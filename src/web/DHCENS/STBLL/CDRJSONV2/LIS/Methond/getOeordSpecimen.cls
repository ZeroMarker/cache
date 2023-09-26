Class web.DHCENS.STBLL.CDRJSONV2.LIS.Methond.getOeordSpecimen Extends (%RegisteredObject, %XML.Adaptor)
{

/// createdate:2020年12月29日
/// creator:zhibao
/// desc: 获取医嘱和条码之间的关联关系
/// other:w ##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Methond.getOeordSpecimen).getOeordSpecimen("6774578")
ClassMethod getOeordSpecimen(RPVisitNumberDr As %String) As %GlobalCharacterStream
{
	set main=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.Data).%New()
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.OeordSpecimen).%New()	
	try{
		set tSC=..getOeordSpecimeninfo(RPVisitNumberDr,.main)	
	}catch{
		b ;!
	}
	set outputStream=##class(%GlobalCharacterStream).%New()
	set JsonString=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.JSONUtil).ObjToJson(main,"")
	d outputStream.Write(JsonString)
	q outputStream
}

ClassMethod getOeordSpecimeninfo(RPVisitNumberDr As %String, Output data As web.DHCENS.STBLL.CDRJSONV2.LIS.Model.Data) As %Status
{
	set data=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.Data).%New()
	set RPVisitNumberData=$g(^dbo.RPVisitNumberD(RPVisitNumberDr))
	set LabNo=$lg(RPVisitNumberData,2)
	set labSpecCode="",labSpecName=""
	s SpecimenDR=$lg(RPVisitNumberData,56)								//SpecimenDR->dbo.BT_Specimen
    i $l(SpecimenDR){
	    s labSpecCode=$lg($g(^dbo.BTSpecimenD(SpecimenDR)),2)
	    s labSpecName=$lg($g(^dbo.BTSpecimenD(SpecimenDR)),3)
    }else{
	    s labSpecCode="",labSpecName=""
    }
    set ord=$o(^OEORD(0,"EpisNo",LabNo,""))
    set sub=""
    for {
		set sub=$o(^OEORD(0,"EpisNo",LabNo,ord,sub))
		quit:sub=""
		set ordItemID=ord_"||"_sub
		set updatedate=$p(^OEORD(ord,"I",sub,11),"^",4)
		if updatedate'="" set updatedate=$zd(updatedate,3)
		set updatetime=$p(^OEORD(ord,"I",sub,11),"^",5)
		if updatetime'="" set updatetime=$zt(updatetime)
		set userUpdateDr=$p(^OEORD(ord,"I",sub,8),"^",12)
		set userUpdateCode=""
		if (userUpdateDr'="")&&(userUpdateDr'="4265"){
			set userUpdateCode=	$p(^SSU("SSUSR",userUpdateDr),"^",1)
		}
		set admNo=$p($g(^OEORD(ord)),"^",1)
		set patRowId=$p($g(^PAADM(admNo)),"^",1)
		set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.OeordSpecimen).%New()
		set businessfieldcode=subObj.businessfieldcode
		set subObj.oeorirelorderitemid=businessfieldcode_"_"_ordItemID
		set subObj.oeorshosspecimenid=LabNo
		set subObj.oeorsrelspecimenid=businessfieldcode_"_"_LabNo
		set subObj.oeorsspecimencode=labSpecCode
		set subObj.oeorsupdatedate=updatedate
		set subObj.oeorsupdatetime=updatetime
		set subObj.oeorsupdateusercode=userUpdateCode
		set subObj.paadmrelvisitnumber=businessfieldcode_"_"_admNo
		set subObj.papatrelpatientid=businessfieldcode_"_"_patRowId
		set subObj.updatedate=$zd(+$h,3)      //时间戳
		set subObj.updatetime=$zt($p($h,",",2))   //时间戳
		d data.OeordSpecimenList.Insert(subObj)
		}
		quit 1
}

