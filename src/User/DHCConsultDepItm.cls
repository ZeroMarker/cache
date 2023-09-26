Class User.DHCConsultDepItm Extends %Persistent [ SqlTableName = DHC_ConsultDepItm ]
{

/// 会诊科室
Property ConsultDepDr As %String [ SqlColumnNumber = 2, SqlFieldName = Consult_DepDr ];

/// 会诊医嘱项
Property ConsultItmDr As %String [ SqlColumnNumber = 3, SqlFieldName = Consult_ItmDr ];

/// 会诊类型(I:院内,O:院外)
Property ConsultType As %String [ SqlColumnNumber = 4, SqlFieldName = Consult_Type ];

/// 医生类型(D:主任医师,A:副主任医师,C:主治医师,P:知名专家)
Property DoctorType As %String [ SqlColumnNumber = 5, SqlFieldName = Doctor_Type ];

/// 会诊费用
Property ConsultPrice As %String [ SqlColumnNumber = 6, SqlFieldName = Consult_Price ];

/// 生成方式
Property ConsultHowToCreate As %String [ SqlColumnNumber = 7, SqlFieldName = Consult_HowToCreate ];

Index Dep On (ConsultDepDr, ConsultHowToCreate);

Index Consult On (ConsultType, DoctorType, ConsultDepDr, ConsultHowToCreate);

/// ifOpenMorcLocAudit:是否开启多科会诊审核,ifOpenMoreLocAuditExec:是否开启审核部门执行
ClassMethod SaveConfig(ifCreateOrderByApp, ifCreateOrderByExcute, ifOpenMorcLocAudit = "N", ifOpenMoreLocAuditExec = "N")
{
	s ^DHCNurConsultSet("ifCreateOrderByApp")=ifCreateOrderByApp
	s ^DHCNurConsultSet("ifCreateOrderByExcute")=ifCreateOrderByExcute
	s ^DHCNurConsultSet("ifOpenMorcLocAudit")=ifOpenMorcLocAudit
	s ^DHCNurConsultSet("ifOpenMoreLocAuditExec")=ifOpenMoreLocAuditExec
	q 0
}

ClassMethod GetConfig()
{
	q $g(^DHCNurConsultSet("ifCreateOrderByApp"))_"^"_$g(^DHCNurConsultSet("ifCreateOrderByExcute"))_"^"_$g(^DHCNurConsultSet("ifOpenMorcLocAudit"))_"^"_$g(^DHCNurConsultSet("ifOpenMoreLocAuditExec"))
}

ClassMethod Save(parr As %String) As %String
{
	q:parr=""
	s depid=$P(parr,"^",1)
	s itmid=$tr($P(parr,"^",2),"__","||")
	s contype=$P(parr,"^",3)
	s doctype=$P(parr,"^",4)
	s howToCreate=$P(parr,"^",5)
	s id=$P(parr,"^",6)
	s depid=$zcvt(depid,"U")
	i depid="All" d
	.//s iddep=$O(^User.DHCConsultDepItmI("Consult"," "_contype," "_doctype," "_depid,""))
	.//q:
	;i id="" d
	;.s id=$O(^User.DHCConsultDepItmI("Consult"," "_contype," "_doctype," "_depid,""_howToCreate,""))
	i id="" d
	.s a=##class(User.DHCConsultDepItm).%New()
	e  d
	.s a=##class(User.DHCConsultDepItm).%OpenId(id)
	s a.ConsultDepDr=depid
	s a.ConsultItmDr=itmid
	s a.ConsultType=contype
	s a.DoctorType=doctype
	s a.ConsultHowToCreate=howToCreate
	TStart
	s sc=a.%Save()
	I $$$ISERR(sc)
	{
		TRollBack
		q "关联失败！"
	}
	else
	{
		TCommit
		q "关联成功！"
	}
}

ClassMethod GetValue(id As %String) As %String
{
	q:id="" ""
	s cdiobj=##class(User.DHCConsultDepItm).%OpenId(id)
	s ret="rw|"_id
	s depid=cdiobj.ConsultDepDr
	s ret=ret_"^depid|"_depid
	i depid'="" d
	.s depcode=$P(^CTLOC(depid),"^",1)
	.s depdesc=$P(^CTLOC(depid),"^",2)
	s ret=ret_"^DepCode|"_$g(depcode)
	s ret=ret_"^DepDesc|"_$g(depdesc)
	s itmid=cdiobj.ConsultItmDr
	s ret=ret_"^itmid|"_$tr(itmid,"||","__")
	i itmid'="" d
	.s itmcode=$P(^ARCIM($P(itmid,"||",1),$P(itmid,"||",2),1),"^",1)
	.s itmdesc=$P(^ARCIM($P(itmid,"||",1),$P(itmid,"||",2),1),"^",2)
	s ret=ret_"^ItmCode|"_$g(itmcode)
	s ret=ret_"^ItmDesc|"_$g(itmdesc)
	s ret=ret_"^contype|"_cdiobj.ConsultType
	s ret=ret_"^ConTypDesc|"
	s:cdiobj.ConsultType="I" ret=ret_"院内会诊"
	s:cdiobj.ConsultType="O" ret=ret_"院外会诊"
	s ret=ret_"^doctype|"_cdiobj.DoctorType
	s ret=ret_"^DocTypDesc|"
	s:cdiobj.DoctorType="D" ret=ret_"主任会诊"
	s:cdiobj.DoctorType="C" ret=ret_"普通会诊"
	q ret
}

ClassMethod Delete(id As %String) As %String
{
	q:id="" -1
	s a=##class(User.DHCConsultDepItm).%OpenId(id)
	TStart
	s sc=a.%DeleteId(id)
	I $$$ISERR(sc)
	{
		TRollBack
		q "删除失败！"
	}
	else
	{
		TCommit
		q "删除成功！"
	}
}

/// d ##class(%ResultSet).RunQuery("User.DHCConsultDepItm","FindLinkData",^objyf55)
Query FindLinkData(parr As %String) As %Query(ROWSPEC = "rw,depid,DepCode,DepDesc,itmid,ItmCode,ItmDesc,contype,ConTypDesc,doctype,DocTypDesc,howToCreateCode,HowToCreate")
{
}

ClassMethod FindLinkDataExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	;i parr="" { Set qHandle=$lb(0,repid,0) Quit $$$OK }
	s pdepid=$P(parr,"^",1)  //科室
	s pdepid=$zcvt(pdepid,"U")
	s pitmid=$tr($P(parr,"^",2),"__","||") //医嘱项
	b ;
	s cdiid="" f  s cdiid=$O(^User.DHCConsultDepItmI("Dep",cdiid)) q:cdiid=""  d
	.s howTo="" f  s howTo=$O(^User.DHCConsultDepItmI("Dep",cdiid,howTo)) q:howTo=""  d
	..s chl="" f  s chl=$O(^User.DHCConsultDepItmI("Dep",cdiid,howTo,chl)) q:chl=""  d
	...b ;33
	...s cdiobj=##class(User.DHCConsultDepItm).%OpenId(chl)
	...s depid=cdiobj.ConsultDepDr
	...s itmid=cdiobj.ConsultItmDr
	...q:((pdepid="DF")||(pdepid="ALL"))&(pdepid'=depid)
	...q:(pdepid'="")&(pdepid'=depid)&&(pdepid'="DF")&&(pdepid'="ALL")
	...q:(pitmid'="")&(pitmid'=itmid)&&(pdepid'="DF")&&(pdepid'="ALL")
	...I depid="ALL" d
	....s depcode="ALL"
	....s depdesc="全院通用"
	...i depid="DF" d
	....s depcode="DF"
	....s depdesc="默认医嘱"
	...i (depid'="")&&(depid'="ALL")&&(depid'="DF") d
	....s depcode=$P(^CTLOC(depid),"^",1)
	....s depdesc=$P(^CTLOC(depid),"^",2)
	
	...;s itemid=$tr(cdiobj.ConsultItmDr,"||","__")
	...s itmcode="",itmdesc=""
	...i itmid'="" d
	....s itmcode=$P(^ARCIM($P(itmid,"||",1),$P(itmid,"||",2),1),"^",1)
	....s itmdesc=$P(^ARCIM($P(itmid,"||",1),$P(itmid,"||",2),1),"^",2)
	...s ConTypDesc=""
	...s contype=cdiobj.ConsultType
	...i contype="I" s ConTypDesc="院内会诊"
	...i contype="O" s ConTypDesc="院外会诊"
	...s doctype=cdiobj.DoctorType
	...s DocTypDesc=""
	...i $ISVALIDNUM(doctype) s DocTypDesc=$P(^CT("CPT",doctype),"^",2)
	...;i doctype="D" s DocTypDesc="主任医师"
	...;i doctype="A" s DocTypDesc="副主任医师"
	...;i doctype="C" s DocTypDesc="主治医师"
	...;i doctype="P" s DocTypDesc="知名专家"
	...s howToCreateCode=cdiobj.ConsultHowToCreate
	...s HowToCreate=""
	...i howToCreateCode="E" s HowToCreate="执行会诊"
	...i howToCreateCode="A" s HowToCreate="申请会诊"
	
	...d OutputLinkRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputLinkRow      
	set Data=$lb(chl,depid,$g(depcode),$g(depdesc),$tr(itmid,"||","__"),$g(itmcode),$g(itmdesc),contype,$g(ConTypDesc),doctype,$g(DocTypDesc),howToCreateCode,$g(HowToCreate))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindLinkDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLinkDataExecute ]
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

ClassMethod FindLinkDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLinkDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(%ResultSet).Runquery("User.DHCConsultDepItm","FindLocData","")
Query FindLocData(parr As %String) As %Query(ROWSPEC = "id,desc")
{
}

ClassMethod FindLocDataExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ^TempXBL(+$h)=parr
	s rw="ALL",c="全院通用"
	d OutputLocRow
	s rw="DF",c="默认医嘱"
	d OutputLocRow
	s rw="" f  s rw=$O(^CTLOC(rw)) q:rw=""  d
 	.s a=$P(^CTLOC(rw),"^")
 	.s c=$P(^CTLOC(rw),"^",2)
 	.s spell = $$ALPHAUP^SSUTIL4($P($g(^CTLOC(rw)),"^",43))
 	.s group=$P(^CTLOC(rw),"^",19)
 	.q:group'=2
 	.q:c=""
    .q:(parr'="")&(c'[parr)&(spell'[$$ALPHAUP^SSUTIL4(parr)) 
    .;s ret="id|"_rw_"^desc|"_c
    .d OutputLocRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputLocRow      
	set Data=$lb(rw,c)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindLocDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLocDataExecute ]
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

ClassMethod FindLocDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLocDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("User.DHCConsultDepItm","FindItmData","")
Query FindItmData(parr As %String) As %Query(ROWSPEC = "id,desc")
{
}

ClassMethod GetAbsTime(dt As %String) As %String
{
 //将日期时间转换成秒
  //n (dt)
  s dat=$P(dt,",",1),tim=$P(dt,",",2)
  q ((dat*86400)+tim)
}

ClassMethod FindItmDataExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s dtpar=+$h_","_$p($h,".",2)
	s itmdesc="" f  s itmdesc=$O(^ARCIM(0,"Desc",itmdesc)) q:itmdesc=""  d
	.q:(itmdesc'["会诊")!((parr'="")&(itmdesc'[$zcvt(parr,"U")))
	.s itmsid="" f  s itmsid=$O(^ARCIM(0,"Desc",itmdesc,itmsid)) q:itmsid=""  d
	..s itmvid="" f  s itmvid=$O(^ARCIM(0,"Desc",itmdesc,itmsid,itmvid)) q:itmvid=""  d
	...s itmdesc1=$P(^ARCIM(itmsid,itmvid,1),"^",2)
	...s EDT=$P(^ARCIM(itmsid,itmvid,7),"^",1)  //EndDTo
	...q:itmdesc'["会诊"
	...q:(EDT'="")&&(EDT<=+$h)
	...;s ret="id|"_itmsid_"__"_itmvid_"^desc|"_itmdesc1
	...d OutputItmRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputItmRow      
	set Data=$lb(itmsid_"__"_itmvid,itmdesc1)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindItmDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindItmDataExecute ]
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

ClassMethod FindItmDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindItmDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Storage Default
{
<Data name="DHCConsultDepItmDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ConsultDepDr</Value>
</Value>
<Value name="3">
<Value>ConsultItmDr</Value>
</Value>
<Value name="4">
<Value>ConsultType</Value>
</Value>
<Value name="5">
<Value>DoctorType</Value>
</Value>
<Value name="6">
<Value>ConsultPrice</Value>
</Value>
<Value name="7">
<Value>ConsultHowToCreate</Value>
</Value>
</Data>
<DataLocation>^User.DHCConsultDepItmD</DataLocation>
<DefaultData>DHCConsultDepItmDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCConsultDepItmD</IdLocation>
<IndexLocation>^User.DHCConsultDepItmI</IndexLocation>
<StreamLocation>^User.DHCConsultDepItmS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
