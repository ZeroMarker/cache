/// 名称: DHCMed.DP.Meta.EmrElCode
/// 描述: 数据池之病历单元代码
/// 编写者：zhugz
/// 编写日期: 2013-11-27
Class DHCMed.DP.Meta.EmrElCode Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ParRef As DHCMed.DP.Meta.EmrElItem [ Cardinality = parent, Inverse = ChildCode ];

/// 模板单元代码
Property EECElementCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = EEC_ElementCode ];

/// 目录ID（可重复模板）
Property EECCategoryID As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = EEC_CategoryID ];

/// 模板ID
Property EECTemplateID As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = EEC_TemplateID ];

/// 病程Title（可重复模板）
Property EECProgressTitle As %String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = EEC_ProgressTitle ];

/// 备注
Property EECResume As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = EEC_Resume ];

/// Creator：     zhugz
/// CreatDate：   2013-11-27
/// Description:  更新数据池之病历单元代码
/// Table：       DHCMed.DP.Meta.EmrElCode
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.DP.Meta.EmrElCode).Update("3^^Code1^Code2^谔谔^2^7^8")
ClassMethod Update(InStr As %String, separete As %String) As %String
{

	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
	}
	q:$p(InStr,separete,1)="" -1
	set id=0
	set ChildID=$p(InStr,separete,2)
	if ChildID="" {
		set obj=##class(DHCMed.DP.Meta.EmrElCode).%New()
		} 
	else {
		set ParObjID=$p(InStr,separete,1)
		set ID=ParObjID_"||"_ChildID
		set obj=##class(DHCMed.DP.Meta.EmrElCode).%OpenId(ID)
		}
	set ParObj=##class(DHCMed.DP.Meta.EmrElItem).GetObjById($p(InStr,separete,1))
	q:'$IsObject(ParObj)||'$IsObject(obj) -1
	set obj.EmrParRef=ParObj
	set obj.EECElementCode=$p(InStr,separete,3)
	set obj.EECCategoryID=$p(InStr,separete,4)
	set obj.EECTemplateID=$p(InStr,separete,5)
	set obj.EECProgressTitle=+$p(InStr,separete,6)
	set obj.EECResume=$p(InStr,separete,7)

	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set id=-1
	}
	else{
		set id=obj.%Id()
		}
	do obj.%Close()
	quit id
}

/// Creator：     zhugz
/// CreatDate：   2013-11-27
/// Description:  删除数据池之病历单元代码
/// Table：       DHCMed.DP.Meta.EmrElCode
/// Input：       DHCMed.DP.Meta.EmrElCode.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.DP.Meta.EmrElCode).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// Input：       DHCMed.DP.Meta.EmrElCode.ID
/// Return：      DHCMed.DP.Meta.EmrElCode
/// w ##class(DHCMed.DP.Meta.EmrElCode).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.DP.Meta.EmrElCode
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.DP.Meta.EmrElCode).%ExistsId(+id) return
	set obj=##Class(DHCMed.DP.Meta.EmrElCode).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EECElementCode</Value>
</Value>
<Value name="3">
<Value>EECCategoryID</Value>
</Value>
<Value name="4">
<Value>EECTemplateID</Value>
</Value>
<Value name="5">
<Value>EECProgressTitle</Value>
</Value>
<Value name="6">
<Value>EECResume</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("CODE")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("CODE")</IdLocation>
<IndexLocation>{%%PARENT}("CODE")(0)</IndexLocation>
<StreamLocation>^DHCMed.DP.Meta.EmrElCodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
