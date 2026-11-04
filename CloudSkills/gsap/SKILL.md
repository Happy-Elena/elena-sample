---
name: gsap
description: Build web animations with GSAP 3.15 (greensock/GSAP): tweens, timelines, ScrollTrigger (pin, scrub, parallax, horizontal scroll), SplitText text reveals, Flip, matchMedia and React useGSAP. Use when the user wants scroll animations, animated landing pages, text reveals, "анимации", parallax or motion design in code. Not for smooth scroll alone (use lenis) or WebGL hero backgrounds (use vanta).
---

# GSAP: animation of any complexity

GSAP is 100% free (including every former "bonus" plugin: SplitText, MorphSVG,
DrawSVG, ScrollSmoother, Inertia...), even for commercial use, under GreenSock's
standard no-charge license. Framework-agnostic, zero dependencies.

- Repo: https://github.com/greensock/GSAP (current: v3.15.1)
- Docs: https://gsap.com/docs/v3 . Cheatsheet: https://gsap.com/cheatsheet

## 1. Install

```bash
npm i gsap            # React: also npm i @gsap/react
```

```js
import gsap from 'gsap'
import { ScrollTrigger } from 'gsap/ScrollTrigger'
import { SplitText } from 'gsap/SplitText'
gsap.registerPlugin(ScrollTrigger, SplitText)   // register every plugin once
```

No build step (pin the version):

```html
<script src="https://cdn.jsdelivr.net/npm/gsap@3.15.1/dist/gsap.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/gsap@3.15.1/dist/ScrollTrigger.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/gsap@3.15.1/dist/SplitText.min.js"></script>
```

## 2. Core

```js
gsap.to('.box', { x: 200, rotation: 360, duration: 1, ease: 'power3.out' })
gsap.from('.card', { y: 60, autoAlpha: 0, stagger: 0.1 })     // animate IN from these values
gsap.fromTo('.bar', { scaleX: 0 }, { scaleX: 1, transformOrigin: 'left center' })
gsap.set('.hero', { autoAlpha: 1 })                           // instant
```

Rules of thumb:
- Animate **transforms and opacity** (`x, y, xPercent, scale, rotation, autoAlpha`),
  not `top/left/width/height`. GPU friendly, no layout thrash.
- `autoAlpha` = opacity + `visibility:hidden` at 0. Use it for fade-ins.
- Default ease is `power1.out`. Good set: `power2/3/4.out`, `expo.out`, `back.out(1.7)`,
  `elastic.out(1, 0.4)`, `none` (for scrub).
- `stagger: 0.08` or `stagger: { each: 0.08, from: 'center', grid: 'auto' }`.
- Relative values: `x: '+=100'`. Function values: `y: (i) => i * 20`.
- `repeat: -1, yoyo: true` for loops. `overwrite: 'auto'` for frequently retriggered tweens.
- `gsap.defaults({ ease: 'power3.out', duration: 0.8 })` once per project.

Prevent the flash of un-animated content (FOUC) for `from()` intros:

```css
.reveal { visibility: hidden; }   /* gsap.from(..., { autoAlpha: 0 }) un-hides it */
```

## 3. Timelines (sequencing)

```js
const tl = gsap.timeline({ defaults: { duration: 0.8, ease: 'power3.out' } })
tl.from('.logo', { y: -30, autoAlpha: 0 })
  .from('.nav a', { y: -20, autoAlpha: 0, stagger: 0.05 }, '-=0.4') // overlap 0.4s
  .from('h1', { y: 80, autoAlpha: 0 }, '<')                           // same start as previous
  .from('.cta', { scale: 0.8, autoAlpha: 0 }, '+=0.2')                // 0.2s gap
  .addLabel('done')

tl.play(); tl.pause(); tl.reverse(); tl.seek('done'); tl.timeScale(2); tl.progress(0.5)
```

Position parameter: `'<'` start of previous, `'>'` end of previous, `'-=0.3'`,
`'+=0.3'`, `'label'`, `'label+=0.5'`, absolute seconds `1.2`.

## 4. ScrollTrigger

```js
gsap.from('.feature', {
  y: 80, autoAlpha: 0, stagger: 0.15,
  scrollTrigger: {
    trigger: '.features',
    start: 'top 80%',        // [trigger edge] [viewport edge]
    end: 'bottom 20%',
    toggleActions: 'play none none reverse', // onEnter onLeave onEnterBack onLeaveBack
    // markers: true,        // debug only, remove before shipping
  },
})
```

**Batch reveal** for many repeated elements (cheaper than one trigger each):

```js
ScrollTrigger.batch('.reveal', {
  start: 'top 85%',
  onEnter: (els) => gsap.to(els, { autoAlpha: 1, y: 0, stagger: 0.1, overwrite: true }),
})
gsap.set('.reveal', { y: 40 })
```

**Scrub** (animation progress glued to scroll) + **pin**:

```js
const tl = gsap.timeline({
  scrollTrigger: {
    trigger: '.story',
    start: 'top top',
    end: '+=200%',     // pinned for 2 screens of scrolling
    scrub: 1,          // true = locked; number = seconds of catch-up smoothing
    pin: true,
    anticipatePin: 1,
  },
})
tl.to('.story img', { scale: 1.3, ease: 'none' })
  .to('.story h2', { yPercent: -100, autoAlpha: 0, ease: 'none' }, '<')
```

**Parallax**:

```js
gsap.utils.toArray('[data-speed]').forEach((el) => {
  gsap.to(el, {
    yPercent: () => -20 * parseFloat(el.dataset.speed),
    ease: 'none',
    scrollTrigger: { trigger: el, start: 'top bottom', end: 'bottom top', scrub: true },
  })
})
```

