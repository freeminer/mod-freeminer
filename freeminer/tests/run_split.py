#!/usr/bin/env python3
"""Start isolated games with the split features enabled and disabled."""
from pathlib import Path
import shutil
import socket
import subprocess
import sys
import tempfile

binary = Path(sys.argv[1]).resolve() if len(sys.argv) > 1 else Path.cwd() / "build_-20/freeminer"
engine = binary.parent.parent
pack_root = Path(__file__).resolve().parents[2]
probe = Path(__file__).with_name("probe")
features = ["freeminer_nodes", "freeminer_mapgen", "freeminer_trees", "freeminer_aquatic", "freeminer_arnis"]

with tempfile.TemporaryDirectory(prefix="freeminer-split-") as tmp:
    base = Path(tmp)
    runtime = base / "runtime"
    (runtime / "bin").mkdir(parents=True)
    (runtime / "games").mkdir()
    shutil.copy2(binary, runtime / "bin/freeminer")
    for name in ("builtin", "textures"):
        (runtime / name).symlink_to(engine / name, target_is_directory=True)
    for name in ("minetest_game", "VoxeLibre"):
        (runtime / "games" / name).symlink_to(engine / "games" / name, target_is_directory=True)
    default_src = engine / "games/default"
    default_dst = runtime / "games/default_game"
    (default_dst / "mods").mkdir(parents=True)
    for item in default_src.iterdir():
        if item.name not in ("mods", ".git", ".gitmodules"):
            (default_dst / item.name).symlink_to(item.resolve(), target_is_directory=item.is_dir())
    for item in (default_src / "mods").iterdir():
        if item.name != "freeminer":
            (default_dst / "mods" / item.name).symlink_to(item.resolve(), target_is_directory=item.is_dir())

    def make_pack(name, members):
        path = base / name
        path.mkdir()
        (path / "modpack.txt").touch()
        for member in members:
            (path / member).symlink_to(pack_root / member, target_is_directory=True)
        return path

    all_members = [item.name for item in pack_root.iterdir() if item.is_dir() and item.name != ".git"]
    packs = {
        "full": make_pack("full", all_members),
        "standalone": make_pack("standalone", features),
        "disabled": make_pack("disabled", ["freeminer"]),
        "nodes_only": make_pack("nodes_only", ["freeminer", "freeminer_nodes"]),
        "mapgen_only": make_pack("mapgen_only", ["freeminer", "freeminer_mapgen"]),
        "feature_nodes": make_pack("feature_nodes", ["freeminer_nodes"]),
        "feature_trees": make_pack("feature_trees", ["freeminer_trees"]),
        "feature_arnis": make_pack("feature_arnis", ["freeminer_arnis"]),
    }
    cases = [("default", mode) for mode in ("full", "disabled", "nodes_only", "mapgen_only")]
    cases += [(game, mode) for game in ("minetest", "VoxeLibre") for mode in ("full", "standalone", "disabled")]
    cases += [(game, mode) for game in ("minetest", "VoxeLibre") for mode in ("feature_nodes", "feature_trees", "feature_arnis")]
    link = default_dst / "mods/freeminer"
    for game, mode in cases:
        world = base / (game.lower() + "-" + mode)
        worldmods = world / "worldmods"
        worldmods.mkdir(parents=True)
        (worldmods / "fm_split_probe").symlink_to(probe, target_is_directory=True)
        if game == "default":
            link.unlink(missing_ok=True)
            link.symlink_to(packs[mode], target_is_directory=True)
        else:
            (worldmods / "fm_split").symlink_to(packs[mode], target_is_directory=True)
        (world / "world.mt").write_text(
            f"gameid = {game}\nbackend = sqlite3\nplayer_backend = sqlite3\n"
            "auth_backend = sqlite3\nmod_storage_backend = sqlite3\nload_mod_fm_split_probe = true\n")
        with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as sock:
            sock.bind(("127.0.0.1", 0))
            port = sock.getsockname()[1]
        config = base / (game.lower() + "-" + mode + ".conf")
        config.write_text(f"server_announce = false\nport = {port}\nmg_name = v7\nfm_split_probe_mode = {mode}\n")
        result = subprocess.run(
            [str(runtime / "bin/freeminer"), "--server", "--world", str(world),
             "--config", str(config), "--logfile", str(world / "debug.log")],
            stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, timeout=90)
        marker = f"[fm_split_probe] {game} {mode} passed"
        if result.returncode or marker not in result.stdout:
            print(result.stdout)
            raise SystemExit(f"FAILED: {game} {mode} (exit {result.returncode})")
        print("PASS:", game, mode, flush=True)
