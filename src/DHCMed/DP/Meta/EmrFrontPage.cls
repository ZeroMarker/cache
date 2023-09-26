/// 名称: DHCMed.DP.Meta.EmrFrontPage
/// 描述: 数据池之电子病历首页
/// 编写者：zhugz
/// 编写日期: 2013-11-27
Class DHCMed.DP.Meta.EmrFrontPage Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 主记录ID
Property EFPMainID As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = EFP_MainID ];

/// 与主记录DataSubCat一致
Property EFPDataSubCat As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = EFP_DataSubCat ];

/// 与主记录ObjectID一致
Property EFPObjectID As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = EFP_ObjectID ];

/// 登记号
Property EFPRegNo As %String [ SqlColumnNumber = 5, SqlFieldName = EFP_RegNo ];

/// 病案号
Property EFPMedical As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = EFP_Medical ];

/// 姓名
Property EFPName As %String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = EFP_Name ];

/// 性别
Property EFPSex As %String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = EFP_Sex ];

/// 年龄
Property EFPAge As %String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = EFP_Age ];

/// 入院日期
Property EFPAdmitDate As %Date [ SqlColumnNumber = 10, SqlFieldName = EFP_AdmitDate ];

/// 入院时间
Property EFPAdmitTime As %Time [ SqlColumnNumber = 11, SqlFieldName = EFP_AdmitTime ];

/// 入院科室
Property EFPAdmitDept As %String [ SqlColumnNumber = 12, SqlFieldName = EFP_AdmitDept ];

/// 入院病区
Property EFPAdmitWard As %String [ SqlColumnNumber = 13, SqlFieldName = EFP_AdmitWard ];

/// 出院日期
Property EFPDischDate As %Date [ SqlColumnNumber = 14, SqlFieldName = EFP_DischDate ];

/// 出院时间
Property EFPDischTime As %Time [ SqlColumnNumber = 15, SqlFieldName = EFP_DischTime ];

/// 出院科室
Property EFPDischDept As %String [ SqlColumnNumber = 16, SqlFieldName = EFP_DischDept ];

/// 出院病区
Property EFPDischWard As %String(TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = EFP_DischWard ];

/// Creator：     zhugz
/// CreatDate：   2013-11-27
/// Description:  更新数据池中电子病历首页
/// Table：       DHCMed.DP.Meta.EmrFrontPage
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.DP.Meta.EmrFrontPage).Update("^27891^张三^12^32^1^2^3^4^5^6^7^8^9^0^1^^^^^^")
ClassMethod Update(InStr As %String, separete As %String) As %String
{

	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
	}
	
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.DP.Meta.EmrFrontPage).%New()
		} 
	else {
		set obj=##class(DHCMed.DP.Meta.EmrFrontPage).%OpenId(ID)
		}
	set obj.EFPMainID=$p(InStr,separete,2)
	set obj.EFPDataSubCat=$p(InStr,separete,3)
	set obj.EFPObjectID=$p(InStr,separete,4)
	set obj.EFPRegNo=$p(InStr,separete,5)
	set obj.EFPMedical=$p(InStr,separete,6)
	set obj.EFPName=$p(InStr,separete,7)
	set obj.EFPSex=$p(InStr,separete,8)
	set obj.EFPAge=$p(InStr,separete,9)
	set obj.EFPAdmitDate=$p(InStr,separete,10)
	set obj.EFPAdmitTime=$p(InStr,separete,11)
	set obj.EFPAdmitDept=$p(InStr,separete,12)
	set obj.EFPAdmitWard=$p(InStr,separete,13)
	set obj.EFPDischDate=$p(InStr,separete,14)
	set obj.EFPDischTime=$p(InStr,separete,15)
	set obj.EFPDischDept=$p(InStr,separete,16)
	set obj.EFPDischWard=$p(InStr,separete,17)

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
/// Description:  删除数据池中电子病历首页
/// Table：       DHCMed.DP.Meta.EmrFrontPage
/// Input：       DHCMed.DP.Meta.EmrFrontPage.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.DP.Meta.EmrFrontPage).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// Input：       DHCMed.DP.Meta.EmrFrontPage.ID
/// Return：      DHCMed.DP.Meta.EmrFrontPage
/// w ##class(DHCMed.DP.Meta.EmrFrontPage).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.DP.Meta.EmrFrontPage
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.DP.Meta.EmrFrontPage).%ExistsId(+id) return
	set obj=##Class(DHCMed.DP.Meta.EmrFrontPage).%OpenId(+id)
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
<Value>EFPMainID</Value>
</Value>
<Value name="3">
<Value>EFPDataSubCat</Value>
</Value>
<Value name="4">
<Value>EFPObjectID</Value>
</Value>
<Value name="5">
<Value>EFPRegNo</Value>
</Value>
<Value name="6">
<Value>EFPMedical</Value>
</Value>
<Value name="7">
<Value>EFPName</Value>
</Value>
<Value name="8">
<Value>EFPSex</Value>
</Value>
<Value name="9">
<Value>EFPAge</Value>
</Value>
<Value name="10">
<Value>EFPAdmitDate</Value>
</Value>
<Value name="11">
<Value>EFPAdmitTime</Value>
</Value>
<Value name="12">
<Value>EFPAdmitDept</Value>
</Value>
<Value name="13">
<Value>EFPAdmitWard</Value>
</Value>
<Value name="14">
<Value>EFPDischDate</Value>
</Value>
<Value name="15">
<Value>EFPDischTime</Value>
</Value>
<Value name="16">
<Value>EFPDischDept</Value>
</Value>
<Value name="17">
<Value>EFPDischWard</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DP.Meta.EmrFrontPageD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.DP.Meta.EmrFrontPageD</IdLocation>
<IndexLocation>^DHCMed.DP.Meta.EmrFrontPageI</IndexLocation>
<StreamLocation>^DHCMed.DP.Meta.EmrFrontPageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
