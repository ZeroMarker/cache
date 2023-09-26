Class web.DHCENS.STBLL.CDRJSONV2.LIS.Methond.getLisSpecimenReportEns Extends (%RegisteredObject, %XML.Adaptor)
{

/// creator:zhibao
/// creatdate:2021年1月18日
/// desc: 根据检验报告表得获取条码和报告得关联关系
/// other: w ##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Methond.getLisSpecimenReportEns).getLisSpecimenReport("1")
ClassMethod getLisSpecimenReport(RPVisitNumberReportDr As %String) As %GlobalCharacterStream
{
	try{
		set main=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.Data).%New()
		set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisSpecimenReport).%New()
		set subObj=..getLisSpecimenReportinfoEns(RPVisitNumberReportDr)
		b ;01
		d main.LisSpecimenReportList.Insert(subObj)
		b ;02
	}catch{
		set main=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.Data).%New()
		set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisSpecimenReport).%New()
		d main.LisSpecimenReportList.Insert(subObj)
	}
	set outputStream=##class(%GlobalCharacterStream).%New()
	set JsonString=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.JSONUtil).ObjToJson(main,"")
	d outputStream.Write(JsonString)
	q outputStream
}

// 从ens标本报告关联表获取数据

ClassMethod getLisSpecimenReportinfoEns(id) As web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisSpecimenReport
{

	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisSpecimenReport).%New()
	set businessfieldcode=subObj.businessfieldcode
	set subObj.businessfieldcode=businessfieldcode
	set subObj.lissrrellisreportid=businessfieldcode_"_"_$lg(^Busi.ENS.EnsLISSpecimenReportD(id),2) //全局检验报告号
	;b ;w subObj.lissrrellisreportid
	set subObj.oeorsrelspecimenid=businessfieldcode_"_"_$lg(^Busi.ENS.EnsLISSpecimenReportD(id),3) //全局样本号
	set subObj.papatrelpatientid=businessfieldcode_"_"_$lg(^Busi.ENS.EnsLISSpecimenReportD(id),5) //全局患者id
	set subObj.paadmrelvisitnumber=businessfieldcode_"_"_$lg(^Busi.ENS.EnsLISSpecimenReportD(id),6) //全局就诊id
	set subObj.updatedate=$zd(+$h,3)      //时间戳
	set subObj.updatetime=$zt($p($h,",",2))   //时间戳
	quit subObj
}

/// other: w ##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Methond.getLisSpecimenReportEns).getLisSpecimenReporthistoryGlobal("1","197270")
ClassMethod getLisSpecimenReporthistoryGlobal(strRowId As %String, endRowId As %String) As %String
{
	set $zt="Exception"
	if (strRowId="")||(endRowId="") {
		quit "-1^id不能为空"
	}
	set ^ExportHistoryData("lisspecimenreport")=$lb("标本报告id","时间戳","时间戳","全局样本号","全局患者id","全局就诊id")
	set RPVisitNumberReportDr="",con=0,strtime=$zt($p($now(),",",2))
	for RPVisitNumberReportDr=strRowId:1:endRowId
	{
		continue:$d(^Busi.ENS.EnsLISSpecimenReportD(RPVisitNumberReportDr))=0
		set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisSpecimenReport).%New()
		set subObj=..getLisSpecimenReportinfoEns(RPVisitNumberReportDr)
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
