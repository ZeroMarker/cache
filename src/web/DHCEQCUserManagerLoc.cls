Class web.DHCEQCUserManagerLoc Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 16;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "UML_RowID";

Parameter SQLDESCRIPTION = "UML_RowID";

Parameter SQLROWID = "UML_RowID";

ClassMethod IsHad(UserID, LocID, UMLID)
{
	// Mozy0030	2010-11-11
	q:UserID="" "N"
	q:LocID="" "N"
	new Flag,UMLDR
	s UMLDR=$o(^DHCEQCCode("DHCEQCUserManagerLoc",0,"UserLoc",UserID,LocID,0))
	i UMLDR="" q "N"
	i UMLDR'=UMLID q "Y"
	q "N"
}

ClassMethod UpdateData(Val, Type)
{
	//Type=0,更新
	//Type＝1，删除
	s RowID=$P(Val,"^",1)
	i +Type=0
	{
		s PLIST(2)=$P(Val,"^",2)
		s PLIST(3)=$P(Val,"^",3)
		s PLIST(4)=$P(Val,"^",4)
		if RowID=""
		{
			&SQL(insert into sqluser.DHC_EQCUserManagerLoc values :PLIST())
		}
		else
		{
			&SQL(update sqluser.DHC_EQCUserManagerLoc values :PLIST() where UML_RowID=:RowID)
		}
		q SQLCODE
	}
	else
	{
		TSTART
		&SQL(delete from sqluser.DHC_EQCUserManagerLoc where UML_RowID=:RowID)
		i SQLCODE 
		{
			TROLLBACK
			q SQLCODE
		}
		TCOMMIT
		q SQLCODE
	}
}

ClassMethod GetOneUserManagerLoc(UMLID)
{
	new ReturnVal,UserID,User,LocID,Loc,PurposeTypes
	s (UserID,User,LocID,Loc,PurposeTypes)=""
	s UserID=$p(^DHCEQCCode("DHCEQCUserManagerLoc",UMLID),"^",1)
	i UserID'="" s User=##Class(web.DHCEQCommon).GetTrakNameByID("user",UserID)
	s LocID=$p(^DHCEQCCode("DHCEQCUserManagerLoc",UMLID),"^",2)
	i LocID'="" s Loc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",LocID)
	s PurposeTypes=$p(^DHCEQCCode("DHCEQCUserManagerLoc",UMLID),"^",3)
	s ReturnVal=UMLID_"^"_UserID_"^"_User_"^"_LocID_"^"_Loc_"^"_PurposeTypes
	q ReturnVal
}

ClassMethod GetUserManagerLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUserManagerLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetUserManagerLocExecute(ByRef qHandle As %Binary) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetGetUserManagerLoc
	Quit $$$OK
BuildDataGetGetUserManagerLoc
	f  s rowid=$o(^DHCEQCCode("DHCEQCUserManagerLoc",rowid))  quit:rowid=""  d
	.d ResetVariablesGetGetUserManagerLoc
	.s TRowID=rowid
	.s TUserID=$p(^DHCEQCCode("DHCEQCUserManagerLoc",TRowID),"^",1)
	.i TUserID'="" s TUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",TUserID)
	.s TLocID=$p(^DHCEQCCode("DHCEQCUserManagerLoc",TRowID),"^",2)
	.i TLocID'="" s TLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TLocID)
	.s TPurposeTypes=$p(^DHCEQCCode("DHCEQCUserManagerLoc",TRowID),"^",3)
	.s TPurposeTypes=##Class(web.DHCEQCommon).ReplacePurposeTypeDesc(TPurposeTypes)
	.d OutputGetUserManagerLoc
	quit
OutputGetUserManagerLoc
   s Data=$lb(TRowID,TUserID,TUser,TLocID,TLoc,TPurposeTypes)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetGetUserManagerLoc
	s (TRowID,TUserID,TUser,TLocID,TLoc,TPurposeTypes)=""
	quit
}

ClassMethod GetUserManagerLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUserManagerLocExecute ]
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

Query GetUserManagerLoc() As %Query(ROWSPEC = "TRowID:%String,TUserDR:%String,TUser:%String,TLocDR:%String,TLoc:%String,TPurposeTypes:%String")
{
}

ClassMethod ReplacePurposeTypeDesc(PurposeTypes)
{
	new i,j
	i PurposeTypes="" q ""
	s i=$l(PurposeTypes,",")
	for j=1:1:i
	{
		s $p(PurposeTypes,",",j)=$p(^DHCEQCCode("DHCEQCPurposeType",$p(PurposeTypes,",",j)),"^",2)
	}
	q PurposeTypes
}

ClassMethod GetPurposeTypes()
{
	s ID=0
	s Str=""
	s OneStr=""
	f  s ID=$o(^DHCEQCCode("DHCEQCPurposeType",ID)) q:ID=""  d
	.s Desc=$p(^DHCEQCCode("DHCEQCPurposeType",ID),"^",2)
	.s OneStr=Desc_","_ID
	.i Str="" d
	..s Str=OneStr
	.e  d
	..s Str=Str_"^"_OneStr
	q Str
}

}
