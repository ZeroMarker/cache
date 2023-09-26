Import sqluser

/// Descript:应用系统参数设定
Class web.DHCSTMHUI.StkSysAppParam Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	查询应用系统参数信息
/// Creator:	wangjiabin
/// CreateDate:	2018-08-20
/// Table:		DHC_StkSysAProp
/// Input:
/// Output:		
/// Return:		应用系统参数信息
/// Others: w ##class(web.DHCSTMHUI.StkSysAppParam).SelectAll(91)
ClassMethod SelectAll(Parref As %String)
{
	n (Parref)
	q:Parref="" ""
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select SSAP_RowID as RowId,SSAP_Code as Code,SSAP_Desc as Description,SSAP_Memo as Memo,SSAP_Value as PropValue from DHC_StkSysAProp"
		_" where SSAP_SSA_Parref="_Parref
		_" order by Code"
	d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	s json = ##class(web.DHCSTMHUI.Common.JsonObj).%New()
	While(result.Next())
	{
		s RowId = result.Data("RowId")
		s Code = result.Data("Code")
		s Description = result.Data("Description")
		s Memo = result.Data("Memo")
		s PropValue = result.Data("PropValue")
		i Code="FtpPassword" s PropValue="******"
		s DataStr=RowId_"^"_Parref_"^"_Code_"^"_Description_"^"_Memo_"^"_PropValue
		s count = count+1		
		d json.InsertRowData(DataStr)
	}
	d result.Close()
	d json.getJsonData("RowId^Parref^Code^Desc^Memo^PropValue",count)
	k json
	q ""
}

