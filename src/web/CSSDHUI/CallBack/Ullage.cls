Import sqluser

Class web.CSSDHUI.CallBack.Ullage Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Description:保存报损登记页面数据
/// Creater:zn
/// CreateDate:	2020-07-22
/// Table:User.CSSDUllage
/// w ##class(web.CSSDHUI.CallBack.Ullage).jsUllageItemSave()
ClassMethod jsUllageSave(User As %String, Params As %String) As %Library.String
{
	n (%session,User,Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s RtnObj=..UllageSave(User,Params)
	q RtnObj.Json()
}

ClassMethod UllageSave(User As %String, Params As %String) As web.CSSDHUI.RtnObj
{
	n (%session,User,Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	s ret=..sssLock("Ullage")
	i ret'=0 d RtnObj.Err(-2,"","单号加锁失败!")
	q:RtnObj.success'=0 RtnObj
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s No=##class(web.CSSDHUI.Common.AppCommon).GetAppNo("Ullage")
		s commitDate=+$h
		s commitTime=$P($h,",",2)
		s LocId=Obj.%Get("LocId")
		i RowId="" d
		.&sql(insert into cssd_ullage( CSSDU_No,CSSDU_Loc,CSSDU_Register,CSSDU_Date,CSSDU_Time) values (:No,:LocId,:User,:commitDate,:commitTime))
		.i SQLCODE'=0 d RtnObj.Err(-3,"",$ClassName()_"jsUllageSave:保存失败!")
		e  d
		.&sql(update cssd_ullage set CSSDU_Loc=:LocId where ID=:RowId)
		.i SQLCODE'=0 d RtnObj.Err(-4,"",$ClassName()_"jsUllageSave:修改失败!")
		continue:RtnObj.success'=0
		s RowId=%ROWID
		s RtnObj.rowid=RowId
		
	}
	i RtnObj.success<0 tro  d ..sssUnLock("Ullage") q RtnObj
	tc
	d ..sssUnLock("Ullage")
	q RtnObj
}

///  Creator:zn
///  CreatDate:2020.07.28
///  Description:报损单执行提交
///  Table:User.CSSDUllage 
///  w ##class(web.CSSDHUI.CallBack.Ullage).jsSubmitUll(20,1)
ClassMethod jsSubmitUll(mainRowId As %String, gUser As %String) As %Library.String
{
	n (%session,mainRowId,gUser)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..SubmitUll(mainRowId,gUser)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

ClassMethod SubmitUll(mainRowId As %String, gUser As %String) As web.CSSDHUI.RtnObj
{
	n (%session,mainRowId,gUser)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i mainRowId="" d RtnObj.Err(-1,"","入参不能为空!")
	q:RtnObj.success'=0 RtnObj
	s MainObj=##Class(User.CSSDUllage).%OpenId(mainRowId)
	d MainObj.%Reload()
	q:'$IsObject(MainObj) RtnObj.Err(-2,"","主单不存在")
	
	s Flag=MainObj.CSSDUComplateFlag
	i Flag="Y" d RtnObj.Err(-2,"","已经提交单据不可以重复提交")
	q:RtnObj.success'=0 RtnObj

	s detailid=$o(^User.CSSDUllageDetailI("CSSDUDMainDrIndex",mainRowId,""))
	i detailid="" d RtnObj.Err(-3,"","无明细不能提交")
	q:RtnObj.success'=0 RtnObj
	s commitTime=$P($h,",",2)
	s commitDate=$P($h,",",1)
	&sql(Update CSSD_Ullage set CSSDU_Register=:gUser,CSSDU_ComplateFlag='Y',CSSDU_Date=:commitDate,CSSDU_Time=:commitTime  WHERE ID=:mainRowId)
	i SQLCODE'=0 d RtnObj.Err(-4,mainRowId,$ClassName()_".Update:SQLCODE"_SQLCODE_":"_$g(%msg))
	q:RtnObj.success'=0 RtnObj

	q RtnObj
}

/// Creator:zn
/// CreatDate:2020.07.28
/// Description:报损单撤销提交
/// Table:User.CSSDUllage 
/// w ##class(web.CSSDHUI.CallBack.Ullage).jsCancelUll("20")
ClassMethod jsCancelUll(mainRowId As %String) As %Library.String
{
	n (%session,mainRowId)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..CancelUll(mainRowId)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

ClassMethod CancelUll(mainRowId As %String) As web.CSSDHUI.RtnObj
{
	n (%session,mainRowId)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i mainRowId="" d RtnObj.Err(-1,"","入参不能为空!")
	q:RtnObj.success'=0 RtnObj
	s MainObj=##Class(User.CSSDUllage).%OpenId(mainRowId)
	d MainObj.%Reload()
	q:'$IsObject(MainObj) RtnObj.Err(-1,"","主单已删除")
	
	s Flag=MainObj.CSSDUComplateFlag
	i Flag'="Y" d RtnObj.Err(-2,"","未提交单据不能进行撤销操作!")
	q:RtnObj.success'=0 RtnObj
	
	&sql(Update CSSD_Ullage set  CSSDU_ComplateFlag='N'  WHERE ID=:mainRowId)
	i SQLCODE'=0 d RtnObj.Err(-3,mainRowId,$ClassName()_".Update:SQLCODE"_SQLCODE_":"_$g(%msg))
	q:RtnObj.success'=0 RtnObj
	
	q RtnObj
}

/// Creator:zn
/// CreatDate:2020.07.28
/// Description:报损单查询
/// Table:User.CSSDUllage 											                    
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.CallBack.Ullage","GetUllageInfo","{""PhaLoc"":"""",""gUserId"":""11070"",""gLocId"":""316"",""gGroupId"":""103"",""gHospId"":""2"",""FStartDate"":""2020-07-29""}")
Query GetUllageInfo(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,No,LocId,LocDesc,commitDate,callName,ComplateFlag") [ SqlProc ]
{
}

ClassMethod GetUllageInfoExecute(ByRef qHandle As %Binary, Params) As %Status
{
	n (%session,qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s PhaLoc = PJObj.%Get("PhaLoc")
	s FStartDate = PJObj.%Get("FStartDate")
	s FEndDate=PJObj.%Get("FEndDate")
	s gHospId=PJObj.%Get("gHospId")
	s FStartDate=..DH2L(FStartDate)
	s FEndDate=..DH2L(FEndDate)
	q:(FStartDate="")||(FEndDate="") $$$OK
	q:(PhaLoc="") $$$OK
	
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="SELECT ID as RowId, CSSDU_No, CSSDU_Loc as LocId,CSSDU_Loc->CTLOC_Desc As LocDesc, CSSDU_Date as commitDate, "
		_"CSSDU_Time As commitTime,CSSDU_Register->SSUSR_Name as callDr,CSSDU_ComplateFlag FROM CSSD_Ullage "
		_" where (CSSDU_Date between "_FStartDate_" and "_FEndDate_") and CSSDU_Loc="_PhaLoc
	
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s No=Result.Data("CSSDU_No")
		s LocId = Result.Data("LocId")
		s LocDesc = Result.Data("LocDesc")
		s callName=Result.Data("callDr")
		s ComplateFlag=Result.Data("CSSDU_ComplateFlag")
		s commitDate=Result.Data("commitDate")
		s commitTime=Result.Data("commitTime")
		s commitDate=..DL2H(commitDate)_" "_..TL2H(commitTime)
		d OutPutUllage
	}
	d Result.Close()
	Quit $$$OK
OutPutUllage
	s Data=$lb(RowId,No,LocId,LocDesc,commitDate,callName,ComplateFlag)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creator:zn
/// CreatDate:2020.07.28
/// Description:报损单明细查询
/// Table:CSSD_UllageDetail,CSSD_MachineConsumeReason
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.CallBack.Ullage","GetItemInfo","28")
Query GetItemInfo(Parref As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,ItemId,ItemDesc,ConsumeQty,ConsumeReasonDR,ConsumeReasonName,Spec") [ SqlProc ]
{
}

ClassMethod GetItemInfoExecute(ByRef qHandle As %Binary, Parref As %String) As %Status
{
	n (%session,qHandle,Parref)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="SELECT ID, CSSDUD_Item, CSSDUD_Num,CSSDUD_ConsumeReason_DR "
			_" FROM CSSD_UllageDetail WHERE CSSDUD_MainDr="_Parref
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("ID")
		s ItemId = Result.Data("CSSDUD_Item")
		s ItemDesc="",Spec=""
		s ItemObj=##Class(User.CSSDItem).%OpenId(ItemId)
		continue:'$IsObject(ItemObj)
		s ItemDesc=ItemObj.CSSDIDesc
		s Spec=ItemObj.CSSDISpec
		s ConsumeQty = Result.Data("CSSDUD_Num")
		s ConsumeReasonDR = Result.Data("CSSDUD_ConsumeReason_DR")
		s ConsumeReasonName=""
		i ConsumeReasonDR'=""  d
		.s ConsumeReasonObj = ##class(User.CSSDMachineConsumeReason).%OpenId(ConsumeReasonDR)
		.s ConsumeReasonName=ConsumeReasonObj.CSSDMConsumeDesc
		d OutPutItemDetailRow
	}
	d Result.Close()
	Quit $$$OK
OutPutItemDetailRow
	s Data=$lb(RowId,ItemId,ItemDesc,ConsumeQty,ConsumeReasonDR,ConsumeReasonName,Spec)   
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creator:zn
/// CreatDate:2020.07.28
/// Description:保存报损明细
/// Table:CSSD_UllageDetail
/// d ##class(web.CSSDHUI.CallBack.Ullage).jsSaveItem("20","[{""ItemDesc"":""包布"",""Spec"":"""",""ItemId"":""25"",""ConsumeReasonName"":""正常使用消耗"",""ConsumeQty"":""3"",""ConsumeReasonDR"":""4""}]")
ClassMethod jsSaveItem(Parref As %String, Params As %String) As %Library.String
{
	n (%session,Parref,Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s RtnObj=..SaveItem(Parref,Params)
	q RtnObj.Json()
}

ClassMethod SaveItem(Parref As %String, Params As %String) As web.CSSDHUI.RtnObj
{
	n (%session,Parref,Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	
	s MainObj=##class(User.CSSDUllage).%OpenId(Parref)
	d MainObj.%Reload()
	q:'$IsObject(MainObj) RtnObj.Err(-1,"","主单已删除")
	
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s Rowid=Obj.%Get("RowId")
		s ItemId=Obj.%Get("ItemId")
		s ConsumeQty=Obj.%Get("ConsumeQty")
		s ConsumeReasonDR=Obj.%Get("ConsumeReasonDR")
		continue:ConsumeQty=""
		continue:ConsumeReasonDR=""
		s UllageDetailId=$o(^User.CSSDUllageDetailI("MainItemIndex",Parref,ItemId,""))
		i ((UllageDetailId'="")&&(UllageDetailId'=Rowid)) d RtnObj.Err(-6,"","器械明细已存在,请核对!") q
		continue:RtnObj.success'=0
		
		i UllageDetailId="" d
		.&sql(Insert into CSSD_UllageDetail(CSSDUD_MainDr,CSSDUD_Item,CSSDUD_Num,CSSDUD_ConsumeReason_DR) values(:Parref,:ItemId,:ConsumeQty,:ConsumeReasonDR))
		.i SQLCODE  d RtnObj.Err(-2,"",$ClassName()_"jsSaveItem:保存失败!") q
		e  d
		.&sql(update CSSD_UllageDetail set CSSDUD_Num=:ConsumeQty,CSSDUD_ConsumeReason_DR=:ConsumeReasonDR where CSSDUD_MainDr=:Parref AND CSSDUD_Item=:ItemId)
		.i SQLCODE d RtnObj.Err(-3,"",$ClassName()_"jsSaveItem:修改失败!") q
		continue:RtnObj.success'=0
	}
	i RtnObj.success<0 tro  q RtnObj
	tc
	q RtnObj
}

/// Creator:zn
/// CreatDate:2020.11.05
/// Description:删除报损单
/// Table:User.CSSDUllage, User.CSSDUllageDetail
/// d ##class(web.CSSDHUI.CallBack.Ullage).jsDelete(37)
ClassMethod jsDelete(Params) As %Library.String
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

ClassMethod Delete(mainRowId As %String) As web.CSSDHUI.RtnObj
{
	n (%session,mainRowId)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i mainRowId="" d RtnObj.Err(-1,"","入参不能为空!")
	q:RtnObj.success'=0 RtnObj
	s MainObj=##Class(User.CSSDUllage).%OpenId(mainRowId)
	i '$IsObject(MainObj) d RtnObj.Err(-2,"","主单据不存在!")
	q:RtnObj.success'=0 RtnObj
	d MainObj.%Reload()
	s Flag=MainObj.CSSDUComplateFlag
	i Flag'="N" d RtnObj.Err(-3,"","只有未提交单据可以删除")
	q:RtnObj.success'=0 RtnObj

	&sql(Delete from CSSD_UllageDetail where CSSDUD_MainDr=:mainRowId)
	i SQLCODE<0 d RtnObj.Err(-4,"","删除明细失败!")
	q:RtnObj.success'=0 RtnObj
	&sql(Delete From CSSD_Ullage where ID=:mainRowId)
	i SQLCODE<0 d RtnObj.Err(-5,"","删除主单据失败!")
	q:RtnObj.success'=0 RtnObj

	q RtnObj
}

/// Creator:zn
/// CreatDate:2020.07.28
/// Description:删除报损明细
/// Table:CSSD_UllageDetail
/// w ##Class(web.CSSDHUI.Clean.CleanInfo).jsDelete(^templxt("jsDelete"))
ClassMethod jsDeleteItem(Params) As %Library.String
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
		s RowId=Obj.%Get("RowId")
		continue:RowId=""
		s RtnObj=..DeleteItem(RowId)
		q:RtnObj.success'=0
	}
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

ClassMethod DeleteItem(RowId As %String) As %Library.String
{
	n (%session,RowId)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	&sql(Delete from CSSD_UllageDetail where ID=:RowId)
	i SQLCODE<0 d RtnObj.Err(-1,"",$ClassName()_".Delete:SQLCODE"_SQLCODE_":"_$g(%msg))
	i RtnObj.success'=0 q RtnObj
	q RtnObj
}

}
