Class EMRservice.ExtendDomParse Extends (%XML.Document, %XML.Node)
{

/// Create a doocument by parsing the XML document contained in a stream.<br>
/// The parsed document is returned in <var>document</var>.<br>
/// A %Status is returned to indicate if parsing is successful.
ClassMethod GetDocumentFromStream(stream As %BinaryStream, Output document As %XML.Document) As %Status
{
	// Parse the message stream so that pieces may be Canonicalized
	If stream=0 {
		q ""
	} Else {
		Do stream.Rewind()
	}
	Set reader = ##class(%XML.Reader).%New()
	Set sc=reader.OpenStream(stream)
	If $$$ISERR(sc) Quit sc
	Set document=reader.Document
	If document.GetVersion()<2 {
		Do document.AddWSSecurityIds()
	}
	Quit $$$OK
}

}
