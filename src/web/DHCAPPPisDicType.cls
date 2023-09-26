Import SQLUser

/// Creator: 		bianshuai
/// CreateDate: 	2019-02-28
/// Descript: 		检查申请病理基础字典维护
Class web.DHCAPPPisDicType Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:	病理基础字典类型
/// w ##class(web.DHCAPPPisDicType).save("8^000003^测试000003^N^65")
ClassMethod save(mParam As %String) As %String
{
	n (mParam)
	s ^tempqujian("save11")=mParam
	s Err=0
	F i=1:1:$L(mParam,"$$") Q:Err'=0  D
	.s mdata=$p(mParam,"$$",i)
	.s Err=..isExist(mdata)   /// 重复性判断
	.Q:Err'=0
	.i $p(mdata,"^",1) ="" d
	..s Err=..insert(mdata)
	.e  d
	..s Err=..update(mdata)
	Q Err
}

/// Descript:	增加
/// w ##class(web.DHCAPPPisDicType).insert("")
ClassMethod insert(mParam As %String) As %String
{
	n (mParam)
	s Code=$p(mParam,"^",2)   	///代码
	s Desc=$p(mParam,"^",3)   	///描述
	s ActFlag=$p(mParam,"^",4)  ///不可用标志
	s HospID=$p(mParam,"^",5)   ///医院ID
	s MapCodeFlag=$p(mParam,"^",6)   ///授权
 	&SQL(INSERT INTO DHC_AppPisDicType(AP_Code, AP_Desc, AP_ActiveFlag, AP_Hosp_Dr,AP_MapCodeFlag) VALUES(:Code,:Desc,:ActFlag,:HospID,:MapCodeFlag))
 	q SQLCODE
}

/// Descript:	更新
/// w ##class(web.DHCAPPPisDicType).update("")
ClassMethod update(mParam As %String) As %String
{
	n (mParam)
	s ID=$p(mParam,"^",1)   	///ID
	s Code=$p(mParam,"^",2)   	///代码
	s Desc=$p(mParam,"^",3)   	///描述
	s ActFlag=$p(mParam,"^",4)  ///不可用标志
	s HospID=$p(mParam,"^",5)   ///医院ID
	s MapCodeFlag=$p(mParam,"^",6)   ///授权
	&SQL(Update DHC_AppPisDicType Set AP_Code=:Code, AP_Desc=:Desc, AP_ActiveFlag=:ActFlag, AP_Hosp_Dr=:HospID
	,AP_MapCodeFlag =:MapCodeFlag WHERE AP_RowID=:ID)
 	q SQLCODE
}

/// Descript:	删除
/// w ##class(web.DHCAPPPisDicType).delete("1")
ClassMethod delete(ID As %String) As %String
{
	N (ID)
	&SQL(Delete From DHC_AppPisDicType Where AP_RowID=:ID)
	Q SQLCODE
}

/// Descript:查询
/// w ##class(web.DHCAPPPisDicType).QryPisDicType("12","1","")
ClassMethod QryPisDicType(rows As %String, page As %String, params As %String, HospID As %String = "") As %String
{
	N (rows,page,params,HospID)
	s End = page*rows
	s Start=(page-1)*rows+1
	k TmpItemDet
	s h=0,count=0
	s ID="0"
	F  s ID=$o(^DHCAPPPDT(ID)) Q:ID=""  D
	.s Code=$p(^DHCAPPPDT(ID),"^",1)    //代码
	.s Desc=$p(^DHCAPPPDT(ID),"^",2)    //描述
	.s ActCode=$p(^DHCAPPPDT(ID),"^",3) //可用标志
	.s ActDesc=$s(ActCode="Y":"是",ActCode="N":"否",1:"")
	.s HospDr=$p(^DHCAPPPDT(ID),"^",4)  //医院
	.;q:((HospID'="")&&(HospID'=HospDr))
	.s HospDesc=""
	.s:HospDr'="" HospDesc=$p(^CT("HOSP",HospDr),"^",2)
	.s ActMapCode=$p(^DHCAPPPDT(ID),"^",5) //可用标志
	.s ActMapDesc=$s(ActMapCode="Y":"是",ActMapCode="N":"否",ActMapCode="":"否")
	.s h=h+1
	.s ListData=ID_"^"_Code_"^"_Desc_"^"_ActCode_"^"_ActDesc_"^"_HospID_"^"_HospDesc_"^"_ActMapCode_"^"_ActMapDesc
	.s TmpItemDet(h)=ListData
	
	i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	Q:h=0 ""
	
	///转换数据为Json格式
	s ListTitle="ID^Code^Desc^ActCode^ActDesc^HospID^HospDesc^ActMapCode^ActMapDesc"
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

/// Descript:检查代码、描述是否重复
ClassMethod isExist(mParam As %String) As %String
{
	N (mParam)
	s ID=$p(mParam,"^",1)   	/// ID
	s Code=$p(mParam,"^",2)   	/// 代码
	s Desc=$p(mParam,"^",3)   	/// 描述
	s HospID=$p(mParam,"^",5)   /// 医院ID
	/// 新记录
	Q:(ID="")&($d(^DHCAPPPDT(0,"Code",$$ALPHAUP^SSUTIL4(Code),HospID))) "-1"
	//Q:(ID="")&($d(^DHCAPPPDT(0,"Desc",$$ALPHAUP^SSUTIL4(Desc),HospID))) "-2"
	Q:ID="" 0
	
	/// 修改记录
	s TmpCode=$p($g(^DHCAPPPDT(ID)),"^",1)    //代码
	s TmpDesc=$p($g(^DHCAPPPDT(ID)),"^",2)    //描述
	Q:(TmpCode'=Code)&($d(^DHCAPPPDT(0,"Code",$$ALPHAUP^SSUTIL4(Code),HospID))) "-3"
	//Q:(TmpDesc'=Desc)&($d(^DHCAPPPDT(0,"Desc",$$ALPHAUP^SSUTIL4(Desc),HospID))) "-4"
	Q 0
}

/// Descritp:	病理基础字典类型
/// w ##Class(web.DHCAPPPisDicType).jsonPisDicType("1")
ClassMethod jsonPisDicType(HospID As %String) As %String
{
	n (HospID)
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT AP_RowID ,AP_Desc, AP_ActiveFlag FROM DHC_AppPisDicType"
	i HospID'="" s sqlStr = sqlStr_" Where  AP_Hosp_Dr="_HospID
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s RowId = result.Data("AP_RowID")
		s Desc = result.Data("AP_Desc")
		Continue:Desc=""
		Continue:result.Data("AP_ActiveFlag")'="Y"
		s tmp=RowId_"^"_Desc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	}
	w "]"
	Q ""
}

}
