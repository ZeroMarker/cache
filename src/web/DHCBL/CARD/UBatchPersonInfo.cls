/// 对于加载批量数据的操作
Class web.DHCBL.CARD.UBatchPersonInfo Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 身份证件类型代码
Parameter IDCardTypeCode = 01;

ClassMethod GroupSinglePersonInfoReg(UserDR As %String, BPersonRowID As %String, CardNo As %String, CardTypeDR As %String, SecurityNo As %String, ExpStr As %String) As %String
{
	;w ##class(web.DHCBL.CARD.UBatchPersonInfo).GroupSinglePersonInfoReg(6,"3||1","0000121212", 2)
	s ^TMPGSPIR=$lb(UserDR , BPersonRowID , CardNo , CardTypeDR , ExpStr )
	s myPersonInfo=##class(User.DHCCardGroupPerson).%OpenId(BPersonRowID)
	
	;本数据已经被导入了
	
	q:(myPersonInfo.CGPRegStatus'="N") -202
	
	ts
	
	s myrtn=0
	
	s myPatObj=##class(web.DHCEntity.PCA.PATMAS).%New()
	s myCardObj=##class(web.DHCEntity.PCA.CardRef).%New()
	if $IsObject(myCardObj) d
	.d myCardObj.ExchangeData(myPersonInfo)
	if $IsObject(myPatObj) d
	.d myPatObj.ExchangeData(myPersonInfo)
	
	s myCardObj.CardNo=CardNo
	s myCardObj.UserDR=UserDR
	
	;^PAC("CARD",{CRT_RowID})
	i myPersonInfo.CredType'="" d
	.s myIDCode=$p(^PAC("CARD",myPersonInfo.CredType),"^",1)
	.q:(myIDCode'=..#IDCardTypeCode)
	.s myPatObj.IDCardNo1 = myPersonInfo.CredNo
	
	s myCardObj.CardTypeDefine=CardTypeDR
	
	s myIDNo = myPatObj.IDCardNo1
	s myCredTypeDR= myPatObj.CredType
	s myCredNo = myPatObj.CredNo
	s myCardTypeDR= myCardObj.CardTypeDefine
	
	s ConfigInfo= ##class(web.DHCBL.CARD.UCardPATRegConfig).ReadGroupConfigByDR(myCardTypeDR)
	
	s myInfo=##class(web.DHCBL.CARD.UCardPATRegConfig).ReadConfigByIDU(myIDNo, myCredTypeDR, myCredNo, myCardTypeDR)
	
	s myInfoRtn=$p(myInfo,$c(1),1)
	i +myInfoRtn=0 d
	.
	
	i (+myInfoRtn=-368) d
	.;myrtn_$c(1)_myConfiXmlData_$c(1)_myPatXmlData_$c(1)_myRepairFlag_$c(1)_myConfingStr_$c(1)
	.s ConfigInfo=$p(myInfo,$c(1),2)
	.s ConfigInfo=##class(web.DHCBL.CARD.UCardPATRegConfig).ReadGroupConfigByXMLData(ConfigInfo)
	.s myOverLayFlag=$p(myInfo,$c(1),4)
	.i myOverLayFlag="Y" d
	..;回调信息能够修改， Excel传入的信息是对的
	.e  d
	..;要把Cache数据库中保存的数据， 修改变成
	..s myCachePatInfo=$p(myInfo,$c(1),3)
	..s myCachePatObj=##class(web.DHCEntity.PCA.CardPatInfoReg).%New()
	..d myCachePatObj.XMLDeserialize(.myCachePatObj, myCachePatInfo)
	..d myPatObj.ExchangeData(myCachePatObj)
	..d myCachePatObj.%Close()
	
	b	;;XMLX
	i (+myInfoRtn=-365) d
	.;此身份证已经有就诊卡， 标注 把此人归到集团中
	.s myrtn=myInfoRtn
	
	;其他标注错误代码，写道GroupPerson表中
	s AccInfo=""
	s DepositInfo=""
	s CardINVInfo="<CardINVPRT></CardINVPRT>"
	s SepcialInfo=SecurityNo_"^"
	s ExpStr=""
	
	b	;;Begin Save
	s myPAPMIDR=""
	s myCardRowID=""
	i (myInfoRtn=0)!(+myInfoRtn=-368) d
	.d myPatObj.XMLExportToString(.PaPatInfo)
	.d myCardObj.XMLExportToString(.CardInfo)
	.s myEnrollInfo=##class(web.DHCBL.CARD.UCardPatRegBuilder).SavePCAInfoToServer(ConfigInfo, PaPatInfo, CardInfo, AccInfo, DepositInfo, CardINVInfo,SepcialInfo, ExpStr)
	.s myrtn=+$p(myEnrollInfo,$c(1),1)
	.s myPAPMIDR=$p(myEnrollInfo,$c(1),5)
	.s myCardRowID=$p(myEnrollInfo,$c(1),6)
	
	b	;;Tro  DFDFD
	
	i +myrtn=0 d
	.tc
	e  d
	.tro
	
	s myUIRtn= myrtn
	
	d myPersonInfo.%Close()
	d myPatObj.%Close()
	d myCardObj.%Close()
	
	b	;;;Log
	i (+myUIRtn'=-341) d
	.s myrtn= ..WriteGPLog(BPersonRowID, myInfoRtn, myrtn, myPAPMIDR, myCardRowID)
	 
	s myTipDesc=""
	
	q myUIRtn
}

/// 集团用户注册
ClassMethod GroupPersonInfoReg(UserDR As %String, ExpStr As %String) As %String
{
	;w ##class(web.DHCBL.CARD.UBatchPersonInfo).GroupPersonInfoReg(6,"")
	s myrtn=0
	
	;^DHCTMPBatchPersonInfoI("UserDRIndex", " "_UserDR, myRowID)
	s myRowID=0
	f  s myRowID=$o(^DHCTMPBatchPersonInfoI("UserDRIndex", " "_UserDR, myRowID)) q:(myRowID="")  d
	.;每成功一个提交一个
	.s myPersonInfo=##class(User.DHCTMPBatchPersonInfo).%OpenId(myRowID)
	.ts
	.s myPatObj=##class(web.DHCEntity.PCA.PATMAS).%New()
	.s myCardObj=##class(web.DHCEntity.PCA.CardRef).%New()
	.if $IsObject(myPatObj) d
	..d myCardObj.ExchangeData(myPersonInfo)
	.if $IsObject(myPatObj) d
	..d myPatObj.ExchangeData(myPersonInfo)
	.
	.d myPatObj.XMLExportToString(.PaPatInfo)
	.
	.d myCardObj.XMLExportToString(.CardInfo)
	.
	.s ConfigInfo="^GR"		;集团注册
	.s AccInfo=""
	.s DepositInfo=""
	.s CardINVInfo="<CardINVPRT></CardINVPRT>"
	.s SepcialInfo="^"
	.s ExpStr=""
	.b
	.s myrtn=##class(web.DHCBL.CARD.UCardPatRegBuilder).SavePCAInfoToServer(ConfigInfo, PaPatInfo, CardInfo, AccInfo, DepositInfo, CardINVInfo,SepcialInfo, ExpStr)
	.s myPersonInfo.CreatCardFlag="1"
	.s mysc=myPersonInfo.%Save()
	.d myPersonInfo.%Close()
	.b	;;Tro
	.i +myrtn=0 d
	..tc
	.e  d
	..tro
	
	b	; 
	
	i 
	s myTipDesc=""
	
	q myrtn_"^"_myTipDesc
}

/// 删除当前用户数据
ClassMethod DeleteCurUserData(UserDR As %String) As %String
{
	;w ##class(web.DHCBL.CARD.UBatchPersonInfo).DeleteCurUserData(6)
	s myrtn=""
	s myrtn=##class(User.DHCTMPBatchPersonInfo).DeleteByUserDR(UserDR)
	
	q myrtn
}

/// 记载集团人员信息
ClassMethod LoadGroupPersonInfo(UserDR As %String, XMLData As %String, LoadMode As %String) As %String
{
	;s myrtn=##class(web.DHCBL.CARD.UBatchPersonInfo).LoadGroupPersonInfo(UserDR, XMLData, LoadMode)
	;LoadMode 加载模式Full 全部追加, Append 追加,  
	;s myxml="<DHCTMPBatchPersonInfo><CardNo>1234567</CardNo></DHCTMPBatchPersonInfo>"
	s ^TMPLOADGROUPINFODFDF=$lb(UserDR, XMLData, LoadMode)
	
	s myrtn=0
	s myErr=""
	
	;作为数据验证模式
	i LoadMode="Full" d
	.s myrtn=..DeleteCurUserData(UserDR)
	i (+myrtn=0){
		s myTGObj=##class(User.DHCTMPBatchPersonInfo).%New()
		
		d myTGObj.XMLDeserialize(.myTGObj, XMLData)
		s myTGObj.UserDR=UserDR
		
		s sc=myTGObj.%Save()
		If $System.Status.IsError(sc) {
			s myErr=sc
			s myrtn=-102
		}
	}
		
	q myrtn_"^"_myErr
}

ClassMethod GroupPersonTransToINV(UserDR As %String, GRegINVRowID As %String) As %String
{
	;把数据转换到 User.DHCCardGroupRegisterINV
	;w ##class(web.DHCBL.CARD.UBatchPersonInfo).GroupPersonTransToINV(6)
	
	s myrtn=0
	
	ts
	
	;集团RowID 和 名称
	s myBPIRowID=$o(^DHCTMPBatchPersonInfoI("UserDRIndex"," "_UserDR,0))
	s myBPObj=##class(User.DHCTMPBatchPersonInfo).%OpenId(myBPIRowID)
	s myGroupDR=myBPObj.EmployeeCompanyLookUpRowID
	s myGroupName=myBPObj.GroupUnitName
	
	d myBPObj.%Close()
	
	i (+myrtn=0){
		;把数据转到 DHC_CardGroupRegisterINV
		;DHC_CardGroupPerson
		s myCGRObj=""
		i GRegINVRowID'="" {
			s myCGRObj=##class(User.DHCCardGroupRegisterINV).%OpenId(GRegINVRowID)
		}
		if '($IsObject(myCGRObj)){
			s myCGRObj=##class(User.DHCCardGroupRegisterINV).%New()
		}
		s myCGRObj.CGRCTCompanyDR = myGroupDR
		;s myCGRObj.CGRCardINVDR =""
		s myCGRObj.CGRGroupName = myGroupName
		;s myCGRObj.CGRInvPrtDate =""
		;s myCGRObj.CGRInvPrtTime = ""
		s myCGRObj.CGRInvPrtFlag ="N"
		s myCGRObj.CGRRegDate = +$h
		s myCGRObj.CGRRegTime =$p($h,",",2)
		s myCGRObj.CGRRegUserDR = UserDR
		
	}
	i (+myrtn=0){
		;DHC_CardGroupPerson
		s myBPIRowID = 0
		f  s myBPIRowID=$o(^DHCTMPBatchPersonInfoI("UserDRIndex"," "_UserDR, myBPIRowID))  q:((myBPIRowID="")||(+myrtn))  d
		.s myBPObj=##class(User.DHCTMPBatchPersonInfo).%OpenId(myBPIRowID)
		.s myCGPObj=##class(User.DHCCardGroupPerson).%New()
		.s myCGPObj.ParRef =myCGRObj
		.d myCGPObj.ExchangeData(myBPObj)
		.s myCGPObj.CGPRegStatus = "N"
		.;d myCGPObj.%Save()
	}
	s sc=myCGRObj.%Save()
	s myCGRRowID=myCGRObj.%Id()
	
	If $System.Status.IsError(sc) {
		;s myErr=$System.Status.DisplayError(sc)
		s myrtn=-102
	}
	
	b	;;Tro
	i (+myrtn=0){
		tc
	}else{
		tro
	}
	
	q myrtn_"^"_myCGRRowID
}

ClassMethod LoadTest()
{
	
	;Address As %String [ SqlFieldName = Address ];
	;d ##class(web.DHCBL.CARD.UBatchPersonInfo).LoadTest()
	s myUserDR=$list(^TMPLOADGROUPINFODFDF,1)
	
	s myXMLData=$list(^TMPLOADGROUPINFODFDF,2)
	s LoadMode = $list(^TMPLOADGROUPINFODFDF,3)
	b	;;
	d ..LoadGroupPersonInfo(myUserDR, myXMLData, LoadMode)
}

/// 写集团注册日志
ClassMethod WriteGPLog(GPRowID As %String, CheckCode As %String, EnRtnCode As %String, PAPMIDR As %String, CardRowID As %String) As %String
{
	;w ##class(web.DHCBL.CARD.UBatchPersonInfo).WriteGPLog("3||1",0,0,"427913",855782)
	;GPRowID		
	;Check Code   	注册判断码
	;Enroll Rtn Code	注册中返回值
	;CGPPAPMIDR
	;CardRowID
	
	s myrtn=0
	s myGPObj=##class(User.DHCCardGroupPerson).%OpenId(GPRowID)
	
	s myCardNo=""
	s myCardTypeDR=""
	s myCardTypeDesc=""
	i CardRowID'="" d
	.s myCardNo=$p(^DHCCARD("CF",CardRowID),"^", 2)
	.s myCardTypeDR=$p(^DHCCARD("CF",CardRowID),"^", 16)
	.s myCardTypeDesc=$p($g(^DHCCARDTYPEDef(myCardTypeDR)),"^",2)
	
	s myErrMsg=..GetRegCardErrorMsg(EnRtnCode)
	
	;N,S,F,T,A
	if (+CheckCode=0){
		if (+EnRtnCode=0){
			s myGPObj.CGPRegStatus="S"		;发卡
			s myGPObj.CGPPAPMIDR=PAPMIDR
			s myGPObj.CardNo=myCardNo
			s myGPObj.CardTypeDefine=myCardTypeDR
			s myGPObj.CardTypeDefineDesc=myCardTypeDesc
		}else{
			s myGPObj.CGPRegStatus="F"
			s myGPObj.CGPRegLog="注册失败，错误代码:"_EnRtnCode_", "_myErrMsg
		}
	}elseif(+CheckCode=-368){
		if (+EnRtnCode=0){
			s myGPObj.CGPRegStatus="T"		;发卡
			s myGPObj.CGPPAPMIDR=PAPMIDR
			s myGPObj.CardNo=myCardNo
			s myGPObj.CardTypeDefine=myCardTypeDR
			s myGPObj.CardTypeDefineDesc=myCardTypeDesc
		}else{
			s myGPObj.CGPRegStatus="F"
			s myGPObj.CGPRegLog="卡绑定失败，错误代码:"_EnRtnCode_", "_myErrMsg
		}
	}elseif(+CheckCode=-365){
		if (+EnRtnCode=0){
			s myGPObj.CGPRegStatus="A"		;不发卡
			s myGPObj.CGPPAPMIDR=PAPMIDR
			s myGPObj.CGPRegLog="此人信息被附加到本集团下, 但是不用发卡"
			s myGPObj.CardNo=myCardNo
			s myGPObj.CardTypeDefine=myCardTypeDR
			s myGPObj.CardTypeDefineDesc=myCardTypeDesc
		}else{
			s myGPObj.CGPRegStatus="F"
			s myGPObj.CGPRegLog="把此卡的信息附加到此集团错误，错误代码:"_EnRtnCode_", "_myErrMsg
		}
	}else{
		s myGPObj.CGPRegStatus="F"			;不发卡
		s myGPObj.CGPRegLog="注册失败，错误代码:"_EnRtnCode_", "_myErrMsg
	}
	
	d myGPObj.%Save()
	d myGPObj.%Close()
	
	q myrtn
}

ClassMethod GetRegCardErrorMsg(ErrCode As %String) As %String
{
	s myErrMsg=""
	i (+ErrCode=-340){
		s myErrMsg="此卡没有对应的病人信息"
	}elseif(+ErrCode=-341){
		s myErrMsg="此卡号已经存在,不能发卡"
	}elseif(+ErrCode=-350){
		s myErrMsg="此卡已经使用,不能重复发卡"
	}elseif(+ErrCode=-351){
		s myErrMsg="此卡已经被挂失,不能使用"
	}elseif(+ErrCode=-352){
		s myErrMsg="此卡已经被作废，不能使用"
	}elseif(+ErrCode=-358){
		s myErrMsg="发卡时，此卡已经有对应的登记号了，不能在新增了"
	}elseif(+ErrCode=-359){
		s myErrMsg="作废的卡不能再进行换卡"
	}elseif(+ErrCode=-360){
		s myErrMsg="正常状态的卡不能进行换卡"
	}elseif(+ErrCode=-361){
		s myErrMsg="作废的卡不能再进行补卡"
	}elseif(+ErrCode=-362){
		s myErrMsg="正常状态的卡不能进行补卡"
	}elseif(+ErrCode=-364){
		s myErrMsg="同类卡，此患者只能有一张"
	}elseif(+ErrCode=-365){
		s myErrMsg="同类卡中，此卡检索此身份证件号码已经存在"
	}elseif(+ErrCode=-366){
		s myErrMsg="卡类型为空错误"
	}elseif(+ErrCode=-367){
		s myErrMsg="证件号码不能为空"
	}elseif(+ErrCode=-368){
		s myErrMsg="同一个证件类型的证件号码被发现，唯一标示卡被发现"
	}elseif(+ErrCode=-369){
		s myErrMsg="办理卡绑定时， 获取患者信息错误"
	}elseif(+ErrCode=-370){
		s myErrMsg="卡号码的长度与此类的定义的长度不一致错误"
	}elseif(+ErrCode=-371){
		s myErrMsg="卡号码的前缀与此类的定义的前缀不一致错误"
	}
	
	q myErrMsg
}

ClassMethod SetGroupRegPRTINVSign(GRIRowID As %String, CardINVRowID As %String) As %String
{
	;w ##class(web.DHCBL.CARD.UBatchPersonInfo).SetGroupRegPRTINVSign(GRIRowID, CardINVRowID)
	s myrtn=0
	
	s myGRIObj=##class(User.DHCCardGroupRegisterINV).%OpenId(GRIRowID)
	
	s myGRIObj.CGRInvPrtDate=+$h
	s myGRIObj.CGRInvPrtFlag="Y"
	s myGRIObj.CGRInvPrtTime=$p($h,",",2)
	d myGRIObj.CGRCardINVDRSetObjectId(CardINVRowID)
	
	d myGRIObj.%Save()
	d myGRIObj.%Close()
	
	q myrtn
}

/// /获取集团注册未打印发票 的人员信息
ClassMethod ReadGroupPersonUnPRTInfo() As %String
{
	;
	;2 读取默认信息
	;w ##class(web.DHCBL.CARD.UBatchPersonInfo).ReadGroupPersonUnPRTInfo()
	
	s myobj=##class(web.DHCEntity.CTBASE.ComboListObject).%New()
	
	;^DHCCARDGRINVD(3)
	s myGRIRowID=0
	f  s myGRIRowID=$o(^DHCCARDGRINVD(myGRIRowID))  q:(myGRIRowID="")  d
	.q:($d(^DHCCARDGRINVD(myGRIRowID))=10)
	.s myGRIObj=##class(User.DHCCardGroupRegisterINV).%OpenId(myGRIRowID)
	.q:(myGRIObj.CGRInvPrtFlag="Y")
	.q:(myGRIObj.CGRCardINVDR'="")
	.s mySCCount=0
	.s myUnRegSCCount=0
	.s myCardSum=0
	.s myCount = myGRIObj.CGPersons.Count()
	.f myIdx=1:1:myCount  d
	..s myPObj=myGRIObj.CGPersons.GetAt(myIdx)
	..s myStatus=myPObj.CGPRegStatus
	..i myStatus="N" d
	...s myUnRegSCCount=+myUnRegSCCount+1
	..q:((myStatus'="S")&(myStatus'="T"))
	..s myCardTypeDR=myPObj.CardTypeDefine
	..s mySCCount=+mySCCount+1
	..q:(myCardTypeDR="")
	..s myCurCardSum = $p(^DHCCARDTYPEDef(myCardTypeDR),"^", 6)
	..s myCardSum=+myCardSum+myCurCardSum
	.d myPObj.%Close()
	.q:(+mySCCount=0)
	.s myValue=myGRIRowID_"^"_mySCCount_"^"_myCardSum_"^"_myUnRegSCCount
	.s myText= myGRIObj.CGRGroupName
	.s myDefaultFlag=0
	.d myobj.Put(myValue,myText,myDefaultFlag)
	.d myGRIObj.%Close()
	
	s myrtn=myobj.GetListValue()
	
	b	;
	d myobj.%Close()

	q myrtn
}

}
