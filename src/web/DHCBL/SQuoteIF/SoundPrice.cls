Class web.DHCBL.SQuoteIF.SoundPrice Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

ClassMethod SoundService(JSFunName As %String, SoundService As %String, ValAry As %String, SessionStr As %String, ExpStr As %String) As %String
{
	///w ##class(web.DHCBL.SQuoteIF.SoundPrice).SoundService("","TotalFee",myValAry,mySessionStr,"")
	///w ##class(web.DHCBL.SQuoteIF.SoundPrice).SoundService("","RtnOdd",myValAry,mySessionStr,"")
	;w ##class(web.DHCBL.SQuote.SoundPrice7).SoundService("","TotalFee","myValAry","mySessionStr","")
	;SoundService 服务名称 
	;费用总额提示   TotalFee   ValAry  = 费用金额^
	;找零提示       RtnOdd		ValAry= 应收总额^收取金额^找零
	;
	s myVer=##class(web.DHCOPConfig).GetVersion()
	i JSFunName=""{
		s JSFunName="DHCWCOM_SoundPriceService"
	}
	s myrtn=0
	if (+myVer=7){
		
		s myrtn=##class(web.DHCBL.SQuote.SoundPrice7).SoundService(JSFunName, SoundService, ValAry, SessionStr, ExpStr)
	}
	q myrtn
}

}
