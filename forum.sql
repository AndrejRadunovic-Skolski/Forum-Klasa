create database Forum
go
use Forum
go


create table Korisnik(
korisnik_id int primary key identity(1,1),
email nvarchar(50),
lozinka nvarchar(50),
ime nvarchar(20),
dozvole int,
)

create table Kategorija(
kategorija_id int primary key identity(1,1),
ime nvarchar(20),
opis text
)

create table Objava(
objava_id int primary key identity(1,1),
korisnik_id int foreign key references korisnik(korisnik_id),
kategorija_id int foreign key references kategorija(kategorija_id),
datum_objave datetime,
glavna bit not null default 1,
odgovor_id int,
naslov nvarchar(50) default 'Bez naslova.',
sadrzaj text
)


create table Glas(
glas_id int primary key identity(1,1),
vrednost int,
korisnik_id int foreign key references korisnik(korisnik_id),
objava_id int foreign key references objava(objava_id),
)
go


create procedure Provera_Korisnika
@email nvarchar(50),
@lozinka nvarchar(100)
as
set LOCK_TIMEOUT 3000;
begin try
if exists(select top 1 email from korisnik where email=@email and lozinka = @lozinka)
begin
return 0
end
return 1
end try
begin catch
return @@error
end catch
go


create procedure Unos_Korisnika
@email nvarchar(50),
@lozinka nvarchar(100),
@ime nvarchar(20)
as
set lock_timeout 3000;
begin try
if exists(select top 1 email from korisnik where (email=@email) or (ime=@ime))
return 1
else
insert into korisnik(email,lozinka,ime)
values(@email, @lozinka,@ime)
return 0
end try
begin catch
return @@error
end catch
go


create procedure Korisnik_Brisanje
@email nvarchar(100)
as
set lock_timeout 3000;
begin try
delete from korisnik where email = @email
return 0
end try
begin catch
return @@error
end catch
go


create procedure Korisnik_Izmena
@email nvarchar(50),
@lozinka nvarchar(100)
as
set lock_timeout 3000;
begin try
if exists(select top 1 email from korisnik where email = @email)
begin
update korisnik set lozinka = @lozinka where email=@email
return 0
end
return 1
end try
begin catch
return @@error
end catch
go

create procedure Objava_Postavljanje
@korisnik_id int,
@odgovor_id int,
@kategorija_id int,
@ime nvarchar(200),
@sadrzaj text
as
set lock_timeout 3000;
begin try
if(@odgovor_id <> 0 and @odgovor_id is not null)
begin
	insert into objava(korisnik_id,odgovor_id,kategorija_id,glavna,datum_objave,sadrzaj) values(@korisnik_id, @odgovor_id, @kategorija_id, 0, GETDATE(), @sadrzaj)
end
else
begin
	insert into objava(korisnik_id,odgovor_id,kategorija_id,glavna,datum_objave,sadrzaj,ime) values(@korisnik_id, @odgovor_id, @kategorija_id, 1, GETDATE(), @sadrzaj,@ime)
end
end try
begin catch
return @@error
end catch
go


create procedure Objava_Brisanje
@objava_id int
as
set lock_timeout 3000;
begin try
delete from Objava where @objava_id = objava_id
return 0
end try
begin catch
return @@error
end catch
go


create procedure Kategorija_Kreiranje
@ime nvarchar(20),
@opis text
as
set lock_timeout 3000;
begin try
if exists(select top 1 ime from Kategorija where (ime=@ime))
return 1
else
insert into Kategorija(ime, opis) values(@ime, @opis)
end try
begin catch
return @@error
end catch
go


create procedure Kategorija_Brisanje
@ime nvarchar(200)
as
set lock_timeout 3000;
begin try
delete from Kategorija where ime = @ime
return 0
end try
begin catch
return @@error
end catch
go

create procedure Glas_Dodavanje
@objava_id int,
@korisnik_id int,
@vrednost int
as
set lock_timeout 3000;
begin try
if exists(select top 1 glas_id from Glas where (@objava_id=objava_id) and (@korisnik_id=korisnik_id))
update Glas set vrednost = @vrednost where (@objava_id=objava_id) and (@korisnik_id=korisnik_id)
else
insert into Glas(objava_id, korisnik_id, vrednost) values(@objava_id, @korisnik_id, @vrednost)
end 
try
begin catch
return @@error
end catch
go


create procedure Glas_Brisanje
@objava_id int,
@korisnik_id int
as
set lock_timeout 3000;
begin try
delete from Glas where (@objava_id=objava_id) and (@korisnik_id=korisnik_id)
return 0
end try
begin catch
return @@error
end catch
go

create procedure Objava_Brojanje_Glasova
@objava_id int
as
set lock_timeout 3000;
begin try
select count(glas_id) from glas where @objava_id = glas.objava_id
end try
begin catch
return @@error
end catch
go

create procedure Objava_Brojanje_Odgovora
@objava_id int
as
set lock_timeout 3000;
begin try
select count(objava_id) from Objava where @objava_id = odgovor_id
end try
begin catch
return @@error
end catch
go

create procedure Kategorija_Brojanje_Objava
@kategorija_id int
as
set lock_timeout 3000;
begin try
select count(objava_id) from Objava where @kategorija_id = objava.kategorija_id
end try
begin catch
return @@error
end catch
go


create procedure Vrati_Kategorije
as
begin
select * from Kategorija
end
go


create procedure Vrati_Objave_Iz_Kategorije
@kategorija_id int
as
begin
select * from objava where kategorija_id = @kategorija_id and glavna = 1
end
go


create procedure Vrati_Odgovore_Na_Objavu
@objava_id int
as
begin
select * from objava where odgovor_id = @objava_id
end
go

insert into Korisnik(email, lozinka,ime,dozvole) values('test', 'test', 'test', 1)

insert into Kategorija values('General','Test')
insert into Kategorija values('Testifikacija','Test ali bolji')
select * from glas
