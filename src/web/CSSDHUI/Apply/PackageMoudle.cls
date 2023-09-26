Import sqluser

/// Creator:ban
/// CreatDate:2020.09.19
/// Description:模板制单类
/// Table:CSSD_Moudle
Class web.CSSDHUI.Apply.PackageMoudle Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Creator:zn
/// CreatDate:2020.6.01
/// Description:设置申请模板(将回收申请单内容复制到模板)
/// Table:CSSD_Moudle
/// w ##class(web.CSSDHUI.Apply.PackageMoudle).jsMoudleSave(20)
ClassMethod jsMoudleSave(MainId As %String) As %Library.String
{
	n (%session,MainId)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i MainId="" d RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"请领单据还没保存!"),"",0)
	q:RtnObj.success'=0 RtnObj.Json()
	
	s MainObj=##Class(User.CSSDPackageApply).%OpenId(MainId) 
	i '$IsObject(MainObj) d RtnObj.Err(-2,"",..%Translate($CLASSNAME(),"入参错误!"),"",0)
	q:RtnObj.success'=0 RtnObj.Json()
	
	d MainObj.%Reload()
	s applyLocDr = MainObj.CSSDPAAPPLYLOCDRGetObjectId()
	s Applyer = MainObj.CSSDPAAPPLYUSERDRGetObjectId()
	s type = MainObj.CSSDPAType
	s level = MainObj.CSSDPAReqLevel
	s LocDr = MainObj.CSSDPALOCDRGetObjectId()
	
	i applyLocDr="" d RtnObj.Err(-2,"",..%Translate($CLASSNAME(),"申请科室不能为空!"),"",0)
	q:RtnObj.success'=0 RtnObj.Json()
	
	s applyDetailId=$o(^User.CSSDPackageApplyDetailI("CSSDPADParrefIndex",MainId,""))
	i applyDetailId="" d RtnObj.Err(-3,"",..%Translate($CLASSNAME(),"请领单据没有明细"),"",0)
	q:RtnObj.success'=0 RtnObj.Json()
	
	s tmpid=""
	&sql(SELECT CSSDM_Rowid into :tmpid FROM CSSD_Moudle where CSSDM_PkgApplyDr =:MainId)
	i tmpid'="" d RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"该申请单已设置模板!"))
	q:RtnObj.success'=0 RtnObj.Json()
	
	s (countMoudle,moudleCode,moudleName)=""
	&sql(SELECT count(*) into :countMoudle FROM CSSD_Moudle where CSSDM_APPLYLOCDR =:applyLocDr)
	i countMoudle'="" d
	.s countMoudle=countMoudle+1
	.s moudleCode="M-"_applyLocDr_"-"_countMoudle
	.s moudleName=..%Translate($CLASSNAME(),"模板")_countMoudle
	
	ts
	&sql(INSERT INTO CSSD_Moudle
		(CSSDM_Code,CSSDM_Name,CSSDM_APPLYLOCDR,CSSDM_APPLYUSERDR,CSSDM_ReqLevel,
		CSSDM_Type,CSSDM_LOCDR,CSSDM_PkgApplyDr)
		VALUES
		(:moudleCode, :moudleName,:applyLocDr,:Applyer,:level,
		:type,:LocDr,:MainId)
	)
	i SQLCODE'=0 tro  d RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"设置模板失败!"))
	q:RtnObj.success'=0 RtnObj.Json()
	
	s rowid=%ROWID
	s RtnObj=..MoudleDetailSave(rowid,MainId)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	
	tc
	q RtnObj.Json()
}

