using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace Forum_Klasa
{
    public class Konekcija
    {
        private static string connString = ConfigurationManager.ConnectionStrings["ForumConnectionString"].ConnectionString;

        public static int IzvrsiProceduru(string imeProcedure, SqlParameter[] parametri)
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                using (SqlCommand cmd = new SqlCommand(imeProcedure, conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    if (parametri != null) cmd.Parameters.AddRange(parametri);

                    SqlParameter ret = new SqlParameter("ReturnValue", SqlDbType.Int);
                    ret.Direction = ParameterDirection.ReturnValue;
                    cmd.Parameters.Add(ret);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                    return (int)ret.Value;
                }
            }
        }

        public static DataTable PreuzmiPodatke(string imeProcedure, SqlParameter[] parametri)
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                using (SqlCommand cmd = new SqlCommand(imeProcedure, conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    if (parametri != null) cmd.Parameters.AddRange(parametri);
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    return dt;
                }
            }
        }

        public static void KorisnikUnos(string email, string lozinka, string ime)
        {
            SqlParameter[] p = { new SqlParameter("@email", email), new SqlParameter("@lozinka", lozinka), new SqlParameter("@ime", ime) };
            IzvrsiProceduru("Unos_Korisnika", p);
        }

        public static void KorisnikIzmena(string email, string lozinka)
        {
            SqlParameter[] p = { new SqlParameter("@email", email), new SqlParameter("@lozinka", lozinka) };
            IzvrsiProceduru("Korisnik_Izmena", p);
        }

        public static void KorisnikBrisanje(string email)
        {
            SqlParameter[] p = { new SqlParameter("@email", email) };
            IzvrsiProceduru("Korisnik_Brisanje", p);
        }

        public static DataTable VratiSveKategorije()
        {
            return PreuzmiPodatke("Vrati_Kategorije", null);
        }

        public static void KategorijaDodaj(string ime, string opis)
        {
            SqlParameter[] p = { new SqlParameter("@ime", ime), new SqlParameter("@opis", opis) };
            IzvrsiProceduru("Kategorija_Kreiranje", p);
        }

        public static void KategorijaObrisi(string ime)
        {
            SqlParameter[] p = { new SqlParameter("@ime", ime) };
            IzvrsiProceduru("Kategorija_Brisanje", p);
        }

        public static DataTable VratiObjaveKategorije(int katId)
        {
            SqlParameter[] p = { new SqlParameter("@kategorija_id", katId) };
            return PreuzmiPodatke("Vrati_Objave_Iz_Kategorije", p);
        }

        public static void ObjavaDodaj(string korId, string odgId, string katId, string naslov, string sadrzaj)
        {
            SqlParameter[] p = {
            new SqlParameter("@korisnik_id", korId),
            new SqlParameter("@odgovor_id", odgId),
            new SqlParameter("@kategorija_id", katId),
            new SqlParameter("@ime", naslov),
            new SqlParameter("@sadrzaj", sadrzaj)
        };
            IzvrsiProceduru("Objava_Postavljanje", p);
        }

        public static void ObjavaObrisi(int id)
        {
            SqlParameter[] p = { new SqlParameter("@objava_id", id) };
            IzvrsiProceduru("Objava_Brisanje", p);
        }

        public static DataTable VratiOdgovore(int objavaId)
        {
            SqlParameter[] p = { new SqlParameter("@objava_id", objavaId) };
            return PreuzmiPodatke("Vrati_Odgovore_Na_Objavu", p);
        }

        public static void Glasaj(string objavaId, string korId, string vrednost)
        {
            SqlParameter[] p = {
                new SqlParameter("@objava_id", objavaId),
                new SqlParameter("@korisnik_id", korId),
                new SqlParameter("@vrednost", vrednost)
            };
            IzvrsiProceduru("Glas_Dodavanje", p);
        }

        public static void GlasObrisi(string objavaId, string korId)
        {
            SqlParameter[] p = {
                new SqlParameter("@objava_id", objavaId),
                new SqlParameter("@korisnik_id", korId)
            };
            IzvrsiProceduru("Glas_Brisanje", p);
        }

        public static void OdgovorObrisi(int id)
        {
            SqlParameter[] p = { new SqlParameter("@objava_id", id) };
            IzvrsiProceduru("Objava_Brisanje", p);
        }
    }

}