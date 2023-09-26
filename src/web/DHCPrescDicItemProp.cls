Import SQLUser

/// Creator:     	chenzhaobo
/// CreateDate:   	2021-09-01
/// Descript:		审核状态字典项目属性操作
Class web.DHCPrescDicItemProp Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:	审核状态字典项目属性表
/// w ##class(web.DHCPrescDicItemProp).save("^Tetssas^zxczxczx^Y^2")
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
/// w ##class(web.DHCPrescDicItemProp).insert("")
ClassMethod insert(mParam As %String) As %String
{
	n (mParam)
	s Code=$p(mParam,"^",2)   	///代码
	s Desc=$p(mParam,"^",3)   	///描述
	s ActFlag=$p(mParam,"^",4)  ///不可用标志
	s TypeID=$p(mParam,"^",5)   ///类型ID
 	&SQL(INSERT INTO CT_PHA_PREADT.ItemProp(PIP_Code, PIP_Desc, PIP_ActiveFlag, PIP_Item_Dr) VALUES(:Code,:Desc,:ActFlag,:TypeID))
 	q SQLCODE
}

/// Descript:	更新
/// w ##class(web.DHCPrescDicItemProp).update("")
ClassMethod update(mParam As %String) As %String
{
	n (mParam)
	s ID=$p(mParam,"^",1)   	///ID
	s Code=$p(mParam,"^",2)   	///代码
	s Desc=$p(mParam,"^",3)   	///描述
	s ActFlag=$p(mParam,"^",4)  ///不可用标志
	&SQL(Update CT_PHA_PREADT.ItemProp Set PIP_Code=:Code, PIP_Desc=:Desc, PIP_ActiveFlag=:ActFlag WHERE PIP_RowID=:ID)
 	q SQLCODE
}

/// Descript:	删除
/// w ##class(web.DHCPrescDicItemProp).delete("1")
ClassMethod delete(ID As %String) As %String
{
	N (ID)
	&SQL(Delete From CT_PHA_PREADT.ItemProp Where PIP_RowID=:ID)
	Q SQLCODE
}

/// Descript:查询
/// w ##class(web.DHCPrescDicItemProp).QryPrescDicItemProp("30","1","2")
ClassMethod QryPrescDicItemProp(rows As %String, page As %String, mID As %String) As %String
{
	N (rows,page,mID)
	s End = page*rows
	s Start=(page-1)*rows+1
	k TmpItemDet
	s h=0,count=0
	s ID="0"
	F  s ID=$o(^CT.PHA.PREADT.ItemPropI("ItemPar",mID,ID)) Q:ID=""  D
	.s str = $g(^CT.PHA.PREADT.ItemPropD(ID))
	.s Code=$list($g(str),2)   						//代码
	.s Desc=$list($g(str),3)    					//描述
	.s ActCode=$list($g(str),4)  					//可用标志
	.s ActDesc=$s(ActCode="Y":"是",ActCode="N":"否",1:"")
	.s mID=$list($g(str),5)     					//项目ID
	.s h=h+1
	.s ListData=ID_"^"_Code_"^"_Desc_"^"_ActCode_"^"_ActDesc_"^"_mID
	.s TmpItemDet(h)=ListData
	
	i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	Q:h=0 ""
	
	///转换数据为Json格式
	s ListTitle="ID^Code^Desc^ActCode^ActDesc^mID"
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
/// w ##class(web.DHCPrescDicItemProp).isExist("^tt^芬斯蒂芬^Y^2^3")
ClassMethod isExist(mParam As %String) As %String
{
	N (mParam)
	s ID=$p(mParam,"^",1)   	/// ID
	s Code=$p(mParam,"^",2)   	/// 代码
	s Desc=$p(mParam,"^",3)   	/// 描述
	s TypeID=$p(mParam,"^",5)   /// 项目ID
	/// 新记录
	Q:(ID="")&($d(^CT.PHA.PREADT.ItemPropI("Code",$$ALPHAUP^SSUTIL4(Code),TypeID))) "-1"
	Q:(ID="")&($d(^CT.PHA.PREADT.ItemPropI("Desc",$$ALPHAUP^SSUTIL4(Desc),TypeID))) "-2"
	Q:ID="" 0
	
	/// 修改记录
	s TmpCode=$list($g(^CT.PHA.PREADT.ItemPropD(ID)),2)    //代码
	s TmpDesc=$list($g(^CT.PHA.PREADT.ItemPropD(ID)),3)    //描述
	Q:(TmpCode'=Code)&($d(^CT.PHA.PREADT.ItemPropI("Code",$$ALPHAUP^SSUTIL4(Code),TypeID))) "-3"
	Q:(TmpDesc'=Desc)&($d(^CT.PHA.PREADT.ItemPropI("Desc",$$ALPHAUP^SSUTIL4(Desc),TypeID))) "-4"
	Q 0
}

}
