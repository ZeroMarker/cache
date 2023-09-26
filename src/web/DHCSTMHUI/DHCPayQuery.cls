Import sqluser

Class web.DHCSTMHUI.DHCPayQuery Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:   付款单采购确认
/// Creator:    wxj
/// CreateDate: 2022-10-25
/// w ##class(web.DHCSTMHUI.DHCPayQuery).jsPurConfirm("3","{""gUserId"":""6423"",""gLocId"":""163"",""gGroupId"":""277"",""gHospId"":""2"",""MENUID"":""57814""}")
ClassMethod jsPurConfirm(PayIdStr, Params) As %Library.String
{
	n (PayIdStr,Params)
	s ^tempxj=$lb(PayIdStr,Params)
	s RtnObj=##class(RtnObj).%New()
	
	s $ZT=..sssError()
	s del="^"
	s cnt=$l(PayIdStr,del)
	s ErrMsg="",Succnt=0,RowidStr=""
	f i=1:1:cnt d
	.s PayId=$p(PayIdStr,del,i)
	.s RtnObj=..PurConfirm(PayId,Params)
	.i RtnObj.success=0 d
	..s Succnt=Succnt+1
	..i RowidStr="" d
	...s RowidStr= PayId
	..e  d
	...s RowidStr=RowidStr_"^"_PayId
	.e  d
	..s msginfo=PayId_":"_RtnObj.msg
	..i ErrMsg="" d
	...s ErrMsg= msginfo
	..e  d
	...s ErrMsg=ErrMsg_"#"_msginfo
	s RtnObj.rowid=RowidStr
	s RtnObj.msg=cnt_"@"_Succnt_"@"_ErrMsg
	s RtnObj.success=0
	q RtnObj.Json()
}

