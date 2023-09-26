Import SQLUser

/// Creator: 		bianshuai
/// CreateDate: 	2018-08-23
/// Descript: 		急诊基础字典项目表
Class web.DHCEMDicItem Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:	急诊基础字典项目表
/// w ##class(web.DHCEMDicItem).save("8^000003^测试000003^N^65")
ClassMethod save(mParam As %String) As %String
{
	n (mParam)
	s Err=0
	F i=1:1:$L(mParam,"$$") Q:Err'=0  D
	.s mdata=$p(mParam,"$$",i)
	.//s Err=..isExist(mdata)   /// 重复性判断
	.Q:Err'=0
	.i $p(mdata,"^",1) ="" d
	..s Err=..insert(mdata)
	.e  d
	..s Err=..update(mdata)
	Q Err
}

/// Descript:	增加
/// w ##class(web.DHCEMDicItem).insert("")
ClassMethod insert(mParam As %String) As %String
{
	n (mParam)
	s Code=$p(mParam,"^",2)   	///代码
	s Desc=$p(mParam,"^",3)   	///描述
	s ActFlag=$p(mParam,"^",4)  ///不可用标志
	s HospID=$p(mParam,"^",5)   ///医院ID
	s TypeID=$p(mParam,"^",6)   ///类型ID
 	&SQL(INSERT INTO DHC_EmDicItem(EM_Code, EM_Desc, EM_ActiveFlag, EM_Hosp_Dr, EM_Type_Dr) VALUES(:Code,:Desc,:ActFlag,:HospID,:TypeID))
 	q SQLCODE
}

/// Descript:	更新
/// w ##class(web.DHCEMDicItem).update("")
ClassMethod update(mParam As %String) As %String
{
	n (mParam)
	s ID=$p(mParam,"^",1)   	///ID
	s Code=$p(mParam,"^",2)   	///代码
	s Desc=$p(mParam,"^",3)   	///描述
	s ActFlag=$p(mParam,"^",4)  ///不可用标志
	s HospID=$p(mParam,"^",5)   ///医院ID
	&SQL(Update DHC_EmDicItem Set EM_Code=:Code, EM_Desc=:Desc, EM_ActiveFlag=:ActFlag, EM_Hosp_Dr=:HospID WHERE EM_RowID=:ID)
 	q SQLCODE
}

/// Descript:	删除
/// w ##class(web.DHCEMDicItem).delete("1")
ClassMethod delete(ID As %String) As %String
{
	N (ID)
	Q:..IsDel(ID) -1
	&SQL(Delete From DHC_EmDicItem Where EM_RowID=:ID)
	Q SQLCODE
}

