Class web.DHCENS.STBLL.DICTNew.METHOD.CTARCItmMast Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：luofanyu
/// CreatDate：2018-11-02
/// Description：查询HIS中医嘱项目信息
/// Table：ARC_ItmMast
/// Input： 医嘱项目字典
/// Return：医嘱项目信息
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTARCItmMast).SendCTARCItmMast("")
ClassMethod SendCTARCItmMast(Input As %String) As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1,num=0
	if Input=""{
		set OrCatRowId="" f  set OrCatRowId=$o(^OEC("ORCAT",OrCatRowId)) q:OrCatRowId=""  d
		.set ArcIcRowId="" f  set ArcIcRowId=$o(^ARC("IC",0,"OrdCat",OrCatRowId,ArcIcRowId)) q:(ArcIcRowId="")  d 
		..set ArmSub=""  f  set ArmSub=$O(^ARCIM(0,"ARCIC_DR",ArcIcRowId,ArmSub)) q:ArmSub=""  d
		...set ArmVer=""  f  set ArmVer=$O(^ARCIM(0,"ARCIC_DR",ArcIcRowId,ArmSub,ArmVer))  q:ArmVer=""  d
		....set rowid=ArmSub_"||"_ArmVer_"^"_ArcIcRowId
		....do plist.SetAt(rowid,count)
		....set count=count+1
		....if count>20 do
		.....set Instream=..GetCTARCItmMastByID(plist)
		.....set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
		.....;b ;000
		.....do tSC.OutputToDevice()
		.....set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CTARCItmMast",tSC)
		.....set num=num+1
		.....;b ;000
		.....;w !,num_","_rowid
		.....set count=1
		.....do plist.Clear()
		set length=plist.Count()
		if length>0 d
		.set Instream=..GetCTARCItmMastByID(plist)
		.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
		.;b ;00
		.do tSC.OutputToDevice()
		.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CTARCItmMast",tSC)
	}else{
		set subStr=$p(Input,"||",1)
		set verStr=$p(Input,"||",2)
		set catStr=$p($g(^ARCIM(subStr,verStr,1)),"^",10)
		set rowid=subStr_"||"_verStr_"^"_catStr
		do plist.SetAt(rowid,count)
		set count=count+1
		set Instream=..GetCTARCItmMastByID(plist)
		set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
		do tSC.OutputToDevice()
		set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CTARCItmMast",tSC)
	}	
	Quit tSC.Read()
Exception
	b ;3
	Quit -1_$ze
}

