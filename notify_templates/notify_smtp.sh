### DISCLAIMER: This is a third party addition to dockcheck - best effort testing.
# INFO: ssmtp is depcerated - consider to use msmtp instead.
#
# Copy/rename this file to notify.sh to enable the notification snipppet.
# mSMTP/sSMTP has to be installed and configured manually.
# Modify to fit your setup - changing SendMailFrom, SendMailTo, SubjectTag

MSMTP=$(which msmtp)
SSMTP=$(which ssmtp)

if [ -n "$MSMTP" ] ; then
	MailPkg=$MSMTP
elif [ -n "$SSMTP" ] ; then
	MailPkg=$SSMTP
else
	echo "No msmtp or ssmtp binary found in PATH: $PATH" ; exit 1
fi

send_notification() {
[ -s "$ScriptWorkDir"/urls.list ] && releasenotes || Updates=("$@")
UpdToString=$( printf '%s\\n' "${Updates[@]}" )
FromHost=$(hostname)

# User variables:
SendMailFrom="me@mydomain.tld"
SendMailTo="me@mydomain.tld"
SubjectTag="dockcheck"

printf "\nSending email notification.\n"

printf -v MessageBody "🐋 Containers on $FromHost with updates available:\n\n$UpdToString"

$MailPkg $SendMailTo << __EOF
From: "$FromHost" <$SendMailFrom>
date:$(date -R)
To: <$SendMailTo>
Subject: [$SubjectTag] Updates available on $FromHost
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

$MessageBody

__EOF
}
