-- 1️⃣ Create the notes table with title
create table if not exists notes (
    id bigint generated always as identity primary key,
    title text not null,
    body text not null,
    created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 2️⃣ Enable Row Level Security (RLS)
alter table notes enable row level security;

-- 3️⃣ Allow anyone (anon key) to perform CRUD for testing
create policy "Allow read for all"
on notes for select
using (true);

create policy "Allow insert for all"
on notes for insert
with check (true);

create policy "Allow update for all"
on notes for update
using (true);

create policy "Allow delete for all"
on notes for delete
using (true);
