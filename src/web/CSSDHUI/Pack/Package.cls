Import sqluser

/// wfg
/// 2019-6-12
/// 消毒包打印使用
Class web.CSSDHUI.Pack.Package Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "CSSDPACK";

/// w ##class(web.CSSDHUI.Pack.Package).GetPrintPackageLabelInfo(^templxt("print",1),^templxt("print",2))
ClassMethod GetPrintPackageLabelInfo(label As %String, Params As %String) As %String
{
	n (label,Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	i (label="") q RtnObj.Err(-1,"","入参不能为空！").Json()
	s Sc=PJObj.%FromJSON(Params)
	i (Sc'=0) q RtnObj.Err(-2,"","入参解析失败！").Json()

	s ToLoc = PJObj.%Get("ToLoc")
	s:ToLoc="" ToLoc= PJObj.%Get("ToLocDr")
	s PotNoValue = PJObj.%Get("SterMachine")			;灭菌器rowid
	s HeatNo = PJObj.%Get("HeatNo")
	s packNum = PJObj.%Get("packNum")
	s packId=$o(^User.CSSDPackagePackI("CSSDPPLabelIndex",label,""))
	s transid=$o(^User.CSSDTransI("CSSDTLabel",label,""))
	i ((packId="")||(transid="")) q RtnObj.Err(-3,"","未获取到包装相关信息！").Json()

	s pkgPack=##Class(User.CSSDPackagePack).%OpenId(packId)
	s PackageObject=pkgPack.CSSDPPPackage
	s locId=pkgPack.CSSDPPApplyLocGetObjectId()
	s PackLocDr=pkgPack.CSSDPPPackLocDrGetObjectId()
	s ChkUser=pkgPack.CSSDPPAckUserDr
	s User=pkgPack.CSSDPPUserDr
	s PackUser=pkgPack.CSSDPPPackUserDr
	s PackageID=pkgPack.CSSDPPPackageGetObjectId()
	s MachineId=pkgPack.CSSDPPMachineDRGetObjectId()
	s PackHeatNo=pkgPack.CSSDPPHeatNo
	s:packNum="" packNum=pkgPack.CSSDPPPackNum
	s SterUser=pkgPack.CSSDPPSterUserDr

	s (PackageRowId,ChkUserName,UserName,PackageDesc,PackageLocId,PackUserName,SterUserName)=""
	i $IsObject(PackageObject) d
	.s PackageDesc=PackageObject.CSSDPDesc
	.s PackageRowId=PackageObject.%Id()
	.s PackageLocId=PackageObject.CSSDPLOCDRGetObjectId()
	.s PackageTypeDtail=PackageObject.CSSDPPackTypeDetail
	.i PackageTypeDtail=1 d
	..s PackageDesc=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetCodeDictName(label)

	s ItemCount=0,ItemRowId=""
	f  s ItemRowId=$o(^User.CSSDPackageItemI("CSSDPIPackageIndex",PackageRowId,ItemRowId)) q:ItemRowId=""  d
	.s objPackageItem=##class(User.CSSDPackageItem).%OpenId(ItemRowId)
	.q:objPackageItem=""
	.s Qty=objPackageItem.CSSDPIQty
	.s ItemCount=ItemCount+Qty
	i ItemCount'=0 s ItemCount="("_ItemCount_"个)"	//消毒包内部的器械数量

	;打印的一个包里边包含多少个（功能针对单包进行多个包打一个大包）
	i packNum'="" s PackageDesc=PackageDesc_" ("_packNum_"个)"

	s LocName="临床科室"
	i PackLocDr'="" d
	.s LocName=$p(^CTLOC(PackLocDr),"^",2)
	e  i ToLoc'="" d
	.s LocName=$p(^CTLOC(ToLoc),"^",2)
	e  i locId'="" d
	.s LocName=$p(^CTLOC(locId),"^",2)
	e  i PackageLocId'="" d
	.s LocName=$p(^CTLOC(PackageLocId),"^",2)

	;灭菌器,批次字段,优先使用前端传入
	i PotNoValue="" s PotNoValue=MachineId
	i HeatNo="" s HeatNo=PackHeatNo
	s SterTypeName="",MachineNum=""
	i PotNoValue'="" d
	.s MachineObj=##Class(User.CSSDMachineConfig).%OpenId(PotNoValue)
	.s MachineNum=MachineObj.CSSDMCNum
	s MachinePot=MachineNum_"/"_HeatNo

	s PackTrans=##Class(User.CSSDTrans).%OpenId(transid)
	s strExpDateD=PackTrans.CSSDTExpDate
	s packDateD=PackTrans.CSSDTDate
	s ValidDateH=strExpDateD-1
	s strExpDate=..DL2H(strExpDateD)
	s ValidDate=..DL2H(ValidDateH)
	s packDate=..DL2H(packDateD)

	;审核人
	s:$IsObject(ChkUser) ChkUserName=ChkUser.SSUSRName
	;包装人
	s:$IsObject(User) UserName=User.SSUSRName
	;配包人
	s:$IsObject(PackUser) PackUserName=PackUser.SSUSRName
	;灭菌人
	s:$IsObject(SterUser) SterUserName=SterUser.SSUSRName

	s (SterTypeDr,SterTypeName)=""
	s SterTypeInfo=##class(User.CSSDPackage).%OpenId(PackageID).CSSDPSterType
	i $IsObject(SterTypeInfo) d
	.s SterTypeDr=SterTypeInfo.%Id()
	.s SterTypeName=$List(^User.CSSDSterTypeD(SterTypeDr),3)

	;补打标志
	s PrintRemark=""
	s PrintTime=pkgPack.CSSDPPPrtTimes
	i PrintTime>=1 d
	.s PrintRemark="(补)"
	&sql(UPDATE CSSD_PackagePack set CSSDPP_PrtTimes=CSSDPP_PrtTimes+1 where CSSDPP_Label=:label)

	Set printObj=##class(ext.util.JsonObject).%New()
	d printObj.Put("label",label).Put("LocName",LocName).Put("strExpDate",strExpDate).Put("AckUserName",UserName).Put("ValidDate",ValidDate)
	d printObj.Put("ChkUserName",ChkUserName).Put("PackageDesc",PackageDesc).Put("packDate",packDate)
	d printObj.Put("SterTypeName",SterTypeName).Put("MachinePot",MachinePot).Put("PackUserName",PackUserName)
	d printObj.Put("ItemCount",ItemCount).Put("PrintRemark",PrintRemark).Put("SterUserName",SterUserName)
	s rtn = printObj.GetPrintData()
	d printObj.%Close()
	s printObj = ""
	q rtn
}

/// Description:根据Label获取绑定的患者相关信息
/// Creator:ban
/// CreatDate:2020-01-7
/// Table:
/// w ##Class(web.CSSDHUI.Pack.Package).GetExtPackageInfo("001339001")
ClassMethod GetExtPackageInfo(Label As %String) As %String
{
	n (Label)
	s StrInfo=""
	s registerId=$o(^User.CSSDExtDevBindI("IndexCSSDExtLabel",Label,""))
	i registerId'="" d
	.s ExtObj = ##class(User.CSSDExtDevBind).%OpenId(registerId)
	.d ExtObj.%Reload()
	.i $IsObject(ExtObj) d
	..s DocName =ExtObj.CSSDExtDocName	//使用医生
	..s UseDate=ExtObj.CSSDExtUseDate	//使用时间
	..s SickerName=ExtObj.CSSDExtSickerName	//患者姓名
	..s HospitalNo=ExtObj.CSSDExtHospitalNo	//住院号
	..s Firm=ExtObj.CSSDExtFirm.CSSDVenName	//厂商
	..s InstruNum=ExtObj.CSSDExtInstruNum	//器械数量
	..s Implants=ExtObj.CSSDExtImplants	//植入物
	..i Implants="Y" s Implants="是"
	..i Implants="N" s Implants="否"
	..s BedNo=ExtObj.CSSDExtBedNo	//床号
	..s ExtLoc=ExtObj.CSSDExtLoc.CTLOCDesc	//使用科室
	..s InstruName=ExtObj.CSSDExtInstruName.CSSDPDesc	//器械名称
	..s StrInfo=DocName_"^"_UseDate_"^"_SickerName_"^"_HospitalNo_"^"_Firm_"^"_InstruNum_"^"_Implants_"^"_BedNo_"^"_ExtLoc_"^"_InstruName
	q StrInfo
}

/// w ##class(web.CSSDHUI.Pack.Package).GetPrintExtPackageLabelInfo(^tmpllkk,^tmpvvjj)
ClassMethod GetPrintExtPackageLabelInfo(label As %String, Params As %String) As %String
{
	n (label,Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	i (label="") d RtnObj.Err(-1,"","入参不能为空!")
	q:RtnObj.success<0 RtnObj.Json()

	s Sc=PJObj.%FromJSON(Params)
	s ToLoc = PJObj.%Get("ToLoc")
	s PotNoValue = PJObj.%Get("PotNoValue")
	s HeatNo = PJObj.%Get("HeatNo")
	i (Sc'=0) q RtnObj.Err(-1,"","入参解析失败").Json()

	s packId=$o(^User.CSSDPackagePackI("CSSDPPLabelIndex",label,""))
	s pkgPack=##Class(User.CSSDPackagePack).%OpenId(packId)
	d pkgPack.%Reload()
	i '$IsObject(pkgPack) q RtnObj.Err(-3,"","未获取到包装相关信息！").Json()

	s transid=$o(^User.CSSDTransI("CSSDTLabel",label,""))
	s packNo=$e(label,$L(label)-1,$L(label))
	s codeDictLabel=##class(web.CSSDHUI.Common.PackageInfoCommon).GetFixedLabel(label)
	s BindLabel=$e(label,1,$L(codeDictLabel)+6)
	s packageName=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetCodeDictName(codeDictLabel)
	s PackageObject=pkgPack.CSSDPPPackage
	s PackageDesc=packageName_"-"_packNo
	s PackageRowId=PackageObject.%Id()
	s (InstruNum,ItemCount)=0,(Implants,ItemRowId)=""
	f  s ItemRowId=$o(^User.CSSDExtDevBindDetailI("CSSDEBDLabelIndex",label,ItemRowId)) q:ItemRowId=""  d
	.s objExtDetail=""
	.s objExtDetail=##class(User.CSSDExtDevBindDetail).%OpenId(ItemRowId)
	.d objExtDetail.%Reload()
	.q:'$IsObject(objExtDetail)
	.s IsImplants=objExtDetail.CSSDEBDIsImplants
	.s ImplantName=objExtDetail.CSSDEBDItmDR.CSSDIDesc
	.s Qty=objExtDetail.CSSDEBDQty
	.s InstruNum=InstruNum+Qty
	.i IsImplants="Y" d
	..i Implants="" s Implants=ImplantName_":"_Qty
	..e  s Implants =Implants_" | "_ImplantName_":"_Qty
	.e  s ItemCount=ItemCount+Qty
	i ItemCount'="" s ItemCount="("_ItemCount_"个)"	//消毒包内部的器械数量
	s PackageLocId=PackageObject.CSSDPLOCDRGetObjectId()
	s PackageClassId=PackageObject.CSSDPPackClass.%Id()
	s IsExt=##class(web.CSSDHUI.Common.PackageInfoCommon).GetExtFlag(PackageRowId)
	i IsExt'="Y" d RtnObj.Err(-1,"","该包不是外来器械，不能进行外来器械打印！")
	q:RtnObj.success<0 RtnObj.Json()

	s ExtInfo = ..GetExtPackageInfo(BindLabel)
	i ExtInfo=""  d RtnObj.Err(-1,"","该外来器械，未做登记患者信息，请先进行外来器械登记！")
	q:RtnObj.success<0 RtnObj.Json()

	s DocName =$p(ExtInfo,"^",1)	//使用医生
	s UseDate=$p(ExtInfo,"^",2)	//使用时间
	s SickerName=$p(ExtInfo,"^",3)	//患者姓名
	s HospitalNo=$p(ExtInfo,"^",4)	//住院号
	s Firm=$p(ExtInfo,"^",5)	//厂商
	i InstruNum=0 s InstruNum=$p(ExtInfo,"^",6)	//器械数量
	i Implants="" s Implants=$p(ExtInfo,"^",7)	//植入物
	s BedNo=$p(ExtInfo,"^",8)	//床号
	s ExtLoc=$p(ExtInfo,"^",9)	//使用科室
	s InstruName=$p(ExtInfo,"^",10)	//器械名称
	s LocName="临床科室",locId=""
	s:locId="" locId=pkgPack.CSSDPPPackLocDrGetObjectId()
	s:locId="" locId=ToLoc
	s:locId="" locId=pkgPack.CSSDPPApplyLocGetObjectId()
	s:locId="" locId=PackageLocId
	s:locId'="" LocName=$p(^CTLOC(locId),"^",2)
	s SterTypeName="",MachineNum=""
	i PotNoValue="" s PotNoValue=pkgPack.CSSDPPMachineDRGetObjectId()
	i PotNoValue'="" d
	.s MachineObj=##Class(User.CSSDMachineConfig).%OpenId(PotNoValue)
	.d MachineObj.%Reload()
	.s MachineNum = MachineObj.CSSDMCNum
	.i ((MachineNum>0)&&(MachineNum<10)) s MachineNum = $e(MachineNum,$l(MachineNum))
	i HeatNo="" s HeatNo=pkgPack.CSSDPPHeatNo

	s PotNoSterType=$lg(^User.CSSDPackageD(PackageRowId),21)
	i PotNoSterType'="" d
	.s SterTypeObj = ##class(User.CSSDSterType).%OpenId(PotNoSterType)
	.d SterTypeObj.%Reload()
	.i $IsObject(SterTypeObj) s SterTypeName = SterTypeObj.CSSDSTSterName
	s MachinePot = MachineNum_"/"_HeatNo
	s PackTrans=##Class(User.CSSDTrans).%OpenId(transid)
	d PackTrans.%Reload()
	s strExpDate=PackTrans.CSSDTExpDate		;失效日期
	s ValidDateH=strExpDate-1				;有效日期
	i strExpDate'="" s strExpDate=..DL2H(strExpDate)
	s ValidDate=..DL2H(ValidDateH)
	s packDate=PackTrans.CSSDTDate
	s packDate=..DL2H(packDate)
	;配包人
	s User=pkgPack.CSSDPPUserDr
	s UserId=User.%Id()
	s UserName=User.SSUSRName
	;审核人
	s ChkUser=pkgPack.CSSDPPAckUserDr
	s ChkUserId=ChkUser.%Id()
	s ChkUserName=ChkUser.SSUSRName

	s SterUser=pkgPack.CSSDPPSterUserDr
	s SterUserId=pkgPack.CSSDPPSterUserDrGetObjectId()
	s SterUserName=..sssUserName(SterUserId)

	&sql(UPDATE CSSD_PackagePack set CSSDPP_PrtTimes=CSSDPP_PrtTimes+1 where CSSDPP_Label=:label)
	Set printObj =  ##class(ext.util.JsonObject).%New()
	/*label,LocName 等为XML模板中的元素名*/
	do printObj.Put("label",label).Put("LocName",LocName).Put("strExpDate",strExpDate).Put("AckUserName",UserName).Put("ValidDate",ValidDate)
	do printObj.Put("ChkUserName",ChkUserName).Put("PackageDesc",PackageDesc).Put("packDate",packDate)
	do printObj.Put("SterTypeName",SterTypeName).Put("MachinePot",MachinePot)
	do printObj.Put("DocName",DocName).Put("UseDate",UseDate).Put("SickerName",SickerName)
	do printObj.Put("HospitalNo",HospitalNo).Put("Firm",Firm).Put("InstruNum",InstruNum)
	do printObj.Put("Implants",Implants).Put("BedNo",BedNo).Put("ExtLoc",ExtLoc).Put("InstruName",InstruName)
	do printObj.Put("ItemCount",ItemCount).Put("SterUserName",SterUserName)
	set rtn = printObj.GetPrintData()
	do printObj.%Close()
	Set printObj = ""
	quit rtn
}

/// Creator:ban
/// CreatDate:2020-04-17
/// Description:根据配置控制返回的列数，调整打印模板列数即打印几列明细
/// Table:
/// detailLine:标签打印返回几列数据   label:标签号
/// d ##class(web.CSSDHUI.Pack.Package).GetItms("{""label"":""20412022030900005"",""gUserId"":""6423"",""gLocId"":""166"",""gGroupId"":""103"",""gHospId"":""2""}")
ClassMethod GetItms(Params As %String) As %Status
{
	n (Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i Params="" d RtnObj.Err(-1,"","入参不能为空!")
	q:RtnObj.success<0 RtnObj.Json()

	s PJobj=##class(web.CSSDHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s label=PJobj.%Get("label")
	s gUserId=PJobj.%Get("gUserId")
	s gLocId=PJobj.%Get("gLocId")
	s gGroupId=PJobj.%Get("gGroupId")
	s gHospId=PJobj.%Get("gHospId")
	s AppName=..%GetParameter("AppName")
	s Param=gGroupId_"^"_gLocId_"^"_gUserId_"^"_gHospId
	s isPackUserValue=##class(web.CSSDHUI.Common.AppCommon).GetParamValue(AppName,"IsPackUser",Param)
	s detailLine=##Class(web.CSSDHUI.Common.AppCommon).GetParamValue(AppName,"PrintDetailNum",Param)
	s:detailLine="" detailLine=1

	s packId=$o(^User.CSSDPackagePackI("CSSDPPLabelIndex",label,""))
	i packId="" q RtnObj.Err(-2,"","未获取到包装相关信息！").Json()
	s pkgPack=##Class(User.CSSDPackagePack).%OpenId(packId)
	d pkgPack.%Reload()

	s PackageRowId=pkgPack.CSSDPPPackageGetObjectId()
	i PackageRowId="" q RtnObj.Err(-2,"","未获取到消毒包信息！").Json()

	k ^TMPITMINFO(PackageRowId,"DETAIL")
	s ItemDetailRowId=""
	f  s ItemDetailRowId=$o(^User.CSSDPackageItemI("CSSDPIPackageIndex",PackageRowId,ItemDetailRowId)) q:ItemDetailRowId=""  d
	.s objItem=##class(User.CSSDPackageItem).%OpenId(ItemDetailRowId)
	.d objItem.%Reload()
	.s Sort=objItem.CSSDPISORT
	.s ^TMPITMINFO(PackageRowId,"DETAIL",Sort,ItemDetailRowId)=ItemDetailRowId

	s (inList,ItemSort,RowId)="",number=0
	f  s ItemSort=$o(^TMPITMINFO(PackageRowId,"DETAIL",ItemSort)) q:ItemSort=""  d
	.f  s RowId=$o(^TMPITMINFO(PackageRowId,"DETAIL",ItemSort,RowId)) q:RowId=""  d
	..s objPackageItem=""
	..s objPackageItem=##class(User.CSSDPackageItem).%OpenId(RowId)
	..d objPackageItem.%Reload()
	..q:objPackageItem=""
	..s itmDr=objPackageItem.CSSDPIItmDR.%Id()
	..q:itmDr=""
	..s Desc=objPackageItem.CSSDPIItmDR.CSSDIDesc
	..s Spec=objPackageItem.CSSDPIItmDR.CSSDISpec
	..s Qty=objPackageItem.CSSDPIQty
	..s SerialNo=objPackageItem.CSSDPISORT
	..i inList="" s inList=Desc_":"_Qty
	..e  d
	...i (number#detailLine=0)&&(inList'="") d
	....s inList=inList_";"_Desc_":"_Qty	//前台JSON解析不支持后台的$c(2),所以用;标注，前台进行replace
	...e  s inList=inList_"^"_Desc_":"_Qty
	..s number=number+1
	s RtnObj.msg=inList
	q RtnObj.Json()
}

/// Creator:ban
/// CreatDate:2021-07-17
/// Description:外来器械明细获，根据配置控制返回的列数，调整打印模板列数即打印几列明细
/// Table:CSSD_ExtDevBindDetail
/// detailLine:标签打印返回几列数据	label:标签号
/// d ##class(web.CSSDHUI.Pack.Package).GetExtItms("{""label"":""10203800100000201"",""gUserId"":""6423"",""gLocId"":""166"",""gGroupId"":""103"",""gHospId"":""2""}")
ClassMethod GetExtItms(Params As %String) As %Status
{
	n (Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i Params="" d RtnObj.Err(-1,"","入参不能为空!")
	q:RtnObj.success<0 RtnObj.Json()

	s PJobj=##class(web.CSSDHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s label=PJobj.%Get("label")
	s gUserId=PJobj.%Get("gUserId")
	s gLocId=PJobj.%Get("gLocId")
	s gGroupId=PJobj.%Get("gGroupId")
	s gHospId=PJobj.%Get("gHospId")
	s AppName=..%GetParameter("AppName")
	s Param=gGroupId_"^"_gLocId_"^"_gUserId_"^"_gHospId
	s isPackUserValue=##class(web.CSSDHUI.Common.AppCommon).GetParamValue(AppName,"IsPackUser",Param)
	s detailLine=##Class(web.CSSDHUI.Common.AppCommon).GetParamValue(AppName,"PrintDetailNum",Param)
	s:detailLine="" detailLine=1

	s (ItemDetailRowId,inList)="",number=0
	f  s ItemDetailRowId=$o(^User.CSSDExtDevBindDetailI("CSSDEBDLabelIndex",label,ItemDetailRowId)) q:ItemDetailRowId=""  d
	.s objItem=##class(User.CSSDExtDevBindDetail).%OpenId(ItemDetailRowId)
	.s itmDr=objItem.CSSDEBDItmDR.%Id()
	.q:itmDr=""
	.s Desc=objItem.CSSDEBDItmDR.CSSDIDesc
	.s Spec=objItem.CSSDEBDItmDR.CSSDISpec
	.s Qty=objItem.CSSDEBDQty
	.i inList="" s inList=Desc_":"_Qty
	.e  d
	..i (number#detailLine=0)&&(inList'="") d
	...s inList=inList_";"_Desc_":"_Qty	//前台JSON解析不支持后台的$c(2),所以用;标注，前台进行replace
	..e  s inList=inList_"^"_Desc_":"_Qty
	.s number=number+1
	s RtnObj.msg=inList
	q RtnObj.Json()
}

/// Creator:why
/// CreatDate:2020-05-20
/// Description:根据固定标签打印明细,根据配置控制返回的列数，调整打印模板列数即打印几列明细
/// Table:
/// detailLine:标签打印返回几列数据	label:标签号
/// w ##class(web.CSSDHUI.Pack.Package).GetItmsByCode("{""label"":""104001001"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2""}")
ClassMethod GetItmsByCode(Params As %String) As %String
{
	n (Params)
	k ^tmpshsaksakjska
	s ^tmpshsaksakjska=Params
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i Params="" d RtnObj.Err(-1,"","入参不能为空!")
	q:RtnObj.success<0 RtnObj.Json()

	s PJobj=##class(web.CSSDHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s label=PJobj.%Get("label")
	s gUserId=PJobj.%Get("gUserId")
	s gLocId=PJobj.%Get("gLocId")
	s gGroupId=PJobj.%Get("gGroupId")
	s gHospId=PJobj.%Get("gHospId")
	s AppName=..%GetParameter("AppName")
	s Param=gGroupId_"^"_gLocId_"^"_gUserId_"^"_gHospId
	s detailLine=##Class(web.CSSDHUI.Common.AppCommon).GetParamValue(AppName,"PrintDetailNum",Param)
	s:detailLine="" detailLine=1
	i label="" d RtnObj.Err(-2,"","标牌不能为空!")
	q:RtnObj.success<0 RtnObj.Json()

	s CodeDictId=$o(^User.CSSDCodeDictI("CSSDCDCodeIndex",label,""))
	i CodeDictId="" d RtnObj.Err(-3,"","未获取到标牌信息!")
	q:RtnObj.success<0 RtnObj.Json()

	s CodeDictObj=##class(User.CSSDCodeDict).%OpenId(CodeDictId)
	s PackageObj=CodeDictObj.CSSDCDPackDR
	i '$IsObject(PackageObj) d RtnObj.Err(-4,"","未获取到消毒包信息!")
	q:RtnObj.success<0 RtnObj.Json()

	s PackageRowId=PackageObj.%Id()
	k ^TMPITMINFO(PackageRowId,"DETAIL")
	s ItemDetailRowId=""
	f  s ItemDetailRowId=$o(^User.CSSDPackageItemI("CSSDPIPackageIndex",PackageRowId,ItemDetailRowId)) q:ItemDetailRowId=""  d
	.s objItem=##class(User.CSSDPackageItem).%OpenId(ItemDetailRowId)
	.d objItem.%Reload()
	.s Sort=objItem.CSSDPISORT
	.s ^TMPITMINFO(PackageRowId,"DETAIL",Sort,ItemDetailRowId)=ItemDetailRowId
	s number=0
	s (inList,ItemSort,RowId)=""
	f  s ItemSort=$o(^TMPITMINFO(PackageRowId,"DETAIL",ItemSort)) q:ItemSort=""  d
	.f  s RowId=$o(^TMPITMINFO(PackageRowId,"DETAIL",ItemSort,RowId)) q:RowId=""  d
	..s objPackageItem=""
	..s objPackageItem=##class(User.CSSDPackageItem).%OpenId(RowId)
	..d objPackageItem.%Reload()
	..q:objPackageItem=""
	..s itmDr=objPackageItem.CSSDPIItmDR.%Id()
	..q:itmDr=""
	..s Desc=objPackageItem.CSSDPIItmDR.CSSDIDesc
	..s Spec=objPackageItem.CSSDPIItmDR.CSSDISpec
	..s Qty=objPackageItem.CSSDPIQty
	..s SerialNo=objPackageItem.CSSDPISORT
	..i inList="" s inList=Desc_""_Qty
	..e  d
	...i (number#detailLine=0)&&(inList'="") d
	....s inList=inList_";"_Desc_""_Qty	//前台JSON解析不支持后台的$c(2),所以用;标注，前台进行replace
	...e  s inList=inList_"^"_Desc_""_Qty
	..s number=number+1
	s RtnObj.msg=inList
	q RtnObj.Json()
}

/// Creator:ban
/// CreatDate:2020-11-17
/// Description:根据参数获取包相关信息
/// Table:
/// w ##class(web.CSSDHUI.Pack.Package).GetPrintComposeLabelInfo("20012020071100001","","","","","Y","2")
ClassMethod GetPrintComposeLabelInfo(label As %String, Params As %String) As %String
{
	n (label,Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	i Params=""	d RtnObj.Err(-1,"","入参不能为空!")
	q:RtnObj.success<0 RtnObj.Json()
	s Sc=PJObj.%FromJSON(Params)
	i (Sc'=0) q RtnObj.Err(-1,"","入参解析失败").Json()
	s ToLoc = PJObj.%Get("ToLoc")
	s PotNoValue = PJObj.%Get("PotNoValue")
	s HeatNo = PJObj.%Get("HeatNo")
	s packNum = PJObj.%Get("packNum")
	s AckUser = PJObj.%Get("AckUser")
	s packId=$o(^User.CSSDPackagePackI("CSSDPPLabelIndex",label,""))
	i packId="" d RtnObj.Err(-1,"","未获取到包装信息!")
	q:RtnObj.success<0 RtnObj.Json()

	s pkgPack=##Class(User.CSSDPackagePack).%OpenId(packId)
	d pkgPack.%Reload()
	s (AckUserName,ChkUserName,PackUserName)=""
	;包装人
	s User=pkgPack.CSSDPPUserDr
	s:$IsObject(User) UserName=User.SSUSRName
	;s UserName=User.SSUSRName
	;审核人
	s ChkUser=pkgPack.CSSDPPAckUserDr
	s:$IsObject(ChkUser) ChkUserName=ChkUser.SSUSRName
	;s ChkUserName=ChkUser.SSUSRName
	;配包人
	s PackUser=pkgPack.CSSDPPPackUserDr
	s:$IsObject(PackUser) PackUserName=PackUser.SSUSRName
	;灭菌人
	s SterUser=pkgPack.CSSDPPSterUserDr
	s:$IsObject(SterUser) SterUserName=SterUser.SSUSRName

	s PackageObject=pkgPack.CSSDPPPackage
	s (PackageDesc,PackageLocId,PackageID)=""
	i $IsObject(PackageObject) d
	.s PackageDesc=PackageObject.CSSDPDesc
	.s PackageLocId=PackageObject.CSSDPLOCDRGetObjectId()
	.s PackageID=PackageObject.%Id()

	s composeId="",detailQty=0
	f  s composeId=$o(^User.CSSDCleanPackComposeI("ComposeLabelIndex",label,composeId)) q:composeId=""  d
	.s composeObj = ##class(User.CSSDCleanPackCompose).%OpenId(composeId)
	.d composeObj.%Reload()
	.s Qty = composeObj.CSSDCDPCQty
	.s detailQty = detailQty+Qty

	i ((detailQty'="")||(detailQty'=0)) s PackageDesc=PackageDesc_" ("_detailQty_"个)"
	i packNum'="" s PackageDesc=PackageDesc_" ("_packNum_"个)"
	s locId=pkgPack.CSSDPPApplyLocGetObjectId()
	s LocName="临床科室"
	s:locId'="" LocName=$p(^CTLOC(locId),"^",2)
	i locId="" d
	.s:PackageLocId'="" LocName=$p(^CTLOC(PackageLocId),"^",2)
	i ToLoc'="" s LocName=$p(^CTLOC(ToLoc),"^",2)
	s PackLoc=pkgPack.CSSDPPPackLocDr
	s PackLocDr=""
	s:$IsObject(PackLoc) PackLocDr=PackLoc.%Id()
	s:PackLocDr'="" LocName=$p(^CTLOC(PackLocDr),"^",2)
	s (SterTypeName,MachineNum)=""
	i PotNoValue'="" d
	.s MachineObj=##Class(User.CSSDMachineConfig).%OpenId(PotNoValue)
	.d MachineObj.%Reload()
	.s MachineNum = MachineObj.CSSDMCNum
	.i ((MachineNum>0)&&(MachineNum<10)) s MachineNum = $e(MachineNum,$l(MachineNum))
	s MachinePot = MachineNum_"/"_HeatNo

	s transId=$o(^User.CSSDTransI("CSSDTLabel",label,""))
	s TransObj=##Class(User.CSSDTrans).%OpenId(transId)
	s strExpDate=TransObj.CSSDTExpDate		;失效日期
	s ValidDateH=strExpDate-1				;有效日期
	i strExpDate'="" s strExpDate=..DL2H(strExpDate)
	s ValidDate=..DL2H(ValidDateH)
	s packDate=TransObj.CSSDTDate
	s packDate=..DL2H(packDate)

	s (SterTypeDr,SterTypeName)=""
	s SterTypeInfo=##class(User.CSSDPackage).%OpenId(PackageID).CSSDPSterType
	i $IsObject(SterTypeInfo) d
	.d SterTypeInfo.%Reload()
	.s SterTypeDr=SterTypeInfo.%Id()
	.s SterTypeName=$List(^User.CSSDSterTypeD(SterTypeDr),3)

	&sql(UPDATE CSSD_PackagePack set CSSDPP_PrtTimes=CSSDPP_PrtTimes+1 where CSSDPP_Label=:label)
	Set printObj =  ##class(ext.util.JsonObject).%New()
	/*label,LocName 等为XML模板中的元素名*/
	do printObj.Put("label",label).Put("LocName",LocName).Put("strExpDate",strExpDate).Put("AckUserName",UserName).Put("ValidDate",ValidDate)
	do printObj.Put("ChkUserName",ChkUserName).Put("PackageDesc",PackageDesc).Put("packDate",packDate)
	do printObj.Put("SterTypeName",SterTypeName).Put("MachinePot",MachinePot).Put("PackUserName",PackUserName)
	do printObj.Put("SterUserName",SterUserName)
	set rtn = printObj.GetPrintData()
	do printObj.%Close()
	Set printObj = ""
	quit rtn
}

/// Creator:ban
/// CreatDate:2020-04-17
/// Description:根据配置控制返回的列数，调整打印模板列数即打印几列明细
/// Table:
/// w ##class(web.CSSDHUI.Pack.Package).GetComposeItms()
ClassMethod GetComposeItms(Params As %String) As %String
{
	n (Params)

	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i Params=""	d RtnObj.Err(-1,"","入参不能为空!")
	q:RtnObj.success<0 RtnObj.Json()

	s PJobj=##class(web.CSSDHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s label=PJobj.%Get("label")
	s gUserId=PJobj.%Get("gUserId")
	s gLocId=PJobj.%Get("gLocId")
	s gGroupId=PJobj.%Get("gGroupId")
	s gHospId=PJobj.%Get("gHospId")
	s AppName=..%GetParameter("AppName")
	s Param=gGroupId_"^"_gLocId_"^"_gUserId_"^"_gHospId
	s isPackUserValue=##class(web.CSSDHUI.Common.AppCommon).GetParamValue(AppName,"IsPackUser",Param)
	s detailLine=##Class(web.CSSDHUI.Common.AppCommon).GetParamValue(AppName,"PrintDetailNum",Param)
	s:detailLine="" detailLine=1

	s packId=$o(^User.CSSDPackagePackI("CSSDPPLabelIndex",label,""))
	i packId="" d RtnObj.Err(-2,"","未获取到包装信息！")
	q:RtnObj.success<0 RtnObj.Json()

	s pkgPack=##Class(User.CSSDPackagePack).%OpenId(packId)
	d pkgPack.%Reload()
	s PackageRowId=pkgPack.CSSDPPPackageGetObjectId()
	i PackageRowId="" d RtnObj.Err(-3,"","未获取到消毒包信息！")
	q:RtnObj.success<0 RtnObj.Json()

	s number=0
	s (RowId,inList)=""
	f  s RowId=$o(^User.CSSDCleanPackComposeI("ComposeLabelIndex",label,RowId)) q:RowId=""  d
	.s objComposeItem=""
	.s objComposeItem=##class(User.CSSDCleanPackCompose).%OpenId(RowId)
	.d objComposeItem.%Reload()
	.q:objComposeItem=""
	.s ComposePkgDr=objComposeItem.CSSDCDPCPkgDr.%Id()
	.q:ComposePkgDr=""
	.s packageObj = ##class(User.CSSDPackage).%OpenId(ComposePkgDr)
	.d packageObj.%Reload()
	.s Desc=packageObj.CSSDPDesc
	.s Qty=objComposeItem.CSSDCDPCQty
	.i inList="" s inList=Desc_":"_Qty
	.e  d
	..i (number#detailLine=0)&&(inList'="") d
	...s inList=inList_";"_Desc_":"_Qty	//前台JSON解析不支持后台的$c(2),所以用;标注，前台进行replace
	..e  s inList=inList_"^"_Desc_":"_Qty
	.s number=number+1
	s RtnObj.msg=inList
	q RtnObj.Json()
}

}
