Import sqluser

/// Descript:	带量采购功能开发
/// CreateDate: 2022-06-08
Class web.DHCSTMHUI.PurchaseInfo Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	保存带量采购信息
/// w ##class(web.DHCSTMHUI.PurchaseInfo).jsSave(^tempxj(1))
ClassMethod jsSave(Main As %String) As %String
{
	n (%session,Main)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..Save(Main)
	q RtnObj.Json()
}

/// Descript:	保存带量采购
/// Input:		
/// Return：	RtnObj
/// w ##class(web.DHCSTMHUI.PurchaseInfo).Save
ClassMethod Save(Main) As RtnObj
{
	n (%session,Main)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	
	s Sc=PJObj.%FromJSON(Main)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!")

	s Inci=PJObj.%Get("Inci")
	s RowId=PJObj.%Get("PurInfoRowId")
	s PurNo=PJObj.%Get("PurNo")
	s PurType=PJObj.%Get("PurType")
	s PurStartDate=PJObj.%Get("PurStartDate")
	s PurEndDate=PJObj.%Get("PurEndDate")
	s PurQty=PJObj.%Get("PurQty")
	s PurDesc=PJObj.%Get("PurDesc")
	
	i PurNo="" q RtnObj.Err(-1,"","带量编号不能为空!","",0)
	s Tempid=$o(^CT.HRP.MAT.PurchaseInfoI("PURNo",PurNo,""))
	i (Tempid'="")&&(RowId'=Tempid) q RtnObj.Err(-1,"","该带量编号已存在!","",0)	
	s PurStartDate=..DH2L(PurStartDate)
	s PurEndDate=..DH2L(PurEndDate)
	i RowId="" d
	.s Obj=##class(CT.HRP.MAT.PurchaseInfo).%New()
	e  d
	.s Obj=##class(CT.HRP.MAT.PurchaseInfo).%OpenId(RowId)
	d Obj.PURTypeSetObjectId(PurType)
	s Obj.PURNo=PurNo
	s Obj.PURStartDate=PurStartDate
	s Obj.PUREndDate=PurEndDate
	s Obj.PURQty=PurQty
	s Obj.PURDesc=PurDesc
	s Sc=Obj.%Save()
	i $$$ISERR(Sc) q RtnObj.Err(-1,"","带量采购信息保存失败!")
	s RowId=Obj.%Id()
	s RtnObj.rowid=RowId
	i Inci'="" d
	.s RtnObj=##class(web.DHCSTMHUI.PurchaseInfo).SaveRelation(Inci,RowId)
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// Descript:	保存带量库存项关联信息
ClassMethod jsSaveRelation(Inci, PURId) As %String
{
	n (%session,Inci,PURId)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..SaveRelation(Inci, PURId)
	q RtnObj.Json()
}

/// Descript:	保存带量采购库存项关联信息
/// Input:		
/// Return：	RtnObj
/// w ##class(web.DHCSTMHUI.PurchaseInfo).SaveRelation(2,2)
ClassMethod SaveRelation(Inci, PURId) As RtnObj
{
	n (%session,Inci,PURId)
	s RtnObj=##class(RtnObj).%New()
	q:PURId="" RtnObj
	i Inci="" q RtnObj.Err(-1,"","带量采购关联入参错误!")
	s RelaRowId=""
	s:PURId'="" RelaRowId=$o(^CT.HRP.MAT.PurInfoRelationI("InciPurDR",Inci,PURId,""),-1)
	s UseRelaRowId=$o(^CT.HRP.MAT.PurInfoRelationI("InciUse",Inci,"Y",""),-1)
	i (UseRelaRowId'="")&&(UseRelaRowId'=RelaRowId) d
	.&sql(update CT_HRP_MAT.PurInfoRelation set PIR_UseFlag='N' where PIR_INCI=:Inci)
	.i SQLCODE'=0 tro  d RtnObj.Err(-6,"","更新带量采购关联信息失败")
	i RelaRowId="" d
	.&sql(insert into CT_HRP_MAT.PurInfoRelation(PIR_INCI,PIR_PUR_DR,PIR_UseFlag) values (:Inci,:PURId,'Y'))
	.i SQLCODE'=0 tro  d RtnObj.Err(-4,"","带量采购信息与物资关联失败")
	e  d
	.&sql(update CT_HRP_MAT.PurInfoRelation set PIR_UseFlag='Y' where ID=:RelaRowId)
	.i SQLCODE'=0 tro  d RtnObj.Err(-6,"","更新带量采购关联信息失败")
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// 获取带量采购信息
/// w ##class(web.DHCSTMHUI.PurchaseInfo).GetData(2)
ClassMethod GetData(InciId, ByRef Title)
{
	n (InciId,Title)
	q:InciId="" ""
	
	s RelaRowId=$o(^CT.HRP.MAT.PurInfoRelationI("InciUse",InciId,"Y",""),-1)
	q:RelaRowId="" ""
	s RowId=$lg(^CT.HRP.MAT.PurInfoRelationD(RelaRowId),3)
	s PurList=^CT.HRP.MAT.PurchaseInfoD(RowId)
	s PurTypeId=$lg(PurList,3)
	s PurNo=$lg(PurList,4)
	s PurStartDate=$lg(PurList,5)
	s PurEndDate=$lg(PurList,6)
	s PurQty=$lg(PurList,7)
	s PurCompletedQty=$lg(PurList,8)
	s PurDesc=$lg(PurList,9)
	s PurTypeDesc="" 
	s:PurTypeId'="" PurTypeDesc=$lg(^CT.HRP.MAT.ComDictValueD(PurTypeId),4)
	s PurNo=..sssComboStr(RowId,PurNo)
	s PurType=..sssComboStr(PurTypeId,PurTypeDesc)
	s PurStartDate=..DL2H(PurStartDate)
	s PurEndDate=..DL2H(PurEndDate)
	
	s Title="PurRowId^PurType^PurNo^PurStartDate^PurEndDate^PurQty^PurCompletedQty^PurDesc"
	s Data=RowId_"^"_PurType_"^"_PurNo_"^"_PurStartDate_"^"_PurEndDate_"^"_PurQty_"^"_PurCompletedQty_"^"_PurDesc
	q Data
}

/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.PurchaseInfo","GetPurInfoHistory",2)
Query GetPurInfoHistory(Inci As %String) As Query(ROWSPEC = "RowId:%Integer,PURId:%Integer,PurNo,PurDesc,PurType,PurStartDate,PurEndDate,PurQty,InciCompletedQty,PurCompletedQty") [ SqlProc ]
{
}

ClassMethod GetPurInfoHistoryExecute(ByRef qHandle As %Binary, Inci As %String) As %Status
{
	n (qHandle,%session,Inci)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Inci="" $$$OK
	s RowId=0
	f  s RowId=$o(^CT.HRP.MAT.PurInfoRelationI("Inci",Inci,RowId)) q:RowId=""  d
	.s RelationInfo=^CT.HRP.MAT.PurInfoRelationD(RowId)
	.s PURId=$lg(RelationInfo,3)
	.s UseFlag=$lg(RelationInfo,6)
	.s InciCompletedQty=$lg(RelationInfo,5)
	.q:'$d(^CT.HRP.MAT.PurchaseInfoD(PURId))
	.s PurInfo=^CT.HRP.MAT.PurchaseInfoD(PURId)
	.s PurType=""
	.s PurTypeId=$lg(PurInfo,3)
	.s:PurTypeId'="" PurType=$lg(^CT.HRP.MAT.ComDictValueD(PurTypeId),4)
	.s PurNo=$lg(PurInfo,4)
	.s PurStartDate=$lg(PurInfo,5)
	.s PurEndDate=$lg(PurInfo,6)
	.s PurQty=$lg(PurInfo,7)
	.s PurCompletedQty=$lg(PurInfo,8)
	.s PurDesc=$lg(PurInfo,9)
	.s PurStartDate=..DL2H(PurStartDate)
	.s PurEndDate=..DL2H(PurEndDate)
	.d OutPutRow
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,PURId,PurNo,PurDesc,PurType,PurStartDate,PurEndDate,PurQty,InciCompletedQty,PurCompletedQty)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// w ##class(web.DHCSTMHUI.PurchaseInfo).GetDataById("")
ClassMethod GetDataById(RowId) As %Library.String
{
	n (RowId)
	q:RowId="" "{}"
	i '$d(^CT.HRP.MAT.PurchaseInfoD(RowId)) q RtnObj.Err(-1,"","带量采购信息不存在!","",0)
	s PurList=^CT.HRP.MAT.PurchaseInfoD(RowId)
	s PurTypeId=$lg(PurList,3)
	s PurNo=$lg(PurList,4)
	s PurStartDate=$lg(PurList,5)
	s PurEndDate=$lg(PurList,6)
	s PurQty=$lg(PurList,7)
	s PurCompletedQty=$lg(PurList,8)
	s PurDesc=$lg(PurList,9)
	
	s PurTypeDesc="" 
	s:PurTypeId'="" PurTypeDesc=$lg(^CT.HRP.MAT.ComDictValueD(PurTypeId),4)
	s PurNo=..sssComboStr(RowId,PurNo)
	s PurType=..sssComboStr(PurTypeId,PurTypeDesc)
	s PurStartDate=..DL2H(PurStartDate)
	s PurEndDate=..DL2H(PurEndDate)
	
	s Title="PurRowId^PurType^PurNo^PurStartDate^PurEndDate^PurQty^PurCompletedQty^PurDesc"
	s Data=RowId_"^"_PurType_"^"_PurNo_"^"_PurStartDate_"^"_PurEndDate_"^"_PurQty_"^"_PurCompletedQty_"^"_PurDesc
	s Rtn=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	q Rtn
}

/// 保存已采购量(入库退货审核调用)
/// w ##class(web.DHCSTMHUI.PurchaseInfo).SaveRecQty()
ClassMethod SaveRecQty(Type As %String, MainId As %String, IfCancelAudit As %String = "") As RtnObj
{
	n (%session,Type, MainId, IfCancelAudit)
	s RtnObj=##class(RtnObj).%New()
	i (Type="")||(MainId="") q RtnObj.Err(-1,"","带量已采购量保存入参错误!")
	i Type="G" d
	.s CH=0
	.f  s CH=$o(^DHCINGR(MainId,"GRI",CH)) q:(CH="")||(RtnObj.success<0)  d
	..s Inci=$p(^DHCINGR(MainId,"GRI",CH),"^",25)
	..s RecQty=$p(^DHCINGR(MainId,"GRI",CH),"^",4)
	..s IngrUom=$p(^DHCINGR(MainId,"GRI",CH),"^",10)
	..s RelaId=$o(^CT.HRP.MAT.PurInfoRelationI("InciUse",Inci,"Y",""))
	..q:+RelaId'>0
	..s PurId=$lg(^CT.HRP.MAT.PurInfoRelationD(RelaId),3)
	..s InciCompletedQty=$lg(^CT.HRP.MAT.PurInfoRelationD(RelaId),5) //库存项已采购量(基本单位)
	..q:'$d(^CT.HRP.MAT.PurchaseInfoD(PurId))
	..s PurStartDate=$lg(^CT.HRP.MAT.PurchaseInfoD(PurId),5)
	..s PurEndDate=$lg(^CT.HRP.MAT.PurchaseInfoD(PurId),6)
	..q:(PurStartDate>+$h)||(PurEndDate<+$h)
	..s PurCompletedQty=$lg(^CT.HRP.MAT.PurchaseInfoD(PurId),8)	//带量编号对应已采购量(基本单位)
	..s Buom=$p(^INCI(Inci,1),"^",10)
	..s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(IngrUom,Buom)
	..s BUomRecQty=RecQty*Fac
	..q:BUomRecQty'>0
	..s:InciCompletedQty="" InciCompletedQty=0
	..s:PurCompletedQty="" PurCompletedQty=0
	..i IfCancelAudit="Y" d
	...s NewInciComQty=InciCompletedQty-BUomRecQty
	...s NewPurComQty=PurCompletedQty-BUomRecQty
	..e  d
	...s NewInciComQty=InciCompletedQty+BUomRecQty
	...s NewPurComQty=PurCompletedQty+BUomRecQty
	..q:NewInciComQty<0
	..q:NewPurComQty<0
	..&sql(update CT_HRP_MAT.PurInfoRelation set PIR_CompletedQty=:NewInciComQty
		where %ID=:RelaId)
	..i SQLCODE'=0 d RtnObj.Err(-2,"保存已采购量失败!"_SQLCODE)
	..q:RtnObj.success'=0
	..&sql(update CT_HRP_MAT.PurchaseInfo set PUR_CompletedQty=:NewPurComQty
		where %ID=:PurId)
	..i SQLCODE'=0 d RtnObj.Err(-3,"保存已采购量失败!"_SQLCODE)
	..q:RtnObj.success'=0
	i Type="R" d
	.s CH=0
	.f  s CH=$o(^INGRT(MainId,"DHCGRR",CH)) q:(CH="")||(RtnObj.success<0)  d
	..s Ingri=$p(^INGRT(MainId,"DHCGRR",CH),"^",1)
	..s RetQty=$p(^INGRT(MainId,"DHCGRR",CH),"^",2)
	..s RetUom=$p(^INGRT(MainId,"DHCGRR",CH),"^",3)
	..s Inci=+$p(^INGRT(MainId,"DHCGRR",CH),"^",6)
	..s RelaId=$o(^CT.HRP.MAT.PurInfoRelationI("InciUse",Inci,"Y",""))
	..q:+RelaId'>0
	..s PurId=$lg(^CT.HRP.MAT.PurInfoRelationD(RelaId),3)
	..s InciCompletedQty=$lg(^CT.HRP.MAT.PurInfoRelationD(RelaId),5) //库存项已采购量(基本单位)
	..q:'$d(^CT.HRP.MAT.PurchaseInfoD(PurId))
	..s PurStartDate=$lg(^CT.HRP.MAT.PurchaseInfoD(PurId),5)
	..s PurEndDate=$lg(^CT.HRP.MAT.PurchaseInfoD(PurId),6)
	..q:(PurStartDate>+$h)||(PurEndDate<+$h)
	..s PurCompletedQty=$lg(^CT.HRP.MAT.PurchaseInfoD(PurId),8)	//带量编号对应已采购量(基本单位)
	..s Buom=$p(^INCI(Inci,1),"^",10)
	..s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(RetUom,Buom)
	..s BUomRetQty=RetQty*Fac
	..q:BUomRetQty'>0
	..s:InciCompletedQty="" InciCompletedQty=0
	..s:PurCompletedQty="" PurCompletedQty=0
	..i IfCancelAudit="Y" d
	...s NewInciComQty=InciCompletedQty-BUomRetQty
	...s NewPurComQty=PurCompletedQty-BUomRetQty
	..e  d
	...s NewInciComQty=InciCompletedQty+BUomRetQty
	...s NewPurComQty=PurCompletedQty+BUomRetQty
	..q:NewInciComQty<0
	..q:NewPurComQty<0
	..&sql(update CT_HRP_MAT.PurInfoRelation set PIR_CompletedQty=:NewInciComQty
		where %ID=:RelaId)
	..i SQLCODE'=0 d RtnObj.Err(-2,"保存已采购量失败!"_SQLCODE)
	..q:RtnObj.success'=0
	..&sql(update CT_HRP_MAT.PurchaseInfo set PUR_CompletedQty=:NewPurComQty
		where %ID=:PurId)
	..i SQLCODE'=0 d RtnObj.Err(-3,"保存已采购量失败!"_SQLCODE)
	..q:RtnObj.success'=0
	q RtnObj
}

}
