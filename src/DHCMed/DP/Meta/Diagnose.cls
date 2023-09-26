/// 名称: DHCMed.DP.Meta.Diagnose
/// 描述: 检查结果
/// 编写者：zhugz
/// 编写日期: 2013-11-27
Class DHCMed.DP.Meta.Diagnose Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 主记录ID
Property DIMainID As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = DI_MainID ];

/// 与主记录DataSubCat一致
Property DIDataSubCat As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = DI_DataSubCat ];

/// 与主记录ObjectID一致
Property DIObjectID As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = DI_ObjectID ];

/// ICD诊断代码
Property DIICDCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = DI_ICDCode ];

/// ICD诊断名称
Property DIICDDesc As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = DI_ICDDesc ];

/// 诊断备注
Property DIComments As %String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = DI_Comments ];

/// 诊断类型
Property DIDiagType As %String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = DI_DiagType ];

/// 诊断日期
Property DIDiagDate As %Date [ SqlColumnNumber = 9, SqlFieldName = DI_DiagDate ];

/// 诊断时间
Property DIDiagTime As %Time [ SqlColumnNumber = 10, SqlFieldName = DI_DiagTime ];

/// 备注
Property DIResume As %String(TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = DI_Resume ];

/// Creator：     zhugz
/// CreatDate：   2013-11-27
/// Description:  更新检查结果
/// Table：       DHCMed.DP.Meta.Diagnose
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.DP.Meta.Diagnose).Update("^2^3^ICDB12^脑炎^备注^2^63291^6752^5^6^7^8^9^0^1^^^^^^")
ClassMethod Update(InStr As %String, separete As %String) As %String
{

	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
	}
	
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.DP.Meta.Diagnose).%New()
		} 
	else {
		set obj=##class(DHCMed.DP.Meta.Diagnose).%OpenId(ID)
		}
	set obj.DIMainID=$p(InStr,separete,2)
	set obj.DIDataSubCat=$p(InStr,separete,3)
	set obj.DIObjectID=$p(InStr,separete,4)
	set obj.DIICDCode=$p(InStr,separete,5)
	set obj.DIICDDesc=$p(InStr,separete,6)
	set obj.DIComments=$p(InStr,separete,7)
	set obj.DIDiagType=$p(InStr,separete,8)
	set obj.DIDiagDate=$p(InStr,separete,9)
	set obj.DIDiagTime=$p(InStr,separete,10)
	set obj.DIResume=$p(InStr,separete,11)
	
	
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
/// Table：       DHCMed.DP.Meta.Diagnose
/// Input：       DHCMed.DP.Meta.Diagnose.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.DP.Meta.Diagnose).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// Input：       DHCMed.DP.Meta.Diagnose.ID
/// Return：      DHCMed.DP.Meta.Diagnose
/// w ##class(DHCMed.DP.Meta.Diagnose).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.DP.Meta.Diagnose
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.DP.Meta.Diagnose).%ExistsId(+id) return
	set obj=##Class(DHCMed.DP.Meta.Diagnose).%OpenId(+id)
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
<Value>DIMainID</Value>
</Value>
<Value name="3">
<Value>DIDataSubCat</Value>
</Value>
<Value name="4">
<Value>DIObjectID</Value>
</Value>
<Value name="5">
<Value>DIICDCode</Value>
</Value>
<Value name="6">
<Value>DIICDDesc</Value>
</Value>
<Value name="7">
<Value>DIComments</Value>
</Value>
<Value name="8">
<Value>DIDiagType</Value>
</Value>
<Value name="9">
<Value>DIDiagDate</Value>
</Value>
<Value name="10">
<Value>DIDiagTime</Value>
</Value>
<Value name="11">
<Value>DIResume</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DP.Meta.DiagnoseD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.DP.Meta.DiagnoseD</IdLocation>
<IndexLocation>^DHCMed.DP.Meta.DiagnoseI</IndexLocation>
<StreamLocation>^DHCMed.DP.Meta.DiagnoseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
