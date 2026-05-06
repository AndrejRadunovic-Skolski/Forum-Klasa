<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Forum_Klasa.Default" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Forum</title>
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

        /* NAV  */
        nav {
            background: var(--surface);
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 2rem;
            height: 56px;
            position: sticky;
            top: 0;
            z-index: 100;
        }
        .nav-logo {
            font-family: 'Bebas Neue', cursive;
            font-size: 1.8rem;
            letter-spacing: 0.1em;
            color: var(--accent);
            text-decoration: none;
        }
        .nav-right { display: flex; align-items: center; gap: 1rem; }
        .nav-user {
            font-family: 'IBM Plex Mono', monospace;
            font-size: 0.7rem;
            color: var(--muted);
            letter-spacing: 0.1em;
        }
        .nav-user span { color: var(--text); }
        .nav-btn {
            background: none;
            border: 1px solid var(--border);
            color: var(--muted);
            font-family: 'IBM Plex Mono', monospace;
            font-size: 0.65rem;
            letter-spacing: 0.2em;
            text-transform: uppercase;
            padding: 0.4rem 0.9rem;
            cursor: pointer;
            text-decoration: none;
            transition: border-color 0.2s, color 0.2s;
        }
        .nav-btn:hover { border-color: var(--accent); color: var(--accent); }
        .nav-btn.admin { border-color: var(--accent2); color: var(--accent2); }
        .nav-btn.admin:hover { background: var(--accent2); color: #000; }

        /* LAYOUT  */
        .wrapper { max-width: 1100px; margin: 0 auto; padding: 2rem 1rem; display: grid; grid-template-columns: 240px 1fr; gap: 2rem; }

        /* SIDEBAR */
        .sidebar {}
        .sidebar-title {
            font-family: 'IBM Plex Mono', monospace;
            font-size: 0.6rem;
            letter-spacing: 0.35em;
            text-transform: uppercase;
            color: var(--muted);
            margin-bottom: 0.75rem;
        }
        .cat-list { list-style: none; }
        .cat-list li { border-bottom: 1px solid var(--border); }
        .cat-list a {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0.75rem 0.5rem;
            color: var(--text);
            text-decoration: none;
            font-size: 0.9rem;
            transition: color 0.15s;
        }
        .cat-list a:hover, .cat-list a.active { color: var(--accent); }
        .cat-list a.active { font-weight: 500; }
        .cat-badge {
            font-family: 'IBM Plex Mono', monospace;
            font-size: 0.65rem;
            color: var(--muted);
        }

        /* NEW POST BTN */
        .new-post-btn {
            display: block;
            width: 100%;
            background: var(--accent);
            color: #000;
            border: none;
            font-family: 'Bebas Neue', cursive;
            font-size: 1.1rem;
            letter-spacing: 0.2em;
            padding: 0.7rem;
            cursor: pointer;
            text-align: center;
            text-decoration: none;
            margin-bottom: 1.5rem;
            transition: background 0.2s;
        }
        .new-post-btn:hover { background: #fff; }

        /* POST LIST */
        .main-col {}
        .col-header {
            display: flex;
            align-items: baseline;
            gap: 0.75rem;
            margin-bottom: 1.25rem;
            border-bottom: 1px solid var(--border);
            padding-bottom: 0.75rem;
        }
        .col-header h1 {
            font-family: 'Bebas Neue', cursive;
            font-size: 2rem;
            letter-spacing: 0.1em;
        }
        .col-header .opis {
            font-size: 0.8rem;
            color: var(--muted);
        }
        .post-list { display: flex; flex-direction: column; gap: 0.5rem; }
        .post-card {
            background: var(--surface);
            border: 1px solid var(--border);
            padding: 1rem 1.25rem;
            display: grid;
            grid-template-columns: 52px 1fr auto;
            gap: 0 1rem;
            align-items: center;
            transition: border-color 0.15s;
            text-decoration: none;
            color: var(--text);
        }
        .post-card:hover { border-color: var(--accent); }
        .vote-col { text-align: center; }
        .vote-count {
            font-family: 'Bebas Neue', cursive;
            font-size: 1.6rem;
            color: var(--accent);
            line-height: 1;
        }
        .vote-label {
            font-family: 'IBM Plex Mono', monospace;
            font-size: 0.55rem;
            color: var(--muted);
            letter-spacing: 0.15em;
        }
        .post-title {
            font-size: 1rem;
            font-weight: 500;
            margin-bottom: 0.25rem;
        }
        .post-meta {
            font-family: 'IBM Plex Mono', monospace;
            font-size: 0.65rem;
            color: var(--muted);
        }
        .post-meta span { color: var(--text); }
        .post-replies {
            font-family: 'IBM Plex Mono', monospace;
            font-size: 0.65rem;
            color: var(--muted);
            text-align: right;
            white-space: nowrap;
        }
        .empty-state {
            text-align: center;
            padding: 4rem 1rem;
            color: var(--muted);
            font-family: 'IBM Plex Mono', monospace;
            font-size: 0.8rem;
        }
        .empty-state .big { font-family: 'Bebas Neue', cursive; font-size: 3rem; color: var(--border); display: block; margin-bottom: 0.5rem; }

        /* MODAL */
        .modal-overlay {
            display: none;
            position: fixed; inset: 0;
            background: rgba(0,0,0,0.8);
            z-index: 200;
            align-items: center;
            justify-content: center;
        }
        .modal-overlay.open { display: flex; }
        .modal {
            background: var(--surface);
            border: 1px solid var(--border);
            width: 100%;
            max-width: 540px;
            padding: 2rem;
            animation: fadeUp 0.25s ease both;
        }
        @keyframes fadeUp { from { opacity:0; transform:translateY(16px); } to { opacity:1; transform:translateY(0); } }
        .modal-title {
            font-family: 'Bebas Neue', cursive;
            font-size: 1.6rem;
            letter-spacing: 0.1em;
            margin-bottom: 1.5rem;
        }
        .field { margin-bottom: 1.1rem; }
        .field label {
            display: block;
            font-family: 'IBM Plex Mono', monospace;
            font-size: 0.6rem;
            letter-spacing: 0.25em;
            text-transform: uppercase;
            color: var(--muted);
            margin-bottom: 0.35rem;
        }
        .field input, .field textarea {
            width: 100%;
            background: var(--surface2);
            border: 1px solid var(--border);
            color: var(--text);
            font-family: 'IBM Plex Mono', monospace;
            font-size: 0.85rem;
            padding: 0.65rem 0.9rem;
            outline: none;
            transition: border-color 0.2s;
            resize: vertical;
        }
        .field input:focus, .field textarea:focus { border-color: var(--accent); }
        .modal-actions { display: flex; gap: 0.75rem; margin-top: 1.25rem; }
        .btn-primary {
            flex: 1;
            background: var(--accent);
            color: #000;
            border: none;
            font-family: 'Bebas Neue', cursive;
            font-size: 1.1rem;
            letter-spacing: 0.2em;
            padding: 0.7rem;
            cursor: pointer;
            transition: background 0.2s;
        }
        .btn-primary:hover { background: #fff; }
        .btn-cancel {
            background: none;
            border: 1px solid var(--border);
            color: var(--muted);
            font-family: 'IBM Plex Mono', monospace;
            font-size: 0.7rem;
            padding: 0.7rem 1.2rem;
            cursor: pointer;
            transition: border-color 0.2s;
        }
        .btn-cancel:hover { border-color: var(--muted); }
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
        <!-- SIDEBAR -->
        <aside class="sidebar">
            <asp:HyperLink ID="lnkNovaObjava" runat="server" CssClass="new-post-btn">+ Nova objava</asp:HyperLink>
            <div class="sidebar-title">Kategorije</div>
            <ul class="cat-list">
                <asp:Repeater ID="rptKategorije" runat="server" OnItemDataBound="rptKategorije_ItemDataBound">
                    <ItemTemplate>
                        <li>
                            <asp:HyperLink ID="lnkKat" runat="server" CssClass="cat-list-link">
                                <span><%# Eval("ime") %></span>
                                <span class="cat-badge" id="spnCount" runat="server"></span>
                            </asp:HyperLink>
                        </li>
                    </ItemTemplate>
                </asp:Repeater>
            </ul>
        </aside>

        <!-- MAIN COLUMN -->
        <main class="main-col">
            <div class="col-header">
                <h1><asp:Literal ID="litKatIme" runat="server" Text="Sve kategorije"/></h1>
                <span class="opis"><asp:Literal ID="litKatOpis" runat="server"/></span>
            </div>
            <div class="post-list">
                <asp:Repeater ID="rptObjave" runat="server" OnItemDataBound="rptObjave_ItemDataBound">
                    <ItemTemplate>
                        <asp:HyperLink ID="lnkObjava" runat="server" CssClass="post-card">
                            <div class="vote-col">
                                <div class="vote-count" id="spnVotes" runat="server">0</div>
                                <div class="vote-label">glasova</div>
                            </div>
                            <div>
                                <div class="post-title"><%# Eval("naslov") %></div>
                                <div class="post-meta">
                                    autor: <span id="spnAutor" runat="server"></span> &nbsp;·&nbsp;
                                    <%# Eval("datum_objave", "{0:dd.MM.yyyy HH:mm}") %>
                                </div>
                            </div>
                            <div class="post-replies" id="spnOdg" runat="server"></div>
                        </asp:HyperLink>
                    </ItemTemplate>
                </asp:Repeater>
                <asp:Panel ID="pnlEmpty" runat="server" CssClass="empty-state" Visible="false">
                    <span class="big">PRAZNO</span>
                    Nema objava u ovoj kategoriji.
                </asp:Panel>
            </div>
        </main>
    </div>

    <!-- NEW POST MODAL -->
    <div class="modal-overlay" id="modalNova">
        <div class="modal">
            <div class="modal-title">Nova objava</div>
            <div class="field">
                <label>Naslov</label>
                <asp:TextBox ID="txtNaslov" runat="server" placeholder="Naslov..."/>
            </div>
            <div class="field">
                <label>Sadrzaj</label>
                <asp:TextBox ID="txtSadrzaj" runat="server" TextMode="MultiLine" Rows="6" placeholder="Sadrzaj..."/>
            </div>
            <asp:HiddenField ID="hfKatIdForPost" runat="server"/>
            <div class="modal-actions">
                <asp:Button ID="btnPostuj" runat="server" Text="POSTUJ" CssClass="btn-primary" OnClick="btnPostuj_Click"/>
                <button type="button" class="btn-cancel" onclick="closeModal()">Otkaži</button>
            </div>
        </div>
    </div>

    <asp:HiddenField ID="hfShowModal" runat="server" Value="0"/>
</form>
<script>
    function openModal() {
        document.getElementById('modalNova').classList.add('open');
        document.getElementById('<%= hfShowModal.ClientID %>').value = '1';
    }
    function closeModal() {
        document.getElementById('modalNova').classList.remove('open');
        document.getElementById('<%= hfShowModal.ClientID %>').value = '0';
    }
    window.onload = function() {
        if (document.getElementById('<%= hfShowModal.ClientID %>').value === '1')
            document.getElementById('modalNova').classList.add('open');
        // Attach new post btn
        var btn = document.querySelector('.new-post-btn');
        if (btn) btn.onclick = function(e) { e.preventDefault(); openModal(); };
    };
</script>
</body>
</html>
