---
name: lenis
description: Add Lenis smooth scrolling (darkroomengineering/lenis v1.3) to a website or landing page, incl. the GSAP ScrollTrigger sync, anchors, modals, nested scroll and React/Vue setup. Use when the user asks for smooth scroll, inertial or buttery scrolling, "плавный скролл", or scroll that feels like an award site. Not for scroll-driven animations themselves (use gsap) or hero backgrounds (use vanta).
---

# Lenis: smooth scroll

Lenis replaces the browser's stepped wheel scroll with an interpolated one while
keeping native scroll (position: sticky, `window.scrollY`, IntersectionObserver
all keep working). MIT license, zero dependencies, a few KB.

- Repo: https://github.com/darkroomengineering/lenis (current: v1.3.27)
- Demo / showcase: https://lenis.dev

## 1. Install

```bash
npm i lenis
```

```js
import Lenis from 'lenis'
import 'lenis/dist/lenis.css'
```

No build step (pin the version):

```html
<link rel="stylesheet" href="https://unpkg.com/lenis@1.3.27/dist/lenis.css">
<script src="https://unpkg.com/lenis@1.3.27/dist/lenis.min.js"></script>
```

**Always include `lenis.css`.** Most "Lenis is broken" reports are a missing
stylesheet (it sets `html.lenis { height:auto }`, stops scroll when stopped,
disables pointer events on iframes during smoothing).

## 2. Pick ONE setup

### A. Standalone (no GSAP)

```js
const lenis = new Lenis({ autoRaf: true, anchors: true })
```

### B. With GSAP ScrollTrigger (the usual case for animated landings)

Drive Lenis from GSAP's ticker so both run on the same frame. Do **not** also set
`autoRaf: true`, or Lenis gets stepped twice per frame.

```js
gsap.registerPlugin(ScrollTrigger)

const lenis = new Lenis({ anchors: true })
lenis.on('scroll', ScrollTrigger.update)
gsap.ticker.add((time) => lenis.raf(time * 1000)) // GSAP time is seconds, Lenis wants ms
gsap.ticker.lagSmoothing(0)
```

### C. Own rAF loop (WebGL/three.js render loop)

```js
const lenis = new Lenis()
function raf(time) {
  lenis.raf(time)
  // renderer.render(scene, camera)
  requestAnimationFrame(raf)
}
requestAnimationFrame(raf)
```

### D. One-liner for static sites

```html
<script>new Lenis({ autoRaf: true, autoToggle: true, anchors: true, allowNestedScroll: true, naiveDimensions: true, stopInertiaOnNavigate: true })</script>
```

## 3. Options that matter

| Option | Default | Use it for |
|---|---|---|
| `lerp` | `0.1` | Smoothness. Lower = floatier (0.05), higher = snappier (0.15). Overrides `duration`/`easing`. |
| `duration` + `easing` | `1.2`, expo-out | Time-based feel instead of lerp. Only applies if `lerp` is not set. |
| `wheelMultiplier` / `touchMultiplier` | `1` | Scroll speed. |
| `smoothWheel` | `true` | Smooth mouse wheel. |
| `syncTouch` | `false` | Smooth touch too. Off by default on purpose: native touch inertia feels better; unstable on iOS < 16. |
| `anchors` | `false` | `true` or `{ offset: -80 }` to make `href="#id"` links smooth-scroll (offset for a fixed header). |
| `allowNestedScroll` | `false` | Let inner scrollable boxes scroll natively. Costs a DOM walk per event; prefer `data-lenis-prevent` on big pages. |
| `prevent` | none | `(node) => node.classList.contains('modal')` to skip smoothing over some elements. |
| `autoToggle` | `false` | Auto stop/start when the wrapper gets `overflow:hidden` (needs lenis.css, modern browsers). |
| `orientation` / `gestureOrientation` | `vertical` | Horizontal scroll sites: `orientation: 'horizontal', gestureOrientation: 'both'`. |
| `infinite` | `false` | Looping page; needs `syncTouch: true` on touch. |
| `wrapper` / `content` | `window` / `<html>` | Smooth-scroll a specific container instead of the page. |
| `respectReducedMotion` | `true` | Keep it on. With `prefers-reduced-motion: reduce` scroll becomes 1:1 and `scrollTo` jumps. |

## 4. API

```js
lenis.scrollTo('#pricing', { offset: -80, duration: 1.4 })
lenis.scrollTo(0, { immediate: true })          // jump
lenis.scrollTo('bottom', { lock: true, onComplete: () => {} })
lenis.stop()    // open modal / menu: freeze page scroll
lenis.start()   // close it
lenis.resize()  // only if autoResize: false
lenis.destroy() // SPA route change / component unmount

lenis.on('scroll', ({ scroll, limit, velocity, direction, progress }) => {})
```

Useful read-only props: `scroll`, `progress` (0..1), `velocity`, `direction`
(1 down, -1 up), `isScrolling`, `isStopped`.

Velocity-driven effect (skew on fast scroll), cheap and popular:

```js
lenis.on('scroll', ({ velocity }) => {
  gsap.to('.card', { skewY: velocity * 0.15, overwrite: true, duration: 0.3 })
})
```

## 5. Nested scroll, modals, iframes

```html
<div class="modal-body" data-lenis-prevent>...</div>
```

Also: `data-lenis-prevent-wheel`, `-touch`, `-vertical`, `-horizontal`.
Modal pattern: `lenis.stop()` on open, `lenis.start()` on close, and put
`data-lenis-prevent` on the modal's scrollable area.

## 6. Frameworks

**React**: `npm i lenis` then use the bundled wrapper:

```jsx
import { ReactLenis, useLenis } from 'lenis/react'

export default function Layout({ children }) {
  return <ReactLenis root options={{ lerp: 0.1, anchors: true }}>{children}</ReactLenis>
}
// inside any child: const lenis = useLenis(({ scroll }) => {})
```

With GSAP in React, pass `autoRaf: false` in `options`, grab the instance via a
ref (`ref.current?.lenis`) and add it to `gsap.ticker` in a `useEffect`, removing
it in cleanup.

**Vue / Nuxt**: `lenis/vue` exports `VueLenis` and `useLenis` with the same shape.

**Snap**: CSS `scroll-snap` does not work with Lenis. Use `lenis/snap`.

## 7. Limitations and checklist

- Safari caps rAF at 60fps (30 in Low Power Mode). Not a bug in your code.
- Wheel over an `<iframe>` (YouTube, maps) is not smoothed; lenis.css disables
  iframe pointer events only while smoothing.
- Don't combine with `scroll-behavior: smooth` in CSS or with GSAP ScrollSmoother.
  One smoother per page.

Before you hand it over:
1. `lenis.css` included.
2. Exactly one driver: `autoRaf` **or** `gsap.ticker` **or** your rAF loop.
3. With ScrollTrigger: `lenis.on('scroll', ScrollTrigger.update)` and `lagSmoothing(0)`.
4. Fixed header: `anchors: { offset: -headerHeight }`.
5. Modals: `stop()/start()` + `data-lenis-prevent`.
6. SPA: `destroy()` on unmount.

For a full landing page skeleton wiring Lenis + GSAP + Vanta together, see
`../gsap/templates/landing-starter.html`.
