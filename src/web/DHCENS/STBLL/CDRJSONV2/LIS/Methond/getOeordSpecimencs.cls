Class web.DHCENS.STBLL.CDRJSONV2.LIS.Methond.getOeordSpecimencs Extends (%RegisteredObject, %XML.Adaptor)
{

/// 获取医嘱和条码之间的关联关系实时
ClassMethod getOeordSpecimenCS(RPVisitNumberDr As %String) As %GlobalCharacterStream
{
	set main=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.Data).%New()
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.OeordSpecimen).%New()	
	try{
		set tSC=..getOeordSpecimeninfoCS(RPVisitNumberDr,.main)	
	}catch{
	}
	set outputStream=##class(%GlobalCharacterStream).%New()
	set JsonString=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.JSONUtil).ObjToJson(main,"")
	d outputStream.Write(JsonString)
	q outputStream
}

/// 获取医嘱和条码之间的关联关系历史
/// w ##class(web.DHCENS.STBLL.CDRJSONV2.LIS.getOeordSpecimen).getOeordSpecimenhistoryCS("2011-02-11","2019-12-19")
ClassMethod getOeordSpecimenhistoryCS(startDate As %String, endDate As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	set ReportResultDr="",con=0,strtime=$zt($p($now(),",",2))
	set:startDate'="" startDate=$zdh(startDate,3)
	set:endDate'="" endDate=$zdh(endDate,3)
	set LabNo="",labRelatId="",flag=0
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
				set veriDate=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",7)
				Quit:((startDate'="")&&(startDate>veriDate))
				set:((endDate'="")&&(veriDate>endDate)) flag=1 
				Quit:((endDate'="")&&(veriDate>endDate))
				set sc=..getOeordSpecimeninfoCS(LabNo,.data)
				set Size = data.OeordSpecimenList.Count()
				for i=1:1:Size{
					set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.OeordSpecimen).%New()
					set subObj=data.OeordSpecimenList.GetAt(i)
					set ^ExportHistoryData("oeordspecimen",OrdRowId)=$lb(OrdRowId,subObj.oeorsspecimencode,subObj.updatedate,
																		subObj.updatetime,subObj.oeorsupdatedate,subObj.oeorsupdatetime,
																		subObj.oeorsupdateusercode,subObj.oeorshosspecimenid,subObj.oeorirelorderitemid,
																		subObj.papatrelpatientid,subObj.paadmrelvisitnumber,
																		subObj.oeorsrelspecimenid,subObj.businessfieldcode)
					set con=con+1
					set no=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.StringUtil).point(startDate, endDate, con, veriDate)		
				}
			}
		quit:flag=1
		}
	quit:flag=1		
	}
		quit "Finish   count:"_con
Exception
	quit "error"="-1^"_$ze
}

/// w ##class(web.DHCENS.STBLL.CDRJSONV2.LIS.getOeordSpecimen).getOeordSpecimeninfoCS("100001")
ClassMethod getOeordSpecimeninfoCS(RPVisitNumberDr As %String, Output data As web.DHCENS.STBLL.CDRJSONV2.LIS.Model.Data) As %Status
{
	set LabNo=RPVisitNumberDr
	set labSpecCode="",labSpecName=""
    set ord=$o(^OEORD(0,"EpisNo",LabNo,""))
    q:ord=""
    set sub=""
    set data=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.Data).%New()
    for {
		set sub=$o(^OEORD(0,"EpisNo",LabNo,ord,sub))
		quit:sub=""
		set ordItemID=ord_"||"_sub
		set updatedate=$p($g(^OEORD(ord,"I",sub,11)),"^",4)
		if updatedate'="" set updatedate=$zd(updatedate,3)
		set updatetime=$p($g(^OEORD(ord,"I",sub,11)),"^",5)
		if updatetime'="" set updatetime=$zt(updatetime)
		set userUpdateDr=$p(^OEORD(ord,"I",sub,8),"^",12)
		set userUpdateCode=""
		if (userUpdateDr'=""){
			set userUpdateCode=	$p(^SSU("SSUSR",userUpdateDr),"^",1)
		}
		s labSpecCode="",labSpecName=""
		if $d(^OEORD(ord,"I",sub,"SPEC",1))'=0
		{
			set labSpecInfo=$g(^OEORD(ord,"I",sub,"SPEC",1))
			set labSpecCode=$p(labSpecInfo,"^",1)
			set:labSpecCode'="" labSpecName=$p($g(^TTAB("SPEC",labSpecCode)),"\",1)
		}
		set admNo=$p($g(^OEORD(ord)),"^",1)
		set patRowId=$p($g(^PAADM(admNo)),"^",1)
		set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.OeordSpecimen).%New()
		set businessfieldcode=subObj.businessfieldcode
		set subObj.oeorirelorderitemid=businessfieldcode_"_"_ordItemID
		set subObj.oeorshosspecimenid=LabNo
		set subObj.oeorsrelspecimenid=businessfieldcode_"_"_LabNo
		set subObj.oeorsspecimencode=labSpecCode
		q:subObj.oeorsspecimencode="" 
		set subObj.oeorsupdatedate=updatedate
		set subObj.oeorsupdatetime=updatetime
		set subObj.oeorsupdateusercode=userUpdateCode
		q:subObj.oeorsupdateusercode="" 
		set subObj.paadmrelvisitnumber=businessfieldcode_"_"_admNo
		set subObj.papatrelpatientid=businessfieldcode_"_"_patRowId
		d data.OeordSpecimenList.Insert(subObj)
		}
		quit 1
}

}
