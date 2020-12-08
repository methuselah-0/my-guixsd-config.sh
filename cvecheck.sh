#!/run/current-system/profile/bin/bash
#set -x
# array[key]="$(declare -p another_aray)"
function f(){
    shopt -s extglob
    [[ -e /tmp/cve.txt ]] || guix lint -c cve >/tmp/cve.txt 2>/tmp/cve_err.txt

    declare -A Vulns
    while read -ra pkgline
    do
	if grep " ${pkgline[0]}" /tmp/cve.txt >/dev/null 2>/dev/null
	then
	    unset cves
	    declare -a cves=()
	    unset cvelinks
	    declare -a cvelinks=()
	    while read -r line
	    do		  
		cves+=("${line}")
		while read -r cve
		do
		    # https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-YYYY-ABCD
		    # https://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-YYYY-ABCD
		    local link="https://web.nvd.nist.gov/view/vuln/detail?vulnId=${cve}"
		    if ! [[ "${cvelinks[@]}" =~ "$link" ]] ; then cvelinks+=("$link") ; fi
		done < <( grep -o -E 'CVE-[0-9]{4}-[0-9]+' <<< "${line}")
	    done < <(grep " ${pkgline[0]}" /tmp/cve.txt 2>/dev/null )
	    version=("${pkgline[1]}")
	    Vulns["${pkgline[0]//-/_}"]=$(declare -p cves && declare -p version && declare -p cvelinks)
	fi
    done < <(guix package -I)
    for key in "${!Vulns[@]}"
    do	
	eval "${Vulns[$key]}"
	printf '%s' "Package: ${key}@${version[@]}" $'\n'
	for cvelink in "${cvelinks[@]}"
	do
	    printf '%s' "Links: ${cvelink}" $'\n'
	done
	
     	for val in "${cves[@]}"
     	do	   
     	    printf '%s' "Vulnerability: " "${val}" $'\n'
     	done
     	echo ""
    done    
}
f
