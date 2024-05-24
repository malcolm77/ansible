echo "############################# CLEAN LOG FILES ###############################"
find ./logs -type f -name "*" -print -exec sed -i 's/PBI..-...-PN./SERVER/g' {} \; -exec sed -i 's/PI..-...-PN./SERVER/g' {} \;  -exec sed -i 's/\([0-9]\{1,3\}\.\)\{3\}[0-9]\{1,3\}/xxx.xxx.xxx.xxx/g' {} \; -exec sed -i 's/CICZ.GOV.AU/domain.au/g' {} \; -exec sed -i 's/NAFIS/domain/g' {} \; -exec sed -i 's/pidm......\..../username/g' {} \;

