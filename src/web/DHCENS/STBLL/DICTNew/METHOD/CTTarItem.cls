Class web.DHCENS.STBLL.DICTNew.METHOD.CTTarItem Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：ZhangXinying
/// CreatDate：2018—09-10
/// Description：收费项字典信息
/// Table：DHC_TarItem
/// Input： 
/// Return：收费项字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTTarItem).CTTarItem("")
ClassMethod CTTarItem(input As %String = "") As %String
{
	set $zt="Exception"
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()	
	set SuccessFlag="0"
	set rowid="0" f  set rowid=$o(^DHCTARI(rowid)) q:rowid=""  d
	.Quit:((rowid'=input)&&(input'=""))
	.set insObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTTarItem).%New()
	.set insObj.CTCICode=$p($g(^DHCTARI(rowid)),"^",1)
	.set insObj.CTCIDesc=$p($g(^DHCTARI(rowid)),"^",2)
	.set CtUomDr=$p($g(^DHCTARI(rowid)),"^",3)
	.set:CtUomDr'="" insObj.CTCIUnitCode=$P($G(^CT("UOM",CtUomDr)),"^",1)
	.set tarCateSubRowid=$p($g(^DHCTARI(rowid)),"^",4)
	.set:tarCateSubRowid'="" insObj.CTCICCCode=$p($g(^DHCTarC("SC",tarCateSubRowid)),"^",1)
	.set tarIPCateSubRowid=$p($g(^DHCTARI(rowid)),"^",14)
	.set:tarIPCateSubRowid'="" insObj.CTCIIPCCCode=$p($g(^DHCTarC("IC",tarIPCateSubRowid)),"^",1)
	.set tarOPCateSubRowid=$p($g(^DHCTARI(rowid)),"^",15)
	.set:tarOPCateSubRowid'="" insObj.CTCIOPCCCode=$p($g(^DHCTarC("OC",tarOPCateSubRowid)),"^",1)
	.set tarEMCateSubRowid=$p($g(^DHCTARI(rowid)),"^",16)
	.set:tarEMCateSubRowid'="" insObj.CTCIEMCCCode=$p($g(^DHCTarC("EC",tarEMCateSubRowid)),"^",1)
	.set tarACCateSubRowid=$p($g(^DHCTARI(rowid)),"^",5)
	.set:tarACCateSubRowid'="" insObj.CTCIACCCCode=$p($g(^DHCTarC("AC",tarACCateSubRowid)),"^",1)
	.set tarMRCateSubRowid=$p($g(^DHCTARI(rowid)),"^",6)
	.set:tarMRCateSubRowid'="" insObj.CTCIMRCCCode=$p($g(^DHCTarC("MC",tarMRCateSubRowid)),"^",1)
	.set tarMRNewCateSubRowid=$p($g(^DHCTARI(rowid)),"^",30)
	.set:tarMRNewCateSubRowid'="" insObj.CTCIMRCCCodeNew=$p($g(^DHCTarC("MCNew",tarMRNewCateSubRowid)),"^",1)
	.set insObj.CTCIAnoName=$p($g(^DHCTARAL(rowid)),"^",3)
	.set insObj.CTCICodesystemCode="CT_ChargeItem"
	.set insObj.CTCIRemarks="无"
	.set insObj.CTCIStatus="1"
	.set insObj.CTCIUpdateUserCode="无"
	.set insObj.CTCIUpdateDate=$zd(+$h,3)
	.set insObj.CTCIUpdateTime=$zt($p($h,",",2))

	.d ListInfo.CTChargeItem.Insert(insObj)
	.set count=ListInfo.CTChargeItem.Count()
	.if count>200 d
	..d ListInfo.XMLExportToString(.String)
	..set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTChargeItem",.Jsonobj)
	..set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	..set Instream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_ChargeItem",JsonString)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..d ListInfo.CTChargeItem.Clear()
	..set count=0
	..set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
	..if resultCode=0 d
	...set success=0
	..else  d
	...set success=-1
	
	if count>0 {
		d ListInfo.XMLExportToString(.String)
		set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTChargeItem",.Jsonobj)
		set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
		set Instream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_ChargeItem",JsonString)
		set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
		set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
		if resultCode=0 d
		.set success=0
		else  d
		.set success=-1
	}
	quit success
Exception
	quit "-1"_$ze
}

/// Creator：ZhangXinying
/// CreatDate：2018—09-10
/// Description：收费项字典信息
/// Table：CT_TarItem
/// Input： 
/// Return：收费项字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTTarItem).GetCTTarItem("1").Read()
ClassMethod GetCTTarItem(Input As %String = "") As %GlobalCharacterStream
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
		set OutputStream=..GetCTTarItemByID(pList)
	}
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：发送HIS中收费项字典信息
/// Table：CT_TarItem
/// Input： 收费项字典
/// Return：收费项字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTTarItem).SendCTTarItem("")
ClassMethod SendCTTarItem(input As %String = "") As %String
{
	s $zt="Err"
	s plist=##class(%ArrayOfDataTypes).%New()
	s Instream=##class(%GlobalCharacterStream).%New()
	s tSC=##class(%GlobalCharacterStream).%New()
	s soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	s count=1
	s rowid="0" for  s rowid=$o(^DHCTARI(rowid)) q:rowid=""  d	
	.set code=$p($g(^DHCTARI(rowid)),"^",1)
	.;if code="" do
	..;set ^tmpwyr("chargeItem",rowid)=""
	.q:code=""
	.d plist.SetAt(rowid,count)
	.s count=count+1
	.if count>20 d
	..set Instream=..GetCTTarItemByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..d tSC.OutputToDevice()	
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_ChargeItem",tSC)
	..;b ;00	
	..d Instream.Clear()
	..s count=1
	..d plist.Clear()
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTTarItemByID(plist)
	.;w Instream.Read()
	.;do Instream.Rewind()
	.;do fileObj.Write($c(13)_$c(10))
    .;do fileObj.Write($c(13)_$c(10))
    .;do fileObj.Write($c(13)_$c(10)_"last"_"###")
    .;do fileObj.Write($c(13)_$c(10))
    .;do fileObj.Write(Instream.Read())
	.;do Instream.Rewind()
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
    .;do fileObj.Write($c(13)_$c(10))
    .;do fileObj.Write($c(13)_$c(10))
    .;do fileObj.Write(tSC.Read())
	.d tSC.OutputToDevice()
	
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_ChargeItem",tSC)
	
#;	do fileObj.%Save()
	q "1"
Err
	q "-1^"_$ze
}