**Horizontal scroll section**:

```js
const track = document.querySelector('.h-track')
gsap.to(track, {
  x: () => -(track.scrollWidth - window.innerWidth),
  ease: 'none',
  scrollTrigger: {
    trigger: '.h-section', pin: true, scrub: 1,
    end: () => '+=' + (track.scrollWidth - window.innerWidth),
    invalidateOnRefresh: true,
  },
})
```

Other useful bits: `snap: 1 / (sections - 1)`, `onUpdate: (self) => self.progress`,
`toggleClass: 'is-active'`, `ScrollTrigger.refresh()` after images/fonts change
layout, `ScrollTrigger.create({...})` for callbacks without a tween,
`containerAnimation` for triggers inside a horizontal-scroll tween.

Pitfalls:
- Create triggers **top to bottom** in page order, or call `ScrollTrigger.sort()`.
- Never put `scrollTrigger` on tweens *inside* a timeline. Put it on the timeline.
- Use `ease: 'none'` with scrub.
- Don't animate the pinned element itself with transforms that fight the pin; animate its children.
- Smooth scroll: use **Lenis** (see `../lenis/SKILL.md`, setup B) or GSAP's own
  ScrollSmoother, never both.

## 5. SplitText (text reveals)

```js
document.fonts.ready.then(() => {
  SplitText.create('.headline', {
    type: 'lines, words',
    mask: 'lines',            // wraps each line in overflow:clip for the "slide up from mask" look
    autoSplit: true,          // re-split on resize/font load; requires onSplit
    onSplit(self) {
      return gsap.from(self.lines, {   // return the animation so it is reverted/re-run on re-split
        yPercent: 100, duration: 0.9, stagger: 0.08, ease: 'expo.out',
        scrollTrigger: { trigger: self.elements[0], start: 'top 85%' },
      })
    },
  })
})
```

`type`: any of `chars, words, lines`. Accessibility: by default it sets
`aria-label` on the parent and `aria-hidden` on the pieces (`aria: 'auto'`).
Call `split.revert()` when done if you no longer need the spans.

## 6. Responsive and reduced motion: gsap.matchMedia()

```js
const mm = gsap.matchMedia()
mm.add({
  isDesktop: '(min-width: 800px)',
  isMobile: '(max-width: 799px)',
  reduce: '(prefers-reduced-motion: reduce)',
}, (ctx) => {
  const { isDesktop, reduce } = ctx.conditions
  if (reduce) { gsap.set('.reveal', { autoAlpha: 1 }); return }
  gsap.to('.panel', { x: isDesktop ? 400 : 100, scrollTrigger: { trigger: '.panel', scrub: true } })
  return () => {} // optional extra cleanup; animations/triggers created here auto-revert
})
```

Always provide the reduced-motion branch on production sites.

## 7. React

```jsx
import { useRef } from 'react'
import gsap from 'gsap'
import { useGSAP } from '@gsap/react'
import { ScrollTrigger } from 'gsap/ScrollTrigger'
gsap.registerPlugin(useGSAP, ScrollTrigger)

export function Hero() {
  const root = useRef(null)
  useGSAP(() => {
    gsap.from('.title', { y: 60, autoAlpha: 0 })          // selectors scoped to root
  }, { scope: root })                                      // auto-reverts on unmount
  const { contextSafe } = useGSAP({ scope: root })
  const onClick = contextSafe(() => gsap.to('.title', { rotation: '+=360' })) // event handlers
  return <section ref={root}><h1 className="title">Hi</h1><button onClick={onClick}>spin</button></section>
}
```

Next.js: add `'use client'` to components using GSAP. Vanilla SPAs: wrap setup in
`const ctx = gsap.context(() => {...}, rootEl)` and call `ctx.revert()` on teardown.

## 8. Other plugins worth knowing (all free)

| Plugin | For |
|---|---|
| `Flip` | Animate layout changes (grid reorder, card to modal): `const s = Flip.getState(els); /* change DOM */ Flip.from(s, { duration: 0.6, ease: 'power2.inOut' })` |
| `ScrollToPlugin` | `gsap.to(window, { scrollTo: '#id' })` (with Lenis use `lenis.scrollTo` instead) |
| `Observer` | Wheel/touch/pointer gestures for fullscreen "slide" sites |
| `Draggable` + `InertiaPlugin` | Drag sliders with momentum |
| `MotionPathPlugin` | Move along an SVG path |
| `DrawSVGPlugin`, `MorphSVGPlugin` | Line drawing, shape morphing |
| `ScrambleTextPlugin`, `TextPlugin` | Text decoding / typing effects |
| `CustomEase` | Brand-specific easing curves |

Utilities: `gsap.utils.toArray, clamp, mapRange, interpolate, random, wrap, snap`,
`gsap.quickTo(el, 'x', { duration: 0.4 })` for cursor followers.

## 9. Checklist before handing over

1. Plugins registered once; versions pinned.
2. Only transforms/opacity animated; FOUC prevented with `visibility:hidden` + `autoAlpha`.
3. `markers: true` removed.
4. `ScrollTrigger.refresh()` after late-loading images/fonts (or set image dimensions).
5. `gsap.matchMedia()` with a `prefers-reduced-motion` branch.
6. Cleanup: `useGSAP` / `gsap.context().revert()` on unmount.
7. Tested on mobile (pins + address bar resize: consider `ScrollTrigger.config({ ignoreMobileResize: true })`).

Starter page wiring Lenis + GSAP + SplitText + Vanta: `templates/landing-starter.html`.
