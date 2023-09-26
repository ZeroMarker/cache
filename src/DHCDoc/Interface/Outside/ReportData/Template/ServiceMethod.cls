/// creator：郭荣勇
/// date：2019-04-10
/// desc：接口使用独立类方法的方式
/// 示例方法:GetDataExample
Class DHCDoc.Interface.Outside.ReportData.Template.ServiceMethod Extends (%RegisteredObject, DHCDoc.Interface.Outside.ReportData.Template.Service)
{

ClassMethod GetDataExample(RequestXML As %String) As %GlobalCharacterStream
{
	s XMLStream=##class(%GlobalCharacterStream).%New()	
	;患者信息获取
	/*
	s PatientID=1
	s PatBaseObj=##class(DHCDoc.GetInfo.Public.Business.EPMI).GetPatBaseInfo(PatientID)
	d PatBaseObj.XMLExportToStream(.XMLStream)
	*/
	d XMLStream.Rewind()
	d XMLStream.WriteLine("测试方法,参数值为:"_RequestXML)
	d XMLStream.%Save()
	
	Q XMLStream
}

}
