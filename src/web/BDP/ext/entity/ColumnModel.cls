Class web.BDP.ext.entity.ColumnModel Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
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
		s myjosnstr=myjosnstr_"header"_":"_"'"_..header_"'"
	}
	
	i (..hidden'=""){
		s:myjosnstr'="" myjosnstr=myjosnstr_","
		s myjosnstr=myjosnstr_"""hidden"""_":"_""""_..hidden_""""
	}
	
	i (..align'=""){
		s:myjosnstr'="" myjosnstr=myjosnstr_","
		s myjosnstr=myjosnstr_"""align"""_":"_""""_..align_""""
	}

	i (..css'=""){
		s:myjosnstr'="" myjosnstr=myjosnstr_","
		s myjosnstr=myjosnstr_"""css"""_":"_""""_..css_""""
	}

	i (..fixed'=""){
		s:myjosnstr'="" myjosnstr=myjosnstr_","
		s myjosnstr=myjosnstr_"""fixed"""_":"_""""_..fixed_""""
	}

	i (..id'=""){
		s:myjosnstr'="" myjosnstr=myjosnstr_","
		s myjosnstr=myjosnstr_"""id"""_":"_""""_..id_""""
	}

	i (..resizable'=""){
		s:myjosnstr'="" myjosnstr=myjosnstr_","
		s myjosnstr=myjosnstr_"""resizable"""_":"_""""_..resizable_""""
	}
	i (..sortable'=""){
		s:myjosnstr'="" myjosnstr=myjosnstr_","
		s myjosnstr=myjosnstr_"""sortable"""_":"_""""_..sortable_""""
	}
	
	i (..width'=""){
		s:myjosnstr'="" myjosnstr=myjosnstr_","
		s myjosnstr=myjosnstr_"""width"""_":"_""_..width_""
	}
	
	i (..dataIndex'=""){
		s:myjosnstr'="" myjosnstr=myjosnstr_","
		s myjosnstr=myjosnstr_"dataIndex"_":"_"'"_..dataIndex_"'"
	}
	s myjosnstr="{"_myjosnstr_"}"
	q myjosnstr
}

Property dataIndex As %String;

}
