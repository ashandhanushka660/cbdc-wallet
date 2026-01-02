-- Extension: Credit & Lending (Sri Lanka Pilot Focus)

-- 1. AI Credit Scoring Table
create table public.credit_scores (
  id uuid default gen_random_uuid() primary key,
  user_id uuid not null references public.profiles(id) on delete cascade,
  score integer check (score >= 300 and score <= 850),
  risk_tier text, -- Low, Medium, High
  last_ai_assessment timestamptz default now(),
  factors jsonb, -- AI factors: repayment history, account age, transaction frequency
  unique(user_id)
);

-- 2. Loans Table
create table public.loans (
  id uuid default gen_random_uuid() primary key,
  user_id uuid not null references public.profiles(id) on delete cascade,
  principal_amount decimal(12, 2) not null,
  interest_rate decimal(5, 2) not null,
  term_months integer not null,
  status text default 'pending', -- pending, active, repaid, defaulted
  remaining_balance decimal(12, 2) not null,
  monthly_repayment decimal(12, 2) not null,
  next_payment_date timestamptz,
  created_at timestamptz default now()
);

-- 3. Open Banking API Logs (for Ecosystem Research)
create table public.api_integrations (
  id uuid default gen_random_uuid() primary key,
  partner_name text not null,
  access_scope text[], -- ['balance', 'transactions', 'credit_info']
  is_active boolean default true,
  created_at timestamptz default now()
);

-- 4. Function to Calculate AI Credit Score (Simulation)
create or replace function public.calculate_user_credit_score(target_user_id uuid)
returns void as $$
declare
    tx_count integer;
    avg_balance decimal;
    new_score integer;
begin
    -- 1. Simple heuristic simulation of an AI model
    select count(*) into tx_count from public.transactions t 
    join public.accounts a on (t.sender_id = a.id or t.receiver_id = a.id)
    where a.user_id = target_user_id;

    select balance into avg_balance from public.accounts where user_id = target_user_id;

    -- 2. Logic: More transactions + Higher balance = Better score
    new_score := 500 + (tx_count * 5) + (avg_balance / 100);
    if new_score > 850 then new_score := 850; end if;

    insert into public.credit_scores (user_id, score, risk_tier, last_ai_assessment)
    values (
        target_user_id, 
        new_score, 
        case 
            when new_score > 700 then 'Low'
            when new_score > 600 then 'Medium'
            else 'High'
        end,
        now()
    )
    on conflict (user_id) do update 
    set score = excluded.score, 
        risk_tier = excluded.risk_tier,
        last_ai_assessment = now();
end;
$$ language plpgsql security definer;

-- 5. Prototype Feature: Auto-Credit Account on Loan Approval
create or replace function public.handle_loan_disbursement()
returns trigger as $$
begin
    if (new.status = 'active' and (old.status = 'pending' or old.status is null)) then
        update public.accounts 
        set balance = balance + new.principal_amount
        where user_id = new.user_id;
        
        -- Log as a special mint transaction
        insert into public.transactions (receiver_id, amount, status, metadata)
        select id, new.principal_amount, 'completed', jsonb_build_object('type', 'loan_disbursement', 'loan_id', new.id)
        from public.accounts where user_id = new.user_id;
    end if;
    return new;
end;
$$ language plpgsql security definer;

create trigger on_loan_activated
    after insert or update on public.loans
    for each row execute procedure public.handle_loan_disbursement();
