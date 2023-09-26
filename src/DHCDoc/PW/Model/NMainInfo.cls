/// CTOR: QP
/// DATE: 2021-07-14
/// DESC: 交班本主界面信息
Class DHCDoc.PW.Model.NMainInfo Extends DHCDoc.Util.RegisteredObject
{

/// 接班备注
Property AcceptNote As %String;

/// 交班备注
Property SubmitNote As %String;

/// 交班人
Property SubmitUser As %String;

/// 接班人
Property AcceptUser As %String;

/// 交班人ID
Property SubmitUserID As %String;

/// 接班人ID
Property AcceptUserID As %String;

/// 保存人ID
Property AddUserID As %String;

/// 保存人
Property AddUser As %String;

/// 开始时间
Property STime As %String;

/// 结束时间
Property ETime As %String;

/// 跨日标志
Property NextDay As %String;

/// W ##class(DHCDoc.PW.Model.NMainInfo).GetInfo(1)
ClassMethod GetInfo(id) As DHCDoc.PW.Model.BCMain
{
	S MObj=##class(DHCDoc.PW.Model.NMainInfo).%New()
	Q:id="" MObj
	S DObj=##class(User.DHCDocPassWorkNMain).%OpenId(id)
	I '$ISObject(DObj) {
		Q MObj
	}
	s langid=..%LanguageID()
	S MObj.AcceptNote=DObj.MAccpetNote
	S MObj.SubmitNote=DObj.MSubmitNote
	S MObj.AddUserID=DObj.MAddUserGetObjectId()
	S MObj.AcceptUserID=DObj.MAcceptUserGetObjectId()
	S MObj.SubmitUserID=DObj.MSubmitUserGetObjectId()
	S MObj.AcceptUser=DObj.MAcceptUserGetObjectId()
	S MObj.SubmitUser=DObj.MSubmitUserGetObjectId()
	I MObj.AcceptUser'="" s MObj.AcceptUser=$P(^SSU("SSUSR",MObj.AcceptUser),"^",2)
	I MObj.SubmitUser'="" s MObj.SubmitUser=$P(^SSU("SSUSR",MObj.SubmitUser),"^",2)
	I MObj.AddUserID'=""  s MObj.AddUser=$P(^SSU("SSUSR",MObj.AddUserID),"^",2)
	s MObj.AcceptUser= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",MObj.AcceptUser,langid)
	s MObj.SubmitUser= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",MObj.SubmitUser,langid)
	s MObj.AddUser= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",MObj.AddUser,langid)
	
	S MObj.STime=DObj.MBCSTime
	S MObj.ETime=DObj.MBCETime
	i MObj.STime'="" s MObj.STime=..%ZT(MObj.STime,2)
	i MObj.ETime'="" s MObj.ETime=..%ZT(MObj.ETime,2)
	s MObj.NextDay=DObj.MBCNextDay
	
	Q MObj
}

}
