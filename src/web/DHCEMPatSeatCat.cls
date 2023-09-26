Import SQLUSER

Class web.DHCEMPatSeatCat Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：      zhaowuqiang
/// CreatDate：    2016-12-14
/// Description:： 查询座位类别表
/// Table：        DHC_EmPatSeatCat 
/// Others：       w ##class(web.DHCEMPatSeatCat).QuerySeatCat("")
ClassMethod QuerySeatCat(params As %String, code, desc, HospDr) As %String
{
	;s end=page*rows
	;s start=(page-1)*rows+1
	s pid=..NewPid()	
	d ..killTmpGlobal(pid)    //k掉临时global
	s:code="" code=$p(params,"^",1)    //在串params中取值 
	s:desc="" desc=$p(params,"^",2)	   //
	s h=0,count=0
	s seatid = ""
	f  s seatid = $o(^DHCEMPSC(seatid)) q:seatid=""  d    //table:DHC_EmPatSeatCat
	.q:seatid=0
	.s seatcode = $p(^DHCEMPSC(seatid),"^",1)
	.s seatdesc = $p(^DHCEMPSC(seatid),"^",2)
	.s enabled = $p(^DHCEMPSC(seatid),"^",3)
	.;s hosdesc = $p(^DHCEMPSC(seatid),"^",4)
	.s hosid = $p(^DHCEMPSC(seatid),"^",4)
	.s color = $p(^DHCEMPSC(seatid),"^",5)
	.;q:+hosid=0 //hxy 2019-09-19 注释 云his公有
	.;q:'$d(^CT("HOSP",hosid)) //hxy 2019-09-19 注释
	.s hosdesc="" //hxy 2019-09-19 st add
	.s:hosid'="" hosdesc = $p(^CT("HOSP",hosid),"^",2) //ed change
	.q:(code'="")&(seatcode'[code)
	.q:(desc'="")&(seatdesc'[desc)
	.s RealHospDr=##Class(web.DHCEMCommonUtil).GetDefHospIdByTableName("DHC_EmPatSeatCat",HospDr) //hxy 2020-05-22 st
	.q:hosid'=RealHospDr //ed
	.s h=h+1
	.s tempstr=seatid_"^"_seatcode_"^"_seatdesc_"^"_enabled_"^"_hosdesc_"^"_color_"^"_color_"^"_hosid
	.s ^TMP("DHCSEATCAT","web.DHCPatSeatCat","QuerySeatCat",pid,h)=tempstr
	
	q:h=0 ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	s title="seatid^seatcode^seatdesc^enabled^hosdesc^seatcolor^seatcolorvalue^hospId"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCSEATCAT","web.DHCPatSeatCat","QuerySeatCat",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCSEATCAT","web.DHCPatSeatCat","QuerySeatCat",pid,index))
	.s count = count+1
	.w $case(count,1:"",:",")
	.w ##class(web.DHCAPPJsonCommon).getJsonData(title,mdate)
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Creator：      zhaowuqiang
/// CreatDate：    2016-12-14
/// Description:： 保存座位类别分类表
/// Table：        DHC_EmPatSeatCat 
/// w ##class(web.DHCEMPatSeatCat).SaveSeatCat("^成人E^成人E^Y^2^")
ClassMethod SaveSeatCat(params As %String) As %String
{
	n (params)
  	s ret=0
	s len=$L(params,"&&")
	f i=1:1:len d
	.s tmpstr=$p(params,"&&",i)
	.i $p(tmpstr,"^",1)'="" q:ret'=0  d
	..s ret=..UpdSeatCat(tmpstr)
	.e  d
	..s ret=..AddSeatCat(tmpstr)
	q ret
}

/// Creator：      sufan
/// CreatDate：    2016-4-14
/// Description:： 更新座位类别分类表
/// Table：        DHC_EmPatSeatCat 
/// Others：       w ##class(web.DHCPatSeatCat).UpdSeatCat("1^001^ds^普通床位")
ClassMethod UpdSeatCat(params As %String) As %String
{
	n (params)
	s seatid=$p(params,"^",1)
	s code=$p(^DHCEMPSC(seatid),"^",1)
	s seatcode=$p(params,"^",2) 
	i seatcode'=code  q:$d(^DHCEMPSC(0,"Code",seatcode)) -96 //hxy 2020-05-22 注释 //hxy 2023-01-18放开注释 私有数据医院组间代码不能重复
	s seatdesc=$p(params,"^",3)
	s enabled=$p(params,"^",4)
	s hospId=$p(params,"^",5)
	s color=$p(params,"^",6)       //huaxiaoying 2017-01-06
#;	s IDUP=..CheckExistCode(seatcode,hospId) //hxy 2020-05-22 add st //2023-01-18 注释
#;	Q:(IDUP'=0)&(seatid'=IDUP) -96
	s IDUP=..CheckExistDesc(seatdesc,hospId)
	Q:(IDUP'=0)&(seatid'=IDUP) -95 //ed
	;s ordcatdr=$o(^ARC("IC",0,"Desc",$$ALPHAUP^SSUTIL4(arcicdesc),""))
	;i ordcatdr'=dr  q:$d(^DHCAPARCCA(0,"IndexOrdCatDr",ordcatdr)) -95
	&sql(update DHC_EmPatSeatCat set PSC_Color=:color,PSC_Code=:seatcode,PSC_Desc=:seatdesc,PSC_ActiveFlag=:enabled,PSC_Hosp_Dr=:hospId where PSC_RowID=:seatid )
	q SQLCODE
}

/// Creator：      zhaowuqiang
/// CreatDate：    2016-12-14
/// Description:： 增加座位类别分类表
/// Table：        DHC_EmPatSeatCat 
/// Others：       w ##class(web.DHCPatSeatCat).AddSeatCat("^005^ds^CT")
ClassMethod AddSeatCat(params As %String) As %String
{
	n (params)
	s seatcode=$p(params,"^",2)
	q:$d(^DHCEMPSC(0,"Code",seatcode)) -96 //hxy 2020-05-22 注释 //hxy 2023-01-18放开注释 私有数据医院组间代码不能重复
	s seatdesc=$p(params,"^",3)
	s enabled=$p(params,"^",4)
	s hosid=$p(params,"^",5) //huaxiaoying 2017-01-06
	s color=$p(params,"^",6) //huaxiaoying 2017-01-06
	;q:$d(^DHCEMPSC(0,"Desc",seatdesc)) -95 //hxy 2020-05-22 注释 
	;Q:..CheckExistCode(seatcode,hosid) -96 //hxy 2020-05-22 st //2023-01-18 注释
	Q:..CheckExistDesc(seatdesc,hosid) -95 //ed
	&sql(insert into DHC_EmPatSeatCat (PSC_Code,PSC_Desc,PSC_ActiveFlag,PSC_Hosp_Dr,PSC_Color) values (:seatcode,:seatdesc,:enabled,:hosid,:color))
	q SQLCODE
}

/// Creator：      zhaowuqiang
/// CreatDate：    2016-12-14
/// Description:： 删除座位类别分类表
/// Table：        DHC_EmPatSeatCat 
/// Others：       w ##class(web.DHCEMPatSeatCat).DelSeatCat("5")
ClassMethod DelSeatCat(params As %String) As %String
{
	n (params)
	;s catcode=$p(^DHCAPARCCA(params),"^",1)
	;k ^DHCAPARCCA(0,"IndexCatCode",catcode,params)
	;q:$d(^DHCAPARCCA(params,"A")) -1
	;q:$d(^DHCAPCATO(params,"O")) -2
	q:$d(^DHCEMPSE("0","Cat",params)) "-1024"
	&sql(delete from DHC_EmPatSeatCat where PSC_RowID=:params)
	q SQLCODE
}

/// Creator：      zhaowuqiang
/// CreatDate：    2016-12-14
/// Description:： 查询座位类别描述
/// Table：        DHC_EmPatSeatCat 
/// Others：       w ##class(web.DHCPatSeatCat).SelHosDesc()
ClassMethod SelHosDesc() As %String
{
	s count=0
	w "["
	s hosid=""
	f  s hosid=$o(^CT("HOSP",hosid)) q:hosid=""  d
	.q:hosid=0
	.s hoscode=$p(^CT("HOSP",hosid),"^",1)
	.s hosdesc=$p(^CT("HOSP",hosid),"^",2)
	.//q:arcicordertype'="X" 
	.s tmp=hoscode_"^"_hosdesc
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	w "]"
	q ""
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	n (pid)
	k ^TMP("SEATCAT","web.DHCPatSeatCat","QuerySeatCat",pid)
}

/// Descript:计数器
ClassMethod NewPid() As %String
{
	Q $I(^TMP("SEATCAT"))
}

/// w ##class(web.DHCPatSeatCat).CheckExistCode("1","2")
ClassMethod CheckExistCode(Code, HospDr)
{
	s ret=0
	s ID=0
	f  s ID=$o(^DHCEMPSC(0,"Code",Code,ID)) q:ID=""  d
	.s RLHospDr=$p(^DHCEMPSC(ID),"^",4)
	.q:HospDr'=RLHospDr
	.s ret=ID
	q ret
}

/// w ##class(web.DHCPatSeatCat).CheckExistDesc("1","2")
ClassMethod CheckExistDesc(Desc, HospDr)
{
	s ret=0
	s ID=0
	f  s ID=$o(^DHCEMPSC(0,"Desc",Desc,ID)) q:ID=""  d
	.s RLHospDr=$p(^DHCEMPSC(ID),"^",4)
	.q:HospDr'=RLHospDr
	.s ret=ID
	q ret
}

}