/// Creator：luofanyu
/// CreatDate：2018-06-01
/// Description：查询HIS中医嘱项目信息
/// Table：ARC_ItmMast
/// Input： 医嘱项目字典
/// Return：医嘱项目信息
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTARCItmMast).GetCTARCItmMastByID("")
ClassMethod GetCTARCItmMastByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set arcimDr=$p(rowid,"^",1)
		set ArmSub=$p(arcimDr,"||",1)
		set ArmVer=$p(arcimDr,"||",2)
		set ArcIcRowId=$p(rowid,"^",2)
		set insObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTARCItmMast).%New()
		set insObj.CTARCIMCode=$p($g(^ARCIM(ArmSub,ArmVer,1)),"^",1)
		set insObj.businessrowid=arcimDr
		set CTARCIMUnitRowId=$p($g(^ARCIM(ArmSub,ArmVer,8)),"^",14)
		set CTARCIMUnit=""
		set:CTARCIMUnitRowId'="" CTARCIMUnit=$p(^CT("UOM",CTARCIMUnitRowId),"^",2)
		set insObj.CTARCIMUnit=CTARCIMUnitRowId //CTARCIMUnit
	 	set CTARCIMDesc=$tr($p($g(^ARCIM(ArmSub,ArmVer,1)),"^",2),"""","")
		set CTARCIMDesc=$tr(CTARCIMDesc,$c(31),"")
		set:CTARCIMDesc["," insObj.CTARCIMDesc=$tr(CTARCIMDesc,",","#") 
		set:CTARCIMDesc'["," insObj.CTARCIMDesc=CTARCIMDesc
		
		set CTARCIMBillSubCatDR=$p($g(^ARCIM(ArmSub,ArmVer,1)),"^",9)
		set CTARCIMBillSubCatRowID=$p(CTARCIMBillSubCatDR,"||",1)
		set CTARCIMBillSubCatSub=$p(CTARCIMBillSubCatDR,"||",2)
		set CTARCIMBillSubCat=$p($g(^ARCBG(CTARCIMBillSubCatRowID,"SG",CTARCIMBillSubCatSub)),"^",1)
		
		set insObj.CTARCIMChildCategory=ArcIcRowId //$P($g(^ARC("IC",ArcIcRowId)),"^",1)
		set OrdCatType=$P($g(^ARC("IC",ArcIcRowId)),"^",7)
		if OrdCatType="R" d
		.set CTARCIMDrugFlag="Y"
		.set CTARCIMConsumFlag="N"
		else  if OrdCatType="M" d
		.set CTARCIMDrugFlag="N"
		.set CTARCIMConsumFlag="Y"
		else  d
		.set CTARCIMDrugFlag="N"
		.set CTARCIMConsumFlag="N"
		if OrdCatType="P" d
		.set CTARCIMAutoDecidePriceFlag="Y"
		else  d
		.set CTARCIMAutoDecidePriceFlag="N"
		set ArcimRowid=ArmSub_"||"_ArmVer
		s tmpprice=##class(web.UDHCJFPRICE).GetOrderPrice("","",ArcimRowid,+$H,"","","","")
		s ordprice2=$j($p(tmpprice,"^",1),3,2)
		set insObj.CTARCIMPrice=ordprice2
		set insObj.CTARCIMAutoDecidePriceFlag=CTARCIMAutoDecidePriceFlag
		set insObj.CTARCIMCodesystemCode="CT_ARCItmMast"
		set insObj.CTARCIMStatus="1"
		set insObj.CTARCIMUpdateUserCode="无"
		set StartDateTime=$p($g(^ARCIM(ArmSub,ArmVer,1)),"^",13)
		set:StartDateTime'="" StartDate=$p(StartDateTime,"Z",1)
		set insObj.CTARCIMStartDate=StartDate
		set insObj.CTARCIMEndDate=""
		set insObj.CTARCIMBillSubCat=CTARCIMBillSubCatDR ;CTARCIMBillSubCatRowID //CTARCIMBillSubCat   ///账单子类
		set insObj.CTARCIMDrugFlag=CTARCIMDrugFlag        ///药品标识
		set insObj.CTARCIMConsumFlag=CTARCIMDrugFlag  ///耗材标识
		set hospId=$o(^CT("HOSP","0")) 
		set hospCode=$p(^CT("HOSP",hospId),"^",1)	
		set insObj.CTARCIMHosCode=hospId //hospCode
		d ListInfo.CTARCItmMast.Insert(insObj)
		;b ;insobj
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTARCItmMast",.Jsonobj)
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)	
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_ARCItmMast",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write("1^"_$ze)
	Quit stream
}

/// Creator：zhengchenghou
/// CreatDate：2018-06-01
/// Description：查询HIS中医嘱项目信息
/// Table：ARC_ItmMast
/// Input： 医嘱项目字典
/// Return：医嘱项目信息
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTARCItmMast).CTARCItmMast("11507||1")
ClassMethod CTARCItmMast(input As %String = "") As %GlobalCharacterStream
{
	set $zt="MsgErr"
	set ReturnStream=##class(%GlobalCharacterStream).%New()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	set OrCatRowId="0" f  set OrCatRowId=$o(^OEC("ORCAT",OrCatRowId)) q:OrCatRowId=""  d
	.set ArcIcRowId="" f  set ArcIcRowId=$o(^ARC("IC",0,"OrdCat",OrCatRowId,ArcIcRowId)) q:(ArcIcRowId="")  d 
	..set ArmSub=""  f  set ArmSub=$O(^ARCIM(0,"ARCIC_DR",ArcIcRowId,ArmSub)) q:ArmSub=""  d
	...set ArmVer=""  f  set ArmVer=$O(^ARCIM(0,"ARCIC_DR",ArcIcRowId,ArmSub,ArmVer))  q:ArmVer=""  d
	....Quit:((ArmSub_"||"_ArmVer'=input)&&(input'=""))
	....set insObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTARCItmMast).%New()
	....set insObj.CTARCIMCode=$p($g(^ARCIM(ArmSub,ArmVer,1)),"^",1)
	....set CTARCIMUnitRowId=$p($g(^ARCIM(ArmSub,ArmVer,8)),"^",14)
	....set:CTARCIMUnitRowId'="" CTARCIMUnit=$p(^CT("UOM",CTARCIMUnitRowId),"^",2)
	....set insObj.CTARCIMUnit=CTARCIMUnit
	....;b ;000
	....set CTARCIMDesc=$tr($p($g(^ARCIM(ArmSub,ArmVer,1)),"^",2),"""","")
	....set CTARCIMDesc=$tr(CTARCIMDesc,$c(31),"")
	....;b ;09
	....set:CTARCIMDesc["," insObj.CTARCIMDesc=$tr(CTARCIMDesc,",","#") 
	....set:CTARCIMDesc'["," insObj.CTARCIMDesc=CTARCIMDesc
	....;b ;00
	....set CTARCIMBillSubCatDR=$p($g(^ARCIM(ArmSub,ArmVer,1)),"^",9)
	....set CTARCIMBillSubCatRowID=$p(CTARCIMBillSubCatDR,"||",1)
	....set CTARCIMBillSubCatSub=$p(CTARCIMBillSubCatDR,"||",2)
	....set CTARCIMBillSubCat=$p($g(^ARCBG(CTARCIMBillSubCatRowID,"SG",CTARCIMBillSubCatSub)),"^",1)
	....;b ;0909
	....set insObj.CTARCIMChildCategory=$P($g(^ARC("IC",ArcIcRowId)),"^",1)
	....set OrdCatType=$P($g(^ARC("IC",ArcIcRowId)),"^",7)
	....if OrdCatType="R" d
	.....set CTARCIMDrugFlag="Y"
	.....set CTARCIMConsumFlag="N"
	....else  if OrdCatType="M" d
	.....set CTARCIMDrugFlag="N"
	.....set CTARCIMConsumFlag="Y"
	....else  d
	.....set CTARCIMDrugFlag="N"
	.....set CTARCIMConsumFlag="N"
	....if OrdCatType="P" d
	.....set CTARCIMAutoDecidePriceFlag="Y"
	....else  d
	.....set CTARCIMAutoDecidePriceFlag="N"
	....set ArcimRowid=ArmSub_"||"_ArmVer
	....s tmpprice=##class(web.UDHCJFPRICE).GetOrderPrice("","",ArcimRowid,+$H,"","","","")
	....s ordprice2=$j($p(tmpprice,"^",1),3,2)
	....set insObj.CTARCIMPrice=ordprice2
	....set insObj.CTARCIMAutoDecidePriceFlag=CTARCIMAutoDecidePriceFlag
	....set insObj.CTARCIMCodesystemCode="CT_ARCItmMast"
	....set insObj.CTARCIMStatus="1"
	....set insObj.CTARCIMUpdateUserCode="无"
	....set insObj.CTARCIMStartDate=""
	....set insObj.CTARCIMEndDate=""
	....set insObj.CTARCIMBillSubCat=CTARCIMBillSubCat   ///账单子类
	....set insObj.CTARCIMDrugFlag=CTARCIMDrugFlag        ///药品标识
	....set insObj.CTARCIMConsumFlag=CTARCIMDrugFlag  ///耗材标识
	....set insObj.CTARCIMHosCode="HFJDFYY"  ///耗材标识
	....d ListInfo.CTARCItmMast.Insert(insObj)
	....set count=ListInfo.CTARCItmMast.Count()
	....if count>2 d
	.....;b ;0000
	.....d ListInfo.XMLExportToString(.String)
	.....b ;09
	.....set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTARCItmMast",.Jsonobj)
	.....set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	.....set JsonString=$tr(JsonString,$c(13),"")
	.....set JsonString=$tr(JsonString,$c(10),"")
	.....set tSC=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_ARCItmMast",JsonString)
	.....;b ;000
	.....d ListInfo.CTARCItmMast.Clear()
	.....set count=0
	.....set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
	.....if resultCode'=0 d
	......s success=-1
	.....else  d
	......s success=0
	/*
	if input'="" {
		set request.body=body
		d request.XMLExportToStream(.stream)
		Quit stream
	}*/
	
	if input'=""
	{
		d ListInfo.XMLExportToString(.String)
		b ;09
		set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTARCItmMast",.Jsonobj)
		set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
		
		set string=..CTARCItmmastMainData("CT_ARCItmMast",JsonString)
		d ReturnStream.Write(string)
		quit ReturnStream	
	}
		
	if count>0 {
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTARCItmMast",.Jsonobj)
	do JsonStream.OutputToDevice()
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	set tSC=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_ARCItmMast",JsonString)
	set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
	if resultCode'=0 d
	.s success=-1
	else  d
	.s success=0
	}
	b ;09
	d ReturnStream.Write(success)
	quit ReturnStream
	
MsgErr
	b ;$ze111
	set ReturnStream=##class(%GlobalCharacterStream).%New()
	d ReturnStream.Write("-1"_$ze)
	quit ReturnStream
}

ClassMethod CTARCItmmastMainData(TableName As %String, Input As %String) As %String
{
	set $zt="MsgErr"
	set InputContent=##class(%GlobalCharacterStream).%New()
	d InputContent.Write(Input)
	set request=##class(web.DHCENS.STBLL.DICTNew.MODEL.Request).%New()
	set header=##class(web.DHCENS.STBLL.DICTNew.MODEL.Header).%New()
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.SourceSystem="02"
	set request.header=header
	
	set body=##class(web.DHCENS.STBLL.DICTNew.MODEL.Body).%New()
	set MainDataApply=##class(web.DHCENS.STBLL.DICTNew.MODEL.SSMDAApply).%New()
	set MainDataApply.SSMDATableCode=TableName
	set MainDataApply.SSMDAContent=Input
	set MainDataApply.SSMDASourceSys="HIS"
	set MainDataApply.SSMDAUserCode="demo"
	set MainDataApply.SSMDAUserName=""
	set MainDataApply.SSMDADate=$zd(+$h,3)
	set MainDataApply.SSMDATime=$zt($p($h,",",2))
	set MainDataApply.SSMDARemarks=""
	d body.SSMainDataApply.Insert(MainDataApply)
	set request.body=body
	d request.XMLExportToString(.string)
	quit string
MsgErr
	quit "-1^"_$ze
}

/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTARCItmMast).Test("")
ClassMethod Test(Input As %String = "") As %String
{
	set InputStream=##class(%GlobalCharacterStream).%New()
	do InputStream.Write(^tmpzch("XMLtoJSONPro"))
	set file=##class(%FileCharacterStream).%New()
	set file.TranslateTable="UTF8"
	set file.Filename="D:\arcitmmast.txt"
	do file.CopyFrom(InputStream)
	set sc=file.%Save()
	Quit sc
}

