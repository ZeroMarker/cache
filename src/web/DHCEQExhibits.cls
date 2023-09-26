Class web.DHCEQExhibits Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// s val="^3^360^9^12/12/2012^CIA^N" 
/// w ##Class(web.DHCEQExhibits).SaveData("","",val,3,360,2)
ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", SourceType As %Library.String = "", SourceID As %Library.String = "", isDel As %Library.String = "")
{
	new PLIST,rowid,SQLCODE
	s SQLCODE=0
	s rowid=$Order(^DHCEQExhibits(0,"Source",SourceType,SourceID,-1))
	i (+isDel=1)	 //删除记录
	{
		i (rowid'="")
		{
			&SQL(update SQLUSER.DHC_EQExhibits set E_InvalidFlag='Y' where E_RowID = :rowid)
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
	 	Set PLIST(4)=$Piece(val,"^",5)
	 	If $Piece(val,"^",6)'="" Set PLIST(5) = ##class(web.DHCEQCommon).TransValueFromPage($Piece(val,"^",6),"date")
	 	Set PLIST(6)=$Piece(val,"^",7)
	 	Set PLIST(7)=$Piece(val,"^",8)
	 	;Set PLIST(8)=""
	 	;Set PLIST(9)=""
	 	;Set PLIST(10)=""
	 	;Set PLIST(11)=""
	 	;Set PLIST(12)=""
	 	
	 	If (rowid="")
	 	{
			&SQL(Insert Into SQLUSER.DHC_EQExhibits Values :PLIST())
	 	}
		Else
		{
			&SQL(Update SQLUSER.DHC_EQExhibits Values :PLIST() where E_RowID=:rowid)
		}
		if (SQLCODE'=0)
        {
	    	q SQLCODE
	    }
	}
	q SQLCODE
}

/// w ##Class(web.DHCEQExhibits).GetDHCEQExhibitsByID("","",3,360)
ClassMethod GetDHCEQExhibitsByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", SourceType As %Library.String = "", SourceID As %Library.String = "")
{
	; ^DHCEQExhibits(0,"Source",0,380,1)=
	New rowid,result
	Set rowid= $Order(^DHCEQExhibits(0,"Source",SourceType,SourceID,""))
	if rowid="" Quit ""
	Set result= $Get(^DHCEQExhibits(rowid))
	If $Piece(result,"^",6)="Y" Quit ""
	If $Piece(result,"^",4)'="" Set $Piece(result,"^",4)=##Class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",4),"date")
	Quit rowid_"^"_result
}

}
