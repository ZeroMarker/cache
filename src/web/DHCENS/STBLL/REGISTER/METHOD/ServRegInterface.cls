Class web.DHCENS.STBLL.REGISTER.METHOD.ServRegInterface Extends (%RegisteredObject, %XML.Adaptor)
{

/// w ##class(web.DHCENS.STBLL.REGISTER.METHOD.ServRegInterface).test001OnReg0001(inputcontent)
ClassMethod test001OnReg0001(inputcontent As %GlobalCharacterStream) As %GlobalCharacterStream
{
	s $ZTrap = "SendMessageET"
	s currentmethod=##safeexpression(""""_$get(%methodname)_"""")
	s messagecode=$p(currentmethod,"On",1)
	s servicecode=$p(currentmethod,"On",2)
	s methodcode="",ip="",port="",buscode=""
	&sql(SELECT MethodCode,ServiceHost,ServicePort,BusCode into :methodcode,:ip,:port,:buscode FROM SQLUser.Ens_RegisteredServiceSOAPMethod where ServiceCode=:servicecode)
	s returnstring=##class(web.DHCENS.STBLL.REGISTER.UTIL.Common).InvokeSOAPViaHTTP(ip, port , buscode, methodcode, messagecode,inputcontent)
	s retstream=##class(%GlobalCharacterStream).%New()
	d retstream.Write(returnstring)
	q retstream
SendMessageET
	s retstream=##class(%GlobalCharacterStream).%New()
	d retstream.Write("-1^"_$ze)
	q retstream
}

/// w ##class(web.DHCENS.STBLL.REGISTER.METHOD.ServRegInterface).test001OnReg0002(inputcontent)
ClassMethod test001OnReg0002(inputcontent As %GlobalCharacterStream) As %GlobalCharacterStream
{
	s $ZTrap = "SendMessageET"
	s currentmethod=##safeexpression(""""_$get(%methodname)_"""")
	s messagecode=$p(currentmethod,"On",1)
	s servicecode=$p(currentmethod,"On",2)
	s methodcode="",ip="",port="",buscode=""
	&sql(SELECT MethodCode,ServiceHost,ServicePort,BusCode into :methodcode,:ip,:port,:buscode FROM SQLUser.Ens_RegisteredServiceSOAPMethod where ServiceCode=:servicecode)
	s returnstring=##class(web.DHCENS.STBLL.REGISTER.UTIL.Common).InvokeSOAPViaHTTP(ip, port , buscode, methodcode, messagecode,inputcontent)
	s retstream=##class(%GlobalCharacterStream).%New()
	d retstream.Write(returnstring)
	q retstream
SendMessageET
	s retstream=##class(%GlobalCharacterStream).%New()
	d retstream.Write("-1^"_$ze)
	q retstream
}

/// w ##class(web.DHCENS.STBLL.REGISTER.METHOD.ServRegInterface).MES0001OnREG0001(inputcontent)
ClassMethod MES0001OnREG0001(inputcontent As %GlobalCharacterStream) As %GlobalCharacterStream
{
	s $ZTrap = "SendMessageET"
	s currentmethod=##safeexpression(""""_$get(%methodname)_"""")
	s messagecode=$p(currentmethod,"On",1)
	s servicecode=$p(currentmethod,"On",2)
	s methodcode="",ip="",port="",buscode=""
	&sql(SELECT MethodCode,ServiceHost,ServicePort,BusCode into :methodcode,:ip,:port,:buscode FROM SQLUser.Ens_RegisteredServiceSOAPMethod where ServiceCode=:servicecode)
	s returnstring=##class(web.DHCENS.STBLL.REGISTER.UTIL.Common).InvokeSOAPViaHTTP(ip, port , buscode, methodcode, messagecode,inputcontent)
	s retstream=##class(%GlobalCharacterStream).%New()
	d retstream.Write(returnstring)
	q retstream
SendMessageET
	s retstream=##class(%GlobalCharacterStream).%New()
	d retstream.Write("-1^"_$ze)
	q retstream
}

/// w ##class(web.DHCENS.STBLL.REGISTER.METHOD.ServRegInterface).MES0002OnREG0002(inputcontent)
ClassMethod MES0002OnREG0002(inputcontent As %GlobalCharacterStream) As %GlobalCharacterStream
{
	s $ZTrap = "SendMessageET"
	s currentmethod=##safeexpression(""""_$get(%methodname)_"""")
	s messagecode=$p(currentmethod,"On",1)
	s servicecode=$p(currentmethod,"On",2)
	s methodcode="",ip="",port="",buscode=""
	&sql(SELECT MethodCode,ServiceHost,ServicePort,BusCode into :methodcode,:ip,:port,:buscode FROM SQLUser.Ens_RegisteredServiceSOAPMethod where ServiceCode=:servicecode)
	s returnstring=##class(web.DHCENS.STBLL.REGISTER.UTIL.Common).InvokeSOAPViaHTTP(ip, port , buscode, methodcode, messagecode,inputcontent)
	s retstream=##class(%GlobalCharacterStream).%New()
	d retstream.Write(returnstring)
	q retstream
SendMessageET
	s retstream=##class(%GlobalCharacterStream).%New()
	d retstream.Write("-1^"_$ze)
	q retstream
}

/// w ##class(web.DHCENS.STBLL.REGISTER.METHOD.ServRegInterface).MES0003OnREG0003(inputcontent)
ClassMethod MES0003OnREG0003(inputcontent As %GlobalCharacterStream) As %GlobalCharacterStream
{
	s $ZTrap = "SendMessageET"
	s currentmethod=##safeexpression(""""_$get(%methodname)_"""")
	s messagecode=$p(currentmethod,"On",1)
	s servicecode=$p(currentmethod,"On",2)
	s methodcode="",ip="",port="",buscode=""
	&sql(SELECT MethodCode,ServiceHost,ServicePort,BusCode into :methodcode,:ip,:port,:buscode FROM SQLUser.Ens_RegisteredServiceSOAPMethod where ServiceCode=:servicecode)
	s returnstring=##class(web.DHCENS.STBLL.REGISTER.UTIL.Common).InvokeSOAPViaHTTP(ip, port , buscode, methodcode, messagecode,inputcontent)
	s retstream=##class(%GlobalCharacterStream).%New()
	d retstream.Write(returnstring)
	q retstream
SendMessageET
	s retstream=##class(%GlobalCharacterStream).%New()
	d retstream.Write("-1^"_$ze)
	q retstream
}

/// w ##class(web.DHCENS.STBLL.REGISTER.METHOD.ServRegInterface).MES0004OnREG0003(inputcontent)
ClassMethod MES0004OnREG0003(inputcontent As %GlobalCharacterStream) As %GlobalCharacterStream
{
	s $ZTrap = "SendMessageET"
	s currentmethod=##safeexpression(""""_$get(%methodname)_"""")
	s messagecode=$p(currentmethod,"On",1)
	s servicecode=$p(currentmethod,"On",2)
	s methodcode="",ip="",port="",buscode=""
	&sql(SELECT MethodCode,ServiceHost,ServicePort,BusCode into :methodcode,:ip,:port,:buscode FROM SQLUser.Ens_RegisteredServiceSOAPMethod where ServiceCode=:servicecode)
	s returnstring=##class(web.DHCENS.STBLL.REGISTER.UTIL.Common).InvokeSOAPViaHTTP(ip, port , buscode, methodcode, messagecode,inputcontent)
	s retstream=##class(%GlobalCharacterStream).%New()
	d retstream.Write(returnstring)
	q retstream
SendMessageET
	s retstream=##class(%GlobalCharacterStream).%New()
	d retstream.Write("-1^"_$ze)
	q retstream
}

/// w ##class(web.DHCENS.STBLL.REGISTER.METHOD.ServRegInterface).test002OnReg0001(inputcontent)
ClassMethod test002OnReg0001(inputcontent As %GlobalCharacterStream) As %GlobalCharacterStream
{
	s $ZTrap = "SendMessageET"
	s currentmethod=##safeexpression(""""_$get(%methodname)_"""")
	s messagecode=$p(currentmethod,"On",1)
	s servicecode=$p(currentmethod,"On",2)
	s methodcode="",ip="",port="",buscode=""
	&sql(SELECT MethodCode,ServiceHost,ServicePort,BusCode into :methodcode,:ip,:port,:buscode FROM SQLUser.Ens_RegisteredServiceSOAPMethod where ServiceCode=:servicecode)
	s returnstring=##class(web.DHCENS.STBLL.REGISTER.UTIL.Common).InvokeSOAPViaHTTP(ip, port , buscode, methodcode, messagecode,inputcontent)
	s retstream=##class(%GlobalCharacterStream).%New()
	d retstream.Write(returnstring)
	q retstream
SendMessageET
	s retstream=##class(%GlobalCharacterStream).%New()
	d retstream.Write("-1^"_$ze)
	q retstream
}

/// w ##class(web.DHCENS.STBLL.REGISTER.METHOD.ServRegInterface).test003OnReg0001(inputcontent)
ClassMethod test003OnReg0001(inputcontent As %GlobalCharacterStream) As %GlobalCharacterStream
{
	s $ZTrap = "SendMessageET"
	s currentmethod=##safeexpression(""""_$get(%methodname)_"""")
	s messagecode=$p(currentmethod,"On",1)
	s servicecode=$p(currentmethod,"On",2)
	s methodcode="",ip="",port="",buscode=""
	&sql(SELECT MethodCode,ServiceHost,ServicePort,BusCode into :methodcode,:ip,:port,:buscode FROM SQLUser.Ens_RegisteredServiceSOAPMethod where ServiceCode=:servicecode)
	s returnstring=##class(web.DHCENS.STBLL.REGISTER.UTIL.Common).InvokeSOAPViaHTTP(ip, port , buscode, methodcode, messagecode,inputcontent)
	s retstream=##class(%GlobalCharacterStream).%New()
	d retstream.Write(returnstring)
	q retstream
SendMessageET
	s retstream=##class(%GlobalCharacterStream).%New()
	d retstream.Write("-1^"_$ze)
	q retstream
}

/// w ##class(web.DHCENS.STBLL.REGISTER.METHOD.ServRegInterface).test1OnREG0007(inputcontent)
ClassMethod test1OnREG0007(inputcontent As %GlobalCharacterStream) As %GlobalCharacterStream
{
	s $ZTrap = "SendMessageET"
	s currentmethod=##safeexpression(""""_$get(%methodname)_"""")
	s messagecode=$p(currentmethod,"On",1)
	s servicecode=$p(currentmethod,"On",2)
	s methodcode="",ip="",port="",buscode=""
	&sql(SELECT MethodCode,ServiceHost,ServicePort,BusCode into :methodcode,:ip,:port,:buscode FROM SQLUser.Ens_RegisteredServiceSOAPMethod where ServiceCode=:servicecode)
	s returnstring=##class(web.DHCENS.STBLL.REGISTER.UTIL.Common).InvokeSOAPViaHTTP(ip, port , buscode, methodcode, messagecode,inputcontent)
	s retstream=##class(%GlobalCharacterStream).%New()
	d retstream.Write(returnstring)
	q retstream
SendMessageET
	s retstream=##class(%GlobalCharacterStream).%New()
	d retstream.Write("-1^"_$ze)
	q retstream
}

/// w ##class(web.DHCENS.STBLL.REGISTER.METHOD.ServRegInterface).test2OnREG0007(inputcontent)
ClassMethod test2OnREG0007(inputcontent As %GlobalCharacterStream) As %GlobalCharacterStream
{
	s $ZTrap = "SendMessageET"
	s currentmethod=##safeexpression(""""_$get(%methodname)_"""")
	s messagecode=$p(currentmethod,"On",1)
	s servicecode=$p(currentmethod,"On",2)
	s methodcode="",ip="",port="",buscode=""
	&sql(SELECT MethodCode,ServiceHost,ServicePort,BusCode into :methodcode,:ip,:port,:buscode FROM SQLUser.Ens_RegisteredServiceSOAPMethod where ServiceCode=:servicecode)
	s returnstring=##class(web.DHCENS.STBLL.REGISTER.UTIL.Common).InvokeSOAPViaHTTP(ip, port , buscode, methodcode, messagecode,inputcontent)
	s retstream=##class(%GlobalCharacterStream).%New()
	d retstream.Write(returnstring)
	q retstream
SendMessageET
	s retstream=##class(%GlobalCharacterStream).%New()
	d retstream.Write("-1^"_$ze)
	q retstream
}

}
