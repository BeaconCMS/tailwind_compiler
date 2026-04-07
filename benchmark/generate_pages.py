#!/usr/bin/env python3
"""
Generate 120 realistic HTML pages using diverse Tailwind CSS v4 classes
for benchmarking the Beacon CSS Compiler.

Goal: 2000-3000+ unique classes across all pages, each page using 30-80 unique classes.
Covers ALL Tailwind categories: layout, spacing, sizing, typography, colors, borders,
shadows, rings, transforms, transitions, gradients, grid, flex, arbitrary values,
responsive variants, state variants, before/after pseudo-elements, and more.
"""

import os
import random

OUTPUT_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "pages")

# ---------------------------------------------------------------------------
# Class pools organized by category
# ---------------------------------------------------------------------------

LAYOUT = [
    "block", "inline-block", "inline", "flex", "inline-flex", "grid", "inline-grid",
    "hidden", "contents", "flow-root", "table", "table-row", "table-cell",
    "static", "fixed", "absolute", "relative", "sticky",
    "top-0", "right-0", "bottom-0", "left-0", "inset-0",
    "top-1/2", "left-1/2", "-translate-x-1/2", "-translate-y-1/2",
    "top-4", "right-4", "bottom-4", "left-4", "inset-x-0", "inset-y-0",
    "z-0", "z-10", "z-20", "z-30", "z-40", "z-50", "z-auto",
    "float-right", "float-left", "float-none", "clear-both",
    "isolate", "isolation-auto",
    "object-contain", "object-cover", "object-fill", "object-none", "object-scale-down",
    "object-center", "object-top", "object-bottom",
    "overflow-auto", "overflow-hidden", "overflow-visible", "overflow-scroll",
    "overflow-x-auto", "overflow-y-auto", "overflow-x-hidden", "overflow-y-hidden",
    "overscroll-auto", "overscroll-contain", "overscroll-none",
    "visible", "invisible", "collapse",
]

FLEXBOX = [
    "flex-row", "flex-row-reverse", "flex-col", "flex-col-reverse",
    "flex-wrap", "flex-wrap-reverse", "flex-nowrap",
    "flex-1", "flex-auto", "flex-initial", "flex-none",
    "grow", "grow-0", "shrink", "shrink-0",
    "justify-start", "justify-end", "justify-center", "justify-between", "justify-around", "justify-evenly",
    "items-start", "items-end", "items-center", "items-baseline", "items-stretch",
    "self-auto", "self-start", "self-end", "self-center", "self-stretch", "self-baseline",
    "content-start", "content-end", "content-center", "content-between", "content-around",
    "order-1", "order-2", "order-3", "order-first", "order-last", "order-none",
    "basis-0", "basis-1/2", "basis-full", "basis-auto",
]

GRID = [
    "grid-cols-1", "grid-cols-2", "grid-cols-3", "grid-cols-4", "grid-cols-5",
    "grid-cols-6", "grid-cols-12", "grid-cols-none",
    "grid-rows-1", "grid-rows-2", "grid-rows-3", "grid-rows-4", "grid-rows-6", "grid-rows-none",
    "col-span-1", "col-span-2", "col-span-3", "col-span-4", "col-span-6", "col-span-full",
    "col-start-1", "col-start-2", "col-start-3", "col-end-3", "col-end-4",
    "row-span-1", "row-span-2", "row-span-3", "row-span-full",
    "row-start-1", "row-start-2", "row-end-3",
    "auto-cols-auto", "auto-cols-min", "auto-cols-max", "auto-cols-fr",
    "auto-rows-auto", "auto-rows-min", "auto-rows-max", "auto-rows-fr",
    "grid-flow-row", "grid-flow-col", "grid-flow-dense", "grid-flow-row-dense",
]

GAP = [
    "gap-0", "gap-1", "gap-2", "gap-3", "gap-4", "gap-5", "gap-6", "gap-8", "gap-10", "gap-12",
    "gap-x-2", "gap-x-4", "gap-x-6", "gap-x-8",
    "gap-y-2", "gap-y-4", "gap-y-6", "gap-y-8",
]

SPACING_MARGIN = [
    "m-0", "m-1", "m-2", "m-3", "m-4", "m-5", "m-6", "m-8", "m-10", "m-12", "m-16", "m-auto",
    "mx-auto", "mx-2", "mx-4", "mx-6", "mx-8",
    "my-2", "my-4", "my-6", "my-8", "my-10", "my-12", "my-16",
    "mt-0", "mt-1", "mt-2", "mt-4", "mt-6", "mt-8", "mt-10", "mt-12", "mt-16", "mt-auto",
    "mr-2", "mr-4", "mr-auto",
    "mb-0", "mb-1", "mb-2", "mb-4", "mb-6", "mb-8", "mb-10", "mb-12", "mb-16",
    "ml-2", "ml-4", "ml-auto",
    "-mt-1", "-mt-2", "-mt-4", "-mb-2", "-ml-1", "-mr-1",
    "ms-2", "ms-4", "me-2", "me-4",
]

SPACING_PADDING = [
    "p-0", "p-1", "p-2", "p-3", "p-4", "p-5", "p-6", "p-8", "p-10", "p-12", "p-16",
    "px-2", "px-3", "px-4", "px-5", "px-6", "px-8", "px-10", "px-12",
    "py-1", "py-2", "py-3", "py-4", "py-5", "py-6", "py-8", "py-10", "py-12", "py-16",
    "pt-2", "pt-4", "pt-6", "pt-8", "pt-10", "pt-16",
    "pr-2", "pr-4", "pr-6",
    "pb-2", "pb-4", "pb-6", "pb-8", "pb-10",
    "pl-2", "pl-4", "pl-6",
    "ps-2", "ps-4", "pe-2", "pe-4",
]

SIZING = [
    "w-0", "w-1", "w-2", "w-4", "w-6", "w-8", "w-10", "w-12", "w-16", "w-20", "w-24",
    "w-32", "w-40", "w-48", "w-56", "w-64", "w-72", "w-80", "w-96",
    "w-auto", "w-1/2", "w-1/3", "w-2/3", "w-1/4", "w-3/4", "w-1/5", "w-2/5", "w-3/5",
    "w-full", "w-screen", "w-min", "w-max", "w-fit",
    "h-0", "h-1", "h-2", "h-4", "h-6", "h-8", "h-10", "h-12", "h-16", "h-20", "h-24",
    "h-32", "h-40", "h-48", "h-56", "h-64", "h-72", "h-80", "h-96",
    "h-auto", "h-1/2", "h-1/3", "h-full", "h-screen", "h-min", "h-max", "h-fit",
    "min-w-0", "min-w-full", "min-w-min", "min-w-max", "min-w-fit",
    "max-w-xs", "max-w-sm", "max-w-md", "max-w-lg", "max-w-xl", "max-w-2xl",
    "max-w-3xl", "max-w-4xl", "max-w-5xl", "max-w-6xl", "max-w-7xl",
    "max-w-full", "max-w-prose", "max-w-screen-sm", "max-w-screen-md", "max-w-screen-lg",
    "max-w-none",
    "min-h-0", "min-h-full", "min-h-screen", "min-h-min", "min-h-max", "min-h-fit",
    "max-h-0", "max-h-full", "max-h-screen", "max-h-min", "max-h-max", "max-h-fit",
    "max-h-48", "max-h-64", "max-h-96",
    "size-4", "size-5", "size-6", "size-8", "size-10", "size-12", "size-16",
]

TYPOGRAPHY = [
    "font-sans", "font-serif", "font-mono",
    "text-xs", "text-sm", "text-base", "text-lg", "text-xl", "text-2xl", "text-3xl",
    "text-4xl", "text-5xl", "text-6xl", "text-7xl", "text-8xl", "text-9xl",
    "font-thin", "font-extralight", "font-light", "font-normal", "font-medium",
    "font-semibold", "font-bold", "font-extrabold", "font-black",
    "italic", "not-italic",
    "tracking-tighter", "tracking-tight", "tracking-normal", "tracking-wide",
    "tracking-wider", "tracking-widest",
    "leading-none", "leading-tight", "leading-snug", "leading-normal",
    "leading-relaxed", "leading-loose", "leading-3", "leading-4", "leading-5",
    "leading-6", "leading-7", "leading-8", "leading-9", "leading-10",
    "text-left", "text-center", "text-right", "text-justify", "text-start", "text-end",
    "underline", "overline", "line-through", "no-underline",
    "decoration-solid", "decoration-double", "decoration-dotted", "decoration-dashed", "decoration-wavy",
    "decoration-1", "decoration-2", "decoration-4",
    "underline-offset-1", "underline-offset-2", "underline-offset-4", "underline-offset-8", "underline-offset-auto",
    "uppercase", "lowercase", "capitalize", "normal-case",
    "truncate", "text-ellipsis", "text-clip",
    "text-wrap", "text-nowrap", "text-balance", "text-pretty",
    "indent-0", "indent-4", "indent-8",
    "align-baseline", "align-top", "align-middle", "align-bottom",
    "align-text-top", "align-text-bottom",
    "whitespace-normal", "whitespace-nowrap", "whitespace-pre", "whitespace-pre-line", "whitespace-pre-wrap",
    "break-normal", "break-words", "break-all", "break-keep",
    "hyphens-none", "hyphens-manual", "hyphens-auto",
    "antialiased", "subpixel-antialiased",
    "tabular-nums", "proportional-nums", "lining-nums", "oldstyle-nums",
    "ordinal", "slashed-zero",
    "list-none", "list-disc", "list-decimal",
    "list-inside", "list-outside",
]

COLORS_TEXT = [
    "text-transparent", "text-current", "text-inherit",
    "text-black", "text-white",
    "text-slate-50", "text-slate-100", "text-slate-200", "text-slate-300", "text-slate-400",
    "text-slate-500", "text-slate-600", "text-slate-700", "text-slate-800", "text-slate-900", "text-slate-950",
    "text-gray-50", "text-gray-100", "text-gray-200", "text-gray-300", "text-gray-400",
    "text-gray-500", "text-gray-600", "text-gray-700", "text-gray-800", "text-gray-900", "text-gray-950",
    "text-zinc-400", "text-zinc-500", "text-zinc-600", "text-zinc-700", "text-zinc-800", "text-zinc-900",
    "text-red-400", "text-red-500", "text-red-600", "text-red-700", "text-red-800",
    "text-orange-400", "text-orange-500", "text-orange-600",
    "text-amber-400", "text-amber-500", "text-amber-600",
    "text-yellow-400", "text-yellow-500", "text-yellow-600",
    "text-lime-400", "text-lime-500", "text-lime-600",
    "text-green-400", "text-green-500", "text-green-600", "text-green-700",
    "text-emerald-400", "text-emerald-500", "text-emerald-600",
    "text-teal-400", "text-teal-500", "text-teal-600",
    "text-cyan-400", "text-cyan-500", "text-cyan-600",
    "text-sky-400", "text-sky-500", "text-sky-600",
    "text-blue-400", "text-blue-500", "text-blue-600", "text-blue-700", "text-blue-800",
    "text-indigo-400", "text-indigo-500", "text-indigo-600",
    "text-violet-400", "text-violet-500", "text-violet-600",
    "text-purple-400", "text-purple-500", "text-purple-600",
    "text-fuchsia-400", "text-fuchsia-500", "text-fuchsia-600",
    "text-pink-400", "text-pink-500", "text-pink-600",
    "text-rose-400", "text-rose-500", "text-rose-600",
]

COLORS_BG = [
    "bg-transparent", "bg-current", "bg-inherit",
    "bg-black", "bg-white",
    "bg-slate-50", "bg-slate-100", "bg-slate-200", "bg-slate-300", "bg-slate-400",
    "bg-slate-500", "bg-slate-600", "bg-slate-700", "bg-slate-800", "bg-slate-900", "bg-slate-950",
    "bg-gray-50", "bg-gray-100", "bg-gray-200", "bg-gray-300", "bg-gray-400",
    "bg-gray-500", "bg-gray-600", "bg-gray-700", "bg-gray-800", "bg-gray-900", "bg-gray-950",
    "bg-zinc-50", "bg-zinc-100", "bg-zinc-800", "bg-zinc-900", "bg-zinc-950",
    "bg-red-50", "bg-red-100", "bg-red-200", "bg-red-400", "bg-red-500", "bg-red-600", "bg-red-700",
    "bg-orange-50", "bg-orange-100", "bg-orange-400", "bg-orange-500",
    "bg-amber-50", "bg-amber-100", "bg-amber-400", "bg-amber-500",
    "bg-yellow-50", "bg-yellow-100", "bg-yellow-400", "bg-yellow-500",
    "bg-lime-50", "bg-lime-100", "bg-lime-400", "bg-lime-500",
    "bg-green-50", "bg-green-100", "bg-green-400", "bg-green-500", "bg-green-600", "bg-green-700",
    "bg-emerald-50", "bg-emerald-100", "bg-emerald-400", "bg-emerald-500",
    "bg-teal-50", "bg-teal-100", "bg-teal-400", "bg-teal-500",
    "bg-cyan-50", "bg-cyan-100", "bg-cyan-400", "bg-cyan-500",
    "bg-sky-50", "bg-sky-100", "bg-sky-400", "bg-sky-500",
    "bg-blue-50", "bg-blue-100", "bg-blue-200", "bg-blue-400", "bg-blue-500", "bg-blue-600", "bg-blue-700",
    "bg-indigo-50", "bg-indigo-100", "bg-indigo-500", "bg-indigo-600", "bg-indigo-700",
    "bg-violet-50", "bg-violet-100", "bg-violet-500", "bg-violet-600",
    "bg-purple-50", "bg-purple-100", "bg-purple-500", "bg-purple-600",
    "bg-fuchsia-50", "bg-fuchsia-100", "bg-fuchsia-500",
    "bg-pink-50", "bg-pink-100", "bg-pink-500",
    "bg-rose-50", "bg-rose-100", "bg-rose-500",
]

OPACITY = [
    "opacity-0", "opacity-5", "opacity-10", "opacity-20", "opacity-25", "opacity-30",
    "opacity-40", "opacity-50", "opacity-60", "opacity-70", "opacity-75", "opacity-80",
    "opacity-90", "opacity-95", "opacity-100",
]

COLORS_WITH_OPACITY = [
    "bg-black/5", "bg-black/10", "bg-black/20", "bg-black/25", "bg-black/50", "bg-black/75",
    "bg-white/5", "bg-white/10", "bg-white/20", "bg-white/50", "bg-white/75", "bg-white/80", "bg-white/90",
    "text-black/50", "text-black/75", "text-white/50", "text-white/75", "text-white/80", "text-white/90",
    "bg-blue-500/10", "bg-blue-500/20", "bg-blue-500/50",
    "bg-red-500/10", "bg-red-500/20", "bg-red-500/50",
    "bg-green-500/10", "bg-green-500/20", "bg-green-500/50",
    "bg-indigo-500/10", "bg-indigo-500/20",
    "text-gray-900/80", "text-gray-600/90", "text-blue-600/80",
    "border-black/10", "border-black/20", "border-white/10", "border-white/20",
    "border-gray-200/50", "border-gray-300/50",
    "ring-black/5", "ring-black/10", "ring-black/20",
    "shadow-black/5", "shadow-black/10", "shadow-black/25",
    "divide-gray-200/50",
]

BORDERS = [
    "border", "border-0", "border-2", "border-4", "border-8",
    "border-t", "border-r", "border-b", "border-l",
    "border-t-0", "border-r-0", "border-b-0", "border-l-0",
    "border-t-2", "border-b-2", "border-l-2", "border-l-4",
    "border-x", "border-y", "border-x-0", "border-y-0",
    "border-solid", "border-dashed", "border-dotted", "border-double", "border-hidden", "border-none",
    "border-transparent", "border-current",
    "border-black", "border-white",
    "border-slate-200", "border-slate-300", "border-slate-400",
    "border-gray-100", "border-gray-200", "border-gray-300", "border-gray-400", "border-gray-500",
    "border-red-200", "border-red-300", "border-red-400", "border-red-500",
    "border-blue-200", "border-blue-300", "border-blue-400", "border-blue-500",
    "border-green-200", "border-green-300", "border-green-400", "border-green-500",
    "border-indigo-500", "border-violet-500", "border-purple-500",
    "border-amber-300", "border-yellow-300", "border-orange-300",
    "border-t-gray-200", "border-b-gray-200",
    "divide-x", "divide-y", "divide-x-2", "divide-y-2", "divide-x-0", "divide-y-0",
    "divide-gray-100", "divide-gray-200", "divide-gray-300",
    "divide-slate-200", "divide-dashed", "divide-dotted",
    "border-collapse", "border-separate",
    "border-spacing-0", "border-spacing-2", "border-spacing-4",
]

BORDER_RADIUS = [
    "rounded-none", "rounded-sm", "rounded", "rounded-md", "rounded-lg",
    "rounded-xl", "rounded-2xl", "rounded-3xl", "rounded-full",
    "rounded-t-none", "rounded-t-sm", "rounded-t-md", "rounded-t-lg", "rounded-t-xl", "rounded-t-2xl",
    "rounded-b-none", "rounded-b-sm", "rounded-b-md", "rounded-b-lg", "rounded-b-xl", "rounded-b-2xl",
    "rounded-l-none", "rounded-l-md", "rounded-l-lg", "rounded-l-xl",
    "rounded-r-none", "rounded-r-md", "rounded-r-lg", "rounded-r-xl",
    "rounded-tl-md", "rounded-tl-lg", "rounded-tl-xl",
    "rounded-tr-md", "rounded-tr-lg", "rounded-tr-xl",
    "rounded-bl-md", "rounded-bl-lg",
    "rounded-br-md", "rounded-br-lg",
    "rounded-ss-md", "rounded-ee-md",
]

SHADOWS = [
    "shadow-sm", "shadow", "shadow-md", "shadow-lg", "shadow-xl", "shadow-2xl",
    "shadow-inner", "shadow-none",
    "drop-shadow-sm", "drop-shadow", "drop-shadow-md", "drop-shadow-lg",
    "drop-shadow-xl", "drop-shadow-2xl", "drop-shadow-none",
]

RINGS = [
    "ring-0", "ring-1", "ring-2", "ring-4", "ring-8", "ring",
    "ring-inset",
    "ring-transparent", "ring-current",
    "ring-white", "ring-black",
    "ring-slate-200", "ring-slate-300", "ring-slate-400",
    "ring-gray-200", "ring-gray-300", "ring-gray-400",
    "ring-blue-400", "ring-blue-500", "ring-blue-600",
    "ring-red-400", "ring-red-500",
    "ring-green-400", "ring-green-500",
    "ring-indigo-500", "ring-violet-500",
    "ring-offset-0", "ring-offset-1", "ring-offset-2", "ring-offset-4",
    "ring-offset-white", "ring-offset-slate-50",
]

TRANSFORMS = [
    "scale-0", "scale-50", "scale-75", "scale-90", "scale-95", "scale-100", "scale-105", "scale-110", "scale-125", "scale-150",
    "scale-x-0", "scale-x-100", "scale-y-0", "scale-y-100",
    "rotate-0", "rotate-1", "rotate-2", "rotate-3", "rotate-6", "rotate-12",
    "rotate-45", "rotate-90", "rotate-180",
    "-rotate-1", "-rotate-2", "-rotate-3", "-rotate-6", "-rotate-12", "-rotate-45", "-rotate-90", "-rotate-180",
    "translate-x-0", "translate-x-1", "translate-x-2", "translate-x-4", "translate-x-8",
    "translate-x-1/2", "translate-x-full",
    "-translate-x-1", "-translate-x-2", "-translate-x-4", "-translate-x-1/2", "-translate-x-full",
    "translate-y-0", "translate-y-1", "translate-y-2", "translate-y-4", "translate-y-8",
    "translate-y-1/2", "translate-y-full",
    "-translate-y-1", "-translate-y-2", "-translate-y-4", "-translate-y-1/2", "-translate-y-full",
    "skew-x-0", "skew-x-1", "skew-x-2", "skew-x-3", "skew-x-6", "skew-x-12",
    "skew-y-0", "skew-y-1", "skew-y-2", "skew-y-3", "skew-y-6",
    "origin-center", "origin-top", "origin-top-right", "origin-right", "origin-bottom-right",
    "origin-bottom", "origin-bottom-left", "origin-left", "origin-top-left",
    "transform-gpu", "transform-none",
]

TRANSITIONS = [
    "transition-none", "transition-all", "transition", "transition-colors",
    "transition-opacity", "transition-shadow", "transition-transform",
    "duration-0", "duration-75", "duration-100", "duration-150", "duration-200",
    "duration-300", "duration-500", "duration-700", "duration-1000",
    "ease-linear", "ease-in", "ease-out", "ease-in-out",
    "delay-0", "delay-75", "delay-100", "delay-150", "delay-200", "delay-300", "delay-500", "delay-700", "delay-1000",
    "animate-none", "animate-spin", "animate-ping", "animate-pulse", "animate-bounce",
]

GRADIENTS = [
    "bg-gradient-to-t", "bg-gradient-to-tr", "bg-gradient-to-r", "bg-gradient-to-br",
    "bg-gradient-to-b", "bg-gradient-to-bl", "bg-gradient-to-l", "bg-gradient-to-tl",
    "from-transparent", "from-current",
    "from-black", "from-white",
    "from-slate-100", "from-slate-500", "from-slate-900",
    "from-gray-100", "from-gray-500", "from-gray-900",
    "from-red-400", "from-red-500", "from-red-600",
    "from-blue-400", "from-blue-500", "from-blue-600", "from-blue-700",
    "from-green-400", "from-green-500",
    "from-purple-400", "from-purple-500", "from-purple-600",
    "from-indigo-400", "from-indigo-500", "from-indigo-600",
    "from-pink-400", "from-pink-500",
    "from-cyan-400", "from-cyan-500",
    "from-teal-400", "from-teal-500",
    "from-amber-400", "from-amber-500",
    "via-transparent",
    "via-white", "via-black",
    "via-blue-500", "via-purple-500", "via-pink-500", "via-sky-500",
    "via-slate-500", "via-gray-500",
    "to-transparent", "to-current",
    "to-black", "to-white",
    "to-slate-100", "to-slate-500", "to-slate-900",
    "to-blue-400", "to-blue-500", "to-blue-600",
    "to-indigo-400", "to-indigo-500",
    "to-purple-400", "to-purple-500", "to-purple-600",
    "to-pink-400", "to-pink-500",
    "to-cyan-400", "to-cyan-500",
    "to-emerald-400", "to-emerald-500",
    "to-red-400", "to-red-500",
    "from-0%", "from-5%", "from-10%",
    "via-30%", "via-50%", "via-70%",
    "to-90%", "to-95%", "to-100%",
]

EFFECTS = [
    "mix-blend-normal", "mix-blend-multiply", "mix-blend-screen", "mix-blend-overlay",
    "mix-blend-darken", "mix-blend-lighten", "mix-blend-color-dodge",
    "bg-blend-normal", "bg-blend-multiply", "bg-blend-screen", "bg-blend-overlay",
    "blur-none", "blur-sm", "blur", "blur-md", "blur-lg", "blur-xl", "blur-2xl", "blur-3xl",
    "brightness-0", "brightness-50", "brightness-75", "brightness-90", "brightness-95",
    "brightness-100", "brightness-105", "brightness-110", "brightness-125", "brightness-150", "brightness-200",
    "contrast-0", "contrast-50", "contrast-75", "contrast-100", "contrast-125", "contrast-150", "contrast-200",
    "grayscale-0", "grayscale",
    "hue-rotate-0", "hue-rotate-15", "hue-rotate-30", "hue-rotate-60", "hue-rotate-90", "hue-rotate-180",
    "invert-0", "invert",
    "saturate-0", "saturate-50", "saturate-100", "saturate-150", "saturate-200",
    "sepia-0", "sepia",
    "backdrop-blur-none", "backdrop-blur-sm", "backdrop-blur", "backdrop-blur-md", "backdrop-blur-lg", "backdrop-blur-xl",
    "backdrop-brightness-50", "backdrop-brightness-75", "backdrop-brightness-100",
    "backdrop-contrast-50", "backdrop-contrast-100",
    "backdrop-grayscale-0", "backdrop-grayscale",
    "backdrop-invert-0", "backdrop-invert",
    "backdrop-opacity-0", "backdrop-opacity-50", "backdrop-opacity-100",
    "backdrop-saturate-0", "backdrop-saturate-100", "backdrop-saturate-150",
    "backdrop-sepia-0", "backdrop-sepia",
]

