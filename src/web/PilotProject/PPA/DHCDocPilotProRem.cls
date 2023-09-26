Class web.PilotProject.PPA.DHCDocPilotProRem Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// PPR_RemAmount：汇款金额
Property PPRRemAmount As %Library.String(TRUNCATE = 1);

/// PPR_RemUser_Dr：操作人
Property PPRRemUserDr As %Library.String(TRUNCATE = 1);

/// PPR_DateAdd：加入日期
Property PPRDateAdd As %Library.String(TRUNCATE = 1);

/// PPR_TimeAdd：加入时间
Property PPRTimeAdd As %Library.String(TRUNCATE = 1);

/// PPR_Remitter：汇款人
Property PPRRemitter As %Library.String(TRUNCATE = 1);

/// PPR_Receiver：接收人
Property PPRReceiver As %Library.String(TRUNCATE = 1);

/// PPR_Date：汇款日期
Property PPRDate As %Library.String(TRUNCATE = 1);

/// PPR_Remark：备注
Property PPRRemark As %Library.String(TRUNCATE = 1);

}
