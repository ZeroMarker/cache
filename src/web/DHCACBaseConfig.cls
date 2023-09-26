Class web.DHCACBaseConfig Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 47;

ClassMethod GetAccPara() As %String
{
	;w ##class(web.DHCACBaseConfig).GetAccPara()
	s CreatePWD=+$g(^DHCACDP("ParaSet","CreatePWD"))    ;建立帐户时设置密码/结帐时使用密码保护
	s UsePWD=+$g(^DHCACDP("ParaSet","UsePWD"))          ;卡支付时使用密码保护
	s CardNoEffect=+$g(^DHCACDP("ParaSet","CardNoEffect"))     ;就诊卡卡号验证保护
	s AccLeftPrint=+$g(^DHCACDP("ParaSet","AccLeftPrint"))      ;预缴金余额查询打印设置
	s PWDCount=+$g(^DHCACDP("ParaSet", "PWDCount"))         ;密码次数设定
	s EffectPaper=+$g(^DHCACDP("ParaSet", "EffectPaper"))    ;有效证件不能为空设置
	s EffectBill=+$g(^DHCACDP("ParaSet","EffectBill"))    ;票据有效管理设置(设置是否验证票据)
	s SQueryPWD=+$g(^DHCACDP("ParaSet","SQueryPWD"))         ;单独查询查询时使用密码保护

	s SDateDiff=+$g(^DHCACDP("ParaSet","SDateDiff"))    			;挂失与补卡的日期差
	s PWDDateDiff=+$g(^DHCACDP("ParaSet","PWDDateDiff"))		;密码遗忘日期差
	s CardReqSuspend= +$g(^DHCACDP("ParaSet","CardReqSuspend"))		;补卡不需要挂失
	s PWDEditReq= +$g(^DHCACDP("ParaSet","PWDEditReq"))		;密码遗忘修改不需要申请
	s PDAutoNo=+$g(^DHCACDP("ParaSet","PDAutoNo"))		;门诊预交金使用自动编码
	s AccReCard=+$g(^DHCACDP("ParaSet","AccReCard"))	;配置结算时，是否回收原卡
	s DepPrice=+$g(^DHCACDP("ParaSet","DepPrice"))		;配置账户的透支限额
	
	s ParInfo=CreatePWD_"^"_UsePWD_"^"_CardNoEffect_"^"_AccLeftPrint_"^"_PWDCount_"^"_EffectPaper_"^"_EffectBill_"^"_SQueryPWD
	s ParInfo=ParInfo_"^"_SDateDiff_"^"_PWDDateDiff_"^"_CardReqSuspend_"^"_PWDEditReq
	s ParInfo=ParInfo_"^"_PDAutoNo_"^"_AccReCard_"^"_DepPrice
	
	q ParInfo
}

/// /;统一传入一个参数信息
ClassMethod SaveAccPara(ParaInfo) As %String
{
	;web.DHCACBaseConfig.SaveAccPara
	s CreatePWD=$p(ParaInfo,"!",1)
	s UsePWD=$p(ParaInfo,"!",2)
	s CardNoEffect=$p(ParaInfo,"!",3)
	s AccLeftPrint=$p(ParaInfo,"!",4)
	s PWDCount=$p(ParaInfo,"!",5)
	s EffectPaper=$p(ParaInfo,"!",6)
	s EffectBill=$p(ParaInfo,"!",7)
	s SQueryPWD=$p(ParaInfo,"!",8)
	s SDateDiff=$p(ParaInfo,"!",9)
	s PWDDateDiff=$p(ParaInfo,"!",10)
	s CardReqSuspend=$p(ParaInfo,"!",11)
	s PWDEditReq=$p(ParaInfo,"!",12)
	s PDAutoNo=$p(ParaInfo,"!",13)
	s AccReCard=$p(ParaInfo,"!",14)
	s DepPrice=+$p(ParaInfo,"!",15)
	
	s ^DHCACDP("ParaSet","CreatePWD")=CreatePWD    ;建立帐户时设置密码/结帐时使用密码保护
	s ^DHCACDP("ParaSet","UsePWD")=UsePWD          ;卡支付时使用密码保护
	s ^DHCACDP("ParaSet","CardNoEffect")=CardNoEffect     ;就诊卡卡号验证保护
	s ^DHCACDP("ParaSet","AccLeftPrint")=AccLeftPrint      ;预缴金余额查询打印设置
	s ^DHCACDP("ParaSet", "PWDCount")=PWDCount         ;密码次数设定
	s ^DHCACDP("ParaSet", "EffectPaper")=EffectPaper    ;有效证件不能为空设置
	s ^DHCACDP("ParaSet","EffectBill")=EffectBill    ;票据有效管理设置(设置是否验证票据)
	s ^DHCACDP("ParaSet","SQueryPWD")=SQueryPWD         ;单独查询查询时使用密码保护
	s ^DHCACDP("ParaSet","SDateDiff")=SDateDiff    			;挂失与补卡的日期差
	s ^DHCACDP("ParaSet","PWDDateDiff")=PWDDateDiff		;密码遗忘日期差
	s ^DHCACDP("ParaSet","CardReqSuspend")=CardReqSuspend		;补卡不需要挂失
	s ^DHCACDP("ParaSet","PWDEditReq")=PWDEditReq		;密码遗忘修改不需要申请
	s ^DHCACDP("ParaSet","PDAutoNo")=PDAutoNo			;
	s ^DHCACDP("ParaSet","AccReCard")=AccReCard	;配置结算时，是否回收原卡
	s ^DHCACDP("ParaSet","DepPrice")=DepPrice		;配置账户的透支限额
	
	q 0
}

}
