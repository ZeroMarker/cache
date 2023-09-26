Import SQLUser

/// web.DHCDocExtData
/// 2011-1-24 刘铁英
/// 医联卡系统接口对照
Class web.DHCDocExtData Extends DHCDoc.Util.RegisteredObject
{

ClassMethod InsertExtData(Instr As %String) As %String
{
	k PLIST
	s PLIST(2)=$p(Instr,"^",1)
	s PLIST(3)=$p(Instr,"^",2)
	s PLIST(4)=$p(Instr,"^",3)
	s PLIST(5)=$p(Instr,"^",4)
	s PLIST(6)=$p(Instr,"^",5)
	s PLIST(7)=$p(Instr,"^",6)
	s PLIST(8)=$p(Instr,"^",7)
	s PLIST(9)=$p(Instr,"^",8)
	&sql(insert into DHC_DocExtData values :PLIST())
	q SQLCODE
}

ClassMethod ModifyExtData(InStr As %String, MUCRowid As %String) As %String
{
	q:MUCRowid="" 100
	s HISCodeRowId=$p(InStr,"^",1)
	s HisCode=$p(InStr,"^",2)
	s HisDesc=$p(InStr,"^",3)
	s MUCCode=$p(InStr,"^",4)
	s MUCDesc=$p(InStr,"^",5)
	s ActiveF=$p(InStr,"^",6)
	s ExtOrgID=$p(InStr,"^",7)
	&sql(update DHC_DocExtData set MUC_LocalDR=:HISCodeRowId,
	                               MUC_LocalCode=:HisCode,
	                               MUC_LocalDesc=:HisDesc,
	                               MUC_ExtCode=:MUCCode,
	                               MUC_ExtDesc=:MUCDesc,
	                               MUC_Active=:ActiveF,
	                               MUC_ExtOrgDr=:ExtOrgID
		                     where MUC_Rowid=:MUCRowid)
	
	q SQLCODE
}

ClassMethod DeleteExtData(MUCRowid As %String) As %String
{
	q:(MUCRowid="") 100
	&sql(delete from DHC_DocExtData where MUC_Rowid=:MUCRowid)
	
	q SQLCODE
}

ClassMethod RepeatExtData(SelectType As %String, HISCodeRowId As %String, MUCRowid As %String = "", ExtOrgID As %String = "") As %String
{
	q:(SelectType="")||(HISCodeRowId="") ""
	if ExtOrgID=""{
		q:'$d(^DHCMUC(0,"TYPELOCALDR",SelectType,HISCodeRowId)) "NR"
		s MucRowid=$o(^DHCMUC(0,"TYPELOCALDR",SelectType,HISCodeRowId,""))
		q:(MUCRowid'="")&&(MUCRowid'=MucRowid) "R"
		q:(MucRowid'="")&&(MUCRowid="") "R"
	}else{
		q:'$d(^DHCMUC(0,"ExtTYPELOCALDR",ExtOrgID,SelectType,HISCodeRowId)) "NR"
		s MucRowid=$o(^DHCMUC(0,"ExtTYPELOCALDR",ExtOrgID,SelectType,HISCodeRowId,""))
		q:(MUCRowid'="")&&(MUCRowid'=MucRowid) "R"
		q:(MucRowid'="")&&(MUCRowid="") "R"	
	}
	q 0
}

ClassMethod ExtDataTypeBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "")
{
	;w ##class(web.DHCDocExtData).ExtDataTypeBroker("","")
	 Set Status=0
	 Set value=""

	 Set rs=##Class(%ResultSet).%New("web.DHCDocCTExtDataType:QueryExtDataType")
	 If rs.QueryIsValid() { 
		 Set Status=rs.Execute()
		 Set columns = rs.GetColumnCount()

		 If 'Status Quit
		 While rs.Next() {
			s rowvalue=""
			s Active=rs.GetData(6)
			continue:Active="否"
			For col = 1:1:columns {
				;Write rs.GetColumnName(col),":"
				if col=1 set rowvalue=rs.GetData(col)
				e  s rowvalue=rowvalue_"^"_rs.GetData(col)
			}
			if value="" s value=rowvalue
			else  s value=value_$c(1)_rowvalue
		 }
	 }
	 if value'="" {
		 s retval=itmjs_"('"_$ZCVT(value,"O","JS")_"');"
		 i itmjsex'="" s retval=retval_itmjsex_"('"_$ZCVT(value,"O","JS")_"');"
		 &javascript<#(retval)#>
	 }
	 q 1
}

ClassMethod ExtDataQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ExtDataQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod ExtDataQueryExecute(ByRef qHandle As %Binary, SelectTypeCode As %String, Code As %String = "", Desc As %String = "", SelectExtOrg As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	
	;if SelectTypeCode="" Set SelectTypeCode="1"
	;if SelectTypeCode="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	if SelectTypeCode'=""{
		d LoopTypeCode
	}else{
		for {
			set SelectTypeCode=$o(^DHCMUC(0,"TYPE",SelectTypeCode)) quit:SelectTypeCode=""
			d LoopTypeCode	
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
LoopTypeCode
	s (THisCode,THisDesc,TMUCCode,TMUCDesc,TActiveFlag,HidRowid,TMUCExtOrgDr,TMUCExtOrg)=""
	s MUCCRowId="" 
	for {
		set MUCCRowId=$o(^DHCMUC(0,"TYPE",SelectTypeCode,MUCCRowId)) quit:MUCCRowId=""
		s HISCodeRowId=$p($g(^DHCMUC("MUC",MUCCRowId)),"^",2)
		s THisCode=$p($g(^DHCMUC("MUC",MUCCRowId)),"^",3)
		s THisDesc=$p($g(^DHCMUC("MUC",MUCCRowId)),"^",4)
		s TMUCCode=$p($g(^DHCMUC("MUC",MUCCRowId)),"^",5)
		s TMUCDesc=$p($g(^DHCMUC("MUC",MUCCRowId)),"^",6)
		s TMUCExtOrgDr=$p($g(^DHCMUC("MUC",MUCCRowId)),"^",8)
		continue:(Code'="")&&(THisCode'[Code)&&(TMUCCode'[Code)
		continue:(Desc'="")&&(THisDesc'[Desc)&&(TMUCDesc'[Desc)
		continue:(SelectExtOrg'="")&&(TMUCExtOrgDr'[SelectExtOrg)
		s TActiveFlag=$p($g(^DHCMUC("MUC",MUCCRowId)),"^",7)
		i TActiveFlag="Y" s TActiveFlag="是"
		e  s TActiveFlag="否"
		s TMUCExtOrg=""
		s:TMUCExtOrgDr'="" TMUCExtOrg=$p($g(^DHCMUCExtOrg(TMUCExtOrgDr)),"^",2)
		s HidRowid=MUCCRowId
		d OutputRow
	}
	Quit
OutputRow      
	set Data=$lb(HISCodeRowId,THisCode,THisDesc,TMUCCode,TMUCDesc,TActiveFlag,HidRowid,SelectTypeCode,TMUCExtOrgDr,TMUCExtOrg)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod ExtDataQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ExtDataQueryExecute ]
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

/// w ##class("web.DHCDocExtData").CheckforTableexcite("aa","aa","aa")
ClassMethod CheckforTableexcite(Table, TableCode, TableDesc)
{
	q:((Table="")||(TableCode="")||(TableDesc="")) "1"
	Set result=##class(%ResultSet).%New("%DynamicQuery:SQL")
	Set sc=result.Prepare("SELECT %ID, "_TableCode_","_TableDesc_" FROM "_Table)
	If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) Quit "1"
	Set sc=result.Execute(10000) If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) Quit "1"
	q 0
}

ClassMethod HisCodeQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = HisCodeQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocExtData","HisCodeQuery",1,"")
ClassMethod HisCodeQueryExecute(ByRef qHandle As %Binary, SelectType As %String, SelectHISCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s ^tempqujian("HisCodeQuery")=SelectType_","_SelectHISCode
	if SelectType="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s CTEDTTable=$p($g(^DHCDOCCTEDT("CTEDT",SelectType)),"^",6)
	s CTEDTTableCode=$p($g(^DHCDOCCTEDT("CTEDT",SelectType)),"^",7)
	s CTEDTTableDesc=$p($g(^DHCDOCCTEDT("CTEDT",SelectType)),"^",8)
	if (CTEDTTable="")  {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	Set result=##class(%ResultSet).%New("%DynamicQuery:SQL")
	Set sc=result.Prepare("SELECT %ID, "_CTEDTTableCode_","_CTEDTTableDesc_" FROM "_CTEDTTable)
	If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) Quit
	Set sc=result.Execute(10000) If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) Quit
	While result.Next(.sc) {
		If $$$ISERR(sc) Quit
		;b //Write result.Data("Name"),result.Data("Salary"),!
		s HISRowid=result.%ROWID 
		s HISCode=result.Data(CTEDTTableCode)
		s HISDesc=result.Data(CTEDTTableDesc)
		if CTEDTTable="PHC_Instruc"{
			s InstrActive=$p(^PHCIN(HISRowid),"^",4)
			continue:InstrActive'="Y"
		}
		do OutputRow
	}
	/*s CTEDTClassName=$p($g(^DHCDOCCTEDT("CTEDT",SelectType)),"^",3)
	s CTEDTQueryName=$p($g(^DHCDOCCTEDT("CTEDT",SelectType)),"^",4)
	s CTEDTClassName=$tr(CTEDTClassName," ","")
	s CTEDTQueryName=$tr(CTEDTQueryName," ","")
	if (CTEDTClassName="")||(CTEDTQueryName="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	s RunQueryName=CTEDTClassName_":"_CTEDTQueryName
	Set rs=##Class(%ResultSet).%New(RunQueryName)
	If rs.QueryIsValid() { 
		 Set Status=rs.Execute(SelectHISCode)
		 Set columns = rs.GetColumnCount()

		 If 'Status Quit
		 While rs.Next() {
			s flag=0
			For col = 1:1:columns {
				//Write rs.GetColumnName(col),":"
				s ColumnName=rs.GetColumnName(col)
				if $zcvt(ColumnName,"U")["ROWID" s HISRowid=rs.GetData(col),flag=1
				if $zcvt(ColumnName,"U")["CODE" s HISCode=rs.GetData(col)
				if $zcvt(ColumnName,"U")["DESC" s HISDesc=rs.GetData(col)
			}
			continue:flag=0
			
			do OutputRow
		 }
	}*/
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow      
	set Data=$lb(HISCode,HISDesc,HISRowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod HisCodeQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = HisCodeQueryExecute ]
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

Query HisCodeQuery(SelectType As %String, SelectHISCode As %String) As %Query(ROWSPEC = "HISCode:%String,HISDesc:%String,HISRowid:%String")
{
}

Query ExtDataQuery(SelectTypeCode As %String, Code As %String = "", Desc As %String = "", SelectExtOrg As %String) As %Query(ROWSPEC = "HISCodeRowId:%String,THISCode:%String,THISDesc:%String,TMUCCode:%String,TMUCDesc:%String,TActiveFlag:%String,HidRowid:%String,SelectTypeCode:%String,TMUCExtOrgDr:%String,TMUCExtOrg:%String")
{
}

Query ExtOrgDataQuery(Active As %String = "") As %Query(ROWSPEC = "TExtOrgCode:%String,TExtOrgDesc:%String,TExtOrgActiveFlag:%String,ExtOrgRowid:%String")
{
}

ClassMethod ExtOrgDataQueryExecute(ByRef qHandle As %Binary, Active As %String = "") As %Status
{
	s Rowid=""
	for{
		s Rowid=$o(^DHCMUCExtOrg(Rowid)) Q:Rowid=""
		s TExtOrgCode=$p(^DHCMUCExtOrg(Rowid),"^",1)
		s TExtOrgDesc=$p(^DHCMUCExtOrg(Rowid),"^",2)
		s TTExtOrgActiveFlag=$p(^DHCMUCExtOrg(Rowid),"^",3)
		continue:(Active'="")&&(TTExtOrgActiveFlag'=Active)
		d OutputRow
	}
	Quit $$$OK
OutputRow      
	set Data=$lb(TExtOrgCode,TExtOrgDesc,TTExtOrgActiveFlag,Rowid)
 	Set qHandle($i(ind))=Data
 	quit
}

ClassMethod ExtOrgDataQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ExtOrgDataQueryExecute ]
{
	s ind=$O(qHandle(""))
	if ind'=""{
		s Row=qHandle(ind)
		k qHandle(ind)
		Quit $$$OK
	}
	s AtEnd=1
	Quit $$$OK
}

ClassMethod CheckDataRepeat(Code As %String, Desc As %String, Rowid As %String)
{
	s ret=0
	s mRowid=""
	for{
		s mRowid=$o(^DHCMUCExtOrg(mRowid)) Q:mRowid=""
		continue:(Rowid'="")&&(Rowid=mRowid)
		s TExtOrgCode=$p(^DHCMUCExtOrg(mRowid),"^",1)
		s TExtOrgDesc=$p(^DHCMUCExtOrg(mRowid),"^",2)
		if Code=TExtOrgCode s ret=1
		if Desc=TExtOrgDesc s ret=2
	}
	Q ret
}

ClassMethod SaveExtOrg(Code As %String, Desc As %String, Active As %String, Rowid As %String)
{
	s ret=..CheckDataRepeat(Code,Desc,Rowid)
	if ret'=0 Q ret
	if (Active="N")&&(Rowid'=""){
		Q:($d(^DHCMUC(0,"ExtOrg",Rowid)))&&($d(^DHCDocTEXTDIC(0,"EOTC",Rowid))) "该外部结构已被【医生站代码表外部对照】、【对外接口文本字段对照】使用,不能置为不可用!"
		Q:$d(^DHCMUC(0,"ExtOrg",Rowid)) "该外部结构已被【医生站代码表外部对照】使用,不能置为不可用!"
        Q:$d(^DHCDocTEXTDIC(0,"EOTC",Rowid)) "该外部结构已被【对外接口文本字段对照】使用,不能置为不可用!"
    }
	if Rowid=""{
		s Obj=##class(User.DHCDocCTExtDataExtOrg).%New()	
	}else{
		s Obj=##class(User.DHCDocCTExtDataExtOrg).%OpenId(Rowid)
	}
	if '$IsObject(Obj){
		Q -100	
	}
	s ret=0
	s Obj.MUCExtOrgCode=Code
	s Obj.MUCExtOrgDesc=Desc
	s Obj.MUCExtOrgActive=Active
	s sc=Obj.%Save()
	If $$$ISERR(sc){
	    s ret=-200
    }
    d Obj.%Close()
	Q ret
}

/// Desc:根据HIS字典表ID获取对照数据接口：
/// Note:代码类型、HIS字典表ID不能为空,机构代码为空则取未维护机构的通用对照数据
/// Input:代码类型、机构代码
/// Output:0^外部代码_$C(1)_外部名称
/// Output:非0^错误信息
/// w ##class(web.DHCDocExtData).GetExtData("freq",1)
ClassMethod GetExtData(SelectTypeCode As %String, LocalId As %String, ExtOrgCode As %String = "")
{
	s ExtData="",ExtStr=""
	if SelectTypeCode=""{
		Q "-1^代码类型不能为空"	
	}
	if LocalId=""{
		Q "-1^HIS字典表ID不能为空"	
	}
	s SelectType=$o(^DHCDOCCTEDTi("CTEDTCode",SelectTypeCode,""))
	if SelectType=""{
		Q "-1^代码类型不存在"	
	}
	if ExtOrgCode'=""{
		s ExtOrgId=$o(^DHCMUCExtOrgi("Code",ExtOrgCode,""))
		if ExtOrgId=""{
			Q "-1^机构代码不存在"	
		}
		s ID=""
		for{
			s ID=$o(^DHCMUC(0,"ExtTYPELOCALDR",ExtOrgId,SelectType,LocalId,ID)) Q:ID=""
			s THisCode=$p($g(^DHCMUC("MUC",ID)),"^",3)
			s THisDesc=$p($g(^DHCMUC("MUC",ID)),"^",4)
			s TMUCCode=$p($g(^DHCMUC("MUC",ID)),"^",5)
			s TMUCDesc=$p($g(^DHCMUC("MUC",ID)),"^",6)
			s TActiveFlag=$p($g(^DHCMUC("MUC",ID)),"^",7)
			continue:TActiveFlag'="Y"
			s ExtStr=TMUCCode_$c(1)_TMUCDesc
		}
		
	}else{
		s ID=""
		for{
			s ID=$o(^DHCMUC(0,"TYPELOCALDR",SelectType,LocalId,ID)) Q:ID=""
			s THisCode=$p($g(^DHCMUC("MUC",ID)),"^",3)
			s THisDesc=$p($g(^DHCMUC("MUC",ID)),"^",4)
			s TMUCCode=$p($g(^DHCMUC("MUC",ID)),"^",5)
			s TMUCDesc=$p($g(^DHCMUC("MUC",ID)),"^",6)
			s TActiveFlag=$p($g(^DHCMUC("MUC",ID)),"^",7)
			s TMUCExtOrgDr=$p($g(^DHCMUC("MUC",ID)),"^",8)
			continue:TMUCExtOrgDr'=""
			continue:TActiveFlag'="Y"
			s ExtStr=TMUCCode_$c(1)_TMUCDesc
		}
	}
	if ExtStr'=""{
		s ExtData=0_"^"_ExtStr
	}else{
		s ExtData="-1"_"^"_"未获取到对照数据"	
	}
	
	Q ExtData
}

}
