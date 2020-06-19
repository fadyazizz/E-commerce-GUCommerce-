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
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }




        protected void login(object sender, EventArgs e)
        {
            //Get the information of the connection to the database
            string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ToString();

            //create a new connection
            SqlConnection conn = new SqlConnection(connStr);

            /*create a new SQL command which takes as parameters the name of the stored procedure and
             the SQLconnection name*/
            SqlCommand cmd = new SqlCommand("userLogin", conn);
            cmd.CommandType = CommandType.StoredProcedure;
        //To read the input from the user
        string username = txt_username.Text;
            string password = txt_password.Text;

            //pass parameters to the stored procedure
            cmd.Parameters.Add(new SqlParameter("@username", username));
            cmd.Parameters.Add(new SqlParameter("@password", password));

            //Save the output from the procedure
            SqlParameter type = cmd.Parameters.Add("@type", SqlDbType.Int);
            type.Direction = ParameterDirection.Output;

            SqlParameter success = cmd.Parameters.Add("@success", SqlDbType.Bit);
            success.Direction = ParameterDirection.Output;
            //Executing the SQLCommand
            conn.Open();
            cmd.ExecuteNonQuery();
            conn.Close();


            if (success.Value.ToString().Equals("1"))
            {
                //To send response data to the client side (HTML)
                Response.Write("Passed");

                /*ASP.NET session state enables you to store and retrieve values for a user
                as the user navigates ASP.NET pages in a Web application.
                This is how we store a value in the session*/
                Session["field1"] = username;
                string cases = type.Value.ToString();

                if (cases.Equals("0"))
                {
                    Response.Redirect("Customer.aspx", true);
                }

                //To navigate to another webpage
                //Response.Redirect("Companies.aspx", true);
                else
                {
                    if (cases.Equals("1"))
                    {
                        Response.Redirect("Vendors.aspx", true);
                    }


                    else {
                        if (cases.Equals("2"))
                        {
                            Response.Redirect("Admins.aspx", true);
                        }
                        else if (cases.Equals("3"))
                        {
                            Response.Redirect("DeliveryPerson.aspx", true);
                        }
                        else
                        {
                            Response.Write("user cant be identified");
                        }
                    }
                }
            }

            else
            {
                Response.Write("user not found");
            }
        }
    }
}
