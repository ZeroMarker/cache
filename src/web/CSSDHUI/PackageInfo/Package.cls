Import sqluser

/// 消毒包信息相关类
Class web.CSSDHUI.PackageInfo.Package Extends (%RegisteredObject, %XML.Adaptor, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Creator:wfg
/// CreateDate:2019-7-31
/// Description：获取消毒包数据
/// Table:CSSD_Package
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.PackageInfo.Package","QueryPkgInfo","{""PLoc"":"""",""gUserId"":""13922"",""gLocId"":""396"",""gGroupId"":""102"",""gHospId"":""3"",""NotUse"":""Y"",""FAttributeId"":""6"",""PkgDesc"":""""}","{""BDPHospital"":""3"",""gUserId"":""13922"",""gLocId"":""396"",""gGroupId"":""102"",""gHospId"":""3""}")
Query QueryPkgInfo(Params As %String, Others As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,PkgCode,PkgDesc,PkgAlias,UomId,UomDesc,NotUseFlag,Price,PkgClassId,PkgClassDesc,WorkTimes,Length,AttributeId,AttributeDesc,LocId,LocDesc,Remark,SterTypeId,SterTypeDesc,IsExt,NotBioFlag,MaterialId,MaterialDesc,SpecId,SpecDesc,FirmId,FirmDesc,ItmQty") [ SqlProc ]
{
}

ClassMethod QueryPkgInfoExecute(ByRef qHandle As %Binary, Params As %String, Others As %String) As %Status
{
	n (qHandle,Params,Others)
	s repid=$I(^CacheTemp) 
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s OthersObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	s OtherSc=OthersObj.%FromJSON(Others)
	i ((Sc'=0)||(OtherSc'=0)) q $$$OK
	
	s PPkgDesc=PJObj.%Get("PkgDesc")
	s PNotUse=PJObj.%Get("NotUse")
	s PPkgClassId=PJObj.%Get("PkgClassId")
	s PAttributeId=PJObj.%Get("AttributeId")
	s gLocId=PJObj.%Get("gLocId")
	s PHospId=OthersObj.%Get("BDPHospital")
	s gHospId=OthersObj.%Get("gHospId")
	s PLoc=PJObj.%Get("PLoc")
	s PContainerFlag=PJObj.%Get("ContainerFlag")
	s PSterTypeId=PJObj.%Get("SterTypeId")
	s PPkgId=PJObj.%Get("PkgId")
	s PBioFlag=PJObj.%Get("BioFlag")
	s PExtFlag=PJObj.%Get("ExtFlag")
	s PPkgDesc=$$ALPHAUP^SSUTIL4(PPkgDesc)
	s PHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(PHospId,gHospId)
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr = "SELECT CSSDP_Rowid,CSSDP_IsExt,CSSDP_Code,CSSDP_Desc,CSSDP_Alias,CSSDP_UOM_DR,CSSDP_NotUseFlag,"
			_"CSSDP_PackPhoto,CSSDP_PackClassdr,CSSDP_PackClassdr->CSSDPC_PackClassName as PackClassName,"
			_"CSSDP_WorkTimes,CSSDP_Volumn,CSSDP_PackTypeDetail,CSSDP_LOCDR,CSSDP_Remark ,CSSDP_SterType,CSSDP_NotBioFlag "
			_",CSSDP_CreateLocDr,CSSDP_SpecDr,CSSDP_ZCompany,CSSDP_ZCompany->CSSDVen_Name as VenName,CSSDP_WorkCost"
			_" FROM CSSD_Package where (CSSDP_Desc like '%"_PPkgDesc_"%' OR CSSDP_Alias like '%"_PPkgDesc_"%' ) "
	i PPkgId'="" d
	.s SqlStr=SqlStr_" and CSSDP_Rowid in ("_PPkgId_")"
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("CSSDP_Rowid")
		s IsExt = Result.Data("CSSDP_IsExt")
		s PkgCode = Result.Data("CSSDP_Code")
		s PkgDesc = Result.Data("CSSDP_Desc")
		s PkgAlias = Result.Data("CSSDP_Alias")
		s UomId = Result.Data("CSSDP_UOM_DR")
		s NotUseFlag = Result.Data("CSSDP_NotUseFlag")
		s PackPhoto = Result.Data("CSSDP_PackPhoto")
		s PkgClassId = Result.Data("CSSDP_PackClassdr")
		s PkgClassDesc = Result.Data("PackClassName")
		s WorkTimes = Result.Data("CSSDP_WorkTimes")
		s Volumn = Result.Data("CSSDP_Volumn")
		s AttributeId = Result.Data("CSSDP_PackTypeDetail")
		s LocId = Result.Data("CSSDP_LOCDR")
		s Remark = Result.Data("CSSDP_Remark")
		s SterTypeId = Result.Data("CSSDP_SterType")
		s NotBioFlag = Result.Data("CSSDP_NotBioFlag")
		s CreateLocId = Result.Data("CSSDP_CreateLocDr")
		s SpecId = Result.Data("CSSDP_SpecDr")
		s FirmId = Result.Data("CSSDP_ZCompany")
		s FirmDesc = Result.Data("VenName")
		s WorkCost=Result.Data("CSSDP_WorkCost") ;器械总数
		
		continue:((PBioFlag'="")&(PBioFlag'=NotBioFlag))
		continue:((PExtFlag'="")&(PExtFlag'=IsExt))
		s ShowDataFlag =##class(web.CSSDHUI.HospMap).GetShowDataFlag("CSSD_Package",RowId,PHospId)
		continue:ShowDataFlag="N"
		s UomDesc=""
		s:UomId'="" UomDesc=$p(^CT("UOM",UomId),"^",2)
		continue:((PNotUse'="")&(PNotUse'=NotUseFlag))
		
		s (Length,MaterialId,MaterialDesc)="",Price=0
		s MaterialId=##class(web.CSSDHUI.Common.PackageInfoCommon).GetDefaultMaterial(RowId)
		i MaterialId'="" d
		.s MaterialDesc=$List(^User.CSSDMaterialD(MaterialId),3)
		.s MatInfo=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetMaterialExpireLength(MaterialId,RowId)
		.i MatInfo'="" d
		..s Length=$p(MatInfo,"^",1)
		..s Price=$p(MatInfo,"^",2)
		
		continue:((PPkgClassId'="")&(PPkgClassId'=PkgClassId))
		continue:((PAttributeId'="")&((","_PAttributeId_",")'[(","_AttributeId_",")))
		continue:((PContainerFlag="N")&((AttributeId=3)||(AttributeId=6)))	//包装材料界面灭菌架和清洗架过滤
		s AttributeDesc=##class(web.CSSDHUI.Common.PackageInfoCommon).GetPackageDetailDesc(AttributeId)
		continue:(PLoc'="")&&(PLoc'=LocId)
		s LocDesc=..sssLocDesc(LocId)
		
		continue:((PSterTypeId'="")&(PSterTypeId'=SterTypeId))
		s SterTypeObj=##class(User.CSSDSterType).%OpenId(SterTypeId)
		s SterTypeDesc=""
		i $IsObject(SterTypeObj) d
		.s SterTypeDesc=SterTypeObj.CSSDSTSterName
		continue:((gLocId'="")&&(CreateLocId'="")&&(gLocId'=CreateLocId))
		
		s PkgSpecObj=##class(CT.STER.CSSD.PackageSpec).%OpenId(SpecId)
		s SpecDesc=""
		i $IsObject(PkgSpecObj) d
		.s SpecDesc=PkgSpecObj.PSSpecDesc
		
		s ItmQty=##class(web.CSSDHUI.Common.PackageInfoCommon).GetItmQtyByPkgId(RowId)
		i ItmQty=0 s ItmQty=WorkCost
		d OutPutPackage
	}
	d Result.Close()
	Quit $$$OK
	
OutPutPackage
	s Data=$lb(RowId,PkgCode,PkgDesc,PkgAlias,UomId,UomDesc,NotUseFlag,Price,PkgClassId,PkgClassDesc,
			WorkTimes,Length,AttributeId,AttributeDesc,LocId,LocDesc,Remark,SterTypeId,SterTypeDesc,
			IsExt,NotBioFlag,MaterialId,MaterialDesc,SpecId,SpecDesc,FirmId,FirmDesc,ItmQty
	)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:   插入图片
/// Creater:    wfg
/// CreateDate: 2019-7-31
/// Table:
/// Input:File图片流Param=GroupId_"^"_LocId_"^"_UserId  
/// Output:
ClassMethod SavePkgImg(File As %CSP.BinaryStream, Params As %String, FileName As %String) As web.CSSDHUI.RtnObj
{
	n (File,Params,FileName)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s PPkgDesc=PJObj.%Get("PkgDesc")
	s PPkgId=PJObj.%Get("PkgId")
	s gHospId=PJObj.%Get("gHospId")
	s gUserId=PJObj.%Get("gUserId")
	s gGroupId=PJObj.%Get("gGroupId")
	s gLocId=PJObj.%Get("gLocId")
	s ParamData=gUserId_"^"_gLocId_"^"_gGroupId_"^"_gHospId
	s ParamTitle="UserId^LocId^GroupId^HospId"
	s Param=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(ParamData,ParamTitle)
	
	s Len=$L(FileName,".")
	s FileSuffix=$p(FileName,".",Len)
	s FileSuffix=$$ALPHAUP^SSUTIL4(FileSuffix)
	s PicType=$$ALPHAUP^SSUTIL4("gif,jpg,jpeg,bmp,png")
	i (PicType'[FileSuffix) s Type="PDF"
	e  s Type="JPG"
	s PkgUrlDesc=PPkgDesc_$tr($j($RANDOM(1000000),6)," ","0")_"."_FileSuffix
	s Result = ##class(web.CSSDHUI.Common.FtpFile).UpFile(File,PkgUrlDesc,Param)
	i Result'=0  d RtnObj.Err(-99,"","ftp服务上传失败")
	q:RtnObj.success'=0 RtnObj
	
	&sql(insert into CSSD_PackageImageUrl (CSSDPI_PackageDr,CSSDPI_ImageUrl,CSSDPI_Type,CSSDPI_FileName)values(:PPkgId,:PkgUrlDesc,:Type,:FileName) )
	i SQLCODE'=0 d RtnObj.Err(-1,"","上传失败!")
	q:RtnObj.success'=0 RtnObj
	
	q RtnObj
}

/// Descript: 查询消毒图片信息
/// Creater:  wfg
/// CreateDate: 2019-8-2
/// Table: CSSD_PackageImageUrl
/// Input:
/// Output:     
/// Return：w ##class(web.CSSDHUI.PackageInfo.Package).GetPkgImgInfo(221,"JPG")
ClassMethod GetPkgImgInfo(PkgId As %String, Type As %String) As %String
{
	n (PkgId,Type)
	s SqlStr="SELECT ID,CSSDPI_ImageUrl,CSSDPI_PackageDr,CSSDPI_Type,CSSDPI_FileName"
			_" FROM CSSD_PackageImageUrl WHERE CSSDPI_PackageDr="_PkgId_" and CSSDPI_Type='"_Type_"'"
	s Result = ##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	s json = ##class(web.CSSDHUI.Common.JsonObj).%New()
	While(Result.Next())
	{
		s RowId = Result.Data("ID")
		s PkgId = Result.Data("CSSDPI_PackageDr")
		s ImgSrc=Result.Data("CSSDPI_ImageUrl")
		s ImgType=Result.Data("CSSDPI_Type")
		s FileName=Result.Data("CSSDPI_FileName")
		s Data=RowId_"^"_PkgId_"^"_ImgSrc_"^"_ImgType_"^"_FileName
		d json.InsertRowData(Data)
	}
	d Result.Close()
	d json.getCbJsonData("RowId^PkgId^ImgSrc^ImgType^FileName")
	k json
	Q ""
}

/// Descript: 删除消毒包图片信息
/// Creater:  wfg
/// CreateDate: 2019-8-2
/// Table: CSSD_PackageImageUrl
/// Input:ImgId\Params
/// Output:
/// w ##class(web.CSSDHUI.PackageInfo.Package).jsDelPkgImg(3)
ClassMethod jsDelPkgImg(ImgId As %String, Params As %String) As %Library.String
{
	n (ImgId,Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..DelPkgImg(ImgId,Params)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Descript:	删除消毒图片
/// Creater:	XuChao
/// CreateDate:	2019-8-2
/// Table:		CSSD_PackageImageUrl
/// Input:		File图片流Param=GroupId_"^"_LocId_"^"_UserId  供应商rowid
/// Output:
/// w ##class(web.CSSDHUI.PackageInfo.Package).DelPkgImg(164,"")
ClassMethod DelPkgImg(ImgId As %String, Params As %String) As web.CSSDHUI.RtnObj
{
	n (ImgId,Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJobj=##class(web.CSSDHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s PkgId=PJobj.%Get("PkgId")
	s gHospId=PJobj.%Get("gHospId")
	s gUserId=PJobj.%Get("gUserId")
	s gGroupId=PJobj.%Get("gGroupId")
	s gLocId=PJobj.%Get("gLocId")
	s ParamData=gUserId_"^"_gLocId_"^"_gGroupId_"^"_gHospId
	s ParamTitle="UserId^LocId^GroupId^HospId"
	s Param=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(ParamData,ParamTitle)
	s FileName=""
	s PkgImgObj=##class(User.CSSDPackageImageUrl).%OpenId(ImgId)
	i $IsObject(PkgImgObj) s FileName=PkgImgObj.CSSDPIImageUrl
	
	&sql(delete FROM CSSD_PackageImageUrl WHERE ID=:ImgId)
	i SQLCODE'=0 d RtnObj.Err(-1,"","删除失败!")
	q:RtnObj.success'=0 RtnObj
	
	s Result = ##class(web.CSSDHUI.Common.FtpFile).DeleFile(FileName,Param)
	i Result'=0 d RtnObj.Err(-1,"","删除FTP文件失败!")
	q:RtnObj.success'=0 RtnObj
	
    q RtnObj
}

/// Creator:ban
/// CreatDate:2020-3-2
/// Description:消毒包启用，判断所在的明细是否都启用
/// Table:CSSD_Package
/// 判断消毒包能否启用
/// d ##class(web.CSSDHUI.PackageInfo.Package).IsPkgUse(3)
ClassMethod IsPkgUse(PkgId As %String) As %Library.String
{
	n (PkgId)
	s UseFlag="Y"
	s PkgItmId=""
	f  s PkgItmId=$o(^User.CSSDPackageItemI("CSSDPIPackageIndex",PkgId,PkgItmId)) q:((PkgItmId="")||(UseFlag="N"))  d
	.q:PkgItmId=""
	.s ItmId = $list(^User.CSSDPackageItemD(PkgItmId),7)
	.s ItemObj=##class(User.CSSDItem).%OpenId(ItmId)
	.s UseFlag=ItemObj.CSSDIUseFlag
	q UseFlag
}

/// Creator:lxt
/// CreatDate:20220511
/// Description:消毒包保存功能
/// Table:CSSD_Package
/// Input: Params
/// w ##class(web.CSSDHUI.PackageInfo.Package).jsSavePkg("{""PkgAttributeId"":""1"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2"",""PkgClassId"":""1"",""PkgSpecId"":""2"",""PkgMaterialId"":""2"",""PkgUom"":""25"",""PkgSterType"":""20"",""PkgReqLoc"":"""",""Firm"":"""",""PkgBioFlag"":"""",""PkgUseFlag"":""Y"",""PkgPrice"":""30.00"",""PkgLength"":""180"",""PkgWorkTimes"":"""",""PkgId"":"""",""PkgCode"":"""",""PkgDesc"":""测试23"",""PkgAlias"":"""",""PkgRemark"":"""",""BDPHospital"":""2""}")
ClassMethod jsSavePkg(Params) As %Library.String
{
	n (Params,%session)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..SavePkg(Params)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:lxt
/// CreatDate:20220511
/// Description:消毒包保存功能
/// Table:CSSD_Package
/// Input: Params
/// w ##class(web.CSSDHUI.PackageInfo.Package).SavePkg()
ClassMethod SavePkg(Params) As web.CSSDHUI.RtnObj
{
	n (Params,%session)
	d ..sssSetLogID()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i (Sc'=0) q RtnObj.Err(-1,"","入参解析失败!")
	
	s RowId=PJObj.%Get("PkgId")
	s PPkgCode=PJObj.%Get("PkgCode")
	s PPkgDesc=PJObj.%Get("PkgDesc")
	s PPkgAlias=PJObj.%Get("PkgAlias")
	s PPkgSpecId=PJObj.%Get("PkgSpecId")
	s PPkgClassId=PJObj.%Get("PkgClassId")
	s PPkgAttributeId=PJObj.%Get("PkgAttributeId")
	s PPkgSterType=PJObj.%Get("PkgSterType")
	s PPkgUomId=PJObj.%Get("PkgUom")
	s PPkgMaterialId=PJObj.%Get("PkgMaterialId")
	s PPkgPrice=PJObj.%Get("PkgPrice")
	s PPkgLength=PJObj.%Get("PkgLength")
	s PPkgWorkTimes=PJObj.%Get("PkgWorkTimes")
	s PReqLocId=PJObj.%Get("PkgReqLoc")
	s PRemark=PJObj.%Get("PkgRemark")
	s PBioFlag=PJObj.%Get("PkgBioFlag")
	s PUseFlag=PJObj.%Get("PkgUseFlag")
	s PFirmId=PJObj.%Get("Firm")
	s PIsExt=PJObj.%Get("IsExt")
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s gLocId=PJObj.%Get("gLocId")
	s PWorkCost=PJObj.%Get("WorkCost") ;器械总数
	i PWorkCost="" s PWorkCost=0
	i (PWorkCost=0)&&(RowId'="") d
	.s ItmQty=##class(web.CSSDHUI.Common.PackageInfoCommon).GetItmQtyByPkgId(RowId)
	.s PWorkCost=ItmQty
	
	s:PPkgPrice="" PPkgPrice=0
	s:PBioFlag="" PBioFlag="N"
	s:PUseFlag="" PUseFlag="N"
	s:PIsExt="" PIsExt="N"
	s pHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(pHospId,gHospId)
	
	//新增清洗&灭菌架时默认单位为 台
	i ((PPkgAttributeId="3")||(PPkgAttributeId="6")) d
	.s PUomDesc="台"
	.s PUomId=$d(^CT("UOM",0,"Desc",PUomDesc))
	.i PUomId=0 d
	..&sql(INSERT INTO CT_UOM(CTUOM_Code,CTUOM_Desc,CTUOM_ForeignDesc ) VALUES (:PUomDesc,:PUomDesc,:PUomDesc))
	..i SQLCODE'=0 d RtnObj.Err(-7,"单位插入失败!")
	.s PPkgUomId=$o(^CT("UOM",0,"Desc",PUomDesc,""))
	
	s RepeatId=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Desc",PPkgDesc,"CSSD_Package",pHospId)
	i ((RepeatId'="")&&(RepeatId'=RowId)) q RtnObj.Err(-3,"",PPkgDesc_"-名称重复!")
	
	i ((PPkgAttributeId="1")||(PPkgAttributeId="2")||(PPkgAttributeId="7")||(PPkgAttributeId="10")) d
	.i (RowId="")&&(PPkgMaterialId="") d RtnObj.Err(-4,"","新增时请维护包装材料!")
	q:RtnObj.success'=0 RtnObj
	
	i ((PPkgAttributeId="1")||(PPkgAttributeId="2")||(PPkgAttributeId="6")||(PPkgAttributeId="7")||(PPkgAttributeId="10")) d
	.i PPkgSterType="" d RtnObj.Err(-5,"",PPkgDesc_"未维护灭菌方式!")
	q:RtnObj.success'=0 RtnObj
	
	i ((PPkgAttributeId'=1)&&(PIsExt="Y")) d RtnObj.Err(-5,"","包属性不是标牌追溯包，不能维护为外来器械!")
	q:RtnObj.success'=0 RtnObj
	
	i PPkgCode="" d
	.&sql(SELECT Max(CSSDP_Code) INTO :PPkgCode FROM CSSD_Package)
	.s PPkgCode=PPkgCode+1
	i PPkgAlias="" d
	.s PPkgAlias=##class(web.CSSDHUI.Common.UtilCommon).GetCNCODE(PPkgDesc,4,"")
	
	i RowId="" d
	.s obj=##class(User.CSSDPackage).%New()
	.s obj.CSSDPCode=PPkgCode
	.s obj.CSSDPCreateLocDr=##class(User.CTLoc).%OpenId(gLocId)
	.s obj.CSSDPHospital=##class(User.CTHospital).%OpenId(pHospId)
	.s LogType="A"		;日志记录使用
	.s OldJsonStr=""
	e  d
	.i PUseFlag="Y" d
	..s Flag=..IsPkgUse(RowId)	//判断消毒包能否启用
	..i Flag="N" d RtnObj.Err(-2,"","该消毒包绑定存在停用明细器械，不能启用!")
	.q:RtnObj.success'=0
	.s obj=##class(User.CSSDPackage).%OpenId(RowId)
	.d obj.%Reload()
	.s OldPkgAttributeId=obj.CSSDPPackTypeDetail
	.i (OldPkgAttributeId'=PPkgAttributeId) d
	..s RtnObj=..CheckAttribute(RowId,OldPkgAttributeId,PPkgAttributeId)
	.q:RtnObj.success'=0
	.s LogType="U"
	.s OldJsonStr=##class(web.CSSDHUI.Common.JsonObj).GetValue("CSSD_Package",RowId)
	q:RtnObj.success'=0 RtnObj
	
	s obj.CSSDPDesc=PPkgDesc
	s obj.CSSDPNotBioFlag=PBioFlag
	s obj.CSSDPAlias=PPkgAlias
	s obj.CSSDPUom=##class(User.CTUOM).%OpenId(PPkgUomId)
	s obj.CSSDPPackClass=##class(User.CSSDPackageClass).%OpenId(PPkgClassId)
	s obj.CSSDPPackTypeDetail=PPkgAttributeId
	s obj.CSSDPUnitPrice=PPkgPrice
	s obj.CSSDPLOCDR=##class(User.CTLoc).%OpenId(PReqLocId)
	s obj.CSSDPRemark=PRemark
	s obj.CSSDPSterType=##class(User.CSSDSterType).%OpenId(PPkgSterType)
	s obj.CSSDPNotUseFlag=PUseFlag
	s obj.CSSDPSpecDr=##class(CT.STER.CSSD.PackageSpec).%OpenId(PPkgSpecId)
	s obj.CSSDPWorkTimes=PPkgWorkTimes
	s obj.CSSDPZCompany=##class(User.CSSDVen).%OpenId(PFirmId)
	s obj.CSSDPIsExt=PIsExt
	s obj.CSSDWorkCost=PWorkCost
	s Sc=obj.%Save()
	
	i $$$ISERR(Sc) d RtnObj.Err(-5,"",$ClassName()_"SavePkg:保存失败!")
	q:RtnObj.success'=0 RtnObj
	
	s RowId=obj.%Id()
	s Ret = ##class(web.CSSDHUI.HospMap).SaveHOSP("CSSD_Package",RowId,pHospId)
	q:Ret'=0 RtnObj.Err(-6,"","关联院区失败!")
	
	i ((PPkgAttributeId="1")||(PPkgAttributeId="2")||(PPkgAttributeId="7")||(PPkgAttributeId="10")) d
	.s RtnObj=..UpdateLength(RowId,PPkgMaterialId,PPkgLength,PPkgPrice)
	q:RtnObj.success'=0 RtnObj
	
	s RtnObj=##class(web.CSSDHUI.Log).SaveLog("CSSD_Package","User.CSSDPackage","消毒包信息",RowId,PPkgDesc,LogType,"",OldJsonStr)
	i RtnObj.success'=0 q RtnObj

	d ..sssKillLogID()
	s RtnObj.rowid=RowId
	q RtnObj
}

/// Creator:ban
/// CreatDate:2020-3-2
/// Description:修改消毒包 默认的包装材料、有效期、价格等信息
/// Table:CSSD_Expire
/// w ##class(web.CSSDHUI.PackageInfo.Package).UpdateLength(1057,1,2,3)
ClassMethod UpdateLength(PkgId As %Integer, MaterialId As %Integer, Length As %Integer, Price As %Float) As web.CSSDHUI.RtnObj
{
	n (PkgId,MaterialId,Length,Price)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i (PkgId="")||(MaterialId="") d RtnObj.Err(-1,"","消毒包不存在或者包装材料未维护")
	q:RtnObj.success'=0 RtnObj
	
	s IsExist=$o(^User.CSSDExpireI("IndexCSSDEXPackage",PkgId,""))
	i IsExist'="" d
	.&sql(UPDATE CSSD_Expire SET CSSDEx_IsDefault="N" WHERE CSSDEX_Package_DR=:PkgId)
	.i SQLCODE d RtnObj.Err(-1,"","更改所有包装材料默认标志为N失败!")
	q:RtnObj.success'=0 RtnObj
	
	s ExpireId=$o(^User.CSSDExpireI("IndexCSSDEXPackageMat",PkgId,MaterialId,""))
	i ExpireId="" d		//不存在该消毒包对应的包装材料
	.&sql(INSERT INTO CSSD_Expire(CSSDEX_Package_DR,CSSDEX_Material_DR,CSSDEX_Length,CSSDEX_Price,CSSDEx_IsDefault) values(:PkgId,:MaterialId,:Length,:Price,'Y'))
	.i SQLCODE  d RtnObj.Err(-2,"","插入消毒包包装材料信息失败！")
	e  d
	.&sql(UPDATE CSSD_Expire SET CSSDEx_IsDefault="Y",CSSDEX_Length=:Length,CSSDEX_Price=:Price WHERE CSSDEX_Package_DR=:PkgId AND CSSDEX_Material_DR=:MaterialId)
	.i SQLCODE d RtnObj.Err(-4,"","更改该包装材料的信息失败!")
	q:RtnObj.success'=0 RtnObj
	
	q RtnObj
}

/// Creator:ban
/// CreatDate:2020-3-2
/// Description:消毒包删除，判断业务数据：普通循环包（2）\专科包（10）判断请领表、标牌追溯包（1）判断清洗表 、非循环包（7）判断pack
/// Table:CSSD_Package
/// 判断消毒包能否删除
/// w ##class(web.CSSDHUI.PackageInfo.Package).IsPkgDel("1")
ClassMethod IsPkgDel(PkgId As %String) As %Library.String
{
	n (PkgId)
	s AttributeId=$lg(^User.CSSDPackageD(PkgId),15)
	s isStop=0
	
	i ((AttributeId="1")||(AttributeId="2")||(AttributeId="7")||(AttributeId="10")) d
	.i $d(^User.CSSDPackageApplyDetailI("CSSDPADPackageDrIndex",PkgId)) s isStop=1 q
	.i $d(^User.CSSDCallbackDetailNewI("CSSDCDPackageIndex",PkgId)) s isStop=1 q
	.i $d(^User.CSSDCleanDetailPacksI("IndexPkgdr",PkgId)) s isStop=1 q
	.i $d(^User.CSSDTransI("CSSDTPackageIndex",PkgId)) s isStop=1 q
	.i $d(^User.CSSDCodeDictI("PACKDR",PkgId)) s isStop=1 q
	e  d
	.s isStop=2
	q isStop
}

/// Creator:ban
/// CreatDate:2020-3-2
/// Description:删除消毒包信息
/// Table:CSSD_Package
/// w ##class(web.CSSDHUI.PackageInfo.Package).jsDeletePkg(3)
ClassMethod jsDeletePkg(Params) As %Library.String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!").Json()
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		
		s PkgId=Obj.%Get("RowId")
		continue:PkgId=""
		s RtnObj=..DeletePkg(PkgId)
		continue:RtnObj.success'=0
	}
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:ban
/// CreatDate:2020-3-2
/// Description:删除消毒包信息
/// Table:CSSD_Package
/// w ##class(web.CSSDHUI.PackageInfo.Package).DeletePkg("1")
ClassMethod DeletePkg(PkgId As %String) As web.CSSDHUI.RtnObj
{
	n (PkgId)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i PkgId="" q RtnObj.Err(-1,"","入参不能为空!")
	
	s Ret=..IsPkgDel(PkgId)
	i Ret=1 q RtnObj.Err(-2,"","该消毒包存在业务数据，不能删除！")
	i Ret=2 q RtnObj.Err(-2,"","灭菌架等不允许删除，请做停用处理！")
	
	s PkgItmId=""
	f  s PkgItmId=$o(^User.CSSDPackageItemI("CSSDPIPackageIndex",PkgId,PkgItmId)) q:(PkgItmId="")||(RtnObj.success'=0)  d
	.s RtnObj=##class(web.CSSDHUI.PackageInfo.PackageItem).Delete(PkgItmId)
	q:RtnObj.success'=0 RtnObj
	
	&sql(Delete from CSSD_Package where CSSDP_Rowid=:PkgId)
	i SQLCODE'=0 q RtnObj.Err(-11,"",$ClassName()_".DeletePkg:SQLCODE"_SQLCODE_":"_$g(%msg))
	
	s Retval=##class(web.CSSDHUI.HospMap).DeleteHospitals("CSSD_Package",PkgId)
	i Retval<0 q RtnObj.Err(-4,PkgId,$ClassName()_":删除医院关联数据失败！,SQLOCDE:"_SQLCODE) 
	
	q RtnObj
}

/// Creator:ban
/// CreatDate:2020-3-2
/// Description:更加消毒包明细总价格
/// Table:CSSD_PackageItem
/// w ##class(web.CSSDHUI.PackageInfo.Package).GetPkgPrice("250")
ClassMethod GetPkgPrice(PkgId As %Integer) As %Library.String
{
	n (PkgId)
	s SumPrice=0
	s PkgItmId=""
	f  s PkgItmId=$o(^User.CSSDPackageItemI("CSSDPIPackageIndex",PkgId,PkgItmId)) q:(PkgItmId="")  d
	.s ItmQty=$List(^User.CSSDPackageItemD(PkgItmId),4)
	.s ItmId = $list(^User.CSSDPackageItemD(PkgItmId),7)
	.s ItmObj=##class(User.CSSDItem).%OpenId(ItmId)
	.d ItmObj.%Reload()
	.s Price=ItmObj.CSSDIPrice
	.s ItmPrice=ItmQty*Price
	.s SumPrice=SumPrice+ItmPrice
	q SumPrice
}

/// Creator:ban
/// CreatDate:2022-9-22
/// Description:消毒包维护页面消毒包复制功能
/// Table:CSSD_Package
/// d ##class(web.CSSDHUI.PackageInfo.Package).JsCopyPackage(4,2)
ClassMethod JsCopyPackage(PkgId As %String) As %Library.String
{
	n (PkgId)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..CopyPackage(PkgId)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:ban
/// CreatDate:2022-9-22
/// Description:消毒包维护页面消毒包复制功能
/// Table:CSSD_Package
/// d ##class(web.CSSDHUI.PackageInfo.Package).CopyPackage("46")
ClassMethod CopyPackage(PkgId As %String) As web.CSSDHUI.RtnObj
{
	n (PkgId)
	q:PkgId="" $$$OK
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PkgCode=0
	&sql(SELECT Max(CSSDP_Code) INTO :PkgCode FROM CSSD_Package)
	s PkgCode=PkgCode+1
	s PkgObj=##class(User.CSSDPackage).%OpenId(PkgId)
	d PkgObj.%Reload()
	s PkgDesc=PkgObj.CSSDPDesc_PkgCode
	s UomObj=PkgObj.CSSDPUom
	s PkgClassObj=PkgObj.CSSDPPackClass
	s AttributeId=PkgObj.CSSDPPackTypeDetail
	s UnitPrice=PkgObj.CSSDPUnitPrice
	s PackPrice=PkgObj.CSSDPPackPrice
	s UrgentPrice=PkgObj.CSSDPUrgentPrice
	s Remark=PkgObj.CSSDPRemark
	s SterTypeObj=PkgObj.CSSDPSterType
	s NotUseFlag=PkgObj.CSSDPNotUseFlag
	s NotBioFlag=PkgObj.CSSDPNotBioFlag
	s HospitalObj=PkgObj.CSSDPHospital
	s CreateLocObj=PkgObj.CSSDPCreateLocDr
	s SpecObj=PkgObj.CSSDPSpecDr
	s LocObj=PkgObj.CSSDPLOCDR
	s IsExt=PkgObj.CSSDPIsExt
	s:IsExt="" IsExt="N"
	s PkgAlias=##class(web.CSSDHUI.Common.UtilCommon).GetCNCODE(PkgDesc,4,"")
	
	s RowId=""
	s obj=##class(User.CSSDPackage).%New()
	s obj.CSSDPWorkTimes=0
	s obj.CSSDPDesc=PkgDesc
	s obj.CSSDPNotBioFlag=NotBioFlag
	s obj.CSSDPAlias=PkgAlias
	s obj.CSSDPCode=PkgCode
	s obj.CSSDPUom=UomObj
	s obj.CSSDPPackClass=PkgClassObj
	s obj.CSSDPPackTypeDetail=AttributeId
	s obj.CSSDPUnitPrice=UnitPrice
	s obj.CSSDPLOCDR=LocObj
	s obj.CSSDPRemark=Remark
	s obj.CSSDPSterType=SterTypeObj
	s obj.CSSDPNotUseFlag=NotUseFlag
	s obj.CSSDPHospital=HospitalObj
	s obj.CSSDPCreateLocDr=CreateLocObj
	s obj.CSSDPSpecDr=SpecObj
	s obj.CSSDPIsExt=IsExt
	s Sc=obj.%Save()
	i $$$ISERR(Sc) d RtnObj.Err(-1,"",$ClassName()_"CopyPackage:复制失败!")
	q:RtnObj.success'=0 RtnObj
	
	i RowId="" d
	.s RowId=obj.%Id()
	i ((AttributeId="1")||(AttributeId="2")||(AttributeId="7")||(AttributeId="10")) d
	.s ExpireId=""
	.f  s ExpireId=$o(^User.CSSDExpireI("IndexCSSDEXPackage",PkgId,ExpireId))  q:((ExpireId="")||(RtnObj.success'=0))  d
	..s ExpireObj=##class(User.CSSDExpire).%OpenId(ExpireId)
	..d ExpireObj.%Reload()
	..q:'$IsObject(ExpireObj)
	..s Length=ExpireObj.CSSDEXLength
	..s Price=ExpireObj.CSSDEXPrice
	..s MaterialId=ExpireObj.CSSDEXMaterialDr.%Id()
	..s Default=ExpireObj.CSSDExIsDefault
	..&sql(INSERT INTO CSSD_Expire(CSSDEX_Package_DR,CSSDEX_Material_DR,CSSDEX_Length,CSSDEX_Price,CSSDEx_IsDefault) values(:RowId,:MaterialId,:Length,:Price,:Default))
	..i SQLCODE  d RtnObj.Err(-2,"","插入包装材料绑定信息失败！")
	..q:RtnObj.success'=0
	q:RtnObj.success'=0 RtnObj
	
	s RtnObj=..SaveItmByPkg(RowId,PkgId)
	q:RtnObj.success'=0 RtnObj
	
	s Ret = ##class(web.CSSDHUI.HospMap).SaveHOSP("CSSD_Package",RowId,HospitalObj.%Id())
	i Ret'=0 d RtnObj.Err(-3,"","关联院区失败!")
	q:RtnObj.success'=0 RtnObj
	
	s RtnObj.rowid=RowId
	q RtnObj
}

/// Creator:wangning
/// CreatDate:2020-11-12
/// Description:消毒包维护页面明细另存
/// Table:CSSD_PackageItem
/// d ##class(web.CSSDHUI.PackageInfo.Package).JsSaveDetailByPackage(1,1)
ClassMethod JsSaveItmByPkg(NewPkgId As %String, ByPkgId As %String) As %Library.String
{
	n (NewPkgId,ByPkgId)
	s $ZT=..sssError()
	ts
	s RtnObj=..SaveItmByPkg(NewPkgId,ByPkgId)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:ban
/// CreatDate:2022-9-22
/// Description:根据被复制的消毒包Id保存复制后消毒包的明细
/// Table:CSSD_PackageItem
/// d ##class(web.CSSDHUI.PackageInfo.Package).SaveItmByPkg("46")
ClassMethod SaveItmByPkg(NewPkgId As %String, ByPkgId As %String) As web.CSSDHUI.RtnObj
{
	n (NewPkgId,ByPkgId)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PkgItmId=""
	f  s PkgItmId=$o(^User.CSSDPackageItemI("CSSDPIPackageIndex",ByPkgId,PkgItmId))  q:((PkgItmId="")||(RtnObj.success'=0))  d
	.s PkgItmObj=##class(User.CSSDPackageItem).%OpenId(PkgItmId)
	.d PkgItmObj.%Reload()
	.s ItmId=PkgItmObj.CSSDPIItmDRGetObjectId()
	.s Qty=PkgItmObj.CSSDPIQty
	.s TmpId=$o(^User.CSSDPackageItemI("CSSDPIPackageItmIndex",NewPkgId,ItmId,""))
	.i TmpId="" d
	..s RowId=NewPkgId_"||"_ItmId
	..&sql(Insert into CSSD_PackageItem(CSSDPI_Itm_Dr,CSSDPI_Rowid,CSSDPI_Package_Dr,CSSDPI_Qty) values(:ItmId,:RowId,:NewPkgId,:Qty))
	..i SQLCODE'=0 d RtnObj.Err("-1","","插入消毒包明细失败！")
	.e  d
	..&sql(update CSSD_PackageItem set CSSDPI_Qty=CSSDPI_Qty+:Qty where ID=:TmpId)
	..i SQLCODE'=0  d RtnObj.Err("-2","","更新消毒包明细数量失败！")
	..q:RtnObj.success'=0
	q:RtnObj.success'=0 RtnObj
	
	s RtnObj=##class(web.CSSDHUI.PackageInfo.PackageItem).sortItmNo(NewPkgId)
	q:RtnObj.success'=0 RtnObj
	
	q RtnObj
}

/// Creator:ban
/// CreatDate:2022-9-22
/// Description:获取默认灭菌方式的相关信息
/// Table:CSSD_SterType
/// w ##class(web.CSSDHUI.PackageInfo.Package).GetSterTypeInfo(2)
ClassMethod GetSterTypeInfo(PkgId As %String) As %String
{
	n (PkgId)
	q:PkgId="" ""
	s PkgObj=##class(User.CSSDPackage).%OpenId(PkgId)
	d PkgObj.%Reload()
	s SterTypeObj=""
	i $IsObject(PkgObj) d
	.s SterTypeObj =PkgObj.CSSDPSterType
	q:'$IsObject(SterTypeObj)
	s SterTypeId=SterTypeObj.%Id()
	s SterTypeDesc=SterTypeObj.CSSDSTSterName
	s SterTypeColor=SterTypeObj.CSSDSTDisplayColor
	d SterTypeObj.%Close()
	q SterTypeId_"^"_SterTypeDesc_"^"_SterTypeColor
}

/// Creator:wangning
/// CreatDate:2020-11-12
/// Description:保存拍照
/// Table:CSSD_PackageImageUrl
/// w ##class(web.CSSDHUI.PackageInfo.Package).SavePhoto("{""OrgType"":""Vendor"",""OrgId"":""654"",""GrpType"":""Person"",""PointerType"":""SalesMan"",""Pointer"":""8"",""gUserId"":""873"",""gLocId"":""153"",""gGroupId"":""98"",""gHospId"":""2"",""SubType"":""PersonLic""}","aa1.jpg","20201112001.jpg")
ClassMethod SavePhoto(Params As %String, FileName As %String, NewFileName As %String) As %String
{
	n (Params,FileName,NewFileName)
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q -1
	
	s OrgType=PJObj.%Get("OrgType")		//对象Pkg等
	s OrgId=PJObj.%Get("OrgId")			//对象ID
	s GrpType=PJObj.%Get("GrpType")		//来源分类等
	s PointerType=PJObj.%Get("PointerType")	//数据类型等
	s Pointer=PJObj.%Get("Pointer")		//数据ID
	s SubType=PJObj.%Get("SubType")		//数据子类型类型
	s gHospId=PJObj.%Get("gHospId")
	s gUserId=PJObj.%Get("gUserId")
	
	s FileType=$p(NewFileName,".",2)
	s FileType="JPG"
	s Date=+$h
	s Time=$p($h,",",2)
	&sql(insert into CSSD_PackageImageUrl (CSSDPI_PackageDr,CSSDPI_ImageUrl
	,CSSDPI_Type,CSSDPI_FileName)values(:OrgId,:NewFileName,:FileType,:FileName) )
	q SQLCODE
}

/// Creator：lxt
/// Date：20220511
/// Descript：编辑修改消毒包时弹框中展示的消毒包信息
/// Table:CSSD_Package
/// w ##class(web.CSSDHUI.PackageInfo.Package).Select(2243)
ClassMethod Select(PkgId As %String) As %String
{
	n (PkgId)
	q:PkgId="" ""
	
	s PkgObj=##class(User.CSSDPackage).%OpenId(PkgId)
	q:'$IsObject(PkgObj) ""
	
	s (PkgSpecDesc,PkgClassDesc,AttributeDesc,PkgUomDesc,PkgSterTypeDesc)=""
	s PkgSpecId = PkgObj.CSSDPSpecDrGetObjectId()
	s PkgClassId=PkgObj.CSSDPPackClassGetObjectId()
	s AttributeId=PkgObj.CSSDPPackTypeDetail
	s PkgUomId=PkgObj.CSSDPUomGetObjectId()
	s PkgSterTypeId=PkgObj.CSSDPSterTypeGetObjectId()
	s PkgReqLocId=PkgObj.CSSDPLOCDRGetObjectId()
	s FirmId=PkgObj.CSSDPZCompanyGetObjectId()
	s WorkCost=PkgObj.CSSDWorkCost
	s ItmQty=##class(web.CSSDHUI.Common.PackageInfoCommon).GetItmQtyByPkgId(PkgId)
	i ItmQty'=0 s WorkCost=ItmQty
	
	i PkgSpecId'="" d
	.s PkgSpecObj=##class(CT.STER.CSSD.PackageSpec).%OpenId(PkgSpecId)
	.i $IsObject(PkgSpecObj) s PkgSpecDesc=PkgSpecObj.PSSpecDesc
	s PkgSpecStr=##class(web.CSSDHUI.Common.UtilCommon).ComboStr(PkgSpecId,PkgSpecDesc)
	
	i PkgClassId'="" d
	.s PkgClassObj=##class(User.CSSDPackageClass).%OpenId(PkgClassId)
	.i $IsObject(PkgClassObj) s PkgClassDesc=PkgClassObj.CSSDPCPackCalssName
	s PkgClassStr=##class(web.CSSDHUI.Common.UtilCommon).ComboStr(PkgClassId,PkgClassDesc)
	
	i AttributeId'="" s AttributeDesc=##class(web.CSSDHUI.Common.PackageInfoCommon).GetPackageDetailDesc(AttributeId)
	s AttributeStr=##class(web.CSSDHUI.Common.UtilCommon).ComboStr(AttributeId,AttributeDesc)
	
	s:PkgUomId'="" PkgUomDesc=$p(^CT("UOM",PkgUomId),"^",2)
	s PkgUomStr=##class(web.CSSDHUI.Common.UtilCommon).ComboStr(PkgUomId,PkgUomDesc)
	
	i PkgSterTypeId'="" d
	.s PkgSterTypeObj=##class(User.CSSDSterType).%OpenId(PkgSterTypeId)
	.i $IsObject(PkgSterTypeObj) s PkgSterTypeDesc=PkgSterTypeObj.CSSDSTSterName
	s PkgSterTypeStr=##class(web.CSSDHUI.Common.UtilCommon).ComboStr(PkgSterTypeId,PkgSterTypeDesc)
	
	s (PkgMaterialDesc,PkgPrice,PkgLength,PkgMaterialStr)=""
	s PkgMaterialId=##class(web.CSSDHUI.Common.PackageInfoCommon).GetDefaultMaterial(PkgId)
	i PkgMaterialId'="" d
	.s PkgMaterialDesc=$List(^User.CSSDMaterialD(PkgMaterialId),3)
	.s PkgMaterialStr=##class(web.CSSDHUI.Common.UtilCommon).ComboStr(PkgMaterialId,PkgMaterialDesc)
	.s MatInfo=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetMaterialExpireLength(PkgMaterialId,PkgId)
	.i MatInfo'="" d
	..s PkgLength=$p(MatInfo,"^",1)
	..s PkgPrice=$p(MatInfo,"^",2)
	
	s (PkgReqLocDesc,FirmDesc)=""
	i PkgReqLocId'="" s PkgReqLocDesc=..sssLocDesc(PkgReqLocId)
	s PkgReqLocStr=##class(web.CSSDHUI.Common.UtilCommon).ComboStr(PkgReqLocId,PkgReqLocDesc)
	
	.s FirmObj=##class(User.CSSDVen).%OpenId(FirmId)
	.i $IsObject(FirmObj) s FirmDesc=FirmObj.CSSDVenName
	s FirmStr=##class(web.CSSDHUI.Common.UtilCommon).ComboStr(FirmId,FirmDesc)
	
	s Data=PkgId_"^"_PkgObj.CSSDPCode_"^"_PkgObj.CSSDPDesc_"^"_PkgObj.CSSDPAlias_"^"_PkgSpecStr
			_"^"_PkgClassStr_"^"_AttributeId_"^"_PkgUomStr_"^"_PkgSterTypeStr_"^"_PkgMaterialStr
			_"^"_PkgPrice_"^"_PkgLength_"^"_PkgObj.CSSDPWorkTimes_"^"_PkgReqLocStr_"^"_PkgObj.CSSDPRemark
			_"^"_PkgObj.CSSDPNotBioFlag_"^"_PkgObj.CSSDPNotUseFlag_"^"_FirmStr_"^"_PkgObj.CSSDPIsExt_"^"_WorkCost
	s Title="PkgId^PkgCode^PkgDesc^PkgAlias^PkgSpecId^PkgClassId^PkgAttributeId^PkgUom^PkgSterType^PkgMaterialId^PkgPrice^PkgLength^PkgWorkTimes^PkgReqLoc^PkgRemark^PkgBioFlag^PkgUseFlag^Firm^IsExt^WorkCost"
	s PkgStr=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	
	q PkgStr
}

ClassMethod CheckAttribute(PkgId, OldAttributeId, NewAttributeId) As web.CSSDHUI.RtnObj
{
	n (PkgId,OldAttributeId,NewAttributeId)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	
	s PkgObj=##class(User.CSSDPackage).%OpenId(PkgId)
	s IsExt=PkgObj.CSSDPIsExt
	
	i (OldAttributeId="1")&&(IsExt="Y") d	//外来器械：存在未移交不能修改
	.s CodeDictId=0
	.f  s CodeDictId=$o(^User.CSSDCodeDictI("PACKDR",PkgId,CodeDictId)) q:(CodeDictId="")||(RtnObj.success'=0)  d
	..s NotUseFlag=$lg(^User.CSSDCodeDictD(CodeDictId),17)
	..s CodeDict=$lg(^User.CSSDCodeDictD(CodeDictId),2)
	..q:NotUseFlag="N"
	..s RegisterId=$o(^User.CSSDExtDevBindI("IndexCSSDExtCodeIsTransfer",CodeDict,"N",""))
	..i RegisterId'="" d RtnObj.Err(-2,"","存在未移交外来器械，不能修改包属性")
	.q:RtnObj.success'=0
	e  i (OldAttributeId="1")&&(NewAttributeId="2") d	//标牌追溯包->普通循环包：新标牌回收、清洗不能修改，旧标牌存在非回收状态不能修改
	.s CodeDictId=0
	.f  s CodeDictId=$o(^User.CSSDCodeDictI("PACKDR",PkgId,CodeDictId)) q:(CodeDictId="")||(RtnObj.success'=0)  d
	..s NotUseFlag=$lg(^User.CSSDCodeDictD(CodeDictId),17)
	..s CodeDict=$lg(^User.CSSDCodeDictD(CodeDictId),2)
	..q:NotUseFlag="N"
	..s TransId=$o(^User.CSSDTransI("CodeDict",CodeDict,""),-1)
	..i TransId'="" d
	...s Status=$lg(^User.CSSDTransD(TransId),8)
	...i Status'="C" d RtnObj.Err(-2,"","存在不是回收状态的标牌，不能修改包属性")
	..q:RtnObj.success'=0
	..e  d
	...s CleanId=$o(^User.CSSDCleanDetailPacksI("CSSDIndexCDPLabel",CodeDict,0))
	...i CleanId'="" d RtnObj.Err(-2,"","已发生清洗业务，不能修改包属性")
	...q:RtnObj.success'=0
	...s CBId=$o(^User.CSSDCallbackDetailNewI("CSSDPCDictLabelIndex",CodeDict,0))
	...//i CBId'="" d RtnObj.Err(-2,"","已发生回收业务，不能修改包属性")
	...//q:RtnObj.success'=0
	..q:RtnObj.success'=0
	.q:RtnObj.success'=0
	e  i (OldAttributeId="1")&&(NewAttributeId="7") d 	//标牌追溯包->非循环包：存在业务就不能修改
	.s CodeDictId=0
	.f  s CodeDictId=$o(^User.CSSDCodeDictI("PACKDR",PkgId,CodeDictId)) q:(CodeDictId="")||(RtnObj.success'=0)  d
	..s NotUseFlag=$lg(^User.CSSDCodeDictD(CodeDictId),17)
	..s CodeDict=$lg(^User.CSSDCodeDictD(CodeDictId),2)
	..q:NotUseFlag="N"
	..s CleanId=$o(^User.CSSDCleanDetailPacksI("CSSDIndexCDPLabel",CodeDict,0))
	..i CleanId'="" d RtnObj.Err(-2,"","存在清洗业务，不能修改包属性")
	..q:RtnObj.success'=0
	..s CBId=$o(^User.CSSDCallbackDetailNewI("CSSDPCDictLabelIndex",CodeDict,0))
	..i CBId'="" d RtnObj.Err(-2,"","存在回收业务，不能修改包属性")
	..q:RtnObj.success'=0
	.q:RtnObj.success'=0
	e  i (OldAttributeId="2") d 	//普通循环包：存在非C/U/R的不能修改，存在正在进行业务不能修改
	.s TransId=""
	.f  s TransId=$o(^User.CSSDTransI("CSSDTPackageIndex",PkgId,TransId),-1) q:(TransId="")||(RtnObj.success'=0)  d
	..s Status=$lg(^User.CSSDTransD(TransId),8)
	..i (Status'="C")&&(Status'="R")&&(Status'="U") d RtnObj.Err(-2,"","存在标签不是接收、使用、回收状态，不能修改包属性")
	.q:RtnObj.success'=0
	.s CleanId=""
	.f  s CleanId=$o(^User.CSSDCleanDetailPacksI("IndexPkgdr",PkgId,CleanId),-1) q:(CleanId="")||(RtnObj.success'=0)  d
	..s MainId=$lg(^User.CSSDCleanDetailPacksD(CleanId),3)
	..s CheckFlag=$lg(^User.CSSDCleanD(MainId),14)
	..i CheckFlag="" d RtnObj.Err(-2,"","存在消毒包正在清洗，不能修改包属性")
	..q:RtnObj.success'=0
	.q:RtnObj.success'=0
	.s CBId=""
	.f  s CBId=$o(^User.CSSDCallbackDetailNewI("CSSDCDPackageIndex",PkgId,CBId),-1) q:(CBId="")||(RtnObj.success'=0)  d
	..s MainId=$lg(^User.CSSDCallbackDetailNewD(CBId),2)
	..s CheckFlag=$lg(^User.CSSDPackageCallbackD(MainId),14)
	..i CheckFlag'="Y" d RtnObj.Err(-2,"","存在消毒包正在回收，不能修改包属性")
	..q:RtnObj.success'=0
	.q:RtnObj.success'=0
	e  i (OldAttributeId="7") d 	//非循环包：存在业务不能修改
	.s TransId=$o(^User.CSSDTransI("CSSDTPackageIndex",PkgId,0))
	.i TransId'="" d RtnObj.Err(-2,"","发生过业务，不能修改包属性")
	.q:RtnObj.success'=0
	e  i (OldAttributeId="3")||(OldAttributeId="6")||(NewAttributeId="3")||(NewAttributeId="6") d
	.d RtnObj.Err(-2,"","清洗架和灭菌架不能修改包属性")
	.q:RtnObj.success'=0
	q RtnObj
}

}
