Class web.DHCEQIntangibleAssets Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 无形资产的维护
/// add BY:GBX 2014-10-12 
/// w ##Class(web.DHCEQIntangibleAssets).SaveData("","",)
ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", SourceType As %Library.String = "", SourceID As %Library.String = "", isDel As %Library.String = "")
{
	new PLIST,rowid,SQLCODE
	s SQLCODE=0
	s rowid=$p(val,"^",2)
	
	i (+isDel=1)	 //删除记录
	{
		i (rowid'="")
		{
			&SQL(update SQLUSER.DHC_EQIntangibleAssets set IA_InvalidFlag='Y' where IA_RowID = :rowid)
		}	
	}
	
	If (+isDel=2)
	{
		Set PLIST(2)=SourceType
	 	Set PLIST(3)=SourceID
	 	Set PLIST(4)=$Piece(val,"^",3)
	 	Set PLIST(5)=$Piece(val,"^",4)
	 	Set PLIST(6)=$Piece(val,"^",5)
	 	If $Piece(val,"^",6)'="" Set PLIST(7) = ##class(web.DHCEQCommon).TransValueFromPage($Piece(val,"^",6),"date")
	 	Set PLIST(8)=$Piece(val,"^",7)
	 	Set PLIST(9)=$Piece(val,"^",8)
	 	Set PLIST(10)=$Piece(val,"^",9)
	 	If $Piece(val,"^",10)'="" Set PLIST(11) = ##class(web.DHCEQCommon).TransValueFromPage($Piece(val,"^",10),"date")
	 	Set PLIST(12)="N"
	 	;Set PLIST(13)=""
	 	;Set PLIST(14)=""
	 	;Set PLIST(15)=""
	 	;Set PLIST(16)=""
	 	;Set PLIST(17)=""
	 	
	 	If (rowid="")
	 	{
			&SQL(Insert Into SQLUSER.DHC_EQIntangibleAssets Values :PLIST())
	 	}
		Else
		{
			&SQL(Update SQLUSER.DHC_EQIntangibleAssets Values :PLIST() where IA_RowID=:rowid)
		}
	}
 	If SQLCODE Quit SQLCODE
	Quit 0
}

/// w ##Class(web.DHCEQIntangibleAssets).GetIntangibleAssetsByID("","",0,380)
ClassMethod GetIntangibleAssetsByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", SourceType As %Library.String = "", SourceID As %Library.String = "")
{
	; ^DHCEQIntangibleAssets(0,"Source",0,380,1)=
	New rowid,result
	Set rowid= $Order(^DHCEQIntangibleAssets(0,"Source",SourceType,SourceID,""))
	if rowid="" Quit ""
	Set result= $Get(^DHCEQIntangibleAssets(rowid))
	If $Piece(result,"^",6)'="" Set $Piece(result,"^",6)=##Class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",6),"date")		;IA_RegistrationDate
	If $Piece(result,"^",10)'="" Set $Piece(result,"^",10)=##Class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",10),"date")	;IA_AnnouncementDate
	Set result=rowid_"^"_result
	Quit result
}

}
