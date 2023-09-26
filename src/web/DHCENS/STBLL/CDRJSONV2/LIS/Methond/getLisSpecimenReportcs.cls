Class web.DHCENS.STBLL.CDRJSONV2.LIS.Methond.getLisSpecimenReportcs Extends (%RegisteredObject, %XML.Adaptor)
{

/// desc: 根据检验报告表得获取条码和报告得关联关系
/// other: w ##class(web.DHCENS.STBLL.CDRJSONV2.LIS.getLisSpecimenReport).getLisSpecimenReportCS("23081817||C708||1").Read()
ClassMethod getLisSpecimenReportCS(RPVisitNumberReportDr As %String) As %GlobalCharacterStream
{
	set main=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.Data).%New()
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisSpecimenReport).%New()	
	try{
		set subObj=..getLisSpecimenReportinfoCS(RPVisitNumberReportDr)
		d main.LisSpecimenReportList.Insert(subObj)
	}catch{
	}
	set outputStream=##class(%GlobalCharacterStream).%New()
	set JsonString=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.JSONUtil).ObjToJson(main,"")
	d outputStream.Write(JsonString)
	q outputStream
}

/// creator:zhibao
/// creatdate:2021年1月18日
/// desc: 根据检验报告表得获取条码和报告得关联关系
/// other: w ##class(web.DHCENS.STBLL.CDRJSONV2.LIS.getLisSpecimenReport).getLisSpecimenReport("1")
ClassMethod getLisSpecimenReportinfoCS(RPVisitNumberReportDr) As web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisSpecimenReport
{
	
	set LabNo=+RPVisitNumberReportDr
	set ord=$o(^OEORD(0,"EpisNo",LabNo,""))
	set admNo=$p($g(^OEORD(ord)),"^",1)
	if admNo'="" set patRowId=$p($g(^PAADM(admNo)),"^",1)
	else  set patRowId=""
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisSpecimenReport).%New()
	set businessfieldcode=subObj.businessfieldcode
	set subObj.businessfieldcode=businessfieldcode
	set subObj.lissrhoslisreportid=RPVisitNumberReportDr
	set subObj.lissrrellisreportid=businessfieldcode_"_"_RPVisitNumberReportDr
	set subObj.oeorsrelspecimenid=businessfieldcode_"_"_LabNo
	set subObj.paadmrelvisitnumber=businessfieldcode_"_"_admNo
	set subObj.papatrelpatientid=businessfieldcode_"_"_patRowId
	quit subObj
}

/// creator:zhibao
/// creatdate:2021年1月18日
/// desc: 根据检验报告表得获取条码和报告得关联关系历史数据
/// w ##class(web.DHCENS.STBLL.CDRJSONV2.LIS.getLisSpecimenReport).getLisSpecimenReporthistoryCS("2011-02-11","2019-12-01")
ClassMethod getLisSpecimenReporthistory(startDate As %String, endDate As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	set ReportResultDr="",con=0,strtime=$zt($p($now(),",",2))
	set:startDate'="" startDate=$zdh(startDate,3)
	set:endDate'="" endDate=$zdh(endDate,3)
	s LabNo="",labRelatId="",flag=0 
	for{  
		set LabNo=$O(^OEORD(0,"EpisNo",LabNo)) 
	    q:LabNo=""
		set OEORDRowId=""
		for{
			set OEORDRowId=$O(^OEORD(0,"EpisNo",LabNo,OEORDRowId))
			q:OEORDRowId=""
			set OEORIChildsub=""
			for	{
				set OEORIChildsub=$O(^OEORD(0,"EpisNo",LabNo,OEORDRowId,OEORIChildsub)) 
				q:OEORIChildsub=""
				set OrdRowId=OEORDRowId_"||"_OEORIChildsub
				// 医嘱日期
				;b  ;OrdRowId
				set veriDate=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",7)
				Quit:((startDate'="")&&(startDate>veriDate))
				set:((endDate'="")&&(veriDate>endDate)) flag=1 
				Quit:((endDate'="")&&(veriDate>endDate))
				// 报告Id
				set labRelatId=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",35)
				continue:labRelatId=""
				s labNo=$p(labRelatId,"||",1)
				s labTSCode=$p(labRelatId,"||",2)
				s labTSId=$p(labRelatId,"||",3)
				set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.LisSpecimenReport).%New()
				set subObj=..getLisSpecimenReportinfoCS(labRelatId)
				set ^ExportHistoryData("lisspecimenreport",labRelatId)=$lb(labRelatId,subObj.updatedate,subObj.updatetime,subObj.oeorsrelspecimenid,subObj.papatrelpatientid,
																			subObj.paadmrelvisitnumber,subObj.businessfieldcode,subObj.lissrrellisreportid)
				set con=con+1
				if con#100=0  w !,con_"   "_labRelatId
			}
			quit:flag=1  
		}
		quit:flag=1  
	}
		quit "Finish   count:"_con
Exception
	quit "-1^"_$ze
}

}
