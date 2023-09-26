/// 监控快照明细
Class DHCMed.CC.EvaluationDetail Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 所属的监控主体评价表
Property Parref As %Integer;

Index ParrefIndex On Parref;

/// 监控项目字典ID
Property ItemDic As %Integer;

/// 监控触发项目的详情
Property ItemDetail As %String;

Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
	}
	set return=..%Id()_separete
	Set return=return_Parref_separete
	Set return=return_ItemDic_separete
	Set return=return_ItemDetail_separete
	Quit return
}

ClassMethod GetObjById(argId As %String) As DHCMed.CC.EvaluationDetail
{
	New (argId)
	Set return=""
	Quit:argId="" return
	Set return=##Class(DHCMed.CC.EvaluationDetail).%OpenId(argId)
	If $IsObject(return) Do return.%Close()
	Quit return
}

ClassMethod Update(argInput As %String, argSeperator As %String = "^") As %Integer
{
	New (argInput,argSeperator)
	Set return=0
	Set ID=$p(argInput,argSeperator,1)
	If ID="" {
		Set obj=##class(DHCMed.CC.EvaluationDetail).%New()
	}Else{
		Set obj=##class(DHCMed.CC.EvaluationDetail).%OpenId(ID)
		Quit:'$IsObject(obj) return
	}
	Set obj.Parref=$p(argSeperator,"^",1)
	Set obj.ItemDic=$p(argSeperator,"^",2)
	Set obj.ItemDetail=$p(argSeperator,"^",3)
	
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {     //检查Save是否成功
   		d $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

Storage Default
{
<Data name="EvaluationDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ItemDetail</Value>
</Value>
<Value name="3">
<Value>ItemDic</Value>
</Value>
<Value name="4">
<Value>Parref</Value>
</Value>
</Data>
<DataLocation>^DHCMed.CC("ApprDtl")</DataLocation>
<DefaultData>EvaluationDetailDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.CC("ApprDtl")</IdLocation>
<IndexLocation>^DHCMed.CCi("IApprDtl",0)</IndexLocation>
<StreamLocation>^DHCMed.CC.EvaluationDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
