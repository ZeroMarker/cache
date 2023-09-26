/// 名称: CT.IPMR.FP.ICDCatSub
/// 描述: 编码库亚目
/// 创建者：liyi
/// 创建日期: 2019-09-17
Class CT.IPMR.FP.ICDCatSub Extends (%Persistent, MA.IPMR.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// ICD编码类型（ICDType） 手术/诊断
Property FIICDType As CT.IPMR.BT.Dictionary [ Required ];

/// 描述
Property FIDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 代码
Property FIICDAlias As %String(MAXLEN = 100, TRUNCATE = 1);

Index IndexICDAlias On (FIICDType, FIICDAlias) [ Unique ];

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  取编码库亚目
/// Table：       CT.IPMR.FP.ICDCatSub
/// Input：       Id : CT.IPMR.FP.ICDCatSub.ID
/// Return：      返回Object
/// w ##class(CT.IPMR.FP.ICDCatSub).GetObjById()
ClassMethod GetObjById(aId As %String) As CT.IPMR.FP.ICDCatSub
{
	new (aId)
	quit:'##class(CT.IPMR.FP.ICDCatSub).%ExistsId(aId) ""
	set obj=##Class(CT.IPMR.FP.ICDCatSub).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  更新编码库亚目
/// Table：       CT.IPMR.FP.ICDCatSub
/// Input：       InputStr ：分类数据
///               Separate : 分隔符
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(CT.IPMR.FP.ICDCatSub).Update("^1||1^1^1^1^1^","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set ID			= $p(aInputStr,aSeparate,1)
	Set ICDType		= $p(aInputStr,aSeparate,2)
	Set Desc 		= $p(aInputStr,aSeparate,3)
	Set ICDAlias	= $p(aInputStr,aSeparate,4)
	Quit:(Desc="")||(ICDAlias="")||(ICDType="") return
	Set objICDType = ##class(CT.IPMR.BT.Dictionary).GetObjById(ICDType)
	Quit:'$isobject(objICDType) return
	
	Set tID = $o(^CT.IPMR.FP.ICDCatSubI("IndexICDAlias",ICDType," "_$zcvt(ICDAlias,"U"),0))
	Quit:(ID'="")&&(ID'=tID) -100
	
	Set:ID="" ID=tID
	If ID="" {
		Set obj=##class(CT.IPMR.FP.ICDCatSub).%New()
	}Else{
		Set obj=##class(CT.IPMR.FP.ICDCatSub).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	Set obj.FIICDType	= objICDType
	Set obj.FIDesc		= Desc
	Set obj.FIICDAlias	= ICDAlias
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  删除编码库亚目
/// Table：       CT.IPMR.FP.ICDCatSub
/// Input：       Id : CT.IPMR.FP.ICDCatSub.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##class(CT.IPMR.FP.ICDCatSub).DeleteById()
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(CT.IPMR.FP.ICDCatSub).%DeleteId(aId)
	if $system.Status.IsError(sc) {  //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set return=-1
	}else{
		set return=1
	}
	quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FIICDType</Value>
</Value>
<Value name="3">
<Value>FIDesc</Value>
</Value>
<Value name="4">
<Value>FIICDAlias</Value>
</Value>
</Data>
<DataLocation>^CT.IPMR.FP.ICDCatSubD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CT.IPMR.FP.ICDCatSubD</IdLocation>
<IndexLocation>^CT.IPMR.FP.ICDCatSubI</IndexLocation>
<StreamLocation>^CT.IPMR.FP.ICDCatSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
