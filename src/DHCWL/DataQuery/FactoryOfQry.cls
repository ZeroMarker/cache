/// 名称: DHCWL.DataQuery.FactoryOfQry
/// 描述: 统计查询工厂类
/// 编写者：王峥
/// 编写日期: 2017-7
Class DHCWL.DataQuery.FactoryOfQry Extends %RegisteredObject
{

/// Creator：      	王峥
/// CreatDate：    	2017-6-23
/// Description:   	创建报表对象
/// Table：       	ServOfQryLineRpt，ServOfQryCrossRpt
/// Input：         rptCode报表编码，searchArgs查询参数
/// Output： 
/// Return：		ServOfQry对象
ClassMethod creator(rptCode As %String, searchArgs As %String) As ServOfQry
{
	s rptID=$o(^DHCWL.DataQuery.ReportCfgI("InxCode",rptCode,0))
	s newObj=##class(DHCWL.DataQuery.ReportCfg).%OpenId(rptID)
	s rptType=newObj.RptType
	q:$g(rptType)="" null
	if rptType="grpRpt" {	//返回行式报表对象
		q ##class(DHCWL.DataQuery.ServOfQryLineRpt).%New(rptCode,searchArgs)
	}elseif rptType="crossRpt" {	//返回交叉报表对象
		q ##class(DHCWL.DataQuery.ServOfQryCrossRpt).%New(rptCode,searchArgs)
	}
}

}
