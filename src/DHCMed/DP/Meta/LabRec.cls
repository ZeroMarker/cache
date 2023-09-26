/// 名称: DHCMed.DP.Meta.LabRec
/// 描述: 数据池之检验医嘱
/// 编写者：zhugz
/// 编写日期: 2013-11-27
Class DHCMed.DP.Meta.LabRec Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ChildData As DHCMed.DP.Meta.LabRecData [ Cardinality = children, Inverse = ParRef ];

/// 主记录ID
Property LRMainID As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = LR_MainID ];

/// 与主记录DataSubCat一致
Property LRDataSubCat As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = LR_DataSubCat ];

/// 与主记录ObjectID一致
Property LRObjectID As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = LR_ObjectID ];

/// 检验医嘱代码
Property LRTestSetName As %String [ SqlColumnNumber = 5, SqlFieldName = LR_TestSetName ];

/// 检验医嘱描述
Property LRTestSetDesc As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = LR_TestSetDesc ];

/// 检验医嘱备注
Property LRComments As %String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = LR_Comments ];

/// 申请日期
Property LRReqDate As %Date [ SqlColumnNumber = 8, SqlFieldName = LR_ReqDate ];

/// 申请时间
Property LRReqTime As %Time [ SqlColumnNumber = 9, SqlFieldName = LR_ReqTime ];

/// 送检日期
Property LRCollDate As %Date [ SqlColumnNumber = 10, SqlFieldName = LR_CollDate ];

/// 送检时间
Property LRCollTime As %Time [ SqlColumnNumber = 11, SqlFieldName = LR_CollTime ];

/// 标本
Property LRSpecimen As %String [ SqlColumnNumber = 12, SqlFieldName = LR_Specimen ];

/// 检验方法
Property LRAssayMethod As %String [ SqlColumnNumber = 13, SqlFieldName = LR_AssayMethod ];

/// 录入日期
Property LREntryDate As %Date [ SqlColumnNumber = 14, SqlFieldName = LR_EntryDate ];

/// 录入时间
Property LREntryTime As %Time [ SqlColumnNumber = 15, SqlFieldName = LR_EntryTime ];

/// 审核日期
Property LRAuthDate As %Date [ SqlColumnNumber = 16, SqlFieldName = LR_AuthDate ];

/// 审核时间
Property LRAuthTime As %Time [ SqlColumnNumber = 17, SqlFieldName = LR_AuthTime ];

/// 备注
Property LRResume As %String [ SqlColumnNumber = 18, SqlFieldName = LR_Resume ];

/// Creator：     zhugz
/// CreatDate：   2013-11-27
/// Description:  更新数据池中检验医嘱
/// Table：       DHCMed.DP.Meta.LabRec
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.DP.Meta.LabRec).Update("^27891^张三^12^32^1^2^3^4^5^6^7^8^9^0^1^^^^^^")
ClassMethod Update(InStr As %String, separete As %String) As %String
{

	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
	}
	
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.DP.Meta.LabRec).%New()
		} 
	else {
		set obj=##class(DHCMed.DP.Meta.LabRec).%OpenId(ID)
		}
	set obj.LRMainID=$p(InStr,separete,2)
	set obj.LRDataSubCat=$p(InStr,separete,3)
	set obj.LRObjectID=$p(InStr,separete,4)
	set obj.LRTestSetName=$p(InStr,separete,5)
	set obj.LRTestSetDesc=$p(InStr,separete,6)
	set obj.LRComments=$p(InStr,separete,7)
	set obj.LRReqDate=$p(InStr,separete,8)
	set obj.LRReqTime=$p(InStr,separete,9)
	set obj.LRCollDate=$p(InStr,separete,10)
	set obj.LRCollTime=$p(InStr,separete,11)
	set obj.LRSpecimen=$p(InStr,separete,12)
	set obj.LRAssayMethod=$p(InStr,separete,13)
	set obj.LREntryDate=$p(InStr,separete,14)
	set obj.LREntryTime=$p(InStr,separete,15)
	set obj.LRAuthDate=$p(InStr,separete,16)
	set obj.LRAuthTime=$p(InStr,separete,17)
	set obj.LRResume=$p(InStr,separete,18)
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
/// Table：       DHCMed.DP.Meta.LabRec
/// Input：       DHCMed.DP.Meta.LabRec.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.DP.Meta.LabRec).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// Input：       DHCMed.DP.Meta.LabRec.ID
/// Return：      DHCMed.DP.Meta.LabRec
/// w ##class(DHCMed.DP.Meta.LabRec).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.DP.Meta.LabRec
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.DP.Meta.LabRec).%ExistsId(+id) return
	set obj=##Class(DHCMed.DP.Meta.LabRec).%OpenId(+id)
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
<Value>LRMainID</Value>
</Value>
<Value name="3">
<Value>LRDataSubCat</Value>
</Value>
<Value name="4">
<Value>LRObjectID</Value>
</Value>
<Value name="5">
<Value>LRTestSetName</Value>
</Value>
<Value name="6">
<Value>LRTestSetDesc</Value>
</Value>
<Value name="7">
<Value>LRComments</Value>
</Value>
<Value name="8">
<Value>LRReqDate</Value>
</Value>
<Value name="9">
<Value>LRReqTime</Value>
</Value>
<Value name="10">
<Value>LRCollDate</Value>
</Value>
<Value name="11">
<Value>LRCollTime</Value>
</Value>
<Value name="12">
<Value>LRSpecimen</Value>
</Value>
<Value name="13">
<Value>LRAssayMethod</Value>
</Value>
<Value name="14">
<Value>LREntryDate</Value>
</Value>
<Value name="15">
<Value>LREntryTime</Value>
</Value>
<Value name="16">
<Value>LRAuthDate</Value>
</Value>
<Value name="17">
<Value>LRAuthTime</Value>
</Value>
<Value name="18">
<Value>LRResume</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DP.Meta.LabRecD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.DP.Meta.LabRecD</IdLocation>
<IndexLocation>^DHCMed.DP.Meta.LabRecI</IndexLocation>
<StreamLocation>^DHCMed.DP.Meta.LabRecS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
