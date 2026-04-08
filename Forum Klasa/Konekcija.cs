using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

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
}