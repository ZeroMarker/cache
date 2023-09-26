Import SQLUser

Class web.CSSDHUI.Clean.CleanBasket Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Creator:ban
/// CreatDate:2020-04-30
/// Description:已装筐的修改数量
/// Table:CSSD_BasketPackDetail
/// w ##class(web.CSSDHUI.Clean.CleanBasket).jsSave("[{""RowId"":"""",""TransDr"":""1"",""CleanMethodDR"":""1"",""CleanMethodName"":""手工清洗"",""CleanUser"":""1"",""CleanUserName"":""Demo Group"",""CleanMachineNo"":""2"",""CleanNo"":""20200319200001"",""ErrorDate"":""65457"",""PkgDr"":""1"",""PackageName"":""甲乳专科器械"",""SterUser"":""1"",""SterUserName"":""Demo Group"",""SterNo"":""2020031901007"",""SterMachineNo"":""1"",""SterMethodDr"":""1"",""SterMethodName"":""低温灭菌"",""SSterMethodDr"":""0"",""SSterMethodName"":""高温灭菌"",""SCleanMethodDr"":""1"",""SCleanMethodName"":""手工清洗"",""UpdateUserDr"":"""",""UpdateUserDrName"":"""",""Remark"":""""}]","{""packageName"":"""",""gUserId"":""11354"",""gLocId"":""316"",""gGroupId"":""103"",""gHospId"":""2""}")
ClassMethod jsSave(Params) As %Library.String
{
	n (%session,Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..Save(Params)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

ClassMethod Save(Params) As web.CSSDHUI.RtnObj
{
	n (%session,Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		
		s pRowId=Obj.%Get("RowId")
		continue:pRowId=""
		
		s pQty=Obj.%Get("Qty")
		s CallBackDetailId=$List(^User.CSSDBasketPackDetailD(pRowId),2)
		i (CallBackDetailId'="") d RtnObj.Err(-1,"","不能修改数量")
		continue:RtnObj.success'=0
		
		s DetailObj=""
		s DetailObj=##class(User.CSSDBasketPackDetail).%OpenId(pRowId)
		s PkgId=DetailObj.CSSDCBPPackage.%Id()
		s AttributeId=$lg(^User.CSSDPackageD(PkgId),15) ;包属性
		s IsExt=##class(web.CSSDHUI.Common.PackageInfoCommon).GetExtFlag(PkgId)
		i ((AttributeId="1")&&(IsExt'="Y")) d RtnObj.Err(-1,"","标牌追溯包不能修改数量")
		continue:RtnObj.success'=0
		
		s DetailObj.CSSDCBPQty=pQty
		s Sc=DetailObj.%Save()
		continue:RtnObj.success'=0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj
}

/// Creator:ban
/// CreatDate:2020.4.21
/// Description:清洗篮筐中,扫描增加消毒包
/// Table:CSSD_BasketPackDetail
/// Input:basketLabel:清洗篮筐 pkgLabel:消毒包标签
/// Output:
/// Return:日志信息
/// w ##class(web.CSSDHUI.Clean.CleanBasket).jsSaveCleanBasket(^tmpljl("2"))
ClassMethod jsSaveCleanBasket(Params) As %Library.String
{
	n (%session,Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..AddBasket(Params)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:ban
/// CreatDate:2020.4.21
/// Description:清洗篮筐中,扫描增加消毒包
/// Table:CSSD_BasketPackDetail
/// Input:basketLabel:清洗篮筐 pkgLabel:消毒包标签
/// Output:
/// Return:日志信息
/// w ##class(web.CSSDHUI.Clean.CleanBasket).AddBasket("45","002042001","7")
ClassMethod AddBasket(Params) As web.CSSDHUI.RtnObj
{
	n (%session,Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	
	s pBasketLabel = PJObj.%Get("CleanBasket")
	s pPkgLabel = PJObj.%Get("BarCode")
	s pCleanMachineId = PJObj.%Get("CleanMachine")
	i ((pBasketLabel="")||(pPkgLabel="")) d RtnObj.Err(-1,"","清洗架或标牌不能为空！")
	
	s PkgId="",Qty=1,CodeDictId="",AttributeId=""
	s CodeDictId=$o(^User.CSSDCodeDictI("CSSDCDCodeIndex",pPkgLabel,CodeDictId))
	i CodeDictId="" d RtnObj.Err(-1,"","扫描标牌不存在！")
	q:RtnObj.success'=0 RtnObj
	
	;判断同一标牌下的所有标签状态(外来器械)
	s PackId=""
	f  s PackId=$o(^User.CSSDPackagePackI("CodeDict",CodeDictId,PackId)) q:PackId=""  d 
	.s PackObj = ##class(User.CSSDPackagePack).%OpenId(PackId)
	.d PackObj.%Reload()
	.s Label=PackObj.CSSDPPLabel
	.s TransId=$o(^User.CSSDTransI("CSSDTLabel",Label,""))
	.q:TransId=""
	.s TransObj = ##class(User.CSSDTrans).%OpenId(TransId)
	.d TransObj.%Reload()
	.s Status=TransObj.CSSDTStatus
	.i (Status'="C")&&(Status'="TC") d RtnObj.Err(-1,"","存在标签不是回收或过期处理状态！")
	q:RtnObj.success'=0 RtnObj
	
	
	s CodeDictObj = ##class(User.CSSDCodeDict).%OpenId(CodeDictId)
	d CodeDictObj.%Reload()
	s UseFlag=CodeDictObj.CSSDCDNotUseFlag
	i UseFlag'="Y" d RtnObj.Err(-1,"","扫描标牌不可用！")
	q:RtnObj.success'=0 RtnObj
	
	s PkgId = CodeDictObj.CSSDCDPackDR.%Id()
	s CycleCount = CodeDictObj.CSSDCDCycleCount
	s AttributeId=##class(User.CSSDPackage).%OpenId(PkgId).CSSDPPackTypeDetail
	i AttributeId'=1 d RtnObj.Err(-1,"","非标牌追溯包")
	q:RtnObj.success'=0 RtnObj
	
	s (CallId,ComplateFlag,CallMainId)=""
	//处理外来器械
	s ExtId=""
	s IsExt=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetExtFlag(PkgId)
	i IsExt="Y" d
	.s ExtId=$o(^User.CSSDExtDevBindI("IndexCSSDExtCodeIsTransfer",pPkgLabel,"N",""))
	.i ExtId="" d RtnObj.Err(-1,"","清洗前，请先做外来器械登记！") q
	.
	.s ExtObj = ##class(User.CSSDExtDevBind).%OpenId(ExtId)
	.d ExtObj.%Reload()
	.s NowState = ExtObj.CSSDExtStatus
	.i ((NowState'="B")&&(NowState'="C")) d RtnObj.Err(-1,"","不是登记和回收状态的外来器械包")	q
	q:RtnObj.success'=0 RtnObj
	&sql(select max(ID) into :TmpCleanItmId from CSSD_CleanDetailPacks where CSSDCDP_Label=:pPkgLabel AND CSSDCDP_IsCrtLbl = 0)
	i (IsExt'="Y")&&(SQLCODE=0)&&(TmpCleanItmId'="") d RtnObj.Err(-1,"","该标牌追溯包已清洗未打包,不能重复装载！")
	q:RtnObj.success'=0 RtnObj
	
	s ComplateFlag=""
	&sql(select max(CSSDCD_Rowid) into :CallId from CSSD_CallBackDetailNew where CSSDPC_DictLabel =:pPkgLabel AND CSSDCD_IsClean IS NULL)
	i (SQLCODE=0)&&(CallId'="") d 
	.s CallMainId=$lg(^User.CSSDCallbackDetailNewD(CallId),2)
	.i CallMainId'="" d
	..s ComplateFlag=$lg((^User.CSSDPackageCallbackD(CallMainId)),14)
	i ComplateFlag="N" d RtnObj.Err(-1,"","回收单未提交!")
	q:RtnObj.success'=0 RtnObj
	
	i (CycleCount'=0)&&(ComplateFlag="N")  d RtnObj.Err(-1,"","该标牌追溯包未回收或已添加！")
	q:RtnObj.success'=0 RtnObj
	
	s BasketId=$o(^User.CSSDBasketPackDetailI("LabelIsCleanIndex",pPkgLabel,"N",""))
	i BasketId'="" d RtnObj.Err(-1,"","标牌已装载未清洗！")
	q:RtnObj.success'=0 RtnObj
	
	&sql(INSERT INTO CSSD_BasketPackDetail (CSSDCBP_BSKLabel, CSSDCBP_Package_DR, CSSDCBP_PackageLabel, CSSDCBP_Qty, CSSDCBP_IsClean,CSSDCBP_MachineNo_DR,CSSDCBP_CallBackDetail_DR) VALUES (:pBasketLabel,:PkgId,:pPkgLabel,:Qty,'N',:pCleanMachineId,:CallId))
	i SQLCODE'=0 d RtnObj.Err(-1,pPkgLabel,"装载清洗架失败!:"_$ClassName()_".jsSaveCleanBasket:SQLCODE"_SQLCODE_":"_$g(%msg))
	q:RtnObj.success'=0 RtnObj
	
	q RtnObj
}

/// Creator:ban
/// CreatDate:2020.4.21
/// Description:清洗架中,扫描增加消毒包
/// Table:CSSD_BasketPackDetail
/// Input:BasketLabel:清洗架标牌
/// Output:
/// Return:日志信息
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Clean.CleanBasket","SelectCleanBasketInfo","1")
Query SelectCleanBasketInfo(BasketLabel As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,PkgDesc,PkgLabel,Qty:%Float,MachineNo,BasketDesc,BackNo,BackLocDesc")
{
}

ClassMethod SelectCleanBasketInfoExecute(ByRef qHandle As %Binary, BasketLabel As %String) As %Status
{
	n (%session,qHandle,BasketLabel)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:BasketLabel="" $$$OK
	
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="SELECT ID,CSSDCBP_Package_DR->CSSDP_Desc AS PkgDesc,CSSDCBP_PackageLabel, "
			 _" CSSDCBP_MachineNo_DR,CSSDCBP_Qty,CSSDCBP_Package_DR,CSSDCBP_BSKLabel,CSSDCBP_IsClean "
			 _" FROM CSSD_BasketPackDetail"
			 _" WHERE CSSDCBP_BSKLabel= '"_BasketLabel_"'"
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{	
		s RowId = Result.Data("ID")
		s IsClean = Result.Data("CSSDCBP_IsClean")
		continue:IsClean="Y"
		s PkgId=Result.Data("CSSDCBP_Package_DR")
		s PkgDesc = Result.Data("PkgDesc")
		s PkgLabel = Result.Data("CSSDCBP_PackageLabel")
		s Qty = Result.Data("CSSDCBP_Qty")	
		s MachineId = Result.Data("CSSDCBP_MachineNo_DR")
		s BSKLabel = Result.Data("CSSDCBP_BSKLabel")
		s AttributeId=$lg(^User.CSSDPackageD(PkgId),15)
		i AttributeId=1 d
		.s DictId=$o(^User.CSSDCodeDictI("CSSDCDCodeIndex",PkgLabel,""))
		.s PkgDesc=$s(DictId'="":$lg(^User.CSSDCodeDictD(DictId),6),1:"")
		i MachineId'="" d
		.s MachineNo=$lg(^User.CSSDMachineConfigD(MachineId),10)
		s BasketDesc=$lg(^User.CSSDCodeDictD(BSKLabel),6)
		
		s CBItmId=$lg(^User.CSSDBasketPackDetailD(RowId),2)
		s BackNo="",BackLocDesc="",BackLocId=""
		i (CBItmId'="")&&($d(^User.CSSDCallbackDetailNewD(CBItmId))) d	//回收信息
		.s CBItmInfo=^User.CSSDCallbackDetailNewD(CBItmId)
		.s CBId=$lg(CBItmInfo,2)
		.s CBInfo=^User.CSSDPackageCallbackD(CBId)
		.s BackLocId=$lg(CBInfo,3)
		.s BackLocDesc=..sssLocDesc(BackLocId)
		.s BackNo=$lg(CBInfo,8)
		d OutPutRow
	}
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,PkgDesc,PkgLabel,Qty,MachineNo,BasketDesc,BackNo,BackLocDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creator:ban
/// CreatDate:2020.4.21
/// Description:删除清洗架的数据
/// Table:CSSD_BasketPackDetail
/// Input:ItemRowID:明细id
/// Output:
/// Return:日志信息
/// w ##class(web.CSSDHUI.Clean.CleanBasket).jsDelete("[{""RowId"":""6"",""PkgDesc"":""ptb-1"",""PkgLabel"":"""",""Qty"":""4"",""MachineNo"":"""",""BasketDesc"":""清洗容器003"",""BackNo"":"""",""BackLocDesc"":""""}]")
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

ClassMethod Delete(Params As %String) As web.CSSDHUI.RtnObj
{
	n (%session,Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!")
	
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		
		s pRowId=Obj.%Get("RowId")
		continue:pRowId=""
		
		s CleanBasketObj = ##class(User.CSSDBasketPackDetail).%OpenId(pRowId)
		s IsClean=CleanBasketObj.CSSDCBPIsClean
		i IsClean="Y"  d RtnObj.Err(-3,"","已清洗不能删除")
		q:RtnObj.success'=0
		
		&sql(delete from CSSD_BasketPackDetail where ID=:pRowId)
		i SQLCODE'=0 d RtnObj.Err(-2,pRowId,"删除清洗篮筐数据失败!:"_$ClassName()_".jsDelete:SQLCODE"_SQLCODE_":"_$g(%msg))
		q:RtnObj.success'=0
	}
	q RtnObj
}

/// CreatDate:2022.6.1
/// Description:清洗架中,添加普通循环包
/// Table:CSSD_BasketPackDetail
/// Return:日志信息
/// w ##class(web.CSSDHUI.Clean.CleanBasket).JsSaveCommonPackage(^tmpllkkll)
ClassMethod JsSaveCommonPackage(Params) As %Library.String
{
	n (%session,Params)
	s ^tmpllkkll=Params
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..SaveCommonPackage(Params)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// CreatDate:2022.6.1
/// Description:清洗架中,添加普通循环包
/// Table:CSSD_BasketPackDetail
ClassMethod SaveCommonPackage(Params) As web.CSSDHUI.RtnObj
{
	n (%session,Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	
	s pBasketLabel = PJObj.%Get("CleanBasket")
	s pCleanMachineId = PJObj.%Get("CleanMachine")
	s pPkgId = PJObj.%Get("CommonPkg")
	s pPkgNum = PJObj.%Get("ComPkgNum")
	
	s MachineId="",CleanDetailId="",BasketId=""
	f  s BasketId=$o(^User.CSSDBasketPackDetailI("CSSDCBPBSKLabelIsCleanIndex",pBasketLabel,"Y",BasketId)) q:(BasketId="")  d
	.s BasketObj = ##class(User.CSSDBasketPackDetail).%OpenId(BasketId)
	.d BasketObj.%Reload()
	.i $IsObject(BasketObj.CSSDCBPICleanDr) s CleanDetailId = BasketObj.CSSDCBPICleanDrGetObjectId()
	.q:CleanDetailId=""
	.
	.s Obj = ##class(User.CSSDCleanDetailPacks).%OpenId(CleanDetailId)
	.d Obj.%Reload()
	.s States=Obj.CSSDCDPStates
	.i States="" d RtnObj.Err(-1,"","该清洗架存在清洗未验收的明细,不能重复装载！")
	.q:RtnObj.success'=0
	q:RtnObj.success'=0 RtnObj	
	
	s DetailId=""
	s Regid=0
	f  s Regid=$o(^User.CSSDBasketPackDetailI("CSSDCBPBSKLabelPkgIsCleanIndex",pBasketLabel,pPkgId,"N",Regid)) q:(Regid="")||(DetailId'="")  d
	.s CleanDetailCbk=$List(^User.CSSDBasketPackDetailD(Regid),2)
	.q:CleanDetailCbk'=""	//手工添加的包与回收添加的单明细分开
	.s DetailId=Regid
	
	i DetailId'="" d
	.s BasketObj =##class(User.CSSDBasketPackDetail).%OpenId(DetailId)
	.d BasketObj.%Reload()
	.s Qty=BasketObj.CSSDCBPQty+pPkgNum
	.&sql(update CSSD_BasketPackDetail set CSSDCBP_Qty=:Qty where ID=:DetailId)
	e  d
	.&sql(INSERT INTO CSSD_BasketPackDetail (CSSDCBP_BSKLabel, CSSDCBP_Package_DR, CSSDCBP_Qty, CSSDCBP_IsClean,CSSDCBP_MachineNo_DR) VALUES (:pBasketLabel,:pPkgId,:pPkgNum,'N',:pCleanMachineId))
	.i SQLCODE'=0 d
	..d RtnObj.Err(-1,pBasketLabel,"加入清洗架失败!:"_$ClassName()_".jsSaveCleanBasket:SQLCODE"_SQLCODE_":"_$g(%msg))
	
	i RtnObj.success'=0 tro  q RtnObj
	q RtnObj
}

/// 取回收记录的清洗装车数量
/// w ##class(web.CSSDHUI.Clean.CleanInfo).GetCleanQtyByCB(1)
ClassMethod GetCleanQtyByCB(CallBackItmId)
{
	n (%session,CallBackItmId)
	q:CallBackItmId="" ""

	s SumCleanQty=0
	s CleanItmId=""
	f  s CleanItmId=$o(^User.CSSDBasketPackDetailI("CSSDCBPICallBackIndex",CallBackItmId,CleanItmId)) q:CleanItmId=""  d
	.s CleanQty=$lg(^User.CSSDBasketPackDetailD(CleanItmId),5)
	.s SumCleanQty=SumCleanQty+CleanQty
	
	q SumCleanQty
}

/// 取回收记录的清洗数量
/// w ##class(web.CSSDHUI.Clean.CleanInfo).GetCleanQtyByCB(1)
ClassMethod GetCleanQtyByCBClean(CallBackItmId)
{
	n (%session,CallBackItmId)
	q:CallBackItmId="" ""

	s SumCleanQty=0
	s CleanItmId=""
	f  s CleanItmId=$o(^User.CSSDCleanDetailPacksI("IndexCallBackDetailDr",CallBackItmId,CleanItmId)) q:CleanItmId=""  d
	.s CleanQty=$lg(^User.CSSDCleanDetailPacksD(CleanItmId),22)
	.s SumCleanQty=SumCleanQty+CleanQty
	
	q SumCleanQty
}

/// CreatDate:	2021-05-14
/// Description:根据已回收记录进行清洗装车
/// Input:		
/// Output:		
/// Return:		
/// w ##Class(web.CSSDHUI.Clean.CleanBasket).jsSaveUnCleanOrd("[{""CallBackItmId"":""54"",""PkgId"":""6"",""PkgDesc"":""美容大包"",""BackQty"":""2"",""CleanQty"":""0"",""UnCleanQty"":""2"",""MaterialId"":"""",""MaterialDesc"":"""",""ApplyLocDesc"":""手术室"",""CallBackNo"":""C20230410001"",""ReqLevel"":""0"",""BeInfected"":""N"",""SterType"":""高温灭菌"",""CodeDict"":""""},{""CallBackItmId"":""53"",""PkgId"":""9"",""PkgDesc"":""芒果包"",""BackQty"":""1"",""CleanQty"":""0"",""UnCleanQty"":""1"",""MaterialId"":""3"",""MaterialDesc"":""医用纸袋"",""ApplyLocDesc"":""手术室"",""CallBackNo"":""C20230410001"",""ReqLevel"":""0"",""BeInfected"":""N"",""SterType"":""高温灭菌"",""CodeDict"":""100009001""}]","{""CleanBasket"":""2"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2"",""CommonPkg"":"""",""ComPkgNum"":"""",""BarCode"":""""}")
ClassMethod jsSaveUnCleanOrd(Params, MainParams) As %Library.String
{
	n (%session,Params,MainParams)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s RtnObj=..SaveUnCleanOrd(Params,MainParams)
	q RtnObj.Json()
}

ClassMethod SaveUnCleanOrd(Params, MainParams) As web.CSSDHUI.RtnObj
{
	n (%session,Params,MainParams)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i MainParams="" q RtnObj.Err(-2,"","请选择清洗架")
	i RtnObj.success<0 q RtnObj
	
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"","入参解析失败!")
	
	s PJObjMain=##class(web.CSSDHUI.Common.FromJson).%New()
	s ScMain=PJObjMain.%FromJSON(MainParams)
	s pBasketLabel = PJObjMain.%Get("CleanBasket")
	s pCleanMachineId = PJObjMain.%Get("CleanMachine")

	s MachineId="",BasketId="",CleanDetailId=""
	f  s BasketId=$o(^User.CSSDBasketPackDetailI("CSSDCBPBSKLabelIsCleanIndex",pBasketLabel,"Y",BasketId)) q:BasketId=""  d
	.s BasketObj = ##class(User.CSSDBasketPackDetail).%OpenId(BasketId)
	.d BasketObj.%Reload()
	.i $IsObject(BasketObj.CSSDCBPICleanDr) s CleanDetailId = BasketObj.CSSDCBPICleanDr.%Id()
	.q:CleanDetailId=""
	.
	.s Obj = ##class(User.CSSDCleanDetailPacks).%OpenId(CleanDetailId)
	.d Obj.%Reload()
	.s States=Obj.CSSDCDPStates
	.i States="" d RtnObj.Err(-1,"","该清洗架存在清洗未验收的明细,不能重复装载！")
	.q:RtnObj.success'=0
	q:RtnObj.success'=0 RtnObj
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		
		s pCallBackItmId=Obj.%Get("CallBackItmId")
		s pPkgId=Obj.%Get("PkgId")
		s pBackQty=Obj.%Get("BackQty")
		s pWillQty=Obj.%Get("WillQty")
		s pMaterialId=Obj.%Get("MaterialId")
		s pReqLevel=Obj.%Get("ReqLevel")
		s pCodeDict=Obj.%Get("CodeDict")
		s CallBackMainId=$lg(^User.CSSDCallbackDetailNewD(pCallBackItmId),2)
		s CallBackCompFlag=$lg(^User.CSSDPackageCallbackD(CallBackMainId),14)
		s IsClean=$lg(^User.CSSDCallbackDetailNewD(pCallBackItmId),10)
		i IsClean="Y" d RtnObj.Err(-1,"","已加入清洗 请核实！")
		i CallBackCompFlag'="Y" d RtnObj.Err(-1,"","部分明细的回收单未提交!")
		continue:RtnObj.success'=0
		
		s CleanQty=..GetCleanQtyByCB(pCallBackItmId)
		s UnCleanQty=pBackQty-CleanQty
		i UnCleanQty<0 s UnCleanQty=0
		q:UnCleanQty=0
		
		i pWillQty="" s pWillQty=UnCleanQty
		i pWillQty>UnCleanQty d RtnObj.Err(-1,"","数量不能大于未装载的数量!")
		continue:RtnObj.success'=0
		
		s BasketId=""
		f  s BasketId=$o(^User.CSSDBasketPackDetailI("CSSDCBPBSKLabelIsCleanIndex",pBasketLabel,"N",BasketId)) q:(BasketId="")  d
		.s CBDetailId=$lg(^User.CSSDBasketPackDetailD(BasketId),2)
		.q:(CBDetailId'=pCallBackItmId)
		
		i BasketId="" d
		.s Obj=##class(User.CSSDBasketPackDetail).%New()
		.s Obj.CSSDCBPBSKLabel=pBasketLabel
		.d Obj.CSSDCBPPackageSetObjectId(pPkgId)
		.d Obj.CSSDCBPMachineNoDRSetObjectId(pCleanMachineId)
		.d Obj.CSSDCBPCallBackDetailDRSetObjectId(pCallBackItmId)
		.s Obj.CSSDCBPPackageLabel=pCodeDict
		e  d
		.s Obj=##class(User.CSSDBasketPackDetail).%OpenId(BasketId)
		s Obj.CSSDCBPQty=Obj.CSSDCBPQty+pWillQty
		s Obj.CSSDCBPIsClean="N"
		s Sc=Obj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-1,"","装载信息更新失败!") q
	}
	
	i RtnObj.success<0 tro  q RtnObj
	tc
	q RtnObj
}

}
