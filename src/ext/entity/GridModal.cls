/// 解析的Ext对象
/// ColumnModal  
/// Field 对象
Class ext.entity.GridModal Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

/// columModle
Property cms As list Of ColumnModel;

/// fieldNames
Property fns As list Of Field;

Method GetJosnData() As %String
{
	s myjosnstr=""
	
	;;List 对象的 cms
	s mycount=..cms.Count()
	s mycmsstr=""
	for myidx=1:1:mycount {
		s:(mycmsstr'="") mycmsstr=mycmsstr_","
		s myobj=..cms.GetAt(myidx)
		s mysubstr=myobj.GetJosnData()
		s mycmsstr=mycmsstr_mysubstr
	}
	i mycmsstr'=""{
		s mycmsstr="["_mycmsstr_"]"
		
	}
	s mycmsstr="""cms"""_":"_mycmsstr
	i mycmsstr'=""{
		s:(myjosnstr'="") myjosnstr=myjosnstr_","
		s myjosnstr=myjosnstr_mycmsstr
	}
	
	;;List 对象的 fns
	s mycount=..fns.Count()
	s myfnsstr=""
	s mysubstr=""
	for myidx=1:1:mycount {
		
		s:(myfnsstr'="") myfnsstr=myfnsstr_","
		s myobj=..fns.GetAt(myidx)
		s mysubstr=myobj.GetJosnData()
		s myfnsstr=myfnsstr_mysubstr
	}
	
	i myfnsstr'=""{
		s myfnsstr="["_myfnsstr_"]"
	}
	
	s myfnsstr="""fns"""_":"_myfnsstr
	i myfnsstr'=""{
		s:(myjosnstr'="") myjosnstr=myjosnstr_","
		s myjosnstr=myjosnstr_myfnsstr
	}
	
	s myjosnstr="{"_myjosnstr_"}"
	
	q myjosnstr
}

}
