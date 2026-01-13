#!/usr/bin/env bash
set -euo pipefail

echo "==> Adding Hive3 to Hue 4.11 (core-based)"

########################################
# Sanity check
########################################
if [ ! -d apps/hive ] || [ ! -d apps/beeswax ]; then
  echo "ERROR: Run this from Hue repo root (apps/hive not found)"
  exit 1
fi

########################################
# 1. Backend: beeswax → beeswax3
########################################
if [ ! -d apps/beeswax3 ]; then
  cp -r apps/beeswax apps/beeswax3
fi

# Rename package in setup.py
sed -i "s/name='beeswax'/name='beeswax3'/" apps/beeswax3/setup.py

# Use separate config section
sed -i 's/section="beeswax"/section="beeswax3"/g' \
  apps/beeswax3/src/beeswax/conf.py

########################################
# 2. Frontend: hive → hive3
########################################
if [ ! -d apps/hive3 ]; then
  cp -r apps/hive apps/hive3
fi

# Rename python package
if [ -d apps/hive3/src/hive ] && [ ! -d apps/hive3/src/hive3 ]; then
  mv apps/hive3/src/hive apps/hive3/src/hive3
fi

# Rename app in setup.py
sed -i "s/name='hive'/name='hive3'/" apps/hive3/setup.py

########################################
# 3. Fix imports: hive → hive3
########################################
FILES=$(grep -Rl "from hive" apps/hive3/src || true)
[ -n "$FILES" ] && sed -i 's/from hive/from hive3/g' $FILES

FILES=$(grep -Rl "import hive" apps/hive3/src || true)
[ -n "$FILES" ] && sed -i 's/import hive/import hive3/g' $FILES

########################################
# 4. Point Hive3 UI → beeswax3 backend
########################################
FILES=$(grep -Rl "/beeswax/" apps/hive3/src || true)
[ -n "$FILES" ] && sed -i 's#/beeswax/#/beeswax3/#g' $FILES

########################################
# 5. Register apps (THIS is what makes them appear)
########################################
SETTINGS=desktop/core/src/desktop/settings.py

grep -q "'beeswax3'" "$SETTINGS" || \
  sed -i "/INSTALLED_APPS *= *\[/a\    'beeswax3'," "$SETTINGS"

grep -q "'hive3'" "$SETTINGS" || \
  sed -i "/INSTALLED_APPS *= *\[/a\    'hive3'," "$SETTINGS"

########################################
# Done
########################################
echo "==> Hive3 added successfully"
echo
echo "Next steps:"
echo "  1) Add [beeswax3] section in hue.ini"
echo "  2) Run: make apps && make build"
echo "  3) Restart Hue"

