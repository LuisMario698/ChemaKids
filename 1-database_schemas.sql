create table public.invitado (
  id bigint not null,
  nombre character varying(255) not null,
  edad bigint not null,
  nivel bigint not null,
  constraint invitado_pkey primary key (id)
) TABLESPACE pg_default;

create table public.juegos (
  id bigint not null,
  nombre character varying(255) not null,
  descripcion character varying(255) not null,
  constraint juegos_pkey primary key (id)
) TABLESPACE pg_default;

create table public.progreso (
  id bigint not null,
  id_juego bigint not null,
  nivel bigint not null,
  puntaje bigint not null,
  racha_maxima bigint not null,
  id_usuario bigint not null,
  id_invitado bigint not null,
  constraint progreso_pkey primary key (id),
  constraint progreso_id_invitado_foreign foreign KEY (id_invitado) references invitado (id),
  constraint progreso_id_juego_foreign foreign KEY (id_juego) references juegos (id),
  constraint progreso_id_usuario_foreign foreign KEY (id_usuario) references usuario (id)
) TABLESPACE pg_default;

create table public.usuario (
  id bigint not null,
  nombre character varying(255) not null,
  email character varying null,
  nivel bigint not null,
  edad bigint not null,
  auth_user uuid null,
  constraint usuario_pkey primary key (id),
  constraint usuario_auth_user_fkey foreign KEY (auth_user) references auth.users (id)
) TABLESPACE pg_default;