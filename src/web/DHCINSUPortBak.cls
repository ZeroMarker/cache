Import SQLUser

Class web.DHCINSUPortBak Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 30;

/*判断特病诊断是否可以开
//入参：AdmID   Paadm   的Rowid
//      AdmReasonID   Pac_Admreason 的RowID
//      DiagnosID     mrc_icddx     的RowID
//出参：0     可以录此诊断
//      -2   没有办医保特病号
//      -1    不能录此诊断  */
/// 名称:提供给其他产品组提供的各种接口
/// 描述: 
/// 编写者：刘书凤
/// 编写日期:2008 05 10 ->作废20200514
ClassMethod CheckDiagnos(AdmID, AdmReasonID, DiagnosID) As %String
{
 ;s AdmID=683,AdmReasonID=9,DiagnosID=11013
 s CheckDiagnos=-1,CheckTBFlag=-1,AdmInfoFlag=-1
 s AdmReasonDesc=$p(^PAC("ADMREA",AdmReasonID),"^",2)
 q:AdmReasonDesc'["特病" 0
 s AdmInfo=##class(web.DHCINSUAdmInfoCtl).GetInfoByAdm(AdmID)
 i $p(AdmInfo,"!",1)="1" d
 .s TBCode=$p($p(AdmInfo,"!",2),"^",27)
 e  d
 .s TBCode=""
 q:TBCode="" -2    ;没有医保挂号
 s DCRowid=""
 f  s DCRowid=$o(^DHCDiagnosCatI("0","Diagose",DiagnosID,DCRowid)) q:DCRowid=""  d
 .s DCCode=$p(^DHCDiagnosCat(DCRowid),"^",6)
 .s DCBillTypeDR=$p(^DHCDiagnosCat(DCRowid),"^",3)
 .i (AdmReasonID=DCBillTypeDR)&($ZCONVERT(DCCode,"U")=$ZCONVERT(TBCode,"U")) d
 ..s CheckDiagnos=0    ;可以录医嘱
 ;.i (AdmReasonID=DCBillTypeDR) d
 ;..s CheckTBFlag=0   ;是特病
 q CheckDiagnos
}