/// Creator: ZhangXinying
/// Description：通过Array集合返回病区字典密文流
/// Table：DHC_ANC_OperRoom
/// Input： Array集合
/// Return：病区字典密文流获取
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTTarItem).GetCTTarItemByID()
ClassMethod GetCTTarItemByID(plist As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	s $zt="Err"
	s count=plist.Count()
	s ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	f i=1:1:count
	{
		s rowid=plist.GetAt(i)
		s insObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTTarItem).%New()
		set insObj.businessrowid=rowid
		set insObj.CTCICode=$p($g(^DHCTARI(rowid)),"^",1)		
		set insObj.CTCIDesc=$p($g(^DHCTARI(rowid)),"^",2)
		set CtUomDr=$p($g(^DHCTARI(rowid)),"^",3)
		set:CtUomDr'="" insObj.CTCIUnitCode=CtUomDr //$P($G(^CT("UOM",CtUomDr)),"^",1)
		set tarCateSubRowid=$p($g(^DHCTARI(rowid)),"^",4)
		set:tarCateSubRowid'="" insObj.CTCICCCode=tarCateSubRowid //$p($g(^DHCTarC("SC",tarCateSubRowid)),"^",1)
		set tarIPCateSubRowid=$p($g(^DHCTARI(rowid)),"^",14)
		set:tarIPCateSubRowid'="" insObj.CTCIIPCCCode=tarIPCateSubRowid //$p($g(^DHCTarC("IC",tarIPCateSubRowid)),"^",1)
		set tarOPCateSubRowid=$p($g(^DHCTARI(rowid)),"^",15)
		set:tarOPCateSubRowid'="" insObj.CTCIOPCCCode=tarOPCateSubRowid //$p($g(^DHCTarC("OC",tarOPCateSubRowid)),"^",1)
		set tarEMCateSubRowid=$p($g(^DHCTARI(rowid)),"^",16)
		set:tarEMCateSubRowid'="" insObj.CTCIEMCCCode=tarEMCateSubRowid //$p($g(^DHCTarC("EC",tarEMCateSubRowid)),"^",1)
		set tarACCateSubRowid=$p($g(^DHCTARI(rowid)),"^",5)
		set:tarACCateSubRowid'="" insObj.CTCIACCCCode=tarACCateSubRowid //$p($g(^DHCTarC("AC",tarACCateSubRowid)),"^",1)
		set tarMRCateSubRowid=$p($g(^DHCTARI(rowid)),"^",6)
		set:tarMRCateSubRowid'="" insObj.CTCIMRCCCode=tarMRCateSubRowid //$p($g(^DHCTarC("MC",tarMRCateSubRowid)),"^",1)
		set tarMRNewCateSubRowid=$p($g(^DHCTARI(rowid)),"^",30)
		set:tarMRNewCateSubRowid'="" insObj.CTCIMRCCCodeNew=tarMRNewCateSubRowid //$p($g(^DHCTarC("MCNew",tarMRNewCateSubRowid)),"^",1)
		set insObj.CTCIAnoName=$p($g(^DHCTARAL(rowid)),"^",3)
		set:insObj.CTCIAnoName="" insObj.CTCIAnoName="无"
		set insObj.CTCICodesystemCode="CT_ChargeItem"
		set insObj.CTCIRemarks="无"
		set insObj.CTCICCHCode="无"
		set insObj.CTCICCode="无"
		set insObj.CTCIStatus="1"
		set insObj.CTCIUpdateUserCode="无"
		set insObj.CTCIUpdateDate=$zd(+$h,3)
		set insObj.CTCIUpdateTime=$zt($p($h,",",2))
		set insObj.CTCIStartDate=$p($g(^DHCTARI(rowid)),"^",11)
		if $p($g(^DHCTARI(rowid)),"^",11)="" {
			set TPRowId=0,TPStartDate=""
			f  set TPRowId=$o(^DHCTARI(rowid,"P",TPRowId)) q:(TPRowId="")||(TPStartDate'="")  d
			.set TPStartDate=$p(^DHCTARI(rowid,"P",TPRowId),"^",3)
			.q:TPStartDate="" 
			.set insObj.CTCIStartDate=TPStartDate
			i TPStartDate="" set insObj.CTCIStartDate=62594   //2012-05-17
		}
		d ListInfo.CTChargeItem.Insert(insObj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTChargeItem",.Jsonobj)
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)	
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	s RtnStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).GetMainDataManager("CT_ChargeItem",JsonString)
	Quit RtnStream
Err
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

}
