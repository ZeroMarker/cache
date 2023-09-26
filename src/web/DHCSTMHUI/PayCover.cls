Import sqluser

Class web.DHCSTMHUI.PayCover Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTMRECCOVERM";

/// Descript:	查询付款封面信息
/// Creator: 	tsr
/// CreatDate: 	2018-06-24
/// Table: 		DHC_INGdRec_Cover
/// Input: 		Params对象
Query DHCPayCover(Params As %String) As Query(ROWSPEC = "RowId,CoverNo,pIngrLoc,LocDesc,CreateUser,CreateDate,CreateTime,Month,VoucherCount:%Float,RpAmt:%Float,SpAmt:%Float") [ SqlProc ]
{
}

ClassMethod DHCPayCoverExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s StartDate=PJObj.%Get("StartDate")
	s EndDate=PJObj.%Get("EndDate")
	s pIngrLoc=PJObj.%Get("IngrLoc")
	s pPayUser=PJObj.%Get("PayUser")
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	q:pIngrLoc="" $$$OK
	s StartDate=..DH2L(StartDate)
	s EndDate=..DH2L(EndDate)
    s LocDesc=$p(^CTLOC(pIngrLoc),"^",2)
	s LocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(LocDesc)
	
    s SqlStr ="select CVR_RowId as CoverId, CVR_No as CoverNo, "_
             "CVR_Date as CreateDate, CVR_Time as CreateTime, CVR_SSUSR_DR as UserId, "_
             "CVR_SSUSR_DR->SSUSR_NAME AS CreateUser, CVR_Month as Month, CVR_VoucherCount as VoucherCount, "_
             "CVR_RpAmt as RpAmt, CVR_SpAmt as SpAmt from DHC_INGdRec_Cover "_
             "where (CVR_Date between "_StartDate_" and "_EndDate_" ) and CVR_CTLOC_DR="_pIngrLoc
    s result=##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(SqlStr)
	s sc=result.Execute()
	i $$$ISERR(sc) q $$$OK
	while (result.Next())
	{
	    s RowId = result.Data("CoverId")
	    s CoverNo = result.Data("CoverNo")
	    s CreateDate = result.Data("CreateDate")
		s:CreateDate'="" CreateDate=..DL2H(CreateDate)
	    s CreateTime = result.Data("CreateTime")
		s:CreateTime'="" CreateTime=..TL2H(CreateTime)
	    s UserId = result.Data("UserId")
	    CONTINUE:(pPayUser'="")&&(pPayUser'=UserId)
	    s CreateUser = result.Data("CreateUser")
	    s Month = result.Data("Month")
	    s VoucherCount = result.Data("VoucherCount")
	    s RpAmt = result.Data("RpAmt")
	    s SpAmt = result.Data("SpAmt")
		d OutPutPayCoverRow 
	}     
	d result.Close()
	Quit $$$OK
OutPutPayCoverRow
	s Data=$lb(RowId,CoverNo,pIngrLoc,LocDesc,CreateUser,CreateDate,CreateTime,Month,VoucherCount,RpAmt,SpAmt)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	查找待做封面的单据
/// Creator: 	tsr
/// CreatDate: 	2018-06-24
/// Table: 		dhc_ingdrecitm,dhc_ingrtitm
/// Input: 		Params对象
Query RecListQuery(Params As %String) As Query(ROWSPEC = "RowId,GRNo,Vendor,VendorDesc,CreateDate,CreateTime,CreateUser,AuditDate,AuditTime,AuditUser,RpAmt:%Float,SpAmt:%Float,Type,Scg,ScgDesc,ReqLocDesc,Qty:%Float") [ SqlProc ]
{
}

