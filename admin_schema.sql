-- Admin Panel Database Extensions

-- 1. Add admin role to profiles
alter table public.profiles add column if not exists is_admin boolean default false;

-- 2. System Statistics View
create or replace view public.system_stats as
select
  (select count(*) from public.profiles) as total_users,
  (select count(*) from public.accounts) as total_accounts,
  (select sum(balance) from public.accounts) as total_supply,
  (select count(*) from public.transactions where created_at > now() - interval '24 hours') as transactions_24h,
  (select count(*) from public.transactions where created_at > now() - interval '7 days') as transactions_7d,
  (select count(*) from public.transactions where created_at > now() - interval '30 days') as transactions_30d;

-- 3. Mint Funds Function (Admin Only)
create or replace function mint_funds(
  target_account_id uuid,
  mint_amount decimal,
  reason text default 'Admin minting'
)
returns jsonb
language plpgsql
security definer
as $$
declare
  admin_check boolean;
  transaction_id uuid;
begin
  -- Check if caller is admin
  select is_admin into admin_check
  from public.profiles
  where id = auth.uid();

  if not admin_check then
    return jsonb_build_object('success', false, 'error', 'Unauthorized: Admin access required');
  end if;

  -- Check if target account exists
  if not exists(select 1 from public.accounts where id = target_account_id) then
    return jsonb_build_object('success', false, 'error', 'Target account not found');
  end if;

  -- Add funds to account
  update public.accounts
  set balance = balance + mint_amount
  where id = target_account_id;

  -- Record transaction (sender_id is null for minting)
  insert into public.transactions (sender_id, receiver_id, amount, status, metadata)
  values (null, target_account_id, mint_amount, 'completed', jsonb_build_object('type', 'mint', 'reason', reason))
  returning id into transaction_id;

  return jsonb_build_object(
    'success', true,
    'transaction_id', transaction_id,
    'message', 'Funds minted successfully'
  );
end;
$$;

-- 4. Burn Funds Function (Admin Only)
create or replace function burn_funds(
  target_account_id uuid,
  burn_amount decimal,
  reason text default 'Admin burning'
)
returns jsonb
language plpgsql
security definer
as $$
declare
  admin_check boolean;
  current_balance decimal;
  transaction_id uuid;
begin
  -- Check if caller is admin
  select is_admin into admin_check
  from public.profiles
  where id = auth.uid();

  if not admin_check then
    return jsonb_build_object('success', false, 'error', 'Unauthorized: Admin access required');
  end if;

  -- Get current balance
  select balance into current_balance
  from public.accounts
  where id = target_account_id;

  if current_balance is null then
    return jsonb_build_object('success', false, 'error', 'Target account not found');
  end if;

  if current_balance < burn_amount then
    return jsonb_build_object('success', false, 'error', 'Insufficient balance to burn');
  end if;

  -- Remove funds from account
  update public.accounts
  set balance = balance - burn_amount
  where id = target_account_id;

  -- Record transaction (receiver_id is null for burning)
  insert into public.transactions (sender_id, receiver_id, amount, status, metadata)
  values (target_account_id, null, burn_amount, 'completed', jsonb_build_object('type', 'burn', 'reason', reason))
  returning id into transaction_id;

  return jsonb_build_object(
    'success', true,
    'transaction_id', transaction_id,
    'message', 'Funds burned successfully'
  );
end;
$$;

-- 5. Freeze/Unfreeze Account Function (Admin Only)
create or replace function toggle_account_freeze(
  target_account_id uuid,
  freeze_status boolean
)
returns jsonb
language plpgsql
security definer
as $$
declare
  admin_check boolean;
begin
  -- Check if caller is admin
  select is_admin into admin_check
  from public.profiles
  where id = auth.uid();

  if not admin_check then
    return jsonb_build_object('success', false, 'error', 'Unauthorized: Admin access required');
  end if;

  -- Check if account exists
  if not exists(select 1 from public.accounts where id = target_account_id) then
    return jsonb_build_object('success', false, 'error', 'Account not found');
  end if;

  -- Update freeze status
  update public.accounts
  set is_frozen = freeze_status
  where id = target_account_id;

  return jsonb_build_object(
    'success', true,
    'message', case when freeze_status then 'Account frozen' else 'Account unfrozen' end
  );
end;
$$;

-- 6. Admin-only policies for system_stats view
create policy "Admins can view system stats"
  on public.profiles for select
  using (is_admin = true);
