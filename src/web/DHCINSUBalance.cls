Import sqluser

Class web.DHCINSUBalance Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      	lilizhi
/// CreatDate：    	2012-08-07
/// Description： 	查询所有符合条件的结算记录，用于医保对账
/// Table：       	insu_divide,insu_adminfo,pa_adm
/// Input：          CurrDate   发生日期
/// Return：        
/// w ##class(web.DHCINSUBalance).QueryInsuDivInfo("2012-11-20^2012-11-20^^^")
ClassMethod QueryInsuDivInfo(inputstr As %String) As %String
{
	n (inputstr)
	k ^CacheTemp("InsuBalance",$j)
	q:inputstr="" OutStr
	s StrDate=$p(inputstr,"^",1)
	s EndDate=$p(inputstr,"^",2)
	s InsuType=$p(inputstr,"^",3)
	s StrDate=$zdh(StrDate,3)
	s EndDate=$zdh(EndDate,3)
	;s ^CacheTemp("InsuBalance",$j,1)="INPAY_Rowid^INPAY_AdmDr^INPAY_AdmInfoDr^INPAY_DHCpblDr^INPAY_DhcInvPrtDr^INPAY_Flag^INPAY_INSUDivideDr^INPAY_bcbxf0^INPAY_djlsh0^INPAY_bckbcs^INPAY_bqbm00^INPAY_brnl00^INPAY_cardno^INPAY_cfxms0^INPAY_crbcts^INPAY_grzfe0^INPAY_iDate^INPAY_iTime^INPAY_id0000^INPAY_jjzfe0^INPAY_ptbcts^INPAY_sUserDr^INPAY_sfrq00^INPAY_sfrxm0^INPAY_sfsj00^INPAY_sftsbz^INPAY_xbie00^INPAY_xming0^INPAY_zhzfe0^INPAY_zyksmc^INPAY_zylsh0^INPAY_InsuPay1^INPAY_InsuPay2^INPAY_InsuPay3^INPAY_InsuPay4^INPAY_InsuPay5^INPAY_Zstr01^INPAY_Zstr02^INPAY_Zstr03^INPAY_Zstr04^INPAY_Zstr05^INPAY_Zstr06^INPAY_Zstr07^INPAY_Zstr08^INPAY_Zstr09^INPAY_Zstr10^INPAY_InsuPay6^INPAY_InsuPay7^INPAY_InsuPay8^INPAY_InsuPay9^INPAY_InsuPay10^INPAY_Zstr11^INPAY_Zstr12^INPAY_Zstr13^INPAY_Zstr14^INPAY_Zstr15^INPAY_Zstr16^INPAY_Zstr17^INPAY_Zstr18^INPAY_Zstr19^INPAY_Zstr20^INPAY_Zstr21^INPAY_Zstr22^INPAY_Zstr23^INPAY_Zstr24^INPAY_Zstr25^INPAY_Zstr26^INPAY_Zstr27^INPAY_Zstr28^INPAY_Zstr29^INPAY_Zstr30"
	s i=1
	f CurrDate=StrDate:1:EndDate  d
	.s DivDr=""
	.f  s DivDr=$o(^DHCINDIV("0","IDate",CurrDate,DivDr)) q:DivDr=""  d
	..s (INPAYdjlsh0,INADMInsuId,INADMCardNo,INPAYming0,INPAYDhcInvPrtDr)=""
	..s (INPAYiDateTime,INADMAdmType,INPAYbcbxf0,INPAYInsuPay1,INPAYgrzfe0)=""
	..s (YBZFHJ,grzhye,ybnzje,ybwzje,ybhdbz)=""
	..s (ybhdsj,PrtNo)=""
	..s DivInfo=$g(^DHCINDIV(DivDr))
	..s AdmDr=$p(DivInfo,"^",1)
	..s Type=$p($g(^PAADM(AdmDr)),"^",2)
	..q:(Type'="O")&&(Type'="E")
	..s AdmInfoDr=$p(DivInfo,"^",2)
	..q:AdmInfoDr=""
	..s InsuAdmInfo=$g(^DHCINADM(AdmInfoDr))
	..s TempInsuType=$p(InsuAdmInfo,"^",18)
	..q:(TempInsuType'=InsuType)&&(InsuType'="")
	..s Flag=$p(DivInfo,"^",5)				//结算状态，I：正常、B：被冲销、S冲销记录，D中间状态
	..q:Flag'="I"
	..s mCorrDiv=DivInfo
	..s INSUAdmInfo=InsuAdmInfo
	..s INPAYdjlsh0=$p(mCorrDiv,"^",8)
	..s INADMInsuId=$p(INSUAdmInfo,"^",2)
	..s INADMCardNo=$p(INSUAdmInfo,"^",3)
	..s INPAYming0=$p(mCorrDiv,"^",27)		;未寸
	..s INPAYDhcInvPrtDr=$p(mCorrDiv,"^",4)
	..s INPAYiDateTime=$zd($p(mCorrDiv,"^",16),3)_" "_$zt($p(mCorrDiv,"^",17))
	..s INADMAdmType=$p(INSUAdmInfo,"^",14)
	..s INPAYbcbxf0=+$p(mCorrDiv,"^",7)
	..s INPAYInsuPay1=+$p(mCorrDiv,"^",31)
	..s INPAYgrzfe0=+$p(mCorrDiv,"^",15)
	..s YBZFHJ=INPAYbcbxf0-INPAYgrzfe0	;除现金之外金额，医保支付合计
	..s grzhye=0			;位置未定
	..s ybnzje=0			;需要遍历dividesub取
	..s ybwzje=0			;需要遍历dividesub取
	..s ybhdbz=""
	..s ybhdsj=""
	..i INPAYDhcInvPrtDr'="" d
	...s:$d(^DHCINVPRT(INPAYDhcInvPrtDr)) PrtNo=$p(^DHCINVPRT(INPAYDhcInvPrtDr),"^",14)
	..s jssj=INPAYiDateTime
	..s Str=INPAYdjlsh0_"^"_INADMInsuId_"^"_INADMCardNo_"^"_INPAYming0_"^"_INPAYDhcInvPrtDr
	..s Str=Str_"^"_INPAYiDateTime_"^"_INADMAdmType_"^"_INPAYbcbxf0_"^"_INPAYInsuPay1_"^"_INPAYgrzfe0
	..s Str=Str_"^"_YBZFHJ_"^"_grzhye_"^"_ybnzje_"^"_ybwzje_"^"_ybhdbz
	..s Str=Str_"^"_ybhdsj_"^"_PrtNo_"^"_jssj_"^"_DivDr
	
	..w Str,!
	..s ^CacheTemp("InsuBalance",$j,i)=Str  ;DivDr_"^"_DivInfo
	..s i=i+1
	q i-1_"|"_$j
}

ClassMethod GetInsuDivInfo(Joid As %String, i As %String) As %String
{
	n (Joid,i)
	s OutStr=^CacheTemp("InsuBalance",Joid,i)
	q OutStr
}

/// Creator：      	lilizhi
/// CreatDate：    	2012-08-07
/// Description： 	查询所有符合条件的结算记录，用于医保对账
/// Table：       	insu_divide,insu_adminfo,pa_adm
/// Input：          CurrDate   发生日期
/// Return：        
/// w ##class(web.DHCINSUBalance).GetDivDetailsByDivID("2012-11-22^2012-11-22^^^")
ClassMethod GetDivDetailsByDivID(ID As %String, Type As %String) As %String
{
	q:ID="" ""
	s Str=""
	i (Type="11")||(Type="19") d 
	.s ChildSub=0,InString="",BalRowid=0,IntctRowid="",Sum=""
	.s tradeno=$p(^DHCINDIV(ID),"^",8)   ///交易流水号
	.f  s ChildSub=$o(^DHCINDIV(ID,"ChildSub",ChildSub))  q:ChildSub=""  d   //项目序号
	..s IntctRowid=""
	..s mCorrDiv=$g(^DHCINDIV(ID,"ChildSub",ChildSub))
	..s hiscode=$p(mCorrDiv,"^",14) ///HIS项目代码
	..s ArcimDr=$p(mCorrDiv,"^",1) 
	..s IntctRowid=$o(^DHCINTCT("0","DHCTID",ArcimDr,""),-1)
	..i IntctRowid="" s itemcode="",itemname="",itemtype="",feetype=""
	..e  d
	...s InsuDr=$p(^DHCINTCT(IntctRowid),"^",4)
	...s itemcode=$p(^DHCINTIM(InsuDr),"^",3)  ///医保项目代码
	...s itemname=$p(^DHCINTIM(InsuDr),"^",4)  ///医保项目名称
	...s itemtype=$p(^DHCINTIM(InsuDr),"^",1)  ///项目类别
	...s feetype=$p(^DHCINTIM(InsuDr),"^",36)   ///收费类别
	..s unitprice=$p(mCorrDiv,"^",5)            ///单价
	..s count=$p(mCorrDiv,"^",4)                ///数量
	..s fee=$p(mCorrDiv,"^",6)                  ///项目总金额
	..s feein=$p(mCorrDiv,"^",9)                ///医保内金额
	..s feeout=$p(mCorrDiv,"^",10)              ///医保外金额
	..s selfpay2=$p(mCorrDiv,"^",11)            ///个人自付2
	..s state=$p(mCorrDiv,"^",13)               ///分解状态
	..s preferfee=""                            ///社区优惠金额
	..s preferscale=""                          ///社区优惠比例
	..s InString=tradeno_"^"_ChildSub_"^"_hiscode_"^"_itemcode_"^"_itemname
	..s InString=InString_"^"_itemtype_"^"_unitprice_"^"_count_"^"_fee_"^"_feein_"^"_feeout_"^"_selfpay2_"^"_state_"^"_feetype_"^"_preferfee_"^"_preferscale
    ..;w InString,!
    ..i Str=""  s Str=InString
    ..e  s Str=Str_"|"_InString
    e  d
    .s AdmDr=$p(^DHCINADM(ID),"^",1)
    .s tradeno=$p(^DHCINADM(ID),"^",10)
    .s Info=##class(web.DHCOPAdm).GetInsuBillParaByAdmID(AdmDr)
    .q:Info=""
    .i +Info<0 w Info,!
    .q:+Info<0
    .s i=$l(Info,"!")
    .f ChildSub=2:1:i  d
    ..s TarItemInfo=$p(Info,"!",ChildSub)
    ..s ArcimDr=$p(TarItemInfo,"^",1)
    ..s IntctRowid=$o(^DHCINTCT("0","DHCTID",ArcimDr,""),-1)
	..i IntctRowid="" s itemcode="",itemname="",itemtype="",feetype=""
	..e  d
	...s InsuDr=$p(^DHCINTCT(IntctRowid),"^",4)
	...s itemcode=$p(^DHCINTIM(InsuDr),"^",3)  ///医保项目代码
	...s itemname=$p(^DHCINTIM(InsuDr),"^",4)  ///医保项目名称
	...s itemtype=$p(^DHCINTIM(InsuDr),"^",1)  ///项目类别
	...s feetype=$p(^DHCINTIM(InsuDr),"^",36)   ///收费类别
    ..s hiscode=$p(TarItemInfo,"^",2)  ///His项目代码
	..;s itemdesc=$p(TarItemInfo,"^",3)  ///His项目名称
	..s unitprice=$p(TarItemInfo,"^",4)  ///单价
	..s fee=unitprice,feein=unitprice    ///项目总金额，医保内金额
	..s feeout="",selfpay2="",state="",preferfee="",preferscale="" 
	..s count="1" 
	..s InString=tradeno_"^"_(ChildSub-1)_"^"_hiscode_"^"_itemcode_"^"_itemname
	..s InString=InString_"^"_itemtype_"^"_unitprice_"^"_count_"^"_fee_"^"_feein_"^"_feeout_"^"_selfpay2_"^"_state_"^"_feetype_"^"_preferfee_"^"_preferscale                        
    ..i Str=""  s Str=InString
    ..e  s Str=Str_"|"_InString
    q Str
}

