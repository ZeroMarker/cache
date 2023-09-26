/// 名称: DHCMed.DP.Meta.ExamRec
/// 描述: 检查结果
/// 编写者：zhugz
/// 编写日期: 2013-11-27
Class DHCMed.DP.Meta.ExamRec Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 主记录ID
Property ERMainID As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = ER_MainID ];

/// 与主记录DataSubCat一致
Property ERDataSubCat As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = ER_DataSubCat ];

/// 与主记录ObjectID一致
Property ERObjectID As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = ER_ObjectID ];

/// 检查项目代码
Property ERItemCode As %String [ SqlColumnNumber = 5, SqlFieldName = ER_ItemCode ];

/// 检查项目名称
Property ERItemDesc As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = ER_ItemDesc ];

/// 申请日期
Property ERReqDate As %Date [ SqlColumnNumber = 7, SqlFieldName = ER_ReqDate ];

/// 申请时间
Property ERReqTime As %Time [ SqlColumnNumber = 8, SqlFieldName = ER_ReqTime ];

/// 检查日期
Property ERExamDate As %Date [ SqlColumnNumber = 9, SqlFieldName = ER_ExamDate ];

/// 检查时间
Property ERExamTime As %Time [ SqlColumnNumber = 10, SqlFieldName = ER_ExamTime ];

/// 录入日期
Property EREntryDate As %Date [ SqlColumnNumber = 11, SqlFieldName = ER_EntryDate ];

/// 录入时间
Property EREntryTime As %Time [ SqlColumnNumber = 12, SqlFieldName = ER_EntryTime ];

/// 审核日期
Property ERAuthDate As %Date [ SqlColumnNumber = 13, SqlFieldName = ER_AuthDate ];

/// 审核时间
Property ERAuthTime As %Time [ SqlColumnNumber = 14, SqlFieldName = ER_AuthTime ];

/// 病人病情
Property ERCondition As %String [ SqlColumnNumber = 15, SqlFieldName = ER_Condition ];

/// 诊断意见
Property EROpinion As %String [ SqlColumnNumber = 16, SqlFieldName = ER_Opinion ];

/// 备注
Property ERResume As %String(TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = ER_Resume ];

/// Creator：     zhugz
/// CreatDate：   2013-11-27
/// Description:  更新检查结果
/// Table：       DHCMed.DP.Meta.ExamRec
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.DP.Meta.ExamRec).Update("^1^01^12^32^1^2^3^4^5^6^7^8^9^0^1^^^^^^")
ClassMethod Update(InStr As %String, separete As %String) As %String
{

	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
	}
	
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.DP.Meta.ExamRec).%New()
		} 
	else {
		set obj=##class(DHCMed.DP.Meta.ExamRec).%OpenId(ID)
		}
	set obj.ERMainID=$p(InStr,separete,2)
	set obj.ERDataSubCat=$p(InStr,separete,3)
	set obj.ERObjectID=$p(InStr,separete,4)
	set obj.ERItemCode=$p(InStr,separete,5)
	set obj.ERItemDesc=$p(InStr,separete,6)
	set obj.ERReqDate=$p(InStr,separete,7)
	set obj.ERReqTime=$p(InStr,separete,8)
	set obj.ERExamDate=$p(InStr,separete,9)
	set obj.ERExamTime=$p(InStr,separete,10)
	set obj.EREntryDate=$p(InStr,separete,11)
	set obj.EREntryTime=$p(InStr,separete,12)
	set obj.ERAuthDate=$p(InStr,separete,13)
	set obj.ERAuthTime=$p(InStr,separete,14)
	set obj.ERCondition=$p(InStr,separete,15)
	set obj.EROpinion=$p(InStr,separete,16)
	set obj.ERResume=$p(InStr,separete,17)
	
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
/// Description:  删除检查结果
/// Table：       DHCMed.DP.Meta.ExamRec
/// Input：       DHCMed.DP.Meta.ExamRec.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.DP.Meta.ExamRec).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// Input：       DHCMed.DP.Meta.ExamRec.ID
/// Return：      DHCMed.DP.Meta.ExamRec
/// w ##class(DHCMed.DP.Meta.ExamRec).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.DP.Meta.ExamRec
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.DP.Meta.ExamRec).%ExistsId(+id) return
	set obj=##Class(DHCMed.DP.Meta.ExamRec).%OpenId(+id)
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
<Value>ERMainID</Value>
</Value>
<Value name="3">
<Value>ERDataSubCat</Value>
</Value>
<Value name="4">
<Value>ERObjectID</Value>
</Value>
<Value name="5">
<Value>ERItemCode</Value>
</Value>
<Value name="6">
<Value>ERItemDesc</Value>
</Value>
<Value name="7">
<Value>ERReqDate</Value>
</Value>
<Value name="8">
<Value>ERReqTime</Value>
</Value>
<Value name="9">
<Value>ERExamDate</Value>
</Value>
<Value name="10">
<Value>ERExamTime</Value>
</Value>
<Value name="11">
<Value>EREntryDate</Value>
</Value>
<Value name="12">
<Value>EREntryTime</Value>
</Value>
<Value name="13">
<Value>ERAuthDate</Value>
</Value>
<Value name="14">
<Value>ERAuthTime</Value>
</Value>
<Value name="15">
<Value>ERCondition</Value>
</Value>
<Value name="16">
<Value>EROpinion</Value>
</Value>
<Value name="17">
<Value>ERResume</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DP.Meta.ExamRecD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.DP.Meta.ExamRecD</IdLocation>
<IndexLocation>^DHCMed.DP.Meta.ExamRecI</IndexLocation>
<StreamLocation>^DHCMed.DP.Meta.ExamRecS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
