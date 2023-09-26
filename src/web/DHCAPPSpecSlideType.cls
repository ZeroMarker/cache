Import SQLUSER

/// Creator: 	 QuNianpeng
/// CreateDate:  2017-07-08
/// Descript:    标本玻片类型字典表数据操作类
Class web.DHCAPPSpecSlideType Extends %Library.RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：      QuNianpeng
/// CreatDate：    2017-07-08
/// Description:： 【保存】标本玻片类型字典表数据
/// Table：        DHC_APPSpecSlideType
/// Input:		   标本玻片类型数据信息。 以字符"^"分割，格式为 id^代码^描述^医院描述^医院id^是否可用$$代码^描述^医院描述^医院id^是否可用
/// Return：	   保存成功0 失败 非0
/// Others：       w ##class(web.DHCAPPSpecSlideType).SaveSpecSlideType("1^0011^病理标本^东华标准版数字化医院^2^Y")
ClassMethod SaveSpecSlideType(params As %String) As %String
{
	n (params)
	s $Zt="Err"
	s err=0
	s len=$L(params,"$$")
	TS
	f i=1:1:len d
	.s tmpStr=$p(params,"$$",i)
	.s err=..CheckRepeat(tmpStr)   /// 重复性判断
	.q:err'=0
	.i ($p(tmpStr,"^",1)'="")&($p(tmpStr,"^",1)'=0) d
	..s err=..UpdateSpecSlideType(tmpStr)
	..q:err'=0
	.e  d
	..s err=..InsertSpecSlideType(tmpStr)
	..q:err'=0
	

	i err'=0 Tro
	TC
	q err
	
Err
	TRo
	i err=0 s err=-1
	q err
}

/// Creator：      QuNianpeng
/// CreatDate：    2017-07-08
/// Description:： 【保存】标本玻片类型字典表数据
/// Table：        DHC_APPSpecSlideType
/// Input:		   标本玻片类型数据信息。 以字符"^"分割，格式为 id^代码^描述^医院描述^医院id^是否可用
/// Return：	   保存成功0 失败 非0
/// Others：       w ##class(web.DHCAPPSpecSlideType).InsertSpecSlideType("^001^病理病人^2^Y")
ClassMethod InsertSpecSlideType(params As %String) As %String
{
	n (params)
	
	s ASTCode=$p(params,"^",2)
	s ASTDesc=$p(params,"^",3)
	s ASTHospDr=$p(params,"^",4)	//插入时界面hospDesc字段就是hospDr
	s ASTActiveFlag=$p(params,"^",7)
	
	&sql(insert into DHC_APPSpecSlideType (AST_Code,AST_Desc,AST_Hosp_Dr,AST_ActiveFlag) values (:ASTCode,:ASTDesc,:ASTHospDr,:ASTActiveFlag))
	q SQLCODE
}

/// Creator：      QuNianpeng
/// CreatDate：    2017-07-08
/// Description:： 【删除】标本玻片字典表数据
/// Table：        DHC_APPSpecSlideType
/// Input:		   表的id
/// Return：	   删除成功 0,删除失败 非0
/// Others：       w ##class(web.DHCAPPSpecSlideType).DeleteSpecSlideType("1")
ClassMethod DeleteSpecSlideType(astRowId As %String) As %String
{
	n (astRowId)
	&SQL(Delete From DHC_APPSpecSlideType Where AST_RowId=:astRowId)
	Q SQLCODE
}

