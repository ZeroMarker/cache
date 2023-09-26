Import sqluser

Class web.CSSDHUI.System.SatisfactionSurvey Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Creator:ban
/// CreatDate:2022-3-23
/// Description:满意度调查主界面查询
/// Table:CSSD_SatisfactionMain
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.System.SatisfactionSurvey","SelectAll",^tmpmy("vf"))
Query SelectAll(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,No,LocId,LocDesc,CreateDate,CreateUserName,Flag,SubmitDate,SubmitUserName")
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
	
	s PLocId=PJObj.%Get("LocId")
	s FStartDate=PJObj.%Get("FStartDate")
	s FEndDate=PJObj.%Get("FEndDate")
	s gHospId=PJObj.%Get("gHospId")
	s MainId=PJObj.%Get("MainId")
	s SupplyLocStr=..GetSupplyLoc(gHospId)
	s FStartDate=..DH2L(FStartDate)
	s FEndDate=..DH2L(FEndDate)
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="SELECT ID,CSSDSM_No,CSSDSM_Loc,CSSDSM_Loc->CTLOC_Hospital_DR as HospId,"
			_" CSSDSM_Date,CSSDSM_Time,CSSDSM_User_DR,CSSDSM_Flag,CSSDSM_SubmitDate,"
			_" CSSDSM_SubmitTime,CSSDSM_SubmitUser_DR FROM CSSD_SatisfactionMain"
			_" where CSSDSM_Date between "_FStartDate_" and "_FEndDate
	i MainId'="" d
	.s SqlStr=SqlStr_" and ID="_MainId
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{	
		s RowId = Result.Data("ID")
		s No= Result.Data("CSSDSM_No")
		s LocId = Result.Data("CSSDSM_Loc")
		s HospId = Result.Data("HospId")
		s CreateDate = Result.Data("CSSDSM_Date")
		s CreateTime = Result.Data("CSSDSM_Time")
		s CreateUserId = Result.Data("CSSDSM_User_DR")
		s Flag = Result.Data("CSSDSM_Flag")
		s SubmitDate = Result.Data("CSSDSM_SubmitDate")
		s SubmitTime = Result.Data("CSSDSM_SubmitTime")
		s SubmitUserId=Result.Data("CSSDSM_SubmitUser_DR")
		continue:(MainId="")&&(PLocId'="")&&(SupplyLocStr'[("^"_PLocId_"^"))&&(PLocId'=LocId)
		continue:(gHospId'="")&&(gHospId'=HospId)
		s LocDesc=..sssLocDesc(LocId)
		s CreateUserName=$s(CreateUserId'="":$p(^SSU("SSUSR",CreateUserId),"^",2),1:"")
		s SubmitUserName=$s(SubmitUserId'="":$p(^SSU("SSUSR",SubmitUserId),"^",2),1:"")
		s CreateUserName=..%FieldTranslate("User.SSUser","SSUSRName",CreateUserName)
		s SubmitUserName=..%FieldTranslate("User.SSUser","SSUSRName",SubmitUserName)
		s CreateDate=..DL2H(CreateDate)_" "_..TL2H(CreateTime)
		s SubmitDate=..DL2H(SubmitDate)_" "_..TL2H(SubmitTime)
		d OutPutRow
	}
	d Result.Close()
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,No,LocId,LocDesc,CreateDate,CreateUserName,Flag,SubmitDate,SubmitUserName)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creator:ban
/// CreatDate:2022-3-23
/// Description:删除满意度调查主表信息
/// Table:CSSD_SatisfactionMain
/// d ##class(web.CSSDHUI.System.SatisfactionSurvey).jsDelete(^tmpmy("cdcvdv"))
ClassMethod jsDelete(Params As %String) As %Library.String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!").Json()
	
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

/// Creator:ban
/// CreatDate:2022-3-23
/// Description:删除满意度调查主表信息
/// Table:CSSD_SatisfactionMain
/// d ##class(web.CSSDHUI.System.SatisfactionSurvey).Delete(214)
ClassMethod Delete(RowId As %String) As web.CSSDHUI.RtnObj
{
	n (RowId)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i RowId="" q RtnObj.Err(-2,"",..%Translate($CLASSNAME(),"入参为空!"))
	s SfItmId=$o(^User.CSSDSatisfactionDetailI("CSSDSDMainDrIndex",RowId,""))
	i SfItmId'="" d
	.&sql(DELETE FROM CSSD_SatisfactionDetail WHERE CSSDSD_MainDr=:RowId)
	.i SQLCODE'=0 d RtnObj.Err(-3,"",..%Translate($CLASSNAME(),"删除调查详情信息失败!"))
	q:RtnObj.success<0 RtnObj
	&sql(DELETE FROM CSSD_SatisfactionMain WHERE ID=:RowId)
	i SQLCODE'=0 q RtnObj.Err(-4,"",..%Translate($CLASSNAME(),"删除调查主单失败!"))
	
	q RtnObj
}

///  Creator:ban
///  CreatDate:2022-3-23
///  Description:生成满意度单号
///  Table:CSSD_SatisfactionMain
///  Input:
///  Output:
///  Return:
/// w ##Class(web.CSSDHUI.System.SatisfactionSurvey).CreateNo("166","2")
ClassMethod CreateNo(gLocId, gHospId) As %String
{
	n (gLocId,gHospId)
	s date=$zd(+$h,8)
	s dateday=+$h
	s regid=$o(^User.CSSDSatisfactionMainI("CSSDSMDateLocIndex",dateday,gLocId,""),-1)
	i regid'="" d
	.s maxNo=$List(^User.CSSDSatisfactionMainD(regid),2)
	e  d
	.s maxNo=""
	s Num=+$e(maxNo,$l(maxNo)-4,$l(maxNo))
	s Num=Num+1
	s Num=$tr($j(Num,5)," ","0")
	s SatisfactionNo=date_gHospId_Num
	q SatisfactionNo
}

/// Creator:ban
/// CreatDate:2022-3-23
/// Description:保存满意度调查主表信息
/// Table:CSSD_SatisfactionMain
/// d ##class(web.CSSDHUI.System.SatisfactionSurvey).jsSave("{""DeptLocID"":""166"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2"",""FStartD"":"""",""FEndD"":""""}","[{""CreateLocDesc"":""消毒供应室"",""CreateLocDR"":""166""}]")
ClassMethod jsSave(Params As %String, MainParams As %String) As %Library.String
{
	n (Params,MainParams)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..Save(Params,MainParams)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:ban
/// CreatDate:2022-3-23
/// Description:保存满意度调查主表信息
/// Table:CSSD_SatisfactionMain
/// d ##class(web.CSSDHUI.System.SatisfactionSurvey).Save()
ClassMethod Save(Params, MainParams) As web.CSSDHUI.RtnObj
{
	n (Params,MainParams)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s MainPJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s MainSc=MainPJObj.%FromJSON(MainParams)
	s Sc=PJObj.%FromJSON(Params)
	i ((Sc'=0)||(MainSc'=0)) d RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"入参解析失败!"))
	q:RtnObj.success'=0 RtnObj
	
	s gUserId=PJObj.%Get("gUserId")
	s gLocId=PJObj.%Get("gLocId")
	s gHospId=PJObj.%Get("gHospId")
	
	while(RtnObj.success=0){
		s Obj=MainPJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s LocId=Obj.%Get("LocId")
		s CreateDate=+$h
		s CreateTime=$P($h,",",2)
		
		s ret=..sssLock("Satisfaction")
		i ret'=0 d RtnObj.Err(-2,"",..%Translate($CLASSNAME(),"生成调查单号加锁失败！"))
		q:RtnObj.success'=0
		s No=..CreateNo(LocId,gHospId)
		i No="" d ..sssUnLock("Satisfaction") d RtnObj.Err(-3,"",..%Translate($CLASSNAME(),"生成调查单号失败！"))
		q:RtnObj.success'=0
		
		s obj=""
		i RowId="" d
		.s obj=##class(User.CSSDSatisfactionMain).%New()
		e  d
		.s obj=##class(User.CSSDSatisfactionMain).%OpenId(RowId)
		.d obj.%Reload()
		s obj.CSSDSMNo=No
		s obj.CSSDSMLoc=##class(User.CTLoc).%OpenId(LocId)
		s obj.CSSDSMDate=CreateDate
		s obj.CSSDSMTime=CreateTime
		s obj.CSSDSMUserDr=##class(User.SSUser).%OpenId(gUserId)
		s Sc=obj.%Save()
		i $$$ISERR(Sc) d
		.d ..sssUnLock("Satisfaction")
		.d RtnObj.Err(-4,"",..%Translate($CLASSNAME(),"保存失败!"))
		q:RtnObj.success'=0
		d ..sssUnLock("Satisfaction")
		s RowId=obj.%Id()
		s RtnObj.rowid=RowId
	}
	q RtnObj
}

/// Creator:ban
/// CreatDate:2022-3-29
///  Description:撤销调查信息
///  Table:CSSD_SatisfactionMain
///  w ##class(web.CSSDHUI.System.SatisfactionSurvey).jsCancelOrder(2,"Y")
ClassMethod jsCancelOrder(Params As %String) As %Library.String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"入参解析失败！"))
	q:RtnObj.success'=0 RtnObj.Json()
	s gUserId = PJObj.%Get("gUserId")
	s SfMainId = PJObj.%Get("MainId")
	i SfMainId="" d RtnObj.Err(-2,"",..%Translate($CLASSNAME(),"入参不能为空!"))
	q:RtnObj.success'=0 RtnObj.Json()
	
	ts
	&sql(update CSSD_SatisfactionMain set 
		CSSDSM_Flag='N',CSSDSM_SubmitUser_DR =null,
		CSSDSM_SubmitDate=null,CSSDSM_SubmitTime=null 
		where ID=:SfMainId)
	i SQLCODE'=0 d RtnObj.Err(-3,"",..%Translate($CLASSNAME(),"撤销调查信息数据失败!"))
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:ban
/// CreatDate:2022-3-29
///  Description:提交调查信息
///  Table:CSSD_SatisfactionMain
///  w ##class(web.CSSDHUI.System.SatisfactionSurvey).jsSubmitOrder()
ClassMethod jsSubmitOrder(Params As %String) As %Library.String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"入参解析失败！"))
	q:RtnObj.success'=0 RtnObj.Json()
	s gUserId=PJObj.%Get("gUserId")
	s SfMainId=PJObj.%Get("MainId")
	i SfMainId="" d RtnObj.Err(-2,"",..%Translate($CLASSNAME(),"详情未维护，不允许提交!"))
	q:RtnObj.success'=0 RtnObj.Json()
	
	s SfItmId=$o(^User.CSSDSatisfactionDetailI("CSSDSDMainDrIndex",SfMainId,""))
	i SfItmId="" d RtnObj.Err(-3,"",..%Translate($CLASSNAME(),"未填写调查详情不能提交!"))
	q:RtnObj.success'=0 RtnObj.Json()
	
	s SubmitDate=+$h
	s SubmitTime=$P($h,",",2)
	ts
	&sql(update CSSD_SatisfactionMain set 
		CSSDSM_Flag='Y',CSSDSM_SubmitUser_DR =:gUserId,
		CSSDSM_SubmitDate=:SubmitDate,CSSDSM_SubmitTime=:SubmitTime 
		where ID=:SfMainId)
	i SQLCODE'=0 d RtnObj.Err(-4,"",..%Translate($CLASSNAME(),"提交调查信息数据失败!"))
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:ban
/// CreatDate:2022-3-23
/// Description:新增获取满意度调查项目
/// Table:CSSD_SatisfactionDetail
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.System.SatisfactionSurvey","SelectByF",^tmpmy("cgrg"))
Query SelectByF(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,SatisfactionId,SatisfactionDesc,Type,Result") [ SqlProc ]
{
}

ClassMethod SelectByFExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 $$$OK
	
	s gHospId=PJObj.%Get("gHospId")
	s PType=PJObj.%Get("SatisfactionType")
	s SfMainId=PJObj.%Get("MainId")
	q:SfMainId="" $$$OK
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="SELECT ID,S_Desc,S_Type,S_UseFlag FROM CT_STER_CSSD.Satisfaction"
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s SatisfactionId=Result.Data("ID")
		s SatisfactionDesc=Result.Data("S_Desc")
		s SatisfactionDesc=..%FieldTranslate("CT.STER.CSSD.Satisfaction","SDesc",SatisfactionDesc)
		s Type=Result.Data("S_Type")
		s UseFlag=Result.Data("S_UseFlag")
		
		s ShowDataFlag=##class(web.CSSDHUI.HospMap).GetShowDataFlag("CT_STER_CSSD.Satisfaction",SatisfactionId,gHospId)
		continue:ShowDataFlag="N"
		continue:((PType'="")&&(PType'=Type))
		
		s RowId=""
		s MainObj=##class(User.CSSDSatisfactionMain).%OpenId(SfMainId)
		s Flag=MainObj.CSSDSMFlag
		s RowId=$o(^User.CSSDSatisfactionDetailI("CSSDSDMainDrSatisfactionDrIndex",SfMainId,SatisfactionId,""))
		continue:(Flag="Y")&&(RowId="")							// 已提交的只显示保存的明细
		continue:(Flag'="Y")&&(UseFlag'="Y")&&(RowId="")		// 已保存未提交的显示保存的以及可用的
		s SatisfactionResult=""
		i RowId'="" d
		.s DetailObj=##class(User.CSSDSatisfactionDetail).%OpenId(RowId)
		.s SatisfactionResult=DetailObj.CSSDSDResult
		d OutPutItem
	}
	d Result.Close()
	Quit $$$OK
