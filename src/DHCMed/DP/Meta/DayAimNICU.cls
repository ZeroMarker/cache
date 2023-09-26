/// 名称: DHCMed.DP.Meta.DayAimNICU
/// 描述: NICU患者日志
/// 编写者：zhugz
/// 编写日期: 2013-11-27
Class DHCMed.DP.Meta.DayAimNICU Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 主记录ID
Property DANMainID As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = DAN_MainID ];

/// 与主记录DataSubCat一致
Property DANDataSubCat As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = DAN_DataSubCat ];

/// 与主记录ObjectID一致
Property DANObjectID As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = DAN_ObjectID ];

/// 发生日期
Property DANActDate As %Date [ SqlColumnNumber = 5, SqlFieldName = DAN_ActDate ];

/// 科室代码
Property DANDeptCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = DAN_DeptCode ];

/// 病区代码
Property DANWardCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = DAN_WardCode ];

/// 新住院新生儿数1(入科人数)
Property DANInLocNum1 As %String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = DAN_InLocNum1 ];

/// 新住院新生儿数2
Property DANInLocNum2 As %String [ SqlColumnNumber = 9, SqlFieldName = DAN_InLocNum2 ];

/// 新住院新生儿数3
Property DANInLocNum3 As %String [ SqlColumnNumber = 10, SqlFieldName = DAN_InLocNum3 ];

/// 新住院新生儿数4
Property DANInLocNum4 As %String(TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = DAN_InLocNum4 ];

/// 已住院新生儿数1(住在人数)
Property DANAtLocNum1 As %String(TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = DAN_AtLocNum1 ];

/// 已住院新生儿数2
Property DANAtLocNum2 As %String(TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = DAN_AtLocNum2 ];

/// 已住院新生儿数3
Property DANAtLocNum3 As %String(TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = DAN_AtLocNum3 ];

/// 已住院新生儿数4
Property DANAtLocNum4 As %String(TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = DAN_AtLocNum4 ];

/// 脐\中心静脉插管人数1
Property DANPICCNum1 As %String [ SqlColumnNumber = 16, SqlFieldName = DAN_PICCNum1 ];

/// 脐\中心静脉插管人数2
Property DANPICCNum2 As %String [ SqlColumnNumber = 17, SqlFieldName = DAN_PICCNum2 ];

/// 脐\中心静脉插管人数3
Property DANPICCNum3 As %String [ SqlColumnNumber = 18, SqlFieldName = DAN_PICCNum3 ];

/// 脐\中心静脉插管人数4
Property DANPICCNum4 As %String [ SqlColumnNumber = 19, SqlFieldName = DAN_PICCNum4 ];

/// 使用呼吸机人数1
Property DANVNTNum1 As %String [ SqlColumnNumber = 20, SqlFieldName = DAN_VNTNum1 ];

/// 使用呼吸机人数2
Property DANVNTNum2 As %String [ SqlColumnNumber = 21, SqlFieldName = DAN_VNTNum2 ];

/// 使用呼吸机人数3
Property DANVNTNum3 As %String [ SqlColumnNumber = 22, SqlFieldName = DAN_VNTNum3 ];

/// 使用呼吸机人数4
Property DANVNTNum4 As %String [ SqlColumnNumber = 23, SqlFieldName = DAN_VNTNum4 ];

