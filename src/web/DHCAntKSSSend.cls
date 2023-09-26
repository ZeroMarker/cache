Class web.DHCAntKSSSend Extends %RegisteredObject
{

/// Creator：      hw
/// CreatDate：    2016-3-09
/// Description:： 根据抗生素申请ID发送消息给平台
/// Table：        DHC_Doc_AntibioticApply
/// Input：        抗生素申请ID
/// Output：       发送消息返回值
/// Return：        
/// Others：      w ##class(web.DHCAntKSSSend).SendApplyInfo(454)
ClassMethod SendApplyInfo(AppRowid)
{
	s retpt=0
	q:AppRowid="" retpt
	s AppStatus=$p(^DHCDAA("ANT",AppRowid),"^",12)
	
 	if AppStatus="U"  s Status="2"
	;if AppStatus="A"  s Status="1"
	if AppStatus="A" d
	.s PoisonCode=""
	.s arcim=$p(^DHCDAA("ANT",AppRowid),"^",2)
	.s PoisonRowid=##class(web.DHCDocOrderEntry).GetDrgFormPoison(arcim)
    .i PoisonRowid'="" s PoisonCode=$P(^PHCPO(PoisonRowid),"^",1)
    .i PoisonCode="KSS1"  s Status="11"
    .i PoisonCode="KSS2"  s Status="12"
    .i PoisonCode="KSS3"  s Status="13"
	if AppStatus="R"  s Status="3"  
 	s adm=$p(^DHCDAA("ANT",AppRowid),"^",1)
 	s admNo=$p(^PAADM(adm),"^",81)
	s retpt=##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000021",AppRowid,Status,adm)
	q retpt
}

}
