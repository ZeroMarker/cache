Class web.DHCBL.CARDIF.ICardRefInfo Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 73;

/// 集团人员信息注册 整体注册
ClassMethod GroupPersonInfoReg(UserDR As %String, ExpStr As %String) As %String
{
	;
	;(ConfigInfo, PaPatInfo, CardInfo, AccInfo, DepositInfo, CardINVInfo, SepcialInfo, ExpStr)
	s myrtn=0
	s myrtn = ##class(web.DHCBL.CARD.UBatchPersonInfo).GroupPersonInfoReg(UserDR,"")
	
	q myrtn
}

/// /单个注册
ClassMethod GroupSinglePersonInfoReg(UserDR As %String, BPersonRowID As %String, CardNo As %String, CardTypeDR As %String, SecurityNo As %String, ExpStr As %String) As %String
{
	;w ##class(web.DHCBL.CARDIF.ICardRefInfo).GroupSinglePersonInfoReg("6", "8", "0000999999", "2", "")
	;(ConfigInfo, PaPatInfo, CardInfo, AccInfo, DepositInfo, CardINVInfo, SepcialInfo, ExpStr)
	s myrtn=0
	s myrtn = ##class(web.DHCBL.CARD.UBatchPersonInfo).GroupSinglePersonInfoReg(UserDR, BPersonRowID, CardNo, CardTypeDR, SecurityNo, ExpStr)
	
	q myrtn
}

/// 加载集团人员数据
/// LoadMode 加载模式Full 全部追加, Append 追加,  
ClassMethod LoadGroupPersonInfo(UserDR, LoadMode, XmlData, ExpStr) As %String
{
	;##class(web.DHCBL.CARDIF.ICardRefInfo).LoadGroupPersonInfo(UserDR, LoadMode, XmlData, ExpStr)
	s myrtn=0
	s myrtn=##class(web.DHCBL.CARD.UBatchPersonInfo).LoadGroupPersonInfo(UserDR, XmlData, LoadMode)
	q myrtn
}

/// /
ClassMethod GroupPersonTransToINV(UserDR As %String, GRegINVRowID As %String) As %String
{
	;##class(web.DHCBL.CARDIF.ICardRefInfo).GroupPersonTransToINV(UserDR)
	n (UserDR, GRegINVRowID)
	s myrtn=##class(web.DHCBL.CARD.UBatchPersonInfo).GroupPersonTransToINV(UserDR, GRegINVRowID)
	q myrtn
}

/// 包含功能如下：
/// 1  初始化患者信息数据
/// 	1.1 规则  使用卡与卡 类型RowID去判断
/// 2  保存患者信息
/// 3  读取患者信息
/// 		3.1 就诊功能
/// 		3.2 账户支付功能
/// 
ClassMethod ReadPatValidateInfoByCardNo(CardNO As %Library.String = "", SecurityNo As %String = "", CardTypeDR As %String = "", ExpStr As %String) As %String
{
	;
	;w ##class(web.DHCBL.CARDIF.ICardRefInfo).ReadPatValidateInfoByCardNo("00000012","","1","")
	;w ##class(web.DHCBL.CARDIF.ICardRefInfo).ReadPatValidateInfoByCardNo("00000136","","1","")
	n (CardNO,  SecurityNo, CardTypeDR, ExpStr)
	s myrtn=""
	
	s ^TMPFDFDFD=$lb(CardNO,  SecurityNo, CardTypeDR, ExpStr)
	
	s myVer=##class(web.DHCOPConfig).GetVersion()
	s myClsName="web.DHCBL.CARD.UCardRefInfo"_myVer
	s myflag=..%IsValidMethod(myClsName,"ReadPatValidateInfoByCardNo")
	if (myflag)
	{
		s myrtn= $ZOBJCLASSMETHOD(myClsName, "ReadPatValidateInfoByCardNo", CardNO,  SecurityNo, CardTypeDR)
	}else
	{
		s myrtn=##class(web.DHCBL.CARD.UCardRefInfo).ReadPatValidateInfoByCardNo(CardNO,  SecurityNo, CardTypeDR)
	}
	q myrtn
}

/// 保存Pat
/// Card
/// AccManager
/// 信息到数据库中
/// 
ClassMethod SavePCAInfoToServer(ConfigInfo As %String, PaPatInfo As %String, CardInfo As %String, AccInfo As %String, DepositInfo As %String, CardINVInfo As %String, SepcialInfo As %String, ExpStr As %String) As %String
{
	;步骤：
	;
	;1. 对于传的String  进行 反序列化处理
	;	1.1  通用数据反序列化
	;	1.2  特殊数据赋值
	;2. 验证数据的来源，
	;3. 对数据加以 校验  实现校验规则；
	;	3.1 
	;4. 保存患者基本信息到数据库
	;5. 保存患者的卡信息到数据库
	;	5.1	根据卡类型配置 保存票据信息和费用信息
	;6. 保存患者帐户信息
	;	6.1  保存预交金信息
	;7. 返回 信息  
	;	7.1 组件 保存返回
	;	7.2 Web注册保存返回
	
	n (ConfigInfo, PaPatInfo, CardInfo, AccInfo, DepositInfo, CardINVInfo, SepcialInfo, ExpStr,%session)
	s myrtn=##class(web.DHCBL.CARD.UCardPatRegBuilder).SavePCAInfoToServer(ConfigInfo, PaPatInfo, CardInfo, AccInfo, DepositInfo, CardINVInfo,SepcialInfo, ExpStr)
	
	q myrtn
}

/// /提供一个退卡回收功能， 是否收回钱，由发卡时来定义的
/// /1.  如果 此卡收了费， 就退钱
/// /2.  否则 就不退钱
ClassMethod CancelCardInfo(UserDR As %String, sFlag As %String, CardStatusChangeInfo As %String, ExpStr As %String) As %String
{
	;w ##class(web.DHCBL.CARDIF.ICardRefInfo).CancelCardInfo()
	;1. 标注原卡回收
	;1.1 同时考虑帐户
	;2. 同时作废发票，回收发票，在日报上显示
	s myrtn=0
	s ^TMPCANCELINFO=$lb(UserDR , sFlag , CardStatusChangeInfo , ExpStr)
	
	;修改原来的卡状态  变为
	s myrtn=##class(web.DHCBL.CARD.UCardRefBulider).CancelCardInfo(UserDR , sFlag , CardStatusChangeInfo , ExpStr)
	
	q myrtn
}

ClassMethod Test()
{
	; w ##class(web.DHCBL.CARDIF.ICardRefInfo).Test()
	;$LIST($g(^TMPPatRegInfo),1)
	s myrtn=##class(web.DHCBL.CARDIF.ICardRefInfo).CancelCardInfo(7,"A",$list(^TMPCANCELINFO,3),"")
}

/// 不用,转到web.UDHCOPOtherLB.cls中处理
ClassMethod GetCredNo() As %String
{
   Q ""
}

}
