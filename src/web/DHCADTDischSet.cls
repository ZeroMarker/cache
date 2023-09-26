/// Creator: wangxinlei
/// CreatDate: 2009-09-29
/// Description: 病人出院结算与转科功能设置
Class web.DHCADTDischSet Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Creator: wangxinlei
/// CreatDate: 2009-09-29
/// Description: 取需关注的未处理情况
/// Table：^DHCCLSet
/// Input：
/// Return：序号,未处理情况,是否提示,提示顺序
Query FindQueryType() As %Query(ROWSPEC = "No,AbnormalStat,AlertItem,AbnormalSeq")
{
}

ClassMethod FindQueryTypeExecute(ByRef qHandle As %Binary) As %Status
{
 	s repid=$i(^CacheTemp)
 	s ind=1
 	s AbnormalStatNum=$l($g(^DHCCLSet("Disch","AbnormalStat")),"^")
 	f I=1:1:AbnormalStatNum d
 	.s No=I
	.s AbnormalStat=$p($g(^DHCCLSet("Disch","AbnormalStat")),"^",I)
	.s AlertItem=$p($g(^DHCCLSet("Disch","AlertItem")),"^",I)
	.s AbnormalSeq=$p($g(^DHCCLSet("Disch","AbnormalSeq")),"^",I)
    .d OutRowtyp1
    s qHandle=$lb(0,repid,0)
    q $$$OK

OutRowtyp1
	s Data=$lb(No,AbnormalStat,AlertItem,AbnormalSeq)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q

 //code,name,filename,byadm,prnframe
}

