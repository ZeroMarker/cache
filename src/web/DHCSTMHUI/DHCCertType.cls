Import sqluser

/// Descript:证件类型字典
/// Creator: lxt
/// CreateDate: 2020-8-18
Class web.DHCSTMHUI.DHCCertType Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	查询证件类型
/// Creator:	lxt
/// CreateDate:	2020-8-18
/// Table:		DHC_CertType
/// Input:		类型，查询条件
/// Return：	资质类型
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCCertType","SelectAll","Vendor","{""BDPHospital"":""2"",""gUserId"":""873"",""gLocId"":""153"",""gGroupId"":""98"",""gHospId"":""2""}")
Query SelectAll(Type As %String, Params As %String) As Query(ROWSPEC = "RowId,Type,Code,FullName,ShortName,Num:%Float,ShowFlag,WarnDays:%Integer,ControlInDays:%Integer,ControlOutDays:%Integer,ControlUseDays:%Integer") [ SqlProc ]
{
}

ClassMethod SelectAllExecute(ByRef qHandle As %Binary, Type As %String, Params As %String) As %Status
{
	n (qHandle,Type,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	q:Type="" $$$OK

	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)

	s pRowId=PJObj.%Get("RowId")
	s pCode=PJObj.%Get("Code")
	s pFullName=PJObj.%Get("FullName")
	s pShortName=PJObj.%Get("ShortName")
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)

	s SqlStr = "select CT_RowId as RowId,CT_Type as Type,CT_Code as Code,CT_FullName as FullName,"
		_"CT_ShortName as ShortName,CT_Num as Num,CT_ShowFlag as ShowFlag,CT_WarnDays as WarnDays,"
		_"CT_ControlInDays as ControlInDays, CT_ControlOutDays as ControlOutDays, CT_ControlUseDays as ControlUseDays "
		_" from DHC_CertType where CT_Type='"_Type_"'"
	i pCode'="" d
	.s SqlStr=SqlStr_" and CT_Code like '%"_pCode_"%' "
	i pFullName'="" d
	.s SqlStr=SqlStr_" and CT_FullName like '%"_pFullName_"%' "
	i pShortName'="" d
	.s SqlStr=SqlStr_" and CT_ShortName like '%"_pShortName_"%' "
	s SqlStr=SqlStr_" order by CT_Num asc"
	
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	s sc=Result.Execute()
	i $$$ISERR(sc) q $$$OK
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		//判断医院权限
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_CertType",RowId,pHospId)
		continue:ShowDataFlag="N"
		s Type = Result.Data("Type")
		s Code=Result.Data("Code")
		s FullName=Result.Data("FullName")
		s ShortName=Result.Data("ShortName")
		s Num=Result.Data("Num")
		s ShowFlag=Result.Data("ShowFlag")
		s WarnDays=Result.Data("WarnDays")
		s ControlInDays=Result.Data("ControlInDays")
		s ControlOutDays=Result.Data("ControlOutDays")
		s ControlUseDays=Result.Data("ControlUseDays")
		d OutPutRow1
	}
	Quit $$$OK
OutPutRow1
	s Data=$lb(RowId,Type,Code,FullName,ShortName,
		Num,ShowFlag,WarnDays,ControlInDays,ControlOutDays,
		ControlUseDays)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	保存证件类型
/// 对象类型数据
/// w ##class(web.DHCSTMHUI.DHCCertType).jsSave(^templxt("save1"),^templxt("save2"))
ClassMethod jsSave(Main As %String, Detail As %String) As %String
{
	n (Main,Detail,%session)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..Save(Main,Detail)
	q RtnObj.Json()
}

/// Descript:	保存证件类型
/// Creator:	lxt
/// CreateDate:	2020-8-19
/// Table:		DHC_CertType
/// Input:		主单,明细
/// Return：	成功，失败
ClassMethod Save(Main As %String, Detail As %String) As RtnObj
{
	n (Main,Detail,%session)
	s RtnObj=##class(RtnObj).%New()
	
	s MainPJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	q:MainPJObj.%FromJSON(Main)'=0 RtnObj.Err(-1,"","入参解析失败!","",0)
	
	s pType=MainPJObj.%Get("Type")
	s gHospId=MainPJObj.%Get("gHospId")
	s pHospId=MainPJObj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	q:PJObj.%FromJSON(Detail)'=0 RtnObj.Err(-1,"","入参解析失败!","",0)
	
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s Code=Obj.%Get("Code")
		s FullName=Obj.%Get("FullName")
		s ShortName=Obj.%Get("ShortName")
		s Num=Obj.%Get("Num")
		s ShowFlag=Obj.%Get("ShowFlag")
		s WarnDays=Obj.%Get("WarnDays")					;报警天数
		s ControlInDays=Obj.%Get("ControlInDays")		;控制入库天数
		s ControlOutDays=Obj.%Get("ControlOutDays")		;控制出库天数
		s ControlUseDays=Obj.%Get("ControlUseDays")		;控制临床使用天数
		
		i ShortName="" s ShortName=FullName
		
		i RowId'="" d
		.s CertInfo=^User.DHCCertTypeD(RowId)
		.s OrginCode=$list(CertInfo,3)
		.i Code'=OrginCode d RtnObj.Err(-2,RowId,OrginCode_" 代码维护后不允许修改!","",0)
		q:RtnObj.success<0
		
	 	s ret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("CODE",Code,"DHC_CertType",pHospId,RowId,pType)
		i ret>0 d RtnObj.Err(-3,RowId,Code_" 代码重复!","",0)
		q:RtnObj.success<0
		
		s ret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("DESC",FullName,"DHC_CertType",pHospId,RowId,pType)
		i ret>0 d RtnObj.Err(-4,RowId,FullName_" 全称重复!","",0)
		q:RtnObj.success<0
		s ret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("ALIASDESC",ShortName,"DHC_CertType",pHospId,RowId,pType)
		i ret>0 d RtnObj.Err(-5,RowId,ShortName_" 简称重复!","",0)
		q:RtnObj.success<0
		
		i RowId="" d
		.s obj=##class(User.DHCCertType).%New()
		.s obj.CTType=pType
		e  d
		.s obj=##class(User.DHCCertType).%OpenId(RowId)
		.d obj.%Reload()
		s obj.CTCode=Code
		s obj.CTFullName=FullName
		s obj.CTShortName=ShortName
		s obj.CTNum=Num
		s obj.CTShowFlag=ShowFlag
		s obj.CTWarnDays=WarnDays
		s obj.CTControlInDays=ControlInDays
		s obj.CTControlOutDays=ControlOutDays
		s obj.CTControlUseDays=ControlUseDays
		s Sc=obj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-6,"",MethodName_":保存失败!")
		q:RtnObj.success<0
		
		i RowId="" d
		.s RowId=obj.%Id()
		.//保存医院关联
		.s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("DHC_CertType",RowId,pHospId)
		.i ret<0 d RtnObj.Err(-7,"","关联医院失败"_ret)
		q:RtnObj.success<0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj
}

ClassMethod GetCertTypeShare(OrgType)
{
	n (OrgType)
	i OrgType="Dealer" s OrgType="Vendor"
	q OrgType
}

}