/// Creator:zn
/// CreatDate:2020.6.01
/// Description:设置申请模板明细  
/// Table:CSSD_MoudleDetail
/// w ##class(web.CSSDHUI.Apply.PackageMoudle).MoudleDetailSave(^tmp("1"),^tmp("2"))
ClassMethod MoudleDetailSave(rowid As %String, MainId As %String) As web.CSSDHUI.RtnObj
{
	n (%session,rowid,MainId)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s Count=0
	s ApplyDetail=""
	f  s ApplyDetail=$o(^User.CSSDPackageApplyDetailI("CSSDPADParrefIndex",MainId,ApplyDetail)) q:ApplyDetail=""  d
	.s ApplyDetailObj=##Class(User.CSSDPackageApplyDetail).%OpenId(ApplyDetail)
	.q:'$IsObject(ApplyDetailObj)
	.d ApplyDetailObj.%Reload()
	.s ReqQty=ApplyDetailObj.CSSDPADReqQty
	.s PkgDr = ApplyDetailObj.CSSDPADPackageDr.%Id()
	.s Price = ApplyDetailObj.CSSDPADPrice
	.s Remark = ApplyDetailObj.CSSDPADDesc
	.s MaterialDr=ApplyDetailObj.CSSDPADMaterialDRGetObjectId()
	.s AttributeCode=ApplyDetailObj.CSSDPADPackageDr.CSSDPPackTypeDetail
	.q:AttributeCode=1
	.s Count=Count+1
	.&sql(INSERT INTO CSSD_MoudleDetail (CSSDMD_Parref,CSSDMD_Package,CSSDMD_Qty,CSSDMD_Price,CSSDMD_Remark,CSSDMD_Material_DR) VALUES (:rowid,:PkgDr,:ReqQty,:Price,:Remark,:MaterialDr))
	.i SQLCODE'=0 d RtnObj.Err(-2,"",..%Translate($CLASSNAME(),"设置模板明细信息失败!"))
	.q:RtnObj.success'=0
	q:RtnObj.success<0 RtnObj
	
	i Count=0 q RtnObj.Err(-1,"","该单据没有可设置模板的明细!","",0)
	
	q RtnObj
}

/// Creator:ban
/// CreatDate:2020.6.19
/// Description:获取申请模板主单据  
/// Table:CSSD_Moudle
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Apply.PackageMoudle","SelectMoudle","{""ReqLocId"":""1"",""RowId"":""11"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2""}")
Query SelectMoudle(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,MoudleCode,MoudleName,ApplyLocDr,ReqLocDesc,SupRowId,SupLocDesc,ApplyName,ReqLevel,ReqLevelDesc,ReqType,ReqTypeDesc") [ SqlProc ]
{
}

ClassMethod SelectMoudleExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,%session,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 $$$OK
	s PRowId=PJObj.%Get("RowId")
	s gLocId=PJObj.%Get("gLocId")
	s PReqLocId=PJObj.%Get("ReqLocId")
	s:PReqLocId="" PReqLocId=gLocId
	
	s Result=##class(%Library.ResultSet).%New()	
	s SqlStr="SELECT CSSDM_Rowid, CSSDM_Code, CSSDM_Name, CSSDM_APPLYLOCDR, CSSDM_LOCDR, CSSDM_APPLYUSERDR->SSUSR_Name as ApplyName,"
			_" CSSDM_ReqLevel, CSSDM_Type FROM CSSD_Moudle where 1=1 "
	i PRowId'="" d
	.s SqlStr=SqlStr_" and %id in ("_PRowId_")"
	e  i PReqLocId'="" d
	.s SqlStr=SqlStr_" and CSSDM_APPLYLOCDR="_PReqLocId
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("CSSDM_Rowid")
		s MoudleCode = Result.Data("CSSDM_Code")
		s MoudleName = Result.Data("CSSDM_Name")
		s ApplyLocDr=Result.Data("CSSDM_APPLYLOCDR")
		s SupRowId=Result.Data("CSSDM_LOCDR")
		s ApplyName=Result.Data("ApplyName")
		s ReqLevel=Result.Data("CSSDM_ReqLevel")
		s ReqType=Result.Data("CSSDM_Type")
		continue:ApplyLocDr=""
		continue:SupRowId=""
		
		s ReqLocDesc=..sssLocDesc(ApplyLocDr)
		s SupLocDesc=..sssLocDesc(SupRowId)
		s ReqTypeDesc=##class(web.CSSDHUI.Common.PackageInfoCommon).getReqTypeDesc(ReqType)
		s ReqLevelDesc=##class(web.CSSDHUI.Common.PackageInfoCommon).getReqLevelDesc(ReqLevel)
		d OutPutRowMoudle
	}
	d Result.Close()
	Quit $$$OK
