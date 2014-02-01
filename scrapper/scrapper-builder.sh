#!/usr/bin/env bash
# Description:	some cool description here

companyList=$(psql -qAtX -U postgres -c "select distinct(company) from servers" test |xargs echo)

for company in $companyList; do
  # build company header
  echo "<table border="1">"
  echo "<caption> $company </caption>"
  
  # build server title
  echo "<tr><th>Hostname</th><th>CPU</th><th>Memory</th><th>Storage</th><th>Disks</th><th>Network</th><th>Operating system</th><th>Kernel</th><th>PostgreSQL version</th><th>PgBouncer version</th><th>Databases</th></tr>"

  # build server rows
  serverList=$(psql -qAtX -U postgres -c "select c.company,c.hostname,h.cpu,h.memory,h.storage,h.disks,h.network,s.os,s.kernel,s.pg_version,s.pgb_version,s.databases from servers c join hardware h on c.hostname = h.hostname join software s on c.hostname = s.hostname where company = '$company'" test)
  echo $serverList |while read server; do
    SAVEIFS=$IFS ; IFS='|'
    echo "$server" |while read company hostname cpu memory storage disks network os kernel pgversion pgbversion databases; do
     echo "<tr><td>$hostname</td><td>$cpu</td><td>$memory</td><td>$storage</td><td>$disks</td><td>$network</td><td>$os</td><td>$kernel</td><td>$pgversion</td><td>$pgbversion</td><td>$databases</td></tr>"
    done
  done
  IFS=$SAVEIFS
done
  # close table
  echo "</table>"
