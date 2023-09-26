Class DHCWL.DM.T.DataLog Extends %Persistent
{

//using class name to index data log master

Property Master As %String [ Required ];

Property Submaster As %String [ Required ];

Property LogStartDate As %Integer [ Required ];

Property LogStartTime As %Double;

Property LogEndDate As %Integer [ Required ];

Property LogEndTime As %Double;

Property UsingTime As %Double;

Property Status As %String;

Property Params As %String(MAXLEN = 512, TRUNCATE = 1);

Property LogDetail As %String(MAXLEN = 512, TRUNCATE = 1);

Index MainI On (Master, Submaster, LogStartDate);

ClassMethod StartLog(master As %String, subMaster As %String) As DataLog
{
  s log=##class(DataLog).%New()	
  s log.Master=master
  s log.Submaster=subMaster
  s log.LogStartDate=+$h
  s log.LogStartTime=$p($zts,",",2)
  s log.LogEndTime=$p($zts,",",2)
  q log
}

Method CommitLog(status As %String = "", params As %String = "", logDetail As %String = "") As %Status
{
	s ..LogEndDate=+$h
	s ..LogEndTime=$p($zts,",",2)
    if ..LogEndDate=..LogStartDate {
	  s ..UsingTime=..LogEndTime-..LogStartTime   
    }else{
	  s ..UsingTime=(..LogEndDate-..LogStartDate-1)*(24*60*60)+..LogEndTime-..LogStartTime
    }
    s:status'="" ..Status=status
    s:params'="" ..Params=params
    if logDetail'=""{
	    if ..LogDetail'=""{
		    s ..LogDetail=..LogDetail_"^" _logDetail
	    }else{
		    s ..LogDetail=logDetail
	    }
    }
    q ..%Save()
}

Method Touch(flag, timeTouchFlag As %Boolean = 1, computedFlag As %Boolean = 1) As %Status
{
	s:..LogDetail'="" ..LogDetail=..LogDetail_"^"
	if (timeTouchFlag){
		if (computedFlag){
			s ..LogDetail=..LogDetail_flag_":"_($p($zts,",",2)-..LogEndTime)
		}else{
			s ..LogDetail=..LogDetail_flag_":"_$p($zts,",",2)
		}
		s ..LogEndTime=$p($zts,",",2)
	}else{
		s ..LogDetail=..LogDetail_flag
	}
	q $$$OK
}

Storage Default
{
<Data name="DataLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Master</Value>
</Value>
<Value name="3">
<Value>Submaster</Value>
</Value>
<Value name="4">
<Value>LogDate</Value>
</Value>
<Value name="5">
<Value>LogTime</Value>
</Value>
<Value name="6">
<Value>Status</Value>
</Value>
<Value name="7">
<Value>LogEndDate</Value>
</Value>
<Value name="8">
<Value>LogEndTime</Value>
</Value>
<Value name="9">
<Value>UsingTime</Value>
</Value>
<Value name="10">
<Value>LogStartDate</Value>
</Value>
<Value name="11">
<Value>LogStartTime</Value>
</Value>
<Value name="12">
<Value>Params</Value>
</Value>
<Value name="13">
<Value>LogDetail</Value>
</Value>
</Data>
<DataLocation>^DHCWL.DM.T.DataLogD</DataLocation>
<DefaultData>DataLogDefaultData</DefaultData>
<IdLocation>^DHCWL.DM.T.DataLogD</IdLocation>
<IndexLocation>^DHCWL.DM.T.DataLogI</IndexLocation>
<StreamLocation>^DHCWL.DM.T.DataLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
