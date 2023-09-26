Class web.DHCBL.CARD.CardManager Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 根据卡号获取卡号的使用次数及卡状态
ClassMethod CheckCardNO(CardNo As %String) As %String
{
	set returnvalue=""
	set count=0
	set cardRowID=""
	set cardRowID=$o(^DHCCARDi("CF",0,"CardNo",CardNo,cardRowID))
	while(cardRowID'="")
	{
		set count=count+1
		set status=$p($g(^DHCCARD("CF",cardRowID)),"^",10)
		if (returnvalue="")
		{
			set returnvalue=status
		}
		else
		{
			set returnvalue=returnvalue_","_status
		}
		set cardRowID=$o(^DHCCARDi("CF",0,"CardNo",CardNo,cardRowID))
	}
	set returnvalue=""_count_"^"_returnvalue
	quit returnvalue
}

/// 根据卡状态信息构造卡帐户状态信息
ClassMethod GenerateoCardAccStatus(CardStatus As web.DHCEntity.PCA.CardStatusChange, NewStatus As %String) As web.DHCEntity.PCA.CardAccStatusChange
{
	set CardAccStatus=##class(web.DHCEntity.PCA.CardAccStatusChange).%New()
	set AccountID=$p($g(^DHCCARD("CF",CardStatus.CardID)),"^",1)
 if AccountID="" quit CardAccStatus
 s OldStatus=$p($g(^DHCACD("AccM",AccountID)),"^",13)

	set CardAccStatus.AccountID=AccountID
	set CardAccStatus.OldStatus=OldStatus
	set CardAccStatus.NewStatus=NewStatus
	//set CardAccStatus.Left=CardStatus.CardStatus
	set CardAccStatus.OperDate=..%SysDate()
	set CardAccStatus.OperTime=$p($h,"^",2)
	set CardAccStatus.UserDR=CardStatus.UserDR
	set CardAccStatus.RLName=CardStatus.RLName
	set CardAccStatus.RLCredNo=CardStatus.RLCredNo
	set CardAccStatus.RLAddress=CardStatus.RLAddress
	set CardAccStatus.RLPhoneNo=CardStatus.RLPhoneNo
	set CardAccStatus.RLProof=CardStatus.RLProof
	set CardAccStatus.RLRemark=CardStatus.RLRemark
	set CardAccStatus.CredType=CardStatus.RLCredTypeID
	
	quit CardAccStatus
}

/// 根据卡CardID获取卡状态
ClassMethod GetCardStatus(CardID As %String) As %String
{
	set status=$p($g(^DHCCARD("CF",CardID)),"^",10)
	quit status
}

/// 根据卡CardID获取卡状态更改日期
ClassMethod GetCardStatusChangeDate(CardID As %String) As %String
{
	&sql(select max(CSC_Date) into :LossDate from  sqluser.DHC_CardStatusChange where CSC_CF_ParRef=:CardID )
	
	quit LossDate
}

/// //判断该卡类型是否为当前业务支持
ClassMethod IsSupportCardType(SupportFlag As %String, CardTypeID As %String) As %Integer
{
	q:SupportFlag="" 1
	q:CardTypeID="" 1
	s cardtypeStr=$g(^DHCCARDTYPEDef(CardTypeID))
	q:cardtypeStr="" -1
	s lossFlag="",exchangeFlag="",fillFlag=""
	s lossFlag=$p(cardtypeStr,"^",31)
	s exchangeFlag=$p(cardtypeStr,"^",32)
	s fillFlag=$p(cardtypeStr,"^",33)
	s backFlag=$p(cardtypeStr,"^",7)

	If (SupportFlag="L") //挂失
	{
		If (lossFlag="Y")
		{
			Quit 1
		}else
		{
			Quit -1
		}
	}
	If (SupportFlag="E")
	{
		If (exchangeFlag="Y") //换卡
		{
			Quit 1
		}else
		{
			Quit -1
		}
	}
	If (SupportFlag="F")
	{
		If (fillFlag="Y") //补卡
		{
			Quit 1
		}else
		{
			Quit -1
		}
	}
	If (SupportFlag="B")
	{
		If (backFlag="Y") //退卡
		{
			Quit 1
		}else
		{
			Quit -1
		}
	}
	Q -1
}

ClassMethod PatientCardQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PatientCardQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
	Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCBL.CARD.CardManager","PatientCardQuery","","","0000000110","N","1","","","","","","","","","","","","") 

ClassMethod PatientCardQueryExecute(ByRef qHandle As %Binary, Name As %String, IDCardNo As %String, CardNo As %String, CardStatus As %String, CardTypeID As %String, SupportFlag As %String, CredNo As %String, UseStatus As %String, BirthDay As %String, Telphone As %String, OutMedicareNo As %String, InMedicareNo As %String, RegNo As %String, NewInMedicareNo As %String, InsuranceNo As %String, EmMedicare As %String) As %Status
{
	s NewOutMedicareNo="",NewInMedicareNo="" //东、西病历号，目前标库没有用到，NewOutMedicareNo改成登记号查询
	s ^DHCXPTest("Input1")=Name_"^"_IDCardNo_"^"_CardNo_"^"_CardStatus_"^"_CardTypeID
	s ^DHCXPTest("Input1")=^DHCXPTest("Input1")_"^"_SupportFlag_"^"_CredNo_"^"_UseStatus_"^"_BirthDay
	s ^DHCXPTest("Input1")=^DHCXPTest("Input1")_"^"_Telphone_"^"_OutMedicareNo_"^"_InMedicareNo
	s ^DHCXPTest("Input1")=^DHCXPTest("Input1")_"^"_NewOutMedicareNo_"^"_NewInMedicareNo_"^"_InsuranceNo
	//s RegNo=""
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
	s ^tempztwa("PatientCardQueryExecute")=$lb(Name , IDCardNo , CardNo , CardStatus , CardTypeID , SupportFlag , CredNo , UseStatus , BirthDay , Telphone , OutMedicareNo , InMedicareNo , NewOutMedicareNo , NewInMedicareNo , InsuranceNo , EmMedicare , RegNo )
	s Name=$ZConvert(Name,"U")			;姓名转换成大写
	s CredNo=$ZConvert(CredNo,"U")		;证件号转换成大写
	s OutMedicareNo=$ZConvert(OutMedicareNo,"U")		;门诊病历号转换成大写	
	s InMedicareNo=$ZConvert(InMedicareNo,"U")			;住院病历号转换成大写	
	s InsuranceNo=$ZConvert(InsuranceNo,"U")			;医保号转换成大写	
	s NameStandard=$ZConvert(Name,"U") 	;保留姓名字串
	s mySupportFlag=SupportFlag			;保留业务支持字串
	s qName=NameStandard				;保留姓名字串
	s qIDCardNo=IDCardNo				;保留身份证号字串
	s qCardNo=CardNo					;保留卡号字串
	s qCredNo=CredNo					;保留证件号字串
	s qUseStatus=UseStatus				;保留是否使用状态判断标记
	s qTelphoneNo=Telphone
	s qBirthDay=BirthDay
	i qBirthDay'=""  s qBirthDay=..%ZDH(qBirthDay) //$zdh(qBirthDay,3)
	s qOutMedicareNo=OutMedicareNo
	s qInMedicareNo=InMedicareNo
	
	s qNewOutMedicareNo=NewOutMedicareNo
	s qNewInMedicareNo=NewInMedicareNo
	s qInsuranceNo=InsuranceNo
	S qEmMedicare=EmMedicare
	s qRegNo=RegNo
	s myCredNo=""						;初始化输出证件号
	s myCredTypeDesc=""					;初始化输出证件类型
	s LogonHospId=%session.Data("LOGON.HOSPID")
	;支持退挂失的卡
	i SupportFlag="B" {
		i CardStatus="" {
			s CardStatus=" D "
		}else{
			s CardStatus=" "_CardStatus_" D "
		}
	}else{
		i CardStatus'="" s CardStatus=" "_CardStatus_" "
	}
	s qUseStatus="N"
 //1*******************按卡号查询
	s RowId=""
	if (qCardNo'="")
	{
		s RowId=$o(^DHCCARDi("CF",0,"CardNo",CardNo,RowId))
		while(RowId'="")
		{
			s status=$p(^DHCCARD("CF",RowId),"^",10)
			s:status="" status="N"
			set CFType=$P(^DHCCARD("CF",RowId),"^",16)
			//判断卡类型是否给该院区授权
			s HosFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_CardTypeDef",CFType,LogonHospId,+$H)
			if HosFlag'="Y" s RowId=$o(^DHCCARDi("CF",0,"CardNo",CardNo,RowId)) continue
			s ^DHCXPTest("CardNoMan")=qUseStatus_"^"_status_"^"_CardStatus
			if ((qUseStatus="N") || (CardStatus[(" "_status_" ")))
			{
				s ID=RowId
				s CardNO=$p(^DHCCARD("CF",RowId),"^",2)
				
				s ActivedFlag=status
				i ActivedFlag="" s ActivedFlag="正常"
				i ActivedFlag="N" s ActivedFlag="正常"
				 i ActivedFlag="S" s ActivedFlag="挂失"
				 i ActivedFlag="D" s ActivedFlag="作废"
				 i ActivedFlag="R" s ActivedFlag="回收"

				 s PersonRowId=$p(^DHCCARD("CF",RowId),"^",4)
				 s Name=$p(^PAPER(PersonRowId,"ALL"),"^",1)
				 s IDCardNo= $p(^PAPER(PersonRowId,"ALL"),"^",9)

				 s cardtype=""
				 if ($g(^DHCCARD("CF",RowId))'="") s cardtype=$p($g(^DHCCARD("CF",RowId)),"^",16)
				 if (CardTypeID="" ||(CardTypeID=cardtype))
				 {
					if (..IsSupportCardType(mySupportFlag,cardtype)=1)
					{
						s myCredStr=$g(^PAPER(PersonRowId,"ALL"))
						if (myCredStr'=""){
							do PatInfo(PersonRowId)
						}
						s CardTypeDesc=$p($g(^DHCCARDTYPEDef(cardtype)),"^",2)
						s AccMBalance=0
						s myAccRowID=$p(^DHCCARD("CF",RowId),"^",1)
						if myAccRowID'="" {
							s AccStatus=$p(^DHCACD("AccM",myAccRowID),"^",13)
							if (AccStatus="N"){
								s AccMBalance=##class(web.DHCBillInterface).IGetAccMDeposit(PersonRowId,LogonHospId)
							}
						}
						set Data=$ListBuild(Name,IDCardNo,CardNO,ActivedFlag,ID,CardTypeDesc,myCredNo,myCredTypeDesc,myOtherStr,TPoliticalLevel,TSecretLevel,PersonRowId,AccMBalance)
						s PAPMIDOB=$p(^PAPER(PersonRowId,"ALL"),"^",6)
						s ind1=100000+ind
						s Tind=PAPMIDOB_ind1
						Set ^CacheTemp(repid,Tind)=Data
						Set ind=ind+1
					}
				 }
			}
			s RowId=$o(^DHCCARDi("CF",0,"CardNo",CardNo,RowId))
		}

		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	//1.2*******************按登记号查询
	if (qRegNo'="")
	{
		s PersonRowId=""
		s PersonRowId=$o(^PAPERi("PAPMI_PatNo",qRegNo,PersonRowId))
	
		while(PersonRowId'="")
		{
			s RowId=""
			s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId))
			while(RowId'="")
			{
				s status=$p(^DHCCARD("CF",RowId),"^",10)
				s:status="" status="N"
				set CFType=$P(^DHCCARD("CF",RowId),"^",16)
				//判断卡类型是否给该院区授权
				s HosFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_CardTypeDef",CFType,LogonHospId,+$H)
				//q:HosFlag'="Y"
				if HosFlag'="Y" s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId)) continue
				if ((qUseStatus="N") || (CardStatus[(" "_status_" ")))
				{
					s ID=RowId
					s CardNO=$p(^DHCCARD("CF",RowId),"^",2)
				
					s ActivedFlag=status
					i ActivedFlag="" s ActivedFlag="正常"
					i ActivedFlag="N" s ActivedFlag="正常"
					 i ActivedFlag="S" s ActivedFlag="挂失"
					 i ActivedFlag="D" s ActivedFlag="作废"
					 i ActivedFlag="R" s ActivedFlag="回收"

					 s Name=$p(^PAPER(PersonRowId,"ALL"),"^",1)
					 s IDCardNo= $p(^PAPER(PersonRowId,"ALL"),"^",9)
					 s cardtype=""
					 s CardTypeDesc=""
					 if ($g(^DHCCARD("CF",RowId))'="") s cardtype=$p($g(^DHCCARD("CF",RowId)),"^",16)
					 s:cardtype'="" CardTypeDesc=$p($g(^DHCCARDTYPEDef(cardtype)),"^",2)
					 if (..IsSupportCardType(mySupportFlag,cardtype)=1)
	 				{
		 				s myCredStr=$g(^PAPER(PersonRowId,"ALL"))
		 				if (myCredStr'=""){
			 				do PatInfo(PersonRowId)
		 				}
		 				s AccMBalance=0
						s myAccRowID=$p(^DHCCARD("CF",RowId),"^",1)
						if myAccRowID'="" {
							s AccStatus=$p(^DHCACD("AccM",myAccRowID),"^",13)
							if (AccStatus="N"){
								s AccMBalance=##class(web.DHCBillInterface).IGetAccMDeposit(PersonRowId,LogonHospId)
							}
						}
	 					set Data=$ListBuild(Name,IDCardNo,CardNO,ActivedFlag,ID,CardTypeDesc,myCredNo,myCredTypeDesc,myOtherStr,TPoliticalLevel,TSecretLevel,PersonRowId,AccMBalance)
						s PAPMIDOB=$p(^PAPER(PersonRowId,"ALL"),"^",6)
						s ind1=100000+ind
						s Tind=PAPMIDOB_ind1
						Set ^CacheTemp(repid,Tind)=Data
	 					Set ind=ind+1
	 				}
				}
				s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId))
			}
			s PersonRowId=$o(^PAPERi("PAPMI_PatNo",qRegNo,PersonRowId))
		}
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
 //2*******************按身份证号查询	
 if (qIDCardNo'="")
	{
		s PersonRowId=""
		s PersonRowId=$o(^PAPERi("PAPMI_ICPPBC",IDCardNo_"Z",PersonRowId))
		
		while(PersonRowId'="")
		{
			s RowId=""
			s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId))
			while(RowId'="")
			{
				s status=$p(^DHCCARD("CF",RowId),"^",10)
				s:status="" status="N"
				set CFType=$P(^DHCCARD("CF",RowId),"^",16)
				//判断卡类型是否给该院区授权
				s HosFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_CardTypeDef",CFType,LogonHospId,+$H)
				if HosFlag'="Y" s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId)) continue
				if ((qUseStatus="N") || (CardStatus[(" "_status_" ")))
				{
					s ID=RowId
					s CardNO=$p(^DHCCARD("CF",RowId),"^",2)
				
					s ActivedFlag=status
					i ActivedFlag="" s ActivedFlag="正常"
					i ActivedFlag="N" s ActivedFlag="正常"
 i ActivedFlag="S" s ActivedFlag="挂失"
 i ActivedFlag="D" s ActivedFlag="作废"
 i ActivedFlag="R" s ActivedFlag="回收"

 s Name=$p(^PAPER(PersonRowId,"ALL"),"^",1)
 s IDCardNo= $p(^PAPER(PersonRowId,"ALL"),"^",9)
 s cardtype=""
 s CardTypeDesc=""
 if ($g(^DHCCARD("CF",RowId))'="") s cardtype=$p($g(^DHCCARD("CF",RowId)),"^",16)
 s:cardtype'="" CardTypeDesc=$p($g(^DHCCARDTYPEDef(cardtype)),"^",2)
 if (..IsSupportCardType(mySupportFlag,cardtype)=1)
	 				{
		 				s myCredStr=$g(^PAPER(PersonRowId,"ALL"))
		 				if (myCredStr'=""){
			 				do PatInfo(PersonRowId)
		 				}
		 				s AccMBalance=0
						s myAccRowID=$p(^DHCCARD("CF",RowId),"^",1)
						if myAccRowID'="" {
							s AccStatus=$p(^DHCACD("AccM",myAccRowID),"^",13)
							if (AccStatus="N"){
								s AccMBalance=##class(web.DHCBillInterface).IGetAccMDeposit(PersonRowId,LogonHospId)
							}
						}
	 					set Data=$ListBuild(Name,IDCardNo,CardNO,ActivedFlag,ID,CardTypeDesc,myCredNo,myCredTypeDesc,myOtherStr,TPoliticalLevel,TSecretLevel,PersonRowId,AccMBalance)
						s PAPMIDOB=$p(^PAPER(PersonRowId,"ALL"),"^",6)
						s ind1=100000+ind
						s Tind=PAPMIDOB_ind1
						Set ^CacheTemp(repid,Tind)=Data
	 					Set ind=ind+1
	 				}
				}
				s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId))
			}
			s PersonRowId=$o(^PAPERi("PAPMI_ICPPBC",IDCardNo_"Z",PersonRowId))
		}
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
		
 //3*******************按证件号查询
	if (qCredNo'="")
	{
		s PersonRowId=""
		s PersonRowId=$o(^PAPERi("DVA",qCredNo,PersonRowId))
	
		while(PersonRowId'="")
		{
			s RowId=""
			s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId))
			while(RowId'="")
			{
				s status=$p(^DHCCARD("CF",RowId),"^",10)
				s:status="" status="N"
				set CFType=$P(^DHCCARD("CF",RowId),"^",16)
				//判断卡类型是否给该院区授权
				s HosFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_CardTypeDef",CFType,LogonHospId,+$H)
				if HosFlag'="Y" s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId)) continue
				if ((qUseStatus="N") || (CardStatus[(" "_status_" ")))
				{
					s ID=RowId
					s CardNO=$p(^DHCCARD("CF",RowId),"^",2)
				
					s ActivedFlag=status
					i ActivedFlag="" s ActivedFlag="正常"
					i ActivedFlag="N" s ActivedFlag="正常"
 i ActivedFlag="S" s ActivedFlag="挂失"
 i ActivedFlag="D" s ActivedFlag="作废"
 i ActivedFlag="R" s ActivedFlag="回收"

 s Name=$p(^PAPER(PersonRowId,"ALL"),"^",1)
 s IDCardNo= $p(^PAPER(PersonRowId,"ALL"),"^",9)
 s cardtype=""
 s CardTypeDesc=""
 if ($g(^DHCCARD("CF",RowId))'="") s cardtype=$p($g(^DHCCARD("CF",RowId)),"^",16)
 s:cardtype'="" CardTypeDesc=$p($g(^DHCCARDTYPEDef(cardtype)),"^",2)
 s CredNo=qCredNo
 s CredTypeID=$p(^PAPER(PersonRowId,"ALL"),"^",1)
 s CredTypeDesc=""
 if (..IsSupportCardType(mySupportFlag,cardtype)=1)
	 				{
		 				s myCredStr=$g(^PAPER(PersonRowId,"ALL"))
		 				if (myCredStr'=""){
			 				do PatInfo(PersonRowId)
		 				}
		 				s AccMBalance=0
						s myAccRowID=$p(^DHCCARD("CF",RowId),"^",1)
						if myAccRowID'="" {
							s AccStatus=$p(^DHCACD("AccM",myAccRowID),"^",13)
							if (AccStatus="N"){
								s AccMBalance=##class(web.DHCBillInterface).IGetAccMDeposit(PersonRowId,LogonHospId)
							}
						}
	 					set Data=$ListBuild(Name,IDCardNo,CardNO,ActivedFlag,ID,CardTypeDesc,myCredNo,myCredTypeDesc,myOtherStr,TPoliticalLevel,TSecretLevel,PersonRowId,AccMBalance)
						s PAPMIDOB=$p(^PAPER(PersonRowId,"ALL"),"^",6)
						s ind1=100000+ind
						s Tind=PAPMIDOB_ind1
						Set ^CacheTemp(repid,Tind)=Data
	 					Set ind=ind+1
	 				}
				}
				s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId))
			}
			s PersonRowId=$o(^PAPERi("DVA",qCredNo,PersonRowId))
		}
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
		
 //4*******************按姓名查询
	if (qName'="")
	{
	//4.1*******************姓名等于查询
		set PersonRowId =$o(^PAPERi("PAPER_PatName",qName,0))

		while (PersonRowId'="")
		{
			do ReSetVar
			set RowId=""
			s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId))
			while(RowId'="")
			{
				s status=$p(^DHCCARD("CF",RowId),"^",10)
				s:status="" status="N"
				set CFType=$P(^DHCCARD("CF",RowId),"^",16)
				//判断卡类型是否给该院区授权
				s HosFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_CardTypeDef",CFType,LogonHospId,+$H)
				if HosFlag'="Y" s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId)) continue
				if ((qUseStatus="N") || (CardStatus[(" "_status_" ")))
				{
					s ID=RowId
					s CardNO=$p(^DHCCARD("CF",RowId),"^",2)
				
					s ActivedFlag=status
					;q:((CardStatus'="")&&(CardStatus="S")&&(ActivedFlag="N"))
					i ActivedFlag="" s ActivedFlag="正常"
					i ActivedFlag="N" s ActivedFlag="正常"
					 i ActivedFlag="S" s ActivedFlag="挂失"
					 i ActivedFlag="D" s ActivedFlag="作废"
					 i ActivedFlag="R" s ActivedFlag="回收"

					 s Name=$p(^PAPER(PersonRowId,"ALL"),"^",1)
					 s IDCardNo= $p(^PAPER(PersonRowId,"ALL"),"^",9)
					 s cardtype=""
					 s CardTypeDesc=""
					 if ($g(^DHCCARD("CF",RowId))'="") s cardtype=$p($g(^DHCCARD("CF",RowId)),"^",16)
					 s:cardtype'="" CardTypeDesc=$p($g(^DHCCARDTYPEDef(cardtype)),"^",2)
					 if (..IsSupportCardType(mySupportFlag,cardtype)=1)
	 				{
		 				s myCredStr=$g(^PAPER(PersonRowId,"ALL"))
		 				if (myCredStr'=""){
			 				do PatInfo(PersonRowId)
		 				}
		 				s AccMBalance=0
						s myAccRowID=$p(^DHCCARD("CF",RowId),"^",1)
						if myAccRowID'="" {
							s AccStatus=$p(^DHCACD("AccM",myAccRowID),"^",13)
							if (AccStatus="N"){
								s AccMBalance=##class(web.DHCBillInterface).IGetAccMDeposit(PersonRowId,LogonHospId)
							}
						}
		 				if (..%ZDH(myBirthDay)'=qBirthDay)&(BirthDay'="") q
                        .q:($ZCVT(Name,"U")'[NameStandard)
	 					set Data=$ListBuild(Name,IDCardNo,CardNO,ActivedFlag,ID,CardTypeDesc,myCredNo,myCredTypeDesc,myOtherStr,TPoliticalLevel,TSecretLevel,PersonRowId,AccMBalance)
						s PAPMIDOB=$p(^PAPER(PersonRowId,"ALL"),"^",6)
						s ind1=100000+ind
						s Tind=PAPMIDOB_ind1
						Set ^CacheTemp(repid,Tind)=Data
	 					Set ind=ind+1
	 				}
				}
				s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId))
			}
			set PersonRowId =$o(^PAPERi("PAPER_PatName",qName,PersonRowId))
		}
		
 //4.2*******************姓名模糊查询
		Set PAPERName = $o(^PAPERi("PAPER_PatName",qName)) //模糊查询
		while(PAPERName'="")
		{
			if (PAPERName[NameStandard)
			{
				s tmpId=""
				s tmpId=$o(^PAPERi("PAPER_PatName",PAPERName,tmpId))
				while(tmpId'="")
				{
					s PersonRowId=tmpId
					set RowId=""
					s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId))
					while(RowId'="")
					{
						s status=$p(^DHCCARD("CF",RowId),"^",10)
						s:status="" status="N"
						set CFType=$P(^DHCCARD("CF",RowId),"^",16)
						//判断卡类型是否给该院区授权
						s HosFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_CardTypeDef",CFType,LogonHospId,+$H)
						if HosFlag'="Y" s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId)) continue
						s:qUseStatus="" qUseStatus="N"
						if ((qUseStatus="N") || (CardStatus[(" "_status_" ")))
						{
							s ID=RowId
							s CardNO=$p(^DHCCARD("CF",RowId),"^",2)
							s ActivedFlag=status
							;q:((CardStatus'="")&&(CardStatus="S")&&(ActivedFlag="N"))
							i ActivedFlag="" s ActivedFlag="正常"
							i ActivedFlag="N" s ActivedFlag="正常"
	 						i ActivedFlag="S" s ActivedFlag="挂失"
	 						i ActivedFlag="D" s ActivedFlag="作废"
	 						i ActivedFlag="R" s ActivedFlag="回收"

	 						s Name=$p(^PAPER(PersonRowId,"ALL"),"^",1)
	 						s IDCardNo= $p(^PAPER(PersonRowId,"ALL"),"^",9)
	 						s cardtype=""
	 						s CardTypeDesc=""
	 						if ($g(^DHCCARD("CF",RowId))'="") s cardtype=$p($g(^DHCCARD("CF",RowId)),"^",16)
	 						s:cardtype'="" CardTypeDesc=$p($g(^DHCCARDTYPEDef(cardtype)),"^",2)
	 						if (..IsSupportCardType(mySupportFlag,cardtype)=1)
			 				{
				 				s myCredStr=$g(^PAPER(PersonRowId,"ALL"))
				 				if (myCredStr'=""){
					 				do PatInfo(PersonRowId)
				 				}
				 				if ($zd(qBirthDay,3)'=myBirthDay)&(BirthDay'="") q
				 				//w PAPERName,!
				 				.q:($ZCVT(Name,"U")'[NameStandard)
				 				s AccMBalance=0
								s myAccRowID=$p(^DHCCARD("CF",RowId),"^",1)
								if myAccRowID'="" {
									s AccStatus=$p(^DHCACD("AccM",myAccRowID),"^",13)
									if (AccStatus="N"){
										s AccMBalance=##class(web.DHCBillInterface).IGetAccMDeposit(PersonRowId,LogonHospId)
									}
								}
		 						set Data=$ListBuild(Name,IDCardNo,CardNO,ActivedFlag,ID,CardTypeDesc,myCredNo,myCredTypeDesc,myOtherStr,TPoliticalLevel,TSecretLevel,,PersonRowId,AccMBalance)
								s PAPMIDOB=$p(^PAPER(PersonRowId,"ALL"),"^",6)
								s ind1=100000+ind
								s Tind=PAPMIDOB_ind1
								Set ^CacheTemp(repid,Tind)=Data
		 						Set ind=ind+1
			 				}
						}
						s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId))
					}
					s tmpId=$o(^PAPERi("PAPER_PatName",PAPERName,tmpId))
				}
					
			}
			Set PAPERName = $o(^PAPERi("PAPER_PatName",PAPERName)) 
		}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	}

	if (qTelphoneNo'="")
	{
	//*****************按电话号码查询
	    s qTelphoneNo=qTelphoneNo_"Z"
		set PersonRowId =$o(^PAPERi("Phone",qTelphoneNo,0))
		
		while (PersonRowId'="")
		{
			do ReSetVar
			set RowId=""
			s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId))
			while(RowId'="")
			{
				s status=$p(^DHCCARD("CF",RowId),"^",10)
				s:status="" status="N"
				set CFType=$P(^DHCCARD("CF",RowId),"^",16)
				//判断卡类型是否给该院区授权
				s HosFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_CardTypeDef",CFType,LogonHospId,+$H)
				if HosFlag'="Y" s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId)) continue
				if ((qUseStatus="N") || (CardStatus[(" "_status_" ")))
				{
					s ID=RowId
					s CardNO=$p(^DHCCARD("CF",RowId),"^",2)
				
					s ActivedFlag=status
					i ActivedFlag="" s ActivedFlag="正常"
					i ActivedFlag="N" s ActivedFlag="正常"
 i ActivedFlag="S" s ActivedFlag="挂失"
 i ActivedFlag="D" s ActivedFlag="作废"
 i ActivedFlag="R" s ActivedFlag="回收"

 s Name=$p(^PAPER(PersonRowId,"ALL"),"^",1)
 s IDCardNo= $p(^PAPER(PersonRowId,"ALL"),"^",9)
 s cardtype=""
 s CardTypeDesc=""
 if ($g(^DHCCARD("CF",RowId))'="") s cardtype=$p($g(^DHCCARD("CF",RowId)),"^",16)
 s:cardtype'="" CardTypeDesc=$p($g(^DHCCARDTYPEDef(cardtype)),"^",2)
 if (..IsSupportCardType(mySupportFlag,cardtype)=1)
 {
		 				s myCredStr=$g(^PAPER(PersonRowId,"ALL"))
		 				if (myCredStr'=""){
			 				do PatInfo(PersonRowId)
		 				}
		 				s AccMBalance=0
						s myAccRowID=$p(^DHCCARD("CF",RowId),"^",1)
						if myAccRowID'="" {
							s AccStatus=$p(^DHCACD("AccM",myAccRowID),"^",13)
							if (AccStatus="N"){
								s AccMBalance=##class(web.DHCBillInterface).IGetAccMDeposit(PersonRowId,LogonHospId)
							}
						}
	 					set Data=$ListBuild(Name,IDCardNo,CardNO,ActivedFlag,ID,CardTypeDesc,myCredNo,myCredTypeDesc,myOtherStr,TPoliticalLevel,TSecretLevel,PersonRowId,AccMBalance)
						s PAPMIDOB=$p(^PAPER(PersonRowId,"ALL"),"^",6)
						s ind1=100000+ind
						s Tind=PAPMIDOB_ind1
						Set ^CacheTemp(repid,Tind)=Data
	 					Set ind=ind+1
	 				}

				}
				s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId))
			}
				set PersonRowId =$o(^PAPERi("Phone",qTelphoneNo,PersonRowId))
		}
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	if (BirthDay'="")
	{
	//*****************按出生日期查询
		set PersonRowId =$o(^PAPERi("DOB2",qBirthDay,0))
		while (PersonRowId'="")
		{
			do ReSetVar
			set RowId=""
			s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId))
			while(RowId'="")
			{
				s status=$p(^DHCCARD("CF",RowId),"^",10)
				s:status="" status="N"
				set CFType=$P(^DHCCARD("CF",RowId),"^",16)
				//判断卡类型是否给该院区授权
				s HosFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_CardTypeDef",CFType,LogonHospId,+$H)
				if HosFlag'="Y" s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId)) continue
				if ((qUseStatus="N") || (CardStatus[(" "_status_" ")))
				{
					s ID=RowId
					s CardNO=$p(^DHCCARD("CF",RowId),"^",2)
				
					s ActivedFlag=status
					i ActivedFlag="" s ActivedFlag="正常"
					i ActivedFlag="N" s ActivedFlag="正常"
 i ActivedFlag="S" s ActivedFlag="挂失"
 i ActivedFlag="D" s ActivedFlag="作废"
 i ActivedFlag="R" s ActivedFlag="回收"

 s Name=$p(^PAPER(PersonRowId,"ALL"),"^",1)
 s IDCardNo= $p(^PAPER(PersonRowId,"ALL"),"^",9)
 s cardtype=""
 s CardTypeDesc=""
 if ($g(^DHCCARD("CF",RowId))'="") s cardtype=$p($g(^DHCCARD("CF",RowId)),"^",16)
 s:cardtype'="" CardTypeDesc=$p($g(^DHCCARDTYPEDef(cardtype)),"^",2)
 if (..IsSupportCardType(mySupportFlag,cardtype)=1)
 {
		 				s myCredStr=$g(^PAPER(PersonRowId,"ALL"))
		 				if (myCredStr'=""){
			 				do PatInfo(PersonRowId)
		 				}
		 				s AccMBalance=0
						s myAccRowID=$p(^DHCCARD("CF",RowId),"^",1)
						if myAccRowID'="" {
							s AccStatus=$p(^DHCACD("AccM",myAccRowID),"^",13)
							if (AccStatus="N"){
								s AccMBalance=##class(web.DHCBillInterface).IGetAccMDeposit(PersonRowId,LogonHospId)
							}
						}
	 					set Data=$ListBuild(Name,IDCardNo,CardNO,ActivedFlag,ID,CardTypeDesc,myCredNo,myCredTypeDesc,myOtherStr,TPoliticalLevel,TSecretLevel,PersonRowId,AccMBalance)
						s PAPMIDOB=$p(^PAPER(PersonRowId,"ALL"),"^",6)
						s ind1=100000+ind
						s Tind=PAPMIDOB_ind1
						Set ^CacheTemp(repid,Tind)=Data
	 					Set ind=ind+1
	 				}

				}
				s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId))
			}
				set PersonRowId =$o(^PAPERi("DOB2",qBirthDay,PersonRowId))
		}
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	if (qOutMedicareNo'="")
	{
	//*****************按门诊病历号查询
		s qOutMedicareNo=qOutMedicareNo_"Z"
		set PersonRowId =$o(^PAPERi("Govern",qOutMedicareNo,0))
		while (PersonRowId'="")
		{
			do ReSetVar
			set RowId=""
			s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId))
			while(RowId'="")
			{
				s status=$p(^DHCCARD("CF",RowId),"^",10)
				s:status="" status="N"
				set CFType=$P(^DHCCARD("CF",RowId),"^",16)
				//判断卡类型是否给该院区授权
				s HosFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_CardTypeDef",CFType,LogonHospId,+$H)
				if HosFlag'="Y" s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId)) continue
				if ((qUseStatus="N") || (CardStatus[(" "_status_" ")))
				{
					s ID=RowId
					s CardNO=$p(^DHCCARD("CF",RowId),"^",2)
				
					s ActivedFlag=status
					i ActivedFlag="" s ActivedFlag="正常"
					i ActivedFlag="N" s ActivedFlag="正常"
 i ActivedFlag="S" s ActivedFlag="挂失"
 i ActivedFlag="D" s ActivedFlag="作废"
 i ActivedFlag="R" s ActivedFlag="回收"

 s Name=$p(^PAPER(PersonRowId,"ALL"),"^",1)
 s IDCardNo= $p(^PAPER(PersonRowId,"ALL"),"^",9)
 s cardtype=""
 s CardTypeDesc=""
 if ($g(^DHCCARD("CF",RowId))'="") s cardtype=$p($g(^DHCCARD("CF",RowId)),"^",16)
 s:cardtype'="" CardTypeDesc=$p($g(^DHCCARDTYPEDef(cardtype)),"^",2)
 if (..IsSupportCardType(mySupportFlag,cardtype)=1)
 {
		 				s myCredStr=$g(^PAPER(PersonRowId,"ALL"))
		 				if (myCredStr'=""){
			 				do PatInfo(PersonRowId)
		 				}
		 				s AccMBalance=0
						s myAccRowID=$p(^DHCCARD("CF",RowId),"^",1)
						if myAccRowID'="" {
							s AccStatus=$p(^DHCACD("AccM",myAccRowID),"^",13)
							if (AccStatus="N"){
								s AccMBalance=##class(web.DHCBillInterface).IGetAccMDeposit(PersonRowId,LogonHospId)
							}
						}
	 					set Data=$ListBuild(Name,IDCardNo,CardNO,ActivedFlag,ID,CardTypeDesc,myCredNo,myCredTypeDesc,myOtherStr,TPoliticalLevel,TSecretLevel,PersonRowId,AccMBalance)
						s PAPMIDOB=$p(^PAPER(PersonRowId,"ALL"),"^",6)
						s ind1=100000+ind
						s Tind=PAPMIDOB_ind1
						Set ^CacheTemp(repid,Tind)=Data
	 					Set ind=ind+1
	 				}

				}
				s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId))
			}
				set PersonRowId =$o(^PAPERi("Govern",qOutMedicareNo,PersonRowId))
		}
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}

	if (qInMedicareNo'="")
	{
	//*****************按住院病历号查询
		set PersonRowId =$o(^PAPERi("Medicare1",qInMedicareNo,0))
		while (PersonRowId'="")
		{
			do ReSetVar
			set RowId=""
			s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId))
			while(RowId'="")
			{
				s status=$p(^DHCCARD("CF",RowId),"^",10)
				s:status="" status="N"
				set CFType=$P(^DHCCARD("CF",RowId),"^",16)
				//判断卡类型是否给该院区授权
				s HosFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_CardTypeDef",CFType,LogonHospId,+$H)
				if HosFlag'="Y" s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId)) continue
				if ((qUseStatus="N") || (CardStatus[(" "_status_" ")))
				{
					s ID=RowId
					s CardNO=$p(^DHCCARD("CF",RowId),"^",2)
				
					s ActivedFlag=status
					i ActivedFlag="" s ActivedFlag="正常"
					i ActivedFlag="N" s ActivedFlag="正常"
 i ActivedFlag="S" s ActivedFlag="挂失"
 i ActivedFlag="D" s ActivedFlag="作废"
 i ActivedFlag="R" s ActivedFlag="回收"

 s Name=$p(^PAPER(PersonRowId,"ALL"),"^",1)
 s IDCardNo= $p(^PAPER(PersonRowId,"ALL"),"^",9)
 s cardtype=""
 s CardTypeDesc=""
 if ($g(^DHCCARD("CF",RowId))'="") s cardtype=$p($g(^DHCCARD("CF",RowId)),"^",16)
 s:cardtype'="" CardTypeDesc=$p($g(^DHCCARDTYPEDef(cardtype)),"^",2)
 if (..IsSupportCardType(mySupportFlag,cardtype)=1)
 {
		 				s myCredStr=$g(^PAPER(PersonRowId,"ALL"))
		 				if (myCredStr'=""){
			 				do PatInfo(PersonRowId)
		 				}
		 				s AccMBalance=0
						s myAccRowID=$p(^DHCCARD("CF",RowId),"^",1)
						if myAccRowID'="" {
							s AccStatus=$p(^DHCACD("AccM",myAccRowID),"^",13)
							if (AccStatus="N"){
								s AccMBalance=##class(web.DHCBillInterface).IGetAccMDeposit(PersonRowId,LogonHospId)
							}
						}
	 					set Data=$ListBuild(Name,IDCardNo,CardNO,ActivedFlag,ID,CardTypeDesc,myCredNo,myCredTypeDesc,myOtherStr,TPoliticalLevel,TSecretLevel,PersonRowId,AccMBalance)
						s PAPMIDOB=$p(^PAPER(PersonRowId,"ALL"),"^",6)
						s ind1=100000+ind
						s Tind=PAPMIDOB_ind1
						Set ^CacheTemp(repid,Tind)=Data
	 					Set ind=ind+1
	 				}

				}
				s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId))
			}
				set PersonRowId =$o(^PAPERi("Medicare1",qInMedicareNo,PersonRowId))
		}
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}

	if (qNewOutMedicareNo'="")
	{
	//*****************按门诊病历号(西)查询
		;s qNewOutMedicareNo=qNewOutMedicareNo_"Z"
		set PersonRowId =$o(^DHCPERSON(0,"FCMedicareCode1",qNewOutMedicareNo,0))
		while (PersonRowId'="")
		{
			do ReSetVar
			s PapmiRowId=$p(^DHCPERSON(PersonRowId),"^",1)
			set RowId=""
			s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PapmiRowId,RowId))
			while(RowId'="")
			{
				s status=$p(^DHCCARD("CF",RowId),"^",10)
				s:status="" status="N"
				set CFType=$P(^DHCCARD("CF",RowId),"^",16)
				//判断卡类型是否给该院区授权
				s HosFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_CardTypeDef",CFType,LogonHospId,+$H)
				if HosFlag'="Y" s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PapmiRowId,RowId)) continue
				if ((qUseStatus="N") || (CardStatus[(" "_status_" ")))
				{
					s ID=RowId
					s CardNO=$p(^DHCCARD("CF",RowId),"^",2)
				
					s ActivedFlag=status
					i ActivedFlag="" s ActivedFlag="正常"
					i ActivedFlag="N" s ActivedFlag="正常"
 i ActivedFlag="S" s ActivedFlag="挂失"
 i ActivedFlag="D" s ActivedFlag="作废"
 i ActivedFlag="R" s ActivedFlag="回收"

 s Name=$p(^PAPER(PapmiRowId,"ALL"),"^",1)
 s IDCardNo= $p(^PAPER(PapmiRowId,"ALL"),"^",9)
 s cardtype=""
 s CardTypeDesc=""
 if ($g(^DHCCARD("CF",RowId))'="") s cardtype=$p($g(^DHCCARD("CF",RowId)),"^",16)
 s:cardtype'="" CardTypeDesc=$p($g(^DHCCARDTYPEDef(cardtype)),"^",2)
 if (..IsSupportCardType(mySupportFlag,cardtype)=1)
 {
		 				s myCredStr=$g(^PAPER(PapmiRowId,"ALL"))
		 				if (myCredStr'=""){
			 				do PatInfo(PapmiRowId)
		 				}
		 				s AccMBalance=0
						s myAccRowID=$p(^DHCCARD("CF",RowId),"^",1)
						if myAccRowID'="" {
							s AccStatus=$p(^DHCACD("AccM",myAccRowID),"^",13)
							if (AccStatus="N"){
								s AccMBalance=##class(web.DHCBillInterface).IGetAccMDeposit(PersonRowId,LogonHospId)
							}
						}
	 					set Data=$ListBuild(Name,IDCardNo,CardNO,ActivedFlag,ID,CardTypeDesc,myCredNo,myCredTypeDesc,myOtherStr,TPoliticalLevel,TSecretLevel,PersonRowId,PersonRowId,AccMBalance)
						s PAPMIDOB=$p(^PAPER(PersonRowId,"ALL"),"^",6)
						s ind1=100000+ind
						s Tind=PAPMIDOB_ind1
						Set ^CacheTemp(repid,Tind)=Data
	 					Set ind=ind+1
	 				}

				}
				s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PapmiRowId,RowId))
			}
				set PersonRowId =$o(^DHCPERSON(0,"FCMedicareCode1",qNewOutMedicareNo,PersonRowId))
		}
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}

	if (qNewInMedicareNo'="")
	{
	//*****************按住院病历号(西)查询
		;s qNewOutMedicareNo=qNewOutMedicareNo_"Z"
		set PersonRowId =$o(^DHCPERSON(0,"FCMedicareCode2",qNewInMedicareNo,0))
		while (PersonRowId'="")
		{
			do ReSetVar
			s PapmiRowId=$p(^DHCPERSON(PersonRowId),"^",1)
			set RowId=""
			s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PapmiRowId,RowId))
			while(RowId'="")
			{
				s status=$p(^DHCCARD("CF",RowId),"^",10)
				s:status="" status="N"
				set CFType=$P(^DHCCARD("CF",RowId),"^",16)
				//判断卡类型是否给该院区授权
				s HosFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_CardTypeDef",CFType,LogonHospId,+$H)
				if HosFlag'="Y" s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PapmiRowId,RowId)) continue
				if ((qUseStatus="N") || (CardStatus[(" "_status_" ")))
				{
					s ID=RowId
					s CardNO=$p(^DHCCARD("CF",RowId),"^",2)
				
					s ActivedFlag=status
					i ActivedFlag="" s ActivedFlag="正常"
					i ActivedFlag="N" s ActivedFlag="正常"
 i ActivedFlag="S" s ActivedFlag="挂失"
 i ActivedFlag="D" s ActivedFlag="作废"
 i ActivedFlag="R" s ActivedFlag="回收"

 s Name=$p(^PAPER(PapmiRowId,"ALL"),"^",1)
 s IDCardNo= $p(^PAPER(PapmiRowId,"ALL"),"^",9)
 s cardtype=""
 s CardTypeDesc=""
 if ($g(^DHCCARD("CF",RowId))'="") s cardtype=$p($g(^DHCCARD("CF",RowId)),"^",16)
 s:cardtype'="" CardTypeDesc=$p($g(^DHCCARDTYPEDef(cardtype)),"^",2)
 if (..IsSupportCardType(mySupportFlag,cardtype)=1)
 {
		 				s myCredStr=$g(^PAPER(PapmiRowId,"ALL"))
		 				if (myCredStr'=""){
			 				do PatInfo(PapmiRowId)
		 				}
		 				s AccMBalance=0
						s myAccRowID=$p(^DHCCARD("CF",RowId),"^",1)
						if myAccRowID'="" {
							s AccStatus=$p(^DHCACD("AccM",myAccRowID),"^",13)
							if (AccStatus="N"){
								s AccMBalance=##class(web.DHCBillInterface).IGetAccMDeposit(PersonRowId,LogonHospId)
							}
						}
	 					set Data=$ListBuild(Name,IDCardNo,CardNO,ActivedFlag,ID,CardTypeDesc,myCredNo,myCredTypeDesc,myOtherStr,TPoliticalLevel,TSecretLevel,PersonRowId,AccMBalance)
						s PAPMIDOB=$p(^PAPER(PersonRowId,"ALL"),"^",6)
						s ind1=100000+ind
						s Tind=PAPMIDOB_ind1
						Set ^CacheTemp(repid,Tind)=Data
	 					Set ind=ind+1
	 				}

				}
				s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PapmiRowId,RowId))
			}
				set PersonRowId =$o(^DHCPERSON(0,"FCMedicareCode2",qNewInMedicareNo,PersonRowId))
		}
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}

	if (qInsuranceNo'="")
	{
	//*****************按医保号查询
		;s qNewOutMedicareNo=qNewOutMedicareNo_"Z" ^PAPERi("PAPER_PatName"
		set PersonRowId =$o(^PAPERi("PAPER_HFundNo",qInsuranceNo,0))
		while (PersonRowId'="")
		{
			do ReSetVar
			set RowId=""
			s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId))
			while(RowId'="")
			{
				s status=$p(^DHCCARD("CF",RowId),"^",10)
				s:status="" status="N"
				set CFType=$P(^DHCCARD("CF",RowId),"^",16)
				//判断卡类型是否给该院区授权
				s HosFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_CardTypeDef",CFType,LogonHospId,+$H)
				if HosFlag'="Y" s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId)) continue
				if ((qUseStatus="N") || (CardStatus[(" "_status_" ")))
				{
					s ID=RowId
					s CardNO=$p(^DHCCARD("CF",RowId),"^",2)
				
					s ActivedFlag=status
					i ActivedFlag="" s ActivedFlag="正常"
					i ActivedFlag="N" s ActivedFlag="正常"
					 i ActivedFlag="S" s ActivedFlag="挂失"
					 i ActivedFlag="D" s ActivedFlag="作废"
					 i ActivedFlag="R" s ActivedFlag="回收"

					 s Name=$p(^PAPER(PersonRowId,"ALL"),"^",1)
					 s IDCardNo= $p(^PAPER(PersonRowId,"ALL"),"^",9)
					 s cardtype=""
					 s CardTypeDesc=""
					 if ($g(^DHCCARD("CF",RowId))'="") s cardtype=$p($g(^DHCCARD("CF",RowId)),"^",16)
					 s:cardtype'="" CardTypeDesc=$p($g(^DHCCARDTYPEDef(cardtype)),"^",2)
					 if (..IsSupportCardType(mySupportFlag,cardtype)=1)
					 {
		 				s myCredStr=$g(^PAPER(PersonRowId,"ALL"))
		 				if (myCredStr'=""){
			 				do PatInfo(PersonRowId)
		 				}
		 				s AccMBalance=0
						s myAccRowID=$p(^DHCCARD("CF",RowId),"^",1)
						if myAccRowID'="" {
							s AccStatus=$p(^DHCACD("AccM",myAccRowID),"^",13)
							if (AccStatus="N"){
								s AccMBalance=##class(web.DHCBillInterface).IGetAccMDeposit(PersonRowId,LogonHospId)
							}
						}
	 					set Data=$ListBuild(Name,IDCardNo,CardNO,ActivedFlag,ID,CardTypeDesc,myCredNo,myCredTypeDesc,myOtherStr,TPoliticalLevel,TSecretLevel,PersonRowId,AccMBalance)
						s PAPMIDOB=$p(^PAPER(PersonRowId,"ALL"),"^",6)
						s ind1=100000+ind
						s Tind=PAPMIDOB_ind1
						Set ^CacheTemp(repid,Tind)=Data
	 					Set ind=ind+1
	 				}

				}
				s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId))
			}
				set PersonRowId =$o(^PAPERi("PAPER_PatName",qInsuranceNo,PersonRowId))
		}
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	if (qEmMedicare'="")
	{
	//*****************按急诊病历号查询
		;s qNewOutMedicareNo=qNewOutMedicareNo_"Z"
		set PersonRowId =$o(^DHCPERSON(0,"SGMedicareCode1",qEmMedicare,0))
		SET ^DHCAA=PersonRowId
		while (PersonRowId'="")
		{
			do ReSetVar
			s PapmiRowId=$p(^DHCPERSON(PersonRowId),"^",1)
			set RowId=""
			s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PapmiRowId,RowId))
			while(RowId'="")
			{
				s status=$p(^DHCCARD("CF",RowId),"^",10)
				s:status="" status="N"
				set CFType=$P(^DHCCARD("CF",RowId),"^",16)
				//判断卡类型是否给该院区授权
				s HosFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_CardTypeDef",CFType,LogonHospId,+$H)
				if HosFlag'="Y" s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PapmiRowId,RowId)) continue
				if ((qUseStatus="N") || (CardStatus[(" "_status_" ")))
				{
					s ID=RowId
					s CardNO=$p(^DHCCARD("CF",RowId),"^",2)
				
					s ActivedFlag=status
					i ActivedFlag="" s ActivedFlag="正常"
					i ActivedFlag="N" s ActivedFlag="正常"
 					i ActivedFlag="S" s ActivedFlag="挂失"
 					i ActivedFlag="D" s ActivedFlag="作废"
 					i ActivedFlag="R" s ActivedFlag="回收"

 					s Name=$p(^PAPER(PapmiRowId,"ALL"),"^",1)
 					s IDCardNo= $p(^PAPER(PapmiRowId,"ALL"),"^",9)
 					s cardtype=""
 					s CardTypeDesc=""
 					if ($g(^DHCCARD("CF",RowId))'="") s cardtype=$p($g(^DHCCARD("CF",RowId)),"^",16)
 					s:cardtype'="" CardTypeDesc=$p($g(^DHCCARDTYPEDef(cardtype)),"^",2)
 					if (..IsSupportCardType(mySupportFlag,cardtype)=1)
 					{
		 				s myCredStr=$g(^PAPER(PapmiRowId,"ALL"))
		 				if (myCredStr'=""){
			 				do PatInfo(PapmiRowId)
		 				}
		 				s AccMBalance=0
						s myAccRowID=$p(^DHCCARD("CF",RowId),"^",1)
						if myAccRowID'="" {
							s AccStatus=$p(^DHCACD("AccM",myAccRowID),"^",13)
							if (AccStatus="N"){
								
								s AccMBalance=##class(web.DHCBillInterface).IGetAccMDeposit(PersonRowId,LogonHospId)
							}
						}
						
	 					set Data=$ListBuild(Name,IDCardNo,CardNO,ActivedFlag,ID,CardTypeDesc,myCredNo,myCredTypeDesc,myOtherStr,TPoliticalLevel,TSecretLevel,PersonRowId,AccMBalance)
						s PAPMIDOB=$p(^PAPER(PersonRowId,"ALL"),"^",6)
						s ind1=100000+ind
						s Tind=PAPMIDOB_ind1
						Set ^CacheTemp(repid,Tind)=Data
	 					Set ind=ind+1
	 				}

				}
				s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PapmiRowId,RowId))
			}
				set PersonRowId =$o(^DHCPERSON(0,"SGMedicareCode1",qEmMedicare,PersonRowId))
		}
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

PatInfo(PersonRowId)
	s myCredNo=$p($g(^PAPER(PersonRowId,"PAT",3)),"^",6)
	s myCredTypeID=$p($g(^PAPER(PersonRowId,"PAT",3)),"^",7)
	s:myCredTypeID'="" myCredTypeDesc=$p($g(^PAC("CARD",myCredTypeID)),"^",2)
	s myTelH=$p(^PAPER(PersonRowId,"PER",1),"^",11) ;电话号码
	s myBirthDay=$p(^PAPER(PersonRowId,"ALL"),"^",6) ;出生日期
	s myBirthDay=..%ZD(myBirthDay) //$zd(myBirthDay,3)
	s mySexDr=$p(^PAPER(PersonRowId,"ALL"),"^",7) ;性别
	i mySexDr'="" d 
	.s mySexDesc=$p(^CT("SEX",mySexDr),"^",2)			 				
	e  s mySexDesc=""
	s myOutMedicareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(PersonRowId,"O",$g(%session.Data("LOGON.HOSPID")))
	s myInMedicareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(PersonRowId,"I",$g(%session.Data("LOGON.HOSPID")))
	s myNewOutMedicareNo=""
	s myNewInMedicareNo=""
	s DHCPersonDr=$o(^DHCPERSON(0,"PAPERSON",PersonRowId,""))
	i DHCPersonDr'=""  d 
	.i $d(^DHCPERSON(DHCPersonDr))  d 
	..s myNewOutMedicareNo=$p(^DHCPERSON(DHCPersonDr),"^",5)	;住院病历号(西)
	..s myNewInMedicareNo=$p(^DHCPERSON(DHCPersonDr),"^",6)		;住院病历号(西)
	s myAddress=$p($g(^PAPER(PersonRowId,"PER","ADD",1)),"^",1) ;住址
	s myCompany=$p($g(^PAPER(PersonRowId,"PER",4)),"^",18)      ;工作单位		 						 				
	s myPatType=""   
 	s socialstatus=$p($g(^PAPER(PersonRowId,"PER",1)),"^",10) 
	i socialstatus'="" d
	.s myPatType=$p($g(^CT("SS",socialstatus)),"^",2)           ;病人类型
	s myPapmiNo=$p($g(^PAPER(PersonRowId,"PAT",1)),"^",2)        ;IP_No
	;2015-01-25 liutieying
	s PatEncryptLevel=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(PersonRowId,.ErrMsg)
	i PatEncryptLevel'="" {
		s TPoliticalLevel=$p(PatEncryptLevel,"^",2)
		s TSecretLevel=$p(PatEncryptLevel,"^",4)
	}
	s AccmRowid=$o(^DHCACDi("AccM",0,"PAPMI",PersonRowId,0))
	S AccMBalance=""
	if (AccmRowid'="")&&((ActivedFlag="正常")||(ActivedFlag="挂失")){
		s AccMBalance=$p(^DHCACD("AccM",AccmRowid),"^",8)	
	}
	s myOtherStr=myTelH_"^"_myBirthDay_"^"_myAddress_"^"_myCompany_"^"_mySexDesc_"^"_myPatType_"^"_myPapmiNo
	s myOtherStr=myOtherStr_"^"_myInMedicareNo_"^"_myOutMedicareNo_"^"_myNewOutMedicareNo_"^"_myNewInMedicareNo_"^"_AccMBalance_"^"_cardtype
	q
	
ReSetVar
	set (myTelH,myBirthDay,myInMedicareNo,myAddress,myCompany,mySexDesc,myPatType,myPapmiNo,TPoliticalLevel,TSecretLevel)=""
	q
}

ClassMethod PatientCardQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PatientCardQueryExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 根据卡RowID获取卡类型信息[替代使用XCombo中的CardTypeDefineOnChangeHandler]
ClassMethod getcardtypeinfo(CardID As %Library.String = "")
{
	s myCardTypeinfoStr=""
	set RowID=CardID
	s ^Tomming("myCardTypeinfoStr","1")=CardID
 set CardTypeDr=$p(^DHCCARD("CF",RowID),"^",16)

 s myCardTypeStr=""
 s:CardTypeDr'="" myCardTypeStr=$g(^DHCCARDTYPEDef(CardTypeDr))
 if (myCardTypeStr'=""){
	 	set myCardTypeinfoStr=myCardTypeStr
 }
	s str=CardTypeDr_"^"_myCardTypeinfoStr
	s ^Tomming("myCardTypeinfoStr")=str
 q str
}

/// 根据卡号获取卡类型信息[刷卡更新卡类型]
ClassMethod getcardtypeinfoByCardNo(CardNo As %Library.String = "")
{
	s CardID=$o(^DHCCARDi("CF",0,"CardNo",CardNo,""))
	q:CardID=""
	s myCardTypeinfoStr=""
	set RowID=CardID

 	set CardTypeDr=$p(^DHCCARD("CF",RowID),"^",16)

 	s myCardTypeStr=""
 	s:CardTypeDr'="" myCardTypeStr=$g(^DHCCARDTYPEDef(CardTypeDr))
 	if (myCardTypeStr'=""){
	 	set myCardTypeinfoStr=myCardTypeStr
 	}
	s str=CardTypeDr_"^"_myCardTypeinfoStr
 	q str
}

/// creator:guorongyong
/// date:2013-04-26
/// desc:判断卡号优先模式判断输出,根据卡号获取卡类型信息[刷卡更新卡类型]
/// input:卡号
/// output:卡类型信息
/// other: w ##class(web.DHCBL.CARD.CardManager).getcardtypeinfoByCardNoNew("000000666666")
ClassMethod getcardtypeinfoByCardNoNew(CardNo As %Library.String = "", CardTypeRowId As %Library.String = "")
{
	s findCardSum=0,findCardTypeDR=""
	s RowID=0
	for {
		s RowID=$o(^DHCCARDi("CF",0,"CardNo",CardNo,RowID)) q:RowID=""
		s CFCardTypeDR=$p(^DHCCARD("CF",RowID),"^",16)
		s status=$p(^DHCCARD("CF",RowID),"^",10)
		s:status="" status="N"
		continue:(status'="N")&&(status'="UA")&&(status'="S")
		continue:(CardTypeRowId'="")&&(CFCardTypeDR'=CardTypeRowId)
		s findCardSum=findCardSum+1
		s findCardTypeDR=CFCardTypeDR
	}
	;如果存在卡号重复,则需要选择卡类型
	q:findCardSum>1 "-1"
	;没有找到可用的卡记录,则退出
	q:findCardTypeDR="" "-2"
	s SearchCardNoMode=$p($g(^DHCCARDTYPEDef(findCardTypeDR)),"^",28)
	;卡类型卡号优先模式,返回空,前台不控制卡类型选择
	q:SearchCardNoMode="TC" ""
 	s myCardTypeStr=""
 	s myCardTypeStr=$g(^DHCCARDTYPEDef(findCardTypeDR))

	s str=findCardTypeDR_"^"_myCardTypeStr
 	q str
}

// w ##class(web.DHCBL.CARD.CardManager).getpatinfo("","","46939")

/// 根据卡RowID获取病人及卡信息
ClassMethod getpatinfo(itmjs As %Library.String = "", itmjsex As %Library.String = "", CardID As %Library.String = "")
{
   s RegNo="",Papmi="",name="",IDCardNo="",CardNo="",SecurityNO="",ActiveFlag="",DateFrom="",DateTo="",FlagName=""
   s Balance="",CredTypeID="",CredType="",CredNo="",cardverify1="",cardverify2=""
   s myCardTypeDesc="",myCardChangeValidate="",myCardTypeID="",myCardLength="",myCardFareCost=""
    //IDCardNO:^PAPER(27,"ALL"),"^",9
	set RowID=CardID
	set accrowid=$p(^DHCCARD("CF",RowID),"^",1)
	set CardNo=$p(^DHCCARD("CF",RowID),"^",2)
	set SecurityNO=$p(^DHCCARD("CF",RowID),"^",3)
	s cardverify2=##class(web.UDHCAccEnrypt).Decrypt(SecurityNO)
	set Papmi=$p(^DHCCARD("CF",RowID),"^",4)
	
	
	 set RegNo=$p(^DHCCARD("CF",RowID),"^",6)
	 set ActiveFlag=$p(^DHCCARD("CF",RowID),"^",10)
	 S:ActiveFlag="" ActiveFlag="N"
	 set DateFrom=$p(^DHCCARD("CF",RowID),"^",11)
	 set DateTo=$p(^DHCCARD("CF",RowID),"^",12)
	 set CardTypeDr=$p(^DHCCARD("CF",RowID),"^",16)

	 s myCardTypeStr=""
	 s:CardTypeDr'="" myCardTypeStr=$g(^DHCCARDTYPEDef(CardTypeDr))
	 if (myCardTypeStr'=""){
	 	 set myCardTypeID=CardTypeDr
		 set myCardTypeDesc=$p(myCardTypeStr,"^",2)
		 set myCardChangeValidate=$p(myCardTypeStr,"^",27)
		 s myCardLength=$p(myCardTypeStr,"^",17)
		 s myCardFareCost=$p(myCardTypeStr,"^",6)
	 }
	 //set ^ozrtest(100)="aaa1:"_RowID_"bbb:"_accrowid
	 if accrowid'=""{ //有帐户情况?只保存一个号码?类型;证件号=身份证号?证件类型=身份证
		 	set Balance=$p(^DHCACD("AccM",accrowid),"^",8)
		 	set AccStatus=$p(^DHCACD("AccM",accrowid),"^",13) 	
		 	set AccType=$p(^DHCACD("AccM",accrowid),"^",16)
		 	set CredTypeID=$p(^DHCACD("AccM",accrowid),"^",17)
		 	set CredNo=$p(^DHCACD("AccM",accrowid),"^",18)
		 	set IDCardNo=CredNo
		 	set CardTypeDr=CredTypeID
	 } //else{
		 	set IDCardNo=$p(^PAPER(Papmi,"ALL"),"^",9)
		 	set CardTypeDr=""
			i $d(^PAPER(Papmi,"PAT",3)) d 
		 	.s:^PAPER(Papmi,"PAT",3)'="" CredNo=$p(^PAPER(Papmi,"PAT",3),"^",6)
		 	.s:^PAPER(Papmi,"PAT",3)'="" CredNo=$p(^PAPER(Papmi,"PAT",3),"^",6)
		 	.s:^PAPER(Papmi,"PAT",3)'="" CredTypeID=$p(^PAPER(Papmi,"PAT",3),"^",7)
	 //}
	 s CredNo=$p($g(^PAPER(Papmi,"PAT",3)),"^",6)
	 s IDCardNo=$TR(IDCardNo,$char(0),"")
	 set name=$p(^PAPER(Papmi,"ALL"),"^",1)
	 set address=$G(^PAPER(Papmi,"PER","ADD",1))
	 set phone=$p(^PAPER(Papmi,"PER",1),"^",11)
	 s sexid=$p($g(^PAPER(Papmi,"ALL")),"^",7)
	 s RSex=$p($g(^CT("SEX",sexid)),"^",2)
	 s RBirth=$ZD($p($g(^PAPER(Papmi,"ALL")),"^",6),3)
	 s myCardINVRowID=$p(^DHCCARD("CF",RowID),"^", 17)		;CF_CardINVPRT_DR
	 s myCardAmount=0
	 s myCardINVNo=""
	 i myCardINVRowID'="" d
	 .s myCardAmount=$p(^DHCCARDINVPRT(myCardINVRowID),"^", 3)
	 .s myCardINVNo=$p(^DHCCARDINVPRT(myCardINVRowID),"^", 7)
	 i DateFrom'=""  s DateFrom=..%ZD(DateFrom) //$zd(DateFrom,4)
	 i DateTo'=""  s DateTo=..%ZD(DateTo) //$zd(DateTo,4)
	 i ((ActiveFlag="N")||(ActiveFlag="")) s FlagName="正常"
	 i ActiveFlag="S" s FlagName="挂失"
	 i ActiveFlag="D" s FlagName="作废"
	 i ActiveFlag="R" s FlagName="回收"

	 /*
	 / 0?登记号 RegNo =$p(^DHCCARD("CF",卡ID),"^",6)
	 / 1?病人ID Papmi =$p(^DHCCARD("CF",卡ID),"^",4)
	 / 
	 / 2?姓名 name    =$p(^PAPER(病人ID,"ALL"),"^",1)
	 / 3?身份证号 IDCardNo
	 / 		有帐户    =帐户记录里的号码
	 / 		无帐户    =$p(^PAPER(病人ID,"ALL"),"^",9)}
	 / 4?卡号 CardNo  =$p(^DHCCARD("CF",卡ID),"^",2)
	 / 
	 / 原始验证码	  =$p(^DHCCARD("CF",卡ID),"^",3)
	 / 5?卡验证码 cardverify2=##class(web.UDHCAccEnrypt).Decrypt(原始验证码)
	 / 6?可用标记 ActiveFlag=$p(^DHCCARD("CF",卡ID),"^",10)
	 / 
	 / 存储生效日期 =$p(^DHCCARD("CF",卡ID),"^",11)[60969]
	 / 7?生效日期DateFrom=$zd(DateFrom,4)[07/03/2007]
	 / 存储失效日期=$p(^DHCCARD("CF",卡ID),"^",12)[60970]
	 */

	 /*
	 / 0- 5?登记号?病人ID?姓名?身份证号?卡号?卡验证码
	 / 6-10?可用标记?生效日期?失效日期?卡ID?卡状态
	 /11-15?帐户平衡?证件号?证件类型?证件类型ID?地址
	 /16-17?电话?卡类型ID
	 /18-20?发票记录里的卡费用?发票号?性别描述
	 /21-23?卡类型?卡验证标记?卡类型ID
	 /24-25?卡长度?办卡金额
	 */
	s str=RegNo_"^"_Papmi_"^"_name_"^"_IDCardNo_"^"_CardNo_"^"_cardverify2 ;0-5
	s str=str_"^"_ActiveFlag_"^"_DateFrom_"^"_DateTo_"^"_CardID_"^"_FlagName ;6-10
	s str=str_"^"_Balance_"^"_CredNo_"^"_CredType_"^"_CredTypeID_"^"_address ;11-15
	s str=str_"^"_phone_"^"_CardTypeDr ;16-17
	s str=str_"^"_myCardAmount_"^"_myCardINVNo_"^"_RSex		;JS  18  -19 -20
	s str=str_"^"_myCardTypeDesc_"^"_myCardChangeValidate_"^"_myCardTypeID ;21-23
	s str=str_"^"_myCardLength_"^"_myCardFareCost ;24-25
	s ^Tomming("Str")=str
	;00000028^28^tom^^000000009012^
	;^S^05/12/2007^^41^挂失
	;^^军A-100 100^^2^家哪里?Tomming's Addredd
	;^2323..232哈哈??^
	;^2^20155^男
	;^注册医疗卡-1^Y^15
	;^12^2
	if (itmjs'=""){
		 s retval=itmjs_"('"_$ZCVT(str,"O","JS")_"');"
		 i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(str,"O","JS")_"');"
		 &javascript<#(retval)#>
		 q 1
	}else{
		q str
	}
}

Query PatientCardQuery(Name As %String = "", IDCardNo As %String = "", CardNo As %String = "", CardStatus As %String = "", CardTypeID As %String = "", SupportFlag As %String, CredNo As %String = "", UseStatus As %String = "", BirthDay As %String, Telphone As %String, OutMedicareNo As %String, InMedicareNo As %String, RegNo As %String, NewInMedicareNo As %String, InsuranceNo As %String, EmMedicare As %String) As %Query(ROWSPEC = "Name:%String,IDCardNo:%String,CardNO:%String,ActivedFlag:%String,CardID:%String,CardTypeDesc:%String,CredNo:%String,CredTypeDesc:%String,myOtherStr:%String,TPoliticalLevel:%String,TSecretLevel:%String,TPatientId:%String,TBalance:%String")
{
}

// W ##Class(web.DHCBL.CARD.CardManager).GetpatinfoByIDCardNo("372926199204214537")

ClassMethod GetpatinfoByIDCardNo(IDCardNo, flag)
{
	s ^tmpscl("GetpatinfoByIDCardNo")=IDCardNo_","_flag
	q:IDCardNo="" ""
	s CFRowID="" f  s CFRowID=$o(^DHCCARDi("CF",0,"IDCardNo",IDCardNo,CFRowID)) q:CFRowID=""  d
	.s CFActiveFlag=$p(^DHCCARD("CF",CFRowID),"^",10)
	.i CFActiveFlag=flag D
	..s CardNo=$p(^DHCCARD("CF",CFRowID),"^",2)
	..;^PAPER({PAPMI_RowId})PAPMIMobPhone
	..s PAPMIRowId=$p(^DHCCARD("CF",CFRowID),"^",4)
	..s PhoneNo=$p(^PAPER(PAPMIRowId,"PER",1),"^",11)
	Q $g(CardNo)_"^"_$G(PhoneNo)_"^"_$g(PAPMIRowId)
}

Query PatientCardQuerySort(Name As %String = "", IDCardNo As %String = "", CardNo As %String = "", CardStatus As %String = "", CardTypeID As %String = "", SupportFlag As %String, CredNo As %String = "", UseStatus As %String = "", BirthDay As %String, Telphone As %String, OutMedicareNo As %String, InMedicareNo As %String, RegNo As %String, NewInMedicareNo As %String, InsuranceNo As %String, EmMedicare As %String) As websys.Query(ROWSPEC = "Name:%String,IDCardNo:%String,CardNO:%String,ActivedFlag:%String,CardID:%String,CardTypeDesc:%String,CredNo:%String,CredTypeDesc:%String,myOtherStr:%String,TPoliticalLevel:%String,TSecretLevel:%String,TPatientId:%String,TBalance:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocIPBookingCtl","QueryBookByDateLocExport","2020-10-12","2020-10-12","","","","",10209,2,"")
ClassMethod PatientCardQuerySortExecute(ByRef qHandle As %Library.Binary, Name As %String = "", IDCardNo As %String = "", CardNo As %String = "", CardStatus As %String = "", CardTypeID As %String = "", SupportFlag As %String, CredNo As %String = "", UseStatus As %String = "", BirthDay As %String, Telphone As %String, OutMedicareNo As %String, InMedicareNo As %String, RegNo As %String, NewInMedicareNo As %String, InsuranceNo As %String, EmMedicare As %String) As %Library.Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	k ^tmp("PatientCardQuerySort",$J)
	//"web.DHCBL.CARD.CardManager","PatientCardQuery"
	s rset=##class(%ResultSet).%New("web.DHCBL.CARD.CardManager:PatientCardQuery")
	d rset.Execute(Name, IDCardNo, CardNo, CardStatus, CardTypeID, SupportFlag, CredNo, UseStatus, BirthDay, Telphone, OutMedicareNo, InMedicareNo, RegNo, NewInMedicareNo, InsuranceNo, EmMedicare)
	While (rset.Next()) {
		s Name=rset.Data("Name")
		s IDCardNo=rset.Data("IDCardNo")
		s CardNO=rset.Data("CardNO")
		s ActivedFlag=rset.Data("ActivedFlag")
		s CardID=rset.Data("CardID")
		s CardTypeDesc=rset.Data("CardTypeDesc")
		s CredNo=rset.Data("CredNo")
		s CredTypeDesc=rset.Data("CredTypeDesc")
		s myOtherStr=rset.Data("myOtherStr")
		s TPoliticalLevel=rset.Data("TPoliticalLevel")
		s TSecretLevel=rset.Data("TSecretLevel")
		s TPatientId=rset.Data("TPatientId")
		s TBalance=rset.Data("TBalance")
		s SortFlag="2"
		if (ActivedFlag="正常") s SortFlag="1"
		s OutputList=$lb(Name,IDCardNo,CardNO,ActivedFlag,CardID,CardTypeDesc,CredNo,CredTypeDesc,myOtherStr,TPoliticalLevel,TSecretLevel,TPatientId,TBalance)
		s ^tmp("PatientCardQuerySort",$J,SortFlag,CardNO)=OutputList
		//d OutputRow14
	}
	s SortFlag=0
	f  s SortFlag=$O(^tmp("PatientCardQuerySort",$J,SortFlag)) q:SortFlag=""  d
	.s CardNO=""
	.f  s CardNO=$O(^tmp("PatientCardQuerySort",$J,SortFlag,CardNO)) q:CardNO=""  d
	..s Data=^tmp("PatientCardQuerySort",$J,SortFlag,CardNO)
	..d OutputRowSort
	k ^tmp("PatientCardQuerySort",$J)
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRowSort
	//set Data=OutputList
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

}
