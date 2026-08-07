#!/bin/bash

# ==========================================
# 1. BOT TOKEN AUR TARGET IDS
# ==========================================
BOT_TOKEN="8884013399:AAGNt17VYy6DKJ90VDy_ngFXe1A1kyLTz64"
TARGET_IDS=("-1003771154449" "-1003032298289")
SITE_DOMAIN="https://comic-pur.maxton87667.workers.dev"

# ==========================================
# 2. LATEST COMMIT SE COMIC DETECT KARNA
# ==========================================
NEW_FILES=$(git show --name-only --oneline | grep "^comics/")

if [ -z "$NEW_FILES" ]; then
    echo "⚠️ Koi comic file detect nahi hui. Last commit check karein."
    exit 0
fi

COMIC_SLUG=$(echo "$NEW_FILES" | head -n 1 | awk -F'/' '{print $2}')
COMIC_TITLE=$(echo "$COMIC_SLUG" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)} 1')

CH_LIST=$(echo "$NEW_FILES" | awk -F'/' '{print $3}' | grep -i "^ch" | sed 's/ch//i' | sort -n | uniq)
MIN_CH=$(echo "$CH_LIST" | head -n 1)
MAX_CH=$(echo "$CH_LIST" | tail -n 1)

if [ "$MIN_CH" == "$MAX_CH" ]; then
    EPISODE_TEXT="Chapter ${MIN_CH}"
else
    EPISODE_TEXT="Chapter ${MIN_CH} se ${MAX_CH}"
fi

READ_LINK="${SITE_DOMAIN}/comic/${COMIC_SLUG}"

# ==========================================
# 3. INTERNAL STORAGE SE COVER PHOTO DHOONDNA
# ==========================================
# Aapke folder me jis extension me file ho (.jpg, .webp, .png), wo auto detect karega
COVER_DIR="$HOME/storage/shared/Comics/cover"
COVER_IMAGE=$(ls "${COVER_DIR}/${COMIC_SLUG}"* 2>/dev/null | head -n 1)

if [ -z "$COVER_IMAGE" ]; then
    echo "❌ Error: Cover photo nahi mili -> ${COVER_DIR}/${COMIC_SLUG}.[jpg/webp/png]"
    exit 1
fi

# ==========================================
# 4. CONSOLE PREVIEW
# ==========================================
echo "----------------------------------------"
echo "📌 TEST PREVIEW:"
echo "• Title: $COMIC_TITLE"
echo "• Range: $EPISODE_TEXT"
echo "• Cover: $COVER_IMAGE"
echo "----------------------------------------"

CAPTION="🔥 *NEW EPISODE RELEASED!* 🔥

📚 *Title:* ${COMIC_TITLE}
📖 *Episodes:* ${EPISODE_TEXT}
⚡ *Status:* Available Now!

_Niche diye gaye button par click karke abhi padhein:_"

KEYBOARD='{"inline_keyboard":[[{"text":"📖 Read Now","url":"'${READ_LINK}'"}]]}'

# ==========================================
# 5. LOCAL IMAGE UPLOAD TO TELEGRAM (-F USE KARKE)
# ==========================================
for ID in "${TARGET_IDS[@]}"; do
    echo "📢 Sending to ID: $ID ..."
    curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendPhoto" \
         -F "chat_id=${ID}" \
         -F "photo=@${COVER_IMAGE}" \
         -F "caption=${CAPTION}" \
         -F "parse_mode=Markdown" \
         -F "reply_markup=${KEYBOARD}"
    echo ""
done

echo "✅ Process complete!"

