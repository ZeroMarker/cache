Class CHSSWeb.Barcode.PersonBarcodeReportXML Extends %CSP.Page [ ClassType = "", Not ProcedureBlock ]
{

Parameter CONTENTTYPE = "text/xml";

///  Creator：liuchao
///  CreatDate：2010-3-8
///  Description: 根据id生成xml文件
///  Table：
///  Input：id-任意值
///  Output：
///  Return：错误返回错误信息，正确返回正确信息
///  Others：如果传的参数为空，则报错
ClassMethod OnPage() As %Status
{
	Write "<?xml version=""1.0"" ?>",!

	Set YearCheckRowId=$G(%request.Data("YearCheckRowId",1))
	Set PersonRowId=$G(%request.Data("PersonRowId",1))
	If (YearCheckRowId=""){
	    Set status=YearCheckRowId
	    Do $system.OBJ.DisplayError(status)
    	Quit status
		}
	Set reportData = ..GenPersonBarcodeData(YearCheckRowId,PersonRowId)
	Set status = reportData.XMLExport()
    If ($system.Status.IsError(status)) {
    	Do $system.OBJ.DisplayError(status)
    	Quit status
    }
         
    Quit $system.Status.OK()
}

ClassMethod GenPersonBarcodeData(YearCheckRowId As %String, PersonRowId As %String) As CHSSWeb.Barcode.PersonBarcodeData
{
	n (YearCheckRowId,PersonRowId)	
	Set barcodeDataList = ##class(CHSSWeb.Barcode.PersonBarcodeData).%New()
	
	//根据	PersonRowId 取姓名 性别 年龄
	s tempPersonInfo = ##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)		
	s PersonName = tempPersonInfo.PersonName
	
	s sex = ""
	i tempPersonInfo.SexDR'= "" d
	.s sex = tempPersonInfo.SexDR.CTSEXDesc
	s birthdate = tempPersonInfo.Birth	     
	s age = ..GetAge(birthdate)	
	
	//获取条形码相关信息
	Set BarcodeRowId = 0
	For  Set BarcodeRowId = $O(^CHSS.CheckUpBarcodeRecordI("YearCheckRowIdIndex"," "_YearCheckRowId,BarcodeRowId)) q:BarcodeRowId=""  d
	.Set tempCheck = ##class(CHSS.CheckUpBarcodeRecord).%OpenId(BarcodeRowId)
	.//条形码
	.Set Barcode = tempCheck.Barcode	  	
	.if tempCheck.BarcodeType'= "" do
	..Set BarcodeType = tempCheck.BarcodeType.Description  //条形码名称
	.s barcodeData = ##class(CHSSWeb.Barcode.PersonBarcodeObj).%New()
	.s barcodeData.PersonName = PersonName
	.s barcodeData.SexName = sex
	.s barcodeData.Age = age
	.s barcodeData.BarcodeTypeName = BarcodeType
	.s barcodeData.Barcode = Barcode	
	.//w "="_Barcode_"=="_BarcodeType_"="
	.d barcodeDataList.PersonBarcodeList.Insert(barcodeData)
	q barcodeDataList
}

//  根据出生日期获得年龄

ClassMethod GetAge(birthdate As %String) As %Integer
{
  S birth = $zd(birthdate,3)	
  S today = $zd($h,3)
  s age = $E(today,1,4)- $E(birth,1,4)
  S birth = $E(today,1,4)_$E(birth,5,10)
  i (birth-$h<0) d
  .s age=age-1  
  q age
}

}
