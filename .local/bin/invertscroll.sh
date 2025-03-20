#!/bin/bash

# Função para ajustar o scroll
adjust_scroll() {
    DEVICE_ID=$1
    xinput set-prop $DEVICE_ID "libinput Natural Scrolling Enabled" 1
}

# IDs dos dispositivos
WIRELESS_ID="18"  # Ajuste para o ID do mouse wireless
WIRED_ID="13"     # Ajuste para o ID do mouse com fio

# Função para verificar e ajustar a rolagem
check_and_adjust() {
    if xinput list --id-only "$WIRELESS_ID" &>/dev/null; then
        adjust_scroll $WIRELESS_ID
    elif xinput list --id-only "$WIRED_ID" &>/dev/null; then
        adjust_scroll $WIRED_ID
    fi
}

# Chamada inicial para ajustar a rolagem
check_and_adjust

# Loop para monitorar mudanças nos dispositivos de entrada
while true; do
    # Verificar a cada 2 segundos
    sleep 2
    check_and_adjust
done

