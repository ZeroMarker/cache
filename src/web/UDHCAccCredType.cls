Import SQLUser

Class web.UDHCAccCredType Extends (DHCDoc.Util.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 46;

ClassMethod getdefaultCredType() As %Library.String
{
	s defCredType="",defCredTypeID="",active="N",defCredTypeROWID=""
	q:'$d(^DHCACCCredType("0","DFT","Y")) "-1^^"
	s rtn="-1"
	f  s defCredTypeID=$o(^DHCACCCredType("0","DFT","Y",defCredTypeID))  q:(defCredTypeID="")!(active="Y")  d
	.s active=$p($g(^DHCACCCredType(defCredTypeID)),"^",4)
	.q:active'="Y"
	.s defCredType=$p($g(^DHCACCCredType(defCredTypeID)),"^",1)
	.s defCredTypeROWID=defCredTypeID
	.s rtn=0
	q rtn_"^"_defCredType_"^"_defCredTypeROWID
}

ClassMethod insertCredType(code As %Library.String = "", desc As %Library.String = "", def As %Library.String = "", act As %Library.String = "", DateFrom As %String, DateTo As %String) As %Library.String
{
	q:$d(^DHCACCCredType("0","Code",code)) "-316"
	k PLIST
	s PLIST(2)=code
	s PLIST(3)=desc
	s PLIST(4)=def
	s PLIST(5)=act
	s DateFrom=$g(DateFrom) 
	s DateTo=$g(DateTo)
	
	i +DateFrom'=0 d
	.s PLIST(6)=..%ZDH(DateFrom) //$zdh(DateFrom,4)
	e  d
	.s PLIST(6)=""
	i +DateTo'=0 d
	.s PLIST(7)=..%ZDH(DateTo) //$zdh(DateTo,4)
	e  d
	.s PLIST(7)=""
	
	i ((PLIST(6)>+PLIST(7))&(+PLIST(7)'="0")) q "DateErr"
	s $ZT="ERROR^DHCSSERR" d ##Class(web.UDHCCardRef).tb()
	s ren=##Class(web.UDHCCredType).INSERT()
	i ren=0  d ##Class(web.UDHCCardRef).tc()
	e  TROLLBACK
	q ren
}

ClassMethod updateCredType(code As %Library.String = "", desc As %Library.String = "", def As %Library.String = "", act As %Library.String = "", ID As %Library.String = "", DateFrom As %String, DateTo As %String) As %Library.String
{
	s ^RP("updateCredType")=def
	s sid=$o(^DHCACCCredType("0","Code",code,""))
	q:(sid'="")&(sid'=ID) "-316"
	k PLIST
	s PLIST(2)=code
	s PLIST(3)=desc
	s PLIST(4)=def
	s PLIST(5)=act
	
	i def="Y"{
		s ckDef=..checkSetDef()
		Q:(ckDef'="")&&(ckDef'=ID) "DEF"
	}
	
	s DateFrom=$g(DateFrom) 
	s DateTo=$g(DateTo)
	
	i +DateFrom'=0 d
	.s PLIST(6)=..%ZDH(DateFrom) //$zdh(DateFrom,4)
	e  d
	.s PLIST(6)=""
	i +DateTo'=0 d
	.s PLIST(7)=..%ZDH(DateTo) //$zdh(DateTo,4)
	e  d
	.s PLIST(7)=""
	i ((PLIST(6)>+PLIST(7))&(+PLIST(7)'="0")) q "DateErr"
	s $ZT="ERROR^DHCSSERR" d ##Class(web.UDHCCardRef).tb()
	s ren=##Class(web.UDHCCredType).UPDATE(ID)
	i ren=0  d ##Class(web.UDHCCardRef).tc()
	e  TROLLBACK
	q ren
}

/// ^DHCACCCredType
ClassMethod checkSetDef()
{
	s Ret=""
	s Ret=$O(^DHCACCCredType(0,"DFT","Y",""))
	Q Ret
}

ClassMethod FindCredTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCredTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod FindCredTypeExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	s rowid=0
	f  s rowid=$o(^DHCACCCredType(rowid)) q:rowid=""  d
	.s code=$p(^DHCACCCredType(rowid),"^",1)
	.s desc=$p(^DHCACCCredType(rowid),"^",2)
	.s default=$p(^DHCACCCredType(rowid),"^",3)
	.s active=$p(^DHCACCCredType(rowid),"^",4)
	.s rowid0=rowid
 	
 	;^PAC("CARD",{CRT_RowID})
	s rowid=0
	f  s rowid=$o(^PAC("CARD",rowid)) q:rowid=""  d
	.s code=$p(^PAC("CARD",rowid),"^",1)
	.s desc=$p(^PAC("CARD",rowid),"^",2)
	.s active=$p($g(^PAC("CARD",rowid,"DHC")),"^",1)
	.s default=$p($g(^PAC("CARD",rowid,"DHC")),"^",2)
	.s CredNoRequired=$p($g(^PAC("CARD",rowid,"DHC")),"^",3)
	.s myDateFrom=$p(^PAC("CARD",rowid),"^",3)
	.s:myDateFrom'="" myDateFrom=..%ZD(myDateFrom) //$zd(myDateFrom,4)
	.s myDateTo=$p(^PAC("CARD",rowid),"^",4)
	.s:myDateTo'="" myDateTo=..%ZD(myDateTo) //$zd(myDateTo,4)
	.s rowid0=rowid
 	.Do OutputRow1	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow1
	set Data=$lb(code,desc,rowid0,default,active, myDateFrom, myDateTo, CredNoRequired)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindCredTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCredTypeExecute ]
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

Query FindCredType() As %Query(ROWSPEC = "TCredCode:%String,TCredDesc:%String,TCredTypeID:%String,TSureFlag:%String,TActive:%String, TDateFrom:%String, TDateTo:%String, TCredNoRequired:%String")
{
}

ClassMethod SaveByJson(RowId As %String, JsonStr As %String)
{
	s ^dhcInsertByJson=RowId_","_JsonStr
	s jsonObj={}
	s jsonObj=jsonObj.%FromJSON(JsonStr)
	
	s sid=$o(^DHCACCCredType("0","Code",jsonObj.CRTCode,""))
	if (sid'="") {
		Q:(RowId'="")&(sid'=RowId) "-316"
		Q:(RowId="") "-316"
	}
	s sid=$o(^DHCACCCredType("0","Desc",$$ALPHAUP^SSUTIL4(jsonObj.CRTDesc),""))
	if (sid'="") {
		Q:(RowId'="")&(sid'=RowId) "-317"
		Q:(RowId="") "-317"
	}
	s def="N"
	s myobj=##class(%Dictionary.CompiledClass).%OpenId("User.DHCCredType")
	s myCount = myobj.Properties.Count()
	k PLIST
	s myParList=""
	f i=1:1:myCount {
		s mypropobj=myobj.Properties.GetAt(i)
		s PropertyName=mypropobj.Name
		continue:jsonObj.%GetTypeOf(PropertyName)="unassigned" 
		s val=jsonObj.%Get(PropertyName)
		s dataType=mypropobj.Type
		if dataType="%Library.Date"{
			s val=..%ZDH(val)	
		}
		s sqlNum=mypropobj.SqlColumnNumber
		s PLIST(sqlNum)=val
		if (sqlNum=4){
			s def=val
		}
	}
	i def="Y"{
		s ckDef=..checkSetDef()
		Q:(ckDef'="")&&(RowId'="")&&(ckDef'=RowId) "DEF"
		Q:(ckDef'="")&&(RowId="") "DEF"
	}
	i ((PLIST(6)>+PLIST(7))&(+PLIST(7)'="0")) q "DateErr"
	
	
	if '$d(PLIST) Quit -1
	b //45
	if RowId=""{
		&sql(insert into SQLUSER.DHC_CredType values :PLIST())
	}else{
		&sql(update SQLUSER.DHC_CredType values :PLIST() where CRT_RowID=:RowId)
	}
	Quit SQLCODE
}

/// w ##class(web.DHCBL.CARD.CardHardComManager).GetDataJson(13,^dhcGetCardTypeDataJson)
ClassMethod GetDataJson(RowId As %String, jsonFiledStr As %String)
{
	s ^dhcGetCardTypeDataJson=jsonFiledStr
	&sql(select * into :PLIST() from SQLUSER.DHC_CredType where CRT_RowID=:RowId)
	if SQLCODE'=0 Quit ""
	s jsonFiled=##class(%Library.DynamicObject).%FromJSON(jsonFiledStr)
	s jsonData={}
	s myobj=##class(%Dictionary.CompiledClass).%OpenId("User.DHCCredType")
	s myCount = myobj.Properties.Count()
	//k PLIST
	s myParList=""
	f i=1:1:myCount {
		s mypropobj=myobj.Properties.GetAt(i)
		s PropertyName=mypropobj.Name
		s dataType=mypropobj.Type
		continue:jsonFiled.%GetTypeOf(PropertyName)="unassigned" 
		s sqlNum=mypropobj.SqlColumnNumber
		continue:sqlNum=""
		s val=$g(PLIST(sqlNum))
		if dataType="%Library.Date"{
			s val=..%ZD(val)
		}
		
		s filedName=jsonFiled.%Get(PropertyName)
		do jsonData.%Set(filedName,val)
	}
	
	Quit jsonData.%ToJSON()
}

/// Desc：获取有效的证件类型
/// Output：Json串
/// debugger：w ##class(web.UDHCAccCredType).GetActiveCredType()
ClassMethod GetActiveCredType()
{
	set List=[]
	Set rset=##class(%ResultSet).%New("web.UDHCAccCredType:FindCredType")
	do rset.Execute()
	Set columns = rset.GetColumnCount()
	While (rset.Next()) {
		set Active=rset.Data("TActive")
		Continue:Active'="Y"
		set Obj={}
		for col=1:1:columns{
			set Name=rset.GetColumnName(col)
			set Val=rset.Data(Name)
			do Obj.%Set(Name,Val)
		}
		do List.%Push(Obj)
	}
	Q List.%ToJSON()
}

}
