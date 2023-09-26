Import SQLUser

/// Creator: 		bianshuai
/// CreateDate: 	2019-04-16
/// Descript: 		mdt会诊申请字典类型表
Class web.DHCMDTDicType Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator: 		bianshuai
/// CreateDate: 	2019-04-16
/// Descript:		会诊申请字典类型
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

/// Creator: 		bianshuai
/// CreateDate: 	2019-04-16
/// Descript:		增加
/// w ##class(web.DHCMDTDicType).insert("")
ClassMethod insert(mParam As %String) As %String
{
	n (mParam)
	s Code=$p(mParam,"^",2)   	///代码
	s Desc=$p(mParam,"^",3)   	///描述
	s ActFlag=$p(mParam,"^",4)  ///不可用标志
	s HospID=$p(mParam,"^",5)   ///医院ID
 	&SQL(INSERT INTO DHC_MDTDicType(MD_Code, MD_Desc, MD_ActiveFlag, MD_Hosp_Dr) VALUES(:Code,:Desc,:ActFlag,:HospID))
 	q SQLCODE
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-04-16
/// Descript:		更新
/// w ##class(web.DHCMDTDicType).update("")
ClassMethod update(mParam As %String) As %String
{
	n (mParam)
	s ID=$p(mParam,"^",1)   	///ID
	s Code=$p(mParam,"^",2)   	///代码
	s Desc=$p(mParam,"^",3)   	///描述
	s ActFlag=$p(mParam,"^",4)  ///不可用标志
	s HospID=$p(mParam,"^",5)   ///医院ID
	&SQL(Update DHC_MDTDicType Set MD_Code=:Code, MD_Desc=:Desc, MD_ActiveFlag=:ActFlag, MD_Hosp_Dr=:HospID WHERE MD_RowID=:ID)
 	q SQLCODE
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-04-16
/// Descript:		删除
/// w ##class(web.DHCMDTDicType).delete("1")
ClassMethod delete(ID As %String) As %String
{
	N (ID)
	&SQL(Delete From DHC_MDTDicType Where MD_RowID=:ID)
	Q SQLCODE
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-04-16
/// Descript:		查询
/// w ##class(web.DHCMDTDicType).QryDicType("12","1","")
ClassMethod QryDicType(rows As %String, page As %String, params As %String) As %String
{
	N (rows,page,params)
	s End = page*rows
	s Start=(page-1)*rows+1
	k TmpItemDet
	s h=0,count=0
	s hospId = $p(params,"^",1)
	s ID="0"
	F  s ID=$o(^DHCMDTDT(ID)) Q:ID=""  D
	.s Code=$p(^DHCMDTDT(ID),"^",1)    //代码
	.s Desc=$p(^DHCMDTDT(ID),"^",2)    //描述
	.s ActCode=$p(^DHCMDTDT(ID),"^",3) //可用标志
	.s ActDesc=$s(ActCode="Y":"是",ActCode="N":"否",1:"")
	.s HospID=$p(^DHCMDTDT(ID),"^",4)  //医院
	.q:hospId'=HospID
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

/// Creator: 		bianshuai
/// CreateDate: 	2019-04-16
/// Descript:		检查代码、描述是否重复
/// w ##class(web.DHCMDTDicType).isExist("7^OutLoc^外院科室(树)^Y^2")
ClassMethod isExist(mParam As %String) As %String
{
	N (mParam)
	s ID=$p(mParam,"^",1)   	/// ID
	s Code=$p(mParam,"^",2)   	/// 代码
	s Desc=$p(mParam,"^",3)   	/// 描述
	s HospID=$p(mParam,"^",5)   /// 医院ID
	
	s codeHasId=$o(^DHCMDTDT(0,"Code",$$ALPHAUP^SSUTIL4(Code),HospID,""))
	s descHasId=$o(^DHCMDTDT(0,"Desc",$$ALPHAUP^SSUTIL4(Desc),HospID,""))

	/// 新记录
	Q:(codeHasId'="")&&(+ID'=+codeHasId) "-1"
	Q:(descHasId'="")&&(+ID'=+descHasId) "-2"
	Q 0
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-04-16
/// Descritp:		会诊申请字典类型
/// w ##Class(web.DHCMDTDicType).jsonDicType("1")
ClassMethod jsonDicType(HospID As %String) As %String
{
	n (HospID)
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT MD_RowID ,MD_Desc, MD_ActiveFlag FROM DHC_MDTDicType"
	i HospID'="" s sqlStr = sqlStr_" Where  MD_Hosp_Dr="_HospID
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s RowId = result.Data("MD_RowID")
		s Desc = result.Data("MD_Desc")
		Continue:Desc=""
		Continue:result.Data("MD_ActiveFlag")'="Y"
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
