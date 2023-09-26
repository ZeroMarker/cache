Import sqluser

/// Descript:请领科室禁止请领物资维护\供应科室物资禁止请领科室
/// Creater:	taosongrui
/// CreateDate:	2014-03-07
Class web.DHCSTMHUI.RefuseReqLoc Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	保存请领科室禁止请领物资
/// Creater:	taosongrui
/// CreateDate:	2014-03-07
/// Table:
/// Input:请领科室,物资id,供应科室,开始日期,截止日期,备注,RowId
/// Output:		
/// Return：
/// w ##class(web.DHCSTMHUI.RefuseReqLoc).Save()
ClassMethod Save(Params As %String) As %Library.String
{
  n (Params)
  ;s ^tmpliu33=Params
  s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s sc=PJObj.%FromJSON(Params)
	i sc'=0 d
	.s sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	s ret=0
	ts
	s $ZT=..sssError()
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s ReqLoc=Obj.%Get("ReqLocId")
		s IncId=Obj.%Get("IncRowid")
		s FrLoc=Obj.%Get("FroLocId")
		s StartDate=Obj.%Get("StartDate")
		s EndDate=Obj.%Get("EndDate")
		s Remark=Obj.%Get("Remark")
		s useflag=Obj.%Get("ChkUesFlag")
		s:StartDate'="" StartDate=..DH2L(StartDate)
 		s:EndDate'="" EndDate=..DH2L(EndDate)
		i RowId="" d
	    .s RtnObj=..Insert(ReqLoc,IncId,FrLoc,StartDate,EndDate,Remark,useflag)
		e  d
		.s RtnObj=..Update(ReqLoc,IncId,FrLoc,StartDate,EndDate,Remark,RowId,useflag)	
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// Descript:	更新请领科室禁止请领物资
/// Creater:	taosongrui
/// CreateDate:	2014-03-07
/// Table: 
/// Input: 
/// Output:		
/// Return：0:成功;非0：失败
/// w ##class(web.DHCSTMHUI.RefuseReqLoc).Update("4","533","153","2014-03-09","2014-06-10","83759","40") 
ClassMethod Update(ReqLoc As %String, IncId As %String, FrLoc As %String, StartDate As %String, EndDate As %String, Remark As %String, RowId As %String, useflag As %String) As %Library.String [ Private ]
{
	n (ReqLoc,IncId,FrLoc,StartDate,EndDate,Remark,RowId,useflag,%session)
	;s ^lh("dddd3")=$lb(ReqLoc,IncId,FrLoc,StartDate,EndDate,Remark,RowId,useflag,%session)
	s RtnObj=##class(RtnObj).%New()
	s rowid=""
  	f  s rowid=$o(^DHCRFUREQ(0,"FIT",FrLoc,IncId,ReqLoc,rowid))  q:rowid=""  d
  	.s ToLoc=$p(^DHCRFUREQ(rowid),"^",2)
  	.i (ToLoc=ReqLoc)&&(rowid'=RowId) d
	..s Sc=RtnObj.Err(-10,"","该物资的该请领科室已经维护！","",0)
	q:RtnObj.success'=0 RtnObj
 	s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_RefuseReqLocItm",RowId)
	&sql(Update DHC_RefuseReqLocItm set RFU_FrLoc_DR=:FrLoc,RFU_ToLoc_DR=:ReqLoc,RFU_INCI_DR=:IncId,
	 RFU_DateFrom=:StartDate,RFU_DateTo=:EndDate,RFU_Remark=:Remark,RFU_UseFlag=:useflag where RFU_RowId=:RowId)
	i SQLCODE'=0  d
 	.s sc=RtnObj.Err(-1,RowId,$ClassName()_".Update:SQLCODE"_SQLCODE_":"_$g(%msg))
 	e  d
 	.s RtnObj=##class(Log).SaveLog("DHC_RefuseReqLocItm","User.DHCRefuseReqLocItm","请领科室禁止请领物资信息",RowId,IncId,"U","",OldJsonStr)
 	q:RtnObj.success'=0 RtnObj
 	q RtnObj
}

/// Descript:	增加请领科室禁止请领物资
/// Creater:	taosongrui
/// CreateDate:	2014-03-07
/// Table: 
/// Input: 请领科室,物资id,供应科室,开始日期,截止日期,备注
/// Output:		
/// Return：rowid
/// w ##class(web.DHCSTMHUI.RefuseReqLoc).Insert("3","35","153","","","")
ClassMethod Insert(ReqLoc As %String, IncId As %String, FrLoc As %String, StartDate As %String, EndDate As %String, Remark As %String, useflag As %String) As %Library.String
{
	n (ReqLoc,IncId,FrLoc,StartDate,EndDate,Remark,useflag,%session)
	s RtnObj=##class(RtnObj).%New()
	s rowid=""
  	f  s rowid=$o(^DHCRFUREQ(0,"FIT",FrLoc,IncId,ReqLoc,rowid))  q:rowid=""  d
  	.s ToLoc=$p(^DHCRFUREQ(rowid),"^",2)
  	.i ToLoc=ReqLoc d
  	..s Sc=RtnObj.Err(-10,"","该物资的该请领科室已经维护！","",0)
  	q:RtnObj.success'=0 RtnObj
  	&sql(Insert into DHC_RefuseReqLocItm(RFU_FrLoc_DR,RFU_ToLoc_DR,RFU_INCI_DR,RFU_DateFrom,
  	RFU_DateTo,RFU_Remark,RFU_UseFlag)
 	values(:FrLoc,:ReqLoc,:IncId,:StartDate,:EndDate,:Remark,:useflag))
 	i SQLCODE'=0  d
 	.s Sc=RtnObj.Err(-11,"",$ClassName()_".Insert:SQLCODE"_SQLCODE_":"_$g(%msg))
 	e  d
    .s RtnObj=##class(Log).SaveLog("DHC_RefuseReqLocItm","User.DHCRefuseReqLocItm","请领科室禁止请领物资信息",$SYSTEM.SQL.GetROWID(),IncId,"A")
 	q:RtnObj.success'=0 RtnObj
 	q RtnObj
}

///  d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.RefuseReqLoc","Query","^tmpliu333")
Query Query(Params As %String) As websys.Query(ROWSPEC = "RowId,IncRowid,InciCode,InciDesc,FroLocDesc,FroLocId,ReqLocDesc,ReqLocId,StartDate,EndDate,Remark,ChkUesFlag") [ SqlProc ]
{
}

ClassMethod QueryExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	;s ^litmp("web.DHCSTMHUI.RefuseReqLoc")=Params
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s ReqLoc=PJobj.%Get("ToLoc")
	s IncId=PJobj.%Get("Inci")
	s StkGrpId=PJobj.%Get("StkGrpId")
	s FrLoc=PJobj.%Get("FrLoc")
	s pHospId=PJobj.%Get("Hospital")
	s gHospId=PJobj.%Get("gHospId")
	i pHospId="" s pHospId=gHospId
	s StkGrpId=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr("",..sssCode(),"",StkGrpId,pHospId)
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	s StrSql="SELECT RFU_RowId as Rowid,RFU_FrLoc_DR,RFU_ToLoc_DR,RFU_INCI_DR,RFU_DateFrom,RFU_DateTo,RFU_Remark,RFU_UseFlag FROM DHC_RefuseReqLocItm where 1=1"
	i ReqLoc'=""  d
	.s StrSql=StrSql_" and RFU_ToLoc_DR="_ReqLoc_""
	i FrLoc'=""  d
	.s StrSql=StrSql_" and RFU_FrLoc_DR="_FrLoc_""
	i IncId'=""  d
	.s StrSql=StrSql_" and RFU_INCI_DR="_IncId_""
	d Result.Prepare(StrSql)
	d Result.Execute()
	While(Result.Next())
	{	
		s RowId = Result.Data("Rowid") 
	   	CONTINUE:+RowId=0
	   	s IncRowid=Result.Data("RFU_INCI_DR")
	   	s InciCode=$p(^INCI(IncRowid,1),"^",1)
	   	s InciDesc=$p(^INCI(IncRowid,1),"^",2)
	   	i StkGrpId'="" d
	   	.s TmpGrpInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(IncRowid)
	    .s TmpGrpType=$p(TmpGrpInfo,"^",5)
		continue:(StkGrpId'="")&&(("^"_StkGrpId_"^")'[("^"_TmpGrpType_"^"))
	   	s FroLocId=Result.Data("RFU_FrLoc_DR")
	   	s:FroLocId'="" FroLocDesc=$p(^CTLOC(FroLocId),"^",2),FroLocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(FroLocDesc)
	   	s ReqLocId=Result.Data("RFU_ToLoc_DR")
	   	s:ReqLocId'="" ReqLocDesc=$p(^CTLOC(ReqLocId),"^",2),ReqLocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(ReqLocDesc)
	   	s FroLocHosp=..sssHospId(FroLocId)
	   	s ReqLocHosp=..sssHospId(ReqLocId)
	   	continue:(pHospId'=FroLocHosp)&&(pHospId'=ReqLocHosp)
	   	s StartDate=Result.Data("RFU_DateFrom")
	   	s EndDate=Result.Data("RFU_DateTo")
	   	s Remark=Result.Data("RFU_Remark")
	   	s ChkUesFlag=Result.Data("RFU_UseFlag")
	   	s:StartDate'="" StartDate=..DL2H(StartDate)
 		s:EndDate'="" EndDate=..DL2H(EndDate)
		d OutPutRow
 	}
 Quit $$$OK
OutPutRow
 s Data=$lb(RowId,IncRowid,InciCode,InciDesc,FroLocDesc,FroLocId,ReqLocDesc,ReqLocId,StartDate,EndDate,Remark,ChkUesFlag)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

/// Descript:	删除请领科室禁止请领物资\供应科室物资禁止请领科室
/// Creater:	taosongrui
/// CreateDate:	2014-03-07
/// Table: 
/// Input: 
/// Output:		
/// Return：0:成功;非0：失败
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
		s JsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_RefuseReqLocItm",RowId)
	 	&sql(Delete from DHC_RefuseReqLocItm  where RFU_RowId=:RowId)
	 	i SQLCODE'=0  d
		.s sc=RtnObj.Err(-2,RowId,$ClassName()_".Delete:SQLCODE"_SQLCODE_":"_$g(%msg))
		e  d
		.s RtnObj=##class(Log).SaveLog("DHC_RefuseReqLocItm","User.DHCRefuseReqLocItm","请领科室禁止请领物资信息",RowId,"","D",JsonStr)
		q:RtnObj.success'=0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

}
