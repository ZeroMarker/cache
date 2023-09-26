Class dhcinterface.BankRegRule Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// R01:注册
ClassMethod ToRegister(RequestObj As dhcinterface.BankSendMsg) As dhcinterface.BankReturnMsg
{

	s $ZTrap="SendMsgError"
	s msgobj=##class(dhcinterface.BankReturnMsg).%New() 
	for i=1:1:RequestObj.PatientDetails.Count()
	{
		s PatDetail=RequestObj.PatientDetails.GetAt(i)
		s myConfigObj=##class(web.DHCEntity.PCA.CardTypeConfig).%New()
		s PPAPersonInfo=##class(web.DHCEntity.PCA.PATMAS).%New()
		s myCardObj=##class(web.DHCEntity.PCA.CardRef).%New()
		s myCardINVObj = ##class(web.DHCEntity.PCA.CardINVPRT).%New()
		;//构造卡类型配置
		s CardTypeCode=RequestObj.BankCode
		s rtn=..GetCardTypeByCode(CardTypeCode)
		s CardTypeDR=$p(rtn,"^",1)
		i CardTypeDR="" {
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="注册失败:卡类型不合法"
			q 
		}
		;b ;病人配置信息
		s CardTypeObj=##class(User.DHCCardTypeDef).%OpenId(CardTypeDR)
		s myCardRegConfig=##class(web.DHCBL.CARD.CardPATRegConfig).GetCardPatRegConfig()
		s myConfigObj.AccManageFLag=$p(myCardRegConfig, "^", 6)
		s myConfigObj.CardRefFlag=$p(myCardRegConfig, "^", 5)
		s myConfigObj.PatMasFlag=$p(myCardRegConfig, "^", 4)
		
		s myConfigObj.CardAccountRelation=CardTypeObj.CTDCardAccountRelation
		s myConfigObj.CardFareCost=CardTypeObj.CTDCardFareCost
		s myConfigObj.FareType=CardTypeObj.CTDFareType
		s myConfigObj.GroupRegFlag="PR"
		s myConfigObj.PANoCardRefFlag=CardTypeObj.CTDPANoCardRefFlag
		
		s myConfigObj.PreCardFlag=CardTypeObj.CTDPreCardFlag
		s myConfigObj.SearchMasFlag=CardTypeObj.CTDSearchMasFlag
		s myConfigObj.StChangeValidateFlag=CardTypeObj.CTDStChangeValidateFlag
		s myConfigObj.SecurityNoFlag=CardTypeObj.CTDSecurityNoFlag
		s myConfigObj.UseINVType=CardTypeObj.CTDUseINVType
		;b //构造病人信息
		b ;1.1.1.1
		s Sex=..GetSex(RequestObj,PatDetail)
		i Sex=""	{
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="注册失败:性别值不合法"
			q 
		}	
		s PPAPersonInfo.Sex=Sex
		s Name=$tr(PatDetail.Name," ")
		i Name="" {
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="注册失败:病人姓名为空"
			q 
		}
		s PPAPersonInfo.Name=Name
		;b //1
		i ..ValidDate(PatDetail.DOB) {
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="注册失败:出生日期不合法"
			q 

		}
		;b //2
		b ;1.1.1.2
		s PPAPersonInfo.Birth=PatDetail.DOB
		s CredTypeDR=..GetCredType(RequestObj,PatDetail)
		i CredTypeDR=""	{
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="注册失败:证件类型值不合法"
			q 
		}	
		s PPAPersonInfo.CredType=CredTypeDR
		
		//i ..IsIDCardType(RequestObj,PatDetail) {
		//	i ##class(web.HXGYDataImport.Rule.CommonRule).ValidIdentityNO(PatDetail.IDNo) {
		//		s msgobj.ResultCode="001"
		//		s msgobj.ErrorMsg="注册失败:身份证号不合法"
		//		q 
		//	}
		//}
		;b //3
		b ;1.1.1.4
		s myCheckInfo=##class(web.DHCBL.CARD.UCardRefInfo).CreateCardCheckData(PatDetail.IDNo,CredTypeDR,PatDetail.IDNo,CardTypeDR, "" )
	    b ;1.1.1.5
	    ;b //4
		;解释：myrtn=0  没有检测到信息 可以按照 卡类型原有配置 直接办卡
		;myrtn=-368   	需要绑定卡标志
		;myrtn=-365		患者已经办理过此卡，通知用户，不能办理卡 集团注册时，修改EmployeeCompony字段
		;其他错误，需要提示一下 同时，不能办理卡
		
		s myrtn=+$p(myCheckInfo,"^",1)
		;w myrtn
		i (myrtn=-368) {
			s myPAPMIDR=$p(myCheckInfo,"^",2)
			s PPAPersonInfo.PAPMIRowID=myPAPMIDR
			s myConfigObj.PANoCardRefFlag="Y"		;直接定义卡与 信息建立对照
			s myConfigObj.SearchMasFlag="Y"		;建立对照， 要求有等记号
			s tmpPersonobj=##class(User.PAPerson).%OpenId(myPAPMIDR)
			s PPAPersonInfo.PatType=tmpPersonobj.PAPERSocialStatusDR.%Id()
			
		}
		else
		{
			b ;88
			;s pattype=""
			s pattype=PatDetail.PatType
			b ;66
			&sql(select ss_rowid into:pattype from sqluser.CT_SocialStatus where ss_code=:pattype)
			b ;77
			i pattype'="" d
			.s PPAPersonInfo.PatType=pattype
			else  do
			.s PPAPersonInfo.PatType="4"
		}
		b ;778
		s PPAPersonInfo.EmployeeCompany=PatDetail.Workplace  ;zhaoym 20090915 
		b //5
		s PPAPersonInfo.CredNo=PatDetail.IDNo
		s PPAPersonInfo.IDCardNo1=PatDetail.IDNo
		s PPAPersonInfo.Address=PatDetail.Address
		s zipcode=$tr(PatDetail.Zip," ")
		s zipDR=""
		&sql(select ctzip_rowid into :zipDR from sqluser.CT_Zip where ctzip_code=:zipcode)
		if zipDR'="" d
		.s PPAPersonInfo.ZipLookUpRowID=zipDR
		s PPAPersonInfo.TelHome=PatDetail.TelephoneNo
		s PPAPersonInfo.MobPhone=PatDetail.Mobile
		s PPAPersonInfo.UserDR=RequestObj.UserDR
		b //6
		b ;1.1.1.6
		s ChkPatient=..GetPAPersonByCardNO(PatDetail.PatientCard,CardTypeDR,"N")
		i ChkPatient'="" 
		{
			s patno= $p($g(^PAPER(ChkPatient,"PAT",3)),"^",6)
		    i (patno=PatDetail.IDNo){
			   	s msgobj.PatientID=ChkPatient
			   	s msgobj.ResultCode="000"
			    s msgobj.ErrorMsg="注册成功:病人已注册" 
			    
		    }else{
				s msgobj.PatientID=ChkPatient
			   	s msgobj.ResultCode="001"
			    s msgobj.ErrorMsg="注册失败:其他病人拥有此卡号，状态为正常" 
		    }
			q
		}
		;b //7
		b ;1.1.1.7
		s ChkPatient=..GetPAPersonByCardNO(PatDetail.PatientCard,CardTypeDR,"S")
		b ;1.1.1.9
		i ChkPatient'=""
		{
			s patno= $p($g(^PAPER(ChkPatient,"PAT",3)),"^",6)
		    i (patno=PatDetail.IDNo){
			   	s msgobj.PatientID=ChkPatient
			   	s msgobj.ResultCode="001"
			    s msgobj.ErrorMsg="注册失败:病人已拥有注册信息,卡号状态为挂失" 
			    
		    }else{
				s msgobj.PatientID=ChkPatient
			   	s msgobj.ResultCode="001"
			    s msgobj.ErrorMsg="注册失败:其他病人拥有此卡号，状态为挂失" 
		    }
			q
		}
		;b //8
		b ;1.1.1.8
		s ChkPatient=..GetPAPersonByCardNO(PatDetail.PatientCard,CardTypeDR,"D")
		i ChkPatient'=""
		{
			s patno= $p($g(^PAPER(ChkPatient,"PAT",3)),"^",6)
		    i (patno=PatDetail.IDNo){
			   	s msgobj.PatientID=ChkPatient
			   	s msgobj.ResultCode="001"
			    s msgobj.ErrorMsg="注册失败:病人已拥有注册信息,卡号状态为作废" 
			    
		    }else{
				s msgobj.PatientID=ChkPatient
			   	s msgobj.ResultCode="001"
			    s msgobj.ErrorMsg="注册失败:其他病人拥有此卡号，状态为作废" 
		    }
			q
		}

		b //构造卡
		/*
		s CardID=##class(web.DHCBL.CARD.CardManager).GetCardIDByCardNO(PatDetail.PatientCard,CardTypeDR)
		;as1
		i CardID'="" {
		    s patId=$p($g(^DHCCARD("CF",CardID)),"^",4)
		    s patno= $p($g(^PAPER(patId,"PAT",3)),"^",6)
		    i (patno=PatDetail.IDNo){
			   	s msgobj.PatientID=patId
			   	s msgobj.ResultCode="000"
			    s msgobj.ErrorMsg="注册成功:病人已注册" 
			    
		    }else{
			  s msgobj.ResultCode="001"
			  s msgobj.ErrorMsg="注册失败:新卡号已被使用"
		    }
			q 
		}
		*/
		s myCardObj.CardNo=PatDetail.PatientCard
		s myCardObj.CardTypeDefine=CardTypeDR
		s myCardObj.ComputerIP=RequestObj.BankCode
		s myCardObj.CredNo=PatDetail.IDNo
		s myCardObj.UserDR=RequestObj.UserDR
		/*s BankDR=..GetOrganByCode(RequestObj.BankCode)
		i BankDR="" {
			 s msgobj.ResultCode="001"
			 s msgobj.ErrorMsg="注册失败:HXOrgan机构不存在"
			 q
		}
		s myCardObj.Organ=BankDR
*/
		//构造帐户
		
		//构造预交金
		
		//构造发票
		;s myCardINVObj.CardFareCost = myDate
		;s myCardINVObj.PayMode = myTime
		;;s myCardINVObj.ReceiptNO = myTime
		;s myCardINVObj.UserDR = RequestObj.UserDR

		b //序列化失败
		s rtn=myConfigObj.XMLExportToString(.ConfigInfo,"CardTypeConfig")
		i ($system.Status.IsError(rtn)) {
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="注册失败:卡类型配置序列化失败"
			q
		 }
		 b //dd
		s rtn=PPAPersonInfo.XMLExportToString(.PaPatInfo,"PATMAS")
		i ($system.Status.IsError(rtn)) {
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="注册失败:病人信息序列化失败"
			q
		 }
		s rtn=myCardObj.XMLExportToString(.CardInfo,"CardRef")
		i ($system.Status.IsError(rtn)) {
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="注册失败:卡信息序列化失败"
			q
		 }
		b ;帐户信息
		s AccInfo=""
		b ;预交金信息
		s DepositInfo=""
		/*
		s rtn=myAccObj.XMLExportToString(.AccInfo,"AccManager")
		i ($system.Status.IsError(rtn)) {
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="注册失败:帐户信息序列化失败"
			q
		}
		s rtn=myDepositObj.XMLExportToString(.DepositInfo,"AccPreDeposit")
		i ($system.Status.IsError(rtn)) {
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="注册失败:预交金信息序列化失败"
			q
		}
		*/
		s rtn=myCardINVObj.XMLExportToString(.CardINVInfo,"CardINVPRT")
		i ($system.Status.IsError(rtn)) {
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="注册失败:发票序列化失败"
			q
		 }
		 
		b //系统特殊配置
		s SepcialInfo="0^"
		s ExpStr=""
        b ;注册
		;s status=##class(web.DHCBL.CARD.UCardPatRegBuilder).SavePCAInfoToServer(ConfigInfo, PaPatInfo, CardInfo, AccInfo, DepositInfo, CardINVInfo, SepcialInfo, ExpStr)
		b ;1.1.1.9
		s status=##class(web.DHCBL.CARDIF.ICardRefInfo).SavePCAInfoToServer(ConfigInfo, PaPatInfo, CardInfo, AccInfo, DepositInfo, CardINVInfo, SepcialInfo, ExpStr)
		b ;1.1.1.10
		
		
		;b ;w status,!
		if +status=0 {
			b ;ok1
			s msgobj.PatientID=$p(status,$c(1),5)
			b //z1
			i ..IsIDCardType(RequestObj,PatDetail) {
			b //z2
			;s tmpOBJ=##class(User.PAPerson).%OpenId(msgobj.PatientID)
			b //z3
			;s tmpOBJ.PAPERID=PatDetail.IDNo
			b //z4
			;d tmpOBJ.%Save()
			b //z5
			}
			
			s msgobj.ResultCode="000"
			s msgobj.ErrorMsg="注册成功"
		}
		elseif status=-371
		{
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="注册失败:卡号前缀有误"
		}
		elseif status=-302
		{
			b ;ok2
			s msgobj.PatientID=$p(status,$c(1),5)
			s msgobj.ResultCode="000"
			s msgobj.ErrorMsg="注册失败:此病人已经有正常的卡了,不能发卡"
		}
		elseif status=-303
		{
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="注册失败:卡号不能为空"
		}
		elseif status=-304
		{
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="注册失败:此卡号已经存在,不能发卡"
		}
		elseif status=-365
		{
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="注册失败:此病人已经拥有一张有效的银医卡,请办理其他卡或办理补卡"
		}
		elseif status=-366
		{
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="注册失败:请选择卡类型"
		}
		elseif status=-367
		{
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="注册失败:证件号码不能为空"
		}
		elseif status=-369
		{
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="注册失败:办理卡绑定时,获取患者信息错误"
		}
		elseif status=-370
		{
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="注册失败:卡号长度与系统设定不一致"
			
		}
		else
		{
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="注册失败:错误代码"_status
		}
}
 ;b ;end
 b ;1.1.1.11
	q msgobj
	
SendMsgError
    zn "websrc"
    s msgobj=##class(dhcinterface.BankReturnMsg).%New() 
	s msgobj.ResultCode="001"
	s msgobj.ErrorMsg="ToRegister函数异常:"_$ZERROR
	q msgobj
}

