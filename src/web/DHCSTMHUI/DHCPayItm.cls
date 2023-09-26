Import sqluser

Class web.DHCSTMHUI.DHCPayItm Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	查询付款单明细信息
/// Creator: 	tsr
/// CreatDate: 	2018-05-28
/// Table: 		DHC_PayItm
/// Input: 		付款主表RowId
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCPayItm","DHCPayItm",7)
Query DHCPayItm(Pay As %String) As Query(ROWSPEC = "RowId,Pointer,TransType,Inclb,Inci,Code,Description,Spec,Manf,Qty:%Float,UomDesc,RecAmt:%Float,PayAmt:%Float,SumPayAmt:%Float,Rp:%Float,RpAmt:%Float,Sp:%Float,SpAmt:%Float,Pp:%Float,PpAmt:%Float,DiscpDiff,DiscAmt:%Float,DiffAmt:%Float,InvNo,InvDate,InvAmt:%Float,GRNo,InsxNo,BatNo,ExpDate,OverFlag") [ SqlProc ]
{
}

ClassMethod DHCPayItmExecute(ByRef qHandle As %Binary, Pay As %String) As %Status
{
	n (qHandle,Pay)
	;s ^zx("Pay")=Pay
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	q:Pay="" $$$OK

	s Ch=0
	f  s Ch=$o(^DHCPAY(Pay,"I",Ch)) q:Ch=""  d
	.s RowId=Pay_"||"_Ch q:RowId=""
	.s Inci=$p(^DHCPAY(Pay,"I",Ch),"^",1)
	.s Pointer=$p(^DHCPAY(Pay,"I",Ch),"^",2)
	.s OverFlag=$p(^DHCPAY(Pay,"I",Ch),"^",7)
	.s TransType=$p(^DHCPAY(Pay,"I",Ch),"^",9)
	.s RecAmt=$p(^DHCPAY(Pay,"I",Ch),"^",3)		//入库金额(进价) 
	.s PayAmt=$p(^DHCPAY(Pay,"I",Ch),"^",5)		//本次付款金额
	.s SumPayAmt=$p(^DHCPAY(Pay,"I",Ch),"^",4)  //累计付款金额
	.s RecItm=""
	.i TransType="G" d
	..s RecItm=..SelRecItmInfo(Pointer)
	.e  d
	..s RecItm=..SelRetItmInfo(Pointer)
	.s BatNo=$p(RecItm,"^",1)
	.s Manf=$p(RecItm,"^",2)
	.s UomDesc=$p(RecItm,"^",3)
	.s Qty=$p(RecItm,"^",4)
	.s Pp=$p(RecItm,"^",5)
	.s Rp=$p(RecItm,"^",6)
	.s Sp=$p(RecItm,"^",7)
	.s PpAmt=$p(RecItm,"^",8)
	.s RpAmt=$p(RecItm,"^",9)
	.s SpAmt=$p(RecItm,"^",10)
	.s DiscpDiff=$p(RecItm,"^",11)
	.s DiscAmt=$p(RecItm,"^",12)
	.s DiffAmt=$p(RecItm,"^",13)
	.s InvNo=$p(RecItm,"^",14)
	.s InvDate=$p(RecItm,"^",15)
	.s GRNo=$p(RecItm,"^",16)		//业务单据号
	.s InsxNo=$p(RecItm,"^",17)		//随行单号
	.s Inclb=$p(RecItm,"^",18)
	.s ExpDate=$p(RecItm,"^",19)
	.s InvAmt=$p(RecItm,"^",20)
	.s Code=$p($G(^INCI(Inci,1)),"^",1)
	.s Description=$p($G(^INCI(Inci,1)),"^",2)
	.s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",Inci)
	.d OutPutRow

	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,Pointer,TransType,Inclb,Inci,Code,Description,Spec,Manf,Qty,UomDesc,RecAmt,PayAmt,SumPayAmt,Rp,RpAmt,Sp,SpAmt,Pp,PpAmt,DiscpDiff,DiscAmt,DiffAmt,InvNo,InvDate,InvAmt,GRNo,InsxNo,BatNo,ExpDate,OverFlag)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	查询入库明细信息