ClassMethod GetColumes() As %String
{
	;s Str="INPAYdjlsh0"_"^"_"INADMInsuId"_"^"_"INADMCardNo"_"^"_"INPAYming0"_"^"_"INPAYDhcInvPrtDr"
	;s Str=Str_"^"_"INPAYiDateTime"_"^"_"INADMAdmType"_"^"_"INPAYbcbxf0"_"^"_"INPAYInsuPay1"_"^"_"INPAYgrzfe0"
	;s Str=Str_"^"_"YBZFHJ"_"^"_"grzhye"_"^"_"ybnzje"_"^"_"ybwzje"_"^"_"ybhdbz"
	;s Str=Str_"^"_"ybhdsj"_"^"_"PrtNo"_"^"_"jssj"_"^"_"DivDr"
	s Str="结算流水号"_"^"_"医保号"_"^"_"医保卡号"_"^"_"姓名"_"^"_"发票ID"
	s Str=Str_"^"_"操作日期"_"^"_"医疗类别"_"^"_"总金额"_"^"_"统筹支付"_"^"_"现金支付"
	s Str=Str_"^"_"医保支付总额"_"^"_"grzhye"_"^"_"ybnzje"_"^"_"ybwzje"_"^"_"ybhdbz"
	s Str=Str_"^"_"ybhdsj"_"^"_"发票号"_"^"_"结算时间"_"^"_"HIS结算ID"
	;s str="INPAY_Rowid^INPAY_AdmDr^INPAY_AdmInfoDr^INPAY_DHCpblDr^INPAY_DhcInvPrtDr^INPAY_Flag^INPAY_INSUDivideDr^INPAY_bcbxf0^INPAY_djlsh0^INPAY_bckbcs^INPAY_bqbm00^INPAY_brnl00^INPAY_cardno^INPAY_cfxms0^INPAY_crbcts^INPAY_grzfe0^INPAY_iDate^INPAY_iTime^INPAY_id0000^INPAY_jjzfe0^INPAY_ptbcts^INPAY_sUserDr^INPAY_sfrq00^INPAY_sfrxm0^INPAY_sfsj00^INPAY_sftsbz^INPAY_xbie00^INPAY_xming0^INPAY_zhzfe0^INPAY_zyksmc^INPAY_zylsh0^INPAY_InsuPay1^INPAY_InsuPay2^INPAY_InsuPay3^INPAY_InsuPay4^INPAY_InsuPay5^INPAY_Zstr01^INPAY_Zstr02^INPAY_Zstr03^INPAY_Zstr04^INPAY_Zstr05^INPAY_Zstr06^INPAY_Zstr07^INPAY_Zstr08^INPAY_Zstr09^INPAY_Zstr10^INPAY_InsuPay6^INPAY_InsuPay7^INPAY_InsuPay8^INPAY_InsuPay9^INPAY_InsuPay10^INPAY_Zstr11^INPAY_Zstr12^INPAY_Zstr13^INPAY_Zstr14^INPAY_Zstr15^INPAY_Zstr16^INPAY_Zstr17^INPAY_Zstr18^INPAY_Zstr19^INPAY_Zstr20^INPAY_Zstr21^INPAY_Zstr22^INPAY_Zstr23^INPAY_Zstr24^INPAY_Zstr25^INPAY_Zstr26^INPAY_Zstr27^INPAY_Zstr28^INPAY_Zstr29^INPAY_Zstr30"
	q Str
}

/// ______________________________________________________________________________________________________________________________________________________
/// 新增函数列表
/// QryBalanceHISErrorByDate
/// QryBalanceINSUErrorByDate
/// CheckINVOfINSU			检验DHC_INVPRT表数据，是否属于医保数据（包括挂号、收费）
/// CheckAccPayINVOfINSU	检验DHC_AccPayINV表数据，是否属于医保数据
/// CheckMobileINVOfINSU	检验DHC_AccPayINV表数据，是否属于医保数据
/// ChangeINVPRTFlag		转换DHC_INVPRT的PRT_Flag值     结算数据->N,被作废数据->B,作废数据->S
/// ChangeAccPayINVFlag		转换DHC_AccPayINV的API_Flag值，结算数据->N,被作废数据->B,作废数据->S
/// ChangeMobileFlag		转换DHC_INVPRTInsu的Flag值，结算数据->N,被作废数据->B,作废数据->S
/// ChangeINSUFlag			转换DHC_Divide的INPAY_Flag值，结算数据->N,被作废数据->B,作废数据->S
/// CheckINSUDivRightByINDivDrFlag 	根据计费业务传进来的 INSUDivDr、Flag 核查 医保结算表INUS_Divide表里,数据的正确性.			
/// CheckINSURegRightByINADMDrFlag 	根据计费业务传进来的 INSUADMDr、Flag 核查 医保结算表INUS_Divide表里,数据的正确性.
/// CheckINVRegRightByINADMDrFlag	根据医保传进来的INSUAdmInfoDr、Flag 核查 在DHC_INVPRT 表 “是否有、并且状态正确” 的  挂号 数据
/// CheckINVDivRightByINDIVDrFlag	根据医保传进来的INSUDivDr、Flag 核查 在DHC_INVPRT 表 “是否有、并且结算状态正确” 的对应数据
/// CheckAccRightByINDIVDrFlag		根据医保传进来的INSUDivDr、Flag 核查 在DHC_AccPayINV表 “是否有、并且结算状态正确” 的对应数据
/// CheckMobileRightByINDIVDrFlag	根据医保传进来的INSUDivDr、Flag 核查 在DHC_INVPRTInsu 表 “是否有、并且结算状态正确” 的对应数据
/// GetINSUADMDrByAdmDr				根据PA_ADM表 Rowid  在DHCRegistrationFee表中  取医保挂号表 INSU_AdmInfo 表 rowid
/// GetBalanceRegByDate				获取一段时间内，DHC_INVPRT表 挂号、自助机挂号 的异常医保结算数据
/// GetBalanceINVByDate				获取一段时间内，DHC_INVPRT表 收费业务 的异常医保结算数据
/// GetBalanceINVACCPByDate			获取一段时间内，DHC_AccPayINV表 收费业务 的异常医保结算数据
/// GetBalanceMobileByDate			获取一段时间内，DHC_INVPRTInsu表 移动支付方式异常医保结算数据
/// GetBalanceALLHISOPErrorByDate	获取一段时间内，HIS所有对账错误数据
/// GetBalanceALLHISOPErrorTab		获取^CacheTemp("INSUBalance",PID,"OP")节点下 节点分类信息
/// GetBalanceALLINSUOPErrorByDate	获取一段时间内，INSU_Divide表 的 所有对账错误数据
/// CheckINSUDivOfReg				判断INSUDivDr 是否为挂号费用数据
/// ______________________________________________________________________________________________________________________________________________________
/// Creator：   		zhangdongliang
/// CreatDate： 		2018-03-14
/// Description:： 		查询HIS收费业务，对账错误的数据
/// Table： 						
/// Input： 			STDate 	开始日期, 
/// 					EndDate 结束日期，
/// 					Type： 	查询类别 
/// 					PID     需要查询的global的PID节点值
/// 					Type值 用途：	
/// 									INVReg 	输出 挂号 错误数据
/// 									INVDiv 	输出 普通门诊 错误数据
/// 									AccPay  输出 集中打印 错误数据
/// 									Mobile	输出 移动支付 错误数据
/// Output： 		   	登记号	姓名	就诊表Dr	HIS业务日期	HIS结算状态	INVPRTDr	医保结算表Dr	HIS操作员	数据来源表Dr	医保结算状态	医保业务日期	医保操作员	医疗类别
/// 1: 	^CacheTemp("INSUBalance",1,"OP","AccPay","Error",1)	=	"0000000024^条码卡卡支付2^58^2018-03-01^正常结算^222779^2742^cashier^21767^无效数据^2018-03-01^Demo Group^11"
/// 2: 	^CacheTemp("INSUBalance",1,"OP","INVDiv","Error",1)	=	"0000000026^保保01^18^2018-03-01^正常结算^222761^2731^cashier^222761^无效数据^2018-03-01^Demo Group^11"
/// 3: 	^CacheTemp("INSUBalance",1,"OP","INVDiv","Error",2)	=	"0000000026^保保01^18^2018-03-01^作废^222765^2732^cashier^222765^无效数据^2018-03-01^cashier^11"
/// 4: 	^CacheTemp("INSUBalance",1,"OP","INVDiv","Error",3)	=	"0000000026^保保01^18^2018-03-01^正常结算^222766^2735000000^cashier^222766^^^^"
/// 5: 	^CacheTemp("INSUBalance",1,"OP","INVReg","Error",1)	=	"0000000026^保保01^18^2018-03-01^正常结算^222748^922^cashier^222748^无效数据^2018-03-01^Demo Group^11"
/// Return： 			
/// Others： 			
/// d ##class(%ResultSet).RunQuery("web.DHCINSUBalance","QryBalanceHISErrorByDate","INVDiv","1")
Query QryBalanceHISErrorByDate(Type, PID) As %Query(ROWSPEC = "PAPMINO,PAPMIName,AdmDr,HISiDate,HISFlag,DHCINVPRTDr,PRTInsDivDR,HISUser,BLLDataRowid,INSUFlag,INSUiDate,INSUUser,INSUAdmType,PID,HISAmount")
{
}

