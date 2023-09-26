Class DHCCPMWeb.CPMSevice.entity.DHCEReportsVersion Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Property ParRef As %String(TRUNCATE = 1);

Property RVAuthor As %String(TRUNCATE = 1);

Property RVCreateDate As %Date;

Property RVCreateTime As %Time;

Property RVData As %GlobalCharacterStream(LOCATION = "^CacheTempEReportVerData($j)");

Property RVPublicationDate As %Date;

Property RVPublicationTime As %Time;

Property RVStatus As %Integer;

Property RVVersionNumber As %Integer;

Property RVXMLSchemaFile As %GlobalCharacterStream(LOCATION = "^CacheTempEReportVerXMLSchemalF($j)");

/// ///ID的值,可以用来判定是否保存
Property RowID As %String(TRUNCATE = 1);

}
