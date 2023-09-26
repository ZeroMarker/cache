Class web.DHCENS.STBLL.CDRJSONV2.LIS.Methond.getLisSpecimenReport Extends (%RegisteredObject, %XML.Adaptor)
{

/// creator:zhibao
/// creatdate:2021年1月18日
/// desc: 根据检验报告表得获取条码和报告得关联关系
/// other: w ##class(web.DHCENS.STBLL.CDRJSONV2.LIS.getLisSpecimenReport).getLisSpecimenReport("1")
ClassMethod getLisSpecimenReport(RPVisitNumberReportDr As %String) As %GlobalCharacterStream
{
	set main=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.Data).%New()
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisSpecimenReport).%New()	
	try{
		set subObj=..getLisSpecimenReportinfo(RPVisitNumberReportDr)
		d main.LisSpecimenReportList.Insert(subObj)
	}catch{
	}
	set outputStream=##class(%GlobalCharacterStream).%New()
	set JsonString=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.JSONUtil).ObjToJson(main,"")
	d outputStream.Write(JsonString)
	q outputStream
}

ClassMethod getLisSpecimenReportinfo(RPVisitNumberReportDr) As web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisSpecimenReport
{
	set businessfieldcode="00001"
	set RPReportData=$g(^dbo.RPVisitNumberReportD(RPVisitNumberReportDr))
	set VisitNumberDR=$lg(RPReportData,2)
	set RPVisitNumberData=$g(^dbo.RPVisitNumberD(VisitNumberDR))
	set LabNo=$lg(RPVisitNumberData,2)
	set admNo=$lg(RPVisitNumberData,5)
	if admNo'="" set patRowId=$p($g(^PAADM(admNo)),"^",1)
	else  set patRowId=""
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisSpecimenReport).%New()
	set subObj.businessfieldcode=businessfieldcode
	set subObj.lissrhoslisreportid=RPVisitNumberReportDr
	set subObj.lissrrellisreportid=businessfieldcode_"_"_RPVisitNumberReportDr
	set subObj.oeorsrelspecimenid=businessfieldcode_"_"_LabNo
	set subObj.paadmrelvisitnumber=businessfieldcode_"_"_admNo
	set subObj.papatrelpatientid=businessfieldcode_"_"_patRowId
	set subObj.updatedate=$zd(+$h,3)      //时间戳
	set subObj.updatetime=$zt($p($h,",",2))   //时间戳
	quit subObj
}

/// other: w ##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Methond.getLisSpecimenReport).getLisSpecimenReportGlobal("1","6843309")
ClassMethod getLisSpecimenReportGlobal(strRowId As %String, endRowId As %String) As %String
{
	set $zt="Exception"
	if (strRowId="")||(endRowId="") {
		quit "-1^id不能为空"
	}
	set ^ExportHistoryData("lisspecimenreport")=$lb("标本报告id","时间戳","时间戳","全局样本号","全局患者id","全局就诊id")
	set RPVisitNumberReportDr="",con=0,strtime=$zt($p($now(),",",2))
	for RPVisitNumberReportDr=strRowId:1:endRowId
	{
		continue:$d(^dbo.RPVisitNumberReportD(RPVisitNumberReportDr))=0
		set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisSpecimenReport).%New()
		set subObj=..getLisSpecimenReportinfo(RPVisitNumberReportDr)
		set ^ExportHistoryData("lisspecimenreport",RPVisitNumberReportDr)=$lb(RPVisitNumberReportDr,subObj.updatedate,subObj.updatetime,subObj.oeorsrelspecimenid,subObj.papatrelpatientid,
																			subObj.paadmrelvisitnumber,subObj.businessfieldcode,subObj.lissrrellisreportid)
		set con=con+1
		set no=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.StringUtil).point(strRowId, endRowId, con, RPVisitNumberReportDr)
		}			
	quit "Finish   count:"_con
Exception
	quit "-1^"_$ze
}

}