/// 医嘱项关联医保收费项信息
/// ArcimRowid：医嘱项的rowid; AdmReasonDr：病人就诊费别(paadm_admreason)
/// 返回医保项的信息:
/// 		项目等级/结算属类(甲乙类等)^支付比例^备注^适用险种^重症^门诊^重症说明^基准价格^医保类型(省医保市医保等)
/// w ##class(web.DHCINSUPort).ArcimLinkInsu("6783||1", 12)
/// 是否增加院区入参20200514，传实际院区，不要传分组的院区,AdmReasonDrToDLLType 应该是 AdmReasonDrToTariType
ClassMethod ArcimLinkInsu(ArcimRowid, AdmReasonDr)
{
	n (ArcimRowid, AdmReasonDr)
	q:$g(ArcimRowid)="" "-1^医嘱项Dr不能为空"
	q:$g(AdmReasonDr)="" "-1^AdmReasonDr不能为空"
	q:$d(^PAC("ADMREA",AdmReasonDr))=0 "-1"
	
	s REANationalCode="",InsuType="",InsuTypeDesc=""
 	s REANationalCode=$p(^PAC("ADMREA",AdmReasonDr),"^",5)
 	s REAAdmSource=$p(^PAC("ADMREA",AdmReasonDr),"^",9)
	s tmpdicinfo=##class(web.INSUDicDataCom).QueryByCode("AdmReasonDrToDLLType",AdmReasonDr)
	s InsuType=$p(tmpdicinfo,"^",6)  ;通过AdmReasonDr判断目录类别
	q:InsuType="" ""
	s InsuTypeDesc=$p(tmpdicinfo,"^",7)
	s TariDr=""
	;----------Zhan 20181114--------->
	;q:$d(^DHCOLT(0,"ARTTA",ArcimRowid))=0 "-2^医嘱项没有对应的收费项"	
	;s TariDr=$o(^DHCOLT(0,"ARTTA",ArcimRowid,TariDr))
	;q:$o(^DHCOLT(0,"ARTTA",ArcimRowid,TariDr))'="" "-3^医嘱项对应了多个收费项"
	s DrugFlag=$$GetDrugFlagBy^DHCINSUFacade(ArcimRowid)
	if (DrugFlag="1"){
	    s TariDr=##class(web.DHCINSUPortUse).GetTariDrByArcimRowid(ArcimRowid,"")
	    q:$l(TariDr,"^")>1 "-3^医嘱项对应了多个收费项" 
	}else{
		s TariDr=""
	    q:$d(^DHCOLT(0,"ARTTA",ArcimRowid))=0 "-2^医嘱项没有对应的收费项"	
	    s TariDr=$o(^DHCOLT(0,"ARTTA",ArcimRowid,TariDr))
	    q:$o(^DHCOLT(0,"ARTTA",ArcimRowid,TariDr))'="" "-3^医嘱项对应了多个收费项"
	}

	;//--------------------------------
	q:TariDr="" "-2^没有查到对应的收费项"
	s TariInsuFlag=$p($$QueryByCode^DHCINSUDicData("TariInsuFlag",InsuType),"^",6)   //取收费项是否与其他收费项关联的标志  add by lilizhi 2013-03-05
	s TarItemInsuInfo=$$GetConInfo^DHCINSUTarContrast(TariDr,InsuType,$zd(+$h,3),TariInsuFlag)
	q:TarItemInsuInfo="" ""
	s INTIMbzjg=$p(TarItemInsuInfo,"^",15)				//基准价格
	s zfbl=$p(TarItemInsuInfo,"^",18)					
	s:zfbl'="" zfbl=+(zfbl*100)_"%"  					//自负比例
	s Demo=$p(TarItemInsuInfo,"^",22)
	s lb=$p(TarItemInsuInfo,"^",23)						//甲,乙,非医保									
	s xmlb=..RtnDicDescByDicCode(("AKA065"_InsuType),lb)				//结算属类
	;s INTIMflzb1=$p(TarItemInsuInfo,"^",24)				//适用险种
	s INTIMtxbz=$p(TarItemInsuInfo,"^",6)				//特殊项标志（限制用药标志） Zhan 20170406
	s INTIMflzb2=$p(TarItemInsuInfo,"^",25)				//重症
	s INTIMflzb3=$p(TarItemInsuInfo,"^",26)				//门诊
	s INTIMflzb4=$p(TarItemInsuInfo,"^",27)				//重症说明

	;s txbz=$p(TarItemInsuInfo,"^",6)
    ;s:lb="1" xmlb="甲类"
    ;s:lb="2" xmlb="乙类"
    ;s:lb="3" xmlb="丙类"
    ;s:((lb'="1")&(lb'="2")&(lb'="3")) xmlb="丙类"
    ;s BillSubDr=$p(^ARCIM($p(Arcimrowid,"||",1),$p(Arcimrowid,"||",2),1),"^",9)
    ;s BillSubDesc=$p(^ARCBG($p(BillSubDr,"||",1),"SG",$p(BillSubDr,"||",2)),"^",2)
    ;s:((lb'="1")&(lb'="2")&(lb'="3")&(BillSubDesc'["药费")) xmlb="甲类"
    ;s:xmlb="丙类" zfbl="100%"
    ;项目等级/结算属类^支付比例^备注^适用险种  ^   重症      ^   门诊        ^    重症说明  ^  基准价格
    
    ;q xmlb_"^"_zfbl_"^"_Demo_"^"_INTIMflzb1_"^"_INTIMflzb2_"^"_INTIMflzb3_"^"_INTIMflzb4_"^"_INTIMbzjg
    ;项目等级/结算属类^支付比例^备注^特殊项标志^   重症      ^   门诊        ^    重症说明  ^  基准价格
    ;Zhan 20170406 医生站只用到了第4个
    q xmlb_"^"_zfbl_"^"_Demo_"^"_INTIMtxbz_"^"_""_"^"_""_"^"_""_"^"_INTIMbzjg_"^"_InsuTypeDesc
}

/// 收费相关联医保收费项信息
/// TarItmId 收费的rowid; AdmReasonDr 病人就诊费别(paadm_admreason)  OEORIDR 医嘱ID   AdmRowid:登记表rowid   UnitPrice:单价
/// 返回医保相关信息
/// w ##class(web.DHCINSUPort).TarItmLinkInsu("5864","19","","","0")
/// w ##class(web.DHCINSUPort).TarItmLinkInsu("5401","19","","","0")
/// 甲类^0^^^1^^^0
/// 尼莫地平片(尼莫同)[30mg x20片/盒]
/// outStr=乙类^.1^^^3,4,6,7,10^^补血^0
/// 有问题 DingSH  AdmReasonDrToDLLType 应该是 AdmReasonDrToTariType
ClassMethod TarItmLinkInsu(TarItmRowid, AdmReasonDr, OEORIDR, AdmRowid, UnitPrice)
{
 	n (TarItmRowid, AdmReasonDr, OEORIDR, AdmRowid, UnitPrice)
 	s SpecType="Y"
 	s OutStr=""
 	s:OEORIDR="" SpecType="N"   ;是否需要取特殊项目对照的关系
 	q:$g(TarItmRowid)="" "-1^收费Dr不能为空"
 	q:$g(AdmReasonDr)="" "-1^AdmReasonDr不能为空"
 	q:$d(^DHCTARI(TarItmRowid))=0 "-1^收费表没有对应的数据"
 	q:$d(^PAC("ADMREA",AdmReasonDr))=0 ""
 	
  	//s REANationalCode="",InsuType=""
 	//s REANationalCode=$p(^PAC("ADMREA",AdmReasonDr),"^",5)
 	//s REAAdmSource=$p(^PAC("ADMREA",AdmReasonDr),"^",9)
 	s InsuTypeDesc=""
	s tmpdicinfo=##class(web.INSUDicDataCom).QueryByCode("AdmReasonDrToDLLType",AdmReasonDr)
	s InsuType=$p(tmpdicinfo,"^",6)  ;通过AdmReasonDr判断目录类别
	q:InsuType="" ""
	s InsuTypeDesc=$p(tmpdicinfo,"^",7)
 	;***************************
 	;add liusf 2008 10 18 特殊收费项目转换
 	i SpecType="Y"  d
 	.s ARCIMType=$p($g(^OEORD(+PBOOEORIDR,"I",$p(OEORIDR,"||",2),"DHC")),"^",2)
 	.s TarItmRowid=##class(web.DHCINSUTarConTar).QueryTarConId(TarItmRowid,ARCIMType)
 	q:TarItmRowid="" ""
 	;***************************
 	s TariInsuFlag=$p($$QueryByCode^DHCINSUDicData("TariInsuFlag",InsuType),"^",6)   //取收费项是否与其他收费项关联的标志  add by lilizhi 2013-03-05
 	s TarItemInsuInfo=$$GetConInfo^DHCINSUTarContrast(TarItmRowid,InsuType,$zd(+$h,3),TariInsuFlag)
 	q:TarItemInsuInfo="" ""

 	
 	s INTIMbzjg=$p(TarItemInsuInfo,"^",15)				//基准价格
	s zfbl=$p(TarItemInsuInfo,"^",18)					
	;s:zfbl'="" zfbl=+(zfbl*100)_"%"  					//自负比例
	s Demo=$p(TarItemInsuInfo,"^",22)
	s lb=$p(TarItemInsuInfo,"^",23)						//甲,乙,非医保									
	;s xmlb=..RtnDicDescByDicCode("AKA065WHA",lb)				//结算属类
	s xmlb=..RtnDicDescByDicCode(("AKA065"_InsuType),lb)
	//s INTIMflzb1=$p(TarItemInsuInfo,"^",24)				//适用险种
	//s INTIMflzb2=$p(TarItemInsuInfo,"^",25)				//重症 1~10		a代表所有
	;s INTIMflzb2=..RtnDicCodeStrByDicBill1("Skc516WHA",INTIMflzb2)		//参照重慢病不限制收费项		
	//s INTIMflzb3=$p(TarItemInsuInfo,"^",26)				//门诊
	//s INTIMflzb4=$p(TarItemInsuInfo,"^",27)				//重症说明


 	;s OutpatCate=$p($g(^DHCTARI(TarItmRowid)),"^",14)
 	;s OutpatCateDesc=$P($g(^DHCTarC("IC",OutpatCate)),"^",2)
 	;s InsuCode=$p(TarItemInsuInfo,"^",4)
 	;s DrugSingle=$p(TarItemInsuInfo,"^",27)  //+liusf 2009 03 20  单味药标志
 	;s lx="",zfje=""
 	;s OutStr=lb_"^"_zfbl_"^"_Demo_"^"_lx_"^"_zfje_"^"_DrugSingle
 	;    项目等级   自付比例  备注     类型   自负金额     单味药标志
 	;项目等级/结算属类^支付比例 ^ 备注 ^    适用险种  ^   重症       ^   门诊       ^    重症说明  ^  基准价格
 	s OutStr=xmlb_"^"_zfbl_"^"_Demo_"^^^^^^"_InsuTypeDesc			//_"^"_INTIMflzb1_"^"_INTIMflzb2_"^"_INTIMflzb3_"^"_INTIMflzb4_"^"_INTIMbzjg
	q OutStr
}

/// Creator：      刘书凤
/// CreatDate：    2009 06 30
/// Description:   医嘱项关联医保收费项信息（用的特殊项目对照的时候）
/// Table：        
/// Input：        ArcimRowid：医嘱项的rowid; AdmReasonDr：病人就诊费别(paadm_admreason)
/// Output：       
/// Return：       成功返回 0
/// Others：
/// 
/// w ##class(web.INSUTarContrastCom).ArcimLinkTarStr("9309||1", 3)
/// w ##class(web.DHCINSUPort).ArcimLinkTarStr("9309||1", 3)
/// 有问题 DingSH  有写死的地方
ClassMethod ArcimLinkTarStr(ArcimRowid, AdmReasonDr)
{
	n (ArcimRowid, AdmReasonDr)
	q:$g(ArcimRowid)="" "-1"
	q:$g(AdmReasonDr)="" "-1"
	q:$d(^PAC("ADMREA",AdmReasonDr))=0 "-1"
	
	;取REA_AdmSource 医保患者值为"1"
	s InsuType=$p(^PAC("ADMREA",AdmReasonDr),"^",9)      
	;i InsuType="1"  d
	.;s InsuType="SZ" ;如果不传费别，或自费病人取医保信息时，默认一个医保类型，改为配置 20200514
	
	s TariDr="",limitFlag=""  //yjy 2008.5.21
	;----------Zhan 20181114--------->
	s DrugFlag=$$GetDrugFlagBy^DHCINSUFacade(ArcimRowid)
	if (DrugFlag="1"){
	    s TariDr=##class(web.DHCINSUPortUse).GetTariDrByArcimRowid(ArcimRowid,"")
	    q:$l(TariDr,"^")>1 "-3^医嘱项对应了多个收费项" 
	}else{
		s TariDr=""
		q:$d(^DHCOLT(0,"ARTTA",Arcimrowid))=0 "-2"	
		s TariDr=$o(^DHCOLT(0,"ARTTA",Arcimrowid,TariDr))
		q:$o(^DHCOLT(0,"ARTTA",Arcimrowid,TariDr))'="" "-3"
	}
	;q:$d(^DHCOLT(0,"ARTTA",Arcimrowid))=0 "-2"	
	;s TariDr=$o(^DHCOLT(0,"ARTTA",Arcimrowid,TariDr))
	;q:$o(^DHCOLT(0,"ARTTA",Arcimrowid,TariDr))'="" "-3"
	;--------------------------------
	s OutStr=$$GetTarConTarInfo^DHCINSUTarItems(TariDr)
	q OutStr
}

/// Creator：      刘书凤
/// CreatDate：    2009 06 30
/// Description:   医保项维护和目录自动对照接口(珠海)
/// Table：        
/// Input：        InString：医保类别^项目编码^项目名称^项目拼音码^项目类别^统计类项目(自费、控制)^DHC_TarItem.Rowid
/// 医保类别珠海可以不传，项目编码^项目名称^项目拼音码 这个分别收费项目编码、名称、别名  项目类别 药品为“0”  其他为“1”
/// 统计类项目(自费、控制)为：基本、控制、自费三选一  DHC_TarItem.Rowid：如果是更新以前项目的信息这个必须为非空
/// Output：       
/// Return：       成功返回 0
/// Others：
/// w ##class(web.DHCINSUPort).AddINSUInfo("")    
/// 有问题 DingSH  有些死的地方,作废20200514
ClassMethod AddINSUInfo(InString As %String) As %String
{
	n (InString)
	;s InString="ZH^X210316005^贝复舒凝胶(5g:21000iu)^cs^0^基本^8790"
	s TemInStr="^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
 	//s InsuType="ZH"	//传进来 20200514
 	s Code=$p(InString,"^",2)
	s Desc=$p(InString,"^",3)
 	s xmrj=$p(InString,"^",4)
 	s xmlb=$p(InString,"^",5)
 	s ybdj=$p(InString,"^",6)
 	q:(ybdj'="基本")&(ybdj'="控制")&(ybdj'="自费") -1     ;2009 07 05
 	s TarItemDr=$p(InString,"^",7)
 	s $p(TemInStr,"^",3)=InsuType
 	s $p(TemInStr,"^",4)=Code
 	s $p(TemInStr,"^",5)=Desc
 	s $p(TemInStr,"^",6)=xmrj
 	s $p(TemInStr,"^",8)=xmlb
 	s $p(TemInStr,"^",24)=ybdj
 	s INTCTRowid=""
 	i TarItemDr'="" d
 	.i $d(^DHCINTCT("0","DHCTID",TarItemDr)) d
 	..s INTCTRowid=$o(^DHCINTCT("0","DHCTID",TarItemDr,INTCTRowid),-1)
 	..s InsuDr=$p($g(^DHCINTCT(INTCTRowid)),"^",4)
 	..i $d(^DHCINTIM(InsuDr)) d
 	...s $p(TemInStr,"^",1)=InsuDr
	s ItemFlag=##class(web.INSUTarItemsCom).Update("","",TemInStr)
	q:ItemFlag'=0 "ItemFlag="_ItemFlag
	s ConStr=""_"^"_Code_"^"_Desc_"^"_Code_"^"_Desc_"^"_InsuType_"^"_"1"_"^"_$zd(+$h,3)
	s ConFlag=##class(web.INSUTarContrastCom).CheckInCont(ConStr)
	q:ConFlag'=0 "ConFlag="_ConFlag
	q ConFlag
}

/// Creator:ZhanMingChao 
/// modify by yangjianzhang 
/// Description:通过insuadminfo表Rowid就诊号更新insuadminfo 
/// Input：PAADM:就诊号;INADMRowid:insuadminfo表Rowid 
/// Output: 失败:-1 成功:0 
/// CreatDate:2009-07-10 Others:门诊挂号医生站调用 
/// Modify DingSH 20180914
/// Others: w ##class(web.DHCINSUPort).UpdateInsuAdm("81^82","15","119")
ClassMethod UpdateInsuAdm(INADMRowidList As %String, PAADM As %String, InvPrtDr As %String, INDivDr As %String = "") As %String
{
	s RtnCode=-1  
	q:$g(INADMRowidList)=""||$g(PAADM)="" RtnCode
	s i=$l(INADMRowidList,"^")
	f k=1:1:i   d
	.s INADMRowid=$p(INADMRowidList,"^",k)
	.&SQL(UPDATE INSU_AdmInfo SET INADM_AdmDr=:PAADM WHERE INADM_Rowid=:INADMRowid)
	.q:(SQLCODE'=0)
	.;s INDivDr=+$p($g(^DHCINADM(INADMRowid)),"^",46)
	.&SQL(UPDATE INSU_Divide SET INPay_AdmDr=:PAADM,INPAY_DhcInvPrtDr=:InvPrtDr WHERE INPay_Rowid=:INDivDr)
	.s:(SQLCODE'=0) RtnCode=-2
	.q:(SQLCODE'=0)
	.s rtn=##class(web.DHCINSUDivideSubCtl).UpdateDivSubInvprtDrByDivDr(INDivDr,InvPrtDr,"")
	.s RtnCode=0
	q RtnCode
}

/// GetDivideByInvPrtDr
/// Creator: 张东亮
/// Description:返回门诊打印所需元素
/// Input：InvPrtDr：DHC_INVPRT表Rowid，
/// CreatDate:2011-09-14
/// Others: w ##class(web.DHCINSUPort).GetDivideByInvPrtDr("1677","")
/// Output:Insu_AdmInfo表 49个字段_"!^"_Insu_divide表70个字段
/// 			字段详情请参考表结构文档
/// 备注：门诊传InvPrtDr
ClassMethod GetDivideByInvPrtDr(InvPrtDr As %String, PBDr As %String) As %String
{
	n (InvPrtDr,PBDr)
	s OutStr=""
	q:(+InvPrtDr=0) OutStr
	q:('$d(^DHCINDIV("0","DHCInvPrt",InvPrtDr))) OutStr
	s DivDr=""
	s DivDr=$o(^DHCINDIV("0","DHCInvPrt",InvPrtDr,DivDr),-1)
	q:(DivDr="") OutStr
	s DivInfo=$g(^DHCINDIV(DivDr))
	s AdmInfoDr=$p(DivInfo,"^",2)			;50个字段
	s Flag=$p(DivInfo,"^",5)
	q:((Flag'="I")&&(Flag'="B")) OutStr 
	s AdmInfo=$g(^DHCINADM(AdmInfoDr))		;70个字段
	s InsuAdmCenter=$p(AdmInfo,"^",8)
	s InsuAdmInsuType=$p(AdmInfo,"^",18)
	s INPAYbcbxf0=$p(DivInfo,"^",7)			;医保总费用
	s INPAYgrzfe0=$p(DivInfo,"^",15)		;医保现金
	s INPAYInsuPay10=$p(DivInfo,"^",50)		;医保误差值

	s $p(DivInfo,"^",7)=INPAYbcbxf0+INPAYInsuPay10	;总金额考虑医保误差值
	s $p(DivInfo,"^",15)=INPAYgrzfe0+INPAYInsuPay10	;现金考虑医保误差值
	
	
	;字段详情请参考表结构文档
	s OutStr=AdmInfo_"!^"_DivInfo
	q OutStr
}

/// GetDivideByPBDr
/// Creator: 杨建章 modefy by zhangdongliang 2010-11-16
/// Description:返回住院打印所需元素
/// Input：PBDr：DHC_PatientBill表Rowid，
/// Others: w ##class(web.DHCINSUPort).GetDivideByPBDr("","199258")
/// Output: Insu_AdmInfo表 49个字段_"!^"_Insu_divide表70个字段
/// 备注：住院传PBDr
ClassMethod GetDivideByPBDr(InvPrtDr As %String, PBDr As %String) As %String
{
	n (InvPrtDr,PBDr)
	s OutStr=""
	q:(+PBDr=0) OutStr
	q:('$d(^DHCINDIV("0","DHCPB",PBDr))) OutStr
	s DivDr=""
	s DivDr=$o(^DHCINDIV("0","DHCPB",PBDr,DivDr),-1)
	q:(DivDr="") OutStr
	s DivInfo=$g(^DHCINDIV(DivDr))
	s AdmInfoDr=$p(DivInfo,"^",2)			;49个字段
	s Flag=$p(DivInfo,"^",5)
	q:((Flag'="I")&&(Flag'="B")) OutStr 
	s AdmInfo=$g(^DHCINADM(AdmInfoDr))		;70个字段
	s InsuAdmCenter=$p(AdmInfo,"^",8)
	s InsuAdmInsuType=$p(AdmInfo,"^",18)
	s INPAYbcbxf0=$p(DivInfo,"^",7)			;医保总费用
	s INPAYgrzfe0=$p(DivInfo,"^",15)		;医保现金
	s INPAYInsuPay10=$p(DivInfo,"^",50)		;医保误差值

	s $p(DivInfo,"^",7)=$fn(INPAYbcbxf0+INPAYInsuPay10,"",2)	;总金额考虑医保误差值
	s $p(DivInfo,"^",15)=$fn(INPAYgrzfe0+INPAYInsuPay10,"",2)	;现金考虑医保误差值
	
	;字段详情请参考表结构文档
	s OutStr=AdmInfo_"!^"_DivInfo
	q OutStr
}

/// Description:根据就诊号返回住院打印所需元素
/// Input：PAADM:pa_adm表的rowid
/// Others: w ##class(web.DHCINSUPort).GetDivideByADM("123","")
/// Output: Insu_divide表70个字段_"!"_Insu_divide表70个字段
ClassMethod GetDivideByADM(PAADM As %String, ExpStr As %String) As %String
{
	n (ExpStr,PAADM)
	s OutStr="-1"
	s DivStr=""
	q:PAADM="" OutStr
	q:$d(^DHCPB(0,"ADM",PAADM))=0 OutStr
	s billid=""
	f  s billid=$o(^DHCPB(0,"ADM",PAADM,billid))	q:billid=""  d
	.s Payedflag=$p(^DHCPB(billid),"^",16)
	.s Refundflag=$p(^DHCPB(billid),"^",17)
	.;q:(Payedflag'="B")&(Payedflag'="P")
	.;q:(Payedflag="P")&((Refundflag="B")||(Refundflag="P"))
	.s DivDr=$o(^DHCINDIV("0","DHCPB",billid,""),-1)
	.q:(DivDr="")
	.s DivInfo=$g(^DHCINDIV(DivDr))
	.s:DivStr'="" DivStr=DivStr_"!"_DivInfo
	.s:DivStr="" DivStr=DivInfo
	s:DivStr'="" OutStr=DivStr
	q OutStr
}

/// Description:根据发票获取改张发票的医保结算id以及费别
/// Input：PAADM:pa_adm表的rowid
/// Others: w ##class(web.DHCINSUPort).GetDivDrAndAdmReaByInvPrt("218056")
/// Output: Insu_divide表ID_"!"_费别ID
ClassMethod GetDivDrAndAdmReaByInvPrt(PrtRowid As %String) As %String
{
	n (PrtRowid)
	s OutStr="N"
	s InsuDivDr=$p($G(^DHCINVPRT(PrtRowid)),"^",30) 
	s InsType=$p($G(^DHCINVPRT(PrtRowid)),"^",9) 
	s admsource=""
	s:InsType'="" admsource=$p(^PAC("ADMREA",InsType),"^",9)
	s:InsuDivDr'="" OutStr=InsuDivDr_"!"_InsType_"!"_admsource
	q OutStr
}

/// GetDividePreByPBDr
/// Creator:  zhangdongliang 2010-11-15
/// Description:返回医保预结算医保支付金额
/// Input：PBDr：DHC_PatientBill表Rowid，insu_dividepre
/// CreatDate:1010-07-07
/// Others: w ##class(web.DHCINSUPort).GetDividePreByPBDr("204197")
/// Output: 医保支付
ClassMethod GetDividePreByPBDr(PBDr As %String) As %String
{
	n (PBDr)
	q:$d(^DHCINDIVPre("0","DHCPB",PBDr))=0 "0.00"
	s Id=$O(^DHCINDIVPre("0","DHCPB",PBDr,""),-1)
	q:+Id=0 "0.00"
	s AdmDr=$p(^DHCINDIVPre(Id),"^",1)
	s JJZF=##class(web.DHCINSUPort).GetDividePreByAdmDr(AdmDr)
	q JJZF
}

/// RtnDicCodeStrByDicBill1
/// Creator: 张东亮
/// Description:根据DicBill1Str，返回DicCode组串
/// Input：	DicType：insu_dicdata表indid_DicType字段
/// 		DicBill1Str：insu_dicdata表indid_DicBill1字段组串，
/// CreatDate:2011-09-20
/// Others: 
/// Output: insu_dicdata表indid_DicCode 字段组串
/// 备注：
/// w ##class(web.DHCINSUPort).RtnDicCodeStrByDicBill1("Skc516WHA","1, 2, 3 ,4,5,6,7,8,9,10,a")
ClassMethod RtnDicCodeStrByDicBill1(DicType As %String, DicBill1Str As %String) As %String
{
	n (DicType,DicBill1Str)
	s OutStr=""
	s DicCode=""
	q:DicBill1Str="" OutStr
	s DicStr=$$Query^DHCINSUDicData(DicType,DicCode)
	q:DicStr=0 OutStr
	q:DicStr="" OutStr
	;DicStr=i_"^"_$j
	

	s INSUDicId=""
	s DataString=""
	f  s INSUDicId=$o(^CacheTemp("INSUDic",$p(DicStr,"^",2),INSUDicId))  q:INSUDicId=""  d
	.s DataString=$g(^CacheTemp("INSUDic",$p(DicStr,"^",2),INSUDicId))
	.s id=$p(DataString,"^",1)
	.s cType=$p(DataString,"^",2)
    .s cCode=$p(DataString,"^",3)
    .s cDesc=$p(DataString,"^",4)
    .s cDemo=$p(DataString,"^",5)
    .s cBill1=$p(DataString,"^",6)
    .s cBill2=$p(DataString,"^",7)


    .s Num=$l(DicBill1Str,",")
    .f i=1:1:Num  d
    ..s Flag="N"
    ..s tmpcBill1=$tr($p(DicBill1Str,",",i)," ")
    ..s:cBill1=tmpcBill1 Flag="Y"
    ..q:Flag'="Y"
    ..i OutStr=""  d
    ...s OutStr=cCode
	..e  d
	...s OutStr=OutStr_","_cCode
	q OutStr
}

/// DicDataDesc
/// Creator: 张东亮
/// Description:返回insu_dicdata中Desc，显示中文描述
/// Input：DicType：insu_dicdata表indid_DicType字段
/// 			DicCode：insu_dicdata表indid_DicCode字段，
/// CreatDate:2011-09-14
/// Others: w ##class(web.DHCINSUPort).GetDivideByInvPrtDr("253","")
/// Output: insu_dicdata表indid_DicDesc字段，
/// 备注：内部调用，不对外公开
/// w ##class(web.DHCINSUPort).RtnDicDescByDicCode("Skc516WHA","")
ClassMethod RtnDicDescByDicCode(DicType As %String, DicCode As %String) As %String
{
	n (DicType,DicCode)
	s OutStr=""
	q:DicCode="" OutStr
	s DicStr=$$Query^DHCINSUDicData(DicType,DicCode)
	q:DicStr=0 OutStr
	q:DicStr="" OutStr
	s DicStr=^CacheTemp("INSUDic",$p(DicStr,"^",2),$p(DicStr,"^",1))
	s OutStr=$p(DicStr,"^",4)					;描述
	q OutStr
}

/// w ##class(web.DHCINSUPort).GetLocInfoByYLZ("111000")
/// 通过医疗证号获取名单库信息(供建卡使用)
/// Rowid^^医疗证号^^^^身份证号^姓名^性别^^区别^类别^^^^^单位代码^0^单位名称^^^单位邮编^^^^2011-09-20^11:29:39^62351^0^^0^^AdmReasonDR^0^0^0^0^0^0^0^^^^^^^^^
ClassMethod GetLocInfoByYLZ(YLZ As %String) As %String
{
	n (YLZ)
	s OutStr="-1"
	q:(YLZ="") OutStr
	s PatInsuCard=$o(^PAPERi("PAPER_PatName",YLZ,""))
	q:(PatInsuCard'="") "1"
	s LocInfoDr=""
	s tmpID=""
	f  s LocInfoDr=$o(^DHCINLOC("0","YLZBH",YLZ,LocInfoDr)) q:LocInfoDr=""   d
	.s XXLX=$p($g(^DHCINLOC(LocInfoDr)),"^",1)
	.q:(XXLX=4)	//??20200514
	.;s TmpAdmReason=$p($g(^DHCINLOC(LocInfoDr)),"^",32)
	.;q:((AdmReason'="")&&(TmpAdmReason'=AdmReason))
	.s tmpID=LocInfoDr
	q:(+tmpID=0) OutStr
	s OutStr=$$GetInfoById^DHCINSULOCInfo(tmpID)
	q OutStr
}

/// w ##class(web.DHCINSUPort).GetInsuMZLSH()
/// 深圳：返回医保挂号的流水号
ClassMethod GetInsuMZLSH()
{
	s Rnd=$Random(100)
	s DateStr=$Zd(+$h,8)
	s TimeStr=$Zt($P($h,",",2),1)
	s TimeStr=$p(TimeStr,":",1)_""_$p(TimeStr,":",2)_""_$p(TimeStr,":",3)
	s MZLSH="H"_""_DateStr_""_TimeStr_""_Rnd
	q MZLSH
}

/*
	            objToStr = Rowid & "^" & AdmDr & "^" & InsuId & "^" & CardNo & "^" & PatType & "^" & _
                       CardStatus & "^" & Company & "^" & States & "^" & Center & "^" & Account & "^" & AdmSeriNo & "^" & _ ;11
                       ActiveFlag & "^" & AdmDate & "^" & AdmTime & "^" & AdmType & "^" & DeptDesc & "^" & InsuUser & "^" & _
                       IpTimes & "^" & InsuType & "^" & AdmCancelNo & "^" & OutDate & "^" & OutTime & "^" & OutUser & "^" & _
                       UserDr & "^" & FunDate & "^" & FunTime & "^" & _
                       XString1 & "^" & XString2 & "^" & XString3 & "^" & XString4 & "^" & _
                       XFloat1 & "^" & XFloat2 & "^" & XFloat3 & "^" & XFloat4 & "^" & _
                       XString5 & "^" & XString6 & "^" & XString7 & "^" & XString8 & "^" & _
                       XString9 & "^" & XString10 & "^" & XString11 & "^" & XString12 & "^" & _
                       UserName
                       
                       
                       
  DivObjToStr = Rowid & "^" & AdmDr & "^" & AdmInfoDr & "^" & DHCpblDr & "^" & DhcInvPrtDr 
               & "^" & Flag & "^" & INSUDivideDr & "^" & bcbxf0 & "^" & djlsh0 & "^" & bckbcs 
               & "^" & bqbm00 & "^" & brnl00 & "^" & cardno & "^" & cfxms0 & "^" & crbcts 
               & "^" & grzfe0 & "^" & iDate & "^" & iTime & "^" & id0000 & "^" & jjzfe0 
               & "^" & ptbcts & "^" & sUserDr & "^" & sfrq00 & "^" & sfrxm0 & "^" & sfsj00
                & "^" & sftsbz & "^" & xbie00 & "^" & xming0 & "^" & zhzfe0 & "^" & zyksmc 
                & "^" & zylsh0 & "^" & InsuPay1 & "^" & InsuPay2 & "^" & InsuPay3 & "^" & InsuPay4 
                & "^" & InsuPay5 & "^" & Zstr01 & "^" & Zstr02 & "^" & Zstr03 & "^" & Zstr04 
                & "^" & Zstr05 & "^" & Zstr06 & "^" & Zstr07 & "^" & Zstr08 & "^" & Zstr09 
                & "^" & Zstr10 & "^" & UserName
                       */
/// GetDivideInfoIPPreByDate
/// Creator: 刘书凤
/// Description:返回统计组报表所需数据
/// Input：SDate开始时间, EDate结束时间
/// CreatDate:2011 11 23
/// Others: w ##class(web.DHCINSUPort).GetDivideInfoIPPreByDate("62412","62412")
/// Output: 进程号。^TmpDHCINSUPre(SDate,EDate,$j)
ClassMethod GetDivideInfoIPPreByDate(SDate As %String, EDate As %String) As %String
{
	n (SDate,EDate)
	k ^TmpDHCINSUPre(SDate,EDate)
	F iDate=SDate:1:EDate D
	.s DivDr=""  f  s DivDr=$o(^DHCINDIVPre("0","IDate",iDate,DivDr)) q:DivDr=""  d
	..s DivStr=$g(^DHCINDIVPre(DivDr))
	..s PBDr=$p(DivStr,"^",3)
	..q:PBDr=""
	..s str=##class(web.DHCINSUPort).GetDivideInfoIPPre("",PBDr)
	..q:str="-1"
	..s ^TmpDHCINSUPre(SDate,EDate,PBDr,$j)=str
	q $j
}

/// GetDivideInfoIP
/// Creator: 刘书凤
/// Description:返回统计组报表所需数据
/// Input：PBDr：DHC_PatientBill表Rowid，
/// CreatDate:2011 11 23
/// Others: w ##class(web.DHCINSUPort).GetDivideInfoIPPre("","202486")
/// Output: 
/// 医保总费用       INPAY_bcbxf0
/// 自费费用         自费药品+自费项目
/// 起付线           INPAY_InsuPay8
/// 个人先付费用     乙类药品先付+特检疗先付
/// 按比例负担费用   统筹个人按比例支付+大病个人按比例支付   ？
/// 非上传费用       账单表总费用- INPAY_bcbxf0
/// 个人现金支付     INPAY_grzfe0
/// 个人账户支付     INPAY_zhzfe0
/// 自费药费         自费药品
/// 自费诊疗费用     自费项目
/// 自费药费报支 
/// 自费诊疗费用报支 
/// 人员类别         PatType   ("11-在职；12-在职二乙；21-退休；22-退休二乙；31-离休； 51  学生 ；71  学龄前儿童；72  成年居民；73  老年居民")
/// 医保类别         公务员  慢性病  普通医保   不用
/// 备注：住院传PBDr
ClassMethod GetDivideInfoIPPre(InvPrtDr As %String, PBDr As %String) As %String
{
	n (InvPrtDr,PBDr)
	q:(+PBDr=0) "-1"
	q:('$d(^DHCINDIVPre("0","DHCPB",PBDr))) "-1"
	s bcbxf0=0,SelfTotal=0,InsuPay8=0,SelfXF=0,BLDF=0,WSCFY=0,grzfe0=0,zhzfe=0,SelfYP=0,SelfXM=0,SelfYPBZ=0,SelfXMBZ=0,PatType="",InsuType=""
	s mCurrRowPatientBill=$g(^DHCPB(PBDr))
	s PBTotal=($p(mCurrRowPatientBill,"^",8))
	s DivDr=""
	s DivDr=$o(^DHCINDIVPre("0","DHCPB",PBDr,DivDr),-1)
	s DivStr=$g(^DHCINDIVPre(DivDr))
	s Flag=$p(DivStr,"^",5)
	q:((Flag'="I")&&(Flag'="B"))
	s bcbxf0=+$p(DivStr,"^",7)	
	s Zstr10=$p(DivStr,"^",45)	     ;自费药品|自费项目|超过大额峰顶线自费金额
    s SelfYP=$p(Zstr10,"|",1)
    s SelfXM=$p(Zstr10,"|",2)
    s SelfTotal=SelfYP+SelfXM              ;自费费用
    s InsuPay8=$p(DivStr,"^",48)           ;起付线
	s grzfe0=+$p(DivStr,"^",15)			;现金
	s zhzfe=+$p(DivStr,"^",28)				;账户支付
    s Zstr09=$p(DivStr,"^",44)
    s SelfXF=$p(Zstr09,"|",2)+$p(Zstr09,"|",3)   ;个人先付费用  
    s BLDF=$p(DivStr,"^",55)+$p(DivStr,"^",56)   ;按比例负担费用
    s WSCFY=PBTotal-bcbxf0                       ;非上传费用 
    s InfoId=$p(DivStr,"^",2)
	s AdmInfoStr=$$GetInfoById^DHCINSUAdmInfo(InfoId)
    s PatType =$p(AdmInfoStr,"^",5)
    s InsuType =""
	s OutStr=bcbxf0_"^"_SelfTotal_"^"_InsuPay8_"^"_SelfXF_"^"_BLDF_"^"_WSCFY_"^"_grzfe0_"^"_zhzfe_"^"_SelfYP_"^"_SelfXM_"^"_SelfYPBZ_"^"_SelfXMBZ_"^"_PatType_"^"_InsuType
	q OutStr
}

/// GetInsuCardByAdm
/// Creator: 詹明超
/// Description:通过就诊号取医保卡号
/// Input：PAADM：就诊号
/// CreatDate:2012-03-12
/// Others: w ##class(web.DHCINSUPort).GetInsuCardByAdm("202486")
/// Output: 医保卡号
ClassMethod GetInsuCardByAdm(PAADM As %String) As %String
{
	q:$g(PAADM)="" ""
	q:$d(^DHCINADM("0","ADM",PAADM))=0 ""
	s adminfoid="",InsuCard=""
	f  s adminfoid=$o(^DHCINADM("0","ADM",PAADM,adminfoid)) q:adminfoid=""  d
	.s ActiveFlag=$p(^DHCINADM(adminfoid),"^",11)
	.q:+ActiveFlag=3
	.s InsuCard=$p(^DHCINADM(adminfoid),"^",3)
	q InsuCard
}

/// 医嘱项关联医保收费项信息列表
/// ArcimRowid：医嘱项的rowid; AdmReasonDr：病人就诊费别(paadm_admreason)
/// 返回医保项的信息      特检  9028||1     限制性提示  "15199||1"
/// w ##class(web.DHCINSUPort).ArcimLinkInsuList("1||1", 3)
/// 有问题 DingSH  TariDrStr Undefined,
/// DSH重写20200514
ClassMethod ArcimLinkInsuList(ArcimRowid, AdmReasonDr)
{
	n (ArcimRowid, AdmReasonDr)
	s InsuType="",OutStr="",OutStr1=""
	q:$g(ArcimRowid)="" "-1^医嘱项Dr不能为空"
	q:$g(AdmReasonDr)="" "-1^AdmReasonDr不能为空"
	q:$d(^PAC("ADMREA",AdmReasonDr))=0 "-1"
	s AdmReasonCode=$p(^PAC("ADMREA",AdmReasonDr),"^",1)
	s TmpOut=$$QueryByCode^DHCINSUDicData("AdmReasonDrToTariType",AdmReasonDr)
	s InsuType=$p(TmpOut,"^",6)
	q:InsuType="" "-1^费别和医保目录没有对照"
	s TariDr=""
	;----------Zhan 20181114--------->
	;q:$d(^DHCOLT(0,"ARTTA",ArcimRowid))=0 "-2^医嘱项没有对应的收费项"	
	;s TariDr=$o(^DHCOLT(0,"ARTTA",ArcimRowid,TariDr))
	;q:$o(^DHCOLT(0,"ARTTA",ArcimRowid,TariDr))'="" "-3^医嘱项对应了多个收费项"
	s DrugFlag=$$GetDrugFlagBy^DHCINSUFacade(ArcimRowid)
	if (DrugFlag="1"){
	    s TariDr=##class(web.DHCINSUPortUse).GetTariDrByArcimRowid(ArcimRowid,"")
	    q:$l(TariDr,"^")>1 "-3^医嘱项对应了多个收费项" 
	}else{
		s TariDr=""
	    q:$d(^DHCOLT(0,"ARTTA",ArcimRowid))=0 "-2^医嘱项没有对应的收费项"	
	    s TariDr=$o(^DHCOLT(0,"ARTTA",ArcimRowid,TariDr))
	    q:$o(^DHCOLT(0,"ARTTA",ArcimRowid,TariDr))'="" "-3^医嘱项对应了多个收费项"
	}
	
	;//--------------------------------
	q:TariDr="" "-2^没有对应的收费项"
    f Num=1:1:$l(TariDrStr,"^")  d
    .s TariDr=$p(TariDrStr,"^",Num)
	.s TarString=$$GetTarDetail^DHCINSUTarContrast(TariDr)
	.s TariCode=$p(TarString,"^",2)
	.s TariDesc=$p(TarString,"^",3)
	.s Price=$fn($p(TarString,"^",7),"",4)
	.s TariInsuFlag=$p($$QueryByCode^DHCINSUDicData("TariInsuFlag",InsuType),"^",6)   //取收费项是否与其他收费项关联的标志  add by lilizhi 2013-03-05
	.s TarItemInsuInfo=$$GetConInfo^DHCINSUTarContrast(TariDr,InsuType,"",TariInsuFlag)
	.s ContrastFlag="Y"
	.s:TarItemInsuInfo="" ContrastFlag="N"
	.s txbz=""
	.s zfbl=$p(TarItemInsuInfo,"^",18)
	.s:zfbl'="" zfbl=+(zfbl*100)_"%"  			//自负比例
	.s Demo=$p(TarItemInsuInfo,"^",22)
	.s lb=$p(TarItemInsuInfo,"^",23)						//甲,乙,非医保	
	.S SysCode="AKA065"_InsuType								
	.s xmlb=..RtnDicDescByDicCode(SysCode,lb)				//结算属类
	.s flzb1=$p(TarItemInsuInfo,"^",25)         //特检特治标志
	.s:flzb1'="1" flzb1="0"
	.s InsuClass=$p(TarItemInsuInfo,"^",23)

    .s:((InsuClass'="甲类")&(InsuClass'="乙类")) InsuClass="自费"
    .s:InsuClass="自费" zfbl="100%"
    .;       收费项目代码 收费项目名称  项目等级   支付比例  备注 特殊标志  特检特治标志
    .i OutStr1="" d
    ..s OutStr1=TariDr_"^"_TariCode_"^"_TariDesc_"^"_Price_"^"_ContrastFlag_"^"_InsuClass_"^"_zfbl_"^"_Demo_"^"_txbz_"^"_flzb1
    .e       d
    ..s OutStr1=OutStr1_"!"_TariDr_"^"_TariCode_"^"_TariDesc_"^"_Price_"^"_ContrastFlag_"^"_InsuClass_"^"_zfbl_"^"_Demo_"^"_txbz_"^"_flzb1
    q OutStr1
}

/// Creator:ZhanMingChao
/// Description:返回汉字的编码信息
/// Input：	HANZI:汉字
/// 			FLAG:返回何种编码(1:ASC码,2:汉字,3:拼音,4:首拼,5:四角码6:五笔码7:区位码8:笔划数9:郑码)
/// 			SPLIT:分割符(可以为空)
/// Output：
/// 	非0:返回编码信息:ASC码^汉字^拼音^首拼^四角码^五笔码^区位码^笔划数^郑码
/// 	0：未找到编码信息
/// CreatDate:2011-06-08
/// w ##class(web.DHCINSUPort).GetCNCODE("东华",4,"^")
/// w ##class(web.DHCINSUPort).GetCNCODE("东华",4,"")
ClassMethod GetCNCODE(HANZIS As %String = "", FLAG As %String = "", SPLIT As %String = "") As %String
{
	s Rtnstr="0"
	q:$g(HANZIS)="" Rtnstr
	s Rtnstr=""
	f i=1:1:$l(HANZIS) d
	.s HANZI=$EXTRACT(HANZIS,i)
	.s ASCIICODE=$ASCII(HANZI)
	.i $D(^DHCCharacterEncoding("0","ASCII",ASCIICODE))'=0 d
	..s rowid=$o(^DHCCharacterEncoding("0","ASCII",ASCIICODE,""))
	..s tmpstr=""
	..s:FLAG="" tmpstr=$g(^DHCCharacterEncoding(rowid))
	..s:FLAG'="" tmpstr=$p(^DHCCharacterEncoding(rowid),"^",FLAG)
	..i Rtnstr=""  d
	...s Rtnstr=tmpstr
	..e  d
	...s Rtnstr=Rtnstr_SPLIT_tmpstr
	.e  d
	..s:Rtnstr="" Rtnstr="?"
	..s Rtnstr=Rtnstr_SPLIT_"?"
	q Rtnstr
}

/// 通过医嘱项到医保对照表中找到同一医保项对应的其他医嘱项
/// Lou 2011-08-02 提供给医生站控制超量使用
/// 多院区会有问题20200514
ClassMethod GetArcimStrByInsuCon(ArcimDr As %String) As %String
{
	n (ArcimDr)
	s ArcimStr=""
	q:ArcimDr="" ""
	s DrugFlag=$$GetDrugFlagBy^DHCINSUFacade(ArcimDr)
	q:DrugFlag'="1" ArcimDr //非药品不查

	s TariDr="" 
	q:$d(^DHCOLT(0,"ARTTA",ArcimDr))=0 ArcimDr
	s TariDr=$o(^DHCOLT(0,"ARTTA",ArcimDr,TariDr),-1) //只取最新的那条对应关系
	q:TariDr="" ArcimDr
	q:$o(^DHCOLT(0,"ARTTA",ArcimDr,TariDr))'="" ArcimDr //医嘱项对多条计费项

	s INCONRowId=""
	s INCONRowId=$o(^DHCINTCT("0","DHCTID",TariDr,INCONRowId)) //找出对照的医保代码
	q:INCONRowId="" ArcimDr
	s InsuDr=$p(^DHCINTCT(INCONRowId),"^",4)
	q:InsuDr="" ArcimDr
	s InsuCode=$p(^DHCINTIM(InsuDr),"^",3)
	q:InsuCode="" ArcimDr
	s InsuCode=$$ALPHAUP^SSUTIL4(InsuCode)
	s InsuRowid=""
	f  s InsuRowid=$o(^DHCINTIM("0","CODE",InsuCode,InsuRowid)) q:InsuRowid=""  d //循环相同医保代码
	.s InsuConRowid=""
	.f  s InsuConRowid=$o(^DHCINTCT("0","INSUTID",InsuRowid,InsuConRowid)) q:InsuConRowid=""  d //循环同一医保项的对照关系
	..s HisDr=$p(^DHCINTCT(InsuConRowid),"^",1)
	..s OLTARCIMDR="",tmpOLTARCIMDR="",QuitFlag="N"
	..s StartDate=""  f  s StartDate=$o(^DHCOLT(0,"TAR",HisDr,StartDate)) q:StartDate=""  d
	...q:StartDate>+$h
	...s OLTRowId=""  f  s OLTRowId=$o(^DHCOLT(0,"TAR",HisDr,StartDate,OLTRowId)) q:OLTRowId=""  d
	....s EndDate=$p(^DHCOLT(OLTRowId),"^",5)
	....q:(EndDate'="")&(EndDate<+$h)
	....s OLTARCIMDR=$p(^DHCOLT(OLTRowId),"^",1)
	....s:tmpOLTARCIMDR="" tmpOLTARCIMDR=OLTARCIMDR
	....i tmpOLTARCIMDR'=OLTARCIMDR s QuitFlag="Y" //如果能循环出多条医嘱项,表示非药品有问题
	..q:QuitFlag="Y"
	..q:OLTARCIMDR=""
	..i ArcimStr="" d
	...s ArcimStr=OLTARCIMDR
	..e   d
	...s ArcimStr=ArcimStr_"^"_OLTARCIMDR
	s:ArcimStr="" ArcimStr=ArcimDr
	q ArcimStr
}

/// Creator:ZhanMingChao
/// Description:自动转换全角半角
/// Input：	字符串
/// 			FLAG:0全角转为半角，1半角转为全角
/// Output：
/// 	非0:返回转换后的字符串
/// 	0：异常
/// CreatDate:2013-04-23
/// w ##class(web.DHCINSUPort).AutoSBDB("东华１２５９ｔｅｓｔ",0)
ClassMethod AutoSBDB(InArgs As %String = "", FLAG As %String = "") As %String
{
	s Rtnstr="0"
	q:$g(InArgs)="" Rtnstr
	s tmpstr=""
	i FLAG="1" d	;to SBC
	.f i=1:1:$l(InArgs) d
	..i $ASCII($EXTRACT(InArgs,i))=32 d
	...s tmpstr=tmpstr_$c(12288)
	..e  d
	...i $ASCII($EXTRACT(InArgs,i))<127 d
	....s tmpstr=tmpstr_$c($ASCII($EXTRACT(InArgs,i))+65248)
	...e  s tmpstr=tmpstr_$EXTRACT(InArgs,i)
	e  d
	.f i=1:1:$l(InArgs) d	;to DBC
	..i $ASCII($EXTRACT(InArgs,i))=12288 d
	...s tmpstr=tmpstr_$c(32)
	..e  d
	...i ($ASCII($EXTRACT(InArgs,i))<65375)&($ASCII($EXTRACT(InArgs,i))>65280) d
	....s tmpstr=tmpstr_$c($ASCII($EXTRACT(InArgs,i))-65248)
	...e  s tmpstr=tmpstr_$EXTRACT(InArgs,i)
	s:tmpstr'="" Rtnstr=tmpstr
	q Rtnstr
}

/// 根据就诊号取病人挂号或入院登记信息
/// 入参:
/// 		PAADMDr:就诊号
/// 返回:
/// 		就诊号^医疗保险号^医保卡号^人员类别(在职、退休、离休等代码)^IC卡状态^单位^地区^所属分中心^个人帐户余额^医保就诊流水号(10)^
/// 		有效标志(A:有效,B:被作废,S:作废,O:出院)^入院日期^入院时间^入院类别（医疗类别）^就诊科室名称^入院登记人Dr^住院次数^医保类别(省市医保比如：“AH”、“SYA“)^冲销流水号^出院日期(20)^
/// 		出院时间^出院操作员^操作员指针^操作日期^操作时间^预留串^预留串^预留串^预留串^预留串^
/// 		预留串^预留串^预留串^预留串^预留串^预留串^预留串^预留串^预留串^预留串^
/// 		预留串^预留串^预留串^预留串^预留串^预留串^预留串^预留串^预留串
/// 其它说明：
/// w ##class(web.DHCINSUPort).GetInsuAdmInfoByAdmDr(PAADMDr)
ClassMethod GetInsuAdmInfoByAdmDr(PAADMDr) As %String
{
	n (PAADMDr)
	q:$g(PAADMDr)="" ""
	q:$d(^DHCINADM("0","ADM",PAADMDr))=0 ""

	s AdmInfoDr="",InsuAdmCenter="",InsuAdmInsuType=""
	s AdmInfoDr=$o(^DHCINADM("0","ADM",PAADMDr,AdmInfoDr),-1)

	s AdmInfo=$g(^DHCINADM(AdmInfoDr))		
	s InsuAdmCenter=$p(AdmInfo,"^",8)
	s InsuAdmInsuType=$p(AdmInfo,"^",18)
	
	;以下字段如需转成汉字显示，请再调用..RtnDicDescByDicCode("OrganizationCodeCCA",$p(AdmInfo,"^",8))函数。
	s $p(AdmInfo,"^",8)=..RtnDicDescByDicCode("OrganizationCodeCCA",$p(AdmInfo,"^",8))			;统筹区
	s $p(AdmInfo,"^",4)=..RtnDicDescByDicCode("AKC021CCA",$p(AdmInfo,"^",4))		;参保人员类别
	;s $p(AdmInfo,"^",38)=..RtnDicDescByDicCode("GWYTypeCCA",$p(AdmInfo,"^",38))		;公务员标志
	;s $p(AdmInfo,"^",39)=..RtnDicDescByDicCode("BJDXTypeCCA",$p(AdmInfo,"^",39))	;保健对象标识
	;s $p(AdmInfo,"^",40)=..RtnDicDescByDicCode("TSRYTypeCCA",$p(AdmInfo,"^",40))	;特殊人员标志
	;字段详情请参考表结构文档
	s OutStr=AdmInfo
	
	q OutStr
}

/// GetDividePreByPBDr
/// Creator: zhangdongliang 
/// Description:返回医保费用上传后返回的自费和自付部分
/// Input：PBDr：DHC_PatBillDetails表Rowid
/// CreatDate:2013-08-08
/// Others: w ##class(web.DHCINSUPort).PBDLinkInsu("202834||1||3")
/// Output: 自付比例_"^"_自费金额_"^"_报销金额
ClassMethod PBDLinkInsu(PBDDr) As %String
{
	n (PBDDr)
	q:(PBDDr="") -1
	q:('$d(^DHCINDIS("0","PBDDr",PBDDr))) -1
	s DivSubId="", Qry=0, Amount=0, Scale=0, Fund=0, Self=0
	f  s DivSubId=$o(^DHCINDIS("0","PBDDr",PBDDr,DivSubId)) q:DivSubId=""  d
	.s DivSubInfo=$g(^DHCINDIS(DivSubId))
	.s Flag=$p(DivSubInfo,"^",18)
	.;q:(Flag="S")||(Flag="I")
	.q:Flag'="N"
	.s TarItemID=$p(DivSubInfo,"^",3)
	.s Qry=+$p(DivSubInfo,"^",11) //数量
	.s Pricce=+$p(DivSubInfo,"^",12) //价格
	.s Amount=+$p(DivSubInfo,"^",13) //金额
	.s Scale=+$p(DivSubInfo,"^",15) //自付比例
	.s Fund=+$p(DivSubInfo,"^",16) //统筹支付
	.s Self=+$p(DivSubInfo,"^",17) //个人自付部分
	s SelFee=Scale_"^"_Self_"^"_Fund
	q SelFee
}

/// add by zhangdongliang at 2014-09-02 for 门诊住院数据校验
/// 入参Desc:
/// InvPrtDr:		门诊传InvPrtDr，PBDr=""，不可同时传
/// 	PBDr:			住院传PBDr，不传InvPrtDr=""，不可同时传
/// 	JustThread；	卡支付集中打印发票 的进程号
/// 	CPPFlag:		为卡支付集中打印发票是否标志，是的情况：InvPrtDr=""、PBDr=""、CPPFlag="CPP"；非则CPPFlag=""
/// 	DivFlag:		校验结算业务数据传"N",校验退费业务数据传"S",默认""时校验正数据;集中打印发票无退费业务，退费时调用门诊退费。
/// 出参：
/// 			Y!BackString 	Y代表医保有此数据，校验无误 	BackString为对应业务成功后，医保函数返回串。  
/// 			或N				N代表校验无此数据，计费需回滚	
/// 备注		BackString对应含义：
/// 								校验门诊结算,BackString=医保门诊结算函数返回串
/// 								校验住院结算,BackString=医保住院结算函数返回串
/// 								校验"卡支付集中打印发票,BackString=""
/// w ##class(web.DHCINSUPort).CheckINSUDivFlag("24976","","","","N")
/// w ##class(web.DHCINSUPort).CheckINSUDivFlag("230999","","","","S")
/// w ##class(web.DHCINSUPort).CheckINSUDivFlag("","244585","","N","N")
/// w ##class(web.DHCINSUPort).CheckINSUDivFlag("","","123","CPP","N")
ClassMethod CheckINSUDivFlag(InvPrtDr As %String, PBDr As %String, JustThread As %String, CPPFlag As %String, DivFlag As %String) As %String
{
	
	n (InvPrtDr,PBDr,JustThread,CPPFlag,DivFlag)
	s OutStr="N"
	i (CPPFlag="CPP")  d
	.s OutStr=..CheckINSUOPDivFlagCPP(JustThread)
	e  i ((InvPrtDr'="")&&($d(^DHCINDIV("0","DHCInvPrt",InvPrtDr)))) d
	.s OutStr=..CheckINSUOPDivFlag(InvPrtDr,DivFlag)
	e  i ((PBDr'="")&&($d(^DHCINDIV("0","DHCPB",PBDr))))  d
	.s OutStr=..CheckINSUIPDivFlag(PBDr,DivFlag)
	q OutStr
}

/// 内部调用，不对外公布
/// 有问题 DingSH  应增加 [Abstract]--移走,dsh 20200514
ClassMethod CheckINSUOPDivGlobalCPP(JustThread As %String) As %String
{
	n (JustThread)
	s OutStr="N"
	q:(+JustThread=0) OutStr
	q:('$d(^DHCTMPACCColPRT("IP",JustThread))) OutStr
	s instype=""
	s instype=$o(^DHCTMPACCColPRT("IP",JustThread,instype))
	q:instype="" OutStr
	s InvprtIndex=""
	s InvprtIndex=$o(^DHCTMPACCColPRT("IP",JustThread,instype,InvprtIndex)) 
	q:InvprtIndex="" OutStr
	s InsuDivide=""
	s InsuDivide=$o(^DHCTMPACCColPRT("IP",JustThread,instype,InvprtIndex,"YBRowID",InsuDivide))
	q:InsuDivide="" OutStr
	;各地不同医院不同支付方式，请教研global节点与结算表各分解费用是否一致。
	;Todo: CheckPayMode
	s OutStr="Y"

	q OutStr
}

/// 内部调用，不对外公布
/// 有问题 DingSH  应增加 [Abstract]--移走,dsh 20200514
ClassMethod CheckINSUOPDivFlagCPP(JustThread As %String) As %String
{
	n (JustThread,InvPrtDr)
	s OutStr="N"
	s INSUOPDivGlobalFlag="",INSUOPDivFlag=""
	s INSUOPDivGlobalFlag=..CheckINSUOPDivGlobalCPP(JustThread)
	q:INSUOPDivGlobalFlag="Y" "Y"
	;INSUOPDivGlobalFlag="N"
	s INSUOPDivFlag=..UpdateINSUOPDivCPPGlobal(JustThread)
	i INSUOPDivFlag="0" d 
	.s OutStr="Y"
	e  d
	.s OutStr="N"
	q OutStr
}

// 

/// 内部调用，不对外公布
/// 有问题 DingSH  应增加 [Abstract]--移走,dsh 20200514
ClassMethod CheckINSUOPDivFlag(InvPrtDr As %String, DivFlag As %String) As %String
{
	n (InvPrtDr,DivFlag)
	s OutStr="N"
	s BackString=""
	q:(+InvPrtDr=0) OutStr
	q:('$d(^DHCINDIV("0","DHCInvPrt",InvPrtDr))) OutStr
	s DivDr=""
	;add by zhangdongliang 2015-10-16 for 挂号发票信息退出。
	s PrtInfo=$g(^DHCINVPRT(InvPrtDr))
	s PrtFairType=$p(PrtInfo,"^",34)
	q:PrtFairType="R" "N"
	;end
	f  s DivDr=$o(^DHCINDIV("0","DHCInvPrt",InvPrtDr,DivDr),-1) q:DivDr=""  d
	.s DivInfo=$g(^DHCINDIV(DivDr))			;70个字段
	.s AdmInfoDr=$p(DivInfo,"^",2)			
	.s Flag=$p(DivInfo,"^",5)
	.q:(DivFlag'="S")&&(Flag'="I")
	.q:(DivFlag="S")&&((Flag'="S")&&(Flag'="D"))
	.;s AdmInfo=$g(^DHCINADM(AdmInfoDr))		;50个字段
	.s INPAYbcbxf0=$p(DivInfo,"^",7)			;医保总费用
	.s INPAYgrzfe0=$p(DivInfo,"^",15)		;医保现金
	.s INPAYzhzfe0=$p(DivInfo,"^",28)		;医保账户支付
	.;s INPAYjjzfe0=INPAYbcbxf0-INPAYgrzfe0-INPAYzhzfe0	;$p(DivInfo,"^",19)		;除现金、医保账户支付外医保统筹总支付
	.s INPAYjjzfe0=$p(DivInfo,"^",19)
	.s INPAYInsuPay10=$p(DivInfo,"^",50)		;医保误差值 
	.s INPAYbcbxf0=INPAYbcbxf0+INPAYInsuPay10	;总金额考虑医保误差值
	.s INPAYgrzfe0=INPAYgrzfe0+INPAYInsuPay10	;现金考虑医保误差值
	
	.s TCPayModeDr="6"			;医保统筹支付方式Dr
	.;s ZHPayModeDr=""			;医保账户支付方式Dr
		
	.;拼门诊结算返回串            
    .s BackString = "0"_"^"_DivDr_"^"_INPAYgrzfe0_"^"_InvPrtDr_$c(2)_TCPayModeDr_"^"_INPAYjjzfe0		;_$c(2)_ZHPayModeDr_"^"_INPAYzhzfe0	
	s:BackString'="" OutStr="Y"_"!"_BackString
	q OutStr
}

/// 内部方法，不对外公布
/// 有问题 DingSH  应增加 [Abstract]--移走,dsh 20200514
ClassMethod CheckINSUIPDivFlag(PBDr As %String, DivFlag As %String) As %String
{
	n (PBDr,DivFlag)
	s OutStr="N"
	q:(+PBDr=0) OutStr
	q:('$d(^DHCINDIV("0","DHCPB",PBDr))) OutStr
	s DivDr=""
	s DivDr=$o(^DHCINDIV("0","DHCPB",PBDr,DivDr),-1)
	q:(DivDr="") OutStr
	s DivInfo=$g(^DHCINDIV(DivDr))	;70个字段
	s AdmInfoDr=$p(DivInfo,"^",2)			
	s Flag=$p(DivInfo,"^",5)
	q:(DivFlag'="S")&&(Flag'="I") OutStr 
	q:(DivFlag="S")&&(Flag'="B") OutStr
	;s AdmInfo=$g(^DHCINADM(AdmInfoDr))		;50个字段
	s INPAYbcbxf0=$p(DivInfo,"^",7)			;医保总费用
	s INPAYgrzfe0=$p(DivInfo,"^",15)		;医保现金
	s INPAYzhzfe0=$p(DivInfo,"^",28)		;医保账户支付
	s INPAYjjzfe0=INPAYbcbxf0-INPAYgrzfe0-INPAYzhzfe0	;$p(DivInfo,"^",19)		;除现金、医保账户支付外医保统筹总支付
	
	s INPAYInsuPay10=$p(DivInfo,"^",50)		;医保误差值 
	s INPAYbcbxf0=INPAYbcbxf0+INPAYInsuPay10	;总金额考虑医保误差值
	s INPAYgrzfe0=INPAYgrzfe0+INPAYInsuPay10	;现金考虑医保误差值
	
	s TCPayModeDr="34"			;医保统筹支付方式Dr
	;s ZHPayModeDr=""			;医保账户支付方式Dr
	
	;拼住院结算返回串            
    s BackString = "0"_"^"_DivDr_"^"_INPAYgrzfe0_"^"_PBDr_$c(2)_TCPayModeDr_"^"_INPAYjjzfe0		;_$c(2)_ZHPayModeDr_"^"_INPAYzhzfe0	
	s OutStr="Y"_"!"_BackString
	q OutStr
}

/*
ClassMethod Init() As %String
{
	k ^DHCTMPACCColPRT("IP")
	s ^DHCTMPACCColPRT("IP","123","BJ")=""
	s ^DHCTMPACCColPRT("IP","123","BJ","1")=""
	s ^DHCTMPACCColPRT("IP","123","BJ","1","PatPaySum")="498.72"
	s ^DHCTMPACCColPRT("IP","123","BJ","1","PrtRowID",24976)=""
	q 0
}
*/
/// w ##class(web.DHCINSUPort).Init()
/// add by zhangdongliang at 2014-09-02 for 卡支付集中打印发票，判断global无医保数据后，调用此接口函数更新global			
/// 入参Desc:
/// 	JustThread；	卡支付集中打印发票 的进程号
/// 出参：		0/小于0		0代表成功，小于零失败。
/// w ##class(web.DHCINSUPort).UpdateINSUOPDivCPPGlobal("123")
ClassMethod UpdateINSUOPDivCPPGlobal(JustThread As %String) As %String
{
	n (JustThread)
	s OutStr="-1"
	;b
	q:JustThread="" OutStr
	s AdmReasonId="",rtn=""
	;取支付方式rowid
	;s PayModeStr=##class(web.DHCINSUFacade).GetPayModeDr()	;Cash_"^"_INSU1
	s PayModeStr=..GetPayModeDr()	;Cash_"^"_INSU1
    f  s AdmReasonId=$o(^DHCTMPACCColPRT("IP",JustThread,AdmReasonId))     q:AdmReasonId=""    d
    .s DicInsuType=$p($$QueryByCode^DHCINSUDicData("AdmReasonDrToDLLType",AdmReasonId),"^",6)
    .;s DicInsuType="ZZB"
    .s myIdx="",ConStr="",TmpInvRowid="",TmpFlag=""
    .f  s myIdx=$o(^DHCTMPACCColPRT("IP",JustThread,AdmReasonId,myIdx)) q:myIdx=""  d
    ..s PRTAcount=$g(^DHCTMPACCColPRT("IP",JustThread,AdmReasonId,myIdx,"PatPaySum"))    //单张发票总费用
    ..s tmpPrtRowID="",TmpInvRowid=""
    ..f  s tmpPrtRowID=$o(^DHCTMPACCColPRT("IP",JustThread,AdmReasonId,myIdx,"PrtRowID",tmpPrtRowID)) q:(tmpPrtRowID="")||(+rtn<0)  d
    ...;^DHCBCI(0,"INV",{DHCBCI_INVDR},{DHCBCI_Rowid}) 
    ...;w !," tmpPrtRowID="_tmpPrtRowID
    ...;q:'$d(^DHCBCI(0,"INV",tmpPrtRowID))
    ...q:('$d(^DHCINDIV("0","DHCInvPrt",tmpPrtRowID))) 
	...s DivDr=""               ;"DHCInvPrt"
	...s DivDr=$o(^DHCINDIV("0","DHCInvPrt",tmpPrtRowID,DivDr),-1)
	...q:(DivDr="") 
	...s DivInfo=$g(^DHCINDIV(DivDr))			;70个字段
	...s INPAYFlag=$p(DivInfo,"^",5)
	...q:INPAYFlag'="I"
	...s INPAYbcbxf0=$p(DivInfo,"^",7)			;医保总费用
	...s INPAYgrzfe0=$p(DivInfo,"^",15)		;医保现金
	...s INPAYzhzfe0=$p(DivInfo,"^",28)		;医保账户支付
	...s INPAYjjzfe0=INPAYbcbxf0-INPAYgrzfe0-INPAYzhzfe0	;$p(DivInfo,"^",19)		;除现金、医保账户支付外医保统筹总支付
	...;支付方式串，各项目不同，暂时默认INPAYgrzfe0_""_INPAYjjzfe0_""_INPAYzhzfe0三部分
	...s jjzfInfo=$p(PayModeStr,"^",2)_"^"_INPAYjjzfe0
	...s BackString=myIdx_"^"_DivDr_"^"_INPAYgrzfe0_"^"_INPAYjjzfe0
	...s tmprtn=##class(web.DHCINSUOPBill).SetOPBillInfo(JustThread ,AdmReasonId, BackString)
	...q:tmprtn'="0"
	...s rtn=tmprtn
	
	s:rtn="0" OutStr="0"
	b
	q OutStr
}

/// Creator: 詹明超
/// Description:通过结算表ID、就诊号、发票ID、账单号等返回BI所需的结算数据
/// Input：INDIVID:Insu_divide.Rowid,PAADM:就诊号,PRTID:发票表Rowid,BILLNO:账单号,PRTFLAG：发票状态(N,S)
/// CreatDate:20150126
/// Others: w ##class(web.DHCINSUPort).GetDivideInfoForBI("885","786",186006,"","N")
/// Output: 失败：-1
/// 			成功：交易流水号^个人编号^医保卡号^医保结算日期^医保结算时间^收费日期^操作人员^医保险种^参保地^医保类别^就诊类型^医疗类别^中途结算标志^总费用^个人支付额^基金支付额^个人账户支付额 ^统筹支付^大病支付^公务员补助^民政救助(专项救助)^离休统筹^单位补充医疗^公务员大病医疗补充部分^保健对象支付^医院垫付(单病种垫付)^HIS总费用与医保返回数据的误差^医保内金额^医保外金额^个人自付一^个人自付二^自费金额^是否特殊病种^单病种编码^单病种定额^单病种名称^限价标志^限价类别^限价病种^定额差
ClassMethod GetDivideInfoForBI(INDIVID As %String = "", PAADM As %String = "", PRTID As %String = "", BILLNO As %String = "", PRTFLAG As %String = "") As %String
{
	n (INDIVID,PRTID,PRTID,BILLNO,PRTFLAG)
	q:(INDIVID="")&&(PAADM="")&&(PRTID="")&&(BILLNO="") "-1"
	s:PRTFLAG="" PRTFLAG="N"
	
	s RtnStr="-1"
	s (DivStr,Adminfo)=""
	i (INDIVID="")&&(PRTID'="") d	//一般是门诊数据
	.q:$d(^DHCINDIV("0","DHCInvPrt",PRTID))=0
	.s tmpdivId=""
	.f  s tmpdivId=$O(^DHCINDIV("0","DHCInvPrt",PRTID,tmpdivId),-1) q:tmpdivId=""  d
	..q:$p(^DHCINDIV(tmpdivId),"",5)'=PRTFLAG
	..s INDIVID=tmpdivId
	i (INDIVID="")&&(BILLNO'="") d	//一般是住院数据
	.q:$d(^DHCINDIV("0","DHCPB",BILLNO))=0
	.s tmpdivId=""
	.f  s tmpdivId=$O(^DHCINDIV("0","DHCPB",BILLNO,tmpdivId),-1) q:tmpdivId=""  d
	..q:$p(^DHCINDIV(tmpdivId),"",5)'=PRTFLAG
	..s INDIVID=tmpdivId
	i (INDIVID="")&&(PAADM'="") d	//取挂号时的结算数据
	.q:$d(^DHCINDIV("0","Paadm",PAADM))=0
	.s tmpdivId=""
	.f  s tmpdivId=$O(^DHCINDIV("0","Paadm",PAADM,tmpdivId),-1) q:tmpdivId=""  d
	..q:$p(^DHCINDIV(tmpdivId),"",5)'=PRTFLAG
	..q:$p(^DHCINDIV(tmpdivId),"",36)'="R"
	..s INDIVID=tmpdivId
	
	i INDIVID'="" d
	.//给返回值赋初始值，BI要求字段没有数据要返回Null
	.s RtnStr="Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null"
	.s DivStr=$$GetDivideInfo^DHCINSUDivide(INDIVID)	//因为加了rowid，取值时比表中定位的位置增加一位！
	.s AdminfoDr=$p(DivStr,"^",3)
	.s Adminfo=$g(^DHCINADM(AdminfoDr))
	.s $p(RtnStr,"^",1)=$p(DivStr,"^",9)	//交易流水号
	.s $p(RtnStr,"^",2)=$p(Adminfo,"^",2)	//个人编号
	.s $p(RtnStr,"^",3)=$p(Adminfo,"^",3)	//医保卡号
	.s $p(RtnStr,"^",4)=$p(DivStr,"^",23)	//医保结算日期
	.s $p(RtnStr,"^",5)=$p(DivStr,"^",25)	//医保结算时间
	.s $p(RtnStr,"^",6)=$p(DivStr,"^",17)	//收费日期
	.s $p(RtnStr,"^",7)=$p(DivStr,"^",22)	//操作人员
	.s $p(RtnStr,"^",8)=$p(Adminfo,"^",4)	//医保险种
	.s $p(RtnStr,"^",9)=$p(Adminfo,"^",7)	//参保地
	.s $p(RtnStr,"^",10)=$p(Adminfo,"^",18)	//医保类别
	.s $p(RtnStr,"^",11)=$p(Adminfo,"^",14)	//就诊类型
	.s $p(RtnStr,"^",12)=$p(Adminfo,"^",14)	//医疗类别
	.s $p(RtnStr,"^",13)=$p(DivStr,"^",38)	//中途结算标志
	.s $p(RtnStr,"^",14)=$p(DivStr,"^",8)	//总费用
	.s $p(RtnStr,"^",15)=$p(DivStr,"^",16)	//个人支付额
	.s $p(RtnStr,"^",16)=$p(DivStr,"^",20)-$p(DivStr,"^",29)	//基金支付额(统筹+大病+民政等)
	.s $p(RtnStr,"^",17)=$p(DivStr,"^",29)	//个人账户支付额 
	.s $p(RtnStr,"^",18)=$p(DivStr,"^",32)	//统筹支付
	.s $p(RtnStr,"^",19)=$p(DivStr,"^",33)	//大病支付
	.s $p(RtnStr,"^",20)=$p(DivStr,"^",34)	//公务员补助
	.s $p(RtnStr,"^",21)=$p(DivStr,"^",35)	//民政救助(专项救助)
	.s $p(RtnStr,"^",22)=$p(DivStr,"^",36)	//离休统筹
	.s $p(RtnStr,"^",23)=$p(DivStr,"^",47)	//单位补充医疗
	.s $p(RtnStr,"^",24)=$p(DivStr,"^",48)	//公务员大病医疗补充部分
	.s $p(RtnStr,"^",25)=$p(DivStr,"^",49)	//保健对象支付
	.s $p(RtnStr,"^",26)=$p(DivStr,"^",50)	//医院垫付(单病种垫付)
	.s $p(RtnStr,"^",27)=$p(DivStr,"^",51)	//HIS总费用与医保返回数据的误差
	.s $p(RtnStr,"^",28)=$p(DivStr,"^",40)	//医保内金额
	.s $p(RtnStr,"^",29)=$p(DivStr,"^",41)	//医保外金额
	.s $p(RtnStr,"^",30)=$p(DivStr,"^",41)	//个人自付一
	.s $p(RtnStr,"^",31)=$p(DivStr,"^",42)	//个人自付二
	.s $p(RtnStr,"^",32)=$p(DivStr,"^",43)	//自费金额
	q RtnStr
}

/// Creator: 詹明超
/// Description:根据结算表的rowid、发票表rowid和结算状态判断是否有正常的门诊医保结算数据
/// 				结算表的rowid和发票表rowid不能都为空
/// Input:DivDr结算表的rowid;InvPrtid：发票表的Rowid;Flag结算状态,I表示正常记录，B:表示被红充，S表示红充记录
/// CreatDate:20150211
/// Output:1：有正常记录，非1：未找到对应的数据
/// Others: w ##class(web.DHCINSUPort).GetFlagbyDivDr("结算表的rowid","发票表rowid","结算状态判断")
ClassMethod GetFlagbyDivDr(DivDr As %String = "", InvPrtid As %String = "", Flag As %String = "", ExtStr As %String = "") As %String
{
 n (DivDr,InvPrtid,Flag)
 q:(DivDr="")&(InvPrtid="") -1
 s INPAYRowid=DivDr
 s OutStr=-1
 q:INPAYRowid="" OutStr
 i INPAYRowid'=""  d
 .q:$d(^DHCINDIV(INPAYRowID))=0
 .s INPAYFlag=$p(^DHCINDIV(INPAYRowID),"^",5)
 .i (INPAYFlag="B")&&(Flag="S") d
 ..s INPAYFlag="S"
 .q:(INPAYFlag'=Flag)
 .s OutStr=1
 e  d
 .s INPAYRowID=""
 .q:$d(^DHCINDIV("0","DHCInvPrt",InvPrtid))=0
 .f  s INPAYRowID=$o(^DHCINDIV("0","DHCInvPrt",InvPrtid,INPAYRowID)) q:INPAYRowID=""  d
 ..s INPAYFlag=$p(^DHCINDIV(INPAYRowID),"^",5)
 ..q:(INPAYFlag'=Flag)
 ..s OutStr=1
 q OutStr
}

/// 根据账单号获取住院病人医保明细是否上传、是否结算
/// 入参:
/// 	BillNo:账单号，ExpStr：扩展字段
/// 返回值:
/// 	1:医保已上传明细
/// 	2:医保已结算
/// 	小于0:医保未结算未上传
/// Others: w ##class(web.DHCINSUPort).GetInsuUpFlag("账单号","")
/// 		此函数可以给计费组用于判断是否可以重新生成账单
ClassMethod GetInsuUpFlag(BillNo As %String = "", ExpStr As %String) As %String
{
	n (BillNo,ExpStr)
	s OutStr="-1"
	q:BillNo="" OutStr
	;q:($d(^DHCINDIS("0","PBDr",BillNo))=0)||($d(^DHCINDIV("0","DHCPB",BillNo))=0) OutStr
	//判断是否上传
	s divsubid=""
	f  s divsubid=$o(^DHCINDIS("0","PBDr",BillNo,divsubid))	q:divsubid=""  d
    .s tmpFlag=$p($g(^DHCINDIS(divsubid)),"^",18)
    .q:(tmpFlag'="N")&(tmpFlag'="I")       ;2010 08 20 liusf   原来是"I"
	.s OutStr=1
	//判断是否已结算
	s divid=""
	f  s divid=$o(^DHCINDIV("0","DHCPB",BillNo,divid))	q:divid=""  d
	.s INPAYFlag=$p(^DHCINDIV(divid),"^",5)
	.q:INPAYFlag'="I"
	.s OutStr=2
	q OutStr
}

/// 根据就诊号获取住院病人医保明细是否上传、是否结算
/// 入参:
/// 	PAADM:就诊号，ExpStr：扩展字段
/// 返回值:
/// 	大于0:医保已结算，不允许取消最终结算
/// 	小于0:医保未结算未上传
/// Others: w ##class(web.DHCINSUPort).GetInsuUpFlagByAdm("就诊号","")
/// 		此函数可以给护理组用于判断是否可以取消最终结算等。
/// 			如果有多个账单，任何一个账单有上传信息或结算信息就不允许取消最终结算
ClassMethod GetInsuUpFlagByAdm(PAADM As %String = "", ExpStr As %String) As %String
{
	n (PAADM,ExpStr)
	s OutStr="-1"
	q:PAADM="" OutStr
	q:$d(^DHCPB(0,"ADM",PAADM))=0 OutStr
	s billid=""
	f  s billid=$o(^DHCPB(0,"ADM",PAADM,billid))	q:billid=""  d
	.s Payedflag=$p(^DHCPB(billid),"^",16)
	.s Refundflag=$p(^DHCPB(billid),"^",17)
	.;q:(Payedflag'="B")&(Payedflag'="P")
	.;q:(Payedflag="P")&((Refundflag="B")||(Refundflag="P"))
	.s tmpOutStr=..GetInsuUpFlag(billid,"")
	.;
	.s:tmpOutStr>1 OutStr=tmpOutStr
	q OutStr
}

// w ##class(web.DHCINSUPort).SaveInsuAdmInfo("")

/// Creator ZhanMingChao  20160621
/// 入参Desc:
/// 	inAdmInfo:inadminfo数据串,或User.INSUAdmInfo对象,如果是其它对象要修改Util中的ObjtoAdminfoStr函数
/// 		inDivInfo:结算数据串,或User.INSUDivide对象
/// 	ExpStr:     扩展串,ExpStr:存储顺序是否一致标志^JSON标志:1,XML标志:2^就诊Dr^发票Rowid串(门诊不能为空,!分割)^操作员Dr^挂号或收费标识 R（挂号）、 F（收费）^结算来源(01：现金结算、02：集中打印、31：微信、32：支付宝、20：自助机、10：本地算法)
/// 出参：
/// 			0!医保结算表rowid
/// 			或-1!错误原因	
/// 备注:如果要使用事务请参考深圳版本
/// 应用场景：自助机项目，计费组调用此接口保存医保结算信息
/// w ##class(web.DHCINSUPort).SaveInsuAdmInfo(adminfoobj,divobj,"^")
/// 出参：-1 保存失败   0成功(返回值与.net中返回值一样)
/// 移动到自助机的工程里 20200514
ClassMethod SaveInsuAdmInfo(inAdmInfo, inDivInfo, ExpStr As %String) As %String
{
	n (inAdmInfo, inDivInfo, ExpStr)
	
	s $ZTrap ="SaveInsuAdmInfoEx"
	s inadmFlag=0
	s Flag="-1"
	s AdmInfoStr=""
	s DivStr=""
	q:(inAdmInfo="")&($IsObject(inAdmInfo)=0) Flag
	q:(inDivInfo="")&($IsObject(inDivInfo)=0) Flag
	s AdmInfoStr=##class(web.DHCINSUPortUtil).AdminfoDecode(inAdmInfo,ExpStr)
	s inadmrowid=##class(web.DHCINSUAdmInfoCtl).Save(AdmInfoStr)
	i inadmrowid<0 d
	.s inadmFlag=-1
	q:inadmFlag=-1 Flag
	s savedivflag=..SaveInsuDivInfo(inDivInfo,"",ExpStr)
	s rowid=$p(savedivflag,"!",2)
	i rowid>0 d      
    .s DivStr=^DHCINDIV(rowid)
    .;s Flag="0"_"^"_inadmrowid_"^1"_"!"_+$p(DivStr,"^",16)_$c(2)_"7!"_+$p(DivStr,"^",20)_$c(2)_$c(2)_"0!"_+$p(DivStr,"^",45)
    .s Flag=##class(web.DHCINSUPortUtil).BuildAdminfoRtnStr(inadmrowid,DivStr,"")
    e  d    
    .s $p(^DHCINADM(inadmrowid),"^",11)="I"	
    
	q Flag
	
SaveInsuAdmInfoEx
 ;异常处理	
	q "-1!"_$ze
}

/// Creator ZhanMingChao  2015-10-26
/// 入参Desc:
/// 	DivObj:	  结算数据串(如果不是结算表一致的拼串/XML/JSON，请自行修改DivDecode函数中的子函数),或User.INSUDivide对象
/// 	PAADM:	  就诊号
/// 	ExpStr: 扩展串,ExpStr:存储顺序是否一致标志^JSON标志:1,XML标志:2^就诊Dr^发票Rowid串(门诊不能为空,!分割)^操作员Dr^挂号或收费标识 R（挂号）、 F（收费）^结算来源(01：现金结算、02：集中打印、31：微信、32：支付宝、20：自助机、10：本地算法)
/// 出参：
/// 			0!医保结算表rowid
/// 			或-1!错误原因	
/// 备注	如果要使用事务请参考深圳版本		
/// 应用场景：自助机项目，计费组调用此接口保存医保结算信息
/// w ##class(web.DHCINSUPort).SaveInsuDivInfo("","324","^")
/// 移动到自助机的工程里 20200514
ClassMethod SaveInsuDivInfo(DivObj, InAdmId As %String, ExpStr As %String) As %String
{
	n (DivObj,PAADM,ExpStr)
	s $ZTrap ="SaveInsuDivInfoEx"
	s OutStr="-1!"
	s saveStr=""
	;q:PAADM="" "-1!就诊号不能为空"
	
	//DivObj为对象或用^分割的字符串或json串
	s saveStr=##class(web.DHCINSUPortUtil).DivDecode(DivObj,ExpStr)  
	b ;div
	q:saveStr="-1" OutStr
	
	s:$P(saveStr,"^",2)="" $P(saveStr,"^",2)=$P(ExpStr,"^",3)   ;就诊Dr
	s:$P(saveStr,"^",3)="" $P(saveStr,"^",3)=InAdmId            ;医保结算表
	s:$P(saveStr,"^",5)="" $P(saveStr,"^",5)=$P(ExpStr,"^",4)   ;发票rowid串
	s:$P(saveStr,"^",22)="" $P(saveStr,"^",22)=$P(ExpStr,"^",5) ;操作员Dr
	s:$P(saveStr,"^",37)="" $P(saveStr,"^",37)=$P(ExpStr,"^",6) ;挂号或收费标识 R（挂号） F（收费）
	s:$P(saveStr,"^",39)="" $P(saveStr,"^",39)=$P(ExpStr,"^",7) ;结算来源
	s DivMod=$P(ExpStr,"^",6) ;挂号或收费标识 R（挂号） F（收费）	
    s DivID=##class(web.DHCINSUDivideCtl).InsertDivInfo(saveStr)	;.NET调用的方法，不要动
    i +DivID>0 d
    .i DivMod="F" d
    ..;拼写更新支付方式的串
    ..s $P(saveStr,"^",1)=DivID 
	..s updatastr=##class(web.DHCINSUPortUtil).UpdateINVPRTYBInfoByDivide(saveStr,"")
	..;开始更新支付方式
	..s updatecode=##class(web.DHCINSUPortUse).UpdateINVPRTYBInfo(updatastr,"")	;调用公共的方法，不要动
	..i updatecode'=0 d
	...s $p(^DHCINDIV(DivID),"^",5)="D"
	..e  s OutStr="0!"_DivID
	;s OutStr="0!"_DivID
	q OutStr
SaveInsuDivInfoEx
 ;异常处理
	q "-1!"_$ze
}

/// Creator: 詹明超
/// Description:根据结算表的rowid结算状态判断是否有正常的门诊医保结算数据
/// Input:DivDr结算表的rowid;InvPrtid：发票表的Rowid;Flag结算状态,+(N):正常结算记录，-(B)：被红充了,S：红充
/// CreatDate:20150429
/// Output:错误状态码1：有正常记录，非1：未找到对应的数据^医保总金额、医保报销金额、医保现金支付金额
/// 错误状态码 {1:正常;-202:his医保数据状态不一致;-203:医保无此记录;-204:his没有相应记录;-205:his医保数据金额不一致}
/// Others: w ##class(web.DHCINSUPort).GetDivInfobyDivDr("结算表的rowid","结算状态判断","扩展参数")
ClassMethod GetDivInfobyDivDr(DivDr As %String = "", Flag As %String = "", ExtStr As %String = "") As %String
{
	n (DivDr,Flag,ExtStr)
	s OutStr=-1
	q:(DivDr="")||(Flag="") OutStr
	s INPAYRowid=DivDr
	q:INPAYRowid="" OutStr
	s errcode=""
	i INPAYRowid'=""  d
	.q:$d(^DHCINDIV(INPAYRowid))=0
	.s divstr=^DHCINDIV(INPAYRowid)
	.s INPAYFlag=$p(divstr,"^",5)
	.;i (INPAYFlag="B")&&(Flag="S") d
	..;s INPAYFlag="S"
	.s:INPAYFlag="insu" INPAYFlag="I"
	.s:INPAYFlag="bestrike" INPAYFlag="B"
	.s:INPAYFlag="strike" INPAYFlag="S"
	.s:INPAYFlag="divide" INPAYFlag="D"
	.q:INPAYFlag="D"
	.s inpay10=+$p(divstr,"^",50)
	.s insuTotAmt=$j(+$p(divstr,"^",7),0,2)
	.;s jjzfe=+$p(divstr,"^",19)
	.s grzfe=+$p(divstr,"^",15)
	.s jjzfe=$j(insuTotAmt-grzfe,0,2)
	.s OutStr=-202_"^"_insuTotAmt_"^"_jjzfe_"^"_grzfe
	.q:(INPAYFlag'="I")&((Flag="+")||(Flag="N"))
	.q:(INPAYFlag'="B")&(INPAYFlag'="S")&((Flag="-")||("B.S"[Flag))
	.;s OutStr=-203_"^"_insuTotAmt_"^"_jjzfe_"^"_grzfe

	.s invprtdr=$p(divstr,"^",4)
	.s invamt=$j(+$p(ExtStr,"^",1),0,2),invinsu=$j(+$p(ExtStr,"^",2),0,2)
	.s ckFlag=$p(ExtStr,"^",3)	;0:不核对金额,1:核对总金额,2:核对总金额及医保支付总额
	.s:ckFlag="" ckFlag=2
	.;i $d(^DHCINVPRT(invprtdr))
	..;s invamt=+$p(^DHCINVPRT(invprtdr),"^",1)
	..;s invinsu=+$p(^DHCINVPRT(invprtdr),"^",31)
	.s errcode=1
	.i ckFlag'="0" d
	..i ((invamt-insuTotAmt'=0)&(invamt-insuTotAmt-inpay10'=0))||((invinsu-jjzfe'=0)&(ckFlag="2")) d
	...s errcode=-205
	...;s OutStr=errcode_"^"_insuTotAmt_"^"_jjzfe_"^"_grzfe
	.s OutStr=errcode_"^"_insuTotAmt_"^"_jjzfe_"^"_grzfe
	q OutStr
}

/// 根据代码类别和位置取字典的值
/// SysType:SYS代码
/// Code:代码
/// Zhan 2015-12-21
/// 取值的位置
/// w ##class(web.DHCINSUPort).GetDicByCodeAndInd("TariType","CZZG",0)
ClassMethod GetDicByCodeAndInd(SysType, Code, Ind) As %String
{
	n (SysType,Code,Ind)
	q ##class(web.INSUDicDataCom).GetDicByCodeAndInd(SysType,Code,Ind)
}

/// 根据费别id和代码取字典表数据列表
/// admreasonDr:费别表rowid,dicType:字典类别,dicCode:字典代码,ExpStr:扩展参数(以^分割,比如第一位是$p取值位置)
/// 当admreasonDr不为空时,取对应的医保类别代码,并拼给dicType,如果dicCode为空,则返回列表
/// Zhan 20170101
/// w ##class(web.DHCINSUPort).GetDicInfoByCode(4,"DispenType","",0)
ClassMethod GetDicInfoByCode(admreasonDr, dicType, dicCode, ExpStr) As %String
{
	n (admreasonDr, dicType, dicCode,ExpStr)
	s insutype="",RtnStr=""
	s Ind=+$p(ExpStr,"^",1)
	i +admreasonDr>0 d
	.s insutype=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AdmReasonDrToTariType",admreasonDr,6)
	.s:insutype'="" dicType=dicType_insutype
	s RtnStr=$$GetSys^DHCINSUDicData(dicType,dicCode)
	i ($l(RtnStr,"^")>1)&(Ind>0) d
	.s RtnStr=$p(RtnStr,"^",Ind)
	q RtnStr
}

/// Description:根据收费项目代码，判断是否存在上传了对照关系
/// Creator:李铭京
/// Input:收费项Rowid
/// Output:(-1 未对照 0 对照未上穿 为1是表示目录上传医保中 为2是表示目录中心已经审核 为3是表示目录中心审核不通过) ^ 收费项Rowid^收费项Code^收费项描述（多个用！分割）
/// w ##class(web.DHCINSUPort).GetTarConUpFlag("3236","BJ")
ClassMethod GetTarConUpFlag(TarDr As %String, InsuType As %String) As %String
{
	n (TarDr,InsuType)
	s InsuTarConDr="",Rtn=""
	f  s InsuTarConDr=$o(^DHCINTCT(0,"DHCTID",TarDr,InsuTarConDr)) q:InsuTarConDr=""  d
	.Q:InsuTarConDr="" 
	.s InsuTarCode="",InsuTarDesc=""
	.s TarConType=$p(^DHCINTCT(InsuTarConDr),"^",12)
	.q:TarConType'=InsuType
	.s ActiveDate=$p(^DHCINTCT(InsuTarConDr),"^",13)
	.s ExpiryDate=$p(^DHCINTCT(InsuTarConDr),"^",20)
	.Q:(ActiveDate>+$h)||((ExpiryDate<+$h)&&(ExpiryDate'=""))
	.s InsuTarDr=$p(^DHCINTCT(InsuTarConDr),"^",4)
	.s InsuTarCode=$p(^DHCINTCT(InsuTarConDr),"^",5)
	.s InsuTarDesc=$p(^DHCINTCT(InsuTarConDr),"^",6)
	.s DrAddFlag=$p(^DHCINTCT(InsuTarConDr),"^",11)
	.s:Rtn'="" Rtn=Rtn_"!"_DrAddFlag_"^"_InsuTarDr_"^"_InsuTarCode_"^"_InsuTarDesc
	.s:Rtn="" Rtn=DrAddFlag_"^"_InsuTarDr_"^"_InsuTarCode_"^"_InsuTarDesc
    Q Rtn
}

/// Creator:ZhanMingChao 
/// Description:insu_divide表Rowid更新医保结算表发票指针 
/// Input：INSUDIVDR:insu_divide表Rowid 
/// Output: 失败:-1 成功:0 
/// CreatDate:20161101 
/// Others:计费组过号重打时调用
/// Others: w ##class(web.DHCINSUPort).UpdateInsuPrtDr("81","15","")
ClassMethod UpdateInsuPrtDr(INSUDIVDR As %String, INVPRTDR As %String, ExpStr As %String) As %String
{
	s RtnCode=-1  
	q:(+$g(INSUDIVDR)=0)||(+$g(INVPRTDR)=0) RtnCode
	&SQL(UPDATE INSU_Divide SET INPAY_DhcInvPrtDr=:INVPRTDR WHERE INPay_Rowid=:INSUDIVDR)
	i (SQLCODE'=0) d
	.s RtnCode=-2
	e  s RtnCode=0
	q RtnCode
}

/// w ##class(web.DHCINSUPort).GetDividePreByAdmDr("392")
ClassMethod GetDividePreByAdmDr(AdmDr) As %String
{
	n (AdmDr)
	s OutStr="0.00"
	q:$d(^DHCINDIVPre("0","Paadm",AdmDr))=0 OutStr
	s Id=$O(^DHCINDIVPre("0","Paadm",AdmDr,""),-1)
	q:(Id="") OutStr
	s cash=$p(^DHCINDIVPre(Id),"^",15)
	s bcbxf0=+$p(^DHCINDIVPre(Id),"^",7)				;总费用
	s YB=bcbxf0-cash
	s iDate=$p(^DHCINDIVPre(Id),"^",16)
	q YB
}

/// Creator: 	  yangjianzhang
/// CreatDate：	  2010-05-17
/// Description:  获得支付方式rowid 用于返串给计费和医生站时拼入
/// Table:		  ct_paymode
/// Input:		  
/// Output:		  No
/// Return:		  支付方式rowid拼成的串
/// Others:		  No
/// w ##class(web.DHCINSUPort).GetPayModeDr()
ClassMethod GetPayModeDr() As %String
{
	s ReturnStr=""
	s Cash="" 		;现金总支付
	s INSU1=""		;医保基金支付
	s INSUZHZF=""		;医保账户支付

	s CTPMCode=""
	f  s CTPMCode=$o(^CT("CTPM",0,"Code",CTPMCode))  q:CTPMCode=""   d
	.s CTPMRowId=""
	.f  s CTPMRowId=$o(^CT("CTPM",0,"Code",CTPMCode,CTPMRowId)) q:CTPMRowId=""  d
	..s:(CTPMCode="CASH") Cash=CTPMRowId 
	..s:(CTPMCode="YBINSU") INSU1=CTPMRowId 
	..s:(CTPMCode="INSUZHZF") INSUZHZF=CTPMRowId 
	s ReturnStr=Cash_"^"_INSU1_"^"_INSUZHZF
	q ReturnStr
}

/// 根据insu_divide.rowid获取医保支付方式串
/// w ##class(web.DHCINSUPort).GetDivBackStrByRowid(3767778,1,"R")
/// 入参：		InPayRowid：insu_divide.rowid
/// 			GrzfModeStr：个人支付默认支付方式rowid
/// 			ExtStr：扩展串,第一位放结算类型。R:挂号 O:门诊结算 I:住院结算
/// 出参：失败：错误代码!错误描述
///       成功：0!支付方式串
/// 	备注：门诊结算:"0^insu_divide.rowid^现金^dhc_invprt.rowid^个人支付支付方式$c(2)支付方式rowid^金额$c(2)支付方式rowid^金额..."
/// 		  门诊挂号:"0^insu_adminfo.rowid^现金^insu_divide.rowid^个人支付支付方式$c(2)支付方式rowid^金额$c(2)支付方式rowid^金额..."
/// 		  住院结算:"0^insu_divide.rowid^现金^dhc_patientbill.rowid$c(2)支付方式rowid^金额$c(2)支付方式rowid^金额..."
ClassMethod GetDivBackStrByRowid(InPayRowid As %String, GrzfModeStr As %String, ExtStr As %String) As %String
{
	n (InPayRowid,GrzfModeStr,ExtStr)
	s OutStr="-1!"
	s DivType=$p(ExtStr,"^",1)   ///R:挂号 O:门诊结算
	q:$g(InPayRowid)="" "-1!参数不能为空"
	q:'$d(^DHCINDIV(InPayRowid)) "-1!未结算"
	s DivInfo=$g(^DHCINDIV(InPayRowid))
	s Flag=$p(DivInfo,"^",5)
	q:(Flag'="I") "-1!未结算"
	s InvPrtDr=$p(DivInfo,"^",4)
	s PBDr=$p(DivInfo,"^",3)
	s InAdmInfoRowid=$p(DivInfo,"^",2)
	s InAdmInfo=$g(^DHCINADM(InAdmInfoRowid))		
	s INPAYbcbxf0=$p(DivInfo,"^",7)			;总费用
	s INPAYgrzfe0=$p(DivInfo,"^",15)		;现金支付
	s INPAYzhzfe0=$p(DivInfo,"^",28)		;个人帐户支付
	s INPAYjjzfe0=$p(DivInfo,"^",19)		;基金
	s INPAYPay01=$p(DivInfo,"^",31) 
	s INPAYPay02=$p(DivInfo,"^",32) 
	s INPAYPay03=$p(DivInfo,"^",33) 
	s INPAYPay04=$p(DivInfo,"^",34) 
	s INPAYPay05=$p(DivInfo,"^",35) 
	s INPAYPay06=$p(DivInfo,"^",46) 
	s INPAYPay07=$p(DivInfo,"^",47) 
	s INPAYPay08=$p(DivInfo,"^",48) 
	s INPAYPay09=$p(DivInfo,"^",49) 
	s INPAYPay10=$p(DivInfo,"^",50) 		;误差		
	s InsuType=$p(InAdmInfo,"^",18)	
	s InsuSum=INPAYgrzfe0+INPAYzhzfe0+INPAYPay01+INPAYPay02+INPAYPay03+INPAYPay04+INPAYPay05+INPAYPay06+INPAYPay07+INPAYPay08+INPAYPay09
	;判断医保返回总金额是否等于医保返回分解金额相加
	q:INPAYbcbxf0'=InsuSum "-2!医保返回总金额为："_INPAYbcbxf0_",医保分解金额相加为："_InsuSum			
	
	;取ct_paymode表rowid,返回顺序需要根据实际医保存值写死。
	;s PayModeStr=##class(web.INSUBase).GetPayModeDr()
	s PayModeStr=..GetPayModeDr()
	s:GrzfModeStr="" GrzfModeStr=$p(PayModeStr,"^",1) 
	
	i (DivType="O")||(DivType="P") d
    .s BackString = "0"_"^"_InPayRowid_"^"_(INPAYgrzfe0)_"^"_InvPrtDr_"^"_GrzfModeStr
    i DivType="R" d
    .s BackString = "0"_"^"_InAdmInfoRowid_"^"_InPayRowid_"^"_GrzfModeStr
    .s BackString=BackString_"!"_GrzfModeStr_"^"_(INPAYgrzfe0)
    i DivType="I" d
    .s BackString = "0"_"^"_InPayRowid_"^"_(INPAYgrzfe0)_"^"_PBDr
    b ;0
    s:INPAYzhzfe0'=0 BackString=BackString_$c(2)_$p(PayModeStr,"^",3)_"^"_INPAYzhzfe0
    ;s:INPAYjjzfe0'=0 BackString=BackString_$c(2)_PayjjzfePayModeDr_"^"_INPAYjjzfe0
    s:INPAYPay01'=0 BackString=BackString_$c(2)_$p(PayModeStr,"^",2)_"^"_INPAYPay01
    s:INPAYPay02'=0 BackString=BackString_$c(2)_$p(PayModeStr,"^",5)_"^"_INPAYPay02
    s:INPAYPay03'=0 BackString=BackString_$c(2)_$p(PayModeStr,"^",6)_"^"_INPAYPay03
    s:INPAYPay04'=0 BackString=BackString_$c(2)_$p(PayModeStr,"^",7)_"^"_INPAYPay04
    s:INPAYPay05'=0 BackString=BackString_$c(2)_$p(PayModeStr,"^",8)_"^"_INPAYPay05
    s:INPAYPay06'=0 BackString=BackString_$c(2)_$p(PayModeStr,"^",9)_"^"_INPAYPay06
    s:INPAYPay07'=0 BackString=BackString_$c(2)_$p(PayModeStr,"^",10)_"^"_INPAYPay07
    s:INPAYPay08'=0 BackString=BackString_$c(2)_$p(PayModeStr,"^",11)_"^"_INPAYPay08
    s:INPAYPay09'=0 BackString=BackString_$c(2)_$p(PayModeStr,"^",12)_"^"_INPAYPay09
    i DivType="O" d
    .s OutStr=##class(web.DHCINSUOPBill).UpdateINVPRTYBInfo(BackString,"")
    .i OutStr'="0" d
    ..s OutStr="-3!更新支付方式失败,错误代码:"_OutStr
    .e  d
    ..s OutStr="0!"_BackString
    i DivType="P" d
    .s OutStr=##class(web.DHCINSUOPBill).GxPEZffs(InvPrtDr,BackString)
    .i OutStr'="0" d
    ..s OutStr="-3!更新支付方式失败,错误代码:"_OutStr
    .e  d
    ..s OutStr="0!"_BackString
    i DivType="R" d 								
	.s OutStr="0!"_BackString
	i DivType="I" d
	.s OutStr="0!"_BackString
	
	q OutStr
}

/// Creator: 郭宁
/// Description:校验用户工号和密码是否正确
/// Input:UserCode：操作员工号,PassWord:操作员密码
/// CreatDate:20150211
/// Output:0_"!"_UserRowid^UserCode^UserName :校验正确返回状态和操作员Dr。非0：校验不正确
/// Others: w ##class(web.DHCINSUPort).CheckUserCodeAndPassWord("Demo",1)
/// 移动到web.DHCINSUBase.cls中 20200514
ClassMethod CheckUserCodeAndPassWord(UserCode As %String = "", PassWord As %String = "") As %String
{
 n (UserCode,PassWord)
 s OutStr="-1"
 q:(UserCode="")!(PassWord="") OutStr_"!"_"用户名和密码不能空"
 s UserRowid=""
 q:$d(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(UserCode)))=0 OutStr_"！"_"不存在该用户"
 s UserRowid=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(UserCode),""),-1)
 s ActiveFlag=$p(^SSU("SSUSR",UserRowid),"^",19)
 s UserName=$p(^SSU("SSUSR",UserRowid),"^",2)
 q:ActiveFlag'="Y" OutStr_"！"_"该用户为无效用户"
 s EnPassWord=$$ENCR^SSUTIL2(PassWord)
 s tPassWord=$p(^SSU("SSUSR",UserRowid),"^",3)
 b ;00
 q:EnPassWord'=tPassWord OutStr_"！"_"密码错误"
 s OutStr=0_"!"_UserRowid_"^"_UserCode_"^"_UserName
 q OutStr
}

/// Creator：      DingSH
/// CreatDate：    2018 06 07
/// Description:   根据就诊号或账单ID判断是否有未结算账单
/// Table：        
/// Input：        AdmDr;BillDr
/// Output：       
/// Return：       0:无未结算账单 ;1:有未结算账单
/// Others：  
/// 使用场景：
///       需求编号：548775
///       需求描述：标准版住院结算界面账单为P状态的记录不再补调医保接口，医保登记界面账单为P状态的记录不允许再医保登记
/// w ##class(web.DHCINSUPort).CheckBillStatus("5", "")
/// w ##class(web.DHCINSUPort).CheckBillStatus("", "264593")
/// w ##class(web.DHCINSUPort).CheckBillStatus("", "264590")
ClassMethod CheckBillStatus(AdmDr, BillDr) As %String
{
	n (AdmDr, BillDr)
	s Flag="0" ;无未结算账单
	if (AdmDr'="")
	{ 
	  ;b ;00
      q:+$d(^PAADM(AdmDr))=0 ;非法就诊ID
	  s PBRowId="",PBPayedFlag=""
	  s PBRowId=$O(^DHCPB(0,"ADM",AdmDr,""),-1)
	  s:PBRowId'="" PBPayedFlag=$P(^DHCPB(PBRowId),"^",16)
      s:PBRowId="" Flag="1"      ;刚住院登记没有产生账单情况:有未结算账单
	  s:PBPayedFlag'="P" Flag="1"
	  ;b ;01
	}
	
	if (BillDr'="")
	{
	  ;b ;000
      q:+$d(^DHCPB(BillDr))=0 ;非法账单ID
	  s PBPayedFlag=""
	  s PBPayedFlag=$P(^DHCPB(BillDr),"^",16)
	  s:PBPayedFlag'="P" Flag="1"
	  ;b ;001
		
	}
	
	q Flag
}

/*
/// Creator: hwq WH
/// Description:公费医疗发票信息(按类别)
/// Input：InsuDiv   Insu_divide表rowid
/// CreatDate:2011-07-29
/// OutPut: 类别名称1^总金额1^记账1^个人支付1|类别名称2^总金额2^记账2^个人支付2……#总金额^记账^个人支付
/// Others: w ##class(web.DHCINSUPort).GetInsuCatByDivDr("1122")
ClassMethod GetInsuCatByDivDr(InsuDiv As %String) As %String
{
	n (InsuDiv)
	k ^CacheTemp("INSUINVPRT")
	s Out="-1"
	s InsuDivInfo=$g(^DHCINDIV(InsuDiv))
	s LSH=$p(InsuDivInfo,"^",8)
	s Amount=$p(InsuDivInfo,"^",7)
	s FundPaySum=$p(InsuDivInfo,"^",31)
	s SelfPay=$p(InsuDivInfo,"^",15)
 	s INDISIC=""
	f  s INDISIC=$o(^DHCINDISIC("0","JYLSH",LSH,INDISIC))  q:INDISIC=""  d
	.s AdmDr=$p(^DHCINDISIC(INDISIC),"^",3)
	.s TarCatDr=$p(^DHCINDISIC(INDISIC),"^",5)
	.;s TarCate=$p(^DHCINDID(TarCatDr),"^",2)
	.s TarDesc=$p(^DHCTarC("TOC",TarCatDr),"^",2)
	.b
	.s TotAmount=$p(^DHCINDISIC(INDISIC),"^",8)
	.s FundPay=$p(^DHCINDISIC(INDISIC),"^",12)
	.s TotSelf=$p(^DHCINDISIC(INDISIC),"^",16)
	.s InsuType=$p(^DHCINDISIC(INDISIC),"^",63)
	.b
	.s TypeDesc=..RtnDicDescByDicCode("TariType",InsuType)
	.s $p(^CacheTemp("INSUINVPRT",AdmDr,TarCatDr),"^",1)=$p($g(^CacheTemp("INSUINVPRT",AdmDr,TarCatDr)),"^",1)+TotAmount
	.s $p(^CacheTemp("INSUINVPRT",AdmDr,TarCatDr),"^",2)=$p($g(^CacheTemp("INSUINVPRT",AdmDr,TarCatDr)),"^",2)+FundPay
	.s $p(^CacheTemp("INSUINVPRT",AdmDr,TarCatDr),"^",3)=$p($g(^CacheTemp("INSUINVPRT",AdmDr,TarCatDr)),"^",3)+TotSelf
	.s $p(^CacheTemp("INSUINVPRT",AdmDr,TarCatDr),"^",4)=TarDesc
	s TarCat=""
	f  s TarCat=$o(^CacheTemp("INSUINVPRT",AdmDr,TarCat))  q:TarCat=""  d
	.s InvprtStr=$g(^CacheTemp("INSUINVPRT",AdmDr,TarCat))
	.i Out="-1"  d
	..s Out=$p(InvprtStr,"^",4)_"^"_$p(InvprtStr,"^",1)_"^"_$p(InvprtStr,"^",2)_"^"_$p(InvprtStr,"^",3)
	.e  d
	..s Out=Out_"|"_$p(InvprtStr,"^",4)_"^"_$p(InvprtStr,"^",1)_"^"_$p(InvprtStr,"^",2)_"^"_$p(InvprtStr,"^",3)
	s Out=Out_"#"_Amount_"^"_FundPaySum_"^"_SelfPay_"#"_TypeDesc
	//中成药^76.74^65.229^11.511|彩超^1300^1235^65#1376.74^1235^76.51"
	q Out
}

/// w ##class(web.DHCINSUPort).RtnDicDescStrByDicBill1("Skc516WHA","1, 2, 3 ,4,5,6,7,8,9,10,a")
ClassMethod RtnDicDescStrByDicBill1(DicType As %String, DicBill1Str As %String) As %String
{
	n (DicType,DicBill1Str)
	s OutStr=""
	s DicCode=""
	s DicStr=$$Query^DHCINSUDicData(DicType,DicCode)
	q:DicStr=0 OutStr
	q:DicStr="" OutStr
	;DicStr=i_"^"_$j
	

	s INSUDicId=""
	s DataString=""
	f  s INSUDicId=$o(^CacheTemp("INSUDic",$p(DicStr,"^",2),INSUDicId))  q:INSUDicId=""  d
	.s DataString=$g(^CacheTemp("INSUDic",$p(DicStr,"^",2),INSUDicId))
	.s id=$p(DataString,"^",1)
	.s cType=$p(DataString,"^",2)
    .s cCode=$p(DataString,"^",3)
    .s cDesc=$p(DataString,"^",4)
    .s cDemo=$p(DataString,"^",5)
    .s cBill1=$p(DataString,"^",6)
    .s cBill2=$p(DataString,"^",7)


    .s Num=$l(DicBill1Str,",")
    .f i=1:1:Num  d
    ..s Flag="N"
    ..s tmpcBill1=$tr($p(DicBill1Str,",",i)," ")
    ..s:cBill1=tmpcBill1 Flag="Y"
    ..q:Flag'="Y"
    ..i OutStr=""  d
    ...s OutStr=cDesc
	..e  d
	...s OutStr=OutStr_","_cDesc
	q OutStr
}


/// 医嘱项关联医保收费项信息列表
/// ArcimRowid：医嘱项的rowid; AdmReasonDr：病人就诊费别(paadm_admreason)
/// 返回医保项的信息      特检  9028||1     限制性提示  "15199||1"
/// w ##class(web.DHCINSUPort).ArcimLinkInsuList("16346||1", 3)
ClassMethod ArcimLinkInsuListold(ArcimRowid, AdmReasonDr)
{
	n (ArcimRowid, AdmReasonDr)
	s InsuType="",OutStr=""
	q:$g(ArcimRowid)="" "-1^医嘱项Dr不能为空"
	q:$g(AdmReasonDr)="" "-1^AdmReasonDr不能为空"
	q:$d(^PAC("ADMREA",AdmReasonDr))=0 "-1"
	s AdmReasonCode=$p(^PAC("ADMREA",AdmReasonDr),"^",1)
	s TmpOut=$$QueryByCode^DHCINSUDicData("AdmReasonDrToTariType",AdmReasonDr)
	s InsuType=$p(TmpOut,"^",6)
	s:InsuType="" InsuType="NNA"
	q:$d(^DHCOLT(0,"ARTTA",ArcimRowid))=0 "-2^医嘱项没有对应的收费项"	
	s TariDr=""
	f  s TariDr=$o(^DHCOLT(0,"ARTTA",ArcimRowid,TariDr))     q:TariDr=""  d
	.s TariCode=$p($g(^DHCTARI(+TariDr)),"^",1)
	.s TariDesc=$p($g(^DHCTARI(+TariDr)),"^",2)
	.s TariInsuFlag=$p($$QueryByCode^DHCINSUDicData("TariInsuFlag",InsuType),"^",6)   //取收费项是否与其他收费项关联的标志  add by lilizhi 2013-03-05
	.s TarItemInsuInfo=$$GetConInfo^DHCINSUTarContrast(TariDr,InsuType,$zd(+$h,3),TariInsuFlag)
	.s zfbl=$p(TarItemInsuInfo,"^",18)
	.s:zfbl'="" zfbl=+(zfbl*100)_"%"  			//自负比例
	.s InsuClass=$p(TarItemInsuInfo,"^",23)	    //医保等级(甲,乙,非医保)
	.s Demo=$p(TarItemInsuInfo,"^",22)          //备注(限制用药信息)
	.s txbz=$p(TarItemInsuInfo,"^",34)           //门诊特病 wty 20110824
	.if (AdmReasonDr'="36") s txbz="0" //wty 20110824
	.s:txbz'="1" txbz="0" 
	.s flzb1=$p(TarItemInsuInfo,"^",25)         //特检特治标志
	.s:flzb1'="1" flzb1="0"
	.if (AdmReasonDr'="2")&(AdmReasonDr'="3")&(AdmReasonDr'="8")&(AdmReasonDr'="14") s flzb1="0" //特检特治仅限这几类人 0831
    .s:InsuClass="1" InsuClass="甲类"
    .s:InsuClass="2" InsuClass="乙类"
    .s:InsuClass="3" InsuClass="自费"
    .s:((InsuClass'="甲类")&(InsuClass'="乙类")) InsuClass="自费"
    .s:InsuClass="自费" zfbl="100%"
    .;       收费项目代码 收费项目名称  项目等级   支付比例  备注 特殊标志  特检特治标志
    .i OutStr="" d
    ..s OutStr=TariCode_"^"_TariDesc_"^"_InsuClass_"^"_zfbl_"^"_Demo_"^"_txbz_"^"_flzb1
    .e       d
    ..s OutStr=OutStr_"!"_TariCode_"^"_TariDesc_"^"_InsuClass_"^"_zfbl_"^"_Demo_"^"_txbz_"^"_flzb1
    q OutStr
}

ClassMethod CheckINSUOPDivFlag(InvPrtDr As %String, DivFlag As %String) As %String
{
	n (InvPrtDr,DivFlag)
	s OutStr="N"
	q:(+InvPrtDr=0) OutStr
	q:('$d(^DHCINDIV("0","DHCInvPrt",InvPrtDr))) OutStr
	s DivDr=""
	s DivDr=$o(^DHCINDIV("0","DHCInvPrt",InvPrtDr,DivDr),-1)
	q:(DivDr="") OutStr
	s DivInfo=$g(^DHCINDIV(DivDr))			;70个字段
	s AdmInfoDr=$p(DivInfo,"^",2)			
	s Flag=$p(DivInfo,"^",5)
	q:(DivFlag'="S")&&(Flag'="I") OutStr 
	q:(DivFlag="S")&&(Flag'="B") OutStr
	;s AdmInfo=$g(^DHCINADM(AdmInfoDr))		;50个字段
	s INPAYbcbxf0=$p(DivInfo,"^",7)			;医保总费用
	s INPAYgrzfe0=$p(DivInfo,"^",15)		;医保现金
	s INPAYzhzfe0=$p(DivInfo,"^",28)		;医保账户支付
	s INPAYjjzfe0=INPAYbcbxf0-INPAYgrzfe0-INPAYzhzfe0	;$p(DivInfo,"^",19)		;除现金、医保账户支付外医保统筹总支付
	
	s INPAYInsuPay10=$p(DivInfo,"^",50)		;医保误差值 
	s INPAYbcbxf0=INPAYbcbxf0+INPAYInsuPay10	;总金额考虑医保误差值
	s INPAYgrzfe0=INPAYgrzfe0+INPAYInsuPay10	;现金考虑医保误差值
	
	s TCPayModeDr="34"			;医保统筹支付方式Dr
	;s ZHPayModeDr=""			;医保账户支付方式Dr
	
	
	;拼门诊结算返回串            
    s BackString = "0"_"^"_DivDr_"^"_INPAYgrzfe0_"^"_InvPrtDr_$c(2)_TCPayModeDr_"^"_INPAYjjzfe0		;_$c(2)_ZHPayModeDr_"^"_INPAYzhzfe0	
	s OutStr="Y"_"!"_BackString
	q OutStr
}

*/
/// ywb--建议放在计费对外接口中20200514
/// 20141225
/// 获取分类信息门诊传发票表InvDr,住院传账单号bill
/// w ##class(web.DHCINSUPort).GetCateFee("226746","")
ClassMethod GetCateFee(InvDr, bill)
{
	n (InvDr,bill)
	s job=$j,str="",Type=""
	k ^TMP("BILL","CateFee",job)
	if (InvDr'=""){
		s Type="TOC"
		s Condr=""
		f  s Condr=$o(^DHCBCI(0,"INV",InvDr,Condr))  q:Condr=""  d
		.s Bill=$p($g(^DHCBCI(Condr)),"^",2)
		.s BillOrd=""
		.f  s BillOrd=$o(^DHCPB(Bill,"O",BillOrd))  q:BillOrd=""   d
		..s BillDetsub=""
		..f  s BillDetsub=$o(^DHCPB(Bill,"O",BillOrd,"D",BillDetsub))   q:BillDetsub=""   d
		...s tarid=$p($g(^DHCPB(Bill,"O",BillOrd,"D",BillDetsub)),"^",3)
		...q:tarid=""
		...s OPSubCat=$p($g(^DHCTARI(tarid)),"^",15)      ;门诊子类
		...s OPSubCatCode=$p($G(^DHCTarC("OC",OPSubCat)),"^",1)  ;门诊大类
		...s OPCat=$p($G(^DHCTarC("OC",OPSubCat)),"^",3)  ;门诊大类		
		...s ^TMP("BILL","CateFee",job,OPCat)=$g(^TMP("BILL","CateFee",job,OPCat))+$p($g(^DHCPB(Bill,"O",BillOrd,"D",BillDetsub)),"^",7)
		
	

	}elseif(bill'=""){
		s BillOrd="0",Type="TIC"
		f  s BillOrd=$o(^DHCPB(bill,"O",BillOrd))  q:BillOrd=""   d
		.s BillDetsub="0"
		.f  s BillDetsub=$o(^DHCPB(bill,"O",BillOrd,"D",BillDetsub))   q:BillDetsub=""   d
		..s tarid=$p($g(^DHCPB(bill,"O",BillOrd,"D",BillDetsub)),"^",3)
		..q:tarid=""
		..s IPSubCat=$p($g(^DHCTARI(tarid)),"^",14)
		..s IPSubCatCode=$p($G(^DHCTarC("IC",IPSubCat)),"^",1) 
		..s IPCat=$p($G(^DHCTarC("IC",IPSubCat)),"^",3)
		..s ^TMP("BILL","CateFee",job,IPCat)=$g(^TMP("BILL","CateFee",job,IPCat))+$p($g(^DHCPB(bill,"O",BillOrd,"D",BillDetsub)),"^",7)
	
	
	}else{
	}
	if (Type'=""){
		s catDr="0"
		f  s catDr=$o(^DHCTarC(Type,catDr)) q:catDr=""  d
		.s cateDesc=$p(^DHCTarC(Type,catDr),"^",2)     
		.s cateCode=$p(^DHCTarC(Type,catDr),"^",1)
		.s amt=+$g(^TMP("BILL","CateFee",job,catDr))
		.i str="" s str=cateDesc_"|"_amt
		.e  s str=str_"^"_cateDesc_"|"_amt
	}else{
		s str=-1
	}

	q str
}

/// 收费相关联医保收费项信息
/// Input：  TarItmRowid:收费项Dr,AdmReasonDr:病人就诊费别rowid,PBDID:账单明细表ID
/// 				DivFlag:是否优先从医保上传明细表中取数据(Y/N),ExpStr:扩展参数
/// Output：成功：返回医保相关信息:项目等级xmlb、自付比例zfbl、医保收费类别、报销金额、自费金额
/// 			失败：-1^失败原因
/// Others：甲类^0^^^
/// w ##class(web.DHCINSUPort).GetTarInsuInfo("309","4","272106||1||1","Y","")
/// 乙类^0.5^西药^^
ClassMethod GetTarInsuInfo(TarItmRowid, AdmReasonDr, PBDID, DivFlag, ExpStr As %String) As %String
{
 	n (TarItmRowid, AdmReasonDr, PBDID, DivFlag, ExpSt)
 	s OutStr="",zfbl="",xmlb="",sflb="",bxje="",zfjj=""
 	q:(TarItmRowid="")&(PBDID="") "-1^收费项Dr和账单明细表ID不能同时为空"
 	i $g(DivFlag)="Y" {	//从dividesub表取数据
	 	q:$g(PBDID)="" "-1^DivFlag为Y时,账单明细表ID不能为空"
	 	q:$d(^DHCINDIS("0","PBDDr",PBDID))="0" "-1^账单明细表ID无对应数据"
	 	s INDISid=""
	 	f  s INDISid=$o(^DHCINDIS("0","PBDDr",PBDID,INDISid)) q:INDISid=""  d
	 	.s tmpdisstr=$g(^DHCINDIS(INDISid))
	 	.q:$p(tmpdisstr,"^",18)'="N"
	 	.s lb=$p(tmpdisstr,"^",10)
	 	.s insutarid=$p(tmpdisstr,"^",4)
	 	.s TarItemInsuInfo=$g(^DHCINTIM(insutarid))
	 	.s InsuType=$p(tmpdisstr,"^",2)
	 	.s zfbl=$p(tmpdisstr,"^",15) //自付比例,有的项目可能没有返回
	 	.s bxje=$p(tmpdisstr,"^",16) //报销金额,有的项目可能没有返回
	 	.s zfjj=$p(tmpdisstr,"^",17) //自费金额,有的项目可能没有返回
	}else{
		//从对照表取数据
	 	q:$g(AdmReasonDr)="" "-1^DivFlag不为Y时,AdmReasonDr不能为空"
	 	q:$g(TarItmRowid)="" "-1^DivFlag不为Y时,TarItmRowid不能为空"
	 	q:$d(^DHCTARI(TarItmRowid))=0 "-1^收费表没有对应的数据"
	 	q:$d(^PAC("ADMREA",AdmReasonDr))=0 "-1^费别表没有对应的数据"
	 	s InsuTypeDesc=""
		s tmpdicinfo=##class(web.INSUDicDataCom).QueryByCode("AdmReasonDrToDLLType",AdmReasonDr)
		s InsuType=$p(tmpdicinfo,"^",6)
		q:InsuType="" "-1^未取到AdmReasonDr对应的医保类型"
		s InsuTypeDesc=$p(tmpdicinfo,"^",7)
	 	s TariInsuFlag=$p($$QueryByCode^DHCINSUDicData("TariInsuFlag",InsuType),"^",6)   //取收费项是否与其他收费项关联的标志  add by lilizhi 2013-03-05
	 	s TarItemInsuInfo=$$GetConInfo^DHCINSUTarContrast(TarItmRowid,InsuType,$zd(+$h,3),TariInsuFlag)
	 	q:TarItemInsuInfo="" "-1^收费表没有对应的数据"
		s zfbl=$p(TarItemInsuInfo,"^",18)					
		s lb=$p(TarItemInsuInfo,"^",23)						//甲,乙,非医保									
	}
	s xmlb=..RtnDicDescByDicCode(("AKA065"_InsuType),lb)
 	s tmpsflb=$p(TarItemInsuInfo,"^",1)
 	s sflb=..RtnDicDescByDicCode(("FeeType"_InsuType),tmpsflb)	//收费类别
 	s:zfbl="" zfbl=$p(TarItemInsuInfo,"^",18)	//如果医保中心没返回就取对照表数据
	s:$p(zfbl,".",1)="" zfbl="0"_zfbl
 	s OutStr=xmlb_"^"_zfbl_"^"_sflb_"^"_bxje_"^"_zfjj
	q OutStr
}

/// 根据费别和病种code获取慢病病种信息
/// Input：SkcCode:病种代码 ；AdmReasonDr：Pac_AdmReason
/// Output：成功：1^病种代码^病种描述 
/// 		失败：-1^失败原因
/// DingSH 20200309
/// w ##class(web.DHCINSUPort).GetSkcInfoByCode("N18.903","4")
ClassMethod GetSkcInfoByCode(SkcCode As %String, AdmReasonDr As %String) As %String
{
 	n (SkcCode, AdmReasonDr)
 	s OutStr=""
 	q:$g(SkcCode)="" "-1^病种代码不能为空"
 	q:$g(AdmReasonDr)="" "-1^费别不能为空"
    s tmpdicinfo=##class(web.INSUDicDataCom).QueryByCode("AdmReasonDrToDLLType",AdmReasonDr)
    s InsuType=$p(tmpdicinfo,"^",6)  ;通过AdmReasonDr获取医保类别
    q:InsuType="" "-1^根据费别："_AdmReasonDr_"，未取到对应医保类型"
    s tmpdicinfo=##class(web.INSUDicDataCom).QueryByCode("Skc516"_InsuType,SkcCode)
    s DiagCode="",DiagDesc=""
    s DiagCode=$p(tmpdicinfo,"^",3)
    s DiagDesc=$p(tmpdicinfo,"^",4)
	s OutStr="1^"_DiagCode_"^"_DiagDesc
	q OutStr
}

}
