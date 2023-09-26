Import sqluser

/// wfg
/// wfg 2019-8-16
Class web.CSSDHUI.System.DataInput Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// 界面导入入口
/// w ##class(web.CSSDHUI.System.DataInput).DataInput("[{""消毒包编码"":20239,""消毒包名称"":""妇瘤e科Lep刀包21"",""消毒包别名"":null,""包装材料"":""棉纺物品"",""消毒包分类"":""手术(口腔)"",""消毒包属性"":""标牌追溯包"",""价格"":1000,""单位"":""个"",""规格"":""大"",""灭菌方式"":""高温灭菌(口腔)"",""有效期"":7,""接收科室"":null,""自动生成标牌数"":null,""校验信息"":""√""}]","CSSD_Package","{""BDPHospital"":""3"",""gUserId"":""13922"",""gLocId"":""396"",""gGroupId"":""102"",""gHospId"":""3""}")
/// w ##class(web.CSSDHUI.System.DataInput).InputPackageItem("7@%Library.DynamicObject","166","2")
ClassMethod DataInput(Rows, Type, Params)
{
	n (Rows,Type,Params,%session)
	s $ZT=..sssError()
	
	s cnt=0,success=0,fail=0,Msg=""
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	q:Type="" RtnObj.Err(-1,"","数据类型不能为空!").Json()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Rows)
	q:Sc'=0 RtnObj.Err(-2,"","入参解析失败!").Json()
	
	while(1){
		s Row=PJObj.%Pop()
		q:Row=""
		s cnt=cnt+1
		i Type="CSSD_Package" d
		.s RtnObj=..InputPackage(Row,Params)
		e  i Type="CSSD_Item" d
		.s RtnObj=..InputPackageItem(Row,Params)
		e  i Type="CSSD_PackagePack" d
		.s RtnObj=..InputFaricLabel(Row,Params)
		e  i Type="CSSD_PackageClass" d
		.s RtnObj=..InputPkgClass(Row,Params)
		e  i Type="CSSD_CodeDict" d
		.s RtnObj=..InputPackageCodeDict(Row,Params)

		i RtnObj.success=0 d
		.s success=success+1
		e  d
		.s fail=fail+1
		.s Msg=Msg_"<br>第"_cnt_"行"_RtnObj.msg
	}
	i cnt=success s RtnObj.msg="共"_cnt_"条数据,已全部导入成功!"
	e  s RtnObj.msg="共"_cnt_"条数据,导入成功"_success_"条数据,失败"_fail_"条数据!<br>失败原因:"_Msg
	q RtnObj.Json()
}

/// 导入消毒包数据明细
ClassMethod InputPackageItem(RowObj, Params) As web.CSSDHUI.RtnObj
{
	n (RowObj,Params,%session)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s Obj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=Obj.%FromJSON(Params)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!")
	s gLocId=Obj.%Get("gLocId")
	s gGroupId=Obj.%Get("gGroupId")
	s gUserId=Obj.%Get("gUserId")
	s gHospId=Obj.%Get("gHospId")
	s pHospId=Obj.%Get("BDPHospital")
	s gHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(pHospId,gHospId)
	
	s PkgDesc=RowObj.%Get("消毒包名称")
	s ItmDesc=RowObj.%Get("器械名称")
	s SpecDesc=RowObj.%Get("器械规格")
	s UnitPrice=RowObj.%Get("器械价格")
	s Qty=RowObj.%Get("器械数量")
	s ItemAlias=RowObj.%Get("器械别名")
	s ItemRemarks=RowObj.%Get("备注")
	s OneOffFlag=RowObj.%Get("一次性标志")
	
	s PkgId=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Desc",PkgDesc,"CSSD_Package",gHospId)
	i PkgId="" q RtnObj.Err(-2,"","消毒包"_PkgDesc_"不存在！")
	
	s ItmId=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Desc",ItmDesc,"CSSD_Item",gHospId,"",SpecDesc,gLocId)
	i ItmId'="" d
	.s PkgItmRelationId=PkgId_"||"_ItmId
	.s PkgItmId=$o(^User.CSSDPackageItemI("CSSDPIRowidIndex",PkgItmRelationId,""))
	.i PkgItmId'="" d RtnObj.Err(-6,"",PkgDesc_" 消毒包绑定的 "_ItmDesc_" 明细存在重复！")
	q:RowObj.success<0 RtnObj
	
	s:UnitPrice="" UnitPrice=0
	s:Qty="" Qty=1
	
	ts
	i ItmId="" d
	.i ItemAlias="" d
	..s ItemAlias=##class(web.CSSDHUI.Common.UtilCommon).GetCNCODE(ItmDesc,4,"")
	.&sql(insert into CSSD_Item
		(CSSDI_Desc, CSSDI_Spec, CSSDI_Price,CSSDI_UseFlag,
		CSSDI_CreateLocDr,CSSDI_Alias,CSSDI_Remarks,CSSDI_OneOffFlag)
		values (:ItmDesc,:SpecDesc,:UnitPrice,'Y',
		:gLocId,:ItemAlias,:ItemRemarks,:OneOffFlag))
	.i SQLCODE'=0 d
	..d RtnObj.Err(-4,"","插入器械报错！"_SQLCODE)
	.e  d
	..s ItmId=%ROWID
	..s ret=##class(web.CSSDHUI.HospMap).SaveHOSP("CSSD_Item",ItmId,gHospId)
	..i ret'=0 d RtnObj.Err(-5,"","器械明细关联院区失败!")
	i RtnObj.success<0 tro  q RtnObj
	
	s maxSerialNo=..MaxSerialNo(PkgId)
	s PkgItmId=PkgId_"||"_ItmId
	&sql(INSERT INTO cssd_packageitem 
		(CSSDPI_Itm_DR, CSSDPI_Package_DR,CSSDPI_Qty, CSSDPI_Rowid,CSSDPI_SORT) 
		VALUES (:ItmId,:PkgId,:Qty,:PkgItmId,:maxSerialNo))
	i SQLCODE'=0 tro  q RtnObj.Err(-7,"","插入消毒包和器械关系表错误!"_SQLCODE)
	
	tc
	q RtnObj
}

