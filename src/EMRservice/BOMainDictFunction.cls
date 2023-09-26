/// 名称：EMRservice.BOMainDictFunction
/// 描述：电子病历维护程序系统功能项定义表WebService接口
/// 编写者：LingChen
/// 编写日期: 2010-10-22
Class EMRservice.BOMainDictFunction Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "BOMainDictFunctionService";

/// Creator：      LingChen
/// CreatDate：    2010-10-22
/// Description:   查询
/// Table：        
/// Input：          
/// Output：        
/// Return：       函数返回值的说明
/// Others：       其它说明
/// Test:          d ##Class(EMRservice.BOMainDictFunction).SelectAll()
ClassMethod SelectAll() As EMRservice.dataset.EMainDictFunctionAllDataSet [ WebMethod ]
{
    q ##Class(EMRservice.BL.BLMainDictFunction).SelectAll()
}

/// 添加项
ClassMethod AddDictFunction(ADictFunction As EMRservice.entity.EMainDictFunction) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLMainDictFunction).AddDictFunction(ADictFunction)
}

/// 清除数据
ClassMethod ClearData() [ WebMethod ]
{
	d ##Class(EMRservice.BL.BLMainDictFunction).ClearData()
}

/// 删除
ClassMethod DelDictFunction(RowID As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLMainDictFunction).DelDictFunction(RowID)
}

}
