Import sqluser

Class web.DHCSTMHUI.DHCReimPayInv Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Description:保存报销支付单明细
/// Creator:	tsr
/// CreatDate:	2018-07-27
/// Table:		DHC_ReimPayInv,DHC_ReimPayInvItm
/// Input:		报支单Id,Detail
ClassMethod Save(RPRowId As %String, Detail As %String) As RtnObj
{
	n (RPRowId,Detail)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Detail)
	i Sc'=0 d RtnObj.Err(-1,RPRowId,"入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	while(RtnObj.success=0)
	{
		s Obj=PJObj.%Pop()
		q:Obj=""
		s Pointer=Obj.%Get("Ingri")
		s Type=Obj.%Get("Type")
		s InvNo=Obj.%Get("InvNo")
		s InvAmt=Obj.%Get("RpAmt")
		s RPIRowId=..SaveRPI(RPRowId,Pointer,Type,InvNo,InvAmt)
		i RPIRowId<0 d RtnObj.Err(-2,RPRowId,"保存报支单明细DHC_ReimPayInv失败!")
		q:RtnObj.success'=0
		s Sub=$o(^DHCREIMPAY(+RPIRowId,"I",$P(RPIRowId,"||",2),"II",""),-1)+1
    	&sql(INSERT INTO DHC_ReimPayInvItm(RPII_RPI_ParRef, RPII_ChildSub, RPII_Pointer, RPII_InvRpAmt, RPII_Type)
    		VALUES (:RPIRowId,:Sub,:Pointer,:InvAmt,:Type))
    	i SQLCODE'=0 d RtnObj.Err(-3,RPRowId,"保存报支单明细DHC_ReimPayInvItm失败!")
	}
	s RtnObj.rowid=RPIRowId
	q RtnObj
}

/// Description:保存报销支付单明细
/// Creator:	tsr
/// CreatDate:	2018-07-27
/// Table:		DHC_ReimPayInv
/// Input:		报支单Id,Detail
ClassMethod SaveRPI(RPRowId As %String, Pointer As %String, Type As %String, InvNo As %String, InvAmt As %String) As %String
{
	n (RPRowId,Pointer,Type,InvNo,InvAmt)
	s err=0
    s Sub=$o(^DHCREIMPAY(0,"InvNo",InvNo,RPRowId,""))
    i Sub="" d
    .i Type="R" d
    ..s Ingri=$P(^INGRT(+Pointer,"DHCGRR",$P(Pointer,"||",2)),"^",1)
    .e  d
    ..s Ingri=Pointer
 	.s IngrInfo=^DHCINGR(+Ingri)
 	.s Vendor=$p(IngrInfo,"^",3)
    .&sql(insert into DHC_ReimPayInv (RPI_RP_Parref,RPI_InvNo, RPI_InvRpAmt,RPI_APCVM_DR)
    	values (:RPRowId,:InvNo,:InvAmt,:Vendor))
    .i SQLCODE'=0 s err=-1
    e  d
    .s RowId=RPRowId_"||"_Sub
    .&sql(UPDATE DHC_ReimPayInv SET RPI_InvRpAmt=(RPI_InvRpAmt+:InvAmt) WHERE RPI_RowId=:RowId)
	.i SQLCODE'=0 s err=-2
	q:err'=0 err
	q %ROWID
}

/// Description:查询报销支付单明细
/// Creator:	tsr
/// CreatDate:	2018-07-27
/// Table:		DHC_ReimPayInv
/// Input:		报支单号
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCReimPayInv","DHCReimPayInv","ZYXZ001201907240001")
Query DHCReimPayInv(ReimPayNo As %String) As Query(ROWSPEC = "RowId,ReimPayNo,InvNo,InvAmt:%Float,UnPayAmt:%Float,Vendor,VendorDesc,PayAmt:%Float,LocDesc,Inci,InciCode,InciDesc") [ SqlProc ]
{
}

