Class web.DHCENS.STBLL.DRUG.METHOD.PrescriptionInfor Extends (%RegisteredObject, %XML.Adaptor)
{

/// w ##class(web.DHCENS.STBLL.DRUG.METHOD.PrescriptionInfor).Test()
ClassMethod Test() As %String
{
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("<Request><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body><PrescriptionInforRt><PATPatientID></PATPatientID><PAADMVisitNumber></PAADMVisitNumber><OEORIInfoList><OEORIInfo><OEORIOrderItemID>11||1</OEORIOrderItemID><OrderExecuteID>11||1||2</OrderExecuteID><Status>1</Status><DeptCode>100101B</DeptCode></OEORIInfo></OEORIInfoList><UpdateUserCode>demo</UpdateUserCode><UpdateDate></UpdateDate><UpdateTime></UpdateTime></PrescriptionInforRt></Body></Request>")
	set sc=..SavePrescriptionInfor(stream)
	Quit sc.Read()
}

/// Creator：lipan
/// CreatDate：2016—08-01
/// Description：接受退药信息
/// Table：
/// Input：
/// Return：
/// Others: 
ClassMethod SavePrescriptionInfor(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $zt="Exception"
	set tSC=0,RtSC=0
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(Input,.tDocument)
	
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
		set ^TMPDHCENS("SavePrescriptionInfor",$zd(+$h,3),$zt($p($h,",",2)))=Input.Read()
		d Input.Rewind()
		set (UpdateUserCode,OrderIDs,ROrderIDs,DeptCode)=""
		set tSC=tDocument.EvaluateExpression("/Request/Body/PrescriptionInforRt/UpdateUserCode","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
			set fieldValue=tRes.GetAt(1).Value
			set UpdateUserCode=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/PrescriptionInforRt/OEORIInfoList","count(OEORIInfo)",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			set hsCount=tRes.GetAt(1).Value
			Quit:hsCount="0" "-1^信息为空"
			for i=1:1:hsCount {
				set (OrderExecuteID,Status)=""
				set tSC=tDocument.EvaluateExpression("/Request/Body/PrescriptionInforRt/OEORIInfoList/OEORIInfo["_i_"]/OrderExecuteID","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set OrderExecuteID=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/PrescriptionInforRt/OEORIInfoList/OEORIInfo["_i_"]/Status","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set Status=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/PrescriptionInforRt/OEORIInfoList/OEORIInfo["_i_"]/DeptCode","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set DeptCode=$tr(fieldValue,$c(0),"")
				}
				/// 发药
				if Status="1" {			
					if OrderIDs'="" {								
						set OrderIDs=OrderIDs_"^"_OrderExecuteID
					}
					else {
						set OrderIDs=OrderExecuteID
					}
				}
				/// 退药	
				if Status="0" {				
					if ROrderIDs'="" {
						set ROrderIDs=ROrderIDs_"^"_OrderExecuteID
					}
					else {
						set ROrderIDs=OrderExecuteID
					}	
				}
			}
			set DeptDr=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(DeptCode),""))
			set UserDr=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(UpdateUserCode),""))
			if ((DeptDr'="")&&(UserDr'="")) {
				if OrderIDs'="" {	
					/// 发药		
					set tSC=##class(web.DHCSTPCHCOLLS).InsPhaCollByOEORE(OrderIDs, DeptDr, UserDr)	
				}
				if ROrderIDs="0" {
					/// 退药			
					set RtSC=##class(web.DHCSTPHARETURN).InsPhaReturn(ROrderIDs, DeptDr, UserDr)	
				}
			}
			else {
				set responseBody.ResultCode="1"
				set responseBody.ResultContent="科有误室或人员代码信息"
			}
		}
		if ((tSC="0")&&(RtSC=0)) {
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
