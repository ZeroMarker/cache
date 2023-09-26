Class web.DHCENS.STBLL.CDRJSONV2.RIS.Method.RisReport Extends (%RegisteredObject, %XML.Adaptor)
{

/// createdate:	2020年12月29日
/// creator:	zhibao
/// desc: 		获取检查登记信息
/// table:		DHCRB_RegInfo
/// outout:
/// other: w ##class(web.DHCENS.STBLL.CDRJSONV2.RIS.Method.RisReport).getRisReport("2436032")
ClassMethod getRisReport(rowid As %String) As %GlobalCharacterStream
{
	try{
		set main=##class(web.DHCENS.STBLL.CDRJSONV2.RIS.Model.Data).%New()
		set subobj=##class(web.DHCENS.STBLL.CDRJSONV2.RIS.Model.Risreport).%New()  
		set subobj=..RisReportInfo(rowid)
		d main.risreportList.Insert(subobj)

	}catch{
		b ;2
		set main=##class(web.DHCENS.STBLL.CDRJSONV2.RIS.Model.Data).%New()
		set subobj=##class(web.DHCENS.STBLL.CDRJSONV2.RIS.Model.Risreport).%New()
		d main.risreportList.Insert(subobj)  
	}
	set outputStream=##class(%GlobalCharacterStream).%New()
	set JsonString=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.JSONUtil).ObjToJson(main,"")
	d outputStream.Write(JsonString)
	q outputStream
}

/// 检查报告的医生是直接从 报告表中获取的数据。
/// 所以取值时应该直接获取到医生的姓名
ClassMethod RisReportInfo(rowid) As web.DHCENS.STBLL.CDRJSONV2.RIS.Model.Risreport
{
	Try
	{
		/*检查号*/
		set StudyNo=$p($g(^DHCRBStudy("Report",rowid)),"^",1)
		/*报告ID*/
		set ReportID=$p($g(^DHCRBStudy("Report",rowid)),"^",2)
		/*报告状态*/
		set statusDR=$p($g(^DHCRBStudy("Report",rowid)),"^",4)
		/*报告医生*/
		set ReportDocDR=$p($g(^DHCRBStudy("Report",rowid)),"^",8)
		//set ReportDocDR=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.UserUtil).queryCarepoovidByUserid(ReportDocDR)
		set ReportDocName=""
		if ReportDocDR'="" set ReportDocName=$p($g(^SSU("SSUSR",ReportDocDR)),"^",2)
		/*报告日期*/
		set ReportDate=$p($g(^DHCRBStudy("Report",rowid)),"^",9)
		if ReportDate'="" set ReportDate=$zd(ReportDate,3)
		/*报告时间*/
		set ReportTime=$p($g(^DHCRBStudy("Report",rowid)),"^",10)
		if ReportTime'="" set ReportTime=$zt(ReportTime)
		/*审核医生*/
		set VerifyDocDR=$p($g(^DHCRBStudy("Report",rowid)),"^",11)
		set VerifyDocName=""
		if VerifyDocDR'="" set VerifyDocName=$p($g(^SSU("SSUSR",VerifyDocDR)),"^",2)
		//set VerifyDocDR=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.UserUtil).queryCarepoovidByUserid(VerifyDocDR)
		/*审核日期*/
		set VerifyDate=$p($g(^DHCRBStudy("Report",rowid)),"^",12)
		if VerifyDate'="" set VerifyDate=$zd(VerifyDate,3)
		/*审核时间*/
		set VerifyTime=$p($g(^DHCRBStudy("Report",rowid)),"^",13)
		if VerifyTime'="" set VerifyTime=$zt(VerifyTime)
		/*检查方法*/
		set ExamMethod=$p($g(^DHCRBStudy("Report",rowid)),"^",24)
		/*录入者*/
		set Typist = $p($g(^DHCRBStudy("Report",rowid)),"^",26)
		/*检查所见*/
		set strExam=$g(^DHCRBStudy("Report",rowid,"ExamDescEx"))
		/*检查结果*/
		set strResult=$g(^DHCRBStudy("Report",rowid,"ResultDescEx"))
		/*检查备注*/
		set strRptMemo=$g(^DHCRBStudy("Report",rowid,"MemoEx"))
		/*肉眼所见*/
		set strSee=$g(^DHCRBStudy("Report",rowid,"DRPT_SeeDesc"))
		/*医嘱号*/
		set ordItemId=$p(^DHCRBStudy("Report",rowid),"^",15)
		/*就诊号*/
		set ord=$p(ordItemId,"||",1)
		set sub=$p(ordItemId,"||",2)
		set adminId=$p($g(^OEORD(ord)),"^",1)
		/*登记号*/
		
		set patientid=$p($g(^PAADM(adminId)),"^",1)
		set arcimId=$p($g(^OEORD(ord,"I",sub,1)),"^",2)
		set OEORISttDate=$p($g(^OEORD(ord,"I",sub,1)),"^",9)
		set OEORISttTime=$p($g(^OEORD(ord,"I",sub,1)),"^",10)
		set:ReportDate="" ReportDate=$zd(OEORISttDate,3)
		set:ReportTime="" ReportTime=$zt(OEORISttTime)
		set arcSub = $P(arcimId,"||",1)
    	set arcVer = $P(arcimId,"||",2)
		set OEORIARCItmMastCode=arcimId
    	set:arcSub'="" OEORIARCItmMastDesc=$p($g(^ARCIM(arcSub,arcVer,1)),"^",2)
		set subobj=##class(web.DHCENS.STBLL.CDRJSONV2.RIS.Model.Risreport).%New()
		set businessfieldcode=subobj.businessfieldcode
		set subobj.businessfieldcode=businessfieldcode
		set subobj.oeorirelorderitemid=businessfieldcode_"_"_ordItemId
		set subobj.paadmrelvisitnumber=businessfieldcode_"_"_adminId
		set subobj.papatrelpatientid=businessfieldcode_"_"_patientid
		set subobj.risorelexamid=businessfieldcode_"_"_StudyNo
		set subobj.risrcheckdate=VerifyDate
		set subobj.risrcheckdoccode=VerifyDocDR
		set subobj.risrcheckdocname=VerifyDocName
		set subobj.risrchecktime=VerifyTime
		set subobj.risrcontentpdf=""
		set subobj.risrcontentxml=""
		set subobj.risrdiagdesc=strResult
		set subobj.risracrcode=OEORIARCItmMastCode
		set subobj.risrexamdesc=strExam
		set subobj.risrfinalcheckdate=VerifyDate
		set subobj.risrfinalcheckdoccode=VerifyDocDR
		set subobj.risrfinalcheckdocname=VerifyDocName
		set subobj.risrfinalchecktime=VerifyTime
		set subobj.risrhosrisreportid=rowid
		set subobj.risrimagesrc=""
		set subobj.risrisget=""
		set subobj.risrispositive=""
		set subobj.risritemdesc=OEORIARCItmMastDesc
		set subobj.risrorderitemdesc=OEORIARCItmMastDesc
		set subobj.risrrelrisreportid=businessfieldcode_"_"_rowid
		set subobj.risrreportdate=ReportDate
		set subobj.risrreportdoccode=ReportDocDR
		set subobj.risrreportdocname=ReportDocName
		set subobj.risrreportimagesrc=""
		set subobj.risrreporttime=ReportTime
		set subobj.risrwarncode=""
	}
	catch
	{
		set subobj=##class(web.DHCENS.STBLL.CDRJSONV2.RIS.Model.Risreport).%New()
	}
		quit subobj
}

