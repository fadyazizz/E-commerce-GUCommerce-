<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CustomerRegister.aspx.cs" Inherits="team_54.CustomerRegister" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
              <asp:Label ID="Label_username" runat="server" Text="Username:"></asp:Label>
            <asp:TextBox ID="username_register" runat="server"></asp:TextBox>

            <asp:Label ID="Label_firstname" runat="server" Text="first name:"></asp:Label>
            <asp:TextBox ID="firstname_register" runat="server"></asp:TextBox>

            <asp:Label ID="Label1" runat="server" Text="last name:"></asp:Label>
            <asp:TextBox ID="lastname_register" runat="server"></asp:TextBox>

            <asp:Label ID="Label3" runat="server" Text="password"></asp:Label>
            <asp:TextBox ID="password_register" runat="server" TextMode="Password"></asp:TextBox>


            <asp:Label ID="Label2" runat="server" Text="Email"></asp:Label>
            <asp:TextBox ID="email_register" runat="server"></asp:TextBox>


            <asp:Button ID="button1" runat="server" Text="Register" onclick="customer_register" Width="90px"/>

        </div>
    </form>
</body>
</html>