/// Creator：      QuNianpeng
/// CreatDate：    2017-07-08
/// Description:：【新】标本玻片类型字典表数据
/// Table：        DHC_APPSpecSlideType
/// Input:		   分类数据信息。 以字符"^"分割，格式为 id^代码^描述^医院描述^医院id^是否可用
/// Return：	   更新成功0 失败 非0
/// Others：       w ##class(web.DHCAPPSpecSlideType).UpdateSpecSlideType("1^0011^病理标本^东华标准版数字化医院^2^Y")
ClassMethod UpdateSpecSlideType(params As %String) As %String
{
	n (params)
	s astRowId=$p(params,"^",1)
	s astCode=$p(params,"^",2)
	s astDesc=$p(params,"^",3)
	s astHospDesc=$p(params,"^",4)
	s hospDr=$p(params,"^",5)
	s astActiveFlag=$p(params,"^",7)
	s astHospDr=astHospDesc
	i ((+astHospDesc=0)&&(astHospDesc'=0)) s astHospDr=hospDr  //更新时，描述未改变，取dr字段值。否则desc就是id

	&SQL(Update DHC_APPSpecSlideType Set AST_Code=:astCode,AST_Desc=:astDesc,AST_Hosp_Dr=:astHospDr,AST_ActiveFlag=:astActiveFlag Where AST_RowId=:astRowId)
	Q SQLCODE
}

/// Creator：      QuNianpeng
/// CreatDate：    2017-07-08
/// Description:： 【查询】标本玻片类型字典表数据
/// Table：        DHC_APPSpecSlideType
/// Input:		   代码或描述
/// Return：	   分类信息
/// Others：       w ##class(web.DHCAPPSpecSlideType).QuerySpecSlideType(100,1,"")
ClassMethod QuerySpecSlideType(rows As %String, page As %String, params As %String) As %String
{
	n (rows,page,params)

	s end = page*rows
	s start = (page-1)*rows+1
    //s pid=##Class(web.DHCAPPPathCom).NewPid()  //没有
    s pid=##Class(web.DHCAPPExaRepCom).NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    s code=$p(params,"^",1)
    s desc=$p(params,"^",2)
	s h=0,count=0
	s astRowId=""
	f  s astRowId=$o(^DHCAPPSST(astRowId)) q:astRowId=""  d
	.q:astRowId=0
	.s astCode=$p(^DHCAPPSST(astRowId),"^",1)
	.s astDesc=$p(^DHCAPPSST(astRowId),"^",2)
	.s astHospDr=$p(^DHCAPPSST(astRowId),"^",3)
	.s astHospDesc=""
	.i astHospDr'="" s astHospDesc=$P(^CT("HOSP",astHospDr),"^",2)
	.s astActiveFlag=$p(^DHCAPPSST(astRowId),"^",4)
	.s ActiveFlagCode=astActiveFlag
	.s astActiveFlag=$s(astActiveFlag="Y":"是",astActiveFlag="N":"否",1:"")
	.q:(code'="")&(astCode'[code)
	.q:(desc'="")&(astDesc'[desc)
	.s h=h+1
	.s tmpStr=astRowId_"^"_astCode_"^"_astDesc_"^"_astHospDesc_"^"_astHospDr_"^"_astActiveFlag_"^"_ActiveFlagCode
	.s ^TMP("DHCAPP","web.DHCAPPSpecSlideType","QuerySpecSlideType",pid,h)=tmpStr
	
	q:h=0 ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	s title="astRowId^astCode^astDesc^astHospDesc^astHospDr^astActiveFlag^ActiveFlagCode"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCAPP","web.DHCAPPSpecSlideType","QuerySpecSlideType",pid,index)) q:index=""  d
	.s mdata=$g(^TMP("DHCAPP","web.DHCAPPSpecSlideType","QuerySpecSlideType",pid,index))
	.s count = count+1
	.q:(count<start)||(count>end)
	.i count=start d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(title,mdata)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(title,mdata)
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Description: 保存[检查代码、描述是否重复]
/// Creator:     QuNianpeng
/// CreateDate:  2017-07-08
/// Table:		 DHC_APPSpecSlideType
/// Input:		   id^代码^描述
/// Return：	   不重复0 重复 非0
/// Others:		 w ##class(web.DHCAPPSpecSlideType).CheckRepeatSpecSlideType("1^0011^病理标本^东华标准版数字化医院^2^Y")
ClassMethod CheckRepeatSpecSlideType(tmpStr As %String) As %String
{
	n (tmpStr)
	s rowId=$p(tmpStr,"^",1)
	s code=$p(tmpStr,"^",2)
	s desc=$p(tmpStr,"^",3)

	/// 新记录
	q:(+rowId=0)&$d(^DHCAPPSST(0,"Code",$$ALPHAUP^SSUTIL4(code))) -2 
	q:(+rowId=0)&$d(^DHCAPPSST(0,"Desc",$$ALPHAUP^SSUTIL4(desc))) -3
	q:+rowId=0 0

	/// 修改记录
	s codeFlag=0
	s descFlag=0
	s accRowId=0
	//判断代码重复性
	i $d(^DHCAPPSST(0,"Code",$$ALPHAUP^SSUTIL4(code))) d
	.s accRowId=$o(^DHCAPPSST(0,"Code",$$ALPHAUP^SSUTIL4(code),""))
	.q:rowId=accRowId 
	.s codeFlag=1

	//判断描述重复性
	i $d(^DHCAPPSST(0,"Desc",$$ALPHAUP^SSUTIL4(desc))) d
	.s accRowId=$o(^DHCAPPSST(0,"Desc",$$ALPHAUP^SSUTIL4(desc),""))
	.q:rowId=accRowId 
	.s descFlag=1

	q:codeFlag=1 -2
	q:descFlag=1 -3

	q 0
}

/// Creator：  sufan
/// CreatDate: 2017-07-06
/// Descript:  检查代码、描述是否重复
/// Table：    User.DHCAppPatRec
/// Others：   w ##class(web.DHCAPPPatRec).CheckRepeat("^11^11^65^Y")
ClassMethod CheckRepeat(ItmTempStr As %String) As %String
{
	n (ItmTempStr)
	s ret=0
	s ID=$p(ItmTempStr,"^",1)   	 ///ID
	s APCode=$p(ItmTempStr,"^",2)  	 ///代码
	s APDesc=$p(ItmTempStr,"^",3) 	 ///描述
	s HospID=$p(ItmTempStr,"^",4)	 ///医院ID
	/// 新记录
	if ID=""  d
	.i $d(^DHCAPPSST(0,"Code",$$ALPHAUP^SSUTIL4((APCode))))   d
	..s APID=""
	..for  s APID=$o(^DHCAPPSST(0,"Code",$$ALPHAUP^SSUTIL4(APCode),APID)) q:(APID="")||(ret'=0)  d
	...s HospDr=$p(^DHCAPPSST(APID),"^",3)
	...q:HospDr'=HospID
	...s ret=-1
	..
	.
	.i $d(^DHCAPPSST(0,"Desc",$$ALPHAUP^SSUTIL4(APDesc)))  d
	..s APID=""
	..f  s APID=$o(^DHCAPPSST(0,"Desc",$$ALPHAUP^SSUTIL4(APDesc),APID))  q:(APID="")||(ret'=0)  d
	...s HospDr=$p(^DHCAPPSST(APID),"^",3)
	...q:HospDr'=HospID
	...s ret=-2
	..
	.
	/// 修改记录
	else  d
	.s Code=$p($g(^DHCAPPSST(ID)),"^",1)    //代码
	.s Desc=$p($g(^DHCAPPSST(ID)),"^",2)    //描述
	.i (Code'=APCode)&($d(^DHCAPPSST(0,"Code",$$ALPHAUP^SSUTIL4(APCode))))  d
	..s APID=""
	..f  s APID=$o(^DHCAPPSST(0,"Code",$$ALPHAUP^SSUTIL4(APCode),APID)) q:(APID="")||(ret'=0)  d
	...s HospDr=$p(^DHCAPPSST(APID),"^",3)
	...q:HospDr'=HospID
	...s ret=-3
	..
	.
	.i (Desc'=APDesc)&($d(^DHCAPPSST(0,"Desc",$$ALPHAUP^SSUTIL4(APDesc))))  d
	..s APID=""
	..f  s APID=$o(^DHCAPPSST(0,"Desc",$$ALPHAUP^SSUTIL4(APDesc),APID)) q:(APID="")||(ret'=0)  d
	...s HospDr=$p(^DHCAPPSST(APID),"^",3)
	...q:HospDr'=HospID
	...s ret=-4
	..
	.
	q ret
}

/// Description: k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCAPP","web.DHCAPPSpecSlideType","QuerySpecSlideType",pid)
}

}