OutPutRowMoudle
	s Data=$lb(RowId,MoudleCode,MoudleName,ApplyLocDr,ReqLocDesc,SupRowId,
		SupLocDesc,ApplyName,ReqLevel,ReqLevelDesc,ReqType,ReqTypeDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creator:ban
/// CreatDate:2020.6.19
/// Description:设置申请模板明细
/// Table:CSSD_MoudleDetail
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Apply.PackageMoudle","SelectMoudleDetail","27")
Query SelectMoudleDetail(MoudleId As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,Parref,PackageDR,PackageName,Qty,Remark,MaterialId,MaterialDesc") [ SqlProc ]
{
}

ClassMethod SelectMoudleDetailExecute(ByRef qHandle As %Binary, MoudleId As %String) As %Status
{
	n (qHandle,%session,MoudleId)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:MoudleId="" $$$OK
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="SELECT CSSDMD_Rowid, CSSDMD_Parref, CSSDMD_Package, CSSDMD_Package->CSSDP_Desc PackageName,"
			_" CSSDMD_Qty,CSSDMD_Remark,CSSDMD_Material_DR,CSSDMD_Material_DR->CSSDM_Desc as  MaterialDesc"
			_" FROM CSSD_MoudleDetail where CSSDMD_Parref = "_MoudleId
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("CSSDMD_Rowid")
		s Parref = Result.Data("CSSDMD_Parref")
		s PackageDR = Result.Data("CSSDMD_Package")
		s PackageName=Result.Data("PackageName")
		s Qty = Result.Data("CSSDMD_Qty")
		s Remark = Result.Data("CSSDMD_Remark")
		s MaterialId=Result.Data("CSSDMD_Material_DR")
		s MaterialDesc= Result.Data("MaterialDesc")
		continue:PackageDR=""
		s PackageName=..%FieldTranslate("User.CSSDPackage","CSSDPDesc",PackageName)
		s MaterialDesc=..%FieldTranslate("User.CSSDMaterial","CSSDMDesc",MaterialDesc)
		d OutPutRowMoudleDetail
	}
	d Result.Close()
	Quit $$$OK
OutPutRowMoudleDetail
	s Data=$lb(RowId,Parref,PackageDR,PackageName,Qty,Remark,MaterialId,MaterialDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creator:zn
/// CreatDate:2020.06.02
/// Description:根据申请模板制作申请单
/// Table:User.CSSDMoudleDetail 
/// w ##class(web.CSSDHUI.Apply.PackageMoudle).jsPackageApplyByMoudle("17","15","{""gUserId"":""11889"",""gLocId"":""144"",""gGroupId"":""337"",""gHospId"":""2""}")
ClassMethod jsPackageApplyByMoudle(DetailRows, MainId, Params) As %Library.String
{
	n (%session,DetailRows,MainId,Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s RtnObj=..PackageApplyByMoudle(DetailRows,MainId,Params)
	q RtnObj.Json()
}

ClassMethod PackageApplyByMoudle(DetailRows, MainId, Params) As web.CSSDHUI.RtnObj
{
	n (%session,DetailRows,MainId,Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i MainId="" q RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"入参不能为空!"))
	i DetailRows="" q RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"模板没有明细"))
	
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"参数有误!"))
	s gUserId=PJObj.%Get("gUserId")
	
	s MoudleObj=##class(User.CSSDMoudle).%OpenId(MainId)
	i MoudleObj="" d RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"参数有误,请刷新核实!"),"",0)
	q:RtnObj.success'=0 RtnObj
	
	s ReqLoc=MoudleObj.CSSDMAPPLYLOCDRGetObjectId()
	s reqlevel=MoudleObj.CSSDMReqLevel
	s type=MoudleObj.CSSDMType
	s Loc = MoudleObj.CSSDMLOCDRGetObjectId()
	
	s ItemData=""
	s ItemLen=$L(DetailRows,",")
	f k=1:1:ItemLen d
	.s Row=$p(DetailRows,",",k)
	.s MoudleRowId=$p(Row,"^",1)
	.s MoudleDetailObj=##class(User.CSSDMoudleDetail).%OpenId(MoudleRowId)
	.d MoudleDetailObj.%Reload()
	.s PackageDR=MoudleDetailObj.CSSDMDPackage.%Id()
	.s Remark=MoudleDetailObj.CSSDMDRemark
	.s MaterialId=MoudleDetailObj.CSSDMDMaterialDRGetObjectId()
	.s Qty=MoudleDetailObj.CSSDMDQty					;请领数量
	.s RowId=""
	.s Data=RowId_"^"_PackageDR_"^"_Qty_"^"_MaterialId_"^"_Remark
	.s Title="RowId^PackageDR^ReqQty^MaterialId^Remark"
	.s DataStr=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	.
	.i ItemData="" s ItemData=DataStr
	.e  s ItemData=ItemData_","_DataStr
	
	s ItemData="["_ItemData_"]"
	i ItemData="[]" d RtnObj.Err(-2,"",..%Translate($CLASSNAME(),"模板明细为空"))
	q:RtnObj.success'=0 RtnObj
	
	s MainData=ReqLoc_"^"_gUserId
	s MainTitleStr="FromLoc^CreateUser"
	s MainParames=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(MainData,MainTitleStr)
	
	s usedate=""
	s DetailData=ReqLoc_"^"_reqlevel_"^"_usedate_"^"_Loc_"^"_type
	s DetailTitleStr="LocRowId^ReqLevel^ReqDate^SupRowId^ReqType"
	s DetailParames=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(DetailData,DetailTitleStr)
	s DetailParames="["_DetailParames_"]"
	
	ts
	s MainRtnObj=##class(web.CSSDHUI.Apply.PackageApply).Save(DetailParames,MainParames)
	i MainRtnObj.success'=0 tro  q RtnObj.Err(-4,"",..%Translate($CLASSNAME(),"插入请领主表失败"))
	s ItemRtnObj=##class(web.CSSDHUI.Apply.PackageApplyItm).Save(MainRtnObj.rowid,ItemData)
	i ItemRtnObj.success'=0 tro  q RtnObj.Err(-4,"",..%Translate($CLASSNAME(),"插入请领明细表失败:")_ItemRtnObj.msg)
	tc
	
	s RtnObj.rowid=MainRtnObj.rowid
	q RtnObj
}

