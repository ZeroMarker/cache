/// Creator:      EH
/// CreatDate:    2022-06-20
/// Description:  条目表
Class CT.NUR.MNIS.H8D5P.Entry Extends (%Persistent, CT.NUR.MNIS.H8D5P.Base) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Definition As CT.NUR.MNIS.H8D5P.Definition [ Cardinality = parent, Inverse = Entry ];

Relationship Property As CT.NUR.MNIS.H8D5P.Property [ Cardinality = children, Inverse = Entry ];

Property Inherit As CT.NUR.MNIS.H8D5P.Entry;

Property Reference As CT.NUR.MNIS.H8D5P.Definition;

Property Quotation As CT.NUR.MNIS.H8D5P.Entry;

Property Name As %String(MAXLEN = 256, TRUNCATE = 1);

Property Value As %String(MAXLEN = 1024, TRUNCATE = 1);

Property Remarks As %String(MAXLEN = 256, TRUNCATE = 1);

Property Number As %Integer;

Property System As %Boolean;

Index Inherit On (Inherit, Name);

Trigger Numberer [ Event = INSERT, Foreach = row/object, Time = AFTER ]
{
	n (%oper,pNew,pOld,pChanged,%ok,%msg,%ROWCOUNT,%ROWID,%check,%cls,%d,%i,%l,%ls,%mv,%tstart,%xxsql,SQLCODE,sn,sqlcode)
	s id=$g(%d(1)),inherit=$g(%d(2)),number=$g(%d(4)),no=0,null=$$$NULLNODE,l2=$s(inherit'="":inherit,1:null),i4=+id
 	i (inherit'="")&&(+inherit'=i4) {
		s i5=0 f  s i5=$o(^CT.NUR.MNIS.H8D5P.EntryD(i4,i5)) q:(i5="")  d
 		.s lb=$g(^CT.NUR.MNIS.H8D5P.EntryD(i4,i5)),l2=$lg(lb,2),l8=$lg(lb,8)
 		.i (+l2'=i4)&&(l8>no)&&(i5'=$p(id,"||",2)) s no=l8
	} else {
	 	s i3="" f  s i3=$o(^CT.NUR.MNIS.H8D5P.EntryI("Inherit",l2," "_i3)),i3=$e(i3,2,$l(i3)) q:(i3="")  d
	 	.s i5=0 f  s i5=$o(^CT.NUR.MNIS.H8D5P.EntryI("Inherit",l2," "_i3,i4,i5)) q:(i5="")  d
	 	..s lb=$g(^CT.NUR.MNIS.H8D5P.EntryD(i4,i5)),l8=$lg(lb,8)
	 	..i (l8>no)&&(i5'=$p(id,"||",2)) s no=l8
	}
 	s no=$i(no)
 	i (number'=no) d
 	.s object=##class(CT.NUR.MNIS.H8D5P.Entry).%OpenId(id)
 	.i ($isobject(object)) d
 	..i (object.Number="") d
 	...s object.Number=no
 	...i (object.%Save()=1) s %d(4)=no
 	...e  s %ok=0,%msg=%objlasterror
 	..d object.%Close()
}

Storage Default
{
<Data name="EntryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Inherit</Value>
</Value>
<Value name="3">
<Value>Reference</Value>
</Value>
<Value name="4">
<Value>Quotation</Value>
</Value>
<Value name="5">
<Value>Name</Value>
</Value>
<Value name="6">
<Value>Value</Value>
</Value>
<Value name="7">
<Value>Remarks</Value>
</Value>
<Value name="8">
<Value>Number</Value>
</Value>
<Value name="9">
<Value>System</Value>
</Value>
</Data>
<DataLocation>^CT.NUR.MNIS.H8D5P.EntryD</DataLocation>
<DefaultData>EntryDefaultData</DefaultData>
<IdLocation>^CT.NUR.MNIS.H8D5P.EntryD</IdLocation>
<IndexLocation>^CT.NUR.MNIS.H8D5P.EntryI</IndexLocation>
<StreamLocation>^CT.NUR.MNIS.H8D5P.EntryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
