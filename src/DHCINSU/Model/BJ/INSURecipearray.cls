Class DHCINSU.Model.BJ.INSURecipearray Extends (%SerialObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "recipearray";

Relationship recipe As DHCINSU.Model.BJ.INSURecipe(XMLNAME = "recipe", XMLPROJECTION = "ELEMENT") [ Cardinality = many, Inverse = recipearray ];

Storage Default
{
<StreamLocation>^DHCINSU.Mo5F28.INSURecipea6B3BS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
