Class web.DHCEQStock Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 21;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "S_RowID";

Parameter SQLDESCRIPTION = "S_RowID";

Parameter SQLROWID = "S_RowID";

/// 获取最近一次的采购
/// inclb（INC_ItmLcBt的RowID)
/// DHC_INGdRecItm  入库表
ClassMethod GetLastINGRI(inclb)
{
  	 n INGR,incib,INGRCH,INGRI
     s incib=$$CIBrow^at299(inclb)
     q:incib="" ""
     s INGR=$o(^INGRI("GRI_INCIB",incib,""),-1)
     i INGR d
       .s INGRCH=$o(^INGRI("GRI_INCIB",incib,INGR,""))
       .s INGRI=INGR_"||"_INGRCH
     q $g(INGRI)
}

ClassMethod GetLastPrice(inclb, UOM)
{
	n LASTINGRI,DHCINGR,DHCINGRCH
    n BUOM,RP,PP,RECUOM
    n fac1,fac2
    s LASTINGRI=..GetLastINGRI(inclb)
    q:LASTINGRI="" ""
    s DHCINGR=$o(^DHCINGR(0,"INGDRECITM",LASTINGRI,"")) q:DHCINGR="" ""
    s DHCINGRCH=$o(^DHCINGR(0,"INGDRECITM",LASTINGRI,DHCINGR,"")) q:DHCINGRCH="" ""
    s RP=$p(^DHCINGR(DHCINGR,"GRI",DHCINGRCH),"^",30)    ; Real Price (in)
    s PP=$p(^DHCINGR(DHCINGR,"GRI",DHCINGRCH),"^",35)    ; Purchase Price (in)
    s RECUOM=$p(^DHCINGR(DHCINGR,"GRI",DHCINGRCH),"^",10) ; UOM
    s BUOM=$p(^INCI(+inclb,1),"^",10)
    i UOM="" s UOM=BUOM
    i UOM'=RECUOM
    {
    	s fac1=..TransUOM(UOM,BUOM)
    	s fac2=..TransUOM(RECUOM,BUOM)
    	s RP=RP/fac2*fac1
    	s PP=PP/fac2*fac1
    }
    //q PP_"^"_RP
    q RP
}

ClassMethod TransUOM(fr, to)
{
	q:fr=to 1    ;if from-uom is as same as to-uom then return 1
	s rowid=""
	s rowid=$o(^CT("CTCF",0,"UOM",fr,to,rowid))
	i rowid'="" d
	.s fac=$p(^CT("CTCF",rowid),"^",3)
	.s fac=$p(fac,$c(1))
    e  d
    .s fac=1
    q $g(fac)
}

/*If ReturnCode = 0 Then retmessage = ""
    If ReturnCode = -1 Then retmessage = "rowid error"
    If ReturnCode = 100 Then retmessage = "节点不存在"
    If ReturnCode = 101 Then retmessage = "暂停使用"
    If ReturnCode = 102 Then retmessage = "合同过期"
    If ReturnCode = 200 Then retmessage = "dhcrowid error"
    If ReturnCode = 201 Then retmessage = "dhc节点不存在"
    If ReturnCode = 202 Then retmessage = "工商执照过期"
    If ReturnCode = 203 Then retmessage = "税务登记过期"
    If ReturnCode = 204 Then retmessage = "药品经营许可证过期"
    If ReturnCode = 205 Then retmessage = "医疗器械经营许可证过期"
    If ReturnCode = 206 Then retmessage = "医疗器械注册证过期"
    If ReturnCode = 207 Then retmessage = "卫生许可证过期"
    If ReturnCode = 208 Then retmessage = "组织机构代码过期"
    If ReturnCode = 209 Then retmessage = "GSP认证过期"
    If ReturnCode = 210 Then retmessage = "医疗器械生产许可证过期"
    If ReturnCode = 211 Then retmessage = "生产制造认可表过期"
    If ReturnCode = 212 Then retmessage = "进口医疗器械注册证过期"
    If ReturnCode = 213 Then retmessage = "进口注册登记表过期"
    If ReturnCode = 214 Then retmessage = "代理授权书过期"
    If ReturnCode = 215 Then retmessage = "质量保证书过期"
    If ReturnCode = 216 Then retmessage = "业务员授权书过期"
*/
/// 检查供应商资质
ClassMethod CheckApcExpdate(apcdesc, days)
{
	;s apcdesc="TJDLQ-天津东丽区康达芦根加工厂" 
	n (apcdesc,days)
	s days=+$h
	w apcdesc
	s apcdesc=$ZCONVERT(apcdesc,"U")
	s apcdr=$o(^APC("APCVM",0,"APCVM_Name",apcdesc,""))
	q:apcdr="" -1
	s ret=..CheckApc(apcdr)
	q:ret>0 ret
	s ret=..CheckDHCApc(apcdr,days)
	q ret
}

