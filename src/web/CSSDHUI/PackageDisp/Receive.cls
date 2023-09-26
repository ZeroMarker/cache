Import sqluser

/// CreatDate:2023-02-23
/// Description:消毒包接收后台类
Class web.CSSDHUI.PackageDisp.Receive Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Creator:ban
/// CreatDate:2022-2-22
/// Description:扫码接收-消毒包接收界面-批量接收按钮  
/// Table:CSSD_PackageDispMain
/// 消毒包接收界面-批量接收按钮  
/// d ##class(web.CSSDHUI.PackageDisp.Receive).jsReceAll(52,13320)
ClassMethod jsReceAll(Params As %String, UserId) As %Library.String
{
	n (Params,UserId)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i UserId="" q RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"入参不能为空!")).Json()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"入参解析失败!")).Json()
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s DispMainId=Obj.RowId
		s RtnObj=..ReceOrder(DispMainId,UserId)
		q:RtnObj.success'=0
	}
	i RtnObj.success<0 tro  q RtnObj.Json()
	
	tc
	q RtnObj.Json()
}

/// Creator:ban
/// CreatDate:2022-2-22
/// Description:扫码接收-消毒包接收界面-接收按钮  
/// Table:CSSD_PackageDispMain
/// 消毒包接收界面-接收按钮  
/// w ##class(web.CSSDHUI.PackageDisp.Receive).jsReceOrder("11","1")
ClassMethod jsReceOrder(DispMainId As %String, UserId) As %Library.String
{
	n (DispMainId,UserId)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i DispMainId="" q RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"入参不能为空!")).Json()
	ts
	s RtnObj=..ReceOrder(DispMainId,UserId)
	i RtnObj.success<0 tro  q RtnObj.Json()
	
	tc
	q RtnObj.Json()
}

