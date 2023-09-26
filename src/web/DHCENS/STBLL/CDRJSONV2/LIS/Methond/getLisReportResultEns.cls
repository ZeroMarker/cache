Class web.DHCENS.STBLL.CDRJSONV2.LIS.Methond.getLisReportResultEns Extends (%RegisteredObject, %XML.Adaptor)
{

/// creator:zhibao
/// creatdate:2021年1月4日
/// desc:
/// other:w ##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Methond.getLisReportResultEns).getLisReportResult("247822")
ClassMethod getLisReportResult(RPVisitNumberReportDr As %String) As %GlobalCharacterStream
{
	set main=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.Data).%New()
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisReportResult).%New()	
	try{
		set subObj=..getLisReportResultDHCENSnew(RPVisitNumberReportDr)
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

/// creatdate:2021年1月4日
/// desc:检验报告结果历史数据 Global
/// other:w ##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Methond.getLisReportResultEns).getLisReportResultBShistoyGlobal("1","249263")
ClassMethod getLisReportResultBShistoyGlobal(strRowId As %String, endRowId As %String) As %String
{
	set $zt="Exception"
	if (strRowId="")||(endRowId="") {
		quit "-1^id不能为空"
	}
	set ^ExportHistoryData("lisreportresult")=$lb("院内检验报告号","报告科室代码","初审日期","初审时间","初审医生代码","审核日期","审核时间","审核医生代码","上机日期","上机时间","检测日期","检测时间","作废日期","作废时间","作废医生代码","作废原因","报告内容xml","报告内容pdf","报告类型","备注","是否微生物报告","时间戳","时间戳","鉴定结果(微生物才有)","审核医生描述","初审医生描述","作废医生描述","医嘱描述","全局患者id","全局就诊id")
	set RPVisitNumberReportDr="",con=0,strtime=$zt($p($now(),",",2))
	for RPVisitNumberReportDr=strRowId:1:endRowId
	{
		continue:$d(^Busi.ENS.EnsLISReportResultD(RPVisitNumberReportDr))=0
		set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisReportResult).%New()
		set subObj=..getLisReportResultDHCENSnew(RPVisitNumberReportDr)
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

/// creator:zhibao
/// creatdate:2021年1月4日
/// desc:
/// other:w ##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Methond.getLisReportResultEns).getLisReportResultDHCENSnew("291262")
ClassMethod getLisReportResultDHCENSnew(id) As web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisReportResult
{
	set $zt="Exception"
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisReportResult).%New()
	s businessfieldcode=subObj.businessfieldcode
	s LisReportResult=^Busi.ENS.EnsLISReportResultD(id)
	s subObj.lissrhoslisreportid=$lg(LisReportResult,2)
	s reportid=subObj.lissrhoslisreportid
	s subObj.papatrelpatientid=businessfieldcode_"_"_$lg(LisReportResult,3)
	s subObj.paadmrelvisitnumber=businessfieldcode_"_"_$lg(LisReportResult,5)
	s subObj.lisrrmachinedate=$lg(LisReportResult,90)
	s:subObj.lisrrmachinedate'="" subObj.lisrrmachinedate=$zd(subObj.lisrrmachinedate,3)
	s subObj.lisrrmachinetime=$lg(LisReportResult,91)
	s:subObj.lisrrmachinetime'="" subObj.lisrrmachinetime=$zt(subObj.lisrrmachinetime)
	s subObj.lisrrtestdate=$lg(LisReportResult,92)
	s:subObj.lisrrtestdate'="" subObj.lisrrtestdate=$zd(subObj.lisrrtestdate,3)
	s subObj.lisrrtesttime=$lg(LisReportResult,93)
	s:subObj.lisrrtesttime'="" subObj.lisrrtesttime=$zt(subObj.lisrrtesttime)
	s subObj.lisrrcanceldate=$lg(LisReportResult,94)
	s:subObj.lisrrcanceldate'="" subObj.lisrrcanceldate=$zd(subObj.lisrrcanceldate,3)
	s subObj.lisrrcanceltime=$lg(LisReportResult,95)
	s:subObj.lisrrcanceltime'="" subObj.lisrrcanceltime=$zt(subObj.lisrrcanceltime)
	s subObj.lisrrcancelusercode=$lg(LisReportResult,96)
	s subObj.lisrrcancelusername=$lg(LisReportResult,97)
	s subObj.lisrrcancelreason=$lg(LisReportResult,98)
	set lisrrisactive=1   ///报告状态  ----2021年11月10日
	s subObj.lisrrreportxml=""
	s subObj.lisrrreportpdf=""
	set str="01001^01002"
	set leth=$l(str,"^")
	for i=1:1:leth d
	.s code=$p(str,"^",i)
	.if $d(^Busi.ENS.EnsHOSDocumentI("HOSDVersionNumberIndex","0001",code,"xml",reportid)) d
	..s Version=$o(^Busi.ENS.EnsHOSDocumentI("HOSDVersionNumberIndex","0001",code,"xml",reportid,""),-1)
	..s hosdid=$o(^Busi.ENS.EnsHOSDocumentI("HOSDVersionNumberIndex","0001",code,"xml",reportid,Version,""))
	..s subObj.lisrrreportxml=$lg(^Busi.ENS.EnsHOSDocumentD(hosdid),19)
	.if $d(^Busi.ENS.EnsHOSDocumentI("HOSDVersionNumberIndex","0001",code,"pdf",reportid)) d
	..s Version=$o(^Busi.ENS.EnsHOSDocumentI("HOSDVersionNumberIndex","0001",code,"pdf",reportid,""),-1)
	..s hosdid=$o(^Busi.ENS.EnsHOSDocumentI("HOSDVersionNumberIndex","0001",code,"pdf",reportid,Version,""))
	..s subObj.lisrrreportpdf=$lg(^Busi.ENS.EnsHOSDocumentD(hosdid),19)
	s subObj.lisrrreporttype=$lg(LisReportResult,101)
	s subObj.lisrrremarks=$lg(LisReportResult,102)
	s subObj.lisrrismcroorganism=$lg(LisReportResult,103)
	s subObj.lisrridentifition=$lg(LisReportResult,106)
	s subObj.lisrrcheckdate=$lg(LisReportResult,107)
	s:subObj.lisrrcheckdate'="" subObj.lisrrcheckdate=$zd(subObj.lisrrcheckdate,3)
	s subObj.lisrrchecktime=$lg(LisReportResult,108)
	s:subObj.lisrrchecktime'="" subObj.lisrrchecktime=$zt(subObj.lisrrchecktime)
	s subObj.lisrrcheckusercode=$lg(LisReportResult,109)
	s subObj.lisrrcheckusername=$lg(LisReportResult,110)
	s subObj.lisrrfirstcheckdate=$lg(LisReportResult,111)
	s:subObj.lisrrfirstcheckdate'="" subObj.lisrrfirstcheckdate=$zd(subObj.lisrrfirstcheckdate,3)
	s subObj.lisrrfirstchecktime=$lg(LisReportResult,112)
	s:subObj.lisrrfirstchecktime'="" subObj.lisrrfirstchecktime=$zt(subObj.lisrrfirstchecktime)
	s subObj.lisrrfirstcheckusercode=$lg(LisReportResult,113)
	s subObj.lisrrfirstcheckusername=$lg(LisReportResult,114)
	s subObj.lisrrorderitemdesc=$lg(LisReportResult,115)
	
	set subObj.lisrrisactive=lisrrisactive
	s subObj.lissrrellisreportid=businessfieldcode_"_"_$lg(LisReportResult,2)
	s LISIRShowSeq=$o(^Busi.ENS.EnsLISItemResultI("LISIRReportIDIndex",subObj.lissrhoslisreportid,""))
	s subObj.lisrrreportdeptcode=""
	if LISIRShowSeq'=""  {
		s itmid=$o(^Busi.ENS.EnsLISItemResultI("LISIRReportIDIndex",subObj.lissrhoslisreportid,LISIRShowSeq,""))
		if itmid'="" {
			if $d(^Busi.ENS.EnsLISItemResult(itmid))'=0{
			s LISIROrderItemID=$lg(^Busi.ENS.EnsLISItemResult(itmid),28)
			if LISIROrderItemID'=""{
				s lisrrreportdeptid=$p($g(^OEORD(+LISIROrderItemID,"I",$p(LISIROrderItemID,"||",2),3)),"^",6)
				s:lisrrreportdeptid'="" subObj.lisrrreportdeptcode=$p(^CTLOC(lisrrreportdeptid),"^",1)  //报告科室表里没有暂时先取医嘱接收科室
				}
			}
		}
	}
	set subObj.updatedate=$zd(+$h,3)
	set subObj.updatetime=$zt($p($h," ",2))
	q subObj
Exception	
    quit "-1^"_$ze
}

}
