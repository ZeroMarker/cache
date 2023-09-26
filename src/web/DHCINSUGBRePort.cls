Import SQLUser

Class web.DHCINSUGBRePort Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 276;

// 该类方法用于统计上海东方医院干保报表 Lou 2010-03-09

/// 生成BA表的临时Global,	门急诊挂号信息	(BA)
/// 还需修改
/// Table :   insu_divide,insu_adminfo,pa_adm
/// 杨建章 2010-03-08
ClassMethod BuildGlobalBA(iDate As %String) As %String
{
	n (iDate)
	k ^DHCINSUGB("BA")
	s ^DHCINSUGB("BA",$j,0)="LSH^YLZBH^SBCARD^MJZH^JZSJ^MJZBS^KSMC^GHF^ZLF^YBZF^GBZF^TSFY^GRZF^FYID^FFXZID^ZFBL^DBXM^YSXM^ZZBZ^MZZD^TKBZ^TKLSH"
    s DivDr="0",i=0
	s DivDr=""
	f  s DivDr=$o(^DHCINDIV("0","IDate",CurrDate,DivDr)) q:DivDr=""  d
	.s DivInfo=$g(^DHCINDIV(DivDr))
	.s djlsh=$p(DivInfo,"^",8)			;中心交易流水号	16	交易确认应答返回的流水号
	.q:djlsh="" ;非实时结算的退出
	.q:djlsh=""						;单据流水号为空表示此数据位本地结算数据
	.s Zstr01=$p(DivInfo,"^",1)		;挂号还是收费的分解标识
	.q:(Zstr01="F")
	.s AdmDr=$p(DivInfo,"^",1)
	.s AdmNo=$p($g(^PAADM(AdmDr)),"^",81)
	.s ReaId=$p($g(^PAADM(AdmDr,1)),"^",7)
	.s AdmInfoDr=$p(DivInfo,"^",2)
	.s InsuAdmInfo=$g(^DHCINADM(AdmInfoDr))
	.s SYBZ=$p(InsuAdmInfo,"^",40)				;适用医保办法标志
	.s SeriNo=$p(InsuAdmInfo,"^",10)
	.s bcbxf0=+$p(DivInfo,"^",7)
	.s Flag=$p(DivInfo,"^",5)				//结算状态，I：正常、B：被冲销、S冲销记录，D中间状态
	.q:Flag="D"
	.s x=1
	.s TKBZ=0
	.;退款记录取原记录流水号
	.i Flag="S"                 d
	..s TKBZ=1									;退款标志
	..s x=-1
	..s tmpDivDr=+$p(DivInfo,"^",6)
	..s djlsh=$p($g(^DHCINDIV(tmpDivDr)),"^",8)
	;结算流水号
	.s InsuId=$p(InsuAdmInfo,"^",2)
	.s INLOCInfo=##class(web.DHCINSULOCInfo).GetLocInfoByCardNo(InsuId,ReaId)
	.s YLZBH=$p(INLOCInfo,"^",3)				;保健号
	.s CardNo=$p(INLOCInfo,"^",4)				;社保卡号
	.s FunDate=$p(DivInfo,"^",22)
	.s FunTime=$p(DivInfo,"^",24)
	.s FunDate=..ToType3ToB(FunDate,FunTime) 	;就诊时间
	.s AdmType=+$p(InsuAdmInfo,"^",14)			;门急诊标志
	.s:AdmType=3 AdmType=1						;如果是大病患者，门急诊标志默认为门诊
	.s AdmDeptDr=+$p($g(^PAADM(AdmDr)),"^",4)
	.s AdmDepCode=$p($g(^CTLOC(AdmDeptDr)),"^",1)  
	.s DepStr=$$QueryByCode^DHCINSUDicData("30",AdmDepCode)
	.s DepCode=$p(DepStr,"^",6)			;科室代码
	.s DepDesc=$p(DepStr,"^",7)			;科室名称
	.s ZLF=+$p(DivInfo,"^",52)*x			;诊疗费
	.s GHF=(bcbxf0-ZLF)*x								;挂号费
	.s Jjzfe=$p(DivInfo,"^",19)*x			;医保基金支付
	.s GBJJ=$p(DivInfo,"^",19)*x			;干保统筹金支付
	.s Tsylfy=0							;特殊医疗费用
	.s SelfPay=+$p(DivInfo,"^",15)*x		;个人现金支付
	.s FYXZ=$p(INLOCInfo,"^",11)		;费用性质
	.s FFXZID=$p(INLOCInfo,"^",12)		;付费性质
	.s XjBl=0							;个人现金支付比例
	.s DisCode=$p(InsuAdmInfo,"^",45)	;大病项目
	.s DoctorName=""					;医生姓名（医生姓名参考老系统全部置空）
	.i $e(YLZBH,"",1)="Q"    d
	..s ZZBZ=0 ;转诊标志
	.e                       d
	..s ZZBZ=1
	.s MZZD=""							;门诊诊断
	.s MJZH=AdmNo                       ;门急诊号
	.s TmpStr=AdmDr_"^"_YLZBH_"^"_CardNo_"^"_MJZH_"^"_FunDate_"^"_AdmType_"^"_DepDesc_"^"_$j(GHF,3,2)_"^"_$j(ZLF,3,2)_"^"_$j(Jjzfe,3,2)_"^"_$j(GBJJ,3,2)_"^"_$j(Tsylfy,3,2)_"^"_$j(SelfPay,3,2)_"^"_FYXZ_"^"_FFXZID_"^"_XjBl_"^"_DisCode_"^"_DoctorName_"^"_ZZBZ_"^"_MZZD_"^"_TKBZ_"^"_djlsh
	.s i=i+1
	.s ^DHCINSUGB("BA",$j,i)=TmpStr
    q $j_"|"_i
}

