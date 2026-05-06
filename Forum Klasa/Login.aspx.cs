using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using Forum_Klasa;

namespace Forum_Klasa
{
    public partial class Login : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["korisnik_id"] != null)
                Response.Redirect("Default.aspx");
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string email = txtLoginEmail.Text.Trim();
            string lozinka = txtLoginLozinka.Text.Trim();

            if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(lozinka))
            {
                ShowMsg("Popuni sva polja.", false); return;
            }

            SqlParameter[] p = {
                new SqlParameter("@email", email),
                new SqlParameter("@lozinka", lozinka)
            };
            int result = Konekcija.IzvrsiProceduru("Provera_Korisnika", p);

            if (result == 0)
            {
                DataTable user = Konekcija.PreuzmiPodatkeSQL(
                    "SELECT * FROM Korisnik WHERE email=@email",
                    new SqlParameter[] { new SqlParameter("@email", email) });

                if (user != null && user.Rows.Count > 0)
                {
                    DataRow r = user.Rows[0];
                    Session["korisnik_id"] = (int)r["korisnik_id"];
                    Session["ime"] = r["ime"].ToString();
                    Session["email"] = r["email"].ToString();
                    Session["dozvole"] = r["dozvole"] == DBNull.Value ? 0 : (int)r["dozvole"];
                }
                Response.Redirect("Default.aspx");
            }
            else
            {
                ShowMsg("Pogresan email ili lozinka.", false);
            }
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            string ime = txtRegIme.Text.Trim();
            string email = txtRegEmail.Text.Trim();
            string lozinka = txtRegLozinka.Text.Trim();

            if (string.IsNullOrEmpty(ime) || string.IsNullOrEmpty(email) || string.IsNullOrEmpty(lozinka))
            {
                ShowMsg("Popuni sva polja.", false);
                hfActiveTab.Value = "register";
                return;
            }

            SqlParameter[] p = {
                new SqlParameter("@email", email),
                new SqlParameter("@lozinka", lozinka),
                new SqlParameter("@ime", ime)
            };
            int result = Konekcija.IzvrsiProceduru("Unos_Korisnika", p);

            if (result == 0)
            {
                ShowMsg("Registracija uspesna! Prijavi se.", true);
                hfActiveTab.Value = "login";
            }
            else
            {
                ShowMsg("Email ili korisnicko ime vec postoji.", false);
                hfActiveTab.Value = "register";
            }
        }

        private void ShowMsg(string msg, bool success)
        {
            lblMsg.Text = msg;
            lblMsg.CssClass = success ? "msg success" : "msg";
            lblMsg.Visible = true;
        }
    }
}
