Import SQLUser

Class web.DHCICUCom Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod getCurDateAndTime() As %String
{
	s dat=$zd(+$h,3)
	s tim=$zt($p($h,",",2))
	q dat_"^"_tim
}

ClassMethod GetEqUomQty(arcimId) As %String
{
	q:arcimId="" "^1"
	s phcdfId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",12)
	q:phcdfId="" "^1"
	s phcdId=+phcdfId,phcdfSub=$p(phcdfId,"||",2)
	q:phcdfSub="" "^1"
	s baseUomId=$p(^PHCD(phcdId,"DF",phcdfSub,2),"^",4)
	
	s eqUomId=baseUomId,eqQty=1
	s eqId=0
	f  s eqId=$o(^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId)) q:eqId=""  d
		.s eqUomId=+^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId)
		.s eqQty=$p(^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId),"^",2) q
	i eqQty=0 s eqQty=1
	i $p(eqQty,".",1)="" s eqQty=0_eqQty
	q eqUomId_"^"_eqQty
}

ClassMethod GetCTUOM() As %String
{
	k ^TMPICU("Com",$i)
	s ctuomCode=0,i=0
	f  s ctuomCode=$o(^CT("UOM",0,"Code",ctuomCode)) q:ctuomCode=""  d
	    .s ctuomId=$o(^CT("UOM",0,"Code",ctuomCode,""))
	    .q:ctuomId=""
	    .s sortNo=$p(^CT("UOM",ctuomId),"^",3)
	    .i +sortNo'=sortNo s sortNo=10000
	    .s sortNo=sortNo+(ctuomId/10000)
	    .s unitDesc=$ZCVT($p($g(^CT("UOM",+ctuomId)),"^",2),"l")
	    .s unitCode=$p(^CT("UOM",+ctuomId),"^",1)
	    .s tmpUom(sortNo)=ctuomId_"^"_unitDesc_"^"_unitCode
	s sortNo=""
	f  s sortNo=$o(tmpUom(sortNo)) q:sortNo=""  d
	    .s i=i+1 
		.s ^TMPICU("Com",$i,i)=tmpUom(sortNo)
	q i
}

ClassMethod GetIcuarrange(date As %String) As %String
{
	k ^TMPICU("Com",$i)
	s arcimSub=0,i=0
	f  s arcimSub=$o(^ARCIM(arcimSub)) q:arcimSub=""  d
	    .s arcicId=$p(^ARCIM(arcimSub,1,1),"^",10)
	    .i $p(^ARC("IC",arcicId),"^",8)'=30 q
	    .s ^TMPICU("Com",$i,i)=arcimSub_"||1,"_$p(^ARCIM(arcimSub,1,1),"^",2)
	    .s i=i+1 
	q i
}

ClassMethod GetPHCIN() As %String
{
	k ^TMPICU("Com",$i)
	s phcinId=0,i=0
	f  s phcinId=$o(^PHCIN(phcinId)) q:phcinId=""  d
	    .s sortNo=+$p(^PHCIN(phcinId),"^",3)
	    .i sortNo=0 s sortNo=10000
	    .s sortNo=sortNo+(phcinId/10000)
	    .s tmpPhcin(sortNo)=phcinId_"^"_$p(^PHCIN(phcinId),"^",2)_"^"_$p(^PHCIN(phcinId),"^",1)
	s sortNo=""
	f  s sortNo=$o(tmpPhcin(sortNo)) q:sortNo=""  d
	    .s i=i+1 
		.s ^TMPICU("Com",$i,i)=tmpPhcin(sortNo)
	q i
}

ClassMethod GetCTLOC(typeStr As %String = "W^E^D^OP^EM^CL") As %String
{
	k ^TMPICU("Com",$i)
	s ctlocId=0,i=0
	f  s ctlocId=$o(^CTLOC(ctlocId)) q:ctlocId=""  d
	    .q:"^"_typeStr_"^"'[("^"_$p(^CTLOC(ctlocId),"^",13)_"^")
	    .//w $p(^CTLOC(ctlocId),"^",2),!
	    .s ^TMPICU("Com",$i,i)=ctlocId_"^"_$p(^CTLOC(ctlocId),"^",2)
	    .s i=i+1 
	q i
}

ClassMethod GetPara(icuaId As %String, ctlocId As %String = "") As %String
{
	//少了两列
	//q:(+icuaId=0) 0
	s i=0,resStr="",tmpStr=""
	i (+icuaId=0) s icupId="Default"
	e  s icupId=..GetIcupId(icuaId,ctlocId)
	q:icupId="" ""

	s icupiSub=0
	f  s icupiSub=$o(^DHCICUPara(icupId,"I",icupiSub)) q:icupiSub=""  d
	    .s icupiStr=^DHCICUPara(icupId,"I",icupiSub)
	    .//w icupiStr,!
	    .s $p(icupiStr,"^",13)=$p($g(^DHCANC("VPSite",+$p(icupiStr,"^",13))),"^",2)
	    .s icupiStr=$tr(icupiStr,"^","!")
	    .s tmpOrder=$p($g(^DHCICUC("RecordItem",+$p(icupiStr,"!",4))),"^",2)
	    .i tmpOrder="" d
	    ..s tmpOrder=$p($g(^ARCIM(+$p(icupiStr,"!",3),1,1)),"^",2)
	    .//s tmpStr=tmpStr_"!"_tmpOrder
	    .s $p(icupiStr,"!",10)=$p(icupiStr,"!",10)_"!"_$p($g(^DHCANC("Scale",+$p(icupiStr,"!",10))),"^",3)_"!"_$p($g(^DHCANC("Scale",+$p(icupiStr,"!",10))),"^",5)
	    .s $p(resStr,"^",$p(icupiStr,"!",8))=icupId_"||"_icupiSub_"!"_tmpOrder_"!"_icupiStr
	s resStr=resStr_"^"_$p($g(^DHCICUPara(icupId)),"^",2)_"!"_$p($g(^DHCICUPara(icupId)),"^ ",3)
	q resStr
}

ClassMethod GetItems(i As %String, j As %String) As %Library.List
{
 s k=0,returnList=""
 f k=i:1:(i+j) d
     .i $d(^TMPICU("Com",$i,k))=1 d
         ..s returnList=returnList_$LB($LB(^TMPICU("Com",$i,k)))
         ..k ^TMPICU("Com",$i,k)
         ..//w k,!
 q returnList
}

ClassMethod SetPara(icuaId As %String, paraStr As %String, ctlocId As %String = "") As %String
{
	q:(+icuaId=0) -1
	
	s paraId=$o(^DHCICUPara(0,icuaId,""))
	;w paraId

	k ^DHCICUPara(paraId,"I")
	////s paraStr="!动脉穿刺!!!D!M!!1!255!0!0!!^!!22696||1!强痛定针!D!M!!2!0!255!255!!^!开胸!!!D!M!!3!255!0!128!!^!!22392||1!强痛定片!D!M!!4!128!0!0!!^!拔气管插管!!!D!M!!5!255!128!128!!^ESOP食道镜!!!!D!I!1!6!0!255!0!0!10^ETCO2 !!!!D!I!3!7!0!0!255!14!1^!!22692||1!吗啡控释片!D!M!!8!128!0!128!!^EPSS!!!!D!I!5!9!255!255!0!0!10^HEMO有创血液动力学监测!!!!D!I!7!10!255!128!0!0!10^!!22389||1!杜冷丁针!D!M!!11!128!128!0!!^!动脉穿刺!!!D!M!!12!0!128!255!!^!诱导!!!D!M!!13!128!0!255!!^!动脉穿刺!!!D!M!!14!255!0!255!!"
	////s paraStr="!300!8^24!!!!D!I!1!1!0|255|0!2!N^35!!!!D!I!4!2!0|0|255!1!N^23!!!!D!I!8!3!255|64|255!2!N^26!!!!D!I!7!4!255|128|0!2!N^!!!2!D!M!!5!255|0|0!!Y^!!!1!D!M!!6!0|255|255!!Y^20!!!!D!M!!7!255|128|128!!N^!!!4!D!M!!8!128|0|128!!N"
	////s paraStr="!300!8^!!!2!D!M!!1!255|0|0!!Y^!!!7!D!M!!2!0|255|255!!Y^!!!5!D!M!!3!255|0|128!^!!!4!D!M!!4!128|0|0!^20!!!!D!M!!5!255|128|128!^24!!!!D!I!1!6!0|255|0!2^25!!!!D!I!3!7!0|0|255!1^!!!5!D!M!!8!128|0|128!^23!!!!D!I!5!9!255|255|0!2^26!!!!D!I!7!10!255|128|0!2^!!!2!D!M!!11!128|128|0!^!!!8!D!M!!12!0|128|255!"
	s num=$l(paraStr,"^")
	i num<2 q -2
	;w ^DHCICUPara(paraId),!
	s $p(^DHCICUPara(paraId),"^",2)=$p(paraStr,"!",2)
	;w ^DHCICUPara(paraId),!
	s $p(^DHCICUPara(paraId),"^",3)=$p($p(paraStr,"!",3),"^")
	;w ^DHCICUPara(paraId),!
	s ^DHCICUPara(paraId,"I",0)=num-1
	f i=2:1:num d
	    .s paraiStr=$p(paraStr,"^",i)
	    .s paraiStr=$tr(paraiStr,"!","^")
	    .s tmpStr=$p(paraiStr,"^",3)
	    .i tmpStr'="" d
	        ..s icucriId=0
	        ..f  s icucriId=$o(^DHCICUC("RecordItem",icucriId)) q:icucriId=""  d
	            ...i tmpStr=$p(^DHCICUC("RecordItem",icucriId),"^",4) s $p(paraiStr,"^",4)=icucriId
	    .s tmpStr=$p(paraiStr,"^",4)
	    .i tmpStr'="",$p(paraiStr,"^",3)="" d
	        ..s $p(paraiStr,"^",3)=$p($g(^DHCICUC("RecordItem",tmpStr)),"^",4)
	    .s ancvpsId=0
	    .f  s ancvpsId=$o(^DHCANC("VPSite",ancvpsId)) q:ancvpsId=""  d
	        ..i $p(paraiStr,"^",13)=$p(^DHCANC("VPSite",ancvpsId),"^",2) s $p(paraiStr,"^",13)=ancvpsId
	    .s ^DHCICUPara(paraId,"I",i-1)=paraiStr
	i ctlocId'="" m ^DHCICUC("Para",ctlocId)=^DHCICUPara(paraId)
	q 0
}

