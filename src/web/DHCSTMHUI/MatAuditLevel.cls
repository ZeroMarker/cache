Import sqluser

/// Descript: 业务多级审核维护
/// Creater:	lihui
/// CreateDate:	20190304
Class web.DHCSTMHUI.MatAuditLevel Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// creator: lihui
/// date: 20190304
/// description: 查询多级审核维护信息
/// Table: DHC_MatAuditLevel
/// input:  
/// output:
/// others:
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.MatAuditLevel","QueryMatAuditLevel",)
Query QueryMatAuditLevel(Params As %String) As Query(ROWSPEC = "RowId,Type,Level,ActiveFlag,SSGroupId,SSGroupDesc,LocId,LocDesc,SSUserId,SSUserDesc,ScgId,ScgDesc") [ SqlProc ]
{
}

ClassMethod QueryMatAuditLevelExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	;s ^tmpli("QueryMatAuditLevel")=Params
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s gHospId=PJobj.%Get("gHospId")
	s HospId=PJobj.%Get("Hospital")
	s HospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(HospId,gHospId)
	s sqlStr = "SELECT DMAL_RowId As RowId, DMAL_Type, DMAL_Level, DMAL_SSGroup As SSGroupId, DMAL_Loc_Dr As LocId, DMAL_SSuser_Dr As SSUserId, DMAL_ActiveFlag,"_
				"DMAL_SSGroup->SSGRP_Desc As SSGroupDesc,DMAL_Loc_Dr->CTLOC_Desc As LocDesc,DMAL_SSuser_Dr->SSUSR_Name As SSUserDesc,DMAL_SCG_DR ScgId, DMAL_SCG_DR->Scg_Desc ScgDesc "
				_" FROM DHC_MatAuditLevel"
				_" order by DMAL_Type, ScgId, DMAL_Level"
	s result = ##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	s sc=result.Execute()
	s err=$$$ISERR(sc)
	If err  q $$$OK
	While(result.Next())
	{
		s RowId = result.Data("RowId")
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_MatAuditLevel",RowId,HospId)
		continue:ShowDataFlag="N"
		s Type = result.Data("DMAL_Type")
		s Level = result.Data("DMAL_Level")
		s ActiveFlag = result.Data("DMAL_ActiveFlag")
		s SSGroupId = result.Data("SSGroupId")
		s SSGroupDesc = result.Data("SSGroupDesc")
		s SSUserId = result.Data("SSUserId")
		s SSUserDesc = result.Data("SSUserDesc")
		s LocId = result.Data("LocId")
		s Locdesc = result.Data("LocDesc")
		s ScgId=result.Data("ScgId")
		s ScgDesc=result.Data("ScgDesc")
		s Locdesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(Locdesc)
		d OutPutRow
	}
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,Type,Level,ActiveFlag,SSGroupId,SSGroupDesc,LocId,Locdesc,SSUserId,SSUserDesc,
		ScgId,ScgDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:   保存/更新信息(Js调用)
/// Creater:    lihui
/// CreateDate: 20200702
/// w ##class(web.DHCSTMHUI.MatAuditLevel).jsSave(^tsr("MainInforec"),^tsr("ListDatarec"))
ClassMethod jsSave(Params As %String, ListData As %String) As %Library.String
{
	n (Params,ListData,%session)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..SaveMatAuditLevel(Params,ListData)
	q RtnObj.Json()
}

/// Descript:	保存/更新业务多级审核维护信息
/// Creater:	lihui
/// CreateDate:	20190304
/// Table: DHC_MatAuditLevel
/// Input: 数据串:rowid^代码^描述^类型
/// Output:		
/// Return："" – 成功，非空：失败
/// w ##class(web.DHCSTMHUI.MatAuditLevel).SaveMatAuditLevel()
ClassMethod SaveMatAuditLevel(Params As %String, listData As %String) As RtnObj
{
	n (Params,listData,%session)
	;s ^litmp("SaveMatAuditLevel1")=Params
	;s ^tmpli("SaveMatAuditLevel")=listData
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	
	s MainPJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	q:MainPJObj.%FromJSON(Params)'=0 RtnObj.Err(-1,"","入参解析失败!")
	s gHospId=MainPJObj.%Get("gHospId")
	s pHospId=MainPJObj.%Get("BDPHospital")
	s gHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(listData)
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s Objitm=Obj.%ToJSON()
		i RowId'=""  d
		.s RtnObj=..Update(Objitm)
		e  d
		.s RtnObj=..Insert(Objitm,gHospId)
		continue:RtnObj.success'=0
	}
	i RtnObj.success'=0 tro  q RtnObj
	tc
	q RtnObj
}