BACKGROUNDS = [
    "bg-fixed", "bg-local", "bg-scroll",
    "bg-clip-border", "bg-clip-padding", "bg-clip-content", "bg-clip-text",
    "bg-repeat", "bg-no-repeat", "bg-repeat-x", "bg-repeat-y", "bg-repeat-round", "bg-repeat-space",
    "bg-origin-border", "bg-origin-padding", "bg-origin-content",
    "bg-auto", "bg-cover", "bg-contain",
    "bg-center", "bg-top", "bg-bottom", "bg-left", "bg-right",
    "bg-left-top", "bg-right-bottom",
    "bg-none",
]

INTERACTIVITY = [
    "accent-auto", "accent-inherit", "accent-current",
    "accent-blue-500", "accent-indigo-500", "accent-green-500",
    "appearance-none", "appearance-auto",
    "cursor-auto", "cursor-default", "cursor-pointer", "cursor-wait",
    "cursor-text", "cursor-move", "cursor-help", "cursor-not-allowed",
    "cursor-none", "cursor-crosshair", "cursor-grab", "cursor-grabbing",
    "caret-blue-500", "caret-black", "caret-transparent",
    "pointer-events-none", "pointer-events-auto",
    "resize-none", "resize-y", "resize-x", "resize",
    "scroll-auto", "scroll-smooth",
    "scroll-m-0", "scroll-m-4", "scroll-mt-4", "scroll-mb-4",
    "scroll-p-0", "scroll-p-4", "scroll-pt-4", "scroll-pb-4",
    "snap-start", "snap-end", "snap-center", "snap-align-none",
    "snap-normal", "snap-always",
    "snap-none", "snap-x", "snap-y", "snap-both", "snap-mandatory", "snap-proximity",
    "touch-auto", "touch-none", "touch-pan-x", "touch-pan-y", "touch-manipulation",
    "select-none", "select-text", "select-all", "select-auto",
    "will-change-auto", "will-change-scroll", "will-change-contents", "will-change-transform",
]

TABLES = [
    "table-auto", "table-fixed",
    "caption-top", "caption-bottom",
]

SVG = [
    "fill-none", "fill-current", "fill-inherit",
    "fill-black", "fill-white",
    "fill-slate-500", "fill-gray-500", "fill-blue-500", "fill-red-500", "fill-green-500",
    "stroke-none", "stroke-current", "stroke-inherit",
    "stroke-black", "stroke-white",
    "stroke-slate-500", "stroke-gray-500", "stroke-blue-500", "stroke-red-500",
    "stroke-0", "stroke-1", "stroke-2",
]

ASPECT_RATIO = [
    "aspect-auto", "aspect-square", "aspect-video",
]

COLUMNS = [
    "columns-1", "columns-2", "columns-3", "columns-4",
    "columns-xs", "columns-sm", "columns-md", "columns-lg",
]

BREAK = [
    "break-after-auto", "break-after-avoid", "break-after-all", "break-after-page", "break-after-column",
    "break-before-auto", "break-before-avoid", "break-before-all", "break-before-page",
    "break-inside-auto", "break-inside-avoid", "break-inside-avoid-page", "break-inside-avoid-column",
    "box-decoration-clone", "box-decoration-slice",
    "box-border", "box-content",
]

ARBITRARY_VALUES = [
    "w-[200px]", "w-[300px]", "w-[calc(100%-2rem)]", "w-[50vw]",
    "h-[200px]", "h-[300px]", "h-[calc(100vh-4rem)]", "h-[50vh]",
    "min-h-[500px]", "min-h-[calc(100vh-80px)]",
    "max-w-[1200px]", "max-w-[90rem]", "max-w-[calc(100%-3rem)]",
    "top-[50%]", "left-[50%]", "top-[10px]", "left-[20px]", "right-[1rem]", "bottom-[2rem]",
    "m-[10px]", "mt-[2px]", "mb-[3rem]",
    "p-[10px]", "px-[15px]", "py-[2.5rem]",
    "gap-[10px]", "gap-[1.5rem]",
    "text-[14px]", "text-[16px]", "text-[18px]", "text-[20px]", "text-[24px]", "text-[32px]", "text-[40px]",
    "text-[#333333]", "text-[#1a1a2e]", "text-[#e94560]",
    "bg-[#f0f0f0]", "bg-[#1a1a2e]", "bg-[#16213e]", "bg-[#0f3460]", "bg-[#e94560]",
    "bg-[url('/img/hero.jpg')]",
    "border-[#e5e7eb]", "border-[3px]",
    "rounded-[4px]", "rounded-[8px]", "rounded-[12px]", "rounded-[50%]",
    "leading-[1.2]", "leading-[1.75]", "leading-[2]",
    "tracking-[0.02em]", "tracking-[0.05em]",
    "shadow-[0_2px_4px_rgba(0,0,0,0.1)]", "shadow-[0_4px_6px_-1px_rgba(0,0,0,0.1)]",
    "grid-cols-[200px_1fr_200px]", "grid-cols-[repeat(auto-fill,minmax(250px,1fr))]",
    "grid-rows-[auto_1fr_auto]",
    "translate-x-[10px]", "translate-y-[-5px]", "rotate-[17deg]", "skew-x-[20deg]",
    "duration-[2000ms]", "delay-[500ms]",
    "z-[100]", "z-[999]", "z-[-1]",
    "font-[600]", "font-[900]",
    "opacity-[0.85]",
    "line-clamp-[3]", "line-clamp-[5]",
    "basis-[200px]",
    "scroll-mt-[80px]",
    "columns-[18rem]",
    "indent-[2em]",
    "outline-[3px]",
    "ring-[3px]",
    "space-x-[10px]", "space-y-[10px]",
    "decoration-[2px]",
]

# Pseudo-element and before/after classes
PSEUDO_CONTENT = [
    "before:content-['']", "after:content-['']",
    "before:content-['*']", "after:content-['\\2192']",
    "before:absolute", "after:absolute", "before:relative", "after:relative",
    "before:inset-0", "after:inset-0",
    "before:block", "after:block", "before:inline-block", "after:inline-block",
    "before:w-full", "after:w-full", "before:h-full", "after:h-full",
    "before:h-1", "after:h-1", "before:w-4", "after:w-4",
    "before:bg-blue-500", "after:bg-blue-500",
    "before:bg-gradient-to-r", "after:bg-gradient-to-r",
    "before:rounded-full", "after:rounded-full",
    "before:opacity-0", "after:opacity-0",
    "before:transition-opacity", "after:transition-opacity",
    "before:top-0", "after:top-0", "before:left-0", "after:left-0",
    "before:bottom-0", "after:bottom-0", "before:right-0", "after:right-0",
    "before:border-b-2", "after:border-b-2",
    "before:border-blue-500", "after:border-blue-500",
    "before:bg-black/10", "after:bg-black/10",
    "before:z-[-1]", "after:z-[-1]",
    "before:pointer-events-none", "after:pointer-events-none",
]

# State variants
HOVER_CLASSES = [
    "hover:bg-gray-50", "hover:bg-gray-100", "hover:bg-gray-200", "hover:bg-gray-700",
    "hover:bg-blue-50", "hover:bg-blue-100", "hover:bg-blue-600", "hover:bg-blue-700",
    "hover:bg-red-50", "hover:bg-red-600", "hover:bg-red-700",
    "hover:bg-green-50", "hover:bg-green-600", "hover:bg-green-700",
    "hover:bg-indigo-600", "hover:bg-indigo-700",
    "hover:bg-white", "hover:bg-black", "hover:bg-transparent",
    "hover:bg-slate-50", "hover:bg-slate-700",
    "hover:text-gray-600", "hover:text-gray-700", "hover:text-gray-900",
    "hover:text-blue-500", "hover:text-blue-600", "hover:text-blue-700",
    "hover:text-red-500", "hover:text-red-600",
    "hover:text-white", "hover:text-black",
    "hover:text-indigo-600",
    "hover:border-gray-300", "hover:border-gray-400",
    "hover:border-blue-500", "hover:border-blue-600",
    "hover:border-indigo-500",
    "hover:shadow-md", "hover:shadow-lg", "hover:shadow-xl",
    "hover:opacity-75", "hover:opacity-80", "hover:opacity-90", "hover:opacity-100",
    "hover:scale-105", "hover:scale-110",
    "hover:-translate-y-1", "hover:-translate-y-0.5",
    "hover:ring-2", "hover:ring-4",
    "hover:ring-blue-500", "hover:ring-indigo-500",
    "hover:underline", "hover:no-underline",
    "hover:decoration-blue-500",
    "hover:brightness-110", "hover:brightness-90",
    "hover:saturate-150",
    "hover:rotate-3", "hover:-rotate-3",
    "hover:cursor-pointer",
    "hover:z-10",
]

FOCUS_CLASSES = [
    "focus:outline-none", "focus:outline-0",
    "focus:ring-2", "focus:ring-4", "focus:ring-0",
    "focus:ring-blue-500", "focus:ring-blue-600", "focus:ring-indigo-500",
    "focus:ring-red-500", "focus:ring-green-500",
    "focus:ring-offset-2", "focus:ring-offset-0",
    "focus:ring-offset-white",
    "focus:border-blue-500", "focus:border-blue-600",
    "focus:border-indigo-500", "focus:border-red-500", "focus:border-green-500",
    "focus:border-gray-400",
    "focus:border-transparent",
    "focus:bg-gray-50", "focus:bg-gray-100", "focus:bg-white",
    "focus:text-gray-900",
    "focus:shadow-md", "focus:shadow-lg",
    "focus:shadow-blue-500/25",
    "focus:scale-105",
    "focus:placeholder-gray-400",
    "focus-within:ring-2", "focus-within:ring-blue-500", "focus-within:ring-indigo-500",
    "focus-within:border-blue-500",
    "focus-within:shadow-md",
    "focus-visible:outline-2", "focus-visible:outline-offset-2",
    "focus-visible:outline-blue-500", "focus-visible:outline-indigo-500",
    "focus-visible:ring-2", "focus-visible:ring-blue-500",
]

ACTIVE_CLASSES = [
    "active:bg-gray-200", "active:bg-gray-300",
    "active:bg-blue-700", "active:bg-blue-800",
    "active:bg-red-700", "active:bg-green-700",
    "active:scale-95", "active:scale-100",
    "active:translate-y-0.5",
    "active:shadow-sm", "active:shadow-none",
    "active:ring-0",
    "active:opacity-80",
]

DARK_CLASSES = [
    "dark:bg-gray-800", "dark:bg-gray-900", "dark:bg-gray-950",
    "dark:bg-slate-800", "dark:bg-slate-900", "dark:bg-slate-950",
    "dark:bg-zinc-800", "dark:bg-zinc-900", "dark:bg-zinc-950",
    "dark:bg-black", "dark:bg-white/5", "dark:bg-white/10",
    "dark:text-white", "dark:text-gray-100", "dark:text-gray-200", "dark:text-gray-300", "dark:text-gray-400",
    "dark:text-slate-100", "dark:text-slate-200", "dark:text-slate-300", "dark:text-slate-400",
    "dark:border-gray-600", "dark:border-gray-700", "dark:border-gray-800",
    "dark:border-slate-600", "dark:border-slate-700",
    "dark:divide-gray-700", "dark:divide-gray-800",
    "dark:ring-gray-700", "dark:ring-gray-800",
    "dark:shadow-none", "dark:shadow-lg",
    "dark:placeholder-gray-500",
    "dark:text-blue-400", "dark:text-red-400", "dark:text-green-400",
    "dark:bg-blue-900", "dark:bg-red-900", "dark:bg-green-900",
    "dark:hover:bg-gray-700", "dark:hover:bg-gray-800",
    "dark:hover:text-white",
    "dark:focus:ring-blue-400", "dark:focus:ring-offset-gray-900",
    "dark:fill-gray-400", "dark:stroke-gray-400",
]

RESPONSIVE_SM = [
    "sm:block", "sm:hidden", "sm:inline-block", "sm:flex", "sm:inline-flex", "sm:grid",
    "sm:flex-row", "sm:flex-col",
    "sm:grid-cols-2", "sm:grid-cols-3", "sm:grid-cols-4",
    "sm:col-span-2", "sm:col-span-3",
    "sm:w-1/2", "sm:w-1/3", "sm:w-auto", "sm:w-full",
    "sm:px-4", "sm:px-6", "sm:py-4", "sm:py-6",
    "sm:mx-auto", "sm:mx-0",
    "sm:text-sm", "sm:text-base", "sm:text-lg", "sm:text-xl", "sm:text-2xl",
    "sm:gap-4", "sm:gap-6",
    "sm:space-x-4", "sm:space-y-4",
    "sm:max-w-sm", "sm:max-w-md", "sm:max-w-lg",
    "sm:p-4", "sm:p-6",
    "sm:rounded-lg",
    "sm:items-center", "sm:justify-between",
    "sm:static", "sm:relative",
    "sm:mt-0", "sm:mb-0", "sm:ml-4",
    "sm:border-0", "sm:border-l",
]

RESPONSIVE_MD = [
    "md:block", "md:hidden", "md:inline-block", "md:flex", "md:inline-flex", "md:grid",
    "md:flex-row", "md:flex-col", "md:flex-row-reverse",
    "md:grid-cols-2", "md:grid-cols-3", "md:grid-cols-4", "md:grid-cols-6",
    "md:col-span-2", "md:col-span-3", "md:col-span-4",
    "md:w-1/2", "md:w-1/3", "md:w-2/3", "md:w-1/4", "md:w-auto", "md:w-full", "md:w-64",
    "md:px-6", "md:px-8", "md:px-10", "md:py-6", "md:py-8",
    "md:mx-auto",
    "md:text-base", "md:text-lg", "md:text-xl", "md:text-2xl", "md:text-3xl", "md:text-4xl",
    "md:gap-6", "md:gap-8",
    "md:space-x-6", "md:space-y-0",
    "md:max-w-md", "md:max-w-lg", "md:max-w-xl", "md:max-w-2xl", "md:max-w-4xl",
    "md:p-6", "md:p-8",
    "md:rounded-xl",
    "md:items-center", "md:items-start", "md:justify-between", "md:justify-start",
    "md:static", "md:relative", "md:sticky",
    "md:mt-0", "md:mb-0", "md:ml-6", "md:ml-8",
    "md:border-0", "md:border-l", "md:border-r",
    "md:order-1", "md:order-2", "md:order-first", "md:order-last",
    "md:h-screen", "md:h-full",
    "md:overflow-y-auto",
    "md:top-0", "md:inset-y-0",
    "md:translate-x-0",
]

RESPONSIVE_LG = [
    "lg:block", "lg:hidden", "lg:flex", "lg:grid", "lg:inline-flex",
    "lg:flex-row", "lg:flex-col",
    "lg:grid-cols-3", "lg:grid-cols-4", "lg:grid-cols-5", "lg:grid-cols-6", "lg:grid-cols-12",
    "lg:col-span-2", "lg:col-span-3", "lg:col-span-4", "lg:col-span-6", "lg:col-span-8", "lg:col-span-9",
    "lg:w-1/2", "lg:w-1/3", "lg:w-1/4", "lg:w-2/3", "lg:w-3/4", "lg:w-auto", "lg:w-full", "lg:w-80",
    "lg:px-8", "lg:px-10", "lg:px-12", "lg:py-8", "lg:py-10", "lg:py-12",
    "lg:mx-auto",
    "lg:text-lg", "lg:text-xl", "lg:text-2xl", "lg:text-3xl", "lg:text-4xl", "lg:text-5xl",
    "lg:gap-8", "lg:gap-10", "lg:gap-12",
    "lg:space-x-8", "lg:space-y-0",
    "lg:max-w-lg", "lg:max-w-xl", "lg:max-w-3xl", "lg:max-w-5xl", "lg:max-w-7xl",
    "lg:p-8", "lg:p-10", "lg:p-12",
    "lg:rounded-2xl",
    "lg:items-center", "lg:justify-between",
    "lg:static", "lg:sticky",
    "lg:mt-0", "lg:ml-8", "lg:ml-auto",
    "lg:order-1", "lg:order-2",
    "lg:h-screen",
    "lg:top-0", "lg:inset-y-0",
    "lg:translate-x-0",
]

RESPONSIVE_XL = [
    "xl:block", "xl:hidden", "xl:flex", "xl:grid",
    "xl:grid-cols-4", "xl:grid-cols-5", "xl:grid-cols-6",
    "xl:col-span-3", "xl:col-span-4",
    "xl:w-1/4", "xl:w-1/3",
    "xl:px-12", "xl:py-12",
    "xl:text-xl", "xl:text-2xl", "xl:text-4xl", "xl:text-5xl", "xl:text-6xl",
    "xl:gap-10", "xl:gap-12",
    "xl:max-w-xl", "xl:max-w-4xl", "xl:max-w-6xl", "xl:max-w-7xl",
    "xl:p-12",
    "xl:ml-auto",
]

RESPONSIVE_2XL = [
    "2xl:block", "2xl:hidden",
    "2xl:grid-cols-6",
    "2xl:max-w-7xl",
    "2xl:px-16", "2xl:py-16",
    "2xl:text-6xl", "2xl:text-7xl",
    "2xl:gap-12", "2xl:gap-16",
]

SPACE = [
    "space-x-0", "space-x-1", "space-x-2", "space-x-3", "space-x-4", "space-x-6", "space-x-8",
    "space-y-0", "space-y-1", "space-y-2", "space-y-3", "space-y-4", "space-y-6", "space-y-8", "space-y-10", "space-y-12",
    "space-x-reverse", "space-y-reverse",
]

GROUP_PEER = [
    "group", "group/item", "group/card",
    "group-hover:visible", "group-hover:opacity-100", "group-hover:scale-105",
    "group-hover:bg-gray-50", "group-hover:text-blue-600",
    "group-hover:translate-x-1", "group-hover:-translate-y-1",
    "group-hover:shadow-lg",
    "group-hover:border-blue-500",
    "group-focus:ring-2", "group-focus:ring-blue-500",
    "peer", "peer/input",
    "peer-focus:text-blue-600", "peer-focus:ring-2",
    "peer-invalid:text-red-600", "peer-invalid:border-red-500",
    "peer-checked:bg-blue-500", "peer-checked:text-white",
    "peer-placeholder-shown:top-1/2",
    "peer-disabled:opacity-50",
]

OTHER_STATES = [
    "disabled:opacity-50", "disabled:cursor-not-allowed", "disabled:bg-gray-100",
    "disabled:text-gray-400", "disabled:border-gray-200",
    "checked:bg-blue-500", "checked:border-blue-500",
    "indeterminate:bg-gray-300",
    "placeholder:text-gray-400", "placeholder:text-gray-500", "placeholder:italic",
    "first:mt-0", "first:pt-0", "first:rounded-t-lg", "first:border-t-0",
    "last:mb-0", "last:pb-0", "last:rounded-b-lg", "last:border-b-0",
    "odd:bg-gray-50", "odd:bg-white",
    "even:bg-gray-50", "even:bg-gray-100",
    "first-of-type:mt-0", "last-of-type:mb-0",
    "empty:hidden",
    "required:border-red-500",
    "invalid:border-red-500", "invalid:text-red-600",
    "valid:border-green-500",
    "read-only:bg-gray-50", "read-only:cursor-default",
    "autofill:bg-yellow-50",
    "open:rotate-180", "open:opacity-100",
    "selection:bg-blue-200", "selection:text-blue-900",
    "file:mr-4", "file:py-2", "file:px-4", "file:rounded-full", "file:border-0",
    "file:bg-blue-50", "file:text-blue-700", "file:font-semibold",
    "file:cursor-pointer",
    "marker:text-blue-500", "marker:text-gray-500",
    "first-letter:text-4xl", "first-letter:font-bold", "first-letter:text-blue-600",
    "first-line:uppercase", "first-line:tracking-widest",
]

OUTLINE = [
    "outline-none", "outline", "outline-dashed", "outline-dotted", "outline-double",
    "outline-0", "outline-1", "outline-2", "outline-4", "outline-8",
    "outline-offset-0", "outline-offset-1", "outline-offset-2", "outline-offset-4",
    "outline-transparent", "outline-current",
    "outline-black", "outline-white",
    "outline-blue-500", "outline-red-500", "outline-green-500",
]

CONTAINER_AND_MISC = [
    "container",
    "prose", "prose-sm", "prose-lg", "prose-xl",
    "not-prose",
    "sr-only", "not-sr-only",
    "forced-color-adjust-auto", "forced-color-adjust-none",
]

LINE_CLAMP = [
    "line-clamp-1", "line-clamp-2", "line-clamp-3", "line-clamp-4", "line-clamp-5", "line-clamp-6",
    "line-clamp-none",
]

PRINT_CLASSES = [
    "print:hidden", "print:block", "print:text-black", "print:bg-white",
]

MOTION_CLASSES = [
    "motion-safe:animate-spin", "motion-safe:transition",
    "motion-reduce:animate-none", "motion-reduce:transition-none",
]

SUPPORTS_CLASSES = [
    "supports-[display:grid]:grid",
]

ARIA_DATA_CLASSES = [
    "aria-selected:bg-blue-500", "aria-selected:text-white",
    "aria-disabled:opacity-50", "aria-disabled:cursor-not-allowed",
    "aria-expanded:rotate-180",
    "aria-hidden:hidden",
    "aria-checked:bg-blue-500",
    "data-[active]:bg-blue-500", "data-[state=open]:rotate-180",
    "data-[selected]:bg-indigo-50", "data-[selected]:text-indigo-600",
    "data-[disabled]:opacity-50",
]

PLACEHOLDER_SHOWN = [
    "placeholder-shown:border-gray-300",
    "placeholder-shown:text-gray-400",
]

# ---------------------------------------------------------------------------
# All pools in one list for easy reference
# ---------------------------------------------------------------------------
# Logical properties (mbs, mbe, pbs, pbe, inline/block sizing)
LOGICAL_PROPERTIES = [
    "mbs-2", "mbs-4", "mbs-6", "mbe-2", "mbe-4", "mbe-8",
    "-mbs-2", "-mbe-4",
    "pbs-2", "pbs-4", "pbs-6", "pbe-2", "pbe-4", "pbe-8",
    "mis-2", "mis-4", "mie-2", "mie-4",
    "-mis-2", "-mie-4",
    "inline-full", "inline-auto", "inline-1/2",
    "min-inline-0", "max-inline-lg",
    "block-full", "block-auto", "block-1/2",
    "min-block-0", "max-block-screen",
]

# Viewport unit keywords
VIEWPORT_UNITS = [
    "w-svw", "w-lvw", "w-dvw",
    "h-svh", "h-lvh", "h-dvh",
    "min-h-svh", "min-h-dvh",
    "max-h-lvh",
    "h-lh",
]

# Mask utilities
MASK_UTILITIES = [
    "mask-image-[url('/mask.svg')]", "mask-image-[url('/gradient.png')]",
    "mask-clip-border", "mask-clip-padding", "mask-clip-content",
    "mask-origin-border", "mask-origin-padding", "mask-origin-content",
    "mask-mode-alpha", "mask-mode-luminance", "mask-mode-match",
    "mask-composite-add", "mask-composite-subtract", "mask-composite-intersect", "mask-composite-exclude",
    "mask-type-alpha", "mask-type-luminance",
    "mask-repeat", "mask-no-repeat", "mask-repeat-x", "mask-repeat-y",
    "mask-auto", "mask-cover", "mask-contain",
    "mask-center", "mask-top", "mask-bottom",
]

# 3D transforms
TRANSFORMS_3D = [
    "rotate-x-12", "rotate-x-45", "rotate-x-90", "rotate-x-180",
    "rotate-y-12", "rotate-y-45", "rotate-y-90", "rotate-y-180",
    "rotate-z-45", "rotate-z-90",
    "-rotate-x-12", "-rotate-y-45",
    "translate-z-4", "translate-z-8", "translate-z-12",
    "-translate-z-4",
    "scale-z-50", "scale-z-75", "scale-z-100", "scale-z-125",
    "transform-3d", "backface-hidden", "backface-visible",
    "perspective-normal", "perspective-distant",
]

# Touch action composition
TOUCH_ACTION = [
    "touch-auto", "touch-none", "touch-manipulation",
    "touch-pan-x", "touch-pan-y", "touch-pinch-zoom",
    "touch-pan-left", "touch-pan-right", "touch-pan-up", "touch-pan-down",
]

