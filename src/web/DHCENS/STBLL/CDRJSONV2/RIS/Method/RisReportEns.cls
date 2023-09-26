Class web.DHCENS.STBLL.CDRJSONV2.RIS.Method.RisReportEns Extends (%RegisteredObject, %XML.Adaptor)
{

/// createdate:	2020年12月29日
/// creator:	zhibao
/// desc: 		获取检查登记信息
/// table:		//从User.EnsRISReportResult取报告信息
/// outout:
/// other: w ##class(web.DHCENS.STBLL.CDRJSONV2.RIS.Method.RisReportEns).queryRisReport("651699")
ClassMethod queryRisReport(rowid As %String) As %GlobalCharacterStream
{
	try{
		set main=##class(web.DHCENS.STBLL.CDRJSONV2.RIS.Model.Data).%New()
		set subobj=##class(web.DHCENS.STBLL.CDRJSONV2.RIS.Model.Risreport).%New()  
		set subobj=..RisReportInfoEns(rowid) //从User.EnsRISReportResult取报告信息
		d main.risreportList.Insert(subobj)

	}catch{
		set main=##class(web.DHCENS.STBLL.CDRJSONV2.RIS.Model.Data).%New()
		set subobj=##class(web.DHCENS.STBLL.CDRJSONV2.RIS.Model.Risreport).%New()
		d main.risreportList.Insert(subobj)  
	}
	set outputStream=##class(%GlobalCharacterStream).%New()
	set JsonString=##class(web.DHCENS.STBLL.CDRJSONV2.common.CommonMethod).ObjToJson(main,"")
	d outputStream.Write(JsonString)
	q outputStream
}

// 从User.EnsRISReportResult取报告信息

/// w ##class(web.DHCENS.STBLL.CDRJSONV2.RIS.Method.getRisReportEns).RisReportInfoEnsNew("658094")
ClassMethod RisReportInfoEns(id) As web.DHCENS.STBLL.CDRJSONV2.RIS.Model.Risreport
{
	set subobj=##class(web.DHCENS.STBLL.CDRJSONV2.RIS.Model.Risreport).%New()
	set businessfieldcode=subobj.businessfieldcode
	set subobj.businessfieldcode=businessfieldcode  //业务域
	set risrhosrisreportid=$lg(^Busi.ENS.EnsRISReportResultD(id),2)
	set subobj.risrhosrisreportid=risrhosrisreportid //医院内部报告号
	set subobj.risohosrisexamid=$lg(^Busi.ENS.EnsRISReportResultD(id),3) //院内检查号
	set ReportID=subobj.risohosrisexamid
	set subobj.oeorirelorderitemid=businessfieldcode_"_"_$lg(^Busi.ENS.EnsRISReportResultD(id),4) //全局医嘱明细id
	set orderItemId=$lg(^Busi.ENS.EnsRISReportResultD(id),4)
	set subobj.papatrelpatientid=businessfieldcode_"_"_$lg(^Busi.ENS.EnsRISReportResultD(id),5) //业务域_院内患者id
	set subobj.paadmrelvisitnumber=businessfieldcode_"_"_$lg(^Busi.ENS.EnsRISReportResultD(id),6) //业务域_院内就诊号
	set subobj.risorelexamid=businessfieldcode_"_"_$lg(^Busi.ENS.EnsRISReportResultD(id),3) //院内检查号
	set subobj.risrreportdoccode=$lg(^Busi.ENS.EnsRISReportResultD(id),8) //报告医生代码
	set subobj.risrreportdocname=$lg(^Busi.ENS.EnsRISReportResultD(id),9) //报告医生描述
	set subobj.risrreportdate=$lg(^Busi.ENS.EnsRISReportResultD(id),10) //报告日期
	set:subobj.risrreportdate'="" subobj.risrreportdate=$zd(subobj.risrreportdate,3)
	set subobj.risrreporttime=$lg(^Busi.ENS.EnsRISReportResultD(id),11) //报告时间
	set:subobj.risrreporttime'="" subobj.risrreporttime=$zt(subobj.risrreporttime)
	set subobj.risrcheckdoccode=$lg(^Busi.ENS.EnsRISReportResultD(id),12) //审核医生代码
	set subobj.risrcheckdocname=$lg(^Busi.ENS.EnsRISReportResultD(id),13) //审核医生描述
	set subobj.risrreportdate=$lg(^Busi.ENS.EnsRISReportResultD(id),14) //报告日期
	set:subobj.risrreportdate'="" subobj.risrreportdate=$zd(subobj.risrreportdate,3)
	set subobj.risrreporttime=$lg(^Busi.ENS.EnsRISReportResultD(id),15) //报告时间
	set:subobj.risrreporttime'="" subobj.risrreporttime=$zt(subobj.risrreporttime)
	set subobj.risrfinalcheckdoccode=$lg(^Busi.ENS.EnsRISReportResultD(id),16) //终审医生代码
	set subobj.risrfinalcheckdocname=$lg(^Busi.ENS.EnsRISReportResultD(id),17) //终审医生描述
	set subobj.risrfinalcheckdate=$lg(^Busi.ENS.EnsRISReportResultD(id),18) //终审日期
	set:subobj.risrfinalcheckdate'="" subobj.risrfinalcheckdate=$zd(subobj.risrfinalcheckdate,3)
	set subobj.risrfinalchecktime=$lg(^Busi.ENS.EnsRISReportResultD(id),19) //终审时间
	set:subobj.risrfinalchecktime'="" subobj.risrfinalchecktime=$zt(subobj.risrfinalchecktime)
	set subobj.risritemdesc=$lg(^Busi.ENS.EnsRISReportResultD(id),20) //检查项目描述
	set subobj.risobacode=$lg(^Busi.ENS.EnsRISReportResultD(id),21) //检查部位代码
	set subobj.risobadesc=$lg(^Busi.ENS.EnsRISReportResultD(id),22) //检查部位描述
	set subobj.risrmethod=$lg(^Busi.ENS.EnsRISReportResultD(id),23) //检查方法
	set subobj.risrexamdesc=$lg(^Busi.ENS.EnsRISReportResultD(id),24) //检查所见
	set subobj.risrdiagdesc=$lg(^Busi.ENS.EnsRISReportResultD(id),25) //诊断意见
	set subobj.risradvisedesc=$lg(^Busi.ENS.EnsRISReportResultD(id),27) //报告建议
	set subobj.risrisget=$lg(^Busi.ENS.EnsRISReportResultD(id),28) //是否已领取
	set subobj.risrorderitemdesc=$lg(^Busi.ENS.EnsRISReportResultD(id),31) //医嘱描述
	set subobj.risrimagesrc=$lg(^Busi.ENS.EnsRISReportResultD(id),32) //图像链接
	set subobj.risrreportimagesrc=$lg(^Busi.ENS.EnsRISReportResultD(id),33) //图片报告链接
	set subobj.risrispositive=$lg(^Busi.ENS.EnsRISReportResultD(id),35) //是否阳性
	set subobj.risrcontentxml=""	//报告内容
	set subobj.risrcontentpdf=""	//报告内容pdf
	set str="02001^02002^02003^02004^02006"
	set leth=$l(str,"^")
	for i=1:1:leth {
		s code=$p(str,"^",i)
		set RelOrderDocumentRowId=""
		if $d(^Busi.ENS.EnsRelOrderDocumentI("RelODRisExamIDIndex",risrhosrisreportid,"xml")){
			set RelOrderDocumentRowId=$o(^Busi.ENS.EnsRelOrderDocumentI("RelODRisExamIDIndex",risrhosrisreportid,"xml",RelOrderDocumentRowId))
			set:RelOrderDocumentRowId'="" RelODDocumentID=$lg(^Busi.ENS.EnsRelOrderDocumentD(RelOrderDocumentRowId),2)
			set:RelODDocumentID'="" DocumentRowID=$O(^Busi.ENS.EnsHOSDocumentI("HOSDOCUMENTPKey",RelODDocumentID,""))
			set:DocumentRowID'="" subobj.risrcontentxml=$lg(^Busi.ENS.EnsHOSDocumentD(DocumentRowID),19)
		}elseif $d(^Busi.ENS.EnsRelOrderDocumentI("RelODOrderItemIDIndex",orderItemId,"xml")){
			set RelOrderDocumentRowId=$o(^Busi.ENS.EnsRelOrderDocumentI("RelODOrderItemIDIndex",orderItemId,"xml",RelOrderDocumentRowId))
			set:RelOrderDocumentRowId'="" RelODDocumentID=$lg(^Busi.ENS.EnsRelOrderDocumentD(RelOrderDocumentRowId),2)
			set:RelODDocumentID'="" DocumentRowID=$O(^Busi.ENS.EnsHOSDocumentI("HOSDOCUMENTPKey",RelODDocumentID,""))
			set:DocumentRowID'="" subobj.risrcontentxml=$lg(^Busi.ENS.EnsHOSDocumentD(DocumentRowID),19)
			}
		set RelOrderDocumentRowId=""
		if $d(^Busi.ENS.EnsRelOrderDocumentI("RelODRisExamIDIndex",risrhosrisreportid,"pdf")){
			set RelOrderDocumentRowId=$o(^Busi.ENS.EnsRelOrderDocumentI("RelODRisExamIDIndex",risrhosrisreportid,"pdf",RelOrderDocumentRowId))
			set:RelOrderDocumentRowId'="" RelODDocumentID=$lg(^Busi.ENS.EnsRelOrderDocumentD(RelOrderDocumentRowId),2)
			set:RelODDocumentID'="" DocumentRowID=$O(^Busi.ENS.EnsHOSDocumentI("HOSDOCUMENTPKey",RelODDocumentID,""))
			set:DocumentRowID'="" subobj.risrcontentpdf=$lg(^Busi.ENS.EnsHOSDocumentD(DocumentRowID),19)
		}elseif $d(^Busi.ENS.EnsRelOrderDocumentI("RelODOrderItemIDIndex",orderItemId,"pdf")){
			set RelOrderDocumentRowId=$o(^Busi.ENS.EnsRelOrderDocumentI("RelODOrderItemIDIndex",orderItemId,"pdf",RelOrderDocumentRowId))
			set:RelOrderDocumentRowId'="" RelODDocumentID=$lg(^Busi.ENS.EnsRelOrderDocumentD(RelOrderDocumentRowId),2)
			set:RelODDocumentID'="" DocumentRowID=$O(^Busi.ENS.EnsHOSDocumentI("HOSDOCUMENTPKey",RelODDocumentID,""))
			set:DocumentRowID'="" subobj.risrcontentpdf=$lg(^Busi.ENS.EnsHOSDocumentD(DocumentRowID),19)
		}
	}
	set subobj.updatedate=$zd(+$h,3)  //时间戳
	set subobj.updatetime=$zt($p($h,",",2))  //时间戳
	set subobj.risrrelrisreportid=businessfieldcode_"_"_subobj.risrhosrisreportid	//全局检查报告号	
	set subobj.risrwarncode=""	//是否危急
	quit subobj
}

/// desc: 	获取检查登记信息历史数据(Global)
/// table:		
/// outout:从User.EnsRISReportResult取报告信息
/// other: w ##class(web.DHCENS.STBLL.CDRJSONV2.RIS.Method.getRisReportEns).getRisReportGlobal("1","82354")
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
		continue:$d(^Busi.ENS.EnsRISReportResultD(rowid))=0
		set subobj=..RisReportInfoEns(rowid)
		set ^ExportHistoryData("risreport",rowid)=$lb(subobj.risrhosrisreportid,subobj.risrreportdoccode,subobj.risrreportdate,
													subobj.risrreporttime,subobj.risrcheckdoccode,subobj.risrcheckdate,subobj.risrchecktime,
													subobj.risrfinalcheckdoccode,subobj.risrfinalcheckdate,subobj.risrfinalchecktime,
													subobj.risritemdesc,subobj.risrmethod,subobj.risrexamdesc,subobj.risrdiagdesc,
													subobj.risrcontentxml,subobj.risrcontentpdf,subobj.risradvisedesc,subobj.risrisget,
													subobj.updatedate,subobj.updatetime,subobj.risrreportdocname,subobj.risrfinalcheckdocname,
													subobj.risrfinalcheckdocname,subobj.risrorderitemdesc,subobj.papatrelpatientid,
													subobj.paadmrelvisitnumber,subobj.risorelexamid,subobj.oeorirelorderitemid,subobj.risrimagesrc,
													subobj.risrisget,subobj.risrwarncode,subobj.risrispositive,subobj.businessfieldcode)
		set con=con+1
		set no=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.StringUtil).point(stradmRowId, endadmRowId, con, rowid)		
	}
	quit "Finish   count:"_con
Exception
	quit "-1^"_$ze
}

}
