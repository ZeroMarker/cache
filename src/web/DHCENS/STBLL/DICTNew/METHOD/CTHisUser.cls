Class web.DHCENS.STBLL.DICTNew.METHOD.CTHisUser Extends (%RegisteredObject, %XML.Adaptor)
{

/// ODS根据ID导入字典
/// Creator：wangyaru
/// CreatDate：2020—03-09
/// Description：HIS用户字典信息
/// Table：SS_User
/// Input： rowid^rowid^...
/// Return：HIS用户字典信息集合
/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTHisUser).GetCTHisUser("1").Read()
ClassMethod GetCTHisUser(Input As %String = "") As %GlobalCharacterStream
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
		set OutputStream=..GetCTHisUserByID(pList)
	}
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// Creator：wangyaru
/// CreatDate：2020—03-09
/// Description：查询HIS中HIS用户字典信息
/// Table：SS_User
/// Input： 
/// Return：HIS用户字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTHisUser).SendCTHisUser("")
ClassMethod SendCTHisUser(Input As %String) As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set rowid="0"  for  set rowid=$o(^SSU("SSUSR",rowid)) Quit:(rowid="")  d
	.do plist.SetAt(rowid,count)
	.set count=count+1
	.if count>50 d
	..set Instream=..GetCTHisUserByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_HisUser",tSC)
	..d tSC.OutputToDevice()
	..d Instream.Clear()
	..d plist.Clear()
	..s count=1
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTHisUserByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.d tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_HisUser",tSC)
	
	q "0" 
Exception
	Quit -1_$ze
}

/// Creator：wangyaru	
/// CreatDate：2020—03-09
/// Description：查询HIS中HIS用户字典信息
/// Table：SS_User
/// Input： 
/// Return：HIS用户字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTHisUser).GetCTHisUserByID("")
ClassMethod GetCTHisUserByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set RowId=pList.GetAt(i)
		set hisUserObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTHisUser).%New()
		set hisUserObj.businessrowid=RowId
		set hisUserObj.CTHUId=$p($g(^SSU("SSUSR",RowId)),"^",1)
		set locRowid=$p($g(^SSU("SSUSR",RowId)),"^",4)
		if locRowid'=""{
			set locInfo=^CTLOC(locRowid)
			set locCode1=$p(locInfo,"^",1)
			set locCode2=$p(locInfo,"^",41)
			set hisUserObj.CTHUDeptCode=locCode2
			;set:locCode2="" hisUserObj.CTHUDeptCode=locCode1
			set:locCode2="" hisUserObj.CTHUDeptCode=locRowid
		}else{
			set hisUserObj.CTHUDeptCode=""
		}
		set hisUserObj.CTHUSecuGroupCode=$p($g(^SSU("SSUSR",RowId)),"^",5)
		set hisUserObj.CTHUName=$p($g(^SSU("SSUSR",RowId)),"^",2)
		set hisUserObj.CTHUCodesystemCode="CT_HisUser"
		set hisUserObj.CTHUStartDate=$p($g(^SSU("SSUSR",RowId)),"^",96)
		set hisUserObj.CTHUEndDate=$p($g(^SSU("SSUSR",RowId)),"^",97)
		set hospId=$p($g(^SSU("SSUSR",RowId)),"^",98)
		;set:hospId'="" hisUserObj.CTHUHosCode=$p(^CT("HOSP",hospId),"^",1)
		set hisUserObj.CTHUHosCode=hospId
		set hisUserObj.CTHUPhoneNum=$p($g(^SSU("SSUSR",RowId)),"^",99)
		set hisUserObj.CTHUEmail=$p($g(^SSU("SSUSR",RowId)),"^",101)
		set hisUserObj.CTHUCreatDate=$p($g(^SSU("SSUSR",RowId)),"^",115)
		set hisUserObj.CTHUCreatTime=$p($g(^SSU("SSUSR",RowId)),"^",116)
		
		set hisUserObj.CTHUUpdateUserCode=""
		set updateUserId=$p($g(^SSU("SSUSR",RowId)),"^",75)
		set:updateUserId'="" hisUserObj.CTHUUpdateUserCode=$p($g(^SSU("SSUSR",updateUserId)),"^",1)
		set hisUserObj.CTHUUpdateDate=$p($g(^SSU("SSUSR",RowId)),"^",76)
		set hisUserObj.CTHUUpdateTime=$p($g(^SSU("SSUSR",RowId)),"^",77)
		
		set hisUserObj.CTHURemarks="无"
		set isActive=$p($g(^SSU("SSUSR",RowId)),"^",19)
		set:isActive="Y" hisUserObj.CTHUStatus="1"
		set:isActive="N" hisUserObj.CTHUStatus="0"
		set hisUserObj.CTHUCareProvID=$p($g(^SSU("SSUSR",RowId)),"^",14)
		d ListInfo.CTHisUser.Insert(hisUserObj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTHisUser",.Jsonobj)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_HisUser",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

}
