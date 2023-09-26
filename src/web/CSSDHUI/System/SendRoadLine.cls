Import sqluser

Class web.CSSDHUI.System.SendRoadLine Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Descript:获取线路数据
/// Creator:ban
/// CreateDate:2022-11-18
/// Table:CSSD_SendRoadLineMain
/// Input:查询条件
/// Return：线路数据
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.System.SendRoadLine","SelectAll","{""System"":""3"",""gUserId"":""6423"",""gLocId"":""382"",""gGroupId"":""265"",""gHospId"":""2""}")
Query SelectAll(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,SupLocId,SupLocDesc,FloorCode,LineCode,LineDesc,LineUserId,LineUserName") [ SqlProc ]
{
}

ClassMethod SelectAllExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s gHospId = PJObj.%Get("gHospId")
	i gHospId="" q $$$OK

	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="select ID as RowId,CSSDSRLM_StockLOCDR as SupLocId,CSSDSRLM_LineCode as LineCode,"
			_" CSSDSRLM_LineDesc as LineDesc,CSSDSRLM_SenderDR as LineUserId"
			_" from CSSD_SendRoadLineMain"
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s SupLocId = Result.Data("SupLocId")	//供应中心
		s LineCode = Result.Data("LineCode")
		s LineDesc = Result.Data("LineDesc")
		s LineUserId=Result.Data("LineUserId")
		continue:SupLocId=""					//只要医院配置了供应中心,即可显示
		continue:'$d(^User.CSSDDeptCenterI("HospDept",gHospId,SupLocId))
		s SupLocDesc=$p(^CTLOC(SupLocId),"^",2)
		s LineUserName=$s(LineUserId'="":$p(^SSU("SSUSR",LineUserId),"^",2),1:"")
		d OutPutRow
	}
	d Result.Close()
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,SupLocId,SupLocDesc,FloorCode,LineCode,LineDesc,LineUserId,LineUserName)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:保存线路数据
/// Creator:ban
/// CreateDate:2022-11-18
/// Table:CSSD_SendRoadLineMain
/// Input:查询条件
/// Return：
/// w ##class(web.CSSDHUI.System.SendRoadLine).Save("[{""RowId"":""8"",""System"":""2"",""StockLocId"":""2"",""StoreLocDesc"":""呼吸内科门诊"",""FloorCode"":""13"",""LineCode"":""12"",""LineDes      c"":""2线"",""SendUserId"":""6425"",""SendUserName"":""admin"",""SystemDesc"":"" 卫生材料管理系统""}]")
ClassMethod jsSave(Params As %String) As %Library.String
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

/// Descript:保存线路数据
/// Creator:ban
/// CreateDate:2022-11-18
/// Table:CSSD_SendRoadLineMain
/// Input:查询条件
/// Return：
/// d ##class(web.CSSDHUI.System.SendRoadLine).Save()
ClassMethod Save(Params As %String) As web.CSSDHUI.RtnObj
{
	n (Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i Params="" q RtnObj.Err(-1,"","入参不能为空!")

	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-2,"","入参解析失败!")

	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""

		s RowId=Obj.%Get("RowId")
		s SupLocId=Obj.%Get("SupLocId")
		s LineCode=Obj.%Get("LineCode")
		s LineDesc=Obj.%Get("LineDesc")
		s LineUserId=Obj.%Get("LineUserId")

		s RoadLineId = $o(^User.CSSDSendRoadLineMainI("indexLineCode",LineCode,""))
		i ((RoadLineId '="")&&(RoadLineId'=RowId)) d RtnObj.Err(-3,"","线路编号重复！")
		continue:RtnObj.success'=0

		s LineObj=""
		i RowId="" d
		.s LineObj=##class(User.CSSDSendRoadLineMain).%New()
		e  d
		.s LineObj=##class(User.CSSDSendRoadLineMain).%OpenId(RowId)
		.d LineObj.%Reload()
		s LineObj.CSSDSRLMLineCode=LineCode
		s LineObj.CSSDSRLMDesc=LineDesc
		d LineObj.CSSDSRLMStockLOCDRSetObjectId(SupLocId)
		d LineObj.CSSDSRLMSenderDRSetObjectId(LineUserId)
		s Sc=LineObj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-4,"",$ClassName()_":Save:保存线路信息失败!")
		continue:RtnObj.success'=0
	}
	q RtnObj
}

