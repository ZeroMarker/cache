Import sqluser

Class web.DHCSTMHUI.DHCPayVoucher Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	查询凭证信息
/// Creator: 	tsr
/// CreatDate: 	2018-07-09
/// Table: 		DHC_StockVoucher
/// Input: 		Params对象
Query QueryVoucher(Params As %String) As Query(ROWSPEC = "RowId,VoucherNo,Vendor,VendorDesc,SvcDate,StartDate,EndDate,Type,Month,RpAmt:%Float,SpAmt:%Float") [ SqlProc ]
{
}

ClassMethod QueryVoucherExecute(ByRef qHandle As %Binary, Params As %String) As %Status
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
	s LocId=PJObj.%Get("IngrLoc")
	s Vendor=PJObj.%Get("Vendor")
	s VoucherNo=PJObj.%Get("VoucherNo")
	q:LocId="" $$$OK
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	s StartDate=..DH2L(StartDate)
	s EndDate=..DH2L(EndDate)
	
	s SqlStr="select SVC_Rowid RowId,"
	s SqlStr=SqlStr_"SVC_VoucherNo VoucherNo,"
	s SqlStr=SqlStr_"svc_apcvm_dr->apcvm_name VendorDesc,"
	s SqlStr=SqlStr_"svc_date SvcDate,svc_apcvm_dr Vendor,"
	s SqlStr=SqlStr_"SVC_type Type,RIGHT(svc_month,2) Month,"
	s SqlStr=SqlStr_"svc_startdate StartDate,svc_enddate EndDate,"
	s SqlStr=SqlStr_"svc_rpamt RpAmt,svc_spamt SpAmt"
	s SqlStr=SqlStr_" From DHC_StockVoucher"
	s SqlStr=SqlStr_" where svc_date between "_StartDate_" and "_EndDate
	s SqlStr=SqlStr_" and svc_loc_dr="_LocId
	i Vendor'="" d
	.s SqlStr=SqlStr_" and svc_apcvm_dr="_Vendor
	i VoucherNo'="" d
	.s SqlStr=SqlStr_" and SVC_VoucherNo="_VoucherNo
	s xrs=##class(%ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(SqlStr)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{
		s RowId=xrs.Data("RowId") 
		s VoucherNo=xrs.Data("VoucherNo")
		s Vendor=xrs.Data("Vendor")
		s VendorDesc=xrs.Data("VendorDesc")
		s SvcDate=xrs.Data("SvcDate")
		s Type=xrs.Data("Type")
		s Month=xrs.Data("Month")
		s StartDate=xrs.Data("StartDate")
		s EndDate=xrs.Data("EndDate")
		s RpAmt=xrs.Data("RpAmt")
		s SpAmt=xrs.Data("SpAmt")
		s:SvcDate'="" SvcDate=..DL2H(SvcDate)
		s:StartDate'="" StartDate=..DL2H(StartDate)
		s:EndDate'="" EndDate=..DL2H(EndDate)
		d OutPutRow
	}
	d xrs.Close()
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,VoucherNo,Vendor,VendorDesc,SvcDate,StartDate,EndDate,Type,Month,RpAmt,SpAmt) 
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	查询凭证入库退货信息
/// Creator: 	tsr
/// CreatDate: 	2018-07-09
/// Table: 		DHC_INGdRec,DHC_INGDRET
/// Input: 		凭证RowId
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCPayVoucher","QueryRecByVoucher","195")
Query QueryRecByVoucher(Svc As %String) As Query(ROWSPEC = "RowId,GRNo,CreateDate,CreateUser,AuditDate,AuditUser,ScgDesc,RpAmt:%Float,SpAmt:%Float,QtyAmt:%Float,Type,OverFlag") [ SqlProc ]
{
}

