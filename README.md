# 후원 내역 분석

후원 내역을 읽어 핵심 수치, 후원 추이, 도네이터별 기록, 주간 요약을 보여 주는 단일 HTML 페이지입니다.

- `index.html`을 브라우저로 열면 바로 동작합니다. 서버나 빌드가 필요 없습니다.
- 연결 전에는 482건 후원 내역을 익명화한 샘플을 보여 줍니다. 닉네임은 `도네이터01`처럼 바꿨고 내용은 비웠습니다.
- 툴바의 **데이터 연결**에서 Supabase 테이블을 읽거나 CSV 파일을 올릴 수 있습니다.

## Supabase로 연결하기

1. Supabase SQL Editor에서 [`supabase/donations.sql`](supabase/donations.sql)을 실행해 `donations` 테이블과 읽기 정책을 만듭니다.
2. Table Editor → `donations` → **Import data from CSV**로 후원 내역을 넣습니다. 열 이름은 `donated_at, donor, grade, type, amount, message, source`입니다.
3. 대시보드의 **데이터 연결 → Supabase**에 Project URL, anon(publishable) 키, 테이블 이름을 넣고 **연결하고 불러오기**를 누릅니다.

- 연결 정보는 그 브라우저에만 저장되고, 다음에 열면 자동으로 다시 불러옵니다. 툴바의 **새로고침**으로 최신 데이터를 다시 읽습니다.
- 1,000행씩 나눠 모두 읽어 옵니다.
- `donated_at`이 `timestamptz`라면 한국 시간으로 바꿔 보여 줍니다.
- 한글 열 이름(시간, 도네이터, 금액 …)도 그대로 읽습니다.
- service_role·secret 키는 받지 않습니다.

> anon 키로 읽을 수 있는 데이터는 키를 가진 누구나 읽을 수 있습니다. 실제 후원자 정보가 든 테이블의 키를 공개 페이지(`SUPABASE_PRESET`)에 넣지 마세요.

## CSV 형식

| 열 | 필수 | 예 |
|---|---|---|
| 시간 (`donated_at`) | O | `2026-08-19 07:10` |
| 도네이터 (`donor`) | O | 닉네임 |
| 금액 (`amount`) | O | `30800` |
| 등급 · 유형 · 내용 · 출처 | | `VVIP`, `텍스트`, 메시지, `일반` |

UTF-8과 EUC-KR(엑셀에서 저장한 CSV) 모두 읽습니다. 여러 파일을 한 번에 올리면 합쳐서 분석하고, 파일끼리 겹치는 행은 한 번만 셉니다.
