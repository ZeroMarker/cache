/// Creator:      EH
/// CreatDate:    2022-06-20
/// Description:  定义表
Class CT.NUR.MNIS.H8D5P.Definition Extends (%Persistent, CT.NUR.MNIS.H8D5P.Base) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Entry As CT.NUR.MNIS.H8D5P.Entry [ Cardinality = children, Inverse = Definition ];

Property Inherit As CT.NUR.MNIS.H8D5P.Definition;

Property Identifier As %String(MAXLEN = 256, TRUNCATE = 1) [ Required ];

Property Interpretation As %String(MAXLEN = 1024, TRUNCATE = 1);

Property Remarks As %String(MAXLEN = 256, TRUNCATE = 1);

Property Number As %Integer;

Property System As %Boolean;

Index Inherit On (Inherit, Identifier);

Trigger Numberer [ Event = INSERT, Foreach = row/object, Time = AFTER ]
{
	n (%oper,pNew,pOld,pChanged,%ok,%msg,%ROWCOUNT,%ROWID,%check,%cls,%d,%i,%l,%ls,%mv,%tstart,%xxsql,SQLCODE,sn,sqlcode)
	s id=$g(%d(1)),inherit=$g(%d(3)),number=$g(%d(5)),no=0,null=$$$NULLNODE,l2=$s(inherit'="":inherit,1:null)
 	s i3="" f  s i3=$o(^CT.NUR.MNIS.H8D5P.DefinitionI("Inherit",l2," "_i3)),i3=$e(i3,2,$l(i3)) q:(i3="")  d
 	.s i4=0 f  s i4=$o(^CT.NUR.MNIS.H8D5P.DefinitionI("Inherit",l2," "_i3,i4)) q:(i4="")  d
 	..s l6=$lg(^CT.NUR.MNIS.H8D5P.DefinitionD(i4),6)
 	..i (l6>no)&&(i4'=id) s no=l6
 	s no=$i(no)
 	i (number'=no) d
 	.s object=##class(CT.NUR.MNIS.H8D5P.Definition).%OpenId(id)
 	.i ($isobject(object)) d
 	..i (object.Number="") d
 	...s object.Number=no
 	...i (object.%Save()=1) s %d(5)=no
 	...e  s %ok=0,%msg=%objlasterror
 	..d object.%Close()
}

Storage Default
{
<Data name="DefinitionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Inherit</Value>
</Value>
<Value name="3">
<Value>Identifier</Value>
</Value>
<Value name="4">
<Value>Interpretation</Value>
</Value>
<Value name="5">
<Value>Remarks</Value>
</Value>
<Value name="6">
<Value>Number</Value>
</Value>
<Value name="7">
<Value>System</Value>
</Value>
</Data>
<DataLocation>^CT.NUR.MNIS.H8D5P.DefinitionD</DataLocation>
<DefaultData>DefinitionDefaultData</DefaultData>
<IdLocation>^CT.NUR.MNIS.H8D5P.DefinitionD</IdLocation>
<IndexLocation>^CT.NUR.MNIS.H8D5P.DefinitionI</IndexLocation>
<StreamLocation>^CT.NUR.MNIS.H8D5P.DefinitionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
