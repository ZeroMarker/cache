/// 病案收费子表
Class DHCWMR.MF.FeeRecordDtl Extends (%Persistent, DHCWMR.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCWMR.MF.FeeRecord [ Cardinality = parent, Inverse = ChildDTL ];

/// HIS收费项(指向DHC_TarItem)
Property FRDTarItemDr As %String(MAXLEN = 100, TRUNCATE = 1);

/// 总金额
Property FRDMoney As %String(MAXLEN = 100, TRUNCATE = 1);

/// 数量
Property FRDNumber As %String(MAXLEN = 100, TRUNCATE = 1);

/// Creator:          zhufei
/// CreateDate:       2015-10-11
/// Description:      根据ID取病案收费子项
/// OperationTable:   DHCWMR.MF.FeeRecordDtl
/// Input:            Id : DHCWMR.MF.FeeRecordDtl.ID
/// Output:           返回Object
/// w ##Class(DHCWMR.MF.FeeRecordDtl).GetObjById(21)
ClassMethod GetObjById(aId As %String) As DHCWMR.MF.FeeRecordDtl
{
	new (aId)
	quit:'##class(DHCWMR.MF.FeeRecordDtl).%ExistsId(aId) ""
	set obj=##Class(DHCWMR.MF.FeeRecordDtl).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator:      zhufei
/// CreateDate:   2015-10-11
/// Description:  更新病案收费子项
/// Table：       DHCWMR.MF.FeeRecordDtl
/// Input：       InputStr : Parref^ChildSub^TarItemDr^Money^Number
///               Separate ：分隔符
/// Return：      返回新纪录的%Id()值
/// w ##class(DHCWMR.MF.FeeRecordDtl).Update("","")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set Parref=$p(aInputStr,aSeparate,1)
	Set ChildSub=$p(aInputStr,aSeparate,2)
	Set TarItemDr=$p(aInputStr,aSeparate,3)
	Set Money=+$p(aInputStr,aSeparate,4)
	Set Number=+$p(aInputStr,aSeparate,5)
	Quit:(Parref="") return
	
	Set objParref=##class(DHCWMR.MF.FeeRecord).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	
	If ChildSub="" {
		Set obj=##class(DHCWMR.MF.FeeRecordDtl).%New()
	} Else {
		Set obj=##class(DHCWMR.MF.FeeRecordDtl).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref	  		= objParref
	Set obj.FRDTarItemDr	= TarItemDr
	Set obj.FRDMoney		= Money
	Set obj.FRDNumber		= Number
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}	
	Quit return
}

/// Creator:      zhufei
/// CreateDate:   2015-10-11
/// Description:  删除病案收费子项
/// Table：       DHCWMR.MF.FeeRecordDtl
/// Input：       Id : DHCWMR.MF.FeeRecordDtl.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(DHCWMR.MF.FeeRecordDtl).%DeleteId(aId)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc)
   		set return=-1
	}else{
		set return=1
	}
	quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FRDTarItemDr</Value>
</Value>
<Value name="3">
<Value>FRDMoney</Value>
</Value>
<Value name="4">
<Value>FRDNumber</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("DTL")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("DTL")</IdLocation>
<IndexLocation>^DHCWMR.MF.FeeRecordI("DTL")</IndexLocation>
<StreamLocation>^DHCWMR.MF.FeeRecordDtlS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
