Class CIS.AN.DTO.ENS.Request.Arguments Extends (CIS.AN.DTO.Abstract.Model, CIS.AN.DTO.Abstract.Arguments, %XML.Adaptor)
{

Parameter XMLNAME = "Arguments";

Parameter XMLIGNORENULL = 0;

Parameter XMLIGNOREINVALIDTAG = 0;

/// 开始日期（手术日期）
Property StartDate As %String;

/// 结束日期（手术日期）
Property EndDate As %String;

/// 手术申请ID（内部标准ID）
Property RowId As %String;

/// 手术申请ID（外部标准ID）
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

/// 手术名称ID
Property OperationID As %String;

ClassMethod Create() As CIS.AN.DTO.ENS.Request.Arguments
{
	quit ##class(CIS.AN.DTO.ENS.Request.Arguments).%New()
}

ClassMethod CloneFromObject(object As %RegisteredObject) As CIS.AN.DTO.ENS.Request.Arguments
{
	set result=##class(CIS.AN.DTO.ENS.Request.Arguments).%New()
	set result.StartDate=$property(object,"StartDate")
	set result.EndDate=$property(object,"StartDate")
	set result.EpisodeID=$property(object,"EpisodeID")
	set result.RegNo=$property(object,"RegNo")
	set result.MedcareNo=$property(object,"MedcareNo")
	set result.OperationID=$property(object,"OperationID")
	
	quit result
}

Method MatchArgs(arguments As CIS.AN.DTO.Abstract.Arguments) As %Status
{
	try
	{
		set ##this.PAADMVisitNumber=$property(arguments,"EpisodeID")
		set ##this.PAADMVisitNumber=$property(arguments,"PAADMVisitNumber")
	}
	catch(e)
	{
	}
	quit $$$OK
}

}
