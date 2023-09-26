/// 名称: DHCMed.DP.Meta.LabTestSet
/// 描述: 数据池之检验医嘱
/// 编写者：zhugz
/// 编写日期: 2013-11-27
Class DHCMed.DP.Meta.LabTestSet Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ChildData As DHCMed.DP.Meta.LabTestSetData [ Cardinality = children, Inverse = ParRef ];

/// 主记录ID
Property LTSMainID As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = LTS_MainID ];

/// 与主记录DataSubCat一致
Property LTSDataSubCat As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = LTS_DataSubCat ];

/// 与主记录ObjectID一致
Property LTSObjectID As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = LTS_ObjectID ];

/// 医嘱代码
Property LTSOEItmCode As %String [ SqlColumnNumber = 5, SqlFieldName = LTS_OEItmCode ];

/// 医嘱描述
Property LTSOEItmDesc As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = LTS_OEItmDesc ];

/// 检验号
Property LTSTestSetRow As %String [ SqlColumnNumber = 7, SqlFieldName = LTS_TestSetRow ];

/// 检验医嘱代码
Property LTSTSCode As %String [ SqlColumnNumber = 8, SqlFieldName = LTS_TSCode ];

/// 检验医嘱描述
Property LTSTSDesc As %String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = LTS_TSDesc ];

/// 检验医嘱备注
Property LTSComments As %String(TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = LTS_Comments ];

/// 申请日期
Property LTSReqDate As %Date [ SqlColumnNumber = 11, SqlFieldName = LTS_ReqDate ];

/// 申请时间
Property LTSReqTime As %Time [ SqlColumnNumber = 12, SqlFieldName = LTS_ReqTime ];

/// 送检日期
Property LTSCollDate As %Date [ SqlColumnNumber = 13, SqlFieldName = LTS_CollDate ];

/// 送检时间
Property LTSCollTime As %Time [ SqlColumnNumber = 14, SqlFieldName = LTS_CollTime ];

/// 标本代码
Property LTSSpecCode As %String [ SqlColumnNumber = 15, SqlFieldName = LTS_SpecCode ];

/// 标本名称
Property LTSSpecDesc As %String [ SqlColumnNumber = 16, SqlFieldName = LTS_SpecDesc ];

/// 检验方法代码
Property LTSAssMthCode As %String [ SqlColumnNumber = 17, SqlFieldName = LTS_AssMthCode ];

/// 检验方法名称
Property LTSAssMthDesc As %String [ SqlColumnNumber = 18, SqlFieldName = LTS_AssMthDesc ];

/// 录入日期
Property LTSEntryDate As %Date [ SqlColumnNumber = 19, SqlFieldName = LTS_EntryDate ];

/// 录入时间
Property LTSEntryTime As %Time [ SqlColumnNumber = 20, SqlFieldName = LTS_EntryTime ];

/// 审核日期
Property LTSAuthDate As %Date [ SqlColumnNumber = 21, SqlFieldName = LTS_AuthDate ];

/// 审核时间
Property LTSAuthTime As %Time [ SqlColumnNumber = 22, SqlFieldName = LTS_AuthTime ];

/// 备注
Property LTSResume As %String [ SqlColumnNumber = 23, SqlFieldName = LTS_Resume ];

