Import SQLUser

/// Creator: 		bianshuai
/// CreateDate: 	2018-08-23
/// Descript: 		检查申请病理基础字典维护
Class web.DHCAPPPisDicItem Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:	病理基础字典项目表
/// w ##class(web.DHCAPPPisDicItem).save("8^000003^测试000003^N^65")
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
/// w ##class(web.DHCAPPPisDicItem).insert("")
ClassMethod insert(mParam As %String) As %String
{
	n (mParam)
	s Code=$p(mParam,"^",2)   	///代码
	s Desc=$p(mParam,"^",3)   	///描述
	s ActFlag=$p(mParam,"^",4)  ///不可用标志
	s HospID=$p(mParam,"^",5)   ///医院ID
	s TypeID=$p(mParam,"^",6)   ///类型ID
 	&SQL(INSERT INTO DHC_AppPisDicItem(AP_Code, AP_Desc, AP_ActiveFlag, AP_Hosp_Dr, AP_Type_Dr) VALUES(:Code,:Desc,:ActFlag,:HospID,:TypeID))
 	q SQLCODE
}

/// Descript:	更新
/// w ##class(web.DHCAPPPisDicItem).update("")
ClassMethod update(mParam As %String) As %String
{
	n (mParam)
	s ID=$p(mParam,"^",1)   	///ID
	s Code=$p(mParam,"^",2)   	///代码
	s Desc=$p(mParam,"^",3)   	///描述
	s ActFlag=$p(mParam,"^",4)  ///不可用标志
	s HospID=$p(mParam,"^",5)   ///医院ID
	&SQL(Update DHC_AppPisDicItem Set AP_Code=:Code, AP_Desc=:Desc, AP_ActiveFlag=:ActFlag, AP_Hosp_Dr=:HospID WHERE AP_RowID=:ID)
 	q SQLCODE
}

/// Descript:	删除
/// w ##class(web.DHCAPPPisDicItem).delete("1")
ClassMethod delete(ID As %String) As %String
{
	N (ID)
	&SQL(Delete From DHC_AppPisDicItem Where AP_RowID=:ID)
	Q SQLCODE
}

/// Descript:查询
/// w ##class(web.DHCAPPPisDicItem).QryPisDicItem("30","1","6",2)
ClassMethod QryPisDicItem(rows As %String, page As %String, mID As %String, HospID As %String) As %String
{
	N (rows,page,mID,HospID)
	s ^tempqujina("QryPisDicItem")=rows_","_page_","_mID_","_HospID
	s End = page*rows
	s Start=(page-1)*rows+1
	k TmpItemDet
	s h=0,count=0
	s ID="0"
	F  s ID=$o(^DHCAPPPDI(0,"Type",mID,ID)) Q:ID=""  D
	.s Code=$p(^DHCAPPPDI(ID),"^",1)    //代码
	.s Desc=$p(^DHCAPPPDI(ID),"^",2)    //描述
	.s ActCode=$p(^DHCAPPPDI(ID),"^",3) //可用标志
	.s ActDesc=$s(ActCode="Y":"是",ActCode="N":"否",1:"")
	.s HospDr=$p(^DHCAPPPDI(ID),"^",4)  //医院
	.q:((HospID'="")&&(HospID'=HospDr))
	.s HospDesc=""
	.s:HospDr'="" HospDesc=$p(^CT("HOSP",HospDr),"^",2)
	.s mIDs=$p(^DHCAPPPDI(ID),"^",5)    //类型ID
	.s h=h+1
	.s Sort=$p(^DHCAPPPDI(ID),"^",6)    //顺序
	.if Sort="" s Sort=ID
	.s ListData=ID_"^"_Code_"^"_Desc_"^"_ActCode_"^"_ActDesc_"^"_HospDr_"^"_HospDesc_"^"_mIDs
	.s TmpItemDet(Sort)=ListData
	
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
	Q:(ID="")&($d(^DHCAPPPDI(0,"Code",$$ALPHAUP^SSUTIL4(Code),HospID))) "-1"
	//Q:(ID="")&($d(^DHCAPPPDI(0,"Desc",$$ALPHAUP^SSUTIL4(Desc),HospID))) "-2"
	Q:ID="" 0
	
	/// 修改记录
	s TmpCode=$p($g(^DHCAPPPDI(ID)),"^",1)    //代码
	s TmpDesc=$p($g(^DHCAPPPDI(ID)),"^",2)    //描述
	Q:(TmpCode'=Code)&($d(^DHCAPPPDI(0,"Code",$$ALPHAUP^SSUTIL4(Code),HospID))) "-3"
	//Q:(TmpDesc'=Desc)&($d(^DHCAPPPDI(0,"Desc",$$ALPHAUP^SSUTIL4(Desc),HospID))) "-4"
	Q 0
}

/// Descritp:	病理基础字典项目
/// w ##Class(web.DHCAPPPisDicItem).jsonPisDicItem("1")
ClassMethod jsonPisDicItem(mCode As %String, HospID As %String) As %String
{
	n (mCode, HospID)
	s ID=$o(^DHCAPPPDT(0,"Code",$$ALPHAUP^SSUTIL4(mCode),HospID,""))
	Q:ID="" 
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT AP_RowID , AP_Desc, AP_ActiveFlag FROM DHC_AppPisDicItem Where AP_Type_Dr="_ID
	i HospID'="" s sqlStr = sqlStr_" And  AP_Hosp_Dr="_HospID
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

/// w ##Class(web.DHCAPPPisDicItem).moveTreeLink("51^56")
ClassMethod moveTreeLink(mListData As %String) As %String
{
	n (mListData)
	s ^tempqujian("moveTreeLink")=mListData
	s ID=$p(mListData,"^",1)
	s TrsOrdNum=$p(^DHCAPPPDI(ID),"^",6) 
	i +TrsOrdNum=0 s TrsOrdNum=ID
	s LastID=$p(mListData,"^",2)
	s LastOrdNum=$p(^DHCAPPPDI(LastID),"^",6) 
	i +LastOrdNum=0 s LastOrdNum=LastID
	b ;dd
	TS
	&sql(update DHC_AppPisDicItem set AP_SortNum=:LastOrdNum WHERE AP_RowID=:ID)
	i SQLCODE'=0 tro
	Q:SQLCODE'=0 -1
	&sql(update DHC_AppPisDicItem set AP_SortNum=:TrsOrdNum WHERE AP_RowID=:LastID)
	i SQLCODE'=0 tro
	Q:SQLCODE'=0 -2
	TC
	Q 0
}

}
