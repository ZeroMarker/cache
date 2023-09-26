Class DHCWL.VerManagement.VerData Extends %Persistent
{

///  pl
///  2016-02-02
///  版本管理存储版本记录 
Parameter VMDName;

Parameter VMDCode;

Parameter VMDTSName;

Parameter VMDUpDate;

Parameter VMDInstallDate;

Parameter VMDInstallTime;

Parameter VMDremarks;

/// select * from DHCWL_VerManagement.VerData
Property VMDName As %Library.String [ SqlColumnNumber = 2 ];

/// 产品版本
Property VMDCode As %Library.String [ SqlColumnNumber = 3 ];

/// 技术支持者（产品作者）
Property VMDTSName As %Library.String [ SqlColumnNumber = 4 ];

/// 发布日期
Property VMDUpDate As %Library.String [ SqlColumnNumber = 5 ];

/// 备注
Property VMDremarks As %Library.String(MAXLEN = 1000) [ SqlColumnNumber = 6 ];

/// 安装日期
Property VMDInstallDate As %Library.String [ SqlColumnNumber = 7 ];

/// 安装时间
Property VMDInstallTime As %Library.String [ SqlColumnNumber = 8 ];

Index Code On (VMDCode, VMDName);

Index Name On VMDName;

//s ds=##class(DHCWL.VerManagement.VerData).%OpenId(21)

//d ds.GetVersion()

Method GetVersion()
{
	s vmdName=..VMDName
	s vmdCode=..VMDCode
	s vmdTSName=..VMDTSName	
	s vmdUpDate=..VMDUpDate	
	s vmdremarks=..VMDremarks
	s vmdInstallDate=..VMDInstallDate
	s vmdInstallTime=..VMDInstallTime
	s ret=$G(vmdName)_"^"_$G(vmdCode)_"^"_$G(vmdTSName)_"^"_$G(vmdUpDate)_"^"_$G(vmdremarks)_"^"_$G(vmdInstallDate)_"^"_$G(vmdInstallTime)
	q $G(ret)
}

Method Insert() As %Status
{
	s ret=..GetVersion()
    s ..VMDName=$p($G(ret),"^",1)
	s ..VMDCode=$p($G(ret),"^",2)
	s ..VMDTSName=$p($G(ret),"^",3)	
	s ..VMDUpDate=$p($G(ret),"^",4)	
    s ..VMDremarks=$p($G(ret),"^",5)
	s ..VMDInstallDate=$zd($p($h,",",1),3)
	s ..VMDInstallTime=$zt($p($h,",",2),1)
	d ..%Save()
	q 1
}

Method %OnNew() As %Status
{
	s ..VMDName=..#VMDName
	s ..VMDCode=..#VMDCode
	s ..VMDTSName=..#VMDTSName	
	s ..VMDUpDate=..#VMDUpDate	
	s ..VMDremarks=..#VMDremarks
	s ..VMDInstallDate=..#VMDInstallDate
	s ..VMDInstallTime=..#VMDInstallTime
	q 1
}

Storage Default
{
<Data name="VerDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VMDName</Value>
</Value>
<Value name="3">
<Value>VMDCode</Value>
</Value>
<Value name="4">
<Value>VMDTSName</Value>
</Value>
<Value name="5">
<Value>VMDUpDate</Value>
</Value>
<Value name="6">
<Value>VMDremarks</Value>
</Value>
<Value name="7">
<Value>VMDInstallDate</Value>
</Value>
<Value name="8">
<Value>VMDInstallTime</Value>
</Value>
</Data>
<DataLocation>^DHCWL.VerManagement.VerDataD</DataLocation>
<DefaultData>VerDataDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.VerManagement.VerDataD</IdLocation>
<IndexLocation>^DHCWL.VerManagement.VerDataI</IndexLocation>
<StreamLocation>^DHCWL.VerManagement.VerDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