/// Creator:ban
/// CreatDate:2020.6.19
/// Description:保存模板单明细
/// Table:CSSD_MoudleDetail
/// d ##class(web.CSSDHUI.Apply.PackageMoudle).jsSave("7","[{""RowId"":""7"",""Parref"":""7"",""PackageDR"":""331"",""PackageName"":""探针"",""Qty"":""5"",""Remark"":""""}]")
ClassMethod jsSave(Parref, Params) As %Library.String
{
	n (%session,Parref,Params)
	s $ZT = ..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i ((Parref="")||(Params="")) d RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"入参不能为空!"),"",0)
	q:RtnObj.success'=0 RtnObj.Json()
	
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-2,"",..%Translate($CLASSNAME(),"入参解析失败!"),"",0)
	q:RtnObj.success'=0 RtnObj.Json()
	s MoudleObj=##class(User.CSSDMoudle).%OpenId(Parref)
	i MoudleObj="" d RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"参数有误,请刷新核实!"),"",0)
	q:RtnObj.success'=0 RtnObj.Json()
	
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		
		s RowId=Obj.%Get("RowId")
		s PackageDR=Obj.%Get("PackageDR")
		s RowParref=Obj.%Get("Parref")
		s Qty=Obj.%Get("Qty")
		s Remark=Obj.%Get("Remark")
		s MaterialId=Obj.%Get("MaterialId")
		
		i MaterialId="" d
		.s MaterialId=##class(web.CSSDHUI.Common.PackageInfoCommon).GetDefaultMaterial(PackageDR) 
		.i MaterialId="" d RtnObj.Err(-3,"",..%Translate($CLASSNAME(),"包装材料名称不能为空!"),"",0)
		q:RtnObj.success'=0
		
		i RowId="" d
		.s itmobj=##class(User.CSSDMoudleDetail).%New()
		e  d
		.s itmobj=##class(User.CSSDMoudleDetail).%OpenId(RowId)
		s itmobj.CSSDMDParref=##class(User.CSSDMoudle).%OpenId(Parref)
		s itmobj.CSSDMDPackage=##class(User.CSSDPackage).%OpenId(PackageDR)
		s itmobj.CSSDMDQty=Qty
		s itmobj.CSSDMDRemark=Remark
		s itmobj.CSSDMDMaterialDR=##class(User.CSSDMaterial).%OpenId(MaterialId)
		s Sc=itmobj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-5,"",$ClassName()_"jsSave:"_..%Translate($CLASSNAME(),"模板明细保存失败!"))
		q:RtnObj.success'=0
	}
	i RtnObj.success<0 tro  q RtnObj.Json()
	
	tc
	q RtnObj.Json()
}

