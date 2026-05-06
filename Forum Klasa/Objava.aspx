<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Objava.aspx.cs" Inherits="Forum_Klasa.Objava" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Objava – Forum</title>
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=IBM+Plex+Mono:wght@400;600&family=IBM+Plex+Sans:wght@300;400;500&display=swap" rel="stylesheet"/>
    <style>
        :root {
            --bg: #0e0e0e;
            --surface: #161616;
            --surface2: #1e1e1e;
            --border: #2a2a2a;
            --accent: #e8ff00;
            --accent2: #ff4d00;
            --text: #f0f0f0;
            --muted: #666;
        }
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body { background: var(--bg); color: var(--text); font-family: 'IBM Plex Sans', sans-serif; }

        nav {
            background: var(--surface);
            border-bottom: 1px solid var(--border);
            display: flex; align-items: center; justify-content: space-between;
            padding: 0 2rem; height: 56px;
            position: sticky; top: 0; z-index: 100;
        }
        .nav-logo { font-family: 'Bebas Neue', cursive; font-size: 1.8rem; letter-spacing: 0.1em; color: var(--accent); text-decoration: none; }
        .nav-right { display: flex; align-items: center; gap: 1rem; }
        .nav-btn { background: none; border: 1px solid var(--border); color: var(--muted); font-family: 'IBM Plex Mono', monospace; font-size: 0.65rem; letter-spacing: 0.2em; text-transform: uppercase; padding: 0.4rem 0.9rem; cursor: pointer; text-decoration: none; transition: border-color 0.2s, color 0.2s; }
        .nav-btn:hover { border-color: var(--accent); color: var(--accent); }
        .nav-btn.admin { border-color: var(--accent2); color: var(--accent2); }
        .nav-btn.admin:hover { background: var(--accent2); color: #000; }
        .nav-user { font-family: 'IBM Plex Mono', monospace; font-size: 0.7rem; color: var(--muted); }
        .nav-user span { color: var(--text); }

        .wrapper { max-width: 800px; margin: 0 auto; padding: 2.5rem 1rem; }
        .breadcrumb { font-family: 'IBM Plex Mono', monospace; font-size: 0.65rem; color: var(--muted); margin-bottom: 1.5rem; }
        .breadcrumb a { color: var(--muted); text-decoration: none; }
        .breadcrumb a:hover { color: var(--accent); }
        .breadcrumb .sep { margin: 0 0.4rem; }

        .post-box {
            background: var(--surface);
            border: 1px solid var(--border);
            border-left: 3px solid var(--accent);
            padding: 2rem;
            margin-bottom: 2rem;
            animation: fadeUp 0.3s ease both;
        }
        @keyframes fadeUp { from { opacity:0; transform:translateY(12px); } to { opacity:1; transform:translateY(0); } }
        .post-title { font-family: 'Bebas Neue', cursive; font-size: 2.2rem; letter-spacing: 0.05em; margin-bottom: 0.5rem; line-height: 1.1; }
        .post-meta { font-family: 'IBM Plex Mono', monospace; font-size: 0.65rem; color: var(--muted); margin-bottom: 1.5rem; }
        .post-meta span { color: var(--text); }
        .post-body { font-size: 0.95rem; line-height: 1.75; color: #d0d0d0; white-space: pre-wrap; }


        .vote-bar {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            margin-top: 1.75rem;
            padding-top: 1.25rem;
            border-top: 1px solid var(--border);
        }
        .vote-score { font-family: 'Bebas Neue', cursive; font-size: 1.8rem; color: var(--accent); min-width: 40px; text-align: center; }
        .vote-btn {
            background: none;
            border: 1px solid var(--border);
            color: var(--muted);
            width: 34px; height: 34px;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.15s;
            display: flex; align-items: center; justify-content: center;
        }
        .vote-btn:hover { border-color: var(--accent); color: var(--accent); }
        .vote-btn.down:hover { border-color: var(--accent2); color: var(--accent2); }
        .delete-btn {
            margin-left: auto;
            background: none;
            border: 1px solid var(--border);
            color: var(--muted);
            font-family: 'IBM Plex Mono', monospace;
            font-size: 0.65rem;
            letter-spacing: 0.1em;
            padding: 0.4rem 0.8rem;
            cursor: pointer;
            transition: all 0.15s;
        }
        .delete-btn:hover { border-color: var(--accent2); color: var(--accent2); }


        .replies-header {
            font-family: 'IBM Plex Mono', monospace;
            font-size: 0.65rem;
            letter-spacing: 0.3em;
            text-transform: uppercase;
            color: var(--muted);
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }
        .replies-header::after { content:''; flex:1; height:1px; background:var(--border); }

        .reply-card {
            background: var(--surface2);
            border: 1px solid var(--border);
            border-left: 2px solid var(--border);
            padding: 1.25rem 1.5rem;
            margin-bottom: 0.5rem;
            display: grid;
            grid-template-columns: 1fr auto;
            gap: 0.75rem;
            animation: fadeUp 0.3s ease both;
        }
        .reply-card:hover { border-left-color: var(--muted); }
        .reply-meta { font-family: 'IBM Plex Mono', monospace; font-size: 0.65rem; color: var(--muted); margin-bottom: 0.6rem; }
        .reply-meta span { color: var(--text); }
        .reply-body { font-size: 0.9rem; line-height: 1.7; color: #c0c0c0; white-space: pre-wrap; }
        .reply-vote { display: flex; flex-direction: column; align-items: center; gap: 0.3rem; }
        .reply-vote-score { font-family: 'Bebas Neue', cursive; font-size: 1.2rem; color: var(--accent); }


        .reply-form {
            background: var(--surface);
            border: 1px solid var(--border);
            padding: 1.5rem;
            margin-top: 1.5rem;
        }
        .reply-form-title { font-family: 'Bebas Neue', cursive; font-size: 1.2rem; letter-spacing: 0.1em; margin-bottom: 1rem; }
        .field { margin-bottom: 1rem; }
        .field label { display: block; font-family: 'IBM Plex Mono', monospace; font-size: 0.6rem; letter-spacing: 0.25em; text-transform: uppercase; color: var(--muted); margin-bottom: 0.35rem; }
        .field textarea { width: 100%; background: var(--surface2); border: 1px solid var(--border); color: var(--text); font-family: 'IBM Plex Mono', monospace; font-size: 0.85rem; padding: 0.7rem 1rem; outline: none; transition: border-color 0.2s; resize: vertical; }
        .field textarea:focus { border-color: var(--accent); }
        .btn-primary { background: var(--accent); color: #000; border: none; font-family: 'Bebas Neue', cursive; font-size: 1.1rem; letter-spacing: 0.2em; padding: 0.7rem 2rem; cursor: pointer; transition: background 0.2s; }
        .btn-primary:hover { background: #fff; }
        .no-replies { font-family: 'IBM Plex Mono', monospace; font-size: 0.75rem; color: var(--muted); padding: 1.5rem 0; text-align: center; }
    </style>
</head>
<body>
<form id="form1" runat="server">
    <nav>
        <a class="nav-logo" href="Default.aspx">Forum</a>
        <div class="nav-right">
            <div class="nav-user">Korisnik: <span><asp:Literal ID="litIme" runat="server"/></span></div>
            <asp:HyperLink ID="lnkAdmin" runat="server" CssClass="nav-btn admin" NavigateUrl="WebForm1.aspx" Visible="false">Admin</asp:HyperLink>
            <asp:LinkButton ID="btnOdjava" runat="server" CssClass="nav-btn" OnClick="btnOdjava_Click">Odjavi se</asp:LinkButton>
        </div>
    </nav>

    <div class="wrapper">
        <div class="breadcrumb">
            <a href="Default.aspx">← Nazad</a>
        </div>


        <div class="post-box">
            <div class="post-title"><asp:Literal ID="litNaslov" runat="server"/></div>
            <div class="post-meta">
                autor: <span><asp:Literal ID="litAutor" runat="server"/></span>
                &nbsp;·&nbsp;
                <asp:Literal ID="litDatum" runat="server"/>
            </div>
            <div class="post-body"><asp:Literal ID="litSadrzaj" runat="server"/></div>
            <div class="vote-bar">
                <asp:Button ID="btnUpvote" runat="server" Text="▲" CssClass="vote-btn" OnClick="btnUpvote_Click"/>
                <div class="vote-score"><asp:Literal ID="litVotes" runat="server" Text="0"/></div>
                <asp:Button ID="btnDownvote" runat="server" Text="▼" CssClass="vote-btn down" OnClick="btnDownvote_Click"/>
                <asp:Button ID="btnDelete" runat="server" Text="Obriši objavu" CssClass="delete-btn" OnClick="btnDelete_Click" Visible="false"
                    OnClientClick="return confirm('Sigurno briše?');"/>
            </div>
        </div>


        <div class="replies-header"><asp:Literal ID="litOdgCount" runat="server" Text="0"/> odgovora</div>

        <asp:Repeater ID="rptOdgovori" runat="server" OnItemDataBound="rptOdgovori_ItemDataBound">
            <ItemTemplate>
                <div class="reply-card">
                    <div>
                        <div class="reply-meta">
                            <span id="spnAutorOdg" runat="server"></span>
                            &nbsp;·&nbsp;
                            <%# Eval("datum_objave", "{0:dd.MM.yyyy HH:mm}") %>
                        </div>
                        <div class="reply-body"><%# Server.HtmlEncode(Eval("sadrzaj").ToString()) %></div>
                    </div>
                    <div class="reply-vote">
                        <asp:Button ID="btnOdgUp" runat="server" Text="▲" CssClass="vote-btn" CommandName="upvote" CommandArgument='<%# Eval("objava_id") %>' OnCommand="rptOdgovori_Command"/>
                        <div class="reply-vote-score" id="spnOdgVotes" runat="server">0</div>
                        <asp:Button ID="btnOdgDown" runat="server" Text="▼" CssClass="vote-btn down" CommandName="downvote" CommandArgument='<%# Eval("objava_id") %>' OnCommand="rptOdgovori_Command"/>
                        <asp:Button ID="btnOdgDel" runat="server" Text="✕" CssClass="vote-btn" CommandName="delete" CommandArgument='<%# Eval("objava_id") %>' OnCommand="rptOdgovori_Command" Visible="false" ToolTip="Obriši"/>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>

        <asp:Panel ID="pnlNoReplies" runat="server" CssClass="no-replies" Visible="false">
            Budi prvi koji odgovori.
        </asp:Panel>


        <div class="reply-form">
            <div class="reply-form-title">Odgovori</div>
            <div class="field">
                <label>Tvoj odgovor</label>
                <asp:TextBox ID="txtOdgovor" runat="server" TextMode="MultiLine" Rows="5" placeholder="Napisi odgovor..."/>
            </div>
            <asp:Button ID="btnOdgovori" runat="server" Text="POŠALJI" CssClass="btn-primary" OnClick="btnOdgovori_Click"/>
        </div>
    </div>
    <asp:HiddenField ID="hfObjavaId" runat="server"/>
    <asp:HiddenField ID="hfKatId" runat="server"/>
</form>
</body>
</html>
