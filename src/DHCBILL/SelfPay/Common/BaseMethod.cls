Class DHCBILL.SelfPay.Common.BaseMethod Extends %RegisteredObject
{

/// w ##class(DHCBILL.SelfPay.Common.BaseMethod).getTradeCode("<Request><TradeCode>3987</TradeCode><His></His></Request>")
ClassMethod getTradeCode(InputString As %String) As %String
{
	set InputObj=##class(DHCBILL.SelfPay.Entity.TradeCodeInput).%New()
	do InputObj.XMLNodeDeserialize(.InputObj, "Request", InputString)
	set string=InputObj.TradeCode
	quit string
}

}
