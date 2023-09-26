Class DHCWL.APP.Data.JsonObject Extends %RegisteredObject
{

Property cursor As Cursor [ Private ];

Property dataStorage As DataStorageManager;

ClassMethod Create(cursor As Cursor, dataStorage As DataStorage) As JsonObject
{
	s jo=##class(JsonObject).%New()
	s jo.cursor=cursor
	s jo.dataStorage=dataStorage
	q jo
}

Method Get(propertyName) [ CodeMode = expression ]
{
..cursor.Get(propertyName)
}

/*
Method Set(property, value) As %Status
{
	q ..cursor.Set(property,value)
}
*/
Method ToString() As %String
{
	s meta=..cursor.GetMeta()
	q ..PriToString(meta,..cursor)
}

Method ToArrayString() As %String
{
	s meta=..cursor.GetMeta()
	q ..PriToArrayString(meta,..cursor)
}

Method PriToString(meta As Meta, cursor As Cursor) As %String [ Private ]
{
	q:((meta="")||(cursor="")) ""
	s str=""
	f i=1:1:meta.GetPropertyCount() {
		s proName=meta.GetPropertyName(i)
		if (meta.IsArray(proName)){
			s str2=proName_":["
			s arrayLen=..cursor.GetArraySize(proName)
			s arrayStr=""
			f j=1:1:arrayLen {
				if (meta.GetProperty(proName)){
					s access=cursor.GetMeta().GetFullAccessLable()
					s access=access_"."_proName
					s childCursor=..dataStorage.GetCursor(access)
					s childRowId=cursor.Get(proName,j)
					s childCursor=childCursor.MoveTo(childRowId)
					s value=..PriToString(meta.GetProperty(proName),childCursor)
					if value="" s value="{}"
				}else{
					;continue:cursor.Get(proName,j)=""
					s value=##class(JsonObject).JsonTypeDeliValue(meta.GetPropertyType(proName),cursor.Get(proName,j))
				}
				if arrayStr="" {
					s arrayStr=value
				}else{
					s arrayStr=arrayStr_","_value
				}
			}
			s str2=str2_arrayStr_"]"
			if str="" {
				s str=str2
			}else{
				s str=str_","_str2
			}
		}else{
			if (meta.GetProperty(proName)){
				s access=cursor.GetMeta().GetFullAccessLable()
				s access=access_"."_proName
				s childCursor=..dataStorage.GetCursor(access)
				s childRowId=cursor.Get(proName)
				if childRowId {
					d childCursor.MoveTo(cursor.Get(proName))
					s value=..PriToString(meta.GetProperty(proName),childCursor)
				}else{
					s value=..PriToString(meta.GetProperty(proName),"")
				}
				if value="" s value="{}"
			}else{
				;continue:cursor.Get(proName)=""
				s value=##class(JsonObject).JsonTypeDeliValue(meta.GetPropertyType(proName),cursor.Get(proName))
			}
			if str="" {
				s str=proName_":"_value
			}else{
				s str=str_","_proName_":"_value
			}
		}
	}
	q "{"_str_"}"
}

Method PriToArrayString(meta As Meta, cursor As Cursor) As %String [ Private ]
{
	q:((meta="")||(cursor="")) ""
	s str=""
	f i=1:1:meta.GetPropertyCount() {
		s proName=meta.GetPropertyName(i)
		if (meta.IsArray(proName)){
			s str2="["
			s arrayLen=..cursor.GetArraySize(proName)
			s arrayStr=""
			f j=1:1:arrayLen {
				if (meta.GetProperty(proName)){
					s access=cursor.GetMeta().GetFullAccessLable()
					s access=access_"."_proName
					s childCursor=..dataStorage.GetCursor(access)
					s childRowId=cursor.Get(proName,j)
					s childCursor=childCursor.MoveTo(childRowId)
					s value=..PriToString(meta.GetProperty(proName),childCursor)
					if value="" s value="[]"
				}else{
					;continue:cursor.Get(proName,j)=""
					s value=##class(JsonObject).JsonTypeDeliValue(meta.GetPropertyType(proName),cursor.Get(proName,j))
				}
				if arrayStr="" {
					s arrayStr=value
				}else{
					s arrayStr=arrayStr_","_value
				}
			}
			s str2=str2_arrayStr_"]"
			if str="" {
				s str=str2
			}else{
				s str=str_","_str2
			}
		}else{
			if (meta.GetProperty(proName)){
				s access=cursor.GetMeta().GetFullAccessLable()
				s access=access_"."_proName
				s childCursor=..dataStorage.GetCursor(access)
				s childRowId=cursor.Get(proName)
				if childRowId {
					d childCursor.MoveTo(cursor.Get(proName))
					s value=..PriToString(meta.GetProperty(proName),childCursor)
				}else{
					s value=..PriToString(meta.GetProperty(proName),"")
				}
				if value="" s value="[]"
			}else{
				;continue:cursor.Get(proName)=""
				s value=##class(JsonObject).JsonTypeDeliValue(meta.GetPropertyType(proName),cursor.Get(proName))
			}
			if str="" {
				s str=value
			}else{
				s str=str_","_value
			}
		}
	}
	q "["_str_"]"
}

ClassMethod JsonTypeDeliValue(type, value) As %String
{
	if (type [ "String") {
		s value= ##class(DHCWL.util.StringUtil).ReplaceStr(value,"'","\'")
		s value= ##class(DHCWL.util.StringUtil).ReplaceStr(value,"""","\""")
		s value=""""_value_""""
	}else {
		if value="" s value=""""""
	}
	q value
}

}
