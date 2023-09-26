Class User.DHCIFCallSeat Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// CallSeat_No
Property CallSeatNo As %String(TRUNCATE = 1);

/// CallSeat_Date
Property CallSeatDate As %Library.Date(FORMAT = 1);

/// SeatCall_Time
Property CallSeatTime As %Library.Time;

/// SeatCall_State
Property CallSeatState As %String(TRUNCATE = 1);

ClassMethod Save(Parr As %String) As %String
{
	s id=$P(Parr,"^",1)
	s SeatNo=$P(Parr,"^",2)
	s CallDate=$P($h,",",1)
	s CallTime=$P($h,",",2)
	s CallState=$P(Parr,"^",5)
	d ##class(web.DHCIFCallSeat).DelSeatNo(SeatNo)
	i id="" s a=##class(User.DHCIFCallSeat).%New()
	e  s a=##class(User.DHCIFCallSeat).%OpenId(id)
	s a.CallSeatNo=SeatNo
	s a.CallSeatDate=CallDate
	s a.CallSeatTime=CallTime
	s a.CallSeatState=CallState
	d a.%Save()
	q 0
}

Storage Default
{
<Data name="DHCIFCallSeatDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CallSeatDate</Value>
</Value>
<Value name="3">
<Value>CallSeatNo</Value>
</Value>
<Value name="4">
<Value>CallSeatState</Value>
</Value>
<Value name="5">
<Value>CallSeatTime</Value>
</Value>
</Data>
<DataLocation>^User.DHCIFCallSeatD</DataLocation>
<DefaultData>DHCIFCallSeatDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCIFCallSeatD</IdLocation>
<IndexLocation>^User.DHCIFCallSeatI</IndexLocation>
<StreamLocation>^User.DHCIFCallSeatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