/// Descript:	增加业务多级审核维护信息
/// Creater:	lihui
/// CreateDate:	20190304
/// Table: DHC_MatAuditLevel
/// Input: (业务类型^级别^激活标志^安全组^科室^审核人)
/// Output:		
/// Return：0 成功；否则失败
ClassMethod Insert(Params As %String, gHospId As %String) As RtnObj [ Private ]
{
	n (Params,gHospId,%session)
	s RtnObj=##class(RtnObj).%New()
	
	s MainPJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	q:MainPJObj.%FromJSON(Params)'=0 RtnObj.Err(-1,"","入参解析失败!")
	s Type=MainPJObj.%Get("Type")
	if Type=""  d RtnObj.Err(-2,"","业务类型为空","",0) q RtnObj
	s Level=MainPJObj.%Get("Level")
	if Level=""  d RtnObj.Err(-3,"","审核级别为空","",0) q RtnObj
	s SSGroupId=MainPJObj.%Get("SSGroupId")
	s LocId=MainPJObj.%Get("LocId")
	s SSUserId=MainPJObj.%Get("SSUserId")
	s ActiveFlag=MainPJObj.%Get("ActiveFlag")
	s ScgId=MainPJObj.%Get("ScgId")
	s:ActiveFlag="" ActiveFlag="N"

	;s tmpid=$o(^DMALM(0,"typelevel",Type,Level,""))
	;if (tmpid'="")  d RtnObj.Err(-3,"","同类型业务审核级别重复") q RtnObj
	s ExistFlag=..CheckLevelExist(Params)
	i ExistFlag="Y" q RtnObj.Err(-4,"","同类型业务审核级别重复","",0)

	&sql(INSERT INTO DHC_MatAuditLevel
		(DMAL_Type, DMAL_Level, DMAL_SSGroup, DMAL_Loc_Dr, DMAL_SSuser_Dr,
		DMAL_ActiveFlag,DMAL_SCG_DR) 
		VALUES
		(:Type,:Level,:SSGroupId,:LocId,:SSUserId,
		:ActiveFlag,:ScgId))
	i SQLCODE'=0 d
	.d RtnObj.Err(-4,"","插入失败:"_SQLCODE)
	e  d
	.s RowId=$p(%ROWID,$c(1))
	.s JsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_MatAuditLevel",RowId)
	.s RtnObj=##class(Log).SaveLog("DHC_MatAuditLevel","User.DHCMatAuditLevel","业务审核级别维护",$SYSTEM.SQL.GetROWID(),Type_""_Level,"A",JsonStr)
	.q:RtnObj.success'=0
	.//保存医院关联
	.s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("DHC_MatAuditLevel",RowId,gHospId)
	.i ret<0  d RtnObj.Err(-5,"","关联医院失败"_ret)
	q RtnObj
}

/// Descript:	更新业务多级审核维护信息
/// Creater:	lihui
/// CreateDate:	20190304
/// Table: DHC_MatAuditLevel
/// Input: RowId^业务类型^级别^激活标志^安全组^科室^审核人
/// Output:		
/// Return：0 成功；否则失败
ClassMethod Update(Params As %String) As RtnObj [ Private ]
{
	n (Params,%session)
	s RtnObj=##class(RtnObj).%New()
	
	s MainPJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	q:MainPJObj.%FromJSON(Params)'=0 RtnObj.Err(-1,"","入参解析失败!")
	s RowId=MainPJObj.%Get("RowId")
	if RowId=""  d RtnObj.Err(-1,"","记录不存在","",0) q RtnObj
	s Type=MainPJObj.%Get("Type")
	if Type=""  d RtnObj.Err(-2,"","业务类型为空","",0) q RtnObj
	s Level=MainPJObj.%Get("Level")
	if Level=""  d RtnObj.Err(-3,"","审核级别为空","",0) q RtnObj
	s SSGroupId=MainPJObj.%Get("SSGroupId")
	s LocId=MainPJObj.%Get("LocId")
	s SSUserId=MainPJObj.%Get("SSUserId")
	s ActiveFlag=MainPJObj.%Get("ActiveFlag")
	s ScgId=MainPJObj.%Get("ScgId")
	s:ActiveFlag="" ActiveFlag="N"

	;s tmpid=$o(^DMALM(0,"typelevel",Type,Level,""))
	;if ((tmpid'="")&&(tmpid'=RowId)) d RtnObj.Err(-4,"","同类型业务审核级别重复") q RtnObj
	s ExistFlag=..CheckLevelExist(Params)
	i ExistFlag="Y" q RtnObj.Err(-4,"","同类型业务审核级别重复","",0)

	s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_MatAuditLevel",RowId)
	&sql(UPDATE DHC_MatAuditLevel
		SET DMAL_Type=:Type,DMAL_Level=:Level, DMAL_SSGroup=:SSGroupId, DMAL_Loc_Dr=:LocId, DMAL_SSuser_Dr=:SSUserId,
		DMAL_ActiveFlag=:ActiveFlag,DMAL_SCG_DR=:ScgId
		WHERE DMAL_RowId=:RowId)
	i SQLCODE'=0 d
	.d RtnObj.Err(-5,"",$ClassName()_".Update:更新失败:"_SQLCODE)
	e  d
	.s JsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_MatAuditLevel",RowId)
	.s RtnObj=##class(Log).SaveLog("DHC_MatAuditLevel","User.DHCMatAuditLevel","业务审核级别维护",RowId,Type_""_Level,"U",JsonStr,OldJsonStr)
	q RtnObj
}

/// Y:存在重复; 其他:不存在重复
ClassMethod CheckLevelExist(Params) [ Private ]
{
	n (Params)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s RowId=PJObj.%Get("RowId")
	s Type=PJObj.%Get("Type")
	s Level=PJObj.%Get("Level")
	s ScgId=PJObj.%Get("ScgId")
	q:(Type="")||(Level="") "N"
	
	s ExistFlag=""
	s TmpRowId=0
	f  s TmpRowId=$o(^DMALM(0,"typelevel",Type,Level,TmpRowId)) q:(TmpRowId="")||(ExistFlag="Y")  d
	.q:TmpRowId=RowId
	.s LevelScgId=$p(^DMALM(TmpRowId),"^",7)
	.q:ScgId'=LevelScgId
	.s ExistFlag="Y"
	
	q ExistFlag
}

}