ClassMethod ReceOrder(DispMainId As %String, UserId) As web.CSSDHUI.RtnObj
{
	n (DispMainId,UserId)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s MainObj=##Class(User.CSSDPackageDispMain).%OpenId(DispMainId)
	d MainObj.%Reload()
	s ComplateFlag=MainObj.CSSDPDMComplateFlag
	s ToUserDr=MainObj.CSSDPDMToUserDr
	s ReceDate=MainObj.CSSDPDMRecDate
	s IsRec=MainObj.CSSDPDMIsRec
	s Type=MainObj.CSSDPDMType
	s DocType=MainObj.CSSDPDMDocType
	s RecLocId=MainObj.CSSDPDMToLocDr.%Id()
	s CallbackDr=""
	s CallBackObj=MainObj.CSSDPDMCallBackDr
	s:$IsObject(CallBackObj) CallbackDr=CallBackObj.%Id()
	s ApplyDr=""
	s:CallbackDr'="" ApplyDr=$lg(^User.CSSDPackageCallbackD(CallbackDr),24)
	i ComplateFlag'="Y" q RtnObj.Err(-2,"",..%Translate($CLASSNAME(),"未提交不能接收"),"",0)
	i ((ToUserDr'="")||(ReceDate'="")) q RtnObj.Err(-3,"",..%Translate($CLASSNAME(),"已经接收不能重复接收"),"",0)
	
	s sdate=$zdt($h,3)
	s RecDate=$P($h,",",1),RecTime=$P($h,",",2)
	&sql(update CSSD_PackageDispMain set CSSDPDM_IsRec='Y',CSSDPDM_RecStatu='1',CSSDPDM_ToUser_DR=:UserId,
		CSSDPDM_RecDate=:sdate,CSSDPDM_ReceiveDate=:RecDate,CSSDPDM_ReceiveTime=:RecTime
		WHERE ID=:DispMainId
	)
	i SQLCODE'=0 d
	.d RtnObj.Err(-5,"",$ClassName()_"jsReceOrder:"_..%Translate($CLASSNAME(),"更新失败!"))
	q:RtnObj.success'=0 RtnObj
	
	i (ApplyDr'="")&&(DocType'=1) d
	.&sql(update CSSD_PackageApply set CSSDPA_Flag='6' WHERE ID=:ApplyDr)
	.i SQLCODE'=0 d RtnObj.Err(-6,"",..%Translate($CLASSNAME(),"更新CSSD_PackageApply失败!"))
	q:RtnObj.success'=0 RtnObj
	
	s ItemRowId=""
	f  s ItemRowId=$o(^User.CSSDPackageDispI("CSSDPDCParrefDr",DispMainId,ItemRowId)) q:((ItemRowId="")||(RtnObj.success'=0))  d
	.s ItemObj=##Class(User.CSSDPackageDisp).%OpenId(ItemRowId)
	.d ItemObj.%Reload()
	.q:'$IsObject(ItemObj)
	.s DispQty=ItemObj.CSSDPDQty
	.s PkgId=ItemObj.CSSDPDPackageGetObjectId()
	.i Type="Y" d
	..s Label=ItemObj.CSSDPDLabel
	..s toUser=ItemObj.CSSDPDToUserDr
	..s:toUser'="" DispQty=DispQty-1
	..q:toUser'=""		//解决如果单据有一个接收全部接收会报错
	..s RtnObj=..ReceiveLabel(Label,UserId,Type)
	..q:RtnObj.success'=0
	.e  d
	..s DetailRowId = ""
	..f  s DetailRowId=$o(^User.CSSDPackageDispDetailI("CSSDPDDParref",ItemRowId,DetailRowId)) q:((DetailRowId="")||(RtnObj.success'=0))  d
	...s DetailObj=##Class(User.CSSDPackageDispDetail).%OpenId(DetailRowId)
	...d DetailObj.%Reload()
	...q:'$IsObject(DetailObj)
	...s DetailLabel=DetailObj.CSSDPDDLabel
	...s DetailToUser=DetailObj.CSSDPDRecUser
	...s:DetailToUser'="" DispQty=DispQty-1
	...q:DetailToUser'=""		//解决如果单据有一个接收全部接收会报错
	...s RtnObj=..ReceiveLabel(DetailLabel,UserId,Type)
	...q:RtnObj.success'=0
	.q:RtnObj.success'=0
	.i DispQty>0 d
	..s RtnObj=##class(web.CSSDHUI.System.LocPackageStock).UpdateCurQty(RecLocId,PkgId,DispQty)
	q:RtnObj.success'=0 RtnObj
	
	q RtnObj
}

/// Creator:ban
/// CreatDate:2022-02-22
/// Description:按照单据接收，接收单据中的每个消毒包
/// Table:CSSD_PackageDisp
/// d ##class(web.CSSDHUI.PackageDisp.Receive).ReceiveLabel("71","95")
ClassMethod ReceiveLabel(Label As %String, UserId As %String, Type As %String) As web.CSSDHUI.RtnObj
{
	n (Label,UserId,Type)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i Label="" d RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"入参不能为空!"))
	q:RtnObj.success'=0 RtnObj
	
	s rcvDt=$zdt($h,3)
	s ReceiveDate=$p($h,",",1)
	s ReceiveTime=$p($h,",",2)
	
	s ItemId="",RecLocId=""
	i Type="Y" d
	.s ItemId =$o(^User.CSSDPackageDispI("CSSDPDLabel",Label,""),-1)
	.i ItemId="" d RtnObj.Err(-2,"",..%Translate($CLASSNAME(),"标签号为")_Label_..%Translate($CLASSNAME(),"的消毒包未发放!"),"",0)
	.q:RtnObj.success'=0
	.s dispInfo=##Class(User.CSSDPackageDisp).%OpenId(ItemId)
	.d dispInfo.%Reload()
	.s toUser=dispInfo.CSSDPDToUserDr
	.s RecLocId=dispInfo.CSSDPDToLocDrGetObjectId()
	.i toUser'="" d RtnObj.Err(-3,"",..%Translate($CLASSNAME(),"标签号为")_Label_..%Translate($CLASSNAME(),"的消毒包已经接收不能重复接收!"),"",0)
	.q:RtnObj.success'=0
	e  d
	.s DispDetailId =$o(^User.CSSDPackageDispDetailI("CSSDPDDLabelIndex",Label,""),-1)
	.i DispDetailId="" d RtnObj.Err(-2,"",..%Translate($CLASSNAME(),"标签号为")_Label_..%Translate($CLASSNAME(),"的消毒包未发放!"),"",0)
	.q:RtnObj.success'=0
	.s DetailObj=##class(User.CSSDPackageDispDetail).%OpenId(DispDetailId)
	.s ItemId =DetailObj.CSSDPDDParrefDr.%Id()
	.s RecLocId=DetailObj.CSSDPDDParrefDr.CSSDPDToLocDrGetObjectId()
	.&sql(update CSSD_PackageDispDetail set CSSDPD_RecUser_DR=:UserId where CSSDPDD_Rowid=:DispDetailId )
	.i SQLCODE'=0  d
	..d RtnObj.Err(-4,"",$ClassName()_"ReceiveLabel:"_..%Translate($CLASSNAME(),"此明细接收失败!"))
	.q:RtnObj.success'=0
	q:RtnObj.success'=0 RtnObj
	
	&sql(update cssd_packagedisp set CSSDPD_ToUser_DR=:UserId,CSSDPD_RecDate=:rcvDt,CSSDPD_ReceiveDate=:ReceiveDate,CSSDPD_ReceiveTime=:ReceiveTime where CSSDPD_Rowid=:ItemId )
	i SQLCODE'=0  d
	.d RtnObj.Err(-4,"",$ClassName()_"ReceiveLabel:"_..%Translate($CLASSNAME(),"此明细接收失败!"))
	q:RtnObj.success'=0 RtnObj
	
	&sql(update cssd_trans set cssdt_status='R',CSSDT_CurrLoc_DR=:RecLocId where cssdt_label=:Label )
	i SQLCODE'=0  d
	.d RtnObj.Err(-5,"",$ClassName()_"ReceiveLabel:"_..%Translate($CLASSNAME(),"改条码修改接收状态失败!"))
	q:RtnObj.success'=0 RtnObj
	
	s RtnObj=##class(web.CSSDHUI.PackageDisp.DispItm).UpdateWLStatus(Label,"R")
	q:RtnObj.success'=0 RtnObj
	
	q RtnObj
}

/// Creator:why
/// CreatDate:2022-4-14
/// Description:取消接收-消毒包接收界面-取消接收按钮  
/// Table:CSSD_PackageDispMain
/// 消毒包接收界面-取消接收按钮  
/// w ##class(web.CSSDHUI.PackageDisp.Receive).jsReceOrder("57","11889")
ClassMethod jsCanlRecOrder(DispMainId As %String, UserId) As %Library.String
{
	n (DispMainId,UserId)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i DispMainId="" q RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"入参不能为空!")).Json()
	ts
	s RtnObj=..CanlReceOrder(DispMainId,UserId)
	i RtnObj.success<0 tro  q RtnObj.Json()
	
	tc
	q RtnObj.Json()
}