ALL_POOLS = [
    LAYOUT, FLEXBOX, GRID, GAP, SPACING_MARGIN, SPACING_PADDING, SIZING,
    TYPOGRAPHY, COLORS_TEXT, COLORS_BG, OPACITY, COLORS_WITH_OPACITY,
    BORDERS, BORDER_RADIUS, SHADOWS, RINGS, TRANSFORMS, TRANSITIONS,
    GRADIENTS, EFFECTS, BACKGROUNDS, INTERACTIVITY, TABLES, SVG,
    ASPECT_RATIO, COLUMNS, BREAK, ARBITRARY_VALUES, PSEUDO_CONTENT,
    HOVER_CLASSES, FOCUS_CLASSES, ACTIVE_CLASSES, DARK_CLASSES,
    RESPONSIVE_SM, RESPONSIVE_MD, RESPONSIVE_LG, RESPONSIVE_XL,
    RESPONSIVE_2XL, SPACE, GROUP_PEER, OTHER_STATES, OUTLINE,
    CONTAINER_AND_MISC, LINE_CLAMP, PRINT_CLASSES, MOTION_CLASSES,
    SUPPORTS_CLASSES, ARIA_DATA_CLASSES, PLACEHOLDER_SHOWN,
    LOGICAL_PROPERTIES, VIEWPORT_UNITS, MASK_UTILITIES, TRANSFORMS_3D,
    TOUCH_ACTION,
]

# ---------------------------------------------------------------------------
# Page templates -- each is a function that returns (html_string, set_of_classes_used)
# ---------------------------------------------------------------------------

def pick(pool, n):
    """Pick n random unique items from pool."""
    return random.sample(pool, min(n, len(pool)))

def join(*lists):
    """Flatten and deduplicate, preserving order."""
    seen = set()
    result = []
    for lst in lists:
        for item in lst:
            if item not in seen:
                seen.add(item)
                result.append(item)
    return result

def cls(*lists):
    """Join class lists into a class string."""
    return " ".join(join(*lists))

# ---- page generators ----

def landing_page(variant=0):
    nav_cls = join(pick(LAYOUT, 3), ["flex", "items-center", "justify-between"],
                   pick(SPACING_PADDING, 3), pick(COLORS_BG, 1), pick(SHADOWS, 1),
                   pick(DARK_CLASSES, 2))
    hero_cls = join(["relative", "overflow-hidden"], pick(SPACING_PADDING, 4),
                    pick(COLORS_BG, 1), pick(GRADIENTS, 3), pick(SIZING, 2),
                    pick(RESPONSIVE_LG, 3), pick(DARK_CLASSES, 2))
    heading_cls = join(pick(TYPOGRAPHY, 5), pick(COLORS_TEXT, 1),
                       pick(RESPONSIVE_MD, 2), pick(RESPONSIVE_LG, 2), pick(DARK_CLASSES, 1))
    subheading_cls = join(pick(TYPOGRAPHY, 3), pick(COLORS_TEXT, 1), pick(SPACING_MARGIN, 2),
                          pick(RESPONSIVE_MD, 1))
    btn_cls = join(["inline-flex", "items-center", "justify-center"], pick(SPACING_PADDING, 2),
                   pick(BORDER_RADIUS, 1), pick(COLORS_BG, 1), pick(COLORS_TEXT, 1),
                   pick(TYPOGRAPHY, 2), pick(SHADOWS, 1), pick(TRANSITIONS, 2),
                   pick(HOVER_CLASSES, 3), pick(FOCUS_CLASSES, 3), pick(ACTIVE_CLASSES, 1))
    feature_grid_cls = join(["grid"], pick(GRID, 2), pick(GAP, 2), pick(SPACING_PADDING, 2),
                            pick(RESPONSIVE_SM, 1), pick(RESPONSIVE_MD, 1), pick(RESPONSIVE_LG, 1))
    card_cls = join(pick(SPACING_PADDING, 2), pick(BORDER_RADIUS, 1), pick(BORDERS, 2),
                    pick(COLORS_BG, 1), pick(SHADOWS, 1), pick(TRANSITIONS, 2),
                    pick(HOVER_CLASSES, 2), pick(DARK_CLASSES, 2))
    icon_cls = join(pick(SIZING, 2), pick(COLORS_TEXT, 1), pick(SPACING_MARGIN, 1))
    feature_title = join(pick(TYPOGRAPHY, 3), pick(COLORS_TEXT, 1), pick(SPACING_MARGIN, 1))
    feature_desc = join(pick(TYPOGRAPHY, 2), pick(COLORS_TEXT, 1), pick(LINE_CLAMP, 1))
    cta_cls = join(["text-center"], pick(SPACING_PADDING, 3), pick(COLORS_BG, 1),
                   pick(RESPONSIVE_LG, 1), pick(DARK_CLASSES, 1))

    all_classes = set()
    def c(lst):
        s = " ".join(lst)
        all_classes.update(lst)
        return s

    html = f"""<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Landing Page {variant}</title></head>
<body class="{c(["min-h-screen", "bg-white", "dark:bg-gray-950", "antialiased"])}">
  <nav class="{c(nav_cls)}">
    <a href="#" class="{c(join(pick(TYPOGRAPHY, 2), pick(COLORS_TEXT, 1)))}">Brand</a>
    <div class="{c(["hidden", "md:flex", "items-center"] + pick(SPACE, 1))}">
      <a href="#" class="{c(join(pick(TYPOGRAPHY, 1), pick(COLORS_TEXT, 1), pick(HOVER_CLASSES, 1), pick(TRANSITIONS, 1)))}">Features</a>
      <a href="#" class="{c(join(pick(TYPOGRAPHY, 1), pick(COLORS_TEXT, 1), pick(HOVER_CLASSES, 1)))}">Pricing</a>
      <a href="#" class="{c(join(pick(TYPOGRAPHY, 1), pick(COLORS_TEXT, 1), pick(HOVER_CLASSES, 1)))}">About</a>
    </div>
  </nav>
  <section class="{c(hero_cls)}">
    <div class="{c(["max-w-4xl", "mx-auto", "text-center"])}">
      <h1 class="{c(heading_cls)}">Build something amazing</h1>
      <p class="{c(subheading_cls)}">The fastest way to ship beautiful products.</p>
      <div class="{c(["flex", "flex-col", "sm:flex-row", "items-center", "justify-center"] + pick(GAP, 1) + pick(SPACING_MARGIN, 1))}">
        <a href="#" class="{c(btn_cls)}">Get Started</a>
        <a href="#" class="{c(join(["inline-flex", "items-center"], pick(SPACING_PADDING, 2), pick(BORDER_RADIUS, 1), pick(BORDERS, 1), pick(COLORS_TEXT, 1), pick(HOVER_CLASSES, 2), pick(TRANSITIONS, 1)))}">Learn More</a>
      </div>
    </div>
  </section>
  <section class="{c(feature_grid_cls)}">
    <div class="{c(card_cls)}">
      <div class="{c(icon_cls)}">&#9733;</div>
      <h3 class="{c(feature_title)}">Fast Performance</h3>
      <p class="{c(feature_desc)}">Lightning-fast compilation with zero overhead.</p>
    </div>
    <div class="{c(card_cls)}">
      <div class="{c(icon_cls)}">&#9881;</div>
      <h3 class="{c(feature_title)}">Customizable</h3>
      <p class="{c(feature_desc)}">Tailor everything to your exact needs.</p>
    </div>
    <div class="{c(card_cls)}">
      <div class="{c(icon_cls)}">&#9729;</div>
      <h3 class="{c(feature_title)}">Cloud Ready</h3>
      <p class="{c(feature_desc)}">Deploy anywhere with one command.</p>
    </div>
  </section>
  <section class="{c(cta_cls)}">
    <h2 class="{c(join(pick(TYPOGRAPHY, 3), pick(COLORS_TEXT, 1)))}">Ready to start?</h2>
    <p class="{c(join(pick(TYPOGRAPHY, 2), pick(COLORS_TEXT, 1), pick(SPACING_MARGIN, 1)))}">Join thousands of developers building with us.</p>
    <a href="#" class="{c(btn_cls)}">Sign Up Free</a>
  </section>
</body>
</html>"""
    return html, all_classes


def dashboard_page(variant=0):
    all_classes = set()
    def c(lst):
        s = " ".join(lst)
        all_classes.update(lst)
        return s

    sidebar_cls = join(["hidden", "md:flex", "md:flex-col", "fixed", "md:inset-y-0"],
                       pick(SIZING, 2), pick(COLORS_BG, 1), pick(BORDERS, 1),
                       pick(DARK_CLASSES, 2), pick(TRANSITIONS, 1))
    sidebar_link = join(["flex", "items-center"], pick(SPACING_PADDING, 2), pick(SPACING_MARGIN, 1),
                        pick(BORDER_RADIUS, 1), pick(TYPOGRAPHY, 2), pick(COLORS_TEXT, 1),
                        pick(HOVER_CLASSES, 2), pick(TRANSITIONS, 1), pick(GROUP_PEER, 1))
    main_cls = join(["md:ml-64"], pick(SPACING_PADDING, 3), pick(COLORS_BG, 1),
                    ["min-h-screen"], pick(DARK_CLASSES, 1))
    header_cls = join(["flex", "items-center", "justify-between"], pick(SPACING_PADDING, 2),
                      pick(BORDERS, 1), pick(COLORS_BG, 1))
    stat_card = join(pick(SPACING_PADDING, 2), pick(BORDER_RADIUS, 1), pick(COLORS_BG, 1),
                     pick(BORDERS, 1), pick(SHADOWS, 1), pick(DARK_CLASSES, 2))
    stat_label = join(pick(TYPOGRAPHY, 2), pick(COLORS_TEXT, 1))
    stat_value = join(pick(TYPOGRAPHY, 3), pick(COLORS_TEXT, 1))
    table_cls = join(["w-full"], pick(TYPOGRAPHY, 1), pick(BORDERS, 1))
    thead_cls = join(pick(COLORS_BG, 1), pick(TYPOGRAPHY, 1), pick(COLORS_TEXT, 1))
    th_cls = join(pick(SPACING_PADDING, 2), ["text-left"], pick(TYPOGRAPHY, 1))
    td_cls = join(pick(SPACING_PADDING, 2), pick(BORDERS, 1), pick(COLORS_TEXT, 1))
    badge_green = join(["inline-flex", "items-center"], pick(SPACING_PADDING, 1),
                       pick(BORDER_RADIUS, 1), ["bg-green-100", "text-green-700"],
                       pick(TYPOGRAPHY, 1), pick(DARK_CLASSES, 1))
    badge_red = join(["inline-flex", "items-center"], pick(SPACING_PADDING, 1),
                     pick(BORDER_RADIUS, 1), ["bg-red-100", "text-red-700"],
                     pick(TYPOGRAPHY, 1))
    badge_yellow = join(["inline-flex", "items-center"], pick(SPACING_PADDING, 1),
                        pick(BORDER_RADIUS, 1), ["bg-yellow-100", "text-yellow-600"],
                        pick(TYPOGRAPHY, 1))
    chart_placeholder = join(pick(SIZING, 2), pick(COLORS_BG, 1), pick(BORDER_RADIUS, 1),
                             pick(BORDERS, 1), ["animate-pulse"])
    search_cls = join(pick(SIZING, 1), pick(SPACING_PADDING, 2), pick(BORDERS, 1),
                      pick(BORDER_RADIUS, 1), pick(TYPOGRAPHY, 1), pick(COLORS_BG, 1),
                      pick(FOCUS_CLASSES, 3), pick(OTHER_STATES, 1))

    rows_html = ""
    for i in range(5):
        status = random.choice([c(badge_green), c(badge_red), c(badge_yellow)])
        rows_html += f"""      <tr class="{c(pick(OTHER_STATES, 1) + pick(HOVER_CLASSES, 1))}">
        <td class="{c(td_cls)}">Order #{1000+i}</td>
        <td class="{c(td_cls)}">Customer {i+1}</td>
        <td class="{c(td_cls)}"><span class="{status}">Active</span></td>
        <td class="{c(td_cls)}">$<span>{random.randint(10,999)}.00</span></td>
      </tr>\n"""

    html = f"""<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Dashboard {variant}</title></head>
<body class="{c(["min-h-screen", "bg-gray-50", "dark:bg-gray-950"])}">
  <aside class="{c(sidebar_cls)}">
    <div class="{c(["flex", "items-center", "h-16"] + pick(SPACING_PADDING, 1) + pick(BORDERS, 1))}">
      <span class="{c(join(pick(TYPOGRAPHY, 2), pick(COLORS_TEXT, 1)))}">Dashboard</span>
    </div>
    <nav class="{c(["flex-1", "overflow-y-auto"] + pick(SPACING_PADDING, 1) + pick(SPACE, 1))}">
      <a href="#" class="{c(sidebar_link)}">Overview</a>
      <a href="#" class="{c(sidebar_link)}">Analytics</a>
      <a href="#" class="{c(sidebar_link)}">Customers</a>
      <a href="#" class="{c(sidebar_link)}">Orders</a>
      <a href="#" class="{c(sidebar_link)}">Settings</a>
    </nav>
  </aside>
  <main class="{c(main_cls)}">
    <header class="{c(header_cls)}">
      <h1 class="{c(join(pick(TYPOGRAPHY, 3), pick(COLORS_TEXT, 1)))}">Overview</h1>
      <input type="search" placeholder="Search..." class="{c(search_cls)}">
    </header>
    <div class="{c(["grid", "grid-cols-1", "sm:grid-cols-2", "lg:grid-cols-4"] + pick(GAP, 1) + pick(SPACING_PADDING, 1))}">
      <div class="{c(stat_card)}"><p class="{c(stat_label)}">Revenue</p><p class="{c(stat_value)}">$48,200</p></div>
      <div class="{c(stat_card)}"><p class="{c(stat_label)}">Orders</p><p class="{c(stat_value)}">1,240</p></div>
      <div class="{c(stat_card)}"><p class="{c(stat_label)}">Customers</p><p class="{c(stat_value)}">3,840</p></div>
      <div class="{c(stat_card)}"><p class="{c(stat_label)}">Conversion</p><p class="{c(stat_value)}">3.2%</p></div>
    </div>
    <div class="{c(join(pick(SPACING_PADDING, 2), pick(SPACING_MARGIN, 1)))}">
      <div class="{c(chart_placeholder)}">&nbsp;</div>
    </div>
    <div class="{c(["overflow-x-auto"] + pick(SPACING_PADDING, 1) + pick(BORDER_RADIUS, 1) + pick(COLORS_BG, 1) + pick(SHADOWS, 1))}">
      <table class="{c(table_cls)}">
        <thead class="{c(thead_cls)}">
          <tr>
            <th class="{c(th_cls)}">Order</th>
            <th class="{c(th_cls)}">Customer</th>
            <th class="{c(th_cls)}">Status</th>
            <th class="{c(th_cls)}">Amount</th>
          </tr>
        </thead>
        <tbody class="{c(["divide-y"] + pick(BORDERS, 1))}">
{rows_html}        </tbody>
      </table>
    </div>
  </main>
</body>
</html>"""
    return html, all_classes


def blog_post_page(variant=0):
    all_classes = set()
    def c(lst):
        s = " ".join(lst)
        all_classes.update(lst)
        return s

    article_cls = join(["max-w-prose", "mx-auto"], pick(SPACING_PADDING, 3),
                       pick(RESPONSIVE_MD, 1), pick(RESPONSIVE_LG, 1))
    meta_cls = join(["flex", "items-center"], pick(GAP, 1), pick(SPACING_MARGIN, 1),
                    pick(TYPOGRAPHY, 2), pick(COLORS_TEXT, 1))
    avatar_cls = join(["rounded-full", "object-cover"], pick(SIZING, 2), pick(RINGS, 1))
    title_cls = join(pick(TYPOGRAPHY, 4), pick(COLORS_TEXT, 1), pick(SPACING_MARGIN, 1),
                     pick(RESPONSIVE_MD, 1), pick(RESPONSIVE_LG, 1))
    prose_cls = join(["prose", "prose-lg"], pick(TYPOGRAPHY, 2), pick(COLORS_TEXT, 1),
                     pick(DARK_CLASSES, 2), pick(SPACING_MARGIN, 1))
    img_cls = join(["w-full", "rounded-xl", "object-cover"], pick(SIZING, 1),
                   pick(SHADOWS, 1), pick(SPACING_MARGIN, 1))
    blockquote_cls = join(["border-l-4"], pick(BORDERS, 1), pick(SPACING_PADDING, 2),
                          pick(COLORS_BG, 1), pick(TYPOGRAPHY, 1), pick(COLORS_TEXT, 1),
                          pick(BORDER_RADIUS, 1), pick(SPACING_MARGIN, 1))
    tag_cls = join(["inline-block"], pick(SPACING_PADDING, 1), pick(BORDER_RADIUS, 1),
                   pick(COLORS_BG, 1), pick(COLORS_TEXT, 1), pick(TYPOGRAPHY, 1),
                   pick(HOVER_CLASSES, 1), pick(TRANSITIONS, 1))
    code_cls = join(pick(SPACING_PADDING, 1), pick(BORDER_RADIUS, 1),
                    pick(COLORS_BG, 1), pick(TYPOGRAPHY, 1), pick(COLORS_TEXT, 1))
    heading2_cls = join(pick(TYPOGRAPHY, 3), pick(COLORS_TEXT, 1), pick(SPACING_MARGIN, 2))
    link_cls = join(pick(COLORS_TEXT, 1), pick(TYPOGRAPHY, 1), ["underline"],
                    pick(HOVER_CLASSES, 1), pick(TRANSITIONS, 1))
    share_btn = join(["inline-flex", "items-center", "justify-center"],
                     pick(SIZING, 2), pick(BORDER_RADIUS, 1), pick(COLORS_BG, 1),
                     pick(COLORS_TEXT, 1), pick(HOVER_CLASSES, 2), pick(TRANSITIONS, 1))
    toc_cls = join(pick(SPACING_PADDING, 2), pick(BORDER_RADIUS, 1), pick(COLORS_BG, 1),
                   pick(BORDERS, 1), pick(SPACING_MARGIN, 1))
    toc_link = join(pick(COLORS_TEXT, 1), pick(TYPOGRAPHY, 1), pick(HOVER_CLASSES, 1))
    first_letter = pick(OTHER_STATES, 2)
    dropcap = join(["first-letter:text-4xl", "first-letter:font-bold", "first-letter:text-blue-600"])

    html = f"""<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Blog Post {variant}</title></head>
<body class="{c(["min-h-screen", "bg-white", "dark:bg-gray-900", "antialiased"])}">
  <article class="{c(article_cls)}">
    <div class="{c(meta_cls)}">
      <img src="/avatar.jpg" alt="Author" class="{c(avatar_cls)}">
      <div>
        <p class="{c(join(pick(TYPOGRAPHY, 2), pick(COLORS_TEXT, 1)))}">Jane Doe</p>
        <time class="{c(join(pick(TYPOGRAPHY, 1), pick(COLORS_TEXT, 1)))}">March 15, 2026</time>
      </div>
    </div>
    <h1 class="{c(title_cls)}">Understanding Modern CSS Compilation</h1>
    <img src="/hero.jpg" alt="Hero" class="{c(img_cls)}">
    <nav class="{c(toc_cls)}">
      <h4 class="{c(join(pick(TYPOGRAPHY, 2), pick(COLORS_TEXT, 1)))}">Table of Contents</h4>
      <ul class="{c(join(pick(SPACE, 1), ["list-disc", "list-inside"]))}">
        <li><a href="#intro" class="{c(toc_link)}">Introduction</a></li>
        <li><a href="#deep" class="{c(toc_link)}">Deep Dive</a></li>
        <li><a href="#conclusion" class="{c(toc_link)}">Conclusion</a></li>
      </ul>
    </nav>
    <div class="{c(prose_cls)}">
      <p class="{c(dropcap)}">CSS compilation has evolved significantly. Modern tools parse utility classes and generate optimized stylesheets at build time, eliminating unused styles and reducing bundle sizes.</p>
      <h2 id="intro" class="{c(heading2_cls)}">Introduction</h2>
      <p>The approach of utility-first CSS has transformed how we think about styling. Instead of writing custom CSS for every component, we compose designs using <code class="{c(code_cls)}">pre-defined utility classes</code>.</p>
      <blockquote class="{c(blockquote_cls)}">
        <p>"The best CSS is the CSS you never have to write."</p>
      </blockquote>
      <h2 id="deep" class="{c(heading2_cls)}">Deep Dive</h2>
      <p>When the compiler encounters a class like <code class="{c(code_cls)}">bg-blue-500</code>, it resolves the color value from the theme and emits the corresponding CSS rule. This process is <a href="#" class="{c(link_cls)}">deterministic and cacheable</a>.</p>
      <h2 id="conclusion" class="{c(heading2_cls)}">Conclusion</h2>
      <p>Modern CSS compilation provides the best of both worlds: developer experience and performance.</p>
    </div>
    <div class="{c(["flex", "items-center"] + pick(GAP, 1) + pick(SPACING_MARGIN, 1) + pick(BORDERS, 1) + pick(SPACING_PADDING, 1))}">
      <span class="{c(join(pick(TYPOGRAPHY, 1), pick(COLORS_TEXT, 1)))}">Tags:</span>
      <a href="#" class="{c(tag_cls)}">CSS</a>
      <a href="#" class="{c(tag_cls)}">Tailwind</a>
      <a href="#" class="{c(tag_cls)}">Performance</a>
    </div>
    <div class="{c(["flex", "items-center"] + pick(GAP, 1) + pick(SPACING_MARGIN, 1))}">
      <span class="{c(join(pick(TYPOGRAPHY, 1), pick(COLORS_TEXT, 1)))}">Share:</span>
      <a href="#" class="{c(share_btn)}">T</a>
      <a href="#" class="{c(share_btn)}">F</a>
      <a href="#" class="{c(share_btn)}">L</a>
    </div>
  </article>
</body>
</html>"""
    return html, all_classes


