/// 名称：EPRservice.BOMainDictFunction
/// 描述：电子病历维护程序系统功能项定义表WebService接口
/// 编写者：LingChen
/// 编写日期: 2010-10-22
Class EPRservice.BOMainDictFunction Extends %SOAP.WebService [ ProcedureBlock ]
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
/// Test:          d ##Class(EPRservice.BOMainDictFunction).SelectAll()
ClassMethod SelectAll() As EPRservice.dataset.MainDictFunctionAllDataSet [ WebMethod ]
{
    q ##Class(EPRservice.BLMainDictFunction).SelectAll()
}

}
