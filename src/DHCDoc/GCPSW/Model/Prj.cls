/// CTOR: QP
/// DATE: 2020-09-08
/// DESC: 项目模型
Class DHCDoc.GCPSW.Model.Prj Extends %RegisteredObject
{

/// 代码
Property PCode As %String;

/// 描述
Property PDesc As %String;

/// 开始日期
Property PStartDate As %String;

/// 结束日期
Property PEndDate As %String;

/// 科研项目
Property PPPRowId As %String;

/// 备注
Property PNote As %String;

ClassMethod GetInfo(id) As DHCDoc.GCPSW.Model.Prj
{
	S MObj=##class(DHCDoc.GCPSW.Model.Prj).%New()
	Q:id="" MObj
	S DObj=##class(User.GCPSWPrj).%OpenId(id)
	I '$ISObject(DObj) {
		Q MObj
	}
	S MObj.PCode=DObj.PCode
	S MObj.PDesc=DObj.PDesc
	S MObj.PStartDate=##class(DHCDoc.GCPSW.COM.Func).DateLogicalToHtml(DObj.PStartDate)
	S MObj.PEndDate=##class(DHCDoc.GCPSW.COM.Func).DateLogicalToHtml(DObj.PEndDate)
	
	S MObj.PNote=DObj.PNote
	S MObj.PPPRowId=DObj.PPPRowIdGetObjectId()
	
	
	Q MObj
}

}
