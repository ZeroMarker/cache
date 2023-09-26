Class CHSS.PersonHISInfoXml Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// XML格式：<Request><Name></Name><Sex></Sex><Birth></Birth><CredType></CredType><CredNo></CredNo><Address></Address><TelHome></TelHome><PatType></PatType><CardType></CardType><CardNo></CardNo><UserDR></UserDR></Request>
/// Property PersonInfoXML As %String(TRUNCATE = 1);
/// 卡号
Property CardNumber As %String(TRUNCATE = 1);

/// 姓名
Property PersonName As %String(MAXLEN = 60, TRUNCATE = 1) [ Required ];

/// 性别
Property SexDR As %String(TRUNCATE = 1);

/// 出生日期yyyy-MM-dd
Property Birth As %String(TRUNCATE = 1);

/// 证件类别
Property IDCardTypeDR As %String(TRUNCATE = 1);

/// 身份证号
Property IDCard As %String(MAXLEN = 30, TRUNCATE = 1);

/// 地址
Property Address As %String(MAXLEN = 100, TRUNCATE = 1);

/// 联系人电话
Property LinkManPhone As %String(MAXLEN = 30, TRUNCATE = 1);

}