/// 
/// 获取医嘱和条码之间的关联关系历史数据 global
/// other:w ##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Methond.getOeordSpecimen).getOeordSpecimenGlobal("1","6793475")
ClassMethod getOeordSpecimenGlobal(strRowId As %String, endRowId As %String) As %String
{
	set $zt="Exception"
	set ^ExportHistoryData("oeordspecimen")=$lb("标本id","样本代码","时间戳","时间戳","最后更新日期","最后更新时间","最后更新人编码","医院内部样本号","全局医嘱明细id","全局患者id","全局就诊号","全局样本号")
	set sum=endRowId-strRowId+1
	if (strRowId="")||(endRowId="") {
		quit "-1^id不能为空"
	}
	set RPVisitNumberDr="",con=0,strtime=$zt($p($now(),",",2))
	for RPVisitNumberDr=strRowId:1:endRowId{
		continue:$d(^dbo.RPVisitNumberD(RPVisitNumberDr))=0
		set RPVisitNumberData=$g(^dbo.RPVisitNumberD(RPVisitNumberDr))
		set LabNo=$lg(RPVisitNumberData,2)
	    set ord=$o(^OEORD(0,"EpisNo",LabNo,""))
	    i ord'=""
	    {
		    set sub=""
		    for {
				set sub=$o(^OEORD(0,"EpisNo",LabNo,ord,sub))
				quit:sub=""
				set ordItemID=ord_"||"_sub
				set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.OeordSpecimen).%New()
				set subObj=..getOeordSpecimeninfoglobal(RPVisitNumberDr,ordItemID)
				set ^ExportHistoryData("oeordspecimen",ordItemID)=$lb(ordItemID,subObj.oeorsspecimencode,subObj.updatedate,subObj.updatetime,
																	  subObj.oeorsupdatedate,subObj.oeorsupdatetime,subObj.oeorsupdateusercode,
																	  subObj.oeorshosspecimenid,subObj.oeorirelorderitemid,subObj.papatrelpatientid,
																	  subObj.paadmrelvisitnumber,subObj.oeorsrelspecimenid,subObj.businessfieldcode)
				set con=con+1
				set no=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.StringUtil).point(strRowId, endRowId, con, RPVisitNumberDr)		

	    	}
	    }
	}
	quit "Finish   count:"_con
Exception
	quit "error"="-1^"_$ze
}

ClassMethod getOeordSpecimeninfoglobal(RPVisitNumberDr As %String, ordItemID As %String)
{
	set RPVisitNumberData=$g(^dbo.RPVisitNumberD(RPVisitNumberDr))
	set LabNo=$lg(RPVisitNumberData,2)
	set labSpecCode="",labSpecName=""
	s SpecimenDR=$lg(RPVisitNumberData,56)							
    i $l(SpecimenDR){
	    s labSpecCode=$lg($g(^dbo.BTSpecimenD(SpecimenDR)),2)
	    s labSpecName=$lg($g(^dbo.BTSpecimenD(SpecimenDR)),3)
    }else{
	    s labSpecCode="",labSpecName=""
    }
		set ord=+ordItemID
		set sub=$p(ordItemID,"||",2)
		set updatedate=$p(^OEORD(ord,"I",sub,11),"^",4)
		if updatedate'="" set updatedate=$zd(updatedate,3)
		set updatetime=$p(^OEORD(ord,"I",sub,11),"^",5)
		if updatetime'="" set updatetime=$zt(updatetime)
		set userUpdateDr=$p(^OEORD(ord,"I",sub,8),"^",12)
		set userUpdateCode=""
		if (userUpdateDr'="")&&(userUpdateDr'="4265"){
			set userUpdateCode=	$p(^SSU("SSUSR",userUpdateDr),"^",1)
		}
		set admNo=$p($g(^OEORD(ord)),"^",1)
		set patRowId=$p($g(^PAADM(admNo)),"^",1)
		set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.LIS.Model.OeordSpecimen).%New()
		set businessfieldcode=subObj.businessfieldcode
		set subObj.businessfieldcode=businessfieldcode
		set subObj.oeorirelorderitemid=businessfieldcode_"_"_ordItemID
		set subObj.oeorshosspecimenid=LabNo
		set subObj.oeorsrelspecimenid=businessfieldcode_"_"_LabNo
		set subObj.oeorsspecimencode=labSpecCode
		set subObj.oeorsupdatedate=updatedate
		set subObj.oeorsupdatetime=updatetime
		set subObj.oeorsupdateusercode=userUpdateCode
		set subObj.paadmrelvisitnumber=businessfieldcode_"_"_admNo
		set subObj.papatrelpatientid=businessfieldcode_"_"_patRowId
		set subObj.updatedate=$zd(+$h,3)      //时间戳
		set subObj.updatetime=$zt($p($h,",",2))   //时间戳
		quit subObj
}

}
