const std = @import("std");
const tailwind = @import("tailwind_compiler");

pub fn main(init: std.process.Init) !void {
    const gpa = init.gpa;

    const candidates = [_][]const u8{
        // ─── Static (core) ───
        "flex",         "block",        "hidden",       "absolute",     "relative",
        "sticky",       "isolate",      "sr-only",      "truncate",     "underline",
        "italic",       "uppercase",    "antialiased",  "cursor-pointer","select-none",
        "flex-col",     "items-center", "justify-between","overflow-hidden","container",
        "inline-table", "backface-hidden","transform-gpu","transform-3d","bg-none",
        "accent-auto",  "outline-hidden","inset-auto",  "top-auto",     "scale-none",
        "rotate-none",  "transform-none","decoration-auto","decoration-from-font",
        "max-w-prose",  "max-w-none",   "divide-solid", "divide-dashed",
        "font-stretch-condensed",       "object-center","object-right-top",
        "justify-center-safe",          "items-center-safe","self-baseline-last",
        "shadow-initial","inset-shadow-none","ring-inset","text-shadow-none",
        "space-x-reverse","divide-x-reverse",
        "scheme-dark-light",

        // ─── Spacing ───
        "p-4",      "px-6",     "py-2",     "m-2",      "mt-8",     "-mt-4",
        "mx-auto",  "gap-4",    "space-x-4","space-y-2",

        // ─── Scroll ───
        "scroll-mt-4",  "scroll-px-8",  "scroll-mb-2",

        // ─── Sizing ───
        "w-full",   "w-1/2",    "h-screen", "size-8",   "min-h-0",

        // ─── Inset ───
        "inset-0",  "top-0",    "right-4",

        // ─── Colors (with opacity) ───
        "bg-red-500",       "bg-blue-500/50",   "text-white",
        "text-gray-900",    "border-gray-200",  "bg-transparent",
        "text-inherit",     "bg-[#0088cc]",     "fill-red-500",
        "stroke-blue-500/75","caret-green-500",

        // ─── Typography ───
        "text-sm",  "text-lg",  "text-2xl", "font-sans","font-bold",
        "font-semibold",    "leading-tight",    "leading-6",
        "tracking-wide",    "font-weight-[900]",

        // ─── Border ───
        "border",   "border-2", "border-t", "rounded-lg","rounded-full",
        "divide-x", "divide-y-2",

        // ─── Effects ───
        "opacity-50",  "shadow-md",    "shadow-lg",    "shadow-none",
        "ring-2",      "ring-offset-2","ring-offset-blue-500",
        "inset-ring-2","inset-ring-red-500",
        "inset-shadow-sm","inset-shadow-none",
        "text-shadow-sm","text-shadow-none",
        "blur-sm",  "brightness-75","grayscale","contrast-125",
        "saturate-150","sepia","hue-rotate-90",
        "backdrop-blur-sm","backdrop-opacity-50",

        // ─── Transforms ───
        "rotate-45",   "-rotate-12",   "scale-95",     "translate-x-4",
        "-translate-y-2","skew-x-6",

        // ─── Grid ───
        "cols-3",   "col-span-2",   "col-start-1",
        "rows-2",   "row-span-full","auto-cols-fr",

        // ─── Aspect ───
        "aspect-video","aspect-square","aspect-4/3",

        // ─── Gradients ───
        "bg-linear-to-r","bg-linear-to-br","-bg-linear-45",
        "from-red-500","via-blue-500","to-green-500",
        "from-purple-500/50",

        // ─── Z/Order ───
        "z-10", "z-50", "-z-10", "order-first",

        // ─── Transitions ───
        "transition","duration-300","delay-150","ease-in-out",

        // ─── Animation ───
        "animate-spin","animate-bounce",

        // ─── Line clamp ───
        "line-clamp-3",

        // ─── Mask ───
        "mask-image-[url('/mask.svg')]",

        // ─── Grow/Shrink ───
        "grow-[2]","shrink-[0]",

        // ─── Content / List ───
        "content-none","list-disc","list-image-none",

        // ─── Perspective / Origin / Columns ───
        "perspective-normal","origin-top-right","columns-3",

        // ─── Outline ───
        "outline-offset-2",

        // ─── Underline ───
        "underline-offset-4",

        // ─── Important ───
        "flex!",

        // ─── Arbitrary ───
        "[color:red]","[display:grid]","w-[calc(100%-2rem)]",

        // ─── ALL variant types ───
        "hover:bg-blue-500",    "hover:underline",
        "focus:outline-none",   "focus:ring-2",
        "active:scale-95",      "disabled:opacity-50",
        "dark:bg-gray-900",     "dark:text-white",
        "sm:grid",              "sm:flex",
        "md:cols-2",            "lg:text-xl",         "2xl:hidden",
        "first:mt-0",           "last:mb-0",
        "odd:bg-gray-50",       "even:bg-white",
        "before:content-['']",  "after:block",
        "placeholder:text-gray-400",
        "group-hover:text-blue-500","peer-focus:ring-2",
        "group-aria-checked:bg-blue-500",
        "has-checked:border-blue-500",
        "not-first:mt-4",
        "in-[.dark]:bg-black",
        "aria-checked:bg-blue-500",
        "data-disabled:opacity-50",
        "supports-gap:grid",
        "nth-3:bg-red-500",
        "@lg:text-xl",
        "starting:opacity-0",
        "print:hidden",
        "ltr:text-left",
        "rtl:text-right",
        "portrait:flex-col",
        "landscape:flex-row",
        "motion-safe:transition",
        "motion-reduce:transition-none",
        "contrast-more:border-2",
        "forced-colors:outline-2",
        "focus-visible:ring-2",
        "focus-within:ring-2",
        "open:opacity-100",
        "[&>svg]:w-4",
        "max-lg:hidden",
    };

    const css = try tailwind.compile(gpa, &candidates, null, false, true, null, null, null);

    std.log.info("Generated CSS ({d} bytes, {d} candidates)", .{ css.len, candidates.len });
    std.log.info("{s}", .{css});
}
