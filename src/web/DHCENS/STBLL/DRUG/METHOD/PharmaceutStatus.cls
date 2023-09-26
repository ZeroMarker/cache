Class web.DHCENS.STBLL.DRUG.METHOD.PharmaceutStatus Extends (%RegisteredObject, %XML.Adaptor)
{

/// Description: HIS系统门诊发药电子处方（开始发药指令202）；HIS系统门诊发药电子处方（结束发药指令203）
/// Debug:w ##class(web.DHCENS.BLL.Drug.BO.PharmaceutStatus).PharmaceutStatus("202","O14112803493")
ClassMethod PharmaceutStatus(sendCode As %String, sendData As %String) As %String
{
	set $zt="SendMessageET"
	set soap=##class(web.DHCENS.STBLL.DRUG.SOAP.PUB0005Soap).%New()
	set MainObj=##class(web.DHCENS.STBLL.DRUG.MODEL.PharmaceutStatusList).%New()
	s MainObj.OPSYSTEM="HIS"
	
	s MainObj.OPTYPE=sendCode
	set Obj=##class(web.DHCENS.STBLL.DRUG.MODEL.PharmaceutStatus).%New()
	///调用药房方法获取信息
	s Str=##Class(web.DHCSTInterfacePH).GetPHDispPer()
	if (Str'=""){
		s len=$L(sendData,"@")
		for i=1:1:len{
			s presInfo=$p(sendData,"@",i)
			s obj=##class(web.DHCENS.STBLL.DRUG.MODEL.PharmaceutStatus).%New()
			s obj.PRESCDATE=$p(presInfo,"^",1)
			s obj.PRESCNO=$p(presInfo,"^",2)
			s obj.INVOICENO=$p(presInfo,"^",3)
			s obj.DISPENSARY=$p(presInfo,"^",4)
			d MainObj.CONSISPRESCMSTVW.Insert(obj)
		}
	}
	set count=MainObj.CONSISPRESCMSTVW.Count()
	d MainObj.XMLExportToStream(.stream)
	set Rtn=soap.HIPMessageServer("MES0047",stream)
	set RetStr=##class(web.DHCENS.STBLL.DRUG.METHOD.BaseMethod).WlhcResultToStr(Rtn)
	if ($P(RetStr,"^",1)=1)
	{
		Q "0^"_$P(RetStr,"^",2)
	}
	else
	{
		Q "-1^"_$P(RetStr,"^",2)		
	}
SendMessageET
  ZN "DHC-APP"
  Q "-1^程序异常"_$ze
}

/*
/// Description"HIS系统门诊发药机电子处方(开始发药、结束发药、重新分配并发药)
/// Input :Input 处方号(多个处方号以^分割)
///       Status:开始发药 202  结束发药 203    重新分配并发药  206
///       WindowsCode:窗口号
///       UserCode:
/// Creator:zch
/// CreateDate:2018-07-26
/// w ##class(web.DHCENS.STBLL.DRUG.METHOD.PharmaceutStatus).PharmaceutStatus("1","202","1","demo")
ClassMethod PharmaceutStatus(Input As %String) As %String
{
	set $zt="MsgErr"
	set ^tmpzch("Input")=$ZD(+$h,3)_" "_$zt($p($h,",",2),1)
	set ^tmpxhm(2222223444)=Input
	q:Input="" "-1^处方信息为空"
	;q:Status="" "-1^类别信息为空"
	set request=##class(web.DHCENS.STBLL.DRUG.MODEL.Request).%New()
	set header=##class(web.DHCENS.STBLL.DRUG.MODEL.Header).%New()
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.SourceSystem="02"
	set request.header=header
	set body=##class(web.DHCENS.STBLL.DRUG.MODEL.Body).%New()
	set MainObj=##class(web.DHCENS.STBLL.DRUG.MODEL.PrescRt).%New()
	set MainObj.OPSysteem=$p(Input,"^",3)
	set MainObj.CKCode=$p(Input,"^",4)
	set MainObj.OPType=$p(Input,"^",5)
	set MainObj.OPIp=$p(Input,"^",6)
	set MainObj.CTCPCode=$p(Input,"^",7)
	;set UserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(UserCode),""))
	;set UserDesc=""
	;set:UserId'="" UserDesc=$p($g(^SSU("SSUSR",UserId)),"^",2)
	set MainObj.CTCPName=$p(Input,"^",8)
	set PrescDate=$p(Input,"^",9)
	set PrescNo=$p(Input,"^",10)
	set ReceiptNo=$p(Input,"^",11)
	set PharmacyNo=$p(Input,"^",12)
	set len=$l(PrescDate,"#")
	for i=1:1:len {
		set obj=##class(web.DHCENS.STBLL.DRUG.MODEL.PharmaceutStatus).%New()
		set obj.PrescNo=$p(PrescNo,"#",i)
		set obj.PrescDate=$p(PrescDate,"#",i)
		set obj.PharmacyNo=$p(PharmacyNo,"#",i)
		set obj.ReceiptNo=$p(ReceiptNo,"#",i)
		d MainObj.PharmaceutStatusRt.Insert(obj)
	}
	d body.PrescRt.Insert(MainObj)
	set request.body=body
	d request.XMLExportToStream(.Stream)
	set Soap=##class(web.DHCENS.STBLL.DRUG.SOAP.PUB0006Soap).%New()
	set Soap.Timeout=10
	set ReturnStream=Soap.SendDataFromHis("MES0047",Stream)	
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(ReturnStream,.tDocument)
	b ;;
	set String=""
	if $$$ISERR(tSC) {
		q "-1"_tSC
	}else{
		set ResultCode=""
		set tSC=tDocument.EvaluateExpression("/Response/Body/ResultCode","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
			set fieldValue=tRes.GetAt(1).Value
			set ResultCode=$tr(fieldValue,$c(0),"")
		}
		set:ResultCode=0 String="成功"
		set:ResultCode'=0 String="失败"
	}
	q String
MsgErr
	q "-1"_$ze
}
*/
}
