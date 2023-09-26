/// 名称: DHCMed.DP.Meta.ICUIntubate
/// 描述: 数据池之插管记录
/// 编写者：zhugz
/// 编写日期: 2013-11-27
Class DHCMed.DP.Meta.ICUIntubate Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 主记录ID
Property IIMainID As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = II_MainID ];

/// 与主记录DataSubCat一致
Property IIDataSubCat As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = II_DataSubCat ];

/// 与主记录ObjectID一致
Property IIObjectID As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = II_ObjectID ];

/// 项目代码
Property IIItemCode As %String [ SqlColumnNumber = 5, SqlFieldName = II_ItemCode ];

/// 项目名称
Property IIItemName As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = II_ItemName ];

/// 置管日期
Property IIIntuDate As %Date [ SqlColumnNumber = 7, SqlFieldName = II_IntuDate ];

/// 置管时间
Property IIIntuTime As %Time [ SqlColumnNumber = 8, SqlFieldName = II_IntuTime ];

/// 拔管日期
Property IIExtuDate As %Date [ SqlColumnNumber = 9, SqlFieldName = II_ExtuDate ];

/// 拔管时间
Property IIExtuTime As %Time [ SqlColumnNumber = 10, SqlFieldName = II_ExtuTime ];

/// 置管地点代码
Property IIIntuPlace As %String(TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = II_IntuPlace ];

/// 置管人员代码
Property IIIntuUser As %String [ SqlColumnNumber = 12, SqlFieldName = II_IntuUser ];

/// 导管类型(PICC)
Property IIPICCType As %String [ SqlColumnNumber = 13, SqlFieldName = II_PICCType ];

/// 导管腔数(PICC)
Property IIPICCNumber As %String(TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = II_PICCNumber ];

/// 导管部位(PICC)
Property IIPICCRegion As %String [ SqlColumnNumber = 15, SqlFieldName = II_PICCRegion ];

/// 尿袋类型(UC)
Property IIUCType As %String [ SqlColumnNumber = 16, SqlFieldName = II_UCType ];

/// 气道类型(VAP)
Property IIVAPType As %String(TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = II_VAPType ];

/// 是否新生儿
Property IIIsNewBaby As %Boolean [ SqlColumnNumber = 18, SqlFieldName = II_IsNewBaby ];

/// 新生儿体重
Property IIBabyWeight As %String [ SqlColumnNumber = 19, SqlFieldName = II_BabyWeight ];

/// 是否感染
Property IIIsInfection As %Boolean [ SqlColumnNumber = 20, SqlFieldName = II_IsInfection ];

/// 感染日期
Property IIInfDate As %Date [ SqlColumnNumber = 21, SqlFieldName = II_InfDate ];

/// 备注
Property IIResume As %String [ SqlColumnNumber = 22, SqlFieldName = II_Resume ];

/// Creator：     zhugz
/// CreatDate：   2013-11-27
/// Description:  更新插管记录
/// Table：       DHCMed.DP.Meta.ICUIntubate
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.DP.Meta.ICUIntubate).Update("^1^01^12^32^1^2^3^4^5^6^7^8^9^0^1^^^^^^")
ClassMethod Update(InStr As %String, separete As %String) As %String
{

	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
	}
	
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.DP.Meta.ICUIntubate).%New()
		} 
	else {
		set obj=##class(DHCMed.DP.Meta.ICUIntubate).%OpenId(ID)
		}
	set obj.IIMainID=$p(InStr,separete,2)
	set obj.IIDataSubCat=$p(InStr,separete,3)
	set obj.IIObjectID=$p(InStr,separete,4)
	set obj.IIItemCode=$p(InStr,separete,5)
	set obj.IIItemName=$p(InStr,separete,6)
	set obj.IIIntuDate=$p(InStr,separete,7)
	set obj.IIIntuTime=$p(InStr,separete,8)
	set obj.IIExtuDate=$p(InStr,separete,9)
	set obj.IIExtuTime=$p(InStr,separete,10)
	set obj.IIIntuPlace=$p(InStr,separete,11)
	set obj.IIIntuUser=$p(InStr,separete,12)
	set obj.IIPICCType=$p(InStr,separete,13)
	set obj.IIPICCNumber=$p(InStr,separete,14)
	set obj.IIPICCRegion=$p(InStr,separete,15)
	set obj.IIUCType=$p(InStr,separete,16)
	set obj.IIVAPType=$p(InStr,separete,17)
	set obj.IIIsNewBaby=$p(InStr,separete,18)
	set obj.IIBabyWeight=$p(InStr,separete,19)
	set obj.IIIsInfection=$p(InStr,separete,20)
	set obj.IIInfDate=$p(InStr,separete,21)
	set obj.IIResume=$p(InStr,separete,22)
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
/// Description:  删除插管记录
/// Table：       DHCMed.DP.Meta.ICUIntubate
/// Input：       DHCMed.DP.Meta.ICUIntubate.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.DP.Meta.ICUIntubate).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// Input：       DHCMed.DP.Meta.ICUIntubate.ID
/// Return：      DHCMed.DP.Meta.ICUIntubate
/// w ##class(DHCMed.DP.Meta.ICUIntubate).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.DP.Meta.ICUIntubate
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.DP.Meta.ICUIntubate).%ExistsId(+id) return
	set obj=##Class(DHCMed.DP.Meta.ICUIntubate).%OpenId(+id)
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
<Value>IIMainID</Value>
</Value>
<Value name="3">
<Value>IIDataSubCat</Value>
</Value>
<Value name="4">
<Value>IIObjectID</Value>
</Value>
<Value name="5">
<Value>IIItemCode</Value>
</Value>
<Value name="6">
<Value>IIItemName</Value>
</Value>
<Value name="7">
<Value>IIIntuDate</Value>
</Value>
<Value name="8">
<Value>IIIntuTime</Value>
</Value>
<Value name="9">
<Value>IIExtuDate</Value>
</Value>
<Value name="10">
<Value>IIExtuTime</Value>
</Value>
<Value name="11">
<Value>IIIntuPlace</Value>
</Value>
<Value name="12">
<Value>IIIntuUser</Value>
</Value>
<Value name="13">
<Value>IIPICCType</Value>
</Value>
<Value name="14">
<Value>IIPICCNumber</Value>
</Value>
<Value name="15">
<Value>IIPICCRegion</Value>
</Value>
<Value name="16">
<Value>IIUCType</Value>
</Value>
<Value name="17">
<Value>IIVAPType</Value>
</Value>
<Value name="18">
<Value>IIIsNewBaby</Value>
</Value>
<Value name="19">
<Value>IIBabyWeight</Value>
</Value>
<Value name="20">
<Value>IIIsInfection</Value>
</Value>
<Value name="21">
<Value>IIInfDate</Value>
</Value>
<Value name="22">
<Value>IIResume</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DP.Meta.ICUIntubateD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.DP.Meta.ICUIntubateD</IdLocation>
<IndexLocation>^DHCMed.DP.Meta.ICUIntubateI</IndexLocation>
<StreamLocation>^DHCMed.DP.Meta.ICUIntubateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
