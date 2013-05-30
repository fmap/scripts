awk '{ OFS="\t"; print NR, $0 }' "$@"
