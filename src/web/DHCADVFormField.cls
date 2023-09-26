Import SQLUser

/// Creator: 		bianshuai
/// CreateDate: 	2017-12-12
/// Descript: 		表单业务字段维护
Class web.DHCADVFormField Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:	表单业务字段维护
/// w ##class(web.DHCADVFormField).saveFormField("8^000003^测试000003^N^65")
ClassMethod saveFormField(mListData As %String) As %String
{
	n (mListData)
	s Len=$L(mListData,"$$")
	s Err=0
	F i=1:1:Len Q:Err'=0  D
	.s mdata=$p(mListData,"$$",i)
	.s Err=..isExist(mdata)   /// 重复性判断
	.Q:Err'=0
	.i $p(mdata,"^",1) ="" d
	..s Err=..insert(mdata)
	.e  d
	..s Err=..update(mdata)
	Q Err
}

/// Descript:	增加 表单业务字段维护
/// w ##class(web.DHCADVFormField).insert("")
ClassMethod insert(ItmTempStr As %String) As %String
{
	n (ItmTempStr)
	s FieldCode=$p(ItmTempStr,"^",2)   	/// 字段代码
	s FieldDesc=$p(ItmTempStr,"^",3)   	/// 字段描述
 	&SQL(INSERT INTO DHC_AdvFormField(AF_FieldCode, AF_FieldDesc) VALUES(:FieldCode,:FieldDesc))
 	q SQLCODE
}

/// Descript:	更新 表单业务字段维护
/// w ##class(web.DHCADVFormField).update("")
ClassMethod update(ItmTempStr As %String) As %String
{
	n (ItmTempStr)
	s ID=$p(ItmTempStr,"^",1)   		/// ID
	s FieldCode=$p(ItmTempStr,"^",2)   	/// 字段代码
	s FieldDesc=$p(ItmTempStr,"^",3)   	/// 字段描述
	&SQL(Update DHC_AdvFormField Set AF_FieldCode=:FieldCode,AF_FieldDesc=:FieldDesc WHERE AF_RowID=:ID)
 	q SQLCODE
}

/// Descript:	删除 表单业务字段维护
/// w ##class(web.DHCADVFormField).delFormField("1")
ClassMethod delFormField(ID As %String) As %String
{
	N (ID)
	&SQL(Delete From DHC_AdvFormField Where AF_RowID=:ID)
	Q SQLCODE
}

/// Descript:检查代码、描述是否重复
ClassMethod isExist(ItmTempStr As %String) As %String
{
	N (ItmTempStr)
	s ID=$p(ItmTempStr,"^",1)   		/// ID
	s FieldCode=$p(ItmTempStr,"^",2)   	/// 字段代码
	s FieldDesc=$p(ItmTempStr,"^",3)   	/// 字段描述
	/// 新记录
	q:(ID="")&($d(^DHCADVFF(0,"Code",$$ALPHAUP^SSUTIL4(FieldCode)))) "-1"
	q:(ID="")&($d(^DHCADVFF(0,"Desc",$$ALPHAUP^SSUTIL4(FieldDesc)))) "-2"
	q:ID="" 0
	
	/// 修改记录
	s Code=$p($g(^DHCADVFF(ID)),"^",1)    //代码
	s Desc=$p($g(^DHCADVFF(ID)),"^",2)    //描述
	q:(FieldCode'=Code)&($d(^DHCADVFF(0,"Code",$$ALPHAUP^SSUTIL4(FieldCode)))) "-3"
	q:(FieldDesc'=Desc)&($d(^DHCADVFF(0,"Desc",$$ALPHAUP^SSUTIL4(FieldDesc)))) "-4"
	q 0
}

/// Descript:	查询 表单业务字段维护
/// w ##class(web.DHCADVFormField).QryFormField("12","1","")
ClassMethod QryFormField(rows As %String, page As %String, params As %String) As %String
{
	N (rows,page,params)
	s End = page*rows
	s Start=(page-1)*rows+1
	
    s pid=##Class(web.DHCADVCOMMON).NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
	
	s h=0,count=0
	s ID="0"
	F  s ID=$o(^DHCADVFF(ID)) Q:ID=""  D
	.s FieldCode=$p(^DHCADVFF(ID),"^",1)    /// 字段代码
	.s FieldDesc=$p(^DHCADVFF(ID),"^",2)    /// 字段描述
	.s h=h+1
	.s ListData=ID_"^"_FieldCode_"^"_FieldDesc
	.s ^TMP("DHCADV","web.DHCADVFormField","QryFormField",pid,h)=ListData
	
	i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	Q:h=0 ""
	
	///转换数据为Json格式
	S ListTitle="ID^FieldCode^FieldDesc"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCADV","web.DHCADVFormField","QryFormField",pid,index)) q:index=""  d
	.s ListData=$g(^TMP("DHCADV","web.DHCADVFormField","QryFormField",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	N (pid)
	k ^TMP("DHCADV","web.DHCADVFormField","QryFormField",pid)
	q ""
}

}
