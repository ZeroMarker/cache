Class DHCDoc.Interface.Outside.ReportData.Template.Service Extends (%RegisteredObject, %SOAP.WebService)
{

/// Parameter LOCATION = "http://172.19.19.57/DTHealth/web/";
/// Name of the WebService.
Parameter SERVICENAME = "SelfRegService";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://tempuri.org";

/// 以下4种方式,有数据对照清洗的处理，请统一在本包下的ServiceContrast类中封装方法处理
/// 1、统一输出Query的%XML.DataSet;建议使用这种方式
/// input:QueryName Query名称，格式 类名:Query名称
/// 		  argsLen 参数长度,指的是p1 至 p9 的个数,传递几个参数的意思
/// 		  p1 至 p9 具体业务参数
/// ouput:%XML.DataSet,具体应用请查看类文档；对应调用的Query输出可以为对应接口的字段名称
/// d ##class(DHCDoc.Interface.Outside.ReportData.Template.Service).QueryDataSet("DHCDoc.Interface.Outside.ReportData.Template.ServiceQuery:QueryExample","")
ClassMethod QueryDataSet(QueryName As %String, argsLen = 0, p1 = "", p2 = "", p3 = "", p4 = "", p5 = "", p6 = "", p7 = "", p8 = "", p9 = "") As %XML.DataSet [ WebMethod ]
{
    Set result=##class(%XML.DataSet).%New(QueryName)
    set Args=argsLen
    
    set p(1)=p1,p(2)=p2,p(3)=p3,p(4)=p4,p(5)=p5,p(6)=p6,p(7)=p7,p(8)=p8,p(9)=p9
    for i=1:1:Args {
	    s Args(i)=p(i)
    }
    Set result.DataSetName="QueryDataSet"
    Do result.SetArgs(Args...)
    Quit result
}

/// 2、使用存储过程的模式,Query 增加表达式SqlProc与SqlName; 这种方式的接口统一在DHCDoc.Interface.Outside.ReportData.Template.ServiceProc中书写
/// 例如：Query ProcExample(ByRef qHandle As %Binary,args...) As %Query(ROWSPEC = "ExampleProA,ExampleProB,ExampleProC") [ SqlName = ReportData_ProcExample, SqlProc ]
/// 3、使用标准Query的模式; 这种方式的接口统一在DHCDoc.Interface.Outside.ReportData.Template.ServiceQuery中书写
/// 例如：Query QueryExample(ByRef qHandle As %Binary,args...) As %Query(ROWSPEC = "ExampleQryA,ExampleQryB,ExampleQryC")
/// -------------------------------------------------
/// 4、使用独立类方法的模式; 这种方式的接口方法体统一在DHCDoc.Interface.Outside.ReportData.Template.ServiceMethod中书写，入口还需写在本类中
/// 例如：ClassMethod GetDataExample(args...) As %String/%GlobalCharacterStream
ClassMethod GetDataExample(RequestXML As %String) As %GlobalCharacterStream [ WebMethod ]
{
    Q ##class(DHCDoc.Interface.Outside.ReportData.Template.ServiceMethod).GetDataExample(RequestXML)
}

}
