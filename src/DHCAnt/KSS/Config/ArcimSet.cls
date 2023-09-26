/// CTOR: QP
/// DATE: 2019-04-16
/// DESC: 抗菌药物医嘱项设置
Class DHCAnt.KSS.Config.ArcimSet Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2016-08-19
/// DESC: 保存医嘱项设置
/// IN  : rowId + "^" + ArcimRowid + "^" + cqmx + "^" + tgc + "^" + lab
/// OUT : 
/// TABL: DHCAnt_Base.ItmMast
/// EXEC: w ##class(DHCAnt.KSS.Config.ArcimSet).Save(^TEMP("qp",1))
ClassMethod Save(inPara As %String)
{
	n (inPara)
	s ^TEMP("qp",1)=inPara
	s mRtn = 1
	s id=$p(inPara,"^",1)
	s arcim=$p(inPara,"^",2)
	s cqmx=$p(inPara,"^",3)
	s tgc=$p(inPara,"^",4)
	s lab=$p(inPara,"^",5)
	s hosp=$p(inPara,"^",6)
	q:hosp="" "-2" //院区为空
	TS
	i id="" {
		//q:$d(^CF.ANT.ItmMastI("ARCIM",arcim)) "-1"	//配置已存在
		q:$d(^CF.ANT.ItmMastI("HospArcim",hosp,arcim)) "-1"	//配置已存在
		s a=##class(DHCAnt.Base.ItmMast).%New()
		
	} else {
		s a=##class(DHCAnt.Base.ItmMast).%OpenId(id)
		s oldArcim=a.ARCIMDRGetObjectId()
		s oldHosp=a.Hosp
		//q:($d(^CF.ANT.ItmMastI("ARCIM",arcim)))&&(oldArcim'=arcim) "-1"	//配置已存在
		q:$d(^CF.ANT.ItmMastI("HospArcim",hosp,arcim))&&((oldArcim'=arcim)||(oldHosp'=hosp)) "-1"	//配置已存在
	}
	d a.ARCIMDRSetObjectId(arcim)
	s a.CQMX=cqmx
	s a.TGC=tgc
	s a.LAB=lab
	s a.Hosp=hosp
	b ;001
	s sc=a.%Save()
	If $$$ISERR(sc) {	//QP
		//d $system.OBJ.DisplayError(sc) 
		TRollback
		Quit "-100"
	}
	//兼容老版本ANT-4.4--
	/*
	s result=##class(DHCAnt.Base.MainConfigExcute).SetValueByMCGCode("CQMX",arcim)
	i result'=1 {
		TRollback
		Quit "-2"	//老版本配置更新失败
	}
	s result=##class(DHCAnt.Base.MainConfigExcute).SetValueByMCGCode("TGC",arcim)
	i result'=1 {
		TRollback
		Quit "-2"	//老版本配置更新失败
	}
	s result=##class(DHCAnt.Base.MainConfigExcute).SetValueByMCGCode("LABARCIM",arcim)
	i result'=1 {
		TRollback
		Quit "-2"	//老版本配置更新失败
	}
	*/
	TC
	///
	q mRtn
}

/// Creator：     QP
/// CreatDate：   2019-04-16
/// Description:  根据类型和父类型查找所有的子类集合
/// Table：  DHCAnt_Base.ItmMast  
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCAnt.KSS.Config.ArcimSet","QryANTArcim","")
Query QryANTArcim(ArcimRowid = "", InHosp = "") As %Query(ROWSPEC = "rowId,arcim,arcimDesc,cqmx,tgc,lab,hosp,hospName")
{
}

ClassMethod QryANTArcimExecute(ByRef qHandle As %Binary, ArcimRowid = "", InHosp = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	i ArcimRowid'="" d
 	.s rowId=""
 	.f  s rowId=$o(^CF.ANT.ItmMastI("ARCIM",ArcimRowid,rowId)) q:rowId=""  d 
 	..s cqmx=$p(^CF.ANT.ItmMastD(rowId),"^",2)
 	..s tgc=$p(^CF.ANT.ItmMastD(rowId),"^",3)
 	..s lab=$p(^CF.ANT.ItmMastD(rowId),"^",4)
 	..s hosp=$p(^CF.ANT.ItmMastD(rowId),"^",5)
 	..s hospName=""
 	..i hosp'="" s hospName=$p(^CT("HOSP",hosp),"^",2)
 	..s arcim=ArcimRowid
 	..s arcimDesc=$p(^ARCIM(+arcim,$p(arcim,"||",2),1),"^",2)
 	..q:(InHosp'="")&&(hosp'=InHosp)
 	..d output1
 	e  d
 	.s rowId=0
 	.f  s rowId=$o(^CF.ANT.ItmMastD(rowId)) q:rowId=""  d
 	..s arcim=$p(^CF.ANT.ItmMastD(rowId),"^",1)
 	..s cqmx=$p(^CF.ANT.ItmMastD(rowId),"^",2)
 	..s tgc=$p(^CF.ANT.ItmMastD(rowId),"^",3)
 	..s lab=$p(^CF.ANT.ItmMastD(rowId),"^",4)
 	..s arcimDesc=$p(^ARCIM(+arcim,$p(arcim,"||",2),1),"^",2)
 	..s hosp=$p(^CF.ANT.ItmMastD(rowId),"^",5)
 	..s hospName=""
 	..i hosp'="" s hospName=$p(^CT("HOSP",hosp),"^",2)
 	..q:(InHosp'="")&&(hosp'=InHosp)
 	..d output1
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output1
	Set Data=$lb(rowId,arcim,arcimDesc,cqmx,tgc,lab,hosp,hospName)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryANTArcimClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryANTArcimExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryANTArcimFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryANTArcimExecute ]
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
/// DATE: 2016-08-19
/// DESC: 删除医嘱项设置
/// IN  : 
/// OUT : 
/// TABL: DHCAnt_Base.ItmMast
/// EXEC: w ##class(DHCAnt.KSS.Config.ArcimSet).Delete()
ClassMethod Delete(ids As %String)
{
	n (ids)
	s mRtn=0
	s Len=$l(ids,",")
	
	TS
	f i=1:1:Len {
		q:mRtn'=0
		s cid=$p(ids,",",i)
		&SQL(DELETE FROM DHCAnt_Base.ItmMast WHERE ITM_RowId=:cid)	
		i SQLCODE s mRtn=SQLCODE
	}
	
	i mRtn'=0 {
		tro
		q "-1"	
	}
	
	TC
	
	q mRtn
}

/// CTOR: QP
/// DESC: 院区
/// IN  : 
/// OUT : id,text
/// EXEC: d ##Class(%ResultSet).RunQuery("DHCAnt.KSS.Config.ArcimSet","QryHosp")
Query QryHosp() As %Query(ROWSPEC = "hosp:%String,hospName:%String,code")
{
}

ClassMethod QryHospExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    Set qHandle=$lb(0,repid,0)
    s id=0
  	f  s id=$o(^CT("HOSP",id)) q:id=""  d
  	.s text=$p(^CT("HOSP",id),"^",2)
    .d OutputRow22
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow22
    set Data=$lb(id,text)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1   
    quit
}

ClassMethod QryHospClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHospExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QryHospFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHospExecute ]
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
