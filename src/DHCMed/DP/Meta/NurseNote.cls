/// 名称: DHCMed.DP.Meta.NurseNote
/// 描述: 数据池之护理记录
/// 编写者：zhugz
/// 编写日期: 2013-11-27
Class DHCMed.DP.Meta.NurseNote Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 主记录ID
Property NNMainID As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = NN_MainID ];

/// 与主记录DataSubCat一致
Property NNDataSubCat As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = NN_DataSubCat ];

/// 与主记录ObjectID一致
Property NNObjectID As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = NN_ObjectID ];

/// 记录日期
Property NNRecDate As %Date [ SqlColumnNumber = 5, SqlFieldName = NN_RecDate ];

/// 记录时间
Property NNRecTime As %Time [ SqlColumnNumber = 6, SqlFieldName = NN_RecTime ];

/// 项目代码
Property NNItemCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = NN_ItemCode ];

/// 项目名称
Property NNItemDesc As %String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = NN_ItemDesc ];

/// 项目值
Property NNItemValue As %String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = NN_ItemValue ];

/// 备注
Property NNResume As %String(TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = NN_Resume ];

/// Creator：     zhugz
/// CreatDate：   2013-11-27
/// Description:  更新数据池之护理记录
/// Table：       DHCMed.DP.Meta.NurseNote
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.DP.Meta.NurseNote).Update("^1^2^3^4^5^6^7^8")
ClassMethod Update(InStr As %String, separete As %String) As %String
{

	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
	}
	
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.DP.Meta.NurseNote).%New()
		} 
	else {
		set obj=##class(DHCMed.DP.Meta.NurseNote).%OpenId(ID)
		}

	set obj.NNMainID=$p(InStr,separete,2)
	set obj.NNDataSubCat=$p(InStr,separete,3)
	set obj.NNObjectID=$p(InStr,separete,4)
	set obj.NNRecDate=+$p(InStr,separete,5)
	set obj.NNRecTime=$p(InStr,separete,6)
	set obj.NNItemCode=$p(InStr,separete,7)
	set obj.NNItemDesc=+$p(InStr,separete,8)
	set obj.NNItemValue=$p(InStr,separete,9)
	set obj.NNResume=$p(InStr,separete,10)


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
/// Description:  删除数据池之护理记录
/// Table：       DHCMed.DP.Meta.NurseNote
/// Input：       DHCMed.DP.Meta.NurseNote.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.DP.Meta.NurseNote).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// Input：       DHCMed.DP.Meta.NurseNote.ID
/// Return：      DHCMed.DP.Meta.NurseNote
/// w ##class(DHCMed.DP.Meta.NurseNote).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.DP.Meta.NurseNote
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.DP.Meta.NurseNote).%ExistsId(+id) return
	set obj=##Class(DHCMed.DP.Meta.NurseNote).%OpenId(+id)
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
<Value>NNMainID</Value>
</Value>
<Value name="3">
<Value>NNDataSubCat</Value>
</Value>
<Value name="4">
<Value>NNObjectID</Value>
</Value>
<Value name="5">
<Value>NNRecDate</Value>
</Value>
<Value name="6">
<Value>NNRecTime</Value>
</Value>
<Value name="7">
<Value>NNItemCode</Value>
</Value>
<Value name="8">
<Value>NNItemDesc</Value>
</Value>
<Value name="9">
<Value>NNItemValue</Value>
</Value>
<Value name="10">
<Value>NNResume</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DP.Meta.NurseNoteD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.DP.Meta.NurseNoteD</IdLocation>
<IndexLocation>^DHCMed.DP.Meta.NurseNoteI</IndexLocation>
<StreamLocation>^DHCMed.DP.Meta.NurseNoteS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
