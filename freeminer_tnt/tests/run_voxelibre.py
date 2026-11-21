#!/usr/bin/env python3
"""Exercise both TNT implementations in an isolated VoxeLibre world."""
import os
import socket
from pathlib import Path
import subprocess
import sys
import tempfile

root = Path(__file__).resolve().parents[3]
binary = Path(sys.argv[1]).resolve() if len(sys.argv) > 1 else root / "build_-20/freeminer"
probe = Path(__file__).with_name("voxelibre_probe")
with tempfile.TemporaryDirectory(prefix="fm-tnt-voxelibre-") as directory:
    base = Path(directory)
    world = base / "world"
    mods = world / "worldmods"
    mods.mkdir(parents=True)
    (mods / "tnt").symlink_to(root / "mods/freeminer_tnt", target_is_directory=True)
    (mods / "fm_tnt_probe").symlink_to(probe, target_is_directory=True)
    (world / "world.mt").write_text(
        "gameid = VoxeLibre\nbackend = sqlite3\nplayer_backend = sqlite3\n"
        "auth_backend = sqlite3\nmod_storage_backend = sqlite3\n"
        "load_mod_tnt = true\nload_mod_fm_tnt_probe = true\n"
        "load_mod_freeminer = false\nload_mod_sponge = false\n"
        "load_mod_portals = false\nload_mod_moonflower = false\n"
        "load_mod_weather = false\nload_mod_spring = false\n")
    config = base / "test.conf"
    with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as sock:
        sock.bind(("127.0.0.1", 0))
        port = sock.getsockname()[1]
    config.write_text(f"server_announce = false\nport = {port}\nmg_name = v7\n"
                      "enable_tnt = true\ntnt_async_budget_ms = 100\n")
    result = subprocess.run(
        [str(binary), "--server", "--world", str(world), "--config", str(config),
         "--logfile", str(base / "engine.log")],
        env={**os.environ, "LUANTI_GAME_PATH": str(root / "games")},
        stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, timeout=120)
    print(result.stdout)
    if result.returncode or "[fm_tnt_probe] VoxeLibre ignition, explosion and both mixed-chain directions passed" not in result.stdout:
        raise SystemExit(result.returncode or 1)
