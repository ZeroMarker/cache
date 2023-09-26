/// 名称 : DHCMed.DC.StreamData
/// 说明 : WebService接口XML数据流
Class DHCMed.DC.StreamData Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 任务说明
Property TaskName As %String(MAXLEN = 200, TRUNCATE = 1);

/// 执行结果
Property Result As %String(MAXLEN = 200, TRUNCATE = 1);

/// 执行程序
Property Routine As %String(MAXLEN = 200, TRUNCATE = 1);

/// 进程号
Property PID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 数据流
Property Stream As %GlobalCharacterStream;

/// 日志日期
Property LogDate As %Date;

/// 日志时间
Property LogTime As %Time;

/// Creator：     zhufei
/// CreatDate：   2016-04-20
/// Description:  根据ID取值数据流
/// Table：       DHCMed.DC.StreamData
/// Input：       Id : DHCMed.DC.StreamData.ID
/// Return：      返回Object
/// w ##class(DHCMed.DC.StreamData).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMed.DC.StreamData
{
	new (aId)
	quit:'##class(DHCMed.DC.StreamData).%ExistsId(aId) ""
	set obj=##Class(DHCMed.DC.StreamData).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     zhufei
/// CreatDate：   2016-04-20
/// Description:  更新数据流
/// Table：       DHCMed.DC.StreamData
/// Input：       DataSource ：数据源
///               DataStream : 数据流
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.DC.StreamData).Update()
ClassMethod Update(aTaskName As %String, aRoutine As %String, aPID As %String, aStream As %GlobalCharacterStream) As %String
{
	New (aTaskName,aRoutine,aPID,aStream)
	Set return=0
	Quit:(aTaskName="")||(aRoutine="")||(aPID="")||(aStream="") return
	
	Set obj=##class(DHCMed.DC.StreamData).%New()
	Quit:'$IsObject(obj) return
	Set obj.TaskName   = aTaskName
	Set obj.Routine    = aRoutine
	Set obj.Stream     = aStream
	Set obj.PID        = aPID
	Set obj.LogDate    = +$h
	Set obj.LogTime    = $p($h,",",2)
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// w ##Class(DHCMed.DC.StreamData).TestInput()
ClassMethod TestInput()
{
	New
	Set return=0
	
	Set objStream=##class(%GlobalCharacterStream).%New()
    Do objStream.Rewind()
	//Do objStream.Write("<?xml version=""1.0"" encoding=""UTF-8""?>")
	Do objStream.Write("<AdmFirstPage description=""病案首页"">")
	Do objStream.Write("    <HospitalDesc description=""医疗机构名称""></HospitalDesc>")
	Do objStream.Write("</AdmFirstPage>")
	Do objStream.%Close()
	
	Set return=##Class(DHCMed.DC.StreamData).Update(objStream,1)
	Quit return
}

/// w ##Class(DHCMed.DC.StreamData).TestOutput(2)
ClassMethod TestOutput(aID As %String) As %String
{
	New (aID)
	
	Set obj=##Class(DHCMed.DC.StreamData).%OpenId(aID)
	Do:obj'="" obj.%Close()
	Quit:'$IsObject(obj) "No Stream Data!"
	
	Set reader = ##class(%XML.Reader).%New()
	Set sc= reader.OpenStream(obj.ESDStream)
	Do reader.Correlate("AdmFirstPage","DHCMed.DCEns.LIS.AdmFirstPage")
	If $$$ISERR(sc) {
		Do $system.OBJ.DisplayError(sc)
		Quit "Error"
	}
	
	While reader.Next(.object,.sc) {
		w "************************* 基本信息 *************************",!
		Do $System.OBJ.Dump(object)
		
		w "************************* 诊断信息 *************************",!
		For indRec=1:1:object.DiagnoseInfo.Count() {
			Set objRec = object.DiagnoseInfo.GetAt(indRec)
			Do $System.OBJ.Dump(objRec)
		}
	}
	Do reader.%Close()
	
	Quit "OK"
}

/// w ##Class(DHCMed.DC.StreamData).Test(3)
ClassMethod Test(aID As %String) As %String
{
	New (aID)
	
	Set obj=##Class(DHCMed.DC.StreamData).%OpenId(aID)
	Do:obj'="" obj.%Close()
	Quit:'$IsObject(obj) "No Stream Data!"
	Set xmlStream=obj.ESDStream
	
	Set return=##class(DHCMed.DC.LISService.ImportDataByEns).Service(xmlStream,1)
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TaskName</Value>
</Value>
<Value name="3">
<Value>Routine</Value>
</Value>
<Value name="4">
<Value>PID</Value>
</Value>
<Value name="5">
<Value>Stream</Value>
</Value>
<Value name="6">
<Value>LogDate</Value>
</Value>
<Value name="7">
<Value>LogTime</Value>
</Value>
<Value name="8">
<Value>Result</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DC.StreamDataD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.DC.StreamDataD</IdLocation>
<IndexLocation>^DHCMed.DC.StreamDataI</IndexLocation>
<StreamLocation>^DHCMed.DC.StreamDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
