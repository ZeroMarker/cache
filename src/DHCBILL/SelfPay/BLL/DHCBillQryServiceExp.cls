/// 2018-07-07
/// 计费查询相关接口
Class DHCBILL.SelfPay.BLL.DHCBillQryServiceExp Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// CreatDate:2018-05-07
/// Desc: 获取交易明细
/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCBillQryServiceExp).GetCheckDetails("<Request><TradeCode>4802</TradeCode><HospitalID>2</HospitalID><TradeChannel>ScanPayCDSNP</TradeChannel><StartDate>2018-05-01</StartDate><EndDate>2018-05-08</EndDate><ExpStr/></Request>").Read()
ClassMethod GetBillExtTradeDetails(Input As %String) As %GlobalCharacterStream
{
	set $ZT="GetBillExtTradeDetailsET"
	set ^TMPIPBILL("GetBillExtTradeDetails")=Input
    new (Input)
	Set InputObj=##Class(DHCBILL.SelfPay.Entity.GetBillExtTradeDetails.Req.Request).%New()
	Do InputObj.XMLNodeDeserialize(.InputObj,"Request",Input)
	set HospitalID=InputObj.HospitalID
	set TradeChannel=InputObj.TradeChannel
    set StDate=InputObj.StartDate	;查询日期
    set EndDate=InputObj.EndDate
    set:StDate'="" StDate=$zdh(StDate,3)
    set:EndDate'="" EndDate=$zdh(EndDate,3)
    b ;
    Set OutputObj=##class(DHCBILL.SelfPay.Entity.GetBillExtTradeDetails.Res.Response).%New()
	If (TradeChannel=""){
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj,"-1","TradeChannel字段不能为空")
		Quit OutputXML
	}
	If (StDate="")||(EndDate=""){
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj,"-2","开始日期结束日期不能为空")
		Quit OutputXML
	}
	set Index = 0
    for Date=StDate:1:EndDate do
	.set ETPRowID=""
	.for  set ETPRowID=$o(^DHCBILLETPi(0,"TCDate",TradeChannel,Date,ETPRowID)) quit:ETPRowID=""  do
	..set TradeData=$g(^DHCBILLETP(ETPRowID))
	..set ETPRc=$p(TradeData,"^",1)
	..quit:(ETPRc'="00")	//&&(ETPRc'="04")
	..set HISTradeNo=$p(TradeData,"^",32)
	..set HISTradeAmt=$p(TradeData,"^",23)
	..set HISTradeDate=$p(TradeData,"^",21)
	..set HISTradeTime=$p(TradeData,"^",22)
	..set TradeNo=$p(TradeData,"^",47)
	..set TradeAmt=$p(TradeData,"^",4)
	..set PlatformNo=$p(TradeData,"^",7)
	..set ExtTradeChannel=$p(TradeData,"^",46)
	..set ExtTradeType=$p(TradeData,"^",26)
	..set OldHISHISTradeNo=$p(TradeData,"^",33)
	..set TradeUserId=$p(TradeData,"^",24)
	..set TradeUser=$p($g(^SSU("SSUSR",+TradeUserId)),"^",2)
	..set Papmi=$p(TradeData,"^",40)
	..set PatNo=$p($g(^PAPER(+Papmi,"PAT",1)),"^",1)
	..set PatName=$p($g(^PAPER(+Papmi,"ALL")),"^",1)
	..set HISType=$p(TradeData,"^",25)	;OP,IP,DEP,PRE,CARD,INSU
	..set FairType=""
	..if (HISType="OP")  do
	...set Sub=$o(^DHCBILLETP(ETPRowID,"C",0))
	...quit:Sub=""
	...set PrtRowID=$p(^DHCBILLETP(ETPRowID,"C",Sub),"^",1)
	...quit:$d(^DHCINVPRT(PrtRowID))=0
	...set FairType=$p(^DHCINVPRT(PrtRowID),"^",34)
	..set:(HISType="OP")&&(FairType="R") HISType="门诊挂号"
	..set:(HISType="OP")&&(FairType'="R") HISType="门诊收费"
	..set:(HISType="DEP") HISType="住院押金"
	..;------------
	..set TradeListObj=##class(DHCBILL.SelfPay.Entity.GetBillExtTradeDetails.Res.TradeList).%New()
	..set Index=Index+1
	..set TradeListObj.Index=Index
	..set TradeListObj.HISTradeNo=HISTradeNo
	..set TradeListObj.HISTradeAmt=$fn(HISTradeAmt,"",2)
	..set TradeListObj.HISTradeDate=$zd(HISTradeDate,3)
	..set TradeListObj.HISTradeTime=$zt(HISTradeDate,1)
	..set TradeListObj.TradeNo=TradeNo
	..set TradeListObj.TradeAmt=$fn(+TradeAmt,"",2)
	..set TradeListObj.PlatformNo=PlatformNo
	..set TradeListObj.TradeChannel=ExtTradeChannel
	..set TradeListObj.TradeType=ExtTradeType
	..set TradeListObj.OldHISHISTradeNo=OldHISHISTradeNo
	..set TradeListObj.TradeUser=TradeUser
	..set TradeListObj.PatNo=PatNo
	..set TradeListObj.PatName=PatName
	..set TradeListObj.HISTradeType=HISType
	..do OutputObj.TradeLists.Insert(TradeListObj)
	..do TradeListObj.%Close()

	set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj,"0","成功")
	quit OutputXML	
