Class dhcinterface.ATFYPXX Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

Property INPATIENTNO As %String(TRUNCATE = 1) [ Required ];

Property PID As %String(TRUNCATE = 1) [ Required ];

Property NAME As %String(TRUNCATE = 1);

Property DEPTSN As %String(TRUNCATE = 1);

Property DEPTNAME As %String(TRUNCATE = 1);

Property WARDSN As %String(TRUNCATE = 1);

Property WARDNAME As %String(TRUNCATE = 1);

Property DOCTOR As %String(TRUNCATE = 1);

Property BEDNO As %String(TRUNCATE = 1);

Property COMMENT As %String(TRUNCATE = 1);

Property COMM2 As %String(TRUNCATE = 1);

Property DRUGCODE As %String(TRUNCATE = 1) [ Required ];

Property DRUGNAME As %String(TRUNCATE = 1);

Property SPECIFICATION As %String(TRUNCATE = 1);

Property DOSAGE As %Numeric;

Property DOSUNIT As %String(TRUNCATE = 1);

Property AMOUNT As %Numeric;

Property OCCTIME As %String(TRUNCATE = 1) [ Required ];

Property FLAG As %String(TRUNCATE = 1);

Property ATFNO As %Numeric;

Property PRIFLAG As %String(TRUNCATE = 1);

Property PAGENO As %String(TRUNCATE = 1);

Property DETAILSN As %String(TRUNCATE = 1) [ Required ];

Property GENTIME As %String(TRUNCATE = 1);

Property MZFLAG As %String(TRUNCATE = 1);

Storage Default
{
<Data name="ATFYPXXDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>INPATIENTNO</Value>
</Value>
<Value name="3">
<Value>DEPTNAME</Value>
</Value>
<Value name="4">
<Value>NAME</Value>
</Value>
<Value name="5">
<Value>PID</Value>
</Value>
<Value name="6">
<Value>AMOUNT</Value>
</Value>
<Value name="7">
<Value>BEDNO</Value>
</Value>
<Value name="8">
<Value>COMM2</Value>
</Value>
<Value name="9">
<Value>COMMENT</Value>
</Value>
<Value name="10">
<Value>DOCTOR</Value>
</Value>
<Value name="11">
<Value>DOSAGE</Value>
</Value>
<Value name="12">
<Value>DOSUNIT</Value>
</Value>
<Value name="13">
<Value>DRUGCODE</Value>
</Value>
<Value name="14">
<Value>FLAG</Value>
</Value>
<Value name="15">
<Value>OCCTIME</Value>
</Value>
<Value name="16">
<Value>SPECIFICATION</Value>
</Value>
<Value name="17">
<Value>WARDNAME</Value>
</Value>
<Value name="18">
<Value>WARDSN</Value>
</Value>
<Value name="19">
<Value>ATFNO</Value>
</Value>
<Value name="20">
<Value>PRIFLAG</Value>
</Value>
<Value name="21">
<Value>PAGENO</Value>
</Value>
<Value name="22">
<Value>DETAILSN</Value>
</Value>
<Value name="23">
<Value>DRUGNAME</Value>
</Value>
<Value name="24">
<Value>GENTIME</Value>
</Value>
<Value name="25">
<Value>MZFLAG</Value>
</Value>
<Value name="26">
<Value>DEPTSN</Value>
</Value>
</Data>
<DataLocation>^dhcinterface.ATFYPXXD</DataLocation>
<DefaultData>ATFYPXXDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcinterface.ATFYPXXD</IdLocation>
<IndexLocation>^dhcinterface.ATFYPXXI</IndexLocation>
<StreamLocation>^dhcinterface.ATFYPXXS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
