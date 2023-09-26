Class DHCWL.DM.R.ComputedThemeMetrics Extends %RegisteredObject
{

Property Code As %String [ Required ];

Property DataType As DHCWL.DM.T.DataType;

Property SerialNumber As %Integer;

Property StructList As %List;

Method %OnNew(metricName, metricStruct As %List, sn As %Integer) As %Status [ Private, ServerOnly = 1 ]
{
	s ..Code=metricName
	s ..DataType=##class(DHCWL.DM.T.DataType).GetByJDBCTypeCode($lg(metricStruct,4,8))
	s ..SerialNumber=sn
	s $list(metricStruct,1)=metricName
	s $list(metricStruct,2)=sn
	s $list(metricStruct,3)=sn
	s $list(metricStruct,4)=8
	s ..StructList=metricStruct
	q $$$OK
}

Method GetJDBCTypeCodeNum() As %Integer [ CodeMode = expression ]
{
..DataType.JDBCTypeCodeNum
}

}