ClassMethod FindQueryTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindQueryTypeExecute ]
{
	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {			
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindQueryTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindQueryTypeExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

/// Creator: wangxinlei
/// CreatDate: 2009-09-29
/// Description: 取出院与转科设置
/// Table：^DHCCLSet
/// Input：
/// Return：出院与转科设置
ClassMethod GetDischSet() As %String
{
	//有提示仍能办理出院
	s CanDisch=$g(^DHCCLSet("Disch","CanDisch"))
	//转科是否停当日长期医嘱
	s TransDiscon=$g(^DHCCLSet("Disch","TransDiscon"))
	//出院带药医嘱,需要在最终结算前取药
	s TakeDisDrug=$g(^DHCCLSet("Disch","TakeDisDrug"))
	//没有下列诊断类型不允许办理结算
	s DiagTypeStr=""
	s tmpDiagTypeId=$g(^DHCCLSet("Disch","DiagTypeId"))
	f I=1:1:$l(tmpDiagTypeId,"^") d
	.s DiagTypeId=$p(tmpDiagTypeId,"^",I)
	.q:DiagTypeId=""
	.s DiagTypeIdDesc=$p($g(^MRC("DTYP",DiagTypeId)),"^",2)
	.i DiagTypeStr="" s DiagTypeStr=DiagTypeId_"!"_DiagTypeIdDesc
	.e  s DiagTypeStr=DiagTypeStr_"^"_DiagTypeId_"!"_DiagTypeIdDesc 
	//出院前必须停止的医嘱代码RowId
	s MustDisconArcimStr=""
	s tmpMustDisconArcimId=$g(^DHCCLSet("Disch","MustDisconArcimId"))
	f I=1:1:$l(tmpMustDisconArcimId,"^") d
	.s MustDisconArcimId=$p(tmpMustDisconArcimId,"^",I)
	.q:MustDisconArcimId=""
	.s MustDisconArcimDesc=$p($g(^ARCIM($p(MustDisconArcimId,"||",1),$p(MustDisconArcimId,"||",2),1)),"^",2)
	.i MustDisconArcimStr="" s MustDisconArcimStr=MustDisconArcimId_"!"_MustDisconArcimDesc
	.e  s MustDisconArcimStr=MustDisconArcimStr_"^"_MustDisconArcimId_"!"_MustDisconArcimDesc 
	//出院前必须要医生开的医嘱子类RowId
	s NeedOrdCatStr=""
	s tmpNeedOrdCat=$g(^DHCCLSet("Disch","NeedOrdCat"))
	f I=1:1:$l(tmpNeedOrdCat,"^") d
	.s NeedOrdCatId=$p(tmpNeedOrdCat,"^",I)
	.q:NeedOrdCatId=""
	.s NeedOrdCatDesc=$p($g(^ARC("IC",NeedOrdCatId)),"^",2)
	.i NeedOrdCatStr="" s NeedOrdCatStr=NeedOrdCatId_"!"_NeedOrdCatDesc
	.e  s NeedOrdCatStr=NeedOrdCatStr_"^"_NeedOrdCatId_"!"_NeedOrdCatDesc 
	//转科前必须要医生开的医嘱子类RowId
	s NeedTransOrdCatStr=""
	s tmpNeedTransOrdCat=$g(^DHCCLSet("Disch","NeedTransOrdCat"))
	f I=1:1:$l(tmpNeedTransOrdCat,"^") d
	.s NeedTransOrdCatId=$p(tmpNeedTransOrdCat,"^",I)
	.q:NeedTransOrdCatId=""
	.s NeedTransOrdCatDesc=$p($g(^ARC("IC",NeedTransOrdCatId)),"^",2)
	.i NeedTransOrdCatStr="" s NeedTransOrdCatStr=NeedTransOrdCatId_"!"_NeedTransOrdCatDesc
	.e  s NeedTransOrdCatStr=NeedTransOrdCatStr_"^"_NeedTransOrdCatId_"!"_NeedTransOrdCatDesc 
	//设定科室所开医嘱不提示
	s SelOrdDepStr=""
	s tmpSelOrdDep=$g(^DHCCLSet("Disch","UnNeedExecLocId"))
	f I=1:1:$l(tmpSelOrdDep,"^") d
	.s SelOrdDepId=$p(tmpSelOrdDep,"^",I)
	.q:SelOrdDepId=""
	.s SelOrdDepDesc=$p($g(^CTLOC(SelOrdDepId)),"^",2)
	.i SelOrdDepStr="" s SelOrdDepStr=SelOrdDepId_"!"_SelOrdDepDesc
	.e  s SelOrdDepStr=SelOrdDepStr_"^"_SelOrdDepId_"!"_SelOrdDepDesc 
	//转科是否需要科室与病区关联
	s TransLocWardRelation=$g(^DHCCLSet("Disch","TransLocWardRelation"))
	//非新长嘱未执行是否提示
	s LongUnnewExec=$g(^DHCCLSet("Disch","LongUnnewExec"))
	//设定某些子类不提示
	s UnNeedOrdSubCat=""
	s tmpUnNeedOrdSubCat=$g(^DHCCLSet("Disch","UnNeedOrdSubCat"))
	f I=1:1:$l(tmpUnNeedOrdSubCat,"^") d
	.s UnNeedOrdSubCatId=$p(tmpUnNeedOrdSubCat,"^",I)
	.q:UnNeedOrdSubCatId=""
	.s UnNeedOrdSubCatDesc=$p(^ARC("IC",UnNeedOrdSubCatId),"^",2)
	.i UnNeedOrdSubCat="" s UnNeedOrdSubCat=UnNeedOrdSubCatId_"!"_UnNeedOrdSubCatDesc
	.e  s UnNeedOrdSubCat=UnNeedOrdSubCat_"^"_UnNeedOrdSubCatId_"!"_UnNeedOrdSubCatDesc
	q CanDisch_"@"_TransDiscon_"@"_TakeDisDrug_"@"_DiagTypeStr_"@"_MustDisconArcimStr_"@"_NeedOrdCatStr_"@"_NeedTransOrdCatStr_"@"_SelOrdDepStr_"@"_TransLocWardRelation_"@"_LongUnnewExec_"@"_UnNeedOrdSubCat
}

/// Creator: wangxinlei
/// CreatDate: 2009-09-29
/// Description: 增加出院与转科提示设置
/// Table：^DHCCLSet
/// Input：
/// Return：成功返回0,失败返回非0
ClassMethod TypeAdd(No As %String, typeStr As %String)
{
	q:(No="") -2
	q:$p($g(^DHCCLSet("Disch","AbnormalStat")),"^",No)'="" -1
	s $p(^DHCCLSet("Disch","AbnormalStat"),"^",No)=$p(typeStr,"^",1)
	s $p(^DHCCLSet("Disch","AlertItem"),"^",No)=$p(typeStr,"^",2)
	s $p(^DHCCLSet("Disch","AbnormalSeq"),"^",No)=$p(typeStr,"^",3)
	q 0
}

/// Creator: wangxinlei
/// CreatDate: 2009-09-29
/// Description: 更新出院与转科提示设置
/// Table：^DHCCLSet
/// Input：
/// Return：成功返回0,失败返回非0
ClassMethod TypeUpdate(oldNo As %String, No As %String, typeStr As %String)
{
	q:(oldNo="")!(No="") -2
	s $p(^DHCCLSet("Disch","AbnormalStat"),"^",No)=$p(typeStr,"^",1)
	s $p(^DHCCLSet("Disch","AlertItem"),"^",No)=$p(typeStr,"^",2)
	s $p(^DHCCLSet("Disch","AbnormalSeq"),"^",No)=$p(typeStr,"^",3)
	q 0
}

/// Creator: wangxinlei
/// CreatDate: 2009-09-29
/// Description: 删除出院与转科提示设置
/// Table：^DHCCLSet
/// Input：
/// Return：成功返回0,失败返回非0
ClassMethod TypeDel(No As %String)
{
	q:(No="") -2
	q:$p($g(^DHCCLSet("Disch","AbnormalStat")),"^",No)="" -1
	s $p(^DHCCLSet("Disch","AbnormalStat"),"^",No)=""
	s $p(^DHCCLSet("Disch","AlertItem"),"^",No)=""
	s $p(^DHCCLSet("Disch","AbnormalSeq"),"^",No)=""
	q 0
}

/// Creator: wangxinlei
/// CreatDate: 2009-09-29
/// Description: 取诊断类型
/// Table：MRC_DiagnosType
/// Input：
/// Return：返回诊断类型的描述与RowId
Query FindDiagType(DiagType As %String) As %Query(ROWSPEC = "DTYPDesc,DTYPRowId")
{
}

ClassMethod FindDiagTypeExecute(ByRef qHandle As %Binary, DiagType As %String) As %Status
{
 	s repid=$i(^CacheTemp)
 	s ind=1
 	
 	
 	s DTYPRowId=0
 	f  s DTYPRowId=$o(^MRC("DTYP",DTYPRowId)) q:DTYPRowId=""  d
 	.s DTYPDesc=$p(^MRC("DTYP",DTYPRowId),"^",2)
 	.q:(DiagType'="")&(DTYPDesc'[DiagType)
    .d OutRowtyp2
    s qHandle=$lb(0,repid,0)
    q $$$OK

OutRowtyp2
	s Data=$lb(DTYPDesc,DTYPRowId)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q

 //code,name,filename,byadm,prnframe
}

ClassMethod FindDiagTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDiagTypeExecute ]
{
	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {			
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindDiagTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDiagTypeExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

/// Creator: wangxinlei
/// CreatDate: 2009-09-29
/// Description: 取医嘱子类
/// Table：ARC_ItemCat
/// Input：
/// Return：返回医嘱子类的描述与RowId
Query FindArcItemCat(ArcItemCat As %String) As %Query(ROWSPEC = "ItemCatDesc,ItemCatRowId")
{
}

ClassMethod FindArcItemCatExecute(ByRef qHandle As %Binary, ArcItemCat As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ItemCatRowId=""
 	f  s ItemCatRowId=$O(^ARC("IC",ItemCatRowId)) q:ItemCatRowId=""  d
 	.s ItemCatDesc=$P(^ARC("IC",ItemCatRowId),"^",2)
 	.q:(ItemCatDesc'[ArcItemCat)&(ArcItemCat'="")
	.Do Outputcat
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Outputcat
	set Data=$lb(ItemCatDesc,ItemCatRowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindArcItemCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArcItemCatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindArcItemCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindArcItemCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator: wangxinlei
/// CreatDate: 2009-09-29
/// Description: 保存出院与转科设置
/// Table：^DHCCLSet
/// Input：
/// Return：成功返回0,失败返回非0
ClassMethod TypeSave(SetStr As %String)
{
	//有提示仍能办理出院
	s ^DHCCLSet("Disch","CanDisch")=$p(SetStr,"!",1)
	//转科是否停当日长期医嘱
	s ^DHCCLSet("Disch","TransDiscon")=$p(SetStr,"!",2)
	//出院带药医嘱,需要在最终结算前取药
	s ^DHCCLSet("Disch","TakeDisDrug")=$p(SetStr,"!",3)
	//没有下列诊断类型不允许办理结算
	s ^DHCCLSet("Disch","DiagTypeId")=$p(SetStr,"!",4)
	//出院前必须停止的医嘱代码RowId
	s ^DHCCLSet("Disch","MustDisconArcimId")=$p(SetStr,"!",5)
	//出院前必须要医生开的医嘱子类RowId
	s ^DHCCLSet("Disch","NeedOrdCat")=$p(SetStr,"!",6)
	//转科前必须要医生开的医嘱子类RowId
	s ^DHCCLSet("Disch","NeedTransOrdCat")=$p(SetStr,"!",7)
	//设定科室所开医嘱不提示
	s ^DHCCLSet("Disch","UnNeedExecLocId")=$p(SetStr,"!",8)
	//转科是否需要科室与病区关联
	s ^DHCCLSet("Disch","TransLocWardRelation")=$p(SetStr,"!",9)
	//非新长嘱未执行是否提示
	s ^DHCCLSet("Disch","LongUnnewExec")=$p(SetStr,"!",10)
	//设定某些子类不提示
	s ^DHCCLSet("Disch","UnNeedOrdSubCat")=$p(SetStr,"!",11)
	q 0
}

/// Creator: wangxinlei
/// CreatDate: 2009-09-29
/// Description: 取科室
/// Table：CT_Loc
/// Input：LocDesc: 查询条件
/// Return：CTLocDesc:科室描述, CTLocId:科室的ID
Query FindCTLoc(LocDesc As %String) As %Query(ROWSPEC = "CTLocDesc:%String,CTLocId:%String")
{
}

ClassMethod FindCTLocExecute(ByRef qHandle As %Binary, LocDesc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	i $g(LocDesc)'="" s LocDesc=$$ALPHAUP^SSUTIL4(LocDesc)
	s len=$l(LocDesc)
    s CTLocId=0 f  s CTLocId=$o(^CTLOC(CTLocId)) q:CTLocId=""  d
    .q:'$d(^CTLOC(CTLocId))
    .s CTLocDesc=$p(^CTLOC(CTLocId),"^",2)
    .s tmpLocDesc=$$ALPHAUP^SSUTIL4(CTLocDesc)
    .s tmpLocDesc=$e(tmpLocDesc,1,len)
    .q:tmpLocDesc'=LocDesc
    .s CTLocType=$p($G(^CTLOC(CTLocId)),"^",13)
    .q:(CTLocType="OR")!(CTLocType="O")
 	.Do Output
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
Output
	set Data=$lb(CTLocDesc,CTLocId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindCTLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCTLocExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindCTLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCTLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
