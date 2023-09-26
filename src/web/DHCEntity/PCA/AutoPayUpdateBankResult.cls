/// Creator:Lid
/// CreatDate:2012-02-07
/// Description:自助机结算完成后，HIS更新银医交易记录结果类
Class web.DHCEntity.PCA.AutoPayUpdateBankResult Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// ResultCode
Property ResultCode As %String(TRUNCATE = 1);

/// ErrorMsg
Property ErrorMsg As %String(TRUNCATE = 1);

}