/// Creator：ZhangXinying
/// CreatDate：2018-09-15
/// Description：
/// Table：arc_itmmast
/// Input： 
/// Return：根据rowid获取医嘱项字典信息集合，ODS用
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTARCItmMast).GetCTARCItmMast("1||1").Read()
ClassMethod GetCTARCItmMast(Input As %String) As %GlobalCharacterStream
{
	set $zt="Exception"	
	set OutputStream=##class(%GlobalCharacterStream).%New()
	set length=$l(Input,"^")
	set pList=##class(%ArrayOfDataTypes).%New()
	b ;aa1
	for i=1:1:length{
		set rowid=$p(Input,"^",i)
		set ServCatDr=$p($g(^ARCIM(+rowid,$p(rowid,"||",2),1)),"^",10)
		set id=rowid_"^"_ServCatDr
		do pList.SetAt(id,i)
	}
	if pList.Count()>0{
		set OutputStream=..GetCTARCItmMastByID(pList)
	}
	b ;221
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write("-1^"_$ze)
	Quit stream
}

/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTARCItmMast).Test1("") 
ClassMethod Test1(Input As %String = "") As %String
{

	set $zt="Exception"
	set message=##class(%GlobalCharacterStream).%New()
	
	//set tSc=message.WriteLine("字典代码,代码,名称,状态,备注,更新日期,更新时间,更新人")
	
	set tSc=message.WriteLine("对照字典id,源数据代码,源数据描述,目标数据代码,目标数据描述,备注,状态")
	set i=0
	/*
	set ArmSub="0"  for  set ArmSub=$o(^ARCIM(ArmSub)) Quit:ArmSub=""  d
	.set ArmVer=""  for  set ArmVer=$o(^ARCIM(ArmSub,ArmVer)) Quit:ArmVer=""  d
	..//set rowId=ArmSub_"||"_ArmVer
	..set rowId=$tr($p($g(^ARCIM(ArmSub,ArmVer,1)),"^",1),"""","")
	..set rowId=$tr(rowId,$c(13),"")
	..set rowId=$tr(rowId,$c(10),"")
	..set CTARCIMDesc=$tr($p($g(^ARCIM(ArmSub,ArmVer,1)),"^",2),",","")
	..set CTARCIMDesc=$tr(CTARCIMDesc,$c(13),"")
	..set CTARCIMDesc=$tr(CTARCIMDesc,$c(10),"")
	..set CTARCIMDesc=$tr(CTARCIMDesc,$c(9),"")
	..set tableConfigStr="SD00014,"_rowId_","_CTARCIMDesc_",Y,,2019-06-18,22:50:17,admin"
	..set tSc=message.WriteLine(tableConfigStr)
	*/
	/*
	set ArmSub="0"  for  set ArmSub=$o(^ARCIM(ArmSub)) Quit:ArmSub=""  d
	.set ArmVer=""  for  set ArmVer=$o(^ARCIM(ArmSub,ArmVer)) Quit:ArmVer=""  d
	..set rowId=ArmSub_"||"_ArmVer
	..set code=$tr($p($g(^ARCIM(ArmSub,ArmVer,1)),"^",1),"""","")
	..set code=$tr(code,$c(13),"")
	..set code=$tr(code,$c(10),"")
	..set CTARCIMDesc=$tr($p($g(^ARCIM(ArmSub,ArmVer,1)),"^",2),",","")
	..set CTARCIMDesc=$tr(CTARCIMDesc,$c(13),"")
	..set CTARCIMDesc=$tr(CTARCIMDesc,$c(10),"")
	..set CTARCIMDesc=$tr(CTARCIMDesc,$c(9),"")
	..set tableConfigStr=","_rowId_","_CTARCIMDesc_","_code_","_CTARCIMDesc_",,Y"
	..set tSc=message.WriteLine(tableConfigStr)
	*/
	/*
	set diagId="0"  for  set diagId=$o(^MRC("ID",diagId)) Quit:diagId=""  d
	.set rowId=$tr($p($g(^MRC("ID",diagId)),"^",1),"""","")
	.set CTARCIMDesc=$tr($p($g(^MRC("ID",diagId)),"^",2),",","")
	.set CTARCIMDesc=$tr(CTARCIMDesc,$c(13),"")
	.set CTARCIMDesc=$tr(CTARCIMDesc,$c(10),"")
	.set tableConfigStr="SD00056,"_rowId_","_CTARCIMDesc_",Y,,2019-06-18,22:50:17,admin"
	.set tSc=message.WriteLine(tableConfigStr)
	*/
	/*
	set diagId="0"  for  set diagId=$o(^MRC("ID",diagId)) Quit:diagId=""  d
	.set code=$tr($p($g(^MRC("ID",diagId)),"^",1),"""","")
	.set CTARCIMDesc=$tr($p($g(^MRC("ID",diagId)),"^",2),",","")
	.set CTARCIMDesc=$tr(CTARCIMDesc,$c(13),"")
	.set CTARCIMDesc=$tr(CTARCIMDesc,$c(10),"")
	.set tableConfigStr=","_diagId_","_CTARCIMDesc_","_code_","_CTARCIMDesc_",,Y"
	.set tSc=message.WriteLine(tableConfigStr)
	*/
	/*
	set diagId="0"  for  set diagId=$o(^ORC("OPER",diagId)) Quit:diagId=""  d
	.set rowId=$tr($p($g(^ORC("OPER",diagId)),"^",1),"""","")
	.set rowId=$tr(rowId,$c(13),"")
	.set rowId=$tr(rowId,$c(10),"")
	.set CTARCIMDesc=$tr($p($g(^ORC("OPER",diagId)),"^",2),",","")
	.set CTARCIMDesc=$tr(CTARCIMDesc,$c(13),"")
	.set CTARCIMDesc=$tr(CTARCIMDesc,$c(10),"")
	.set tableConfigStr="SD00057,"_diagId_","_CTARCIMDesc_",Y,,2019-06-18,22:50:17,admin"
	.set tSc=message.WriteLine(tableConfigStr)
	*/
	/*
	set wardId="0"  for  set wardId=$o(^PAWARD(wardId)) q:wardId=""  d
	.set bedId="0"  for  set bedId=$o(^PAWARD(wardId,"BED",bedId)) q:bedId=""  d
	..set rowId=wardId_"||"_bedId
	..set code=$tr($p($g(^PAWARD(wardId,"BED",bedId)),"^",1),"""","")
	..set CTARCIMDesc=$tr($p($g(^PAWARD(wardId,"BED",bedId)),"^",2),",","")
	..set CTARCIMDesc=$tr(CTARCIMDesc,$c(13),"")
	..set CTARCIMDesc=$tr(CTARCIMDesc,$c(10),"")
	..set tableConfigStr="SD00014,"_code_","_code_",Y,,2019-06-18,22:50:17,admin"
	..set tSc=message.WriteLine(tableConfigStr)
	*/
	
	/*
	set wardId="0"  for  set wardId=$o(^PAWARD(wardId)) q:wardId=""  d
	.set bedId="0"  for  set bedId=$o(^PAWARD(wardId,"BED",bedId)) q:bedId=""  d
	..set rowId=wardId_"||"_bedId
	..set code=$tr($p($g(^PAWARD(wardId,"BED",bedId)),"^",1),"""","")
	..set CTARCIMDesc=$tr($p($g(^PAWARD(wardId,"BED",bedId)),"^",2),",","")
	..set CTARCIMDesc=$tr(CTARCIMDesc,$c(13),"")
	..set CTARCIMDesc=$tr(CTARCIMDesc,$c(10),"")
	..set tableConfigStr=","_rowId_","_code_","_code_","_code_",,Y"
	..set tSc=message.WriteLine(tableConfigStr)
	*/
	/*
	set i=0
	set hospRowId="" for  set hospRowId=$O(^DeptLink(hospRowId)) q:hospRowId=""  d
	.Quit:hospRowId="Hosp"
	.Quit:hospRowId="Hrp"
	.set rowId="" for  set rowId=$O(^DeptLink(hospRowId,rowId)) q:rowId=""  d
	..set ^DeptLink("Hrp",rowId)=""
	..set i=i+1
	)*/
	
	/*
	set rowid="0"  for  set rowid=$o(^SSU("SSUSR",rowid)) Quit:rowid=""  d
	.set code=$p($g(^SSU("SSUSR",rowid)),"^",1)
	.set code=$tr(code,$c(13),"")
	.set code=$tr(code,$c(10),"")
	.set desc=$p($g(^SSU("SSUSR",rowid)),"^",2)
	.set desc=$tr(desc,$c(13),"")
	.set desc=$tr(desc,$c(10),"")
	.set hrpRowId=""
	.set hrpRowId=$o(^UserLink(code,""))
	.set:hrpRowId'="" code=hrpRowId
	.set tableConfigStr="SD00066,"_code_","_desc_",Y,,2019-06-18,22:50:17,admin"
	.set tSc=message.WriteLine(tableConfigStr)
	Quit message
	
	*/
	/*
	set rowid="0"  for  set rowid=$o(^SSU("SSUSR",rowid)) Quit:rowid=""  d
	.set code=$p($g(^SSU("SSUSR",rowid)),"^",1)
	.set code=$tr(code,$c(13),"")
	.set code=$tr(code,$c(10),"")
	.set desc=$p($g(^SSU("SSUSR",rowid)),"^",2)
	.set desc=$tr(desc,$c(13),"")
	.set desc=$tr(desc,$c(10),"")
	.set hrpRowId=""
	.set hrpRowId=$o(^UserLink(code,""))
	.set:hrpRowId'="" code=hrpRowId
	.set tableConfigStr=","_rowid_","_desc_","_code_","_desc_",,Y"
	.set tSc=message.WriteLine(tableConfigStr)
	*/
	/*
	set rowid="0"  for  set rowid=$o(^CTLOC(rowid)) Quit:rowid=""  d
	.set code=rowid
	.set desc=$p($g(^CTLOC(rowid)),"^",2)
	.set desc=$tr(desc,$c(13),"")
	.set desc=$tr(desc,$c(10),"")
	.set hrpRowId=""
	.set hrpRowId=$o(^LocLink(rowid,""))
	.if hrpRowId'="" d
	..set code=hrpRowId
	..set desc=$g(^LocLink(rowid,hrpRowId))
	.set tableConfigStr="SD00062,"_code_","_desc_",Y,,2019-06-18,22:50:17,admin"
	.set tSc=message.WriteLine(tableConfigStr)
	*/
	/*
	set rowid="0"  for  set rowid=$o(^CTLOC(rowid)) Quit:rowid=""  d
	.set desc=$p($g(^CTLOC(rowid)),"^",2)
	.set desc=$tr(desc,$c(13),"")
	.set desc=$tr(desc,$c(10),"")
	.set hrpRowId=""
	.set hrpRowId=$o(^LocLink(rowid,""))
	.if hrpRowId'="" d
	..set code=hrpRowId
	.e  d
	..set code=rowid
	.set tableConfigStr=","_rowid_","_desc_","_code_","_desc_",,Y"
	.set tSc=message.WriteLine(tableConfigStr)
	*/
	/*
	set rowid="0"  for  set rowid=$o(^DHCTARI(rowid)) Quit:rowid=""  d
	.set code=$p($g(^DHCTARI(rowid)),"^",1)
	.set code=$tr(code,$c(13),"")
	.set code=$tr(code,$c(10),"")
	.set desc=$p($g(^DHCTARI(rowid)),"^",2)
	.set desc=$tr(desc,$c(13),"")
	.set desc=$tr(desc,$c(10),"")
	.set desc=$tr(desc,",","^^^")
	.set tableConfigStr="SD00029,"_code_","_desc_",Y,,2019-06-18,22:50:17,admin"
	.set tSc=message.WriteLine(tableConfigStr)
	*/
	
	set rowid="0"  for  set rowid=$o(^DHCTARI(rowid)) Quit:rowid=""  d
	.set code=$p($g(^DHCTARI(rowid)),"^",1)
	.set code=$tr(code,$c(13),"")
	.set code=$tr(code,$c(10),"")
	.set desc=$p($g(^DHCTARI(rowid)),"^",2)
	.set desc=$tr(desc,$c(13),"")
	.set desc=$tr(desc,$c(10),"")
	.set desc=$tr(desc,",","^^^")
	.set tableConfigStr=","_rowid_","_desc_","_code_","_desc_",,Y"
	.set tSc=message.WriteLine(tableConfigStr)
	
	Quit message
Exception
	Quit "-1^"_$ze
}

}
