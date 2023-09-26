/// 临床路径项目
Class User.DHCMRCClinPathWaysEpStepItem Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = CPWSI_RowId, SqlTableName = DHC_MRC_ClinPathWaysEpStepItem ]
{

Relationship CPWSIParRef As User.DHCMRCClinPathWaysEpStep [ Cardinality = parent, Inverse = ChildItem, SqlFieldName = CPWSI_ParRef ];

Relationship ChildItmImpl As User.DHCMRCClinPathWaysItmImpl [ Cardinality = children, Inverse = CPWSIIParRef ];

Relationship ChildItmGene As User.DHCMRCClinPathWaysItmGene [ Cardinality = children, Inverse = IGParref ];

/// 项目子类
Property CPWSISubCategory As User.DHCMRCStepItemSubCategory [ SqlColumnNumber = 3, SqlFieldName = CPWSI_SubCategory ];

/// 顺序号(分组号)
Property CPWSIGroupNo As %Float [ SqlColumnNumber = 4, SqlFieldName = CPWSI_GroupNo ];

/// 项目描述
Property CPWSIDesc As %String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = CPWSI_Desc ];

/// 可选项/必选项  Y可选 N必选
Property CPWSIIsMust As %String(DISPLAYLIST = ",Yes,No", MINLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = CPWSI_IsMust ];

/// （作废）关联医嘱套
/// Table:ARCOrdSets
Property CPWSIOrdSetDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = CPWSI_OrdSet_DR ];

/// （作废）可选医嘱
/// 替换成User.DHCMRCClinPathWaysItmGene   update by zf 20150525
Property CPWSIARCIM As list Of User.DHCMRCClinPathWaysARCIM [ SqlColumnNumber = 7, SqlFieldName = DHC_MRC_ARCIMList ];

/// （作废）关键点类型  K:里程碑、T:时效性
Property CPWSICheckPoint As %String(DISPLAYLIST = ",KEY,TIME", MINLEN = 3, TRUNCATE = 1, VALUELIST = ",K,T") [ SqlColumnNumber = 8, SqlFieldName = CPWSI_CheckPoint ];

/// （作废）关键点描述，如要求出结果天数
Property CPWSICheckDesc As %String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = CPWSI_CheckDesc ];

/// （作废）可选关联项
Property CPWSIBLItmList As list Of User.DHCMRCClinPathWaysBLITM [ SqlColumnNumber = 11, SqlFieldName = DHC_MRC_BLItmList ];

Index IndexGroupNo On (CPWSIParRef, CPWSIGroupNo);

