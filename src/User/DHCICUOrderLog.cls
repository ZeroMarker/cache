Class User.DHCICUOrderLog Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = DHC_ICU_OrderLog ]
{

Property ArrangeId As User.DHCICUArrange [ SqlColumnNumber = 2 ];

Property OrderId As %String [ SqlColumnNumber = 3 ];

Property DataDate As %Date [ SqlColumnNumber = 4 ];

Property DataTime As %Time [ SqlColumnNumber = 5 ];

Property UpdateUser As %String [ SqlColumnNumber = 6 ];

Property ClientIP As %String [ SqlColumnNumber = 7 ];

Property AppName As %String [ SqlColumnNumber = 8 ];

Property EditFlag As %String [ SqlColumnNumber = 9 ];

Property Note As %String(MAXLEN = 1000000) [ SqlColumnNumber = 10 ];

Property Type As %String [ SqlColumnNumber = 11 ];

Property ServerIp As %String(MAXLEN = 500) [ SqlColumnNumber = 12 ];

Index ArrangeIndex On ArrangeId As Plus;

// w ##class(User.DHCICUOrderLog).Log(1234)

ClassMethod Log(id)
{
	q ""
	set maxCount=9000*10000 ; 九千万
	set curDataCount=$g(^DHCANICUDebug("ICUOrderLogCount"))
	if (curDataCount>=maxCount)
	{
		// 总日志超过九千万，认为日志异常
		quit "总日志超过九千万，日志异常"
	}
	set orderObj=##class(User.DHCICUOrder).%OpenId(id)
	quit:orderObj.ICUOEditFlag'="C" 1
	set log=##class(User.DHCICUOrderLog).%New()
	set log.OrderId=id
	
	set log.ArrangeId=orderObj.ICUOICUADr
	set log.ClientIP=$System.Process.ClientIPAddress()
	set log.AppName=$System.Process.ClientExecutableName()
	set log.EditFlag=orderObj.ICUOEditFlag
	set log.DataDate=+$h
	set log.DataTime=$p($h,",",2)
	set retStr=""
	set time=$p($h,",",2)
	set count=+$g(^||A(log.ArrangeId.%Id(),time))
	set count=count+1
	set ^||A(log.ArrangeId.%Id(),time)=count+1
	set log.ServerIp=$p(##class(%SYSTEM.INetInfo).GetInterfacesInfo(),$c(1),3)
	if (count>10)
	{
		set log.Note="count>10"_$System.Process.CallingRoutine()_"  "_" "_$JOB
	    do log.%Save()
		//SET mygenex = ##class(%Exception.General).%New("请拍照联系信息科","999",,"请拍照联系信息科")
        //THROW mygenex
	}
	else
	{
		set log.Note=$System.Process.CallingRoutine()_"  "_" "_$JOB
		do log.%Save()
	}
	quit 0
}

ClassMethod LogSaveIcuOrder(icuaId, paraStr)
{
	q ""
	set log=##class(User.DHCICUOrderLog).%New()
	if (##class(User.DHCICUArrange).%ExistsId(icuaId))
	{
		set log.ArrangeId=##class(User.DHCICUArrange).%OpenId(icuaId)
		set log.ClientIP=$System.Process.ClientIPAddress()
		set log.AppName=$System.Process.ClientExecutableName()
		set log.EditFlag=""
		set log.DataDate=+$h
		set log.DataTime=$p($h,",",2)
		set log.Type="SaveICUOrderMethod"
		if ($d(%session))
		{
			set log.UpdateUser=%session.Get("LOGON.USERID")	
		}
		set log.Note=paraStr
		do log.%Save()
	}
	quit 0
}

Storage Default
{
<Data name="DHCICUOrderLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ArrangeId</Value>
</Value>
<Value name="3">
<Value>OrderId</Value>
</Value>
<Value name="4">
<Value>DataDate</Value>
</Value>
<Value name="5">
<Value>DataTime</Value>
</Value>
<Value name="6">
<Value>UpdateUser</Value>
</Value>
<Value name="7">
<Value>ClientIP</Value>
</Value>
<Value name="8">
<Value>AppName</Value>
</Value>
<Value name="9">
<Value>EditFlag</Value>
</Value>
<Value name="10">
<Value>Note</Value>
</Value>
<Value name="11">
<Value>Type</Value>
</Value>
<Value name="12">
<Value>ServerIp</Value>
</Value>
</Data>
<DataLocation>^User.DHCICUOrderLogD</DataLocation>
<DefaultData>DHCICUOrderLogDefaultData</DefaultData>
<IdLocation>^User.DHCICUOrderLogD</IdLocation>
<IndexLocation>^User.DHCICUOrderLogI</IndexLocation>
<StreamLocation>^User.DHCICUOrderLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
