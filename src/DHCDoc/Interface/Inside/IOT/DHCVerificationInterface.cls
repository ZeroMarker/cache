/// Create 20200108 by yl
/// 验证码相关程序
Class DHCDoc.Interface.Inside.IOT.DHCVerificationInterface Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 验证码位数
Parameter VFCodeDigits = 8;

/// 日志保留天数
Parameter VFLogDay = 7;

/// 获取验证码
/// w ##class(DHCDoc.Interface.Inside.IOT.DHCVerificationInterface).GetVerifCode()
ClassMethod GetVerifCode()
{
	s Code=""
	f i=1:1:..#VFCodeDigits {
		s OneCode=$$GetRandomCode()
		s Code=Code_OneCode
	}
	q Code
GetRandomCode()
	do {
		s OneRandom=$random(123)
	} while '(((OneRandom>47)&&(OneRandom<58))!((OneRandom>64)&&(OneRandom<91))!(OneRandom>96))
	
	q $c(OneRandom)
}

/// 获取流水号
/// w ##class(DHCDoc.Interface.Inside.IOT.DHCVerificationInterface).GetTradeCode()
ClassMethod GetTradeCode(Type As %String)
{
	q Type_$tr($now(),",.","")
}

/// 发送验证码到指定手机号上，并返回流水号及验证码
ClassMethod VerifInterface(VFType As %String, PatId As %String = "", Tel As %String = "")
{
	;d ..ClearExpiredVerif()	;清除过期数据
	q:(PatId="")&&(Tel="") "-100^信息不全，发送验证码失败"
	s VFCode=..GetVerifCode()
	s TradeCode=..GetTradeCode(VFType)
	s SendMsg="系统验证短信，验证码为"_VFCode
	if Tel="" {
		s Tel=$p($g(^PAPER(PatId,"PER",1)),"^",11)
	}
	s ret=""	;调用发送短信接口
	s ret=0
	if ret=0 {
		s ret=..SaveVerifInfo(VFType, PatId, Tel, VFCode, TradeCode, SendMsg)
		if ret=0 {
			q "0^"_VFCode_"^"_TradeCode
		}
	}
	q ret_"^验证码发送失败"
}

/// 保存
ClassMethod SaveVerifInfo(VFType As %String, PatId As %String, Tel As %String, VFCode As %String, TradeCode As %String, SendMsg As %String)
{
	s PLIST(2)=VFType
	s PLIST(3)=PatId
	s PLIST(4)=Tel
	s PLIST(5)=TradeCode
	s PLIST(6)=VFCode
	s PLIST(7)=SendMsg
	s PLIST(8)=..%SysDate()-1
	s PLIST(9)=..%SysTime()
	
	&SQL(insert into SQLUser.DHC_VerificationInfo values :PLIST())
	
	q SQLCODE
}

ClassMethod ClearExpiredVerif()
{
	s ExpiredDate=..%SysDate()-(..#VFLogDay)
	&SQL(delete from SQLUser.DHC_VerificationInfo where VF_Date<:ExpiredDate)
	q SQLCODE
}

}
