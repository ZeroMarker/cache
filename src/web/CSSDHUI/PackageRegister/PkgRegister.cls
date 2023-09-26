Import SQLUSER

/// Creator:why
/// CreatDate:2020-03-23
/// Description:消毒包登记
/// Table:CSSD_Trans_OP
Class web.CSSDHUI.PackageRegister.PkgRegister Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Creator:why
/// CreatDate:2020-03-23
/// Description:消毒包登记通过就诊号查询
/// Table:CSSD_Trans_OP
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.PackageRegister.PkgRegister","GetPatientInfo","222")
Query GetPatientInfo(Adm As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,Label,CountNurseName,CountNurseTime,RegNo,PatName,PatLoc,PkgDesc") [ SqlProc ]
{
}

ClassMethod GetPatientInfoExecute(ByRef qHandle As %Binary, Adm As %String) As %Status
{
	n (qHandle,Adm,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="SELECT CSSDTOP_rowid as Rowid,cssdtop_label as label,cssdtop_CountNurseDr as CountNurseDr,"
			_"CSSDOP_CountDate,CSSDOP_CountTime,cssdtop_PationtDR as PationtDR"
			_" FROM CSSD_Trans_OP WHERE cssdtop_pationtDR='"_Adm_"' and CSSDTOP_ANOPID IS null"
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("Rowid")
		s Label = Result.Data("label")
		s CountNurseDrId = Result.Data("CountNurseDr")
		s CountDate = Result.Data("CSSDOP_CountDate")
		s CountTime = Result.Data("CSSDOP_CountTime")
		s PationtDR = Result.Data("PationtDR")
		s CountDate=..DL2H(CountDate)
		s CountTime=..TL2H(CountTime)
		s CountNurseTime=CountDate_" "_CountTime
		&sql(SELECT  CTPCP_Desc into:CountNurseName FROM CT_CareProv where CTPCP_RowId=:CountNurseDrId)
		s CountNurseName=..%FieldTranslate("User.CTCareProv","CTPCPDesc",CountNurseName)
		s pationtInfo=..ByAdmGetPatInfo(PationtDR)
		s RegNo=$p(pationtInfo,"^",1)
		s PatName=$p(pationtInfo,"^",2)
		s PatLoc=$p(pationtInfo,"^",3)
		s PkgDesc=..GetPackageName(Label)
		d OutPutRow
	}
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,Label,CountNurseName,CountNurseTime,RegNo,PatName,PatLoc,PkgDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creator:why
/// CreatDate:2020-03-23
/// Description:通过就诊号获取患者信息返回String格式
/// Table:CSSD_Trans_OP
/// w ##class(web.CSSDHUI.PackageRegister.PkgRegister).ByAdmGetPatInfo("1")
ClassMethod ByAdmGetPatInfo(Adm As %String) As %Status
{
	n (Adm,%session)
	s PaAdmId=$p(^PAADM(Adm),"^",1)
	s PaAdmDepLocId=$p(^PAADM(Adm),"^",4)
	s PatName=$p(^PAPER($p(^PAADM(Adm),"^",1),"ALL"),"^",1)
	s PatName=..%FieldTranslate("User.PAPerson","PAPERName",PatName)
	s RegNo=$p(^PAPER(PaAdmId,"PAT",1),"^",1)
	s PatLoc=$p(^CTLOC(PaAdmDepLocId),"^",2)
	s PatLoc=..%FieldTranslate("User.CTLoc","CTLOCDesc",PatLoc)
	q RegNo_"^"_PatName_"^"_PatLoc
}

/// Creator:why
/// CreatDate:2020-03-23
/// Description:通过标签获取包名
/// Table:CSSD_Trans_OP
/// w ##class(web.CSSDHUI.PackageRegister.PkgRegister).GetPackageName("1")
ClassMethod GetPackageName(label As %String) As %Status
{
	n (label,%session)
	q:label="" 
	s TransId= $o(^User.CSSDTransI("CSSDTLabel",label,""))
	s transInfo=""
	s transInfo=##Class(User.CSSDTrans).%OpenId(TransId)
	s AttributeId=transInfo.CSSDTPackage.CSSDPPackTypeDetail
	s PkgDesc=transInfo.CSSDTPackage.CSSDPDesc
	s PkgDesc=..%FieldTranslate("User.CSSDPackage","CSSDPDesc",PkgDesc)
	i AttributeId=1 d
	.s PkgDesc=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetCodeDictName(label)
	q PkgDesc
}

/// Description:删除追踪信息
/// w ##class(web.CSSDHUI.PackageRegister.PkgRegister).jsDelete(^tmpmy("dv"))
ClassMethod jsDelete(Params) As %Library.String
{
	n (%session,Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 tro  q RtnObj.Err(-1,"","入参解析失败!").Json()
	
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		continue:RowId=""
		s RtnObj=..Delete(RowId)
		q:RtnObj.success'=0
	}
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:why
/// CreatDate:2020-03-23
/// Description:删除追踪信息
/// Table:CSSD_Trans_OP
/// w ##class(web.CSSDHUI.PackageRegister.PkgRegister).Delete("7")
ClassMethod Delete(RowId) As web.CSSDHUI.RtnObj
{
	n (RowId,%session)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s TransOpObj=##class(User.CSSDTransOP).%OpenId(RowId)
	d TransOpObj.%Reload()
	s Label=TransOpObj.CSSDTOPLabel
	s ApplyItmId=TransOpObj.CSSDTOPPackageApplyDetailDRGetObjectId()
	s ApplyStatu="",ApplyId=""
	
	i ApplyItmId'="" d
	.s ApplyItmObj=##class(User.CSSDPackageApplyDetail).%OpenId(ApplyItmId)
	.s ApplyId=ApplyItmObj.CSSDPADParref
	.s ReqQty=ApplyItmObj.CSSDPADReqQty
	
	i ApplyId'="" d
	.s ApplyObj=##class(User.CSSDPackageApply).%OpenId(ApplyId)
	.q:'$IsObject(ApplyObj)
	.s ApplyStatu=ApplyObj.CSSDPAFlag
	i ((ApplyStatu'="")&&(ApplyStatu'=0)) d RtnObj.Err(-2,"",..%Translate($CLASSNAME(),"请领单已提交,不能删除"))
	q:RtnObj.success'=0 RtnObj
	
	s TransId= $o(^User.CSSDTransI("CSSDTLabel",Label,""))
	s TransInfo=##Class(User.CSSDTrans).%OpenId(TransId)
	d TransInfo.%Reload()
	s status=TransInfo.CSSDTStatus
	i status="C" d RtnObj.Err(-11,"",..%Translate($CLASSNAME(),"条码已经回收,不能删除"))
	q:RtnObj.success'=0 RtnObj

	&sql(Update cssd_trans set CSSDT_Status='R' where cssdt_label=:Label)
	i SQLCODE'=0 d RtnObj.Err(-2,RowID,$ClassName()_".Delete:SQLCODE"_SQLCODE_":"_$g(%msg))
	i RtnObj.success<0 q RtnObj
	
	i ApplyItmId'="" d
	.i ReqQty>1 d
	..s Qty=ReqQty-1
	..&sql(UPDATE CSSD_PackageApplyDetail SET CSSDPAD_ReqQty=:Qty WHERE ID=:ApplyItmId)
	.e  d
	..&sql(DELETE FROM CSSD_PackageApplyDetail WHERE ID=:ApplyItmId)
	i SQLCODE'=0 d RtnObj.Err(-3,"",..%Translate($CLASSNAME(),"更新申请子表失败！"))
	i RtnObj.success<0 q RtnObj
	
	i ApplyId'="" d
	.s ApplyDetailId=$o(^User.CSSDPackageApplyDetailI("CSSDPADParrefIndex",ApplyId,""))
	.i ApplyDetailId="" d
	..&sql(DELETE FROM CSSD_PackageApply WHERE ID=:ApplyId)
	i SQLCODE'=0 d RtnObj.Err(-3,"",..%Translate($CLASSNAME(),"删除申请主表失败！"))
	i RtnObj.success<0 q RtnObj
	
	&sql(delete from CSSD_Trans_OP where CSSDTOP_Rowid=:RowId)
	i SQLCODE'=0  d RtnObj.Err(-3,RowID,$ClassName()_".Delete:SQLCODE"_SQLCODE_":"_$g(%msg))
	i RtnObj.success<0 q RtnObj
	
	s RtnObj=##class(web.CSSDHUI.PackageDisp.DispItm).UpdateWLStatus(Label,"R")
	i RtnObj.success'=0 q RtnObj
	q RtnObj
}

/// Creator:wn
/// CreatDate:2020.1.10
/// Description:清洗验收页面验收合格功能
/// Table:CSSD_Clean
/// Input: Params：主表单据的ID、登录人以及科室等信息
/// Output:
/// Return:
/// w ##class(web.CSSDHUI.PackageRegister.PkgRegister).jsSaveRegister(^tmpmy("vds"))
ClassMethod jsSaveRegister(Params As %String) As %Library.String
{
	n (Params,%session)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..SaveRegister(Params)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:why
/// CreatDate:2020-03-23
/// Description:插入追踪信息表
/// Table:CSSD_Trans_OP
/// w ##class(web.CSSDHUI.PackageRegister.PkgRegister).SaveRegister("00482021091300001","3199119","15514","216","2")
ClassMethod SaveRegister(Params)
{
	n (Params,%session)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj

	s gUserId=PJObj.%Get("gUserId")
	s gGroupId=PJObj.%Get("gGroupId")
	s gLocId=PJObj.%Get("gLocId")
	s gHospId=PJObj.%Get("gHospId")
	s Adm=PJObj.%Get("Adm")
	s Label=PJObj.%Get("Label")
	i ((Adm="")||(Label="")) d RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"入参不能为空!"))
	q:RtnObj.success'=0 RtnObj

	s transId= $o(^User.CSSDTransI("CSSDTLabel",Label,""))
	i transId="" d RtnObj.Err(-2,"",..%Translate($CLASSNAME(),"错误的标签号"))
	q:RtnObj.success'=0 RtnObj
	s transInfo=##Class(User.CSSDTrans).%OpenId(transId)
	d transInfo.%Reload()
	s DispDetail=transInfo.CSSDTDisp
	s status=transInfo.CSSDTStatus
	s expDate=transInfo.CSSDTExpDate
	s PackageTypeDetail=transInfo.CSSDTPackage.CSSDPPackTypeDetail
	
	s ID=..IfRepCode(Label)
	i ID'=0 d RtnObj.Err(-3,"",..%Translate($CLASSNAME(),"标签号已经被登记"))
	q:RtnObj.success'=0 RtnObj

	i ('$IsObject(DispDetail)) d RtnObj.Err(-5,"",..%Translate($CLASSNAME(),"标签没有发放"))
	q:RtnObj.success'=0 RtnObj
	
	i status'="R" d RtnObj.Err(-7,"",..%Translate($CLASSNAME(),"标签不是接收状态"))
	q:RtnObj.success'=0 RtnObj

	s nowDate=$p($h,",",1)
	i nowDate>=expDate d RtnObj.Err(-6,"",..%Translate($CLASSNAME(),"标签过期"))
	q:RtnObj.success'=0 RtnObj

	s NurseId=..GetNurseIDByUseid(gUserId)
	i NurseId=0 d RtnObj.Err(-6,"",..%Translate($CLASSNAME(),"获取护士ID失败"))
	q:RtnObj.success'=0 RtnObj
	
	s nowTime=$p($h,",",2)
	s Param=gGroupId_"^"_gLocId_"^"_gUserId_"^"_gHospId
	s PatientInfo=..ByAdmGetPatInfo(Adm)
	s PatName=$p(PatientInfo,"^",2)
	s IfCreateApply=##class(web.CSSDHUI.Common.AppCommon).GetParamValue("CSSDAPPLAY","IfCreateApply",Param)
	&sql(insert into CSSD_Trans_OP (CSSDTOP_Label,CSSDTOP_PationtDR,CSSDTOP_PationtName,CSSDTOP_Doctor,
		CSSDTOP_CountNurseDR,CSSDOP_CountDate,CSSDOP_CountTime) 
		values(:Label,:Adm,:PatName,:NurseId,:NurseId,:nowDate,:nowTime)
	)
	i SQLCODE'=0 d
	.d RtnObj.Err(-7,"",..%Translate($CLASSNAME(),"保存数据失败:")_$ClassName()_".Insert:SQLCODE"_SQLCODE_":"_$g(%msg))
	q:RtnObj.success'=0 RtnObj

	&sql(Update cssd_trans set CSSDT_Status='U' where cssdt_label=:Label)
	i SQLCODE'=0 d
	.d RtnObj.Err(-8,"",..%Translate($CLASSNAME(),"更新状态失败")_$ClassName()_".Insert:SQLCODE"_SQLCODE_":"_$g(%msg))
	q:RtnObj.success'=0 RtnObj

	s RtnObj=##class(web.CSSDHUI.PackageDisp.DispItm).UpdateWLStatus(Label,"U")
	q:RtnObj.success'=0 RtnObj

	i IfCreateApply="Y" d
	.s RtnObj=..CreateApply(Label,gLocId,gUserId)
	q:RtnObj.success'=0 RtnObj

	q RtnObj
}

/// Creator:ban
/// CreatDate:2021-07-10
/// Description:根据登记的消毒包创建申请单
/// Table:CSSD_PackageApply
/// w ##class(web.CSSDHUI.PackageRegister.PkgRegister).CreateApply("L10292021070600001")
ClassMethod CreateApply(label, LocId, UserId) As web.CSSDHUI.RtnObj
{
	n (Label,LocId,UserId,%session)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PackId=$o(^User.CSSDPackagePackI("CSSDPPLabelIndex",Label,""))
	s PackObj=##class(User.CSSDPackagePack).%OpenId(PackId)
	s PkgId=PackObj.CSSDPPPackageGetObjectId()
	s MaterialId=PackObj.CSSDPPMaterialDrGetObjectId()
	s DeptCenter=PackObj.CSSDPPLocDrGetObjectId()
	
	s MaterialInfo=##class(web.CSSDHUI.Common.PackageInfoCommon).GetMaterialExpireLength(MaterialId,PkgId)
	s Price=$p(MaterialInfo,"^",2)
	s No=##class(web.CSSDHUI.Common.AppCommon).GetAppNo("Apply")
	s Usedate=+$h
	
	s ApplyId="",ApplyFlag=""
	f  s ApplyId=$o(^User.CSSDPackageApplyI("LocDate",LocId,+$h,ApplyId),-1) q:(ApplyId="")||(ApplyFlag=0)  d
	.s ApplyInfo=##Class(User.CSSDPackageApply).%OpenId(ApplyId)
	.d ApplyInfo.%Reload()
	.s ApplyFlag=ApplyInfo.CSSDPAFlag
	.s:ApplyFlag=0 rowid=ApplyId
	i ApplyFlag'=0 d
	.&sql(insert into cssd_packageapply (CSSDPA_No,CSSDPA_APPLYLOCDR,
		CSSDPA_ReqLevel,CSSDPA_UseDate,CSSDPA_Flag,CSSDPA_Type,
		CSSDPA_IsBack,CSSDPA_LOCDR,CSSDPA_CreateDate,CSSDPA_CreateUser) 
		values(:No,:LocId,0,:Usedate,0,0,0,:DeptCenter,:Usedate,:UserId))
	.i SQLCODE d RtnObj.Err(-2,"",$ClassName()_"Insert:"_..%Translate($CLASSNAME(),"新增请领单失败!"))
	.q:RtnObj.success'=0
	.s rowid=%ROWID
	q:RtnObj.success'=0 RtnObj
	
	s CodeDict=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetFixedLabel(Label)
	s ApplyItmId=$o(^User.CSSDPackageApplyDetailI("CSSDPADParrefPackageDrIndex",rowid,PkgId,""))
	i ApplyItmId="" d
	.&sql(INSERT CSSD_PackageApplyDetail (CSSDPAD_Parref, CSSDPAD_PackageDr,CSSDPAD_BackQty,
		CSSDPAD_OutQty,CSSDPAD_ReqQty,CSSDPAD_Price,CSSDPAD_Material_DR,CSSDPAD_BarCode)
		VALUES (:rowid,:PkgId,0,0,1,:Price,:MaterialId,:CodeDict))
	.i SQLCODE'=0 d RtnObj.Err(-4,"",..%Translate($CLASSNAME(),"插入明细数据失败")_$ClassName()_".CreateApply:SQLCODE"_SQLCODE_":"_$g(%msg))
	.q:RtnObj.success'=0
	.s ApplyItmId=%ROWID
	e  d
	.s ApplyItmInfo=##class(User.CSSDPackageApplyDetail).%OpenId(ApplyItmId)
	.d ApplyItmInfo.%Reload()
	.s ReqQty=ApplyItmInfo.CSSDPADReqQty
	.s Qty=ReqQty+1
	.&sql(UPDATE CSSD_PackageApplyDetail SET CSSDPAD_ReqQty =:Qty WHERE ID=:ApplyItmId)
	.i SQLCODE'=0 d RtnObj.Err(-4,"",..%Translate($CLASSNAME(),"更新明细数据失败")_$ClassName()_".CreateApply:SQLCODE"_SQLCODE_":"_$g(%msg))
	.q:RtnObj.success'=0
	q:RtnObj.success'=0 RtnObj
	&sql(Update CSSD_Trans_OP set CSSDTOP_PackageApplyDetailDR=:ApplyItmId where CSSDTOP_Label=:Label)
	i SQLCODE'=0 d RtnObj.Err(-4,"",..%Translate($CLASSNAME(),"更新状态失败")_$ClassName()_".CreateApply:SQLCODE"_SQLCODE_":"_$g(%msg))
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// Creator:why
/// CreatDate:2020-03-23
/// Description:根据userid获取护士ID
/// Table:CSSD_Trans_OP
/// w ##class(web.CSSDHUI.PackageRegister.PkgRegister).GetNurseIDByUseid("122221")
ClassMethod GetNurseIDByUseid(Useid)
{
	n (Useid,%session)
	s CTPId=""
	&sql(SELECT CTPCP_RowId into:CTPId FROM CT_CareProv WHERE CTPCP_Desc=(SELECT SSUSR_Name FROM SQLUser.SS_User WHERE SSUSR_RowId=:Useid)) 
	i CTPId'="" d
	.s ret=CTPId
	e  d
	.s ret=0
	q ret
}

/// Creator:why
/// CreatDate:2020-03-23
/// Description:判断CSSD_Trans_OP是否有记录
/// Table:CSSD_Trans_OP
/// w ##class(web.CSSDHUI.PackageRegister.PkgRegister).IfRepCode("122221")
ClassMethod IfRepCode(Label) As %String
{
	n (Label,%session)
	s rowid=$o(^User.CSSDTransOPI("CSSDTOPLabelIndex",Label,0))
	i rowid="" d  s rowid=0
	q rowid
}

}
