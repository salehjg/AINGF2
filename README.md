# AINGF2
FPGA Based Digital Still Camera Over USB-2.0

# Hardware
FPGA: Xilinx Spartan-3
Memory: Cypress SRAM * 2 (seperate busses)
USB: Cypress USBFX2LP

# Architecture
Ping-Pong frame aquisition by utilizing both SRAMs and their respective(and seperate) SRAM Controllers and a 8051 soft-core for reset signal management and I3C custom interface handling.
also a simple hex2coef converter utility to convert built firmware(hex-file) into xilinx-coef format for integrating into ROM IP CORE (on platform-flash)

# PCB
Designed using Altium-Designer as double-sided PCB.
there are some known issues related to ground bouncing and signal integrity at challenging clock frequencies(PCLK, main clock), which are avoidable by a proper 4-Layer PCB stackup.

# Software
Simple program written in C#.Net to receive data sent over USB-2 and configure internal registers of image sensor, based on official SDK for USBFX2LP and official Cypress driver for Microsoft-Windows.
