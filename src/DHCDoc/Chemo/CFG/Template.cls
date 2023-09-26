/// CTOR: QP
/// DATE: 2020-04-26
/// DESC: 模板维护
Class DHCDoc.Chemo.CFG.Template Extends DHCDoc.Util.RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-04-26
/// DESC: 保存模板
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.CFG.Template).SaveTPL("903||1")
ClassMethod SaveTPL(mList As %String, importObj As DHCDoc.Chemo.Model.ImportTPL = "")
{
	S ^QP("SaveTPL")=mList
	if (importObj="") {
		s id=$p(mList,"^",1)
		s type=$p(mList,"^",2)
		s desc=$p(mList,"^",3)
		s name=$p(mList,"^",4)
		s stagenum=$p(mList,"^",5)
		s active=$p(mList,"^",6)
		s user=$p(mList,"^",7)
		s mainNote=$p(mList,"^",8)
		s title=$p(mList,"^",9)
		s othername=$p(mList,"^",10)
		s otherdesc=$p(mList,"^",11)
		s otherloc=$p(mList,"^",12)
		s hosp=$p(mList,"^",13)
		Q:hosp="" "-99"
	} else {
		s id=""
		s type=importObj.TPType
		s desc=importObj.TPDesc
		s name=importObj.TPName
		s stagenum=importObj.TPStageNum
		s active="Y"
		s user=""
		s mainNote=""
		s title=""
		s othername=""
		s otherdesc=""
		s otherloc=""
		s hosp=importObj.TPHosp
		i hosp="" {
			i type="HOSP" {
				s hosp=desc
			}elseif type="DEP" {
				s hosp=$P(^CTLOC(desc),"^",22)
			}else{
				s defaultLoc=$p(^SSU("SSUSR",desc),"^",4)
				i defaultLoc'="" s hosp=$P(^CTLOC(defaultLoc),"^",22)
			}
		}
		Q:hosp="" "-99"
		/*i $d(^CF.DOC.Chemo.TemplateI("ChemoTemplate","TPTypeDescName",type,desc,name)) {
			s id=$o(^CF.DOC.Chemo.TemplateI("ChemoTemplate","TPTypeDescName",type,desc,name,""))	
		}*/
		i $d(^CF.DOC.Chemo.TemplateI("ChemoTemplate","Hosp",hosp,type,desc,name)) {
			s id=$o(^CF.DOC.Chemo.TemplateI("ChemoTemplate","Hosp",hosp,type,desc,name,""))	
		}
	}
	s cDate=+$h
	s cTime=$p($h,",",2)
	s hasFlag=..HasTPL(id,type,desc,name,hosp)
	q:hasFlag=1 "-99"
	i id="" {
		s a=##class(User.ChemoTemplate).%New()
		s a.TPCreateDate=cDate
		s a.TPCreateTime=cTime
		d a.TPHospSetObjectId(hosp)
		d a.TPCreateUserSetObjectId(user)
	} else {
		s a=##class(User.ChemoTemplate).%OpenId(id)
	}
	s a.TPType=type
	s a.TPDesc=desc
	s a.TPName=name
	s a.TPStageNum=stagenum
	s a.TPActive=active
	s a.TPUpdateDate=cDate
	s a.TPUpdateTime=cTime
	d a.TPUpdateUserSetObjectId(user)
	s a.TPMainNote=mainNote
	s a.TPTitle=title
	s a.TPOtherName=othername
	s a.TPOtherDesc=otherdesc
	s a.TPOtherLoc=otherloc
	s sc=a.%Save()
	If $$$ISERR(sc) {
		//d $system.OBJ.DisplayError(sc) 
		Quit "-101"
	}
	Q a.%Id()
	Q 0
}

