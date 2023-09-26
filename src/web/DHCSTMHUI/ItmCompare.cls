Import sqluser

Class web.DHCSTMHUI.ItmCompare Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	查询物资对照信息
/// Creater:	zlk
/// CreateDate:	2018-12-4
/// Table:		DHC_HVMat_ItmCheckList
/// Input:		
/// Return：	物资对照信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.ItmCompare","SelectAll","RowId","Desc","{""FStkGrpBox"":""2"",""gUserId"":""6462"",""gLocId"":""392"",""gGroupId"":""276"",""gHospId"":""2"",""FInciDesc"":"""",""FICHisItmCode"":""""}")
Query SelectAll(Params As %String) As websys.Query(ROWSPEC = "rowId,Code,Description,HISCode,HISDesc,spec") [ SqlProc ]
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
	s PDescription=PJobj.%Get("FInciDesc")
	s PFICHisItmCode=PJobj.%Get("FICHisItmCode")
	s PFStkGrpBox=PJobj.%Get("FStkGrpBox")
	
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	s sqlStr = "SELECT IC_RowId as rowId,IC_INCItmCode as Code,IC_INCItmDesc as Description,IC_HISItmCode as HISCode,IC_HISItmDesc as HISDesc,IC_INCI_DR as inci"
		_" FROM DHC_HVMat_ItmCheckList "	
	d Result.Prepare(sqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s rowId = Result.Data("rowId")
		s Description = Result.Data("Description")
		s Code = Result.Data("Code")
		s HISCode = Result.Data("HISCode")
		s HISDesc = Result.Data("HISDesc")
		s inci = Result.Data("inci")
		s spec =##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec(Code,inci)
		s stkcat=""
        s stkcat=$p(^INCI(inci,2),"^",2)
        s stktmp=""
        s:stkcat'="" stktmp=$o(^DHCSCG("STKCAT",stkcat,0))
        CONTINUE:(PFStkGrpBox'="")&(stktmp'=PFStkGrpBox)
        CONTINUE:(PDescription'="")&(Description'[PDescription)
        CONTINUE:(PFICHisItmCode'="")&(HISCode'[PFICHisItmCode)
        
		
		d OutPutRow
 	}
	Quit $$$OK
OutPutRow
	s Data=$lb(rowId,Code,Description,HISCode,HISDesc,spec)   
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	保存/更新物资对照信息
/// Creater:	zlk
/// CreateDate:	2018-12-4
/// Table:		DHC_HVMat_ItmCheckList
/// Input:		
/// Return：	RtnObj Json
/// d ##class(web.DHCSTMHUI.ItmCompare).Save("[{""RowId"":""4466"",""Code"":""ZW纸卡类001"",""Description""   :""zzzz"",""Spec"":""aaa"",""HISCode"":""1"",""HISDesc"":""1""}]")
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
		s rowId=Obj.%Get("rowId")
		s HISCode=Obj.%Get("HISCode")
		s HISDesc=Obj.%Get("HISDesc")
		s Description=Obj.%Get("Description")
		s Code=Obj.%Get("Code")
		s inci=$o(^INCI(0,"Desc",$$ALPHAUP^SSUTIL4(Description),""))
	 	i (HISCode="")||(HISDesc="")||(Description="") s Sc=RtnObj.Err(-2,"","必填项不能为空!","",0)
 		q:RtnObj.success'=0
		s TmpId=$o(^DHCHVMIL(0,"HISITMCODE",$$ALPHAUP^SSUTIL4(HISCode),""))
		i (TmpId'="")&&(TmpId'=rowId) s Sc=RtnObj.Err(-3,"",Description_"代码重复!","",0)
		q:RtnObj.success'=0
		s TmpId=$o(^DHCHVMIL(0,"INCITM",inci,""))
		i (TmpId'="")&&(TmpId'=rowId) s Sc=RtnObj.Err(-4,"",Description_"名称重复","",0)
		q:RtnObj.success'=0
		i rowId'=""  d
		.s RtnObj=..Update(rowId,inci,Description,HISCode,HISDesc,Code)
		e  d
		.s RtnObj=..Insert(inci,Description,HISCode,HISDesc,Code)
		q:RtnObj.success'=0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// Descript:	更新物资对照信息
/// Creater:	zlk
/// CreateDate:	2018-12-04
/// Table:		DHC_HVMat_ItmCheckList
/// Input:		
/// Return：	RtnObj
/// d ##class(web.DHCSTMHUI.ItmCompare).Update("6","消化内科门诊","3","111","221")
ClassMethod Update(rowId As %String, inci As %String, Description As %String, HISCode As %String, HISDesc As %String, Code As %String) As RtnObj
{
	n (rowId,inci,Description,HISCode,HISDesc,Code,%session)
	s RtnObj=##class(RtnObj).%New()
	s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_HVMat_ItmCheckList",rowId)
	&sql(Update DHC_HVMat_ItmCheckList set 
		IC_HISItmCode=:HISCode,IC_HISItmDesc=:HISDesc,IC_INCItmCode=:Code,IC_INCItmDesc=:Description,IC_INCI_DR=:inci
		where IC_RowId=:rowId)
	i SQLCODE'=0  d
	.s sc=RtnObj.Err(-1,rowId,$ClassName()_".Update:SQLCODE"_SQLCODE_":"_$g(%msg))
	e  d
	.s RtnObj=##class(Log).SaveLog("DHC_HVMat_ItmCheckList","User.DHCHVMatItmCheckList","物资对照信息",rowId,Description,"U","",OldJsonStr)
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// Descript:	增加物资对照信息
/// Creater:	zlk
/// CreateDate:	2018-12-04
/// Table:		DHC_HVMat_ItmCheckList
/// Input:		
/// Return：	RtnObj
/// d ##class(web.DHCSTMHUI.ItmCompare).Insert("6","消化内科门诊","3","111","221")
ClassMethod Insert(inci As %String, Description As %String, HISCode As %String, HISDesc As %String, Code As %String) As RtnObj [ Private ]
{
	n (inci,Description,HISCode,HISDesc,Code,%session)
	s RtnObj=##class(RtnObj).%New()
	q:RtnObj.success'=0 RtnObj
	s HospId=$Get(%session.Data("LOGON.HOSPID"))
	&sql(Insert into DHC_HVMat_ItmCheckList(IC_HISItmCode,IC_HISItmDesc,IC_INCItmCode,IC_INCItmDesc,IC_INCI_DR,IC_HospComp_DR)
	values(:HISCode,:HISDesc,:Code,:Description,:inci,:HospId))
	i SQLCODE'=0  d
	.s Sc=RtnObj.Err(-11,"",$ClassName()_".Insert:SQLCODE"_SQLCODE_":"_$g(%msg))
	e  d
	.s RtnObj=##class(Log).SaveLog("DHC_HVMat_ItmCheckList","User.DHCHVMatItmCheckList","物资对照信息",$SYSTEM.SQL.GetROWID(),Description,"A")
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// Descript:	删除物资对照信息
/// Creater:	zlk
/// CreateDate:	2018-12-04
/// Table: DHC_HVMat_ItmCheckList
/// Input:		
/// Return：	RtnObj
/// d ##class(web.DHCSTMHUI.ItmCompare).Delete()
ClassMethod Delete(Params As %String) As %Library.String
{
	n (Params,%session)
	;s ^zlk("Delete1")=$lb(Params)
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
		s rowId=Obj.%Get("rowId")
		q:rowId=""
		s Description=Obj.%Get("Description")
		s JsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_HVMat_ItmCheckList",rowId)
		&sql(Delete from DHC_HVMat_ItmCheckList where IC_RowId=:rowId)
		i SQLCODE'=0  d
		.s sc=RtnObj.Err(-2,RowId,$ClassName()_".Delete:SQLCODE"_SQLCODE_":"_$g(%msg))
		e  d
		.s RtnObj=##class(Log).SaveLog("DHC_HVMat_ItmCheckList","User.DHCHVMatItmCheckList","物资对照信息",rowId,Description,"D",JsonStr)
		q:RtnObj.success'=0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

}
