Class web.DHCENS.STBLL.DICTNew.METHOD.CTBed Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：luofanyu
/// CreatDate：2018-11-01
/// Description：查询HIS中床位字典信息
/// Table：pac_bed
/// Input： 床位字典
/// Return：床位字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTBed).SendCTBed("")
ClassMethod SendCTBed(Input As %String) As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set wardID=0  for  set wardID=$o(^PAWARD(wardID)) Quit:wardID=""  d
	.set bedId=0  for  set bedId=$o(^PAWARD(wardID,"BED",bedId)) Quit:bedId=""  d
	..set rowid=wardID_"||"_bedId
	..do plist.SetAt(rowid,count)
	..set count=count+1
	..if count>50 do
	...set Instream=..GetCTBedByID(plist)
	...set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	...do tSC.OutputToDevice()
	...set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_Bed",tSC)
	...set count=1
	...do plist.Clear()
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTBedByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.do tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_Bed",tSC)
	Quit tSC.Read()
Exception
	Quit -1_$ze
}

/// Creator：luofanyu
/// CreatDate：2018-11-01
/// Description：查询HIS中床位字典信息
/// Table：pac_bed
/// Input： 
/// Return：床位字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTBed).CTBed("")
ClassMethod GetCTBedByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set wardId=$p(rowid,"||",1)
		set bedId=$p(rowid,"||",2)
		set bedInfo=$g(^PAWARD(wardId,"BED",bedId))
		set bedObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTBed).%New()
		set bedObj.businessrowid=rowid
		//set bedObj.CTBCode=$p(bedInfo,"^",1)
		set bedObj.CTBCode=$p(bedInfo,"^",1)
		set bedObj.CTBDesc=$p(bedInfo,"^",1)
		set bedObj.CTBCodesystemCode="CT_Bed"
		set locId=$p($g(^PAWARD(wardId)),"^",5)
		Continue:locId=""
		set hospId=$p(^CTLOC(locId),"^",22)
		set:hospId="" hospId=$o(^CT("HOSP","0"))
		set hospCode=$p(^CT("HOSP",hospId),"^",1)	
		set bedObj.CTBHosCode=hospId  //hospCode
		set roomId=$p(bedInfo,"^",3)
		set bedObj.CTBRoomCode=roomId //$p($g(^PAROOM(roomId)),"^",1)
		set bedObj.CTBRemarks="无"
		set bedObj.CTBStatus="1"
		set bedObj.CTBUpdateUserCode="无"
		set bedObj.CTBWardCode=wardId //$p($g(^PAWARD(wardId)),"^",1)
		set bedTyId=$p(bedInfo,"^",2)
		set:bedTyId="" bedTyId="3"
		set StartDate=$p(bedInfo,"^",21)
		set:StartDate="" StartDate=61360
		set bedObj.CTBStartDate=StartDate
		set bedObj.CTBBedType=bedTyId //$p($g(^PAC("BEDTP",bedTyId)),"^",1)
		d ListInfo.CTBed.Insert(bedObj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTBed",.Jsonobj)
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_Bed",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// Creator：ZhangXinying
/// CreatDate：2018-09-15
/// Description：
/// Table：pac_bed
/// Input： 
/// Return：根据rowid床位字典信息集合，ODS用
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTBed).GetCTBed("1||1").Read()
ClassMethod GetCTBed(Input As %String) As %GlobalCharacterStream
{
	set $zt="Exception"	
	set OutputStream=##class(%GlobalCharacterStream).%New()
	set length=$l(Input,"^")
	set pList=##class(%ArrayOfDataTypes).%New()
	for i=1:1:length{
		set rowid=$p(Input,"^",i)
		do pList.SetAt(rowid,i)
	}
	if pList.Count()>0{
		set OutputStream=..GetCTBedByID(pList)
	}
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write("-1^"_$ze)
	Quit stream
}

}