/// 生成BB表BC表的临时Global,	门急诊药品明细信息	(BB) 门急诊检查诊疗信息	(BC)
/// 还需修改
ClassMethod BuildGlobalBBBC(iDate As %String) As %String
{
	n (iDate)
	k ^DHCINSUGB("BB")
	k ^DHCINSUGB("BC")
	s ^DHCINSUGB("BB",$j,0)="LSH^YLZBH^SBCARD^MJZH^CFRQ^YSXM^FYLB^XMBM^XMMC^JX^DW^GG^SL^DJ^YBZF^GBZF^TSFY^GRZF^FYID^FFXZID^ZFBL^TSYP_BZ^CFH^TKBZ^TKLSH"
	s ^DHCINSUGB("BC",$j,0)="LSH^YLZBH^SBCARD^MJZH^YSXM^CFRQ^FYLB^XMBM^XMMC^DW^SL^DJ^YBZF^GBZF^TSFY^GRZF^FYID^FFXZID^ZFBL^TSJCZL_BZ^SJDH^TKBZ^TKLSH"
    s DivDr="0",i=0,j=0
    for  s DivDr=$o(^DHCINDIV("0","IDate",iDate,DivDr)) q:DivDr=""  d
    .s mCurrRowDiv=$g(^DHCINDIV(DivDr))
    .q:$p(mCurrRowDiv,"^",68)'="1" ;非干保定点结算退出
    .q:$p(mCurrRowDiv,"^",8)="" ;非实时结算的退出
    .s INSUAdmDr=$p(mCurrRowDiv,"^",2)
    .s mCurrRowInsuAdm=$g(^DHCINADM(INSUAdmDr))
    .q:(mCurrRowInsuAdm="")
    .s AdmDr=$p(mCurrRowInsuAdm,"^",1)
    .s AdmType=$p($g(^PAADM(AdmDr)),"^",2)
    .q:(AdmType'="O")&&(AdmType'="E") ;只统计门急诊
    .s Flag=$p(mCurrRowDiv,"^",5)
    .q:Flag="D"
    .s:Flag="S" x=-1
    .e  s x=1
    .s AdmNO=$p($g(^PAADM(AdmDr)),"^",81)
    .s ReaId=$p($g(^PAADM(AdmDr,1)),"^",7)
    .s InsuId=$p(mCurrRowInsuAdm,"^",2)
    .s INLOCInfo=##class(web.DHCINSULOCInfo).GetLocInfoByCardNo(InsuId,ReaId)
    .s DivSubDr="0"
    .f  s DivSubDr=$o(^DHCINDIS("0","DivideDr",DivDr,DivSubDr)) q:DivSubDr=""  d
    ..s LSH="",YLZBH="",SBCARD="",MJZH="",YSXM="",CFRQ="",FYLB="",XMBM="",XMMC="",DW="",SL="",DJ="",YBZF="",GBZF="",TSFY="",GRZF="",FYID="",FFXZID="",ZFBL="",TSJCZLBZ="",SJDH="",TKBZ="",TKLSH=""
    ..s JX="",GG="",TSYPBZ="",CFH=""
	..s mCurrRowDivSub=$g(^DHCINDIS(DivSubDr))
	..s TarDr=$p(mCurrRowDivSub,"^",3)
	..s ArcimDr=$p(mCurrRowDivSub,"^",2)
	..s TarCate=$p(mCurrRowDivSub,"^",14)
	..i TarCate'["药" s Flag="BC"  ;类别非药品生成BC表,否则生成BB表
	..e  s Flag="BB"
	..s DicStr=$$QueryByCode^DHCINSUDicData("CateTypeOP",TarCate)
    ..s CTUOMDr=$p(mCurrRowTarItem,"^",3),TarItemUOMDesc=""
    ..i $g(CTUOMDr)'="" s TarItemUOMDesc=$p($g(^CT("UOM",CTUOMDr)),"^",2)
	..s LSH=AdmDr          ;门急诊流水号	        
	..s YLZBH=$p(INLOCInfo,"^",3)	    ;保健号             
	..s SBCARD=InsuId	    ;社保卡号	          
	..s MJZH=AdmNO	        ;门急诊号	            
	..s YSXM=""	       ;医生姓名	          
	..s CFRQ=""	       ;处方日期   
	..s FYLB=$p(DicStr,"^",6)	        ;费用类别	          
	..s XMBM=$p($g(^DHCTARI(TarDr)),"^",1)	        ;项目编码	    
	..s XMMC=$p($g(^DHCTARI(TarDr)),"^",2)	        ;项目名称	    
	..s DW=$e(TarItemUOMDesc,1,4)	          ;单位	        
	..s SL=$j(+$p(mCurrRowDivSub,"^",11)*x,3,2)	          ;数量	        
	..s DJ=$j(+$p(mCurrRowDivSub,"^",12)*x,3,2)            ;单价	        
	..s JX=""            ;剂型
	..s GG=$$GetTarItemReguByTarItemDesc^DHCINSUFacade(ArcimDr)            ;规格
	..s TSJCZLBZ="0"	     ;特殊检查诊疗标志 0普通 1特殊
	..s TSYPBZ="0"        ;特殊药品标志 0普通 1特殊
	..s YBZF=$j(+$p(mCurrRowDivSub,"^",13)*x,3,2)         ;医保基金支付   总金额?? 
	..s GBZF=$j(+$p(mCurrRowDivSub,"^",13)*x,3,2)         ;干保统筹金支付   ??
	..s TSFY="0.00"         ;特殊医疗费用    
	..s GRZF="0.00"         ;个人现金支付    
	..s FYID="009"         ;费用性质    ??    
	..s FFXZID="004"       ;付费性质    ??  
	..s ZFBL="1"         ;个人现金支付比例 ??
	..s SJDH=""          ;本次计费中第几张申请单??
	..s CFH=""           ;本次计费中第几张处方??
	..s:x=-1 TKBZ="1"	        ;退款标志	  
	..s:x=1 TKBZ="0"
	..s TKLSH=$p(mCurrRowDiv,"^",8)	       ;结算流水号	
	..s Str1=LSH_"^"_YLZBH_"^"_SBCARD_"^"_MJZH_"^"_CFRQ_"^"_YSXM_"^"_FYLB_"^"_XMBM_"^"_XMMC_"^"_JX_"^"_DW_"^"_GG
	..s Str1=Str1_"^"_SL_"^"_DJ_"^"_YBZF_"^"_GBZF_"^"_TSFY_"^"_GRZF_"^"_FYID_"^"_FFXZID_"^"_ZFBL_"^"_TSYPBZ_"^"_CFH_"^"_TKBZ_"^"_TKLSH
	..s Str2=LSH_"^"_YLZBH_"^"_SBCARD_"^"_MJZH_"^"_YSXM_"^"_CFRQ_"^"_FYLB_"^"_XMBM_"^"_XMMC_"^"_DW_"^"_SL_"^"_DJ
	..s Str2=Str2_"^"_YBZF_"^"_GBZF_"^"_TSFY_"^"_GRZF_"^"_FYID_"^"_FFXZID_"^"_ZFBL_"^"_TSJCZLBZ_"^"_SJDH_"^"_TKBZ_"^"_TKLSH
	..i Flag="BB" d
	...s i=i+1
	...s ^DHCINSUGB("BB",$j,i)=Str1
	..i Flag="BC" d
	...s j=j+1
	...s ^DHCINSUGB("BC",$j,j)=Str2
	q $j_"|"_i_"|"_j
}

