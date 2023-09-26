/// 导诊单
Class DHCExternalService.QryInterface.BL.DirectInfo Extends %RegisteredObject
{

/// 根据发票获取导诊单信息
ClassMethod GetDirectListByPrtRowid(Input As %String) As %GlobalCharacterStream
{
	set $zt="GetDirectListByPrtRowidET"	
    Set err=0
    Set streamObj=##class(%GlobalCharacterStream).%New()
	Set inputObj=##class(DHCExternalService.BillInterface.DHCEntity.AutoPayInputInfo).%New()
    Do inputObj.XMLNodeDeserialize(.inputObj,"Request",Input)
    Set invRowID=inputObj.InvoiceNO
    
    Set OutputXML=""
	Set OutputObj=##class(DHCExternalService.BillInterface.DHCEntity.AutoPayDirectResult).%New()
	If ((invRowID="")||('$d(^DHCINVPRT(invRowID)))){
		Set OutputObj.ResultCode=-3
   		Set OutputObj.ErrorMsg="传入发票为空"  
   		Do OutputObj.XMLExportToString(.OutputXML,"Response")
   		Do OutputObj.%Close()
	}
	q:((invRowID="")||('$d(^DHCINVPRT(invRowID)))) OutputXML
	b ;b0
	s WindowStr=""
	s dhcBCIRowid=0
	f  s dhcBCIRowid=$o(^DHCBCI(0,"INV",invRowID,dhcBCIRowid)) q:dhcBCIRowid=""  d
	.s admRowId="",papmiRowId="",userName="",date="",sexRowId="",PatSex="",tmpAge="",PatAge="",mrRowId="",locRowId="",locName="",prtDate=""
	.s admRowId=$p(^DHCBCI(dhcBCIRowid),"^",3)
	.s locRowId=$p(^PAADM(admRowId),"^",4)
	.s AdmLoc=$p(^CTLOC(locRowId),"^",2)   //接诊科室
	.s AdmLocAddress=""
	.s AdmLocAddress=$p(^CTLOC(locRowId),"^",41) //楼层
	.i AdmLoc["-" s AdmLoc=$p(AdmLoc,"-",2)
	.s AdmDoc=$p($g(^PAADM(admRowId)),"^",9)  
    .i AdmDoc'="" s AdmDoc=$p($g(^CTPCP(AdmDoc,1)),"^",2)     //就诊医生
	.s papmiRowId=$p(^PAADM(admRowId),"^",1)
	.s mradm=$p(^PAADM(admRowId),"^",61)
	.s AdmDia=##class(web.DHCMRDiagnos).GetMRDiagnosDesc($G(mradm),"/")
	.s PatName=$p(^PAPER(papmiRowId,"ALL"),"^",1)   //姓名
	.s PatNo=$p(^PAPER(papmiRowId,"PAT",1),"^",1)   //登记号
	.s CardNo=##class(web.DHCOutPhNewAddCommit).GetCardFrPmi(PatNo)
	.s sexRowId=$p(^PAPER(papmiRowId,"ALL"),"^",7)
	.s PatSex=$p(^CT("SEX",sexRowId),"^",2)      //性别
	.s tmpAge=$p(^PAPER(papmiRowId,"ALL"),"^",6)  
	.s PatAge=$p($zdt($h,3),"-",1)-$p($zdt(tmpAge,3),"-",1)  //年龄
	.s InvNo=$p(^DHCINVPRT(invRowID),"^",14)             //发票号
	.s PrtDate=$zd($p(^DHCINVPRT(invRowID),"^",5),3)_" "_$zt($p(^DHCINVPRT(invRowID),"^",20))      //打印日期时间
	.s billRowId=$p(^DHCBCI(dhcBCIRowid),"^",2)
	.s pboChildSub=0
	.s loc=""
	.f  s pboChildSub=$o(^DHCPB(billRowId,"O",pboChildSub)) q:pboChildSub=""  d
	..s arcIMRowId=$p(^DHCPB(billRowId,"O",pboChildSub),"^",3)
	..s arcimSubscript=$p(arcIMRowId,"||",1)
	..s arcimVersion=$p(arcIMRowId,"||",2)
	..s myOeoriDr=$p(^DHCPB(billRowId,"O",pboChildSub),"^",4)
	..s myPresNo=$p(^OEORD(+myOeoriDr,"I",$p(myOeoriDr,"||",2),1),"^",14)
	..i myOeoriDr="" b
	..s locRowId=$p(^OEORD(+myOeoriDr,"I",$p(myOeoriDr,"||",2),3),"^",6)   //接受科室Rowid
	..s locDesc=$p(^CTLOC(locRowId),"^",2)   //接受科室
	..s OrdInfo=""  ;##class(web.UDHCOPINVPrtData12).GetOrdByOrdId(myOeoriDr)
	..s OrdRecDep=$p(OrdInfo,"^",6)
	..i locRowId="" s locRowId=0
	..s myLocAddress=""  ;##class(web.UDHCOPINVPrtData12).GetLocAddress(locRowId)
	..s WinInfo=""
	..i myPresNo'="" s WinInfo=##class(web.DHCMZYFXTYW02).GetPrtPrescWin(invRowID,myPresNo)
	..i WindowStr'[WinInfo   s WindowStr=WindowStr_WinInfo 	
	..i myLocAddress="" s myLocAddress="无接收科室"
	..s ^TMP("ADRESS",$j,locRowId,myLocAddress,myOeoriDr)=OrdInfo_"^"_WinInfo
	b ;b1
	s locRowId=0
	f  s locRowId=$o(^TMP("ADRESS",$j,locRowId)) q:locRowId=""  d
	.s myAdress="",listData1=""
	.f  s myAdress=$o(^TMP("ADRESS",$j,locRowId,myAdress)) q:myAdress=""  d
	..s OUTRECCURObj=##class(DHCExternalService.BillInterface.DHCEntity.RecLoc).%New()  	
	..s locDesc=$p(^CTLOC(locRowId),"^",2)   //接受科室
	..s:locDesc["-" locDesc=$p(locDesc,"-",2)
	..s OUTRECCURObj.RecLocDesc=locDesc
  	..s OUTRECCURObj.RecLocAddress=myAdress
	..s OrdId=""
	..f  s OrdId=$o(^TMP("ADRESS",$j,locRowId,myAdress,OrdId)) q:(OrdId="")  d  //||(intNo>1)  d   20100721
	...s OeOrdObj=##class(DHCExternalService.BillInterface.DHCEntity.OEOrdItem).%New()
	...s mytmpstr=^TMP("ADRESS",$j,locRowId,myAdress,OrdId)
	...s orditmmast=$p($g(^OEORD(+OrdId,"I",$p(OrdId,"||",2),1)),"^",2)     ;//医嘱项	
	...s OrderName=$p(mytmpstr,"^",1)
	...s OrderPrice=$p(mytmpstr,"^",4)
	...s OrderQty=$p(mytmpstr,"^",3)
	...i ($l(OrderName)>15)  s OrderName=$e(OrderName,1,15)	
  	...s OeOrdObj.ArcmiDesc=OrderName
  	...s OeOrdObj.Price=OrderPrice
  	...s OeOrdObj.Qty=OrderQty
  	...d OUTRECCURObj.Items.Insert(OeOrdObj)
  	...d OeOrdObj.%Close()
  	..d OutputObj.RecLocs.Insert(OUTRECCURObj)
  	..d OUTRECCURObj.%Close()
  	k ^TMP("ADRESS",$j)
  	s OutputObj.ResultCode=0
  	s OutputObj.ResultContent="成功"
  	s OutputObj.PatNo=PatNo
  	s OutputObj.CardNo=CardNo
  	s OutputObj.PrtDate=PrtDate
  	s OutputObj.PatName=PatName
  	s OutputObj.PatSex=PatSex
  	s OutputObj.PatAge=PatAge
  	s OutputObj.AdmLoc=AdmLoc
  	s OutputObj.AdmLocAddress=AdmLocAddress
  	s OutputObj.AdmDoc=AdmDoc
  	s OutputObj.AdmDia=AdmDia
  	s OutputObj.PreWindow=WindowStr
  	
	d OutputObj.XMLExportToString(.OutputXML,"Response")
	d OutputObj.%Close()
	b ;kk
	q OutputXML

	

GetDirectListByPrtRowidET
	set myrtn="<Response><ResultCode>-10</ResultCode><ErrorMsg>程序处理出错:"_$ZERROR_"</ErrorMsg></Response>"
	set streamObj=##class(%GlobalCharacterStream).%New()
	do streamObj.Write(myrtn)
	quit streamObj
}

}
