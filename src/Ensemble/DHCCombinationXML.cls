Class Ensemble.DHCCombinationXML Extends (%Persistent, %XML.Adaptor) [ Inheritance = right ]
{

//w ##class(Ensemble.DHCCombinationXML).DHCCombinationXMLToBS("NO","BAIYAOJI","69","BAIYAOJI")

//w ##class(Ensemble.DHCCombinationXML).DHCCombinationXMLToBS("DrugInfo","BAIYAOJI","","BAIYAOJI")

Storage Default
{
<Data name="DHCCombinationXMLDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^Ensemble.DHCCombinationXMLD</DataLocation>
<DefaultData>DHCCombinationXMLDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^Ensemble.DHCCombinationXMLD</IdLocation>
<IndexLocation>^Ensemble.DHCCombinationXMLI</IndexLocation>
<StreamLocation>^Ensemble.DHCCombinationXMLS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

//w ##class(Ensemble.DHCCombinationXML).DHCCombinationXMLToBS("DrugInfo","BAIYAOJI","69","BAIYAOJI")

ClassMethod DHCCombinationXMLToBS(Instruction As %String, InterfaceType As %String, InputString As %String, Method As %String) As %String
{
   
	s str="s myobj=##class(Ensemble.DHCCPHARMACYSoap).%New()"
	s str=str_" s myMsg=##class(Ensemble.Request).%New()"
	s str=str_" s myMsg.Instruction="""_Instruction_""""
	s str=str_" s myMsg.InterfaceType="""_InterfaceType_""""
	s str=str_" s myMsg.InputString="""_InputString_""""
	s str=str_" d myMsg.XMLExportToString(.myxml)"
	s str=str_" s ^zWBResult(2)=myxml"
	s str=str_" s myrtn=myobj."_Method_"("_"myxml"_")"
	s str=str_" s ^zWBResult(1)=myrtn"
	XECUTE str
	Kill myobj
	Set reader = ##class(%XML.Reader).%New()
    Set sc=reader.OpenString(^zWBResult(1)) 
    If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit   
    Do reader.Correlate("Response","Ensemble.Response") 
    While reader.Next(.admission,.sc)  {
	   s ResultCode=admission.ResultCode
	   s ErrorMsg=admission.ErrorMsg
    }
    q ResultCode
}

}