ClassMethod CanlReceOrder(DispMainId As %String, UserId) As web.CSSDHUI.RtnObj
{
	n (DispMainId,UserId)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s MainObj=##Class(User.CSSDPackageDispMain).%OpenId(DispMainId)
	s ComplateFlag=MainObj.CSSDPDMComplateFlag
	s ToUserDr=MainObj.CSSDPDMToUserDr
	s ReceDate=MainObj.CSSDPDMRecDate
	s RecevDate=MainObj.CSSDPDMReceiveDate
	s IsRec=MainObj.CSSDPDMIsRec
	s Type=MainObj.CSSDPDMType
	s DocType=MainObj.CSSDPDMDocType
	s RecLocId=MainObj.CSSDPDMToLocDr.%Id()
	s CallbackDr=MainObj.CSSDPDMCallBackDrGetObjectId()

	s RtnObj=..CheckBeforeCancel(DispMainId)
	q:RtnObj.success<0 RtnObj
	
	s ApplyDr=""
	s:CallbackDr'="" ApplyDr=$lg(^User.CSSDPackageCallbackD(CallbackDr),24)
	
	&sql(update CSSD_PackageDispMain set CSSDPDM_IsRec='N',CSSDPDM_RecStatu=null,CSSDPDM_ToUser_DR=null,
		CSSDPDM_RecDate=null,CSSDPDM_ReceiveDate=null,CSSDPDM_ReceiveTime=null
		WHERE ID=:DispMainId
	)
	&sql(update CSSD_PackageDisp set CSSDPD_RecDate=null,CSSDPD_ReceiveDate=null,CSSDPD_ReceiveTime=null
		WHERE CSSDPD_Parref_DR=:DispMainId
	)
	i SQLCODE'=0 d
	.d RtnObj.Err(-4,"",$ClassName()_"CanlReceOrder:"_..%Translate($CLASSNAME(),"更新失败!"))
	q:RtnObj.success'=0 RtnObj
	
	i (ApplyDr'="")&&(DocType'=1) d
	.&sql(update CSSD_PackageApply set CSSDPA_Flag='3' WHERE ID=:ApplyDr)
	.i SQLCODE'=0 d RtnObj.Err(-5,"","CSSD_PackageApply"_..%Translate($CLASSNAME(),"更新失败!"))
	q:RtnObj.success'=0 RtnObj
	
	s ItemRowId=""
	f  s ItemRowId=$o(^User.CSSDPackageDispI("CSSDPDCParrefDr",DispMainId,ItemRowId)) q:((ItemRowId="")||(RtnObj.success'=0))  d
	.s ItemObj=##Class(User.CSSDPackageDisp).%OpenId(ItemRowId)
	.d ItemObj.%Reload()
	.q:'$IsObject(ItemObj)
	.s PkgId=ItemObj.CSSDPDPackageGetObjectId()
	.s DispQty=ItemObj.CSSDPDQty
	.i Type="Y" d
	..s Label=ItemObj.CSSDPDLabel
	..s toUser=ItemObj.CSSDPDToUserDr
	..q:toUser=""		//解决如果单据有一个接收全部接收会报错
	..s RtnObj=..CanlReceiveLabel(Label,UserId,Type)
	..q:RtnObj.success'=0
	.e  d
	..s DetailRowId = ""
	..f  s DetailRowId=$o(^User.CSSDPackageDispDetailI("CSSDPDDParref",ItemRowId,DetailRowId)) q:((DetailRowId="")||(RtnObj.success'=0))  d
	...s DetailObj=##Class(User.CSSDPackageDispDetail).%OpenId(DetailRowId)
	...d DetailObj.%Reload()
	...q:'$IsObject(DetailObj)
	...s DetailLabel=DetailObj.CSSDPDDLabel
	...s DetailToUser=DetailObj.CSSDPDRecUser
	...q:DetailToUser=""		//解决如果单据有一个接收全部接收会报错
	...s RtnObj=..CanlReceiveLabel(DetailLabel,UserId,Type)
	...q:RtnObj.success'=0
	.q:RtnObj.success'=0
	.
	.s RtnObj=##class(web.CSSDHUI.System.LocPackageStock).UpdateCurQty(RecLocId,PkgId,-DispQty)
	.q:RtnObj.success'=0
	q:RtnObj.success'=0 RtnObj
	
	q RtnObj
}

/// Creator:why
/// CreatDate:2022-04-14
/// Description:按照单据取消接收，取消接收单据中的每个消毒包
/// Table:CSSD_PackageDisp
/// d ##class(web.CSSDHUI.PackageDisp.Receive).ReceiveLabel("71","95")
ClassMethod CanlReceiveLabel(Label As %String, UserId As %String, Type As %String) As web.CSSDHUI.RtnObj
{
	n (Label,UserId,Type)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i ((Label="")||(UserId="")) d RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"入参不能为空!"))
	q:RtnObj.success'=0 RtnObj
	
	s transId=$o(^User.CSSDTransI("CSSDTLabel",Label,""))
	s transInfo=##Class(User.CSSDTrans).%OpenId(transId)
	d transInfo.%Reload()
	s status=transInfo.CSSDTStatus
	i status'="R" q RtnObj.Err(-6,"",..%Translate($CLASSNAME(),"条码不是接收状态不能取消!"),"",0)
	
	s ItemId="",FrLocId=""
	i Type="Y" d
	.s ItemId =$o(^User.CSSDPackageDispI("CSSDPDLabel",Label,""),-1)
	.i ItemId="" d RtnObj.Err(-2,"",..%Translate($CLASSNAME(),"标签号为")_Label_..%Translate($CLASSNAME(),"的消毒包未发放!"),"",0)
	.q:RtnObj.success'=0
	.s dispInfo=##Class(User.CSSDPackageDisp).%OpenId(ItemId)
	.d dispInfo.%Reload()
	.s toUser=dispInfo.CSSDPDToUserDr
	.s FrLocId=dispInfo.CSSDPDFromLocDrGetObjectId()
	.i toUser="" d RtnObj.Err(-3,"",..%Translate($CLASSNAME(),"标签号为")_Label_..%Translate($CLASSNAME(),"的消毒包未接收不能取消接收!"),"",0)
	.q:RtnObj.success'=0
	e  d
	.s DispDetailId =$o(^User.CSSDPackageDispDetailI("CSSDPDDLabelIndex",Label,""),-1)
	.i DispDetailId="" d RtnObj.Err(-2,"",..%Translate($CLASSNAME(),"标签号为")_Label_..%Translate($CLASSNAME(),"的消毒包未发放!"),"",0)
	.q:RtnObj.success'=0
	.s DetailObj=##class(User.CSSDPackageDispDetail).%OpenId(DispDetailId)
	.s ItemId =DetailObj.CSSDPDDParrefDr.%Id()
	.s FrLocId=DetailObj.CSSDPDDParrefDr.CSSDPDFromLocDrGetObjectId()
	.&sql(update CSSD_PackageDispDetail set CSSDPD_RecUser_DR=null where CSSDPDD_Rowid=:DispDetailId )
	.i SQLCODE'=0  d
	..d RtnObj.Err(-4,"",$ClassName()_"ReceiveLabel:"_..%Translate($CLASSNAME(),"此明细取消接收失败!"))
	.q:RtnObj.success'=0
	q:RtnObj.success'=0 RtnObj
	
	&sql(update cssd_packagedisp set CSSDPD_ToUser_DR=null,CSSDPD_RecDate=null,CSSDPD_ReceiveDate=null,CSSDPD_ReceiveTime=null where CSSDPD_Rowid=:ItemId )
	i SQLCODE'=0  d
	.d RtnObj.Err(-4,"",$ClassName()_"ReceiveLabel:"_..%Translate($CLASSNAME(),"此明细取消接收失败!"))
	q:RtnObj.success'=0 RtnObj
	
	&sql(update cssd_trans set cssdt_status='D',CSSDT_CurrLoc_DR=:FrLocId where cssdt_label=:Label )
	i SQLCODE'=0  d
	.d RtnObj.Err(-5,"",$ClassName()_"ReceiveLabel:"_..%Translate($CLASSNAME(),"改条码取消接收状态失败!"))
	q:RtnObj.success'=0 RtnObj
	
	s RtnObj=##class(web.CSSDHUI.PackageDisp.DispItm).UpdateWLStatus(Label,"D")
	q:RtnObj.success'=0 RtnObj
	
	q RtnObj
}

/// 撤销接收前,判断是否允许
ClassMethod CheckBeforeCancel(DispMainId As %String) As web.CSSDHUI.RtnObj
{
	n (DispMainId)
	
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s MainObj=##Class(User.CSSDPackageDispMain).%OpenId(DispMainId)
	s ComplateFlag=MainObj.CSSDPDMComplateFlag
	s IsRec=MainObj.CSSDPDMIsRec
	s ReceiveDate=MainObj.CSSDPDMReceiveDate
	s Type=MainObj.CSSDPDMType

	i IsRec'="Y" q RtnObj.Err(-2,"",..%Translate($CLASSNAME(),"未接收不能撤销"),"",0)
	s nowdate=+$h
	s day=nowdate-ReceiveDate
	i day>2 q RtnObj.Err(-2,"",..%Translate($CLASSNAME(),"接收超过2天的单据不能撤销"),"",0)
	
	s ItemRowId=""
	f  s ItemRowId=$o(^User.CSSDPackageDispI("CSSDPDCParrefDr",DispMainId,ItemRowId)) q:((ItemRowId="")||(RtnObj.success'=0))  d
	.s ItemObj=##Class(User.CSSDPackageDisp).%OpenId(ItemRowId)
	.d ItemObj.%Reload()
	.q:'$IsObject(ItemObj)
	.s DispQty=ItemObj.CSSDPDQty
	.s PkgId=ItemObj.CSSDPDPackageGetObjectId()
	.
	.i Type="Y" d
	..s Label=ItemObj.CSSDPDLabel
	..s TransId=$o(^User.CSSDTransI("CSSDTLabel",Label,0))
	..q:TransId=""
	..s TransStatus=$lg(^User.CSSDTransD(TransId),8)
	..i TransStatus'="R" d RtnObj.Err(-1,"",Label_..%Translate($CLASSNAME(),"不是接收状态,不可撤销"),"",0) q
	.e  d
	..s DetailRowId=""
	..f  s DetailRowId=$o(^User.CSSDPackageDispDetailI("CSSDPDDParref",ItemRowId,DetailRowId)) q:((DetailRowId="")||(RtnObj.success'=0))  d
	...s DetailObj=##Class(User.CSSDPackageDispDetail).%OpenId(DetailRowId)
	...d DetailObj.%Reload()
	...q:'$IsObject(DetailObj)
	...s DetailLabel=DetailObj.CSSDPDDLabel
	...s TransId=$o(^User.CSSDTransI("CSSDTLabel",DetailLabel,0))
	...q:TransId=""
	...s TransStatus=$lg(^User.CSSDTransD(TransId),8)
	...i TransStatus'="R" d RtnObj.Err(-1,"",Label_..%Translate($CLASSNAME(),"不是接收状态,不可撤销"),"",0) q
	.q:RtnObj.success'=0
	
	q RtnObj
}

/// Creator:wn
/// CreatDate:2022-8-31
/// Description:checkbox多选部分接收
/// Table:CSSD_PackageDisp
/// d ##class(web.CSSDHUI.PackageDisp.Receive).jsRecePart("48","[{""RowId"":""58"",""PackageDR"":""746"",""PackageName"":""CS-测试二号包"",""Qty"":""1"",""Label"":""40062022083000013"",""ToUserDesc"":"""",""Price"":""0"",""PackMaterial"":"""",""PackMaterialName"":"""",""TotalPrice"":""0"",""LevelFlag"":"""",""DispDetailId"":""58""}]","6461")
ClassMethod jsRecePart(mainId As %String, Params As %String, UserId As %String) As %Library.String
{
	n (mainId,Params,UserId)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..RecePart(mainId,Params,UserId)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	
	q RtnObj.Json()
}

ClassMethod RecePart(mainId As %String, Params As %String, UserId As %String) As %Library.String
{
	n (mainId,Params,UserId)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i mainId="" q RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"入参不能为空!"))
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-2,"",..%Translate($CLASSNAME(),"入参解析失败!"))
	s MainObj=##Class(User.CSSDPackageDispMain).%OpenId(mainId)
	d MainObj.%Reload()
	s ComFlag=MainObj.CSSDPDMIsRec
	i ComFlag="Y" q RtnObj.Err(-3,"",..%Translate($CLASSNAME(),"该单据已接收!"))
	s Type=MainObj.CSSDPDMType
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s Label=Obj.Label
		s RtnObj=..ReceiveItemOne(mainId,Label,UserId)
		q:RtnObj.success'=0
	}
	q:RtnObj.success'=0 RtnObj

	q RtnObj
}

/// Creator:ban
/// CreatDate:2022-02-22
/// Description:扫码接收-扫描条码单个接收
/// Table:CSSD_PackageDisp
/// d ##class(web.CSSDHUI.PackageDisp.Receive).jsRecDetail("518","102058005000001","13922")
ClassMethod jsRecDetail(mainId, barCode, UserId) As %Library.String
{
	n (mainId,barCode,UserId)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i ((mainId="")||(barCode="")) d RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"入参不能为空!"))
	q:RtnObj.success'=0 RtnObj.Json()
	
	s MainObj=##Class(User.CSSDPackageDispMain).%OpenId(mainId)
	d MainObj.%Reload()
	s IsRecFlag=MainObj.CSSDPDMIsRec
	i IsRecFlag="Y" d RtnObj.Err(-2,"",..%Translate($CLASSNAME(),"已经接收的单据不能扫码!"),"",0)
	q:RtnObj.success'=0 RtnObj.Json()
	ts
	s RtnObj=..ReceiveItemOne(mainId,barCode,UserId)
	i RtnObj.success<0 tro  q RtnObj.Json()
	
	tc
	
	q RtnObj.Json()
}

