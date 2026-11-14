(() => {
    "use strict";

    const COPY = {
        es: {
            meta_title: "Driva — Higiene digital para Android",
            meta_desc: "Driva es una app Android de higiene digital: mide la salud real de tu batería y almacenamiento y te guía para liberar espacio sin promesas falsas. En desarrollo.",
            skip: "Saltar al contenido",
            nav_features: "Funciones",
            nav_how: "Cómo funciona",
            nav_status: "Estado",
            badge: "En desarrollo · Android",
            tagline: "Higiene digital, sin humo.",
            lead: "Una app Android que mide el estado real de tu batería y tu almacenamiento, te guía para liberar espacio app por app y registra cuánto has recuperado de verdad. Sin promesas mágicas de velocidad.",
            point1: "Datos del propio dispositivo, no estimaciones",
            point2: "Limpieza guiada, paso a paso",
            point3: "Historial de lo que liberas",
            cta_features: "Ver funciones",
            cta_status: "Estado del proyecto",
            micro: "MVP validado en emulador y en un Redmi Note 13 Pro 5G. Todavía no está en Google Play.",
            phone_sub: "Higiene digital",
            phone_battery: "Batería",
            phone_health: "Saludable",
            phone_temp: "Temperatura",
            phone_capacity: "Capacidad",
            phone_storage: "Almacenamiento",
            phone_free: "43,7 GB libres de 128 GB",
            phone_favs: "Tus favoritas",
            phone_all: "Ver todas",
            phone_freed_1: "120 MB liberados",
            phone_freed_2: "480 MB liberados",
            phone_freed_3: "1,2 GB liberados",
            features_eyebrow: "Funciones del MVP",
            features_title: "Lo que Driva mide, y lo que no",
            features_lead: "Cuatro funciones construidas sobre las APIs reales de Android. Nada de animaciones que «aceleran» el teléfono.",
            f1_title: "Salud de la batería",
            f1_text: "Nivel, estado de carga y temperatura leídos del sistema. Sin cifras inventadas ni «reparaciones» imposibles.",
            f2_title: "Almacenamiento real",
            f2_text: "Ocupado y libre del dispositivo, con las apps que más espacio consumen para que sepas dónde mirar primero.",
            f3_title: "Limpieza guiada",
            f3_text: "Android no deja que una app borre la caché de otra. Driva te lleva a los Ajustes de cada app y te pregunta cuánto liberaste.",
            f4_title: "Historial y favoritas",
            f4_text: "Cada limpieza queda registrada por app y fecha, con un total por periodo. Tus apps de siempre, siempre arriba.",
            how_eyebrow: "Cómo funciona",
            how_title: "Tres pasos, dos de ellos tuyos",
            how_lead: "La limitación de Android no se puede esquivar con código: se convierte en una experiencia clara.",
            s1_title: "Elige la app",
            s1_text: "Primero tus favoritas, después las recientes y, si hace falta, las 187 apps con icono del teléfono.",
            s2_title: "Limpia en Ajustes",
            s2_text: "Driva abre la pantalla de almacenamiento de esa app en Android. Tú pulsas «Borrar caché».",
            s3_title: "Registra lo liberado",
            s3_text: "Al volver, anota los MB con botones rápidos (10, 50, 100, 200, 500). El historial se actualiza solo.",
            honest_eyebrow: "Transparencia",
            honest_title: "Prefiere decirte la verdad",
            honest_text: "Desde Android 11, y de forma definitiva en Android 16, el sistema bloquea que una app de terceros lea o borre la caché de otras apps. Lo comprobamos en un dispositivo real con ADB: Permission denied. Driva no simula una limpieza que el sistema prohíbe; mide lo que sí puede y convierte el resto en un flujo guiado.",
            fact1_k: "APK debug",
            fact1_v: "Compilada e instalada",
            fact2_k: "Pruebas",
            fact2_v: "Emulador + teléfono real",
            fact3_k: "Apps detectadas",
            fact3_v: "187 con icono",
            fact4_k: "Publicación",
            fact4_v: "Pendiente",
            status_eyebrow: "Estado del proyecto",
            status_title: "Fase 1 completada",
            status_lead: "El MVP funciona y está probado. Lo que queda es monetización y escalado.",
            p0_title: "Fase 0 · Validación",
            p0_text: "Marca, stack técnico y alcance del MVP definidos.",
            p1_title: "Fase 1 · MVP",
            p1_text: "Method Channels en Kotlin, batería, almacenamiento y limpieza guiada. APK debug validada en un Redmi Note 13 Pro 5G con Android 16.",
            p2_title: "Fase 2 · Monetización",
            p2_text: "Modelo freemium con límite diario, versión Pro y suscripción.",
            p3_title: "Fase 3 · Escalado",
            p3_text: "Mantenimiento programado, control de datos móviles y publicación en tiendas.",
            tag_done: "Completada",
            tag_active: "En curso",
            tag_pending: "Pendiente",
            stack_label: "Stack",
            notice: "Driva todavía no está disponible en Google Play. Cuando exista ficha, se enlazará desde aquí y desde la tarjeta del portfolio.",
            footer_by: "Un proyecto de Arzaga Nahil",
            footer_portfolio: "Portfolio",
            footer_contact: "Contacto"
        },
        en: {
            meta_title: "Driva — Digital hygiene for Android",
            meta_desc: "Driva is an Android digital hygiene app: it measures the real health of your battery and storage and guides you to free up space without false promises. In development.",
            skip: "Skip to content",
            nav_features: "Features",
            nav_how: "How it works",
            nav_status: "Status",
            badge: "In development · Android",
            tagline: "Digital hygiene, no hype.",
            lead: "An Android app that measures the real state of your battery and storage, guides you to free up space app by app and records how much you actually recovered. No magic speed promises.",
            point1: "Data straight from the device, not estimates",
            point2: "Guided cleanup, step by step",
            point3: "History of what you free up",
            cta_features: "See features",
            cta_status: "Project status",
            micro: "MVP validated on an emulator and on a Redmi Note 13 Pro 5G. Not on Google Play yet.",
            phone_sub: "Digital hygiene",
            phone_battery: "Battery",
            phone_health: "Healthy",
            phone_temp: "Temperature",
            phone_capacity: "Capacity",
            phone_storage: "Storage",
            phone_free: "43.7 GB free of 128 GB",
            phone_favs: "Your favourites",
            phone_all: "See all",
            phone_freed_1: "120 MB freed",
            phone_freed_2: "480 MB freed",
            phone_freed_3: "1.2 GB freed",
            features_eyebrow: "MVP features",
            features_title: "What Driva measures, and what it doesn't",
            features_lead: "Four features built on real Android APIs. No animations that pretend to “speed up” your phone.",
            f1_title: "Battery health",
            f1_text: "Level, charging state and temperature read from the system. No made-up numbers or impossible “repairs”.",
            f2_title: "Real storage",
            f2_text: "Used and free space on the device, plus the apps taking up the most room so you know where to look first.",
            f3_title: "Guided cleanup",
            f3_text: "Android won't let one app clear another app's cache. Driva takes you to each app's Settings and asks how much you freed.",
            f4_title: "History and favourites",
            f4_text: "Every cleanup is logged by app and date, with a total per period. Your everyday apps, always on top.",
            how_eyebrow: "How it works",
            how_title: "Three steps, two of them yours",
            how_lead: "Android's restriction can't be coded around: it becomes a clear experience instead.",
            s1_title: "Pick the app",
            s1_text: "Your favourites first, then recent apps and, if needed, all 187 apps with an icon on the phone.",
            s2_title: "Clean in Settings",
            s2_text: "Driva opens that app's storage screen in Android. You tap “Clear cache”.",
            s3_title: "Log what you freed",
            s3_text: "Back in Driva, enter the MB with quick buttons (10, 50, 100, 200, 500). History updates itself.",
            honest_eyebrow: "Transparency",
            honest_title: "It would rather tell you the truth",
            honest_text: "Since Android 11, and definitively in Android 16, the system blocks third-party apps from reading or clearing other apps' cache. We confirmed it on a real device with ADB: Permission denied. Driva doesn't fake a cleanup the system forbids; it measures what it can and turns the rest into a guided flow.",
            fact1_k: "Debug APK",
            fact1_v: "Built and installed",
            fact2_k: "Testing",
            fact2_v: "Emulator + real phone",
            fact3_k: "Apps detected",
            fact3_v: "187 with an icon",
            fact4_k: "Release",
            fact4_v: "Pending",
            status_eyebrow: "Project status",
            status_title: "Phase 1 complete",
            status_lead: "The MVP works and has been tested. What remains is monetisation and scaling.",
            p0_title: "Phase 0 · Validation",
            p0_text: "Brand, technical stack and MVP scope defined.",
            p1_title: "Phase 1 · MVP",
            p1_text: "Kotlin Method Channels, battery, storage and guided cleanup. Debug APK validated on a Redmi Note 13 Pro 5G running Android 16.",
            p2_title: "Phase 2 · Monetisation",
            p2_text: "Freemium model with a daily limit, Pro version and subscription.",
            p3_title: "Phase 3 · Scaling",
            p3_text: "Scheduled maintenance, mobile data control and store release.",
            tag_done: "Done",
            tag_active: "In progress",
            tag_pending: "Pending",
            stack_label: "Stack",
            notice: "Driva isn't available on Google Play yet. Once there's a store listing, it will be linked from here and from the portfolio card.",
            footer_by: "A project by Arzaga Nahil",
            footer_portfolio: "Portfolio",
            footer_contact: "Contact"
        }
    };

    const STORAGE_KEY = "driva-lang";
    const root = document.documentElement;
    const toggle = document.querySelector("[data-lang-toggle]");

    function detectLang() {
        try {
            const saved = localStorage.getItem(STORAGE_KEY);
            if (saved === "es" || saved === "en") return saved;
        } catch (error) {
            /* storage blocked */
        }
        return (navigator.language || "es").toLowerCase().startsWith("en") ? "en" : "es";
    }

    function apply(lang) {
        const copy = COPY[lang] || COPY.es;

        document.querySelectorAll("[data-i18n]").forEach((node) => {
            const value = copy[node.dataset.i18n];
            if (typeof value === "string") node.textContent = value;
        });

        document.querySelectorAll("[data-i18n-attr]").forEach((node) => {
            const value = copy[node.dataset.i18nKey];
            if (typeof value === "string") node.setAttribute(node.dataset.i18nAttr, value);
        });

        document.title = copy.meta_title;
        root.lang = lang;

        if (toggle) {
            const next = lang === "es" ? "EN" : "ES";
            toggle.textContent = next;
            toggle.setAttribute(
                "aria-label",
                lang === "es" ? "Switch to English" : "Cambiar a español"
            );
        }

        try {
            localStorage.setItem(STORAGE_KEY, lang);
        } catch (error) {
            /* storage blocked */
        }
    }

    let current = detectLang();
    apply(current);

    if (toggle) {
        toggle.addEventListener("click", () => {
            current = current === "es" ? "en" : "es";
            apply(current);
        });
    }

    const year = document.querySelector("[data-year]");
    if (year) year.textContent = String(new Date().getFullYear());
})();
