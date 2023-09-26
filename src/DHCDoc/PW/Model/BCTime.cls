/// CTOR: QP
/// DATE: 2020-09-03
/// DESC: 交班本配置模型
Class DHCDoc.PW.Model.BCTime Extends DHCDoc.Util.RegisteredObject
{

/// 班次代码
Property BCCode As %String;

/// 班次名称
Property BCName As %String;

/// 开始时间
Property BCSTime As %String;

/// 结束时间
Property BCETime As %String;

/// 是否跨日
Property BCIsNextDay As %String;

/// 备注
Property BCNote As %String;

/// 是否激活
Property BCActive As %String;

/// 第几班
Property BCSeqno As %String;

/// w ##class(DHCDoc.PW.Model.BCTime).GetInfo(1)
ClassMethod GetInfo(id) As DHCDoc.PW.Model.BCTime
{
	S MObj=##class(DHCDoc.PW.Model.BCTime).%New()
	Q:id="" MObj
	S DObj=##class(User.DHCDocPassWorkBCTime).%OpenId(id)
	I '$ISObject(DObj) {
		Q MObj
	}
	S MObj.BCActive=DObj.BCActive
	S MObj.BCCode=DObj.BCCode
	S MObj.BCETime=DObj.BCETime
	S MObj.BCIsNextDay=DObj.BCIsNextDay
	S MObj.BCName=DObj.BCName
	S MObj.BCNote=DObj.BCNote
	S MObj.BCSeqno=DObj.BCSeqno
	S MObj.BCSTime=DObj.BCSTime
	i MObj.BCETime'="" s MObj.BCETime=..%ZT(MObj.BCETime,2)
	i MObj.BCSTime'="" s MObj.BCSTime=..%ZT(MObj.BCSTime,2)
	
	Q MObj
}

}
