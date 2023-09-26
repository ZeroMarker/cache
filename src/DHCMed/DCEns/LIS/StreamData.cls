/// 名称 : DHCMed.DCEns.LIS.StreamData
/// 说明 : 检验接口XML数据流
Class DHCMed.DCEns.LIS.StreamData Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 数据来源（1送检结果，2检验报告，3检验项目字典，4检验医嘱字典，5检验标本字典，6细菌字典，7抗生素字典，8科室字典）
Property ESDSource As %String;

/// 数据流
Property ESDStream As %GlobalCharacterStream;

/// 日期
Property ESDActDate As %Date;

/// 时间
Property ESDActTime As %Time;

/// Creator：     zhufei
/// CreatDate：   2015-12-25
/// Description:  根据ID取值数据流
/// Table：       DHCMed.DCEns.LIS.StreamData
/// Input：       Id : DHCMed.DCEns.LIS.StreamData.ID
/// Return：      返回Object
/// w ##class(DHCMed.DCEns.LIS.StreamData).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMed.DCEns.LIS.StreamData
{
	new (aId)
	quit:'##class(DHCMed.DCEns.LIS.StreamData).%ExistsId(aId) ""
	set obj=##Class(DHCMed.DCEns.LIS.StreamData).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     zhufei
/// CreatDate：   2015-12-25
/// Description:  更新数据流
/// Table：       DHCMed.DCEns.LIS.StreamData
/// Input：       DataSource ：数据源
///               DataStream : 数据流
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.DCEns.LIS.StreamData).Update()
ClassMethod Update(aStream As %GlobalCharacterStream, aSource As %String = "1") As %String
{
	New (aStream,aSource)
	Set return=0
	Quit:(aStream="")||(aSource="") return
	
	Set obj=##class(DHCMed.DCEns.LIS.StreamData).%New()
	Quit:'$IsObject(obj) return
	Set obj.ESDSource     = aSource
	Set obj.ESDStream     = aStream
	Set obj.ESDActDate    = +$h
	Set obj.ESDActTime    = $p($h,",",2)
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

/// w ##Class(DHCMed.DCEns.LIS.StreamData).TestInput()
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
	
	Set return=##Class(DHCMed.DCEns.LIS.StreamData).Update(objStream,1)
	Quit return
}

/// w ##Class(DHCMed.DCEns.LIS.StreamData).TestOutput(2)
ClassMethod TestOutput(aID As %String) As %String
{
	New (aID)
	
	Set obj=##Class(DHCMed.DCEns.LIS.StreamData).%OpenId(aID)
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

/// w ##Class(DHCMed.DCEns.LIS.StreamData).Test(3)
ClassMethod Test(aID As %String) As %String
{
	New (aID)
	
	Set obj=##Class(DHCMed.DCEns.LIS.StreamData).%OpenId(aID)
	Do:obj'="" obj.%Close()
	Quit:'$IsObject(obj) "No Stream Data!"
	Set xmlStream=obj.ESDStream
	
	Set return=##class(DHCMed.DC.LISService.ImportDataByEns).Service(xmlStream,1)
	Quit return
}

Storage Default
{
<Data name="DataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ESDSource</Value>
</Value>
<Value name="3">
<Value>ESDStream</Value>
</Value>
<Value name="4">
<Value>ESDActDate</Value>
</Value>
<Value name="5">
<Value>ESDActTime</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DCEns.LIS.StreamDataD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.DCEns.LIS.StreamDataD</IdLocation>
<IndexLocation>^DHCMed.DCEns.LIS.StreamDataI</IndexLocation>
<StreamLocation>^DHCMed.DCEns.LIS.StreamDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
