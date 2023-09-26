Class DHCINSU.Model.BJ.INSUBasFeesInfoCollection Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNORENULL = 1;

Property INSUBasFeesInfo As list Of DHCINSU.Model.BJ.INSUBasFeesInfo;

//Relationship INSUBasFeesInfo As DHCINSU.Model.BJ.INSUBasFeesInfo(XMLPROJECTION = "ELEMENT") [ Cardinality = many, Inverse = INSUBasFeesInfoCollection ];

}
