Class web.DHCENS.STBLL.CDRJSONV2.LIS.Methond.getLisSenItemResult Extends (%RegisteredObject, %XML.Adaptor)
{

/// createdate:2020年12月29日
/// creator:zhibao
/// desc: 获取检验微生物明细结果
/// other:w ##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Methond.getLisSenItemResult).getLisSenItemResult("").Read()
ClassMethod getLisSenItemResult(lisSenResultRowid As %String) As %GlobalCharacterStream
{
	set main=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.Data).%New()
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisSenItemResult).%New()	
	try{
		S lisSenResultRowid=$replace(lisSenResultRowid,$c(34),"")

		set subObj=..getLisSenItemResultinfo(lisSenResultRowid)
		d main.LisSenItemResultList.Insert(subObj)
	}
	catch{	
	}
	set outputStream=##class(%GlobalCharacterStream).%New()
	set JsonString=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.JSONUtil).ObjToJson(main,"")
	d outputStream.Write(JsonString)
	q outputStream
}

ClassMethod getLisSenItemResultinfo(ReportResSenDr) As web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisSenItemResult
{
	set ReportResSenData=$g(^dbo.RPVisitNumberReportResSenD(ReportResSenDr))
	set ReportResultDR=$lg(ReportResSenData,2)
	set ReportResultData=$g(^dbo.RPVisitNumberReportResultD(ReportResultDR))
	set reportid=$lg(ReportResultData,2)
	set admNo=$lg(ReportResultData,23)
	set:admNo'="" PatientId=$p($g(^PAADM(admNo)),"^",1)   	///患者rowid
	set:admNo="" PatientId=""
	set AntibioticsDR=$lg(ReportResSenData,3)
	set AntibioticsCode="",AntibioticsDesc="",AntibioticsECode="",AntibioticsClassCode="",AntibioticsClassDesc=""
	if (AntibioticsDR'=""){
		set AntibioticsCode=AntibioticsDR
		set AntibioticsDesc=$lg(^dbo.BTAntibioticsD(AntibioticsDR),3)
		set AntibioticsECode=$lg(^dbo.BTAntibioticsD(AntibioticsDR),4)
		set AntibioticsClassDR=$lg(^dbo.BTAntibioticsD(AntibioticsDR),19)
		if (AntibioticsClassDR'=""){
			set AntibioticsClassCode=AntibioticsClassDR
			set AntibioticsClassDesc=$lg(^dbo.BTAntibioticsClassD(AntibioticsClassDR),3)
		}
	} 
	set SenMethod=$lg(ReportResSenData,4)
	set IRanges=$lg(ReportResSenData,7)
	set RRanges=$lg(ReportResSenData,9)
	set SRanges=$lg(ReportResSenData,8)
	set SenValue=$lg(ReportResSenData,5)
	set MachSensitivityDR=$lg(ReportResSenData,16)
	set MachSensitivityCode="",MachSensitivityDesc=""
	if (MachSensitivityDR'=""){
		set MachSensitivityCode=""
		set MachSensitivityDesc=""	
	}
	set Sequence=$lg(ReportResSenData,10)
	

	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisSenItemResult).%New()
	set businessfieldcode=subObj.businessfieldcode
	set subObj.lisisrantibioticsclassdesc=AntibioticsClassCode
	set subObj.lisisrantibioticsclassid=AntibioticsClassDesc
	set subObj.lisisrantibioticscode=AntibioticsCode
	set subObj.lisisrantibioticsdesc=AntibioticsDesc
	set subObj.lisisrflag="Y"
	set subObj.lisisrhosresultid=ReportResSenDr
	set subObj.lisisriranges=IRanges
	set subObj.lisisrmethod=SenMethod
	set subObj.lisisrrelresultid=businessfieldcode_"_"_ReportResSenDr
	set subObj.lisirrelitemid=businessfieldcode_"_"_ReportResSenDr
	set subObj.lisisrresult=SenValue
	set subObj.lisisrrranges=RRanges
	set subObj.lisisrsensitivitycode=""
	set subObj.lisisrsensitivitydesc=""
	set subObj.lisisrshowseq=Sequence
	set subObj.lisisrsranges=SRanges
	set subObj.lisisrsuggestion=""
	set subObj.lissrrellisreportid=businessfieldcode_"_"_reportid
	set subObj.paadmrelvisitnumber=businessfieldcode_"_"_admNo
	set subObj.papatrelpatientid=businessfieldcode_"_"_PatientId
	set subObj.updatedate=$zd(+$h,3)
	set subObj.updatetime=$zt($p($h," ",2))
	quit subObj
}

/// createdate:2020年12月29日
/// creator:zhibao
/// desc: 获取检验微生物明细结果历史数据Global
/// other:w ##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Methond.getLisSenItemResult).getLisSenItemResultGlobal("1","515578")
ClassMethod getLisSenItemResultGlobal(strRowId As %String, endRowId As %String) As %String
{
	set $zt="Exception"
	set ^ExportHistoryData("lisitemsenresult")=$lb("院内药敏结果id","抗生素代码","抗生素描述","药敏数值结果","药敏结果代码","药敏结果描述","i折点范围","s折点范围","r折点范围","显示序号","试验方法","建议","药敏结果标志","抗生素级别id","抗生素级别名称","时间戳","时间戳","全局患者id","全局就诊id","全局检验报告号","全局检验结果id")
	if (strRowId="")||(endRowId="") {
		quit "-1^id不能为空"
	}
	set ReportResSenDr="",con=0
	for ReportResSenDr=strRowId:1:endRowId{
		continue:$d(^dbo.RPVisitNumberReportResSenD(ReportResSenDr))=0
		set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisSenItemResult).%New()
		set subObj=..getLisSenItemResultinfo(ReportResSenDr)
		set ^ExportHistoryData("lisitemsenresult",ReportResSenDr)=$lb(subObj.lisisrhosresultid,subObj.lisisrantibioticscode,subObj.lisisrantibioticsdesc,subObj.lisisrresult,subObj.lisisrsensitivitycode,
																subObj.lisisrsensitivitydesc,subObj.lisisriranges,subObj.lisisrsranges,subObj.lisisrrranges,subObj.lisisrshowseq,
																subObj.lisisrmethod,subObj.lisisrsuggestion,subObj.lisisrflag,subObj.lisisrantibioticsclassid,subObj.lisisrantibioticsclassdesc,
																subObj.updatedate,subObj.updatetime,subObj.papatrelpatientid,subObj.paadmrelvisitnumber,subObj.lissrrellisreportid,
																subObj.lisirrelitemid,subObj.businessfieldcode,subObj.lisisrrelresultid)
		set con=con+1
		set no=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.StringUtil).point(strRowId, endRowId, con, ReportResSenDr)
		}			
	quit "Finish   count:"_con
Exception
	quit "-1^"_$ze
}

}
