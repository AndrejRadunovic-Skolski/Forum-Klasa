using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using Forum_Klasa;

namespace Forum_Klasa
{
    public partial class Default : Page
    {
        protected int selectedKatId = 0;
        protected DataTable dtKategorije;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["korisnik_id"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            litIme.Text = Session["ime"]?.ToString();
            int dozvole = Session["dozvole"] != null ? (int)Session["dozvole"] : 0;
            lnkAdmin.Visible = dozvole >= 1;

            if (!IsPostBack)
            {
                if (Request.QueryString["kat"] != null)
                    int.TryParse(Request.QueryString["kat"], out selectedKatId);

                LoadKategorije();
                LoadObjave();
            }
        }

        private void LoadKategorije()
        {
            dtKategorije = Konekcija.VratiSveKategorije();
            rptKategorije.DataSource = dtKategorije;
            rptKategorije.DataBind();
        }

        private void LoadObjave()
        {
            DataTable dt;

            if (selectedKatId > 0)
            {

                if (dtKategorije == null) dtKategorije = Konekcija.VratiSveKategorije();
                DataRow[] rows = dtKategorije.Select("kategorija_id = " + selectedKatId);
                if (rows.Length > 0)
                {
                    litKatIme.Text = rows[0]["ime"].ToString();
                    litKatOpis.Text = rows[0]["opis"].ToString();
                }
                hfKatIdForPost.Value = selectedKatId.ToString();
                lnkNovaObjava.NavigateUrl = "#";

                dt = Konekcija.VratiObjaveKategorije(selectedKatId);
            }
            else
            {
                litKatIme.Text = "Sve objave";
                litKatOpis.Text = "";
                lnkNovaObjava.Visible = false; 
                dt = Konekcija.PreuzmiPodatkeSQL(
                    "SELECT o.*, k.ime as autor_ime FROM Objava o LEFT JOIN Korisnik k ON o.korisnik_id=k.korisnik_id WHERE o.glavna=1 ORDER BY o.datum_objave DESC",
                    null);
            }

            if (selectedKatId > 0)
            {

                dt = Konekcija.PreuzmiPodatkeSQL(
                    "SELECT o.*, k.ime as autor_ime FROM Objava o LEFT JOIN Korisnik k ON o.korisnik_id=k.korisnik_id WHERE o.kategorija_id=@kid AND o.glavna=1 ORDER BY o.datum_objave DESC",
                    new SqlParameter[] { new SqlParameter("@kid", selectedKatId) });
            }

            rptObjave.DataSource = dt;
            rptObjave.DataBind();

            pnlEmpty.Visible = dt.Rows.Count == 0;
        }

        protected void rptKategorije_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem) return;
            DataRowView row = (DataRowView)e.Item.DataItem;
            int katId = (int)row["kategorija_id"];

            HyperLink lnk = (HyperLink)e.Item.FindControl("lnkKat");
            lnk.NavigateUrl = "Default.aspx?kat=" + katId;
            if (katId == selectedKatId) lnk.CssClass += " active";

            HtmlGenericControl spn = (HtmlGenericControl)e.Item.FindControl("spnCount");
            spn.InnerText = Konekcija.BrojOdgovora(katId).ToString(); // reuse count helper
        }

        protected void rptObjave_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem) return;
            DataRowView row = (DataRowView)e.Item.DataItem;
            int objavaId = (int)row["objava_id"];

            HyperLink lnk = (HyperLink)e.Item.FindControl("lnkObjava");
            lnk.NavigateUrl = "Objava.aspx?id=" + objavaId;

            HtmlGenericControl spnVotes = (HtmlGenericControl)e.Item.FindControl("spnVotes");
            spnVotes.InnerText = Konekcija.BrojGlasova(objavaId).ToString();

            HtmlGenericControl spnAutor = (HtmlGenericControl)e.Item.FindControl("spnAutor");
            spnAutor.InnerText = row.Row.Table.Columns.Contains("autor_ime") ? row["autor_ime"].ToString() : "?";

            HtmlGenericControl spnOdg = (HtmlGenericControl)e.Item.FindControl("spnOdg");
            int odg = Konekcija.BrojOdgovora(objavaId);
            spnOdg.InnerText = odg + " odgovora";
        }

        protected void btnOdjava_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("Login.aspx");
        }

        protected void btnPostuj_Click(object sender, EventArgs e)
        {
            string naslov = txtNaslov.Text.Trim();
            string sadrzaj = txtSadrzaj.Text.Trim();
            string katId = hfKatIdForPost.Value;
            string korId = Session["korisnik_id"].ToString();

            if (!string.IsNullOrEmpty(naslov) && !string.IsNullOrEmpty(sadrzaj) && !string.IsNullOrEmpty(katId))
            {
                Konekcija.ObjavaDodaj(korId, "0", katId, naslov, sadrzaj);
                txtNaslov.Text = "";
                txtSadrzaj.Text = "";
                Response.Redirect("Default.aspx?kat=" + katId);
            }
            else
            {
                hfShowModal.Value = "1";
            }
        }
    }
}
