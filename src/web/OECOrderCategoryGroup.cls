Include webimport

IncludeGenerator webimport

Class web.OECOrderCategoryGroup Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 117;

Parameter SQLDATEFROM = "OCGRP_DateFrom";

Parameter SQLDATETO = "OCGRP_DateTo";

Parameter SQLCODE = "OCGRP_Code";

Parameter SQLDESCRIPTION = "OCGRP_Desc";

Parameter SQLROWID = "OCGRP_RowId";

ClassMethod LookUpOrdCatGrpBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", x As %Library.String = "") As %Library.Boolean
{
}

Query LookUpOrdCatGrp(val As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "desc:%String,code:%String,HIDDEN:%String")
{

	SELECT OCGRP_Desc,OCGRP_Code,OCGRP_RowId
	FROM SQLUser.OEC_OrderCategoryGroup
	WHERE (((%ALPHAUP OCGRP_Desc %STARTSWITH %ALPHAUP :val) OR ( %ALPHAUP OCGRP_Code = %ALPHAUP :val) OR (:val IS NULL))
	AND (OCGRP_DateFrom <= CURRENT_DATE OR OCGRP_DateFrom IS NULL)
	AND (OCGRP_DateTo >= CURRENT_DATE OR OCGRP_DateTo IS NULL))
	ORDER BY OCGRP_Desc
}

ClassMethod LookUpOrdCatGrp2Broker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", SSGRP As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpOrdCatGrp2Close(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpOrdCatGrp2Fetch ]
{
}

ClassMethod LookUpOrdCatGrp2Execute(ByRef QHandle As %Library.Binary, Category As %Library.String = "", SSGRP As %Library.String = "") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

ClassMethod LookUpOrdCatGrp2Fetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpOrdCatGrp2Execute ]
{
}

Query LookUpOrdCatGrp2(CatGrp As %Library.String, SSGRP As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "Group:%String,Code:%String,HIDDEN:%String")
{
}

}
