Import SQLUser

/// Creator: 		bianshuai
/// CreateDate: 	2018-12-18
/// Descript: 		会诊申请字典项目属性表
Class web.DHCEMConsItemProp Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:	会诊申请字典项目属性表
/// w ##class(web.DHCEMConsItemProp).save("8^000003^测试000003^N^65")
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
/// w ##class(web.DHCEMConsItemProp).insert("")
ClassMethod insert(mParam As %String) As %String
{
	n (mParam)
	s Code=$p(mParam,"^",2)   	///代码
	s Desc=$p(mParam,"^",3)   	///描述
	s ActFlag=$p(mParam,"^",4)  ///不可用标志
	s HospID=$p(mParam,"^",5)   ///医院ID
	s TypeID=$p(mParam,"^",6)   ///类型ID
	s Value=$p(mParam,"^",7)    ///参数 hxy 2021-05-08
 	&SQL(INSERT INTO DHC_EmConsItemProp(EC_Code, EC_Desc, EC_ActiveFlag, EC_Item_Dr,EC_Value) VALUES(:Code,:Desc,:ActFlag,:TypeID,:Value))
 	q SQLCODE
}

/// Descript:	更新
/// w ##class(web.DHCEMConsItemProp).update("")
ClassMethod update(mParam As %String) As %String
{
	n (mParam)
	s ID=$p(mParam,"^",1)   	///ID
	s Code=$p(mParam,"^",2)   	///代码
	s Desc=$p(mParam,"^",3)   	///描述
	s ActFlag=$p(mParam,"^",4)  ///不可用标志
	s HospID=$p(mParam,"^",5)   ///医院ID
	s Value=$p(mParam,"^",7)    ///参数 hxy 2021-05-08
	&SQL(Update DHC_EmConsItemProp Set EC_Code=:Code, EC_Desc=:Desc, EC_ActiveFlag=:ActFlag,EC_Value=:Value WHERE EC_RowID=:ID)
 	q SQLCODE
}

/// Descript:	删除
/// w ##class(web.DHCEMConsItemProp).delete("1")
ClassMethod delete(ID As %String) As %String
{
	N (ID)
	//Q:..IsDel(ID) -1
	&SQL(Delete From DHC_EmConsItemProp Where EC_RowID=:ID)
	Q SQLCODE
}

/// Descript:查询
/// w ##class(web.DHCEMConsItemProp).QryEmConsItem("12","1","")
ClassMethod QryEmConsItem(rows As %String, page As %String, mID As %String) As %String
{
	N (rows,page,mID)
	s End = page*rows
	s Start=(page-1)*rows+1
	k TmpItemDet
	s h=0,count=0
	s ID="0"
	F  s ID=$o(^DHCEMCIP(0,"Item",mID,ID)) Q:ID=""  D
	.s Code=$p(^DHCEMCIP(ID),"^",1)    //代码
	.s Desc=$p(^DHCEMCIP(ID),"^",2)    //描述
	.s ActCode=$p(^DHCEMCIP(ID),"^",3) //可用标志
	.s ActDesc=$s(ActCode="Y":"是",ActCode="N":"否",1:"")
	.s mID=$p(^DHCEMCIP(ID),"^",4)     //项目ID
	.s Value=$p(^DHCEMCIP(ID),"^",5)   //参数
	.s h=h+1
	.s ListData=ID_"^"_Code_"^"_Desc_"^"_ActCode_"^"_ActDesc_"^"_mID_"^"_Value
	.s TmpItemDet(h)=ListData
	
	i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	Q:h=0 ""
	
	///转换数据为Json格式
	s ListTitle="ID^Code^Desc^ActCode^ActDesc^mID^Value"
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
/// w ##class(web.DHCEMConsItemProp).isExist("^tt^芬斯蒂芬^Y^2^3")
ClassMethod isExist(mParam As %String) As %String
{
	N (mParam)
	s TmpID=$p(mParam,"^",1)   	/// ID
	s Code=$p(mParam,"^",2)   	/// 代码
	s Desc=$p(mParam,"^",3)   	/// 描述
	s HospID=$p(mParam,"^",5)   /// 医院ID
	s ItemID=$p(mParam,"^",6)   /// 类型ID
	s ID="0", QuitFlag=0
	F  s ID=$o(^DHCEMCIP(0,"Item",ItemID,ID)) Q:(ID="")||(QuitFlag'=0)  D
	.Q:(TmpID'="")&(TmpID=ID)
	.s TmpCode=$p(^DHCEMCIP(ID),"^",1)    //代码
	.s TmpDesc=$p(^DHCEMCIP(ID),"^",2)    //描述
	.i TmpCode=Code s QuitFlag="-1"
	.;i TmpDesc=Desc s QuitFlag="-2" //hxy 2021-03-11 注释
	.
	Q QuitFlag
#;	/// 新记录
#;	Q:(ID="")&($d(^DHCEMCIP(0,"Code",$$ALPHAUP^SSUTIL4(Code)))) "-1"
#;	Q:(ID="")&($d(^DHCEMCIP(0,"Desc",$$ALPHAUP^SSUTIL4(Desc)))) "-2"
#;	Q:ID="" 0
#;	
#;	/// 修改记录
#;	s TmpCode=$p($g(^DHCEMCIP(ID)),"^",1)    //代码
#;	s TmpDesc=$p($g(^DHCEMCIP(ID)),"^",2)    //描述
#;	Q:(TmpCode'=Code)&($d(^DHCEMCIP(0,"Code",$$ALPHAUP^SSUTIL4(Code)))) "-3"
#;	Q:(TmpDesc'=Desc)&($d(^DHCEMCIP(0,"Desc",$$ALPHAUP^SSUTIL4(Desc)))) "-4"
#;	Q 0
}

}