/// R02:换卡
ClassMethod ChangeCard(RequestObj As dhcinterface.BankSendMsg) As dhcinterface.BankReturnMsg
{
	s msgobj=##class(dhcinterface.BankReturnMsg).%New()
	for i=1:1:RequestObj.PatientDetails.Count()
	{
		s PatDetail=RequestObj.PatientDetails.GetAt(i)
		s msgobj.PatientID=PatDetail.PatientID
		s CardInfo=##class(web.DHCEntity.PCA.CardStatusChange).%New()
		s obj=##class(User.PAPerson).%OpenId(PatDetail.PatientID) 
		i obj="" {
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="换卡失败:病人唯一索引不合法"
			q 
		}
		s CardInfo.PatientID=PatDetail.PatientID
	
		s CardTypeCode=RequestObj.BankCode
		;s CardTypeCode="YYK"
		s rtn=..GetCardTypeByCode(CardTypeCode)
		s CardTypeDR=$p(rtn,"^",1)
		i CardTypeDR="" {
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="换卡失败:卡类型不合法"
			q 
		}
		s CardInfo.CardTypeDefine=CardTypeDR
		
		s CardID=..GetCardIDByCardNO(PatDetail.OldPatientCard,CardTypeDR)
		/*
		i CardID="" {
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="换卡失败:旧卡卡号不合法"
			q 
		}
		*/
		s ChkPatient=..GetPAPersonByCardNO(PatDetail.OldPatientCard,CardTypeDR,"N")
		i ChkPatient'=""
		{
		    i (ChkPatient'=PatDetail.PatientID){
				s msgobj.PatientID=ChkPatient
			   	s msgobj.ResultCode="001"
			    s msgobj.ErrorMsg="换卡失败:其他病人拥有此旧卡号，状态为正常" 
			    q
		    }
			
		}
		s ChkPatient=..GetPAPersonByCardNO(PatDetail.OldPatientCard,CardTypeDR,"S")
		i ChkPatient'=""
		{
		    i (ChkPatient=PatDetail.PatientID){
			   	;s msgobj.ResultCode="001"
			    ;s msgobj.ErrorMsg="换卡失败:病人拥有此旧卡号，状态为挂失" 
			    
		    }else{
				s msgobj.PatientID=ChkPatient
			   	s msgobj.ResultCode="001"
			    s msgobj.ErrorMsg="换卡失败:其他病人拥有此旧卡号，状态为挂失" 
			    q
		    }
			
		}
		s ChkPatient=..GetPAPersonByCardNO(PatDetail.OldPatientCard,CardTypeDR,"D")
		i ChkPatient'=""
		{
		    i (ChkPatient=PatDetail.PatientID){
			   	s msgobj.ResultCode="001"
			    s msgobj.ErrorMsg="换卡失败:病人拥有此旧卡号，状态为作废" 
			    
		    }else{
				s msgobj.PatientID=ChkPatient
			   	s msgobj.ResultCode="001"
			    s msgobj.ErrorMsg="换卡失败:其他病人拥有此旧卡号，状态为作废" 
		    }
			q
		}

		s CardInfo.CardNo=PatDetail.OldPatientCard
		s CardInfo.CardID=CardID
		/*
		s CardStatus=##class(web.DHCBL.CARD.CardManager).GetCardStatus(CardID)
		i CardStatus="S"
		{
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="换卡失败:旧卡已经处于挂失状态"
			q 
		}
		elseif CardStatus="D"
		{
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="换卡失败:旧卡已经处于作废状态"
			q 
		}
		elseif CardStatus="R"
		{
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="换卡失败:旧卡已经处于回收状态"
			q 
		}		
		elseif CardStatus="" 
		{
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="换卡失败:旧卡状态不合法"
			q 
		}
*/
		
		s CardID=..GetCardIDByCardNO(PatDetail.PatientCard,CardTypeDR)
		/*
		i CardID'="" {
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="换卡失败:新卡号已被使用"
			q 
		}
		*/
		s ChkPatient=..GetPAPersonByCardNO(PatDetail.PatientCard,CardTypeDR,"N")
		i ChkPatient'=""
		{
		    i (ChkPatient=PatDetail.PatientID)
		    {
			   s msgobj.ResultCode="000"
			   s msgobj.ErrorMsg="换卡成功" 
			}
			else
		    {
				s msgobj.PatientID=ChkPatient
			   	s msgobj.ResultCode="001"
			    s msgobj.ErrorMsg="换卡失败:其他病人拥有此新卡号，状态为正常" 
			    
		    }
			q
		}
		s ChkPatient=..GetPAPersonByCardNO(PatDetail.PatientCard,CardTypeDR,"S")
		i ChkPatient'=""
		{
		    i (ChkPatient=PatDetail.PatientID){
			   	s msgobj.ResultCode="001"
			    s msgobj.ErrorMsg="换卡失败:病人拥有此新卡号，状态为挂失" 
			    
		    }else{
				s msgobj.PatientID=ChkPatient
			   	s msgobj.ResultCode="001"
			    s msgobj.ErrorMsg="换卡失败:其他病人拥有此新卡号，状态为挂失" 
		    }
			q
		}
		s ChkPatient=..GetPAPersonByCardNO(PatDetail.PatientCard,CardTypeDR,"D")
		i ChkPatient'=""
		{
		    i (ChkPatient=PatDetail.PatientID){
			   	s msgobj.ResultCode="001"
			    s msgobj.ErrorMsg="换卡失败:病人拥有此新卡号，状态为作废" 
			    
		    }else{
				s msgobj.PatientID=ChkPatient
			   	s msgobj.ResultCode="001"
			    s msgobj.ErrorMsg="换卡失败:其他病人拥有此新卡号，状态为作废" 
		    }
			q
		}

		s CardInfo.ExchangeCardNo=PatDetail.PatientCard
		;s CardInfo.ActiveFlag="N"
		s CardInfo.ComputerIP=RequestObj.BankCode
		s CardInfo.UserDR=RequestObj.UserDR
		
		s CardInfo.RLName=PatDetail.Name
		;s CardInfo.ActiveFlag="N"
		s CredTypeDR=..GetCredType(RequestObj,PatDetail)
		i CredTypeDR=""	{
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="换卡失败:证件类型值不合法"
			q 
		}	

		s CardInfo.RLCredType=CredTypeDR
		s CardInfo.RLCredTypeID=CredTypeDR
		s CardInfo.RLCredNo=PatDetail.IDNo
		s CardInfo.RLAddress=PatDetail.Address
		s CardInfo.RLPhoneNo=PatDetail.TelephoneNo
		;s BankDR=..GetOrganByCode(RequestObj.BankCode)
		;i BankDR="" {
		;	 s msgobj.ResultCode="001"
		;	 s msgobj.ErrorMsg="注册失败:机构不存在"
		;	 q
		;}
		;s CardInfo.Organ=BankDR
		
		s rtn=CardInfo.XMLExportToString(.XML,"DHCCardStatusChange")
		i ($system.Status.IsError(rtn)) {
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="换卡失败:序列化对象失败"
			q
		}
		s status=..CardExechange(XML)
		if status'="0" {
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="换卡失败：错误号"_status
		}
		else
		{
			s msgobj.ResultCode="000"
			s msgobj.ErrorMsg="换卡成功"
		}
	}
	q msgobj
}

