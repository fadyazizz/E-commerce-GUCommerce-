using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
namespace team_54
{
    public partial class CustomerRegister : System.Web.UI.Page
    {
        protected void customer_register(object sender, EventArgs e)
        {

            //Get the information of the connection to the database
            string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ToString();

            //create a new connection
            SqlConnection conn = new SqlConnection(connStr);

            /*create a new SQL command which takes as parameters the name of the stored procedure and
             the SQLconnection name*/
            SqlCommand cmd = new SqlCommand("customerRegister", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            //To read the input from the user
            string username = username_register.Text;
            string firstname = firstname_register.Text;
            string lastname = lastname_register.Text;
            string password = password_register.Text;
            string email = email_register.Text;


            //pass parameters to the stored procedure
            cmd.Parameters.Add(new SqlParameter("@username", username));
            cmd.Parameters.Add(new SqlParameter("@first_name", firstname));
            cmd.Parameters.Add(new SqlParameter("@last_name", lastname));
            cmd.Parameters.Add(new SqlParameter("@password", password));
            cmd.Parameters.Add(new SqlParameter("@email", email));


            //Executing the SQLCommand

            try
            {

                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
            }
            catch (SqlException ex)
            {

                if (ex.Number == 2627)
                {
                    Response.Write("username is taken");

                }


            }



        }
    }
}