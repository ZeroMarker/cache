Import sqluser

/// Creator:wfg
/// CreatDate:2019-6-19
/// Description:回收相关
/// Table:CSSD_PackageDispMain
Class web.CSSDHUI.PackageDisp.Disp Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Creator:cy
/// CreatDate:2019-6-19
/// Description:保存请领单主表  前端调用
/// Table:
/// d ##class(web.CSSDHUI.PackageDisp.Disp).jsSave()
ClassMethod jsSave(Params) As %Library.String
{
	n (%session,Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()	
	ts
	s RtnObj=..Update(Params)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:cy
/// CreatDate:2019-8-29
/// Description:修改
/// Table:CSSD_PackageDispMain
/// w ##class(web.CSSDHUI.PackageDisp.Disp).Update({"fromLocDr":"382","toLocDr":"382","fromUserDr":"1","isOPRFlag":"N"})
ClassMethod Update(Params) As web.CSSDHUI.RtnObj
{
	n (%session,Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!")
	s Ret=..sssLock("Disp")
	q:Ret'=0 RtnObj.Err(-1,"","生成发放单号加锁失败！")
	
	s No=##class(web.CSSDHUI.Common.AppCommon).GetAppNo("Disp")
	s DispTime=$P($h,",",2)
	s DispDate=$P($h,",",1)
	s DispLocId=PJObj.%Get("fromLocDr")
	s RecLocId=PJObj.%Get("toLocDr")
	s CreateUserId=PJObj.%Get("fromUserDr")
	s ReqLevel=PJObj.%Get("ReqLevel")
	s CallBackMainId=PJObj.%Get("CallBackMainId")
	&sql(insert into CSSD_PackageDispMain(
		CSSDPDM_FromLoc_DR,CSSDPDM_ToLoc_DR,CSSDPDM_FromUser_DR,CSSDPDM_ComplateFlag,
		CSSDPDM_SerialNo,CSSDPDM_Type,CSSDPDM_DispUser_DR,CSSDPDM_ReqLevel,
		CSSDPDM_DispDate,CSSDPDM_DispTime,CSSDPDM_CallBackDr)
		values
		(:DispLocId,:RecLocId,:CreateUserId,'N',
		:No,'N',null,:ReqLevel,
		:DispDate,:DispTime,:CallBackMainId)
	)
	i SQLCODE'=0 d
	.d ..sssUnLock("Disp")
	.d RtnObj.Err(-2,"",$ClassName()_"Update:保存失败!")
	q:RtnObj.success'=0 RtnObj
	d ..sssUnLock("Disp")
	
	s Rowid=%ROWID
	s RtnObj.rowid=Rowid
	q RtnObj
}

/// Creator:ban
/// CreatDate:2022-3-10
/// Description:删除回收单  前端调用
/// Table:CSSD_PackageDisp CSSD_PackageDispMain
/// d ##class(web.CSSDHUI.PackageDisp.Disp).jsDelete()
ClassMethod jsDelete(Params As %String) As %Library.String
{
	n (%session,Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!").Json()
	
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s mainRowId=Obj.%Get("RowId")
		continue:mainRowId=""
		s RtnObj=..Delete(mainRowId)
		q:RtnObj.success'=0
	}
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:cy
/// CreatDate:2019-6-19
/// Description:删除回收单  前端调用
/// Table:CSSD_PackageDisp CSSD_PackageDispMain
/// d ##class(web.CSSDHUI.PackageDisp.Disp).Delete(6)
ClassMethod Delete(mainRowId As %String) As web.CSSDHUI.RtnObj
{
	n (%session,mainRowId)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i mainRowId="" d RtnObj.Err(-1,"","入参不能为空!")
	q:RtnObj.success'=0 RtnObj
	
	s MainObj=##Class(User.CSSDPackageDispMain).%OpenId(mainRowId)
	d MainObj.%Reload()
	s ComplateFlag=MainObj.CSSDPDMComplateFlag
	i ComplateFlag="Y" d RtnObj.Err(-2,"","只有未提交单据可以删除！")
	q:RtnObj.success'=0 RtnObj
	
	s Type=MainObj.CSSDPDMType
	i Type="Y" d RtnObj.Err(-3,"","单据类型错误！","",0)
	q:RtnObj.success'=0 RtnObj
	
	s DispItemRowId=""
	f  s DispItemRowId=$o(^User.CSSDPackageDispI("CSSDPDCParrefDr",mainRowId,DispItemRowId)) q:(DispItemRowId="")!(RtnObj.success'=0)  d
	.q:'$d(^User.CSSDPackageDispD(DispItemRowId))
	.s RtnObj=##class(web.CSSDHUI.PackageDisp.DispItm).Delete(DispItemRowId)
	.q:RtnObj.success'=0
	q:RtnObj.success'=0 RtnObj
	
	&sql(Delete FROM CSSD_PackageDispMain WHERE ID=:mainRowId)
	i SQLCODE'=0  d
	.d RtnObj.Err(-5,mainRowId,$ClassName()_".Delete:SQLCODE"_SQLCODE_":"_$g(%msg))
	q:RtnObj.success'=0 RtnObj
	
	q RtnObj
}

/// Creator:ban
/// CreatDate:2022-2-22
/// Description:扫码发放主单据提交
/// Table:CSSD_PackageDispMain
/// w ##class(web.CSSDHUI.PackageDisp.Disp).jsSubmitOrder(^bintmp(143))
ClassMethod jsSubmitOrder(Params As %String) As %String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"入参解析失败!"))
	s gUserId=PJObj.%Get("gUserId")
	s gGroupId=PJObj.%Get("gGroupId")
	s gLocId=PJObj.%Get("gLocId")
	s gHospId=PJObj.%Get("gHospId")
	s DispTime=PJObj.%Get("DispTime")
	s Type=PJObj.%Get("Type")
	s MainIdStr=PJObj.%Get("mainRowId")
	f i=1:1:$l(MainIdStr,",") d
	.s MainId=$p(MainIdStr,",",i)
	.s ParamData=gGroupId_"^"_gLocId_"^"_gUserId_"^"_gHospId_"^"_MainId_"^"_DispTime_"^"_Type
	.s ParamTitle="gGroupId^gLocId^gUserId^gHospId^mainRowId^DispTime^Type"
	.s Param=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(ParamData,ParamTitle)
	.s RtnObj=..SubmitOrder(Param)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// 提交
ClassMethod SubmitOrder(Params As %String) As web.CSSDHUI.RtnObj
{
	n (Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"入参解析失败!"))
	s MainId=PJObj.%Get("mainRowId")
	s gUserId=PJObj.%Get("gUserId")
	s gGroupId=PJObj.%Get("gGroupId")
	s gLocId=PJObj.%Get("gLocId")
	s gHospId=PJObj.%Get("gHospId")
	s DispTime=PJObj.%Get("DispTime")
	s PType=PJObj.%Get("Type")
	s AppParam=gGroupId_"^"_gLocId_"^"_gUserId_"^"_gHospId
	s UseLabelForDisp=##class(web.CSSDHUI.Common.AppCommon).GetParamValue("CSSDDISP","UseLabelForDisp",AppParam)
	s IfAutoRec=##class(web.CSSDHUI.Common.AppCommon).GetParamValue("CSSDDISP","IfAutoRec",AppParam)
	
	i MainId="" q RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"参数是空!"))
	
	s MainObj=##Class(User.CSSDPackageDispMain).%OpenId(MainId)
	q:'$IsObject(MainObj)
	s SupLocId=MainObj.CSSDPDMFromLocDrGetObjectId()
	s Type=MainObj.CSSDPDMType
	s ComplateFlag=MainObj.CSSDPDMComplateFlag
	s CallBackId=MainObj.CSSDPDMCallBackDrGetObjectId()
	;i PType'=Type q RtnObj.Err(-2,"",..%Translate($CLASSNAME(),"单据类型错误！"),"",0)
	i ComplateFlag="Y" q RtnObj.Err(-3,"",..%Translate($CLASSNAME(),"该单据已经提交！"),"",0)
	s Parref=$o(^User.CSSDPackageDispI("CSSDPDCParrefDr",MainId,""))
	i Parref="" q RtnObj.Err(-4,"",..%Translate($CLASSNAME(),"无明细不能提交！"),"",0)
	
	s SubmitTime=$P($h,",",2)
	s SubmitDate=$P($h,",",1)
	i DispTime'="" d
	.s SubmitTime=DispTime
	
	s DispItemRowId=0
	f  s DispItemRowId=$o(^User.CSSDPackageDispI("CSSDPDCParrefDr",MainId,DispItemRowId)) q:((DispItemRowId="")||(RtnObj.success'=0))  d
	.s DispDetailObj=##Class(User.CSSDPackageDisp).%OpenId(DispItemRowId)
	.d DispDetailObj.%Reload()
	.s PkgId=DispDetailObj.CSSDPDPackageGetObjectId()
	.s UnDispQty=DispDetailObj.CSSDPDUnDispQty
	.s DispQty=DispDetailObj.CSSDPDQty
	.s LabelDispQty=DispDetailObj.CSSDPDDispQty
	.i ((Type'="Y")&&(UseLabelForDisp="Y")&&(UnDispQty>0)) d RtnObj.Err(-4,"",..%Translate($CLASSNAME(),"存在未完全发放的消毒包"))
	.q:RtnObj.success'=0
	.i (+LabelDispQty'=0)&&(+LabelDispQty'=DispQty) d RtnObj.Err(-4,"",..%Translate($CLASSNAME(),"存在未完全扫码发放的消毒包"))
	.q:RtnObj.success'=0
	.s RtnObj=##class(web.CSSDHUI.System.LocPackageStock).UpdateCurQty(SupLocId,PkgId,-DispQty)
	.q:RtnObj.success'=0
	q:RtnObj.success'=0 RtnObj
	
	// 如果回收数量和发放数量相等更新回收主表状态
	i CallBackId'="" d
	.s ret=..IsDispAll(CallBackId)
	.q:ret'="0"
	.s DispFlag="Y"
	.&sql(Update CSSD_PackageCallBack set CSSDPC_IsDispFlag=:DispFlag 
		WHERE CSSDPC_Rowid=:CallBackId)
	.i SQLCODE'=0 d RtnObj.Err(-4,MainId,..%Translate($CLASSNAME(),"回收表发放标志更新失败")) q
	.q:RtnObj.success'=0
	.s RtnObj=..UpdateApplyState(MainId,gUserId,"3")
	.q:RtnObj.success'=0
	q:RtnObj.success'=0 RtnObj
	
	&sql(Update CSSD_PackageDispMain set CSSDPDM_DispUser_DR=:gUserId,
		CSSDPDM_CHKUser_DR=:gUserId, CSSDPDM_ComplateFlag='Y',
		CSSDPDM_SubmitDate=:SubmitDate,CSSDPDM_SubmitTime=:SubmitTime
		WHERE ID=:MainId)
	i SQLCODE'=0 d
	.d RtnObj.Err(-4,MainId,..%Translate($CLASSNAME(),"发放主单更新失败！"))
	q:RtnObj.success'=0 RtnObj
	
	i IfAutoRec="Y" d
	.s RtnObj=##class(web.CSSDHUI.PackageDisp.Receive).ReceOrder(MainId,"")
	.q:RtnObj.success'=0
	q:RtnObj.success'=0 RtnObj
	
	q RtnObj
}

/// Creator:ban
/// CreatDate:2022-3-10
/// Description:撤销发放单	前端调用
/// Table:CSSD_PackageDisp CSSD_PackageDispMain CSSD_PackageCallBack
/// d ##class(web.CSSDHUI.PackageDisp.Disp).jsCancelOrder("176","{""fromLocDr"":""166"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2"",""toLocDr"":"""",""FloorCode"":"""",""LineCode"":"""",""toUser"":"""",""packagename"":"""",""ReqType"":"""",""FStartDate"":""2022-09-28"",""FEndDate"":""2022-09-29"",""StartTime"":"""",""EndTime"":"""",""FReqNo"":"""",""DispTime"":""""}")
ClassMethod jsCancelOrder(Params As %String) As %Library.String
{
	n (%session,Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()	
	ts
	s RtnObj=..CancelOrder(Params)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:cy
/// CreatDate:2019-6-19
/// Description:撤销发放单	前端调用  后期可以考虑有明细的也可以删除(ps 修改打包表里面的是否装车标志)
/// Table:CSSD_PackageDisp	CSSD_PackageCallBack  CSSD_PackageDispMain
/// d ##class(web.CSSDHUI.PackageDisp.Disp).CancelOrder("41")
ClassMethod CancelOrder(Params As %String) As web.CSSDHUI.RtnObj
{
	n (%session,Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!")
	s mainRowId=PJObj.%Get("mainRowId")
	s gUserId=PJObj.%Get("gUserId")
	s gGroupId=PJObj.%Get("gGroupId")
	s gLocId=PJObj.%Get("gLocId")
	s gHospId=PJObj.%Get("gHospId")
	s PType=PJObj.%Get("Type")
	q:mainRowId="" RtnObj.Err(-1,"","入参不能为空!")
	s AppParam=gGroupId_"^"_gLocId_"^"_gUserId_"^"_gHospId
	s IfAutoRec=##class(web.CSSDHUI.Common.AppCommon).GetParamValue("CSSDDISP","IfAutoRec",AppParam)
	i IfAutoRec="Y" d
	.s RtnObj=##class(web.CSSDHUI.PackageDisp.Receive).CanlReceOrder(mainRowId,gUserId)
	.q:RtnObj.success'=0
	q:RtnObj.success'=0 RtnObj
	
	s MainObj=##Class(User.CSSDPackageDispMain).%OpenId(mainRowId)
	d MainObj.%Reload()
	s ComplateFlag=MainObj.CSSDPDMComplateFlag
	s locDr=MainObj.CSSDPDMFromLocDrGetObjectId()
	s Type=MainObj.CSSDPDMType
	s IsRec=MainObj.CSSDPDMIsRec
	s CallBackId=MainObj.CSSDPDMCallBackDrGetObjectId()
	
	i ComplateFlag'="Y" d RtnObj.Err(-2,"",..%Translate($CLASSNAME(),"未提交单据不能进行撤销操作!"))
	q:RtnObj.success'=0 RtnObj
	s:Type="" Type="N"
	i PType'=Type q RtnObj.Err(-2,"",..%Translate($CLASSNAME(),"单据类型错误！"))
	q:RtnObj.success'=0 RtnObj
	i ((IfAutoRec="N")&&(IsRec="Y")) d RtnObj.Err(-4,"",..%Translate($CLASSNAME(),"该发放单已接收，不能进行撤销操作"))
	q:RtnObj.success'=0 RtnObj
	
	s IsRec="N"
	s DispItemId=""
	f  s DispItemId=$o(^User.CSSDPackageDispI("CSSDPDCParrefDr",mainRowId,DispItemId)) q:(DispItemId="")||(IsRec="Y")  d
	.s DispObj=##Class(User.CSSDPackageDisp).%OpenId(DispItemId)
	.d DispObj.%Reload()
	.s PkgId=DispObj.CSSDPDPackageGetObjectId()
	.s DispQty=DispObj.CSSDPDQty
	.s RecDate=DispObj.CSSDPDRecDate
	.s RtnObj=##class(web.CSSDHUI.System.LocPackageStock).UpdateCurQty(locDr,PkgId,DispQty)
	.q:RtnObj.success'=0
	.i RecDate'="" s IsRec="Y"
	.s DispDetailId=$o(^User.CSSDPackageDispDetailI("CSSDPDDParref",DispItemId,""))
	.i (DispDetailId'="")&&(IsRec="N") d
	.f  s DispDetailId=$o(^User.CSSDPackageDispDetailI("CSSDPDDParref",DispItemId,DispDetailId)) q:DispDetailId=""  d
	..s DispDetailObj=##class(User.CSSDPackageDispDetail).%OpenId(DispDetailId)
	..s RecUserId=DispDetailObj.CSSDPDRecUser
	..i RecUserId'="" s IsRec="Y"
	q:RtnObj.success'=0 RtnObj
	i ((IfAutoRec="N")&&(IsRec="Y")) q RtnObj.Err(-5,"",..%Translate($CLASSNAME(),"发放单已经部分接收,不能撤销!"))
	
	i CallBackId'="" d
	.s ret=..IsDispAll(CallBackId)
	.q:ret'=0
	.&sql(Update CSSD_PackageCallBack set CSSDPC_IsDispFlag='N' WHERE CSSDPC_Rowid=:CallBackId)
	.i SQLCODE'=0 d
	..d RtnObj.Err(-6,mainRowId,..%Translate($CLASSNAME(),"回收单发放标志更新失败！!"))
	.q:RtnObj.success'=0
	.s RtnObj=..UpdateApplyState(mainRowId,"","2")
	.q:RtnObj.success'=0
	q:RtnObj.success'=0 RtnObj
	
	&sql(Update CSSD_PackageDispMain set CSSDPDM_DispUser_DR=null,
		CSSDPDM_ComplateFlag='N',CSSDPDM_SubmitDate=null,CSSDPDM_SubmitTime=null
		WHERE ID=:mainRowId)
	i SQLCODE'=0  d
	.d RtnObj.Err("",mainRowId,..%Translate($CLASSNAME(),"发放主单更新失败！"))
	q:RtnObj.success'=0 RtnObj
	
	s DispId=""
	f  s DispId=$o(^User.CSSDPackageDispI("CSSDPDCParrefDr",mainRowId,DispId)) q:DispId=""  d
	.s DispInfo=##Class(User.CSSDPackageDisp).%OpenId(DispId)
	.d DispInfo.%Reload()
	.q:'$IsObject(DispInfo)
	.s Qty=DispInfo.CSSDPDQty
	.s DispDetailId=$o(^User.CSSDPackageDispDetailI("CSSDPDDParref",DispId,""))
	.i DispDetailId="" d
	..&sql(UPDATE CSSD_PackageDisp SET CSSDPD_DispQty=0,CSSDPD_UnDispQty=:Qty where CSSDPD_Rowid=:DispId)
	..i SQLCODE'=0  d
	...d RtnObj.Err(-7,mainRowId,..%Translate($CLASSNAME(),"发放明细表更新失败！"))
	.e  d
	..s DispDetailRowId="",sumqty=0
	..f  s DispDetailRowId=$o(^User.CSSDPackageDispDetailI("CSSDPDDParref",DispId,DispDetailRowId)) q:DispDetailRowId=""  d
	...s DispDetailObj=##class(User.CSSDPackageDispDetail).%OpenId(DispDetailRowId)
	...q:'$IsObject(DispDetailObj)
	...s sumqty=sumqty+1
	..&sql(UPDATE CSSD_PackageDisp SET CSSDPD_DispQty=:sumqty,CSSDPD_UnDispQty=:Qty-:sumqty where CSSDPD_Rowid=:DispId)
	..i SQLCODE'=0  d
	...d RtnObj.Err(-8,mainRowId,..%Translate($CLASSNAME(),"发放明细表更新失败！"))
	.q:RtnObj.success'=0
	q:RtnObj.success'=0 RtnObj
	
	q RtnObj
}

/// Creator:ban
/// CreatDate:2022-3-10
/// Description:根据回收单制作发放单
/// Table:CSSD_CallbackDetailNew
/// d ##class(web.CSSDHUI.PackageDisp.Disp).jsCreateDispByCallBack(^tmpmy("feg"),^tmpmy("ItemRow"))
ClassMethod jsCreateDispByCallBack(Params As %String, ItemRow As %String) As %Library.String
{
	n (%session,Params,ItemRow)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..CreateDispByCallBack(Params,ItemRow)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:cy
/// CreatDate:2019-8-29
/// Description:根据回收单制作发放单 why20211214修改可以部分发放
/// Table:CSSD_CallbackDetailNew
/// w ##class(web.CSSDHUI.PackageDisp.Disp).CreateDispByApply("62","{""ItemRowId"":"",87,86,"",""gUserId"":""13922"",""gLocId"":""166"",""gGroupId"":""294"",""gHospId"":""2""}")
ClassMethod CreateDispByCallBack(Params As %String, ItemRow As %String) As web.CSSDHUI.RtnObj
{
	n (%session,Params,ItemRow)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s PJItemObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	
	s ItemSc=PJItemObj.%FromJSON(ItemRow)
	i ItemSc'=0 d RtnObj.Err(-2,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	
	s gUserId=PJObj.%Get("gUserId")
	s gGroupId=PJObj.%Get("gGroupId")
	s gLocId=PJObj.%Get("gLocId")
	s gHospId=PJObj.%Get("gHospId")
	
	s Pid=..NewPid()
	k ^TMPCSSD(Pid,"DISPBYCallBack")
	
	while(RtnObj.success=0){
		s Obj=PJItemObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s BackQty=Obj.%Get("BackQty")
		s PkgId=Obj.%Get("PkgId")
		s MaterialDr=Obj.%Get("Material")
		s PreQty=Obj.%Get("PreDispQty")		//要发放数量
		s DispQty=Obj.%Get("DispQty")		//已经发放数量
		s ReqLevel=Obj.%Get("LevelFlag")
		s CallBackId=Obj.%Get("MainId")
		
		s ret=..IsDispAll(CallBackId)
		i ret=0 d RtnObj.Err(-3,"","存在已经全部发放申请单!")
		q:RtnObj.success'=0
		
		s DispQty=$lg(^User.CSSDCallbackDetailNewD(RowId),5)	;已发放数量(从后台取)
		s NotQty=BackQty-DispQty
		i PreQty>NotQty d RtnObj.Err(-5,"","要发放数量不能大于未回收数量!")
		continue:RtnObj.success'=0
		
		s DetailStr=PkgId_"^"_MaterialDr_"^"_ReqLevel_"^"_PreQty
		s ^TMPCSSD(Pid,"DISPBYCallBack",CallBackId,RowId)=DetailStr
	}
	q:RtnObj.success'=0 RtnObj
	
	i '$d(^TMPCSSD(Pid,"DISPBYCallBack")) d RtnObj.Err(-5,"","没有需要发放的申请")
	q:RtnObj.success'=0 RtnObj
	s MainIdStr=""
	s CallBackId=0
	f  s CallBackId=$o(^TMPCSSD(Pid,"DISPBYCallBack",CallBackId)) q:(CallBackId="")||(RtnObj.success'=0)  d
	.s CallBackMainObj=##class(User.CSSDPackageCallback).%OpenId(CallBackId)
	.d CallBackMainObj.%Reload()
	.q:'$IsObject(CallBackMainObj)
	.s RecLocId=CallBackMainObj.CSSDPCFromLocDrGetObjectId()
	.s ReqLevel=CallBackMainObj.CSSDPCReqLevel
	.s MainData=gLocId_"^"_RecLocId_"^"_gUserId_"^"_ReqLevel_"^"_CallBackId
	.s MainTitleStr="fromLocDr^toLocDr^fromUserDr^ReqLevel^CallBackMainId"
	.s MainParams=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(MainData,MainTitleStr)
	.s RtnObj=..Update(MainParams)
	.q:RtnObj.success'=0
	.s MainId=RtnObj.rowid
	.i MainId="" d RtnObj.Err(-5,"","生成发放主单失败")
	.i MainIdStr="" d
	..s MainIdStr=MainId
	.e  d
	..s MainIdStr=MainIdStr_","_MainId
	.q:RtnObj.success'=0
	.
	.s CallBackItmId=0
	.f  s CallBackItmId=$o(^TMPCSSD(Pid,"DISPBYCallBack",CallBackId,CallBackItmId)) q:(CallBackItmId="")||(RtnObj.success'=0)  d
	..s DetailStr=^TMPCSSD(Pid,"DISPBYCallBack",CallBackId,CallBackItmId)
	..s PkgId=$p(DetailStr,"^",1)
	..s MaterialDr=$p(DetailStr,"^",2)
	..s ReqLevel=$p(DetailStr,"^",3)
	..s PreQty=$p(DetailStr,"^",4)
	..s MainData=MainId_"^"_gGroupId_"^"_gLocId_"^"_gUserId_"^"_gHospId
	..s MainTitle="MainId^gGroupId^gLocId^gUserId^gHospId"
	..s MainParams=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(MainData,MainTitle)
	..s DetailData=""_"^"_PkgId_"^"_PreQty_"^"_CallBackItmId_"^"_MaterialDr_"^"_ReqLevel
	..s DetailTitle="RowId^PackageDR^Qty^CallBackDetailDr^PackMaterial^LevelFlag"
	..s Detail=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(DetailData,DetailTitle)
	..s Detail="["_Detail_"]"
	..s RtnObj=##class(web.CSSDHUI.PackageDisp.DispItm).SaveDisp(Detail,MainParams)
	..q:RtnObj.success'=0
	.;自动提交
	.q:RtnObj.success'=0
	.
	.s Qty=0,IsCommit="N"
	.s DispId=""
	.f  s DispId=$o(^User.CSSDPackageDispI("CSSDPDCParrefDr",MainId,DispId)) q:((DispId="")||(IsCommit="Y"))  d
	..s DispInfo=##Class(User.CSSDPackageDisp).%OpenId(DispId)
	..q:'$IsObject(DispInfo)
	..d DispInfo.%Reload()
	..s UnDispQty=DispInfo.CSSDPDUnDispQty
	..i UnDispQty>0 s IsCommit="Y"
	.
#;	.i IsCommit="N" d
#;	..s ParamData=gGroupId_"^"_gLocId_"^"_gUserId_"^"_gHospId_"^"_MainId_"^"_"N"
#;	..s ParamTitle="gGroupId^gLocId^gUserId^gHospId^mainRowId^Type"
#;	..s Param=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(ParamData,ParamTitle)
#;	..s RtnObj=##class(web.CSSDHUI.PackageDisp.Disp).SubmitOrder(Param)
	s RtnObj.rowid=MainIdStr
	
	q RtnObj
}

/// Creator:cy
/// CreatDate:2019-8-29
/// Description:根据回收主表id判断回收单是全部发放
/// Table:CSSD_CallBackDetailNew
/// d ##class(web.CSSDHUI.PackageDisp.Disp).IsDispAll()
ClassMethod IsDispAll(CallBackMainDr) As %Library.String
{
	n (CallBackMainDr)
	s sumDispQty=0,sumQty=0
	s CallBackDetail=0
	f  s CallBackDetail=$o(^User.CSSDCallbackDetailNewI("CSSDCDParrefIndex",CallBackMainDr,CallBackDetail)) q:CallBackDetail=""  d
	.s CallBackDetailObj=##Class(User.CSSDCallbackDetailNew).%OpenId(CallBackDetail)
	.q:'$IsObject(CallBackDetailObj)
	.d CallBackDetailObj.%Reload()
	.s DispQty=CallBackDetailObj.CSSDCDDispQty
	.s Qty=CallBackDetailObj.CSSDCDQty
	.s sumDispQty=sumDispQty+DispQty
	.s sumQty=sumQty+Qty
	s ret=sumDispQty-sumQty
	q ret
}

/// Creator:cy
/// CreatDate:2019-8-29
/// Description:根据发放主表id更新请领单发放状态
/// Table:CSSD_PackageDisp	CSSD_PackageApply
/// w ##class(web.CSSDHUI.PackageDisp.Disp).UpdateApplyState("96","",2)
ClassMethod UpdateApplyState(PackageDispMainId, gUser, Flag) As %Library.String
{
	n (PackageDispMainId,gUser,Flag)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s (CallBackMainRow,ApplyNo,ApplyType,ApplyId,ApplyFlag)="",rvn="-1"
	
	s DispItemRowId=""
	f  s DispItemRowId=$o(^User.CSSDPackageDispI("CSSDPDCParrefDr",PackageDispMainId,DispItemRowId)) q:DispItemRowId=""  d
	.s DispDetailObj=##Class(User.CSSDPackageDisp).%OpenId(DispItemRowId)
	.d DispDetailObj.%Reload()
	.s CallBackDetailObj=DispDetailObj.CSSDPDPackageCallBackDetail
	.q:'$IsObject(CallBackDetailObj)
	.s CallBackDetail=CallBackDetailObj.%Id()
	.s ApplyDetailObj=CallBackDetailObj.CSSDCDPackageApplyDetailDR
	.q:'$IsObject(ApplyDetailObj)
	.s ApplyDetailDr=ApplyDetailObj.%Id()
	.s ApplyId=ApplyDetailObj.CSSDPADParref
	.s ApplyFlag=$lg(^User.CSSDPackageApplyD(ApplyId),9)
	.s ApplyType=$lg(^User.CSSDPackageApplyD(ApplyId),17)
	.s rvn=..IsApply(ApplyId)
	
	i rvn="0" d
	.i Flag="3" d  //提交发放单更新请领状态
	..q:ApplyType=4
	..&sql(Update CSSD_PackageApply set CSSDPA_Flag='3' WHERE ID=:ApplyId)
	..i SQLCODE'=0 d RtnObj.Err(-1,"","提交发放单，更新申请单为发放状态失败！") q
	.e  i Flag="2" d      //撤销发放单时，需要将回收申请单从发放变回收,非循环包/借包单从发放变确认
	..i ((ApplyType="0")||(ApplyType="5")) s NewFlag="2"
	..i ((ApplyType="1")||(ApplyType="2")) s NewFlag="5"
	..&sql(Update CSSD_PackageApply set CSSDPA_Flag=:NewFlag WHERE ID=:ApplyId)
	..i SQLCODE'=0 d RtnObj.Err(-1,"","撤销发放单，更新申请单为回收状态失败！") q
	
	q:RtnObj.success'=0 RtnObj
	
	q RtnObj
}

/// Creator:cy
/// CreatDate:2019-8-29
/// Description:判断申请单，回收和发放数量是否相等
/// Table:CSSD_PackageApplyDetail
/// w ##class(web.CSSDHUI.PackageDisp.Disp).IsApply("20220600001")
ClassMethod IsApply(ApplyId) As %Library.String
{
	n (ApplyId)
	q:ApplyId="" "-1"
	s (sumBackQty,sumOutQty)=0
	s ApplyDetail=0
	f  s ApplyDetail=$o(^User.CSSDPackageApplyDetailI("CSSDPADParrefIndex",ApplyId,ApplyDetail)) q:ApplyDetail=""  d
	.s ApplyDetailObj=##Class(User.CSSDPackageApplyDetail).%OpenId(ApplyDetail)
	.i $IsObject(ApplyDetailObj) d
	..d ApplyDetailObj.%Reload()
	..s BackQty=ApplyDetailObj.CSSDPADBackQty
	..s OutQty=ApplyDetailObj.CSSDPADOutQty
	..s sumBackQty=sumBackQty+BackQty
	..s sumOutQty=sumOutQty+OutQty
	s ret=sumOutQty-sumBackQty
	q ret
}

/// 打印发放汇总方法报表
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.PackageDisp.Disp","SelectAllPrint","4,5,6")
Query SelectAllPrint(MainIds As %Text = "") As web.CSSDHUI.Query(ROWSPEC = "FromLocDesc,FromUserName,ToLocDesc,SerialNo,DispDate,PkgClassDesc,PkgDesc,Remark,Qty:%Float") [ SqlProc ]
{
}

ClassMethod SelectAllPrintExecute(ByRef qHandle As %Binary, MainIds As %Text) As %Status
{
	n (qHandle,MainIds)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="SELECT CSSDPDM_FromLoc_Dr->CTLOC_Desc FromLocDesc,CSSDPDM_SerialNo,CSSDPDM_DispDate,"
		_"CSSDPDM_FromUser_dr->SSUSR_Name FromUserName,CSSDPDM_ToLoc_Dr->CTLOC_Desc ToLocDesc,"
		_"CSSDPD_Package_DR,CSSDPD_Qty,CSSDPD_CallBackDetailDR->CSSDCD_PackageApplyDetailDr->CSSDPAD_Desc Remark "
		_" FROM CSSD_PackageDispMain main,CSSD_PackageDisp detail"
		_" WHERE main.ID=detail.CSSDPD_Parref_DR AND main.ID IN ("_MainIds_") "
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s FromLocDesc=Result.Data("FromLocDesc")
		s SerialNo=Result.Data("CSSDPDM_SerialNo")
		s FromUserName=Result.Data("FromUserName")
		s ToLocDesc=Result.Data("ToLocDesc")
		s DispDate=Result.Data("CSSDPDM_DispDate")
		s PkgId=Result.Data("CSSDPD_Package_DR")
		s Qty=Result.Data("CSSDPD_Qty")
		s Remark=Result.Data("Remark")
		s packageObj=##class(User.CSSDPackage).%OpenId(PkgId)
		continue:'$IsObject(packageObj)
		s PkgDesc=packageObj.CSSDPDesc
		s PkgClassDesc=packageObj.CSSDPPackClass.CSSDPCPackCalssName
		s DispDate=..DL2H(DispDate)
		d OutPutRowPrint
	}
	d Result.Close()
	Quit $$$OK
OutPutRowPrint
	s Data=$lb(FromLocDesc,FromUserName,ToLocDesc,SerialNo,DispDate,PkgClassDesc,PkgDesc,Remark,Qty)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Decription:判断一个标签是否存在与发放或调拨单中
/// Creator:lxt
/// CreateDate:20220615
ClassMethod CheckLabelDispExist(Label) As %Library.String
{
	n (Label)
	
	s DispId=$o(^User.CSSDPackageDispI("CSSDPDLabel",Label,0))
	q:DispId'="" "Y"
	
	s DispDetailId=$o(^User.CSSDPackageDispDetailI("CSSDPDDLabelIndex",Label,0))
	q:DispDetailId'="" "Y"
	
	q "N"
}

}
