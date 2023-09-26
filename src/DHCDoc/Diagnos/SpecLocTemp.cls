Class DHCDoc.Diagnos.SpecLocTemp Extends DHCDoc.DHCDocConfig.Common
{

Query QueryCat(LocID = "") As %Query(ROWSPEC = "ID,Code,Name,Active,AuthLoc")
{
}

ClassMethod QueryCatExecute(ByRef qHandle As %Binary, LocID = "") As %Status
{
	s rows=[]
	s qHandle=rows.%GetIterator()
	s ID=0 for{
		s ID=$O(^User.DHCSpecLocDiagCatD(ID)) Q:ID=""
		s AuthLoc=$LG(^User.DHCSpecLocDiagCatD(ID),5)
		continue:(LocID'="")&&((","_AuthLoc_",")'[(","_LocID_","))
		s Code=$LG(^User.DHCSpecLocDiagCatD(ID),2)
		s Name=$LG(^User.DHCSpecLocDiagCatD(ID),3)
		s Active=$LG(^User.DHCSpecLocDiagCatD(ID),4)
		d rows.%Push($LB(ID,Code,Name,Active,AuthLoc))
	}
	Quit $$$OK
}

ClassMethod QueryCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCatExecute ]
{
	if 'qHandle.%GetNext(.key,.Row) s AtEnd=1
	Quit $$$OK
}

Query QueryCatItem(CatID) As %SQLQuery
{
	SELECT * FROM SQLUser.DHC_SpecLocDiagItem WHERE CatDR=:CatID ORDER BY case when Sequence is null then 1 else 0 end,Sequence
}

ClassMethod DeleteCat(ID)
{
	TS
	&SQL(DELETE FROM SQLUser.DHC_SpecLocDiagCat WHERE ID=:ID)
	if 'SQLCODE{
		&SQL(DELETE FROM SQLUser.DHC_SpecLocDiagItem WHERE CatDR=:ID)
		s:SQLCODE=100 SQLCODE=0
	}
	if SQLCODE TRO
	else  TC
	Q SQLCODE
}

Query QueryAuthLoc(CatID, HospID = "") As %Query(ROWSPEC = "LocID,LocDesc,LocAlias,selected")
{
}

ClassMethod QueryAuthLocExecute(ByRef qHandle As %Binary, CatID, HospID = "") As %Status
{
	s rows=[]
	s qHandle=rows.%GetIterator()
	s:HospID="" HospID=%session.Data("LOGON.HOSPID")
	Q:(CatID="")||(HospID="") $$$OK
	s AuthLoc=$LG(^User.DHCSpecLocDiagCatD(CatID),5)
	d ..StrToList(AuthLoc,",",.AuthLocList)
	s LocID=0 for{
		s LocID=$O(^CTLOC(0,"Hosp",HospID,LocID)) Q:LocID=""
		s DateActiveTo=$P(^CTLOC(LocID),"^",25)
		continue:(DateActiveTo'="")&&(DateActiveTo'>+$H)
		s LocDesc=$P(^CTLOC(LocID),"^",2)
		s LocAlias=$ZCVT($P(^CTLOC(LocID),"^",43),"U")
		s selected=$D(AuthLocList(LocID))
		continue:($P(^CTLOC(LocID),"^",14)'="Y")
		d rows.%Push($LB(LocID,LocDesc,LocAlias,selected))
	}
	Quit $$$OK
}

ClassMethod QueryAuthLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAuthLocExecute ]
{
	if 'qHandle.%GetNext(.key,.Row) s AtEnd=1
	Quit $$$OK
}

ClassMethod SaveLocAuth(CatID, HospID, LocIDStr)
{
	s AuthLoc=$LG(^User.DHCSpecLocDiagCatD(CatID),5)
	d ..StrToList(AuthLoc,",",.AuthLocList)
	s LocID=0 for{
		s LocID=$O(AuthLocList(LocID)) Q:LocID=""
		s HospDR=$P(^CTLOC(LocID),"^",22)
		if HospDR=HospID k AuthLocList(LocID)
	}
	d ..StrToList(LocIDStr,",",.AuthLocList)
	s AuthLocStr=..ListToStr(.AuthLocList,",")
	&SQL(UPDATE SQLUser.DHC_SpecLocDiagCat SET AuthLoc=:AuthLocStr WHERE ID=:CatID)
	Q SQLCODE
}

}
