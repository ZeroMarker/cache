/// Description:处方追踪查询相关
/// Creator:    hulihua
/// CreateDate: 2017-12-22
/// Table:		OE_OrdItem、DHC_PhaPresTrack-处方追踪主表、DHC_PhaPresTrackItm-处方追踪子表、DHC_PhaPreState-处方状态表     
Class web.DHCINPHA.HMPresTrack.PresTrackQuery Extends (%RegisteredObject, websys.Abstract) [ ClassType = "" ]
{

/// Description:获取某病区所有在院病人的处方信息
/// Creator:	hulihua
/// CreateDate:	2018-01-08
/// Table:      DHC_PhaPresTrack-处方追踪主表
/// Input:		每页行数、页数、科室ID
/// Output:		登记号、住院号、姓名、床号、处方号、就诊日期、就诊病区
/// Return：    
/// Debug:		w ##class(web.DHCINPHA.HMPresTrack.PresTrackQuery).jsGetWardPatPresList("50","1","199")
ClassMethod jsGetWardPatPresList(rows, page, params) As %String
{
	//s ^hlh($h)=$lb(rows, page, params)
	q:params="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson()
	i $g(page)="" s page=1
	i $g(rows)="" s rows=50
	s End = page*rows
	s Start=(page-1)*rows+1
	s WardLocId=$p(params,"^",1)
	s InputAdm=$p(params,"^",2)
	s InputPrescNo=$p(params,"^",3)
	s pid=##class(web.DHCINPHA.MTCommon.CommonUtil).NewPid($this)
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp($this,"jsGetWardPatPresList",pid,"PATPRESC")
	s n=0
	i InputAdm=""  d
	.s LocEmerType=$P($G(^CTLOC(WardLocId)),"^",13)
	.Q:LocEmerType'="W"	
	.S EmerWard=$O(^PAWARD(0,"WARD_LocationDR",WardLocId,""))
	.Q:EmerWard=""
	.S WardItem=EmerWard
	.s RoomDr=0
	.f  s RoomDr=$O(^PAADMi("CurrWard",WardItem,RoomDr)) q:RoomDr=""  d
	..s PAAdm=0
	..f  s PAAdm=$O(^PAADMi("CurrWard",WardItem,RoomDr,PAAdm)) q:PAAdm=""  d
	...q:'$d(^PHAPRESTRACKi("PatAdmPresc",PAAdm))
	...s PAADMVisitStatus=$p(^PAADM(PAAdm),"^",20)
	...q:PAADMVisitStatus="D"
	...s prescNo=""
	...f  s prescNo=$o(^PHAPRESTRACKi("PatAdmPresc",PAAdm,prescNo)) q:prescNo=""  d
	....s ord=$o(^OEORD(0,"PrescNo",prescNo,""),-1)
	....q:ord="" 
	....d SetTmpGlobal
	...
	..
	.s AdmItm=0
	.f  s AdmItm=$O(^PAWARDA(WardItem,"WADM",AdmItm)) q:AdmItm=""  d
	..s PAAdm=$P(^PAWARDA(WardItem,"WADM",AdmItm),"^",1)
	..q:'$d(^PHAPRESTRACKi("PatAdmPresc",PAAdm))
	..s PAADMVisitStatus=$p(^PAADM(PAAdm),"^",20)
	..q:PAADMVisitStatus="D"
	..s prescNo=""
	..f  s prescNo=$o(^PHAPRESTRACKi("PatAdmPresc",PAAdm,prescNo)) q:prescNo=""  d
	...s ord=$o(^OEORD(0,"PrescNo",prescNo,""),-1)
	...q:ord="" 
	...s index=PAAdm_","_prescNo
	...q:$d(^TMP("DHCINPHA",$this,"jsGetWardPatPresList",pid,"PATPRESC",index))
	...d SetTmpGlobal
	..
	.
	e  d
	.s prescNo=""
	.s PAAdm=InputAdm
	.s WardItem=$p(^PAADM(PAAdm),"^",70)
	.q:'$d(^PHAPRESTRACKi("PatAdmPresc",PAAdm))
	.f  s prescNo=$o(^PHAPRESTRACKi("PatAdmPresc",PAAdm,prescNo)) q:prescNo=""  d
	..s ord=$o(^OEORD(0,"PrescNo",prescNo,""),-1)
	..q:ord="" 
	..s index=PAAdm_","_prescNo
	..q:$d(^TMP("DHCINPHA",$this,"jsGetWardPatPresList",pid,"PATPRESC",index))
	..d SetTmpGlobal
	.
	q:n=0 ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEmptySign(n) //输出空的json串
	// 输出Json数据
	s countrecords=n
    i End>countrecords s End=countrecords
	s Title1="TPatNo^TPameNo^TPatName^TBedNo^TPrescNo"
	s Title2="TAdmDate^TWardDesc^TPreFormType^TPhaDate^TPhaUserName"
	s Title3="TAddOrdDate^TFactor^TSeekDate^TSeekUserName"
	s Title=Title1_"^"_Title2_"^"_Title3
	s count=0
	s Index=""
	f  s Index=$o(^TMP("DHCINPHA",$this,"jsGetWardPatPresList",pid,"PATPRESC",Index)) q:Index=""  d
	.s mdata=^TMP("DHCINPHA",$this,"jsGetWardPatPresList",pid,"PATPRESC",Index)
	.s count=count+1
	.q:(count<Start)||(count>End)
    .i count=Start d
	..w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonStartStringJqGrid(countrecords,rows)
	..w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	.i count=End w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEndSign()
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp($this,"jsGetWardPatPresList",pid,"PATPRESC")
	q ""
	
SetTmpGlobal
	q:(InputPrescNo'="")&&(InputPrescNo'=prescNo)
	s queId = +##class(PHA.HERB.Com.Method).PrescCYQueId(prescNo)
	q:(queId = 0)	// 过滤非草药处方
	s AdmDate=$P($g(^PAADM(PAAdm)),"^",6)
	s AdmDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(AdmDate)
	s patinfo=##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).GetPatInfo(PAAdm)
	s PatNo=$p(patinfo,"^",1)
	s PatName=$p(patinfo,"^",3)
	s PameNo=$p(patinfo,"^",12)
 	s bedNo=$p(patinfo,"^",13)
 	s WardDesc=$p(^PAWARD(WardItem),"^",2)
 	s preOrdStr=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPreOrdInfo(prescNo)
 	s SeekUserName=$p(preOrdStr,"^",3)
 	s SeekDate=$p(preOrdStr,"^",4)
 	s prescStr=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPaQueInfo(prescNo)
 	s Factor=$p(prescStr,"^",2)
	s PreFormType=$p(prescStr,"^",8)
	s AddOrdDate=$p(prescStr,"^",25)
	s PhaomInfo=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPhaomInfo(prescNo,"N")
	s PhaDate=$p(PhaomInfo,"^")
	s PhaUserName=$p(PhaomInfo,"^",3)
 	s index=PAAdm_","_prescNo
	s Data1=PatNo_"^"_PameNo_"^"_PatName_"^"_bedNo_"^"_prescNo
	s Data2=AdmDate_"^"_WardDesc_"^"_PreFormType_"^"_PhaDate_"^"_PhaUserName
	s Data3=AddOrdDate_"^"_Factor_"^"_SeekDate_"^"_SeekUserName
	s n=n+1
	s ^TMP("DHCINPHA",$this,"jsGetWardPatPresList",pid,"PATPRESC",index)=Data1_"^"_Data2_"^"_Data3
	q
}

/// Description:通过处方号获取处方追踪信息的json串
/// Creator:	hulihua
/// CreateDate:	2018-01-09
/// Table:      DHC_PhaPresTrack-处方追踪主表、DHC_PhaPresTrackItm-处方追踪子表
/// Input:		prescno-处方号
/// Output:		患者姓名、床号、住院号
/// Return：    
/// w ##class(web.DHCINPHA.HMPresTrack.PresTrackQuery).GetPresTrackJsonByPres("I220111000056")
ClassMethod GetPresTrackJsonByPres(prescno) As %String
{
	//s ^PHATMP("myq",$this,"GetPresTrackJsonByPres") = $lb(prescno)
	s json = ##Class(Code.JsonObj).%New(),count = 0
	q:prescno="" json
	s phaptid=$o(^PHAPRESTRACKi("PRESCNO",prescno,""),-1)
	q:phaptid="" json
	s phaptch=0
	f  s phaptch=$o(^PHAPRESTRACK(phaptid,"I",phaptch))  q:phaptch=""  d
	.s tmp=""
	.s PhaPreStaDr=$p(^PHAPRESTRACK(phaptid,"I",phaptch),"^",5)
	.s PhaPreStaCode=$p(^DHCPHAPSTATE(PhaPreStaDr),"^",1)
	.s ExecuteUserId=$p(^PHAPRESTRACK(phaptid,"I",phaptch),"^",2)
	.s ExecuteUser=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetUserInfoById(ExecuteUserId),"^",2)
	.s ExecuteDate=$p(^PHAPRESTRACK(phaptid,"I",phaptch),"^",3)
	.s ExecuteDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ExecuteDate)
	.s ExecuteTime=$p(^PHAPRESTRACK(phaptid,"I",phaptch),"^",4)
	.s ExecuteTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(ExecuteTime)
	.s PhaPreStatue=$p(^DHCPHAPSTATE(PhaPreStaDr),"^",2)
	.s ExeLocDr=$p(^PHAPRESTRACK(phaptid,"I",phaptch),"^",6)
	.s ExeLoc=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetLocInfoById(ExeLocDr),"^",2)
	.s Oeore=$p(^PHAPRESTRACK(phaptid,"I",phaptch),"^",1)
	.i Oeore'="" d
	..s OeoreDate=$p(^OEORD(+Oeore,"I",$p(Oeore,"||",2),"X",$p(Oeore,"||",3)),"^",1)
	..s OeoreDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(OeoreDate)
	..s OeoreTime=$p(^OEORD(+Oeore,"I",$p(Oeore,"||",2),"X",$p(Oeore,"||",3)),"^",2)
	..s OeoreTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(OeoreTime)
	..s PhaPreStatue=PhaPreStatue_"（理论执行日期:"_OeoreDate_" "_OeoreTime_"）"
	.s PhaPti=phaptid_"||"_phaptch
	.s tmp=PhaPti_"^"_ExecuteUser_"^"_ExecuteDate_"^"_ExecuteTime_"^"_PhaPreStatue_"^"_ExeLoc
	.s count=count+1
	.d json.InsertRowData(tmp)
	s colNameStr="TId^TExecuteUser^TExecuteDate^TExecuteTime^TPhaPreStatue^TExeLoc"
	s resultString = json.getWriteJsonData(colNameStr,count)
	k json
	Q resultString
}

Storage Default
{
<Data name="PresTrackQueryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCINPHC625.PresTrackQueryD</DataLocation>
<DefaultData>PresTrackQueryDefaultData</DefaultData>
<IdLocation>^web.DHCINPHC625.PresTrackQueryD</IdLocation>
<IndexLocation>^web.DHCINPHC625.PresTrackQueryI</IndexLocation>
<StreamLocation>^web.DHCINPHC625.PresTrackQueryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
