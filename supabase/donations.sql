-- 후원 내역 분석 대시보드용 테이블
-- Supabase SQL Editor에서 한 번 실행하세요.

create table if not exists public.donations (
  id          bigint generated always as identity primary key,
  donated_at  timestamp   not null,  -- 한국 시간 그대로 (예: 2026-08-25 16:47)
  donor       text        not null,  -- 도네이터
  grade       text,                  -- 등급
  type        text,                  -- 유형 (텍스트, 시그니처, 투네톡 …)
  amount      integer     not null check (amount > 0),  -- 금액
  message     text,                  -- 내용
  source      text                   -- 출처
);

create index if not exists donations_donated_at_idx on public.donations (donated_at);

-- 대시보드는 브라우저에서 anon 키로 읽어요. 읽기만 허용합니다.
alter table public.donations enable row level security;

drop policy if exists "donations: anon read" on public.donations;
create policy "donations: anon read"
  on public.donations for select
  to anon
  using (true);

-- 주의: 이 정책이면 anon 키를 가진 누구나 이 테이블을 읽을 수 있어요.
-- 실제 후원자 정보를 넣는다면 anon 키를 공개 페이지에 넣지 마세요.
