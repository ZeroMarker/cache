Class web.DHCENS.STBLL.DICTNew.METHOD.SSUser Extends (%RegisteredObject, %XML.Adaptor)
{

/// 根据ID号列表取字典信息
/// Creator：luofanyu
/// CreatDate：2018—10-30
/// Description：用户字典信息
/// Table：CT_Loc
/// Input： 
/// Return：用户字典信息集合
/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.SSUser).SendSSUser("")
ClassMethod SendSSUser(Input As %String) As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1,total=0
	set rowid="0"  for  set rowid=$o(^SSU("SSUSR",rowid)) Quit:(rowid="")||(total>5)  d
	.do plist.SetAt(rowid,count)
	.set count=count+1
	.set total=total+1
	.if count>1 do
	..set Instream=..GetSSUserByID(plist)
	..b ;00
	..set tSC=soapObj.AcceptDicInfo("MES0071",Instream)
	..do tSC.OutputToDevice()
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("SS_User",tSC)
	..set count=1
	..do plist.Clear()
	
#;	set length=plist.Count()
#;	if length>0 d
#;	.set Instream=..GetSSUserByID(plist)
#;	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
#;	.do tSC.OutputToDevice()
#;	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("SS_User",tSC)
	Quit tSC.Read()
Exception
	Quit -1_$ze
}

/// 根据ID号列表取字典信息
/// Creator：luofanyu
/// CreatDate：2018—10-30
/// Description：用户字典信息
/// Table：CT_Loc
/// Input： 
/// Return：用户字典信息集合
ClassMethod GetSSUserByID0(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set RowId=pList.GetAt(i)
		set insObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.SSUser).%New()
		set insObj.SSUSRId=$p($g(^SSU("SSUSR",RowId)),"^",1)
		set insObj.SSUSRName=$p($g(^SSU("SSUSR",RowId)),"^",2)
		do insObj.XMLExportToString(.b)
		w b,!
		d ListInfo.SSUser.Insert(insObj)
	}
	d ListInfo.XMLExportToString(.String)
	;set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/SSUserList",.Jsonobj)
#;	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/SSUser",.Jsonobj)
#;	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
#;	set JsonString=$tr(JsonString,$c(13),"")
#;	set JsonString=$tr(JsonString,$c(10),"")
#;	set OutStream=##class(%GlobalCharacterStream).%New()
#;	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("SS_User",JsonString)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("SS_User",JsonString)

	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// set a=##class(web.DHCENS.STBLL.DICTNew.METHOD.SSUser).GetSSUser("1")
ClassMethod GetSSUser(Input As %String = "") As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set stream=##class(%GlobalCharacterStream).%New()		
	set request=##class(web.DHCENS.STBLL.DICTNew.MODEL.Request).%New()
	set body=##class(web.DHCENS.STBLL.DICTNew.MODEL.Body).%New()
	
	set RowId=Input
	set insObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.SSUser).%New()
	set insObj.SSUSRId=$p($g(^SSU("SSUSR",RowId)),"^",1)
	set insObj.SSUSRName=$p($g(^SSU("SSUSR",RowId)),"^",2)
	set locRowid=$p($g(^SSU("SSUSR",RowId)),"^",4)
	set insObj.SSUSRSecuGroupCode=$p($g(^SSU("SSUSR",RowId)),"^",5)
	if locRowid'=""{
		//set insObj.SSUSRDeptCode=$p($g(^CTLOC(locRowid)),"^",1)
		set locInfo=^CTLOC(locRowid)
		set locCode1=$p(locInfo,"^",1)
		set locCode2=$p(locInfo,"^",41)
		set insObj.SSUSRDeptCode=locCode2
		set:locCode2="" insObj.SSUSRDeptCode=locCode1
	}else{
		set insObj.SSUSRDeptCode=""
	}
	
	d body.ssuser.Insert(insObj)
	set request.body=body

	d request.XMLExportToStream(.stream)
	Quit stream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

ClassMethod GetSSUserByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set request=##class(web.DHCENS.STBLL.DICTNew.MODEL.Request).%New()
	set body=##class(web.DHCENS.STBLL.DICTNew.MODEL.Body).%New()

	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()

	for i=1:1:pList.Count()
	{
		set RowId=pList.GetAt(i)
		set insObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.SSUser).%New()
		set insObj.SSUSRId=$p($g(^SSU("SSUSR",RowId)),"^",1)
		set insObj.SSUSRName=$p($g(^SSU("SSUSR",RowId)),"^",2)
		set locRowid=$p($g(^SSU("SSUSR",RowId)),"^",4)
		set insObj.SSUSRSecuGroupCode=$p($g(^SSU("SSUSR",RowId)),"^",5)
		if locRowid'=""{
			//set insObj.SSUSRDeptCode=$p($g(^CTLOC(locRowid)),"^",1)
			set locInfo=^CTLOC(locRowid)
			set locCode1=$p(locInfo,"^",1)
			set locCode2=$p(locInfo,"^",41)
			set insObj.SSUSRDeptCode=locCode2
			set:locCode2="" insObj.SSUSRDeptCode=locCode1
		}else{
			set insObj.SSUSRDeptCode=""
		}
		
		d body.ssuser.Insert(insObj)
	}
	set request.body=body

	d request.XMLExportToStream(.stream)
	Quit stream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

}