OutPutItem
	s Data=$lb(RowId,SatisfactionId,SatisfactionDesc,Type,SatisfactionResult)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creator:ban
/// CreatDate:2022-3-23
/// Description:保存满意度调查详情信息
/// Table:CSSD_SatisfactionDetail
/// d ##class(web.CSSDHUI.System.SatisfactionSurvey).jsSaveDetail("")
ClassMethod jsSaveDetail(Params As %String, MainId As %String) As %Library.String
{
	n (Params,MainId)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()	
	ts
	s RtnObj=..SaveDetail(Params,MainId)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:ban
/// CreatDate:2022-3-23
/// Description:保存满意度调查详情信息
/// Table:CSSD_SatisfactionDetail
/// d ##class(web.CSSDHUI.System.SatisfactionSurvey).SaveDetail()
ClassMethod SaveDetail(Params, MainId) As web.CSSDHUI.RtnObj
{
	n (Params,MainId)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"入参解析失败!"))
	q:RtnObj.success'=0 RtnObj
	
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s SatisfactionId=Obj.%Get("SatisfactionId")
		s Type=Obj.%Get("Type")
		s Result=Obj.%Get("Result")
		i Result="" d RtnObj.Err(-4,"",..%Translate($CLASSNAME(),"请填写完整调查明细!"))
		q:RtnObj.success'=0
		s obj=""
		i RowId="" d
		.s obj=##class(User.CSSDSatisfactionDetail).%New()
		e  d
		.s obj=##class(User.CSSDSatisfactionDetail).%OpenId(RowId)
		.d obj.%Reload()
		s obj.CSSDSDMainDr=##class(User.CSSDSatisfactionMain).%OpenId(MainId)
		s obj.CSSDSDSatisfactionDr=##class(CT.STER.CSSD.Satisfaction).%OpenId(SatisfactionId)
		s obj.CSSDSDResult=Result
		s Sc=obj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-5,"",..%Translate($CLASSNAME(),"保存满意度调查信息失败!"))
		q:RtnObj.success'=0
	}
	q RtnObj
}

/// Creator:wn
/// CreatDate:2022-7-7
/// Description:获取码表维护中供应中心科室串
/// Table:CSSD_DeptCenter
/// w ##class(web.CSSDHUI.System.SatisfactionSurvey).GetSupplyLoc(2)
ClassMethod GetSupplyLoc(gHospId As %String) As %String
{
	n (gHospId)
	s LocStr=""
	s SupplyId=""
	f  s SupplyId=$o(^User.CSSDDeptCenterI("HospDept",gHospId,SupplyId)) q:SupplyId=""  d
	.s LocStr=LocStr_"^"_SupplyId
	
	s LocStr=LocStr_"^"
	q LocStr
}

}
