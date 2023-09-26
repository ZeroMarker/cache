Class web.DHCTestTT Extends (%Persistent, %XML.Adaptor) [ Inheritance = right ]
{

ClassMethod GetPatInfo(startdate, enddate)
{
    s startdate=$zdh(startdate,3) 
    s enddate=$zdh(enddate,3)
    f prtdate=startdate:1:enddate  d
    .s rowid=""
    .f  s rowid=$o(^PAADM("PAADM_AdmDate",prtdate,rowid)) q:rowid=""  d
    ..s papmirowid=$p(^PAADM(rowid),"^",1)
    ..s paadmadmdate=$p(^PAADM(rowid),"^",6)
    ..s PrtType=$p(^PAADM(rowid),"^",2)
    ..q:PerType'="I"
    ..q:papmirowid=""
    ..i $d(^PAPER(papmirowid,"ALL")) s papminame=$p(^PAPER(papmirowid,"ALL"),"^",1)
    ..i $d(^PAPER(papmirowid,"PAT",1)) s papmiipno=$p(^PAPER(papmirowid,"PAT",1),"^",1)
    ..w !,paadmadmdate_"^"_papminame_"^"_papmiipno
    q
}

ClassMethod GetSum()
{
}

Storage Default
{
<Data name="DHCTestTTDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCTestTTD</DataLocation>
<DefaultData>DHCTestTTDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCTestTTD</IdLocation>
<IndexLocation>^web.DHCTestTTI</IndexLocation>
<StreamLocation>^web.DHCTestTTS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
