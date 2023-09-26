Import SQLUser

/// Creator: 		bianshuai
/// CreateDate: 	2018-08-23
/// Descript: 		会诊申请字典项目表
Class web.DHCEMConsDicItem Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:	会诊申请字典项目表
/// w ##class(web.DHCEMConsDicItem).save("8^000003^测试000003^N^65")
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
/// w ##class(web.DHCEMConsDicItem).insert("")
ClassMethod insert(mParam As %String) As %String
{
	n (mParam)
	s Code=$p(mParam,"^",2)   	///代码
	s Desc=$p(mParam,"^",3)   	///描述
	s ActFlag=$p(mParam,"^",4)  ///不可用标志
	s HospID=$p(mParam,"^",5)   ///医院ID
	s TypeID=$p(mParam,"^",6)   ///类型ID
	s ParID=$p(mParam,"^",7)   ///类型ID
 	&SQL(INSERT INTO DHC_EmConsDicItem(EC_Code, EC_Desc, EC_ActiveFlag, EC_Hosp_Dr, EC_Type_Dr,EC_Par_Dr)
 	 VALUES(:Code,:Desc,:ActFlag,:HospID,:TypeID,:ParID))
 	q SQLCODE
}

/// Descript:	更新
/// w ##class(web.DHCEMConsDicItem).update("")
ClassMethod update(mParam As %String) As %String
{
	n (mParam)
	s ID=$p(mParam,"^",1)   	///ID
	s Code=$p(mParam,"^",2)   	///代码
	s Desc=$p(mParam,"^",3)   	///描述
	s ActFlag=$p(mParam,"^",4)  ///不可用标志
	s HospID=$p(mParam,"^",5)   ///医院ID
	s ParID=$p(mParam,"^",7)   ///类型ID
	&SQL(Update DHC_EmConsDicItem Set EC_Code=:Code, EC_Desc=:Desc, EC_ActiveFlag=:ActFlag, EC_Hosp_Dr=:HospID 
		,EC_Par_Dr=:ParID WHERE EC_RowID=:ID)
 	q SQLCODE
}

/// Descript:	删除
/// w ##class(web.DHCEMConsDicItem).delete("1")
ClassMethod delete(ID As %String) As %String
{
	N (ID)
	Q:..IsDel(ID) -1
	;&SQL(Delete From DHC_EmConsDicItem Where EC_RowID=:ID) //hxy 2021-03-22 st
	s $Zt="Err"
	ts
	&SQL(Delete From DHC_EmConsDicItem Where EC_RowID=:ID)
	i SQLCODE'=0 tro
	q:SQLCODE'=0 SQLCODE
	&SQL(Delete From DHC_EmConsDicItem Where EC_Par_Dr=:ID)
	s:SQLCODE=100 SQLCODE=0
	i SQLCODE'=0 tro
	q:SQLCODE'=0 SQLCODE
	&SQL(Delete From DHC_EmConsItemProp Where EC_Item_Dr=:ID)
	s:SQLCODE=100 SQLCODE=0
	i SQLCODE'=0 tro
	q:SQLCODE'=0 SQLCODE
	tc
	Q SQLCODE
Err
	tro //ed
	Q SQLCODE
}

