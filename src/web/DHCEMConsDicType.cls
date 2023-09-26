Import SQLUser

/// Creator: 		bianshuai
/// CreateDate: 	2018-08-23
/// Descript: 		会诊申请字典类型表
Class web.DHCEMConsDicType Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:	会诊申请字典类型
/// w ##class(web.DHCEMConsDicType).save("8^000003^测试000003^N^65")
ClassMethod save(mParam As %String) As %String
{
	n (mParam)
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
/// w ##class(web.DHCEMConsDicType).insert("")
ClassMethod insert(mParam As %String) As %String
{
	n (mParam)
	s Code=$p(mParam,"^",2)   	///代码
	s Desc=$p(mParam,"^",3)   	///描述
	s ActFlag=$p(mParam,"^",4)  ///不可用标志
	s HospID=$p(mParam,"^",5)   ///医院ID
 	&SQL(INSERT INTO DHC_EmConsDicType(EC_Code, EC_Desc, EC_ActiveFlag, EC_Hosp_Dr) VALUES(:Code,:Desc,:ActFlag,:HospID))
 	q SQLCODE
}

/// Descript:	更新
/// w ##class(web.DHCEMConsDicType).update("")
ClassMethod update(mParam As %String) As %String
{
	n (mParam)
	s ID=$p(mParam,"^",1)   	///ID
	s Code=$p(mParam,"^",2)   	///代码
	s Desc=$p(mParam,"^",3)   	///描述
	s ActFlag=$p(mParam,"^",4)  ///不可用标志
	s HospID=$p(mParam,"^",5)   ///医院ID
	&SQL(Update DHC_EmConsDicType Set EC_Code=:Code, EC_Desc=:Desc, EC_ActiveFlag=:ActFlag, EC_Hosp_Dr=:HospID WHERE EC_RowID=:ID)
 	q SQLCODE
}

/// Descript:	删除
/// w ##class(web.DHCEMConsDicType).delete("1")
ClassMethod delete(ID As %String) As %String
{
	N (ID)
	;&SQL(Delete From DHC_EmConsDicType Where EC_RowID=:ID) //hxy 2021-04-13 st
	s $Zt="Err"
	ts
	s ItmID="0",ret=0
	F  s ItmID=$o(^DHCEMCDI(0,"Type",ID,ItmID)) Q:(ItmID="")||(ret'=0)  D
	.s ret=##class(web.DHCEMConsDicItem).delete(ItmID)
	i ret'=0 tro
	q:ret'=0 ret
	&SQL(Delete From DHC_EmConsDicType Where EC_RowID=:ID)
	i SQLCODE'=0 tro
	q:SQLCODE'=0 SQLCODE
	tc
	Q SQLCODE
Err
	tro //ed
	Q SQLCODE
}

/// Descript:查询
/// w ##class(web.DHCEMConsDicType).QryEmConsType("12","1","")
ClassMethod QryEmConsType(rows As %String, page As %String, params As %String) As %String
{
	N (rows,page,params)
	s End = page*rows
	s Start=(page-1)*rows+1
	k TmpItemDet
	s h=0,count=0
	s ID="0"
	F  s ID=$o(^DHCEMCDT(ID)) Q:ID=""  D
	.s Code=$p(^DHCEMCDT(ID),"^",1)    //代码
	.s Desc=$p(^DHCEMCDT(ID),"^",2)    //描述
	.s ActCode=$p(^DHCEMCDT(ID),"^",3) //可用标志
	.s ActDesc=$s(ActCode="Y":"是",ActCode="N":"否",1:"")
	.s HospID=$p(^DHCEMCDT(ID),"^",4)  //医院
	.s HospDrID=$p(params,"^",1)
	.q:(HospDrID'="")&(HospDrID'=HospID) //hxy 2019-07-18
	.s HospDesc=""
	.s:HospID'="" HospDesc=$p(^CT("HOSP",HospID),"^",2)
	.s h=h+1
	.s ListData=ID_"^"_Code_"^"_Desc_"^"_ActCode_"^"_ActDesc_"^"_HospID_"^"_HospDesc
	.s TmpItemDet(h)=ListData
	
	i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	Q:h=0 ""
	
	///转换数据为Json格式
	s ListTitle="ID^Code^Desc^ActCode^ActDesc^HospID^HospDesc"
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
	Q:(ID="")&($d(^DHCEMCDT(0,"Code",$$ALPHAUP^SSUTIL4(Code),HospID))) "-1"
	Q:(ID="")&($d(^DHCEMCDT(0,"Desc",$$ALPHAUP^SSUTIL4(Desc),HospID))) "-2"
	Q:ID="" 0
	
	/// 修改记录
	s TmpCode=$p($g(^DHCEMCDT(ID)),"^",1)    //代码
	s TmpDesc=$p($g(^DHCEMCDT(ID)),"^",2)    //描述
	Q:(TmpCode'=Code)&($d(^DHCEMCDT(0,"Code",$$ALPHAUP^SSUTIL4(Code),HospID))) "-3"
	Q:(TmpDesc'=Desc)&($d(^DHCEMCDT(0,"Desc",$$ALPHAUP^SSUTIL4(Desc),HospID))) "-4"
	Q 0
}

/// Descritp:	会诊申请字典类型
/// w ##Class(web.DHCEMConsDicType).jsonConsType("1")
ClassMethod jsonConsType(HospID As %String) As %String
{
	n (HospID)
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT EC_RowID ,EC_Desc, EC_ActiveFlag FROM DHC_EmConsDicType"
	i HospID'="" s sqlStr = sqlStr_" Where  EC_Hosp_Dr="_HospID
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s RowId = result.Data("EC_RowID")
		s Desc = result.Data("EC_Desc")
		Continue:Desc=""
		Continue:result.Data("ECS_ActiveFlag")'="Y"
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
