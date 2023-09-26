Import sqluser

Class web.DHCSTMHUI.DepartmentCompare Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	查询科室对照信息
/// Creater:	zlk
/// CreateDate:	2018-11-21
/// Table:		DHC_HVMat_LocCheckList
/// Input:		
/// Return：	科室对照信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DepartmentCompare","SelectAll","{""Description"":"""",""gUserId"":""6462"",""gLocId"":""392"",""gGroupId"":""276"",""gHospId"":""2""}")
Query SelectAll(Params As %String) As Query(ROWSPEC = "RowId,LocDesc,LocId,HISCode,HISDesc") [ SqlProc ]
{
}

ClassMethod SelectAllExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	 
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s PDescription=PJobj.%Get("Description")
	s PDescription=$$ALPHAUP^SSUTIL4(PDescription)
	
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	s sqlStr = "SELECT LC_RowId as RowId,LC_HISLocCode as HISCode,LC_HISLocDesc as HISDesc,LC_CTLOC_DR as LocId, LC_CTLOC_DR->CTLoc_Desc as LocDesc"
		_" FROM DHC_HVMat_LocCheckList"
	d Result.Prepare(sqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s LocDesc = Result.Data("LocDesc")
		continue:(PDescription'="")&&($$ALPHAUP^SSUTIL4(LocDesc)'[PDescription)
		s LocId = Result.Data("LocId")
		s HISCode = Result.Data("HISCode")
		s HISDesc = Result.Data("HISDesc")
		
		d OutPutRow
	}
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,LocDesc,LocId,HISCode,HISDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	保存/更新科室对照信息
/// Creater:	zlk
/// CreateDate:	2018-11-21
/// Table:		DHC_HVMat_LocCheckList,CT_Loc
/// Input:		
/// Return：	RtnObj Json
/// d ##class(web.DHCSTMHUI.DepartmentCompare).Save("[{""Description"":""男科门诊"",""HISCode"":""22"",""HISDesc"":    ""33""}]")
ClassMethod Save(Params) As %Library.String
{
	n (Params,%session)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	ts
	s $ZT=..sssError()
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s HISCode=Obj.%Get("HISCode")
		s HISDesc=Obj.%Get("HISDesc")
		s LocId=Obj.%Get("LocId")
		s LocDesc=Obj.%Get("LocDesc")
		i LocId="" d RtnObj.Err(-2,"","本系统科室不能为空!","",0) q
		s TmpId=$o(^DHCHVMLL(0,"CTLOC",LocId,""))
		i (TmpId'="")&&(TmpId'=RowId) d RtnObj.Err(-4,"",LocDesc_"本系统科室重复","",0) q
		
		i HISCode="" d RtnObj.Err(-2,"","第三方系统代码不能为空!","",0) q
		s TmpId=$o(^DHCHVMLL(0,"HISLOCCODE",HISCode,""))
		i (TmpId'="")&&(TmpId'=RowId) d RtnObj.Err(-3,"",HISCode_"第三方系统代码重复!","",0) q
		
		i RowId'=""  d
		.s RtnObj=..Update(RowId,LocId,HISCode,HISDesc)
		e  d
		.s RtnObj=..Insert(LocId,HISCode,HISDesc)
		q:RtnObj.success'=0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// Descript:	更新科室对照信息
/// Creater:	zlk
/// CreateDate:	2018-11-21
/// Table:		DHC_HVMat_LocCheckList,CT_Loc
/// Input:		
/// Return：	RtnObj
/// d ##class(web.DHCSTMHUI.DepartmentCompare).Update("6","消化内科门诊","3","111","221")
ClassMethod Update(RowId As %String, LocId As %String, HISCode As %String, HISDesc As %String) As RtnObj
{
	n (%session,RowId,LocId,HISCode,HISDesc)
	s RtnObj=##class(RtnObj).%New()
	s LocCode=$p(^CTLOC(LocId),"^",1)
	s LocDesc=$p(^CTLOC(LocId),"^",2)
	
	s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_HVMat_LocCheckList",RowId)
	&sql(Update DHC_HVMat_LocCheckList
		set LC_HISLocCode=:HISCode,LC_HISLocDesc=:HISDesc,LC_CTLocCode=:LocCode,LC_CTLocDesc=:LocDesc,LC_CTLOC_DR=:LocId
		where LC_RowId=:RowId)
	i SQLCODE'=0 q RtnObj.Err(-22,"",$ClassName()_".Update,SQLCODE:"_SQLCODE_":"_$g(%msg))
	
	s RtnObj=##class(Log).SaveLog("DHC_HVMat_LocCheckList","User.DHCHVMatLocCheckList","科室对照信息",RowId,LocDesc,"U","",OldJsonStr)
	
	q RtnObj
}

/// Descript:	增加科室对照信息
/// Creater:	zlk
/// CreateDate:	2018-11-22
/// Table:		DHC_HVMat_LocCheckList,CT_Loc
/// Input:		
/// Return：	RtnObj
/// d ##class(web.DHCSTMHUI.DepartmentCompare).Insert("6","消化内科门诊","3","111","221")
ClassMethod Insert(LocId As %String, HISCode As %String, HISDesc As %String) As RtnObj [ Private ]
{
	n (%session,LocId,HISCode,HISDesc)
	s RtnObj=##class(RtnObj).%New()
	s LocCode=$p(^CTLOC(LocId),"^",1)
	s LocDesc=$p(^CTLOC(LocId),"^",2)
	&sql(Insert into DHC_HVMat_LocCheckList
		(LC_HISLocCode,LC_HISLocDesc,LC_CTLocCode,LC_CTLocDesc,LC_CTLOC_DR)
		values
		(:HISCode,:HISDesc,:LocCode,:LocDesc,:LocId)
	)
	i SQLCODE'=0 q RtnObj.Err(-32,"",$ClassName()_".Insert,SQLCODE:"_SQLCODE_":"_$g(%msg))
	s RowId=$SYSTEM.SQL.GetROWID()
	
	s RtnObj=##class(Log).SaveLog("DHC_HVMat_LocCheckList","User.DHCHVMatLocCheckList","科室对照信息",RowId,LocDesc,"A")
	
	q RtnObj
}

/// Descript:	删除科室对照信息
/// Creater:	zlk
/// CreateDate:	2018-11-22
/// Table: DHC_HVMat_LocCheckList
/// Input:		
/// Return：	RtnObj
/// d ##class(web.DHCSTMHUI.DepartmentCompare).Delete("[{""RowId"":""5"",""Description"":""胃肠外科门诊"",""LocId"":""14"",""HISCode"":""2"",""HISDesc"":""1""}]")
ClassMethod Delete(Params As %String) As %Library.String
{
	n (Params,%session)
	s RtnObj=##class(RtnObj).%New(Params)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	ts
	s $ZT=..sssError()
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		q:RowId=""
		s Description=Obj.%Get("Description")
		s JsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_HVMat_LocCheckList",RowId)
		&sql(Delete from DHC_HVMat_LocCheckList where LC_RowId=:RowId)
		i SQLCODE'=0  d
		.s sc=RtnObj.Err(-2,RowId,$ClassName()_".Delete:SQLCODE"_SQLCODE_":"_$g(%msg))
		e  d
		.s RtnObj=##class(Log).SaveLog("DHC_HVMat_LocCheckList","User.DHCHVMatLocCheckList","科室对照信息",RowId,Description,"D",JsonStr)
		q:RtnObj.success'=0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

}
