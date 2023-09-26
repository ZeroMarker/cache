Import SQLUser

Class web.UDHCAccRegCardIF Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 59;

ClassMethod getpatbyCardNo(cardno As %Library.String = "", cardverify As %Library.String = "")
{
	;w ##class(web.UDHCAccRegCardIF).getpatbyCardNo("006281","")
	n (cardno, cardverify)
	
	s myrtn=0
	
	s myVer=##class(web.DHCOPConfig).GetVersion()
	
	if (+myVer=0){
		;北京积水潭医院
		;需要新写入DHC_CardRef
		s myrtn=##class(web.UDHCAccRegCard0).getpatbyCardNo(cardno, cardverify)
	}elseif (+myVer=1){
		;合肥省力医院
		s myrtn=##class(web.UDHCAccRegCard).getpatbyCardNo(cardno, cardverify)
	}elseif (+myVer=2){
		
	}elseif (+myVer=3){
		//大同
		s myrtn=##class(web.UDHCAccRegCard0).getpatbyCardNo(cardno, cardverify)
	}elseif (+myVer=4){
		
	}else{
		s myrtn=##class(web.UDHCAccRegCard).getpatbyCardNo(cardno, cardverify)
	}
	
	q myrtn
}

ClassMethod NewCardAcc(PAPatInfo As %String, CardInfo As %String, AccInfo As %String, DepositInfo As %String, ExpStr As %String) As %String
{
	n (PAPatInfo,CardInfo,AccInfo, DepositInfo, ExpStr)
	
	s $ZT="ERROR^DHCSSERR"
	s myrtn=0
	s ^TMPHHHHH(1)=PAPatInfo
	s ^TMPHHHHH(2)=CardInfo
	s ^TMPHHHHH(3)=AccInfo
	s ^TMPHHHHH(4)=DepositInfo
	;w ##class(web.UDHCAccRegCardIF).NewCardAcc("303^GYP^2^1976-01-01^ ^0755091^ ^2^^^KX^Bj","00000300^303^^006280^000006026046553199^^^1^USER-9^000003006046556435","^303^00000300^006280^1^58B2C53441A9DB19E159BEC686D685D8^0^P^1^^","^200^1^^^58B2C53441A9DB19E159BEC686D685D8^1^^^^^^^^P")
	;str1=PAPatInfo
	;str2=CardInfo
	;str3=AccInfo
	;str4=DepositInfo
	
	s myVer=##class(web.DHCOPConfig).GetVersion()
	
	if (+myVer=0){
		;北京积水潭医院
		;需要新写入DHC_CardRef
		;PAPatInfo=
		;CardInfo=PAPMINo^PAPMIDR^IDCardNo^CardNo^SecrityNo^DateFrom^DateTo^UserDR^ComputerName^SecrityNo
		;AccInfo=
		;DepositInfo=
		s myrtn=##class(web.UDHCAccRegCard0).NewCardAcc(PAPatInfo,CardInfo,AccInfo, DepositInfo)
	}elseif (+myVer=1){
		;合肥省力医院
		;需要更新DHC_CardRef
		s myrtn=##class(web.UDHCAccRegCard).NewCardAcc(PAPatInfo,CardInfo,AccInfo, DepositInfo)
	}elseif (+myVer=2){
		
	}elseif (+myVer=3){
		///大同
		s myrtn=##class(web.UDHCAccRegCard0).NewCardAcc(PAPatInfo,CardInfo,AccInfo, DepositInfo)
	}elseif (+myVer=4){
		
	}else{
		s myrtn=##class(web.UDHCAccRegCard).NewCardAcc(PAPatInfo,CardInfo,AccInfo, DepositInfo)
	}
	
	q myrtn
}

}
