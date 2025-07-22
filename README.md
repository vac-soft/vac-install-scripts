# vac-install-scripts
VAC Products Installation Scripts

# PBX

1. First execute: 
<pre lang='bash'><code>
bash <(curl -s https://raw.githubusercontent.com/vac-soft/vac-install-scripts/master/PBX/vacpbx5-script1.sh)
</code></pre>
2. It will reboot. 
3. Login Again.
4. Execute:
<pre lang='bash'><code>
bash <(curl -s https://raw.githubusercontent.com/vac-soft/vac-install-scripts/master/PBX/vacpbx5-install2.sh)
</code></pre>
5. Params Update:
<pre lang='bash'><code>
Asterisk Version : 16
Wanpipe Drivers : yes
Beta - No
MySQL Password : Check with VAC Team personally
Admin Password : Check with VAC Team Personally
</code></pre>
It will reboot and PBX is installed.