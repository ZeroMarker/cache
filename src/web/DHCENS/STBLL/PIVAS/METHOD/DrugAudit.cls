Class web.DHCENS.STBLL.PIVAS.METHOD.DrugAudit Extends (%RegisteredObject, %XML.Adaptor)
{

// 护士领药审核/取消领药审核

// w ##class(web.DHCENS.STBLL.PIVAS.METHOD.DrugAudit).GetDrugAudit("1449||3||1,Y")

ClassMethod GetDrugAudit(Input As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	set Counter=0
	set request=##class(web.DHCENS.STBLL.PIVAS.MODEL.Request).%New()
	set header=##class(web.DHCENS.STBLL.PIVAS.MODEL.Header).%New()
	set header.SourceSystem="02"
	set MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.MessageID=MessageID
	set request.header=header
	set body=##class(web.DHCENS.STBLL.PIVAS.MODEL.Body).%New()
	set OrderExecuteInfoRtObj=##class(web.DHCENS.STBLL.PIVAS.MODEL.OrderExecuteInfoRt).%New()
	set ExeOrdRowidStr=$p(Input,",",1)
	set Flag=$p(Input,",",2)
	set OrderRowid=$p(ExeOrdRowidStr,"||")
	set AdmRowid=$p(^OEORD(OrderRowid),"^",1)
	set AdmDeptRowID=$p($g(^PAADM(AdmRowid)),"^",4)	
	if AdmDeptRowID'=""  {		
		set hopitalId=$p($g(^CTLOC(AdmDeptRowID)),"^",22)
		set:hopitalId'="" OrderExecuteInfoRtObj.HospitalCode=$p($g(^CT("HOSP",hopitalId)),"^",1)
	}
	set OrderExecuteInfoRtObj.PAADMVisitNumber=AdmRowid
	set patRowId=$p($g(^PAADM(AdmRowid)),"^",1)
	set OrderExecuteInfoRtObj.PATPatientID=$p($g(^PAPER(patRowId,"PAT",1)),"^",1)
	set length=$l(ExeOrdRowidStr,"^")
	for i=1:1:length {
		set rowId=$p(ExeOrdRowidStr,"^",i)
		set ordExeItemObj=##class(web.DHCENS.STBLL.PIVAS.MODEL.ordExeItem).%New()
		;s DspRowid=$o(^DHCOEDISQTY(0,"OEORE",rowId,""))
	    ;continue:DspRowid=""
	    ;s DspStatus=$p(^DHCOEDISQTY(DspRowid),"^",7)
	    ;continue:DspStatus'="C"
		set ordExeItemObj=..ExeOrdItem(rowId,Flag)
		d OrderExecuteInfoRtObj.ordExeItems.Insert(ordExeItemObj)
		s Counter=Counter+1
	}
	if Counter=0 {
		s stream=##class(%GlobalCharacterStream).%New()
		d stream.Write("<Request><Header><SourceSystem>HIS</SourceSystem><MessageID>"_MessageID_"</MessageID></Header><Body><OrderExecuteInfoRt><PATPatientID></PATPatientID><PAADMVisitNumber></PAADMVisitNumber><OEORIInfoList><OEORIInfo><OEORIOrderItemID></OEORIOrderItemID><OrderDispDrugQuantity></OrderDispDrugQuantity><OrderDispDrugUnit></OrderDispDrugUnit><OrderExecuteID></OrderExecuteID><OrderExecuteStatus/><OrderRequredExDate></OrderRequredExDate><OrderRequredExTime></OrderRequredExTime><OrderExUserCode></OrderExUserCode><UpdateUserCode></UpdateUserCode><UpdateDate></UpdateDate><UpdateTime></UpdateTime><IsDrugAudit></IsDrugAudit><RecDeptCode></RecDeptCode></OEORIInfo></OEORIInfoList></OrderExecuteInfoRt></Body></Request>")
		q stream
	}
	s body.OrderExecuteInfoRt=OrderExecuteInfoRtObj
	s request.body=body
	d request.XMLExportToStream(.stream)
	q stream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

// w ##class(web.DHCENS.STBLL.PIVAS.METHOD.DrugAudit).ExeOrdItem("131||1||1","Y")

ClassMethod ExeOrdItem(ExeOrdRowid As %String, Flag As %String) As web.DHCENS.STBLL.PIVAS.MODEL.ordExeItem
{
	s $zt="Exception"
	s obj=##class(web.DHCENS.STBLL.PIVAS.MODEL.ordExeItem).%New()
	s OrderRowid=$p(ExeOrdRowid,"||",1)
	s OrderSubid=$p(ExeOrdRowid,"||",2)
	s ChildSubid=$p(ExeOrdRowid,"||",3)
	s ExeOrdInfo=$g(^OEORD(OrderRowid,"I",OrderSubid,"X",ChildSubid))
	s OEORIOrderItemID=$p(ExeOrdRowid,"||",1,2)
	s ExStDate=$p(ExeOrdInfo,"^",1)
	s ExStTime=$p(ExeOrdInfo,"^",2)
	s Dspid=0,flag=-1,DspRowid=""
	f  s Dspid=$o(^DHCOEDISQTY(0,"OEORI",OEORIOrderItemID,Dspid)) q:(Dspid="")||(flag=0)  d
	.s DspStatus=$p(^DHCOEDISQTY(Dspid),"^",7)
	.q:(DspStatus'="TC")
	.s DSPTimeDosing=$p(^DHCOEDISQTY(Dspid),"^",20)
	.s:ExStTime=DSPTimeDosing flag=0,DspRowid=Dspid
	;s obj.OrderDispDrugQuantity=$p(ExeOrdInfo,"^",4)
	;s dosageUnitRowID = $P(^OEORD(OrderRowid,"I",OrderSubid,2),"^",3)
	;s:((dosageUnitRowID'="")&&(dosageUnitRowID'=0)) obj.OrderDispDrugUnit=$p($g(^CT("UOM",dosageUnitRowID)),"^",2)
	;s DspRowid=$o(^DHCOEDISQTY(0,"OEORE",ExeOrdRowid,""))
	i DspRowid="" d
	.s tmpChildSubid="0",tmpChildSubidnum=0,TmptmpChildSubidnum=0
	.f  s tmpChildSubid=$o(^OEORD(OrderRowid,"I",OrderSubid,"X",tmpChildSubid)) q:tmpChildSubid=""  d
	..s tmpChildSubidnum=tmpChildSubidnum+1
	..i tmpChildSubid=ChildSubid s TmptmpChildSubidnum=tmpChildSubidnum
	.s TDspid=0 ,TMPTDspidNUM=0
	.f  s TDspid=$o(^DHCOEDISQTY(0,"OEORI",OEORIOrderItemID,TDspid)) q:(TDspid="")  d
	..S TMPTDspidNUM=TMPTDspidNUM+1
	..s DspStatus=$p(^DHCOEDISQTY(TDspid),"^",7)
	..q:(DspStatus'="TC")
	..i TMPTDspidNUM=TmptmpChildSubidnum  s DspRowid=TDspid
	
	q:DspRowid="" obj
	s obj.OEORIOrderItemID=OEORIOrderItemID
	s obj.OEORIParentOrderID=$p($g(^OEORD(OrderRowid,"I",OrderSubid,11)),"^",39)
	s obj.OrderSeqNo=$p(^DHCOEDISQTY(DspRowid),"^",4)
	s obj.OrderDispDrugQuantity=$p(^DHCOEDISQTY(DspRowid),"^",5)
	s dosageUnitRowID = $p(^DHCOEDISQTY(DspRowid),"^",6)
	s:((dosageUnitRowID'="")&&(dosageUnitRowID'=0)) obj.OrderDispDrugUnit=$p($g(^CT("UOM",dosageUnitRowID)),"^",2)
	s obj.OrderExecuteID=ExeOrdRowid

	s OeExeStatus=$p(ExeOrdInfo,"^",16)
	if OeExeStatus'="" {
		s OrderExecuteStatus=$p(^OEC("STAT",OeExeStatus),"^",1)
		if OrderExecuteStatus="F" {
			s obj.OrderExecuteStatus=1
		}
		else{
			s obj.OrderExecuteStatus=0
		} 
	}
	
	s obj.OrderRequredExDate=$zd($p(ExeOrdInfo,"^",1),3)
	s obj.OrderRequredExTime=$zt($p(ExeOrdInfo,"^",2))
	s docRowID=$p(ExeOrdInfo,"^",15)
	if docRowID'="" {
		set userId=$o(^SSU("SSUSR",0,"CTPCP",docRowID,""))	
		if userId'="" {
			set obj.OrderExUserCode=$p($g(^SSU("SSUSR",userId)),"^",1)
			s obj.UpdateUserCode=obj.OrderExUserCode
		}	
	}
	s obj.UpdateDate=$ZD(+$H,3)
	s obj.UpdateTime=$ZT($P($H,",",2))
	s obj.IsDrugAudit=Flag
	//lyh 20161224 停止执行记录消息增加“接收科室”
	set recDeptRowID = $p($g(^OEORD(OrderRowid,"I",OrderSubid,3)),"^",6)
	set:recDeptRowID'="" obj.RecDeptCode=$p($g(^CTLOC(recDeptRowID)),"^",1)
	q obj
Exception
	s obj=##class(web.DHCENS.STBLL.PIVAS.MODEL.ordExeItem).%New()
	q obj
}

}
