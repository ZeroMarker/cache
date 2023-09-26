Class DHCCPMWeb.CPMSevice.entity.DHCEReports Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Property ComponentName As %String(TRUNCATE = 1);

Property RepDescription As %String(TRUNCATE = 1);

Property ComponentDR As %String(TRUNCATE = 1);

Property DateFrom As %Date;

Property RepCaption As %String(TRUNCATE = 1);

Property DateTo As %Date;

Property RepName As %String(TRUNCATE = 1);

Property LastVersion As %String(TRUNCATE = 1);

Property PublishVersion As %String(TRUNCATE = 1);

Property RepCategoryDR As %String(TRUNCATE = 1);

/// 转化为一个List对象列表
Property RepPanels As list Of DHCERepPanels;

/// 单独保存为一个 报表模版对象
Property ReportsVersion As DHCEReportsVersion;

Property RowID As %String(TRUNCATE = 1);

Property XMLSchemaFile As %GlobalCharacterStream(LOCATION = "^CacheTempEReportsXMLSchemaFile($j)");

}
