/// CTOR: QP
/// DATE: 2020-09-08
/// DESC: 子项指标设置
Class DHCDoc.GCPSW.CFG.ItemKPI Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-09-08
/// DESC: 保存
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.CFG.ItemKPI).Save("903||1")
ClassMethod Save(ITID, mList)
{
	s mRtn=0
	s KTID=+ITID
	S Sub=$p(ITID,"||",2)
	s id=$p(mList,"^",1)
	s code=$p(mList,"^",2)
	s name=$p(mList,"^",3)
	s complex=$p(mList,"^",4)
	s note=$p(mList,"^",5)
	s user=$p(mList,"^",6)
	s express=$p(mList,"^",7)
	s arcim=$p(mList,"^",8)
	
	i id="" {
		s a=##class(User.GCPSWItemKPI).%New(ITID)
		d a.IKParrefSetObjectId(ITID)
		d a.IKAddUserSetObjectId(user)
		s a.IKAddDate=+$H
		s a.IKAddTime=$p($h,",",2)
		
		i $d(^CF.DOC.GCPSW.KPITypeI("ItemKPI","IKCode",KTID,Sub,code)) {
			Q -2
		}
	} else {
		s a=##class(User.GCPSWItemKPI).%OpenId(id)
		s oldCode=a.IKCode
		i $d(^CF.DOC.GCPSW.KPITypeI("ItemKPI","IKCode",KTID,Sub,code)) {
			i oldCode'=code {
				Q -2	
			}
		}
	}
	s a.IKCode=code
	s a.IKName=name
	s a.IKNote=note
	s a.IKComplex=complex
	s a.IKExpress=express
	s a.IKArcim=arcim
	s sc=a.%Save()
	If $$$ISERR(sc) {
		//d $system.OBJ.DisplayError(sc) 
		s mRtn=-101
	} else {
		s mRtn=a.%Id()
	}
	d a.%Close()
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-09-08
/// DESC: 删除
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.CFG.ItemKPI).Delete("")
ClassMethod Delete(IKID As %String)
{
	Q:IKID="" 0
	&SQL(DELETE FROM SQLUser.GCPSW_ItemKPI WHERE IK_ID=:IKID)
	Q:SQLCODE'=0 -102
	
	Q 0
}

/// CTOR: QP
/// DATE: 2020-09-08
/// DESC: 查询指标
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.GCPSW.CFG.ItemKPI","QryKPI","3||1","")
Query QryKPI(ITID = "", KPIContent = "") As %Query(ROWSPEC = "id,code,name,complex,note,express,arcim")
{
}

ClassMethod QryKPIExecute(ByRef qHandle As %Binary, ITID = "", KPIContent = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	/*i ITID="" {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK	
	}*/
	i ITID'="" {
		s KTID=+ITID
		S SUB=$P(ITID,"||",2)
	 	s CH=""
	 	f  s CH=$o(^CF.DOC.GCPSW.KPITypeD(KTID,"I",SUB,"K",CH)) q:CH=""  d
	 	.s id=ITID_"||"_CH
	 	.s code=$p(^CF.DOC.GCPSW.KPITypeD(KTID,"I",SUB,"K",CH),"^",1)
	 	.s name=$p(^CF.DOC.GCPSW.KPITypeD(KTID,"I",SUB,"K",CH),"^",2)
	 	.s complex=$p(^CF.DOC.GCPSW.KPITypeD(KTID,"I",SUB,"K",CH),"^",3)
	 	.s note=$p(^CF.DOC.GCPSW.KPITypeD(KTID,"I",SUB,"K",CH),"^",7)
	 	.s express=$p(^CF.DOC.GCPSW.KPITypeD(KTID,"I",SUB,"K",CH),"^",8)
	 	.s arcim=$p(^CF.DOC.GCPSW.KPITypeD(KTID,"I",SUB,"K",CH),"^",9)
	 	.q:+arcim=0
	 	.s arcim=##class(DHCDoc.GCPSW.CFG.Item).GetArcimDesc(arcim)
	 	.s exitFlag=$$IsExit(KPIContent,code,name,note)
		.q:exitFlag=1
	 	.d output1
	} else {
		s KTID=""
		f  s KTID=$o(^CF.DOC.GCPSW.KPITypeD(KTID)) q:KTID=""  d
		.s SUB=""
		.f  s SUB=$o(^CF.DOC.GCPSW.KPITypeD(KTID,"I",SUB)) q:SUB=""  d
		..s CH=""
	 	..f  s CH=$o(^CF.DOC.GCPSW.KPITypeD(KTID,"I",SUB,"K",CH)) q:CH=""  d
	 	...s id=KTID_"||"_SUB_"||"_CH
	 	...s code=$p(^CF.DOC.GCPSW.KPITypeD(KTID,"I",SUB,"K",CH),"^",1)
	 	...s name=$p(^CF.DOC.GCPSW.KPITypeD(KTID,"I",SUB,"K",CH),"^",2)
	 	...s complex=$p(^CF.DOC.GCPSW.KPITypeD(KTID,"I",SUB,"K",CH),"^",3)
	 	...s note=$p(^CF.DOC.GCPSW.KPITypeD(KTID,"I",SUB,"K",CH),"^",7)
	 	...s express=$p(^CF.DOC.GCPSW.KPITypeD(KTID,"I",SUB,"K",CH),"^",8)
	 	...s arcim=$p(^CF.DOC.GCPSW.KPITypeD(KTID,"I",SUB,"K",CH),"^",9)
	 	...s arcim=##class(DHCDoc.GCPSW.CFG.Item).GetArcimDesc(arcim)
	 	...s exitFlag=$$IsExit(KPIContent,code,name,note)
		...q:exitFlag=1
	 	...d output1
	 	
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
IsExit(KPIContent,code,name,note)
	s mRtn=1
	q:KPIContent="" 0
	s KPIContent=$zcvt(KPIContent,"U")
	s code=$zcvt(code,"U")
	s name=$zcvt(name,"U")
	s note=$zcvt(note,"U")
	q:code[KPIContent 0
	q:name[KPIContent 0
	q:note[KPIContent 0
	
	Q mRtn
	
output1
	Set Data=$lb(id,code,name,complex,note,express,arcim)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryKPIClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryKPIExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryKPIFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryKPIExecute ]
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
/// DATE: 2020-09-10
/// DESC: 根据code获取ID
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.CFG.ItemKPI).GetIdByCode("3||1","WhiteCell")
ClassMethod GetIdByCode(itemDR = "", itemCode = "")
{
	s mRtn=""
	Q:(itemDR="")||(itemCode="") mRtn
	s KTID=+itemDR,SUB=$P(itemDR,"||",2)
	
	q:'$d(^CF.DOC.GCPSW.KPITypeI("ItemKPI","IKCode",KTID,SUB,itemCode)) mRtn
	s id=$o(^CF.DOC.GCPSW.KPITypeI("ItemKPI","IKCode",KTID,SUB,itemCode,""))
	q:id="" mRtn
	s mRtn=itemDR_"||"_id


	Q mRtn
}

}
