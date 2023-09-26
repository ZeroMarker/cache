Class epr.CTGraphDefinition Extends (%Library.Persistent, websys.Abstract) [ ClassType = persistent, CompileAfter = epr.CTGraphItemDefinition, Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 695;

Parameter SQLCODE = "GRPHCode";

Parameter SQLDATEFROM = "GRPHDateFromCurrent";

Parameter SQLDATETO = "GRPHDateToCurrent";

Parameter SQLDESCRIPTION = "GRPHDesc";

Parameter SQLROWID = "ID";

Property GRPHAdHocGraph As %Library.String(TRUNCATE = 1);

Property GRPHUserGraph As %Library.String(TRUNCATE = 1);

Property GRPHCode As %Library.String(COLLATION = "ALPHAUP", TRUNCATE = 1) [ Required ];

Property GRPHDesc As %Library.String(COLLATION = "ALPHAUP", TRUNCATE = 1);

Property GRPHY1AxisMax As %Library.String(TRUNCATE = 1);

Property GRPHY1AxisMin As %Library.String(TRUNCATE = 1);

Property GRPHY1AxisProfile As %Library.String(TRUNCATE = 1);

Property GRPHY1AxisStep As %Library.String(TRUNCATE = 1);

Property GRPHY1AxisType As %Library.String(TRUNCATE = 1);

Property GRPHY2AxisMax As %Library.String(TRUNCATE = 1);

Property GRPHY2AxisMin As %Library.String(TRUNCATE = 1);

Property GRPHY2AxisProfile As %Library.String(TRUNCATE = 1);

Property GRPHY2AxisStep As %Library.String(TRUNCATE = 1);

Property GRPHY2AxisType As %Library.String(TRUNCATE = 1);

Property GRPHGraphType As %Library.String(TRUNCATE = 1);

Property GRPHXAxisIncrement As %Library.Integer;

Property GRPHXAxisIncrementUnit As %Library.String(TRUNCATE = 1);

Property GRPHXAxisIntervalType As %Library.String(TRUNCATE = 1);

Property GRPHDateFromCurrent As %Library.String(TRUNCATE = 1);

Property GRPHDateToCurrent As %Library.String(TRUNCATE = 1);

Property GRPHDateFromOffset As %Library.String(TRUNCATE = 1);

Property GRPHDateToOffset As %Library.String(TRUNCATE = 1);

Property GraphItems As list Of epr.CTGraphItemDefinition;

/// Log 44734 - 30-09-2004 : New field to store User that created the Graph. DR to SSUser.
Property GRPHUserCreatedDR As User.SSUser;

/// Uniqueness index for property GRPHCode
Index UniqueGRPHCodeIndex On GRPHCode [ Unique ];

Index UniqueGRPHDescIndex On GRPHDesc [ Unique ];

/// Number of intervals for partogram
Property GRPHNoOfIntervals As %Library.Integer;

ClassMethod Bin(HexValue As %Library.String = "") As %Library.String
{
}

ClassMethod DeleteGraphByIDOrCode(GraphID As %Library.String = "", GraphCode As %Library.String = "")
{
}

/// Log 44734 - AI - 01-10-2004 : Get all graphs for the User - All within Graph Group, and adhoc graphs for the user.
ClassMethod GetAllGraphsForUserClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = GetAllGraphsForUserFetch ]
{
}

/// Log 44734 - AI - 01-10-2004 : Get all graphs for the User - All within Graph Group, and adhoc graphs for the user.
/// Called from component epr.CTGraphDefinition.List.
ClassMethod GetAllGraphsForUserExecute(ByRef QHandle As %Library.Binary) As %Library.Status
{
}

/// Log 44734 - AI - 01-10-2004 : Get all graphs for the User - All within Graph Group, and adhoc graphs for the user.
ClassMethod GetAllGraphsForUserFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = GetAllGraphsForUserExecute ]
{
}

ClassMethod GetCumulativeItemsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = GetCumulativeItemsFetch ]
{
}

ClassMethod GetCumulativeItemsExecute(ByRef QHandle As %Library.Binary, CumProfile As %Library.String = "", PatientID As %Library.String = "") As %Library.Status
{
}

ClassMethod GetCumulativeItemsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = GetCumulativeItemsExecute ]
{
}

/// Runs to get graph (GRPH) data in epr.CTGraph.Edit
ClassMethod GetGraphData(GraphID As %Library.String = "", GraphCode As %Library.String = "", GraphDesc As %Library.String = "", DontInitialise As %Library.String = 0)
{
}

ClassMethod GetGraphItemDetails(GraphID As %Library.String = "", GraphItemID As %Library.String = "")
{
}

