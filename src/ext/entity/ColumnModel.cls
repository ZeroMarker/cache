Class ext.entity.ColumnModel Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

/// The header text to display in the Grid view
Property header As %String;

/// optional) True to hide the column. Defaults to false
Property hidden As %String;

/// (optional) Set the CSS text-align property of the column. Defaults to undefined
Property align As %String;

/// (optional) Set custom CSS for all table cells in the column (excluding headers). Defaults to undefined.
Property css As %String;

/// (optional) True if the column width cannot be changed. Defaults to false.
Property fixed As %String;

Property id As %String;

/// optional) False to disable column resizing. Defaults to true.
Property resizable As %String;

/// (optional) True if sorting is to be allowed on this column. Defaults to the value of the defaultSortable property
Property sortable As %String;

/// optional) The initial width in pixels of the column
Property width As %String;

Method GetJosnData() As %String
{
	s myjosnstr=""
	i (..header'=""){
		s:myjosnstr'="" myjosnstr=myjosnstr_","
		;优先取翻译
		i $e(..header,1,3)="$g(" s myjosnstr=myjosnstr_"""header"":"""_..header_""""
		e  s myjosnstr=myjosnstr_"""header"":"_""""_..header_""""
	}
	
	i (..hidden'=""){
		s:myjosnstr'="" myjosnstr=myjosnstr_","
		s myjosnstr=myjosnstr_"""hidden"":"_..hidden
	}
	
	i (..align'=""){
		s:myjosnstr'="" myjosnstr=myjosnstr_","
		s myjosnstr=myjosnstr_"""align"":"""_..align_""""
	}

	i (..css'=""){
		s:myjosnstr'="" myjosnstr=myjosnstr_","
		s myjosnstr=myjosnstr_"""css"":"""_..css_""""
	}

	i (..fixed'=""){
		s:myjosnstr'="" myjosnstr=myjosnstr_","
		s myjosnstr=myjosnstr_"""fixed"":"_..fixed
	}

	i (..id'=""){
		s:myjosnstr'="" myjosnstr=myjosnstr_","
		s myjosnstr=myjosnstr_"""id"":"""_..id_""""
	}

	i (..resizable'=""){
		s:myjosnstr'="" myjosnstr=myjosnstr_","
		s myjosnstr=myjosnstr_"""resizable"":"_..resizable
	}
	i (..sortable'=""){
		s:myjosnstr'="" myjosnstr=myjosnstr_","
		s myjosnstr=myjosnstr_"""sortable"":"_..sortable
	}
	
	i (..width'=""){
		s:myjosnstr'="" myjosnstr=myjosnstr_","
		s myjosnstr=myjosnstr_"""width"":"_+..width
	}
	
	i (..dataIndex'=""){
		s:myjosnstr'="" myjosnstr=myjosnstr_","
		s myjosnstr=myjosnstr_"""dataIndex"":"""_..dataIndex_""""
	}
	s myjosnstr="{"_myjosnstr_"}"
	q myjosnstr
}

Property dataIndex As %String;

}
