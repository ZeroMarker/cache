Import sqluser

Class web.DHCSTMHUI.HRP.AccountStat Extends (%RegisteredObject, web.DHCSTMHUI.StkTypeM, %XML.Adaptor) [ Not ProcedureBlock ]
{

Parameter HospId = 2;

Parameter LocStr = "1,2";

/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.HRP.AccountStat","QueryIncStkCat")
/// 同步分类
/// Call web_DHCSTMHUI_HRP.IncStkCat()
Query QueryIncStkCat() As web.DHCSTMHUI.Query(ROWSPEC = "MAT_TYPE_CODE,MAT_TYPE_NAME,SUPER_CODE,TYPE_LEVEL,IS_LAST") [ SqlName = IncStkCat, SqlProc ]
{
}

ClassMethod QueryIncStkCatExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle,Params)
	;s ^zx("Params")=Params
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s HospId=..#HospId
	s stkcatgroupId="0"
	f  s stkcatgroupId=$O(^DHCSCG(stkcatgroupId)) q:(stkcatgroupId="")||(stkcatgroupId="STKCAT")  d
	.s scgcode=$p(^DHCSCG(stkcatgroupId),"^",1)
	.s scgdesc=$p(^DHCSCG(stkcatgroupId),"^",2)
	.s scgtype=$p(^DHCSCG(stkcatgroupId),"^",3)
	.q:scgtype'="M"
	.s parrefdr=$p(^DHCSCG(stkcatgroupId),"^",4)
	.s parrefcode=""
	.s:parrefdr'="" parrefcode=$p(^DHCSCG(parrefdr),"^",1)
	.i parrefcode=""  s parrefcode="0"
	.s Data=$lb(stkcatgroupId,scgdesc,parrefdr,2,0)
	.s ^CacheTemp(repid,ind)=Data    
	.s ind=ind+1
	s stkcatId="" 
	f  s stkcatId=$o(^INC("SC",stkcatId)) q:stkcatId=""  d
	.s code=$p(^INC("SC",stkcatId),"^",1)
	.s desc=$p(^INC("SC",stkcatId),"^",2)
	.s type=$p(^INC("SC",stkcatId),"^",3)
	.q:type'="M"
	.s stkcatgroupInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).StkCatGrpStr(stkcatId,"M")
	.s topcode=$p(stkcatgroupInfo,"^",1)
	.s topid=$p(stkcatgroupInfo,"^",5)
	.i topcode=""  s topcode="0"
	.s Data=$lb(stkcatId,desc,topid,1,1)
	.s ^CacheTemp(repid,ind)=Data    
	.s ind=ind+1
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.HRP.AccountStat","QueryInc")
/// Call web_DHCSTMHUI_HRP.QueryInc()
/// 查询物资信息
Query QueryInc() As web.DHCSTMHUI.Query(ROWSPEC = "INV_CODE,INV_NAME,MAT_TYPE_ID,INV_MODEL,AMORTIZE_TYPE,PRICE_TYPE,inv_id,inv_no") [ SqlName = QueryInc, SqlProc ]
{
}

ClassMethod QueryIncExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle,Params)
	;s ^zx("Params")=Params
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s HospId=..#HospId
	s COPYCODE=101
	s inciid="0"
	f  s inciid=$o(^INCI(inciid)) q:(inciid="")||(inciid="IB_EX")  d
	.;q:(inci'="")&&(inci'=inciid)
	.s incicode=$P(^INCI(inciid,1),"^",1)
	.s incidesc=$P(^INCI(inciid,1),"^",2)
	.s TmpIncCatId=$p(^INCI(inciid,2),"^",2)
	.q:'$d(^INC("SC",TmpIncCatId))
 	.s incscdesc=""
 	.s:TmpIncCatId'="" incscdesc=$p(^INC("SC",TmpIncCatId),"^",2)
	.s type=$p(^INC("SC",TmpIncCatId),"^",3)
	.s incscdesc=$p(^INC("SC",TmpIncCatId),"^",2)
	.q:type'="M"
	.s buom=$p(^INCI(inciid,1),"^",10)
 	.s puruom=$p(^INCI(inciid,3),"^",6)
 	.s buomdesc=$p(^CT("UOM",buom),"^",2)
 	.s puruomdesc=$p(^CT("UOM",puruom),"^",2)
 	.s pfac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(puruom,buom)
 	.s info=$o(^DHCITMINFO(0,"INCI",inciid,""))
 	.q:info=""
 	.s spec=$p($G(^DHCITMINFO(info)),"^",27)
 	.s brand=$p($G(^DHCITMINFO(info)),"^",58)
 	.s Model=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetModel(inciid)
 	.s ManfInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPbManf(+inciid)
	.s ManfId=$p(ManfInfo,"^",1)
 	.s Data=$lb(incicode,incidesc,"1000000"_TmpIncCatId,spec,ManfId,0,inciid,inciid)
	.s ^CacheTemp(repid,ind)=Data    
	.s ind=ind+1
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.HRP.AccountStat","GetInGdRec","2021-04-01","2021-06-07")
/// 查询入库退货主表信息
/// Call web_DHCSTMHUI_HRP.GetInGdRec("2021-04-01","2021-04-07")
Query GetInGdRec(st As %String, et As %String) As web.DHCSTMHUI.Query(ROWSPEC = "IN_ID:%String,IN_NO:%String,YEAR:%String,MONTH:%String,BUS_TYPE_CODE:%String,SUP_code:%String,STORE_code:%String,MAKER:%String,IN_DATE:%String,CHECKER:%String,CHECK_DATE:%String,CONFIRMER:%String,CONFIRM_DATE:%String,state:%String") [ SqlName = GetInGdRec, SqlProc ]
{
}

