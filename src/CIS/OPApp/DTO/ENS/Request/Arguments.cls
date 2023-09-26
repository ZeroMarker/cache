Class CIS.OPApp.DTO.ENS.Request.Arguments Extends (CIS.OPApp.DTO.Abstract.Model, %XML.Adaptor)
{

Parameter XMLNAME = "Arguments";

Parameter XMLIGNORENULL = 0;

Parameter XMLIGNOREINVALIDTAG = 0;

/// 开始日期（手术日期）
Property StartDate As %String;

/// 结束日期（手术日期）
Property EndDate As %String;

/// 手术申请ID
Property RowId As %String;

/// 手术申请ID
Property ApplicationID As %String;

/// 手术申请ID(旧版4.x)
Property OldID As %String;

/// 就诊号
Property EpisodeID As %String;

/// 登记号
Property RegNo As %String;

/// 住院号
Property MedcareNo As %String;

/// 就诊号
Property PAADMVisitNumber As %String;

ClassMethod Create() As CIS.OPApp.DTO.ENS.Request.Arguments
{
	quit ##class(CIS.OPApp.DTO.ENS.Request.Arguments).%New()
}

ClassMethod CloneFromObject(object As %RegisteredObject) As CIS.OPApp.DTO.ENS.Request.Arguments
{
	set result=##class(CIS.OPApp.DTO.ENS.Request.Arguments).%New()
	set result.StartDate=$property(object,"StartDate")
	set result.EndDate=$property(object,"StartDate")
	set result.EpisodeID=$property(object,"EpisodeID")
	
	quit result
}

}
