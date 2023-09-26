Class web.DHCPE.AdvancePaymentReplace Extends %RegisteredObject
{

/// 保存基本信息
ClassMethod Save(StrInfo)
{
	s ^TempDHCPEAPReplace("APInfo")=StrInfo
	s APRowID=$P(StrInfo,"^",1)
	s APData=$G(^DHCPEAP(APRowID))	
	s Name=$p($G(^DHCPEDataEx("DHCPEAD","Info",APRowID)),"^",1)
	s Sex=$p($G(^DHCPEDataEx("DHCPEAD","Info",APRowID)),"^",2)
	s Tel=$p(APData,"^",16)
	s EndLineDate=$p(APData,"^",14)
	s EndLineDate=##class(websys.Conversions).DateLogicalToHtml(EndLineDate)
	s IDCard=$p(APData,"^",17)
	s Rebate=$p(APData,"^",15)
	s OldInfo="姓名:"_Name_";性别:"_Sex_";联系电话:"_Tel_";截止日期:"_EndLineDate_";证件号:"_IDCard_";折扣率:"_Rebate_";"
	
	s NewInfo=""
	s NewName=$P(StrInfo,"^",2)
	i (NewName'="")&&(NewName'=Name) d
	.s $p(^DHCPEDataEx("DHCPEAD","Info",APRowID),"^",1)=NewName       //姓名
	.s NewInfo="姓名:"_NewName_";"
	e  d
	.s NewInfo="姓名:"_Name_";"
	
	s NewSex=$P(StrInfo,"^",3)
	i (NewSex'="")&&(NewSex'=Sex) d
	.s $p(^DHCPEDataEx("DHCPEAD","Info",APRowID),"^",2)=NewSex        //性别
	.s NewInfo=NewInfo_"性别:"_NewSex_";"
	e  d
	.s NewInfo=NewInfo_"性别:"_Sex_";"
	
	s NewTel=$P(StrInfo,"^",4)
	i (NewTel'="")&&(NewTel'=Tel) d
	.s $p(^DHCPEAP(APRowID),"^",16)=NewTel                    //联系电话
	.s NewInfo=NewInfo_"联系电话:"_NewTel_";"
	e  d
	.s NewInfo=NewInfo_"联系电话:"_Tel_";"
	
	s NewEndLineDate=$P(StrInfo,"^",5)
	i (NewEndLineDate'="")&&(NewEndLineDate'=EndLineDate) d
	.s NewInfo=NewInfo_"截止日期:"_NewEndLineDate_";"
	.s NewEndLineDate=##class(websys.Conversions).DateHtmlToLogical(NewEndLineDate)
	.s $p(^DHCPEAP(APRowID),"^",14)=NewEndLineDate                    //截止日期
	e  d
	.s NewInfo=NewInfo_"截止日期:"_EndLineDate_";"
	
	
	s NewIDCard=$P(StrInfo,"^",6)
	i (NewIDCard'="")&&(NewIDCard'=IDCard) d
	.s $p(^DHCPEAP(APRowID),"^",17)=NewIDCard                         //身份证号
	.s NewInfo=NewInfo_"证件号:"_NewIDCard_";"
	e  d
	.s NewInfo=NewInfo_"证件号:"_IDCard_";"
	
	s NewRebate=$P(StrInfo,"^",7) 
	i (NewRebate'="")&&(NewRebate'=Rebate) d
	.s $p(^DHCPEAP(APRowID),"^",15)=NewRebate                         //折扣率
	.s NewInfo=NewInfo_"折扣率:"_NewRebate_";"
	e  d
	.s NewInfo=NewInfo_"折扣率:"_Rebate_";"
	
	s NewRemark=$P(StrInfo,"^",8) 
	i NewRemark'="" d
	.s Remark=$p(APData,"^",9)
	.s NewRemark=Remark_";"_NewRemark
	.s $p(^DHCPEAP(APRowID),"^",9)=NewRemark                          //备注 
	
	s UserID=$P(StrInfo,"^",9)
	d ##class(web.DHCPE.ModifyRecord).Save(APRowID,"AdvancePayment",OldInfo,NewInfo,UserID)
	q "0"
}

/// 获取基本信息
/// w ##class(web.DHCPE.AdvancePaymentReplace).GetPreInfo("48")
ClassMethod GetPreInfo(APRowID)
{
	q:APRowID="" ""
	s APData=$G(^DHCPEAP(APRowID))
	s Type=$p(APData,"^",3)
	q:Type'="C" ""
	
	s CardNo=$p(APData,"^",2)
	s Name=$p($G(^DHCPEDataEx("DHCPEAD","Info",APRowID)),"^",1)
	s Sex=$p($G(^DHCPEDataEx("DHCPEAD","Info",APRowID)),"^",2)
	s Tel=$p(APData,"^",16)
	s EndLineDate=$p(APData,"^",14)
	s EndLineDate=##class(websys.Conversions).DateLogicalToHtml(EndLineDate)
	s IDCard=$p(APData,"^",17)
	s Rebate=$p(APData,"^",15)
	//s Remark=$p(APData,"^",9)
	q CardNo_"^"_Name_"^"_Sex_"^"_Tel_"^"_EndLineDate_"^"_IDCard_"^"_Rebate
}

}