/// R03:挂失
ClassMethod DeclareCardLost(RequestObj As dhcinterface.BankSendMsg) As dhcinterface.BankReturnMsg
{
	s msgobj=##class(dhcinterface.BankReturnMsg).%New()
	for i=1:1:RequestObj.PatientDetails.Count()
	{
		s PatDetail=RequestObj.PatientDetails.GetAt(i)
		s CardInfo=##class(web.DHCEntity.PCA.CardStatusChange).%New()
			s msgobj.PatientID=PatDetail.PatientID
		s obj=##class(User.PAPerson).%OpenId(PatDetail.PatientID) 
		i obj="" {
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="挂失失败:病人唯一索引不合法"
			q 
		}
		s CardInfo.PatientID=PatDetail.PatientID
	
		s CardTypeCode=RequestObj.BankCode
		;s CardTypeCode="YYK"
		s rtn=..GetCardTypeByCode(CardTypeCode)
		s CardTypeDR=$p(rtn,"^",1)
		i CardTypeDR="" {
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="挂失失败:卡类型不合法"
			q 
		}
		
		s CardID=..GetCardIDByCardNO(PatDetail.PatientCard,CardTypeDR)
		;w PatDetail.PatientCard,!
		;w CardTypeDR,!,"aa",CardID
		b //2
		i CardID="" {
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="挂失失败:卡号不合法"
			q 
		}
		b //1
		s ChkPatient=..GetPAPersonByCardNO(PatDetail.PatientCard,CardTypeDR,"N")
		i ChkPatient'=""
		{
		    i (ChkPatient'=PatDetail.PatientID)
		    {
				s msgobj.PatientID=ChkPatient
			   	s msgobj.ResultCode="001"
			    s msgobj.ErrorMsg="挂失失败:其他病人拥有此卡号，状态为正常" 
			    q
		    }
			
		}
		s ChkPatient=..GetPAPersonByCardNO(PatDetail.PatientCard,CardTypeDR,"S")
		i ChkPatient'=""
		{
		    i (ChkPatient=PatDetail.PatientID){
			   	s msgobj.ResultCode="000"
			    s msgobj.ErrorMsg="挂失成功" 
			    
		    }else{
				s msgobj.PatientID=ChkPatient
			   	s msgobj.ResultCode="001"
			    s msgobj.ErrorMsg="挂失失败:其他病人拥有此卡号，状态为挂失" 
		    }
			q
		}
		s ChkPatient=..GetPAPersonByCardNO(PatDetail.PatientCard,CardTypeDR,"D")
		i ChkPatient'=""
		{
		    i (ChkPatient=PatDetail.PatientID){
			   	s msgobj.ResultCode="001"
			    s msgobj.ErrorMsg="挂失失败:病人拥有此卡号，状态为作废" 
			    
		    }else{
				s msgobj.PatientID=ChkPatient
			   	s msgobj.ResultCode="001"
			    s msgobj.ErrorMsg="挂失失败:其他病人拥有此卡号，状态为作废" 
		    }
			q
		}

		s CardInfo.CardNo=PatDetail.PatientCard
		s CardInfo.CardID=CardID
		
		s CardStatus=..GetCardStatus(CardID)
		/*
		i CardStatus="" 
		{
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="挂失失败:卡状态不合法"
			q 
		}
		elseif CardStatus="S"
		{
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="挂失失败:卡已经处于挂失状态"
			q 
		}
		elseif CardStatus="D"
		{
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="挂失失败:卡已经处于作废状态"
			q 
		}
		elseif CardStatus="R"
		{
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="挂失失败:卡已经处于回收状态"
			q 
		}
*/
		;s CardInfo.ActiveFlag="N"
		s CardInfo.ComputerIP=RequestObj.BankCode
		s CardInfo.UserDR=RequestObj.UserDR
		
		s PatInfo=##class(User.PAPerson).%OpenId(PatDetail.PatientID)
		s CardInfo.RLName=PatInfo.PAPERName
		s CardInfo.RLPhoneNo=PatInfo.PAPERTelH
		s:PatInfo.PAPERStName.Count()'=0 CardInfo.RLAddress=PatInfo.PAPERStName.GetAt(PatInfo.PAPERStName.Count())
		s PatInfo=##class(User.PAPatMas).%OpenId(PatDetail.PatientID)
		s CardInfo.RLCredTypeID=PatInfo.PAPMICardTypeDR.%Id()
		s CardInfo.RLCredNo=PatInfo.PAPMIDVAnumber
		s CardInfo.RLCredType=PatDetail.IDType
		;s PPAPersonInfo.OldPatientCard=PatDetail.OldPatientCard
		
		;s BankDR=..GetOrganByCode(RequestObj.BankCode)
		;i BankDR="" {
		;	 s msgobj.ResultCode="001"
		;	 s msgobj.ErrorMsg="注册失败:HXOrgan机构不存在"
		;	 q
		;}
		;s CardInfo.Organ=BankDR
		
		s rtn=CardInfo.XMLExportToString(.XML,"DHCCardStatusChange")
		i ($system.Status.IsError(rtn)) {
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="挂失失败:序列化对象失败"
			q
		 }
		s status=##class(web.DHCBL.CARD.UCardStatusChangeBuilder).CardReportOrCancelLoss(XML,CardStatus)
		if status'="0" {
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="挂失失败：错误号"_status
		}
		else
		{
			s msgobj.ResultCode="000"
			s msgobj.ErrorMsg="挂失成功"
		}
	}

	q msgobj
}

