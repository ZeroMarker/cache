Import sqluser

/// Creator:ban
/// CreatDate:2021.09.01
/// Description:借包单归还后台类方法
/// Table:CSSD_PackageApply
Class web.CSSDHUI.Apply.ReturnPackage Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Creator:ban
/// CreatDate:2021.09.01
/// Description:借包单归还查询方法
/// Table:CSSD_PackageApply
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Apply.ReturnPackage","SelectAll",^tmplljj)
Query SelectAll(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,ApplyNo,ApplyLocDr,ApplyLocDesc,ApplyUserDr,ApplyUserName,ApplyDate,ApplyTime,ReqTypeDesc,ReqType,ReqLevel,ReqLevelDesc,ApplyDateTime") [ SqlProc ]
{
}

ClassMethod SelectAllExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,%session,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 $$$OK
	s FReqLoc=PJObj.%Get("FReqLoc")
	s gLocId=PJObj.%Get("gLocId")
	q:FReqLoc="" $$$OK

	s Type="1"	//借包单
	s RowId=""
	f  s RowId=$o(^User.CSSDPackageApplyI("IndexApplyLocDrType",FReqLoc,Type,RowId)) q:RowId=""  d
	.s ApplyObj=##Class(User.CSSDPackageApply).%OpenId(RowId)
	.q:'$IsObject(ApplyObj)
	.s ApplyNo=ApplyObj.CSSDPANO
	.s ApplyLocDr=ApplyObj.CSSDPAAPPLYLOCDRGetObjectId()
	.s ApplyUserDr=ApplyObj.CSSDPAAPPLYUSERDRGetObjectId()
	.s ApplyDate=ApplyObj.CSSDPASubmitDate
	.s ApplyTime=ApplyObj.CSSDPASubmitTime
	.s ReqLevel=ApplyObj.CSSDPAReqLevel
	.s ReqType=ApplyObj.CSSDPAType
	.
	.q:ApplyLocDr=""
	.q:ApplyUserDr=""
	.
	.s ret=..IsReturnAll(RowId)
	.q:ret=0
	.
	.s ApplyLocDesc=..sssLocDesc(ApplyLocDr)
	.s ApplyUserName=..sssUserName(ApplyUserDr)
	.s ApplyDate=..DL2H(ApplyDate)
	.s ApplyTime=..TL2H(ApplyTime)
	.s ApplyDateTime=ApplyDate_" "_ApplyTime
	.s ReqTypeDesc=##class(web.CSSDHUI.Common.PackageInfoCommon).getReqTypeDesc(ReqType)
	.s ReqLevelDesc=##class(web.CSSDHUI.Common.PackageInfoCommon).getReqLevelDesc(ReqLevel)
	.
	.s Flag=""
	.s DetailId=""
	.f  s DetailId=$o(^User.CSSDPackageApplyDetailI("CSSDPADParrefIndex",RowId,DetailId)) q:DetailId=""  d
	..s DetailObj=##Class(User.CSSDPackageApplyDetail).%OpenId(DetailId)
	..q:'$IsObject(DetailObj)
	..s PackageDr=DetailObj.CSSDPADPackageDr.%Id()
	..s DispQty=..GetDispQty(DetailId)					;发放数
	..s CheckBackQty=..GetItmCheckBackQty(DetailId)		//回收制单后实际回收数（已归还数）
	..i (DispQty>CheckBackQty) s Flag=1
	.q:Flag=""
	.d OutPutRow
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,ApplyNo,ApplyLocDr,ApplyLocDesc,ApplyUserDr,ApplyUserName,
		ApplyDate,ApplyTime,ReqTypeDesc,ReqType,ReqLevel,ReqLevelDesc,ApplyDateTime)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creator:ban
