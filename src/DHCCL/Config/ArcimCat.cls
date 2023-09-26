/// 医嘱项子类
Class DHCCL.Config.ArcimCat Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = ArcimCat ]
{

/// 医嘱项子类代码
Property Code As %String(COLLATION = "AlphaUp", MAXLEN = 70, TRUNCATE = 1) [ Required, SqlColumnNumber = 2 ];

/// 医嘱项子类名称
Property Description As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3 ];

/// 医嘱类型
Property OrderType As %String(DISPLAYLIST = ",Drug,Diet,IV,Consultation,Normal,Dental,LabTrak,RehabMedicine,Price,BloodBank,Diet Supplement,Hardware,Diet Enteral Feed,Day Book,DFT,Diet Thickened Fluid,Bulk Meal,Prosthetics,Material", MAXLEN = 20, TRUNCATE = 1, VALUELIST = ",R,D,I,C,N,T,L,X,P,B,S,H,E,A,F,DTF,BM,PROS,M") [ SqlColumnNumber = 4 ];

/// 医嘱项分类
Property OrderCategory As DHCCL.Config.OrderCategory [ SqlColumnNumber = 5 ];

Property ExternalID As %String [ SqlColumnNumber = 6 ];

Index OrdType On OrderType;

Index OrdCat On OrderCategory;

Index Ext On ExternalID;

Storage Default
{
<Data name="ArcimCatDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>OrderType</Value>
</Value>
<Value name="4">
<Value>OrderCategory</Value>
</Value>
<Value name="5">
<Value>ExternalID</Value>
</Value>
</Data>
<DataLocation>^DHCCL.Config.ArcimCatD</DataLocation>
<DefaultData>ArcimCatDefaultData</DefaultData>
<IdLocation>^DHCCL.Config.ArcimCatD</IdLocation>
<IndexLocation>^DHCCL.Config.ArcimCatI</IndexLocation>
<StreamLocation>^DHCCL.Config.ArcimCatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