/// Descript:删除线路
/// Creator:ban
/// CreateDate:2022-11-18
/// Table:CSSD_SendRoadLineMain
/// Input:查询条件
/// Return：线路数据
/// d ##class(web.CSSDHUI.System.SendRoadLine).jsDelete("[{""RowId"":""3"",""SupLocId"":""166"",""SupLocDesc"":""消毒供应室"",""FloorCode"":""1"",""LineCode"":""1"",""LineDesc"":""1"",""LineUserId"":""12204"",""LineUserName"":""高雪云""}]")
ClassMethod jsDelete(Params As %String) As %Library.String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0  q RtnObj.Err(-1,"","入参解析失败!").Json()

	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""

		s RowId=Obj.%Get("RowId")
		continue:RowId=""
		s RtnObj=..Delete(RowId)
		continue:RtnObj.success'=0
	}
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Descript:删除线路
/// Creator:ban
/// CreateDate:2022-11-18
/// Table:CSSD_SendRoadLineDetail
/// Input:查询条件
/// Return：
/// d ##class(web.CSSDHUI.System.SendRoadLine).Delete(214)
ClassMethod Delete(RowId As %String) As web.CSSDHUI.RtnObj
{
	n (RowId)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s LineObj=##class(User.CSSDSendRoadLineMain).%OpenId(RowId)
	d LineObj.%Reload()
	i '$IsObject(LineObj) d RtnObj.Err(-1,"","该线路已被删除，请核对!")
	q:RtnObj.success'=0 RtnObj

	s LineItmId=0
	f  s LineItmId=$o(^User.CSSDSendRoadLineDetailI("IndexRoadLineDR",RowId,LineItmId)) q:(LineItmId="")||(RtnObj.success'=0)  d
	.q:+LineItmId=0
	.s RtnObj=..DeleteItm(LineItmId)
	q:RtnObj.success'=0 RtnObj

	s LineTimeId=""
	f  s LineTimeId=$o(^User.CSSDSendRoadLineControlI("RoadLine",RowId,LineTimeId)) q:(LineTimeId="")||(RtnObj.success'=0)  d
	.q:+LineTimeId=0
	.s RtnObj=..DeleteLineTime(LineTimeId)
	q:RtnObj.success'=0 RtnObj

	&sql(Delete from CSSD_SendRoadLineMain where ID=:RowId)
	i SQLCODE'=0 d RtnObj.Err(-3,"",$ClassName()_".Delete:SQLCODE"_SQLCODE_":"_$g(%msg))
	q:RtnObj.success'=0 RtnObj

	q RtnObj
}

/// Descript:获取线路明细数据
/// Creator:ban
/// CreateDate:2022-11-18
/// Table:CSSD_SendRoadLineDetail
/// Input:查询条件
/// Return：线路明细数据
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.System.SendRoadLine","SelectLineItm",1)
Query SelectLineItm(RoadLineId As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,LocId,LocCode,LocDesc,SortNo:%Float") [ SqlProc ]
{
}

ClassMethod SelectLineItmExecute(ByRef qHandle As %Binary, RoadLineId As %String) As %Status
{
	n (qHandle,RoadLineId)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:RoadLineId="" $$$OK

	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="SELECT ID as RowId,CSSDSRLD_LocDR as LocId,CSSDSRLD_SortNo as SortNo FROM CSSD_SendRoadLineDetail"
			_" WHERE CSSDSRLD_RoadLineDR="_RoadLineId
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s LocId = Result.Data("LocId")
		s SortNo = Result.Data("SortNo")
		continue:LocId=""
		s LocCode=$p(^CTLOC(LocId),"^",1)
		s LocDesc=$p(^CTLOC(LocId),"^",2)
		d OutPutRowLineItm
	}
	d Result.Close()
	Quit $$$OK
OutPutRowLineItm
	s Data=$lb(RowId,LocId,LocCode,LocDesc,SortNo)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:保存线路明细
/// Creator:ban
/// CreateDate:2022-11-18
/// Table:CSSD_SendRoadLineDetail
/// Input:查询条件
/// Return：线路明细数据
/// d ##class(web.CSSDHUI.System.SendRoadLine).jsSaveItm()
ClassMethod jsSaveItm(RoadLineId As %String, Params As %String) As %Library.String
{
	n (RoadLineId,Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..SaveItm(RoadLineId,Params)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Descript:保存线路明细
/// Creator:ban
/// CreateDate:2022-11-18
/// Table:CSSD_SendRoadLineDetail
/// Input:查询条件
/// Return：线路明细数据
/// d ##class(web.CSSDHUI.System.SendRoadLine).SaveItm()
ClassMethod SaveItm(RoadLineId As %String, Params As %String) As web.CSSDHUI.RtnObj
{
	n (RoadLineId,Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i ((RoadLineId="")||(Params="")) q RtnObj.Err(-1,"","入参不能为空!")

	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-2,"","入参解析失败!")

	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""

		s RowId=Obj.%Get("RowId")
		s LocId=Obj.%Get("LocId")
		s SortNo=Obj.%Get("SortNo")
		s LocDesc=""
		s:($D(^CTLOC(LocId))) LocDesc=$p(^CTLOC(LocId),"^",2)
		s TmpId=$o(^User.CSSDSendRoadLineDetailI("indexLineLoc",RoadLineId,LocId,""))
		i ((TmpId'="")&&(RowId'=TmpId)) d RtnObj.Err(-2,"",LocDesc_":科室重复")
		continue:RtnObj.success'=0

		s maxSortNo=$o(^User.CSSDSendRoadLineDetailI("IndexSortNo",""),-1)
		i SortNo>=maxSortNo s SortNo=maxSortNo+1

		s LineItmObj=""
		i RowId="" d
		.s LineItmObj=##class(User.CSSDSendRoadLineDetail).%New()
		e  d
		.s LineItmObj=##class(User.CSSDSendRoadLineDetail).%OpenId(RowId)
		.d LineItmObj.%Reload()
		d LineItmObj.CSSDSRLDRoadLineDRSetObjectId(RoadLineId)
		d LineItmObj.CSSDSRLDLocDRSetObjectId(LocId)
		s LineItmObj.CSSDSRLDSortNo=SortNo
		s Sc=LineItmObj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-3,"",$ClassName()_":SaveItm:线路保存科室信息失败!")
		continue:RtnObj.success'=0
	}
	q RtnObj
}

/// Descript:删除线路明细
/// Creator:ban
/// CreateDate:2022-11-18
/// Table:CSSD_SendRoadLineDetail
/// Input:查询条件
/// Return：线路明细数据
/// d ##class(web.CSSDHUI.System.SendRoadLine).jsDeleteItm(214)
ClassMethod jsDeleteItm(Params As %String) As %Library.String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0  q RtnObj.Err(-1,"","入参解析失败!").Json()

	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""

		s RowId=Obj.%Get("RowId")
		continue:RowId=""
		s RtnObj=..DeleteItm(RowId)
		continue:RtnObj.success'=0
	}
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Descript:删除路线明细
/// Creator:ban
/// CreateDate:2022-11-18
/// Table:CSSD_SendRoadLineDetail
/// Input:查询条件
/// Return：路线明细数据
/// d ##class(web.CSSDHUI.System.SendRoadLine).DeleteItm(214)
ClassMethod DeleteItm(RowId As %String) As web.CSSDHUI.RtnObj
{
	n (RowId)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s LineItm=##class(User.CSSDSendRoadLineDetail).%OpenId(RowId)
	d LineItm.%Reload()
	i '$IsObject(LineItm) d RtnObj.Err(-1,"","该科室已被删除，请核对!")
	q:RtnObj.success'=0 RtnObj

	&sql(Delete from CSSD_SendRoadLineDetail where ID=:RowId)
	i SQLCODE'=0 d RtnObj.Err(-2,"",$ClassName()_".DeleteItm:SQLCODE"_SQLCODE_":"_$g(%msg))
	q:RtnObj.success'=0 RtnObj

	q RtnObj
}

/// Descript:获取线路时间
/// Creator:yj
/// CreateDate:2023-2-21
/// Table:CSSD_SendRoadLineControl
/// Input:线路ID
/// Return：线路时间
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.System.SendRoadLine","SelectLineTime",2)
Query SelectLineTime(RoadLineId As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,StartTime,EndTime") [ SqlProc ]
{
}

ClassMethod SelectLineTimeExecute(ByRef qHandle As %Binary, RoadLineId As %String) As %Status
{
	n (qHandle,RoadLineId)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:RoadLineId="" $$$OK

	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="SELECT ID as RowId,CSSDSRLC_StartTime as StartTime,CSSDSRLC_EndTime as EndTime FROM CSSD_SendRoadLineControl"
			_" WHERE CSSDSRLC_RoadLineDR="_RoadLineId
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s StartTime = Result.Data("StartTime")
		s EndTime = Result.Data("EndTime")
		s StartTime=$zt(StartTime,2)
		s EndTime=$zt(EndTime,2)
		d OutPutRowLineTime
	}
	d Result.Close()
	q $$$OK
OutPutRowLineTime
	s Data=$lb(RowId,StartTime,EndTime)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:保存线路时间
/// Creator:yj
/// CreateDate:2023-2-21
/// Table:CSSD_SendRoadLineControl
/// Input:RoadLineId:线路id  Params:要保存的数据
/// Return：
/// d ##class(web.CSSDHUI.System.SendRoadLine).jsSaveTime()
ClassMethod jsSaveLineTime(RoadLineId As %String, Params As %String) As %Library.String
{
	n (RoadLineId,Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..SaveLineTime(RoadLineId,Params)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Descript:保存线路时间
/// Creator:yj
/// CreateDate:2023-2-22
/// Table:CSSD_SendRoadLineControl
/// Input:RoadLineId:线路id  Params:要保存的数据
/// Return：
/// d ##class(web.CSSDHUI.System.SendRoadLine).SaveTime()
ClassMethod SaveLineTime(RoadLineId As %String, Params As %String) As web.CSSDHUI.RtnObj
{
	n (RoadLineId,Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i ((RoadLineId="")||(Params="")) q RtnObj.Err(-1,"","入参不能为空!")

	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-2,"","入参解析失败!")

	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""

		s RowId=Obj.%Get("RowId")
		s PStartTime=Obj.%Get("StartTime")
		s PEndTime=Obj.%Get("EndTime")
		S StartTime=..TH2L(PStartTime)
		S EndTime=..TH2L(PEndTime)
		i EndTime<=StartTime d RtnObj.Err(-3,"",$ClassName()_":SaveItm:结束时间需大于开始时间")

		s LineTimeObj=""
		i RowId="" d
		.s LineTimeObj=##class(User.CSSDSendRoadLineControl).%New()
		e  d
		.s LineTimeObj=##class(User.CSSDSendRoadLineControl).%OpenId(RowId)
		.d LineTimeObj.%Reload()
		d LineTimeObj.CSSDSRLCRoadLineDRSetObjectId(RoadLineId)
		s LineTimeObj.CSSDSRLCStartTime=StartTime
		s LineTimeObj.CSSDSRLCEndTime=EndTime
		s Sc=LineTimeObj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-4,"",$ClassName()_":SaveItm:线路控制时间信息保存失败!")
		continue:RtnObj.success'=0
	}
	q RtnObj
}

/// Descript:删除线路时间
/// Creator:yj
/// CreateDate:2023-2-22
/// Table:CSSD_SendRoadLineControl
/// Input:Params
/// Return：
/// d ##class(web.CSSDHUI.System.SendRoadLine).jsDeleteLineTime(214)
ClassMethod jsDeleteLineTime(Params As %String) As %Library.String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0  q RtnObj.Err(-1,"","入参解析失败!").Json()

	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""

		s RowId=Obj.%Get("RowId")
		continue:RowId=""
		s RtnObj=..DeleteLineTime(RowId)
		continue:RtnObj.success'=0
	}
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Descript:删除线路时间
/// Creator:yj
/// CreateDate:2023-2-22
/// Table:CSSD_SendRoadLineControl
/// Input:RowId
/// Return：
/// d ##class(web.CSSDHUI.System.SendRoadLine).DeleteLineTime(2)
ClassMethod DeleteLineTime(RowId As %String) As web.CSSDHUI.RtnObj
{
	n (RowId)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s LineTimeObj=##class(User.CSSDSendRoadLineControl).%OpenId(RowId)
	d LineTimeObj.%Reload()
	i '$IsObject(LineTimeObj) d RtnObj.Err(-1,"","该时间段已被删除，请核对!")
	q:RtnObj.success'=0 RtnObj

	&sql(Delete from CSSD_SendRoadLineControl where ID=:RowId)
	i SQLCODE'=0 d RtnObj.Err(-2,"",$ClassName()_".DeleteTime:SQLCODE"_SQLCODE_":"_$g(%msg))
	q:RtnObj.success'=0 RtnObj

	q RtnObj
}

/// w ##class(web.CSSDHUI.System.SendRoadLine).jsCheckLocTime(3,$p($h,",",2),1)
ClassMethod jsCheckLocTime(LocId As %String, Time As %String, SupLocId As %String = "") As %Library.String
{
	n (LocId,Time,SupLocId)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..CheckLocTime(LocId,Time,SupLocId)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Descript:指定时间，科室是否在有效时间段内
/// Creator:yj
/// CreateDate:2023-2-22
/// Input:RowId
/// Return：LocId 科室Id 	Time 指定时间		SupLocId 供应科室
/// d ##class(web.CSSDHUI.System.SendRoadLine).CheckLocTime(166,"13:11:33")
ClassMethod CheckLocTime(LocId As %String, Time As %String, SupLocId As %String = "") As web.CSSDHUI.RtnObj
{

	n (LocId,Time,SupLocId)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	q:((LocId="")||(Time="")) RtnObj.Err(-1,"","入参不能为空!")

	s ControlFlag="N"
	s PermitFlag="N"
	s NewTime=..TH2L(Time)

	s Result=##class(%Library.ResultSet).%New()
	s SqlStr1="SELECT CSSDSRLC_StartTime StartTime,CSSDSRLC_EndTime EndTime FROM CSSD_SendRoadLineControl WHERE 1=1 "
	s SqlStr2="SELECT CSSDSRLD_RoadLineDR FROM CSSD_SendRoadLineDetail WHERE CSSDSRLD_LocDR="_LocId
	i SupLocId'="" s SqlStr2=SqlStr2_" AND CSSDSRLD_RoadLineDR->CSSDSRLM_StockLOCDR="_SupLocId
	s SqlStr=SqlStr1_" AND CSSDSRLC_RoadLineDR IN ("_SqlStr2_")"
	b ;1
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s ControlFlag="Y"
		s StartTime = Result.Data("StartTime")
		s EndTime = Result.Data("EndTime")
		s:((NewTime<=EndTime)&&(NewTime>=StartTime)) PermitFlag="Y"
	}
	i (ControlFlag="Y")&&(PermitFlag="N") d RtnObj.Err(-2,"","申请科室不在线路有效时间范围内!")
	q RtnObj
}

}
