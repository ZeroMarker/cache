Class DHCWL.BaseDataQuery.QryStatData.FactoryOfQry Extends %RegisteredObject
{

/// Creator：      	王峥
/// CreatDate：    	2017-6-23
/// Description:   	创建报表对象
/// Table：       	ServOfQryLineRpt，ServOfQryCrossRpt
/// Input：         rptCode报表编码，searchArgs查询参数
/// Output： 
/// Return：		ServOfQry对象
ClassMethod creator(rptName As %String, searchArgs As %String) As ServOfQry
{
	s name=rptName
	s searchArgs=searchArgs
	s rptID=$o(^DHCWL.BaseDataQuery.ReportCfgI("InxName",name,0))
	s newObj=##class(DHCWL.BaseDataQuery.ReportCfg).%OpenId(rptID)
	s rptType=newObj.Type
	q:$g(rptType)="" null
	if rptType="grpRpt" {	//返回行式报表对象
		q ##class(DHCWL.BaseDataQuery.QryStatData.ServOfQryLineRpt).%New(rptID,searchArgs)
	}elseif rptType="corssRpt" {	//返回交叉报表对象
		q ##class(DHCWL.BaseDataQuery.QryStatData.ServOfQryCrossRpt).%New(rptID,searchArgs)
	}
}

}
