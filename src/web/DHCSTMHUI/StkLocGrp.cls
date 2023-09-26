Import sqluser

/// Descript:	科室组相关
/// Creator:	ZhangDongmei
/// CreateDate:	2018-04-05
Class web.DHCSTMHUI.StkLocGrp Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

Parameter AppTable [ Final ] = "DHC_StkLocGroup";

/// Descript:	保存/更新科室组信息
/// Creator:	wanajiabin
/// CreateDate:	2018-04-05
/// Table:		DHC_StkLocGroup
/// Input:		params: [{RowId:**,Code:**,Description:**,Type:**},{...},...]
/// Output:		RtnObj信息串
/// w ##class(web.DHCSTMHUI.StkLocGrp).Save("[{""RowId"":""6"",""Code"":""1"",""Description"":""cl测试科室"",""Type"":""M""}]")
ClassMethod Save(Params As %String, Main As %String) As %Library.String
{
	n (Params,Main,%session)
	s $ZT=..sssError()
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	
	s MainPJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	q:MainPJObj.%FromJSON(Main)'=0 RtnObj.Err(-1,"","入参解析失败!").Json()
	s gHospId=MainPJObj.%Get("gHospId")
	s pHospId=MainPJObj.%Get("BDPHospital")
	s gHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	
	s Type=..sssCode()
	ts
	while(RtnObj.success=0){
		s objStr=PJObj.%Pop()
		q:objStr=""
		s RowId=objStr.%Get("RowId")
		s Code=objStr.%Get("Code")
		s Description=objStr.%Get("Description")
		s ret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("CODE",Code,..#AppTable,gHospId,RowId)
		i ret>0 d RtnObj.Err(-2,RowId,Code_" 代码重复!","",0)
		continue:RtnObj.success<0
		s ret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("DESC",Description,..#AppTable,gHospId,RowId)
		i ret>0 d RtnObj.Err(-2,RowId,Description_" 名称重复!","",0)
		continue:RtnObj.success<0
		
		i RowId'=""  d
		.s RtnObj=..Update(RowId,Code,Description,Type)
		e  d
		.s RtnObj=..Insert(Code,Description,Type,gHospId)
		continue:RtnObj.success'=0
	}
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Descript:	增加科室组信息
/// Creator:	wangjiabin
/// CreateDate:	2018-04-08
/// Input:		代码,描述,类型
/// Output:		RtnObj
ClassMethod Insert(code As %String, desc As %String, type As %String, gHospId As %String) As RtnObj [ Private ]
{
	n (code,desc,type,gHospId,%session)
	s RtnObj=##class(RtnObj).%New()
	i (code="")||(desc="") q RtnObj.Err(-1,"","必填项不可为空","",0)
	
	&sql(Insert into DHC_StkLocGroup
		(SLG_Code,SLG_Desc,SLG_Type)
		values
		(:code,:desc,:type)
	)
	i SQLCODE'=0 d
	.s JsonStr=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(code_"^"_desc,"Code^Description")
	.d RtnObj.Err(-1,"",$ClassName()_".Insert:SQLCODE"_SQLCODE_":"_$g(%msg),JsonStr)
	q:RtnObj.success'=0 RtnObj
	
	s RowId=$p(%ROWID,$c(1))
	//保存医院关联
	s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP(..#AppTable,RowId,gHospId)
	i ret<0 d RtnObj.Err(-11,"","关联医院失败"_ret)
	q:RtnObj.success<0 RtnObj
	s RtnObj=##class(web.DHCSTMHUI.Log).SaveLog("DHC_StkLocGroup","User.DHCStkLocGroup","科室组信息",RowId,desc,"A")
	q:RtnObj.success<0 RtnObj
	s RtnObj.rowid=RowId
	q RtnObj
}

/// Descript:	更新科室组信息
/// Creator:	wangjaibin
/// CreateDate:	2018-04-08
/// Input:		rowid,代码,描述,类型
/// Output:		RtnObj
ClassMethod Update(rowid As %String, code As %String, desc As %String, type As %String) As RtnObj [ Private ]
{
	n (rowid,code,desc,type,%session)
	s RtnObj=##class(RtnObj).%New()
	i (code="")||(desc="")||(rowid="") d
	.s RtnObj.success=-1
	.s RtnObj.msg="必填项不可为空"
	q:RtnObj.success'=0 RtnObj

	s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_StkLocGroup",rowid)
	&sql(Update DHC_StkLocGroup
		set SLG_Code=:code,SLG_Desc=:desc,SLG_Type=:type
		where SLG_Rowid=:rowid
	)
	i SQLCODE'=0  d
	.d RtnObj.Err(-3,rowid,$ClassName()_".Update:SQLCODE"_SQLCODE_":"_$g(%msg),OldJsonStr)
	q:RtnObj.success'=0 RtnObj

	s RtnObj=##class(Log).SaveLog("DHC_StkLocGroup","User.DHCStkLocGroup","科室组信息",rowid,desc,"U","",OldJsonStr)
	q RtnObj
}

/// Descript:	删除信息
/// CreateDate:	2012-05-22
/// Input:		rowid
/// Output:		
/// Return:		0 – 成功，非0 ：失败,
/// w ##class(web.DHCSTMHUI.StkLocGrp).Delete("")
ClassMethod Delete(rowid As %String) As %Library.String
{
	n (rowid,%session)
	s RtnObj=##class(RtnObj).%New()
	i rowid="" q RtnObj.Err(-1,rowid,"必填项不可为空","",0).Json()

	s JsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_StkLocGroup",rowid)
	&sql(Delete from DHC_StkLocGroup where SLG_Rowid=:rowid)
	i SQLCODE'=0  d
	.d RtnObj.Err(-2,rowid,"删除失败:"_$ClassName()_".Delete:SQLCODE"_SQLCODE_":"_$g(%msg),JsonStr)
	q:RtnObj.success'=0 RtnObj.Json()

	d ##class(Log).SaveLog("DHC_StkLocGroup","User.DHCStkLocGroup","科室组信息",rowid,"","D",JsonStr)
	q RtnObj.Json()
}

/// Description:获取科室组信息
/// CreateDate:	2018-04-04
/// Creator:	wangjiabin
/// Input:		sort,order,params:{Code:**,Deccription:**}
/// OutPut:		
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.StkLocGrp","Query","")
Query Query(Params As %String) As Query(ROWSPEC = "RowId,Code,Description,Type") [ SqlProc ]
{
}

ClassMethod QueryExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)

	s Code=PJobj.%Get("Code")
	s Description=PJobj.%Get("Description")
	s gHospId=PJobj.%Get("gHospId")
	s pHospId=PJobj.%Get("BDPHospital")
	s gHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)

	s Code=$$ALPHAUP^SSUTIL4(Code)
	s Description=$$ALPHAUP^SSUTIL4(Description)

	s Type=..sssCode()
	s StrSql="select SLG_RowId as RowId,SLG_Code as Code,SLG_Desc as Description,SLG_Type as Type"
		_" from DHC_StkLocGroup where %ALPHAUP(SLG_Desc) like ? and %ALPHAUP(SLG_Code) like ?"
		_" and SLG_Type=?"
	s result = ##class(%Library.ResultSet).%New()
	d result.Prepare(StrSql)
	s sc=result.Execute("%"_Description_"%","%"_Code_"%",Type)
	s err=$$$ISERR(sc)
	If err q $$$OK
	While(result.Next()) {
		s RowId = result.Data("RowId")
		//判断医院权限
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag(..#AppTable,RowId,gHospId)
		continue:ShowDataFlag="N"
		s Code = result.Data("Code")
		s Description = result.Data("Description")
		s Type = result.Data("Type")
		d OutPutRow
	}
	d result.Close()
	q $$$OK

OutPutRow
	s Data=$lb(RowId,Code,Description,Type)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod SavePtMod(Params As %String) As %Library.String
{
	n (Params,%session)
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
		s LocId=Obj.%Get("LocId")
		s StkGrpId=Obj.%Get("StkGrpId")
		s PtModID=Obj.%Get("PtModID")
		i RowId'="" d
		.s RtnObj=..UpdatePtMod(RowId,LocId,StkGrpId,PtModID)
		e  d
		.s RtnObj=..InsertPtMod(LocId,StkGrpId,PtModID)
		q:RtnObj.success'=0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

ClassMethod InsertPtMod(LocId As %String, StkGrpId As %String, PtModID As %String) As %Library.String
{
	n (LocId,StkGrpId,PtModID,%session)
	s RtnObj=##class(RtnObj).%New()
	s RowId=""
	&sql(select PRT_RowId into :RowId from DHC_StkLocBillPrintMode where PRT_CTLOC_DR=:LocId and PRT_SCG_DR=:StkGrpId)
	i +RowId>0 d
	.s sc=RtnObj.Err(-1,"","存在重复记录","",0)
	q:RtnObj.success'=0 RtnObj
	&sql(insert into DHC_StkLocBillPrintMode (PRT_CTLOC_DR,PRT_SCG_DR,PRT_PrtMode) values (:LocId,:StkGrpId,:PtModID))
	i SQLCODE'=0  d
	.s sc=RtnObj.Err(-1,"",$ClassName()_".Insert:SQLCODE"_SQLCODE_":"_$g(%msg))
	e  d
	.s RtnObj=##class(Log).SaveLog("DHC_StkLocBillPrintMode","User.DHCStkLocBillPrintMode","科室类组打印设置",$SYSTEM.SQL.GetROWID(),LocId,"A")
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

ClassMethod UpdatePtMod(RowId As %String, LocId As %String, StkGrpId As %String, PtModID As %String) As %Library.String
{
	n (RowId,LocId,StkGrpId,PtModID,%session)
	s RtnObj=##class(RtnObj).%New()
	s rid=""
	&sql(select PRT_RowId into :rid from DHC_StkLocBillPrintMode where PRT_CTLOC_DR=:LocId and PRT_SCG_DR=:StkGrpId and PRT_PrtMode=:PtModID)
	i +rid>0 d
	.s Sc=RtnObj.Err(-3,"","存在重复记录","",0)
	q:RtnObj.success'=0 RtnObj
	s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_StkLocBillPrintMode",RowId)
	&sql(update DHC_StkLocBillPrintMode set PRT_CTLOC_DR=:LocId,PRT_SCG_DR=:StkGrpId,PRT_PrtMode=:PtModID where PRT_RowId=:RowId)
	i SQLCODE'=0  d
	.s Sc=RtnObj.Err(-1,RowId,$ClassName()_".Update:SQLCODE"_SQLCODE_":"_$g(%msg))
	e  d
	.s RtnObj=##class(Log).SaveLog("DHC_StkLocBillPrintMode","User.DHCStkLocBillPrintMode","科室类组打印设置",RowId,LocId,"U","",OldJsonStr)
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.StkLocGrp","QueryPtMod","")
Query QueryPtMod(Params As %String) As websys.Query(ROWSPEC = "RowId,LocId,LocDesc,StkGrpId,StkGrpDesc,PtModID") [ SqlProc ]
{
}

ClassMethod QueryPtModExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)	
	s LocId=PJobj.%Get("PhaLoc")
	s gHospId=PJobj.%Get("gHospId")
	s pHospId=PJobj.%Get("BDPHospital")
	s gHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	s StrSql="select * from DHC_StkLocBillPrintMode"
	i LocId'="" d
	.s StrSql="select * from DHC_StkLocBillPrintMode where PRT_CTLOC_DR="_LocId
	d Result.Prepare(StrSql)
	d Result.Execute()	
	while(Result.Next())
	{
		s RowId = Result.Data("PRT_RowId")
		s LocId = Result.Data("PRT_CTLOC_DR")
		s ret=##class(web.DHCSTMHUI.CTLOC).LocOfHosp(LocId, gHospId)
		continue:(ret'=0)
		s LocDesc=""
		i LocId'="" s LocDesc=$p($g(^CTLOC(LocId)),"^",2)
		s StkGrpId = Result.Data("PRT_SCG_DR")
		s StkGrpDesc=$s(StkGrpId'="":$p(^DHCSCG(StkGrpId),"^",2),1:"")
		s PtModID = Result.Data("PRT_PrtMode")
		d PtModOutPutRow
	}
	Quit $$$OK
PtModOutPutRow
	s Data=$lb(RowId,LocId,LocDesc,StkGrpId,StkGrpDesc,PtModID)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod DeletePtMod(Params As %String) As %Library.String
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
		s LocId=Obj.%Get("LocId")
		s Loc=$p($g(^CTLOC(LocId)),"^",2)
		s JsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_StkLocBillPrintMode",RowId)
		&sql(DELETE from DHC_StkLocBillPrintMode WHERE PRT_RowId=:RowId)
		i SQLCODE'=0  d
		.s sc=RtnObj.Err(-2,RowId,$ClassName()_".Delete:SQLCODE"_SQLCODE_":"_$g(%msg))
		e  d
		.s RtnObj=##class(Log).SaveLog("DHC_StkLocBillPrintMode","User.DHCStkLocBillPrintMode","科室类组打印设置",RowId,Loc,"D",JsonStr)
		q:RtnObj.success'=0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

ClassMethod GetModByLocScg(Loc As %String, Scg As %String) As %String
{
	
	s PtMod=""
	q:Loc="" "MM"
	&sql(select DHCLoc_BillPrtMode into :PtMod from DHCST_CtLoc where DHCLoc_Ctloc_dr=:Loc)
	i Scg="" d
	.i PtMod="" d
	..s PtMod="MM"
	e  d
	.s PtMode=""
	.&sql(select PRT_PrtMode into :PtMode from DHC_StkLocBillPrintMode where PRT_CTLOC_DR=:Loc and PRT_SCG_DR=:Scg)
	.i PtMode'="" d
	..s PtMod=PtMode
	.e  d
	..s:PtMod="" PtMod="MM"
	q PtMod
}

}