/// Descript:	删除应用系统参数信息
/// Creator:	wangjiabin
/// CreateDate:	2018-08-22
/// Table:		DHC_StkSysAProp
/// Input:		Json
/// Output:		RtnObj.Json()
ClassMethod Delete(Params) As %Library.String
{
	n (Params,%session)
	s $ZT=..sssError()
	s MethodName=$CLASSNAME()_".Delete"
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"",MethodName_":参数解析错误")
	ts
	While(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		
		s RowId=Obj.%Get("RowId")
		continue:RowId=""
		&sql(Delete from DHC_StkSysAProp where SSAP_RowID=:RowId)
		i SQLCODE'=0 d
		.d RtnObj.Err(-2,RowId,MethodName_":删除失败")
		continue:RtnObj.success<0
	}
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Descript:	保存/更新应用系统参数信息
/// Creator:	wangjiabin
/// CreateDate:	2018-08-22
/// Table:		DHC_StkSysAProp
/// Input:		Json(rowid,父表id,名称,描述,备注)
/// Output:		
/// Return："" – 成功，非空：失败
/// Others:w ##class(web.DHCSTMHUI.StkSysAppParam).Save("^1^dd^dd^dd^dd")
ClassMethod Save(Parref, Detail As %String) As %Library.String
{
	n (Parref,Detail,%session)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Detail)
	i Sc'=0 q RtnObj.Err(-1,"","入参解析失败!").Json()
	i Parref="" q RtnObj.Err(-1,"","入参错误!").Json()
	
	ts
	While(RtnObj.success=0){
		s RowObj=PJObj.%Pop()
		q:RowObj=""
		
		s RowId=RowObj.%Get("RowId")
		s Code=RowObj.%Get("Code")
		s Desc=RowObj.%Get("Desc")
		s Memo=RowObj.%Get("Memo")
		s PropValue=RowObj.%Get("PropValue")
		i ($$ALPHAUP^SSUTIL4(Code)="")||($$ALPHAUP^SSUTIL4(Desc)="") d RtnObj.Err(-2,RowId,"代码或名称不可为空!","",0)
		continue:RtnObj.success<0
		i (RowId="")&&$d(^DHCSSA(0,"APNAME",Parref,$$ALPHAUP^SSUTIL4(Code))) d RtnObj.Err(-3,RowId,"参数已存在!","",0)
		continue:RtnObj.success<0
		i Code="FtpPassword" s PropValue=##class(web.DHCSTMHUI.Common.UtilCommon).EncryptPW(PropValue)
		
		i RowId="" d
		.s Obj=##class(User.DHCStkSysAProp).%New()
		.d Obj.SSAPSSAParrefSetObjectId(Parref)
		.s Ch=1+$o(^DHCSSA(Parref,"AP",""),-1)
		.s Obj.SSAPChildSub=Ch
		.s Obj.SSAPCode=Code
		e  d
		.s Obj=##Class(User.DHCStkSysAProp).%OpenId(RowId)
		s Obj.SSAPDesc=Desc
		s Obj.SSAPMemo=Memo
		s Obj.SSAPValue=PropValue
		s Sc=Obj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-10,RowId,"保存失败!")
		continue:RtnObj.success<0
	}
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Descript:	查询应用系统参数值信息
/// Creator:	wangjiabin
/// CreateDate:	2018-08-20
/// Table:		DHC_StkSysAPropPref
/// Input:		参数ID,医院rowid
/// Output:		
/// Return:		应用系统参数值信息
/// Others: w ##class(web.DHCSTMHUI.StkSysAppParam).SelectProp("91||1")
ClassMethod SelectProp(Parref As %String, HospId As %String)
{
	n (Parref,HospId)
	q:Parref="" ""
	s result=##class(%Library.ResultSet).%New()
	s sqlStr="select PF_SSAP_ParRef as ParRef,PF_RowId as RowId,PF_Type as Type,PF_Pointer as Pointer,PF_Value as PFValue,"
		_" PF_Hospital_DR as HospDr, PF_StDate as StartDate "
		_" from DHC_StkSysAPropPref where PF_SSAP_ParRef='"_Parref_"'"
	d result.Prepare(sqlStr)
	d result.Execute()
	s count=0
	s json=##class(web.DHCSTMHUI.Common.JsonObj).%New()
	While(result.Next())
	{
		s ParRef=result.Data("ParRef")
		s RowId=result.Data("RowId")
		s Type=result.Data("Type")
		s Pointer=result.Data("Pointer")
		s Value=result.Data("PFValue")
		s HospDr=result.Data("HospDr")
		s StartDate=result.Data("StartDate")
		
		s Code=$p(^DHCSSA(+ParRef,"AP",$p(ParRef,"||",2)),"^",1)
		i Code="FtpPassword" s Value="******"
		
		s (TypeName,PointerName)=""
		;,G,L,U,D
		i Type = "G" d
		.s TypeName="安全组"
		.&sql(select SSGRP_Desc into :PointerName from SS_Group where SSGRP_RowId=:Pointer)
		e  i Type = "L" d
		.s TypeName="科室"
		.&sql(select CTLOC_DESC into :PointerName from CT_Loc WHERE CTLOC_ROWID=:Pointer)
		e  i Type="U" d
		.s TypeName="用户"
		.&sql(select ssusr_name,SSUSR_Initials into :PointerName,:Initials from SS_user where ssusr_rowid=:Pointer)
		.q:SQLCODE'=0
		.s PointerName=PointerName	//_"["_Initials_"]"
		e  i Type="D" d
		.s TypeName="全院"
		.&sql(select HOSP_Desc into :PointerName from CT_Hospital where HOSP_RowId=:Pointer)

		s HospName=""
		i (HospDr'="")&&$d(^CT("HOSP",HospDr)) d
		.s HospName=$P($G(^CT("HOSP",HospDr)),"^",2)
		s StartDate=..DL2H(StartDate)
		s DataStr=ParRef_"^"_RowId_"^"_Type_"^"_TypeName_"^"_Pointer
			_"^"_PointerName_"^"_Value_"^"_HospDr_"^"_HospName_"^"_StartDate
		s count = count+1
		d json.InsertRowData(DataStr)
	}
	d result.Close()
	s TitleStr="Parref^RowId^Type^TypeName^Pointer"
		_"^PointerName^Value^HospId^HospName^StartDate"
	d json.getJsonData(TitleStr,count)
	k json
	q ""
}

/// Descript:	保存/更新应用系统参数值信息
/// Creator:	wangjiabin
/// CreateDate:	2018-08-22
/// Table:		DHC_StkSysAPropPref
/// Input:		父表rowid, Json(rowid,父表id,类型,类型值,参数值,医院)
/// Output:		RtnObj.Json()
/// w ##class(web.DHCSTMHUI.StkSysAppParam).SaveProp("105||4","{""Type"":""D"",""gUserId"":""4642"",""gLocId"":""392"",""gGroupId"":""264"",""gHospId"":""2"",""Pointer"":""1"",""HospId"":"""",""RowId"":""105||4||1"",""Value"":""2""}")
ClassMethod SaveProp(Parref, Detail) As %Library.String
{
	n (Parref,Detail,%session)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Detail)
	i Sc'=0 q RtnObj.Err(-1,"","入参解析失败!").Json()
	i Parref="" q RtnObj.Err(-1,"","入参错误!").Json()
	
	ts
	s RowId=PJObj.%Get("RowId")
	s Type=PJObj.%Get("Type")
	s Pointer=PJObj.%Get("Pointer")
	i ((Type="")||(Pointer="")) d RtnObj.Err(-1,"","类型或者类型值为空","",0) q RtnObj.Json()
	s Value=PJObj.%Get("Value")
	s HospId=PJObj.%Get("HospId")
	s StartDate=PJObj.%Get("StartDate")
	s StartDate=..DH2L(StartDate)
	s SSA=$P(Parref,"||",1),SSAPCh=$p(Parref,"||",2)
	s Code=$p(^DHCSSA(SSA,"AP",SSAPCh),"^",1)
	
	i RowId="" d
	.s Obj=##class(User.DHCStkSysAPropPref).%New()
	.d Obj.PFSSAPParRefSetObjectId(Parref)
	.s Ch=1+$o(^DHCSSA(SSA,"AP",SSAPCh,"PF",""),-1)
	.s Obj.PFChildSub=Ch
	e  d
	.s Obj=##Class(User.DHCStkSysAPropPref).%OpenId(RowId)
	s Obj.PFType=Type
	s Obj.PFPointer=Pointer
	
	i (Code'="FtpPassword")||(Value'="******") d
	.i Code="FtpPassword" s Value=##class(web.DHCSTMHUI.Common.UtilCommon).EncryptPW(Value)
	.s Obj.PFValue=Value
	
	d Obj.PFHospitalDRSetObjectId(HospId)
	s Obj.PFStDate=StartDate
	s Sc=Obj.%Save()
	i $$$ISERR(Sc) d RtnObj.Err(-10,RowId,"保存失败!")
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Descript:	删除应用系统参数值信息
/// Creator:	wangjiabin
/// CreateDate:	2018-08-22
/// Table:		DHC_StkSysAPropPref
/// Input:		Json({RowId:**})
/// Output:		RtnObj.Json()
ClassMethod DeleteProp(Params As %String) As %Library.String
{
	n (Params,%session)
	s $ZT=..sssError()
	s MethodName=$CLASSNAME()_".DeleteProp"
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"",MethodName_":参数解析错误")
	ts
	While(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		
		s RowId=Obj.%Get("RowId")
		continue:RowId=""
		&sql(Delete from DHC_StkSysAPropPref where PF_RowId=:RowId)
		i SQLCODE'=0 d
		.d RtnObj.Err(-2,RowId,MethodName_":删除失败")
		continue:RtnObj.success<0
	}
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Descript:	获取参数值明显信息,填充表单
/// Creator:	wangjiabin
/// CreateDate:	2018-10-19
/// Table:		DHC_StkSysAPropPref
/// Input:		Json({RowId:**})
/// Output:		表单对象信息
/// d ##class(web.DHCSTMHUI.StkSysAppParam).GetPropDetail("105||4||1")
ClassMethod GetPropDetail(RowId As %String)
{
	n (RowId)
	q:RowId="" $$$NullJson
	
	s SSA=$p(RowId,"||",1),AP=$p(RowId,"||",2),PF=$p(RowId,"||",3)
	s PFInfo=^DHCSSA(SSA,"AP",AP,"PF",PF)
	s Type=$p(PFInfo,"^",1)
	s Pointer=$p(PFInfo,"^",2)
	s Value=$p(PFInfo,"^",3)
	s HospDr=$p(PFInfo,"^",4)
	s StartDate=$p(PFInfo,"^",5)

	s TypeName="",PointerName="",HospName=""
	i Type="G" d
	.s TypeName="安全组"
	.&sql(select SSGRP_Desc into :PointerName from SS_Group where SSGRP_RowId=:Pointer)
	e  i Type="L" d
	.s TypeName="科室"
	.&sql(select CTLOC_DESC into :PointerName from CT_Loc WHERE CTLOC_ROWID=:Pointer)
	e  i Type="U" d
	.s TypeName="用户"
	.&sql(select ssusr_name,SSUSR_Initials into :PointerName,:Initials from SS_user where ssusr_rowid=:Pointer)
	.q:SQLCODE'=0
	.//s PointerName=PointerName_"["_Initials_"]"
	e  i Type="D" d
	.s TypeName="全院"
	.&sql(select HOSP_Desc into :PointerName from CT_Hospital where HOSP_RowId=:Pointer)
	i (HospDr'="")&&$d(^CT("HOSP",HospDr)) d
	.s HospName=$P($G(^CT("HOSP",HospDr)),"^",2)
	
	s TypeField=..sssComboStr(Type,TypeName)
	s PointerField=..sssComboStr(Pointer,PointerName)
	s HospField=..sssComboStr(HospDr,HospName)
	s StartDate=..DL2H(StartDate)
	
	s APInfo=^DHCSSA(SSA,"AP",AP)
	s Code=$p(APInfo,"^",1)
	i Code="FtpPassword" s Value="******"
	
	s DataStr=RowId_"^"_TypeField_"^"_PointerField_"^"_Value_"^"_HospField
		_"^"_StartDate
	s TitleStr="RowId^Type^Pointer^Value^HospId"
		_"^StartDate"
	s Str=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(DataStr,TitleStr)
	q Str
	w ""
}

}
