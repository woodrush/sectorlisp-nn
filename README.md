# Handwritten Digit Recognition in SectorLISP
At the dawn of Lisp, Lisp was used as a language for creating advanced artifical intelligence.
We make that a reality once again by running a neural network for handwritten digit recognition,
written in pure lisp (without builtin integers or floating point numbers) that runs on the IBM PC model 5150.

[SectorLISP](https://justine.lol/sectorlisp2/) is an amazing project
where a fully functional Lisp interpreter is fit into the 512 bytes of the boot sector of a floppy disk.
Since it works as a boot sector program, the binary can be written to a disk to be used as a boot drive,
where the computer presents an interface for writing and evaluating Lisp programs,
all running in the booting phase of bare metal on the 436-byte program.

In this project, we implement a neural network that runs on SectorLISP.
Since SectorLISP runs on the IBM PC model 5150,
this implementation allows neural networks to run on the boot phase of vintage PCs.


## Usage
Here are the instructions for running the neural network implemented in SectorLISP.

First, `git clone` the SectorLISP repository and `make` SectorLISP's binary, `sectorlisp.bin`:

```sh
git clone https://github.com/jart/sectorlisp
cd sectorlisp
git checkout io
make
```

This will generate `sectorlisp.bin` under `./sectorlisp`.

By building a [fork](https://woodrush.github.io/blog/posts/2022-01-12-sectorlisp-io.html)
of SectorLISP that supports I/O, an additional output with some messages indicating the input and the output will become printed.
Since the source code for this project is backwards comptible with the main SectorLISP branch,
the same code can be run on both versions.

The source code for this project is available at []().

To run SectorLISP on the i8086 emulator [Blinkenlights](https://justine.lol/blinkenlights/),
first follow the instructions on its [download page](https://justine.lol/blinkenlights/download.html)
and get the latest version:

```sh
curl https://justine.lol/blinkenlights/blinkenlights-latest.com >blinkenlights.com
chmod +x blinkenlights.com
```

You can then run SectorLISP by running:

```sh
./blinkenlights.com -rt sectorlisp.bin
```

In some cases, there might be a graphics-related error showing and the emulator may not start.
In that case, run the following command first available on the download page:

```sh
sudo sh -c "echo ':APE:M::MZqFpD::/bin/sh:' >/proc/sys/fs/binfmt_misc/register"
```

Running this command should allow you to run Blinkenlights on your terminal.

After starting Blinkenlights,
expand the size of your terminal large enough so that the `TELETYPEWRITER` region shows up
at the center of the screen.
This region is the console used for input and output.
Then, press `c` to run the emulator in continuous mode.
The cursor in the `TELETYPEWRITER` region should move one line down.
You can then start typing in text or paste a long code from your terminal into Blinkenlight's console
to run your Lisp program.

### Running on Physical Hardware
You can also run SectorLISP on an actual physical machine if you have a PC with an Intel CPU that boots with a BIOS,
and a drive such as a USB drive or a floppy disk that can be used as a boot drive.
First, mount your drive to the PC you've built sectorlisp.bin on, and check:

```sh
lsblk -o KNAME,TYPE,SIZE,MODEL
```

Among the list of the hardware, check for the device name for your drive you want to write SectorLISP onto.
After making sure of the device name, run the following command, replacing `[devicename]` with your device name.
`[devicename]` should be values such as `sda` or `sdb`, depending on your setup.

**Caution:** The following command used for writing to the drive
will overwrite anything that exists in the target drive's boot sector,
so it's important to make sure which drive you're writing into.
If the command or the device name is wrong,
it may overwrite the entire content of your drive or other drives mounted in your PC,
probably causing your computer to be unbootable
(or change your PC to a SectorLISP machine that always boots SectorLISP,
which is cool, but is hard to recover from).
Please perform these steps with extra care, and at your own risk.

```sh
sudo dd if=sectorlisp.bin of=/dev/[devicename] bs=512 count=1
```

After you have written your boot drive, insert the drive to the PC you want to boot it from.
You may have to change the boot priority settings from the BIOS to make sure the PC boots from the target drive.
When the drive boots successfully, you should see a cursor blinking in a blank screen,
which indicates that you're ready to type your Lisp code into bare metal.

## Impementation Details
The implementation details for this project are available at []().
