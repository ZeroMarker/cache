Class CHSSWeb.Reg.CARD.UCardRefInfo Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// 建卡时需要的验证关系
ClassMethod CreateCardCheckData(IDNo As %String = "", CredTypeDR As %String, CredNo As %String = "", CardTypeDR As %String = "", ExpStr As %String) As %String
{
	;w ##class(web.DHCBL.CARD.UCardRefInfo).CreateCardCheckData()
	;如果这个证件号码已经办过此类卡， 决不让办理下一个  返回 -365
	;对于集团办就诊卡，  需要补充 把患者归到集团中
	;如果这个证件号码办过同是 IDU 的卡 一定要办理绑定
	;绑定时,  返回此卡对照的基本信息
	;同时要求 此类卡的基本信息是否能够 覆盖当前的基本信息
	;如果不能覆盖， 返回
	;IDNo   身份证号码
	;CredTypeDR  证件类型
	;CredNo    证件号码   
	;CardTypeDR   卡类型
	n (IDNo, CredTypeDR, CardTypeDR, CredNo, ExpStr)
	s ^TMPCardCHEKCDTATA=(IDNo_","_CredTypeDR_","_CardTypeDR_","_CredNo_","_ExpStr)
	
	s myrtn=0
	
	i (CardTypeDR=""){
		s myrtn=-366
	}else{
		;此时要求证件号码<>""
		s mySameFind=0
		s myIDUFind=0			;唯一标示发现
		
		s myPAPMIDR=0
		s myRtnPAPMIRowID=""
		s myCardTypeValidateFlag=$p($g(^DHCCARDTYPEDef(CardTypeDR)),"^", 30)		;CTD_ValidateMode
		///身份证类型验证  ID Unqiue
		///证件类型唯一性验证
		if (myCardTypeValidateFlag="IDU"){
			i (IDNo="")&(CredNo="") d
			.s myrtn=-367
			
			q:(myrtn) myrtn
			
			s myPAID=$ZConvert(IDNo,"U")
			i $l(myPAID)=15{
				s myPAID15=$ZConvert(myPAID_"Z", "U")
				s myPAID18=$e(myPAID,1,6)_"19"_$e(myPAID,7,15)_" "
				s myPAID18=$ZConvert(myPAID18_"Z","U")
				
			}elseif($l(myPAID)=18){
				s myPAID18=$ZConvert(myPAID_"Z", "U")
				s myPAID15=$e(myPAID,1,6)_$e(myPAID,9,17)
				s myPAID15=$ZConvert(myPAID15_"Z","U")
			}else
			{
				s myPAID18="ZX"
				s myPAID15="ZX"
			}
			
			;^DHCCARDi("CF",0,"PAPMICTDR",{CF_PAPMI_DR},{CF_CardType_DR},      x
			;分成  15 位和 18位区别
			f  s myPAPMIDR=$o(^PAPERi("PAPMI_ICPPBC",myPAID18,myPAPMIDR))  q:((myPAPMIDR="")!(+mySameFind))  d
			.s myCardTypeDR=0
			.f  s myCardTypeDR=$o(^DHCCARDi("CF",0,"PAPMICTDR",myPAPMIDR ,myCardTypeDR)) q:(myCardTypeDR="")!(+mySameFind)  d
			..s myIDUniqueFlag=$p($g(^DHCCARDTYPEDef(myCardTypeDR)),"^",30)		;CTD_ValidateMode
			..i (myIDUniqueFlag="IDU")&(CardTypeDR'=myCardTypeDR) d
			...s myIDUFind=1
			...s myRtnPAPMIRowID=myPAPMIDR
			..i CardTypeDR=myCardTypeDR d
			...s mySameFind=1
			
			b	;18
			s myPAPMIDR=0
			f  s myPAPMIDR=$o(^PAPERi("PAPMI_ICPPBC",myPAID15,myPAPMIDR))  q:((myPAPMIDR="")!(+mySameFind))  d
			.s myCardTypeDR=0
			.f  s myCardTypeDR=$o(^DHCCARDi("CF",0,"PAPMICTDR",myPAPMIDR ,myCardTypeDR)) q:(myCardTypeDR="")!(+mySameFind)  d
			..s myIDUniqueFlag=$p($g(^DHCCARDTYPEDef(myCardTypeDR)),"^",30)		;CTD_ValidateMode
			..i (myIDUniqueFlag="IDU")&(CardTypeDR'=myCardTypeDR) d
			...s myIDUFind=1
			...s myRtnPAPMIRowID=myPAPMIDR
			..i CardTypeDR=myCardTypeDR d
			...s mySameFind=1
			..
			b	;15
			i +mySameFind d
			.s myrtn=-365
			
			;唯一表示被发现，建立卡时需要绑定
			i +myIDUFind d
			.s myrtn=-368
			
			s myPAID=$ZConvert(CredNo, "U")
			;验证证件类型和证件号码
			;没有发现身份证号重复
			i (+mySameFind=0)&(+myIDUFind=0) d
			.;^PAPERi("DVA",$$ALPHAUP({PAPMI_DVAnumber}),{PAPMI_RowId})
			.s myPAPMIDR=0
			.f  s myPAPMIDR=$o(^PAPERi("DVA",myPAID,myPAPMIDR))  q:(myPAPMIDR="")  d
			..;同一证件类型才成
			..s myCredTypeDR=$p(^PAPER(myPAPMIDR,"PAT",3),"^",7)	;CardType_DR
			..b	;
			..i CredTypeDR=myCredTypeDR d
			...s myCardTypeDR=0
			...f  s myCardTypeDR=$o(^DHCCARDi("CF",0,"PAPMICTDR",myPAPMIDR ,myCardTypeDR)) q:(myCardTypeDR="")!(+mySameFind)  d
			....s myIDUniqueFlag=$p($g(^DHCCARDTYPEDef(myCardTypeDR)),"^",30)		;CTD_ValidateMode
			....i (myIDUniqueFlag="IDU")&(CardTypeDR'=myCardTypeDR) d
			.....s myIDUFind=1
			.....s myRtnPAPMIRowID=myPAPMIDR
			....i CardTypeDR=myCardTypeDR d
			.....s mySameFind=1
			
			i +mySameFind d
			.s myrtn=-365
			
			;唯一表示被发现，建立卡时需要绑定
			i +myIDUFind d
			.s myrtn=-368
		}
	}
	
	q myrtn_"^"_myRtnPAPMIRowID
}

}
