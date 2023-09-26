Import SQLUSER

/// Description    配送中转站维护
/// Creator        zhaowuqiang
/// CreatDate      2017-03-22
Class web.DHCDISNodeLoc Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// Description:  保存中转站科室
/// Creator:      zhaowuqiang
/// Creatdate:    2017-03-23
/// Table:        DHC_DISNodeLoc、DHC_DISNodeLocLink
/// Input:        代码^描述^科室^是否可用
/// Output:       0
/// Others:       w ##class(web.DHCDISNodeLoc).SaveNodeLoc("^8^0^Y^2&&^32^0^Y^2")
ClassMethod SaveNodeLoc(params)
{
	N (params)
	
	TSTART
	
  	s ret=0
	s len=$L(params,"&&")
	f i=1:1:len q:ret'=0  d
	.s tmpstr=$p(params,"&&",i)
	.i $p(tmpstr,"^",1)'=""  d
	..s ret=..Update(tmpstr)
	.e  d
	..s ret=..Insert(tmpstr)
	.
	i ret'=0 TROLLBACK
	e  TCOMMIT
	
	Q ret
}

/// w ##class(web.DHCDISNodeLoc).Insert("^8^0^Y^2")
ClassMethod Insert(tmpstr)
{
	n (tmpstr)
	s code=$p(tmpstr,"^",2)
	s desc=$p(tmpstr,"^",3)
	s activeflag=$p(tmpstr,"^",4)
	s locid=$p(tmpstr,"^",5)
	q:$d(^DHCDISNL(0,"Code",code)) -96
	&sql(insert into DHC_DisNodeLoc (NL_Code,NL_Desc,NL_ActiveFlag,NL_Loc_Dr) values (:code,:desc,:activeflag,:locid))
	
	q 0
}

ClassMethod Update(tmpstr)
{
	n (tmpstr)
	s NLid=$p(tmpstr,"^",1)
	s code=$p(^DHCDISNL(NLid),"^",1)
	s NLcode=$p(tmpstr,"^",2) 
	i NLcode'=code  q:$d(^DHCDISNL(0,"Code",NLcode)) -96
	s NLdesc=$p(tmpstr,"^",3)
	s NLenabled=$p(tmpstr,"^",4)
	s NLlocid=$p(tmpstr,"^",5)
	&sql(update DHC_DisNodeLoc set NL_Code=:NLcode,NL_Desc=:NLdesc,NL_ActiveFlag=:NLenabled,NL_Loc_Dr=:NLlocid where NL_RowID=:NLid )
	q SQLCODE
}

