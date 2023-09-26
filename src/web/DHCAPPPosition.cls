Import SQLUSER

Class web.DHCAPPPosition Extends %Library.RegisteredObject [ ClassType = "", NoExtent, Not ProcedureBlock ]
{

/// Creator：      sufan
/// CreatDate：    2016-4-12
/// Description:： 查询体位表
/// Table：        DHC_AppPosition 
/// Others：       w ##class(web.DHCAPPPosition).QueryPosition("11","1","")
ClassMethod QueryPosition(rows As %String, page As %String, params As %String, HospID As %String = "") As %String
{
	n (rows,page,params,HospID)
	s end=page*rows
	s start=(page-1)*rows+1
	s pid=##Class(web.DHCAPPExaRepCom).NewPid()	
	d ..killTmpGlobal(pid)    //k掉临时global
	s code=$p(params,"^",1)    //在串params中取值
	s desc=$p(params,"^",2)
	s h=0,count=0
	s aprowid=""
	f  s aprowid=$o(^DHCAPPOS(aprowid)) q:aprowid=""  d  //查询表DHC_AppPosition
	.q:aprowid=0
	.s apcode=$p(^DHCAPPOS(aprowid),"^",1)
	.s apdesc=$p(^DHCAPPOS(aprowid),"^",2)
	.s apactiveflag=$p(^DHCAPPOS(aprowid),"^",3)
	.s apactiveflag=$s(apactiveflag="Y":"是",apactiveflag="N":"否",1:"")
	.s aphospdr=+$p(^DHCAPPOS(aprowid),"^",4)
	.q:((HospID'="")&&(aphospdr'=HospID))
	.s hospdesc=""
	.i aphospdr'=0 d
	..s hospdesc=$p(^CT("HOSP",aphospdr),"^",2)
	.q:(code'="")&(apcode'[code)
	.q:(desc'="")&(apdesc'[desc)
	.s h=h+1
	.s tempstr=aprowid_"^"_apcode_"^"_apdesc_"^"_apactiveflag_"^"_aphospdr_"^"_hospdesc
	.s ^TMP("DHCST","web.DHCAPPPosition","QueryPosition",pid,h)=tempstr
	
	q:h=0 ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	s title="aprowid^apcode^apdesc^apactiveflag^aphospdr^hospdesc"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCAPPPosition","QueryPosition",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCST","web.DHCAPPPosition","QueryPosition",pid,index))
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

/// Creator：      sufan
/// CreatDate：    2016-4-12
/// Description:： 保存体位表
/// Table：        DHC_AppPosition 
ClassMethod SavePosition(params As %String) As %String
{
  	n (params)
  	s ret=0
	s len=$L(params,"&&")
	f i=1:1:len d
	.s tmpstr=$p(params,"&&",i)
	.i $p(tmpstr,"^",1)'="" q:ret'=0  d
	..s ret=..UpdPosition(tmpstr)
	.e  d
	..s ret=..AddPosition(tmpstr)
	q ret
}

/// Creator：      sufan
/// CreatDate：    2016-4-12
/// Description:： 增加体位表
/// Table：        DHC_AppPosition 
/// Others：       w ##class(web.DHCAPPPosition).AddPosition("^d^d^Y^2")
ClassMethod AddPosition(params As %String) As %String
{
	n (params)
	s apcode=$p(params,"^",2)
	s aphospdr=$p(params,"^",5)
	q:$d(^DHCAPPOS(0,"Code",$$ALPHAUP^SSUTIL4(apcode),aphospdr)) -1
	s apdesc=$p(params,"^",3)
	q:$d(^DHCAPPOS(0,"Desc",$$ALPHAUP^SSUTIL4(apdesc),aphospdr)) -2
	s apactiveflag=$p(params,"^",4)
	&sql(insert into DHC_AppPosition (AP_Code,AP_Desc,AP_ActiveFlag,AP_Hosp_Dr)values (:apcode,:apdesc,:apactiveflag,:aphospdr ))
	q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2016-4-12
/// Description:： 更新体位表
/// Table：        DHC_AppPosition 
/// Others：       w ##class(web.DHCAPPPosition).UpdPosition("48^f^ff^Y^3^3")
ClassMethod UpdPosition(params As %String) As %String
{
  	n (params)
  	s aprowid=$p(params,"^",1)
	s apcode=$p(params,"^",2)
	s aphospdr=$p(params,"^",5)
	s code=$p(^DHCAPPOS(aprowid),"^",1)
	s desc=$p(^DHCAPPOS(aprowid),"^",2)
	i code'=apcode q:$d(^DHCAPPOS(0,"Code",$$ALPHAUP^SSUTIL4(apcode),aphospdr)) -3
	s apdesc=$p(params,"^",3)
	i desc'=apdesc q:$d(^DHCAPPOS(0,"Desc",$$ALPHAUP^SSUTIL4(apdesc),aphospdr)) -4
	s apactiveflag=$p(params,"^",4)
	i apactiveflag="是" s apactiveflag="Y"
	i apactiveflag="否" s apactiveflag="N"
	&sql(update DHC_AppPosition set AP_Code=:apcode,AP_Desc=:apdesc,AP_ActiveFlag=:apactiveflag,AP_Hosp_Dr=:aphospdr where AP_RowID=:aprowid )
	q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2016-4-12
/// Description:： 删除体位表
/// Table：        DHC_AppPosition 
/// Others：       w ##class(web.DHCAPPPosition).DelPosition("0")
ClassMethod DelPosition(params As %String) As %String
{
	n (params)
	s apcode=$p(^DHCAPPOS(params),"^",1)
	k ^DHCAPPOS(0,"Code",$$ALPHAUP^SSUTIL4(apcode),params)
  	&sql(delete from DHC_AppPosition where AP_RowID=:params )
  	q SQLCODE
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	n (pid)
	k ^TMP("DHCST","web.DHCAPPPosition","QueryPosition",pid)
}

}
