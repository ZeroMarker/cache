/// 名称: DHCMed.DP.Meta.EmrProNote
/// 描述: 日常病程记录
/// 编写者：zhufei
/// 编写日期: 2014-07-01
Class DHCMed.DP.Meta.EmrProNote Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 记录ID
Property EPNRecordID As %String(MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = EPN_RecordID ];

/// 就诊号
Property EPNEpisodeID As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = EPN_EpisodeID ];

/// 数据大类
Property EPNCategory As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = EPN_Category ];

/// 数据子类
Property EPNSubCat As %String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = EPN_SubCat ];

/// 病程日期
Property EPNProDate As %Date [ SqlColumnNumber = 6, SqlFieldName = EPN_ProDate ];

/// 病程时间
Property EPNProTime As %Time [ SqlColumnNumber = 7, SqlFieldName = EPN_ProTime ];

/// 医生代码
Property EPNDocCode As %String [ SqlColumnNumber = 8, SqlFieldName = EPN_DocCode ];

/// 医生名称
Property EPNDocDesc As %String [ SqlColumnNumber = 9, SqlFieldName = EPN_DocDesc ];

/// 病程标题
Property EPNProTitle As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = EPN_ProTitle ];

/// 病程记录
Property EPNProNote As %String(MAXLEN = 5000, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = EPN_ProNote ];

/// 记录日期
Property EPNActDate As %Date [ SqlColumnNumber = 12, SqlFieldName = EPN_ActDate ];

/// 记录时间
Property EPNActTime As %Time [ SqlColumnNumber = 13, SqlFieldName = EPN_ActTime ];

/// 是否有效
Property EPNIsActive As %String [ SqlColumnNumber = 14, SqlFieldName = EPN_IsActive ];

/// 备注
Property EPNResume As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = EPN_Resume ];

/// Creator：     zhufei
/// CreatDate：   2014-07-01
/// Description:  更新病程记录
/// Table：       DHCMed.DP.Meta.EmrProNote
/// Input：       DHCMed.DP.Meta.EmrProNote.ID
/// Return：      DHCMed.DP.Meta.EmrProNote
/// w ##class(DHCMed.DP.Meta.EmrProNote).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.DP.Meta.EmrProNote
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.DP.Meta.EmrProNote).%ExistsId(+id) return
	set obj=##Class(DHCMed.DP.Meta.EmrProNote).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-07-01
/// Description:  更新病程记录
/// Table：       DHCMed.DP.Meta.EmrProNote
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.DP.Meta.EmrProNote).Update("^1^01^12^32^1^2^3^4^5^6^7^8^9^0^1^^^^^^")
ClassMethod Update(InStr As %String, separete As %String) As %String
{

	new (InStr,separete)
	set return=0
	quit:InStr="" return
	
	if $g(separete)=""{
		set separete=..#SEPARATE
	}
	
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.DP.Meta.EmrProNote).%New()
	} else {
		set obj=##class(DHCMed.DP.Meta.EmrProNote).%OpenId(ID)
	}
	
	set obj.EPNRecordID=$p(InStr,separete,2)
	set obj.EPNEpisodeID=$p(InStr,separete,3)
	set obj.EPNCategory=$p(InStr,separete,4)
	set obj.EPNSubCat=$p(InStr,separete,5)
	set obj.EPNProDate=$p(InStr,separete,6)
	set obj.EPNProTime=$p(InStr,separete,7)
	set obj.EPNDocCode=$p(InStr,separete,8)
	set obj.EPNDocDesc=$p(InStr,separete,9)
	set obj.EPNProTitle=$p(InStr,separete,10)
	set obj.EPNProNote=$p(InStr,separete,11)
	set obj.EPNActDate=$p(InStr,separete,12)
	set obj.EPNActTime=$p(InStr,separete,13)
	set obj.EPNIsActive=+$p(InStr,separete,14)
	set obj.EPNResume=$p(InStr,separete,15)
	
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set return=-1
	}else{
		set return=obj.%Id()
	}
	do obj.%Close()
	
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-07-01
/// Description:  删除病程记录
/// Table：       DHCMed.DP.Meta.EmrProNote
/// Input：       DHCMed.DP.Meta.EmrProNote.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.DP.Meta.EmrProNote).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EPNRecordID</Value>
</Value>
<Value name="3">
<Value>EPNEpisodeID</Value>
</Value>
<Value name="4">
<Value>EPNCategory</Value>
</Value>
<Value name="5">
<Value>EPNSubCat</Value>
</Value>
<Value name="6">
<Value>EPNProDate</Value>
</Value>
<Value name="7">
<Value>EPNProTime</Value>
</Value>
<Value name="8">
<Value>EPNDocCode</Value>
</Value>
<Value name="9">
<Value>EPNDocDesc</Value>
</Value>
<Value name="10">
<Value>EPNProTitle</Value>
</Value>
<Value name="11">
<Value>EPNProNote</Value>
</Value>
<Value name="12">
<Value>EPNActDate</Value>
</Value>
<Value name="13">
<Value>EPNActTime</Value>
</Value>
<Value name="14">
<Value>EPNIsActive</Value>
</Value>
<Value name="15">
<Value>EPNResume</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DP.Meta.EmrProNoteD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.DP.Meta.EmrProNoteD</IdLocation>
<IndexLocation>^DHCMed.DP.Meta.EmrProNoteI</IndexLocation>
<StreamLocation>^DHCMed.DP.Meta.EmrProNoteS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
