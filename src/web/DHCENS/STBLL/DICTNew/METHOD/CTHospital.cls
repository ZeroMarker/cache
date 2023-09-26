Class web.DHCENS.STBLL.DICTNew.METHOD.CTHospital Extends (%RegisteredObject, %XML.Adaptor)
{

/// ODS根据ID导入字典
/// Creator：luofanyu
/// CreatDate：2018—10-30
/// Description：医院字典信息
/// Table：CT_Hospital
/// Input： 
/// Return：医院字典信息集合
/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTHospital).GetCTHospital("2^3").Read()
ClassMethod GetCTHospital(Input As %String = "") As %GlobalCharacterStream
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
		set OutputStream=..GetHospitalByID(pList)
	}
	d OutputStream.Rewind()
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// 初始化导入数据时批量导入字典
/// Creator：luofanyu
/// CreatDate：2018—10-30
/// Description：医院字典信息
/// Table：CT_Hospital
/// Input： 
/// Return：医院字典信息集合
/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTHospital).SendCTHospital("")
ClassMethod SendCTHospital(Input As %String = "") As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set count=1
	set hospId="0"  for  set hospId=$o(^CT("HOSP",hospId)) q:hospId=""  d
	.do plist.SetAt(hospId,count)
	.set count=count+1
	set stream=##class(%GlobalCharacterStream).%New()
	set stream=..GetHospitalByID(plist)
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set tSC=soapObj.AcceptDicInfo("MES0001",stream)
	set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_Hospital",tSC)
	d tSC.OutputToDevice()
	Quit sc
Exception
	Quit "-1^"_$ze
}

/// 根据ID号列表取字典信息
/// Creator：luofanyu
/// CreatDate：2018—10-30
/// Description：医院字典信息
/// Table：CT_Hospital
/// Input： 
/// Return：医院字典信息集合
/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTHospital).GetHospitalByID("")
ClassMethod GetHospitalByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set hospInfo=$g(^CT("HOSP",rowid))
		set hospObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTHospital).%New()
		set hospObj.businessrowid=rowid
		set hospObj.CTHRowId=rowid
		set hospObj.CTHCode=$p(hospInfo,"^",1)
		set hospObj.CTHDesc=$p(hospInfo,"^",2)
		set hospObj.CTHNationalCode=$p(hospInfo,"^",1)
		set startdate=$p(hospInfo,"^",9)
		Continue:startdate=""
		set hospObj.CTHStartDate=startdate
		set enddate=$p(hospInfo,"^",10)
		Continue:startdate=""
		set hospObj.CTHEndDate=enddate
		set hospObj.CTHCodesystemCode="CT_Hospital"
		set CTHOrganizationCode=$p(hospInfo,"^",7)
		set:CTHOrganizationCode="" CTHOrganizationCode=$p(hospInfo,"^",1)
		set hospObj.CTHOrganizationCode=CTHOrganizationCode
		set hospObj.CTHNationalCode=$p(hospInfo,"^",1)
		set hospObj.CTHRemarks="无"
		set:enddate="" hospObj.CTHStatus="1"
		set:enddate'="" hospObj.CTHStatus="0"
		set hospObj.CTHUpdateUserCode="无"
		d ListInfo.CTHospital.Insert(hospObj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTHospital",.Jsonobj)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_Hospital",JsonString)
	w OutStream.Read(),!
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

}
