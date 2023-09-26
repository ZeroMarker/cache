/// 名称: CT.IPMR.FP.ICDAlias
/// 描述: ICD别名
/// 创建者：liyi
/// 创建日期: 2019-09-17
Class CT.IPMR.FP.ICDAlias Extends (%Persistent, MA.IPMR.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As CT.IPMR.FP.ICDDx [ Cardinality = parent, Inverse = ChildAlias ];

/// ICD版本
Property FIICDVerDr As CT.IPMR.FP.ICDVer;

/// 别名
Property FIAlias As %String(MAXLEN = 100, TRUNCATE = 1);

Index IndexAlias On (FIICDVerDr, FIAlias);

/// Creator：     chenPJ
/// CreatDate：   2019-10-22
/// Description:  根据ID取ICD别名
/// Table：       CT.IPMR.BT.ICDAlias
/// Input：       ID:    CT.IPMR.BT.ICDAlias.ID
/// Return：      返回Object
/// w ##class(CT.IPMR.FP.ICDAlias).GetObjById(1||1)
ClassMethod GetObjById(id As %String) As CT.IPMR.FP.ICDAlias
{
	New (id)
	Set return=""
	Quit:id="" return
	
	Set obj=##Class(CT.IPMR.FP.ICDAlias).%OpenId(id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     chenPJ
/// CreatDate：   2019-10-22
/// Description:  更新ICD别名
/// Table：       CT.IPMR.BT.ICDAlias
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(CT.IPMR.FP.ICDAlias).Update("1^^1^古典生物型霍乱","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String = "^") As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:aInputStr="" return
	
	Set Parref   = $p(aInputStr,aSeparate,1)
	Set ChildSub = $p(aInputStr,aSeparate,2)
	Set ICDVerID = $p(aInputStr,aSeparate,3)
	Set IAAlias  = $p(aInputStr,aSeparate,4)
	Quit:(Parref="")||(ICDVerID="")||(IAAlias="") return

	Set objParref=##class(CT.IPMR.FP.ICDDx).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	Set objICDVer = ##class(CT.IPMR.FP.ICDVer).GetObjById(ICDVerID)
	Quit:'$IsObject(objICDVer) return
	
	if ChildSub="" {
		Set ChildSub=$o(^CT.IPMR.FP.ICDDxI("Alias","IndexAlias",ICDVerID," "_$zcvt(IAAlias,"U"),Parref,0))
	}
	
	if ChildSub="" {
		Set obj=##class(CT.IPMR.FP.ICDAlias).%New()
	}else{
		Set obj=##class(CT.IPMR.FP.ICDAlias).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref   	= objParref
	Set obj.FIICDVerDr  = objICDVer
	Set obj.FIAlias  	= IAAlias
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     chenPJ
/// CreatDate：   2019-10-22
/// Description:  删除ICD别名
/// Table：       CT.IPMR.FP.ICDAlias
/// Input：       Id
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(Id)
{
	New (Id)
	Set sc = ##class(CT.IPMR.FP.ICDAlias).%DeleteId(Id)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set ret=-1
	} else {
		Set ret=1
	}
	Quit ret
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FIICDVerDr</Value>
</Value>
<Value name="3">
<Value>FIAlias</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Alias")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>{%%PARENT}("Alias")</IdLocation>
<IndexLocation>^CT.IPMR.FP.ICDDxI("Alias")</IndexLocation>
<StreamLocation>^CT.IPMR.FP.ICDAliasS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
