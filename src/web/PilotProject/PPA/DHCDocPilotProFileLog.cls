Class web.PilotProject.PPA.DHCDocPilotProFileLog Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// 项目代码
Property LogRowID As %Library.String(TRUNCATE = 1);

/// 项目代码
Property PPCode As %Library.String(TRUNCATE = 1);

/// 项目名称
Property PPDesc As %Library.String(TRUNCATE = 1);

/// 小结日期
Property BriefDate As %Library.String(TRUNCATE = 1);

/// 关中心日期
Property CenterDate As %Library.String(TRUNCATE = 1);

/// 总结日期
Property SumDate As %Library.String(TRUNCATE = 1);

/// PPS_UpdateUser_Dr
Property PPSUpdateUserDr As %Library.String(TRUNCATE = 1);

/// PPS_UpdateDate
Property PPSUpdateDate As %Library.String(TRUNCATE = 1);

/// PPS_UpdateTime
Property PPSUpdateTime As %Library.String(TRUNCATE = 1);

/// PPS_Rowid
Property PPSRowID As %Library.String(TRUNCATE = 1);

}