GetBillExtTradeDetailsET
	Set OutputObj=##class(DHCBILL.SelfPay.Entity.GetBillExtTradeDetails.Res.Response).%New()
	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj,"-99","程序处理错误:"_$ZERROR)
	Quit OutputXML
}

/// CreatDate:2018-07-07
/// Desc: 根据就诊查询费用
/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCBillQryServiceExp).GetBillDetails("<Request><TradeCode></TradeCode><AdmID>81</AdmID><StartDate></StartDate><EndDate></EndDate><OutFlag>0</OutFlag><ExpStr></ExpStr></Request>")
/// Debug: w ##class(DHCBILL.SelfPay.BLL.DHCBillQryServiceExp).GetBillDetails(^TMPIPBILL("GetBillDetails"))
ClassMethod GetBillDetails(Input As %String) As %GlobalCharacterStream
{
	set ^TMPIPBILL("GetBillDetails")=Input
    new (Input)
	set $ZT="GetBillDetailsET"
	set InputObj=##class(DHCBILL.SelfPay.Entity.GetBillDetails.Req.Request).%New()
    do InputObj.XMLNodeDeserialize(.InputObj,"Request",Input)
    set OutStream=##class(%GlobalCharacterStream).%New()
    Set AdmID=InputObj.AdmID ;就诊号    
    set StartDate=InputObj.StartDate
    set EndDate=InputObj.EndDate
    set OutFlag=InputObj.OutFlag
    set ExpStr=InputObj.ExpStr
    //set OutFlag=0	//1显示医嘱明细,0显示收费明细(都不合并,合并让第三方处理?)
    
    if StartDate'="" set StartDate=$zdh(StartDate,3)
    if EndDate'="" set EndDate=$zdh(EndDate,3)
    
    set OutputObj=##class(DHCBILL.SelfPay.Entity.GetBillDetails.Res.Response).%New()
    if (AdmID="")||($d(^PAADM(+AdmID))=0){
	    set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj,"-1","就诊号不能为空或就诊不存在")
		quit OutputXML
    }
    
    set Bill=""
    for  set Bill=$o(^DHCPB(0,"ADM",AdmID,Bill))  quit:Bill=""  do
	.quit:$d(^DHCPB(Bill))=0
	.set BillObj=##class(DHCBILL.SelfPay.Entity.GetBillDetails.Res.Bill).%New()
	.set PBStDate=$p(^DHCPB(Bill),"^",6)
	.set PBEndDate=$p(^DHCPB(Bill),"^",7)
	.;set PBTotalAmount=$p(^DHCPB(Bill),"^",8)
	.;set PBDiscAmount=$p(^DHCPB(Bill),"^",196)
	.;set PBPayorShare=$p(^DHCPB(Bill),"^",11)
	.;set PBPatShare=$p(^DHCPB(Bill),"^",12)
	.set PBPayFlag=$p(^DHCPB(Bill),"^",16)
	.if PBPayFlag="P" set PBPayFlag="已结算"
	.else  set PBPayFlag="未结算"
	.if PBStDate'="" set PBStDate=$zd(PBStDate,3)
	.if PBEndDate'="" set PBEndDate=$zd(PBEndDate,3)
	.set (PBTotalAmount,PBDiscAmount,PBPayorShare,PBPatShare)=0
	.kill ^||TMP("IPBill",$j)
    .set PBOSub=0
    .for  set PBOSub=$o(^DHCPB(Bill,"O",PBOSub))  quit:PBOSub=""  do
    ..quit:$d(^DHCPB(Bill,"O",PBOSub))=10
	..set PBOrd=$p($g(^DHCPB(Bill,"O",PBOSub)),"^",4)
	..Quit:PBOrd=""
	..Quit:'$d(^OEORD($p(PBOrd,"||",1),"I",$p(PBOrd,"||",2)))
	..;输出医嘱明细(不合并,合并由第三方处理？)
	..if (OutFlag=1) do
	...set OrdObj=##class(DHCBILL.SelfPay.Entity.GetBillDetails.Res.OrdItem).%New()
	...set ArcimDR=$p($g(^DHCPB(Bill,"O",PBOSub)),"^",3)
	...set OrdCode=$p($g(^ARCIM(+ArcimDR,+$p(ArcimDR,"||",2),1)),"^",1)
	...set OrdDesc=$p($g(^ARCIM(+ArcimDR,+$p(ArcimDR,"||",2),1)),"^",2)
	...set OrdExcID=$p($g(^DHCPB(Bill,"O",PBOSub)),"^",20)
	...set OrdDate=$p(^OEORD(+OrdExcID,"I",$p(OrdExcID,"||",2),"X",$p(OrdExcID,"||",3)),"^",1)
	...set OrdTime=$p(^OEORD(+OrdExcID,"I",$p(OrdExcID,"||",2),"X",$p(OrdExcID,"||",3)),"^",2)
	...set OrdQty=$p($g(^DHCPB(Bill,"O",PBOSub)),"^",5)
	...set OrdPrice=$p($g(^DHCPB(Bill,"O",PBOSub)),"^",7)
	...set OrdTotalAmount=$p($g(^DHCPB(Bill,"O",PBOSub)),"^",8)
	...set OrdDiscAmount=$p($g(^DHCPB(Bill,"O",PBOSub)),"^",9)
	...set OrdPayorShare=$p($g(^DHCPB(Bill,"O",PBOSub)),"^",10)
	...set OrdPatShare=$p($g(^DHCPB(Bill,"O",PBOSub)),"^",11)
	...quit:((+OrdTotalAmount=0)&&(+OrdPatShare=0))
	
	

	...if OrdDate'="" set OrdDate=$zd(OrdDate,3)
	...if OrdTime'="" set OrdTime=$zt(OrdTime,1)
	...;费用日期??
	...set PBDSub=$o(^DHCPB(Bill,"O",PBOSub,"D",0)) 
	...set BillDate=StartDate
	...if PBDSub'="" do
	....set BillDate=$p(^DHCPB(Bill,"O",PBOSub,"D",PBDSub),"^",11)
	...quit:(StartDate'="")&&(EndDate'="")&&((BillDate<StartDate)||(BillDate>EndDate))
	
	...//取整包装单位、数量
	...set OrdUom=##class(web.DHCBillCommon).GetPackUom(ArcimDR, PBOrd)
	...set Confac=##class(web.DHCBillCommon).GetUomConvFactor(ArcimDR, PBOrd)
	...set OrdQty=OrdQty/Confac
	
	...if '$d(^||TMP("IPBill",$j,ArcimDR,$fn(OrdPrice,"",7)))  do  //合并
	....set ^||TMP("IPBill",$j,ArcimDR,$fn(OrdPrice,"",7))=OrdCode_"^"_OrdDesc_"^"_OrdQty_"^"_OrdPrice_"^"_OrdUom_"^"_OrdTotalAmount_"^"_OrdDiscAmount_"^"_OrdPayorShare_"^"_OrdPatShare
	...else  do
	....set $p(^||TMP("IPBill",$j,ArcimDR,$fn(OrdPrice,"",7)),"^",3)=$p(^||TMP("IPBill",$j,ArcimDR,$fn(OrdPrice,"",7)),"^",3)+OrdQty
	....set $p(^||TMP("IPBill",$j,ArcimDR,$fn(OrdPrice,"",7)),"^",6)=$p(^||TMP("IPBill",$j,ArcimDR,$fn(OrdPrice,"",7)),"^",6)+OrdTotalAmount
	....set $p(^||TMP("IPBill",$j,ArcimDR,$fn(OrdPrice,"",7)),"^",7)=$p(^||TMP("IPBill",$j,ArcimDR,$fn(OrdPrice,"",7)),"^",7)+OrdDiscAmount
	....set $p(^||TMP("IPBill",$j,ArcimDR,$fn(OrdPrice,"",7)),"^",8)=$p(^||TMP("IPBill",$j,ArcimDR,$fn(OrdPrice,"",7)),"^",8)+OrdPayorShare
	....set $p(^||TMP("IPBill",$j,ArcimDR,$fn(OrdPrice,"",7)),"^",9)=$p(^||TMP("IPBill",$j,ArcimDR,$fn(OrdPrice,"",7)),"^",9)+OrdPatShare
	...set PBTotalAmount=PBTotalAmount+OrdTotalAmount
	...set PBDiscAmount=PBDiscAmount+OrdDiscAmount
	...set PBPayorShare=PBPayorShare+OrdPayorShare
	...set PBPatShare=PBPatShare+OrdPatShare
	
	...quit
	...set OrdObj.OrdCode=OrdCode
	...set OrdObj.OrdDesc=OrdDesc
	...set OrdObj.OrdDate=OrdDate
	...set OrdObj.OrdTime=OrdTime
	...set OrdObj.OrdQty=OrdQty
	...set OrdObj.OrdPrice=$fn(OrdPrice,"",2)
	...set OrdObj.OrdTotalAmount=OrdTotalAmount
	...set OrdObj.OrdDiscAmount=OrdDiscAmount
	...set OrdObj.OrdPayorShare=OrdPayorShare
	...set OrdObj.OrdPatShare=OrdPatShare
	...set OrdObj.OrdUom=OrdUom
	
	...do BillObj.OrdItemList.Insert(OrdObj)
	...do OrdObj.%Close()
	..;取收费项目明细(不合并,合并由第三方处理？)
	..else  do
	...set PBDSub=0 
	...for  set PBDSub=$o(^DHCPB(Bill,"O",PBOSub,"D",PBDSub)) quit:(PBDSub="")  do
	....set Data=$g(^DHCPB(Bill,"O",PBOSub,"D",PBDSub))
	....quit:Data=""
	....set ItemObj=##class(DHCBILL.SelfPay.Entity.GetBillDetails.Res.TarItem).%New()
	....set BillDate=$p(Data,"^",11)
	....quit:(StartDate'="")&&(EndDate'="")&&((BillDate<StartDate)||(BillDate>EndDate))
	....set BillTime=$p(Data,"^",12)
	....set BillStatus=$p(Data,"^",14)
	....set Qty=$p(Data,"^",5)     			;pbd_billqty
    ....set Price=$p(Data,"^",4)	;pbd_unitprice
    ....set TotalAmount=$p(Data,"^",7)    		;pbd_totalamount
    ....set DiscAmount=$p(Data,"^",8) 
    ....set PayorShare=$p(Data,"^",9) 
    ....set PatShare=$p(Data,"^",10) 
	....set TarItem=$p(Data,"^",3)
	....quit:((+TotalAmount=0)&&(+PatShare=0))
	....quit:TarItem=""
	....set TarItemCode=$p(^DHCTARI(TarItem),"^",1)
	....set TarItemDesc=$p(^DHCTARI(TarItem),"^",2)
  	....set TarItemChargeBasis=$p(^DHCTARI(TarItem),"^",20)     ;取物价编码
  	....set TarCateSub=$p(^DHCTARI(TarItem),"^",14)
	....set TarCate=$p($g(^DHCTarC("IC",+TarCateSub)),"^",3)  ;收费项目住院分类
	....set TarCateCode=$p($g(^DHCTarC("TIC",+TarCate)),"^",1)
	....set TarCateDesc=$p($g(^DHCTarC("TIC",+TarCate)),"^",2)	;住院大类
	
	....if '$d(^||TMP("IPBill",$j,TarItem,$fn(Price,"",7)))  do  //合并
	.....set ^||TMP("IPBill",$j,TarItem,$fn(Price,"",7))=TarCateCode_"^"_TarCateDesc_"^"_TarItemCode_"^"_TarItemDesc_"^"_Qty_"^"_Price_"^"_TotalAmount_"^"_DiscAmount_"^"_PayorShare_"^"_PatShare
	....else  do
	.....set $p(^||TMP("IPBill",$j,TarItem,$fn(Price,"",7)),"^",5)=$p(^||TMP("IPBill",$j,TarItem,$fn(Price,"",7)),"^",5)+Qty
	.....set $p(^||TMP("IPBill",$j,TarItem,$fn(Price,"",7)),"^",7)=$p(^||TMP("IPBill",$j,TarItem,$fn(Price,"",7)),"^",7)+TotalAmount
	.....set $p(^||TMP("IPBill",$j,TarItem,$fn(Price,"",7)),"^",8)=$p(^||TMP("IPBill",$j,TarItem,$fn(Price,"",7)),"^",8)+DiscAmount
	.....set $p(^||TMP("IPBill",$j,TarItem,$fn(Price,"",7)),"^",9)=$p(^||TMP("IPBill",$j,TarItem,$fn(Price,"",7)),"^",9)+PayorShare
	.....set $p(^||TMP("IPBill",$j,TarItem,$fn(Price,"",7)),"^",10)=$p(^||TMP("IPBill",$j,TarItem,$fn(Price,"",7)),"^",10)+PatShare
	....set PBTotalAmount=PBTotalAmount+TotalAmount
	....set PBDiscAmount=PBDiscAmount+DiscAmount
	....set PBPayorShare=PBPayorShare+PayorShare
	....set PBPatShare=PBPatShare+PatShare
	
	....quit
	....if BillDate'="" set BillDate=$zd(BillDate,3)
	....if BillTime'="" set BillTime=$zt(BillTime,1)
	....set ItemObj.TarCateCode=TarCateCode
	....set ItemObj.TarCateDesc=TarCateDesc
	....set ItemObj.ItemCode=TarItemCode
	....set ItemObj.ItemDesc=TarItemDesc
	....set ItemObj.ItemBillDate=BillDate
	....set ItemObj.ItemBillTime=BillTime
	....set ItemObj.ItemQty=Qty
	....set ItemObj.ItemPrice=$fn(Price,"",2)
	....set ItemObj.ItemTotalAmount=TotalAmount
	....set ItemObj.ItemDiscAmount=DiscAmount
	....set ItemObj.ItemPayorShare=PayorShare
	....set ItemObj.ItemPatShare=PatShare
	
	
	....do BillObj.TarItemList.Insert(ItemObj)
	....do ItemObj.%Close()
	
	
	.;合并后输出
	.if (OutFlag=1) do
	..set Node1=""
	..for  set Node1=$o(^||TMP("IPBill",$j,Node1)) quit:(Node1="")  do
	...set Node2=""
	...for  set Node2=$o(^||TMP("IPBill",$j,Node1,Node2)) quit:(Node2="")  do
	....set OrdObj=##class(DHCBILL.SelfPay.Entity.GetBillDetails.Res.OrdItem).%New()
	....set OrdData=$g(^||TMP("IPBill",$j,Node1,Node2))
	....;OrdCode_"^"_OrdDesc_"^"_OrdQty_"^"_OrdPrice_"^"_OrdUom_"^"_OrdTotalAmount_"^"_OrdDiscAmount_"^"_OrdPayorShare_"^"_OrdPatShare
	....set OrdObj.OrdCode=$p(OrdData,"^",1)
	....set OrdObj.OrdDesc=$p(OrdData,"^",2)
	....set OrdObj.OrdQty=$p(OrdData,"^",3)
	....set OrdObj.OrdPrice=$fn($p(OrdData,"^",4),"",2)
	....set OrdObj.OrdTotalAmount=$fn($p(OrdData,"^",6),"",2)
	....set OrdObj.OrdDiscAmount=$fn($p(OrdData,"^",7),"",2)
	....set OrdObj.OrdPayorShare=$fn($p(OrdData,"^",8),"",2)
	....set OrdObj.OrdPatShare=$fn($p(OrdData,"^",9),"",2)
	....set OrdObj.OrdUom=$p(OrdData,"^",5)
	....do BillObj.OrdItemList.Insert(OrdObj)
	....do OrdObj.%Close()
	.else  do
	..set Node1=""
	..for  set Node1=$o(^||TMP("IPBill",$j,Node1)) quit:(Node1="")  do
	...set Node2=""
	...for  set Node2=$o(^||TMP("IPBill",$j,Node1,Node2)) quit:(Node2="")  do
	....set ItemObj=##class(DHCBILL.SelfPay.Entity.GetBillDetails.Res.TarItem).%New()
	....set itmData=$g(^||TMP("IPBill",$j,Node1,Node2))
	....;TarCateCode_"^"_TarCateDesc_"^"_TarItemCode_"^"_TarItemDesc_"^"_Qty_"^"_ItemPrice_"^"_TotalAmount_"^"_DiscAmount_"^"_PayorShare_"^"_PatShare
	....set ItemObj.TarCateCode=$p(itmData,"^",1)
	....set ItemObj.TarCateDesc=$p(itmData,"^",2)
	....set ItemObj.ItemCode=$p(itmData,"^",3)
	....set ItemObj.ItemDesc=$p(itmData,"^",4)

	....set ItemObj.ItemQty=$p(itmData,"^",5)
	....set ItemObj.ItemPrice=$fn($p(itmData,"^",6),"",2)
	....set ItemObj.ItemTotalAmount=$fn($p(itmData,"^",7),"",2)
	....set ItemObj.ItemDiscAmount=$fn($p(itmData,"^",8),"",2)
	....set ItemObj.ItemPayorShare=$fn($p(itmData,"^",9),"",2)
	....set ItemObj.ItemPatShare=$fn($p(itmData,"^",10),"",2)
	....do BillObj.TarItemList.Insert(ItemObj)
	....do ItemObj.%Close()
	
	.set BillObj.BillStDate=PBStDate
	.set BillObj.BillEndDate=PBEndDate
	.set BillObj.BillTotalAmount=PBTotalAmount
	.set BillObj.BillDiscAmount=PBDiscAmount
	.set BillObj.BillPayorShare=PBPayorShare
	.set BillObj.BillPatShare=PBPatShare
	.set BillObj.BillStatus=PBPayFlag
	.do OutputObj.BillList.Insert(BillObj)
	.do BillObj.%Close()
	
	set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj,"0","成功")
	quit OutputXML