/// Creator:ban
/// CreatDate:2020.6.19
/// Description:删除模板单明细数据
/// d ##class(web.CSSDHUI.Apply.PackageMoudle).jsDelete("[{""RowId"":""11"",""Parref"":""7"",""PackageDR"":""329"",""PackageName"":""尿道探条(临床)"",""Qty"":""12"",""Remark"":""""}]")
ClassMethod jsDelete(Params As %String) As %Library.String
{
	n (%session,Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	
	ts
	s RtnObj=..Delete(Params)
	i RtnObj.success<0 tro  q RtnObj.Json()
	
	tc
	q RtnObj.Json()
}

/// Creator:ban
/// CreatDate:2020.6.19
/// Description:删除模板单明细数据
/// Table:CSSD_MoudleDetail
ClassMethod Delete(Params As %String) As web.CSSDHUI.RtnObj
{
	n (%session,Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s sc=PJObj.%FromJSON(Params)
	i sc'=0 q RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"入参解析失败!"))
	
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		
		s RowId=Obj.%Get("RowId")
		&sql(Delete From CSSD_MoudleDetail WHERE CSSDMD_Rowid=:RowId)
		i SQLCODE<0 d RtnObj.Err(-2,"",$ClassName()_".Delete:SQLCODE"_SQLCODE_":"_$g(%msg))
		continue:RtnObj.success'=0
	}
	q RtnObj
}

/// Creator:ban
/// CreatDate:2020.8.08
/// Description:保存模板
/// Table:CSSD_MoudleDetail
/// d ##class(web.CSSDHUI.Apply.PackageMoudle).jsSaveMoudleMain("7","[{""RowId"":""7"",""Parref"":""7"",""PackageDR"":""331"",""PackageName"":""探针"",""Qty"":""5"",""Remark"":""""}]")
ClassMethod jsSaveMoudleMain(Params) As %Library.String
{
	n (%session,Params)
	s $ZT = ..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s RtnObj=..SaveMoudleMain(Params)
	q RtnObj.Json()
}

ClassMethod SaveMoudleMain(Params) As web.CSSDHUI.RtnObj
{
	n (%session,Params)
	s $ZT = ..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i Params="" q RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"入参不能为空!"))
	
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-2,"",..%Translate($CLASSNAME(),"入参解析失败!"))
	
	s RowIdStr=""
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		
		s RowId=Obj.%Get("RowId")
		s MoudleName=Obj.%Get("MoudleName")
		s ApplyLocDr=Obj.%Get("ApplyLocDr")
		s SupRowId=Obj.%Get("SupRowId")
		s type=Obj.%Get("ReqType")
		s reqlevel=Obj.%Get("ReqLevel")
		
		s MoudleCode=##class(web.CSSDHUI.Common.UtilCommon).GetCNCODE(MoudleName,4,"")
		i reqlevel="" s reqlevel=0
		i type="" s type=0
		
		i RowId="" d
		.s itmobj=##class(User.CSSDMoudle).%New()
		e  d
		.s itmobj=##class(User.CSSDMoudle).%OpenId(RowId)
		s itmobj.CSSDMName=MoudleName
		s itmobj.CSSDMCode=MoudleCode
		s itmobj.CSSDMAPPLYLOCDR=##class(User.CTLoc).%OpenId(ApplyLocDr)
		s itmobj.CSSDMLOCDR=##class(User.CTLoc).%OpenId(SupRowId)
		s itmobj.CSSDMType=type
		s itmobj.CSSDMReqLevel=reqlevel
		s Sc=itmobj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-5,"",$ClassName()_"jsSave:"_..%Translate($CLASSNAME(),"模板保存失败!"))
		q:RtnObj.success'=0
		
		s RowId=itmobj.%Id()
		i RowIdStr="" s RowIdStr=RowId
		e  s RowIdStr=RowIdStr_","_RowId
	}
	i RtnObj.success<0 tro  q RtnObj
	
	tc
	s RtnObj.rowid=RowIdStr
	q RtnObj
}