/// 根据条码接收
/// 前端不允许直接调用
ClassMethod ReceiveItemOne(mainId As %String, Label As %String, UserId As %String) As web.CSSDHUI.RtnObj
{
	n (mainId,Label,UserId)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s Type=$lg(^User.CSSDPackageDispMainD(mainId),12)
	i ((Label="")||(UserId="")) d RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"入参不能为空!"))
	q:RtnObj.success'=0 RtnObj
	
	s TransId =$o(^User.CSSDTransI("CSSDTLabel",Label,""))
	i TransId="" d RtnObj.Err(-2,"",..%Translate($CLASSNAME(),"未找到标签号为")_Label_..%Translate($CLASSNAME(),"的消毒包信息!"),"",0)
	q:RtnObj.success'=0 RtnObj
	s TransObj=##class(User.CSSDTrans).%OpenId(TransId)
	s Status=TransObj.CSSDTStatus
	s PackageId=TransObj.CSSDTPackageGetObjectId()
	i Status="R" d RtnObj.Err(-3,"",..%Translate($CLASSNAME(),"标签号为")_Label_..%Translate($CLASSNAME(),"的消毒包已接收!"),"",0)
	q:RtnObj.success'=0 RtnObj
	s (ItemId,itemDetail)=""
	i Type="Y" d
	.s ItemId =$o(^User.CSSDPackageDispI("CSSDPDLabel",Label,""),-1)
	.i ItemId="" d RtnObj.Err(-4,"",..%Translate($CLASSNAME(),"标签号为")_Label_..%Translate($CLASSNAME(),"的消毒包未发放!"),"",0)
	e  d
	.s itemDetail=$o(^User.CSSDPackageDispDetailI("CSSDPDDLabelIndex",Label,""))
	.i itemDetail="" d RtnObj.Err(-6,"",..%Translate($CLASSNAME(),"标签号为")_Label_..%Translate($CLASSNAME(),"的消毒包未发放!"),"",0)
	.s DetailObj=##class(User.CSSDPackageDispDetail).%OpenId(itemDetail)
	.s ItemId =DetailObj.CSSDPDDParrefDr.%Id()
	q:RtnObj.success'=0 RtnObj
	
	s dispInfo=##Class(User.CSSDPackageDisp).%OpenId(ItemId)
	d dispInfo.%Reload()
	s DispMainId=dispInfo.CSSDPDParrefDrGetObjectId()
	s RecLocId=dispInfo.CSSDPDParrefDr.CSSDPDMToLocDrGetObjectId()
	i DispMainId'=mainId d RtnObj.Err(-7,"",..%Translate($CLASSNAME(),"标签号为")_Label_..%Translate($CLASSNAME(),"的消毒包不属于这个单据!"),"",0)
	q:RtnObj.success'=0 RtnObj
	
	s RtnObj=##class(web.CSSDHUI.System.LocPackageStock).UpdateCurQty(RecLocId,PackageId,1)
	q:RtnObj.success'=0 RtnObj
	
	s ReceiveDate=$p($h,",",1)
	s ReceiveTime=$p($h,",",2)
	s IsRec="Y"
	i Type'="Y" d
	.&sql(update CSSD_PackageDispDetail set CSSDPD_RecUser_DR=:UserId where CSSDPDD_Rowid=:itemDetail)
	.i SQLCODE'=0 d RtnObj.Err(-8,"",$ClassName()_"ReceiveItemOne:"_..%Translate($CLASSNAME(),"更新标签明细表失败!")) q
	.s DispDetail=""
	.f  s DispDetail=$o(^User.CSSDPackageDispDetailI("CSSDPDDParref",ItemId,DispDetail)) q:(DispDetail="")||(IsRec="N")  d
	..s DispDetailObj=##class(User.CSSDPackageDispDetail).%OpenId(DispDetail)
	..d DispDetailObj.%Reload()
	..s DetailRecUser=DispDetailObj.CSSDPDRecUser
	..s:'$IsObject(DetailRecUser) IsRec="N"
	i IsRec="Y" d
	.&sql(update cssd_packagedisp set CSSDPD_ToUser_DR=:UserId,CSSDPD_ReceiveDate=:ReceiveDate,CSSDPD_ReceiveTime=:ReceiveTime where CSSDPD_Rowid=:ItemId )
	.i SQLCODE'=0 d RtnObj.Err(-9,"",$ClassName()_"ReceiveItemOne:"_..%Translate($CLASSNAME(),"更新发放子表失败!"))
	q:RtnObj.success'=0 RtnObj

	s IsRec="Y"
	s DispId=""
	f  s DispId=$o(^User.CSSDPackageDispI("CSSDPDCParrefDr",mainId,DispId)) q:(DispId="")||(IsRec="N")  d
	.s DispObj=##class(User.CSSDPackageDisp).%OpenId(DispId)
	.d DispObj.%Reload()
	.q:'$IsObject(DispObj)
	.s RecDate=DispObj.CSSDPDReceiveDate
	.i RecDate="" s IsRec="N"
	i IsRec="Y" d
	.&sql(update CSSD_PackageDispMain set CSSDPDM_ToUser_DR=:UserId, CSSDPDM_IsRec=:IsRec,CSSDPDM_ReceiveDate=:ReceiveDate,CSSDPDM_ReceiveTime=:ReceiveTime WHERE ID=:mainId)
	.i SQLCODE'=0 d RtnObj.Err(-11,"",$ClassName()_"ReceiveItemOne:"_..%Translate($CLASSNAME(),"更新手术发放主表失败!"))
	q:RtnObj.success'=0 RtnObj

	&sql(update cssd_trans set cssdt_status='R',CSSDT_CurrLoc_DR=:RecLocId where cssdt_label=:Label )
	i SQLCODE'=0  d RtnObj.Err(-10,"",$ClassName()_"ReceiveItemOne:"_..%Translate($CLASSNAME(),"改条码修改接收状态失败!"))
	q:RtnObj.success'=0 RtnObj
	s RtnObj=##class(web.CSSDHUI.PackageDisp.DispItm).UpdateWLStatus(Label,"R")
	s ToUser=..sssUserName(UserId)
	s ReceiveTime=..DL2H(ReceiveDate)_" "_..TL2H(ReceiveTime)
	s RtnObj.keyValue="{""IsRec"":"""_IsRec_""",""ToUser"":"""_ToUser_""",""ReceiveTime"":"""_ReceiveTime_"""}"
	q:RtnObj.success'=0 RtnObj
	
	q RtnObj
}

}