/// Creator:ban
/// CreatDate:2019.12.30
/// Description:获取当前dr中明细最大序号
/// Table:CSSD_PackageItem
/// Input:packagedr 消毒包dr
/// Output:
/// Return:maxSerialNo
/// w ##Class(web.CSSDHUI.System.DataInput).MaxSerialNo("1018")
ClassMethod MaxSerialNo(PkgId) As %String
{
	n (PkgId,%session)
	s maxSerialNo = 0
	&sql(SELECT max(CSSDPI_SORT)+1 into :maxSerialNo FROM CSSD_PackageItem
		WHERE CSSDPI_Package_DR = :PkgId)
	i ((maxSerialNo=0)||(maxSerialNo="")) d
	.s maxSerialNo=1
	q maxSerialNo
}

ClassMethod InputPackage(RowObj, Params) As web.CSSDHUI.RtnObj
{
	n (RowObj,Params,%session)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s Obj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=Obj.%FromJSON(Params)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!")
	s gLocId=Obj.%Get("gLocId")
	s gGroupId=Obj.%Get("gGroupId")
	s gUserId=Obj.%Get("gUserId")
	s gHospId=Obj.%Get("gHospId")
	s pHospId=Obj.%Get("BDPHospital")
	s gHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(pHospId,gHospId)
	
	s PkgCode=RowObj.%Get("消毒包编码")
	s PkgDesc=RowObj.%Get("消毒包名称")
	s PkgAlias=RowObj.%Get("消毒包别名")
	s PkgClassDesc=RowObj.%Get("消毒包分类")
	s AttributeDesc=RowObj.%Get("消毒包属性")
	s UnitPrice=RowObj.%Get("价格")
	s UomDesc=RowObj.%Get("单位")
	s Spec=RowObj.%Get("规格")
	s RecLocDesc=RowObj.%Get("接收科室")
	s SterTypeDesc=RowObj.%Get("灭菌方式")
	s MaterialDesc=RowObj.%Get("包装材料")
	s ValPeriod=RowObj.%Get("有效期")
	s BaseQty=RowObj.%Get("自动生成标牌数")
	s IsExt=RowObj.%Get("外来器械标志")
	i IsExt="" s IsExt="N"
	s AppParam=gGroupId_"^"_gLocId_"^"_gUserId_"^"_gHospId
	
	s PkgCodeId=$o(^User.CSSDPackageI("CSSDPackageCodeIndex",PkgCode,""))
	i PkgCodeId'="" q RtnObj.Err(-2,"","消毒包编码"_PkgCode_"重复！")
	
	s PkgDescId=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Desc",PkgDesc,"CSSD_Package",gHospId)
	i PkgDescId'="" q RtnObj.Err(-3,"","消毒包名称"_PkgDesc_"重复！")
	
	s PkgClassId=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Desc",PkgClassDesc,"CSSD_PackageClass",gHospId)
	i PkgClassId="" q RtnObj.Err(-4,"","消毒包分类未维护"_PkgClassDesc)
	
	s AttributeId=##Class(web.CSSDHUI.Common.PackageInfoCommon).getPackageDetailDr(AttributeDesc)
	i +AttributeId=0 q RtnObj.Err(-5,"","消毒包属性错误"_AttributeDesc)
	
	i ((IsExt="Y")&&(AttributeId'="1")) q RtnObj.Err(-6,"",PkgDesc_":为外来器械包，包属性必须为标牌追溯包!")
	
	s SterTypeId=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Desc",SterTypeDesc,"CSSD_SterType",gHospId)
	i SterTypeId="" q RtnObj.Err(-7,"","灭菌方式"_SterTypeDesc_",未维护！")
	
	s MaterialId=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Desc",MaterialDesc,"CSSD_Material",gHospId)
	i MaterialId="" q RtnObj.Err(-8,"","包装材料"_MaterialDesc_"未维护！")
	
	&sql(SELECT CTUOM_RowId INTO :UomId FROM CT_UOM WHERE CTUOM_Desc=:UomDesc)
	i SQLCODE'=0 q RtnObj.Err(-9,"","消毒包单位"_UomDesc_"未找到对应关系!")
	s InitUom=##Class(web.CSSDHUI.Common.AppCommon).GetParamValue("CSSDPACKAGE","Uom",AppParam)
	i InitUom'[UomDesc q RtnObj.Err(-10,"","消毒包单位"_UomDesc_"未在参数设置里配置！")
	
	s SpecId=""
	i Spec'="" d
	.s SpecId=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Desc",Spec,"CT_STER_CSSD.PackageSpec",gHospId)
	.i SpecId="" d RtnObj.Err(-11,"","规格"_Spec_"未维护！")
	q:RtnObj.success<0 RtnObj
	
	s RecLocId=""
	i RecLocDesc'="" d
	.&sql(SELECT CTLOC_RowID INTO :RecLocId FROM CT_Loc WHERE CTLOC_Desc=:RecLocDesc)
	.i RecLocId="" d
	..d RtnObj.Err(-12,"","填写的科室未找到对应关系!")
	.e  d
	..s HospId=..sssHospId(RecLocId)
	..i HospId'=gHospId d RtnObj.Err(-7,"",RecLocDesc_"非当前院区科室!")
	q:RtnObj.success<0 RtnObj
	
	s MaterialObj=##Class(User.CSSDMaterial).%OpenId(MaterialId)
	i ValPeriod="" s ValPeriod=MaterialObj.CSSDMExpLength
	s IsUseFlag=MaterialObj.CSSDMIsUsed
	i IsUseFlag="N" q RtnObj.Err(-14,"",MaterialDesc_"该包装材料未启用!")
	
	i PkgAlias="" s PkgAlias=##class(web.CSSDHUI.Common.UtilCommon).GetCNCODE(PkgDesc,4,"")
	s:UnitPrice="" UnitPrice=0
	
	ts
	&sql(INSERT INTO cssd_package
		(CSSDP_Code,CSSDP_Desc,CSSDP_Alias,CSSDP_Hospital,CSSDP_LOCDR,CSSDP_NotUseFlag,
		CSSDP_PackClassdr,CSSDP_PackTypeDetail,CSSDP_Volumn,CSSDP_WorkTimes,CSSDP_WorkCost,
		CSSDP_SterType,CSSDP_UOM_DR,CSSDP_CreateLocDr,CSSDP_UnitPrice,CSSDP_SpecDr,CSSDP_IsExt) 
		VALUES (:PkgCode,:PkgDesc,:PkgAlias,:gHospId,:RecLocId,'Y',
		:PkgClassId,:AttributeId,0,0,0,:SterTypeId,:UomId,:gLocId,:UnitPrice,:SpecId,:IsExt))
	i SQLCODE'=0 d
	.d RtnObj.Err(-15,"","插入消毒包数据错误:"_SQLCODE)
	e  d
	.s PkgId=%ROWID
	.s ret=##class(web.CSSDHUI.HospMap).SaveHOSP("CSSD_Package",PkgId,gHospId)
	.i ret'=0 d RtnObj.Err(-16,"","消毒包维护关联院区失败!")
	i RtnObj.success<0 tro  q RtnObj
	
	&sql(insert CSSD_Expire(CSSDEX_Length, CSSDEX_Package_DR,
		CSSDEX_Material_DR,CSSDEx_IsDefault,CSSDEX_Price) 
		values (:ValPeriod,:PkgId,:MaterialId,"Y",:UnitPrice))
	i SQLCODE'=0 tro  d RtnObj.Err(-17,"","插入有效期错误:"_SQLCODE) q
	
	// 生成固定标签判断生成规则
	s IsSameCode=##Class(web.CSSDHUI.Common.AppCommon).GetParamValue("CSSDPACKAGE","IsCodeSame",AppParam)
	i (+BaseQty'=0)&&(AttributeId=1) d
	.s Data=PkgId_"^"_gHospId_"^"_BaseQty_"^"_gLocId
	.s Title="PkgDesc^gHospId^Qty^gLocId"
	.s PkgInfo=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	.i IsSameCode="N" d
	..s RtnObj=##class(web.CSSDHUI.PackageInfo.CodeDict).CreateCodeDict(PkgInfo,Params)
	.e  i IsSameCode="Y" d 
	..s RtnObj=##class(web.CSSDHUI.PackageInfo.CodeDict).CreateOldCodeDict(PkgInfo,Params)
	
	i RtnObj.success<0 tro  q RtnObj
	
	tc
	q RtnObj
}

/// 导入消毒包标牌数据
ClassMethod InputPackageCodeDict(RowObj, Params) As web.CSSDHUI.RtnObj
{
	n (RowObj,Params,%session)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New() 
	s Obj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=Obj.%FromJSON(Params)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!")
	s gLocId=Obj.%Get("gLocId")
	s gGroupId=Obj.%Get("gGroupId")
	s gUserId=Obj.%Get("gUserId")
	s gHospId=Obj.%Get("gHospId")
	s pHospId=Obj.%Get("BDPHospital")
	s gHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(pHospId,gHospId)
	
	s CodeDict=RowObj.%Get("标牌编码")
	s CodeDictDesc=RowObj.%Get("标牌名称")
	s PkgDesc=RowObj.%Get("消毒包名称")
	
	s CodeDictDescId=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Desc",CodeDictDesc,"CSSD_CodeDict",gHospId)
	i CodeDictDescId'="" q RtnObj.Err(-2,"","标牌名称"_CodeDictDesc_"重复！")
	
	s CodeDictId=$o(^User.CSSDCodeDictI("CSSDCDCodeIndex",CodeDict,""))
	i CodeDictId'="" q RtnObj.Err(-3,"","标牌"_CodeDict_"重复！")
	
	s PkgId=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Desc",PkgDesc,"CSSD_Package",gHospId)
	i PkgId="" q RtnObj.Err(-4,"","没找到相应的消毒包"_PkgDesc)
	
	s AttributeId=$lg(^User.CSSDPackageD(PkgId),15)
	s PkgLocId=$lg(^User.CSSDPackageD(PkgId),18)
	i AttributeId'=(1||3||6) q RtnObj.Err(-5,"","只有标牌追溯包/清洗架/灭菌架能生成标牌!"_PkgDesc)
	
	ts
	&sql(INSERT INTO CSSD_CodeDict
		(CSSDCD_Code,CSSDCD_CycleCount,CSSDCD_PackDR,CSSDCD_PackTypeDetail,
		CSSDCD_CreateLocDr,CSSDCD_PackName,CSSDCD_Hospital,CSSDCD_OPRLocID) 
		VALUES (:CodeDict,0,:PkgId,:AttributeId,
		:gLocId,:CodeDictDesc,:gHospId,:PkgLocId))
	i SQLCODE'=0 d
	.d RtnObj.Err(-6,"","插入标牌表数据错误"_SQLCODE)
	e  d
	.s CodeDictId=%ROWID
	.s ret=##class(web.CSSDHUI.HospMap).SaveHOSP("CSSD_CodeDict",CodeDictId,gHospId)
	.i ret'=0 d RtnObj.Err(-7,"","关联院区失败!")
	i RtnObj.success<0 tro  q RtnObj
	tc
	
	q RtnObj
}

/// d ##class(web.CSSDHUI.System.DataInput).InputPkgClass("7@%Library.DynamicObject","{""gUserId"":""13922"",""gLocId"":""396"",""gGroupId"":""102"",""gHospId"":""3""}")
ClassMethod InputPkgClass(RowObj, Params) As web.CSSDHUI.RtnObj
{
	n (RowObj,Params,%session)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PkgClassCode=RowObj.%Get("代码")
	s PkgClassDesc=RowObj.%Get("描述")
	s ClassData=""_"^"_PkgClassCode_"^"_PkgClassDesc_"^"_"Y"
	s ClassTitle="RowId^PkgClassCode^PkgClassDesc^NotUseFlag"
	s ClassStr=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(ClassData,ClassTitle)
	s ClassStr="["_ClassStr_"]"
	ts
	s RtnObj=##class(web.CSSDHUI.PackageInfo.PackageClass).Save(ClassStr,Params)
	i RtnObj.success'=0 tro  q RtnObj
	tc
	
	q RtnObj
}

/// 非循环包标签导入
ClassMethod InputFaricLabel(RowObj, Params) As web.CSSDHUI.RtnObj
{
	n (RowObj,Params,%session)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s Obj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=Obj.%FromJSON(Params)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!")
	s gLocId=Obj.%Get("gLocId")
	s gGroupId=Obj.%Get("gGroupId")
	s gUserId=Obj.%Get("gUserId")
	s gHospId=Obj.%Get("gHospId")
	s pHospId=Obj.%Get("BDPHospital")
	s gHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(pHospId,gHospId)
	
	s PkgDesc=RowObj.%Get("消毒包名称")
	s Label=RowObj.%Get("非循环包标签")
	s ExpDate=RowObj.%Get("失效日期")
	s RecLocDesc=RowObj.%Get("接收科室")
	
	s PkgId=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Desc",PkgDesc,"CSSD_Package",gHospId)
	i PkgId="" d
	.d RtnObj.Err(-2,"","没找到相应的消毒包"_PkgDesc)
	e  d
	.s PkgObj=##Class(User.CSSDPackage).%OpenId(PkgId)
	.d PkgObj.%Reload()
	.s AttributeId=PkgObj.CSSDPPackTypeDetail
	.i AttributeId'=7 d RtnObj.Err(-3,"",PkgDesc_"不是非循环包!")
	q:RtnObj.success<0 RtnObj
	
	s TransId=$o(^User.CSSDTransI("CSSDTLabel",Label,""))
	i TransId'="" q RtnObj.Err(-4,"","标签重复!"_Label)
	
	s ExpDate=..DH2L(ExpDate)
	i ExpDate'>+$h q RtnObj.Err(-5,"",PkgDesc_"失效日期不能早于或等于当天!")
	
	&sql(SELECT CTLOC_RowID INTO :RecLocId FROM CT_Loc WHERE CTLOC_Desc=:RecLocDesc)
	i RecLocId="" d
	.d RtnObj.Err(-6,"",RecLocDesc_"未找到对应关系!")
	e  d
	.s HospId=..sssHospId(RecLocId)
	.i HospId'=gHospId d RtnObj.Err(-7,"",RecLocDesc_"非当前院区科室!")
	q:RtnObj.success<0 RtnObj
	
	s MaterialId=##class(web.CSSDHUI.Common.PackageInfoCommon).GetDefaultMaterial(PkgId)
	i MaterialId="" q RtnObj.Err(-8,"",PkgDesc_"消毒包未设置默认包装材料!")
	
	s ChkUserId=gUserId,AckUserId=gUserId,PackUserId=gUserId
	s PackDate=+$h
	s PackTime=$p($h,",",2)
	s SerialNo=##class(web.CSSDHUI.Common.AppCommon).CreatePackSerialNo()
	
	ts
	&sql(Insert into CSSD_PackagePack
		(CSSDPP_Label,CSSDPP_Package_DR,CSSDPP_Loc_DR,CSSDPP_Date,CSSDPP_Time,
		CSSDPP_Qty,CSSDPP_User_DR,CSSDPP_AckUser_DR,CSSDPP_AckDate,CSSDPP_SerialNo,
		CSSDPP_ApplyLoc,CSSDPP_PackUser_DR,CSSDPP_Material_DR,CSSDPP_IsLoadSteCar,CSSDPP_PrtTimes)
		Values
		(:Label,:PkgId,:gLocId,:PackDate,:PackTime,
		1,:ChkUserId,:AckUserId,:PackDate,:SerialNo,
		:RecLocId,:PackUserId,:MaterialId,0,0)
	)
	i SQLCODE'=0 tro  q RtnObj.Err(-10,"","插入数据失败SQLCODE:"_SQLCODE_","_$g(%msg))
	s PackId=%ROWID
	
	&sql(Insert into CSSD_Trans
		(CSSDT_Label,CSSDT_Pack_DR,CSSDT_Package_DR,CSSDT_Date,CSSDT_Time,
		CSSDT_ExpDate,cssdt_Status)
		Values
		(:Label,:PackId,:PkgId,:PackDate,:PackTime,
		:ExpDate,'P')
	)
	i SQLCODE'=0 tro  q RtnObj.Err(-11,"","插入数据失败SQLCODE:"_SQLCODE_","_$g(%msg))

	tc
	q RtnObj
}

}
