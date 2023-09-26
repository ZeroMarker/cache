Class DHCWL.DM.Util.FilterTree Extends %RegisteredObject
{

// -1 for flag root; 0 no logical; 1 for unbinary logical; 2 for binary logical

Property NodeType As %Integer;

Property Left As FilterTree;

Property Right As FilterTree;

Property LogicalOperator As %String;

Property Parent As FilterTree;

Property Expression As %String;

Property SegBitIndexMap [ MultiDimensional ];

//relationDim for metric bit index mapping

Property RMBitIMap [ MultiDimensional ];

//noly NodeType=0

Property Params As %List;

Property FilterFunction As %String;

Property DimStruct As %List;

Property proFunStructIndex As %Integer;

Property FunCall As DHCWL.DM.Util.FunctionCall;

Property parsedDimStruct As DHCWL.DM.Core.ParsedDimStruct;

Method %OnNew(nodeType As %Integer) As %Status [ Private, ServerOnly = 1 ]
{
    s ..NodeType=$g(nodeType,0)
    q $$$OK
}

Method SetLogical(logical)
{
	s ..LogicalOperator=logical
}

Method SetParent(parent As FilterTree)
{
	s ..Parent=parent
}

Method GetLogical() As %String
{
	q ..LogicalOperator
}

Method SeLeft(left As FilterTree)
{
	s ..Left=left
}

Method SetRight(right As FilterTree)
{
	s ..Right=right
}

Method GetLeft() As FilterTree
{
	q ..Left
}

Method GetRight() As FilterTree
{
	q ..Right
}

Method IsRoot() As %Boolean
{
	q (..LogicalOperator="") || (..Parent="")
}

Method SetExpression(expression As %String)
{
	s ..Expression=expression
}

Method IsRelationDim() As %Boolean
{
	q:..parsedDimStruct="" 0
 	q ..parsedDimStruct.IsRelationDim()
}

}
