/// 名称: DHCMed.DP.Meta.DayAimICU
/// 描述: ICU患者日志
/// 编写者：zhugz
/// 编写日期: 2013-11-27
Class DHCMed.DP.Meta.DayAimICU Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 主记录ID
Property DAIMainID As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = DAI_MainID ];

/// 与主记录DataSubCat一致
Property DAIDataSubCat As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = DAI_DataSubCat ];

/// 与主记录ObjectID一致
Property DAIObjectID As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = DAI_ObjectID ];

/// 发生日期
Property DAIActDate As %Date [ SqlColumnNumber = 5, SqlFieldName = DAI_ActDate ];

/// 科室代码
Property DAIDeptCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = DAI_DeptCode ];

/// 病区代码
Property DAIWardCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = DAI_WardCode ];

/// 入科人数
Property DAIInLocNum As %String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = DAI_InLocNum ];

/// 住在人数
Property DAIAtLocNum As %String [ SqlColumnNumber = 9, SqlFieldName = DAI_AtLocNum ];

/// 使用呼吸机人数
Property DAIVAPNum As %String [ SqlColumnNumber = 10, SqlFieldName = DAI_VAPNum ];

/// 导尿管插管人数
Property DAIUCNum As %String(TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = DAI_UCNum ];

/// 中心静脉插管人数
Property DAIPICCNum As %String(TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = DAI_PICCNum ];

/// Creator：     zhugz
/// CreatDate：   2013-11-27
/// Description:  更新ICU患者日志
/// Table：       DHCMed.DP.Meta.DayAimICU
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.DP.Meta.DayAimICU).Update("^2^3^ICDB12^66666^备注^2^63291^6752^5^6^7^8^9^0^1^^^^^^")
ClassMethod Update(InStr As %String, separete As %String) As %String
{

	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
	}
	
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.DP.Meta.DayAimICU).%New()
		} 
	else {
		set obj=##class(DHCMed.DP.Meta.DayAimICU).%OpenId(ID)
		}
	set obj.DAIMainID=$p(InStr,separete,2)
	set obj.DAIDataSubCat=$p(InStr,separete,3)
	set obj.DAIObjectID=$p(InStr,separete,4)
	set obj.DAIActDate=$p(InStr,separete,5)
	set obj.DAIDeptCode=$p(InStr,separete,6)
	set obj.DAIWardCode=$p(InStr,separete,7)
	set obj.DAIInLocNum=$p(InStr,separete,8)
	set obj.DAIAtLocNum=$p(InStr,separete,9)
	set obj.DAIVAPNum=$p(InStr,separete,10)
	set obj.DAIUCNum=$p(InStr,separete,11)
	set obj.DAIPICCNum=$p(InStr,separete,12)
	
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
/// Description:  删除ICU患者日志
/// Table：       DHCMed.DP.Meta.DayAimICU
/// Input：       DHCMed.DP.Meta.DayAimICU.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.DP.Meta.DayAimICU).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// Input：       DHCMed.DP.Meta.DayAimICU.ID
/// Return：      DHCMed.DP.Meta.DayAimICU
/// w ##class(DHCMed.DP.Meta.DayAimICU).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.DP.Meta.DayAimICU
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.DP.Meta.DayAimICU).%ExistsId(+id) return
	set obj=##Class(DHCMed.DP.Meta.DayAimICU).%OpenId(+id)
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
<Value>DAIMainID</Value>
</Value>
<Value name="3">
<Value>DAIDataSubCat</Value>
</Value>
<Value name="4">
<Value>DAIObjectID</Value>
</Value>
<Value name="5">
<Value>DAIActDate</Value>
</Value>
<Value name="6">
<Value>DAIDeptCode</Value>
</Value>
<Value name="7">
<Value>DAIWardCode</Value>
</Value>
<Value name="8">
<Value>DAIInLocNum</Value>
</Value>
<Value name="9">
<Value>DAIAtLocNum</Value>
</Value>
<Value name="10">
<Value>DAIVAPNum</Value>
</Value>
<Value name="11">
<Value>DAIUCNum</Value>
</Value>
<Value name="12">
<Value>DAIPICCNum</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DP.Meta.DayAimICUD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.DP.Meta.DayAimICUD</IdLocation>
<IndexLocation>^DHCMed.DP.Meta.DayAimICUI</IndexLocation>
<StreamLocation>^DHCMed.DP.Meta.DayAimICUS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