ClassMethod QueryRecByVoucherExecute(ByRef qHandle As %Binary, Svc As %String) As %Status
{
	n (qHandle,Svc)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Svc="" $$$OK

	s StkType=..sssCode()
	//检索入库数据
	s SqlStr="select INGR_RowId Ingr,"
	s SqlStr=SqlStr_"INGR_No GRNo,"
	s SqlStr=SqlStr_"INGR_SCG_DR Scg,"
	s SqlStr=SqlStr_"ingr_createdate CreateDate,"
	s SqlStr=SqlStr_"ingr_createuser->ssusr_name CreateUser,"
	s SqlStr=SqlStr_"ingr_date AuditDate,"
	s SqlStr=SqlStr_"ingr_ssusr_dr->ssusr_name AuditUser"
	s SqlStr=SqlStr_" From DHC_INGdRec"
	s SqlStr=SqlStr_" where INGR_StkType='"_StkType_"'"
	s SqlStr=SqlStr_" and INGR_RowId IN (select svci_pointer from DHC_StockVoucherItm where svci_svc_parref="_Svc_")"

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
		s CreateDate=xrs.Data("CreateDate")
		s CreateUser=xrs.Data("CreateUser")
		s AuditDate=xrs.Data("AuditDate")
		s AuditUser=xrs.Data("AuditUser")
		s:CreateDate'="" CreateDate=..DL2H(CreateDate)
		s:AuditDate'="" AuditDate=..DL2H(AuditDate)
		s Scg=xrs.Data("Scg")
		s ScgDesc=$s(Scg'="":$p(^DHCSCG(Scg),"^",2),1:"")
		s GRAmt=##class(web.DHCSTMHUI.DHCINGdRecInv).GetGRAmt(Ingr,Type)
		s RpAmt=$p(GRAmt,"^",1)
		s SpAmt= $p(GRAmt,"^",2)
		s QtyAmt=$p(GRAmt,"^",3)
		s PayedAmt= ##class(web.DHCSTMHUI.DHCINGdRecInv).PayedAmt(Ingr,Type)
		s OverFlag=$s(PayedAmt>=RpAmt:"Y",1:"N")
		d OutPutRecRow
	}
	d xrs.Close()
 
	//检索退货数据
	s SqlStr="select ID Ingr,"
	s SqlStr=SqlStr_"INGRT_NO GRNo,"
	s SqlStr=SqlStr_"ingrt_date CreateDate,"
	s SqlStr=SqlStr_"ingrt_ssusr_dr->ssusr_name CreateUser,"
	s SqlStr=SqlStr_"ingrt_auditdate AuditDate,"
	s SqlStr=SqlStr_"INGRT_SSUSR_Audit_DR->ssusr_name AuditUser,"
	s SqlStr=SqlStr_"INGRT_SCG_DR Scg"
	s SqlStr=SqlStr_" From DHC_INGDRET"
	s SqlStr=SqlStr_" where INGRT_StkType='"_StkType_"'"
	s SqlStr=SqlStr_" and ID IN (select svci_pointer from DHC_StockVoucherItm where svci_svc_parref="_Svc_")"

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
		s CreateDate=xrs.Data("CreateDate")
		s CreateUser=xrs.Data("CreateUser")
		s AuditDate=xrs.Data("AuditDate")
		s AuditUser=xrs.Data("AuditUser")
		s:CreateDate'="" CreateDate=..DL2H(CreateDate)
		s:AuditDate'="" AuditDate=..DL2H(AuditDate)
		s Scg=xrs.Data("Scg")
		s ScgDesc=$s(Scg'="":$p(^DHCSCG(Scg),"^",2),1:"")
		s GRAmt=##class(web.DHCSTMHUI.DHCINGdRecInv).GetGRAmt(Ingr,Type)
		s RpAmt=$p(GRAmt,"^",1)
		s SpAmt= $p(GRAmt,"^",2)
		s QtyAmt=$p(GRAmt,"^",3)
		s PayedAmt= ##class(web.DHCSTMHUI.DHCINGdRecInv).PayedAmt(Ingr,Type)
		s OverFlag=$s(PayedAmt>=RpAmt:"Y",1:"N")
		d OutPutRecRow
	}
	Quit $$$OK
OutPutRecRow
 s Data=$lb(Ingr,GRNo,CreateDate,CreateUser,AuditDate,AuditUser,ScgDesc,RpAmt,SpAmt,QtyAmt,Type,OverFlag)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

/// Descript:	删除凭证信息
/// Creator: 	tsr
/// CreatDate: 	2018-07-09
/// Table: 		DHC_StockVoucher
/// Input: 		凭证RowId
ClassMethod DeleteVoucher(Svc As %String) As %String
{
    n (Svc)
    s RtnObj=##class(RtnObj).%New()
	i Svc="" d RtnObj.Err(-1,"","凭证Id为空!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
    &sql(delete from DHC_StockVoucher where svc_rowid=:Svc)
    i SQLCODE'=0 d RtnObj.Err(-2,Svc,"删除凭证信息失败!")
    q RtnObj.Json()
}

/// 生成入库/退货凭证
/// Author:lxt
/// Date:2017-02-07
/// w ##class(web.DHCSTMHUI.DHCPayVoucher).InsertVoucher("153^2^541^2017-01-13^2017-12-13^812^680^880^0^0","118^126","")
ClassMethod InsertVoucher(maindata, recdetaildata, retdetaildata)
{
	n (maindata,recdetaildata,retdetaildata)
	q:maindata="" -1
	q:(recdetaildata="")&&(retdetaildata="") -2
	
	s loc=$p(maindata,"^",1)
 	s MonthId=$p(maindata,"^",2)
 	s userid=$p(maindata,"^",3)
 	s stdate=$p(maindata,"^",4)
 	s enddate=$p(maindata,"^",5)
 	s venid=$p(maindata,"^",6)
 	s recrealamt=+$p(maindata,"^",7)
 	s recsaleamt=+$p(maindata,"^",8)
 	s retrealamt=+$p(maindata,"^",9)
 	s retsaleamt=+$p(maindata,"^",10)
	
	ts
	s recvoucherid="",retvoucherid="",ret=0
	i recdetaildata'=""  d
	.s flag="G"
	.s data=loc_"^"_MonthId_"^"_userid_"^"_stdate_"^"_enddate_"^"_venid_"^"_recrealamt_"^"_recsaleamt
    .s recvoucherid=..Insert(flag,data,recdetaildata)
    .i +recvoucherid<0  s ret=-3 tro
    q:ret<0 ret
    
    i retdetaildata'=""  d
	.s flag="R"
	.s data=loc_"^"_MonthId_"^"_userid_"^"_stdate_"^"_enddate_"^"_venid_"^"_retrealamt_"^"_retsaleamt
    .s retvoucherid=..Insert(flag,data,retdetaildata)
    .i +retvoucherid<0  s ret=-4 tro
    q:ret<0 ret
    
    tc
    q recvoucherid_"^"_retvoucherid
}

/// 插入凭证主表
/// Author:lxt
/// Date:2017-02-07
ClassMethod Insert(flag, data, detaildata)
{
	n (flag,data,detaildata)
	q:flag="" -1
	q:data="" -2
	q:detaildata="" -3
	s ret=0
	s voucherid=..InsertVoucherMain(flag,data)
	q:+voucherid<0 -4

	f i=1:1:$l(detaildata,"^") q:ret<0  d
	.s ingid=$p(detaildata,"^",i)
	.i ingid="" s ret=-5
	.q:ingid=""
	.s itm=..InsertVoucherItm(voucherid,ingid,flag)
	.i +itm<0 s ret=-6
	.q:+itm<0
	
	q:ret<0 ret
	q voucherid
}

/// 插入凭证主表
/// Author:lxt
/// Date:2017-02-07
ClassMethod InsertVoucherMain(flag, data)
{
	n (flag,data)
	q:flag="" -1
	q:data="" -2
    s loc=$p(data,"^",1)
 	s month=$p(data,"^",2)
 	s len=$l(month)
 	s month1=month
 	i len<2 s month1="0"_month
 	s userid=$p(data,"^",3)
 	s stdate=$p(data,"^",4)
 	s enddate=$p(data,"^",5)
 	s year=$p(enddate,"-",1)
 	s venid=$p(data,"^",6)
 	s realamt=+$p(data,"^",7)
 	s saleamt=+$p(data,"^",8)
 
 	s rowid=$o(^DHCSVC(0,"LOCYEARMONTH",loc,year,month,""),-1)
 	i rowid="" d
 	.s num="0001" 
 	.s number=loc_year_month1_num
 	else  D
 	.s number=$p(^DHCSVC(rowid),"^",6)
 	.s number=number+1
 	
 	;s type=""
 	;i flag="G" d
	;.s poinid=$o(^DHCINGR(0,"No",poinerno,""))
 	;.i $d(^DHCINGR(poinid,"GRI",1)) d
 	;..S inci=$P(^DHCINGR(poinid,"GRI",1),"^",25)
 	;.e  d
 	;..s inci=$P(^DHCINGR(poinid,"GRI",2),"^",25)
	;.s scgType=$$GetIncStkCatGrp(inci)
 	;.s scgType1=$p(scgType,"^",5)   //类组
	;.s type=scgType1
 	;e  d
 	;.s poinid="",child=""
 	;.s poinid=$o(^INGRT(0,"RETNO",poinerno,poinid)) q:poinid=""
 	;.s child=$o(^INGRT(poinid,"DHCGRR",child)) q:child=""
 	;.s ingritmrowid=$p(^INGRT(poinid,"DHCGRR",child),"^",1)
 	;.S inci=$P(^DHCINGR($p(ingritmrowid,"||",1),"GRI",$p(ingritmrowid,"||",2)),"^",25)
 	;.s scgType=$$GetIncStkCatGrp(inci)
 	;.s scgType1=$p(scgType,"^",5)   //类组 
 	;.s type=scgType1
 	
 	k PLIST
 	s PLIST(1)=""
 	s PLIST(2)=flag
 	s PLIST(3)=""
 	s PLIST(4)=userid
 	s PLIST(5)=+$h
 	s PLIST(6)=$P($h,",",2)
 	s PLIST(7)=number
 	s PLIST(8)=loc
 	s PLIST(9)=month
 	s PLIST(10)=stdate
 	s PLIST(11)=enddate
 	;s PLIST(12)=type   //类组
 	s PLIST(12)=""
 	s PLIST(13)=venid
 	s PLIST(14)=realamt
 	s PLIST(15)=saleamt
 	s PLIST(20)=year
 	s PLIST=$o(PLIST(""),-1)
 	&sql(insert into DHC_StockVoucher values :PLIST())
 	q:SQLCODE -3 
 	q +(%ROWID)
}

/// 插入凭证子表
/// Author:lxt
/// Date:2017-02-07
ClassMethod InsertVoucherItm(mrowid, poinerid, flag)
{
	n (mrowid,poinerid,flag)
	q:mrowid="" -1
	q:poinerid="" -2
	q:flag="" -3

    s checkflag=..CheckVoucher(flag,poinerid)
    i checkflag=0  q -4   //已生成凭证
 	s ch=$o(^DHCSVC(mrowid,"I",""),-1)
 	s ch=ch+1
	k PLIST
 	s PLIST(0)=mrowid
 	s PLIST(1)=""
 	s PLIST(2)=ch
 	s PLIST(3)=poinerid
 	s PLIST(4)="Y"
 	s PLIST(5)=flag
 	s PLIST=$o(PLIST(""),-1)
 	s SQLCODE=0
 	&sql(insert into DHC_StockVoucherItm values :PLIST())    
 	q:SQLCODE -15
 	q %ROWID
}

/// 判断是否当前凭证 
/// w ##class(web.DHCSTMHUI.DHCPayVoucher).PayVoucher("R","22766","32891")
/// return:是0  否1
ClassMethod PayVoucher(type, ingri, Voucherid)
{
	n (type,ingri,Voucherid) 
	s SVCItemId="" 
	&sql(select %id into :SVCItemId from DHC_StockVoucherItm where svci_type=:type and svci_svc_Parref=:Voucherid and svci_Pointer=:ingri) 
	i SVCItemId'="" q 0 
	e  q 1
}

/// 判断是否生成凭证
/// w ##class(web.DHCSTMHUI.DHCPayVoucher).CheckVoucher("R","22766")
/// return:0是  1否
ClassMethod CheckVoucher(type, ingri)
{
	n (type,ingri) 
	s SVCItemId="" 
	&sql(select %id into :SVCItemId from DHC_StockVoucherItm where svci_type=:type and svci_Pointer=:ingri) 
	i SVCItemId'="" q 0 
	e  q 1
}

/// 取单个凭证单记录数据字符串
/// Author:lxt
/// Date:2017-2-9
/// Argu:
/// Return:
/// w ##class(web.DHCSTMHUI.DHCPayVoucher).SelectVoucher(7)
ClassMethod SelectVoucher(svcId As %String) As %String
{
 n (svcId)
 s result=""
 &sql(
SELECT SVC_ROWID,svc_type,svc_ssusr_dr,svc_ssusr_dr->ssusr_name,svc_date,svc_time,
svc_voucherNo,svc_Loc_dr,svc_Loc_dr->ctloc_desc,Svc_month,Svc_Startdate,svc_endDate, 
svc_scg_dr,svc_scg_dr->scg_desc,svc_apcvm_dr,svc_apcvm_dr->apcvm_name,svc_rpamt,svc_spamt 
into :SVCrowid,:SVCtype,:SVCuser,:SVCuserdesc,:SVCdate,:SVCtime,
:SVCvoucherNo,:SVCloc,:SVClocdesc,:SVCmonth,:SVCstrda,:SVCendda,
:SVCscg,:SVCscgdesc,:SVCapcvm,:SVCapcvmdesc,:SVCrpamt,:SVCspamt 
FROM DHC_StockVoucher where %id=:svcId)
 q:SQLCODE='0 result
 
 s:SVCdate'="" SVCdate=..DL2H(SVCdate)
 s:SVCtime'="" SVCtime=..TL2H(SVCtime)
 s:SVCstrda'="" SVCstrda=..DL2H(SVCstrda)
 s:SVCendda'="" SVCendda=..DL2H(SVCendda)
 s:SVCmonth'="" SVCmonth=..DL2H(SVCmonth),SVCmonth=$p(SVCmonth,"-",3)
 
 s result=SVCrowid_"^"_SVCtype_"^"_SVCuser_"^"_SVCuserdesc_"^"_SVCdate_"^"_SVCtime_"^"_
 	SVCvoucherNo_"^"_SVCloc_"^"_SVClocdesc_"^"_SVCmonth_"^"_SVCstrda_"^"_SVCendda_"^"_
 	SVCscg_"^"_SVCscgdesc_"^"_SVCapcvm_"^"_SVCapcvmdesc_"^"_SVCrpamt_"^"_SVCspamt

 q result
}

/// 取库凭证单明细汇总数据
/// Author:lxt
/// Date:2017-1-20
/// Argu:
/// Return:
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCPayVoucher","GetVoucherDetailRecord",34)
Query GetVoucherDetailRecord(Params As %String) As Query(ROWSPEC = "svcrowid,svcitmscgdesc,svcitmqty:%Float,svcitmrpamt:%Float,svcitmspamt:%Float,svcitmdif,incscdesc") [ SqlProc ]
{
}

ClassMethod GetVoucherDetailRecordExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Params="" $$$OK
	
	s svcId=Params
	
	s svcitm=""
	s sumqty=0
	s sumrpamt=0
	s sumspamt=0
	s sumdif=0
	s type=$p(^DHCSVC(svcId),"^",1)
	k ^TEMPVOUCHERDETAIL(svcId)
	
	i type="G"  d
	.f  s svcitm=$o(^DHCSVC(svcId,"I",svcitm)) q:svcitm=""  d
	..s pointer=$p(^DHCSVC(svcId,"I",svcitm),"^",1)
	..s scgdesc=""
	..s scg=$p(^DHCINGR(pointer),"^",28)
	..i scg="" s scg="scg"
	..i scg'="scg" s scgdesc=$p(^DHCSCG(scg),"^",2)
	..s itmid=""
	..f  s itmid=$o(^DHCINGR(pointer,"GRI",itmid)) q:itmid=""  d
	...&sql(select initm_INCI_DR inci,initm_INCI_DR->INCI_INCSC_DR incscid,initm_INCI_DR->INCI_INCSC_DR->INCSC_Desc incscdesc,ingri_recqty qty,initm_realtotal rpAmt,initm_spamt spAmt 
	   into inci,incscid,incscdesc,qty,rpamt,spamt
	   From dhc_ingdrecitm where ingri_childsub=:itmid and ingri_ingr_parref=:pointer)
	...i incscid=""  d
	....s incscid="incsc"
	....s incscdesc=""
	...i $d(^TEMPVOUCHERDETAIL(svcId,scg,incscid)) d
	....s sumqty=+qty+$p(^TEMPVOUCHERDETAIL(svcId,scg,incscid),"^",3)
	....s sumrpamt=+rpamt+$p(^TEMPVOUCHERDETAIL(svcId,scg,incscid),"^",4)
	....s sumspamt=+spamt+$p(^TEMPVOUCHERDETAIL(svcId,scg,incscid),"^",5)
	....s sumdif=sumrpamt-sumspamt
	....s ^TEMPVOUCHERDETAIL(svcId,scg,incscid)=svcId_"^"_scgdesc_"^"_sumqty_"^"_sumrpamt_"^"_sumspamt_"^"_sumdif_"^"_incscdesc
	...e  d
	....s dif=rpamt-spamt
	....s ^TEMPVOUCHERDETAIL(svcId,scg,incscid)=svcId_"^"_scgdesc_"^"_qty_"^"_rpamt_"^"_spamt_"^"_dif_"^"_incscdesc
	
	i type="R" d
	.f  s svcitm=$o(^DHCSVC(svcId,"I",svcitm)) q:svcitm=""  d
	..s pointer=$p(^DHCSVC(svcId,"I",svcitm),"^",1)
	..s scgdesc=""
	..s scg=$p(^INGRT(pointer),"^",14)
	..i scg="" s scg="scg"
	..i scg'="scg" s scgdesc=$p(^DHCSCG(scg),"^",2)
	..s itmid=""
	..f  s itmid=$o(^INGRT(pointer,"DHCGRR",itmid)) q:itmid=""  d
	...&sql(select INGRTI_INGRI_DR->initm_INCI_DR inci,INGRTI_INGRI_DR->initm_INCI_DR->INCI_INCSC_DR incscid,INGRTI_INGRI_DR->initm_INCI_DR->INCI_INCSC_DR->INCSC_Desc incscdesc,ingrti_retqty retqty,INGRTI_RETAMOUNT rpAmt,INGRTI_SpAmt spAmt 
	   into inci,incscid,incscdesc,qty,rpamt,spamt
	   From dhc_ingrtitm where ingrti_childsub=:itmid and ingrti_ingrt_parref=:pointer)
	...i incscid=""  d
	....s incscid="incsc"
	....s incscdesc=""
	...i $d(^TEMPVOUCHERDETAIL(svcId,scg,incscid)) d
	....s sumqty=+qty+$p(^TEMPVOUCHERDETAIL(svcId,scg,incscid),"^",3)
	....s sumrpamt=+rpamt+$p(^TEMPVOUCHERDETAIL(svcId,scg,incscid),"^",4)
	....s sumspamt=+spamt+$p(^TEMPVOUCHERDETAIL(svcId,scg,incscid),"^",5)
	....s sumdif=sumrpamt-sumspamt
	....s ^TEMPVOUCHERDETAIL(svcId,scg,incscid)=svcId_"^"_scgdesc_"^"_sumqty_"^"_sumrpamt_"^"_sumspamt_"^"_sumdif_"^"_incscdesc
	...e  d
	....s dif=$g(rpamt)-$g(spamt)
	....s ^TEMPVOUCHERDETAIL(svcId,scg,incscid)=svcId_"^"_scgdesc_"^"_qty_"^"_rpamt_"^"_spamt_"^"_dif_"^"_incscdesc
	
    s scgid=""
    s sumdif=0
    f  s scgid=$o(^TEMPVOUCHERDETAIL(svcId,scgid)) q:(scgid="")  d
    .s incscid=""
    .f  s incscid=$o(^TEMPVOUCHERDETAIL(svcId,scgid,incscid)) q:(incscid="")  d
    ..s svcrowid=$p(^TEMPVOUCHERDETAIL(svcId,scgid,incscid),"^",1)
    ..s svcitmscgdesc=$p(^TEMPVOUCHERDETAIL(svcId,scgid,incscid),"^",2)
    ..s svcitmqty=$p(^TEMPVOUCHERDETAIL(svcId,scgid,incscid),"^",3)
    ..s svcitmrpamt=$p(^TEMPVOUCHERDETAIL(svcId,scgid,incscid),"^",4)
    ..s svcitmspamt=$p(^TEMPVOUCHERDETAIL(svcId,scgid,incscid),"^",5)
    ..s svcitmdif=$p(^TEMPVOUCHERDETAIL(svcId,scgid,incscid),"^",6)
    ..s incscdesc=$p(^TEMPVOUCHERDETAIL(svcId,scgid,incscid),"^",7)
    ..d OutPutSVCItm
    
	Quit $$$OK
	
OutPutSVCItm
	s Data=$lb(svcrowid,svcitmscgdesc,svcitmqty,svcitmrpamt,svcitmspamt,svcitmdif,incscdesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
