Class User.DHCMRCClinPathWaysBLITM Extends %Library.SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 序号
Property ITMNo As %Float;

/// 基础关联项
Property ITMBLItmDR As User.DHCMRCBaseLinkItemDic;

/// 分组编号
Property ITMGroupNo As %Float;

/// 是否有效
Property ITMIsActive As %String(DISPLAYLIST = ",Yes,No", MINLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N");

/// 修改人
Property ITMUpdateUser As %String(TRUNCATE = 1);

/// 修改日期
Property ITMUpdateDate As %String(TRUNCATE = 1);

/// 修改时间
Property ITMUpdateTime As %String(TRUNCATE = 1);

ClassMethod Insert()
{
	//##Class(User.DHCMRCClinPathWaysBLITM).Insert()
	s obj=##class(User.DHCMRCClinPathWaysEpStepItem).%OpenId("2||1||1||2")
	s obj1=##class(User.DHCMRCClinPathWaysBLITM).%New()
	s obj1.ITMBLItmDR="2"
	d obj.CPWSIARCIM.Insert(obj1)
	d obj.%Save()
}

Storage Default
{
<Data name="DHCMRCClinPathWaysBLITMState">
<Value name="1">
<Value>ITMNo</Value>
</Value>
<Value name="2">
<Value>ITMBLItmDR</Value>
</Value>
<Value name="3">
<Value>ITMGroupNo</Value>
</Value>
<Value name="4">
<Value>ITMIsActive</Value>
</Value>
<Value name="5">
<Value>ITMUpdateDate</Value>
</Value>
<Value name="6">
<Value>ITMUpdateTime</Value>
</Value>
<Value name="7">
<Value>ITMUpdateUser</Value>
</Value>
</Data>
<State>DHCMRCClinPathWaysBLITMState</State>
<StreamLocation>^User.DHCMRCClinPathWaysBLITMS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
