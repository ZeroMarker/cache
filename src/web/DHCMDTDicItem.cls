Import SQLUser

/// Creator: 		bianshuai
/// CreateDate: 	2019-04-16
/// Descript: 		MDT会诊申请字典项目表
Class web.DHCMDTDicItem Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator: 		bianshuai
/// CreateDate: 	2019-04-16
/// Descript:		MDT会诊申请字典项目表
/// w ##class(web.DHCMDTDicItem).save("8^000003^测试000003^N^65")
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
/// w ##class(web.DHCMDTDicItem).insert("")
ClassMethod insert(mParam As %String) As %String
{
	n (mParam)
	s Code=$p(mParam,"^",2)   	///代码
	s Desc=$p(mParam,"^",3)   	///描述
	s ActFlag=$p(mParam,"^",4)  ///不可用标志
	s HospID=$p(mParam,"^",5)   ///医院ID
	s TypeID=$p(mParam,"^",6)   ///类型ID
	s ParID=$p(mParam,"^",7)    ///父节点ID
	s Notes=$p(mParam,"^",8)    ///备注
 	&SQL(INSERT INTO DHC_MDTDicItem(MD_Code, MD_Desc, MD_ActiveFlag, MD_Hosp_Dr, MD_Type_Dr, MD_Par_Dr,MD_Notes) 
 		VALUES(:Code,:Desc,:ActFlag,:HospID,:TypeID,:ParID,:Notes))
 	q SQLCODE
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-04-16
/// Descript:		更新
/// w ##class(web.DHCMDTDicItem).update("")
ClassMethod update(mParam As %String) As %String
{
	n (mParam)
	s ID=$p(mParam,"^",1)   	///ID
	s Code=$p(mParam,"^",2)   	///代码
	s Desc=$p(mParam,"^",3)   	///描述
	s ActFlag=$p(mParam,"^",4)  ///不可用标志
	s HospID=$p(mParam,"^",5)   ///医院ID
	s ParID=$p(mParam,"^",7)    ///父节点ID
	s Notes=$p(mParam,"^",8)    ///备注
	&SQL(Update DHC_MDTDicItem Set MD_Code=:Code, MD_Desc=:Desc, MD_ActiveFlag=:ActFlag, MD_Hosp_Dr=:HospID, MD_Par_Dr=:ParID,
	 MD_Notes=:Notes WHERE MD_RowID=:ID)
 	q SQLCODE
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-04-16
/// Descript:		删除
/// w ##class(web.DHCMDTDicItem).delete("1")
ClassMethod delete(ID As %String) As %String
{
	N (ID)
	Q:..IsDel(ID) -1
	
	ts
	&SQL(Delete From DHC_MDTDicItem Where MD_RowID=:ID)
	tro:SQLCODE'=0
	q:SQLCODE'=0 SQLCODE
	
	s Err=0
	s ChildID=0
	f  s ChildID=$o(^DHCMDTDI("0","Par",ID,ChildID)) q:(ChildID="")||(Err'=0)  d
	.&SQL(Delete From DHC_MDTDicItem Where MD_RowID=:ChildID)
	.s Err=SQLCODE
	
	tro:Err'=0
	q:Err'=0 Err
	
	tc
	Q 0
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-04-16
/// Descript:		查询
/// w ##class(web.DHCMDTDicItem).QryDicItem("12","1","")
ClassMethod QryDicItem(rows As %String, page As %String, mID As %String, IsTreeGrid = "") As %String
{
	N (rows,page,mID, IsTreeGrid)
	s End = page*rows
	s Start=(page-1)*rows+1
	s:+IsTreeGrid=1 Start=1,End=999
	k TmpItemDet
	s h=0,count=0
	s ID="0"
	F  s ID=$o(^DHCMDTDI(0,"Type",mID,ID)) Q:ID=""  D
	.s Code=$p(^DHCMDTDI(ID),"^",1)    //代码
	.s Desc=$p(^DHCMDTDI(ID),"^",2)    //描述
	.s ActCode=$p(^DHCMDTDI(ID),"^",3) //可用标志
	.s ActDesc=$s(ActCode="Y":"是",ActCode="N":"否",1:"")
	.s HospID=$p(^DHCMDTDI(ID),"^",4)  //医院
	.s HospDesc=""
	.s:HospID'="" HospDesc=$p(^CT("HOSP",HospID),"^",2)
	.s mID=$p(^DHCMDTDI(ID),"^",5)    //类型ID
	.s ParID=$p(^DHCMDTDI(ID),"^",6)
	.s h=h+1
	.s ListData=ID_"^"_Code_"^"_Desc_"^"_ActCode_"^"_ActDesc_"^"_HospID_"^"_HospDesc_"^"_mID_"^"_ParID
	.s TmpItemDet(h)=ListData
	
	i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	Q:h=0 ""
	
	///转换数据为Json格式
	s ListTitle="ID^Code^Desc^ActCode^ActDesc^HospID^HospDesc^mID^_parentId"
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
ClassMethod isExist(mParam As %String) As %String
{
	N (mParam)
	s ID=$p(mParam,"^",1)   	/// ID
	s Code=$p(mParam,"^",2)   	/// 代码
	s Desc=$p(mParam,"^",3)   	/// 描述
	s HospID=$p(mParam,"^",5)   /// 医院ID
	/// 新记录
	Q:(ID="")&($d(^DHCMDTDI(0,"Code",$$ALPHAUP^SSUTIL4(Code),HospID))) "-1"
	Q:(ID="")&($d(^DHCMDTDI(0,"Desc",$$ALPHAUP^SSUTIL4(Desc),HospID))) "-2"
	Q:ID="" 0
	
	/// 修改记录
	s TmpCode=$p($g(^DHCMDTDI(ID)),"^",1)    //代码
	s TmpDesc=$p($g(^DHCMDTDI(ID)),"^",2)    //描述
	Q:(TmpCode'=Code)&($d(^DHCMDTDI(0,"Code",$$ALPHAUP^SSUTIL4(Code),HospID))) "-3"
	Q:(TmpDesc'=Desc)&($d(^DHCMDTDI(0,"Desc",$$ALPHAUP^SSUTIL4(Desc),HospID))) "-4"
	Q 0
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-04-16
/// Descritp:		MDT会诊申请字典项目
/// w ##Class(web.DHCMDTDicItem).jsonDicItem("1")
ClassMethod jsonDicItem(mCode As %String, HospID As %String) As %String
{
	n (mCode, HospID)
	s ID=$o(^DHCMDTDT(0,"Code",$$ALPHAUP^SSUTIL4(mCode),HospID,""))
	Q:ID="" ""
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT MD_RowID ,MD_Desc, MD_ActiveFlag FROM DHC_MDTDicItem Where MD_Type_Dr="_ID
	i HospID'="" s sqlStr = sqlStr_" And  MD_Hosp_Dr="_HospID
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

/// Creator: 		bianshuai
/// CreateDate: 	2019-04-16
/// Descritp:		MDT会诊申请字典项目
/// w ##Class(web.DHCMDTDicItem).jsonParDicItem("1")
ClassMethod jsonParDicItem(mCode As %String, HospID As %String) As %String
{
	n (mCode, HospID,%session)
	s ID=$o(^DHCMDTDT(0,"Code",$$ALPHAUP^SSUTIL4(mCode),HospID,""))
	Q:ID="" ""
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT MD_RowID ,MD_Desc, MD_ActiveFlag, MD_Par_Dr FROM DHC_MDTDicItem Where MD_Type_Dr="_ID_" And MD_Par_Dr is not Null"
	i HospID'="" s sqlStr = sqlStr_" And  MD_Hosp_Dr="_HospID
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s RowId = result.Data("MD_RowID")
		s Desc = result.Data("MD_Desc")
		s ParID = result.Data("MD_Par_Dr")
		Continue:Desc=""
		Continue:result.Data("MD_ActiveFlag")'="Y"
		s HospDesc=$p(^DHCMDTDI(ParID),"^",2)
		s Desc=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCMDTDicItem","MDDesc","",Desc)
		s HospDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCMDTDicItem","MDDesc","",HospDesc)
		s tmp=RowId_"^"_Desc_" - "_HospDesc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	}
	w "]"
	Q ""
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-04-16
/// Descritp:		会诊申请字典项目
/// w ##Class(web.DHCMDTDicItem).GetDicItem("CYT","2")
ClassMethod GetDicItem(mCode As %String, HospID As %String) As %String
{
	n (mCode, HospID)
	s ID=$o(^DHCEMCDT(0,"Code",$$ALPHAUP^SSUTIL4(mCode),HospID,""))
	Q:ID="" ""
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT MD_RowID , MD_Code, MD_Desc, MD_ActiveFlag FROM DHC_MDTDicItem Where MD_Type_Dr="_ID
	i HospID'="" s sqlStr = sqlStr_" And  MD_Hosp_Dr="_HospID
    d result.Prepare(sqlStr)
	d result.Execute()
	s mTypes=""
	While(result.Next())
	{	
		s RowId = result.Data("MD_RowID")
		s Code = result.Data("MD_Code")
		s Desc = result.Data("MD_Desc")
		Continue:Desc=""
		Continue:result.Data("MD_ActiveFlag")'="Y"
		s tmp=RowId_"^"_Desc
		i mTypes="" s mTypes=RowId_"^"_Code_"^"_Desc
		e  s mTypes=mTypes_"||"_RowId_"^"_Code_"^"_Desc
	}
	Q mTypes
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-04-16
/// Descritp:		是否允许会诊申请字典项目
/// w ##Class(web.DHCMDTDicItem).IsDel("11")
ClassMethod IsDel(ID As %String) As %String
{
	n (ID)
	/// 会诊类型
	Q:..isExCsType(ID) 1
	
	Q 0
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-04-16
/// Descritp:		会诊类型是否存在
/// w ##Class(web.DHCMDTDicItem).isExCsType("2")
ClassMethod isExCsType(CsID As %String) As %String
{
	n (CsID)
	s CsTypeID=$p(^DHCMDTDI(CsID),"^",5)        /// 字典类型
	Q:$p(^DHCMDTDT(CsTypeID),"^",1)'="CYT" 0    /// 代码
	s ID=0,QuitFlag=0
	F  s ID=$o(^DHCEMCDA(ID)) Q:ID=""  D
	.Q:$p(^DHCMDTDA(ID),"^",2)'=CsID
	.s QuitFlag=1
	Q QuitFlag
}

/// Descript:查询
/// w ##class(web.DHCEMConsDicItem).QryEmConsItemArray("15","")
ClassMethod QryEmConsItemArray(mID As %String, tID = "") As %String
{
	N (mID,tID)
	s ^BIANSHUAI(666)=$lb(mID,tID)
	q:+mID=0 "[]"
	s Count=0
	w "["
	s ID="0"
	F  s ID=$o(^DHCMDTDI(0,"Type",mID,ID)) Q:ID=""  D
	.s Desc=$p(^DHCMDTDI(ID),"^",2)    //描述
	.s ActCode=$p(^DHCMDTDI(ID),"^",3) //可用标志
	.;q:ActCode'="Y" //hxy 2020-08-12 树形配置设置-选择启用为否的记录，点击新增，打开的增加页面中父节点显示为数字
	.s ParID = $p(^DHCMDTDI(ID),"^",6)
	.Q:+ParID'=0
	.q:(tID'="")&&(tID=ID)
	.s Count=Count+1
	.w $case(Count,1:"",:",")
	.s ItmData = ID_"^"_Desc
	.W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",ItmData)
	w "]"
	Q ""
}

}
