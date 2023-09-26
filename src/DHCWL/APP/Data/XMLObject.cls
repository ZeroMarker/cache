Class DHCWL.APP.Data.XMLObject Extends %RegisteredObject
{

Property cursor As Cursor [ Private ];

Property dataStorage As DataStorageManager;

ClassMethod Create(cursor As Cursor, dataStorage As DataStorage) As JsonObject
{
	s xo=##class(XMLObject).%New()
	s xo.cursor=cursor
	s xo.dataStorage=dataStorage
	q xo
}

Method ToStream(ByRef writer As %XML.Writer) As %Status
{
	q ..PriToStream(..cursor.GetMeta(),..cursor,.writer)
}

Method ToString() As %String
{
	q ..PriToString(..cursor.GetMeta(),..cursor)
}

Method PriToStream(meta As Meta, cursor As Cursor, ByRef writer As %XML.Writer) As %Status [ Private ]
{
	q:((meta="")||(cursor="")) ""
	d writer.Element(meta.GetFullAccessLable())
	;s str="<"_meta.GetFullAccessLable()_">"
	f i=1:1:meta.GetPropertyCount() {
		s proName=meta.GetPropertyName(i)
		if (meta.IsArray(proName)){
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
					if value="" s value=""
				}else{
					;continue:cursor.Get(proName,j)=""
					s value=cursor.Get(proName,j)
				}
				d writer.Element(proName)
				d writer.WriteAttribute("Type",meta.GetPropertyType(proName))
				d writer.Write(value)
				d writer.EndElement()
				;s arrayStr=arrayStr_"<"_proName_" Type="""_meta.GetPropertyType(proName)_""">"_value_"</"_proName_">"
			}
			s str=str_arrayStr
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
			}else{
				s value=cursor.Get(proName)
			}
			d writer.Element(proName)
			d writer.WriteAttribute("Type",meta.GetPropertyType(proName))
			d writer.Write(value)
			d writer.EndElement()
			;s str=str_"<"_proName_" Type="""_meta.GetPropertyType(proName)_""">"_value_"</"_proName_">"
		}
	}
	d writer.EndElement()
	q $$$OK
	;q str_"</"_meta.GetFullAccessLable()_">"
}

Method PriToString(meta As Meta, cursor As Cursor) As %String [ Private ]
{
	q:((meta="")||(cursor="")) ""
	s str="<"_meta.GetFullAccessLable()_">"
	f i=1:1:meta.GetPropertyCount() {
		s proName=meta.GetPropertyName(i)
		if (meta.IsArray(proName)){
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
					if value="" s value=""
				}else{
					;continue:cursor.Get(proName,j)=""
					s value=cursor.Get(proName,j)
				}
				s arrayStr=arrayStr_"<"_proName_" Type="""_meta.GetPropertyType(proName)_""">"_value_"</"_proName_">"
			}
			s str=str_arrayStr
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
			}else{
				s value=cursor.Get(proName)
			}
			s str=str_"<"_proName_" Type="""_meta.GetPropertyType(proName)_""">"_value_"</"_proName_">"
		}
	}
	q str_"</"_meta.GetFullAccessLable()_">"
}

}