def ecommerce_product_page(variant=0):
    all_classes = set()
    def c(lst):
        s = " ".join(lst)
        all_classes.update(lst)
        return s

    container = join(["max-w-7xl", "mx-auto"], pick(SPACING_PADDING, 2))
    grid_cls = join(["grid", "grid-cols-1", "md:grid-cols-2"], pick(GAP, 1))
    img_gallery = join(pick(SIZING, 1), pick(BORDER_RADIUS, 1), ["overflow-hidden", "relative"],
                       pick(COLORS_BG, 1), pick(ASPECT_RATIO, 1))
    main_img = join(["w-full", "h-full", "object-cover"], pick(TRANSITIONS, 2),
                    pick(HOVER_CLASSES, 2))
    thumb_cls = join(pick(SIZING, 2), pick(BORDER_RADIUS, 1), ["object-cover", "cursor-pointer"],
                     pick(BORDERS, 1), pick(OPACITY, 1), pick(HOVER_CLASSES, 1),
                     pick(RINGS, 1), pick(TRANSITIONS, 1))
    title_cls = join(pick(TYPOGRAPHY, 4), pick(COLORS_TEXT, 1))
    price_cls = join(pick(TYPOGRAPHY, 3), pick(COLORS_TEXT, 1), pick(SPACING_MARGIN, 1))
    old_price = join(["line-through"], pick(TYPOGRAPHY, 1), pick(COLORS_TEXT, 1))
    badge_cls = join(["inline-block"], pick(SPACING_PADDING, 1), pick(BORDER_RADIUS, 1),
                     ["bg-red-500", "text-white"], pick(TYPOGRAPHY, 1))
    rating_cls = join(["flex", "items-center"], pick(GAP, 1), pick(COLORS_TEXT, 1))
    star_cls = join(pick(SIZING, 1), ["fill-yellow-400", "text-yellow-400"])
    desc_cls = join(pick(TYPOGRAPHY, 2), pick(COLORS_TEXT, 1), pick(SPACING_MARGIN, 1),
                    pick(LINE_CLAMP, 1))
    size_btn = join(["inline-flex", "items-center", "justify-center"],
                    pick(SIZING, 2), pick(BORDERS, 1), pick(BORDER_RADIUS, 1),
                    pick(TYPOGRAPHY, 1), pick(HOVER_CLASSES, 2), pick(FOCUS_CLASSES, 1),
                    pick(TRANSITIONS, 1), pick(ACTIVE_CLASSES, 1))
    add_to_cart = join(["w-full", "flex", "items-center", "justify-center"],
                       pick(SPACING_PADDING, 2), pick(BORDER_RADIUS, 1),
                       pick(COLORS_BG, 1), pick(COLORS_TEXT, 1), pick(TYPOGRAPHY, 2),
                       pick(SHADOWS, 1), pick(HOVER_CLASSES, 2), pick(FOCUS_CLASSES, 2),
                       pick(ACTIVE_CLASSES, 1), pick(TRANSITIONS, 2),
                       pick(DISABLED_CLS := ["disabled:opacity-50", "disabled:cursor-not-allowed"], 2))
    wishlist_btn = join(["flex", "items-center", "justify-center"],
                        pick(SIZING, 2), pick(BORDER_RADIUS, 1), pick(BORDERS, 1),
                        pick(COLORS_TEXT, 1), pick(HOVER_CLASSES, 2), pick(TRANSITIONS, 1))
    review_cls = join(pick(SPACING_PADDING, 2), pick(BORDERS, 1), pick(SPACING_MARGIN, 1))
    review_author = join(pick(TYPOGRAPHY, 2), pick(COLORS_TEXT, 1))
    review_text = join(pick(TYPOGRAPHY, 1), pick(COLORS_TEXT, 1), pick(SPACING_MARGIN, 1))

    html = f"""<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Product {variant}</title></head>
<body class="{c(["min-h-screen", "bg-white", "dark:bg-gray-950"])}">
  <div class="{c(container)}">
    <div class="{c(grid_cls)}">
      <div class="{c(["space-y-4"])}">
        <div class="{c(img_gallery)}">
          <span class="{c(badge_cls + ["absolute", "top-4", "left-4", "z-10"])}">-25%</span>
          <img src="/product.jpg" alt="Product" class="{c(main_img)}">
        </div>
        <div class="{c(["flex"] + pick(GAP, 1))}">
          <img src="/thumb1.jpg" class="{c(thumb_cls)}">
          <img src="/thumb2.jpg" class="{c(thumb_cls)}">
          <img src="/thumb3.jpg" class="{c(thumb_cls)}">
          <img src="/thumb4.jpg" class="{c(thumb_cls)}">
        </div>
      </div>
      <div class="{c(["flex", "flex-col"] + pick(SPACE, 1))}">
        <h1 class="{c(title_cls)}">Premium Wireless Headphones</h1>
        <div class="{c(rating_cls)}">
          <svg class="{c(star_cls)}" viewBox="0 0 20 20"><path d="M10 15l-5.878 3.09 1.123-6.545L.489 6.91l6.572-.955L10 0l2.939 5.955 6.572.955-4.756 4.635 1.123 6.545z"/></svg>
          <span>4.8 (230 reviews)</span>
        </div>
        <div class="{c(["flex", "items-baseline"] + pick(GAP, 1))}">
          <span class="{c(price_cls)}">$149.99</span>
          <span class="{c(old_price)}">$199.99</span>
        </div>
        <p class="{c(desc_cls)}">Experience crystal-clear audio with our premium wireless headphones. Featuring active noise cancellation, 30-hour battery life, and ultra-comfortable memory foam ear cushions.</p>
        <div>
          <p class="{c(join(pick(TYPOGRAPHY, 1), pick(COLORS_TEXT, 1), pick(SPACING_MARGIN, 1)))}">Size</p>
          <div class="{c(["flex", "flex-wrap"] + pick(GAP, 1))}">
            <button class="{c(size_btn)}">S</button>
            <button class="{c(size_btn)}">M</button>
            <button class="{c(size_btn)}">L</button>
            <button class="{c(size_btn)}">XL</button>
          </div>
        </div>
        <div class="{c(["flex"] + pick(GAP, 1))}">
          <button class="{c(add_to_cart)}">Add to Cart</button>
          <button class="{c(wishlist_btn)}">&#9825;</button>
        </div>
      </div>
    </div>
    <section class="{c(pick(SPACING_MARGIN, 1) + pick(SPACING_PADDING, 1))}">
      <h2 class="{c(join(pick(TYPOGRAPHY, 3), pick(COLORS_TEXT, 1), pick(SPACING_MARGIN, 1)))}">Reviews</h2>
      <div class="{c(["divide-y"] + pick(BORDERS, 1))}">
        <div class="{c(review_cls)}">
          <p class="{c(review_author)}">Alice K.</p>
          <p class="{c(review_text)}">Amazing sound quality, very comfortable for long listening sessions.</p>
        </div>
        <div class="{c(review_cls)}">
          <p class="{c(review_author)}">Bob M.</p>
          <p class="{c(review_text)}">Great noise cancellation. Battery life is exactly as advertised.</p>
        </div>
      </div>
    </section>
  </div>
</body>
</html>"""
    return html, all_classes


def settings_form_page(variant=0):
    all_classes = set()
    def c(lst):
        s = " ".join(lst)
        all_classes.update(lst)
        return s

    container = join(["max-w-2xl", "mx-auto"], pick(SPACING_PADDING, 3))
    form_cls = join(pick(SPACE, 1))
    section_cls = join(pick(SPACING_PADDING, 2), pick(BORDER_RADIUS, 1), pick(COLORS_BG, 1),
                       pick(BORDERS, 1), pick(SHADOWS, 1), pick(DARK_CLASSES, 2))
    section_title = join(pick(TYPOGRAPHY, 3), pick(COLORS_TEXT, 1), pick(SPACING_MARGIN, 1))
    label_cls = join(["block"], pick(TYPOGRAPHY, 2), pick(COLORS_TEXT, 1), pick(SPACING_MARGIN, 1))
    input_cls = join(["block", "w-full"], pick(SPACING_PADDING, 2), pick(BORDERS, 1),
                     pick(BORDER_RADIUS, 1), pick(TYPOGRAPHY, 1), pick(COLORS_BG, 1),
                     pick(COLORS_TEXT, 1), pick(SHADOWS, 1),
                     pick(FOCUS_CLASSES, 3), pick(DARK_CLASSES, 2),
                     pick(OTHER_STATES, 2), pick(TRANSITIONS, 1))
    textarea_cls = join(["block", "w-full", "resize-y"], pick(SPACING_PADDING, 2),
                        pick(BORDERS, 1), pick(BORDER_RADIUS, 1), pick(TYPOGRAPHY, 1),
                        pick(SIZING, 1), pick(FOCUS_CLASSES, 2), pick(DARK_CLASSES, 1))
    select_cls = join(["block", "w-full", "appearance-none"], pick(SPACING_PADDING, 2),
                      pick(BORDERS, 1), pick(BORDER_RADIUS, 1), pick(TYPOGRAPHY, 1),
                      pick(COLORS_BG, 1), pick(FOCUS_CLASSES, 2), pick(DARK_CLASSES, 1))
    toggle_track = join(["relative", "inline-flex", "shrink-0", "cursor-pointer"],
                        pick(SIZING, 2), pick(BORDER_RADIUS, 1), pick(TRANSITIONS, 2),
                        pick(COLORS_BG, 1), pick(FOCUS_CLASSES, 1))
    toggle_knob = join(["inline-block", "rounded-full", "bg-white", "shadow", "transform",
                        "transition-transform"], pick(SIZING, 2))
    checkbox_cls = join(pick(SIZING, 2), pick(BORDER_RADIUS, 1), pick(BORDERS, 1),
                        pick(COLORS_TEXT, 1), pick(FOCUS_CLASSES, 2),
                        pick(OTHER_STATES, 1), pick(INTERACTIVITY, 1))
    helper_text = join(pick(TYPOGRAPHY, 2), pick(COLORS_TEXT, 1), pick(SPACING_MARGIN, 1))
    error_text = join(pick(TYPOGRAPHY, 2), ["text-red-600"], pick(SPACING_MARGIN, 1))
    submit_btn = join(["inline-flex", "items-center", "justify-center"],
                      pick(SPACING_PADDING, 2), pick(BORDER_RADIUS, 1),
                      pick(COLORS_BG, 1), pick(COLORS_TEXT, 1), pick(TYPOGRAPHY, 2),
                      pick(SHADOWS, 1), pick(HOVER_CLASSES, 2), pick(FOCUS_CLASSES, 2),
                      pick(ACTIVE_CLASSES, 1), pick(TRANSITIONS, 2),
                      ["disabled:opacity-50", "disabled:cursor-not-allowed"])
    cancel_btn = join(["inline-flex", "items-center", "justify-center"],
                      pick(SPACING_PADDING, 2), pick(BORDER_RADIUS, 1),
                      pick(BORDERS, 1), pick(COLORS_TEXT, 1), pick(TYPOGRAPHY, 1),
                      pick(HOVER_CLASSES, 2), pick(FOCUS_CLASSES, 1), pick(TRANSITIONS, 1))
    file_input = join(pick(OTHER_STATES, 3))

    html = f"""<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Settings {variant}</title></head>
<body class="{c(["min-h-screen", "bg-gray-50", "dark:bg-gray-900"])}">
  <div class="{c(container)}">
    <h1 class="{c(join(pick(TYPOGRAPHY, 3), pick(COLORS_TEXT, 1), pick(SPACING_MARGIN, 1)))}">Account Settings</h1>
    <form class="{c(form_cls)}">
      <div class="{c(section_cls)}">
        <h2 class="{c(section_title)}">Profile</h2>
        <div class="{c(["flex", "items-center"] + pick(GAP, 1) + pick(SPACING_MARGIN, 1))}">
          <img src="/avatar.jpg" alt="avatar" class="{c(["rounded-full", "object-cover"] + pick(SIZING, 2) + pick(RINGS, 1))}">
          <button type="button" class="{c(cancel_btn)}">Change photo</button>
        </div>
        <div>
          <label class="{c(label_cls)}">Display Name</label>
          <input type="text" class="{c(input_cls)}" value="Jane Doe">
        </div>
        <div>
          <label class="{c(label_cls)}">Email</label>
          <input type="email" class="{c(input_cls)}" value="jane@example.com">
          <p class="{c(helper_text)}">We'll never share your email.</p>
        </div>
        <div>
          <label class="{c(label_cls)}">Bio</label>
          <textarea rows="3" class="{c(textarea_cls)}"></textarea>
        </div>
      </div>
      <div class="{c(section_cls)}">
        <h2 class="{c(section_title)}">Preferences</h2>
        <div>
          <label class="{c(label_cls)}">Language</label>
          <select class="{c(select_cls)}">
            <option>English</option><option>French</option><option>German</option>
          </select>
        </div>
        <div>
          <label class="{c(label_cls)}">Timezone</label>
          <select class="{c(select_cls)}">
            <option>UTC</option><option>EST</option><option>PST</option>
          </select>
        </div>
        <div class="{c(["flex", "items-center", "justify-between"])}">
          <span class="{c(join(pick(TYPOGRAPHY, 1), pick(COLORS_TEXT, 1)))}">Dark Mode</span>
          <button type="button" class="{c(toggle_track)}" role="switch">
            <span class="{c(toggle_knob)}"></span>
          </button>
        </div>
        <div class="{c(["flex", "items-start"] + pick(GAP, 1))}">
          <input type="checkbox" class="{c(checkbox_cls)}">
          <label class="{c(join(pick(TYPOGRAPHY, 1), pick(COLORS_TEXT, 1)))}">Send me marketing emails</label>
        </div>
        <div>
          <label class="{c(label_cls)}">Upload document</label>
          <input type="file" class="{c(file_input)}">
        </div>
      </div>
      <div class="{c(section_cls)}">
        <h2 class="{c(section_title)}">Danger Zone</h2>
        <p class="{c(error_text)}">Deleting your account is irreversible.</p>
        <button type="button" class="{c(join(["inline-flex", "items-center"], pick(SPACING_PADDING, 2), pick(BORDER_RADIUS, 1), ["bg-red-600", "text-white"], pick(HOVER_CLASSES, 1), pick(FOCUS_CLASSES, 1)))}">Delete Account</button>
      </div>
      <div class="{c(["flex", "items-center", "justify-end"] + pick(GAP, 1))}">
        <button type="button" class="{c(cancel_btn)}">Cancel</button>
        <button type="submit" class="{c(submit_btn)}">Save Changes</button>
      </div>
    </form>
  </div>
</body>
</html>"""
    return html, all_classes


def navbar_page(variant=0):
    all_classes = set()
    def c(lst):
        s = " ".join(lst)
        all_classes.update(lst)
        return s

    nav_cls = join(["sticky", "top-0", "z-50"], pick(COLORS_BG, 1),
                   pick(SHADOWS, 1), ["backdrop-blur-lg"], pick(COLORS_WITH_OPACITY, 1),
                   pick(BORDERS, 1), pick(DARK_CLASSES, 2))
    inner = join(["max-w-7xl", "mx-auto", "flex", "items-center", "justify-between"],
                 pick(SPACING_PADDING, 2))
    logo_cls = join(pick(TYPOGRAPHY, 2), pick(COLORS_TEXT, 1), pick(GRADIENTS, 2),
                    ["bg-clip-text", "text-transparent"])
    link_cls = join(pick(TYPOGRAPHY, 1), pick(COLORS_TEXT, 1), pick(HOVER_CLASSES, 2),
                    pick(TRANSITIONS, 1), ["relative"],
                    pick(PSEUDO_CONTENT, 3))
    dropdown_cls = join(["absolute", "top-full", "left-0", "mt-2"],
                        pick(SIZING, 1), pick(COLORS_BG, 1), pick(BORDER_RADIUS, 1),
                        pick(SHADOWS, 1), pick(BORDERS, 1), pick(RINGS, 1),
                        pick(SPACING_PADDING, 1), pick(DARK_CLASSES, 2))
    dropdown_item = join(["block"], pick(SPACING_PADDING, 2), pick(BORDER_RADIUS, 1),
                         pick(TYPOGRAPHY, 1), pick(COLORS_TEXT, 1),
                         pick(HOVER_CLASSES, 2), pick(TRANSITIONS, 1))
    mobile_btn = join(["md:hidden", "inline-flex", "items-center", "justify-center"],
                      pick(SIZING, 2), pick(BORDER_RADIUS, 1),
                      pick(COLORS_TEXT, 1), pick(HOVER_CLASSES, 1), pick(FOCUS_CLASSES, 1))
    avatar_cls = join(["rounded-full", "object-cover"], pick(SIZING, 2),
                      pick(RINGS, 1), ["cursor-pointer"],
                      pick(HOVER_CLASSES, 1), pick(TRANSITIONS, 1))
    search_cls = join(["hidden", "lg:block"], pick(SIZING, 1), pick(SPACING_PADDING, 2),
                      pick(BORDERS, 1), pick(BORDER_RADIUS, 1), pick(COLORS_BG, 1),
                      pick(FOCUS_CLASSES, 2), pick(TYPOGRAPHY, 1),
                      pick(DARK_CLASSES, 1))
    notification_cls = join(["relative", "inline-flex", "items-center", "justify-center"],
                            pick(SIZING, 2), pick(BORDER_RADIUS, 1), pick(COLORS_TEXT, 1),
                            pick(HOVER_CLASSES, 1))
    badge_dot = join(["absolute", "top-0", "right-0", "block"],
                     pick(SIZING, 1), ["rounded-full", "bg-red-500", "ring-2", "ring-white"])

    html = f"""<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Navbar {variant}</title></head>
<body class="{c(["min-h-screen", "bg-gray-50", "dark:bg-gray-950"])}">
  <nav class="{c(nav_cls)}">
    <div class="{c(inner)}">
      <a href="#" class="{c(logo_cls)}">Acme Inc</a>
      <div class="{c(["hidden", "md:flex", "items-center"] + pick(SPACE, 1))}">
        <div class="{c(["relative", "group"])}">
          <a href="#" class="{c(link_cls)}">Products</a>
          <div class="{c(dropdown_cls + ["hidden", "group-hover:block"])}">
            <a href="#" class="{c(dropdown_item)}">Analytics</a>
            <a href="#" class="{c(dropdown_item)}">Automation</a>
            <a href="#" class="{c(dropdown_item)}">Reports</a>
          </div>
        </div>
        <a href="#" class="{c(link_cls)}">Pricing</a>
        <a href="#" class="{c(link_cls)}">Docs</a>
        <a href="#" class="{c(link_cls)}">Blog</a>
      </div>
      <div class="{c(["flex", "items-center"] + pick(GAP, 1))}">
        <input type="search" placeholder="Search..." class="{c(search_cls)}">
        <button class="{c(notification_cls)}">
          <span class="{c(["sr-only"])}">Notifications</span>
          &#128276;
          <span class="{c(badge_dot)}"></span>
        </button>
        <img src="/avatar.jpg" alt="user" class="{c(avatar_cls)}">
        <button class="{c(mobile_btn)}">&#9776;</button>
      </div>
    </div>
  </nav>
  <main class="{c(["max-w-7xl", "mx-auto"] + pick(SPACING_PADDING, 2))}">
    <h1 class="{c(join(pick(TYPOGRAPHY, 3), pick(COLORS_TEXT, 1)))}">Page Content</h1>
    <p class="{c(join(pick(TYPOGRAPHY, 2), pick(COLORS_TEXT, 1)))}">Scroll to see the sticky navigation bar in action.</p>
    <div class="{c(["h-[2000px]"])}"></div>
  </main>
</body>
</html>"""
    return html, all_classes


def footer_page(variant=0):
    all_classes = set()
    def c(lst):
        s = " ".join(lst)
        all_classes.update(lst)
        return s

    footer_cls = join(pick(COLORS_BG, 1), pick(COLORS_TEXT, 1), pick(SPACING_PADDING, 3),
                      pick(BORDERS, 1), pick(DARK_CLASSES, 2))
    grid_cls = join(["grid", "grid-cols-2", "md:grid-cols-4"], pick(GAP, 1))
    col_title = join(pick(TYPOGRAPHY, 2), pick(COLORS_TEXT, 1), pick(SPACING_MARGIN, 1), ["uppercase"])
    link_cls = join(["block"], pick(TYPOGRAPHY, 1), pick(COLORS_TEXT, 1),
                    pick(HOVER_CLASSES, 1), pick(TRANSITIONS, 1), pick(SPACING_MARGIN, 1))
    social_cls = join(["flex", "items-center"], pick(GAP, 1), pick(SPACING_MARGIN, 1))
    social_icon = join(["inline-flex", "items-center", "justify-center"],
                       pick(SIZING, 2), pick(BORDER_RADIUS, 1), pick(COLORS_BG, 1),
                       pick(COLORS_TEXT, 1), pick(HOVER_CLASSES, 2), pick(TRANSITIONS, 1))
    bottom_cls = join(["flex", "flex-col", "md:flex-row", "items-center", "justify-between"],
                      pick(BORDERS, 1), pick(SPACING_PADDING, 1), pick(SPACING_MARGIN, 1))
    bottom_text = join(pick(TYPOGRAPHY, 1), pick(COLORS_TEXT, 1))
    newsletter_cls = join(pick(SPACING_PADDING, 2), pick(BORDER_RADIUS, 1), pick(COLORS_BG, 1),
                          pick(SPACING_MARGIN, 1))
    newsletter_input = join(pick(SIZING, 1), pick(SPACING_PADDING, 2), pick(BORDERS, 1),
                            pick(BORDER_RADIUS, 1), pick(FOCUS_CLASSES, 2), pick(DARK_CLASSES, 1))
    newsletter_btn = join(pick(SPACING_PADDING, 2), pick(BORDER_RADIUS, 1),
                          pick(COLORS_BG, 1), pick(COLORS_TEXT, 1), pick(TYPOGRAPHY, 1),
                          pick(HOVER_CLASSES, 1), pick(TRANSITIONS, 1))

    html = f"""<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Footer {variant}</title></head>
<body class="{c(["min-h-screen", "flex", "flex-col", "bg-white", "dark:bg-gray-950"])}">
  <main class="{c(["flex-1"])}"></main>
  <footer class="{c(footer_cls)}">
    <div class="{c(["max-w-7xl", "mx-auto"])}">
      <div class="{c(grid_cls)}">
        <div>
          <h3 class="{c(col_title)}">Product</h3>
          <a href="#" class="{c(link_cls)}">Features</a>
          <a href="#" class="{c(link_cls)}">Pricing</a>
          <a href="#" class="{c(link_cls)}">Changelog</a>
          <a href="#" class="{c(link_cls)}">Roadmap</a>
        </div>
        <div>
          <h3 class="{c(col_title)}">Company</h3>
          <a href="#" class="{c(link_cls)}">About</a>
          <a href="#" class="{c(link_cls)}">Blog</a>
          <a href="#" class="{c(link_cls)}">Careers</a>
          <a href="#" class="{c(link_cls)}">Press</a>
        </div>
        <div>
          <h3 class="{c(col_title)}">Resources</h3>
          <a href="#" class="{c(link_cls)}">Documentation</a>
          <a href="#" class="{c(link_cls)}">Help Center</a>
          <a href="#" class="{c(link_cls)}">Community</a>
          <a href="#" class="{c(link_cls)}">API</a>
        </div>
        <div>
          <h3 class="{c(col_title)}">Legal</h3>
          <a href="#" class="{c(link_cls)}">Privacy</a>
          <a href="#" class="{c(link_cls)}">Terms</a>
          <a href="#" class="{c(link_cls)}">Cookies</a>
          <a href="#" class="{c(link_cls)}">Licenses</a>
        </div>
      </div>
      <div class="{c(newsletter_cls)}">
        <p class="{c(join(pick(TYPOGRAPHY, 2), pick(COLORS_TEXT, 1)))}">Subscribe to our newsletter</p>
        <div class="{c(["flex"] + pick(GAP, 1) + pick(SPACING_MARGIN, 1))}">
          <input type="email" placeholder="your@email.com" class="{c(newsletter_input)}">
          <button class="{c(newsletter_btn)}">Subscribe</button>
        </div>
      </div>
      <div class="{c(social_cls)}">
        <a href="#" class="{c(social_icon)}">X</a>
        <a href="#" class="{c(social_icon)}">GH</a>
        <a href="#" class="{c(social_icon)}">LI</a>
        <a href="#" class="{c(social_icon)}">YT</a>
      </div>
      <div class="{c(bottom_cls)}">
        <p class="{c(bottom_text)}">&copy; 2026 Acme Inc. All rights reserved.</p>
        <div class="{c(["flex"] + pick(GAP, 1))}">
          <a href="#" class="{c(link_cls)}">Privacy</a>
          <a href="#" class="{c(link_cls)}">Terms</a>
        </div>
      </div>
    </div>
  </footer>
</body>
</html>"""
    return html, all_classes


def hero_section_page(variant=0):
    all_classes = set()
    def c(lst):
        s = " ".join(lst)
        all_classes.update(lst)
        return s

    section_cls = join(["relative", "overflow-hidden", "isolate"],
                       pick(SPACING_PADDING, 4), pick(COLORS_BG, 1),
                       pick(RESPONSIVE_LG, 2), pick(DARK_CLASSES, 2))
    bg_decoration = join(["absolute", "inset-0", "-z-10"], pick(EFFECTS, 2),
                         pick(GRADIENTS, 3), pick(OPACITY, 1))
    inner = join(["max-w-5xl", "mx-auto", "text-center"],
                 pick(RESPONSIVE_LG, 1))
    badge_cls = join(["inline-flex", "items-center"], pick(SPACING_PADDING, 1),
                     pick(BORDER_RADIUS, 1), pick(COLORS_BG, 1), pick(COLORS_TEXT, 1),
                     pick(TYPOGRAPHY, 1), pick(RINGS, 1), pick(SPACING_MARGIN, 1))
    h1_cls = join(pick(TYPOGRAPHY, 5), pick(COLORS_TEXT, 1),
                  pick(RESPONSIVE_SM, 1), pick(RESPONSIVE_MD, 1), pick(RESPONSIVE_LG, 1),
                  pick(DARK_CLASSES, 1))
    gradient_text = join(["bg-clip-text", "text-transparent"], pick(GRADIENTS, 3))
    p_cls = join(pick(TYPOGRAPHY, 3), pick(COLORS_TEXT, 1), pick(SIZING, 1),
                 ["mx-auto"], pick(SPACING_MARGIN, 1), pick(RESPONSIVE_MD, 1))
    btn_primary = join(["inline-flex", "items-center"], pick(SPACING_PADDING, 2),
                       pick(BORDER_RADIUS, 1), pick(COLORS_BG, 1), pick(COLORS_TEXT, 1),
                       pick(TYPOGRAPHY, 1), pick(SHADOWS, 1), pick(TRANSITIONS, 2),
                       pick(HOVER_CLASSES, 3), pick(FOCUS_CLASSES, 2),
                       pick(ACTIVE_CLASSES, 1), pick(TRANSFORMS, 1))
    btn_secondary = join(["inline-flex", "items-center"], pick(SPACING_PADDING, 2),
                         pick(BORDER_RADIUS, 1), pick(BORDERS, 1), pick(COLORS_TEXT, 1),
                         pick(TYPOGRAPHY, 1), pick(HOVER_CLASSES, 2), pick(FOCUS_CLASSES, 1),
                         pick(TRANSITIONS, 1))
    img_cls = join(["w-full", "rounded-2xl", "shadow-2xl"], pick(BORDERS, 1),
                   pick(SPACING_MARGIN, 1), pick(RESPONSIVE_LG, 1))
    floating_el = join(["absolute"], pick(SIZING, 2), pick(BORDER_RADIUS, 1),
                       pick(COLORS_BG, 1), pick(SHADOWS, 1), pick(TRANSITIONS, 2),
                       pick(TRANSFORMS, 2), ["animate-pulse"])

    html = f"""<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Hero {variant}</title></head>
<body class="{c(["min-h-screen", "bg-white", "dark:bg-gray-950"])}">
  <section class="{c(section_cls)}">
    <div class="{c(bg_decoration)}"></div>
    <div class="{c(inner)}">
      <span class="{c(badge_cls)}">New Release v4.0</span>
      <h1 class="{c(h1_cls)}">The future of <span class="{c(gradient_text)}">web development</span></h1>
      <p class="{c(p_cls)}">Build stunning user interfaces faster than ever. Our platform gives you everything you need to create, deploy, and scale modern web applications.</p>
      <div class="{c(["flex", "flex-col", "sm:flex-row", "items-center", "justify-center"] + pick(GAP, 1) + pick(SPACING_MARGIN, 1))}">
        <a href="#" class="{c(btn_primary)}">Start Building</a>
        <a href="#" class="{c(btn_secondary)}">View Demo &rarr;</a>
      </div>
      <div class="{c(["relative"])}">
        <img src="/dashboard.png" alt="Dashboard Preview" class="{c(img_cls)}">
        <div class="{c(floating_el + ["top-4", "right-4"])}"></div>
        <div class="{c(floating_el + ["bottom-4", "left-4"])}"></div>
      </div>
    </div>
  </section>
</body>
</html>"""
    return html, all_classes