/// Creator: 	tsr
/// CreatDate: 	2018-05-28
/// Table: 		DHC_PayItm
/// Input: 		入库子表记录RowId
ClassMethod SelRecItmInfo(Ingri) As %String
{
	n (Ingri)
	q:Ingri="" ""
	s DHCINGR=$p(Ingri,"||",1) q:DHCINGR="" ""
	s DHCINGRCH=$p(Ingri,"||",2) q:DHCINGRCH="" ""
	q:'$d(^DHCINGR(DHCINGR,"GRI",DHCINGRCH)) ""
	s RecQty=$p(^DHCINGR(DHCINGR,"GRI",DHCINGRCH),"^",4)
	s Uom=+$p(^DHCINGR(DHCINGR,"GRI",DHCINGRCH),"^",10)
	s UomDesc=""
	s:Uom'="" UomDesc=$p($g(^CT("UOM",Uom)),"^",2)
	s Inclb=$p(^DHCINGR(DHCINGR,"GRI",DHCINGRCH),"^",1)
	s BatExp=##class(web.DHCSTMHUI.Common.DrugStkCommon).Bat(Inclb)
	s BatNo=$p(BatExp,"^",1),ExpDate=$p(BatExp,"^",2)
	s ManfId=$p(^DHCINGR(DHCINGR,"GRI",DHCINGRCH),"^",29)
	s Manf=""
	i ManfId'="" s Manf=$p($g(^PHMNF(ManfId)),"^",2)
	s Pp=$p(^DHCINGR(DHCINGR,"GRI",DHCINGRCH),"^",35)
	s Rp=$p(^DHCINGR(DHCINGR,"GRI",DHCINGRCH),"^",30)
	s Sp=$p(^DHCINGR(DHCINGR,"GRI",DHCINGRCH),"^",32)
	s InvNo=$p(^DHCINGR(DHCINGR,"GRI",DHCINGRCH),"^",27)
	s InvDate=$p(^DHCINGR(DHCINGR,"GRI",DHCINGRCH),"^",34)
	s:InvDate'="" InvDate=..DL2H(InvDate)
	s InvAmt=$p(^DHCINGR(DHCINGR,"GRI",DHCINGRCH),"^",26)
	s DiscpDiff=Pp-Rp
	s DiscAmt=DiscpDiff*RecQty
	s SpAmt=Sp*RecQty
	s PpAmt=Pp*RecQty
	s RpAmt=Rp*RecQty
	s DiffAmt=(Sp-Rp)*RecQty
	s IngrNo=$p($g(^DHCINGR(DHCINGR)),"^",1)
	s InsxNo=$p(^DHCINGR(DHCINGR,"GRI",DHCINGRCH),"^",38)
	s ret1=BatNo_"^"_Manf_"^"_UomDesc_"^"_RecQty_"^"_Pp
	s ret2=Rp_"^"_Sp_"^"_PpAmt_"^"_RpAmt_"^"_SpAmt
	s ret3=DiscpDiff_"^"_DiscAmt_"^"_DiffAmt_"^"_InvNo_"^"_InvDate
	s ret4=IngrNo_"^"_InsxNo_"^"_Inclb_"^"_ExpDate_"^"_InvAmt
	s ret=ret1_"^"_ret2_"^"_ret3_"^"_ret4
	q ret
}

