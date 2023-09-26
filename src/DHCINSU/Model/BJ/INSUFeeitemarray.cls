Class DHCINSU.Model.BJ.INSUFeeitemarray Extends (%SerialObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "feeitemarray";

//(XMLNAME = "feeitem", XMLPROJECTION = "ATTRIBUTE") 

//没有 (XMLPROJECTION = "ELEMENT") 无法解析feeitem

Relationship feeitem As DHCINSU.Model.BJ.INSUFeeitem(XMLPROJECTION = "ELEMENT") [ Cardinality = many, Inverse = feeitemarray ];

Storage Default
{
<StreamLocation>^DHCINSU.Mo5F28.INSUFeeitem2744S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
