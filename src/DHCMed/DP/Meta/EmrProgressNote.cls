/// 名称: DHCMed.DP.Meta.EmrProgressNote
/// 描述: 病程记录
/// 编写者：zhugz
/// 编写日期: 2013-11-27
Class DHCMed.DP.Meta.EmrProgressNote Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 主记录ID
Property EPNMainID As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = EPN_MainID ];

/// 与主记录DataSubCat一致
Property EPNDataSubCat As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = EPN_DataSubCat ];

/// 与主记录ObjectID一致
Property EPNObjectID As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = EPN_ObjectID ];

/// 记录日期
Property EPNRecDate As %Date [ SqlColumnNumber = 5, SqlFieldName = EPN_RecDate ];

/// 记录时间
Property EPNRecTime As %Time [ SqlColumnNumber = 6, SqlFieldName = EPN_RecTime ];

/// 病程记录标题
Property EPNProTitle As %String [ SqlColumnNumber = 7, SqlFieldName = EPN_ProTitle ];

/// 病程记录
Property EPNProNote As %String [ SqlColumnNumber = 8, SqlFieldName = EPN_ProNote ];

/// 关键字
Property EPNKeyWords As %String [ SqlColumnNumber = 9, SqlFieldName = EPN_KeyWords ];

/// 备注
Property EPNResume As %String [ SqlColumnNumber = 10, SqlFieldName = EPN_Resume ];

/// Creator：     zhugz
/// CreatDate：   2013-11-27
/// Description:  更新病程记录
/// Table：       DHCMed.DP.Meta.EmrProgressNote
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.DP.Meta.EmrProgressNote).Update("^1^01^12^32^1^2^3^4^5^6^7^8^9^0^1^^^^^^")
ClassMethod Update(InStr As %String, separete As %String) As %String
{

	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
	}
	
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.DP.Meta.EmrProgressNote).%New()
		} 
	else {
		set obj=##class(DHCMed.DP.Meta.EmrProgressNote).%OpenId(ID)
		}
	set obj.EPNMainID=$p(InStr,separete,2)
	set obj.EPNDataSubCat=$p(InStr,separete,3)
	set obj.EPNObjectID=$p(InStr,separete,4)
	set obj.EPNRecDate=$p(InStr,separete,5)
	set obj.EPNRecTime=$p(InStr,separete,6)
	set obj.EPNProTitle=$p(InStr,separete,7)
	set obj.EPNProNote=$p(InStr,separete,8)
	set obj.EPNKeyWords=$p(InStr,separete,9)
	set obj.EPNResume=$p(InStr,separete,10)

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
/// Description:  删除病程记录
/// Table：       DHCMed.DP.Meta.EmrProgressNote
/// Input：       DHCMed.DP.Meta.EmrProgressNote.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.DP.Meta.EmrProgressNote).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// Input：       DHCMed.DP.Meta.EmrProgressNote.ID
/// Return：      DHCMed.DP.Meta.EmrProgressNote
/// w ##class(DHCMed.DP.Meta.EmrProgressNote).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.DP.Meta.EmrProgressNote
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.DP.Meta.EmrProgressNote).%ExistsId(+id) return
	set obj=##Class(DHCMed.DP.Meta.EmrProgressNote).%OpenId(+id)
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
<Value>EPNMainID</Value>
</Value>
<Value name="3">
<Value>EPNDataSubCat</Value>
</Value>
<Value name="4">
<Value>EPNObjectID</Value>
</Value>
<Value name="5">
<Value>EPNRecDate</Value>
</Value>
<Value name="6">
<Value>EPNRecTime</Value>
</Value>
<Value name="7">
<Value>EPNProTitle</Value>
</Value>
<Value name="8">
<Value>EPNProNote</Value>
</Value>
<Value name="9">
<Value>EPNKeyWords</Value>
</Value>
<Value name="10">
<Value>EPNResume</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DP.Meta.EmrProgressNoteD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.DP.Meta.EmrProgressNoteD</IdLocation>
<IndexLocation>^DHCMed.DP.Meta.EmrProgressNoteI</IndexLocation>
<StreamLocation>^DHCMed.DP.Meta.EmrProgressNoteS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
