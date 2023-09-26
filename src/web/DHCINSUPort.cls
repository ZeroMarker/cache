Import SQLUser

/// 名称:提供给其他产品组提供的各种接口
/// 描述: 
/// 编写者：刘书凤
/// 编写日期:2008 05 10 
Class web.DHCINSUPort Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 30;

/// 判断特病诊断是否可以开
/// 入参：AdmID   Paadm   的Rowid
///       AdmReasonID   Pac_Admreason 的RowID
///       DiagnosID     mrc_icddx     的RowID
/// 表：  DHC_DiagnosCat、DHC_DiagnosCatDetail
/// 出参：0     可以录此诊断
///      -2   没有办医保特病号
///      -1    不能录此诊断  */
ClassMethod CheckDiagnos(AdmID, AdmReasonID, DiagnosID) As %String
{
 n (AdmID, AdmReasonID, DiagnosID)
 s CheckDiagnos=-1,CheckTBFlag=-1,AdmInfoFlag=-1
 s AdmReasonDesc=$p(^PAC("ADMREA",AdmReasonID),"^",2)
 q:AdmReasonDesc'["特病" 0      //项目不同要修改
 s AdmInfo=##class(web.DHCINSUAdmInfoCtl).GetInfoByAdm(AdmID)
 i $p(AdmInfo,"!",1)="1" d
 .s TBCode=$p($p(AdmInfo,"!",2),"^",27) //XString1
 e  d
 .s TBCode=""
 q:TBCode="" -2    ;没有医保挂号
 s DCRowid=""
 f  s DCRowid=$o(^DHCDiagnosCatI("0","Diagose",DiagnosID,DCRowid)) q:DCRowid=""  d  //	
 .s DCCode=$p(^DHCDiagnosCat(DCRowid),"^",6)
 .s DCBillTypeDR=$p(^DHCDiagnosCat(DCRowid),"^",3)    //费别Rowid
 .i (AdmReasonID=DCBillTypeDR)&($ZCONVERT(DCCode,"U")=$ZCONVERT(TBCode,"U")) d
 ..s CheckDiagnos=0    ;可以录医嘱
 ;.i (AdmReasonID=DCBillTypeDR) d
 ;..s CheckTBFlag=0   ;是特病
 q CheckDiagnos
}

/// 医嘱项关联医保收费项信息
/// 入参： ArcimRowid：医嘱项的rowid; AdmReasonDr：病人就诊费别(paadm_admreason); HospDr：院区(CT_Hosptial),ExpStr:生效日期(yyyy-mm-dd)^
/// 出参：
/// 返回医保项的信息:
/// 		项目等级/结算属类(甲乙类等)^自付比例^备注^预留^预留^预留^ 预留^预留^医保类型(省医保市医保等)^医保目录编码^医保目录名称^国家目录编码^国家目录名称
/// w ##class(web.DHCINSUPort).ArcimLinkInsu("2||1", 2,2)
ClassMethod ArcimLinkInsu(ArcimRowid, AdmReasonDr, HospDr, ExpStr = "")
{
	n (ArcimRowid, AdmReasonDr,HospDr,ExpStr,%session)
	q:$g(ArcimRowid)="" "-1^医嘱项Dr不能为空"
	q:$g(AdmReasonDr)="" "-1^AdmReasonDr不能为空"
	q:$d(^PAC("ADMREA",AdmReasonDr))=0 "-1"
	s REANationalCode="",InsuType="",InsuTypeDesc=""
 	s REANationalCode=$p(^PAC("ADMREA",AdmReasonDr),"^",5)
 	s REAAdmSource=$p(^PAC("ADMREA",AdmReasonDr),"^",9)
	s tmpdicinfo=##class(web.INSUDicDataCom).QueryByCode("AdmReasonDrToTariType",AdmReasonDr,HospDr)
	s InsuType=$p(tmpdicinfo,"^",6)  ;通过AdmReasonDr判断目录类别
	q:InsuType="" ""
	s InsuTypeDesc=$p(tmpdicinfo,"^",7)
	s TariDr=""
	s ActDate=$P(ExpStr,"^",1)
	s:ActDate="" ActDate=$zd(+$H,3)
	;----------Zhan 20181114--------->
	;q:$d(^DHCOLT(0,"ARTTA",ArcimRowid))=0 "-2^医嘱项没有对应的收费项"	
	;s TariDr=$o(^DHCOLT(0,"ARTTA",ArcimRowid,TariDr))
	;q:$o(^DHCOLT(0,"ARTTA",ArcimRowid,TariDr))'="" "-3^医嘱项对应了多个收费项"
	;s DrugFlag=$$GetDrugFlagBy^DHCINSUFacade(ArcimRowid)
	;s DrugFlag=##class(web.DHCINSUPortUse).IsDrug(ArcimRowid,"")
#;	if (DrugFlag="1"){
#;	    s TariDr=##class(web.DHCINSUPortUse).GetTariDrByArcimRowid(ArcimRowid,"")
#;	    q:$l(TariDr,"^")>1 "-3^医嘱项对应了多个收费项" 
#;	}else{
#;		s TariDr=""
#;	    q:$d(^DHCOLT(0,"ARTTA",ArcimRowid))=0 "-2^医嘱项没有对应的收费项"	
#;	    s TariDr=$o(^DHCOLT(0,"ARTTA",ArcimRowid,TariDr))
#;	    q:$o(^DHCOLT(0,"ARTTA",ArcimRowid,TariDr))'="" "-3^医嘱项对应了多个收费项"
#;	}
	    s TariDr=##class(web.DHCINSUPortUse).GetTariDrByArcimRowid(ArcimRowid,"")  //修改 DingSH 20220505 
        q:$l(TariDr,"^")>1 "-3^医嘱项对应了多个收费项" 
	;//--------------------------------
	q:TariDr="" "-2^没有查到对应的收费项"
	s TariInsuFlag=$p($$QueryByCode^DHCINSUDicData("HISPROPerty"_InsuType,"TariInsuFlag",HospDr),"^",4)   //取收费项是否与其他收费项关联的标志  add by lilizhi 2013-03-05
	s TarItemInsuInfo=$$GetConInfo^DHCINSUTarContrast(TariDr,InsuType,ActDate,TariInsuFlag,HospDr)
	q:TarItemInsuInfo="" ""
	s INTIMbzjg=$p(TarItemInsuInfo,"^",15)				//基准价格
	s zfbl=$p(TarItemInsuInfo,"^",18)					
	s:zfbl'="" zfbl=+(zfbl*100)_"%"  					//自负比例
	s Demo=$p(TarItemInsuInfo,"^",22)
	s lb=$p(TarItemInsuInfo,"^",23)						//甲,乙,非医保									
	s xmlb=..RtnDicDescByDicCode(("chrgitm_lv"_InsuType),lb,HospDr)				//结算属类 AKA065 20220128 DingSH
	;s INTIMflzb1=$p(TarItemInsuInfo,"^",24)				//适用险种
	s INTIMtxbz=$p(TarItemInsuInfo,"^",6)				//特殊项标志（限制用药标志） Zhan 20170406
	s INTIMflzb2=$p(TarItemInsuInfo,"^",25)				//重症
	s INTIMflzb3=$p(TarItemInsuInfo,"^",26)				//门诊
	s INTIMflzb4=$p(TarItemInsuInfo,"^",27)				//重症说明
	s Cfg="",INTIMUnique="",INTIMyysmbm=""
	s INTIMxmbm=$p(TarItemInsuInfo,"^",3)			    //医保目录编码 -地方码 +DingSH 20211115
    s INTIMxmmc=$p(TarItemInsuInfo,"^",4)			    //医保目录名称 -地方码 +DingSH 20211115
    s Cfg=##class(web.DHCINSUPortUse).GetConfigByHospId(HospDr,"DHC_TarItem")
    //判定贯标码来源(收费项目表、医保目录表)
    i Cfg="INSU" d
    .s INTIMUnique=$p(TarItemInsuInfo,"^",43)			//国家医保编码         +DingSH 20211115
    .s INTIMyysmbm=$p(TarItemInsuInfo,"^",35)			//国家医保名称         +DingSH 20211224
    e  d
    .s StdInfo=##class(web.DHCINSUPortUse).GetStdInfoByDHCTarItemRowId(TariDr)
    .s INTIMUnique=$P(StdInfo,"^",1)
    .s INTIMyysmbm=$P(StdInfo,"^",2)

    ;q xmlb_"^"_zfbl_"^"_Demo_"^"_INTIMflzb1_"^"_INTIMflzb2_"^"_INTIMflzb3_"^"_INTIMflzb4_"^"_INTIMbzjg
    ;项目等级/结算属类^支付比例^备注^特殊项标志^   重症      ^   门诊        ^    重症说明  ^  基准价格
    ;Zhan 20170406 医生站只用到了第4个
    q xmlb_"^"_zfbl_"^"_Demo_"^"_INTIMtxbz_"^"_""_"^"_""_"^"_""_"^"_INTIMbzjg_"^"_InsuTypeDesc_"^"_INTIMxmbm_"^"_INTIMxmmc_"^"_INTIMUnique_"^"_INTIMyysmbm
}