/// Creator：     zhugz
/// CreatDate：   2013-11-27
/// Description:  更新NICU患者日志
/// Table：       DHCMed.DP.Meta.DayAimNICU
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.DP.Meta.DayAimNICU).Update("^2^3^ICDB12^66666^备注^2^63291^6752^5^6^7^8^9^0^1^^^^^^")
ClassMethod Update(InStr As %String, separete As %String) As %String
{

	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
	}
	
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.DP.Meta.DayAimNICU).%New()
		} 
	else {
		set obj=##class(DHCMed.DP.Meta.DayAimNICU).%OpenId(ID)
		}
	set obj.DANMainID=$p(InStr,separete,2)
	set obj.DANDataSubCat=$p(InStr,separete,3)
	set obj.DANObjectID=$p(InStr,separete,4)
	set obj.DANActDate=$p(InStr,separete,5)
	set obj.DANDeptCode=$p(InStr,separete,6)
	set obj.DANWardCode=$p(InStr,separete,7)
	set obj.DANInLocNum1=$p(InStr,separete,8)
	set obj.DANInLocNum2=$p(InStr,separete,9)
	set obj.DANInLocNum3=$p(InStr,separete,10)
	set obj.DANInLocNum4=$p(InStr,separete,11)
	set obj.DANAtLocNum1=$p(InStr,separete,12)
	set obj.DANAtLocNum2=$p(InStr,separete,13)
	set obj.DANAtLocNum3=$p(InStr,separete,14)
	set obj.DANAtLocNum4=$p(InStr,separete,15)
	set obj.DANPICCNum1=$p(InStr,separete,16)
	set obj.DANPICCNum2=$p(InStr,separete,17)
	set obj.DANPICCNum3=$p(InStr,separete,18)
	set obj.DANPICCNum4=$p(InStr,separete,19)
	set obj.DANVNTNum1=$p(InStr,separete,20)
	set obj.DANVNTNum2=$p(InStr,separete,21)
	set obj.DANVNTNum3=$p(InStr,separete,22)
	set obj.DANVNTNum4=$p(InStr,separete,23)
	
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
/// Description:  删除NICU患者日志
/// Table：       DHCMed.DP.Meta.DayAimNICU
/// Input：       DHCMed.DP.Meta.DayAimNICU.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.DP.Meta.DayAimNICU).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// Input：       DHCMed.DP.Meta.DayAimNICU.ID
/// Return：      DHCMed.DP.Meta.DayAimNICU
/// w ##class(DHCMed.DP.Meta.DayAimNICU).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.DP.Meta.DayAimNICU
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.DP.Meta.DayAimNICU).%ExistsId(+id) return
	set obj=##Class(DHCMed.DP.Meta.DayAimNICU).%OpenId(+id)
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
<Value>DANMainID</Value>
</Value>
<Value name="3">
<Value>DANDataSubCat</Value>
</Value>
<Value name="4">
<Value>DANObjectID</Value>
</Value>
<Value name="5">
<Value>DANActDate</Value>
</Value>
<Value name="6">
<Value>DANDeptCode</Value>
</Value>
<Value name="7">
<Value>DANWardCode</Value>
</Value>
<Value name="8">
<Value>DANInLocNum1</Value>
</Value>
<Value name="9">
<Value>DANInLocNum2</Value>
</Value>
<Value name="10">
<Value>DANInLocNum3</Value>
</Value>
<Value name="11">
<Value>DANInLocNum4</Value>
</Value>
<Value name="12">
<Value>DANAtLocNum1</Value>
</Value>
<Value name="13">
<Value>DANAtLocNum2</Value>
</Value>
<Value name="14">
<Value>DANAtLocNum3</Value>
</Value>
<Value name="15">
<Value>DANAtLocNum4</Value>
</Value>
<Value name="16">
<Value>DANPICCNum1</Value>
</Value>
<Value name="17">
<Value>DANPICCNum2</Value>
</Value>
<Value name="18">
<Value>DANPICCNum3</Value>
</Value>
<Value name="19">
<Value>DANPICCNum4</Value>
</Value>
<Value name="20">
<Value>DANVNTNum1</Value>
</Value>
<Value name="21">
<Value>DANVNTNum2</Value>
</Value>
<Value name="22">
<Value>DANVNTNum3</Value>
</Value>
<Value name="23">
<Value>DANVNTNum4</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DP.Meta.DayAimNICUD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.DP.Meta.DayAimNICUD</IdLocation>
<IndexLocation>^DHCMed.DP.Meta.DayAimNICUI</IndexLocation>
<StreamLocation>^DHCMed.DP.Meta.DayAimNICUS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
