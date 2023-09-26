Class dhc.dto.BaseDto Extends %RegisteredObject
{

Property rowid As %String;

Property msg As %String [ InitialExpression = "默认提示" ];

Property success As %Boolean [ InitialExpression = 0 ];

Property results As %String [ InitialExpression = "[]" ];

Method toJson()
{
	Quit ##class(ext.util.JsonObject).ObjToJson($this)
}

}
