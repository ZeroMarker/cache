Import sqluser

/// Descript:	科室采购人员维护
/// Creater:	tsr
/// CreateDate:	2018-04-27
Class web.DHCSTMHUI.LocPurPlanUser Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	安全组下科室
/// Creater:	tsr
/// CreateDate:	2018-04-27
/// Input:		安全组Id,安全组名
Query GetGroupLoc(Params As %String) As Query(ROWSPEC = "RowId,Code,Description") [ SqlProc ]
{
}

ClassMethod GetGroupLocExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s PGroupId=PJobj.%Get("GroupId")
	s PDescription=PJobj.%Get("Description")
	s gHospId=PJobj.%Get("gHospId")
	s pHospId=PJobj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	s SqlStr = "SELECT ST_CTLOC_DR AS RowId, ST_CTLOC_DR->CTLOC_Code AS Code, ST_CTLOC_DR->CTLOC_DESC AS Description FROM SS_GroupStockLocations"
	s SqlStr = SqlStr_" WHERE ST_ParRef="_PGroupId
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		continue:(##class(web.DHCSTMHUI.CTLOC).LocOfHosp(RowId,pHospId)'=0)
		s Active=""
		s LocRowId=$o(^DHCLOC(0,"LOC",RowId,""))
		s:LocRowId'="" Active=$p(^DHCLOC(LocRowId),"^",4)
		continue:Active="N"
		s Code = Result.Data("Code")
		s Description = Result.Data("Description")
		s ContactName = $p(^CTLOC(RowId),"^",43)
		s PDescription=$$ALPHAUP^SSUTIL4(PDescription)
		continue:(PDescription'="")&&(($$ALPHAUP^SSUTIL4(Description)'[PDescription)
			&&($$ALPHAUP^SSUTIL4(Code)'[PDescription)
			&&($$ALPHAUP^SSUTIL4(ContactName)'[PDescription))
		d OutPutGroupLocRow
 	}
	Quit $$$OK
OutPutGroupLocRow
	s Data=$lb(RowId,Code,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	安全组下科室对应的人员信息
/// Creater:	tsr
/// CreateDate:	2018-04-28
/// Table:		DHC_LocPurPlanUser
/// Input:		科室Id
ClassMethod SelectLocUser(LocId As %String) As %Library.String
{
	n (LocId)
	q:LocId="" ""
	s Count = 0
	s Json = ##class(web.DHCSTMHUI.Common.JsonObj).%New()
	s SqlStr="SELECT LPP_RowId as RowId, LPP_SSUSR_DR, LPP_SSUSR_DR->SSUSR_Initials as Code, LPP_SSUSR_DR->SSUSR_Name as UserDesc, LPP_Active, LPP_Default"
	s SqlStr=SqlStr_" FROM DHC_LocPurPlanUser WHERE LPP_CTLOC_DR="_LocId
	s Result=##class(%Library.ResultSet).%New()
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{	
		s RowId = Result.Data("RowId")
		s UserId = Result.Data("LPP_SSUSR_DR")
		s Code = Result.Data("Code")
		s UserDesc = Result.Data("UserDesc")
		s ActiveFlag = Result.Data("LPP_Active")
		s DefaultFlag = Result.Data("LPP_Default")
		s Tmp=RowId_"^"_UserId_"^"_Code_"^"_UserDesc_"^"_ActiveFlag_"^"_DefaultFlag
		s Count = Count+1
		d Json.InsertRowData(Tmp)
 	}
	d Json.getJsonData("RowId^UserId^Code^UserDesc^ActiveFlag^DefaultFlag",Count)
	k Json
	q ""
}

/// Descript:	保存/更新采购人员
/// Creater:	tsr
/// CreateDate:	2018-05-03
/// Table:		DHC_LocPurPlanUser
/// Input:		科室Id,{UserId,}
ClassMethod Save(LocId As %String, Params As %String) As %Library.String
{
	n (LocId,Params,%session)
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s sc=PJObj.%FromJSON(Params)
	i sc'=0 d
	.s sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	ts
	s $ZT=..sssError()
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s UserId=Obj.%Get("UserId")
		i UserId="" d RtnObj.Err(-3,RowId,"请选择采购员,必填项不能为空!","",0)
		q:RtnObj.success'=0
		s DefaultFlag=Obj.%Get("DefaultFlag")
		s ActiveFlag=Obj.%Get("ActiveFlag")
		s LPPId=$o(^DHCLOCPPUSER(0,"LOCUSER",LocId,UserId,0))
		i ((LPPId'="")&&(LPPId'=RowId)) d
		.s UserName=$p(^SSU("SSUSR",UserId),"^",2)
		.d RtnObj.Err(-2,RowId,UserName_"已维护,请重新选择采购员!","",0)
		q:RtnObj.success'=0
		i RowId="" d
		.s RtnObj=..Insert(LocId,UserId,DefaultFlag,ActiveFlag)
		e  d
		.s RtnObj=..Update(RowId,UserId,DefaultFlag,ActiveFlag)
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// Descript:	增加采购人员
/// Creater:	tsr
/// CreateDate:	2018-05-03
/// Table:		DHC_LocPurPlanUser
ClassMethod Insert(LocId As %String, UserId As %String, DefaultFlag As %String, ActiveFlag As %String) As RtnObj [ Private ]
{
	n (LocId,UserId,DefaultFlag,ActiveFlag,%session)
	s RtnObj=##class(RtnObj).%New()
 	s UserName=$p(^SSU("SSUSR",UserId),"^",2)
	q:RtnObj.success'=0 RtnObj
 	i (LocId="")||(UserId="") d
 	.s Sc=RtnObj.Err(-21,"","必填项不能为空!","",0)
 	q:RtnObj.success'=0 RtnObj
 	&sql(Insert into DHC_LocPurPlanUser
 		(LPP_CTLOC_DR,LPP_SSUSR_DR,LPP_Active,LPP_Default)
 		 values
 		 (:LocId,:UserId,:ActiveFlag,:DefaultFlag))
 	i SQLCODE'=0  d
 	.s Sc=RtnObj.Err(-11,"",$ClassName()_".Insert:SQLCODE"_SQLCODE_":"_$g(%msg))
 	e  d
    .s RtnObj=##class(Log).SaveLog("DHC_LocPurPlanUser","User.DHCLocPurPlanUser","采购人员信息",$SYSTEM.SQL.GetROWID(),UserName,"A")
 	q:RtnObj.success'=0 RtnObj
 	q RtnObj
}

/// Descript:	更新采购人员
/// Creater:	tsr
/// CreateDate:	2018-05-03
/// Table:		DHC_LocPurPlanUser
ClassMethod Update(RowId As %String, UserId As %String, DefaultFlag As %String, ActiveFlag As %String) As RtnObj [ Private ]
{
	n (RowId,UserId,DefaultFlag,ActiveFlag,%session)
	s RtnObj=##class(RtnObj).%New()
 	s UserName=$p(^SSU("SSUSR",UserId),"^",2)
 	s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_LocPurPlanUser",RowId)
 	&sql(Update DHC_LocPurPlanUser set 
 		LPP_SSUSR_DR=:UserId,LPP_Default=:DefaultFlag,LPP_Active=:ActiveFlag
 		where LPP_RowId=:RowId)
 	i SQLCODE'=0  d
 	.s sc=RtnObj.Err(-1,RowId,$ClassName()_".Update:SQLCODE"_SQLCODE_":"_$g(%msg))
 	e  d
 	.s RtnObj=##class(Log).SaveLog("DHC_LocPurPlanUser","User.DHCLocPurPlanUser","采购人员信息",RowId,UserName,"U","",OldJsonStr)
 	q:RtnObj.success'=0 RtnObj
 	q RtnObj
}

/// Descript:	删除采购人员
/// Creater:	tsr
/// CreateDate:	2018-05-03
/// Table:		DHC_LocPurPlanUser
ClassMethod Delete(Params As %String) As %Library.String
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
		q:RowId=""
		s UserId=Obj.%Get("UserId")
		s UserName=$p(^SSU("SSUSR",UserId),"^",2)
		s JsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_LocPurPlanUser",RowId)
		&sql(Delete from DHC_LocPurPlanUser where LPP_RowId=:RowId)
		i SQLCODE'=0  d
		.s sc=RtnObj.Err(-2,RowId,$ClassName()_".Delete:SQLCODE"_SQLCODE_":"_$g(%msg))
		e  d
		.s RtnObj=##class(Log).SaveLog("DHC_LocPurPlanUser","User.DHCLocPurPlanUser","采购人员信息",RowId,UserName,"D",JsonStr)
		q:RtnObj.success'=0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

}
