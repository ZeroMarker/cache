Class web.DHCEQSpecialPlant Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// s val="^0^360^12/12/2012^20^tyyu^wuhan^N"
/// w ##Class(web.DHCEQSpecialPlant).SaveData("","",val,0,360,2)
ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", SourceType As %Library.String = "", SourceID As %Library.String = "", isDel As %Library.String = "")
{
	new PLIST,rowid,SQLCODE
	s SQLCODE=0
	;s rowid=$p(val,"^",2)
	s rowid=$Order(^DHCEQSpecialPlant(0,"Source",SourceType,SourceID,-1))
	i (+isDel=1)	 //删除记录
	{
		i (rowid'="")
		{
			&SQL(update SQLUSER.DHC_EQSpecialPlant set S_InvalidFlag='Y' where S_RowID = :rowid)
			if (SQLCODE'=0)
            {
	    	    q SQLCODE
	        }
		}
	}
	
	If (+isDel=2)
	{
		Set PLIST(2)=SourceType
	 	Set PLIST(3)=SourceID
	 	If $Piece(val,"^",5)'="" Set PLIST(4) = ##class(web.DHCEQCommon).TransValueFromPage($Piece(val,"^",5),"date")
	 	Set PLIST(5)=$Piece(val,"^",6)
	 	Set PLIST(6)=$Piece(val,"^",7)
	 	Set PLIST(7)=$Piece(val,"^",8)
	 	Set PLIST(8)="N"
	 	;Set PLIST(9)=""
	 	;Set PLIST(10)=""
	 	;Set PLIST(11)=""
	 	;Set PLIST(12)=""
	 	;Set PLIST(13)=""
	 	
	 	If (rowid="")
	 	{
			&SQL(Insert Into SQLUSER.DHC_EQSpecialPlant Values :PLIST())
	 	}
		Else
		{
			&SQL(Update SQLUSER.DHC_EQSpecialPlant Values :PLIST() where S_RowID=:rowid)
		}
		if (SQLCODE'=0)
        {
	        TRollBack
	    	q SQLCODE
	    }
	}
 	q SQLCODE
}

/// w ##Class(web.DHCEQSpecialPlant).GetDHCEQSpecialPlantByID("","",0,380)
ClassMethod GetDHCEQSpecialPlantByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", SourceType As %Library.String = "", SourceID As %Library.String = "")
{
	; ^DHCEQSpecialPlant(0,"Source",0,380,1)=
	New rowid,result
	Set rowid= $Order(^DHCEQSpecialPlant(0,"Source",SourceType,SourceID,""))
	if rowid="" Quit ""
	Set result= $Get(^DHCEQSpecialPlant(rowid))
	If $Piece(result,"^",7)="Y" Quit ""
	If $Piece(result,"^",3)'="" Set $Piece(result,"^",3)=##Class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",3),"date")
	Quit rowid_"^"_result
}

}