def pricing_table_page(variant=0):
    all_classes = set()
    def c(lst):
        s = " ".join(lst)
        all_classes.update(lst)
        return s

    container = join(["max-w-6xl", "mx-auto"], pick(SPACING_PADDING, 3))
    heading = join(["text-center"], pick(TYPOGRAPHY, 4), pick(COLORS_TEXT, 1),
                   pick(SPACING_MARGIN, 1))
    subheading = join(["text-center"], pick(TYPOGRAPHY, 2), pick(COLORS_TEXT, 1),
                      pick(SIZING, 1), ["mx-auto"], pick(SPACING_MARGIN, 1))
    toggle_cls = join(["flex", "items-center", "justify-center"], pick(GAP, 1),
                      pick(SPACING_MARGIN, 1))
    toggle_label = join(pick(TYPOGRAPHY, 1), pick(COLORS_TEXT, 1))
    toggle_bg = join(["relative", "inline-flex"], pick(SIZING, 2), pick(BORDER_RADIUS, 1),
                     pick(COLORS_BG, 1), ["cursor-pointer"], pick(TRANSITIONS, 1))
    grid_cls = join(["grid", "grid-cols-1", "md:grid-cols-3"], pick(GAP, 1),
                    pick(RESPONSIVE_LG, 1))

    def plan_card(name, price, popular=False):
        extra = []
        if popular:
            extra = ["relative", "z-10", "scale-105", "shadow-xl",
                     "border-2", "border-blue-500"]
        card = join(["flex", "flex-col"], pick(SPACING_PADDING, 3),
                    pick(BORDER_RADIUS, 1), pick(COLORS_BG, 1),
                    pick(BORDERS, 1) if not popular else [],
                    pick(SHADOWS, 1), pick(DARK_CLASSES, 2),
                    pick(TRANSITIONS, 2), pick(HOVER_CLASSES, 1), extra)
        popular_badge = join(["absolute", "-top-4", "left-1/2", "-translate-x-1/2"],
                             pick(SPACING_PADDING, 1), pick(BORDER_RADIUS, 1),
                             ["bg-blue-500", "text-white"], pick(TYPOGRAPHY, 1))
        plan_name = join(pick(TYPOGRAPHY, 2), pick(COLORS_TEXT, 1))
        plan_price = join(pick(TYPOGRAPHY, 3), pick(COLORS_TEXT, 1), pick(SPACING_MARGIN, 1))
        plan_period = join(pick(TYPOGRAPHY, 1), pick(COLORS_TEXT, 1))
        feature_list = join(pick(SPACE, 1), pick(SPACING_MARGIN, 1))
        feature_item = join(["flex", "items-center"], pick(GAP, 1),
                            pick(TYPOGRAPHY, 1), pick(COLORS_TEXT, 1))
        check_cls = join(pick(SIZING, 1), ["text-green-500"])
        btn = join(["w-full", "text-center"], pick(SPACING_PADDING, 2),
                   pick(BORDER_RADIUS, 1),
                   ["bg-blue-600", "text-white"] if popular else pick(BORDERS, 1) + pick(COLORS_TEXT, 1),
                   pick(TYPOGRAPHY, 1), pick(HOVER_CLASSES, 2),
                   pick(FOCUS_CLASSES, 1), pick(TRANSITIONS, 1), pick(SPACING_MARGIN, 1))
        badge_html = f'<span class="{c(popular_badge)}">Most Popular</span>' if popular else ""
        return f"""    <div class="{c(card)}">
      {badge_html}
      <h3 class="{c(plan_name)}">{name}</h3>
      <div class="{c(plan_price)}"><span>${price}</span><span class="{c(plan_period)}">/mo</span></div>
      <ul class="{c(feature_list)}">
        <li class="{c(feature_item)}"><span class="{c(check_cls)}">&#10003;</span>Feature one</li>
        <li class="{c(feature_item)}"><span class="{c(check_cls)}">&#10003;</span>Feature two</li>
        <li class="{c(feature_item)}"><span class="{c(check_cls)}">&#10003;</span>Feature three</li>
        <li class="{c(feature_item)}"><span class="{c(check_cls)}">&#10003;</span>Feature four</li>
      </ul>
      <a href="#" class="{c(btn)}">Choose Plan</a>
    </div>"""

    html = f"""<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Pricing {variant}</title></head>
<body class="{c(["min-h-screen", "bg-white", "dark:bg-gray-950"])}">
  <div class="{c(container)}">
    <h1 class="{c(heading)}">Simple, transparent pricing</h1>
    <p class="{c(subheading)}">Choose the plan that works best for you and your team.</p>
    <div class="{c(toggle_cls)}">
      <span class="{c(toggle_label)}">Monthly</span>
      <button class="{c(toggle_bg)}"><span class="{c(["sr-only"])}">Toggle billing</span></button>
      <span class="{c(toggle_label)}">Yearly</span>
    </div>
    <div class="{c(grid_cls)}">
{plan_card("Starter", 9)}
{plan_card("Pro", 29, popular=True)}
{plan_card("Enterprise", 99)}
    </div>
  </div>
</body>
</html>"""
    return html, all_classes


def login_form_page(variant=0):
    all_classes = set()
    def c(lst):
        s = " ".join(lst)
        all_classes.update(lst)
        return s

    wrapper = join(["min-h-screen", "flex", "items-center", "justify-center"],
                   pick(COLORS_BG, 1), pick(SPACING_PADDING, 2), pick(DARK_CLASSES, 1))
    card = join(["w-full"], pick(SIZING, 1), pick(SPACING_PADDING, 3),
                pick(BORDER_RADIUS, 1), pick(COLORS_BG, 1), pick(SHADOWS, 1),
                pick(BORDERS, 1), pick(DARK_CLASSES, 2))
    logo_cls = join(["mx-auto", "block"], pick(SIZING, 2))
    heading = join(["text-center"], pick(TYPOGRAPHY, 3), pick(COLORS_TEXT, 1),
                   pick(SPACING_MARGIN, 1))
    label_cls = join(["block"], pick(TYPOGRAPHY, 2), pick(COLORS_TEXT, 1), pick(SPACING_MARGIN, 1))
    input_cls = join(["block", "w-full"], pick(SPACING_PADDING, 2), pick(BORDERS, 1),
                     pick(BORDER_RADIUS, 1), pick(TYPOGRAPHY, 1), pick(COLORS_BG, 1),
                     pick(SHADOWS, 1), pick(FOCUS_CLASSES, 3), pick(DARK_CLASSES, 2),
                     pick(OTHER_STATES, 2), pick(TRANSITIONS, 1))
    remember_cls = join(["flex", "items-center"], pick(GAP, 1))
    checkbox_cls = join(pick(SIZING, 2), pick(BORDER_RADIUS, 1), pick(BORDERS, 1),
                        pick(COLORS_TEXT, 1), pick(FOCUS_CLASSES, 1))
    forgot_cls = join(pick(TYPOGRAPHY, 1), pick(COLORS_TEXT, 1), pick(HOVER_CLASSES, 1))
    submit_btn = join(["w-full", "flex", "items-center", "justify-center"],
                      pick(SPACING_PADDING, 2), pick(BORDER_RADIUS, 1),
                      ["bg-indigo-600", "text-white"], pick(TYPOGRAPHY, 2),
                      pick(SHADOWS, 1), pick(HOVER_CLASSES, 2), pick(FOCUS_CLASSES, 2),
                      pick(ACTIVE_CLASSES, 1), pick(TRANSITIONS, 2))
    divider = join(["relative", "flex", "items-center"], pick(SPACING_MARGIN, 1))
    divider_line = join(["flex-1", "border-t"], pick(BORDERS, 1))
    divider_text = join(pick(SPACING_PADDING, 1), pick(TYPOGRAPHY, 1), pick(COLORS_TEXT, 1),
                        pick(COLORS_BG, 1))
    social_btn = join(["flex", "items-center", "justify-center", "w-full"],
                      pick(SPACING_PADDING, 2), pick(BORDER_RADIUS, 1),
                      pick(BORDERS, 1), pick(COLORS_TEXT, 1), pick(TYPOGRAPHY, 1),
                      pick(HOVER_CLASSES, 2), pick(TRANSITIONS, 1))
    signup_text = join(["text-center"], pick(TYPOGRAPHY, 1), pick(COLORS_TEXT, 1),
                       pick(SPACING_MARGIN, 1))
    signup_link = join(pick(COLORS_TEXT, 1), pick(TYPOGRAPHY, 1), pick(HOVER_CLASSES, 1))
    pw_wrapper = join(["relative"])
    pw_toggle = join(["absolute", "inset-y-0", "right-0", "flex", "items-center"],
                     pick(SPACING_PADDING, 1), pick(COLORS_TEXT, 1), ["cursor-pointer"])

    html = f"""<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Login {variant}</title></head>
<body>
  <div class="{c(wrapper)}">
    <div class="{c(card)}">
      <img src="/logo.svg" alt="Logo" class="{c(logo_cls)}">
      <h2 class="{c(heading)}">Sign in to your account</h2>
      <form class="{c(pick(SPACE, 1))}">
        <div>
          <label for="email" class="{c(label_cls)}">Email address</label>
          <input id="email" type="email" required class="{c(input_cls)}" placeholder="you@example.com">
        </div>
        <div>
          <label for="password" class="{c(label_cls)}">Password</label>
          <div class="{c(pw_wrapper)}">
            <input id="password" type="password" required class="{c(input_cls)}">
            <button type="button" class="{c(pw_toggle)}">Show</button>
          </div>
        </div>
        <div class="{c(["flex", "items-center", "justify-between"])}">
          <div class="{c(remember_cls)}">
            <input type="checkbox" class="{c(checkbox_cls)}">
            <span class="{c(join(pick(TYPOGRAPHY, 1), pick(COLORS_TEXT, 1)))}">Remember me</span>
          </div>
          <a href="#" class="{c(forgot_cls)}">Forgot password?</a>
        </div>
        <button type="submit" class="{c(submit_btn)}">Sign In</button>
      </form>
      <div class="{c(divider)}">
        <div class="{c(divider_line)}"></div>
        <span class="{c(divider_text)}">or</span>
        <div class="{c(divider_line)}"></div>
      </div>
      <div class="{c(pick(SPACE, 1))}">
        <button class="{c(social_btn)}">Continue with Google</button>
        <button class="{c(social_btn)}">Continue with GitHub</button>
      </div>
      <p class="{c(signup_text)}">Don't have an account? <a href="#" class="{c(signup_link)}">Sign up</a></p>
    </div>
  </div>
</body>
</html>"""
    return html, all_classes


def modal_page(variant=0):
    all_classes = set()
    def c(lst):
        s = " ".join(lst)
        all_classes.update(lst)
        return s

    overlay = join(["fixed", "inset-0", "z-50", "flex", "items-center", "justify-center"],
                   pick(COLORS_WITH_OPACITY, 1), ["backdrop-blur-sm"],
                   pick(TRANSITIONS, 1))
    modal = join(["relative", "w-full"], pick(SIZING, 1), pick(SPACING_PADDING, 3),
                 pick(BORDER_RADIUS, 1), pick(COLORS_BG, 1), pick(SHADOWS, 1),
                 pick(DARK_CLASSES, 2), pick(TRANSFORMS, 1), pick(TRANSITIONS, 2),
                 pick(RESPONSIVE_SM, 1))
    close_btn = join(["absolute", "top-4", "right-4", "inline-flex", "items-center", "justify-center"],
                     pick(SIZING, 2), pick(BORDER_RADIUS, 1), pick(COLORS_TEXT, 1),
                     pick(HOVER_CLASSES, 2), pick(FOCUS_CLASSES, 1), pick(TRANSITIONS, 1))
    icon_cls = join(["mx-auto", "flex", "items-center", "justify-center"],
                    pick(SIZING, 2), pick(BORDER_RADIUS, 1), pick(COLORS_BG, 1),
                    pick(SPACING_MARGIN, 1))
    title = join(["text-center"], pick(TYPOGRAPHY, 3), pick(COLORS_TEXT, 1), pick(SPACING_MARGIN, 1))
    desc = join(["text-center"], pick(TYPOGRAPHY, 2), pick(COLORS_TEXT, 1), pick(SPACING_MARGIN, 1))
    btn_row = join(["flex", "flex-col-reverse", "sm:flex-row", "items-center", "justify-center"],
                   pick(GAP, 1))
    confirm_btn = join(["w-full", "sm:w-auto", "inline-flex", "items-center", "justify-center"],
                       pick(SPACING_PADDING, 2), pick(BORDER_RADIUS, 1),
                       pick(COLORS_BG, 1), pick(COLORS_TEXT, 1), pick(TYPOGRAPHY, 1),
                       pick(HOVER_CLASSES, 2), pick(FOCUS_CLASSES, 1), pick(TRANSITIONS, 1))
    cancel_btn = join(["w-full", "sm:w-auto", "inline-flex", "items-center", "justify-center"],
                      pick(SPACING_PADDING, 2), pick(BORDER_RADIUS, 1),
                      pick(BORDERS, 1), pick(COLORS_TEXT, 1), pick(TYPOGRAPHY, 1),
                      pick(HOVER_CLASSES, 1), pick(FOCUS_CLASSES, 1), pick(TRANSITIONS, 1))
    input_cls = join(["block", "w-full"], pick(SPACING_PADDING, 2), pick(BORDERS, 1),
                     pick(BORDER_RADIUS, 1), pick(FOCUS_CLASSES, 2), pick(SPACING_MARGIN, 1))
    label_cls = join(["block"], pick(TYPOGRAPHY, 1), pick(COLORS_TEXT, 1), pick(SPACING_MARGIN, 1))

    html = f"""<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Modal {variant}</title></head>
<body class="{c(["min-h-screen", "bg-gray-100", "dark:bg-gray-900"])}">
  <div class="{c(overlay)}">
    <div class="{c(modal)}" role="dialog" aria-modal="true">
      <button class="{c(close_btn)}">&times;</button>
      <div class="{c(icon_cls)}">&#9888;</div>
      <h3 class="{c(title)}">Confirm Action</h3>
      <p class="{c(desc)}">Are you sure you want to proceed? This action cannot be undone.</p>
      <div>
        <label class="{c(label_cls)}">Type "confirm" to proceed</label>
        <input type="text" class="{c(input_cls)}" placeholder="confirm">
      </div>
      <div class="{c(btn_row)}">
        <button class="{c(cancel_btn)}">Cancel</button>
        <button class="{c(confirm_btn)}">Confirm</button>
      </div>
    </div>
  </div>
</body>
</html>"""
    return html, all_classes


def sidebar_page(variant=0):
    all_classes = set()
    def c(lst):
        s = " ".join(lst)
        all_classes.update(lst)
        return s

    sidebar = join(["fixed", "inset-y-0", "left-0", "z-40", "flex", "flex-col"],
                   pick(SIZING, 1), pick(COLORS_BG, 1), pick(BORDERS, 1),
                   pick(DARK_CLASSES, 2), pick(TRANSITIONS, 2),
                   pick(TRANSFORMS, 1), pick(RESPONSIVE_MD, 2))
    sidebar_header = join(["flex", "items-center", "shrink-0"],
                          pick(SIZING, 1), pick(SPACING_PADDING, 2), pick(BORDERS, 1))
    sidebar_nav = join(["flex-1", "overflow-y-auto"], pick(SPACING_PADDING, 1))
    nav_section_title = join(pick(TYPOGRAPHY, 2), pick(COLORS_TEXT, 1), pick(SPACING_PADDING, 1),
                             pick(SPACING_MARGIN, 1), ["uppercase"])
    nav_link = join(["flex", "items-center"], pick(GAP, 1), pick(SPACING_PADDING, 2),
                    pick(BORDER_RADIUS, 1), pick(TYPOGRAPHY, 1), pick(COLORS_TEXT, 1),
                    pick(HOVER_CLASSES, 2), pick(TRANSITIONS, 1))
    nav_link_active = join(["flex", "items-center"], pick(GAP, 1), pick(SPACING_PADDING, 2),
                           pick(BORDER_RADIUS, 1), pick(COLORS_BG, 1), pick(COLORS_TEXT, 1),
                           pick(TYPOGRAPHY, 1))
    nav_icon = join(pick(SIZING, 2), pick(COLORS_TEXT, 1))
    sidebar_footer = join(["shrink-0", "flex", "items-center"], pick(SPACING_PADDING, 2),
                          pick(BORDERS, 1))
    avatar = join(["rounded-full", "object-cover"], pick(SIZING, 2))
    user_info = join(["flex-1", "min-w-0"])
    user_name = join(pick(TYPOGRAPHY, 2), pick(COLORS_TEXT, 1), ["truncate"])
    user_email = join(pick(TYPOGRAPHY, 1), pick(COLORS_TEXT, 1), ["truncate"])
    main_cls = join(["md:ml-64", "min-h-screen"], pick(COLORS_BG, 1), pick(SPACING_PADDING, 2))
    collapse_btn = join(["absolute", "-right-3", "top-6", "flex", "items-center", "justify-center"],
                        pick(SIZING, 2), pick(BORDER_RADIUS, 1), pick(COLORS_BG, 1),
                        pick(BORDERS, 1), pick(SHADOWS, 1), pick(HOVER_CLASSES, 1),
                        pick(TRANSITIONS, 1))
    badge_cls = join(["ml-auto", "inline-flex", "items-center", "justify-center"],
                     pick(SIZING, 1), ["min-w-[20px]"], pick(BORDER_RADIUS, 1),
                     ["bg-red-500", "text-white"], pick(TYPOGRAPHY, 1))

    html = f"""<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Sidebar {variant}</title></head>
<body class="{c(["min-h-screen", "bg-gray-50", "dark:bg-gray-950"])}">
  <aside class="{c(sidebar)}">
    <button class="{c(collapse_btn)}">&laquo;</button>
    <div class="{c(sidebar_header)}">
      <span class="{c(join(pick(TYPOGRAPHY, 2), pick(COLORS_TEXT, 1)))}">AppName</span>
    </div>
    <nav class="{c(sidebar_nav)}">
      <p class="{c(nav_section_title)}">Main</p>
      <a href="#" class="{c(nav_link_active)}">
        <span class="{c(nav_icon)}">&#9632;</span> Dashboard
      </a>
      <a href="#" class="{c(nav_link)}">
        <span class="{c(nav_icon)}">&#9733;</span> Projects
        <span class="{c(badge_cls)}">3</span>
      </a>
      <a href="#" class="{c(nav_link)}">
        <span class="{c(nav_icon)}">&#9993;</span> Messages
        <span class="{c(badge_cls)}">12</span>
      </a>
      <p class="{c(nav_section_title)}">Settings</p>
      <a href="#" class="{c(nav_link)}">
        <span class="{c(nav_icon)}">&#9881;</span> General
      </a>
      <a href="#" class="{c(nav_link)}">
        <span class="{c(nav_icon)}">&#128274;</span> Security
      </a>
      <a href="#" class="{c(nav_link)}">
        <span class="{c(nav_icon)}">&#128276;</span> Notifications
      </a>
    </nav>
    <div class="{c(sidebar_footer)}">
      <img src="/avatar.jpg" alt="User" class="{c(avatar)}">
      <div class="{c(user_info)}">
        <p class="{c(user_name)}">Jane Doe</p>
        <p class="{c(user_email)}">jane@example.com</p>
      </div>
    </div>
  </aside>
  <main class="{c(main_cls)}">
    <h1 class="{c(join(pick(TYPOGRAPHY, 3), pick(COLORS_TEXT, 1)))}">Dashboard</h1>
    <p class="{c(join(pick(TYPOGRAPHY, 2), pick(COLORS_TEXT, 1)))}">Welcome back, Jane.</p>
  </main>
</body>
</html>"""
    return html, all_classes


