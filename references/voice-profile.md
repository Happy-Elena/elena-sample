# Voice & Brand Profile

Your voice, niche, and rules in one place. Fill this once (or let `threads-humanizer` build
it from a few of your real posts), and every writing skill in this Threads bundle
reads it before drafting, so you stop re-explaining who you are on every request.
This file is yours: edit it freely. Nothing here is sent anywhere; it just steers
the drafts. Skills only load it when `filled: yes` below; an empty template is
ignored.

## Status

- filled: no
- source: template
- updated: --

## 1. Voice fingerprint

- Sentence rhythm:
- Signature openers:
- Punctuation habits:
- Words and phrases you use a lot:
- Words and phrases you NEVER use:
- Emoji:
- Formatting (Threads): 500 chars per post; warm and conversational; one hashtag max

## 2. Who you are and who you write for

- You are: «Кот Клеопатры» - the correct brand name (a cat, not a "code" pun
  - correction from the founder overrides the earlier methodology-doc
  spelling). A light Telegram/VK/Instagram-native automation tool for a solo
  beauty master (not a heavy salon CRM). Product direction: the MVP will be
  a full AI agent, and the fuller vision is a small team of AI agents
  working for the beauty master. The brand voice speaks as the cat.
- Your audience (ICP): Self-employed beauty masters (manicure, pedicure,
  brows, lashes, makeup, sugaring, cosmetology) in Russia/CIS. 30-150 active
  clients, no administrator, work solo from home/a rented room/beauty
  co-working. Talk to clients over Telegram, VKontakte, Instagram, and Avito.
  Want automation but won't pay 2000+ RUB/month for a heavy CRM (DIKIDI,
  YCLIENTS, Arnika, LokonCRM, Rubitime, i2crm).
- Your content pillars: боль мастера (ручная рутина, забытые клиенты) /
  продукт (a specific automation scenario) / выгода (time saved, clients
  retained) / обучение (CRM/automation explained simply, no jargon) / доверие
  (cases, numbers, reviews - only confirmed ones) / бренд (Cleopatra, the
  cat, Egypt, symbolism, philosophy) / lifestyle-aspiration (a master whose
  business runs calmer) / продажи (MVP, testing, signup - only with approved
  terms).

## 3. Hard rules (always / never)

- Always: friendly, warm tone (дружелюбный) throughout. No jargon at all -
  not just IT terms, any specialist/business jargon - the copy should read
  as plain, warm speech. Aesthetic, polished phrasing; Egyptian-brand
  flourishes (imagery, metaphors, a light ornamental touch) are welcome in
  the copy itself, not just in visuals. It is fine, and on-brand, to
  describe the product as an AI assistant/agent (the cat), or as a small
  team of AI agents working for the beauty master - that is the real
  product direction, confirmed by the founder. Address the master as an
  independent entrepreneur, never as "a girl who needs help." One natural
  product mention max per post.
- Never: promise a specific ruble figure or result without confirmed data
  and team sign-off. Never invent cases or numbers. No pressure/urgency
  framing ("супер-мега-инновационная AI-платформа" and the like - AI is
  fine to name, breathless hype language is not).

## 4. Links and CTA

- Primary link you point people to:
- Where it goes:
- Your CTA style:

## 5. Signature examples

Paste 2-4 of your own real Threads lines or posts that sound most like you. The
writing skills mirror the rhythm and word choice of these, not a generic voice.

-
-
-

## 6. Brand assets (for illustrations)

Used by the illustration step (`lib.illustrate`) to keep every generated image
on-brand via a pixel-exact overlay. All optional; leave blank to skip the overlay.

- Handle to stamp on images:
- Brand color (hex): #C9A24D (gold accent - reads clean as an overlay stamp on
  both the dark emerald and ivory backgrounds below; never use the gold as a
  large fill)
- Logo: (path or Pixfaro `logo_id` - not generated yet). Concept: an elegant
  Cleopatra profile in a thin gold outline, set against an ivory or
  dark-emerald ground.
- Overlay position: (e.g. bottom-right)
- Visual style default: premium luxury beauty, Cleopatra aesthetic - see full
  brand palette and style rules below.

### Full palette

| Color | Hex | Role |
|---|---|---|
| Dark emerald | `#114B4E` | Primary |
| Medium emerald | `#8DA79E` | Secondary |
| Light emerald | `#AFC7BE` | Secondary |
| Gold | `#C9A24D` | Accent only - never a dominant fill |
| Ivory | `#F7F3EC` | Background |
| Warm cream | `#EFE7DA` | Background |
| Graphite | `#222222` | Text/line |

Approved combinations: dark emerald + gold; light emerald + dark emerald;
ivory + gold. Avoid large gold elements on a light-emerald background.

### Style rules

Premium, minimalist, feminine, intelligent - luxury beauty or fine-jewelry
production values, not a costume-shop take on Ancient Egypt. Thin gold
linework; Cleopatra symbolism (lotus, Eye of Horus, ankh, Egyptian ornament
motifs) used sparingly, never kitsch. Every image should carry a sense of
care, status, beauty, and trust.

### Cat anatomy requirements (mandatory in every illustration prompt)

Image models routinely mangle cat anatomy. Every prompt for the Кот Клеопатры
character must spell this out explicitly, every time, not assume the model
gets it right by default:

- Exactly four legs and four paws, anatomically correct and proportional.
- No extra or duplicated limbs, paws, tails, or digits.
- Natural, physically plausible paw and limb positioning and resting pose
  (no impossible bends, no limbs merging into objects or into each other).
- Realistic cat anatomy overall: proportions, joints, and posture should
  read as a real cat, not a stylized/deformed one.
- If the generated result shows any of the above faults, regenerate or
  `refine` rather than shipping it as-is.
