/// 名称: DHCMed.DP.Meta.LabRecDataAnti
/// 描述: 药敏结果
/// 编写者：zhugz
/// 编写日期: 2013-11-27
Class DHCMed.DP.Meta.LabRecDataAnti Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// DHCMed.DP.Meta.LabRec Parent Reference
Relationship ParRef As DHCMed.DP.Meta.LabRecData [ Cardinality = parent, Inverse = ChildAnti, Required ];

/// 抗生素
Property LDAAntibiotics As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = LDA_Antibiotics ];

/// 药敏结果
Property LDAResult As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = LDA_Result ];

/// Creator：     zhugz
/// CreatDate：   2013-11-27
/// Description:  更新药敏结果
/// Table：       DHCMed.DP.Meta.LabRecDataAnti
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.DP.Meta.LabRecDataAnti).Update("3||1^^4^5^6^7^8^8^21^^^^^^^")
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
		set obj=##class(DHCMed.DP.Meta.LabRecDataAnti).%New()
		} 
	else {
		set ParObjID=$p(InStr,separete,1)
		set ID=ParObjID_"||"_ChildID
		set obj=##class(DHCMed.DP.Meta.LabRecDataAnti).%OpenId(ID)
		}

	set ParObj=##class(DHCMed.DP.Meta.LabRecData).GetObjById($p(InStr,separete,1))

	q:'$IsObject(ParObj)||'$IsObject(obj) -1
	set obj.LabRecDataParRef=ParObj
	set obj.LDAAntibiotics=$p(InStr,separete,3)
	set obj.LDAResult=$p(InStr,separete,4)


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
/// Description:  删除药敏结果
/// Table：       DHCMed.DP.Meta.LabRecDataAnti
/// Input：       DHCMed.DP.Meta.LabRecDataAnti.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.DP.Meta.LabRecDataAnti).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// Input：       DHCMed.DP.Meta.LabRecDataAnti.ID
/// Return：      DHCMed.DP.Meta.LabRecDataAnti
/// w ##class(DHCMed.DP.Meta.LabRecDataAnti).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.DP.Meta.LabRecDataAnti
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.DP.Meta.LabRecDataAnti).%ExistsId(id) return
	set obj=##Class(DHCMed.DP.Meta.LabRecDataAnti).%OpenId(id)
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
<Value>LDAAntibiotics</Value>
</Value>
<Value name="3">
<Value>LDAResult</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ANT")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("ANT")</IdLocation>
<IndexLocation>{%%PARENT}("ANT")(0)</IndexLocation>
<StreamLocation>^DHCMed.DP.Meta.LabRecDataAntiS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