/// Descript:	付款采购确认
/// Creator: 	tsr
/// CreatDate: 	2018-06-13
/// Table:		DHC_Pay
/// Input:		
ClassMethod PurConfirm(PayId As %String, Params As %String) As RtnObj
{
	n (PayId,Params)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"","入参解析失败!")
	i ((PayId="")||('$d(^DHCPAY(PayId)))) q RtnObj.Err(-2,"","请选择付款单!","",0)
	s gUserId=PJObj.%Get("gUserId")
	
	&sql(select pay_completed,pay_ack1 into :Comp,:Ack1 from DHC_Pay where %ID=:PayId)
	i SQLCODE'=0 q RtnObj.Err(-3,PayId,"此付款单不存在!","",0)
	i Comp'="Y" q RtnObj.Err(-4,PayId,"此付款单未完成!","",0)
	i Ack1="Y" q RtnObj.Err(-5,PayId,"此付款单已采购确认!","",0)
	
	s Yes="Y"
	s AckDate=+$h
	i ##class(web.DHCSTMHUI.DHCPay).Lock(PayId)<0 q RtnObj.Err(-99,PayId,"加锁失败!")
	&sql(update dhc_pay set pay_ack1=:Yes,pay_date_ack1=:AckDate,pay_ssusr_ack1=:gUserId where %ID=:PayId)
	i SQLCODE'=0 d RtnObj.Err(-6,PayId,"采购确认失败!")
	d ##class(web.DHCSTMHUI.DHCPay).uLock(PayId)
	q:RtnObj.success'=0 RtnObj
	s RtnObj.rowid=PayId
	q RtnObj
}

/// Descript:	付款会计确认
/// Creator: 	tsr
/// CreatDate: 	2018-06-13
/// Table:		DHC_Pay
/// Input:		
ClassMethod AccConfirm(Pay As %String, Params As %String) As %String
{
	n (Pay,Params)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	i Pay="" d RtnObj.Err(-2,"","付款单Id不能为空!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	s pPayDate=PJObj.%Get("PayDate")
	s pPayMode=PJObj.%Get("FPayMode")
	s pCheckNo=PJObj.%Get("CheckNo")
	s pCheckAmt=PJObj.%Get("CheckAmt")
	s gUserId=PJObj.%Get("gUserId")

	&sql(select pay_completed,pay_ack2 into :Comp,:Ack2 from dhc_pay where %ID=:Pay)
	i SQLCODE'=0 d RtnObj.Err(-3,Pay,"此付款单不存在!","",0)
	i Comp'="Y" d RtnObj.Err(-4,Pay,"此付款单未完成!","",0)
	i Ack2="Y" d RtnObj.Err(-5,Pay,"此付款单已会计确认!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	s Yes="Y"
	s AckDate=+$h
	s:pPayDate'="" pPayDate=..DH2L(pPayDate)
	i ##class(web.DHCSTMHUI.DHCPay).Lock(Pay)<0 d RtnObj.Err(-99,Pay,"加锁失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	&sql(update dhc_pay set pay_ack2=:Yes,pay_date_ack2=:AckDate,pay_ssusr_ack2=:gUserId,
		pay_mode=:pPayMode,pay_checkno=:pCheckNo,pay_checkdate=:pPayDate,pay_checkamt=:pCheckAmt
		where %ID=:Pay)
	i SQLCODE'=0 d RtnObj.Err(-6,Pay,"会计确认失败!")
	d ##class(web.DHCSTMHUI.DHCPay).uLock(Pay)
	q:RtnObj.success'=0 RtnObj.Json()
	s RtnObj.rowid=Pay
	q RtnObj.Json()
}

/// Descript:   付款单财务确认
/// Creator:    wxj
/// CreateDate: 2022-10-25
/// w ##class(web.DHCSTMHUI.DHCPayQuery).jsPurConfirm()
ClassMethod jsFinConfirm(PayIdStr, Params) As %Library.String
{
	n (PayIdStr,Params)
	s RtnObj=##class(RtnObj).%New()
	
	s $ZT=..sssError()
	s del="^"
	s cnt=$l(PayIdStr,del)
	s ErrMsg="",Succnt=0,RowidStr=""
	f i=1:1:cnt d
	.s PayId=$p(PayIdStr,del,i)
	.s RtnObj=..FinConfirm(PayId,Params)
	.i RtnObj.success=0 d
	..s Succnt=Succnt+1
	..i RowidStr="" d
	...s RowidStr= PayId
	..e  d
	...s RowidStr=RowidStr_"^"_PayId
	.e  d
	..s msginfo=PayId_":"_RtnObj.msg
	..i ErrMsg="" d
	...s ErrMsg= msginfo
	..e  d
	...s ErrMsg=ErrMsg_"#"_msginfo
	s RtnObj.rowid=RowidStr
	s RtnObj.msg=cnt_"@"_Succnt_"@"_ErrMsg
	s RtnObj.success=0
	q RtnObj.Json()
}

/// Descript:	付款财务确认
/// Creator: 	tsr
/// CreatDate: 	2018-06-13
/// Table:		DHC_Pay
/// Input:		
ClassMethod FinConfirm(PayId As %String, Params As %String) As RtnObj
{
	n (PayId,Params)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	i ((PayId="")||('$d(^DHCPAY(PayId)))) q RtnObj.Err(-2,"","请选择付款单!","",0)
	s gUserId=PJObj.%Get("gUserId")
	
  	&sql(select pay_completed,PAY_Ack11 into :Comp,:Ack3 from DHC_Pay where %ID=:PayId)
  	i SQLCODE'=0 q RtnObj.Err(-3,PayId,"此付款单不存在!","",0)
	i Comp'="Y" q RtnObj.Err(-4,PayId,"此付款单未完成!","",0)
	i Ack3="Y" q RtnObj.Err(-5,PayId,"此付款单已财务确认!","",0)
	s Yes="Y"
  	s AckDate=+$h
  	i ##class(web.DHCSTMHUI.DHCPay).Lock(PayId)<0 q RtnObj.Err(-99,PayId,"加锁失败!")
  	&sql(update dhc_pay set PAY_Ack11=:Yes,PAY_Date_Ack11=:AckDate,PAY_SSUSR_Ack11=:gUserId where %ID=:PayId)
  	i SQLCODE'=0 d RtnObj.Err(-6,PayId,"财务确认失败!")
  	d ##class(web.DHCSTMHUI.DHCPay).uLock(PayId)
  	q:RtnObj.success'=0 RtnObj
  	s RtnObj.rowid=PayId
	q RtnObj
}

}
