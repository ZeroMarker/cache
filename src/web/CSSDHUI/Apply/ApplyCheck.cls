Import SQLUSER

Class web.CSSDHUI.Apply.ApplyCheck Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// 确认 
/// w ##class(web.CSSDHUI.Apply.ApplyCheck).jsAudit()
ClassMethod jsAudit(Params As %String, main As %String) As %Library.String
{
	n (%session,Params,main)
	s $ZT=..sssError() 
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(main)
	i Sc'=0 q RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"入参解析失败!")).Json()
	s gUser=PJObj.%Get("gUserId")
	s gHospId = PJObj.%Get("gHospId")
	s gLocId = PJObj.%Get("gLocId")
	s gGroupId = PJObj.%Get("gGroupId")
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"入参解析失败!")).Json()
	
	s Param=gGroupId_"^"_gLocId_"^"_gUser_"^"_gHospId
	s IsCreateCallBack=##Class(web.CSSDHUI.Common.AppCommon).GetParamValue("CSSDCALLBACK","IsCreatCallBack",Param)
	
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		
		s RowId=Obj.%Get("RowId")
		s ApplyObj = ##class(User.CSSDPackageApply).%OpenId(RowId)
		continue:'$IsObject(ApplyObj)
		s ReqType=ApplyObj.CSSDPAType
		s ReqLevel=ApplyObj.CSSDPAReqLevel
		s ReqFlag = ApplyObj.CSSDPAFlag
		
		i ReqFlag'=1 d RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"只有提交状态的单据可以确认！"))
		continue:RtnObj.success<0
		
		&sql(update CSSD_PackageApply set CSSDPA_Flag = 5 where ID=:RowId)
		i SQLCODE'=0 d RtnObj.Err(-2,"",..%Translate($CLASSNAME(),"申请单状态更新失败！"))
		continue:RtnObj.success<0
		
		//自动生成回收单
		i ((ReqType=0)||(ReqType=4))&&(IsCreateCallBack="Y") d
		.s ApplyDetails=..GetApplyDetails(RowId)
		.s RtnObj=##Class(web.CSSDHUI.CallBack.CallBack).CreateCallBackByApply(main,ApplyDetails)
		.q:RtnObj.success'=0
		continue:RtnObj.success<0
	}
	i RtnObj.success<0 tro  q RtnObj.Json()
	
	tc
	q RtnObj.Json()
}

/// 根据请领主表Id获取明细表信息
/// d ##class(web.CSSDHUI.Apply.ApplyCheck).GetApplyDetails()
ClassMethod GetApplyDetails(RowId As %String) As %Library.String
{
	n (%session,RowId)
	q:RowId="" ""
	
	s ReqLevel=$lg(^User.CSSDPackageApplyD(RowId),14)
	
	s ItemData=""
	s DetailId=""
	f  s DetailId=$o(^User.CSSDPackageApplyDetailI("CSSDPADParrefIndex",RowId,DetailId)) q:DetailId=""  d
	.s ApplyDetailObj=##class(User.CSSDPackageApplyDetail).%OpenId(DetailId)
	.d ApplyDetailObj.%Reload()
	.s PackageDR=ApplyDetailObj.CSSDPADPackageDr.%Id()
	.s ReqQty=ApplyDetailObj.CSSDPADReqQty
	.s MaterialDr=ApplyDetailObj.CSSDPADMaterialDRGetObjectId()
	.s BarCode=ApplyDetailObj.CSSDPADBarCode
	.
	.s Title="RowId^PackageDR^ReqQty^MainId^MaterialId^NotQty^BarCode"
	.s Data=DetailId_"^"_PackageDR_"^"_ReqQty_"^"_RowId_"^"_MaterialDr_"^"_ReqQty_"^"_BarCode
	.s ItemDataD=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	.
	.i ItemData="" s ItemData=ItemDataD
	.e  s ItemData=ItemDataD_","_ItemData
	
	s ApplyDetails="["_ItemData_"]"
	q ApplyDetails
}

