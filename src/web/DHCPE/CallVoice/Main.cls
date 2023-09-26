Class web.DHCPE.CallVoice.Main Extends %Persistent
{

Parameter ServiceClassName = "web.DHCPE.CallVoice.DHCVISServiceSoap";

// DHC_VIS_VoiceClient 

// d ##class(web.DHCPE.CallVoice.Main).SendVoice("1||8","1")

/// w ##class(web.DHCPE.CallVoice.Main).SendVoice("1||2","tj01","C")
ClassMethod SendVoice(RoomID, UserID, vDetailStatus As %String = "")
{
	s $ZT="SendVoiceErr"
	q:RoomID="" ""
	
	/// 叫号的时候传当前IP对应的诊室信息 by sunxintao 20210801
	s CurIP=##Class(ext.util.String).ClientIP()
	s CallRoomID=$p(##Class(web.DHCPE.RoomManager).GetRoomIDByComputeNew(CurIP),"$",1)
	/// 叫号的时候传当前IP对应的诊室信息 end
	s:(CallRoomID="") CallRoomID=RoomID
	s RoomInfo=..GetInfoByRoomID(CallRoomID)
	s PatientInfoObj=##class(web.DHCPE.CallVoice.Entity.PatientInfo).%New()
	s PatientInfoObj.WindowName=$P(RoomInfo,"^",1)
	s PatientInfoObj.WindowIP=$P(RoomInfo,"^",2)
	s PatientInfoObj.WindowDoctor=$P(RoomInfo,"^",3)
	s PatientInfoObj.WindowDocPro=$P(RoomInfo,"^",4)
	s PatientInfoObj.WindowDept=$P(RoomInfo,"^",5)
	s PatientInfoObj.WindowNote=$P(RoomInfo,"^",6)
	s ShowNum=$P(RoomInfo,"^",3)
	s:ShowNum="" ShowNum=7
	s i=0
	s Sort=""
	f  s Sort=$O(^User.DHCPEAdmRoomRecordI("StatusSortIndex"," N"," "_RoomID,Sort)) q:Sort=""  d
	.s PAADM=""
	.f  s PAADM=$O(^User.DHCPEAdmRoomRecordI("StatusSortIndex"," N"," "_RoomID,Sort,PAADM)) q:PAADM=""  d
	..s Adm=$P(PAADM," ",2)
	..s ID=""
	..f  s ID=$O(^User.DHCPEAdmRoomRecordI("StatusSortIndex"," N"," "_RoomID,Sort,PAADM,ID)) q:ID=""  d
	...s DetailStatus=$LG(^User.DHCPEAdmRoomRecordD(ID),9)
	...q:DetailStatus="E"
	...q:i=ShowNum
	...s i=i+1
	...i (DetailStatus'="")&&(vDetailStatus="C") d
	....s obj=..SetPatientObj("V", Adm,Sort)
	....d PatientInfoObj.VisitingPatients.Insert(obj)
	...e  d
	....s obj=..SetPatientObj("W", Adm,Sort)
	....d PatientInfoObj.WaitingPatients.Insert(obj)
	i i=0
	{
		b ;i-0
		d ..SendClearInfo(RoomID)
		q 0
	}
	/*
	s Sort=""
	f  s Sort=$O(^User.DHCPEAdmRoomRecordI("StatusSortIndex"," P"," "_RoomID,Sort)) q:Sort=""  d
	.s PAADM=""
	.f  s PAADM=$O(^User.DHCPEAdmRoomRecordI("StatusSortIndex"," P"," "_RoomID,Sort,PAADM)) q:PAADM=""  d
	..s Adm=$P(PAADM," ",2)
	..s ID=""
	..f  s ID=$O(^User.DHCPEAdmRoomRecordI("StatusSortIndex"," P"," "_RoomID,Sort,PAADM,ID)) q:ID=""  d
	...q:i=ShowNum
	...s i=i+1
	...;s obj=##class(web.DHCPE.CallVoice.Entity.SkipPatient).%New()
	...s obj=..SetPatientObj("S", Adm,Sort)
	...d PatientInfoObj.SkipPatients.Insert(obj)
	*/
	s rtn=PatientInfoObj.XMLExportToString(.XML,"PatientInfo")
	b ;XML
	s rtn=..SendInfo(XML)
	b ;111
	q rtn
SendVoiceErr
	q "Err"_$ZERROR
}

ClassMethod SetPatientObj(Type, PAADM, Sort)
{
	i Type="V" d
	.s obj=##class(web.DHCPE.CallVoice.Entity.VisitingPatient).%New()
	e  i Type="W"  d
	.s obj=##class(web.DHCPE.CallVoice.Entity.WaitingPatient).%New()
	e  d
	.s obj=##class(web.DHCPE.CallVoice.Entity.SkipPatient).%New()
	s PAADMObj=##class(User.PAAdm).%OpenId(PAADM)
	s obj.Name=PAADMObj.PAADMPAPMIDR.PAPMIName
	s obj.Sex=PAADMObj.PAADMPAPMIDR.PAPMISexDR.CTSEXDesc
	s obj.Priority="普通"
	s obj.QueueNo=Sort
	s obj.RegisterNo=PAADMObj.PAADMPAPMIDR.PAPMIIPNo
	s obj.Department=PAADMObj.PAADMDepCodeDR.CTLOCDesc
	q obj
}

ClassMethod SendClearInfo(RoomID)
{
	;d ##class(web.DHCPE.CallVoice.Main).SendClearInfo("2||50")
	s RoomInfo=..GetInfoByRoomID(RoomID)
	s Info="<PatientInfo><WindowName>"_$P(RoomInfo,"^",1)_"</WindowName><WindowIP>"_$P(RoomInfo,"^",2)_"</WindowIP>"
	s Info=Info_"<WindowDoctor></WindowDoctor><WindowNote></WindowNote><VisitingPatient><Name></Name><Sex></Sex><Priority></Priority><QueueNo></QueueNo><RegisterNo></RegisterNo><Department></Department></VisitingPatient><WaitingPatient><Name></Name><Sex></Sex><Priority></Priority><QueueNo></QueueNo><RegisterNo></RegisterNo><Department></Department></WaitingPatient></PatientInfo>"
	//s ^wrz("Clear")=Info
	d ..SendInfo(Info)
}

ClassMethod GetInfoByRoomID(RoomID)
{
	//w ##class(web.DHCPE.CallVoice.Main).GetInfoByRoomID("1||10")
	s RoomDesc=$LG(^User.DHCPEAreaD(+RoomID,"ChildRoom",$P(RoomID,"||",2)),3)
	s ShowNum=$LG(^User.DHCPEAreaD(+RoomID,"ChildRoom",$P(RoomID,"||",2)),15)
	s Sub=$O(^User.DHCPEAreaD(+RoomID,"ChildRoom",$P(RoomID,"||",2),"childIP",0))
	s IP=""
	s:Sub'="" IP=$LG(^User.DHCPEAreaD(+RoomID,"ChildRoom",$P(RoomID,"||",2),"childIP",Sub),2)
	q RoomDesc_"^"_IP_"^"_ShowNum
}

ClassMethod SendInfo(XmlStr)
{
	;q
	;d ##class(web.DHCPE.CallVoice.Main).SendInfo("")
	s LocID=""
	i $d(%session){
		s LocID=%session.Get("LOGON.CTLOCID")
	}
	s:(LocID="") LocID=105
	s CallVoiceFlag=$G(^DHCPESetting("DHCPE","CallVoice",LocID))
	q:CallVoiceFlag'="Y" 0
	//s XmlStr="<PatientInfo><WindowName>心电图１室</WindowName><WindowIP>B09-TJZX-51</WindowIP></PatientInfo>"
	s XmlStr=##class(web.DHCPE.Public.Setting).Replace(XmlStr,"<VisitingPatients>","")
	s XmlStr=##class(web.DHCPE.Public.Setting).Replace(XmlStr,"</VisitingPatients>","")
	s XmlStr=##class(web.DHCPE.Public.Setting).Replace(XmlStr,"<WaitingPatients>","")
	s XmlStr=##class(web.DHCPE.Public.Setting).Replace(XmlStr,"</WaitingPatients>","")
	s XmlStr=##class(web.DHCPE.Public.Setting).Replace(XmlStr,"<SkipPatients>","")
	s XmlStr=##class(web.DHCPE.Public.Setting).Replace(XmlStr,"</SkipPatients>","")
	s VisitNull="<VisitingPatient><Name></Name><Sex></Sex><Priority></Priority><QueueNo></QueueNo><RegisterNo></RegisterNo><Department></Department></VisitingPatient>"
	//如果没有就诊队列，添加一个空的就诊队列
	i $L(XmlStr,"<VisitingPatient>")=1 d
	.s XmlStr=$P(XmlStr,"<WaitingPatient>",1)_VisitNull_"<WaitingPatient>"_$P(XmlStr,"<WaitingPatient>",2,$L(XmlStr,"<WaitingPatient>"))
	;s i=$i(^wrzXML)
	;s ^wrzXML(i)=XmlStr
	//s XmlStr="<PatientInfo><WindowName>耳鼻喉1室</WindowName><WindowIP>lenovo-bf7dddbe</WindowIP><WindowDoctor></WindowDoctor><WindowNote></WindowNote><VisitingPatient><Name></Name><Sex></Sex><Priority></Priority><QueueNo></QueueNo><RegisterNo></RegisterNo><Department></Department></VisitingPatient><WaitingPatient><Name>张金海</Name><Sex>!</Sex><Priority>普通</Priority><QueueNo>1272</QueueNo><RegisterNo>TEP64373</RegisterNo><Department>耳鼻喉1室</Department></WaitingPatient><WaitingPatient><Name>徐士荃</Name><Sex>!</Sex><Priority>普通</Priority><QueueNo>1278</QueueNo><RegisterNo>TEP64361</RegisterNo><Department>耳鼻喉1室</Department></WaitingPatient><WaitingPatient><Name>吴铮</Name><Sex>!</Sex><Priority>普通</Priority><QueueNo>1280</QueueNo><RegisterNo>TEJC4157</RegisterNo><Department>耳鼻喉1室</Department></WaitingPatient><WaitingPatient><Name>薛红</Name><Sex>!</Sex><Priority>普通</Priority><QueueNo>1315</QueueNo><RegisterNo>TEJC4154</RegisterNo><Department>耳鼻喉1室</Department></WaitingPatient><WaitingPatient><Name>许君文</Name><Sex>!</Sex><Priority>普通</Priority><QueueNo>1318</QueueNo><RegisterNo>TEFJ1582</RegisterNo><Department>耳鼻喉1室</Department></WaitingPatient></PatientInfo>"
	q:(XmlStr="") 0
	s index=$i(^DHCPERecord("web.DHCPE.CallVoice.Main).SendInfo",+$H))
	s ^DHCPERecord("web.DHCPE.CallVoice.Main).SendInfo",+$H,index)=XmlStr
	
	s Rtn=##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000056",XmlStr)
	//s ClsObj=$ZOBJCLASSMETHOD(..#ServiceClassName,"%New")
	//s Rtn=0 //ClsObj.RisSendVoice(XmlStr)
	s ^DHCPERecord("web.DHCPE.CallVoice.Main).SendInfo",+$H,index,"Rtn")=Rtn
	q Rtn
}

Storage Default
{
<Data name="MainDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.CallVoice.MainD</DataLocation>
<DefaultData>MainDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCPE.CallVoice.MainD</IdLocation>
<IndexLocation>^web.DHCPE.CallVoice.MainI</IndexLocation>
<StreamLocation>^web.DHCPE.CallVoice.MainS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