def data_table_page(variant=0):
    all_classes = set()
    def c(lst):
        s = " ".join(lst)
        all_classes.update(lst)
        return s

    container = join(["max-w-7xl", "mx-auto"], pick(SPACING_PADDING, 2))
    card = join(pick(BORDER_RADIUS, 1), pick(COLORS_BG, 1), pick(SHADOWS, 1),
                pick(BORDERS, 1), ["overflow-hidden"], pick(DARK_CLASSES, 2))
    toolbar = join(["flex", "flex-col", "sm:flex-row", "items-start", "sm:items-center", "justify-between"],
                   pick(GAP, 1), pick(SPACING_PADDING, 2), pick(BORDERS, 1))
    search = join(pick(SIZING, 1), pick(SPACING_PADDING, 2), pick(BORDERS, 1),
                  pick(BORDER_RADIUS, 1), pick(FOCUS_CLASSES, 2), pick(TYPOGRAPHY, 1))
    filter_btn = join(["inline-flex", "items-center"], pick(GAP, 1), pick(SPACING_PADDING, 2),
                      pick(BORDERS, 1), pick(BORDER_RADIUS, 1), pick(TYPOGRAPHY, 1),
                      pick(COLORS_TEXT, 1), pick(HOVER_CLASSES, 1))
    table_wrapper = join(["overflow-x-auto"])
    table = join(["w-full", "text-left"], pick(TYPOGRAPHY, 1))
    thead = join(pick(COLORS_BG, 1))
    th = join(pick(SPACING_PADDING, 2), pick(TYPOGRAPHY, 2), pick(COLORS_TEXT, 1),
              ["cursor-pointer", "select-none"], pick(HOVER_CLASSES, 1))
    td = join(pick(SPACING_PADDING, 2), pick(COLORS_TEXT, 1))
    tr_cls = join(pick(BORDERS, 1), pick(HOVER_CLASSES, 1), pick(TRANSITIONS, 1),
                  pick(OTHER_STATES, 1))
    status_active = join(["inline-flex", "items-center"], pick(SPACING_PADDING, 1),
                         pick(BORDER_RADIUS, 1), ["bg-green-100", "text-green-800"],
                         pick(TYPOGRAPHY, 1))
    status_inactive = join(["inline-flex", "items-center"], pick(SPACING_PADDING, 1),
                           pick(BORDER_RADIUS, 1), ["bg-gray-100", "text-gray-800"],
                           pick(TYPOGRAPHY, 1))
    action_btn = join(["inline-flex", "items-center", "justify-center"],
                      pick(SIZING, 2), pick(BORDER_RADIUS, 1), pick(COLORS_TEXT, 1),
                      pick(HOVER_CLASSES, 1), pick(TRANSITIONS, 1))
    pagination = join(["flex", "items-center", "justify-between"],
                      pick(SPACING_PADDING, 2), pick(BORDERS, 1))
    page_info = join(pick(TYPOGRAPHY, 1), pick(COLORS_TEXT, 1))
    page_btns = join(["flex", "items-center"], pick(GAP, 1))
    page_btn = join(["inline-flex", "items-center", "justify-center"],
                    pick(SIZING, 2), pick(BORDER_RADIUS, 1), pick(BORDERS, 1),
                    pick(TYPOGRAPHY, 1), pick(COLORS_TEXT, 1),
                    pick(HOVER_CLASSES, 1), pick(TRANSITIONS, 1))
    page_btn_active = join(["inline-flex", "items-center", "justify-center"],
                           pick(SIZING, 2), pick(BORDER_RADIUS, 1),
                           ["bg-blue-600", "text-white"], pick(TYPOGRAPHY, 1))
    checkbox = join(pick(SIZING, 2), pick(BORDER_RADIUS, 1), pick(BORDERS, 1),
                    pick(FOCUS_CLASSES, 1))

    rows_html = ""
    names = ["Alice Johnson", "Bob Smith", "Carol White", "David Brown", "Eve Davis",
             "Frank Wilson", "Grace Lee", "Henry Taylor", "Ivy Clark", "Jack Moore"]
    for i, name in enumerate(names):
        status = c(status_active) if i % 3 != 0 else c(status_inactive)
        rows_html += f"""          <tr class="{c(tr_cls)}">
            <td class="{c(td)}"><input type="checkbox" class="{c(checkbox)}"></td>
            <td class="{c(td)}">{name}</td>
            <td class="{c(td)}">{name.split()[0].lower()}@example.com</td>
            <td class="{c(td)}"><span class="{status}">{"Active" if i % 3 != 0 else "Inactive"}</span></td>
            <td class="{c(td)}">
              <button class="{c(action_btn)}">&#9998;</button>
              <button class="{c(action_btn)}">&#128465;</button>
            </td>
          </tr>\n"""

    html = f"""<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Data Table {variant}</title></head>
<body class="{c(["min-h-screen", "bg-gray-50", "dark:bg-gray-950"])}">
  <div class="{c(container)}">
    <h1 class="{c(join(pick(TYPOGRAPHY, 3), pick(COLORS_TEXT, 1), pick(SPACING_MARGIN, 1)))}">Users</h1>
    <div class="{c(card)}">
      <div class="{c(toolbar)}">
        <input type="search" placeholder="Search users..." class="{c(search)}">
        <div class="{c(["flex", "items-center"] + pick(GAP, 1))}">
          <button class="{c(filter_btn)}">Filter</button>
          <button class="{c(filter_btn)}">Export</button>
        </div>
      </div>
      <div class="{c(table_wrapper)}">
        <table class="{c(table)}">
          <thead class="{c(thead)}">
            <tr>
              <th class="{c(th)}"><input type="checkbox" class="{c(checkbox)}"></th>
              <th class="{c(th)}">Name</th>
              <th class="{c(th)}">Email</th>
              <th class="{c(th)}">Status</th>
              <th class="{c(th)}">Actions</th>
            </tr>
          </thead>
          <tbody class="{c(["divide-y"] + pick(BORDERS, 1))}">
{rows_html}          </tbody>
        </table>
      </div>
      <div class="{c(pagination)}">
        <p class="{c(page_info)}">Showing 1 to 10 of 50 results</p>
        <div class="{c(page_btns)}">
          <button class="{c(page_btn)}">&laquo;</button>
          <button class="{c(page_btn_active)}">1</button>
          <button class="{c(page_btn)}">2</button>
          <button class="{c(page_btn)}">3</button>
          <button class="{c(page_btn)}">&raquo;</button>
        </div>
      </div>
    </div>
  </div>
</body>
</html>"""
    return html, all_classes


def card_grid_page(variant=0):
    all_classes = set()
    def c(lst):
        s = " ".join(lst)
        all_classes.update(lst)
        return s

    container = join(["max-w-7xl", "mx-auto"], pick(SPACING_PADDING, 2))
    grid = join(["grid", "grid-cols-1", "sm:grid-cols-2", "lg:grid-cols-3", "xl:grid-cols-4"],
                pick(GAP, 1))
    card = join(["group", "relative", "flex", "flex-col", "overflow-hidden"],
                pick(BORDER_RADIUS, 1), pick(COLORS_BG, 1), pick(BORDERS, 1),
                pick(SHADOWS, 1), pick(TRANSITIONS, 2),
                pick(HOVER_CLASSES, 2), pick(DARK_CLASSES, 2))
    card_img_wrapper = join(["relative", "overflow-hidden"], pick(ASPECT_RATIO, 1))
    card_img = join(["w-full", "h-full", "object-cover"], pick(TRANSITIONS, 1),
                    pick(GROUP_PEER, 1))
    card_overlay = join(["absolute", "inset-0"], pick(GRADIENTS, 2),
                        pick(OPACITY, 1), pick(TRANSITIONS, 1), pick(GROUP_PEER, 1))
    card_body = join(["flex", "flex-col", "flex-1"], pick(SPACING_PADDING, 2))
    card_tag = join(["inline-block", "self-start"], pick(SPACING_PADDING, 1),
                    pick(BORDER_RADIUS, 1), pick(COLORS_BG, 1), pick(COLORS_TEXT, 1),
                    pick(TYPOGRAPHY, 1), pick(SPACING_MARGIN, 1))
    card_title = join(pick(TYPOGRAPHY, 3), pick(COLORS_TEXT, 1), pick(SPACING_MARGIN, 1),
                      pick(LINE_CLAMP, 1), pick(GROUP_PEER, 1))
    card_desc = join(pick(TYPOGRAPHY, 2), pick(COLORS_TEXT, 1), pick(LINE_CLAMP, 1), ["flex-1"])
    card_footer = join(["flex", "items-center", "justify-between"],
                       pick(SPACING_PADDING, 2), pick(BORDERS, 1))
    card_author = join(["flex", "items-center"], pick(GAP, 1))
    author_avatar = join(["rounded-full", "object-cover"], pick(SIZING, 2))
    author_name = join(pick(TYPOGRAPHY, 1), pick(COLORS_TEXT, 1))
    card_date = join(pick(TYPOGRAPHY, 1), pick(COLORS_TEXT, 1))
    like_btn = join(["inline-flex", "items-center"], pick(GAP, 1), pick(COLORS_TEXT, 1),
                    pick(HOVER_CLASSES, 1), pick(TRANSITIONS, 1))

    cards_html = ""
    titles = ["Getting Started with Zig", "Modern CSS Techniques", "Elixir Phoenix Tips",
              "WebAssembly Deep Dive", "Database Optimization", "CI/CD Best Practices",
              "GraphQL vs REST", "Docker Containers 101", "Building CLIs in Rust",
              "Kubernetes for Devs", "TypeScript Patterns", "Redis Caching Guide"]
    for i, title in enumerate(titles):
        cards_html += f"""    <article class="{c(card)}">
      <div class="{c(card_img_wrapper)}">
        <img src="/blog-{i+1}.jpg" alt="{title}" class="{c(card_img)}">
        <div class="{c(card_overlay)}"></div>
      </div>
      <div class="{c(card_body)}">
        <span class="{c(card_tag)}">Tech</span>
        <h3 class="{c(card_title)}">{title}</h3>
        <p class="{c(card_desc)}">A comprehensive guide to modern development practices and tooling.</p>
      </div>
      <div class="{c(card_footer)}">
        <div class="{c(card_author)}">
          <img src="/author-{i%4+1}.jpg" alt="Author" class="{c(author_avatar)}">
          <span class="{c(author_name)}">Author {i+1}</span>
        </div>
        <span class="{c(card_date)}">Mar {i+1}</span>
      </div>
    </article>\n"""

    html = f"""<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Card Grid {variant}</title></head>
<body class="{c(["min-h-screen", "bg-gray-50", "dark:bg-gray-950"])}">
  <div class="{c(container)}">
    <h1 class="{c(join(pick(TYPOGRAPHY, 3), pick(COLORS_TEXT, 1), pick(SPACING_MARGIN, 1)))}">Latest Articles</h1>
    <div class="{c(grid)}">
{cards_html}    </div>
  </div>
</body>
</html>"""
    return html, all_classes


def image_gallery_page(variant=0):
    all_classes = set()
    def c(lst):
        s = " ".join(lst)
        all_classes.update(lst)
        return s

    container = join(["max-w-7xl", "mx-auto"], pick(SPACING_PADDING, 2))
    heading = join(pick(TYPOGRAPHY, 4), pick(COLORS_TEXT, 1), pick(SPACING_MARGIN, 1))
    filter_bar = join(["flex", "flex-wrap", "items-center"], pick(GAP, 1),
                      pick(SPACING_MARGIN, 1))
    filter_btn = join(pick(SPACING_PADDING, 2), pick(BORDER_RADIUS, 1),
                      pick(TYPOGRAPHY, 1), pick(COLORS_TEXT, 1),
                      pick(HOVER_CLASSES, 1), pick(TRANSITIONS, 1))
    filter_btn_active = join(pick(SPACING_PADDING, 2), pick(BORDER_RADIUS, 1),
                             ["bg-black", "text-white", "dark:bg-white", "dark:text-black"],
                             pick(TYPOGRAPHY, 1))
    masonry = join(["columns-1", "sm:columns-2", "lg:columns-3", "xl:columns-4"],
                   pick(GAP, 1))
    img_wrapper = join(["relative", "group", "mb-4", "break-inside-avoid", "overflow-hidden"],
                       pick(BORDER_RADIUS, 1))
    img_cls = join(["w-full", "block"], pick(TRANSITIONS, 1), pick(GROUP_PEER, 1))
    img_overlay = join(["absolute", "inset-0", "flex", "flex-col", "items-center", "justify-center"],
                       pick(COLORS_WITH_OPACITY, 1), pick(OPACITY, 1),
                       pick(TRANSITIONS, 1), pick(GROUP_PEER, 1))
    overlay_title = join(pick(TYPOGRAPHY, 2), ["text-white"])
    overlay_btn = join(["inline-flex", "items-center"], pick(SPACING_PADDING, 2),
                       pick(BORDER_RADIUS, 1), ["bg-white", "text-black"],
                       pick(TYPOGRAPHY, 1), pick(HOVER_CLASSES, 1), pick(TRANSITIONS, 1),
                       pick(SPACING_MARGIN, 1))
    lightbox = join(["fixed", "inset-0", "z-50", "flex", "items-center", "justify-center"],
                    ["bg-black/90"], ["backdrop-blur-md"], pick(TRANSITIONS, 1))
    lightbox_img = join(["max-w-full", "max-h-[90vh]", "object-contain"], pick(BORDER_RADIUS, 1),
                        pick(SHADOWS, 1))
    lightbox_close = join(["absolute", "top-4", "right-4"], pick(SIZING, 2),
                          ["text-white", "cursor-pointer"], pick(HOVER_CLASSES, 1))
    lightbox_nav = join(["absolute", "top-1/2", "-translate-y-1/2"],
                        pick(SIZING, 2), ["text-white", "cursor-pointer", "rounded-full"],
                        pick(COLORS_WITH_OPACITY, 1), pick(HOVER_CLASSES, 1))

    imgs_html = ""
    heights = ["h-48", "h-64", "h-72", "h-56", "h-80", "h-40", "h-96", "h-52"]
    for i in range(12):
        h = heights[i % len(heights)]
        imgs_html += f"""    <div class="{c(img_wrapper)}">
      <img src="/gallery-{i+1}.jpg" alt="Photo {i+1}" class="{c(img_cls + [h])}">
      <div class="{c(img_overlay)}">
        <p class="{c(overlay_title)}">Photo {i+1}</p>
        <button class="{c(overlay_btn)}">View</button>
      </div>
    </div>\n"""

    html = f"""<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Gallery {variant}</title></head>
<body class="{c(["min-h-screen", "bg-white", "dark:bg-gray-950"])}">
  <div class="{c(container)}">
    <h1 class="{c(heading)}">Photo Gallery</h1>
    <div class="{c(filter_bar)}">
      <button class="{c(filter_btn_active)}">All</button>
      <button class="{c(filter_btn)}">Nature</button>
      <button class="{c(filter_btn)}">Architecture</button>
      <button class="{c(filter_btn)}">People</button>
      <button class="{c(filter_btn)}">Abstract</button>
    </div>
    <div class="{c(masonry)}">
{imgs_html}    </div>
  </div>
  <!-- Lightbox (hidden by default) -->
  <div class="{c(lightbox + ["hidden"])}" id="lightbox">
    <button class="{c(lightbox_close)}">&times;</button>
    <button class="{c(lightbox_nav + ["left-4"])}">&lsaquo;</button>
    <img src="/gallery-1.jpg" alt="Lightbox" class="{c(lightbox_img)}">
    <button class="{c(lightbox_nav + ["right-4"])}">&rsaquo;</button>
  </div>
</body>
</html>"""
    return html, all_classes


def testimonials_page(variant=0):
    all_classes = set()
    def c(lst):
        s = " ".join(lst)
        all_classes.update(lst)
        return s

    section = join(pick(SPACING_PADDING, 4), pick(COLORS_BG, 1), pick(DARK_CLASSES, 2))
    container = join(["max-w-6xl", "mx-auto"])
    heading = join(["text-center"], pick(TYPOGRAPHY, 4), pick(COLORS_TEXT, 1),
                   pick(SPACING_MARGIN, 1))
    grid = join(["grid", "grid-cols-1", "md:grid-cols-2", "lg:grid-cols-3"], pick(GAP, 1))
    card = join(["relative", "flex", "flex-col"], pick(SPACING_PADDING, 3),
                pick(BORDER_RADIUS, 1), pick(COLORS_BG, 1), pick(BORDERS, 1),
                pick(SHADOWS, 1), pick(TRANSITIONS, 1), pick(HOVER_CLASSES, 1),
                pick(DARK_CLASSES, 2))
    quote_icon = join(["absolute"], pick(TYPOGRAPHY, 1), pick(COLORS_TEXT, 1), pick(OPACITY, 1))
    quote_text = join(pick(TYPOGRAPHY, 2), pick(COLORS_TEXT, 1), ["italic"], pick(SPACING_MARGIN, 1))
    author_row = join(["flex", "items-center"], pick(GAP, 1), ["mt-auto"])
    author_avatar = join(["rounded-full", "object-cover"], pick(SIZING, 2),
                         pick(RINGS, 1))
    author_name = join(pick(TYPOGRAPHY, 2), pick(COLORS_TEXT, 1))
    author_title = join(pick(TYPOGRAPHY, 1), pick(COLORS_TEXT, 1))
    stars = join(["flex"], pick(GAP, 1), pick(COLORS_TEXT, 1), pick(SPACING_MARGIN, 1))
    before_quote = pick(PSEUDO_CONTENT, 3)

    testimonials = [
        ("This product changed our workflow completely.", "Sarah Chen", "CTO, TechCo"),
        ("Incredible performance improvements.", "Mike Rogers", "Lead Dev, StartupXYZ"),
        ("The best developer tool I've used.", "Emily Park", "Founder, DevShop"),
        ("Saved us hundreds of hours.", "Alex Kumar", "VP Eng, BigCorp"),
        ("Simple, fast, and reliable.", "Lisa Wang", "Staff Eng, ScaleUp"),
        ("A game changer for our team.", "Tom Brown", "Architect, CloudInc"),
    ]

    cards_html = ""
    for quote, name, title in testimonials:
        cards_html += f"""    <div class="{c(card)}">
      <span class="{c(quote_icon)}">&ldquo;</span>
      <div class="{c(stars)}">&#9733;&#9733;&#9733;&#9733;&#9733;</div>
      <p class="{c(join(quote_text, before_quote))}">{quote}</p>
      <div class="{c(author_row)}">
        <img src="/avatar.jpg" alt="{name}" class="{c(author_avatar)}">
        <div>
          <p class="{c(author_name)}">{name}</p>
          <p class="{c(author_title)}">{title}</p>
        </div>
      </div>
    </div>\n"""

    html = f"""<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Testimonials {variant}</title></head>
<body class="{c(["min-h-screen", "bg-white", "dark:bg-gray-950"])}">
  <section class="{c(section)}">
    <div class="{c(container)}">
      <h2 class="{c(heading)}">What our customers say</h2>
      <div class="{c(grid)}">
{cards_html}      </div>
    </div>
  </section>
</body>
</html>"""
    return html, all_classes


def faq_page(variant=0):
    all_classes = set()
    def c(lst):
        s = " ".join(lst)
        all_classes.update(lst)
        return s

    container = join(["max-w-3xl", "mx-auto"], pick(SPACING_PADDING, 3))
    heading = join(["text-center"], pick(TYPOGRAPHY, 4), pick(COLORS_TEXT, 1),
                   pick(SPACING_MARGIN, 1))
    subheading = join(["text-center"], pick(TYPOGRAPHY, 2), pick(COLORS_TEXT, 1),
                      pick(SPACING_MARGIN, 1))
    accordion = join(pick(SPACE, 1))
    item = join(pick(BORDERS, 1), pick(BORDER_RADIUS, 1), pick(COLORS_BG, 1),
                ["overflow-hidden"], pick(DARK_CLASSES, 1))
    question = join(["flex", "items-center", "justify-between", "w-full", "text-left",
                     "cursor-pointer"], pick(SPACING_PADDING, 2), pick(TYPOGRAPHY, 2),
                    pick(COLORS_TEXT, 1), pick(HOVER_CLASSES, 1), pick(TRANSITIONS, 1),
                    pick(FOCUS_CLASSES, 1))
    chevron = join(pick(SIZING, 2), pick(COLORS_TEXT, 1), pick(TRANSITIONS, 1),
                   pick(TRANSFORMS, 1), pick(ARIA_DATA_CLASSES, 1))
    answer = join(pick(SPACING_PADDING, 2), pick(TYPOGRAPHY, 1), pick(COLORS_TEXT, 1),
                  pick(BORDERS, 1))

    faqs = [
        ("How does billing work?", "We offer monthly and annual billing. You can upgrade or downgrade at any time."),
        ("Can I cancel anytime?", "Yes, you can cancel your subscription at any time. No questions asked."),
        ("Is there a free trial?", "We offer a 14-day free trial with full access to all features."),
        ("What payment methods do you accept?", "We accept all major credit cards, PayPal, and bank transfers."),
        ("Do you offer refunds?", "Yes, we offer a 30-day money-back guarantee on all plans."),
        ("How do I get support?", "You can reach our support team via email, chat, or phone 24/7."),
    ]

    items_html = ""
    for q, a in faqs:
        items_html += f"""    <div class="{c(item)}">
      <button class="{c(question)}" aria-expanded="false">
        <span>{q}</span>
        <span class="{c(chevron)}">&#9660;</span>
      </button>
      <div class="{c(answer)}">
        <p>{a}</p>
      </div>
    </div>\n"""

    contact = join(["text-center"], pick(SPACING_PADDING, 3), pick(COLORS_BG, 1),
                   pick(BORDER_RADIUS, 1), pick(SPACING_MARGIN, 1))
    contact_link = join(pick(COLORS_TEXT, 1), pick(TYPOGRAPHY, 1), ["underline"],
                        pick(HOVER_CLASSES, 1))

    html = f"""<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>FAQ {variant}</title></head>
<body class="{c(["min-h-screen", "bg-white", "dark:bg-gray-950"])}">
  <div class="{c(container)}">
    <h1 class="{c(heading)}">Frequently Asked Questions</h1>
    <p class="{c(subheading)}">Everything you need to know about our product.</p>
    <div class="{c(accordion)}">
{items_html}    </div>
    <div class="{c(contact)}">
      <p class="{c(join(pick(TYPOGRAPHY, 2), pick(COLORS_TEXT, 1)))}">Still have questions?</p>
      <a href="#" class="{c(contact_link)}">Contact our support team</a>
    </div>
  </div>
</body>
</html>"""
    return html, all_classes


def stats_section_page(variant=0):
    all_classes = set()
    def c(lst):
        s = " ".join(lst)
        all_classes.update(lst)
        return s

    section = join(pick(SPACING_PADDING, 4), pick(COLORS_BG, 1),
                   pick(GRADIENTS, 2), pick(DARK_CLASSES, 1))
    container = join(["max-w-6xl", "mx-auto"])
    heading = join(["text-center"], pick(TYPOGRAPHY, 3), pick(COLORS_TEXT, 1),
                   pick(SPACING_MARGIN, 1))
    grid = join(["grid", "grid-cols-2", "lg:grid-cols-4"], pick(GAP, 1))
    stat = join(["text-center"], pick(SPACING_PADDING, 2), ["relative"],
                pick(PSEUDO_CONTENT, 2))
    stat_value = join(pick(TYPOGRAPHY, 4), pick(COLORS_TEXT, 1),
                      pick(RESPONSIVE_LG, 1))
    stat_label = join(pick(TYPOGRAPHY, 2), pick(COLORS_TEXT, 1), pick(SPACING_MARGIN, 1))
    stat_change = join(["inline-flex", "items-center"], pick(GAP, 1),
                       pick(TYPOGRAPHY, 1), pick(COLORS_TEXT, 1))
    divider = join(["hidden", "lg:block", "absolute", "right-0", "top-1/4", "h-1/2"],
                   pick(BORDERS, 1))

    stats = [
        ("10M+", "Downloads", "+23%"),
        ("99.9%", "Uptime", "+0.1%"),
        ("50K+", "Developers", "+15%"),
        ("<5ms", "Avg Response", "-12%"),
    ]

    stats_html = ""
    for val, label, change in stats:
        stats_html += f"""    <div class="{c(stat)}">
      <div class="{c(divider)}"></div>
      <p class="{c(stat_value)}">{val}</p>
      <p class="{c(stat_label)}">{label}</p>
      <p class="{c(stat_change)}">{change}</p>
    </div>\n"""

    html = f"""<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Stats {variant}</title></head>
<body class="{c(["min-h-screen", "bg-white", "dark:bg-gray-950"])}">
  <section class="{c(section)}">
    <div class="{c(container)}">
      <h2 class="{c(heading)}">Trusted by developers worldwide</h2>
      <div class="{c(grid)}">
{stats_html}      </div>
    </div>
  </section>
</body>
</html>"""
    return html, all_classes


def contact_form_page(variant=0):
    all_classes = set()
    def c(lst):
        s = " ".join(lst)
        all_classes.update(lst)
        return s

    container = join(["max-w-4xl", "mx-auto"], pick(SPACING_PADDING, 3))
    grid = join(["grid", "grid-cols-1", "md:grid-cols-2"], pick(GAP, 1))
    info_side = join(["flex", "flex-col"], pick(SPACE, 1), pick(SPACING_PADDING, 2),
                     pick(BORDER_RADIUS, 1), pick(COLORS_BG, 1), pick(GRADIENTS, 2),
                     pick(COLORS_TEXT, 1))
    info_heading = join(pick(TYPOGRAPHY, 3), ["text-white"])
    info_text = join(pick(TYPOGRAPHY, 2), pick(COLORS_WITH_OPACITY, 1))
    info_item = join(["flex", "items-center"], pick(GAP, 1))
    info_icon = join(pick(SIZING, 2), pick(COLORS_TEXT, 1))
    form_side = join(pick(SPACE, 1))
    label_cls = join(["block"], pick(TYPOGRAPHY, 2), pick(COLORS_TEXT, 1), pick(SPACING_MARGIN, 1))
    input_cls = join(["block", "w-full"], pick(SPACING_PADDING, 2), pick(BORDERS, 1),
                     pick(BORDER_RADIUS, 1), pick(TYPOGRAPHY, 1), pick(COLORS_BG, 1),
                     pick(FOCUS_CLASSES, 3), pick(DARK_CLASSES, 1), pick(TRANSITIONS, 1))
    textarea_cls = join(["block", "w-full", "resize-none"], pick(SPACING_PADDING, 2),
                        pick(BORDERS, 1), pick(BORDER_RADIUS, 1), pick(SIZING, 1),
                        pick(FOCUS_CLASSES, 2))
    submit = join(["w-full", "flex", "items-center", "justify-center"],
                  pick(SPACING_PADDING, 2), pick(BORDER_RADIUS, 1),
                  pick(COLORS_BG, 1), pick(COLORS_TEXT, 1), pick(TYPOGRAPHY, 2),
                  pick(SHADOWS, 1), pick(HOVER_CLASSES, 2), pick(FOCUS_CLASSES, 1),
                  pick(ACTIVE_CLASSES, 1), pick(TRANSITIONS, 2))
    error = join(pick(TYPOGRAPHY, 1), ["text-red-600"], pick(SPACING_MARGIN, 1))
    radio_group = join(["flex", "flex-wrap"], pick(GAP, 1), pick(SPACING_MARGIN, 1))
    radio_label = join(["flex", "items-center"], pick(GAP, 1), pick(TYPOGRAPHY, 1),
                       pick(COLORS_TEXT, 1), ["cursor-pointer"])
    radio_cls = join(pick(SIZING, 2), pick(COLORS_TEXT, 1), pick(FOCUS_CLASSES, 1))

    html = f"""<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Contact {variant}</title></head>
<body class="{c(["min-h-screen", "bg-gray-50", "dark:bg-gray-950"])}">
  <div class="{c(container)}">
    <div class="{c(grid)}">
      <div class="{c(info_side)}">
        <h2 class="{c(info_heading)}">Get in touch</h2>
        <p class="{c(info_text)}">We'd love to hear from you. Send us a message and we'll respond as soon as possible.</p>
        <div class="{c(info_item)}"><span class="{c(info_icon)}">&#9993;</span> hello@example.com</div>
        <div class="{c(info_item)}"><span class="{c(info_icon)}">&#9742;</span> +1 (555) 000-0000</div>
        <div class="{c(info_item)}"><span class="{c(info_icon)}">&#9873;</span> 123 Main St, City, ST 12345</div>
      </div>
      <form class="{c(form_side)}">
        <div class="{c(["grid", "grid-cols-2"] + pick(GAP, 1))}">
          <div>
            <label class="{c(label_cls)}">First Name</label>
            <input type="text" class="{c(input_cls)}" required>
          </div>
          <div>
            <label class="{c(label_cls)}">Last Name</label>
            <input type="text" class="{c(input_cls)}">
          </div>
        </div>
        <div>
          <label class="{c(label_cls)}">Email</label>
          <input type="email" class="{c(input_cls)}" required>
          <p class="{c(error)}" id="email-error"></p>
        </div>
        <div>
          <label class="{c(label_cls)}">Subject</label>
          <div class="{c(radio_group)}">
            <label class="{c(radio_label)}"><input type="radio" name="subject" class="{c(radio_cls)}"> General</label>
            <label class="{c(radio_label)}"><input type="radio" name="subject" class="{c(radio_cls)}"> Support</label>
            <label class="{c(radio_label)}"><input type="radio" name="subject" class="{c(radio_cls)}"> Sales</label>
          </div>
        </div>
        <div>
          <label class="{c(label_cls)}">Message</label>
          <textarea rows="5" class="{c(textarea_cls)}"></textarea>
        </div>
        <button type="submit" class="{c(submit)}">Send Message</button>
      </form>
    </div>
  </div>
</body>
</html>"""
    return html, all_classes


