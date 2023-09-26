Class web.DHCENS.STBLL.CDRJSONV2.LIS.Methond.getLisReportResultcs Extends (%RegisteredObject, %XML.Adaptor)
{

/// creator:zhibao
/// creatdate:2021年1月4日
/// desc:
/// other: w ##class(web.DHCENS.STBLL.CDRJSONV2.LIS.getLisReportResult).getLisReportResultCS("100038||B021||1").Read()
ClassMethod getLisReportResultCS(ReportDr As %String) As %GlobalCharacterStream
{
	set main=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.Data).%New()		
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisReportResult).%New()	
	try{
		set subObj=..getLisReportResultinfoCS(ReportDr)
		d main.LisReportResultList.Insert(subObj)
	}
	catch{
	}
	set stream=##class(%GlobalCharacterStream).%New()
	set JsonString=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.StringUtil).ObjToJson(main,"")
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

ClassMethod getLisReportResultinfoCS(ReportDr) As web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisReportResult
{
		s LabNo=+ReportDr	
								//条码号
		s OEORDRowId=$o(^OEORD(0,"EpisNo",LabNo,""))
		q:OEORDRowId=""
		s AdmNo=$p($g(^OEORD(OEORDRowId)),"^",1)
		i AdmNo'="" set PatientId=$p($g(^PAADM(AdmNo)),"^",1)
		else  set PatientId=""
		
		s labRelatId=$tr(ReportDr,$c(0),"")
		s labTSCode=$p(ReportDr,"||",2)
    	s labTSId=$p(ReportDr,"||",3)
		s TSData=$g(^TEPI($P(labRelatId,"||",1),1,labTSCode,labTSId))
	
		s AcceptDate="",AcceptTime=""
		s AcceptDate=$p(TSData,"\",21)  
		s:AcceptDate'="" AcceptDate=$ZD(AcceptDate,3)  //核收日期
		s AcceptTime=$p(TSData,"\",22)  
		s:AcceptTime'="" AcceptTime=$ZT(AcceptTime,1)  //核收时间
		
		//审核日期,审核时间
		s AuthDate=$p(TSData,"\",4)  
		s:$Length(AuthDate) AuthDate=$ZD(AuthDate,3) 
		s AuthTime=$p(TSData,"\",5)  
		s:$Length(AuthTime) AuthTime=$ZT(AuthTime,1)  
	
		//审核者代码,审核者名称
		s AuthUserCode="",AuthUserName=""
		s AuthUserCode=$p(TSData,"\",6)
		s AuthUserName=""
		i $Length(AuthUserCode) 
 		{
	 		s CheckRowId=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(AuthUserCode),""))
	 		s AuthUserCode=CheckRowId
			s:CheckRowId'="" AuthUserName=$Piece($g(^SSU("SSUSR",CheckRowId)),"^",2) 
 		}
		
		//报告日期,报告时间
		s EntryDate=$P(TSData,"\",4)
		s:EntryDate'="" EntryDate=$ZD(EntryDate,3)
		/// 报告发布时间
		s EntryTime=$P(TSData,"\",5)
		s:EntryTime'="" EntryTime=$ZT(EntryTime)	
		
		//报告者代码,报告者名称
		set EntryUserCode="",EntryUserName=""
		s EntryUserCode=$P(TSData,"\",6)
		s reportUserName=""
		i (EntryUserCode'="") {
	 		s reportUserRowId=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(EntryUserCode),""))
			s EntryUserCode=reportUserRowId
			s:reportUserRowId'="" reportUserName=$p($g(^SSU("SSUSR",reportUserRowId)),"^",2)
 		}
 	
    	set OEORIARCItmMastCode="" //$p($g(^ARCIM(arcSub,arcVer,1)),"^",1)
    	set OEORIARCItmMastDesc="" //$p($g(^ARCIM(arcSub,arcVer,1)),"^",2)
    	
    	set DiscardDate=""	//作废日期
    	set DiscardTime=""	//作废时间
		set DisCardNotes=""
		set DiscardUserDR=""
		set DiscardUserCode="",DiscardUserName=""
		i DiscardUserDR'=""{
			s DiscardUserCode=""
			s DiscardUserName=""
		}
		set UploadDate=""	//上机日期
		set UploadTime=""	//上机时间
		set WorkGroupCode="",WorkGroupName=""   // 报告科室代码，报告科室名称
		set lisrrisactive=1				///报告日期   2021年11月10日
		set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisReportResult).%New()
		set businessfieldcode=subObj.businessfieldcode
		set subObj.lisirorderitemdesc=OEORIARCItmMastDesc
		set subObj.lisrrcanceldate=DiscardDate
		set subObj.lisrrcancelreason=DisCardNotes
		set subObj.lisrrcanceltime=DiscardTime
		set subObj.lisrrcancelusercode=DiscardUserCode
		set subObj.lisrrcancelusername=DiscardUserName
		set subObj.lisrrcheckdate=AuthDate
		set subObj.lisrrchecktime=EntryTime
		set subObj.lisrrcheckusercode=AuthUserCode
		set subObj.lisrrcheckusername=AuthUserName
		set subObj.lisrrfirstcheckdate=AuthDate
		set subObj.lisrrfirstchecktime=EntryTime
		set subObj.lisrrfirstcheckusercode=AuthUserCode
		set subObj.lisrrfirstcheckusername=AuthUserName
		set subObj.lisrridentifition=""     //鉴定结果
		set subObj.lisrrismcroorganism="" //ReportClass
		set subObj.lisrrmachinedate=UploadDate
		set subObj.lisrrmachinetime=UploadTime
		set subObj.lisrrremarks=""
		set subObj.lisrrreportdeptcode=WorkGroupCode
		set subObj.lisrrreportdeptdesc=WorkGroupName
		set subObj.lisrrreportpdf=""
		set subObj.lisrrreporttype="" //ReportClass
		set subObj.lisrrreportxml=""
		set subObj.lisrrtestdate=AcceptDate
		set subObj.lisrrtesttime=AcceptTime
		set subObj.lisrrisactive=lisrrisactive
		set subObj.lissrhoslisreportid=ReportDr
		set subObj.lissrrellisreportid=businessfieldcode_"_"_ReportDr
		set subObj.paadmrelvisitnumber=businessfieldcode_"_"_AdmNo
		set subObj.papatrelpatientid=businessfieldcode_"_"_PatientId
	quit subObj
}

/// w ##class(web.DHCENS.STBLL.CDRJSONV2.LIS.getLisReportResult).getLisReportResultBShistoyCS("2018-12-10","2019-02-01")
ClassMethod getLisReportResultglobal(startDate, endDate) As %GlobalCharacterStream
{
	set $zt="Exception"
	set ^ExportHistoryData("lisreportresult")=$lb("院内检验报告号","报告科室代码","初审日期","初审时间","初审医生代码","审核日期","审核时间","审核医生代码","上机日期","上机时间","检测日期","检测时间","作废日期","作废时间","作废医生代码","作废原因","报告内容xml","报告内容pdf","报告类型","备注","是否微生物报告","时间戳","时间戳","鉴定结果(微生物才有)","审核医生描述","初审医生描述","作废医生描述","医嘱描述","全局患者id","全局就诊id")
	set:startDate'="" startDate=$zdh(startDate,3)
	set:startDate="" startDate=+$h
	set:endDate'="" endDate=$zdh(endDate,3)
	set:endDate="" endDate=+$h
	set OEORDRowId="",con=0,flag=0
	for{
		set OEORDRowId= $o(^OEORDi(0,"LabTS",OEORDRowId)) 
		q:OEORDRowId=""
		set ReportResultDr=""
		for
		{
			set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisReportResult).%New()
			set ReportResultDr=$o(^OEORDi(0,"LabTS",OEORDRowId,ReportResultDr))
			q:ReportResultDr=""
			set OEORIChildsub=$o(^OEORDi(0,"LabTS",OEORDRowId,ReportResultDr,""))
			set veriDate=SP(SG(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",7)
			Quit:((startDate'="")&&(startDate>veriDate))
			set:(endDate'="")&&(veriDate>endDate) flag=1
			Quit:((endDate'="")&&(veriDate>endDate))
			set subObj=..getLisReportResultinfoCS(ReportResultDr)
			set ^ExportHistoryData("lisreportresult",ReportResultDr)=$lb(ReportResultDr,subObj.lisrrreportdeptcode,subObj.lisrrfirstcheckdate,subObj.lisrrfirstchecktime,subObj.lisrrfirstcheckusercode,
																		subObj.lisrrcheckdate,subObj.lisrrchecktime,subObj.lisrrcheckusercode,subObj.lisrrmachinedate,subObj.lisrrmachinetime,
																		subObj.lisrrtestdate,subObj.lisrrtesttime,subObj.lisrrcanceldate,subObj.lisrrcanceltime,subObj.lisrrcancelusercode,
																		subObj.lisrrcancelreason,subObj.lisrrreportxml,subObj.lisrrreportpdf,subObj.lisrrreporttype,subObj.lisrrremarks,
																		subObj.lisrrismcroorganism,subObj.updatedate,subObj.updatetime,subObj.lisrridentifition,subObj.lisrrcheckusername,
																		subObj.lisrrfirstcheckusername,subObj.lisrrcancelusername,subObj.lisirorderitemdesc,subObj.papatrelpatientid,subObj.paadmrelvisitnumber,
																		subObj.lisrrisactive,subObj.businessfieldcode,subObj.lissrrellisreportid,subObj.lisrrreportdeptdesc)
			set con=con+1
			i con#100=0 w "count:"_con_"    id:"_ReportResultDr ,!
			}
			quit:flag=1
		}
			quit "Finish   count:"_con
Exception
	quit "-1^"_$ze
}

}
