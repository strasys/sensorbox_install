
Achtung: folgender Ablauf ist notwendig, da ansonsten die Compilierung nicht funktioniert

Preprocessing:
cpp -nostdinc -I /opt/source/dtb-6.12.x/include/ \
  -undef -x assembler-with-cpp BB-UART1-GPIO-I2C-00A0.dts BB-UART1-GPIO-I2C-00A0.pp


Dann pp in dtbo:
sudo dtc -@ -I dts -O dtb \
  -o BB-UART1-GPIO-I2C-00A0.dtbo BB-UART1-GPIO-I2C-00A0.pp

  Excellent follow-up 👌 — and yes, you’re absolutely right to ask.

Here’s the clear answer:

---

### ✅ You **must copy/install** the `.dtbo` file as **root**

…but you **do not need to *create* or *compile*** it as root.

---

### 🔧 Here’s the correct workflow:

#### 1️⃣ Compile as regular user (`debian`)

You can safely build your overlay in your home directory:

```bash
dtc -@ -I dts -O dtb -o BB-UART1-GPIO-I2C-00A0.dtbo BB-UART1-GPIO-I2C-00A0.dts
```

> (You only need `sudo` here if your include paths are in a protected location,
> but normally you can build as `debian`.)

---

#### 2️⃣ Copy the finished `.dtbo` into `/lib/firmware` as root

That’s the **only step requiring `sudo`**, because `/lib/firmware` belongs to `root`:

```bash
sudo cp BB-UART1-GPIO-I2C-00A0.dtbo /lib/firmware/
```

Then check:

```bash
ls -l /lib/firmware/BB-UART1-GPIO-I2C-00A0.dtbo
```

You should see:

```
-rw-r--r-- 1 root root  1234 Oct 26 20:31 /lib/firmware/BB-UART1-GPIO-I2C-00A0.dtbo
```

---

#### 3️⃣ Make sure `/boot/uEnv.txt` (edited as root) points to it:

```ini
enable_uboot_overlays=1
uboot_overlay_addr4=/lib/firmware/BB-UART1-GPIO-I2C-00A0.dtbo
```

---

#### 4️⃣ Reboot to load it:

```bash
sudo reboot
```

---

✅ **Summary:**

| Task                            | Needs root? | Command                       |
| ------------------------------- | ----------- | ----------------------------- |
| Compile `.dts → .dtbo`          | ❌ No        | `dtc -@ -I dts -O dtb -o ...` |
| Copy `.dtbo` to `/lib/firmware` | ✅ Yes       | `sudo cp ... /lib/firmware/`  |
| Edit `/boot/uEnv.txt`           | ✅ Yes       | `sudo nano /boot/uEnv.txt`    |
| Reboot to apply overlay         | ✅ Yes       | `sudo reboot`                 |

---

Would you like me to show a verified working `BB-UART1-GPIO-I2C-00A0.dts` that fits your 6.12.x kernel (to make sure the next compile succeeds cleanly)?