/// Descript:	查询退货明细信息
/// Creator: 	tsr
/// CreatDate: 	2018-05-28
/// Table: 		DHC_PayItm
/// Input: 		退货子表记录RowId
ClassMethod SelRetItmInfo(Ingrti) As %String
{
	n (Ingrti)
	q:Ingrti="" ""
	s retamt=0,invono="",invodate=""
	s DHCINGRT=$p(Ingrti,"||",1)
	s DHCChild=$p(Ingrti,"||",2)
	q:'$d(^INGRT(DHCINGRT,"DHCGRR",DHCChild)) ""
	s RetNo=$p(^INGRT(DHCINGRT),"^",1)
	s RetDate=$p(^INGRT(DHCINGRT),"^",9)
	s:RetDate'="" RetDate=..DL2H(RetDate)
	s RetQty=-1*$P(^INGRT(DHCINGRT,"DHCGRR",DHCChild),"^",2)
	s RetUom=$P(^INGRT(DHCINGRT,"DHCGRR",DHCChild),"^",3)
	s RetUomDesc=""
	s:RetUom'="" RetUomDesc=$p($g(^CT("UOM",RetUom)),"^",2)
	s InvNo=$p(^INGRT(DHCINGRT,"DHCGRR",DHCChild),"^",12)
	s InvAmt=$p(^INGRT(DHCINGRT,"DHCGRR",DHCChild),"^",13)
	s InvDate=$p(^INGRT(DHCINGRT,"DHCGRR",DHCChild),"^",14)
	s:InvDate'="" InvDate=..DL2H(InvDate)
	s Rp=$p(^INGRT(DHCINGRT,"DHCGRR",DHCChild),"^",7)
	s RetAmt=-$p(^INGRT(DHCINGRT,"DHCGRR",DHCChild),"^",4)
	s Pp=$p(^INGRT(DHCINGRT,"DHCGRR",DHCChild),"^",10)
	s RetPpAmt=-$p(^INGRT(DHCINGRT,"DHCGRR",DHCChild),"^",11)
	s Sp=$p(^INGRT(DHCINGRT,"DHCGRR",DHCChild),"^",8)
	s SpAmt=-$p(^INGRT(DHCINGRT,"DHCGRR",DHCChild),"^",9)
	s Inclb=$p(^INGRT(DHCINGRT,"DHCGRR",DHCChild),"^",6)
	s DHCGRI=$p(^INGRT(DHCINGRT,"DHCGRR",DHCChild),"^",1)
	
	s BatExp=##class(web.DHCSTMHUI.Common.DrugStkCommon).Bat(Inclb)
	s BatNo=$p(BatExp,"^",1),ExpDate=$p(BatExp,"^",2)
	s ManfInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb(Inclb)
	s Manf=$p(ManfInfo,"^",2)
	
	s DiscpDiff=Pp-Rp
	s DiscAmt=RetPpAmt-RetAmt
	s DiffAmt=SpAmt-RetAmt
	s InsxNo=$P($G(^INGRT(DHCINGRT,"DHCGRR",DHCChild)),"^",18)
	s ret1=BatNo_"^"_Manf_"^"_RetUomDesc_"^"_RetQty_"^"_Pp
	s ret2=Rp_"^"_Sp_"^"_RetPpAmt_"^"_RetAmt_"^"_SpAmt
	s ret3=DiscpDiff_"^"_DiscAmt_"^"_DiffAmt_"^"_InvNo_"^"_InvDate
	s ret4=RetNo_"^"_InsxNo_"^"_Inclb_"^"_ExpDate_"^"_InvAmt
	s ret=ret1_"^"_ret2_"^"_ret3_"^"_ret4
	q ret
}