GetBillDetailsET	
    set OutputObj=##class(DHCBILL.SelfPay.Entity.GetBillDetails.Res.Response).%New()
	set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj,"-99","程序处理错误:"_$ZERROR)
	quit OutputXML
}

ClassMethod QueryReFundOrderInfo(input As %String) As %GlobalCharacterStream
{
	set $zt="QueryReFundOrderInfoET"
	
	
	set inputObj=##Class(DHCBILL.SelfPay.Entity.QueryReFundOrderInfo.Req.Request).%New()
	do inputObj.XMLNodeDeserialize(.inputObj,"Request",input)
	set stDateTime=InputObj.stDate
	set endDateTime=InputObj.endDate
	set guser = InputObj.guser
	set tradeChannel="ZZJPay"
	
	set outputObj=##class(DHCBILL.SelfPay.Entity.QueryReFundOrderInfo.Req.Response).%New()
	set stDate=$p($zdth(stDateTime,3,1),",",1)
	set stTime=$p($zdth(stDateTime,3,1),",",2)
	set endDate=$p($zdth(endDateTime,3,1),",",1)
	set endTime=$p($zdth(endDateTime,3,1),",",2)
	
	set listObj=##class(DHCBILL.SelfPay.Entity.QueryReFundOrderInfo.Req.ResultData).%New()
	for date=stDate:1:endDate do
	.set ETPRowID=""
	.for  set ETPRowID=$o(^DHCBILLETPi(0,"TCDate",tradeChannel,date,ETPRowID)) quit:(ETPRowID="")  do
	..set tradeData=$g(^DHCBILLETP(ETPRowID))
	..set ETPRc=$p(tradeData,"^",1)
	..quit:(ETPRc'="00")
	..set extTradeType=$p(tradeData,"^",26)
	..quit:(extTradeType'="D")		//只查退款
	..set HISTradeNo=$p(tradeData,"^",32)
	..set HISTradeAmt=$p(tradeData,"^",23)
	..set HISTradeDate=$p(tradeData,"^",21)
	..set HISTradeTime=$p(tradeData,"^",22)
	..set TradeNo=$p(tradeData,"^",47)
	..set TradeAmt=$p(tradeData,"^",4)
	..set PlatformNo=$p(tradeData,"^",7)
	..set ExtTradeChannel=$p(tradeData,"^",46)
	..set HISType=$p(TradeData,"^",25)	;OP,IP,DEP,PRE,CARD,INSU
	..set OldHISHISTradeNo=$p(tradeData,"^",33)
	..set TradeUserId=$p(tradeData,"^",24)
	..set TradeUser=$p($g(^SSU("SSUSR",+TradeUserId)),"^",2)
	..set Papmi=$p(tradeData,"^",40)
	..set PatNo=$p($g(^PAPER(+Papmi,"PAT",1)),"^",1)
	..set PatName=$p($g(^PAPER(+Papmi,"ALL")),"^",1)
	..set itmObj=##class(DHCBILL.SelfPay.Entity.GetBillDetails.Res.RecordList).%New()
	..set itmObj.OPERATORTIME=$zdt(HISTradeDate_","_HISTradeTime,3,1)
	..set itmObj.SERIALNO=""
	..set itmObj.HISORDERNO=HISTradeNo
	..set itmObj.TRADENO=OldHISHISTradeNo
	..set itmObj.REFUNDTYPE=$case(HISType,"OP":1,"DEP":2,:"")
	..set itmObj.OPERATORMONEY=$fn(HISTradeAmt,"",2)
	..set itmObj.JYFLAG=1
	..do listObj.RecordList.Insert(itmObj)
	..do itmObj.%Close()
	set outputObj.ResultData=listObj
	
	set outputObj.ResultCode="0000"
	set outputObj.ResultMsg="成功"
	
QueryReFundOrderInfoET
	set $zt=""
    set outputObj=##class(DHCBILL.SelfPay.Entity.QueryReFundOrderInfo.Req.Response).%New()
	set outputStream=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.outputObj,"0001","程序处理错误:"_$ZERROR)
	quit outputStream
}

/// Creator:田志俊
/// CreatDate:2022-04-21
/// Desc: 查询对账数据
/// Debug: w ##class(DHCBILL.OnPay.BL.webservice).GetBills("<Request><TradeCode>6001</TradeCode><HospitalID>2</HospitalID><StartDate>2023-01-13</StartDate><EndDate></EndDate></Request>").Read()
ClassMethod GetBills(Input As %String) As %GlobalCharacterStream
{
	Set $ZT="GetBillsET"
    Set InputObj=##class(DHCBILL.SelfPay.Entity.GetBills.Request.Req).%New()
    Do InputObj.XMLNodeDeserialize(.InputObj,"Request",Input)
    Set StartDate=InputObj.StartDate
    Set EndDate=InputObj.EndDate
    Set PayMode=InputObj.PayMode
    Set TradeChannel=InputObj.TradeChannel
    Set HospitalID=InputObj.HospitalID
    Set TradeCode=InputObj.TradeCode
    If HospitalID="" Set HospitalID=$o(^CT("HOSP","0"))
 	Set OutputObj=##class(DHCBILL.SelfPay.Entity.GetBills.Respons.Res).%New()	
 	Set StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
 	Set EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	If ((StartDate="")&&(EndDate="")){
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj,"-1","日期为空")
		Quit OutputXML
	}
	Set ETPStr=""
	For BillDate=StartDate:1:EndDate  Do
	.//// 获取正常数据（查找交易明细，传所有交易明细成功记录）
	.Set ETPRowID="0"
	.For   Set ETPRowID=$o(^DHCBILLETPi(0,"TradeDate",BillDate,ETPRowID))  Quit:(ETPRowID="")  Do
	..Set ETPInfo=$g(^DHCBILLETP(ETPRowID))
	..Set ETPRc=$p(ETPInfo,"^",1) 
	..Quit:(ETPRc'="00")
	..Do GetBillSInfo(ETPRowID)
  	..;Quit:(ETPRc="00")
	.////获取单边数据（通过业务表查交易表，查询his成功，交易表失败记录）
	.;;1、门诊收费、挂号数据
	.Set PrtRowID=""
	.For  Set PrtRowID=$o(^DHCINVPRT(0,"Date",BillDate,PrtRowID))  Quit:(PrtRowID="")  Do
	..Set ETPRowID=""
	..For  Set ETPRowID=$o(^DHCBILLETPi(0,"TTypePRT","OP","PRT",PrtRowID,ETPRowID))  QUit:(ETPRowID="")  Do
	...Set ETPInfo=$g(^DHCBILLETP(ETPRowID))
	...Set ETPRc=$p(ETPInfo,"^",1) 
	...Quit:(ETPRc="00") 
	...Do GetBillSInfo(ETPRowID)
	.;;4、取门诊预交金数据
	.Set ManagerId=""
	.For  Set ManagerId=$o(^DHCACDi("AccM",0,"APDDate",BillDate,ManagerId)) Quit:ManagerId=""  Do
	..Set ManagerInfo=$g(^DHCACD("AccM",ManagerId))
	..Set Balance=$p(ManagerInfo,"^",8)
	..Quit:Balance=""
	..Set PreId=0
	..For  Set PreId=$o(^DHCACD("AccM",ManagerId,"AccPD",PreId))  Quit:PreId=""  DO
	...Set PreInfo=$g(^DHCACD("AccM",ManagerId,"AccPD",PreId))
	...Set PrtRowID=ManagerId_"||"_PreId
	...b:(PrtRowID="84140||1") ;tianzj
	...For  Set ETPRowID=$o(^DHCBILLETPi(0,"TTypePRT","PRE","PRT",PrtRowID,ETPRowID))  QUit:(ETPRowID="")  Do
	....Set ETPInfo=$g(^DHCBILLETP(ETPRowID))
	....Set ETPRc=$p(ETPInfo,"^",1) 
	....Quit:(ETPRc="00") 
	....Do GetBillSInfo(ETPRowID)
	.;;2、住院发票数据
	.Set PrtRowID=""
	.For  Set PrtRowID=$o(^DHCINVPRTZY(0,"DATE",BillDate,PrtRowID))  Quit:(PrtRowID="")  Do
	..Set ETPRowID=""
	..For  Set ETPRowID=$o(^DHCBILLETPi(0,"TTypePRT","IP","PRT",PrtRowID,ETPRowID))  QUit:(ETPRowID="")  Do
	...Set ETPInfo=$g(^DHCBILLETP(ETPRowID))
	...Set ETPRc=$p(ETPInfo,"^",1) 
	...Quit:(ETPRc="00") 
	...Do GetBillSInfo(ETPRowID)
	.;;3、住院押金数据
	.Set PrtRowID=""
	.For  Set PrtRowID=$o(^DHCSFPRINTDETAIL(0,"PrtDate",BillDate,PrtRowID))  Quit:(PrtRowID="")  Do
	..Set ETPRowID=""
	..For  Set ETPRowID=$o(^DHCBILLETPi(0,"TTypePRT","DEP","PRT",PrtRowID,ETPRowID))  QUit:(ETPRowID="")  Do
	...Set ETPInfo=$g(^DHCBILLETP(ETPRowID))
	...Set ETPRc=$p(ETPInfo,"^",1) 
	...Quit:(ETPRc="00") 
	...DO GetBillSInfo(ETPRowID)
    If (ETPStr'=""){
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj,"0","获取对账结果成功")
	}Else{
		Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj,"-4","无对账结果记录")	
	}
  	
  	Quit OutputXML
