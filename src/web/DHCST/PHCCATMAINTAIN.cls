Import sqluser

Class web.DHCST.PHCCATMAINTAIN Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTPHCCAT";

/// Description:构造树形结构
/// Creator:caoting
/// w ##class(web.DHCST.DHCSTPHCCATMAINTAIN).GetCatTreeData("0","0")
/// yunhaibao20160303,添加是否分院区维护显示的过滤
ClassMethod GetCatTreeData(catdr, level) As %String
{
	s pid=..NewPid()
	k ^TMP("DHCST","DHCSTPHCCATMAINTAIN","GetCatTreeData",pid)
	s currlevel=level+1
	s locid=$G(%session.Data("LOGON.CTLOCID"))
	s hospid=$p(^CTLOC(locid),"^",22)
	s params=""_"^"_locid_"^"_""_"^"_hospid
    s maintainway=##class(web.DHCST.Common.AppCommon).GetAppPropValue(..%GetParameter("AppName"),"MaintainWay",params)  //是否分院区维护
	s hosprowid=""
	f  s hosprowid=$o(^DHCPHCC(0,"PARCAT",hosprowid)) q:hosprowid=""  d
	.q:(maintainway="Y")&&(hosprowid'=hospid)
	.s catid=""
	.f  s catid=$o(^DHCPHCC(0,"PARCAT",hosprowid,catdr,catid)) q:catid=""  d
	..q:+catid=0
	..s ^TMP("DHCST","DHCSTPHCCATMAINTAIN","GetCatTreeData",pid,catid)=""
	q:'$d(^TMP("DHCST","DHCSTPHCCATMAINTAIN","GetCatTreeData",pid)) ""
	w "["
	s outcatid=""
	f  s outcatid=$o(^TMP("DHCST","DHCSTPHCCATMAINTAIN","GetCatTreeData",pid,outcatid)) q:outcatid=""  d	
	.s catdesc=$p(^DHCPHCC(outcatid),"^",2)
	.s leafflag="false"
	.s tmphospital="",tmpleafflag=""
	.f  s tmphospital=$o(^DHCPHCC(0,"PARCAT",tmphospital)) q:tmphospital=""  d
	..q:+tmphospital=0
	..i $o(^DHCPHCC(0,"PARCAT",+tmphospital,outcatid,""))'=""  s tmpleafflag="1"
	.i tmpleafflag="" s leafflag="true"
	.s currlevel=$p(^DHCPHCC(outcatid),"^",4)
	.s checkflag="null"
	.s expandflag="true"
	.w "{"_"id:'"_outcatid_"',text:'"_catdesc_"',leaf:"_leafflag_",level:'"_currlevel_"',checked:"_checkflag_",expanded:"_expandflag_"}"
	.s next=$o(^TMP("DHCST","DHCSTPHCCATMAINTAIN","GetCatTreeData",pid,outcatid))
	.i (+next'=0) d
	..w ","
	k ^TMP("DHCST","DHCSTPHCCATMAINTAIN","GetCatTreeData",pid)
	q "]"
}

/// Description:构造树形结构
/// Creator:caoting
/// w ##class(web.DHCST.DHCSTPHCCATMAINTAIN).GetCatTreeDataById("0","0","100000023")
ClassMethod GetCatTreeDataById(catdr, level, checkednode = "") As %String
{
	s pid=..NewPid()
	k ^TMP("DHCST","DHCSTPHCCATMAINTAIN","GetCatTreeDataById",pid)
	s currlevel=level+1
	s locid=$G(%session.Data("LOGON.CTLOCID"))
	s hospid=$p(^CTLOC(locid),"^",22)
	s params=""_"^"_locid_"^"_""_"^"_hospid
    s maintainway=##class(web.DHCST.Common.AppCommon).GetAppPropValue(..%GetParameter("AppName"),"MaintainWay",params)  //是否分院区维护
	s hosprowid=""
	f  s hosprowid=$o(^DHCPHCC(0,"PARCAT",hosprowid)) q:hosprowid=""  d
	.q:(maintainway="Y")&&(hosprowid'=hospid)
	.s catid=""
	.f  s catid=$o(^DHCPHCC(0,"PARCAT",hosprowid,catdr,catid)) q:catid=""  d
	..q:+catid=0
	..s ^TMP("DHCST","DHCSTPHCCATMAINTAIN","GetCatTreeDataById",pid,catid)=""
	q:'$d(^TMP("DHCST","DHCSTPHCCATMAINTAIN","GetCatTreeDataById",pid)) ""
	w "["
	s outcatid=""
	f  s outcatid=$o(^TMP("DHCST","DHCSTPHCCATMAINTAIN","GetCatTreeDataById",pid,outcatid)) q:outcatid=""  d
	.s leafflag="false"
	.s tmphospital="",tmpleafflag=""
	.f  s tmphospital=$o(^DHCPHCC(0,"PARCAT",tmphospital)) q:tmphospital=""  d
	..q:+tmphospital=0
	..i $o(^DHCPHCC(0,"PARCAT",+tmphospital,outcatid,""))'=""  s tmpleafflag="1"
	.i tmpleafflag="" s leafflag="true"
	.s catdesc=$p(^DHCPHCC(outcatid),"^",2)
	.s plevel=$p(^DHCPHCC(outcatid),"^",4)
	.s parentnode=..GetParentNode(checkednode,plevel)
	.i parentnode=outcatid d
	..s expandflag="true"
	.e  d
	..s expandflag="false"
	.i checkednode="" s expandflag="true"
	.i checkednode=outcatid d
	..s checkflag="null" //"true"
	.e  d
    ..s checkflag="null" //"false"
	.w "{"_"id:'"_outcatid_"',text:'"_catdesc_"',leaf:"_leafflag_",level:'"_currlevel_"',checked:"_checkflag_",expanded:"_expandflag_"}"
	.s next=$o(^TMP("DHCST","DHCSTPHCCATMAINTAIN","GetCatTreeDataById",pid,outcatid))
	.i (+next'=0) d
	..w ","
	k ^TMP("DHCST","DHCSTPHCCATMAINTAIN","GetCatTreeDataById",pid)	
	q "]"
}

ClassMethod GetChildCatTreeData(catdr, level) As %String
{
	s childlevel=level+1
	s catid=""
    s locid=$G(%session.Data("LOGON.CTLOCID"))
	s hospid=$p(^CTLOC(locid),"^",22)
	s params=""_"^"_locid_"^"_""_"^"_hospid
    s maintainway=##class(web.DHCST.Common.AppCommon).GetAppPropValue(..%GetParameter("AppName"),"MaintainWay",params)  //是否分院区维护
	s hosprowid=""
	f  s hosprowid=$o(^DHCPHCC(0,"PARCAT",hosprowid)) q:hosprowid=""  d
	.q:(maintainway="Y")&&(hosprowid'=hospid)
	.f  s catid=$o(^DHCPHCC(0,"PARCAT",hosprowid,catdr,catid)) q:catid=""  d
	..s leafflag="false"
	..i $o(^DHCPHCC(0,"PARCAT",hosprowid,catid,""))=""  s leafflag="true"
	..s catdesc=$p(^DHCPHCC(catid),"^",2)
	..s checkflag="true"
	..w ",{"_"id:'"_catid_"',text:'"_catdesc_"',leaf:"_leafflag_",level:'"_childlevel_"',checked:"_checkflag_"}"
	..s ret=""
	..i checkflag="true" s ret=..GetChildCatTreeData(catid,childlevel)
	..w ret
	q ""
}

/// w ##class(web.DHCST.DHCSTPHCCATMAINTAIN).SaveCat(0,1321,1)	
ClassMethod SaveCat(ParCat, CatCode, CatDesc) As %String
{
	q:ParCat="" -1
	q:CatCode="" -1
	q:CatDesc="" -1
	s locid=$G(%session.Data("LOGON.CTLOCID"))
	s hospid=$p(^CTLOC(locid),"^",22)
	s params=""_"^"_locid_"^"_""_"^"_hospid
    s maintainway=##class(web.DHCST.Common.AppCommon).GetAppPropValue(..%GetParameter("AppName"),"MaintainWay",params)  //是否分院区维护
	//i maintainway'="Y" s hospid="1",yunhaibao20160325还是按院区存
	i ParCat'=0 d
	.s parlevel=$p(^DHCPHCC(ParCat),"^",4)
	.s level=parlevel+1
	e  d
	.s level=1
	i maintainway="Y" s tmphospid=hospid
	e  s tmphospid=""
	s exist=..CheckPhcCatExist(CatCode,CatDesc,level,ParCat,tmphospid)
	q:exist'="" exist
	&sql(insert into dhc_phccat(PHCC_Code,PHCC_Desc,PHCC_ParCat_Dr,PHCC_Level,PHCC_Hosp_Dr) values(:CatCode,:CatDesc,:ParCat,:level,:hospid))
	s ruleid=$o(^DHCSSPCS(0,"LEVEL",+hospid,level,""))
	i ruleid'="" d
	.&sql(update DHC_StkSysPHCCodeSet set PCS_CurNo=:CatCode where PCS_RowId=:ruleid)
	q SQLCODE
}

/// w ##class(web.DHCST.DHCSTPHCCATMAINTAIN).UpdCat(100000000,2,2)
ClassMethod UpdCat(CatId, CatCode, CatDesc) As %String
{
	q:CatId="" -1
	q:CatCode="" -1
	q:CatDesc="" -1
	s exist=..CheckPhcCatExist(CatCode,CatDesc,"","","",CatId)
	q:exist'="" exist	
	&sql(update dhc_phccat set PHCC_Code=:CatCode,PHCC_Desc=:CatDesc where PHCC_RowId=:CatId)
	q SQLCODE
}

/// 保存某药学分类的下一级分类
/// w ##class(web.DHCST.DHCSTPHCCATMAINTAIN).SaveChildCat(34,"",2,2)
ClassMethod SaveChildCat(ParCat, CatId, CatCode, CatDesc, Hosp = "") As %String
{
	q:ParCat="" -1
	q:CatCode="" -1
	q:CatDesc="" -1
	//s ^yunhaibao("SaveChildCat")=ParCat_","_CatId_","_CatCode_","_CatDesc
	s locid=$G(%session.Data("LOGON.CTLOCID"))
	s hospid=$p(^CTLOC(locid),"^",22)
	s params=""_"^"_locid_"^"_""_"^"_hospid
	s exist=""
    s maintainway=##class(web.DHCST.Common.AppCommon).GetAppPropValue(..%GetParameter("AppName"),"MaintainWay",params)  //是否分院区维护
	//i maintainway'="Y" s hospid="1"	
	i CatId="" d
	.i ParCat'=0 d
	..s parlevel=$p(^DHCPHCC(ParCat),"^",4)
	..s level=parlevel+1
	.e  d
	..s level=1
	.i maintainway="Y" s tmphospid=hospid
	.e  s tmphospid=""
	.s exist=..CheckPhcCatExist(CatCode,CatDesc,level,ParCat,tmphospid)
	.q:exist'="" 
	.&sql(insert into dhc_phccat(PHCC_Code,PHCC_Desc,PHCC_ParCat_Dr,PHCC_Level,PHCC_Hosp_Dr) values(:CatCode,:CatDesc,:ParCat,:level,:hospid))
	.s ruleid=$o(^DHCSSPCS(0,"LEVEL",+hospid,level,""))
	.i ruleid'="" d
	..&sql(update DHC_StkSysPHCCodeSet set PCS_CurNo=:CatCode where PCS_RowId=:ruleid)
	e  d
	.s exist=..CheckPhcCatExist(CatCode,CatDesc,"","","",CatId)
	.q:exist'="" 
	.&sql(update dhc_phccat set PHCC_Code=:CatCode,PHCC_Desc=:CatDesc where PHCC_RowId=:CatId)
	q:exist'="" exist
	q SQLCODE
}

ClassMethod DeleteCat(CatId) As %String
{
	q:'$d(^DHCPHCC(CatId)) ""
	s ret=0
	s hospDr=$p(^DHCPHCC(CatId),"^",5)
	s rowId=""
	f  s rowId=$o(^DHCPHCC(0,"PARCAT",hospDr,CatId,rowId))  q:rowId=""  d
	.s secId=$o(^DHCPHCC(0,"PARCAT",hospDr,rowId,""))
	.i secId="" d
	..&sql(delete from dhc_phccat where PHCC_RowId=:rowId)
	..i SQLCODE'=0 d
	...s rett=$$ErrorRecord^DHCSTERROR("Delete:dhc_phccat","","rowId:"_rowId_";"_SQLCODE_":"_%msg)
	.e  d
	..s ret=..DeleteCat(rowId)
	..i ret'=0 d
	...s rett=$$ErrorRecord^DHCSTERROR("Delete:dhc_phccat","","rowId:"_rowId_";"_SQLCODE_":"_%msg)
	
	&sql(delete from dhc_phccat where PHCC_RowId=:CatId)
	i SQLCODE'=0 d
	.s rett=$$ErrorRecord^DHCSTERROR("Delete:dhc_phccat","","rowId:"_rowId_";"_SQLCODE_":"_%msg)
	q:ret'=0 ret
	q 0
}

ClassMethod GetAllPhcCat(catdr, catdescstr) As %String
{
	q:+catdr="0" ""
	q:'$d(^DHCPHCC(catdr)) ""
	s parcatdr=$p(^DHCPHCC(catdr),"^",3)
	s catdesc=$p(^DHCPHCC(catdr),"^",2)
	i catdescstr="" d
	.s catdescstr=catdesc
	e  d
	.s catdescstr=catdesc_"-"_catdescstr
	q:parcatdr=0 catdescstr
	s ret=..GetAllPhcCat(parcatdr,catdescstr)
	q ret
}

/// Descript:	根据传入的药学多级分类的id值，获取父类
/// Creater:	wyx
/// CreateDate:	2015-01-06
/// Input:		药学多级分类的id值
/// Output:		Return 父类 "catcode1-catcode2-catcode3^catdesc1-catdesc2-catdesc3^catid1-catid2-catid3"
ClassMethod GetAllPhcCatById(catdr, catdescstr, catcodestr, catidstr) As %String
{
	q:+catdr="0" ""
	q:'$d(^DHCPHCC(catdr)) ""
	s parcatdr=$p(^DHCPHCC(catdr),"^",3)
	
	s catcode=$p(^DHCPHCC(catdr),"^",1)
	s catdesc=$p(^DHCPHCC(catdr),"^",2)
	i catdescstr="" d
	.s catdescstr=catdesc
	e  d
	.s catdescstr=catdesc_"-"_catdescstr
	i catcodestr="" d
	.s catcodestr=catcode
	e  d
	.s catcodestr=catcode_"-"_catcodestr
	i catidstr="" d
	.s catidstr=catdr
	e  d
	.s catidstr=catdr_"-"_catidstr
	s catstr=catcodestr_"^"_catdescstr_"^"_catidstr
	q:parcatdr=0 catstr
	s ret=..GetAllPhcCatById(parcatdr,catdescstr,catcodestr,catidstr)
	q ret
}

/// Description:保存药学项多级分类
/// Creator:caoting
ClassMethod SaveNewPhcCat(InciId, catid) As %String
{
	q:InciId="" -1
	q:'$d(^INCI(InciId)) -1
	s ArcimId=$p(^INCI(InciId,1),"^",3)
	s Sub=+ArcimId
	s Ver=$p(ArcimId,"||",2)
	q:Sub="" -2 
	q:Ver="" -2
	q:'$d(^ARCIM(Sub,Ver)) -2
	s PhcdfId=$p(^ARCIM(Sub,Ver,1),"^",12)
	s PHCD=+PhcdfId
	s DF=$p(PhcdfId,"||",2)
	q:PHCD="" -3 
	q:DF="" -3
	&sql(update phc_drgformext set PHCDF_PHCC_Dr=:catid where PHCDF_RowId=:PhcdfId)
	q SQLCODE
}

/// Description:药学分类、药学子类、更小分类导入新多级分类表
/// Creator:caoting
ClassMethod ImportAllPhcCat() As %String
{
	s catid=0
	f  s catid=$o(^PHCC(catid)) q:catid=""  d
	.q:$g(^PHCC(catid))=""
	.s catcode=$p(^PHCC(catid),"^",1)
	.s catdesc=$p(^PHCC(catid),"^",2)
	.&sql(insert into dhc_phccat(PHCC_Code,PHCC_Desc,PHCC_ParCat_Dr,PHCC_Level) values(:catcode,:catdesc,'0','1'))
	.q:SQLCODE'=0
	.s parcatdr=$p(%ROWID,$c(1))
	.s subcat=0
	.f  s subcat=$o(^PHCC(catid,"SC",subcat)) q:subcat=""  d
	..s subcatcode=$p(^PHCC(catid,"SC",subcat),"^",1)
	..s subcatdesc=$p(^PHCC(catid,"SC",subcat),"^",2)
	..&sql(insert into dhc_phccat(PHCC_Code,PHCC_Desc,PHCC_ParCat_Dr,PHCC_Level) values(:subcatcode,:subcatdesc,:parcatdr,'2'))
	..q:SQLCODE'=0
	..s parsubcatdr=$p(%ROWID,$c(1))
	..s mincat=0
	..f  s mincat=$o(^PHCC(catid,"SC",subcat,"MIN",mincat)) q:mincat=""  d
	...s mincatcode=$p(^PHCC(catid,"SC",subcat,"MIN",mincat),"^",1)
	...s mincatdesc=$p(^PHCC(catid,"SC",subcat,"MIN",mincat),"^",2)
	...&sql(insert into dhc_phccat(PHCC_Code,PHCC_Desc,PHCC_ParCat_Dr,PHCC_Level) values(:mincatcode,:mincatdesc,:parsubcatdr,'3'))
	
	q SQLCODE
}

ClassMethod GetCatCode(Catid)
{
	q:Catid="" ""
    s catcode=$p(^DHCPHCC(Catid),"^",1)
    q catcode
}

ClassMethod GetChild(parentId As %String) As %String
{
	Set json = ##class(Code.JsonObj).%New()
	q:parentId="" ""
	s num=0
	s locid=$G(%session.Data("LOGON.CTLOCID"))
	s hospid=$p(^CTLOC(locid),"^",22)
	s params=""_"^"_locid_"^"_""_"^"_hospid
    s maintainway=##class(web.DHCST.Common.AppCommon).GetAppPropValue(..%GetParameter("AppName"),"MaintainWay",params)  //是否分院区维护
    s hosprowid=""
    f  s hosprowid=$o(^DHCPHCC(0,"PARCAT",hosprowid)) q:hosprowid=""  d
    .q:(maintainway="Y")&&(hosprowid'=hospid)
	.s catid=""
	.f  s catid=$o(^DHCPHCC(0,"PARCAT",hosprowid,parentId,catid)) q:catid=""  d
	..s catcode=$p(^DHCPHCC(catid),"^",1)
	..s catdesc=$p(^DHCPHCC(catid),"^",2)
	..s hospital=$p(^DHCPHCC(catid),"^",5)
	..s data=catid_"^"_catcode_"^"_catdesc_"^"_hospital
	..s num=num+1
	..d json.InsertRowData(data)
	s DetailInfo=json.getJsonData("RowId^Code^Desc^Hospital",num)
	k json
	q DetailInfo
}

/// w ##class(web.DHCST.DHCSTPHCCATMAINTAIN).GetParentNode(100000022,1)
ClassMethod GetParentNode(catid As %String, level As %String = "") As %String
{
	q:catid="" ""
	q:level="" ""
	s parentid=$p(^DHCPHCC(catid),"^",3)
	q:parentid=0 catid
	s parentlevel=$p(^DHCPHCC(catid),"^",4)
	i level=parentlevel q catid
	e  s ret=..GetParentNode(parentid,level)
	q ret
}

ClassMethod GetTreeDataByDesc(catdr, desc = "") As %String
{
	k ^TMPPHCCAT("CATDESC")
	s pid=..NewPid()
	s locid=$G(%session.Data("LOGON.CTLOCID"))
	s hospid=$p(^CTLOC(locid),"^",22)
	s params=""_"^"_locid_"^"_""_"^"_hospid
    s maintainway=##class(web.DHCST.Common.AppCommon).GetAppPropValue(..%GetParameter("AppName"),"MaintainWay",params)  //是否分院区维护
    //i maintainway'="Y" s hospid=1
    s hosprowid=""
    f  s hosprowid=$o(^DHCPHCC(0,"PARCAT",hosprowid)) q:hosprowid=""  d
    .q:(maintainway="Y")&&(hosprowid'=hospid)
	.f  s catdr=$o(^DHCPHCC(0,"PARCAT",hosprowid,catdr)) q:catdr=""  d
	..s catid=0
	..f  s catid=$o(^DHCPHCC(0,"PARCAT",hosprowid,catdr,catid)) q:catid=""  d
	...s catdesc=$p(^DHCPHCC(catid),"^",2)
	...i (desc'="")&&(catdesc[desc) d
	....;s parentid=..GetParentNode(catid,1)
	....s ^TMPPHCCAT("CATDESC",pid,catid)=""
	w "["
	s catid=""
	f  s catid=$o(^TMPPHCCAT("CATDESC",pid,catid)) q:catid=""  d
	.s catdesc=$p(^DHCPHCC(catid),"^",2)
	.s leafflag="false"
	.s tmphospital="",tmpleafflag=""
	.f  s tmphospital=$o(^DHCPHCC(0,"PARCAT",tmphospital)) q:tmphospital=""  d
	..q:+tmphospital=0
	..i $o(^DHCPHCC(0,"PARCAT",+tmphospital,catid,""))'=""  s tmpleafflag="1"
	.i tmpleafflag="" s leafflag="true"
	.s currlevel=$p(^DHCPHCC(catid),"^",4)
	.s checkflag="false"
	.s expandflag="true"
	.w "{"_"id:'"_catid_"',text:'"_catdesc_"',leaf:"_leafflag_",level:'"_currlevel_"',checked:"_checkflag_",expanded:"_expandflag_"}"
	.s next=$o(^TMPPHCCAT("CATDESC",pid,catid))
	.i (+next'=0) d
	..w ","
	
	q "]"
}

ClassMethod NewPid() As %String
{
 q $I(^DHCSTNEWPHCCAT("TREE"))
}

ClassMethod GetNoRule() As %String
{
	Set json = ##class(Code.JsonObj).%New()
	s num=0
	s ruleid=0
	f  s ruleid=$o(^DHCSSPCS(ruleid)) q:ruleid=""  d
	.s level=$p(^DHCSSPCS(ruleid),"^",1)
	.s length=$p(^DHCSSPCS(ruleid),"^",2)
	.s start=$p(^DHCSSPCS(ruleid),"^",3)
	.s hospital=$p(^DHCSSPCS(ruleid),"^",4)
	.s data=ruleid_"^"_level_"^"_length_"^"_start_"^"_hospital
	.s num=num+1
	.d json.InsertRowData(data)
	s DetailInfo=json.getJsonData("RowId^NoLevel^NoLength^NoStart^Hospital",num)
	k json
	q DetailInfo
}

/// 保存药学分类代码生成规则
ClassMethod SaveNoRule(ListData As %String) As %String
{
	s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
    s Len=$l(ListData,rowDelim)
    s Err=0
    f i=1:1:Len  d
    .s Data=$p(ListData,rowDelim,i)
    .s rowid=$p(Data,"^",1)
    .i rowid'=""  d
    ..s Err=..UpdateNoRule(Data)
    .e  d
    ..s Err=..InsertNoRule(Data)
    q Err
}

ClassMethod InsertNoRule(Data As %String) As %String
{
	s locid=$G(%session.Data("LOGON.CTLOCID"))
	s hospid=$p(^CTLOC(locid),"^",22)
	s params=""_"^"_locid_"^"_""_"^"_hospid
	s level=$p(Data,"^",2)
    s length=$p(Data,"^",3)
    s start=$p(Data,"^",4)
    s hospital=$p(Data,"^",5)	
	&sql(insert into DHC_StkSysPHCCodeSet(PCS_Level,PCS_Length,PCS_Start,PCS_Hosp_Dr) values(:level,:length,:start,:hospital))
    s Err=0
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Insert:DHC_StkSysPHCCodeSet","",SQLCODE_":"_%msg)
    .s Err=-1
    q Err
}

ClassMethod UpdateNoRule(Data) As %String
{
	s locid=$G(%session.Data("LOGON.CTLOCID"))
	s hospid=$p(^CTLOC(locid),"^",22)
	s rowid=$p(Data,"^",1)
	s level=$p(Data,"^",2)
    s length=$p(Data,"^",3)
    s start=$p(Data,"^",4)
    s hospital=$p(Data,"^",5)
	&sql(update DHC_StkSysPHCCodeSet set PCS_Level=:level,PCS_Length=:length,PCS_Start=:start,PCS_Hosp_Dr=:hospital where PCS_RowId=:rowid)
    s Err=0
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Update:DHC_StkSysPHCCodeSet","",SQLCODE_":"_%msg)
    .s Err=-1
    q Err
}

/// 获取当前最大码
ClassMethod GetCurCode(catid, hospdr) As %String
{
	s locid=$G(%session.Data("LOGON.CTLOCID"))
	s hospid=$p(^CTLOC(locid),"^",22)
	s params=""_"^"_locid_"^"_""_"^"_hospid
	i catid=0 s level=1
	e  s level=$p(^DHCPHCC(catid),"^",4)+1
	s ruleid=$o(^DHCSSPCS(0,"LEVEL",+hospdr,level,""))
	q:ruleid="" ""
	s length=$p(^DHCSSPCS(ruleid),"^",2)
	s start=$p(^DHCSSPCS(ruleid),"^",3) 
	s curno=$p(^DHCSSPCS(ruleid),"^",5)
	i curno="" d
	.s curcode=$tr($j(start,length)," ","0")
	e  d
	.s curcode=$tr($j(curno+1,length)," ","0")
	q curcode
}

/// creator:yunhaibao
/// createdate:20161012
/// description:判断药学分类是否已经存在
/// output:-11:代码存在,-12:名称存在
/// w ##class(web.DHCST.DHCSTPHCCATMAINTAIN).CheckPhcCatExist(1,2,"","","",100000000)
ClassMethod CheckPhcCatExist(CatCode, CatDesc, Level, ParCat, HospId = "", CatId = "")
{
	i CatId'="" d
	.s Level=$p(^DHCPHCC(CatId),"^",4)
	.s ParCat=$p(^DHCPHCC(CatId),"^",3)
	s phccatexist=""
	s phccathosp=""
	s indexstr="CODE^DESC"
	f indexi=1:1:$l(indexstr,"^") d
	.s index=$p(indexstr,"^",indexi)
	.f  s phccathosp=$o(^DHCPHCC(0,index,phccathosp)) q:(phccathosp="")||(phccatexist'="")  d
	..q:(HospId'="")&&(HospId'=phccathosp)
	..i index="CODE" s mainindex=CatCode
	..i index="DESC" s mainindex=CatDesc
	..s phccatrowid=""
	..f  s phccatrowid=$o(^DHCPHCC(0,index,phccathosp,mainindex,phccatrowid)) q:(phccatrowid="")||(phccatexist'="")  d
	...q:+phccatrowid=0
	...q:(CatId'="")&&(CatId=phccatrowid)
	...s phclevel=$p(^DHCPHCC(phccatrowid),"^",4)
	...s phaparcat=$p(^DHCPHCC(phccatrowid),"^",3)
	...i (phclevel=Level)&&(phaparcat=ParCat) d
	....i index="CODE" s phccatexist=-11
	....i index="DESC" s phccatexist=-12
	q phccatexist
}

/// creator: yunhaibao
/// createdate:20170621
/// description:药学分类查询,EasyUI树
/// w ##class(web.DHCST.PHCCATMAINTAIN).jsQueryPhcCatTree("","","")
ClassMethod jsQueryPhcCatTree(rows, page, strParams)
{
	i rows="" s rows=9999
	i page="" s page=1
	s colNameStr="phcCatDesc^phcCatCode^phcCatRowId^_parentId^phcCatLevel^state"
	s endPage=page*rows 
	s startPage=((page-1)*rows)+1 
	s inputCatDesc=$p(strParams,"^",2)
	s inputCatCode=$p(strParams,"^",1)
	s inputAlias=$zcvt($p(strParams,"^",3),"U")
	s pid=..NewPid()
	s locId=$G(%session.Data("LOGON.CTLOCID"))
	s hospId=$p(^CTLOC(locId),"^",22)
	s params=""_"^"_locId_"^"_""_"^"_hospId
    s maintainWay=##class(web.DHCST.Common.AppCommon).GetAppPropValue(..%GetParameter("AppName"),"MaintainWay",params)  
    s hospRowId=""
    f  s hospRowId=$o(^DHCPHCC(0,"PARCAT",hospRowId)) q:hospRowId=""  d
    .q:(maintainWay="Y")&&(hospRowId'=hospId)
    .s parentId=""
	.f  s parentId=$o(^DHCPHCC(0,"PARCAT",hospRowId,parentId)) q:parentId=""  d
	..//q:'$d(^DHCPHCC(parentId))
	..s catId=""
	..f  s catId=$o(^DHCPHCC(0,"PARCAT",hospRowId,parentId,catId)) q:catId=""  d
	...s catDesc=$p(^DHCPHCC(catId),"^",2)
	...s catCode=$p(^DHCPHCC(catId),"^",1)
	...s quitFlag=""
	...q:(inputCatDesc'="")&&(catDesc'[inputCatDesc)
	...q:(inputCatCode'="")&&(catCode'[inputCatCode) 
	...i inputAlias'="" d
	....s catDescPY=##class(web.DHCST.Common.AppCommon).GetCNCODE(catDesc)
	....s catDescPY=$zcvt(catDescPY,"U")
	....i catDescPY'[inputAlias s quitFlag=1
	...q:quitFlag'=""
	...//q:$p(^DHCPHCC(catId),"^",4)<2
	...s ^TMP("DHCST",$this,"jsQueryPhcCatTree",pid,catId)=""
	s count=0
	s catId=""
	f  s catId=$o(^TMP("DHCST",$this,"jsQueryPhcCatTree",pid,catId)) q:catId=""  d
	.s count=count+1
	.q:count<startPage
    .q:count>endPage
    .s catCode=$p(^DHCPHCC(catId),"^",1)
	.s catDesc=$p(^DHCPHCC(catId),"^",2)
	.s parentId=$p(^DHCPHCC(catId),"^",3)
	.i '$d(^TMP("DHCST",$this,"jsQueryPhcCatTree",pid,parentId)) s parentId=""
	.i parentId=0 s parentId=""
	.s level=$p(^DHCPHCC(catId),"^",4)
	.s hospRowId=$p(^DHCPHCC(catId),"^",5)
	.//i level<2 s ifclose="open"
	.//e  s ifclose="open"
	.s ifclose="closed"
	.i ..CheckChildExist(catId)'=1 s ifclose=""
	.s outputData=catDesc_"^"_catCode_"^"_catId_"^"_parentId_"^"_level_"^"_ifclose
	.I count=startPage d
	..w ##class(web.DHCSTJQUERYCOMMON).getJsonRowSign()
	..W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputData,"^")
	.e  d
	..W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputData,"^")
	k ^TMP("DHCST",$this,"jsQueryPhcCatTree",pid)
	q:count>0 "],""total"""_":"_count_"}"
	w ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	q ""
}

/// creator:    yunhaibao
/// createdate: 20170622
/// description:根据药学分类ID获取分类信息
/// w ##class(web.DHCST.DHCSTPHCCATMAINTAIN).GetPhcCatInfoByRowId("15")
ClassMethod GetPhcCatInfoByRowId(catRowId)
{
	s catRowId=+catRowId
	q:catRowId=0 ""
	q:'$d(^DHCPHCC(catRowId)) ""
    s catCode=$p(^DHCPHCC(catRowId),"^",1)
	s catDesc=$p(^DHCPHCC(catRowId),"^",2)
	s parentId=$p(^DHCPHCC(catRowId),"^",3)
	s level=$p(^DHCPHCC(catRowId),"^",4)
	s hospRowId=$p(^DHCPHCC(catRowId),"^",5)
	s retStr=catCode_"^"_catDesc_"^"_parentId_"^"_level_"^"_hospRowId
	q retStr
}

/// creator:    yunhaibao
/// createdate: 2017-07-13
/// description:层级关系药品信息维护删除药学分类
/// w ##class(web.DHCST.DHCSTPHCCATMAINTAIN).Delete("15")
ClassMethod Delete(phcCatId)
{
	s chkRet=##class(web.DHCST.DrugLink).CheckPhcCatLink(phcCatId)
	q:+chkRet<0 chkRet
	s delRet=..DeleteCat(phcCatId)
	q:delRet'=0 -1_"^删除失败!"
	q 0
}

/// creator:	yunhaibao
/// createdate: 2017-07-14
/// description:获取药学分类id下的所有子类
/// input:      phcCatId(药学分类ID)
/// return:     分类串^
/// w ##class(web.DHCST.DHCSTPHCCATMAINTAIN).GetChildrenNodes(47)
ClassMethod GetChildrenNodes(phcCatId, phcCatStr = "") As %String
{
	q:phcCatId="" ""
	s hospId=2
	s tmpCatStr=""
	s catRowId=""
	f  s catRowId=$o(^DHCPHCC(0,"PARCAT",hospId,phcCatId,catRowId)) q:catRowId=""  d
	.i tmpCatStr="" s tmpCatStr=catRowId
	.e  s tmpCatStr=tmpCatStr_","_catRowId
	.i phcCatStr="" s phcCatStr=catRowId
	.e  s phcCatStr=phcCatStr_","_catRowId
	s i=0
	f i=1:1:$l(tmpCatStr,",") d
	.s tmpPhcCatId=$p(tmpCatStr,",",i)
	.q:tmpPhcCatId=""
	.d ..GetChildrenNodes(tmpPhcCatId,.phcCatStr)
	q phcCatStr
}

/// creator: yunhaibao
/// createdate:2017-09-13
/// description:获取子类ID
/// return: 1-存在
ClassMethod CheckChildExist(parentId)
{
	s exist=""
	q:parentId="" ""
	s num=0
	s locid=$G(%session.Data("LOGON.CTLOCID"))
	s hospid=$p(^CTLOC(locid),"^",22)
	s params=""_"^"_locid_"^"_""_"^"_hospid
    s maintainway=##class(web.DHCST.Common.AppCommon).GetAppPropValue(..%GetParameter("AppName"),"MaintainWay",params)  //是否分院区维护
    s hosprowid=""
    f  s hosprowid=$o(^DHCPHCC(0,"PARCAT",hosprowid)) q:hosprowid=""  d
    .q:(maintainway="Y")&&(hosprowid'=hospid)
    .i $d(^DHCPHCC(0,"PARCAT",hosprowid,parentId)) s exist=1
    q exist
}

}
