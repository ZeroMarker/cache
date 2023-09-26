Class CIS.AN.DTO.OP.Arrangement Extends (CIS.AN.DTO.Abstract.Model, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLTYPE = "Model";

Parameter XMLNAME = "Arrangement";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 外部ID
Property ExternalID As %String;

/// 内部ID
Property RowId As %String;

/// 申请表ID
Property ApplicationID As %String;

/// 旧版申请表ID（5.0以前的手术申请）
Property OldID As %String;

/// 就诊号
Property EpisodeID As %String;

/// 手术间ID
Property OperRoomID As %String;

/// 手术间
Property OperRoom As %String;

/// 手术台次
Property OperSeq As %String;

/// 器械护士
Property ScrubNurses As list Of CIS.AN.DTO.Base.CareProvider;

/// 巡回护士
Property CirculatingNurses As list Of CIS.AN.DTO.Base.CareProvider;

/// 手术执行闭环流程
Property Procedures As list Of CIS.AN.DTO.OP.Procedure;

/// 手术预约状态
Property StatusCode As %String;

/// 手术预约状态描述
Property StatusDesc As %String;

/// 提交时间
Property SubmitDateTime As %String(TRUNCATE = 1);

/// 提交用户ID
Property SubmitUserID As %String(TRUNCATE = 1);

/// 提交用户
Property SubmitUser As %String(TRUNCATE = 1);

Method Validate(ByRef message As %String) As %Boolean
{
	set valid=1
	
	if ##this.ApplicationID=""
	{
		set valid=0,message="ApplicationID can not be null!"
	}
	elseif ##this.EpisodeID=""
	{
		set valid=0,message="EpisodeID can not be null!"
	}
	elseif ##this.OperRoomID=""
	{
		set valid=0,message="OperRoomID can not be null!"
	}
	
	quit valid
}

Method ToXML() As %GlobalCharacterStream
{
	set xml=##class(%GlobalCharacterStream).%New()
    set ret=##this.XMLExportToStream(.xml)
    
    quit xml
}

}
