# Helper utilities for working with system files

field() {
  JSON="$1"
	ENTRY="$2"
	FIELD="$3"
  QUERY="\[$ENTRY,\"$FIELD\".*\]"
  
  if [[ "$ENTRY" == '*' ]]; then
    QUERY="\[.*\"$FIELD\".*]"
  fi

	echo "$JSON" | grep -i "$QUERY" | cut -f 2 | sed -e 's/^"\(.*\)"$/\1/'
}

fields() {
  echo "$1" | cut -f 1 | tr -d ',[]"0-9' | sort | uniq -c
}

last() {
  JSON="$1"
	l=`echo "$JSON" | cut -d',' -f1 | cut -c2- | sort -rn | head -1`
	echo ${l:--1}
}

array() {
  RESULT=`echo "$1" | json -b`
  (( $? )) || ( echo "$RESULT" | cut -f2 | tr -d '"' )
}

public_root() {
  find "$1" -type f -perm -004
}

private_root() {
  find "$1" -type f \! -perm -004
}

public() {
  find "$1" \! -path "$1/boot/*" \! -path "$1/usr/src/kernel/*" -type f -perm -004
}

private() {
  find "$1" \! -path "$1/boot/*" \! -path "$1/usr/src/kernel/*" -type f \! -perm -004
}

bool() {
	[ -n "$1" ] && [ "$1" != "false" ] && echo "true"
}

noblank() {
  echo -e "$1" | sed -e :a -e '/./,$!d;/^\n*$/{$d;N;};/\n$/ba'
}

nocomma() {
  echo -e "$1" | sed -e '$s/ *, *$//'
}

nullstring() {
  if echo -e "$1" | grep -q '^null$'; then
    echo 'null';
  else
    echo "\"$1\"";
  fi
}

members() {
  cat /etc/passwd | grep "^[^:]*:[^:]*:[^:]*:[^:]*:[^:]*:$1" | cut -d: -f1
}
