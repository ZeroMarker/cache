Import sqluser

/// 科室分类组处理
/// 2017-8-11
Class web.DHCSTMHUI.LocClaGrp Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

/// 插入或更新数据
/// Author:zhangxiao
/// Date:2017-08-11
/// Table:
/// Argu:数据串:rowid^代码^描述
///  
/// Return:
///    rowid
/// w ##class(web.DHCSTMHUI.LocClaGrp).Save(
ClassMethod Save(Loc As %String, Params As %String) As %Library.String
{
	n (Loc,Params,%session)
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
		s Code=Obj.%Get("GrpCode")
		s Description=Obj.%Get("GrpDesc")
	 	i (Code="")||(Description="") s Sc=RtnObj.Err(-2,"","必填项不能为空!","",0)
 		q:RtnObj.success'=0
		s TmpId=..CheckCode(Code,Loc)
		i (TmpId'="")&&(TmpId'=RowId) s Sc=RtnObj.Err(-3,"",Description_"代码重复!","",0)
		q:RtnObj.success'=0
		s Tmpid=..CheckDesc(Description,Loc)
	 	i (TmpId'="")&&(TmpId'=RowId) s Sc=RtnObj.Err(-4,"",Description_"名称重复!","",0)
	 	q:RtnObj.success'=0
		i RowId'=""  d
		.s RtnObj=..Update(RowId,Code,Description,Loc)
		e  d
		.s RtnObj=..Insert(Code,Description,Loc)
		q:RtnObj.success'=0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// Descript:   增加
/// Creater:    zhangxiao
/// CreateDate: 2017-8-10
/// Table:DHC_LocClaGrp
/// Input:
/// Output:     
/// Return：rowid
ClassMethod Insert(code As %String, desc As %String, loc As %String) As %Library.String [ Private ]
{
	n (code,desc,loc,%session)
	s RtnObj=##class(RtnObj).%New()
	&sql(Insert into DHC_LocClaGrp (LCG_Code,LCG_Desc,LCG_CTLOC_DR) values (:code,:desc,:loc))
	i SQLCODE'=0 d
 	.s sc=RtnObj.Err(-11,"",$ClassName()_".Insert:SQLCODE"_SQLCODE_":"_$g(%msg))
 	e  d
    .s RtnObj=##class(Log).SaveLog("DHC_LocClaGrp","User.DHCLocClaGrp","科室内分组信息",$SYSTEM.SQL.GetROWID(),desc,"A")
	q RtnObj
}

/// Descript:   更新
/// Creater:    zhangxiao
/// CreateDate: 2017-8-10
/// TableDHC_LocClaGrp
/// Input:
/// Output:     
/// Return：
ClassMethod Update(rowid As %String, code As %String, desc As %String, loc As %String) As %Library.String [ Private ]
{
	n (rowid,code,desc,loc,%session)
	s RtnObj=##class(RtnObj).%New()
	s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_LocClaGrp",rowid)
	&sql(Update DHC_LocClaGrp set LCG_Code=:code,LCG_Desc=:desc,LCG_CTLOC_DR=:loc where LCG_Rowid=:rowid)
	i SQLCODE'=0 d
 	.s sc=RtnObj.Err(-22,"",$ClassName()_".Update:SQLCODE"_SQLCODE_":"_$g(%msg))
 	e  d
    .s RtnObj=##class(Log).SaveLog("DHC_LocClaGrp","User.DHCLocClaGrp","科室内分组信息",rowid,desc,"U","",OldJsonStr)
	q RtnObj
}

/// Descript:   查询科室分组信息
/// Creater:     zhangxiao
/// CreateDate: 2017-8-11
/// Table:DHC_LocClaGrp
/// Input:
/// Output:     
/// Return：
Query Query(Loc As %String) As Query(ROWSPEC = "RowId,GrpCode,GrpDesc") [ SqlProc ]
{
}

ClassMethod QueryExecute(ByRef qHandle As %Binary, Loc As %String) As %Status
{
	n (qHandle,Loc)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Loc="" $$$OK
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	s type=..sssCode()
	s sqlStr="select LCG_Rowid as GrpId, LCG_Code as GrpCode,LCG_Desc as GrpDesc from DHC_LocClaGrp where LCG_CTLOC_DR="_Loc
	d result.Prepare(sqlStr)
 	d result.Execute()
	While(result.Next())
	{
		 s GrpId=result.Data("GrpId")
		 CONTINUE:+GrpId=0
	 	 s GrpCode=result.Data("GrpCode")
	 	 s GrpDesc=result.Data("GrpDesc")
	 	 
		 d OutPutRow4
       }
 	d result.Close()
	Quit $$$OK
OutPutRow4
	s Data=$lb(GrpId,GrpCode,GrpDesc)   
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

///  Descript:   删除科室分组信息
/// Creater:     zhangxiao
/// CreateDate: 2017-8-11
/// Table:DHC_LocClaGrp
/// Input:rowid
/// Output:     
/// Return：0 – 成功，非0 ：失败
ClassMethod Delete(Params) As %String
{
	n (Params)
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
		&sql(Delete from DHC_LocClaGrp where LCG_Rowid=:RowId)
		i SQLCODE<0 d
		.s Sc=RtnObj.Err(-2,"","删除失败!")
		q:RtnObj.success'=0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// Descript:   查询科室分组对应明细信息
/// Creater:     zhangxiao
/// CreateDate: 2017-8-14
/// Table:DHC_LocClaGrp,DHC_LocCLaGrpInci
/// Input:
/// Output:     
/// Return：
Query QueryChoose(Parref As %String) As Query(ROWSPEC = "RowId,InciCode,InciDesc,Spec") [ SqlProc ]
{
}

ClassMethod QueryChooseExecute(ByRef qHandle As %Binary, Parref As %String) As %Status
{
	n (qHandle,Parref)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Parref="" $$$OK
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	s type=..sssCode()
	s sqlStr="select LCGI_RowId as LcGiId,LCGI_Inci_DR as Incidr ,LCGI_Inci_DR->INCI_Code as INCICode,LCGI_Inci_DR->INCI_Desc as INCIDesc from DHC_LocCLaGrpInci where LCGI_Parref="_Parref
	d result.Prepare(sqlStr)
 	d result.Execute()
	While(result.Next())
	{
		s RowId=result.Data("LcGiId")
		CONTINUE:+RowId=0
		s Inci=result.Data("Incidr")
		s InciCode=result.Data("INCICode")
		s InciDesc=result.Data("INCIDesc")
		s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",Inci)  
		d OutPutRow1
	}
	d result.Close()
	Quit $$$OK
OutPutRow1
	s Data=$lb(RowId,InciCode,InciDesc,Spec)   
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:   查询科室未分组的物资信息
/// Creater:     zhangxiao
/// CreateDate: 2017-8-14
/// Table:DHC_LocClaGrp,DHC_LocCLaGrpInci,inc_itm
/// Input:
/// Output:     
/// Return：
/// w ##class(web.DHCSTMHUI.LocClaGrp).QueryNotChoose(153,0,9999)
Query QueryNotChoose(Loc As %String, Params As %String = "") As Query(ROWSPEC = "RowId,InCode,InDesc,InSpec") [ SqlProc ]
{
}

ClassMethod QueryNotChooseExecute(ByRef qHandle As %Binary, Loc As %String, Params As %String = "") As %Status
{
	n (qHandle,Loc,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s PDescription=PJobj.%Get("Description")
	q:Loc="" $$$OK
	s type=..sssCode()
	s pHospId=..sssHospId(Loc)
	s ScgStr=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr("",type,Loc,"",pHospId)
	q:ScgStr="" ""
	s IncscStr=$$GetIncscStr(ScgStr)
	s sqlStr ="select distinct inca_inci_dr from inc_alias "
		_" where inca_inci_dr->inci_incsc_dr in ("_IncscStr_")"
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(sqlStr)
	s sc=result.Execute()
	If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) q $$$OK
	While(result.Next())
	{
		s RowId = result.Data("INCA_INCI_DR")
		s NotUseFlag=$P(^INCI(RowId,2),"^",9)
		CONTINUE:NotUseFlag="Y" ;过滤停用
		s ret=..CheckInc(RowId,Loc)
		CONTINUE:ret=0
		s InCode=$P(^INCI(RowId,1),"^",1)
		s InDesc=$P(^INCI(RowId,1),"^",2)
		&sql(select INCA_TEXT into :TEXT from inc_alias  where INCA_INCI_DR=:RowId)
		continue:(PDescription'="")&&($$ALPHAUP^SSUTIL4(InDesc)'[$$ALPHAUP^SSUTIL4(PDescription)&&($$ALPHAUP^SSUTIL4(TEXT)'[$$ALPHAUP^SSUTIL4(PDescription)))
		S InSpec=##Class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",RowId)
		 d OutPutRow
       }
 	d result.Close()
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,InCode,InDesc,InSpec)   
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
	
GetIncscStr(ScgStr)
	n (ScgStr)
	q:ScgStr="" ""
	s IncscStr=""
	s ScgLen=$l(ScgStr,"^")
	f i=1:1:ScgLen d
	.s Scg=$p(ScgStr,"^",i)
	.s ch=""
	.f  s ch=$o(^DHCSCG(Scg,"RE",ch)) q:ch=""  d
	..s Incsc=$p(^DHCSCG(Scg,"RE",ch),"^",1)
	..i IncscStr="" s IncscStr=Incsc
	..e  s IncscStr=IncscStr_","_Incsc
	q IncscStr
}

/// 验证某物资是否在此科室中分组
/// Author:zhangxiao
/// Date:2017-8-14
/// Argu:
/// 	inci - 库存id
/// 	loc - 科室rowid
/// Return:
///  0 -存在
///  <0,>0 - 不存在
/// w ##class(web.DHCSTMHUI.LocClaGrp).CheckInc(2,153)
ClassMethod CheckInc(inci As %String, loc As %String) As %String
{
  n (inci,loc)
  s rowid=""
  &sql(select LCGI_RowId into :rowid from DHC_LocCLaGrpInci  where LCGI_Inci_DR=:inci and LCGI_Parref->LCG_CTLOC_DR=:loc)
  q SQLCODE
}

/// 插入分组明细
/// Author:zhangxiao
/// Date:2017-8-14
/// Argu:
/// 	inci - 库存id
/// 	loc - 科室rowid
/// Return:
///  0 -存在
///  <0,>0 - 不存在
/// w ##class(web.DHCSTMHUI.LocClaGrp).AddGrpInci(7,2)
ClassMethod AddGrpInci(grpid As %String, inci As %String) As %String
{
  n (grpid,inci)
  s RtnObj=##class(RtnObj).%New()
  s obj=##class(User.DHCLocClaGrpInci).%New()
  d obj.LCGIParrefSetObjectId(grpid)
  s ch=$O(^DHCLCG(grpid,"I",""),-1)+1
  s obj.LCGIChildSub=ch
  d obj.LCGIInciDRSetObjectId(inci)
  s sc=obj.%Save()
  i $$$ISERR(sc) d RtnObj.Err(-2,"","保存失败!")
  q RtnObj.Json()
}

///  Descript:   删除科室分组信息
/// Creater:     zhangxiao
/// CreateDate: 2017-8-11
/// Table:DHC_LocClaGrp
/// Input:rowid
/// Output:     
/// Return：0 – 成功，非0 ：失败
ClassMethod DeleteGrpInci(rowid As %String) As %Library.String
{
	n (rowid,%session)
	s RtnObj=##class(RtnObj).%New()
	i rowid=""  d
	.s Sc=RtnObj.Err(-1,"","入参错误!")
	q:RtnObj.success'=0 RtnObj.Json()
 	s JsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_LocCLaGrpInci",rowid)
 	&sql(Delete from DHC_LocCLaGrpInci where LCGI_RowId=:rowid)
	i SQLCODE'=0 d
 	.s sc=RtnObj.Err(-22,"",$ClassName()_".Delete:SQLCODE"_SQLCODE_":"_$g(%msg))
 	e  d
    .d ##class(Log).SaveLog("DHC_LocCLaGrpInci","User.DHCLocClaGrpInci","科室内分组信息",rowid,,"D","",JsonStr)
	q RtnObj.Json()
}

/// 代码重复检查
/// Author:zhangxiao
/// Date:2017-09-04
/// Table:
/// Argu:数据串:代码,科室id
///  
/// Return:
///    rowid
/// w ##class(web.DHCSTMHUI.LocClaGrp).CheckCode(1,153)
ClassMethod CheckCode(code As %String, loc As %String) As %Library.String
{
	n (code,loc)
	s rowid=""
	&sql(select LCG_Rowid into :rowid from DHC_LocClaGrp where LCG_Code=:code and LCG_CTLOC_DR=:loc)
	q rowid
}

/// 名称重复检查
/// Author:zhangxiao
/// Date:2017-09-04
/// Table:
/// Argu:数据串:名称,科室id
///  
/// Return:
///    rowid
/// w ##class(web.DHCSTMHUI.LocClaGrp).CheckDesc(2,153)
ClassMethod CheckDesc(desc As %String, loc As %String) As %Library.String
{
	n (desc,loc)
	s rowid=""
	&sql(select LCG_Rowid into :rowid from DHC_LocClaGrp where LCG_Desc=:desc and LCG_CTLOC_DR=:loc)
	q rowid
}

}
