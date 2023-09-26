Class web.DHCENS.STBLL.ORDER.METHOD.OrdersBillStatus Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：lyh
/// CreatDate：2016-06-16
/// Description：获取医嘱状态信息
/// Table：
/// Input：医嘱号^医嘱号^医嘱号
/// Return：医嘱状态信息集合
/// Others: 
/// w ##class(web.DHCENS.STBLL.ORDER.METHOD.OrdersBillStatus).GetOrdersState("2934||1^2934||2^@4874")
ClassMethod GetOrdersState(Input As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	set request=##class(web.DHCENS.STBLL.ORDER.MODEL.Request).%New()
	
	set header=##class(web.DHCENS.STBLL.ORDER.MODEL.Header).%New()
	set header.SourceSystem="02"
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set request.header=header
	set Input=$p(Input,"@",1)
	set length=$l(Input,"^")
	set OEOrder=##class(web.DHCENS.STBLL.ORDER.MODEL.OrdersBillStatusList).%New()
	for i=1:1:length{   //目前表里插得是医嘱RowID^医嘱RowID^@发票号
		set rowId=$p(Input,"^",i)
		set OEOrdStatus=##class(web.DHCENS.STBLL.ORDER.MODEL.OrdersBillStatus).%New()
		set OEOrdStatus=..OEOrdBillStatus(rowId)
		d OEOrder.OEORIInfoList.Insert(OEOrdStatus)
	}
	set body=##class(web.DHCENS.STBLL.ORDER.MODEL.Body).%New()
	set admRowId=$p($g(^OEORD(+Input)),"^",1)
	set patRowId=$p($g(^PAADM(admRowId)),"^",1)
	set OEOrder.PAADMVisitNumber=admRowId
	set OEOrder.PATPatientID=$p($g(^PAPER(patRowId,"PAT",1)),"^",1)
	set AdmTypeCode=$p($g(^PAADM(admRowId)),"^",2)
	s OEOrder.PAADMEncounterTypeCode=AdmTypeCode
	set OEOrder.UpdateUserCode="demo"
	set OEOrder.UpdateUserDesc="demo"
	set OEOrder.UpdateDate=$ZD(+$H,3)
	set OEOrder.UpdateTime=$ZT($P($H,",",2))	
	
	set body.UpdateOrdersRt=OEOrder
	set request.body=body
	d request.XMLExportToStream(.stream)
	q stream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator：lyh
/// CreatDate：2016-06-16
/// Description：获取单条医嘱状态信息
/// Table：
/// Input：医嘱号
/// Return：单条医嘱状态信息
/// Others: 
ClassMethod OEOrdBillStatus(ordRowId As %String) As web.DHCENS.STBLL.ORDER.MODEL.OrdersBillStatus
{
	set $zt="Exception"
	set tSC=0
	set ord = $P(ordRowId,"||",1)
	set sub = $P(ordRowId,"||",2)
	set ChildOEOrdItemObj=##class(web.DHCENS.STBLL.ORDER.MODEL.OrdersBillStatus).%New()	
	set ordstr3 = $g(^OEORD(ord,"I",sub,3))
	set ordstr1 = $g(^OEORD(ord,"I",sub,1))
	set ordstr7 = $g(^OEORD(ord,"I",sub,7))
	set arcimId = $P(ordstr1,"^",2)
    set arcSub = $P(arcimId,"||",1)
    set arcVer = $P(arcimId,"||",2)
    
	set ChildOEOrdItemObj.OEORIOrderItemID=ordRowId
	set ChildOEOrdItemObj.OEORIBillStatusCode = $P(ordstr3,"^",5)   
 	set ChildOEOrdItemObj.OEORIBillStatusDesc=$Case(ChildOEOrdItemObj.OEORIBillStatusCode,"P":"已收费",:"未收费")
	set ChildOEOrdItemObj.ReturnReason=""
	
	
	set OrdSubCatRowID = $p($g(^ARCIM(arcSub,arcVer,1)),"^",10)
    if (OrdSubCatRowID '= "")
    {
	    //医嘱子类信息
	    set ChildOEOrdItemObj.OEORIOrdSubCatCode = $p($g(^ARC("IC",OrdSubCatRowID)),"^",1)
	    set ChildOEOrdItemObj.OEORIOrdSubCatDesc = $p($g(^ARC("IC",OrdSubCatRowID)),"^",2)
	    //医嘱大类信息
		set OrdCatRowID = $p($g(^ARC("IC",OrdSubCatRowID)),"^",8)
    	if (OrdCatRowID '= "")
    	{
	    	set ChildOEOrdItemObj.OEORIOrdCatCode = $p($g(^OEC("ORCAT",OrdCatRowID)),"^",1)
	    	set ChildOEOrdItemObj.OEORIOrdCatDesc = $p($g(^OEC("ORCAT",OrdCatRowID)),"^",2)  
    	}
    }
    
    //接收科室信息
    set RecDeptCode=""
    set RecDeptRowID = $P(ordstr3,"^",6)
    set:RecDeptRowID'="" ChildOEOrdItemObj.OEORIAcceptDeptCode = $p($g(^CTLOC(RecDeptRowID)),"^",1)   
	
	set appDeptRowID = $P(ordstr7,"^",2)
	set:appDeptRowID'="" ChildOEOrdItemObj.OEORIAppDeptCode=$p($g(^CTLOC(appDeptRowID)),"^",1)
	Quit ChildOEOrdItemObj
Exception
	set ChildOEOrdItemObj=##class(web.DHCENS.STBLL.ORDER.MODEL.OrdersBillStatus).%New()
	Quit ChildOEOrdItemObj
}

}
