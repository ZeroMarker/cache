Import sqluser

/// 回收申请单明细
Class web.CSSDHUI.Apply.PackageApplyItm Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// CreatDate:	2019.9.15
/// Description:根据主表rowid获取回收申请子表的数据列表
/// Table:		CSSD_PackageApplyDetail
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Apply.PackageApplyItm","SelectByF","3","1")
/// call web_CSSDHUI_Apply.PackageApplyItm_SelectByF(102)
Query SelectByF(ApplyId As %String, PSterTypeId As %String = "") As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,PackageDR,PackageName,Qty:%Float,ReqQty:%Float,Remark,RemarkInfo,MaterialId,MaterialDesc,InfectRemark,UnDispQty:%Float,BarCode,BackQty:%Float,NotQty:%Float,SterTypeColor") [ SqlProc ]
{
}

ClassMethod SelectByFExecute(ByRef qHandle As %Binary, ApplyId As %String, PSterTypeId As %String = "") As %Status
{
	n (qHandle,ApplyId,PSterTypeId,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:ApplyId="" $$$OK
	
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="select ID, CSSDPAD_PackageDr as packagedr, CSSDPAD_PackageDr->CSSDP_Desc PackageName,CSSDPAD_DESC As Remark ,CSSDPAD_Qty as Qty,"
			_"CSSDPAD_ReqQty ,CSSDPAD_BackQty as BackQty,CSSDPAD_OutQty as OutQty ,CSSDPAD_PackLBL as PackLBL,"
			_"CSSDPAD_Remark as RemarkInfo,CSSDPAD_Material_DR,CSSDPAD_Material_DR->CSSDM_Desc as MaterialDesc,"
			_"CSSDPAD_InfectRemark,CSSDPAD_BarCode "
			_"FROM cssd_packageapplydetail WHERE CSSDPAD_Parref in ("_ApplyId_")"
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("ID")
		s PackageDR = Result.Data("packagedr")
		s PackageName=Result.Data("PackageName")
		s Remark = Result.Data("Remark")			;备注
		s RemarkInfo = Result.Data("RemarkInfo")	;反馈信息
		s Qty = Result.Data("Qty")
		s ReqQty = Result.Data("CSSDPAD_ReqQty")
		s MaterialId=Result.Data("CSSDPAD_Material_DR")
		s MaterialDesc=Result.Data("MaterialDesc")
		s InfectRemark=Result.Data("CSSDPAD_InfectRemark")
		s OutQty=Result.Data("OutQty")
		s BarCode=Result.Data("CSSDPAD_BarCode")
		s BackQty=Result.Data("BackQty")
		
		s UnDispQty=ReqQty-OutQty
		s NotQty=ReqQty-BackQty
		s PackageName=..%FieldTranslate("User.CSSDPackage","CSSDPDesc",PackageName)
		s MaterialDesc=..%FieldTranslate("User.CSSDMaterial","CSSDMDesc",MaterialDesc)
		i BarCode'="" d
		.s DictId=$o(^User.CSSDCodeDictI("CSSDCDCodeIndex",BarCode,""))
		.s PackageName=$s(DictId'="":$lg(^User.CSSDCodeDictD(DictId),6),1:"")
		.s PackageName=..%FieldTranslate("User.CSSDCodeDict","CSSDCDPackName",PackageName)
		s SterTypeId=$lg(^User.CSSDPackageD(PackageDR),21)
		continue:((PSterTypeId'="")&&(SterTypeId'=PSterTypeId))
		s SterTypeColor=$p(##class(web.CSSDHUI.PackageInfo.Package).GetSterTypeInfo(PackageDR),"^",3)
		d OutPutRow
	}
	d Result.Close()
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,PackageDR,PackageName,Qty,ReqQty,Remark,
		RemarkInfo,MaterialId,MaterialDesc,InfectRemark,UnDispQty,
		BarCode,BackQty,NotQty,SterTypeColor)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// CreatDate:	2019.9.15
/// Description:保存回收申请单明细
/// Table:		CSSD_PackageApplyDetail
/// w ##class(web.CSSDHUI.Apply.PackageApplyItm).jsSave
ClassMethod jsSave(MainId, Params) As %Library.String
{
	n (%session,MainId,Params)
	s $ZT=..sssError()
	ts
	s RtnObj=..Save(MainId,Params)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

ClassMethod Save(MainId, Params) As web.CSSDHUI.RtnObj
{
	n (%session,MainId,Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i ((MainId="")||(Params="")) q RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"入参不能为空!"))
	
	s ApplyObj=##class(User.CSSDPackageApply).%OpenId(MainId)
	i ApplyObj="" q RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"单据已删除,请刷新核实!"))
	
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-2,"",..%Translate($CLASSNAME(),"入参解析失败!"))
	
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		
		s RowId=Obj.%Get("RowId")
		s PackageDR=Obj.%Get("PackageDR")
		s BarCode=Obj.%Get("BarCode")
		s ReqQty=Obj.%Get("ReqQty")				;请求数量
		s Qty=Obj.%Get("Qty")					;原始请求数量(确认界面修改数量时传入,申请制单时不需传递)
		s MaterialId=Obj.%Get("MaterialId")
		s Remark=Obj.%Get("Remark")
		s InfectRemark=Obj.%Get("InfectRemark")
		s RemarkInfo=Obj.%Get("RemarkInfo")
		
		i Qty="" s Qty=ReqQty					;制单时,不能传Qty字段,默认使用申请数量ReqQty
		
		continue:PackageDR=""
		s PackageDesc=$lg(^User.CSSDPackageD(PackageDR),5)
		s UnitPrice=$lg(^User.CSSDPackageD(PackageDR),9)
		s ApplyDetailId=$o(^User.CSSDPackageApplyDetailI("CSSDPADParrefPackageDrIndex",MainId,PackageDR,""))
		i (BarCode="")&&((ApplyDetailId'="")&&(ApplyDetailId'=RowId)) d RtnObj.Err(-3,"",PackageDesc_..%Translate($CLASSNAME(),"重复申领，请核对！"))
		continue:RtnObj.success'=0
		
		s CheckFlag=..CheckCurApplyQty(MainId,PackageDR,Qty,RowId)
		i CheckFlag="Y" d RtnObj.Err(-9,"",PackageDesc_..%Translate($CLASSNAME(),"超过每日请领量"))
		continue:RtnObj.success'=0
		
		i (Qty<0) d RtnObj.Err(-4,"",..%Translate($CLASSNAME(),"申请数量必须大于0!"))
		continue:RtnObj.success'=0
		
		s InfectSign="N"
		i InfectRemark'="" s InfectSign="Y"
		
		s ItmObj=""
		i RowId="" d
		.s ItmObj=##class(User.CSSDPackageApplyDetail).%New()
		.s ItmObj.CSSDPADParref=MainId
		e  d
		.s ItmObj=##class(User.CSSDPackageApplyDetail).%OpenId(RowId)
		
		d ItmObj.CSSDPADPackageDrSetObjectId(PackageDR)
		s ItmObj.CSSDPADQty=Qty
		s ItmObj.CSSDPADReqQty=ReqQty
		s ItmObj.CSSDPADBackQty=0
		s ItmObj.CSSDPADOutQty=0
		s ItmObj.CSSDPADDesc=Remark
		s ItmObj.CSSDPADRemark=RemarkInfo
		s ItmObj.CSSDPADPrice=UnitPrice
		d ItmObj.CSSDPADMaterialDRSetObjectId(MaterialId)
		s ItmObj.CSSDPADBeInfected=InfectSign
		s ItmObj.CSSDPADInfectRemark=InfectRemark
		s Sc=ItmObj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-5,"",$ClassName()_"jsSave:"_..%Translate($CLASSNAME(),"保存失败!"))
		continue:RtnObj.success'=0
	}
	q:RtnObj.success<0 RtnObj
	
	s RtnObj=##class(web.CSSDHUI.Apply.PackageApply).ChangeInfectedFlag(MainId)
	q:RtnObj.success<0 RtnObj
	
	q RtnObj
}

