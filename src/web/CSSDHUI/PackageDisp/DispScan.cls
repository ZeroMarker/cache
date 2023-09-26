Import sqluser

/// Creator:ban
/// CreatDate:2022-02-22
/// Description:扫码发放后台类
Class web.CSSDHUI.PackageDisp.DispScan Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Creator:ban
/// CreatDate:2022-2-22
/// Description:扫码发放主单据查询
/// Table:CSSD_PackageDispMain
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.PackageDisp.DispScan","SelectAll",^bintmp(20))
Query SelectAll(Params As %String = "") As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,No,FromLocDR,FromLocDesc,FromUserDR,FromUserDesc,DispUserDR,DispUserDesc,DispDate,ToLocDR,ToLocDesc,ComplateFlag,RecDate,DispCHKUserDesc,DispCHKDate,ToUserDesc,IsRec,RecStatu,LevelFlag,DispType,DocType,ApplyUserName,ApplyDateTime,ApplyTypeDesc,CallbackNo,ApplyType,CallBackUserName,CallBackDateTime,ApplyNo") [ SqlProc ]
{
}

ClassMethod SelectAllExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 $$$OK
	
	s pRowId=PJObj.%Get("RowId")
	s FStartD=PJObj.%Get("FStartDate")
	s FEndD=PJObj.%Get("FEndDate")
	s FStartTime=PJObj.%Get("FStartTime")
	s FEndTime=PJObj.%Get("FEndTime")
	s FNo=PJObj.%Get("FNo")
	s PComplateFlag=PJObj.%Get("FComplateFlag")	
	s FStatu=PJObj.%Get("FStatu")
	s PFromLocId=PJObj.%Get("fromLocDr")
	s PFromUserId=PJObj.%Get("fromUserDr")
	s PToLocId=PJObj.%Get("toLocDr")
	s PToUserId=PJObj.%Get("toUser")
	s gHospId=PJObj.%Get("gHospId")
	s gLocId=PJObj.%Get("gLocId")
	s PType=PJObj.%Get("Type")
	s PDocType=PJObj.%Get("DocType")
	s FReqType=PJObj.%Get("ReqType")
	s PPkgId=PJObj.%Get("packagename")
	s PLabel=PJObj.%Get("Label")
	s PLineId=PJObj.%Get("LineCode")
	q:(pRowId="")&&((FStartD="")||(FEndD="")) $$$OK
	
	s FStartD=..DH2L(FStartD)
	s FEndD=..DH2L(FEndD)
	s FStartTime=..TH2L(FStartTime)
	s FEndTime=..TH2L(FEndTime)
	s LineLocStr=##class(web.CSSDHUI.Common.PackageInfoCommon).GetLocByLine(PLineId)
	
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="SELECT ID AS RowId, CSSDPDM_FromLoc_DR, CSSDPDM_FromUser_DR,"
			_" CSSDPDM_SerialNo,CSSDPDM_DispUser_DR,CSSDPDM_Date,CSSDPDM_ToLoc_DR,"
			_" CSSDPDM_ToUser_DR,CSSDPDM_Type,CSSDPDM_ComplateFlag,CSSDPDM_ReceiveDate,"
			_" CSSDPDM_ReceiveTime,CSSDPDM_DispDate,CSSDPDM_DispTime,CSSDPDM_SubmitDate,"
			_" CSSDPDM_SubmitTime,CSSDPDM_CHKUser_DR,CSSDPDM_IsRec,CSSDPDM_RecStatu,"
			_" CSSDPDM_CallBackDr->CSSDPC_PackageApplyDR,CSSDPDM_DocType,CSSDPDM_CallBackDr,CSSDPDM_CallBackDr->CSSDPC_SerialNo"
			_" FROM CSSD_PackageDispMain "
			_" where 1=1 "
	i pRowId'="" d
	.s SqlStr=SqlStr_" and ID in ("_pRowId_")"
	e  d
	.s SqlStr=SqlStr_" and CSSDPDM_DispDate between "_FStartD_" AND "_FEndD
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s FromLocId = Result.Data("CSSDPDM_FromLoc_DR")
		s FromUserId = Result.Data("CSSDPDM_FromUser_DR")
		s ToLocId = Result.Data("CSSDPDM_ToLoc_DR")
		s ToUserId = Result.Data("CSSDPDM_ToUser_DR")
		s DispUserId = Result.Data("CSSDPDM_DispUser_DR")
		s DispCHKUserDR = Result.Data("CSSDPDM_CHKUser_DR")
		s No = Result.Data("CSSDPDM_SerialNo")
		s DispDate = Result.Data("CSSDPDM_DispDate")
		s DispTime = Result.Data("CSSDPDM_DispTime")
		s SubmitDate = Result.Data("CSSDPDM_SubmitDate")
		s SubmitTime = Result.Data("CSSDPDM_SubmitTime")
		s ComplateFlag = Result.Data("CSSDPDM_ComplateFlag")	//判断是否单据提交
		s ReceiveDate = Result.Data("CSSDPDM_ReceiveDate")
		s ReceiveTime = Result.Data("CSSDPDM_ReceiveTime")
		s DispType = Result.Data("CSSDPDM_Type")
		s IsRec = Result.Data("CSSDPDM_IsRec")
		s RecStatu = Result.Data("CSSDPDM_RecStatu")
		s DocType = +Result.Data("CSSDPDM_DocType")
		s ApplyId = Result.Data("CSSDPC_PackageApplyDR")
		s CallbackNo = Result.Data("CSSDPC_SerialNo")
		s CallBackDr = Result.Data("CSSDPDM_CallBackDr")
		s (ApplyType,ApplyDate,ApplyTime,ApplyUserId,ApplyNo)=""
		i ApplyId'="" d
		.s ApplyObj=##class(User.CSSDPackageApply).%OpenId(ApplyId)
		.q:'$IsObject(ApplyObj)
		.s ApplyUserId=ApplyObj.CSSDPAAPPLYUSERDRGetObjectId()
		.s ApplyDate=ApplyObj.CSSDPASubmitDate
		.s ApplyTime=ApplyObj.CSSDPASubmitTime
		.s ApplyType=ApplyObj.CSSDPAType
		.s ApplyNo=ApplyObj.CSSDPANO
		s (CallBackUserId,CallBackDate,CallBackTime)=""
		i CallBackDr'="" d
		.s CallBackObj=##class(User.CSSDPackageCallback).%OpenId(CallBackDr)
		.q:'$IsObject(CallBackObj)
		.s CallBackUserId=CallBackObj.CSSDPCAckUserDrGetObjectId()
		.s CallBackDate=CallBackObj.CSSDPCAckDate
		.s CallBackTime=CallBackObj.CSSDPCAckTime
		s ShowDataFlag=##class(web.CSSDHUI.HospMap).GetShowDataFlag("CT_Loc",FromLocId,gHospId)
		continue:ShowDataFlag="N"
		continue:(pRowId="")&&((PToLocId'="")&&(PToLocId'=ToLocId))
		continue:(pRowId="")&&((PFromLocId'="")&&(PFromLocId'=FromLocId))
		continue:(pRowId="")&&((PFromUserId'="")&&(PFromUserId'=FromUserId))
		continue:(pRowId="")&&((PToUserId'="")&&(PToUserId'=ToUserId))
		continue:(pRowId="")&&((FNo'="")&&(FNo'=No))
		continue:(pRowId="")&&((FStartD=DispDate)&&(FStartTime'="")&&(DispTime<FStartTime))
		continue:(pRowId="")&&((FEndD=DispDate)&&(FEndTime'="")&&(DispTime>=FEndTime))
		continue:(pRowId="")&&((PComplateFlag'="")&&(PComplateFlag'=ComplateFlag))
		continue:(pRowId="")&&((PType'="")&&(PType'=DispType))
		continue:(pRowId="")&&((PDocType'="")&&(PDocType'=DocType))
		continue:(pRowId="")&&((FStatu'="")&&(FStatu'=IsRec))
		continue:(pRowId="")&&((FReqType'="")&&(FReqType'=ApplyType))
		continue:(pRowId="")&&((LineLocStr'="")&&(LineLocStr'[("^"_ToLocId_"^")))
		continue:(pRowId="")&&((PPkgId'="")&&'$d(^User.CSSDPackageDispI("CSSDPDParrefDrIndex",RowId,PPkgId)))
		
		i (pRowId="")&&(PLabel'="") d
		.s CheckLabel=..CheckDispLabel(RowId,PLabel)
		continue:(pRowId="")&&((PLabel'="")&&(CheckLabel'="Y"))
		
		s ApplyTypeDesc=""
		s:+ApplyType=0 ApplyTypeDesc="回收单"
		s:ApplyType=1 ApplyTypeDesc="借包单"
		s:ApplyType=2 ApplyTypeDesc="非循环包申请单"
		s:ApplyType=5 ApplyTypeDesc="回收单(标牌追溯包)"
		
		i IsRec="N" s RecStatu="2"
		s LevelFlag=""
		s DispId=""
		f  s DispId=$o(^User.CSSDPackageDispI("CSSDPDCParrefDr",RowId,DispId)) q:((DispId="")||(LevelFlag=1))  d
		.s DispObj=##class(User.CSSDPackageDisp).%OpenId(DispId)
		.s LevelFlag=DispObj.CSSDPDLevelFlag
		
		s ApplyDate=..DL2H(ApplyDate)
		s ApplyTime=..TL2H(ApplyTime)
		s ApplyDateTime=ApplyDate_" "_ApplyTime
		s CallBackDate=..DL2H(CallBackDate)
		s CallBackTime=..TL2H(CallBackTime)
		s CallBackDateTime=CallBackDate_" "_CallBackTime
		s DispDate=..DL2H(DispDate)
		s DispTime=..TL2H(DispTime)
		s DispDateTime=DispDate_" "_DispTime
		s DispCHKDateNew=..DL2H(SubmitDate)
		s DispCHKDateTime=..TL2H(SubmitTime)
		s DispCHKDate=DispCHKDateNew_" "_DispCHKDateTime
		s RecDateNew=..DL2H(ReceiveDate)
		s RecDateTime=..TL2H(ReceiveTime)
		s RecDate=RecDateNew_" "_RecDateTime
		s ToLocDesc=..sssLocDesc(ToLocId)
		s FromLocDesc=..sssLocDesc(FromLocId)
		s FromUserDesc=..sssUserName(FromUserId)
		s DispUserDesc=..sssUserName(DispUserId)
		s DispCHKUserDesc=..sssUserName(DispCHKUserDR)
		s ApplyUserName=..sssUserName(ApplyUserId)
		s ToUserDesc=..sssUserName(ToUserId)
		s CallBackUserName=..sssUserName(CallBackUserId)
		
		d OutPutRow
	}
	d Result.Close()
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,No,FromLocId,FromLocDesc,FromUserId,FromUserDesc,DispUserId,DispUserDesc,
		DispDateTime,ToLocId,ToLocDesc,ComplateFlag,RecDate,DispCHKUserDesc,DispCHKDate,ToUserDesc,
		IsRec,RecStatu,LevelFlag,DispType,DocType,ApplyUserName,ApplyDateTime,ApplyTypeDesc,CallbackNo,
		ApplyType,CallBackUserName,CallBackDateTime,ApplyNo)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creator:ban
/// CreatDate:2022-2-22
/// Description:扫码发放主单据保存操作
/// Table:CSSD_PackageDispMain
/// w ##class(web.CSSDHUI.PackageDisp.DispScan).jsSave("{""fromLocDr"":""360"",""gUserId"":""541"",""gLocId"":""360"",""gGroupId"":""236"",""gHospId"":"""",""toLocDr"":""1"",""fromUser"":""李立志"",""fromUserDr"":""901"",""isOPRFlag"":""Y""}")
ClassMethod jsSave(Params) As %Library.String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..Save(Params)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// 保存消毒包发放主表前端不允许调用
ClassMethod Save(Params) As web.CSSDHUI.RtnObj
{
	n (Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"入参解析失败!"))
	q:RtnObj.success'=0 RtnObj
	
	s curDate=$zdt($h,3)
	s nowDate=$p($h,",",1)
	s nowTime=$p($h,",",2)
	s RowId=PJObj.%Get("RowId")
	s fromLocDr=PJObj.%Get("fromLocDr")
	s toLocDr=PJObj.%Get("toLocDr")
	s fromUserDr=PJObj.%Get("fromUserDr")
	s Type=PJObj.%Get("Type")
	s gHospId=PJObj.%Get("gHospId")
	s gLocId=PJObj.%Get("gLocId")
	s gGroupId=PJObj.%Get("gGroupId")
	s gUserId=PJObj.%Get("gUserId")
	s DocType=PJObj.%Get("DocType")
	s:fromUserDr="" fromUserDr=gUserId
	
	s obj=##class(User.CSSDPackageDispMain).%New()
	s Ret=..sssLock("DispScan")
	i Ret'=0 d RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"生成发放单号加锁失败！"))
	q:RtnObj.success'=0 RtnObj
	
	s No=##class(web.CSSDHUI.Common.AppCommon).GetAppNo("Disp")
	s obj.CSSDPDMSerialNo=No
	s obj.CSSDPDMDate=curDate
	s obj.CSSDPDMDispDate=nowDate
	s obj.CSSDPDMDispTime=nowTime
	d obj.CSSDPDMFromUserDrSetObjectId(fromUserDr)
	d obj.CSSDPDMFromLocDrSetObjectId(fromLocDr)
	d obj.CSSDPDMToLocDrSetObjectId(toLocDr)
	s obj.CSSDPDMType=Type
	s obj.CSSDPDMDocType=DocType
	s Sc=obj.%Save()
	i $$$ISERR(Sc) d ..sssUnLock("DispScan") d RtnObj.Err(-5,"",..%Translate($CLASSNAME(),"保存失败!"))
	q:RtnObj.success'=0 RtnObj
	d ..sssUnLock("DispScan")
	s mainRowid=obj.%Id()
	
	s RtnObj.rowid=mainRowid
	q RtnObj
}

/// Creator:ban
/// CreatDate:2022-2-22
/// Description:扫码发放主删除单据
/// Table:CSSD_PackageDispMain
/// d ##class(web.CSSDHUI.PackageDisp.DispScan).jsDelete(23)
ClassMethod jsDelete(Params As %String) As %Library.String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"入参解析失败!")).Json()
	
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

/// 不允许前端调用
/// d ##class(web.CSSDHUI.PackageDisp.DispScan).Delete(29)
ClassMethod Delete(mainRowId As %String) As web.CSSDHUI.RtnObj
{
	n (mainRowId)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i mainRowId="" d RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"入参不能为空!"))
	q:RtnObj.success'=0 RtnObj
	
	s MainObj=##Class(User.CSSDPackageDispMain).%OpenId(mainRowId)
	d MainObj.%Reload()
	s Type=MainObj.CSSDPDMType
	i Type'="Y" q RtnObj.Err(-2,"",..%Translate($CLASSNAME(),"单据类型错误！"),"",0)
	
	s ComplateFlag=MainObj.CSSDPDMComplateFlag
	i ComplateFlag="Y" d RtnObj.Err(-2,"",..%Translate($CLASSNAME(),"单据已经发放提交，不能删除"),"",0)
	q:RtnObj.success'=0 RtnObj
	
	s DispId=""
	f  s DispId=$o(^User.CSSDPackageDispI("CSSDPDCParrefDr",mainRowId,DispId)) q:(DispId="")||(RtnObj.success'=0)  d
	.q:+DispId=0
	.s DispObj=##class(User.CSSDPackageDisp).%OpenId(DispId)
	.q:'$IsObject(DispObj)
	.s RtnObj=##class(web.CSSDHUI.PackageDisp.DispItm).Delete(DispId)
	q:RtnObj.success'=0 RtnObj
	&sql(Delete FROM CSSD_PackageDispMain WHERE ID=:mainRowId)
	i SQLCODE'=0  d
	.d RtnObj.Err(-5,"",$ClassName()_"jsDelete:"_..%Translate($CLASSNAME(),"删除失败!"))
	q:RtnObj.success'=0 RtnObj
	
	q RtnObj
}

/// Description:打印单据时查询发放主表信息
/// Creator:	why
/// CreatDate:	2019-09-27
/// Table:		cssd_packagedispmain
/// w ##class(web.CSSDHUI.PackageDisp.DispScan).Select(14)
ClassMethod Select(DispMainId) As %String
{
	n (DispMainId)
	q:DispMainId="" "{}"
	&sql(SELECT ID,CSSDPDM_FromLoc_Dr->CTLOC_Desc,CSSDPDM_SerialNo,CSSDPDM_FromUser_dr->SSUSR_Name,CSSDPDM_ToLoc_Dr->CTLOC_Desc,CSSDPDM_DispDate,CSSDPDM_DispTime,CSSDPDM_FromLoc_Dr 
	INTO RowId,FromLocName,SerialNo,FromUserName,ToLocName,DispDate,DispTime,FromLocId 
	FROM CSSD_PackageDispMain WHERE ID=:DispMainId) 
	q:SQLCODE "{}"
	i DispDate'="" s DispCHKDateNew=..DL2H(DispDate)
	i DispTime'="" s DispDateTime=..TL2H(DispTime)
	s DispCHKDate=DispCHKDateNew_" "_DispDateTime
	s DataStr=RowId_"^"_FromLocName_"^"_SerialNo_"^"_FromUserName_"^"_ToLocName
		_"^"_DispCHKDate_"^"_FromLocId
	s TitleStr="RowId^FromLocName^SerialNo^FromUserName^ToLocName^DispDate^FromLocId"
	s Rtn=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(DataStr,TitleStr)
	q Rtn
}

/// Description:计算角标数量
/// Creator:lxt
/// Date:20220318
/// Table:
/// Input:Params
/// Output:Json
/// w ##class(web.CSSDHUI.PackageDisp.DispScan).GetMarkQty(^templxt("GetMarkQty"))
ClassMethod GetMarkQty(Params)
{
	n (Params)
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q "{}"
	
	s (UnTrfInNum)=0

	s Result=##class(%Library.ResultSet).%New("web.CSSDHUI.PackageDisp.DispScan:SelectAll")
	s sc=Result.Execute(Params)
	i $$$ISERR(sc) q "{}"
	While(Result.Next()){s UnTrfInNum=UnTrfInNum+1}
	d Result.Close()

	s RetData=UnTrfInNum
	s RetTitle="UnTrfInNum"
	s Ret=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(RetData,RetTitle)
	
	q Ret
}

/// Description:判断发放单中是否包含某标签
/// Input:		DispId-发放单主表id, Label-标签
/// Output:		Y-包含, N-不包含
ClassMethod CheckDispLabel(DispId, Label) As %String
{
	n (DispId,Label)
	s Flag="N"
	q:(DispId="")||(Label="") Flag
	
	s Type=$lg(^User.CSSDPackageDispMainD(DispId),12)
	s DispItmId=0
	f  s DispItmId=$o(^User.CSSDPackageDispI("CSSDPDCParrefDr",DispId,DispItmId)) q:(DispItmId="")||(Flag="Y")  d
	.s ItmLabel=$lg(^User.CSSDPackageDispD(DispItmId),5)
	.i (Type="Y")&&(ItmLabel[Label) s Flag="Y" q
	.
	.s DetailId=0
	.f  s DetailId=$o(^User.CSSDPackageDispDetailI("CSSDPDDParref",DispItmId,DetailId)) q:(DetailId="")||(Flag="Y")  d
	..s DetailLabel=$lg(^User.CSSDPackageDispDetailD(DetailId),3)
	..i DetailLabel[Label s Flag="Y" q
	
	q Flag
}

}