/// Descript:查询
/// w ##class(web.DHCEMDicItem).QryEmConsItem("12","1","")
ClassMethod QryEmConsItem(rows As %String, page As %String, mID As %String) As %String
{
	N (rows,page,mID)
	s End = page*rows
	s Start=(page-1)*rows+1
	k TmpItemDet
	s h=0,count=0
	s ID="0"
	F  s ID=$o(^DHCEMDI(0,"Type",mID,ID)) Q:ID=""  D
	.s Code=$p(^DHCEMDI(ID),"^",1)    //代码
	.s Desc=$p(^DHCEMDI(ID),"^",2)    //描述
	.s ActCode=$p(^DHCEMDI(ID),"^",3) //可用标志
	.s ActDesc=$s(ActCode="Y":"是",ActCode="N":"否",1:"")
	.s HospID=$p(^DHCEMDI(ID),"^",4)  //医院
	.s HospDesc=""
	.s:HospID'="" HospDesc=$p(^CT("HOSP",HospID),"^",2)
	.s mID=$p(^DHCEMDI(ID),"^",5)    //类型ID
	.s h=h+1
	.s ListData=ID_"^"_Code_"^"_Desc_"^"_ActCode_"^"_ActDesc_"^"_HospID_"^"_HospDesc_"^"_mID
	.s TmpItemDet(h)=ListData
	
	i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	Q:h=0 ""
	
	///转换数据为Json格式
	s ListTitle="ID^Code^Desc^ActCode^ActDesc^HospID^HospDesc^mID"
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
	Q:(ID="")&($d(^DHCEMDI(0,"Code",$$ALPHAUP^SSUTIL4(Code),HospID))) "-1"
	Q:(ID="")&($d(^DHCEMDI(0,"Desc",$$ALPHAUP^SSUTIL4(Desc),HospID))) "-2"
	Q:ID="" 0
	
	/// 修改记录
	s TmpCode=$p($g(^DHCEMDI(ID)),"^",1)    //代码
	s TmpDesc=$p($g(^DHCEMDI(ID)),"^",2)    //描述
	Q:(TmpCode'=Code)&($d(^DHCEMDI(0,"Code",$$ALPHAUP^SSUTIL4(Code),HospID))) "-3"
	Q:(TmpDesc'=Desc)&($d(^DHCEMDI(0,"Desc",$$ALPHAUP^SSUTIL4(Desc),HospID))) "-4"
	Q 0
}

/// Descritp:	急诊基础字典项目
/// w ##Class(web.DHCEMDicItem).jsonConsItem("Discharge",9)
ClassMethod jsonConsItem(mCode As %String, HospID As %String) As %String
{
	n (mCode, HospID,%session)
	s HospID=##Class(web.DHCEMCommonUtil).GetDefHospIdByTableName("DHC_EmDicType",HospID) //hxy 2020-05-27 产品配置-私有
	s ID=$o(^DHCEMDT(0,"Code",$$ALPHAUP^SSUTIL4(mCode),HospID,""))
	Q:ID="" 
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT EM_RowID ,EM_Desc, EM_ActiveFlag FROM DHC_EmDicItem Where EM_Type_Dr="_ID
	i HospID'="" s sqlStr = sqlStr_" And  EM_Hosp_Dr="_HospID
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s RowId = result.Data("EM_RowID")
		s Desc = result.Data("EM_Desc")
		Continue:Desc=""
		Continue:result.Data("EM_ActiveFlag")'="Y"
		s Desc=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCEmDicItem","EMDesc","",Desc) //hxy 2022-12-20
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

/// Descritp:	急诊基础字典项目
/// w ##Class(web.DHCEMDicItem).GetConsItem("CYT","2")
ClassMethod GetConsItem(mCode As %String, HospID As %String) As %String
{
	n (mCode, HospID)
	s ID=$o(^DHCEMDT(0,"Code",$$ALPHAUP^SSUTIL4(mCode),HospID,""))
	Q:ID="" ""
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT EM_RowID , EM_Code, EM_Desc, EM_ActiveFlag FROM DHC_EmDicItem Where EM_Type_Dr="_ID
	i HospID'="" s sqlStr = sqlStr_" And  EM_Hosp_Dr="_HospID
    d result.Prepare(sqlStr)
	d result.Execute()
	s mTypes=""
	While(result.Next())
	{	
		s RowId = result.Data("EM_RowID")
		s Code = result.Data("EM_Code")
		s Desc = result.Data("EM_Desc")
		Continue:Desc=""
		Continue:result.Data("EM_ActiveFlag")'="Y"
		s tmp=RowId_"^"_Desc
		i mTypes="" s mTypes=RowId_"^"_Code_"^"_Desc
		e  s mTypes=mTypes_"||"_RowId_"^"_Code_"^"_Desc
	}
	Q mTypes
}

/// Descritp:	是否允许急诊申请字典项目
/// w ##Class(web.DHCEMDicItem).IsDel("11")
ClassMethod IsDel(ID As %String) As %String
{
	n (ID)
	/// 会诊类型
	Q:..isExCsType(ID) 1
	
	/// 外科医院
	Q:..isExCsHos(ID) 1
	
	Q 0
}

/// Descritp:	急诊类型是否存在
/// w ##Class(web.DHCEMDicItem).isExCsType("2")
ClassMethod isExCsType(CsID As %String) As %String
{
	n (CsID)
	s CsTypeID=$p(^DHCEMDI(CsID),"^",5)        /// 字典类型
	Q:$p(^DHCEMDT(CsTypeID),"^",1)'="CYT" 0    /// 代码
	s ID=0,QuitFlag=0
	F  s ID=$o(^DHCEMCDA(ID)) Q:ID=""  D
	.Q:$p(^DHCEMCDA(ID),"^",2)'=CsID
	.s QuitFlag=1
	Q QuitFlag
}

/// Descritp:	外院、科室是否存在
/// w ##Class(web.DHCEMDicItem).isExCsHos("11")
ClassMethod isExCsHos(CsID As %String) As %String
{
	n (CsID)
	s CsTypeID=$p(^DHCEMDI(CsID),"^",5)       /// 字典类型
	s itmCode=$p(^DHCEMDT(CsTypeID),"^",1)
	Q:(itmCode'="HOS")&(itmCode'="LOC") 0   /// 代码
	Q:$d(^DHCEMCHL(0,"HospID",CsID)) 1
	s ID=0,QuitFlag=0
	F  s ID=$o(^DHCEMCHL(ID)) Q:ID=""  D
	.Q:$p(^DHCEMCHL(ID),"^",2)'=CsID
	.s QuitFlag=1
	Q QuitFlag
}

/// Descript:	动态提取设置列
/// w ##Class(web.DHCEMDicItem).JsGetColumns("DWL","1")
ClassMethod JsGetColumns(mCode As %String, HospID As %String) As %String
{
	n (mCode, HospID,%session)
	s HospID=##Class(web.DHCEMCommonUtil).GetDefHospIdByTableName("DHC_EmDicType",HospID) //hxy 2020-06-30 产品配置-私有
	s mID=+$o(^DHCEMDT(0,"Code",$$ALPHAUP^SSUTIL4(mCode),HospID,""))
	//Q:mID="" ""
	s ListTitle="field^title^width^align"
	w "[["
	s ID="",count=0
	F  s ID=$o(^DHCEMDI(0,"Type",mID,ID)) Q:ID=""  D
	.s Code=$p(^DHCEMDI(ID),"^",1)    /// 代码
	.s Desc=$p(^DHCEMDI(ID),"^",2)    /// 描述
	.Q:$p(^DHCEMDI(ID),"^",3)'="Y"    /// 可用标志
	.Q:$p(^DHCEMDI(ID),"^",4)'=HospID /// 医院
	.S Desc=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCEmDicItem","EMDesc","",Desc)
	.s ListData="T"_ID_"^"_Desc_"^140^center"
	.s count = count+1
	.I count=1 d
	..W ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.
	w "]]"
	Q ""
}

}
