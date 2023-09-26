Import SQLuser

Class web.CSSDHUI.Pack.ComposePackLabel Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

///  Creator:ban
///  CreatDate:2020/12/8
///  Description:设置以哪个包为主进行组合，并生成标签
///  Table:CSSD_CleanDetailPacks
ClassMethod jsSetUpComposeOrd(Main, Detail, num) As %String [ SqlProc ]
{
	n (Main, Detail, num)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..SetUpComposeOrd(Main,Detail,num)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

///  Creator:ban
///  CreatDate:2020/12/8
///  Description:设置以哪个包为主进行组合，并生成标签
///  Table:CSSD_CleanDetailPacks
///  Input:
///  Output:
///  Return:RtnObj
///  w ##class(web.CSSDHUI.Pack.ComposePackLabel).SetUpComposeOrd(^tempyj("Main"),^tempyj("Detail"),^tempyj("num"))
ClassMethod SetUpComposeOrd(Main, Detail, num) As %String [ SqlProc ]
{
	n (Main,Detail,num)
	s MethodName=$ClassName()_".SetUpComposeOrd"
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	q:((Main="")||(Detail="")) RtnObj.Err(-1,"","入参不能为空!")

	s PJObjMain=##class(web.CSSDHUI.Common.FromJson).%New()
	s ScMain=PJObjMain.%FromJSON(Main)
	s PJObjDetail=##class(web.CSSDHUI.Common.FromJson).%New()
	s ScDetail=PJObjDetail.%FromJSON(Detail)
	s LocId=PJObjMain.%Get("gLocId")
	s PPackChkUserId=PJObjMain.%Get("PackChkUser")
	s PPackUserId=PJObjMain.%Get("PackUser")
	s PPackerId=PJObjMain.%Get("Packer")
	s PSterDate=PJObjMain.%Get("SterDate")
	s PMaterialId=PJObjMain.%Get("MaterialId")

	q:((ScMain'=0)||(ScDetail'=0)) RtnObj.Err(-1,"","入参解析失败!")
	q:PPackChkUserId="" RtnObj.Err(-1,"","审核人为空")
	q:PPackUserId="" RtnObj.Err(-1,"","包装人为空")
	q:num="" RtnObj.Err(-1,"","num为空")

	s pdate=+$h
	s ptime=$p($h,",",2)
	i ((PSterDate'=pdate)&&(PSterDate'=""))  d
	.s SterDate=..DH2L(PSterDate)
	.s pdate=SterDate
	.s ptime=0

	while(RtnObj.success=0){
		s Obj=PJObjDetail.%Pop()
		q:Obj=""

		s (CleanId,retval,packageRegRowidS,CallBackdetailId,CallBackLoc)=""
		s CleanItmId=Obj.%Get("CleanItmId")
		s Qty=Obj.%Get("Qty")
		s CleanItmObj=##class(User.CSSDCleanDetailPacks).%OpenId(CleanItmId)
		d CleanItmObj.%Reload()
		s ComposeFlag = CleanItmObj.CSSDCDPComposeFlag
		s MaterialId=CleanItmObj.CSSDCDPMaterialDRGetObjectId()
		s LevelFlag=CleanItmObj.CSSDCDPLevelFlag
		;是否已生成标签
		s IsGen=CleanItmObj.CSSDCDPIsCrtLbl
		i IsGen=1  d RtnObj.Err(-1,"","标签已设定为组合!")
		continue:RtnObj.success'=0

		s CleanMain=CleanItmObj.CSSDCDPCleanMain
		s CleanId=CleanMain.%Id()
		s CleanDate=CleanMain.CSSDCDate
		;固定标签
		s CodeDict=CleanItmObj.CSSDCDPLabel
		s CallBackdetail=CleanItmObj.CSSDCDPCallBackDetailDr
		i $IsObject(CallBackdetail) d
		.s CallBackdetailId=CallBackdetail.%Id()
		.s CallBackLoc=##class(web.CSSDHUI.Pack.CleanPackLabel).GetLocID(CallBackdetailId)
		s PkgId=CleanItmObj.CSSDPRPackage.%Id()
		s pkgCode=CleanItmObj.CSSDPRPackage.CSSDPCode
		s serialNo=##class(web.CSSDHUI.Common.AppCommon).CreatePackSerialNo()
		s MaterialType=PMaterialId
		s:MaterialType="" MaterialType =MaterialId
		s:MaterialType="" MaterialType =##Class(web.CSSDHUI.Common.PackageInfoCommon).GetDefaultMaterial(PkgId)
		i MaterialType="" d RtnObj.Err(-1,"","未获取到消毒包清洗绑定的包装材料！","",0)
		continue:RtnObj.success'=0

		s MaterialInfo=##class(web.CSSDHUI.Common.PackageInfoCommon).GetMaterialExpireLength(MaterialType,PkgId)
		i MaterialInfo="" d RtnObj.Err(-2,"","消毒包和包装材料未做绑定！","",0)
		continue:RtnObj.success'=0

		s length=$p(MaterialInfo,"^",1)
		s price=$p(MaterialInfo,"^",2)
		i length=0 d RtnObj.Err(-3,"","消毒包有效期为空","",0)
		continue:RtnObj.success'=0

		s expireDate=pdate+length
		s labels=##class(web.CSSDHUI.Pack.CleanPackLabel).GetOrdLabels(pkgCode,num)
		s lblLenth=$L(labels,"^")
		s Label=""
		f j=1:1:lblLenth  q:RtnObj.success<0  d
		.s Label=$p(labels,"^",j)
		.&sql(Insert into CSSD_PackagePack(CSSDPP_Label,CSSDPP_Package_DR,CSSDPP_Loc_DR,CSSDPP_Date,CSSDPP_Time,CSSDPP_Qty,CSSDPP_User_DR,CSSDPP_AckUser_DR,CSSDPP_AckDate,CSSDPP_SerialNo,CSSDPP_IsLoadSteCar,CSSDPP_ApplyLoc,CSSDPP_CallBackDetailDr,CSSDPP_PackUser_DR,CSSDPP_Material_DR,CSSDPP_LevelFlag,CSSDPP_Clean_DR,CSSDPP_PrtTimes,CSSDPP_BasketCode,CSSDPP_CleanDetail_DR)
			Values
		(:Label,:PkgId,:LocId,:pdate,:ptime,1,:PPackUserId,:PPackChkUserId,:pdate,:serialNo,0,:CallBackLoc,:CallBackdetailId,:PPackerId,:MaterialType,:LevelFlag,:CleanId,0,:CodeDict,:CleanItmId))
		.i SQLCODE'=0  d
		..d RtnObj.Err(-10,"","插入数据失败:"_MethodName_":SQLCODE"_SQLCODE_":"_$g(%msg))
		.q:RtnObj.success<0
		.
		.s packageRegRowidS=$g(packageRegRowidS)_"^"_%ROWID
		.s PackId=%ROWID
		.&sql(Insert into CSSD_Trans(CSSDT_Label,CSSDT_Pack_DR,CSSDT_Package_DR,CSSDT_Clean_DR,CSSDT_Date,CSSDT_Time,CSSDT_ExpDate,cssdt_Status)Values(:Label,:PackId,:PkgId,:CleanItmId,:pdate,:ptime,:expireDate,'P'))
		.i SQLCODE'=0  d
		..d RtnObj.Err(-11,"","插入数据失败:"_MethodName_":SQLCODE"_SQLCODE_":"_$g(%msg))
		.q:RtnObj.success<0
		continue:RtnObj.success<0

		&sql(Update CSSD_CleanDetailPacks set CSSDCDP_ComposeFlag='Y',CSSDCDP_IsCrtLbl=1,cssdcdp_CreatedQty=cssdcdp_CreatedQty+:num  where %id=:CleanItmId)
		i SQLCODE'=0  d
		.d RtnObj.Err(-21,"","更新数据失败:"_MethodName_":SQLCODE"_SQLCODE_":"_$g(%msg))
		continue:RtnObj.success<0
		&sql(INSERT INTO CSSD_CleanPackCompose(CSSDCDPC_CleanDetailDR, CSSDCDPC_Qty, CSSDCDPC_PkgDr, CSSDCDPC_Label) VALUES (:CleanItmId,:Qty,:PkgId,:Label))
		i SQLCODE'=0 d RtnObj.Err(-22,"",label_"消毒包组合新增失败","",0)
		continue:RtnObj.success<0
	}
	q:RtnObj.success<0 RtnObj
	;如果 所有的 CSSDCDP_IsCrtLbl=0,则更新主表的 CSSDCDP_IsCrtLbl=1
	s cnt=""
	s cnt=$o(^User.CSSDCleanDetailPacksI("IndexMainDrIsCrtLbl",CleanId,"0",""))
	i cnt="" d
	.&sql(update CSSD_Clean set cssdc_iscreatelbl=1 where id=:CleanId)
	.i SQLCODE<0 d RtnObj.Err(-32,"","更新数据失败:"_MethodName_"SQLCODE"_SQLCODE_":"_$g(%msg))
	s RtnObj.rowid=packageRegRowidS
	q RtnObj
}

///  Creator:ban
///  CreatDate:2020.12.10
///  Description:生成组合包的标签
///  Table:
///  Input:Detail 需要组合的明细包 detailComposeID 组合的标准，以哪个包为主
///  Output:
///  Return:
///  Others：w ##Class(web.CSSDHUI.Pack.ComposePackLabel).ComposeOrdLabel(^tempyj("Detail"),^tempyj("detailComposeID"))
ClassMethod ComposeOrdLabel(Detail As %String, detailComposeID As %String) As %String [ SqlProc ]
{
	n (Detail,detailComposeID)
	s $zt =..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Detail)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()

	s (Label,ComposePkgDr)=""
	s ComposeMainId = $o(^User.CSSDCleanPackComposeI("ComposeDetailIndex",detailComposeID,""))
	i ComposeMainId'="" d
	.s ComposeMainObj = ##class(User.CSSDCleanPackCompose).%OpenId(ComposeMainId)
	.s Label = ComposeMainObj.CSSDCDPCLabel
	.s ComposePkgDr=ComposeMainObj.CSSDCDPCPkgDr.%Id()
	e  d RtnObj.Err(-1,"","请先设定组合的消毒包!")
	q:RtnObj.success'=0 RtnObj.Json()

	s CleanId=""
 	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""

		s CleanItmId=Obj.%Get("CleanItmId")
		s PkgId=Obj.%Get("PkgId")
		s Qty=Obj.%Get("Qty")
		s ComposePkgName="物品/器械组合包"
		continue:CleanItmId=""

		s CleanItmObj = ##class(User.CSSDCleanDetailPacks).%OpenId(CleanItmId)
		continue:'$IsObject(CleanItmObj)

		d CleanItmObj.%Reload()
		s CleanId = CleanItmObj.CSSDCDPCleanMain.%Id()
		&sql(Update CSSD_CleanDetailPacks set CSSDCDP_IsCrtLbl=1,CSSDCDP_ComposePkg=:ComposePkgDr,CSSDCDP_ComposePkgName=:ComposePkgName where %id=:CleanItmId)
		i SQLCODE'=0 d RtnObj.Err(-1,"",label_"更新状态失败","",0)
		continue:RtnObj.success<0

		s ComposeId = $o(^User.CSSDCleanPackComposeI("ComposePkgDrLabelIndex",CleanItmId,PkgId,Label,""))
		i ComposeId'="" d
		.&sql(Update CSSD_CleanPackCompose set CSSDCDPC_Qty=:Qty where CSSDCDPC_CleanDetailDR=:CleanItmId and CSSDCDPC_PkgDr=:PkgId and CSSDCDPC_Label=:Label)
		.i SQLCODE'=0 d RtnObj.Err(-1,"",label_"消毒包组合更新失败","",0)
		e  d
		.&sql(INSERT INTO CSSD_CleanPackCompose (CSSDCDPC_CleanDetailDR, CSSDCDPC_Qty, CSSDCDPC_PkgDr, CSSDCDPC_Label) VALUES (:CleanItmId,:Qty,:PkgId,:Label))
		.i SQLCODE'=0 d RtnObj.Err(-1,"",label_"消毒包组合新增失败","",0)
		continue:RtnObj.success<0

		s cnt=""
		s cnt=$o(^User.CSSDCleanDetailPacksI("IndexMainDrIsCrtLbl",CleanId,"0",""))
		i cnt="" d
		.&sql(update CSSD_Clean set cssdc_iscreatelbl=1 where id=:CleanId)
		.i SQLCODE<0 d RtnObj.Err(-32,"","更新数据失败:"_MethodName_"SQLCODE"_SQLCODE_":"_$g(%msg))
		continue:RtnObj.success<0
	}
	q RtnObj.Json()
}