/// R04:撤消挂失
ClassMethod RecallCard(RequestObj As dhcinterface.BankSendMsg) As dhcinterface.BankReturnMsg
{
	s msgobj=##class(dhcinterface.BankReturnMsg).%New()
	for i=1:1:RequestObj.PatientDetails.Count()
	{
		s PatDetail=RequestObj.PatientDetails.GetAt(i)
		s CardInfo=##class(web.DHCEntity.PCA.CardStatusChange).%New()
		s obj=##class(User.PAPerson).%OpenId(PatDetail.PatientID) 
		s msgobj.PatientID=PatDetail.PatientID
		i obj="" {
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="撤消挂失失败:病人唯一索引不合法"
			q 
		}
		s CardInfo.PatientID=PatDetail.PatientID
		
		s CardTypeCode=RequestObj.BankCode
		;s CardTypeCode="YYK"
		s rtn=..GetCardTypeByCode(CardTypeCode)
		s CardTypeDR=$p(rtn,"^",1)
		i CardTypeDR="" {
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="撤消挂失失败:卡类型不合法"
			q 
		}
		
		s CardID=..GetCardIDByCardNO(PatDetail.PatientCard,CardTypeDR)
		
		i CardID="" {
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="撤消挂失失败:卡号不合法"
			q 
		}
		
		s ChkPatient=..GetPAPersonByCardNO(PatDetail.PatientCard,CardTypeDR,"N")
		i ChkPatient'=""
		{
		    i (ChkPatient=PatDetail.PatientID)
		    {
			    s msgobj.ResultCode="000"
			    s msgobj.ErrorMsg="撤消挂失成功" 
			}
			else
		    {
				s msgobj.PatientID=ChkPatient
			   	s msgobj.ResultCode="001"
			    s msgobj.ErrorMsg="撤消挂失失败:其他病人拥有此卡号，状态为正常" 
		    }
			q
		}
		s ChkPatient=..GetPAPersonByCardNO(PatDetail.PatientCard,CardTypeDR,"S")
		i ChkPatient'=""
		{
		    i (ChkPatient'=PatDetail.PatientID){
				s msgobj.PatientID=ChkPatient
			   	s msgobj.ResultCode="001"
			    s msgobj.ErrorMsg="撤消挂失失败:其他病人拥有此卡号，状态为挂失" 
			    q
		    }
			
		}
		s ChkPatient=..GetPAPersonByCardNO(PatDetail.PatientCard,CardTypeDR,"D")
		i ChkPatient'=""
		{
		    i (ChkPatient=PatDetail.PatientID){
			   	s msgobj.ResultCode="001"
			    s msgobj.ErrorMsg="撤消挂失失败:病人拥有此卡号，状态为作废" 
			    
		    }else{
				s msgobj.PatientID=ChkPatient
			   	s msgobj.ResultCode="001"
			    s msgobj.ErrorMsg="撤消挂失失败:其他病人拥有此卡号，状态为作废" 
		    }
			q
		}
		s CardInfo.CardNo=PatDetail.PatientCard
		s CardInfo.CardID=CardID
		
		s CardStatus=..GetCardStatus(CardID)
		/*
		i CardStatus="" 
		{
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="撤消挂失失败:卡状态不合法"
			q 
		}
		elseif CardStatus="N"
		{
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="撤消挂失失败:卡已经处于正常状态"
			q 
		}
		elseif CardStatus="D"
		{
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="撤消挂失失败:卡已经处于作废状态"
			q 
		}
		elseif CardStatus="R"
		{
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="撤消挂失失败:卡已经处于回收状态"
			q 
		}
		*/

		;s CardInfo.ActiveFlag="N"
		s CardInfo.ComputerIP=RequestObj.BankCode
		s CardInfo.UserDR=RequestObj.UserDR
		
		s PatInfo=##class(User.PAPerson).%OpenId(PatDetail.PatientID)
		s CardInfo.RLName=PatInfo.PAPERName
		s CardInfo.RLPhoneNo=PatInfo.PAPERTelH
		s:PatInfo.PAPERStName.Count()'=0 CardInfo.RLAddress=PatInfo.PAPERStName.GetAt(PatInfo.PAPERStName.Count())
		s PatInfo=##class(User.PAPatMas).%OpenId(PatDetail.PatientID)
		s CardInfo.RLCredTypeID=PatInfo.PAPMICardTypeDR.%Id()
		s CardInfo.RLCredNo=PatInfo.PAPMIDVAnumber
		s CardInfo.RLCredType=PatDetail.IDType
		;s PPAPersonInfo.OldPatientCard=PatDetail.OldPatientCard
		
		;s BankDR=..GetOrganByCode(RequestObj.BankCode)
		;i BankDR="" {
		;	 s msgobj.ResultCode="001"
		;	 s msgobj.ErrorMsg="注册失败:HXOrgan机构不存在"
		;	 q
		;}
		;s CardInfo.Organ=BankDR
		
		s rtn=CardInfo.XMLExportToString(.XML,"DHCCardStatusChange")
		i ($system.Status.IsError(rtn)) {
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="撤消挂失失败:序列化对象失败"
			q
		 }
		s status=..CardReportOrCancelLoss(XML,CardStatus)
		if status'="0" {
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="撤消挂失失败:"_status
		}
		else
		{
			s msgobj.ResultCode="000"
			s msgobj.ErrorMsg="撤消挂失成功"
		}
	}
	q msgobj
}

