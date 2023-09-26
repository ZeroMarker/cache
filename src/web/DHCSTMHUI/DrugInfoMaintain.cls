Import sqluser

Class web.DHCSTMHUI.DrugInfoMaintain Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTDRUGMAINTAINM";

Parameter AppTable [ Final ] = "INC_Itm";

/// 是否允许多院区代码重复 Y:不允许，N:允许
Parameter CodeOnly [ Final ] = "Y";

/// Descript:   查询三大项信息(query改完Method解决慢的问题)
/// Creator:    zhangxiao
/// Date: 		20200519
/// Table:INC_Itm,DHC_IncItmAddionInfo,Arc_ItmMast,PHC_DrgMast,PHC_DrgForm
/// w ##class(web.DHCSTMHUI.DrugInfoMaintain).GetItmDetail("1","15","","","{""StkGrp"":"""",""gUserId"":""6423"",""gLocId"":""163"",""gGroupId"":""277"",""gHospId"":""2"",""StkCat"":"""",""NotUse"":"""",""HighPrice"":"""",""ArcBox"":"""",""HighRiskBox"":"""",""InciDesc"":"""",""Vendor"":"""",""Inci"":"""",""InciCode"":"""",""CreateStartDate"":"""",""CreateEndDate"":"""",""Alias"":"""",""UpdateStartDate"":"""",""UpdateEndDate"":"""",""RowId"":""2"",""BDPHospital"":""2""}")
ClassMethod GetItmDetail(page As %String, rows As %String, sort As %String, order As %String, Params As %String) As %String
{
	n (page, rows,sort,order,Params,%session)
	s Start=(page-1)*rows
	s Limit=rows
	s End=Start+Limit
	
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s pRowId=PJobj.%Get("Inci")
	s pInciCode=PJobj.%Get("InciCode")
	s pInciDesc=PJobj.%Get("InciDesc")
	s pAlias=PJobj.%Get("Alias")
	s pStkCatId=PJobj.%Get("StkCat")
	s pNotUse=PJobj.%Get("NotUse")
	s gUserId=PJobj.%Get("gUserId")
	s pHighPrice=PJobj.%Get("HighPrice")
	s pCharge=PJobj.%Get("Charge")
	s pImplantation=PJobj.%Get("Implantation")
	s gLocId=PJobj.%Get("gLocId") 
	s gHospId=PJobj.%Get("gHospId")
	s pHospId=PJobj.%Get("BDPHospital")
	s gHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	s pVendorId=PJobj.%Get("Vendor")
	s pAckSpFlag=PJobj.%Get("ArcBox")
	s pCatGrpStr=PJobj.%Get("StkGrp")
	s pDefaRp=PJobj.%Get("DefaRp")
	s pSpec=PJobj.%Get("Spec")
	s pBrand=PJobj.%Get("Brand")
	s pAbbrev=PJobj.%Get("Abbrev")
	s pBRp=PJobj.%Get("BRp")
	s pBSp=PJobj.%Get("BSp")
	s pUpdateStartDate=PJobj.%Get("UpdateStartDate")
	s pUpdateEndDate=PJobj.%Get("UpdateEndDate")
	s pCreateStartDate=PJobj.%Get("CreateStartDate")
	s pCreateEndDate=PJobj.%Get("CreateEndDate")
	s pUpdateStartDate=..DH2L(pUpdateStartDate)
	s pUpdateEndDate=..DH2L(pUpdateEndDate)
	s pCreateStartDate=..DH2L(pCreateStartDate)
	s pCreateEndDate=..DH2L(pCreateEndDate)
	s pCreateUser=PJobj.%Get("CreateUser")
	s pManf=PJobj.%Get("Manf")
	s HighRisk=PJobj.%Get("HighRiskBox")
	s pRegisterNo=PJobj.%Get("pRegisterNo")
	s pArcCode=PJobj.%Get("ArcCode")
	s pSp=PJobj.%Get("Sp")
	s CatGrpStr=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(gUserId,..sssCode(),gLocId,pCatGrpStr,gHospId)
	
	// 1.根据各条件优先使用相关索引,获取组织inci的临时global
	s pInciCode=$$ALPHAUP^SSUTIL4(pInciCode)
	s pInciDesc=$$ALPHAUP^SSUTIL4(pInciDesc)
	s pAlias=$$ALPHAUP^SSUTIL4(pAlias)
	s StrParam=pInciCode_"^"_pInciDesc_"^"_pAlias_"^"_pStkCatId
	i pRowId'="" d
	.s ret=..GetItmByRowId(pRowId)
	e  i pInciCode'=""  d
	.s ret=..GetItmByCode(StrParam,CatGrpStr)
	e  i pInciDesc'="" d
	.s ret=..GetItmByDesc(StrParam,CatGrpStr)
	e  i pAlias'=""  d
	.s ret=..GetItmByAlias(StrParam,CatGrpStr)
	e  i pStkCatId'=""  d
	.s ret=..GetItmByStkCat(StrParam)
	e  d
	.s ret=..GetAllItm(CatGrpStr)

	s pid=$p(ret,"^",1)
	s count=$p(ret,"^",2)
	i pid=""  q $$$OK
	// 2.根据inci临时global ^TMPITMINFO(pid,"ITM",inci)=""
	// 组织用于输出的global ^TMPITMINFO(pid,"DETAIL",Sub,num)=InciId
	// 其中Sub节点为排序使用
	k ^TMPITMINFO(pid,"DETAIL")
	s num=0
	s InciId=0
	f  s InciId=$o(^TMPITMINFO(pid,"ITM",InciId)) q:InciId=""  d
	.s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag(..#AppTable,InciId,gHospId)
	.q:ShowDataFlag="N"
	.s InfoRowId=$o(^DHCITMINFO(0,"INCI",InciId,""))
	.s (HighPrice,Charge,Implantation,Spec,Brand,Model,Abbrev,AckSpFlag,CreateDate,UpdateDate,CreateUser)=""
	.i InfoRowId'="" d
	..s InfoData=$G(^DHCITMINFO(InfoRowId))
	..q:InfoData=""
	..s HighPrice=$p(InfoData,"^",12)
	..s Charge=$p(InfoData,"^",57)
	..s Implantation=$p(InfoData,"^",62)
	..s Spec=$p(InfoData,"^",27)
	..s Brand=$p(InfoData,"^",58)
	..s Model=$p(InfoData,"^",59)
	..s HighRiskFlag=$p(InfoData,"^",50)
	..s Abbrev=$p(InfoData,"^",60)
	..s AckSpFlag=$p(InfoData,"^",17)
	..s CreateDate=$p(InfoData,"^",94)
	..s CreateUser=$p(InfoData,"^",112)
	..s:HighRiskFlag="" HighRiskFlag="N"
	.s Remarks=""
	.i $d(^INCI(InciId,"REM",1))  d
	..s Remarks=^INCI(InciId,"REM",1)
	.
	.q:(pCreateUser'="")&&(pCreateUser'=CreateUser)
	.q:(pSpec'="")&&(Spec'[pSpec)
	.q:(pBrand'="")&&(Brand'[pBrand)
	.q:(pAbbrev'="")&&(Abbrev'[pAbbrev)
	.s:HighPrice="" HighPrice="N"
	.q:(pHighPrice'="")&&(pHighPrice'=HighPrice)
	.s:Charge="" Charge="N"
	.q:(pCharge'="")&(pCharge'=Charge)					//Y-收费; N-非收费
	.s:Implantation="" Implantation="N"
	.q:(pImplantation'="")&(pImplantation'=Implantation)	//Y-植入; N-非植入
	.q:(HighRisk'="")&&(HighRisk'=HighRiskFlag)
	.i pAckSpFlag'="" d
	..s Arcim=$p(^INCI(InciId,1),"^",3)
	..s AckSpFlag=$s(((AckSpFlag="Y")||(Arcim'="")):"Y",1:"N")
	.q:(pAckSpFlag'="")&&(pAckSpFlag'=AckSpFlag)
	.s PurUomId=$p(^INCI(InciId,3),"^",6)
	.s BUomId=$p(^INCI(InciId,1),"^",10)
	.i (+pBRp'=0) d
	..s BRp=..Rp(InciId,BUomId,gHospId,pDefaRp)
	.q:(+pBRp'=0)&&(+pBRp'=+BRp)
	.i (+pBSp'=0) d
	..s BSp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(InciId,+$h,BUomId,gHospId)
	.q:(+pBSp'=0)&&(+pBSp'=+BSp)
	.i (+pSp'=0) d
	..s ifexitbatadjpricestr=##class(web.DHCSTMHUI.Common.PriceCommon).IfExitBatAdjprice(InciId)
	..s ifexitbatadjprice=$p(ifexitbatadjpricestr,"^",1)
	..s BatFlag=$p(ifexitbatadjpricestr,"^",2)
	..s AspInfo=##class(web.DHCSTMHUI.INCITM).GetINCPrice(InciId,+$h,PurUomId,"")
	..i ((ifexitbatadjprice'="Y")&&(BatFlag=1)) d
	...s Sp=$p(AspInfo,"^",2) ;当前售价
	..e  d
	...s Sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(InciId,+$h,PurUomId,gHospId)
	.q:(+pSp'=0)&&(+pSp'=+Sp)
	.s NotUseFlag=$p(^INCI(InciId,2),"^",9)
	.s:NotUseFlag="" NotUseFlag="N"
	.q:(pNotUse'="")&(pNotUse'=NotUseFlag)          ;不显示不可用项目
	.i (pVendorId'="") d
	..s VendorStr=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPbVendor(+InciId)
	..s VendorId=$p(VendorStr,"^",1)
	.q:(pVendorId'="")&&(pVendorId'=VendorId)
	.i pManf'="" d
	..s ManfInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPbManf(+InciId)
	..s ManfId=$p(ManfInfo,"^",1)
	.q:(pManf'="")&&(pManf'=ManfId)
	.i pRegisterNo'="" d
	..s RegisterNoInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetCert(+InciId,"")
	..s RegisterNo=$p(RegisterNoInfo,"^",1)
	.q:(pRegisterNo'="")&&(RegisterNo'[pRegisterNo)
	.s ArcId=$p(^INCI(InciId,1),"^",3)
	.i pArcCode'="" d
	..s arccode=$s(ArcId'="":$p(^ARCIM(+ArcId,$p(ArcId,"||",2),1),"^",1),1:"")
	.q:(pArcCode'="")&&(arccode'[pArcCode)
	.s UpdateDate=$p(^INCI(InciId,3),"^",1)
	.q:(pCreateStartDate'="")&&((pCreateStartDate>CreateDate)!(CreateDate=""))
	.q:(pCreateEndDate'="")&&((pCreateEndDate<CreateDate)!(CreateDate=""))
	.q:(pUpdateStartDate'="")&&(pUpdateStartDate>UpdateDate)
	.q:(pUpdateEndDate'="")&&(pUpdateEndDate<UpdateDate)
	.s num=num+1
	.s Sub=""
	.i sort="InciCode" d
	..s InciCode=$p(^INCI(InciId,1),"^",1)
	..s Sub=InciCode
	.e  i sort="InciDesc" d
	..s InciDesc=$p(^INCI(InciId,1),"^",2)
	..s Sub=InciDesc
	.e  i sort="Spec" d
	..s Sub=$g(Spec)
	.e  i sort="Manf" d
	..s Manf=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPbManf(+InciId)
	..s Manf=$p(Manf,"^",2)
	..s Sub=Manf
	.e  i sort="PurUom" d
	..s PurUomDesc=$p(^CT("UOM",PurUomId),"^",2)
	..s Sub=PurUomDesc
	.e  i sort="Sp" d
	..s Sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(InciId,+$h,PurUomId,gHospId)
	..s Sub=Sp
	.e  i sort="Rp" d
	..s Rp=..Rp(InciId,PurUomId,gHospId,pDefaRp)
	..s Sub=Rp
	.e  i sort="BUom" d
	..s BUomDesc=$p(^CT("UOM",BUomId),"^",2)
	..s Sub=BUomDesc
	.e  i sort="BillUom" d
	..s ArcId=$p(^INCI(InciId,1),"^",3)
	..s BillUom=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetArcBuom(ArcId)
	..s BillUomDesc=$p(BillUom,"^",2) 
	..s Sub=BillUomDesc
	.e  i sort="StkCatDesc" d
	..s StkCatId=$p(^INCI(InciId,2),"^",2)
	..s StkCatDesc=$p($G(^INC("SC",StkCatId)),"^",2)
	..s Sub=StkCatDesc
	.e  i sort="NotUseFlag" d
	..s Sub=NotUseFlag
	.e  i sort="BRp" d
	..i (+$g(BRp)=0) d
	...s BRp=..Rp(InciId,BUomId,gHospId,pDefaRp)
	..s Sub=BRp
	.e  i sort="Implantation" d
	..s Sub=Implantation
	.e  i sort="Marginnow" d
	..s Sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(InciId,+$h,PurUomId,gHospId)
	..s Rp=..Rp(InciId,PurUomId,gHospId,pDefaRp)
	..s Marginnow=$s(+Rp'=0:Sp/Rp,1:"")
	..s Sub=Marginnow
	.e  i sort="Brand" d
	..s Sub=Brand
	.e  i sort="HighPrice" d
	..s Sub=HighPrice
	.e  d
	..s Sub=InciId
	.
	.s:Sub="" Sub="*"
	.s ^TMPITMINFO(pid,"DETAIL",Sub,num)=InciId
	
	// 3.输出明细
	s json = ##class(web.DHCSTMHUI.Common.JsonObj).%New()
	s order=$$ALPHAUP^SSUTIL4(order)
	s:order="" order="ASC"
	s orderFlag=$s(order="ASC":1,1:-1)
	s num=0
	s sub=""
	f  s sub=$o(^TMPITMINFO(pid,"DETAIL",sub),orderFlag) q:sub=""  d
	.s chl=""
	.f  s chl=$o(^TMPITMINFO(pid,"DETAIL",sub,chl),orderFlag) q:chl=""  d
	..s num=num+1
	..q:num<=Start
	..q:num>End
	..s InciId=$p(^TMPITMINFO(pid,"DETAIL",sub,chl),"^",1)
	..d GetInciInformation(InciId)
	
	s Title1="RowId^InciCode^InciDesc^Spec^Manf^PurUom"
	s Title2="Sp:number^Rp:number^BUom^BillUom^StkCatDesc^NotUseFlag"
	s Title3="VendorId^VendorName^RegisterNo^RegisterNoExpDate^Brand^Marginnow"
	s Title4="BRp^HighPrice^Charge^Implantation^Model^Remarks"
	s Title5="PhcdCode^Supervision^InciCreateDate^InciCreateTime^InciUpdateDate^InciUpdateTime"
	s Title6="ArcId^Origin^RegCertDateOfIssue^RegItmDesc^RegCertNoFull^MaxSp:number"
	s Title7="CreateUser^BarCode^insProLicText^firstProdLicText^insBusLicText^secondBusLicText"
	s Title=Title1_"^"_Title2_"^"_Title3_"^"_Title4_"^"_Title5_"^"_Title6_"^"_Title7
	d json.getJsonData(Title,num)
	k ^TMPITMINFO(pid)
	k json
	q ""
	
GetInciInformation(InciId)
	s data=""
	i InciId d
	.s (HighPric,Charge,Implantation,Spec,Brand,Model,Remarks,Abbrev,Supervision,Origin,MaxSp,CreateUserId,insProLicText,firstProdLicText,insBusLicText,secondBusLicText)=""
	.s InfoRowId=$o(^DHCITMINFO(0,"INCI",InciId,""))
	.i InfoRowId'="" d
	..s InfoData=$G(^DHCITMINFO(InfoRowId))
	..q:InfoData=""
	..s HighPrice=$p(InfoData,"^",12)
	..s MaxSp=$p(InfoData,"^",16)
	..s Spec=$p(InfoData,"^",27)
	..s Charge=$p(InfoData,"^",57)
	..s Brand=$p(InfoData,"^",58)
	..s Model=$p(InfoData,"^",59)
	..s Abbrev=$p(InfoData,"^",60)
	..s Supervision=$p(InfoData,"^",61)
	..s Implantation=$p(InfoData,"^",62)
	..s OriginId=$p(InfoData,"^",100)
	..s:OriginId'="" Origin=$p(^DHCSTORI(OriginId),"^",2)
	..s CreateUser=$p(InfoData,"^",112)
	.s Remarks=""
	.i $d(^INCI(InciId,"REM",1))  d
	..s Remarks=^INCI(InciId,"REM",1)
	.s:HighPrice="" HighPrice="N"
	.s:Charge="" Charge="N"
	.s:Implantation="" Implantation="N"
	.s CreateUser=$s(CreateUserId'="":$p(^SSU("SSUSR",CreateUserId),"^",2),1:"")
	.s InciCode=$p(^INCI(InciId,1),"^",1)
	.s InciDesc=$p(^INCI(InciId,1),"^",2)
	.s ManfInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPbManf(+InciId)
	.s ManfId=$p(ManfInfo,"^",1)
	.s Manf=$p(ManfInfo,"^",2)
	.s PurUomId=$p(^INCI(InciId,3),"^",6)
	.s BUomDesc="",PurUomDesc="",StkCatDesc=""
	.s BUomId=$p(^INCI(InciId,1),"^",10)
	.s:BUomId'="" BUomDesc=$p(^CT("UOM",BUomId),"^",2)
	.s:PurUomId'="" PurUomDesc=$p(^CT("UOM",PurUomId),"^",2)
	.s ifexitbatadjpricestr=##class(web.DHCSTMHUI.Common.PriceCommon).IfExitBatAdjprice(InciId)
	.s ifexitbatadjprice=$p(ifexitbatadjpricestr,"^",1)
	.s BatFlag=$p(ifexitbatadjpricestr,"^",2)
	.s AspInfo=##class(web.DHCSTMHUI.INCITM).GetINCPrice(InciId,+$h,PurUomId,"")
	.if ((ifexitbatadjprice'="Y")&&(BatFlag=1)) d
	..s Sp=$p(AspInfo,"^",2) ;当前售价
	.e  d
	..s Sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(InciId,+$h,PurUomId,gHospId)
	.if ((pDefaRp'=3)&&(ifexitbatadjprice'="Y")&&(BatFlag=1)) d  ;批次售价且无批次信息且不取招标进价的时候
	..s Rp=$p(AspInfo,"^",1) ;当前进价
	.e  d
	..s Rp=..Rp(InciId,PurUomId,gHospId,pDefaRp)
	.s bRp=..Rp(InciId,BUomId,gHospId,pDefaRp)
	.s bSp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(InciId,+$h,BUomId,gHospId)
	.s StkCatId=$p(^INCI(InciId,2),"^",2)
	.s:StkCatId'="" StkCatDesc=$p($G(^INC("SC",StkCatId)),"^",2)
	.s NotUseFlag=$p(^INCI(InciId,2),"^",9)
	.s ArcId=$p(^INCI(InciId,1),"^",3)
	.s BillUom=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetArcBuom(ArcId)
	.s BillUomDesc=$p(BillUom,"^",2)   
	.s VendorStr=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPbVendor(+InciId)
	.s VendorId=$p(VendorStr,"^")
	.s VendorName=$p(VendorStr,"^",2)
	.s CertStr=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetCert(+InciId)
	.s RegisterNo=$p(CertStr,"^",1)
	.s RegisterNoExpDate=$p(CertStr,"^",2)
	.s RegItmDesc=$p(CertStr,"^",3)
	.s RegCertDateOfIssue=$p(CertStr,"^",22)
	.s RegValidLong=$p(CertStr,"^",7)
	.s RegExpExtended=$p(CertStr,"^",6)
	.s RegCertNoFull=$p(CertStr,"^",4)
	.s Marginnow=""
	.s:+Rp'=0 Marginnow=Sp/Rp,Marginnow=$fn(Marginnow,"",3)
	.s PhcdCode=""
	.s Phcdf=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPhcdf(InciId)
	.s:+Phcdf'=0 PhcdCode=$p(^PHCD(+Phcdf,1),"^",2)
	.s InciDateStr=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetInciCreateDate(InciId)
	.s InciCreateDate=$p(InciDateStr,"^",1)
	.s:InciCreateDate'="" InciCreateDate=..DL2H(InciCreateDate)
	.s InciCreateTime=$p(InciDateStr,"^",2)
	.s:InciCreateTime'="" InciCreateTime=..TL2H(InciCreateTime)
	.s InciUpdateDate=$p(InciDateStr,"^",3)
	.s:InciUpdateDate'="" InciUpdateDate=..DL2H(InciUpdateDate)
	.s InciUpdateTime=$p(InciDateStr,"^",4)
	.s:InciUpdateTime'="" InciUpdateTime=..TL2H(InciUpdateTime)
	.s BarCode=$p(^INCI(InciId,3),"^",9)
	.i ManfId'="" d
	..s insProLicInfo=##class(web.DHCSTMHUI.DHCCertDetail).GetCertDetailInfo("Manf",ManfId,"insProLic")
	..s insProLicText=$p(insProLicInfo,"^",1)
	..s firstProdLicInfo=##class(web.DHCSTMHUI.DHCCertDetail).GetCertDetailInfo("Manf",ManfId,"firstProdLic")
	..s firstProdLicText=$p(firstProdLicInfo,"^",1)
	.i VendorId'="" d
	..s insBusLicInfo=##class(web.DHCSTMHUI.DHCCertDetail).GetCertDetailInfo("Vendor",VendorId,"insBusLic")
	..s insBusLicText=$p(insBusLicInfo,"^",1)
	..s secondBusLicInfo=##class(web.DHCSTMHUI.DHCCertDetail).GetCertDetailInfo("Vendor",VendorId,"secondBusLic")
	..s secondBusLicText=$p(secondBusLicInfo,"^",1)	
	.;s count = count+1
	.;q:count<=Start
	.;q:count>End
	.s Data1=InciId_"^"_InciCode_"^"_InciDesc_"^"_Spec_"^"_Manf_"^"_PurUomDesc
	.s Data2=Sp_"^"_Rp_"^"_BUomDesc_"^"_BillUomDesc_"^"_StkCatDesc_"^"_NotUseFlag
	.s Data3=VendorId_"^"_VendorName_"^"_RegisterNo_"^"_RegisterNoExpDate_"^"_Brand_"^"_Marginnow
	.s Data4=bRp_"^"_HighPrice_"^"_Charge_"^"_Implantation_"^"_Model_"^"_Remarks
	.s Data5=PhcdCode_"^"_Supervision_"^"_InciCreateDate_"^"_InciCreateTime_"^"_InciUpdateDate_"^"_InciUpdateTime
	.s Data6=ArcId_"^"_Origin_"^"_RegCertDateOfIssue_"^"_RegItmDesc_"^"_RegCertNoFull_"^"_MaxSp
	.s Data7=CreateUser_"^"_BarCode_"^"_insProLicText_"^"_firstProdLicText_"^"_insBusLicText_"^"_secondBusLicText
	.s Data=Data1_"^"_Data2_"^"_Data3_"^"_Data4_"^"_Data5_"^"_Data6_"^"_Data7
	.d json.InsertRowData(Data)
}

/// Descript:   查询三大项信息
/// Creator:    XuChao
/// Date: 		2018-12-14
/// Table:I		NC_Itm,DHC_IncItmAddionInfo,Arc_ItmMast,PHC_DrgMast,PHC_DrgForm
/// Input:
/// Output:
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DrugInfoMaintain","GetItm","","","{""StkGrp"":""12"",""gUserId"":""873"",""gLocId"":""153"",""gGroupId"":""98"",""gHospId"":""2"",""StkCat"":"""",""NotUse"":"""",""HighPrice"":"""",""ArcBox"":"""",""InciDesc"":"""",""Vendor"":"""",""Charge"":"""",""Inci"":"""",""InciCode"":"""",""CreateStartDate"":"""",""CreateEndDate"":"""",""Alias"":"""",""UpdateStartDate"":"""",""UpdateEndDate"":"""",""BDPHospital"":""2""}")
Query GetItm(sort As %String, order As %String, Params As %String) As Query(ROWSPEC = "RowId,InciCode,InciDesc,Spec,Manf,PurUom,Sp:%Float,Rp:%Float,BUom,BillUom,StkCatDesc,NotUseFlag,VendorId,VendorName,RegisterNo,RegisterNoExpDate,Brand,Marginnow:%Float,BRp:%Float,HighPrice,Charge,Implantation,Model,Remarks,PhcdCode,Supervision,InciCreateDate,InciCreateTime,InciUpdateDate,InciUpdateTime,ArcId,Origin,RegCertDateOfIssue,RegItmDesc,RegCertNoFull,MaxSp:%Float,CreateUser,BarCode,insProLicText,firstProdLicText,insBusLicText,secondBusLicText") [ SqlProc ]
{
}

ClassMethod GetItmExecute(ByRef qHandle As %Binary, sort As %String, order As %String, Params As %String) As %Status
{
	n (qHandle,sort,order,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	 
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s pRowId=PJobj.%Get("Inci")
	s pInciCode=PJobj.%Get("InciCode")
	s pInciDesc=PJobj.%Get("InciDesc")
	s pAlias=PJobj.%Get("Alias")
	s pStkCatId=PJobj.%Get("StkCat")
	s pNotUse=PJobj.%Get("NotUse")
	s gUserId=PJobj.%Get("gUserId")
	s pHighPrice=PJobj.%Get("HighPrice")
	s pCharge=PJobj.%Get("Charge")
	s pImplantation=PJobj.%Get("Implantation")
	s gLocId=PJobj.%Get("gLocId") 
	s gHospId=PJobj.%Get("gHospId")
	s pHospId=PJobj.%Get("BDPHospital")
	s gHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	s pVendorId=PJobj.%Get("Vendor")
	s pAckSpFlag=PJobj.%Get("ArcBox")
	s pCatGrpStr=PJobj.%Get("StkGrp")
	s pDefaRp=PJobj.%Get("DefaRp")
	s pSpec=PJobj.%Get("Spec")
	s pBrand=PJobj.%Get("Brand")
	s pAbbrev=PJobj.%Get("Abbrev")
	s pBRp=PJobj.%Get("BRp")
	s pBSp=PJobj.%Get("BSp")
	s pUpdateStartDate=PJobj.%Get("UpdateStartDate")
	s pUpdateEndDate=PJobj.%Get("UpdateEndDate")
	s pCreateStartDate=PJobj.%Get("CreateStartDate")
	s pCreateEndDate=PJobj.%Get("CreateEndDate")
	s pUpdateStartDate=..DH2L(pUpdateStartDate)
	s pUpdateEndDate=..DH2L(pUpdateEndDate)
	s pCreateStartDate=..DH2L(pCreateStartDate)
	s pCreateEndDate=..DH2L(pCreateEndDate)
	s pCreateUser=PJobj.%Get("CreateUser")
	s pManf=PJobj.%Get("Manf")
	s NotLock=PJobj.%Get("NotLock")
	s HighRisk=PJobj.%Get("HighRiskBox")
	s CatGrpStr=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(gUserId,..sssCode(),gLocId,pCatGrpStr,gHospId)

	// 1.根据各条件优先使用相关索引,获取组织inci的临时global
	s pInciCode=$$ALPHAUP^SSUTIL4(pInciCode)
	s pInciDesc=$$ALPHAUP^SSUTIL4(pInciDesc)
	s pAlias=$$ALPHAUP^SSUTIL4(pAlias)
	s StrParam=pInciCode_"^"_pInciDesc_"^"_pAlias_"^"_pStkCatId
	i pRowId'="" d
	.s ret=..GetItmByRowId(pRowId)
	e  i pInciCode'=""  d
	.s ret=..GetItmByCode(StrParam,CatGrpStr)
	e  i pInciDesc'="" d
	.s ret=..GetItmByDesc(StrParam,CatGrpStr)
	e  i pAlias'=""  d
	.s ret=..GetItmByAlias(StrParam,CatGrpStr)
	e  i pStkCatId'=""  d
	.s ret=..GetItmByStkCat(StrParam)
	e  d
	.s ret=..GetAllItm(CatGrpStr)

	s pid=$p(ret,"^",1)
	s count=$p(ret,"^",2)
	i pid=""  q $$$OK
	// 2.根据inci临时global ^TMPITMINFO(pid,"ITM",inci)=""
	// 组织用于输出的global ^TMPITMINFO(pid,"DETAIL",Sub,num)=InciId
	// 其中Sub节点为排序使用
	k ^TMPITMINFO(pid,"DETAIL")
	s num=0
	s InciId=0
	f  s InciId=$o(^TMPITMINFO(pid,"ITM",InciId)) q:InciId=""  d
	.s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag(..#AppTable,InciId,gHospId)
	.q:ShowDataFlag="N"
	.s InfoRowId=$o(^DHCITMINFO(0,"INCI",InciId,""))
	.s (HighPrice,Charge,Implantation,Spec,Brand,Model,Remarks,AckSpFlag,CreateDate,UpdateDate,CreateUser)=""
	.i InfoRowId'="" d
	..s InfoData=$G(^DHCITMINFO(InfoRowId))
	..q:InfoData=""
	..s HighPrice=$p(InfoData,"^",12)
	..s Charge=$p(InfoData,"^",57)
	..s Implantation=$p(InfoData,"^",62)
	..s Spec=$p(InfoData,"^",27)
	..s Brand=$p(InfoData,"^",58)
	..s Model=$p(InfoData,"^",59)
	..s HighRiskFlag=$p(InfoData,"^",50)
	..s:HighRiskFlag="" HighRiskFlag="N"
	..s Abbrev=$p(InfoData,"^",60)
	..s AckSpFlag=$p(InfoData,"^",17)
	..s CreateDate=$p(InfoData,"^",94)
	..s CreateUser=$p(InfoData,"^",112)
	.s Remarks=""
	.i $d(^INCI(InciId,"REM",1))  d
	..s Remarks=^INCI(InciId,"REM",1)
	.
	.q:(pCreateUser'="")&&(pCreateUser'=CreateUser)
	.q:(pSpec'="")&&(Spec'[pSpec)
	.q:(pBrand'="")&&(Brand'[pBrand)
	.q:(pAbbrev'="")&&(Abbrev'[pAbbrev)
	.s:HighPrice="" HighPrice="N"
	.q:(pHighPrice'="")&&(pHighPrice'=HighPrice)
	.s:Charge="" Charge="N"
	.q:(pCharge'="")&(pCharge'=Charge)					//Y-收费; N-非收费
	.s:Implantation="" Implantation="N"
	.q:(pImplantation'="")&(pImplantation'=Implantation)	//Y-植入; N-非植入
	.q:(HighRisk'="")&&(HighRisk'=HighRiskFlag)
	.i pAckSpFlag'="" d
	..s Arcim=$p(^INCI(InciId,1),"^",3)
	..s AckSpFlag=$s(((AckSpFlag="Y")||(Arcim'="")):"Y",1:"N")
	.q:(pAckSpFlag'="")&&(pAckSpFlag'=AckSpFlag)
	.s PurUomId=$p(^INCI(InciId,3),"^",6)
	.s BUomId=$p(^INCI(InciId,1),"^",10)
	.i (+pBRp'=0) d
	..s BRp=..Rp(InciId,BUomId,gHospId,pDefaRp)
	.q:(+pBRp'=0)&&(+pBRp'=+BRp)
	.i (+pBSp'=0) d
	..s BSp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(InciId,+$h,BUomId,gHospId)
	.q:(+pBSp'=0)&&(+pBSp'=+BSp)
	.s NotUseFlag=$p(^INCI(InciId,2),"^",9)
	.s:NotUseFlag="" NotUseFlag="N"
	.q:(pNotUse'="")&(pNotUse'=NotUseFlag)          ;不显示不可用项目
	.i (pVendorId'="") d
	..s VendorStr=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPbVendor(+InciId)
	..s VendorId=$p(VendorStr,"^",1)
	.q:(pVendorId'="")&&(pVendorId'=VendorId)
	.i pManf'="" d
	..s ManfInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPbManf(+InciId)
	..s ManfId=$p(ManfInfo,"^",1)
	.q:(pManf'="")&&(pManf'=ManfId)
	.s UpdateDate=$p(^INCI(InciId,3),"^",1)
	.q:(pCreateStartDate'="")&&((pCreateStartDate>CreateDate)!(CreateDate=""))
	.q:(pCreateEndDate'="")&&((pCreateEndDate<CreateDate)!(CreateDate=""))
	.q:(pUpdateStartDate'="")&&(pUpdateStartDate>UpdateDate)
	.q:(pUpdateEndDate'="")&&(pUpdateEndDate<UpdateDate)
	.s PhaLock=""
	.i NotLock'="" d
	..s PhaLock=..GetIncilLock(InciId)
	.q:((NotLock'="")&&(PhaLock'=NotLock))
	.s num=num+1
	.s Sub=""
	.i sort="InciCode" d
	..s InciCode=$p(^INCI(InciId,1),"^",1)
	..s Sub=InciCode
	.e  i sort="InciDesc" d
	..s InciDesc=$p(^INCI(InciId,1),"^",2)
	..s Sub=InciDesc
	.e  i sort="Spec" d
	..s Sub=$g(Spec)
	.e  i sort="Manf" d
	..s Manf=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPbManf(+InciId)
	..s Manf=$p(Manf,"^",2)
	..s Sub=Manf
	.e  i sort="PurUom" d
	..s PurUomDesc=$p(^CT("UOM",PurUomId),"^",2)
	..s Sub=PurUomDesc
	.e  i sort="Sp" d
	..s Sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(InciId,+$h,PurUomId,gHospId)
	..s Sub=Sp
	.e  i sort="Rp" d
	..s Rp=..Rp(InciId,PurUomId,gHospId,pDefaRp)
	..s Sub=Rp
	.e  i sort="BUom" d
	..s BUomDesc=$p(^CT("UOM",BUomId),"^",2)
	..s Sub=BUomDesc
	.e  i sort="BillUom" d
	..s ArcId=$p(^INCI(InciId,1),"^",3)
	..s BillUom=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetArcBuom(ArcId)
	..s BillUomDesc=$p(BillUom,"^",2) 
	..s Sub=BillUomDesc
	.e  i sort="StkCatDesc" d
	..s StkCatId=$p(^INCI(InciId,2),"^",2)
	..s StkCatDesc=$p($G(^INC("SC",StkCatId)),"^",2)
	..s Sub=StkCatDesc
	.e  i sort="NotUseFlag" d
	..s Sub=NotUseFlag
	.e  i sort="BRp" d
	..i (+$g(BRp)=0) d
	...s BRp=..Rp(InciId,BUomId,gHospId,pDefaRp)
	..s Sub=BRp
	.e  i sort="Implantation" d
	..s Sub=Implantation
	.e  i sort="Marginnow" d
	..s Sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(InciId,+$h,PurUomId,gHospId)
	..s Rp=..Rp(InciId,PurUomId,gHospId,pDefaRp)
	..s Marginnow=$s(+Rp'=0:Sp/Rp,1:"")
	..s Sub=Marginnow
	.e  i sort="Brand" d
	..s Sub=Brand
	.e  i sort="HighPrice" d
	..s Sub=HighPrice
	.e  d
	..s Sub=InciId
	.
	.s:Sub="" Sub="*"
	.s ^TMPITMINFO(pid,"DETAIL",Sub,num)=InciId
	
	// 3.输出明细
	s order=$$ALPHAUP^SSUTIL4(order)
	s:order="" order="ASC"
	s orderFlag=$s(order="ASC":1,1:-1)
	s num=0
	s sub=""
	f  s sub=$o(^TMPITMINFO(pid,"DETAIL",sub),orderFlag) q:sub=""  d
	.s chl=""
	.f  s chl=$o(^TMPITMINFO(pid,"DETAIL",sub,chl),orderFlag) q:chl=""  d
	..s num=num+1
	..s InciId=$p(^TMPITMINFO(pid,"DETAIL",sub,chl),"^",1)
	..d GetInciDetail(InciId)
	k ^TMPITMINFO(pid)
 Quit $$$OK

GetInciDetail(InciId)
	s data=""
	i InciId d
	.s (HighPric,Charge,Implantation,Spec,Brand,Model,Remarks,Abbrev,Supervision,Origin,MaxSp,CreateUserId,insProLicText,firstProdLicText,insBusLicText,secondBusLicText)=""
	.s InfoRowId=$o(^DHCITMINFO(0,"INCI",InciId,""))
	.i InfoRowId'="" d
	..s InfoData=$G(^DHCITMINFO(InfoRowId))
	..q:InfoData=""
	..s HighPrice=$p(InfoData,"^",12)
	..s MaxSp=$p(InfoData,"^",16)
	..s Spec=$p(InfoData,"^",27)
	..s Charge=$p(InfoData,"^",57)
	..s Brand=$p(InfoData,"^",58)
	..s Model=$p(InfoData,"^",59)
	..s Abbrev=$p(InfoData,"^",60)
	..s Supervision=$p(InfoData,"^",61)
	..s Implantation=$p(InfoData,"^",62)
	..s OriginId=$p(InfoData,"^",100)
	..s:OriginId'="" Origin=$p(^DHCSTORI(OriginId),"^",2)
	..s CreateUser=$p(InfoData,"^",112)
	.s Remarks=""
	.i $d(^INCI(InciId,"REM",1))  d
	..s Remarks=^INCI(InciId,"REM",1)
	.s:HighPrice="" HighPrice="N"
	.s:Charge="" Charge="N"
	.s:Implantation="" Implantation="N"
	.s CreateUser=$s(CreateUserId'="":$p(^SSU("SSUSR",CreateUserId),"^",2),1:"")
	.s InciCode=$p(^INCI(InciId,1),"^",1)
	.s InciDesc=$p(^INCI(InciId,1),"^",2)
	.s ManfInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPbManf(+InciId)
	.s ManfId=$p(ManfInfo,"^",1)
	.s Manf=$p(ManfInfo,"^",2)
	.s PurUomId=$p(^INCI(InciId,3),"^",6)
	.s BUomDesc="",PurUomDesc="",StkCatDesc=""
	.s BUomId=$p(^INCI(InciId,1),"^",10)
	.s:BUomId'="" BUomDesc=$p(^CT("UOM",BUomId),"^",2)
	.s:PurUomId'="" PurUomDesc=$p(^CT("UOM",PurUomId),"^",2)
	.s ifexitbatadjpricestr=##class(web.DHCSTMHUI.Common.PriceCommon).IfExitBatAdjprice(InciId)
	.s ifexitbatadjprice=$p(ifexitbatadjpricestr,"^",1)
	.s BatFlag=$p(ifexitbatadjpricestr,"^",2)
	.s AspInfo=##class(web.DHCSTMHUI.INCITM).GetINCPrice(InciId,+$h,PurUomId,"")
	.if ((ifexitbatadjprice'="Y")&&(BatFlag=1)) d
	..s Sp=$p(AspInfo,"^",2) ;当前售价
	.e  d
	..s Sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(InciId,+$h,PurUomId,gHospId)
	.if ((pDefaRp'=3)&&(ifexitbatadjprice'="Y")&&(BatFlag=1)) d  ;批次售价且无批次信息且不取招标进价的时候
	..s Rp=$p(AspInfo,"^",1) ;当前进价
	.e  d
	..s Rp=..Rp(InciId,PurUomId,gHospId,pDefaRp)
	.s bRp=..Rp(InciId,BUomId,gHospId,pDefaRp)
	.s bSp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(InciId,+$h,BUomId,gHospId)
	.s StkCatId=$p(^INCI(InciId,2),"^",2)
	.s:StkCatId'="" StkCatDesc=$p($G(^INC("SC",StkCatId)),"^",2)
	.s NotUseFlag=$p(^INCI(InciId,2),"^",9)
	.s ArcId=$p(^INCI(InciId,1),"^",3)
	.s BillUom=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetArcBuom(ArcId)
	.s BillUomDesc=$p(BillUom,"^",2)   
	.s VendorStr=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPbVendor(+InciId)
	.s VendorId=$p(VendorStr,"^")
	.s VendorName=$p(VendorStr,"^",2)
	.s CertStr=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetCert(+InciId)
	.s RegisterNo=$p(CertStr,"^",1)
	.s RegisterNoExpDate=$p(CertStr,"^",2)
	.s RegItmDesc=$p(CertStr,"^",3)
	.s RegCertDateOfIssue=$p(CertStr,"^",22)
	.s RegValidLong=$p(CertStr,"^",7)
	.s RegExpExtended=$p(CertStr,"^",6)
	.s RegCertNoFull=$p(CertStr,"^",4)
	.s Marginnow=""
	.s:+Rp'=0 Marginnow=Sp/Rp,Marginnow=$fn(Marginnow,"",3)
	.s PhcdCode=""
	.s Phcdf=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPhcdf(InciId)
	.s:+Phcdf'=0 PhcdCode=$p(^PHCD(+Phcdf,1),"^",2)
	.s InciDateStr=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetInciCreateDate(InciId)
	.s InciCreateDate=$p(InciDateStr,"^",1)
	.s:InciCreateDate'="" InciCreateDate=..DL2H(InciCreateDate)
	.s InciCreateTime=$p(InciDateStr,"^",2)
	.s:InciCreateTime'="" InciCreateTime=..TL2H(InciCreateTime)
	.s InciUpdateDate=$p(InciDateStr,"^",3)
	.s:InciUpdateDate'="" InciUpdateDate=..DL2H(InciUpdateDate)
	.s InciUpdateTime=$p(InciDateStr,"^",4)
	.s:InciUpdateTime'="" InciUpdateTime=..TL2H(InciUpdateTime)
	.s BarCode=$p(^INCI(InciId,3),"^",9)
	.i ManfId'="" d
	..s insProLicInfo=##class(web.DHCSTMHUI.DHCCertDetail).GetCertDetailInfo("Manf",ManfId,"insProLic")
	..s insProLicText=$p(insProLicInfo,"^",1)
	..s firstProdLicInfo=##class(web.DHCSTMHUI.DHCCertDetail).GetCertDetailInfo("Manf",ManfId,"firstProdLic")
	..s firstProdLicText=$p(firstProdLicInfo,"^",1)
	.i VendorId'="" d
	..s insBusLicInfo=##class(web.DHCSTMHUI.DHCCertDetail).GetCertDetailInfo("Vendor",VendorId,"insBusLic")
	..s insBusLicText=$p(insBusLicInfo,"^",1)
	..s secondBusLicInfo=##class(web.DHCSTMHUI.DHCCertDetail).GetCertDetailInfo("Vendor",VendorId,"secondBusLic")
	..s secondBusLicText=$p(secondBusLicInfo,"^",1)
	.s Data=$lb(InciId,InciCode,InciDesc,Spec,Manf,PurUomDesc,Sp,Rp,BUomDesc,BillUomDesc,StkCatDesc,NotUseFlag,VendorId,VendorName,RegisterNo,RegisterNoExpDate,Brand,Marginnow,bRp,HighPrice,Charge,Implantation,Model,Remarks,PhcdCode,Supervision,InciCreateDate,InciCreateTime,InciUpdateDate,InciUpdateTime,ArcId,Origin,RegCertDateOfIssue,RegItmDesc,RegCertNoFull,MaxSp,CreateUser,BarCode,insProLicText,firstProdLicText,insBusLicText,secondBusLicText)   
	.s ^CacheTemp(repid,ind)=Data
	.s ind=ind+1
	.q
}

/// Descript:	查询三大项信息
/// Creator:	XuChao
/// Date: 		2018-12-14
/// Table:		INC_Itm,DHC_IncItmAddionInfo
/// Input:		InciId
/// Output:		临时global ^TMPITMINFO(pid,"ITM",inci)=""   
ClassMethod GetItmByRowId(InciIdStr As %String) As %Library.String [ Private ]
{
	n (InciIdStr)
	q:InciIdStr="" ""
	s StrLen=$l(InciIdStr,",")
	q:StrLen<=0 ""
	s pid=..NewPid()
	k ^TMPITMINFO(pid)
	f i=1:1:StrLen d
	.s InciId=$p(InciIdStr,",",i)
	.q:'$d(^INCI(InciId,1))||'$d(^INCI(InciId,2))||'$d(^INCI(InciId,3))
	.s Incsc=$p(^INCI(InciId,2),"^",2)
	.q:Incsc=""
	.s StkType=$p($G(^INC("SC",Incsc)),"^",3)
	.q:StkType'=..sssCode()
	.s ^TMPITMINFO(pid,"ITM",InciId)=""
	q pid_"^"_1
}

/// Descript:   查询三大项信息
/// Creator:    XuChao
/// Date: 		2018-12-14
/// Table:		INC_Itm,DHC_IncItmAddionInfo,Arc_ItmMast,PHC_DrgMast,PHC_DrgForm
/// Input:      StrParam(InciCode^InciDesc^Alias^StkCatId), 类组串
/// Output:     临时global ^TMPITMINFO(pid,"ITM",inci)=""
ClassMethod GetItmByDesc(StrParam As %String, CatGrpStr As %String = "") As %Library.String
{
	n (StrParam,CatGrpStr)
	s InciCode=$p(StrParam,"^",1)
	s InciDesc=$p(StrParam,"^",2)
	s Alias=$p(StrParam,"^",3)
	s StkCatId=$p(StrParam,"^",4)
	s InciDesc=$$ALPHAUP^SSUTIL4(InciDesc)
	q:InciDesc="" ""
	s pid=..NewPid()
	k ^TMPITMINFO(pid)

	s num=0
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select INCI_RowId,INCI_Code,INCI_Desc from INC_Itm  where 1=1"
	s:StkCatId'="" sqlStr=sqlStr_"and inci_incsc_dr ="_StkCatId
	d result.Prepare(sqlStr)
	s sc=result.Execute()
	s err=$$$ISERR(sc) i err q ""
	While(result.Next())
	{
		s Code=result.Data("INCI_Code")
		s desc=result.Data("INCI_Desc")
		s SAlias=##class(web.DHCSTMHUI.Common.AppCommon).GetCNCODE(desc)
		continue:($$ALPHAUP^SSUTIL4(Code)'[InciDesc)&&($$ALPHAUP^SSUTIL4(desc)'[InciDesc)&&($$ALPHAUP^SSUTIL4(SAlias)'[InciDesc)
		s InciId = result.Data("INCI_RowId")
		continue:'$d(^INCI(InciId,1))||'$d(^INCI(InciId,2))||'$d(^INCI(InciId,3))
		s Incsc=$p(^INCI(InciId,2),"^",2)
		continue:Incsc=""
		continue:(StkCatId'="")&&(Incsc'=StkCatId)		;库存分类过滤
		s StkType=$p($G(^INC("SC",Incsc)),"^",3)
		continue:StkType'=..sssCode()
		i Alias'="" d
		.s AliasRet=##class(web.DHCSTMHUI.INCALIAS).CheckAlias(InciId,Alias)
		continue:(Alias'="")&&(+AliasRet'=1)			;别名过滤
		continue:'..IsInCatGrpStr(InciId,$G(CatGrpStr))	;类组权限过滤
		s num=num+1
		s ^TMPITMINFO(pid,"ITM",InciId)=""
	}
	q pid_"^"_num
}

/// Descript:	查询三大项信息
/// Creator:	XuChao
/// Date: 		2018-12-14
/// Table:		INC_Itm,DHC_IncItmAddionInfo,Arc_ItmMast,PHC_DrgMast,PHC_DrgForm
/// Input:		StrParam(InciCode^InciDesc^Alias^StkCatId), 类组串
/// Output:		临时global ^TMPITMINFO(pid,"ITM",inci)=""   
ClassMethod GetItmByCode(StrParam As %String, CatGrpStr As %String) As %Library.String [ Private ]
{
	n (StrParam,CatGrpStr)
	s InciCode=$p(StrParam,"^",1)
	s InciDesc=$p(StrParam,"^",2)
	s Alias=$p(StrParam,"^",3)
	s StkCatId=$p(StrParam,"^",4)
	q:InciCode="" ""
	s pid=..NewPid()
	k ^TMPITMINFO(pid)

	s num=0
	s StrSql="select INCI_RowId from inc_itm where inci_code like '%"_InciCode_"%'"
	s result = ##class(%Library.ResultSet).%New()
	d result.Prepare(StrSql)
	s sc=result.Execute()
	s err=$$$ISERR(sc)
	If err  q ""
	While(result.Next())
	{
		s InciId=result.Data("INCI_RowId")
		continue:InciId=""
		continue:'$d(^INCI(InciId,1))||'$d(^INCI(InciId,2))||'$d(^INCI(InciId,3))

		s Incsc=$p(^INCI(InciId,2),"^",2)
		continue:Incsc=""
		continue:(StkCatId'="")&&(Incsc'=StkCatId)
		s StkType=$p($G(^INC("SC",Incsc)),"^",3)
		continue:StkType'=..sssCode()
		continue:'..IsInCatGrpStr(InciId,$G(CatGrpStr))	;类组权限过滤

		i Alias'="" d
		.s AliasRet=##class(web.DHCSTMHUI.INCALIAS).CheckAlias(InciId,Alias)
		continue:(Alias'="")&&(+AliasRet'=1)			;别名过滤
		s num=num+1
		s ^TMPITMINFO(pid,"ITM",InciId)=""
	}

	q pid_"^"_num
}

/// Descript:	查询三大项信息
/// Creator:	XuChao
/// Date: 		2018-12-14
/// Table:		INC_Itm,DHC_IncItmAddionInfo,Arc_ItmMast,PHC_DrgMast,PHC_DrgForm
/// Input:		StrParam(InciCode^InciDesc^Alias^StkCatId), 类组串
/// Output:		临时global ^TMPITMINFO(pid,"ITM",inci)=""    
ClassMethod GetItmByAlias(StrParam As %String, CatGrpStr As %String) As %Library.String [ Private ]
{
	n (StrParam,CatGrpStr)
	s InciCode=$p(StrParam,"^",1)
	s InciDesc=$p(StrParam,"^",2)
	s Alias=$p(StrParam,"^",3)
	s StkCatId=$p(StrParam,"^",4)
	s Alias=$$ALPHAUP^SSUTIL4(Alias)
	q:Alias="" ""
	
	s pid=..NewPid()
	k ^TMPITMINFO(pid)  
	s num=0
	
	s Alias="%"_Alias_"%"
	&sql( declare xx1 cursor for select distinct inca_inci_dr From inc_alias 
		where %ALPHAUP(inca_text) like :Alias)
	&sql(open xx1)
	f  &sql(fetch xx1 into :InciId) q:SQLCODE  d
	.q:'$d(^INCI(InciId,1))||'$d(^INCI(InciId,2))||'$d(^INCI(InciId,3))
	.s Incsc=$p(^INCI(InciId,2),"^",2)
	.q:Incsc=""
	.q:(StkCatId'="")&&(Incsc'=StkCatId)		;库存分类过滤
	.s StkType=$p($G(^INC("SC",Incsc)),"^",3)
	.q:StkType'=..sssCode()
	.q:'..IsInCatGrpStr(+InciId,$G(CatGrpStr))	;类组权限过滤
	.s num=num+1
	.s ^TMPITMINFO(pid,"ITM",InciId)=""
	
	q pid_"^"_num
}

/// Descript:	查询三大项信息
/// Creator:	XuChao
/// Date: 		2018-12-14
/// Table:		INC_Itm,DHC_IncItmAddionInfo,Arc_ItmMast,PHC_DrgMast,PHC_DrgForm
/// Input:		StrParam(InciCode^InciDesc^Alias^StkCatId)
/// Output:		临时global ^TMPITMINFO(pid,"ITM",inci)=""   
ClassMethod GetItmByStkCat(StrParam As %String) As %Library.String [ Private ]
{
	n (StrParam)
	s InciCode=$p(StrParam,"^",1)
	s InciDesc=$p(StrParam,"^",2)
	s Alias=$p(StrParam,"^",3)
	s StkCatId=$p(StrParam,"^",4)
	q:StkCatId="" ""
	s pid=..NewPid()
	k ^TMPITMINFO(pid)

	s num=0
	s InciId=0
	f  s InciId=$o(^INCI(0,"StkCat",StkCatId,InciId)) q:InciId=""  d
	.s TmpGrpInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(InciId)
	.s TmpGrpType=$p(TmpGrpInfo,"^",3)
	.q:TmpGrpType'=..sssCode()
	.s num=num+1
	.s ^TMPITMINFO(pid,"ITM",InciId)=""

	q pid_"^"_num
}

/// Descript:	查询三大项信息
/// Creator:	XuChao
/// Date: 		2018-12-14
/// Table:		INC_Itm,DHC_IncItmAddionInfo,Arc_ItmMast,PHC_DrgMast,PHC_DrgForm
/// Input:		类组串(^隔开)
/// Output:		临时global ^TMPITMINFO(pid,"ITM",inci)=""  
ClassMethod GetAllItm(CatGrpStr As %String) As %Library.String [ Private ]
{
	n (CatGrpStr)
	s pid=..NewPid()
	k ^TMPITMINFO(pid)
	s num=0

	s Code1=""
	f  s Code1=$o(^INCI(0,"Code1",Code1)) q:Code1=""  d
	.s InciId=0
	.f  s InciId=$o(^INCI(0,"Code1",Code1,InciId)) q:InciId=""  d
	..q:'$d(^INCI(InciId,1))||'$d(^INCI(InciId,2))||'$d(^INCI(InciId,3))
	..
	..q:'..IsInCatGrpStr(InciId,$G(CatGrpStr))		//类组权限过滤
	..s TmpGrpInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(InciId)
	..s TmpGrpType=$p(TmpGrpInfo,"^",3)
	..q:TmpGrpType'=..sssCode()
	..
	..s ^TMPITMINFO(pid,"ITM",InciId)=""

	q pid_"^"_num
}

/// Descript:   保存/更新三大项信息
/// Creater:    ZhangDongmei
/// CreateDate: 2011-12-27
/// Table:PHC_DrgMast,PHC_DrgForm
/// Arc_ItmMast,Inc_Itm,DHC_ItmAddionInfo
/// Input:库存项rowid
/// 
/// 医嘱项数据串:代码^描述^账单单位id^医嘱子类id^费用大类id^费用子类id^独立医嘱标志
/// ^默认医嘱优先级id^无库存医嘱标志^医保名称^别名^缩写
/// ^医保类别^最大量^限制使用天数^每天最大剂量^单次最大剂量^急诊用药^住院用药^门诊用药
/// ^体检用药^医嘱提示^是否维护收费项目标志^是否维护医保项目^收费子分类^住院子分类^门诊子分类
/// ^核算子分类^病历首页子分类^会计子分类^生效日期^截止日期^医嘱大类
/// 
/// 库存项数据串:代码^描述^基本单位id^入库单位id^库存分类id^转移方式
/// ^是否要求批次^是否要求效期^别名^不可用标志^协和码^条码^更新人^售价^进价
/// ^价格生效日期^规格^进口标志^质量层次
/// ^质量编号^国/省别^批准文号^高值类标志^定价类型id
/// ^最高售价^存储条件^本院药品目录^招标标志^招标进价^招标级别^招标供应商id^招标生产商id
/// ^招标配送商id^招标名称^阳光采购标志^效期长度^物价文件号^物价文件备案时间^帐簿分类id
/// w ##class(web.DHCSTMHUI.DrugInfoMaintain).SaveData(^templxt(1),^templxt(2),^templxt(3))
ClassMethod SaveData(ArcData, IncData, SearchData = "") As %Library.String
{
    n (ArcData,IncData,SearchData,%session)
	s $ZT=..sssError()
	d ..sssSetLogID()
	s RtnObj=##class(RtnObj).%New()
	s InciObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=InciObj.%FromJSON(IncData)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","库存项入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	s User=InciObj.%Get("gUserId")
	s Group=InciObj.%Get("gGroupId")
	s Loc=InciObj.%Get("gLocId")
	s Hosp=InciObj.%Get("gHospId")
	s Params=Group_"^"_Loc_"^"_User_"^"_Hosp
	s IncRowid=InciObj.%Get("Inci")
	s HospId=""
	i SearchData'="" d
	.s SearchObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	.s Sc1=SearchObj.%FromJSON(SearchData)
	.q:Sc1'=0
	.s HospId=SearchObj.%Get("BDPHospital")
	s Hosp=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(HospId,Hosp)
	s OldInci=IncRowid
	s OldArc=""
	i IncRowid'="" d
	.&sql(select inci_originalarcim_dr into :OldArc from inc_itm where %id=:IncRowid)
	s InciCode=InciObj.%Get("InciCode")
	s ChargeFlag=InciObj.%Get("ChargeFlag")
	s StkCat=InciObj.%Get("StkCat")
	s StkGrp=InciObj.%Get("StkGrp") ;类组id
	s Rp=+InciObj.%Get("RpPUom")
	s Sp=+InciObj.%Get("SpPUom")
	s PreExeDate=InciObj.%Get("PreExeDate")
	s AspStatus=InciObj.%Get("AspStatus")
	s Asp=InciObj.%Get("Asp")
	s PrcFile=InciObj.%Get("PrcFile")						;物价文件号
	s PrcFileDate=InciObj.%Get("PrcDate")					;物价文件备案时间
	s NIRowId=InciObj.%Get("NIRowId")

	s ArcObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=ArcObj.%FromJSON(ArcData)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","医嘱项入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	s ArcRowid=ArcObj.%Get("Arc")
	s ArcCode=ArcObj.%Get("ArcCode")
	s ArcSp=ArcObj.%Get("ArcSp")
	s ArcPreExeDate=ArcObj.%Get("ArcPreExeDate")
	s TarItm=""
	s:IncRowid'="" ArcRowid=$p(^INCI(IncRowid,1),"^",3)
	s:ArcRowid'="" TarItm=$o(^DHCOLT(0,"ARCIM",ArcRowid,""))	//收费项
	s AppName=##class(web.DHCSTMHUI.DrugInfoMaintain).%GetParameter("AppName")
	s AutoCreateIncCode=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"AutoCreateIncCode",Params)
	s SameCode=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"SameCode",Params)
	s NewLinkFlag=$s((IncRowid'="")&&((ArcRowid="")!(TarItm="")):"Y",1:"N")	;有库存项之后,再次维护信息和医嘱项关联的标记
	s OldPUom=""
	s:IncRowid'="" OldPUom=$p(^INCI(IncRowid,3),"^",6)
	s OldAspInfo=##class(web.DHCSTMHUI.INCITM).GetINCPrice(IncRowid,+$h,OldPUom,"")
	s OldRp=$p(OldAspInfo,"^",1)
	s OldSp=$p(OldAspInfo,"^",2)
	;新增修改审核处理
	s AddAuditFlag=$p(..IFMatAudit(),"^",1)
	s UpAuditFlag=$p(..IFMatAudit(),"^",2)
	s IfAuditOver="N"
	i ((AddAuditFlag="Y")||(UpAuditFlag="Y"))&&(IncRowid'="") d
	.s IfAuditOver=##class(web.DHCSTMHUI.MatAudit).IfAuditOver(IncRowid)
	i IfAuditOver="Y"  d RtnObj.Err(-3,"","存在待审核记录!","",0)  q RtnObj.Json()
	tstart
	// 增加  修改 审核记录
	s BIncid=IncRowid,logMainid=""
	i (((AddAuditFlag="Y")&&(BIncid=""))||((UpAuditFlag="Y")&&(BIncid'=""))) d
	.s Ret=##class(web.DHCSTMHUI.MatAudit).AddLogMain(User,BIncid,IncData)
	.i +Ret>0 s logMainid=Ret
	.i +Ret<0 d RtnObj.Err(-4,"","插入修改主日志失败!")
	.q:RtnObj.success'=0
	.;修改前
	.i ((UpAuditFlag="Y")&&(BIncid'="")&&(+logMainid>0)) d
	..s Ret=##class(web.DHCSTMHUI.MatAudit).AddMatLog(logMainid,BIncid,IncData)
	..i +Ret<0 d RtnObj.Err(-4,"","插入修改日志失败!")
	i RtnObj.success'=0 trollback  q RtnObj.Json()
	;保存医嘱项
	i (IncRowid="")&&(InciCode="")&&(AutoCreateIncCode="Y")  d   //新录入库存项目时//根据设置决定自动生成代码 
	.s InciCode=..NewCode(StkCat)  //自动生成代码(当没有录入时)
	i (ArcRowid="")&&(SameCode="Y")&&(ArcCode="") d  // 根据设置决定是否使用库存项代码（新增加项目时）
	.s ArcCode=InciCode 

	i ChargeFlag="Y" d
	.i ArcData'="" d
	..s RtnObj=##class(web.DHCSTMHUI.ARCITMMAST).Save(.ArcRowid,ArcData,ArcCode,Hosp)
	i RtnObj.success'=0 trollback  q RtnObj.Json()
	;保存库存项
	s RtnObj=##class(web.DHCSTMHUI.INCITM).Save(.IncRowid,IncData,ArcRowid,InciCode,Hosp)
	i RtnObj.success'=0 trollback  q RtnObj.Json()
	s RtnObj=..CreateInaspFrArcim(IncRowid,Rp,Sp,OldRp,OldSp,PreExeDate,User,Loc,Hosp)
	i RtnObj.success'=0  trollback  q RtnObj.Json()
	i (IncRowid'="")&&(ArcRowid'="") d
	.s TarPriceFlag=..GetTarPriceFlag(IncRowid)		;2017-07-04 没有计费项价格的，补充处理
	.i TarPriceFlag="Y" d
	..;这里调整收费项价格
	..s Ret=..AdjTarPrice(IncRowid,User)
	..i Ret<0 d RtnObj.Err(-2,"","调整收费项价格失败!")
	i RtnObj.success'=0 trollback  q RtnObj.Json()

	
	;新增或者修改后
	i ((((AddAuditFlag="Y")&&(IncRowid'=""))||(UpAuditFlag="Y")))&&(+logMainid>0) d
	.i (AddAuditFlag="Y")&&(IncRowid'="")&&(BIncid="") d
	..s Ret=##class(web.DHCSTMHUI.MatAudit).AddMatLog(logMainid,"^"_IncRowid)
	..i +Ret=0 s $p(^INCI(IncRowid,2),"^",9)="Y"
	.i ((UpAuditFlag="Y")&&(BIncid'="")) d
	..s Ret=##class(web.DHCSTMHUI.MatAudit).AddMatLog(logMainid,BIncid_"^"_IncRowid)
	..i +Ret=0 s $p(^INCI(IncRowid,2),"^",9)="Y"
	..i +Ret<0 d RtnObj.Err(-5,"","插入新增修改后日志失败!")
	i RtnObj.success'=0  trollback   q RtnObj.Json()
	
	tcommit
	d ..sssKillLogID()
	
	//同步库存项信息到供应链平台(SCI,ECS,Lis等)
	i (AddAuditFlag'="Y")&&(UpAuditFlag'="Y") d
	.d ##class(web.DHCSTMHUI.ServiceForSCI).getHopInc(IncRowid)
	.d ##class(web.DHCSTMHUI.ServiceForECS).updateHosInv(IncRowid,Hosp)
	.d ##class(web.DHCSTMHUI.ServiceForLis).SynInciInfo(IncRowid,Hosp)
	
	i NIRowId'="" d
	.d ##class(web.DHCSTMHUI.ServiceForECS).supProSpecAudit(IncRowid,Hosp)
	
	s RtnObj.rowid=IncRowid
	q RtnObj.Json()
}

/// Descript:	调整计费项价格
/// Creator:	wangjiabin
/// CreateDate:	2015-11-16
/// Input:		库存项id, 维护物资信息的人员id
/// Return：
ClassMethod AdjTarPrice(inci As %String, UpdateUserId As %String) As %String [ Private ]
{
	n (%session,inci,UpdateUserId)

	i $d(%session) d
	.s defaultDept=$Get(%session.Data("LOGON.CTLOCID"))
	e  d
	.s defaultDept=$p(^SSU("SSUSR",UpdateUserId),"^",4)
	s HospId=$p(^CTLOC(defaultDept),"^",22)
	s ifexitbatadjpricestr=##class(web.DHCSTMHUI.Common.PriceCommon).IfExitBatAdjprice(inci)
	s ifexitbatadjprice=$p(ifexitbatadjpricestr,"^",1)
	s batflag=$p(ifexitbatadjpricestr,"^",2)
	;基本单位售价
	if ((ifexitbatadjprice'="Y")&&(batflag=1))  d
	.s resultsp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElseOld(inci,+$h,"",HospId)
	e  d
	.s resultsp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(inci,+$h,"",HospId)
	s TarId=$$ChkTar(inci)
	i (TarId'="") d
	.s AdjRow=""		;这里暂不记录
	.s exedate=+$h
	.s err=$$AdjINCIPrice^DHCSTMHUITARPRICE(inci,exedate,resultsp,UpdateUserId,AdjRow,"",HospId)
	q 0

ChkTar(inci)
	n (inci)
	q:inci="" ""
	q:'$d(^INCI(inci,1)) ""
	s arcim=$p(^INCI(inci,1),"^",3)
	q:arcim="" ""
	s tar=$o(^DHCOLT(0,"ARCIM",arcim,""))
	q tar
}

/// Descript:	是否需要维护计费项价格
/// 			(根据计费项价格对应global是否存在)
/// Creator:	wangjiabin
/// CreateDate:	2017-07-04
/// Input:		库存项id
/// Return:		Y:需维护计费项价格, N:无
/// w ##class(web.DHCSTMHUI.DrugInfoMaintain).GetTarPriceFlag(2830)
ClassMethod GetTarPriceFlag(inci) As %String
{
	n (inci)
	s Ret="N"
	q:inci="" Ret
	q:'$d(^INCI(inci,1)) Ret
	s arcim=$p(^INCI(inci,1),"^",3)
	q:arcim="" Ret
	s tar=$o(^DHCOLT(0,"ARTTA",arcim,""))
	q:tar="" Ret
	
	i '$d(^DHCTARI(tar,"P")) s Ret="Y"
	q Ret
}

/// Descript:   查询三大项明细信息
/// Creater:    XuChao
/// CreateDate: 2018-07-27
/// Input:库存项id
/// Output:库存项：医嘱项rowid^代码^描述^基本单位id^基本单位^入库单位id^入库单位^库存分类id^库存分类^
/// 转移方式^是否要求批次^是否要求效期^别名^不可用标志^协和码^条码^更新人id^更新人^售价^进价^
/// 进口标志^质量层次^处方药分类^基本药物标志^中国药典标志^临床验证用药标志
/// ^处方购药标志^质量编号^国/省别^批准文号^高值类标志^院长签字^定价类型id^定价类型^最高售价^存储条件
/// ^本院药品目录^招标标志^招标进价^招标级别^招标供应商id^招标生产商id^招标配送商id^招标名称^
/// ^阳光采购标志^效期长度^物价文件号^物价文件备案时间^皮试标志^帐簿分类id^帐簿分类^用药说明^基本药物标志2
/// ^省增补药物标志1^省增补药物标志2^药品本位码^进药依据^规格
/// 
/// 医嘱项：药学项子表id^代码^描述^账单单位id^医嘱子类id^医嘱子类^费用大类^费用子类id^
/// 费用子类^独立医嘱标志^默认医嘱优先级id^默认医嘱优先级^无库存医嘱标志^医保名称^缩写
/// ^最大量^限制使用天数^每天最大剂量^单次最大剂量^急诊用药^住院用药^门诊用药
/// ^体检用药^医嘱提示^生效日期^截止日期^医嘱大类描述^医嘱大类id
/// w ##class(web.DHCSTMHUI.DrugInfoMaintain).GetDetail(832,"")
ClassMethod GetDetail(InciId, HospId) As %Library.String
{
	n (InciId,HospId)
	s RtnObj=##class(RtnObj).%New()
	s IncData=##class(web.DHCSTMHUI.INCITM).Select(InciId,HospId,.RtnObj)
	i RtnObj.success'=0 q RtnObj.Json()
	s ArcimId=$p(^INCI(InciId,1),"^",3)
	s ArcData="{}"
	i ArcimId'="" d
	.s ArcData=##class(web.DHCSTMHUI.ARCITMMAST).Select(ArcimId,.RtnObj)
	i RtnObj.success'=0 q RtnObj.Json()
	q "{"_$c(34)_"success"_$c(34)_":"_$c(34)_0_$c(34)_","_$c(34)_"InciData"_$c(34)_":"_IncData_","_$c(34)_"ArcimData"_$c(34)_":"_ArcData_"}"
}

/// Descript:   删除三大项信息
/// Creater:    ZhangDongmei
/// CreateDate: 2011-12-28
/// Table:
/// Arc_ItmMast,Inc_Itm,DHC_ItmAddionInfo
/// Input:库存项rowid
/// Output:     
/// Return：0：成功;错误代码
/// -2  ;删除库存项失败
/// -3  ;删除库存项附加信息失败
/// -4  ;删除库存项别名失败
/// -5  ;删除调价记录失败
/// -81   ;删除医嘱项主表失败
/// -82   ;删除医嘱项附加表失败
/// -83  ;删除医嘱项别名失败
ClassMethod Delete(InciRowid) As %Library.String
{
	n (InciRowid)
	q:InciRowid="" -1
	q:'$d(^INCI(InciRowid)) -1
	s UseFlag=##class(web.DHCSTMHUI.INCITM).CheckUsed(InciRowid)   
	q:UseFlag=1 -11  ;药品已在使用，不能删除
	s Err=0
	s ArcimRowid=$p(^INCI(InciRowid,1),"^",3)
	i ArcimRowid'=""  d
	.s Sub=+ArcimRowid
	.s Ver=$p(ArcimRowid,"||",2)
	tstart
	s $ZT=..sssError()                        ;增加错误处理
	;删除库存项
	s Ret=##class(web.DHCSTMHUI.INCITM).Delete(InciRowid)
	i Ret'=0  trollback
	q:Ret'=0 Ret
	
	;删除医嘱项  
	s Ret=##class(web.DHCSTMHUI.ARCITMMAST).Delete(ArcimRowid)
	i Ret'=0  trollback
	q:Ret'=0 Ret
	tcommit
	q 0
}

/// 看某个品种的类组是否包含在列表中
/// Author:zhwh
/// Date:2013-07-15
/// Arguments:
///  inci  -库存项rowid
///  CatGrpStr - 类组rowid串("^"分隔)
/// Return:
///  1 - 包含
///  0 - 不包含
ClassMethod IsInCatGrpStr(inci As %String, CatGrpStr As %String) As %String
{
	n (inci,CatGrpStr)
	q:inci="" 0
	q:CatGrpStr="" 0
	s incsc=$p($G(^INCI(inci,2)),"^",2)
	q:incsc="" 0

	s catgrp=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetParSCG(incsc)
	i ("^"_CatGrpStr_"^")[("^"_catgrp_"^") q 1
	q 0
}

/// Descript: 查询物资图片信息
/// Creater:  XuChao
/// CreateDate: 2014-03-12
/// Table: DHC_ItmDocStorage
/// Input:
/// Output:     
/// Return：w ##class(web.DHCSTMHUI.DrugInfoMaintain).GetProductImageInfo()
ClassMethod GetProductImageInfo(Inci As %String) As %String
{
	n (Inci)
	s StrSql="select DOCI_RowId rowid,DOCI_INCI_DR inci,DOCI_Name imgfilename,DOCI_Type imgtype,DOCI_FileName filename from DHC_ItmDocStorage where DOCI_INCI_DR="_Inci_" Order By DOCI_TYPE desc"
	s result = ##class(%Library.ResultSet).%New()
	d result.Prepare(StrSql)
	s sc=result.Execute()
	s err=$$$ISERR(sc)
	If err  q "{}"
	s count = 0
	s resultString = ""
	s json = ##class(web.DHCSTMHUI.Common.JsonObj).%New()
	While(result.Next())
	{
		s rowid = result.Data("rowid")
		s inci = result.Data("inci")
		s inciDesc=$p(^INCI(inci,1),"^",2)
		s picsrc=result.Data("imgfilename")
		s imgtype=..picTypeDesc(result.Data("imgtype"))
		s filename=result.Data("filename")
		s Data=rowid_"^"_inci_"^"_inciDesc_"^"_picsrc_"^"_imgtype_"^"_filename
		d json.InsertRowData(Data)
	}
	d result.Close()
	d json.getCbJsonData("RowId^Inci^InciDesc^PicSrc^ImgType^FileName")
	k json
	Q ""
}

ClassMethod picTypeDesc(tp) As %String
{
	if tp="instruct" q "说明书"
	i $zcvt(tp,"l")="productmaster" q "主图片"
	i $zcvt(tp,"l")="product" q "普通图片"

	i tp="cert" q "产品注册证"
	i tp="contract" q "采购合同"
	i tp="sterFile" q "消毒合格证"
	i tp="tradeFile" q "成交通知书"
	i tp="tradeFile" q "成交合同书"
	i tp="productDetail" q "产品详情一览表"
	i tp="priceFile" q "报价单"
	i tp="portFile" q "报关单"

	q tp
}

/// Descript:   删除供应商资质图片名称
/// Creater:    XuChao
/// CreateDate: 2014-03-12
/// Table:
/// Input:File图片流Param=GroupId_"^"_LocId_"^"_UserId  供应商rowid
/// Output:     
/// Return：地址
/// w ##class(web.DHCSTMHUI.DrugInfoMaintain).DelProductImageInfo(164,"")
ClassMethod DelProductImageInfo(docRowId As %String, Param As %String) As %Library.String
{
	n (docRowId,Param)
	s RtnObj=##class(RtnObj).%New()
	s FileName=""
	&sql(SELECT DOCI_NAME into :FileName FROM DHC_ItmDocStorage WHERE DOCI_RowId=:docRowId)
	ts
	&sql(delete from DHC_ItmDocStorage where DOCI_RowId=:docRowId)
	b
	i SQLCODE'=0 d
	.d RtnObj.Err(-1,"","删除失败!") q
	e  d
	.s result = ##class(web.DHCSTMHUI.Common.FtpFile).DeleFile(FileName,Param)
	.b
	.i result'=0 d
	..d RtnObj.Err(-1,"","删除FTP文件失败!") q
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// Descript:   插入图片
/// Creater:    XuChao
/// CreateDate: 2014-03-12
/// Table:
/// Input:File图片流Param=GroupId_"^"_LocId_"^"_UserId  
/// Output:     
/// Return：地址
ClassMethod SaveProductImage(File As %CSP.BinaryStream, Params As %String, FileType As %String, OrgFileName As %String) As RtnObj
{
	n (File,Params,FileType,OrgFileName,%session)
	s RtnObj=##class(RtnObj).%New()
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s Inci=PJobj.%Get("Inci")
	s Type=PJobj.%Get("PicType")
	s FileType=$p(FileType,"/",2)
	s FileType=$zcvt(FileType,"U")
	
	i OrgFileName'="" d
	.s tmpid=""
    .&sql(select %ID into :tmpid from DHC_ItmDocStorage where DOCI_FileName=:OrgFileName)
    .i tmpid'="" d RtnObj.Err(-991,"","文件名称重复","",0)
    q:RtnObj.success<0 RtnObj
	
	s Param=..sssParamStr()
	s gHospId=$p(Param,"^",4)
	s AppName=##class(web.DHCSTMHUI.Common.FtpFile).%GetParameter("AppName")  //ftp公共单号规则
	s ret=##class(web.DHCSTMHUI.Common.AppCommon).Lock("FTPFILE")
	q:ret<0 RtnObj.Err(-99,"","加锁失败!")
	s FileName=##class(web.DHCSTMHUI.Common.AppCommon).GetAppNo(AppName,"","",gHospId) //生成图片名称
	i FileType="PDF" d
	.s FileName=FileName_".PDF"
	e  d
	.s FileName=FileName_".JPG"
	
	i FileName="" d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock("FTPFILE")
	q:FileName="" RtnObj.Err(-99,"","生成单号失败!")
	&sql(select DOCI_RowId into :DOCI from DHC_ItmDocStorage where DOCI_Name=:FileName and DOCI_INCI_DR=:Inci)
	i SQLCODE'=0 d
	.s result = ##class(web.DHCSTMHUI.Common.FtpFile).UpFile(File,Param,FileName)
	.i result'=0  d RtnObj.Err(-99,"","ftp服务上传失败")
	.q:RtnObj.success'=0
	.i Type="" s Type="product"  //默认为"普通图片"
	.&sql(insert into DHC_ItmDocStorage (DOCI_INCI_DR,DOCI_Name,DOCI_Type,DOCI_FileName)values(:Inci,:FileName,:Type,:OrgFileName) )
	.i SQLCODE'=0 d
	..d RtnObj.Err(-1,"","上传失败!")
	e  d
	.d RtnObj.Err(-1,"","重复上传!","",0)
	q RtnObj
}

/// 设置某产品图片的类型为主图片
/// Author:zhwh
/// Date:2014-12-31
/// Arguments :
///  rowid  - RowId of DHC_ItmDocStorage
/// Return:
///  0 - Success
///  <0 - Fail
/// 
ClassMethod SetProductMaster(rowid As %String) As %String
{
	n (rowid)
	s RtnObj=##class(RtnObj).%New()
	s mtype="productmaster"
	s type="product"
	&Sql(select doci_inci_dr into :inci from DHC_ItmDocStorage where DOCI_RowId=:rowid )
	i SQLCODE'=0 d RtnObj.Err(-2,"","查询库存项失败!")
	q:RtnObj.success'=0 RtnObj.Json() 
	tstart
	//全部设置为非主图片
	&sql(update DHC_ItmDocStorage set DOCI_Type=:type WHERE DOCI_INCI_DR=:inci and DOCI_Type like 'product%')
	i SQLCODE'=0 d  tro  d RtnObj.Err(-2,"","全部设置为非主图片失败!")
	q:RtnObj.success'=0 RtnObj.Json() 
	//设置为主图片
	&sql(update DHC_ItmDocStorage set DOCI_Type=:mtype WHERE DOCI_RowId=:rowid)
	i SQLCODE'=0 d  tro  d RtnObj.Err(-2,"","设置为主图片失败!")
	q:RtnObj.success'=0 RtnObj.Json() 
	tcommit
	q RtnObj.Json()
}

/// Descript:   获取主图片名称及其他物资信息
/// up: 2015-05-19
/// Creator:    wangjiabin
/// CreateDate: 2015-03-10
/// Table:      DHC_ItmDocStorage
/// Input:      库存项rowid
/// Output:     图片名称
/// ps: components.js中调用
ClassMethod GetProductMaster(inci As %String) As %Library.String
{
	n (inci)
	s PicType="productmaster"
	s InciInfo=""
	s PicName=""
	&sql(select DOCI_NAME into :PicName from DHC_ItmDocStorage where DOCI_INCI_DR=:inci and DOCI_Type=:PicType)
	i (inci'="")&&($d(^INCI(inci))) d
	.s Code=$p(^INCI(inci,1),"^",1)
	.s Desc=$p(^INCI(inci,1),"^",2)
	.s InciInfo="物资代码:"_Code_"<br/>物资名称:"_Desc
	q PicName_"^"_InciInfo
}

/// 插入物资图片
/// zhwh,2015-04-02
/// 
ClassMethod InsItmPic(inci, FileName, type) As %String
{
	&sql(insert into DHC_ItmDocStorage (DOCI_INCI_DR,DOCI_Name,DOCI_Type)values(:inci,:FileName,:type) )
	q:SQLCODE'=0 -1
	q 0
}

/// 获取进价
ClassMethod Rp(InciId, PurUomId, sHospID, defaRp) As %String
{
	n (InciId,PurUomId,sHospID,defaRp)
	s Rp=0
	i defaRp="" s defaRp=2 //未设置或为空时采用2(当前进价)
	i defaRp=1  d   ;取最后一次入库进价
	.s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetInciLRp(InciId,PurUomId,sHospID)     
	i defaRp=2 d    d  ;取调价表进价
	.s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetInciBasicRp(InciId,+$h,PurUomId,sHospID)
	i defaRp=3 d   ;取招标进价
	.s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPbRp(InciId,PurUomId,sHospID)
	
	q Rp
}

ClassMethod createCode2(chargeflag As %String) As %String
{
	n (chargeflag)
	i chargeflag="Y" d
	.s ret=$i(^DHCSTMCODE("DHCSTM","CL"))
	.s prefix="CL"
	e  d
	.s ret=$i(^DHCSTMCODE("DHCSTM","WL"))
	.s prefix="WL"

	s ret=$tr($j(ret,6)," ","0")
	s ret=prefix_ret
	q ret
}

/// 根据配置取界面数据
/// w ##class(web.DHCSTMHUI.DrugInfoMaintain).MapArc(2)
ClassMethod MapArc(StkCatId As %String)
{
	n (StkCatId)
	s MPRowId=$o(^DHCMapScArcic(0,"SC",StkCatId,""))
	q:MPRowId="" "{}"
	
	s (BillCat,BillSubCat,OwnFlag,Priority,WoStock,OrdCat,ArcSubCat,TarSubCat,TarInpatCat,TarOutpatCat,TarEMCCat,TarAcctCat,TarMRCat,TarNewMRCat,EffDate,OwnFlag)=""
	s (ArcSubCatId,BillSubCatId,TarSubCatDR,TarInpatDR,TarAcctDR,TarMRDR,TarEMCDR,TarOutDR,TarNMRDR,EffDateFlag,PriorId,OwnFlag,BillCatId,OrdCatId)=""
	s (ArcSubCatDesc,OrdCatDesc,BillSubCatDesc,BillCatDesc,EffDate,TarSubCatDesc,TarAcctDesc,TarMRDesc,TarInpatDesc,TarOutDesc,TarEMCDesc,TarNMRDesc,PriorDesc)=""

	s ArcSubCatId=$p(^DHCMapScArcic(MPRowId),"^",2)
	s BillSubCatId=$p(^DHCMapScArcic(MPRowId),"^",3)
	s TarSubCatDR=$p(^DHCMapScArcic(MPRowId),"^",4)
	s TarInpatDR=$p(^DHCMapScArcic(MPRowId),"^",5)
	s TarAcctDR=$p(^DHCMapScArcic(MPRowId),"^",6)
	s TarMRDR=$p(^DHCMapScArcic(MPRowId),"^",7)
	s TarEMCDR=$p(^DHCMapScArcic(MPRowId),"^",8)
	s TarOutDR=$p(^DHCMapScArcic(MPRowId),"^",9)
	s TarNMRDR=$p(^DHCMapScArcic(MPRowId),"^",10)
	s EffDateFlag=$p(^DHCMapScArcic(MPRowId),"^",11)
	s PriorId=$p(^DHCMapScArcic(MPRowId),"^",12)
	s OwnFlag=$p(^DHCMapScArcic(MPRowId),"^",13)
	
	s BillCatId=$p(BillSubCatId,"||",1)
	s:ArcSubCatId'="" ArcSubCatDesc=$p(^ARC("IC",ArcSubCatId),"^",2)
	s:ArcSubCatId'="" OrdCatId=$p(^ARC("IC",ArcSubCatId),"^",8)
	s OrdCatDesc=""
	s:OrdCatId'="" OrdCatDesc=$p(^OEC("ORCAT",OrdCatId),"^",2)
	s BillSubCatDesc=""
	s:BillSubCatId'="" BillSubCatDesc=$p(^ARCBG(BillCatId,"SG",$p(BillSubCatId,"||",2)),"^",2)
	s BillCatDesc=""
	s:BillSubCatId'="" BillCatDesc=$p(^ARCBG(BillCatId),"^",2)
	s WoStock="N"               ;无库存医嘱标志
	i EffDateFlag="Y" s EffDate=..DL2H(+$h)
	i TarSubCatDR'="" s TarSubCatDesc=$p(^DHCTarC("SC",TarSubCatDR),"^",2)
	i TarAcctDR'="" s TarAcctDesc=$p(^DHCTarC("AC",TarAcctDR),"^",2)
	i TarMRDR'="" s TarMRDesc=$p(^DHCTarC("MC",TarMRDR),"^",2)
	i TarInpatDR'="" s TarInpatDesc=$p(^DHCTarC("IC",TarInpatDR),"^",2)
	i TarOutDR'="" s TarOutDesc=$p(^DHCTarC("OC",TarOutDR),"^",2)
	i TarEMCDR'="" s TarEMCDesc=$p(^DHCTarC("EC",TarEMCDR),"^",2)
	i TarNMRDR'="" s TarNMRDesc=$p(^DHCTarC("MCNew",TarNMRDR),"^",2)
	s PriorDesc=""
	i PriorId'="" s PriorDesc=$p(^OECPR(PriorId),"^",2)
	
	s ArcSubCat=..sssComboStr(ArcSubCatId,ArcSubCatDesc)
	s BillCat=..sssComboStr(BillCatId,BillCatDesc)
	s BillSubCat=..sssComboStr(BillSubCatId,BillSubCatDesc)
	s Priority=..sssComboStr(PriorId,PriorDesc)
	s OrdCat=..sssComboStr(OrdCatId,OrdCatDesc)
	s TarSubCat=..sssComboStr(TarSubCatDR,TarSubCatDesc)
	s TarInpatCat=..sssComboStr(TarInpatDR,TarInpatDesc)
	s TarOutpatCat=..sssComboStr(TarOutDR,TarOutDesc)
	s TarEMCCat=..sssComboStr(TarEMCDR,TarEMCDesc)
	s TarAcctCat=..sssComboStr(TarAcctDR,TarAcctDesc)
	s TarMRCat=..sssComboStr(TarMRDR,TarMRDesc)
	s TarNewMRCat=..sssComboStr(TarNMRDR,TarNMRDesc)
	s Data=BillCat_"^"_BillSubCat_"^"_OwnFlag_"^"_Priority_"^"_WoStock_"^"_OrdCat_"^"_ArcSubCat_"^"_TarSubCat_"^"_TarInpatCat_"^"_TarOutpatCat_"^"_TarEMCCat_"^"_TarAcctCat_"^"_TarMRCat_"^"_TarNewMRCat_"^"_EffDate
	s Title="BillCat^BillSubCat^OwnFlag^Priority^WoStock^OrdCat^OrdSubCat^TarSubCat^TarInpatCat^TarOutpatCat^TarEMCCat^TarAcctCat^TarMRCat^TarNewMRCat^EffDate"
	s Rtn=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	q Rtn
}

/// Description:根据高值标志获取医嘱收费信息
/// Creator:    tsr
/// CreatDate:  2019-09-31
/// Table:      
/// Input:      
/// Return:     
/// w ##class(web.DHCSTMHUI.DrugInfoMaintain).MapArcByHv()
ClassMethod MapArcByHv(HvFlag As %String, Params As %String)
{
	n (HvFlag,Params,%session)
	q:HvFlag="" "{}"
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	q:PJObj.%FromJSON(Params)'=0 RtnObj.Err(-1,"","入参解析失败!").Json()
	s gHospId=PJObj.%Get("gHospId")
	s HospId=PJObj.%Get("Hospital")
	i HospId'="" s gHospId=HospId	//使用选择的医院ID
	
	s HMARowId=##class(web.DHCSTMHUI.MatForBDPData).CodeDescGetId("CODE",HvFlag,"DHC_HvMapArc",gHospId)
	q:HMARowId="" "{}"
	s ArcSubCatId=$p(^DHCHVMAPARC(HMARowId),"^",2)
	s BillSubCatId=$p(^DHCHVMAPARC(HMARowId),"^",3)
	s TarSubCatDR=$p(^DHCHVMAPARC(HMARowId),"^",4)
	s TarInpatDR=$p(^DHCHVMAPARC(HMARowId),"^",5)
	s TarOutDR=$p(^DHCHVMAPARC(HMARowId),"^",6)
	s TarEMCDR=$p(^DHCHVMAPARC(HMARowId),"^",7)
	s TarMRDR=$p(^DHCHVMAPARC(HMARowId),"^",8)
	s TarNMRDR=$p(^DHCHVMAPARC(HMARowId),"^",9)
	s TarAcctDR=$p(^DHCHVMAPARC(HMARowId),"^",10)
	s BillCatId=+BillSubCatId
	s (ArcSubCatDesc,OrdCatId,OrdCatDesc,BillSubCatDesc,BillCatDesc)=""
	s:ArcSubCatId'="" ArcSubCatDesc=$p(^ARC("IC",ArcSubCatId),"^",2)	
	s:ArcSubCatId'="" OrdCatId=$p(^ARC("IC",ArcSubCatId),"^",8)
	s:OrdCatId'="" OrdCatDesc=$p(^OEC("ORCAT",OrdCatId),"^",2)
	s:BillSubCatId'="" BillSubCatDesc=$p(^ARCBG(BillCatId,"SG",$p(BillSubCatId,"||",2)),"^",2)
	s:BillSubCatId'="" BillCatDesc=$p(^ARCBG(BillCatId),"^",2)
	&sql(select OECPR_RowId into :PriorId from OEC_Priority where OECPR_Desc='临时医嘱')
	s OwnFlag="N"               ;独立医嘱标志
	s WoStock="N"               ;无库存医嘱标志
	s (TarSubCatDesc,TarAcctDesc,TarMRDesc,TarInpatDesc,TarOutDesc,TarEMCDesc,TarNMRDesc)=""
	i TarSubCatDR'="" s TarSubCatDesc=$p(^DHCTarC("SC",TarSubCatDR),"^",2)
	i TarAcctDR'="" s TarAcctDesc=$p(^DHCTarC("AC",TarAcctDR),"^",2)
	i TarMRDR'="" s TarMRDesc=$p(^DHCTarC("MC",TarMRDR),"^",2)
	i TarInpatDR'="" s TarInpatDesc=$p(^DHCTarC("IC",TarInpatDR),"^",2)
	i TarOutDR'="" s TarOutDesc=$p(^DHCTarC("OC",TarOutDR),"^",2)
	i TarEMCDR'="" s TarEMCDesc=$p(^DHCTarC("EC",TarEMCDR),"^",2)
	i TarNMRDR'="" s TarNMRDesc=$p(^DHCTarC("MCNew",TarNMRDR),"^",2)

	s ArcSubCat=..sssComboStr(ArcSubCatId,ArcSubCatDesc)
	s BillCat=..sssComboStr(BillCatId,BillCatDesc)
	s BillSubCat=..sssComboStr(BillSubCatId,BillSubCatDesc)
	s Priority=""
	i PriorId'="" s Priority=..sssComboStr(PriorId,"临时医嘱")
	s OrdCat=..sssComboStr(OrdCatId,OrdCatDesc)
	s TarSubCat=..sssComboStr(TarSubCatDR,TarSubCatDesc)
	s TarInpatCat=..sssComboStr(TarInpatDR,TarInpatDesc)
	s TarOutpatCat=..sssComboStr(TarOutDR,TarOutDesc)
	s TarEMCCat=..sssComboStr(TarEMCDR,TarEMCDesc)
	s TarAcctCat=..sssComboStr(TarAcctDR,TarAcctDesc)
	s TarMRCat=..sssComboStr(TarMRDR,TarMRDesc)
	s TarNewMRCat=..sssComboStr(TarNMRDR,TarNMRDesc)
	s Data=BillCat_"^"_BillSubCat_"^"_OwnFlag_"^"_Priority_"^"_WoStock_"^"_OrdCat_"^"_ArcSubCat_"^"_TarSubCat_"^"_TarInpatCat_"^"_TarOutpatCat_"^"_TarEMCCat_"^"_TarAcctCat_"^"_TarMRCat_"^"_TarNewMRCat
	s Title="BillCat^BillSubCat^OwnFlag^Priority^WoStock^OrdCat^OrdSubCat^TarSubCat^TarInpatCat^TarOutpatCat^TarEMCCat^TarAcctCat^TarMRCat^TarNewMRCat"
	s Rtn=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	q Rtn
}

/// 更新售价(适用于对未生效的调价单数据进行修改，然后立即进行生效处理)
/// zhwh
/// 2015-12-07
/// Arguments:
///    IncRowid  -库存项目Rowid
///     ArcSp - 零售价格
///     ArcPreExeDate - 生效日期
///     user - 用户
///     AspStatus - 状态
///     Asp - 调价rowid
/// w ##class(web.DHCSTMHUI.DrugInfoMaintain).CreateInaspFrArcim("959","","959","",11,11,"","2019-11-11","","4668","392","Y")
ClassMethod CreateInaspFrArcim(IncRowid As %String, Rp As %String, Sp As %String, OldRp As %String, OldSp As %String, PreExeDate As %String, User As %String, Loc As %String, Hosp = "") As RtnObj
{
	n (IncRowid,Rp,Sp,OldRp,OldSp,PreExeDate,User,Loc,Hosp,%session)
	s RtnObj=##class(RtnObj).%New()
	s HospId=$s(Loc'="":$p($G(^CTLOC(Loc)),"^",22),1:"")
	s HospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(Hosp,HospId)
	q:IncRowid="" RtnObj.Err(-20,"","调价库存项为空!","",0)
	s PreExeDate=..DH2L(PreExeDate)
	s PurUomId=$p(^INCI(IncRowid,3),"^",6)
	s BUomId=$p(^INCI(IncRowid,1),"^",10)
	s fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PurUomId,BUomId)
	s:+PreExeDate<+$h PreExeDate=+$h
	s bSp=Sp/fac
	s bRp=Rp/fac
	s Used=##class(web.DHCSTMHUI.INCITM).CheckUsed(IncRowid) /// Return：0：未使用;1：使用
	s AspInfo=##class(web.DHCSTMHUI.INCITM).GetINCPrice(IncRowid,+$h,PurUomId,HospId)
	s Asp=$P(AspInfo,"^",5)
	s AspStatus=$P(AspInfo,"^",4)
	s ExeDate=..DH2L($P(AspInfo,"^",3))
	s AppName=##class(web.DHCSTMHUI.INAdjSalePrice).%GetParameter("AppName")
	i Asp="" d //没有调价记录
	.s WarrentInfo="^^"_PreExeDate
	.s RtnObj=##class(web.DHCSTMHUI.INAdjSalePrice).CreateAdjspFromNewitm1(IncRowid,Sp,User,PurUomId,Rp,AppName,HospId,WarrentInfo,Loc)
	e  d
	.i (Used=0)&&((OldRp'=Rp)||(OldSp'=Sp)) d
	..i (AspStatus="Yes")&&(ExeDate<+$h) d   //新建asp
	...s WarrentInfo="^^"_PreExeDate 
	...s RtnObj=##class(web.DHCSTMHUI.INAdjSalePrice).CreateAdjspFromNewitm1(IncRowid,Sp,User,PurUomId,Rp,AppName,HospId,WarrentInfo,Loc)
	..e  i (AspStatus="Yes")&&(ExeDate=+$h) d // 更新
	...&sql(update in_adjsaleprice set inasp_ctuom_dr=:PurUomId, inasp_ctuom_price=:Sp,inasp_resultsp=:bSp,
		INASP_CTUOM_Rp=:Rp,INASP_ResultRP=:bRp where inasp_rowid=:Asp)
	...i SQLCODE'=0 d RtnObj.Err(-1,"","更新调价表失败") q
	...s $p(^INASP(Asp),"^",9)="Audit"
	...s RtnObj=##class(web.DHCSTMHUI.INAdjSalePrice).Exe(Asp,"^^"_User)
	..e  i AspStatus="No" d // 更新
	...&sql(update in_adjsaleprice set inasp_ctuom_dr=:PurUomId, inasp_ctuom_price=:Sp,inasp_resultsp=:bSp,
		INASP_CTUOM_Rp=:Rp,INASP_ResultRP=:bRp,inasp_preexedate=:PreExeDate where inasp_rowid=:Asp)
	...i SQLCODE'=0 d RtnObj.Err(-1,"","更新调价表失败") q
	...s RtnObj=##class(web.DHCSTMHUI.INAdjSalePrice).Audit(Asp,User)
	..e  i AspStatus="Audit" d   // "Audit"
	...&sql(update in_adjsaleprice set inasp_ctuom_dr=:PurUomId, inasp_ctuom_price=:Sp,inasp_resultsp=:bSp,
		INASP_CTUOM_Rp=:Rp,INASP_ResultRP=:bRp,inasp_preexedate=:PreExeDate where inasp_rowid=:Asp)
	...i SQLCODE'=0 d RtnObj.Err(-1,"","更新调价表失败") q
	...i PreExeDate=+$h d
	....s RtnObj=##class(web.DHCSTMHUI.INAdjSalePrice).Exe(Asp,"^^"_User)
	q RtnObj
}

/// 获取新的物资项目代码
/// Arguments：
///    incsc -库存分类rowid
/// Return：
///   代码
ClassMethod NewCode(incsc) As %String
{
	n (incsc,%session)
	s paramStr=..sssParamStr() 
	q:incsc="" ""
	s ret=""
	s cnt=0
	s incscCode=$P($G(^INC("SC",incsc)),"^",1)
	s incscPrefix=$P($G(^INC("SC",incsc)),"^",4)
	i incscPrefix'="" d
	.s prefix=incscPrefix
	.s sxNo=$i(^dhccSTKCATGRPSXNO(prefix)) 
	e  d
	.s ret=incscCode
	.&sql(select scgr_scg_parref into :scg from dhc_stkcatgrprelations where scgr_stkcat_dr=:incsc)
	.i scg'="" d
	..s scgCode=$p($G(^DHCSCG(scg)),"^",1)
	..s ret=scgCode_ret
	..s cnt=cnt+1
	..f  s scg=$p($g(^DHCSCG(scg)),"^",4) q:(scg="")  d
	...s scgCode=$p($G(^DHCSCG(scg)),"^",1)
	...s ret=scgCode_ret
	...s cnt=cnt+1
	.s prefix=ret
	.s sxNo=$i(^INCIx("AUTOCODE",scgCode,incscCode))
	s sxNoLen=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(..%GetParameter("AppName"),"AutoCodeLengthOfSerialNo",paramStr)
	i cnt>1 s sxNoLen=sxNoLen-2
	s sxNo=$tr($j(sxNo,sxNoLen)," ","0")
	s nextInciCode=prefix_sxNo
	&sql(select INCI_RowId FROM INC_Itm WHERE INCI_Code=:nextInciCode)
	i SQLCODE=0  d
	.s nextInciCode=..NewCode(incsc)
	q nextInciCode
}

/// Descript:   判断是否启用物资审核功能
/// Creater:    lihui
/// CreateDate: 20200706
/// Input:
/// return: 新增审核标志（Y:N）^修改审核（Y:N）
/// w ##class(web.DHCSTMHUI.DrugInfoMaintain).IFMatAudit()
ClassMethod IFMatAudit()
{
	n (%session)
	s addAudFlag="N",upAudFlag="N"
	s paramStr=..sssParamStr()
	s NeedAudit=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(..%GetParameter("AppName"),"NeedAudit",paramStr)
	s addAudit=1,upAudit=2
	i (","_NeedAudit_",")[(","_addAudit_",") s addAudFlag="Y"
	i (","_NeedAudit_",")[(","_upAudit_",") s upAudFlag="Y"
	q addAudFlag_"^"_upAudFlag
}

/// Descript:   查询该库存是否有锁定的批次
/// Creater:    wangning
/// CreateDate: 20201120
/// Table:	DHC_ItmBat
/// return: N有锁定  Y无锁定
/// w ##class(web.DHCSTMHUI.DrugInfoMaintain).GetIncilLock()
ClassMethod GetIncilLock(InciId)
{
	n (InciId)
	s Ret="Y"
	s ch=""
	f  s ch=$o(^INCI(InciId,"IB",ch)) q:((ch="")||(Ret="N"))  d
	.s ReCallFlag=$p(^INCI(InciId,"IB",ch),"^",3)
	.s:ReCallFlag="Y" Ret="N"
	
	q Ret
}

/// Descript:   获取物资码打印信息
/// Creater:    lihui
/// CreateDate: 20210903
/// Table:	inc_itm
/// return: 
/// w ##class(web.DHCSTMHUI.DrugInfoMaintain).HCodeforprint(2)
ClassMethod HCodeforprint(inci, LocId = "") As %String
{
	n (inci,LocId)
	q:inci="" ""
	q:'$d(^INCI(inci)) ""
	s incidesc=$p(^INCI(inci,1),"^",2) ;物资名称
	s incicode=$p(^INCI(inci,1),"^",1) ;物资代码
	s PurUomId=$p(^INCI(inci,3),"^",6)
	s BUomId=$p(^INCI(inci,1),"^",10)
	s PurchCTUomDesc =$p(^CT("UOM",PurUomId),"^",2)
	s spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",inci) ;规格
	s Brand=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetBrand(inci) ;品牌
	s Model=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetModel(inci) ;型号
	s Manf=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPbManf(inci),"^",2) ;生产厂家
	s (MaxQty,MinQty)=0
	i LocId'="" d
	.s chl=$o(^INCI("IL_LOC",LocId,inci,""))
	.i +chl>0 d
	..s locitminfo=^INCI(inci,"IL",chl)
	..s MaxQty=$p(locitminfo,"^",7)
	..s MinQty=$p(locitminfo,"^",4) 
	s Nincidesc1=$e(incidesc,1,16)
	s Nincidesc2=$e(incidesc,17,$l(incidesc))
	s Nincidesc=Nincidesc1_$c(10)_Nincidesc2
	s Nspec1=$e(spec,1,16)
	s Nspec2=$e(spec,17,$l(spec))
	s Nspec=Nspec1_$c(10)_Nspec2
	s type="H"
	s BarcodeStr="{"_$c(34)_"code"_$c(34)_":"_$c(34)_incicode_$c(34)_","_$c(34)_"type"_$c(34)_":"_$c(34)_type_$c(34)_"}"
	s Data1=incidesc_"^"_incicode_"^"_PurchCTUomDesc_"^"_spec_"^"_Brand_"^"_BarcodeStr_"^"_Nincidesc_"^"_Nspec_"^"_Model_"^"_Manf
	s Data2=MinQty_"^"_MaxQty
	s Data=Data1_"^"_Data2
	s Title="incidesc^incicode^PurchCTUomDesc^spec^Brand^BarcodeStr^Nincidesc^Nspec^Model^Manf^MinQty^MaxQty"
	s PrintData=##class(web.DHCSTMHUI.Common.UtilCommon).GetXmlPrintData(Title,Data)
	q PrintData
}

}