ClassMethod GetGraphItemsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = GetGraphItemsFetch ]
{
}

ClassMethod GetGraphItemsExecute(ByRef QHandle As %Library.Binary, GraphCode As %String) As %Library.Status
{
}

ClassMethod GetGraphItemsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = GetGraphItemsExecute ]
{
}

ClassMethod GetRGB(HexColour As %Library.String = "") As %Library.String
{
}

ClassMethod GraphCleanUp()
{
}

/// Log 44734 - AI - 30-09-2004 : Method to return if the Graph is available for modification by the logged on User.
/// Called from component ChartFX.Link - GraphAvailableForUser item.
ClassMethod GraphAvailableForUser(graphdesc As %Library.String = "") As %Library.Boolean
{
}

/// Log 44734 - AI - 01-10-2004 : Look Up all graphs for the User - All within Graph Group, and adhoc graphs for the user.
ClassMethod LookUpAllGraphsForUserClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpAllGraphsForUserFetch ]
{
}

/// Log 44734 - AI - 01-10-2004 : Look Up all graphs for the User - All within Graph Group, and adhoc graphs for the user.
/// Called from the "Graph" item of component ChartFX.Link.
ClassMethod LookUpAllGraphsForUserExecute(ByRef QHandle As %Library.Binary, Desc As %Library.String) As %Library.Status
{
}

/// Log 44734 - AI - 01-10-2004 : Look Up all graphs for the User - All within Graph Group, and adhoc graphs for the user.
ClassMethod LookUpAllGraphsForUserFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpAllGraphsForUserExecute ]
{
}

ClassMethod LookUpByTypeClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpByTypeFetch ]
{
}

ClassMethod LookUpByTypeExecute(ByRef QHandle As %Library.Binary, profiledesc As %String, type As %String) As %Library.Status
{
}

ClassMethod LookUpByTypeFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpByTypeExecute ]
{
}

/// Invoked before websysSave - can be used to cancel the save
ClassMethod websysBeforeSave(compref As %String, ByRef GraphID As %String) As %Boolean
{
}

/// Default save method used for updating the database for Components of type Edit.
/// The compref is the component reference which is the string from which we can deduce the instance of
/// websysComponent
/// websysComponentItem
/// id is the id for the instance of class we wish to update.
ClassMethod websysSave(compref As %String, GraphID As %String, SystemFlag As %String)
{
}

/// Log 44734 - AI - 01-10-2004 : Get all graphs for the User - All within Graph Group, and adhoc graphs for the user.
/// Called from component epr.CTGraphDefinition.List.
Query GetAllGraphsForUser() As %Library.Query(CONTAINID = 0, ROWSPEC = "ID:%String,GRPHCode:%String,GRPHDesc:%String,graphY1AxisProfile,graphY1AxisType,graphY2AxisProfile,graphY2AxisType,graphY1AxisMin,graphY1AxisMax,graphY1AxisStep,graphY2AxisMin,graphY2AxisMax,graphY2AxisStep,graphchk,GRPHGraphType,graphXAxisIncrement,graphXAxisIncrementUnit,GRPHDateFromCurrent,GRPHDateToCurrent,GRPHDateFromOffset,GRPHDateToOffset")
{
}

Query GetCumulativeItems(CumProfile As %Library.String, PatientID As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "ItemCode:%Library.String,ItemDesc:%Library.String")
{
}