///  Creator:ban
///  CreatDate:2020.12.10
///  Description:取消生成组合包的标签
///  Table:
///  Input:Detail 需要组合的明细包 detailComposeID 组合的标准，以哪个包为主
///  Output:
///  Return:
///  Others：w ##Class(web.CSSDHUI.Pack.ComposePackLabel).CancelComposeOrdLabel("[{""CleanItmId"":""23"",""LocName"":"""",""PkgId"":""33"",""packagedesc"":""口腔门诊专科器械"",""Qty"":""10"",""createdQty"":""0"",""unCreatedQty"":""10"",""IsPrint"":""N"",""ComposeFlag"":"""",""ComposePkgDr"":""""},{""CleanItmId"":""22"",""LocName"":"""",""PkgId"":""34"",""packagedesc"":""口腔门诊钢丝剪"",""Qty"":""2"",""createdQty"":""1"",""unCreatedQty"":""2"",""IsPrint"":""N"",""ComposeFlag"":""Y"",""ComposePkgDr"":""34""},{""CleanItmId"":""21"",""LocName"":"""",""PkgId"":""37"",""packagedesc"":""口腔门诊微创拔牙挺"",""Qty"":""13"",""createdQty"":""0"",""unCreatedQty"":""13"",""IsPrint"":""N"",""ComposeFlag"":"""",""ComposePkgDr"":""""}]","22")
ClassMethod CancelComposeOrdLabel(Detail As %String, detailComposeID As %String) As %String [ SqlProc ]
{
	n (Detail,detailComposeID)
	s $zt =..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Detail)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()

	s (Label,ComposePkgDr)=""
	s ComposeMainId = $o(^User.CSSDCleanPackComposeI("ComposeDetailIndex",detailComposeID,""))
	i ComposeMainId'="" d
	.s ComposeMainObj = ##class(User.CSSDCleanPackCompose).%OpenId(ComposeMainId)
	.d ComposeMainObj.%Reload()
	.s Label = ComposeMainObj.CSSDCDPCLabel
	.s ComposePkgDr=ComposeMainObj.CSSDCDPCPkgDr.%Id()
	e  d RtnObj.Err(-1,"","请先选择设定组合的消毒包!")
	q:RtnObj.success'=0 RtnObj.Json()

 	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""

		s CleanItmId=Obj.%Get("CleanItmId")
		s PkgId=Obj.%Get("PkgId")
		s Qty=Obj.%Get("Qty")
		s ComposePkgName="物品/器械组合包"
		continue:CleanItmId=""

		s CleanItmObj = ##class(User.CSSDCleanDetailPacks).%OpenId(CleanItmId)
		continue:'$IsObject(CleanItmObj)

		&sql(Update CSSD_CleanDetailPacks set CSSDCDP_IsCrtLbl=0,CSSDCDP_ComposePkg=NULL,CSSDCDP_ComposePkgName=NULL where %id=:CleanItmId)
		i SQLCODE'=0 d RtnObj.Err(-1,"",label_"更新状态失败","",0)
		continue:RtnObj.success<0

		i CleanItmId'=detailComposeID d
		.&sql(Delete from CSSD_CleanPackCompose  where CSSDCDPC_CleanDetailDR=:CleanItmId and CSSDCDPC_PkgDr=:PkgId and CSSDCDPC_Label=:Label)
		.i SQLCODE'=0 d RtnObj.Err(-1,"",label_"消毒包组合取消更新失败","",0)
		continue:RtnObj.success<0
	}
	q RtnObj.Json()
}

}
