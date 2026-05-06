<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Forum_Klasa.Login" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Forum – Prijava</title>
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=IBM+Plex+Mono:wght@400;600&family=IBM+Plex+Sans:wght@300;400;500&display=swap" rel="stylesheet"/>
    <style>
        :root {
            --bg: #0e0e0e;
            --surface: #161616;
            --border: #2a2a2a;
            --accent: #e8ff00;
            --accent2: #ff4d00;
            --text: #f0f0f0;
            --muted: #888;
        }
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            background: var(--bg);
            color: var(--text);
            font-family: 'IBM Plex Sans', sans-serif;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }
        body::before {
            content: 'FORUM';
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            font-family: 'Bebas Neue', cursive;
            font-size: clamp(120px, 25vw, 320px);
            color: rgba(232,255,0,0.03);
            pointer-events: none;
            white-space: nowrap;
            letter-spacing: 0.1em;
        }
        .container {
            position: relative;
            width: 100%;
            max-width: 440px;
            padding: 1rem;
            animation: fadeUp 0.5s ease both;
        }
        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(20px); }
            to   { opacity: 1; transform: translateY(0); }
        }
        .logo {
            font-family: 'Bebas Neue', cursive;
            font-size: 3.5rem;
            letter-spacing: 0.15em;
            color: var(--accent);
            text-align: center;
            margin-bottom: 0.25rem;
            line-height: 1;
        }
        .tagline {
            text-align: center;
            font-family: 'IBM Plex Mono', monospace;
            font-size: 0.65rem;
            color: var(--muted);
            letter-spacing: 0.3em;
            text-transform: uppercase;
            margin-bottom: 2.5rem;
        }
        .tabs {
            display: flex;
            border-bottom: 1px solid var(--border);
            margin-bottom: 2rem;
        }
        .tab-btn {
            flex: 1;
            background: none;
            border: none;
            color: var(--muted);
            font-family: 'IBM Plex Mono', monospace;
            font-size: 0.75rem;
            letter-spacing: 0.2em;
            text-transform: uppercase;
            padding: 0.75rem;
            cursor: pointer;
            position: relative;
            transition: color 0.2s;
        }
        .tab-btn.active {
            color: var(--accent);
        }
        .tab-btn.active::after {
            content: '';
            position: absolute;
            bottom: -1px; left: 0; right: 0;
            height: 2px;
            background: var(--accent);
        }
        .form-panel { display: none; }
        .form-panel.active { display: block; animation: fadeUp 0.3s ease both; }
        .field {
            margin-bottom: 1.25rem;
        }
        .field label {
            display: block;
            font-family: 'IBM Plex Mono', monospace;
            font-size: 0.65rem;
            letter-spacing: 0.25em;
            text-transform: uppercase;
            color: var(--muted);
            margin-bottom: 0.4rem;
        }
        .field input {
            width: 100%;
            background: var(--surface);
            border: 1px solid var(--border);
            color: var(--text);
            font-family: 'IBM Plex Mono', monospace;
            font-size: 0.9rem;
            padding: 0.75rem 1rem;
            outline: none;
            transition: border-color 0.2s;
        }
        .field input:focus {
            border-color: var(--accent);
        }
        .btn {
            width: 100%;
            background: var(--accent);
            color: #000;
            border: none;
            font-family: 'Bebas Neue', cursive;
            font-size: 1.2rem;
            letter-spacing: 0.2em;
            padding: 0.85rem;
            cursor: pointer;
            transition: background 0.2s, transform 0.1s;
            margin-top: 0.5rem;
        }
        .btn:hover { background: #fff; }
        .btn:active { transform: scale(0.98); }
        .msg {
            font-family: 'IBM Plex Mono', monospace;
            font-size: 0.75rem;
            padding: 0.6rem 0.8rem;
            margin-bottom: 1rem;
            border-left: 3px solid var(--accent2);
            background: rgba(255,77,0,0.08);
            color: var(--accent2);
        }
        .msg.success {
            border-color: var(--accent);
            background: rgba(232,255,0,0.06);
            color: var(--accent);
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <div class="logo">IDForum</div>
            <div class="tagline">Pristupi Tel Aviv bazi podataka.</div>

            <div class="tabs">
                <button type="button" class="tab-btn active" onclick="switchTab('login',this)">Prijava</button>
                <button type="button" class="tab-btn" onclick="switchTab('register',this)">Registracija</button>
            </div>

            <asp:Label ID="lblMsg" runat="server" CssClass="msg" Visible="false"></asp:Label>


            <div id="panelLogin" class="form-panel active">
                <div class="field">
                    <label>Email</label>
                    <asp:TextBox ID="txtLoginEmail" runat="server" placeholder="korisnik@email.com"></asp:TextBox>
                </div>
                <div class="field">
                    <label>Lozinka</label>
                    <asp:TextBox ID="txtLoginLozinka" runat="server" TextMode="Password" placeholder="••••••••"></asp:TextBox>
                </div>
                <asp:Button ID="btnLogin" runat="server" Text="PRIJAVI SE" CssClass="btn" OnClick="btnLogin_Click"/>
            </div>


            <div id="panelRegister" class="form-panel">
                <div class="field">
                    <label>Korisničko ime</label>
                    <asp:TextBox ID="txtRegIme" runat="server" placeholder="nekocool123"></asp:TextBox>
                </div>
                <div class="field">
                    <label>Email</label>
                    <asp:TextBox ID="txtRegEmail" runat="server" placeholder="korisnik@email.com"></asp:TextBox>
                </div>
                <div class="field">
                    <label>Lozinka</label>
                    <asp:TextBox ID="txtRegLozinka" runat="server" TextMode="Password" placeholder="••••••••"></asp:TextBox>
                </div>
                <asp:Button ID="btnRegister" runat="server" Text="REGISTRUJ SE" CssClass="btn" OnClick="btnRegister_Click"/>
            </div>
        </div>
        <asp:HiddenField ID="hfActiveTab" runat="server" Value="login"/>
    </form>
    <script>
        function switchTab(tab, el) {
            document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
            document.querySelectorAll('.form-panel').forEach(p => p.classList.remove('active'));
            el.classList.add('active');
            document.getElementById('panel' + (tab === 'login' ? 'Login' : 'Register')).classList.add('active');
        }
        window.onload = function () {
            var at = document.getElementById('<%= hfActiveTab.ClientID %>');
            if (at && at.value === 'register') switchTab('register', document.querySelectorAll('.tab-btn')[1]);
        };
    </script>
</body>
</html>
