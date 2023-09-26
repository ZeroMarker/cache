Class web.DHCSTMHUI.InsuMatCodeUpload Extends %RegisteredObject
{

Parameter UserId = 1;

/// 每次上传的最大数据条数
Parameter UpLoadCnt = 999;

/// 首先更新User.DHCDataExchangeLog这个错误日志类，对比更新
/// 写死后挂上任务 d ##class(web.DHCSTMHUI.InsuMatCodeUpload).Task() 用来推送前一天数据
/// CALL web_DHCSTMHUI.InsuMatCodeUpload_Method3501("2021-01-01","2021-01-30","2","","");
/// CALL web_DHCSTMHUI.InsuMatCodeUpload_Method3502("2021-01-01","2021-01-30","2","","");
/// CALL web_DHCSTMHUI.InsuMatCodeUpload_Method3503("2021-01-01","2021-01-30","2","","");
/// CALL web_DHCSTMHUI.InsuMatCodeUpload_Method3504("2021-01-01","2021-01-30","2","","");
/// CALL web_DHCSTMHUI.InsuMatCodeUpload_Method3505("2021-01-01","2021-01-30","2","","");
/// CALL web_DHCSTMHUI.InsuMatCodeUpload_Method3506("2021-01-01","2021-01-30","2","","");
/// w ##class(web.DHCSTMHUI.InsuMatCodeUpload).SendTask3501("2021-08-01","2022-10-01",2)
/// w ##class(web.DHCSTMHUI.InsuMatCodeUpload).SendTask3502("2021-08-01","2022-10-01",2) 
/// w ##class(web.DHCSTMHUI.InsuMatCodeUpload).SendTask3503("2021-08-01","2022-10-01",2) 
/// w ##class(web.DHCSTMHUI.InsuMatCodeUpload).SendTask3504("2021-08-01","2022-10-01",2) 
/// w ##class(web.DHCSTMHUI.InsuMatCodeUpload).SendTask3505("2021-08-01","2022-10-01",2) 
/// w ##class(web.DHCSTMHUI.InsuMatCodeUpload).SendTask3506("2021-08-01","2022-10-01",2) 
ClassMethod getHeadObj(code, hospid) As %Library.DynamicObject
{
	/// 动态拼接
	set Object=##class(%Library.DynamicObject).%New()
	s OrgCode=$p($g(^CT("HOSP",hospid)),"^",7)  //定点医疗机构代码
	s HospDesc=$p(^CT("HOSP",hospid),"^",2)
	s opterID=..#UserId
	s CurrDate=$zd(+$h,3)	
	s CurrTime=$zt($p($h,",",2),1)
	s CurrMaxNo=$i(^DHCDoc("InsuVerify",+$h))
	s CurrMaxNo=$e("0000",1,4-$l(CurrMaxNo))_CurrMaxNo
	s insuplcadmdvs="371301"
	s opter=$p($g(^SSU("SSUSR",opterID)),"^",1)
	s optername=$p($g(^SSU("SSUSR",opterID)),"^",2)
	do Object.%Set("infno",code)
	do Object.%Set("msgid",OrgCode_CurrMaxNo)   ;_$replace(CurrDate,"-","")_$replace(CurrTime,":","")
	do Object.%Set("insuplc_admdvs",insuplcadmdvs)
	do Object.%Set("mdtrtarea_admvs" ,"371399")
	do Object.%Set("recer_sys_code","CSDM")
	do Object.%Set("cainfo"        ,"")
	do Object.%Set("dev_no"        ,"")
	do Object.%Set("dev_safe_info" ,"")
	do Object.%Set("signtype"      ,"")
	do Object.%Set("infver"        ,"V1.0")
	do Object.%Set("opter_type"    ,"1")
	do Object.%Set("opter"         ,opter)
	do Object.%Set("opter_name"    ,optername)
	do Object.%Set("inf_time"      ,CurrDate_" "_CurrTime)
	do Object.%Set("fixmedins_code",OrgCode)
	do Object.%Set("fixmedins_name",HospDesc)
	do Object.%Set("sign_no"       ,"")
	q Object
}

Query Method3501(StartDate As %Date, EndDate As %Date, HospId As %String, OutRowId As %String = "", ExpDataAry As %DynamicArray = "") As websys.Query(ROWSPEC = "med_list_codg,fixmedins_hilist_id,fixmedins_hilist_name,rx_flag,invdate,inv_cnt,manu_lotnum,fixmedins_bchno,manu_date,expy_end,memo") [ SqlProc ]
{
}

ClassMethod Method3501Execute(ByRef qHandle As %Binary, StartDate As %Date, EndDate As %Date, HospId As %String, OutRowId As %String = "", ExpDataAry As %DynamicArray = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1 
	i (OutRowId="")||(OutRowId=$c(0)) s OutRowId=""
	s StartDate=$zdh(StartDate,3)
	q:StartDate="" $$$OK 
	s EndDate=$zdh(EndDate,3)
	q:EndDate="" $$$OK 
	s Pid=..NewPid()
	k ^TMP("DHCSTM","web.DHCSTMService.InsuMatCodeUpload","Method3501",Pid)
	f calcuDate=StartDate:1:EndDate d
	.s Inst=""
	.f  s Inst=$o(^DHCINST(0,"DATE",calcuDate,Inst)) q:Inst=""  d
	..s adjComplete=$p(^DHCINST(Inst),"^",14)
	..q:adjComplete'="Y"
	..s stktype=$p(^DHCINST(Inst),"^",34)
	..q:stktype'="M"
	..s Instloc=$p(^DHCINST(Inst),"^",5)
	..s hospdr=$P(^CTLOC(Instloc),"^",22)
	..q:HospId'=hospdr
    ..s Instlocdesc=$p(^CTLOC(Instloc),"^",2)
	..s ret=##class(web.DHCSTMHUI.InsuMatCodeMethod).Method3501(Inst,Pid,OutRowId,ExpDataAry)
    q:'$d(^TMP("DHCSTM","web.DHCSTMService.InsuMatCodeUpload","Method3501",Pid)) $$$OK
    s Main=""
    f  s Main=$o(^TMP("DHCSTM","web.DHCSTMService.InsuMatCodeUpload","Method3501",Pid,Main))  q:Main=""  d
    .s Detial=""
	.f  s Detial=$o(^TMP("DHCSTM","web.DHCSTMService.InsuMatCodeUpload","Method3501",Pid,Main,Detial))  q:Detial=""  d
	..s intrData=^TMP("DHCSTM","web.DHCSTMService.InsuMatCodeUpload","Method3501",Pid,Main,Detial)
	..s intrDataLth=$l(intrData,"^")
	..s intrData=$p(intrData,"^",1,intrDataLth-1)
	..d OutRow
	k ^TMP("DHCSTM","web.DHCSTMService.InsuMatCodeUpload","Method3501",Pid)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRow
	set Data=$LISTFROMSTRING(intrData,"^")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

/// D ##class(%ResultSet).RunQuery("web.DHCSTMHUI.InsuMatCodeUpload","Method3502","2019-02-01","2021-05-01","2")
Query Method3502(StartDate As %Date, EndDate As %Date, HospId As %String, OutRowId As %String = "", ExpDataAry As %DynamicArray) As websys.Query(ROWSPEC = "med_list_codg,inv_chg_type,fixmedins_hilist_id,fixmedins_hilist_name,fixmedins_bchno,pric,cnt,rx_flag,inv_chg_time,inv_chg_opter_name,memo,trdn_flag") [ SqlProc ]
{
}

ClassMethod Method3502Execute(ByRef qHandle As %Binary, StartDate As %Date, EndDate As %Date, HospId As %String, OutRowId As %String = "", ExpDataAry As %DynamicArray) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1 
	i (OutRowId="")||(OutRowId=$c(0)) s OutRowId=""
	s StartDate=$zdh(StartDate,3)
	q:StartDate="" $$$OK 
	s EndDate=$zdh(EndDate,3)
	q:EndDate="" $$$OK 
	s Pid=..NewPid()
	k ^TMP("DHCSTM","web.DHCSTMService.InsuMatCodeUpload","Method3502",Pid)
	f calcuDate=StartDate:1:EndDate d
	.s ret=##class(web.DHCSTMHUI.InsuMatCodeMethod).Method3502(calcuDate,Pid,OutRowId,ExpDataAry,HospId)
	q:'$d(^TMP("DHCSTM","web.DHCSTMService.InsuMatCodeUpload","Method3502",Pid)) $$$OK
	s Main=""
    f  s Main=$o(^TMP("DHCSTM","web.DHCSTMService.InsuMatCodeUpload","Method3502",Pid,Main))  q:Main=""  d
    .s Detial=""
	.f  s Detial=$o(^TMP("DHCSTM","web.DHCSTMService.InsuMatCodeUpload","Method3502",Pid,Main,Detial))  q:Detial=""  d
	..s intrData=^TMP("DHCSTM","web.DHCSTMService.InsuMatCodeUpload","Method3502",Pid,Main,Detial)
	..s intrDataLth=$l(intrData,"^")
	..s intrData=$p(intrData,"^",1,intrDataLth-1)
    ..d OutRow
    k ^TMP("DHCSTM","web.DHCSTMService.InsuMatCodeUpload","Method3502",Pid)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRow
	set Data=$LISTFROMSTRING(intrData,"^")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

Query Method3503(StartDate As %Date, EndDate As %Date, HospId As %String, OutRowId As %String = "", ExpDataAry As %DynamicArray) As websys.Query(ROWSPEC = "med_list_codg,fixmedins_hilist_id,fixmedins_hilist_name,dynt_no,fixmedins_bchno,spler_name,spler_pmtno,manu_lotnum,prodentp_name,aprvno,manu_date,expy_end,finl_trns_pric,purc_retn_cnt,purc_invo_codg,purc_invo_no,rx_flag,purc_retn_stoin_time,purc_retn_opter_name,prod_geay_flag,memo,spec,min_pacunt,pacunt,pac_cnt,rtal_pric") [ SqlProc ]
{
}

ClassMethod Method3503Execute(ByRef qHandle As %Binary, StartDate As %Date, EndDate As %Date, HospId As %String, OutRowId As %String = "", ExpDataAry As %DynamicArray) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1 
	i (OutRowId="")||(OutRowId=$c(0)) s OutRowId=""
	s StartDate=$zdh(StartDate,3)
	q:StartDate="" $$$OK 
	s EndDate=$zdh(EndDate,3)
	q:EndDate="" $$$OK 
	s Pid=..NewPid()
	k ^TMP("DHCSTM","web.DHCSTMService.InsuMatCodeUpload","Method3503",Pid)
	f calcuDate=StartDate:1:EndDate d
	.s Ingr=""
	.f  s Ingr=$o(^DHCINGR(0,"DODate",calcuDate,Ingr))  q:Ingr=""  d
	..s type=$p(^DHCINGR(Ingr),"^",30)
	..q:type'="M"
	..s LocId=$p(^DHCINGR(Ingr),"^",13)
	..s hospdr=$P(^CTLOC(LocId),"^",22)
	..q:HospId'=hospdr
	..s ret=##class(web.DHCSTMHUI.InsuMatCodeMethod).Method3503(Ingr,Pid,OutRowId,ExpDataAry,HospId)
	q:'$d(^TMP("DHCSTM","web.DHCSTMService.InsuMatCodeUpload","Method3503",Pid)) $$$OK
	s Main=""
    f  s Main=$o(^TMP("DHCSTM","web.DHCSTMService.InsuMatCodeUpload","Method3503",Pid,Main))  q:Main=""  d
    .s Detial=""
	.f  s Detial=$o(^TMP("DHCSTM","web.DHCSTMService.InsuMatCodeUpload","Method3503",Pid,Main,Detial))  q:Detial=""  d
	..s intrData=^TMP("DHCSTM","web.DHCSTMService.InsuMatCodeUpload","Method3503",Pid,Main,Detial)
	..s intrDataLth=$l(intrData,"^")
	..s intrData=$p(intrData,"^",1,intrDataLth-1)
    ..d OutRow
    k ^TMP("DHCSTM","web.DHCSTMService.InsuMatCodeUpload","Method3503",Pid)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRow
	set Data=$LISTFROMSTRING(intrData,"^")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

Query Method3504(StartDate As %Date, EndDate As %Date, HospId As %String, OutRowId As %String = "", ExpDataAry As %DynamicArray) As websys.Query(ROWSPEC = "med_list_codg,fixmedins_hilist_id,fixmedins_hilist_name,fixmedins_bchno,spler_name,spler_pmtno,manu_date,expy_end,finl_trns_pric,purc_retn_cnt,purc_invo_codg,purc_invo_no,rx_flag,purc_retn_stoin_time,purc_retn_opter_name,memo,medins_prod_purc_no,spec,min_pacunt,pac_cnt,pacunt,prdr_name,rtal_pric") [ SqlProc ]
{
}

ClassMethod Method3504Execute(ByRef qHandle As %Binary, StartDate As %Date, EndDate As %Date, HospId As %String, OutRowId As %String = "", ExpDataAry As %DynamicArray) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1 
	i (OutRowId="")||(OutRowId=$c(0)) s OutRowId=""
	s StartDate=$zdh(StartDate,3)
	q:StartDate="" $$$OK 
	s EndDate=$zdh(EndDate,3)
	q:EndDate="" $$$OK 
	s Pid=..NewPid()
	k ^TMP("DHCSTM","web.DHCSTMService.InsuMatCodeUpload","Method3504",Pid)
	f calcuDate=StartDate:1:EndDate d
	.s Ingrt=""
	.f  s Ingrt=$o(^INGRT(0,"AUDITDATE",calcuDate,Ingrt))  q:Ingrt=""  d
	..s type=$p(^INGRT(Ingrt),"^",16)
	..q:type'="M"
	..s LocId=$p(^INGRT(Ingrt),"^",7)
	..s hospdr=$P(^CTLOC(LocId),"^",22)
	..q:HospId'=hospdr
	..s ret=##class(web.DHCSTMHUI.InsuMatCodeMethod).Method3504(Ingrt,Pid,OutRowId,ExpDataAry,HospId)
	q:'$d(^TMP("DHCSTM","web.DHCSTMService.InsuMatCodeUpload","Method3504",Pid)) $$$OK
	s Main=""
    f  s Main=$o(^TMP("DHCSTM","web.DHCSTMService.InsuMatCodeUpload","Method3504",Pid,Main))  q:Main=""  d
    .s Detial=""
	.f  s Detial=$o(^TMP("DHCSTM","web.DHCSTMService.InsuMatCodeUpload","Method3504",Pid,Main,Detial))  q:Detial=""  d
	..s intrData=^TMP("DHCSTM","web.DHCSTMService.InsuMatCodeUpload","Method3504",Pid,Main,Detial)
	..s intrDataLth=$l(intrData,"^")
	..s intrData=$p(intrData,"^",1,intrDataLth-1)
    ..d OutRow
    k ^TMP("DHCSTM","web.DHCSTMService.InsuMatCodeUpload","Method3504",Pid)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRow
	set Data=$LISTFROMSTRING(intrData,"^")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

Query Method3505(StartDate As %Date, EndDate As %Date, HospId As %String, OutRowId As %String = "", ExpDataAry As %DynamicArray) As websys.Query(ROWSPEC = "med_list_codg,fixmedins_hilist_id,fixmedins_hilist_name,fixmedins_bchno,prsc_dr_cert_type,prsc_dr_certno,prsc_dr_name,phar_cert_type,phar_certno,phar_name,phar_prac_cert_no,hi_feesetl_type,setl_id,mdtrt_sn,psn_no,psn_cert_type,certno,psn_name,manu_lotnum,manu_date,expy_end,rx_flag,trdn_flag,finl_trns_pric,rxno,rx_circ_flag,rtal_docno,stoout_no,bchno,drug_trac_codg,drug_prod_barc,shelf_posi,sel_retn_cnt,sel_retn_time,sel_retn_opter_name,memo,spec,min_pacunt,pac_cnt,pacunt,prdr_name") [ SqlProc ]
{
}

ClassMethod Method3505Execute(ByRef qHandle As %Binary, StartDate As %Date, EndDate As %Date, HospId As %String, OutRowId As %String = "", ExpDataAry As %DynamicArray) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1 
	i (OutRowId="")||(OutRowId=$c(0)) s OutRowId=""
	s StartDate=$zdh(StartDate,3)
	q:StartDate="" $$$OK 
	s EndDate=$zdh(EndDate,3)
	q:EndDate="" $$$OK 
	s Pid=..NewPid()
	k ^TMP("DHCSTM","web.DHCSTMService.InsuMatCodeUpload","Method3505",Pid)
	f calcuDate=StartDate:1:EndDate d
	.s ret=##class(web.DHCSTMHUI.InsuMatCodeMethod).Method3505(calcuDate,Pid,HospId,OutRowId,ExpDataAry)
	q:'$d(^TMP("DHCSTM","web.DHCSTMService.InsuMatCodeUpload","Method3505",Pid)) $$$OK
	s Main=""
    f  s Main=$o(^TMP("DHCSTM","web.DHCSTMService.InsuMatCodeUpload","Method3505",Pid,Main))  q:Main=""  d
    .s Detial=""
	.f  s Detial=$o(^TMP("DHCSTM","web.DHCSTMService.InsuMatCodeUpload","Method3505",Pid,Main,Detial))  q:Detial=""  d
	..s intrData=^TMP("DHCSTM","web.DHCSTMService.InsuMatCodeUpload","Method3505",Pid,Main,Detial)
	..s intrDataLth=$l(intrData,"^")
	..s intrData=$p(intrData,"^",1,intrDataLth-1)
    ..d OutRow
    k ^TMP("DHCSTM","web.DHCSTMService.InsuMatCodeUpload","Method3505",Pid)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRow
	set Data=$LISTFROMSTRING(intrData,"^")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

Query Method3506(StartDate As %Date, EndDate As %Date, HospId As %String, OutRowId As %String = "", ExpDataAry As %DynamicArray) As websys.Query(ROWSPEC = "med_list_codg,fixmedins_hilist_id,fixmedins_hilist_name,fixmedins_bchno,setl_id,psn_no,psn_cert_type,certno,psn_name,manu_lotnum,manu_date,expy_end,rx_flag,trdn_flag,finl_trns_pric,sel_retn_cnt,sel_retn_time,sel_retn_opter_name,memo,medins_prod_sel_no") [ SqlProc ]
{
}

ClassMethod Method3506Execute(ByRef qHandle As %Binary, StartDate As %Date, EndDate As %Date, HospId As %String, OutRowId As %String = "", ExpDataAry As %DynamicArray) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1 
	i (OutRowId="")||(OutRowId=$c(0)) s OutRowId=""
	s StartDate=$zdh(StartDate,3)
	q:StartDate="" $$$OK 
	s EndDate=$zdh(EndDate,3)
	q:EndDate="" $$$OK 
	s Pid=..NewPid()
	k ^TMP("DHCSTM","web.DHCSTMService.InsuMatCodeUpload","Method3506",Pid)
	f calcuDate=StartDate:1:EndDate d
	.s ret=##class(web.DHCSTMHUI.InsuMatCodeMethod).Method3506(calcuDate,Pid,HospId,OutRowId,ExpDataAry)
	q:'$d(^TMP("DHCSTM","web.DHCSTMService.InsuMatCodeUpload","Method3506",Pid)) $$$OK
	
	s Main=""
    f  s Main=$o(^TMP("DHCSTM","web.DHCSTMService.InsuMatCodeUpload","Method3506",Pid,Main))  q:Main=""  d
    .s Detial=""
	.f  s Detial=$o(^TMP("DHCSTM","web.DHCSTMService.InsuMatCodeUpload","Method3506",Pid,Main,Detial))  q:Detial=""  d
	..s intrData=^TMP("DHCSTM","web.DHCSTMService.InsuMatCodeUpload","Method3506",Pid,Main,Detial)
	..s intrDataLth=$l(intrData,"^")
	..s intrData=$p(intrData,"^",1,intrDataLth-1)
    ..d OutRow
    k ^TMP("DHCSTM","web.DHCSTMService.InsuMatCodeUpload","Method3506",Pid)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRow
	set Data=$LISTFROMSTRING(intrData,"^")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod NewPid() As %String
{
  	Q $I(^DHCSTMPID("DHCSTM",$this))
}

/// task3501
/// housc
/// 【3501】商品盘存上传
/// w ##class(web.DHCSTMHUI.InsuMatCodeUpload).SendTask3501("2019-09-23","2022-09-23",2)
ClassMethod SendTask3501(StartDate As %Date, EndDate As %Date, HospId As %String) As %String
{
	SET rs=##class(%ResultSet).%New()
	SET rs.ClassName="web.DHCSTMHUI.InsuMatCodeUpload"
	set rs.QueryName="Method3501"
	DO rs.Execute(StartDate,EndDate,HospId,"","")
	s count=0
	s UpLoadCnt=..#UpLoadCnt
	While rs.Next(.sc) {
		s medlistcodg=rs.Data("med_list_codg")  ; 
		s fixmedinshilistid=rs.Data("fixmedins_hilist_id") ; 
		s hilistname=rs.Data("fixmedins_hilist_name") ; 
		s rxflag=rs.Data("rx_flag")  ; 
		s invdate=rs.Data("invdate") ; 
		s invcnt=rs.Data("inv_cnt")  ; 
		s lotnum=rs.Data("manu_lotnum") ; 
		s bchno=rs.Data("fixmedins_bchno") ; 
		s manudate=rs.Data("manu_date")  ; 
		s expyend=rs.Data("expy_end") ;
		s memo=rs.Data("memo") ;
		s HeadObj=##class(%Library.DynamicObject).%New()
		s content=##class(%Library.DynamicObject).%New()
		s HeadObj=..getHeadObj("3501",HospId)
		set Item=##class(%Library.DynamicObject).%New()
		do Item.%Set("med_list_codg",medlistcodg)
		do Item.%Set("fixmedins_hilist_id",fixmedinshilistid)
		do Item.%Set("fixmedins_hilist_name",hilistname)
		do Item.%Set("rx_flag",rxflag)
		do Item.%Set("invdate",invdate)
		do Item.%Set("inv_cnt",invcnt)
		do Item.%Set("manu_lotnum",lotnum)
		do Item.%Set("fixmedins_bchno",bchno)
		do Item.%Set("manu_date",manudate)
		do Item.%Set("expy_end",expyend)
		do Item.%Set("memo",memo)
		do content.%Set("invinfo",Item)
		do HeadObj.%Set("input",content)
		s stream=##class(%GlobalCharacterStream).%New()
		do HeadObj.%ToJSON(.stream)
		set ret="1"
		s LogRowId=""
		s ret=..SaveLog(.LogRowId,"","3501","INSU.OFFBIZ.BL.BIZ00A","INSUAPI",stream,HospId)
		s res=##class(INSU.OFFBIZ.BL.BIZ00A).INSUAPI(stream,HospId)
		s ret=..SaveLog(.LogRowId,res,"3501","INSU.OFFBIZ.BL.BIZ00A","INSUAPI",stream,HospId)
	}
	q 0
}

/// task3502
/// housc
/// 【3502】商品库存变更(调整，报损，出库)
/// w ##class(web.DHCSTMHUI.InsuMatCodeUpload).SendTask3502("2021-01-01","2022-10-01",2)
ClassMethod SendTask3502(StartDate As %Date, EndDate As %Date, HospId As %String) As %String
{
	SET rs=##class(%ResultSet).%New()
	SET rs.ClassName="web.DHCSTMHUI.InsuMatCodeUpload"
	set rs.QueryName="Method3502"
	DO rs.Execute(StartDate,EndDate,HospId,"","")
	While rs.Next(.sc) {
		s medlistcodg=rs.Data("med_list_codg")  ; 
		continue:medlistcodg=""
		s invchgtype=rs.Data("inv_chg_type") ; 
		s fixmedinshilistid=rs.Data("fixmedins_hilist_id") ; 
		s fixmedinshilistname=rs.Data("fixmedins_hilist_name")  ; 
		s bchno=rs.Data("fixmedins_bchno") ; 
		s pric=rs.Data("pric")  ; 
		s cnt=rs.Data("cnt") ; 
		s rxflag=rs.Data("rx_flag") ; 
		s invchgtime=rs.Data("inv_chg_time")  ; 
		s optername=rs.Data("inv_chg_opter_name") ;
		s trdnflag=rs.Data("trdn_flag") ;
		s memo=rs.Data("memo") ;
		s HeadObj=##class(%Library.DynamicObject).%New()
		s content=##class(%Library.DynamicObject).%New()
		s HeadObj=..getHeadObj("3502",HospId)
		set Item=##class(%Library.DynamicObject).%New()
		do Item.%Set("med_list_codg",medlistcodg)
		do Item.%Set("inv_chg_type",invchgtype)
		do Item.%Set("fixmedins_hilist_id",fixmedinshilistid)
		do Item.%Set("fixmedins_hilist_name",fixmedinshilistname)
		do Item.%Set("fixmedins_bchno",bchno)
		do Item.%Set("pric",pric)
		do Item.%Set("cnt",cnt)
		do Item.%Set("rx_flag",rxflag)
		do Item.%Set("inv_chg_time",invchgtime)
		do Item.%Set("inv_chg_opter_name",optername)
		do Item.%Set("trdn_flag",trdnflag)
		do Item.%Set("memo",memo)
		do content.%Set("invinfo",Item)
		do HeadObj.%Set("input",content)
		s stream=##class(%GlobalCharacterStream).%New()
		do HeadObj.%ToJSON(.stream)
		s LogRowId=""
		s ret=..SaveLog(.LogRowId,"","商品库存变更3502","INSU.OFFBIZ.BL.BIZ00A","INSUAPI",stream,HospId)
		s res=##class(INSU.OFFBIZ.BL.BIZ00A).INSUAPI(stream,HospId)
		s ret=..SaveLog(.LogRowId,res,"商品库存变更3502","INSU.OFFBIZ.BL.BIZ00A","INSUAPI",stream,HospId)
	}
	q 0
}

/// task3503
/// housc
/// 【3503】商品采购
/// w ##class(web.DHCSTMHUI.InsuMatCodeUpload).SendTask3503("2019-09-23","2022-09-23",2)
ClassMethod SendTask3503(StartDate As %Date, EndDate As %Date, HospId As %String) As %String
{
	SET rs=##class(%ResultSet).%New()
	SET rs.ClassName="web.DHCSTMHUI.InsuMatCodeUpload"
	set rs.QueryName="Method3503"
	DO rs.Execute(StartDate,EndDate,HospId,"","")
	s count=0
	While rs.Next(.sc) {
		s medlistcodg=rs.Data("med_list_codg")  ; 
		continue:medlistcodg=""
		s fixmedinshilistid=rs.Data("fixmedins_hilist_id") ; 
		s fixmedinshilistname=rs.Data("fixmedins_hilist_name")  ; 
		s dyntno=rs.Data("dynt_no")  ; 
		s bchno=rs.Data("fixmedins_bchno") ; 
		s splername=rs.Data("spler_name")  ; 
		s splerpmtno=rs.Data("spler_pmtno") ; 
		s manulotnum=rs.Data("manu_lotnum") ; 
		s prdrname=rs.Data("prodentp_name")  ; 
		s aprvno=rs.Data("aprvno") ;
		s manudate=rs.Data("manu_date") ;
		s expyend=rs.Data("expy_end") ;
		s finltrnspric=rs.Data("finl_trns_pric")  ; 
		s purcretncnt=rs.Data("purc_retn_cnt") ; 
		s purcinvocodg=rs.Data("purc_invo_codg")  ; 
		s purcinvono=rs.Data("purc_invo_no") ; 
		s rxflag=rs.Data("rx_flag") ; 
		s purcretnstointime=rs.Data("purc_retn_stoin_time")  ; 
		s purcretnoptername=rs.Data("purc_retn_opter_name") ;
		s prodgeayflag=rs.Data("prod_geay_flag") ;
		s memo=rs.Data("memo") ;
		s HeadObj=##class(%Library.DynamicObject).%New()
		s content=##class(%Library.DynamicObject).%New()
		s count=count+1
		s HeadObj=..getHeadObj("3503",HospId)
		set Item=##class(%Library.DynamicObject).%New()
		do Item.%Set("med_list_codg",medlistcodg)
		do Item.%Set("fixmedins_hilist_id",fixmedinshilistid)
		do Item.%Set("fixmedins_hilist_name",fixmedinshilistname)
		do Item.%Set("dynt_no",dyntno)
		do Item.%Set("fixmedins_bchno",bchno)
		do Item.%Set("spler_name",splername)
		do Item.%Set("spler_pmtno",splerpmtno)
		do Item.%Set("manu_lotnum",manulotnum)
		do Item.%Set("prodentp_name",prdrname)
		do Item.%Set("aprvno",aprvno)
		do Item.%Set("manu_date",manudate)
		do Item.%Set("expy_end",expyend)
		do Item.%Set("finl_trns_pric",finltrnspric)
		do Item.%Set("purc_retn_cnt",purcretncnt)
		do Item.%Set("purc_invo_codg",purcinvocodg)
		do Item.%Set("purc_invo_no",purcinvono)
		do Item.%Set("rx_flag",rxflag)
		do Item.%Set("purc_retn_stoin_time",purcretnstointime)
		do Item.%Set("purc_retn_opter_name",purcretnoptername)
		do Item.%Set("prod_geay_flag",prodgeayflag)
		do Item.%Set("memo",memo)
		do content.%Set("purcinfo",Item)
		do HeadObj.%Set("input",content)
		s stream=##class(%GlobalCharacterStream).%New()
		do HeadObj.%ToJSON(.stream)
		s LogRowId=""
		s ret=..SaveLog(.LogRowId,"","3503","INSU.OFFBIZ.BL.BIZ00A","INSUAPI",stream,HospId)
		s res=##class(INSU.OFFBIZ.BL.BIZ00A).INSUAPI(stream,HospId)
		s ret=..SaveLog(.LogRowId,res,"35063","INSU.OFFBIZ.BL.BIZ00A","INSUAPI",stream,HospId)
		
	}
	q 0
}

/// task3504
/// housc
/// 【3504】商品采购退货
/// w ##class(web.DHCSTMHUI.InsuMatCodeUpload).SendTask3504("2019-09-21","2022-10-01",2)
ClassMethod SendTask3504(StartDate As %Date, EndDate As %Date, HospId As %String) As %String
{
	SET rs=##class(%ResultSet).%New()
	//med_list_codg,fixmedins_hilist_id,fixmedins_hilist_name,fixmedins_bchno,spler_name,spler_pmtno,manu_date,
	//expy_end,finl_trns_pric,purc_retn_cnt,
	//purc_invo_codg,purc_invo_no,rx_flag,purc_retn_stoin_time,purc_retn_opter_name,memo,medins_prod_purc_no
	SET rs.ClassName="web.DHCSTMHUI.InsuMatCodeUpload"
	set rs.QueryName="Method3504"
	DO rs.Execute(StartDate,EndDate,HospId,"","")
	s count=0
	While rs.Next(.sc) {
		s count=count+1
		s medlistcodg=rs.Data("med_list_codg")  ; 
		continue:medlistcodg=""
		s fixmedinshilistid=rs.Data("fixmedins_hilist_id") ; 
		s fixmedinshilistname=rs.Data("fixmedins_hilist_name")  ; 
		s bchno=rs.Data("fixmedins_bchno") ; 
		s splername=rs.Data("spler_name")  ; 
		s splerpmtno=rs.Data("spler_pmtno") ; 
		s manudate=rs.Data("manu_date") ; 
		s expyend=rs.Data("expy_end")  ; 
		s finltrnspric=rs.Data("finl_trns_pric") ;
		s purcretncnt=rs.Data("purc_retn_cnt") ;
		s purcinvocodg=rs.Data("purc_invo_codg") ;
		s purcinvono=rs.Data("purc_invo_no")  ; 
		s rxflag=rs.Data("rx_flag") ; 
		s purcretnstointime=rs.Data("purc_retn_stoin_time")  ; 
		s purcretnoptername=rs.Data("purc_retn_opter_name") ; 
		s memo=rs.Data("memo") ; 
		s spec=rs.Data("spec") 
		s minpacunt=rs.Data("min_pacunt") 
		s paccnt=rs.Data("pac_cnt") 
		s pacunt=rs.Data("pacunt") 
		s prdrname=rs.Data("prdr_name") 
		s rtalpric=rs.Data("rtal_pric") 
		s medinsprodpurcno=rs.Data("medins_prod_purc_no")  ; 
		s HeadObj=##class(%Library.DynamicObject).%New()
		s content=##class(%Library.DynamicObject).%New()
		s HeadObj=..getHeadObj("3504",HospId)
		set Item=##class(%Library.DynamicObject).%New()
		do Item.%Set("med_list_codg",medlistcodg)
		do Item.%Set("fixmedins_hilist_id",fixmedinshilistid)
		do Item.%Set("fixmedins_hilist_name",fixmedinshilistname)
		do Item.%Set("fixmedins_bchno",bchno)
		do Item.%Set("spler_name",splername)
		do Item.%Set("spler_pmtno",splerpmtno)
		do Item.%Set("manu_date",manudate)
		do Item.%Set("expy_end",expyend)
		do Item.%Set("finl_trns_pric",finltrnspric)
		do Item.%Set("purc_retn_cnt",purcretncnt)
		do Item.%Set("purc_invo_codg",purcinvocodg)
		do Item.%Set("purc_invo_no",purcinvono)
		do Item.%Set("rx_flag",rxflag)
		do Item.%Set("purc_retn_stoin_time",purcretnstointime)
		do Item.%Set("purc_retn_opter_name",purcretnoptername)
		do Item.%Set("memo",memo)
		do Item.%Set("medins_prod_purc_no",medinsprodpurcno)
		do Item.%Set("spec",spec)
		do Item.%Set("min_pacunt",minpacunt)
		do Item.%Set("pac_cnt",paccnt)
		do Item.%Set("pacunt",pacunt)
		do Item.%Set("prdr_name",prdrname)
		do Item.%Set("rtal_pric",rtalpric)
		do content.%Set("purcinfo",Item)
		do HeadObj.%Set("input",content)
		s stream=##class(%GlobalCharacterStream).%New()
		do HeadObj.%ToJSON(.stream)
		s LogRowId=""
		s ret=..SaveLog(.LogRowId,"","3504","INSU.OFFBIZ.BL.BIZ00A","INSUAPI",stream,HospId)
		s res=##class(INSU.OFFBIZ.BL.BIZ00A).INSUAPI(stream,HospId)
		s ret=..SaveLog(.LogRowId,res,"3504","INSU.OFFBIZ.BL.BIZ00A","INSUAPI",stream,HospId)
	}
	q 0
}

/// task3505
/// housc
/// 【3505】商品销售
/// w ##class(web.DHCSTMHUI.InsuMatCodeUpload).SendTask3505("2021-09-01","2022-10-01",2)
ClassMethod SendTask3505(StartDate As %Date, EndDate As %Date, HospId As %String) As %String
{
	SET rs=##class(%ResultSet).%New()
	SET rs.ClassName="web.DHCSTMHUI.InsuMatCodeUpload"
	set rs.QueryName="Method3505"
	DO rs.Execute(StartDate,EndDate,HospId,"","")
	s count=0
	While rs.Next(.sc) {
		s count=count+1
		s medlistcodg=rs.Data("med_list_codg")  ; 
		continue:medlistcodg=""
		s fixmedinshilistid=rs.Data("fixmedins_hilist_id") ; 
		s fixmedinshilistname=rs.Data("fixmedins_hilist_name")  ; 
		s bchno=rs.Data("fixmedins_bchno") ; 
		s prscdrcerttype=rs.Data("prsc_dr_cert_type")  ; 
		s pharcertno=rs.Data("phar_certno") ; 
		s pharname=rs.Data("phar_name") ; 
		s pharpraccertno=rs.Data("phar_prac_cert_no")  ; 
		s hifeesetltype=rs.Data("hi_feesetl_type") ;
		s setlid=rs.Data("setl_id") ;
		s mdtrtsn=rs.Data("mdtrt_sn") ;
		s psnno=rs.Data("psn_no")  ; 
		s psncerttype=rs.Data("psn_cert_type") ; 
		s certno=rs.Data("certno")  ; 
		s psnname=rs.Data("psn_name") ; 
		s manulotnum=rs.Data("manu_lotnum") ; 
		s manudate=rs.Data("manu_date")  ; 
		s expyend=rs.Data("expy_end") ; 
		s rxflag=rs.Data("rx_flag") ; 
		s trdnflag=rs.Data("trdn_flag")  ; 
		s finltrnspric=rs.Data("finl_trns_pric") ; 
		s rxno=rs.Data("rxno") ; 
		s rxcircflag=rs.Data("rx_circ_flag")  ; 
		s rtaldocno=rs.Data("rtal_docno")  ; 
		s stooutno=rs.Data("stoout_no") ; 
		s bchno=rs.Data("bchno")  ; 
		s drugtraccodg=rs.Data("drug_trac_codg")  ;
		s drugprodbarc=rs.Data("drug_prod_barc") ; 
		s shelfposi=rs.Data("shelf_posi")  ; 
		s selretncnt=rs.Data("sel_retn_cnt")  ; 
		s selretntime=rs.Data("sel_retn_time") ; 
		s selretnoptername=rs.Data("sel_retn_opter_name")  ; 
		s memo=rs.Data("memo") ; 
		s spec=rs.Data("spec")
		s minpacunt=rs.Data("min_pacunt")
		s paccnt=rs.Data("pac_cnt")
		s pacunt=rs.Data("pacunt")
		s prdrname=rs.Data("prdr_name")
		s HeadObj=##class(%Library.DynamicObject).%New()
		s content=##class(%Library.DynamicObject).%New()
		s HeadObj=..getHeadObj("3505",HospId)
		set Item=##class(%Library.DynamicObject).%New()
		do Item.%Set("med_list_codg",medlistcodg)
		do Item.%Set("fixmedins_hilist_id",fixmedinshilistid)
		do Item.%Set("fixmedins_hilist_name",fixmedinshilistname)
		do Item.%Set("fixmedins_bchno",bchno)
		do Item.%Set("prsc_dr_cert_type",prscdrcerttype)
		do Item.%Set("phar_certno",pharcertno)
		do Item.%Set("phar_name",pharname)
		do Item.%Set("phar_prac_cert_no",pharpraccertno)
		do Item.%Set("hi_feesetl_type",hifeesetltype)
		do Item.%Set("setl_id",setlid)
		do Item.%Set("mdtrt_sn",mdtrtsn)
		do Item.%Set("psn_no",psnno)
		do Item.%Set("psn_cert_type",psncerttype)
		do Item.%Set("certno",certno)
		do Item.%Set("psn_name",psnname)
		do Item.%Set("manu_lotnum",manulotnum)
		do Item.%Set("manu_date",manudate)
		do Item.%Set("expy_end",expyend)
		do Item.%Set("rx_flag",rxflag)
		do Item.%Set("trdn_flag",trdnflag)
		do Item.%Set("finl_trns_pric",finltrnspric)
		do Item.%Set("rxno",rxno)
		do Item.%Set("rx_circ_flag",rxcircflag)
		do Item.%Set("rtal_docno",rtaldocno)
		do Item.%Set("stoout_no",stooutno)
		do Item.%Set("bchno",bchno)
		do Item.%Set("drug_trac_codg",drugtraccodg)
		do Item.%Set("drug_prod_barc",drugprodbarc)
		do Item.%Set("shelf_posi",shelfposi)
		do Item.%Set("sel_retn_cnt",selretncnt)
		do Item.%Set("sel_retn_time",selretntime)
		do Item.%Set("sel_retn_opter_name",selretnoptername)
		do Item.%Set("memo",memo)
		do Item.%Set("spec",spec)
		do Item.%Set("min_pacunt",minpacunt)
		do Item.%Set("pac_cnt",paccnt)
		do Item.%Set("pacunt",pacunt)
		do Item.%Set("prdr_name",prdrname)
		do content.%Set("purcinfo",Item)
		do HeadObj.%Set("input",content)
		s stream=##class(%GlobalCharacterStream).%New()
		do HeadObj.%ToJSON(.stream)
		s LogRowId=""
		s ret=..SaveLog(.LogRowId,"","3505","INSU.OFFBIZ.BL.BIZ00A","INSUAPI",stream,HospId)
		s res=##class(INSU.OFFBIZ.BL.BIZ00A).INSUAPI(stream,HospId)
		s ret=..SaveLog(.LogRowId,res,"3505","INSU.OFFBIZ.BL.BIZ00A","INSUAPI",stream,HospId)
	}
	q 0
}

/// task3506
/// housc
/// 【3506】商品销售退货
/// w ##class(web.DHCSTMHUI.InsuMatCodeUpload).SendTask3506("2021-09-21","2022-10-01",2)
ClassMethod SendTask3506(StartDate As %Date, EndDate As %Date, HospId As %String) As %String
{
	SET rs=##class(%ResultSet).%New()
	SET rs.ClassName="web.DHCSTMHUI.InsuMatCodeUpload"
	set rs.QueryName="Method3505"
	DO rs.Execute(StartDate,EndDate,HospId,"","")
	s count=0
	While rs.Next(.sc) {
		s count=count+1
		s medlistcodg=rs.Data("med_list_codg")  ; 
		continue:medlistcodg=""
		s fixmedinshilistid=rs.Data("fixmedins_hilist_id") ; 
		s fixmedinshilistname=rs.Data("fixmedins_hilist_name")  ; 
		s bchno=rs.Data("fixmedins_bchno") ; 
		s setlid=rs.Data("setl_id") ;
		s psnno=rs.Data("psn_no")  ; 
		s psncerttype=rs.Data("psn_cert_type") ; 
		s certno=rs.Data("certno")  ; 
		s psnname=rs.Data("psn_name") ; 
		s manulotnum=rs.Data("manu_lotnum") ; 
		s manudate=rs.Data("manu_date")  ; 
		s expyend=rs.Data("expy_end") ; 
		s rxflag=rs.Data("rx_flag") ; 
		s trdnflag=rs.Data("trdn_flag")  ; 
		s finltrnspric=rs.Data("finl_trns_pric") ; 
		s selretncnt=rs.Data("sel_retn_cnt")  ; 
		s selretntime=rs.Data("sel_retn_time") ; 
		s selretnoptername=rs.Data("sel_retn_opter_name")  ; 
		s memo=rs.Data("memo") ; 
		;s medinsprodselno=rs.Data("medins_prod_sel_no") ; 
		s medinsprodselno=""
		s HeadObj=##class(%Library.DynamicObject).%New()
		s content=##class(%Library.DynamicObject).%New()
		s HeadObj=..getHeadObj("3506",HospId)
		set Item=##class(%Library.DynamicObject).%New()
		do Item.%Set("med_list_codg",medlistcodg)
		do Item.%Set("fixmedins_hilist_id",fixmedinshilistid)
		do Item.%Set("fixmedins_hilist_name",fixmedinshilistname)
		do Item.%Set("fixmedins_bchno",bchno)
		do Item.%Set("setl_id",setlid)
		do Item.%Set("psn_no",psnno)
		do Item.%Set("psn_cert_type",psncerttype)
		do Item.%Set("certno",certno)
		do Item.%Set("psn_name",psnname)
		do Item.%Set("manu_lotnum",manulotnum)
		do Item.%Set("manu_date",manudate)
		do Item.%Set("expy_end",expyend)
		do Item.%Set("rx_flag",rxflag)
		do Item.%Set("trdn_flag",trdnflag)
		do Item.%Set("finl_trns_pric",finltrnspric)
		do Item.%Set("sel_retn_cnt",selretncnt)
		do Item.%Set("sel_retn_time",selretntime)
		do Item.%Set("sel_retn_opter_name",selretnoptername)
		do Item.%Set("memo",memo)
		do Item.%Set("medins_prod_sel_no",medinsprodselno)
		do content.%Set("purcinfo",Item)
		do HeadObj.%Set("input",content)
		s stream=##class(%GlobalCharacterStream).%New()
		do HeadObj.%ToJSON(.stream)
		s LogRowId=""
		s ret=..SaveLog(.LogRowId,"","3506","INSU.OFFBIZ.BL.BIZ00A","INSUAPI",stream,HospId)
		s res=##class(INSU.OFFBIZ.BL.BIZ00A).INSUAPI(stream,HospId)
		s ret=..SaveLog(.LogRowId,res,"3506","INSU.OFFBIZ.BL.BIZ00A","INSUAPI",stream,HospId)
	}
	q 0
}

/// w ##class(web.DHCSTMHUI.InsuMatCodeUpload).Task()
ClassMethod Task()
{
	s hospid=""
	s st=$zd(+$H-1,3)
	s et=$zd(+$H-1,3)
	f  s hospid=$o(^CT("HOSP",hospid)) q:hospid=""  d
	.s datefrom=$p(^CT("HOSP",hospid),"^",9)
	.s dateTo=$p(^CT("HOSP",hospid),"^",10)
	.q:(datefrom'="")&&(datefrom>+$H-1)
	.q:(dateTo'="")&&(dateTo<+$H-1)
	.d ..SendTask3501(st,et,hospid)
	.d ..SendTask3502(st,et,hospid)
	.d ..SendTask3503(st,et,hospid)
	.d ..SendTask3504(st,et,hospid)
	.d ..SendTask3505(st,et,hospid)
	.d ..SendTask3506(st,et,hospid)
	q 0
}

ClassMethod SaveLog(ByRef LogRowId As %String, OutTextStr, LogType As %String = "", ClassName As %String = "", MethodName As %String = "", Params, HospId)
{
	;s LogType="InsuMatCodeUpLoad"
	s Success="N"
    ;OutTextStr 医保返回 1^resultjson  1:代表成功  resultjson：代表第三方回传数据
	i OutTextStr'="" d
	.s successflag=$p(OutTextStr,"^",1)
	.q:successflag'=1 ;不需要解析肯定失败了
	.s OutText=$p(OutTextStr,"^",2)
	.s OutTextData=##class(%ZEN.proxyObject).%New()
    .d ##class(ext.util.JsonObject).JSONStreamToObject(OutText,.OutTextData)
    .s infcode=$g(OutTextData.%data("infcode"))	//返回值
    .s:infcode="0" Success="Y"
    .s OutTextStr=..GetStream(OutTextStr)
	s Params=..GetStream(Params)
	i $g(LogRowId)="" d
	.s obj=##class(User.DHCDataExchangeLog).%New()
	.s obj.LogClassName=ClassName
	.s obj.LogMethodName=MethodName
	.s obj.LogType=LogType
	.s obj.LogParams=Params
	.s obj.LogParamsDate=+$h
	.s obj.LogParamsTime=$P($h,",",2)
	.s obj.LogResultDate=+$h
	.s obj.LogResultTime=$P($h,",",2)
	.s obj.HOSPID=HospId
	.s obj.LogSuccess=Success
	e  d
	.s obj=##class(User.DHCDataExchangeLog).%OpenId(LogRowId)
	.d obj.%Reload()
	.s obj.LogResult=OutTextStr
	.s obj.LogResultDate=+$h
	.s obj.LogResultTime=$P($h,",",2)
	.s obj.LogSuccess=Success
	s sc=obj.%Save()
	s LogRowId=obj.%Id()
	q sc
}

ClassMethod GetStream(Input)
{
	s Stream=##class(%GlobalCharacterStream).%New()
	i $ISOBJECT(Input) d
	.d Stream.CopyFrom(Input)
	e  d
	.d Stream.Write(Input)
	q Stream
}

}
