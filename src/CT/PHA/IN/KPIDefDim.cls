Class CT.PHA.IN.KPIDefDim Extends (%Persistent, User.Abstract) [ SqlRowIdName = Defd_RowID, SqlTableName = KPIDefDim, StorageStrategy = ObjStorage ]
{

Relationship DefdParref As CT.PHA.IN.KPIDefinition [ Cardinality = parent, Inverse = ChildDefDim, Required, SqlFieldName = Defd_Parref ];

Property DefdDimDr As CT.PHA.IN.KPIDimension [ SqlColumnNumber = 2, SqlFieldName = Defd_Dim_Dr ];

Property DefdOrder As %Integer [ SqlColumnNumber = 3, SqlFieldName = Defd_Order ];

Index DefDimI On (DefdParref, DefdDimDr);

Index DefOrderI On (DefdParref, DefdOrder);

Storage ObjStorage
{
<Data name="KPIDefDimDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DefdDimDr</Value>
</Value>
<Value name="3">
<Value>DefdOrder</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("DIM")</DataLocation>
<DefaultData>KPIDefDimDefaultData</DefaultData>
<IdLocation>{%%PARENT}("DIM")</IdLocation>
<IndexLocation>^CT.PHA.IN.KPIDefI</IndexLocation>
<StreamLocation>^CT.PHA.IN.KPIDefS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
