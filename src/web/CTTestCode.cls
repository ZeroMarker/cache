Class web.CTTestCode Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod GetIdFromCodeOrDescription(val As %Library.String) As %Library.String
{
}

ClassMethod LookUpBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", TestItem As %Library.String = "", orderitem As %Library.String, OrdCategory As %Library.String, EpisodeID As %Library.String) As %Library.Boolean
{
}

ClassMethod LookUpEpisodeTestItemClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpEpisodeTestItemFetch ]
{
}

ClassMethod LookUpEpisodeTestItemExecute(ByRef QHandle As %Library.Binary, TestItem As %Library.String, orderitem As %Library.String, OrdCategory As %Library.String = "", EpisodeID As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpEpisodeTestItemFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpEpisodeTestItemExecute ]
{
}

/// Log 58657 YC - Broker for LookUp query. Used in Lab Cumulative profile (OEOrder.Edit.LabCummProfile)
/// ab 8.05.06 56897 - added restriction
ClassMethod LookUpTestItemOnlyBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", testitem As %String, Restrict As %String = "") As %Library.Boolean
{
}

}
