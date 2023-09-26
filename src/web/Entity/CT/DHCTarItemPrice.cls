/// 名称:收费项价格
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期:2015-07-25
Class web.Entity.CT.DHCTarItemPrice Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

//^DHCTARI 

Parameter PersistentClassName = "web.Entity.CT.DHCTarItemPrice";

Property TPRowId As %String;

Property TPTARIParRef As %String;

/// TP_ChildSub
Property TPChildSub As %String;

/// TP_StartDate
Property TPStartDate As %String;

/// TP_EndDate
Property TPEndDate As %String;

/// TP_Price
Property TPPrice As %String;

/// TP_LimitedPrice
Property TPLimitedPrice As %String;

/// TP_PayorRate
Property TPPayorRate As %String;

/// TP_UpdateUser
Property TPUpdateUser As %String;

/// TP_UpdateDate
Property TPUpdateDate As %String;

/// TP_UpdateTime
Property TPUpdateTime As %String;

/// TP_AdjustNo
Property TPAdjustNo As %String;

/// TP_DiscRate
Property TPDiscRate As %String;

/// TP_PatInsType
Property TPPatInsType As %String;

/// TP_AlterPrice1
Property TPAlterPrice1 As %String;

/// TP_AlterPrice2
Property TPAlterPrice2 As %String;

/// TP_Hospital_DR
Property TPHospitalDR As %String;

/// 备注  20170814
Property TPNoteText As %String;

}
