/// CTOR: QP
/// DATE: 2020-09-03
/// DESC: 交班本
Class DHCDoc.PW.Model.NMain Extends %RegisteredObject
{

/// 1原有
Property PreSum As %String(TRUNCATE = 1);

/// 2现有
Property NowSum As %String(TRUNCATE = 1);

/// 3出院		
Property OutHospNum As %String(TRUNCATE = 1);

/// 4入院
Property InHospNum As %String(TRUNCATE = 1);

/// 5转出
Property OutWardNum As %String(TRUNCATE = 1);

/// 6转入
Property InWardNum As %String(TRUNCATE = 1);

/// 7手术
Property OperNum As %String(TRUNCATE = 1);

/// 8病危
Property SeverityNum As %String(TRUNCATE = 1);

/// 9病重
Property CritiNum As %String(TRUNCATE = 1);

/// 10死亡
Property DeathNum As %String(TRUNCATE = 1);

}
