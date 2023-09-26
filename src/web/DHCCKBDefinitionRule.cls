Import SQLUSER

Class web.DHCCKBDefinitionRule Extends %Library.RegisteredObject [ ClassType = "", NoExtent, Not ProcedureBlock ]
{

/// Creator：      Lidong
/// CreatDate：    2022-9-16
/// Description:： 保存
/// Table：        
/// Input:		   TempElement
/// Others：       w ##class(web.DHCCKBDefinitionRule).SaveTermRule("24512^28","11863^6^1^291^2","113.140.81.66")
ClassMethod SaveTermRule(ListData, LoginInfo, ClientIPAddress)
{
	n (ListData,LoginInfo,ClientIPAddress)

	s TempElementId=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4("TempElement"),""))
	s NodeId=$p(ListData,"^",1)
	s DicId=$p(ListData,"^",2)
	s AddRuleFlagId=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4("AddRuleFlag"),""))
	s AttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",DicId,AddRuleFlagId,""))
	i (AttrId'="") d
	.s RuleFlagId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),4)
	e  d
	.s RuleFlagId=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4("Y"),""))
	s ListF=""_"^"_NodeId_"^"_TempElementId_"^"_DicId_"^"_""
	s ListS=""_"^"_DicId_"^"_AddRuleFlagId_"^"_RuleFlagId_"^"_""
	s ^TmpListF=ListF
	s ^TmpListS=ListS
	s Flag=..CheckIsLink(ListF)
	q:Flag=1 -100 //表内已存在该条数据
	TS
	s Err=0
	s Err=..saveDicAttrByType(ListF,"tree",LoginInfo,ClientIPAddress)
	s Err=..saveDicAttrByType(ListS,"tree",LoginInfo,ClientIPAddress)
	i Err'=0 tro
	Q:Err'=0 Err
	TC
	Q Err
}

/// Creator：      Lidong
/// CreatDate：    2022-9-16
/// Description:： 判断是否为字典元素
/// Table：        DHC_CKBCommonDiction
/// Input:		   Code,Desc
/// Oueput:		   1:是  0：不是
/// Others：       w ##class(web.DHCCKBDefinitionRule).CheckIsDic("tree","树形")
ClassMethod CheckIsDic(Code, Desc)
{
	n (Code,Desc)
	&SQL(
	SELECT Count(*) INTO :Num
	FROM CT_CKB_PDSS.CommonDiction
	WHERE CD_Code=:Code  AND  CD_Desc=:Desc
	)
	Q:Num=0 0
	q:Num'=0 1
}

/// Creator：      Lidong
/// CreatDate：    2022-9-16
/// Description:： 判断关系表内是否已有存在数据
/// Table：        CT_CKB_PDSS.DicLinkAttr
/// Input:		   List
/// Oueput:		   1:是  0：不是
/// Others：       w ##class(web.DHCCKBDefinitionRule).CheckIsLink("^235527^49535^134^")
ClassMethod CheckIsLink(List)
{
	n (List)
	s DLADicDr=$p(List,"^",2)
	s DLAAttrCode=$p(List,"^",3)
	s DLAAttrDr=$p(List,"^",4)
	s DLARowId=$o(^CT.CKB.PDSS.DicLinkAttrI("Reverse",DLAAttrDr,DLAAttrCode,""))
	i DLARowId="" d
	.s Flag=0
	e  d
	.s Flag=1
	
	q Flag
}

/// Creator：      lidong
/// CreatDate：    2022-9-19
/// Description:： 根据类型存储数据
/// Table：        CT_CKB_PDSS.DicLinkAttr,CT_CKB_PDSS.CommonDiction
/// Others：       w ##class(web.DHCCKBDefinitionRule).saveDicAttrByType("0^81646^39^^&&^81646^39^3912^IngredientCodeId^0^&&^81646^39^12^IngredientMete^0^&&^81646^39^3924^IngredientUnitId^0^","datagrid","11863^6^1^291^2","113.140.81.66")
/// w ##class(web.DHCCKBDefinitionRule).saveDicAttrByType("^24512^49535^28^","tree","11863^6^1^291^2","113.140.81.66")
/// w ##class(web.DHCCKBDefinitionRule).saveDicAttrByType("^28^33^26852^","tree","11863^6^1^291^2","113.140.81.66")
ClassMethod saveDicAttrByType(ListData, Type, LoginInfo, ClientIPAddress)
{
	n (ListData,Type,LoginInfo,ClientIPAddress)
	s LgUserID=$p(LoginInfo,"^",1)
	s LgHospID=$p(LoginInfo,"^",5)
	s pid=##class(web.DHCCKBCommonUtil).NewPid()
	s ListDataN=##class(web.DHCCKBDicLinkAttr).dealListData(pid,ListData,Type)
	s:ListDataN'="" ListData=ListDataN
	//s InsFlag=##class(web.DHCCKBDicLinkAttr).IsExistAttrValueId(ListData)
	TS
	s Err=0
	i Type="tree"  d
	.s Err=..saveTreeData(ListData,LgUserID,LgHospID,ClientIPAddress,Type)
	i Err'=0 tro
	Q:Err'=0 Err
	TC
	Q Err
}

ClassMethod saveTreeData(ListData, LgUserID, LgHospID, ClientIPAddress, Type)
{
	n (ListData, LgUserID, LgHospID, ClientIPAddress, Type)
	s ^TMPlidong=$lb(ListData, LgUserID, LgHospID, ClientIPAddress, Type)
	s Err=0
	
	TS
	s Err=##class(web.DHCCKBDicLinkAttr).saveGridData(ListData,LgUserID,LgHospID,ClientIPAddress,Type)
	i Err'=0 tro
	Q:Err'=0 Err
	TC
	Q Err
}

/// Creator：      Lidong
/// CreatDate：    2022-9-16
/// Description:： 保存
/// Table：        
/// Input:		   TempElement
/// Others：       w ##class(web.DHCCKBDefinitionRule).DeleteTermRule("133","260743")
ClassMethod DeleteTermRule(ID, parentID)
{
	n (ID,parentID)
	s AddRuleFlagId=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4("AddRuleFlag"),""))
	s ^TMP("DeleteTermRule")=$lb(ID, parentID)
	TS
	s Err=0
	s Err=..DeleteFirstData(ID,parentID)
	s Err=..DeleteSecondData(ID,AddRuleFlagId)
	i Err'=0 tro
	Q:Err'=0 Err
	TC
	Q Err
}

/// Creator：      Lidong
/// CreatDate：    2022-9-16
/// Description:： 删除
/// Table：        
/// Input:		   TempElement
/// Others：       w ##class(web.DHCCKBDefinitionRule).DeleteFirstData("133","235527")
ClassMethod DeleteFirstData(ID, parentID)
{
	n (ID,parentID)
	&SQL(
	DELETE FROM CT_CKB_PDSS.DicLinkAttr
	WHERE DLA_Dic_Dr=:parentID AND DLA_Attr_Dr=:ID
	)
	Q SQLCODE
}

/// Creator：      Lidong
/// CreatDate：    2022-9-16
/// Description:： 删除
/// Table：        
/// Input:		   TempElement
/// Others：       w ##class(web.DHCCKBDefinitionRule).DeleteSecondData("137","33")
ClassMethod DeleteSecondData(ID, AddRuleFlagId)
{
	n (ID,AddRuleFlagId)
	&SQL(
	DELETE FROM CT_CKB_PDSS.DicLinkAttr
	WHERE DLA_Dic_Dr=:ID AND DLA_AttrCode=:AddRuleFlagId
	)
	Q SQLCODE
}

}
