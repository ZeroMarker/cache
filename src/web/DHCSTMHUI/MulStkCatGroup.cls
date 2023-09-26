Import sqluser

/// Descript:	多级类组维护(以及库存分类关联等)
/// Creator:	wangjiabin
/// CreateDate: 2015-02-18
Class web.DHCSTMHUI.MulStkCatGroup Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Description:新建类组或库存分类
/// Creator:	wangjiabin
/// CreateDate:	2016-02-19
/// Table:		DHC_StkCatGrpRelations等
/// Input:		Strparam(类型(INCSC:库存分类,SCG:类组)^代码^名称^上层类组rowid)
/// Output:		
/// Return:		"":成功, '="":失败信息
ClassMethod Add(StrParam, Params) As %String
{
	n (StrParam,Params,%session)
	s NewType=$p(StrParam,"^",1)
	s NewCode=$p(StrParam,"^",2)
	s NewDesc=$p(StrParam,"^",3)
	s ParentId=$p(StrParam,"^",4)
	s StkType=$p(StrParam,"^",5)
	q:NewType="" "信息有误!"
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	q:PJObj.%FromJSON(Params)'=0 RtnObj.Err(-1111,"","入参解析失败!").Json()
	
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s gHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
	s:StkType="" StkType=..sssCode()
	s ret=""
	s $ZT=..sssError()
	ts
	i NewType="INCSC" d
	.s ret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("CODE",NewCode,"INC_StkCat",gHospId,"")
	.i ret>0 s ret=NewCode_" 代码重复!"
	.q:ret'=""
	.s ret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("DESC",NewDesc,"INC_StkCat",gHospId,"")
	.i ret>0 s ret=NewDesc_" 名称重复!"
	.q:ret'=""
	.s:ParentId="" ret="信息有误!"
	.s ChildScg=$o(^DHCSCG(0,"Parent",ParentId,0))
	.s:ChildScg'="" ret="该类组不是底层类组,不可新增库存分类!"
	.q:ret'=""
	.&sql(Insert into INC_StkCat (INCSC_Code,INCSC_Desc,INCSC_StkType) values (:NewCode,:NewDesc,:StkType))
	.i SQLCODE s ret="保存失败!"
	.q:ret'=""
	.s Incsc=$p(%ROWID,$c(1))
	.s ch=1+$o(^DHCSCG(ParentId,"RE",""),-1)
	.&sql(Insert into DHC_StkCatGrpRelations(SCGR_SCG_Parref,SCGR_StkCat_DR,SCGR_Childsub)
		values(:ParentId,:Incsc,:ch))
	.i SQLCODE s ret="保存失败!"
	.q:ret'=""
	.//保存医院关联
	.s result=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("INC_StkCat",Incsc,gHospId)
	.i result<0 s ret="关联医院失败"
	.q:ret'=""
	.d ##class(web.DHCSTMHUI.ServiceForECS).updateHosCat(Incsc,gHospId)
	e  d
	.i (ParentId'="")&&($d(^DHCSCG(ParentId,"RE"))=11) s ret="该类组是底层类组,不可新增子类!"
	.q:ret'=""
	.;新建类组
	.s ret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("CODE",NewCode,"DHC_StkCatGroup",gHospId,"")
	.i ret>0 s ret=NewCode_" 代码重复!"
	.q:ret'=""
	.s ret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("DESC",NewDesc,"DHC_StkCatGroup",gHospId,"")
	.i ret>0 s ret=NewDesc_" 名称重复!"
	.q:ret'=""
	.&sql(Insert into DHC_StkCatGroup(SCG_Code,SCG_Desc,SCG_Type,SCG_CATGRP_DR)
		values (:NewCode,:NewDesc,:StkType,:ParentId))
	.i SQLCODE s ret="保存失败!"
	.q:ret'=""
	.s RowId=%ROWID
	.s result=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("DHC_StkCatGroup",RowId,gHospId)
	.i result<0 s ret="关联医院失败"
	.q:ret'=""
	
	i ret'="" tro  q ret
	tc
	q ""
}

/// Description:修改库存分类信息
/// CreateDate:	2016-03-23
/// Input:		RowId
/// Output:		
/// Return:		代码^名称^...
ClassMethod GetStkCatInfo(RowId) As %String
{
	n (RowId)
	q:RowId="" ""
	q:'$d(^INC("SC",RowId)) ""
	s Code=$p(^INC("SC",RowId),"^",1)
	s Desc=$p(^INC("SC",RowId),"^",2)
	s StkType=$p(^INC("SC",RowId),"^",3)
	s result=Code_"^"_Desc_"^"_StkType
	q result
}

/// Description:修改类组信息
/// CreateDate:	2016-03-23
/// Input:		RowId
/// Output:		
/// Return:		代码^名称^...
ClassMethod GetStkGrpInfo(RowId) As %String
{
	n (RowId)
	q:RowId="" ""
	q:'$d(^DHCSCG(RowId)) ""
	s Code=$p(^DHCSCG(RowId),"^",1)
	s Desc=$p(^DHCSCG(RowId),"^",2)
	s StkType=$p(^DHCSCG(RowId),"^",3)
	s ScgSet=$p(^DHCSCG(RowId),"^",5)
	s SpReq=$p(^DHCSCG(RowId),"^",6)
	s result=Code_"^"_Desc_"^"_StkType_"^"_ScgSet_"^"_SpReq
	q result
}

/// Description:修改库存分类
/// CreateDate:	2016-03-23
/// Input:		StrParam(rowid^代码^名称)
/// Output:		
/// Return:		"":成功, '="":失败信息
ClassMethod UpdateStkCat(StrParam As %String, Params) As %Library.String
{
	n (StrParam,Params,%session)
	s rowid=$p(StrParam,"^",1)
	s code=$p(StrParam,"^",2)
	s desc=$p(StrParam,"^",3)
	q:rowid="" "信息有误!"
	q:code="" "信息有误!"
	q:desc="" "信息有误!"
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	q:PJObj.%FromJSON(Params)'=0 "入参解析失败！"
	
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s gHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
	&sql(select * from INC_StkCat where (INCSC_Code=:code or INCSC_Desc=:desc) and %id<>:rowid)
	q:SQLCODE=0 "信息重复!"
	s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("INC_StkCat",rowid)
	&sql(Update INC_StkCat set INCSC_Code=:code,INCSC_Desc=:desc where INCSC_RowId=:rowid)
	q:SQLCODE'=0 "更新失败!"
	d ##class(Log).SaveLog("INC_StkCat","User.INCStkCat","库存分类信息",rowid,desc,"U","",OldJsonStr)
	d ##class(web.DHCSTMHUI.ServiceForECS).updateHosCat(rowid,gHospId)
	
	q ""
}

/// Description:修改类组信息
/// CreateDate:	2016-03-23
/// Input:		StrParam(rowid^代码^名称^类组集合^售价必填)
/// Output:		
/// Return:		"":成功, '="":失败信息
ClassMethod UpdateStkGrp(StrParam As %String, Params As %String) As %Library.String
{
	n (StrParam,Params,%session)
	s rowid=$p(StrParam,"^",1)
	s code=$p(StrParam,"^",2)
	s desc=$p(StrParam,"^",3)
	s scgSet=$p(StrParam,"^",4)
	;s spReq=$p(StrParam,"^",5)
	q:rowid="" "信息有误!"
	q:code="" "信息有误!"
	q:desc="" "信息有误!"
	
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s gHospId=PJobj.%Get("gHospId")
	s pHospId=PJobj.%Get("BDPHospital")
	s gHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
	s ret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("CODE",code,"DHC_StkCatGroup",gHospId,rowid)
	q:ret>0 code_" 代码重复!"
	s ret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("DESC",desc,"DHC_StkCatGroup",gHospId,rowid)
	q:ret>0 desc_"名称重复!"
	
	s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_StkCatGroup",rowid)
	s $ZT=..sssError()
	&sql(Update DHC_StkCatGroup set SCG_Code=:code,SCG_Desc=:desc,SCG_Set=:scgSet
		where SCG_Rowid=:rowid)
	q:SQLCODE'=0 "更新失败!"
	d ##class(Log).SaveLog("INC_StkCat","User.INCStkCat","库存分类信息",rowid,desc,"U","",OldJsonStr)
	q ""
}

/// Description:获取未关联类组的库存分类
/// Creator:	wangjiabin
/// Table:		INC_StkCat,DHC_StkCatGrpRelations
/// Input:		Type(M:物资类组,O:物资财务类组)
/// Output:		json串
ClassMethod NoRelationCat(Type, Params)
{
	n (Type,Params,%session)
	s count=0
	s json=##class(web.DHCSTMHUI.Common.JsonObj).%New()
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	q:PJObj.%FromJSON(Params)'=0 $$$OK
	
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s gHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
	s StkCatId=0
	f  s StkCatId=$o(^INC("SC",StkCatId)) q:StkCatId=""  d
	.s StkType=$p(^INC("SC",StkCatId),"^",3)
	.q:StkType'=..sssCode()
	.//判断医院权限
	.s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("INC_StkCat",StkCatId,gHospId)
	.q:ShowDataFlag="N"
	.s StkGrpId=0,Flag=0
	.f  s StkGrpId=$o(^DHCSCG("STKCAT",StkCatId,StkGrpId)) q:(StkGrpId="")||(Flag=1)  d
	..s ScgType=$p(^DHCSCG(StkGrpId),"^",3)
	..q:ScgType'=Type		;默认没归属类组
	..s Chl=$o(^DHCSCG("STKCAT",StkCatId,StkGrpId,""))
	..q:Chl=""
	..i $d(^DHCSCG(StkGrpId,"RE",Chl)) s Flag=1 q	;存在归属类组
	.q:Flag=1			;维护了类组
	.
	.s StkCatCode=$p(^INC("SC",StkCatId),"^",1)
	.s StkCatDesc=$p(^INC("SC",StkCatId),"^",2)
	.s DataStr=StkCatId_"^"_StkCatCode_"^"_StkCatDesc
	.s count=count+1
	.d json.InsertRowData(DataStr)
	.
	d json.getJsonData("RowId^Code^Description",count)
	k json
	q ""
}

/// Description:将类组和库存分类进行关联
/// Creator:	wangjiabin
/// CreateDate:	2016-02-18
/// Table:		DHC_StkCatGrpRelations
/// Input:		类组id, 库存分类Str(^隔开)
/// Output:		
/// Return:		"":成功, '="":失败信息
/// w ##class(web.DHCSTMHUI.MulStkCatGroup).ScgRelaIncsc()
ClassMethod ScgRelaIncsc(Scg, IncscStr) As %String
{
	n (Scg,IncscStr)
	q:Scg="" "参数错误!"
	q:IncscStr="" ""
	
	s ret=""
	ts
	s IncscLen=$l(IncscStr,"^")
	f i=1:1:IncscLen q:ret'=""  d
	.s Incsc=$p(IncscStr,"^",i)
	.q:Incsc=""
	.&sql(select * from DHC_StkCatGrpRelations where SCGR_SCG_Parref=:Scg and SCGR_StkCat_DR=:Incsc)
	.q:SQLCODE=0
	.
	.&sql(delete from DHC_StkCatGrpRelations where SCGR_StkCat_DR=:Incsc)
	.i SQLCODE<0 s ret="删除原有关联失败!" q
	.s ch=1+$o(^DHCSCG(Scg,"RE",""),-1)
	.&sql(Insert into DHC_StkCatGrpRelations(SCGR_SCG_Parref,SCGR_StkCat_DR,SCGR_Childsub)
		values(:Scg,:Incsc,:ch))
	.i SQLCODE s ret="保存失败!" q
	i ret'="" tro  q ret
	tc
	
	q ""
}

/// Description:将类组和库存分类进行关联
/// Creator:	wangjiabin
/// CreateDate:	2016-02-18
/// Table:		DHC_StkCatGrpRelations
/// Input:		类组id, 库存分类id
/// Output:		
/// Return:		"":成功, '="":失败信息
ClassMethod UpdateParScg(ParScg, Scg) As %String
{
	n (ParScg,Scg)
	q:Scg="" -1
	
	&sql(update DHC_StkCatGroup set SCG_CATGRP_DR=:ParScg where SCG_Rowid=:Scg)
	q:SQLCODE "修改失败!"
	q ""
}

/// Descript:	删除类组和库存分类关联
/// Creator:	wangjiabin
/// CreateDate:	2018-08-03
/// Table:		DHC_StkCatGrpRelations
/// Input:		库存分类rowid
/// Output:		
/// Return:		RtnObj.Json()
/// w ##class(web.DHCSTMHUI.MulStkCatGroup).DeleteRelation(14)
ClassMethod DeleteRelation(IncscId As %String, StkType = "M") As %Library.String
{
	n (IncscId,StkType,%session)
	s RtnObj=##class(RtnObj).%New()
	q:IncscId="" ""
	s (StkGrpId,StkGrpDesc,ScgrId)=""
	&sql(SELECT SCGR_SCG_Parref,SCGR_RowId
		into :StkGrpId,:ScgrId
		FROM DHC_StkCatGrpRelations
		WHERE SCGR_StkCat_DR=:IncscId and SCGR_SCG_Parref->Scg_Type=:StkType
	)
	q:ScgrId="" ""
	s:StkGrpId'="" StkGrpDesc=$p(^DHCSCG(StkGrpId),"^",2)
	s StkCatDesc=$p(^INC("SC",IncscId),"^",2) 	
	s JsonStr="{类组:"_StkGrpDesc_",库存分类"_StkCatDesc_"}"
	
	&sql(Delete from DHC_StkCatGrpRelations where SCGR_Rowid=:ScgrId)
	i SQLCODE'=0 d
	.d RtnObj.Err(-1,ScgrId,$ClassName()_".DeleteRelation:SQLCODE"_SQLCODE_":"_$g(%msg))
	q:RtnObj.success<0 RtnObj.Json()
	
	d ##class(Log).SaveLog("DHC_StkCatGrpRelations","User.DHCStkCatGrpRelations","类组分类对应信息",ScgrId,StkGrpDesc,"D",JsonStr)
	q RtnObj.Json()
}

/// Description:类组授权信息记录
/// Creator:	wangjiabin
/// CreateDate:	2016-02-22
/// Table:		
/// Input:		ScgStr(Scg,Scg,...), 科室id
/// Output:		
/// Return:		"":授权成功, 非空:授权失败
/// 2016-03-14 根据类组授权
/// w ##class(web.DHCSTMHUI.MulStkCatGroup).SaveAuthorData(ScgStr, AuthorPar)
ClassMethod SaveAuthorData(ScgStr, AuthorPar) As %String
{
	n (ScgStr,AuthorPar)
	s AuthorObj=$p(AuthorPar,"^",1)		;授权科室
	s StkType=..sssCode()
	
	s ret=""
	ts
	;1.先将已授权但不在ScgStr里的删除(可以考虑添加Active字段)
	i ScgStr'="" d
	.s delSql="delete from sqluser.DHC_StkLocCatGroup where SLCG_CTLoc_Dr="_AuthorObj_" and SLCG_StkCatGrp_Dr not in ("_ScgStr_") and SLCG_Type='"_StkType_"'"
	e  d
	.s delSql="delete from sqluser.DHC_StkLocCatGroup where SLCG_CTLoc_Dr="_AuthorObj_" and SLCG_Type='"_StkType_"'"
	s tStatement=##class(%SQL.Statement).%New()
	s tStatus=tStatement.%Prepare(delSql)
	s rset=tStatement.%Execute()
	i rset.%SQLCODE<0 s ret="授权失败!" tro  q ret
	i ScgStr="" tc  q ret
	;2.再激活(或新增)需授权的部分
	s ScgLen=$l(ScgStr,",")
	f i=1:1:ScgLen q:ret'=""  d
	.s Scg=$p(ScgStr,",",i)
	.&sql(select * from DHC_StkLocCatGroup 
		where SLCG_CTLoc_Dr=:AuthorObj and SLCG_StkCatGrp_Dr=:Scg and SLCG_Type=:StkType)
	.i SQLCODE=100 d
	..&sql(insert into DHC_StkLocCatGroup (SLCG_CTLoc_Dr,SLCG_StkCatGrp_Dr,SLCG_Type,SLCG_Default,SLCG_StkMonFlag)
		values (:AuthorObj,:Scg,:StkType,'N','Y'))
	.i SQLCODE s ret="授权失败!"
	.q:ret'=""
	i ret'="" tro  q ret
	tc
	
	q ""
}

/// Description:用户授权信息记录(记录库存分类)
/// Creator:	wangjiabin
/// CreateDate:	2016-02-23
/// Table:		
/// Input:		ScgStr(Scg,Scg,...), 授权参数(授权类型^授权对象rowid)
/// Output:		
/// Return:		"":授权成功, 非空:授权失败
/// w ##class(web.DHCSTMHUI.MulStkCatGroup).SaveUserAuthorData("undefined,1,2","213^12378")
ClassMethod SaveUserAuthorData(ScgStr, AuthorPar) As %String
{
	n (ScgStr,AuthorPar)
	s LocId=$p(AuthorPar,"^",1)
	s UserId=$p(AuthorPar,"^",2)
	q:LocId="" "参数错误!"
	q:UserId="" "参数错误"
	
	s StkType=..sssCode()
	
	s ret=""
	s ScgLen=$l(ScgStr,",")
	s DefaultScg=""
	s DefaultScgInfo=..GetDefaScg(AuthorPar)
	s Defaultid=$p(DefaultScgInfo,"^",1)
	s:+Defaultid>0 DefaultScg=$p($g(^DHCSLCG(+Defaultid)),"^",2)
	ts
	;1.先另该科室的所有权限失效
	&sql(update DHC_StkLocUserCatGrp set U_Active='N',U_Default='N'
		where U_SLCG_Parref->SLCG_CTLoc_Dr=:LocId and U_SLCG_Parref->SLCG_Type=:StkType and U_SSUSR_DR=:UserId)
	i SQLCODE<0 s ret="授权失败!"
	i ret'="" tro  q ret
	;2.再激活(或新增)需授权的部分
	f i=1:1:ScgLen q:ret'=""  d
	.s Scg=$p(ScgStr,",",i)
	.
	.s SLCGId=""
	.&sql(select %id into :SLCGId from DHC_StkLocCatGroup
		where SLCG_CTLoc_Dr=:LocId and SLCG_StkCatGrp_Dr=:Scg and SLCG_Type=:StkType)
	.q:SLCGId=""
	.i (DefaultScg'="")&&(DefaultScg=Scg) d
	..&sql(update DHC_StkLocUserCatGrp set U_Active='Y',U_Default='Y'
		where U_SLCG_Parref=:SLCGId and U_SSUSR_DR=:UserId)
	.e  d
	..&sql(update DHC_StkLocUserCatGrp set U_Active='Y'
		where U_SLCG_Parref=:SLCGId and U_SSUSR_DR=:UserId)
	.i SQLCODE=100 d
	..s ch=1+$o(^DHCSLCG(SLCGId,"I",""),-1)
	..&sql(insert into DHC_StkLocUserCatGrp (U_SLCG_Parref,U_ChildSub,U_SSUSR_DR,U_Active,U_Default)
		values (:SLCGId,:ch,:UserId,'Y','N'))
	.i SQLCODE s ret="授权失败!"
	.q:ret'=""
	i ret'="" tro  q ret
	tc
	
	q ""
}

/// Description:获取权限信息(类组串,逗号隔开),有授权的底层类组+其上面上级类组
/// Creator:	wangjiabin
/// CreateDate:	2016-02-22
/// Table:		
/// Input:		StrParam(科室id^人员id)
/// Output:		
/// Return:		有权限的类组串(逗号隔开)
/// w ##class(web.DHCSTMHUI.MulStkCatGroup).GetAuthorScg(1)
ClassMethod GetAuthorScg(StrParam As %String) As %String
{
	n (StrParam)
	s LocId=$p(StrParam,"^",1)
	s UserId=$p(StrParam,"^",2)
	
	s ScgStr=""
	s Param=LocId_"^"
	s ScgStr=..GetAuthorLeafScg(Param)
	s ScgStr=$tr(ScgStr,"^",",")
	q:ScgStr="" ""
	
	s ScgLen=$l(ScgStr,",")
	f i=1:1:ScgLen  d
	.s Scg=$p(ScgStr,",",i)
	.
	.f  s TmpScg=Scg,Scg=$p($g(^DHCSCG(Scg)),"^",4) q:(Scg="")!(Scg=TmpScg)  d
	..s ScgType=$p(^DHCSCG(Scg),"^",3)
	..q:ScgType'=..sssCode()
	..i ((","_ScgStr_",")'[(","_Scg_",")) d
	...s ScgStr=ScgStr_","_Scg
	
	q ScgStr
}

/// Description:获取设置了权限的叶子类组(底层类组)(^隔开),按人员取值或者按科室取值(二选一)
/// 	用于类组授权的回显
/// Creator:	wangjiabin
/// CreateDate:	2016-03-14
/// Table:		
/// Input:		StrParam(科室id^人员id)
/// Output:		
/// Return:		有权限的类组串(^隔开)
/// w ##class(web.DHCSTMHUI.MulStkCatGroup).GetAuthorLeafScg("153^541")
ClassMethod GetAuthorLeafScg(StrParam As %String) As %String
{
	n (StrParam)
	s LocId=$p(StrParam,"^",1)
	s UserId=$p(StrParam,"^",2)
	q:LocId="" ""
	s StkType=..sssCode()
	s result=""
	i UserId'="" d
	.&Sql(declare userScg cursor for 
		select u_slcg_parref->slcg_stkcatgrp_dr From DHC_StkLocUserCatGrp
		where u_ssusr_dr=:UserId and u_slcg_parref->slcg_type=:StkType and u_slcg_parref->SLCG_CTLoc_Dr=:LocId and U_Active='Y')    
	.&sql(open userScg)
	.f  &sql(fetch userScg into :scg) q:SQLCODE  d
	..i result="" s result=+scg
	..e  s result=result_"^"_+scg
	.&sql(close userScg)
	e  d
	.&Sql(declare userScg2 cursor for
		select SLCG_StkCatGrp_Dr From DHC_StkLocCatGroup
		where SLCG_Type=:StkType and SLCG_CTLoc_Dr=:LocId)    
	.&sql(open userScg2)
	.f  &sql(fetch userScg2 into :scg) q:SQLCODE  d
	..i result="" s result=+scg
	..e  s result=result_"^"_+scg
	.&sql(close userScg2)
	q result
}

/// Description:根据科室人员等信息获取缺省类组
/// Creator:	wangjiabin
/// CreateDate:	2016-03-24
/// Table:		
/// Input:		StrParam(科室id^人员id^第二科室id)
/// Output:		类组id^类组desc
/// w ##class(web.DHCSTMHUI.MulStkCatGroup).GetDefaScg("153^541^")
ClassMethod GetDefaScg(StrParam As %String) As %String
{
	n (StrParam)
	s LocId=$p(StrParam,"^",1)
	s UserId=$p(StrParam,"^",2)
	s xLocId=$p(StrParam,"^",3)
	q:LocId="" ""
	s StkType=..sssCode()
	
	s:xLocId'="" xLocScgStr=##class(web.DHCSTMHUI.Util.DrugUtil).GetAuthorOnlyScg(xLocId_"^")
	s result="",UserScgFlag=""
	&sql(declare UserScgCursor cursor for
		select U_SLCG_Parref->SLCG_StkCatGrp_Dr, U_SLCG_Parref->SLCG_StkCatGrp_Dr->Scg_Desc, U_Default
		from DHC_StkLocUserCatGrp where U_SLCG_Parref->SLCG_CTLoc_Dr=:LocId and U_SLCG_Parref->SLCG_Type=:StkType and U_SSUSR_DR=:UserId and U_Active='Y'
		order by U_SLCG_Parref->SLCG_StkCatGrp_Dr->Scg_Desc)
	&sql(open UserScgCursor)
	f  &sql(fetch UserScgCursor into :ScgId,:ScgDesc,:UserDefault) q:SQLCODE||(result'="")  d
	.s UserScgFlag="Y"
	.i UserDefault="Y" d
	..;第二科室有权限,且权限内无此类组时,不取值
	..q:(xLocId'="")&&(xLocScgStr'="")&&((","_xLocScgStr_",")'[(","_ScgId_","))
	..s result=ScgId_"^"_ScgDesc
	&sql(close UserScgCursor)
	
	;若个人有授权,则不进行按科室授权的取值
	q:UserScgFlag="Y" result
	
	&sql(declare LocScgCursor cursor for
		select SLCG_StkCatGrp_Dr,SLCG_StkCatGrp_Dr->Scg_Desc,SLCG_Default
		from DHC_StkLocCatGroup where SLCG_CTLoc_Dr=:LocId and SLCG_Type=:StkType
		order by SLCG_StkCatGrp_Dr->Scg_Desc)
	&sql(open LocScgCursor)
	f  &sql(fetch LocScgCursor into :ScgId,:ScgDesc,:LocDefault) q:SQLCODE||(result'="")  d
	.i LocDefault="Y" d
	..;第二科室有权限,且权限内无此类组时,不取值
	..q:(xLocId'="")&&(xLocScgStr'="")&&((","_xLocScgStr_",")'[(","_ScgId_","))
	..s result=ScgId_"^"_ScgDesc
	&sql(close LocScgCursor)
	
	q result
}

/// Description:设置缺省类组(按科室或者按个人)
/// Creator:	wangjiabin
/// CreateDate:	2016-04-06
/// Table:		
/// Input:		科室id, 类组id
/// Output:		"":成功, 非空:不成功
/// w ##class(web.DHCSTMHUI.MulStkCatGroup).SetLocDefaScg("1","1")
ClassMethod SetLocDefaScg(LocId As %String, ScgId As %String) As %String
{
	n (LocId, ScgId)
	q:LocId="" "参数错误!"
	s StkType=..sssCode()
	s (DefaultFlag,ret)=""
	&sql(select SLCG_Default into :DefaultFlag from DHC_StkLocCatGroup 
		where SLCG_CTLoc_Dr=:LocId and SLCG_Type=:StkType and SLCG_StkCatGrp_Dr=:ScgId)
	q:DefaultFlag="Y" "类组已设置缺省，不能重复设置!"

	ts
	&sql(update DHC_StkLocCatGroup set SLCG_Default='N'
		where SLCG_CTLoc_Dr=:LocId and SLCG_Type=:StkType)
	i SQLCODE'=0 tro  q "更新类组缺省标志失败!"
	i ScgId'="" d
	.&sql(update DHC_StkLocCatGroup set SLCG_Default='Y'
		where SLCG_CTLoc_Dr=:LocId and SLCG_Type=:StkType and SLCG_StkCatGrp_Dr=:ScgId)
	.i SQLCODE'=0 s ret="更新类组缺省标志失败!"
	i ret'="" tro  q ret
	tc
	q ""
}

/// Description:设置缺省类组(按科室或者按个人)
/// Creator:	wangjiabin
/// CreateDate:	2016-04-06
/// Table:		
/// Input:		科室id, 人员id, 类组id
/// Output:		"":成功, 非空:不成功
/// w ##class(web.DHCSTMHUI.MulStkCatGroup).SetLocUserDefaScg("163","6423","1")
ClassMethod SetLocUserDefaScg(LocId As %String, UserId As %String, ScgId As %String) As %String
{
	n (LocId,UserId,ScgId)
	q:LocId="" "参数错误!"
	q:UserId="" "参数错误!"
	s StkType=..sssCode()
	s (DefaultFlag,ret)=""
		
	&sql(select U_Default into :DefaultFlag from DHC_StkLocUserCatGrp 
		where U_SLCG_Parref->SLCG_CTLoc_Dr=:LocId and U_SLCG_Parref->SLCG_Type=:StkType and U_SSUSR_DR=:UserId and U_SLCG_Parref->SLCG_StkCatGrp_Dr=:ScgId)
	q:DefaultFlag="Y" "类组已设置缺省，不能重复设置!" 

	ts
	&sql(update DHC_StkLocUserCatGrp set U_Default='N'
		where U_SLCG_Parref->SLCG_CTLoc_Dr=:LocId and U_SLCG_Parref->SLCG_Type=:StkType and U_SSUSR_DR=:UserId)
	i SQLCODE'=0 tro  q "更新类组缺省标志失败!"

	i ScgId'="" d
	.&sql(update DHC_StkLocUserCatGrp set U_Default='Y'
		where U_SLCG_Parref->SLCG_CTLoc_Dr=:LocId and U_SLCG_Parref->SLCG_StkCatGrp_Dr=:ScgId and U_SSUSR_DR=:UserId)
	.i SQLCODE'=0 s ret="更新类组缺省标志失败!"
	i ret'="" tro  q ret
	tc
	q ""
}

/// Description:获取类组,库存分类信息
/// Creator:	wangjiabin
/// CreateDate:	2018-08-26
/// Table:		
/// Input:		类组rowid(传空表示根节点)
/// Output:		Hisui-tree格式数据
/// ps: ProcedureBlock = 1,请不要去掉
/// d ##class(web.DHCSTMHUI.MulStkCatGroup).GetScg("","{""LocId"":392,""Type"":""M""}")
ClassMethod GetScg(ParScg, Params) [ ProcedureBlock = 1 ]
{
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0
	s Type=PJObj.%Get("Type")
	s:Type="" Type=..sssCode()
	s LocId=PJObj.%Get("LocId")
	i LocId'="" d
	.s ScgStr=..GetAuthorScg(LocId_"^")
	
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s gHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
	i ParScg="" d
	.w "[{""id"":""AllSCG"",""text"":""分类"",""iconCls"":""icon-sum"",""children"":"
	.d ..GetScg("AllSCG",Params)
	.w "}]"
	q:ParScg=""
	
	s result=##class(%Library.ResultSet).%New()
	i ParScg="AllSCG" d
	.s sqlStr="select 'SCG-'||scg_rowid as RowId,scg_code as Code, scg_desc as Description From dhc_stkcatgroup where scg_type='"_Type_"' and SCG_CATGRP_DR is null order by scg_desc"
	e  i $d(^DHCSCG(0,"Parent",ParScg)) d
	.s sqlStr1="select 'SCG-'||scg_rowid as RowId, scg_code as Code, scg_desc as Description From dhc_stkcatgroup where scg_catgrp_dr="_ParScg
	.s sqlStr2="select 'INCSC-'||scgr_stkcat_dr as RowId,scgr_stkcat_dr->incsc_code as Code,scgr_stkcat_dr->incsc_desc as Description From dhc_stkcatgrprelations where scgr_scg_parref="_ParScg
	.s sqlStr=sqlStr1_" union "_sqlStr2_" order by Description"
	e  d
	.s sqlStr="select 'INCSC-'||scgr_stkcat_dr as RowId,scgr_stkcat_dr->incsc_code as Code,scgr_stkcat_dr->incsc_desc as Description From dhc_stkcatgrprelations where scgr_scg_parref="_ParScg
	d result.Prepare(sqlStr)
	d result.Execute()
	s count=0
	s json=##class(web.DHCSTMHUI.Common.JsonObj).%New()
	w "["
	While(result.Next())
	{
		s Id=result.Data("RowId")
		s Token=$p(Id,"-",1)
		s TmpRowId=+$p(Id,"-",2)
		continue:TmpRowId=0
		continue:(Token="SCG")&&('$d(^DHCSCG(TmpRowId)))
		continue:(Token="INCSC")&&('$d(^INC("SC",TmpRowId)))
		//统一改在这里过滤
		continue:(LocId'="")&&(Token="SCG")&&((","_ScgStr_",")'[(","_TmpRowId_","))
		//判断医院权限
		s ShowDataFlag="N"
		i Token="SCG" s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_StkCatGroup",TmpRowId,gHospId)
		i Token="INCSC" s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("INC_StkCat",TmpRowId,gHospId)
		continue:ShowDataFlag="N"
		s Desc=result.Data("Description")
		
		s IconCls=""
		s:Token="SCG" IconCls="icon-add"
		s:Token="INCSC" IconCls="icon-star-yellow"
		s Desc=$zcvt(Desc,"O","JS")
		s count=count+1
		i count=1 w "{"
		e  w ",{"
		w """id"":"""_Id_""",""text"":"""_Desc_""""_",""iconCls"":"""_IconCls_""""
		i (Token="SCG")&&($d(^DHCSCG(0,"Parent",TmpRowId))||$d(^DHCSCG(TmpRowId,"RE"))) d
		.w ",""children"":"
		.d ..GetScg(TmpRowId,Params)
		w "}"
	}
	w "]"
	d result.Close()
}

/// Description:检查本科室权限是否与支配科室相同
/// Creator:	lxt
/// CreateDate:	20200625
/// Table:		
/// Input:		LocId
/// Output:		
/// Return:		0相同  <>0不同
/// w ##class(web.DHCSTMHUI.MulStkCatGroup).CheckMainLocScg(342)
ClassMethod CheckMainLocScg(LocId) As %String
{
	n (LocId)
	s ret=0
	s MainLoc=##class(web.DHCSTMHUI.Common.UtilCommon).MLoc(LocId)
	q:MainLoc="" ret
	
	s LocScgStr=..GetAuthorScg(LocId_"^")
	s MainLocScgStr=..GetAuthorScg(MainLoc_"^")
	
	q:(LocScgStr'=MainLocScgStr) -1
	q ret
}

}
