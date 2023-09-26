Class EPRservice.dao.DPrivCTLoc Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("EPRservice.dao.DPrivCTLoc","GetCTLoc")
/// added by Jiangew on 2012-11-15
Query GetAllCTLoc() As %SQLQuery(CONTAINID = 1, ROWSPEC = "CTLOC_RowID,CTLOC_Desc", SELECTMODE = "RUNTIME") [ SqlName = GetAllCTLoc, SqlProc ]
{
	Select CTLOC_RowID,CTLOC_Desc from SQLUser.CT_Loc order by CTLOC_RowID
}

Query GetCTLocByName(CTLocName As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "CTLOC_RowID,CTLOC_Desc", SELECTMODE = "RUNTIME") [ SqlName = GetCTLocByName, SqlProc ]
{
	Select CTLOC_RowID,CTLOC_Desc from SQLUser.CT_Loc where CTLOC_Desc like :CTLocName
}

/// added by Jiangew on 2012-11-15
Query GetCTLoc(ADicCode As %String, AItem As %String, AStartRow As %Integer, ARowCount As %Integer, ASessionId As %String) As %Query(ROWSPEC = "CTLOC_RowID:%String,CTLOC_Desc:%String")
{
}

ClassMethod GetCTLocExecute(ByRef qHandle As %Binary, ADicCode As %String, AItem As %String, AStartRow As %Integer, ARowCount As %Integer, ASessionId As %String) As %Status
{
	s qHandle="1" 
    s SQLCODE=0 
    s %counter=0
    s ID=""
    s %ResultID=""
    
    if ($D(^CacheTempStdQuery(ASessionId)))
    {
	    if ($G(^CacheTempStdQuery(ASessionId))="True") 
	    {
		    s StartPageID= AStartRow
		    s LastPageId = AStartRow+ARowCount
            s PageNumCounter = 0 
            s PageKey= $O(^CacheTempStdQuery(ASessionId,""))
            While (PageKey '="")
	        {
		        s PageNumCounter = PageNumCounter + 1
	            if (PageNumCounter> StartPageID)&(PageNumCounter <= LastPageId)
	            {
		            s %ResultID(PageNumCounter-StartPageID)= $G(^CacheTempStdQuery(ASessionId,PageKey))	 
	            }
		
	            s PageKey= $O(^CacheTempStdQuery(ASessionId,PageKey)) 	
		    }
		    s qHandle=%ResultID
            q $$$OK
		}
	}
}

ClassMethod GetCTLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCTLocExecute ]
{
	s SQLCODE=0 
    s $ET="QUIT" 
    s %counter=%counter+1
    if $o(%ResultID(""),-1) < %counter 
    {
	    s Row = ""
	    s AtEnd=1
    }
    else 
    {
	    s Row=%ResultID(%counter)
	}
	q $$$OK
}

ClassMethod GetCTLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCTLocExecute ]
{
	s qHandle="" 
	q $$$OK
}

}
