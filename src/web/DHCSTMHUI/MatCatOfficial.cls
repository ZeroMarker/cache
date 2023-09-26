Import sqluser

Class web.DHCSTMHUI.MatCatOfficial Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Description:获取68分类tree信息
/// Creator:	wangjiabin
/// CreateDate:	2018-08-01
/// Table:		DHC_MatCatOfficial
/// Input:		tree节点id(为空时显示所有)
/// Output:		
/// w ##class(web.DHCSTMHUI.MatCatOfficial).GetOfficalInfo()
ClassMethod GetOfficalInfo(ParentId = "", Params = "") [ ProcedureBlock = 1 ]
{
	s id=$p(ParentId,"-")
	s rowid=$p(ParentId,"-",2)
	
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s gHospId=PJobj.%Get("gHospId")
	s pHospId=PJobj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
	i ParentId="" d
	.w "[{""id"":""AllMCO"",""text"":""68分类"",""iconCls"":""icon-sum"",""children"":"
	.d ..GetOfficalInfo("AllMCO",Params)
	.w "}]"
	q:ParentId=""
	
	s result=##class(%Library.ResultSet).%New()
	i id="AllMCO" d
	.s sqlStr="select 'MCO-'||MCO_Rowid as RowId, MCO_Code as Code, MCO_Desc as Description From DHC_MatCatOfficial where MCO_Uplevel_DR is null order by MCO_Desc"
	e  i id="MCO" d
	.s sqlStr="select 'MCO-'||MCO_Rowid as RowId, MCO_Code as Code, MCO_Desc as Description From DHC_MatCatOfficial where MCO_Uplevel_DR="_rowid_" order by Description"
	d result.Prepare(sqlStr)
	d result.Execute()
	s count=0
	w "["
	While(result.Next())
	{
		s Id=result.Data("RowId")
		s Token=$p(Id,"-",1)
		s TmpRowId=+$p(Id,"-",2)
		continue:TmpRowId=0
		continue:(Token="MCO")&&('$d(^DHCMCO(TmpRowId)))
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_MatCatOfficial",TmpRowId,pHospId)
		continue:ShowDataFlag="N"
		s Desc=result.Data("Description")
		&sql(select %id from DHC_MatCatOfficial where MCO_Uplevel_DR=:TmpRowId)
		s IsParent=$s(SQLCODE=0:"Y",1:"N")
		s IconCls="icon-star-yellow"
		s count=count+1
		i count=1 w "{"
		e  w ",{"
		w """id"":"""_Id_""",""text"":"""_Desc_""""_",""iconCls"":"""_IconCls_""""
		i (IsParent="Y") d
		.w ",""children"":"
		.d ..GetOfficalInfo(Id,Params)
		w "}"
	}
	d result.Close()
	w "]"
}

/// Description: 新建官方分类
/// Creator: tsr
/// CreateDate: 2017-07-18
/// Table: DHC_MatCatOfficial
/// Input: Strparam(代码^名称^上层分类rowid)
/// Return: "":成功, '="":失败信息
ClassMethod AddMatCatOfficial(StrParam, Main) As %String
{
	n (StrParam,Main,%session)
	
	s MainPJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	q:MainPJObj.%FromJSON(Main)'=0 "入参解析失败!"
	s gHospId=MainPJObj.%Get("gHospId")
	s pHospId=MainPJObj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
	s NewCode=$p(StrParam,"^",1)
	s NewDesc=$p(StrParam,"^",2)
	s ParentId=$p(StrParam,"^",3)
	s ret=""
	s $ZT=..sssError()
	ts
	s matret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("CODE",NewCode,"DHC_MatCatOfficial",pHospId)
	i matret>0 s ret="代码重复"
	s matret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("DESC",NewDesc,"DHC_MatCatOfficial",pHospId)
	i matret>0 s ret="名称重复"
	q:ret'="" ret
	
	&sql(Insert into DHC_MatCatOfficial(MCO_Code, MCO_Desc, MCO_Uplevel_DR)
		values (:NewCode,:NewDesc,:ParentId))
	i SQLCODE s ret="保存失败!"
	i ret'="" tro  q ret
	s RowId=%ROWID
	
	//保存医院关联
	s matret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("DHC_MatCatOfficial",RowId,pHospId)
	i matret<0 s ret="关联医院失败"
	i ret'="" tro  q ret
	
	tc
	q ret
}

/// Description: 修改官方分类
/// Creator: tsr
/// CreateDate:	2017-07-18
/// Input: StrParam(rowid^代码^名称)
/// Return: "":成功, '="":失败信息
ClassMethod UpdateMatCatOfficial(StrParam As %String, Main) As %Library.String
{
	n (StrParam,Main,%session)
	s rowid=$p(StrParam,"^",1)
	s code=$p(StrParam,"^",2)
	s desc=$p(StrParam,"^",3)
	q:rowid="" "信息有误!"
	q:code="" "代码为空!"
	q:desc="" "名称为空!"
	
	s MainPJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	q:MainPJObj.%FromJSON(Main)'=0 "入参解析失败!"
	s gHospId=MainPJObj.%Get("gHospId")
	s pHospId=MainPJObj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
	s ret=""
	s $ZT=..sssError()

	s matret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("CODE",code,"DHC_MatCatOfficial",pHospId,rowid)
	i matret>0 s ret="代码重复"
	s matret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("DESC",desc,"DHC_MatCatOfficial",pHospId,rowid)
	i matret>0 s ret="名称重复"
	q:ret'="" ret
	
	s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_MatCatOfficial",rowid)
	&sql(Update DHC_MatCatOfficial set MCO_Code=:code,MCO_Desc=:desc where MCO_Rowid=:rowid)
	q:SQLCODE'=0 "更新失败!"
	d ##class(Log).SaveLog("DHC_MatCatOfficial","User.DHCMatCatOfficial","官方分类信息",rowid,desc,"U","",OldJsonStr)
	q ""
}

/// Description: 获取官方分类信息
/// Creator: tsr
/// CreateDate:	2017-07-18
/// Input: RowId
/// Return: 代码^名称
ClassMethod GetMatCatOfficial(RowId) As %String
{
	n (RowId)
	q:RowId="" ""
	q:'$d(^DHCMCO(RowId)) ""
	s Code=$p(^DHCMCO(RowId),"^",1)
	s Desc=$p(^DHCMCO(RowId),"^",2)
	s result=Code_"^"_Desc
	q result
}

/// Description: 将官方分类上下级进行关联
/// Creator: tsr
/// CreateDate:	2017-07-18
/// Table: DHC_MatCatOfficial
/// Input: 上级分类id, 本级分类id
/// Return: "":成功, '="":失败信息
ClassMethod UpdateParMco(ParMco, Mco) As %String
{
	n (ParMco,Mco)
	q:Mco="" -1
	&sql(update DHC_MatCatOfficial set MCO_Uplevel_DR=:ParMco where MCO_Rowid=:Mco)
	q:SQLCODE "修改失败!"
	q ""
}

/// Description:获取临床分类tree信息
/// Creator:	wangjiabin
/// CreateDate:	2018-08-02
/// Table:		DHC_MatCatClinical
/// Input:		tree节点id(为空时显示所有)
/// Output:		
/// d ##class(web.DHCSTMHUI.MatCatOfficial).GetClinicalInfo("","{""BDPHospital"":""2"",""gUserId"":""6423"",""gLocId"":""163"",""gGroupId"":""277"",""gHospId"":""2""}")
ClassMethod GetClinicalInfo(ParentId = "", Params = "") [ ProcedureBlock = 1 ]
{
	s id=$p(ParentId,"-")
	s rowid=$p(ParentId,"-",2)
	
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s gHospId=PJobj.%Get("gHospId")
	s pHospId=PJobj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
	i ParentId="" d
	.w "[{""id"":""AllMCC"",""text"":""重点关注分类"",""iconCls"":""icon-sum"",""children"":"
	.d ..GetClinicalInfo("AllMCC",Params)
	.w "}]"
	q:ParentId=""
	
	s result=##class(%Library.ResultSet).%New()
	i id="AllMCC" d
	.s sqlStr="select 'MCC-'||MCC_Rowid as RowId, MCC_Code as Code, MCC_Desc as Description From DHC_MatCatClinical where MCC_Uplevel_DR is null order by MCC_Desc"
	e  i id="MCC" d
	.s sqlStr="select 'MCC-'||MCC_Rowid as RowId, MCC_Code as Code, MCC_Desc as Description From DHC_MatCatClinical where MCC_Uplevel_DR="_rowid_" order by Description"
	d result.Prepare(sqlStr)
	d result.Execute()
	s count=0
	w "["
	While(result.Next())
	{
		s Id=result.Data("RowId")
		s Token=$p(Id,"-",1)
		s TmpRowId=+$p(Id,"-",2)
		continue:TmpRowId=0
		continue:(Token="MCC")&&('$d(^DHCMCC(TmpRowId)))
		
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_MatCatClinical",TmpRowId,pHospId)
		continue:ShowDataFlag="N"
		
		s Desc=result.Data("Description")
		
		&sql(select %id from DHC_MatCatClinical where MCC_Uplevel_DR=:TmpRowId)
		s IsParent=$s(SQLCODE=0:"Y",1:"N")
		s IconCls="icon-star-yellow"
		s count=count+1
		i count=1 w "{"
		e  w ",{"
		w """id"":"""_Id_""",""text"":"""_Desc_""""_",""iconCls"":"""_IconCls_""""
		i (IsParent="Y") d
		.w ",""children"":"
		.d ..GetClinicalInfo(Id,Params)
		w "}"
	}
	d result.Close()
	w "]"
}

/// Description: 新建临床分类
/// Creator: tsr
/// CreateDate: 2017-07-18
/// Table: DHC_MatCatClinical
/// Input: Strparam(代码^名称^上层分类rowid)
/// Return: "":成功, '="":失败信息
ClassMethod AddMatCatClinical(StrParam, Main = "") As %String
{
	n (StrParam,Main,%session)
	s NewCode=$p(StrParam,"^",1)
	s NewDesc=$p(StrParam,"^",2)
	s ParentId=$p(StrParam,"^",3)
	
	s MainPJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	q:MainPJObj.%FromJSON(Main)'=0 "入参解析失败!"
	s gHospId=MainPJObj.%Get("gHospId")
	s pHospId=MainPJObj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
	s ret=""
	s $ZT=..sssError()
	ts
	s matret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("CODE",NewCode,"DHC_MatCatClinical",pHospId)
	i matret>0 s ret="代码重复"
	s matret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("DESC",NewDesc,"DHC_MatCatClinical",pHospId)
	i matret>0 s ret="名称重复"
	q:ret'="" ret
	
	&sql(Insert into DHC_MatCatClinical(MCC_Code, MCC_Desc, MCC_Uplevel_DR)
		values (:NewCode,:NewDesc,:ParentId))
	i SQLCODE s ret="保存失败!"
	i ret'="" tro  q ret
	s RowId=%ROWID
	//保存医院关联
	s matret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("DHC_MatCatClinical",RowId,pHospId)
	i matret<0 s ret="关联医院失败"
	i ret'="" tro  q ret
	
	tc
	q ret
}

/// Description: 修改临床分类
/// Creator: tsr
/// CreateDate:	2017-07-18
/// Input: StrParam(rowid^代码^名称)
/// Return: "":成功, '="":失败信息
ClassMethod UpdateMatCatClinical(StrParam As %String, Main) As %Library.String
{
	n (StrParam,Main,%session)
	s rowid=$p(StrParam,"^",1)
	s code=$p(StrParam,"^",2)
	s desc=$p(StrParam,"^",3)
	q:rowid="" "信息有误!"
	q:code="" "代码为空!"
	q:desc="" "名称为空!"
	
	s MainPJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	q:MainPJObj.%FromJSON(Main)'=0 "入参解析失败!"
	s gHospId=MainPJObj.%Get("gHospId")
	s pHospId=MainPJObj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
	s ret=""
	s $ZT=..sssError()
	
	s matret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("CODE",code,"DHC_MatCatClinical",pHospId,rowid)
	i matret>0 s ret="代码重复"
	s matret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("DESC",desc,"DHC_MatCatClinical",pHospId,rowid)
	i matret>0 s ret="名称重复"
	q:ret'="" ret
	
	s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_MatCatClinical",rowid)
	&sql(Update DHC_MatCatClinical set MCC_Code=:code,MCC_Desc=:desc where MCC_Rowid=:rowid)
	q:SQLCODE'=0 "更新失败!"
	d ##class(Log).SaveLog("DHC_MatCatClinical","User.DHCMatCatClinical","临床分类信息",rowid,desc,"U","",OldJsonStr)
	q ""
}

/// Description: 获取临床分类信息
/// Creator: tsr
/// CreateDate:	2017-07-18
/// Input: RowId
/// Return: 代码^名称
ClassMethod GetMatCatClinical(RowId) As %String
{
	n (RowId)
	q:RowId="" ""
	q:'$d(^DHCMCC(RowId)) ""
	s Code=$p(^DHCMCC(RowId),"^",1)
	s Desc=$p(^DHCMCC(RowId),"^",2)
	s result=Code_"^"_Desc
	q result
}

/// Description: 将临床分类上下级进行关联
/// Creator: tsr
/// CreateDate:	2017-07-18
/// Table: DHC_MatCatClinical
/// Input: 上级分类id, 本级分类id
/// Return: "":成功, '="":失败信息
ClassMethod UpdateParMcc(ParMcc, Mcc) As %String
{
	n (ParMcc,Mcc)
	q:Mcc="" -1
	&sql(update DHC_MatCatClinical set MCC_Uplevel_DR=:ParMcc where MCC_Rowid=:Mcc)
	q:SQLCODE "修改失败!"
	q ""
}

/// Description:获取特殊分类tree信息
/// Creator:	wangjiabin
/// CreateDate:	2018-08-02
/// Table:		DHC_MatCatSpecial
/// Input:		tree节点id(为空时显示所有)
/// Output:		
/// d ##class(web.DHCSTMHUI.MatCatOfficial).GetSpecialInfo("")
ClassMethod GetSpecialInfo(ParentId = "", Params = "") [ ProcedureBlock = 1 ]
{
	s id=$p(ParentId,"-")
	s rowid=$p(ParentId,"-",2)
	
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s gHospId=PJobj.%Get("gHospId")
	s pHospId=PJobj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
	i ParentId="" d
	.w "[{""id"":""AllMCS"",""text"":""特殊分类"",""iconCls"":""icon-sum"",""children"":"
	.d ..GetSpecialInfo("AllMCS",Params)
	.w "}]"
	q:ParentId=""
	
	s result=##class(%Library.ResultSet).%New()
	i id="AllMCS" d
	.s sqlStr="select 'MCS-'||MCS_Rowid as RowId, MCS_Code as Code, MCS_Desc as Description From DHC_MatCatSpecial where MCS_Uplevel_DR is null order by MCS_Desc"
	e  i id="MCS" d
	.s sqlStr="select 'MCS-'||MCS_Rowid as RowId, MCS_Code as Code, MCS_Desc as Description From DHC_MatCatSpecial where MCS_Uplevel_DR="_rowid_" order by Description"
	d result.Prepare(sqlStr)
	d result.Execute()
	s count=0
	w "["
	While(result.Next())
	{
		s Id=result.Data("RowId")
		s Token=$p(Id,"-",1)
		s TmpRowId=+$p(Id,"-",2)
		continue:TmpRowId=0
		continue:(Token="MCS")&&('$d(^DHCMCS(TmpRowId)))
		
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_MatCatSpecial",TmpRowId,pHospId)
		continue:ShowDataFlag="N"
		
		s Desc=result.Data("Description")
		
		&sql(select %id from DHC_MatCatSpecial where MCS_Uplevel_DR=:TmpRowId)
		s IsParent=$s(SQLCODE=0:"Y",1:"N")
		s IconCls="icon-star-yellow"
		s count=count+1
		i count=1 w "{"
		e  w ",{"
		w """id"":"""_Id_""",""text"":"""_Desc_""""_",""iconCls"":"""_IconCls_""""
		i (IsParent="Y") d
		.w ",""children"":"
		.d ..GetSpecialInfo(Id,Params)
		w "}"
	}
	d result.Close()
	w "]"
}

/// Description: 新建特殊分类
/// Creator: tsr
/// CreateDate: 2017-07-18
/// Table: DHC_MatCatSpecial
/// Input: Strparam(代码^名称^上层分类rowid)
/// Return: "":成功, '="":失败信息
ClassMethod AddMatCatSpecial(StrParam, Main = "") As %String
{
	n (StrParam,Main,%session)
	s NewCode=$p(StrParam,"^",1)
	s NewDesc=$p(StrParam,"^",2)
	s ParentId=$p(StrParam,"^",3)
	
	s MainPJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	q:MainPJObj.%FromJSON(Main)'=0 "入参解析失败!"
	s gHospId=MainPJObj.%Get("gHospId")
	s pHospId=MainPJObj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
	s ret=""
	s $ZT=..sssError()
	ts
	s TempId=$o(^DHCMCS(0,"Code",$$ALPHAUP^SSUTIL4(NewCode),""))
	i TempId'="" s ret="代码重复"
	i ret'="" tro  q ret
	;s matret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("CODE",NewCode,"DHC_MatCatSpecial",pHospId)
	;i matret>0 s ret="代码重复"
	s matret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("DESC",NewDesc,"DHC_MatCatSpecial",pHospId)
	i matret>0 s ret="名称重复"
	i ret'="" tro  q ret
	
	&sql(Insert into DHC_MatCatSpecial(MCS_Code, MCS_Desc, MCS_Uplevel_DR)
		values (:NewCode,:NewDesc,:ParentId))
	i SQLCODE s ret="保存失败!"
	i ret'="" tro  q ret
	s RowId=%ROWID
	
	//保存医院关联
	s matret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("DHC_MatCatSpecial",RowId,pHospId)
	i matret<0 s ret="关联医院失败"
	i ret'="" tro  q ret
	
	tc
	q ret
}

/// Description: 修改特殊分类
/// Creator: tsr
/// CreateDate:	2017-07-18
/// Input: StrParam(rowid^代码^名称)
/// Return: "":成功, '="":失败信息
ClassMethod UpdateMatCatSpecial(StrParam As %String, Main) As %Library.String
{
	n (StrParam,Main,%session)
	s rowid=$p(StrParam,"^",1)
	s code=$p(StrParam,"^",2)
	s desc=$p(StrParam,"^",3)
	q:rowid="" "信息有误!"
	q:code="" "代码为空!"
	q:desc="" "名称为空!"
	
	s MainPJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	q:MainPJObj.%FromJSON(Main)'=0 "入参解析失败!"
	s gHospId=MainPJObj.%Get("gHospId")
	s pHospId=MainPJObj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
	s ret=""
	s $ZT=..sssError()
	s TempId=$o(^DHCMCS(0,"Code",$$ALPHAUP^SSUTIL4(code),""))
	i (TempId'="")&&(TempId'=rowid) s ret="代码重复"
	q:ret'="" ret
	;s matret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("CODE",code,"DHC_MatCatSpecial",pHospId,rowid)
	;i matret>0 s ret="代码重复"
	s matret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("DESC",desc,"DHC_MatCatSpecial",pHospId,rowid)
	i matret>0 s ret="名称重复"
	q:ret'="" ret
	
	s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_MatCatSpecial",rowid)
	&sql(Update DHC_MatCatSpecial set MCS_Code=:code,MCS_Desc=:desc where MCS_Rowid=:rowid)
	q:SQLCODE'=0 "更新失败!"
	d ##class(Log).SaveLog("DHC_MatCatSpecial","User.DHCMatCatSpecial","特殊分类信息",rowid,desc,"U","",OldJsonStr)
	q ""
}

/// Description: 获取特殊分类信息
/// Creator: tsr
/// CreateDate:	2017-07-18
/// Input: RowId
/// Return: 代码^名称
ClassMethod GetMatCatSpecial(RowId) As %String
{
	n (RowId)
	q:RowId="" ""
	q:'$d(^DHCMCS(RowId)) ""
	s Code=$p(^DHCMCS(RowId),"^",1)
	s Desc=$p(^DHCMCS(RowId),"^",2)
	s result=Code_"^"_Desc
	q result
}

/// Description: 将特殊分类上下级进行关联
/// Creator: tsr
/// CreateDate:	2017-07-18
/// Table: DHC_MatCatSpecial
/// Input: 上级分类id, 本级分类id
/// Return: "":成功, '="":失败信息
ClassMethod UpdateParMcs(ParMcs, Mcs) As %String
{
	n (ParMcs,Mcs)
	q:Mcs="" -1
	&sql(update DHC_MatCatSpecial set MCS_Uplevel_DR=:ParMcs where MCS_Rowid=:Mcs)
	q:SQLCODE "修改失败!"
	q ""
}

/// Descript:	初始化重点关注分类数据
/// Creator:	wxj
/// CreateDate:	2021-12-24
/// Table:		DHC_MatCatClinical
/// Input:		
/// Return：	成功，失败
/// w ##class(web.DHCSTMHUI.MatCatOfficial).ResetClinicData()
ClassMethod ResetClinicData() As %String
{
	s RtnObj=##class(RtnObj).%New()
	s Rowid=""
	&sql(select top 1 %ID into :Rowid from DHC_MatCatClinical)
	ts
	i Rowid'="" d
	.s Ret=##class(web.DHCSTMHUI.MatForBDPData).DeleteHospitals("DHC_MatCatClinical")
	.i Ret<0  d RtnObj.Err(-2,"","清除重点关注分类院区关联数据失败")	
	.q:RtnObj.success<0
	.&sql(DELETE FROM DHC_MatCatClinical)
	.i SQLCODE'=0  d RtnObj.Err(-3,"","清除重点关注分类数据失败")
	i RtnObj.success<0 tro  q RtnObj.Json()
	
	//代码 描述
	k ClinicData
	s ClinicData($i(ClinicData))=$lb("C0000001","单/多部件金属固定器械及附件")		
	s ClinicData($i(ClinicData))=$lb("C0000002","导丝")
	s ClinicData($i(ClinicData))=$lb("C0000003","耳内假体")
	s ClinicData($i(ClinicData))=$lb("C0000004","颌面部赝复及修复重建材料及制品")
	s ClinicData($i(ClinicData))=$lb("C0000005","脊柱椎体间固定/置换系统")
	s ClinicData($i(ClinicData))=$lb("C0000006","可吸收外科止血材料")
	s ClinicData($i(ClinicData))=$lb("C0000007","髋关节假体")
	s ClinicData($i(ClinicData))=$lb("C0000008","颅骨矫形器械")
	s ClinicData($i(ClinicData))=$lb("C0000009","刨骨器")
	s ClinicData($i(ClinicData))=$lb("C00000010","球囊扩张导管")
	s ClinicData($i(ClinicData))=$lb("C00000011","托槽")
	s ClinicData($i(ClinicData))=$lb("C00000012","吻合器(带钉)")
	s ClinicData($i(ClinicData))=$lb("C00000013","血管支架")
	s ClinicData($i(ClinicData))=$lb("C00000014","阴茎假体")
	s ClinicData($i(ClinicData))=$lb("C00000015","植入式神经刺激器")
	s ClinicData($i(ClinicData))=$lb("C00000016","植入式心率转复除颤器")
	s ClinicData($i(ClinicData))=$lb("C00000017","植入式药物输注设备")
	s ClinicData($i(ClinicData))=$lb("C00000018","椎体成形导引系统")
	s HospStr=##class(web.DHCSTMHUI.MatForBDPData).GetDefHospStr("DHC_MatCatClinical")
	s i=0
	f  s i=$o(ClinicData(i)) q:(i="")||(RtnObj.success'=0)  d
	.s data=ClinicData(i)
	.s Code=$list(data,1)
	.s Desc=$list(data,2)
	.i HospStr="" d
	..&sql(Insert into DHC_MatCatClinical(MCC_Code, MCC_Desc)
		values (:Code,:Desc))
	..i SQLCODE'=0 d RtnObj.Err(-3,"","重新生成重点关注分类失败")
	.e  d
	..s HospLen=$l(HospStr,"^")
	..f j=1:1:HospLen q:(RtnObj.success'=0)  d
	...s HospId=$p(HospStr,"^",j)
	...&sql(Insert into DHC_MatCatClinical(MCC_Code, MCC_Desc)
		values (:Code,:Desc))
	...i SQLCODE'=0 d RtnObj.Err(-3,"","重新生成重点关注分类失败")
	...s RowId=%ROWID
	...s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("DHC_MatCatClinical",RowId,HospId)
	...i ret'=0 d RtnObj.Err(-5,"","关联院区失败")
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

}
