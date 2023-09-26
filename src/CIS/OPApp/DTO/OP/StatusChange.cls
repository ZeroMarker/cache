Class CIS.OPApp.DTO.OP.StatusChange Extends (CIS.OPApp.DTO.Abstract.Model, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLTYPE = "Model";

Parameter XMLNAME = "StatusChange";

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

/// 患者姓名
Property Patient As %String;

/// 原始状态
Property OriginalStatus As %String;

/// 原始状态代码
Property OriginalStatusCode As %String;

/// 当前状态
Property CurrentStatus As %String;

/// 当前状态代码
Property CurrentStatusCode As %String;

/// 数据更新时间（yyyy-MM-dd HH:mm:ss）
Property UpdateDateTime As %String;

/// 相关操作用户
Property UpdateUser As %String;

/// 相关操作用户ID
Property UpdateUserID As %String;

}