ClassMethod GetInGdRecExecute(ByRef qHandle As %Binary, st As %String, et As %String) As %Status
{
	n (qHandle,st,et)
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	s groupID=""
	s HospId=..#HospId
	s COPYCODE=101
	s st=$zdh(st,3)
	s et=$zdh(et,3)
	s SourceOfFund=""
	f dat=st:1:et d
	.s dhcingr=""
	.f  s dhcingr=$o(^DHCINGR(0,"DODate",dat,dhcingr)) q:dhcingr=""  d
	..s LocId=$p(^DHCINGR(dhcingr),"^",13)
	..q:(","_LocStr_",")'[(","_LocId_",")
    ..s ReqLoc=$p(^DHCINGR(dhcingr),"^",25)
    ..s LocDesc=$P(^CTLOC(LocId),"^",2)
    ..s LocCode=$P(^CTLOC(LocId),"^",1)
	..s ApcvmId=$p(^DHCINGR(dhcingr),"^",3)
	..s no=$p(^DHCINGR(dhcingr),"^",1)
	..s SourceOfFund=$p(^DHCINGR(dhcingr),"^",36)
	..s VenCode="",VenDesc=""
	..s:ApcvmId'="" VenDesc=$p(^APC("APCVM",ApcvmId),"^",3)
	..s:ApcvmId'="" VenCode=$p(^APC("APCVM",ApcvmId),"^",2)
	..s auditdate=$p(^DHCINGR(dhcingr),"^",4)
	..s:auditdate'="" auditdate=$zd(auditdate,3)
	..s auditflag=$p(^DHCINGR(dhcingr),"^",29)
	..s type=$p(^DHCINGR(dhcingr),"^",30)
	..s user=$p(^DHCINGR(dhcingr),"^",8)
	..s usercode=""
	..s:user'="" usercode=$p(^SSU("SSUSR",user),"^",1)
	..q:auditflag'="Y"
	..q:type'="M"
	..s year=$P(auditdate,"-",1)
	..s month=$P(auditdate,"-",2)
	..s typecode="2"
	..s inid="A"_dhcingr
	..s rpsum="0"
	..s INGRISub=""  f  s INGRISub=$o(^DHCINGR(dhcingr,"GRI",INGRISub))  q:INGRISub=""  d
	...s rp=$p(^DHCINGR(dhcingr,"GRI",INGRISub),"^",30)      ;进价
	...s rpsum=rpsum+rp
	..s Data=$lb(100000000_dhcingr,no,year,month,typecode,ApcvmId,LocId,4,auditdate,4,auditdate,4,auditdate,3)
	..s ^CacheTemp(repid,ind)=Data
	..s ind=ind+1 

	f dat=st:1:et d
	.s dhcingrt=""
	.f  s dhcingrt=$o(^INGRT(0,"AUDITDATE",dat,dhcingrt)) q:dhcingrt=""  d
	..s no=$p(^INGRT(dhcingrt),"^",1)
	..s ApcvmId=$p(^INGRT(dhcingrt),"^",2)
	..s type=$p(^INGRT(dhcingrt),"^",16)
	..s user=$p(^INGRT(dhcingrt),"^",8)
	..s auditdate=$p(^INGRT(dhcingrt),"^",9)
	..s:auditdate'="" auditdate=$zd(auditdate,3)
	..s auditflag=$p(^INGRT(dhcingrt),"^",15)
	..s LocId=$p(^INGRT(dhcingrt),"^",7)
	..q:(","_LocStr_",")'[(","_LocId_",")
    ..s LocDesc=$P(^CTLOC(LocId),"^",2)
    ..s LocCode=$P(^CTLOC(LocId),"^",1)
	..s VenCode="",VenDesc=""
	..s:ApcvmId'="" VenDesc=$p(^APC("APCVM",ApcvmId),"^",3)
	..s:ApcvmId'="" VenCode=$p(^APC("APCVM",ApcvmId),"^",2)
	..s usercode=""
	..s:user'="" usercode=$p(^SSU("SSUSR",user),"^",1)
	..q:auditflag'="Y"
	..q:type'="M"
	..s ch="" 
	..s year=$P(auditdate,"-",1)
	..s month=$P(auditdate,"-",2)
	..s typecode="12"
	..s inid="B"_dhcingrt
	..s rpsum="0"
	..s INGRTISub=""  f  s INGRTISub=$o(^INGRT(dhcingrt,"DHCGRR",INGRTISub))  q:INGRTISub=""  d
	...s rp=$p(^INGRT(dhcingrt,"DHCGRR",INGRTISub),"^",7)      ;进价
	...s rpsum=rpsum+rp
	..s Data=$lb(200000000_dhcingrt,no,year,month,typecode,ApcvmId,LocId,4,auditdate,4,auditdate,4,auditdate,3)
	..s ^CacheTemp(repid,ind)=Data
	..s ind=ind+1 
	
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.HRP.AccountStat","GetInGdRecDetail","2021-07-01","2021-07-31")
/// 查询入库退货明细
/// Call web_DHCSTMHUI_HRP.GetInGdRecDetail("2021-07-01","2021-07-31")
Query GetInGdRecDetail(st As %String, et As %String) As web.DHCSTMHUI.Query(ROWSPEC = "IN_ID:%String,IN_NO:%String,BATCH_NO:%String,PRICE:%String,AMOUNT:%String,AMOUNT_MONEY:%String,NOTE:%String,BATCH_SN:%String,inv_id:%String,inv_no:%String") [ SqlName = GetInGdRecDetail, SqlProc ]
{
}

ClassMethod GetInGdRecDetailExecute(ByRef qHandle As %Binary, st As %String, et As %String) As %Status
{
	n (qHandle,st,et)
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	s groupID=""
	s HospId=..#HospId
	s COPYCODE=101
	s st=$zdh(st,3)
	s et=$zdh(et,3)
	f dat=st:1:et d
	.s dhcingr=""
	.f  s dhcingr=$o(^DHCINGR(0,"DODate",dat,dhcingr)) q:dhcingr=""  d
	..s LocId=$p(^DHCINGR(dhcingr),"^",13)
	..q:(","_LocStr_",")'[(","_LocId_",")
    ..s ReqLoc=$p(^DHCINGR(dhcingr),"^",25)
    ..s LocDesc=$P(^CTLOC(LocId),"^",2)
    ..s LocCode=$P(^CTLOC(LocId),"^",1)
	..s ApcvmId=$p(^DHCINGR(dhcingr),"^",3)
	..s no=$p(^DHCINGR(dhcingr),"^",1)
	..s SourceOfFund=$p(^DHCINGR(dhcingr),"^",36)
	..s VenCode="",VenDesc=""
	..s:ApcvmId'="" VenDesc=$p(^APC("APCVM",ApcvmId),"^",3)
	..s:ApcvmId'="" VenCode=$p(^APC("APCVM",ApcvmId),"^",2)
	..s auditdate=$p(^DHCINGR(dhcingr),"^",4)
	..s:auditdate'="" auditdate=$zd(auditdate,3)
	..s auditflag=$p(^DHCINGR(dhcingr),"^",29)
	..s type=$p(^DHCINGR(dhcingr),"^",30)
	..s user=$p(^DHCINGR(dhcingr),"^",8)
	..s usercode=""
	..s:user'="" usercode=$p(^SSU("SSUSR",user),"^",1)
	..q:auditflag'="Y"
	..q:type'="M"
	..s ch="" 
	..f  s ch=$o(^DHCINGR(dhcingr,"GRI",ch)) q:ch=""  d
	...s inclb=$p(^DHCINGR(dhcingr,"GRI",ch),"^",1)
	...s Qty=$p(^DHCINGR(dhcingr,"GRI",ch),"^",4)
	...s uomdr=$p(^DHCINGR(dhcingr,"GRI",ch),"^",10)
	...s expdate=$p(^DHCINGR(dhcingr,"GRI",ch),"^",9)
	...s:expdate'="" expdate=$zd(expdate,3)
	...s batno=$p(^DHCINGR(dhcingr,"GRI",ch),"^",13)
	...s:batno="" batno=1
	...s Rp=$p(^DHCINGR(dhcingr,"GRI",ch),"^",30)
	...s Sp=Rp
	...s inci=+inclb
	...s incicode=$p(^INCI(inci,1),"^",1)
	...s incidesc=$P(^INCI(inci,1),"^",2)
	...s puruomdesc=$p(^CT("UOM",uomdr),"^",2)
	...s Rp=$fn(Rp,"",2)
	...s Data=$lb(100000000_dhcingr,no,batno,Rp,Qty,Rp*Qty,"",1,inci,inci)
	...s ^CacheTemp(repid,ind)=Data
	...s ind=ind+1
	
	f dat=st:1:et d
	.s dhcingrt=""
	.f  s dhcingrt=$o(^INGRT(0,"AUDITDATE",dat,dhcingrt)) q:dhcingrt=""  d
	..s no=$p(^INGRT(dhcingrt),"^",1)
	..
	..s ApcvmId=$p(^INGRT(dhcingrt),"^",2)
	..s type=$p(^INGRT(dhcingrt),"^",16)
	..s user=$p(^INGRT(dhcingrt),"^",8)
	..s auditdate=$p(^INGRT(dhcingrt),"^",9)
	..s:auditdate'="" auditdate=$zd(auditdate,3)
	..s auditflag=$p(^INGRT(dhcingrt),"^",15)
	..s LocId=$p(^INGRT(dhcingrt),"^",7)
	..q:(","_LocStr_",")'[(","_LocId_",")
    ..s LocDesc=$P(^CTLOC(LocId),"^",2)
    ..s LocCode=$P(^CTLOC(LocId),"^",1)
	..s VenCode="",VenDesc=""
	..s:ApcvmId'="" VenDesc=$p(^APC("APCVM",ApcvmId),"^",3)
	..s:ApcvmId'="" VenCode=$p(^APC("APCVM",ApcvmId),"^",2)
	..s usercode=""
	..s:user'="" usercode=$p(^SSU("SSUSR",user),"^",1)
	..q:auditflag'="Y"
	..q:type'="M"
	..s ch="" 
	..f  s ch=$o(^INGRT(dhcingrt,"DHCGRR",ch)) q:ch=""  d
	...s ingri=$p(^INGRT(dhcingrt,"DHCGRR",ch),"^",1)
	...q:ingri=""
	...s Qty=$p(^INGRT(dhcingrt,"DHCGRR",ch),"^",2)
	...s Qty=-Qty
	...s uomdr=$p(^INGRT(dhcingrt,"DHCGRR",ch),"^",3)
	...s expdate=""
	...s SourceOfFund=$p($g(^DHCINGR(+ingri)),"^",36)
	...s:expdate'="" expdate=$zd(expdate,3)
	...s batno=""
	...s:batno="" batno=1
	...s Rp=$p(^INGRT(dhcingrt,"DHCGRR",ch),"^",7)
	...s Rp=$fn(Rp,"",2)
	...s Sp=Rp
	...s inclb=$p(^DHCINGR(+ingri,"GRI",$p(ingri,"||",2)),"^",1)
	...s inci=+inclb
	...s incicode=$p(^INCI(inci,1),"^",1)
	...s incidesc=$P(^INCI(inci,1),"^",2)
	...s puruomdesc=$p(^CT("UOM",uomdr),"^",2)
	...s Data=$lb(200000000_dhcingrt,no,batno,Rp,Qty,Rp*Qty,"",1,inci,inci)
	...s ^CacheTemp(repid,ind)=Data
	...s ind=ind+1
	Quit $$$OK
}

/// 查询资金来源
/// Call web_DHCSTMHUI_HRP.GetSourceOfFund()
Query GetSourceOfFund(Params As %String) As web.DHCSTMHUI.Query(ROWSPEC = "RowId:%String,Description:%String") [ SqlName = GetSourceOfFund, SqlProc ]
{
}

ClassMethod GetSourceOfFundExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s groupID=""
	s HospId=..#HospId
	s COPYCODE=101
	s qHandle=$lb(0,repid,0)
	s Result = ##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	s SqlStr = "SELECT SOF_RowId AS RowId, SOF_Desc AS Description FROM DHC_SourceOfFund"
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s Description = Result.Data("Description")
		d OutPutSourceOfFundRow
	}
	d Result.Close()
	Quit $$$OK
OutPutSourceOfFundRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.HRP.AccountStat","GetDhcInIsTrfDetail","2021-03-01","2021-04-07")
/// 查询出库退库明细
/// Call web_DHCSTMHUI_HRP.GetDhcInIsTrfDetail("2021-04-01","2021-04-07")
Query GetDhcInIsTrfDetail(st As %String, et As %String) As web.DHCSTMHUI.Query(ROWSPEC = "OUT_ID:%String,OUT_NO:%String,BATCH_NO:%String,PRICE:%String,AMOUNT:%String,AMOUNT_MONEY:%String,NOTE:%String,inv_id,inv_no,BATCH_NO") [ SqlName = GetDhcInIsTrfDetail, SqlProc ]
{
}

ClassMethod GetDhcInIsTrfDetailExecute(ByRef qHandle As %Binary, st As %String, et As %String) As %Status
{
	n (qHandle,st,et)
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	s groupID=""
	s HospId=..#HospId
	s COPYCODE=101
	s st=$zdh(st,3)
	s et=$zdh(et,3)
	f dat=st:1:et d
	.s init=""
	.f  s init=$o(^DHCINIT(0,"AckDate",dat,init)) q:init=""  d
	..s no=$p(^DHCINIT(init),"^",1)
	..s initdate=$p(^DHCINIT(init),"^",2)
	..s:initdate'="" initdate=$zd(initdate,3)
	..s type=$p(^DHCINIT(init),"^",24)
	..s user=$p(^DHCINIT(init),"^",8)
	..s LocId=$p(^DHCINIT(init),"^",5)
    ..s LocDesc=$P(^CTLOC(LocId),"^",2)
    ..s LocCode=$P(^CTLOC(LocId),"^",1)
    ..s toLocId=$p(^DHCINIT(init),"^",6)
    ..q:((","_LocStr_",")'[(","_LocId_","))&&((","_LocStr_",")'[(","_toLocId_","))
    ..s toLocDesc=$P(^CTLOC(toLocId),"^",2)
    ..s toLocCode=$P(^CTLOC(toLocId),"^",1)
	..s usercode=""
	..s:user'="" usercode=$p(^SSU("SSUSR",user),"^",1)
	..s status=$p(^DHCINIT(init),"^",14)
	..q:(status'="21")&&(status'="31")
	..q:type'="M"
	..s ch=0
	..f  s ch=$o(^DHCINIT(init,"ITI",ch)) q:ch=""  d
	...s inclb=$p(^DHCINIT(init,"ITI",ch),"^",3)
	...s Qty=$p(^DHCINIT(init,"ITI",ch),"^",1)
	...s uomdr=$p(^DHCINIT(init,"ITI",ch),"^",7)
	...s Rp=$p(^DHCINIT(init,"ITI",ch),"^",15)
	...s Sp=Rp
	...s inci=+inclb
	...s incicode=$p(^INCI(inci,1),"^",1)
	...s incidesc=$P(^INCI(inci,1),"^",2)
	...s puruomdesc=$p(^CT("UOM",uomdr),"^",2)
	...s batno=""
	...s:batno="" batno="1234"
	...s Rp=$fn(Rp,"",2)
	...s Data=$lb(init,no,$g(batno),Rp,Qty,Rp*Qty,$g(note),inci,inci,1)
	...s ^CacheTemp(repid,ind)=Data
	...s ind=ind+1
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.HRP.AccountStat","GetDhcInIsTrf","2021-03-01","2021-11-07")
/// 查询出库退库主表信息
/// Call web_DHCSTMHUI_HRP.GetDhcInIsTrf("2021-04-01","2021-11-07")
Query GetDhcInIsTrf(st As %String, et As %String) As web.DHCSTMHUI.Query(ROWSPEC = "OUT_NO:%String,OUT_DATE:%String,BUS_TYPE_CODE:%String,STORE_CODE:%String,DEPT_CODE:%String,MAT_TYPE_CODE:%String,MONEY:%String") [ SqlName = GetDhcInIsTrf, SqlProc ]
{
}

ClassMethod GetDhcInIsTrfExecute(ByRef qHandle As %Binary, st As %String, et As %String) As %Status
{
	n (qHandle,st,et)
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	s groupID=""
	s HospId=..#HospId
	s COPYCODE=101
	k ^TMPHOUSC("HRPStat")
	s st=$zdh(st,3)
	s et=$zdh(et,3)
	f dat=st:1:et d
	.s init=""
	.f  s init=$o(^DHCINIT(0,"AckDate",dat,init)) q:init=""  d
	..s no=$p(^DHCINIT(init),"^",1)
	..s initdate=$p(^DHCINIT(init),"^",2)
	..s:initdate'="" initdate=$zd(initdate,3)
	..s type=$p(^DHCINIT(init),"^",24)
	..s user=$p(^DHCINIT(init),"^",8)
	..s LocId=$p(^DHCINIT(init),"^",5)
    ..s LocDesc=$P(^CTLOC(LocId),"^",2)
    ..s LocCode=$P(^CTLOC(LocId),"^",1)
    ..s toLocId=$p(^DHCINIT(init),"^",6)
    ..s kfcode="",kscode=""
    ..q:((","_LocStr_",")'[(","_LocId_","))&&((","_LocStr_",")'[(","_toLocId_","))
    ..s toLocDesc=$P(^CTLOC(toLocId),"^",2)
    ..s toLocCode=$P(^CTLOC(toLocId),"^",1)
	..s usercode=""
	..s:user'="" usercode=$p(^SSU("SSUSR",user),"^",1)
	..s status=$p(^DHCINIT(init),"^",14)
	..q:(status'="21")&&(status'="31")
	..q:type'="M"
	..i ((","_LocStr_",")[(","_LocId_",")) d
	...s typecode="01"
	...s kfcode=LocId
	...s kscode=toLocId
	..e  d
	...s typecode="02"
	...s kfcode=toLocId
	...s kscode=LocId
	..s ch="" 
	..s mainstr=init_","_no_","_initdate_","_typecode_","_kfcode_","_kscode
	..f  s ch=$o(^DHCINIT(init,"ITI",ch)) q:ch=""  d
	...s inclb=$p(^DHCINIT(init,"ITI",ch),"^",3)
	...q:inclb=""
	...s Qty=$p(^DHCINIT(init,"ITI",ch),"^",1)
	...s uomdr=$p(^DHCINIT(init,"ITI",ch),"^",7)
	...s Rp=$p(^DHCINIT(init,"ITI",ch),"^",15)
	...s RpAmt=Rp*Qty
	...s inci=+inclb
	...s tmpstkgrp=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inci,"M")
	...s TmpStkGrpId=$p(tmpstkgrp,"^",5)
	...s StkGrpDesc=$p(tmpstkgrp,"^",5)
	...i StkGrpDesc="" b ;
	...s:StkGrpDesc="" StkGrpDesc="其他"
	...i '$d(^TMPHOUSC("HRPStat",mainstr,StkGrpDesc)) d
	....s ^TMPHOUSC("HRPStat",mainstr,StkGrpDesc)=RpAmt
	...e  d
	....s ^TMPHOUSC("HRPStat",mainstr,StkGrpDesc)=^TMPHOUSC("HRPStat",mainstr,StkGrpDesc)+RpAmt
	q:'$d(^TMPHOUSC("HRPStat")) $$$OK
	s main=""
	f  s main=$O(^TMPHOUSC("HRPStat",main)) q:main=""  d
	.s stkdesc=""
	.f  s stkdesc=$O(^TMPHOUSC("HRPStat",main,stkdesc)) q:stkdesc=""  d
	..s RpAmt=^TMPHOUSC("HRPStat",main,stkdesc)
	..s no=$p(main,",",2)
	..s initdate=$p(main,",",3)
	..s typecode=$P(main,",",4)
	..s kfcode=$p(main,",",5)
	..s kscode=$p(main,",",6)
	..s Data=$lb(no,initdate,typecode,kfcode,kscode,stkdesc,RpAmt)
	..s ^CacheTemp(repid,ind)=Data
	..s ind=ind+1
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.HRP.AccountStat","GetInGdRec","2021-04-01","2021-06-07")
/// 查询入库退货资金来源
/// Call web_DHCSTMHUI_HRP.GetInGdRecZJ("2021-04-01","2021-04-07")
Query GetInGdRecNew(st As %String = "", et As %String = "") As web.DHCSTMHUI.Query(ROWSPEC = "IN_ID,SOURCE_ID,SOURCE_MONEY") [ SqlName = GetInGdRecZJ, SqlProc ]
{
}

ClassMethod GetInGdRecNewExecute(ByRef qHandle As %Binary, st As %String = "", et As %String = "") As %Status
{
	n (qHandle,st,et)
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	s groupID=""
	s HospId=2
	s COPYCODE=101
	s st=$zdh(st,3)
	s et=$zdh(et,3)
	s SourceOfFund=""
	f dat=st:1:et d
	.s dhcingr=""
	.f  s dhcingr=$o(^DHCINGR(0,"DODate",dat,dhcingr)) q:dhcingr=""  d
	..s LocId=$p(^DHCINGR(dhcingr),"^",13)
	..;q:LocId'=198
	..q:(","_LocStr_",")'[(","_LocId_",")
    ..s ReqLoc=$p(^DHCINGR(dhcingr),"^",25)
    ..s LocDesc=$P(^CTLOC(LocId),"^",2)
    ..s LocCode=$P(^CTLOC(LocId),"^",1)
	..s ApcvmId=$p(^DHCINGR(dhcingr),"^",3)
	..s no=$p(^DHCINGR(dhcingr),"^",1)
	..s SourceOfFund=$p(^DHCINGR(dhcingr),"^",36)
	..s VenCode="",VenDesc=""
	..s:ApcvmId'="" VenDesc=$p(^APC("APCVM",ApcvmId),"^",3)
	..s:ApcvmId'="" VenCode=$p(^APC("APCVM",ApcvmId),"^",2)
	..s auditdate=$p(^DHCINGR(dhcingr),"^",4)
	..s:auditdate'="" auditdate=$zd(auditdate,3)
	..s auditflag=$p(^DHCINGR(dhcingr),"^",29)
	..s type=$p(^DHCINGR(dhcingr),"^",30)
	..s user=$p(^DHCINGR(dhcingr),"^",8)
	..s usercode=""
	..s:user'="" usercode=$p(^SSU("SSUSR",user),"^",1)
	..q:auditflag'="Y"
	..q:type'="M"
	..s year=$P(auditdate,"-",1)
	..s month=$P(auditdate,"-",2)
	..s typecode="2"
	..s inid="A"_dhcingr
	..s rpsum="0"
	..s INGRISub=""  f  s INGRISub=$o(^DHCINGR(dhcingr,"GRI",INGRISub))  q:INGRISub=""  d
	...s rp=$p(^DHCINGR(dhcingr,"GRI",INGRISub),"^",30)      ;进价
	...s rpsum=rpsum+rp
	..s Data=$lb(100000000_dhcingr,"1",rpsum)
	..s ^CacheTemp(repid,ind)=Data
	..s ind=ind+1 

	f dat=st:1:et d
	.s dhcingrt=""
	.f  s dhcingrt=$o(^INGRT(0,"AUDITDATE",dat,dhcingrt)) q:dhcingrt=""  d
	..s no=$p(^INGRT(dhcingrt),"^",1)
	..s ApcvmId=$p(^INGRT(dhcingrt),"^",2)
	..s type=$p(^INGRT(dhcingrt),"^",16)
	..s user=$p(^INGRT(dhcingrt),"^",8)
	..s auditdate=$p(^INGRT(dhcingrt),"^",9)
	..s:auditdate'="" auditdate=$zd(auditdate,3)
	..s auditflag=$p(^INGRT(dhcingrt),"^",15)
	..s LocId=$p(^INGRT(dhcingrt),"^",7)
	..q:(","_LocStr_",")'[(","_LocId_",")
    ..s LocDesc=$P(^CTLOC(LocId),"^",2)
    ..s LocCode=$P(^CTLOC(LocId),"^",1)
	..s VenCode="",VenDesc=""
	..s:ApcvmId'="" VenDesc=$p(^APC("APCVM",ApcvmId),"^",3)
	..s:ApcvmId'="" VenCode=$p(^APC("APCVM",ApcvmId),"^",2)
	..s usercode=""
	..s:user'="" usercode=$p(^SSU("SSUSR",user),"^",1)
	..q:auditflag'="Y"
	..q:type'="M"
	..s ch="" 
	..s year=$P(auditdate,"-",1)
	..s month=$P(auditdate,"-",2)
	..s typecode="12"
	..s inid="B"_dhcingrt
	..s rpsum="0"
	..s INGRTISub=""  f  s INGRTISub=$o(^INGRT(dhcingrt,"DHCGRR",INGRTISub))  q:INGRTISub=""  d
	...s rp=$p(^INGRT(dhcingrt,"DHCGRR",INGRTISub),"^",7)      ;进价
	...s rpsum=rpsum+rp
	..s Data=$lb(200000000_dhcingrt,"1",rpsum)
	..s ^CacheTemp(repid,ind)=Data
	..s ind=ind+1 
	
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.HRP.AccountStat","GetDhcInIsTrf","2021-03-01","2021-04-07")
/// 查询出库退库主表资金来源
/// Call web_DHCSTMHUI_HRP.GetDhcInIsTrfZJ("2021-04-01","2021-04-07")
Query GetDhcInIsTrfNew(st As %String = "", et As %String = "", init As %String = "") As web.DHCSTMHUI.Query(ROWSPEC = "OUT_ID,SOURCE_ID,SOURCE_MONEY") [ SqlName = GetDhcInIsTrfZJ, SqlProc ]
{
}

ClassMethod GetDhcInIsTrfNewExecute(ByRef qHandle As %Binary, st As %String = "", et As %String = "", init As %String = "") As %Status
{
	n (qHandle,st,et,init)
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	s groupID=""
	s HospId=2
	s COPYCODE=101
	s st=$zdh(st,3)
	s et=$zdh(et,3)
	f dat=st:1:et d
	.s init=""
	.f  s init=$o(^DHCINIT(0,"AckDate",dat,init)) q:init=""  d
	..s no=$p(^DHCINIT(init),"^",1)
	..s initdate=$p(^DHCINIT(init),"^",2)
	..s:initdate'="" initdate=$zd(initdate,3)
	..s type=$p(^DHCINIT(init),"^",24)
	..s user=$p(^DHCINIT(init),"^",8)
	..s LocId=$p(^DHCINIT(init),"^",5)
    ..s LocDesc=$P(^CTLOC(LocId),"^",2)
    ..s LocCode=$P(^CTLOC(LocId),"^",1)
    ..s toLocId=$p(^DHCINIT(init),"^",6)
    ..q:((","_LocStr_",")'[(","_LocId_","))&&((","_LocStr_",")'[(","_toLocId_","))
    ..s toLocDesc=$P(^CTLOC(toLocId),"^",2)
    ..s toLocCode=$P(^CTLOC(toLocId),"^",1)
	..s usercode=""
	..s:user'="" usercode=$p(^SSU("SSUSR",user),"^",1)
	..s status=$p(^DHCINIT(init),"^",14)
	..q:(status'="21")&&(status'="31")
	..q:type'="M"
	..s ch="" 
	..s year=$p(initdate,"-",1)
	..s month=$p(initdate,"-",2)
	..s typecode="3"
	..s rpsum="0"
	..s INITI=""  f  s INITI=$o(^DHCINIT(init,"ITI",INITI))  q:INITI=""  d
	...s rp=$p(^DHCINIT(init,"ITI",INITI),"^",14) 
	...s rpsum=rpsum+rp
	..i ((","_LocStr_",")[(","_LocId_",")) d
	...s typecode="3"
	...s Data=$lb(init,"1",rpsum)
	..e  d
	...s typecode="21"
	...s Data=$lb(init,"1",rpsum)
	..s ^CacheTemp(repid,ind)=Data
	..s ind=ind+1
	
	
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.HRP.AccountStat",QueryVendor)
/// Call web_DHCSTMHUI_HRP.IncVendor()
Query QueryVendor(vendor As %String = "") As web.DHCSTMHUI.Query(ROWSPEC = "ven_code,ven_name") [ SqlName = IncVendor, SqlProc ]
{
}

ClassMethod QueryVendorExecute(ByRef qHandle As %Binary, vendor As %String = "") As %Status
{
	n (qHandle,vendor)
	;s ^zx("Params")=Params
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	s venid=""
	f  s venid=$o(^APC("APCVM",venid)) q:venid=""  d
	.s type=$P(^APC("APCVM",venid),"^",9)
	.q:type'="M"
	.s venDesc=$P(^APC("APCVM",venid),"^",3)
	
	.s Data=$lb(venid,venDesc)
	.s ^CacheTemp(repid,ind)=Data    
	.s ind=ind+1
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.HRP.AccountStat","QueryPackageDisp","2021-11-01","2021-11-26")
/// Call web_DHCSTMHUI_HRP.PackageDisp("2021-01-01","2021-11-11")
Query QueryPackageDisp(StartDate As %String = "", EndDate As %String = "") As %Query(ROWSPEC = "ACC_YEAR,ACC_MONTH,DEPT_CODE,MAT_CODE,MAT_NAME,MONEY") [ SqlName = PackageDisp, SqlProc ]
{
}

ClassMethod QueryPackageDispExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "") As %Status
{
	n (qHandle,StartDate,EndDate)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s pid=$i(^DHCSTMPID("PID"))
	k ^TMPHOUSC("CSSDDisp",pid)
	s ind=1
	s sql="SELECT main.cssdpdm_date as dispdate,main.CSSDPDM_ToLoc_DR as tolocdr ,main.CSSDPDM_ToLoc_DR->CTLOC_Desc as toLocName,main.CSSDPDM_FromLoc_Dr as FromLocdr,"
		_" main.CSSDPDM_FromLoc_Dr->CTLOC_Desc as FromLocName,"
		_" detail.CSSDPD_Package_DR as Packagedr,detail.CSSDPD_Package_DR->CSSDP_Desc as PackageName,detail.CSSDPD_DispPrice as UnitPrice,detail.CSSDPD_Qty as Qty"
		_" FROM CSSD_PackageDispMain main,cssd_packagedisp detail "
		_" where main.ID=detail.CSSDPD_Parref_DR "
		_" and CSSDPDM_ComplateFlag ='Y' and cssdpdm_date>='"_StartDate_"' and cssdpdm_date<='"_EndDate_"' "
	s result=##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(sql)
	d result.Execute()
	While(result.Next())
	{ 
		set tolocdr=result.Data("tolocdr")
		set toLocName=result.Data("toLocName")
		set FromLocdr=result.Data("FromLocdr")
		set FromLocName=result.Data("FromLocName")
		set Packagedr=result.Data("Packagedr")
		s PackageObject=##Class(User.CSSDPackage).%OpenId(Packagedr)
		set PackageName=result.Data("PackageName")
		set UnitPrice=result.Data("UnitPrice")
		set Qty=result.Data("Qty")
		set sumPrice=UnitPrice*Qty
		set dispdate=result.Data("dispdate")
		set dispdate=$zd(dispdate,3)
		set Year=$P(dispdate,"-",1)
		set Month=$P(dispdate,"-",2)
		s data=Year_","_Month_","_Packagedr_","_PackageName_","_tolocdr_","_toLocName
		i '$d(^TMPHOUSC("CSSDDisp",pid,data)) d
		.s ^TMPHOUSC("CSSDDisp",pid,data)=sumPrice
		e  d
		.s ^TMPHOUSC("CSSDDisp",pid,data)=^TMPHOUSC("CSSDDisp",pid,data)+sumPrice 
	}
	d result.Close()
	s str=""
	f  s str=$o(^TMPHOUSC("CSSDDisp",pid,str)) q:str=""  d
	.s sumPrice=^TMPHOUSC("CSSDDisp",pid,str)
	.s Year=$P(str,",",1)
	.s Month=$P(str,",",2)
	.s packagedr=$P(str,",",3)
	.s Desc=$P(str,",",4)
	.s LocId=$p(str,",",5)
	.s toLocDesc=$p(str,",",6)
	.s Data=$lb(Year,Month,LocId,packagedr,Desc,sumPrice)
	.s ^CacheTemp(repid,ind)=Data    
	.s ind=ind+1
	b ; end
	
	q $$$OK
}

ClassMethod QueryPackageDispClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPackageDispExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryPackageDispFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPackageDispExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" { 
	Set AtEnd=1
	Set Row=""
	}
	Else      { 
	Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
