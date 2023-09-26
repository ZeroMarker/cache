Class web.DHCENS.STBLL.CDRJSONV2.LIS.Methond.getLisSenItemResultEns Extends (%RegisteredObject, %XML.Adaptor)
{

/// createdate:2020年12月29日
/// creator:zhibao
/// desc: 获取检验微生物明细结果
/// other:w ##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Methond.getLisSenItemResultEns).getLisSenItemResult("1").Read()
ClassMethod getLisSenItemResult(lisSenResultRowid As %String) As %GlobalCharacterStream
{
	S lisSenResultRowid=$replace(lisSenResultRowid,$c(34),"")
	set main=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.Data).%New()
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisSenItemResult).%New()	
	try{
		set subObj=..getLisSenItemResultinfoEns(lisSenResultRowid)
		d main.LisSenItemResultList.Insert(subObj)
	}
	catch{	
	}
	set outputStream=##class(%GlobalCharacterStream).%New()
	set JsonString=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.JSONUtil).ObjToJson(main,"")
	d outputStream.Write(JsonString)
	q outputStream
}

/// 取ENS.EnsLISItemSenResult表数据
/// w ##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Methond.getLisSenItemResultEns).getLisSenItemResultinfoEns("17844")
ClassMethod getLisSenItemResultinfoEns(id) As web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisSenItemResult
{
	
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisSenItemResult).%New()
	set businessfieldcode=subObj.businessfieldcode
	set subObj.lisisrhosresultid	=	$lg($g(^Busi.ENS.EnsLISItemSenResultD(id)),2) ///	院内药敏结果id
	set subObj.lisisrantibioticscode	=	$lg($g(^Busi.ENS.EnsLISItemSenResultD(id)),3) ///	抗生素代码
	set subObj.lisisrantibioticsdesc	=	$lg($g(^Busi.ENS.EnsLISItemSenResultD(id)),4) ///	抗生素描述
	set subObj.lisisrresult	=	$lg($g(^Busi.ENS.EnsLISItemSenResultD(id)),5) ///	药敏数值结果
	set subObj.lisisrsensitivitycode	=	$lg($g(^Busi.ENS.EnsLISItemSenResultD(id)),6) ///	药敏结果代码
	set subObj.lisisrsensitivitydesc	=	$lg($g(^Busi.ENS.EnsLISItemSenResultD(id)),7) ///	药敏结果描述
	set subObj.lisisriranges	=	$lg($g(^Busi.ENS.EnsLISItemSenResultD(id)),8) ///	i折点范围
	set subObj.lisisrsranges	=	$lg($g(^Busi.ENS.EnsLISItemSenResultD(id)),9) ///	s折点范围
	set subObj.lisisrrranges	=	$lg($g(^Busi.ENS.EnsLISItemSenResultD(id)),10) ///	r折点范围
	set subObj.lisisrshowseq	=	$lg($g(^Busi.ENS.EnsLISItemSenResultD(id)),11) ///	显示序号
	set subObj.lisisrmethod	=	$lg($g(^Busi.ENS.EnsLISItemSenResultD(id)),12) ///	试验方法
	set subObj.lisisrsuggestion	=	$lg($g(^Busi.ENS.EnsLISItemSenResultD(id)),13) ///	建议
	set subObj.lisisrflag	=	$lg($g(^Busi.ENS.EnsLISItemSenResultD(id)),14) ///	药敏结果标志
	set subObj.lisisrantibioticsclassid	=	$lg($g(^Busi.ENS.EnsLISItemSenResultD(id)),15) ///	抗生素级别id
	set subObj.lisisrantibioticsclassdesc	=	$lg($g(^Busi.ENS.EnsLISItemSenResultD(id)),16) ///	抗生素级别名称

	set subObj.updatedate=$zd(+$h,3)
	set subObj.updatetime=$zt($p($h," ",2))
	
	s subObj.lissrrellisreportid=businessfieldcode_"_"_$lg($g(^Busi.ENS.EnsLISItemResultD(id)),3)  //报告ID

	s subObj.papatrelpatientid=businessfieldcode_"_"_$lg($g(^Busi.ENS.EnsLISItemResultD(id)),4)  //患者ID

	s subObj.paadmrelvisitnumber=businessfieldcode_"_"_$lg($g(^Busi.ENS.EnsLISItemResultD(id)),5)  //就诊号

	s subObj.lisirrelitemid=businessfieldcode_"_"_$lg($g(^Busi.ENS.EnsLISItemSenResultD(id)),2)  //全局检验结果id
	s subObj.lisisrrelresultid=businessfieldcode_"_"_$lg($g(^Busi.ENS.EnsLISItemSenResultD(id)),2)  //全局药敏结果id

	quit subObj
}

/// createdate:2020年12月29日
/// creator:zhibao
/// desc: 获取检验微生物明细结果历史数据Global
/// other:w ##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Methond.getLisSenItemResultEns).getLisSenItemResultGlobal("1","14485")
ClassMethod getLisSenItemResultGlobal(strRowId As %String, endRowId As %String) As %String
{
	set $zt="Exception"
	set ^ExportHistoryData("lisitemsenresult")=$lb("院内药敏结果id","抗生素代码","抗生素描述","药敏数值结果","药敏结果代码","药敏结果描述","i折点范围","s折点范围","r折点范围","显示序号","试验方法","建议","药敏结果标志","抗生素级别id","抗生素级别名称","时间戳","时间戳","全局患者id","全局就诊id","全局检验报告号","全局检验结果id")
	if (strRowId="")||(endRowId="") {
		quit "-1^id不能为空"
	}
	set ReportResSenDr="",con=0,strtime=$zt($p($now(),",",2))
	for ReportResSenDr=strRowId:1:endRowId
	{
		continue:$d(^Busi.ENS.EnsLISItemSenResultD(ReportResSenDr))=0
		;b ;01
		set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisSenItemResult).%New()
		set subObj=..getLisSenItemResultinfoEns(ReportResSenDr)
		set ^ExportHistoryData("lisitemsenresult",ReportResSenDr)=$lb(subObj.lisisrhosresultid,subObj.lisisrantibioticscode,subObj.lisisrantibioticsdesc,subObj.lisisrresult,subObj.lisisrsensitivitycode,
																subObj.lisisrsensitivitydesc,subObj.lisisriranges,subObj.lisisrsranges,subObj.lisisrrranges,subObj.lisisrshowseq,
																subObj.lisisrmethod,subObj.lisisrsuggestion,subObj.lisisrflag,subObj.lisisrantibioticsclassid,subObj.lisisrantibioticsclassdesc,
																subObj.updatedate,subObj.updatetime,subObj.papatrelpatientid,subObj.paadmrelvisitnumber,subObj.lissrrellisreportid,
																subObj.lisirrelitemid,subObj.businessfieldcode,subObj.lisisrrelresultid)
		;b ;03
		set con=con+1
		set no=##class(web.DHCENS.STBLL.CDRJSONV2.common.common).point(strRowId, endRowId, con, ReportResSenDr)
		}			
	quit "Finish   count:"_con
Exception
	quit "-1^"_$ze
}

}
