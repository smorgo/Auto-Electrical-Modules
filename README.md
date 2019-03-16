# Auto Electrical Modules
3D printable designs for a suite of modular components to create auto-electrical installations.

The printable components in this project are intended to be compatible with the [MTA Modular Fuse Holder System](http://www.mta.it/en/frames-modules). The MTA Modular Fuse Holder System is available in the UK from such vendors as [12VoltPlanet](https://www.12voltplanet.co.uk/mta-modular-fuse-relay-holding-system.html) and [Polevolt](https://www.polevolt.co.uk/acatalog/Modular_Fuse_and_Relay_System.html).

The project originated from a need to include some electronics in an automotive power distribution system that uses the MTA system. The lack of a suitable module in the MTA range led to the design of a 3D printable enclosure that fits into the MTA frames or brackets, alongside the regular fuse and relay modules.

## Printable Components
The project includes OpenSCAD source code to generate the following components:
* A lidded enclosure with a parameterised height
* End brackets with a parameterised number of module ways
* Module locks for the end brackets [see below](#Module-Locks)

You can use modules generated from this project with its accompanying end brackets, or you can use them with the original MTA backets and frames. Conversely, you can use MTA modules with the brackets generated from this project.

## Rendered Examples
The Renders folder in the repository contain a small number of STL files generated from the OpenSCAD source code, including:
* [40mm tall enclosure module](https://github.com/smorgo/Auto-Electrical-Modules/blob/master/Renders/Module_40mm.stl)
* [Lid for the enclosure module](https://github.com/smorgo/Auto-Electrical-Modules/blob/master/Renders/Module_Lid.stl)
* [Two-way end bracket](https://github.com/smorgo/Auto-Electrical-Modules/blob/master/Renders/mounttest.stl)
* [Locking clip for the end bracket (two needed per bracket)](https://github.com/smorgo/Auto-Electrical-Modules/blob/master/Renders/locktest.stl)

## Intended Use
I designed this project to complement the MTA Modular Fuse and Relay Holder System, not to replicate it and certainly not to infringe any copyright. Use the project responsibly.

## Module Locks
The standard MTA frames and brackets include a plastic locking tab to hold the modules securely in place. The same design can't be readily replicated in this 3D printed design for two reasons: (1) the tab would normally be printed in mid-air and I'm trying to avoid using supports and (2) the layer structure would be perpendicular to the plane of flex, making it weak and liable to break.

I had a rethink and generated a separate locking component that clips to the end bracket. Being printed separately, it can have the layers oriented parallel to the plane of flex, making it much stronger. It can also be printed completely without the need for supports.

It's not an entirely reliable locking system, yet. Under significant pressure, the lock can disengage. A few more iterations of the design may be useful, but it's reasonably effective and could be made more robust with a well-placed dab of glue.


