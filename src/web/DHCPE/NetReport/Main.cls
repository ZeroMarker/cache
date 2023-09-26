Class web.DHCPE.NetReport.Main Extends %RegisteredObject
{

Parameter ServiceClassName = "web.DHCPE.NetReport.WebServiceHttpPort";

Parameter NetReportMode = "Interface";

// d ##class(web.DHCPE.NetReport.Main).Main(16488182)

ClassMethod Main(PAADM)
{
	/*
	s ResultInfo=..GetResult(PAADM)
	;d WebServiceObj.ISSOrderResult(ResultInfo)
	q
	*/
	s $ZT="MainErr"
	s LocID=$P(^PAADM(PAADM),"^",4)
	s NetReportFlag=$G(^DHCPESetting("DHCPE","NetReport",LocID))
	q:NetReportFlag'="Y" 0
	
	i ..#NetReportMode="Interface"
	{
		d ..SetReportData(PAADM)
		q ""
	}
	s ret=..CheckSendReport(PAADM)
	;q:ret'="" 
	
	s StartTime=$P($H,",",2)
	s UserInfo=..GetUserInfo(PAADM)
	s WebServiceObj=$ZOBJCLASSMETHOD(..#ServiceClassName,"%New")
	;1基本信息WebService
	i $P(UserInfo,"^",1)=0 d
	.s UserInfo=$P(UserInfo,"^",2)
	.s ^TempDHCPE("NetReport","UserInfo")=UserInfo
	.d WebServiceObj.IuserInfo(UserInfo)   
	
	;b ;1IuserInfo
	;2 ADM信息
	s CheckInfo=..GetCheckInfo(PAADM)
	i $P(CheckInfo,"^",1)=0 d
	.s CheckInfo=$P(CheckInfo,"^",2)
	.s ^TempDHCPE("NetReport","CheckInfo")=CheckInfo
	.d WebServiceObj.ICheckMainInfo(CheckInfo) 
	;b ;2ICheckMainInfo
	;3、4医嘱信息  科室小结
	s ResultInfo=..GetSOrderInfo(PAADM)
	i $P(ResultInfo,"^",1)=0 d
	.s CheckInfo=$P(CheckInfo,"^",2)
	.s OrderInfo=$P(ResultInfo,"^",2)
	.s ^TempDHCPE("NetReport","OrderInfo")=OrderInfo
	.d WebServiceObj.ISSOrderInfo(OrderInfo)
	.;b ;3ISSOrderInfo
	.s StationSummarizeInfo=$P(ResultInfo,"^",3)
	.s ^TempDHCPE("NetReport","StationSummarizeInfo")=StationSummarizeInfo
	.d WebServiceObj.IStationSummarize(StationSummarizeInfo)  
	.;b ;4IStationSummarize
		
	;5建议
	s DiagnosisInfo=..GetDiagnosisInfo(PAADM)
	i $P(DiagnosisInfo,"^",1)=0 d
	.s DiagnosisInfo=$P(DiagnosisInfo,"^",2)
	.s ^TempDHCPE("NetReport","DiagnosisInfo")=DiagnosisInfo
	.d WebServiceObj.IDiagnosisInfo(DiagnosisInfo)  
	;b ;5IDiagnosisInfo
	;6小结结果
	s SSResult=..GetSSResult(PAADM)
	i $P(SSResult,"^",1)=0 d
	.s SSResult=$P(SSResult,"^",2)
	.s ^TempDHCPE("NetReport","SSResult")=SSResult
	.d WebServiceObj.ISSResult(SSResult)  
	.//w SSResult
	;小结建议
	s SSDiagnosis=..GetSSDiagnosis(PAADM)
	i $P(SSDiagnosis,"^",1)=0 d
	.s SSDiagnosis=$P(SSDiagnosis,"^",2)
	.s ^TempDHCPE("NetReport","SSDiagnosis")=SSDiagnosis
	.d WebServiceObj.ISSDiagnosis(SSDiagnosis)  
	;b ;7ISSDiagnosis
	//结果
	s ResultInfo=..GetResult(PAADM)
	s EndTime=$P($H,",",2)
	
MainErr
	q ""
}

ClassMethod CheckSendReport(PAADM)
{
	s AdmObj=##class(User.PAAdm).%OpenId(PAADM)
	s hisregno=AdmObj.PAADMPAPMIDR.PAPMINo
	s cardno=AdmObj.PAADMPAPMIDR.PAPMIDVAnumber
	q:cardno="" "证件号码为空" ;不允许发送
 	q ""  ;允许发送
}

ClassMethod CheckGetReport(RegNo, IDCard)
{
	q:(RegNo=""||IDCard="") "存入参数不能为空"
	s PatMasID=$O(^PAPERi("PAPMI_PatNo",RegNo,0))
	q:PatMasID="" "登记号不存在"
	s CurIDCard=$P(^PAPER(PatMasID,"PAT",3),"^",6)
	q:CurIDCard'=IDCard "证件号码和系统不一致"
	q ""
}

ClassMethod GetUserInfo(PAADM) As %String
{
	s obj=##class(web.DHCPE.NetReport.Entity.UserInfo).%New()
	s AdmObj=##class(User.PAAdm).%OpenId(PAADM)
	s obj.hisregno=AdmObj.PAADMPAPMIDR.PAPMIIPNo
	
	s obj.cardno=AdmObj.PAADMPAPMIDR.PAPMIDVAnumber
	s obj.name=AdmObj.PAADMPAPMIDR.PAPMIName
	s obj.Birth=AdmObj.PAADMPAPMIDR.PAPMIDOB
	s:obj.Birth'="" obj.Birth=$ZD(obj.Birth,3)
	s obj.Sex=AdmObj.PAADMPAPMIDR.PAPMISexDR.CTSEXDesc
	s obj.password=""  ;密码待定
	s obj.phone=AdmObj.PAADMPAPMIDR.PAPMIMobPhone
	s:obj.phone="" obj.phone=AdmObj.PAADMPAPMIDR.PAPMIPAPERDR.PAPERTelH
	d ..ChangeNull(.obj)
	s rtn=obj.XMLExportToString(.XML,"Request")
	i ($system.Status.IsError(rtn)) {
		q "-1^序列化基本信息对象失败"
	}
	q "0^"_XML
}

ClassMethod GetCheckInfo(PAADM) As %String
{
	s obj=##class(web.DHCPE.NetReport.Entity.CheckMainInfo).%New()
	s AdmObj=##class(User.PAAdm).%OpenId(PAADM)
	s obj.hisregno=AdmObj.PAADMPAPMIDR.PAPMIIPNo
	s obj.checkdate=AdmObj.PAADMAdmDate
	s:obj.checkdate'="" obj.checkdate=$ZD(obj.checkdate,3)
	s obj.hispaadm=PAADM
	s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
	//q:IADM=""
	s GADM=$P(^DHCPEIADM(IADM),"^",2)
	i GADM="" d
	.s obj.workunit=""
	e  d
	.s GBI=$P(^DHCPEGADM(GADM),"^",1)
	.s obj.workunit=$P(^DHCPEGBI(GBI),"^",2)
	s GSID=$O(^DHCPEGS(0,"IADM",IADM,0))
	q:GSID=""
	s obj.auditdoctor=$P(^DHCPEGS(GSID,1),"^",5)
	s:obj.auditdoctor'="" obj.auditdoctor=$P(^SSU("SSUSR",obj.auditdoctor),"^",2)
	
	s MainDoctorInfo=$G(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",PAADM))    //add by  20130129 
	s obj.checkdoctor=$p(MainDoctorInfo,"^",1)                                                 //add by  20130129  
	s:obj.checkdoctor'="" obj.checkdoctor=$p($g(^SSU("SSUSR",obj.checkdoctor)),"^",2) //add by  20130129 

	s obj.auditdate=$P(^DHCPEGS(GSID,1),"^",6)
	s:obj.auditdate'="" obj.auditdate=$ZD(obj.auditdate,3)
	d ..ChangeNull(.obj)
	s rtn=obj.XMLExportToString(.XML,"Request")
	i ($system.Status.IsError(rtn)) {
		q "-1^序列化检查信息对象失败"
	}
	q "0^"_XML
}

ClassMethod GetSOrderInfo(PAADM)
{
	//s ReportJob=$J_"^"_PAADM
	s ReportJob=%session.Get("LOGON.USERID")
	d ##class(web.DHCPE.ReportGetInfor).GetReportResult(PAADM)
	s SSOrderObj=##class(web.DHCPE.NetReport.Entity.SSOrderInfo).%New()
	s StationSummarizeObj=##class(web.DHCPE.NetReport.Entity.StationSummarize).%New()
	s StationSummarizeObj.hispaadm=PAADM
	s SSOrderObj.hispaadm=PAADM
	;s ^TMPReport(ReportJob,ReportJob,"Result","Station",STSequence,STRowId,ARCSequence,^TMPReport(ReportJob,ReportJob,"Result","Station",STSequence,STRowId,ARCSequence))=TestId
	s STSequence=""
	f  s STSequence=$O(^TMPReport(ReportJob,ReportJob,"Result","Station",STSequence)) q:STSequence=""  d
	.s STID=""
	.f  s STID=$O(^TMPReport(ReportJob,ReportJob,"Result","Station",STSequence,STID)) q:STID=""  d
	..s StationObj=##class(web.DHCPE.NetReport.Entity.station).%New()
	..s StationObj.hisstation=STID
	..s STName=$P(^DHCPEST(STID),"^",2)
	..s StationObj.sort=STSequence
	..s StationObj.hisstationname=STName
	..d ..ChangeNull(.StationObj)
	..d StationSummarizeObj.stations.Insert(StationObj)
	
	..s StationOrderObj=##class(web.DHCPE.NetReport.Entity.stationorder).%New()
	..s StationOrderObj.hisstation=STID
	..s ItemSort=""
	..f  s ItemSort=$O(^TMPReport(ReportJob,ReportJob,"Result","Station",STSequence,STID,ItemSort)) q:ItemSort=""  d
	...s Sort=""
	...s ResultI=0
	...s Flag=0
	...f  s Sort=$O(^TMPReport(ReportJob,ReportJob,"Result","Station",STSequence,STID,ItemSort,Sort)) q:Sort=""  d
	....;q:ResultI>0
	....s ResultI=1
	....s OrderItemID=$G(^TMPReport(ReportJob,ReportJob,"Result","Station",STSequence,STID,ItemSort,Sort))
	....s OrderInfo=$G(^TMPReport(ReportJob,ReportJob,"Result","ARCIM",OrderItemID))
	....s OrderObj=##class(web.DHCPE.NetReport.Entity.order).%New()
	....;ARCIMDesc_"^"_RLTUser_"^"_RLTUpdateDate_"^"_ReportFormat_"^"_$G(AuditUser)_"^"_ARCIMDR
	....s OrderObj.hisorderid=OrderItemID
	....s OrderObj.ordername=$P(OrderInfo,"^",1)
	....s OrderObj.reportformt=$P(OrderInfo,"^",4)
	....s OrderObj.checkdoctor=$P(OrderInfo,"^",2)
	....s OrderObj.checkdate=$P(OrderInfo,"^",3)
	....s OrderObj.auditdoctor=$P(OrderInfo,"^",5)
	....s OrderObj.auditdate=""
	....s OrderObj.sort=Sort
	....d ..ChangeNull(.OrderObj)
	....d StationOrderObj.orders.Insert(OrderObj)
	..d SSOrderObj.stationorders.Insert(StationOrderObj)
	;k ^TMPReport(ReportJob,ReportJob,"Result")
	s rtn=SSOrderObj.XMLExportToString(.OrderXML,"Request")
	i ($system.Status.IsError(rtn)) {
		q "-1^序列化医嘱对象失败^"
	}
	s rtn=StationSummarizeObj.XMLExportToString(.StationSummarizeXML,"Request")
	i ($system.Status.IsError(rtn)) {
		q "-1^序列化小结站点对象失败^"
	}
	q "0^"_OrderXML_"^"_StationSummarizeXML
}

ClassMethod GetResult(PAADM)
{
	//s ReportJob=$J_"^"_PAADM
	s ReportJob=%session.Get("LOGON.USERID")
	s WebServiceObj=$ZOBJCLASSMETHOD(..#ServiceClassName,"%New")
	s iTotal=0
	s SendTotal=0
	d ##class(web.DHCPE.ReportGetInfor).GetReportResult(PAADM)
	s ResultObj=##class(web.DHCPE.NetReport.Entity.SSOrderResult).%New()
	s ResultObj.hispaadm=PAADM
	;s ^TMPReport(ReportJob,ReportJob,"Result","Station",STSequence,STRowId,ARCSequence,^TMPReport(ReportJob,ReportJob,"Result","Station",STSequence,STRowId,ARCSequence))=TestId
	s STSequence=""
	f  s STSequence=$O(^TMPReport(ReportJob,ReportJob,"Result","Station",STSequence)) q:STSequence=""  d
	.s STID=""
	.f  s STID=$O(^TMPReport(ReportJob,ReportJob,"Result","Station",STSequence,STID)) q:STID=""  d
	..s ItemSort=""
	..f  s ItemSort=$O(^TMPReport(ReportJob,ReportJob,"Result","Station",STSequence,STID,ItemSort)) q:ItemSort=""  d
	...s Sort=""
	...s Flag=0
	...s ResultCount=0
	...f  s Sort=$O(^TMPReport(ReportJob,ReportJob,"Result","Station",STSequence,STID,ItemSort,Sort)) q:Sort=""  d
	....s OrderItemID=$G(^TMPReport(ReportJob,ReportJob,"Result","Station",STSequence,STID,ItemSort,Sort))
	....s OrderInfo=$G(^TMPReport(ReportJob,ReportJob,"Result","ARCIM",OrderItemID))
	....s reportformt=$P(OrderInfo,"^",4)
	....s OrderResultObj=##class(web.DHCPE.NetReport.Entity.orderresult).%New()
	....s OrderResultObj.hisorderid=OrderItemID
	....s ResultSort=""
	....f  s ResultSort=$O(^TMPReport(ReportJob,ReportJob,"Result", "Content", OrderItemID,ResultSort)) q:ResultSort=""  d
	.....s Flag=1
	.....s iTotal=iTotal+1
	.....s ResultInfo=$G(^TMPReport(ReportJob,ReportJob,"Result", "Content", OrderItemID,ResultSort))
	.....s OrderDetailResultObj=##class(web.DHCPE.NetReport.Entity.detailresult).%New()
	.....s OrderDetailResultObj.detailname=$P(ResultInfo,"^",1)
	.....s OrderDetailResultObj.result=$P(ResultInfo,"^",2)
	.....s OrderDetailResultObj.result=..MaskContent(OrderDetailResultObj.result, "C")
	.....s OrderDetailResultObj.normalflag=$P(ResultInfo,"^",3)  //正常、异常
	.....s:OrderDetailResultObj.normalflag="异常" OrderDetailResultObj.normalflag="0"
	.....s:OrderDetailResultObj.normalflag'="异常" OrderDetailResultObj.normalflag="1"
	.....s OrderDetailResultObj.unit=$P(ResultInfo,"^",4)
	.....s OrderDetailResultObj.sort=ResultSort
	.....i (reportformt[("LIS"))||(reportformt[("CAT")) d
	......s OrderDetailResultObj.ranginfo=$P(ResultInfo,"^",5)
	......s OrderDetailResultObj.detailename=$P(ResultInfo,"^",8)
	......s OrderDetailResultObj.resulttype=$P(ResultInfo,"^",6)
	......s Template=""
	......s OrderDetailResultObj.hisresultid=$P(ResultInfo,"^",9)
	.....e  d
	......s OrderDetailResultObj.ranginfo=""
	......s OrderDetailResultObj.detailename=""
	......s OrderDetailResultObj.resulttype=""
	......s Template=$P(ResultInfo,"^",5)
	......s OrderDetailResultObj.hisresultid=$P(ResultInfo,"^",6)
	.....s:Template'="" OrderDetailResultObj.result=OrderDetailResultObj.result_"("_Template_")"
	.....d ..ChangeNull(.OrderDetailResultObj)
	.....d:Flag=1 OrderResultObj.detailresults.Insert(OrderDetailResultObj)
	....s:Flag=1 ResultCount=ResultCount+1
	....d:Flag=1 ResultObj.orderresults.Insert(OrderResultObj)
	....i ResultCount=5 d
	.....s rtn=ResultObj.XMLExportToString(.ResultXML,"Request")
	.....d WebServiceObj.ISSOrderResult(ResultXML)
	.....s SendTotal=SendTotal+1
	.....s ResultCount=0
	.....d ResultObj.orderresults.Clear()
	i ResultCount>0 d
	.s rtn=ResultObj.XMLExportToString(.ResultXML,"Request")
	.s ^TempDHCPE("NetReport","Result")=ResultXML
	.d WebServiceObj.ISSOrderResult(ResultXML)
	.s SendTotal=SendTotal+1
	;w SendTotal_"^"_iTotal,!
	q 0
}

ClassMethod GetDiagnosisInfo(PAADM)
{
	;d ##class(web.DHCPE.NetReport.Main).GetDiagnosisInfo(19648585)
	s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
	s GSID=$O(^DHCPEGS(0,"IADM",IADM,0))
	q:GSID="" "-1^"
	s obj=##class(web.DHCPE.NetReport.Entity.DiagnosisInfo).%New()
	s obj.hispaadm=PAADM
	
	s Sort=0
	f  s Sort=$O(^DHCPEGS(0,"GSDSort",GSID,Sort)) q:Sort=""  d
	.s Sub=""
	.f  s Sub=$O(^DHCPEGS(0,"GSDSort",GSID,Sort,Sub)) q:Sub=""  d
	..s DiagnosisObj=##class(web.DHCPE.NetReport.Entity.diagnosis).%New()
	..s DiagnosisObj.hissub=Sub
	..s DiagnosisObj.sort=Sort
	..s EDID=$P(^DHCPEGS(GSID,"Diagnosis",Sub),"^",1)
	..s DiagnosisObj.edname=$p($g(^DHCPEED(EDID,"1")),"^",1)
	..i $D(^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",GSID_"||"_Sub)) d
	..;.s DiagnosisObj.edname=$G(^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",GSID_"||"_Sub))
	..s DiagnosisObj.eddetail=$P(^DHCPEGS(GSID,"Diagnosis",Sub),"^",9)
	..d ..ChangeNull(.DiagnosisObj)
	..d obj.diagnosiss.Insert(DiagnosisObj)
	s rtn=obj.XMLExportToString(.XML,"Request")
	i ($system.Status.IsError(rtn)) {
		q "-1^序列化建议对象失败^"
	}
	q "0^"_XML
}

// d ##class(web.DHCPE.NetReport.Main).GetSSResult(19668103)

// d ##class(web.DHCPE.NetReport.Main).GetSSResult(19855163)

ClassMethod GetSSResult(PAADM)
{
	s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
	s STID=$O(^DHCPESS(0,"IADM",IADM,0))
	q:STID="" "-1^"
	s obj=##class(web.DHCPE.NetReport.Entity.SSResult).%New()
	s obj.hispaadm=PAADM
	s RisStation="^"_$g(^DHCPESetting("DHCPE","StationId_Ris"))_"^"
	
	s STID=""
	f  s STID=$O(^DHCPESS(0,"IADM",IADM,STID)) q:STID=""  d
	.q:RisStation[("^"_STID_"^")
	.s StationObj=##class(web.DHCPE.NetReport.Entity.stationresult).%New()
	.s StationObj.hisstation=STID
	.s Flag=0
	.s SSID=0
	.f  s SSID=$o(^DHCPESS(0,"IADM",IADM,STID,SSID))  q:SSID=""  d
	..s Sub=""
	..f  s Sub=$o(^DHCPESS(SSID,"Result",Sub))  q:Sub=""  d
	...s ResultObj=##class(web.DHCPE.NetReport.Entity.result).%New()
	...s ResultObj.hissub=Sub
	...s Flag=1
	...s ResultObj.hisresultid=$p(^DHCPESS(SSID,"Result",Sub),"^",1)
	...d ..ChangeNull(.ResultObj)
	...d StationObj.results.Insert(ResultObj)
	.d:Flag=1 obj.stationresults.Insert(StationObj) 
	q:obj.stationresults.Count()=0 "-1^没有数据"
	s rtn=obj.XMLExportToString(.XML,"Request")
	i ($system.Status.IsError(rtn)) {
		q "-1^序列化小结结果对象失败^"
	}
	q "0^"_XML
}

ClassMethod GetSSDiagnosis(PAADM)
{
	s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
	s STID=$O(^DHCPESS(0,"IADM",IADM,0))
	q:STID="" "-1^"
	s obj=##class(web.DHCPE.NetReport.Entity.SSDiagnosis).%New()
	s obj.hispaadm=PAADM
	;web.DHCPE.NetReport.Entity.diagnosis
	s STID=""
	f  s STID=$O(^DHCPESS(0,"IADM",IADM,STID)) q:STID=""  d
	.s StationObj=##class(web.DHCPE.NetReport.Entity.diagnosisstation).%New()
	.s StationObj.hisstation=STID
	.s Flag=0
	.s SSID=0
	.f  s SSID=$o(^DHCPESS(0,"IADM",IADM,STID,SSID))  q:SSID=""  d
	..s Sub=""
	..f  s Sub=$o(^DHCPESS(SSID,"Diagnosis",Sub))  q:Sub=""  d
	...s DiagnosisObj=##class(web.DHCPE.NetReport.Entity.diagnosis).%New()
	...s DiagnosisObj.hissub=Sub
	...s DiagnosisObj.sort=Sub
	...s Flag=1
	...s DiagnosisObj.eddetail=$p($G(^DHCPESS(SSID,"Diagnosis",Sub)),"^",7)
	...s EDID=$p($G(^DHCPESS(SSID,"Diagnosis",Sub)),"^",1)
	...i $D(^DHCPEDataEx("DHCPESSDiagnosis","DisplayDesc",SSID_"||"_Sub)) d
	....s DiagnosisObj.edname=$G(^DHCPEDataEx("DHCPESSDiagnosis","DisplayDesc",SSID_"||"_Sub))
	...e  d
	....s DiagnosisObj.edname=$p($g(^DHCPEED(EDID,"1")),"^",1)
	...d ..ChangeNull(.DiagnosisObj)
	...d StationObj.diagnosiss.Insert(DiagnosisObj)
	.d:Flag=1 obj.diagnosisstations.Insert(StationObj)
	s rtn=obj.XMLExportToString(.XML,"Request")
	i ($system.Status.IsError(rtn)) {
		q "-1^序列化小结建议对象失败^"
	}
	q "0^"_XML
}

ClassMethod ChangeNull(ByRef object As %ObjectHandle)
{
	s myClassName=object.%ClassName(1)
	set ClassDef = ##class(%Library.ClassDefinition).%OpenId(myClassName)
	s myCount=ClassDef.Properties.Count()
	f i = 1:1:myCount d
	.s myPropertyName=ClassDef.Properties.GetAt(i).Name
	.i $ZOBJPROPERTY(object, myPropertyName)="" d
	..s $ZOBJPROPERTY(object, myPropertyName)=$C(0)
	d ClassDef.%Close()
	quit $$$OK
}

ClassMethod MaskContent(Content, Type)
{
	i Type="C" d
	.s Content=##class(web.DHCPE.Public.Setting).Replace(Content,"&","&amp;")
	.s Content=##class(web.DHCPE.Public.Setting).Replace(Content,"<","&lt;")
	.s Content=##class(web.DHCPE.Public.Setting).Replace(Content,">","&gt;")
	.s Content=##class(web.DHCPE.Public.Setting).Replace(Content,"""","&quot;")
	.s Content=##class(web.DHCPE.Public.Setting).Replace(Content,"'","&apos;")
	e  d
	.s Content=##class(web.DHCPE.Public.Setting).Replace(Content,"&lt;","<")
	.s Content=##class(web.DHCPE.Public.Setting).Replace(Content,"&gt;",">")
	.s Content=##class(web.DHCPE.Public.Setting).Replace(Content,"&quot;","""")
	.s Content=##class(web.DHCPE.Public.Setting).Replace(Content,"&apos;","'")
	.s Content=##class(web.DHCPE.Public.Setting).Replace(Content,"&amp;","&")
	
	q Content
}

/*
^DHCPENetReport("Record",RegNo,PAADM)=姓名^性别^年龄^单位^体检日期^体检科室^总检医生^总检日期^审核医生^审核日期
^DHCPENetReport("Result",PAADM,"Advice")=建议内容(很大一段内容)
^DHCPENetReport("Result",PAADM,"OrdItem",Sort,OrdItemID)=项目名称^报告格式^审核医生名字^医生名字^检查日期
^DHCPENetReport("Result",PAADM,"OrdDetail",OrdItemID,"Detail",Sort,DetailID)=细项名称^英文缩写^检查结果^提示(上下箭头)^单位(10S9)^参考范围
*/
ClassMethod CancelReportData(PAADM)
{
	s obj=##class(User.PAAdm).%OpenId(PAADM)
	s RegNo=obj.PAADMPAPMIDR.PAPMINo
	k ^DHCPENetReport("Record",RegNo,PAADM)
	k ^DHCPENetReport("Result",PAADM)
}

/// d ##class(web.DHCPE.NetReport.Main).SetReportData(2200)
ClassMethod SetReportData(PAADM)
{
	
	d ..CancelReportData(PAADM)
	s LocID=$P(^PAADM(PAADM),"^",4)

	s obj=##class(User.PAAdm).%OpenId(PAADM)
	s RegNo=obj.PAADMPAPMIDR.PAPMINo
	s UserID=""
	//s:$D(%session) UserID=%session.Get("LOGON.USERID")
	s:UserID="" UserID=PAADM
	//s LocID=%session.Get("LOGON.CTLOCID")
	s LocDesc=$P(^CTLOC(LocID),"^",2)
	i $L(LocDesc,"-")>1 d
	.s LocDesc=$P(LocDesc,2,$L(LocDesc,"-"))
	
	d ##Class(web.DHCPE.ReportOutToWeb).GetReportInfor(PAADM,UserID)
	//基本信息
	s Name=$G(^TMPReport(UserID,"PatInfo","PatName"))
	s Sex=$G(^TMPReport(UserID,"PatInfo","PatSex"))
	s Age=$G(^TMPReport(UserID,"PatInfo","PatAge"))
	s PatCompany=$G(^TMPReport(UserID,"PatInfo","PatCompany"))
	s Position=$G(^TMPReport(UserID,"PatInfo","Position"))
	s CheckDate=$G(^TMPReport(UserID,"PatInfo","AdmDate"))
	s CheckLoc=LocDesc
	s AuditDoc=$G(^TMPReport(UserID,"GeneralAdvice","AduitUser"))
	s AuditDate=$G(^TMPReport(UserID,"GeneralAdvice","AduitUserDate"))
	s MainDoc=$G(^TMPReport(UserID,"GeneralAdvice","MainDoctor"))
	s MainDate=$G(^TMPReport(UserID,"GeneralAdvice","MainDoctorDate"))
	s VIPDesc=$G(^TMPReport(UserID,"PatInfo","VIPLevel"))
	s HPNo=$G(^TMPReport(UserID,"PatInfo","PatRegNo"))
	s PatTel=$G(^TMPReport(UserID,"PatInfo","PatTel"))
	s IDCard=$G(^TMPReport(UserID,"PatInfo","PatID"))
	
	s PatBirthday=$g(^TMPReport(UserID,"PatInfo","PatBirthday"))
	s Vocation=$g(^TMPReport(UserID,"PatInfo","Vocation"))
	s Address=$g(^TMPReport(UserID,"PatInfo","PatAddress"))
	s Nation=$g(^TMPReport(UserID,"PatInfo","Nation"))
	s Married=$g(^TMPReport(UserID,"PatInfo","Married"))
	s PatCardType=$G(^TMPReport(UserID,"PatInfo","PatCardType"))
	
	s ^DHCPENetReport("Record",RegNo,PAADM)=Name_"^"_Sex_"^"_Age_"^"_PatCompany_"^"_CheckDate_"^"_CheckLoc_"^"_AuditDoc_"^"_AuditDate_"^"_MainDoc_"^"_MainDate_"^"_VIPDesc_"^"_Position_"^"_HPNo_"^"_PatTel_"^"_IDCard_"^"_PatBirthday_"^"_Vocation_"^"_Address_"^"_Nation_"^"_Married_"^"_PatCardType
	
	// 单位信息
	s groupArr=$g(^TMPReport(UserID,"PatInfo","groupArr"))  // 单位地址
    s gpostalCode=$g(^TMPReport(UserID,"PatInfo","groupPostalCode"))  // 邮政编码
    s gcontact=$g(^TMPReport(UserID,"PatInfo","groupContact"))  // 联系人
    s gcontactNumber=$g(^TMPReport(UserID,"PatInfo","groupContactNumber"))  // 联系电话
    s gEmail=$g(^TMPReport(UserID,"PatInfo","groupEmail"))  // 电子邮件
	s ^DHCPENetReport("GroupRecord",RegNo,PAADM)=groupArr_"^"_gpostalCode_"^"_gcontact_"^"_gcontactNumber_"^"_gEmail
	
	//检查项目ID
	s ^DHCPENetReport("Result",PAADM,"AddItemID")=$G(^TMPReport(UserID,"Result","AddItemID"))
	//体检项目
	s ^DHCPENetReport("Result",PAADM,"AddItem")=$G(^TMPReport(UserID,"Result","AddItem"))
	//体检套餐
	s ^DHCPENetReport("Result",PAADM,"OrderSetsDesc")=$G(^TMPReport(UserID,"PatInfo","OrderSetsDesc"))
	//阳性汇总
	s ^DHCPENetReport("Result",PAADM,"Contentgather")=$G(^TMPReport(UserID,"Summarize", "Contentgather"))
	//建议
	s ^DHCPENetReport("Result",PAADM,"Advice")=$G(^TMPReport(UserID,"GeneralAdvice","Advice"))
	s:PAADM=1173 ^DHCPENetReport("Result",PAADM,"Advice")="<b>既往史，现病史</b><br>1、<b>糖尿病</b><br>      建议：内分泌科门诊诊治。"_$c(13,10)_"<b>一般情况</b><br>2、<b>血压偏高</b><br>      建议：偶尔发现血压升高者请择期复查,并监测血压波动情况；劳逸结合,保持良好身心状态;避免各种诱因,如情绪低落、激动、紧张等；低盐、低脂、低糖饮食,戒除烟酒；确诊高血压病者,请到心血管内科诊治。"_$c(13,10)_"<b>检验项目</b><br>3、<b>尿常规葡萄糖阳性（UGLU）</b><br>      建议：应该注意经常观测尿糖的水平,生活中应该注意控制每天的饮食摄入量,适量运动,控制体重于正常水平,内分泌科诊治。<br>4、<b>谷氨酰转氨酶增高(GGT)</b><br>      建议：偶尔一次检查发现谷氨酰转氨酶轻度升高，不一定有临床意义，建议结合其他肝功能指标及临床进行综合评估。生活饮食上提倡戒酒，并注意休息，避免过度劳累。到医院检查肝炎病毒标志物及B超等检查有无脂肪肝、肝癌、血吸虫肝等改变，并酌情使用护肝药物。<br>5、<b>血糖升高(GLU)</b><br>      建议：空腹血糖为6.1～6.9mmol/L时，建议进一步做口服葡萄糖耐量试验或糖化血红蛋白检测。空腹血糖≥7.0mmol/L或随机血糖≥11.1mmol/L时考虑糖尿病，需到内分泌科就医并结合糖化血红蛋白检测和胰岛素释放试验等进一步确诊。<br>6、<b>甘油三酯偏高(TG)</b><br>      建议：血脂影响因素很多，偶尔一次检查发现甘油三酯增高，不一定有临床意义，如连续多次升高，应引起重视。先调整生活方式，饮食上注意减少油脂的摄入，增加运动，三月后复查血脂，如血脂仍增高，则需要服用降脂药物。如同时合并有糖尿病、高血压、冠心病等则需尽早加用调药物。<br>7、<b>血粘度偏高</b><br>      建议：①多饮水,降低血粘度,保持血液循环畅通。②多吃蔬菜水果,能改善血液流变,有效降低血液粘稠度,少食动物油脂和内脏,多吃低脂肪、低胆固醇食物,粗粮和细粮搭配,戒饮酒,戒烟,劳逸结合。"_$c(13,10)_"<b>腹部B超</b><br>8、<b>B超提示：脂肪肝</b><br>      建议：控制体重,低盐,低糖饮食,减少动物性食物比例,每天可食一餐谷物鱼类,增加运动量,定期复查血脂,肝功能和彩超,必要时服用降脂药。<br>9、<b>B超提示：前列腺钙化斑</b><br>      建议：一般不需治疗，若有不适泌尿外科诊治。"_$c(13,10)_"<b>CT检查</b><br>10、<b>胸部CT提示：右侧斜裂胸膜及水平裂胸膜下多发小结节影</b><br>      建议：呼吸科诊治。<br>11、<b>胸部CT提示：脂肪肝</b><br>      建议：控制体重,低盐,低糖饮食,减少动物性食物比例,每天可食一餐谷物鱼类,增加运动量,定期复查血脂,肝功能和彩超,必要时服用降脂药。"_$c(13,10)
	
	// 乙肝建议
	s ^DHCPENetReport("Result",PAADM,"YGAdvice")=$G(^TMPReport(UserID,"GeneralAdvice", "YGAdvice"))
	
	// 分开建议
	if $d(^TMPReport(UserID,"GeneralAdvice","DisplayGSum")) d
	.m ^DHCPENetReport("Result",PAADM,"DisplayGSum")=^TMPReport(UserID,"GeneralAdvice","DisplayGSum")
	
	// 疾病
	m ^DHCPENetReport("Result",PAADM,"IllExplain")=^TMPReport(UserID,"IllExplain")
	
	// 报告配置 人体图异常部位  病史
	m ^DHCPENetReport("Result",PAADM)=^TMPReport(UserID,"ReportSetting")

	// 总检医生签名
	s ^DHCPENetReport("Result",PAADM,"CAAduitUser")=##class(web.DHCPE.CA.Main).GetSignName(2,PAADM)
	s ^DHCPENetReport("Result",PAADM,"CAMainDoctor")=##class(web.DHCPE.CA.Main).GetSignName(3,PAADM)
	
	// 职业病信息
	m ^DHCPENetReport("PatOccInfo",PAADM)=^TMPReport(UserID,"PatOccInfo")
	
	//体检综述
	s NegativeSummary=""
	s StationNum=0	
	//项目以及结果
	s NoReportStation="^"_$G(^DHCPESetting("DHCPE","NoReportStation"))_"^"
	s ItemSort=0
	s sStationSequence=""
	f  s sStationSequence=$O(^TMPReport(UserID,"Result","Station",sStationSequence)) q:sStationSequence=""  d
	.s StationId=""
	.f  s StationId=$O(^TMPReport(UserID,"Result","Station",sStationSequence,StationId)) Q:(""=StationId)  d
	..q:NoReportStation[("^"_StationId_"^")
	..s StationCode=$P(^DHCPEST(StationId),"^",1)
	..s StationName=$P(^DHCPEST(StationId),"^",2)
	
	..s StationNum=StationNum+1
	..s:NegativeSummary'="" NegativeSummary=NegativeSummary_$C(1)_##class(HS.BL.PECommon).NumConvert(StationNum)_"、"_StationName_$C(2)
	..s:NegativeSummary="" NegativeSummary=##class(HS.BL.PECommon).NumConvert(StationNum)_"、"_StationName_$C(2)
	..s ARCIMNum=0
	
	..s sARCSequence=""
	..f  s sARCSequence=$O(^TMPReport(UserID,"Result","Station",sStationSequence,StationId,sARCSequence)) Q:(""=sARCSequence)  d
	...s iiiLLoop=0
	...f  s iiiLLoop=$O(^TMPReport(UserID,"Result","Station",sStationSequence,StationId,sARCSequence,iiiLLoop)) Q:(""=iiiLLoop)  d
	....s ARCIM=$G(^TMPReport(UserID,"Result","Station",sStationSequence,StationId,sARCSequence,iiiLLoop))
	....s sArcimIdTemp=$p($G(^OEORD(+ARCIM,"I",$p(ARCIM,"||",2),1)),"^",2)
	....s bFlagTemp=$G(^DHCPEDataEx("DHCPEStationOrder","Sign",sArcimIdTemp))
	....q:ARCIM=""
	....s ARCIMNum=ARCIMNum+1
	....s CurData=$G(^TMPReport(UserID,"Result", "ARCIM", ARCIM))
	....s ARCIMDesc=$P(CurData,"^",1)
	....s Checker=$P(CurData,"^",2)
	....s CheckDate=$P(CurData,"^",3)
	....s ReportFormat=$P(CurData,"^",4)
	....s AuditUser=$P(CurData,"^",5)
	....s YGFlag=$P(CurData,"^",6)
	....s LisItmData=$P(CurData,"^",7)
	....;项目 小结
	....s Negative=$G(^TMPReport(UserID,"Result","Negative",ARCIM))
	....s:Negative="" Negative="未见异常"
	....s:Negative[";诊断意见:" Negative=$p(Negative,";诊断意见:",2)
	....i ARCIMNum=1 d  s NegativeSummary=NegativeSummary_ARCIMNum_"、"_ARCIMDesc_":"_Negative
	....e  d  s NegativeSummary=NegativeSummary_$C(3)_ARCIMNum_"、"_ARCIMDesc_":"_Negative
	....q:'$D(^TMPReport(UserID,"Result", "Content",ARCIM))
	....s ItemSort=ItemSort+1
	....;^DHCPENetReport("Result",PAADM,"OrdItem",Sort,OrdItemID)=项目名称^报告格式^审核医生名字^医生名字^检查日期^站点代码^站点名称^项目小结
	....s ^DHCPENetReport("Result",PAADM,"OrdItem",ItemSort,ARCIM)=ARCIMDesc_"^"_ReportFormat_"^"_AuditUser_"^"_Checker_"^"_CheckDate_"^"_StationCode_"^"_StationName_"^"_Negative_"^"_YGFlag_"^"_LisItmData
	....s CADocImg = ##class(web.DHCPE.CA.Main).GetSignName(0,ARCIM)
	....s ^DHCPENetReport("Result",PAADM,"OrdItem",ItemSort,ARCIM,"CADocImg")=CADocImg
	....s ItmImgData=##class(web.DHCPE.ReportShowOther).GetOtherURL(ARCIM,LocID)
	....s:ItmImgData'="" ^DHCPENetReport("Result",PAADM,"OrdItem",ItemSort,ARCIM,"IMGDATA")=ItmImgData
	....s DetailSort=0
	....s ODID=""
	....f  s ODID=$O(^TMPReport(UserID,"Result", "Content",ARCIM,ODID)) q:ODID=""  d
	.....s CurData=$g(^TMPReport(UserID,"Result", "Content",ARCIM,ODID))
	.....;^DHCPENetReport("Result",PAADM,"OrdDetail",OrdItemID,"Detail",Sort,DetailID)=细项名称^英文缩写^检查结果^提示(上下箭头)^单位(10S9)^参考范围^体检结果ID^图片信息
	.....i (ReportFormat["LIS")||(ReportFormat["CAT") d
	......s DetailSort=DetailSort+1
	......s TestDesc=$P(CurData,"^",1)
	......s TestResult=$P(CurData,"^",2)
	......s TestStandard=$P(CurData,"^",5)
	......s Arrow=$P(CurData,"^",6)
	......s:Arrow=3 Arrow="*"
	......s:Arrow=2 Arrow="↑"
	......s:Arrow=0 Arrow="↓"
	......s:Arrow=1 Arrow=""
	......s CTTCSynonym=$P(CurData,"^",8)
	......s Normal=$P(CurData,"^",3)
	......s TestUnit=$P(CurData,"^",4)
	......s ResultID=$P(CurData,"^",9)
	.....i (ReportFormat["NOR")||((ReportFormat["RIS")||(ReportFormat["PIS")||((ReportFormat["EKG"))) d
	......s TestDesc=$Replace($P(CurData,"^",1),"-检查结果","")
	......s ResultDesc=$P(CurData,"^",2)
	......s:ResultDesc'="" ResultDesc=$Replace(ResultDesc,$C(0),"")
	......s TestResult=ResultDesc
	......s Normal=$P(CurData,"^",3)
	......s TestUnit=$P(CurData,"^",4)
	......s TestStandard=$P(CurData,"^",7)
	......s Arrow=""
	......s CTTCSynonym=""
	......s ResultID=$P(CurData,"^",6)
	
	.....;图片信息  add by wgy  
	.....s ImgInfo=""
	.....i (ReportFormat["EKG")||((ReportFormat["RIS")) d
	......s ImgInfo=$G(^TMPReport(UserID,"Result", "IMG",ARCIM))
	......s:ImgInfo'="" ImgInfo=$Replace(ImgInfo,$C(1),"##")
	.....;end
	
	.....;北京医院  单独打印心电PDF
	.....;i (ReportFormat["EKG")  d
	.....;.s ^DHCPENetReport("Record",PAADM,"PDFPrint")=ImgInfo
	
	.....s ^DHCPENetReport("Result",PAADM,"OrdDetail",ARCIM,"Detail",DetailSort,ODID)=TestDesc_"^"_CTTCSynonym_"^"_TestResult_"^"_Arrow_"^"_TestUnit_"^"_TestStandard_"^"_ResultID
	s ^DHCPENetReport("Result",PAADM,"NegativeSummary")=NegativeSummary
	d ..BatchHistoryRecord(PAADM,UserID)
	k ^TMPReport(UserID)
}

/// 批量生成网上体检报告   wgy
/// w ##class(web.DHCPE.NetReport.Main).BatchGenNetReport("Y","2018-01-01",2018-12-31")
/// Input:Flag  Y:全部重新生成   N:已存在的不更新   BeginDate :审核开始时间  YYYY-MM-DD  EndDate :截止时间  YYYY-MM-DD
ClassMethod BatchGenNetReport(ALLFlag = "N", BeginDate = "", EndDate = "") As %String
{
	s:BeginDate="" BeginDate="1900-01-01"
	s:EndDate="" EndDate="3999-12-31"
	s BeginDate=$zdh(BeginDate,3)
	s EndDate=$zdh(EndDate,3)
	s rtn=0
	s $zt="ErrHandle"
	s RPTId=0
	f  s RPTId=$O(^DHCPERPT(RPTId)) q:RPTId=""  d
	.s RPTStatus=$p(^DHCPERPT(RPTId),"^",2)
	.q:("UNCHECKED"=RPTStatus)||("NA"=RPTStatus)||("NoAudit"=RPTStatus)
	.s AuditDate=$P(^DHCPERPT(RPTId),"^",5)
	.q:(AuditDate<BeginDate)||(AuditDate>EndDate)
	.s PEIADMDR=$P(^DHCPERPT(RPTId),"^",1)
	.q:PEIADMDR=""
	.s PAADMDR=$P(^DHCPEIADM(PEIADMDR),"^",1)
	.q:PAADMDR=""
	.q:..IsAuditReport(PAADMDR)'=0

	.i ((ALLFlag="Y")||('$D(^DHCPENetReport("Result",PAADMDR)))) d

	..d ..Main(PAADMDR)
	..s rtn=rtn+1
	..w rtn ,!
	q rtn
ErrHandle
	s $zt=""
	s rtn="-100^批量生成网上报告发生错误"
	q:$ze="" rtn
	q rtn_"^"_$ze
}

/// 生成历年结果记录   wgy
/// w ##class(web.DHCPE.NetReport.Main).BatchHistoryRecord()
ClassMethod BatchHistoryRecord(PAADM, UserID)
{
	i $D(^TMPReport(UserID,"HistoryResult",1,1))
	{
		i $L(^TMPReport(UserID,"HistoryResult",1,1),"^")>2 d 
		.m ^DHCPENetReport("Result",PAADM,"HistoryResult")=^TMPReport(UserID,"HistoryResult")
	}
}

/// 报告状态是否审核完成
/// 0:已审核  1：未总检  2：未复检
/// w ##class(web.DHCPE.NetReport.Main).IsAuditReport(128)
ClassMethod IsAuditReport(PAADM)
{
	//是否总检
	s GSID=##class(web.DHCPE.ResultDiagnosis).GetSSId(PAADM)
	s AuditUser=""
	s:GSID'="" AuditUser=$P(^DHCPEGS(GSID,1),"^",5)
	q:AuditUser="" 1  ;没有总检
	s LocID=$P(^PAADM(PAADM),"^",4)
	//是否复检
	s MainDocFlag=$G(^DHCPESetting("DHCPE","MainDoctorGroup",LocID))
	i MainDocFlag="Y"
	{
		s MainInfo=$G(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",PAADM))
		s MainUser=$P(MainInfo,"^",1)
		q:MainUser="" 2 ;没有复检
	}
	q 0
}

}