/// ;检查在用标志，合同是否到期
ClassMethod CheckApc(tmpapcdr)
{
	n (tmpapcdr)
	q:'$d(^APC("APCVM",tmpapcdr)) 100
	s status=$p(^APC("APCVM",tmpapcdr),"^",18)
	q:status'="Active" 101        ;Active
	s expdate=$p(^APC("APCVM",tmpapcdr,1),"^",6)
	q:(expdate'="")&(expdate<+$h) 102
	;
	s apctype=$p(^APC("APCVM",tmpapcdr),"^",9)
	s apccat=$p(^APC("APCVM",tmpapcdr,1),"^",1)
	i apccat'="" d
	.s apccat=$p(^APC("APCVC",apccat),"^",3)
	s style=$p(^APC("APCVM",tmpapcdr,1),"^",11)
	q 0
}

/// ;检查各类资质是否过期
ClassMethod CheckDHCApc(tmpapcdr, tmpday)
{
	n (tmpapcdr,tmpday)
	s tmpday=$g(tmpday),tmpapcdr=$g(tmpapcdr)
	w "tmpday=",tmpday,!
	w tmpapcdr,!
	q:'$d(^DHCSTV(0,tmpapcdr)) 200
	s dhcdr=$o(^DHCSTV(0,tmpapcdr,""))
	w dhcdr,!
	q:dhcdr="" 201
	s datas=^DHCSTV(dhcdr) 
	s comlicdate=$p(datas,"^",2)
	w "comlicdate=",comlicdate,!
	q:(comlicdate'="" )&(comlicdate<tmpday) 202
	s revregdate=$p(datas,"^",24)
	w "revregdate=",revregdate,!
	q:(revregdate'="")&(revregdate<tmpday) 203
	s drugmanlicdate=$p(datas,"^",5)
	w "drugmanlicdate=",drugmanlicdate,!
	q:(drugmanlicdate'="")&(drugmanlicdate<tmpday) 204
	s matmanlicdate=$p(datas,"^",15)
	w "matmanlicdate=",matmanlicdate,!
	q:(matmanlicdate'="")&(matmanlicdate<tmpday) 205 
	s matenroldate=$p(datas,"^",13)
	w "matenroldate=",matenroldate,!
	q:(matenroldate'="")&(matenroldate<tmpday) 206
	s sanitationdate=$p(datas,"^",26)
	w "sanitationdate=",sanitationdate,!
	q:(sanitationdate'="")&(sanitationdate<tmpday) 207
	s orgcodedate=$p(datas,"^",19)
	w "orgcodedate=",orgcodedate,!
	q:(orgcodedate'="")&(orgcodedate<tmpday) 208
	s gspdate=$p(datas,"^",7)
	w "gspdate=",gspdate,!
	q:(gspdate'="")&(gspdate<tmpday) 209
	s matprodate=$p(datas,"^",17)
	w "matprodate=",matprodate,!
	q:(matprodate'="")&(matprodate<tmpday) 210
	s propermitdate=$p(datas,"^",22)
	w "propermitdate=",propermitdate,!
	q:(propermitdate'="")&(propermitdate<tmpday) 211
	s impenroldate=$p(datas,"^",9)
	w "impenroldate=",impenroldate,!
	q:(impenroldate'="")&(impenroldate<tmpday) 212
	s implicdate=$p(datas,"^",11)
	w "implicdate=",implicdate,!
	q:(implicdate'="")&(implicdate<tmpday) 213
	s agentlicdate=$p(datas,"^",30)
	q:(agentlicdate'="")&(agentlicdate<tmpday) 214
	s qualitydate=$p(datas,"^",31)
	q:(qualitydate'="")&(qualitydate<tmpday) 215
	s salesdate=$p(datas,"^",33)
	q:(salesdate'="")&(salesdate<tmpday) 216
	q 0
}

ClassMethod GetINCItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetINCItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetINCItemExecute(ByRef qHandle As %Binary, loc, desc) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	if (patientname="")
 	{Set qHandle=$lb(0,repid,0)
 	 quit $$$OK}
	s rowid=0
	f  s rowid=$o(^PAADMi("No",$ZCONVERT(patientname,"U"),rowid)) q:rowid=""  d
	.s admno=$p(^PAADM(rowid),"^",81)
	.s admid=rowid	
	.s patientid =$p(^PAADM(rowid),"^",1)
 	.Do OutputRowGetINCItem
 	s rowid=0
 	f  s rowid=$o(^PAPERi("PAPER_PatName",$ZCONVERT(patientname,"U"),rowid)) q:rowid=""  d
 	.s patientid =rowid
 	.Do OutputRowGetINCItem
 	s rowid=0
 	f  s rowid=$o(^PAPERi("PAPMI_PatNo",$ZCONVERT(patientname,"U"),rowid)) q:rowid=""  d
 	.s patientid =rowid
 	.Do OutputRowGetINCItem
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK    
OutputRowGetINCItem
	s pname=$p(^PAPER(patientid,"ALL"),"^",1)
	s pno=$p(^PAPER(patientid,"PAT",1),"^",1)	
	s sex=$p(^PAPER(patientid,"ALL"),"^",7)	
	i sex'="" s sex=$p(^CT("SEX",sex),"^",2)
	set Data=$lb(pname,pno,patientid,sex)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetINCItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetINCItemExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GetINCItem(loc, desc) As %Query(ROWSPEC = "Name:%String,No:%String,Hidden:%String,Sex:%String")
{
}

}