/// Creator：     zhugz
/// CreatDate：   2013-11-27
/// Description:  更新数据池中检验医嘱
/// Table：       DHCMed.DP.Meta.LabTestSet
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.DP.Meta.LabTestSet).Update("")
ClassMethod Update(InStr As %String, separete As %String) As %String
{

	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
	}
	
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.DP.Meta.LabTestSet).%New()
		} 
	else {
		set obj=##class(DHCMed.DP.Meta.LabTestSet).%OpenId(ID)
		}
	set obj.LTSMainID=$p(InStr,separete,2)
	set obj.LTSDataSubCat=$p(InStr,separete,3)
	set obj.LTSObjectID=$p(InStr,separete,4)
	set obj.LTSOEItmCode=$p(InStr,separete,5)
	set obj.LTSOEItmDesc=$p(InStr,separete,6)
	set obj.LTSTestSetRow=$p(InStr,separete,7)
	set obj.LTSTSCode=$p(InStr,separete,8)
	set obj.LTSTSDesc=$p(InStr,separete,9)
	set obj.LTSComments=$p(InStr,separete,10)
	set obj.LTSReqDate=$p(InStr,separete,11)
	set obj.LTSReqTime=$p(InStr,separete,12)
	set obj.LTSCollDate=$p(InStr,separete,13)
	set obj.LTSCollTime=$p(InStr,separete,14)
	set obj.LTSSpecCode=$p(InStr,separete,15)
	set obj.LTSSpecDesc=$p(InStr,separete,16)
	set obj.LTSAssMthCode=$p(InStr,separete,17)
	set obj.LTSAssMthDesc=$p(InStr,separete,18)
	set obj.LTSEntryDate=$p(InStr,separete,19)
	set obj.LTSEntryTime=$p(InStr,separete,20)
	set obj.LTSAuthDate=$p(InStr,separete,21)
	set obj.LTSAuthTime=$p(InStr,separete,22)
	set obj.LTSResume=$p(InStr,separete,23)
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
/// Description:  删除数据池中检验医嘱
/// Table：       DHCMed.DP.Meta.LabTestSet
/// Input：       DHCMed.DP.Meta.LabTestSet.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.DP.Meta.LabTestSet).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// Input：       DHCMed.DP.Meta.LabTestSet.ID
/// Return：      DHCMed.DP.Meta.LabTestSet
/// w ##class(DHCMed.DP.Meta.LabTestSet).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.DP.Meta.LabTestSet
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.DP.Meta.LabTestSet).%ExistsId(+id) return
	set obj=##Class(DHCMed.DP.Meta.LabTestSet).%OpenId(+id)
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
<Value>LTSMainID</Value>
</Value>
<Value name="3">
<Value>LTSDataSubCat</Value>
</Value>
<Value name="4">
<Value>LTSObjectID</Value>
</Value>
<Value name="5">
<Value>LTSOEItmCode</Value>
</Value>
<Value name="6">
<Value>LTSOEItmDesc</Value>
</Value>
<Value name="7">
<Value>LTSTestSetRow</Value>
</Value>
<Value name="8">
<Value>LTSTSCode</Value>
</Value>
<Value name="9">
<Value>LTSTSDesc</Value>
</Value>
<Value name="10">
<Value>LTSComments</Value>
</Value>
<Value name="11">
<Value>LTSReqDate</Value>
</Value>
<Value name="12">
<Value>LTSReqTime</Value>
</Value>
<Value name="13">
<Value>LTSCollDate</Value>
</Value>
<Value name="14">
<Value>LTSCollTime</Value>
</Value>
<Value name="15">
<Value>LTSSpecCode</Value>
</Value>
<Value name="16">
<Value>LTSSpecDesc</Value>
</Value>
<Value name="17">
<Value>LTSAssMthCode</Value>
</Value>
<Value name="18">
<Value>LTSAssMthDesc</Value>
</Value>
<Value name="19">
<Value>LTSEntryDate</Value>
</Value>
<Value name="20">
<Value>LTSEntryTime</Value>
</Value>
<Value name="21">
<Value>LTSAuthDate</Value>
</Value>
<Value name="22">
<Value>LTSAuthTime</Value>
</Value>
<Value name="23">
<Value>LTSResume</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DP.Meta.LabTestSetD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.DP.Meta.LabTestSetD</IdLocation>
<IndexLocation>^DHCMed.DP.Meta.LabTestSetI</IndexLocation>
<StreamLocation>^DHCMed.DP.Meta.LabTestSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
