<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm1.aspx.cs" Inherits="Forum_Klasa.WebForm1" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>IDForum</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma; background: #eceff1; padding: 20px; }
        .panel { background: white; padding: 20px; border-radius: 10px; margin-bottom: 25px; border-left: 5px solid #3498db; }
        h2 { color: #2c3e50; margin-top: 0; }
        .grid { width: 100%; border-collapse: collapse; margin-top: 10px; }
        .btn { padding: 8px 15px; cursor: pointer; border: none; border-radius: 4px; color: white; background: #3498db; }
        .btn-red { background: #e74c3c; }
        .btn-green { background: #2ecc71; }
        input[type="text"], input[type="password"] { padding: 8px; margin: 5px; border: 1px solid #ccc; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <h1>Forum menadzerisanjeinator</h1>

        <div class="panel">
            <h2>Korisnici (Unos, Izmena, Brisanje)</h2>
            <asp:TextBox ID="txtEmail" runat="server" placeholder="Email"></asp:TextBox>
            <asp:TextBox ID="txtIme" runat="server" placeholder="Ime"></asp:TextBox>
            <asp:TextBox ID="txtLozinka" runat="server" TextMode="Password" placeholder="Lozinka"></asp:TextBox>
            <br />
            <asp:Button ID="btnDodajKor" runat="server" Text="Dodaj" OnClick="btnDodajKor_Click" CssClass="btn btn-green" />
            <asp:Button ID="btnIzmeniKor" runat="server" Text="Izmeni Lozinku" OnClick="btnIzmeniKor_Click" CssClass="btn" />
            <asp:Button ID="btnObrisiKor" runat="server" Text="Obriši" OnClick="btnObrisiKor_Click" CssClass="btn btn-red" />
        </div>

        <div class="panel">
            <h2>Kategorije</h2>
            <asp:TextBox ID="txtKatIme" runat="server" placeholder="Naziv kategorije"></asp:TextBox>
            <asp:TextBox ID="txtKatOpis" runat="server" placeholder="Opis"></asp:TextBox>
            <asp:Button ID="btnDodajKat" runat="server" Text="Kreiraj" OnClick="btnDodajKat_Click" CssClass="btn btn-green" />
            <asp:Button ID="btnObrisiKat" runat="server" Text="Obriši po imenu" OnClick="btnObrisiKat_Click" CssClass="btn btn-red" />
            <hr />
            <asp:GridView ID="gvKategorije" runat="server" AutoGenerateColumns="true" CssClass="grid"></asp:GridView>
        </div>

        <div class="panel">
            <h2>Objave & Odgovori</h2>
            <div style="background: #f9f9f9; padding: 10px; margin-bottom:10px;">
                <h4>Nova Objava / Odgovor</h4>
                Korisnik ID: <asp:TextBox ID="txtObjavaKorId" runat="server" Width="40"></asp:TextBox>
                Kat ID: <asp:TextBox ID="txtObjavaKatId" runat="server" Width="40"></asp:TextBox>
                Odgovor na ID (0 ako je glavna): <asp:TextBox ID="txtOdgovorId" runat="server" Width="40"></asp:TextBox>
                Naslov: <asp:TextBox ID="txtObjavaNaslov" runat="server"></asp:TextBox>
                Sadržaj: <asp:TextBox ID="txtObjavaSadrzaj" runat="server"></asp:TextBox>
                <asp:Button ID="btnPostaviObjavu" runat="server" Text="Postavi" OnClick="btnPostaviObjavu_Click" CssClass="btn btn-green" />
            </div>
            
            Kategorija: <asp:DropDownList ID="ddlKategorije" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlKategorije_SelectedIndexChanged" DataTextField="ime" DataValueField="kategorija_id"></asp:DropDownList>
        <asp:GridView ID="gvObjave" runat="server" AutoGenerateColumns="False" CssClass="grid" OnRowCommand="gvObjave_RowCommand"> 
            <Columns>
                <asp:BoundField DataField="objava_id" HeaderText="ID" />
                <asp:BoundField DataField="ime" HeaderText="Naslov" />
                <asp:BoundField DataField="sadrzaj" HeaderText="Sadržaj" />
                <asp:TemplateField HeaderText="Akcije">
                    <ItemTemplate>

                        <asp:Button ID="btnVidi" runat="server" Text="Odgovori" 
                            CommandName="Vidi" CommandArgument='<%# Eval("objava_id") %>' CssClass="btn" />
                
                        <asp:Button ID="btnDelete" runat="server" Text="X" 
                            CommandName="Obrisi" CommandArgument='<%# Eval("objava_id") %>' 
                            CssClass="btn btn-red" OnClientClick="return confirm('Obriši objavu?');" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
        <asp:Panel ID="pnlOdgovori" runat="server" Visible="false" CssClass="panel" style="border-left: 5px solid #2ecc71; background: #f0fff4;">
            <h3>Odgovori na objavu:</h3>
                <asp:GridView ID="gvOdgovori" runat="server" AutoGenerateColumns="False" CssClass="grid" OnRowCommand="gvOdgovori_RowCommand" BackColor="White">
                <Columns>
                    <asp:BoundField DataField="objava_id" HeaderText="ID" />
                    <asp:BoundField DataField="sadrzaj" HeaderText="Sadržaj Odgovora" />
                    <asp:TemplateField HeaderText="Akcije">
                        <ItemTemplate>
                            <asp:Button ID="btnObrisiOdgovor" runat="server" Text="Obriši" 
                                CommandName="ObrisiOdgovor" CommandArgument='<%# Eval("objava_id") %>' 
                                CssClass="btn btn-red" OnClientClick="return confirm('Obriši ovaj odgovor?');" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        <asp:Button ID="btnZatvoriOdgovore" runat="server" Text="Zatvori" OnClick="btnZatvoriOdgovore_Click" CssClass="btn" style="background:#95a5a6;" />
        </asp:Panel>
        </div>

        <div class="panel" style="background: #fdf2e9;">
            <h2>Upravljanje Glasovima</h2>
            Objava ID: <asp:TextBox ID="txtGlasObjavaId" runat="server" Width="40"></asp:TextBox>
            Korisnik ID: <asp:TextBox ID="txtGlasKorId" runat="server" Width="40"></asp:TextBox>
            Vrednost (-1 do 1): <asp:TextBox ID="txtGlasVrednost" runat="server" Width="40"></asp:TextBox>
            <asp:Button ID="btnGlasaj" runat="server" Text="Dodaj/Izmeni Glas" OnClick="btnGlasaj_Click" CssClass="btn" />
            <asp:Button ID="btnObrisiGlas" runat="server" Text="Obriši Glas" OnClick="btnObrisiGlas_Click" CssClass="btn btn-red" />
        </div>

        <asp:Label ID="lblStatus" runat="server" Font-Bold="true" ForeColor="Blue"></asp:Label>
    </form>
</body>
</html>