def notification_page(variant=0):
    all_classes = set()
    def c(lst):
        s = " ".join(lst)
        all_classes.update(lst)
        return s

    container = join(["max-w-lg", "mx-auto"], pick(SPACING_PADDING, 2))
    heading = join(pick(TYPOGRAPHY, 3), pick(COLORS_TEXT, 1), pick(SPACING_MARGIN, 1))
    # Toast notifications
    toast_success = join(["flex", "items-start"], pick(GAP, 1), pick(SPACING_PADDING, 2),
                         pick(BORDER_RADIUS, 1), ["bg-green-50", "border", "border-green-200"],
                         pick(SHADOWS, 1), pick(SPACING_MARGIN, 1), pick(DARK_CLASSES, 1))
    toast_error = join(["flex", "items-start"], pick(GAP, 1), pick(SPACING_PADDING, 2),
                       pick(BORDER_RADIUS, 1), ["bg-red-50", "border", "border-red-200"],
                       pick(SHADOWS, 1), pick(SPACING_MARGIN, 1))
    toast_warning = join(["flex", "items-start"], pick(GAP, 1), pick(SPACING_PADDING, 2),
                         pick(BORDER_RADIUS, 1), ["bg-amber-50", "border", "border-amber-200"],
                         pick(SHADOWS, 1), pick(SPACING_MARGIN, 1))
    toast_info = join(["flex", "items-start"], pick(GAP, 1), pick(SPACING_PADDING, 2),
                      pick(BORDER_RADIUS, 1), ["bg-blue-50", "border", "border-blue-200"],
                      pick(SHADOWS, 1), pick(SPACING_MARGIN, 1))
    toast_icon = join(["shrink-0"], pick(SIZING, 2))
    toast_title = join(pick(TYPOGRAPHY, 2), pick(COLORS_TEXT, 1))
    toast_msg = join(pick(TYPOGRAPHY, 1), pick(COLORS_TEXT, 1))
    toast_close = join(["ml-auto", "shrink-0", "inline-flex", "items-center", "justify-center"],
                       pick(SIZING, 2), pick(BORDER_RADIUS, 1), pick(COLORS_TEXT, 1),
                       pick(HOVER_CLASSES, 1), pick(TRANSITIONS, 1))
    progress_bar = join(["h-1", "rounded-full"], pick(COLORS_BG, 1), pick(TRANSITIONS, 1))
    banner = join(["flex", "items-center", "justify-between"], pick(SPACING_PADDING, 2),
                  pick(COLORS_BG, 1), pick(COLORS_TEXT, 1), pick(SPACING_MARGIN, 1))
    banner_close = join(pick(COLORS_TEXT, 1), pick(HOVER_CLASSES, 1), ["cursor-pointer"])

    html = f"""<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Notifications {variant}</title></head>
<body class="{c(["min-h-screen", "bg-gray-50", "dark:bg-gray-950"])}">
  <div class="{c(banner)}">
    <p class="{c(join(pick(TYPOGRAPHY, 1)))}">New version available! <a href="#" class="{c(["underline", "font-semibold"])}">Update now</a></p>
    <button class="{c(banner_close)}">&times;</button>
  </div>
  <div class="{c(container)}">
    <h1 class="{c(heading)}">Notifications</h1>
    <div class="{c(toast_success)}">
      <span class="{c(toast_icon + ["text-green-500"])}">&#10003;</span>
      <div>
        <p class="{c(toast_title)}">Success!</p>
        <p class="{c(toast_msg)}">Your changes have been saved.</p>
        <div class="{c(progress_bar)}" style="width: 75%"></div>
      </div>
      <button class="{c(toast_close)}">&times;</button>
    </div>
    <div class="{c(toast_error)}">
      <span class="{c(toast_icon + ["text-red-500"])}">&#10007;</span>
      <div>
        <p class="{c(toast_title)}">Error</p>
        <p class="{c(toast_msg)}">Something went wrong. Please try again.</p>
      </div>
      <button class="{c(toast_close)}">&times;</button>
    </div>
    <div class="{c(toast_warning)}">
      <span class="{c(toast_icon + ["text-amber-500"])}">&#9888;</span>
      <div>
        <p class="{c(toast_title)}">Warning</p>
        <p class="{c(toast_msg)}">Your session will expire in 5 minutes.</p>
      </div>
      <button class="{c(toast_close)}">&times;</button>
    </div>
    <div class="{c(toast_info)}">
      <span class="{c(toast_icon + ["text-blue-500"])}">&#8505;</span>
      <div>
        <p class="{c(toast_title)}">Info</p>
        <p class="{c(toast_msg)}">A new feature is available.</p>
      </div>
      <button class="{c(toast_close)}">&times;</button>
    </div>
  </div>
</body>
</html>"""
    return html, all_classes


def profile_page(variant=0):
    all_classes = set()
    def c(lst):
        s = " ".join(lst)
        all_classes.update(lst)
        return s

    container = join(["max-w-4xl", "mx-auto"], pick(SPACING_PADDING, 2))
    cover = join(["relative", "h-48", "md:h-64", "overflow-hidden"],
                 pick(BORDER_RADIUS, 1), pick(GRADIENTS, 3))
    avatar_wrapper = join(["relative", "-mt-16", "ml-8"])
    avatar = join(["rounded-full", "object-cover", "ring-4", "ring-white"],
                  pick(SIZING, 2), pick(SHADOWS, 1), pick(DARK_CLASSES, 1))
    info = join(pick(SPACING_PADDING, 2))
    name = join(pick(TYPOGRAPHY, 3), pick(COLORS_TEXT, 1))
    handle = join(pick(TYPOGRAPHY, 2), pick(COLORS_TEXT, 1))
    bio = join(pick(TYPOGRAPHY, 2), pick(COLORS_TEXT, 1), pick(SPACING_MARGIN, 1),
               pick(SIZING, 1))
    stats_row = join(["flex", "flex-wrap"], pick(GAP, 1), pick(SPACING_MARGIN, 1))
    stat_item = join(["flex", "items-center"], pick(GAP, 1))
    stat_num = join(pick(TYPOGRAPHY, 2), pick(COLORS_TEXT, 1))
    stat_lbl = join(pick(TYPOGRAPHY, 1), pick(COLORS_TEXT, 1))
    follow_btn = join(["inline-flex", "items-center"], pick(SPACING_PADDING, 2),
                      pick(BORDER_RADIUS, 1), pick(COLORS_BG, 1), pick(COLORS_TEXT, 1),
                      pick(TYPOGRAPHY, 1), pick(HOVER_CLASSES, 2), pick(FOCUS_CLASSES, 1),
                      pick(TRANSITIONS, 1))
    tabs = join(["flex", "border-b"], pick(BORDERS, 1), pick(SPACING_MARGIN, 1))
    tab = join(pick(SPACING_PADDING, 2), pick(TYPOGRAPHY, 1), pick(COLORS_TEXT, 1),
               pick(HOVER_CLASSES, 1), pick(TRANSITIONS, 1), ["relative"])
    tab_active = join(pick(SPACING_PADDING, 2), pick(TYPOGRAPHY, 2), pick(COLORS_TEXT, 1),
                      ["relative", "border-b-2"], pick(BORDERS, 1))
    post_card = join(pick(SPACING_PADDING, 2), pick(BORDERS, 1), pick(BORDER_RADIUS, 1),
                     pick(COLORS_BG, 1), pick(SPACING_MARGIN, 1), pick(DARK_CLASSES, 1))
    post_meta = join(["flex", "items-center"], pick(GAP, 1), pick(SPACING_MARGIN, 1))
    post_text = join(pick(TYPOGRAPHY, 2), pick(COLORS_TEXT, 1))
    post_actions = join(["flex", "items-center"], pick(GAP, 1), pick(SPACING_MARGIN, 1))
    action_btn = join(["inline-flex", "items-center"], pick(GAP, 1),
                      pick(COLORS_TEXT, 1), pick(HOVER_CLASSES, 1), pick(TRANSITIONS, 1),
                      pick(TYPOGRAPHY, 1))

    html = f"""<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Profile {variant}</title></head>
<body class="{c(["min-h-screen", "bg-gray-50", "dark:bg-gray-950"])}">
  <div class="{c(container)}">
    <div class="{c(cover)}"></div>
    <div class="{c(avatar_wrapper)}">
      <img src="/avatar-large.jpg" alt="Profile" class="{c(avatar)}">
    </div>
    <div class="{c(info)}">
      <div class="{c(["flex", "items-start", "justify-between"])}">
        <div>
          <h1 class="{c(name)}">Jane Doe</h1>
          <p class="{c(handle)}">@janedoe</p>
        </div>
        <button class="{c(follow_btn)}">Follow</button>
      </div>
      <p class="{c(bio)}">Full-stack developer. Open source enthusiast. Building tools that make developers' lives easier.</p>
      <div class="{c(stats_row)}">
        <div class="{c(stat_item)}"><span class="{c(stat_num)}">1,234</span><span class="{c(stat_lbl)}">posts</span></div>
        <div class="{c(stat_item)}"><span class="{c(stat_num)}">56.7K</span><span class="{c(stat_lbl)}">followers</span></div>
        <div class="{c(stat_item)}"><span class="{c(stat_num)}">892</span><span class="{c(stat_lbl)}">following</span></div>
      </div>
    </div>
    <div class="{c(tabs)}">
      <button class="{c(tab_active)}">Posts</button>
      <button class="{c(tab)}">Replies</button>
      <button class="{c(tab)}">Media</button>
      <button class="{c(tab)}">Likes</button>
    </div>
    <div>
      <div class="{c(post_card)}">
        <div class="{c(post_meta)}">
          <img src="/avatar.jpg" class="{c(["rounded-full", "w-10", "h-10"])}">
          <span class="{c(join(pick(TYPOGRAPHY, 1), pick(COLORS_TEXT, 1)))}">Jane Doe</span>
          <span class="{c(join(pick(TYPOGRAPHY, 1), pick(COLORS_TEXT, 1)))}">&middot; 2h</span>
        </div>
        <p class="{c(post_text)}">Just shipped a major update to the CSS compiler. Performance is now 3x faster!</p>
        <div class="{c(post_actions)}">
          <button class="{c(action_btn)}">&#9825; 42</button>
          <button class="{c(action_btn)}">&#128172; 8</button>
          <button class="{c(action_btn)}">&#8635; 12</button>
        </div>
      </div>
    </div>
  </div>
</body>
</html>"""
    return html, all_classes


def checkout_page(variant=0):
    all_classes = set()
    def c(lst):
        s = " ".join(lst)
        all_classes.update(lst)
        return s

    container = join(["max-w-6xl", "mx-auto"], pick(SPACING_PADDING, 2))
    grid = join(["grid", "grid-cols-1", "lg:grid-cols-3"], pick(GAP, 1))
    form_col = join(["lg:col-span-2"])
    summary_col = join(["lg:col-span-1"])
    section = join(pick(SPACING_PADDING, 2), pick(BORDER_RADIUS, 1), pick(COLORS_BG, 1),
                   pick(BORDERS, 1), pick(SHADOWS, 1), pick(SPACING_MARGIN, 1),
                   pick(DARK_CLASSES, 2))
    section_title = join(pick(TYPOGRAPHY, 3), pick(COLORS_TEXT, 1), pick(SPACING_MARGIN, 1))
    label_cls = join(["block"], pick(TYPOGRAPHY, 1), pick(COLORS_TEXT, 1), pick(SPACING_MARGIN, 1))
    input_cls = join(["block", "w-full"], pick(SPACING_PADDING, 2), pick(BORDERS, 1),
                     pick(BORDER_RADIUS, 1), pick(FOCUS_CLASSES, 2), pick(TRANSITIONS, 1))
    two_col = join(["grid", "grid-cols-2"], pick(GAP, 1))
    radio_card = join(["flex", "items-center"], pick(SPACING_PADDING, 2),
                      pick(BORDER_RADIUS, 1), pick(BORDERS, 1), ["cursor-pointer"],
                      pick(HOVER_CLASSES, 1), pick(TRANSITIONS, 1),
                      pick(OTHER_STATES, 1))
    radio_cls = join(pick(SIZING, 2), pick(COLORS_TEXT, 1))
    item_row = join(["flex", "items-center"], pick(GAP, 1), pick(SPACING_PADDING, 1),
                    pick(BORDERS, 1))
    item_img = join(pick(SIZING, 2), pick(BORDER_RADIUS, 1), ["object-cover"])
    item_name = join(pick(TYPOGRAPHY, 2), pick(COLORS_TEXT, 1))
    item_price = join(pick(TYPOGRAPHY, 1), pick(COLORS_TEXT, 1), ["ml-auto"])
    qty_btn = join(["inline-flex", "items-center", "justify-center"],
                   pick(SIZING, 2), pick(BORDERS, 1), pick(BORDER_RADIUS, 1),
                   pick(HOVER_CLASSES, 1))
    qty_input = join(["w-12", "text-center"], pick(BORDERS, 1), pick(TYPOGRAPHY, 1))
    summary_row = join(["flex", "items-center", "justify-between"],
                       pick(SPACING_PADDING, 1))
    summary_label = join(pick(TYPOGRAPHY, 1), pick(COLORS_TEXT, 1))
    summary_value = join(pick(TYPOGRAPHY, 2), pick(COLORS_TEXT, 1))
    total_row = join(["flex", "items-center", "justify-between"],
                     pick(SPACING_PADDING, 1), pick(BORDERS, 1))
    total_label = join(pick(TYPOGRAPHY, 2), pick(COLORS_TEXT, 1))
    total_value = join(pick(TYPOGRAPHY, 3), pick(COLORS_TEXT, 1))
    pay_btn = join(["w-full", "flex", "items-center", "justify-center"],
                   pick(SPACING_PADDING, 2), pick(BORDER_RADIUS, 1),
                   pick(COLORS_BG, 1), pick(COLORS_TEXT, 1), pick(TYPOGRAPHY, 2),
                   pick(SHADOWS, 1), pick(HOVER_CLASSES, 2), pick(FOCUS_CLASSES, 1),
                   pick(TRANSITIONS, 1), pick(SPACING_MARGIN, 1))
    secure_badge = join(["flex", "items-center", "justify-center"], pick(GAP, 1),
                        pick(TYPOGRAPHY, 1), pick(COLORS_TEXT, 1))

    html = f"""<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Checkout {variant}</title></head>
<body class="{c(["min-h-screen", "bg-gray-50", "dark:bg-gray-950"])}">
  <div class="{c(container)}">
    <h1 class="{c(join(pick(TYPOGRAPHY, 3), pick(COLORS_TEXT, 1), pick(SPACING_MARGIN, 1)))}">Checkout</h1>
    <div class="{c(grid)}">
      <div class="{c(form_col)}">
        <div class="{c(section)}">
          <h2 class="{c(section_title)}">Shipping Information</h2>
          <div class="{c(two_col)}">
            <div><label class="{c(label_cls)}">First Name</label><input type="text" class="{c(input_cls)}"></div>
            <div><label class="{c(label_cls)}">Last Name</label><input type="text" class="{c(input_cls)}"></div>
          </div>
          <div><label class="{c(label_cls)}">Address</label><input type="text" class="{c(input_cls)}"></div>
          <div class="{c(["grid", "grid-cols-3"] + pick(GAP, 1))}">
            <div><label class="{c(label_cls)}">City</label><input type="text" class="{c(input_cls)}"></div>
            <div><label class="{c(label_cls)}">State</label><input type="text" class="{c(input_cls)}"></div>
            <div><label class="{c(label_cls)}">ZIP</label><input type="text" class="{c(input_cls)}"></div>
          </div>
        </div>
        <div class="{c(section)}">
          <h2 class="{c(section_title)}">Shipping Method</h2>
          <div class="{c(pick(SPACE, 1))}">
            <label class="{c(radio_card)}"><input type="radio" name="shipping" class="{c(radio_cls)}"><div><p class="{c(join(pick(TYPOGRAPHY, 1), pick(COLORS_TEXT, 1)))}">Standard (5-7 days)</p><p class="{c(join(pick(TYPOGRAPHY, 1), pick(COLORS_TEXT, 1)))}">Free</p></div></label>
            <label class="{c(radio_card)}"><input type="radio" name="shipping" class="{c(radio_cls)}"><div><p class="{c(join(pick(TYPOGRAPHY, 1), pick(COLORS_TEXT, 1)))}">Express (2-3 days)</p><p class="{c(join(pick(TYPOGRAPHY, 1), pick(COLORS_TEXT, 1)))}">$9.99</p></div></label>
          </div>
        </div>
        <div class="{c(section)}">
          <h2 class="{c(section_title)}">Payment</h2>
          <div><label class="{c(label_cls)}">Card Number</label><input type="text" class="{c(input_cls)}" placeholder="4242 4242 4242 4242"></div>
          <div class="{c(two_col)}">
            <div><label class="{c(label_cls)}">Expiry</label><input type="text" class="{c(input_cls)}" placeholder="MM/YY"></div>
            <div><label class="{c(label_cls)}">CVV</label><input type="text" class="{c(input_cls)}" placeholder="123"></div>
          </div>
        </div>
      </div>
      <div class="{c(summary_col)}">
        <div class="{c(section)}">
          <h2 class="{c(section_title)}">Order Summary</h2>
          <div class="{c(item_row)}">
            <img src="/item1.jpg" class="{c(item_img)}">
            <div><p class="{c(item_name)}">Headphones</p><div class="{c(["flex", "items-center"] + pick(GAP, 1))}"><button class="{c(qty_btn)}">-</button><input type="text" value="1" class="{c(qty_input)}"><button class="{c(qty_btn)}">+</button></div></div>
            <span class="{c(item_price)}">$149.99</span>
          </div>
          <div class="{c(item_row)}">
            <img src="/item2.jpg" class="{c(item_img)}">
            <div><p class="{c(item_name)}">Case</p></div>
            <span class="{c(item_price)}">$29.99</span>
          </div>
          <div class="{c(summary_row)}"><span class="{c(summary_label)}">Subtotal</span><span class="{c(summary_value)}">$179.98</span></div>
          <div class="{c(summary_row)}"><span class="{c(summary_label)}">Shipping</span><span class="{c(summary_value)}">Free</span></div>
          <div class="{c(summary_row)}"><span class="{c(summary_label)}">Tax</span><span class="{c(summary_value)}">$14.40</span></div>
          <div class="{c(total_row)}"><span class="{c(total_label)}">Total</span><span class="{c(total_value)}">$194.38</span></div>
          <button class="{c(pay_btn)}">Place Order</button>
          <p class="{c(secure_badge)}">&#128274; Secure checkout</p>
        </div>
      </div>
    </div>
  </div>
</body>
</html>"""
    return html, all_classes


# ---------------------------------------------------------------------------
# Page template registry
# ---------------------------------------------------------------------------
PAGE_GENERATORS = [
    ("landing", landing_page),
    ("dashboard", dashboard_page),
    ("blog", blog_post_page),
    ("ecommerce", ecommerce_product_page),
    ("settings", settings_form_page),
    ("navbar", navbar_page),
    ("footer", footer_page),
    ("hero", hero_section_page),
    ("pricing", pricing_table_page),
    ("login", login_form_page),
    ("modal", modal_page),
    ("sidebar", sidebar_page),
    ("data_table", data_table_page),
    ("card_grid", card_grid_page),
    ("gallery", image_gallery_page),
    ("testimonials", testimonials_page),
    ("faq", faq_page),
    ("stats", stats_section_page),
    ("contact", contact_form_page),
    ("notifications", notification_page),
    ("profile", profile_page),
    ("checkout", checkout_page),
]


