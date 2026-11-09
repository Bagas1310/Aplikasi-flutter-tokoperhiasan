# Prompt Prompting Guide & Specifications for `barely_shop`

Dokumen ini berisi prompt terstruktur dan siap pakai (*ready-to-use*) untuk menginstruksikan AI Developer Tooling (**OpenCode, 9router, Ponytail, dan Impeccable**) dalam membangun aplikasi toko gelang online bernama **`barely_shop`**.

---

## 1. System Prompt & Context Overview

```text
Act as a Senior Full-Stack Web/Mobile Developer and UI/UX Designer.
You are tasked with building a modern, responsive, and visually aesthetic online bracelet store application named "barely_shop".

Key Specifications:
- Brand Name: barely_shop
- Theme & Palette: Aesthetic Soft Pastel (Dominant Soft Blue combined with Soft Pink accents, e.g., Pastel Blue #A0C4FF / #BEE3F8 mixed with Soft Pink #FFC6FF / #FED7E2, with neutral white background #F8FAFC).
- Target Audience: Teenagers, young adults, fashion enthusiasts looking for stylish bracelets.
- Design Style: Clean, soft, modern, minimal, friendly, and user-friendly navigation.
```

---

## 2. Comprehensive Prompt for AI Tools (OpenCode / 9router / Ponytail / Impeccable)

Gunakan prompt di bawah ini langsung pada tool pilihan Anda:

```text
Build a full-featured, responsive single-page or multi-page web application for an online bracelet store called "barely_shop".

### 🎨 Design & Aesthetic Guidelines:
1. Color Palette:
   - Primary: Soft Blue (e.g., `#99C1F1` or `#BAE6FD`)
   - Secondary / Accent: Soft Pink (e.g., `#FBB6CE` or `#F472B6`)
   - Background: Light Soft Neutral (e.g., `#FAF5FF` or `#F8FAFC`)
   - Text: Soft Slate / Charcoal (`#334155`) for high readability without harsh contrast.
2. Styling & Layout:
   - Rounded corners (`border-radius: 12px` to `16px`), soft shadows, and clean typography (e.g., Poppins, Quicksand, or Inter).
   - Fully responsive design (mobile-first layout with smooth desktop view).

---

### 🔑 Features & Page Flow Requirements:

#### 1. Authentication Flow (Login & Register):
- Initial View: Display the **Login Page** first upon app launch.
- If the user does not have an account, provide a clear link/tab to switch to the **Registration Page** ("Belum punya akun? Daftar dulu yuk!").
- Fields required for Registration: Full Name, Email, Password, Confirm Password.
- Fields required for Login: Email, Password.
- Include form validation and smooth transition animations between Login and Register states.
- Upon successful login, store state (e.g., mock session or local storage) and redirect the user to the **Home Page**.

#### 2. Home Page (Beranda):
- **Greeting Section**: Personalized top greeting bar (e.g., "Halo, [Nama User]! ✨ Selamat datang di barely_shop. Temukan gelang favoritmu hari ini!").
- **Hero Banner**: Eye-catching promotional banner sliding/carousel (e.g., "New Collection Release", "Special Promo 20% Off").
- **Bracelet Collections Grid/List**:
  - Show categories/types of bracelets (e.g., *Beaded Bracelets*, *Charm Bracelets*, *Minimalist Thread*, *Custom Letter Bracelets*, *Couples Set*).
  - Product Cards displaying:
    - High-quality photo placeholder / image URL.
    - Bracelet Title / Name.
    - Category Tag.
    - Product Description (short summary + detailed modal/popup view).
    - Price tag formatted neatly (e.g., `Rp 25.000`).
    - "Tambah ke Keranjang" (Add to Cart) button with interactive counter or animation.

#### 3. Shopping Cart & Checkout System (Keranjang):
- Floating or Header Shopping Cart icon displaying the item count badge.
- Interactive Cart Modal / Sidebar:
  - List of selected bracelets with thumbnail, quantity modifier (+/-), item price, and subtotal.
  - Delete item button.
  - Grand total calculation.
  - "Checkout Now" button triggering a simulated checkout summary dialog.

#### 4. User Profile Page (Halaman Profil):
- Dedicated profile tab/page displaying user details:
  - User avatar placeholder.
  - User Name, Email, Phone Number, and Shipping Address.
  - Bio/Description of the account owner (e.g., "Pencinta gelang aesthetic 🌸 | Member since 2026").
  - Order history summary list (Mock recent purchases).
  - "Logout" button that resets authentication and returns back to the Login screen.

---

### 💻 Technical Stack Preference:
- **Frontend**: HTML5, Tailwind CSS (or React + Tailwind / Vue + Tailwind), Vanilla JavaScript / React Hooks for state management (Auth, Cart, Navigation).
- **Icons**: Lucide Icons or FontAwesome.
- **State**: Persistent local storage for user profile data and cart items.

Please generate clean, well-structured, modular, and fully functional code fulfilling all requirements above.
```

---

## 3. Tool-Specific Execution Strategy

| AI Tool | Anjuran Cara Penggunaan Prompt |
| :--- | :--- |
| **OpenCode** | Paste prompt pada bagian system instruction / direct prompt. Mintalah pembuatan struktur file single-file (HTML/JS/Tailwind CDN) atau React App. |
| **9router** | Gunakan prompt ini sebagai `user message` utama untuk memandu routing logika komponen antara Login, Home, Cart, dan Profile. |
| **Ponytail** | Manfaatkan bagian *Design & Aesthetic Guidelines* dan *Features & Page Flow* agar Ponytail membuat UI mockups/component tree secara presisi. |
| **Impeccable** | Gunakan prompt ini untuk memandu *code generation* akhir dengan penekanan pada styling warna Soft Blue & Soft Pink. |