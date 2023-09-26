Class web.DHCENS.STBLL.DICTNew.METHOD.CTDeptHierarchy Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：haochenguang
/// CreatDate：2018-09-15
/// Description：
/// Table：
/// Input： 
/// Return：科室层级关系集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDeptHierarchy).CTDeptHierarchy("1").Read()
ClassMethod CTDeptHierarchy(input As %String = "") As %GlobalCharacterStream
{
	s success=0
	set $zt="Exception"
	s ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	s soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set rowid="0" f  set rowid=$o(^CTLOC(rowid)) q:rowid=""  d
	.Quit:((rowid'=input)&&(input'=""))
    .set info=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDept).GetFirstGradeDept(rowid)
	.set Obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTDeptHierarchy).%New()
	.set Obj.CTDHCode=$p(info,"^",2)
	.set Obj.CTDHDesc=$p(info,"^",3)
	.set Obj.CTDHClass=$p(info,"^",5)
	.set Obj.CTDHCodesystemCode="CT_DeptHierarchy"
	.set Obj.CTDHRemarks=""
	.set Obj.CTDHStatus="1"
	.set Obj.CTDHUpdateUserCode="无"
	.s hospId=$o(^CT("HOSP","0"))
	.s hospCode=$p(^CT("HOSP",hospId),"^",1)	
	.s Obj.CTDHHosCode=hospCode
	.d ListInfo.CTDeptHierarchy.Insert(Obj)
	.set count=ListInfo.CTDeptHierarchy.Count()
	.if count>100 d
	..d ListInfo.XMLExportToString(.String)
	..set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTDeptHierarchy",.Jsonobj)
	..set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	..set Instream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_DeptHierarchy",JsonString)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..d ListInfo.CTRoom.Clear()
	..set count=0
	..set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
	..if resultCode=0 d
	...set success=0
	..else  d
	...set success=-1
	
	if count>0 {
		d ListInfo.XMLExportToString(.String)
		set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTDeptHierarchy",.Jsonobj)
		set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
		set Instream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_DeptHierarchy",JsonString)
		set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
		set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
		if resultCode=0 d
		.set success=0
		else  d
		.set success=-1
	}
	quit success
Exception
	quit "-1^"_$ze
}

/// Creator：haochenguang
/// CreatDate：2018-09-15
/// Description：
/// Table：
/// Input： 
/// Return：科室层级关系集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDeptHierarchy).GetCTDeptHierarchy("90").Read()
ClassMethod GetCTDeptHierarchy(Input As %String = "") As %GlobalCharacterStream
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
		set OutputStream=..GetCTDeptHierarchyByID(pList)
	}
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：通过Array集合返回科室层级关系密文流
/// Table：RBC_Hierarchy
/// Input： Array集合
/// Return：科室层级关系密文流获取
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOperationRoom).GetCTDeptHierarchyByID()
ClassMethod GetCTDeptHierarchyByID(plist As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	s $zt="Err"
	s count=plist.Count()
	s ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	f i=1:1:count
	{
		s rowid=plist.GetAt(i)
		set info=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDept).GetFirstGradeDept(rowid)
		set Obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTDeptHierarchy).%New()
		set Obj.CTDHCode=$p(info,"^",2)
		q:Obj.CTDHCode=""
		set Obj.CTDHDesc=$p(info,"^",3)
		set Obj.CTDHClass=$p(info,"^",5)
		set Obj.CTDHCodesystemCode="CT_DeptHierarchy"
		set Obj.CTDHRemarks=""
		set Obj.CTDHStatus="1"
		set Obj.CTDHUpdateUserCode="无"
		s hospId=$o(^CT("HOSP","0"))
		s hospCode=$p(^CT("HOSP",hospId),"^",1)	
		s Obj.CTDHHosCode=hospCode
		d ListInfo.CTDeptHierarchy.Insert(Obj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTDeptHierarchy",.Jsonobj)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	s RtnStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_DeptHierarchy",JsonString)
	Quit RtnStream
Err
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：科室层级关系字典信息
/// Table：
/// Input： 科室层级关系字典
/// Return：科室层级关系字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDeptHierarchy).SendCTDeptHierarchy("")
ClassMethod SendCTDeptHierarchy(input As %String = "") As %String
{
	s $zt="Err"
	s plist=##class(%ArrayOfDataTypes).%New()
	s Instream=##class(%GlobalCharacterStream).%New()
	s tSC=##class(%GlobalCharacterStream).%New()
	s soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	s count=1
	s rowid="0" for  s rowid=$o(^CTLOC(rowid)) q:rowid=""  d
	.d plist.SetAt(rowid,count)
	.s count=count+1
	.if count>200 d
	..set Instream=..GetCTDeptHierarchyByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_DeptHierarchy",tSC)
	..d tSC.OutputToDevice()
	..d Instream.Clear()
	..s count=1
	..d plist.Clear()
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTDeptHierarchyByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.d tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_DeptHierarchy",tSC)

	q sc
Err
	q "-1^"_$ze
}

}
