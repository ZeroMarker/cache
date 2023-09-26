Class web.DHCENS.STBLL.CDRJSONV2.LIS.Methond.getLisReportResult Extends (%RegisteredObject, %XML.Adaptor)
{

/// 重新更新检验的
ClassMethod SendLisReportSenFlag(sid As %String, eid As %String)
{
	for RPVisitNumberReportDr=sid:1:eid{
		set stream=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Methond.getLisReportResult).getLisReportResultBS(RPVisitNumberReportDr)
		s tRequest=##class(%Net.HttpRequest).%New()
		do tRequest.SetHeader("Cache-Control", "no-cache")
		Do tRequest.ContentTypeSet("application/x-www-form-urlencoded; charset=utf-8")
		set url="/hdc/SaveService/ACC0012"
	 	set tRequest.Server="127.0.0.1"
	 	set tRequest.Port="9098"
	 	d tRequest.InsertFormData("content",stream)
		set tSc = tRequest.Post(url)
		set OutputStream=tRequest.HttpResponse.Data
		
	}
	quit 0
}

/// creator:zhibao
/// creatdate:2021年1月4日
/// desc:
/// other:w ##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Methond.getLisReportResult).getLisReportResultBS("6819845")
ClassMethod getLisReportResultBS(RPVisitNumberReportDr As %String) As %GlobalCharacterStream
{
	set main=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.Data).%New()
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisReportResult).%New()	
	try{
		set subObj=..getLisReportResultinfoBS(RPVisitNumberReportDr)
		d main.LisReportResultList.Insert(subObj)
		
	}
	catch{
		b ;2
	
	}
	set stream=##class(%GlobalCharacterStream).%New()
	set JsonString=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.JSONUtil).ObjToJson(main,"")
	d stream.Write(JsonString)
	quit stream
}

ClassMethod FormatDate(Input As %String) As %String
{
	s $zt = "Error"
	q:Input="" ""
	s date=$zd($zdh(Input,8),3)
	q date
Error
	q ""
}

ClassMethod getLisReportResultinfoBS(RPVisitNumberReportDr) As web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisReportResult
{
	s ReportData=$g(^dbo.RPVisitNumberReportD(RPVisitNumberReportDr))
	s VisitNumberDR=$lg(ReportData,2)	
	s VisitNumberData=$g(^dbo.RPVisitNumberD(VisitNumberDR))
	s labNo=$lg(VisitNumberData,2)									//条码号
	s RegNo=$lg(VisitNumberData,3)
	s AdmNo=$lg(VisitNumberData,5)		
	i AdmNo'="" set PatientId=$p($g(^PAADM(AdmNo)),"^",1)
	else  set PatientId=""
	
	//检验日期,检验时间
	s AcceptDate=..FormatDate($lg(ReportData,9))	//核收日期
	s AcceptTime=..FormatTime($lg(ReportData,10))	//核收时间
	//审核日期,审核时间
	s AuthDate=..FormatDate($lg(ReportData,19))
	s AuthTime=..FormatTime($lg(ReportData,20))
	//审核者代码,审核者名称
	set AuthUserCode="",AuthUserName=""
	s AuthUserDR=$lg(ReportData,21)			//dbo.RP_VisitNumberReport->AuthUserDR->dbo.SYS_User
	i AuthUserDR'=""{
#;			s AuthUserCode=$lg($g(^dbo.SYSUserD(AuthUserDR)),2)
		s AuthUserCode=AuthUserDR
		s AuthUserName=$lg($g(^dbo.SYSUserD(AuthUserDR)),3)
	}else{
		s AuthUserCode="",AuthUserName=""
	}
	//报告日期,报告时间
	s EntryDate=..FormatDate($lg(ReportData,16))	//初审日期
	s EntryTime=..FormatTime($lg(ReportData,17))	//初审时间
	//报告者代码,报告者名称
	set EntryUserCode="",EntryUserName=""
	s EntryUserDR=$lg(ReportData,18)
	i EntryUserDR'=""{
#;			s EntryUserCode=$lg($g(^dbo.SYSUserD(EntryUserDR)),2)
		s EntryUserCode=EntryUserDR
		s EntryUserName=$lg($g(^dbo.SYSUserD(EntryUserDR)),3)
	}else{
		s EntryUserCode=AuthUserCode
		s EntryUserName=AuthUserName
	}	
	set OEORIARCItmMastCode="" 
	set OEORIARCItmMastDesc="" 
	set DiscardDate=..FormatDate($lg(ReportData,36))	//作废日期
	set DiscardTime=..FormatTime($lg(ReportData,37))	//作废时间
	set DisCardNotes=$lg(ReportData,39)
	set DiscardUserDR=$lg(ReportData,38)
	set DiscardUserCode="",DiscardUserName=""
	i DiscardUserDR'=""{
