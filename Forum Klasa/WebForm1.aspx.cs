using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Forum_Klasa
{
    public partial class WebForm1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) OsveziSve();
        }

        private void OsveziSve()
        {
            gvKategorije.DataSource = Konekcija.PreuzmiPodatke("Vrati_Kategorije", null);
            gvKategorije.DataBind();

            ddlKategorije.DataSource = Konekcija.PreuzmiPodatke("Vrati_Kategorije", null);
            ddlKategorije.DataBind();
            ddlKategorije.Items.Insert(0, new ListItem("-- Odaberi --", "0"));
        }

        protected void btnDodajKor_Click(object sender, EventArgs e)
        {
            SqlParameter[] p = { new SqlParameter("@email", txtEmail.Text), new SqlParameter("@lozinka", txtLozinka.Text), new SqlParameter("@ime", txtIme.Text) };
            Konekcija.IzvrsiProceduru("Unos_Korisnika", p);
            lblStatus.Text = "Korisnik obrađen.";
        }

        protected void btnIzmeniKor_Click(object sender, EventArgs e)
        {
            SqlParameter[] p = { new SqlParameter("@email", txtEmail.Text), new SqlParameter("@lozinka", txtLozinka.Text) };
            Konekcija.IzvrsiProceduru("Korisnik_Izmena", p);
            lblStatus.Text = "Lozinka izmenjena.";
        }

        protected void btnObrisiKor_Click(object sender, EventArgs e)
        {
            SqlParameter[] p = { new SqlParameter("@email", txtEmail.Text) };
            Konekcija.IzvrsiProceduru("Korisnik_Brisanje", p);
            lblStatus.Text = "Korisnik obrisan.";
        }

        protected void btnDodajKat_Click(object sender, EventArgs e)
        {
            SqlParameter[] p = { new SqlParameter("@ime", txtKatIme.Text), new SqlParameter("@opis", txtKatOpis.Text) };
            Konekcija.IzvrsiProceduru("Kategorija_Kreiranje", p);
            OsveziSve();
        }

        protected void btnObrisiKat_Click(object sender, EventArgs e)
        {
            SqlParameter[] p = { new SqlParameter("@ime", txtKatIme.Text) };
            Konekcija.IzvrsiProceduru("Kategorija_Brisanje", p);
            OsveziSve();
        }


        protected void btnPostaviObjavu_Click(object sender, EventArgs e)
        {
            SqlParameter[] p = {
            new SqlParameter("@korisnik_id", txtObjavaKorId.Text),
            new SqlParameter("@odgovor_id", txtOdgovorId.Text),
            new SqlParameter("@kategorija_id", txtObjavaKatId.Text),
            new SqlParameter("@ime", txtObjavaNaslov.Text),
            new SqlParameter("@sadrzaj", txtObjavaSadrzaj.Text)
        };
            Konekcija.IzvrsiProceduru("Objava_Postavljanje", p);
            lblStatus.Text = "Objava postavljena.";
        }

        protected void ddlKategorije_SelectedIndexChanged(object sender, EventArgs e)
        {
            SqlParameter[] p = { new SqlParameter("@kategorija_id", ddlKategorije.SelectedValue) };
            gvObjave.DataSource = Konekcija.PreuzmiPodatke("Vrati_Objave_Iz_Kategorije", p);
            gvObjave.DataBind();
        }

        protected void gvObjave_RowCommand(object sender, GridViewCommandEventArgs e)
        {

            int id = Convert.ToInt32(e.CommandArgument);
            SqlParameter[] p = { new SqlParameter("@objava_id", id) };

            if (e.CommandName == "Vidi")
            {

                DataTable dtOdgovori = Konekcija.PreuzmiPodatke("Vrati_Odgovore_Na_Objavu", p);

                gvOdgovori.DataSource = dtOdgovori;
                gvOdgovori.DataBind();


                pnlOdgovori.Visible = true;
                lblStatus.Text = "Prikazani odgovori za objavu ID: " + id;
            }
            else if (e.CommandName == "Obrisi")
            {
                Konekcija.IzvrsiProceduru("Objava_Brisanje", p);

                lblStatus.Text = "Objava ID: " + id + " je obrisana.";


                OsveziObjave();
            }
        }
        protected void gvOdgovori_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ObrisiOdgovor")
            {
                int id = Convert.ToInt32(e.CommandArgument);
                SqlParameter[] p = { new SqlParameter("@objava_id", id) };

                
                Konekcija.IzvrsiProceduru("Objava_Brisanje", p);

                lblStatus.Text = "Odgovor ID: " + id + " je trajno uklonjen.";

                pnlOdgovori.Visible = false; 
                OsveziObjave(); 
            }
        }

        private void OsveziObjave()
        {
            if (ddlKategorije.SelectedValue != "0")
            {
                SqlParameter[] p = { new SqlParameter("@kategorija_id", ddlKategorije.SelectedValue) };
                gvObjave.DataSource = Konekcija.PreuzmiPodatke("Vrati_Objave_Iz_Kategorije", p);
                gvObjave.DataBind();
            }
        }
        protected void btnZatvoriOdgovore_Click(object sender, EventArgs e)
        {
            pnlOdgovori.Visible = false;
        }

        protected void btnGlasaj_Click(object sender, EventArgs e)
        {
            SqlParameter[] p = {
            new SqlParameter("@objava_id", txtGlasObjavaId.Text),
            new SqlParameter("@korisnik_id", txtGlasKorId.Text),
            new SqlParameter("@vrednost", txtGlasVrednost.Text)
        };
            Konekcija.IzvrsiProceduru("Glas_Dodavanje", p);
        }

        protected void btnObrisiGlas_Click(object sender, EventArgs e)
        {
            SqlParameter[] p = {
            new SqlParameter("@objava_id", txtGlasObjavaId.Text),
            new SqlParameter("@korisnik_id", txtGlasKorId.Text)
        };
            Konekcija.IzvrsiProceduru("Glas_Brisanje", p);
        }
    }
}