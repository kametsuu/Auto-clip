# Autoclip - version 0.2
## _Generates clip mask by subtracting images and turns it to vector mask_

_Sadly for now it has it's flaws, however as time passes I ought to improve as much as I can, however it's nearly impossible to make it work perfectly._

For now it struggle with:
- Sharp edges
- Moving scenes

## How to configure

- Open autoclip.lua file and at the very top replace in the `exec` variable path of the . exe file.

## How to use
Go to frame, where there is no object and then open GUI and set minuend (by clicking the relevant button for type of frame it'll automatically set current video time). Then skip to the same frame but now with appeared object and set range by adequately seting subtrahend "from" and "to" frames (If you want just one frame, then set time on both frames the same). When everything will be done, click "apply" button. If your computer is slow or/and you choosen large frame range, it may take some time.

## Params
While frame times are intuitive, other options may not be, so I'll explain them.
- Erosion level - If you had a problem that clip outline is too inward or outward, then by choosing different level of it may fix that problem.
- Minimum area - If you want to get rid of smaller objects, you can adjust that all contours whose area is smaller than this value will be removed.
- Cliptype - If you want the inside of the mask to be visible instead of the outside, just change it from \iclip to \clip.

## Changelog
0.2 - Improved mask detection, added GUI, added functionality to use fragments rather than just two choosen frames, added settings (Erosion level, Minimum area and Clip type)
0.0.1 - Initial commit