/// CTOR: QP
/// DATE: 2020-08-20
/// DESC: 是否存在
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.CFG.Template).HasTPL("262","HOSP","2","替吉奥S1方案（晚期乳腺癌路上皮癌化疗方案）")
ClassMethod HasTPL(id, type, desc, name, hosp)
{
	
	s ^QP("HH",1)=$LB(id,type,desc,name,hosp)
	s ^QP("HH",2)=name
	s mRtn=0
	if (id="") {
		;Q:$d(^CF.DOC.Chemo.TemplateI("ChemoTemplate","TPTypeDescName",type,desc,name)) 1
		Q:$d(^CF.DOC.Chemo.TemplateI("ChemoTemplate","Hosp",hosp,type,desc,name)) 1


	} else {
		s oldType=$p(^CF.DOC.Chemo.TemplateD(id),"^",1)
		s oldDesc=$p(^CF.DOC.Chemo.TemplateD(id),"^",2)
		s oldName=$p(^CF.DOC.Chemo.TemplateD(id),"^",3)
		s oldHosp=$p(^CF.DOC.Chemo.TemplateD(id),"^",17)
		;s flag=$d(^CF.DOC.Chemo.TemplateI("ChemoTemplate","TPTypeDescName",type,desc,name))
		s flag=$d(^CF.DOC.Chemo.TemplateI("ChemoTemplate","Hosp",hosp,type,desc,name))
		
		i (oldType=type)&&(oldDesc=desc)&&(oldName=name)&&(oldHosp=hosp) {
			//TODO
		} else {
			if flag=1 {
				Q 1		
			} else {
				//TODO
			}
			
		}
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-04-26
/// DESC: 删除模板
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.THPY.CFG.Tpl).DeleteTPL("54")
ClassMethod DeleteTPL(TPID As %String)
{

	Q:TPID="" 0
	TS
	s mRtn=##class(DHCDoc.Chemo.CFG.ChgReason).DeleteByTPL(TPID)
	i (mRtn'=0)&&(mRtn'=100) {
		TRO
		Q "-102"
	}
	&SQL(DELETE FROM SQLUser.Chemo_Template WHERE TP_ID=:TPID)
	i SQLCODE'=0 {
		TRO
		Q "-102"
	}
	TC
	Q 0
}

/// CTOR: QP
/// DATE: 2020-04-26
/// DESC: 查询模板类型
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.THPY.CFG.Tpl","QryTPLType")
Query QryTPLType() As %Query(ROWSPEC = "id,text")
{
}

ClassMethod QryTPLTypeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	s id="USER",text="用户"
 	d output1
 	s id="DEP",text="科室"
 	d output1
 	s id="HOSP",text="医院"
 	d output1
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output1
	Set Data=$lb(id,text)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryTPLTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTPLTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryTPLTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTPLTypeExecute ]
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

/// CTOR: QP
/// DATE: 2020-04-26
/// DESC: 查询模板描述
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.THPY.CFG.Tpl","QryTPLDesc","USER","Y")
Query QryTPLDesc(InType = "", q = "", InHosp = "") As %Query(ROWSPEC = "id,text")
{
}

