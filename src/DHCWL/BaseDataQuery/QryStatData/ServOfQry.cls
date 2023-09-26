Class DHCWL.BaseDataQuery.QryStatData.ServOfQry Extends %RegisteredObject
{

/// 报表ID
Property rptID As %String;

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
Method QryRptStatData(startDate As %String, endDate As %String, outputIF As ServOfOutputIF, ByRef inParam) As %String [ Abstract ]
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
Method %OnNew() As %Status
{
	d ..LoadInitData()
    Quit $$$OK
}

Method LoadInitData()
{
		//sql表名和类名的映射
	s ^||DHCWLTEMP("classSqlTableMap","dhc_workload")="User.DHCWorkLoad"
	s ^||DHCWLTEMP("FactoryOfEngIne","dhc_workload")="##class(DHCWL.BaseDataQuery.QryStatData.ServOfEngIneWL).%New()"
}

/// Creator：      王峥
/// CreatDate：    2017-01-25
/// Description:：   返回维度属性执行代码
/// Table：       	基础维度表，维度属性表
/// Input：         qryObjName：查询对象；dimType：维度类型；dimCode：维度编码；proCode：属性编码
/// 					
/// Output：        无。
/// Return：        维度执行代码
/// Others
ClassMethod getPropertyExc(qryObjName As %String, dimType As %String, dimCode As %String, proCode As %String) As %String
{
	//s num=$o(^TEMPDHCWL("WZ-getPropertyExc",""),-1)
	//s ^TEMPDHCWL("WZ-getPropertyExc",num+1)=dimType_","_dimCode_","_proCode
	s ret=""
	if dimType="标准维度" {
		s dimID=$o(^DHCWL.MKPI.MKPIDimTypeI("DimTypeI",$SYSTEM.SQL.ALPHAUP(dimCode),""))
		s dimProID=$o(^DHCWL.MKPI.DimPropertyI("DimCodeI",dimID,$SYSTEM.SQL.ALPHAUP(proCode),""))
		s ret=$lg(^DHCWL.MKPI.DimPropertyD(dimProID),6,"")
	}elseif dimType="对象维度" {
		s proID=$o(^DHCWL.BaseDataQuery.QryobjProI("InxQryobjCode",qryObjName,proCode,""))
		s ret=$lg(^DHCWL.BaseDataQuery.QryobjProD(proID),6,"")
	}
	q ret
}

Method GetProValue(execStr As %String, IDValue As %String, inPam As %String = "") As %String
{

	//s $zt="SQLErrGetProValue"
	s excStr=""
	if $g(inPam)'="" {
		s excStr="$$"_execStr_"("""_IDValue_"~"_inPam_""")"
	}
	else {
		
		s excStr="$$"_execStr_"("""_IDValue_""")"
	}
	q @excStr
	
SQLErrGetProValue
	q "NULL"
}

Method GetExcResult(execStr As %String) As %String
{
	q @execStr
}

}
