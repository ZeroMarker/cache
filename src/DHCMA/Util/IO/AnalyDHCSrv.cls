/// 名称: DHCMA.Util.IO.AnalyDHCSrv
/// 描述: 语义分析服务调用类
/// 编写者：yankai
/// 编写日期: 2020-03-16
Class DHCMA.Util.IO.AnalyDHCSrv Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2020-05-19
/// Description:  获取语义分析结果
/// Table：       无
/// Input：       aInputStr ：调用接口入参拼接(json)串
/// Return：      返回解析结果
/// w ##class(DHCMA.Util.IO.AnalyDHCSrv).GetJsonResult()
ClassMethod GetJsonResult(aInputStr As %String) As %ArrayOfDataTypes
{
	New (aInputStr)
	Set return=##Class(%ArrayOfDataTypes).%New()
	Quit:aInputStr="" return
	
	Set $ZT="GetJsonResultErr"
	
	Set ServerStr=##class(DHCMA.Util.BT.Config).GetValueByCode("SYSRMEServerToMain")
	Set Server = $p(ServerStr,":",1)   //解析服务器地址 111.205.6.207
	Set Port   = $p(ServerStr,":",2)   //端口 7707
	Quit:(Server="")||(Port="") return
	
	//组织流数据
	Set jsonStream=##class(%GlobalCharacterStream).%New()
	Do jsonStream.%Close()
    Do jsonStream.Rewind()
	Do jsonStream.Write(aInputStr)
	
	//获取测试Json数据流 输入
	//Do ##Class(DHCHAI.Utils.FromJSON).SetTestData(jsonStream,"In")
	//Set aInputStr=$zcvt(aInputStr,"O","UTF8")
	//HttpRequest调用
	Set httpRequest=##class(%Net.HttpRequest).%New()		
	Set httpRequest.Server = Server
	Set httpRequest.Port   = Port
	Do httpRequest.InsertParam("data",aInputStr)
	Set sc=httpRequest.Post("/tag")
	If $system.Status.IsError(sc) {
		Do $system.OBJ.DisplayError(sc)
		Set ^DHCHAI.Task.TaskManager("NLPStatus")=1
		Quit return
	}
	Set jsonStream=httpRequest.HttpResponse.Data
	
	//获取测试Json数据流 输出
	//Do ##Class(DHCHAI.Utils.FromJSON).SetTestData(jsonStream,"Out")
	
	//解析Json数据流
	Set jsonObject=##class(%DynamicObject).%FromJSON(jsonStream)
	Quit:'$IsObject(jsonObject) return
	Set return=..ChangeJsonObject(jsonObject)
	Quit return
	
GetJsonResultErr
	//w $ZError,!
	Set ^DHCHAI.Task.TaskManager("NLPStatus")=1
	Quit return
}

/// Do ##class(DHCMA.Util.IO.AnalyDHCSrv).ChangeJsonObject()
ClassMethod ChangeJsonObject(jsonObject As %DynamicObject) As %ArrayOfDataTypes
{
	New (jsonObject)
	Set return=##Class(%ArrayOfDataTypes).%New()
	Quit:jsonObject="" return
	
	set iter=jsonObject.%GetIterator()
	While iter.%GetNext(.key,.value) {
		Set type=jsonObject.%GetTypeOf(key)
		If type="object" {
			Set obj=..ChangeJsonObject(value)
			Do return.SetAt(obj,key)
		} ElseIf type="array" {
			Set arr=..ChangeJsonArray(value)
			Do return.SetAt(arr,key)
		} Else {
			Do return.SetAt(value,key)
		}
	}
	Quit return
}

/// Do ##class(DHCMA.Util.IO.AnalyDHCSrv).ChangeJsonArray()
ClassMethod ChangeJsonArray(jsonArray As %DynamicArray) As %ArrayOfDataTypes
{
	New (jsonArray)
	Set return=##Class(%ArrayOfDataTypes).%New()
	Quit:jsonArray="" return
	
	For indCnt=0:1:(jsonArray.%Size()-1){
		Set type=jsonArray.%GetTypeOf(indCnt)
		Set value=jsonArray.%Get(indCnt)
		If type="object" {
			Set obj=..ChangeJsonObject(value)
			Set cnt=return.Count()
			Do return.SetAt(obj,cnt+1)
		} ElseIf type="array" {
			Set arr=..ChangeJsonArray(value)
			Set cnt=return.Count()
			Do return.SetAt(arr,cnt+1)
		} Else {
			Set cnt=return.Count()
			Do return.SetAt(value,cnt+1)
		}
	}
	Quit return
}

}
