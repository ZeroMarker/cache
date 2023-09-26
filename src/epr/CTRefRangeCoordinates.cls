Class epr.CTRefRangeCoordinates Extends (%Library.Persistent, websys.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 34;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "ID";

Parameter SQLDESCRIPTION = "ID";

Parameter SQLROWID = "ID";

Property GRCOParRef As epr.CTGraphRefRange;

Property GRCOXCoordinate As %Library.Float;

Property GRCOYCoordinate As %Library.Float;

/// Quick way to add an item.
ClassMethod AddItem(id As %Library.String, XCo As %Library.Integer, YCo As %Library.Integer)
{
}

/// Default save method used for updating the database for Components of type Edit.<br>
/// <br>
/// The compref is the  component reference which is the string from which we can deduce the instance of<BR>
/// websysComponent<BR>
/// websysComponentItem<BR>
/// id is the id for the instance of class we wish to update.
ClassMethod websysSave(compref As %String, id As %String)
{
}

Query GetRefRangeCoordinates(ParRef As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "XCoord,YCoord,Description,XIncrement")
{
	SELECT GRCOXCoordinate,GRCOYCoordinate,GRCOParRef->GREFDesc,GRCOParRef->GREFXAxisIncrement
	FROM epr.CTRefRangeCoordinates 
	WHERE GRCOParRef=:ParRef
}

Storage Default
{
<Data name="CTRefRangeCoordinatesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GRCOParRef</Value>
</Value>
<Value name="3">
<Value>GRCOXCoordinate</Value>
</Value>
<Value name="4">
<Value>GRCOYCoordinate</Value>
</Value>
</Data>
<DataLocation>^epr.CTRefRangeCoordinatesD</DataLocation>
<DefaultData>CTRefRangeCoordinatesDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^epr.CTRefRangeCoordinatesD</IdLocation>
<IndexLocation>^epr.CTRefRangeCoordinatesI</IndexLocation>
<StreamLocation>^epr.CTRefRangeCoordinatesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