ClassMethod RecListQueryExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s StartDate=PJObj.%Get("StartDate")
	s EndDate=PJObj.%Get("EndDate")
	s pIngrLoc=PJObj.%Get("IngrLoc")
	s pInvNo=PJObj.%Get("InvNo")
	s pHvFlag=PJObj.%Get("HvFlag")
	s pVendor=PJObj.%Get("Vendor")
	s pInvFlag=PJObj.%Get("InvFlag")
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	q:pIngrLoc="" $$$OK
	s StartDate=..DH2L(StartDate)
	s EndDate=..DH2L(EndDate)
	
	s StkType=..sssCode()
	//检索入库数据
	s SqlStr="select ingri_ingr_parref Ingr,"
	s SqlStr=SqlStr_"ingri_ingr_parref->ingr_no GRNo,"
	s SqlStr=SqlStr_"ingri_ingr_parref->ingr_apcvm_dr Vendor,"
	s SqlStr=SqlStr_"ingri_ingr_parref->ingr_apcvm_dr->apcvm_name VendorDesc,"
	s SqlStr=SqlStr_"ingri_ingr_parref->ingr_createdate CreateDate,"
	s SqlStr=SqlStr_"ingri_ingr_parref->ingr_createtime CreateTime,"
	s SqlStr=SqlStr_"ingri_ingr_parref->ingr_createuser->ssusr_name CreateUser,"
	s SqlStr=SqlStr_"ingri_ingr_parref->ingr_date AuditDate,"
	s SqlStr=SqlStr_"ingri_ingr_parref->ingr_time AuditTime,"
	s SqlStr=SqlStr_"ingri_ingr_parref->ingr_ssusr_dr->ssusr_name AuditUser,"
	s SqlStr=SqlStr_"initm_invno InvNo,"
	s SqlStr=SqlStr_"initm_INCI_DR Inci,"
	s SqlStr=SqlStr_"ingri_ingr_parref->INGR_ReqLoc_Dr ReqLoc,"
	s SqlStr=SqlStr_"ingri_ingr_parref->INGR_ReqLoc_Dr->CTLOC_Desc ReqLocDesc,"
	s SqlStr=SqlStr_"ingri_ingr_parref->INGR_DO_No CoverId,"
	s SqlStr=SqlStr_"ingri_ingr_parref->INGR_SCG_DR Scg"
	s SqlStr=SqlStr_" From dhc_ingdrecitm"
	s SqlStr=SqlStr_" where ingri_ingr_parref->ingr_date between "_StartDate_" and "_EndDate
	s SqlStr=SqlStr_" and ingri_ingr_parref->ingr_loc_dr="_pIngrLoc
	s SqlStr=SqlStr_" and ingri_ingr_parref->INGR_StkType='"_StkType_"'"
	i pVendor'="" d
	.s SqlStr=SqlStr_" and ingri_ingr_parref->ingr_apcvm_dr="_pVendor 
	s xrs=##class(%Library.ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(SqlStr)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{
		s Ingr=xrs.Data("Ingr")
		continue:$d(XAmt(Ingr))
		s CoverId=xrs.Data("CoverId")
		continue:+CoverId>0
		s InvNo=xrs.Data("InvNo")
		s Inci=xrs.Data("Inci")
		s Hvflag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
		continue:(pHvFlag'="")&&(pHvFlag'=Hvflag)
		continue:(pInvNo'="")&&(pInvNo'=InvNo)
		continue:(pInvFlag="Y")&&(InvNo="")
		continue:(pInvFlag="N")&&(InvNo'="")
		s ReqLocDesc=xrs.Data("ReqLocDesc")
		s ReqLocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(ReqLocDesc)
		s Type="G"
		s GRNo=xrs.Data("GRNo")
		s Vendor=xrs.Data("Vendor")
		s VendorDesc=xrs.Data("VendorDesc")
		s CreateDate=xrs.Data("CreateDate")
		s CreateTime=xrs.Data("CreateTime")
		s CreateUser=xrs.Data("CreateUser")
		s:CreateDate'="" CreateDate=..DL2H(CreateDate)
		s:CreateTime'="" CreateTime=..TL2H(CreateTime)
		s AuditDate=xrs.Data("AuditDate")
		s AuditTime=xrs.Data("AuditTime")
		s:AuditDate'="" AuditDate=..DL2H(AuditDate)
		s:AuditTime'="" AuditTime=..TL2H(AuditTime)
		s AuditUser=xrs.Data("AuditUser")
		s Scg=xrs.Data("Scg")
		s ScgDesc=$s(Scg'="":$p(^DHCSCG(Scg),"^",2),1:"")
		s GRAmt=##class(web.DHCSTMHUI.DHCINGdRecInv).GetGRAmt(Ingr,Type)
		s RpAmt=$p(GRAmt,"^",1)
		s SpAmt=$p(GRAmt,"^",2)
		s Qty=$p(GRAmt,"^",3)
		s XAmt(Ingr)=RpAmt_"^"_SpAmt_"^"_Qty
		d OutPutRow
	}
	d xrs.Close()
	k XAmt
	
	//检索退货数据
	s SqlStr="select ingrti_ingrt_parref Ingr,"
	s SqlStr=SqlStr_"ingrti_ingrt_parref->ingrt_no GRNo,"
	s SqlStr=SqlStr_"ingrti_ingrt_parref->ingrt_apcvm_dr Vendor,"
	s SqlStr=SqlStr_"ingrti_ingrt_parref->ingrt_apcvm_dr->apcvm_name VendorDesc,"
	s SqlStr=SqlStr_"ingrti_ingrt_parref->ingrt_date CreateDate,"
	s SqlStr=SqlStr_"ingrti_ingrt_parref->ingrt_time CreateTime,"
	s SqlStr=SqlStr_"ingrti_ingrt_parref->ingrt_ssusr_dr->ssusr_name CreateUser,"
	s SqlStr=SqlStr_"ingrti_ingrt_parref->ingrt_auditdate AuditDate ,"
	s SqlStr=SqlStr_"ingrti_ingrt_parref->ingrt_audittime AuditTime,"
	s SqlStr=SqlStr_"ingrti_ingrt_parref->INGRT_SSUSR_Audit_DR->ssusr_name AuditUser,"
	s SqlStr=SqlStr_"ingrti_invno InvNo,"
	s SqlStr=SqlStr_"INGRTI_INGRI_DR->initm_INCI_DR Inci,"
	s SqlStr=SqlStr_"INGRTI_INGRI_DR->ingri_ingr_parref->INGR_ReqLoc_Dr ReqLoc,"
	s SqlStr=SqlStr_"INGRTI_INGRI_DR->ingri_ingr_parref->INGR_ReqLoc_Dr->CTLOC_Desc ReqLocDesc,"
	s SqlStr=SqlStr_"ingrti_ingrt_parref->INGRT_CoverId CoverId,"
	s SqlStr=SqlStr_"ingrti_ingrt_parref->INGRT_SCG_DR Scg"
	s SqlStr=SqlStr_" From dhc_ingrtitm"
	s SqlStr=SqlStr_" where ingrti_ingrt_parref->ingrt_auditdate between  "_StartDate_" and "_EndDate
	s SqlStr=SqlStr_" and ingrti_ingrt_parref->ingrt_ctloc_Dr= "_pIngrLoc
	s SqlStr=SqlStr_" and ingrti_ingrt_parref->INGRT_StkType= '"_StkType_"'"
	i pVendor'="" d
	.s SqlStr=SqlStr_" and ingrti_ingrt_parref->ingrt_apcvm_dr="_pVendor
	s xrs=##class(%Library.ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(SqlStr)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{
		s Ingr=xrs.Data("Ingr")
		continue:$d(XAmt(Ingr))
		s CoverId=xrs.Data("CoverId")
		continue:+CoverId>0
		s InvNo=xrs.Data("InvNo")
		s Inci=xrs.Data("Inci")
		s Hvflag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
		continue:(pHvFlag'="")&&(pHvFlag'=Hvflag)
		continue:(pInvNo'="")&&(pInvNo'=InvNo)
		continue:(pInvFlag="Y")&&(InvNo="")
		continue:(pInvFlag="N")&&(InvNo'="")
		s ReqLocDesc=xrs.Data("ReqLocDesc")
		s ReqLocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(ReqLocDesc)
		s Type="R"
		s GRNo=xrs.Data("GRNo")
		s Vendor=xrs.Data("Vendor")
		s VendorDesc=xrs.Data("VendorDesc")
		s CreateDate=xrs.Data("CreateDate")
		s CreateTime=xrs.Data("CreateTime")
		s CreateUser=xrs.Data("CreateUser")
		s:CreateDate'="" CreateDate=..DL2H(CreateDate)
		s:CreateTime'="" CreateTime=..TL2H(CreateTime)
		s AuditDate=xrs.Data("AuditDate")
		s AuditTime=xrs.Data("AuditTime")
		s:AuditDate'="" AuditDate=..DL2H(AuditDate)
		s:AuditTime'="" AuditTime=..TL2H(AuditTime)
		s AuditUser=xrs.Data("AuditUser")
		s Scg=xrs.Data("Scg")
		s ScgDesc=$s(Scg'="":$p(^DHCSCG(Scg),"^",2),1:"")
		s GRAmt=##class(web.DHCSTMHUI.DHCINGdRecInv).GetGRAmt(Ingr,Type)
		s RpAmt=-$p(GRAmt,"^",1)
		s SpAmt=-$p(GRAmt,"^",2)
		s Qty=$p(GRAmt,"^",3)
		s XAmt(Ingr)=RpAmt_"^"_SpAmt_"^"_Qty
		d OutPutRow
	} 
 	d xrs.Close()
	Quit $$$OK
OutPutRow
	s Data=$lb(Ingr,GRNo,Vendor,VendorDesc,CreateDate,CreateTime,CreateUser,AuditDate,AuditTime,AuditUser,RpAmt,SpAmt,Type,Scg,ScgDesc,ReqLocDesc,Qty)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	保存付款封面
/// Creator: 	tsr
/// CreatDate: 	2018-06-24
/// Table: 		DHC_INGdRec_Cover
/// Input: 		Params对象
ClassMethod Save(Main As %String, Detail As %String) As %String
{
	n (Main,Detail)
	s RtnObj=##class(RtnObj).%New()
    s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Main)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	s gUserId=PJObj.%Get("gUserId")
	s gLocId=PJObj.%Get("gLocId")
	s pIngrLoc=PJObj.%Get("IngrLoc")
	s Sc=PJObj.%FromJSON(Detail)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-2,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	s TotalRpAmt=0,TotalSpAmt=0,VoucherCount=0,Month=""
	k ^TMPRECRET("RECRET")
	
	tstart
    s $ZT=..sssError()
    s pid=..NewPid()
	while(RtnObj.success=0)
	{
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s Type=Obj.%Get("Type")
		s VoucherCount=VoucherCount+1
		i Type="G"
		{
			s Ch=0
			f  s Ch=$o(^DHCINGR(RowId,"GRI",Ch)) q:Ch=""  d
			.s Inci="",RpAmt=0,SpAmt=0
			.s Inci=$p(^DHCINGR(RowId,"GRI",Ch),"^",25)
			.s RpAmt=$p(^DHCINGR(RowId,"GRI",Ch),"^",31)
			.s SpAmt=$p(^DHCINGR(RowId,"GRI",Ch),"^",50)
			.s Date=$p(^DHCINGR(RowId),"^",14)
			.s:Date'="" Date=..DL2H(Date)
			.s Month=$p(Date,"-",1,2)
			.s TotalRpAmt=TotalRpAmt+RpAmt
			.s TotalSpAmt=TotalSpAmt+SpAmt
			.s StkCat=$s(Inci'="":$p(^INCI(Inci,2),"^",2),1:"")
			.q:StkCat=""
			.i $d(^TMPRECRET("RECRET",pid,StkCat)) d
			..s $p(^TMPRECRET("RECRET",pid,StkCat),"^",2)=$p(^TMPRECRET("RECRET",pid,StkCat),"^",2)+RpAmt
			..s $p(^TMPRECRET("RECRET",pid,StkCat),"^",3)=$p(^TMPRECRET("RECRET",pid,StkCat),"^",3)+SpAmt
			.e  d
			..s ^TMPRECRET("RECRET",pid,StkCat)=StkCat_"^"_RpAmt_"^"_SpAmt
		}
		i Type="R"
		{
			s Ch=0
			f  s Ch=$o(^INGRT(RowId,"DHCGRR",Ch)) q:Ch=""  d
			.s Inci="",RpAmt=0,SpAmt=0,Ingri=""
			.s Ingri=$p(^INGRT(RowId,"DHCGRR",Ch),"^",1)
			.s Inci=$p(^DHCINGR(+Ingri,"GRI",$p(Ingri,"||",2)),"^",25)
			.s RpAmt=$p(^INGRT(RowId,"DHCGRR",Ch),"^",4)
			.s SpAmt=$p(^INGRT(RowId,"DHCGRR",Ch),"^",9)
			.s RpAmt=RpAmt*(-1)
			.s SpAmt=SpAmt*(-1)
			.s Date=$p(^INGRT(RowId),"^",3)
			.s:Date'="" Date=..DL2H(Date)
			.s Month=$p(Date,"-",1,2)
			.s TotalRpAmt=TotalRpAmt+RpAmt
			.s TotalSpAmt=TotalSpAmt+SpAmt
			.s StkCat=$s(Inci'="":$p(^INCI(Inci,2),"^",2),1:"")
			.q:StkCat=""
			.i $d(^TMPRECRET("RECRET",pid,StkCat)) d
			..s $p(^TMPRECRET("RECRET",pid,StkCat),"^",2)=$p(^TMPRECRET("RECRET",pid,StkCat),"^",2)+RpAmt
			..s $p(^TMPRECRET("RECRET",pid,StkCat),"^",3)=$p(^TMPRECRET("RECRET",pid,StkCat),"^",3)+SpAmt
			.e  d
			..s ^TMPRECRET("RECRET",pid,StkCat)=StkCat_"^"_RpAmt_"^"_SpAmt
		}
	}
	//生成付款封面主表
	s AppName=..%GetParameter("AppName") 
	s PayCoverNo=##class(web.DHCSTMHUI.Common.AppCommon).GetAppNo(AppName,"",gLocId)
	s CreateDate=+$h
	s CreateTime=$p($h,",",2)
	&sql(insert into DHC_INGdRec_Cover(CVR_No,CVR_CTLOC_DR,CVR_Date,CVR_Time,CVR_SSUSR_DR,
		CVR_Month,CVR_VoucherCount,CVR_RpAmt,CVR_SpAmt) values (:PayCoverNo,:pIngrLoc,:CreateDate,
		:CreateTime,:gUserId,:Month,:VoucherCount,:TotalRpAmt,:TotalSpAmt))    
	i SQLCODE'=0 d RtnObj.Err(-3,"","生成付款封面主表失败,SQLOCDE:"_SQLCODE)
	i RtnObj.success'=0 tro  k ^TMPRECRET("RECRET",pid) q RtnObj.Json()
	s CvrId=$p($g(%ROWID),$c(1))
	
	//生成付款封面明细
	s sub=0
	f  s sub=$o(^TMPRECRET("RECRET",pid,sub)) q:((sub="")||(RtnObj.success'=0))  d
	.s Data=^TMPRECRET("RECRET",pid,sub)
	.s Ret=##class(web.DHCSTMHUI.PayCoverItm).InsertCoverItm(CvrId,Data)
	.i Ret'=0 d RtnObj.Err(-4,"","生成付款封面明细失败!")
	i RtnObj.success'=0 tro  k ^TMPRECRET("RECRET",pid) q RtnObj.Json()
	
	//处理入库退货单
	d PJObj.%FromJSON(Detail)
	while(RtnObj.success=0)
	{
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s Type=Obj.%Get("Type")
		i Type="G"
		{
			&sql(update DHC_INGdRec set INGR_DO_No=:CvrId where INGR_RowId=:RowId)
			i SQLCODE'=0 d RtnObj.Err(-5,"","更新入库单失败,SQLOCDE:"_SQLCODE)
		}
		i Type="R"
		{
			&sql(update DHC_INGDRET set INGRT_CoverId=:CvrId where INGRT_RowId=:RowId)
			i SQLCODE'=0 d RtnObj.Err(-6,"","更新退货单失败,SQLOCDE:"_SQLCODE)
		}
	}
	k ^TMPRECRET("RECRET",pid)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	s RtnObj.rowid=CvrId
	q RtnObj.Json()
}

/// Descript:	修改付款封面
/// Creator: 	tsr
/// CreatDate: 	2018-07-06
/// Table: 		DHC_INGdRec_Cover
ClassMethod Update(Main As %String, Detail As %String) As %String
{
	n (Main,Detail)
	s ^tsr("Update")=$lb(Main,Detail)
	s RtnObj=##class(RtnObj).%New()
    s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Main)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	s gUserId=PJObj.%Get("gUserId")
	s gLocId=PJObj.%Get("gLocId")
	s CvrId=PJObj.%Get("RowId")
	i CvrId="" d RtnObj.Err(-2,"","付款封面Id为空!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	s Sc=PJObj.%FromJSON(Detail)
	i Sc'=0 d RtnObj.Err(-3,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	s LocId=$p(^DHCINGRCover(CvrId),"^",2)
	i gLocId'=LocId d RtnObj.Err(-4,"","科室不匹配!","",0)
	s VoucherCount=$p(^DHCINGRCover(CvrId),"^",7)
	s TotalRpAmt=$p(^DHCINGRCover(CvrId),"^",8)
	s TotalSpAmt=$p(^DHCINGRCover(CvrId),"^",9)

	k ^TMPRECRET("RECRET")
	
	tstart
    s $ZT=..sssError()
    s pid=..NewPid()
	s sub=0
	f  s sub=$o(^DHCINGRCover(CvrId,"I",sub)) q:sub=""  d
	.s StkCat=$p(^DHCINGRCover(CvrId,"I",sub),"^",1)
	.s RpAmt=$p(^DHCINGRCover(CvrId,"I",sub),"^",2)
	.s SpAmt=$p(^DHCINGRCover(CvrId,"I",sub),"^",3)
	.s ^TMPRECRET("RECRET",pid,StkCat)=StkCat_"^"_RpAmt_"^"_SpAmt

	while(RtnObj.success=0)
	{
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s Type=Obj.%Get("Type")
		s VoucherCount=VoucherCount+1
		i Type="G"
		{
			s Ch=0
			f  s Ch=$o(^DHCINGR(RowId,"GRI",Ch)) q:Ch=""  d
			.s Inci="",RpAmt=0,SpAmt=0
			.s Inci=$p(^DHCINGR(RowId,"GRI",Ch),"^",25)
			.s RpAmt=$p(^DHCINGR(RowId,"GRI",Ch),"^",31)
			.s SpAmt=$p(^DHCINGR(RowId,"GRI",Ch),"^",50)
			.s TotalRpAmt=TotalRpAmt+RpAmt
			.s TotalSpAmt=TotalSpAmt+SpAmt
			.s StkCat=$s(Inci'="":$p(^INCI(Inci,2),"^",2),1:"")
			.q:StkCat=""
			.i $d(^TMPRECRET("RECRET",pid,StkCat)) d
			..s $p(^TMPRECRET("RECRET",pid,StkCat),"^",2)=$p(^TMPRECRET("RECRET",pid,StkCat),"^",2)+RpAmt
			..s $p(^TMPRECRET("RECRET",pid,StkCat),"^",3)=$p(^TMPRECRET("RECRET",pid,StkCat),"^",3)+SpAmt
			.e  d
			..s ^TMPRECRET("RECRET",pid,StkCat)=StkCat_"^"_RpAmt_"^"_SpAmt
		}
		i Type="R"
		{
			s Ch=0
			f  s Ch=$o(^INGRT(RowId,"DHCGRR",Ch)) q:Ch=""  d
			.s Inci="",RpAmt=0,SpAmt=0,Ingri=""
			.s Ingri=$p(^INGRT(RowId,"DHCGRR",Ch),"^",1)
			.s Inci=$p(^DHCINGR(+Ingri,"GRI",$p(Ingri,"||",2)),"^",25)
			.s RpAmt=$p(^INGRT(RowId,"DHCGRR",Ch),"^",4)
			.s SpAmt=$p(^INGRT(RowId,"DHCGRR",Ch),"^",9)
			.s RpAmt=RpAmt*(-1)
			.s SpAmt=SpAmt*(-1)
			.s TotalRpAmt=TotalRpAmt+RpAmt
			.s TotalSpAmt=TotalSpAmt+SpAmt
			.s StkCat=$s(Inci'="":$p(^INCI(Inci,2),"^",2),1:"")
			.q:StkCat=""
			.i $d(^TMPRECRET("RECRET",pid,StkCat)) d
			..s $p(^TMPRECRET("RECRET",pid,StkCat),"^",2)=$p(^TMPRECRET("RECRET",pid,StkCat),"^",2)+RpAmt
			..s $p(^TMPRECRET("RECRET",pid,StkCat),"^",3)=$p(^TMPRECRET("RECRET",pid,StkCat),"^",3)+SpAmt
			.e  d
			..s ^TMPRECRET("RECRET",pid,StkCat)=StkCat_"^"_RpAmt_"^"_SpAmt
		}
	}
	//修改付款封面主表
	&sql(update DHC_INGdRec_Cover set CVR_VoucherCount=:VoucherCount,CVR_RpAmt=:TotalRpAmt,CVR_SpAmt=:TotalSpAmt
		where CVR_RowId=:CvrId)    
	i SQLCODE'=0 d RtnObj.Err(-5,"","更新付款封面主表失败,SQLOCDE:"_SQLCODE)
	i RtnObj.success'=0 tro  k ^TMPRECRET("RECRET",pid) q RtnObj.Json()
	s CvrId=$p($g(%ROWID),$c(1))

	//生成付款封面明细
	s sub=0
	f  s sub=$o(^TMPRECRET("RECRET",pid,sub)) q:((sub="")||(RtnObj.success'=0))  d
	.s Data=^TMPRECRET("RECRET",pid,sub)
	.s StkCat=$p(Data,"^",1)
	.s CvrItm=""
	.&sql(select CVRI_RowId into :CvrItm from DHC_INGdRec_CoverItm where CVRI_Parref=:CvrId and CVRI_StkCat_DR=:StkCat)
	.i CvrItm="" d
	..s ret=##class(web.DHCSTMHUI.PayCoverItm).InsertCoverItm(CvrId,Data)
	.e  d
	..s ret=##class(web.DHCSTMHUI.PayCoverItm).UpdateCoverItm(CvrItm,Data)
	.i ret'=0 d RtnObj.Err(-6,"","更新付款封面明细失败!")
	i RtnObj.success'=0 tro  k ^TMPRECRET("RECRET",pid) q RtnObj.Json()
 	
 	//处理入库退货单
	d PJObj.%FromJSON(Detail)
	while(RtnObj.success=0)
	{
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s Type=Obj.%Get("Type")
		i Type="G"
		{
			&sql(update DHC_INGdRec set INGR_DO_No=:CvrId where INGR_RowId=:RowId)
			i SQLCODE'=0 d RtnObj.Err(-7,"","更新入库单失败,SQLOCDE:"_SQLCODE)
		}
		i Type="R"
		{
			&sql(update DHC_INGDRET set INGRT_CoverId=:CvrId where INGRT_RowId=:RowId)
			i SQLCODE'=0 d RtnObj.Err(-8,"","更新退货单失败,SQLOCDE:"_SQLCODE)
		}
	}
	k ^TMPRECRET("RECRET",pid)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	s RtnObj.rowid=CvrId
	q RtnObj.Json()
}

/// Descript:	删除付款封面
/// Creator: 	tsr
/// CreatDate: 	2018-07-05
/// Table: 		DHC_INGdRec_Cover
/// Input: 		Params对象
ClassMethod Delete(Params) As %Library.String
{
	n (Params)
	s RtnObj=##class(RtnObj).%New()
    s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	
	tstart
    s $ZT=..sssError()
	while(RtnObj.success=0)
	{
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s Ret=..CheckRec(RowId)
		i +Ret>0 d
		.&sql(update DHC_INGdRec set INGR_DO_No=null where INGR_DO_No=:RowId)
		.i SQLCODE'=0 d RtnObj.Err(-2,"","更新入库单失败,SQLOCDE:"_SQLCODE)
		q:RtnObj.success'=0
		s Ret=..CheckRet(RowId)
		i +Ret>0 d
		.&sql(update DHC_INGDRET set INGRT_CoverId=null where INGRT_CoverId=:RowId)
		.i SQLCODE'=0 d RtnObj.Err(-3,"","更新退货单失败,SQLOCDE:"_SQLCODE)
		q:RtnObj.success'=0
		&sql(delete from DHC_INGdRec_Cover where CVR_RowId=:RowId)
		i SQLCODE'=0 d RtnObj.Err(-4,"","删除付款封面失败,SQLOCDE:"_SQLCODE)
	}
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Descript:	验证付款封面是否包含入库单
/// Creator: 	tsr
/// CreatDate: 	2018-07-05
/// Table: 		DHC_INGdRec
ClassMethod CheckRec(CoverId) As %String
{
	n (CoverId)
	s RowId=""
	&sql(select INGR_RowId into :RowId from DHC_INGdRec where INGR_DO_No=:CoverId)
	q RowId
}

/// Descript:	验证付款封面是否包含退货单
/// Creator: 	tsr
/// CreatDate: 	2018-07-05
/// Table: 		DHC_INGDRET
ClassMethod CheckRet(CoverId) As %String
{
	n (CoverId)
	s RowId=""
	&sql(select INGRT_RowId into :RowId from DHC_INGDRET where INGRT_CoverId=:CoverId)
	q RowId
}

}
