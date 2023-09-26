/// 名称: DHCMed.DP.Meta.DayAdmTrans
/// 描述: 出入转汇总
/// 编写者：zhugz
/// 编写日期: 2013-11-27
Class DHCMed.DP.Meta.DayAdmTrans Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 主记录ID
Property DATMainID As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = DAT_MainID ];

/// 与主记录DataSubCat一致
Property DATDataSubCat As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = DAT_DataSubCat ];

/// 与主记录ObjectID一致
Property DATObjectID As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = DAT_ObjectID ];

/// 发生日期
Property DATActDate As %Date [ SqlColumnNumber = 5, SqlFieldName = DAT_ActDate ];

/// 科室代码
Property DATDeptCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = DAT_DeptCode ];

/// 病区代码
Property DATWardCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = DAT_WardCode ];

/// 入院人数
Property DATInHospNum As %String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = DAT_InHospNum ];

/// 出院人数
Property DATOutHospNum As %String [ SqlColumnNumber = 9, SqlFieldName = DAT_OutHospNum ];

/// 入科人数
Property DATInLocNum As %String [ SqlColumnNumber = 10, SqlFieldName = DAT_InLocNum ];

/// 出科人数
Property DATOutLocNum As %String(TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = DAT_OutLocNum ];

/// 住在人数
Property DATAdmLocNum As %String(TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = DAT_AdmLocNum ];

/// Creator：     zhugz
/// CreatDate：   2013-11-27
/// Description:  更新出入转汇总
/// Table：       DHCMed.DP.Meta.DayAdmTrans
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.DP.Meta.DayAdmTrans).Update("^2^3^ICDB12^66666^备注^2^63291^6752^5^6^7^8^9^0^1^^^^^^")
ClassMethod Update(InStr As %String, separete As %String) As %String
{

	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
	}
	
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.DP.Meta.DayAdmTrans).%New()
		} 
	else {
		set obj=##class(DHCMed.DP.Meta.DayAdmTrans).%OpenId(ID)
		}
	set obj.DATMainID=$p(InStr,separete,2)
	set obj.DATDataSubCat=$p(InStr,separete,3)
	set obj.DATObjectID=$p(InStr,separete,4)
	set obj.DATActDate=$p(InStr,separete,5)
	set obj.DATDeptCode=$p(InStr,separete,6)
	set obj.DATWardCode=$p(InStr,separete,7)
	set obj.DATInHospNum=$p(InStr,separete,8)
	set obj.DATOutHospNum=$p(InStr,separete,9)
	set obj.DATInLocNum=$p(InStr,separete,10)
	set obj.DATOutLocNum=$p(InStr,separete,11)
	set obj.DATAdmLocNum=$p(InStr,separete,12)
	
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
/// Description:  删除出入转汇总
/// Table：       DHCMed.DP.Meta.DayAdmTrans
/// Input：       DHCMed.DP.Meta.DayAdmTrans.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.DP.Meta.DayAdmTrans).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// Input：       DHCMed.DP.Meta.DayAdmTrans.ID
/// Return：      DHCMed.DP.Meta.DayAdmTrans
/// w ##class(DHCMed.DP.Meta.DayAdmTrans).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.DP.Meta.DayAdmTrans
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.DP.Meta.DayAdmTrans).%ExistsId(+id) return
	set obj=##Class(DHCMed.DP.Meta.DayAdmTrans).%OpenId(+id)
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
<Value>DATMainID</Value>
</Value>
<Value name="3">
<Value>DATDataSubCat</Value>
</Value>
<Value name="4">
<Value>DATObjectID</Value>
</Value>
<Value name="5">
<Value>DATActDate</Value>
</Value>
<Value name="6">
<Value>DATDeptCode</Value>
</Value>
<Value name="7">
<Value>DATWardCode</Value>
</Value>
<Value name="8">
<Value>DATInHospNum</Value>
</Value>
<Value name="9">
<Value>DATOutHospNum</Value>
</Value>
<Value name="10">
<Value>DATInLocNum</Value>
</Value>
<Value name="11">
<Value>DATOutLocNum</Value>
</Value>
<Value name="12">
<Value>DATAdmLocNum</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DP.Meta.DayAdmTransD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.DP.Meta.DayAdmTransD</IdLocation>
<IndexLocation>^DHCMed.DP.Meta.DayAdmTransI</IndexLocation>
<StreamLocation>^DHCMed.DP.Meta.DayAdmTransS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
