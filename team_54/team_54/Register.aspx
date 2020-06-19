<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="team_54.Register" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Button ID="Button_customer" runat="server" Text="Press if you are a Customer if you are not a customer please press the down button" onclick="Customer_Register" Width="990px"/>
            <asp:Button ID="Button_vendor" runat="server" Text="if you did not press the above button then surely you are a vendor, so please press this button" onclick="Vendor_Register" Width="990px" />

        </div>
    </form>

</body>
</html>