/// R05:卡作废
ClassMethod RepealCard(RequestObj As dhcinterface.BankSendMsg) As dhcinterface.BankReturnMsg
{
	s msgobj=##class(dhcinterface.BankReturnMsg).%New()
	for i=1:1:RequestObj.PatientDetails.Count()
	{
		s PatDetail=RequestObj.PatientDetails.GetAt(i)
		s CardInfo=##class(web.DHCEntity.PCA.CardStatusChange).%New()
		s obj=##class(User.PAPerson).%OpenId(PatDetail.PatientID) 
		s msgobj.PatientID=PatDetail.PatientID
		i obj="" {
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="卡作废失败:病人唯一索引不合法"
			q 
		}
		s CardInfo.PatientID=PatDetail.PatientID
	
		s CardTypeCode=RequestObj.BankCode
		s rtn=..GetCardTypeByCode(CardTypeCode)
		s CardTypeDR=$p(rtn,"^",1)
		i CardTypeDR="" {
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="卡作废失败:卡类型不合法"
			q 
		}
		
		s CardID=..GetCardIDByCardNO(PatDetail.PatientCard,CardTypeDR)
		b ;卡号不合法
		i CardID="" {
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="卡作废失败:卡号不合法"
			q 
		}
		
		
		s ChkPatient=..GetPAPersonByCardNO(PatDetail.PatientCard,CardTypeDR,"N")
		i ChkPatient'=""
		{
		    i (ChkPatient'=PatDetail.PatientID)
		    {
				s msgobj.PatientID=ChkPatient
			   	s msgobj.ResultCode="001"
			    s msgobj.ErrorMsg="卡作废失败:其他病人拥有此卡号，状态为正常" 
			    q
		    }
		    
			
		}
		s ChkPatient=..GetPAPersonByCardNO(PatDetail.PatientCard,CardTypeDR,"S")
		i ChkPatient'=""
		{
		    i (ChkPatient'=PatDetail.PatientID){
				s msgobj.PatientID=ChkPatient
			   	s msgobj.ResultCode="001"
			    s msgobj.ErrorMsg="卡作废失败:其他病人拥有此卡号，状态为挂失" 
			    q
		    }
			
		}
		s ChkPatient=..GetPAPersonByCardNO(PatDetail.PatientCard,CardTypeDR,"D")
		i ChkPatient'=""
		{
		    i (ChkPatient=PatDetail.PatientID){
			   	s msgobj.ResultCode="000"
			    s msgobj.ErrorMsg="卡作废成功" 
			    
		    }else{
				s msgobj.PatientID=ChkPatient
			   	s msgobj.ResultCode="001"
			    s msgobj.ErrorMsg="卡作废失败:其他病人拥有此卡号，状态为作废" 
		    }
			q
		}

	
		s CardInfo.CardNo=PatDetail.PatientCard
		s CardInfo.CardID=CardID
		
		s CardStatus=##class(web.DHCBL.CARD.CardManager).GetCardStatus(CardID)
		/*
		i CardStatus="" 
		{
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="卡作废失败:卡状态不合法"
			q 
		}
		elseif CardStatus="D"
		{
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="卡作废失败:卡已经处于作废状态"
			q 
		}
*/
		;s CardInfo.ActiveFlag="N"
		s CardInfo.ComputerIP=RequestObj.BankCode
		s CardInfo.UserDR=RequestObj.UserDR
		
		s PatInfo=##class(User.PAPerson).%OpenId(PatDetail.PatientID)
		s CardInfo.RLName=PatInfo.PAPERName
		s CardInfo.RLPhoneNo=PatInfo.PAPERTelH
		s CardInfo.RLAddress=PatInfo.PAPERStName
		s PatInfo=##class(User.PAPatMas).%OpenId(PatDetail.PatientID)
		s CardInfo.RLCredTypeID=PatInfo.PAPMICardTypeDR.%Id()
		s CardInfo.RLCredNo=PatInfo.PAPMIDVAnumber
		s CardInfo.RLCredType=PatDetail.IDType
		;s PPAPersonInfo.OldPatientCard=PatDetail.OldPatientCard
		/*s BankDR=..GetOrganByCode(RequestObj.BankCode)
		i BankDR="" {
			 s msgobj.ResultCode="001"
			 s msgobj.ErrorMsg="注册失败:HXOrgan机构不存在"
			 q
		}
		s CardInfo.Organ=BankDR
		*/
		s rtn=CardInfo.XMLExportToString(.XML,"DHCCardStatusChange")
		i ($system.Status.IsError(rtn)) {
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="卡作废失败:序列化对象失败"
			q
		 }
		//s status=##class(web.DHCBL.CARD.UCardStatusChangeBuilder).CardRepeal(XML)
		s status=..CardRepeal(XML)
		if status'="0" {
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="卡作废失败:错误号："_status
		}
		else
		{
			s msgobj.ResultCode="000"
			s msgobj.ErrorMsg="卡作废成功"
		}
	}

	q msgobj
}