def build_extra_class_pool():
    """Build a large pool of additional Tailwind classes for coverage injection.
    These supplement the template-based classes to reach the 2000-3000+ unique class target."""
    extra = []

    # More color scales (neutral, stone)
    for color in ["neutral", "stone"]:
        for shade in [50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 950]:
            extra.append(f"text-{color}-{shade}")
            extra.append(f"bg-{color}-{shade}")
            extra.append(f"border-{color}-{shade}")

    # More ring/divide colors
    for color in ["emerald", "teal", "cyan", "sky", "amber", "yellow", "lime", "orange", "fuchsia", "rose", "pink"]:
        for shade in [100, 200, 300, 500, 700]:
            extra.append(f"ring-{color}-{shade}")
            extra.append(f"divide-{color}-{shade}")

    # More opacity variants on colors
    for color in ["slate", "gray", "red", "blue", "green", "purple", "indigo"]:
        for shade in [400, 500, 600]:
            for op in [10, 20, 30, 50, 75]:
                extra.append(f"bg-{color}-{shade}/{op}")
                extra.append(f"text-{color}-{shade}/{op}")

    # Additional spacing values
    for prefix in ["m", "p"]:
        for side in ["", "x-", "y-", "t-", "r-", "b-", "l-"]:
            for val in [0.5, 1.5, 2.5, 3.5, 14, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 64, 72, 80, 96]:
                extra.append(f"{prefix}{side}{val}")

    # Additional sizing
    for val in ["1/6", "5/6", "1/12", "5/12", "7/12", "11/12", "4/5"]:
        extra.append(f"w-{val}")

    # More arbitrary values
    extras_arb = [
        "w-[100px]", "w-[150px]", "w-[250px]", "w-[350px]", "w-[400px]", "w-[500px]",
        "h-[100px]", "h-[150px]", "h-[250px]", "h-[350px]", "h-[400px]", "h-[500px]",
        "max-w-[800px]", "max-w-[1000px]", "max-w-[1400px]",
        "min-h-[200px]", "min-h-[300px]", "min-h-[400px]", "min-h-[600px]",
        "gap-[2px]", "gap-[3px]", "gap-[5px]", "gap-[8px]", "gap-[12px]", "gap-[16px]", "gap-[20px]",
        "p-[3px]", "p-[5px]", "p-[7px]", "p-[20px]", "p-[24px]",
        "m-[3px]", "m-[5px]", "m-[7px]", "m-[20px]", "m-[24px]",
        "text-[10px]", "text-[11px]", "text-[12px]", "text-[13px]", "text-[15px]",
        "text-[22px]", "text-[28px]", "text-[36px]", "text-[48px]", "text-[56px]", "text-[64px]",
        "rounded-[2px]", "rounded-[6px]", "rounded-[10px]", "rounded-[16px]", "rounded-[20px]", "rounded-[24px]",
        "leading-[1.1]", "leading-[1.3]", "leading-[1.4]", "leading-[1.5]", "leading-[1.6]", "leading-[1.8]",
        "tracking-[0.01em]", "tracking-[0.03em]", "tracking-[0.04em]", "tracking-[0.1em]",
        "border-[1px]", "border-[2px]", "border-[5px]",
        "top-[5px]", "top-[20px]", "left-[5px]", "left-[10px]", "right-[5px]", "right-[10px]",
        "bottom-[5px]", "bottom-[10px]",
        "z-[1]", "z-[2]", "z-[5]", "z-[60]", "z-[70]", "z-[80]",
        "translate-x-[2px]", "translate-x-[5px]", "translate-x-[-10px]",
        "translate-y-[2px]", "translate-y-[5px]", "translate-y-[-10px]",
        "rotate-[5deg]", "rotate-[10deg]", "rotate-[15deg]", "rotate-[30deg]",
        "scale-[1.02]", "scale-[1.05]", "scale-[0.98]", "scale-[0.95]",
        "opacity-[0.1]", "opacity-[0.2]", "opacity-[0.3]", "opacity-[0.4]",
        "opacity-[0.6]", "opacity-[0.7]", "opacity-[0.8]", "opacity-[0.9]",
        "w-[calc(100%-1rem)]", "w-[calc(100%-4rem)]", "w-[calc(50%-1rem)]",
        "h-[calc(100vh-2rem)]", "h-[calc(100vh-8rem)]", "h-[calc(100vh-60px)]",
        "max-h-[200px]", "max-h-[300px]", "max-h-[400px]", "max-h-[500px]",
        "min-w-[100px]", "min-w-[200px]", "min-w-[300px]",
        "inset-[0px]", "inset-[4px]", "inset-[8px]",
        "shadow-[0_1px_2px_rgba(0,0,0,0.05)]", "shadow-[0_0_0_3px_rgba(59,130,246,0.5)]",
        "shadow-[inset_0_2px_4px_rgba(0,0,0,0.1)]",
        "grid-cols-[1fr_2fr]", "grid-cols-[auto_1fr]", "grid-cols-[1fr_1fr_1fr]",
        "grid-cols-[minmax(200px,1fr)_3fr]",
        "grid-rows-[auto_1fr]", "grid-rows-[60px_1fr_40px]",
        "basis-[100px]", "basis-[150px]", "basis-[300px]",
        "duration-[50ms]", "duration-[125ms]", "duration-[250ms]", "duration-[400ms]", "duration-[600ms]",
        "delay-[50ms]", "delay-[250ms]", "delay-[400ms]",
        "blur-[2px]", "blur-[4px]", "blur-[8px]", "blur-[20px]",
        "backdrop-blur-[2px]", "backdrop-blur-[4px]", "backdrop-blur-[8px]",
        "brightness-[1.1]", "brightness-[0.8]", "contrast-[1.1]",
        "hue-rotate-[10deg]", "hue-rotate-[45deg]",
        "saturate-[1.25]", "saturate-[0.75]",
        "drop-shadow-[0_2px_4px_rgba(0,0,0,0.1)]",
        "font-[500]", "font-[700]", "font-[800]",
        "text-[#0ea5e9]", "text-[#8b5cf6]", "text-[#ec4899]", "text-[#f59e0b]", "text-[#10b981]",
        "bg-[#fef3c7]", "bg-[#ecfdf5]", "bg-[#eff6ff]", "bg-[#fdf2f8]", "bg-[#f5f3ff]",
        "border-[#d1d5db]", "border-[#93c5fd]", "border-[#fca5a5]",
        "ring-[5px]", "ring-[6px]",
        "outline-[5px]",
        "columns-[14rem]", "columns-[16rem]", "columns-[20rem]",
        "scroll-mt-[60px]", "scroll-mt-[100px]", "scroll-mb-[60px]",
        "indent-[1em]", "indent-[3em]",
        "space-x-[2px]", "space-x-[4px]", "space-y-[2px]", "space-y-[4px]",
        "decoration-[3px]", "decoration-[4px]",
        "underline-offset-[3px]", "underline-offset-[5px]",
        "line-clamp-[2]", "line-clamp-[4]", "line-clamp-[6]",
        "aspect-[4/3]", "aspect-[16/9]", "aspect-[3/2]", "aspect-[1/1]",
        "size-3", "size-7", "size-9", "size-11", "size-14", "size-20", "size-24",
    ]
    extra.extend(extras_arb)

    # More hover variants
    for color in ["slate", "zinc", "neutral", "stone"]:
        for shade in [50, 100, 200, 600, 700, 800]:
            extra.append(f"hover:bg-{color}-{shade}")
            extra.append(f"hover:text-{color}-{shade}")

    # More focus variants
    for color in ["emerald", "teal", "cyan", "amber", "orange", "violet", "fuchsia", "rose", "pink"]:
        extra.append(f"focus:ring-{color}-500")
        extra.append(f"focus:border-{color}-500")

    # More dark variants
    for color in ["blue", "green", "red", "purple", "indigo", "teal", "cyan", "amber"]:
        for shade in [100, 200, 300, 400, 800, 900]:
            extra.append(f"dark:text-{color}-{shade}")
            extra.append(f"dark:bg-{color}-{shade}")
            extra.append(f"dark:border-{color}-{shade}")

    # More responsive md/lg variants
    for bp in ["sm", "md", "lg", "xl"]:
        for prop in ["text-center", "text-left", "text-right",
                     "items-start", "items-end", "items-center",
                     "justify-start", "justify-end", "justify-center",
                     "self-start", "self-end", "self-center",
                     "flex-1", "flex-none", "flex-auto",
                     "grow", "grow-0", "shrink", "shrink-0",
                     "overflow-hidden", "overflow-auto",
                     "truncate", "whitespace-nowrap",
                     "rounded-none", "rounded-lg", "rounded-xl", "rounded-2xl",
                     "shadow-none", "shadow-sm", "shadow-md", "shadow-lg",
                     "border-0", "border", "border-2",
                     "opacity-0", "opacity-100",
                     "w-1/2", "w-1/3", "w-2/3", "w-1/4", "w-3/4",
                     "h-auto", "h-full", "h-screen",
                     "gap-2", "gap-4", "gap-6", "gap-8",
                     "p-2", "p-4", "p-8", "p-12",
                     "m-0", "m-auto",
                     "absolute", "relative", "fixed", "sticky"]:
            extra.append(f"{bp}:{prop}")

    # More hover+focus combined state classes
    extra_states = [
        "hover:underline-offset-4", "hover:decoration-2",
        "hover:translate-x-1", "hover:translate-x-2",
        "hover:translate-y-1", "hover:-translate-y-2",
        "hover:skew-x-1", "hover:skew-y-1",
        "hover:blur-sm", "hover:grayscale",
        "hover:invert", "hover:sepia",
        "hover:backdrop-blur-sm",
        "hover:ring-offset-2", "hover:ring-offset-4",
        "hover:outline-2", "hover:outline-blue-500",
        "hover:border-b-2", "hover:border-l-4",
        "hover:font-semibold", "hover:font-bold",
        "hover:tracking-wide", "hover:tracking-wider",
        "hover:text-sm", "hover:text-lg",
        "hover:leading-tight", "hover:leading-relaxed",
        "hover:gap-4", "hover:gap-6",
        "hover:p-4", "hover:p-6",
        "focus:bg-blue-50", "focus:bg-indigo-50", "focus:bg-transparent",
        "focus:text-blue-600", "focus:text-indigo-600",
        "focus:shadow-xl", "focus:shadow-2xl",
        "focus:scale-100", "focus:scale-110",
        "focus:translate-y-0", "focus:opacity-100",
        "focus:ring-inset",
        "focus:ring-offset-4",
        "focus:underline", "focus:no-underline",
        "active:bg-indigo-700", "active:bg-indigo-800",
        "active:bg-slate-200", "active:bg-slate-300",
        "active:text-white", "active:text-gray-900",
        "active:border-indigo-700",
        "active:ring-2",
        "active:translate-y-1",
        "active:shadow-inner",
    ]
    extra.extend(extra_states)

    # Before/after with more properties
    extra_pseudo = [
        "before:content-['\\2022']", "after:content-['\\2026']",
        "before:bg-red-500", "after:bg-red-500",
        "before:bg-green-500", "after:bg-green-500",
        "before:bg-purple-500", "after:bg-purple-500",
        "before:bg-gradient-to-b", "after:bg-gradient-to-b",
        "before:bg-gradient-to-l", "after:bg-gradient-to-l",
        "before:w-2", "after:w-2", "before:w-8", "after:w-8",
        "before:h-2", "after:h-2", "before:h-8", "after:h-8",
        "before:rounded-md", "after:rounded-md",
        "before:rounded-lg", "after:rounded-lg",
        "before:opacity-50", "after:opacity-50",
        "before:opacity-75", "after:opacity-75",
        "before:transition-all", "after:transition-all",
        "before:scale-0", "after:scale-0",
        "before:scale-100", "after:scale-100",
        "before:translate-x-full", "after:translate-x-full",
        "before:-translate-x-full", "after:-translate-x-full",
        "before:border-2", "after:border-2",
        "before:border-red-500", "after:border-green-500",
        "before:shadow-sm", "after:shadow-sm",
        "before:ring-2", "after:ring-2",
        "before:duration-300", "after:duration-300",
        "before:ease-in-out", "after:ease-in-out",
    ]
    extra.extend(extra_pseudo)

    # Group/peer with more variants
    extra_group = [
        "group/button", "group/link", "group/row",
        "group-hover:text-red-600", "group-hover:text-green-600",
        "group-hover:bg-blue-50", "group-hover:bg-red-50",
        "group-hover:underline", "group-hover:no-underline",
        "group-hover:ring-4", "group-hover:ring-blue-400",
        "group-hover:rotate-6", "group-hover:-rotate-6",
        "group-hover:scale-110", "group-hover:scale-100",
        "group-hover:opacity-50", "group-hover:opacity-75",
        "group-hover:translate-y-1", "group-hover:translate-y-2",
        "group-focus:bg-blue-50", "group-focus:text-blue-600",
        "group-focus:shadow-md",
        "group-active:scale-95", "group-active:bg-gray-100",
        "peer/checkbox", "peer/toggle",
        "peer-hover:text-blue-500", "peer-hover:bg-gray-50",
        "peer-focus:border-indigo-500", "peer-focus:ring-indigo-500",
        "peer-checked:bg-indigo-500", "peer-checked:border-indigo-500",
        "peer-invalid:text-red-500", "peer-invalid:border-red-400",
        "peer-required:text-red-500",
        "peer-disabled:bg-gray-100", "peer-disabled:cursor-not-allowed",
    ]
    extra.extend(extra_group)

    # More aria/data attributes
    extra_aria = [
        "aria-selected:bg-indigo-500", "aria-selected:text-white",
        "aria-selected:font-semibold", "aria-selected:border-indigo-500",
        "aria-disabled:bg-gray-100", "aria-disabled:text-gray-400",
        "aria-expanded:bg-gray-50", "aria-expanded:shadow-md",
        "aria-checked:bg-green-500", "aria-checked:text-white",
        "aria-current:font-bold", "aria-current:text-blue-600",
        "aria-busy:animate-pulse", "aria-busy:opacity-50",
        "data-[state=closed]:hidden", "data-[state=active]:bg-blue-500",
        "data-[state=active]:text-white",
        "data-[size=sm]:text-sm", "data-[size=lg]:text-lg",
        "data-[variant=primary]:bg-blue-500", "data-[variant=primary]:text-white",
        "data-[variant=danger]:bg-red-500", "data-[variant=danger]:text-white",
        "data-[loading]:animate-pulse", "data-[loading]:opacity-75",
    ]
    extra.extend(extra_aria)

    # Print/motion/supports
    extra_media = [
        "print:text-sm", "print:border", "print:shadow-none", "print:p-0",
        "print:m-0", "print:bg-transparent", "print:text-gray-900",
        "motion-safe:animate-bounce", "motion-safe:animate-pulse",
        "motion-safe:transition-all", "motion-safe:transition-colors",
        "motion-safe:duration-300", "motion-safe:duration-500",
        "motion-reduce:animate-[none]", "motion-reduce:duration-0",
        "motion-reduce:transition-colors",
        "portrait:hidden", "portrait:flex-col",
        "landscape:flex-row", "landscape:grid-cols-2",
        "contrast-more:border-2", "contrast-more:font-bold",
        "contrast-less:opacity-75",
        "supports-[backdrop-filter]:backdrop-blur-lg",
        "supports-[display:grid]:grid-cols-3",
    ]
    extra.extend(extra_media)

    # Gradient from/via/to with more stops
    extra_gradients = [
        "from-sky-400", "from-sky-500", "from-sky-600",
        "from-emerald-400", "from-emerald-500",
        "from-rose-400", "from-rose-500",
        "from-fuchsia-400", "from-fuchsia-500",
        "from-orange-400", "from-orange-500",
        "via-teal-500", "via-emerald-500", "via-rose-500",
        "via-amber-500", "via-orange-500", "via-cyan-500",
        "via-indigo-500", "via-violet-500", "via-fuchsia-500",
        "to-teal-500", "to-teal-600",
        "to-amber-500", "to-amber-600",
        "to-orange-500", "to-orange-600",
        "to-violet-500", "to-violet-600",
        "to-fuchsia-500", "to-fuchsia-600",
        "to-sky-500", "to-sky-600",
        "to-rose-500", "to-rose-600",
        "to-lime-500", "to-lime-600",
        "from-15%", "from-20%", "from-25%", "from-30%",
        "via-20%", "via-40%", "via-60%", "via-80%",
        "to-70%", "to-80%", "to-85%",
    ]
    extra.extend(extra_gradients)

    # SVG extras
    extra_svg = [
        "fill-blue-400", "fill-blue-600", "fill-red-400", "fill-red-600",
        "fill-green-400", "fill-green-600", "fill-purple-500", "fill-indigo-500",
        "fill-amber-500", "fill-yellow-500", "fill-teal-500", "fill-cyan-500",
        "stroke-blue-400", "stroke-blue-600", "stroke-red-400", "stroke-red-600",
        "stroke-green-400", "stroke-green-600", "stroke-purple-500", "stroke-indigo-500",
    ]
    extra.extend(extra_svg)

    # Accent/caret extras
    extra_interact = [
        "accent-red-500", "accent-green-600", "accent-purple-500", "accent-pink-500",
        "accent-teal-500", "accent-amber-500", "accent-orange-500",
        "caret-red-500", "caret-green-500", "caret-indigo-500", "caret-purple-500",
        "cursor-zoom-in", "cursor-zoom-out", "cursor-copy", "cursor-context-menu",
        "cursor-cell", "cursor-alias", "cursor-progress", "cursor-no-drop",
        "cursor-col-resize", "cursor-row-resize", "cursor-n-resize", "cursor-e-resize",
        "cursor-s-resize", "cursor-w-resize",
        "scroll-ml-4", "scroll-mr-4", "scroll-pl-4", "scroll-pr-4",
        "snap-start", "snap-center",
        "overscroll-x-auto", "overscroll-y-auto", "overscroll-x-contain", "overscroll-y-contain",
    ]
    extra.extend(extra_interact)

    # Placeholder-shown, autofill, selection
    extra_pseudo_cls = [
        "placeholder-shown:border-gray-200", "placeholder-shown:text-gray-300",
        "placeholder-shown:bg-gray-50",
        "autofill:bg-yellow-100", "autofill:text-gray-900",
        "selection:bg-indigo-200", "selection:text-indigo-900",
        "selection:bg-purple-200", "selection:text-purple-900",
        "selection:bg-green-200",
    ]
    extra.extend(extra_pseudo_cls)

    # first/last/odd/even with more properties
    extra_child = [
        "first:border-t", "first:rounded-t-xl",
        "last:border-b", "last:rounded-b-xl",
        "first:pl-0", "last:pr-0",
        "first:ml-0", "last:mr-0",
        "odd:bg-slate-50", "even:bg-slate-50",
        "odd:bg-zinc-50", "even:bg-zinc-50",
        "first-of-type:font-bold", "last-of-type:font-bold",
        "only:py-4", "only:mx-auto",
        "first:pt-4", "last:pb-4",
        "odd:dark:bg-gray-800", "even:dark:bg-gray-800",
        "empty:p-4", "empty:border-dashed",
    ]
    extra.extend(extra_child)

    # Table-related
    extra_tables = [
        "border-spacing-1", "border-spacing-3", "border-spacing-6", "border-spacing-8",
        "border-spacing-x-2", "border-spacing-x-4", "border-spacing-y-2", "border-spacing-y-4",
        "table-header-group", "table-footer-group", "table-row-group",
        "table-column", "table-column-group", "table-caption",
    ]
    extra.extend(extra_tables)

    # Columns variants
    extra_columns = [
        "columns-5", "columns-6", "columns-7", "columns-8", "columns-9", "columns-10", "columns-11", "columns-12",
        "columns-xl", "columns-2xl", "columns-3xl",
    ]
    extra.extend(extra_columns)

    # Logical properties
    extra_logical = [
        "mbs-2", "mbs-4", "mbs-6", "mbs-8", "mbs-auto",
        "mbe-2", "mbe-4", "mbe-6", "mbe-8",
        "-mbs-2", "-mbs-4", "-mbe-2",
        "pbs-2", "pbs-4", "pbs-6", "pbs-8",
        "pbe-2", "pbe-4", "pbe-6", "pbe-8",
        "mis-2", "mis-4", "mis-auto", "mie-2", "mie-4",
        "-mis-2", "-mie-4",
        "inline-full", "inline-auto", "inline-1/2", "inline-1/3",
        "min-inline-0", "max-inline-lg", "max-inline-xl",
        "block-full", "block-auto", "block-screen",
        "min-block-0", "max-block-screen",
        "sm:mbs-4", "md:pbs-6", "lg:inline-1/2",
        "hover:mbs-2", "dark:pbe-8",
    ]
    extra.extend(extra_logical)

    # Viewport units
    extra_viewport = [
        "w-svw", "w-lvw", "w-dvw",
        "h-svh", "h-lvh", "h-dvh",
        "min-h-svh", "min-h-dvh", "min-h-lvh",
        "max-h-svh", "max-h-dvh", "max-h-lvh",
        "h-lh",
        "sm:h-svh", "md:h-dvh", "lg:min-h-svh",
    ]
    extra.extend(extra_viewport)

    # Mask utilities
    extra_mask = [
        "mask-clip-border", "mask-clip-padding", "mask-clip-content",
        "mask-origin-border", "mask-origin-padding", "mask-origin-content",
        "mask-mode-alpha", "mask-mode-luminance", "mask-mode-match",
        "mask-composite-add", "mask-composite-subtract", "mask-composite-intersect", "mask-composite-exclude",
        "mask-type-alpha", "mask-type-luminance",
        "mask-repeat", "mask-no-repeat", "mask-repeat-x", "mask-repeat-y",
        "mask-auto", "mask-cover", "mask-contain",
        "mask-center", "mask-top", "mask-bottom", "mask-left", "mask-right",
        "mask-image-[url('/mask.svg')]", "mask-image-[url('/gradient.png')]",
    ]
    extra.extend(extra_mask)

    # 3D transforms
    extra_3d = [
        "rotate-x-12", "rotate-x-45", "rotate-x-90", "rotate-x-180",
        "rotate-y-12", "rotate-y-45", "rotate-y-90", "rotate-y-180",
        "rotate-z-45", "rotate-z-90", "rotate-z-180",
        "-rotate-x-12", "-rotate-x-45", "-rotate-y-12", "-rotate-y-90",
        "translate-z-2", "translate-z-4", "translate-z-8", "translate-z-12",
        "-translate-z-2", "-translate-z-4",
        "scale-z-50", "scale-z-75", "scale-z-100", "scale-z-125", "scale-z-150",
        "hover:rotate-x-12", "hover:rotate-y-45",
        "group-hover:rotate-x-180", "group-hover:translate-z-4",
        "sm:rotate-x-45", "md:translate-z-8",
    ]
    extra.extend(extra_3d)

    # Touch action composition
    extra_touch = [
        "touch-pan-x", "touch-pan-y", "touch-pinch-zoom",
        "touch-pan-left", "touch-pan-right", "touch-pan-up", "touch-pan-down",
    ]
    extra.extend(extra_touch)

    return extra


def inject_extra_classes_as_html(extra_classes_batch):
    """Create realistic HTML elements using the extra classes.
    Groups classes into small batches and puts them on realistic elements."""
    elements = []
    # Distribute classes across different realistic element types
    el_templates = [
        '<div class="{cls}"><span>Content</span></div>',
        '<section class="{cls}"><p>Section content</p></section>',
        '<article class="{cls}"><h3>Title</h3><p>Body text</p></article>',
        '<button class="{cls}">Action</button>',
        '<a href="#" class="{cls}">Link text</a>',
        '<span class="{cls}">Inline text</span>',
        '<p class="{cls}">Paragraph content here.</p>',
        '<input type="text" class="{cls}" placeholder="Input">',
        '<img src="/placeholder.jpg" alt="img" class="{cls}">',
        '<ul class="{cls}"><li>Item</li></ul>',
        '<nav class="{cls}"><a href="#">Nav link</a></nav>',
        '<header class="{cls}"><h2>Header</h2></header>',
        '<footer class="{cls}"><p>Footer</p></footer>',
        '<label class="{cls}">Label text</label>',
        '<figure class="{cls}"><img src="/fig.jpg" alt="fig"></figure>',
        '<aside class="{cls}"><p>Sidebar</p></aside>',
    ]

    # Group extra classes into sets of 3-6 per element
    i = 0
    while i < len(extra_classes_batch):
        chunk_size = random.randint(3, 6)
        chunk = extra_classes_batch[i:i+chunk_size]
        template = random.choice(el_templates)
        elements.append("    " + template.format(cls=" ".join(chunk)))
        i += chunk_size

    return "\n".join(elements)


def main():
    import sys
    seed = 42
    num_pages = 120
    output_dir = OUTPUT_DIR

    # Parse CLI args: generate_pages.py [--seed N] [--pages N] [--output DIR]
    args = sys.argv[1:]
    i = 0
    while i < len(args):
        if args[i] == "--seed" and i + 1 < len(args):
            seed = int(args[i + 1]); i += 2
        elif args[i] == "--pages" and i + 1 < len(args):
            num_pages = int(args[i + 1]); i += 2
        elif args[i] == "--output" and i + 1 < len(args):
            output_dir = args[i + 1]; i += 2
        else:
            i += 1

    random.seed(seed)

    os.makedirs(output_dir, exist_ok=True)

    # Build extra class pool
    extra_pool = build_extra_class_pool()
    # Deduplicate and collect all existing template-pool classes
    all_template_classes = set()
    for pool in ALL_POOLS:
        all_template_classes.update(pool)
    # Filter extra pool to only truly new classes
    extra_pool = [c for c in extra_pool if c not in all_template_classes]
    # Shuffle for even distribution
    random.shuffle(extra_pool)

    all_classes_global = set()
    num_generators = len(PAGE_GENERATORS)

    # Distribute extra classes evenly across pages
    extras_per_page = len(extra_pool) // num_pages
    remainder = len(extra_pool) % num_pages

    for i in range(num_pages):
        gen_idx = i % num_generators
        variant = i // num_generators
        gen_name, gen_func = PAGE_GENERATORS[gen_idx]
        html, classes = gen_func(variant)
        all_classes_global.update(classes)

        # Calculate this page's extra class slice
        start = i * extras_per_page + min(i, remainder)
        end = start + extras_per_page + (1 if i < remainder else 0)
        page_extras = extra_pool[start:end]
        all_classes_global.update(page_extras)

        # Inject extra classes as realistic HTML elements before </body>
        if page_extras:
            extra_html = inject_extra_classes_as_html(page_extras)
            # Insert a "component showcase" section before </body>
            showcase = f'\n  <!-- Additional components -->\n  <section class="hidden" aria-hidden="true">\n{extra_html}\n  </section>'
            html = html.replace("</body>", f"{showcase}\n</body>")

        filename = f"page-{i+1:03d}.html"
        filepath = os.path.join(output_dir, filename)
        with open(filepath, "w") as f:
            f.write(html)

    # Print stats
    print(f"Generated {num_pages} pages in {output_dir} (seed={seed})")
    print(f"Total unique classes: {len(all_classes_global)}")


if __name__ == "__main__":
    main()
