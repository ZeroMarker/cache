/// 名称: DHCMed.DP.Meta.EmrElItem
/// 描述: 数据池之病历单元
/// 编写者：zhugz
/// 编写日期: 2013-11-27
Class DHCMed.DP.Meta.EmrElItem Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ChildCode As DHCMed.DP.Meta.EmrElCode [ Cardinality = children, Inverse = ParRef ];

/// 数据分类（代码）
Property EEIDataCate As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = EEI_DataCate ];

/// 数据子分类（代码）
Property EEIDataSubCat As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = EEI_DataSubCat ];

/// 项目代码
Property EEIItemCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = EEI_ItemCode ];

/// 项目名称
Property EEIItemDesc As %String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = EEI_ItemDesc ];

/// 备注
Property EEIResume As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = EEI_Resume ];

/// Creator：     zhugz
/// CreatDate：   2013-11-27
/// Description:  更新数据池之病历单元
/// Table：       DHCMed.DP.Meta.EmrElItem
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.DP.Meta.EmrElItem).Update("^1^2^3^4^5^6^7^8")
ClassMethod Update(InStr As %String, separete As %String) As %String
{

	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
	}
	
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.DP.Meta.EmrElItem).%New()
		} 
	else {
		set obj=##class(DHCMed.DP.Meta.EmrElItem).%OpenId(ID)
		}

	set obj.EEIDataCate=$p(InStr,separete,2)
	set obj.EEIDataSubCat=$p(InStr,separete,3)
	set obj.EEIItemCode=$p(InStr,separete,4)
	set obj.EEIItemDesc=+$p(InStr,separete,5)
	set obj.EEIResume=$p(InStr,separete,6)

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
/// Description:  删除数据池之病历单元
/// Table：       DHCMed.DP.Meta.EmrElItem
/// Input：       DHCMed.DP.Meta.EmrElItem.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.DP.Meta.EmrElItem).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// Input：       DHCMed.DP.Meta.EmrElItem.ID
/// Return：      DHCMed.DP.Meta.EmrElItem
/// w ##class(DHCMed.DP.Meta.EmrElItem).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.DP.Meta.EmrElItem
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.DP.Meta.EmrElItem).%ExistsId(+id) return
	set obj=##Class(DHCMed.DP.Meta.EmrElItem).%OpenId(+id)
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
<Value>EEIDataCate</Value>
</Value>
<Value name="3">
<Value>EEIDataSubCat</Value>
</Value>
<Value name="4">
<Value>EEIItemCode</Value>
</Value>
<Value name="5">
<Value>EEIItemDesc</Value>
</Value>
<Value name="6">
<Value>EEIResume</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DP.Meta.EmrElItemD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.DP.Meta.EmrElItemD</IdLocation>
<IndexLocation>^DHCMed.DP.Meta.EmrElItemI</IndexLocation>
<StreamLocation>^DHCMed.DP.Meta.EmrElItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
