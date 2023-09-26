Class web.DHCENS.STBLL.DICTNew.METHOD.CTSpecimen Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：ZhangXinying
/// CreatDate：2018-11-12
/// Description：检验标本字典信息
/// Table：dbo.BT_Specimen
/// Input： 
/// Return：检验标本字典信息
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTSpecimen).GetCTSpecimen("1").Read()
ClassMethod GetCTSpecimen(Input As %String) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set OutputStream=##class(%GlobalCharacterStream).%New()
	set length=$l(Input,"^")
	set pList=##class(%ArrayOfDataTypes).%New()
	for i=1:1:length{
		set rowid=$p(Input,"^",i)
		do pList.SetAt(rowid,i)
		}
	if pList.Count()>0{
		set OutputStream=..GetCTSpecimenByID(pList)
	}
	
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// Creator：ZhangXinying
/// CreatDate：2018-11-01
/// Description：检验标本字典信息
/// Table：dbo.BT_Specimen
/// Input： 
/// Return：检验标本字典集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTSpecimen).SendCTSpecimen("")
ClassMethod SendCTSpecimen(Input As %String) As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set rowid="0"  for  set rowid=$o(^dbo.BTSpecimenD(rowid)) Quit:rowid=""  d
	.do plist.SetAt(rowid,count)
	.set count=count+1
	if plist.Count()>0{
		set Instream=..GetCTSpecimenByID(plist)
		set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
		set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_Specimen",tSC)
		d tSC.OutputToDevice()
	}
	q 1
Exception
	Quit -1_$ze
}

/// Creator：ZhangXinying
/// CreatDate：2018-11-01
/// Description：检验标本字典信息
/// Table：dbo.BT_Specimen
/// Input： 
/// Return：检验标本字典集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTSpecimen).GetCTSpecimenByID("")
ClassMethod GetCTSpecimenByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set Obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTSpecimen).%New()
		set Str=$g(^dbo.BTSpecimenD(rowid))
		set Obj.businessrowid=rowid
		set Obj.CTSCode=$lg(Str,2)
		set Obj.CTSDesc=$lg(Str,3)
		Q:Obj.CTSDesc=""
		set Obj.CTSCodesystemCode="CT_Specimen"
		set Obj.CTSRemarks=""
		set Obj.CTSStatus="1"
		set Obj.CTSUpdateUserCode="无"
		d ListInfo.CTSpecimen.Insert(Obj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTSpecimen",.Jsonobj)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_Specimen",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

}
