Class web.DHCWLGetLocMRData Extends %RegisteredObject [ Not ProcedureBlock ]
{

// d ##class(%ResultSet).RunQuery("web.DHCWLQuery","QueryLoc")

// 	修改^OEC("ORCAT",)ID 中药费的ID

/// Creator：      ch
/// CreatDate：    2014-12-12
/// Description:： 医技科室工作量
/// Table：        
/// Input：       ""
/// Output：     
/// Return：      
/// Others：     d ##class(%ResultSet).RunQuery("web.DHCWLGetLocMRData","GetLocMRDataQuery","2012-01-01","2013-01-01","I,O","2")	,,,,,,,
Query GetLocMRDataQuery(mSDate As %String, mEDate As %String, mType As %String, mStatStr As %String) As %Query(ROWSPEC = "monId:%String,monDesc:%String,kpiId:%String,kpiCode:%String,kpiDes:%String,dimList:%String,resolvedDimList:%String,value:%Float") [ SqlProc ]
{
}

/// //						 ByRef qHandle As %Binary, startdate As %String, enddate As %String
ClassMethod GetLocMRDataQueryExecute(ByRef qHandle As %Binary, mSDate As %String, mEDate As %String, mType As %String, mStatStr As %String) As %Status
{
	;n (qHandle)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	i (mSDate="")&(mEDate="") Set qHandle=$lb(0,repid,0)
    i (mSDate="")&(mEDate="")  q $$$OK
 	Set ind=1,flag=1
 	s sDate=$zdh(mSDate,3)
	s eDate=$zdh(mEDate,3)
	k ^TEMPDHCWL($j) 
	
	s kpiStr="KPSTWLJF,KPSTWLEXE,KPSTWLJYInter,KPSTWLJCInter,KPSTWLHSZX"
	s startDate=$G(mSDate)
	s endDate=$G(mEDate)
	s choiceType=""
	s isRealData="C"
	s filterRuler=""
	s kpi=$$GetKpiStr(kpiStr)
	
	
	;s mStatStr="2,3,4,5"
	;d InitStatDetail(mStatStr)
	
 	;Set rset = ##class(%ResultSet).%New("DHCWL.MKPIService.MKPIQuery:QueryMutiMonKPIDataByGen")
	;d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.MKPIQuery","QueryMKPIByDate",kpi,startDate,endDate,choiceType,isRealData,filterRuler)
 	Set rset = ##class(%ResultSet).%New("DHCWL.MKPIService.MKPIQuery:QueryMKPIByDate")
	Set columns = rset.GetColumnCount()
	Set sc = rset.Execute(kpi,startDate,endDate,choiceType,isRealData,filterRuler)
	d InitStatDetail(mStatStr)
	d InitAdmType(mType)
	;w !,kpi_"--"_startDate_"--"_endDate_"--"_choiceType_"--"_isRealData_"--"_filterRuler

	///	958:2012年07月12日:286:KPSTWLJF:科室工作量(计费):I,98,1072||1,6:住院,中心药房,葡萄糖氯化钠注射液[东宝][250ml],中西医结合一科:2:
	While (rset.Next())
	{
      
      s monId=rset.GetData(1)
      s monDesc=rset.GetData(2)
      s kpiId=rset.GetData(3)
      s kpiCode=rset.GetData(4)
      s kpiDes=rset.GetData(5)
      s dimList=rset.GetData(6)
      s resolvedDimList=rset.GetData(7)
      s value=rset.GetData(8)
      
      
      s mAdmType=$p($G(dimList),",",1)
      s mArcItmDr=$p($G(dimList),",",3)
      s mDataFlag=$$GetDataFlag(mAdmType,mArcItmDr)
      i $G(mDataFlag) d OutPutRowD
	}
	Do rset.Close()	

	;d OutPutRowD
	
	 

 	
 	k ^TEMPDHCWL($j) 
	Quit $$$OK



OutPutRowD
	s Data=$lb(monId,monDesc,kpiId,kpiCode,kpiDes,dimList,resolvedDimList,value)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
GetDataFlag(mAdmType,mArcItmDr)
	n (mAdmType,mArcItmDr)
	s mRet=1
	q:'$d(^TEMPDHCWL($j,"AdmTypeFlag",mAdmType)) 0
	q:'$d(^TEMPDHCWL($j,"ArcFlag",mArcItmDr)) 0
	q $G(mRet)
 	
GetKpiStr(kpiStr)
	n (kpiStr)
	s kpi=""
	s mKpiLen=$l($G(kpiStr),",")
	f i=1:1:mKpiLen d
	.s mKpiA=$p($G(kpiStr),",",i)
	.s mKpiB=$G(mKpiA)_":AdmType^RecDep^Arcim.ARCIMName^PatDep"
	.i $G(kpi)="" d
	..s kpi=$G(mKpiB)
	.e  d
	..s kpi=$G(kpi)_","_$G(mKpiB)
	q $G(kpi)
InitStatDetail(mStatStr)
	n (mStatStr)
	s mStatLen=$l($G(mStatStr),",")
	
	s YJCode=$g(^DHCWLSTWLYJGroupBS("Code"))
 	Q:YJCode="" $$$OK
	s GrpId=0    ///记录BS代码明细表中医嘱明细属于统计子类，分类
	f  s GrpId=$o(^DHCWL.CodeCfg.GroupD(GrpId)) q:GrpId=""  d
	.s GrpCode=$li(^DHCWL.CodeCfg.GroupD(GrpId),2)
	.s GrpDesc=$li(^DHCWL.CodeCfg.GroupD(GrpId),3)
	.Q:GrpCode'[YJCode
	.Q:((","_mStatStr_",")'[(","_GrpId_","))&&($g(mStatStr)'="")
	.s ItemDr=0
	.f  s ItemDr=$O(^DHCWL.CodeCfg.SubGroupItemI("Grp",GrpId,ItemDr)) Q:ItemDr=""  d
	..s Id=0
	..f  s Id=$O(^DHCWL.CodeCfg.SubGroupItemI("Grp",GrpId,ItemDr,Id)) Q:Id=""  d
	...s SubGrp=$li(^DHCWL.CodeCfg.SubGroupItemD(Id),3)
	...s SubGrpDesc=$li(^DHCWL.CodeCfg.SubGroupD(SubGrp),3)
	...s ArcimDr=$TR(ItemDr," ","")
	...q:$G(ArcimDr)=""
	...s ^TEMPDHCWL($j,"ArcFlag",ArcimDr)=1
	q
InitAdmType(mType)
	n (mType)
	s mTypeLen=$l($G(mType),",")
	f i=1:1:mTypeLen d
	.s mAdmType=$p($G(mType),",",i)
	.q:$G(mAdmType)=""
	.s ^TEMPDHCWL($j,"AdmTypeFlag",mAdmType)=1
	q
}

ClassMethod GetLocMRDataQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocMRDataQueryExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetLocMRDataQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocMRDataQueryExecute ]
{
	n (qHandle,Row,AtEnd)
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      ycm
/// CreatDate：    2012-06-8
/// Description:： 解析科室id，Code，Desc
/// Table：       CT_Loc
/// Input：       ""
/// Output：     CTLocid,CTLocCode,CTLocDesc
/// Return：      
/// Others：      d ##class(%ResultSet).RunQuery("web.DHCWLGetLocMRData","QueryLoc","NK")
Query QueryLoc(mLocDesc As %String) As %Query(ROWSPEC = "CTLocid:%String,CTLocCode:%String,CTLocDesc:%String") [ SqlProc ]
{
}

ClassMethod QueryLocExecute(ByRef qHandle As %Binary, mLocDesc As %String) As %Status
{
	n (qHandle,mLocDesc)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1,flag=1
 	
 	
 	s mLocDesc=$zcvt(mLocDesc,"U")
 	;s CTLocid=0,CTLocCode="",CTLocDesc="Null"
 	;d OutPutRowD1
 	s CTLocid=0 f  s CTLocid=$O(^CTLOC(CTLocid)) Q:CTLocid=""  d
 	.s CTLocType=$P(^CTLOC(CTLocid),"^",13)
 	.Q:CTLocType'="E"
 	.s CTLocCode=$P(^CTLOC(CTLocid),"^",1)
 	.s CTLocDesc=$P(^CTLOC(CTLocid),"^",2)
 	.q:($G(mLocDesc)'="")&&($G(CTLocDesc)'[$G(mLocDesc))
 	.i CTLocDesc["-" s CTLocDesc=$P(CTLocDesc,"-",2)
 	.Q:CTLocDesc["停用"
 	.d OutPutRowD1
	Quit $$$OK
OutPutRowD1
	s Data=$lb(CTLocid,CTLocCode,CTLocDesc)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
}

ClassMethod QueryLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryLocExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLocExecute ]
{
	n (qHandle,Row,AtEnd)
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCWLQuery","QueryWard")

/// Creator：      ycm
/// CreatDate：    2012-06-8
/// Description:： 解析病区id，Code，Desc
/// Table：       Pac_Ward
/// Input：       ""
/// Output：     Wardid,WardCode,WardDesc
/// Return：      
/// Others：      
Query QueryWard() As %Query(ROWSPEC = "Wardid:%String,WardCode:%String,WardDesc:%String") [ SqlProc ]
{
}

ClassMethod QueryWardExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1,flag=1
 	s Locid=""
 	f  s Locid=$O(^PAWARD(0,"WARD_LocationDR",Locid)) Q:Locid=""  d
 	.s Wardid="" f  s Wardid=$O(^PAWARD(0,"WARD_LocationDR",Locid,Wardid))  Q:Wardid=""  d
 	..s WardCode=$P(^PAWARD(Wardid),"^",1)
 	..s WardDesc=$P(^PAWARD(Wardid),"^",2)
 	..s WardActive=$P(^PAWARD(Wardid),"^",6)
 	..Q:WardActive="N"
 	..i WardDesc["-" s WardDesc=$P(WardDesc,"-",2)
 	..Q:WardDesc["停用"
 	..d OutPutWard
	Quit $$$OK
OutPutWard
	s Data=$lb(Wardid,WardCode,WardDesc)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
}

ClassMethod QueryWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryWardExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryWardExecute ]
{
	n (qHandle,Row,AtEnd)
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      ycm
/// CreatDate：    2014-11-24
/// Description:： 从BS代码维护获得以WLST开头的医技工作量统计分类维护以及统计分类相关联的口径
/// Table：       DHCWL.CodeCfg.Group
/// Input：       
/// Output：      
/// Return：
/// Others：d ##class(%ResultSet).RunQuery("web.DHCWLGetLocMRData","GetGroupList")
Query GetGroupList() As %Query(ROWSPEC = "GrpId:%String,GrpCode:%String,GrpDesc:%String") [ SqlProc ]
{
}

ClassMethod GetGroupListExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	k ^TEMPDHCWLCode($j)
	k data
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	s YJCode=$g(^DHCWLSTWLYJGroupBS("Code"))
 	Q:YJCode="" $$$OK
	s GrpId=0 
	f  s GrpId=$o(^DHCWL.CodeCfg.GroupD(GrpId)) q:GrpId=""  d
	.s GrpCode=$li(^DHCWL.CodeCfg.GroupD(GrpId),2)
	.s GrpDesc=$li(^DHCWL.CodeCfg.GroupD(GrpId),3)
	.Q:GrpCode'[YJCode
	.s ^TEMPDHCWLCode($j,GrpId)=GrpCode_"^"_GrpDesc
	s GrpId=0 
	f  s GrpId=$o(^TEMPDHCWLCode($j,GrpId)) q:GrpId=""  d
	.s GrpCode=$p($g(^TEMPDHCWLCode($j,GrpId)),"^",1)
	.s GrpDesc=$p($g(^TEMPDHCWLCode($j,GrpId)),"^",2)
	.s ^CacheTemp(repid,ind)=$lb(GrpId,GrpCode,GrpDesc)
	.s ind=ind+1
	k ^TEMPDHCWLCode($j)
	Quit $$$OK
}

ClassMethod GetGroupListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetGroupListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	k ^TEMPDHCWLCode($j)
	Quit $$$OK
}

ClassMethod GetGroupListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetGroupListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      ch
/// CreatDate：    2014-11-24
/// Description:： 从BS代码维护获得以WLST开头的医技工作量统计分类信息
/// Table：       DHCWL.CodeCfg.Group
/// Input：       
/// Output：      
/// Return：
/// Others：d ##class(%ResultSet).RunQuery("web.DHCWLGetLocMRData","GetGroupDetail")
Query GetGroupDetail(mGrpStr As %String) As %Query(ROWSPEC = "mGrpId:%String,mGrpCode:%String,mGrpDesc:%String,mGrpSubId:%String,mGrpSubCode:%String,mGrpSubDesc:%String,mGrpDetailId:%String,mGrpDetailDesc:%String") [ SqlProc ]
{
}

ClassMethod GetGroupDetailExecute(ByRef qHandle As %Binary, mGrpStr As %String) As %Status
{
	n (mGrpStr,qHandle)
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	k ^TEMPDHCWLCode($j)
	k data
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	s YJCode=$g(^DHCWLSTWLYJGroupBS("Code"))
 	i mGrpStr=""  d
	.s GrpId=0 
	.f  s GrpId=$o(^DHCWL.CodeCfg.GroupD(GrpId)) q:GrpId=""  d
	..s GrpCode=$li(^DHCWL.CodeCfg.GroupD(GrpId),2)
	..s GrpDesc=$li(^DHCWL.CodeCfg.GroupD(GrpId),3)
	..Q:GrpCode'[YJCode
	..s mGrpStr=mGrpStr_","_GrpId
 
 	
 	
 	s mLen=$l(mGrpStr,",")
	f i=1:1:mLen d 
	.s mGrpId=$p($G(mGrpStr),",",i)
	.Q:+mGrpId=0
	.s mGrpCode=$li($g(^DHCWL.CodeCfg.GroupD(mGrpId)),2)
	.s mGrpDesc=$li($g(^DHCWL.CodeCfg.GroupD(mGrpId)),3)
	.///	^DHCWL.CodeCfg.SubGroupI("GrpDr",1,2)
	.s mGrpSubId=0
	.f  s mGrpSubId=$o(^DHCWL.CodeCfg.SubGroupI("GrpDr",mGrpId,mGrpSubId)) q:$G(mGrpSubId)=""  d
	..s mGrpSubCode=$li($g(^DHCWL.CodeCfg.SubGroupD(mGrpSubId)),2)
	..s mGrpSubDesc=$li($g(^DHCWL.CodeCfg.SubGroupD(mGrpSubId)),3)
	..///	^DHCWL.CodeCfg.SubGroupItemI("SGrpIM",10," 10369||1",10)
	..s mGrpDetailIda=0
	..f  s mGrpDetailIda=$o(^DHCWL.CodeCfg.SubGroupItemI("SGrpIM",mGrpSubId,mGrpDetailIda)) q:$G(mGrpDetailIda)=""  d
	...s mGrpDetailId=$tr(mGrpDetailIda," ","")
	...s mGrpDetailDesc=$$GetARCIMName(mGrpDetailId)
	...s ^CacheTemp(repid,ind)=$lb(mGrpId,mGrpCode,mGrpDesc,mGrpSubId,mGrpSubCode,mGrpSubDesc,mGrpDetailId,mGrpDetailDesc)
	...s ind=ind+1
	k ^TEMPDHCWLCode($j)
	Quit $$$OK
	
GetARCIMName(mArcItemDR)
	n (mArcItemDR)
 	q:$g(mArcItemDR)="" "Null"
	s mArcItemDrF=$p(mArcItemDR,"||",1)
 	s mArcItemDrS=$p(mArcItemDR,"||",2)
 	q:($G(mArcItemDrF)="")!($G(mArcItemDrS)="") "Null"
 	s mArcItemDesc=$p($G(^ARCIM(mArcItemDrF,mArcItemDrS,1)),"^",2)
 	i $G(mArcItemDesc)="" s mArcItemDesc="Null"
 	q $g(mArcItemDesc)  
	
	///	mGrpId,mGrpCode,mGrpDesc,mGrpSubId,mGrpSubCode,mGrpSubDesc,mGrpDetailId,mGrpDetailDesc
}

ClassMethod GetGroupDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetGroupDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	k ^TEMPDHCWLCode($j)
	Quit $$$OK
}

ClassMethod GetGroupDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetGroupDetailExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
