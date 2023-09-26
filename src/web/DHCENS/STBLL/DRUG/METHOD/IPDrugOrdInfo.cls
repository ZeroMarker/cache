Class web.DHCENS.STBLL.DRUG.METHOD.IPDrugOrdInfo Extends (%RegisteredObject, %XML.Adaptor)
{

/// Description：发送HIS中药品医嘱信息(同步) 
/// Table：DHC_PhaCollected
/// Input：住院药品发药表ROWID
/// Return：0^成功
/// Others: w ##class(web.DHCENS.STBLL.DRUG.METHOD.IPDrugOrdInfo).DispenseIPDrugInfo("955")
ClassMethod DispenseIPDrugInfo(Input As %String) As %String
{
	set $zt="SendMessage"
	set soapObj=##class(web.DHCENS.STBLL.DRUG.SOAP.PUB0006Soap).%New()
	s stream=##class(%GlobalCharacterStream).%New()
	s stream=..GetIPDrugInfo(Input)
	set result=soapObj.HIPMessageServer("MES0041",stream)
	Quit result.Read()

SendMessage
  	q "-1^程序异常"_$ze
}

/// w ##class(web.DHCENS.STBLL.DRUG.METHOD.IPDrugOrdInfo).GetIPDrugInfo("6")
ClassMethod GetIPDrugInfo(Input As %String) As %GlobalCharacterStream
{
	set $zt="SendMessageET"
	set request=##class(web.DHCENS.STBLL.DRUG.MODEL.Request).%New()
	set header=##class(web.DHCENS.STBLL.DRUG.MODEL.Header).%New()
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.SourceSystem="SYS0007"
	set request.header=header
	set success="0"
	set body=##class(web.DHCENS.STBLL.DRUG.MODEL.Body).%New()
	
	// 调用药房组方法取出住院发药主表相关信息，返回值：信息明细
	set MainObj=##class(web.DHCSTInterfacePH).GetPhMain(Input)
	// 调用药房组方法取出住院发药明细相关信息（存储在临时global中），返回值：药品总数^进程号
	set DetailObj=##class(web.DHCSTInterfacePH).GetPhDetail(Input)
	set Result=""
	k ^TmpPresOrder(+$h-2)
	if (DetailObj'="")
	{
		//医嘱总数
		set inum=$p(DetailObj,"^",1)
		//进程号
		set pid=$p(DetailObj,"^",2)
		set Id="",i=0  //^TMP(pid,"PH",PresNo,inum)
		set PresNo=""
		f  set PresNo=$o(^TMP(pid,"PH",PresNo)) q:PresNo=""  d
		.set Id=""
		.f  set Id=$o(^TMP(pid,"PH",PresNo,Id)) q:Id=""  d
		..set DrugOrdInfo=##class(web.DHCENS.STBLL.DRUG.MODEL.IPDrugOrdInfo).%New()
		..set TmpStr=$g(^TMP(pid,"PH",PresNo,Id))
		..;--------新增开始记录顺序号
		..set TmpPresNo=$P(TmpStr,"^",14)
		..set TmpPatId=$P(TmpStr,"^",8)
		..set TmpDrugCode=$P(TmpStr,"^",16)
		..set TmpOccTime=$P($P(TmpStr,"^",30)," ",1)
		..i ($d(^TmpPresOrder(TmpOccTime,TmpPresNo,TmpPatId))=0) d
		...set i=1
		...set ^TmpPresOrder(TmpOccTime,TmpPresNo,TmpPatId)=i
		..e  d
		...set i=^TmpPresOrder(TmpOccTime,TmpPresNo,TmpPatId)
		...set ^TmpPresOrder(TmpOccTime,TmpPresNo,TmpPatId)=i+1
		..;--------新增结束顺序号
		..set DrugOrdInfo.PresNo=$P(TmpStr,"^",14)
		..set DrugOrdInfo.SeqNo=i
		..set:$P(TmpStr,"^",7)'="" DrugOrdInfo.DocumentNo=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID($P(TmpStr,"^",7),"I","",.ErrMsg)
		..set DrugOrdInfo.PatId=$P(TmpStr,"^",8)
		..set DrugOrdInfo.Name=$P(TmpStr,"^",9)
		..set DrugOrdInfo.Sex=$P(TmpStr,"^",10)
		..set DrugOrdInfo.DOB=$P(TmpStr,"^",11)
		..set DrugOrdInfo.Age=$tr($P(TmpStr,"^",12),"岁","")
		..set DrugOrdInfo.AdmNo=$P(TmpStr,"^",6)
		..set DrugOrdInfo.DeptCode=$P(TmpStr,"^",13)
		..set DrugOrdInfo.DeptName=""
		..set DrugOrdInfo.WardCode=$P(TmpStr,"^",3)
		..set DrugOrdInfo.WardName=$P(TmpStr,"^",4)	
		..set DrugOrdInfo.BedNo=$P(TmpStr,"^",5)
		..set DrugOrdInfo.DocCode=$P(TmpStr,"^",22)
		..set DrugOrdInfo.DocName=$P(TmpStr,"^",23)	
		..set DrugOrdInfo.OrdId=$P(TmpStr,"^",1)
		..set DrugOrdInfo.OrdType=""
		..set DrugOrdInfo.OrdDetailId=$P(TmpStr,"^",2) ;$P(TmpStr,"^",48)   
		..set DateTime=$P(TmpStr,"^",35)
		..set:DateTime'="" DrugOrdInfo.OrdDateTime=$P(TmpStr,"^",34)_" "_$P(TmpStr,"^",35)
		..set DrugOrdInfo.DrugCode=$P(TmpStr,"^",16)
		..set DrugOrdInfo.DrugName=$P(TmpStr,"^",17)
		..set DrugOrdInfo.Comment=$P(TmpStr,"^",45)
		..set DrugOrdInfo.Usage=$P(TmpStr,"^",24)
		..set DrugOrdInfo.Specification=$P(TmpStr,"^",26)    
		..set DrugOrdInfo.DrugSpec=""
		..set DrugOrdInfo.MinDos=""
		..set:$P(TmpStr,"^",36)'="" DrugOrdInfo.MinDosUnits=$p($g(^CT("UOM",$P(TmpStr,"^",36))),"^",1)	
		..set DrugOrdInfo.Dosage=$P(TmpStr,"^",27)
		..set DrugOrdInfo.DosUnit=$P(TmpStr,"^",28)	
		..set DrugOrdInfo.UsageNum=$P(TmpStr,"^",38)
		..set DrugOrdInfo.UsageNum=$num(+DrugOrdInfo.UsageNum,2)
		..set DrugOrdInfo.TotalNum=$P(TmpStr,"^",18)
		..set DrugOrdInfo.OccTime=$P(TmpStr,"^",30)
		..set DrugOrdInfo.UsageCount=$P(TmpStr,"^",31)		
		..set DrugOrdInfo.Flag=0
		..set DrugOrdInfo.MacNo=1
		..set DrugOrdInfo.PriFlag=$P(TmpStr,"^",39)
		..set DrugOrdInfo.DetailSeq=$p(TmpStr,"^",6)_"|"_$p(TmpStr,"^",1)
		..set DrugOrdInfo.Priority=$P(TmpStr,"^",39)
		..set DrugOrdInfo.Price=$P(TmpStr,"^",20)
		..set DrugOrdInfo.Freq=""
		..set DrugOrdInfo.FreqDesc=$P(TmpStr,"^",29)
		..set DrugOrdInfo.BatNo=$P(TmpStr,"^",33)
		..set DrugOrdInfo.FrescFac=$P(TmpStr,"^",37)
		..set DrugOrdInfo.ManfName=$P(TmpStr,"^",46)
		..set DrugOrdInfo.AmountUomFac=$P(TmpStr,"^",44)  
		..set DrugOrdInfo.BarCode=$P(TmpStr,"^",25)
		..set DrugOrdInfo.FormCode=$P(TmpStr,"^",47)
		..set DrugOrdInfo.BaseUnit=$P(TmpStr,"^",19)
		..if MainObj'="" d
		...set DrugOrdInfo.PageNo=$p(MainObj,"^",5)	    
		...set DrugOrdInfo.GroupNo=$p(MainObj,"^",1)
		...set:$p(MainObj,"^",1)'="" DrugOrdInfo.GroupCode=$p($g(^CTLOC($p(MainObj,"^",1))),"^",1)
		...set DrugOrdInfo.GroupDesc=$p(MainObj,"^",2)
		...set DrugOrdInfo.DrugType=$p(MainObj,"^",25)
		...set DrugOrdInfo.PrintTime=$p(MainObj,"^",6)_" "_$p(MainObj,"^",7)
		...d body.IPDrugOrds.Insert(DrugOrdInfo)
	}
	K ^TMP(pid,"PHD")
	s request.body=body
	s stream=##class(%GlobalCharacterStream).%New()
	d request.XMLExportToStream(.stream)
	q stream
		
SendMessageET
	s pid=0
  	K ^TMP(pid,"PHD")
  	s stream=##class(%GlobalCharacterStream).%New()
  	d stream.Write("-1^程序异常"_$ze)
  	q stream
}

}