/// 生成BD表的临时Global,	门急诊结算表	(BD)
/// 还需修改
ClassMethod BuildGlobalBD(iDate As %String) As %String
{
	n (iDate)
	k ^DHCINSUGB("BD")
	s ^DHCINSUGB("BD",$j,0)="JSLSH^MJZLSH^YLZBH^XM^JZRQ^MJZH^JZCS^FYZJ^YBZFZZ^YBZFTX^GRZFYBNZZ^GRZFYBNTX^GRZFYBWZZ^GRZFYBWTX^GBZFYBNZZ^GBZFYBNTX^GBZFYBWZZ^GBZFYBWTX^ZLF^ZHLF^SCF^JCF^HYF^SPF^TSF^XYF^ZCYF^ZHCYF^QTFY^BH^TBRQ^DWFZR^CKFZR^SHR^ZBR^TKBZ^TKLSH"
    s DivDr="0",i=0
    for  s DivDr=$o(^DHCINDIV("0","IDate",iDate,DivDr)) q:DivDr=""  d
    .s JSLSH="",MJZLSH="",YLZBH="",XM="",JZRQ="",MJZH="",JZCS="",FYZJ="",YBZFZZ="",YBZFTX="",GRZFYBNZZ="",GRZFYBNTX="",GRZFYBWZZ="",GRZFYBWTX="",GBZFYBNZZ="",GBZFYBNTX="",GBZFYBWZZ="",GBZFYBWTX="",ZLF="",ZHLF="",SCF="",JCF="",HYF="",SPF="",TSF="",XYF="",ZCYF="",ZHCYF="",QTFY="",BH="",TBRQ="",DWFZR="",CKFZR="",SHR="",ZBR="",TKBZ="",TKLSH=""
    .s mCurrRowDiv=$g(^DHCINDIV(DivDr))
    .q:$p(mCurrRowDiv,"^",68)'="1" ;非干保定点结算退出
    .s INSUAdmDr=$p(mCurrRowDiv,"^",2)
    .s mCurrRowInsuAdm=$g(^DHCINADM(INSUAdmDr))
    .q:(mCurrRowInsuAdm="")
    .s AdmDr=$p(mCurrRowInsuAdm,"^",1)
    .s AdmType=$p($g(^PAADM(AdmDr)),"^",2)
    .q:(AdmType'="O")&&(AdmType'="E") ;只统计门急诊
    .s AdmNO=$p($g(^PAADM(AdmDr)),"^",81)
    .s Flag=$p(mCurrRowDiv,"^",5)
    .q:Flag="D"
    .s:Flag="S" x=-1
    .e  s x=1
    .s XString6=$p(mCurrRowInsuAdm,"^",35) ;职退情况
    .i XString6="1" s x1=1,x2=0 ;1：在职
    .i (XString6="2")||(XString6="3") s x1=0,x2=1 ;2：退休
    .s ReaId=$p($g(^PAADM(AdmDr,1)),"^",7)
    .s InsuId=$p(mCurrRowInsuAdm,"^",2)
    .s INLOCInfo=##class(web.DHCINSULOCInfo).GetLocInfoByCardNo(InsuId,ReaId)
	.s JSLSH=$p(mCurrRowDiv,"^",8)            ;结算流水号 djlsh              
	.q:JSLSH="" ;非实时结算的退出
	.s MJZLSH=AdmDr                           ;门急诊流水号            ??
	.s YLZBH=$p(INLOCInfo,"^",3)            ;保健号                  
	.s XM=$p(mCurrRowDiv,"^",27)              ;姓名	xming                  
	.s JZRQ=$p($g(^PAADM(AdmDr)),"^",6)        ;就诊日期 YYYYMMDD	              
	.s JZRQ=$zd(JZRQ,8)
	.s MJZH=AdmNO         				      ;门急诊号	           ??     
	.s JZCS=""                                ;就诊次数 ??              
	.s FYZJ=$j(+$p(mCurrRowDiv,"^",7)*x,3,2)             ;费用总计	 bcbxf 
	.s InsuPay1=+$p(mCurrRowDiv,"^",31),InsuPay2=+$p(mCurrRowDiv,"^",32)           
	.s YBZFZZ=$j((InsuPay1+InsuPay2)*x1*x,3,2)           ;医保基金支付在职        
	.s YBZFTX=$j((InsuPay1+InsuPay2)*x2*x,3,2)           ;医保基金支付退休     
	.s Zstr21=+$p(mCurrRowDiv,"^",61),Zstr22=+$p(mCurrRowDiv,"^",62),Zstr23=+$p(mCurrRowDiv,"^",63) 
	.s GRZFYBNZZ=$j((Zstr21+Zstr22+Zstr23)*x1*x,3,2)        ;个人现金支付医保内在职  
	.s GRZFYBNTX=$j((Zstr21+Zstr22+Zstr23)*x2*x,3,2)        ;个人现金支付医保内退休  
	.s GRZFYBWZZ=$j(+$p(mCurrRowDiv,"^",53)*x1*x,3,2)        ;个人现金支付医保外在职  zstr13
	.s GRZFYBWTX=$j(+$p(mCurrRowDiv,"^",53)*x2*x,3,2)        ;个人现金支付医保外退休  
	.s GBZFYBNZZ=$p(mCurrRowDiv,"^",2)        ;干保统筹金支付医保内在职???
	.s GBZFYBNTX=$p(mCurrRowDiv,"^",2)        ;干保统筹金支付医保内退休???
	.s GBZFYBWZZ=$p(mCurrRowDiv,"^",2)        ;干保统筹金支付医保外在职???
	.s GBZFYBWTX=$p(mCurrRowDiv,"^",2)        ;干保统筹金支付医保外退休???
	.s Zstr29=$p(mCurrRowDiv,"^",69)
	.s ZLF=$j(+$p(Zstr29,"|",2)*x,3,2)              ;诊疗费                  
	.s ZHLF=$j(+$p(Zstr29,"|",3)*x,3,2)             ;治疗费                  
	.s SCF=$j(+$p(Zstr29,"|",5)*x,3,2)              ;手材费                  
	.s JCF=$j(+$p(Zstr29,"|",6)*x,3,2)              ;检查费                  
	.s HYF=$j(+$p(Zstr29,"|",7)*x,3,2)              ;化验费                  
	.s SPF=$j(+$p(Zstr29,"|",8)*x,3,2)              ;摄片费                  
	.s TSF=$j(+$p(Zstr29,"|",9)*x,3,2)              ;透视费                  
	.s XYF=$j(+$p(Zstr29,"|",12)*x,3,2)              ;西药费                  
	.s ZCYF=$j(+$p(Zstr29,"|",13)*x,3,2)             ;中成药费                
	.s ZHCYF=$j(+$p(Zstr29,"|",14)*x,3,2)            ;中草药费                
	.s QTFY=$j(+$p(Zstr29,"|",15)*x,3,2)             ;其他费用                
	.s BH=""               ;编号                    
	.s TBRQ=$zd(+$h,8)             			;填报日期                
	.s DWFZR=""            ;单位负责人              
	.s CKFZR=""            ;财会负责人              
	.s SHR=""              ;审核人                  
	.s ZBR=""              ;制表人                  
	.s:x=1 TKBZ="0"             ;退款标志  
	.s:x=-1 TKBZ="1"               
	.s:x=1 TKLSH=""            ;退款流水号    
	.s:x=-1 TKLSH=$p(mCurrRowDiv,"^",8)
	.s Str=JSLSH_"^"_MJZLSH_"^"_YLZBH_"^"_XM_"^"_JZRQ_"^"_MJZH_"^"_JZCS_"^"_FYZJ_"^"_YBZFZZ_"^"_YBZFTX_"^"_GRZFYBNZZ_"^"_GRZFYBNTX_"^"_GRZFYBWZZ_"^"_GRZFYBWTX_"^"_GBZFYBNZZ_"^"_GBZFYBNTX_"^"_GBZFYBWZZ_"^"_GBZFYBWTX
	.s Str=Str_"^"_ZLF_"^"_ZHLF_"^"_SCF_"^"_JCF_"^"_HYF_"^"_SPF_"^"_TSF_"^"_XYF_"^"_ZCYF_"^"_ZHCYF_"^"_QTFY_"^"_BH_"^"_TBRQ_"^"_DWFZR_"^"_CKFZR_"^"_SHR_"^"_ZBR_"^"_TKBZ_"^"_TKLSH
	.s i=i+1     
	.s ^DHCINSUGB("BD",$j,i)=Str
    q $j_"|"_i
}

/// 生成BE表的临时Global,	门诊病房工作质量分析月报表	(BE)
/// 还需修改
ClassMethod BuildGlobalBE(iDate As %String) As %String
{
	n (iDate)
	k ^DHCINSUGB("BE")
	s ^DHCINSUGB("BE",$j,0)="SBNY^ZLZCS^MZCS^JZCS^CZCS^MAXMZRC^MINMZRC^HDCWS^QMSYCWS^DDRYRS^QCLYRS^QNRYRS^TKZRRS^QNCYRSZJ^CYBRSZJ^CYZYRS^CYHZRS^CYWYRS^CYSWRS^QNCYQTRS^ZWTKRS^QMLYRS^SJKFZCRS^PJKFCWS^SJZYZCRS^CYZZZCRS^CYZPJZYR^ZYL^HZL^BSL^BCZZL^PJBCGZR^SJBCSYL^PKZRRS^PKL^CYFYZJ^CYFYMR^CYFYMRMT^CYZXYFZJ^CYZXYFMR^MZFYZJ^MZFYYF^MZFYJC^MZFYQT^MCYZDFHRS^MCYZDBFRS^MCYZDFHL^RCYZDFHRS^RCYZDBFRS^RCYZDFHL^SSRS^SSDZFHRS^SSDZBFRS^SSDZFHL^MZDCRS^MZDCL^RYDCRS^RYDCL^CYDCRS^CYDCL^RYSRQZRS^RYSRQZL^ZBR^SHR^SJBCRQ"
    s DivDr="0",i=0
    q $j_"|"_i
}

/// 生成BF表的临时Global,	门急诊诊断明细信息表	(BF)
/// 还需修改
ClassMethod BuildGlobalBF(iDate As %String) As %String
{
	n (iDate)
	k ^DHCINSUGB("BF")
	s ^DHCINSUGB("BF",$j,0)="ZDLSH^MJZH^CZSJ^BYSL^ZDDM^ZDSM^ZDJB^ZDLX^ZDJG^ZLSD"
    s DivDr="0",i=0
    q $j_"|"_i
}