/// Creator:ban
/// CreatDate:2020.8.08
/// Description:删除模板及模板单明细数据
/// d ##class(web.CSSDHUI.Apply.PackageMoudle).jsDeleteMoudle("[{""RowId"":""11"",""Parref"":""7"",""PackageDR"":""329"",""PackageName"":""尿道探条(临床)"",""Qty"":""12"",""Remark"":""""}]")
ClassMethod jsDeleteMoudle(Params As %String) As %Library.String
{
	n (%session,Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	
	ts
	s RtnObj=..DeleteMoudle(Params)
	i RtnObj.success<0 tro  q RtnObj.Json()
	
	tc
	q RtnObj.Json()
}

/// Creator:ban
/// CreatDate:2020.8.08
/// Description:删除模板、模板单明细数据
/// Table:CSSD_Moudle
/// d ##class(web.CSSDHUI.Apply.PackageMoudle).DeleteMoudle("[{""RowId"":""11"",""Parref"":""7"",""PackageDR"":""329"",""PackageName"":""尿道探条(临床)"",""Qty"":""12"",""Remark"":""""}]")
ClassMethod DeleteMoudle(Params As %String) As web.CSSDHUI.RtnObj
{
	n (%session,Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s sc=PJObj.%FromJSON(Params)
	i sc'=0 q RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"入参解析失败!"))
	
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		
		s RowId=Obj.%Get("RowId")
		
		&sql(delete from CSSD_MoudleDetail where CSSDMD_Parref=:RowId)
		i SQLCODE<0 d RtnObj.Err(-3,"",..%Translate($CLASSNAME(),"删除明细失败!"))
		continue:RtnObj.success<0
		
		&sql(Delete From CSSD_Moudle WHERE CSSDM_Rowid=:RowId)
		i SQLCODE<0 d RtnObj.Err(-2,"",..%Translate($CLASSNAME(),"删除模板主表出错！"))
		continue:RtnObj.success<0
	}
	q RtnObj
}

}
