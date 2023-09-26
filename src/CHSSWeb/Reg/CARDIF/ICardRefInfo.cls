Class CHSSWeb.Reg.CARDIF.ICardRefInfo Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// 保存Pat
/// Card
/// AccManager
/// 信息到数据库中
/// 
ClassMethod SavePCAInfoToServer(Address As %String, Birth As %String, CredNo As %String, EmployeeCompany As %String, IDCardNo1 As %String, MobPhone As %String, Name As %String, PatYBCode As %String, Sex As %String, TelHome As %String, CardNo As %String, PayMode) As %String
{
	;s ^dahai = ConfigInfo_"^"_PaPatInfo_"^"_CardInfo_"^"_AccInfo_"^"_DepositInfo_"^"_CardINVInfo_"^"_SepcialInfo_"^"_ExpStr

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
    s ConfigInfo = ##class(CHSSWeb.Reg.OutRegister).GetConfigInfoXml()
	s PaPatInfo = ##class(CHSSWeb.Reg.OutRegister).GetPaPatInfoXml(Address, Birth, CredNo, EmployeeCompany, IDCardNo1, MobPhone, Name, PatYBCode, Sex, TelHome)
	s CardInfo = ##class(CHSSWeb.Reg.OutRegister).GetCardInfoXml(CardNo, CredNo)
	s AccInfo = ##class(CHSSWeb.Reg.OutRegister).GetAccInfoXml(CardNo, CredNo)
	s DepositInfo = ##class(CHSSWeb.Reg.OutRegister).GetDepositInfoXml()
	s CardINVInfo = ##class(CHSSWeb.Reg.OutRegister).GetCardINVInfoXml(PayMode)
	s SepcialInfo = ##class(CHSSWeb.Reg.OutRegister).GetSepcialInfoXml()
	s ExpStr = ##class(CHSSWeb.Reg.OutRegister).GetExpStrXml()
	
	;n (ConfigInfo, PaPatInfo, CardInfo, AccInfo, DepositInfo, CardINVInfo, SepcialInfo, ExpStr)
	k ^dahai
	s aa = ConfigInfo
	s bb = PaPatInfo
	s ^dahai(0,1) = ConfigInfo
	s ^dahai(0,2) = PaPatInfo
	s ^dahai(0,1,1) = CardInfo
	s ^dahai(0,1,2) = AccInfo
	s ^dahai(0,1,3) = DepositInfo
	s ^dahai(0,1,4) = CardINVInfo
	s ^dahai(0,2,1) = SepcialInfo
	s ^dahai(0,2,2) = ExpStr
	s myrtn=##class(CHSSWeb.Reg.CARD.UCardPatRegBuilder).SavePCAInfoToServer(ConfigInfo, PaPatInfo, CardInfo, AccInfo, DepositInfo, CardINVInfo,SepcialInfo, ExpStr)
	
	q myrtn
}

}
