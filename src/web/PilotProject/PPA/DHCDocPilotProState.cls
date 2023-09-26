Class web.PilotProject.PPA.DHCDocPilotProState Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// PPS_PP_ParRef
Property PPSPPParRef As %Library.String(TRUNCATE = 1);

/// PPS_CurState
Property PPSCurState As %Library.String(TRUNCATE = 1);

/// PPS_UpdateUser_Dr
Property PPSUpdateUserDr As %Library.String(TRUNCATE = 1);

/// PPS_UpdateDate
Property PPSUpdateDate As %Library.String(TRUNCATE = 1);

/// PPS_UpdateTime
Property PPSUpdateTime As %Library.String(TRUNCATE = 1);

/// PPS_Remark
Property PPSRemark As %Library.String(TRUNCATE = 1);

/// PPS_UpdateReason
Property PPSUpdateReason As %Library.String(TRUNCATE = 1);

/// PPS_AuthUser_Dr
Property PPSAuthUserDr As %Library.String(TRUNCATE = 1);

}