/// 取消确认 
/// d ##class(web.CSSDHUI.Apply.ApplyCheck).jsCancelAudit(^bintmp(95))
ClassMethod jsCancelAudit(Params As %String) As %Library.String
{
	n (%session,Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"入参解析失败!"))
	q:RtnObj.success'=0 RtnObj.Json()
	
	s UserId=$s($d(%session):%session.Data("LOGON.USERID"),1:"")
	
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		
		s RowId=Obj.%Get("RowId")
		s ApplyObj = ##class(User.CSSDPackageApply).%OpenId(RowId)
		continue:'$IsObject(ApplyObj)
		d ApplyObj.%Reload()
		s ReqFlag = ApplyObj.CSSDPAFlag
		s IsCount=ApplyObj.CSSDPAIsCount
		s SupLocId=ApplyObj.CSSDPALOCDRGetObjectId()
		
		s Param="^"_SupLocId_"^"_UserId
		s IsCreateCallBack=##Class(web.CSSDHUI.Common.AppCommon).GetParamValue("CSSDCALLBACK","IsCreatCallBack",Param)
		
		; 自动回收参数为Y && 只有1个回收单 && 回收单未提交 && 全部回收明细都对应, 则允许删除回收单
		s AutoCBFlag=""
		i (IsCreateCallBack'="Y") s AutoCBFlag="N"
		s ApplyCBCount=0
		s CBId=0
		f  s CBId=$o(^User.CSSDPackageCallbackI("CSSDPCPackageApplyIndex",RowId,CBId)) q:(CBId="")||(AutoCBFlag="N")  d
		.s ApplyCBCount=ApplyCBCount+1
		.i ApplyCBCount>1 s AutoCBFlag="N" q
		.s CompFlag=$lg(^User.CSSDPackageCallbackD(CBId),14)
		.i CompFlag="Y" s AutoCBFlag="N"
		i ApplyCBCount'=1 s AutoCBFlag="N"
		i AutoCBFlag="" d
		.s AutoCBFlag="Y"			;仅所有明细 回收数量=申请数量, 此值才设置为Y
		.s ApplyItmId=0
		.f  s ApplyItmId=$o(^User.CSSDPackageApplyDetailI("CSSDPADParrefIndex",RowId,ApplyItmId)) q:(ApplyItmId="")||(AutoCBFlag="N")  d
		..s CBQty=$lg(^User.CSSDPackageApplyDetailD(ApplyItmId),8)
		..s ApplyQty=$lg(^User.CSSDPackageApplyDetailD(ApplyItmId),11)
		..i CBQty'=ApplyQty s AutoCBFlag="N" q
		
		i (AutoCBFlag="Y")&&(ReqFlag'=5)&&(ReqFlag'=2) d RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"请核实单据状态！"))
		i (AutoCBFlag'="Y")&&(ReqFlag'=5) d RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"只有确认状态的单据可以取消确认！"))
		continue:RtnObj.success<0
		;i IsCount'="" d RtnObj.Err(-3,"",..%Translate($CLASSNAME(),"已经进行回收制单不能撤销！"))
		;continue:RtnObj.success<0
		s IsSendFlag=..IsSend(RowId)
		i IsSendFlag'="" d RtnObj.Err(-3,"",..%Translate($CLASSNAME(),"已经发放的单据不能撤销"))
		continue:RtnObj.success<0
		
		s CBId=$o(^User.CSSDPackageCallbackI("CSSDPCPackageApplyIndex",RowId,0))
		i (CBId'="")&&(AutoCBFlag="N") d
		.d RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"请先删除回收单，再取消确认！"))
		continue:RtnObj.success<0
		
		i (CBId'="")&&(AutoCBFlag="Y") d
		.s RtnObj=##class(web.CSSDHUI.CallBack.CallBack).Delete(CBId)
		continue:RtnObj.success<0
		
		&sql(update CSSD_PackageApply set CSSDPA_Flag = 1 where ID=:RowId)
		continue:RtnObj.success<0
	}
	i RtnObj.success<0 tro  q RtnObj.Json()
	
	tc
	q RtnObj.Json()
}

