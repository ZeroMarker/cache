/// 名称: DHCMed.DP.Meta.OEItem
/// 描述: 数据池之医嘱记录
/// 编写者：zhugz
/// 编写日期: 2013-11-27
Class DHCMed.DP.Meta.OEItem Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 主记录ID
Property OEMainID As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = OE_MainID ];

/// 与主记录DataSubCat一致
Property OEDataSubCat As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = OE_DataSubCat ];

/// 与主记录ObjectID一致
Property OEObjectID As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = OE_ObjectID ];

/// 医嘱项代码
Property OEArcimCode As %String [ SqlColumnNumber = 5, SqlFieldName = OE_ArcimCode ];

/// 医嘱项名称
Property OEArcimDesc As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = OE_ArcimDesc ];

/// 医嘱类型
Property OEPriority As %String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = OE_Priority ];

/// 开始日期
Property OESttDate As %Date [ SqlColumnNumber = 8, SqlFieldName = OE_SttDate ];

/// 开始时间
Property OESttTime As %Time [ SqlColumnNumber = 9, SqlFieldName = OE_SttTime ];

/// 停止日期
Property OEXDate As %Date [ SqlColumnNumber = 10, SqlFieldName = OE_XDate ];

/// 停止时间
Property OEXTime As %Time [ SqlColumnNumber = 11, SqlFieldName = OE_XTime ];

/// 开医嘱科室
Property OEOrdDept As %String [ SqlColumnNumber = 12, SqlFieldName = OE_OrdDept ];

/// 开医嘱医生
Property OEOrdDoc As %String [ SqlColumnNumber = 13, SqlFieldName = OE_OrdDoc ];

/// 接收科室
Property OERecDept As %String(TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = OE_RecDept ];

/// 剂量
Property OEDoseQty As %String [ SqlColumnNumber = 15, SqlFieldName = OE_DoseQty ];

/// 剂量单位
Property OEDoseUom As %String [ SqlColumnNumber = 16, SqlFieldName = OE_DoseUom ];

/// 频次
Property OEPHFreq As %String(TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = OE_PHFreq ];

/// 用法
Property OEInstruc As %String [ SqlColumnNumber = 18, SqlFieldName = OE_Instruc ];

/// 管制分类(抗生素)
Property OEPoison As %String [ SqlColumnNumber = 19, SqlFieldName = OE_Poison ];

/// 用药目的(抗生素)
Property OEPurpose As %String [ SqlColumnNumber = 20, SqlFieldName = OE_Purpose ];

/// 是否送检(抗生素)
Property OEIsSubmis As %Boolean [ SqlColumnNumber = 21, SqlFieldName = OE_IsSubmis ];

/// 备注
Property OEResume As %String [ SqlColumnNumber = 22, SqlFieldName = OE_Resume ];

/// Creator：     zhugz
/// CreatDate：   2013-11-27
/// Description:  更新数据池医嘱记录
/// Table：       DHCMed.DP.Meta.OEItem
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.DP.Meta.OEItem).Update("^27891^张三^12^32^1^2^3^4^5^6^7^8^9^0^1^^^^^^")
ClassMethod Update(InStr As %String, separete As %String) As %String
{

	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
	}
	
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.DP.Meta.OEItem).%New()
		} 
	else {
		set obj=##class(DHCMed.DP.Meta.OEItem).%OpenId(ID)
		}
	set obj.OEMainID=$p(InStr,separete,2)
	set obj.OEDataSubCat=$p(InStr,separete,3)
	set obj.OEObjectID=$p(InStr,separete,4)
	set obj.OEArcimCode=$p(InStr,separete,5)
	set obj.OEArcimDesc=$p(InStr,separete,6)
	set obj.OEPriority=$p(InStr,separete,7)
	set obj.OESttDate=$p(InStr,separete,8)
	set obj.OESttTime=$p(InStr,separete,9)
	set obj.OEXDate=$p(InStr,separete,10)
	set obj.OEXTime=$p(InStr,separete,11)
	set obj.OEOrdDept=$p(InStr,separete,12)
	set obj.OEOrdDoc=$p(InStr,separete,13)
	set obj.OERecDept=$p(InStr,separete,14)
	set obj.OEDoseQty=$p(InStr,separete,15)
	set obj.OEDoseUom=$p(InStr,separete,16)
	set obj.OEPHFreq=$p(InStr,separete,17)
	set obj.OEInstruc=$p(InStr,separete,18)
	set obj.OEPoison=$p(InStr,separete,19)
	set obj.OEPurpose=$p(InStr,separete,20)
	set obj.OEIsSubmis=$p(InStr,separete,21)
	set obj.OEResume=$p(InStr,separete,22)
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
/// Description:  删除数据池医嘱记录
/// Table：       DHCMed.DP.Meta.OEItem
/// Input：       DHCMed.DP.Meta.OEItem.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.DP.Meta.OEItem).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// Input：       DHCMed.DP.Meta.OEItem.ID
/// Return：      DHCMed.DP.Meta.OEItem
/// w ##class(DHCMed.DP.Meta.OEItem).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.DP.Meta.OEItem
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.DP.Meta.OEItem).%ExistsId(+id) return
	set obj=##Class(DHCMed.DP.Meta.OEItem).%OpenId(+id)
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
<Value>OEMainID</Value>
</Value>
<Value name="3">
<Value>OEDataSubCat</Value>
</Value>
<Value name="4">
<Value>OEObjectID</Value>
</Value>
<Value name="5">
<Value>OEArcimCode</Value>
</Value>
<Value name="6">
<Value>OEArcimDesc</Value>
</Value>
<Value name="7">
<Value>OEPriority</Value>
</Value>
<Value name="8">
<Value>OESttDate</Value>
</Value>
<Value name="9">
<Value>OESttTime</Value>
</Value>
<Value name="10">
<Value>OEXDate</Value>
</Value>
<Value name="11">
<Value>OEXTime</Value>
</Value>
<Value name="12">
<Value>OEOrdDept</Value>
</Value>
<Value name="13">
<Value>OEOrdDoc</Value>
</Value>
<Value name="14">
<Value>OERecDept</Value>
</Value>
<Value name="15">
<Value>OEDoseQty</Value>
</Value>
<Value name="16">
<Value>OEDoseUom</Value>
</Value>
<Value name="17">
<Value>OEPHFreq</Value>
</Value>
<Value name="18">
<Value>OEInstruc</Value>
</Value>
<Value name="19">
<Value>OEPoison</Value>
</Value>
<Value name="20">
<Value>OEPurpose</Value>
</Value>
<Value name="21">
<Value>OEIsSubmis</Value>
</Value>
<Value name="22">
<Value>OEResume</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DP.Meta.OEItemD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.DP.Meta.OEItemD</IdLocation>
<IndexLocation>^DHCMed.DP.Meta.OEItemI</IndexLocation>
<StreamLocation>^DHCMed.DP.Meta.OEItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
