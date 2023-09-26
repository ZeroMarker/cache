Class CHSSWeb.HISInterface.BarCodeInterface Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

ClassMethod GetPersonBarcodeData(YearCheckRowId As %String, PersonRowId As %String) As %String
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
	s returnData = returnData_"<BarCodeList>"
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
	.;d barcodeDataList.PersonBarcodeList.Insert(barcodeData)
	.;第二种方法：手工拼写
	.Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId("CHSSWeb.Barcode.PersonBarcodeObj")
 	.s returnData = returnData_"<BarCodeInfo>"
	.Set propertiescount = cdef.Properties.Count()
	.For i = 1:1:propertiescount d
    ..s returnData = returnData_"<"_cdef.Properties.GetAt(i).Name_">"_$ZOBJPROPERTY(barcodeData,cdef.Properties.GetAt(i).Name)_"</"_cdef.Properties.GetAt(i).Name_">"
 	.s returnData = returnData_"</BarCodeInfo>"
	s returnData = returnData_"</BarCodeList>"
		
	q returnData
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

Storage Default
{
<Data name="BarCodeInterfaceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.HIS6F2.BarCodeInter621D</DataLocation>
<DefaultData>BarCodeInterfaceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.HIS6F2.BarCodeInter621D</IdLocation>
<IndexLocation>^CHSSWeb.HIS6F2.BarCodeInter621I</IndexLocation>
<StreamLocation>^CHSSWeb.HIS6F2.BarCodeInter621S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
