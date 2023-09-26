Class DHCENS.BC.Model.BookedInfo Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "BookedInfo";

Property Rowid As %String(MAXLEN = 32767);

Property ResourceInfo As %String(MAXLEN = 32767);

Property BookedDate As %String(MAXLEN = 32767);

Property BookedTime As %String(MAXLEN = 32767);

Property OperaterInfo As %String(MAXLEN = 32767);

Property NoteInfo As %String(MAXLEN = 32767);

Property OtherInfo As %String(MAXLEN = 32767);

}
