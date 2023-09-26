/// 名称: BILL.COM.XMLPrint.cls
/// 描述: XML打印公共方法类
/// 编写者：ZhYW
/// 编写日期: 2022-05-20
/// 产品组：计费医保组
Class BILL.COM.XMLPrint Extends %RegisteredObject
{

/// Creator: ZhYW
/// CreatDate: 2022-05-20
/// Description: 获取打印的TxtData
/// Input: TxtData的json对象
/// Return: 
/// Debug: w ##class(BILL.COM.XMLPrint).GetPrintTxtData()
ClassMethod GetPrintTxtData(txtObj As %DynamicObject) As %String
{
    set prtTxtInfo=""
    quit:('$isObject(txtObj)) prtTxtInfo
	set jsonObj=##class(ext.util.JsonObject).FromJSON(txtObj.%ToJSON())
	set prtTxtInfo=jsonObj.GetPrintData()
	do jsonObj.%Close()
    quit prtTxtInfo
}

/// Creator: ZhYW
/// CreatDate: 2022-05-20
/// Description: 获取打印的ListData
/// Input: ListData的json数组对象
/// Return: 
/// Debug: w ##class(BILL.COM.XMLPrint).GetPrintListData()
ClassMethod GetPrintListData(listObj As %DynamicArray) As %String
{
	set listStr=""
    quit:('$isObject(listObj)) listStr
    set iter=listObj.%GetIterator()
	while iter.%GetNext(.key, .value) {
   		set listStr=$s((listStr=""):value.Listdatapara,1:(listStr_$c(2)_value.Listdatapara))
   	}
   	quit listStr
}

}
