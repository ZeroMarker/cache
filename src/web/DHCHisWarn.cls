Class web.DHCHisWarn Extends (%RegisteredObject, %XML.Adaptor)
{

/// w ##Class(web.DHCHisWarn).SaveClientInfo("192.1.1.1^COFFEE-PC")
ClassMethod SaveClientInfo(Param As %String = "") As %String
{
	s computerIP=$P(Param,"^",1)
	s computerName=$P(Param,"^",2)
	s computerName=$$upper^SSUTIL4(computerName)
	s ^DHCHisWarnNameIP(computerName)=computerIP
	q 0
}

/// w ##Class(web.DHCHisWarn).GetClientInfo("B01-JZSYS-03")
ClassMethod GetClientInfo(Param As %String = "") As %String
{
    s RetStr=""
	s RetStrIP=""
	s RetStrIP1=""
	s RetStrIP2=""
	s RetStrIP3=""
	s RetStrDesc=""
	s ResultCode=0
	s ResultDesc=""
	s ClientRowId=""
	s Param=$TR(Param," ")
	s ClientRowId=$O(^DHCWARNING(0,"Name",Param,""))
	i ClientRowId=""  d
	.s ResultCode="901"
	.s ResultDesc="终端未授权!"
	e  d
	.s QueueStr=^DHCWARNING(ClientRowId)
	.s WarComputerName=$p(^DHCWARNING(ClientRowId),"^",1)
	.s WarHospital=$p(^DHCWARNING(ClientRowId),"^",2)
	.s WarTenement=$p(^DHCWARNING(ClientRowId),"^",3)
	.I ((WarTenement'="")&&($d(^DHCTENEMENT(WarTenement)))) S WarTenement=$P(^DHCTENEMENT(WarTenement),"^",1)
	.s TWarFloor=$p(^DHCWARNING(ClientRowId),"^",4) 
	.I ((TWarFloor'="")&&($d(^DHCFLOOR(TWarFloor)))) S TWarFloor=$p(^DHCFLOOR(TWarFloor),"^",1)
	.s WarCtloc=$p(^DHCWARNING(ClientRowId),"^",5)
	.I ((WarCtloc'="")&&($d(^CTLOC(WarCtloc)))) S WarCtloc=$p($P(^CTLOC(WarCtloc),"^",2),"-",2)
	.s WarZQ =$p(^DHCWARNING(ClientRowId),"^",6)
	.I ((WarZQ'="")&&($d(^User.DHCExaBoroughD(WarZQ)))) S WarZQ=$list(^User.DHCExaBoroughD(WarZQ),5)
	.s WarRoom=$p(^DHCWARNING(ClientRowId),"^",7)
	.//s WarRoom=$TR(WarRoom,WarZQ,"")
	.//s RLenWarZQ=$L(WarZQ)
	.i WarRoom["诊区" s WarRoom=$P(WarRoom,"诊区",2)
	.s WarBZ=$p(^DHCWARNING(ClientRowId),"^",8)
	.i WarZQ=""  d
	..s WarZQ=WarBZ
	.e  d
	..i ((WarRoom'="") && (WarBZ'=""))  d
	...s WarRoom=WarRoom_WarBZ
	..i ((WarRoom="") && (WarBZ'=""))  d
	...s WarRoom=WarBZ
	.s ZKSDesc=$p(^DHCWARNING(ClientRowId),"^",9)
	.s ZKSComputerName=$p(^DHCWARNING(ClientRowId),"^",10)
	.//s RetStrIP1=$P(QueueStr,"^",10)_"!"
	.s compName1=$P(QueueStr,"^",10)
	.i compName1'="" d
	..s RLencompName1=$L(compName1,",")
	..f i=1:1:RLencompName1  d
	...s compNamei=$P(compName1,",",i)
	...s compNamei=$$ALPHAUP^SSUTIL4(compNamei)
	...q:compNamei=""
	...s compIP1=$G(^DHCHisWarnNameIP(compNamei))
	...i compIP1'=""  d
	....i RetStrIP1=""  d
	.....s RetStrIP1=compIP1_"!"
	....e  d
	.....s RetStrIP1=compIP1_"!"_RetStrIP1
	.//s RetStrIP2=$P(QueueStr,"^",12)_"!"    ^DHCHisWarnNameIP("DELLPC") = "10.160.25.185" 
	.s compName2=$P(QueueStr,"^",12)
	.i compName2'="" d
	..s RLencompName2=$L(compName2,",")
	..f i=1:1:RLencompName2  d
	...s compNamei=$P(compName2,",",i)
	...s compNamei=$$ALPHAUP^SSUTIL4(compNamei)
	...q:compNamei=""
	...s compIP2=$G(^DHCHisWarnNameIP(compNamei))
	...i compIP2'=""  d
	....i RetStrIP2=""  d
	.....s RetStrIP2=compIP2_"!"
	....e  d
	.....s RetStrIP2=compIP2_"!"_RetStrIP2
	.//s RetStrIP3=$P(QueueStr,"^",14)_"!"
	.s compName3=$P(QueueStr,"^",14)
	.i compName3'="" d
	..s RLencompName3=$L(compName3,",")
	..f i=1:1:RLencompName3  d
	...s compNamei=$P(compName3,",",i)
	...s compNamei=$$ALPHAUP^SSUTIL4(compNamei)
	...q:compNamei=""
	...s compIP3=$G(^DHCHisWarnNameIP(compNamei))
	...i compIP3'=""  d
	....i RetStrIP3=""  d
	.....s RetStrIP3=compIP3_"!"
	....e  d
	.....s RetStrIP3=compIP3_"!"_RetStrIP3
	.i RetStrIP1'=""  s RetStrIP=RetStrIP1
	.i RetStrIP2'=""  d
	..i RetStrIP=""  s RetStrIP=RetStrIP2
	..e  s RetStrIP=RetStrIP_RetStrIP2
	.i RetStrIP3'=""  d
	..i RetStrIP=""  s RetStrIP=RetStrIP3
	..e  s RetStrIP=RetStrIP_RetStrIP3
	.i (RetStrIP1="")&&(RetStrIP2="")&&(RetStrIP3="")  d
	..s ResultCode="902"
	..s ResultDesc="接收位置为空"
	.e  d
	..//s RetStrDesc=$P(QueueStr,"^",2)_$P(QueueStr,"^",3)_$P(QueueStr,"^",5)_$P(QueueStr,"^",6)_$P(QueueStr,"^",7)
	..s WarZQ=$TR(WarZQ," ")
	..s WarRoom=$TR(WarRoom," ")
	..S RetStrDesc=WarHospital_" "_WarTenement_" "_TWarFloor_" "_WarZQ_" "_WarRoom_" "
	..//s RetStr="10.150.66.26!10.150.66.25!"_"^"_RetStrDesc
	..s RetStr=RetStrIP_"^"_RetStrDesc
	..s Index=$I(^DHCHisWarnTest(+$H,"Warn","Desc"))
	..s ^DHCHisWarnTest(+$H,"Warn","Desc",Index)=$P($H,",",2)_"^"_Param_"^"_RetStr
	..//s ^WKZTemp(1)=RetStrDesc_","_RetStrIP
	..s RetStrIPB=RetStrIP1_RetStrIP2
	..s RLen=$L(RetStrIPB,"!")
	..f i=1:1:(RLen-1) d
    ...s RetStrIPStr=$P(RetStrIPB,"!",i)
    ...s RetStrIPStr=$TR(RetStrIPStr," ")
	...i RetStrIPStr'=""  s VoiceStr=##class(web.DHCVISVoiceMessage).InsertVoiceMessageWarn(RetStrDesc,RetStrIPStr)
	i ResultCode'=0  d
	.s Index=$I(^DHCHisWarnTest(+$H,"Warn","Err"))
	.s ^DHCHisWarnTest(+$H,"Warn","Err",Index)=$P($H,",",2)_"^"_Param_"^"_ResultCode_"^"_ResultDesc
	s RetXML="<Response><ResultCode>"_ResultCode_"</ResultCode><ResultDesc>"_ResultDesc_"</ResultDesc><ResultList>"_RetStr_"</ResultList></Response>"
	q RetXML
}

/// w ##Class(web.DHCHisWarn).GetClientWarnInfo("YANGJIA-PC")
ClassMethod GetClientWarnInfo(Param As %String = "") As %String
{
    s RetStr=""
	s RetStrIP=""
	s RetStrIP1=""
	s RetStrIP2=""
	s RetStrIP3=""
	s RetStrDesc=""
	s ResultCode=0
	s ResultDesc=""
	s WarnId=""
	s Param=$TR(Param," ")
	s WarnId=$O(^DHCVISWarni(0,"WarnComputerName",Param,""),-1)
	i WarnId=""  d
	.s ResultCode="901"
	.s ResultDesc="终端未授权!"
	e  d
	.s WarnStr=$g(^DHCVISWarn(WarnId))
	.s WarnComputerName=$p(WarnStr,"^",1)
	.s WarnHospitalId=$p(WarnStr,"^",2)
	.s WarnHospitalName=$p($g(^CT("HOSP",WarnHospitalId)),"^",2)
	.s WarnLocId=$p(WarnStr,"^",7)
	.s WarnLocDesc=$p($g(^CTLOC(WarnLocId)),"^",2)
	.s WarnBuildId=$p(WarnStr,"^",3)
	.s WarnBuildName=$p($g(^DHCVISBuild(WarnBuildId)),"^",2)
	.s WarnFloorId=$p(WarnStr,"^",4)
	.s WarnFloorName=$p($g(^DHCVISFloor(WarnFloorId)),"^",2)
	.s WarnClinicalId=$p(WarnStr,"^",5)
	.s WarnClinicalName=$p($g(^DHCVISClinical(WarnClinicalId)),"^",2)
	.s WarnRoomId=$p(WarnStr,"^",6)
	.s WarnRoomName=$p($g(^DHCVISRoom(WarnRoomId)),"^",2)
	.s WarnSendAddress=$p(WarnStr,"^",8)
	.s WarnSendToComputerName=$p(WarnStr,"^",9)
	
	.i WarnSendToComputerName'="" d
	..s SendToComputerNameLen=$L(WarnSendToComputerName,",")
	..f index=1:1:SendToComputerNameLen  d
	...s SendComputerName=$P(WarnSendToComputerName,",",index)
	...s SendComputerName=$$upper^SSUTIL4(SendComputerName)
	...q:SendComputerName=""
	...s SendComputerIP=$G(^DHCHisWarnNameIP(SendComputerName))
	...i SendComputerIP'=""  d
	....i RetStrIP=""  d
	.....s RetStrIP=SendComputerIP_"!"
	....e  d
	.....s RetStrIP=SendComputerIP_"!"_RetStrIP
	
	.i (RetStrIP="")  d
	..s ResultCode="902"
	..s ResultDesc="接收位置为空"
	.e  d
	..s RetStrDesc=WarnHospitalName_" "_WarnBuildName_" "_WarnFloorName_" "_WarnClinicalName_" "_WarnRoomName_" "
	..s RetStr=RetStrIP_"^"_RetStrDesc
	..s Index=$I(^DHCHisWarnTest(+$H,"Warn","Desc"))
	..s ^DHCHisWarnTest(+$H,"Warn","Desc",Index)=$P($H,",",2)_"^"_Param_"^"_RetStr
	..s RLen=$L(RetStrIP,"!")
	..f ipIndex=1:1:(RLen-1) d
    ...s RetStrIPStr=$P(RetStrIP,"!",ipIndex)
    ...s RetStrIPStr=$TR(RetStrIPStr," ")
	...i RetStrIPStr'=""  s VoiceStr=##class(web.DHCVISVoiceMessage).InsertVoiceMessageWarn(RetStrDesc,WarnId,RetStrIPStr)
	i ResultCode'=0  d
	.s Index=$I(^DHCHisWarnTest(+$H,"Warn","Err"))
	.s ^DHCHisWarnTest(+$H,"Warn","Err",Index)=$P($H,",",2)_"^"_Param_"^"_ResultCode_"^"_ResultDesc
	s RetXML="<Response><ResultCode>"_ResultCode_"</ResultCode><ResultDesc>"_ResultDesc_"</ResultDesc><ResultList>"_RetStr_"</ResultList></Response>"
	q RetXML
}

}