ClassMethod QryBalanceHISErrorByDateExecute(ByRef qHandle As %Binary, Type, PID) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	Set qHandle=$lb(0,repid,0)
 	
 	s ^CacheTemp("QryBalanceHISErrorByDate")=Type_","_PID
 	q:(Type="")||(PID="") $$$OK 
 	q:(Type'="INVReg")&&(Type'="INVDiv")&&(Type'="AccPay")&&(Type'="Mobile")&&(Type'="INVPEDiv") $$$OK
 	
 	s (TempStr,ErrorCount,index)=""
 	s (PAPMINO,PAPMIName,AdmDr,HISiDate,HISFlag,DHCINVPRTDr,PRTInsDivDR,HISUser,BLLDateRowid,INSUFlag,INSUiDate,INSUUser,INSUAdmType)=""
 	s index=""
 	f  s index=$o(^CacheTemp("INSUBalance",PID,"OP",Type,"Error",index))  q:(index="")  d
 	.s TempStr=$g(^CacheTemp("INSUBalance",PID,"OP",Type,"Error",index))
	.;1~5
	.s PAPMINO=$p(TempStr,"^",1)
	.s PAPMIName=$p(TempStr,"^",2)
	.s AdmDr=$p(TempStr,"^",3)
	.s HISiDate=$p(TempStr,"^",4)
	.s:HISiDate'="" HISiDate=$zdh(HISiDate,3)
	.s:+HISiDate>0 HISiDate=##class(websys.Conversions).DateLogicalToHtml(HISiDate)
	.s HISFlag=$p(TempStr,"^",5)
	.;6~10
	.s DHCINVPRTDr=$p(TempStr,"^",6)
	.s PRTInsDivDR=$p(TempStr,"^",7)
	.s HISUser=$p(TempStr,"^",8)
	.s BLLDataRowid=$p(TempStr,"^",9)
	.s INSUFlag=$p(TempStr,"^",10)
	.;11~15
	.s INSUiDate=$p(TempStr,"^",11)
	.s:INSUiDate'="" INSUiDate=$zdh(INSUiDate,3)
	.s:+INSUiDate>0 INSUiDate=##class(websys.Conversions).DateLogicalToHtml(INSUiDate)
	.s INSUUser=$p(TempStr,"^",12)
	.s INSUAdmType=$p(TempStr,"^",13)
	.s HISAmount=$p(TempStr,"^",14)
	.d OutputRow
	
	
	 ;k ^CacheTemp("INSUBalance",PID,"OP",Type)
  
  Quit $$$OK
	
OutputRow
	set Data=$lb(PAPMINO,PAPMIName,AdmDr,HISiDate,HISFlag,DHCINVPRTDr,PRTInsDivDR,HISUser,BLLDataRowid,INSUFlag,INSUiDate,INSUUser,INSUAdmType,PID,HISAmount)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryBalanceHISErrorByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryBalanceHISErrorByDateExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryBalanceHISErrorByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryBalanceHISErrorByDateExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：   		zhangdongliang
/// CreatDate： 		2018-03-14
/// Description:： 		查询医保收费业务，对账错误的数据
/// Table： 						
/// Input： 			STDate 开始日期, 
/// 						EndDate 结束日期
/// Output： 		   	;登记号	姓名	就诊表Dr	医保业务日期	医保结算状态	INVPRTDr	医保结算表Dr	医保操作员	医疗类别	医保号  挂号/收费 总金额
/// Return： 			
/// Others： 			
/// d ##class(%ResultSet).RunQuery("web.DHCINSUBalance","QryBalanceINSUErrorByDate","2018-03-01","2018-04-10")
/// ^CacheTemp("INSUBalance",5,"OP","INSU","Error",1)	=	"0000000026^保保01^18^2018-03-01^正常结算^222766^2735^Demo Group^11^001^收费"
Query QryBalanceINSUErrorByDate(STDate, EndDate, HospDr = "") As %Query(ROWSPEC = "PAPMINO,PAPMIName,AdmDr,INSUiDate,INSUFlag,DHCINVPRTDr,INSUDivDr,INSUUser,INSUAdmType,InsuId,FairType,INSUAmount,HISFlag,PrtInsDivDr")
{
}

ClassMethod QryBalanceINSUErrorByDateExecute(ByRef qHandle As %Binary, STDate, EndDate, HospDr = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	Set qHandle=$lb(0,repid,0)
    
    s ^CacheTemp("QryBalanceINSUError")=STDate_","_EndDate
 	q:(STDate="")||(EndDate="") $$$OK 

 	s:STDate["-" STDate=$zdh(STDate,3)
	s:EndDate["-" EndDate=$zdh(EndDate,3)
	s:STDate["/" STDate=$zdh(STDate,4)
	s:EndDate["/" EndDate=$zdh(EndDate,4)
 	s (TempStr,PID,ErrorCount,index)=""
 	s (PAPMINO,PAPMIName,AdmDr,INSUiDate,INSUFlag,DHCINVPRTDr,INSUDivDr,INSUUser,INSUAdmType,InsuId,FairType,INSUAmount,HISFlag,PrtInsDivDr)=""
	
	;登记号	姓名	就诊表Dr	医保业务日期	医保结算状态	INVPRTDr	医保结算表Dr	医保操作员	医疗类别	医保号  挂号/收费
	;登记号	姓名	就诊表Dr	医保业务日期	医保结算状态	INVPRTDr	医保结算表Dr	医保操作员	医疗类别	医保号  挂号/收费 医保总金额 HIS结算状态 

	s TempStr=..GetBalanceALLINSUOPErrorByDate(STDate, EndDate,HospDr)
	
 	s PID=$p(TempStr,"|",1)
 	s ErrorCount=$p(TempStr,"|",2)
 	s index=""
 	f  s index=$o(^CacheTemp("INSUBalance",PID,"OP","INSU","Error",index))  q:(index="")  d
 	.s TempStr=$g(^CacheTemp("INSUBalance",PID,"OP","INSU","Error",index))
	.;1~5
	.s PAPMINO=$p(TempStr,"^",1)
	.s PAPMIName=$p(TempStr,"^",2)
	.s AdmDr=$p(TempStr,"^",3)
	.s INSUiDate=$p(TempStr,"^",4)
	.s:INSUiDate'="" INSUiDate=$zdh(INSUiDate,3)
	.s:+INSUiDate>0 INSUiDate=##class(websys.Conversions).DateLogicalToHtml(INSUiDate)
	.s INSUFlag=$p(TempStr,"^",5)
	.;6~10
	.s DHCINVPRTDr=$p(TempStr,"^",6)
	.s INSUDivDr=$p(TempStr,"^",7)
	.s INSUUser=$p(TempStr,"^",8)
	.s INSUAdmType=$p(TempStr,"^",9)
	.s InsuId=$p(TempStr,"^",10)
	.;11~15
	.s FairType=$p(TempStr,"^",11)
	.s INSUAmount=$p(TempStr,"^",12)
	.s HISFlag=$p(TempStr,"^",13)
	.s PrtInsDivDr=$p(TempStr,"^",14) //+DingSH 20200907
	.d OutputRow1

  Quit $$$OK
	
OutputRow1
	//set Data=$lb(PAPMINO,PAPMIName,AdmDr,HISiDate,HISFlag,DHCINVPRTDr,INSUDivDr,HISUser,BLLDateRowid,INSUFlag,INSUiDate,INSUUser,INSUAdmType,InsuId,FairType,INSUAmount,HISFlag)
	set Data=$lb(PAPMINO,PAPMIName,AdmDr,INSUiDate,INSUFlag,DHCINVPRTDr,INSUDivDr,INSUUser,INSUAdmType,InsuId,FairType,INSUAmount,HISFlag,PrtInsDivDr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryBalanceINSUErrorByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryBalanceINSUErrorByDateExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryBalanceINSUErrorByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryBalanceINSUErrorByDateExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：   		zhangdongliang
/// CreatDate： 		2018-03-11
/// Description:： 		检验DHC_INVPRT表数据，是否属于医保数据（包括挂号、收费）
/// Table： 			DHC_INVPRT
/// Input： 			DHCINVPRTDr	:	DHC_INVPRT表 Rowid
/// Output： 					
/// Return： 			Y： 医保数据
/// 					N： 非医保数据
/// Others： 			PRTInsDivDR、initPRTInsDivDR不同时为空，则是医保数据
/// 	w ##class(web.DHCINSUBalance).CheckINVOfINSU(2202000)
ClassMethod CheckINVOfINSU(DHCINVPRTDr) As %String
{
	n (DHCINVPRTDr)
	s OutStr="N",PassINVPRT="N"	
	s (PRTinitInvDR,PRTInsDivDR,initPRTInsDivDR)=""
	s DHCINVPRTInfo=$g(^DHCINVPRT(DHCINVPRTDr))
	s PRTFlag=..ChangeINVPRTFlag(DHCINVPRTDr)
	s PRTAmount=$p(DHCINVPRTInfo,"^",1)
	s PRTinitInvDR=$p(DHCINVPRTInfo,"^",13)
	s PRTInsDivDR=$p(DHCINVPRTInfo,"^",30)
	s PRTFairType=$p(DHCINVPRTInfo,"^",34)
	i PRTinitInvDR'="" d
	.s initPRTInsDivDR=$p(^DHCINVPRT(PRTinitInvDR),"^",30)	;被作废数据的INSUDivDr
	i (PRTInsDivDR'="")||(initPRTInsDivDR'="")  d
	.s OutStr="Y"
	
	;过号补打发票，被作废、作废的数据不参与医保对账。
	;PRTFlag="B"时，DHCINVPRTDr在PRT_OldINV_DR 字段有索引
	;PRTFlag="S"时，PRTinitInvDR在PRT_OldINV_DR 字段有索引
	i PRTFlag="B" d
	.i $d(^DHCINVPRT(0,"OldINV",DHCINVPRTDr))'=0 d
	..s NewDHCINVPRTDr=$o(^DHCINVPRT(0,"OldINV",DHCINVPRTDr,""))
	..s NewPRTAmount=$p($g(^DHCINVPRT(NewDHCINVPRTDr)),"^",1)
	..q:NewPRTAmount'=PRTAmount
	..s PassINVPRT="Y"
	i PRTFlag="S" d
	.i $d(^DHCINVPRT(0,"OldINV",PRTinitInvDR))'=0 d
	..s NewDHCINVPRTDr=$o(^DHCINVPRT(0,"OldINV",PRTinitInvDR,""))
	..s NewPRTAmount=$p($g(^DHCINVPRT(NewDHCINVPRTDr)),"^",1)
	..q:$ZABS(NewPRTAmount)'=$ZABS(PRTAmount)
	..s PassINVPRT="Y"
	i PassINVPRT="Y" s OutStr="N"		;判断是否为过号重打发票数据
	;end
		
	q:OutStr="Y" OutStr			;PRTInsDivDR存储了医保业务Dr，直接退出。
	q:PRTFairType="F" OutStr   	;收费数据判断到这里即可退出。避免 DHC_INVPRT 作为小条表时，走下面逻辑。
	
	/*
	;下面是挂号数据，并且PRTInsDivDR未存储INSUAdmInfoDr时，通过医生站挂号表判断。
	s DHCBCIDr=$o(^DHCBCI(0,"INV",DHCINVPRTDr,""))
	i DHCBCIDr'=""  d
	.s AdmDr=$p($g(^DHCBCI(DHCBCIDr)),"^",3)
	.s INSUAdmInfoDr=..GetINSUADMDrByAdmDr(AdmDr)
	.i (INSUAdmInfoDr'="") d
	..s OutStr="Y"
	*/
	
	q OutStr
}

/// Creator：   		zhangdongliang
/// CreatDate： 		2018-03-12
/// Description:： 		检验DHC_AccPayINV表数据，是否属于医保数据
/// Table： 			DHC_AccPayINV
/// Input： 			DHCAccPayINVDr	:	DHC_AccPayINV表 Rowid
/// Output： 					
/// Return： 			Y： 医保数据
/// 					N： 非医保数据
/// Others： 			APIInsDivDR ,initAPIInsDivDR 不同时为空，则是医保数据
/// 	w ##class(web.DHCINSUBalance).CheckAccPayINVOfINSU(21766)
ClassMethod CheckAccPayINVOfINSU(DHCAccPayINVDr) As %String
{
	n (DHCAccPayINVDr)
	s OutStr="N"
	
	;集中打印表
	s (APIInsDivDR,initAPIInsDivDR)=""
	s APIInfo=$g(^DHCINVPRTAP(DHCAccPayINVDr))
	s APIPayINVDR=$p(APIInfo,"^",10)
	s APIInsDivDR=$p(APIInfo,"^",19)	
	i APIPayINVDR'="" d
	.s initAPIInsDivDR=$p($g(^DHCINVPRTAP(APIPayINVDR)),"^",19)	

	i (APIInsDivDR'="")||(initAPIInsDivDR'="")  d
	.s OutStr="Y"
	
	q OutStr
}

/// Creator：   		zhangdongliang
/// CreatDate： 		2018-03-12
/// Description:： 		检验DHC_AccPayINV表数据，是否属于医保数据
/// Table： 			DHC_AccPayINV
/// Input： 			DHCAccPayINVDr	:	DHC_AccPayINV表 Rowid
/// Output： 					
/// Return： 			Y： 医保数据
/// 					N： 非医保数据
/// Others： 			APIInsDivDR ,initAPIInsDivDR 不同时为空，则是医保数据
/// 	w ##class(web.DHCINSUBalance).CheckMobileINVOfINSU()
ClassMethod CheckMobileINVOfINSU(DHCINVPRTInsuDr) As %String
{
	n (DHCAccPayINVDr)
	s OutStr="N"

	s (InsDivDR,initInsDivDR)=""
	s PrtInsuInfo=$g(^DHCINVPRTInsu(DHCINVPRTInsuDr))
	s initinvDr=$p(PrtInsuInfo,"^",14)
	s InsDivDR=$p(PrtInsuInfo,"^",17)	
	i initinvDr'="" d
	.s initInsDivDR=$p($g(^DHCINVPRTAP(initinvDr)),"^",17)	

	i (InsDivDR'="")||(initInsDivDR'="")  d
	.s OutStr="Y"
	
	q OutStr
}

/// Creator：   		zhangdongliang
/// CreatDate： 		2018-03-11
/// Description:： 		转换DHC_INVPRT的PRT_Flag值
/// Table： 			
/// Input： 			DHCINVPRTDr	:	DHC_INVPRT表 Rowid
/// Output： 					
/// Return： 			
/// 					N： 正常结算数据
/// 					B： N被作废之后变为B（被作废数据）
/// 					S:	指向B的记录（作废数据）
/// Others： 			PRT_Flag 字段 被作废\作废 都是S,若要区分数据,还要根据PRT_initInvDR字段才能区分,所有直接封装后使用.
/// 					功能单一
/// w ##class(web.DHCINSUBalance).ChangeINVPRTFlag(222768)
ClassMethod ChangeINVPRTFlag(DHCINVPRTDr) As %String
{
	n (DHCINVPRTDr)	
	s (OutStr)=""
	
	q:DHCINVPRTDr="" OutStr
	q:$d(^DHCINVPRT(DHCINVPRTDr))=0 OutStr
	
	s DHCINVPRTInfo=$g(^DHCINVPRT(DHCINVPRTDr))
	s PRTFlag=$p(DHCINVPRTInfo,"^",8)
	s PRTinitInvDR=$p(DHCINVPRTInfo,"^",13)
	i PRTFlag="N"  s OutStr="N"
	i (PRTFlag="A")||(PRTFlag="S") d
	.i PRTinitInvDR="" d
	..s OutStr="B"
	.e  d
	..s OutStr="S"

	q OutStr
}

/// Creator：   		zhangdongliang
/// CreatDate： 		2018-03-12
/// Description:： 		转换DHC_AccPayINV的API_Flag值，结算数据->N,被作废数据->B,作废数据->S
/// Table： 			
/// Input： 			DHC_AccPayINV	:	DHC_AccPayINV Rowid
/// Output： 					
/// Return： 			
/// 					N： 正常结算数据
/// 					B： N被作废之后变为B（被作废数据）
/// 					S:	指向B的记录（作废数据）
/// Others： 			PRT_Flag 字段 被作废\作废 都是S,若要区分数据,还要根据PRT_initInvDR字段才能区分,所有直接封装后使用.
/// 					功能单一
/// w ##class(web.DHCINSUBalance).ChangeAccPayINVFlag(298)
ClassMethod ChangeAccPayINVFlag(DHCAccPayINVDr) As %String
{
	n (DHCAccPayINVDr)	
	s (OutStr)=""
	
	q:DHCAccPayINVDr="" OutStr
	q:$d(^DHCINVPRTAP(DHCAccPayINVDr))=0 OutStr
	
	s APIInfo=$g(^DHCINVPRTAP(DHCAccPayINVDr))
	s APIFlag=$p(APIInfo,"^",2)
	s APIPayINVDR=$p(APIInfo,"^",10)
	s APIInsDivDR=$p(APIInfo,"^",19)
	b ;11	
	i APIFlag="N"  s OutStr="N"
	i (APIFlag="A")||(APIFlag="S") d
	.i APIPayINVDR="" d
	..s OutStr="B"
	.e  d
	..s OutStr="S"

	q OutStr
}

/// Creator：   		zhangdongliang
/// CreatDate： 		2018-03-12
/// Description:： 		转换DHC_INVPRTInsu的Flag值，结算数据->N,被作废数据->B,作废数据->S
/// Table： 			
/// Input： 			DHC_INVPRTInsu	:	DHC_INVPRTInsu Rowid
/// Output： 					
/// Return： 			
/// 					N： 正常结算数据
/// 					B： N被作废之后变为B（被作废数据）
/// 					S:	指向B的记录（作废数据）
/// Others： 			PRT_Flag 字段 被作废\作废 都是S,若要区分数据,还要根据PRT_initInvDR字段才能区分,所有直接封装后使用.
/// 					功能单一
/// w ##class(web.DHCINSUBalance).ChangeAccPayINVFlag(21767)
ClassMethod ChangeMobileFlag(DHCINVPRTInsuDr) As %String
{
	n (DHCINVPRTInsuDr)	
	s (OutStr)=""
	
	q:DHCINVPRTInsuDr="" OutStr
	q:$d(^DHCINVPRTInsu(DHCINVPRTInsuDr))=0 OutStr
	
	s PrtInsuInfo=$g(^DHCINVPRTInsu(DHCINVPRTInsuDr))
	s PrtInsuFlag=$p(PrtInsuInfo,"^",9)	
	s PrtInsuinitinvDr=$p(PrtInsuInfo,"^",14)
	s PrtInsuInsDivDR=$p(PrtInsuInfo,"^",17)	
	i PrtInsuFlag="N"  s OutStr="N"
	i (PrtInsuFlag="A")||(PrtInsuFlag="S") d
	.i PrtInsuinitinvDr="" d
	..s OutStr="B"
	.e  d
	..s OutStr="S"
	
	q OutStr
}

/// Creator：   		zhangdongliang
/// CreatDate： 		2018-03-12
/// Description:： 		转换DHC_Divide的INPAY_Flag值，结算数据->N,被作废数据->B,作废数据->S
/// Table： 			
/// Input： 			INSUDivDr	:	DHC_Divide Rowid
/// Output： 					
/// Return： 			
/// 					N： 正常结算数据
/// 					B： N被作废之后变为B（被作废数据）
/// 					S:	指向B的记录（作废数据）
/// 					D： 无效数据
/// Others： 			
/// 					功能单一
/// w ##class(web.DHCINSUBalance).ChangeINSUFlag(21767)
ClassMethod ChangeINSUFlag(INSUDivDr) As %String
{
	n (INSUDivDr)	
	s (OutStr)=""
	
	q:INSUDivDr="" OutStr
	q:$d(^DHCINDIV(INSUDivDr))=0 OutStr
	
	s INSUDivInfo=$g(^DHCINDIV(INSUDivDr))
	s INPAYFlag=$p(INSUDivInfo,"^",5)
	
	;北京项目存储的INPAYFlag与标准版不同
	s:INPAYFlag="insu" INPAYFlag="I"
	s:INPAYFlag="bestrike" INPAYFlag="B"
	s:INPAYFlag="strike" INPAYFlag="S"
	s:INPAYFlag="divide" INPAYFlag="D"
	
	;转成与计费协商的 通用标志
	i INPAYFlag="I"  s OutStr="N"
	i INPAYFlag="B"  s OutStr="B"
	i INPAYFlag="S"  s OutStr="S"
	i INPAYFlag="D"  s OutStr="D"

	q OutStr
}

/// Creator：   		zhangdongliang
/// CreatDate： 		2018-03-12
/// Description:： 		根据计费业务传进来的 INSUDivDr、Flag 核查 医保结算表INUS_Divide表里,数据的正确性.					
/// Table： 			
/// Input： 			INSUDivDr:	 医保组INSU_Divide表 Rowid
/// 								DHC_INVPRT表		收费记录	PRT_InsDiv_DR 
/// 								DHC_AccPayINV表		收费记录  	API_InsDiv_DR
/// 								DHC_INVPRTInsu表	收费记录 	PrtInsu_InsDiv_DR     
/// 					Flag:		
/// 							N： 正常结算数据
/// 							B： N被作废之后变为B（被作废数据）
/// 							S:	指向B的记录（作废数据）
/// Output： 					
/// Return： 			Y:	数据正确
/// 					N|INSUDivStr: 	数据错误|需要输出的字段值
/// Others： 			计费业务中，作废数据INSUDivDr为空，需要使用原被作废数据的 INSUDivDr，并且Flag字段传S
/// w ##class(web.DHCINSUBalance).CheckINSUDivRightByINDivDrFlag(180436,"N")
ClassMethod CheckINSUDivRightByINDivDrFlag(INSUDivDr, Flag) As %String
{
	n (INSUDivDr, Flag)
	
	s OutStr="N"
	
	;无数据
	q:INSUDivDr="" OutStr
	q:$d(^DHCINDIV(INSUDivDr))=0 OutStr
	
	/*	Flag="S"时，找对应的医保S数据
	i Flag="S" d
	.;无索引,需新增索引后才能使用下面代码。
	.s StrikeINSUDivDr=$o(^DHCINDIV(0,"INSUDivideDr",INSUDivDr,""),-1)
	.i StrikeINSUDivDr'="" d
	..s INSUDivDr=StrikeINSUDivDr
	*/
	
	s (INPAYFlag,INSUiDate,INSUUser,INSUAdmType)=""
	s INSUDivInfo=$g(^DHCINDIV(INSUDivDr))
	s INPAYFlag=..ChangeINSUFlag(INSUDivDr)

	i (Flag="N")&&(INPAYFlag="N") d
	.s OutStr="Y"
	i (Flag="B")&&(INPAYFlag="B") d
	.s OutStr="Y"
	
	;无索引时，Flag="S" 并且 INPAYFlag=B时认为数据正确。
	;i (Flag="S")&&(INPAYFlag="S") d
	i (Flag="S")&&(INPAYFlag="B") d
	.s OutStr="Y" 
	
	q:OutStr="Y" OutStr
	
	;错误数据时，需要输出的医保信息串
	s INSUAdmInfoDr=$p(INSUDivInfo,"^",2)
	i INSUAdmInfoDr'=""  d
	.s INSUAdmType=$p($g(^DHCINADM(INSUAdmInfoDr)),"^",14)
	.s INSUInsuType=$p($g(^DHCINADM(INSUAdmInfoDr)),"^",18)
	.s AdmDr=$p($g(^DHCINADM(INSUAdmInfoDr)),"^",1)
	.s tHospDr= ##class(web.UDHCHospitalGroup).GetHospitalByAdm(AdmDr)
	.s INSUAdmType=##class(web.DHCINSUPort).GetDicByCodeAndInd("AKA130"_INSUInsuType,INSUAdmType,4,tHospDr)
	
	s:INPAYFlag="N" INPAYFlag="正常结算"
	s:INPAYFlag="B" INPAYFlag="被作废"
	s:INPAYFlag="S" INPAYFlag="作废"
	s:INPAYFlag="D" INPAYFlag="预分解"
	s INSUiDate=$p(INSUDivInfo,"^",16)
	s:INSUiDate'="" INSUiDate=$zd(INSUiDate,3)	;医保结算日期
	s INSUUser=$p(INSUDivInfo,"^",21)
	s:INSUUser'="" INSUUser=$p($g(^SSU("SSUSR",INSUUser)),"^",2)
	;医保结算状态	医保业务日期	医保操作员	医疗类别
	s INSUDivStr=INPAYFlag_"^"_INSUiDate_"^"_INSUUser_"^"_INSUAdmType
	
	s OutStr=OutStr_"|"_INSUDivStr

	q OutStr
}

/// Creator：   		zhangdongliang
/// CreatDate： 		2018-03-12
/// Description:： 		根据计费业务传进来的 INSUADMDr、Flag 核查 医保结算表INUS_Divide表里,数据的正确性.					
/// Table： 			
/// Input： 			INSUADMDr	 医保组INSU_AdmInfo表 Rowid
/// 								 DHC_INVPRT表  挂号记录的  	PRT_InsDiv_DR 
/// 					Flag:		
/// 							N： 正常结算数据
/// 							B： N被作废之后变为B（被作废数据）
/// 							S:	指向B的记录（作废数据）
/// Output： 					
/// Return： 			Y:	数据正确
/// 					N: 	数据错误
/// Others： 			计费业务中，作废数据INSUADMDr为空，需要使用原被作废数据的 INSUADMDr，并且Flag字段传S
/// w ##class(web.DHCINSUBalance).CheckINSURegRightByINADMDrFlag(922,"N")
ClassMethod CheckINSURegRightByINADMDrFlag(INSUADMDr, Flag) As %String
{
	
	n (INSUADMDr, Flag)
	
	s OutStr="N"
	
	;无数据
	q:INSUADMDr="" OutStr
	q:$d(^DHCINADM(INSUADMDr))=0 OutStr
	;取INSUADMDr对应INSU_Divide表第一条数据
	s INSUDivDr=$o(^DHCINDIV(0,"ADMINFO",INSUADMDr,""))
	q:INSUDivDr="" OutStr
	q:$d(^DHCINDIV(INSUDivDr))=0 OutStr	
	
	s OutStr=..CheckINSUDivRightByINDivDrFlag(INSUDivDr,Flag)
	
	q OutStr
}

/// Creator：   		zhangdongliang
/// CreatDate： 		2018-03-13
/// Description:： 		根据医保传进来的INSUAdmInfoDr、Flag 核查 在DHC_INVPRT 表 “是否有、并且状态正确” 的  挂号 数据
/// Table： 			
/// Input： 			INSUDivDr:	INUS_Divide表 Rowid
/// 					Flag:		
/// 							N： 正常结算数据
/// 							B： N被作废之后变为B（被作废数据）
/// 							S:	指向B的记录（作废数据）
/// Output： 					
/// Return： 			Y:	数据正确
/// 					N: 	数据错误
/// Others： 			计费业务中，作废数据INSUDivDr为空，需要使用原被作废数据的 INSUDivDr 判断，并且Flag字段传S
/// w ##class(web.DHCINSUBalance)CheckINVRegRightByINADMDrFlag(2737,"N")
ClassMethod CheckINVRegRightByINADMDrFlag(INSUAdmInfoDr, Flag) As %String
{
	n (INSUAdmInfoDr, Flag)
	
	s OutStr="N"
	
	;无数据
	q:INSUAdmInfoDr="" OutStr
	
	;避免挂号、收费数据存的医保Dr重复，所以要循环取。
	s DHCINVPRTDr=""
	s TempDHCINVPRTDr=""
	f  s TempDHCINVPRTDr=$o(^DHCINVPRT("0","INSDIV",INSUAdmInfoDr,TempDHCINVPRTDr)) q:TempDHCINVPRTDr=""  d
	.s DHCINVPRTInfo=$g(^DHCINVPRT(TempDHCINVPRTDr))
	.s PRTFairType=$p(DHCINVPRTInfo,"^",34)
	.q:PRTFairType'="R"
	.s DHCINVPRTDr=TempDHCINVPRTDr
	
	;当INVPRT无数据，医保是B/S数据时，认为不是错误数据。
	q:(DHCINVPRTDr="")&&((Flag="B")||(Flag="S")) "Y"
	q:DHCINVPRTDr="" OutStr
	
	i Flag="S" d
	.s StrikeDHCINVPRTDr=$o(^DHCINVPRT("0","InitInvDR",DHCINVPRTDr,""))
	.i StrikeDHCINVPRTDr'="" d
	..s DHCINVPRTDr=StrikeDHCINVPRTDr

	s DHCINVPRTInfo=$g(^DHCINVPRT(DHCINVPRTDr))
	s PRTFlag=..ChangeINVPRTFlag(DHCINVPRTDr)
	i (Flag="N")&&(PRTFlag="N") d
	.s OutStr="Y"
	i (Flag="B")&&(PRTFlag="B") d
	.s OutStr="Y"
	i (Flag="S")&&(PRTFlag="S") d
	.s OutStr="Y"

	q OutStr
}

/// Creator：   		zhangdongliang
/// CreatDate： 		2018-03-13
/// Description:： 		根据医保传进来的INSUDivDr、Flag 核查 在DHC_INVPRT 表 “是否有、并且结算状态正确” 的对应数据
/// Table： 			
/// Input： 			INSUDivDr:	INUS_Divide表 Rowid
/// 					Flag:		
/// 							N： 正常结算数据
/// 							B： N被作废之后变为B（被作废数据）
/// 							S:	指向B的记录（作废数据）
/// Output： 					
/// Return： 			Y:	数据正确
/// 					N: 	数据错误
/// Others： 			计费业务中，作废数据INSUDivDr为空，需要使用原被作废数据的 INSUDivDr 判断，并且Flag字段传S
/// w ##class(web.DHCINSUBalance).CheckINVDivRightByINDIVDrFlag(277,"N")
ClassMethod CheckINVDivRightByINDIVDrFlag(INSUDivDr, Flag) As %String
{
	n (INSUDivDr, Flag)
	
	s OutStr="N"
	
	;无数据
	q:INSUDivDr="" OutStr
	

	;避免挂号、收费数据存的医保Dr重复，所以要循环取。
	s DHCINVPRTDr=""
	s TempDHCINVPRTDr=""
	f  s TempDHCINVPRTDr=$o(^DHCINVPRT("0","INSDIV",INSUDivDr,TempDHCINVPRTDr)) q:TempDHCINVPRTDr=""  d
	.s DHCINVPRTInfo=$g(^DHCINVPRT(TempDHCINVPRTDr))
	.s PRTFairType=$p(DHCINVPRTInfo,"^",34)
	.;q:PRTFairType'="F" ;DingSH 20190311
	.s DHCINVPRTDr=TempDHCINVPRTDr
	
	;兰州一大，当INVPRT无数据，医保是B/S数据时，属于弹窗后点击取消结算按钮；认为不是错误数据。
	q:(DHCINVPRTDr="")&&((Flag="B")||(Flag="S")) "Y"
	;end
	b ;end
	q:DHCINVPRTDr="" OutStr

	q:$d(^DHCINVPRT(DHCINVPRTDr))=0 OutStr

	i Flag="S" d
	.s StrikeDHCINVPRTDr=$o(^DHCINVPRT("0","InitInvDR",DHCINVPRTDr,""))
	.i StrikeDHCINVPRTDr'="" d
	..s DHCINVPRTDr=StrikeDHCINVPRTDr

	s DHCINVPRTInfo=$g(^DHCINVPRT(DHCINVPRTDr))
	s PRTFlag=..ChangeINVPRTFlag(DHCINVPRTDr)
	b ;st
	i (Flag="N")&&(PRTFlag="N") d
	.s OutStr="Y"
	i (Flag="B")&&(PRTFlag="B") d
	.s OutStr="Y"
	i (Flag="S")&&(PRTFlag="S") d
	.s OutStr="Y"

	q OutStr
}

/// Creator：   		zhangdongliang
/// CreatDate： 		2018-03-13
/// Description:： 		根据医保传进来的INSUDivDr、Flag 核查 在DHC_AccPayINV表 “是否有、并且结算状态正确” 的对应数据
/// Table： 			
/// Input： 			INSUDivDr:	INUS_Divide表 Rowid
/// 					Flag:		
/// 							N： 正常结算数据
/// 							B： N被作废之后变为B（被作废数据）
/// 							S:	指向B的记录（作废数据）
/// Output： 					
/// Return： 			Y:	数据正确
/// 					N: 	数据错误
/// Others： 			计费业务中，作废数据INSUDivDr为空，需要使用原被作废数据的 INSUDivDr 判断，并且Flag字段传S
/// w ##class(web.DHCINSUBalance).CheckAccRightByINDIVDrFlag(277,"N")
ClassMethod CheckAccRightByINDIVDrFlag(INSUDivDr, Flag) As %String
{
	n (INSUDivDr, Flag)
	
	s OutStr="N"
	
	;无数据
	q:INSUDivDr="" OutStr
	s DHCAccPayINVDr=$o(^DHCINVPRTAPi("0","InsDR",INSUDivDr,""),-1)
	q:DHCAccPayINVDr="" OutStr
	q:$d(^DHCINVPRTAP(DHCAccPayINVDr))=0 OutStr
		
	i (Flag="S") d
	.s StrikeAccPDr=$o(^DHCINVPRTAPi("0","APIDR",DHCAccPayINVDr,""))
	.i StrikeAccPDr'="" d
	..s DHCAccPayINVDr=StrikeAccPDr
	
	s APIInfo=$g(^DHCINVPRTAP(DHCAccPayINVDr))
	s APIFlag=..ChangeAccPayINVFlag(DHCAccPayINVDr)		
	s APIPayINVDR=$p(APIInfo,"^",10)
	s APIInsDivDR=$p(APIInfo,"^",19)	

	i (Flag="N")&&(APIFlag="N") d
	.s OutStr="Y"
	i (Flag="B")&&(APIFlag="B") d
	.s OutStr="Y"
	i (Flag="S")&&(APIFlag="S")  d
	.s OutStr="Y"
	
	q OutStr
}

/// ;未测试 2018-03-16 
/// Creator：   		zhangdongliang
/// CreatDate： 		2018-03-13
/// Description:： 		根据医保传进来的INSUDivDr、Flag 核查 在DHC_INVPRTInsu 表 “是否有、并且结算状态正确” 的对应数据
/// Table： 			
/// Input： 			INSUDivDr:	INUS_Divide表 Rowid
/// 					Flag:		
/// 							N： 正常结算数据
/// 							B： N被作废之后变为B（被作废数据）
/// 							S:	指向B的记录（作废数据）
/// Output： 					
/// Return： 			Y:	数据正确
/// 					N: 	数据错误
/// Others： 			计费业务中，作废数据INSUDivDr为空，需要使用原被作废数据的 INSUDivDr 判断，并且Flag字段传S
/// w ##class(web.DHCINSUBalance).CheckAccRightByINDIVDrFlag(2742,"N")
ClassMethod CheckMobileRightByINDIVDrFlag(INSUDivDr, Flag) As %String
{
	n (INSUDivDr, Flag)
	
	s OutStr="N"
	
	;无数据
	q:INSUDivDr="" OutStr
	s PrtInsuRowid=$o(^DHCINVPRTInsu("0","InsDiv",INSUDivDr,""))
	q:PrtInsuRowid="" OutStr
	q:$d(^DHCINVPRTInsu(PrtInsuRowid))=0 OutStr
	
	i (Flag="S") d
	.s StrikePrtInsuRowid=$o(^DHCINVPRTAPi("0","InitInv",PrtInsuRowid,""))
	.i StrikePrtInsuRowid'="" d
	..s PrtInsuRowid=StrikePrtInsuRowid
	
	s PrtInsuInfo=$g(^DHCINVPRTInsu(PrtInsuRowid))
	s PrtInsuFlag=..ChangeMobileFlag(PrtInsuRowid)
	s PrtInsuinitinvDr=$p(PrtInsuInfo,"^",14)
	s PrtInsuInsDivDR=$p(PrtInsuInfo,"^",17)	
	
	i (Flag="N")&&(PrtInsuFlag="N") d
	.s OutStr="Y"
	i (Flag="B")&&(PrtInsuFlag="B") d
	.s OutStr="Y"
	i (Flag="S")&&(PrtInsuFlag="S") d
	.s OutStr="Y"
	
	q OutStr
}

/// Creator：   		zhangdongliang
/// CreatDate： 		2018-03-13
/// Description:： 		根据PA_ADM表 Rowid  在DHCRegistrationFee表中  取医保挂号表 INSU_AdmInfo 表 rowid
/// Table： 			DHCRegistrationFee
/// Input： 			AdmDr	PA_ADM表 Rowid					
/// Output： 					
/// Return： 			INSU_AdmInfo 表 rowid						
/// Others： 			功能单一
/// w ##class(web.DHCINSUBalance).GetINSUADMDrByAdmDr(18)
/// 此函数是医保组自己写的，需要医生站提供接口函数替换此函数
ClassMethod GetINSUADMDrByAdmDr(AdmDr) As %String
{
	n (AdmDr)
	//DHCRegistrationFee 表数据 
	s OutStr=""
	q:AdmDr="" OutStr
	
	s Admi=" "_AdmDr
	S RegFeeRowId=$O(^User.DHCRegistrationFeeI("ADM",Admi,""))
	q:RegFeeRowId="" OutStr
	s object=##class(User.DHCRegistrationFee).%OpenId(RegFeeRowId)			
	s InsuAdmInfoDr=##class(web.DHCOPAdm).GetINADMRowid(RegFeeRowId)
	s OutStr=InsuAdmInfoDr
	
	q OutStr
}

/// Creator：   		zhangdongliang
/// CreatDate： 		2018-03-11
/// Description:： 		获取一段时间内，DHC_INVPRT表 挂号、自助机挂号 的异常医保结算数据
/// 					^CacheTemp("INSUBalance",PID,"OP","INVReg","Error",ErrorCount)存异常数据
/// Table： 			
/// Input： 			STDate 开始日期, EndDate 结束日期, PID 节点增量值
/// Output： 		
/// Return： 			PID_"|"_ErrorCount_"|"_AllCount
/// 					AllCount 	所有数据的数量
/// 					ErrorCount	错误数据的数量
/// Others： 						
/// w ##class(web.DHCINSUBalance).GetBalanceRegByDate("2016-4-27","2016-4-27","1")
ClassMethod GetBalanceRegByDate(STDate, EndDate, PID, HospDr = "") As %String
{
	k ^CacheTemp("INSUBalance",PID,"OP","INVReg")
	
	s:STDate["-" STDate=$zdh(STDate,3)
	s:EndDate["-" EndDate=$zdh(EndDate,3)
	s:STDate["/" STDate=$zdh(STDate,4)
	s:EndDate["/" EndDate=$zdh(EndDate,4)
	
	s iDate=""
	;INVDr INVFlag iDate 登记号 姓名 HIS收费操作员 医保Dr 医保Flag 医保iDate 医保操作员 医疗类别
	s (PAPMINO,PAPMIName,AdmDr,PRTFlag,PRTInsDivDR,HISUser,INPAYFlag,INSUiDate,INSUUser,INSUAdmType,PRTAmount)=""
	s ErrorCount=0,AllCount=0
	f iDate=STDate:1:EndDate d
	.s DHCINVPRTDr=""
	.f  s DHCINVPRTDr=$o(^DHCINVPRT("0","Date",iDate,DHCINVPRTDr))  q:DHCINVPRTDr=""  d
	..s (PAPMINO,PAPMIName,AdmDr,PRTFlag,PRTInsDivDR,HISUser,INPAYFlag,INSUiDate,INSUUser,INSUAdmType,PRTAmount)=""		
	..s DHCINVPRTInfo=$g(^DHCINVPRT(DHCINVPRTDr))
	..s PRTFairType=$p(DHCINVPRTInfo,"^",34)
	..q:PRTFairType'="R" 
	..s Flag=..CheckINVOfINSU(DHCINVPRTDr)   		;是否属于医保数据
	..q:Flag="N"		;非医保数据退出
	
	..s PRTinitInvDR=$p(DHCINVPRTInfo,"^",13)
	..s PRTInsDivDR=$p(DHCINVPRTInfo,"^",30)
	..s PRTFlag=..ChangeINVPRTFlag(DHCINVPRTDr)						;N：正常结算数据;B: N被作废之后变为B（被作废数据）;S: 指向B的记录（作废数据）	
	..i (PRTFlag="S") d												;作废数据 取 被作废数据的 PRTInsDivDR 字段
	...s PRTInsDivDR=$p($g(^DHCINVPRT(PRTinitInvDR)),"^",30)
	..s AllCount=AllCount+1
		
	..;s RightFlagInfo=..CheckINSURegRightByINADMDrFlag(PRTInsDivDR, PRTFlag)   ;根据计费业务传进来的 INSUADMDr、Flag 核查 医保结算表INUS_Divide表里,数据的正确性.		
	..s RightFlagInfo=..CheckINSUDivRightByINDivDrFlag(PRTInsDivDR, PRTFlag)    ;DingSH 20190311
	..s RightFlag=$p(RightFlagInfo,"|",1)
	..s INSUSplitStr=$p(RightFlagInfo,"|",2)
	..q:RightFlag'="N"							;N: 	数据错误
	..s PRTAmount=$p(DHCINVPRTInfo,"^",1)
	..s PAPMIDr=$p(DHCINVPRTInfo,"^",15)
	..s PAPMINO=$p($g(^PAPER(PAPMIDr,"PAT",1)),"^",1)
	..s PAPMIName=$p($g(^PAPER(PAPMIDr,"ALL")),"^",1)   
	..s HISUser=$p(DHCINVPRTInfo,"^",21)
	..s HISUser=$p($g(^SSU("SSUSR",HISUser)),"^",2)
	..s DHCBCIDr=$o(^DHCBCI(0,"INV",DHCINVPRTDr,""),-1)
	..s tHospDr=""
	..i DHCBCIDr'=""  d
	...s AdmDr=$p($g(^DHCBCI(DHCBCIDr)),"^",3)
	...s tHospDr = ##class(web.UDHCHospitalGroup).GetHospitalByAdm(AdmDr) //+ DingSH 20200612
	..q:tHospDr'=HospDr
	..s INPAYFlag=$p(INSUSplitStr,"^",1)
	..s:INPAYFlag="" INPAYFlag="无医保数据"
	..s INSUiDate=$p(INSUSplitStr,"^",2)
    ..s INSUUser=$p(INSUSplitStr,"^",3)
	..s INSUAdmType=$p(INSUSplitStr,"^",4)
	..s:PRTFlag="N" PRTFlag="正常结算"
	..s:PRTFlag="B" PRTFlag="被作废"
	..s:PRTFlag="S" PRTFlag="作废"
	..s Str=PAPMINO_"^"_PAPMIName_"^"_AdmDr_"^"_$zd(iDate,3)_"^"_PRTFlag
	..s Str=Str_"^"_DHCINVPRTDr_"^"_PRTInsDivDR_"^"_HISUser_"^"_DHCINVPRTDr_"^"_INPAYFlag
	..s Str=Str_"^"_INSUiDate_"^"_INSUUser_"^"_INSUAdmType_"^"_PRTAmount
	..s ErrorCount=ErrorCount+1
	..s ^CacheTemp("INSUBalance",PID,"OP","INVReg","Error",ErrorCount)=Str

	
	;登记号	姓名	就诊表Dr	HIS业务日期	HIS结算状态	INVPRTDr	医保结算表Dr	HIS操作员	数据来源表Dr	医保结算状态	医保业务日期	医保操作员	医疗类别
	
	q PID_"|"_ErrorCount_"|"_AllCount
}

/// Creator：   		zhangdongliang
/// CreatDate： 		2018-03-11
/// Description:： 		获取一段时间内，DHC_INVPRT表 收费业务 的异常医保结算数据
/// 					^CacheTemp("INSUBalance",PID,"OP","INVDiv","Error",ErrorCount)存异常数据
/// Table： 			DHC_INVPRT
/// Input： 			STDate 开始日期, EndDate 结束日期, PID 节点增量值
/// Output： 		
/// Return： 			PID_"|"_ErrorCount_"|"_AllCount
/// 					AllCount 	所有数据的数量
/// 					ErrorCount	错误数据的数量
/// Others： 		
/// w ##class(web.DHCINSUBalance).GetBalanceINVByDate("2015-03-01","2015-06-01","1")
/// w ##class(web.DHCINSUBalance).GetBalanceINVByDate("2018-03-01","2018-03-01","1")
/// 分产品线写函数， 注意封装 
ClassMethod GetBalanceINVByDate(STDate, EndDate, PID, HospDr = "") As %String
{
	k ^CacheTemp("INSUBalance",PID,"OP","INVDiv")
	
	s:STDate["-" STDate=$zdh(STDate,3)
	s:EndDate["-" EndDate=$zdh(EndDate,3)
	s:STDate["/" STDate=$zdh(STDate,4)
	s:EndDate["/" EndDate=$zdh(EndDate,4)
	
	s iDate=""
	s (PAPMINO,PAPMIName,AdmDr,PRTFlag,PRTInsDivDR,HISUser,INPAYFlag,INSUiDate,INSUUser,INSUAdmType,PRTAmount)=""
	s ErrorCount=0,AllCount=0
	f iDate=STDate:1:EndDate d
	.s DHCINVPRTDr=""
	.f  s DHCINVPRTDr=$o(^DHCINVPRT("0","Date",iDate,DHCINVPRTDr))  q:DHCINVPRTDr=""  d
	..s (PAPMINO,PAPMIName,AdmDr,PRTFlag,PRTInsDivDR,HISUser,INPAYFlag,INSUiDate,INSUUser,INSUAdmType,PRTAmount)=""
	..s DHCINVPRTInfo=$g(^DHCINVPRT(DHCINVPRTDr))
	..s PRTFairType=$p(DHCINVPRTInfo,"^",34)
	..q:PRTFairType'="F"  
	..s Flag=..CheckINVOfINSU(DHCINVPRTDr)   		;是否属于医保数据
	..q:Flag="N"		;非医保数据退出
	..s PRTinitInvDR=$p(DHCINVPRTInfo,"^",13)
	..s PRTInsDivDR=$p(DHCINVPRTInfo,"^",30)
	..s PRTFlag=..ChangeINVPRTFlag(DHCINVPRTDr)						;N：正常结算数据;B: N被作废之后变为B（被作废数据）;S: 指向B的记录（作废数据）
	..i (PRTFlag="S") d
	...s PRTInsDivDR=$p($g(^DHCINVPRT(PRTinitInvDR)),"^",30)		;作废数据 取 被作废数据的 PRTInsDivDR 字段
	..s AllCount=AllCount+1
	..;s ^CacheTemp("INSUBalance",PID,"OP","INVDiv","ALL",AllCount)=DHCINVPRTDr
	
	..s RightFlagInfo=..CheckINSUDivRightByINDivDrFlag(PRTInsDivDR, PRTFlag)	;医保结算表INUS_Divide表里,数据的正确性.
	..s RightFlag=$p(RightFlagInfo,"|",1)
	..s INSUSplitStr=$p(RightFlagInfo,"|",2)
	..q:RightFlag'="N"
	..s PRTAmount=$p(DHCINVPRTInfo,"^",1)
	..s PAPMIDr=$p(DHCINVPRTInfo,"^",15)
	..s PAPMINO=$p($g(^PAPER(PAPMIDr,"PAT",1)),"^",1)
	..s PAPMIName=$p($g(^PAPER(PAPMIDr,"ALL")),"^",1)   
	..s HISUser=$p(DHCINVPRTInfo,"^",21)
	..s HISUser=$p($g(^SSU("SSUSR",HISUser)),"^",2)
	..s DHCBCIDr=$o(^DHCBCI(0,"INV",DHCINVPRTDr,""),-1)
	..s tHospDr = ""
	..i DHCBCIDr'=""  d
	...s AdmDr=$p($g(^DHCBCI(DHCBCIDr)),"^",3)
	...s tHospDr = ##class(web.UDHCHospitalGroup).GetHospitalByAdm(AdmDr) //+ DingSH 20200612
	..q:tHospDr'=HospDr
	..s INPAYFlag=$p(INSUSplitStr,"^",1)
	..s:INPAYFlag="" INPAYFlag="无医保数据"
	..s INSUiDate=$p(INSUSplitStr,"^",2)
    ..s INSUUser=$p(INSUSplitStr,"^",3)
	..s INSUAdmType=$p(INSUSplitStr,"^",4)
	..s:PRTFlag="N" PRTFlag="正常结算"
	..s:PRTFlag="B" PRTFlag="被作废"
	..s:PRTFlag="S" PRTFlag="作废"
	..s Str=PAPMINO_"^"_PAPMIName_"^"_AdmDr_"^"_$zd(iDate,3)_"^"_PRTFlag
	..s Str=Str_"^"_DHCINVPRTDr_"^"_PRTInsDivDR_"^"_HISUser_"^"_DHCINVPRTDr_"^"_INPAYFlag
	..s Str=Str_"^"_INSUiDate_"^"_INSUUser_"^"_INSUAdmType_"^"_PRTAmount
	..s ErrorCount=ErrorCount+1
	..s ^CacheTemp("INSUBalance",PID,"OP","INVDiv","Error",ErrorCount)=Str
	
	q PID_"|"_ErrorCount_"|"_AllCount
}

/// Creator：   		zhangdongliang
/// CreatDate： 		2018-03-11
/// Description:： 		获取一段时间内，DHC_AccPayINV表 收费业务 的异常医保结算数据
/// 					^CacheTemp("INSUBalance",$j,"AccPay","Error")存异常数据
/// Table： 			DHC_AccPayINV
/// Input： 			STDate 开始日期, EndDate 结束日期, PID 节点增量值
/// Output： 		
/// Return： 			PID_"|"_ErrorCount_"|"_AllCount
/// 					AllCount 	所有数据的数量
/// 					ErrorCount	错误数据的数量
/// Others： 		
/// w ##class(web.DHCINSUBalance).GetBalanceINVACCPByDate("2016-4-27","2016-4-27","1")
/// 分产品线写函数， 注意封装 
ClassMethod GetBalanceINVACCPByDate(STDate, EndDate, PID, HospDr = "") As %String
{
	k ^CacheTemp("INSUBalance",PID,"OP","AccPay")
	
	s:STDate["-" STDate=$zdh(STDate,3)
	s:EndDate["-" EndDate=$zdh(EndDate,3)
	s:STDate["/" STDate=$zdh(STDate,4)
	s:EndDate["/" EndDate=$zdh(EndDate,4)
	
	s iDate=""
	s (PAPMINO,PAPMIName,AdmDr,APIFlag,DHCINVPRTDr,APIInsDivDR,HISUser)=""
	
	s ErrorCount=0,AllCount=0
	f iDate=STDate:1:EndDate d
	.s DHCAccPayINVDr=""
	.f  s DHCAccPayINVDr=$o(^DHCINVPRTAPi("0","Date",iDate,DHCAccPayINVDr))  q:DHCAccPayINVDr=""  d
	..s (PAPMINO,PAPMIName,AdmDr,APIFlag,DHCINVPRTDr,APIInsDivDR,HISUser)=""
	..s Flag=..CheckAccPayINVOfINSU(DHCAccPayINVDr)
	..q:Flag="N"		;非医保数据退出	
	..s APIInfo=$g(^DHCINVPRTAP(DHCAccPayINVDr))
	..s APIPayINVDR=$p(APIInfo,"^",10)
	..s APIInsDivDR=$p(APIInfo,"^",19)	
	..s APIFlag=..ChangeAccPayINVFlag(DHCAccPayINVDr)				;N：正常结算数据;B: N被作废之后变为B（被作废数据）;S: 指向B的记录（作废数据）
	..i (APIFlag="S") d
	...s APIInsDivDR=$p($g(^DHCINVPRTAP(APIPayINVDR)),"^",19)		;作废数据 取 被作废数据的 PRTInsDivDR 字段。
	..s AllCount=AllCount+1
	..;s ^CacheTemp("INSUBalance",PID,"OP","AccPay","ALL",AllCount)=DHCAccPayINVDr
	
	..s RightFlagInfo=..CheckINSUDivRightByINDivDrFlag(APIInsDivDR, APIFlag)
	..s RightFlag=$p(RightFlagInfo,"|",1)
	..s INSUSplitStr=$p(RightFlagInfo,"|",2)
	..q:RightFlag'="N"
	..s HISUser=$p(APIInfo,"^",5)
	..s HISUser=$p($g(^SSU("SSUSR",HISUser)),"^",2)
	..s PAPMIDr=$p(APIInfo,"^",11)
	..s PAPMINO=$p($g(^PAPER(PAPMIDr,"PAT",1)),"^",1)
	..s PAPMIName=$p($g(^PAPER(PAPMIDr,"ALL")),"^",1)   
	..s ACPDr=$o(^DHCINVPRTCAPi(0,"APINVDR",DHCAccPayINVDr,""))		
	..i ACPDr'="" d
	...s ACPInfo=$g(^DHCINVPRTCAP(ACPDr))
	...s DHCINVPRTDr=$p(ACPInfo,"^",1)
	...s DHCBCIDr=$o(^DHCBCI(0,"INV",DHCINVPRTDr,""),-1)
	..s tHospDr = ""
	...i DHCBCIDr'=""  d
	....s AdmDr=$p($g(^DHCBCI(DHCBCIDr)),"^",3)
	...s tHospDr = ##class(web.UDHCHospitalGroup).GetHospitalByAdm(AdmDr) //+ DingSH 20200612
	..q:tHospDr'=HospDr
	..s INPAYFlag=$p(INSUSplitStr,"^",1)
	..s:INPAYFlag="" INPAYFlag="无医保数据"
	..s INSUiDate=$p(INSUSplitStr,"^",2)
	..s INSUUser=$p(INSUSplitStr,"^",3)
	..s INSUAdmType=$p(INSUSplitStr,"^",4)
	..s:APIFlag="N" APIFlag="正常结算"
	..s:APIFlag="B" APIFlag="被作废"
	..s:APIFlag="S" APIFlag="作废"
	..s Str=PAPMINO_"^"_PAPMIName_"^"_AdmDr_"^"_$zd(iDate,3)_"^"_APIFlag
	..s Str=Str_"^"_DHCINVPRTDr_"^"_APIInsDivDR_"^"_HISUser_"^"_DHCAccPayINVDr_"^"_INPAYFlag
	..s Str=Str_"^"_INSUiDate_"^"_INSUUser_"^"_INSUAdmType
	..s ErrorCount=ErrorCount+1
	..s ^CacheTemp("INSUBalance",PID,"OP","AccPay","Error",ErrorCount)=Str
	
	;登记号	姓名	就诊表Dr	HIS业务日期	HIS结算状态	INVPRTDr	医保结算表Dr	HIS操作员	数据来源表Dr	医保结算状态	医保业务日期	医保操作员	医疗类别
	
	q PID_"|"_ErrorCount_"|"_AllCount
}

/// Creator：   		zhangdongliang
/// CreatDate： 		2018-03-11
/// Description:： 		获取一段时间内，DHC_INVPRTInsu表 移动支付方式（微信、支付宝）异常医保结算数据(先支付，窗口医保分解后，返还医保报销费用)
/// 					^CacheTemp("INSUBalance",PID,"OP","Mobile","Error",ErrorCount)存异常数据
/// Table： 			
/// Input： 			STDate 开始日期, EndDate 结束日期, PID 节点增量值
/// Output： 		
/// Return： 			PID_"|"_ErrorCount_"|"_AllCount
/// 					AllCount 	所有数据的数量
/// 					ErrorCount	错误数据的数量
/// Others： 		
/// w ##class(web.DHCINSUBalance).GetBalanceMobileByDate("2018-03-01","2018-03-01",1)
/// 分产品线写函数， 注意封装 
ClassMethod GetBalanceMobileByDate(STDate, EndDate, PID, HospDr = "") As %String
{
	
	k ^CacheTemp("INSUBalance",PID,"OP","Mobile")
	
	s:STDate["-" STDate=$zdh(STDate,3)
	s:EndDate["-" EndDate=$zdh(EndDate,3)
	s:STDate["/" STDate=$zdh(STDate,4)
	s:EndDate["/" EndDate=$zdh(EndDate,4)
	
	s iDate=""
	;INVDr INVFlag iDate 登记号 姓名 HIS收费操作员 医保Dr 医保Flag 医保iDate 医保操作员 医疗类别
	s (PAPMINO,PAPMIName,AdmDr,APIFlag,DHCINVPRTDr,APIInsDivDR,HISUser)=""
	
	s ErrorCount=0,AllCount=0
	f iDate=STDate:1:EndDate d
	.s PrtInsuRowid=""
	.f  s PrtInsuRowid=$o(^DHCINVPRTInsu("0","Date",iDate,PrtInsuRowid))  q:PrtInsuRowid=""  d
	..s (PAPMINO,PAPMIName,AdmDr,APIFlag,DHCINVPRTDr,APIInsDivDR,HISUser)=""
	..s Flag=..CheckMobileINVOfINSU(PrtInsuRowid)
	..q:Flag="N"		;非医保数据退出	
	..s PrtInsuInfo=$g(^DHCINVPRTInsu(PrtInsuRowid))
	..s PrtInsuinitinvDr=$p(PrtInsuInfo,"^",14)
	..s PrtInsuInsDivDR=$p(PrtInsuInfo,"^",17)
	..s PrtInsuFlag=..ChangeMobileFlag(PrtInsuRowid)				;N：正常结算数据;B: N被作废之后变为B（被作废数据）;S: 指向B的记录（作废数据）
	..i (PrtInsuFlag="S") d
	...s PrtInsuInsDivDR=$p($g(^DHCINVPRTAP(PrtInsuinitinvDr)),"^",17)		;作废数据 取 被作废数据的 PRTInsDivDR 字段。
	..s AllCount=AllCount+1
	..;s ^CacheTemp("INSUBalance",PID,"OP","AccPay","ALL",AllCount)=DHCAccPayINVDr
	
	..s RightFlagInfo=..CheckINSUDivRightByINDivDrFlag(PrtInsuInsDivDR, PrtInsuFlag)
	..s RightFlag=$p(RightFlagInfo,"|",1)
	..s INSUSplitStr=$p(RightFlagInfo,"|",2)
	..q:RightFlag'="N"
	..s DHCINVPRTDr=$p(PrtInsuInfo,"^",1)
	..s HISUser=$p(PrtInsuInfo,"^",7)
	..s HISUser=$p($g(^SSU("SSUSR",HISUser)),"^",2)
	..s DHCINVPRTInfo=$g(^DHCINVPRT(DHCINVPRTDr))
	..s PAPMIDr=$p(DHCINVPRTInfo,"^",15)
	..s PAPMINO=$p($g(^PAPER(PAPMIDr,"PAT",1)),"^",1)
	..s PAPMIName=$p($g(^PAPER(PAPMIDr,"ALL")),"^",1)   
	..s DHCBCIDr=$o(^DHCBCI(0,"INV",DHCINVPRTDr,""),-1)
	..s tHospDr =""
	..i DHCBCIDr'=""  d
	...s AdmDr=$p($g(^DHCBCI(DHCBCIDr)),"^",3)
	...s tHospDr = ##class(web.UDHCHospitalGroup).GetHospitalByAdm(AdmDr) //+ DingSH 20200612
	..q:tHospDr'=HospDr
	..s INPAYFlag=$p(INSUSplitStr,"^",1)
	..s:INPAYFlag="" INPAYFlag="无医保数据"
	..s INSUiDate=$p(INSUSplitStr,"^",2)
	..s INSUUser=$p(INSUSplitStr,"^",3)
	..s INSUAdmType=$p(INSUSplitStr,"^",4)
	..s:PrtInsuFlag="N" PrtInsuFlag="正常结算"
	..s:PrtInsuFlag="B" PrtInsuFlag="被作废"
	..s:PrtInsuFlag="S" PrtInsuFlag="作废"
	..s Str=PAPMINO_"^"_PAPMIName_"^"_AdmDr_"^"_$zd(iDate,3)_"^"_PrtInsuFlag
	..s Str=Str_"^"_DHCINVPRTDr_"^"_PrtInsuInsDivDR_"^"_HISUser_"^"_PrtInsuRowid_"^"_INPAYFlag
	..s Str=Str_"^"_INSUiDate_"^"_INSUUser_"^"_INSUAdmType
	..s ErrorCount=ErrorCount+1
	..s ^CacheTemp("INSUBalance",PID,"OP","Mobile","Error",ErrorCount)=Str
	
	;登记号	姓名	就诊表Dr	HIS业务日期	HIS结算状态	INVPRTDr	医保结算表Dr	HIS操作员	数据来源表Dr	医保结算状态	医保业务日期	医保操作员	医疗类别
	
	q PID_"|"_ErrorCount_"|"_AllCount
}

/// Creator：   		zhangdongliang
/// CreatDate： 		2018-03-11
/// Description:： 		获取一段时间内，HIS所有对账错误数据
/// 					^CacheTemp("INSUBalance",PID,"OP","INVReg","Error")
/// 						^CacheTemp("INSUBalance",PID,"OP","INVDiv","Error")
/// 						^CacheTemp("INSUBalance",PID,"OP","INVACCP","Error")
/// 						^CacheTemp("INSUBalance",PID,"OP","Mobile","Error")
/// Table： 			
/// Input： 			STDate 开始日期, EndDate 结束日期
/// Output： 		
/// Return： 			PID
/// Others： 		
/// w ##class(web.DHCINSUBalance).GetBalanceALLHISOPErrorByDate("2016-01-01","2016-03-31")
/// 分产品线写函数， 注意封装 
ClassMethod GetBalanceALLHISOPErrorByDate(STDate, EndDate, HospDr = "") As %String
{
	s PID=$I(^CacheTemp("INSUBalance"))
	k ^CacheTemp("INSUBalance",PID,"OP")
	
	;w "开始",!
	;w $zt($p($h,",",2)),!
	;w "GetBalanceRegByDate",!
	s TempStr=..GetBalanceRegByDate(STDate, EndDate,PID,HospDr)
	;w $zt($p($h,",",2)),!
	;w "GetBalanceINVByDate",!
	s TempStr=..GetBalanceINVByDate(STDate, EndDate,PID,HospDr)
	;w $zt($p($h,",",2)),!
	;w "GetBalanceINVACCPByDate",!
	s TempStr=..GetBalanceINVACCPByDate(STDate, EndDate,PID,HospDr)
	;w $zt($p($h,",",2)),!
	;w "GetBalanceMobileByDate",!
	s TempStr=..GetBalanceMobileByDate(STDate, EndDate,PID,HospDr)
	;w $zt($p($h,",",2)),!
	;w "完成",!
	s TempStr=..GetBalancePEINVByDate(STDate, EndDate,PID,HospDr)	;Zhan 20191227增加体检数据的检查
	
	q PID
}

/// Creator：   		zhangdongliang
/// CreatDate： 		2018-03-11
/// Description:： 		获取^CacheTemp("INSUBalance",PID,"OP")节点下 节点分类信息
/// Table： 			
/// Input： 			PID 节点值
/// Output： 		
/// Return： 			INVReg|INVDiv|...   节点值的拼串
/// Others： 		
/// w ##class(web.DHCINSUBalance).GetBalanceALLHISOPErrorTab("1")
ClassMethod GetBalanceALLHISOPErrorTab(PID As %String) As %String
{
	n (PID)
	s (INVReg,INVDiv,AccPay,Mobile,INVPEDiv)=""
	i $d(^CacheTemp("INSUBalance",PID,"OP","INVReg")) d
	.s INVReg="INVReg"
	i $d(^CacheTemp("INSUBalance",PID,"OP","INVDiv")) d
	.s INVDiv="INVDiv"
	i $d(^CacheTemp("INSUBalance",PID,"OP","AccPay")) d
	.s AccPay="AccPay"
	i $d(^CacheTemp("INSUBalance",PID,"OP","Mobile")) d
	.s Mobile="Mobile"
	i $d(^CacheTemp("INSUBalance",PID,"OP","INVPEDiv")) d
	.s INVPEDiv="INVPEDiv"
	s OutStr="{""INVReg"":"""_INVReg_""""_","_"""INVDiv"":"""_INVDiv_","_"""INVPEDiv"":"""_INVPEDiv_""""_","_"""AccPay"":"""_AccPay_""""_","_"""Mobile"":"""_Mobile_"""}"
	q OutStr
}

/// Creator：   		zhangdongliang
/// CreatDate： 		2018-03-11
/// Description:： 		获取^CacheTemp("INSUBalance",PID,"OP")节点下 节点分类信息
/// Table： 			
/// Input： 			PID 节点值
/// Output： 		
/// Return： 			INVReg|INVDiv|...   节点值的拼串
/// Others： 		
/// w ##class(web.DHCINSUBalance).GetBalanceALLHISOPErrorTab("1")
ClassMethod GetBalanceALLHISOPErrorTabStr(PID As %String) As %String
{
	n (PID)
	s Type=""
	s OutStr=""
	f  s Type=$o(^CacheTemp("INSUBalance",PID,"OP",Type))  q:Type=""  d
	.i OutStr=""  d
	..s OutStr=Type
	.e  d
	..s OutStr=OutStr_"|"_Type
	q OutStr
}

/// Creator：   		zhangdongliang
/// CreatDate： 		2018-03-11
/// Description:： 		获取一段时间内，INSU_Divide表 的 所有对账错误数据
/// 					^CacheTemp("INSUBalance",$j,"OP","INSU","ALL")存所有数据
/// 					^CacheTemp("INSUBalance",$j,"OP","INSU","Error")存异常数据
/// Table： 			
/// Input： 			STDate 开始日期, EndDate 结束日期
/// Output： 		
/// Return： 			PID_"|"_AllCount_"|"_ErrorCount
/// 					AllCount 	所有数据的数量
/// 					ErrorCount	错误数据的数量
/// 					PID			节点增量值
/// Others： 		
/// w ##class(web.DHCINSUBalance).GetBalanceALLINSUOPErrorByDate("2020-08-31","2020-08-31",2)
/// 分产品线写函数， 注意封装 
ClassMethod GetBalanceALLINSUOPErrorByDate(STDate, EndDate, HospDr = "") As %String
{
	
	s PID=$I(^CacheTemp("INSUBalance"))
	k ^CacheTemp("INSUBalance",PID,"OP","INSU")

	s ErrorCount=0,AllCount=0
	s INSUDivDr=""
	
	s:STDate["-" STDate=$zdh(STDate,3)
	s:EndDate["-" EndDate=$zdh(EndDate,3)
	s:STDate["/" STDate=$zdh(STDate,1)
	s:EndDate["/" EndDate=$zdh(EndDate,1)
	
	s DicDatainfo=##class(web.INSUDicDataCom).QueryByCode("SYS","Hospital",HospDr)
	s Hospital=$p(DicDatainfo,"^",4)
	
	s iDate=""
	s (PAPMINO,PAPMIName,AdmDr,INPAYFlag,DHCINVPRTDr,INSUDivDr,INSUUser,INSUAdmType,InsuId,INPAYbcbxf0,PRTFlag)=""
	s ErrorCount=0,AllCount=0,Flag=""
	f iDate=STDate:1:EndDate d
	.s INSUDivDr=""
	.f  s INSUDivDr=$o(^DHCINDIV("0","IDate",iDate,INSUDivDr)) q:INSUDivDr=""  d
	..s (PAPMINO,PAPMIName,AdmDr,INPAYFlag,DHCINVPRTDr,INSUUser,INSUAdmType,InsuId,INPAYbcbxf0,PRTFlag)=""
	..s (AdmDr,AdmType)=""
	..s INSUDivInfo=$g(^DHCINDIV(INSUDivDr)) 
	..s AdmDr=$p(INSUDivInfo,"^",1) 	;AdmDr 可能为空，医生站未更新 divide表的 AdmDr/INPAY_DhcInvPrtDr
	..s tHospDr = ""
	..s INSUAdmInfoDr=$p(INSUDivInfo,"^",2)
	..i INSUAdmInfoDr'=""  d					
	...s INSUAdmInfo=$g(^DHCINADM(INSUAdmInfoDr))
	...s AdmDr=$p(INSUAdmInfo,"^",1)
	...s InsuId=$p(INSUAdmInfo,"^",2)
	...s INSUAdmType=$p(INSUAdmInfo,"^",14)
	...s INSUInsuType=$p(INSUAdmInfo,"^",18)
	...s tHospDr = ##class(web.UDHCHospitalGroup).GetHospitalByAdm(AdmDr) //+ DingSH 20200612
	...s INSUAdmType=##class(web.DHCINSUPort).GetDicByCodeAndInd("AKA130"_INSUInsuType,INSUAdmType,4,tHospDr)
	..i AdmDr'="" d
	...s PAPMIDr=$p(^PAADM(AdmDr),"^",1)
	...s PAPMINO=$p($g(^PAPER(PAPMIDr,"PAT",1)),"^",1)
	...s PAPMIName=$p($g(^PAPER(PAPMIDr,"ALL")),"^",1) 
	...s AdmType=$p(^PAADM(AdmDr),"^",2) 
	..q:tHospDr'=HospDr
	..q:(AdmType'="")&&(AdmType="I")				;非门急诊数据退出，如果有特殊业务无法用此字段判断，改用其他字段。
	..s Zstr01=$p(INSUDivInfo,"^",36)				;收费类别
	..q:Zstr01="W"									;外院报销不参与对账
	..s INPAYbqbm00=$p(INSUDivInfo,"^",10)
	..q:(Hospital="LZDXDYYY")&&(INPAYbqbm00'="")	;特殊判断：兰大一院本地算法，多张发票对应一个医保结算。bqbm00'=""代表本地算法。本地算法
	..s INPAYZstr01=$p(INSUDivInfo,"^",36)
	..s INPAYFlag=..ChangeINSUFlag(INSUDivDr)
	..q:INPAYFlag="D"								;预分解数据
	..s CheckINSUDivDr=INSUDivDr
	..i INPAYFlag="S" d
	...s CheckINSUDivDr=$p(INSUDivInfo,"^",6)		;B数据的INSUDivDr
	..s DHCINVPRTDr=$p($g(^DHCINDIV(CheckINSUDivDr)),"^",4)  ;B数据的INVPRTDr
	..s AllCount=AllCount+1
	..;s ^CacheTemp("INSUBalance",$j,"OP","INSU","ALL",AllCount)=INSUDivDr
	
	..;判断INSUDivDr 是挂号？收费？
	..;挂号 数据 ：INSUAdmInfoDr在医生站Regi挂号表存在，并且INSUDivDr为同INSUAdmInfoDr下第一条数据 
	..s RegFlag="N"
	..;s RegFlag=..CheckINSUDivOfReg(INSUDivDr,AdmDr)	;无报销挂号费的项目，可以注释此段代码，提高效率。RegFlag=Y:	挂号费用数据  
	..i RegFlag="Y" d
	...;s Flag=..CheckINVRegRightByINADMDrFlag(INSUAdmInfoDr,INPAYFlag)	;在DHC_INVPRT 表 “是否有、并且结算状态正确” 的  挂号 数据
	...s Flag=..CheckINVDivRightByINDIVDrFlag(CheckINSUDivDr,INPAYFlag) ;在DHC_INVPRT 表 “是否有、并且结算状态正确” 的  收费 数据
	...q:Flag="Y"	;及时退出
	..e  d
	...s Flag=..CheckINVDivRightByINDIVDrFlag(CheckINSUDivDr,INPAYFlag) ;在DHC_INVPRT 表 “是否有、并且结算状态正确” 的  收费 数据
	...q:Flag="Y"	;及时退出
	...s Flag=..CheckAccRightByINDIVDrFlag(CheckINSUDivDr,INPAYFlag)	;在DHC_AccPayINV表 “是否有、并且结算状态正确” 的  收费 数据
	...q:Flag="Y"      													
	...s Flag=..CheckMobileRightByINDIVDrFlag(CheckINSUDivDr,INPAYFlag)	;未测试   ;在DHC_INVPRTInsu表 “是否有、并且结算状态正确” 的  收费 数据
	...q:Flag="Y" 
	...s tmpCheckFlag=""
	...s:((INPAYZstr01="P")||(AdmType="H")) tmpCheckFlag=$p(##class(web.DHCPE.CashierEx).GetCheckData($p(INSUDivInfo,"^",4)),"^",2)	;Zhan 20191227增加体检数据的检查
	...s:(tmpCheckFlag=INPAYFlag) Flag="Y" 
	..q:Flag="Y"   		;正确数据退出
	..i AdmDr'="" d
	...s PAPMIDr=$p(^PAADM(AdmDr),"^",1)
	...s PAPMINO=$p($g(^PAPER(PAPMIDr,"PAT",1)),"^",1)
	...s PAPMIName=$p($g(^PAPER(PAPMIDr,"ALL")),"^",1) 
	
	..s INPAYbcbxf0=+$p(INSUDivInfo,"^",7)
	..s INSUiDate=$p(INSUDivInfo,"^",16)
	..q:INPAYbcbxf0=+$p(INSUDivInfo,"^",15)
	..s:INSUiDate'="" INSUiDate=$zd(INSUiDate,3)	;医保结算日期
	..s INSUUser=$p(INSUDivInfo,"^",21)
	..s:INSUUser'="" INSUUser=$p($g(^SSU("SSUSR",INSUUser)),"^",2)
	..s INPAYZstr01=$p(INSUDivInfo,"^",36)
	..s:INPAYZstr01="R" INPAYZstr01="挂号"
	..s:INPAYZstr01="F" INPAYZstr01="收费"
	..s:((INPAYZstr01="P")||(AdmType="H")) INPAYZstr01="体检"
	..s:INPAYFlag="N" INPAYFlag="正常结算"
	..s:INPAYFlag="B" INPAYFlag="被作废"
	..s:INPAYFlag="S" INPAYFlag="作废"
	..s:INPAYFlag="D" INPAYFlag="预分解"
	..s PRTFlag="无计费数据"
	..i DHCINVPRTDr'="" d
	...s PRTFlag=..ChangeINVPRTFlag(DHCINVPRTDr)
	...s:PRTFlag="N" PRTFlag="正常结算"
	...s:PRTFlag="B" PRTFlag="被作废"
	...s:PRTFlag="S" PRTFlag="作废"
    ..s prtInsDivDr=..GetPrtInsDivDrByDivDr(INSUDivDr)
	..s Str=PAPMINO_"^"_PAPMIName_"^"_AdmDr_"^"_$zd(iDate,3)_"^"_INPAYFlag
	..s Str=Str_"^"_DHCINVPRTDr_"^"_INSUDivDr_"^"_INSUUser_"^"_INSUAdmType_"^"_InsuId
	..s Str=Str_"^"_INPAYZstr01_"^"_INPAYbcbxf0_"^"_PRTFlag_"^"_prtInsDivDr
	..s ErrorCount=ErrorCount+1
	..s ^CacheTemp("INSUBalance",PID,"OP","INSU","Error",ErrorCount)=Str

	;登记号	姓名	就诊表Dr	医保业务日期	医保结算状态	INVPRTDr	医保结算表Dr	医保操作员	医疗类别	医保号  挂号/收费 医保总金额 HIS结算状态 

	
	q PID_"|"_ErrorCount_"|"_AllCount
}

/// Creator：   		zhangdongliang
/// CreatDate： 		2018-03-17
/// Description:： 		判断INSUDivDr 是否为挂号费用数据
/// Table： 			
/// Input： 			INSUDivDr   INSU_divide表 rowid
/// 						AdmDr		INSUDivDr对应的 pa_adm rowid					 
/// Output： 				
/// Return： 			Y:	挂号费用数据
/// 					N: 	非挂号费用数据
/// Others： 		
/// w ##class(web.DHCINSUBalance).CheckINSUDivOfReg(2731,18)
ClassMethod CheckINSUDivOfReg(INSUDivDr, AdmDr) As %String
{
	n (INSUDivDr,AdmDr)
	s OutStr="N"

	s INSUAdmInfoDr=..GetINSUADMDrByAdmDr(AdmDr)	;需医生站提供函数替换医保组自己写的程序
	q:INSUAdmInfoDr="" OutStr

	s TempINSUDivDr="",FirstINSUDivDr=""
	f  s TempINSUDivDr=$o(^DHCINDIV(0,"ADMINFO",INSUAdmInfoDr,TempINSUDivDr))  q:TempINSUDivDr=""  d
	.s:FirstINSUDivDr="" FirstINSUDivDr=TempINSUDivDr
	i INSUDivDr=FirstINSUDivDr d
	.s OutStr="Y"
	
	q OutStr
}

/// Creator：   		ZhanMingchao
/// CreatDate： 		2019-12-27
/// Description:： 		获取一段时间内，体检发票表的异常医保结算数据
/// 					^CacheTemp("INSUBalance",PID,"OP","INVPE","Error",ErrorCount)存异常数据
/// Input： 			STDate 开始日期, EndDate 结束日期, PID 节点增量值
/// Output： 		
/// Return： 			PID_"|"_ErrorCount_"|"_AllCount
/// 					AllCount 	所有数据的数量
/// 					ErrorCount	错误数据的数量
/// Others： 		
/// w ##class(web.DHCINSUBalance).GetBalancePEINVByDate("2019-03-01","2019-06-01","1")
ClassMethod GetBalancePEINVByDate(STDate, EndDate, PID, HospDr = "") As %String
{
	k ^CacheTemp("INSUBalance",PID,"OP","INVPE")
	;s ^CacheTemp("INSUBalance",PID,"OP","INVPE","Error",ErrSort)=ErrInfo
	s:STDate["-" STDate=$zdh(STDate,3)
	s:EndDate["-" EndDate=$zdh(EndDate,3)
	s:STDate["/" STDate=$zdh(STDate,4)
	s:EndDate["/" EndDate=$zdh(EndDate,4)
	s eCnt=##class(web.DHCPE.CashierEx).GetBalanceINVByDate($zd(STDate,3),$zd(EndDate,3),PID)

	q PID_"|"_eCnt_"|"_eCnt
}

/// Creator：   		DingSH
/// CreatDate： 		2020-09-09
/// Description:： 		根据INSUDivDr 获取发票表，集中发票表，体检发票表字段存医保结算表指针
/// Table： 			
/// Input： 			INSUDivDr   INSU_divide表 rowid
/// 						AdmDr		INSUDivDr对应的 pa_adm rowid					 
/// Output： 				
/// Return： 			发票表存的医保结算表指针
/// 					N: 	非挂号费用数据
/// Others： 		
/// w ##class(web.DHCINSUBalance).GetPrtInsDivDrByDivDr(277)
ClassMethod GetPrtInsDivDrByDivDr(INSUDivDr) As %String
{
	n (INSUDivDr)
	q:INSUDivDr="" ""
	
	q:$d(^DHCINDIV(INSUDivDr))=0 ""
	s prtStr=$P($G(^DHCINDIV(INSUDivDr)),"^",4) 
	s DivType=$P($G(^DHCINDIV(INSUDivDr)),"^",37) ;R:挂号 F:收费;P(H):体检
    s DivMod=$P($G(^DHCINDIV(INSUDivDr)),"^",38)  ;01现金结算模式 ,02集中打印模式,03体检,10本地算法,20自助机
    s InsDivDr=""
    i +DivMod=2 d      //集中打印
    .s prtDr=$P(prtStr,"!",1)
    .s accInvPrt=$p($g(^DHCINVPRT(prtDr)),"^",4)
    .s InsDivDr=$P(^DHCINVPRTAP(accInvPrt),"^",19)
    e  i (DivType="P")||(DivType="H")|| (+DivMod=3) d //体检
    .s InsDivDr=$P(^DHCPEOEITEM(+prtStr),"^",4)
    e  d
    .s InsDivDr=$P(^DHCINVPRT(+prtStr),"^",30)
    
	q InsDivDr
}

}
