using System;
using System.Data;
using System.Web.UI.WebControls;

namespace Forum_Klasa
{
    public partial class WebForm1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                OsveziSve();
            }
        }

        private void OsveziSve()
        {

            DataTable dt = Konekcija.VratiSveKategorije();

            gvKategorije.DataSource = dt;
            gvKategorije.DataBind();

            ddlKategorije.DataSource = dt;
            ddlKategorije.DataTextField = "ImeKategorije";
            ddlKategorije.DataValueField = "ID";
            ddlKategorije.DataBind();
            ddlKategorije.Items.Insert(0, new ListItem("-- Odaberi --", "0"));
        }

        protected void btnDodajKor_Click(object sender, EventArgs e)
        {
            Konekcija.KorisnikUnos(txtEmail.Text, txtLozinka.Text, txtIme.Text);
            lblStatus.Text = "Korisnik dodat u bazu.";
        }

        protected void btnIzmeniKor_Click(object sender, EventArgs e)
        {
            Konekcija.KorisnikIzmena(txtEmail.Text, txtLozinka.Text);
            lblStatus.Text = "Lozinka uspešno izmenjena.";
        }

        protected void btnObrisiKor_Click(object sender, EventArgs e)
        {
            Konekcija.KorisnikBrisanje(txtEmail.Text);
            lblStatus.Text = "Korisnik je obrisan.";
        }

        protected void btnDodajKat_Click(object sender, EventArgs e)
        {
            Konekcija.KategorijaDodaj(txtKatIme.Text, txtKatOpis.Text);
            OsveziSve();
        }
        protected void btnObrisiKat_Click(object sender, EventArgs e)
        {
            Konekcija.KategorijaObrisi(txtKatIme.Text);
            OsveziSve();
        }


        protected void btnPostaviObjavu_Click(object sender, EventArgs e)
        {
            Konekcija.ObjavaDodaj(txtObjavaKorId.Text, txtOdgovorId.Text, txtObjavaKatId.Text, txtObjavaNaslov.Text, txtObjavaSadrzaj.Text);
            lblStatus.Text = "Objava uspešno postavljena.";
        }

        protected void ddlKategorije_SelectedIndexChanged(object sender, EventArgs e)
        {
            OsveziObjave();
        }

        private void OsveziObjave()
        {
            if (ddlKategorije.SelectedValue != "0")
            {
                int katId = Convert.ToInt32(ddlKategorije.SelectedValue);
                gvObjave.DataSource = Konekcija.VratiObjaveKategorije(katId);
                gvObjave.DataBind();
            }
        }

        protected void gvObjave_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "Vidi")
            {
                gvOdgovori.DataSource = Konekcija.VratiOdgovore(id);
                gvOdgovori.DataBind();
                pnlOdgovori.Visible = true;
            }
            else if (e.CommandName == "Obrisi")
            {
                Konekcija.ObjavaObrisi(id);
                OsveziObjave();
            }
        }
        protected void gvOdgovori_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ObrisiOdgovor")
            {
                int id = Convert.ToInt32(e.CommandArgument);
                Konekcija.OdgovorObrisi(id);

                lblStatus.Text = "Odgovor ID: " + id + " je uklonjen.";
                pnlOdgovori.Visible = false;
                OsveziObjave();
            }
        }

        protected void btnZatvoriOdgovore_Click(object sender, EventArgs e)
        {
            pnlOdgovori.Visible = false;
        }

        protected void btnGlasaj_Click(object sender, EventArgs e)
        {
            Konekcija.Glasaj(txtGlasObjavaId.Text, txtGlasKorId.Text, txtGlasVrednost.Text);
            lblStatus.Text = "Glas uspešan.";
        }

        protected void btnObrisiGlas_Click(object sender, EventArgs e)
        {
            Konekcija.GlasObrisi(txtGlasObjavaId.Text, txtGlasKorId.Text);
            lblStatus.Text = "Glas povučen.";
        }
    }

}