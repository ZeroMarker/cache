Import sqluser

Class web.DHCSTMHUI.PayCoverItm Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	查询付款封面对应的入库退货信息
/// Creator: 	tsr
/// CreatDate: 	2018-07-05
/// Table: 		DHC_INGdRec,DHC_INGDRET
/// Input: 		付款封面Id
Query QueryCoverRec(CoverId As %String) As Query(ROWSPEC = "RowId,GRNo,Vendor,VendorDesc,RpAmt:%Float,SpAmt:%Float,QtyAmt:%Float,Type") [ SqlProc ]
{
}

ClassMethod QueryCoverRecExecute(ByRef qHandle As %Binary, CoverId As %String) As %Status
{
	n (qHandle,CoverId)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s StkType=..sssCode()
	//检索入库数据
	s SqlStr="select INGR_RowId Ingr,"
	s SqlStr=SqlStr_"INGR_No GRNo,"
	s SqlStr=SqlStr_"INGR_APCVM_DR Vendor,"
	s SqlStr=SqlStr_"INGR_APCVM_DR->apcvm_name VendorDesc"
	s SqlStr=SqlStr_" From DHC_INGdRec"
	s SqlStr=SqlStr_" where INGR_DO_No="_CoverId
	s SqlStr=SqlStr_" and INGR_StkType='"_StkType_"'"

    s xrs=##class(%Library.ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(SqlStr)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{
		s Type="G"
		s Ingr=xrs.Data("Ingr")
		s GRNo=xrs.Data("GRNo")
		s Vendor=xrs.Data("Vendor")
		s VendorDesc=xrs.Data("VendorDesc")
		s GRAmt=##class(web.DHCSTMHUI.DHCINGdRecInv).GetGRAmt(Ingr,Type)
		s RpAmt=$p(GRAmt,"^",1)
		s SpAmt= $p(GRAmt,"^",2)
		s QtyAmt=$p(GRAmt,"^",3)
		d OutPutRow
	}
	d xrs.Close()
 
	//检索退货数据
	s SqlStr="select ID Ingr,"
	s SqlStr=SqlStr_"INGRT_NO GRNo,"
	s SqlStr=SqlStr_"INGRT_APCVM_DR Vendor,"
	s SqlStr=SqlStr_"INGRT_APCVM_DR->apcvm_name VendorDesc"
	s SqlStr=SqlStr_" From DHC_INGDRET"
	s SqlStr=SqlStr_" where INGRT_CoverId="_CoverId
	s SqlStr=SqlStr_" and INGRT_StkType= '"_StkType_"'"

    s xrs=##class(%Library.ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(SqlStr)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{
		s Type="R"
		s Ingr=xrs.Data("Ingr")
		s GRNo=xrs.Data("GRNo")
		s Vendor=+xrs.Data("Vendor")
		s VendorDesc=xrs.Data("VendorDesc")
		s GRAmt=##class(web.DHCSTMHUI.DHCINGdRecInv).GetGRAmt(Ingr,Type)
		s RpAmt=$p(GRAmt,"^",1)
		s SpAmt= $p(GRAmt,"^",2)
		s QtyAmt=$p(GRAmt,"^",3)
		d OutPutRow
	}
	Quit $$$OK
OutPutRow
 s Data=$lb(Ingr,GRNo,Vendor,VendorDesc,RpAmt,SpAmt,QtyAmt,Type)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

/// Descript:	保存付款封面子表
/// Creator: 	tsr
/// CreatDate: 	2018-07-06
/// Table: 		DHC_INGdRec_CoverItm
ClassMethod InsertCoverItm(CvrID As %String, Data As %String) As %String
{
	n (CvrID,Data)
	s StkCat=$p(Data,"^",1)
	s RpAmt=$p(Data,"^",2)
	s SpAmt=$p(Data,"^",3)
	s Ch=$O(^DHCINGRCover(CvrID,"I",""),-1)+1
    
    &sql(insert into DHC_INGdRec_CoverItm (CVRI_Parref,CVRI_ChildSub,CVRI_StkCat_DR,CVRI_RpAmt,CVRI_SpAmt)
    	values (:CvrID,:Ch,:StkCat,:RpAmt,:SpAmt))
    q:SQLCODE'=0 -1
    q 0
}

/// Descript:	修改付款封面子表
/// Creator: 	tsr
/// CreatDate: 	2018-07-06
/// Table: 		DHC_INGdRec_CoverItm
ClassMethod UpdateCoverItm(CvrItm, Data) As %String
{
	n (CvrItm,Data)
	s StkCat=$p(Data,"^",1)
	s RpAmt=$p(Data,"^",2)
	s SpAmt=$p(Data,"^",3)
	s StkCatTmp=$p(^DHCINGRCover(+CvrItm,"I",$p(CvrItm,"||",2)),"^",1)
	q:StkCatTmp'=StkCat -1
    
    &sql(update DHC_INGdRec_CoverItm set CVRI_RpAmt=:RpAmt,CVRI_SpAmt=:SpAmt where CVRI_RowId=:CvrItm)
    q:SQLCODE'=0 -2
    q 0
}

/// Descript:	查询付款封面明细信息
/// Creator: 	tsr
/// CreatDate: 	2018-08-03
/// Table: 		DHC_INGdRec_CoverItm
/// Input: 		付款封面Id
Query QueryCoverItm(CoverId As %String) As Query(ROWSPEC = "RowId,StkCat,RpAmt:%Float,SpAmt:%Float") [ SqlProc ]
{
}

ClassMethod QueryCoverItmExecute(ByRef qHandle As %Binary, CoverId As %String) As %Status
{
	n (qHandle,CoverId)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
 	q:CoverId="" $$$OK
 	
	s StkType=..sssCode()
 
	s SqlStr="select CVRI_RowId RowId,"
	s SqlStr=SqlStr_" CVRI_StkCat_DR->INCSC_Desc StkCat,"
	s SqlStr=SqlStr_" CVRI_RpAmt RpAmt,"
	s SqlStr=SqlStr_" CVRI_SpAmt SpAmt"
	s SqlStr=SqlStr_" From DHC_INGdRec_CoverItm"
	s SqlStr=SqlStr_" where CVRI_Parref= "_CoverId
 
    s xrs=##class(%Library.ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(SqlStr)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{
		s RowId=xrs.Data("RowId")
		s StkCat=xrs.Data("StkCat") 
		s RpAmt=xrs.Data("RpAmt")
		s SpAmt=xrs.Data("SpAmt")
		d OutPutCoverItmRow
	} 
 
 Quit $$$OK
OutPutCoverItmRow
 s Data=$lb(RowId,StkCat,RpAmt,SpAmt)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

}
