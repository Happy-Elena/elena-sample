---
name: vanta
description: Add an animated 3D background to a hero section with Vanta.js (tengbao/vanta v0.5.24, three.js/p5): NET, WAVES, FOG, BIRDS, GLOBE, HALO, CLOUDS, DOTS, RINGS, CELLS, TOPOLOGY, TRUNK, RIPPLE. Use when the user wants an animated hero or main screen background, "анимация главного экрана", or vantajs.com effects. Not for scroll animations (use gsap) or smooth scroll (use lenis).
---

# Vanta: animated hero background

Vanta appends a WebGL (three.js) or p5.js canvas as the background of any element;
the element's other children stay in front as normal content. MIT license.
About 120 KB gzipped (mostly three.js), usually lighter than a background video.

- Repo: https://github.com/tengbao/vanta (v0.5.24, last release Jan 2023)
- Gallery + live option editor: https://www.vantajs.com (tune there, copy the options)

## 1. Install

**Script tags (most reliable).** Vanta's builds read a global `THREE`, and the
newest three.js no longer ships a UMD global build, so pin **three r134**, the
version Vanta 0.5.24 targets:

```html
<script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r134/three.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/vanta@0.5.24/dist/vanta.net.min.js"></script>
<script>
  const vanta = VANTA.NET({ el: '#hero' })
</script>
```

p5-based effects (TOPOLOGY, TRUNK) need p5 instead of three:

```html
<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.1.9/p5.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/vanta@0.5.24/dist/vanta.topology.min.js"></script>
```

**npm:**

```bash
npm i vanta three@0.134.0
```

```js
import * as THREE from 'three'
import NET from 'vanta/dist/vanta.net.min'
const effect = NET({ el: heroEl, THREE })   // pass THREE explicitly
```

Newer `three` versions mostly work for NET/WAVES/DOTS/GLOBE/BIRDS, but HALO uses
`THREE.RGBFormat` (removed in r137) and breaks. If you upgrade three, test each effect.

## 2. Markup

```html
<section id="hero" class="hero">
  <div class="hero__content">
    <h1>Headline</h1>
    <a class="btn" href="#pricing">Get started</a>
  </div>
</section>
```

```css
.hero { position: relative; min-height: 100svh; background: #0b1020; /* fallback color = effect bg */ }
.hero__content { position: relative; z-index: 1; }
```

The canvas takes the element's size. For fullscreen, make the element fullscreen.
Set a CSS background matching `backgroundColor` so there is no flash before WebGL starts.

## 3. Effects and their options

Common options for all: `el` (required), `mouseControls: true`, `touchControls: true`,
`gyroControls: false`, `minHeight: 200`, `minWidth: 200`, `scale: 1`, `scaleMobile: 1`.
Colors are hex numbers: `0xff3f81`, not strings.

| Effect | Renderer | Look | Key options (defaults) |
|---|---|---|---|
| `NET` | three | Connected points mesh, tech/SaaS | `color 0xff3f81`, `backgroundColor 0x23153c`, `points 10`, `maxDistance 20`, `spacing 15`, `showDots true` |
| `WAVES` | three | Liquid surface, calm premium | `color 0x005588`, `shininess 30`, `waveHeight 15`, `waveSpeed 1`, `zoom 1` |
| `FOG` | three (shader) | Soft gradient fog, beauty/wellness | `highlightColor 0xffc300`, `midtoneColor 0xff1f00`, `lowlightColor 0x2d00ff`, `baseColor 0xffebeb`, `blurFactor 0.6`, `speed 1`, `zoom 1` |
| `BIRDS` | three | Flocking birds | `backgroundColor 0x07192f`, `color1 0xff0000`, `color2 0x00d1ff`, `colorMode 'varianceGradient'`, `birdSize 1`, `wingSpan 30`, `speedLimit 5`, `separation 20`, `alignment 20`, `cohesion 20`, `quantity 5` (2..5) |
| `GLOBE` | three | Rotating network globe | `color 0xff3f81`, `color2 0xffffff`, `size 1`, `backgroundColor 0x23153c`, `points 10`, `maxDistance 20`, `spacing 15`, `showDots true` |
| `HALO` | three (shader) | Glowing ring/portal | `baseColor 0x001a59`, `color2 0xf2e735`, `backgroundColor 0x131a43`, `amplitudeFactor 1`, `ringFactor 1`, `rotationFactor 1`, `xOffset 0`, `yOffset 0`, `size 1`, `speed 1` |
| `CLOUDS` | three (shader) | Sky with sun | `skyColor 0x68b8d7`, `cloudColor 0xadc1de`, `cloudShadowColor 0x183550`, `sunColor 0xff9919`, `sunGlareColor 0xff6633`, `sunlightColor 0xff9933`, `speed 1` |
| `DOTS` | three | Dot field perspective | `color 0xff8820`, `color2 0xff8820`, `backgroundColor 0x222222`, `size 3`, `spacing 35`, `showLines true` |
| `RINGS` | three | Concentric arcs | `backgroundColor 0x202428`, `color 0x88ff00` |
| `CELLS` | three (shader) | Organic cells | `color1 0x008c8c`, `color2 0xf2e735`, `size 1.5`, `speed 1` |
| `RIPPLE` | three (shader) | Water ripples | `color1 0x060b25`, `color2 0xffffff`, `backgroundColor 0xf6f6f6`, `amplitudeFactor 1`, `ringFactor 4`, `rotationFactor 0.1`, `speed 1` |
| `TOPOLOGY` | p5 | Flow-field lines | `color 0x89964e`, `backgroundColor 0x002222` |
| `TRUNK` | p5 | Growing organic rings | `color 0x98465f`, `backgroundColor 0x222426`, `spacing 0`, `chaos 1` |

