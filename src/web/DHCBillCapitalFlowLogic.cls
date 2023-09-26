Import SQLUser

Class web.DHCBillCapitalFlowLogic Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillCapitalFlowLogic","FindTransList","2017-07-26","2017-07-26","","IP")
Query FindTransList(StDate As %String, EndDate As %String, CapType As %String, CapPayMode As %String, BorrowUser As %String, OptionType As %String, HospId As %String, LangId As %String = "") As websys.Query(ROWSPEC = "CapRowId:%String:表ID,CapAcount:%Float:转交金额,CapDate:%String:转交日期,CapTime:%String:转交时间,CapUsrName:%String:操作员,CapFlag:%String,CapFlagDisplay:%String:转交类别,CapObjUsrDR:%String:接收用户ID,CapObjUsrName:%String:接收用户,CapPayModeDesc:%String:资金类型,CapInitCapDR:%String,CapJkDR:%String:结账ID,CapComFlag:%String,OptionDesc:%String:描述,CapTypeDesc:%String:门诊/住院")
{
}

ClassMethod FindTransListExecute(ByRef qHandle As %Binary, StDate As %String, EndDate As %String, CapType As %String, CapPayMode As %String, BorrowUser As %String, OptionType As %String, HospId As %String, LangId As %String = "") As %Status
{
    set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
	
	if (LangId="")&&($d(%session)) {
		set LangId=%session.Get("LOGON.LANGID")
	}
	
	set StDate=##class(websys.Conversions).DateHtmlToLogical(StDate)
	set EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	
    if (CapType="") set CapType="IP"
    
    for Date=StDate:1:EndDate  do
    .set CapRowId=0
    .for  set CapRowId=$o(^DHCBCFi(0,"DATE",CapType,Date,CapRowId))  quit:(CapRowId="")  do
    ..set CapData=$g(^DHCBCF(CapRowId))
    ..set HospDR=$p(CapData,"^",12)
    ..quit:(HospDR'=HospId)
    ..set CapAcount=$p(CapData,"^",1)
    ..set CapAcount=$fn(CapAcount,"",2)
    ..set CapDate=$p(CapData,"^",2)
    ..set CapDate=##class(websys.Conversions).DateLogicalToHtml(CapDate)
    ..set CapTime=$p(CapData,"^",3)
    ..set CapTime=##class(websys.Conversions).TimeLogicalToHtml(CapTime)
    ..set CapUsr=$p(CapData,"^",4)
    ..set CapUsrName=$s((+CapUsr'=0):$p(^SSU("SSUSR",CapUsr),"^",2),1:"")
    ..set CapUsrName=##class(User.SSUser).GetTranByDesc("SSUSRName", CapUsrName, LangId)
    ..set CapFlag=$p(CapData,"^",5)
    ..quit:((OptionType'="")&&(OptionType'=CapFlag))
    ..set CapFlagDisplay=$case(CapFlag,"OUT":"借出","IN":"借入",:"未定义")
    ..set CapFlagDisplay=##class(websys.Translation).Get("", CapFlagDisplay, LangId)
    ..set CapObjUsrDR=$p(CapData,"^",6)
	..quit:((BorrowUser'="")&&(BorrowUser'=CapObjUsrDR))
    ..set CapObjUsrName=$s((+CapObjUsrDR'=0):$p(^SSU("SSUSR",CapObjUsrDR),"^",2),1:"")
    ..set CapObjUsrName=##class(User.SSUser).GetTranByDesc("SSUSRName", CapObjUsrName, LangId)
    ..set CapPayModeDR=$p(CapData,"^",7)
    ..quit:((CapPayMode'="")&&(CapPayMode'=CapPayModeDR))
    ..set CapPayModeDesc=$s((+CapPayModeDR'=0):$p($g(^CT("CTPM",CapPayModeDR)),"^",2),1:"")
    ..set CapPayModeDesc=##class(User.CTPayMode).GetTranByDesc("CTPMDesc", CapPayModeDesc, LangId)
    ..set CapInitCapDR=$p(CapData,"^",8)
	..set CapJkDR=$p(CapData,"^",9)
	..set CapTypeDesc=$case(CapType,"I":"住院","O":"门诊",:CapType)
	..set CapTypeDesc=##class(websys.Translation).Get("", CapTypeDesc, LangId)
	..set NewCapRowid=$o(^DHCBCFi(0,"INITCAPDR",CapRowId,""))
	..//判断借出记录是否已经确认
	..set CapComFlag=$s(((CapFlag="OUT")&&(NewCapRowid="")):"N",1:"Y")
	..//判断描述
	..set OptionDesc=##class(websys.Translation).Get("", "该笔金额由", LangId)
	..if ((CapFlag="OUT")&&(NewCapRowid="")) set OptionDesc=OptionDesc_"["_CapUsrName_"]"_##class(websys.Translation).Get("", "借出", LangId)_"，"_"["_CapObjUsrName_"]"_##class(websys.Translation).Get("", "尚未确认接收", LangId)
	..else  if ((CapFlag="OUT")&&(NewCapRowid'="")) set OptionDesc=OptionDesc_"["_CapUsrName_"]"_##class(websys.Translation).Get("", "借出", LangId)_"，"_"["_CapObjUsrName_"]"_##class(websys.Translation).Get("", "已确认接收", LangId)
	..else  if (CapFlag="IN") set OptionDesc=OptionDesc_"["_CapObjUsrName_"]"_##class(websys.Translation).Get("", "借出", LangId)_"，"_"["_CapUsrName_"]"_##class(websys.Translation).Get("", "确认接收", LangId)
	..else  set OptionDesc=OptionDesc_"["_CapObjUsrName_"]"_##class(websys.Translation).Get("", "借出", LangId)_"，"_"["_CapUsrName_"]"_##class(websys.Translation).Get("", "确认接收", LangId)
	..do OutputRowList
	
	quit $$$OK

OutputRowList
	set Data=$lb(CapRowId,CapAcount,CapDate,CapTime,CapUsrName,CapFlag,CapFlagDisplay,CapObjUsrDR,CapObjUsrName,CapPayModeDesc,CapInitCapDR,CapJkDR,CapComFlag,OptionDesc,CapTypeDesc)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// 插入表 DHC_CapitalFlow
/// Debug: w ##class(web.DHCBillCapitalFlowLogic).InsertCapitalFlow("10207^10208^OUT^1000.00^1^I")
ClassMethod InsertCapitalFlow(InsertInfo)
{
	new (InsertInfo)
	set ^TMP("InsertCapitalFlow")=InsertInfo
	set CapAcount=$p(InsertInfo,"^",4)
	set CapUsr=$p(InsertInfo,"^",1)
	set CapFlag=$p(InsertInfo,"^",3)
	set CapObjUsr=$p(InsertInfo,"^",2)
	set PayMode=$p(InsertInfo,"^",5)
	set CapType=$p(InsertInfo,"^",6)
	set HospId=$p(InsertInfo,"^",7)
	kill PLIST
	set PLIST(2)=CapAcount
	set PLIST(5)=CapUsr
	set PLIST(6)=CapFlag
	set PLIST(7)=CapObjUsr
	set PLIST(8)=PayMode
	set PLIST(11)="N"        ;Cap_Handin
	set PLIST(12)=CapType    ;OP门诊 IP 住院
	set PLIST(13)=HospId     ;OP门诊 IP 住院
	ts
	&SQL(INSERT INTO DHC_BillCapitalFlow VALUES PLIST())
	set rtn=SQLCODE
	if (+rtn)  tro  quit rtn_"^"_$g(%msg)
	if ($tl>0) tc
	quit rtn
}

ClassMethod DeleteCapitalFlow(CapRowId, UserId)
{
	new (CapRowId, UserId)
	quit:(CapRowId="") -1_"^"_"参数错误"
	set CapFlag=$p(^DHCBCF(CapRowId),"^",5)
	set NewCapRowid=$o(^DHCBCFi(0,"INITCAPDR",CapRowId,""))
	quit:((CapFlag="OUT")&&(NewCapRowid'="")) -1_"^"_"已经确认接收不能删除"
	
	kill PLIST
	&sql(SELECT * INTO PLIST() FROM DHC_BillCapitalFlow WHERE Cap_RowId = :CapRowId) 	
	quit:(SQLCODE'=0) SQLCODE
	
	set OldCapUsr=PLIST(5)
	quit:(UserId'=OldCapUsr) -1_"^"_"非原操作员，不能删除"
	
	set CapJkDR=PLIST(10)
	quit:(CapJkDR'="") -1_"^"_"已结账，不能删除"
	
	ts
	&SQL(DELETE FROM DHC_BillCapitalFlow WHERE Cap_RowId = :CapRowId)
	set rtn=SQLCODE
	if (+rtn)  tro  quit rtn_"^"_$g(%msg)
	if ($tl>0) tc
	quit rtn
}

/// Debug: w ##class(web.DHCBillCapitalFlowLogic).ComfirmCapitalFlow(45,516)
ClassMethod ComfirmCapitalFlow(CapRowId As %String, UserId As %String, LangId As %String = "") As %String
{
	new (CapRowId, UserId, LangId)
	if (LangId="")&&($d(%session)) {
		set LangId=%session.Get("LOGON.LANGID")
	}
	quit:(CapRowId="") -1_"^"_"参数错误"
	set CapFlag=$p(^DHCBCF(CapRowId),"^",5)
	set NewCapRowid=$o(^DHCBCFi(0,"INITCAPDR",CapRowId,""))
	quit:(CapFlag="IN")||((CapFlag="OUT")&&(NewCapRowid'="")) -1_"^"_"已经确认接收不能再接收"
	kill PLIST
	&SQL(SELECT * INTO PLIST() FROM DHC_BillCapitalFlow WHERE Cap_RowId = :CapRowId)
	set rtn=SQLCODE
	if (+rtn)  tro  quit rtn_"^"_$g(%msg)
	
	set OldCapUsr=PLIST(5)
	set OldCapObjUsr=PLIST(7)
	set OldUsrName=$p(^SSU("SSUSR",OldCapObjUsr),"^",2)
	set OldUsrName=##class(User.SSUser).GetTranByDesc("SSUSRName", OldUsrName, LangId)
	quit:(UserId'=OldCapObjUsr) -1_"^"_##class(websys.Translation).Get("dhcbill.capitalflow.csp", "该数据需由", LangId)_"["_OldUsrName_"]"_##class(websys.Translation).Get("dhcbill.capitalflow.csp", "确认", LangId)_"，"_##class(websys.Translation).Get("dhcbill.capitalflow.csp", "请重新选择", LangId)
	kill PLIST(1)
	set PLIST(3)=+$h
	set PLIST(4)=$p($h,",",2)
	set PLIST(5)=UserId
	set PLIST(6)="IN"
	set PLIST(7)=OldCapUsr
	set PLIST(9)=CapRowId
	set PLIST(10)=""
	set PLIST(11)="N"
	ts
	&SQL(INSERT INTO DHC_BillCapitalFlow VALUES PLIST())
	set rtn=SQLCODE
	if (+rtn)  tro  quit rtn_"^"_$g(%msg)
	if ($tl>0) tc
	
	quit rtn
}

/// CreatDate: 20170706
/// Creator: yq
/// Description: 判断操作员是否存在未接收的资金交转记录
/// Output: Y 存在需要本人处理的资金交转记录数据 N 不存在
/// Table：DHC_BillCapitalFlow 表数据
/// Debug：w ##class(web.DHCBillCapitalFlowLogic).JudgeNotReceiveFlag("IP","2017-07-06","","2017-07-06","",59)
ClassMethod JudgeNotReceiveFlag(CapType, StDate, STime, EndDate, EndTime, HandUser, HospId)
{
	new (CapType, StDate, STime, EndDate, EndTime, HandUser, HospId)
	
	set StDate=##class(websys.Conversions).DateHtmlToLogical(StDate)
	set EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	set STime=##class(websys.Conversions).TimeHtmlToLogical(STime)
	set EndTime=##class(websys.Conversions).TimeHtmlToLogical(EndTime)
	
	set rtn="N"
	for CapDate=StDate:1:EndDate do
	.set CapRowId=0
	.for  set CapRowId=$o(^DHCBCFi(0,"DATE",CapType,CapDate,CapRowId)) quit:((CapRowId="")||(rtn="Y"))  do
	..set CapData=$g(^DHCBCF(CapRowId))
	..set HospDR=$p(CapData,"^",12)
	..quit:(HospId'=HospDR)
	..set CapUsr=$p(CapData,"^",4)     //转交人
	..set CapObjUsr=$p(CapData,"^",6)  //确认接收人员
	..quit:((HandUser'=CapUsr)&&(HandUser'=CapObjUsr))
	..set CapJkDR=$p(CapData,"^",9)
	..quit:(CapJkDR'="")
	..set VoidDate=$p(CapData,"^",2)
	..set VoidTime=$p(CapData,"^",3)
	..quit:((EndTime'="")&&(VoidDate=EndDate)&&(VoidTime>EndTime))
	..set CapFlag=$p(CapData,"^",5)
	..quit:(CapFlag="IN") //过滤本人已接收的
	..set NewCapRowid=$o(^DHCBCFi(0,"INITCAPDR",CapRowId,""))
	..if ((CapFlag="OUT")&&(NewCapRowid="")) set rtn="Y"
	
	quit rtn
}

/// CreatDate:20170706
/// Creator:yq
/// Description:收费员日结算时结算操作员资金交转列表
/// Table：DHC_BillCapitalFlow 表数据
/// Debug：w ##class(web.DHCBillCapitalFlowLogic).HandCapitalFlow()
ClassMethod HandCapitalFlow(CapType, StDate, STime, EndDate, EndTime, HandUser, HISParref, HospId)
{
	new (CapType, StDate, STime, EndDate, EndTime, HandUser, HISParref, HospId)
	set StDate=##class(websys.Conversions).DateHtmlToLogical(StDate)
	set EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	set STime=##class(websys.Conversions).TimeHtmlToLogical(STime)
	set EndTime=##class(websys.Conversions).TimeHtmlToLogical(EndTime)
	
	ts
	
	set rtn=0
	for CapDate=StDate:1:EndDate {
		set CapRowId=0
		while($o(^DHCBCFi(0,"DATE",CapType,CapDate,CapRowId))) {
			set CapRowId=$o(^DHCBCFi(0,"DATE",CapType,CapDate,CapRowId))
			set HospDR=$p(^DHCBCF(CapRowId),"^",12)
			continue:(HospId'=HospDR)
			set CapUsr=$p(^DHCBCF(CapRowId),"^",4)
			continue:(HandUser'=CapUsr)
			set CapJkDR=$p(^DHCBCF(CapRowId),"^",9)
			continue:(CapJkDR'="")
			set VoidDate=$p(^DHCBCF(CapRowId),"^",2)
			set VoidTime=$p(^DHCBCF(CapRowId),"^",3)
			continue:((EndTime'="")&&(VoidDate=EndDate)&&(VoidTime>EndTime))
			&SQL(
				UPDATE DHC_BillCapitalFlow
				SET Cap_Reports_DR = :HISParref, Cap_Handin = 'Y'
				WHERE Cap_RowId = :CapRowId
			)
			set rtn=SQLCODE
			if (+rtn) {
				set rtn=rtn_"^"_$g(%msg)
				quit
			}
		}
	}
	
	if (+rtn)  tro  quit rtn
	if ($tl>0) tc
	
	quit rtn
}

/// CreatDate:20170706
/// Creator:yq
/// Description:返回操作员当天转出转入金额
/// Output:OutCapAcount_"^"_InCapAcount :转出金额^转入金额
/// Table：DHC_BillCapitalFlow 表数据
/// Debug：w ##class(web.DHCBillCapitalFlowLogic).GetCapitalFlowInfo("IP","","","","",62,"4158")
ClassMethod GetCapitalFlowInfo(CapType, StDate, STime, EndDate, EndTime, HandUser, HISParref, HospId)
{
	new (CapType, StDate, STime, EndDate, EndTime, HandUser, HISParref, HospId)
	set StDate=##class(websys.Conversions).DateHtmlToLogical(StDate)
	set EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	set STime=##class(websys.Conversions).TimeHtmlToLogical(STime)
	set EndTime=##class(websys.Conversions).TimeHtmlToLogical(EndTime)
	
	set (OutCapAcount, InCapAcount)=""

	if (HISParref'=""){
		set CapRowId=0
		for  set CapRowId=$o(^DHCBCFi(0,"RepDR",CapType,HISParref,CapRowId))  quit:(CapRowId="")  do
		.set CapData=$g(^DHCBCF(CapRowId))
		.set HospDR=$p(CapData,"^",12)
		.quit:(HospId'=HospDR)
		.set CapAcount=$p(CapData,"^",1)
		.set CapFlag=$p(CapData,"^",5)
		.if (CapFlag="OUT") do
		..set OutCapAcount=$i(OutCapAcount, CapAcount)
		.else  set InCapAcount=$i(InCapAcount, CapAcount)
	}else{
		for CapDate=StDate:1:EndDate do
		.set CapRowId=0
		.for  set CapRowId=$o(^DHCBCFi(0,"DATE",CapType,CapDate,CapRowId)) quit:(CapRowId="")  do
		..set CapData=$g(^DHCBCF(CapRowId))
		..set HospDR=$p(CapData,"^",12)
		..quit:(HospId'=HospDR)
		..set CapUsr=$p(CapData,"^",4) ;转交人
		..quit:(HandUser'=CapUsr)
		..set CapJkDR=$p(CapData,"^",9)
		..quit:(CapJkDR'="")
		..set VoidDate=$p(CapData,"^",2)
		..set VoidTime=$p(CapData,"^",3)
		..quit:((EndTime'="")&&(VoidDate=EndDate)&&(VoidTime>EndTime))
		..set CapAcount=$p(CapData,"^",1)
		..set CapFlag=$p(CapData,"^",5)
		..if (CapFlag="OUT") set OutCapAcount=$i(OutCapAcount, CapAcount)
		..else  set InCapAcount=$i(InCapAcount, CapAcount)
	}
	
	quit OutCapAcount_"^"_InCapAcount
}

}