/// 收费相关联医保收费项信息
/// 入参：TarItmId 收费的rowid; AdmReasonDr 病人就诊费别(paadm_admreason)  OEORIDR 医嘱ID   AdmRowid:登记表rowid   UnitPrice:单价
///       HospDr:院区(CT_Hosptial),ExpStr:"调用来源(RS:药房、物资、基础平台)^"
/// 出参：
/// 返回医保相关信息:项目等级/结算属类^自付比例^备注 ^^^^^基准价格^医保类型^医保目录编码^医保目录名称^国家医保编码
/// w ##class(web.DHCINSUPort).TarItmLinkInsu("5864","19","","","0",2)
/// w ##class(web.DHCINSUPort).TarItmLinkInsu("5401","19","","","0",2)
/// w ##class(web.DHCINSUPort).TarItmLinkInsu("2559","73","","","0",2)
/// w ##class(web.DHCINSUPort).TarItmLinkInsu("4401","","","","","2","RS^")
/// w ##class(web.DHCINSUPort).TarItmLinkInsu("2559","","","","","2","RS^")
/// 甲类^0^^^1^^^0
/// 尼莫地平片(尼莫同)[30mg x20片/盒]
/// outStr=乙类^.1^^^3,4,6,7,10^^补血^0
/// DingSH 修改 20211115 返回参数增加 医保目录编码^医保目录名称^国家医保编码^国家医保名称
///       与就诊业务有关的费别必传
/// 注意：与就诊业务无关的费别可为空，例如 药库、物资、基础数据平台组数据维护界面 扩展参数1位 调用来源：RS 固定 必传
ClassMethod TarItmLinkInsu(TarItmRowid, AdmReasonDr, OEORIDR, AdmRowid, UnitPrice, HospDr, ExpStr = "")
{
 	n (TarItmRowid, AdmReasonDr, OEORIDR, AdmRowid, UnitPrice,HospDr,ExpStr)
 	s SpecType="Y"
 	s OutStr=""
 	s:OEORIDR="" SpecType="N"  ;是否需要取特殊项目对照的关系
 	s RSFlag=$p(ExpStr,"^",1)
 	q:$g(TarItmRowid)="" "-1^收费Dr不能为空"
 	q:($g(AdmReasonDr)="")&(RSFlag="") "-1^AdmReasonDr和接口调用来源不能同时为空"
 	q:$d(^DHCTARI(TarItmRowid))=0 "-1^收费表没有对应的数据"
 	q:($g(AdmReasonDr)'="")&&($d(^PAC("ADMREA",AdmReasonDr))=0) ""
  	//s REANationalCode="",InsuType=""
 	//s REANationalCode=$p(^PAC("ADMREA",AdmReasonDr),"^",5)
 	//s REAAdmSource=$p(^PAC("ADMREA",AdmReasonDr),"^",9)
 	s tmpdicinfo=""
    s InsuType=""
 	s InsuTypeDesc=""
 	i $g(AdmReasonDr)'="" d
	.s tmpdicinfo=##class(web.INSUDicDataCom).QueryByCode("AdmReasonDrToTariType",AdmReasonDr,HospDr)
	.s InsuType=$p(tmpdicinfo,"^",6)  ;通过AdmReasonDr判断目录类别
	.s InsuTypeDesc=$p(tmpdicinfo,"^",7)
	
	//基数数据维护界面取医保目录贯标数据
	i RSFlag="RS"&&(InsuType="") d
	.s InsuType="00A"   //没上线国家版医保接口的要修改
	.s InsuTypeDesc="国家版医保"
	q:InsuType="" ""
	
 	;***************************
 	;add liusf 2008 10 18 特殊收费项目转换
 	;i SpecType="Y"  d
 	.;s ARCIMType=$p($g(^OEORD(+OEORIDR,"I",$p(OEORIDR,"||",2),"DHC")),"^",2)
 	.;s TarItmRowid=##class(web.DHCINSUTarConTar).QueryTarConId(TarItmRowid,ARCIMType)
 	;q:TarItmRowid="" ""
 	;***************************
 	//-------Zhan20201027 特殊收费项目转换-------------->
    s TariSpecialFlag=$p($$QueryByCode^DHCINSUDicData("HISPROPerty"_InsuType,"TariSpecialFlag",HospDr),"^",4) //是否启用特殊收费项目对照 +DingSH 20200828
    i (TariSpecialFlag="Y")&&(SpecType="Y") d
    .s ARCIMType=$p($g(^OEORD(+OEORIDR,"I",$p(OEORIDR,"||",2),"DHC")),"^",3)	;Zhan 20151119 OEORI_InsurCat_DR 医保类别指针医保适应症代码(医保组)
    .s tmpPBDTARIDR=##class(web.DHCINSUTarConTar).QueryTarConId(TarItmRowid, ARCIMType,HospDr) //+DingSH 20200828
    .i tmpPBDTARIDR'=""  d
    ..s TarItmRowid=tmpPBDTARIDR
 	//<--------------------------------------------------//
 	
 	s TariInsuFlag=$p($$QueryByCode^DHCINSUDicData("HISPROPerty"_InsuType,"TariInsuFlag",HospDr),"^",4)   //取收费项是否与其他收费项关联的标志  add by lilizhi 2013-03-05
 	s TarItemInsuInfo=$$GetConInfo^DHCINSUTarContrast(TarItmRowid,InsuType,$zd(+$h,3),TariInsuFlag,HospDr)
 	q:TarItemInsuInfo="" ""

 	
 	s INTIMbzjg=$p(TarItemInsuInfo,"^",15)				//基准价格
	s zfbl=$p(TarItemInsuInfo,"^",18)					
	;s:zfbl'="" zfbl=+(zfbl*100)_"%"  					//自负比例
	s Demo=$p(TarItemInsuInfo,"^",22)
	s lb=$p(TarItemInsuInfo,"^",23)						//甲,乙,非医保									
	s xmlb=..RtnDicDescByDicCode(("chrgitm_lv"_InsuType),lb,HospDr)
	s INTIMflzb1=$p(TarItemInsuInfo,"^",24)				//适用险种(根据医保类型区分)
	s INTIMflzb2=$p(TarItemInsuInfo,"^",25)				//重症 1~10		a代表所有
	s INTIMflzb2=..RtnDicCodeStrByDicBill1("Skc516"_InsuType,INTIMflzb2,HospDr)		//参照重慢病不限制收费项		
	s INTIMflzb3=$p(TarItemInsuInfo,"^",26)				//门诊
	s INTIMflzb4=$p(TarItemInsuInfo,"^",27)				//重症说明
    s INTIMbzjg=$p(TarItemInsuInfo,"^",15)				//标准价格
    s INTIMxmbm=$p(TarItemInsuInfo,"^",3)			    //医保目录编码 -地方码 +DingSH 20211115
    s INTIMxmmc=$p(TarItemInsuInfo,"^",4)			    //医保目录名称 -地方码 +DingSH 20211115

    s Cfg="",INTIMUnique="",INTIMyysmbm=""
    s Cfg=##class(web.DHCINSUPortUse).GetConfigByHospId(HospDr,"DHC_TarItem")
    i $zcvt(Cfg,"U")="INSU" d
    .s INTIMUnique=$p(TarItemInsuInfo,"^",43)			//国家医保编码         +DingSH 20211115
    .s INTIMyysmbm=$p(TarItemInsuInfo,"^",35)			//国家医保名称         +DingSH 20211224
    e  d
    .s StdInfo=##class(web.DHCINSUPortUse).GetStdInfoByDHCTarItemRowId(TarItmRowid)
    .s INTIMUnique=$P(StdInfo,"^",1)
    .s INTIMyysmbm=$P(StdInfo,"^",2)
 	;s OutpatCate=$p($g(^DHCTARI(TarItmRowid)),"^",14)
 	;s OutpatCateDesc=$P($g(^DHCTarC("IC",OutpatCate)),"^",2)
 	;s InsuCode=$p(TarItemInsuInfo,"^",4)
 	;s DrugSingle=$p(TarItemInsuInfo,"^",27)  //+liusf 2009 03 20  单味药标志
 	;s lx="",zfje=""
 	;s OutStr=lb_"^"_zfbl_"^"_Demo_"^"_lx_"^"_zfje_"^"_DrugSingle
 	;    项目等级   自付比例  备注     类型   自负金额     单味药标志
 	;项目等级/结算属类^支付比例 ^ 备注 ^    适用险种  ^   重症       ^   门诊       ^    重症说明  ^  基准价格
 	//s OutStr=xmlb_"^"_zfbl_"^"_Demo_"^^^^^^"_InsuTypeDesc   //"^"_INTIMflzb1_"^"_INTIMflzb2_"^"_INTIMflzb3_"^"_INTIMflzb4_"^"_INTIMbzjg
 	s OutStr=xmlb_"^"_zfbl_"^"_Demo_"^"_INTIMflzb1_"^"_INTIMflzb2_"^"_INTIMflzb3_"^"_INTIMflzb4_"^"_INTIMbzjg_"^"_InsuTypeDesc_"^"_INTIMxmbm_"^"_INTIMxmmc_"^"_INTIMUnique_"^"_INTIMyysmbm
	q OutStr
}

/// 根据收费项取医保目录信息
/// 20221129 DingSH
/// 入参说明：TarItmRowid：DHC_TarItem.Rowid ，InsuType：医保类型(例如 00A 国家版医保) ，ActDate：生效日期 （yyyy-mm-dd） 格式
///          HospDr:CT_Hospital.Rowid, ExpStr:扩展参数
/// 出参说明：rtnStr : "" 或 医保目录信息 或 小于零^错误信息
/// 医保目录信息格式:
///               01-05: 医保目录编码^医保目录名称^项目等级^自付比例^特殊项标志
///               06-10: 备注^收费大类代码^剂型^规格^单位
///               11-15: 批准文号^标准价格^实际价格^最高限价^医保目录表指针
///               16-20: 国家编码^国家名称^生效日期^失效日期^
/// w ##class(web.DHCINSUPort).GetInsuItemByTarDr("4905","00A",$zd(+$H,3),"2","")
ClassMethod GetInsuItemByTarDr(TarItmRowid, InsuType, ActDate, HospDr, ExpStr = "")
{
	s $zt="GetInsuItemByTarDrEx"
 	s TariInsuFlag=$p($$QueryByCode^DHCINSUDicData("HISPROPerty"_InsuType,"TariInsuFlag",HospDr),"^",4)   //取收费项是否与其他收费项关联的标志  add by lilizhi 2013-03-05
	s TarItemInsuInfo=$$GetConInsuInfo^DHCINSUTarContrast(TarItmRowid,InsuType,ActDate,TariInsuFlag,HospDr)
	q:TarItemInsuInfo="" ""
	s INTIMRowid = $p(TarItemInsuInfo,"^",1)
	s INTIMsfdlbm = $p(TarItemInsuInfo,"^",2)			 //收费大类代码
	s INTIMxmbm = $p(TarItemInsuInfo,"^",4)			     //医保目录编码 -地方码 +DingSH 20211115
    s INTIMxmmc = $p(TarItemInsuInfo,"^",5)			     //医保目录名称 -地方码 +DingSH 20211115
	s INTIMtxbz = $p(TarItemInsuInfo,"^",7)              //特殊项标志
	s INTIMjx = $p(TarItemInsuInfo,"^",9)			     //剂型
	s INTIMgg = $p(TarItemInsuInfo,"^",10)			     //规格
	s INTIMdw = $p(TarItemInsuInfo,"^",11)			     //单位
	s INTIMpzwh = $p(TarItemInsuInfo,"^",15)			 //批准文号
	s INTIMbzjg = $p(TarItemInsuInfo,"^",16)			 //标准价格
	s INTIMsjjg = $p(TarItemInsuInfo,"^",17)			 //实际价格
	s INTIMzgxj = $p(TarItemInsuInfo,"^",18)			 //最高限价
	s INTIMzfbl = $p(TarItemInsuInfo,"^",19)             //自付比例		
	;s:zfbl'="" zfbl=+(zfbl*100)_"%"  								
	s INTIMbz=$p(TarItemInsuInfo,"^",23)                // 备注
	s INTIMtjdm=$p(TarItemInsuInfo,"^",24)			    //项目等级  （甲,乙,丙等）							
	s INTIMtjdm=..RtnDicDescByDicCode(("chrgitm_lv"_InsuType),INTIMtjdm,HospDr)
	s INTIMActiveDate = $p(TarItemInsuInfo,"^",43)             //生效日期
	s INTIMExpiryDate = $p(TarItemInsuInfo,"^",45)             //失效日期
	//s INTIMflzb1=$p(TarItemInsuInfo,"^",25)				//适用险种(根据医保类型区分)
	//s INTIMflzb2=$p(TarItemInsuInfo,"^",26)				//重症 1~10		a代表所有
	//s INTIMflzb2=..RtnDicCodeStrByDicBill1("Skc516"_InsuType,INTIMflzb2,HospDr)		//参照重慢病不限制收费项		
	//s INTIMflzb3=$p(TarItemInsuInfo,"^",27)				//门诊
	//s INTIMflzb4=$p(TarItemInsuInfo,"^",28)				//重症说明
	//st 贯标国家码取值 
    s Cfg ="",NatItmCode ="",NatItmDesc =""
    s Cfg =##class(web.DHCINSUPortUse).GetConfigByHospId(HospDr,"DHC_TarItem")
    i Cfg = "INSU" d
    .s NatItmCode = $p(TarItemInsuInfo,"^",44)			//国家医保编码         +DingSH 20211115 INTIMUnique ??需根据项目修改
    .s NatItmDesc = $p(TarItemInsuInfo,"^",36)			//国家医保名称         +DingSH 20211224 INTIMyysmbm ??需根据项目修改
    e  d
    .s StdInfo=##class(web.DHCINSUPortUse).GetStdInfoByDHCTarItemRowId(TarItmRowid)
    .s NatItmCode=$P(StdInfo,"^",1)
    .s NatItmDesc=$P(StdInfo,"^",2)
	//ed 贯标国家码取值 
	;01-05 医保目录编码^医保目录名称^项目等级^自付比例^特殊项标志
    s rtnStr = INTIMxmbm_"^"_INTIMxmmc_"^"_INTIMtjdm_"^"_INTIMzfbl_"^"_INTIMtxbz
	;06-10 备注^收费大类代码^剂型^规格^单位
	s rtnStr = rtnStr_"^"_INTIMbz_"^"_INTIMsfdlbm_"^"_INTIMjx_"^"_INTIMgg_"^"_INTIMdw
	;11-15 批准文号^标准价格^实际价格^最高限价^医保目录表指针
	s rtnStr = rtnStr_"^"_INTIMpzwh_"^"_INTIMbzjg_"^"_INTIMsjjg_"^"_INTIMzgxj_"^"_INTIMRowid
	;16-20 国家编码^国家名称^生效日期^失效日期^
	s rtnStr = rtnStr_"^"_NatItmCode_"^"_NatItmDesc_"^"_INTIMActiveDate_"^"_INTIMExpiryDate

    q rtnStr
GetInsuItemByTarDrEx
   s $zt="" 
   q "-99^程序异常:"_$ze
}

/// Creator：      刘书凤
/// CreatDate：    2009 06 30
/// Description:   医嘱项关联医保收费项信息（用的特殊项目对照的时候）
/// Table：        
/// Input：        ArcimRowid：医嘱项的rowid; AdmReasonDr：病人就诊费别(paadm_admreason)
/// Output：       
/// Return：       HIS项目编码$c(1)HIS项目名称$c(1)项目类型$c(1)备注$c(1)项目类型描述$c(1)医保项目编码$c(1)医保项目名称$c(1)自付比例$c(1)最高限价，(多条用^分割)
/// Others：
///                 DingSH 20200812增加返回内容
/// w ##class(web.DHCINSUPort).ArcimLinkTarStr("5480||1",4,2)
ClassMethod ArcimLinkTarStr(ArcimRowid, AdmReasonDr, HospDr, langId = "")
{
	n (ArcimRowid, AdmReasonDr,HospDr,langId,%session)
	q:$g(ArcimRowid)="" "-1"
	q:$g(AdmReasonDr)="" "-1"
	q:$d(^PAC("ADMREA",AdmReasonDr))=0 "-1"
	//取REA_AdmSource 医保患者值为"1"
	;s InsuType=$p(^PAC("ADMREA",AdmReasonDr),"^",9) 
	//如果自费患者想按照某医保类型显示可按项目修改     
	//i InsuType="1"  d
	//.s InsuType="SZ"
	//s InsuType=$p(^PAC("ADMREA",AdmReasonDr),"^",6) 
	s InsuType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AdmReasonDrToTariType",AdmReasonDr,6,HospDr)
	q:InsuType="" "-1"
	s TariDr="",limitFlag=""  //yjy 2008.5.21
	;----------Zhan 20181114--------->
	//s DrugFlag=##class(web.DHCINSUPortUse).IsDrug(ArcimRowid,"")  // - 20221031 
	;s DrugFlag=$$GetDrugFlagBy^DHCINSUFacade(ArcimRowid)
	/*
	if (DrugFlag="1"){
	    s TariDr=##class(web.DHCINSUPortUse).GetTariDrByArcimRowid(ArcimRowid,"")
	    q:$l(TariDr,"^")>1 "-3^医嘱项对应了多个收费项" 
	}else{
		s TariDr=""
		q:$d(^DHCOLT(0,"ARTTA",ArcimRowid))=0 "-2"	
		s TariDr=$o(^DHCOLT(0,"ARTTA",ArcimRowid,TariDr))
		q:$o(^DHCOLT(0,"ARTTA",ArcimRowid,TariDr))'="" "-3"
	}
	q:$g(TariDr)="" "-2^没有对应的收费项"
	*/    // - 20221031 
	;q:$d(^DHCOLT(0,"ARTTA",Arcimrowid))=0 "-2"	
	;s TariDr=$o(^DHCOLT(0,"ARTTA",Arcimrowid,TariDr))
	;q:$o(^DHCOLT(0,"ARTTA",Arcimrowid,TariDr))'="" "-3"
	;--------------------------------
	s TariDrStr=##class(web.DHCINSUPortUse).GetTariDrByArcimRowid(ArcimRowid,"") //+ 20221031
	q:$g(TariDrStr)="" "-2^没有对应的收费项"
	s TariDrCnt=$l(TariDrStr,"^")
	s OutStr=""
	f TariDrIdx=1:1:TariDrCnt {
		s TariDr=$P(TariDrStr,"^",TariDrIdx)
		s TarConTarInfo=$$GetTarConTarInfo^DHCINSUTarItems(TariDr,InsuType,HospDr,langId)
		if OutStr=""{
	         s OutStr=TarConTarInfo
		}
		else{
			 s OutStr=OutStr_"^"_TarConTarInfo
		}
	}
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
ClassMethod AddINSUInfo(InString As %String) As %String
{
	n (InString)
	;s InString="ZH^X210316005^贝复舒凝胶(5g:21000iu)^cs^0^基本^8790"
	s TemInStr="^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
 	s InsuType=""
 	s Code=$p(InString,"^",2)
	s Desc=$p(InString,"^",3)
 	s xmrj=$p(InString,"^",4)
 	s xmlb=$p(InString,"^",5)
 	s ybdj=$p(InString,"^",6)
 	//q:(ybdj'="基本")&(ybdj'="控制")&(ybdj'="自费") -1     ;2009 07 05
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
	n (INADMRowidList,PAADM,InvPrtDr,INDivDr)
	
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

/// CheckLocInfo
/// Creator: 杨建章
/// Description:返回本地名单表中是否存在该凭证号码的患者
/// Input：YLZBH：医疗证编号(个人编号); HospDr:院区指针
/// CreatDate:2020100226
/// Others: w ##class(web.DHCINSUPort).CheckLocInfo("Q-0021")
ClassMethod CheckLocInfo(YLZBH As %String, HospDr As %String) As %String
{
	n (YLZBH,HospDr)
	s OutStr="-1"
	q:YLZBH="" OutStr
	s GroupHospDr=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId("DHC_INSULOCInfo",HospDr)  //+ DingSH 20200609
	s YLZBH=$ZCVT(YLZBH,"U")
	s Rowid="",Flag="N"
	f  s Rowid=$O(^DHCINLOC("0","YLZBH",YLZBH,Rowid)) q:(Rowid="")||(Flag="Y")  d
	.s tHospDr=$P(^DHCINLOC(Rowid),"^",49)
	.q:tHospDr'=GroupHospDr
	.s Flag="Y"
	.s OutStr=0
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
/// 		DicBill1Str：insu_dicdata表indid_DicBill1字段组串，HospDr:院区指针
/// CreatDate:2011-09-20
/// Others: 
/// Output: insu_dicdata表indid_DicCode 字段组串
/// 备注：
/// w ##class(web.DHCINSUPort).RtnDicCodeStrByDicBill1("Skc516WHA","1, 2, 3 ,4,5,6,7,8,9,10,a")
ClassMethod RtnDicCodeStrByDicBill1(DicType As %String, DicBill1Str As %String, HospDr As %String) As %String
{
	n (DicType,DicBill1Str,HospDr)
	s OutStr=""
	s DicCode=""
	q:DicBill1Str="" OutStr
	s DicStr=$$Query^DHCINSUDicData(DicType,DicCode,HospDr)
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
///             HospDr:院区指针
/// 注意点，如果字典代码对应描述为空(或 未配置),返回字典代码本身
/// CreatDate:2011-09-14
/// Others: w ##class(web.DHCINSUPort).RtnDicDescByDicCode("Skc516WHA","")
/// Output: insu_dicdata表indid_DicDesc字段，
/// 备注：内部调用，不对外公开
/// w ##class(web.DHCINSUPort).RtnDicDescByDicCode("Skc516WHA","")
ClassMethod RtnDicDescByDicCode(DicType As %String, DicCode As %String, HospDr As %String) As %String
{
	n (DicType,DicCode,HospDr,%session)
	s OutStr=""
	q:DicCode="" OutStr
	Set langid=""
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	s DicStr=$$Query^DHCINSUDicData(DicType,DicCode,HospDr)
	q:DicStr=0 OutStr
	q:DicStr="" OutStr
	s DicStr=^CacheTemp("INSUDic",$p(DicStr,"^",2),$p(DicStr,"^",1))
	s OutStr=$p(DicStr,"^",4)					;描述
	//汉字翻译成英文
	s OutStr=##class(web.DHCINSUPortUse).GetTransDesc("User.INSUDicData","INDIDDicDesc",langid,OutStr) //描述 20220726 DingSH 
	s:OutStr="" OutStr=DicCode
	q OutStr
}

/// w ##class(web.DHCINSUPort).GetLocInfoByYLZ("111000")
/// 通过医疗证号获取名单库信息(供建卡使用)
/// Rowid^^医疗证号^^^^身份证号^姓名^性别^^区别^类别^^^^^单位代码^0^单位名称^^^单位邮编^^^^2011-09-20^11:29:39^62351^0^^0^^AdmReasonDR^0^0^0^0^0^0^0^^^^^^^^^
ClassMethod GetLocInfoByYLZ(YLZ As %String, HospDr As %String) As %String
{
	n (YLZ,HospDr)
	s OutStr="-1"
	q:(YLZ="") OutStr
	s PatInsuCard=$o(^PAPERi("PAPER_PatName",YLZ,""))
	q:(PatInsuCard'="") "1"
	s GroupHospDr=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId("DHC_INSULOCInfo",HospDr)  //+ DingSH 20200609
	s LocInfoDr=""
	s tmpID=""
	f  s LocInfoDr=$o(^DHCINLOC("0","YLZBH",YLZ,LocInfoDr)) q:LocInfoDr=""   d
	.s XXLX=$p($g(^DHCINLOC(LocInfoDr)),"^",1)
	.q:(XXLX=4)
	.s tHospDr=$p($g(^DHCINLOC(LocInfoDr)),"^",1)
	.q:tHospDr'=GroupHospDr
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

/// w ##class(web.DHCINSUPort).SaveInsuAdmInfoSZ("")
/// 深圳：保存医保挂号信息
/// 入参：InfoStr=病人类型^门诊流水号^科室编码^科室编码^挂号类别（代码：普通、主治、主任、免收诊金）^挂号费^专家诊金^挂号合计！社保卡号加密串^社保流水号^就诊表rowid!医保支付明细
/// 出参：-1 保存失败   0成功(返回值与.net中返回值一样)
ClassMethod SaveInsuAdmInfoSZ(InfoStr)
{
	n (InfoStr)
	//s InfoStr="2^H2012011613432185^呼吸科门诊^HXKM-呼吸科门诊^^0^.1^.1!%GAWXFKKWKJUKFAWHHFHI?;07613226295319088187?^H2012011613432185^2978087!0105:0.1"
	s Flag="-1"
	s AdmInfoStr="^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^" ;44个
	s DivStr="^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^" ;47个
	s TmpAdmInfo=$p(InfoStr,"!",1)
	s TmpInsuInfo=$p(InfoStr,"!",2)
	s TmpDivInfo=$p(InfoStr,"!",3)

	q:(InfoStr="")||(TmpAdmInfo="")||(TmpInsuInfo="") Flag

	s $p(AdmInfoStr,"^",5)=$p(TmpAdmInfo,"^",1)  ;病人类型
	s $p(AdmInfoStr,"^",11)=$p(TmpAdmInfo,"^",2)  ;门诊流水号
	;s $p(AdmInfoStr,"^",10)=$p(TmpAdmInfo,"^",3)  ;科室编码
	s $p(AdmInfoStr,"^",16)=$p(TmpAdmInfo,"^",4)  ;科室编码
	s $p(AdmInfoStr,"^",15)=$p(TmpAdmInfo,"^",5)  ;挂号类别
	s $p(AdmInfoStr,"^",2)=$p(TmpInsuInfo,"^",3)  ;就诊表rowid
	s $p(AdmInfoStr,"^",35)=$p(TmpInsuInfo,"^",1) ;社保卡号加密串 
	s $p(AdmInfoStr,"^",12)="A"   ;ActiveFlag
	s $p(AdmInfoStr,"^",19)="SZOP"   ;ActiveFlag
	
	tstart 
	s inadmrowid=##class(web.DHCINSUAdmInfoCtl).Save(AdmInfoStr)
	q:inadmrowid<0 Flag

	s $p(DivStr,"^",40)=$p(TmpAdmInfo,"^",6)  ;挂号费
	s $p(DivStr,"^",41)=$p(TmpAdmInfo,"^",7)  ;专家诊金
	;s $p(DivStr,"^",41)=$p(TmpAdmInfo,"^",7)  ;专家合计
	s $p(DivStr,"^",2)=$p(TmpInsuInfo,"^",3)  ;就诊表rowid
	s $p(DivStr,"^",3)=inadmrowid  ;AdmInfoDr
	s $p(DivStr,"^",6)="I"
	s $p(DivStr,"^",46)=TmpDivInfo  ;Zstr10
	;s $p(DivStr,"^",19)=$p(TmpInsuInfo,"^",1)
	s $p(DivStr,"^",9)=$p(TmpInsuInfo,"^",2)
	
	s Len=$l(TmpDivInfo,"|")
	f i=1:1:Len  d
	.s TmpStr=$p(TmpDivInfo,"|",i)
	.s:$p(TmpStr,":",1)="0105" $p(DivStr,"^",33)=$p(TmpStr,":",2) ;InsuPay2
	.s:$p(TmpStr,":",1)="0101" $p(DivStr,"^",34)=$p(TmpStr,":",2)	;InsuPay3
	.s:$p(TmpStr,":",1)="0111" $p(DivStr,"^",23)=$p(TmpStr,":",2)	;sfrq00
	.s:$p(TmpStr,":",1)="03" $p(DivStr,"^",8)=$p(TmpStr,":",2)		;bcbxf0
	.s:$p(TmpStr,":",1)="02" $p(DivStr,"^",20)=$p(TmpStr,":",2)		;jjzfe0
	.s:$p(TmpStr,":",1)="01" $p(DivStr,"^",16)=$p(TmpStr,":",2)		;grzfe0
	.s:$p(TmpStr,":",1)="0201" $p(DivStr,"^",29)=$p(TmpStr,":",2)	;zhzfe0
	.s:$p(TmpStr,":",1)="0303" $p(DivStr,"^",44)=$p(TmpStr,":",2)	;Zstr08
	.s:$p(TmpStr,":",1)="0306" $p(DivStr,"^",45)=$p(TmpStr,":",2)	;Zstr09
	.s:$p(TmpStr,":",1)="0103" $p(DivStr,"^",42)=$p(TmpStr,":",2)	;Zstr06
	.s:$p(TmpStr,":",1)="0104" $p(DivStr,"^",43)=$p(TmpStr,":",2)	;Zstr07
	
	s rowid=##class(web.DHCINSUDivideCtl).InsertDivInfo(DivStr)

	i rowid>0 d      
    .tcommit		;提交
    .s Flag="0"_"^"_inadmrowid_"^1"_"!"_+$p(DivStr,"^",16)_$c(2)_"7!"_+$p(DivStr,"^",20)_$c(2)_$c(2)_"0!"_+$p(DivStr,"^",45)
    e  d    
    .trollback		;回滚
    
	q Flag
}

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
	.;q:+ActiveFlag=3
	.q:(ActiveFlag'="A")&&(ActiveFlag'="O") //+DingSH 20200828
	.s InsuCard=$p(^DHCINADM(adminfoid),"^",3)
	q InsuCard
}

/// 医嘱项关联医保收费项信息列表
/// ArcimRowid：医嘱项的rowid; AdmReasonDr：病人就诊费别(paadm_admreason);HospDr:院区指针,ExpStr:生效日期(yyyy-mm-dd)^
/// 返回医保项的信息      特检  9028||1     限制性提示  "15199||1"
/// 成功: 收费项目Rowid^收费项目代码^收费项目名称^价格^项目等级/结算属类(甲乙类等)^对照标识^自付比例^备注(限制信息)^特殊标志^预留(分类指标1)^医保目录编码^医保目录名称^国家目录编码^国家目录名称
/// 失败: -1(小于零)^错误信息
/// 注意多行数据,行数据用!分割,每个行数据的数据项用^分割
/// w ##class(web.DHCINSUPort).ArcimLinkInsuList("2||1", 4,2,"")
/// w ##class(web.DHCINSUPort).ArcimLinkInsuList("11813||1","4","2","2022-06-20")
ClassMethod ArcimLinkInsuList(ArcimRowid, AdmReasonDr, HospDr, ExpStr = "")
{
	n (ArcimRowid, AdmReasonDr,HospDr,ExpStr,%session)
	s InsuType="",OutStr="",OutStr1=""
	q:$g(ArcimRowid)="" "-1^医嘱项Dr不能为空"
	q:$g(AdmReasonDr)="" "-1^AdmReasonDr不能为空"
	q:$d(^PAC("ADMREA",AdmReasonDr))=0 "-1"
	s AdmReasonCode=$p(^PAC("ADMREA",AdmReasonDr),"^",1)
	s TmpOut=$$QueryByCode^DHCINSUDicData("AdmReasonDrToTariType",AdmReasonDr,HospDr)
	s InsuType=$p(TmpOut,"^",6)
	q:InsuType="" "-1^费别和医保目录没有对照"
	s TariDrStr=""
	s ActDate=$P(ExpStr,"^",1)
	s:ActDate="" ActDate=$zd(+$H,3)
	;----------Zhan 20181114--------->
	;q:$d(^DHCOLT(0,"ARTTA",ArcimRowid))=0 "-2^医嘱项没有对应的收费项"	
	;s TariDr=$o(^DHCOLT(0,"ARTTA",ArcimRowid,TariDr))
	;q:$o(^DHCOLT(0,"ARTTA",ArcimRowid,TariDr))'="" "-3^医嘱项对应了多个收费项"

	s TariDrStr=##class(web.DHCINSUPortUse).GetTariDrByArcimRowid(ArcimRowid,"")
	;//--------------------------------
	q:$g(TariDrStr)="" "-2^没有对应的收费项"
	
	s Cfg=##class(web.DHCINSUPortUse).GetConfigByHospId(HospDr,"DHC_TarItem")
	b ;TariDrStr
    f Num=1:1:$l(TariDrStr,"^")  d
    .s TariDr=$p(TariDrStr,"^",Num)
	.s TarString=$$GetTarDetail^DHCINSUTarContrast(TariDr,HospDr)	//upt 20220623
	.s TariCode=$p(TarString,"^",2)
	.s TariDesc=$p(TarString,"^",3)
	.s Price=$fn($p(TarString,"^",7),"",4)
	.s TariInsuFlag=$p($$QueryByCode^DHCINSUDicData("HISPROPerty"_InsuType,"TariInsuFlag",HospDr),"^",4)   //取收费项是否与其他收费项关联的标志  add by lilizhi 2013-03-05
	.s TarItemInsuInfo=$$GetConInfo^DHCINSUTarContrast(TariDr,InsuType,ActDate,TariInsuFlag,HospDr)
	.s ContrastFlag="Y"
	.s:TarItemInsuInfo="" ContrastFlag="N"
	.s txbz=$p(TarItemInsuInfo,"^",6)
	.s zfbl=$p(TarItemInsuInfo,"^",18)
	.s:zfbl'="" zfbl=+(zfbl*100)_"%"  			//自负比例
	.s Demo=$p(TarItemInsuInfo,"^",22)
	.s lb=$p(TarItemInsuInfo,"^",23)						//甲,乙,非医保	
	.//S SysCode="AKA065"_InsuType								
	.//s xmlb=..RtnDicDescByDicCode(SysCode,lb,HospDr)				//结算属类
	.//s xmlb=..RtnDicDescByDicCode(("chrgitm_lv"_InsuType),lb,HospDr)				//结算属类 AKA065 20220128 DingSH
	.s flzb1=$p(TarItemInsuInfo,"^",25)         //特检特治标志
	.s:flzb1'="1" flzb1="0"
	.s InsuClass=$p(TarItemInsuInfo,"^",23)
    .//s:((InsuClass'="甲类")&(InsuClass'="乙类")) InsuClass="自费"
    .s InsuClass=..RtnDicDescByDicCode(("chrgitm_lv"_InsuType),InsuClass,HospDr)				//结算属类 AKA065 20220128 DingSH
    .s:InsuClass="自费" zfbl="100%"
    .;       收费项目代码 收费项目名称  项目等级   支付比例  备注 特殊标志  特检特治标志
    .s xmbm=$p(TarItemInsuInfo,"^",3)			    //医保目录编码 -地方码 +DingSH 20211115
    .s xmmc=$p(TarItemInsuInfo,"^",4)			    //医保目录名称 -地方码 +DingSH 20211115
    .s unique="",yysmbm=""
    .i ContrastFlag'="N" d
    ..//判定贯标码来源(收费项目表、医保目录表)
    ..i Cfg="INSU" d
    ...s unique=$p(TarItemInsuInfo,"^",43)			//国家医保编码         +DingSH 20211115
    ...s yysmbm=$p(TarItemInsuInfo,"^",35)			//国家医保名称         +DingSH 20211224
    ..e  d
    ...s StdInfo=##class(web.DHCINSUPortUse).GetStdInfoByDHCTarItemRowId(TariDr)
    ...s unique=$P(StdInfo,"^",1)
    ...s yysmbm=$P(StdInfo,"^",2)
    .s tmpOutStr=TariDr_"^"_TariCode_"^"_TariDesc_"^"_Price_"^"_ContrastFlag_"^"_InsuClass_"^"_zfbl_"^"_Demo_"^"_txbz_"^"_flzb1_"^"_xmbm_"^"_xmmc_"^"_unique_"^"_yysmbm
    .b ;klll
	.i OutStr1="" d
    ..s OutStr1=tmpOutStr
    .e  d
    ..s OutStr1=OutStr1_"!"_tmpOutStr
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
/// w ##class(web.DHCINSUPort).GetCNCODE("aaa",3,"")
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
ClassMethod GetArcimStrByInsuCon(ArcimDr As %String) As %String
{
	n (ArcimDr)
	s ArcimStr=""
	q:ArcimDr="" ""
	;s DrugFlag=$$GetDrugFlagBy^DHCINSUFacade(ArcimDr)
	s DrugFlag=##class(web.DHCINSUPortUse).IsDrug(ArcimDr,"")
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
/// 返回:   失败：+rtn<0
///         成功:
/// 		1!Rowid^就诊号^医疗保险号^医保卡号^人员类别(在职、退休、离休等代码)^IC卡状态^单位^参保地区^所属分中心^个人帐户余额^医保就诊流水号(11)^
/// 		有效标志(A:有效,B:被作废,S:作废,O:出院)^入院日期^入院时间^入院类别（医疗类别）^就诊科室名称^入院登记人Dr^住院次数^医保类别(省市医保比如：“AH”、“SYA“)^冲销流水号^出院日期(20)^
/// 		出院时间^出院操作员^操作员指针^操作日期^操作时间^预留串^预留串^预留串^预留串^预留串^
/// 		预留串^预留串^预留串^预留串^预留串^预留串^预留串^预留串^预留串^预留串^
/// 		预留串^预留串^预留串^预留串^预留串^预留串^预留串^预留串^预留串^异地结算标志
/// 其它说明：HanZH 20220607 增加YDFlag:异地结算标志 参考自事前-事中明细审核分析服务
/// w ##class(web.DHCINSUPort).GetInsuAdmInfoByAdmDr(1529)
ClassMethod GetInsuAdmInfoByAdmDr(PAADMDr) As %String
{
	n (PAADMDr)
    s AdmInfo=##class(web.DHCINSUAdmInfoCtl).GetInfoByAdm(PAADMDr)
    q:+AdmInfo<0 AdmInfo
    s ActFlag=$p(AdmInfo,"^",12)	
    q:(ActFlag'="A")&&(ActFlag'="O") "-1"
	s InsuAdmStates=$p(AdmInfo,"^",8)		
	s InsuAdmCenter=$p(AdmInfo,"^",9)
	s InsuType=$p(AdmInfo,"^",19)
	s HospDr = ##class(web.UDHCHospitalGroup).GetHospitalByAdm(PAADMDr)
	;以下字段如需转成汉字显示，请再调用..RtnDicDescByDicCode("OrganizationCodeCCA",$p(AdmInfo,"^",8))函数。
	s $p(AdmInfo,"^",8)=..RtnDicDescByDicCode("YAB003"_InsuType,$p(AdmInfo,"^",8),HospDr)		;统筹区
	s $p(AdmInfo,"^",9)=..RtnDicDescByDicCode("YAB003"_InsuType,$p(AdmInfo,"^",9),HospDr)		;分中心
	s $p(AdmInfo,"^",5)=..RtnDicDescByDicCode("AKC021"_InsuType,$p(AdmInfo,"^",5),HospDr)		;参保人员类别
	s $p(AdmInfo,"^",15)=..RtnDicDescByDicCode("AKA130"_InsuType,$p(AdmInfo,"^",15),HospDr)		;参保就诊类别
	;字段详情请参考表结构文档
	s OutStr=AdmInfo
	//st add 20220602 明细审核分析提供给医生站异地标志
	s INADMStates=$p(AdmInfo,"^",7)
	s HospDr = $P(^PAADM(PAADMDr,2),"^",85) ;//PAADMHospitalDR
	i HospDr ="" d
	.s DepCodeDR = ""
	.s DepCodeDR = $P(^PAADM(PAADMDr),"^",4)
	.s:DepCodeDR'="" HospDr=$P(^CTLOC(DepCodeDR),"^",22)
	
	s YDFlag="0"
	i ($e(INADMStates,1,2)'=$e(InsuAdmCenter,1,2)) d
    .s YDFlag="1"
    e  d
    .s InsuCenterNo=$e(##class(web.INSUDicDataCom).GetDicByCodeAndInd("HISPROPerty"_InsuType,"InsuCenterNo",4,HospDr),1,4)
    ..i $e(INADMStates,1,4)'=InsuCenterNo d
    ..i $e(INADMStates,1,4)=InsuCenterNo d
    ...i $e(##class(web.INSUDicDataCom).GetDicByCodeAndInd("HISPROPerty"_InsuType,"InsuHospCode",4,HospDr),2,5)'=$e(InsuAdmCenter,1,4) d
    ....s YDFlag="1"
    ..e  d
    ... i ($e(INADMStates,1,4)'=$e(InsuAdmCenter,1,4)) d
    ....s YDFlag="1"
    s OutStr=OutStr_"^"_YDFlag
	//ed add 20220602
	
	q OutStr
}

/// PBDLinkInsu
/// Creator: zhangdongliang 
/// Description:返回医保费用上传后返回的自费和自付部分
/// Input：PBDr：DHC_PatBillDetails表Rowid
/// CreatDate:2013-08-08
/// Others: w ##class(web.DHCINSUPort).PBDLinkInsu("4123||1||1")
/// Output: 自付比例^自费金额^报销金额^医保目录编码^医保目录名称^国家医保编码
ClassMethod PBDLinkInsu(PBDDr) As %String
{
	n (PBDDr)
	q:(PBDDr="") -1
	q:('$d(^DHCINDIS("0","PBDDr",PBDDr))) -1
	s DivSubId="", Qry=0, Amount=0, Scale=0, Fund=0, Self=0,INSUCode="",INSUDesc="",MedListCodg=""
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
    .s INSUCode=$p(DivSubInfo,"^",8)     ;医保项目编码
    .s INSUDesc=$p(DivSubInfo,"^",9)     ;医保项目名称(国家码)
    .s MedListCodg=$p(INSUCode,"-",1)    ;医疗目录编码
	s SelFee=Scale_"^"_Self_"^"_Fund_"^"_INSUCode_"^"_INSUDesc_"^"_MedListCodg
	q SelFee
}

/// add by zhangdongliang at 2014-09-02 for 门诊住院数据校验
/// 入参Desc:
/// InvPrtDr:		    门诊传InvPrtDr，PBDr=""，不可同时传
/// 	PBDr:			住院传PBDr，不传InvPrtDr=""，不可同时传
/// 	JustThread；	卡支付集中打印发票 的进程号
/// 	CPPFlag:		为卡支付集中打印发票是否标志，是的情况：InvPrtDr=""、PBDr=""、CPPFlag="CPP"；非则CPPFlag=""
/// 	DivFlag:		校验结算业务数据传"N",校验退费业务数据传"S",默认""时校验正数据;集中打印发票无退费业务，退费时调用门诊退费。
///     ExpStr          扩展串 s DivMod=$P(ExpStr,"^",1),F:收费,R:挂号,P:体检  20220718 
/// 出参：
/// 			Y!BackString 	Y代表医保有此数据，校验无误 	BackString为对应业务成功后，医保函数返回串。  
/// 			或N				N代表校验无此数据，计费需回滚	
/// 备注		BackString对应含义：
/// 								校验门诊结算,BackString=医保门诊结算函数返回串
/// 								校验住院结算,BackString=医保住院结算函数返回串
/// 								校验"卡支付集中打印发票,BackString=""
/// w ##class(web.DHCINSUPort).CheckINSUDivFlag("8084","","","","N")
/// w ##class(web.DHCINSUPort).CheckINSUDivFlag("230999","","","","S")
/// w ##class(web.DHCINSUPort).CheckINSUDivFlag("","244585","","N","N")
/// w ##class(web.DHCINSUPort).CheckINSUDivFlag("","","123","CPP","N")
/// w ##class(web.DHCINSUPort).CheckINSUDivFlag("","","123","","N","P")： 体检 最后一个入参必填
ClassMethod CheckINSUDivFlag(InvPrtDr As %String, PBDr As %String, JustThread As %String, CPPFlag As %String, DivFlag As %String, ExpStr As %String = "") As %String
{
	
	n (InvPrtDr,PBDr,JustThread,CPPFlag,DivFlag, ExpStr)
	s OutStr="N"
	i (CPPFlag="CPP")  d
	.s OutStr=..CheckINSUOPDivFlagCPP(JustThread)
	e  i ((InvPrtDr'="")&&($d(^DHCINDIV("0","DHCInvPrt",InvPrtDr)))) d
	.s OutStr=..CheckINSUOPDivFlag(InvPrtDr,DivFlag,ExpStr)
	e  i ((PBDr'="")&&($d(^DHCINDIV("0","DHCPB",PBDr))))  d
	.s OutStr=..CheckINSUIPDivFlag(PBDr,DivFlag)
	q OutStr
}

/// 内部调用，不对外公布
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
/// s DivMod=$P(ExpStr,"^",1),F:收费,R:挂号,P:体检
ClassMethod CheckINSUOPDivFlag(InvPrtDr As %String, DivFlag As %String, ExpStr As %String = "") As %String
{
	n (InvPrtDr,DivFlag,ExpStr)
	s OutStr="N"
	s BackString=""
	q:(+InvPrtDr=0) OutStr
	q:('$d(^DHCINDIV("0","DHCInvPrt",InvPrtDr))) OutStr
	s DivDr=""
	;add by zhangdongliang 2015-10-16 for 挂号发票信息退出。
	s PrtInfo=$g(^DHCINVPRT(InvPrtDr))
	s DivMod=$P(ExpStr,"^",1)          //+DingSH 20220718 
	s PrtFairType=$p(PrtInfo,"^",34)
	q:PrtFairType="R" "N"
	;end
	f  s DivDr=$o(^DHCINDIV("0","DHCInvPrt",InvPrtDr,DivDr),-1) q:DivDr=""  d
	.s DivInfo=$g(^DHCINDIV(DivDr))			;70个字段
	.s AdmInfoDr=$p(DivInfo,"^",2)			
	.s Flag=$p(DivInfo,"^",5)
	.q:(DivFlag'="S")&&(Flag'="I")
	.q:(DivFlag="S")&&((Flag'="S")&&(Flag'="D"))
	.s TmpDivMod=$p(DivInfo,"^",36)				
	.q:(DivMod'="")&&(DivMod'=TmpDivMod)        //+DingSH 20220718 
	.;s AdmInfo=$g(^DHCINADM(AdmInfoDr))		;50个字段
	.s INPAYbcbxf0=$p(DivInfo,"^",7)			;医保总费用
	.s INPAYgrzfe0=$p(DivInfo,"^",15)		;医保现金
	.s INPAYzhzfe0=$p(DivInfo,"^",28)		;医保账户支付
	.;s INPAYjjzfe0=INPAYbcbxf0-INPAYgrzfe0-INPAYzhzfe0	;$p(DivInfo,"^",19)		;除现金、医保账户支付外医保统筹总支付
	.s INPAYjjzfe0=$fn($p(DivInfo,"^",19),"",2)
	.s INPAYInsuPay10=$p(DivInfo,"^",50)		;医保误差值 
	.s INPAYbcbxf0=$fn(INPAYbcbxf0+INPAYInsuPay10,"",2)	;总金额考虑医保误差值
	.s INPAYgrzfe0=$fn(INPAYgrzfe0+INPAYInsuPay10,"",2)	;现金考虑医保误差值
	
	.s TCPayModeDr="6"			;医保统筹支付方式Dr
	.;s ZHPayModeDr=""			;医保账户支付方式Dr	
	.;拼门诊结算返回串            
    .s BackString = "0"_"^"_DivDr_"^"_INPAYgrzfe0_"^"_InvPrtDr_$c(2)_TCPayModeDr_"^"_INPAYjjzfe0		;_$c(2)_ZHPayModeDr_"^"_INPAYzhzfe0	
    .//s rtn=..GetDivBackStrByRowid(DivDr,"","O") 
    .//s BackString=$P(rtn,"!",2)
	s:BackString'="" OutStr="Y"_"!"_BackString
	q OutStr
}

/// 内部方法，不对外公布
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
	s HospDr=##class(web.DHCINSUBase).GetHOSPID(JustThread,"JustThread" ) //+ DingSH 20200609
	;取支付方式rowid
	;s PayModeStr=##class(web.DHCINSUFacade).GetPayModeDr()	;Cash_"^"_INSU1
	s PayModeStr=..GetPayModeDr()	;Cash_"^"_INSU1
    f  s AdmReasonId=$o(^DHCTMPACCColPRT("IP",JustThread,AdmReasonId))     q:AdmReasonId=""    d
    .s DicInsuType=$p($$QueryByCode^DHCINSUDicData("AdmReasonDrToDLLType",AdmReasonId,HospDr),"^",6)
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
/// 			成功：交易流水号^个人编号^医保卡号^医保结算日期^医保结算时间^收费日期^操作人员^医保险种^参保地^医保类别^就诊类型^医疗类别^中途结算标志^总费用^个人支付额^基金支付额^个人账户支付额 ^统筹支付^大额医疗补助^公务员补助^医疗救助(民政救助(专项救助))^补充医疗保险基金支出/离休统筹^大病补充医疗保险/单位补充医疗^其他基金支出/公务员大病医疗补充部分^保健对象支付^医院负担金额/医院垫付(单病种垫付)^HIS总费用与医保返回数据的误差^医保内金额^医保外金额^个人自付一^个人自付二^自费金额^是否特殊病种^单病种编码^单病种定额^单病种名称^限价标志^限价类别^限价病种^定额差
///             成功：交易流水号^个人编号^医保卡号^医保结算日期^医保结算时间-5^收费日期^操作人员^医保险种^参保地^医保类别-10^就诊类型^医疗类别^中途结算标志^总费用^个人现金支付额(psn_cash_pay)-15^基金支付总额 (fund_pay_sumamt )^帐户支付额(acct_pay)^基本医疗统筹基金支出(hifp_pay)^大额医疗补助基金支出（hifob_pay）^公务员医疗补助基金支出(cvlserv_pay)-20^医疗救助基金支出(maf_pay)^大病补充医疗保险基金支出（hifmi_pay ）^大病补充医疗保险基金支出(hifmi_pay)^ 其他基金支出(oth_pay)^ 伤残人员医疗保障基金支出(hifdm_pay)-25^医院负担金额（hosp_part_amt）^HIS总费用与医保返回数据的误差^ 符合政策范围金额（inscp_scp_amt）^政策范围外金额/自费金额 (包括超限价自费费用,fulamt_ownpay_amt+overlmt_selfpay)^个人负担总金额(psn_part_amt)-30^先行自付金额(preselfpay_amt)^全自费金额(fulamt_ownpay_amt)^是否特殊病种^单病种编码^单病种定额-35^单病种名称^限价标志^限价类别^限价病种^定额差-40^overlmt_selfpay超限价自费费用
ClassMethod GetDivideInfoForBI(INDIVID As %String = "", PAADM As %String = "", PRTID As %String = "", BILLNO As %String = "", PRTFLAG As %String = "") As %String
{
	n (INDIVID,PAADM,PRTID,BILLNO,PRTFLAG)
	q:(INDIVID="")&&(PAADM="")&&(PRTID="")&&(BILLNO="") "-1"
	s:PRTFLAG="" PRTFLAG="N"
	
	s RtnStr="-1"
	s (DivStr,Adminfo)=""
	i (INDIVID="")&&(PRTID'="") d	//一般是门诊数据
	.i ($d(^DHCINDIV("0","DHCInvPrt",PRTID))=0)&&($d(^DHCINVPRT(PRTID))) d
	..s tmpPRTID=$p(^DHCINVPRT(PRTID),"^",13)
	..s:tmpPRTID'="" PRTID=tmpPRTID,PRTFLAG="S"	;说明是负发票
	.q:$d(^DHCINDIV("0","DHCInvPrt",PRTID))=0
	.s tmpdivId=""
	.f  s tmpdivId=$O(^DHCINDIV("0","DHCInvPrt",PRTID,tmpdivId),-1) q:(tmpdivId="")||(INDIVID'="")  d
	..q:($p(^DHCINDIV(tmpdivId),"^",5)'=PRTFLAG)&&(PRTFLAG'="")
	..s INDIVID=tmpdivId
	i (INDIVID="")&&(BILLNO'="") d	//一般是住院数据
	.i $d(^DHCINDIV("0","DHCPB",BILLNO))=0 d
	..q:$d(^DHCPB(BILLNO))=0
	..s tmpPAADM=$p(^DHCPB(BILLNO),"^",1)
	..s tmpBILLNO=""
	..f  s tmpBILLNO=$o(^DHCPB(0,"ADM",tmpPAADM,tmpBILLNO)) q:tmpBILLNO=""  d
	...q:tmpBILLNO'=BILLNO
	...s OriginalBill=$p(^DHCPB(BILLNO),"^",18)
	...s:OriginalBill'="" BILLNO=OriginalBill,PRTFLAG="S" ;说明是负账单
	.q:$d(^DHCINDIV("0","DHCPB",BILLNO))=0
	.s tmpdivId=""
	.f  s tmpdivId=$O(^DHCINDIV("0","DHCPB",BILLNO,tmpdivId),-1) q:(tmpdivId="")||(INDIVID'="")  d
	..q:($p(^DHCINDIV(tmpdivId),"^",5)'=PRTFLAG)&&(PRTFLAG'="")
	..s INDIVID=tmpdivId
	i (INDIVID="")&&(PAADM'="") d	//取挂号时的结算数据
	.q:$d(^DHCINDIV("0","Paadm",PAADM))=0
	.s tmpdivId=""
	.f  s tmpdivId=$O(^DHCINDIV("0","Paadm",PAADM,tmpdivId),-1) q:(tmpdivId="")||(INDIVID'="")  d
	..q:($p(^DHCINDIV(tmpdivId),"^",5)'=PRTFLAG)&&(PRTFLAG'="")
	..q:$p(^DHCINDIV(tmpdivId),"^",36)'="R"
	..s INDIVID=tmpdivId
	s pls=1
	i INDIVID'="" d
	.//给返回值赋初始值，BI要求字段没有数据要返回Null
	.s RtnStr="Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null^Null"
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
	.s $p(RtnStr,"^",13)=$p(DivStr,"^",38)	//中途结算标志 （Zstr02）
	.s:(PRTFLAG="S")&&(+$p(DivStr,"^",8)>0) pls=-1
	.s $p(RtnStr,"^",14)=+$p(DivStr,"^",8)*pls	//总费用     
	.s $p(RtnStr,"^",15)=+$p(DivStr,"^",16)*pls	//个人支付额   psn_cash_pay 个人现金支付额
	.s $p(RtnStr,"^",16)=+$p(DivStr,"^",20)*pls //-$p(DivStr,"^",29) fund_pay_sumamt 基金支付总额
	.s $p(RtnStr,"^",17)=+$p(DivStr,"^",29)*pls	//个人账户支付额  acct_pay 帐户支付额
	.s $p(RtnStr,"^",18)=+$p(DivStr,"^",32)*pls	//基本统筹支付 hifp_pay 基本医疗统筹基金支出
	.s $p(RtnStr,"^",19)=+$p(DivStr,"^",33)*pls	//大病支付 hifob_pay 大额医疗补助基金支出
	.s $p(RtnStr,"^",20)=+$p(DivStr,"^",34)*pls	//公务员补助 cvlserv_pay 公务员医疗补助基金支出
	.s $p(RtnStr,"^",21)=+$p(DivStr,"^",35)*pls	//民政救助(专项救助) maf_pay  医疗救助基金支出
	.s $p(RtnStr,"^",22)=+$p(DivStr,"^",36)*pls	//补充医疗保险基金 hifes_pay 补充医疗保险基金支出
	.s $p(RtnStr,"^",23)=+$p(DivStr,"^",47)*pls	//大病补充保险基金 hifmi_pay 大病补充医疗保险基金支出
	.s $p(RtnStr,"^",24)=+$p(DivStr,"^",48)*pls	//其他基金  oth_pay 其他基金支出
	.s $p(RtnStr,"^",25)=$p(DivStr,"^",49)*pls	// hifdm_pay 伤残人员医疗保障基金支出??
	.s $p(RtnStr,"^",26)=+$p(DivStr,"^",50)*pls	//医院垫付(单病种垫付) hosp_part_amt 医院负担金额
	.s $p(RtnStr,"^",27)=+$p(DivStr,"^",51)*pls	//HIS总费用与医保返回数据的误差
	.s $p(RtnStr,"^",28)=+$p(DivStr,"^",67)*pls	//医保内金额-复核范围金额   （Zstr26）inscp_scp_amt 符合政策范围金额
	.s $p(RtnStr,"^",29)=+($p(DivStr,"^",53)+$p(DivStr,"^",55))*pls	//医保外金额-全自费金额 自费金额 (包括超限价自费费用)
	.s $p(RtnStr,"^",30)=+$p(DivStr,"^",63)*pls	//个人自付一，个人负担总金额 （ Zstr22） psn_part_amt  个人负担总金额
	.s $p(RtnStr,"^",31)=+$p(DivStr,"^",54)*pls	//个人自付二，先行自付金额   （Zstr13）  preselfpay_amt 先行自付金额
	.s $p(RtnStr,"^",32)=+$p(DivStr,"^",53)*pls	//自费金额  (Zstr12) fulamt_ownpay_amt       ' 全自费金额
	.// 是否特殊病种-33^单病种编码^单病种定额^单病种名称^限价标志^限价类别^限价病种^定额差-40
	.s $p(RtnStr,"^",41)=+$p(DivStr,"^",55)*pls	//超限价自费费用  (Zstr14)：overlmt_selfpay 超限价自费费用。 + DingSH 20220517 
	

   
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
/// Others: w ##class(web.DHCINSUPort).GetInsuUpFlag("14686","")
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
    .q:(tmpFlag'="N")       ;2010 08 20 liusf   原来是"I"
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
    s $ZTrap=""	
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
    s $ZTrap=""	
	q "-1!"_$ze
}

/// Description:返回发票打印所需数据
/// Input:InvPrtid:DHCINVPrt.Rowid; BillDr:DHC_PatientBill.Rowid; InvDivId:InsuDivide.rowid;ExpStr:挂号结算(有就诊记录结算记录)标识^体检结算标识^^
/// Creator:  DingSH
/// CreatDate:2020-12-23
/// ModifyDate 2022-05-16
/// Output:
/// 成功时返回: 0^医保个人编号^医保类型^医保结算总金额^基本医疗统筹基金支出-5^其他支付总额^个人账户支付^个人现金支付^个人自付^个人自费(包括 超限价自费费用)-10^医保报销总金额^个人支付总额^大额医疗补助基金支出^公务员医疗补助基金支出^医疗救助基金支出-15^大病补充医疗保险基金支出^其他基金支出^伤残人员医疗保障基金支出^医院负担金额^超限价自费费用-20
/// 失败时返回:-1^错误信息
/// 注意，很重要 医保其他支付、个人自付和个人自费 根据项目和医保类型进行调整
/// Others: w ##class(web.DHCINSUPort).GetDivInfoForINV(4566,"","","")
/// Others: w ##class(web.DHCINSUPort).GetDivInfoForINV(4699,"","","")
/// Others: w ##class(web.DHCINSUPort).GetDivInfoForINV("","14008","","")
/// Others: w ##class(web.DHCINSUPort).GetDivInfoForINV("","","572","")
/// Others: w ##class(web.DHCINSUPort).GetDivInfoForINV("","4800","","")
/// Others: w ##class(web.DHCINSUPort).GetDivInfoForINV("3266","","","")
ClassMethod GetDivInfoForINV(prtDr As %String = "", BillDr As %String = "", InvDivId As %String = "", ExpStr As %String = "") As %String
{
	
	q:(prtDr="")&&(BillDr="")&&(InvDivId="") "-1^发票Dr,账单号,医保结算表Dr不能同时为空"
	q:(prtDr'="")&&('$d(^DHCINDIV("0","DHCInvPrt",prtDr))) "-1^没有prtDr="_prtDr_"对应的医保结算记录"
	q:(BillDr'="")&&('$d(^DHCINDIV("0","DHCPB",BillDr))) "-1^没有BillDr="_BillDr_"对应的医保结算记录"
	q:(InvDivId'="")&&('$d(^DHCINDIV(InvDivId))) "-1^没有InvDivId="_InvDivId_"对应的医保结算记录"
	s Flag=0,DivDr=""
	if (prtDr'="")
	{
	  s DivDr=$o(^DHCINDIV("0","DHCInvPrt",prtDr,DivDr),-1)
	  s Flag=1
	}
	if (BillDr'="")&&(+Flag=0)
	{
	  s DivDr=$o(^DHCINDIV("0","DHCPB",BillDr,DivDr),-1)
	  s Flag=1
	}
	
	if (InvDivId'="")&&(+Flag=0)
	{
	  s DivDr=InvDivId
	  s Flag=1
	}

	s DivInfo=$g(^DHCINDIV(DivDr))
	s AdmInfoDr=$p(DivInfo,"^",2)			
	s Flag=$p(DivInfo,"^",5)
	q:((Flag'="I")&&(Flag'="B")&&(Flag'="S")) "-1^非有效的医保结算记录状态,Flag="_Flag
	s RF=1
	s AdmInfo=$g(^DHCINADM(AdmInfoDr))		
	s HospDr=$P(AdmInfo,"^",51)
    s InsuId=$P(AdmInfo,"^",2)              ;医保编号
    s InsuType=$P(AdmInfo,"^",18)           ;医保类型(Code)
    s InsuType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("DLLType",InsuType,4,HospDr)         
	s INPAYbcbxf0=$p(DivInfo,"^",7)			;医保总费用
	s:(Flag="S")&&(INPAYbcbxf0>0) RF=-1     ;负票结算记录
	s INPAYbcbxf0=INPAYbcbxf0 * RF
	s INPAYgrzfe0=$p(DivInfo,"^",15) * RF	;医保个人现金支付 psn_cash_pay 个人现金支付额
	s INPAYPay10=$p(DivInfo,"^",50)	* RF	;医保误差值
	s INPAYPay1=$p(DivInfo,"^",31)	* RF	;医保统筹基金支付 hifp_pay 基本医疗统筹基金支出
	s InPay2=$p(DivInfo,"^",32) * RF        ;hifob_pay 大额医疗补助基金支出
	s InPay3=$p(DivInfo,"^",33) * RF        ;cvlserv_pay 公务员医疗补助基金支出
	s InPay4=$p(DivInfo,"^",34) * RF        ;maf_pay  医疗救助基金支出
    s InPay5=$p(DivInfo,"^",35) * RF        ;hifes_pay 补充医疗保险基金支出
	s InPay6=$p(DivInfo,"^",46) * RF        ;hifmi_pay 大病补充医疗保险基金支出
	s InPay7=$p(DivInfo,"^",46) * RF        ;oth_pay 其他基金支出
	s InPay8=$p(DivInfo,"^",48)	* RF        ;hifdm_pay 伤残人员医疗保障基金支出??
    s InPay9=$p(DivInfo,"^",49)	* RF		;hosp_part_amt 医院负担金额
    //注意很重要 医保其他支付、个人自付和个人自费 根据项目和医保类型进行调整
	s INPAYQT=InPay2+InPay3+InPay4+InPay5+InPay6+InPay7+InPay8+InPay9	;医保其他支付 InsuPay2+...+InsuPay8
	s INPAYZhzfe0=$p(DivInfo,"^",28) * RF		                        ;个人账户支付 acct_pay 帐户支付额  
	s ItmYLGrzf=$p(DivInfo,"^",53) * RF		                            ;个人自付  (Zstr13):preselfpay_amt 先行自付金额
	s ItmBLGrzf=($p(DivInfo,"^",52)+$p(DivInfo,"^",54)) * RF            ;个人自费  (Zstr12):fulamt_ownpay_amt 全自费金额。(Zstr14)：overlmt_selfpay 超限价自费费用。
	s OverlmtSelfpay=($p(DivInfo,"^",54)) * RF                          ;(Zstr14)：overlmt_selfpay 超限价自费费用。
	s Jizfe0=$p(DivInfo,"^",19) * RF                                    ;fund_pay_sumamt ' 基金支付总额
	s GrzfSumAmt=(INPAYbcbxf0-Jizfe0) * RF                              ;个人支付总额
	//0^医保个人编号^医保类型^医保结算总金额^基本医疗统筹基金支出-5^其他支付总额^个人账户支付^个人现金支付^
	s OutStr=0_"^"_InsuId_"^"_InsuType_"^"_INPAYbcbxf0_"^"_INPAYPay1_"^"_INPAYQT_"^"_INPAYZhzfe0_"^"_INPAYgrzfe0
	//个人自付^个人自费-10^基金支付总额^个人支付总额^大额医疗补助基金支出^公务员医疗补助基金支出^
	s OutStr=OutStr_"^"_ItmYLGrzf_"^"_ItmBLGrzf_"^"_Jizfe0_"^"_GrzfSumAmt_"^"_InPay2_"^"_InPay3
	//医疗救助基金支出-15^大病补充医疗保险基金支出^其他基金支出^伤残人员医疗保障基金支出^医院负担金额^超限价自费费用
	s OutStr=OutStr_"^"_InPay4_"^"_InPay5_"^"_InPay6_"^"_InPay7_"^"_InPay8_"^"_InPay9_"^"_OverlmtSelfpay
	q OutStr
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
/// w ##class(web.DHCINSUPort).GetDicByCodeAndInd("HISPROPertyZZB","IsUseFundPaySumamtCTP",0,2)
ClassMethod GetDicByCodeAndInd(SysType, Code, Ind, HospDr) As %String
{
	n (SysType,Code,Ind,HospDr)
	q ##class(web.INSUDicDataCom).GetDicByCodeAndInd(SysType,Code,Ind,HospDr)
}

/// 根据费别id和代码取字典表数据列表
/// admreasonDr:费别表rowid,dicType:字典类别,dicCode:字典代码,ExpStr:扩展参数(以^分割,比如第一位是$p取值位置,第二位院区指针)
/// 当admreasonDr不为空时,取对应的医保类别代码,并拼给dicType,如果dicCode为空,则返回列表
/// Zhan 20170101
/// w ##class(web.DHCINSUPort).GetDicInfoByCode(4,"DispenType","",0)
ClassMethod GetDicInfoByCode(admreasonDr, dicType, dicCode, ExpStr) As %String
{
	n (admreasonDr, dicType, dicCode,ExpStr)
	s insutype="",RtnStr=""
	s Ind=+$p(ExpStr,"^",1)
	s HospDr=$P(ExpStr,"^",2) //+ DingSH 20200603
	i +admreasonDr>0 d
	.s insutype=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AdmReasonDrToTariType",admreasonDr,6,HospDr)
	.s:insutype'="" dicType=dicType_insutype
	s RtnStr=$$GetSys^DHCINSUDicData(dicType,dicCode,HospDr)
	i ($l(RtnStr,"^")>1)&(Ind>0) d
	.s RtnStr=$p(RtnStr,"^",Ind)
	q RtnStr
}

/// Description:根据收费项目代码，判断是否存在上传了对照关系
/// Creator:李铭京
/// Input:收费项Rowid
/// Output:(-1 未对照 0 对照未上穿 为1是表示目录上传医保中 为2是表示目录中心已经审核 为3是表示目录中心审核不通过) ^ 收费项Rowid^收费项Code^收费项描述（多个用！分割）
/// w ##class(web.DHCINSUPort).GetTarConUpFlag("3236","BJ")
/// 需要修改 20200603增加院区判断
ClassMethod GetTarConUpFlag(TarDr As %String, InsuType As %String, HospDr As %String) As %String
{
	n (TarDr,InsuType,HospDr)
	s InsuTarConDr="",Rtn=""
	s GroupHospital=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId("INSU_TarContrast",HospDr) //+ DingSH 20200521
	f  s InsuTarConDr=$o(^DHCINTCT(0,"DHCTID",TarDr,InsuTarConDr)) q:InsuTarConDr=""  d
	.Q:InsuTarConDr="" 
	.s InsuTarCode="",InsuTarDesc=""
	.s tHospDr=$p(^DHCINTCT(InsuTarConDr),"^",27)
	.q:tHospDr'=GroupHospital
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
	s Cash="" 		    ;现金总支付
	s INSU1=""		    ;医保基金支付
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
/// w ##class(web.DHCINSUPort).GetDivBackStrByRowid(205,1,"O")
/// 入参：		InPayRowid：insu_divide.rowid
/// 			GrzfModeStr：个人支付默认支付方式rowid
/// 			ExtStr：扩展串,第一位放结算类型。R:挂号 O:门诊结算 I:住院结算
/// 出参：失败：错误代码!错误描述
///       成功：0!支付方式串
/// 	备注：门诊结算:"0^insu_divide.rowid^现金^dhc_invprt.rowid^个人支付支付方式$c(2)支付方式rowid^金额$c(2)支付方式rowid^金额..."
/// 		  门诊挂号:"0^insu_adminfo.rowid^现金^insu_divide.rowid^个人支付支付方式!支付方式rowid^金额$c(2)支付方式rowid^金额..."
/// 		  住院结算:"0^insu_divide.rowid^现金^dhc_patientbill.rowid$c(2)支付方式rowid^金额$c(2)支付方式rowid^金额..."
/// 增加了自助机预结算返回串
ClassMethod GetDivBackStrByRowid(InPayRowid As %String, GrzfModeStr As %String, ExtStr As %String) As %String
{
	n (InPayRowid,GrzfModeStr,ExtStr)
	s OutStr="-1!"
	s DivType=$p(ExtStr,"^",1)   ///R:挂号 O:门诊结算
	q:$g(InPayRowid)="" "-1!参数不能为空"
	q:'$d(^DHCINDIV(InPayRowid)) "-1!未结算"
	s DivInfo=$g(^DHCINDIV(InPayRowid))
	s Flag=$p(DivInfo,"^",5)
	q:(DivType'="OPre")&&(Flag'="I") "-1!未结算"
	s JSFS=$P(DivInfo,"^",36)
	s InvPrtRowid=$P(DivInfo,"^",4)
	//门诊外院报销 
	q:(JSFS="OUT")&&(+InvPrtRowid>0) ##class(BILL.OUTPAY.BL.ChargeCtl).GetDivBackStrByRowid(InvPrtRowid,InPayRowid,"")
	s InvPrtDr=$p(DivInfo,"^",4)
	s PBDr=$p(DivInfo,"^",3)
	s InAdmInfoRowid=$p(DivInfo,"^",2)
	s InAdmInfo=$g(^DHCINADM(InAdmInfoRowid))		
	s INPAYbcbxf0=$p(DivInfo,"^",7)			        ;总费用
	s INPAYgrzfe0=$fn($p(DivInfo,"^",15),"",2)		;现金支付
	s INPAYzhzfe0=$p(DivInfo,"^",28)		        ;个人帐户支付
	s INPAYjjzfe0=$p(DivInfo,"^",19)		        ;基金总额
	s INPAYPay01=$p(DivInfo,"^",31)                 ;基本统筹支付
	s INPAYPay02=$p(DivInfo,"^",32)                 ;医院垫付
	s INPAYPay03=$p(DivInfo,"^",33)                 ;公务员部署
	s INPAYPay04=$p(DivInfo,"^",34)                 
	s INPAYPay05=$p(DivInfo,"^",35) 
	s INPAYPay06=$p(DivInfo,"^",46) 
	s INPAYPay07=$p(DivInfo,"^",47) 
	s INPAYPay08=$p(DivInfo,"^",48) 
	s INPAYPay09=$p(DivInfo,"^",49)               
	s INPAYPay10=$p(DivInfo,"^",50) 		         ;误差		
	s InsuType=$p(InAdmInfo,"^",18)	
	s AdmDr=$p(InAdmInfo,"^",1)	
	s HospDr=$p(InAdmInfo,"^",51)	                 ;
	s:(HospDr="")&&(AdmDr'="") HospDr=##class(web.UDHCHospitalGroup).GetHospitalByAdm(AdmDr)
	s InsuSum=$fn(INPAYgrzfe0+INPAYzhzfe0+INPAYPay01+INPAYPay02+INPAYPay03+INPAYPay04+INPAYPay05+INPAYPay06+INPAYPay07+INPAYPay08+INPAYPay09,"",2)
	s INPAYbcbxf0=$fn(INPAYbcbxf0,"",2)
	;判断医保返回总金额是否等于医保返回分解金额相加
	q:+INPAYbcbxf0'=+InsuSum "-2!医保返回总金额："_INPAYbcbxf0_"不等于医保分解金额之和："_InsuSum			
	;取ct_paymode表rowid,返回顺序需要根据实际医保存值写死。
	
    
    /*基金汇总,是否使用基金支付总额支付方式 DingSH 20210507*/ 
    s IsUseFundPaySumamtCTP=..GetDicByCodeAndInd("HISPROPerty"_InsuType,"IsUseFundPaySumamtCTP",4,HospDr)
    
    /*基金支付总额是否包括医保账户支付	+20230116*/			
	s IsFundPaySumamtHasZhzf=..GetDicByCodeAndInd("HISPROPerty"_InsuType,"IsFundPaySumamtHasZhzf",4,HospDr)
    
#;	s JjzfHasZhFlag = 0 //基金支付总额是否包含账户支付 
#;    i ($zabs(INPAYjjzfe0+INPAYgrzfe0-INPAYbcbxf0) = 0)&&(INPAYzhzfe0>0) d
#;    .s JjzfHasZhFlag = 1
#;	s tmpINPAYjjzfe0=INPAYjjzfe0
#;    i (+IsUseFundPaySumamtCTP=1)&&(+JjzfHasZhFlag=0) d
#;    .s tmpINPAYjjzfe0=tmpINPAYjjzfe0+INPAYzhzfe0
    
    s IsFundPaySumamtHasZhzf = 0 //基金支付总额是否包含账户支付 	upt 20230116
    i ($zabs(INPAYjjzfe0+INPAYgrzfe0-INPAYbcbxf0) = 0)&&(INPAYzhzfe0>0) d
    .s IsFundPaySumamtHasZhzf = 1
	s tmpINPAYjjzfe0=INPAYjjzfe0
    i (+IsUseFundPaySumamtCTP=1)&&(+IsFundPaySumamtHasZhzf=0) d
    .s tmpINPAYjjzfe0=tmpINPAYjjzfe0+INPAYzhzfe0
	q:(IsUseFundPaySumamtCTP=1)&&(+INPAYbcbxf0'=+(tmpINPAYjjzfe0+INPAYgrzfe0)) "-3!医保返回总金额："_INPAYbcbxf0_",不等于(jjzfe0+grzfe0)金额："_(INPAYjjzfe0+INPAYgrzfe0)

	;s PayModeStr=##class(web.INSUBase).GetPayModeDr()
	s PayModeStr=..GetPayModeDr()
	s:GrzfModeStr="" GrzfModeStr=$p(PayModeStr,"^",1) 
	s IsBackALLCTP=0
	i (DivType="O")||(DivType="P")||(DivType="OPre") d
    .s BackString = "0"_"^"_InPayRowid_"^"_(INPAYgrzfe0)_"^"_InvPrtDr_"^"_GrzfModeStr
    ./*是否全部返回门诊结算报销支付方式(包括金额为零)*/
    .s IsBackALLCTP=..GetDicByCodeAndInd("HISPROPerty"_InsuType,"OPDivIsBackALLCTP",4,HospDr)
    i DivType="R" d
    .s BackString = "0"_"^"_InAdmInfoRowid_"^"_InPayRowid_"^"_GrzfModeStr
    .s BackString=BackString_"!"_GrzfModeStr_"^"_(INPAYgrzfe0)
    ./*是否全部返回门诊挂号报销支付方式(包括金额为零)*/
    .s IsBackALLCTP=..GetDicByCodeAndInd("HISPROPerty"_InsuType,"OPRegIsBackALLCTP",4,HospDr)
    i DivType="I" d
    .s BackString = "0"_"^"_InPayRowid_"^"_(INPAYgrzfe0)_"^"_PBDr
    ./*是否全部返回住院结算报销支付方式(包括金额为零)*/
    .s IsBackALLCTP=..GetDicByCodeAndInd("HISPROPerty"_InsuType,"IPDivIsBackALLCTP",4,HospDr)
    
    i +IsUseFundPaySumamtCTP=1  d
    .s BackString=BackString_$c(2)_$p(PayModeStr,"^",2)_"^"_INPAYjjzfe0
    .s:+IsFundPaySumamtHasZhzf=0 BackString=BackString_$c(2)_$p(PayModeStr,"^",3)_"^"_INPAYzhzfe0
    //医保支付方式拼串：报销分项汇总的支付方式和报销分项的支付方式
#;    i +IsUseFundPaySumamtCTP=1  d
#;    .s BackString=BackString_$c(2)_$p(PayModeStr,"^",2)_"^"_INPAYjjzfe0
#;    .s:+JjzfHasZhFlag=0 BackString=BackString_$c(2)_$p(PayModeStr,"^",3)_"^"_INPAYzhzfe0
    e  d
    .d BuildPayBackStr(INPAYzhzfe0,$p(PayModeStr,"^",3))
    .d BuildPayBackStr(INPAYPay01,$p(PayModeStr,"^",2))
    .d BuildPayBackStr(INPAYPay02,$p(PayModeStr,"^",5))
    .d BuildPayBackStr(INPAYPay03,$p(PayModeStr,"^",6))
    .d BuildPayBackStr(INPAYPay04,$p(PayModeStr,"^",7))
    .d BuildPayBackStr(INPAYPay05,$p(PayModeStr,"^",8))
    .d BuildPayBackStr(INPAYPay06,$p(PayModeStr,"^",9))
    .d BuildPayBackStr(INPAYPay07,$p(PayModeStr,"^",10))
    .d BuildPayBackStr(INPAYPay08,$p(PayModeStr,"^",11))
    .d BuildPayBackStr(INPAYPay09,$p(PayModeStr,"^",12))
    
    i DivType="O" d
    .s OutStr=##class(web.DHCINSUOPBill).UpdateINVPRTYBInfo(BackString,"")
    .i OutStr'="0" d
    ..s OutStr="-3!更新支付方式失败,错误代码:"_OutStr_"BackString:"_BackString
    .e  d
    ..s OutStr="0!"_BackString
    i DivType="P" d
    .//s OutStr=##class(web.DHCINSUOPBill).GxPEZffs(InvPrtDr,BackString)
    .s OutStr=##class(web.DHCINSUOPBill).UpatePEINVPRTYBInfo(InvPrtDr,BackString)  //修改 DingSH 20220222 
    .i OutStr'="0" d
    ..s OutStr="-3!更新支付方式失败,错误代码:"_OutStr_"BackString:"_BackString
    .e  d
    ..s OutStr="0!"_BackString
    i DivType="R" d 								
	.s OutStr="0!"_BackString
	i DivType="I" d
	.s OutStr="0!"_BackString
	//+DingSH 2021111 门诊预结算
	i DivType="OPre" d
	.s OutStr="0!"_BackString
	q OutStr
BuildPayBackStr(PayAmt,PayMdDr)
   //判断是否返回所有报销分项或报销分项大于0进行拼串
   i (+IsBackALLCTP=1)||(PayAmt>0)
   {
	  s BackString=BackString_$c(2)_PayMdDr_"^"_PayAmt
   }
 q
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
      q:+$d(^PAADM(AdmDr))=0 Flag ;非法就诊ID
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
      q:+$d(^DHCPB(BillDr))=0 Flag ;非法账单ID
	  s PBPayedFlag=""
	  s PBPayedFlag=$P(^DHCPB(BillDr),"^",16)
	  s:PBPayedFlag'="P" Flag="1"
	  ;b ;001
		
	}
	
	q Flag
}

/// ywb
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
/// 20200603 需要修改
ClassMethod GetTarInsuInfo(TarItmRowid, AdmReasonDr, PBDID, DivFlag, ExpStr As %String) As %String
{
 	n (TarItmRowid, AdmReasonDr, PBDID, DivFlag, ExpStr)
 	s OutStr="",zfbl="",xmlb="",sflb="",bxje="",zfjj=""
 	q:(TarItmRowid="")&(PBDID="") "-1^收费项Dr和账单明细表ID不能同时为空"
 	s HospDr=$P($g(ExpStr),"^",1) //DingSH 20200603
 	q:(PBDID="")&&(HospDr="") "1^ExpStr的第一位院区指针不能为空"  //+ DingSH 20200603
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
		s tmpdicinfo=##class(web.INSUDicDataCom).QueryByCode("AdmReasonDrToDLLType",AdmReasonDr,HospDr)
		s InsuType=$p(tmpdicinfo,"^",6)
		q:InsuType="" "-1^未取到AdmReasonDr对应的医保类型"
		s InsuTypeDesc=$p(tmpdicinfo,"^",7)
	 	s TariInsuFlag=$p($$QueryByCode^DHCINSUDicData("HISPROPerty"_InsuType,"TariInsuFlag",HospDr),"^",4)   //取收费项是否与其他收费项关联的标志  add by lilizhi 2013-03-05
	 	s TarItemInsuInfo=$$GetConInfo^DHCINSUTarContrast(TarItmRowid,InsuType,$zd(+$h,3),TariInsuFlag,HospDr)
	 	q:TarItemInsuInfo="" "-1^收费表没有对应的数据"
		s zfbl=$p(TarItemInsuInfo,"^",18)					
		s lb=$p(TarItemInsuInfo,"^",23)						//甲,乙,非医保									
	}
	s xmlb=..RtnDicDescByDicCode(("AKA065"_InsuType),lb,HospDr)
 	s tmpsflb=$p(TarItemInsuInfo,"^",1)
 	s sflb=..RtnDicDescByDicCode(("FeeType"_InsuType),tmpsflb,HospDr)	//收费类别
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
/// 需要修改 20200603
ClassMethod GetSkcInfoByCode(SkcCode As %String, AdmReasonDr As %String, HospDr As %String) As %String
{
 	n (SkcCode, AdmReasonDr,HospDr)
 	s OutStr=""
 	q:$g(SkcCode)="" "-1^病种代码不能为空"
 	q:$g(AdmReasonDr)="" "-1^费别不能为空"
    s tmpdicinfo=##class(web.INSUDicDataCom).QueryByCode("AdmReasonDrToDLLType",AdmReasonDr,HospDr)
    s InsuType=$p(tmpdicinfo,"^",6)  ;通过AdmReasonDr获取医保类别
    q:InsuType="" "-1^根据费别："_AdmReasonDr_"，未取到对应医保类型"
    s tmpdicinfo=##class(web.INSUDicDataCom).QueryByCode("Skc516"_InsuType,SkcCode,HospDr)
    s DiagCode="",DiagDesc=""
    s DiagCode=$p(tmpdicinfo,"^",3)
    s DiagDesc=$p(tmpdicinfo,"^",4)
	s OutStr="1^"_DiagCode_"^"_DiagDesc
	q OutStr
}

/// 根据就诊,(身份证号或登记号)及费别获取慢病信息
/// Input：admDr:Paadm.Rowid ;papmi.PatMas.Rowid
///        insuNo:身份证号或登记号 要根据慢病人员维护信息区分,
///        admReaId:PacAdmReason.Rowid,ExpStr:发票Rowid|集中打印标识| ,hospId:CTHospital.Rowid
/// Output：成功：空(自费患者情况)或(病种代码^病种描述^病种类型$病种代码^病种描述^病种类型)
/// 		失败：-1^失败原因
/// DingSH 20210908
/// w ##class(web.DHCINSUPort).GetChronicInfo("","1856","","4","","2")
/// 使用场景：.Net获取慢病信息,体检走普通门诊不考虑
/// 门诊挂号：papmi 和 admReaId 或 insuNo() 和 admReaId 组合不能为空
ClassMethod GetChronicInfo(admDr As %String = "", papmi As %String = "", insuNo As %String, admReaId As %String, ExpStr As %String = "", hospId As %String = "") As %String
{
 	n (admDr, papmi,insuNo,admReaId,ExpStr,hospId)
 	s ChronicInfo=""
 	s StrInvDr="",CPPFlag=""
 	s StrInvDr=$P($g(ExpStr),"|",1)
 	s CPPFlag=$P($g(ExpStr),"|",2)
 	s ^TMP("CH")=$lb(admDr,papmi,insuNo,admReaId,ExpStr,hospId)
    //获取papmiDr
 	i (admDr="")&(papmi="")&(+StrInvDr>0) d
 	.s PrtRowID=""
 	.i CPPFlag="Y" d //集中打印发票情况
 	..s JustThread=StrInvDr
 	..s tmpAdmReasonId="",myIdx=""
 	..s tmpAdmReasonId = $O(^DHCTMPACCColPRT("IP",JustThread,""),-1)
 	..s:+tmpAdmReasonId>0 myIdx =$O(^DHCTMPACCColPRT("IP",JustThread,tmpAdmReasonId,""),-1)
 	..s:+myIdx>0 PrtRowID =$O(^DHCTMPACCColPRT("IP",JustThread,tmpAdmReasonId,myIdx,"PrtRowID",""),-1)
    .e  d
    ..s PrtRowID=+StrInvDr
 	.s:+PrtRowID>0 papmi=$P(^DHCINVPRT(PrtRowID),"^",15)
 	
 	q:($g(admDr)="")&($g(papmi)="")&($g(insuNo)="") "-1^就诊Id或人员基本信息Id或身份证号(或个人编号)及费别不能同时为空"
 	i (admDr'="")&&(admReaId="") d
 	.s admReaId=$P($g(^PAADM(admDr,1)),"^",7)
 	q:$g(admReaId)="" "-1^费别不能为空"
 	i (admDr'="")&&(papmi="") d
 	.s papmi=$P($g(^PAADM(admDr)),"^",1)
 	

 	s InsuType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AdmReasonDrToDLLType",admReaId,6,hospId)
    q:InsuType="" ""                  //自费患者返回空
    s QCChronicFlag=""                //医保控费慢病标识 1:是,2:否
    s QCChronicFlag=##class(web.INSUDicDataCom).GetDicByCodeAndInd("HISPROPerty"_InsuType,"QCChronicFlag",4,hospId)
 	if (+QCChronicFlag=1)
 	{
     new rrset 
     set rrset=##class(%ResultSet).%New("web.DHCOPAdmFind:GetChronicList")
	 s rrc= rrset.Execute(papmi, insuNo, admReaId, hospId)
	 q:$$$ISERR(rrc) "-1^"_$SYSTEM.Status.DisplayError(rrc)
	 while (rrset.Next()) {
		set diagCode=rrset.Get("DiagCode")
		set diagDesc=rrset.Get("DiagDesc")
		set diagType=rrset.Get("DiagType")
		s ChronicInfo=ChronicInfo_"!"_diagCode_"^"_diagDesc_"^"_diagType
	 }
 	}
 	else
 	{
	   s ChronicStr=##class(web.INSUDicDataCom).GetSys("","","Skc516"_InsuType,hospId)	
	   s chNum=$l(ChronicStr,"!")
	   f cIdx=2:1:chNum d
	   .s lInfo=$P(ChronicStr,"!",cIdx)
	   .s diagCode=$P(lInfo,"^",3)
	   .s diagDesc=$P(lInfo,"^",4)
	   .s diagType=$P(lInfo,"^",6)
	   .s ChronicInfo=ChronicInfo_"!"_diagCode_"^"_diagDesc_"^"_diagType
	 }
	q ChronicInfo
}

/// 是否医保标识取值位置配置(医嘱或者执行记录)
/// Input：AdmReasonDr：Pac_AdmReason,HospDr
/// Output：成功： 1:是否医保值取自医嘱表的OE_OrdItem.OEORI_CoverMainIns字段
///             或 0:是否医保值取自医嘱表的OE_OrdExec.OEORE_CoverMainIns字段
/// 		失败：-1^失败原因
/// DingSH 20210407
/// w ##class(web.DHCINSUPort).GetOEMainInsCfg("4","2")
/// 医生站、内部调用（取费用明细）
ClassMethod GetOEMainInsCfg(AdmReasonDr, HospDr As %String) As %String
{
 	n (AdmReasonDr,HospDr)
 	s OutStr=""
 	q:$g(AdmReasonDr)="" "-1^费别Id不能空"
 	q:$g(HospDr)="" "-1^院区Id不能空"
 	s OEMainInsCfg=""
 	//通过AdmReasonDr获取医保类别
    s InsuType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AdmReasonDrToDLLType",AdmReasonDr, 6 ,HospDr)
    s OEMainInsCfg=""
    s OEMainInsCfg=##class(web.INSUDicDataCom).GetDicByCodeAndInd("HISPROPerty"_InsuType,"OEMainInsCfg",4,HospDr)
    i InsuType="" d
    .s OEMainInsCfg=##class(web.INSUDicDataCom).GetDicByCodeAndInd("SYS","OEMainInsCfg",6,HospDr)
    
	q OEMainInsCfg
}

///  根据就诊或账单号判断是否做过医保医嘱审核
///  入参：AdmDr：Pa_Adm.Rowid, PBDr:DHC_PatientBill.Rowid,OEORDIDr:OE_OrdItem.Rowid 或者 (OE_OrdExec.Rowid)
///  出参 Y 或 N  或 小于0^错误信息
///  应用场景：判断当前患者是否已完成医保审核
///          （1）：护士会调用接口根据结果判断，如果已审核不允许护士进行召回或者费用调整；必须先撤销审核后才允许操作；
///          （2）：住院结算校验是否医保医嘱审核
/// w ##class(web.DHCINSUPort).CheckAuditFlag("1911","","")
/// 注意：住院如果存在多个账单 必须传账单号
/// 修改：DingSH 20221129 
ClassMethod CheckAuditFlag(AdmDr As %String, PBDr As %String = "", OEORDIDr As %String = "", TaritmDr As %String = "")
{
	s rtnAuditFlag = ##class(web.INSUAuditIP).CheckAuditFlag(AdmDr,PBDr,OEORDIDr_"^"_TaritmDr)
	q rtnAuditFlag
}

/// 根据用户表Code贯标医师、护师、技师编码
/// w ##class(web.DHCINSUBase).GetStdInfoByUserCode("hsjc1")
ClassMethod GetStdInfoByUserCode(UserCode, HospDr As %String = "") As %String
{
 s drcode=##class(web.DHCINSUBase).GetStdInfoByUserCode(UserCode,HospDr)
 q drcode
}

/// 根据用户表Id贯标医师、护师、技师编码
/// w ##class(web.DHCINSUPort).GetStdInfoByUserId("")
/// 基础平台组 SSUSRFreeText3 用这个字段存贯标
/// 返回 空或国家医师编码^用户名
/// 注意 某些项目可能此字段已经被占用 要修改
ClassMethod GetStdInfoByUserId(SSUSRRowId, HospDr As %String = "") As %String
{
	s drInfo=##class(web.DHCINSUBase).GetStdInfoByUserId(SSUSRRowId,HospDr)
	q drInfo
}

/// Function: 根据ICD诊断rowid获取诊断国家医保编码等信息(贯标)
/// Creator:DingSH
/// CreateDate: 2021-11-25
/// Input:
///        RowId      :ICD诊断rowid
///        HospDr     :院区rowid
///        AdmReasonDr:费别rowid
///        ActDate    :生效日期  日期格式 yyyy-mm-dd
///        ExpStr     :扩展参数
/// Return :诊断国家医保编码^诊断国家医保名称
/// Debug: w ##class(web.DHCINSUPort).GetStdInfoByMRCICDDxRowId("12430",2,4,"","")
ClassMethod GetStdInfoByMRCICDDxRowId(Rowid As %String, HospDr As %String, AdmReasonDr As %String = "", ActDate As %String = "", ExpStr As %String = "", langId As %String = "") As %String
{
	s $zt="GetStdInfoByMRCICDDxRowIdEx"
	n (Rowid,HospDr,AdmReasonDr,ActDate,ExpStr,langId,%session)
	s Cfg=""
    s Cfg=##class(web.DHCINSUPortUse).GetConfigByHospId(HospDr,"MRC_ICDDx")
	s StdCode="",StdDesc=""
	i $ZCVT(Cfg,"U")="INSU" d
	.//todo
	.//330^00A^T00.900x002^多处皮肤浅表擦伤^DCPFQBCS^^^^^2021-12-15^17:57:53^^^2021-12-15^^^^^^^^^^^^2^国家医保^^^^^^^^^^^^^^^^^^^^^^^^^
	.s StdInfo=##class(web.DHCINSUPort).GetICDInsuInfo(Rowid,AdmReasonDr,ActDate,HospDr,ExpStr,langId)
    .s StdCode=$P(StdInfo,"^",3)
	.s StdDesc=$P(StdInfo,"^",4)
	e  d
	.s StdInfo=##class(web.DHCINSUPortUse).GetStdInfoByMRCICDDxRowId(Rowid,langId)
	.s StdCode=$P(StdInfo,"^",1)
	.s StdDesc=$P(StdInfo,"^",2)
	q StdCode_"^"_StdDesc
GetStdInfoByMRCICDDxRowIdEx
 s $zt=""
 b ;异常 GetStdInfoByMRCICDDxRowIdEx w $ze
 q "-1^"_$ze
}

/// Function: 根据手术rowid获取手术国家医保编码等信息(贯标)
/// Creator:DingSH
/// CreateDate: 2021-11-25
/// Input:
///        RowId:     : 手术rowid
///        HospDr     : 院区rowid
///        AdmReasonDr: 费别rowid
/// 	   ActDate:	    生效日期 yyyy-mm-dd
/// 	   DSouc:		数据来源 (1:临床手术字典,2:病案手术字典)
/// 	   SoucVer：	数据来源版本 +DingSH 20220215
///        ExpStr     :扩展参数
/// Return :手术国家医保编码^手术国家医保名称
/// Debug: w ##class(web.DHCINSUPort).GetStdInfoByORCOperRowId("1",2,"","","1","","")
/// w ##class(web.DHCINSUPort).GetOperInsuInfo("2257",4,1,"","","2","")
ClassMethod GetStdInfoByORCOperRowId(Rowid As %String, HospDr As %String, AdmReasonDr As %String = "", ActDate As %String = "", DSouc As %String = "", SoucVer As %String = "", ExpStr As %String = "") As %String
{
	s $zt="GetStdInfoByORCOperRowIdEx"
    s Cfg=""
    s Cfg=##class(web.DHCINSUPortUse).GetConfigByHospId(HospDr,"ORC_Operation")
	s StdCode="",StdDesc=""
	i $ZCVT(Cfg,"U")="INSU" d
	.//todo
	.//2257^2257^17.9900x015^龟息养生功治疗^1^^4^2^KL^开颅^66200^^Demo Group^
	.s StdInfo=##class(web.DHCINSUPort).GetOperInsuInfo(Rowid,AdmReasonDr,DSouc,SoucVer,ActDate,HospDr,ExpStr)
	.//b ; StdInfo
	.s StdCode=$P(StdInfo,"^",9)
	.s StdDesc=$P(StdInfo,"^",10)
	e  d
	.s StdInfo=##class(web.DHCINSUPortUse).GetStdInfoByORCOperRowId(Rowid)
	.s StdCode=$P(StdInfo,"^",1)
	.s StdDesc=$P(StdInfo,"^",2)
	q StdCode_"^"_StdDesc
GetStdInfoByORCOperRowIdEx
 s $zt=""
 b ;异常 GetStdInfoByORCOperRowIdEx w $ze
 q "-1^"_$ze
}

/// Function: 根据收费项rowid获取收费项国家医保编码等信息(贯标)
/// Creator:DingSH
/// CreateDate: 2021-11-25
/// Input:TARIRowId： 收费项rowid,HospDr：院区Rowid ,ActDate:生效日期 yyyy-MM-dd 格式
/// Return :国家医保编码^国家医保名称
/// Debug: w ##class(web.DHCINSUPort).GetStdInfoByDHCTarItemRowId("4401")
ClassMethod GetStdInfoByDHCTarItemRowId(Rowid As %String, HospDr As %String, ActDate As %String = "") As %String
{
	s $zt="GetStdInfoByDHCTarItemRowIdEx"
	s Cfg=""
    s Cfg=##class(web.DHCINSUPortUse).GetConfigByHospId(HospDr,"DHC_TarItem")
	s StdCode="",StdDesc=""
	i $ZCVT(Cfg,"U")="INSU" d
	.s TariInsuFlag=$p($$QueryByCode^DHCINSUDicData("HISPROPerty00A","TariInsuFlag",HospDr),"^",4)   //取收费项是否与其他收费项关联的标志  add by lilizhi 2013-03-05
 	.s:ActDate="" ActDate=$zd(+$h,3)
 	.s TarItemInsuInfo=$$GetConInfo^DHCINSUTarContrast(Rowid,"00A",ActDate,TariInsuFlag,HospDr)
 	.s StdCode=$P(TarItemInsuInfo,"^",43)  //INTIMUnique
 	.s StdDesc=$P(TarItemInsuInfo,"^",35)  //INTIMyysmbm
	e  d
	.s StdInfo=##class(web.DHCINSUPortUse).GetStdInfoByDHCTarItemRowId(Rowid)
	.s StdCode=$P(StdInfo,"^",1)
	.s StdDesc=$P(StdInfo,"^",2)
	q StdCode_"^"_StdDesc
GetStdInfoByDHCTarItemRowIdEx
 s $zt=""
 b ;异常 GetStdInfoByDHCTarItemRowIdEx w $ze
 q "-1^"_$ze
}

///    根据界面日期转换成医保接口所需日期格式
///    入参说明：
///    dt：UI界面日期
///    format:日期格式数值 1 MM/DD/YYYY; 3 YYYY-MM-DD;4 DD/MM/YYYY   
///    w ##class(web.DHCINSUPort).GetInsuDateFormat("26/5/2021")
///    DingSH 20210526
ClassMethod GetInsuDateFormat(dt, format = "3")
{
	s $zt="GetInsuDateFormatEx"
	q:(format'=1)&&(format'=3)&&(format'=4) dt
	/*获取日期逻辑数值*/
	s lgdt=##class(websys.Conversions).DateHtmlToLogical(dt)
	/*获取日期逻辑数值*/
	s Insudt=$zd(lgdt,format)
	q Insudt
GetInsuDateFormatEx
 s $zt=""
 q dt
}

/// 诊断关联医保诊断信息
/// Input：  
///         ICDID:MRC_ICDDx.Rowid,
///   AdmReasonDr:费别rowid,
///       ActDate:生效日期
///        HospDr:CT_Hospital.Rowid
///        ExpStr:扩展参数
/// Output：成功：空 或者 返回医保诊断相关信息:医保诊断Rowid^医保类型^医保诊断代码^医保诊断名称^拼音码^^^^^
/// 	    失败：小于0
/// Others：
/// 330^00A^T00.900x002^多处皮肤浅表擦伤^DCPFQBCS^^^^^2021-12-15^17:57:53^^^2021-12-15^^^^^^^^^^^^2^国家医保^^^^^^^^^^^^^^^^^^^^^^^^^
/// w ##class(web.DHCINSUPort).GetICDInsuInfo("39992","4","2021-12-29","2")
ClassMethod GetICDInsuInfo(ICDID As %String, AdmReasonDr As %String, ActDate As %String = "", HospDr As %String = "", ExpStr As %String = "", langId As %String = "") As %String
{
 	n (ICDID, AdmReasonDr, ActDate,HospDr,ExpStr,langId,%session)
 	s ICDCode=$P($g(ExpStr),"^",1)
 	s HiType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AdmReasonDrToTariType",AdmReasonDr,6,HospDr,langId)
 	s:HiType="" HiType="00A"
 	i ActDate'="" d
 	.s ActDate=##class(websys.Conversions).DateHtmlToLogical(ActDate)
 	s OutStr = ##class(web.INSUDiagnosis).GetICDConInfo(ICDID,ICDCode, HiType,HospDr,ActDate,langId)
	q OutStr
}

/// 获取校验后身份证号（15位->18位,18位->18位)
/// PatID:身份证号(15位) 注意：18位直接返回
/// DingSH 20220321 参考 Zhan 20101118 .Net getCheckCode
/// w ##class(web.DHCINSUPort).GetCheckPatID("110102770825233")
/// w ##class(web.DHCINSUPort).GetCheckPatID("360103521002171")
/// w ##class(web.DHCINSUPort).GetCheckPatID("410886612216036")
ClassMethod GetCheckPatID(PatID As %String)
{
	s $zt="GetCheckPatIDEx"
	s len=$l(PatID)
	q:+len=18 PatID
	i +len=15{
		
		    s strJY=$LB("1", "0", "X", "9", "8", "7", "6", "5", "4", "3", "2")
		    s intQun=$LB(7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2, 1)
		    #dim strTemp As %String 
		    #dim intTemp As %Int32 = 0
		    s strTemp=$e(PatID,1,6)_"19"_$e(PatID,7,len)
		    s strLen=$l(strTemp)
		    f i=1:1:strLen{
			     s intTemp=intTemp + ($e(strTemp,i, i) * $lg(intQun,i))
			    }
			    //w "intTemp="_intTemp,!
			   s intTemp=intTemp # 11
			   s strTemp=strTemp_$lg(strJY,intTemp+1)
		         
			}
	q strTemp
GetCheckPatIDEx
 s $zt=""	
 b ;异常 GetCheckPatIDEx
 q PatID
}

/// 手术关联医保手术信息
/// 入参: 	OperDr:		    手术rowid
/// 		DSouc:		    数据来源 (1:临床手术字典,2:病案手术字典)
/// 		AdmReasonDr: 	费别rowid
/// 		ActDate:	    生效日期 yyyy-mm-dd
/// 		HospDr：	    院区rowid
/// 		SoucVer：	    数据来源版本 +DingSH 20220215
/// 		ExpStr：	    扩展参数     +DingSH 20220215
/// 出参："-1"：失败信息
/// 			成功：Rowid^手术表Dr^手术编码^手术名称^数据来源^备注^ConID^医保手术Dr^医保手术代码^医保手术名称^生效日期^失效日期^对照人^系统对照标识^审核状态^审核人^审核日期
/// w ##class(web.DHCINSUPort).GetOperInsuInfo("2257",4,1,"","","2","")
/// 2257^2257^17.9900x015^龟息养生功治疗^1^^4^2^KL^开颅^66200^^Demo Group^
ClassMethod GetOperInsuInfo(OperDr As %String, AdmReasonDr As %String, DSouc As %String = "", SoucVer As %String = "", ActDate As %String = "", HospDr As %String, ExpStr As %String) As %String
{
 	n (OperDr, AdmReasonDr,DSouc,SoucVer,ActDate,HospDr,ExpStr)
 	s HiType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AdmReasonDrToTariType",AdmReasonDr,6,HospDr)
 	s:HiType="" HiType="00A"
 	i ActDate'="" d
 	.s ActDate=##class(websys.Conversions).DateHtmlToLogical(ActDate)
 	s OutStr = ##class(web.INSUOPERContrastCtl).GetIOConInfo(DSouc,OperDr,HiType,ActDate,HospDr,SoucVer)
	q OutStr
}

/// 校验医院审批标志
/// 入参: 	PBDr:账单主表Id
/// 		AdmDr:就诊表		   
///            出参："-1^失败信息"
/// 		   成功：返回：空或医嘱或医嘱执行记录标识^为空医嘱或执行记录拼串(!分割)^ShwMsg(提醒信息)^ShwLink(跳转链接)
///  OEORI(医嘱)^13||14!13||15...^请前往【医嘱医保标志修改】界面，进行修改^ShwLink^
///  OEORE(医嘱执行记录)^13||14||1!13||15||1...^请前往【医保控费审核】界面，进行修改^ShwLink^
///  OEORI(医嘱)^13||14!13||15...^请前往【医保医嘱审核】界面，进行修改^ShwLink^
///  ^^^
/// w ##class(web.DHCINSUPort).CheckHospApprFlag("56")
/// w ##class(web.DHCINSUPort).CheckHospApprFlag("5")
ClassMethod CheckHospApprFlag(PBDr As %String, AdmDr As %String = "") As %String
{
 	n (AdmDr, PBDr)
 	s $zt="CheckHospApprFlagEx"
 	s t0=$p($zts,",",2)
 	//s HiType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AdmReasonDrToTariType",AdmReasonDr,6,HospDr)
 	//s:HiType="" HiType="00A"
 	 q:(PBDr="")&&(AdmDr="") "-1^账单和就诊不能同时为空"
 	 q:(AdmDr'="")&&(+$d(^PAADM(AdmDr))=0) "-1^无效的就诊号"
 	 q:(PBDr'="")&&(+$d(^DHCPB(PBDr))=0) "-1^无效的账单号"
 	 s ApprFlag=""
 	 s OEORDRowId="",ICoverMainIns="",ECoverMainIns=""
 	 s ShwOEFlag="",AdmType=""
 	  i (+PBDr=0){
	 	   s AdmType=$P(^PAADM(AdmDr),"^",2)
 	  }else{
	 	    s AdmDr=$P(^DHCPB(PBDr),"^",1)
	 	    s AdmType=$P(^PAADM(AdmDr),"^",2)
	 	  }
	s HospDr=##class(web.UDHCHospitalGroup).GetHospitalByAdm(AdmDr)
	s ShwDicType=""
	i AdmType="I" 
	{
	  s ShwOEFlag="OEORE"	 //住院判断执行记录
	  s ShwDicType="IPOEORE" 
	 }
	 else{
	  s ShwOEFlag="OEORI"   //门急诊判断医嘱\
	  s ShwDicType="OPOEORI"
	} 	   
	s ShwMsg=""  //"请前往【医嘱医保标志修改】界面，进行修改"
 	s ShwLink="" //"xxxxx.csp"
	s DicStr=##class(web.INSUDicDataCom).GetDicByCodeAndInd("NullHospApprFlagShw00A",ShwDicType,0,HospDr)
	q:$g(DicStr)="" "-1^请在医保字典:NullHospApprFlagShw(医院审批标识空值提醒配置)节点下维护提醒信息"
	s ShwMsg=$P(DicStr,"^",6)
	s ShwLink=$P(DicStr,"^",7)
 	i (+PBDr=0){
     f  {
	     s OEORDRowId=$O(^OEORD(0,"Adm",AdmDr,OEORDRowId))
         q:OEORDRowId=""
         s OEORIChildsub="0"
         f {
	         s OEORIChildsub=$O(^OEORD(OEORDRowId,"I",OEORIChildsub))
	         q:OEORIChildsub=""
	         s ItemStatDR=$p(^OEORD(OEORDRowId,"I",OEORIChildsub,1),"^",13)
             continue:$g(ItemStatDR)=""
             s OSTATCode=$P(^OEC("OSTAT",ItemStatDR),"^",1)
             s OSTATCode=$zcvt(OSTATCode,"U")
             continue:(OSTATCode'="V")&&(OSTATCode'="U")&&(OSTATCode'="E")&&(OSTATCode'="D")
             i AdmType="I" 
             {
	                d BuildECoverMainIns
	          }
	         else{
	                continue:(OSTATCode="U")&&(+$d(^DHCPBi(0,"OEORI",OEORDRowId_"||"_OEORIChildsub))=0)  //作废未进账单的不判断
                    continue:(OSTATCode="D")&&(+$d(^DHCPBi(0,"OEORI",OEORDRowId_"||"_OEORIChildsub))=0)  //停止未进账单的不判断
	                s OEORICoverMainIns=""
                    s OEORICoverMainIns=$P(^OEORD(OEORDRowId,"I",OEORIChildsub,3),"^",3)
                    continue:((ShwOEFlag="OEORI")&&(OEORICoverMainIns'="")&&(OEORICoverMainIns'="NULL"))
	                d BuildICoverMainIns
	          } 	  
	         }
       }
 	 }
 	 else
 	{
	 	 s InsuPId=$I(^tempHospAppr("CoverMainIns"))
 	     k ^tempHospAppr("CoverMainIns",InsuPId)
	 	 s PBRowId=PBDr
	     s PBOChildSub=0
	 	 f  {
	         s PBOChildSub=$O(^DHCPB(PBRowId,"O",PBOChildSub))
             q:PBOChildSub=""
             s PBOOEORIDR=$p(^DHCPB(PBRowId,"O",PBOChildSub),"^",4)
             s OEORDRowId=$P(PBOOEORIDR,"||",1)
             s OEORIChildsub=$P(PBOOEORIDR,"||",2)
             i AdmType="I" {
	               s PBOOrdExecDR=$p(^DHCPB(PBRowId,"O",PBOChildSub),"^",20)
	               s OEOREChildsub=$P(PBOOrdExecDR,"||",3)
	               s OEORECoverMainIns=""
                   s OEORECoverMainIns=$P(^OEORD(OEORDRowId,"I",OEORIChildsub,"X",OEOREChildsub),"^",49)
                   continue:((OEORECoverMainIns'="")&&(OEORECoverMainIns'="NULL"))
	               d BuildIPECoverMainIns
	             }
	             else
	             {
		          continue:+$d(^tempHospAppr("CoverMainIns",InsuPId,"I",PBOOEORIDR))'=0
                  s:AdmType'="I" ^tempHospAppr("CoverMainIns",InsuPId,"I",PBOOEORIDR)=1 //去重
                  s OEORICoverMainIns=""
                  s OEORICoverMainIns=$P(^OEORD(OEORDRowId,"I",OEORIChildsub,3),"^",3)
                  continue:((ShwOEFlag="OEORI")&&(OEORICoverMainIns'="")&&(OEORICoverMainIns'="NULL"))
		          d BuildICoverMainIns
		          }
	 	   }
	      k ^tempHospAppr("CoverMainIns",InsuPId)
	 }
	 s rtn=""
	 i ShwOEFlag="OEORI"{s rtn=ShwOEFlag_"^"_ICoverMainIns_"^"_ShwMsg_"^"_ShwLink}
	 i ShwOEFlag="OEORE"{s rtn=ShwOEFlag_"^"_ECoverMainIns_"^"_ShwMsg_"^"_ShwLink}
	 i (ICoverMainIns="")&&(ECoverMainIns="")
	 {
		 s rtn="^^^"
	 }
	 s t1=$p($zts,",",2)
	 s diff=t1-t0  //耗时计算
	 //w diff,!
     q rtn
BuildICoverMainIns 
  s NullOEORDI=OEORDRowId_"||"_OEORIChildsub
  i ICoverMainIns=""
  {
    s ICoverMainIns=NullOEORDI
   }
   else{
    s ICoverMainIns=ICoverMainIns_"!"_NullOEORDI      
   } 
   q 
BuildIPECoverMainIns   
	s NullOEORDE=OEORDRowId_"||"_OEORIChildsub_"||"_OEOREChildsub
	i ECoverMainIns=""
    {
	  s ECoverMainIns=NullOEORDE
     }else{
		 s ECoverMainIns=ECoverMainIns_"!"_NullOEORDE		          
	} 	        
 q 
BuildECoverMainIns   
 s OEOREChildsub=0
 f {
     s OEOREChildsub=$O(^OEORD(OEORDRowId,"I",OEORIChildsub,"X",OEOREChildsub))
	 q:OEOREChildsub=""
	 s OEEXCRowid=OEORDRowId_"||"_OEORIChildsub_"||"_OEOREChildsub
	 continue:(OSTATCode="U")&&(+$d(^DHCPBi(0,"OEEXC",OEEXCRowid))=0)  //作废未进账单的不判断
     continue:(OSTATCode="D")&&(+$d(^DHCPBi(0,"OEEXC",OEEXCRowid))=0)  //停止未进账单的不判断               
	 s OEORECoverMainIns=""
	 s OEORECoverMainIns=$P(^OEORD(OEORDRowId,"I",OEORIChildsub,"X",OEOREChildsub),"^",49)
	 continue:((OEORECoverMainIns'="")&&(OEORECoverMainIns'="NULL"))
	 s NullOEORDE=OEEXCRowid
	 i ECoverMainIns=""
     {
	    s ECoverMainIns=NullOEORDE
     }else{
		 s ECoverMainIns=ECoverMainIns_"!"_NullOEORDE		          
	  } 	          
   } 
 q 
CheckHospApprFlagEx   
 s $zt=""
 b ;CheckHospApprFlagEx
 q "-99^"_$ze
}

/// Function:	根据就诊获取医保支付方式
/// Creator：	DingSH 20220727 
/// 重要说明：通过医保就诊表存个人结算方式(XString8)与医保支付方式对照取取值
///         用到医保字典类别[psnSetlwayHiPaymtdCon/个人结算方式与医保支付方式对照]
/// Input: 	
/// 			AdmDr:就诊Id
/// Return: 成功：空或对应代码^名称
///         失败：-1^错误信息
///               -99^异常报错
/// w ##class(web.DHCINSUPort).GetHiPaymtdByAdm("21")
ClassMethod GetHiPaymtdByAdm(AdmDr)
{
	s $zt="GetHiPaymtdByAdmEx"
	q:$g(AdmDr)=""
	q:+$d(^DHCINADM(0,"ADM",AdmDr))="" ""
	s InAdmId=""
	s InAdmId=$O(^DHCINADM(0,"ADM",AdmDr,InAdmId),-1)
	q:$g(InAdmId)="" ""
	s ActFlag=$p(^DHCINADM(InAdmId),"^",11)
	q:(ActFlag'="A")&&(ActFlag'="O") ""
	s psnSetlway=$p(^DHCINADM(InAdmId),"^",37)
	s InsuType=$p(^DHCINADM(InAdmId),"^",18)
	s HospDr=##class(web.UDHCHospitalGroup).GetHospitalByAdm(AdmDr)
	s DicStr=##class(web.INSUDicDataCom).GetDicByCodeAndInd("psnSetlwayHiPaymtdCon"_InsuType,psnSetlway,0,HospDr)
	q:$g(DicStr)="" "-1^请在医保字典【psnSetlwayHiPaymtdCon】下维护个人支付方式字典:"_psnSetlway_"到医保支付方式字典的对照"
	s hiPaymtd=$P(DicStr,"^",6)
	s hiPaymtdDesc=$P(DicStr,"^",7)
	q hiPaymtd_"^"_hiPaymtdDesc
GetHiPaymtdByAdmEx
 s $zt=""
 b ;GetHiPaymtdByAdmEx
 q "-99^"_$ze
}

/// Function:	根据医嘱Rowid和项目编码获取三目信息
/// Creator：	HanZH 20220321 参考 jsq 2021.09.19
/// Input: 	
/// 			QOEORIDR:	医嘱rowid
/// Return:		
///   			第1-5  TotalAmount:总费用,UnitPrice:单价,BillQty:数量,HiListType:医保目录类别,ChrgType:收费类别
///   			第6-10 HiListCode:医保目录代码,HiListName:医保目录名称,HiListDosForm:医保目录药品剂型,HiListLv:医保目录等级,HiListPric:医保目录价格
///   			第11-15 Lv1HospItemPric:一级医院目录价格,Lv2HospItemPric:二级医院目录价格,Lv3HospItemPric:三级医院目录价格,HiListMemo:医保目录备注,HospListCode:医院目录代码
///   			第16-20 HospListName:医院目录名称,OwnPayment:自费金额,SelfPayment:自付金额,DeclaredAmt:申报金额,PayType:支付类别
/// others：	医生站调用
Query GetTarItemInfoByOrdId(QOEORIDR As %String) As %Query(ROWSPEC = "TotalAmount:%Float,UnitPrice:%Float,BillQty:%Float,HiListType:%String,ChrgType:%String,HiListCode:%String,HiListName:%String,HiListDosForm:%String,HiListLv:%String,HiListPric:%String,Lv1HospItemPric:%String,Lv2HospItemPric:%String,Lv3HospItemPric:%String,HiListMemo:%String,HospListCode:%String,HospListName:%String,OwnPayment:%String,SelfPayment:%String,DeclaredAmt:%String,PayType:%String") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCINSUPort","GetTarItemInfoByOrdId","6893381||94")
ClassMethod GetTarItemInfoByOrdIdExecute(ByRef qHandle As %Binary, QOEORIDR As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	q:QOEORIDR="" $$$OK 
	
	s OEORD=$p(QOEORIDR,"||",1)
	s OEORIChildsub=$p(QOEORIDR,"||",2)
	
	s AdmNo=$p(^OEORD(OEORD),"^",1)
	s BBExtCode=$p($g(^OEORD(OEORD,"I",OEORIChildsub,11)),"^",18)
	;w "BBExtCode:"_BBExtCode,!
	;q:(BBExtCode="1")||(BBExtCode="") $$$OK
	s CoverMainIns=$p($g(^OEORD(OEORD,"I",OEORIChildsub,3)),"^",3)
	s OeoriDate=$zd($p($g(^OEORD(OEORD,"I",OEORIChildsub,3)),"^",7),3)
	
	//s HosDr=##class(DHCDoc.Interface.YiBaoJianGuan.Business).GetAdmHospitalId(AdmNo)
	s HosDr=##class(web.UDHCHospitalGroup).GetHospitalByAdm(AdmNo)	//upt 20220602
	//s InsuType=$p(##class(web.INSUDicDataCom).QueryByCode("AdmReasonDrToDLLType",BBExtCode,HosDr),"^",6)
	s InsuType=""
	s AdmDr=$p($g(^OEORD(OEORD)),"^",1)
	s PAADMMotherAdmDR=$p($g(^PAADM(AdmDr)),"^",75)
	s:PAADMMotherAdmDR'="" AdmDr=PAADMMotherAdmDR //20211124
	s AdmReasonDr=$p($g(^PAADM(AdmDr,1)),"^",7)
	//s InsuType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AdmReasonDrToDLLType",AdmReasonDr,6)
	s InsuType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AdmReasonDrToDLLType",AdmReasonDr,6,HosDr) //upt 20220602
	s:InsuType="" InsuType="00A"
	s PbRowId=""
	s TariDrOra=""
	k ^TempCache("TariDr",$j)
	f  s PbRowId=$o(^DHCPBi(0,"OEORI",QOEORIDR,PbRowId)) q:PbRowId=""  d
	.s PboId=""
	.f  s PboId=$o(^DHCPBi(0,"OEORI",QOEORIDR,PbRowId,PboId)) q:PboId=""  d
	..s PbdId=""
	..f  s PbdId=$o(^DHCPB(PbRowId,"O",PboId,"D",PbdId)) q:PbdId=""  d
	...s PbdInfo=$g(^DHCPB(PbRowId,"O",PboId,"D",PbdId))
	...s TariDr=$p(PbdInfo,"^",3)
	...q:TariDr=""
	...s UnitPrice=$p(PbdInfo,"^",4)	//单价
 	...s BillQty=$p(PbdInfo,"^",5)		//数量
	...s TotalAmount=$p(PbdInfo,"^",7)	//总价
	...i $d(^TempCache("TariDr",$j,TariDr))=0 d
	....s ^TempCache("TariDr",$j,TariDr)=TotalAmount_"^"_UnitPrice_"^"_BillQty
	...e  d
	....s ^TempCache("TariDr",$j,TariDr)=$p($g(^TempCache("TariDr",$j,TariDr)),"^",1)+TotalAmount_"^"_UnitPrice_"^"_$p($g(^TempCache("TariDr",$j,TariDr)),"^",3)+BillQty
	
	s TariDr=""
	f  s TariDr=$o(^TempCache("TariDr",$j,TariDr)) q:TariDr=""  d
	.s TotalAmount=$P($g(^TempCache("TariDr",$j,TariDr)),"^",1)
	.s UnitPrice=$P($g(^TempCache("TariDr",$j,TariDr)),"^",2)
	.s BillQty=$P($g(^TempCache("TariDr",$j,TariDr)),"^",3)
	.;s TariInsuFlag=$p($$QueryByCode^DHCINSUDicData("TariInsuFlag",InsuType),"^",6)   //取收费项是否与其他收费项关联的标志  add by lilizhi 2013-03-05
	.s TariInsuFlag=$p($$QueryByCode^DHCINSUDicData("TariInsuFlag",InsuType,HosDr),"^",6)   //upt 20220602//取收费项是否与其他收费项关联的标志  add by lilizhi 2013-03-05
	.;s TarItemInsuInfo=$$GetConInfo^DHCINSUTarContrast(TariDr,InsuType,"",TariInsuFlag)
	.s TarItemInsuInfo=$$GetConInfo^DHCINSUTarContrast(TariDr,InsuType,"",TariInsuFlag,HosDr) //upt 20220602
	.;s HiListType=$p(..TARILinkType(+TariDr,InsuType,HosDr),"^",1) //$p(TarItemInsuInfo,"^",7)  ;医保目录类别
	.;s TARISubCateDr=$p($g(^DHCTARI(+TariDr)),"^",4)
	.;s ChrgType=$p(..TARILinkType(+TariDr,InsuType,HosDr),"^",3) //$p($g(^DHCTarC("SC",TARISubCateDr)),"^",2) ;收费类别,DHC_tarsubcate 的code
	.s TARISubCate=$p(^DHCTARI(TariDr),"^",4)
	.s TARSCTARCDR=$p(^DHCTarC("SC",TARISubCate),"^",3)
	.s TARSccatdr=$p($g(^DHCTARI(TARISubCate)),"^",16)
	.s hilisttypedr=$p(##class(web.DHCINSUPort).GetTarConUpFlag(TariDr,InsuType,HosDr),"^",2)
	.i hilisttypedr d
	..s hilisttypecode=$p($g(^DHCINTIM(hilisttypedr)),"^",1)	;医保目录收费大类代码
	.e  d
	..s hilisttypecode=""
	..s hilisttypedesc=""
	.s chrgtypecode=##class(web.INSUDicDataCom).GetDicByCodeAndInd("med_chrgitm_typeCon"_InsuType,TARSccatdr,6,HosDr)	;医疗收费项目类别与HIS收费类别对照
	.s HiListType=hilisttypecode
	.s ChrgType=chrgtypecode
	.s HiListCode=$p(TarItemInsuInfo,"^",3)   //医保目录代码,国家统一标准编码
	.s HiListName=$p(TarItemInsuInfo,"^",4)			//医保目录名称,国家统一标准名称
	.s HiListDosForm=$p(TarItemInsuInfo,"^",8) 	//医保目录药品剂型,国家统一标准药品剂型
	.s HiListLv=$p(TarItemInsuInfo,"^",23)			////医保目录等级
	.s HiListPric=$p(TarItemInsuInfo,"^",15) 			//医保目录价格
	.s Lv1HospItemPric=""			//一级医院目录价格
	.s Lv2HospItemPric=""			//二级医院目录价格
	.s Lv3HospItemPric=""			//三级医院目录价格
	.s HiListMemo=$p(TarItemInsuInfo,"^",22)		//医保目录备注
	.s HospListCode=$p($g(^DHCTARI(+TariDr)),"^",1)			//医院目录代码
	.s HospListName=$p($g(^DHCTARI(+TariDr)),"^",2)				//医院目录名称
	.s zfbl=$p(TarItemInsuInfo,"^",18)
	.s OwnPayment=0
	.s SelfPayment=0
	.i (HiListLv="03")!(HiListLv="3")!(CoverMainIns="N")!(TarItemInsuInfo="") d
	..s OwnPayment=TotalAmount			//自费金额
	.i (HiListLv="02")!(HiListLv="2") d
	..s SelfPayment=TotalAmount*zfbl			//自付金额　
	.s DeclaredAmt=""
	.s PayType=""
	.s TariDrOra=TariDr
	
	.s Data=$lb(TotalAmount,UnitPrice,BillQty,HiListType,ChrgType,HiListCode,HiListName,HiListDosForm,HiListLv,HiListPric,Lv1HospItemPric,Lv2HospItemPric,Lv3HospItemPric,HiListMemo,HospListCode,HospListName,OwnPayment,SelfPayment,DeclaredAmt,PayType)
 	.s ^CacheTemp(repid,ind)=Data
 	.s ind=ind+1
 		
 	q $$$OK
}

ClassMethod GetTarItemInfoByOrdIdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTarItemInfoByOrdIdExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetTarItemInfoByOrdIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTarItemInfoByOrdIdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// 校验医保登记数据
/// DingSH 20220906
/// 入参Desc:
/// AdmDr:		AdmDr:Paadm.Rowid
/// ExpStr      扩展串(可以为空):费别Id^医疗类别
/// 出参：
/// 			Y!A^在院 或 Y!O^出院
/// 			或N!空或N!B^取消登记,N!S^登记取消				
/// w ##class(web.DHCINSUPort).CheckRegActFlag("21","")
ClassMethod CheckRegActFlag(AdmDr As %String, ExpStr As %String = "") As %String
{
	
	n (AdmDr,ExpStr)
	s $zt="CheckRegActFlagEx"
	s OutStr=##class(web.DHCINSUAdmInfoCtl).CheckRegActFlag(AdmDr,ExpStr)
	q OutStr
CheckRegActFlagEx
 s $zt=""
 q "-99!接口异常:"_$ze
}

/// 获取医保医疗类别信息
/// 丁少华 20221206 
/// KeyWords:拼音，代码，描述 等关键字（为空：查询全部）
/// AdmDr：Pa_Adm.Rowid 
/// PrtDr: 门诊发票Id或者集中打印进程Id 
/// AdmReadId:就诊或发票费别 (PAC_AdmReason.Rowid)（如果为空，先取发票上费别，其次取就诊上的费别）
/// HospDr:院区指针（如果为空，先取发票上院区，其次取就诊上的院区）
/// ExpStr:门诊住院标识（OP:门诊/IP:住院,"":全部）^CPPFlag(集中打印标识 Y 或 【N或""】)^退费标识(收费:,退费传S)^医保结算表Id:(退费不为空)
/// Return: $lb(id:rowid,cCodec:医疗类别代码,cDesc:医疗类别描述,cDemo:备注,cBill1:预留1,cBill2:预留2,selected:true or false)
/// w ##class(web.INSUDicDataCom).QueryMedType("","","","4","2","OP^^^")
/// w ##class(web.INSUDicDataCom).QueryMedType("","","17","4","2","OP^^^")
/// w ##class(web.INSUDicDataCom).QueryMedType("","5408","","4","2","OP^^S^^")
ClassMethod QueryMedType(KeyWords As %String = "", PrtDr As %String = "", AdmDr As %String = "", AdmReadId As %String = "", HospDr As %String = "", ExpStr As %String = "", langId = "") As %ResultSet
{
	n (KeyWords, PrtDr , AdmDr, AdmReadId, HospDr , ExpStr,langId ,%session)
	set rset=##class(%ResultSet).%New("web.INSUDicDataCom:QueryMedType")
	do rset.Execute(KeyWords, PrtDr, AdmDr,AdmReadId,HospDr,ExpStr)
	quit rset
}

/// 获取医保慢特病病种信息
/// 丁少华 20221206 
/// KeyWords:拼音，代码，描述 等关键字（为空：查询全部）
/// AdmDr：Pa_Adm.Rowid 
/// PrtDr: 门诊发票Id或者集中打印进程Id 
/// AdmReadId:就诊或发票费别 (PAC_AdmReason.Rowid)（如果为空，先取发票上费别，其次取就诊上的费别）
/// PapmiDr:患者基本信息表.Rowid 
/// InsuNo:医保号
/// HospDr:院区指针（如果为空，先取发票上院区，其次取就诊上的院区）
/// ExpStr:门诊住院标识（OP:门诊/IP:住院,"":全部）^CPPFlag(集中打印标识 Y 或 【N或""】)^退费标识(收费:,退费传S)^医保结算表Id:(退费不为空)
/// Return: $lb(DiagCode:病种代码,DiagDesc:病种名称,DiagType:病种类型,selected:true or false)
/// 调用 示例：
/// 医生站调用，有就诊的情况：w ##class(web.INSUDicDataCom").QueryChronic("","","4153","4","","","2","OP^^^")
/// 医生站调用，无就诊的情况：w ##class(web.INSUDicDataCom").QueryChronic("","","","4","518","","2","OP^^^")
/// 门诊收费调用：w ##class(web.INSUDicDataCom").QueryChronic("","","4153","4","","","2","OP^N^^")
/// 集中收费调用：w ##class(web.INSUDicDataCom").QueryChronic("","进程号","","4","","","2","OP^Y^^")
/// 门诊退费调用：w ##class(web.INSUDicDataCom").QueryChronic("","发票号","","4","","","2","OP^^S^")
ClassMethod QueryChronic(KeyWords As %String = "", PrtDr As %String = "", AdmDr As %String = "", AdmReadId As %String = "", PapmiDr As %String = "", InsuNo As %String = "", HospDr As %String = "", ExpStr As %String = "", langId As %String = "") As %ResultSet
{
	n (KeyWords , PrtDr, AdmDr , AdmReadId , PapmiDr , InsuNo, HospDr , ExpStr,langId ,%session)
	set rset=##class(%ResultSet).%New("web.INSUDicDataCom:QueryChronic")
	do rset.Execute(KeyWords, PrtDr, AdmDr,AdmReadId,PapmiDr,InsuNo,HospDr,ExpStr)
	quit rset
}

/// 根据医嘱id判断是否为医保结算
/// 入参：  医嘱id
/// 出参： Y:医保,N:非医保
/// 使用场景：根据医嘱id来判断该医嘱是否为医保结算。入参门诊为医嘱id OEORIId、住院为医嘱执行表id OEOREId，出参为医保标志
/// +靳帅1010 20221209 upt 靳帅1010 20230404
/// 门诊-OE_Order-Pa_Adm-OE_OrdItem-DHC_PatientBill-DHC_BillConINV-DHC_INVPRT-INSU_Divide-判断：医保结算状态I为医保结算
/// 住院-OE_Order-Pa_Adm-OE_OrdExec-DHC_PatientBill-INSU_Divide-判断：医保结算状态I为医保结算
/// w ##class(web.DHCINSUPort).GetIsInsuPayByOEORDId("7||4","17||1||1") 
ClassMethod GetIsInsuPayByOEORDId(OEORIId As %String, OEOREId As %String) As %String
{
   n (OEORIId,OEOREId)
   s InsuFlag=##class(web.DHCINSUDivideCtl).GetIsInsuPayByOEORDId(OEORIId,OEOREId)
   q InsuFlag
}

/// 医保科室管理：科室信息修改时调用
/// 入参：DeptDr:CT_Loc.Rowid
/// 出参：0 或 小于0程序异常
/// 使用场景：科室/病区维护修改后调用此接口(基础数据平台组)
/// DingSH 20221219
/// w ##class(web.DHCINSUPort).UptLocFlag(39)
ClassMethod UptLocFlag(DeptDr) As %String
{
	n (DeptDr)
	s rtnStr=##class(web.DHCINSULocInfoCtl).UptLocFlag(DeptDr)
	q rtnStr
}

/// Creator：      DingSH
/// CreatDate：    2023-03-14
/// Description:   根据医保结算Rowid判断医保结算数据是否可冲正
/// 可冲正规则：   （1）医保结算表DivFlag=D
///                （2）DivFlag=I且AdmDr="" 且(当前时间-结算时间)超过60秒 (门诊医保挂号异常情况)
///                （3）DivFlag=I且发票Rowid在门诊发票表和体检发票表不存在的。                
///                （4）DivFlag=I且发票Rowid在门诊发票表和体检发票表存在但是PrtFlag=TP 且(当前时间-结算时间)超过60秒。  
///                （5）DivFlag=I且账单Id在账单表不存在
/// Table: INSU_Divide,INSU.MI.BL.RevsTrnsLog
/// Input：        DivDr:Insu_Divide.INPAY_Rowid
/// Output：        
/// Return：    可冲正返回：  1^冲正交易表指针^医保类型" ; 不可冲正返回： 0^  或 -99^异常错误信息
/// Others： 门诊异常处理界面检验是否可冲正使用
/// w ##class(web.DHCINSUPort).CheckIsRevsByDivDr(DivDr)
ClassMethod CheckIsRevsByDivDr(DivDr As %String) As %String
{
	n (DivDr)
	s rtnVal = ##class(web.DHCINSUDivideCtl).CheckIsRevsByDivDr(DivDr)
    q rtnVal
}

/// Creator：      DingSH
/// CreatDate：    2023-03-29
/// Description:   根据医保结算Rowid获取医保登记表Rowid
/// Table:         INSU_Divide,INSU_AdmInfo
/// Input：        InDivDr:Insu_Divide.INPAY_Rowid
/// Output：        
/// Return：    成功：  医保登记表.Rowid  ; 失败 小于0^错误信息或 -99^异常错误信息
/// Others： 使用场景：在就诊登记处登记(自费)，然后在收费界面用医保收费。 再去退号，这时候调用不到医保退费 。
/// w ##class(web.DHCINSUPort).GetInAdmDrByInDivDr(DivDr)
ClassMethod GetInAdmDrByInDivDr(InDivDr As %String) As %String
{
	n (InDivDr)
	s rtnVal = ##class(web.DHCINSUDivideCtl).GetInAdmDrByInDivDr(InDivDr)
    q rtnVal
}

/// 根据就诊Dr判断患者是否慢病
/// 丁少华 20230331
/// AdmDr：Pa_Adm.Rowid 
/// ExpStr:
/// Return: 成功：是 或 否 ；失败 小于0^错误信息
/// 判断规则说明：
/// 	      1:根据  医保就诊登记表信息判断
/// 	      2:根据  人员慢特病备案表信息判断
/// 	      3:根据  调用人员慢特病备案查询接口(5301)实时查询判断
///  	      4:根据  根据就诊未结算医嘱存病种判断
///  使用场景 门诊收费界面 人员信息展示患者是否慢病
///  特别说明如果 按照3 判断 可能会影响性能
/// w ##class(web.DHCINSUPort).CheckIsChronic("9598")
ClassMethod CheckIsChronic(AdmDr As %String, ExpStr As %String = "") As %String
{
	s IsChronic="N",tmpIsChronic=""
	;校验方式说明：
	;1:通过 Insu_AdmInfo 医疗类别、病种编码 字段判断
    s IsChronicStr = ##class(web.DHCINSUAdmInfoCtl).CheckIsChronic(AdmDr,ExpStr)
    s tmpIsChronic = $P(IsChronicStr,"^",1)
	;2 根据  人员慢特病备案表信息判断
	i tmpIsChronic'="Y" {
       s IsChronicStr = ##class(web.INSUReport).CheckIsChronic(AdmDr,ExpStr)
       s tmpIsChronic = $P(IsChronicStr,"^",1)
	}
	;3:根据  调用人员慢特病备案查询接口(5301)实时查询判断
	i tmpIsChronic'="Y" {
       ;s IsChronicStr = ##class(INSU.OFFBIZ.BL.BIZ00A).CheckIsChronic(AdmDr,ExpStr)
       ;s tmpIsChronic = $P(IsChronicStr,"^",1)
	}
    ;4:根据  根据就诊未结算医嘱存病种判断
    i tmpIsChronic'="Y" {
      s IsChronicStr = ##class(web.DHCINSUAdmInfoCtl).CheckIsChronicByOrd(AdmDr,ExpStr)
	  s tmpIsChronic = $P(IsChronicStr,"^",1)
	}
	//s IsChronic=$case(tmpIsChronic,"Y":"是","N":"否",:"未知")
    q tmpIsChronic
}

/// 根据医保结算表Rowid更新医保分解标识 
///  DingSH 2023-04-20
/// 入参： InDivDr: 医保结算表Rowid; 
/// 使用场景：医生给就患者就诊登记,在门诊收费界面只收医保挂号、诊查费(掉门诊医保收费挂号报销), 更新医生站挂号信息时调用
///     成功:大于0(医保结算表Rowid) 失败：小于0^错误信息
/// w ##class(web.DHCINSUPort).UpdtOPRegDivFlag("1")
ClassMethod UpdtOPRegDivFlag(InDivDr As %String) As %String
{
	new (InDivDr)
	set rtnFlag = ##class(web.DHCINSUDivideCtl).UpdtDivFlag(InDivDr,"R")
    quit rtnFlag
}

/*
/// Descript:	根据收费项ID返回目录类别代码及名称、收费类别代码及名称
/// CreateDate:	2022-04-21 LMY
/// Input:		TARIRowId-收费项ID
/// Output:		hilisttypecode目录类别代码,hilisttypedesc目录类别名称,chrgtypecode收费类别代码,chrgtypedesc收费类别名称
/// w ##class(web.DHCINSUPort).TARILinkType("12525")
/// others：	add by HanZH 20220602
ClassMethod TARILinkType(TARIRowId)
{
	q:TARIRowId="" ""
	s TARISubCate=$p(^DHCTARI(TARIRowId),"^",4)
	s TARSCTARCDR=$p(^DHCTarC("SC",TARISubCate),"^",3)
	s hilisttypecode=$p(##Class(web.DHCBL.CT.BDPBaseDataMapDetail).ConvertData("GJYB","MLLBYB",TARSCTARCDR),"^",2)
	s hilisttypedesc=$p(##Class(web.DHCBL.CT.BDPBaseDataMapDetail).ConvertData("GJYB","MLLBYB",TARSCTARCDR),"^",3)
	s chrgtypecode=$p(##Class(web.DHCBL.CT.BDPBaseDataMapDetail).ConvertData("GJYB","SFLBYB",TARISubCate),"^",2)
	s chrgtypedesc=$p(##Class(web.DHCBL.CT.BDPBaseDataMapDetail).ConvertData("GJYB","SFLBYB",TARISubCate),"^",3)
	
	q hilisttypecode_"^"_hilisttypedesc_"^"_chrgtypecode_"^"_chrgtypedesc
}
*/

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
///  根据账单明细PBD校验是否医保标识与已上传明细一致
/// 入参 
/// 	PBDID:账单明细号
/// 	ExpStr:扩展串(院区指针)
/// 出参：0 ;
///       -1^数据有问题
///       -2^不一致的信息
/// KHB 20220913
/// 备注:
/// 应用场景：核查是否医保标识与已上传医保明细是否一致
/// w ##class(web.DHCINSUDivideSubCtl).CheckINSUDivideSubSelfAmountByPBDId("","2")
/// 
ClassMethod CheckINSUDivideSubSelfAmountByPBDId(PBDID As %String, ExpStr As %String) As %String
{
 n (PBDID,ExpStr)
 
 q:PBDID "-1^账单明细号不能为空"
 s BillId=$p(PBDID,"|",1)
 //1 根据配置取是否医保标识取值方式(医嘱,医嘱的执行记录,医保医嘱审核,医保控费审核)
 s AdmReasonDr = $P(^DHCPB(BillId),"^",4)
 s hospdr=$p(ExpStr,"^",1)
 s InsuType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AdmReasonDrToDLLType", AdmReasonDr,6)
 s ChkFlag =##class(web.INSUDicDataCom).GetDicByCodeAndInd("HISPROPerty"_InsuType, "ChkInsuFlagMod",4) //+DingSH 20210222 
 
 //2 获取上传时的医院审批标志
 s SumAmount=0,SumSelfPay=0,count=0
 s INDISRowid=""
 s INDISRowid=$O(^DHCINDIS("0","PBDDr",PBDID,INDISRowid)) q:INDISRowid=""  d
 q:INDISRowid="" "-1^没有找到上传的医保明细"
 q:$p(^DHCINDIS(INDISRowid),"^",18)'="N" "-1^本条明细还没有上传到医保中心"
 s DivedSubFlag=$p(^DHCINDIS(INDISRowid),"^",18)
 s INDISOEORIDr=$p(^DHCINDIS(INDISRowid),"^",5)
 s INDISTarItmDr=$p(^DHCINDIS(INDISRowid),"^",3)
 s INDISInsuFlag=$P($p(^DHCINDIS(INDISRowid),"^",24),"|",1) //INDIS_INSUFlag 明细上传时的医保标识 
 s HospFlag=$P($p(^DHCINDIS(INDISRowid),"^",24),"|",2) //INDIS_INSUFlag 明细上传时的医院审批标识 
 
 //3 获取当前医院的审批标志 start
 s NowHospFlag = ""
 ; 按医嘱取是否医保标识
 i ChkFlag="0" d
 .s NowHospFlag=$p($g(^OEORD($p(INDISOEORIDr,"||",1),"I",$p(INDISOEORIDr,"||",2),3)),"^",3) //CoverMainIns
 ; 按医嘱执行记录取是否医保标识
 i ChkFlag="1" d
 .s NowHospFlag=$p($g(^OEORD($p(INDISOEORIDr,"||",1),"I",$p(INDISOEORIDr,"||",2),"X",$p(INDISOEORIDr,"||",3))),"^",44) //OEOREInsuFlag
 ; 按医保医嘱审核取是否医保标识
 i ChkFlag="2" d
 .s INAUDRowid=""
 .s INAUDRowid=$O(^DHCINAUD("0","OEORI_Tar",INDISOEORIDr,INDISTarItmDr,""),-1)
 .s:+INAUDRowid>0 NowHospFlag=$P($g(^DHCINAUD(INAUDRowid)),"^",6)
 ; 按医保控费取是否医保标识
 i ChkFlag="3" d
 .//s NowHospFlag=##class().xxx()
  
 s (hislmtusedflag,TmpHospFlag)=""
 //获取医保目录的限制标志
 s INSUTARIDr=$p(^DHCINDIS(INDISRowid),"^",4)
 s INTIMtxbz=$p(^DHCINTIM(INSUTARIDr),"^",6)
 s:INTIMtxbz="" hislmtusedflag="0"     ;目录限制使用标志为“否”
 s:INTIMtxbz'="" hislmtusedflag="1"    ;目录限制使用标志为“是”
  
 //根据规则判断当前的医院审批标志
 i hislmtusedflag = "1" d ; '当目录限制使用标志为“是”时:
 .s TmpHospFlag=$case(NowHospFlag,"Y":"1","N":"2",:"2")  ;修改人:  修改时间: 需求编号:   实施姓名：
 i hislmtusedflag = "0" d ; '当目录限制使用标志为“否”时: 		 
 .s TmpHospFlag=$case(NowHospFlag,"Y":"1","N":"2",:"2")  ;修改人:  修改时间: 需求编号:   实施姓名：	
 // 当前医院的审批标志 end
 
 q:INDISInsuFlag'=TmpHospFlag "-2^当时上传给医保中心的医院审批标志:"_INDISInsuFlag_",当前的医院审批标志:"_TmpHospFlag 

 q "0"
}

/// Description:	根据类型获取医保结算业务数据
/// Table:			
/// Input:			AdmType:"I"为住院，其它为门急诊；inArg：门诊为发票ID，住院为账单ID；Infno默认为空；HospId：院区ID，ExpStr：默认为空
/// Output:			返回门诊、住院的结算医保返回的原始JSON
/// Return:
/// Others: w ##class(web.DHCINSUPort).GetTrnsInfo("O",42657,"",2,"")
ClassMethod GetTrnsInfo(AdmType As %String, inArg As %String, Infno As %String, HospId As %String, ExpStr As %String) As %String
{
	s $zt="GetTrnsInfoEx"
	q:AdmType="" "-1!AdmType不能传空"
	q:HospId="" "-2!HospId不能传空"
	s IdxOpte="IdxBillDr"
	s Infno="2304"
	s rid=""
	s rtnStr=""
	i AdmType'="I" d
	.s IdxOpte="IdxPrtDr"
	.s Infno="2207"
	s indexcode=inArg
	q:$d(^INSU.MI.TrnsLogI(IdxOpte,HospId,indexcode))=0
	s tmprid=""
    f  s tmprid=$o(^INSU.MI.TrnsLogI(IdxOpte,HospId,indexcode,tmprid)) q:(tmprid="")||(rid'="")  d
    .s TMPInfo=$g(^INSU.MI.TrnsLogD(tmprid))
    .q:($lg(TMPInfo,8)'=Infno)&&(Infno'="")
    .s rid=tmprid
    .s rtnStr=$g(^INSU.MI.TrnsLogD(rid,"OUTPUT"))

	q rtnStr
GetTrnsInfoEx
 s $zt=""
 q "-1^"_$ze
}

}
