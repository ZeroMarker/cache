Import SQLUser

Class web.DHCSTPHACONFIG Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod GetPhaConfigClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPhaConfigExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPhaConfigExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
    //初始化设置
    i '$d(^DHCSTPHACONFIG("dhcpha")) d
    .;s ^DHCSTPHACONFIG("dhcpha","Con_Aduit")="发药 -- 病区发药前护士需审核^N"
    .s ^DHCSTPHACONFIG("dhcpha","Con_AduitBill")="发药 -- 病区发药是否欠费管理^Y"
    .s ^DHCSTPHACONFIG("dhcpha","Con_DispDefault")="发药 -- 病区发药默认显示值(0-临嘱,1-长嘱,2-长+临嘱)^2"
    .s ^DHCSTPHACONFIG("dhcpha","Con_DisplayOut")="发药 -- 病区发药列表显示出院带药^Y"
    .s ^DHCSTPHACONFIG("dhcpha","Con_DisplayEmy")="发药 -- 病区发药列表显示急煎草药^Y"
    .s ^DHCSTPHACONFIG("dhcpha","Con_LS")="发药 -- 病区发药长临嘱按钮必选(互斥)^N"
    .s ^DHCSTPHACONFIG("dhcpha","Con_DispTypeLocal")="发药 -- 病区发药类别是否默认取本地配置(限发)^Y"
    .;
    .s ^DHCSTPHACONFIG("dhcpha","Con_ReqWard")="退药申请 -- 病区退药申请单只能填写本病区已发药品^N"
    
    //显示
	s item="" f  s item=$o(^DHCSTPHACONFIG("dhcpha",item)) q:item=""  d
	. s info=^DHCSTPHACONFIG("dhcpha",item)
	. s desc=$p(info,"^",1)
	. s config=$p(info,"^",2)
	. d OutputRows
	.
	Quit $$$OK
	
OutputRows
    s Tdesc=desc
    s Titem=item
	s Tconfig=config
	
	s Data=$lb(Tdesc,Titem,Tconfig)
	s ^CacheTemp(repid,ind)=Data	
	s ind=ind+1
	q
}

ClassMethod GetPhaConfigFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPhaConfigExecute ]
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

Query GetPhaConfig() As %Query(ROWSPEC = "Tdesc:%String,Titem:%String,Tconfig:%String")
{
}

ClassMethod UpdateItem(str As %String, flag As %String) As %String
{
	///Description:维护住院药房配置
	///Creator：LQ  2009-01-19
	n (str,flag)
	q:str="" -1
	q:flag="" -2
	s ret=0
	//删除
	i (flag="Delete") d
	.i $d(^DHCSTPHACONFIG("dhcpha",str)) d 
	..k ^DHCSTPHACONFIG("dhcpha",str)
	//更新
	i flag="Update" d 
	.s desc=$p(str,"^",1)
	.s item=$p(str,"^",2)
	.s config=$p(str,"^",3)
	.s setString=desc_"^"_config
	.s ^DHCSTPHACONFIG("dhcpha",item)=setString
	.//增加
	i flag="Add" d 
	.s desc=$p(str,"^",1)
	.s item=$p(str,"^",2)
	.q:item=""								//zdm,2010-11-04,解决增加空记录提示信息完成后保存的问题
	.s config=$p(str,"^",3)
	.s setString=desc_"^"_config
	.i $d(^DHCSTPHACONFIG("dhcpha",item)) s ret=-3
	.s ^DHCSTPHACONFIG("dhcpha",item)=setString
	q ret
}