ClassMethod DHCReimPayInvExecute(ByRef qHandle As %Binary, ReimPayNo As %String) As %Status
{
	n (qHandle,ReimPayNo)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
 
	q:ReimPayNo="" $$$OK
 	s ReimPayNo=$$ALPHAUP^SSUTIL4(ReimPayNo)
 	
 	s SqlStr = "SELECT RPI_RowId, RPI_InvNo, RPI_InvRpAmt, RPI_UnPayRpAmt, RPI_APCVM_DR,"
 		_"RPI_APCVM_DR->Apcvm_Name As VendorDesc, RPI_RP_ParRef->RP_CTLoc_DR->CTLoc_Desc As LocDesc"
 		_" FROM DHC_ReimPayInv WHERE RPI_RP_ParRef->RP_No= '"_ReimPayNo_"' ORDER BY RPI_ChildSub DESC"
 	s result=##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(SqlStr)
	s sc=result.Execute()
	i $$$ISERR(sc) q $$$OK
	while (result.Next())
	{
        s RowId = result.Data("RPI_RowId")
        s InvNo = result.Data("RPI_InvNo")
        s InvAmt = result.Data("RPI_InvRpAmt")
        s UnPayAmt = +result.Data("RPI_UnPayRpAmt")
        s Vendor = result.Data("RPI_APCVM_DR")
        s VendorDesc = result.Data("VendorDesc")
        s LocDesc = result.Data("LocDesc")
        s PayAmt = InvAmt-UnPayAmt
        s Sub=$o(^DHCREIMPAY(+RowId,"I",$p(RowId,"||",2),"II",""))
    	s SubInfo=^DHCREIMPAY(+RowId,"I",$p(RowId,"||",2),"II",Sub)
    	s Pointer=$p(SubInfo,"^",2)
    	s Type=$p(SubInfo,"^",3)
    	i Type="R" d
    	.s Ingri=$P(^INGRT(+Pointer,"DHCGRR",$p(Pointer,"||",2)),"^",1)
    	e  d
    	.s Ingri=Pointer
    	s Inci=$P(^DHCINGR(+Ingri,"GRI",$P(Ingri,"||",2)),"^",25)
 		s InciCode=$p(^INCI(Inci,1),"^",1)
 		s InciDesc=$p(^INCI(Inci,1),"^",2)
        d OutPutRow
	}
	Quit $$$OK
OutPutRow
 s Data=$lb(RowId,ReimPayNo,InvNo,InvAmt,UnPayAmt,Vendor,VendorDesc,PayAmt,LocDesc,Inci,InciCode,InciDesc)
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

/// Description:根据发票号获取报支单号及凭证状态
/// Creator:	tsr
/// CreatDate:	2018-07-27
/// Table:		DHC_ReimPayInv
/// Input:		发票号
ClassMethod GetRPNoByInvNo(InvNo As %String) As %String
{
	n (InvNo)
	q:InvNo="" ""
	s RPNo=""
	&sql(SELECT RPI_RP_ParRef ->RP_No into :RPNo FROM DHC_ReimPayInv WHERE RPI_InvNo=:InvNo)
	q:SQLCODE'=0 ""
	q RPNo
}

/// Description:修改报支单明细信息
/// Creator:	tsr
/// CreatDate:	2018-07-30
/// Table:		DHC_ReimPayInv
/// Input:		Data-RowId,扣款金额
ClassMethod Update(Data As %String) As %String
{
	n (Data)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Data)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	ts
	while(RtnObj.success=0)
	{
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s UnPayAmt=Obj.%Get("UnPayAmt")
		s RPRowId=+RowId
		&sql(SELECT RP_Completed into :Complate FROM DHC_ReimPay WHERE RP_RowId=:RPRowId)
		i SQLCODE'=0 d RtnObj.Err(-2,RowId,"查询失败!")
		q:RtnObj.success'=0
		i Complate="Y" d RtnObj.Err(-3,RowId,"此报支单已完成,不能修改!","",0)
		q:RtnObj.success'=0
		&sql(UPDATE DHC_ReimPayInv SET RPI_UnPayRpAmt=:UnPayAmt WHERE RPI_RowId=:RowId)
		i SQLCODE'=0 d RtnObj.Err(-4,RowId,"更新失败!")
		q:RtnObj.success'=0
	}
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Description:删除报支单明细信息
/// Creator:	tsr
/// CreatDate:	2018-07-30
/// Table:		DHC_ReimPayInv
/// Input:		Data-RowId,扣款金额
ClassMethod Delete(Data As %String) As %String
{
	n (Data)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Data)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	ts
	while(RtnObj.success=0)
	{
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s RPRowId=+RowId
		s Complate=$p(^DHCREIMPAY(RPRowId),"^",5)
		i Complate="Y" d RtnObj.Err(-2,RowId,"该报支单已生成凭证,不能删除!")
		q:RtnObj.success'=0
		&sql(Delete From DHC_ReimPayInv WHERE RPI_RowId=:RowId)
		i SQLCODE'=0 d RtnObj.Err(-3,RowId,"删除失败!")
		q:RtnObj.success'=0
	}
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Description:查询报销支付单明细
/// Creator:	tsr
/// CreatDate:	2018-07-27
/// Table:		DHC_ReimPayInvItm
/// Input:		Params-报支单号
Query DHCReimPayDetail(ReimPayNo As %String) As Query(ROWSPEC = "RPRowId,RPIRowId,RPIIRowId,InvAmt:%Float,Inci,InciCode,InciDesc,ScgIncscDesc") [ SqlProc ]
{
}

ClassMethod DHCReimPayDetailExecute(ByRef qHandle As %Binary, ReimPayNo As %String) As %Status
{
	n (qHandle,ReimPayNo)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
 
	q:ReimPayNo="" $$$OK
 	s ReimPayNo=$$ALPHAUP^SSUTIL4(ReimPayNo)
 	s SqlStr = "SELECT RPII_RPI_ParRef, RPII_RPI_ParRef->RPI_RP_ParRef As RP_RowId, RPII_RowId,"
 		_"RPII_Pointer, RPII_InvRpAmt,RPII_Type "
 		_"FROM DHC_ReimPayInvItm "
 		_"WHERE RPII_RPI_ParRef->RPI_RP_ParRef->RP_No= '"_ReimPayNo_"'"
 	s result=##class(%Library.ResultSet).%New()
 	s result.RuntimeMode=0
	d result.Prepare(SqlStr)
	s sc=result.Execute()
	i $$$ISERR(sc) q $$$OK
	while (result.Next())
	{
		s RPRowId = result.Data("RP_RowId")
	    s RPIRowId = result.Data("RPII_RPI_ParRef")
        s RPIIRowId = result.Data("RPII_RowId")
        s Pointer = result.Data("RPII_Pointer")
        s Type = result.Data("RPII_Type")
        s InvAmt=result.Data("RPII_InvRpAmt")
    	i Type="R" d
    	.s Ingri=$P(^INGRT(+Pointer,"DHCGRR",$p(Pointer,"||",2)),"^",1)
    	e  d
    	.s Ingri=Pointer
    	s Inci=$P(^DHCINGR(+Ingri,"GRI",$P(Ingri,"||",2)),"^",25)
		s StkGrp=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
		s StkGrpDesc=$p(StkGrp,"^",2)
		s IncscId=$p(^INCI(Inci,2),"^",2)
		s IncscDesc=$s(IncscId'="":$p(^INC("SC",IncscId),"^",2),1:"")
 		s InciCode=$p(^INCI(Inci,1),"^",1)
 		s InciDesc=$p(^INCI(Inci,1),"^",2)
        d OutPutRPIRow

	}

 Quit $$$OK
OutPutRPIRow
 s Data=$lb(RPRowId,RPIRowId,RPIIRowId,InvAmt,Inci,InciCode,InciDesc,StkGrpDesc_"/"_IncscDesc)
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

/// Description:根据报支单号获取凭证状态
/// Creator:	tsr
/// CreatDate:	2018-07-27
/// Table:		DHC_ReimPayInv
/// Input:		发票号
ClassMethod GetCompByReimPayNo(ReimPayNo As %String) As %String
{
	n (ReimPayNo)
	q:ReimPayNo="" "N"
	s Complete=""
	&sql(SELECT RP_Completed into :Complete FROM DHC_ReimPay WHERE RP_No=:ReimPayNo)
	q:SQLCODE'=0 "N"
	q Complete
}

}
