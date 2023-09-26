Class DHCWL.BaseDataQuery.QryStatData.FactoryOfEngIne Extends %RegisteredObject
{

//^||DHCWLTEMP("RPTCFG","Name")

/// Creator：      	王峥
/// CreatDate：    	2017-6-23
/// Description:   	创建报表对象
/// Table：       	ServOfQryLineRpt，ServOfQryCrossRpt
/// Input：         rptCode报表编码，searchArgs查询参数
/// Output： 
/// Return：		ServOfQry对象
ClassMethod creator() As ServOfEngIne
{
	s sqlTableName=^||DHCWLTEMP("RPTCFG","BaseObjName") /// 报表名称
	s excStr=^||DHCWLTEMP("FactoryOfEngIne",sqlTableName)
	q @excStr
	//q ##class(DHCWL.BaseDataQuery.QryStatData.ServOfEngIneWL).%New()
}

}