ClassMethod QryTPLDescExecute(ByRef qHandle As %Binary, InType = "", q = "", InHosp = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	if (InType="") {
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s InDesc=""
	i q'="" {
		s InDesc=q
		s InDesc=$zcvt(InDesc,"U")
	}
	
	if (InType="USER") {
		s uid=0
	    f  s uid=$o(^SSU("SSUSR",uid)) q:uid=""  d
	    .s docid=$p(^SSU("SSUSR",uid),"^",14)
	    .s active=$p(^SSU("SSUSR",uid),"^",19)
	    .s StartDate=$p(^SSU("SSUSR",uid),"^",96)
	    .s EndDate=$p(^SSU("SSUSR",uid),"^",97)
	    .q:active'="Y"
	    .q:(StartDate'="")&&(StartDate>+$h)
		.q:(EndDate'="")&&(EndDate<+$h)
	    .;q:docid=""
	    .s (ctpid,docType,otherName)=""
	    .i docid'="" d
	    ..q:'$d(^CTPCP(docid,1))
	    ..s ctpid=$p(^CTPCP(docid,1),"^",4)
	    .;q:ctpid=""
	    .i ctpid'="" s docType=$p(^CT("CPT",ctpid),"^",4)
	    .;q:docType'="DOCTOR"
	    .s defaultLoc=$p(^SSU("SSUSR",uid),"^",4)
	    .s defaultLocDesc=""
	    .i defaultLoc'="" s defaultLocDesc=$p(^CTLOC(defaultLoc),"^",2)
		.s jobNum=$p(^SSU("SSUSR",uid),"^",1)
		.s jobNumUp=$zcvt(jobNum,"U")
		.s userName=$p(^SSU("SSUSR",uid),"^",2)
		.s userNameUp=$zcvt(userName,"U")
		.i docid'="" d
		..q:'$d(^CTPCP(docid,3))
		..s otherName=$p(^CTPCP(docid,3),"^",28)
		..s otherName=$zcvt(otherName,"U")
		.s exit=1
		.i InDesc'="" d
		..i otherName[InDesc s exit=0
		..i userNameUp[InDesc s exit=0
		..i jobNumUp[InDesc s exit=0
		.q:(exit=1)&&(InDesc'="")
		.s id=uid
		.s text=userName
		.d output2
	}
	if (InType="DEP") {
		Set CTLOCID=0
		F  s CTLOCID=$O(^CTLOC(CTLOCID)) q:CTLOCID=""  d 
		.S locDesc=$P($G(^CTLOC(CTLOCID)),"^",2)
		.S HospDr=$P($G(^CTLOC(CTLOCID)),"^",22)
		.S StartDate=$P($G(^CTLOC(CTLOCID)),"^",24)
		.S EndDate=$P($G(^CTLOC(CTLOCID)),"^",25)
		.q:(StartDate'="")&&(StartDate>+$h)
		.q:(EndDate'="")&&(EndDate<+$h)
		.q:(InHosp'="")&&(InHosp'=HospDr)
		.S contactName=$P($G(^CTLOC(CTLOCID)),"^",43)
		.s contactName=$zcvt(contactName,"U")
		.i locDesc["-" s locDesc=$p(locDesc,"-",2)
		.q:((InDesc'="")&&(contactName'[InDesc))&&((InDesc'="")&&(locDesc'[InDesc))
		.s id=CTLOCID
		.s text=locDesc
		.d output2
	}
	if (InType="HOSP") {
		s id=0
		f  s id=$o(^CT("HOSP",id)) q:id=""  d
		.s text=$p(^CT("HOSP",id),"^",2)
		.q:(InHosp'="")&&(id'=InHosp)
		.s dateFrom=$p(^CT("HOSP",id),"^",9)
		.s dateTo=$p(^CT("HOSP",id),"^",10)
		.q:(dateFrom'="")&&(dateFrom>+$H)
		.q:(dateTo'="")&&(dateTo<+$H)
		.d output2
	}
	
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output2
	if (InType="USER"){
		s AllHosp=$p(^SSU("SSUSR",uid),"^",98)	;
		s sub=""
		f  s sub=$o(^SSU("SSUSR",uid,"OTHLL",sub)) q:sub=""  d
		.s cHosp=$p(^SSU("SSUSR",uid,"OTHLL",sub),"^",3)
		.q:cHosp=""
		.i AllHosp="" s AllHosp=cHosp
		.e  d
		..i ##class(DHCAnt.KSS.Common.Method).InArray(AllHosp,cHosp)'=1 s AllHosp=AllHosp_","_cHosp
		q:(InHosp'="")&&(##class(DHCAnt.KSS.Common.Method).InArray(AllHosp,InHosp)'=1)
	}
	Set Data=$lb(id,text)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryTPLDescClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTPLDescExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryTPLDescFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTPLDescExecute ]
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

/// CTOR: QP
/// DATE: 2020-04-26
/// DESC: 查询模板
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.Chemo.CFG.Template","QryTPL")
Query QryTPL(InType = "", InDesc = "", InActive = "", InHosp = "") As %Query(ROWSPEC = "id,type,typeDesc,desc,descDesc,name,stagenum,active,mainNote,title,hospName")
{
}

ClassMethod QryTPLExecute(ByRef qHandle As %Binary, InType = "", InDesc = "", InActive = "", InHosp = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	s id=""
 	f  s id=$o(^CF.DOC.Chemo.TemplateD(id),-1) q:id=""  d
 	.s type=$p(^CF.DOC.Chemo.TemplateD(id),"^",1)
 	.q:(InType'="")&&(InType'=type)
 	.s typeDesc=##class(DHCDoc.Chemo.COM.Func).GetTPLTypeDesc(type)
	.s desc=$p(^CF.DOC.Chemo.TemplateD(id),"^",2)
	.s descDesc=##class(DHCDoc.Chemo.COM.Func).GetTPLDesc(id)
	.s name=$p(^CF.DOC.Chemo.TemplateD(id),"^",3)
	.s stagenum=$p(^CF.DOC.Chemo.TemplateD(id),"^",4)
	.s active=$p(^CF.DOC.Chemo.TemplateD(id),"^",5)
	.q:(InActive'="")&&(InActive'=active)
	.s mainNote=$p(^CF.DOC.Chemo.TemplateD(id),"^",12)
	.s title=$p(^CF.DOC.Chemo.TemplateD(id),"^",13)
	.s otherName=$p(^CF.DOC.Chemo.TemplateD(id),"^",14)
	.s hosp=$p(^CF.DOC.Chemo.TemplateD(id),"^",17)
	.q:(InHosp'="")&&(InHosp'=hosp)
	.s hospName=""
	.i hosp'="" s hospName=$p(^CT("HOSP",hosp),"^",2)
	.s isEixt=1
	.i InDesc'="" d
	..s InDesc=$zcvt(InDesc,"U")
	..S CName=$zcvt(name,"U")
	..S TName=$zcvt(otherName,"U")
	..i CName[InDesc s isEixt=0
	..i TName[InDesc S isEixt=0
	.e  d
	..s isEixt=0
	.q:isEixt=1
 	.d output3
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output3
	Set Data=$lb(id,type,typeDesc,desc,descDesc,name,stagenum,active,mainNote,title,hospName)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryTPLClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTPLExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryTPLFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTPLExecute ]
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

/// CTOR: QP
/// DATE: 2020-04-26
/// DESC: 获取化疗方案Title
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.CFG.Template).GetTPLTitle("")
ClassMethod GetTPLTitle(TPID As %String)
{
	s langid=..%LanguageID()
	s mRtn=""
	Q:TPID="" mRtn
	s mRtn=$p(^CF.DOC.Chemo.TemplateD(TPID),"^",13)
	s mRtn=##class(DHCDoc.Chemo.COM.Func2).FilterToHtml(mRtn)
	s mRtn=##class(User.ChemoTemplate).GetTranByDesc("TPTitle",mRtn,langid)
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-10-28
/// DESC: 保存模板备注及标题
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.CFG.Template).SaveTPLNote("903||1")
ClassMethod SaveTPLNote(importObj As DHCDoc.Chemo.Model.ImportTPLNote = "")
{
	s a=##class(User.ChemoTemplate).%OpenId(importObj.TPID)
	s a.TPMainNote=importObj.TPNote
	s a.TPTitle=importObj.TPTitle
	s a.TPOtherName=importObj.TPOtherName
	s sc=a.%Save()
	If $$$ISERR(sc) {
		//d $system.OBJ.DisplayError(sc) 
		Quit "-146"
	}
	Q 1
}

/// CTOR: QP
/// DATE: 2018-10-23
/// DESC: 插入/更新,调用的触发程序
/// IN  : 
/// OUT : 1(成功)
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.CFG.Template).OnTrigger()
ClassMethod OnTrigger(parref As %String, type As %String = "") As %Status
{
	s rtn=1
	s ParObj=##class(User.ChemoTemplate).%OpenId(parref)
	if $ISOBJECT(ParObj) {
		
		if type="TAfterIns" {
			s OtherDesc=ParObj.TPOtherDesc
			
		}
		if type="TAfterUpd" {
			
			b ;001
			
		}
		
	}

	Q rtn
}

/// CTOR: QP
/// DATE: 2020-04-26
/// DESC: 删除模板
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.CFG.Template).Test(1,3)
ClassMethod Test(TPID As %String, DESC)
{
	Q:TPID="" 0
	&SQL(
		UPDATE SQLUser.Chemo_Template 
		SET TP_OtherDesc=:DESC
		WHERE TP_ID=:TPID
	)
	
	
	Q 0
}

}
