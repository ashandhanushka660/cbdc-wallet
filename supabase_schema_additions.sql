-- 6. Row Level Security Policies
-- Profiles: Users can only see their own profile
create policy "Users can view own profile"
  on public.profiles for select
  using (auth.uid() = id);

create policy "Users can update own profile"
  on public.profiles for update
  using (auth.uid() = id);

-- Accounts: Users can only see their own accounts
create policy "Users can view own accounts"
  on public.accounts for select
  using (auth.uid() = user_id);

-- Transactions: Users can see transactions they're involved in
create policy "Users can view own transactions"
  on public.transactions for select
  using (
    auth.uid() IN (
      SELECT user_id FROM public.accounts WHERE id = sender_id
      UNION
      SELECT user_id FROM public.accounts WHERE id = receiver_id
    )
  );

-- 7. Transfer Funds Function (Secure & Atomic)
create or replace function transfer_funds(
  receiver_account_id uuid,
  transfer_amount decimal
)
returns jsonb
language plpgsql
security definer
as $$
declare
  sender_account_id uuid;
  sender_balance decimal;
  receiver_exists boolean;
  transaction_id uuid;
begin
  -- Get sender's account
  select id, balance into sender_account_id, sender_balance
  from public.accounts
  where user_id = auth.uid()
  limit 1;

  if sender_account_id is null then
    return jsonb_build_object('success', false, 'error', 'Sender account not found');
  end if;

  -- Check if sender has sufficient balance
  if sender_balance < transfer_amount then
    return jsonb_build_object('success', false, 'error', 'Insufficient balance');
  end if;

  -- Check if receiver account exists
  select exists(select 1 from public.accounts where id = receiver_account_id) into receiver_exists;
  
  if not receiver_exists then
    return jsonb_build_object('success', false, 'error', 'Receiver account not found');
  end if;

  -- Check if trying to send to self
  if sender_account_id = receiver_account_id then
    return jsonb_build_object('success', false, 'error', 'Cannot transfer to yourself');
  end if;

  -- Perform the transfer (atomic)
  update public.accounts
  set balance = balance - transfer_amount
  where id = sender_account_id;

  update public.accounts
  set balance = balance + transfer_amount
  where id = receiver_account_id;

  -- Record the transaction
  insert into public.transactions (sender_id, receiver_id, amount, status)
  values (sender_account_id, receiver_account_id, transfer_amount, 'completed')
  returning id into transaction_id;

  return jsonb_build_object(
    'success', true,
    'transaction_id', transaction_id,
    'message', 'Transfer completed successfully'
  );
end;
$$;