/// 插入科室配置表记录
/// Creator:Liang Qiang
/// CreatDate:2011-03-17
/// Input:配置数据
/// OutPut: 0 成功  非0 失败
ClassMethod InsertDHCPHLC(configString As %String, updflag, plcrowid) As %String
{
	n (configString,updflag,plcrowid)
	s tmpstr=""
	s disploc=$p(configString,"^",1)
	s mac=$p(configString,"^",2)
	s desc=$p(configString,"^",3)
	s usercode=$p(configString,"^",4)
	s userid=""
	i usercode'="" s userid=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(usercode),userid))
	q:(usercode'="")&(userid="") -3
	d ChkMacAndUser
	q:($g(exist)=1) -2
	i (updflag=0)&($g(exist)=0) d
	.&sql(insert into DHC_PhaLocConfig(PLC_Loc_DR,PLC_Desc,PLC_MAC,PLC_SSUSR_DR) values (:disploc,:desc,:mac,:userid))
	e  d
	.&sql(update DHC_PhaLocConfig set PLC_Loc_DR=:disploc,PLC_Desc=:desc,PLC_MAC=:mac,PLC_SSUSR_DR=:userid where PLC_ROWID=:plcrowid)
	
	i SQLCODE'=0 Q -1
	Q 0
ChkMacAndUser
   s exist=0
   s plc=0
   f  s plc=$o(^DHCPHLC(plc)) q:(plc="")!(exist=1)  d 
   .s plloc=$p(^DHCPHLC(plc),"^",1)
   .s plcmac=$p(^DHCPHLC(plc),"^",3)
   .s plcuser=$p(^DHCPHLC(plc),"^",6)
   .i (plcmac=mac)&&(plcmac'="")&&(mac'="")&&(plloc=disploc)&&(plcrowid'=plc) d
   ..s exist=1
   .i (plcuser=userid)&&(userid'="")&&(plcuser'="")&&(plloc=disploc)&&(plcrowid'=plc) d
   ..s exist=1
   .
   q
}

ClassMethod GetPhaLocConfigClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPhaLocConfigExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPhaLocConfigExecute(ByRef qHandle As %Binary, displocrowid, MacAddr, UserCode) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
    Q:displocrowid="" $$$OK
	s plc=0
	f  s plc=$o(^DHCPHLC(plc)) q:plc=""  d 
	.s tmpcatstr="",tmppristr=""
	.s plcloc=$p(^DHCPHLC(plc),"^",1)
	.//w plcloc,!
	.q:(displocrowid'=plcloc)&(displocrowid'="")
	.s plcloc=$p(^CTLOC(plcloc),"^",2)
	.s plcdesc=$p(^DHCPHLC(plc),"^",2)
	.s plcmac=$p(^DHCPHLC(plc),"^",3)
	.q:(MacAddr'="")&(MacAddr'=plcmac)
	.s plcuserid=$p(^DHCPHLC(plc),"^",6)
	.s plcuser=""
	.i plcuserid'="" s plcuser=$p(^SSU("SSUSR",plcuserid),"^",1)
	.q:(UserCode'="")&(UserCode'=plcuser)
	.d OutputPhaRows
	Quit $$$OK
OutputPhaRows
	s Data=$lb(plcloc,plcdesc,plcmac,plc,plcuser)
	s ^CacheTemp(repid,ind)=Data	
	s ind=ind+1
	q
}

ClassMethod GetPhaLocConfigFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPhaLocConfigExecute ]
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

Query GetPhaLocConfig(displocrowid, MacAddr, UserCode) As %Query(ROWSPEC = "Tplcloc:%String,Tplcdesc:%String,Tplcmac:%String,Tplc:%String,Tusercode:%String")
{
}

/// 查询科室配置表记录
/// Creator:Liang Qiang
/// CreatDate:2011-03-17
/// Input: rowid
/// OutPut: 配置数据
ClassMethod GetPhaLocConfigStr(plc As %String, pri = "") As %String
{
	n (plc,pri)
	s plclocdr="",plcloc="",plcdesc="",plcmac="",plccat="",plcpri=""
	s plclocdr=$p(^DHCPHLC(plc),"^",1)
	s plcloc=$p(^CTLOC(plclocdr),"^",2)
	s plcdesc=$p(^DHCPHLC(plc),"^",2)
    s plcmac=$p(^DHCPHLC(plc),"^",3)
    s plcuser=$p(^DHCPHLC(plc),"^",6)
    i plcuser'="" s plcuser=$p(^SSU("SSUSR",plcuser),"^",1)
    s pprowid="",tmpcatstr="",tmppristr=""
    f  s pprowid=$o(^DHCPPRIOR(pprowid)) q:pprowid=""  d
    .s code=$p(^DHCPPRIOR(pprowid),"^",1)
    .q:code'=plc
    .s desc=$p(^DHCPPRIOR(pprowid),"^",2)
    .q:(pri'="")&&(pri'=desc)
    .i $g(tmppristr)="" d
	..s tmppristr=desc
	.e  d
	..s tmppristr=tmppristr_"||"_desc
    .i pri'="" d
    ..s ppdp=""
    ..f  s ppdp=$o(^DHCPPRIOR(pprowid,"PRIOR",ppdp)) q:ppdp=""  d
    ...s dispcatdr=$p(^DHCPPRIOR(pprowid,"PRIOR",ppdp),"^",2)
    ...s dispcat=$p(^DHCSTDRUGGRP(dispcatdr),"^",3)
    ...i $g(tmpcatstr)="" d
	....s tmpcatstr=dispcat
	...e  d
	....s tmpcatstr=tmpcatstr_"||"_dispcat
	... 
	s plcpri=tmppristr
	s plccat=tmpcatstr
	
	s retstr=plclocdr_"^"_plcloc_"^"_plcdesc_"^"_plcmac_"^"_plccat_"^"_plcpri_"^"_plc_"^"_plcuser
	
	q $g(retstr)
}

/// 查询科室配置表记录
/// Creator:Liang Qiang
/// CreatDate:2011-03-17
/// Input: rowid
/// OutPut: 配置数据
/// w ##class(web.DHCSTPHACONFIG).GetPhaLocConfigByLoc("184","**C8:B2:9B:39:A6:8E","18887")
ClassMethod GetPhaLocConfigByLoc(Loc As %String, MacAddr As %String, UserId As %String) As %String
{
   
	n (Loc,MacAddr,UserId)
	s ^yunhaibao("GetPhaLocConfigByLoc")=$lb(Loc,MacAddr,UserId)
	q:Loc="" 0
	s exit=0
	s plc=0 ,ret=""
	s plclocdr="",plcloc="",plcdesc="",plcmac="",plccat="",plcpri="",plc=0,chkplc="",macaddstr=""
	//f  s plc=$o(^DHCPHLC(plc)) q:(plc="")!(exit=1)  d
	i UserId'="" d
	.s plc="0"
	.f  s plc=$o(^DHCPHLC(0,"LocUser",Loc,UserId,plc)) q:(plc="")!(exit=1)  d
	..s plclocdr=$p(^DHCPHLC(plc),"^",1)
	..q:(Loc'=plclocdr)
	..s plcmac=$p(^DHCPHLC(plc),"^",3)
	..s plcuser=$p(^DHCPHLC(plc),"^",6)
	..q:(plcuser'="")&(UserId'=plcuser)&(UserId'="")
	..s retflag=$$ChkMacAddr(MacAddr,plcmac)
	..s macadd=$p(macaddstr,"**",2)
	..q:(plcmac'="")&(retflag=0)&(macadd'="")
	..q:(UserId'=plcuser)&(retflag=0)
	..s chkplc=plc
	..s exit=1
	..s plcloc=$p(^CTLOC(plclocdr),"^",2)
	..s plcdesc=$p(^DHCPHLC(plc),"^",2)
	i chkplc'="" d
	.s ret=$$GetPirString(chkplc)
	q:ret'="" ret
	i MacAddr'="" d
	.s plc="0"
	.f  s plc=$o(^DHCPHLC(plc)) q:(plc="")!(exit=1)  d
	..s plclocdr=$p(^DHCPHLC(plc),"^",1)
	..q:(Loc'=plclocdr)
	..s plcmac=$p(^DHCPHLC(plc),"^",3)
	..s plcuser=$p(^DHCPHLC(plc),"^",6)
	..q:(plcuser'="")&(UserId'=plcuser)&(UserId'="")
	..s retflag=$$ChkMacAddr(MacAddr,plcmac)
	..s macadd=$p(macaddstr,"**",2)
	..q:(plcmac'="")&(retflag=0)&(macadd'="")
	..q:(UserId'=plcuser)&(retflag=0)
	..//q:(plcuser'="")&(plcmac'="")&(UserId'=plcuser)&(retflag=0)
	..s chkplc=plc
	..s exit=1
	..s plcloc=$p(^CTLOC(plclocdr),"^",2)
	..s plcdesc=$p(^DHCPHLC(plc),"^",2)
	i chkplc'="" d
	.s ret=$$GetPirString(chkplc)
	q $g(ret)
	
ChkMacAddr(MacAddr,plcmac)
    s num=$l(MacAddr,"||")
    q:plcmac="" 1
    s exitchk=0
    f x=1:1:num q:exitchk=1  d
    .s macaddstr=$p(MacAddr,"||",x)
    .q:macaddstr=""
    .s macadd=$p(macaddstr,"**",2)
    .s plcmac=$tr(plcmac,"-",":")
    .i macadd=plcmac d
    ..s exitchk=1
    q exitchk
    
GetPirString(chkplc)
    s pprowid="",tmppristr=""
    f  s pprowid=$o(^DHCPPRIOR(pprowid)) q:pprowid=""  d
    .s code=$p(^DHCPPRIOR(pprowid),"^",1)
    .q:code'=chkplc
    .s pri=$p(^DHCPPRIOR(pprowid),"^",2)
    .s desc=$p(^OECPR(pri),"^",1)
    .s tmpcatstr=""
    .s ppdp=""
    .f  s ppdp=$o(^DHCPPRIOR(pprowid,"PRIOR",ppdp)) q:ppdp=""  d
    ..s dispcatdr=$p(^DHCPPRIOR(pprowid,"PRIOR",ppdp),"^",2)
    ..s dispcat=$p(^DHCSTDRUGGRP(dispcatdr),"^",1)
    ..
    ..i $g(tmpcatstr)="" d
	...s tmpcatstr=dispcat
	..e  d
	...s tmpcatstr=tmpcatstr_"~"_dispcat
	.
	.i tmppristr="" d
	..s tmppristr=desc_"@"_tmpcatstr
	.e  d
	..s tmppristr=tmppristr_"^"_desc_"@"_tmpcatstr
	..
	q tmppristr
}

/// udpflag 1 检查是否存在  2 insert  3 delete
ClassMethod InsertPriority(plc As %String, pri, udpflag) As %String
{
	n (plc,pri,udpflag)
	s exit=0
	i udpflag=1 d
	.&sql(select PP_RowId into :tmpcode from  DHC_PhaPriority where PP_Code=:plc and PP_Desc=:pri )
    .i $G(tmpcode)'="" s exit=-1
    q:exit'=0 -1
	i udpflag=2 d
	.&sql(insert into DHC_PhaPriority (PP_Code,PP_Desc)values (:plc,:pri))
	.i SQLCODE'=0 s exit=-1
	q:exit'=0 -2
	i udpflag=3 d
	.&sql(delete from DHC_PhaPriority where (PP_Code=:plc and PP_Desc=:pri))
	.i SQLCODE'=0 s exit=-1
	q:exit'=0 -3
	q 0
}

/// udpflag 1 检查是否存在  2 insert  3 delete
ClassMethod InsertPriDispCat(plc As %String, pri, drugcat, updflag) As %String
{
	n (plc,pri,drugcat,updflag)
	
	k PLIST
	s exit=0
	s sdg=0
	f  s sdg=$o(^DHCSTDRUGGRP(sdg)) q:(sdg=0)!(sdg="")!(exit=1)  d
	.s sdgcode=$p(^DHCSTDRUGGRP(sdg),"^",1)
	.i sdgcode=drugcat d
	..s index=sdg
	..s exit=1
	q:$g(index)="" -1
	s pp=""
	f  s pp=$o(^DHCPPRIOR(pp)) q:pp=""  d
	.s code=$p(^DHCPPRIOR(pp),"^",1)
	.q:code'=plc
	.s desc=$p(^DHCPPRIOR(pp),"^",2)
	.q:desc'=pri
	.s pprowid=pp
	.
	s sub=+$o(^DHCPPRIOR(pprowid,"PRIOR",""),-1)+1
	s PLIST(0)=pprowid
	s PLIST(2)=sub
	s PLIST(3)=""
	s PLIST(4)=index
	s exit=0
	
	i updflag=1 d
	.&sql(select PPDP_RowId into :tmprowid from DHC_PhaPriorDisType where PPDP_DispCat_DR=:index and PPDP_ParRef=:pprowid )
	.i $g(tmprowid)'="" d
	..s exit=-1
	q:exit'=0 -1
	i updflag=2 d
	.&sql(insert into DHC_PhaPriorDisType values PLIST())
	.i SQLCODE'=0 s exit=-1
	q:exit'=0 -2
	i updflag=3 d
	.&sql(delete from DHC_PhaPriorDisType where PPDP_DispCat_DR=:index and PPDP_ParRef=:pprowid )
	.i SQLCODE'=0 s exit=-1
	q:exit'=0 -3
	q 0
}

/// Descript: 	删除客户端配置
/// Creater：	zhouyg
/// CreateDate：2014-12-22
/// Input：		User.DHCPhaLocConfig的ID
/// Return:		0-成功，100-无此记录，其他-错误
/// 
ClassMethod DelePhaLocConfig(plcID As %String) As %String
{
	n (plcID)
	q:plcID="" -1
	TS
	&sql(delete from DHC_PhaLocConfig where PLC_ROWID=:plcID)
	i SQLCODE'=0 d
	.TRollback
	q:SQLCODE'=0 SQLCODE
	&sql(delete from  DHC_PhaPriority where PP_Code=:plcID)
	i (SQLCODE'=0)&(SQLCODE'=100) d
	.TRollback
	q:(SQLCODE'=0)&(SQLCODE'=100) SQLCODE
	TC
	q 0
}

}
