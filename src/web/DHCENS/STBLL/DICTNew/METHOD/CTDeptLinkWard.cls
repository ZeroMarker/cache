Class web.DHCENS.STBLL.DICTNew.METHOD.CTDeptLinkWard Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator: haochenguang
/// Description：查询HIS科室病区关联字典信息
/// Table：his无相关表
/// Input： 
/// Return：科室病区关联字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDeptLinkWard).GetCTDeptLinkWard("1").Read()
ClassMethod GetCTDeptLinkWard(Input As %String = "") As %GlobalCharacterStream
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
		set OutputStream=..GetCTDeptLinkWardByID(pList)
	}
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：通过Array集合返回科室病区关联字典密文流
/// Table：
/// Input： Array集合
/// Return：科室病区关联字典密文流获取
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDeptLinkWard).GetCTDeptLinkWardByID()
ClassMethod GetCTDeptLinkWardByID(plist As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	s $zt="Err"
	s count=plist.Count()
	s ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	f i=1:1:count
	{
		s rowid=plist.GetAt(i)
		s oprInfo=$g(^PAWARD(rowid))
		q:oprInfo=""
		s oprObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTDeptLinkWard).%New()
		s deptDr=$p(oprInfo,"^",5)
		s oprObj.CTDLWLinkId=rowid_"||"_deptDr
		s oprObj.CTDLWDeptCode=deptDr
		s oprObj.CTDLWWardCode=rowid	
		s oprObj.CTDLWDesc=$p(oprInfo,"^",2)
		s oprObj.CTDLWCodesystemCode="CT_DeptLinkWard"
		s oprObj.CTDLWRemarks="无"
		s activeFlag=$p(oprInfo,"^",6)
		s:activeFlag="Y" oprObj.CTDLWStatus="1"
		s:activeFlag="N" oprObj.CTDLWStatus="0"
		s oprObj.CTDLWUpdateUserCode="无"
		s hospId=$p($g(^CTLOC(deptDr)),"^",22)
		s oprObj.CTDLWHosCode=hospId
		s oprObj.businessrowid=rowid_"||"_deptDr
		d ListInfo.CTDeptLinkWard.Insert(oprObj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTDeptLinkWard",.Jsonobj)
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	set RtnStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_DeptLinkWard",JsonString)
	Quit RtnStream
Err
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：推送科室病区关联字典
/// Table：
/// Input： 科室病区关联字典
/// Return：科室病区关联字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDeptLinkWard).SendCTDeptLinkWard("")
ClassMethod SendCTDeptLinkWard(input As %String = "") As %String
{
	s $zt="Err"
	s plist=##class(%ArrayOfDataTypes).%New()
	s Instream=##class(%GlobalCharacterStream).%New()
	s tSC=##class(%GlobalCharacterStream).%New()
	s soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	s count=1
	s rowid=0 f  s rowid=$o(^PAWARD(rowid)) q:rowid=""  d
	.d plist.SetAt(rowid,count)
	.s count=count+1
	.if count>0 d
	..set Instream=..GetCTDeptLinkWardByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_DeptLinkWard",tSC)
	..d tSC.OutputToDevice()
	..d Instream.Clear()
	..s count=1
	..d plist.Clear()
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTDeptLinkWardByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.d tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_DeptLinkWard",tSC)
	q sc
Err
	q "-1^"_$ze
}

}