/// 生成BH表的临时Global,住院出入院表（扩充包含不结算出院的类型）
/// 还需修改
ClassMethod BuildGlobalBH(iDate As %String) As %String
{
	n (iDate)
	k ^DHCINSUGB("BH")
	s ^DHCINSUGB("BH",$j,0)="LSH^ZYH^YLZBH^SBCARD^ZYJGBZ^CZLX^KSMC^BQMC^CWBH^CZSJ^RYSQK^RYBZ^MJZLSH^CYYY^JYRQ"
    s INSUAdmDr="0",i=0
    for  s INSUAdmDr=$o(^DHCINADM("0","FunDate",iDate,INSUAdmDr)) q:INSUAdmDr=""  d
	.s LSH="",ZYH="",YLZBH="",SBCARD="",ZYJGBZ="",CZLX="",KSMC="",BQMC="",CWBH="",CZSJ="",RYSQK="",RYBZ="",MJZLSH="",CYYY="",JYRQ=""
	.s mCurrRowInsuAdm=$g(^DHCINADM(INSUAdmDr))
	.q:($p(mCurrRowInsuAdm,"^",38)'="3") ;非干保定点的退出
	.s AdmDr=$p(mCurrRowInsuAdm,"^",1)
    .s AdmType=$p($g(^PAADM(AdmDr)),"^",2)
    .q:AdmType'="I" ;只统计住院
    .s AdmNO=$p($g(^PAADM(AdmDr)),"^",81)
    .s Flag=$p(mCurrRowInsuAdm,"^",11)
    .s ReaId=$p($g(^PAADM(AdmDr,1)),"^",7)
    .s InsuId=$p(mCurrRowInsuAdm,"^",2)
    .s INLOCInfo=##class(web.DHCINSULOCInfo).GetLocInfoByCardNo(InsuId,ReaId)
    .s FunDate=$p(mCurrRowInsuAdm,"^",24),FunTime=$p(mCurrRowInsuAdm,"^",25)
    .s FunDate=$zd(FunDate,3),FunTime=$zt(FunTime,1)
    .s InsuAdmType=$p(mCurrRowInsuAdm,"^",14)
	.s LSH=AdmDr       ;住院流水号	      ??
	.s ZYH=AdmNO       ;住院号	          ??
	.s YLZBH=$p(INLOCInfo,"^",3)     ;保健号           
	.s SBCARD=InsuId    ;社保卡号	        
	.s:InsuAdmType="30" ZYJGBZ="1"    ;住院急观标志	1：住院 2：急观    
	.s:InsuAdmType="20" ZYJGBZ="2"
	.s:Flag="A" CZLX="1"      ;操作类型	0：待入院1：入院2：转科3：转病区4：转床位5：出院6：出院未结算        
	.s:Flag="O" CZLX="5"
	.s KSMC=""      ;科室名称	        
	.s BQMC=""      ;病区名称	        
	.s CWBH=""      ;床位编号	??非空        
	.s CZSJ=..ToType3ToB(FunDate,FunTime)      ;操作时间	        
	.s RYSQK=""     ;入院时情况	      
	.s RYBZ=""      ;入院标志	        
	.s MJZLSH=""    ;门急诊流水号	    
	.s CYYY=""      ;出院原因	        
	.s JYRQ=$zd(iDate,8)      ;交易日期
	.s Str=LSH_"^"_ZYH_"^"_YLZBH_"^"_SBCARD_"^"_ZYJGBZ_"^"_CZLX_"^"_KSMC_"^"_BQMC_"^"_CWBH_"^"_CZSJ_"^"_RYSQK_"^"_RYBZ_"^"_MJZLSH_"^"_CYYY_"^"_JYRQ
	.s i=i+1	        
	.s ^DHCINSUGB("BH",$j,i)=Str
	q $j_"|"_i
}

/// 生成BIBJ表的临时Global,	住院检查诊疗表(BI)  住院药品表(BJ)
/// 还需修改
ClassMethod BuildGlobalBIBJ(iDate As %String) As %String
{
	n (iDate)
	k ^DHCINSUGB("BI")
	k ^DHCINSUGB("BJ")
	s ^DHCINSUGB("BI",$j,0)="LSH^YLZBH^SBCARD^ZYH^KSMC^BQMC^CWBH^YSXM^YZ_KCRQ^YZ_ZXRQ^FYLB^XMBM^XMMC^DW^SL^DJ^YBZF^GBZF^TSFY^GRZF^FYID^FFXZID^ZFBL^TSJCZLBZ^TKBZ^TKLSH"
	s ^DHCINSUGB("BJ",$j,0)="LSH^YLZBH^SBCARD^ZYH^KSMC^BQMC^CWBH^YSXM^YZ_KCRQ^YZ_ZXRQ^FYLB^YPBM^YPMC^JX^DW^GG^SL^DJ^YBZF^GBZF^TSFY^GRZF^FYID^FFXZID^ZFBL^TSYP_BZ^TKBZ^TKLSH"
    s DivDr="0",i=0,j=0
    for  s DivDr=$o(^DHCINDIV("0","IDate",iDate,DivDr)) q:DivDr=""  d
    .s mCurrRowDiv=$g(^DHCINDIV(DivDr))
    .q:$p(mCurrRowDiv,"^",68)'="1" ;非干保定点结算退出
    .q:$p(mCurrRowDiv,"^",8)="" ;非实时结算的退出
    .s INSUAdmDr=$p(mCurrRowDiv,"^",2)
    .s mCurrRowInsuAdm=$g(^DHCINADM(INSUAdmDr))
    .q:(mCurrRowInsuAdm="")
    .s AdmDr=$p(mCurrRowInsuAdm,"^",1)
    .s AdmType=$p($g(^PAADM(AdmDr)),"^",2)
    .q:AdmType'="I" ;只统计住院
    .s Flag=$p(mCurrRowDiv,"^",5)
    .q:Flag="D"
    .s:Flag="S" x=-1
    .e  s x=1
    .s AdmNO=$p($g(^PAADM(AdmDr)),"^",81)
    .s ReaId=$p($g(^PAADM(AdmDr,1)),"^",7)
    .s InsuId=$p(mCurrRowInsuAdm,"^",2)
    .s INLOCInfo=##class(web.DHCINSULOCInfo).GetLocInfoByCardNo(InsuId,ReaId)
    .s DivSubDr="0"
    .f  s DivSubDr=$o(^DHCINDIS("0","DivideDr",DivDr,DivSubDr)) q:DivSubDr=""  d
	..s LSH="",YLZBH="",SBCARD="",ZYH="",KSMC="",BQMC="",CWBH="",YSXM="",YZKCRQ="",YZZXRQ="",FYLB="",XMBM="",XMMC="",DW="",SL="",DJ="",YBZF="",GBZF="",TSFY="",GRZF="",FYID="",FFXZID="",ZFBL="",TSJCZLBZ="",TKBZ="",TKLSH=""
	..s YPBM="",YPMC="",JX="",GG="",TSYPBZ=""
	..s mCurrRowDivSub=$g(^DHCINDIS(DivSubDr))
	..s TarDr=$p(mCurrRowDivSub,"^",3)
	..s ArcimDr=$p(mCurrRowDivSub,"^",2)
	..s TarCate=$p(mCurrRowDivSub,"^",14)
	..i TarCate'["药" s Flag="BI"  ;类别非药品生成BI表,否则生成BJ表
	..e  s Flag="BJ"
	..s DicStr=$$QueryByCode^DHCINSUDicData("CateTypeIP",TarCate)
    ..s CTUOMDr=$p(mCurrRowTarItem,"^",3),TarItemUOMDesc=""
    ..i $g(CTUOMDr)'="" s TarItemUOMDesc=$p($g(^CT("UOM",CTUOMDr)),"^",2)
	..s LSH=AdmDr          ;住院流水号	        
	..s YLZBH=$p(INLOCInfo,"^",3)	    ;保健号             
	..s SBCARD=InsuId	    ;社保卡号	          
	..s ZYH=AdmNO	        ;住院号	            
	..s KSMC=""	       ;科室名称	          
	..s BQMC=""	       ;病区名称	          
	..s CWBH=""	       ;床位编号 ??非空	          
	..s YSXM=""	       ;医生姓名	          
	..s YZKCRQ=""	     ;医嘱开出日期	      
	..s YZZXRQ=""	     ;医嘱执行日期	      
	..s FYLB=$p(DicStr,"^",6)	        ;费用类别	          
	..s XMBM=$p($g(^DHCTARI(TarDr)),"^",1)	        ;项目编码	    
	..s XMMC=$p($g(^DHCTARI(TarDr)),"^",2)	        ;项目名称	    
	..s YPBM=$p($g(^DHCTARI(TarDr)),"^",1)          ;药品编码
	..s YPMC=$p($g(^DHCTARI(TarDr)),"^",2)          ;药品名称
	..s DW=$e(TarItemUOMDesc,1,4)	          ;单位	        
	..s SL=$j(+$p(mCurrRowDivSub,"^",11)*x,3,2)	          ;数量	        
	..s DJ=$j(+$p(mCurrRowDivSub,"^",12)*x,3,2)            ;单价	        
	..s JX=""            ;剂型
	..s GG=$$GetTarItemReguByTarItemDesc^DHCINSUFacade(ArcimDr)            ;规格
	..s TSJCZLBZ="0"	     ;特殊检查诊疗标志 0普通 1特殊
	..s TSYPBZ="0"        ;特殊药品标志 0普通 1特殊
	..s YBZF=$j(+$p(mCurrRowDivSub,"^",13)*x,3,2)         ;医保基金支付   总金额?? 
	..s GBZF=$j(+$p(mCurrRowDivSub,"^",13)*x,3,2)         ;干保统筹金支付   ??
	..s TSFY="0.00"         ;特殊医疗费用    
	..s GRZF="0.00"         ;个人现金支付    
	..s FYID="009"         ;费用性质    ??    
	..s FFXZID="004"       ;付费性质    ??  
	..s ZFBL="1"         ;个人现金支付比例 ??
	..s:x=-1 TKBZ="1"	        ;退款标志	  
	..s:x=1 TKBZ="0"
	..s TKLSH=$p(mCurrRowDiv,"^",8)	       ;结算流水号	
	..s Str1=LSH_"^"_YLZBH_"^"_SBCARD_"^"_ZYH_"^"_KSMC_"^"_BQMC_"^"_CWBH_"^"_YSXM_"^"_YZKCRQ_"^"_YZZXRQ_"^"_FYLB_"^"_XMBM_"^"_XMMC_"^"_DW_"^"_SL_"^"_DJ
	..s Str1=Str1_"^"_YBZF_"^"_GBZF_"^"_TSFY_"^"_GRZF_"^"_FYID_"^"_FFXZID_"^"_ZFBL_"^"_TSJCZLBZ_"^"_TKBZ_"^"_TKLSH
	..s Str2=LSH_"^"_YLZBH_"^"_SBCARD_"^"_ZYH_"^"_KSMC_"^"_BQMC_"^"_CWBH_"^"_YSXM_"^"_YZKCRQ_"^"_YZZXRQ_"^"_FYLB_"^"_YPBM_"^"_YPMC_"^"_JX_"^"_DW_"^"_GG_"^"_SL_"^"_DJ
	..s Str2=Str2_"^"_YBZF_"^"_GBZF_"^"_TSFY_"^"_GRZF_"^"_FYID_"^"_FFXZID_"^"_ZFBL_"^"_TSYPBZ_"^"_TKBZ_"^"_TKLSH
	..i Flag="BI" d
	...s i=i+1
	...s ^DHCINSUGB("BI",$j,i)=Str1
	..i Flag="BJ" d
	...s j=j+1
	...s ^DHCINSUGB("BJ",$j,j)=Str2
	q $j_"|"_i_"|"_j
}

/// 生成BK表的临时Global,	住院病案首页表	(BK)
/// 还需修改
ClassMethod BuildGlobalBK(iDate As %String) As %String
{
	n (iDate)
	k ^DHCINSUGB("BK")
	s ^DHCINSUGB("BK",$j,0)="LSH^ZYH^YLZBH^SBCARD^HYZK^CSD^MZ^GJ^DWMC^DWDZ^DWYB^DWDH^JTDZ^JTYB^JTDH^LXRXM^LXRGX^LXRDZ^LXRDH^YLFKFS^ZYCS^RYRQ^RYSQK^RYKBBS^ZKKB^RYZDRQ^CYRQ^CYKBBS^ZYF^CWF^ZLF^HLF^XYF^ZCYF^ZHCYF^ZHLF^SSF^JCF^JYF^SXF^SYF^QTFY^YYGRMC^ZDFHQK^SSZDYS^YWGM^BDJCJG^JJCS^JJCGCS^SFBYSL^ABOXX^RHXX^SXFY^SXHXB^SXXXB^SXXJ^SXQX^SXQT^SJBL^SZ^SZQX^QTJC^CHCX^XSEXB^XSETZ^BGSM^BAZL^ZRXM^ZZYS^ZYYS^HSZ"
    s DivDr="0",i=0
    q $j_"|"_i
}

/// 生成BLBM表的临时Global,	住院医嘱信息表	(BL)  住院诊断明细信息表	(BM)
/// 还需修改
ClassMethod BuildGlobalBLBM(iDate As %String) As %String
{
	n (iDate)
	k ^DHCINSUGB("BL")
	k ^DHCINSUGB("BM")
	s ^DHCINSUGB("BL",$j,0)="YZLSH^ZYLSH^ZYH^YZNR^YZSM^JL^DW^GG^YF^PD^TS^YZLX^LX^YS^SJYS^KCSJ^ZXSJ^ZZSJ"
	s ^DHCINSUGB("BM",$j,0)="ZDLSH^ZYH^CZSJ^BYSL^ZDDM^ZDSM^ZDJB^ZDLX^ZDJG"
    s DivDr="0",i=0,j=0
    q $j_"|"_i_"|"_j
}

/// 生成BN表的临时Global,住院结算表
/// 还需修改
ClassMethod BuildGlobalBN(iDate As %String) As %String
{
	n (iDate)
	k ^DHCINSUGB("BN")
	s ^DHCINSUGB("BN",$j,0)="JSLSH^ZYLSH^YLZBH^XM^CYRQ^ZYH^ZYTS^FYZJ^YBZFZZ^YBZFTX^GRZFYBNZZ^GRZFYBNTX^GRZFYBWZZ^GRZFYBWTX^GBZFYBNZZ^GBZFYBNTX^GBZFYBWZZ^GBZFYBWTX^ZYF^ZLF^ZHLF^HLF^SCF^JCF^HYF^SPF^TSF^SXF^SYF^XYF^ZCYF^ZHCYF^QTFY^BH^TBRQ^DWFZR^CKFZR^SHR^ZBR^TKBZ^TKLSH"
    s DivDr="0",i=0
    for  s DivDr=$o(^DHCINDIV("0","IDate",iDate,DivDr)) q:DivDr=""  d
	.s JSLSH="",ZYLSH="",YLZBH="",XM="",CYRQ="",ZYH="",ZYTS="",FYZJ="",YBZFZZ="",YBZFTX="",GRZFYBNZZ="",GRZFYBNTX="",GRZFYBWZZ=""
	.s GRZFYBWTX="",GBZFYBNZZ="",GBZFYBNTX="",GBZFYBWZZ="",GBZFYBWTX="",ZYF="",ZLF="",ZHLF="",HLF="",SCF="",JCF="",HYF="",SPF="",TSF=""
	.s SXF="",SYF="",XYF="",ZCYF="",ZHCYF="",QTFY="",BH="",TBRQ="",DWFZR="",CKFZR="",SHR="",ZBR="",TKBZ="",TKLSH=""
    .s mCurrRowDiv=$g(^DHCINDIV(DivDr))
    .q:$p(mCurrRowDiv,"^",68)'="1" ;非干保定点结算退出
    .s INSUAdmDr=$p(mCurrRowDiv,"^",2)
    .s mCurrRowInsuAdm=$g(^DHCINADM(INSUAdmDr))
    .q:(mCurrRowInsuAdm="")
    .s AdmDr=$p(mCurrRowInsuAdm,"^",1)
    .s AdmType=$p($g(^PAADM(AdmDr)),"^",2)
    .q:AdmType'="I" ;只统计住院
    .s AdmNO=$p($g(^PAADM(AdmDr)),"^",81)
    .s Flag=$p(mCurrRowDiv,"^",5)
    .q:Flag="D"
    .s:Flag="S" x=-1
    .e  s x=1
    .s XString6=$p(mCurrRowInsuAdm,"^",35) ;职退情况
    .i XString6="1" s x1=1,x2=0 ;1：在职
    .i (XString6="2")||(XString6="3") s x1=0,x2=1 ;2：退休
    .s ReaId=$p($g(^PAADM(AdmDr,1)),"^",7)
    .s InsuId=$p(mCurrRowInsuAdm,"^",2)
    .s INLOCInfo=##class(web.DHCINSULOCInfo).GetLocInfoByCardNo(InsuId,ReaId)
	.s JSLSH=$p(mCurrRowDiv,"^",8)            ;结算流水号 djlsh              
	.q:JSLSH="" ;非实时结算的退出
	.s ZYLSH=AdmDr            				  ;住院流水号	     ??       
	.s YLZBH=$p(INLOCInfo,"^",3)            ;保健号                  
	.s XM=$p(mCurrRowDiv,"^",27)              ;姓名	xming                  
	.s CYRQ=$p(mCurrRowInsuAdm,"^",20)        ;出院日期 YYYYMMDD	              
	.s ZYH=AdmNO         				      ;住院号	           ??     
	.s ZYTS=$p(mCurrRowDiv,"^",20)             ;住院天数 ptbcts	              
	.s FYZJ=$j(+$p(mCurrRowDiv,"^",7)*x,3,2)             ;费用总计	 bcbxf 
	.s InsuPay1=+$p(mCurrRowDiv,"^",31),InsuPay2=+$p(mCurrRowDiv,"^",32)           
	.s YBZFZZ=$j((InsuPay1+InsuPay2)*x1*x,3,2)           ;医保基金支付在职        
	.s YBZFTX=$j((InsuPay1+InsuPay2)*x2*x,3,2)           ;医保基金支付退休     
	.s Zstr21=+$p(mCurrRowDiv,"^",61),Zstr22=+$p(mCurrRowDiv,"^",62),Zstr23=+$p(mCurrRowDiv,"^",63) 
	.s GRZFYBNZZ=$j((Zstr21+Zstr22+Zstr23)*x1*x,3,2)        ;个人现金支付医保内在职  
	.s GRZFYBNTX=$j((Zstr21+Zstr22+Zstr23)*x2*x,3,2)        ;个人现金支付医保内退休  
	.s GRZFYBWZZ=$j(+$p(mCurrRowDiv,"^",53)*x1*x,3,2)        ;个人现金支付医保外在职  zstr13
	.s GRZFYBWTX=$j(+$p(mCurrRowDiv,"^",53)*x2*x,3,2)        ;个人现金支付医保外退休  
	.s GBZFYBNZZ=$p(mCurrRowDiv,"^",2)        ;干保统筹金支付医保内在职???
	.s GBZFYBNTX=$p(mCurrRowDiv,"^",2)        ;干保统筹金支付医保内退休???
	.s GBZFYBWZZ=$p(mCurrRowDiv,"^",2)        ;干保统筹金支付医保外在职???
	.s GBZFYBWTX=$p(mCurrRowDiv,"^",2)        ;干保统筹金支付医保外退休???
	.s Zstr29=$p(mCurrRowDiv,"^",69)
	.s ZYF=$j(+$p(Zstr29,"|",1)*x,3,2)              ;住院费                  
	.s ZLF=$j(+$p(Zstr29,"|",2)*x,3,2)              ;诊疗费                  
	.s ZHLF=$j(+$p(Zstr29,"|",3)*x,3,2)             ;治疗费                  
	.s HLF=$j(+$p(Zstr29,"|",4)*x,3,2)              ;护理费                  
	.s SCF=$j(+$p(Zstr29,"|",5)*x,3,2)              ;手材费                  
	.s JCF=$j(+$p(Zstr29,"|",6)*x,3,2)              ;检查费                  
	.s HYF=$j(+$p(Zstr29,"|",7)*x,3,2)              ;化验费                  
	.s SPF=$j(+$p(Zstr29,"|",8)*x,3,2)              ;摄片费                  
	.s TSF=$j(+$p(Zstr29,"|",9)*x,3,2)              ;透视费                  
	.s SXF=$j(+$p(Zstr29,"|",10)*x,3,2)              ;输血费                  
	.s SYF=$j(+$p(Zstr29,"|",11)*x,3,2)              ;输氧费                  
	.s XYF=$j(+$p(Zstr29,"|",12)*x,3,2)              ;西药费                  
	.s ZCYF=$j(+$p(Zstr29,"|",13)*x,3,2)             ;中成药费                
	.s ZHCYF=$j(+$p(Zstr29,"|",14)*x,3,2)            ;中草药费                
	.s QTFY=$j(+$p(Zstr29,"|",15)*x,3,2)             ;其他费用                
	.s BH=""               ;编号                    
	.s TBRQ=$zd(+$h,8)             			;填报日期                
	.s DWFZR=""            ;单位负责人              
	.s CKFZR=""            ;财会负责人              
	.s SHR=""              ;审核人                  
	.s ZBR=""              ;制表人                  
	.s:x=1 TKBZ="0"             ;退款标志  
	.s:x=-1 TKBZ="1"               
	.s:x=1 TKLSH=""            ;退款流水号    
	.s:x=-1 TKLSH=$p(mCurrRowDiv,"^",8)
	.s Str=JSLSH_"^"_ZYLSH_"^"_YLZBH_"^"_XM_"^"_CYRQ_"^"_ZYH_"^"_ZYTS_"^"_FYZJ_"^"_YBZFZZ_"^"_YBZFTX_"^"_GRZFYBNZZ_"^"_GRZFYBNTX_"^"_GRZFYBWZZ_"^"_GRZFYBWTX_"^"_GBZFYBNZZ_"^"_GBZFYBNTX_"^"_GBZFYBWZZ_"^"_GBZFYBWTX
	.s Str=Str_"^"_ZYF_"^"_ZLF_"^"_ZHLF_"^"_HLF_"^"_SCF_"^"_JCF_"^"_HYF_"^"_SPF_"^"_TSF_"^"_SXF_"^"_SYF_"^"_XYF_"^"_ZCYF_"^"_ZHCYF_"^"_QTFY_"^"_BH_"^"_TBRQ_"^"_DWFZR_"^"_CKFZR_"^"_SHR_"^"_ZBR_"^"_TKBZ_"^"_TKLSH
	.s i=i+1     
	.s ^DHCINSUGB("BN",$j,i)=Str
	q $j_"|"_i
}

/// 生成BO表的临时Global,	特殊费用结算表	(BO)
/// 还需修改
ClassMethod BuildGlobalBO(iDate As %String) As %String
{
	n (iDate)
	k ^DHCINSUGB("BO")
	s ^DHCINSUGB("BO",$j,0)="JSLSH^ZYLSH^YLZBH^XM^JZLX^MJZZYH^TSYLFYZJ^GRZFBL^GRZFZZ^GRZFTX^GBZFBL^GBZFZZ^GBZFTX^ZYF^HLF^ZLF^ZHLF^SCF^JCF^HYF^SPF^TSF^XYF^ZCYF^ZHCYF^SXF^SYF^QTFY^BH^TBRQ^DWFZR^CKFZR^SHR^ZBR^TKBZ^TKLSH"
    s DivDr="0",i=0
    q $j_"|"_i
}

/// 生成BP表的临时Global,	手术报告表	(BP)
/// 还需修改
ClassMethod BuildGlobalBP(iDate As %String) As %String
{
	n (iDate)
	k ^DHCINSUGB("BP")
	s ^DHCINSUGB("BP",$j,0)="SSBH^SSBGLX^SSLX^YLZBH^SBCARD^KSMC^BQMC^CWBH^SSBM^SSMC^SSRQ^ZDYSXM^SSYZXM^SSEZXM^MZYSXM^MZFS^QKFS^QKYHDJ^BYSL^SQZD^SHZD^KNQK^JSYJ^DWYJ^KZRYJ^YYDDYJ"
    s DivDr="0",i=0
    q $j_"|"_i
}

/// 生成BQ表的临时Global,	死亡报告表	(BQ)
/// 还需修改
ClassMethod BuildGlobalBQ(iDate As %String) As %String
{
	n (iDate)
	k ^DHCINSUGB("BQ")
	s ^DHCINSUGB("BQ",$j,0)="SWBH^SWLX^CWBH^YLZBH^SBCARD^SWSJ^SWDD^SWYY^SWZD"
    s DivDr="0",i=0
    q $j_"|"_i
}

/// 生成BR表的临时Global,	会诊报告表	(BR)
/// 还需修改
ClassMethod BuildGlobalBR(iDate As %String) As %String
{
	n (iDate)
	k ^DHCINSUGB("BR")
	s ^DHCINSUGB("BR",$j,0)="HZBH^CWBH^YLZBH^SBCARD^HZRQ^HZDD^HZZCR^CJHZZJ^BZJY^HZJG"
    s DivDr="0",i=0
    q $j_"|"_i
}

/// 生成BS表的临时Global	健康报告表	(BS)
/// 还需修改
ClassMethod BuildGlobalBS(iDate As %String) As %String
{
	n (iDate)
	k ^DHCINSUGB("BS")
	s ^DHCINSUGB("BS",$j,0)="JKBGBH^CWBH^YLZBH^SBCARD^JKBGNR^TGR^TGRQ"
    s DivDr="0",i=0
    q $j_"|"_i
}

/// 生成BV表的临时Global	医疗事件报告表	(BV)
/// 还需修改
ClassMethod BuildGlobalBV(iDate As %String) As %String
{
	n (iDate)
	k ^DHCINSUGB("BV")
	s ^DHCINSUGB("BV",$j,0)="YLSJBH^SJLX^CWBH^YLZBH^SBCARD^DQZD^DSRXM^DSRZW^DSRJB^FSSJ^FSYY^YYCLYJ"
    s DivDr="0",i=0
    q $j_"|"_i
}

/// 生成BW表的临时Global	住院登记表	(BW)
/// 还需修改
ClassMethod BuildGlobalBW(iDate As %String) As %String
{
	n (iDate)
	k ^DHCINSUGB("BW")
	s ^DHCINSUGB("BW",$j,0)="DJLX^ZYH^YLZBH^LXDH^BQMC^CWBH^RYRQ^RYZD^JYBQ"
    s DivDr="0",i=0
    q $j_"|"_i
}

/// 生成BX表的临时Global	年度体检计划表	(BX)
/// 还需修改
ClassMethod BuildGlobalBX(iDate As %String) As %String
{
	n (iDate)
	k ^DHCINSUGB("BX")
	s ^DHCINSUGB("BX",$j,0)="TJNF^YLZBH^TJRQ^TJDD^REMARK"
    s DivDr="0",i=0
    q $j_"|"_i
}

/// 生成BY表的临时Global	保健对象病史表	(BY)
/// 还需修改
ClassMethod BuildGlobalBY(iDate As %String) As %String
{
	n (iDate)
	k ^DHCINSUGB("BY")
	s ^DHCINSUGB("BY",$j,0)="YLZBH^ZYZD^JYBS^ZLQK^MQZK^LYJY1^FZJC^LYJY2^YFGM^YWGM^YSXM^BSLX^BSRQ"
    s DivDr="0",i=0
    q $j_"|"_i
}

/// 生成BZ表的临时Global	转诊申请表	(BZ)
/// 还需修改
ClassMethod BuildGlobalBZ(iDate As %String) As %String
{
	n (iDate)
	k ^DHCINSUGB("BZ")
	s ^DHCINSUGB("BZ",$j,0)="ZRYYDH^YLZBH^SBCARD^ZDJZYBQ^ZGYS^KZRYJ^KZR^YYYJ^JBR^ZZSQRQ^YYSPRQ^ZZQSRQ^ZZZZRQ"
    s DivDr="0",i=0
    q $j_"|"_i
}

/// 生成CA表的临时Global	转诊费用表	(CA)
/// 还需修改
ClassMethod BuildGlobalCA(iDate As %String) As %String
{
	n (iDate)
	k ^DHCINSUGB("CA")
	s ^DHCINSUGB("CA",$j,0)="YLZBH^SBCARD^JYBQ^ZRRQ^JSRQ^FYZJ^YYSPRQ^JBR"
    s DivDr="0",i=0
    q $j_"|"_i
}

/// 生成CH表的临时Global	保健对象联系信息表（CH）
/// 还需修改
ClassMethod BuildGlobalCH(iDate As %String) As %String
{
	n (iDate)
	k ^DHCINSUGB("CH")
	s ^DHCINSUGB("CH",$j,0)="YLZBH^XM^LXDZ^LXYB^LXDH"
    s DivDr="0",i=0
    q $j_"|"_i
}

/// 生成DA表的临时Global	特殊人员门急诊费用结算表(DA)
/// 还需修改
ClassMethod BuildGlobalDA(iDate As %String) As %String
{
	n (iDate)
	k ^DHCINSUGB("DA")
	s ^DHCINSUGB("DA",$j,0)="MJZLSH^YLZBH^XM^DWMC^JZRQ^MJZH^JZCS^FYZJ^YBZFLX^YBZFSCJR^YBZFQT^ZLF^ZHLF^SCF^JCF^HYF^SPF^TSF^XYF^ZCYF^ZHCYF^QTFY^TBNO^BZJG^BH^TBRQ^DWFZR^CKFZR^SHR^ZBR^DWBM^JBR^JBRQ^TKBZ^TKLSH"
    s DivDr="0",i=0
    s DivDr="0",i=0
    for  s DivDr=$o(^DHCINDIV("0","IDate",iDate,DivDr)) q:DivDr=""  d
    .s MJZLSH="",YLZBH="",XM="",DWMC="",JZRQ="",MJZH="",JZCS="",FYZJ="",YBZFLX="",YBZFSCJR="",YBZFQT="",ZLF="",ZHLF="",SCF="",JCF="",HYF="",SPF="",TSF="",XYF="",ZCYF="",ZHCYF="",QTFY="",TBNO="",BZJG="",BH="",TBRQ="",DWFZR="",CKFZR="",SHR="",ZBR="",DWBM="",JBR="",JBRQ="",TKBZ="",TKLSH=""
    .s mCurrRowDiv=$g(^DHCINDIV(DivDr))
    .q ;???

	.s MJZLSH=""          ;门急诊流水号
	.s YLZBH=""           ;保健号
	.s XM=""              ;姓名	
	.s DWMC=""            ;单位名称
	.s JZRQ=""            ;就诊日期
	.s MJZH=""            ;门急诊号	
	.s JZCS=""            ;就诊次数
	.s FYZJ=""            ;费用总计	
	.s YBZFLX=""          ;医保统筹金支付离休
	.s YBZFSCJR=""        ;医保统筹金支付伤残军人
	.s YBZFQT=""          ;医保统筹金支付其他
	.s ZLF=""             ;诊疗费
	.s ZHLF=""            ;治疗费
	.s SCF=""             ;手材费
	.s JCF=""             ;检查费
	.s HYF=""             ;化验费
	.s SPF=""             ;摄片费
	.s TSF=""             ;透视费
	.s XYF=""             ;西药费
	.s ZCYF=""            ;中成药费
	.s ZHCYF=""           ;中草药费
	.s QTFY=""            ;其他费用
	.s TBNO=""            ;表号
	.s BZJG=""            ;编制机关
	.s BH=""              ;编号
	.s TBRQ=""            ;填报日期
	.s DWFZR=""           ;单位负责人
	.s CKFZR=""           ;财会负责人
	.s SHR=""             ;审核人
	.s ZBR=""             ;制表人
	.s DWBM=""            ;单位编码
	.s JBR=""             ;经办人
	.s JBRQ=""            ;经办日期
	.s TKBZ=""            ;退款标志
	.s TKLSH=""           ;退款流水号
	.s Str=MJZLSH_"^"_YLZBH_"^"_XM_"^"_DWMC_"^"_JZRQ_"^"_MJZH_"^"_JZCS_"^"_FYZJ_"^"_YBZFLX_"^"_YBZFSCJR_"^"_YBZFQT_"^"_ZLF_"^"_ZHLF_"^"_SCF_"^"_JCF_"^"_HYF_"^"_SPF_"^"_TSF_"^"_XYF_"^"_ZCYF_"^"_ZHCYF_"^"_QTFY
	.s Str=Str_"^"_TBNO_"^"_BZJG_"^"_BH_"^"_TBRQ_"^"_DWFZR_"^"_CKFZR_"^"_SHR_"^"_ZBR_"^"_DWBM_"^"_JBR_"^"_JBRQ_"^"_TKBZ_"^"_TKLSH
	.s i=i+1
	.s ^DHCINSUGB("DA",$j,i)=Str	
    q $j_"|"_i
}

/// 生成DB表的临时Global	特殊人员住院费用结算表(DB)
/// 还需修改
ClassMethod BuildGlobalDB(iDate As %String) As %String
{
	n (iDate)
	k ^DHCINSUGB("DB")
	s ^DHCINSUGB("DB",$j,0)="ZYLSH^YLZBH^XM^DWMC^CYRQ^ZYH^ZYTS^FYZJ^YBZFLX^YBZFSCJR^YBZFQT^ZYF^ZLF^ZHLF^HLF^SCF^JCF^HYF^SPF^TSF^SXF^SYF^XYF^ZCYF^ZHCYF^QTFY^TBNO^BZJG^BH^TBRQ^DWFZR^CKFZR^SHR^ZBR^DWBM^JBR^JBRQ^TKBZ^TKLSH"
    s DivDr="0",i=0
    q $j_"|"_i
}

/// 生成DC表的临时Global	自费门急诊费用统计表(DC)
/// 还需修改
ClassMethod BuildGlobalDC(iDate As %String) As %String
{
	n (iDate)
	k ^DHCINSUGB("DC")
	s ^DHCINSUGB("DC",$j,0)="MJZLSH^YLZBH^XM^DWMC^JZRQ^MJZH^JZCS^FYZJ^ZZ^TX^LX^QT^ZLF^ZHLF^SCF^JCF^HYF^SPF^TSF^XYF^ZCYF^ZHCYF^QTFY^TBNO^BZJG^BH^TBRQ^DWFZR^CKFZR^SHR^ZBR^TKBZ^TKLSH"
    s DivDr="0",i=0
    q $j_"|"_i
}

/// 生成DD表的临时Global	自费住院费用统计表(DD)
/// 还需修改
ClassMethod BuildGlobalDD(iDate As %String) As %String
{
	n (iDate)
	k ^DHCINSUGB("DD")
	s ^DHCINSUGB("DD",$j,0)="ZYLSH^YLZBH^XM^DWMC^CYRQ^ZYH^ZYTS^FYZJ^ZZ^TX^LX^QT^ZYF^ZLF^ZHLF^HLF^SCF^JCF^HYF^SPF^TSF^SXF^SYF^XYF^ZCYF^ZHCYF^QTFY^TBNO^BZJG^BH^TBRQ^DWFZR^CKFZR^SHR^ZBR^TKBZ^TKLSH"
    s DivDr="0",i=0
    q $j_"|"_i
}

/// 生成TA表的临时Global	体检年度计划表（TA）
/// 还需修改
ClassMethod BuildGlobalTA(iDate As %String) As %String
{
	n (iDate)
	k ^DHCINSUGB("TA")
	s ^DHCINSUGB("TA",$j,0)="YLZBH^XM^XB^SFZH^RZID^TJND^DWMC^TJRQ^YYLXR^LXRDH^ZGY^FGYZ^BZ"
    s DivDr="0",i=0
    q $j_"|"_i
}

/// 生成TB表的临时Global	保健对象体检信息表（TB）
/// 还需修改
ClassMethod BuildGlobalTB(iDate As %String) As %String
{
	n (iDate)
	k ^DHCINSUGB("TB")
	s ^DHCINSUGB("TB",$j,0)="TJLSH^TJBH^YLZBH^XM^NL^XB^CSNY^JTZZ^ZZDH^SBCARD^RZID^JBID^DWMC^ZW^TJND^TZRQ^TZFS^CJTJ^WJDM^WJYY^TJRQ^TJFS^TJJG^YSXM^TJFY^TJLX^BZ^ZGY^FGYZ"
    s DivDr="0",i=0
    q $j_"|"_i
}

/// 生成TC表的临时Global	体检医护人员信息表（TC）
/// 还需修改
ClassMethod BuildGlobalTC(iDate As %String) As %String
{
	n (iDate)
	k ^DHCINSUGB("TC")
	s ^DHCINSUGB("TC",$j,0)="XM^XB^SFZH^RYLB^RYZC^TJND^JCRC^ZGY^FGYZ"
    s DivDr="0",i=0
    q $j_"|"_i
}

/// 生成TD表的临时Global	体检疾病诊断信息表（TD）
/// 还需修改
ClassMethod BuildGlobalTD(iDate As %String) As %String
{
	n (iDate)
	k ^DHCINSUGB("TD")
	s ^DHCINSUGB("TD",$j,0)="YLZBH^XM^XB^NL^JBID^RZID^DWMC^JBBM^XTJB^TJND^EXZL^JCYS^TJLSH^CQCS^ZGY^FGYZ"
    s DivDr="0",i=0
    q $j_"|"_i
}

/// 生成TE表的临时Global	体检信息明细表（TE）
/// 还需修改
ClassMethod BuildGlobalTE(iDate As %String) As %String
{
	n (iDate)
	k ^DHCINSUGB("TE")
	s ^DHCINSUGB("TE",$j,0)="YLZBH^TJLSH^TJMXLX^TJSM^ZDDM^TJRQ^TJBH"
    s DivDr="0",i=0
    q $j_"|"_i
}

ClassMethod ToType3ToB(inDate As %String, inTime As %String) As %String
{
	n (inDate,inTime)
	s OutStr=inDate_inTime
	s OutStr=$tr(OutStr,"-","")
	s OutStr=$tr(OutStr,":","")
	q OutStr
}

Storage Default
{
<Data name="DHCINSUGBRePortDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCINSUGBRePortD</DataLocation>
<DefaultData>DHCINSUGBRePortDefaultData</DefaultData>
<IdLocation>^web.DHCINSUGBRePortD</IdLocation>
<IndexLocation>^web.DHCINSUGBRePortI</IndexLocation>
<StreamLocation>^web.DHCINSUGBRePortS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
