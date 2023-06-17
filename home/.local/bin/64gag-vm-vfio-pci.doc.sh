#!/usr/bin/env bash
# === FOREWORD ===
# VMs with real hardware (passthrough) are "one of those things" that are very hardware and software dependent.
# Furthermore, the outcome each person wants to achieve differs aswell. The references and sources I list here
# is because I considered them worthy or useful, but none of them contains what I needed to do.
#
# This means tutorials will most likely be innacurate and/or outdated. Those of us that usually get away with
# copy pasting commands and not understanding much of what is behind will surely have less luck than usual.
# Poor or incomplete.
#
# I am not an expert (I started to use KVM in the lates 2022)
# My experience with "KVM + real HW" comes from two objectives:
# - Passing the GPU to a VM for performance
# - Passing disks (HBA controller or not) to a VM
# I have ran VMs on Proxmox, TrueNAS and workstations (Fedora, Ubuntu, Debian)
#
# === MY SCENARIO ===
# I want to be able to hand off my GPU to the VM completely.
# Ideally take control back on the host after the VM is shutdown.
# I have a single GPU
# This whole process is very dependent on setup and goals. The above references 
#
# === HARDWARE/SOFTWARE configuration ===
# - Motherboard ASROCK X570 PRO4
# - CPU: AMD Ryzen 9 5900X 4,80GHz 12 cores
# - OS: Fedora Workstation 38
# - Linux kernel: Linux fedora 6.2.11-300.fc38.x86_64 #1 SMP PREEMPT_DYNAMIC Thu Apr 13 20:27:09 UTC 2023 x86_64 GNU/Linux
#
# === REFERENCES ===
# [1] https://libvirt.org/hooks.html
# [2] https://wiki.archlinux.org/title/PCI_passthrough_via_OVMF
# [3] https://www.kernel.org/doc/html/latest/admin-guide/kernel-parameters.html
#
# === OTHER SOURCES ===
# [4] https://www.youtube.com/@BlandManStudios
# [5] https://passthroughpo.st/simple-per-vm-libvirt-hooks-with-the-vfio-tools-hook-helper/
# [6] https://github.com/joeknock90/Single-GPU-Passthrough
# [7] https://www.reddit.com/r/VFIO/
#
# === INSTRUCTIONS ===
# STEP 0: Chipset
# XXXX TODO
#
# STEP 1: Enable IOMMU
# - [1] states option Intel CPU's require `intel_iommu=on` but it is auto detected for AMD
# - I did not add anything to the kernel parameters (TODO verify/correct)
#
# STEP 2: Loading vfio-pci early
# #/etc/dracut.conf.d/10-vfio.conf
# force_drivers+=" vfio_pci vfio vfio_iommu_type1 "
#
# # Note, [1] states `vfio_virqfd` not needed anymore since Kernel 6.2
#
# $ sudo dracut -f --kver `uname -r`
#
set -x

# From [1]:
# TODO Install as /etc/libvirt/hooks/qemu
# The first argument is the name of the object involved in the operation, or '-' if there is none. For example, the name of a guest being started.
# The second argument is the name of the operation being performed. For example, "start" if a guest is being started.
# The third argument is a sub-operation indication, or '-' if there is none.
# The last argument is an extra argument string, or '-' if there is none.
lvirt_name=$1
lvirt_operation=$2
lvirt_suboperation=$3
lvirt_extra_arg=$4

sys_vtconsole="/sys/class/vtconsole/vtcon0"
driver_efi_framebuffer="/sys/bus/platform/drivers/efi-framebuffer"

