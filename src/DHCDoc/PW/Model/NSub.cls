/// CTOR: QP
/// DATE: 2021-07-14
/// DESC: 交班本修改
Class DHCDoc.PW.Model.NSub Extends %RegisteredObject
{

/// 登记号
Property PatNo As %String;

/// 类型
Property PType As %String;

/// 交班内容
Property SubmitContent As %String;

/// 接班内容
Property AcceptContent As %String;

/// 治疗方案(合并特殊疾病患者,泰和肿瘤)
Property EZLPlan As %String;

/// 目前临床问题(危重症、特级、一级护理患者,泰和肿瘤)
Property EQuestion As %String;

/// 主要处置措施(危重症、特级、一级护理患者,泰和肿瘤)
Property EMainAction As %String;

/// W ##class(DHCDoc.PW.Model.NSub).GetInfo("4||1152")
ClassMethod GetInfo(id) As DHCDoc.PW.Model.NSub
{
	S MObj=##class(DHCDoc.PW.Model.NSub).%New()
	Q:id="" MObj
	S DObj=##class(User.DHCDocPassWorkNSub).%OpenId(id)
	S EID=##class(DHCDoc.PW.BS.NSubExt).GetEID(id)
	S EObj=##class(User.DHCDocPassWorkNSubExt).%OpenId(EID)
	I ('$ISObject(DObj))||('$ISObject(EObj)) {
		Q MObj
	}
	s AdmID=DObj.SAdmIDGetObjectId()
	s PAPMIRowID=$p($g(^PAADM(AdmID)),"^",1)
	s PatNo=$p($g(^PAPER(PAPMIRowID,"PAT",1)),"^",1)
	S MObj.PatNo=PatNo
	s LocID=DObj.SLocIDGetObjectId()
	s MID=##class(DHCDoc.PW.COM.Method).GetMIDByLoc(LocID)
	s PType=##class(DHCDoc.PW.BS.NSub).GetPType(id,AdmID,MID)
	s MObj.PType=PType
	s MObj.AcceptContent=DObj.SAcceptContent
	S MObj.SubmitContent=DObj.SContent
	S MObj.EMainAction=EObj.EMainAction
	S MObj.EQuestion=EObj.EQuestion
	S MObj.EZLPlan=EObj.EZLPlan
	
	B ;00
	
	Q MObj
}

}
