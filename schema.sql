-- Ruang Mengajar IX — Supabase schema
-- Jalankan seluruh script di Supabase Dashboard > SQL Editor.
-- Buat akun guru melalui Authentication > Users. Gunakan anon/publishable key pada frontend; JANGAN pernah menaruh service_role key di website.

create extension if not exists pgcrypto;

create table if not exists public.classes (
 id uuid primary key default gen_random_uuid(),
 name text not null unique,
 created_at timestamptz not null default now()
);
create table if not exists public.students (
 id uuid primary key default gen_random_uuid(),
 class_id uuid not null references public.classes(id),
 student_code text,
 name text not null,
 active boolean not null default true,
 created_at timestamptz not null default now()
);
create unique index if not exists students_code_unique_nonempty on public.students(student_code) where student_code is not null and student_code <> '';
create table if not exists public.lessons (
 id uuid primary key default gen_random_uuid(),
 class_id uuid not null references public.classes(id),
 lesson_date date not null,
 topic text not null,
 objective text,
 notes text,
 meeting_no text,
 created_by uuid references auth.users(id),
 created_at timestamptz not null default now()
);
create table if not exists public.assessments (
 id uuid primary key default gen_random_uuid(),
 class_id uuid not null references public.classes(id),
 title text not null,
 assessment_type text not null default 'Tugas',
 assessment_date date not null,
 created_by uuid references auth.users(id),
 created_at timestamptz not null default now()
);
create table if not exists public.grades (
 id uuid primary key default gen_random_uuid(),
 assessment_id uuid not null references public.assessments(id) on delete cascade,
 student_id uuid not null references public.students(id),
 score numeric(5,2) check(score is null or (score >= 0 and score <= 100)),
 notes text,
 graded_by uuid references auth.users(id),
 created_at timestamptz not null default now(),
 unique(assessment_id,student_id)
);
create table if not exists public.attendance_sessions (
 id uuid primary key default gen_random_uuid(),
 class_id uuid not null references public.classes(id),
 session_date date not null,
 meeting_label text,
 created_by uuid references auth.users(id),
 created_at timestamptz not null default now(),
 unique(class_id,session_date)
);
create table if not exists public.attendance_records (
 id uuid primary key default gen_random_uuid(),
 session_id uuid not null references public.attendance_sessions(id) on delete cascade,
 student_id uuid not null references public.students(id),
 status text not null check(status in ('Hadir','Sakit','Izin','Alpa')),
 notes text,
 marked_by uuid references auth.users(id),
 created_at timestamptz not null default now(),
 unique(session_id,student_id)
);

alter table public.classes enable row level security;
alter table public.students enable row level security;
alter table public.lessons enable row level security;
alter table public.assessments enable row level security;
alter table public.grades enable row level security;
alter table public.attendance_sessions enable row level security;
alter table public.attendance_records enable row level security;

-- Semua pengguna yang berhasil login dianggap sebagai guru tepercaya.
-- Untuk penggunaan sekolah dengan peran berbeda, perluasan ke tabel roles dapat ditambahkan.
do $$
declare t text;
begin
 foreach t in array array['classes','students','lessons','assessments','grades','attendance_sessions','attendance_records']
 loop
  execute format('drop policy if exists "authenticated full access" on public.%I',t);
  execute format('create policy "authenticated full access" on public.%I for all to authenticated using (true) with check (true)',t);
 end loop;
end $$;

-- Isi 11 kelas melalui impor Excel (nama sheet menjadi nama kelas).
-- Catatan: kolom student_code harus unik bila terisi. Bila sekolah memakai NIS/NISN yang sama
-- di kelas berbeda, pastikan memang identitas siswa yang sama; sesuaikan indeks unik jika perlu.