/// CreatDate:2021.09.01
/// Description:判断单据是否全部归还
/// Table:CSSD_PackageApply
/// d ##class(web.CSSDHUI.Apply.ReturnPackage).IsReturnAll(97,"20211200029")
ClassMethod IsReturnAll(ApplyId As %String) As %Library.String
{
	n (%session,ApplyId)
	s ret=0
	s ApplyDetailId=""
	f  s ApplyDetailId=$o(^User.CSSDPackageApplyDetailI("CSSDPADParrefIndex",ApplyId,ApplyDetailId)) q:ApplyDetailId=""  d
	.s ApplyDetailObj=##class(User.CSSDPackageApplyDetail).%OpenId(ApplyDetailId)
	.q:ApplyDetailObj=""
	.d ApplyDetailObj.%Reload()
	.s ApplyQty=ApplyDetailObj.CSSDPADReqQty
	.s ApplyPackageDr=ApplyDetailObj.CSSDPADPackageDr.%Id()
	.s ApplyPackageDesc=ApplyDetailObj.CSSDPADPackageDr.CSSDPDesc
	.s ReturnQty=0
	.
	.;获取借包单对应的发放信息
	.s CallBackLendId=""
	.f  s CallBackLendId=$o(^User.CSSDPackageCallbackI("CSSDPCApplyComplateIndex",ApplyId,"W",CallBackLendId)) q:CallBackLendId=""  d
	..s CallBackLendDetailId=$o(^User.CSSDCallbackDetailNewI("CSSDCDParrefItmIndex",CallBackLendId,ApplyPackageDr,""))
	..s:CallBackLendDetailId="" ret=1
	.
	.;获取借包单对应的回收信息
	.s CallBackId=""
	.f  s CallBackId=$o(^User.CSSDPackageCallbackI("CSSDPCApplyComplateIndex",ApplyId,"Y",CallBackId)) q:CallBackId=""  d
	..s CallBackObj=##class(User.CSSDPackageCallback).%OpenId(CallBackId)
	..q:CallBackObj=""
	..d CallBackObj.%Reload()
	..s Flag=CallBackObj.CSSDPCComplateFlag
	..s CallBackNo=CallBackObj.CSSDPCSerialNo
	..s CallBackDetailId=$o(^User.CSSDCallbackDetailNewI("CSSDCDParrefItmIndex",CallBackId,ApplyPackageDr,""))
	..q:CallBackDetailId=""
	..s CallBackDetailObj=##class(User.CSSDCallbackDetailNew).%OpenId(CallBackDetailId)
	..q:CallBackDetailObj=""
	..d CallBackDetailObj.%Reload()
	..s:'$IsObject(CallBackDetailObj) ret=1
	..s ReturnQty=ReturnQty+CallBackDetailObj.CSSDCDQty	//归还数
	.i ((ReturnQty=0)&&(ApplyQty'=ReturnQty)) s ret=1 q:ret
	.i ((ReturnQty>0)&&(ApplyQty'=ReturnQty)) s ret=2 q:ret
	q:ret=2 ret	//部分归还，未全部归还
	q ret
}

/// Creator:ban
/// CreatDate:2021.09.01
/// Description:借包单归还查询方法
/// Table:CSSD_PackageApply
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Apply.ReturnPackage","SelectDetail","118")
Query SelectDetail(MainId As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,PackageDr,PackageDesc,CodeDict,MaterialDr,MaterialName,ReqQty:%Float,DispQty:%Float,ApplyBackQty:%Float,ReturnQty:%Float,CheckBackQty:%Float") [ SqlProc ]
{
}

ClassMethod SelectDetailExecute(ByRef qHandle As %Binary, MainId As %String) As %Status
{
	n (qHandle,%session,MainId)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s ApplyDetailId=""
	f  s ApplyDetailId=$o(^User.CSSDPackageApplyDetailI("CSSDPADParrefIndex",MainId,ApplyDetailId)) q:ApplyDetailId=""  d
	.s ApplyDetailObj=##class(User.CSSDPackageApplyDetail).%OpenId(ApplyDetailId)
	.d ApplyDetailObj.%Reload()
	.s PackageDr=ApplyDetailObj.CSSDPADPackageDr.%Id()
	.s PackageDesc=ApplyDetailObj.CSSDPADPackageDr.CSSDPDesc
	.s ReqQty=ApplyDetailObj.CSSDPADReqQty
	.s MaterialObj=ApplyDetailObj.CSSDPADMaterialDR
	.
	.s PackageDesc=..%FieldTranslate("User.CSSDPackage","CSSDPDesc",PackageDesc)
	.s (MaterialDr,MaterialName)=""
	.i $IsObject(MaterialObj) d
	..s MaterialDr=MaterialObj.%Id()
	..s MaterialName=MaterialObj.CSSDMDesc
	..s MaterialName=..%FieldTranslate("User.CSSDMaterial","CSSDMDesc",MaterialName)
	.
	.;若发放中包含标签,则分别按标签输出
	.s CodeDictStr=..GetDispCodeDict(ApplyDetailId)
	.i CodeDictStr'="" d
	..s Len=$l(CodeDictStr,"^")
	..f i=1:1:Len d
	...s CodeDict=$p(CodeDictStr,"^",i)
	...s DispQty=1
	...s ApplyBackQty=..GetApplyReturnQty(ApplyDetailId,CodeDict)
	...s CheckBackQty=..GetItmCheckBackQty(ApplyDetailId,CodeDict)
	...s ReturnQty=DispQty-CheckBackQty-ApplyBackQty
	...d OutPutDetailRow
	.e  d
	..;非标牌
	..s CodeDict=""
	..s DispQty=..GetDispQty(ApplyDetailId)							//发放数量
	..s ApplyBackQty=..GetApplyReturnQty(ApplyDetailId,CodeDict)	//已申请归还单（待回收数）
	..s CheckBackQty=..GetItmCheckBackQty(ApplyDetailId,CodeDict)	//回收制单后实际回收数（已归还数）
	..s ReturnQty=DispQty-CheckBackQty-ApplyBackQty					//待申归还
	..q:DispQty=CheckBackQty
	..
	..d OutPutDetailRow
	Quit $$$OK
OutPutDetailRow
	s Data=$lb(ApplyDetailId,PackageDr,PackageDesc,CodeDict,MaterialDr,MaterialName,
		ReqQty,DispQty,ApplyBackQty,ReturnQty,CheckBackQty)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Description:根据借包单明细Id,获取发放的标牌信息
/// Input:		ApplyItmId-借包单明细id
/// Output:		标牌字符串(^分隔)
/// w ##class(web.CSSDHUI.Apply.ReturnPackage).GetDispCodeDict(110)
ClassMethod GetDispCodeDict(ApplyItmId)
{
	n (%session,ApplyItmId)
	q:ApplyItmId="" ""
	
	s CodeDictStr=""
	s CBItmId=0
	f  s CBItmId=$o(^User.CSSDCallbackDetailNewI("CSSDCDPackageApplyDetailDRIndex",ApplyItmId,CBItmId)) q:CBItmId=""  d
	.s DispItmId=0
	.f  s DispItmId=$o(^User.CSSDPackageDispI("CSSDPDCallBackDetailIndex",CBItmId,DispItmId)) q:DispItmId=""  d
	..s DispDetailId=0
	..f  s DispDetailId=$o(^User.CSSDPackageDispDetailI("CSSDPDDParref",DispItmId,DispDetailId)) q:DispDetailId=""  d
	...s Label=$lg(^User.CSSDPackageDispDetailD(DispDetailId),3)
	...q:Label=""
	...s CodeDict=##class(web.CSSDHUI.Common.PackageInfoCommon).GetFixedLabel(Label)
	...q:CodeDict=""
	...i CodeDictStr="" s CodeDictStr=CodeDict
	...e  s CodeDictStr=CodeDictStr_"^"_CodeDict
	
	q CodeDictStr
}

/// Description:根据借包单明细Id,获取生成的归还单的已归还数量
/// Input:		ApplyItmId-借包单明细id
/// Output:		标牌字符串(^分隔)
/// w ##class(web.CSSDHUI.Apply.ReturnPackage).GetItmCheckBackQty(58)
ClassMethod GetItmCheckBackQty(ApplyDetailId, CodeDict = "")
{
	n (%session,ApplyDetailId,CodeDict)
	q:ApplyDetailId="" ""
	s MainId=$lg(^User.CSSDPackageApplyDetailD(ApplyDetailId),3)
	s PackageDr=$lg(^User.CSSDPackageApplyDetailD(ApplyDetailId),4)
	q:(MainId="")||(PackageDr="") ""

	s CheckBackQty=0
	;已归还应该取所有关联单据的数量
	s CBId=""
	f  s CBId=$o(^User.CSSDPackageCallbackI("CSSDPCLendNOIndex",MainId,CBId)) q:CBId=""  d
	.s CallBackObj=##class(User.CSSDPackageCallback).%OpenId(CBId)
	.q:'$IsObject(CallBackObj)
	.s ComplateFlag=CallBackObj.CSSDPCComplateFlag
	.q:ComplateFlag="W"		//默认生成的借包回收单需要过滤掉
	.;这里按照 借包单/归还单过滤, 是不是更合适?
	.
	.s CBItmId=""
	.f  s CBItmId=$o(^User.CSSDCallbackDetailNewI("CSSDCDParrefItmIndex",CBId,PackageDr,CBItmId)) q:CBItmId=""  d
	..s Qty=$lg(^User.CSSDCallbackDetailNewD(CBItmId),4)
	..s CBCodeDict=$lg(^User.CSSDCallbackDetailNewD(CBItmId),9)
	..q:(CodeDict'="")&&(CBCodeDict'=CodeDict)
	..s CheckBackQty=CheckBackQty+Qty
	q CheckBackQty
}

/// 获取生成的归还单对应的包 已申请待回收（待回收数）
/// 2023-04:去除MainId/PackageDr参数, 补充CodeDict参数
/// w ##class(web.CSSDHUI.Apply.ReturnPackage).GetApplyReturnQty(111)
ClassMethod GetApplyReturnQty(ApplyDetailId, CodeDict = "")
{
	n (%session,ApplyDetailId,CodeDict)
	q:(ApplyDetailId="") ""
	s MainId=$lg(^User.CSSDPackageApplyDetailD(ApplyDetailId),3)
	s PackageDr=$lg(^User.CSSDPackageApplyDetailD(ApplyDetailId),4)
	q:(MainId="")||(PackageDr="") ""
	
	s ApplyBackQty=0
	;已归还应该取所有关联单据的数量
	s ApplyRowId=""
	f  s ApplyRowId=$o(^User.CSSDPackageApplyI("IndexLendNO",MainId,ApplyRowId)) q:ApplyRowId=""  d
	.s DetailId=""
	.f  s DetailId=$o(^User.CSSDPackageApplyDetailI("CSSDPADParrefPackageDrIndex",ApplyRowId,PackageDr,DetailId)) q:DetailId=""  d
	..s ApplyDetailData=$g(^User.CSSDPackageApplyDetailD(DetailId))
	..s Qty=$lg(ApplyDetailData,11)
	..s BackQty=$lg(ApplyDetailData,8)
	..s ApplyCodeDict=$lg(ApplyDetailData,28)
	..
	..q:BackQty>0
	..q:(CodeDict'="")&&(ApplyCodeDict'=CodeDict)
	..s ApplyBackQty=ApplyBackQty+Qty
	
	q ApplyBackQty
}

/// w ##class(web.CSSDHUI.Apply.ReturnPackage).GetDispQty(110)
ClassMethod GetDispQty(ApplyItmId)
{
	n (%session,ApplyItmId)
	q:ApplyItmId="" ""
	s TotalDispQty=0
	s CBItmId=0
	f  s CBItmId=$o(^User.CSSDCallbackDetailNewI("CSSDCDPackageApplyDetailDRIndex",ApplyItmId,CBItmId)) q:CBItmId=""  d
	.s DispItmId=0
	.f  s DispItmId=$o(^User.CSSDPackageDispI("CSSDPDCallBackDetailIndex",CBItmId,DispItmId)) q:DispItmId=""  d
	..s DispQty=$lg(^User.CSSDPackageDispD(DispItmId),7)
	..s TotalDispQty=TotalDispQty+DispQty
	q TotalDispQty
}

/// Creator:zn
/// CreatDate:2020.06.02
/// Description:根据借包单制作归还单
/// w ##class(web.CSSDHUI.Apply.ReturnPackage).jsCreateReturnPkg("[{""RowId"":""2"",""PackageDr"":""71"",""PackageDesc"":""护理包"",""DispQty"":""6"",""CallBackQty"":""3"",""ReturnQty"":""3"",""MaterialDr"":""7@User.CSSDMaterial"",""MaterialName"":""测试2""}]","1")
ClassMethod jsCreateReturnPkg(DetailRows, Params) As %Library.String
{
	n (%session,DetailRows,Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s RtnObj=..CreateReturnPkg(DetailRows,Params)
	q RtnObj.Json()
}

ClassMethod CreateReturnPkg(DetailRows, Params) As web.CSSDHUI.RtnObj
{
	n (%session,DetailRows,Params)

	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i ((Params="")||(DetailRows="")) q RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"入参不能为空!"))

	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(DetailRows)
	s PJMainObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s ScMain=PJMainObj.%FromJSON(Params)
	i ((ScMain'=0)||(Sc'=0)) q RtnObj.Err(-2,"",..%Translate($CLASSNAME(),"入参解析失败!"))
	
	s CreateUser=PJMainObj.%Get("gUserId")
	s MainId=PJMainObj.%Get("MainId")

	s ApplyObj=##class(User.CSSDPackageApply).%OpenId(MainId)
	i '$IsObject(ApplyObj) q RtnObj.Err(-2,"",..%Translate($CLASSNAME(),"借包单不存在,清核实!"))
	
	d ApplyObj.%Reload()
	s ReqLoc=ApplyObj.CSSDPAAPPLYLOCDRGetObjectId()
	s fromLoc = ApplyObj.CSSDPALOCDRGetObjectId()
	s reqlevel=ApplyObj.CSSDPAReqLevel
	;s LendNo=ApplyObj.CSSDPANO

	;检查科室所在线路是否在允许时间段内
	s PermitFlag=##class(web.CSSDHUI.System.SendRoadLine).CheckLocTime(ReqLoc,$p($h,",",2),fromLoc)
	i PermitFlag.success'=0 q RtnObj.Err(-6,"",..%Translate($CLASSNAME(),PermitFlag.msg))

	s ret=..sssLock("Apply")
	s No=##class(web.CSSDHUI.Common.AppCommon).GetAppNo("Apply")
	i No="" d ..sssUnLock("Apply") d RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"生成请领单号失败！"))

	i reqlevel="" s reqlevel=0
	s usedate=+$h
	s Flag=0
	s type="4"
	s CreateDate=+$h

	ts
	&sql(insert into cssd_packageapply
		(CSSDPA_No,CSSDPA_Date,CSSDPA_APPLYLOCDR,CSSDPA_ReqLevel,CSSDPA_UseDate,
		CSSDPA_Flag,CSSDPA_Type,CSSDPA_LOCDR,CSSDPA_LendNO,CSSDPA_CreateUser,CSSDPA_CreateDate)
		values
		(:No,null,:ReqLoc,:reqlevel,:usedate,
		:Flag,:type,:fromLoc,:MainId,:CreateUser,:CreateDate)
	)
	d ..sssUnLock("Apply")
	i SQLCODE tro  q RtnObj.Err(-3,"",$ClassName()_"Insert:"_..%Translate($CLASSNAME(),"新增请领数据失败！"))
	s MainRowid=%ROWID

	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""

		s RowId=Obj.%Get("RowId")
		s PackageDr=Obj.%Get("PackageDr")
		s CodeDict=Obj.%Get("CodeDict")
		s ReturnQty=Obj.%Get("ReturnQty")
		s MaterialDr=Obj.%Get("MaterialDr")

		;检查标牌是否存在于其他单据中
		i CodeDict'="" d
		.s TransId=$o(^User.CSSDTransI("CodeDict",CodeDict,""),-1)
		.s CheckFlag=""
		.s ApplyId=""
		.f  s ApplyId=$o(^User.CSSDPackageApplyDetailI("BarCodeParref",CodeDict,ApplyId),-1) q:(ApplyId="")||(CheckFlag="Y")  d
		..s ApplyNo=$lg(^User.CSSDPackageApplyD(ApplyId),5)
		..s ApplyLocId=$lg(^User.CSSDPackageApplyD(ApplyId),7)
		..s ApplyFlag=$lg(^User.CSSDPackageApplyD(ApplyId),9)
		..q:(ReqLoc'=ApplyLocId)
		..s CheckFlag="Y"
		..q:(TransId'="")&&(",0,1,5,"'[ApplyFlag)	;存在已经处理的回收申请，结束循环,不记录RtnObj
		..q:(TransId="")&&(",0,1,5,2,"'[ApplyFlag)
		..d RtnObj.Err(-3,"",CodeDict_..%Translate($CLASSNAME(),"该标牌已存在于其他单据中:")_ApplyNo,"",0)
		continue:RtnObj.success<0

		s UnReturnQty=..GetLendNoQtyInfo(MainId,PackageDr)
		i ReturnQty>UnReturnQty d RtnObj.Err(-4,"",..%Translate($CLASSNAME(),"归还数量超过待归还数量"))
		continue:RtnObj.success'=0

		s MaterialInfo=##class(web.CSSDHUI.Common.PackageInfoCommon).GetMaterialExpireLength(MaterialDr,PackageDr)
		s Price=+$p(MaterialInfo,"^",2)

		s itmobj=##class(User.CSSDPackageApplyDetail).%New()
		s itmobj.CSSDPADParref=MainRowid
		d itmobj.CSSDPADPackageDrSetObjectId(PackageDr)
		s itmobj.CSSDPADBarCode=CodeDict
		s itmobj.CSSDPADReqQty=ReturnQty
		s itmobj.CSSDPADBackQty=0
		s itmobj.CSSDPADOutQty=0
		s itmobj.CSSDPADPrice=Price
		d itmobj.CSSDPADMaterialDRSetObjectId(MaterialDr)
		s Sc=itmobj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-4,"",$ClassName()_"jsSave:"_..%Translate($CLASSNAME(),"明细数据保存失败!"))
		continue:RtnObj.success'=0
	}
	i RtnObj.success'=0 tro  q RtnObj

	tc
	s RtnObj.rowid=MainRowid
	q RtnObj
}

/// 获取一个借包单某个消毒包信息(可归还数量)
/// why20220311
/// w ##class(web.CSSDHUI.Apply.ReturnPackage).GetLendNoQtyInfo("20220300031","154")
ClassMethod GetLendNoQtyInfo(MainId, PkgDr) As %Library.String
{
	n (%session,MainId,PkgDr)
	s (ApplyBackQty,CheckBackQty,ReturnQty)=0
	s ApplyDetailId=$o(^User.CSSDPackageApplyDetailI("CSSDPADParrefPackageDrIndex",MainId,PkgDr,""))
	q:ApplyDetailId="" ""
	s ApplyDetailObj=##class(User.CSSDPackageApplyDetail).%OpenId(ApplyDetailId)
	d ApplyDetailObj.%Reload()
	s ApplyObj=##Class(User.CSSDPackageApply).%OpenId(MainId)
	s LendNo=ApplyObj.CSSDPANO
	s PackageDr=ApplyDetailObj.CSSDPADPackageDr.%Id()
	s PackageDesc=ApplyDetailObj.CSSDPADPackageDr.CSSDPDesc
	s ReqQty=ApplyDetailObj.CSSDPADReqQty
	s DispQty=..GetDispQty(ApplyDetailId)						//发放数量
	s ApplyBackQty=..GetApplyReturnQty(ApplyDetailId)			//已归还数量
	s CheckBackQty=..GetItmCheckBackQty(ApplyDetailId)			//回收制单后实际回收数
	s ReturnQty=DispQty-ApplyBackQty							//待归还数按申请数量
	q ReturnQty
}

/// Description:计算界面角标数量
/// Creator:lxt
/// Date:20220318
/// Table:
/// Input:Params
/// Output:Json
ClassMethod GetMarkQty(Params)
{
	n (%session,Params)
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q "{}"

	s ReturnNum=0
	s ReturnResult=##class(%Library.ResultSet).%New("web.CSSDHUI.Apply.ReturnPackage:SelectAll")
	s sc=ReturnResult.Execute(Params)
	i $$$ISERR(sc) q "{}"
	While(ReturnResult.Next()){s ReturnNum=ReturnNum+1}
	d ReturnResult.Close()

	s RetData=ReturnNum
	s RetTitle="ReturnNum"
	s Ret=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(RetData,RetTitle)

	q Ret
}

}