/// R06:变更病人基本信息
ClassMethod ChangePatientInfo(RequestObj As dhcinterface.BankSendMsg) As dhcinterface.BankReturnMsg
{
	s msgobj=##class(dhcinterface.BankReturnMsg).%New()
	for i=1:1:RequestObj.PatientDetails.Count()
	{
		s PatDetail=RequestObj.PatientDetails.GetAt(i)
		s PPAPersonInfo=##class(web.DHCEntity.PCA.PAPerson).%New()
		s msgobj.PatientID=PatDetail.PatientID
		s obj=##class(User.PAPerson).%OpenId(PatDetail.PatientID) 
		i obj="" {
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="更新病人信息失败:病人唯一索引不合法"
			q 

		}
		s PPAPersonInfo.ID=PatDetail.PatientID
		
		;s PPAPersonInfo.PatientCard=PatDetail.PatientCard
		s Sex=..GetSex(RequestObj,PatDetail)
		i Sex=""	{
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="更新病人信息失败:性别值不合法"
			q 
		}	
		s PPAPersonInfo.PAPERSexDR=Sex
		s Name=$tr(PatDetail.Name," ")
		i Name="" {
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="更新病人信息失败:病人姓名为空"
			q 
		}
		s PPAPersonInfo.PAPERName=Name
		
		i ..ValidDate(PatDetail.DOB) {
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="更新病人信息失败:出生日期不合法"
			q 

		}
		s PPAPersonInfo.PAPERDob=PatDetail.DOB
		s CardTypeDR=..GetCredType(RequestObj,PatDetail)
		i CardTypeDR=""	{
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="更新病人信息失败:证件类型值不合法"
			q 
		}	
		s PPAPersonInfo.PAPMICardTypeDR=CardTypeDR
		i ..IsIDCardType(RequestObj,PatDetail) {
			i ..ValidIdentityNO(PatDetail.IDNo) {
				s msgobj.ResultCode="001"
				s msgobj.ErrorMsg="更新病人信息失败:身份证号不合法"
				q 
			}
		}
		s PPAPersonInfo.PAPERID=PatDetail.IDNo
		s PPAPersonInfo.PAPERForeignAddress=PatDetail.Address
		s zipcode=$tr(PatDetail.Zip," ")
		&sql(select ctzip_rowid into :zipDR from sqluser.CT_Zip where ctzip_code=:zipcode)
		if zipDR'="" d
		.s PPAPersonInfo.PAPERZipDR=zipDR
		s PPAPersonInfo.PAPERTelH=PatDetail.TelephoneNo
		;s PPAPersonInfo.PAPERTelH=PatDetail.Mobile
		;s PPAPersonInfo.OldPatientCard=PatDetail.OldPatientCard
		s status=##class(web.DHCBL.Patient.DHCPatient).PAPersonUpdate(PPAPersonInfo)
		if status="-100" {
			s msgobj.ResultCode="001"
			s msgobj.ErrorMsg="更新病人信息失败"
		}
		else
		{
			s msgobj.ResultCode="000"
			s msgobj.ErrorMsg="更新病人信息成功"
		}
	}
	
	q msgobj
}

/// ****************************************************/
/// 获取卡类型ROWID
ClassMethod GetCardTypeByCode(CardTypeCode As %String) As %String
{
	n (CardTypeCode)
	s RRowid=""
	s Rowid="" f  s Rowid=$o(^DHCCARDTYPEDef(Rowid)) q:Rowid=""  d
	.s Code=$p($g(^DHCCARDTYPEDef(Rowid)),"^",1)
	.i Code=CardTypeCode d
	..s RRowid=Rowid
	q RRowid
}

