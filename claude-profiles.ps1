# Profilo Personale / Privato (Usa la cartella predefinita, condivisa con VS Code)
function claude-personal {
    $env:CLAUDE_CONFIG_DIR = $null
    claude $args
}

# Profilo di Lavoro / Team (Deviato sulla cartella isolata)
function claude-work {
    $env:CLAUDE_CONFIG_DIR = "$HOME\.claude-work"
    claude $args
}
