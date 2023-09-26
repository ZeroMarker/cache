Class EPRservice.entity.EPowerUser Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

/// stores the ChildUsers or UserGroups belong to the user
Property ChildUsers As %String(MAXLEN = 20000, TRUNCATE = 1);

/// if the ChildUsers column stores the UserGroups belong to the user, 
/// for convenience of priveledge configuration and control
Property ControlByGroup As %Boolean;

Property IsValid As %Boolean;

//RowID of SS_GROUP of Trak

Property SSGroupID As %String(TRUNCATE = 1);

/// 用户ID(=TrakID)
Property UserID As %String(TRUNCATE = 1);

}
