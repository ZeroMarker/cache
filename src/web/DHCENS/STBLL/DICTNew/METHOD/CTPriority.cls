Class web.DHCENS.STBLL.DICTNew.METHOD.CTPriority Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creato
/// Creator：ZhangXinying
/// CreatDate：2018-11-12
/// Description：医嘱类型信息
/// Table：oec_Priority
/// Input： 
/// Return：医嘱类型信息
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPriority).GetCTPriority("1").Read()
ClassMethod GetCTPriority(Input As %String) As %GlobalCharacterStream
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
		set OutputStream=..GetCTPriorityByID(pList)
	}
	
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// Creator：ZhangXinying
/// CreatDate：2018-11-01
/// Description：医嘱类型信息
/// Table：oec_Priority
/// Input： 
/// Return：医嘱类型集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPriority).SendCTPriority("")
ClassMethod SendCTPriority(Input As %String) As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set rowid="0"  for  set rowid=$o(^OECPR(rowid)) Quit:rowid=""  d
	.do plist.SetAt(rowid,count)
	.set count=count+1
	if plist.Count()>0{
		set Instream=..GetCTPriorityByID(plist)
		set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
		set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_Priority",tSC)
		d tSC.OutputToDevice()
	}
	
	Quit 1
Exception
	Quit -1_$ze
}

/// Creator：ZhangXinying
/// CreatDate：2018-11-01
/// Description：医嘱类型信息
/// Table：oec_Priority
/// Input： 
/// Return：医嘱类型集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPriority).GetCTPriorityByID("")
ClassMethod GetCTPriorityByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set Obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTPriority).%New()
		set Str=$g(^OECPR(rowid))
		set Obj.businessrowid=rowid
		set Obj.CTPCode=$p(Str,"^",1)
		set Obj.CTPDesc=$p(Str,"^",2)
		set Obj.CTPCodesystemCode="CT_Priority"
		set Obj.CTPRemarks=""
		set Obj.CTPStatus="1"
		set Obj.CTPUpdateUserCode="无"
		d ListInfo.CTPriority.Insert(Obj)
	}
	d ListInfo.XMLExportToString(.String)

	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTPriority",.Jsonobj)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_Priority",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

}
