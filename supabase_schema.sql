-- 1. Create Profiles Table (Public User Data)
create table public.profiles (
  id uuid not null references auth.users on delete cascade,
  first_name text,
  last_name text,
  national_id text,
  email text,
  created_at width_bucket,
  
  primary key (id)
);

alter table public.profiles enable row level security;

-- 2. Create Accounts Table (Wallet Balances)
create table public.accounts (
  id uuid not null default gen_random_uuid() primary key,
  user_id uuid not null references public.profiles(id) on delete cascade,
  balance decimal(12, 2) default 0.00,
  currency text default 'CBDC',
  is_frozen boolean default false,
  created_at timestamptz default now()
);

alter table public.accounts enable row level security;

-- 3. Create Transactions Table (Ledger)
create table public.transactions (
  id uuid not null default gen_random_uuid() primary key,
  sender_id uuid references public.accounts(id),
  receiver_id uuid references public.accounts(id),
  amount decimal(12, 2) not null,
  status text default 'pending', -- pending, completed, failed
  metadata jsonb,
  created_at timestamptz default now()
);

alter table public.transactions enable row level security;

-- 4. Triggers to auto-create profile on signup
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (id, email)
  values (new.id, new.email);
  
  -- Also create a default account for them
  insert into public.accounts (user_id, balance)
  values (new.id, 1000.00); -- Give 1000 CBDC airdrop for demo
  
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- 5. Helper Function: Complete Profile (for Register Page)
create or replace function update_profile_details(
  first_name text,
  last_name text,
  national_id text
)
returns void
language plpgsql
security definer
as $$
begin
  update public.profiles
  set first_name = $1, last_name = $2, national_id = $3
  where id = auth.uid();
end;
$$;
