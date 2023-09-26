Class web.BDP.ext.entity.ColumnModels Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Property cms As list Of ColumnModel;

Method GetJosnData() As %String
{
	;
	;list
	s myjosnstr=""
	
	;;List 对象的
	s mycount=..cms.Count()
	s mycmsstr=""
	for myidx=1:1:mycount {
		s:(mycmsstr'="") mycmsstr=mycmsstr_","
		s myobj=..cms.GetAt(myidx)
		s mysubstr=myobj.GetJosnData()
		s mycmsstr=mycmsstr_mysubstr
	}
	i mycmsstr'=""{
		;s mycmsstr="["_mycmsstr_"]"
	}
	i mycmsstr'=""{
		s:(myjosnstr'="") myjosnstr=myjosnstr_","
		s myjosnstr=myjosnstr_mycmsstr
	}
	
	q myjosnstr
}

}
