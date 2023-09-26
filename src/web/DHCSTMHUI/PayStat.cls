Import sqluser

/// 付款单汇总
/// zhangxiao 
/// 2014-09-04
Class web.DHCSTMHUI.PayStat Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	付款单汇总
/// Creator:	lxt
/// CreateDate:	2018-09-11
/// Table:		DHC_PayItm
/// Input:		排序，查询条件
/// Return：	付款单汇总
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.PayStat","DHCPay","{""Loc"":""153"",""gUserId"":""873"",""gLocId"":""153"",""gGroupId"":""98"",""gHospId"":""2"",""StartDate"":""21/09/2016"",""EndDate"":""21/09/2018"",""PayMode"":"""",""Vendor"":"""",""CompFlag"":""""}")
Query DHCPay(Params As %Text) As Query(ROWSPEC = "payi,payNo,loc,locDesc,vendor,vendorName,payUserName,payDate,payTime,payAmt:%Float,ack1,ack1UserName,ack1Date,ack2,ack2UserName,ack2Date,payComp,payMode,checkNo,checkDate,checkAmt:%Float,ConPerson,CtrlAcct,ScgDesc,code,desc,spec,type,grno,invno") [ SqlProc ]
{
}

ClassMethod DHCPayExecute(ByRef qHandle As %Binary, Params As %Text) As %Status
{
	n (qHandle,Params)
 	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s Loc=PJObj.%Get("Loc")
	s StartDate=PJObj.%Get("StartDate")
	s EndDate=PJObj.%Get("EndDate")
	s Vendor=PJObj.%Get("Vendor")
	s Completed=PJObj.%Get("CompFlag")
	s PayMode=PJObj.%Get("PayMode")
	s:StartDate'="" StartDate=..DH2L(StartDate)
	s:EndDate'="" EndDate=..DH2L(EndDate)
	
	q:Loc="" $$$OK
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
 
 	s sql="select %ID payi," 
 	s sql=sql_"PAYI_INCI_DR inci,"
 	s sql=sql_"PAYI_RecAmt recAmt,"
 	s sql=sql_"PAYI_PayAmt payAmt,"
 	s sql=sql_"PAYI_INGRI_DR pointor,"
 	s sql=sql_"PAYI_PAY_Parref->pay_No payNo,"
 	s sql=sql_"PAYI_PAY_Parref->pay_ctloc_dr loc,"
 	s sql=sql_"PAYI_PAY_Parref->pay_ctloc_dr->ctloc_desc locDesc,"
 	s sql=sql_"PAYI_PAY_Parref->pay_apcvm_dr vendor,"
 	s sql=sql_"PAYI_PAY_Parref->pay_apcvm_dr->apcvm_name vendorName,"
 	s sql=sql_"PAYI_PAY_Parref->pay_date payDate,"
 	s sql=sql_"PAYI_PAY_Parref->pay_time payTime,"
 	s sql=sql_"PAYI_PAY_Parref->pay_ssusr_dr->ssusr_name payUserName,"
 	s sql=sql_"PAYI_PAY_Parref->pay_ack1 ack1,"
 	s sql=sql_"PAYI_PAY_Parref->pay_date_ack1 ack1Date,"
 	s sql=sql_"PAYI_PAY_Parref->pay_ssusr_ack1->ssusr_name ack1UserName,"
 	s sql=sql_"PAYI_PAY_Parref->pay_ack2 ack2,"
 	s sql=sql_"PAYI_PAY_Parref->pay_date_ack2 ack2Date,"
 	s sql=sql_"PAYI_PAY_Parref->pay_ssusr_ack2->ssusr_name ack2UserName,"
 	s sql=sql_"PAYI_PAY_Parref->pay_completed payComp,"
 	s sql=sql_"PAYI_PAY_Parref->pay_mode payMode,"
 	s sql=sql_"PAYI_PAY_Parref->pay_checkno checkNo,"
 	s sql=sql_"PAYI_PAY_Parref->pay_checkdate checkDate,"
 	s sql=sql_"PAYI_PAY_Parref->pay_checkamt checkAmt"
 	s sql=sql_ " from DHC_PayItm  where PAYI_PAY_Parref->pay_date between '"_StartDate_"' and '"_EndDate_"' and PAYI_PAY_Parref->pay_ctloc_dr="_Loc
 
 	s:PayMode'="" sql=sql_" and PAYI_PAY_Parref->pay_mode in ("_PayMode_")"
 	i Vendor'="" d
 	.s sql=sql_" and PAYI_PAY_Parref->pay_apcvm_dr="_Vendor
 	i Completed'="" d
 	.s sql=sql_" and nvl(PAYI_PAY_Parref->pay_completed,'N')="_"'"_Completed_"'"  //2012-12-16
 	s xrs=##class(%ResultSet).%New()
 	s xrs.RuntimeMode=0
 	d xrs.Prepare(sql)
 	s sc=xrs.Execute()
 	i $$$ISERR(sc) q $$$OK
 	while (xrs.Next())
 	{
 		s payi=xrs.Data("payi")
 		s inci=xrs.Data("inci")
 		s pointor=xrs.Data("pointor")
 		s code=$p(^INCI(inci,1),"^",1) ;物资名称
 		s desc=$p(^INCI(inci,1),"^",2) ;物资名称
 		s spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",inci)
 		s grnotypestr=##class(web.DHCSTMHUI.PayStat).Getpaynobypitmid(payi)
 		s type=$p(grnotypestr,"^",2)
 		s GRID=$p(pointor,"||",1)
 		s GRchl=$p(pointor,"||",2)
 		s invno=""
 		i type="G" d
 		.s type="入库"
 		.s invno=$p(^DHCINGR(GRID,"GRI",GRchl),"^",27)
 		i type="R" d
 		.s type="退货"
 		.s invno=$p(^INGRT(GRID,"DHCGRR",GRchl),"^",12)
 		s grno=$p(grnotypestr,"^",1)
 		s payNo=xrs.Data("payNo")
 		s loc=xrs.Data("loc")
 		s locDesc=xrs.Data("locDesc")
 		s vendor=xrs.Data("vendor")
 		s ConPerson=$p(^APC("APCVM",vendor),"^",8)   ;开户行
 		s CtrlAcct=$p(^APC("APCVM",vendor),"^",10)   ;账户
 		s vendorName=xrs.Data("vendorName")
 		s payUserName=xrs.Data("payUserName")
 		s payDate=xrs.Data("payDate")
 		i payDate'="" s payDate=..DL2H(payDate)
 		s ScgDesc=$P(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inci),"^",2)
		s payTime=xrs.Data("payTime")
 		i payTime'="" s payTime=..TL2H(payTime) 
 		s payAmt=xrs.Data("payAmt") ;##class(web.DHCSTMHUI.DHCPay).PayAmt(pay)
 		s recAmt=xrs.Data("recAmt")
 		s ack1=xrs.Data("ack1")
 		s ack1UserName=xrs.Data("ack1UserName")
 		s ack1Date=xrs.Data("ack1Date")
 		i ack1Date'="" s ack1Date=..DL2H(ack1Date)
 		s ack2=xrs.Data("ack2")
 		s ack2UserName=xrs.Data("ack2UserName")
 		s ack2Date=xrs.Data("ack2Date")
 		i ack2Date'="" s ack2Date=..DL2H(ack2Date)
 		s payComp=xrs.Data("payComp")
     
 		s payMode=xrs.Data("payMode")
 		;i payMode'="" &sql(select PayMode_Desc into :payMode From DHC_PayMode where %id=:payMode)
 		///支付方式表由dhc_paymode改为ct_paymode
        i payMode'="" &sql(select CTPM_Desc into :payMode From CT_PayMode where %id=:payMode)

 		s checkNo=xrs.Data("checkNo")
 		s checkAmt=xrs.Data("checkAmt")
 		s checkDate=xrs.Data("checkDate")
 		i checkDate'="" s checkDate=..DL2H(checkDate)
     
 		d OutPutRow1 
 	}
 	d xrs.Close()
 
 	Quit $$$OK
OutPutRow1
 	s Data=$lb(payi,payNo,loc,locDesc,vendor,vendorName,payUserName,payDate,payTime,payAmt,ack1,ack1UserName,ack1Date,ack2,ack2UserName,ack2Date,payComp,payMode,checkNo,checkDate,checkAmt,ConPerson,CtrlAcct,ScgDesc,code,desc,spec,type,grno,invno)   
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
}

/// 根据付款明细id获取业务单号,业务类型
/// lihui 2016-6-8
/// w ##class(web.DHCSTMHUI.PayStat).Getpaynobypitmid("216||4")
ClassMethod Getpaynobypitmid(payiid As %String) As %String
{
 q:payiid="" ""
 s (GRno,type)=""
 s GRdr=$p(^DHCPAY(+payiid,"I",$p(payiid,"||",2)),"^",2)
 s type=$p(^DHCPAY(+payiid,"I",$p(payiid,"||",2)),"^",9)
 s:GRdr'="" GRdr=+GRdr 
 i type="G" d
 .s GRno=$p($g(^DHCINGR(GRdr)),"^",1)
 i type="R" d
 .s GRno=$p($g(^INGRT(GRdr)),"^",1)
 q GRno_"^"_type
}

}
