Import SQLUser

Class BILL.EINV.BL.COM.InvoiceCtl Extends %RegisteredObject
{

/*
ClassMethod SaveServiceResult(ObjValidBillNo As BILL.EINV.DTO.COM.ValidBillNo, InputPam As %String) As %String
{
	s retcode="-1"
	f i=1:1:ObjValidBillNo.INVBillNoList.Size  d
	.s InvType=ObjValidBillNo.INVBillNoList.GetAt(i).INVtype			;票据类型
	.i (InvType="O")||(InvType="I")||(InvType="R") d
	..s InvStart=ObjValidBillNo.INVBillNoList.GetAt(i).INVStartInv		;开始票号		
	..s InvEnd=ObjValidBillNo.INVBillNoList.GetAt(i).INVEndInv			;结束票号
	..s InvDate=+$h					;领用日期
	..s InvTime=$p($h,",",2)		;领用时间
	..s InvUsr=""					;领用人
	..s InvFinalFlag=""				;票据领用标志
	..s InvLastNum=ObjValidBillNo.INVBillNoList.GetAt(i).INVStartInv	;当前可用号码
	..s InvStatus="N"				;
	..s InvHosp=""					;院区指针
	..s cw=..invcw(InvUsr, InvType, HospDr)			;根据领取人、发票类型和院区指针获取票据可用数量
	..i cw>0 d
	...s InvFinalFlag=""       		;发票领用标志为 待用
	..e  d
	...s InvFinalFlag="Y"			;发票领用标志为 可用
	
	..s PLIST(1)=""
	..s PLIST(2)=InvStart
	..s PLIST(3)=InvEnd
	..s PLIST(4)=InvUsr
	..s PLIST(5)=InvDate
	..s PLIST(6)=InvTime
	..s PLIST(7)=InvStart
	..s PLIST(9)=InvType
	..s PLIST(10)=InvStatus
	..s PLIST(26)=InvHosp
		
	..&sql(INSERT INTO SQLUser.DHC_invoice Values :PLIST())

	..i SQLCODE=0  d
	...s retcode=0
	..e  d
	...s retcode=100

	.else  if (InvType="D")  d			;票据类型为住院押金时
	..//
	
	q retcode
}
*/
/// 功能说明：保存服务返回结果信息到发票发放表中
/// 入参说明：ObjValidBillNo --> 发票发放对象
/// 返 回 值：0 成功 其他代表失败
/// 修改履历：苏惠德  2019-09-18 新做成
/// w ##class(BILL.EINV.BL.COM.InvoiceCtl).SaveServiceResult
/// 功能说明：根据领取人、票据类型、院区指针获取发票数量
/// 			count>0  发票领用标志为 待用 , count<>0 发票领用标志为 待用 
/// Debug: w ##class(BILL.EINV.BL.COM.InvoiceCtl).invcw(10207,"I",2)
ClassMethod invcw(userid As %Integer, type As %String, HospDr As %String) As %Integer
{
	k P2
	i HospDr'="" d
	.&sql(select count(*) into :count from SQLUser.dhc_invoice where INV_Finalflag='Y' and INV_Usr=:userid and INV_type=:type and INV_hospital=:HospDr)
	e  d
	.&sql(select count(*) into :count from SQLUser.dhc_invoice where INV_Finalflag='Y' and INV_Usr=:userid and INV_type=:type and INV_hospital is null)
	s P2=count	      
	q count
}

/// 功能说明：将作废的纸质票号保存到跳号表中
/// 入参说明：InputPam --> 收费员ID^纸质票据代码^起始纸质票据号^终止纸质票据号^作废原因^作废张数^票据类型
/// 返 回 值：0 成功 其他代表失败
/// 修改履历：苏惠德  2019-09-29
/// w ##class(BILL.EINV.BL.COM.InvoiceCtl).SaveVoidInvResult("5^31103^000078^000081^发票破损^4")
ClassMethod SaveVoidInvResult(InputPam As %String) As %String
{
	//收费员ID^纸质票据代码^起始纸质票据号^终止纸质票据号^作废原因^作废张数^票据类型 
	set guser=$p(InputPam,"^",1)
	set paperCode=$p(InputPam,"^",2)
	set abortStartNo=$p(InputPam,"^",3)
	set abortEndNo=$p(InputPam,"^",4)
	set voidReason=$p(InputPam,"^",5)
	set abortNum=$p(InputPam,"^",6)
	set endInvNo=$p(InputPam,"^",4)
	set hospID=""
	set rtn=0
	quit:((abortEndNo-abortStartNo+1)'=abortNum) -4
	quit:(((abortEndNo-abortStartNo)<0)||((endInvNo-abortEndNo)<0)) -5
	
	set len=$l(endInvNo)
	for curNo=abortStartNo:1:abortEndNo  quit:(+rtn'=0)  do
	.set receiptNo=##class(web.UDHCJFBaseCommon).FormatINVNO(curNo, len)
    .kill PLIST
 	.set PLIST(2)=+$h
 	.set PLIST(3)=$p($h,",",2)
 	.set PLIST(4)=receiptNo
 	.set PLIST(6)=guser
 	.set PLIST(7)=voidReason
 	.set PLIST(11)=paperCode
 	.&SQL(INSERT INTO SQLUser.DHC_VoidInv VALUES :PLIST())
    .set rtn=SQLCODE
    ;add guoyunlong  更新发票发放表
    s InStr=guser_"^"_$p(InputPam,"^",7)
    s OutMessage=""
    ;获取当前收费员的当前可用发票的结束号以及当前可用发票的发放表ID
    s DHCInvoiceInfo=##class(BILL.EINV.BL.EInvoiceLogic).GetPaperBillNo(InStr,OutMessage)
    s endNo=$p(DHCInvoiceInfo,"^",3)
    s rowID=$p(DHCInvoiceInfo,"^",2)
    if (+endInvNo=+endNo) {        //如果是最后一张领取的发票,标记为已用完
        ///收费员ID^纸质票据代码^起始纸质票据号^终止纸质票据号^作废原因^作废张数^票据类型
		set rtn=##class(BILL.EINV.BL.EInvoiceLogic).InvToFinal(rowID, abortEndNo, $p(InputPam,"^",1), $p(InputPam,"^",7))
	}else {
		set lastNum=##class(web.UDHCAccAddDeposit).incre(abortEndNo)
		;更新发票发放表
		&SQL(UPDATE SQLUser.DHC_INVOICE SET INV_LastNum=:lastNum,INV_comment2="Y" WHERE INV_rowid=:rowID)
		set rtn=SQLCODE
	}
    
	quit rtn
}

/// 功能说明：保存服务返回结果信息到对账主表、子表中
/// 入参说明：ObjCheckData --> 对账数据对象
/// 返 回 值：0 成功 其他代表失败
/// 修改履历：guoyunlong   2019-09-29
/// w ##class(BILL.EINV.BL.COM.InvoiceCtl).SaveDLMXDataResult()
ClassMethod SaveDLMXDataResult(ObjCheckData As BILL.EINV.DTO.COM.CheckData, ObjConfig As BILL.EINV.PO.InvUpConfig) As %String
{
	s result="-1"
    s SuccNum=0  ;记录表中更新的数据
	///票据明细信息
	for i=1:1:ObjCheckData.InvBillNoList.Size  d
	.s CenterEInvInfoObj=##class(BILL.EINV.PO.CenterEInvInfo).%New()
	.s BillBatchCodeTmp=ObjCheckData.InvBillNoList.GetAt(i).billBatchCode     ;票据代码
	.s BillNoTmp=ObjCheckData.InvBillNoList.GetAt(i).billNo            ;票据号码
	.;i ($d(^BILL.EINV.PO.CenterEInvInfoI("IdxBillCodeAndNo",BillBatchCodeTmp,BillNoTmp))>0)  d 
	.i ($d(^BILL.EINV.PO.CenterEInvInfoI("IDataKey",BillBatchCodeTmp,BillNoTmp))>0)  d   ;如果改业务流水号存在，更新
    ..s id=""
    ..;s id=$o(^BILL.EINV.PO.CenterEInvInfoI("IdxBillCodeAndNo",BillBatchCodeTmp,BillNoTmp,id))
    ..s id=$o(^BILL.EINV.PO.CenterEInvInfoI("IDataKey",BillBatchCodeTmp,BillNoTmp,id))
    ..s CenterEInvInfoObj=##class(BILL.EINV.PO.CenterEInvInfo).%OpenId(id)
	.s CenterEInvInfoObj.BusDate=$zdh($e(ObjCheckData.InvBillNoList.GetAt(i).busDate,1,4)_"-"_$e(ObjCheckData.InvBillNoList.GetAt(i).busDate,5,6)_"-"_$e(ObjCheckData.InvBillNoList.GetAt(i).busDate,7,8),3)   ;业务日期
	.s CenterEInvInfoObj.BusNo=ObjCheckData.InvBillNoList.GetAt(i).busNo    ;业务流水号
	.s CenterEInvInfoObj.PlaceCode=ObjCheckData.InvBillNoList.GetAt(i).placeCode ;开票点编码
	.s CenterEInvInfoObj.BillName=ObjCheckData.InvBillNoList.GetAt(i).billName             ;票据种类名称
	.s CenterEInvInfoObj.BillBatchCode=ObjCheckData.InvBillNoList.GetAt(i).billBatchCode     ;票据代码
	.s CenterEInvInfoObj.BillNo=ObjCheckData.InvBillNoList.GetAt(i).billNo            ;票据号码
	.s CenterEInvInfoObj.Random=ObjCheckData.InvBillNoList.GetAt(i).random             ;校验码
	.s CenterEInvInfoObj.TotalAmt=ObjCheckData.InvBillNoList.GetAt(i).totalAmt           ;总金额
	.s CenterEInvInfoObj.IvcDate=$zdh($e(ObjCheckData.InvBillNoList.GetAt(i).ivcDateTime,1,4)_"-"_$e(ObjCheckData.InvBillNoList.GetAt(i).ivcDateTime,5,6)_"-"_$e(ObjCheckData.InvBillNoList.GetAt(i).ivcDateTime,7,8),3)            ;开票时间
	.s CenterEInvInfoObj.DataType=ObjCheckData.InvBillNoList.GetAt(i).dataType           ;数据类型
	.s CenterEInvInfoObj.State=ObjCheckData.InvBillNoList.GetAt(i).state              ;状态
	.s CenterEInvInfoObj.RelateBillBatchCode=ObjCheckData.InvBillNoList.GetAt(i).relateBillBatchCode   ;关联电子票据代码
	.s CenterEInvInfoObj.RelateBillNo=ObjCheckData.InvBillNoList.GetAt(i).relateBillNo         ;关联电子票据号码
    .s CenterEInvInfoObj.InvFactoryCD=ObjConfig.FactoryCode         ;开发商编码
    .s CenterEInvInfoObj.InvFactoryNM=ObjConfig.FactoryDesc         ;开发商名称
    .s sc=CenterEInvInfoObj.%Save()
    .s SuccNum=SuccNum+1
    s errNum=ObjCheckData.total-SuccNum    ;保存失败条数
    ;s result=$System.Status.IsError(sc)
    s Str="本次总共下载"_ObjCheckData.total _"条数据,保存成功"_SuccNum_"条，失败"_errNum_"条"
    ;b ;tc
	s result="0"
	q result
}

/// 功能说明：保存服务返回结果信息到对账主表、子表中
/// 入参说明：ObjCheckData --> 对账数据对象
/// 返 回 值：0 成功 其他代表失败
/// 修改履历：guoyunlong   2019-09-29
/// w ##class(BILL.EINV.BL.COM.InvoiceCtl).SaveDLDataResult()
ClassMethod SaveDLDataResult(ObjCheckData As BILL.EINV.DTO.COM.CheckData, ObjConfig As BILL.EINV.PO.InvUpConfig) As %String
{
	s retcode="-1"
	s SuccNum=""
	s BusDate=$zdh(ObjCheckData.BusDate,3)
	b ;999
	TStart
	i $d(^BILL.EINV.PO.BalanceDayI("IDataKey", ObjConfig.FactoryCode,BusDate)) d
	.s rowid=$o(^BILL.EINV.PO.BalanceDayI("IDataKey",ObjConfig.FactoryCode,BusDate,""))
	.s BalanceDayObj=##class(BILL.EINV.PO.BalanceDay).%OpenId(rowid)
	e  d
	.s BalanceDayObj=##class(BILL.EINV.PO.BalanceDay).%New()
	s BalanceDayObj.BusDate =BusDate     					;业务日期
   	s BalanceDayObj.CopyNum=ObjCheckData.CopyNum     		;总笔数
 	s BalanceDayObj.AllTotalAmt=ObjCheckData.AllTotalAmt   	;总金额
    s BalanceDayObj.AllTotalNum=ObjCheckData.AllTotalNum   	;总开票数
 	s BalanceDayObj.InvFactoryCD=ObjConfig.FactoryCode    	;开发商编码
 	s BalanceDayObj.InvFactoryNM=ObjConfig.FactoryDesc    	;;开发商名称
	s sc = BalanceDayObj.%Save()	
    if ($$$ISOK(sc)){
	   for i=1:1:ObjCheckData.InvBillNoList.Size  d
	   .s BalanceSubDayObj=##class(BILL.EINV.PO.BalanceSubDay).%New()
	   .s BillBatchCodeTmp=ObjCheckData.InvBillNoList.GetAt(i).billBatchCode
	   .s BgnNoTmp=ObjCheckData.InvBillNoList.GetAt(i).bgnNo
	   .i ($d(^BILL.EINV.PO.BalanceSubDayI("IDataKey",ObjConfig.FactoryCode,BusDate,BillBatchCodeTmp,BgnNoTmp))>0)  d 
	   ..s id=""
 	   ..s id=$o(^BILL.EINV.PO.BalanceSubDayI("IDataKey",ObjConfig.FactoryCode,BusDate,BillBatchCodeTmp,BgnNoTmp,id))
	   ..s BalanceSubDayObj=##class(BILL.EINV.PO.BalanceSubDay).%OpenId(id)
	   .s BalanceSubDayObj.BgnNo=ObjCheckData.InvBillNoList.GetAt(i).bgnNo     ;起始号码
	   .s BalanceSubDayObj.EndNo=ObjCheckData.InvBillNoList.GetAt(i).endNo      ;终止号码
	   .s BalanceSubDayObj.BillBatchCode=ObjCheckData.InvBillNoList.GetAt(i).billBatchCode ;票据代码
	   .s BalanceSubDayObj.BillName=ObjCheckData.InvBillNoList.GetAt(i).billName  ;票据种类名称
	   .s BalanceSubDayObj.CopyNum=ObjCheckData.InvBillNoList.GetAt(i).copyNum    ;票号段内总开票数
	   .s BalanceSubDayObj.TotalAmt=ObjCheckData.InvBillNoList.GetAt(i).totalAmt  ;票号段内总金额
	   .s BalanceSubDayObj.BusDate=BusDate                           ;业务日期
	   .s BalanceSubDayObj.InvFactoryCD=ObjConfig.FactoryCode                     ;开发商编码
	   .s BalanceSubDayObj.InvFactoryNM=ObjConfig.FactoryDesc                     ;开发商名称
	   .s sc=BalanceSubDayObj.%Save()
 	   .s SuccNum=SuccNum+1         ;成功条数
 	   .i ($$$ISOK(sc)) d
 	   ..s result="0"	
 	   .else  d
 	   ..s result="-1"
 	   ..;s result="-1"_"^"_"数据添加失败:"_$SYSTEM.OBJ.DisplayError(sc)	
	   ;s result="0"_"^"_"数据添加成功"_BalanceSubDayObj.%Id()
		
	}else{
		s result="-1" 
		//TROLLBACK							;回滚事务
	}
	if (result'="0"){
		TROLLBACK	;回滚事务
	}
	tc  ;提交事务
	q result
}

/// 功能描述：换开界面获取当前纸质发票号保存到DHcinvoice对象中
/// 入参    ：Str ->字符串（票据种类^开始票号^结束票号^领用人^院区） 
/// 出参    ：0-》成功  其他失败
/// debug:w ##class(BILL.EINV.BL.COM.InvoiceCtl).SaveDHcinvoice("EO^0000000555^0000000756^5^2")
ClassMethod SaveDHcinvoice(Str As %String) As %String
{
	s ObjDHCINvoice=##class(BILL.EINV.DTO.COM.DHCInvoiceInfo).%New()
	s ObjDHCINvoice.INVtype=$p(Str,"^",1)	;票据类型
	i (ObjDHCINvoice.INVtype'="") d
	.s ObjDHCINvoice.INVStartInv=$p(Str,"^",2)   ;开始票号		
	.s ObjDHCINvoice.INVEndInv=$p(Str,"^",3)	   ;结束票号
	.s ObjDHCINvoice.INVDate=+$h					;领用日期
	.s ObjDHCINvoice.INVTime=$p($h,",",2)		;领用时间
	.s ObjDHCINvoice.INVUsr=$p(Str,"^",4)					;领用人
	.s ObjDHCINvoice.INVFinalflag=""				;票据领用标志
	.s ObjDHCINvoice.INVLastNum=$p(Str,"^",2)	;当前可用号码
	.s ObjDHCINvoice.INVStatus="N"
	.s ObjDHCINvoice.INVhospital=$p(Str,"^",5)			;院区指针
	.s ObjDHCINvoice.INVBillInvCode=$p(Str,"^",6)       ;票据代码
	.;;根据发票类型和院区指针获取票据结束号段
	.s ObjValidBillNo= ##class(BILL.EINV.DTO.COM.ValidBillNo).%New()
	.s ObjValidBillNo.INVCount="1"
	.d ObjValidBillNo.INVBillNoList.Insert(ObjDHCINvoice)   ;字符串保存到发票发放对象
	.s rtn=##class(BILL.EINV.BL.COM.InvoiceCtl).SaveServiceResult(ObjValidBillNo)
	q rtn
}

/// 功能：保存发票发放表数据
/// 修改人：guoyunlong
/// 日期：2019-10-24
/// 入参：ObjValidBillNo ->博思获取纸质/电子票据返回值对象       
/// 出参：0成功  其他失败
/// debug:w ##class(BILL.EINV.BL.COM.InvoiceCtl).SaveServiceResult("")
ClassMethod SaveServiceResult(ObjValidBillNo As BILL.EINV.DTO.COM.ValidBillNo) As %String
{
	s retcode="0"
	
	
	b ;d
	ts   ;开启事务
	f i=1:1:ObjValidBillNo.INVBillNoList.Size  d
	.s INVtype=ObjValidBillNo.INVBillNoList.GetAt(i).INVtype			;票据类型
	.;add by xubaobao 2020 09 07 start ------------------------------------------------
	.s BillCode=ObjValidBillNo.INVBillNoList.GetAt(i).INVBillInvCode
	.s EndInvNo=ObjValidBillNo.INVBillNoList.GetAt(i).INVEndInv
	.s lquser=ObjValidBillNo.INVBillNoList.GetAt(i).INVUsr
	.s ExistFlg=##class(BILL.EINV.BL.COM.InvoiceCtl).CheckEndInvNoExist(lquser,BillCode,EndInvNo) 
	.q:(ExistFlg=-100)||(ExistFlg="Y")	;发放记录已经存在
	.;add by xubaobao 2020 09 07 end ------------------------------------------------
	.;s INVtype=$case(INVtype,"0401":"EO","0402":"PO","0403":"EI",:"")
	.s cw=..invcw(ObjValidBillNo.INVBillNoList.GetAt(i).INVUsr, INVtype,ObjValidBillNo.INVBillNoList.GetAt(i).INVhospital)			;根据领取人、发票类型和院区指针获取票据可用数量
	.i cw>0 d
	..s INVFinalflag=""       	;发票领用标志为 待用
	.e  d
	..s INVFinalflag="Y"			;发票领用标志为 可用
	.;;根据发票类型和院区指针获取票据结束号段
	.;如果当前发票发放表的结束小于需要保存的发票开始号段，则保存,否则不保存
	.;s DhcInvLastNo=##class(BILL.EINV.BL.COM.InvoiceCtl).GetLastInvNo(INVtype,ObjValidBillNo.INVBillNoList.GetAt(i).INVhospital)
	.s DhcInvLastNo=##class(BILL.EINV.BL.COM.InvoiceCtl).GetLastInvNoNew(INVtype,BillCode,lquser,ObjValidBillNo.INVBillNoList.GetAt(i).INVhospital)  
	.i ObjValidBillNo.INVBillNoList.GetAt(i).INVStartInv> DhcInvLastNo    d
	..b ;0
	..s PLIST(1)=""
    ..s PLIST(2)=ObjValidBillNo.INVBillNoList.GetAt(i).INVStartInv
	..s PLIST(3)=ObjValidBillNo.INVBillNoList.GetAt(i).INVEndInv
	..s PLIST(4)=ObjValidBillNo.INVBillNoList.GetAt(i).INVUsr
	..s PLIST(5)=+$h
	..s PLIST(6)=$p($h,",",2)
	..s PLIST(7)=ObjValidBillNo.INVBillNoList.GetAt(i).INVStartInv
	..s PLIST(8)=INVFinalflag
	..s PLIST(9)=INVtype
	..s PLIST(10)="N"
	..;s PLIST(17)=ObjValidBillNo.INVBillNoList.GetAt(i).INVcomment1
	..s PLIST(26)=ObjValidBillNo.INVBillNoList.GetAt(i).INVhospital
	..s PLIST(27)=ObjValidBillNo.INVBillNoList.GetAt(i).INVBillInvCode
	..;s PLIST(18)=ObjValidBillNo.INVBillNoList.GetAt(i).INVBillInvCode    ;如果有27存27，没有存18
	..&sql(INSERT INTO SQLUser.DHC_invoice Values :PLIST())
	..i SQLCODE'="0" d
	...b ;1
	...s retcode="-1"
	
	i retcode="0" d
	.tc   ;提交事务
	e  d
	.tro  ;回滚事务
	
	q retcode
}

/// 功能：根据领取人、发票类型和院区指针获取票据结束号段
/// 入参：type  ->发票类型
///       HospDr->院区指针
/// 返回值：票据结束号段
/// debug:w ##class(BILL.EINV.BL.COM.InvoiceCtl).GetLastInvNo("EO","2") 
/// 备注说明：如果院区之间公用一套发票不需要传院区指针
ClassMethod GetLastInvNo(type As %String, HospDr As %String = "") As %String
{
	s DhcInvoiceId="",INVEndInv="0"
	f  s DhcInvoiceId=$o(^DHCINVOICE(0,"TYPE",type,DhcInvoiceId)) q:DhcInvoiceId=""   d
	  .s DhcInvoiceInfo=$g(^DHCINVOICE(DhcInvoiceId)) 
	  .q:DhcInvoiceInfo=""
	  .q:(HospDr'="")&&($p(DhcInvoiceInfo,"^",26)'=HospDr)
	  .;q:(userid'="")&&($p(DhcInvoiceInfo,"^",4)'=userid) 
	  .s INVEndInv =$p(DhcInvoiceInfo,"^",2)
	  q INVEndInv
}

/// 功能：根据领取人、发票类型和院区指针获取票据结束号段
/// 入参：type  ->发票类型
///       HospDr->院区指针
/// 返回值：票据结束号段
/// debug:w ##class(BILL.EINV.BL.COM.InvoiceCtl).GetLastInvNo("EO","2") 
/// 备注说明：如果院区之间公用一套发票不需要传院区指针
ClassMethod GetLastInvNoNew(type As %String, BillCode As %String, userid As %String, HospDr As %String = "") As %String
{
	s DhcInvoiceId="",INVEndInv="0"
	f  s DhcInvoiceId=$o(^DHCINVOICE(0,"TYPE",type,DhcInvoiceId)) q:DhcInvoiceId=""   d
	.s DhcInvoiceInfo=$g(^DHCINVOICE(DhcInvoiceId)) 
	.q:DhcInvoiceInfo=""
	.s comment1=$p(DhcInvoiceInfo,"^",17)
	.q:(HospDr'="")&&($p(DhcInvoiceInfo,"^",26)'=HospDr)
	.q:(BillCode'=comment1)
	.q:(userid'="")&&($p(DhcInvoiceInfo,"^",3)'=userid) 
	.s INVEndInv =$p(DhcInvoiceInfo,"^",2)
	q INVEndInv
}

/// 功能：保存发票发放表数据
/// 修改人：guoyunlong
/// 日期：2019-10-24
/// 入参：发票发放表对象
/// 出参：0成功  其他失败
ClassMethod SaveServiceResult123(ObjDHCINvoice As BILL.EINV.DTO.COM.ValidBillNo) As %String
{
	k PLIST
    s PLIST(1)=""
    s PLIST(2)=ObjDHCINvoice.INVStartInv
	s PLIST(3)=ObjDHCINvoice.INVEndInv
	s PLIST(4)=ObjDHCINvoice.INVUsr
	s PLIST(5)=ObjDHCINvoice.INVDate
	s PLIST(6)=ObjDHCINvoice.INVTime
	s PLIST(7)=ObjDHCINvoice.INVStartInv
	s PLIST(8)=ObjDHCINvoice.INVFinalflag
	s PLIST(9)=ObjDHCINvoice.INVtype
	s PLIST(10)=ObjDHCINvoice.INVStatus
	s PLIST(20)=ObjDHCINvoice.INVhospital        ;注意这个院区指针节点
	&sql(INSERT INTO SQLUser.DHC_invoice Values :PLIST())
	q SQLCODE
}

/// 功能：根据领取人、发票代码、结束号码判断是否存在发放记录，如果存在不在自动下载
/// 入参：lquser  ->领取人
///       BillCode->票据代码
/// 		  LastInvNo->票据结束号码
/// 返回值：Y 代表存在 ; N 代表不存在
/// debug:w ##class(BILL.EINV.BL.COM.InvoiceCtl).GetLastInvNo("EO","2") 
/// 备注说明：如果院区之间公用一套发票不需要传院区指针
ClassMethod CheckEndInvNoExist(lquser As %String, BillCode As %String, EndInvNo As %String) As %String
{
	q:(lquser="")||(BillCode="")||(EndInvNo="") -100
	s ExistFlg="N"
	
	s DhcInvoiceId=""
	f  s DhcInvoiceId=$o(^DHCINVOICE(0,"USER",lquser,DhcInvoiceId)) q:(DhcInvoiceId="")!(ExistFlg="Y")   d
	.s DhcInvoiceInfo=$g(^DHCINVOICE(DhcInvoiceId)) 
	.q:DhcInvoiceInfo=""
	.s comment1=$p(DhcInvoiceInfo,"^",17)
	.s EndInv=$p(DhcInvoiceInfo,"^",2)
	.i (BillCode=comment1)&&(EndInvNo=EndInv) d
	..s ExistFlg="Y"
	
	q ExistFlg
}

/// 根据发票发放表ID更新发放表发票类型
/// xubaobao 2020 09 07
/// w ##class(BILL.EINV.BL.COM.InvoiceCtl).UpdateDHCInvoiceById("1017","PI")
ClassMethod UpdateDHCInvoiceById(DhcInvoiceId As %String, type As %String, HospDr As %String) As %String
{
	q:(DhcInvoiceId="")||(type="") -100
	q:'$d(^DHCINVOICE(DhcInvoiceId)) -101
	
	s DhcInvoiceInfo=^DHCINVOICE(DhcInvoiceId)
	s lquser=$p(DhcInvoiceInfo,"^",3)
	s INVtype=$p(DhcInvoiceInfo,"^",8)
	
	s cw=..invcw(lquser,INVtype,HospDr)			;根据领取人、发票类型和院区指针获取票据可用数量
	b ;
	i cw>0 d
	.s INVFinalflag=""       	;发票领用标志为 待用
	e  d
	.s INVFinalflag="Y"			;发票领用标志为 可用
	
	&SQL(UPDATE SQLUser.DHC_INVOICE SET INV_type=:type,INV_Finalflag=:INVFinalflag WHERE INV_rowid=:DhcInvoiceId)
	q SQLCODE
}

/// 功能：保存发票发放表数据
/// 修改人：xubaobao 
/// 日期：2020 09 07
/// 入参：ObjValidBillNo ->博思获取纸质/电子票据返回值对象       
/// 出参：0成功  其他失败
/// debug:w ##class(BILL.EINV.BL.COM.InvoiceCtl).SaveServiceResult("")
ClassMethod CheckBillNoByEndInv(EndInv, ObjValidBillNo As BILL.EINV.DTO.COM.ValidBillNo) As %String
{
	s CurBillNo=""
	
	f i=1:1:ObjValidBillNo.INVBillNoList.Size  d
	.s INVtype=ObjValidBillNo.INVBillNoList.GetAt(i).INVtype			;票据类型
	.s BillCode=ObjValidBillNo.INVBillNoList.GetAt(i).INVBillInvCode
	.s EndInvNo=ObjValidBillNo.INVBillNoList.GetAt(i).INVEndInv
	.s lquser=ObjValidBillNo.INVBillNoList.GetAt(i).INVUsr
	.q:EndInv'=EndInvNo
	.s CurBillNo=ObjValidBillNo.INVBillNoList.GetAt(i).INVStartInv
		
	q CurBillNo
}

}