/// desc: 		获取检查登记信息历史数据(Global)
/// table:		
/// outout: ris_report
/// other: w ##class(web.DHCENS.STBLL.CDRJSONV2.RIS.Method.RisReport).getRisReportGlobal("1","2438524")
ClassMethod getRisReportGlobal(stradmRowId As %String, endadmRowId As %String) As %String
{
	set $zt="Exception"
	if (stradmRowId="")||(endadmRowId="") {
		quit "error"="-1^id不能为空"
	}
	set ^ExportHistoryData("risreport")=$lb("医院内部报告号","报告医生代码","报告日期","报告时间","审核医生代码","审核日期","审核时间","终审医生代码","终审日期","终审时间","检查项目描述","检查方法","检查所见","诊断意见","报告内容","报告内容pdf","报告建议","是否已领取","时间戳","时间戳","报告医生描述","审核医生描述","终审医生描述","医嘱描述","业务域_院内患者id","业务域_院内就诊号","全局检查号","全局医嘱明细id","图像链接","图片报告链接","是否危急","是否阳性")
	set rowid="",con=0,strtime=$zt($p($now(),",",2))
	for rowid=stradmRowId:1:endadmRowId{
		set subobj=##class(web.DHCENS.STBLL.CDRJSONV2.RIS.Model.Risreport).%New()
		continue:$d(^DHCRBStudy("Report",rowid))=0
		set subobj=..RisReportInfo(rowid)
		set ^ExportHistoryData("risreport",rowid)=$lb(subobj.risrhosrisreportid,subobj.risrreportdoccode,subobj.risrreportdate,subobj.risrreporttime,subobj.risrcheckdoccode,subobj.risrcheckdate,subobj.risrchecktime,subobj.risrfinalcheckdoccode,subobj.risrfinalcheckdate,subobj.risrfinalchecktime,subobj.risritemdesc,subobj.risrmethod,subobj.risrexamdesc,subobj.risrdiagdesc,subobj.risrcontentxml,subobj.risrcontentpdf,subobj.risradvisedesc,subobj.risrisget,subobj.updatedate,subobj.updatetime,subobj.risrreportdocname,subobj.risrfinalcheckdocname,subobj.risrfinalcheckdocname,subobj.risrorderitemdesc,subobj.papatrelpatientid,subobj.paadmrelvisitnumber,subobj.risorelexamid,subobj.oeorirelorderitemid,subobj.risrimagesrc,subobj.risrisget,subobj.risrwarncode,subobj.risrispositive,subobj.businessfieldcode)
		set con=con+1
		set no=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.StringUtil).point(stradmRowId, endadmRowId, con, rowid)		
	}
	quit "Finish   count:"_con
Exception
	quit "-1^"_$ze
}

}