/// Creator：     zhufei
/// CreatDate：   2015-05-25
/// Description:  根据ID取表单项目
/// Table：       User.DHCMRCClinPathWaysEpStepItem
/// Input：       Id : User.DHCMRCClinPathWaysEpStepItem.ID
/// Return：      返回Object
/// w ##class(User.DHCMRCClinPathWaysEpStepItem).GetObjById(1)
ClassMethod GetObjById(aId As %String) As User.DHCMRCClinPathWaysEpStepItem
{
	new (aId)
	quit:'##class(User.DHCMRCClinPathWaysEpStepItem).%ExistsId(aId) ""
	set obj=##Class(User.DHCMRCClinPathWaysEpStepItem).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     zhufei
/// CreatDate：   2015-05-25
/// Description:  更新表单项目
/// Table：       User.DHCMRCClinPathWaysEpStepItem
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(User.DHCMRCClinPathWaysEpStepItem).Update("")
ClassMethod Update(aInputStr As %String) As %String
{
	New (aInputStr)
	Set return=0
	Quit:aInputStr="" return
	
	Set StepID = $p(aInputStr,"^",1)
	Set ItemSub = $p(aInputStr,"^",2)
	Set ItemDesc = $p(aInputStr,"^",3)
	Set SubCatID = $p(aInputStr,"^",4)
	Set IsOptional = $p(aInputStr,"^",5)
	Set GroupNo = $p(aInputStr,"^",6)
	Quit:(StepID="")||(ItemDesc="")||(GroupNo="") return
	
	Set objStep=##class(User.DHCMRCClinPathWaysEpStep).GetObjById(StepID)
	Quit:'$IsObject(objStep) return
	Set objSubCat=##class(User.DHCMRCStepItemSubCategory).GetObjById(SubCatID)
	Quit:'$IsObject(objSubCat) return
	
	If ItemSub="" {
		Set obj=##class(User.DHCMRCClinPathWaysEpStepItem).%New()
	} Else {
		Set obj=##class(User.DHCMRCClinPathWaysEpStepItem).%OpenId(StepID_"||"_ItemSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.CPWSIParRef      = objStep
	Set obj.CPWSIDesc        = ItemDesc
	Set obj.CPWSISubCategory = objSubCat
	Set obj.CPWSIGroupNo     = GroupNo
	Set obj.CPWSIIsMust      = IsOptional
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {     //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

ClassMethod UpdateIsOptional(aItemID As %String, aValue As %String) As %String
{
	New (aItemID, aValue)
	Set return=0
	Quit:(aItemID="") return
	
	Set obj=##class(User.DHCMRCClinPathWaysEpStepItem).%OpenId(aItemID)
	Quit:'$IsObject(obj) return
	Set obj.CPWSIIsMust = $s(aValue=1:"Y",1:"N")
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {     //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=1
	}
	Do obj.%Close()
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-06-13
/// Description:  替换表单项目分组号
/// Table：       User.DHCMRCClinPathWaysEpStepItem
/// Input：       FromItemID : User.DHCMRCClinPathWaysEpStepItem.ID
///               ToItemID : User.DHCMRCClinPathWaysEpStepItem.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(User.DHCMRCClinPathWaysEpStepItem).ChangeGroupNo()
ClassMethod ChangeGroupNo(aFromItemID As %String, aToItemID As %String) As %String
{
	New (aFromItemID,aToItemID)
	Set return=0
	Quit:(aFromItemID="")||(aToItemID="") return
	
	Set return=-1
	Set objFromItem=..GetObjById(aFromItemID)
	Quit:'$IsObject(objFromItem) return
	Set FromGroupNo=objFromItem.CPWSIGroupNo
	Set objToItem=..GetObjById(aToItemID)
	Quit:'$IsObject(objToItem) return
	Set ToGroupNo=objToItem.CPWSIGroupNo
	
	Set return=1
	Set obj=##class(User.DHCMRCClinPathWaysEpStepItem).%OpenId(aFromItemID)
	Set obj.CPWSIGroupNo = ToGroupNo
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {     //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-2
	}
	Do obj.%Close()
	Quit:return<0 return
	
	Set obj=##class(User.DHCMRCClinPathWaysEpStepItem).%OpenId(aToItemID)
	Set obj.CPWSIGroupNo = FromGroupNo
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {     //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-3
	}
	Do obj.%Close()
	Quit:return<0 return
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-06-13
/// Description:  合并表单项目分组号
/// Table：       User.DHCMRCClinPathWaysEpStepItem
/// Input：       FromItemID : User.DHCMRCClinPathWaysEpStepItem.ID
///               ToItemID : User.DHCMRCClinPathWaysEpStepItem.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(User.DHCMRCClinPathWaysEpStepItem).MergeGroupNo("79||1||1||11","79||1||1||12")
ClassMethod MergeGroupNo(aFromItemID As %String, aToItemID As %String) As %String
{
	New (aFromItemID,aToItemID)
	Set return=0
	Quit:(aFromItemID="")||(aToItemID="") return
	
	Set return=-1
	Set objFromItem=..GetObjById(aFromItemID)
	Quit:'$IsObject(objFromItem) return
	Set FromGroupNo=objFromItem.CPWSIGroupNo
	Set objToItem=..GetObjById(aToItemID)
	Quit:'$IsObject(objToItem) return
	Set ToGroupNo=objToItem.CPWSIGroupNo
	
	Set return=1
	Set obj=##class(User.DHCMRCClinPathWaysEpStepItem).%OpenId(aFromItemID)
	Set obj.CPWSIGroupNo = ToGroupNo
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {     //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-2
	}
	Do obj.%Close()
	Quit:return<0 return
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-05-25
/// Description:  删除表单项目
/// Table：       User.DHCMRCClinPathWaysEpStepItem
/// Input：       Id : User.DHCMRCClinPathWaysEpStepItem.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(User.DHCMRCClinPathWaysEpStepItem).%DeleteId(aId)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc)
   		set return=-1
	}else{
		set return=1
	}
	quit return
}

Storage Default
{
<Data name="DataMaster">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CPWSISubCategory</Value>
</Value>
<Value name="3">
<Value>CPWSIGroupNo</Value>
</Value>
<Value name="4">
<Value>CPWSIDesc</Value>
</Value>
<Value name="5">
<Value>CPWSIARCIM</Value>
</Value>
<Value name="6">
<Value>CPWSIOrdSetDR</Value>
</Value>
<Value name="7">
<Value>CPWSICheckPoint</Value>
</Value>
<Value name="8">
<Value>CPWSICheckDesc</Value>
</Value>
<Value name="9">
<Value>CPWSIIsMust</Value>
</Value>
<Value name="10">
<Value>CPWSIBLItmList</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ITEM")</DataLocation>
<DefaultData>DataMaster</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("ITEM")</IdLocation>
<IndexLocation>^DHCMRCi("CPW",0,"ITEM")</IndexLocation>
<SqlChildSub>CPWSI_Childsub</SqlChildSub>
<SqlRowIdName>CPWSI_RowId</SqlRowIdName>
<StreamLocation>^User.DHCMRCClinPaA48S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