if [[ "$lvirt_name" == *gpupt* ]]; then
    if [ "${lvirt_operation}" == "prepare" ] && [ "${lvirt_suboperation}" == "begin" ]; then
        systemctl stop display-manager.service
        #killall gdm-x-session
        echo "0" > "${sys_vtconsole}/bind"
        echo "efi-framebuffer.0" > "${driver_efi_framebuffer}/unbind"
        sleep 2
        #virsh nodedev-detach pci_0000_09_00_0
        #virsh nodedev-detach pci_0000_0a_00_0
        virsh nodedev-detach pci_0000_0b_00_0
        virsh nodedev-detach pci_0000_0b_00_1
        modprobe -r amdgpu
        modprobe vfio-pci
    fi

    if [ "${lvirt_operation}" == "release" ] && [ "${lvirt_suboperation}" == "end" ]; then
        #modprobe -r vfio-pci
        modprobe amdgpu
        # NOTE original script made it in the reverse order
        #virsh nodedev-reattach pci_0000_09_00_0
        #virsh nodedev-reattach pci_0000_0a_00_0
        virsh nodedev-reattach pci_0000_0b_00_0
        virsh nodedev-reattach pci_0000_0b_00_1
        echo "1" > "${sys_vtconsole}/bind"
        echo "efi-framebuffer.0" > "${driver_efi_framebuffer}/bind"
        systemctl start display-manager.service
    fi
fi

# === EXTRA NOTES ===
#
# $ lspci -nnk
#
# (Relevant output)
# ...
# 09:00.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD/ATI] Navi 10 XL Upstream Port of PCI Express Switch [1002:1478] (rev c1)
#         Kernel driver in use: pcieport
# 0a:00.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD/ATI] Navi 10 XL Downstream Port of PCI Express Switch [1002:1479]
#         Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] Navi 10 XL Downstream Port of PCI Express Switch [1002:1479]
#         Kernel driver in use: pcieport
# 0b:00.0 VGA compatible controller [0300]: Advanced Micro Devices, Inc. [AMD/ATI] Navi 23 [Radeon RX 6650 XT / 6700S / 6800S] [1002:73ef] (rev c1)
#         Subsystem: Micro-Star International Co., Ltd. [MSI] Device [1462:5027]
#         Kernel driver in use: amdgpu
#         Kernel modules: amdgpu
# 0b:00.1 Audio device [0403]: Advanced Micro Devices, Inc. [AMD/ATI] Navi 21/23 HDMI/DP Audio Controller [1002:ab28]
#         Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] Navi 21/23 HDMI/DP Audio Controller [1002:ab28]
#         Kernel driver in use: snd_hda_intel
#         Kernel modules: snd_hda_intel
# 0c:00.0 Non-Essential Instrumentation [1300]: Advanced Micro Devices, Inc. [AMD] Starship/Matisse PCIe Dummy Function [1022:148a]
#         Subsystem: Advanced Micro Devices, Inc. [AMD] Starship/Matisse PCIe Dummy Function [1022:148a]
# 0d:00.0 Non-Essential Instrumentation [1300]: Advanced Micro Devices, Inc. [AMD] Starship/Matisse Reserved SPP [1022:1485]
#         Subsystem: Advanced Micro Devices, Inc. [AMD] Starship/Matisse Reserved SPP [1022:1485]
# 0d:00.1 Encryption controller [1080]: Advanced Micro Devices, Inc. [AMD] Starship/Matisse Cryptographic Coprocessor PSPCPP [1022:1486]
#         Subsystem: Advanced Micro Devices, Inc. [AMD] Starship/Matisse Cryptographic Coprocessor PSPCPP [1022:1486]
#         Kernel driver in use: ccp
#         Kernel modules: ccp
# ...
#
# 29ea:0102 at 3-9
# 046d:c52b at 3-10
#
# #removed --os-type=Linux --os-variant=rhel6 
# virt-install --name fedora-gpupt --description "Test Fedora GPUPT" --ram=2048 --vcpus=2 --disk size=20 --graphics none --cdrom /mnt/vms/iso/Fedora-KDE-Live-x86_64-38-1.6.iso --network bridge:br0 --hostdev pci_0000_0b_00_0 --hostdev pci_0000_0b_00_1
