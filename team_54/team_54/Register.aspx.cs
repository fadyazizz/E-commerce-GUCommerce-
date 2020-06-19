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
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }
        protected void Customer_Register(object sender, EventArgs e)
        {

            Response.Redirect("CustomerRegister.aspx", true);

        }

        protected void Vendor_Register(object sender, EventArgs e)
        {
            Response.Redirect("VendorRegister.aspx", true);

        }
    }
}