ClassMethod UpdateBedEquip(wardId As %String, bedEquipIp As %String) As %String
{
	q:(wardId="" || bedEquipIp="") "-1"
	s bedEquipId=""
	s count=0
	f  s bedEquipId=$o(^DHCICUBedEquip(bedEquipId)) q:bedEquipId=""  d
	.s bedId=$p($g(^DHCICUBedEquip(bedEquipId)),"^",1)
	.s bedWardId=$p($g(bedId),"||",1)
	.q:(bedWardId'=wardId)
	.s equipAddress=$p($g(^DHCICUBedEquip(bedEquipId)),"^",3)
	.s firstField=$p($g(equipAddress),"|",1)
	.s thirdField=$p($g(equipAddress),"|",3)
	.s forthField=$p($g(equipAddress),"|",4)
	.s secondField=bedEquipIp
	.s $p(^DHCICUBedEquip(bedEquipId),"^",3)=firstField_"|"_secondField_"|"_thirdField_"|"_forthField
	.s count=count+1
	q count
}

ClassMethod AutoTerminal(monIcuaId, bedId) As %String
{
	s retStr=0
	q:monIcuaId="" 0
	q:'$d(^DHCICUArrange(monIcuaId)) 0
	q:bedId="" 0
	q:$p(^DHCICUArrange(monIcuaId),"^",18)'="M" 0
	s EpisodeID=$p(^DHCICUArrange(+monIcuaId),"^",1)
	q:EpisodeID="" 0
	s paadmVisitStatus=$p($g(^PAADM(EpisodeID)),"^",20)
	q:paadmVisitStatus="" 0
	s icuoId=$o(^DHCICUOrder(0,"Arr",monIcuaId,""),-1)
	s paAdmBedId=$p($g(^PAADM(EpisodeID)),"^",73)
	//i (icuoId="")!(paadmVisitStatus'="A") d
	i (icuoId="")!(paadmVisitStatus'="A")!(paAdmBedId'=bedId) d
		.s ^tmpCLEquip("autoIcu",monIcuaId)=$zd($h,3)_" "_$zt($p($h,",",2))_" visitStat:"_paadmVisitStatus
		.&sql(update DHC_ICU_Arrange set ICUA_Status='T' where ICUA_RowId=:monIcuaId)
		.s retStr=..StopEquipCollect(monIcuaId)
	e  d
		.s papmiId=+^PAADM(+(^DHCICUArrange(monIcuaId)))
		.s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
		.s icuaStartDate=$p(^DHCICUArrange(monIcuaId),"^",6)
		.s retStr="InRoom"_"^"_"病人"_patName_"(监护Id:"_monIcuaId_")正在监护!请选择日期"_$zd(icuaStartDate,3)_"查询,结束监护,退出后方可继续操作!"
	q retStr
}

ClassMethod SetInDateTime(icuaId As %String, startDate As %String, startTime As %String, isSet As %String = "1") As %String
{
	q:(+icuaId=0) "-1"
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s startTime=##class(web.DHCClinicCom).ConvertToTimeH(startTime)
	//R为准备，M为监护，T为中止，只有这三种才能开始重症监护
	q:"RMT"'[$p(^DHCICUArrange(icuaId),"^",18) "监护状态不对!"
	s icuaBedId=$p($g(^DHCICUArrange(icuaId)),"^",4)
	s EpisodeID=$p(^DHCICUArrange(+icuaId),"^",1)
	q:(+EpisodeID=0) "noEpisodeIDId^无病人就诊号!"
	
	s admVisitStatus=$p($g(^PAADM(EpisodeID)),"^",20)
	q:(admVisitStatus="D") 0
	s curWardId=$p($g(^PAADM(EpisodeID)),"^",70)
	//跨病区//q:curWardId'=+icuBedId 0
	
	s bedId=$p($g(^PAADM(EpisodeID)),"^",73)
	//s bedSub=$p(bedId,"||",2)
	//q:+bedSub=0 -2 ;"未定义床位!"
	//s bedTpId=$p($g(^PAWARD(+bedId,"BED",+bedSub)),"^",2)
	//s icuBed=$p($g(^PAC("BEDTP",+bedTpId)),"^",5)
	//q:icuBed'="Y" -3 //"非重症监护床!" 
	s icuaBedSub=$p(icuaBedId,"||",2)
	q:+icuaBedSub=0 -2 ;"未定义床位!"
	s icuaBedTpId=$p($g(^PAWARD(+icuaBedId,"BED",+icuaBedSub)),"^",2)
	s icuBed=$p($g(^PAC("BEDTP",+icuaBedTpId)),"^",5)
	q:icuBed'="Y" -3 //"非重症监护床!" 
	
	//w bedId,"/",$d(^DHCICUArrange(0,"BedStatus",bedId,"M")),!
	s retStr=0
	i bedId'="",$d(^DHCICUArrange(0,"BedStatus",bedId,"M"))>0 d
		.q:+bedId'=+icuaBedId
		.s monIcuaId=$o(^DHCICUArrange(0,"BedStatus",bedId,"M",""))
		.q:monIcuaId=""
		.i monIcuaId'=icuaId d
			..s retStr=..AutoTerminal(monIcuaId, bedId)
	q:retStr'=0 retStr
	
	////s icupId=..GetIcupId(icuaId)
	s interval="" ///get from roomequip
	
	i "RT"[$p(^DHCICUArrange(icuaId),"^",18) d
		.s null=""
		.&sql(update DHC_ICU_Arrange set ICUA_Status='M',ICUA_EndDate=:null,ICUA_EndTime=:null where ICUA_RowId=:icuaId)
		.s retStr=SQLCODE
	q:retStr'=0 retStr
	
	//为点击开始按钮进入，写入室时间
	i isSet d
		.s retStr=##class(web.DHCICUArrange).AdjIcuaStartDateTime(EpisodeID, .startDate, .startTime)
		.q:retStr'=0
		.i (startDate="")!(startTime="") s retStr="该病人转病区时间有误!" q
		.//s wardInDateTimeStr=##class(web.DHCANOPCom).GetWardInDateTime(EpisodeID)
		.//s wardInDate=$p(wardInDateTimeStr,"^",1)
		.//s wardInTime=$p(wardInDateTimeStr,"^",2)
		.//i (inDate+(inTime/100000))<(wardInDate+(wardInTime/100000)) d
			.//.s inDate=wardInDate,inTime=wardInTime
		.//i (inDate="")!(inTime="") s retStr="日期或时间有误!" 
		.&sql(update DHC_ICU_Arrange set ICUA_StartDate=:startDate,ICUA_StartTime=:startTime where ICUA_RowId=:icuaId)
		.i SQLCODE s retStr="修改入室时间错！SQLCODE="_SQLCODE
	q:retStr'=0 retStr

	//不论启动设备是否成功，都可以手工操作
	s retStr=..StartEquipCollect(icuaId)
	q retStr
}

ClassMethod StartEquipCollect(icuaId As %String) As %String
{
	s res=##class(web.DHCICUDeviceTask).StartByIcuaId(icuaId,"StartEq")
	q res
}

ClassMethod SetOutDateTime(icuaId As %String, outDate As %String, outTime As %String) As %String
{
	q:(+icuaId=0) -1
	s outDate=##class(web.DHCClinicCom).ConvertToDateH(outDate)
	s outTime=##class(web.DHCClinicCom).ConvertToTimeH(outTime)
	s bedId=$p($g(^DHCICUArrange(icuaId)),"^",4)
	s retStr=..StopEquipCollect(icuaId)
	b    
	i outDate>$h s outDate=+$h,outTime=$p($h,",",2)
	i retStr=0 d
	    .&sql(update DHC_ICU_Arrange set ICUA_Status='T',ICUA_EndDate=:outDate,ICUA_EndTime=:outTime where ICUA_RowId=:icuaId)
	    .i SQLCODE s retStr=SQLCODE
	b "end"    
    q retStr
}

ClassMethod SetLeaveCondition(icuaId As %String, icuaLeaveCondition As %String, leaveDate As %String, leaveTime As %String) As %String
{
	q:(+icuaId=0) -1
	i icuaLeaveCondition="" s icuaLeaveCondition="T"
	s leaveDate=##class(web.DHCClinicCom).ConvertToDateH(leaveDate)
	s leaveTime=##class(web.DHCClinicCom).ConvertToTimeH(leaveTime)
	i leaveDate>$h s leaveDate=+$h,leaveTime=$p($h,",",2)
	
	s retStr=0
	&sql(update DHC_ICU_Arrange set ICUA_LeaveCondition=:icuaLeaveCondition,ICUA_LeaveDate=:leaveDate,ICUA_LeaveTime=:leaveTime where ICUA_RowId=:icuaId)
	i SQLCODE s retStr=SQLCODE
    q retStr
}

// 修改StopEquipCollect为

ClassMethod StopEquipCollect(icuaId As %String) As %String
{
	quit 0
    // s res=##class(web.DHCICUDeviceTask).StartByIcuaId(icuaId,"StopEq")
	// q res
}

ClassMethod GetPatInfo(icuaId As %String) As %String
{
	q:(+icuaId=0) ""
	s EpisodeID=$p(^DHCICUArrange(icuaId),"^",1)
	s papmiId=+^PAADM(+EpisodeID)
	s regNo=$p(^PAPER(papmiId,"PAT",1),"^",1)
	s patName=$p(^PAPER(papmiId,"ALL"),"^",1)

	q "病人姓名:"_patName_" 登记号:"_regNo
}

ClassMethod GetIcuArrangeInfo(icuaId As %String) As %String
{
	q:(+icuaId=0) ""
	q:'$d(^DHCICUArrange(icuaId)) ""
	s EpisodeID=$p(^DHCICUArrange(icuaId),"^",1)
	q EpisodeID
}

ClassMethod GetInOutDateTime(icuaId As %String) As %String
{
	s inOutDateTime = $zd(+$h,3)_"^"_$zt($p($h,",",2))_"^"_$zd(+$h,3)_"^"_$zt($p($h,",",2))
	q:(+icuaId=0) inOutDateTime
	q:'$d(^DHCICUArrange(icuaId)) inOutDateTime

	s resStr=$zd($p(^DHCICUArrange(icuaId),"^",6),3)
	s resStr=resStr_"^"_$zt($p(^DHCICUArrange(icuaId),"^",8))
	s resStr=resStr_"^"_$zd($p(^DHCICUArrange(icuaId),"^",7),3)
	s resStr=resStr_"^"_$zt($p(^DHCICUArrange(icuaId),"^",9))
	q resStr
}

ClassMethod GetOrderItemRecloc(icuaId As %String, arcimId As %String) As %String
{
 i (+icuaId=0)!(arcimId="") q -2
 s EpisodeID=$p(^DHCICUArrange(icuaId),"^",1)
 s Config=##Class(websys.Configuration).%OpenId(1)
 s MEDDATA=Config.DataNamespace
 s LABDATA=Config.LabDataNamespace
 s CurNamespace=$ZNSPACE
 zn MEDDATA		
 s retStr=$$getall^aOET3a(EpisodeID,arcimId,"")
 i retStr'="0" k PLIST w "kill",!
 ;w PLIST_"  "_PLIST(2)
 s retStr=-1
 s inum=0
 f  s inum=$o(PLIST(inum))  q:inum=""  d
     .;w PLIST(inum)," /"_$p(PLIST(inum),$c(3),3),!
     .i $p(PLIST(inum),$c(3),3)="Y" s retStr=+PLIST(inum)
 zn CurNamespace
 q retStr
}

ClassMethod GetAllIcon() As %String
{
 s i=0,retStr=-1
 f  s i=$o(^DHCANC("Icon",i)) q:i=""  d
     .i +^DHCANC("Icon",i)>1000 q
     .i retStr'=-1 s retStr=retStr_"!"_i_"^"_^DHCANC("Icon",i)
     .i retStr=-1 s retStr=i_"^"_^DHCANC("Icon",i)
 q retStr
}

ClassMethod FormatDuration(intervalSec, dayExpress) As %String
{
	//dayExpress不为空，显示的是日期的显示单位及间隔符，为空显示小时数，不显示天数
	i intervalSec<0.0001 q ""
	s intervalDay=$p((intervalSec/86400),".")
	//w intervalSec,!
	
	i +intervalDay=0 s intervalDay=""
	s formatTime=$zt((intervalSec-(86400*intervalDay)),2)
	i intervalDay'="" d
	    .i dayExpress="" d
	        ..s $p(formatTime,":")=intervalDay*24+formatTime
	        ..s intervalDay=""
	    .s intervalDay=intervalDay_dayExpress
	q intervalDay_formatTime
}

ClassMethod GetPatientAgeByDate(icuaId As %String, date As %String, EpisodeID As %String = "") As %String
{
	q:(+icuaId=0)&(EpisodeID="") ""
	i date="" s date=##class(web.DHCClinicCom).ConvertToDateH(+$h)
	e  s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	i icuaId>0 s EpisodeID=$p($g(^DHCICUArrange(icuaId)),"^",1)
	q:EpisodeID="" ""
	s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
	s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
	s ageInfo=##class(web.DHCClinicCom).CalAge(birth,date)
	q ageInfo
}

ClassMethod GetPatientBedInfoByDateTime(icuaId As %String, date As %String, time As %String) As %String
{
	q:(+icuaId=0) ""
	s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	s time=##class(web.DHCClinicCom).ConvertToTimeH(time)
	s EpisodeID=$p($g(^DHCICUArrange(icuaId)),"^",1)
	q:EpisodeID="" ""
	s transInfo=##class(web.DHCClinicCom).GetTransInfoByTime(EpisodeID,date,time)
	//s retStr=regNo_"^"_ctlocDesc_"^"_$g(room)_"^"_$g(sex)_"^"_$g(patName)_"^"_$g(safetyNetCardNo)_"^"_$g(bedCode)_"^"_$g(age)_"^"_$g(wardDesc)_"^"_homeAddres_"^"_homeTel_"  "_workTel_"  "_handtel_"^"_$G(DocDes)_"^"_MedCareNo_"^"_MRDiagnos_"^"_Nation_"^"_paersonLX_"^"_DrugCell_"^"_$G(birthDate)_"^"_$G(patWordUnit)_"^"_$G(PersonID)_"^"_BloodType_"^"_PAAdmReasonDesc_"^"_AdmDoc_"^"_MainNurse_"^"_admStayDay
	s ctlocDesc=$p($g(^CTLOC(+$p(transInfo,"^",1))),"^",2)
    i $p(ctlocDesc,"-",2)'="" s ctlocDesc=$p(ctlocDesc,"-",2)
	s wardDesc=$p($g(^PAWARD(+$p(transInfo,"^",2))),"^",2)
    i $p(wardDesc,"-",2)'="" s wardDesc=$P(wardDesc,"-",2)
	s roomDesc=$p($g(^PAROOM(+$p(transInfo,"^",3))),"^",2)
	s bedId=$p(transInfo,"^",4)
    i bedId="" s bedId=$p(^PAADM(EpisodeID),"^",73)
    s bedSub=$p(bedId,"||",2)
	s bedCode=$p($g(^PAWARD(+bedId,"BED",+bedSub)),"^",1)
	q bedCode
}

/// 返回以^分割的串
/// patBaseInfo^patInfo^patOtherHIS^patAnInfo
/// patInfo:就诊日期，诊断，ICU住天数，就诊号，病区Id，常规开始日期，常规开始时间，入病区时间，重症监护安排表Id，ICU病人身高
/// 			icu病人体重，转入科室，转入病区
/// patAnInfo:日期date_$c(3)_时间time_$c(3)_重症排班ID_$c(3)_用|分割的麻醉方法ID_$c(4)_用+分割的麻醉方法描述串
/// 			_$c(3)_用|分割的手术ID_$c(4)_用+分割的手术描述串_$c(3)_镇痛方式_$c(3)_失血量_$c(3)_尿量_$c(3)_输液量_$c(3)_输血量
/// 			_$c(3)_回室意识_$c(3)_回室体位ID_$c(4)_回室体位描述_$c(3)_回室日期_$c(3)_回室时间_$c(3)_备注
ClassMethod GetIcuaInfo(icuaId As %String, date As %String = "", time As %String = "", EpisodeID As %String = "") As %String [ SqlProc ]
{
	q:(+icuaId=0)&(EpisodeID="") ""
	i EpisodeID="" s EpisodeID=$p($g(^DHCICUArrange(+icuaId)),"^",1)
	q:EpisodeID="" ""
	q:'$d(^PAADM(EpisodeID)) ""
	i icuaId'="" d
		.s wardOutDateTime=##class(web.DHCICUCom).GetWardOutDateTime("",icuaId,"","","^","D")
		.q:wardOutDateTime=""
		.s date=$p(wardOutDateTime,"^",1),time=$p(wardOutDateTime,"^",2)
		.i time>0 s time=time-1
		.i time<0 s date=date-1,time=86399
		.s date=$p($g(^DHCICUArrange(icuaId)),"^",6),time=$p($g(^DHCICUArrange(icuaId)),"^",8)
	s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	s time=##class(web.DHCClinicCom).ConvertToTimeH(time)
 	i icuaId="" s icuaId=..GetIcuaId(EpisodeID,"","")
	s patInfo=##class(web.DHCClinicCom).PatInfo("^"_EpisodeID,"",date,time)
	//w patInfo,!
	s transInfo=##class(web.DHCClinicCom).GetTransInfoByTime(EpisodeID,date,time)
	//s retStr=regNo_"^"_ctlocDesc_"^"_$g(room)_"^"_$g(sex)_"^"_$g(patName)_"^"_$g(safetyNetCardNo)_"^"_$g(bedCode)_"^"_$g(age)_"^"_$g(wardDesc)_"^"_homeAddres_"^"_homeTel_"  "_workTel_"  "_handtel_"^"_$G(DocDes)_"^"_MedCareNo_"^"_MRDiagnos_"^"_Nation_"^"_paersonLX_"^"_DrugCell_"^"_$G(birthDate)_"^"_$G(patWordUnit)_"^"_$G(PersonID)_"^"_BloodType_"^"_PAAdmReasonDesc_"^"_AdmDoc_"^"_MainNurse_"^"_admStayDay
	s ctlocDesc=$p($g(^CTLOC(+$p(transInfo,"^",1))),"^",2)
	i $p(ctlocDesc,"-",2)'="" s ctlocDesc=$p(ctlocDesc,"-",2)
	s wardDesc=$p($g(^PAWARD(+$p(transInfo,"^",2))),"^",2)
	i $p(wardDesc,"-",2)'="" s wardDesc=$P(wardDesc,"-",2)
	s roomDesc=$p($g(^PAROOM(+$p(transInfo,"^",3))),"^",2)
	s bedId=$p(transInfo,"^",4)
	s bedId=$p(^DHCICUArrange(+icuaId),"^",4)
	i bedId="" s bedId=$p(^PAADM(EpisodeID),"^",73)
	s bedSub=$p(bedId,"||",2)
	s wardId=$p(bedId,"||",1)
	s bedCode=$p($g(^PAWARD(+bedId,"BED",+bedSub)),"^",1)
	s preCtlocDesc=$p($g(^CTLOC(+$p(transInfo,"^",5))),"^",2)
	s preWardDesc=$p($g(^PAWARD(+$p(transInfo,"^",6))),"^",2)
	s $p(patInfo,"^",2)=ctlocDesc
	s $p(patInfo,"^",9)=wardDesc
	s $p(patInfo,"^",3)=roomDesc
	s $p(patInfo,"^",7)=bedCode
	
	s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
	s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
	s $p(patInfo,"^",8)=##class(web.DHCClinicCom).CalAge(birth,date)
	s resStr=patInfo //$p(patInfo,"^",1,9) //regNo_"^"_ctlocDesc_"^"_$g(room)_"^"_$g(sex)_"^"_$g(patName)_"^"_$g(safetyNetCardNo)_"^"_$g(bedCode)_"^"_$g(age)_"岁^"_$g(wardDesc)
	s resStr=$tr(resStr,"^",$c(3))
	
	s admDate=$p($g(^PAADM(EpisodeID)),"^",6)
	i admDate'="" s admDate=$zd(admDate,3)
	//s dtypIdStr=$g(^DHCCLSet("Disch","DiagTypeId"))
	//q:dtypIdStr="" 0
	s mradmId=$P(^PAADM(EpisodeID),"^",61)
	s icuaRelatedDiagDr=$p(^DHCICUArrange(+icuaId),"^",20)
	s mrdiaSub=0,mrcidDesc=""
	f  s mrdiaSub=$O(^MR(mradmId,"DIA",mrdiaSub)) q:(mrdiaSub="")  d
		.//q:$p(^MR(mradmId,"DIA",mrdiaSub),"^",7)>date
		.s mrcidId=$p(^MR(mradmId,"DIA",mrdiaSub),"^")
		.//q:("|"_icuaRelatedDiagDr_"|")'[("|"_mrcidId_"|")
		.i mrcidId'="" s curMrcidDesc=$p($g(^MRC("ID",+mrcidId)),"^",2)
		.e  s curMrcidDesc=$g(^MR(mradmId,"DIA",mrdiaSub,"DES",1))
		.q:curMrcidDesc=""
		.s mrcidDesc=$tr(mrcidDesc,$c(13))
		.s mrcidDesc=$tr(mrcidDesc,$c(10))
		.i mrcidDesc'="" s mrcidDesc=mrcidDesc_","
		.s mrcidDesc=mrcidDesc_curMrcidDesc
	s bedTpId=$p($g(^PAWARD(+bedId,"BED",+bedSub)),"^",2)
	s icuBed=$p($g(^PAC("BEDTP",+bedTpId)),"^",5)
	s fromDate=..GetWardInDateTime(EpisodeID,icuaId,"","","^","D") //获取病人时间
	s IcuSDateTmp=$p($g(^DHCICUArrange(+icuaId)),"^",6) //icu开始日期 add by lyn
	/*i icuBed="Y" d
		.s preBedId="",findFlag="N"
		.s transId="" f  s transId=$o(^PAADM(EpisodeID,"TRANS",transId),-1) q:(transId="")!(findFlag="Y")  d  
			..s transStr=^PAADM(EpisodeID,"TRANS",transId)
			..s preBedId=$p(transStr,"^",8)
			..s endDate=$p(transStr,"^",3)    ;end date
			..q:(preBedId="")
			..i preBedId=bedId s findFlag="Y",fromDate=$p(transStr,"^",1)
	*/
	s icuDays="",InWardDays="" ;入ICU天数，入科天数
	i fromDate'="" s InWardDays=date-fromDate+1 
	i IcuSDateTmp'="" s icuDays=date-IcuSDateTmp+1 //$h-fromDate
	b
	s ICUANormalStartDate=$zd($p($g(^DHCICUArrange(+icuaId)),"^",22),3)
	s ICUANormalStartTime=##class(web.DHCClinicCom).ConvertToTime($p($g(^DHCICUArrange(+icuaId)),"^",23),"")
	i ICUANormalStartDate="" s ICUANormalStartTime=""
	s inWardDT=..GetWardInDateTime("",icuaId,"",""," ")
	//s inWardDT=$p(inWardDT,"^",1)_" "_$p(inWardDT,"^",2)
	s icuaPatHeight=$p($g(^DHCICUArrange(+icuaId)),"^",24)
	s icuaPatWeight=$p($g(^DHCICUArrange(+icuaId)),"^",25)
	s icuaARF=$p($g(^DHCICUArrange(+icuaId)),"^",26)
	s icuaCHP=$p($g(^DHCICUArrange(+icuaId)),"^",27)
 	
 	s ICUAResidentCtcpDr=$p($g(^DHCICUArrange(+icuaId)),"^",28)
	s ICUAAttendingCtcpDr=$p($g(^DHCICUArrange(+icuaId)),"^",29)
	s ICUASurgeryType=$p($g(^DHCICUArrange(+icuaId)),"^",30)
	s ICUAInfectedSite=$p($g(^DHCICUArrange(+icuaId)),"^",31)
	s ICUAShockType=$p($g(^DHCICUArrange(+icuaId)),"^",32)
	s ICUAEyeOpeningCLCSODr=$p($g(^DHCICUArrange(+icuaId)),"^",33)
	s ICUAVerbalResponseCLCSODr=$p($g(^DHCICUArrange(+icuaId)),"^",34)
	s ICUAMotorResponseCLCSODr=$p($g(^DHCICUArrange(+icuaId)),"^",35)
	s ICUAGlascowPoint=$p($g(^DHCICUArrange(+icuaId)),"^",36)
	s ICUAAPSPoint=$p($g(^DHCICUArrange(+icuaId)),"^",37)
	s ICUAAgePoint=$p($g(^DHCICUArrange(+icuaId)),"^",38)
	s ICUACHPPoint=$p($g(^DHCICUArrange(+icuaId)),"^",39)
	s ICUAApacheIIPoint=$p($g(^DHCICUArrange(+icuaId)),"^",40)
	s ICUADiagnosticCatCLCSODr=$p($g(^DHCICUArrange(+icuaId)),"^",41)
	s ICUADeathProbability=$p($g(^DHCICUArrange(+icuaId)),"^",42)
	
	s ICUALeaveCondition=$p($g(^DHCICUArrange(+icuaId)),"^",43)

	s ICUALeaveDate=$zd($p($g(^DHCICUArrange(+icuaId)),"^",44),3)

	s ICUALeaveTime=$zt($p($g(^DHCICUArrange(+icuaId)),"^",45),2)
	
	;K ^LynTmp
	s retNurseStr=##class(web.DHCMainNurse).GetWardNurse(EpisodeID)
	s ICUAChargeNurseDr=$p($g(^DHCICUArrange(+icuaId)),"^",60) //责任护士 LYN 20150427
	i ICUAChargeNurseDr=""  d
	.i retNurseStr'="" d
	..s ctcpId=$P($G(retNurseStr),"^",4)
	..i ctcpId '="" s ICUAChargeNurseDr=$o(^SSU("SSUSR",0,"CTPCP",ctcpId,""))
	
	s ICUASupervisorNurseDr=$p($g(^DHCICUArrange(+icuaId)),"^",61) //主管护士 LYN 20150427
	i ICUASupervisorNurseDr="" d
	.i retNurseStr'=""  D
	..s ctcpId=$P($G(retNurseStr),"^",6)
	..i ctcpId '="" s ICUASupervisorNurseDr=$o(^SSU("SSUSR",0,"CTPCP",ctcpId,""))
	
	s ICUAHostpitalCode=$p($g(^DHCICUArrange(+icuaId)),"^",64)
	s ICUAResidence=$p($g(^DHCICUArrange(+icuaId)),"^",65)
	s ICUAIsEstimatedHeight=$p($g(^DHCICUArrange(+icuaId)),"^",66)
	s ICUAIsEstimatedWeight=$p($g(^DHCICUArrange(+icuaId)),"^",67)
	s ICUAPregnant=$p($g(^DHCICUArrange(+icuaId)),"^",68)
	s ICUAGestation=$p($g(^DHCICUArrange(+icuaId)),"^",69)
	s ICUADeliveryDate=$p($g(^DHCICUArrange(+icuaId)),"^",70)
	i ICUADeliveryDate'="" s ICUADeliveryDate=$zd(ICUADeliveryDate,3)
	s ICUAPreDayCPR=$p($g(^DHCICUArrange(+icuaId)),"^",72)
	s ICUASourceHospital=$p($g(^DHCICUArrange(+icuaId)),"^",73)
	s ICUASourceLocationType=$p($g(^DHCICUArrange(+icuaId)),"^",74)
	s ICUAPreHospitalAdmDate=$p($g(^DHCICUArrange(+icuaId)),"^",75)
	i ICUAPreHospitalAdmDate'="" s ICUAPreHospitalAdmDate=$zd(ICUAPreHospitalAdmDate,3)
	
	s ICUAMechanVentilationHour =$p($g(^DHCICUArrange(+icuaId)),"^",47) ;有创呼吸机（小时）	
	s ICUANoninvasVentilationHour  =$p($g(^DHCICUArrange(+icuaId)),"^",48) ;无创呼吸机（小时）
	s ICUACrrtHour   =$p($g(^DHCICUArrange(+icuaId)),"^",52) ;CRRT（小时）
	s ICUAArriveAssistance=$p($g(^DHCICUArrange(+icuaId)),"^",76) ;基础心肺疾病
	s ICUAVasoactiveDrugHour =$p($g(^DHCICUArrange(+icuaId)),"^",77) ;血管活性药（小时）
	s ICUAHavePronePositionDay  =$p($g(^DHCICUArrange(+icuaId)),"^",78) ;有俯卧位（天）
	s ICUAIsBrainstemDeath  =$p($g(^DHCICUArrange(+icuaId)),"^",79) ;是否脑死亡
	s ICUAIsOrganDonation  =$p($g(^DHCICUArrange(+icuaId)),"^",80) ;是否器官捐献
	s ICUALimitedTreatment  =$p($g(^DHCICUArrange(+icuaId)),"^",81) ;限制治疗
	s ICUANEHour=$p($g(^DHCICUArrange(+icuaId)),"^",82) 	;去甲肾上腺素（小时）
	S ICUAEpiHour=$p($g(^DHCICUArrange(+icuaId)),"^",83)	;肾上腺素（小时）
	S ICUADAHour=$p($g(^DHCICUArrange(+icuaId)),"^",84) 	;多巴胺（小时）
	S ICUADobuHour=$p($g(^DHCICUArrange(+icuaId)),"^",85) ;多巴酚丁胺（小时）
	s ICUASourceType=$p($g(^DHCICUArrange(+icuaId)),"^",86) ;收治类型
	
	///取得ICU_PATMaster数据
	s ICUAICUPMDr=$p($g(^DHCICUArrange(+icuaId)),"^",62)
	s ICUPMIsEstimatedBirthdate="",ICUPMEthnicity=""
	i ICUAICUPMDr'="" d  s ICUPMIsEstimatedBirthdate=$lg($g(^DHCICUPatMaster(ICUAICUPMDr)),4)
	i ICUAICUPMDr'="" d  s ICUPMEthnicity=$lg($g(^DHCICUPatMaster(ICUAICUPMDr)),7)
 	
 	s icuBedId=$p($g(^DHCICUArrange(+icuaId)),"^",4)
    s ICUWardID=$P($G(icuBedId),"||",1 ) ;add by lyn ICU病区ID
 	s ICULocID=$p($g(^DHCICUArrange(+icuaId)),"^",2) ;add by lyn ICU科室ID
 	s ICULinkLocId=""
 	i ICULocID'="" d
 		.s ICULinkLocId=ICULocID ;add by lyn ICU科室关联科室ID  
 		.i $p($g(^CTLOC(ICULocID)),"^",13)'="W" s ICULinkLocId=ICULinkLocId_"^"_##class(web.DHCClinicCom).GetLinkLocId(ICULocID)
 		.s ICULinkLocId=$tr(ICULinkLocId,"^","'")
 	
 	//该icuaId 对应的记录，能够再次进行监护 add by lyn 20170317
 	s ifOrder=..GetIfOrderStopInfo(+icuaId)
 	s ICUCanRestart=""
 	i +ifOrder'=0  s ICUCanRestart=0
 	i +ifOrder =0  s ICUCanRestart=1
 	
 	//CCQ20101108 添加手术名称、手术日期和病人体重信息//移到下一部分
 	s opaId=..GetPreviousOpaId(EpisodeID,date) //取最近一次手术
 	//s tempOpaId=0
 	//f  s opaId=$o(^DHCANOPArrange(0,"Adm",EpisodeID,opaId),-1) q:opaId=""  d
 	//.i tempOpaId<opaId s tempOpaId=opaId
 	//s opaId=tempOpaId
 	s anOpString=##class(web.DHCANCom).GetAnaInfo(opaId)
 	s operationName=""
 	s operationDate=""
 	s patientWeight=""
 	i anOpString'=""  d
 	.s patientInfo=$p($g(anOpString),"^",2)
 	.s patientWeight=$p($g(patientInfo),$c(3),2)
 	.s operationInfo=$p($g(anOpString),"^",3)
 	.s operationDate=$p($g(operationInfo),$c(3),16)
 	.i operationDate=""  d
 	..s operationInfo=$p($g(anOpString),"^",2)
 	..s operationDate=$p($g(operationInfo),$c(3),10)
 	.s operationNameInfo=$p($g(anOpString),"^",4)
 	.s operationName=$p($g(operationNameInfo),$c(3),4)
 	;b
 	s resStr=resStr_"^"_admDate_$c(3)_mrcidDesc_$c(3)_icuDays_$c(3)_EpisodeID_$c(3)_wardId_$c(3)_ICUANormalStartDate_$c(3)_ICUANormalStartTime_$c(3)_inWardDT_$c(3)_icuaId_$c(3)_icuaPatHeight
 	s resStr=resStr_$c(3)_icuaPatWeight_$c(3)_preCtlocDesc_$c(3)_preWardDesc_$c(3)_operationName_$c(3)_operationDate_$c(3)_patientWeight_$c(3)_icuaARF_$c(3)_icuaCHP_$c(3)_ICUAResidentCtcpDr_$c(3)_ICUAAttendingCtcpDr_$c(3)_ICUASurgeryType_$c(3)_ICUAInfectedSite_$c(3)_ICUAShockType _$c(3)_ICUAEyeOpeningCLCSODr_$c(3)_ICUAVerbalResponseCLCSODr_$c(3)_ICUAMotorResponseCLCSODr_$c(3)_ICUAGlascowPoint_$c(3)_ICUAAPSPoint_$c(3)_ICUAAgePoint_$c(3)_ICUACHPPoint_$c(3)_ICUAApacheIIPoint_$c(3)_ICUADiagnosticCatCLCSODr_$c(3)_ICUADeathProbability_$c(3)_ICUALeaveCondition_$c(3)_ICUALeaveDate_$c(3)_ICUALeaveTime
 	s resStr=resStr_$c(3)_ICUAChargeNurseDr_$c(3)_ICUASupervisorNurseDr_$c(3)_ICUAHostpitalCode_$c(3)_ICUAResidence_$c(3)_ICUAIsEstimatedHeight_$c(3)_ICUAIsEstimatedWeight_$c(3)_ICUAPregnant
	s resStr=resStr_$c(3)_ICUAGestation_$c(3)_ICUADeliveryDate_$c(3)_ICUAPreDayCPR_$c(3)_ICUASourceHospital_$c(3)_ICUASourceLocationType_$c(3)_ICUAPreHospitalAdmDate_$c(3)_ICUPMIsEstimatedBirthdate_$c(3)_ICUPMEthnicity //LYN 20150427 	
	s resStr=resStr_$c(3)_ICUAArriveAssistance_$c(3)_ICUANoninvasVentilationHour_$c(3)_ICUAMechanVentilationHour_$c(3)_ICUACrrtHour_$c(3)_ICUAVasoactiveDrugHour_$c(3)_ICUAHavePronePositionDay_$c(3)_ICUAIsBrainstemDeath_$c(3)_ICUAIsOrganDonation_$c(3)_ICUALimitedTreatment
	s resStr=resStr_$c(3)_ICUANEHour_$c(3)_ICUAEpiHour_$c(3)_ICUADAHour_$c(3)_ICUADobuHour_$c(3)_ICUASourceType_$c(3)_ICUWardID_$c(3)_ICULocID_$c(3)_ICULinkLocId_$c(3)_InWardDays_$c(3)_ICUCanRestart
	
 	;s resStr=resStr_$c(3)_ICUAResidentCtcpDr_$c(3)_ICUAAttendingCtcpDr_$c(3)_ICUASurgeryType_$c(3)_ICUAInfectedSite_$c(3)_ICUAShockType _$c(3)_ICUAEyeOpeningCLCSODr_$c(3)_ICUAVerbalResponseCLCSODr_$c(3)_ICUAMotorResponseCLCSODr_$c(3)_ICUAGlascowPoint_$c(3)_ICUAAPSPoint_$c(3)_ICUACHPPoint_$c(3)_ICUAApacheIIPoint_$c(3)_ICUADiagnosticCatCLCSODr_$c(3)_ICUADeathProbability
 	//start CCQ20101008 添加湘雅医院HIS信息，病人ID和住院次数
    s oaRowId=$o(^DHCENSOA("0","Paadm",+EpisodeID,""))
    s otherHisPatientId=$p($g(^DHCENSOA(+oaRowId)),"^",4)
    s otherHisVisitId=$p($g(^DHCENSOA(+oaRowId)),"^",5)
    s resStr=resStr_"^"_otherHisPatientId_$c(3)_otherHisVisitId //end CCQ
    
 	s icuaniSub=0,icuaniStr=""
 	f  s icuaniSub=$o(^DHCICUArrange(+icuaId,"AN",icuaniSub)) q:(icuaniSub="")!(icuaniStr'="")  d
 		.i date'="",date=$p(^DHCICUArrange(icuaId,"AN",icuaniSub),"^",1) d
 			..s icuaniStr=^DHCICUArrange(icuaId,"AN",icuaniSub)
 	i icuaniStr'="" d
 		.i $p(icuaniStr,"^",1)'="" d
 			..s $p(icuaniStr,"^",1)=$zd($p(icuaniStr,"^",1),3)	//ICUANI_Date
 			..s $p(icuaniStr,"^",2)=##class(web.DHCClinicCom).ConvertToTime($p(icuaniStr,"^",2),"")	//ICUANI_Time
 			..i $p(icuaniStr,"^",1)="" s $p(icuaniStr,"^",2)=""
 			..s $p(icuaniStr,"^",3)=opaId
 			..s anMethodDesc=##class(web.DHCClinicCom).GetAnMethodDescById($p(icuaniStr,"^",4),"|")
 			..s $p(icuaniStr,"^",4)=$p(icuaniStr,"^",4)_$c(4)_anMethodDesc	//ICUANI_AnMethod_Dr
 			..s operDesc=##class(web.DHCClinicCom).GetOperationDescById($p(icuaniStr,"^",5),"|","+")
 			..i operDesc="" s $p(icuaniStr,"^",5)=$c(4)_$p(icuaniStr,"^",5) //自定义手术名称
 			..e  s $p(icuaniStr,"^",5)=$p(icuaniStr,"^",5)_$c(4)_operDesc
 			..s $p(icuaniStr,"^",7)=+$p(icuaniStr,"^",7)
 			..s $p(icuaniStr,"^",8)=+$p(icuaniStr,"^",8)
 			..s $p(icuaniStr,"^",9)=+$p(icuaniStr,"^",9)
 			..s $p(icuaniStr,"^",10)=+$p(icuaniStr,"^",10)
 			..s icuaniReturnPositionDesc=$P($G(^ORC("OPPOS",+$p(icuaniStr,"^",11))),"^",2)
 			..s $p(icuaniStr,"^",11)=$p(icuaniStr,"^",11)_$c(4)_icuaniReturnPositionDesc
 			..s $p(icuaniStr,"^",13)=$zd($p(icuaniStr,"^",13),3)
 			..s $p(icuaniStr,"^",14)=##class(web.DHCClinicCom).ConvertToTime($p(icuaniStr,"^",14),"")
 			..i $p(icuaniStr,"^",13)="" s $p(icuaniStr,"^",14)=""
 	s $p(icuaniStr,"^",15)=$p(icuaniStr,"^",15)
 	s icuaniStr=$tr(icuaniStr,"^",$c(3))
	s resStr=resStr_"^"_icuaniStr //
	s icuaType=$p($g(^DHCICUArrange(+icuaId)),"^",5)
	s resStr=resStr_"^"_icuaType //
	q resStr
}

/// Creator：		LYN
/// CreatDate：		2017-03-16
/// Descripation：	当前是否有未停止的特级护理的医嘱,或已经停止四小时之内的特护医嘱
/// Input: 			EpisodeID-就诊号;ArcimCodes-特级护理医嘱Code; icuaId-重症监护ID
/// Output: 		医嘱停止且停止时间超过四个小时返回 "0" ; 若未停止返回 "1" 
/// w ##class(web.DHCICUCom).IfNotStopOrder(18206619,"N0307","")
ClassMethod IfNotStopOrder(EpisodeID As %String, ArcimCode As %String, icuaId As %String) As %String
{
	q:(ArcimCode="")!(icuaId="") 0
	i EpisodeID="",icuaId'="" s EpisodeID=$p(^DHCICUArrange(+icuaId),"^",1)
	s rowidm=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ArcimCode),""))
	q:rowidm="" 0
	
	s ret=0,isFind=0,icuSDT="",icuLeaveDT="",icuStatus="",icuWardLocId=""
	//icua记录不为空时
	s icuSDT=$p(^DHCICUArrange(+icuaId),"^",6)+(($p(^DHCICUArrange(+icuaId),"^",8)+1)/100000) //入ICU时间
	//i icuaId'="" s icuLeaveDT=$p($g(^DHCICUArrange(+icuaId)),"^",44)+(($p($g(^DHCICUArrange(+icuaId)),"^",45)+1)/100000)
	//i icuaId'="" s icuStatus=$p(^DHCICUArrange(+icuaId),"^",18)
	s wardId=+$p($g(^DHCICUArrange(icuaId)),"^",4) 	//ICU床位ID
	s icuWardLocId=$p($g(^PAWARD(+wardId)),"^",5) 	//病区科室ID 
	s locIdStr=##class(web.DHCClinicCom).GetLinkLocId(icuWardLocId)
	s locIdStr=locIdStr_"^"_icuWardLocId

	s arcimId=rowidm_"||"_"1"
	S oeordId=$o(^OEORD(0,"Adm",EpisodeID,"")),oeoriSttDate=""
	f  s oeoriSttDate=$o(^OEORDi(0,"ARCIM",oeordId,arcimId,oeoriSttDate),-1) q:(oeoriSttDate="")!(isFind)!(ret)  d
		.s oeoriSub=""
		.f  s oeoriSub=$o(^OEORDi(0,"ARCIM",oeordId,arcimId,oeoriSttDate,oeoriSub),-1) q:(oeoriSub="")!(isFind)!(ret)  d
			..;w oeoriSttDate_"/"_oeoriSub_"/"_oeordId_"/"_arcimId,!
			..s ordLocId=$p($g(^OEORD(oeordId,"I",oeoriSub,7)),"^",2)
			..q:(ordLocId'="")&(("^"_locIdStr_"^")'[("^"_ordLocId_"^"))  //当前医嘱不是本病区的医嘱，退出
			..s oecprId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",8)								
			..i oecprId>0 s oecprCode=$p($g(^OECPR(+oecprId)),"^",1) 
			..i (oecprCode="S")!(oecprCode="OMST")!(oecprCode="OMCQZT") s oecprType="Y" //长期医嘱
			..;w oecprCode,!
			..s ordStatCode=##Class(web.DHCClinicCom).GetOrdStatCode(oeordId_"||"_oeoriSub)								
			..q:("DIU"[ordStatCode)&&(oecprType'="Y")
			..q:("IU"[ordStatCode)&&(oecprType="Y")
			..;w ordStatCode,!
			..s oeoriXDate=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",34)
			..;w oeoriXDate_"/"_ordLocId,!
			..s ret=1
			..i oeoriXDate'="" d
				...s oeoriXTime=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",15)
	    		...s oeoriXDateTime=oeoriXDate+(oeoriXTime/100000)
	    		...s nowDT=$TR($h,",",".")
	    		...;w nowDT_"/"_oeoriXDateTime,!
	    		...i (nowDT-oeoriXDateTime)*100000>(4*3600) s isFind=1
	    	..;w isFind,!
	    	..s oeoriFillerNo=$p($g(^OEORD(oeordId,"I",oeoriSub,9)),"^",12)
    		..s firstOeoriId=$p(oeoriFillerNo,"!!",1)
			..s firstOeoriSub=oeoriSub //首条医嘱对应的子ID
			..i oeoriFillerNo'="" d  s firstOeoriSub=$p(firstOeoriId,"||",2)
			..// 首条开医嘱时间
			..s oeoriSttDat=$p($g(^OEORD(oeordId,"I",firstOeoriSub,1)),"^",9)
			..s oeoriSttTim=$p($g(^OEORD(oeordId,"I",firstOeoriSub,1)),"^",10)
			..s oeoriSttDateTime=oeoriSttDat+(oeoriSttTim/100000)
			..i (icuSDT'="")&(icuSDT<oeoriSttDateTime)  s isFind=1
    q:isFind=1 0
    q 1
}

/// Creator：		LYN
/// CreatDate：		2017-03-16
/// Description: 	判断当前icuaId 对应的特级护理医嘱是否合法
/// input：			icuaId-重症程序rowid
/// Output：			合法返回0，不合法返回字符串
ClassMethod GetIfOrderStopInfo(icuaId) As %String
{
	s icuaStatus=$p($g(^DHCICUArrange(icuaId)),"^",18) //调整后会变
	S EpisodeID=+$g(^DHCICUArrange(icuaId))
	s isOrdLoc=##class(web.DHCICUCom).IsCriticalCare("",icuaId)
	q:(isOrdLoc'=1) 0
	s isHaveOrder=..IfNotStopOrder(EpisodeID,"AC0004",icuaId)
	q:icuaStatus="D" 
	q:(icuaStatus="M")&(isHaveOrder=0) "-1^当前患者的此记录对应的“特级护理”医嘱已经停止，时间已超过四小时，请结束监护"
	q:("R"[icuaStatus)&(isHaveOrder=0) "-2^当前患者的“特级护理”医嘱已经停止，且时间已超过四小时，不能进行监护"
	q:("T"[icuaStatus)&(isHaveOrder=0) "-3^当前患者已经转归，且“特级护理”医嘱停止已超过四小时，不能再填写数据"
	q 0
}

/// creator:lyn
/// creatDate:20161019
/// 已经填写转归信息的在床病人，再次进入系统时，需要再监护室时，进行清空转归信息
ClassMethod SetNullICULeaveInfo(icuaId)
{
	s retStr=0
	&sql(update DHC_ICU_Arrange set ICUA_LeaveCondition=:null,ICUA_LeaveDate=:null,ICUA_LeaveTime=:null where ICUA_RowId=:icuaId)
	i SQLCODE s retStr="修改转归时间错！SQLCODE="_SQLCODE
	s ^DHCANICUDEBUG("RestartLog",+icuaId,+$h,$p($h,",",2))="SetNullLeaveInfo/"_retStr
	q retStr
}

ClassMethod IsCriticalCare(ctlocId As %String, icuaId As %String) As %String
{
	q:(ctlocId="")&&(icuaId="") 0
	s OrderLocIdInfo=$g(^DHCCLSet("ICU","OrderType")) //按照医嘱（特级护理）获取病人的科室
	s arcimCode=$p(OrderLocIdInfo,"^",1)
	s orderLocIDStr=$p(OrderLocIdInfo,"^",2)
	i ctlocId="",icuaId'="" d
	.s wardId=+$p($g(^DHCICUArrange(icuaId)),"^",4)
	.s ctlocId=$p($g(^PAWARD(+wardId)),"^",5)
	q:(","_orderLocIDStr_",")[(","_ctlocId_",") 1
	q 0
}

// 根据就诊号、日期，取小于等于日期(之前)的一个手术排班ID,重症用

ClassMethod GetPreviousOpaId(EpisodeID, date = "") As %String
{
	s date=##class(web.DHCClinicCom).ConvertToDateH(date)
 	s opaId=""
 	s preOpaId=0,isFind="N"
 	f  s opaId=$o(^DHCANOPArrange(0,"Adm",EpisodeID,opaId),-1) q:(opaId="")!(isFind="Y")  d
 		.q:'$d(^DHCANOPArrange(opaId))
 		.s opaStatus=$p($g(^DHCANOPArrange(opaId)),"^",27)
 		.q:(opaStatus="")!("AD"[opaStatus)
 		.s anaId=$p(^DHCANOPArrange(opaId),"^",2)
 		.s opaStartDate="" //$p(^OR(+anaId,"ANA",$p(anaId,"||",2)),"^",39)
 		.i opaStartDate="" s opaStartDate=$p($g(^DHCANOPArrange(+opaId)),"^",14)
 		.q:(date'="")&(opaStartDate>date)
 		.s preOpaId=opaId
 		.s isFind="Y"
	q preOpaId
}

/// 设置icuaId麻醉信息icuaniStr
/// icuaniStr:日期date_$c(3)_时间time_$c(3)_手术排班ID_$c(3)_用|分割的麻醉方法ID
/// 			_$c(3)_用|分割的手术ID_$c(3)_镇痛方式_$c(3)_失血量_$c(3)_尿量_$c(3)_输液量_$c(3)_输血量
/// 			_$c(3)_回室意识_$c(3)_回室体位ID_$c(3)_回室日期_$c(3)_回室时间_$c(3)_备注
ClassMethod SetIcuaInfo(icuaId, icuaniStr) As %String
{
	q:icuaId="" "重症监护ID有误!"
	q:'$d(^DHCICUArrange(icuaId)) "重症监护数据有误!"
	i $p(icuaniStr,"^",1)="" q "数据有误!"
	s $p(icuaniStr,"^",1)=##class(web.DHCClinicCom).ConvertToDateH($p(icuaniStr,"^",1),"")
	s $p(icuaniStr,"^",2)=##class(web.DHCClinicCom).ConvertToTimeH($p(icuaniStr,"^",2),"")
	i $p(icuaniStr,"^",1)="" s $p(icuaniStr,"^",2)=""
	s $p(icuaniStr,"^",13)=##class(web.DHCClinicCom).ConvertToDateH($p(icuaniStr,"^",13),"")
	s $p(icuaniStr,"^",14)=##class(web.DHCClinicCom).ConvertToTimeH($p(icuaniStr,"^",14),"")
	i $p(icuaniStr,"^",13)="" s $p(icuaniStr,"^",14)=""
	
	s date=$p(icuaniStr,"^",1)
 	s icuaniSub=0,curIcuaniSub=""
 	f  s icuaniSub=$o(^DHCICUArrange(icuaId,"AN",icuaniSub)) q:(icuaniSub="")!(curIcuaniSub'="")  d
 		.i date'="",date=$p(^DHCICUArrange(icuaId,"AN",icuaniSub),"^",1) d
 			..s curIcuaniSub=icuaniSub
	i curIcuaniSub'="" d
		.s ^DHCICUArrange(icuaId,"AN",curIcuaniSub)=icuaniStr
	e  d
		.s ^DHCICUArrange(icuaId,"AN",0)=$g(^DHCICUArrange(icuaId,"AN",0))+1
		.s ^DHCICUArrange(icuaId,"AN",^DHCICUArrange(icuaId,"AN",0))=icuaniStr
	q 0
}

ClassMethod GetIcupId(icuaId, ctlocId = "")
{
	q:(+icuaId=0) 0
	s icupId=$o(^DHCICUPara(0,icuaId,""))
	i icupId'="" q icupId
	i ctlocId="" s ctlocId="Default"
	
	i $d(^DHCICUC("Para","Default"))<10 q ""
	s ^DHCICUPara(0)=$g(^DHCICUPara(0))+1
	s ^DHCICUPara(0,icuaId,^DHCICUPara(0))=""
	i $d(^DHCICUC("Para",ctlocId))<1 m ^DHCICUC("Para",ctlocId)=^DHCICUC("Para","Default")
	m ^DHCICUPara(^DHCICUPara(0))=^DHCICUC("Para",ctlocId)
	s $p(^DHCICUPara(^DHCICUPara(0)),"^",1)=icuaId  //ypz end
	s icupId=^DHCICUPara(0)
	q icupId
}

ClassMethod GetPreDrug(icuaId, fDate, tDate = "") As %String
{
	
	q 0
}

// 该程序不用，使用DHCANCom中的方法，可区分重症和麻醉分类

ClassMethod GetAncViewCat(type = "", needAncvcId = "") As %String
{
	//type:V生命体征,O医嘱,E事件
	s typePos=0
	i type="V" s typePos=3
	i type="D" s typePos=4
	i type="E" s typePos=5
	i type="VPS" s typePos=6
	s isVPSite=""
	i needAncvcId'="" s isVPSite=$p($g(^DHCICUC("ViewCat",needAncvcId)),"^",6)
	s resStr=""
	s ancvcId=0
	f  s ancvcId=$o(^DHCICUC("ViewCat",ancvcId)) q:ancvcId=""  d
	    .q:(isVPSite'="Y")&(needAncvcId'="")&(needAncvcId'=ancvcId)
	    .s ancvcStr=^DHCICUC("ViewCat",ancvcId)
	    .q:(isVPSite="Y")&($p($g(^DHCICUC("ViewCat",ancvcId)),"^",6)'="Y")
	    .i typePos>0,$p(ancvcStr,"^",typePos)'="Y" q
	    .//s $p(ancvcStr,"^",6)=$p($g(^DHCANC("VPSite",+$p(ancvcStr,"^",6))),"^",2)
	    .i $l(ancvcStr,"^")<14 s $p(ancvcStr,"^",14)="" //旧的
	    .s ancvcStr=$tr(ancvcStr,"^","!")
	    .i resStr'="" s resStr=resStr_"^"
	    .s resStr=resStr_ancvcId_"!"_ancvcStr
	q resStr
}

ClassMethod GetAncVenipuncSite() As %String
{
	s resStr=""
	s ancvpsId=0
	f  s ancvpsId=$o(^DHCANC("VPSite",ancvpsId)) q:ancvpsId=""  d
	    .s ancvpsStr=^DHCANC("VPSite",ancvpsId)
	    .s ancvpsStr=$tr(ancvpsStr,"^","!")
	    .i resStr'="" s resStr=resStr_"^"
	    .s resStr=resStr_ancvpsId_"!"_ancvpsStr
	q resStr
}

ClassMethod GetMasterItem(arcicId As %String, arcimDesc As %String) As %Status
{
    i (arcimDesc'="") s arcimDesc=$$ALPHAUP^SSUTIL4(arcimDesc)
 	s arcimSub=0 
 	f  s arcimSub=$o(^ARCIM(arcimSub)) q:arcimSub=""  d
	.s arcimVer=0 f  s arcimVer=$o(^ARCIM(arcimSub,arcimVer)) q:arcimVer=""  d
	..s arcimId=arcimSub_"||"_arcimVer
	..s aliasId=$O(^ARC("ALIAS",0,"ARCIM",arcimId,""))
	..q:aliasId=""
	..s aliasDesc=$$ALPHAUP^SSUTIL4($p(^ARC("ALIAS",aliasId),"^",6))
	..s arcimDesc=$p(^ARCIM(arcimSub,arcimVer,1),"^",2)
	..s arcimDesc=aliasDesc_"-"_arcimDesc
	..q:arcimDesc'[arcimDesc
	..//q:$p(arcimDesc,arcimDesc,1)'=""
	..s itemcatDR=$p(^ARCIM(arcimSub,arcimVer,1),"^",10)
	..i arcicId=itemcatDR d
	..
	quit
}

ClassMethod GetOrderInfo() As %String
{
	s resStr=""
	q resStr
}

ClassMethod GetArcimDesc(arcimId = "") As %String
{
	q:arcimId="" ""
	s arcimDesc=""
	s arcimDesc=$p(^ARCIM(+arcimId,+$p(arcimId,"||",2),1),"^",2)
	q arcimDesc
}

ClassMethod GetPostOpCond(icuaId) As %String
{
	q 0
}

ClassMethod SetPostOpCond(icuaId, paraStr) As %String
{
	q 0
}

ClassMethod GetAncByNode(node) As %String
{
	s resStr="",id=0
	f  s id=$o(^DHCANC(node,id)) q:id=""  d
	    .s desc=$p(^DHCANC(node,id),"^",2)
	    .i "^VSCat^"[("^"_node_"^") s desc=$p(desc,"[")
	    .i resStr'="" s resStr=resStr_"^"
	    .s resStr=resStr_id_$c(3)_desc
	q resStr
}

ClassMethod GetAncCodeDescByNode(node) As %String
{
	s resStr="",id=0
	f  s id=$o(^DHCANC(node,id)) q:id=""  d
	    .s desc=$p(^DHCANC(node,id),"^",2)
	    .i "^VSCat^"[("^"_node_"^") s desc=$p(desc,"[")
	    .i resStr'="" s resStr=resStr_"^"
	    .s resStr=resStr_id_$c(3)_$p(^DHCANC(node,id),"^",1)_$c(3)_desc
	q resStr
}

ClassMethod GetIcucByNode(node) As %String
{
	s resStr="",id=0
	f  s id=$o(^DHCICUC(node,id)) q:id=""  d
	    .i resStr'="" s resStr=resStr_"^"
	    .s resStr=resStr_id_$c(3)_$p(^DHCICUC(node,id),"^",2)
	q resStr
}

ClassMethod GetOrcByNode(node) As %String
{
	q:node="" ""
	s resStr="",id=0
	f  s id=$o(^ORC(node,id)) q:id=""  d
	    .i resStr'="" s resStr=resStr_"^"
	    .s resStr=resStr_id_$c(3)_$p(^ORC(node,id),"^",2)
	q resStr
}

ClassMethod GetLocCtcp(icuaId, anNode) As %String
{
	//node="anloc","oploc"
	s locIdStr=""
	s EpisodeID=$p(^DHCICUArrange(+icuaId),"^",1)
	s locIdStr=$p($g(^PAADM(EpisodeID)),"^",4)
	q:locIdStr="" ""
	s wardId=$p($g(^PAADM(EpisodeID)),"^",70)
	s wardLocId=$p(^PAWARD(+wardId),"^",5)
	i wardLocId'="" s locIdStr=locIdStr_"^"_wardLocId
	s num=$l(locIdStr,"^")
	
	s resStr=""
	f i=1:1:num d
	   .s str=$P(locIdStr,"^",i)
	   .s locId=$P(str,"|")
	   .s resId="" f  s resId=$O(^RB("RES",0,"CTLOC",locId,resId)) q:resId=""  d
	       ..s ctcpId=$P(^RB("RES",resId),"^",2)
	       ..q:ctcpId=""
	       ..s ctcpDesc=$p(^CTPCP(ctcpId,1),"^",2)
	       ..i resStr'="" s resStr=resStr_"^"
	       ..s resStr=resStr_ctcpId_$c(3)_ctcpDesc
	 q resStr
}

ClassMethod GetDiag(mrcidStr)
{
	k ^TMPICU("Com",$i)
    s i=0
	s mrcidStr=$$ALPHAUP^SSUTIL4(mrcidStr)  //ypz 070313 $ZCONVERT(mrcidStr,"U")
    q:mrcidStr="" 0
	if mrcidStr'=""
	{
		s flag="N"
		s aliasTextAlphaUp=$O(^MRC("ID",0,"ALIAS",mrcidStr),-1) //ypz 070313 保证找到当前串
    	f  s aliasTextAlphaUp=$O(^MRC("ID",0,"ALIAS",aliasTextAlphaUp)) q:(aliasTextAlphaUp="")!(flag="Y")  d
    		.i $p(aliasTextAlphaUp,mrcidStr)'="" s flag="Y" q
    		.//i $e(aliasTextAlphaUp,1,$L(mrcidStr))'=mrcidStr s flag="Y" q
    		.s mrcidId=""
    		.f  s mrcidId=$O(^MRC("ID",0,"ALIAS",aliasTextAlphaUp,mrcidId)) q:(mrcidId="")  d
    			..s mrcidDesc=$p(^MRC("ID",mrcidId),"^",2)
    			..s ^TMPICU("Com",$i,i)=mrcidId_"^"_mrcidDesc
    			..//w ^TMPICU("Com",$i,i)_".",!
    			..s i=i+1
	}
	i i>0 q i
	s mrcidId=0
	f  s mrcidId=$o(^MRC("ID",mrcidId)) q:mrcidId=""  d
	    .s mrcidDesc=$p(^MRC("ID",mrcidId),"^",2)
	    .//s LinkStr=$ZCONVERT(mrcidStr,"U")
	    .i $$ALPHAUP^SSUTIL4(mrcidDesc)[mrcidStr  do
    		..s ^TMPICU("Com",$i,i)=mrcidId_"^"_mrcidDesc
    		..//w ^TMPICU("Com",$i,i)
    		..s i=i+1
    q i
}

ClassMethod GetOperation(operStr)
{
	k ^TMPICU("Com",$i)
	s i=0   //ypz 060811
	//^ORC("OPER",0,"ALIAS",$$ALPHAUP({ALIAS_Text}),{ORC_Operation.OPER_RowId},{ALIAS_Childsub})
	s operStr=$$ALPHAUP^SSUTIL4(operStr) //$ZCONVERT(operStr,"U")  ypz 070313
    q:operStr="" 0
    if (operStr'="")
    {
	s flag="N"
	s OpDes=$O(^ORC("OPER",0,"ALIAS",operStr),-1)  //ypz 070313 open
    f  s OpDes=$O(^ORC("OPER",0,"ALIAS",OpDes)) q:(OpDes="")!(flag="Y")  d
    	.i $p(OpDes,operStr)'="" s flag="Y" q
    	.s operId=""
    	.f  s operId=$O(^ORC("OPER",0,"ALIAS",OpDes,operId)) q:operId=""  d  //ypz 070313 
    		..s operDesc=$p(^ORC("OPER",operId),"^",2)
    		..s ^TMPICU("Com",$i,i)=operId_"^"_operDesc
    		..//w ^TMPICU("Com",$i,i)
    		..s i=i+1
    }
    if i>0 q i
  	s operId=0
	f  s operId=$o(^ORC("OPER",operId)) q:operId=""  d
		.s operDesc=$p(^ORC("OPER",operId),"^",2)
		.q:$$ALPHAUP^SSUTIL4(operDesc)'[operStr //q:$$UPPER^SSUTIL4(operDesc)'[operStr
    	.s ^TMPICU("Com",$i,i)=operId_"^"_operDesc
    	.//w ^TMPICU("Com",$i,i)
    	.s i=i+1
 	q i
}

ClassMethod SetEventAttDateTime(icuaId, icuoId, icucoId, dateStr, timeStr) As %String
{
	q 0
}

/// w ##class(web.DHCICUCom).GetEditStat(23)
ClassMethod GetEditStat(icuaId) As %String
{
	q:(+icuaId=0) "noIcuaId^无病人监护号!"
	s icuaStatus=$p($g(^DHCICUArrange(icuaId)),"^",18)
	q:icuaStatus="" "noIcuaStat^无监护状态!"
	q:icuaStatus="A" "appIcua^不能对监护状态为申请的病人操作!"
	q:icuaStatus="D" "declineIcua^不能对监护状态为拒绝的病人操作!"
	q:icuaStatus="N" "unAppointIcua^不能对监护状态为非预约的病人操作!"
	s EpisodeID=$p(^DHCICUArrange(+icuaId),"^",1)
	q:(+EpisodeID=0) "noEpisodeIDId^无病人就诊号!"
	
	s retStr=..ReviseArrangeBedEquip(icuaId)
	q:retStr'=0 "errorRevise:"_retStr
	
	s icuaStatus=$p($g(^DHCICUArrange(icuaId)),"^",18) //调整后会变
	s wardId=$p($g(^PAADM(EpisodeID)),"^",70)
	s bedId=$p($g(^PAADM(EpisodeID)),"^",73)
	s icuBedId=$p(^DHCICUArrange(icuaId),"^",4)
	//i (wardId'=+icuBedId)!(bedId="") s bedId=icuBedId //转科或等待区
	q:(wardId'=+icuBedId)!(bedId="") "CanRead^"
	q:bedId="" "noIcuaBed^无病人监护床位!"
	s bedSub=$p(bedId,"||",2)
	s bedTpId=$p($g(^PAWARD(+bedId,"BED",+bedSub)),"^",2)
	s icuBed=$p($g(^PAC("BEDTP",+bedTpId)),"^",5)
	
	s icuBedTpId=$p($g(^PAWARD(+icuBedId,"BED",+$p(icuBedId,"||",2))),"^",2)
	s icuMonBed=$p($g(^PAC("BEDTP",+icuBedTpId)),"^",5)
	q:(icuBed'="Y")&(icuMonBed'="Y") "notIcuBed^非重症监护床!"
	i (wardId=+icuBedId)&(bedId'=icuBedId)&(icuBed'="Y")&(icuMonBed="Y") s bedId=icuBedId //转到普通床
	q:icuaStatus="F" "CanRead^"
	q:("RMT"'[icuaStatus) "errIcuaStat^监护状态不对!"
	s icubeId="",retStr="CanStart^"
	b
	/* 
	采集设备表已改为DHC_ICU_Device表
	f  s icubeId=$o(^DHCICUBedEquip(0,"Bed",bedId,icubeId)) q:icubeId=""  d
		.s icubeEditTcpipAddress=$p($g(^DHCICUBedEquip(icubeId)),"^",7)
		.q:icubeEditTcpipAddress=""
		.//s ^tmpYpz("ip")=$zu(67,15,$j)
		.//i (remoteAddr="")&(icubeEditTcpipAddress[$zu(67,15,$j)) s retStr="CanStart^"
		.//i (remoteAddr'="")&(icubeEditTcpipAddress[remoteAddr) s retStr="CanStart^"
		.s retStr="CanStart^"
	
	q:retStr'["CanStart^" retStr
	*/
	q:(wardId=+icuBedId)&(bedId'=icuBedId)&(icuBed'="Y")&(icuMonBed="Y") "CanEdit^"
	s admVisitStatus=$p($g(^PAADM(EpisodeID)),"^",20)
	//130306//q:wardId'=+bedId "CanEdit^"
	////q:(wardId'=+bedId)&(icuaStatus="T") "CanEdit^"
	q:(admVisitStatus="D")&(icuaStatus="R") "CanRead^"
	q:(admVisitStatus="D")&(icuaStatus="M") "CanRead^"
	q:(admVisitStatus="D")&(icuaStatus="T") "CanEdit^"
	i $d(^DHCICUArrange(0,"BedStatus",bedId,"M"))>0 d
		.i icuaStatus="T" s retStr="CanEdit^" q //术后进入时，已有新监护，只能手工修改
		.s monIcuaId=$o(^DHCICUArrange(0,"BedStatus",bedId,"M",""))
		.i monIcuaId=icuaId,retStr="CanStart^" s retStr="CanStop^"
		.i monIcuaId'=icuaId,retStr="CanStart^" d
			..s tmpRetStr=..AutoTerminal(monIcuaId, bedId)
			..i tmpRetStr'=0 s retStr=tmpRetStr
	q:retStr'["CanStart^" retStr
	i (icuaStatus="T")&(retStr["CanStart^") s retStr="CanRestart^"
	i $d(^DHCICUArrange(0,"BedStatus",bedId,"M"))>0 q retStr
	i $d(^DHCICUArrange(0,"BedStatus",bedId,"T"))>0 q retStr
	i $d(^DHCICUArrange(0,"BedStatus",bedId,"R",icuaId))>0 q retStr
	q retStr
	q "CanRead^"
}

/// 调整当前病区的全部监护：
/// 转病区(一次转病区只有一次ICU安排)，同病区到等待区、到非监护床，停止病人采集数据，调整前一次监护为结束。
/// 启动本病区设备。
ClassMethod ReviseArrangeBedEquip(icuaId, EpisodeID = "", wardId = "") As %String
{
	q:(icuaId="")&(EpisodeID="")&(wardId="") 0
	s retStr=0
	i wardId="" d
		.i EpisodeID="" s EpisodeID=$p(^DHCICUArrange(+icuaId),"^",1)
		.s wardId=$p($g(^PAADM(+EpisodeID)),"^",70)	
	q:wardId="" retStr //无病人病区
	
	s bedSub=0,startIcuaIdStr=""
	f  s bedSub=$o(^PAWARD(wardId,"BED",bedSub)) q:(bedSub="")!(retStr'=0)  d
		.s wardDesc=$p(^PAWARD(wardId),"^",2)
		.s bedId=wardId_"||"_bedSub
		.s bedCode=$p(^PAWARD(+bedId,"BED",bedSub),"^",1)
		.//w "all:"_bedId_"/"_bedCode,!
		.s bedAdmSub=0,bedEpisodeID=""
		.f  s bedAdmSub=$o(^PAWARDA(+bedId,"BED",bedSub,"ADM",bedAdmSub)) q:bedAdmSub=""  d
			..s bedEpisodeID=$p(^PAWARDA(+bedId,"BED",bedSub,"ADM",bedAdmSub),"^")
			..i $o(^PAWARDA(+bedId,"BED",bedSub,"ADM",bedAdmSub))'="" s retStr=wardDesc_bedCode_"("_bedId_")床位与病人关联错!" q
		.q:retStr'=0
		.//清理床位上监护
		.s monIcuaId=""
		.f  s monIcuaId=$o(^DHCICUArrange(0,"BedStatus",bedId,"M",monIcuaId)) q:monIcuaId=""  d
			..q:'$d(^DHCICUArrange(monIcuaId))
			..s monEpisodeID=$p(^DHCICUArrange(+monIcuaId),"^",1)
			..q:'$d(^PAADM(monEpisodeID))
			..q:(bedEpisodeID=monEpisodeID)
			..s retStr=..StopEquipCollect(monIcuaId)
			..s monAdmVisitStatus=$p($g(^PAADM(monEpisodeID)),"^",20)
			..s monWardId=$p($g(^PAADM(monEpisodeID)),"^",70)
			..s monBedId=$p($g(^PAADM(monEpisodeID)),"^",73)
			..s monIcuaStatus=$p($g(^DHCICUArrange(monIcuaId)),"^",18)
			..s monIcuBedId=$p($g(^DHCICUArrange(monIcuaId)),"^",4)
			..//w "status:"_monAdmVisitStatus_"/"_monWardId_"/"_monBedId,!
			..i (monAdmVisitStatus="D")!(monWardId'=wardId) d 	//出院或转病区
				...s monBedIcuaId=..GetIcuaId(monEpisodeID,"","") //判断跨病区提前转
				...q:(monAdmVisitStatus'="D")&(monIcuaId=monBedIcuaId)
				...//w monIcuaId_"出院或转病区",! //
				...&sql(update DHC_ICU_Arrange set ICUA_Status='T' where ICUA_RowId=:monIcuaId)
				...i retStr=0,SQLCODE'=0 s retStr="修改监护安排表状态错误!"
			..e  d 		//同病区，床位错，前一监护没停，可能转回的
				...i monBedId="" s monBedId=bedId //保证转到等待区时，有值
				...e  d
					....s monBedIcuaId=..GetIcuaId(monEpisodeID,"","") //返回单条，不创建新监护,有可能跨过病区
					....//w monIcuaId_"/"_monBedIcuaId_"同病区，床位错，前一监护没停",!
					....i monIcuaId'=monBedIcuaId s monBedId=bedId q //同人，跨病区又回的不重启
					....q:("^"_startIcuaIdStr_"^")[("^"_monIcuaId_"^")
					....i startIcuaIdStr'="" s startIcuaIdStr=startIcuaIdStr_"^"
					....s startIcuaIdStr=startIcuaIdStr_monIcuaId
				...//w monBedId_"修改床位",! //
				...s updateBedId=monBedId
				...i ..IfIcuBed(bedId)'="Y" s updateBedId=monIcuBedId
				...&sql(update DHC_ICU_Arrange set ICUA_Status='T',ICUA_Bed_Dr=:updateBedId where ICUA_RowId=:monIcuaId)
				...i retStr=0,SQLCODE'=0 s retStr="修改监护安排状态、床位错误!"
				...
		.q:retStr'=0
		.//处理当前床上病人的不一致信息
		.q:bedEpisodeID=""
		.s bedIcuaId=..GetIcuaId(bedEpisodeID,"","") //返回单条，不创建新监护
		.//w bedEpisodeID,"/"_bedIcuaId,!
		.i bedIcuaId'="" d
			..s icuaBedId=$p($g(^DHCICUArrange(bedIcuaId)),"^",4)
			..s icuaStatus=$p($g(^DHCICUArrange(bedIcuaId)),"^",18)
			..i (icuaStatus="M")&(bedId'=icuaBedId)&(+bedId=+icuaBedId) d //本区新转床，旧床没停
				...//w bedIcuaId_"停，修改上一监护安排床位!",! //
				...s retStr=..StopEquipCollect(bedIcuaId)
				...//w bedIcuaId_"  bedIcuStop/"_retStr
				...s updateBedId=bedId
				...i ..IfIcuBed(bedId)'="Y" s updateBedId=icuaBedId
				...&sql(update DHC_ICU_Arrange set ICUA_Status='T',ICUA_Bed_Dr=:updateBedId where ICUA_RowId=:bedIcuaId)
				...i retStr=0,SQLCODE'=0 s retStr="修改上一监护安排床位、状态错误!"
				...q:("^"_startIcuaIdStr_"^")[("^"_bedIcuaId_"^")
				...i startIcuaIdStr'="" s startIcuaIdStr=startIcuaIdStr_"^"
				...s startIcuaIdStr=startIcuaIdStr_bedIcuaId
			..i (bedId'=icuaBedId)&(+bedId=+icuaBedId) d //未监护或已停止监护，床位不对
				...//w bedIcuaId_"未监护或已停止监护，床位不对",! //
				...q:(..IfIcuBed(bedId)'="Y")
				...&sql(update DHC_ICU_Arrange set ICUA_Bed_Dr=:bedId where ICUA_RowId=:bedIcuaId)
				...i retStr=0,SQLCODE'=0 s retStr="修改监护安排床位错误! Code="_SQLCODE
		.e  d
			..s bedIcuaId=+..GetIcuaId(bedEpisodeID,"","","N") //返回多条，不创建新监护
			..//w bedIcuaId,!
			..q:bedIcuaId=0
			..s icuaBedId=$p($g(^DHCICUArrange(bedIcuaId)),"^",4)
			..s icuaStatus=$p($g(^DHCICUArrange(bedIcuaId)),"^",18)
			..i (icuaStatus="M") d //跨病区后的转来的，旧床没停
				...//w bedIcuaId_"跨病区后的转来的，旧床没停",! //
				...s retStr=..StopEquipCollect(bedIcuaId)
				...//w bedIcuaId_"  bedIcuStop2/"_retStr
				...&sql(update DHC_ICU_Arrange set ICUA_Status='T' where ICUA_RowId=:bedIcuaId)
				...i retStr=0,SQLCODE'=0 s retStr="修改监护安排表状态错误!"
	q:retStr'=0 retStr
	
	//w "start:"_startIcuaIdStr,! 
	
	q:startIcuaIdStr="" retStr
	//h 10 //等待10秒,采集服务提供相应程序后注释
	//启动设备
	f i=1:1:$l(startIcuaIdStr,"^") d
		.q:retStr'=0
		.s startIcuaId=$p(startIcuaIdStr,"^",i)
		.q:startIcuaId=""
		.s endDate=$p($g(^DHCICUArrange(icuaId)),"^",7)
		.;防止转床改为T状态
		.s stat=$p($g(^DHCICUArrange(icuaId)),"^",18)
		.i endDate'=""&&stat'="M" &sql(update DHC_ICU_Arrange set ICUA_Status='M' where ICUA_RowId=:icuaId)
		.;停止设备		
		.s retStr=..StartEquipCollect(icuaId)
	q retStr
}

ClassMethod IfIcuBed(bedId) As %String
{
	q:bedId="" ""
    s bedTpId=$p($g(^PAWARD(+bedId,"BED",+$p(bedId,"||",2))),"^",2)
    s icuBed=$p($g(^PAC("BEDTP",+bedTpId)),"^",5)
    q icuBed
}

ClassMethod GetBedStat(icuaId, userlocId = "") As %String
{
	q 0 //未用
	//q:(+icuaId=0)&(userId="") "noIcuaIdAndUserId^无病人监护号和用户!"
	q:(+icuaId=0)&(userLocId="") "noIcuaIdAndUserLocId^无病人监护号和用户科室!"
	s locIdStr="",patLocId=""
	i icuaId'="" d
	    .s icuaStatus=$p($g(^DHCICUArrange(icuaId)),"^",18)
	    .q:icuaStatus="" //"noIcuaStat^无监护状态!"
	    .q:icuaStatus="A" //"appIcua^不能对监护状态为申请的病人操作!"
	    .q:icuaStatus="D" //"declineIcua^不能对监护状态为拒绝的病人操作!"
	    .q:icuaStatus="N" //"unAppointIcua^不能对监护状态为非预约的病人操作!"
	    .//s bedId=$p($g(^DHCICUArrange(icuaId)),"^",4)
	    .s EpisodeID=$p(^DHCICUArrange(+icuaId),"^",1)
	    .q:EpisodeID=""
	    .s bedId=$p($g(^PAADM(EpisodeID)),"^",73)
	    .q:bedId="" //"noIcuaBed^无病人监护床位!"
	    .s bedSub=$p(bedId,"||",2)
	    .q:+bedSub=0 ;"未定义床位!"
	    .s bedTpId=$p($g(^PAWARD(+bedId,"BED",+bedSub)),"^",2)
	    .s icuBed=$p($g(^PAC("BEDTP",+bedTpId)),"^",5)
	    .q:icuBed'="Y" //"非重症床!"
	    .s locIdStr=$p($g(^PAWARD(+bedId)),"^",5) //病人病区科室
	    .//s patLocId=$p($g(^DHCICUArrange(icuaId)),"^",2) ////病人科室
	i locIdStr'="" d
	    .s linkLocIdStr=##class(web.DHCCLCom).GetLinkLocId(locIdStr)
	    .i linkLocIdStr'="" s locIdStr=locIdStr_"^"_linkLocIdStr

	i locIdStr="" d //"无监护科室!"
	    .s ctcpId=$p($g(^SSU("SSUSR",userId)),"^",14)
	    .q:ctcpId=""
	    .s locId=""
	    .f  s locId=$O(^RB("RES",0,"CTPCP",ctcpId,locId)) q:(locId="")  d
	 	    ..i locIdStr'="" s locIdStr=locIdStr_"^"
	 	    ..s locIdStr=locIdStr_locId
	 	    ..s linkLocIdStr=##class(web.DHCCLCom).GetLinkLocId(locId)
	 	    ..i linkLocIdStr'="" s locIdStr=locIdStr_"^"_linkLocIdStr
	
	s operLocId="",retStr="",i=0 //以下要改为按病区床位找
	f  s operLocId=$o(^DHCANC("OPRoom",0,operLocId)) q:operLocId=""  d
	    .q:(locIdStr'="")&(locIdStr'[operLocId)
	    .s bedId=""
	    .f  s bedId=$o(^DHCANC("OPRoom",0,operLocId,bedId)) q:bedId=""  d
	        ..s i=i+1
	        ..//q:(locIdStr="")&(i>10)
	        ..q:'$d(^DHCANC("OPRoom",bedId))
	        ..s icuaId=$o(^DHCICUArrange(0,"BedStatus",bedId,"M",""))
	        ..i retStr'="" s retStr=retStr_"^"
	        ..s retStr=retStr_bedId
	        ..s retStr=retStr_$c(3)_$p(^DHCANC("OPRoom",bedId),"^")_$c(3)_$p(^DHCANC("OPRoom",bedId),"^",2)
	        ..s retStr=retStr_$c(3)_icuaId
	q retStr
}

ClassMethod GetAnMethodSingle() As %String
{
	 q 0
}

// ancoStr以$c(3)分割

ClassMethod GetOeordItemArcim(icuaId) As %String
{
	q:icuaId="" ""
	s EpisodeID=$p(^DHCICUArrange(+icuaId),"^",1)
	q:EpisodeID="" ""
	k ^TMPICU("Com",$i)

	s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
	q:oeordId="" ""
	s curDate=+$h,fromDate=$h-2000,i=0
	s oeoriSub=0,oeoriIdStr=""
	f sttDate=fromDate:1:curDate d
	    .s oeoriSub=0
	    .f  s oeoriSub=$o(^OEORDi(0,"StDt",sttDate,oeordId,oeoriSub)) q:(oeoriSub="")  d
	        ..q:'$d(^OEORD(oeordId,"I",oeoriSub))
		    ..s oeoriId=oeordId_"||"_oeoriSub
		    ..s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeoriId)
    	    ..q:ordStatCode'="D"
	        ..s arcicOrderType=##Class(web.DHCCLCom).GetOrdSubCatType(oeoriId)
	        ..q:arcicOrderType'="R"
	        ..//s dispenStat=##Class(web.DHCCLCom).GetDispensingStat(oeoriId)
	        ..//q:(dispenStat'="C")
	        ..s icuoId=$o(^DHCICUOrder(0,"OEORI",oeoriId,icuaId,""))
	        ..q:icuoId'=""
	        .. 
	        ..s arcimId=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",2)
			..s arcimDesc=$p($g(^ARCIM(+arcimId,+$p(arcimId,"||",2),1)),"^",2)
	        ..//w arcimId,"/",!
			..s lIcucriId=0,icucriId=0
			..f  s lIcucriId=$o(^DHCICUC("RecordItem",lIcucriId)) q:(lIcucriId="")!(icucriId>0)  d
			    ...i arcimId=$p(^DHCICUC("RecordItem",lIcucriId),"^",4) s icucriId=lIcucriId
			..s ancvcId="" //ypz无初始值//$o(^DHCICUC("ViewCat",0,"oEvent",""))
			..i icucriId>0 s ancvcId=$p(^DHCICUC("RecordItem",icucriId),"^",5)
			..s eqUomQty=..GetEqUomQty(arcimId)
		    ..//s ^TMPICU("Com",$i,i)=+icucriId_"^"_$p(^DHCICUC("RecordItem",+icucriId),"^",2)_"^"_ancvcId_"^"_arcimId_"^"_arcimDesc_"^"_$p(eqUomQty,"^")_"^"_$p(eqUomQty,"^",2)
		    ..s ancoStr=""
		    ..i icucriId>0 s ancoStr=$g(^DHCICUC("RecordItem",+icucriId))
		    ..i $l(ancoStr,"^")<20 s $p(ancoStr,"^",20)=""
		    ..i $p(ancoStr,"^",4)="" s $p(ancoStr,"^",4)=arcimId
		    ..s $p(ancoStr,"^",5)=ancvcId
		    ..s ancoStr=$tr(ancoStr,"^",$c(3))
		    ..s doseQty=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",1)
		    ..s unitUomId=""
		    ..i doseQty'="" s unitUomId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",3)
		    ..i unitUomId'="" s unitDesc=$p($g(^CT("UOM",unitUomId)),"^",2)
		    ..i (doseQty'="")&($p(doseQty,".")="") s doseQty="0"_doseQty
		    ..i (doseQty'="")&(unitDesc'="") s val("doseQtyUnit")=doseQty_" "_unitDesc
		    ..s ^TMPICU("Com",$i,i)=icucriId_"^"_ancoStr_"^"_arcimDesc_"^"_unitUomId_"^"_doseQty  //$p(eqUomQty,"^")_"^"_$p(eqUomQty,"^",2)
		    ..//w i_":"_^TMPICU("Com",$i,i),!
	    	..s i=i+1 
    q i
}

ClassMethod GetUserTypeName(userId As %String) As %String
{
	//取用户的类别:医生还是护士
	q:userId="" "用户有误!"
	s ctpcpId=$p($g(^SSU("SSUSR",userId)),"^",14)
	q:ctpcpId="" "该用户未关联医护人员!"
	s ctcptId=$P($g(^CTPCP(ctpcpId,1)),"^",4)  ;CTPCP_CarPrvTp_DR
	q:ctcptId="" "该医护人员未定义医护类型!"
    s ctcptInternalType=$P($g(^CT("CPT",ctcptId)),"^",4)  ;CT_CarPrvTp:CTCPT_InternalType
	;q:ctcptInternalType="" "医护人员类型定义有误!"
	s userName=$p($g(^SSU("SSUSR",userId)),"^",2)
	s loadName=$p($g(^SSU("SSUSR",userId)),"^",1)
	q ctcptInternalType_"^"_userName_"^"_loadName
}

ClassMethod ChangeSuperCatCodeToId() As %String
{
    s count=0
    f i=1:1:$g(^DHCICUPara(0)) d
        .f j=1:1:$g(^DHCICUPara(i,"I",0)) d
            ..s preCode=$p(^DHCICUPara(i,"I",j),"^",2)
            ..q:preCode=""
            ..s ancvscId=$o(^DHCICUC("VSCat",0,"Code",preCode,""))
            ..q:ancvscId=""
            ..s $p(^DHCICUPara(i,"I",j),"^",2)=ancvscId
            ..s count=count+1
    f i=1:1:$g(^DHCICUC("ViewCat",0)) d
        .s preCode=$p($g(^DHCICUC("ViewCat",i)),"^",10)
        .//w preCode,!
        .q:preCode=""
        .s ancvscId=$o(^DHCICUC("VSCat",0,"Code",preCode,""))
        .q:ancvscId=""
        .s $p(^DHCICUC("ViewCat",i),"^",10)=ancvscId
        .s count=count+1
    //WEBSOURCE>m ^DHCICUC("Para","Default")=^DHCICUPara(8)
    //WEBSOURCE>m ^DHCICUC("Para","578ICU")=^DHCICUPara(8)
   	q count
}

Query GetICUCIOItem(ctLocDr As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	SELECT ICUCIOI_RowId As RowId,ICUCIOI_Active As Active,ICUCIOI_Code As Code,ICUCIOI_ComOrd_Dr As ComOrdDr,ICUCIOI_Desc As Description,ICUCIOI_Instruct_Dr As InstructDr,ICUCIOI_Type As Type,ICUCIOI_ViewCat_Dr As ViewCatDr FROM DHC_ICUC_IOItem Where ICUCIOI_Ctloc_Dr=:ctLocDr
}

Query GetICUTotalIOItem(parref As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	SELECT ICUTIOI_RowId As RowId,ICUTIOI_ICUCIO_Dr As ICUCIODr,ICUTIOI_Parref As Parref,ICUTIOI_Qty As Quantity,ICUTIOI_Uom_Dr As UomDr,ICUTIOI_ChildSub As ChildSub FROM DHC_ICU_TotalIOItem Where ICUTIOI_Parref=:parref
}

Query GetSummaryData(endDate As %String, endTime As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	SELECT ICUTIO_RowId As RowId,ICUTIO_ICUA_Dr As ICUADr,ICUTIO_StartDate As StartDate,ICUTIO_StartTime As StartTime,ICUTIO_EndDate As EndDate,ICUTIO_EndTime As EndTime,ICUTIO_TotalInput As TotalInput,ICUTIO_TotalOutput As TotalOutput,ICUTIO_SummaryData As SummaryData FROM DHC_ICU_TotalIO Where CONVERT(VARCHAR(20),ICUTIO_EndDate,101)=:endDate And CONVERT(VARCHAR(20),ICUTIO_EndTime,108)=:endTime
}

ClassMethod GetPatientWardId(EpisodeID As %String) As %String
{
	q:(EpisodeID="") ""
	s wardId=$p($g(^PAADM(EpisodeID)),"^",70)
	q $g(wardId)
}

Query FindICUTotalIO(startDate As %String, startTime As %String, endDate As %String, endTime As %String, arrangeId As %String) As %Query(ROWSPEC = "RowId:%String,ICUADr:%String,StartDateTime:%String,EndDateTime:%String,CreateDateTime:%String,TotalInput:%Float,TotalOutput:%Float,SummaryData:%String") [ SqlProc ]
{
}

ClassMethod FindICUTotalIOExecute(ByRef qHandle As %Binary, startDate As %String, startTime As %String, endDate As %String, endTime As %String, arrangeId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	s startDate=$Zdh(startDate,3)
	s endDate=$zdh(endDate,3)
	s startTime=$zth(startTime,3)
	s endTime=$zth(endTime,3)
	
	s totalIORowId=0
	f  s totalIORowId=$o(^DHCICUTotalIO(totalIORowId)) q:totalIORowId=""  d
	.s sumStartDate=$p($g(^DHCICUTotalIO(totalIORowId)),"^",2)
	.s sumStartTime=$p($g(^DHCICUTotalIO(totalIORowId)),"^",4)
	.s sumEndDate=$p($g(^DHCICUTotalIO(totalIORowId)),"^",3)
	.s sumEndTime=$p($g(^DHCICUTotalIO(totalIORowId)),"^",5)
	.q:((sumStartDate>endDate) || (sumEndDate<startDate) || (sumStartDate<startDate) || (sumEndDate>endDate))
	.q:(((sumStartDate=startDate) & (sumStartTime<startTime)) || ((sumStartDate=endDate) & (sumStartTime>endTime)))
	.q:(((sumEndDate=endDate) && (sumEndTime>endTime)) || ((sumEndDate=startDate) && (sumEndTime<startTime)))
	.s startDateTime=""
	.i sumStartDate'=""  s startDateTime=$zd(sumStartDate,3)
	.i sumStartTime'=""  s startDateTime=startDateTime_" "_$zt(sumStartTime,1)
	.s endDateTime=""
	.i sumEndDate'=""  s endDateTime=$zd(sumEndDate,3)
	.i sumEndTime'=""  s endDateTime=endDateTime_" "_$zt(sumEndTime,1)
	.s icuaId=$p($g(^DHCICUTotalIO(totalIORowId)),"^",1)
	.q:(icuaId'=arrangeId)
	.s totalInput=$p($g(^DHCICUTotalIO(totalIORowId)),"^",6)
	.s totalOutput=$p($g(^DHCICUTotalIO(totalIORowId)),"^",7)
	.s summaryData=$p($g(^DHCICUTotalIO(totalIORowId)),"^",31)
	.s createDateTime=""
	.s createDateTime=$zd($p($g(^DHCICUTotalIO(totalIORowId)),"^",19))
	.s createDateTime=createDateTime_" "_$zt($p($g(^DHCICUTotalIO),"^",20))
	.d Output
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Output
	set Data=$lb(totalIORowId,icuaId,startDateTime,endDateTime,createDateTime,totalInput,totalOutput,summaryData)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindICUTotalIOFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindICUTotalIOExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindICUTotalIOClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindICUTotalIOExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：      	ypz
/// CreatDate：    	2010-04-23
/// Description： 	插入病人优先级数据
/// Table：        	DHC_ICU_Arrange,PA_Adm,PA_AdmPriority
/// Input：        	icuaId重症监护安排ID,EpisodeID就诊号;userId,用户Id;date:日期;time:时间;
/// 				ctacuCode病人分级代码,为空取默认设置。
/// Output：       
/// Return：       	返回0正常，否则提示出错信息。(相同状态不插入)
ClassMethod InsertAdmPriority(icuaId, EpisodeID, userId, date, time, ctacuCode = "") As %String
{
	//w ##class(web.DHCICUCom).InsertAdmPriority(1,"",1,$h,"9:00","")
	i EpisodeID="",+icuaId'=0 s EpisodeID=+$g(^DHCICUArrange(icuaId))
	q:+EpisodeID=0 "未找到病人就诊号!"
	q:'$d(^PAADM(EpisodeID)) "病人就诊数据有误!"
	q:userId="" "无用户信息!"
	i ctacuCode'="" s ctacuId=$o(^CT("ACU",0,"Code",ctacuCode,""))
	i ctacuId="" s ctacuId=$p($g(^DHCCLSet("ICU","SERIOUS")),"^",2)
	q:+ctacuId=0 "病人优先级代码有误!"
	q:$p(^PAADM(EpisodeID),"^",33)=ctacuId 0 //优先级相同不插入
	s retStr=0
	k PLIST
	s PLIST(0)=EpisodeID
	s PLIST(3)=##class(web.DHCClinicCom).ConvertToDateH(date)
	s PLIST(4)=##class(web.DHCClinicCom).ConvertToTimeH(time)
	s PLIST(5)=ctacuId
	s PLIST(6)=+userId
	&sql(Insert into PA_AdmPriority values :PLIST())
	i SQLCODE s retStr="插入优先级数据失败! 代码："_SQLCODE
	q:retStr'=0 retStr
	&sql(Update PA_Adm Set PAADM_Priority_DR=:ctacuId where PAADM_RowId=:EpisodeID)
	i SQLCODE s retStr="修改就诊表数据失败! 代码："_SQLCODE
	q retStr
}

/// Creator：      	ypz
/// CreatDate：    	2010-04-23
/// Description： 	取病人分级数据
/// Table：        	DHC_ICU_Arrange,PA_Adm,PA_AdmPriority
/// Input：        	icuaId重症监护安排ID,EpisodeID就诊号
/// Output：        retList数组,结点为日期时间串,值为ctacuId
/// Return：       	正常返回0,为空出错。
ClassMethod GetAdmPriorityList(icuaId, EpisodeID = "", retList = "") As %String
{
	k retList
	i EpisodeID="",+icuaId'=0 s EpisodeID=+$g(^DHCICUArrange(icuaId))
	q:+EpisodeID=0 ""
	
	s defaultCtacuId=$p($g(^DHCCLSet("ICU","SERIOUS")),"^",2)
	i defaultCtacuId'="" s retList(1)=defaultCtacuId
	s priSub=0
	f  s priSub=$o(^PAADM(EpisodeID,"PRI",priSub)) q:priSub=""  d
	    .s priDate=$p(^PAADM(EpisodeID,"PRI",priSub),"^",1)
	    .s priTime=$p(^PAADM(EpisodeID,"PRI",priSub),"^",2)
	    .s retList(priDate+(priTime/100000))=$p(^PAADM(EpisodeID,"PRI",priSub),"^",3)
	q 0
}

/// Creator：      	ypz
/// CreatDate：    	2010-04-23
/// Description： 	在时间数组中取数据
/// Table：        	
/// Input：        	dateTimeList时间数据,date输入日期,time输入时间
/// Output：        数据
/// Return：       	返回0
ClassMethod GetDateTimeListData(dateTimeList, date, time) As %String
{
	q:date="" ""
	
	s includeEndPoint=$p($g(^DHCCLSet("ICU","SERIOUS")),"^",3)
	i includeEndPoint'="Y" s time=time+0.1 //包括开始时间点
	s dateTime=$o(dateTimeList(date+(time/100000)),-1)
	//w "dateTime=",dateTime,!
	s retStr=""
	i dateTime'="" s retStr=dateTimeList(dateTime)
	q retStr
}

/// Creator：      	ypz
/// CreatDate：    	2010-04-23
/// Description： 	根据设置,分级和病人时间，判断病人是否严重病人
/// Table：        	DHC_ICU_Arrange,PA_Adm,PA_AdmPriority,
/// Input：        	icuaId重症监护安排ID,EpisodeID就诊号,date日期(空为系统日期),time时间(空为系统时间)
/// Output：        
/// Return：       	返回Y是严重病人
ClassMethod IfSerious(icuaId, EpisodeID = "", date = "", time = "") As %String
{
	s retStr=..GetAdmPriorityList(icuaId, EpisodeID, .dateTimeList)
	q:retStr'=0 retStr
	s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	s time=##class(web.DHCClinicCom).ConvertToTimeH(time)
	s ctacuId=..GetDateTimeListData(.dateTimeList, date, time)
	q:ctacuId="" "" 
	s retStr="N"
	i ("|"_$p($g(^DHCCLSet("ICU","SERIOUS")),"^")_"|")[("|"_ctacuId_"|") s retStr="Y"
	q retStr
}

/// Creator：      	ypz
/// CreatDate：    	2010-07-27
/// Description： 	根据设置,判断病人优先级类型
/// Table：        	DHC_ICU_Arrange,PA_Adm,PA_AdmPriority,
/// Input：        	icuaId重症监护安排ID,EpisodeID就诊号,date日期(空为系统日期),time时间(空为系统时间)
/// Output：        
/// Return：       	优先级ID，代码，名称
ClassMethod GetAdmPriority(icuaId, EpisodeID = "", date = "", time = "") As %String
{
	s retStr=..GetAdmPriorityList(icuaId, EpisodeID, .dateTimeList)
	q:retStr'=0 retStr
	s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	s time=##class(web.DHCClinicCom).ConvertToTimeH(time)
	s ctacuId=..GetDateTimeListData(.dateTimeList, date, time)
	q:+ctacuId=0 "^^" 
	s retStr=ctacuId_"^"_$p(^CT("ACU",ctacuId),"^",1,2)
	q retStr
}

/// 根据就诊号取监护申请号RowId：转入当前病区后的icuaId。每次转入病区到转出病区间最多只有一个icuaId
/// 生成新icu记录：ifSingle为"Y",ifCreate为"Y",userCtlocId不为空。例外：未转归(转归时间晚于最后转科时间)、6小时内转出又返回者，不新生成
ClassMethod GetIcuaId(EpisodeID, regNo, userId, ifSingle = "Y", ifCreate = "N", userCtlocId = "", bedId = "", date = "", time = "") As %String
{
	// 是否科室模板是否配置
	s templateId=""
	i (ifCreate="Y")&&(userCtlocId'="") d
		.s templateId=$O(^DHCICUPara(0,"Ctloc",userCtlocId,templateId))
	q:((ifCreate="Y")&&(templateId="")) "该科室:"_userCtlocId_"未配置"
	s userWardIdStr=""
	i userCtlocId'="" d  //找病区科室串
		.s userWardIdStr=$o(^PAWARD(0,"WARD_LocationDR",userCtlocId,0))
		.i (userWardIdStr="")!(userWardIdStr=$p(^PAADM(EpisodeID),"^",70)) s bedId=""
		.i userWardIdStr="" d
			..s linkLocIdStr=##class(web.DHCCLCom).GetLinkLocId(userCtlocId)
			..f i=1:1:$l(linkLocIdStr,"^") d
				...s curCtlocId=$p(linkLocIdStr,"^",i)
				...q:curCtlocId=""
				...s curWardId=$o(^PAWARD(0,"WARD_LocationDR",curCtlocId,0))
				...q:curWardId=""
				...i userWardIdStr'="" s userWardIdStr=userWardIdStr_"^"
				...s userWardIdStr=userWardIdStr_curWardId
	e  s bedId=""
		
	s EpisodeIDList=EpisodeID
	i EpisodeID="",regNo'="" d  //入参没有就诊号，根据登记号找
		.s papmiId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(regNo),""))
		.//w papmiId
		.q:papmiId=""
		.f  s EpisodeID=$o(^PAPERdr(papmiId,"ADM","I",EpisodeID),-1) q:EpisodeID=""  d
			..q:'$d(^PAADM(EpisodeID))
			..s pavisit=$p($g(^PAADM(EpisodeID)),"^",20)
			..//w EpisodeID_"/"_pavisit
			..q:"AD"'[pavisit
			..i EpisodeIDList'="" s EpisodeIDList=EpisodeIDList_"^"
			..s EpisodeIDList=EpisodeIDList_EpisodeID
	q:(EpisodeIDList="") ""
	
	s needDateTime=""
	i date>0 s needDateTime=date+((time+1)/100000)
	s icuaIdList="",latestIcuaId="",wardLatestIcuaId=""
	s isFirst="Y" //为"Y"是最新的icuaId
	f i=1:1:$l(EpisodeIDList,"^") d
		.s EpisodeID=$p(EpisodeIDList,"^",i)
		.q:'$d(^PAADM(EpisodeID))
		.s retStr=##class(web.DHCClinicCom).GetAdmTransWardList(EpisodeID, .transWardList)
		.q:'$d(transWardList) 	//没有转病区记录
		.s icuaId="",isQuit=0
		.f  s icuaId=$o(^DHCICUArrange(0,"Adm",EpisodeID,icuaId),-1) q:(icuaId="")!(isQuit)  d
			..q:'$d(^DHCICUArrange(icuaId))
			..s icuaStatus=$p($g(^DHCICUArrange(icuaId)),"^",18)
			..q:icuaStatus=""
			..q:"D"[icuaStatus //停止的
			..q:(ifSingle="Y")&(ifCreate="Y")&(isFirst="N")
			..s wardId=$p(^PAADM(EpisodeID),"^",70)
			..s icuaBedId=$p($g(^DHCICUArrange(icuaId)),"^",4)
			..s icuaWardId=+icuaBedId
			..i (isFirst="Y") s latestIcuaId=icuaId  //latestIcuaId记录最新的icuaId,wardLatestIcuaId为当前病区最新的
			..i (isFirst="Y")&(("^"_userWardIdStr_"^")[("^"_icuaWardId_"^")) s wardLatestIcuaId=icuaId
			..s isFirst="N"
			..//w icuaId_" first ",userCtlocId_"/"_userWardIdStr_"/"_icuaWardId,!
			..q:(userCtlocId'="")&(("^"_userWardIdStr_"^")'[("^"_icuaWardId_"^")) //icuaId非用户病区退出，防止ICU互相转
			..//i $p($g(^DHCICUArrange(+icuaId)),"^",7)'="" s wardLatestIcuaId="" //有结束日期,HX版
			..s icuaDateTime=$p(^DHCICUArrange(icuaId),"^",6)+(($p(^DHCICUArrange(icuaId),"^",8)+1)/100000) //入ICU时间
			..s dateTime=$o(transWardList(icuaDateTime),-1) //本次icuaId的转入病区时间
			..//i dateTime'="" w "first:  "_"/"_transWardList(dateTime)_"/"_icuaDateTime_"/"_dateTime,!
			..i dateTime="" s dateTime=$o(transWardList(icuaDateTime)) //要求时间早于第一次转科记录，取第一次
			..//w "before: "_"/"_transWardList(dateTime)_"/"_icuaDateTime_"/"_dateTime,!
			..q:dateTime="" //无转病区记录，应不会出现
			..//w icuaBedId_" bedid/"_transWardList(dateTime),!
			..i +icuaBedId'=transWardList(dateTime) d //病区不符，一般是监护开始时间早于转科时间。
				...//w " not same "
				...s postDateTime=$o(transWardList(dateTime)) //取后一换病区(不同于转科记录)，看是否符合
				...i postDateTime="" d
					....i icuaIdList'="" s icuaIdList=icuaIdList_"^"
					....s icuaIdList=icuaIdList_icuaId
				...q:postDateTime=""
				...//w "  post: "_"/"_transWardList(postDateTime)_"/"_icuaDateTime_"/"_postDateTime,!
				...q:+icuaBedId'=transWardList(postDateTime) //退出，连续两次换病区不考虑
				...s tmpPostDateTime=postDateTime-0.216 //最早转科提前6小时
				...i $p(tmpPostDateTime,".")<$p(postDateTime,".") d
					....s tmpPostDateTime=tmpPostDateTime-0.136 //跨天，补足一天:1-0.864=0.136
				...i tmpPostDateTime<dateTime s tmpPostDateTime=dateTime //上一转病区、当前病区转入时间前6小时晚的
				...q:tmpPostDateTime>icuaDateTime //开始时间与转病区时间不符退出
				...s dateTime=postDateTime	//监护开始时间早于转科时间
			..q:+icuaBedId'=transWardList(dateTime) //未生成!! HX不一样
			..//锁定了与icuaId对应的转病区时间dateTime
			..//w "after:  "_"/"_transWardList(dateTime)_"/"_icuaDateTime_"/"_dateTime,!
			..i (ifSingle="Y") d //处理是否新插监护记录
				...q:latestIcuaId="" //未监护过
				...s wardDateTime=$o(transWardList(""),-1) //最后一次换病区
				...q:wardDateTime="" //无转病区记录
				...s latestLeaveDate=$p($g(^DHCICUArrange(+latestIcuaId)),"^",44) //转归日期
				...s latestLeaveTime=$p($g(^DHCICUArrange(+latestIcuaId)),"^",45) //转归时间
				...s latestLeaveDateTime=latestLeaveDate+(latestLeaveTime/100000)
				...//w "latestLeaveDateTime="_latestLeaveDateTime,"/"_wardDateTime,"/"_latestIcuaId,!
				...//w latestIcuaId_"/"_latestLeaveDate_"/"_latestLeaveTime_":"_latestLeaveDateTime,!
				...i (latestLeaveDate'="")&(latestLeaveDateTime<wardDateTime) s latestIcuaId="" //转病区前已转归
				...q:wardDateTime=dateTime //最后一条是当前，已找到
				...//w latestIcuaId_"/"_latestLeaveDate_"/"_latestLeaveTime_":"_latestLeaveDateTime,!
				...i +icuaBedId'=transWardList(wardDateTime) s latestIcuaId="" q //不是病人当前病区不插
				...s tmpDateTime=wardDateTime,interval=0
				...f  s tmpDateTime=$o(transWardList(tmpDateTime),-1) q:(tmpDateTime<dateTime)!(tmpDateTime="")  d
					....//w "    trans:"_transWardList(tmpDateTime)_"/"_wardDateTime_"/"_tmpDateTime_"/"_latestIcuaId,!
					....i +icuaBedId=transWardList(tmpDateTime) d //转出又转回
						.....//w "interval="_interval,!
						.....i interval>0.216 s latestIcuaId="" //别的病区呆的大于6小时，要新生成icuaId
						.....s wardDateTime=tmpDateTime //可以有多次转回时间，wardDateTime记录当前病区的多次转入
						.....s interval=0
					....e  d
						.....//w "intervalDifDay="_interval,!
						.....s interval=wardDateTime-tmpDateTime
						.....i $p(tmpDateTime,".")<$p(wardDateTime,".") s interval=interval-0.136
				...//s icuaIdList=latestIcuaId
			..i (ifSingle="Y")&(userCtlocId'="")&(("^"_userWardIdStr_"^")'[("^"_icuaWardId_"^")) s isQuit=1 q //只找一次时，监护的不是当前科室退出
			..i $o(transWardList(icuaDateTime),-1)="" s icuaDateTime=$o(transWardList(icuaDateTime))+0.00001
			..i (ifSingle="Y")&(needDateTime>0)&($o(transWardList(needDateTime),-1)'=dateTime) q //needDateTime有值时，无6小时限制不准 
			..//w latestIcuaId,"/"_needDateTime_"/",dateTime,"/"_transWardList(dateTime)_"/"_$o(transWardList(dateTime)),!
			..//i (ifSingle="Y")&(needDateTime'>0)&($o(transWardList(dateTime))'="") q //只找一次时，6小时内转出又回不是最后一次转病区
			..i ifSingle="Y" s isQuit=1
			..i icuaIdList'="" s icuaIdList=icuaIdList_"^"
			..s icuaIdList=icuaIdList_icuaId
			..//s transSub="",preWardId="",dateTime=0 //$h+($p($h,",",2)/100000)
			..//f  s transSub=$o(^PAADM(EpisodeID,"TRANS",transSub),-1) q:(transSub="")!(preWardId>0)  d
			..//.q:$p(^PAADM(EpisodeID,"TRANS",transSub),"^",9)=wardId
			..//.s preWardId=$p(^PAADM(EpisodeID,"TRANS",transSub),"^",9)
			..//.q:preWardId=""
			..//.s dateTime=^PAADM(EpisodeID,"TRANS",transSub)+($p(^PAADM(EpisodeID,"TRANS",transSub),"^",2)/100000)
			..//w " preWardId="_preWardId," dt="_dateTime,!
			..//i (preWardId="")!((preWardId'="")&(icuaDateTime>dateTime)) d
			..//.i icuaIdList'="" s icuaIdList=icuaIdList_"^"
			..//.s icuaIdList=icuaIdList_icuaId
			..//.//w "list:"_icuaIdList
			..//.i ifSingle="Y" s isQuit=1 //只找第一个
		.s isFirst="N"
	q:(ifSingle'="Y") icuaIdList //找全部
	s icuaId=icuaIdList
	//q:icuaId'="" icuaId //HX用!!单个找已有
	
	//q:(icuaId="")&(wardLatestIcuaId'="") wardLatestIcuaId //HX用!! 转过科未停
	q:userId="" icuaIdList
	q:(ifCreate'="Y") icuaIdList
	q:(userCtlocId="") icuaIdList
	
	i (ifSingle="Y")&(ifCreate="Y") d
		.s icuaId=latestIcuaId
		.i (latestIcuaId="")!(wardLatestIcuaId'=latestIcuaId) s icuaId=""	//未监护或转病区后监护过
	b ;"12"
	i icuaId="",ifSingle="Y" d //只找一个时，病区用户能生成同病区床位上病人记录
		.s icuaId="",isQuit=0,isMonitored=0
		.f  s icuaId=$o(^DHCICUArrange(0,"Adm",EpisodeID,icuaId),-1) q:(icuaId="")!(isQuit)  d
			..q:'$d(^DHCICUArrange(icuaId))
			..s icuaStatus=$p($g(^DHCICUArrange(icuaId)),"^",18)
			..q:icuaStatus=""
			..q:"D"[icuaStatus //停止的
			..i icuaStatus="M" s isMonitored=1
		.b "3"
		.q:isMonitored
		.s curBedId=$p($g(^PAADM(EpisodeID)),"^",73)
		.i bedId'="" s curBedId=bedId
		.q:(curBedId="") //在等待区不生成
		.q:(userCtlocId'="")&(("^"_userWardIdStr_"^")'[("^"_+curBedId_"^")) //不是同一病区不生成
		.;s patLocId=$p($g(^PAADM(EpisodeID)),"^",4)
		.;s patLinkLocStr=##class(web.DHCCLCom).GetLinkLocId(patLocId)
		.;q:patLinkLocStr'[userCtlocId
		.;q:userCtlocId'=patLocId
		.k PLIST
		.s curDate=+$h,curTime=$p($h,",",2)
		.s PLIST(2)=EpisodeID
		.s PLIST(3)=$p($g(^PAADM(EpisodeID)),"^",4)
		.s PLIST(5)=curBedId
		.s PLIST(7)=curDate
		.s PLIST(9)=curTime
		.s PLIST(12)=userId
		.s PLIST(13)=curDate
		.s PLIST(14)=curTime
		.s PLIST(15)=userId
		.s PLIST(16)=curDate
		.s PLIST(17)=curTime
		.s PLIST(19)="R"
		.&SQL(Insert into DHC_ICU_Arrange Values :PLIST())
		.i 'SQLCODE s icuaId=$g(%ROWID)
		.i icuaId'="" s ^tmpICU("GetIcuaId",icuaId,$h)=EpisodeID_"/"_regNo_"/"_userId_"/"_ifSingle_"/"_ifCreate_"/"_userCtlocId_"/"_bedId_"/"_$p($g(^PAADM(EpisodeID)),"^",73)_"/"_userWardIdStr
		.i icuaId'="" m ^tmpICU("GetIcuaId",icuaId,$h,"trans")=transWardList
	q icuaId
}

/// Creator：      	ypz
/// CreatDate：    	2010-03-12
/// Description： 	查找病区病人:有wardId直接找病人,无则根据ctlocId则找病人:是病区直接找病人,是科室找关联病区的病人
/// Table：        	PA_Adm,PA_Patmas,PAC_Ward,PAC_Bed
/// Input：        	wardId病区ID,ctlocId医生/护士科室ID
/// Output：       
/// Return：       	返回以"^"分割的病人信息串，病人信息:就诊号EpisodeID_"|"_床位bedCode_"|"_病人姓名patName
ClassMethod FindWardPatient(wardId As %String = "", ctlocId As %String = "") As %String [ SqlProc ]
{
	s retStr=""
	q:(wardId="")&(ctlocId="") retStr
	
	s wardIdList=wardId
	i wardId="" d
	    .s ctlocType=$p($g(^CTLOC(ctlocId)),"^",13)
		.i (ctlocType="W")||(ctlocType="EM") d
			..s wardIdList=$o(^PAWARD(0,"WARD_LocationDR",ctlocId,0))
		.e  d
			..i ctlocType="E" d  
			..s linksub=0
			..f  s linksub=$o(^CTLOC(ctlocId,"LINK",linksub)) q:linksub=""  d
				...s linkCtlocId=$p($g(^CTLOC(ctlocId,"LINK",linksub)),"^",1)
				...i linkCtlocId'="" d
					....s linkCtlocType=$p($g(^CTLOC(linkCtlocId)),"^",13)
					....i linkCtlocType="W" d 
						.....i wardIdList'="" s wardIdList=wardIdList_"^"
						.....s wardIdList=wardIdList_$o(^PAWARD(0,"WARD_LocationDR",linkCtlocId,0))
	q:wardIdList="" retStr
	
	f i=1:1:$l(wardIdList,"^") d
	    .s wardId=$p(wardIdList,"^",i)
	    .i ctlocId="" s ctlocId=$p(^PAWARD(+wardId),"^",5)
	    .s roomId=0
	    .f  s roomId=$o(^PAADMi("CurrWard",wardId,roomId)) q:roomId=""  d
    		..s EpisodeID=0
    		..f  s EpisodeID=$o(^PAADMi("CurrWard",wardId,roomId,EpisodeID)) q:EpisodeID=""  d
        		...q:'$d(^PAADM(EpisodeID))
        		...s paadmVisitStatus=$p($g(^PAADM(EpisodeID)),"^",20)
        		...i paadmVisitStatus'="A" q
        		...s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
        		...s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
       			...s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
        		...//s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
        		...s bedId=$p($g(^PAADM(EpisodeID)),"^",73)
        		...s bedSub=$p(bedId,"||",2)
        		...q:bedSub=""
        		...s bedTypeId=$p($g(^PAWARD(+bedId,"BED",+bedSub)),"^",2)
        		...s ifIcu=$p($g(^PAC("BEDTP",+bedTypeId)),"^",5)
        		...q:ifIcu'="Y"
        		...s bedCode=$p($g(^PAWARD(wardId,"BED",bedSub)),"^",1)
        		...q:bedCode="" ;防止床位码表被删
        		...s icuaId=..GetIcuaId(EpisodeID, "", "", "Y", "N",ctlocId) //返回单条，不创建新监护
        		...i retStr'="" s retStr=retStr_"^"
        		...s retStr=retStr_EpisodeID_"|"_bedCode_"|"_patName_"|"_icuaId //用床位号好找
    q retStr
}

/// 按病区时，只找当前最新的
ClassMethod FindIcuaIdList(icuaId As %String, EpisodeID As %String, ctlocId As %String) As %Library.String
{
	s icuaIdList=icuaId
	i icuaId="" d
	    .s EpisodeIDList=EpisodeID
	    .i EpisodeID="" s EpisodeIDList=..FindWardPatient("", ctlocId)
	    .q:EpisodeIDList=""
	    .f i=1:1:$l(EpisodeIDList,"^") d
	        ..s EpisodeID=+$p(EpisodeIDList,"^",i)
	        ..s icuaId=..GetIcuaId(EpisodeID,"","") //返回单条，不创建新监护
	        ..q:icuaId=""
	        ..i icuaIdList'="" s icuaIdList=icuaIdList_"^"
	        ..s icuaIdList=icuaIdList_icuaId
	q icuaIdList
}

/// Creator：      	ypz
/// CreatDate：    	2010-08-02
/// Description： 	把当前病人参数作为科室参数，替换全部已监护病人参数
/// Table：        	DHC_IUC_Arrange,PA_Adm,CT_Loc
/// Input：        	icuaId监护安排表ID,ctlocId病人所在病区对应的科室ID
/// Output：       
/// Return：       	返回0正常，其他返回提示信息。
ClassMethod SaveAsWardPara(icuaId As %String, ctlocId As %String) As %Library.String
{
	q:ctlocId="" "科室Id为空!"
	q:icuaId="" "重症监护Id为空!"
	s EpisodeID=+$g(^DHCICUArrange(icuaId))
	q:EpisodeID=0 "就诊号为空!"
	s wardId=$p($g(^PAADM(EpisodeID)),"^",70)
	s wardLocId=$p(^PAWARD(+wardId),"^",5)
	q:wardLocId'=ctlocId "病人当前科室与待操作科室不一致!"
	q:'$d(^PAADM(EpisodeID)) "就诊记录无数据!"
	s icupId=$o(^DHCICUPara(0,icuaId,""))
	q:icupId="" "无当前病人参数Id!"
	q:'$d(^DHCICUPara(icupId,"I")) "当前病人参数有误!"
	m ^DHCICUC("Para",ctlocId)=^DHCICUPara(icupId)
	
	s EpisodeIDList=..FindWardPatient("", ctlocId)
	q:EpisodeIDList="" 0
	f i=1:1:$l(EpisodeIDList,"^") d
	    .s EpisodeID=+$p(EpisodeIDList,"^",i)
	    .s curIcuaId=..GetIcuaId(EpisodeID,"","") //返回单条，不创建新监护
	    .q:curIcuaId=icuaId
	    .s curIcupId=..GetIcupId(curIcuaId,ctlocId)
	    .k ^DHCICUPara(curIcupId,"I")
	    .m ^DHCICUPara(curIcupId,"I")=^DHCICUPara(icupId,"I")
	q 0
}

/// Creator：      	ypz
/// CreatDate：    	2010-08-02
/// Description： 	取监护病人床位定义的采集监护项的常用医嘱ID
/// Table：        	DHC_IUC_Arrange,DHC_ICU_BedEquip,DHC_ICU_BedEquipDetail
/// Input：        	icuaId监护安排表ID
/// Output：       
/// Return：       	返回以^分割的串，第一个为0正常返回,后面为常用医嘱ID串;第一个小于0数据,后面为出错信息。
ClassMethod GetBedEquipAncoId(icuaId As %String) As %Library.String
{
    q:$g(^DHCCLSet("ICU","UnCollect"))="Y" "0^"
	q:icuaId="" "-1^重症监护Id为空!"
	s EpisodeID=+$g(^DHCICUArrange(icuaId))
	q:EpisodeID=0 "-1^就诊号为空!"
	s bedId=$p($g(^PAADM(EpisodeID)),"^",73)
	q:bedId="" "-1^病人不在床位上!"
    s bedSub=$p(bedId,"||",2)
    q:+bedSub=0 "-2^未定义床位!"
    s bedTpId=$p($g(^PAWARD(+bedId,"BED",+bedSub)),"^",2)
    s icuBed=$p($g(^PAC("BEDTP",+bedTpId)),"^",5)
    q:icuBed'="Y" "-3^非重症床!"
    s icubeId="",retStr=0
    f  s icubeId=$o(^DHCICUBedEquip(0,"Bed",bedId,icubeId)) q:icubeId=""  d
        .q:'$d(^DHCICUBedEquip(icubeId))
        .s eqId=$p($g(^DHCICUBedEquip(icubeId)),"^",2)
        .//q:eqId=""
        .q:$p($g(^DHCICUBedEquip(icubeId)),"^",5)="" //未定义设备名
        .s icuBedSub=0
        .f  s icuBedSub=$o(^DHCICUBedEquip(icubeId,"I",icuBedSub)) q:icuBedSub=""  d
        	..s icucriId=$p(^DHCICUBedEquip(icubeId,"I",icuBedSub),"^")
        	..q:icucriId=""
        	..s retStr=retStr_"^"_icucriId
    q retStr
}

/// Creator：      	ypz
/// CreatDate：    	2010-08-03
/// Description： 	按日期取ctlocId科室的，出院病人，
/// Table：        	DHC_ICU_Arrange,PA_ADM
/// Input：        	toDate结束日期，ctlocId科室Id,aheadDays向前查看天数
/// Output：       
/// Return：       	返回出院病人的icuaId串，以"^"分割。
ClassMethod GetDischargeIcuaId(toDate As %String = "", ctlocId As %String = "", aheadDays As %String = 3, icuaId As %String = "") As %Library.String
{
    s toDate=##class(web.DHCClinicCom).ConvertToDateH(toDate)
    s wardId=""
    i ctlocId'="" d
    	.s ctlocType=$p($g(^CTLOC(ctlocId)),"^",13)
		.i ctlocType="W" d
			..s wardId=$o(^PAWARD(0,"WARD_LocationDR",ctlocId,0))
			..s ctlocId=""
    s retStr=""
    s fromDate=toDate-aheadDays+1
    f date=fromDate:1:toDate d 
        .s EpisodeID=""
        .f  s EpisodeID=$o(^PAADMi("DischDate",date,EpisodeID)) q:EpisodeID=""  d
        	..q:'$d(^PAADM(EpisodeID))
        	..q:(ctlocId'="")&(ctlocId'=$p($g(^PAADM(EpisodeID)),"^",4))
        	..q:(wardId'="")&(wardId'=$p($g(^PAADM(EpisodeID)),"^",70))
        	..s curIcuaId=..GetIcuaId(EpisodeID,"","") //返回单条，不创建新监护
        	..q:curIcuaId=""
        	..i retStr'="" s retStr=retStr_"^"
        	..s retStr=retStr_curIcuaId
    i icuaId'="" d
    	.q:'$d(^DHCICUArrange(icuaId))
    	.s icuaBedId=$p($g(^DHCICUArrange(icuaId)),"^",4)
    	.q:wardId'=+icuaBedId //病人不是在用户登录病区监护的
    	.s EpisodeID=+$g(^DHCICUArrange(icuaId))
    	.q:'$d(^PAADM(EpisodeID))
    	.s bedId=$p($g(^PAADM(EpisodeID)),"^",73)
    	.s ifIcuBed=..IfIcuBed(bedId)
    	.s admVisitStatus=$p($g(^PAADM(EpisodeID)),"^",20)
    	.q:(admVisitStatus="A")&(+icuaBedId=$p($g(^PAADM(EpisodeID)),"^",70))&(ifIcuBed="Y")
    	.i ("^"_retStr_"^")'[("^"_icuaId_"^") d
    		..i retStr'="" s retStr=retStr_"^"
    		..s retStr=retStr_icuaId
    q retStr
}

ClassMethod UpdateCommonOrdOptions(commonOrdRowId As %String, option As %String) As %String
{
	q:(commonOrdRowId="") ""
	q:(option="") ""
Trans
	s $ZT="ERROR"
	TSTART		
	&sql(Update sqluser.DHC_ANC_CommonOrd set ANCO_Options=:option Where ANCO_RowId=:commonOrdRowId)
	if SQLCODE TROLLBACK
	q:SQLCODE 1
	TCOMMIT
	q SQLCODE
ERROR
	s ErrorMsg=$ZE
	TROLLBACK
	q "<ERROR>"_VALUE
}

/// Creator：      	lhw
/// CreatDate：    	2010-08-13
/// Description： 	取医嘱的类型
/// Table：        	OEC_Priority
/// Input：        	空
/// Output：       
/// Return：       	返回医嘱的类型，序号，代码和名称，以"^"分割。
Query FindOECPriority() As %Query(ROWSPEC = "RowId:%String,OECPRCode:%String,OECPRDesc:%String") [ SqlProc ]
{
}

ClassMethod FindOECPriorityExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s RowId=""
	f  s RowId=$O(^OECPR(RowId)) Q:RowId=""  d
	   .s OECPRCode=$p(^OECPR(RowId),"^",1)
	   .s OECPRDesc=$p(^OECPR(RowId),"^",2)
	   .d Output
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Output
	set Data=$lb(RowId,OECPRCode,OECPRDesc)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindOECPriorityFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOECPriorityExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindOECPriorityClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOECPriorityExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：      	ypz
/// CreatDate：    	2011-11-29
/// Description： 	获取重症病人监护信息
/// Table：        	DHC_Icu_Arrange
/// Input：        	登记号regNo,就诊号EpisodeID,第三方住院号oaPatientId,第三方住院次数oaVisitId,用户工号ssusrInitials="",用户科室代码userCtlocCode=""
/// Output：        
/// Return：       	返回值分两级，第一级以"^"分割多条记录，第二级以$c(3)分割。
/// 					第二级：重症安排icuaId,用户userId,安全组ssgrpId,病人病区科室wardCtlocId,病区wardDesc,开始时间startDateTime,结束时间endDateTime
ClassMethod GetPatIcuaInfo(regNo, EpisodeID, oaPatientId, oaVisitId, ssusrInitials = "", userCtlocCode = "") As %String
{
	i EpisodeID="" d
		.q:oaPatientId=""
		.q:oaVisitId=""
		.s oaPaadmType="I"
		.s oaId=$o(^DHCENSOA("0","VisitId",oaPaadmType,oaPatientId,oaVisitId,""))
		.q:oaId=""
		.s papmiId=$p(^DHCENSOA(oaId),"^",2)
		.s EpisodeID=$p(^DHCENSOA(oaId),"^",3)
	s icuaIdList=..GetIcuaId(EpisodeID,regNo,"","N")
	q:icuaIdList="" ""
	
	s userCtlocId=##class(web.DHCCLCom).GetCtlocIdByCodeOrDesc(userCtlocCode,"Code")
 	s userCtlocType=$p($G(^CTLOC(+userCtlocId)),"^",13)
 	s userWardCtlocId=userCtlocId
 	i userCtlocType="W" d
 		.s userWardCtlocId=userCtlocId
 	e  d
 		.q:userCtlocType=""
 		.s linkChildSub=0   
 		.f  s linkChildSub=$o(^CTLOC(userCtlocId,"LINK",linkChildSub)) q:linkChildSub=""  d
 			..s linklocId=$p($G(^CTLOC(userCtlocId,"LINK",linkChildSub)),"^",1)
 			..q:$p($G(^CTLOC(+linklocId)),"^",13)'="W"
 			..i userWardCtlocId'="" s userWardCtlocId=userWardCtlocId_"^"
 			..s userWardCtlocId=userWardCtlocId_linklocId
	
	s retStr="",isFind=0
	s userId=##class(web.DHCCLCom).GetUserIdByInitials(ssusrInitials)
	i userId'="" s userId=$o(^SSU("SSUSR",userId),-1)
	f  s userId=$o(^SSU("SSUSR",userId)) q:(userId="")!(isFind)  d
		.s ctcpId=$p(^SSU("SSUSR",userId),"^",14)
		.q:ctcpId=""
		.s ctcptId=$p($g(^CTPCP(+ctcpId,1)),"^",4)  ;CTPCP_CarPrvTp_DR
		.s ctcptType=$p($g(^CT("CPT",+ctcptId)),"^",4)  ;CT_CarPrvTp
		.q:ctcptType=""
		.q:(ssusrInitials="")&(ctcptType="NURSE") //传入为空时，不是护士身份
		.s ssgrpId=$p(^SSU("SSUSR",userId),"^",5)
		.//w userId_","_ctcptType_","_ssgrpId,!
		.s isFind=1
		.f i=1:1:$l(icuaIdList,"^") d
			..s icuaId=$p(icuaIdList,"^",i)
			..q:icuaId=""
			..q:'$d(^DHCICUArrange(icuaId))
			..q:"D"[$p(^DHCICUArrange(icuaId),"^",6)
			..s startDate=$p(^DHCICUArrange(icuaId),"^",6)
			..s endDate=$p(^DHCICUArrange(icuaId),"^",7)
			..s icuBedId=$p(^DHCICUArrange(icuaId),"^",4)
			..s bedId=$p($g(^PAADM(EpisodeID)),"^",73)
			..s bedSub=$p(bedId,"||",2)
			..q:(+bedSub=0) ;"未定义床位!"
			..s wardCtlocId=$p(^PAWARD(+bedId),"^",5)
			..q:(userWardCtlocId'="")&(("^"_userWardCtlocId_"^")'[("^"_wardCtlocId_"^"))
			..s bedTpId=$p($g(^PAWARD(+bedId,"BED",+bedSub)),"^",2)
			..s tBedCode=$p($g(^PAWARD(+bedId,"BED",+bedSub)),"^",1)
			..s wardDesc=$P($g(^PAWARD(+bedId)),"^",2)
			..s startDateTime=""
			..i startDate'="" s startDateTime=$zd(startDate,3)
			..s startTime=$p(^DHCICUArrange(icuaId),"^",8)
			..i startTime'="" s startDateTime=startDateTime_" "_$zt(startTime)
			..s endDateTime=""
			..i endDate'="" s endDateTime=$zd(endDate,3)
			..s endTime=$p(^DHCICUArrange(icuaId),"^",9)
			..i endTime'="" s endDateTime=endDateTime_" "_$zt(endTime)
			..i retStr'="" s retStr=retStr_"^"
			..s retStr=retStr_icuaId_$c(3)_userId_$c(3)_ssgrpId_$c(3)_wardCtlocId_$c(3)_wardDesc_$c(3)_startDateTime_$c(3)_endDateTime
	q retStr
}

Query GetAllPrintInfo(icuaId As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select %ID as Id,
		   ICUPR_Date as StartDate,
		   ICUPR_Time as StartTime,
		   ICUPR_EndDate as EndDate,
		   ICUPR_EndTime as EndTime,
		   ICUPR_PrintDate as PrintDate,
		   ICUPR_PrintTime as PrintTime,
		   ICUPR_PrintUser_Dr as PrintUserId,
		   ICUPR_Parref as Parref
		   from DHC_ICU_PrintRecord
		   where ICUPR_Parref=:icuaId
}

Query GetRecordPara(icuaId As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select %ID as Id,
		   ICUP_ICUA_Dr as RecordArrangeId
		   from DHC_ICU_Para
		   where ICUP_ICUA_Dr=:icuaId
}

Query GetRecordParaItems(paraId As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select %ID as Id,
		   ICUPI_Parref as ParaId,
		   ICUPI_Code as Code,
		   ICUPI_Desc as Description,
		   ICUPI_Type as ParaItemType,
		   ICUPI_ViewSuperCat_Dr as RecordDocumentId,
		   ICUPI_Oeore_Dr as OEOreId,
		   ICUPI_ComOrd_Dr as RecordItemId,
		   ICUPI_Flag as ParaItemFlag,
		   ICUPI_Source as Source,
		   ICUPI_Icon_Dr as IconId,
		   ICUPI_SeqNo as SeqNo,
		   ICUPI_Color as Color,
		   ICUPI_ViewCat_Dr as RecordCatId,
		   ICUPI_Uom_Dr as UomId,
		   ICUPI_StartDate as StartDate,
		   ICUPI_StartTime as StartTime,
		   ICUPI_EndDate as EndDate,
		   ICUPI_EndTime as EndTime
		   from DHC_ICU_ParaItem
		   where ICUPI_Parref=:paraId
}

/// 获取重症监护病人的病区科室Id
ClassMethod GetWardCtlocId(wardId, icuaId = "") As %String
{
	q:(icuaId="")&(wardId="") ""
	i wardId="",icuaId'="" s wardId=+$p($g(^DHCICUArrange(icuaId)),"^",4)
	s wardCtlocId=$p($g(^PAWARD(+wardId)),"^",5)
	q wardCtlocId
}

/*
ClassMethod StartAllTask(cmd = "StartEq") As %String
{
	// w ##class(web.DHCICUCom).StartAllTask("StopEq")
	s icubeId=0,retStr=0
	f  s icubeId=$o(^DHCICUBedEquip(icubeId)) q:icubeId=""  d
	.s bedId=$p(^DHCICUBedEquip(icubeId),"^",1)
	.q:bedId=""
	.
	.s interval=$p(^DHCICUBedEquip(icubeId),"^",6)
	.s bStat=$p(^DHCICUBedEquip(icubeId),"^",8)
	.q:'$d(^DHCICUArrange(0,"BedStatus",bedId,"M"))
	.s icuaId=$o(^DHCICUArrange(0,"BedStatus",bedId,"M",""))
	.q:icuaId=""
	.i bStat'="N" d
	..;启动设备
	..
	..s retStr=..ExcuteTask(icubeId,icuaId,cmd)
	..
	// 启动共享设备 "S^1^10.160.16.30^4001^5000^35^"
	s sub=""
	f  s sub=$O(^DHCCLSet("ShareDev",sub)) q:sub=""  d
	.
	.s item=^DHCCLSet("ShareDev",sub)
	.q:item=""
	.s source=$p(item,"^",1)
	.s eqId=$p(item,"^",2)
	.s ip=$p(item,"^",3)
	.s port=$p(item,"^",4)
	.s sti=$p(item,"^",5)
	.s eqTypeId=$p(item,"^",6)
	.q:eqTypeId=""
	.s devType=$p($g(^DHCANC("CType",eqTypeId)),"^",1)
	.q:devType=""
	.;b "Start Sahre Dev"
	.s retStr=##class(web.DHCCLDevTool).ExcuteDevTask(source,eqId,"","","",ip,port,sti,devType,"",cmd)
	.w retStr
	q retStr
}*/

// ICU采集入库

ClassMethod Insert2DB(icuaId As %String, equipId As %String, source As %String, extInfo As %String = "", dataPara As %String = "", status As %String = "") As %String
{
	// w ##class(web.DHCICUCom).Insert2DB(icuaId,equipId,anoSource,extInfo,dataPara,status)
	i dataPara["PumpSpeed" q ##class(web.DHCICUMicroPump).InsertToDb(source,equipId, icuaId, extInfo, dataPara, status)
	s res=""
	i icuaId="" s res=..InsertShareDevByEquipId(source,equipId,extInfo,dataPara,status)
	e  d
	.s res=..Insert2DBByIcuaId(source,icuaId,equipId,extInfo,dataPara,status)
	q res
}

ClassMethod Insert2DBByIcuaId(source As %String, icuaId As %String, equipId As %String, extInfo As %String = "", dataPara As %String = "", status As %String = "") As %String
{
	s retStr=""
	;q:$$CheckIcuaId(icuaId)'="OK" $$CheckIcuaId(icuaId)
	q:$$CheckEquipId(equipId)'="OK" $$CheckEquipId(equipId)
	q:dataPara="" "-5:datapara=Null" //"无数据!"
	q:$$CheckStandyMode(dataPara) $$CheckStandyMode(dataPara)
	//q:$$PatInBed(icuaId)'="OK" $$PatInBed(icuaId)
	// 如含泵速，则插入DHC_ICU_DeviceData
	s ^tmpdebug("Insert2DBByIcuaId")=dataPara
	
	d GenTEMPRecordToParaItem(icuaId)
	s iOrder=0 ;立即插入DHC_ICU_Order表的数据
	s isHM=0   ;是否是血气的数据
	s insertStr="",standbyMode="false",retStr="" ; 是否立即存入ICUOrder
	
	s iStr="EVLW;EVLWI;GEDV;GEDVI;CFI" ;立即存入包含的项
	
	s NBPs="NSBP",NBPd="NDBP",NBPm="NMBP",sys="",dia="",mean="",nbpStartDate="",nbpStartTime=""
	i $g(^DHCCLSet("ICU","NBPs"))'="" s NBPs=$g(^DHCCLSet("ICU","NBPs"))
	i $g(^DHCCLSet("ICU","NBPd"))'="" s NBPd=$g(^DHCCLSet("ICU","NBPd"))
	i $g(^DHCCLSet("ICU","NBPm"))'="" s NBPm=$g(^DHCCLSet("ICU","NBPm"))
	
	s NBPsId=$O(^DHCICUC("RecordItem",0,"Code",NBPs,""))
	s NBPdId=$O(^DHCICUC("RecordItem",0,"Code",NBPd,""))
	s NBPmId=$O(^DHCICUC("RecordItem",0,"Code",NBPm,""))
	
	s retStr=0,isInsert=0,temperatureChannelNo="TEMP"
	
	
	s devTypeId=$$GetDevTypeId(equipId)
	//w devTypeId
	q:devTypeId="" "-14:Unknow Device Type"
	
	s devDesc=$p($g(^DHCANC("CType",devTypeId)),"^",1)
	s typeCode=$p(^DHCANC("CType",devTypeId),"^",1)
	
	q:$$IsPhilipsSameHM()="true" "-26:Philips Same Hemodynamic monitoring"

	;传入参数有指定时间
	s startDateTime=..GetValue(dataPara,"StartDateTime")
	s startDate=$p(startDateTime,"~",1)
	s startTime=$p(startDateTime,"~",2)
	i startDateTime'="" s iOrder=1
	s itemNum=$L(dataPara,"^")
	
	f i=1:1:itemNum d
	.
	.s itemStr=$P(dataPara,"^",i)
	.q:itemStr=""
	.s channelNo=$P(itemStr,"#",1)
	.q:channelNo=""
	.s devTypeItemId=$$GetDevTypeItemId(devTypeId,channelNo)
	.q:devTypeItemId=""
	.q:$p($g(^DHCANC("CType",devTypeId,"I",devTypeItemId)),"^",3)'="Y"
	.s icucriId=$p(^DHCANC("CType",devTypeId,"I",devTypeItemId),"^",1)
	.s value=$P(itemStr,"#",5)
	.s sttDate=$P(itemStr,"#",2)
	.s sttTime=$P(itemStr,"#",3)
	.s sttDate=##class(web.DHCClinicCom).ConvertToDateH(sttDate)
	.s sttTime=##class(web.DHCClinicCom).ConvertToTimeH(sttTime)
	.;无创血压: 无创血压单独处理
	.i (NBPsId=icucriId) s sys=value s nbpStartDate=sttDate s nbpStartTime=sttTime
	.i (NBPdId=icucriId) s dia=value s nbpStartDate=sttDate s nbpStartTime=sttTime
	.i (NBPmId=icucriId) s mean=value s nbpStartDate=sttDate s nbpStartTime=sttTime
	.q:((NBPsId=icucriId)||(NBPdId=icucriId)||(NBPmId=icucriId))
	.
	.s num="",text=""
	.s field=$p($g(^DHCICUC("RecordItem",icucriId)),"^",24)
	.i (field="Qty") s num=value // 数值ICUO_Qty
	.e  i field="Note" s text=value // 文本ICUO_Note
	.e  i $ISVALIDNUM(field) s num=value
	.e  s text=value
	.i iOrder'=1  d ;血流动力学等需直接放入Order表的数据
	..s collectDataRes=..InsertCollectData(icuaId,icucriId,sttDate,sttTime,num,text)
	..s insertStr=insertStr_channelNo_"["_icucriId_"]:"_collectDataRes_","
	..s isInsert=1
	.e  d
	..d ProInstantData
	..
	..i icuOrderRowId'="" d
	...s insertStr=insertStr_channelNo_"["_icucriId_"]"_"^"_icuOrderRowId_","
	...s isInsert=1
	
	i iOrder=1 d InsertMainItem // /存储需要实时存入的数据
	i (sys'="") d
	.s nbpRes=..InsertNBP(icuaId,nbpStartDate,nbpStartTime,sys,dia,mean)
	.s insertStr=insertStr_" NBP:"_nbpRes
	.s isInsert=1

	i (retStr=0)&&(isInsert=0) s retStr=2 // 未插入值
	q retStr_" icuaId:"_icuaId_" "_insertStr
	
InsertMainItem
	s paraItemId="",sub=""
	f  s paraItemId=$O(TEMPMainSubDic(paraItemId)) q:paraItemId=""  d
	.s paraId=$p(paraItemId,"||",1)
	.s subId=$p(paraItemId,"||",2)
	.s paraItemStr=^DHCICUPara(paraId,"I",subId)
	.s mainRecordId=$p($g(^DHCICUPara(paraId,"I",subId)),"^",4)
	.q:mainRecordId=""
	.s mainRecordStr=$g(^DHCICUC("RecordItem",mainRecordId))
	.q:mainRecordStr=""
	.s mainValStr=""
	.s fStr="",agrs=""
	.;主项中找
	.s fStr=$p(mainRecordStr,"^",25)
	.s args=$p(mainRecordStr,"^",27)
	.
	.i fStr="" d
	..;主项中没有，则找模板项派生按模板取
	..s tempId=$g(^DHCICU("RecordItem"),28)
	..i tempId'="" d
	...s tempStr=$g(^DHCICU("RecordItem",tempId))
	...s fStr=$p(tempStr,"^",25)
	...s args=$p(tempStr,"^",27)
	.q:((fStr="")||(args=""))
	.
	.;生成主项数据
	.s count=$l(fStr,"{")-2
	.s txtValue=fStr
	.s nullValue=txtValue
	.
	.f j=0:1:count d
	..s subStr=##class(web.DHCICUOrder).Replace("{N}","N",j)
	..s code=$p(args,";",(j+1))
	..s aValue=""
	..i code'="" s aValue=$g(TEMPMainSubDic(paraItemId,code))
	..s txtValue=##class(web.DHCICUOrder).Replace(txtValue,subStr,aValue)
	..s nullValue=##class(web.DHCICUOrder).Replace(nullValue,fStr,"")
	.q:nullValue=txtValue
	.;保存到数据
	.b "txt"
	.q:mainParaId=""
	.s sttDate=TEMPMainSubDic(mainParaId,"Date")
	.s sttTime=TEMPMainSubDic(mainParaId,"Time")
	.s icuOrderRowId=..Insert2ICUOrder(icuaId,mainRecordId,sttDate,sttTime,"",txtValue,paraItemId)
	.
	q
CheckIcuaId(icuaId)
	s retStr="OK"
	i $g(^DHCICUArrange(+icuaId))="" q "-12:Invalid icuaId"
	i "RTF"[$p($g(^DHCICUArrange(+icuaId)),"^",18) d
	.s retStr="-11:Stat:"_$p($g(^DHCICUArrange(+icuaId)),"^",18) 
	.s ^DHCANICUDEBUG("debug",+$h,$p($h,",",2),icuaId)=$p($g(^DHCICUArrange(+icuaId)),"^",18)
	
	q retStr
CheckEquipId(equipId)
	s equipId=+equipId
	s retStr="OK"
	i equipId<=0 q "-13:equipId<=0"  
	i '$d(^DHCICUBedEquip(+equipId)) q "-13:Bed Not Exist"   //"手术间设备记录不存在!" q
	q retStr
GetDevTypeId(equipId)
	// 如RELAY设备，则获取真实的设备ID
	s equipId=$p(equipId,"~",1)
	s devTypeId=$p($g(^DHCICUBedEquip(equipId)),"^",5)
	
	s devCode=$p(^DHCANC("CType",devTypeId),"^",1)
	i ($$ALPHAUP^SSUTIL4(devCode)="RELAY")  d
	.s devCode=$p($p($g(^DHCICUBedEquip(equipId)),"^",3),"|",3)
	.s TypeId=##class(web.DHCANCCollectType).GetDevIdByCode(devCode,source)
		
	// 如果是自动识别或模拟设备，则查找设备类型Id
	i (((devCode="AutoCheckDev")||(devCode="TestDev"))) d
	.s devStr=$P(dataPara,"^",1)
	.s $p(devStr,"#",1)="VDeviceName" ;Name
	.s $p(devStr,"#",5)=extInfo ;Value
	.s dataPara=dataPara_"^"_devStr 
	.;查找设备类型Id
	.s devTypeId=##class(web.DHCANCCollectType).GetDevIdByCode(extInfo,source)
	q devTypeId
CheckStandyMode(dataPara)
	s retStr="OK"
	i $$ALPHAUP^SSUTIL4(dataPara)[$$ALPHAUP^SSUTIL4("standby") s retStr="-15:StandBy Data"
	q retStr
PatInBed(icuaId)
	s retStr="OK"
	s EpisodeID=$p(^DHCICUArrange(+icuaId),"^",1)
	s bedId=$p($g(^PAADM(EpisodeID)),"^",73)
	s bedSub=$p(bedId,"||",2)
	s icuBedId=$p($g(^DHCICUArrange(icuaId)),"^",4)
	i bedId'=icuBedId s retStr=##class(web.DHCICUCom).ReviseArrangeBedEquip(icuaId)
	i bedId'=icuBedId s retStr="-25:Patient NOT in bed"  //本次数据丢弃
	
	q retStr
IsPhilipsSameHM()
	// 如果是飞利浦传过来的血流动力学监测的参数且与上次数据不一样才继续
	s isSame="false"
	i (typeCode="PhilipsIIC")&&(dataPara["BSA") d
	.s iOrder=1
	.s dataPara=..CalculateHMByIcuaId(dataPara,icuaId) ;只通过血流参数简单计算
	.i ("false"=..IsDifferentHM(icuaId,dataPara)) s isSame="true"
	.i isSame="false" d
	..;与前一次血流动力学不一样则添加扩展计算的项目
	..s res=..GetHemodynamicExtItems(icuaId,dataPara) ;利用血气、检验计算
	..s dataPara=dataPara_"^"_res
	.e  d
	..d ..Log("GetHemodynamicExtItems-same",icuaId,dataPara)
	q isSame
GetDevTypeItemId(devTypeId,channelNo)
	s devTypeItemId=$o(^DHCANC("CType",0,"ChannelNo",channelNo,devTypeId,""))
	q devTypeItemId

GenTEMPRecordToParaItem(icuaId)
	// 通过icuaId获取个人模板Id
	s paraId=""
	s paraId=$O(^DHCICUPara(0,"ICUA",icuaId,paraId))
	i paraId'="" d
	.s sub=""
	.f  s sub=$O(^DHCICUPara(paraId,"I",sub)) q:sub=""  d
	..s itemStr=$g(^DHCICUPara(paraId,"I",sub))
	..s recordId=$p(itemStr,"^",4)
	..s mainId=$p(itemStr,"^",19)
	..q:recordId=""
	..s TEMPRecordToParaItem(recordId)=paraId_"||"_sub
	..i mainId'="" d
	...s mainSubId=$p(mainId,"||",2)
	...s mainRecordId=$p($g(^DHCICUPara(paraId,"I",mainSubId)),"^",4)
	...q:mainRecordId=""
	...s mainRecordStr=$g(^DHCICUC("RecordItem",mainRecordId))
	...s formatStr=$p(mainRecordStr,"^",25)
	...s args=$p(mainRecordStr,"^",27)
	...s TEMPRecordToParaItem(recordId,"MainItem")=mainId
	...i ((formatStr'="")&&(args'="")) d
	...s TEMPRecordToParaItem(recordId,"MainItem")=mainId_"^"_formatStr_"^"_args
	...
	q
ProInstantData
	s paraItemId=$g(TEMPRecordToParaItem(icucriId))
	b "iOrder"
	s icuOrderRowId=..Insert2ICUOrder(icuaId,icucriId,sttDate,sttTime,value,"",paraItemId)
	i isHM=1 s ^DHCANICUDEBUG("HM",+$h,$p($h,",",2),icuaId,channelNo)=value
	;建立主项子项的关系
	s paraId=$p(paraItemId,"||",1)
	s subParaItemId=$p(paraItemId,"||",2)
	i paraId'="" d
	.s paraItemStr=$g(^DHCICUPara(paraId,"I",subParaItemId))
	.s mainParaId=$p(paraItemStr,"^",19)
	.i mainParaId'="" d
	..s TEMPMainSubDic(mainParaId)=paraItemId
	..s code=$p($g(^DHCICUC("RecordItem",icucriId)),"^",1)
	..s TEMPMainSubDic(mainParaId,code)=value
	..s TEMPMainSubDic(mainParaId,"Date")=sttDate
	..s TEMPMainSubDic(mainParaId,"Time")=sttTime
	..
	q
}

// 向DHC_ICU_CollectData添加数据

// 如果该项目的当前时间点有数据了，则更新

ClassMethod InsertCollectData(icuaId, recordItemId, startDate, startTime, value = "", note = "", updateDate = "", updateTime = "")
{
	// w ##class(web.DHCICUCom).InsertCollectData(icuaId,recordItemId,startDate,startTime,value,note)
	s count=""
	i updateDate="" s updateDate=$p($h,",",1)
	i updateTime="" s updateTime=$p($h,",",2)
	
	i startDate'=+startDate s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	i startTime'=+startTime s startTime=##class(web.DHCClinicCom).ConvertToTimeH(startTime)
	i updateDate'=+updateDate s updateDate=##class(web.DHCClinicCom).ConvertToDateH(updateDate)
	i updateTime'=+updateTime s updateTime=##class(web.DHCClinicCom).ConvertToTimeH(updateTime)
	
	&sql(SELECT COUNT(ICUCD_StartDate) INTO :count 
        FROM DHC_ICU_CollectData where ICUCD_Parref=:icuaId and ICUCD_ComOrd_Dr=:recordItemId and ICUCD_StartDate=:startDate and ICUCD_StartTime=:startTime)
	s res=""
	
	i count>=1 d
	.; 当值(ICUCD_Note,ICUCD_Qty)与不同时修改;否则不修改
	.
	.&SQL(update DHC_ICU_CollectData set ICUCD_Note=:note,ICUCD_Qty=:value, ICUCD_UpdateDate=:updateDate,ICUCD_UpdateTime=:updateTime 
	where ICUCD_Parref=:icuaId and ICUCD_ComOrd_Dr=:recordItemId and 
	ICUCD_StartDate=:startDate and ICUCD_StartTime=:startTime and 
	((ICUCD_Note is null and :note<>"") or (ICUCD_Note is not null and ICUCD_Note<>:note) or 
	(ICUCD_Qty is null and :value<>"") or (ICUCD_Qty is not null and ICUCD_Qty<>:value)))
	.i SQLCODE=0 s res="Updated" // 当前时间点已经有数据
	.e  i SQLCODE=100 s res="SameData"
	e  d
	.&SQL(INSERT INTO DHC_ICU_CollectData(ICUCD_Parref,ICUCD_ComOrd_Dr,ICUCD_StartDate,ICUCD_StartTime,ICUCD_UpdateDate,ICUCD_UpdateTime,ICUCD_Note,ICUCD_Qty) values(:icuaId,:recordItemId,:startDate,:startTime,:updateDate,:updateTime,:note,:value))
	.
	.i SQLCODE=0 s res=$g(%ROWID)
	.e  s res="Error"_SQLCODE_" value["_value_"]["_note_"]"
	
	q res
}

/// Creator： ypz
/// CreatDate： 2012-11-28
/// Description： 保存数据到ICU表中
/// Table： DHC_AN_Order,DHC_AN_RoomEquip,DHC_AN_RoomEquipDetail
/// Input： opaId手术安排ID,icuaId重症监护安排ID,anreOrIcubeId手术间设备或监护床设备ID,userId;
/// para：分两级，第一级"^",第二级#。每条记录的数据。
/// chanalNo_#_sttDate_"#"_sttTime_"#"_ancoType(医嘱类型)_"#"_itemValue_"%"_itemValue2_"%"_itemValue3_"#"_ctuomId_"#"_icuoId(未用)_"#"_ancvcId_"#"_oeoriId(未用)"^"....
/// status: 当前设备任务的状态：
/// "Unstarted"：未启动
/// "Running"：正运行
/// "NetOffline"：网络问题
/// “NoData"：无数据，很可能是MOXA原因
/// Output： 
/// Return： 0-正常，1-病人ID不存在，2-未找到icuaId,3-equipId为空，4-equipId错误,其他-插入数据库有误
/// s equipId=1,anoSource="S",userId=""
/// s dataPara="Datetime#2013-04-28#11:16:56#V#2013-04-28 10:00:00####^PatientID#2013-04-28#11:16:56#V#C736539####^SampleType#2013-04-28#11:16:56#V#动脉^####^pH#2013-04-28#11:16:56#V#7.426####^pCO2#2013-04-28#11:16:56#V#29.3####^pO2(A)#2013-04-28#11:16:56#V#220####^K+#2013-04-28#11:16:56#V#3.6####^Na+#2013-04-28#11:16:56#V#136####^Ca++#2013-04-28#11:16:56#V#1.23####^Cl-#2013-04-28#11:16:56#V#112####^Glu#2013-04-28#11:16:56#V#6.5####^Lac#2013-04-28#11:16:56#V#1.1####^tHb#2013-04-28#11:16:56#V#9.0####^RHb#2013-04-28#11:16:56#V#-0.5####^O2Hb#2013-04-28#11:16:56#V#98.9####^sO2#2013-04-28#11:16:56#V#100.5####^COHb#2013-04-28#11:16:56#V#1.1####^MetHb#2013-04-28#11:16:56#V#0.5####^tBil#2013-04-28#11:16:56#V#9####^T#2013-04-28#11:16:56#V#37.0####^FIO2#2013-04-28#11:16:56#V#40.0####^p50(st)#2013-04-28#11:16:56#V#26.84####^pH(T)#2013-04-28#11:16:56#V#7.426####^pCO2(T)#2013-04-28#11:16:56#V#29.3####^HCO3-#2013-04-28#11:16:56#V#19.2####^SBE#2013-04-28#11:16:56#V#-5.2####^SBC#2013-04-28#11:16:56#V#20.5####^pO2(T)#2013-04-28#11:16:56#V#220####^pO2(A)#2013-04-28#11:16:56#V#100.3####^pO2(A),T#2013-04-28#11:16:56#V#150.3####^p50(act)#2013-04-28#11:16:56#V#25.23####^p50(act),T#2013-04-28#11:16:56#V#25.23####^AaDO2#2013-04-28#11:16:56#V#30.6####^tO2#2013-04-28#11:16:56#V#5.8####^RI#2013-04-28#11:16:56#V#14####^RI,T#2013-04-28#11:16:56#V#14####^Anion gap#2013-04-28#11:16:56#V#4.8####"
/// w ##class(web.DHCICUCom).InsertShareDev(anreOrIcubeId,anoSource,userId,dataPara,status)
ClassMethod InsertShareDevByEquipId(source, equipId As %String, extInfo As %String = "", dataPara As %String = "", status As %String = "") As %String
{
	// w ##class(web.DHCICUCom).InsertShareDev(equipId,anoSource,userId,dataPara,status)
	;s ^TMPANDEBUG("InsertShareDev")=$ztime($p($h,",",2))_equipId_","_anoSource_","_userId_","_dataPara_","
	// equipID是否在Global中
	s icuaId="" s medCareNo="" s actTime="" s ret=0 s insertStr="",SQLCODE=0,retStr=""
	// 查找病人ID
	s pId=..GetValue(dataPara,"PatientID") , isInserted=0 ,txtValue="" ,numValue=""
	s dateTime=..GetValue(dataPara,"DateTime")
	i dateTime="" q "DateTime is Null"
	s actDate=##class(web.DHCClinicCom).ConvertToDateH($p(dateTime,"~",1))
	i dateTime["~" d
	.s actTime=$zth($p(dateTime,"~",2))
	i pId="" q "1:NoPatInfo"
	// 若是检验号则通过检验号查找病人ID
	s tStr=$g(^TEPI(pId))
	i tStr'="" s pId=$p(tStr,"\",18)
	e  d
	.;认为是病案号
	.
	.s sub=0
	.f  s sub=$o(^DHCICUArrange(sub)) q:(sub="")  d
	..;i sub=157 b "s"
	..s arrangeStatus=$p($g(^DHCICUArrange(sub)),"^",18)
	..;q:arrangeStatus'="M"
	..s EpisodeID=$p(^DHCICUArrange(sub),"^",1)
	..s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
	..;s medCareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
	..s paadmtype=$p($g(^PAADM(EpisodeID)),"^",2)
	..s medCareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,paadmtype,.ErrMsg)
	..s medCareNo=$$UPPER^SSUTIL4(medCareNo)
	..i medCareNo=$$UPPER^SSUTIL4(pId) s icuaId=sub 
	

	// 通过病人ID查找icuaId
	i icuaId="" s icuaId=##class(web.DHCICUCom).GetIcuaId("",pId,"") s icuaId=$p(icuaId,"^",1)
	i icuaId=""  q "2:InvalidPatInfo"
	q:('..IsJustLeaveDept(icuaId)) "3:离开科室超过24小时"
	// 判断是否还在床位上  现改为按离开科室时间计算
	/*s bedId=$p($g(^DHCICUArrange(icuaId)),"^",4)
	q:bedId="" "床位为空"_icuaId
	s wardId=$p(bedId,"||",1)
	q:wardId="" "病区为空:DHC_ICU_Arrange数据有误"
	s EpisodeIDList=##class(web.DHCICUCom).FindWardPatient(wardId, "")
	s isInBed=0
	s patCount=$l(EpisodeIDList,"^")
	
	f i=1:1:patCount d
	.q:isInBed=1
	.s patInfo=$p(EpisodeIDList,"^",i)
	.q:patInfo=""
	.s theIcuId=$p(patInfo,"|",4)
	.i theIcuId=icuaId s isInBed=1
	q:isInBed=0 "病人已不在床位"
	*/
	s wardId=""
	s bedId=$p($g(^DHCICUArrange(icuaId)),"^",4)
	s wardId=$p(bedId,"||",1)
	// 获取设备类型ID
	////i $g(^DHCCLSet("ShareDev",anreOrIcubeId))="" q "3:Invalid EquipId" delete by dtj 2015-03-18
	////s ancctId=$p(^DHCCLSet("ShareDev",anreOrIcubeId),"^",6)
	s ancctId=$p($g(^DHCICUBedEquip(equipId)),"^",5)
	
	q:ancctId="" "-4:未知设备"
	s cStr=..GetCalculateItems(icuaId,actDate,actTime,dataPara)
	s opDateTime=""
	
	i cStr'="" d
	.s opDateTime=$p(cStr,"@",2)
	.s cStr=$p(cStr,"@",1)
	.s dataPara=dataPara_"^"_cStr
	.
	//b "插入数据库"
	// 插入数据库
	s sType=..GetValue(dataPara,"SampleType")
	s CaValue=..GetValue(dataPara,"Ca+")
	s insertStr=insertStr_"icuaId:"_icuaId_" "
	s retStr=0 s itemNum=$L(dataPara,"^")	
	f i=1:1:itemNum d
	.;查找对应常用医嘱项
	.q:retStr'=0
	.s itemStr=$P(dataPara,"^",i)
	.//w i,!
	.;i i=21 b "RATIO"
	.s icubedChannelNo=$P(itemStr,"#",1)
	.q:icubedChannelNo=""
	.s ancctiSub=$o(^DHCANC("CType",0,"ChannelNo",icubedChannelNo,ancctId,""))
	.q:ancctiSub=""
	.q:$p(^DHCANC("CType",ancctId,"I",ancctiSub),"^",3)'="Y"
	.s icucriId=$p(^DHCANC("CType",ancctId,"I",ancctiSub),"^",1)
	.q:icucriId=""
	.q:'##class(User.DHCICUCRecordItem).%ExistsId(icucriId)
	.s record=##class(User.DHCICUCRecordItem).%OpenId(icucriId)
	.s sttDate=$P(itemStr,"#",2) ;发送日期
	.s sttTime=$P(itemStr,"#",3) ;发送时间
	.
	.s sttDate=##class(web.DHCClinicCom).ConvertToDateH(sttDate)
	.i $l(sttTime,":")>1 s sttTime=$zth(sttTime)
	.s endDate=sttDate
	.s endTime=sttTime
	.s ancoOrArcimValue=$P(itemStr,"#",5)
	.;是否在医嘱配置范围内
	.s max=$p($g(^DHCICUC("RecordItem",icucriId)),"^",21)
	.s min=$p($g(^DHCICUC("RecordItem",icucriId)),"^",22)
	.q:ancoOrArcimValue>max!ancoOrArcimValue>8000000!ancoOrArcimValue<min
	.s txtValue="" s numValue=""
	.s field=$p(^DHCICUC("RecordItem",icucriId),"^",24)
	.i (field="Qty")&&(ancoOrArcimValue'="")  s numValue=+ancoOrArcimValue
	.e  s txtValue=ancoOrArcimValue
	.s SQLCODE=0
	.i ((icubedChannelNo="DeviceName")&&(txtValue="GEMPremier4000")) s txtValue="GEM4000"
	.;Ca++小于0.6时
	.i ((wardId=33)&&(record.ICUCRICode="SampleType")&&(CaValue<0.6)) s txtValue="Venous"
	.s ret=..Insert2ICUOrder(icuaId,icucriId,actDate,actTime,numValue,txtValue)
	.i ret>=0 s isInserted=1 s insertStr=insertStr_icubedChannelNo_"["_icucriId_"]"_","
	.i (cStr'="")&&("Gap;RATIO"[icubedChannelNo) d
	..s opDate=$p(opDateTime,",",1)
	..s opTime=$p(opDateTime,",",2)
	..
	..s ret=..Insert2ICUOrder(icuaId,icucriId,opDate,opTime,numValue,txtValue)
	..
	..i ret>=0 s isInserted=1 s insertStr=insertStr_icubedChannelNo_"["_icucriId_"]"_","
	..s dataPara=dataPara_"^"_cStr
	i SQLCODE'=0 q SQLCODE
	
	// 根据时间找出这一时间的生理参数(监护仪、呼吸机等)并插入到DHC_ICU_Order
	s wardIds=$g(^DHCCLSet("RecentDataWardId")) ;不需要添加最近时间的参数的科室
	s wardId=$p($p($g(^DHCICUArrange(icuaId)),"^",4),"||",1)
	s time=actTime ; sttTime-60*10
	s InsertedRecentData=""
	i ("^"_wardIds_"^")'[("^"_wardId_"^") d InsertReRecentData
	
	// 计算氧合指数	
	i sType="Arterial" d
	.s PaO2=..GetValue(dataPara,"pO2")
	.;添加PaO2,用以计算评分
	.s ret=..Insert2ICUOrder(icuaId,6596,actDate,actTime,PaO2,"")
	.i ret>=0 s insertStr=insertStr_"PaO2:"_PaO2_","
	.s FiO2=..GetICUValue(icuaId,actDate,actTime,5942) ;FiO2
	.s FiO2=+$p(FiO2,"^",1)
	.s oi=0
	.
	.i FiO2'=0 d
	..;b "FiO2'=0"
	.e  d
	..s time=(actTime\3600)*3600
	..;b "s"
	..s FiO2=..GetICUValue2(icuaId,actDate,time,5942) ;手填的FiO2
	..s FiO2=+$p(FiO2,"^",1)
	..i FiO2=0 d
	...s FlowO2=+..GetICUValue2(icuaId,actDate,time,5653) ;FlowO2氧流量
	...i FlowO2'=0 s FiO2=(FlowO2*4)+21
	...e  s FiO2=21
	.i ((FiO2<20)||(FiO2>100)) s FiO2=21
	.
	.s oi=PaO2/FiO2*100 ;氧合指数
	.i oi>0 d
	..s oi=$fn(oi,"",1)
	..s ret=..Insert2ICUOrder(icuaId,5909,actDate,actTime,oi,"")
	..i ret>=0 s isInserted=1 s insertStr=insertStr_"OI:"_oi_","
	
	
	i (isInserted=0)&&(retStr=0) s retStr="NoInsertedItem"_":"_icuaId_" "_insertStr
	q retStr_" "_icuaId_" "_insertStr_" RecentData:"_InsertedRecentData
	
	
InsertReRecentData	
	f  s time=$o(^DHCICUArrange(0,"CData",icuaId,actDate,time),-1) q:time=""  d
	.i ($zabs(actTime-time)>(20*60)) s isExit=1 q // 20分钟内数据
	.s icucdSub=""
	.f  s icucdSub=$o(^DHCICUArrange(0,"CData",icuaId,actDate,time,icucdSub)) q:icucdSub=""  d
	..s item=$g(^DHCICUArrange(icuaId,"C",icucdSub))
	..q:item=""
	..s icucriId=$p(item,"^",1)
	..q:icucriId=""
	..
	..s txtValue="" s numValue=""
	..s txtValue=$p(item,"^",4)
	..s numValue=$p(item,"^",5)
	..s ret=..Insert2ICUOrder(icuaId,icucriId,actDate,actTime,numValue,txtValue)
	..s code=$p($g(^DHCICUC("RecordItem",icucriId)),"^",1)
	..s InsertedRecentData=InsertedRecentData_code_"["_icucriId_"-"_ret_"]"_","
	..q
	q
}

/// 检查是否是血流动力学监测数据
ClassMethod IsDifferentHM(icuaId, dataPara)
{
	// w ##class(web.DHCICUCom).IsDifferentHM(icuaId,dataPara)
	s hmStr = "dPmax;MAP;C.O.;C.I.;SV;SVR;SVRI;PVRI;CCO;CCI;CFI;SVV;PPV;EVLW;EVLWI;PVPI;GEDV;GEDVI;ITBV;ITBVI;SI;SV;SVI;GEF;Tblood;CVP.;CVPm;SQI;Weight;Height;BSA;PVR;LCW;LCWI;RCWI;RVSW;RVSWI;LVSW;LVSWI;RVEF;RCW;PAWP;PAPs;PAPd;PAPm;SvO2;SaO2"
	s itemNum=$L(dataPara,"^")
	s sameCount=0
	s hmItemCount=0
	f i=1:1:itemNum d
	.s itemStr=$P(dataPara,"^",i)
	.q:itemStr=""
	.s itemName=$P(itemStr,"#",1)
	.s itemValue=$P(itemStr,"#",5)
	.i hmStr[itemName s hmItemCount=hmItemCount+1
	.s lastValue=$g(^DHCICUHM("HM",icuaId,itemName))
	.i lastValue=itemValue s sameCount=sameCount+1
	s largeNum=itemNum*(1/2.0)
	s isNew="true"
	b
	i (itemNum>2)&&(sameCount>largeNum) s isNew="false"
	q isNew
}

ClassMethod Insert2ICUOrder(icuaId As %String, icucriId As %String, date As %String, time As %String, numValue As %String, txtValue As %String, paraItemId As %String = "") As %String
{
	//i icucriId=6096 d
	//.s time=time+3600
	//.i time>(24*3600) s date=date+1 s time=0
	// 不是数值且不是文本型
	s SQLCODE=""
	q:(('$ISVALIDNUM(numValue))&&(txtValue="")) "null"
	//w ##Class(web.DHCICUCom).Insert2ICUOrder(icuaId, icucriId, date, time,numValue, txtValue)
	s rowId="" ,retStr=0
	// 查询后插入
	s isFind=0

	s sub ="" f  s sub=$O(^DHCICUOrder(0,"RecordItem",icucriId,date,icuaId,time,sub)) q:((sub="")||(isFind))  d
	.s editFlag=$p($g(^DHCICUOrder(sub)),"^",25)
	.q:editFlag=""
	.i "NE"[editFlag s isFind=1 s rowId=sub
	.
	// 已存在则修改，否则插入数据
	i isFind=1  d
	.
	.s retStr=$$UPDATE()
	e  s retStr=$$INSERT()
	q retStr
INSERT()		
	s PLIST(2)=icuaId //icuaId
	s PLIST(3)=icucriId //icucriId
	s PLIST(5)="" //userId
	s PLIST(6)=date //startDate
	s PLIST(7)=time //startTime
	s PLIST(8)=date //endDate
	s PLIST(9)=time //endTime
	s PLIST(11)=txtValue
	s PLIST(12)=numValue
	s PLIST(13)="" //ctuomId
	s PLIST(17)=$p($g(^DHCICUC("RecordItem",icucriId)),"^",5) //ancvcId
	s PLIST(18)="N" //ICUO_Flag
	s PLIST(22)=+$h //ICUO_UpdateDate
	s PLIST(23)=$p($h,",",2) //ICUO_UpdateTime
	s PLIST(24)="" //ICUO_ICUO_Dr
	s PLIST(26)="N" //ICUO_EditFlag
	s PLIST(30)="I" //ICUO_ICUO_Source
	s PLIST(31)=$p($g(^DHCICUC("RecordItem",icucriId)),"^",3) //ICUO_Type
	
	i paraItemId'="" s PLIST(39)=paraItemId
	&SQL(Insert into DHC_ICU_Order Values :PLIST())

	i SQLCODE s retStr=icuaId_":ICU SQLCODE:"_SQLCODE //icuoId"插入数据错! SQLCode="_SQLCODE
	s ^tmpICUDebug("ShareDev",$h)=SQLCODE_",rowId="_$g(%ROWID)
	w "Insert:",icucriId,!
	i (SQLCODE<0) q SQLCODE
	e  q $g(%ROWID)
	
UPDATE()
	s updateTime=$p($h,",",2)
	s updateDate=+$h
	
	&sql(update DHC_ICU_Order set ICUO_UpdateTime=:updateTime,
	 ICUO_UpdateDate=:updateDate ,
	 ICUO_Note=:txtValue,
	 ICUO_Qty=:numValue,
	 ICUO_ICUPI_Dr=:paraItemId
	 where ICUO_RowId=:rowId
	 )	
	w "Update:",rowId," ",SQLCODE,!
	i (SQLCODE<0) q SQLCODE
	e  q rowId
}

ClassMethod GetGender(EpisodeID As %String) As %String
{
	
	s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
	s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	i sex="男"  s sex="Male"
	e  s sex="Female"
	q sex
}

/// 根据医嘱ID查找某一时间点的值
ClassMethod GetICUValue(icuaId As %String, date As %String, time As %String, icucriId As %String) As %String
{
	/*
	s sub="" s numValue="" s txtValue="" s isFind=0
	f  s sub=$o(^DHCICUOrder(0,"SttDateTime",date,icuaId,time,sub)) q:((sub="")||(isFind=1))  d
	.s ctuomId=$p($g(^DHCICUOrder(sub)),"^",2)
	.i ctuomId=icucriId  d
	..s isFind=1 
	..s itemStr=^DHCICUOrder(sub)
	..s txtValue=$p(itemStr,"^",10)
	..s numValue=$p(itemStr,"^",11)
	
	q numValue_"^"_txtValue
	*/
	// w ##class(web.DHCICUCom).GetICUValue2(icuaId,actDate,time,5653)
	s sub="" s numValue="" s txtValue="" s isFind=0 s isExit=0
	s t=time+1
	d Find
	// 判断当前时间是否在零点10分内,如小于则
	i time<(10*60) d
	.s date=date-1 d Find	
	.s time=24*60*60-1
	.d Find
	
	q numValue_"^"_txtValue
Find
	f  s t=$o(^DHCICUOrder(0,"SttDateTime",date,icuaId,t),-1) q:((t="")||(isFind=1)||(isExit=1))  d
	.f  s sub=$o(^DHCICUOrder(0,"SttDateTime",date,icuaId,t,sub)) q:((sub="")||(isFind=1))  d
	..w ($zabs(t-time)>(60*60)),!
	..i ($zabs(t-time)>(60*60)) s isExit=1 q // 20分钟内数据
	..s ctuomId=$p($g(^DHCICUOrder(sub)),"^",2)
	..w t,ctuomId,!
	..
	..i ctuomId=icucriId  d
	...;b
	...s isFind=1 
	...s itemStr=^DHCICUOrder(sub)
	...s txtValue=$p(itemStr,"^",10)
	...s numValue=$p(itemStr,"^",11)
	q
}

ClassMethod GetValue(dataPara As %String, itemName As %String) As %String
{
	s itemValue=""
	s itemNum=$L(dataPara,"^")
	f i=1:1:itemNum q:itemValue'=""  d
	.s itemStr=$P(dataPara,"^",i)
	.q:itemStr=""
	.s chNo=$P(itemStr,"#",1)
	.i chNo=itemName s itemValue=$P(itemStr,"#",5) s i=itemNum	
	q itemValue
}

ClassMethod GetCalculateItems(icuaId, qDate As %String, qTime As %String, dataPara As %String)
{
	// w ##class(web.DHCANAdaptor).GetCalCulateItems(icuaId,qDate,qTime,dataPara)
	s PaO2=0,PvO2=0,CaO2=0,CvO2=0,difCO2=0,gap=0
	s curSampleType=..GetValue(dataPara,"SampleType")
	s pCO21=..GetValue(dataPara,"pCO2")
	s pO21=..GetValue(dataPara,"pO2")
	q:curSampleType=""||pCO21="" ""
	;b "s"
	i curSampleType="Arterial" s qSampleType="Venous"
	i curSampleType="Venous" s qSampleType="Arterial"
	// 获取时间
	s oppsiteDate="",oppsiteTime=""
	i (((curSampleType="Arterial")||(curSampleType="Venous"))&&((qSampleType="Arterial")||(qSampleType="Venous"))) d
	.s str=..GetValueByCode(icuaId,"SampleType",qDate,qTime,qSampleType)
	.i str="" s str=..GetValueByCode(icuaId,"SampleType",qDate,qTime+(20*60)+1,qSampleType)
	.q:str="" 	
	.s oppsiteDate=$p(str,":",1)
	.s oppsiteTime=$p(str,":",2)
	.q:oppsiteTime=qTime

	q:((oppsiteDate="")||(oppsiteTime="")) ""
	// Gap计算
	s str=..GetValueByCode(icuaId,"pCO2",oppsiteDate,oppsiteTime)
	s pCO22=$p(str,":",3)
	s str=..GetValueByCode(icuaId,"pO2",oppsiteDate,oppsiteTime)
	s pO22=$p(str,":",3)
	i curSampleType="Arterial" s PaO2=pO21,PvO2=pO22
	e  s PaO2=pO22,PvO2=pO21
	
	i pCO22'="" d
	.s gap=$zabs(pCO21-pCO22)
	.s retStr=..GetCombStr("Gap",gap,qDate,qTime)
	// RATIO计算
	s sO21=..GetValue(dataPara,"sO2")
	s str=..GetValueByCode(icuaId,"sO2",oppsiteDate,oppsiteTime)
	s sO22=$p(str,":",3)
	s atHb="" ;动脉总Hb
	i curSampleType="Arterial" s atHb=..GetValue(dataPara,"tHb")
	e  d
	.s str=..GetValueByCode(icuaId,"tHb",oppsiteDate,oppsiteTime)
	.i str'="" s atHb=$p(str,":",3)
	i atHb'="" d
	.i atHb>24 s atHb=atHb/10
	.b "Hb"
	.i curSampleType="Arterial" d
	..s CaO2=(1.34*sO21*atHb/100)+(0.003*PaO2)
	..s CvO2=(1.34*sO22*atHb/100)+(0.003*PvO2)
	.e  d 
	..s CaO2=(1.34*sO22*atHb/100)+(0.003*PaO2)
	..s CvO2=(1.34*sO21*atHb/100)+(0.003*PvO2)
	.s difCO2=CaO2-CvO2
	.
	.i difCO2'=0 d
	..s RATIO=gap/difCO2
	..s RATIO=$fn(RATIO,"",2)
	..
	..s RATIOStr=..GetCombStr("RATIO",RATIO,qDate,qTime)
	..s retStr=retStr_"^"_RATIOStr
	w "CaO2:",CaO2,"CvO2:",CvO2,"gap:",gap,"difCO2:",difCO2
	q retStr_"@"_oppsiteDate_","_oppsiteTime
Gap
	
	q gap
}

// return:date,time,numValue,txtValue

ClassMethod GetValueByCode(icuaId, code As %String, qDate As %String, qTime As %String, qStr As %String = "", scope = 20) As %String
{
	// w ##class(web.DHCANAdaptor).GetValueByCode(icuaId,code,qDate,qTime)
	s scope=scope*60
	s date=qDate
	s time=qTime+1
	s ret="" s isExit=0 
	
	d Find
	i (ret="")&&($zabs(((date*3600*24)+time)-((qDate*3600*24)+qTime))<scope) d
	.s qDate=qDate-1 s qTime=3600*24
	.d Find
	q ret
Find
	;b "s"
	f  s time=$o(^DHCICUOrder(0,"SttDateTime",date,icuaId,time),-1) q:((time="")||(isExit=1))  d
	.i $zabs(((date*3600*24)+time)-((qDate*3600*24)+qTime))>=scope s isExit=1 q
	.s sub=0
	.f  s sub=$o(^DHCICUOrder(0,"SttDateTime",date,icuaId,time,sub)) q:((sub="")||(isExit=1))  d
	..
	..s itemStr=$g(^DHCICUOrder(sub))
	..s comOrdId=$p(itemStr,"^",2) ;医嘱ID
	..s qtyValue=$p(itemStr,"^",11) ;Qty
	..s noteValue=$p(itemStr,"^",10) ;Note
	..s comOrdCode=$p($g(^DHCICUC("RecordItem",comOrdId)),"^",1) ;Code
	..i sub=61985 ;b "s"
	..i (comOrdCode=code) d
	...;b "Find"
	...i (qStr'="")&&((qStr=noteValue)||(qStr=qtyValue)) s ret=date_":"_time_":"_qtyValue_","_noteValue s isExit=1 
	...i qStr="" s ret=date_":"_time_":"_qtyValue_":"_noteValue s isExit=1 

	q
}

ClassMethod GetCombStr(itemName As %String, itemValue As %String, date As %String, time As %String) As %String
{
	s fStr="###V#####"
	s $p(fStr,"#",1)=itemName ;Name
	s $p(fStr,"#",2)=$zd(date,3) ;Date
	s $p(fStr,"#",3)=$zt(time) ;Time
	s $p(fStr,"#",5)=itemValue ;Value
	q fStr
}

// Return:patName^patSex^birth

ClassMethod GetPatICUInfo(pId As %String)
{
	s patName="" s EpisodeID="" s papmiId="" s medCareNo="" s icuaId="" s patSex="" s birth=""
	i pId="" q "1:NoPatInfo"
	// 若是检验号则通过检验号查找病人ID
	s tStr=$g(^TEPI(pId))
	s isFind="false"
	i tStr'="" s pId=$p(tStr,"\",18)
	e  d
	.;认为是病案号
	.s sub=0
	.f  s sub=$o(^DHCICUArrange(sub)) q:(sub="")||(isFind'="")  d
	..s EpisodeID=$p(^DHCICUArrange(sub),"^",1)
	..s medCareNo=$$UPPER^SSUTIL4(medCareNo)
	..i medCareNo=$$UPPER^SSUTIL4(pId) d
	...s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
	...s icuaId=sub s isFind="true" b "是病案号"
	...;s medCareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
	...s paadmtype=$p($g(^PAADM(EpisodeID)),"^",2)
	...s medCareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,paadmtype,.ErrMsg)
	...s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	...s patSex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	...s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)	
	i icuaId="" d 
	.;通过病人ID找病人信息
	.s papmiId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(pId),""))
	.q:papmiId=""
	.s isFind="true"
	.;s medCareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
	.s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	.s patSex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	.s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
	i isFind="false"  q "2:InvalidPatInfo"
	e  q patName_"^"_patSex_"^"_$zd(birth)
}

// 每小时重发前四个小时一小时之内的存入失败的检验数据

// 保证刚来的病人也可以保存检验的数据

// w ##class(web.DHCICUCom).ReStoreFailedData(iDate,ihour)

ClassMethod ReStoreFailedData(iDate As %String, ihour As %String) As %String
{
	SET $ZTRAP="ERR"
	s ihour=ihour-4
	i ihour<0 s ihour=24+ihour s iDate=iDate-1 // 0=>20,1=>19,2=>18,3=>17,4=>0,5=>1
	
	s source="I"
	s extInfo=""
	s dStr=$zd($p($h,",",1))
	s lDate=+($p(dStr,"/",2))
	s ltime=$p($h,",",2)
	s lhour=ltime\3600
	s lmin=(ltime-(lhour*3600))\60
	s lsec=ltime-(lhour*3600)-(lmin*60)
	
	s eqId="",date="",hour="",min="",sec="",sub=""
	f  s eqId=$O(^DHCANICUDEBUG("InsertToOrder",source,eqId)) q:eqId=""  d
	.f  s min=$O(^DHCANICUDEBUG("InsertToOrder",source,eqId,iDate,ihour,min))	 q:min=""  d
	..f  s sec=$O(^DHCANICUDEBUG("InsertToOrder",source,eqId,iDate,ihour,min,sec))	 q:sec=""  d
	...f  s sub=$O(^DHCANICUDEBUG("InsertToOrder",source,eqId,iDate,ihour,min,sec,sub)) q:sub=""  d
	....s resStr=$g(^DHCANICUDEBUG("InsertToOrder",source,eqId,iDate,ihour,min,sec,sub,"res"))
	....s rStr=$g(^DHCANICUDEBUG("InsertToOrder",source,eqId,iDate,ihour,min,sec,sub))
	....q:rStr=""
	....i ($E(resStr,1)'=0) d // ["InvalidPatInfo") 
	.....; opaId_","_icuaId_","_equipId_","_source_","_extInfo_","_status_","_dataPara
	.....s opaId=$p(rStr,",",1)
	.....s icuaId=$p(rStr,",",2)
	.....s equipId=$p(rStr,",",3)
	.....s source=$p(rStr,",",4)
	.....s extInfo=$p(rStr,",",5)
	.....s status=$p(rStr,",",6)
	.....s dataPara=$p(rStr,",",7)
	.....q:((opaId="")||(icuaId="")) ; 只判断共用的设备
	.....w opaId,icuaId,equipId,source,extInfo,dataPara,!
	.....;q:source'="S"
	.....;q:equipId'=5
	.....;q:dataPara'["2025505"
	.....//b //////
	.....s insertStr=..Insert2DB(icuaId,equipId,source,extInfo,dataPara,status)
	.....s i=1,isub=""
	.....f  s isub=$O(^DHCANICUDEBUG("InsertToOrder",source,equipId,lDate,lhour,lmin,lsec,isub)) q:isub=""  d
	......s i=i+1
	.....s curTime=$p($h,",",2)
	.....; 再次记录，以后不再查检入库
	.....s ^DHCANICUDEBUG("InsertToOrder",source,equipId,lDate,lhour,lmin,lsec,i,"REres")=$zt(curTime)_"=ReSend=>"_opaId_","_icuaId_","_equipId_","_source_","_extInfo_","_status_","_dataPara
	.....s ^DHCANICUDEBUG("InsertToOrder",source,equipId,lDate,lhour,lmin,lsec,i,"REres")=insertStr
	.....
	q 0
ERR
	s dateStr=$zd(+$h,3)
	s ^DHCANICUDEBUG("ReStoreFailedData",dateStr,$ztime($p($h,",",2)))=$zerror
}

ClassMethod RestoreDataByDay(ifrom, ito)
{
	// w $class(web.DHCICUCom).RestoreDataByDay(ifrom,ito)
	f day=ifrom:1:ito d
	.f hour=0:1:24 d
	..d ..ReStoreFailedData(day,hour)
}

ClassMethod TestInsert2ICUOrder(icuaId As %String, icucriId As %String, date As %String, time As %String, numValue As %String, txtValue As %String) As %String
{
	//w Class(web.DHCICUCom).TestInsert2ICUOrder(icuaId, icucriId, date, time,numValue, txtValue)
	s rowId="" ,retStr=0
	// 查询后插入
	s isFind=0
	s sub=""
	f  s sub=$o(^DHCICUOrder(0,"SttDateTime",date,icuaId,time,sub)) q:((sub="")||(isFind=1))  d
	.s ctuomId=$p($g(^DHCICUOrder(sub)),"^",2)
	.i ctuomId=icucriId s isFind=1 s rowId=sub
	.
	// 已存在则修改，否则插入数据
	i isFind=1  d
	.
	.s retStr=$$UPDATE()
	e  s retStr=$$INSERT()
	q retStr
INSERT()		
	s PLIST(2)=icuaId //icuaId
	s PLIST(3)=icucriId //icucriId
	s PLIST(5)="" //userId
	s PLIST(6)=date //startDate
	s PLIST(7)=time //startTime
	s PLIST(8)=date //endDate
	s PLIST(9)=time //endTime
	s PLIST(11)=txtValue
	s PLIST(12)=numValue
	s PLIST(13)="" //ctuomId
	s PLIST(17)=$p($g(^DHCICUC("RecordItem",icucriId)),"^",5) //ancvcId
	s PLIST(18)="N" //ICUO_Flag
	s PLIST(22)=+$h //ICUO_UpdateDate
	s PLIST(23)=$p($h,",",2) //ICUO_UpdateTime
	s PLIST(24)="" //ICUO_ICUO_Dr
	s PLIST(26)="N" //ICUO_EditFlag
	s PLIST(30)="I" //ICUO_ICUO_Source
	s PLIST(31)=$p($g(^DHCICUC("RecordItem",icucriId)),"^",3) //ICUO_Type
	&SQL(Insert into DHC_ICU_Order Values :PLIST())

	i SQLCODE s retStr=icuaId_":ICU SQLCODE:"_SQLCODE //icuoId"插入数据错! SQLCode="_SQLCODE
	s ^tmpICUDebug("ShareDev",$h)=SQLCODE_",rowId="_$g(%ROWID)
	
	q retStr
UPDATE()
	s updateTime=$p($h,",",2)
	s updateDate=+$h
	&sql(update DHC_ICU_Order set ICUO_UpdateTime=:updateTime,
	 ICUO_UpdateDate=:updateDate ,
	 ICUO_Note=:txtValue,
	 ICUO_Qty=:numValue
	 where ICUO_RowId=:rowId
	 )	
	;W "UPDATE",rowId,!
	q SQLCODE
}

ClassMethod GetIcucriIdByAncvcId(ancvcIdStr = "", ancvcCodeStr = "") As %String
{
	q:(ancvcIdStr="")&(ancvcCodeStr="") ""
	s icucoIdList=""
	i (ancvcIdStr="")&(ancvcCodeStr'="") d
		.s ancvcIdStr=""
		.f i=1:1:$l(ancvcCodeStr) d
			..s ancvcCode=$p(ancvcCodeStr,"^",i)
			..s ancvcId=""
			..i ancvcCode'="" s ancvcId=$o(^DHCICUC("ViewCat",0,ancvcCode,""))
			..q:ancvcId=""
			..i ancvcIdStr'="" s ancvcIdStr=ancvcIdStr_"^"
			..s ancvcIdStr=ancvcIdStr_ancvcId
	i ancvcIdStr'="" d
		.//s icucriId="5000"
		.s icucoId=0
		.f  s icucoId=$o(^DHCICUC("RecordItem",icucoId)) q:icucoId=""  d
			..s ancvcId=$p($g(^DHCICUC("RecordItem",icucoId)),"^",5)
			..q:("^"_ancvcIdStr_"^")'[("^"_ancvcId_"^")
			..i icucoIdList'="" s icucoIdList=icucoIdList_"^"
			..s icucoIdList=icucoIdList_icucoId
	q icucoIdList
}

/// 自动插入检验危机值数据
/// 入参：日期、时间
/// startDate:开始日期,startTime:开始时间
/// endDate：评分日期, endTime：评价时间
/// needIcuaId:icuaId
/// needWardLocId:需要评分的科室
ClassMethod AutoAddLabPanicRecord(startDate, endDate, needIcuaId = "", needWardLocId = "", ifDebug = 0) As %String
{
	//w ##class(web.DHCICUCom).AutoAddLabPanicRecord($h-1,$h,687,56,1)
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	
	s labPanicIcucriId=$o(^DHCICUC("RecordItem",0,"Code","LabPanic",""))
	q:labPanicIcucriId="" ""
	w labPanicIcucriId,!
	s orderParaList=""
	s wardCtlocId="",retStr=""
	f  s wardCtlocId=$o(^DHCICUPara(0,"Ctloc",wardCtlocId)) q:wardCtlocId=""  d
		.q:(needWardLocId'="")&(needWardLocId'=wardCtlocId)
		.s locIcupId=$o(^DHCICUPara(0,"Ctloc",wardCtlocId,""))
		.s icupiSub="",isFind=0,labPanicSub=""
		.f  s icupiSub=$o(^DHCICUPara(locIcupId,"I",icupiSub)) q:(icupiSub="")!(isFind)  d
			..s icucriId=$p(^DHCICUPara(locIcupId,"I",icupiSub),"^",4)
			..i labPanicIcucriId=icucriId s labPanicSub=icupiSub,isFind=1
		.//w "sub is: "_labPanicSub,!
		.q:labPanicSub=""
		.s linkLocId=##class(web.DHCClinicCom).GetLinkLocId(wardCtlocId)
		.//w linkLocId,!
		.s patList=##class(web.DHCICUCom).FindWardPatient("",wardCtlocId) //找当前病区病人
		.f i=1:1:$l(patList,"^") d
			..s EpisodeID=+$p(patList,"^",i)
			..s orderParaList=""
			..q:EpisodeID=0
			..s icuaId=##class(web.DHCICUCom).GetIcuaId(EpisodeID,"","")
			..//w "icuaId="_icuaId,!
			..q:icuaId=""
			..s icupId=$o(^DHCICUPara(0,"ICUA",icuaId,""))
			..q:icupId=""
			..k panicList
			..q:(needIcuaId'="")&(icuaId'=needIcuaId)
			..k dateTimeList
			..s icuoId=""
			..f  s icuoId=$o(^DHCICUOrder(0,"CommOrd",labPanicIcucriId,icuaId,icuoId)) q:icuoId=""  d
				...q:'$d(^DHCICUOrder(icuoId))
				...q:"ICD"[$p(^DHCICUOrder(icuoId),"^",25)
				...s dateTimeList(+$p(^DHCICUOrder(icuoId),"^",5),+$p(^DHCICUOrder(icuoId),"^",6))=""
			..s Config=##Class(websys.Configuration).%OpenId(1)
    		..s labDataNamespace=Config.LabDataNamespace
    		..s CurrentNS=$ZNSPACE
    		..zn labDataNamespace     //转换命名空间
			..s dprpLabNo=""
			..f  s dprpLabNo=$o(^DHCPanicReport(0,"ADM",EpisodeID,dprpLabNo)) q:dprpLabNo=""  d
				...s dprpOrder=""
				...f  s dprpOrder=$o(^DHCPanicReport(0,"ADM",EpisodeID,dprpLabNo,dprpOrder)) q:dprpOrder=""  d
					....s note=""
					....q:'$d(^DHCPanicReport(dprpLabNo,dprpOrder))
					....//w icuaId_" "_^DHCPanicReport(dprpLabNo,dprpOrder),!
					....s date=$p(^DHCPanicReport(dprpLabNo,dprpOrder),"\",1)
					....q:(date<startDate)!(date>endDate)
					....s time=$p(^DHCPanicReport(dprpLabNo,dprpOrder),"\",2)
					....//w $zd(date,3)_"/"_$zt(+time),!
					....//i $d(dateTimeList(+date,+time)) w date_"/"_$zt(+time),!
					....q:($d(dateTimeList(+date,+time))>0) //录过数据！
					....s testCode=""
					....f  s testCode=$o(^DHCPanicReport(dprpLabNo,dprpOrder,"TC",testCode)) q:testCode=""  d
						.....//w ^DHCPanicReport(dprpLabNo,dprpOrder,"TC",testCode),!
						.....s curNote=$p(^DHCPanicReport(dprpLabNo,dprpOrder,"TC",testCode),"\",1)
						.....s curNote=curNote_":"_$p(^DHCPanicReport(dprpLabNo,dprpOrder,"TC",testCode),"\",2)
						.....s curNote=curNote_"("_$p(^DHCPanicReport(dprpLabNo,dprpOrder,"TC",testCode),"\",3)_")"
						.....i note'="" s note=note_";"
						.....s note=note_curNote
					....s panicList(icuaId_","_date_","_time)=date_"^"_time_"^"_note_"^"_dprpLabNo
					....//w icuaId_"/"_date_":"_$zd(date,3)_"/"_$zt(time)_"/"_note_"^"_dprpLabNo,!
			..zn CurrentNS 
			..
			..s panicStr=""
			..f  s panicStr=$o(panicList(panicStr)) q:panicStr=""  d
				...s labNo=$p(panicList(panicStr),"^",4)
				...q:labNo=""
				...s oeordId=$o(^OEORD(0,"EpisNo",labNo,""))
				...q:oeordId=""
				...s oeoriSub=$o(^OEORD(0,"EpisNo",labNo,oeordId,""))
				...q:oeoriSub=""
				...s oeoriDeptDr=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",3) //病人所在科室
				...//w linkLocId_"/"_oeoriDeptDr_"/"_oeoriSub
				...q:("^"_linkLocId_"^")'[("^"_oeoriDeptDr_"^")
				...s $p(orderPara,$c(3),2)=icuaId
				...s $p(orderPara,$c(3),3)=labPanicIcucriId 
				...s $p(orderPara,$c(3),6)=$p(panicList(panicStr),"^",1)
				...s $p(orderPara,$c(3),7)=$p(panicList(panicStr),"^",2)
				...s $p(orderPara,$c(3),8)=$p(panicList(panicStr),"^",1)
				...s $p(orderPara,$c(3),9)=$p(panicList(panicStr),"^",2)
				...s $p(orderPara,$c(3),11)=$p(panicList(panicStr),"^",3)
				...s $p(orderPara,$c(3),17)=$p($g(^DHCICUC("RecordItem",labPanicIcucriId)),"^",5) //cat
				...s $p(orderPara,$c(3),18)="N"
				...s $p(orderPara,$c(3),22)=+$h
				...s $p(orderPara,$c(3),23)=$p($h,",",2)
				...s $p(orderPara,$c(3),26)="N"
				...//s $p(orderPara,$c(3),30)="I"
				...s $p(orderPara,$c(3),39)=icupId_"||"_labPanicSub
				...i orderParaList'="" s orderParaList=orderParaList_"^"
				...s orderParaList=orderParaList_orderPara
				...//w "  return: "_icucriId_"\"_$p(^DHCICUC("RecordItem",icucriId),"^",2)_"\"_ancoList(icucriId),"\"_
				...w orderPara,!
			..i 'ifDebug s retStr=##class(web.DHCICUOrder).SaveICUOrder(orderParaList)
	w "orderParaList:",orderParaList,!
	s ^TMPICUDEBUG("ComfirmCollectDataPanic",$h,$p($h,",",2))=orderParaList
	q retStr
	//q scoreItemStr
}

/// 按时间找当前病区的最早转入时间,有icuaId时取重症安排表的开始监护时间
/// 默认返回以delimiter分割的日期和时间字符串，format为"D"时返回内码
ClassMethod GetWardInDateTime(EpisodeID, icuaId, date = "", time = "", delimiter = "^", format = "") As %String
{
	i EpisodeID="",icuaId'="" s EpisodeID=$p($g(^DHCICUArrange(icuaId)),"^",1)
	q:(EpisodeID="") ""
	s needWardId="",inDate="",inTime=""
	i icuaId'="" d
		.s date=$p($g(^DHCICUArrange(icuaId)),"^",6),time=$p($g(^DHCICUArrange(icuaId)),"^",8)
		.s inDate=date,inTime=time
		.s needWardId=+$p(^DHCICUArrange(icuaId),"^",4)
	i inDate="" d
		.i date="" d
			..s date=+$h,time=$p($h,",",2)
		.s dateTime=date+(time/100000)
		.s curRetStr=##class(web.DHCClinicCom).GetAdmTransWardList(EpisodeID, .transWardList)
		.q:'$d(transWardList)	//没有转病区记录
		.s inDateTime=$o(transWardList(dateTime),-1)
		.i inDateTime="" s inDateTime=$o(transWardList(dateTime)) //第一个，应该不可能
		.i (needWardId'="")&(transWardList(inDateTime)'=needWardId) d
			..s nextDateTime=$o(transWardList(inDateTime)) //后找一个
			..s inDateTime=""
			..q:nextDateTime=""
			..i transWardList(nextDateTime)=needWardId s inDateTime=nextDateTime
		.q:(inDateTime="")
		.q:(needWardId'="")&(transWardList(inDateTime)'=needWardId) 
		.s inDate=$p(inDateTime,".")
		.s inTime=(inDateTime-inDate)*100000

	q:inDate="" ""
	q:(format="D") inDate_delimiter_inTime
	q $zd(inDate,3)_delimiter_##class(web.DHCClinicCom).ConvertToTime(inTime,"")
}

/// 按时间找当前病区的最早转入时间,有icuaId时取重症安排表的开始监护时间
/// 默认返回以"^"分割的日期和时间字符串,转病区前病区描述，format为"D"时返回内码
ClassMethod GetWardInInfo(EpisodeID, icuaId, date = "", time = "", format = "") As %String
{
	i EpisodeID="",icuaId'="" s EpisodeID=$p($g(^DHCICUArrange(icuaId)),"^",1)
	q:(EpisodeID="") ""
	s needWardId=""
	i icuaId'="" d
		.s date=$p($g(^DHCICUArrange(icuaId)),"^",6),time=$p($g(^DHCICUArrange(icuaId)),"^",8)
		.s needWardId=+$p(^DHCICUArrange(icuaId),"^",4)
	i date="" d
		.s date=+$h,time=$p($h,",",2)
	s dateTime=date+(time/100000)
	
	s curRetStr=##class(web.DHCClinicCom).GetAdmTransWardList(EpisodeID, .transWardList)
	q:'$d(transWardList) ""	//没有转病区记录
	s inDateTime=$o(transWardList(dateTime),-1)
	i inDateTime="" s inDateTime=$o(transWardList(dateTime)) //第一个，应该不可能
	i (needWardId'="")&(transWardList(inDateTime)'=needWardId) d
		.s nextDateTime=$o(transWardList(inDateTime)) //后找一个
		.s inDateTime=""
		.q:nextDateTime=""
		.i transWardList(nextDateTime)=needWardId s inDateTime=nextDateTime
	q:(inDateTime="") ""
	q:(needWardId'="")&(transWardList(inDateTime)'=needWardId) "" 
	s inDate=$p(inDateTime,".")
	s inTime=(inDateTime-inDate)*100000

	q:inDate="" ""
	s preWardDesc=""
	s preDateTime=$o(transWardList(inDateTime),-1)
	i preDateTime'="" d
		.s preWardId=transWardList(preDateTime)
		.s preWardDesc=$p($g(^PAWARD(+preWardId)),"^",2)
	q:(format="D") inDate_"^"_inTime_"^"_preWardDesc
	q $zd(inDate,3)_"^"_##class(web.DHCClinicCom).ConvertToTime(inTime,"")_"^"_preWardDesc
}

/// 获取转出科室时间，根据就诊号，和开始时间  todo 20130925
/// ClassMethod GetWardOutDateTime(EpisodeID As %String, startDateTime As %String = "", wardId As %String = "", icuaId As %String = "") As %String
ClassMethod GetWardOutDateTime(EpisodeID, icuaId = "", date = "", time = "", delimiter = "^", format = "") As %String
{
	i EpisodeID="",icuaId'="" s EpisodeID=$p($g(^DHCICUArrange(icuaId)),"^",1)
	
	s needWardId=""
	i icuaId'="" d
		.s date=$p($g(^DHCICUArrange(icuaId)),"^",6),time=$p($g(^DHCICUArrange(icuaId)),"^",8)
		.s needWardId=+$p(^DHCICUArrange(icuaId),"^",4)
	s icuaLeaveDate=$p($g(^DHCICUArrange(+icuaId)),"^",44)
	s icuaLeaveTime=$p($g(^DHCICUArrange(+icuaId)),"^",45)
	
	s outDateTime=""
	i icuaLeaveDate'="" d
		.s outDate=icuaLeaveDate,outTime=icuaLeaveTime,outType="L"
		.s outDateTime=outDate+(outTime/100000)
	e  d
		.//w "need:",needWardId,!
		.i date="" d
			..s date=+$h,time=$p($h,",",2)
		.s dateTime=date+(time/100000)
		.s curRetStr=##class(web.DHCClinicCom).GetAdmTransWardList(EpisodeID, .transWardList)
		.q:'$d(transWardList)	//没有转病区记录
		.s inDateTime=$o(transWardList(dateTime),-1)
		.i inDateTime="" s inDateTime=$o(transWardList(dateTime)) //第一个，应该不可能
		.i (needWardId'="")&(transWardList(inDateTime)'=needWardId) d
			..s nextDateTime=$o(transWardList(inDateTime)) //后找一个
			..s inDateTime=""
			..q:nextDateTime=""
			..i transWardList(nextDateTime)=needWardId s inDateTime=nextDateTime
		.q:(inDateTime="")
		.
		.q:(needWardId'="")&(transWardList(inDateTime)'=needWardId)
		.s inDate=$p(inDateTime,".")
		.s inTime=(inDateTime-inDate)*100000
		.;w icuaId_"inDateTime:"_inDate_"/"_inTime,!
		.s outDateTime=$o(transWardList(inDateTime))
		.s outDate=$p(outDateTime,".")
		.s outTime=(outDateTime-outDate)*100000
		.;w icuaId_"outDateTime:"_outDate_"/"_outTime,!
		.s outType=""
		.i outDateTime="" d //未转科，判断是否出院
			..//q:$p($g(^PAADM(EpisodeID)),"^",70)=+$p(^DHCICUArrange(icuaId),"^",4)
			..s outDate=$p(^PAADM(EpisodeID),"^",17)
			..s outTime=$p(^PAADM(EpisodeID),"^",18)
			..q:outDate=""
			..s outDateTime=outDate+((outTime)/100000)
			..i (outDateTime>10000)&(outDateTime<inDateTime) d
				...s outDate=inDate,outTime=inTime,outDateTime=inDateTime
			..s outType="D"
		.e  s outType="T"
	q:+outDateTime=0 "" //未出院，在科内
	i +outDateTime=0 s outDate="",outTime="",outDateTime=""
	//s dateTime=$P(dateTime,".",1)
	;w icuaId_"outDateTime:"_outDate_"/"_outTime,!
	i delimiter="" s delimiter="^"
	q:(format="D") outDate_delimiter_outTime_delimiter_outType
	q $zd(outDate,3)_delimiter_##class(web.DHCClinicCom).ConvertToTime(outTime,"")
}

/// Creator: YuPeizhi
/// CreatDate: 2013-12-28
/// Description: 根据就诊号取监护信息  
/// Table：PA_Ward,PA_Admtransaction,DHC_ICU_Arrange
/// Input：就诊号EpisodeID
/// Return：icuaId，转入病区Id，转出病区Id，入病区日期，时间，出病区日期(在病区时为空)，时间(在病区时为空)
ClassMethod GetIcuaByEpisodeID(EpisodeID) As %String
{
	q:EpisodeID="" ""
	s icuaId="",retStr=""
	f  s icuaId=$o(^DHCICUArrange(0,"Adm",EpisodeID,icuaId)) q:icuaId=""  d
		.q:'$d(^DHCICUArrange(icuaId))
		.s date=$p($g(^DHCICUArrange(icuaId)),"^",6),time=$p($g(^DHCICUArrange(icuaId)),"^",8)
		.q:date=""
		.s dateTime=date+(time/100000)
		.s curRetStr=##class(web.DHCClinicCom).GetAdmTransWardList(EpisodeID, .transWardList)
		.q:'$d(transWardList)	//没有转病区记录
		.s inDateTime=$o(transWardList(dateTime),-1)
		.i inDateTime="" s inDateTime=$o(transWardList(dateTime))
		.s wardId=+$p(^DHCICUArrange(icuaId),"^",4)
		.q:wardId'=transWardList(inDateTime)
		.s inWardId=""
		.i inDateTime'="" d
			..s preInDateTime=$o(transWardList(inDateTime),-1)
			..q:preInDateTime=""
			..s inWardId=transWardList(preInDateTime)
		.s inLocId=$p($g(^PAWARD(+inWardId)),"^",5)
		.s outDateTime=$o(transWardList(inDateTime))
		.s outWardId=""
		.i outDateTime'="" s outWardId=transWardList(outDateTime)
		.s outLocId=$p($g(^PAWARD(+outWardId)),"^",5)
		.s curStr=icuaId_"|"_inLocId_"|"_outLocId_"|"_..GetWardInDateTime("",icuaId,"",""," ")_"|"_..GetWardOutDateTime("",icuaId,"",""," ")
		.i retStr'="" s retStr=retStr_"^"
		.s retStr=retStr_curStr
	q retStr
}

ClassMethod GetAncoIdByAncvcCode(ancvcCodeList) As %String
{
	s icucriIdList=""
	i ancvcCodeList'="" d
		.s ancvcIdList=""
		.f i=1:1:$l(ancvcCodeList) d
			..s ancvcCode=$p(ancvcCodeList,"^",i)
			..s ancvcId=""
			..i ancvcCode'="" s ancvcId=$o(^DHCICUC("ViewCat",0,ancvcCode,""))
			..q:ancvcId=""
			..i ancvcIdList'="" s ancvcIdList=ancvcIdList_"^"
			..s ancvcIdList=ancvcIdList_ancvcId
		.q:ancvcIdList=""
		.s icucriId="5000"
		.f  s icucriId=$o(^DHCICUC("RecordItem",icucriId)) q:icucriId=""  d
			..s ancvcId=$p($g(^DHCICUC("RecordItem",icucriId)),"^",5)
			..q:("^"_ancvcIdList_"^")'[("^"_ancvcId_"^")
			..i icucriIdList'="" s icucriIdList=icucriIdList_"^"
			..s icucriIdList=icucriIdList_icucriId
	q icucriIdList
}

/// Creator: YuPeizhi
/// CreatDate: 2013-12-28
/// Description: 根据就诊号取监护信息  
/// Table：DHC_ICU_Arrange,DHC_ICU_Order,DHC_ICU_RecordItem
/// Input：重症排班表Id，开始日期，开始时间，结束日期，结束时间，记录项码表Id
/// Return：记录开始日期，记录开始时间，记录项码表Id，记录值
Query FindIcuRecord(icuaId, startDate, startTime, endDate, endTime, icucriId) As %Query(ROWSPEC = "startDate,startTime,icucriId,value") [ SqlProc ]
{
}

ClassMethod FindIcuRecordExecute(ByRef qHandle As %Binary, icuaId, startDate, startTime, endDate, endTime, icucriId) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	i (icuaId="")!(icucriId="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	s startTime=##class(web.DHCClinicCom).ConvertToTimeH(startTime)
	s endTime=##class(web.DHCClinicCom).ConvertToTimeH(endTime)
	i (startDate>endDate)!((startDate=endDate)&(startTime>endTime)) Set qHandle=$lb(0,repid,0) Quit $$$OK
	//s icuBedId=$p($g(^DHCICUArrange(+icuaId)),"^",4)
	s icucriDataField=$p(^DHCICUC("RecordItem",icucriId),"^",24)
	s icuoId="",isFind=0
	f  s icuoId=$o(^DHCICUOrder(0,"CommOrd",icucriId,icuaId,icuoId)) q:(icuoId="")!(isFind)  d
		.q:'$d(^DHCICUOrder(icuoId))
		.q:"ICD"[$p(^DHCICUOrder(icuoId),"^",25)
		.s icuoNote=$p(^DHCICUOrder(icuoId),"^",10)
		.s icuoQty=$p(^DHCICUOrder(icuoId),"^",11)
		.//q:(wardIdStr'="")&(("^"_wardIdStr_"^")'[("^"_(+icuBedId)_"^"))
		.s icuoStartDate=$p(^DHCICUOrder(icuoId),"^",5)
		.s icuoStartTime=$p(^DHCICUOrder(icuoId),"^",6)
		.q:(icuoStartDate<startDate)!((icuoStartDate=startDate)&(icuoStartTime<startTime))
		.//w icuoStartDate_"/"_endDate_"/"_icuoStartTime_"/"_endTime,!
		.q:(icuoStartDate>endDate)!((icuoStartDate=endDate)&(icuoStartTime>endTime)) 
		.s value=""
		.i icucriDataField="Qty" s value=icuoQty
		.i icucriDataField="Note" s value=icuoNote
		.i icucriDataField="Volume" s value=+$p(^DHCICUOrder(icuoId),"^",28)
		.//i (dataField="DateTime") s value=$zd(icuoStartDate,3)_" "_$zt(icuoStartTime,2)
		.s icuaIdList(icuaId)=""
		.s curUserId=$p(^DHCICUOrder(icuoId),"^",4)
		.s icuoSource=$p(^DHCICUOrder(icuoId),"^",29)
		.w icuoStartDate,icuoStartTime,icucriId,value,!
		.d OutputRow2
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(icuoStartDate,icuoStartTime,icucriId,value)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindIcuRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindIcuRecordExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindIcuRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindIcuRecordExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 根据医嘱ID查找某一时间点的值
ClassMethod GetICUValue2(icuaId As %String, date As %String, time As %String, icucriId As %String) As %String
{
	// w ##class(web.DHCICUCom).GetICUValue2(icuaId,actDate,time,5653)
	s sub="" s numValue="" s txtValue="" s isFind=0 s isExit=0
	s t=time+1
	d Find
	// 判断当前时间是否在零点10分内,如小于则
	i time<(10*60) d
	.s date=date-1 d Find	
	.s time=24*60*60-1
	.d Find
	
	q numValue_"^"_txtValue
Find
	f  s t=$o(^DHCICUOrder(0,"SttDateTime",date,icuaId,t),-1) q:((t="")||(isFind=1)||(isExit=1))  d
	.f  s sub=$o(^DHCICUOrder(0,"SttDateTime",date,icuaId,t,sub)) q:((sub="")||(isFind=1))  d
	..w ($zabs(t-time)>(20*60)),!
	..i ($zabs(t-time)>(20*60)) s isExit=1 q // 20分钟内数据
	..s ctuomId=$p($g(^DHCICUOrder(sub)),"^",2)
	..w t,ctuomId,!
	..
	..i ctuomId=icucriId  d
	...b
	...s isFind=1 
	...s itemStr=^DHCICUOrder(sub)
	...s txtValue=$p(itemStr,"^",10)
	...s numValue=$p(itemStr,"^",11)
	q
}

Query GetUnderlyingDisease(locID As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select %ID as Id,
		   CLCUD_Code,
		   CLCUD_Desc,
		   CLCUD_Ctloc_Dr,
		   CLCUD_SeqNo
		   from DHC_CLC_UnderlyingDisease
		   where CLCUD_Ctloc_Dr=:locID
}

// 20140909暂时使用(获取基础疾病)

Query GetUnderlyingDiseaseNew(locID As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select %ID as Id,
		   CLCUD_Code as Code,
		   CLCUD_Desc as Description,
		   CLCUD_Ctloc_Dr as LocationId,
		   CLCUD_SeqNo as SeqNo,
		   CLCUD_IsChronicDisease as IsChronicDisease
		   from DHC_CLC_UnderlyingDisease
		   where CLCUD_Ctloc_Dr=:locID
}

/// weight(kg)
/// height(cm)
ClassMethod BSA(weight, height) As %String
{
	// BSA=BW^0.425 * H^0.725 * 0.007184
	s height=height/100
	s bsa=$ZPOWER(weight,0.425) * $ZPOWER(height,0.725) * 0.007184
	q bsa
}

// height(cm)

ClassMethod PBW(height, age, sex) As %String
{
	s pbw=0
	s isAdult=1
	i age<10 s isPediatric=1
	i isAdult=1 d
	.i sex="M" s pbw=50+(0.91*(height-152.4))
	.e  s pbw=45.5+(0.91*(height-152.4))
	e  d
	.i height>152.4 d
	..i sex="M" s pbw=39+(0.89*(height-152.4))
	..e  s pbw=42.2+(0.89*(height-152.4))
	.e  d
	..s pbw=((height*height)*1.65)/1000
	
	q pbw
}

/// height(m)
ClassMethod PBSA(pbw, height) As %String
{
	s pbsa=($ZPOWER(pbw,0.425) * $ZPOWER(height,0.725)) * 0.007184 // DuBois BW >=15kg
	//s pbsa=($ZPOWER(pbw,0.5378) * $ZPOWER(height,0.3964)) * 0.024265 // Haycock BW < 15kg
	q pbsa
}

// 

ClassMethod CalculateHMByIcuaId(dataPara, icuaId)
{
	// w ##class(web.DHCICUCom).CalculateHMByIcuaId(dataPara,icuaId)
	// 查找
	s w=+..GetValue(dataPara,"Weight")
	s h=+..GetValue(dataPara,"Height")
	s bsa=+..GetValue(dataPara,"BSA")
	
	s weight=$p(^DHCICUArrange(icuaId),"^",25)
	s height=$p(^DHCICUArrange(icuaId),"^",24)
	i ((weight'=w)||(height'=h))  d
	.s $p(^DHCICUArrang(icuaId),"^",25)=w
	.s $p(^DHCICUArrang(icuaId),"^",24)=h
	
	s EpisodeID=$p($g(^DHCICUArrange(+icuaId)),"^",1)
	s sex=..GetGender(EpisodeID)
	
	i sex="Female" s sex="F"
	e  s sex="M"
	
	s item=$p(dataPara,"^",1)
	s date=$P(item,"#",2)
	s time=$P(item,"#",3)
	s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	s time=##class(web.DHCClinicCom).ConvertToTimeH(time)
	
	s map=+..GetICUValue(icuaId,date,time,5339) ; MAP(ABPm)
	
	s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
	s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
	s age=##class(web.DHCClinicCom).CalAge(birth,date)
	b
	s retStr=..CalculateHM(dataPara, w, h, bsa, age, sex,map,date,time)
	
	q retStr
}

ClassMethod CalculateHM(dataPara, weight, height, bsa, age, sex, map, date, time) As %String
{
	// w ##class(web.DHCICUCom).CalculateHM(dataPara,weight,height,bsa,age,sex,map)
	s calStr="CI;SVI;PVRI;CCI;RVSWI;LVSWI;ITBVI;GEDVI;EVLWI"
	s divBSAStr="CI;SVI;PVRI;CCI;RVSWI;LVSWI"
	s divPBSA="ITBVI;GEDVI"
	s devPBW="EVLWI"
	
	i bsa'>0
	.s bsa=..BSA(weight,height)
	s pbw=..PBW(height,age,sex)
	s pbsa=..PBSA(pbw,height)
	
	s itemNum=$L(dataPara,"^")
	f i=1:1:itemNum d
	.s itemStr=$p(dataPara,"^",i)
	.q:itemStr=""
	.s itemName=$P(itemStr,"#",1)
	.s itemValue=+$P(itemStr,"#",5)	
	.;s date=$P(itemStr,"#",2)
	.;s time=$P(itemStr,"#",3)
	.
	.i itemName="CO" s itemName="CI"
	.e  i itemName="CCO" s itemName="CCI"
	.e  s itemName=itemName_"I"
	.q:calStr[(itemName_"#")   ;只计算指数的参数
	.q:dataPara[(itemName_"#") ;只计算没有的指数
	.
	.i (";"_divBSAStr_";")[itemName d
	..s itemValue=itemValue/bsa
	..d AddToDataPara
	.e  i (";"_divPBSA_";")[itemName  d
	..s itemValue=itemValue/pbsa
	..d AddToDataPara
	.e  i (";"_devPBW_";")[itemName  d
	..s itemValue=itemValue/pbw
	..d AddToDataPara
	
	// SVRI
	// s map=+GetICUValue(icuaId,actDate,actTime,5338) ;MAP(PAP)
	s cvp=+..GetValue(dataPara,"CVP")
	s ci=+..GetValue(dataPara,"CI")
	// 未发SVRI时计算SVRI
	i ((dataPara'["SVRI")&&(map>0)&&(cvp>0)&&(ci>0)) d
	.;SVRI=[(MAP-CVP) / CI]*80
	.s itemValue=((map-cvp)/ci)*80
	.s itemName="SVRI"
	.i itemValue>0 d
	..d AddToDataPara
	.

	q dataPara
AddToDataPara
	s str=..GetCombStr(itemName,$fn(itemValue,"",2),date,time)
	s dataPara=dataPara_"^"_str
	q
}

ClassMethod GetDHCICUUnderlyingDisease(icuaId As %String) As %String
{
	s UnderlyingDiseaseDR="",ICUAID="",ROWID="",ret=""
	f  s UnderlyingDiseaseDR=$o(^DHCICUUnderlyingDisease(0,"UDisease",UnderlyingDiseaseDR)) q:UnderlyingDiseaseDR=""   d
	   .f  s ICUAID=$o(^DHCICUUnderlyingDisease(0,"UDisease",UnderlyingDiseaseDR,ICUAID)) q:ICUAID=""  d
              ..q:ICUAID'=icuaId
              ..;b ;"3"
              ..f  s ROWID=$o(^DHCICUUnderlyingDisease(0,"UDisease",UnderlyingDiseaseDR,ICUAID,ROWID)) q:ROWID=""  d
	          ...s ret=ret_"^"_$lg(^DHCICUUnderlyingDisease(ROWID),2)	
	q ret
}

/// 取数据，type:Min最低值,Max最高值,First第一个值,MinMax最低值^最高值;exactDate,exactTime准确时间
ClassMethod GetOrderValue(icuaId, icucriId, fromDate, fromTime, scope = 10, type = "First") As %String
{
	// w ##class(web.DHCICUOrder).GetOrderValue(icuaId, icucriId,fromDate, fromTime)
	q:icuaId="" ""
	q:icucriId="" ""
	q:'$d(^DHCICUC("RecordItem",icucriId))="" ""
	s icucriDataField=$p($g(^DHCICUC("RecordItem",icucriId)),"^",24)
	q:icucriDataField="" ""	
	s ^TEMPWHL("GetOrderValue",icuaId)=icuaId_"^"_icucriId
	s fromDate=##class(web.DHCClinicCom).ConvertToDateH(fromDate)
	s fromTime=##class(web.DHCClinicCom).ConvertToTimeH(fromTime)
	
	s queryDateTime=fromDate*100000+fromTime
	s minQty="",maxQty="",value="",difVal=0
	s baseIcuoId="",ifQuit=0
	
	
	// 往后查
	s seq=-1
	s date=fromDate+1
	s time=fromTime+1
	s lastDifTime=-1
	
	d Find
	s afterValue=value
	s afterDifTime=lastDifTime
	// 往前查
	s seq=1
	s date=fromDate-1
	s time=fromTime-1
	d Find
	//上次也查到了
	i afterDifTime'=-1  d
	.// 字次没查到或上次查到的值比现在的结果更接近查寻时间
	.i ((lastDifTime=-1)||(afterDifTime<lastDifTime)) s value=afterValue
	
	q:type="First" value ;最接近查询时间的值
	q:type="Min" minQty
	q:type="Max" maxQty
	q:type="MinMax" minQty_"^"_maxQty
	q:type="Exact" value
	q value
Find	
	s ifQuit=0
	s tmpDate=date
	
	f  s date=$o(^DHCICUOrder(0,"RecordItem",icucriId,date),seq) q:((date="")!(ifQuit))  d
	.
	.i date'=fromDate d
	..;日期结点与查询日期不一至，则根据查询顺序调整
	..i seq=-1 s time=3600*24-1
	..e  s time=0
	.
	.w "Day:",$zd(date)," ",!
	.f  s time=$o(^DHCICUOrder(0,"RecordItem",icucriId,date,icuaId,time),seq) q:((time="")!(ifQuit))  d
	..w "   Time:",$zt(time)," ",!
	..s dateTime=date*100000+time
	..s difVal=$zabs(dateTime-queryDateTime)
	..i difVal>(scope*60) s ifQuit=1 
	..q:ifQuit
	..s icuoId=""
	..f  s icuoId=$o(^DHCICUOrder(0,"RecordItem",icucriId,date,icuaId,time,icuoId)) q:(icuoId="")!(ifQuit)  d
	...q:'$d(^DHCICUOrder(icuoId))
	...q:"ICD"[$p(^DHCICUOrder(icuoId),"^",25)
	...s value=##class(web.DHCICUOrder).GetRecordValueSingle(icuoId,icucriDataField)
	...s lastDifTime=difVal
	...i type="First" s ifQuit=1
	...w "Find:",$zd(date)," ",$zt(time)," V:",value,!
	...i (icucriDataField="Qty")&((minQty="")!(value<minQty)) d
	....s minQty=value
	...i (icucriDataField="Qty")&((maxQty="")!(value>maxQty)) d
	....s maxQty=value
	q
}

/// 返回值格式: DateTime Value(Value1^Value1^Value3...)
///             Value的是以"^"分隔开的，数量顺序由displayIdStr而定
/// 以queryIdStr查寻时间段内scope范围内displayIdStr列出的数据
/// icuaId: DHC_ICU_Arrange的RowId
/// queryIdStr: 要查询的Id串，是逻辑与的关系，同一时间内包含所以ID才能满足条件
/// displayIdStr: 要显示的ID串
/// fromDate,fromTime: 起始时间点
/// toDate,toTime: 结束时间点 
///        toDate是0时，查询fromDate的fromTime开始fromDate这一天的数据
/// 查找显示项的时间范围，为0时精确查找
ClassMethod FindDataByRecordId(icuaId, queryIdStr, displayIdStr, fromDate, fromTime = 0, toDate = 0, toTime = 0, scope = 0) As %String
{
	// w ##class(web.DHCICUCom).FindDataByRecordId(icuaId,queryIdStr,displayIdStr,fromdate,fromTime,fromDate,fromTime)
	s fromDate=##class(web.DHCClinicCom).ConvertToDateH(fromDate)
	s toDate=##class(web.DHCClinicCom).ConvertToDateH(toDate)
	s fromTime=##class(web.DHCClinicCom).ConvertToTimeH(fromTime)
	s fromTime=##class(web.DHCClinicCom).ConvertToTimeH(toTime)
	
	i toDate=0 d
	.;查fromdate一天的数据
	.s toDate=fromDate+1
	.s toTime=0
	s daySecs=3600*24
	s fromDateTime=(daySecs*fromDate)+fromTime
	s toDateTime=(daySecs*toDate)+fromTime
	q:queryIdStr="" "queryIdStr不能为空"
	s queryIdCount=$l(queryIdStr,"^")
	s diplayIdCount=$l(displayIdStr,"^")
	
	s icucriId=$p(queryIdStr,"^",1)
	q:icucriId=""
	
	// 通过queryIdStr、fromDate、fromTime、fromDate、fromTime找出时间点
	s date=fromDate-1
	s time=fromTime-1
	s quit=0
	f  s date=$o(^DHCICUOrder(0,"RecordItem",icucriId,date)) q:((quit=1)||(date=""))  d
	.i date'=fromDate s time=""
	.i date>fromDate s quit=1 
	.
	.q:quit=1
	.f  s time=$o(^DHCICUOrder(0,"RecordItem",icucriId,date,icuaId,time)) q:((quit=1)||(time=""))  d
	..
	..s dateTime=(date*daySecs)+time
	..i dateTime>toDateTime s quit=1
	..q:quit=1
	..
	..s isAll=1
	..f i=2:1:queryIdCount q:(isAll=0)  d
	...i isAll=1 d
	....s theID=$p(queryIdStr,"^",i)
	....s theTime=$o(^DHCICUOrder(0,"RecordItem",theID,date,time))
	....i theTime="" s isAll=0
	..i isAll=1 d
	...w $zt(time)," "
	...s TimeArray(dateTime)=dateTime
	// 通过displayIdStr中的ID取各时间点的数据
	s sub=""
	f  s sub=$O(TimeArray(sub)) q:sub=""  d
	.
	.s dateTime=TimeArray(sub)
	.s qDate=dateTime\daySecs
	.s qTime=dateTime#daySecs
	.w $zd(qDate)," ",$zt(qTime),!
	.f i=1:1:diplayIdCount  d
	..
	..s recordId=$p(displayIdStr,"^",i)
	..s value=##class(web.DHCICUOrder).GetRecordValueByScope(icuaId,recordId,qDate,qTime,scope)
	..i value'="" d
	...d Store2Cache(recordId,value)
	.
 
	q "" 
Store2Cache(recordId,value)
	s code=$p($g(^DHCICUC("RecordItem",recordId)),"^",1)
	w code," ","ID:",recordId," value:",value,!
	q
}

/// 根据常用医嘱的代码获取Id
ClassMethod GetIcuriIdByCode(icucriCodeStr, delim = "^")
{
	s icucriIdStr=""
	f i=1:1:$l(icucriCodeStr,delim) d
		.s icucriCode=$p(icucriCodeStr,delim,i)
		.q:icucriCode=""
		.s $p(icucriIdStr,delim,i)=$o(^DHCICUC("RecordItem",0,"Code",icucriCode,""))
	q icucriIdStr
}

/// 本次入ICU与上次离开ICU间隔
ClassMethod GetPreIcuaIdInterval(icuaId) As %String
{
	q:icuaId="" ""
	s EpisodeID=$p(^DHCICUArrange(icuaId),"^",1)
	q:EpisodeID="" ""
	s inDateTime=##class(web.DHCICUCom).GetWardInDateTime("",icuaId,"","","^","D")
	q:inDateTime="" ""	
	s inDate=$p(inDateTime,"^"),inTime=$p(inDateTime,"^",2)
	s preInterval=""
	s preIcuaId=icuaId
	f  s preIcuaId=$o(^DHCICUArrange(0,"Adm",EpisodeID,preIcuaId),-1) q:preIcuaId=""  d
		.q:##class(web.DHCICUOrder).CheckValidICUAID(preIcuaId)="N"
		.s preOutDateTime=##class(web.DHCICUCom).GetWardOutDateTime("",preIcuaId,"","","^","D")
		.q:preOutDateTime=""
		.s preOutDate=$p(preOutDateTime,"^",1),preOutTime=$p(preOutDateTime,"^",2)
		.s curInterval=##class(web.DHCClinicCom).CalculateDuration(preOutDate,preOutTime,inDate,inTime,"H")
		.q:(preInterval'="")&(curInterval>preInterval)
		.s preInterval=curInterval
	q preInterval
}

Query FindIcons() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select %ID As Id,
		   ANI_Code As Code,
		   ANI_Desc As Description,
		   ANI_Count As PointCount,
		   ANI_Height As Height,
		   ANI_Width As Width,
		   ANI_PositionX As PositionX,
		   ANI_PositionY As PositionY,
		   ANI_LineWidth As LineWidth,
		   ANI_Shape As Shape,
		   ANI_Data As Data
		   From SQLUser.DHC_ANC_Icon
}

/// Creator：      	whl
/// CreatDate：    	2014-03-19
/// Description： 	判断监护记录是否有有效数据（未用）
/// Table：        	DHC_ICU_Order
/// Input：        	icuaId
/// Output：       是Y否N
/// Return：       
ClassMethod CheckValidICUAID(icuaId As %String = "") As %String
{
	s height=$p($g(^DHCICUArrange(icuaId)),"^",24) ;身高
	s weight=$p($g(^DHCICUArrange(icuaId)),"^",25) ;体重
    s adm=$p($g(^DHCICUArrange(icuaId)),"^",1)
    s status= $p($g(^PAADM(adm)),"^",20)
    i (status'="A")&(status'="D")  q "N"
    //s residentCtcpDr=$p($g(^DHCICUArrange(icuaId)),"^",28) ;住院医生
	//s attendingCtcpDr=$p($g(^DHCICUArrange(icuaId)),"^",29) ;主治医生
    s isHaveValidOrder="N"
    s isHaveValidIcuaId="N"
    s tmpIcuoId="",userid=""
    f  s tmpIcuoId=$o(^DHCICUOrder(0,"Arr",icuaId,tmpIcuoId)) q:(tmpIcuoId="")!(isHaveValidOrder)  d
		.s userid=$p(^DHCICUOrder(tmpIcuoId),"^",4) ;
		.q:userid="" 
		.q:("NE"'[$p(^DHCICUOrder(tmpIcuoId),"^",25)) ;
		.s isHaveValidOrder="Y"
	i (isHaveValidOrder="Y")&(height'="")&(weight'="")  s isHaveValidIcuaId="Y"	 
	q isHaveValidIcuaId
}

// 无创血压入库，对比上次参数，如果上次参数与这次完成一样，则认为是重复发送的，不入库

// 返回值: 

// 	    

//      SameNBPData:上次插入的值与本次一样,所以存入

//      插入的值

ClassMethod InsertNBP(icuaId, date, time, sys, dia, mean)
{
	// w ##class(web.DHCICUDebug).InsertNBP(icuaId,date,time,sys,dia)
	i date'=+date s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	i time'=+time s time=##class(web.DHCClinicCom).ConvertToTimeH(time)
	s res=0
	s NBPs="NSBP",NBPd="NDBP",NBPm="NMBP"
	i $g(^DHCCLSet("ICU","NBPs"))'="" s NBPs=$g(^DHCCLSet("ICU","NBPs"))
	i $g(^DHCCLSet("ICU","NBPd"))'="" s NBPd=$g(^DHCCLSet("ICU","NBPd"))
	i $g(^DHCCLSet("ICU","NBPm"))'="" s NBPm=$g(^DHCCLSet("ICU","NBPm"))
	
	s NBPsId=$O(^DHCICUC("RecordItem",0,"Code",NBPs,""))
	s NBPdId=$O(^DHCICUC("RecordItem",0,"Code",NBPd,""))
	s NBPmId=$O(^DHCICUC("RecordItem",0,"Code",NBPm,""))
	
	
	i ((NBPsId'="")&&(NBPdId'="")&&(NBPmId'="")) d
	.s lastSys=$g(^DHCANICUDEBUG("NBP",icuaId,NBPs))
	.s lastDia=$g(^DHCANICUDEBUG("NBP",icuaId,NBPd))
	.s lastMean=$g(^DHCANICUDEBUG("NBP",icuaId,NBPm))
	.
	.i ((sys'=lastSys)||(dia'=lastDia)||(mean'=lastMean)) d
	..;=========入库===================================
	..s res="N_SYS:"_..InsertCollectData(icuaId,NBPsId,date,time,sys)
	..s res=res_",N_DIA:"_..InsertCollectData(icuaId,NBPdId,date,time,dia)
	..s res=res_",N_MEAN:"_..InsertCollectData(icuaId,NBPmId,date,time,mean)
	..;=========记录===================================
	..s ^DHCANICUDEBUG("NBP",icuaId,NBPs)=sys
	..s ^DHCANICUDEBUG("NBP",icuaId,NBPd)=dia
	..s ^DHCANICUDEBUG("NBP",icuaId,NBPm)=mean
	..s ^DHCANICUDEBUG("NBP",icuaId,date,time,$h)=sys_" "_dia_" "_mean_" "_$zd(date,3)_" "_##class(web.DHCClinicCom).ConvertToTime(time)
	.e  d
	..s ^DHCANICUDEBUG("NBP",icuaId,"SameData",date,time,$h)=sys_" "_dia_" "_mean_" "_$zd(date,3)_" "_##class(web.DHCClinicCom).ConvertToTime(time)
	..s res="SameNBPData"
	q res
}

Query GetSpeedUnitList() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	SELECT %ID As Id,
	   ICUCSU_Code As Code,
	   ICUCSU_Desc As Description,
	   ICUCSU_Type As Type,
	   ICUCSU_Uom_Dr As UomId,
	   ICUCSU_Factor As Factor,
	   ICUCSU_ByPatWeight As ByPatWeight,
	   ICUCSU_BaseSpeedUnit_Dr As BaseSpeedUnitId,
	   ICUCSU_BaseUomFactor As BaseUomFactor FROM DHC_ICUC_SpeedUnit
}

ClassMethod GetHemodynamicExtItems(icuaId, dataPara)
{
	s $ZT="GetHDERROR"
	s searchTime=24*60
	s ci=..GetValue(dataPara,"CI")
	s dataDate=$P($p(dataPara,"^",1),"#",2)
	s dataTime=$P($p(dataPara,"^",1),"#",3)
	q:(dataDate=""||dataTime="") ""
	s dataDate=##class(web.DHCClinicCom).ConvertToDateH(dataDate)
	s dataTime=##class(web.DHCClinicCom).ConvertToTimeH(dataTime)
	s HbCode="HGB" ; Hb取从检验取
	s regNo=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"regNo")
	q:regNo="" ""
	s hb=+##class(web.DHCClinicCom).GetTestResultByScope("", regNo, "", HbCode, dataDate, dataTime,searchTime)
	d ..Log("GetHemodynamicExtItems",icuaId,"dataPara:"_dataPara)
	d ..Log("GetHemodynamicExtItems",icuaId,"hb"_hb)
	q:hb<=0 ""
	// CaO2=1.34×Hb×SaO2+0.003×PaO2 近动脉时间=>SaO2、PaO2
	s str=..GetValueByCode(icuaId,"SampleType",dataDate,dataTime,"Arterial",searchTime)
	
	d ..Log("GetHemodynamicExtItems",icuaId,"Arterial:"_str)
	
	q:str="" ""
	s sO2Id=##class(web.DHCICUCRecordItem).GetId("sO2")
	s pO2Id=##class(web.DHCICUCRecordItem).GetId("pO2")

	s artDate=$p(str,":",1)
	s artTime=$p(str,":",2)
	s saO2=..GetOrderValue(icuaId, sO2Id, artDate, artTime,searchTime)
	s paO2=..GetOrderValue(icuaId, pO2Id, artDate, artTime,searchTime)
	s caO2=(1.34*hb*saO2/100)+(0.003*paO2)
	s str=..GetValueByCode(icuaId,"SampleType",dataDate,dataTime,"Venous",searchTime)
	d ..Log("GetHemodynamicExtItems",icuaId,"sav2-paO2-caO2:"_saO2_"^"_paO2_"^"_caO2)
	b
	q:str="" ""
	s venDate=$p(str,":",1)
	s venTime=$p(str,":",2)
	s svO2=..GetOrderValue(icuaId, sO2Id, venDate, venTime,searchTime)
	s pvO2=..GetOrderValue(icuaId, pO2Id, venDate, venTime,searchTime)
	s cvO2=(1.34*hb*svO2/100)+(0.003*pvO2)
	d ..Log("GetHemodynamicExtItems",icuaId,"svO2-pvO2-cvO2:"_svO2_"^"_pvO2_"^"_cvO2)
	// DO2 DO2=CI×CaO2ml/（min.m2）
	s dO2=ci*caO2
	// VO2 VO2=CI×（CaO2- CvO2）ml/（min.m2 ）
	s vO2=ci*caO2-cvO2
	// O2ER O2ER= VO2/ DO2×100% 
	s o2ER=vO2/(dO2)*100
	
	s dO2=$fn(dO2,"",1)
	s vO2=$fn(vO2,"",1)
	s o2ER=$fn(o2ER,"",1)
	s res=..GetCombStr("DO2", dO2,dataDate, dataTime)
	s res=res_"^"_..GetCombStr("VO2", vO2,dataDate, dataTime)
	s res=res_"^"_..GetCombStr("O2ER", o2ER,dataDate, dataTime)
	d ..Log("GetHemodynamicExtItems",icuaId,"do2-vo2-o2ER:"_dO2_"^"_vO2_"^"_o2ER)
	q res
GetHDERROR
	s retStr=$ZERROR
	d ..Log("GetHemodynamicExtItems-Error",icuaId,$ZERROR)
	q ""
}

ClassMethod Log(type, pId, value = "", date = "", time = "")
{
	d ##class(web.DHCClinicCom).LogByPId(type,pId,value, date, time)
}

// 是否刚出科室

ClassMethod IsJustLeaveDept(icuaId, hour = 24)
{
	// w ##class(web.DHCICUCom).IsJustLeaveDept(icuaId)
	s leaveDate=0,leaveTime=0
	
	&sql(SELECT ICUA_LeaveDate,ICUA_LeaveTime into :leaveDate,:leaveTime FROM DHC_ICU_Arrange WHERE ICUA_RowId=:icuaId and ICUA_Status="T") 
	q:((+leaveDate)=0) 1
	s leaveDateTime=(leaveDate*3600*24)+leaveTime
	s now=(($h)*3600*24)+($p($h,",",2))
	s span=$zabs(now-leaveDateTime)
	q:(span<(3600*hour)) 1
	q 0
}

}
