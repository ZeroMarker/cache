Class web.DHCCardSearch Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
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

	If (SupportFlag="L")
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
		If (exchangeFlag="Y")
		{
			Quit 1
		}else
		{
			Quit -1
		}
	}
	If (SupportFlag="F")
	{
		If (fillFlag="Y")
		{
			Quit 1
		}else
		{
			Quit -1
		}
	}
	If (SupportFlag="B")
	{
		If (backFlag="Y")
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

// d ##class(%ResultSet).RunQuery("web.DHCCardSearch","PatientCardQuery","","","","","","","","","","","","","","","^Unite","^2^0000002117^0")

ClassMethod PatientCardQueryExecute(ByRef qHandle As %Binary, Name As %String, IDCardNo As %String, CardNo As %String, CardStatus As %String, CardTypeID As %String, SupportFlag As %String, CredNo As %String, UseStatus As %String, BirthDay As %String, Telphone As %String, OutMedicareNo As %String, InMedicareNo As %String, NewOutMedicareNo As %String, InsuranceNo As %String, EmMedicare As %String, ExpStr As %String = "") As %Status
{
	//NewInMedicareNo As %String,
	s NewInMedicareNo=""
	s ^DHCXPTest("Input1")=$LB(Name, IDCardNo, CardNo, CardStatus, CardTypeID, SupportFlag, CredNo, UseStatus, BirthDay, Telphone, OutMedicareNo, InMedicareNo, NewOutMedicareNo, InsuranceNo, EmMedicare, ExpStr)
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	Set HospitalCode=##class(web.DHCDocOrderCommon).GetCurrentHospitalCode()
    s ^tempztwa("PatientCardQueryExecute")=$lb(Name , IDCardNo , CardNo , CardStatus , CardTypeID , SupportFlag , CredNo , UseStatus , BirthDay , Telphone , OutMedicareNo , InMedicareNo , NewOutMedicareNo , NewInMedicareNo , InsuranceNo , EmMedicare)
 	;lxz  默认走公共查询方法，有需要时可按照医院代码控制
 	s HospitalCode=""
 	s LogonHospId=$P(ExpStr,"^",5)
	s LogonHospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(LogonHospId)
 	s Job=$J
 	k ^TempDHCCardSerarch(Job,"CardSearch")
 	i CardStatus="" s CardStatus="N^R"
 	e  s CardStatus="N^S^R^D^UA"
	//s CardStatus="N"
	//s SupportFlag="L"
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
	
	i qBirthDay'=""{
		s qBirthDay=..%ZDH(qBirthDay)
		//s:$L(qBirthDay,"-")>1 qBirthDay=$zdh(qBirthDay,3)
		//s:$L(qBirthDay,"/")>1 qBirthDay=$zdh(qBirthDay,4)
	}
	s qOutMedicareNo=OutMedicareNo
	s qInMedicareNo=InMedicareNo
	s cardunite=""
	if (ExpStr=""){
		s qEmployeeNo=%request.Get("EmployeeNo") ;得到工号
	    s qHospital=%request.Get("Hospital") ;得到本院状态
		s qPatientNo=%request.Get("PatientNo")
	}else{
		s qEmployeeNo=$p(ExpStr,"^",1)
	    s qHospital=$p(ExpStr,"^",2)
		s qPatientNo=$p(ExpStr,"^",3)
		s cardunite=$p(ExpStr,"^",4)
	}
	s qNewOutMedicareNo=NewOutMedicareNo
	s qNewInMedicareNo=NewInMedicareNo
	s qInsuranceNo=InsuranceNo
	s SearchSource=$P(EmMedicare,"^",2) ;为了卡合并界面同一个ID显示一条消息,同时不影响别的地方查询
	//i SearchSource="Unite" s CardStatus="N"
	s EmMedicare=$P(EmMedicare,"^",1)
	S qEmMedicare=$G(EmMedicare)
	

	s myCredNo=""						;初始化输出证件号
	s myCredTypeDesc=""					;初始化输出证件类型
 //1*******************按卡号查询
	s RowId=""
	if (qCardNo'="")
	{
		s RowId=$o(^DHCCARDi("CF",0,"CardNo",CardNo,RowId))
		while(RowId'="")
		{
			s status=$p(^DHCCARD("CF",RowId),"^",10)
			s CSCSub=$o(^DHCCARD("CF",RowId,"CSC",0))
			s CSCHospId=$p(^DHCCARD("CF",RowId,"CSC",CSCSub),"^",18)
			if (qHospital="on")&&(CSCHospId'=LogonHospId) s RowId=$o(^DHCCARDi("CF",0,"CardNo",CardNo,RowId)) continue
			s:status="" status="N"
			if ((qUseStatus="N") || (("^"_CardStatus_"^")[("^"_status_"^"))) 
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
				set CFType=$P(^DHCCARD("CF",RowId),"^",16)
				//判断卡类型是否给该院区授权
				s HosFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_CardTypeDef",CFType,LogonHospId,+$H)
				q:HosFlag'="Y"
				s Name=$p(^PAPER(PersonRowId,"ALL"),"^",1)
				s EmployeeNo=$P($G(^PAPER(PersonRowId,"EMP")),"^",5) ;加入工号查询项。李相宗，2011-08-03.
				s IDCardNo= $p(^PAPER(PersonRowId,"ALL"),"^",9)

				s cardtype=""
				if ($g(^DHCCARD("CF",RowId))'="") s cardtype=$p($g(^DHCCARD("CF",RowId)),"^",16)
				if (CardTypeID="" ||(CardTypeID=cardtype)){
	 				if (..IsSupportCardType(mySupportFlag,cardtype)=1)||(SearchSource="Unite"){
		 				s myCredStr=$g(^PAPER(PersonRowId,"ALL"))
		 				if (myCredStr'=""){
			 				do PatInfo(PersonRowId)
		 				}
		 				s CardTypeDesc=$p($g(^DHCCARDTYPEDef(cardtype)),"^",2)
		 				i ##class(web.DHCPATCardUnite).PatMasActive(PersonRowId)'="N" d
		 				.q:$D(^TempDHCCardSerarch(Job,"CardSearch",PersonRowId))
		 				.s:SearchSource="Unite" ^TempDHCCardSerarch(Job,"CardSearch",PersonRowId)=""
		 				.s:SearchSource="Unite" CardNO=##class(web.DHCPATCardUnite).GetCardNoInfo(PersonRowId)
		 				.q:(($p(^DHCCARD("CF",RowId),"^",29)="Y")&&(cardunite=1))
		 				.q:$$PatInfoCheck()="Y"
		 				.b ;
		 				.set Data=$ListBuild(Name,EmployeeNo,IDCardNo,CardNO,ActivedFlag,ID,CardTypeDesc,myCredNo,myCredTypeDesc,myOtherStr,PersonRowId,$G(TCreateDate),$G(TCreateUser),TPoliticalLevel,TSecretLevel,myTelH,myBirthDay,myAddress,myCompany,mySexDesc,myPatType,myPapmiNo,myInMedicareNo,myOutMedicareNo,myNewOutMedicareNo,myNewInMedicareNo,myEmMedicareNo,UnionNo,IsInHos,HaveRegNum,NeedAppNum,NeedRegNum,InHosNum)
						.s PAPMIDOB=$p(^PAPER(PersonRowId,"ALL"),"^",6)
						.s ind1=100000+ind
						.s Tind=PAPMIDOB_ind1
						.Set ^CacheTemp(repid,Tind)=Data
		 				.Set ind=ind+1
	 				}
				}
			}
			s RowId=$o(^DHCCARDi("CF",0,"CardNo",CardNo,RowId))
		}
		k ^TempDHCCardSerarch(Job,"CardSearch")
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
            //if HospitalCode="BJDTYY" {
	       
            if (RowId="")
             {
		            s Name=$p(^PAPER(PersonRowId,"ALL"),"^",1)
		            s EmployeeNo=$P($G(^PAPER(PersonRowId,"EMP")),"^",5) ;加入工号查询项。李相宗，2011-08-03.
		            s IDCardNo= $p(^PAPER(PersonRowId,"ALL"),"^",9)
		            s cardtype=""
		            s CardTypeDesc=""
		            s myCredStr=$g(^PAPER(PersonRowId,"ALL"))
		 			if (myCredStr'=""){
			 			do PatInfo(PersonRowId)
		 			}
	 				i ##class(web.DHCPATCardUnite).PatMasActive(PersonRowId)'="N" d
	 				.q:$D(^TempDHCCardSerarch(Job,"CardSearch",PersonRowId))
	 				.s:SearchSource="Unite" ^TempDHCCardSerarch(Job,"CardSearch",PersonRowId)=""
	 				.s:SearchSource="Unite" CardNO=##class(web.DHCPATCardUnite).GetCardNoInfo(PersonRowId)
	 				.q:$$PatInfoCheck()="Y"
	 				.set Data=$ListBuild(Name,EmployeeNo,IDCardNo,CardNO,ActivedFlag,ID,CardTypeDesc,myCredNo,myCredTypeDesc,myOtherStr,PersonRowId,$G(TCreateDate),$G(TCreateUser),TPoliticalLevel,TSecretLevel,myTelH,myBirthDay,myAddress,myCompany,mySexDesc,myPatType,myPapmiNo,myInMedicareNo,myOutMedicareNo,myNewOutMedicareNo,myNewInMedicareNo,myEmMedicareNo,UnionNo,IsInHos,HaveRegNum,NeedAppNum,NeedRegNum,InHosNum)
					.s PAPMIDOB=$p(^PAPER(PersonRowId,"ALL"),"^",6)
					.s ind1=100000+ind
					.s Tind=PAPMIDOB_ind1
					.Set ^CacheTemp(repid,Tind)=Data
	 				.Set ind=ind+1
             }
            
			while(RowId'="")
			{
				s status=$p(^DHCCARD("CF",RowId),"^",10)
				s CSCSub=$o(^DHCCARD("CF",RowId,"CSC",0))
				set CFType=$P(^DHCCARD("CF",RowId),"^",16)
				//判断卡类型是否给该院区授权
				s HosFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_CardTypeDef",CFType,LogonHospId,+$H)
				if HosFlag'="Y" s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId)) continue
				s CSCHospId=$p(^DHCCARD("CF",RowId,"CSC",CSCSub),"^",18)
				if (qHospital="on")&&(CSCHospId'=LogonHospId) s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId)) continue
				s:status="" status="N"
				if ((qUseStatus="N") || (("^"_CardStatus_"^")[("^"_status_"^")))
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
					 s EmployeeNo=$P($G(^PAPER(PersonRowId,"EMP")),"^",5) ;加入工号查询项。李相宗，2011-08-03.
					 s IDCardNo= $p(^PAPER(PersonRowId,"ALL"),"^",9)
					 s cardtype=""
					 s CardTypeDesc=""
					 if ($g(^DHCCARD("CF",RowId))'="") s cardtype=$p($g(^DHCCARD("CF",RowId)),"^",16)
					 s:cardtype'="" CardTypeDesc=$p($g(^DHCCARDTYPEDef(cardtype)),"^",2)
                     if (..IsSupportCardType(mySupportFlag,cardtype)=1)||(SearchSource="Unite")
	 				 {
		 				s myCredStr=$g(^PAPER(PersonRowId,"ALL"))
		 				if (myCredStr'=""){
			 				do PatInfo(PersonRowId)
		 				}
	 					i ##class(web.DHCPATCardUnite).PatMasActive(PersonRowId)'="N" d
		 				.q:$D(^TempDHCCardSerarch(Job,"CardSearch",PersonRowId))
		 				.s:SearchSource="Unite" ^TempDHCCardSerarch(Job,"CardSearch",PersonRowId)=""
		 				.s:SearchSource="Unite" CardNO=##class(web.DHCPATCardUnite).GetCardNoInfo(PersonRowId)
		 				.q:(($p(^DHCCARD("CF",RowId),"^",29)="Y")&&(cardunite=1))
		 				.q:$$PatInfoCheck()="Y"
		 				.set Data=$ListBuild(Name,EmployeeNo,IDCardNo,CardNO,ActivedFlag,ID,CardTypeDesc,myCredNo,myCredTypeDesc,myOtherStr,PersonRowId,$G(TCreateDate),$G(TCreateUser),TPoliticalLevel,TSecretLevel,myTelH,myBirthDay,myAddress,myCompany,mySexDesc,myPatType,myPapmiNo,myInMedicareNo,myOutMedicareNo,myNewOutMedicareNo,myNewInMedicareNo,myEmMedicareNo,UnionNo,IsInHos,HaveRegNum,NeedAppNum,NeedRegNum,InHosNum)
						.s PAPMIDOB=$p(^PAPER(PersonRowId,"ALL"),"^",6)
						.s ind1=100000+ind
						.s Tind=PAPMIDOB_ind1
						.Set ^CacheTemp(repid,Tind)=Data
		 				.Set ind=ind+1
	 				}
				}
				s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId))
			}
			s PersonRowId=$o(^PAPERi("PAPMI_ICPPBC",IDCardNo_"Z",PersonRowId))
		}
		k ^TempDHCCardSerarch(Job,"CardSearch")
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
 //********************通过登记号查找
 if (qPatientNo'=""){
	 s PersonRowId=""
		s PersonRowId=$o(^PAPERi("PAPMI_PatNo",qPatientNo,PersonRowId))
	
		while(PersonRowId'="")
		{
			s RowId=""
			s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId))
			
            if (RowId="")
             {
	             s Name=$p(^PAPER(PersonRowId,"ALL"),"^",1)
	             s EmployeeNo=$P($G(^PAPER(PersonRowId,"EMP")),"^",5) ;加入工号查询项。李相宗，2011-08-03.
	             s IDCardNo= $p(^PAPER(PersonRowId,"ALL"),"^",9)
	             s cardtype=""
	             s CardTypeDesc=""
	             s myCredStr=$g(^PAPER(PersonRowId,"ALL"))
		 		 if (myCredStr'=""){
			 		do PatInfo(PersonRowId)
		 		 }
	 			 i ##class(web.DHCPATCardUnite).PatMasActive(PersonRowId)'="N" d
 				.q:$D(^TempDHCCardSerarch(Job,"CardSearch",PersonRowId))
 				.s:SearchSource="Unite" ^TempDHCCardSerarch(Job,"CardSearch",PersonRowId)=""
 				.s:SearchSource="Unite" CardNO=##class(web.DHCPATCardUnite).GetCardNoInfo(PersonRowId)
 				.q:$$PatInfoCheck()="Y"
 				.set Data=$ListBuild(Name,EmployeeNo,IDCardNo,CardNO,ActivedFlag,ID,CardTypeDesc,myCredNo,myCredTypeDesc,myOtherStr,PersonRowId,$G(TCreateDate),$G(TCreateUser),TPoliticalLevel,TSecretLevel,myTelH,myBirthDay,myAddress,myCompany,mySexDesc,myPatType,myPapmiNo,myInMedicareNo,myOutMedicareNo,myNewOutMedicareNo,myNewInMedicareNo,myEmMedicareNo,UnionNo,IsInHos,HaveRegNum,NeedAppNum,NeedRegNum,InHosNum)
				.s PAPMIDOB=$p(^PAPER(PersonRowId,"ALL"),"^",6)
				.s ind1=100000+ind
				.s Tind=PAPMIDOB_ind1
				.Set ^CacheTemp(repid,Tind)=Data
 				.Set ind=ind+1
             }
            
			while (RowId'="")
			{  
				s status=$p(^DHCCARD("CF",RowId),"^",10)
				s CSCSub=$o(^DHCCARD("CF",RowId,"CSC",0))
				set CFType=$P(^DHCCARD("CF",RowId),"^",16)
				//判断卡类型是否给该院区授权
				s HosFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_CardTypeDef",CFType,LogonHospId,+$H)
				
				if HosFlag'="Y" s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId)) continue
				s CSCHospId=$p(^DHCCARD("CF",RowId,"CSC",CSCSub),"^",18)
				if (qHospital="on")&&(CSCHospId'=LogonHospId) s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId)) continue
				s:status="" status="N"
				if ((qUseStatus="N") || (("^"_CardStatus_"^")[("^"_status_"^")))
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
					 s EmployeeNo=$P($G(^PAPER(PersonRowId,"EMP")),"^",5) ;加入工号查询项。李相宗，2011-08-03.
					 s IDCardNo= $p(^PAPER(PersonRowId,"ALL"),"^",9)
					 s cardtype=""
					 s CardTypeDesc=""
					 if ($g(^DHCCARD("CF",RowId))'="") s cardtype=$p($g(^DHCCARD("CF",RowId)),"^",16)
					 s:cardtype'="" CardTypeDesc=$p($g(^DHCCARDTYPEDef(cardtype)),"^",2)
					 s CredNo=qCredNo
					 s CredTypeID=$p(^PAPER(PersonRowId,"ALL"),"^",1)
					 s CredTypeDesc=""
					 if (..IsSupportCardType(mySupportFlag,cardtype)=1)||(SearchSource="Unite")
	 				{
		 				s myCredStr=$g(^PAPER(PersonRowId,"ALL"))
		 				if (myCredStr'=""){
			 				do PatInfo(PersonRowId)
		 				}
	 					i ##class(web.DHCPATCardUnite).PatMasActive(PersonRowId)'="N" d
		 				.q:$D(^TempDHCCardSerarch(Job,"CardSearch",PersonRowId))
		 				.s:SearchSource="Unite" ^TempDHCCardSerarch(Job,"CardSearch",PersonRowId)=""
		 				.s:SearchSource="Unite" CardNO=##class(web.DHCPATCardUnite).GetCardNoInfo(PersonRowId)
		 				.q:(($p(^DHCCARD("CF",RowId),"^",29)="Y")&&(cardunite=1))
		 				.q:$$PatInfoCheck()="Y"
		 				.set Data=$ListBuild(Name,EmployeeNo,IDCardNo,CardNO,ActivedFlag,ID,CardTypeDesc,myCredNo,myCredTypeDesc,myOtherStr,PersonRowId,$G(TCreateDate),$G(TCreateUser),TPoliticalLevel,TSecretLevel,myTelH,myBirthDay,myAddress,myCompany,mySexDesc,myPatType,myPapmiNo,myInMedicareNo,myOutMedicareNo,myNewOutMedicareNo,myNewInMedicareNo,myEmMedicareNo,UnionNo,IsInHos,HaveRegNum,NeedAppNum,NeedRegNum,InHosNum)
						.s PAPMIDOB=$p(^PAPER(PersonRowId,"ALL"),"^",6)
						.s ind1=100000+ind
						.s Tind=PAPMIDOB_ind1
						.Set ^CacheTemp(repid,Tind)=Data
		 				.Set ind=ind+1
	 				}
				}
				s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId))
			}
			s PersonRowId=$o(^PAPERi("PAPMI_PatNo",qPatientNo,PersonRowId))
		}
		k ^TempDHCCardSerarch(Job,"CardSearch")
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
			
            if (RowId="")
             {
	             s Name=$p(^PAPER(PersonRowId,"ALL"),"^",1)
	             s EmployeeNo=$P($G(^PAPER(PersonRowId,"EMP")),"^",5) ;加入工号查询项。李相宗，2011-08-03.
	             s IDCardNo= $p(^PAPER(PersonRowId,"ALL"),"^",9)
	             s cardtype=""
	             s CardTypeDesc=""
	             s myCredStr=$g(^PAPER(PersonRowId,"ALL"))
 				 if (myCredStr'=""){
	 				do PatInfo(PersonRowId)
 				 }
				 i ##class(web.DHCPATCardUnite).PatMasActive(PersonRowId)'="N" d
	 			 .q:$D(^TempDHCCardSerarch(Job,"CardSearch",PersonRowId))
	 			 .s:SearchSource="Unite" ^TempDHCCardSerarch(Job,"CardSearch",PersonRowId)=""
	 			 .s:SearchSource="Unite" CardNO=##class(web.DHCPATCardUnite).GetCardNoInfo(PersonRowId)
	 			 .q:$$PatInfoCheck()="Y"	
	 			 .set Data=$ListBuild(Name,EmployeeNo,IDCardNo,CardNO,ActivedFlag,ID,CardTypeDesc,myCredNo,myCredTypeDesc,myOtherStr,PersonRowId,$G(TCreateDate),$G(TCreateUser),TPoliticalLevel,TSecretLevel,myTelH,myBirthDay,myAddress,myCompany,mySexDesc,myPatType,myPapmiNo,myInMedicareNo,myOutMedicareNo,myNewOutMedicareNo,myNewInMedicareNo,myEmMedicareNo,UnionNo,IsInHos,HaveRegNum,NeedAppNum,NeedRegNum,InHosNum)
				 .s PAPMIDOB=$p(^PAPER(PersonRowId,"ALL"),"^",6)
				 .s ind1=100000+ind
				 .s Tind=PAPMIDOB_ind1
				 .Set ^CacheTemp(repid,Tind)=Data
	 			 .Set ind=ind+1
             }
            
			while(RowId'="")
			{
				s status=$p(^DHCCARD("CF",RowId),"^",10)
				s CSCSub=$o(^DHCCARD("CF",RowId,"CSC",0))
				set CFType=$P(^DHCCARD("CF",RowId),"^",16)
				//判断卡类型是否给该院区授权
				s HosFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_CardTypeDef",CFType,LogonHospId,+$H)
				if HosFlag'="Y" s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId)) continue
				s CSCHospId=$p(^DHCCARD("CF",RowId,"CSC",CSCSub),"^",18)
				if (qHospital="on")&&(CSCHospId'=LogonHospId) s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId)) continue
				s:status="" status="N"
				if ((qUseStatus="N") || (("^"_CardStatus_"^")[("^"_status_"^")))
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
					 
					 s myCredNo=$p($g(^PAPER(PersonRowId,"PAT",3)),"^",6)
					 q:(qCredNo'="")&&($ZCVT(myCredNo,"U")'=qCredNo)
					 s myName=$p(^PAPER(PersonRowId,"ALL"),"^",1)
					 q:(qName'="")&&($ZCVT(myName,"U")'[qName)
					 s myBirth=$p(^PAPER(PersonRowId,"ALL"),"^",6)
					 q:(qBirthDay'="")&&(qBirthDay'=myBirth)
 
					 s EmployeeNo=$P($G(^PAPER(PersonRowId,"EMP")),"^",5) ;加入工号查询项。李相宗，2011-08-03.
					 s IDCardNo= $p(^PAPER(PersonRowId,"ALL"),"^",9)
					 s cardtype=""
					 s CardTypeDesc=""
					 if ($g(^DHCCARD("CF",RowId))'="") s cardtype=$p($g(^DHCCARD("CF",RowId)),"^",16)
					 s:cardtype'="" CardTypeDesc=$p($g(^DHCCARDTYPEDef(cardtype)),"^",2)
					 s CredNo=qCredNo
					 s CredTypeID=$p(^PAPER(PersonRowId,"ALL"),"^",1)
					 s CredTypeDesc=""
                     if (..IsSupportCardType(mySupportFlag,cardtype)=1)||(SearchSource="Unite")
	 				{
		 				s myCredStr=$g(^PAPER(PersonRowId,"ALL"))
		 				if (myCredStr'=""){
			 				do PatInfo(PersonRowId)
		 				}
	 					i ##class(web.DHCPATCardUnite).PatMasActive(PersonRowId)'="N" d
		 				.q:$D(^TempDHCCardSerarch(Job,"CardSearch",PersonRowId))
		 				.s:SearchSource="Unite" ^TempDHCCardSerarch(Job,"CardSearch",PersonRowId)=""
		 				.s:SearchSource="Unite" CardNO=##class(web.DHCPATCardUnite).GetCardNoInfo(PersonRowId)
		 				.q:(($p(^DHCCARD("CF",RowId),"^",29)="Y")&&(cardunite=1))
		 				.q:$$PatInfoCheck()="Y"
		 				.set Data=$ListBuild(Name,EmployeeNo,IDCardNo,CardNO,ActivedFlag,ID,CardTypeDesc,myCredNo,myCredTypeDesc,myOtherStr,PersonRowId,$G(TCreateDate),$G(TCreateUser),TPoliticalLevel,TSecretLevel,myTelH,myBirthDay,myAddress,myCompany,mySexDesc,myPatType,myPapmiNo,myInMedicareNo,myOutMedicareNo,myNewOutMedicareNo,myNewInMedicareNo,myEmMedicareNo,UnionNo,IsInHos,HaveRegNum,NeedAppNum,NeedRegNum,InHosNum)
						.s PAPMIDOB=$p(^PAPER(PersonRowId,"ALL"),"^",6)
					    .s ind1=100000+ind
					    .s Tind=PAPMIDOB_ind1
					    .Set ^CacheTemp(repid,Tind)=Data
		 				.Set ind=ind+1
	 				}
				}
				s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId))
			}
			s PersonRowId=$o(^PAPERi("DVA",qCredNo,PersonRowId))
		}
		k ^TempDHCCardSerarch(Job,"CardSearch")
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
			s (CardNO,ActivedFlag)=""
			s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId))
			;w RowId,!
			//if HospitalCode="BJDTYY" {

            if (RowId="")
             {
	             s Name=$p(^PAPER(PersonRowId,"ALL"),"^",1)
	             s EmployeeNo=$P($G(^PAPER(PersonRowId,"EMP")),"^",5) ;加入工号查询项。李相宗，2011-08-03.
	             s IDCardNo= $p(^PAPER(PersonRowId,"ALL"),"^",9)
	             s cardtype=""
	             s CardTypeDesc=""
	             s myCredStr=$g(^PAPER(PersonRowId,"ALL"))
	             s myBirth=$p(^PAPER(PersonRowId,"ALL"),"^",6)
	             q:(qBirthDay'="")&&(qBirthDay'=myBirth)
		 		 if (myCredStr'=""){
			 		do PatInfo(PersonRowId)
		 		 }
	 			 i ##class(web.DHCPATCardUnite).PatMasActive(PersonRowId)'="N" d
 				.q:$D(^TempDHCCardSerarch(Job,"CardSearch",PersonRowId))
 				.s:SearchSource="Unite" ^TempDHCCardSerarch(Job,"CardSearch",PersonRowId)=""
 				.s:SearchSource="Unite" CardNO=##class(web.DHCPATCardUnite).GetCardNoInfo(PersonRowId)
 				.q:($ZCVT(Name,"U")'[NameStandard) 
 				.q:$$PatInfoCheck()="Y"
 				.set Data=$ListBuild(Name,EmployeeNo,IDCardNo,CardNO,ActivedFlag,ID,CardTypeDesc,myCredNo,myCredTypeDesc,myOtherStr,PersonRowId,$G(TCreateDate),$G(TCreateUser),TPoliticalLevel,TSecretLevel,myTelH,myBirthDay,myAddress,myCompany,mySexDesc,myPatType,myPapmiNo,myInMedicareNo,myOutMedicareNo,myNewOutMedicareNo,myNewInMedicareNo,myEmMedicareNo,UnionNo,IsInHos,HaveRegNum,NeedAppNum,NeedRegNum,InHosNum)
				.s PAPMIDOB=$p(^PAPER(PersonRowId,"ALL"),"^",6)
				.s ind1=100000+ind
				.s Tind=PAPMIDOB_ind1
				.Set ^CacheTemp(repid,Tind)=Data
 				.Set ind=ind+1
             }
            
			while(RowId'="")
			{
				s (CardNO,ActivedFlag)=""
				s status=$p(^DHCCARD("CF",RowId),"^",10)
				s CSCSub=$o(^DHCCARD("CF",RowId,"CSC",0))
				set CFType=$P(^DHCCARD("CF",RowId),"^",16)
				//判断卡类型是否给该院区授权
				s HosFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_CardTypeDef",CFType,LogonHospId,+$H)
				if HosFlag'="Y" s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId)) continue
				s CSCHospId=$p(^DHCCARD("CF",RowId,"CSC",CSCSub),"^",18)
				if (qHospital="on")&&(CSCHospId'=LogonHospId) s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId)) continue
				s:status="" status="N"

				if ((qUseStatus="N") || (("^"_CardStatus_"^")[("^"_status_"^")))
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
					 s EmployeeNo=$P($G(^PAPER(PersonRowId,"EMP")),"^",5) ;加入工号查询项。李相宗，2011-08-03.
					 s IDCardNo= $p(^PAPER(PersonRowId,"ALL"),"^",9)
					 s cardtype=""
					 s CardTypeDesc=""
					 if ($g(^DHCCARD("CF",RowId))'="") s cardtype=$p($g(^DHCCARD("CF",RowId)),"^",16)
					 s:cardtype'="" CardTypeDesc=$p($g(^DHCCARDTYPEDef(cardtype)),"^",2)
					 if (..IsSupportCardType(mySupportFlag,cardtype)=1)||(SearchSource="Unite")
	 				{
		 				s myCredStr=$g(^PAPER(PersonRowId,"ALL"))
		 				s myBirth=$p(^PAPER(PersonRowId,"ALL"),"^",6)
	                    q:(qBirthDay'="")&&(qBirthDay'=myBirth)
		 				if (myCredStr'=""){
			 				do PatInfo(PersonRowId)
		 				}
		 				//if ($zd(qBirthDay,3)'=myBirthDay)&(BirthDay'="") q

	 					i ##class(web.DHCPATCardUnite).PatMasActive(PersonRowId)'="N" d
		 				.q:$D(^TempDHCCardSerarch(Job,"CardSearch",PersonRowId))
		 				.s:SearchSource="Unite" ^TempDHCCardSerarch(Job,"CardSearch",PersonRowId)=""
		 				.s:SearchSource="Unite" CardNO=##class(web.DHCPATCardUnite).GetCardNoInfo(PersonRowId)
		 				.q:(($p(^DHCCARD("CF",RowId),"^",29)="Y")&&(cardunite=1))
		 				.s Name2=$p(^PAPER(PersonRowId,"ALL"),"^",2)
		 				.s Name3=$p(^PAPER(PersonRowId,"ALL"),"^",19)
		 				.q:$$PatInfoCheck()="Y"
		 				.q:($ZCVT(Name,"U")'[NameStandard)&&($ZCVT(Name2,"U")'[NameStandard)&&($ZCVT(Name3,"U")'[NameStandard)
		 				.set Data=$ListBuild(Name,EmployeeNo,IDCardNo,CardNO,ActivedFlag,ID,CardTypeDesc,myCredNo,myCredTypeDesc,myOtherStr,PersonRowId,$G(TCreateDate),$G(TCreateUser),TPoliticalLevel,TSecretLevel,myTelH,myBirthDay,myAddress,myCompany,mySexDesc,myPatType,myPapmiNo,myInMedicareNo,myOutMedicareNo,myNewOutMedicareNo,myNewInMedicareNo,myEmMedicareNo,UnionNo,IsInHos,HaveRegNum,NeedAppNum,NeedRegNum,InHosNum)
						.s PAPMIDOB=$p(^PAPER(PersonRowId,"ALL"),"^",6)
					    .s ind1=100000+ind
						.s Tind=PAPMIDOB_ind1
						.Set ^CacheTemp(repid,Tind)=Data
		 				.Set ind=ind+1
	 				}
				}
				s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId))
			}
			set PersonRowId =$o(^PAPERi("PAPER_PatName",qName,PersonRowId))
		}
		
       //4.2*******************姓名模糊查询
		Set PAPERName = $o(^PAPERi("PAPER_PatName",qName)) //模糊查询
		kill tmpPapersonArr
		while(PAPERName'="")
		{
			s CardNO=""
			if (PAPERName[NameStandard)
			{
				s tmpId=""
				s tmpId=$o(^PAPERi("PAPER_PatName",PAPERName,tmpId))
				while(tmpId'="")
				{
					s (CardNO,ActivedFlag)=""
					s PersonRowId=tmpId
					set RowId=""
					s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId))
					//if HospitalCode="BJDTYY" {
					
		            if (RowId="")
		             {
				         q:$d(PapersonArr(PersonRowId))
			             s Name=$p(^PAPER(PersonRowId,"ALL"),"^",1)
			             s EmployeeNo=$P($G(^PAPER(PersonRowId,"EMP")),"^",5) ;加入工号查询项。李相宗，2011-08-03.
			             s myBirth=$p(^PAPER(PersonRowId,"ALL"),"^",6)
						 q:(qBirthDay'="")&&(qBirthDay'=myBirth)
			             s IDCardNo= $p(^PAPER(PersonRowId,"ALL"),"^",9)
			             s cardtype=""
			             s CardTypeDesc=""
			             s myCredStr=$g(^PAPER(PersonRowId,"ALL"))
		 				 if (myCredStr'=""){
			 				do PatInfo(PersonRowId)
		 				 }
	 					 i ##class(web.DHCPATCardUnite).PatMasActive(PersonRowId)'="N" d
		 				.q:$D(^TempDHCCardSerarch(Job,"CardSearch",PersonRowId))
		 				.s:SearchSource="Unite" ^TempDHCCardSerarch(Job,"CardSearch",PersonRowId)=""
		 				.s:SearchSource="Unite" CardNO=##class(web.DHCPATCardUnite).GetCardNoInfo(PersonRowId)
		 				.
		 				.q:($ZCVT(Name,"U")'[NameStandard) 
		 				.s PapersonArr(PersonRowId)=1
		 				.q:$$PatInfoCheck()="Y"
		 				.set Data=$ListBuild(Name,EmployeeNo,IDCardNo,CardNO,ActivedFlag,ID,CardTypeDesc,myCredNo,myCredTypeDesc,myOtherStr,PersonRowId,$G(TCreateDate),$G(TCreateUser),TPoliticalLevel,TSecretLevel,myTelH,myBirthDay,myAddress,myCompany,mySexDesc,myPatType,myPapmiNo,myInMedicareNo,myOutMedicareNo,myNewOutMedicareNo,myNewInMedicareNo,myEmMedicareNo,UnionNo,IsInHos,HaveRegNum,NeedAppNum,NeedRegNum,InHosNum)
						.s PAPMIDOB=$p(^PAPER(PersonRowId,"ALL"),"^",6)
						.s ind1=100000+ind
						.s Tind=PAPMIDOB_ind1
						.Set ^CacheTemp(repid,Tind)=Data
		 				.Set ind=ind+1
		             }
		            
					while(RowId'="")
					{
						s (CardNO,ActivedFlag)=""
						s status=$p(^DHCCARD("CF",RowId),"^",10)
						s CSCSub=$o(^DHCCARD("CF",RowId,"CSC",0))
						set CFType=$P(^DHCCARD("CF",RowId),"^",16)
						//判断卡类型是否给该院区授权
						s HosFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_CardTypeDef",CFType,LogonHospId,+$H)
						if HosFlag'="Y" s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId)) continue
						s CSCHospId=$p(^DHCCARD("CF",RowId,"CSC",CSCSub),"^",18)
						if (qHospital="on")&&(CSCHospId'=LogonHospId) s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId)) continue
						s:status="" status="N"

						if ((qUseStatus="N") || (("^"_CardStatus_"^")[("^"_status_"^")))
						{
							s ID=RowId
							s CardNO=$p(^DHCCARD("CF",RowId),"^",2)
							
							s ActivedFlag=status
							i ActivedFlag="" s ActivedFlag="正常"
							i ActivedFlag="N" s ActivedFlag="正常"
	 						i ActivedFlag="S" s ActivedFlag="挂失"
	 						i ActivedFlag="D" s ActivedFlag="作废"
	 						i ActivedFlag="R" s ActivedFlag="回收"
							q:$d(PapersonArr(PersonRowId))
	 						s Name=$p(^PAPER(PersonRowId,"ALL"),"^",1)
	 						
	 						s myCredNo=$p($g(^PAPER(PersonRowId,"PAT",3)),"^",6)
							q:(qCredNo'="")&&($ZCVT(myCredNo,"U")'=qCredNo)
							s myName=$p(^PAPER(PersonRowId,"ALL"),"^",1)
							q:(qName'="")&&($ZCVT(myName,"U")'[qName)
							s myBirth=$p(^PAPER(PersonRowId,"ALL"),"^",6)
							q:(qBirthDay'="")&&(qBirthDay'=myBirth)
	
	 						s EmployeeNo=$P($G(^PAPER(PersonRowId,"EMP")),"^",5) ;加入工号查询项。李相宗，2011-08-03.
	 						s IDCardNo= $p(^PAPER(PersonRowId,"ALL"),"^",9)
	 						s cardtype=""
	 						s CardTypeDesc=""
	 						if ($g(^DHCCARD("CF",RowId))'="") s cardtype=$p($g(^DHCCARD("CF",RowId)),"^",16)
	 						s:cardtype'="" CardTypeDesc=$p($g(^DHCCARDTYPEDef(cardtype)),"^",2)
	 						if (..IsSupportCardType(mySupportFlag,cardtype)=1)||(SearchSource="Unite")
			 				{
				 				s myCredStr=$g(^PAPER(PersonRowId,"ALL"))
				 				if (myCredStr'=""){
					 				do PatInfo(PersonRowId)
				 				}
				 				//if ($zd(qBirthDay,3)'=myBirthDay)&(BirthDay'="") q
		 						i ##class(web.DHCPATCardUnite).PatMasActive(PersonRowId)'="N" d
				 				.q:$D(^TempDHCCardSerarch(Job,"CardSearch",PersonRowId))
				 				.s:SearchSource="Unite" ^TempDHCCardSerarch(Job,"CardSearch",PersonRowId)=""
				 				.s:SearchSource="Unite" CardNO=##class(web.DHCPATCardUnite).GetCardNoInfo(PersonRowId)
		 				        .q:(($p(^DHCCARD("CF",RowId),"^",29)="Y")&&(cardunite=1))
		 				        .q:($ZCVT(Name,"U")'[NameStandard) 
		 				        .s PapersonArr(PersonRowId)=1
		 				        .q:$$PatInfoCheck()="Y"
				 				.set Data=$ListBuild(Name,EmployeeNo,IDCardNo,CardNO,ActivedFlag,ID,CardTypeDesc,myCredNo,myCredTypeDesc,myOtherStr,PersonRowId,$G(TCreateDate),$G(TCreateUser),TPoliticalLevel,TSecretLevel,myTelH,myBirthDay,myAddress,myCompany,mySexDesc,myPatType,myPapmiNo,myInMedicareNo,myOutMedicareNo,myNewOutMedicareNo,myNewInMedicareNo,myEmMedicareNo,UnionNo,IsInHos,HaveRegNum,NeedAppNum,NeedRegNum,InHosNum)
								.s PAPMIDOB=$p(^PAPER(PersonRowId,"ALL"),"^",6)
								.s ind1=100000+ind
								.s Tind=PAPMIDOB_ind1
								.Set ^CacheTemp(repid,Tind)=Data
				 				.Set ind=ind+1
			 				}
						}
						s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId))
					}
					s tmpId=$o(^PAPERi("PAPER_PatName",PAPERName,tmpId))
				}
					
			}
			Set PAPERName = $o(^PAPERi("PAPER_PatName",PAPERName)) 
		}
	kill tmpPapersonArr
	k ^TempDHCCardSerarch(Job,"CardSearch")
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
			//if HospitalCode="BJDTYY" {
			
            if (RowId="")
             {
	             s Name=$p(^PAPER(PersonRowId,"ALL"),"^",1)
	             s EmployeeNo=$P($G(^PAPER(PersonRowId,"EMP")),"^",5) ;加入工号查询项。李相宗，2011-08-03.
	             s IDCardNo= $p(^PAPER(PersonRowId,"ALL"),"^",9)
	             s cardtype=""
	             s CardTypeDesc=""
	             s myCredStr=$g(^PAPER(PersonRowId,"ALL"))
 				if (myCredStr'=""){
	 				do PatInfo(PersonRowId)
 				}
				i ##class(web.DHCPATCardUnite).PatMasActive(PersonRowId)'="N" d
 				.q:$D(^TempDHCCardSerarch(Job,"CardSearch",PersonRowId))
 				.s:SearchSource="Unite" ^TempDHCCardSerarch(Job,"CardSearch",PersonRowId)=""
 				.s:SearchSource="Unite" CardNO=##class(web.DHCPATCardUnite).GetCardNoInfo(PersonRowId)
 				.q:$$PatInfoCheck()="Y"
 				.set Data=$ListBuild(Name,EmployeeNo,IDCardNo,CardNO,ActivedFlag,ID,CardTypeDesc,myCredNo,myCredTypeDesc,myOtherStr,PersonRowId,$G(TCreateDate),$G(TCreateUser),TPoliticalLevel,TSecretLevel,myTelH,myBirthDay,myAddress,myCompany,mySexDesc,myPatType,myPapmiNo,myInMedicareNo,myOutMedicareNo,myNewOutMedicareNo,myNewInMedicareNo,myEmMedicareNo,UnionNo,IsInHos,HaveRegNum,NeedAppNum,NeedRegNum,InHosNum)
				.s PAPMIDOB=$p(^PAPER(PersonRowId,"ALL"),"^",6)
				.s ind1=100000+ind
				.s Tind=PAPMIDOB_ind1
				.Set ^CacheTemp(repid,Tind)=Data
 				.Set ind=ind+1
             }
            
			while(RowId'="")
			{
				s status=$p(^DHCCARD("CF",RowId),"^",10)
				s CSCSub=$o(^DHCCARD("CF",RowId,"CSC",0))
				set CFType=$P(^DHCCARD("CF",RowId),"^",16)
				//判断卡类型是否给该院区授权
				s HosFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_CardTypeDef",CFType,LogonHospId,+$H)
				if HosFlag'="Y" s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId)) continue
				s CSCHospId=$p(^DHCCARD("CF",RowId,"CSC",CSCSub),"^",18)
				if (qHospital="on")&&(CSCHospId'=LogonHospId) s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId)) continue
				s:status="" status="N"

				if ((qUseStatus="N") || (("^"_CardStatus_"^")[("^"_status_"^")))
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
					 s EmployeeNo=$P($G(^PAPER(PersonRowId,"EMP")),"^",5) ;加入工号查询项。李相宗，2011-08-03.
					 s IDCardNo= $p(^PAPER(PersonRowId,"ALL"),"^",9)
					 s cardtype=""
					 s CardTypeDesc=""
					 if ($g(^DHCCARD("CF",RowId))'="") s cardtype=$p($g(^DHCCARD("CF",RowId)),"^",16)
					 s:cardtype'="" CardTypeDesc=$p($g(^DHCCARDTYPEDef(cardtype)),"^",2)
					 if (..IsSupportCardType(mySupportFlag,cardtype)=1)||(SearchSource="Unite")
					 {
		 				s myCredStr=$g(^PAPER(PersonRowId,"ALL"))
		 				if (myCredStr'=""){
			 				do PatInfo(PersonRowId)
		 				}
	 					i ##class(web.DHCPATCardUnite).PatMasActive(PersonRowId)'="N" d
		 				.q:$D(^TempDHCCardSerarch(Job,"CardSearch",PersonRowId))
		 				.s:SearchSource="Unite" ^TempDHCCardSerarch(Job,"CardSearch",PersonRowId)=""
		 				.s:SearchSource="Unite" CardNO=##class(web.DHCPATCardUnite).GetCardNoInfo(PersonRowId)
		 				.q:(($p(^DHCCARD("CF",RowId),"^",29)="Y")&&(cardunite=1))
		 				.q:$$PatInfoCheck()="Y"
		 				.set Data=$ListBuild(Name,EmployeeNo,IDCardNo,CardNO,ActivedFlag,ID,CardTypeDesc,myCredNo,myCredTypeDesc,myOtherStr,PersonRowId,$G(TCreateDate),$G(TCreateUser),TPoliticalLevel,TSecretLevel,myTelH,myBirthDay,myAddress,myCompany,mySexDesc,myPatType,myPapmiNo,myInMedicareNo,myOutMedicareNo,myNewOutMedicareNo,myNewInMedicareNo,myEmMedicareNo,UnionNo,IsInHos,HaveRegNum,NeedAppNum,NeedRegNum,InHosNum)
						.s PAPMIDOB=$p(^PAPER(PersonRowId,"ALL"),"^",6)
					    .s ind1=100000+ind
					    .s Tind=PAPMIDOB_ind1
					    .Set ^CacheTemp(repid,Tind)=Data
		 				.Set ind=ind+1
	 				}

				}
				s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId))
			}
				set PersonRowId =$o(^PAPERi("Phone",qTelphoneNo,PersonRowId))
		}
		k ^TempDHCCardSerarch(Job,"CardSearch")
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	if (qBirthDay'="")
	{
	//*****************按出生日期查询
		set PersonRowId =$o(^PAPERi("DOB2",qBirthDay,0))
		while (PersonRowId'="")
		{
			do ReSetVar
			set RowId=""
			s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId))
			//if HospitalCode="BJDTYY" {
			
            if (RowId="")
             {
	             s Name=$p(^PAPER(PersonRowId,"ALL"),"^",1)
	             s myCredNo=$p($g(^PAPER(PersonRowId,"PAT",3)),"^",6)
				 q:(qCredNo'="")&&($ZCVT(myCredNo,"U")'=qCredNo)
				 s myName=$p(^PAPER(PersonRowId,"ALL"),"^",1)
				 q:(qName'="")&&($ZCVT(myName,"U")'[qName)
				 s myBirth=$p(^PAPER(PersonRowId,"ALL"),"^",6)
				 q:(qBirthDay'="")&&(qBirthDay'=myBirth)
	             s EmployeeNo=$P($G(^PAPER(PersonRowId,"EMP")),"^",5) ;加入工号查询项。李相宗，2011-08-03.
	             s IDCardNo= $p(^PAPER(PersonRowId,"ALL"),"^",9)
	             s cardtype=""
	             s CardTypeDesc=""
	             s myCredStr=$g(^PAPER(PersonRowId,"ALL"))
		 		 if (myCredStr'=""){
			 	    do PatInfo(PersonRowId)
		 		 }
	 			 i ##class(web.DHCPATCardUnite).PatMasActive(PersonRowId)'="N" d
 				 .q:$D(^TempDHCCardSerarch(Job,"CardSearch",PersonRowId))
 				 .s:SearchSource="Unite" ^TempDHCCardSerarch(Job,"CardSearch",PersonRowId)=""
 				 .s:SearchSource="Unite" CardNO=##class(web.DHCPATCardUnite).GetCardNoInfo(PersonRowId)
 				 .q:$$PatInfoCheck()="Y"
 				 .set Data=$ListBuild(Name,EmployeeNo,IDCardNo,CardNO,ActivedFlag,ID,CardTypeDesc,myCredNo,myCredTypeDesc,myOtherStr,PersonRowId,$G(TCreateDate),$G(TCreateUser),TPoliticalLevel,TSecretLevel,myTelH,myBirthDay,myAddress,myCompany,mySexDesc,myPatType,myPapmiNo,myInMedicareNo,myOutMedicareNo,myNewOutMedicareNo,myNewInMedicareNo,myEmMedicareNo,UnionNo,IsInHos,HaveRegNum,NeedAppNum,NeedRegNum,InHosNum)
				 .s PAPMIDOB=$p(^PAPER(PersonRowId,"ALL"),"^",6)
				 .s ind1=100000+ind
				 .s Tind=PAPMIDOB_ind1
				 .Set ^CacheTemp(repid,Tind)=Data
 				 .Set ind=ind+1
             }
            
			while(RowId'="")
			{
				s status=$p(^DHCCARD("CF",RowId),"^",10)
				s CSCSub=$o(^DHCCARD("CF",RowId,"CSC",0))
				set CFType=$P(^DHCCARD("CF",RowId),"^",16)
				//判断卡类型是否给该院区授权
				s HosFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_CardTypeDef",CFType,LogonHospId,+$H)
				if HosFlag'="Y" s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId)) continue
				s CSCHospId=$p(^DHCCARD("CF",RowId,"CSC",CSCSub),"^",18)
				if (qHospital="on")&&(CSCHospId'=LogonHospId) s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId)) continue
				s:status="" status="N"

				if ((qUseStatus="N") || (("^"_CardStatus_"^")[("^"_status_"^")))
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
					 s EmployeeNo=$P($G(^PAPER(PersonRowId,"EMP")),"^",5) ;加入工号查询项。李相宗，2011-08-03.
					 s IDCardNo= $p(^PAPER(PersonRowId,"ALL"),"^",9)
					 s cardtype=""
					 s CardTypeDesc=""
					 if ($g(^DHCCARD("CF",RowId))'="") s cardtype=$p($g(^DHCCARD("CF",RowId)),"^",16)
					 s:cardtype'="" CardTypeDesc=$p($g(^DHCCARDTYPEDef(cardtype)),"^",2)
					 if (..IsSupportCardType(mySupportFlag,cardtype)=1)||(SearchSource="Unite")
					 {
		 				s myCredStr=$g(^PAPER(PersonRowId,"ALL"))
		 				if (myCredStr'=""){
			 				do PatInfo(PersonRowId)
		 				}
	 					i ##class(web.DHCPATCardUnite).PatMasActive(PersonRowId)'="N" d
		 				.q:$D(^TempDHCCardSerarch(Job,"CardSearch",PersonRowId))
		 				.s:SearchSource="Unite" ^TempDHCCardSerarch(Job,"CardSearch",PersonRowId)=""
		 				.s:SearchSource="Unite" CardNO=##class(web.DHCPATCardUnite).GetCardNoInfo(PersonRowId)
		 				.q:(($p(^DHCCARD("CF",RowId),"^",29)="Y")&&(cardunite=1))
		 				.q:$$PatInfoCheck()="Y"
		 				.set Data=$ListBuild(Name,EmployeeNo,IDCardNo,CardNO,ActivedFlag,ID,CardTypeDesc,myCredNo,myCredTypeDesc,myOtherStr,PersonRowId,$G(TCreateDate),$G(TCreateUser),TPoliticalLevel,TSecretLevel,myTelH,myBirthDay,myAddress,myCompany,mySexDesc,myPatType,myPapmiNo,myInMedicareNo,myOutMedicareNo,myNewOutMedicareNo,myNewInMedicareNo,myEmMedicareNo,UnionNo,IsInHos,HaveRegNum,NeedAppNum,NeedRegNum,InHosNum)
						.s PAPMIDOB=$p(^PAPER(PersonRowId,"ALL"),"^",6)
						.s ind1=100000+ind
						.s Tind=PAPMIDOB_ind1
						.Set ^CacheTemp(repid,Tind)=Data
		 				.Set ind=ind+1
	 				}

				}
				s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId))
			}
				set PersonRowId =$o(^PAPERi("DOB2",qBirthDay,PersonRowId))
		}
		k ^TempDHCCardSerarch(Job,"CardSearch")
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
			//if HospitalCode="BJDTYY" {

            if (RowId="")
             {
	             s Name=$p(^PAPER(PersonRowId,"ALL"),"^",1)
	             s EmployeeNo=$P($G(^PAPER(PersonRowId,"EMP")),"^",5) ;加入工号查询项。李相宗，2011-08-03.
	             s IDCardNo= $p(^PAPER(PersonRowId,"ALL"),"^",9)
	             s cardtype=""
	             s CardTypeDesc=""
	             s myCredStr=$g(^PAPER(PersonRowId,"ALL"))
 				if (myCredStr'=""){
	 				do PatInfo(PersonRowId)
 				}
				i ##class(web.DHCPATCardUnite).PatMasActive(PersonRowId)'="N" d
 				.q:$D(^TempDHCCardSerarch(Job,"CardSearch",PersonRowId))
 				.s:SearchSource="Unite" ^TempDHCCardSerarch(Job,"CardSearch",PersonRowId)=""
 				.s:SearchSource="Unite" CardNO=##class(web.DHCPATCardUnite).GetCardNoInfo(PersonRowId)
 				.q:$$PatInfoCheck()="Y"
 				.set Data=$ListBuild(Name,EmployeeNo,IDCardNo,CardNO,ActivedFlag,ID,CardTypeDesc,myCredNo,myCredTypeDesc,myOtherStr,PersonRowId,$G(TCreateDate),$G(TCreateUser),TPoliticalLevel,TSecretLevel,myTelH,myBirthDay,myAddress,myCompany,mySexDesc,myPatType,myPapmiNo,myInMedicareNo,myOutMedicareNo,myNewOutMedicareNo,myNewInMedicareNo,myEmMedicareNo,UnionNo,IsInHos,HaveRegNum,NeedAppNum,NeedRegNum,InHosNum)
				.s PAPMIDOB=$p(^PAPER(PersonRowId,"ALL"),"^",6)
				.s ind1=100000+ind
				.s Tind=PAPMIDOB_ind1
				.Set ^CacheTemp(repid,Tind)=Data
 				.Set ind=ind+1
             }
            
			while(RowId'="")
			{
				s status=$p(^DHCCARD("CF",RowId),"^",10)
				s CSCSub=$o(^DHCCARD("CF",RowId,"CSC",0))
				set CFType=$P(^DHCCARD("CF",RowId),"^",16)
				//判断卡类型是否给该院区授权
				s HosFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_CardTypeDef",CFType,LogonHospId,+$H)
				if HosFlag'="Y" s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId)) continue
				s CSCHospId=$p(^DHCCARD("CF",RowId,"CSC",CSCSub),"^",18)
				if (qHospital="on")&&(CSCHospId'=LogonHospId) s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId)) continue
				s:status="" status="N"

				if ((qUseStatus="N") || (("^"_CardStatus_"^")[("^"_status_"^")))
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
					 s EmployeeNo=$P($G(^PAPER(PersonRowId,"EMP")),"^",5) ;加入工号查询项。李相宗，2011-08-03.
					 s IDCardNo= $p(^PAPER(PersonRowId,"ALL"),"^",9)
					 s cardtype=""
					 s CardTypeDesc=""
					 if ($g(^DHCCARD("CF",RowId))'="") s cardtype=$p($g(^DHCCARD("CF",RowId)),"^",16)
					 s:cardtype'="" CardTypeDesc=$p($g(^DHCCARDTYPEDef(cardtype)),"^",2)
					 if (..IsSupportCardType(mySupportFlag,cardtype)=1)||(SearchSource="Unite")
					 {
		 				s myCredStr=$g(^PAPER(PersonRowId,"ALL"))
		 				if (myCredStr'=""){
			 				do PatInfo(PersonRowId)
		 				}
	 					i ##class(web.DHCPATCardUnite).PatMasActive(PersonRowId)'="N" d
		 				.q:$D(^TempDHCCardSerarch(Job,"CardSearch",PersonRowId))
		 				.s:SearchSource="Unite" ^TempDHCCardSerarch(Job,"CardSearch",PersonRowId)=""
		 				.s:SearchSource="Unite" CardNO=##class(web.DHCPATCardUnite).GetCardNoInfo(PersonRowId)
		 				.q:(($p(^DHCCARD("CF",RowId),"^",29)="Y")&&(cardunite=1))
		 				.q:$$PatInfoCheck()="Y"
		 				.set Data=$ListBuild(Name,EmployeeNo,IDCardNo,CardNO,ActivedFlag,ID,CardTypeDesc,myCredNo,myCredTypeDesc,myOtherStr,PersonRowId,$G(TCreateDate),$G(TCreateUser),TPoliticalLevel,TSecretLevel,myTelH,myBirthDay,myAddress,myCompany,mySexDesc,myPatType,myPapmiNo,myInMedicareNo,myOutMedicareNo,myNewOutMedicareNo,myNewInMedicareNo,myEmMedicareNo,UnionNo,IsInHos,HaveRegNum,NeedAppNum,NeedRegNum,InHosNum)
						.s PAPMIDOB=$p(^PAPER(PersonRowId,"ALL"),"^",6)
						.s ind1=100000+ind
						.s Tind=PAPMIDOB_ind1
						.Set ^CacheTemp(repid,Tind)=Data
		 				.Set ind=ind+1
	 				}

				}
				s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId))
			}
				set PersonRowId =$o(^PAPERi("Govern",qOutMedicareNo,PersonRowId))
		}
		k ^TempDHCCardSerarch(Job,"CardSearch")
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}

   //*******************************************按工号查询：当传入工号（qEmployeeNo）不为空时。
	
	if (qEmployeeNo'="")
        { s EmployeeNo=qEmployeeNo
           s PersonRowId=""
	       set PersonRowId=$o(^PAPERi("EmplNo",EmployeeNo,PersonRowId))
            ///set PersonRowId =$o(^PAPERi("PAPER_PatName",qInsuranceNo,0))
	       while (PersonRowId'=""){
	              do ReSetVar
	              set RowId=""
	              s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId))
	              //if HospitalCode="BJDTYY" {

                  if (RowId=""){
                         s Name=$p(^PAPER(PersonRowId,"ALL"),"^",1)
                         s IDCardNo= $p(^PAPER(PersonRowId,"ALL"),"^",9)
                         s cardtype=""
                         s CardTypeDesc=""
                         s myCredStr=$g(^PAPER(PersonRowId,"ALL"))
                         if (myCredStr'=""){
                           do PatInfo(PersonRowId)
                         }
                         i ##class(web.DHCPATCardUnite).PatMasActive(PersonRowId)'="N" d
		 				.q:$D(^TempDHCCardSerarch(Job,"CardSearch",PersonRowId))
		 				.s:SearchSource="Unite" ^TempDHCCardSerarch(Job,"CardSearch",PersonRowId)=""
		 				.s:SearchSource="Unite" CardNO=##class(web.DHCPATCardUnite).GetCardNoInfo(PersonRowId)
		 				.q:$$PatInfoCheck()="Y"
		 				.set Data=$ListBuild(Name,EmployeeNo,IDCardNo,CardNO,ActivedFlag,ID,CardTypeDesc,myCredNo,myCredTypeDesc,myOtherStr,PersonRowId,$G(TCreateDate),$G(TCreateUser),TPoliticalLevel,TSecretLevel,myTelH,myBirthDay,myAddress,myCompany,mySexDesc,myPatType,myPapmiNo,myInMedicareNo,myOutMedicareNo,myNewOutMedicareNo,myNewInMedicareNo,myEmMedicareNo,UnionNo,IsInHos,HaveRegNum,NeedAppNum,NeedRegNum,InHosNum)
						.s PAPMIDOB=$p(^PAPER(PersonRowId,"ALL"),"^",6)
						.s ind1=100000+ind
						.s Tind=PAPMIDOB_ind1
						.Set ^CacheTemp(repid,Tind)=Data
		 				.Set ind=ind+1
                   }
                  
			      while(RowId'=""){
	                 s status=$p(^DHCCARD("CF",RowId),"^",10)
	                 s CSCSub=$o(^DHCCARD("CF",RowId,"CSC",0))
					s CSCHospId=$p(^DHCCARD("CF",RowId,"CSC",CSCSub),"^",18)
					if (qHospital="on")&&(CSCHospId'=LogonHospId) s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId)) continue
	                 s:status="" status="N"

	                 if ((qUseStatus="N") || (("^"_CardStatus_"^")[("^"_status_"^"))){
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
                        if (..IsSupportCardType(mySupportFlag,cardtype)=1)||(SearchSource="Unite"){
                           	s myCredStr=$g(^PAPER(PersonRowId,"ALL"))
                 			if (myCredStr'=""){
                               do PatInfo(PersonRowId)
                          	}
                         	i ##class(web.DHCPATCardUnite).PatMasActive(PersonRowId)'="N" d
			 				.q:$D(^TempDHCCardSerarch(Job,"CardSearch",PersonRowId))
			 				.s:SearchSource="Unite" ^TempDHCCardSerarch(Job,"CardSearch",PersonRowId)=""
			 				.s:SearchSource="Unite" CardNO=##class(web.DHCPATCardUnite).GetCardNoInfo(PersonRowId)
			 				.q:(($p(^DHCCARD("CF",RowId),"^",29)="Y")&&(cardunite=1))
			 				.q:$$PatInfoCheck()="Y"
			 				.set Data=$ListBuild(Name,EmployeeNo,IDCardNo,CardNO,ActivedFlag,ID,CardTypeDesc,myCredNo,myCredTypeDesc,myOtherStr,PersonRowId,$G(TCreateDate),$G(TCreateUser),TPoliticalLevel,TSecretLevel,myTelH,myBirthDay,myAddress,myCompany,mySexDesc,myPatType,myPapmiNo,myInMedicareNo,myOutMedicareNo,myNewOutMedicareNo,myNewInMedicareNo,myEmMedicareNo,UnionNo,IsInHos,HaveRegNum,NeedAppNum,NeedRegNum,InHosNum)
							.s PAPMIDOB=$p(^PAPER(PersonRowId,"ALL"),"^",6)
							.s ind1=100000+ind
							.s Tind=PAPMIDOB_ind1
							.Set ^CacheTemp(repid,Tind)=Data
			 				.Set ind=ind+1
                        }

                    }
	                s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId))
			    }
				set PersonRowId =$o(^PAPERi("EmplNo",EmployeeNo,PersonRowId))
		}
		k ^TempDHCCardSerarch(Job,"CardSearch")
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}

   


    //******************************************按工号查询查询:当本院（Hospital）checkbox被选中，而工号EmployeeNo为空时。
  /*if (qHospital="on")
     {  s EmployeeNo=0
        s EmployeeNo=$o(^PAPERi("EmplNo",EmployeeNo))
	    while (EmployeeNo'="")
	    {
		    s PersonRowId=""
	       	set PersonRowId=$o(^PAPERi("EmplNo",EmployeeNo,PersonRowId))
			do ReSetVar
			set RowId=""
			s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId))
			if HospitalCode="BJDTYY" {
				s RowId=""
	            if (RowId=""){
		             s Name=$p(^PAPER(PersonRowId,"ALL"),"^",1)
		             s IDCardNo= $p(^PAPER(PersonRowId,"ALL"),"^",9)
		             s cardtype=""
		             s CardTypeDesc=""
		             s myCredStr=$g(^PAPER(PersonRowId,"ALL"))
	 				 if (myCredStr'=""){
		 				do PatInfo(PersonRowId)
	 				 }
 					 set Data=$ListBuild(Name,EmployeeNo,IDCardNo,CardNO,ActivedFlag,ID,CardTypeDesc,myCredNo,myCredTypeDesc,myOtherStr,PersonRowId,$G(TCreateDate),$G(TCreateUser),TPoliticalLevel,TSecretLevel,myTelH,myBirthDay,myAddress,myCompany,mySexDesc,myPatType,myPapmiNo,myInMedicareNo,myOutMedicareNo,myNewOutMedicareNo,myNewInMedicareNo,myEmMedicareNo,UnionNo,IsInHos,HaveRegNum,NeedAppNum,NeedRegNum,InHosNum)
					 Set ^CacheTemp(repid,ind)=Data
 					 Set ind=ind+1
	             }
            }
			while(RowId'="")
			{
				s status=$p(^DHCCARD("CF",RowId),"^",10)
				s CSCSub=$o(^DHCCARD("CF",RowId,"CSC",0))
				s CSCHospId=$p(^DHCCARD("CF",RowId,"CSC",CSCSub),"^",18)
				if (qHospital="on")&&(CSCHospId'=LogonHospId) s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId)) continue
				s:status="" status="N"

				if ((qUseStatus="N") || (("^"_CardStatus_"^")[("^"_status_"^")))
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
					 if (..IsSupportCardType(mySupportFlag,cardtype)=1)||(SearchSource="Unite"){
		 				s myCredStr=$g(^PAPER(PersonRowId,"ALL"))
		 				if (myCredStr'=""){
			 				do PatInfo(PersonRowId)
		 				}
	 					set Data=$ListBuild(Name,EmployeeNo,IDCardNo,CardNO,ActivedFlag,ID,CardTypeDesc,myCredNo,myCredTypeDesc,myOtherStr,PersonRowId,$G(TCreateDate),$G(TCreateUser),TPoliticalLevel,TSecretLevel,myTelH,myBirthDay,myAddress,myCompany,mySexDesc,myPatType,myPapmiNo,myInMedicareNo,myOutMedicareNo,myNewOutMedicareNo,myNewInMedicareNo,myEmMedicareNo,UnionNo,IsInHos,HaveRegNum,NeedAppNum,NeedRegNum,InHosNum)
						.s PAPMIDOB=$p(^PAPER(PersonRowId,"ALL"),"^",6)
						.s ind1=100000+ind
						.s Tind=PAPMIDOB_ind1
						.Set ^CacheTemp(repid,Tind)=Data
	 					Set ind=ind+1
	 				}

				}
				s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId))
			}
				set EmployeeNo=$o(^PAPERi("EmplNo",EmployeeNo))
	     }
	     	k ^TempDHCCardSerarch(Job,"CardSearch")
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}*/




	if (qInMedicareNo'="")
	{
	//*****************按住院病历号查询
		;set PersonRowId =$o(^PAPERi("Medicare1",qInMedicareNo,0))
		//set PersonRowId =##Class(web.DHCWMRService).IGetPatientIDByMrNo(qInMedicareNo)
		s PersonRowId=##class(MA.IPMR.IO.OutService).GetPatientIDByMrNo(qInMedicareNo,"")
		i PersonRowId["-" s PersonRowId=""
		while (PersonRowId'="")
		{
			do ReSetVar
			set RowId=""
			s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId))
			//if HospitalCode="BJDTYY" {
            if (RowId="")
             {
	             s Name=$p(^PAPER(PersonRowId,"ALL"),"^",1)
	             s EmployeeNo=$P($G(^PAPER(PersonRowId,"EMP")),"^",5) ;加入工号查询项。李相宗，2011-08-03.
	             s IDCardNo= $p(^PAPER(PersonRowId,"ALL"),"^",9)
	             s cardtype=""
	             s CardTypeDesc=""
	             s myCredStr=$g(^PAPER(PersonRowId,"ALL"))
		 		 if (myCredStr'=""){
			 		do PatInfo(PersonRowId)
		 		 }
	 			 i ##class(web.DHCPATCardUnite).PatMasActive(PersonRowId)'="N" d
 				.q:$D(^TempDHCCardSerarch(Job,"CardSearch",PersonRowId))
 				.s:SearchSource="Unite" ^TempDHCCardSerarch(Job,"CardSearch",PersonRowId)=""
 				.s:SearchSource="Unite" CardNO=##class(web.DHCPATCardUnite).GetCardNoInfo(PersonRowId)
 				.q:$$PatInfoCheck()="Y"
 				.set Data=$ListBuild(Name,EmployeeNo,IDCardNo,CardNO,ActivedFlag,ID,CardTypeDesc,myCredNo,myCredTypeDesc,myOtherStr,PersonRowId,$G(TCreateDate),$G(TCreateUser),TPoliticalLevel,TSecretLevel,myTelH,myBirthDay,myAddress,myCompany,mySexDesc,myPatType,myPapmiNo,myInMedicareNo,myOutMedicareNo,myNewOutMedicareNo,myNewInMedicareNo,myEmMedicareNo,UnionNo,IsInHos,HaveRegNum,NeedAppNum,NeedRegNum,InHosNum)
				.s PAPMIDOB=$p(^PAPER(PersonRowId,"ALL"),"^",6)
				.s ind1=100000+ind
				.s Tind=PAPMIDOB_ind1
				.Set ^CacheTemp(repid,Tind)=Data
 				.Set ind=ind+1
             }
            
			while(RowId'="")
			{
				s status=$p(^DHCCARD("CF",RowId),"^",10)
				s CSCSub=$o(^DHCCARD("CF",RowId,"CSC",0))
				set CFType=$P(^DHCCARD("CF",RowId),"^",16)
				//判断卡类型是否给该院区授权
				s HosFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_CardTypeDef",CFType,LogonHospId,+$H)
				if HosFlag'="Y" s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId)) continue
				s CSCHospId=$p(^DHCCARD("CF",RowId,"CSC",CSCSub),"^",18)
				if (qHospital="on")&&(CSCHospId'=LogonHospId) s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId)) continue
				s:status="" status="N"

				if ((qUseStatus="N") || (("^"_CardStatus_"^")[("^"_status_"^")))
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
					 s EmployeeNo=$P($G(^PAPER(PersonRowId,"EMP")),"^",5) ;加入工号查询项。李相宗，2011-08-03.
					 s IDCardNo= $p(^PAPER(PersonRowId,"ALL"),"^",9)
					 s cardtype=""
					 s CardTypeDesc=""
					 if ($g(^DHCCARD("CF",RowId))'="") s cardtype=$p($g(^DHCCARD("CF",RowId)),"^",16)
					 s:cardtype'="" CardTypeDesc=$p($g(^DHCCARDTYPEDef(cardtype)),"^",2)
					 if (..IsSupportCardType(mySupportFlag,cardtype)=1)||(SearchSource="Unite"){
		 				s myCredStr=$g(^PAPER(PersonRowId,"ALL"))
		 				if (myCredStr'=""){
			 				do PatInfo(PersonRowId)
		 				}
	 					i ##class(web.DHCPATCardUnite).PatMasActive(PersonRowId)'="N" d
		 				.q:$D(^TempDHCCardSerarch(Job,"CardSearch",PersonRowId))
		 				.s:SearchSource="Unite" ^TempDHCCardSerarch(Job,"CardSearch",PersonRowId)=""
		 				.s:SearchSource="Unite" CardNO=##class(web.DHCPATCardUnite).GetCardNoInfo(PersonRowId)
		 				.q:(($p(^DHCCARD("CF",RowId),"^",29)="Y")&&(cardunite=1))
		 				.q:$$PatInfoCheck()="Y"
		 				.set Data=$ListBuild(Name,EmployeeNo,IDCardNo,CardNO,ActivedFlag,ID,CardTypeDesc,myCredNo,myCredTypeDesc,myOtherStr,PersonRowId,$G(TCreateDate),$G(TCreateUser),TPoliticalLevel,TSecretLevel,myTelH,myBirthDay,myAddress,myCompany,mySexDesc,myPatType,myPapmiNo,myInMedicareNo,myOutMedicareNo,myNewOutMedicareNo,myNewInMedicareNo,myEmMedicareNo,UnionNo,IsInHos,HaveRegNum,NeedAppNum,NeedRegNum,InHosNum)
						.s PAPMIDOB=$p(^PAPER(PersonRowId,"ALL"),"^",6)
						.s ind1=100000+ind
						.s Tind=PAPMIDOB_ind1
						.Set ^CacheTemp(repid,Tind)=Data
		 				.Set ind=ind+1
	 				}

				}
				s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId))
			}
				set PersonRowId =$o(^PAPERi("Medicare1",qInMedicareNo,PersonRowId))
		}
		k ^TempDHCCardSerarch(Job,"CardSearch")
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
			//if HospitalCode="BJDTYY" {
			
            if (RowId="")
             {
	             s Name=$p(^PAPER(PersonRowId,"ALL"),"^",1)
	             s EmployeeNo=$P($G(^PAPER(PersonRowId,"EMP")),"^",5) ;加入工号查询项。李相宗，2011-08-03.
	             s IDCardNo= $p(^PAPER(PersonRowId,"ALL"),"^",9)
	             s cardtype=""
	             s CardTypeDesc=""
	             s myCredStr=$g(^PAPER(PersonRowId,"ALL"))
 				 if (myCredStr'=""){
	 				do PatInfo(PersonRowId)
 				 }
	 		     i ##class(web.DHCPATCardUnite).PatMasActive(PersonRowId)'="N" d
 				.q:$D(^TempDHCCardSerarch(Job,"CardSearch",PersonRowId))
 				.s:SearchSource="Unite" ^TempDHCCardSerarch(Job,"CardSearch",PersonRowId)=""
 				.s:SearchSource="Unite" CardNO=##class(web.DHCPATCardUnite).GetCardNoInfo(PersonRowId)
 				.q:$$PatInfoCheck()="Y"
 				.set Data=$ListBuild(Name,EmployeeNo,IDCardNo,CardNO,ActivedFlag,ID,CardTypeDesc,myCredNo,myCredTypeDesc,myOtherStr,PersonRowId,$G(TCreateDate),$G(TCreateUser),TPoliticalLevel,TSecretLevel,myTelH,myBirthDay,myAddress,myCompany,mySexDesc,myPatType,myPapmiNo,myInMedicareNo,myOutMedicareNo,myNewOutMedicareNo,myNewInMedicareNo,myEmMedicareNo,UnionNo,IsInHos,HaveRegNum,NeedAppNum,NeedRegNum,InHosNum)
				.s PAPMIDOB=$p(^PAPER(PersonRowId,"ALL"),"^",6)
				.s ind1=100000+ind
				.s Tind=PAPMIDOB_ind1
				.Set ^CacheTemp(repid,Tind)=Data
 				.Set ind=ind+1
             }
            
			while(RowId'="")
			{
				s status=$p(^DHCCARD("CF",RowId),"^",10)
				s CSCSub=$o(^DHCCARD("CF",RowId,"CSC",0))
				set CFType=$P(^DHCCARD("CF",RowId),"^",16)
				//判断卡类型是否给该院区授权
				s HosFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_CardTypeDef",CFType,LogonHospId,+$H)
				if HosFlag'="Y" s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PapmiRowId,RowId)) continue
				s CSCHospId=$p(^DHCCARD("CF",RowId,"CSC",CSCSub),"^",18)
				if (qHospital="on")&&(CSCHospId'=LogonHospId) s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PapmiRowId,RowId)) continue
				s:status="" status="N"

				if ((qUseStatus="N") || (("^"_CardStatus_"^")[("^"_status_"^")))
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
					s EmployeeNo=$P($G(^PAPER(PersonRowId,"EMP")),"^",5) ;加入工号查询项。李相宗，2011-08-03.
					s IDCardNo= $p(^PAPER(PapmiRowId,"ALL"),"^",9)
					s cardtype=""
					s CardTypeDesc=""
					if ($g(^DHCCARD("CF",RowId))'="") s cardtype=$p($g(^DHCCARD("CF",RowId)),"^",16)
					s:cardtype'="" CardTypeDesc=$p($g(^DHCCARDTYPEDef(cardtype)),"^",2)
					if (..IsSupportCardType(mySupportFlag,cardtype)=1)||(SearchSource="Unite"){
		 				s myCredStr=$g(^PAPER(PapmiRowId,"ALL"))
		 				if (myCredStr'=""){
			 				do PatInfo(PapmiRowId)
		 				}
	 					i ##class(web.DHCPATCardUnite).PatMasActive(PersonRowId)'="N" d
		 				.q:$D(^TempDHCCardSerarch(Job,"CardSearch",PersonRowId))
		 				.s:SearchSource="Unite" ^TempDHCCardSerarch(Job,"CardSearch",PersonRowId)=""
		 				.s:SearchSource="Unite" CardNO=##class(web.DHCPATCardUnite).GetCardNoInfo(PersonRowId)
		 				.q:(($p(^DHCCARD("CF",RowId),"^",29)="Y")&&(cardunite=1))
		 				.q:$$PatInfoCheck()="Y"
		 				.set Data=$ListBuild(Name,EmployeeNo,IDCardNo,CardNO,ActivedFlag,ID,CardTypeDesc,myCredNo,myCredTypeDesc,myOtherStr,PersonRowId,$G(TCreateDate),$G(TCreateUser),TPoliticalLevel,TSecretLevel,myTelH,myBirthDay,myAddress,myCompany,mySexDesc,myPatType,myPapmiNo,myInMedicareNo,myOutMedicareNo,myNewOutMedicareNo,myNewInMedicareNo,myEmMedicareNo,UnionNo,IsInHos,HaveRegNum,NeedAppNum,NeedRegNum,InHosNum)
						.s PAPMIDOB=$p(^PAPER(PersonRowId,"ALL"),"^",6)
						.s ind1=100000+ind
						.s Tind=PAPMIDOB_ind1
						.Set ^CacheTemp(repid,Tind)=Data
		 				.Set ind=ind+1
	 				}

				}
				s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PapmiRowId,RowId))
			}
				set PersonRowId =$o(^DHCPERSON(0,"FCMedicareCode1",qNewOutMedicareNo,PersonRowId))
		}
		k ^TempDHCCardSerarch(Job,"CardSearch")
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
			//if HospitalCode="BJDTYY" {

            if (RowId="")
             {
	             s Name=$p(^PAPER(PersonRowId,"ALL"),"^",1)
	             s EmployeeNo=$P($G(^PAPER(PersonRowId,"EMP")),"^",5) ;加入工号查询项。李相宗，2011-08-03.
	             s IDCardNo= $p(^PAPER(PersonRowId,"ALL"),"^",9)
	             s cardtype=""
	             s CardTypeDesc=""
	             s myCredStr=$g(^PAPER(PersonRowId,"ALL"))
 				 if (myCredStr'=""){
	 				do PatInfo(PersonRowId)
 				 }
				 i ##class(web.DHCPATCardUnite).PatMasActive(PersonRowId)'="N" d
 				 .q:$D(^TempDHCCardSerarch(Job,"CardSearch",PersonRowId))
 				 .s:SearchSource="Unite" ^TempDHCCardSerarch(Job,"CardSearch",PersonRowId)=""
 				 .s:SearchSource="Unite" CardNO=##class(web.DHCPATCardUnite).GetCardNoInfo(PersonRowId)
 				 .q:$$PatInfoCheck()="Y"
 				 .set Data=$ListBuild(Name,EmployeeNo,IDCardNo,CardNO,ActivedFlag,ID,CardTypeDesc,myCredNo,myCredTypeDesc,myOtherStr,PersonRowId,$G(TCreateDate),$G(TCreateUser),TPoliticalLevel,TSecretLevel,myTelH,myBirthDay,myAddress,myCompany,mySexDesc,myPatType,myPapmiNo,myInMedicareNo,myOutMedicareNo,myNewOutMedicareNo,myNewInMedicareNo,myEmMedicareNo,UnionNo,IsInHos,HaveRegNum,NeedAppNum,NeedRegNum,InHosNum)
				 .s PAPMIDOB=$p(^PAPER(PersonRowId,"ALL"),"^",6)
				 .s ind1=100000+ind
				 .s Tind=PAPMIDOB_ind1
				 .Set ^CacheTemp(repid,Tind)=Data
 				 .Set ind=ind+1
             }
            
			while(RowId'="")
			{
				s status=$p(^DHCCARD("CF",RowId),"^",10)
				s CSCSub=$o(^DHCCARD("CF",RowId,"CSC",0))
				set CFType=$P(^DHCCARD("CF",RowId),"^",16)
				//判断卡类型是否给该院区授权
				s HosFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_CardTypeDef",CFType,LogonHospId,+$H)
				if HosFlag'="Y" s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PapmiRowId,RowId)) continue
				s CSCHospId=$p(^DHCCARD("CF",RowId,"CSC",CSCSub),"^",18)
				if (qHospital="on")&&(CSCHospId'=LogonHospId) s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PapmiRowId,RowId)) continue
				s:status="" status="N"

				if ((qUseStatus="N") || (("^"_CardStatus_"^")[("^"_status_"^")))
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
					 s EmployeeNo=$P($G(^PAPER(PersonRowId,"EMP")),"^",5) ;加入工号查询项。李相宗，2011-08-03.
					 s IDCardNo= $p(^PAPER(PapmiRowId,"ALL"),"^",9)
					 s cardtype=""
					 s CardTypeDesc=""
					 if ($g(^DHCCARD("CF",RowId))'="") s cardtype=$p($g(^DHCCARD("CF",RowId)),"^",16)
					 s:cardtype'="" CardTypeDesc=$p($g(^DHCCARDTYPEDef(cardtype)),"^",2)
					 if (..IsSupportCardType(mySupportFlag,cardtype)=1)||(SearchSource="Unite")
					 {
		 				s myCredStr=$g(^PAPER(PapmiRowId,"ALL"))
		 				if (myCredStr'=""){
			 				do PatInfo(PapmiRowId)
		 				}
	 					i ##class(web.DHCPATCardUnite).PatMasActive(PersonRowId)'="N" d
		 				.q:$D(^TempDHCCardSerarch(Job,"CardSearch",PersonRowId))
		 				.s:SearchSource="Unite" ^TempDHCCardSerarch(Job,"CardSearch",PersonRowId)=""
		 				.s:SearchSource="Unite" CardNO=##class(web.DHCPATCardUnite).GetCardNoInfo(PersonRowId)
		 				.q:(($p(^DHCCARD("CF",RowId),"^",29)="Y")&&(cardunite=1))
		 				.q:$$PatInfoCheck()="Y"
		 				.set Data=$ListBuild(Name,EmployeeNo,IDCardNo,CardNO,ActivedFlag,ID,CardTypeDesc,myCredNo,myCredTypeDesc,myOtherStr,PersonRowId,$G(TCreateDate),$G(TCreateUser),TPoliticalLevel,TSecretLevel,myTelH,myBirthDay,myAddress,myCompany,mySexDesc,myPatType,myPapmiNo,myInMedicareNo,myOutMedicareNo,myNewOutMedicareNo,myNewInMedicareNo,myEmMedicareNo,UnionNo,IsInHos,HaveRegNum,NeedAppNum,NeedRegNum,InHosNum)
						.s PAPMIDOB=$p(^PAPER(PersonRowId,"ALL"),"^",6)
						.s ind1=100000+ind
						.s Tind=PAPMIDOB_ind1
						.Set ^CacheTemp(repid,Tind)=Data
		 				.Set ind=ind+1
	 				}

				}
				s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PapmiRowId,RowId))
			}
				set PersonRowId =$o(^DHCPERSON(0,"FCMedicareCode2",qNewInMedicareNo,PersonRowId))
		}
		k ^TempDHCCardSerarch(Job,"CardSearch")
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}

	if (qInsuranceNo'="")
	{
	//*****************按医保号查询
		;s qNewOutMedicareNo=qNewOutMedicareNo_"Z"
		set PersonRowId =$o(^PAPERi("PAPER_HFundNo",qInsuranceNo,0))
		while (PersonRowId'="")
		{
			do ReSetVar
			set RowId=""
			s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId))
			//if HospitalCode="BJDTYY" {
			
            if (RowId="")
             {
	             s Name=$p(^PAPER(PersonRowId,"ALL"),"^",1)
	             s EmployeeNo=$P($G(^PAPER(PersonRowId,"EMP")),"^",5) ;加入工号查询项。李相宗，2011-08-03.
	             s IDCardNo= $p(^PAPER(PersonRowId,"ALL"),"^",9)
	             s cardtype=""
	             s CardTypeDesc=""
	             s myCredStr=$g(^PAPER(PersonRowId,"ALL"))
 				 if (myCredStr'=""){
	 				do PatInfo(PersonRowId)
 				 }
	 			 i ##class(web.DHCPATCardUnite).PatMasActive(PersonRowId)'="N" d
 				.q:$D(^TempDHCCardSerarch(Job,"CardSearch",PersonRowId))
 				.s:SearchSource="Unite" ^TempDHCCardSerarch(Job,"CardSearch",PersonRowId)=""
 				.s:SearchSource="Unite" CardNO=##class(web.DHCPATCardUnite).GetCardNoInfo(PersonRowId)
 				.q:$$PatInfoCheck()="Y"
 				.set Data=$ListBuild(Name,EmployeeNo,IDCardNo,CardNO,ActivedFlag,ID,CardTypeDesc,myCredNo,myCredTypeDesc,myOtherStr,PersonRowId,$G(TCreateDate),$G(TCreateUser),TPoliticalLevel,TSecretLevel,myTelH,myBirthDay,myAddress,myCompany,mySexDesc,myPatType,myPapmiNo,myInMedicareNo,myOutMedicareNo,myNewOutMedicareNo,myNewInMedicareNo,myEmMedicareNo,UnionNo,IsInHos,HaveRegNum,NeedAppNum,NeedRegNum,InHosNum)
				.s PAPMIDOB=$p(^PAPER(PersonRowId,"ALL"),"^",6)
				.s ind1=100000+ind
				.s Tind=PAPMIDOB_ind1
				.Set ^CacheTemp(repid,Tind)=Data
 				.Set ind=ind+1
             }
            
			while(RowId'="")
			{
				s status=$p(^DHCCARD("CF",RowId),"^",10)
				set CFType=$P(^DHCCARD("CF",RowId),"^",16)
				//判断卡类型是否给该院区授权
				s HosFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_CardTypeDef",CFType,LogonHospId,+$H)
				if HosFlag'="Y" s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId)) continue
				s CSCSub=$o(^DHCCARD("CF",RowId,"CSC",0))
				s CSCHospId=$p(^DHCCARD("CF",RowId,"CSC",CSCSub),"^",18)
				if (qHospital="on")&&(CSCHospId'=LogonHospId) s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId)) continue
				s:status="" status="N"

				if ((qUseStatus="N") || (("^"_CardStatus_"^")[("^"_status_"^")))
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
					 s EmployeeNo=$P($G(^PAPER(PersonRowId,"EMP")),"^",5) ;加入工号查询项。李相宗，2011-08-03.
					 s IDCardNo= $p(^PAPER(PersonRowId,"ALL"),"^",9)
					 s cardtype=""
					 s CardTypeDesc=""
					 if ($g(^DHCCARD("CF",RowId))'="") s cardtype=$p($g(^DHCCARD("CF",RowId)),"^",16)
					 s:cardtype'="" CardTypeDesc=$p($g(^DHCCARDTYPEDef(cardtype)),"^",2)
					 if (..IsSupportCardType(mySupportFlag,cardtype)=1)||(SearchSource="Unite")
					 {
		 				s myCredStr=$g(^PAPER(PersonRowId,"ALL"))
		 				if (myCredStr'=""){
			 				do PatInfo(PersonRowId)
		 				}
	 					i ##class(web.DHCPATCardUnite).PatMasActive(PersonRowId)'="N" d
		 				.q:$D(^TempDHCCardSerarch(Job,"CardSearch",PersonRowId))
		 				.s:SearchSource="Unite" ^TempDHCCardSerarch(Job,"CardSearch",PersonRowId)=""
		 				.s:SearchSource="Unite" CardNO=##class(web.DHCPATCardUnite).GetCardNoInfo(PersonRowId)
		 				.q:(($p(^DHCCARD("CF",RowId),"^",29)="Y")&&(cardunite=1))
		 				.q:$$PatInfoCheck()="Y"
		 				.set Data=$ListBuild(Name,EmployeeNo,IDCardNo,CardNO,ActivedFlag,ID,CardTypeDesc,myCredNo,myCredTypeDesc,myOtherStr,PersonRowId,$G(TCreateDate),$G(TCreateUser),TPoliticalLevel,TSecretLevel,myTelH,myBirthDay,myAddress,myCompany,mySexDesc,myPatType,myPapmiNo,myInMedicareNo,myOutMedicareNo,myNewOutMedicareNo,myNewInMedicareNo,myEmMedicareNo,UnionNo,IsInHos,HaveRegNum,NeedAppNum,NeedRegNum,InHosNum)
						.s PAPMIDOB=$p(^PAPER(PersonRowId,"ALL"),"^",6)
						.s ind1=100000+ind
						.s Tind=PAPMIDOB_ind1
						.Set ^CacheTemp(repid,Tind)=Data
		 				.Set ind=ind+1
	 				}

				}
				s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId))
			}
				set PersonRowId =$o(^PAPERi("PAPER_HFundNo",qInsuranceNo,PersonRowId))
		}
		k ^TempDHCCardSerarch(Job,"CardSearch")
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	
	if (qEmMedicare'="")
	{
	//*****************按急诊病历号查询
		;s qNewOutMedicareNo=qNewOutMedicareNo_"Z"
		set PersonRowId =$o(^DHCPERSON(0,"FCMedicareCode1",qEmMedicare,0))
		SET ^DHCAA=PersonRowId
		while (PersonRowId'="")
		{
			do ReSetVar
			s PapmiRowId=$p(^DHCPERSON(PersonRowId),"^",1)
			set RowId=""
			s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PapmiRowId,RowId))
			//if HospitalCode="BJDTYY" {

            if (RowId="")
             {
	            s Name=$p(^PAPER(PersonRowId,"ALL"),"^",1)
	            s EmployeeNo=$P($G(^PAPER(PersonRowId,"EMP")),"^",5) ;加入工号查询项。李相宗，2011-08-03.
	            s IDCardNo= $p(^PAPER(PersonRowId,"ALL"),"^",9)
	            s cardtype=""
	            s CardTypeDesc=""
	            s myCredStr=$g(^PAPER(PersonRowId,"ALL"))
 				if (myCredStr'=""){
	 				do PatInfo(PersonRowId)
 				}
	 			i ##class(web.DHCPATCardUnite).PatMasActive(PersonRowId)'="N" d
 				.q:$D(^TempDHCCardSerarch(Job,"CardSearch",PersonRowId))
 				.s:SearchSource="Unite" ^TempDHCCardSerarch(Job,"CardSearch",PersonRowId)=""
 				.s:SearchSource="Unite" CardNO=##class(web.DHCPATCardUnite).GetCardNoInfo(PersonRowId)
 				.q:$$PatInfoCheck()="Y"
 				.set Data=$ListBuild(Name,EmployeeNo,IDCardNo,CardNO,ActivedFlag,ID,CardTypeDesc,myCredNo,myCredTypeDesc,myOtherStr,PersonRowId,$G(TCreateDate),$G(TCreateUser),TPoliticalLevel,TSecretLevel,myTelH,myBirthDay,myAddress,myCompany,mySexDesc,myPatType,myPapmiNo,myInMedicareNo,myOutMedicareNo,myNewOutMedicareNo,myNewInMedicareNo,myEmMedicareNo,UnionNo,IsInHos,HaveRegNum,NeedAppNum,NeedRegNum,InHosNum)
				.s PAPMIDOB=$p(^PAPER(PersonRowId,"ALL"),"^",6)
				.s ind1=100000+ind
				.s Tind=PAPMIDOB_ind1
				.Set ^CacheTemp(repid,Tind)=Data
 				.Set ind=ind+1
             }
        
			while(RowId'="")
			{
				s status=$p(^DHCCARD("CF",RowId),"^",10)
				set CFType=$P(^DHCCARD("CF",RowId),"^",16)
				//判断卡类型是否给该院区授权
				s HosFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_CardTypeDef",CFType,LogonHospId,+$H)
				if HosFlag'="Y" s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PapmiRowId,RowId)) continue
				s CSCSub=$o(^DHCCARD("CF",RowId,"CSC",0))
				s CSCHospId=$p(^DHCCARD("CF",RowId,"CSC",CSCSub),"^",18)
				if (qHospital="on")&&(CSCHospId'=LogonHospId) s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PapmiRowId,RowId)) continue
				s:status="" status="N"

				if ((qUseStatus="N") || (("^"_CardStatus_"^")[("^"_status_"^")))
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
 					s EmployeeNo=$P($G(^PAPER(PersonRowId,"EMP")),"^",5) ;加入工号查询项。李相宗，2011-08-03.
 					s IDCardNo= $p(^PAPER(PapmiRowId,"ALL"),"^",9)
 					s cardtype=""
 					s CardTypeDesc=""
 					if ($g(^DHCCARD("CF",RowId))'="") s cardtype=$p($g(^DHCCARD("CF",RowId)),"^",16)
 					s:cardtype'="" CardTypeDesc=$p($g(^DHCCARDTYPEDef(cardtype)),"^",2)
 					if (..IsSupportCardType(mySupportFlag,cardtype)=1)||(SearchSource="Unite")
 					{
		 				s myCredStr=$g(^PAPER(PapmiRowId,"ALL"))
		 				if (myCredStr'=""){
			 				do PatInfo(PapmiRowId)
		 				}
	 					i ##class(web.DHCPATCardUnite).PatMasActive(PersonRowId)'="N" d
		 				.q:$D(^TempDHCCardSerarch(Job,"CardSearch",PersonRowId))
		 				.s:SearchSource="Unite" ^TempDHCCardSerarch(Job,"CardSearch",PersonRowId)=""
		 				.s:SearchSource="Unite" CardNO=##class(web.DHCPATCardUnite).GetCardNoInfo(PersonRowId)
		 				.q:(($p(^DHCCARD("CF",RowId),"^",29)="Y")&&(cardunite=1))
		 				.q:$$PatInfoCheck()="Y"
		 				.set Data=$ListBuild(Name,EmployeeNo,IDCardNo,CardNO,ActivedFlag,ID,CardTypeDesc,myCredNo,myCredTypeDesc,myOtherStr,PersonRowId,$G(TCreateDate),$G(TCreateUser),TPoliticalLevel,TSecretLevel,myTelH,myBirthDay,myAddress,myCompany,mySexDesc,myPatType,myPapmiNo,myInMedicareNo,myOutMedicareNo,myNewOutMedicareNo,myNewInMedicareNo,myEmMedicareNo,UnionNo,IsInHos,HaveRegNum,NeedAppNum,NeedRegNum,InHosNum)
						.s PAPMIDOB=$p(^PAPER(PersonRowId,"ALL"),"^",6)
						.s ind1=100000+ind
						.s Tind=PAPMIDOB_ind1
						.Set ^CacheTemp(repid,Tind)=Data
		 				.Set ind=ind+1
	 				}

				}
				s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PapmiRowId,RowId))
			}
				set PersonRowId =$o(^DHCPERSON(0,"FCMedicareCode1",qEmMedicare,PersonRowId))
		}
		k ^TempDHCCardSerarch(Job,"CardSearch")
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	k ^TempDHCCardSerarch(Job,"CardSearch")
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
PatInfo(PersonRowId)
	s myCredNo=$p($g(^PAPER(PersonRowId,"PAT",3)),"^",6)
	//s myCredNo=$p($g(^PAPER(PersonRowId,"ALL")),"^",9)
	//
	s myCredTypeID=$p($g(^PAPER(PersonRowId,"PAT",3)),"^",7)
	s:myCredTypeID'="" myCredTypeDesc=$p($g(^PAC("CARD",myCredTypeID)),"^",2)
	s myTelH=$p(^PAPER(PersonRowId,"PER",1),"^",11) ;电话号码
	s myBirthDay=$p(^PAPER(PersonRowId,"ALL"),"^",6) ;出生日期
	
	s myBirthDay=..%ZD(myBirthDay) //$zd(myBirthDay,3)
	s mySexDr=$p(^PAPER(PersonRowId,"ALL"),"^",7) ;性别
	i mySexDr'="" d 
	.s mySexDesc=$p(^CT("SEX",mySexDr),"^",2)			 				
	e  s mySexDesc=""
	s myOutMedicareNo=""
	s myInMedicareNo=""
	s myNewOutMedicareNo=""
	s myNewInMedicareNo=""
	s myEmMedicareNo=""
	s TCreateDate=""
	s TCreateUser=""
	i $d(^PAPER(PersonRowId,"PER",4)) s myOutMedicareNo=$p(^PAPER(PersonRowId,"PER",4),"^",4)    ;门诊病历号(东)
	s myInMedicareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(PersonRowId,"I",$g(LogonHospId))
	i myInMedicareNo["-"  s myInMedicareNo=""
	s DHCPersonDr=$o(^DHCPERSON(0,"PAPERSON",PersonRowId,""))
	i DHCPersonDr'=""  d 
	.i $d(^DHCPERSON(DHCPersonDr))  d 
	..s myNewOutMedicareNo=$p(^DHCPERSON(DHCPersonDr),"^",5)	;住院病历号(西)
	..s myNewInMedicareNo=$p(^DHCPERSON(DHCPersonDr),"^",6)		;住院病历号(西)
	..s myEmMedicareNo=$p(^DHCPERSON(DHCPersonDr),"^",2)		;急诊病历号
	s myAddress=$p($g(^PAPER(PersonRowId,"PER","ADD",1)),"^",1) ;住址
	s myCompany=$p($g(^PAPER(PersonRowId,"PER",4)),"^",18)      ;工作单位		 						 				
	s myPatType=""   
 	s socialstatus=$p($g(^PAPER(PersonRowId,"PER",1)),"^",10) 
	i socialstatus'="" d
	.s myPatType=$p($g(^CT("SS",socialstatus)),"^",2)           ;病人类型
	s myPapmiNo=$p($g(^PAPER(PersonRowId,"PAT",1)),"^",2)        ;IP_No
	s UnionNo=$p($g(^PAPER(PersonRowId,"PAT",3)),"^",12)
	
	s myOtherStr=myTelH_"^"_myBirthDay_"^"_myAddress_"^"_myCompany_"^"_mySexDesc_"^"_myPatType_"^"_myPapmiNo
	s myOtherStr=myOtherStr_"^"_myInMedicareNo_"^"_myOutMedicareNo_"^"_myNewOutMedicareNo_"^"_myNewInMedicareNo_"^"_myEmMedicareNo_"^"_UnionNo
	s CardID=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,0))
	i CardID'="" d
	.s TCreateDate=$p($g(^PAPER(PersonRowId,"PER",5)),"^",17)
	.i TCreateDate'="" s TCreateDate=..%ZD(TCreateDate) //$ZD(TCreateDate,3)
	.s TCreateUser=$p($g(^PAPER(PersonRowId,"PER",5)),"^",18)
	.i TCreateUser'="" s TCreateUser=$P(^SSU("SSUSR",TCreateUser),"^",2)
	s CardNOStr=##class(web.DHCPATCardUnite).GetCardNoInfo(PersonRowId)
	s FirstActiveCardNo=$P(CardNOStr,",",1)
	;lxz外层调用之前已经取值卡号，这边不用再去取.（改成为空取值）如果姓名对应多张有效卡会覆盖输出
	if $G(CardNO)=""  d
	.s CardNO=$p(FirstActiveCardNo,$c(1),2)
	s myOtherStr=myOtherStr_"^"_TCreateDate_"^"_TCreateUser
	

	s PatEncryptLevel=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(PersonRowId,.ErrMsg)
	i PatEncryptLevel'="" {
		s TPoliticalLevel=$p(PatEncryptLevel,"^",2)
		s TSecretLevel=$p(PatEncryptLevel,"^",4)
	}
	s IsInHos="否"
	s PatInIPAdmission=##class(web.DHCDocOrderCommon).CheckPatInIPAdmission(PersonRowId)
	if PatInIPAdmission=1 s IsInHos="是"
	s RegAndAppCount=..GetRegAndAppCount(PersonRowId,$G(LogonHospId))
	s HaveRegNum=$P(RegAndAppCount,"^",1)
	s NeedAppNum=$P(RegAndAppCount,"^",3)
	s NeedRegNum=$P(RegAndAppCount,"^",2)
	s InHosNum=+$p($g(^PAPER(PersonRowId,"PER",4)),"^",8)
	q
PatInfoCheck()
	// SupportFlag, CredNo, UseStatus, BirthDay, Telphone, OutMedicareNo, InMedicareNo, NewOutMedicareNo, InsuranceNo, EmMedicare
	b //Name,EmployeeNo,IDCardNo,CardNO,ActivedFlag,ID,CardTypeDesc,myCredNo,myCredTypeDesc,myOtherStr,PersonRowId,$G(TCreateDate),$G(TCreateUser),TPoliticalLevel,TSecretLevel,myTelH,myBirthDay,myAddress,myCompany,mySexDesc,myPatType,myPapmiNo,myInMedicareNo,myOutMedicareNo,myNewOutMedicareNo,myNewInMedicareNo,myEmMedicareNo,UnionNo,IsInHos,HaveRegNum,NeedAppNum,NeedRegNum,InHosNum
	s PatName=$p(^PAPER(PersonRowId,"ALL"),"^",1)
	i (NameStandard'="")&&(PatName'[NameStandard) q "Y"
	s PatIDCardNo= $p(^PAPER(PersonRowId,"ALL"),"^",9)
	q:(qIDCardNo'="")&&(PatIDCardNo'=qIDCardNo) "Y"
	q:(CardNo'="")&&(CardNO'=CardNo) "Y"
	q:(BirthDay'="")&&(BirthDay'=myBirthDay) "Y"
	
	q:(Telphone'="")&&(Telphone'=myTelH) "Y"
	q:(OutMedicareNo'="")&&(OutMedicareNo'=myOutMedicareNo) "Y"
	q:(InMedicareNo'="")&&(InMedicareNo'=myInMedicareNo) "Y"
	q:(NewOutMedicareNo'="")&&(NewOutMedicareNo'=myNewOutMedicareNo) "Y"
	q:(qEmMedicare'="")&&(qEmMedicare'=myEmMedicareNo) "Y"
	q:(NewOutMedicareNo'="")&&(NewOutMedicareNo'=myNewOutMedicareNo) "Y"
	//q:InsuranceNo'=""&&InsuranceNo'=InsuranceNo "Y"
	s EmployeeNo=$P($G(^PAPER(PersonRowId,"EMP")),"^",5)
	q:(qEmployeeNo'="")&&(qEmployeeNo'=EmployeeNo) "Y"
	q ""
ReSetVar
	set (myTelH,myBirthDay,myInMedicareNo,myAddress,myCompany,mySexDesc,myPatType,myPapmiNo,myEmMedicareNo,TCreateDate,TCreateUser,TPoliticalLevel,TSecretLevel,IsInHos,HaveRegNum,NeedAppNum,NeedRegNum,InHosNum)=""
	q
}

/// /1131
/// /w ##class(web.DHCCardSearch).GetRegAndAppCount(1131)
ClassMethod GetRegAndAppCount(PersonRowId, HospId = "")
{
	s HospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	q:PersonRowId="" ""
	s HaveRegNum=0
	s NeedAppNum=0
	s NeedRegNum=0
	s Type=""
	f  s Type=$O(^PAPERdr(PersonRowId,"ADM",Type)) q:(Type="")  d
	.q:Type="H"
	.q:Type="I"
	.s AdmId=""

	.f  s AdmId=$O(^PAPERdr(PersonRowId,"ADM",Type,AdmId)) q:AdmId=""  d
	..s AdmDate=$p($g(^PAADM(AdmId)),"^",6)
	..
	..s VisitStatus=$p($g(^PAADM(AdmId)),"^",20)
	..s AdmHospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(AdmId)
	..Q:AdmHospitalId'=HospId
	..q:(VisitStatus'="A")&&(Type'="E")
	..q:(VisitStatus="C")&&(Type="E")
	..s HaveRegNum=HaveRegNum+1
	..i AdmDate>=+$H  d
	...s mradm=$p(^PAADM(AdmId),"^",61)
	...s DiagnoseCount=##class(web.DHCDocOrderEntry).GetMRDiagnoseCount(mradm)
	...i DiagnoseCount=0 d
	....Set QueRowid=$O(^User.DHCQueueI("QuePaadmDrIndex",AdmId,""),-1)
	....if QueRowid'="" d
	.....Set QueObj=##Class(User.DHCQueue).%OpenId(QueRowid)	
	.....Set PersName=QueObj.QueStateDr.PersName
	.....Do QueObj.%Close()
	.....i (PersName'="到达")&&(PersName'="复诊") s NeedRegNum=NeedRegNum+1
	s RESRowId=""
	f  s RESRowId=$O(^PAPERDR(PersonRowId,"RB_Appt","I",RESRowId)) q:RESRowId=""  d
	.s Loc=$P($G(^RB("RES",RESRowId)),"^",1)
	.q:Loc=""
	.s HospDr=$p(^CTLOC(Loc),"^",22)
	.Q:HospDr'=HospId
	.s ASChildSub=""
	.f  s ASChildSub=$O(^PAPERDR(PersonRowId,"RB_Appt","I",RESRowId,ASChildSub)) q:ASChildSub=""  d
	..s APPTChildSub=""
	..f  s APPTChildSub=$O(^PAPERDR(PersonRowId,"RB_Appt","I",RESRowId,ASChildSub,APPTChildSub)) q:APPTChildSub=""  d
	...s NeedAppNum=NeedAppNum+1
	//^PAPERDR(PersonRowId,"RB_Appt","I",RESRowId,ASChildSub,APPTChildSub)
	q HaveRegNum_"^"_NeedRegNum_"^"_NeedAppNum
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
	 set CardTypeDr=$p(^DHCCARD("CF",RowID),"^",16)
	 s myCardTypeStr=""
	 s:CardTypeDr'="" myCardTypeStr=$g(^DHCCARDTYPEDef(CardTypeDr))
	 if (myCardTypeStr'=""){
		 set myCardTypeinfoStr=myCardTypeStr
	 }
	 s str=CardTypeDr_"^"_myCardTypeinfoStr
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

/// 根据卡RowID获取病人及卡信息
ClassMethod getpatinfo(itmjs As %Library.String = "", itmjsex As %Library.String = "", CardID As %Library.String = "")
{
   s RegNo="",Papmi="",name="",IDCardNo="",CardNo="",SecurityNO="",ActiveFlag="",DateFrom="",DateTo="",FlagName=""
   s Balance="",CredTypeID="",CredType="",CredNo="",cardverify1="",cardverify2=""
   s myCardTypeDesc="",myCardChangeValidate="",myCardTypeID="",myCardLength="",myCardFareCost=""
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
	 if accrowid'=""{ //有帐户情况?只保存一个号码?类型;证件号=身份证号?证件类型=身份证
		 	set Balance=$p(^DHCACD("AccM",accrowid),"^",8)
		 	set AccStatus=$p(^DHCACD("AccM",accrowid),"^",13) 	
		 	set AccType=$p(^DHCACD("AccM",accrowid),"^",16)
		 	set CredTypeID=$p(^DHCACD("AccM",accrowid),"^",17)
		 	set CredNo=$p(^DHCACD("AccM",accrowid),"^",18)
		 	set IDCardNo=CredNo
		 	set CardTypeDr=CredTypeID
	 }	
	 else{
		 	set IDCardNo=$p(^PAPER(Papmi,"ALL"),"^",9)
		 	set CardTypeDr=""
			i $d(^PAPER(Papmi,"PAT",3)) d 
		 	.s:^PAPER(Papmi,"PAT",3)'="" CredNo=$p(^PAPER(Papmi,"PAT",3),"^",6)
		 	.s:^PAPER(Papmi,"PAT",3)'="" CredTypeID=$p(^PAPER(Papmi,"PAT",3),"^",7)
	 }
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
		
	i DateFrom'=""  s DateFrom=$zd(DateFrom,4)
	 i DateTo'=""  s DateTo=$zd(DateTo,4)
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
	 s retval=itmjs_"('"_$ZCVT(str,"O","JS")_"');"
	 i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(str,"O","JS")_"');"
	 &javascript<#(retval)#>
	 q 1
}

/// 根据医保号取医保卡信息
/// w ##class(web.DHCCardSearch).GetInsuCardInfo("00000117200S",2)
ClassMethod GetInsuCardInfo(qInsuranceNo As %String, qCardTypeDR As %String = "") As %String
{
	s InsuCardInfo=""
	q:qInsuranceNo="" ""
	s PersonRowId=0
	
	f  s PersonRowId=$o(^PAPERi("PAPER_YBCode",qInsuranceNo,PersonRowId)) q:PersonRowId=""  d
	.//q:PersonRowId="" ""
	.s RowId=""
	.f  s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId)) q:((RowId="")||(InsuCardInfo'=""))  d 
	..s CardTypeDR=$p($g(^DHCCARD("CF",RowId)),"^",16)
	..q:CardTypeDR'=qCardTypeDR
	..s Status=$p(^DHCCARD("CF",RowId),"^",10)
	..q:Status'="N"
	..s CardNO=$p(^DHCCARD("CF",RowId),"^",2)
	..s InsuCardInfo=CardNO
	q InsuCardInfo
}

/// 根据登记号取医保卡信息
/// w ##class(web.DHCCardSearch).GetInsuCardInfoByPatNo("0000188410",2)
ClassMethod GetInsuCardInfoByPatNo(PatNo As %String, qCardTypeDR As %String = "") As %String
{
	s InsuCardInfo=""
	q:PatNo="" ""
	s PersonRowId=0
	
	f  s PersonRowId=$o(^PAPERi("PAPMI_PatNo",PatNo,PersonRowId)) q:PersonRowId=""  d
	.//q:PersonRowId="" ""
	.b ;000
	.s RowId=""
	.f  s RowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PersonRowId,RowId)) q:((RowId="")||(InsuCardInfo'=""))  d 
	..s CardTypeDR=$p($g(^DHCCARD("CF",RowId)),"^",16)
	..q:CardTypeDR'=qCardTypeDR
	..s Status=$p(^DHCCARD("CF",RowId),"^",10)
	..q:Status'="N"
	..s CardNO=$p(^DHCCARD("CF",RowId),"^",2)
	..s InsuCardInfo=CardNO
	q InsuCardInfo
}

/// 根据医保有效部分取医保卡信息
/// w ##class(web.DHCCardSearch).GetInsuCardInfoByRealPart("000001171",2)
ClassMethod GetInsuCardInfoByRealPart(qCardNo As %String, qCardTypeDR As %String = "") As %String
{
	s Flag=0
	s InsuCardInfo=""
	q:qCardNo="" ""
	s RealPartNo=$e(qCardNo,1,9)
	s PersonRowId=0
	
	s CardNo=$o(^DHCCARDi("CF",0,"CardNo",RealPartNo))
	q:CardNo'[RealPartNo InsuCardInfo
	s InsuCardInfo=$$GetInsuCardInfo()
	q:InsuCardInfo InsuCardInfo
	f  s CardNo=$o(^DHCCARDi("CF",0,"CardNo",CardNo)) q:((CardNo="")||(CardNo'[RealPartNo)||(InsuCardInfo'=""))  d
	.s InsuCardInfo=$$GetInsuCardInfo
	q InsuCardInfo

GetInsuCardInfo()
	s RowId=""
	f  s RowId=$o(^DHCCARDi("CF",0,"CardNo",CardNo,RowId)) q:((RowId="")||(InsuCardInfo'=""))  d 
	.s CardTypeDR=$p($g(^DHCCARD("CF",RowId)),"^",16)
	.q:CardTypeDR'=qCardTypeDR
	.s Status=$p(^DHCCARD("CF",RowId),"^",10)
	.q:Status'="N"
	.s CardNO=$p(^DHCCARD("CF",RowId),"^",2)
	.s InsuCardInfo=CardNO
	i InsuCardInfo'=qCardNo  s Flag=1
	s InsuCardInfo=InsuCardInfo_"^"_Flag
	q InsuCardInfo
}

/// 在返回参数中需要加入工号（EmployeeNo:%String,）李相宗，2011-08-03；
Query PatientCardQuery(Name As %String = "", IDCardNo As %String = "", CardNo As %String = "", CardStatus As %String = "", CardTypeID As %String = "", SupportFlag As %String = "", CredNo As %String = "", UseStatus As %String = "", BirthDay As %String = "", Telphone As %String = "", OutMedicareNo As %String = "", InMedicareNo As %String = "", NewInMedicareNo As %String = "", InsuranceNo As %String = "", EmMedicare As %String = "", ExpStr As %String = "") As %Query(ROWSPEC = "Name:%String,EmployeeNo:%String,IDCardNo:%String,CardNO:%String,ActivedFlag:%String,CardID:%String,CardTypeDesc:%String,CredNo:%String,CredTypeDesc:%String,myOtherStr:%String,TPatientID:%String,TCreateDate:%String,TCreateUser:%String,TPoliticalLevel:%String,TSecretLevel:%String,Ttelphone:%String,TBirthday:%String,TAddress:%String,TCompany:%String,TSex:%String,TPatType:%String,TPapmiNo:%String,TInMedicareNo:%String,TOutMedicareNo:%String,TNewOutMedicareNo:%String,TNewInMedicareNo:%String,TEmMedicareNo:%String,TUnionNo:%String,IsInHos,HaveRegNum,NeedAppNum,NeedRegNum,InHosNum")
{
}

}
