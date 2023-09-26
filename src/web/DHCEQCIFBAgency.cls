Import SQLUser

/// 修改人： MoZY 2011-01-06
/// 描述:招标代理机构表
Class web.DHCEQCIFBAgency Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCEQCIFBAgency","IFBAgency","")
Query IFBAgency(Code As %String = "", Desc As %String = "") As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String,TQualifications:%String,TAddress:%String,TTel:%String,TFax:%String,TConPerson:%String,TFromDate:%String,TToDate:%String")
{
}

ClassMethod IFBAgencyExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	Set rowid=0
	
	For  Set rowid=$Order(^DHCEQCCode("DHCEQCIFBAgency",rowid))  Quit:rowid=""  Do
	.Do ResetVariablesIFBAgency
	.Set TRowID = rowid
	.Set InvalidFlag=$Piece($Get(^DHCEQCCode("DHCEQCIFBAgency",TRowID)),"^",10)
	.Quit:InvalidFlag="Y"
	.Set TCode=$Piece($Get(^DHCEQCCode("DHCEQCIFBAgency",TRowID)),"^",1)
	.Quit:(Code'="")&&(TCode'[Code)
	.Set TDesc=$Piece($Get(^DHCEQCCode("DHCEQCIFBAgency",TRowID)),"^",2)
	.Quit:(Desc'="")&&(TDesc'[Desc)
	.Set TQualifications=$Piece($Get(^DHCEQCCode("DHCEQCIFBAgency",TRowID)),"^",3)
	.Set TAddress=$Piece($Get(^DHCEQCCode("DHCEQCIFBAgency",TRowID)),"^",4)
	.Set TTel=$Piece($Get(^DHCEQCCode("DHCEQCIFBAgency",TRowID)),"^",5)
	.Set TFax=$Piece($Get(^DHCEQCCode("DHCEQCIFBAgency",TRowID)),"^",6)
	.Set TConPerson=$Piece($Get(^DHCEQCCode("DHCEQCIFBAgency",TRowID)),"^",7)
	.Set TFromDate=$Piece($Get(^DHCEQCCode("DHCEQCIFBAgency",TRowID)),"^",8)
	.Set TToDate=$Piece($Get(^DHCEQCCode("DHCEQCIFBAgency",TRowID)),"^",9)
	.
	.Do OutputRowIFBAgency
	Quit $$$OK
OutputRowIFBAgency
	Set Data=$lb(TRowID,TCode,TDesc,TQualifications,TAddress,TTel,TFax,TConPerson,TFromDate,TToDate)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesIFBAgency
	Set (TRowID,TCode,TDesc,TQualifications,TAddress,TTel,TFax,TConPerson,TFromDate,TToDate)=""
	Quit
}

ClassMethod IFBAgencyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = IFBAgencyExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$Order(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod IFBAgencyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = IFBAgencyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// w ##class(web.DHCEQCIFBAgency).GetIFBAgencyByID(1)
ClassMethod GetIFBAgencyByID(rowid As %Library.String = "")
{
	Quit:rowid="" ""
	new result
	Set result= $Get(^DHCEQCCode("DHCEQCIFBAgency",rowid))
	
	If $Piece(result,"^",8)'="" Set $Piece(result,"^",8)=##class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",8),"date")
	If $Piece(result,"^",9)'="" Set $Piece(result,"^",9)=##class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",9),"date")
	
	Set result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n") //回车符转换为"\n"
	
	Quit rowid_"^"_result
}

/// w ##class(web.DHCEQCIFBAgency).SaveData("","","2^代码1^机构名称1^代理资质1^地址1^电话1^传真1^联系人1^^^1^2^3^4^5")
ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", isDel As %Library.String = "")
{
	Kill PLIST,rowid
	Set rowid=$Piece(val,"^",1)
	If (+isDel=1)
	{
	 	Set PLIST(11)="Y" 		// InvalidFlag
	 	&SQL(Update SQLUSER.DHC_EQCIFBAgency Values :PLIST() where IFBA_RowID = :rowid)
	 	If SQLCODE  Quit SQLCODE
	 	Quit rowid
 	}
 	
 	Set PLIST(2)=$Piece(val,"^",2) 		// Code
 	Set PLIST(3)=$Piece(val,"^",3) 		// Desc
 	Set PLIST(4)=$Piece(val,"^",4) 		// Qualifications
 	Set PLIST(5)=$Piece(val,"^",5) 		// Address
 	Set PLIST(6)=$Piece(val,"^",6) 		// Tel
 	Set PLIST(7)=$Piece(val,"^",7) 		// Fax
 	Set PLIST(8)=$Piece(val,"^",8) 		// ConPerson
 	Set PLIST(9)=$Piece(val,"^",9) 		// FromDate
 	If PLIST(9)'="" Set PLIST(9) = ##Class(web.DHCEQCommon).TransValueFromPage($Piece(val,"^",9),"date")
 	Set PLIST(10)=$Piece(val,"^",10) 	// ToDate
 	If PLIST(10)'="" Set PLIST(10) = ##Class(web.DHCEQCommon).TransValueFromPage($Piece(val,"^",10),"date")
 	
 	Set PLIST(12)=$Piece(val,"^",11)	// Hold1
 	Set PLIST(13)=$Piece(val,"^",12)	// Hold2
 	Set PLIST(14)=$Piece(val,"^",13)	// Hold3
 	Set PLIST(15)=$Piece(val,"^",14)	// Hold4
 	Set PLIST(16)=$Piece(val,"^",15)	// Hold5
	
 	If (rowid="")  //新增按钮操作
 	{
	 	&SQL(Insert Into SQLUSER.DHC_EQCIFBAgency Values :PLIST())
 	}
 	Else  //更新按钮操作
 	{
		&SQL(Update SQLUSER.DHC_EQCIFBAgency Values :PLIST() where IFBA_RowID = :rowid)
 	}
 	If SQLCODE Quit SQLCODE
 	Set ID=$Get(%ROWID)
 	Quit ID
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQCIFBAgency","GetIFBAgency","")
Query GetIFBAgency(Desc As %String = "") As %Query(ROWSPEC = "TDesc:%String,Hidden,TCode:%String,TQualification:%String,TAddress:%String")
{
}

ClassMethod GetIFBAgencyExecute(ByRef qHandle As %Binary, Desc As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	Set rowid=0
	
	For  Set rowid=$Order(^DHCEQCCode("DHCEQCIFBAgency",rowid))  Quit:rowid=""  Do
	.Do ResetVariablesGetIFBAgency
	.Set TRowID = rowid
	.Set TCode=$Piece($Get(^DHCEQCCode("DHCEQCIFBAgency",rowid)),"^",1)
	.Set TDesc=$Piece($Get(^DHCEQCCode("DHCEQCIFBAgency",rowid)),"^",2)
	.Quit:(Desc'="")&&(TDesc'=Desc)
	.Set TQualification=$Piece($Get(^DHCEQCCode("DHCEQCIFBAgency",rowid)),"^",3)
	.Set TAddress=$Piece($Get(^DHCEQCCode("DHCEQCIFBAgency",rowid)),"^",4)
	.
	.Do OutputRowGetIFBAgency
	Quit $$$OK
OutputRowGetIFBAgency
	Set Data=$lb(TDesc,TRowID,TCode,TQualification,TAddress)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetIFBAgency
	Set (TDesc,TRowID,TCode,TQualification,TAddress)=""
	Quit
}

ClassMethod GetIFBAgencyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetIFBAgencyExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$Order(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetIFBAgencyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetIFBAgencyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
