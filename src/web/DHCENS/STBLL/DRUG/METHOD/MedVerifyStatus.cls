Class web.DHCENS.STBLL.DRUG.METHOD.MedVerifyStatus Extends (%RegisteredObject, %XML.Adaptor)
{

/// w ##class(web.DHCENS.STBLL.DRUG.METHOD.MedVerifyStatus).Test()
ClassMethod Test() As %String
{
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("<Request><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body><MedVerifyStatusRt><PATPatientID></PATPatientID><PAADMVisitNumber></PAADMVisitNumber><OEORIInfoList><OEORIInfo><OEORIOrderItemID>1||1||11</OEORIOrderItemID><VerifyStatus>Y</VerifyStatus><Remak>vvvvvvv</Remak></OEORIInfo></OEORIInfoList><UpdateUserCode>demo</UpdateUserCode><UpdateDate></UpdateDate><UpdateTime></UpdateTime></MedVerifyStatusRt></Body></Request>")
	set sc=..SaveMedVerifyStatus(stream)
	Quit sc.Read()
}

/// Creator：lipan
/// CreatDate：2016—08-01
/// Description：合理用药审核结果
/// Table：
/// Input：
/// Return：
/// Others: 
ClassMethod SaveMedVerifyStatus(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $zt="Exception"
	
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(Input,.tDocument)
	d Input.Rewind()
	set Response=##class(web.DHCENS.STBLL.HIGHMATERIAL.MODEL.Response).%New()
	set header=##class(web.DHCENS.STBLL.HIGHMATERIAL.MODEL.Header).%New()
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.SourceSystem="02"
	set Response.header=header
	set responseBody=##class(web.DHCENS.STBLL.HIGHMATERIAL.MODEL.Respbody).%New()
	if $$$ISERR(tSC) {
		set responseBody.ResultCode="-1"
		set responseBody.ResultContent=tSC
		set Response.Respbody=responseBody
	}else{
		set ^TMPDHCENS("SaveMedVerifyStatus",$zd(+$h,3),$zt($p($h,",",2)))=Input.Read()
		d Input.Rewind()
		set (UpdateUserCode,UserDr)=""
		set tSC=tDocument.EvaluateExpression("/Request/Body/MedVerifyStatusRt/UpdateUserCode","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
			set fieldValue=tRes.GetAt(1).Value
			set UpdateUserCode=$tr(fieldValue,$c(0),"")
		}
		set:UpdateUserCode'="" UserDr=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(UpdateUserCode),""))
		if UserDr="" {
			set tSC="用户信息有误"
		}
		else{		
			set tSC=tDocument.EvaluateExpression("/Request/Body/MedVerifyStatusRt/OEORIInfoList","count(OEORIInfo)",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
				set hsCount=tRes.GetAt(1).Value
				Quit:hsCount="0" "-1^信息为空"
				for i=1:1:hsCount {
					set (OEORIOrderItemID,VerifyStatus,Remak)=""
					set tSC=tDocument.EvaluateExpression("/Request/Body/MedVerifyStatusRt/OEORIInfoList/OEORIInfo["_i_"]/OEORIOrderItemID","text()",.tRes)					
					if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
						set fieldValue=tRes.GetAt(1).Value
						set OEORIOrderItemID=$tr(fieldValue,$c(0),"")
					}
					set tSC=tDocument.EvaluateExpression("/Request/Body/MedVerifyStatusRt/OEORIInfoList/OEORIInfo["_i_"]/VerifyStatus","text()",.tRes)					
					if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
						set fieldValue=tRes.GetAt(1).Value
						set VerifyStatus=$tr(fieldValue,$c(0),"")
					}
					set tSC=tDocument.EvaluateExpression("/Request/Body/MedVerifyStatusRt/OEORIInfoList/OEORIInfo["_i_"]/Remak","text()",.tRes)					
					if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
						set fieldValue=tRes.GetAt(1).Value
						set Remak=$tr(fieldValue,$c(0),"")
					}
					set ReasonDr=""
					// 状态， 用户id，空 ,空,药师审核备注，安全组(可为空), 医嘱id ，"IA"(IA 住院审核，OA 处方审核)
					if VerifyStatus="Y" {
						set VerifyInfo="Y^"_UserDr_"^^^"_Remak_"^^"_$p(OEORIOrderItemID,"||",1,2)_"^IA"
					}
					else {
						set VerifyInfo="N^"_UserDr_"^^^"_Remak_"^^"_$p(OEORIOrderItemID,"||",1,2)_"^IA"
					}
					b ;999
					set tSC=##class(web.DHCSTCNTSIPMONITOR).SaveAuditResult(ReasonDr,VerifyInfo)
				}
			}
		}

		if tSC="0" {
			set responseBody.ResultCode="0"
			set responseBody.ResultContent="成功"
		}
		else {
			set responseBody.ResultCode="-1"
			set responseBody.ResultContent=tSC
		}
		
	}
    set Response.Respbody=responseBody    
    d Response.XMLExportToStream(.stream)
    q stream
    
Exception

    set Response=##class(web.DHCENS.STBLL.HIGHMATERIAL.MODEL.Response).%New()
	set header=##class(web.DHCENS.STBLL.HIGHMATERIAL.MODEL.Header).%New()
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.SourceSystem="02"
	set Response.header=header
	set responseBody=##class(web.DHCENS.STBLL.HIGHMATERIAL.MODEL.Respbody).%New()
	set responseBody.ResultCode="-1"
	set responseBody.ResultContent=$ze
	set Response.Respbody=responseBody
    d Response.XMLExportToStream(.stream)
    q stream
}

}