/// 根据卡CardNO获取卡CardID
ClassMethod GetCardIDByCardNO(CardNo As %String, CardTypeDR As %String) As %String
{
	s CardID=""
	set cardRowID=""
	set cardRowID=$o(^DHCCARDi("CF",0,"CardNo",CardNo,cardRowID))
	while(cardRowID'="")
	{
		set CardType=$p($g(^DHCCARD("CF",cardRowID)),"^",16)
		set status=$p($g(^DHCCARD("CF",cardRowID)),"^",10)
		if CardType=CardTypeDR,status'="D"
		{
			set CardID=cardRowID
		}
		set cardRowID=$o(^DHCCARDi("CF",0,"CardNo",CardNo,cardRowID))
	}
    q CardID
}

/// 获取性别指针
ClassMethod GetSex(RequestObj As dhcinterface.BankSendMsg, PatDetail As dhcinterface.BankPatDetail) As %String
{
	s SexDR=""
	s SexCode=""
	;转换证件类型代码
	
	i (PatDetail.Sex="F")!(PatDetail.Sex="M")!(PatDetail.Sex="N")
	{
		s Sex=PatDetail.Sex
		&sql(select ctsex_rowid,ctsex_code into:SexDR,:SexCode from sqluser.ct_sex where ctsex_code=:Sex)
	}
	q SexDR
}

/// 获取证件类型指针
ClassMethod GetCredType(RequestObj As dhcinterface.BankSendMsg, PatDetail As dhcinterface.BankPatDetail) As %String
{
	s CredTypeDR=""
	s CredTypeCode=""
	;转换证件类型代码
	;身份证
   i PatDetail.IDType="01" {
   &sql(select card_rowid,card_code into:CredTypeDR,:CredTypeCode from sqluser.pac_cardtype where card_code='01')
   }
    ;军官证
   i PatDetail.IDType="02" {
   &sql(select card_rowid,card_code into:CredTypeDR,:CredTypeCode from sqluser.pac_cardtype where card_code='02')
   }
   ;其他
   i PatDetail.IDType="03" {
   &sql(select card_rowid,card_code into:CredTypeDR,:CredTypeCode from sqluser.pac_cardtype where card_code='07')
   }  
   
   
   ;解放军文职干部证
   i PatDetail.IDType="04" {
   &sql(select card_rowid,card_code into:CredTypeDR,:CredTypeCode from sqluser.pac_cardtype where card_code='08')
   }
   ;警官证
   i PatDetail.IDType="05" {
   &sql(select card_rowid,card_code into:CredTypeDR,:CredTypeCode from sqluser.pac_cardtype where card_code='09')
   } 
   ;解放军士兵证 
   i PatDetail.IDType="06" {
   &sql(select card_rowid,card_code into:CredTypeDR,:CredTypeCode from sqluser.pac_cardtype where card_code='10')
   }
   ;户口薄
   i PatDetail.IDType="07" {
   &sql(select card_rowid,card_code into:CredTypeDR,:CredTypeCode from sqluser.pac_cardtype where card_code='11')
   }
   ;港澳回乡证通行证
   i PatDetail.IDType="08" {
   &sql(select card_rowid,card_code into:CredTypeDR,:CredTypeCode from sqluser.pac_cardtype where card_code='12')
   }
   
   ;台通行证及其他有效旅行证
   i PatDetail.IDType="09" {
   &sql(select card_rowid,card_code into:CredTypeDR,:CredTypeCode from sqluser.pac_cardtype where card_code='17')
   }
   
   ;外国护照
   i PatDetail.IDType="10" {
   &sql(select card_rowid,card_code into:CredTypeDR,:CredTypeCode from sqluser.pac_cardtype where card_code='13')
   }
   ;中国护照
   i PatDetail.IDType="11" {
   &sql(select card_rowid,card_code into:CredTypeDR,:CredTypeCode from sqluser.pac_cardtype where card_code='14')
   }
   ;武警文职干部证
   i PatDetail.IDType="12" {
   &sql(select card_rowid,card_code into:CredTypeDR,:CredTypeCode from sqluser.pac_cardtype where card_code='15')
   }
   ;武警士兵证
   i PatDetail.IDType="13" {
   &sql(select card_rowid,card_code into:CredTypeDR,:CredTypeCode from sqluser.pac_cardtype where card_code='16')
   }

 q CredTypeDR
}

/// 验证身份证号码
ClassMethod ValidIdentityNO(para As %String) As %String
{
	s val=para?1(15N,17N1(1N,1U))
	q 'val
}

/// 日期检查
ClassMethod ValidDate(para As %String) As %String
{
	n (para)
	s val=para?4N1"-"2N1"-"2N
	q 'val
}

/// 根据卡类型，卡号，卡状态获取病人集合
ClassMethod GetPAPersonByCardNO(CardNO As %String, CardTypeID As %String, CardStatus As %String) As %String
{
	s PatientID=""
	s RowId=$o(^DHCCARDi("CF",0,"CardNo",CardNO,0))
	while(RowId'="")
	{
		s cardtype=""
 		if ($g(^DHCCARD("CF",RowId))'="") s cardtype=$p($g(^DHCCARD("CF",RowId)),"^",16)
 		s status=$p(^DHCCARD("CF",RowId),"^",10)
		s:status="" status="N"
 		if cardtype=CardTypeID,status=CardStatus {
	 		if PatientID="" {
		 		s PatientID=$p(^DHCCARD("CF",RowId),"^",4)
	 		}
	 		else
	 		{
				s PatientID=PatientID_"^"_$p(^DHCCARD("CF",RowId),"^",4)
	 		}
 		}
		s RowId=$o(^DHCCARDi("CF",0,"CardNo",CardNO,RowId))
	}
   
    quit PatientID
}

/// 根据卡CardID获取卡状态
ClassMethod GetCardStatus(CardID As %String) As %String
{
	set status=$p($g(^DHCCARD("CF",CardID)),"^",10)
	quit status
}

ClassMethod CardRepeal(CardStatusChangeInfo As %String) As %String
{
	s StatusInfo=##class(web.DHCEntity.PCA.CardStatusChange).%New()
	d StatusInfo.XMLNodeDeserialize(.StatusInfo,"DHCCardStatusChange",CardStatusChangeInfo)
	
	TStart
	set rtn=0
	;1.验证卡状态
	set status=##class(web.DHCBL.CARD.CardManager).GetCardStatus(StatusInfo.CardID)
	if status="D" {
		set rtn= -359 ;作废的卡不能再进行作废
	}
	
	s myCardRegConfig=##class(web.DHCBL.CARD.CardPATRegConfig).GetCardPatRegConfig()
	s myCardRefFlag=$p(myCardRegConfig, "^", 5)
	s myAccManageFLag= $p(myCardRegConfig, "^", 6)
	;2.作废卡
	if ((myCardRefFlag="Y")&&(+rtn=0)) {
		set StatusInfo.ActiveFlag="D"
		set rtn=##class(web.DHCBL.CARD.CardStatusChange).UpdateCardStatus(StatusInfo)
		set rtn=+rtn
	}
	
	;2.写作废卡状态记录
	if ((myCardRefFlag="Y")&&(+rtn=0)) {
		set StatusInfo.ActiveFlag="D"
		set rtn=##class(web.DHCBL.CARD.CardStatusChange).Insert(StatusInfo)
		set rtn=+rtn
	}
	;3.根据帐户配置,如果有帐户信息,更新帐户状态
	if ((myAccManageFLag="Y")&&(+rtn=0)) {
		set CardAccStatus=##class(web.DHCBL.CARD.CardManager).GenerateoCardAccStatus(StatusInfo,"N")
		if CardAccStatus.AccountID'=""
		{
			set myStatusInfo=##class(web.DHCBL.CARD.UCardAccStatusChange).Insert(CardAccStatus)
			i (+myStatusInfo<0){
				s rtn=+myStatusInfo
			}
			
		}
	}
	
	if (+rtn=0)
	{
		TCommit
	}
	else
	{
		TRollback
	}
	quit rtn
}

ClassMethod CardExechange(CardStatusChangeInfo As %String) As %String
{
	set ^ozrtest(100)=CardStatusChangeInfo
	s StatusInfo=##class(web.DHCEntity.PCA.CardStatusChange).%New()
	d StatusInfo.XMLNodeDeserialize(.StatusInfo,"DHCCardStatusChange",CardStatusChangeInfo)
	
	TStart
	set rtn=0
	;1.验证卡状态
	set status=##class(web.DHCBL.CARD.CardManager).GetCardStatus(StatusInfo.CardID)
	if status="D" {
		set rtn= -359 ;作废的卡不能再进行换卡
	}
	elseif status="S" {
		s CardTypeDR=StatusInfo.CardTypeDefine
		s supLossExchange=$p(^DHCCARDTYPEDef(CardTypeDR),"^",37)
		if (supLossExchange="")||(supLossExchange="N") {
			set rtn= -360 ;正常状态的卡不能进行换卡
		}

	}
	
	s myCardRegConfig=##class(web.DHCBL.CARD.CardPATRegConfig).GetCardPatRegConfig()
	s myCardRefFlag=$p(myCardRegConfig, "^", 5)
	s myAccManageFLag= $p(myCardRegConfig, "^", 6)
	;2.作废卡
	if ((myCardRefFlag="Y")&&(+rtn=0)) {
		set StatusInfo.ActiveFlag="D"
		set rtn=##class(web.DHCBL.CARD.CardStatusChange).UpdateCardStatus(StatusInfo)
		set rtn=+rtn
	}
	
	;2.写作废卡状态记录
	if ((myCardRefFlag="Y")&&(+rtn=0)) {
		set StatusInfo.ActiveFlag="D"
		set rtn=##class(web.DHCBL.CARD.CardStatusChange).Insert(StatusInfo)
		set rtn=+rtn
	}
	;3.根据帐户配置,如果有帐户信息,更新帐户状态
	if ((myAccManageFLag="Y")&&(+rtn=0)) {
		set CardAccStatus=##class(web.DHCBL.CARD.CardManager).GenerateoCardAccStatus(StatusInfo,"N")
		if CardAccStatus.AccountID'=""
		{
			set myStatusInfo=##class(web.DHCBL.CARD.UCardAccStatusChange).Insert(CardAccStatus)
			i (+myStatusInfo<0){
				s rtn=+myStatusInfo
			}
			
		}
	}
	
	;4.新增卡
	if ((myCardRefFlag="Y")&&(+rtn=0)) {
		set StatusInfo.ActiveFlag="N"
		set rtn=##class(web.DHCBL.CARD.CardStatusChange).InsertCard(StatusInfo)
		set StatusInfo.CardID=$piece(rtn,"^",2)
		set rtn=+rtn
	}
	;5.写新增卡状态记录
	if ((myCardRefFlag="Y")&&(+rtn=0)) {
		set StatusInfo.ActiveFlag="N"
		set rtn=##class(web.DHCBL.CARD.CardStatusChange).Insert(StatusInfo)
		set rtn=+rtn
	}
	;6.根据帐户配置,新增帐户状态
	if myAccManageFLag="Y" {
		set CardAccStatus=##class(web.DHCBL.CARD.CardManager).GenerateoCardAccStatus(StatusInfo,"N")
		if CardAccStatus.AccountID'=""
		{
			set myStatusInfo=##class(web.DHCBL.CARD.UCardAccStatusChange).Insert(CardAccStatus)
			if (+myStatusInfo<0){
				s rtn=+myStatusInfo
			}
		}
	}
	;7.Update病人信息  ljq 2009-03-25
	if ((myCardRefFlag="Y")&&(+rtn=0)) {
		s rtn=..UpdatePAPerson(StatusInfo)
		s rtn=+rtn
	}
	
	if (+rtn=0)
	{
		TCommit
	}
	else
	{
		TRollback
	}
	quit rtn
}

ClassMethod CardReportOrCancelLoss(CardStatusChangeInfo As %String, oldstatus As %String) As %String
{
	s ^TMPZCZDFDFDD=$lb(CardStatusChangeInfo, oldstatus)
	set StatusInfo=##class(web.DHCEntity.PCA.CardStatusChange).%New()
	do StatusInfo.XMLNodeDeserialize(.StatusInfo,"DHCCardStatusChange",CardStatusChangeInfo)
	set myrtn=0
	;1.验证卡状态	
	set status=##class(web.DHCBL.CARD.CardManager).GetCardStatus(StatusInfo.CardID)
	
	if status'=oldstatus 
	{
		if oldstatus="N" 		
		{
			set myrtn=-355 ;非正常卡不能挂失			
		}
		elseif(oldstatus="S")
		{
			set myrtn=-356 ;非挂失卡不能取消挂失
		}
		quit myrtn
	}
	
	s myCardRegConfig=##class(web.DHCBL.CARD.CardPATRegConfig).GetCardPatRegConfig()
	
	s myCardRefFlag=$p(myCardRegConfig, "^", 5)
	s myAccManageFLag= $p(myCardRegConfig, "^", 6)
	
	TSTART
	;2.1 挂失卡
	if ((myCardRefFlag="Y")&&(+myrtn=0)) {
		if oldstatus="N"
		{
			set StatusInfo.ActiveFlag="S"
		}
		if (oldstatus="S")
		{
			set StatusInfo.ActiveFlag="N"
		}
		set myrtn=##class(web.DHCBL.CARD.CardStatusChange).UpdateCardStatus(StatusInfo)
		set myrtn=+myrtn
	}	
	
	b	;;2.2 写挂失卡状态记录
	if ((myCardRefFlag="Y")&&(+myrtn=0)) {
		if oldstatus="N"
		{
			set StatusInfo.ActiveFlag="S"
		}
		if (oldstatus="S")
		{
			set StatusInfo.ActiveFlag="N"
		}
		set myrtn=##class(web.DHCBL.CARD.CardStatusChange).Insert(StatusInfo)
		set myrtn=+myrtn
		
	}
	b	;3.根据帐户配置,如果有帐户信息,更新帐户状态
	
	if ((myAccManageFLag="Y")&&(+myrtn=0)) 
	{
		if oldstatus="N"
		{
			set CardAccStatus=##class(web.DHCBL.CARD.CardManager).GenerateoCardAccStatus(StatusInfo,"S")
		}
		else
		{
			set CardAccStatus=##class(web.DHCBL.CARD.CardManager).GenerateoCardAccStatus(StatusInfo,"N")
		}
		if CardAccStatus.AccountID'=""
		{
			set myStatusInfo=##class(web.DHCBL.CARD.UCardAccStatusChange).Insert(CardAccStatus)
			if (+myStatusInfo<0){
				s myrtn=+myStatusInfo
			}
			set myrtn=+myrtn
		}
	}
	
	if (+myrtn=0)
	{
		TCommit
	}
	else
	{
		TRollback
	}
	quit myrtn
}

/// 判断是否为身份证类型
ClassMethod IsIDCardType(RequestObj As dhcinterface.BankSendMsg, PatDetail As dhcinterface.BankPatDetail) As %String
{
	s rtn=0
	;转换证件类型代码
	i RequestObj.BankCode="CCB" //建行
	{
	   i PatDetail.IDType="A" {
	   		s rtn=1
	   }

	}
	q rtn
}

ClassMethod UpdatePAPerson(CardStatusInfo As web.DHCEntity.PCA.CardStatusChange) As %String
{
	s PAPMIDR=CardStatusInfo.PatientID
	Q:PAPMIDR="" "-910"
	TStart
	//姓名，地址，联系电话，证件号
	s Name=CardStatusInfo.RLAddress
	s Address=CardStatusInfo.RLAddress
	s Phone=CardStatusInfo.RLPhoneNo
	s PAPersonObj=##class(User.PAPerson).%OpenId(PAPMIDR)
	S PAPersonObj.PAPERName=CardStatusInfo.RLName //姓名
	S ^PAPER(PAPMIDR,"PER","ADD",1)=CardStatusInfo.RLAddress //地址
	S PAPersonObj.PAPERTelH=CardStatusInfo.RLPhoneNo //联系电话
	s sc=PAPersonObj.%Save()
	if $$$ISERR(sc)  d
	.Do $System.Status.DisplayError(sc)
	.Trollback
	.s ErrCode="-911"
	else  d
	.s ErrCode=""
	.TCommit
	;s ^ljqtemp("test")=ErrCode_"^"_CardStatusInfo.RLName_"^"_CardStatusInfo.RLAddress_"^"_CardStatusInfo.RLPhoneNo
	q ErrCode
}

}