/// Descript:	保存付款单明细信息
/// Creator: 	tsr
/// CreatDate: 	2018-06-06
/// Table:		DHC_PayItm
/// Input:		付款单Id,Detail,预付比例
/// Output:     
ClassMethod Save(PayId As %String, Detail As %String, PayRatio As %String) As RtnObj
{
	n (PayId,Detail,PayRatio)
	s RtnObj=##class(RtnObj).%New()
	i PayId="" d RtnObj.Err(-1,"","付款单Id不能为空!","",0)
	q:RtnObj.success'=0 RtnObj
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Detail)
	i Sc'=0 d RtnObj.Err(-2,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	i ..sssLock(##class(web.DHCSTMHUI.DHCPay).%GetParameter("AppName")_PayId)<0 d RtnObj.Err(-99,"","加锁失败!")
	q:RtnObj.success'=0 RtnObj
	i ((PayRatio<=0)||(PayRatio>1)||(PayRatio="")) s PayRatio=1
	while(RtnObj.success=0)
	{
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s Inci=Obj.%Get("Inci")
		s RpAmt=Obj.%Get("RpAmt")
		s PayAmt=Obj.%Get("PayAmt")
		s PayAmt=PayAmt*PayRatio
		s Type=Obj.%Get("Type")
		s obj=##class(User.DHCPayItm).%New()
		d obj.PAYIPAYParrefSetObjectId(PayId)
		s ch=$O(^DHCPAY(PayId,"I",""),-1)+1
		s obj.PAYIChildsub=ch
		d obj.PAYIINCIDRSetObjectId(Inci)
		s obj.PAYIINGRIDR=RowId
		s obj.PAYIPayAmt=+PayAmt
		s obj.PAYIPayedAmt=..GetPayedAmt(RowId,Type)+PayAmt   //之前的已付款+本次付款
		s obj.PAYIRecAmt=+RpAmt
		s obj.PAYIRecType=Type
		i $zabs(obj.PAYIPayedAmt)'<$zabs(+RpAmt) s obj.PAYIOverFlag="Y"   //自动处理付清标志
		s sc=obj.%Save()
		i $$$ISERR(sc) s Sc=RtnObj.Err(-3,"","更新付款单明细信息失败!")
		q:RtnObj.success'=0
	}
	d ..sssUnLock(##class(web.DHCSTMHUI.DHCPay).%GetParameter("AppName")_PayId)
	q RtnObj
}

/// Descript:	计算已付款金额
/// Creator: 	tsr
/// CreatDate: 	2018-06-06
/// Table:		DHC_PayItm
/// Input:		业务明细Id(入库/退货),业务类型(G/R)
ClassMethod GetPayedAmt(Pointer As %String, Type As %String) As %String
{
	n (Pointer,Type)
	s PayedAmt=0
	s PayId=$o(^DHCPAY(0,"TYPEGR",Type,Pointer,""),-1)
	q:PayId="" PayedAmt
	s Ch=$o(^DHCPAY(0,"TYPEGR",Type,Pointer,PayId,""),-1)
	q:Ch="" PayedAmt 
	s PayedAmt=$p($g(^DHCPAY(PayId,"I",Ch)),"^",4)
	q PayedAmt
}

/// Descript:	删除付款单明细
/// Creator: 	tsr
/// CreatDate: 	2018-07-23
/// Table:		DHC_PayItm
/// Input:		付款单明细Id
ClassMethod Delete(PayId As %String, Params As %String) As %String
{
	n (PayId,Params)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	i ..sssLock(##class(web.DHCSTMHUI.DHCPay).%GetParameter("AppName")_PayId)<0 d RtnObj.Err(-99,"","加锁失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	i ##class(web.DHCSTMHUI.DHCPay).AllowDel(PayId)<0 d
	.d ..sssUnLock(##class(web.DHCSTMHUI.DHCPay).%GetParameter("AppName")_PayId)
	.s Sc=RtnObj.Err(-2,"","此付款单不允许删除!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	tstart
	while(RtnObj.success=0)
	{
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		&sql(delete from DHC_PayItm where %id=:RowId)
		i SQLCODE'=0 d RtnObj.Err(-3,RowId,"删除明细失败!")
	}
	i RtnObj.success'=0 tro  d ..sssUnLock(##class(web.DHCSTMHUI.DHCPay).%GetParameter("AppName")_PayId) q RtnObj.Json()
	tc
	d ..sssUnLock(##class(web.DHCSTMHUI.DHCPay).%GetParameter("AppName")_PayId)
	q RtnObj.Json()
}

}
