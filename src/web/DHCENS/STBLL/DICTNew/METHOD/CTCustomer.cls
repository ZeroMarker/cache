Class web.DHCENS.STBLL.DICTNew.METHOD.CTCustomer Extends %RegisteredObject
{

/// Creator：lipengfei
/// CreatDate：2019—10-25
/// Description：获取客户字典信息
/// Table：CT_HealthCareProvider
/// Input： 
/// Return：客户字典信息集合
/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCustomer).SendCTCustomer("")
ClassMethod SendCTCustomer(Input As %String) As %String
{
	set $Ztrap="Exception"
	set rowid=0,count=1
	set plist=##class(%ArrayOfDataTypes).%New()
	for{
		set rowid=$o(^CT("HCP",rowid))
		Quit:(rowid="")||(+rowid=0)
		do plist.SetAt(rowid,count)
		set count=count+1
	}
	set stream=..GetCustomerByID(plist)
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set tSC=soapObj.AcceptDicInfo("MES0001",stream)
	set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_Customer",tSC)
	do tSC.OutputToDevice()
	Quit tSC.Read()
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// Creator：lipengfei
/// CreatDate：2019-10-25
/// Description：获取客户字典信息
/// Table：CT_HealthCareProvider
/// Input： 
/// Return：客户字典信息
/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCustomer).GetCustomer("1").Read()
ClassMethod GetCustomer(Input As %String) As %GlobalCharacterStream
{
	//b ;;;1
	set $zt="Exception"
	set OutputStream=##class(%GlobalCharacterStream).%New()
	set length=$l(Input,"^")
	set pList=##class(%ArrayOfDataTypes).%New()
	for i=1:1:length{
		set rowid=$p(Input,"^",i)
		do pList.SetAt(rowid,i)
		}
	if pList.Count()>0{
		set OutputStream=..GetCustomerByID(pList)
	}
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator：lipengfei
/// CreatDate：2019-10-25
/// Description：获取客户字典信息
/// Table：CT_Customer
/// Input： 
/// Return：客户字典信息
ClassMethod GetCustomerByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTCustomer).%New()
		set message=$g(^CT("HCP",rowid))
		set obj.businessrowid=rowid
		set obj.CTCCode=$P(message,"^",1)
		set obj.CTCCodesystemCode="CT_Customer"
		set obj.CTCDesc=$P(message,"^",2)
		set obj.CTCRemarks="无"
		set obj.CTCStatus=1
		set obj.CTCUpdateUserCode="无"
		do ListInfo.CTCustomer.Insert(obj)
		;b ;3
	}
	;w "sdsdsds"
	d ListInfo.XMLExportToString(.String)
	;w String,!
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTCustomer",.Jsonobj)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_Customer",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

}