Query GetGraphDetailsByCodeOrDesc(graphid As %String, code As %Library.String, desc As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,GRPHCode,GRPHDesc,GRPHY1AxisMax,GRPHY1AxisMin,GRPHY1AxisStep,GRPHY2AxisMax,GRPHY2AxisMin,GRPHY2AxisStep,GRPHAdHocGraph,GRPHGraphType,GRPHXAxisIncrement,GRPHXAxisIncrementUnit,GRPHXAxisIntervalType,GRPHDateFromCurrent,GRPHDateToCurrent,GRPHDateFromOffset,GRPHDateToOffset")
{
SELECT ID, GRPHCode, GRPHDesc, 
 GRPHY1AxisMax, GRPHY1AxisMin, GRPHY1AxisStep, 
 GRPHY2AxisMax, GRPHY2AxisMin, GRPHY2AxisStep,
 GRPHAdHocGraph, GRPHGraphType, GRPHXAxisIncrement,
 GRPHXAxisIncrementUnit, GRPHXAxisIntervalType, GRPHDateFromCurrent, 
 GRPHDateToCurrent, GRPHDateFromOffset, GRPHDateToOffset
FROM epr.CTGraphDefinition
WHERE (ID = :graphid) OR (GRPHCode = :code) OR (GRPHDesc = :desc)
}

Query GetGraphItems(GRPHCode As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "ItemID,ItemName,Type,NormLine,VarLine,Colour,Marker,YAxis,UpRange,LowRange,Sequence,RefColour,itmDR,itmCode,RGBCol,RefRGBCol,normlineValue,varlineValue,markerValue,flags,lnkitmname,MarkerSize,lnkitmDR,NonLinearRefRanges,ObsOnly")
{
}

/// Log 44734 - AI - 01-10-2004 : Look Up all graphs for the User - All within Graph Group, and adhoc graphs for the user.
/// Called from the "Graph" item of component ChartFX.Link.
Query LookUpAllGraphsForUser(Desc As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "GRPHDesc:%String,GRPHCode:%String,HIDDEN:%String,HIDDEN:%String,SystemGraph:%String,graphtype")
{
}

/// Basic query returning description from a partial description, ordered by description.
/// Compiled will attempt to derive the 'description' property from available properties unless it is explicity
/// set in the SQLDESCRIPTION parameter.
/// SQLROWID may be used to specify the field name to be used as rowid.
Query LookUpGraph(desc As %String) As %Library.SQLQuery(CONTAINID = 3, ROWSPEC = "Description:%String,Code:%String,HIDDEN:%String")
{
SELECT GRPHDesc, GRPHCode, ID
FROM epr.CTGraphDefinition
WHERE (%ALPHAUP GRPHCode = %ALPHAUP :desc) OR (%ALPHAUP GRPHDesc %STARTSWITH %ALPHAUP :desc) 
AND ((GRPHAdHocGraph = 'N') AND ((GRPHUserGraph = 'N') OR (GRPHUserGraph IS NULL)))
}

Storage Default
{
<Data name="CTGraphDefinitionClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="CTGraphDefinitionDefaultData">
<Value name="1">
<Value>GRPHCode</Value>
</Value>
<Value name="2">
<Value>GRPHDesc</Value>
</Value>
<Value name="3">
<Value>GRPHY1AxisProfile</Value>
</Value>
<Value name="4">
<Value>GRPHY1AxisType</Value>
</Value>
<Value name="5">
<Value>GRPHY2AxisProfile</Value>
</Value>
<Value name="6">
<Value>GRPHY2AxisType</Value>
</Value>
<Value name="7">
<Value>GRPHY1AxisMax</Value>
</Value>
<Value name="8">
<Value>GRPHY1AxisMin</Value>
</Value>
<Value name="9">
<Value>GRPHY1AxisStep</Value>
</Value>
<Value name="10">
<Value>GRPHY2AxisMax</Value>
</Value>
<Value name="11">
<Value>GRPHY2AxisMin</Value>
</Value>
<Value name="12">
<Value>GRPHY2AxisStep</Value>
</Value>
<Value name="13">
<Value>GraphItems</Value>
</Value>
<Value name="14">
<Value>GRPHAdHocGraph</Value>
</Value>
<Value name="15">
<Value>GRPHParRef</Value>
</Value>
<Value name="16">
<Value>UserCreatedDR</Value>
</Value>
<Value name="17">
<Value>GRPHUserCreatedDR</Value>
</Value>
<Value name="18">
<Value>GRPHUserGraph</Value>
</Value>
<Value name="19">
<Value>GRPHYGroupType</Value>
</Value>
<Value name="20">
<Value>GRPHGroupType</Value>
</Value>
<Value name="21">
<Value>GRPHGraphType</Value>
</Value>
<Value name="22">
<Value>GRPHXAxisIncrementAmount</Value>
</Value>
<Value name="23">
<Value>GRPHXAxisIncrementUnit</Value>
</Value>
<Value name="24">
<Value>GRPHXAxisIncrement</Value>
</Value>
<Value name="25">
<Value>GRPHDateFromCurrent</Value>
</Value>
<Value name="26">
<Value>GRPHDateFromOffset</Value>
</Value>
<Value name="27">
<Value>GRPHDateToCurrent</Value>
</Value>
<Value name="28">
<Value>GRPHDateToOffset</Value>
</Value>
<Value name="29">
<Value>GRPHXAxisIntervalType</Value>
</Value>
<Value name="30">
<Value>GRPHNoOfIntervals</Value>
</Value>
</Data>
<DataLocation>^epr.CTGraphDefinitionD</DataLocation>
<DefaultData>CTGraphDefinitionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^epr.CTGraphDefinitionD</IdLocation>
<IndexLocation>^epr.CTGraphDefinitionI</IndexLocation>
<StreamLocation>^epr.CTGraphDefinitionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
