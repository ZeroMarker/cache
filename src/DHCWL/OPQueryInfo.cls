Class DHCWL.OPQueryInfo Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      ycm
/// CreatDate：    2015-05-04
/// Description:   查询日期里面的手术明细
/// Table：        SDate,EDate ,locId 
/// Input：        
/// Output：       
/// Return：
/// Others：d ##class(%ResultSet).RunQuery("DHCWL.OPQueryInfo","GetOperationInfo","2015-08-01","2015-08-24","")
Query GetOperationInfo(SDate As %String, EDate As %String, LocId As %String = "") As %Query(ROWSPEC = "Admid:%String,PatName:%String,PatNo:%String,PatId:%String,PatAge:%String,PatSex:%String,PatLocDr:%String,PatLocDesc:%String,PatWardr:%String,PatWardDesc:%String,OperName:%String,operdocName:%String,AssistDocName:%String,OperDate:%String,CirNurseName:%String,ScrNurseName:%String,AnDocName:%String,OperCutDesc:%String,MethodDesc:%String,OpLevelDesc:%String") [ SqlProc ]
{
}

ClassMethod GetOperationInfoExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String, LocId As %String = "") As %Status
{
	n (qHandle,SDate,EDate,LocId)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	k ^||TEMPDHCWL($j)

 	q:(SDate="")||(EDate="") $$$OK

 	s SDate=$ZDH(SDate,3)
 	s EDate=$ZDH(EDate,3)
 	
 	i LocId'="" d
 	.s len=$L(LocId,",")
 	.f i=1:1:len d
 	..s PatLoc=$P(LocId,",",i)
 	..q:+PatLoc=0
 	..s ^||TEMPDHCWL($j,"PatLoc",PatLoc)=""
 	
 	f day=SDate:1:EDate d 
	.s wlanrowid=0 
	.f  s wlanrowid=$o(^DHCWLAnaesthesia(0,"STATDATE",day,wlanrowid)) q:wlanrowid=""  d
    ..s Admid=$p(^DHCWLAnaesthesia(wlanrowid),"^",1)
    ..s Papmidr=$P(^PAADM(Admid),"^",1)
    ..s PatName=$$GetPapmiName^DHCWLCommon(Papmidr)
    ..s PatNo=$$GetPapmiNo^DHCWLCommon(Papmidr)
    ..s PatId=$$GetPapmiMedtare^DHCWLCommon(Papmidr)
    ..s PatAge=$$GetAge^DHCWLCommon(Papmidr)
    ..s PatAge=##class(web.DHCBillInterface).GetPapmiAge(Papmidr,Admid)
    ..s PatSex=$$GetSex^DHCWLCommon(Papmidr)
    ..s optype=$p(^DHCWLAnaesthesia(wlanrowid),"^",4)
    ..s opLevelCode=$p(^DHCWLAnaesthesia(wlanrowid),"^",64)    ;手术规模
    ..s OpLevelDesc=""
    ..i +opLevelCode'=0 d
    ...s OpLevelDesc=$P(^DHCANC("OPLevel",opLevelCode),"^",2)
    ..s medthid=$p(^DHCWLAnaesthesia(wlanrowid),"^",8)    ;麻醉方式
    ..s MethodDesc=""
    ..i +medthid'=0 d
    ...s MethodDesc=$P(^ORC("ANMET",medthid),"^",2)
    ..s PatLocDr=$p(^DHCWLAnaesthesia(wlanrowid),"^",5)    ;病人所在科室
    ..Q:(LocId'="")&&('$D(^||TEMPDHCWL($j,"PatLoc",PatLocDr)))
    ..s PatLocDesc=""
    ..i +PatLocDr'=0 d
    ...s PatLocDesc=$P(^CTLOC(PatLocDr),"^",2)
    ..i PatLocDesc["-" s PatLocDesc=$P(PatLocDesc,"-",2)
    ..s PatWardr=$p(^DHCWLAnaesthesia(wlanrowid),"^",6)    ;病区
    ..s PatWardDesc=""
    ..i +PatWardr'=0 d
    ...s PatWardDesc=$P(^PAWARD(PatWardr),"^",2)
    ..i PatWardDesc["-" s PatWardDesc=$P(PatWardDesc,"-",2)
    ..s recopdr=$p(^DHCWLAnaesthesia(wlanrowid),"^",63)   ;接收科室
    ..s operDr=$p(^DHCWLAnaesthesia(wlanrowid),"^",42)
    ..s OperName=""
    ..s OperName=$$GetOpName(wlanrowid)
    ..//i +operDr'=0 d
    ...//s OperName=$P(^ORC("OPER",operDr),"^",2)
    ..s operdocdr=$p(^DHCWLAnaesthesia(wlanrowid),"^",50)    ;主刀医生
    ..s operdocName=""
    ..i +operdocdr'=0 d
    ...s operdocName=$P(^CTPCP(operdocdr,1),"^",2)
    ..s AssistDocdr=$p(^DHCWLAnaesthesia(wlanrowid),"^",52)    ;手术助理1 
    ..s AssistDocdr1=$p(^DHCWLAnaesthesia(wlanrowid),"^",53)    ;手术助理2 
    ..s AssistDocdr2=$p(^DHCWLAnaesthesia(wlanrowid),"^",54)    ;手术助理3 
    ..s AssistDocName=""
    ..i +AssistDocdr'=0 d
    ...s AssistDocName=$P($G(^CTPCP(AssistDocdr,1)),"^",2)
    ..i +AssistDocdr1'=0 d
    ...s AssDocName1=$P($G(^CTPCP(AssistDocdr1,1)),"^",2)
    ...q:AssDocName1=""
    ...i AssistDocName="" s AssistDocName=AssDocName1
    ...else  s AssistDocName=AssistDocName_" "_AssDocName1
    ..i +AssistDocdr2'=0 d
    ...s AssDocName2=$P($G(^CTPCP(AssistDocdr2,1)),"^",2)
    ...q:AssDocName2=""
    ...i AssistDocName="" s AssistDocName=AssDocName2
    ...else  s AssistDocName=AssistDocName_" "_AssDocName2
    ..s CirNursedr1=$p(^DHCWLAnaesthesia(wlanrowid),"^",58)    ;巡回护士
    ..s CirNursedr2=$p(^DHCWLAnaesthesia(wlanrowid),"^",59)    ;巡回护士
    ..s CirNurseName=""
    ..i +CirNursedr1'=0 d
    ...s CirNurseName=$P(^CTPCP(CirNursedr1,1),"^",2)
    ..i +CirNursedr2'=0 d
    ...s CirNurse=$P(^CTPCP(CirNursedr2,1),"^",2)
    ...q:CirNurse=""
    ...i CirNurseName="" s CirNurseName=CirNurse
    ...else  s CirNurseName=CirNurseName_" "_CirNurse
    ..s ScrNursedr1=$p(^DHCWLAnaesthesia(wlanrowid),"^",60)    ;器械护士 
    ..s ScrNursedr2=$p(^DHCWLAnaesthesia(wlanrowid),"^",61)    ;器械护士 
    ..s ScrNurseName=""
    ..i +ScrNursedr1'=0 d
    ...s ScrNurseName=$P($G(^CTPCP(ScrNursedr1,1)),"^",2)
    ..i +ScrNursedr2'=0 d
    ...s ScrNurse=$P($G(^CTPCP(ScrNursedr2,1)),"^",2)
    ...q:ScrNurse=""
    ...i ScrNurseName="" s ScrNurseName=ScrNurse
    ...else  s ScrNurseName=ScrNurseName_" "_ScrNurse
    ..s AnDoc=+$p(^DHCWLAnaesthesia(wlanrowid),"^",9)   ;麻醉医生1
    ..s AnDoc1=+$p(^DHCWLAnaesthesia(wlanrowid),"^",55)   ;麻醉医生2
    ..s AnDocName=""
    ..i +AnDoc'=0 d
    ...s AnDocName=$P($g(^CTPCP(AnDoc,1)),"^",2)
    ..i +AnDoc1'=0 d
    ...s AnDocName1=$P($g(^CTPCP(AnDoc1,1)),"^",2)
    ..i $g(AnDocName1)'="" s AnDocName=AnDocName_" "_AnDocName1
 	..s OperRoomDr=$p(^DHCWLAnaesthesia(wlanrowid),"^",19)  ; 手术间
 	..s OperCutDr=$p(^DHCWLAnaesthesia(wlanrowid),"^",18)  ; 切口等级
 	..s OperCutDesc=""
 	..i OperCutDr'="" s OperCutDesc=$P($g(^ORC("BLDTP",OperCutDr)),"^",2)
 	..s OperDate=$ZD(day,3)
 	..s ^CacheTemp(repid,ind)=$lb(Admid,PatName,PatNo,PatId,PatAge,PatSex,PatLocDr,PatLocDesc,PatWardr,PatWardDesc,OperName,operdocName,AssistDocName,OperDate,CirNurseName,ScrNurseName,AnDocName,OperCutDesc,MethodDesc,OpLevelDesc)
 	..s ind=ind+1

	k ^||TEMPDHCWL($j)
	Quit $$$OK

GetOpName(wlanrowid)    ;统计手术名称(包含附加手术)
    //s rValue=$p($g(^ORC("OPER",wlanValue)),"^",2)
    s rValue=""
    s wlansubdr=0 f  s wlansubdr=$o(^DHCWLAnaesthesia(wlanrowid,"OP",wlansubdr)) q:wlansubdr=""  d
    .s wlanValue=$p(^DHCWLAnaesthesia(wlanrowid,"OP",wlansubdr),"^",1) 
    .i rValue="" s rValue=$p($g(^ORC("OPER",wlanValue)),"^",2)
    .e  s rValue=$g(rValue)_$c(10)_"+ "_$p($g(^ORC("OPER",wlanValue)),"^",2)
    q rValue
}

ClassMethod GetOperationInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOperationInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetOperationInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOperationInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Storage Default
{
<Data name="OPQueryInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCWL.OPQueryInfoD</DataLocation>
<DefaultData>OPQueryInfoDefaultData</DefaultData>
<IdLocation>^DHCWL.OPQueryInfoD</IdLocation>
<IndexLocation>^DHCWL.OPQueryInfoI</IndexLocation>
<StreamLocation>^DHCWL.OPQueryInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
