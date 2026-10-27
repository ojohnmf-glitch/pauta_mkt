// Configuração do banco compartilhado (Supabase).
// Deixe os dois campos vazios para usar o modo local (dados só no navegador).
// A chave "anon" é pública por natureza: quem controla o acesso são as políticas (RLS) do banco.
window.PAUTAS_CONFIG = {
  supabaseUrl: "",      // ex.: "https://abcdefghijklmnop.supabase.co"
  supabaseAnonKey: ""   // chave "anon public" em Project Settings → API
};
