Class EMRservice.entity.EPowerUser Extends (%Library.RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// stores the ChildUsers or UserGroups belong to the user
Property ChildUsers As %String(MAXLEN = 20000, TRUNCATE = 1);

/// if the ChildUsers column stores the UserGroups belong to the user, 
/// for convenience of priveledge configuration and control
Property ControlByGroup As %String(TRUNCATE = 1);

Property IsValid As %String(TRUNCATE = 1);

/// RowID of SS_GROUP of Trak
Property SSGroupID As %String(TRUNCATE = 1);

/// 用户ID(=TrakID)
Property UserID As %String(TRUNCATE = 1);

/// object ID
Property ID As %String(TRUNCATE = 1);

Property UserLevel As %String(TRUNCATE = 1);

/// 大同增加
Property UserPos As %String(TRUNCATE = 1);

/// useriD和groupID
Property SubUserIDGroupID As %String(MAXLEN = 20000, TRUNCATE = 1);

}
