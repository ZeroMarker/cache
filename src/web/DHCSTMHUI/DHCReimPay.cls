Import sqluser

Class web.DHCSTMHUI.DHCReimPay Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTMDHCREIMPAY";

/// Description:检查科室发票号生成报支单状态
/// Creator:	tsr
/// CreatDate:	2018-07-27
/// Table:		DHC_INGdRecItm,DHC_INGRTITM
/// Input:		科室Id,发票号
/// Return:		
ClassMethod CheckLocInv(LocId As %String, InvNo As %String) As %String
{
	 n (LocId,InvNo)
	 q:LocId="" 0
	 q:InvNo="" 0
	 s InvNo=$$ALPHAUP^SSUTIL4(InvNo)
	 s err=0
	 s RowId="",count=0
	 f  s RowId=$o(^DHCINGR(0,"INVNO",InvNo,RowId)) q:(RowId="")!(err'=0)  d
	 .q:'$d(^DHCINGR(RowId))
	 .s IngrInfo=^DHCINGR(RowId)
	 .s IngrLocId=$p(IngrInfo,"^",13)
	 .q:LocId'=IngrLocId
	 .s Audit=$p(IngrInfo,"^",29)
	 .i Audit'="Y"  s err=-1
	 .q:err'=0
	 .s Type="G"
	 .s Sub=0
	 .f  s Sub=$o(^DHCINGR(0,"INVNO",InvNo,RowId,Sub)) q:(Sub="")  d
	 ..q:..CheckPointer(RowId_"||"_Sub,Type)'=""
	 ..s count=count+1
	 s RowId="" 
	 f  s RowId=$o(^INGRT(0,"INVNO",InvNo,RowId)) q:(RowId="")!(err'=0)  d
	 .q:'$d(^INGRT(RowId))
	 .s Ingrtinfo=^INGRT(RowId)
	 .s IngrtLocId=$p(Ingrtinfo,"^",7)
	 .q:(LocId'=IngrtLocId)
	 .s Audit=$p(Ingrtinfo,"^",15)
	 .i Audit'="Y"  s err=-1
	 .q:err'=0
	 .s Type="R"
	 .s Sub=0
	 .f  s Sub=$o(^INGRT(0,"INVNO",InvNo,RowId,Sub)) q:Sub=""  d
	 ..q:..CheckPointer(RowId_"||"_Sub,Type)'=""
	 ..s count=count+1
	 i count=0  s err=-2
	 q err
}

/// Description:检查入库退货单是否加入报支单
/// Creator:	tsr
/// CreatDate:	2018-07-27
/// Table:		DHC_ReimPay
/// Input:		入库退货明细Id,类型
ClassMethod CheckPointer(Pointer, Type)
{
	n (Pointer,Type)
	s RPRowId=$o(^DHCREIMPAY(0,"Pointer",Pointer,Type,""))
	q RPRowId
}

/// Description:查询入库退货单明细信息
/// Creator:	tsr
/// CreatDate:	2018-07-27
/// Table:		DHC_INGdRecItm,DHC_INGRTITM
/// Input:		Params-科室Id,发票号
Query DHCING(Params As %String) As Query(ROWSPEC = "RowId,Ingri,GRNo,Type,Inci,InciCode,InciDesc,InvNo,RpAmt:%Float,VendorDesc,CreateDate,AuditDate") [ SqlProc ]
{
}

ClassMethod DHCINGExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
 
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s IngrLoc=PJObj.%Get("IngrLoc")
	s InvNo=PJObj.%Get("InvNo")
	q:IngrLoc="" $$$OK
	q:InvNo="" $$$OK
	s InvNo=$$ALPHAUP^SSUTIL4(InvNo)

	s RowId=""
	f  s RowId=$o(^DHCINGR(0,"INVNO",InvNo,RowId)) q:RowId=""  d
	.q:'$d(^DHCINGR(RowId))
	.s IngrInfo=^DHCINGR(RowId)
	.s LocId=$p(IngrInfo,"^",13)
	.q:LocId'=IngrLoc
	.s Audit=$p(IngrInfo,"^",29)
	.q:Audit'="Y"
	.s Type="G"
	.s Vendor=$p(IngrInfo,"^",3)
	.s VendorDesc=$s(Vendor'="":$p(^APC("APCVM",Vendor),"^",3),1:"")
	.s GRNo=$p(IngrInfo,"^",1)
	.s CreateDate=$p(IngrInfo,"^",14)
	.s:CreateDate'="" CreateDate=..DL2H(CreateDate)
	.s AuditDate=$p(IngrInfo,"^",4)
	.s:AuditDate'="" AuditDate=..DL2H(AuditDate)
	.s Sub=0
	.f  s Sub=$o(^DHCINGR(0,"INVNO",InvNo,RowId,Sub)) q:Sub=""  d
	..q:..CheckPointer(RowId_"||"_Sub,Type)'=""
	..s RpAmt=$p(^DHCINGR(RowId,"GRI",Sub),"^",26)
	..s Inci=$p(^DHCINGR(RowId,"GRI",Sub),"^",25)
	..s InciCode=$p(^INCI(Inci,1),"^",1)
	..s InciDesc=$p(^INCI(Inci,1),"^",2)
	..d OutPutRow
	s RowId="" 
	f  s RowId=$o(^INGRT(0,"INVNO",InvNo,RowId)) q:RowId=""  d
	.q:'$d(^INGRT(RowId))
	.s Ingrtinfo=^INGRT(RowId)
	.s Type="R"
	.s LocId=$p(Ingrtinfo,"^",7)
	.q:(LocId'=IngrLoc)
	.s Audit=$p(Ingrtinfo,"^",15)
	.q:(Audit'="Y")
	.s Vendor=$p(Ingrtinfo,"^",2)
	.s VendorDesc=$s(Vendor'="":$p(^APC("APCVM",Vendor),"^",3),1:"")
	.s GRNo=$p(Ingrtinfo,"^",1)
	.s CreateDate=$p(Ingrtinfo,"^",3)
	.s:CreateDate'="" CreateDate=..DL2H(CreateDate)
	.s AuditDate=$p(Ingrtinfo,"^",9)
	.s:AuditDate'="" AuditDate=..DL2H(AuditDate)
	.s Sub=0
	.f  s Sub=$o(^INGRT(0,"INVNO",InvNo,RowId,Sub)) q:Sub=""  d
	..q:..CheckPointer(RowId_"||"_Sub,Type)'=""
	..s Ingri=$p(^INGRT(RowId,"DHCGRR",Sub),"^",1)
	..s RpAmt=-$p(^INGRT(RowId,"DHCGRR",Sub),"^",13)
	..s Inci=$P(^DHCINGR(+Ingri,"GRI",$p(Ingri,"||",2)),"^",25)
	..s InciCode=$p(^INCI(Inci,1),"^",1)
	..s InciDesc=$p(^INCI(Inci,1),"^",2)
	..d OutPutRow

	Quit $$$OK
OutPutRow
 s Data=$lb(Type_"||"_RowId_"||"_Sub,RowId_"||"_Sub,GRNo,Type,Inci,InciCode,InciDesc,InvNo,RpAmt,VendorDesc,CreateDate,AuditDate)
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

/// Description:保存报销支付单
/// Creator:	tsr
/// CreatDate:	2018-07-27
/// Table:		DHC_ReimPay,DHC_ReimPayInvItm
/// Input:		
ClassMethod Save(Main As %String, Detail As %String) As %String
{
	n (Main,Detail)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Main)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	s LocId=PJObj.%Get("gLocId")
	s UserId=PJObj.%Get("gUserId")
	s ReimPayNo=PJObj.%Get("ReimPayNo")

	s RowId=$s(ReimPayNo'="":$o(^DHCREIMPAY(0,"No",ReimPayNo,"")),1:"")
	s Complate=""
	i RowId'="" d
	.&sql(SELECT RP_Completed into :Complate FROM DHC_ReimPay WHERE RP_RowId=:RowId)
	.i SQLCODE'=0 d RtnObj.Err(-2,RowId,"查询失败"_SQLCODE)
	.i Complate="Y" d RtnObj.Err(-3,RowId,"该报支单已生成凭证,不能添加!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	
	ts
	s RtnObj=..Update(RowId,Main)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	s RPRowId=RtnObj.rowid
	s RtnObj=##class(web.DHCSTMHUI.DHCReimPayInv).Save(RPRowId,Detail)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	s RtnObj.rowid=RPRowId
	q RtnObj.Json()
}

/// Description:保存报销支付单主信息
/// Creator:	tsr
/// CreatDate:	2018-07-27
/// Table:		DHC_ReimPay
ClassMethod Update(RowId As %String, Main As %String) As RtnObj
{
	n (RowId,Main)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Main)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	s LocId=PJObj.%Get("gLocId")
	s UserId=PJObj.%Get("gUserId")

	s Date=+$H
	s Time=$p($H,",",2)
	
	s AppName=..%GetParameter("AppName")
	i ..sssLock(AppName)'=0 q RtnObj.Err(-1,RowId,"锁定失败!")
	
	i RowId="" d
	.s ReimPayNo=##class(web.DHCSTMHUI.Common.AppCommon).GetAppNo(AppName,"",LocId)
	.i (ReimPayNo<0)||(ReimPayNo="")  d
	..d ..sssUnLock(AppName)
	..d RtnObj.Err(-2,RowId,"生成报支单号失败!")
	.q:RtnObj.success'=0
	.s obj=##class(User.DHCReimPay).%New()
	.s obj.RPNo=ReimPayNo
	.d obj.RPCTLocDRSetObjectId(LocId)
	.s obj.RPCreateDate=Date
	.s obj.RPCreateTime=Time
	.d obj.RPCreateUserSetObjectId(UserId)
	e  d
  	.s obj=##class(User.DHCReimPay).%OpenId(RowId)
  	i RtnObj.success'=0 d ..sssUnLock(AppName) q RtnObj
	s sc=obj.%Save()
	i $$$ISERR(sc) q RtnObj.Err(-3,"","报支单保存失败:"_sc)
	d ..sssUnLock(AppName)
	s RtnObj.rowid=obj.%Id()
	q RtnObj
}

/// Description:获取报支单信息
/// Creator:	tsr
/// CreatDate:	2018-08-01
/// Table:		DHC_ReimPay
/// Input:		报支单Id
ClassMethod Select(RowId As %String) As %String
{
	n (RowId)
	s Result=""
 	&sql(SELECT RP_No, RP_CreateDate, RP_CreateTime, RP_CTLoc_DR, RP_Completed,
 		RP_CreateUser, RP_AduitDate, RP_AduitTime, RP_Aduit, RP_AduitUser, RP_AcctVoucherNo
 		into 
 		RPNo, CreateDate, CreateTime, LocId, Completed,
 		CreateUser, AduitDate, AduitTime, Aduit, AduitUser, AcctVoucherNo
 		FROM DHC_ReimPay WHERE RP_RowId=:RowId)
 	q:SQLCODE'=0 Result
 	s:CreateDate'="" CreateDate=..DL2H(CreateDate)
	s:CreateTime'="" CreateTime=..TL2H(CreateTime)
	s UserName=""
	s:CreateUser'="" UserName=$p($G(^SSU("SSUSR",CreateUser)),"^",2)
 	s:AduitDate'="" AduitDate=..DL2H(AduitDate)
	s:AduitTime'="" AduitTime=..TL2H(AduitTime)
	s:AduitUser'="" AduitUser=$p($G(^SSU("SSUSR",AduitUser)),"^",2)
	s LocDesc=""
	s:LocId'="" LocDesc=$p(^CTLOC(LocId),"^",2)
	s Data=RPNo_"^"_CreateDate_"^"_CreateTime_"^"_LocDesc_"^"_CreateUser
		_"^"_UserName_"^"_Completed_"^"_AduitDate_"^"_AduitTime_"^"_AduitUser
		_"^"_Aduit
	s Title="ReimPayNo^CreateDate^CreateTime^LocDesc^CreateUser"
		_"^UserName^Completed^AduitDate^AduitTime^AduitUser"
		_"^Aduit"
	s Result=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	q Result
}

/// Description:生成凭证
/// Creator:	tsr
/// CreatDate:	2018-07-30
/// Table:		DHC_ReimPay
/// Input:		Params-报支单号,用户Id
ClassMethod AcctVoucherNo(Params As %String) As %String
{
	n (Params)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	s ReimPayNo=PJObj.%Get("ReimPayNo")
	i ReimPayNo="" d RtnObj.Err(-2,"","报支单号不能为空!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
    s RowId=$o(^DHCREIMPAY(0,"No",ReimPayNo,0))
	i RowId="" d RtnObj.Err(-3,"","无此报支单,请重新查询!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	s Complate=$p(^DHCREIMPAY(RowId),"^",5)
	i Complate="Y" d RtnObj.Err(-4,RowId,"该报支单已生成凭证!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	s UserId=PJObj.%Get("gUserId")
	s Num=$i(^DHCSTMDHCREIMPAY)
	s Date=+$H
    s Time=$p($H,",",2)
    s Completed="Y"
	&sql(UPDATE DHC_ReimPay SET 
		RP_AcctVoucherNo=:Num,RP_AduitDate=:Date,RP_AduitTime=:Time,RP_AduitUser=:UserId,RP_Completed=:Completed
		WHERE RP_RowId=:RowId)
	i SQLCODE'=0 d RtnObj.Err(-5,RowId,"生成凭证失败!")
	q RtnObj.Json()
}

/// Description:查询报支单信息
/// Creator:	tsr
/// CreatDate:	2018-07-30
/// Table:		DHC_ReimPay
/// Input:		Params-报支单号,用户Id
Query DHCReimPay(ReimPayNo As %String) As Query(ROWSPEC = "RowId,No,CreateDate,LocDesc,Completed,AcctVoucherNo,UserName,AuditUser,AuditDate,AuditTime") [ SqlProc ]
{
}

ClassMethod DHCReimPayExecute(ByRef qHandle As %Binary, ReimPayNo As %String) As %Status
{
	n (qHandle,ReimPayNo)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
 
	q:ReimPayNo="" $$$OK
	s ReimPayNo=$$ALPHAUP^SSUTIL4(ReimPayNo)
 	s SqlStr = "SELECT RP_RowId, RP_No, RP_CreateDate, RP_CreateTime, RP_Completed,"
 		_"RP_CTLoc_DR->CTLoc_Desc AS LocDesc, RP_AcctVoucherNo, RP_CreateUser->SSUsr_Name As UserName,"
 		_"RP_AduitUser->SSUsr_Name As AuditUserName, RP_AduitDate, RP_AduitTime FROM DHC_ReimPay "
 		_"WHERE RP_No= '"_ReimPayNo_"'"
 	s result=##class(%Library.ResultSet).%New()
 	s result.RuntimeMode=0
	d result.Prepare(SqlStr)
	s sc=result.Execute()
	i $$$ISERR(sc) q $$$OK
	while (result.Next())
	{
		s RowId = result.Data("RP_RowId")
        s No = result.Data("RP_No")
        s CreateDate = result.Data("RP_CreateDate")
        s LocDesc=result.Data("LocDesc")
		s Completed= result.Data("RP_Completed")
		s AcctVoucherNo= result.Data("RP_AcctVoucherNo")
		s UserName= result.Data("UserName")
		s AuditUser=result.Data("AuditUserName")
		s AuditDate=result.Data("RP_AduitDate")
		s AuditTime=result.Data("RP_AduitTime")
		s AuditDate=..DL2H(AuditDate)
		s AuditTime=..TL2H(AuditTime)
		d OutPutRPRow
	}

 Quit $$$OK
OutPutRPRow
 s Data=$lb(RowId,No,CreateDate,LocDesc,Completed,AcctVoucherNo,UserName,AuditUser,AuditDate,AuditTime)
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

}