GetBillsET
	Set OutputObj=##class(DHCBILL.SelfPay.Entity.GetAdmByCardNo.Res.Response).%New()
	Set OutputXML=##class(DHCBILL.SelfPay.BLL.DHCBillCommon).ResponseMsg(.OutputObj,"-99","程序处理错误:"_$ZERROR)
	Quit OutputXML
GetBillSInfo(ETPRowID)
	Set ETPInfo=$g(^DHCBILLETP(ETPRowID))
	Set ETPRc=$p(ETPInfo,"^",1) 
 	Set ItemObj=##class(DHCBILL.OnPay.Entity.GetBills.Respons.Item).%New()	
	Set TradeType=$p(ETPInfo,"^",25)
	Set OpTypeID=""
	If TradeType="PRE" s OpTypeID="O"
	If TradeType="OP" s OpTypeID="O"
	If TradeType="DEP" s OpTypeID="I"
	If TradeType="IP" s OpTypeID="I"
	Set ExtDate=$p(ETPInfo,"^",16)   			////银行交易日期
	Set ExtDate=##class(websys.Conversions).DateLogicalToHtml(ExtDate)
	Set MchtID=$p(ETPInfo,"^",10)   			////商户号
	Set TermID=$p(ETPInfo,"^",11)   			////终端号
	Set TransNO=""   							////交易号
	Set OutTransNO=""   						////外部交易号
	Set BankCardNO=$p(ETPInfo,"^",3)   			////银行卡号
	Set PosNO=""   								////银行交易号
	Set UserID=$p(ETPInfo,"^",24)  	 			////操作员工号
	Set OperCode=$p($g(^SSU("SSUSR",UserID)),"^",1)
	Set PayTypeID=""
	Set TradeDate=$p(ETPInfo,"^",21)   		////his交易日期
	Set TradeTime=$p(ETPInfo,"^",22)   		////his交易时间
	Set TradeDate=##class(websys.Conversions).DateLogicalToHtml(TradeDate)
	Set TradeTime=##class(websys.Conversions).TimeLogicalToHtml(TradeTime,1)
	Set TotalFee=$p(ETPInfo,"^",23)   			////交易金额
	set ETPExtAmt=$p(ETPInfo,"^",4)             ////支付金额
	i ETPExtAmt'="" s TotalFee=ETPExtAmt
	Set BussType=$p(ETPInfo,"^",26)   			////交易（收费、退费）
	If (BussType="C")  Set BussType="收费"
	Else  Set BussType="退费"
	Set OutTransNoSurce=$p(ETPInfo,"^",6)
	If BussType="退费"  set TransNO=$p(ETPInfo,"^",7)   	//// 退费流水号20220510
	Set OldTradeNo=$p(ETPInfo,"^",33)  	
	If (OldTradeNo'="")  Do
	.Set OldETPRowID=$o(^DHCBILLETPi(0,"HISTradeID",OldTradeNo,""))
	.Set OutTransNoSurce=$p($g(^DHCBILLETP(OldETPRowID)),"^",6)   	////收费订单号
	Set TermianlCode=""   		////终端编号号
	Quit:('$d(^DHCBILLETP(ETPRowID,"C")))
	Set Sub=$o(^DHCBILLETP(ETPRowID,"C",""),-1)
	Set ETPSubInfo=$g(^DHCBILLETP(ETPRowID,"C",Sub))
	Set InvoiceNO=$p(ETPSubInfo,"^",1)   		////发票号
	Set InvoicePayMode=$p(ETPSubInfo,"^",3) 
	Set TradeType=$p(ETPSubInfo,"^",5)       ////交易标识取子表，因为存在押金当结算费用退费，主表存的标识不准确
	Set PayModeDr=$p(ETPInfo,"^",45)
	If PayModeDr'=""  d
	.Set PayTypeID=$p($g(^CT("CTPM",PayModeDr)),"^",1)
	.Set PayTypeName=$p($g(^CT("CTPM",PayModeDr)),"^",2)
	Set PatDr=$p(ETPInfo,"^",40)
	If (TradeType="OP")  Do
	.;Set InvType=$p(^DHCINVPRT(InvoiceNO),"^",34)
	.Set OperType="缴费"
	.;If (InvType="R") Set OperType="挂号"  			////业务类型（收费、挂号）
	.;Set PatDr=$p(^DHCINVPRT(InvoiceNO),"^",15)
	.;Set PayModeDr=$p(ETPInfo,"^",45)  ;$p(^DHCINVPRT(+InvoicePayMode,"P",$p(InvoicePayMode,"||",2)),"^",1) update by chenying 20220520
	.;if (PayModeDr="")  Do
	..;Set Sub=$o(^DHCBILLETP(ETPRowID,"C",""),-1)
	..;Set InvPayModeDr=$p(^DHCBILLETP(ETPRowID,"C",Sub),"^",3)
	..;Set PayModeDr=$p(^DHCINVPRT(+InvPayModeDr,"P",$p(InvPayModeDr,"||",2)),"^",1) 
	.;i PayModeDr'="" Set PayTypeID=$p($g(^CT("CTPM",PayModeDr)),"^",1)
	.;i PayModeDr'="" Set PayTypeName=$p($g(^CT("CTPM",PayModeDr)),"^",2)
	Else  If (TradeType="DEP")  Do
	.Set OperType="住院预交金" 
	.;Set Adm=$p($g(^DHCSFPRINTDETAIL(InvoiceNO)),"^",4)
	.;Set PatDr=$p($g(^PAADM(Adm)),"^",1)
	.;Set PayModeDr=$p(^DHCSFPRINTDETAIL(InvoiceNO),"^",9)
	.;i PayModeDr'="" Set PayTypeID=$p($g(^CT("CTPM",PayModeDr)),"^",1)
	.;i PayModeDr'="" Set PayTypeName=$p($g(^CT("CTPM",PayModeDr)),"^",2)
	Else  If (TradeType="IP")  Do
	.;Set OperType="缴费" 
	.;Set Adm=$p(^DHCINVPRTZY(InvoiceNO),"^",4)
	.;i InvoiceNO'="" Set PatDr=$p($g(^ARRCP(InvoiceNO)),"^",30) //update by chenyinng  20220519
	.;set ARRCPRowId=$p($g(InvoicePayMode),"||",1)
	.;set PAYMChildsub=$p($g(InvoicePayMode),"||",2)
	.;i ARRCPRowId'="" Set PayModeDr=$p($g(^ARRCP(ARRCPRowId,"PAYM",PAYMChildsub)),"^",1)
	.;i PayModeDr'="" Set PayTypeID=$p($g(^CT("CTPM",PayModeDr)),"^",1)
	.;i PayModeDr'="" Set PayTypeName=$p($g(^CT("CTPM",PayModeDr)),"^",2)
	Else  If (TradeType="PRE")  Do
	.Set OperType="门诊预交金" 
	.;Set PayModeDr=$p(ETPInfo,"^",45)  
	.;Set PatDr=$s(+InvoiceNO'=0:$p(^DHCACD("AccM",+InvoiceNO),"^",2),1:"")
	.;if (PayModeDr="")  Do
	..;Set Sub=$o(^DHCBILLETP(ETPRowID,"C",""),-1)
	..;Set InvPayModeDr=$p(^DHCBILLETP(ETPRowID,"C",Sub),"^",3)
	..;Set PayModeDr=$p($g(^DHCACD("AccM",+InvPayModeDr,"AccPD",$p(InvPayModeDr,"||",2),"P",$p(InvPayModeDr,"||",3))),"^",1)
	.b:(InvoiceNO="84140||1") ;t222
	quit:(PayModeDr="1")
	Set PatNo=$s(PatDr'="":$p(^PAPER(PatDr,"PAT",1),"^",1),1:"")   			////登记号
	Set PatName=$s(PatDr'="":$p(^PAPER(PatDr,"ALL"),"^",1),1:"")    			////姓名号
	Set ETPStr=1
	Set IsWin="N"
	If PayTypeID="MISPOS" s IsWin="Y"
	If PayTypeID="MISWIN" s IsWin="Y"
	If (BussType="退费")&&(IsWin="Y") Set TransNO=$p(ETPInfo,"^",6)   	//// 退费流水号20220510 窗口业务
	Set ItemObj.MchtID=MchtID
	Set ItemObj.TermID=TermID
	Set ItemObj.TransNO=TransNO
	Set ItemObj.OutTransNO=OutTransNO
	Set ItemObj.BankCardNO=BankCardNO
	Set ItemObj.PosNO=PosNO
	Set ItemObj.OperCode=OperCode
	Set ItemObj.PayTypeID=PayTypeID
	;Set ItemObj.PayTypeName=PayTypeName
	Set ItemObj.TransDate=TradeDate
	Set ItemObj.TotalFee=TotalFee
	Set ItemObj.BussType=BussType
	Set ItemObj.OutTransNoSurce=OutTransNoSurce
	Set ItemObj.TermianlCode=TermianlCode
	Set ItemObj.InvoiceNO=InvoiceNO
	Set ItemObj.PatientNO=PatNo
	Set ItemObj.PatientName=PatName
	Set ItemObj.OperType=OperType
	Set ItemObj.OpTypeID=OpTypeID
	Do OutputObj.List.Insert(ItemObj)
	Do OutputObj.%Close()
}

}
