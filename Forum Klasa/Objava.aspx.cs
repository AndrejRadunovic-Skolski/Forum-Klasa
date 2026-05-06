using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using Forum_Klasa;

namespace Forum_Klasa
{
    public partial class Objava : Page
    {
        private int objavaId;
        private int korId;
        private int dozvole;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["korisnik_id"] == null) { Response.Redirect("Login.aspx"); return; }

            korId = (int)Session["korisnik_id"];
            dozvole = Session["dozvole"] != null ? (int)Session["dozvole"] : 0;
            litIme.Text = Session["ime"]?.ToString();
            lnkAdmin.Visible = dozvole >= 1;

            if (!int.TryParse(Request.QueryString["id"], out objavaId))
            {
                Response.Redirect("Default.aspx");
                return;
            }
            hfObjavaId.Value = objavaId.ToString();

            if (!IsPostBack)
                LoadPage();
        }

        private void LoadPage()
        {

            DataTable dt = Konekcija.PreuzmiPodatkeSQL(
                @"SELECT o.*, k.ime as autor_ime, o.kategorija_id
                  FROM Objava o
                  LEFT JOIN Korisnik k ON o.korisnik_id = k.korisnik_id
                  WHERE o.objava_id = @id",
                new SqlParameter[] { new SqlParameter("@id", objavaId) });

            if (dt.Rows.Count == 0) { Response.Redirect("Default.aspx"); return; }

            DataRow r = dt.Rows[0];
            litNaslov.Text = Server.HtmlEncode(r["naslov"].ToString());
            litAutor.Text = Server.HtmlEncode(r["autor_ime"].ToString());
            litDatum.Text = Convert.ToDateTime(r["datum_objave"]).ToString("dd.MM.yyyy HH:mm");
            litSadrzaj.Text = Server.HtmlEncode(r["sadrzaj"].ToString());
            hfKatId.Value = r["kategorija_id"].ToString();

            litVotes.Text = Konekcija.BrojGlasova(objavaId).ToString();


            int postOwnerId = r["korisnik_id"] == DBNull.Value ? -1 : (int)r["korisnik_id"];
            btnDelete.Visible = (korId == postOwnerId || dozvole >= 1);

            LoadReplies();
        }

        private void LoadReplies()
        {
            DataTable dt = Konekcija.PreuzmiPodatkeSQL(
                @"SELECT o.*, k.ime as autor_ime
                  FROM Objava o
                  LEFT JOIN Korisnik k ON o.korisnik_id = k.korisnik_id
                  WHERE o.odgovor_id = @id
                  ORDER BY o.datum_objave ASC",
                new SqlParameter[] { new SqlParameter("@id", objavaId) });

            litOdgCount.Text = dt.Rows.Count.ToString();
            rptOdgovori.DataSource = dt;
            rptOdgovori.DataBind();
            pnlNoReplies.Visible = dt.Rows.Count == 0;
        }

        protected void rptOdgovori_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem) return;
            DataRowView row = (DataRowView)e.Item.DataItem;
            int id = (int)row["objava_id"];

            HtmlGenericControl spnAutor = (HtmlGenericControl)e.Item.FindControl("spnAutorOdg");
            spnAutor.InnerText = row["autor_ime"].ToString();

            HtmlGenericControl spnVotes = (HtmlGenericControl)e.Item.FindControl("spnOdgVotes");
            spnVotes.InnerText = Konekcija.BrojGlasova(id).ToString();

            int postOwnerId = row["korisnik_id"] == DBNull.Value ? -1 : (int)row["korisnik_id"];
            Button btnDel = (Button)e.Item.FindControl("btnOdgDel");
            btnDel.Visible = (korId == postOwnerId || dozvole >= 1);
        }

        protected void rptOdgovori_Command(object sender, CommandEventArgs e)
        {
            int targetId = int.Parse(e.CommandArgument.ToString());
            string korIdStr = korId.ToString();

            if (e.CommandName == "upvote")
                Konekcija.Glasaj(targetId.ToString(), korIdStr, "1");
            else if (e.CommandName == "downvote")
                Konekcija.Glasaj(targetId.ToString(), korIdStr, "-1");
            else if (e.CommandName == "delete")
                Konekcija.ObjavaObrisi(targetId);

            Response.Redirect("Objava.aspx?id=" + objavaId);
        }

        protected void btnUpvote_Click(object sender, EventArgs e)
        {
            Konekcija.Glasaj(objavaId.ToString(), korId.ToString(), "1");
            Response.Redirect("Objava.aspx?id=" + objavaId);
        }

        protected void btnDownvote_Click(object sender, EventArgs e)
        {
            Konekcija.Glasaj(objavaId.ToString(), korId.ToString(), "-1");
            Response.Redirect("Objava.aspx?id=" + objavaId);
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            string katId = hfKatId.Value;
            Konekcija.ObjavaObrisi(objavaId);
            Response.Redirect("Default.aspx?kat=" + katId);
        }

        protected void btnOdgovori_Click(object sender, EventArgs e)
        {
            string sadrzaj = txtOdgovor.Text.Trim();
            if (string.IsNullOrEmpty(sadrzaj)) return;

            string katId = hfKatId.Value;
            Konekcija.ObjavaDodaj(korId.ToString(), objavaId.ToString(), katId, "", sadrzaj);
            txtOdgovor.Text = "";
            Response.Redirect("Objava.aspx?id=" + objavaId);
        }

        protected void btnOdjava_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("Login.aspx");
        }
    }
}
