/// CTOR: QP
/// DATE: 2020-09-02
/// DESC: 阶段字典
Class web.PilotProject.Model.Stage Extends %RegisteredObject
{

/// 名称
Property STName As %String;

/// 代码
Property STCode As %String;

/// 顺序
Property STSeqno As %String;

/// 项目
Property STProject As %String;

/// 激活
Property STActive As %String;

/// 天数
Property STDays As %String;

/// d ##class(web.PilotProject.Model.Stage).GetInfo(17)
ClassMethod GetInfo(id) As web.PilotProject.Model.Stage
{
	S MObj=##class(web.PilotProject.Model.Stage).%New()
	//Q:id="" MObj
	i id'="" {
		S DObj=##class(User.DHCDocPilotProStage).%OpenId(id)
		I '$ISObject(DObj) {
			Q MObj
		}
		S MObj.STCode=DObj.STCode
		S MObj.STName=DObj.STName
		S MObj.STSeqno=DObj.STOrder
		S MObj.STActive=DObj.STActive
		I MObj.STActive="" S MObj.STActive=0
		S MObj.STProject=DObj.STProjectGetObjectId()
		S MObj.STDays=DObj.STDays
	} else {
		s STSeqno=1
		i $d(^CF.DOC.Pilot.OEStageI("STOrder")) {
			s STSeqno=$o(^CF.DOC.Pilot.OEStageI("STOrder",""),-1)+1
		} 
		s MObj.STSeqno=STSeqno
	}
	Q MObj
}

}
