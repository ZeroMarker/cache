/// CTOR: QP
/// DATE: 2020-06-12
/// DESC: 化疗项目变更原因维护
Class DHCDoc.Chemo.CFG.ChgReason Extends DHCDoc.Util.RegisteredObject [ Not ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-04-29
/// DESC: 保存
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.THPY.CFG.ChgReason).Save("903||1")
ClassMethod Save(CRID, Reason, TplDR, Active, InHosp)
{
	n (CRID,Reason,TplDR,Active,InHosp)
	
	i CRID="" {
		s a=##class(User.ChemoChgReason).%New()
		d a.CRHospSetObjectId(InHosp)
	} else {
		s a=##class(User.ChemoChgReason).%OpenId(CRID)
	}
	s a.CRActive=Active
	s a.CRReason=Reason
	d a.CRTemplateDRSetObjectId(TplDR)
	
	s sc=a.%Save()
	If $$$ISERR(sc) {
		//d $system.OBJ.DisplayError(sc) 
		Quit "-109"
	}
	
	Q 0
}

/// CTOR: QP
/// DATE: 2020-04-29
/// DESC: 删除
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.THPY.CFG.ChgReason).Delete("")
ClassMethod Delete(CRID As %String)
{
	n (CRID)
	Q:CRID="" 0
	&SQL(DELETE FROM SQLUser.Chemo_ChgReason WHERE CR_ID=:CRID)
	Q:SQLCODE'=0 "-110"
	
	Q 0
}

/// CTOR: QP
/// DATE: 2020-04-29
/// DESC: 根据模板删除
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.CFG.ChgReason).DeleteByTPL("")
ClassMethod DeleteByTPL(TPL As %String)
{
	n (TPL)
	Q:TPL="" 0
	&SQL(DELETE FROM SQLUser.Chemo_ChgReason WHERE CR_TemplateDR=:TPL)
	Q:SQLCODE'=0 SQLCODE
	
	Q 0
}

/// CTOR: QP
/// DATE: 2020-04-26
/// DESC: 查询模板类型
/// IN  : InFlag全局标志
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.THPY.CFG.ChgReason","QryReason")
Query QryReason(TplDR = "", InFlag = "", InActive = "", InHosp = "", All = "") As %Query(ROWSPEC = "id,reason,tplid,tplName,active")
{
}

ClassMethod QryReasonExecute(ByRef qHandle As %Binary, TplDR = "", InFlag = "", InActive = "", InHosp = "", All = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	s ^QP("DHC")=$LB(TplDR,InFlag,InActive)
 	s langid=..%LanguageID()
 	s id=0
 	f  s id=$o(^CF.DOC.Chemo.ChgReasonD(id)) q:id=""  d
 	.s reason=$p(^CF.DOC.Chemo.ChgReasonD(id),"^",1)
 	.s tplid=$p(^CF.DOC.Chemo.ChgReasonD(id),"^",2)
 	.s hosp=$p(^CF.DOC.Chemo.ChgReasonD(id),"^",4)
 	.q:(InHosp'="")&&(InHosp'=hosp)
 	.s tplName=""
 	.s tplActive=""
 	.q:(tplid'="")&&'$d(^CF.DOC.Chemo.TemplateD(tplid))
 	.i tplid'="" d
 	..q:'$d(^CF.DOC.Chemo.TemplateD(tplid))
 	..s tplName=$p(^CF.DOC.Chemo.TemplateD(tplid),"^",3)
 	..s tplActive=$p(^CF.DOC.Chemo.TemplateD(tplid),"^",5)
 	.s active=$p(^CF.DOC.Chemo.ChgReasonD(id),"^",3)
 	.d output1
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output1
 	q:(InActive'="")&&(active'=InActive)
 	if (All'=1) {
 		q:(tplActive'="Y")&&(tplid'="")	;显示有效的模板
 	}
 	i TplDR'="" {
	 	i InFlag'="" {
		 	q:(TplDR'="")&&(TplDR'=tplid)&&(tplid'="")	;
		} else {
			q:(TplDR'="")&&(TplDR'=tplid)	;
		}	
	 } else {
		i InFlag'="" {
			Q:tplid'=""	;全局原因
		}
	 }
	s reason= ##class(User.ChemoChgReason).GetTranByDesc("CRReason",reason,langid)
	Set Data=$lb(id,reason,tplid,tplName,active)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryReasonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryReasonExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryReasonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryReasonExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

}