(`CLOUDS2` also exists but needs a `texturePath` to a noise image; skip unless asked.)

Example matched to a brand:

```js
VANTA.FOG({
  el: '#hero',
  highlightColor: 0xf7d6e0, midtoneColor: 0xe8a0bf, lowlightColor: 0xb47ead,
  baseColor: 0xfff5f8, blurFactor: 0.7, speed: 0.8, zoom: 0.9,
})
```

## 4. Lifecycle

```js
const effect = VANTA.WAVES({ el: '#hero', color: 0x112244 })
effect.setOptions({ color: 0xff88cc })   // live update (theme switch)
effect.resize()                          // after the container changes size without a window resize
effect.destroy()                         // SPA route change / unmount: ALWAYS do this
```

React:

```jsx
import { useEffect, useRef } from 'react'
import * as THREE from 'three'
import NET from 'vanta/dist/vanta.net.min'

export function Hero({ children }) {
  const ref = useRef(null)
  useEffect(() => {
    const effect = NET({ el: ref.current, THREE, color: 0x7c5cff, backgroundColor: 0x0b1020 })
    return () => effect.destroy()
  }, [])
  return <section ref={ref} className="hero">{children}</section>
}
```

Next.js: Vanta touches `window`, so use `'use client'` and/or `dynamic(() => import('./Hero'), { ssr: false })`.

## 5. Performance and accessibility (do this on production sites)

```js
const reduce = matchMedia('(prefers-reduced-motion: reduce)').matches
const small = matchMedia('(max-width: 768px)').matches
let effect = null
if (!reduce) {
  effect = VANTA.NET({ el: '#hero', scale: 1, scaleMobile: 1, points: small ? 6 : 10 })
}
// Pause the GPU when the hero is off screen
new IntersectionObserver(([e]) => {
  if (!effect && e.isIntersecting && !reduce) effect = VANTA.NET({ el: '#hero' })
  if (effect && !e.isIntersecting) { effect.destroy(); effect = null }
}).observe(document.querySelector('#hero'))
```

- One Vanta instance per page. Each is a full WebGL context.
- Shader effects (FOG, CLOUDS, HALO, CELLS, RIPPLE) are heaviest; on mobile raise
  `scaleMobile` (renders at lower resolution, e.g. 4) or show a static gradient.
- Keep text readable: add an overlay `background: linear-gradient(...)` on
  `.hero__content` or lower contrast colors.
- Respect `prefers-reduced-motion`: show the CSS background color/gradient only.

## 6. With GSAP and Lenis

Vanta runs its own render loop; nothing to sync. Typical combo: GSAP fades the
hero copy in over the Vanta background, and a ScrollTrigger fades/scales the hero
out on scroll:

```js
gsap.to('#hero .hero__content', {
  yPercent: -30, autoAlpha: 0, ease: 'none',
  scrollTrigger: { trigger: '#hero', start: 'top top', end: 'bottom top', scrub: true },
})
```

Full skeleton: `../gsap/templates/landing-starter.html`.

## 7. Checklist

1. three r134 (or p5 1.1.9 for TOPOLOGY/TRUNK) loaded **before** the Vanta file, or `THREE` passed in.
2. Container has explicit height and a matching CSS background color.
3. Content wrapper has `position: relative; z-index: 1`.
4. `destroy()` on unmount / off screen; reduced-motion fallback.
5. Tested on a mid-range phone.
