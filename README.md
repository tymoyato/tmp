wget https://github.com/tymoyato/tmp/archive/refs/heads/main.zip

unzip main.zip

mv tmp-main tmp

cd tmp

chmod +x ./linux_setup.sh

chmod +x ./fish.sh

bash -i linux_setup.sh

run fish.sh in fish shell