/// Descript:查询
/// w ##class(web.DHCEMConsDicItem).QryEmConsItem("12","1","")
ClassMethod QryEmConsItem(rows As %String, page As %String, mID As %String, IsTreeGrid = "") As %String
{
	N (rows,page,mID,IsTreeGrid)
	s End = page*rows
	s Start=(page-1)*rows+1
	s:+IsTreeGrid=1 Start=1,End=999
	
	k TmpItemDet
	s h=0,count=0
	s ID="0"
	F  s ID=$o(^DHCEMCDI(0,"Type",mID,ID)) Q:ID=""  D
	.s Code=$p(^DHCEMCDI(ID),"^",1)    //代码
	.s Desc=$p(^DHCEMCDI(ID),"^",2)    //描述
	.s ActCode=$p(^DHCEMCDI(ID),"^",3) //可用标志
	.s ActDesc=$s(ActCode="Y":"是",ActCode="N":"否",1:"")
	.s HospID=$p(^DHCEMCDI(ID),"^",4)  //医院
	.s HospDesc=""
	.s:HospID'="" HospDesc=$p(^CT("HOSP",HospID),"^",2)
	.s mID=$p(^DHCEMCDI(ID),"^",5)    //类型ID
	.s ParID = $p(^DHCEMCDI(ID),"^",6)
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

/// Descript:查询
/// w ##class(web.DHCEMConsDicItem).QryEmConsItemArray("15","")
ClassMethod QryEmConsItemArray(mID As %String, tID = "") As %String
{
	N (mID,tID)
	q:+mID=0 "[]"
	s Count=0
	w "["
	s ID="0"
	F  s ID=$o(^DHCEMCDI(0,"Type",mID,ID)) Q:ID=""  D
	.s Desc=$p(^DHCEMCDI(ID),"^",2)    //描述
	.s ActCode=$p(^DHCEMCDI(ID),"^",3) //可用标志
	.;q:ActCode'="Y" //hxy 2020-08-12 树形配置设置-选择启用为否的记录，点击新增，打开的增加页面中父节点显示为数字
	.s ParID = $p(^DHCEMCDI(ID),"^",6)
	.q:(tID'="")&&(tID=ID)
	.s Count=Count+1
	.w $case(Count,1:"",:",")
	.s ItmData = ID_"^"_Desc
	.W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",ItmData)
	w "]"
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
	Q:(ID="")&($d(^DHCEMCDI(0,"Code",$$ALPHAUP^SSUTIL4(Code),HospID))) "-1"
	;Q:(ID="")&($d(^DHCEMCDI(0,"Desc",$$ALPHAUP^SSUTIL4(Desc),HospID))) "-2"
	Q:ID="" 0
	
	/// 修改记录
	s TmpCode=$p($g(^DHCEMCDI(ID)),"^",1)    //代码
	s TmpDesc=$p($g(^DHCEMCDI(ID)),"^",2)    //描述
	Q:(TmpCode'=Code)&($d(^DHCEMCDI(0,"Code",$$ALPHAUP^SSUTIL4(Code),HospID))) "-3"
	;Q:(TmpDesc'=Desc)&($d(^DHCEMCDI(0,"Desc",$$ALPHAUP^SSUTIL4(Desc),HospID))) "-4"
	Q 0
}

/// Descritp:	会诊申请字典项目
/// w ##Class(web.DHCEMConsDicItem).jsonConsItem("EVA",3)
ClassMethod jsonConsItem(mCode As %String, HospID As %String) As %String
{
	n (mCode, HospID,%session)
	s HospID=##Class(web.DHCEMCommonUtil).GetDefHospIdByTableName("DHC_EmConsDicType",HospID) //hxy 2021-05-31 add
	s ID=$o(^DHCEMCDT(0,"Code",$$ALPHAUP^SSUTIL4(mCode),HospID,""))
	Q:ID="" 
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT EC_RowID , EC_Code,EC_Desc, EC_ActiveFlag FROM DHC_EmConsDicItem Where EC_Type_Dr="_ID
	i HospID'="" s sqlStr = sqlStr_" And  EC_Hosp_Dr="_HospID
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s RowId = result.Data("EC_RowID")
		s Code = result.Data("EC_Code")
		s Desc = result.Data("EC_Desc")
		Continue:Desc=""
		Continue:result.Data("EC_ActiveFlag")'="Y"
		s Desc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.DHCEmConsDicItem","ECDesc","",Desc)
		s tmp=RowId_"^"_Desc_"^"_Code
		s count = count+1
		I count=1 d
		.W ##class(web.DHCAPPJsonCommon).getJsonData("value^text^code",tmp)
		e  d
		.W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text^code",tmp)
	}
	w "]"
	Q ""
}

/// Descritp:	会诊申请字典项目
/// w ##Class(web.DHCEMConsDicItem).GetConsItem("CYT","2")
ClassMethod GetConsItem(mCode As %String, HospID As %String) As %String
{
	n (mCode, HospID)
	s HospID=##Class(web.DHCEMCommonUtil).GetDefHospIdByTableName("DHC_EmConsDicType",HospID) //hxy 2021-06-02 多院区 add
	s ID=$o(^DHCEMCDT(0,"Code",$$ALPHAUP^SSUTIL4(mCode),HospID,""))
	Q:ID="" ""
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT EC_RowID , EC_Code, EC_Desc, EC_ActiveFlag FROM DHC_EmConsDicItem Where EC_Type_Dr="_ID
	i HospID'="" s sqlStr = sqlStr_" And  EC_Hosp_Dr="_HospID
    d result.Prepare(sqlStr)
	d result.Execute()
	s mTypes=""
	While(result.Next())
	{	
		s RowId = result.Data("EC_RowID")
		s Code = result.Data("EC_Code")
		s Desc = result.Data("EC_Desc")
		Continue:Desc=""
		Continue:result.Data("EC_ActiveFlag")'="Y"
		s tmp=RowId_"^"_Desc
		i mTypes="" s mTypes=RowId_"^"_Code_"^"_Desc
		e  s mTypes=mTypes_"||"_RowId_"^"_Code_"^"_Desc
	}
	Q mTypes
}

/// Descritp:	是否允许会诊申请字典项目
/// w ##Class(web.DHCEMConsDicItem).IsDel("11")
ClassMethod IsDel(ID As %String) As %String
{
	n (ID)
	/// 会诊类型
	Q:..isExCsType(ID) 1
	
	/// 外科医院
	Q:..isExCsHos(ID) 1
	
	Q 0
}

/// Descritp:	会诊类型是否存在
/// w ##Class(web.DHCEMConsDicItem).isExCsType("2")
ClassMethod isExCsType(CsID As %String) As %String
{
	n (CsID)
	s CsTypeID=$p(^DHCEMCDI(CsID),"^",5)        /// 字典类型
	Q:$p(^DHCEMCDT(CsTypeID),"^",1)'="CYT" 0    /// 代码
	s ID=0,QuitFlag=0
	F  s ID=$o(^DHCEMCDA(ID)) Q:ID=""  D
	.Q:$p(^DHCEMCDA(ID),"^",2)'=CsID
	.s QuitFlag=1
	Q QuitFlag
}

/// Descritp:	外院、科室是否存在
/// w ##Class(web.DHCEMConsDicItem).isExCsHos("11")
ClassMethod isExCsHos(CsID As %String) As %String
{
	n (CsID)
	s CsTypeID=$p(^DHCEMCDI(CsID),"^",5)       /// 字典类型
	s itmCode=$p(^DHCEMCDT(CsTypeID),"^",1)
	Q:(itmCode'="HOS")&(itmCode'="LOC") 0   /// 代码
	Q:$d(^DHCEMCHL(0,"HospID",CsID)) 1
	s ID=0,QuitFlag=0
	F  s ID=$o(^DHCEMCHL(ID)) Q:ID=""  D
	.Q:$p(^DHCEMCHL(ID),"^",2)'=CsID
	.s QuitFlag=1
	Q QuitFlag
}

/// Descritp:	ID是否存在
/// w ##Class(web.DHCEMConsDicItem).isExCsID("2")
ClassMethod isExCsID(tID As %String) As %String
{
	n (tID)
	q:'$d(^DHCEMCDI(tID)) -1
	q 0
}

/// Creator: 		hxy
/// CreateDate: 	2020-08-13
/// Descritp:	ID是否存在,相等对应
/// w ##Class(web.DHCEMConsDicItem).isExOrEqual("8","2")
ClassMethod isExOrEqual(tID As %String, mID As %String) As %String
{
	n (tID,mID)
	q:'$d(^DHCEMCDI(tID)) -1
	s CsTypeID=$p(^DHCEMCDI(tID),"^",5)
	q:(CsTypeID'="")&(mID'="")&(CsTypeID'=mID) -1
	q 0
}

/// Creator: 		hxy
/// CreateDate: 	2021-04-03
/// Descript:该字典项目是否有字典属性
/// w ##class(web.DHCEMConsDicItem).IfHaveProp("5")
ClassMethod IfHaveProp(mID As %String) As %String
{
	n (mID)
	s ret=0
	s ID=$o(^DHCEMCIP(0,"Item",mID,""))
	s:ID'="" ret=1
	q ret
}

/// Creator: 		hxy
/// CreateDate: 	2021-06-29
/// Descript:复制
/// w ##class(web.DHCEMConsDicItem).SaveCopy("17","SHR","3")
ClassMethod SaveCopy(ID As %String, Code As %String, Hosp As %String) As %String
{
	n (ID,Code,Hosp)
	s ret=0
	q:$d(^DHCEMCDT(0,"Code",$$ALPHAUP^SSUTIL4(Code),Hosp)) "-1" /// 重复性判断
	
	s $Zt="Error"
	ts	
	s DicObj=##class(User.DHCEmConsDicType).%New()
	s DicObj.ECCode=Code
	s DicObj.ECDesc=$p(^DHCEMCDT(ID),"^",2)
	s DicObj.ECActiveFlag=$p(^DHCEMCDT(ID),"^",3)
	s DicObj.ECHospDr=##class(User.CTHospital).%OpenId(Hosp)
	d DicObj.%Save()
	
	/// 保存字典项目
 	s ret=##class(web.DHCEMConsDicItem).CopyDicItm(DicObj.%Id(),ID)
	i ret'=0 tro
	q:ret'=0 ret
		
	tc
	q ret
Error
	tro
	q -2
}

ClassMethod CopyDicItm(DicID As %String, ID As %String) As %String
{
	n (DicID,ID)
	s ret=0
	s HospID=$p(^DHCEMCDT(ID),"^",4) //医院
	s ItmID=0
	F  s ItmID=$o(^DHCEMCDI(0,"Type",ID,ItmID)) Q:(ItmID="")||(ret'=0)  D
	.s ParID = $p(^DHCEMCDI(ItmID),"^",6)
	.q:ParID'=""
	.s ItemObj=##class(User.DHCEmConsDicItem).%New()
	.s ItemObj.ECCode=$p(^DHCEMCDI(ItmID),"^",1)    //代码 
	.s ItemObj.ECDesc=$p(^DHCEMCDI(ItmID),"^",2)    //描述
	.s ItemObj.ECActiveFlag=$p(^DHCEMCDI(ItmID),"^",3)  //可用标志
	.s ItemObj.ECHospDr=##class(User.CTHospital).%OpenId(HospID,0)
	.s ItemObj.ECTypeDr=##class(User.DHCEmConsDicType).%OpenId(DicID,0)
	.s sc=ItemObj.%Save()
 	.s:$$$ISERR(sc) ret="-2"
 	.i $d(^DHCEMCDI(0,"IndexPar",ItmID)) d
 	..s ItmRowID=0
 	..F  s ItmRowID=$o(^DHCEMCDI(0,"IndexPar",ItmID,ItmRowID)) Q:(ItmRowID="")||(ret'=0)  D
 	...s ItemRowObj=##class(User.DHCEmConsDicItem).%New()
	...s ItemRowObj.ECCode=$p(^DHCEMCDI(ItmRowID),"^",1)
	...s ItemRowObj.ECDesc=$p(^DHCEMCDI(ItmRowID),"^",2)
	...s ItemRowObj.ECActiveFlag=$p(^DHCEMCDI(ItmRowID),"^",3)
	...s ItemRowObj.ECHospDr=##class(User.CTHospital).%OpenId(HospID,0)
	...s ItemRowObj.ECTypeDr=##class(User.DHCEmConsDicType).%OpenId(DicID,0)
	...s ItemRowObj.ECParDr=##class(User.DHCEmConsDicItem).%OpenId(ItemObj.%Id(),0)
	...s sc=ItemRowObj.%Save()
 	...s:$$$ISERR(sc) ret="-2"
	..
	.i $d(^DHCEMCIP(0,"Item",ItmID)) d
	..s PropID=0
	..F  s PropID=$o(^DHCEMCIP(0,"Item",ItmID,PropID)) Q:(PropID="")||(ret'=0)  D
 	...s PropObj=##class(User.DHCEmConsItemProp).%New()
	...s PropObj.ECCode=$p(^DHCEMCIP(PropID),"^",1)
	...s PropObj.ECDesc=$p(^DHCEMCIP(PropID),"^",2)
	...s PropObj.ECActiveFlag=$p(^DHCEMCIP(PropID),"^",3)
	...s PropObj.ECItemDr=##class(User.DHCEmConsDicItem).%OpenId(ItemObj.%Id(),0)
	...s PropObj.ECValue=$p(^DHCEMCIP(PropID),"^",5)
	...s sc=PropObj.%Save()
 	...s:$$$ISERR(sc) ret="-2"
	..
	.
 	q ret
}

}
