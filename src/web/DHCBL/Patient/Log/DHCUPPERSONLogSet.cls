Class web.DHCBL.Patient.Log.DHCUPPERSONLogSet Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// 需要做日志的实体类名
Property ClassName As %String(TRUNCATE = 1);

/// 需要做日志的实体类字段
Property ClassProperty As %String(TRUNCATE = 1);

/// 需要做日志的实体类字段顺序
Property ClassPropertyIndex As %String(TRUNCATE = 1);

/// 需要做日志的实体类字段描述
Property ClassPropertyDescription As %String(TRUNCATE = 1);

/// 需要做日志的实体类字段值
Property ClassPropertyValue As %String(TRUNCATE = 1);

/// 需要做日志的实体类RowId值
Property ClassPropertyRowId As %String(TRUNCATE = 1);

}
