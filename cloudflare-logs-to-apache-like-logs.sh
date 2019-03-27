#! /bin/sh
###############################################################################
# The script just takes in the Cloudflare JSON formatted logs and outputs Apache-like formatted logs
#
# MNSmitasin@lbl.gov 2018-06-15
#
###############################################################################

TARGETFILE=$1

USAGE(){
  echo "Usage:"
  echo "    $0 <TARGET_FILE>"
  echo "    zcat <TARGET_FILE> | $0"
}

INGEST_STDIN(){
  grep "^{" | jq -c -r '[.EdgeStartTimestamp/1000000000,.ClientIP,.ClientSrcPort,.OriginIP,.ClientRequestMethod,.ClientRequestHost,.ClientRequestURI,.OriginResponseStatus,.ClientRequestProtocol,.ClientRequestBytes,.ClientRequestReferer]' | tr -d "]" | tr -d "[" | tr -d "\""
}

INGEST_FILE(){
  zcat -f $TARGETFILE | grep "^{" | jq -c -r '[.EdgeStartTimestamp/1000000000,.ClientIP,.ClientSrcPort,.OriginIP,.ClientRequestMethod,.ClientRequestHost,.ClientRequestURI,.OriginResponseStatus,.ClientRequestProtocol,.ClientRequestBytes,.ClientRequestReferer]' | tr -d "]" | tr -d "[" | tr -d "\""
  echo ""
}

if [ -z $1 ]
then
  INGEST_STDIN | sort -nk1
elif [ $1 == "-?" ]
then
  USAGE
else
  INGEST_FILE | sort -nk1
fi
