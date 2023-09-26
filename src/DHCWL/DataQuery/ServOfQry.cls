/// 名称: DHCWL.DataQuery.ServOfQry
/// 描述: 查询报表数据基类
/// 编写者：王峥
/// 编写日期:2017-6-23
Class DHCWL.DataQuery.ServOfQry Extends %RegisteredObject
{

/// 报表编码
Property rptCode As %String;

/// 查询项
Property searchArgs As %String;

/// Creator：      	王峥
/// CreatDate：    	2017-6-23
/// Description:   	查询统计数据
/// Table：       	无
/// Input：         startDate:统计开始日期;endDate:统计结束日期;oupputIF:输出接口
/// Output： 
/// Return： 
/// Others：        其它说明
Method QryRptStatData(startDate As %String, endDate As %String, outputIF As ServOfOutputIF) As %String [ Abstract ]
{
}

/// Creator：      	王峥
/// CreatDate：    	2017-6-23
/// Description:   	生成对象后被自动调用，作用相当于构造函数
/// Table：       	无
/// Input：         rptCode:报表编码;searchArgs：查询参数
/// Output： 
/// Return： 
/// Others：        其它说明
Method %OnNew(rptCode As %String, searchArgs As %String) As %Status
{
	k ^||DHCWLTEMP
	
	s ..rptCode=rptCode
	s ..searchArgs=searchArgs
    Quit $$$OK
}

/// Creator：      	王峥
/// CreatDate：    	2017-6-23
/// Description:   	得到报表编码
/// Table：       	无
/// Input：         
/// Output： 
/// Return： 		报表编码
/// Others：        其它说明
Method GetRptCode() As %String
{
	q ..rptCode
}

/// Creator：      	王峥
/// CreatDate：    	2017-6-23
/// Description:   	得到查询参数
/// Table：       	无
/// Input：         
/// Output： 
/// Return： 		查询参数
/// Others：        其它说明
Method GetSearchArgs() As %String
{
	q ..searchArgs
}

}