/// Description:  删除中转站科室
/// Creatotr:     zhaowuqiang
/// Creatdate:    2017-03-23
/// Table:        DHC_DISNodeLoc
/// Input:
/// Output:       0
/// Others:       w ##class(web.DHCDISNodeLoc).DelNodeLoc("1")
ClassMethod DelNodeLoc(params)
{
	n (params)
	s id=params
	&sql(delete from DHC_DisNodeLoc where NL_RowID=:id)
	q:SQLCODE'=0 SQLCODE
	
	TS
	s flag=0
	s NLLid=""
	f  s NLLid=$o(^DHCDISNLL(0,"NodeLocDr",id,NLLid)) q:(NLLid="")||(flag'=0)  d
	.&sql(delete from DHC_DisNodeLocLink where NLL_RowID=:NLLid)
	.i SQLCODE'=0 s flag=-1
	i flag'=0 TRO
	e  TC
	
	q flag
}

/// w ##class(web.DHCDISNodeLoc).SelLoc()
ClassMethod SelLoc()
{
	s count=0
	w "["
	s locid=""
	f  s locid=$o(^CTLOC(locid)) q:locid=""  d
	.q:locid=0
	.s locdesc=$p(^CTLOC(locid),"^",2) 
	.s tmp=locid_"^"_locdesc
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	w "]"
	q ""
}

/// w ##class(web.DHCDISNodeLoc).QueryNodeLoc("20","1","")
ClassMethod QueryNodeLoc(rows As %String, page As %String, params As %String)
{
	n (rows,page,params)
	s end=page*rows
	s start=(page-1)*rows+1
	s pid=..NewPid()	
	d ..killTmpGlobal(pid)    //k掉临时global
	s code=$p(params,"^",1)    //在串params中取值 
	s desc=$p(params,"^",2)	   //
	s h=0,count=0
	s id = 0
	f  s id = $o(^DHCDISNL(id)) q:id=""  d    //table:DHC_DisNodeLoc
	.s NLcode = $p(^DHCDISNL(id),"^",1)
	.s NLdesc = $p(^DHCDISNL(id),"^",2)
	.s enabled = $p(^DHCDISNL(id),"^",3)
	.s locid = $p(^DHCDISNL(id),"^",4)
	.s locdesc=""
	.i locid'="" s locdesc = $p(^CTLOC(locid),"^",2)
	.q:(code'="")&(code'[NLcode)
	.q:(desc'="")&(desc'[NLdesc)
	.s h=h+1
	.s tempstr=NLcode_"^"_NLdesc_"^"_enabled_"^"_locdesc_"^"_locid_"^"_id
	.s ^TMP("DHCDISNL","web.DHCDISNodeLoc","QueryNodeLoc",pid,h)=tempstr
	
	q:h=0 ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	s title="nlcode^nldesc^nlenabled^nlloc^nllocid^nlid"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCDISNL","web.DHCDISNodeLoc","QueryNodeLoc",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCDISNL","web.DHCDISNodeLoc","QueryNodeLoc",pid,index))
	.s count = count+1
	.q:(count<start)||(count>end)
	.i count=start d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(title,mdate)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(title,mdate)
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// w ##class(web.DHCDISNodeLoc).SaveNodeLocLink("^2^1")
ClassMethod SaveNodeLocLink(params)
{
	n (params)
	
	TSTART
	s ret=0
	s len=$l(params,"&&")
	f i=1:1:len q:ret'=0  d
	.s tmpstr=$p(params,"&&",i)
	.i $p(tmpstr,"^",1)'=""  d
	..s ret=..UpdLocLink(tmpstr)
	.e  d
	..s ret=..InsLocLink(tmpstr)
	.
	i ret'=0 TROLLBACK
	e  TCOMMIT
	
	q ret
}

ClassMethod InsLocLink(tmpstr)
{
	n (tmpstr)
	s locid=$p(tmpstr,"^",2)
	s parentid=$p(tmpstr,"^",3)
	q:$d(^DHCDISNLL(0,"NodeLoc",locid,parentid)) -96
	&sql(insert into DHC_DisNodeLocLink (NLL_Loc_Dr,NLL_NodeLoc_Dr) values (:locid,:parentid))
	
	q SQLCODE
}

/// w ##class(web.DHCDISNodeLoc).UpdLocLink("6^2^1")
ClassMethod UpdLocLink(tmpstr)
{
	n (tmpstr)
	s id=$p(tmpstr,"^",1)
	s locid=$p(tmpstr,"^",2)
	s LocID=$p(^DHCDISNLL(id),"^",1)
	s parentid=$p(tmpstr,"^",3)
	i locid'=LocID  q:$d(^DHCDISNLL(0,"NodeLoc",locid,parentid)) -96
	b ;1
	&sql(update DHC_DisNodeLocLink set NLL_Loc_Dr=:locid,NLL_NodeLoc_Dr=:parentid where NLL_RowID=:id)
	
	q SQLCODE
}

ClassMethod DelLocLink(params)
{
	n (params)
	
	s id=params
	&sql(delete from DHC_DisNodeLocLink where NLL_RowID=:id)
	
	q SQLCODE
}

/// w ##class(web.DHCDISNodeLoc).QueryNodeLocLink("20","1","")
ClassMethod QueryNodeLocLink(rows, page, params)
{
	s ^aaa=params
	n (rows,page,params)
	s end=page*rows
	s start=(page-1)*rows+1
	s pid=..NewPid()	
	d ..killTmpGlobal(pid)    //k掉临时global
	s code=$p(params,"^",1)    //在串params中取值 
	s desc=$p(params,"^",2)	   //
	s h=0,count=0
	s id = 0
	f  s id = $o(^DHCDISNLL(id)) q:id=""  d    //table:DHC_DisNodeLocLink
	.s Locid = $p(^DHCDISNLL(id),"^",1)
	.s ParentDr = $p(^DHCDISNLL(id),"^",2)
	.q:ParentDr'=params
	.s locdesc = $p(^CTLOC(Locid),"^",2)
	.s h=h+1
	.s tempstr=Locid_"^"_ParentDr_"^"_locdesc_"^"_id
	.s ^TMP("DHCDISNL","web.DHCDISNodeLoc","QueryNodeLoc",pid,h)=tempstr
	
	q:h=0 ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	s title="nlllocid^parentid^nllloc^nllid"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCDISNL","web.DHCDISNodeLoc","QueryNodeLoc",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCDISNL","web.DHCDISNodeLoc","QueryNodeLoc",pid,index))
	.s count = count+1
	.q:(count<start)||(count>end)
	.i count=start d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(title,mdate)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(title,mdate)
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	n (pid)
	k ^TMP("DHCDISNL","web.DHCDISNodeLoc","QueryNodeLoc",pid)
}

/// Descript:计数器
ClassMethod NewPid() As %String
{
	Q $I(^TMP("DHCDISNL"))
}

}