/// Description:扫码标牌/标签, 保存回收申请单明细
/// Table:		CSSD_PackageApplyDetail
/// w ##class(web.CSSDHUI.Apply.PackageApplyItm).jsSaveBarCode("91","{""BarCode"":""100006001"",""gUserId"":""11889"",""gLocId"":""144"",""gGroupId"":""337"",""gHospId"":""2""}")
ClassMethod jsSaveBarCode(MainId, Params) As %Library.String
{
	n (%session,MainId,Params)
	s $ZT=..sssError()
	ts
	s RtnObj=..SaveBarCode(MainId,Params)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Description:保存回收申请单明细
/// Input:		MainId-回收申请单id
/// 
ClassMethod SaveBarCode(MainId, Params) As web.CSSDHUI.RtnObj
{
	n (%session,MainId,Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i ((MainId="")||(Params="")) q RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"入参不能为空!"))
	
	s ApplyObj=##class(User.CSSDPackageApply).%OpenId(MainId)
	i ApplyObj="" q RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"单据已删除,请刷新核实!"),"",0)
	s ApplyLocId=ApplyObj.CSSDPAAPPLYLOCDRGetObjectId()
	s ReqFlag=ApplyObj.CSSDPAFlag
	i ReqFlag'=0 q RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"请核实单据状态!"),"",0)
	
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-2,"",..%Translate($CLASSNAME(),"入参解析失败!"))
	
	s BarCode=PJObj.%Get("BarCode")
	s LabelInfo=##class(web.CSSDHUI.Common.PackageInfoCommon).GetLabel(BarCode)
	s CodeDict=$p(LabelInfo,"^",1)
	s PkgTypeDetail=$p(LabelInfo,"^",2)
	s PkgDr=$p(LabelInfo,"^",3)
	i CodeDict="" q RtnObj.Err(-2,"",..%Translate($CLASSNAME(),"未获取到标牌信息，请核对！"),"",0)
	i PkgTypeDetail'=1 q RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"该标牌属性不是标牌追溯包，请核实！"),"",0)

	s codeLength=$l(CodeDict)
	s TransId=""
	&sql(select max(cssdt_rowid) into :TransId from cssd_trans
		where substr(cssdt_label,1,:codeLength)=:CodeDict)
	
	i TransId'="" d
	.s DispId=$lg(^User.CSSDTransD(TransId),14)
	.q:DispId=""
	.s DispToLocId=$lg(^User.CSSDPackageDispD(DispId),10)
	.i (DispToLocId'="")&&(ApplyLocId'=DispToLocId) d RtnObj.Err(-1,"","回收申请科室与标签所在科室不符!","",0)
	q:RtnObj.success<0 RtnObj
	
	s IsExt=##class(web.CSSDHUI.Common.PackageInfoCommon).GetExtFlag(PkgDr)
	i (IsExt="Y") d		//循环分包标签判断状态
	.i (TransId="") d RtnObj.Err(-3,"",CodeDict_..%Translate($CLASSNAME(),":标牌未使用，不能申请！"),"",0) q
	.
	.s transObj=##Class(User.CSSDTrans).%OpenId(TransId)
	.s TmpLabel=transObj.CSSDTLabel
	.s NewLabel=$e(TmpLabel,1,codeLength+6)	;标牌编码号加上6位流水号
	.
	.s ItemRowId=0
	.f  s ItemRowId=$o(^User.CSSDPackagePackI("CSSDPPNewLabelIndex",NewLabel,ItemRowId)) q:((ItemRowId="")||(RtnObj.success'=0))  d
	..s ItemObj=##Class(User.CSSDPackagePack).%OpenId(ItemRowId)
	..s PkgLabel=ItemObj.CSSDPPLabel
	..s transId=$o(^User.CSSDTransI("CSSDTLabel",PkgLabel,0))
	..q:transId=""
	..s transObj=##Class(User.CSSDTrans).%OpenId(transId)
	..d transObj.%Reload()
	..s PackageStatus=transObj.CSSDTStatus
	..i ((PackageStatus'="")&&(PackageStatus'="R")&&(PackageStatus'="U")&&(PackageStatus'="TC")) d
	...d RtnObj.Err(-3,"",CodeDict_..%Translate($CLASSNAME(),":对应标签不是接收、使用、过期处理状态！"),"",0)
	..q:RtnObj.success'=0
	.q:RtnObj.success'=0
	e  d
	.i TransId="" d RtnObj.Err(-3,"",CodeDict_..%Translate($CLASSNAME(),":标牌未使用过，不能回收申请"),"",0)
	.q:RtnObj.success'=0
	.s transObj=##Class(User.CSSDTrans).%OpenId(TransId)
	.d transObj.%Reload()
	.s PackageStatus=transObj.CSSDTStatus
	.i ((PackageStatus'="")&&(PackageStatus'="R")&&(PackageStatus'="U")&&(PackageStatus'="TC")) d
	..s State=##class(web.CSSDHUI.Common.PackageInfoCommon).GetStatusChinese(PackageStatus)
	..d RtnObj.Err(-3,"",CodeDict_State_..%Translate($CLASSNAME(),",不是接收、使用、过期处理状态，不能申请！"),"",0)
	q:RtnObj.success'=0 RtnObj
	
	;检查标牌是否存在于其他单据中
	s CheckFlag=""
	s ApplyId=""
	f  s ApplyId=$o(^User.CSSDPackageApplyDetailI("BarCodeParref",CodeDict,ApplyId),-1) q:(ApplyId="")||(CheckFlag="Y")  d
	.q:ApplyId=MainId
	.s ApplyNo=$lg(^User.CSSDPackageApplyD(ApplyId),5)
	.s ApplyFlag=$lg(^User.CSSDPackageApplyD(ApplyId),9)
	.s CheckFlag="Y"
	.q:(TransId'="")&&(",0,1,5,"'[ApplyFlag)	;存在已经处理的回收申请，结束循环,不记录RtnObj
	.q:(TransId="")&&(",0,1,5,2,"'[ApplyFlag)
	.d RtnObj.Err(-3,"",..%Translate($CLASSNAME(),"该标牌已存在于其他单据中:")_ApplyNo,"",0)
	q:RtnObj.success<0 RtnObj
	
	
	s ApplyItmId=$o(^User.CSSDPackageApplyDetailI("ParrefBarCodeIndex",MainId,CodeDict,""))
	i (ApplyItmId'="") d
	.d RtnObj.Err(-3,"",CodeDict_..%Translate($CLASSNAME(),"重复申领，请核对！"),"",0)
	q:RtnObj.success'=0 RtnObj
	
	s MaterialDr=##class(web.CSSDHUI.Common.PackageInfoCommon).GetDefaultMaterial(PkgDr)
	s MatInfo=##class(web.CSSDHUI.Common.PackageInfoCommon).GetMaterialExpireLength(MaterialDr,PkgDr)
	s Price=+$p(MatInfo,"^",2)
	s Qty=1
	
	s ItmObj=##class(User.CSSDPackageApplyDetail).%New()
	s ItmObj.CSSDPADParref=MainId
	d ItmObj.CSSDPADPackageDrSetObjectId(PkgDr)
	s ItmObj.CSSDPADQty=Qty
	s ItmObj.CSSDPADReqQty=Qty
	s ItmObj.CSSDPADBackQty=0
	s ItmObj.CSSDPADOutQty=0
	s ItmObj.CSSDPADBarCode=CodeDict
	s ItmObj.CSSDPADPrice=Price
	d ItmObj.CSSDPADMaterialDRSetObjectId(MaterialDr)
	s Sc=ItmObj.%Save()
	i $$$ISERR(Sc) d RtnObj.Err(-5,"",$ClassName()_"jsSaveBarCode:"_..%Translate($CLASSNAME(),"保存失败!"))
	q:RtnObj.success'=0 RtnObj
	
	q RtnObj
}

/// 判断回收申请数量是否超过规定的请领量
/// w ##class(web.CSSDHUI.Apply.PackageApplyItm).CheckCurApplyQty("144","46","26","","5")
ClassMethod CheckCurApplyQty(CurApplyId, CurPkgId, CurQty, CurApplyD)
{
	n (%session,CurApplyId, CurPkgId, CurQty, CurApplyD)
	s Flag="N"
	q:(CurPkgId="")||(CurApplyId="")||(CurQty="") Flag
	
	s CurApplyObj=##class(User.CSSDPackageApply).%OpenId(CurApplyId)
	s CurType=CurApplyObj.CSSDPAType
	s LocId=CurApplyObj.CSSDPAAPPLYLOCDRGetObjectId()
	q:(CurType=1)||(CurType=4) Flag
	
	s NormQty=##class(web.CSSDHUI.System.LocPackageStock).GetNormQty(LocId,CurPkgId)
	q:NormQty="" Flag
	
	s SumQty=0,CurDate=+$h
	s ApplyId=0
	f  s ApplyId=$o(^User.CSSDPackageApplyI("LocDate",LocId,CurDate,ApplyId)) q:ApplyId=""  d
	.q:(CurApplyId=ApplyId)
	.s ApplyObj=##class(User.CSSDPackageApply).%OpenId(ApplyId)
	.s ReqType=ApplyObj.CSSDPAType
	.q:((ReqType=1)||(ReqType=4))
	.
	.s ApplyItmId=0
	.f  s ApplyItmId=$o(^User.CSSDPackageApplyDetailI("CSSDPADParrefPackageDrIndex",ApplyId,CurPkgId,ApplyItmId)) q:ApplyItmId=""  d
	..s ApplyDObj=##class(User.CSSDPackageApplyDetail).%OpenId(ApplyItmId)
	..s Qty=ApplyDObj.CSSDPADReqQty
	..s SumQty=SumQty+Qty
	.
	s SumQty=SumQty+CurQty
	i SumQty>NormQty s Flag="Y"
	
	q Flag
}

/// CreatDate:2019.9.15
/// Description:删除回收申请明细数据
/// d ##class(web.CSSDHUI.Apply.PackageApplyItm).jsDelete(3)
ClassMethod jsDelete(Params As %String) As %Library.String
{
	n (%session,Params)
	s $ZT=..sssError()
	s MethodName=$CLASSNAME()_".jsDelete"
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"",MethodName_..%Translate($CLASSNAME(),"参数解析错误")).Json()
	
	ts
	While(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		
		s RowId=Obj.%Get("RowId")
		continue:RowId=""
		
		s RtnObj=..Delete(RowId)
		continue:RtnObj.success<0
	}
	i RtnObj.success<0 tro  q RtnObj.Json()
	
	tc
	q RtnObj.Json()
}

/// Description:删除回收申请单明细数据
/// Input:		回收申请单明细id
ClassMethod Delete(RowId As %String) As web.CSSDHUI.RtnObj
{
	n (%session,RowId)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i RowId="" q RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"入参不能为空!"))
	
	s ApplyId=$lg(^User.CSSDPackageApplyDetailD(RowId),3)
	i ApplyId="" q RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"入参异常!"))
	
	s ApplyFlag=$lg(^User.CSSDPackageApplyD(ApplyId),9)
	i ApplyFlag'=0 q RtnObj.Err(-2,"",..%Translate($CLASSNAME(),"单据已提交,请注意核实!"),"",0)
	
	&sql(Delete From CSSD_PackageApplyDetail WHERE ID=:RowId)
	i SQLCODE<0 q RtnObj.Err(-3,"",..%Translate($CLASSNAME(),"删除明细失败！"))
	
	&sql(Update CSSD_Trans_OP set CSSDTOP_PackageApplyDetailDR=NULL where CSSDTOP_PackageApplyDetailDR=:RowId)
	i SQLCODE<0 q RtnObj.Err(-4,"",..%Translate($CLASSNAME(),"更新消毒包追踪患者绑定表失败！"))
	q RtnObj
}

}
