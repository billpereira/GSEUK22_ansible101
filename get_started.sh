zxplore_user=$1

echo -n Password: 
read -s password

python --version

pip --version

sudo apt-get install ansible -y
sudo apt-get install sshpass -y

ansible --version


echo 'all:' >> inventory.yaml
echo '  hosts:' >> inventory.yaml
echo '    zxplore:' >> inventory.yaml
echo '      ansible_user: '$zxplore_user >> inventory.yaml
echo '      ansible_password: '$password >> inventory.yaml
echo '      # ansible_port: 10443 '>> inventory.yaml
echo '      ansible_host: 204.90.115.200' >> inventory.yaml
echo '      #  vars:' >> inventory.yaml
echo '      PYZ: "/usr/lpp/IBM/cyp/v3r9/pyz"' >> inventory.yaml
echo '      ZOAU: "/usr/lpp/IBM/zoautil"' >> inventory.yaml
echo '      ansible_python_interpreter: /usr/lpp/IBM/cyp/v3r9/pyz/bin/python3' >> inventory.yaml
echo '      environment_vars:' >> inventory.yaml
echo '        _BPXK_AUTOCVT: "ON"' >> inventory.yaml
echo '        ZOAU_HOME: "{{ ZOAU }}"' >> inventory.yaml
echo '        PYTHONPATH: "{{ ZOAU }}/lib"' >> inventory.yaml
echo '        LIBPATH: "{{ ZOAU }}/lib:{{ PYZ }}/lib:/lib:/usr/lib:"' >> inventory.yaml
echo '        PATH: "{{ ZOAU }}/bin:{{ PYZ }}/bin:/bin:/var/bin"' >> inventory.yaml
echo '        _CEE_RUNOPTS: "FILETAG(AUTOCVT,AUTOTAG) POSIX(ON)"' >> inventory.yaml
echo '        _TAG_REDIR_ERR: "txt"' >> inventory.yaml
echo '        _TAG_REDIR_IN: "txt"' >> inventory.yaml
echo '        _TAG_REDIR_OUT: "txt"' >> inventory.yaml
echo '        _CC_LIB_PREFIX: "SYS1"' >> inventory.yaml
echo '        LANG: "C"' >> inventory.yaml

exit