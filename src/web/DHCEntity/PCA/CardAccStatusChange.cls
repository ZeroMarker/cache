Class web.DHCEntity.PCA.CardAccStatusChange Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// 帐户Rowid
Property AccountID As %String(TRUNCATE = 1);

/// 帐户旧状态
Property OldStatus As %String(TRUNCATE = 1);

/// 帐户新状态
Property NewStatus As %String(TRUNCATE = 1);

/// 帐户Left
Property Left As %String(TRUNCATE = 1);

/// 操作日期
Property OperDate As %Date;

/// 操作时间
Property OperTime As %Time;

/// 操作员Rowid
Property UserDR As %String(TRUNCATE = 1);

/// 申请人姓名
Property RLName As %String(TRUNCATE = 1);

/// 申请人证件号
Property RLCredNo As %String(TRUNCATE = 1);

/// 申请人地址
Property RLAddress As %String(TRUNCATE = 1);

/// 申请人电话号码
Property RLPhoneNo As %String(TRUNCATE = 1);

/// 单据号
Property RLProof As %String(TRUNCATE = 1);

/// 备注
Property RLRemark As %String(TRUNCATE = 1);

/// 申请人证件类型
Property CredType As %String(TRUNCATE = 1);

/// IP
Property ComputerID As %String(TRUNCATE = 1);

}
