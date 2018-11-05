#!/run/current-system/profile/bin/bash
#set -x
# array[key]="$(declare -p another_aray)"
function guix_health()
{
    shopt -s extglob
    [[ -e /tmp/cve.txt ]] || guix lint -c cve 2>/tmp/cve.txt

    declare -A Vulns
    while read -ra pkgline
    do
	if grep " ${pkgline[0]}" /tmp/cve.txt >/dev/null 2>/dev/null
	then
	    version=("${pkgline[1]}")	    
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
		    cvelinks+=("https://web.nvd.nist.gov/view/vuln/detail?vulnId=${cve}")
		done < <( grep -o -E 'CVE-[0-9]{4}-[0-9]+' <<< "${line}")
	    done < <(grep " ${pkgline[0]}" /tmp/cve.txt 2>/dev/null )
	    Vulns["${pkgline[0]//-/_}"]=$( declare -p cves && declare -p version && declare -p cvelinks )
	fi
    done < <(guix package -I)
    #declare -p
    for key in "${!Vulns[@]}"
    do	
	eval "${Vulns[$key]}"
	printf '%s' "* Package: ${key}@${version[@]}" $'\n'
	printf '%s' "** Links" $'\n'
	for cvelink in "${cvelinks[@]}"
	do
	    printf '%s' "${cvelink}" $'\n'
	done

	printf '%s' "** Vulnerabilities: " $'\n'
     	for val in "${cves[@]}"
     	do	   
	    printf '%s' "${val}" $'\n'
     	done
     	echo ""
    done    
}
[[ "${1}" = "-h" ]] || [[ "${1}" = "--help" ]] && \
    printf '%s\n' "Run with:" "    ./cvecheck.sh" "to print package health status to stdout. or:" "    ./cvecheck.sh > health.org" "and you can open output as org-mode file." \
	|| guix_health
