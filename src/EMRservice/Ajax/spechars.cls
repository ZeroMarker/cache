Class EMRservice.Ajax.spechars Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s ResultStream = ##Class(%GlobalCharacterStream).%New()
	d ResultStream.Write("[")
	s result = ##Class(EMRservice.BL.BLSpechars).GetSpechars()
	d ResultStream.Write(result)
	d ResultStream.Write("]")
	while (ResultStream.AtEnd = 0)
	{
		w $ZSTRIP(ResultStream.Read(32000),"*C",,$c(1)_$c(2))
	}
	Quit $$$OK
}

}