#;			s DiscardUserCode=$lg($g(^dbo.SYSUserD(DiscardUserDR)),2)
		s DiscardUserCode=DiscardUserDR
		s DiscardUserName=$lg($g(^dbo.SYSUserD(DiscardUserDR)),3)
	}
	set UploadDate=..FormatDate($lg(ReportData,12))	//上机日期
	set UploadTime=..FormatTime($lg(ReportData,13))	//上机时间
	set ReportType=$lg(ReportData,35)    /// 普通报告or危急报告
	set WorkGroupMachineDR=$lg(ReportData,4)
	set WorkGroupCode="",WorkGroupName="",ReportClass=""
	if (WorkGroupMachineDR'=""){
		set WorkGroupData=$G(^dbo.BTWorkGroupD($lg($g(^dbo.BTWorkGroupMachineD(WorkGroupMachineDR)),4)))
#;			set WorkGroupCode=$lg(WorkGroupData,2)					///科室工作组代码
		set WorkGroupCode=WorkGroupMachineDR
		set WorkGroupName=$lg(WorkGroupData,3)					///科室工作组名称
		if WorkGroupName["微生物"{
			set ReportClass=1
		}else{
			set ReportClass=2	
		}	
	}
	set lisrrisactive=$lg(ReportData,22)
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisReportResult).%New()
	set businessfieldcode=subObj.businessfieldcode
	set subObj.businessfieldcode=businessfieldcode
	set subObj.lisirorderitemdesc=OEORIARCItmMastDesc
	set subObj.lisrrcanceldate=DiscardDate
	set subObj.lisrrcancelreason=DisCardNotes
	set subObj.lisrrcanceltime=DiscardTime
	set subObj.lisrrcancelusercode=DiscardUserCode
	set subObj.lisrrcancelusername=DiscardUserName
	set subObj.lisrrcheckdate=AuthDate
	set subObj.lisrrchecktime=AuthTime
	set subObj.lisrrcheckusercode=AuthUserCode
	set subObj.lisrrcheckusername=AuthUserName
	set subObj.lisrrfirstcheckdate=EntryDate
	set subObj.lisrrfirstchecktime=EntryTime
	set subObj.lisrrfirstcheckusercode=AuthUserCode
	set subObj.lisrrfirstcheckusername=AuthUserName
	set subObj.lisrridentifition=""     //鉴定结果
	set subObj.lisrrismcroorganism=ReportClass
	set subObj.lisrrmachinedate=UploadDate
	set subObj.lisrrmachinetime=UploadTime
	set subObj.lisrrremarks=""
	set subObj.lisrrreportdeptcode=WorkGroupCode
	set subObj.lisrrreportdeptdesc=WorkGroupName
	set subObj.lisrrreportpdf=""
	set subObj.lisrrreporttype=ReportType
	set subObj.lisrrreportxml=""
	set subObj.lisrrtestdate=AcceptDate
	set subObj.lisrrtesttime=AcceptTime
	set subObj.lissrhoslisreportid=RPVisitNumberReportDr
	set subObj.updatedate=$zd(+$h,3)
	set subObj.updatetime=$zt($p($h,",",2))
	set subObj.lissrrellisreportid=businessfieldcode_"_"_RPVisitNumberReportDr
	set subObj.paadmrelvisitnumber=businessfieldcode_"_"_AdmNo
	set subObj.papatrelpatientid=businessfieldcode_"_"_PatientId
	set subObj.lisrrisactive=lisrrisactive
	quit subObj
}

ClassMethod FormatTime(Time As %String) As %String
{
	s $zt = "Error"
	q:Time="" ""
	q:$l(Time)>5 ""
	q:'$ISVALIDNUM(Time) ""
	s Time=$zt(Time)
	q Time	
Error
	q ""
}

/// creatdate:2021年1月4日
/// desc:检验报告结果历史数据 Global
/// other:w ##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Methond.getLisReportResult).getLisReportResultBShistoyGlobal("1","6843309")
ClassMethod getLisReportResultBShistoyGlobal(strRowId As %String, endRowId As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisReportResult).%New()
	if (strRowId="")||(endRowId="") {
		quit "-1^id不能为空"
	}
	set ^ExportHistoryData("lisreportresult")=$lb("院内检验报告号","报告科室代码","初审日期","初审时间","初审医生代码","审核日期","审核时间","审核医生代码","上机日期","上机时间","检测日期","检测时间","作废日期","作废时间","作废医生代码","作废原因","报告内容xml","报告内容pdf","报告类型","备注","是否微生物报告","时间戳","时间戳","鉴定结果(微生物才有)","审核医生描述","初审医生描述","作废医生描述","医嘱描述","全局患者id","全局就诊id","报告状态")
	set RPVisitNumberReportDr="",con=0,strtime=$zt($p($now(),",",2))
	for RPVisitNumberReportDr=strRowId:1:endRowId{
		continue:$d(^dbo.RPVisitNumberReportD(RPVisitNumberReportDr))=0
		set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisReportResult).%New()
		set subObj=..getLisReportResultinfoBS(RPVisitNumberReportDr)
		set ^ExportHistoryData("lisreportresult",RPVisitNumberReportDr)=$lb(RPVisitNumberReportDr,subObj.lisrrreportdeptcode,subObj.lisrrfirstcheckdate,subObj.lisrrfirstchecktime,subObj.lisrrfirstcheckusercode,
																		subObj.lisrrcheckdate,subObj.lisrrchecktime,subObj.lisrrcheckusercode,subObj.lisrrmachinedate,subObj.lisrrmachinetime,
																		subObj.lisrrtestdate,subObj.lisrrtesttime,subObj.lisrrcanceldate,subObj.lisrrcanceltime,subObj.lisrrcancelusercode,
																		subObj.lisrrcancelreason,subObj.lisrrreportxml,subObj.lisrrreportpdf,subObj.lisrrreporttype,subObj.lisrrremarks,
																		subObj.lisrrismcroorganism,subObj.updatedate,subObj.updatetime,subObj.lisrridentifition,subObj.lisrrcheckusername,
																		subObj.lisrrfirstcheckusername,subObj.lisrrcancelusername,subObj.lisirorderitemdesc,subObj.papatrelpatientid,subObj.paadmrelvisitnumber,
																		subObj.lisrrisactive,subObj.businessfieldcode,subObj.lissrrellisreportid,subObj.lisrrreportdeptdesc)
		set con=con+1
		set no=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.StringUtil).point(strRowId, endRowId, con, RPVisitNumberReportDr)
		}			
	quit "Finish   count:"_con
Exception
	quit "-1^"_$ze
}

}
