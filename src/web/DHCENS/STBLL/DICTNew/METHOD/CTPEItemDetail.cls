Class web.DHCENS.STBLL.DICTNew.METHOD.CTPEItemDetail Extends (%RegisteredObject, %XML.Adaptor)
{

/// Description：体检项目明细字典信息
/// Table：DHC_PE_OrderDetail
/// Input： 
/// Return：体检项目明细字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPEItemDetail).GetCTPEItemDetail("1").Read()
ClassMethod GetCTPEItemDetail(Input As %String = "") As %GlobalCharacterStream
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
		set OutputStream=..GetCTPEItemDetailByID(pList)
	}
	Quit OutputStream
Exception
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：通过Array集合返回体检项目明细字典密文流
/// Table：
/// Input： Array集合
/// Return：体检项目明细字典密文流获取
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPEItem).GetCTPEItemDetailByID()
ClassMethod GetCTPEItemDetailByID(plist As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	s $zt="Err"
	s count=plist.Count()
	s ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	f i=1:1:count
	{
		set rowid=plist.GetAt(i)
		set Obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTPEItemDetail).%New()
		set Str=$g(^DHCPEODR(rowid))
		set ArcimDr=$p(Str,"^",1),ODRODDr=$p(Str,"^",2)
		set ArmSub=$p(ArcimDr,"||",1),ArmVer=$p(ArcimDr,"||",2)
		set StationId=$p(ODRODDr,"||",1),ODChildID=$p(ODRODDr,"||",2)
		set Obj.businessrowid=ODRODDr
		set Obj.CTPEIDCode=$p($g(^DHCPEST(StationId,"OD",ODChildID)),"^",11)
		set Obj.CTPEIDDesc=$p($g(^DHCPEST(StationId,"OD",ODChildID)),"^",1)
		set Obj.CTPEIDCodesystemCode="CT_PEItemDetail"
		//set Obj.CTPEIDParentCode=ArcimDr ; $p($g(^ARCIM(ArmSub,ArmVer,1)),"^",1)
		set Obj.CTPEIDParentCode=$p(Str,"^",5)
		set Obj.CTPEIDRemarks=""
		set Obj.CTPEIDStatus="1"
		set Obj.CTPEIDUpdateUserCode="无"
		set hospId=$o(^CT("HOSP","0")),hospCode=""
		set:hospId'="" hospCode=$p($g(^CT("HOSP",hospId)),"^",1)
		set Obj.CTPEIDHosCode=hospId ;hospCode
		d ListInfo.CTPEItemDetail.Insert(Obj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTPEItemDetail",.Jsonobj)
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)	
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	s RtnStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_PEItemDetail",JsonString)
	Quit RtnStream
Err
	b ;errro
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：推送体检项目明细字典
/// Table：
/// Input： 
/// Return：体检项目明细字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPEItemDetail).SendCTPEItemDetail("")
ClassMethod SendCTPEItemDetail(input As %String = "") As %String
{
	s $zt="Err"
	s plist=##class(%ArrayOfDataTypes).%New()
	s Instream=##class(%GlobalCharacterStream).%New()
	s tSC=##class(%GlobalCharacterStream).%New()
	s soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	s count=1
	s ArcimDr="" f  s ArcimDr=$o(^DHCPEODR(0,"ARCIM",ArcimDr)) q:ArcimDr=""  d
	.s rowid="" f  s rowid=$o(^DHCPEODR(0,"ARCIM",ArcimDr,rowid)) q:rowid=""  d
	..d plist.SetAt(rowid,count)
	..s count=count+1
	..if count>50 d
	...set Instream=..GetCTPEItemDetailByID(plist)
	...set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	...set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_PEItemDetail",tSC)
	...d tSC.OutputToDevice()
	...d Instream.Clear()
	...s count=1
	...d plist.Clear()
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTPEItemDetailByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.d tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_PEItemDetail",tSC)
	q sc
Err
	q "-1^"_$ze
}

}
