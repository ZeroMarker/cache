Import SQLUser

/// Creator: 		sunhuiyong
/// CreateDate: 	2022-02-22
/// Descript: 		案例收藏模块字典维护类
Class web.PrescCaseCollectModule Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:查询[案例收藏模块字典]
/// w ##class(web.PrescCaseCollectModule).QryPrescCase("12","1","")
ClassMethod QryPrescCase(rows As %String, page As %String, params As %String) As %String
{
	N (rows,page,params)
	s End = page*rows
	s Start=(page-1)*rows+1
	k TmpItemDet
	s h=0,count=0
	s ID="0"
	F  s ID=$o(^PHA.PREADT.CaseCollectModuleD(ID)) Q:ID=""  D
	.s Code=$lg(^PHA.PREADT.CaseCollectModuleD(ID),2)    //代码
	.s Desc=$lg(^PHA.PREADT.CaseCollectModuleD(ID),3)    //描述
	.s h=h+1
	.s ListData=ID_"^"_Code_"^"_Desc
	.s TmpItemDet(ID)=ListData
	
	i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	Q:h=0 ""
	
	///转换数据为Json格式
	s ListTitle="ID^Code^Desc"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s index=""
	F  s index=$o(TmpItemDet(index)) Q:index=""  D
	.s ListData=$g(TmpItemDet(index))
	.s count = count+1
	.Q:(count<Start)||(count>End)
	.I count=Start D
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.e  D
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符

	Q ""
}

/// Descript:	删除 [案例收藏模块字典]
/// w ##class(web.PrescCaseCollectModule).DeletePrescCase("1")
ClassMethod DeletePrescCase(ID As %String) As %String
{
	N (ID)
	&SQL(Delete From PHA_PREADT.CaseCollectModule Where ID=:ID)
	Q SQLCODE
}

/// Descript:	保存 [案例收藏模块字典]
/// w ##class(web.PrescCaseCollectModule).SavePrescCase("8^000003^测试000003^N^65")
ClassMethod SavePrescCase(mParam As %String) As %String
{
	n (mParam)
	s Err=0
	F i=1:1:$L(mParam,"$$") Q:Err'=0  D
	.s mdata=$p(mParam,"$$",i)
	.s Err=..CheckRepeat(mdata)   /// 重复性判断
	.Q:Err'=0
	.i $p(mdata,"^",1) ="" d
	..s Err=..insert(mdata)
	.e  d
	..s Err=..update(mdata)
	q Err
}

ClassMethod CheckRepeat(mParam As %String) As %String
{
	n (mParam)
	s ID=$p(mParam,"^",1)   	/// ID
	s Code=$p(mParam,"^",2)   	/// 代码
	s Desc=$p(mParam,"^",3)   	/// 描述
	s HospID=$p(mParam,"^",5)   /// 医院ID
	/// 新记录
	Q:(ID="")&($d(^PHA.PREADT.CaseCollectModuleI("Code",$$ALPHAUP^SSUTIL4(Code)))) "-1"
	Q:(ID="")&($d(^PHA.PREADT.CaseCollectModuleI("Desc",$$ALPHAUP^SSUTIL4(Desc)))) "-2"
	Q:ID="" 0
	
	/// 修改记录
	s TmpCode=$list($g(^PHA.PREADT.CaseCollectModuleD(ID)),2)    //代码
	s TmpDesc=$list($g(^PHA.PREADT.CaseCollectModuleD(ID)),3)    //描述
	Q:(TmpCode'=Code)&($d(^PHA.PREADT.CaseCollectModuleI("Code",$$ALPHAUP^SSUTIL4(Code)))) "-3"
	Q:(TmpDesc'=Desc)&($d(^PHA.PREADT.CaseCollectModuleI("Desc",$$ALPHAUP^SSUTIL4(Desc)))) "-4"
	Q 0
}

/// Descript:	增加 [案例收藏模块字典]
/// w ##class(web.DHCEMConsStatus).insert("")
ClassMethod insert(mParam As %String) As %String
{
	n (mParam)
	s Code=$p(mParam,"^",2)   	///代码
	s Desc=$p(mParam,"^",3)   	///描述
 	&SQL(INSERT INTO PHA_PREADT.CaseCollectModule(PCCM_Code, PCCM_Desc) VALUES(:Code,:Desc))
 	q SQLCODE
}

/// Descript:	更新 [案例收藏模块字典]
/// w ##class(web.DHCEMConsStatus).update("")
ClassMethod update(mParam As %String) As %String
{
	n (mParam)
	s ID=$p(mParam,"^",1)   	///ID
	s Code=$p(mParam,"^",2)   	///代码
	s Desc=$p(mParam,"^",3)   	///描述
	&SQL(Update PHA_PREADT.CaseCollectModule Set PCCM_Code=:Code,PCCM_Desc=:Desc WHERE ID=:ID)
 	q SQLCODE
}

}