/// Description: 拒绝请领单
/// Creator:	 wb
/// CreatDate:	 2020-4-2
/// d ##class(web.CSSDHUI.Apply.ApplyCheck).jsRefuse
ClassMethod jsRefuse(Params As %String) As %Library.String
{
	n (%session,Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-1,"",..%Translate($CLASSNAME(),..%Translate($CLASSNAME(),"入参解析失败!")))
	q:RtnObj.success'=0 RtnObj.Json()
	
	ts
	while(RtnObj.success=0){
	 	s Obj=PJObj.%Pop()
		q:Obj=""
		
		s RowId=Obj.%Get("RowId")
		s RefuseReason=Obj.%Get("RefuseReason")
		
		s ApplyMainObj=##Class(User.CSSDPackageApply).%OpenId(RowId)
		i ApplyMainObj="" d RtnObj.Err(-1,"","单据不存在,请核实!","",0)
		continue:RtnObj.success<0
		d ApplyMainObj.%Reload()
		s ReqType=ApplyMainObj.CSSDPAType
		s ReqFlagNew=ApplyMainObj.CSSDPAFlag
		i ReqFlagNew'=1 d RtnObj.Err(-2,"",..%Translate($CLASSNAME(),"只有提交状态的单据可以拒绝！"))
		continue:RtnObj.success<0
		
		&sql(update CSSD_PackageApply
			set CSSDPA_Flag=8, CSSDPA_RefuseReason=:RefuseReason
			where ID=:RowId
		)
		i SQLCODE'=0 d RtnObj.Err(-1,"","更新单据状态失败!")
		continue:RtnObj.success'=0
	}
	i RtnObj.success<0 tro  q RtnObj.Json()
	
	tc
	q RtnObj.Json()
}

/// 根据请领主表判断是否发放明细
/// w ##class(web.CSSDHUI.Apply.ApplyCheck).IsSend(70)
ClassMethod IsSend(ApplyId As %String) As %String
{
	n (%session,ApplyId)
	s DispId=""
	s CallBackId=""
	f  s CallBackId=$o(^User.CSSDPackageCallbackI("CSSDPCPackageApplyIndex",ApplyId,CallBackId)) q:CallBackId=""  d
	.s CallBackItemRowId=""
	.f  s CallBackItemRowId=$o(^User.CSSDCallbackDetailNewI("CSSDCDParrefIndex",CallBackId,CallBackItemRowId)) q:CallBackItemRowId=""  d
	..s DispId=$o(^User.CSSDPackageDispI("CSSDPDCallBackDetailIndex",CallBackItemRowId,""))
	q DispId
}

/// Description:删除回收申请明细数据
/// d ##class(web.CSSDHUI.Apply.ApplyCheck).jsDeleteItm
ClassMethod jsDeleteItm(Params As %String) As %Library.String
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
		
		s RtnObj=..DeleteItm(RowId)
		continue:RtnObj.success<0
	}
	i RtnObj.success<0 tro  q RtnObj.Json()
	
	tc
	q RtnObj.Json()
}

/// Description:删除回收单申请明细(回收申请确认界面使用)
/// Input:		RowId:回收申请明细表id
ClassMethod DeleteItm(RowId As %String) As web.CSSDHUI.RtnObj
{
	n (%session,RowId)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i RowId="" q RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"入参不能为空!"))
	
	s ApplyId=$lg(^User.CSSDPackageApplyDetailD(RowId),3)
	i ApplyId="" q RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"入参异常!"))
	
	;只能删除 未提交/已提交 的,其他状态不允许删除
	s ApplyFlag=$lg(^User.CSSDPackageApplyD(ApplyId),9)
	i (ApplyFlag'=0)&&(ApplyFlag'=1) q RtnObj.Err(-2,"",..%Translate($CLASSNAME(),"请核实单据状态!"),"",0)
	
	&sql(Delete From CSSD_PackageApplyDetail WHERE ID=:RowId)
	i SQLCODE<0 q RtnObj.Err(-3,"",..%Translate($CLASSNAME(),"删除明细失败！"))
	
	&sql(Update CSSD_Trans_OP set CSSDTOP_PackageApplyDetailDR=NULL where CSSDTOP_PackageApplyDetailDR=:RowId)
	i SQLCODE<0 q RtnObj.Err(-4,"",..%Translate($CLASSNAME(),"更新消毒包追踪患者绑定表失败！"))
	q RtnObj
}

}
