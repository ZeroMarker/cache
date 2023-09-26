Class web.DHCINSUPortUseBak Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 30;

/// 名称:封装其他产品组提供的各种接口
/// 描述: 
/// 编写者：刘书凤
/// 编写日期:2009 03 12 
/// Creator：      	刘书凤
/// CreatDate：    	2009 03 12
/// Description:：   函数功能、性能等的描述
/// Table：       
/// Input：        	myYBInfo=0^63^2796.77^790"_$c(2)_"6^5194.01"_$c(2)_"5^0"
/// 成功标志^InsuDivide.Rowid^个人支付^DHC_InvPrt.Rowid_$c(2)_医保支付方式^支付金额_$c(2)_医保支付方式^支付金额
/// Output：      
/// Return：      	0表示成功，其他值不成功
/// Others：      
/// myYBInfo="0^63^2796.77^790"_$c(2)_"6^5194.01"_$c(2)_"5^0"
/// ##class(web.DHCINSUPortUse).UpdateINVPRTYBInfo(myYBInfo,"")
ClassMethod UpdateINVPRTYBInfo(myYBInfo, ExpStr) As %String
{
	//s myYBInfo="0^63^2796.77^790"_$c(2)_"6^5194.01"_$c(2)_"5^0"
	s ^liusf("myYBInfo",$j)=myYBInfo
	s Flag=##class(web.DHCBillConsIF).UpdateINVPRTYBInfo(myYBInfo,"")
	s InvRowId=$p(myYBInfo,$c(2),1)
	s InvRowId=$p(InvRowId,"^",4)
	i ExpStr'="" d    //+liusf 2009 04 13
	.s UpdateInvPayMode=..UpdateInvPayMode(InvRowId,ExpStr)
	s UpdateINVPRTYBInfo=+Flag
	q UpdateINVPRTYBInfo
}

/// 说明：更新支付方式，你放在原来你调用的类里
/// Creator :yyx  ，珠海
/// CreateDate:2009-04-10
/// Function  :根据发票InvRowId,PayModeDr传入的支付方式，更新发票的第一笔支付方式，
///           当医保结算时可以在医保结算界面选择支付方式,将已经插入的支付修改成新的支付方式
/// Table     :dhc_invpaymode 
/// OutPut    :Return -1 发票rowid不存在或为空,或支付方式为空；SQLCODE为0更新成功，否则更新失败
ClassMethod UpdateInvPayMode(InvRowId, PayModeDr) As %String
{
    n (InvRowId,PayModeDr)
    q:((InvRowId="")!(PayModeDr="")) -1
    s InvPayModeRowId=InvRowId_"||"_"1"
	&sql(update sqluser.dhc_invpaymode set ipm_paymode_dr=:PayModeDr where ipm_rowid=:InvPayModeRowId)
	q SQLCODE
}

/// Creator：      	刘书凤
/// CreatDate：    	2010 02 25
/// Description:：  根据医嘱项Rowid取通用名
/// Table：       
/// Input：        	Arcim:医嘱项表的Rowid
/// Output：      
/// Return：      	通用名
/// Others：      已核实20200213
/// w ##class(web.DHCINSUPortUse).GetGeneric("11||1")
ClassMethod GetGeneric(Arcim) As %String
{
	;取通用名
	n (Arcim)
	//q:inci="" ""
	//s arcim=$p($g(^INCI(inci,1)),"^",3)
	q:Arcim="" ""
	s sub=$p(Arcim,"||",1),ver=$p(Arcim,"||",2)
	s phcdf=$p($g(^ARCIM(sub,ver,1)),"^",12) 
	q:phcdf="" ""
	s phcd=+phcdf
	s gene=$p($g(^PHCD(phcd,4)),"^",1) q:gene="" ""
	s genedesc=$p($g(^PHCGE("GE",gene)),"^",2)
	q genedesc
}

/// Creator：      	刘书凤
/// CreatDate：    	2010 03 04
/// Description:：  根据医嘱项Rowid取原料通用名
/// Table：       
/// Input：        	Arcim:医嘱项表的Rowid
/// Output：      
/// Return：      	
/// Others：珠海这个位置存的是医保的通用名。已核实20200212    
/// w ##class(web.DHCINSUPortUse).GetGeneric1("11||1")
ClassMethod getGenericYL(arcim As %String) As %String
{
	n (arcim)
	q:arcim="" ""
	s sub=$p(arcim,"||",1),ver=$p(arcim,"||",2)
	Q:sub="" ""
	Q:ver="" ""
	s phcdf=$p($g(^ARCIM(sub,ver,1)),"^",12)
	q:phcdf="" ""
	s phcd=$P(phcdf,"||",1)
	S phcdfsub=$P(phcdf,"||",2)
	Q:phcd="" ""
	Q:phcdfsub="" ""
	Q:'$D(^PHCD(phcd,"DF",phcdfsub))
	S genestr=$p(^PHCD(phcd,"DF",phcdfsub,3),"^",4)
	S RetGen=$P(genestr,"||",2)
	q RetGen
}

/// Creator：      	刘书凤
/// CreatDate：    	2010 03 01
/// Description:：  根据BillDr取住院天数
/// Table：       
/// Input：        	BillDr
/// Output：      
/// Return：      	
/// Others：上海住院天数有小数     
/// w ##class(web.DHCINSUPortUse).GetIPSumDay("11||1")
ClassMethod GetIPSumDay(BillDr As %String) As %String
{
	n (BillDr)
	s Days=0
	q:'$d(^DHCPB(BillDr)) Days
	s AdmDr=$p($g(^DHCPB(BillDr)),"^",1)
	q:AdmDr="" Days
	s DaysInfo=""
	s DaysInfo=##class(UDHCJFBaseCommon).GetPatAdmInDays(AdmDr,BillDr)
	s Days=$p(DaysInfo,"^",6)
	q Days
}

/// Creator：      	刘书凤
/// CreatDate：    	2010 06 22
/// Description:：  根据医嘱项Rowid取库存项表的Dr
/// Table：       
/// Input：        	Arcim:医嘱项表的Rowid
/// Output：      
/// Return：      	inci
/// Others：      作废20200213->新开发20200514
/// w ##class(web.DHCINSUPortUse).GetInciByARCIMDr()
ClassMethod GetInciByARCIMDrOld(ARCIMDr As %String) As %String
{
 n (ARCIMDr)
 s inci=$o(^INCI(0,"ARCIM_DR",$p(ARCIMDr,"||",1),"") )
 q inci
}

/// Creator：      	刘书凤
/// CreatDate：    	2010 06 22
/// Description:：  根据医嘱Rowid取库存项表的Dr
/// Table：       
/// Input：        	Arcim:医嘱项表的Rowid
/// Output：      
/// Return：      	inci
/// Others：      作废20200213->新开发20200514
/// w ##class(web.DHCINSUPortUse).GetInciByOrditm()
ClassMethod GetInciByOrditm(orditmRowid As %String) As %String
{
 n (orditmRowid)
 s ord=+orditmRowid
 s chl=$p(orditmRowid,"||",2)
 s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)
 s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") )
 q inci
}

/// Creator：      	刘书凤
/// CreatDate：    	2010 06 22
/// Description:：  根据医嘱项Rowid取库存项
/// Table：       
/// Input：        	Arcim:医嘱项表的Rowid
/// Output：      
/// Return：      	inci
/// Others：      作废20200213
/// w ##class(web.DHCINSUPortUse).GetInciGGByARCIMDr(29112)
ClassMethod GetInciGGByARCIMDr(ARCIMDr As %String) As %String
{
 n (ARCIMDr)
 s inci=##class(web.DHCINSUPortUse).GetInciByARCIMDr(ARCIMDr)
 s InciDesc=##class(web.DHCSTCOMMONSRV).getBarcode(inci)
 q InciDesc
}

/// Creator：      	刘书凤
/// CreatDate：    	2010 06 22
/// Description:：  根据医嘱Rowid取库存项
/// Table：       
/// Input：        	Arcim:医嘱项表的Rowid
/// Output：      
/// Return：      	inci
/// Others：      作废20200213
/// w ##class(web.DHCINSUPortUse).GetInciByARCIMDr()
ClassMethod GetInciGGByOrditmOld(orditmRowid As %String) As %String
{
 n (orditmRowid)
 s inci=##class(web.DHCINSUPortUse).GetInciByOrditm(orditmRowid)
 s InciDesc=##class(web.DHCSTCOMMONSRV).getBarcode(inci)
 q InciDesc
}

// 取草药单复方标志 Lou 2010-07-05

/// w ##class(web.DHCINSUPortUse).GetFFByPrescNo(PrescNo,OEORIDDr)
/// 有问题 把取明细时用的方法更新过来20200514
ClassMethod GetFFByPrescNo(PrescNo As %String, OEORIDDr As %String) As %String
{
	 n (PrescNo,OEORIDDr)
	 s i=0,ChildSub="0",FF=""
	 q:PrescNo="" "1"
	 f  s ChildSub=$o(^OEORD(0,"PrescNo",PrescNo,OEORIDDr,ChildSub)) q:ChildSub=""  d
	 .s i=i+1
	 i i>=2 d
	 .s FF="1"
	 e    d
	 .s FF="0"
	 q FF
}

/// 通过医嘱项目取对应的收费
/// 刘书凤 2013 03 28
/// Zhan 20181115修改，如果是药品要从药房接口取
/// w ##class(web.DHCINSUPortUse).GetTariDrByArcimRowid("1||1","")
/// 20200213待核实->
ClassMethod GetTariDrByArcimRowid(ArcimRowid, ExpStr)
{
	s TariDrStr="",ExecuDate=""
	s DrugFlag=$$GetDrugFlagBy^DHCINSUFacade(ArcimRowid)	//改为从接口取	
	i DrugFlag="1" d
	.;改为从新接口取
	.s tmptarstr=##class(web.DHCSTINTERFACE).GetTarIdByArcimDr(ArcimRowid)	//Zhan 20181115修改，如果是药品要从药房接口取
	.s TariDrStr=$LTS($LFS(tmptarstr,","),"^")
	e  d
	.f  s ExecuDate=$o(^DHCOLT(0,"ARCIM",ArcimRowid,"Z",ExecuDate)) q:ExecuDate=""  d
	..s OLTRowId=""
	..f  s OLTRowId=$o(^DHCOLT(0,"ARCIM",ArcimRowid,"Z",ExecuDate,OLTRowId)) q:OLTRowId=""  d
	...s TariDr=$P($G(^DHCOLT(OLTRowId)),"^",2) 
	...S LINKQTY=$P($G(^DHCOLT(OLTRowId)),"^",3) 
	...s EndDate=$P($G(^DHCOLT(OLTRowId)),"^",5) 
	...q:(EndDate<+$h)&&(EndDate'="")  
	...i TariDrStr="" d
	....s TariDrStr=TariDr
	...e   d
	....s TariDrStr=TariDrStr_"^"_TariDr
	q TariDrStr
}

// 调用医生站获取挂号扩展参数   具体可以参考北京代码

// 作者：刘书凤

// 

/// 有问题 DingSH 是否保留？
ClassMethod GetOPRegExpByAdmDr(AdmDr, ExpStr) As %String
{
	//s GetOPRegExpByAdmDr="^11^ ^J101.01^感冒^^^^^^^^^^^" 
	q GetOPRegExpByAdmDr
}

/// Creator?      刘书凤
/// CreatDate?    2009 12 15
/// Description:   通过医嘱项的截止日期控制收费项目是否有效
/// Table?        
/// Input?        TarDr?收费项目Rowid
/// Output?       GetTarItemActive?(Y/N)  Y表示目录需要对照
/// Return?       成功返回 0
/// Others?		作废20200213->新开发20200514
/// w $$GetTarItemActive^DHCINSUPortUse(TarDr)
ClassMethod GetTarItemActiveOld(TarDr) As %String
{
   n (TarDr)
   s GetTarItemActive="N"
   s OLTStartDate=""
   f  s OLTStartDate=$o(^DHCOLT(0,"TAR",TarDr,OLTStartDate))  q:OLTStartDate=""  d
   .s OLTRowId=""
   .f  s OLTRowId=$o(^DHCOLT(0,"TAR",TarDr,OLTStartDate,OLTRowId)) q:OLTRowId=""   d
   ..s ARCIMDR=$P($g(^DHCOLT(OLTRowId)),"^",1)
   ..q:$D(^ARCIM(+ARCIMDR,$p(ARCIMDR,"||",2)))=0
   ..s ARCIMEffDateTo=$P($g(^ARCIM(+ARCIMDR,$p(ARCIMDR,"||",2),7)),"^",1)
   ..i (ARCIMEffDateTo="")!(ARCIMEffDateTo>+$h)  d
   ...s GetTarItemActive="Y"
   q GetTarItemActive
}

/// Creator?      刘书凤
/// CreatDate?    2009 12 15
/// Description:   通过收费项是否有关联的医嘱项控制收费项目是否有效
/// Table?        
/// Input?        TarDr?收费项目Rowid
/// Output?       GetTarItemActive?(Y/N)  Y表示目录需要对照
/// Return?       成功返回 0
/// Others?		作废20200213->新开发20200514
/// w $$GetTarItemActiveByOlt^DHCINSUPortUse(TarDr)
ClassMethod GetTarItemActiveByOlt(TarDr) As %String
{
   n (TarDr)
   s GetTarItemActive="N"
   s OLTStartDate=""
   s taractflag=$p(^DHCTARI(TarDr),"^",7)
   q:taractflag="N" "N"
   f  s OLTStartDate=$o(^DHCOLT(0,"TAR",TarDr,OLTStartDate))  q:OLTStartDate=""  d
   .s OLTRowId=""
   .f  s OLTRowId=$o(^DHCOLT(0,"TAR",TarDr,OLTStartDate,OLTRowId)) q:(OLTRowId="")!(GetTarItemActive="Y")   d
   ..s ARCIMDR=$P($g(^DHCOLT(OLTRowId)),"^",1)
   ..s:($d(^ARCIM(+ARCIMDR,$p(ARCIMDR,"||",2)))'=0) GetTarItemActive="Y"
   q GetTarItemActive
}

/// Creator?      刘书凤
/// CreatDate?    2009 12 15
/// Description:   通过医嘱项子类的一些描述信息控制收费项目是否有效
/// Table?        
/// Input?        TarDr?收费项目Rowid
/// Output?       GetTarItemActive?(Y/N)  Y表示目录需要对照
/// Return?       成功返回 0
/// Others?		作废20200213->新开发20200514
/// w $$GetTarItemActive1^DHCINSUPortUse(TarDr)
ClassMethod GetTarItemActiveByARCIMItemCat(TarDr) As %String
{
   n (TarDr)
   s GetTarItemActive="N"
   s OLTStartDate=""
   f  s OLTStartDate=$o(^DHCOLT(0,"TAR",TarDr,OLTStartDate))  q:OLTStartDate=""  d
   .s OLTRowId=""
   .f  s OLTRowId=$o(^DHCOLT(0,"TAR",TarDr,OLTStartDate,OLTRowId)) q:OLTRowId=""   d
   ..s ARCIMDR=$P($g(^DHCOLT(OLTRowId)),"^",1)
   ..s ARCIMEffDateTo=$P($g(^ARCIM(+ARCIMDR,$p(ARCIMDR,"||",2),7)),"^",1)
   ..;i (ARCIMEffDateTo="")!(ARCIMEffDateTo>+$h)  d
   ..;.s GetTarItemActive="N"
   ..s ARCIMItemCatDR=$P($g(^ARCIM(+ARCIMDR,$p(ARCIMDR,"||",2),1)),"^",10)
   ..;s:ARCIMItemCatDR="" GetTarItemActive="N"
   ..q:ARCIMItemCatDR="" 
   ..s ItemCatCode=$P($g(^ARC("IC",ARCIMItemCatDR)),"^",2)
   ..i (ItemCatCode'="暂停药物")&(ItemCatCode'="未开展项目")&(ItemCatCode'="信息材料")&(ItemCatCode'="低值易耗")&(ItemCatCode'="修配材料")&(ItemCatCode'="试剂材料")   d
   ...s GetTarItemActive="Y"
   q GetTarItemActive
}

/// Creator?      刘书凤
/// CreatDate?    2009 12 15
/// Description:   通过收费项是否有关联的医嘱并且没有打上截止时间项控制收费项目是否有效
/// Table?        
/// Input?        TarDr?收费项目Rowid
/// Output?       GetTarItemActive?(Y/N)  Y表示目录需要对照
/// Return?       成功返回 0
/// Others?		作废20200213->新开发20200514
/// w $$GetTarItemActiveByOltDate^DHCINSUPortUse(17713)
ClassMethod GetTarItemActiveByOltDate(TarDr) As %String
{
   n (TarDr)
   s GetTarItemActive="N"
   s OLTStartDate=""
   f  s OLTStartDate=$o(^DHCOLT(0,"TAR",TarDr,OLTStartDate))  q:OLTStartDate=""  d
   .s OLTRowId=""
   .f  s OLTRowId=$o(^DHCOLT(0,"TAR",TarDr,OLTStartDate,OLTRowId)) q:(OLTRowId="")!(GetTarItemActive="Y")   d
   ..s ARCIMDR=$P($g(^DHCOLT(OLTRowId)),"^",1)
   ..s OLTEndDate=$P($g(^DHCOLT(OLTRowId)),"^",5)
   ..s:(OLTEndDate="")!(OLTEndDate>+$h) GetTarItemActive="Y"
   q GetTarItemActive
}

/// Descript:	取药品或材料的基础信息
/// Creater:	zhangdongliang
/// CreateDate:	2013-05-22
/// Input:		IncID(INCI_Itm表ID)     药学项表Rowid
///             ArcID(Arc_ItmMast表ID), 医嘱项表Rowid
///             gFlag(0-全部,1-药学项信息,2-医嘱项信息,3-库存项信息)
/// 			IncID和ArcID至少有一个不为空值，医嘱项信息暂时没有提供(待测试)
/// 
/// 出参：		
/// 	1~67为库存项信息
/// 			1库存项rowid^2库存项代码^3库存项描述^4基本单位描述^5入库单位描述
/// 			6类组类型^7类组描述^8库存类别^9规格^10别名
/// 			11作废标记^12用户代码^13用户名称^14库存项更新日期^15库存项更新时间
/// 			16rowid^17进口标志(描述)^18质量层次^19基本药物标志^20处方药分类
/// 			21临床验证用药标志^22中国药典标记^23质标编号^24国(省)别^25备注
/// 			26处方购药标志^27高值类标记^28院长签字标志^29用在患者头上^30定价类型
/// 			31最高售价^32售价确认标志^33售价确认用户姓名^34售价确认日期^35售价确认时间
/// 			36本院药品目录标志^37招标进价^38招标名称^39招标供应商名称^40招标生产商名称
/// 			41招标配送商名称42规格^43存储条件^44阳光采购(Y,N)^45招标级别代码
/// 			46库存项截止日期^47有效期长度^48物价文件号^49物价文件备案日期^50皮试标志(Y,N)
/// 			51账簿分类^52皮试备注(免试液、皮试液)^53用药说明^54TPN标志(Y,N)^55省基本药物标志(1是)
/// 			56市基本药物标志(1是)^57区县基本药物标志(1是)^58挂网标志^59药品本位码^60进药依据
/// 			61不可退药原因^62不可用原因^63厂商(后勤材料用)^64医保类别(材料用)^65高危标志(后勤材料用Y/N)
/// 			66大包装单位^67大包装转换因子
/// 	68~105为药学项基本信息
/// 			68药学项代码^69药学项描述^70药学大类描述^71药学子类描述^72药学最小分类描述
///  			73管制分类^74MIMS number(??)^75生产厂商^76作废标记^77商品名
///  			78处方通用名^79英文国际非专利药名名^80国际专利药名^81更新用户代码^82更新用户名称
/// 			83更新日期^84更新时间^85剂型描述^86频率代码^87频率描述
/// 			88频率系数^89用法^90疗程^91基本单位^92基本数量
/// 			93住院一天量(1或0)^94制剂通用名^95原料通用名^96门诊一天用量标记^97门诊皮试用原液
/// 			98住院皮试用液标记^99年龄限制^100DDD值^101医保剂量上传为0^102草药默认备注
/// 			103抗菌药标记(Y或N)^104高危药标记(Y或N)^105(WHONET
/// 	106~... 为医嘱项信息暂时没有提供	
/// Return：	
/// 	待核实20200213->药房提供接口；整理医保组所需要的字段，20200514
ClassMethod GetItmBaseInfo(IncID, ArcID, gFlag) As %String
{
	n (IncID,ArcID,gFlag)
	s GetItmBaseInfo=##class(web.DHCSTCOMINC).GetItmBaseInfo(IncID,ArcID,gFlag)
 	q GetItmBaseInfo
}

/// Creator      詹明超
/// CreatDate    20151223
/// Description  通过就诊号、诊断类型取病人所有诊断信息。 
/// Input        :PAADM:就诊号,DiagType:诊断类型代码.(空 获取全部,不为空 获取指定诊断代码的诊断)
///              :ExpStr:Pac_AdmReason.Rowid^InsuType^itmjs
/// Return       
/// 			空值：无诊断
/// 			诊断表ID^诊断代码表ID^诊断代码表ICD代码^ICD诊断描述^诊断注释^诊断类型描述^诊断日期^发病日期^诊断状态描述^诊断级别(数字)^医保诊断编码^医保诊断名称^是否主诊断
/// 			如果有多条诊断，以$作用行分割符
/// modify DingSH 20180316  增加 医保诊断编码^医保诊断名称
/// modify DingSH 20191029  增加是否主诊断:
/// Others
/// w ##class(web.DHCINSUPortUse).GetPatAllDiagsByADM(13,"")
ClassMethod GetPatAllDiagsByADM(PAADM As %String, DiagType As %String, ExpStr As %String = "^") As %String
{
	s retStr="",jsonStr="",itmjs=""
	s count=0
	s MRadm=$p($g(^PAADM(PAADM)),"^",61) ;指向MRADM
	Set rset=##class(%ResultSet).%New("web.DHCDocDiagnosNew:DiagnosList")
	do rset.Execute(MRadm,"",DiagType,"1") ;20160418 DingSH 医生站增加了一个入参 固定为1代表去空格
	Set columns = rset.GetColumnCount()
	
	s AdmReasonDr=$P($g(ExpStr),"^",1)
	if AdmReasonDr="" d
	.s AdmReasonDr=$p(^PAADM(PAADM,1),"^",7)
	
	s InsuType=$P($g(ExpStr),"^",2)
	s:(InsuType="") InsuType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AdmReasonDrToDLLType",AdmReasonDr,6)
	
	s itmjs=$P($g(ExpStr),"^",3) ;DingSH 20190429
	
	While (rset.Next()) {
		s DiagnosValue=rset.GetDataByName("DiagnosValue")	;诊断表ID(User.MRDiagnos)
		s DiagnosCodeRowid=rset.GetDataByName("DiagnosCodeRowid")	;诊断代码表ID(User.MRCICDDx)
		s DiagnosICDCode=rset.GetDataByName("DiagnosICDCode")	;诊断代码表ICD代码
		s DiagnosDesc=rset.GetDataByName("DiagnosDesc")	;ICD诊断描述
		s DiagnosMRDesc=rset.GetDataByName("DiagnosMRDesc")	;诊断注释
		
		s DiagnosType=rset.GetDataByName("DiagnosType")	;诊断类型描述
		s DiagnosDate=rset.GetDataByName("DiagnosDate")	;诊断日期
		s DiagnosOnsetDate=rset.GetDataByName("DiagnosOnsetDate")	;发病日期
		s DiagStat=rset.GetDataByName("DiagStat")	;诊断状态描述
		s DiagnosLeavel=rset.GetDataByName("DiagnosLeavel")	;诊断级别(数字)
		s MainDiagFlag=rset.GetDataByName("MainDiagFlag")	;是否主诊断 20191029
		s InsuDiagInfo=""
		;b ;01
		s:DiagnosCodeRowid'="" InsuDiagInfo=$$GetConInfo^DHCINSUICDContrast(DiagnosCodeRowid,InsuType,"")
		s InsuDiagCode=$P(InsuDiagInfo,"^",3) ;医保诊断编码
		s InsuDiagDesc=$P(InsuDiagInfo,"^",4) ;医保诊断描述
	    ;b ;02
	
		//continue:Flag'=0
		i retStr="" {
			s retStr=DiagnosValue_"^"_DiagnosCodeRowid_"^"_DiagnosICDCode_"^"_DiagnosDesc_"^"_DiagnosMRDesc_"^"_DiagnosType_"^"_DiagnosDate_"^"_DiagnosOnsetDate_"^"_DiagStat_"^"_DiagnosLeavel_"^"_InsuDiagCode_"^"_InsuDiagDesc_"^"_MainDiagFlag
		}else{
			s retStr=retStr_"$"_DiagnosValue_"^"_DiagnosCodeRowid_"^"_DiagnosICDCode_"^"_DiagnosDesc_"^"_DiagnosMRDesc_"^"_DiagnosType_"^"_DiagnosDate_"^"_DiagnosOnsetDate_"^"_DiagStat_"^"_DiagnosLeavel_"^"_InsuDiagCode_"^"_InsuDiagDesc_"^"_MainDiagFlag
		}
		
		i itmjs="HUIToJson" d
		.s tmpjson="{""DiagnosICDCode"":"""_DiagnosICDCode_""",""DiagnosDesc"":"""_DiagnosDesc_""",""DiagnosMRDesc"":"""_DiagnosMRDesc_""",""DiagnosType"":"""_DiagnosType_""",""DiagStat"":"""_DiagStat_""",""InsuDiagCode"":"""_InsuDiagCode_""",""InsuDiagDesc"":"""_InsuDiagDesc_""",""MainDiagFlag"":"""_MainDiagFlag_""""_"}"
		.i jsonStr="" d
		..s jsonStr=jsonStr_tmpjson
		.e  d
		..s jsonStr=jsonStr_","_tmpjson
		

	}
	d rset.Close()
   i itmjs="HUIToJson" d
   .s jsonStr="["_jsonStr_"]"
   .s retStr=jsonStr 
	Q retStr
}

/// Descript:	取药品或材料的库存扩展信息
/// Creater:	ZhanMingchao
/// CreateDate:	2015-01-08
/// Input:		IncID(INCI_Itm表ID),扩展表(DHC_ItmAddionInfo)
/// 				TarID:收费项ID
/// 				ArcID:医嘱项ID
/// Return：	ResStr=
/// 			1rowid^2进口标志(描述)^3质量层次^4基本药物标志^5处方药分类
/// 			6临床验证用药标志^7中国药典标记^8质标编号^9国(省)别^10备注(批准文号)
/// 			11处方购药标志^12高值类标记^13院长签字标志^14用在患者头上^15定价类型
/// 			16最高售价^17售价确认标志^18售价确认用户姓名^19售价确认日期^20售价确认时间
/// 			21本院药品目录标志^22招标进价^23招标名称^24招标供应商名称^25招标生产商名称
/// 			26招标配送商名称27规格^28存储条件^29阳光采购(Y,N)^30招标级别代码
/// 			31库存项截止日期^32有效期长度^33物价文件号^34物价文件备案日期^35皮试标志(Y,N)
/// 			36账簿分类^37皮试备注(免试液、皮试液)^38用药说明^39TPN标志(Y,N)^40省基本药物标志(1是)
/// 				41市基本药物标志(1是)^42区县基本药物标志(1是)^43挂网标志^44药品本位码^45进药依据
/// 				46不可退药原因^47不可用原因^48厂商(后勤材料用)^49医保类别(材料用)^50高危标志(后勤材料用Y/N)
/// 				51大包装单位^52大包装转换因子
/// 	w ##class(web.DHCINSUPortUse).GetIncAddInfo(990)
/// 	待核实20200213->药房提供接口,整理医保组所需要的字段，20200514
ClassMethod GetIncAddInfo(IncID, TarID, ArcID) As %String
{
	n (IncID,ArcID,TarID)
	q:((IncID="")&(ArcID="")&(TarID="")) "-1"
	i IncID="" d
	.i ArcID="" d
	..;s ArcID=..GetTarArcim(TarID,"")
	.q:ArcID=""
	.s IncID=##class(web.DHCSTCOMINC).GetInciID(ArcID)
	s GetIncAddInfo=##class(web.DHCSTCOMINC).GetIncAddInfo(IncID)
 	q GetIncAddInfo
}

/// 根据Pa_Adm.Rowid,获取就诊日期时间信息
///  入参:AdmRowID:Pa_adm.Rowid,ExpStr:Pac_AdmReason.Rowid^InsuType
/// 返回:就诊日期^就诊时间
/// w ##class(web.DHCINSUPortUse).GetAdminDateTime("2")
/// DingSH 2016-02-19
ClassMethod GetAdminDateTime(ADMRowID, ExpStr As %String = "") As %String
{
	n (ADMRowID,ExpStr)
	;-st DingSH 2016-04-09 非住院就诊日期和时间
	q:ADMRowID="" "^"
	q:$d(^PAADM(ADMRowID))=0 "^"
	s Type=$P(^PAADM(ADMRowID),"^",2)
	q:Type'="I" $P(^PAADM(ADMRowID),"^",6)_"^"_$P(^PAADM(ADMRowID),"^",7)
	;-ed DingSH 2016-04-09
	
	s AdmReasonDR=$P($g(ExpStr),"^",1)
	s InsuType=$P($g(ExpStr),"^",2)
	s:AdmReasonDR="" AdmReasonDR=$p(^PAADM(ADMRowID,1),"^",7)  //病人计费类别
	s:(InsuType="")&&(AdmReasonDR'="") InsuType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AdmReasonDrToDLLType",AdmReasonDR,6)
	
	s OutStr="^"
	s ADMDate=$p(^PAADM(ADMRowID),"^",6) //入院日期 
	s ADMTime=$p(^PAADM(ADMRowID),"^",7) //入院时间
	s ADMDate1="",ADMTime1=""
	i ($g(^DHCDishChargeSet("Disch","ifGetAdmDateTimeByBed"))="Y") d
	.s ADMDate1=$p(##class(web.DHCDischargeHistory).GetAdminDateTime(ADMRowID),"^",1)	;入院日期 按护理配置取值
	.s ADMTime1=$p(##class(web.DHCDischargeHistory).GetAdminDateTime(ADMRowID),"^",2)	;入院时间 按护理配置取值
	.s:InsuType="" ADMDate=ADMDate1,ADMTime=ADMTime1
	.;----Zhan 20180124,根据配置取日期--->
	.;s CTLFlag=+##class(web.DHCINSUPort).GetDicByCodeAndInd("SYS","INSUDETDATACTL",6)	;0：默认，1：取HIS，2：取护理组
	.;s:CTLFlag=2 ADMDate=ADMDate1,ADMTime=ADMTime1
	.;//Modify By DingSH 20180326
	.s CTLFlag=+##class(web.DHCINSUPort).GetDicByCodeAndInd("HISPROPerty"_InsuType,"AdmDateCtl",4)	;1：取PA_ADM.AdmDate，2：取护理组
	.s:((CTLFlag=2)&&(InsuType'="")) ADMDate=ADMDate1,ADMTime=ADMTime1
	
	
	;DingSH 20181012 如果已医保登记，取医保登记就诊时间
	s ADMDate2="",ADMTime2=""
	s InAdmDr="",ActFlag=""
	s InAdmDr=$O(^DHCINADM("0","ADM",ADMRowID,""),-1)
	s:InAdmDr'="" ActFlag=$P(^DHCINADM(InAdmDr),"^",11)
	i ((ActFlag="A")!(ActFlag="O")) d
	.s ADMDate2=$P(^DHCINADM(InAdmDr),"^",12)
	.s ADMTime2=$P(^DHCINADM(InAdmDr),"^",13)
	
	s:ADMDate2'="" ADMDate=ADMDate2,ADMTime=ADMTime2
	
	;<-------------------//
	s OutStr=ADMDate_"^"_ADMTime
    q OutStr
}

/// 根据Pa_Adm.Rowid,获取出院日期时间信息
/// 入参:AdmRowID:Pa_adm.Rowid,ExpStr:Pac_AdmReason.Rowid^InsuType
/// 返回:出院日期^出院时间
/// w ##class(web.DHCINSUPortUse).GetDischargeDateTime("2")
/// DingSH 2016-02-19
ClassMethod GetDischargeDateTime(ADMRowID, ExpStr As %String = "") As %String
{
	n (ADMRowID,ExpStr)
	s OutStr="^"
	s DischgDate1="",DischgTime1=""
	s DischgDate=$p(^PAADM(ADMRowID),"^",17) //出院日期 
	s DischgTime=$p(^PAADM(ADMRowID),"^",18) // //出院时间
	
	s AdmReasonDR=$P($g(ExpStr),"^",1)
	s InsuType=$P($g(ExpStr),"^",2)
	s:AdmReasonDR="" AdmReasonDR=$p(^PAADM(ADMRowID,1),"^",7)  //病人计费类别
	s:(InsuType="")&&(AdmReasonDR'="") InsuType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AdmReasonDrToDLLType",AdmReasonDR,6)
	
	i ($g(^DHCDishChargeSet("Disch","ifGetDischgDateTimeByDoc"))="Y") d
	.s DischgDate1=$p(##class(web.DHCDischargeHistory).GetDischargeDateTime(ADMRowID),"^",1)	;离院日期 按护理配置取值
	.s DischgTime1=$p(##class(web.DHCDischargeHistory).GetDischargeDateTime(ADMRowID),"^",2)	;离院时间 按护理配置取值
	;----Zhan 20180124,根据配置取日期--->
	;s CTLFlag=+##class(web.DHCINSUPort).GetDicByCodeAndInd("SYS","INSUDETDATACTL",6)	;0：默认，1：取HIS，2：取护理组
	;s:CTLFlag=2 DischgDate=DischgDate1,DischgTime=DischgTime1
	;//Modify By DingSH 20180326
	s CTLFlag=+##class(web.DHCINSUPort).GetDicByCodeAndInd("HISPROPerty"_InsuType,"DischDateCtl",4)	;1：取PA_ADM.DischDate，2：取护理组
	s:((CTLFlag=2)!(InsuType="")) DischgDate=DischgDate1,DischgTime=DischgTime1
	;<-------------------//
	s OutStr=DischgDate_"^"_DischgTime
    q OutStr
}

/// 根据医嘱明细表的ROWID取医嘱的数量及单位
/// 返回:数量1^基本单位名称$数量2^计价单位名称$数量3^整包装单位名称$数量4^协议包装单位名称
/// 66^g$^$396^g$396^
/// w ##class(web.DHCINSUPortUse).GetOEQty("1504||4")
/// add zdl desc 此函数截至2019-01-31 ，只有门诊审批在用。
/// Zhan 20160324
/// 	20200213除了医嘱的数据，其它数据改为调接口取；作废->找医生站要接口，20200514
ClassMethod GetOEQty(oeoriRowId) As %String
{
	n (oeoriRowId)
	s OutStr=""
	q:oeoriRowId="" OutStr
	
	s (phOrdQty,phOrdQtyDesc,jQty,jQtyDewc,pQty,pQtyDesc,xQty,xQtyDesc)=""
	s oeordId=$p(oeoriRowId,"||",1),oeoriSub=$p(oeoriRowId,"||",2)
    s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
    q:arcimId="" OutStr
	s phOrdQty=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",12)
	;b ;1
	s arcicOrderType=##Class(web.DHCCLCom).GetOrdSubCatType(oeoriRowId)
	i arcicOrderType="R" d
	.s dis=$O(^DHCOEDISQTY(0,"OEORI",oeoriRowId,0))
	.q:dis=""
	.q:'$d(^DHCOEDISQTY(dis))
	.s phOrdQty=$p(^DHCOEDISQTY(dis),"^",2)
	e  d
	.s pqty=0,pbrowid=0
	.q:$d(^DHCPBi(0,"OEORI",oeoriRowId))=0
	.f  s pbrowid=$o(^DHCPBi(0,"OEORI",oeoriRowId,pbrowid)) q:pbrowid=""  d
	..q:$d(^DHCPB(pbrowid))=10
    ..q:$d(^DHCPB(pbrowid))=0
    ..s confdr=$o(^DHCIPBillPatFeeConfirmi(0,"Bill",+pbrowid,""))
    ..s pb=pbrowid
    ..s pbosub=0
    ..f  s pbosub=$o(^DHCPBi(0,"OEORI",oeoriRowId,pbrowid,pbosub)) q:pbosub=""  d
    ...q:$d(^DHCPB(pbrowid,"O",pbosub))=10
    ...s pbo=^DHCPB(pbrowid,"O",pbosub)
    ...s pbbillqty=$p(pbo,"^",5)
    ...s pbrefundqty=$p(pbo,"^",6)
    ...s pqty=pqty+pbbillqty+pbrefundqty
	.i +pqty'=0 s Pqty=pqty
	.e  s Pqty=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",12)
	.s:Pqty>0 phOrdQty=Pqty
	;b ;2
    s PhUomDr=""
	s INCIRowid=##class(web.DHCDocOrderEntry).GetINCI(+arcimId)
	i INCIRowid'="" d
	.s BaseUOMRowid=$p($g(^INCI(INCIRowid,1)),"^",10)
	.;判断是否是草药 0 不是,1 是 则取药学项基本单位
	.s CheckCHNFlag=##class(web.DHCSTINTERFACE).GetStruModeFlag(arcimId)
	.if CheckCHNFlag="Y" d
	..S Phcdf=$P($g(^ARCIM(+arcimId,$P(arcimId,"||",2),1)),"^",12)
	..if (Phcdf'="") s PhUomDr=$p(^PHCD(+Phcdf,"DF",$p(Phcdf,"||",2),2),"^",4)
	.s:PhUomDr'="" BaseUOMRowid=PhUomDr
	.s phOrdQtyDesc=##class(web.DHCDocOrderCommon).GetUOMDesc(BaseUOMRowid)
	

	;取医嘱整包数量和单位
	s scrip=$P(arcimId,"||")
	s ver=$P(arcimId,"||",2)
	s packUomId=$P(^ARCIM(scrip,ver,8),"^",14)
	i packUomId'="" d
	.s packUomDesc=$p(^CT("UOM",packUomId),"^",2)
	.s packUomQty=$p($g(^OEORD(oeordId,"I",oeoriSub,9)),"^",4)
	.s:packUomQty'="" pQty=packUomQty,pQtyDesc=packUomDesc,xQty=packUomQty
	;b ;000
	s:PhUomDr'="" pQtyDesc=phOrdQtyDesc ;20181211  草药的使用基本单位
	i ((+pQty=0)&&(arcicOrderType="R"))  d
	.s OrderFreqRowid=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",4)
	.i OrderFreqRowid'="" s FreqFactor=$P(^PHCFR(OrderFreqRowid),"^",2)
	.e  s FreqFactor=1
	.s OrderDurRowid=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",6)
	.i OrderDurRowid'="" s DuraFactor=$P(^PHCDU(OrderDurRowid),"^",2)
	.e  s DuraFactor=1
	.;modefy by zhangdongliang at 2019-01-31 for 草药整包装数量是否应该×频率×疗程？，暂时认为不应该。 需求序号：784222
	.i OrderDurRowid'="" s pQty=+phOrdQty ;s pQty=+phOrdQty*FreqFactor*DuraFactor,xQty=pQty
	.s:pQtyDesc="" pQtyDesc=phOrdQtyDesc ;20181211 
    ;b ;001
	;取协议单位
	s ProtocolPackUOMDR=$p($g(^OEORD(oeordId,"I",oeoriSub,"DHC")),"^",13)
	i ProtocolPackUOMDR'="" d
	.s OrderPackUOMRowid=ProtocolPackUOMDR
	.s OrderPackUOM=$p($g(^CT("UOM",OrderPackUOMRowid)),"^",2)
	.s:OrderPackUOM'="" xQtyDesc=OrderPackUOM
	
	;modefy by zhangdongliang at 2018-12-14 for 暂时注释此代码,因为发现有bug,用整包装数量替换了基本单位数量.
	;举例:  需求序号:	766371
	;草药不用下面规则.
	;s:pQty>phOrdQty phOrdQty=pQty
	s CheckCHNFlag=##class(web.DHCSTINTERFACE).GetStruModeFlag(arcimId)
	i CheckCHNFlag'="Y" d
	.s:pQty>phOrdQty phOrdQty=pQty 
	;end

	;b ;3
	s OutStr=phOrdQty_"^"_phOrdQtyDesc_"$"_"^"_"$"_pQty_"^"_pQtyDesc_"$"_xQty_"^"_xQtyDesc
    q OutStr
}

/// DingSH 
/// 根据安全组取支付方式
/// 20160809
/// 出参：空 或 支付方式Rowid^支付方式Code^支付方式Desc$c(2)支付方式Rowid^支付方式Code^支付方式Desc
/// w ##class(web.DHCINSUPortUse).ReadGSPMListBroker(119,"REG")
ClassMethod ReadGSPMListBroker(GPRowID As %String = "", Type As %String = "") As %String
{
	n (GPRowID,Type)
	if Type'="" d
	.s rtn=##class(web.DHCOPAdmReg).ReadGSPMListBroker("GetPayModeToStr","",GPRowID,Type)
	e  d
	.s rtn=##class(web.UDHCJFCOMMON).ReadGSPMListBroker(GPRowID)
	q rtn
}

/// Description:通过收费项ID取药品信息 
/// Input:	收费项ID	
/// Return：	规格、基本单位、入库单位、剂型dr、剂型、厂家、每次用量(等效单位)、频次、剂量单位、批准文号 
/// Others:		医保组上传数据调用，由于入参是收费项厂家取三大项默认的，等效单位只取第一个！
/// w ##class(web.DHCINSUPortUse).GetDrugInfoByTar("1")
/// 作废20200213,统一取药品信息接口，整理字段统一接口20200514
ClassMethod GetDrugInfoByTar(TarId As %String) As %String
{
	s rtnStr="^^^^^^^^^"
	q:TarId="" rtnStr
	//-----Zhan 20191112,判断收费项是否药品-------->
	S InciId=##class(web.DHCST.INCLINKTAR).GetIncIdByTarItm(TarId)
	Q:InciId="" rtnStr
	s scgStr=##Class(web.DHCSTCOMINC).GetIncStkCatGrp(InciId)
	s scgType=$p(scgStr,"^",3)
	q:scgType'="G" rtnStr	//非药品医嘱
	//<---------------------------------------------
	q ##class(web.DHCSTINTERFACE).GetDrugInfoByTar(TarId)
}

/// 据库存项获取药品本位码
/// input: incId 库存项Dr
/// DingSH 20190320 
/// 作废20200213
ClassMethod GetInciStandardCode(InciId) As %String
{
  n (InciId)
  q:InciId="" ""
    s Info=$o(^DHCITMINFO(0,"INCI",InciId,0))
    q:Info="" ""
    s StandardCode=$p(^DHCITMINFO(Info),"^",44)
   
    q StandardCode
}

/// 据库存项获取批准文号
/// input: incId 库存项Dr
/// DingSH 20190320 
/// 作废20200213
ClassMethod GetInciRemark(InciId) As %String
{
  n (InciId)
  q:InciId="" "-"
    s Info=$o(^DHCITMINFO(0,"INCI",InciId,0))
    q:Info="" "-"
    s Remark=$p(^DHCITMINFO(Info),"^",10)
    i Remark="" s Remark="-"
    i Remark'["-" s Remark=Remark_"-"
    q Remark
}

/// 据库存项获取进口标识
/// input: incId 库存项Dr
/// DingSH 20190321
/// 作废20200213
ClassMethod GetInciImportFlag(InciId) As %String
{
  n (InciId)
   q:InciId="" ""
    s Info=$o(^DHCITMINFO(0,"INCI",InciId,0))
    q:Info="" ""
    s ImportFlag=$p(^DHCITMINFO(Info),"^",2)
   
    q ImportFlag
}

/// Descript:	根据医嘱项ID取该药品的处方药分类
/// Creator:	XuBaoBao
/// CreateDate:	2019-03-21
/// Table:      INC_Itm,ARC_ItmMast,DHC_ItmAddionInfo
/// Input:      oeori-医嘱ID		
/// Output:		
/// Return:     处方药or非处方药
/// w ##class(web.DHCINSUPortUse).GetOTCByArcimid("100||1")
/// 作废20200213,位置变了
ClassMethod GetOTCByArcimid(arcimid As %String) As %Library.String
{

	N (arcimid)
	S OTC=""
 	Q:arcimid="" OTC
 	S arcimm=$p(arcimid,"||",1)
 	Q:arcimm="" OTC
 	S inci=$O(^INCI(0,"ARCIM_DR",arcimm,""))
 	Q:inci="" OTC
    S info=$o(^DHCITMINFO(0,"INCI",inci,""))
	Q:info="" OTC
	S OTCDesc=$p(^DHCITMINFO(info),"^",5)
	S:OTCDesc="处方药" OTC="1"
	S:OTCDesc="非处方药" OTC="0"
	Q OTC
}

/// 根据库存项的ID取厂商
/// Input:		InciId-INC_Itm的ID
/// Output:		Return
/// Return：	厂商ID^厂商代码^厂商名称
/// DingSH  20190320 
/// 作废20200213
ClassMethod GetManFInfo(InciId) As %String
{
	n (InciId)
	s manf=""
	s manf=##class(web.DHCST.Common.DrugInfoCommon).GetManf(InciId)
	s:manf="" manf="^^"
	s:$P(manf,"^",3)["-" $P(manf,"^",3)=$P($P(manf,"^",3),"-",2) ;格式化：例如QLZY-齐鲁制药-->齐鲁制药
	
	q manf
}

/// w ##class(web.DHCINSUPortUse).GetManFInfoByTarCode("XWY000003")
/// w ##class(web.DHCINSUPortUse).GetManFInfoByTarCode("YP00002")
/// w ##class(web.DHCINSUPortUse).GetManFInfoByTarCode("ABGC0001(121000001)")
/// 作废20200213
ClassMethod GetManFInfoByTarCode(tCode) As %String
{
	
	 s OutStr="^^^^"
	 ;st DingSH 20181206
	 s (JXDr,JXDesc,GGDesc,PZWH,Factory)=""
	 s ARCIMDr=""
	 
	 s tmpCode=$$ALPHAUP^SSUTIL4(tCode)
	 s Subscript="",Version=""
	 s Subscript=$O(^ARCIM(0,"Code",tmpCode,""),-1)
	 i +Subscript>0 d
	 .s Version=$O(^ARCIM(0,"Code",tmpCode,Subscript,""),-1)
	 .s:+Version>0 ARCIMDr=Subscript_"||"_Version


	i +ARCIMDr>0 d
	.s TARIJXStr=$$GetjxbyArcDr^DHCINSUFacade(ARCIMDr)
	.s JXDr=$P(TARIJXStr,"^",1)
	.s JXDesc=$P(TARIJXStr,"^",2)
    .s DrugFlag=$$GetDrugFlagBy^DHCINSUFacade(ARCIMDr)
    .i +DrugFlag=1   d
    .s GGDesc=##class(web.DHCINSUPortUse).GetInciGGByARCIMDr(ARCIMDr)
    .s inciDr=##class(web.DHCINSUPortUse).GetInciByARCIMDr(ARCIMDr)
    .s PZWH=$P(##class(web.DHCINSUPortUse).GetInciRemark(inciDr),"-",1)
    .s Factory=$P(##class(web.DHCINSUPortUse).GetManFInfo(inciDr),"^",3)
    
    s OutStr=JXDr_"^"_JXDesc_"^"_GGDesc_"^"_PZWH_"^"_Factory
    
	q OutStr
}

/// Description:  根据病人就诊号获取最后呆过的床号
/// Input:        病人就诊号
/// Return:       bedcode
/// + DingSH 20200512
/// Other:  w ##class(web.DHCINSUPortUse).getPatientLastBedCode("61")
ClassMethod getPatientLastBedCode(EpisodeID) As %String
{
	n (EpisodeID)
	s BedCode=##class(Nur.Interface.OutSide.Patient).getPatientLastBedCode(EpisodeID)
	q BedCode
}

/// Description: 根据EpisodeID获取病案号,默认根据就诊号取接诊类型;当取不到病案号时,通过病人ID取"住院病案号
///       Input：EpisodeID ：就诊号
///              MedType   ：门诊（O）、急诊（E）、住院（I）
/// + DingSH 20200512
/// w ##class(web.DHCINSUPortUse).IGetMrNoByEpisodeID("44","","")
ClassMethod IGetMrNoByEpisodeID(EpisodeID As %String, MedType As %String, ByRef ErrMsg As %String) As %String
{
	n (EpisodeID,MedType,ErrMsg)
	s MrNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,MedType,.ErrMsg)
	q MrNo
}

/// Description: 根据PatientID获取住院病案号
///       Input：PatientID ：病人ID
///              MedType   ：门诊（O）、急诊（E）、住院（I）
/// + DingSH 20200512
/// w ##class(web.DHCINSUPortUse).IGetMrNoByPatientID("39","","2","")
ClassMethod IGetMrNoByPatientID(PatientID As %String, MedType As %String, HosptialID As %String, ByRef ErrMsg As %String) As %String
{
	n (PatientID,MedType,HosptialID,ErrMsg)
	s MrNo=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(PatientID,MedType,HosptialID,.ErrMsg)
	q MrNo
}

/// Description:获取院区指针
///       Input:
///               ArgVal:参数值 
///              ArgType:参数类型 目前有[AdmDr, BillDr,INVPrtDr,PEPrtDr,JustThread]取值
///               参数类型取值解释
///               AdmDr:Pa_Adm.Rowid   ,  BillDr:DHC_PatientBill.Rowid
///               INVPrtDr:DHC_INVPRT.Rowd  , PEPrtDr:DHC_PE_INVPRT.Rowid
///               JustThread:^DHCTMPACCColPRT("IP",{JustThread}) 进程号(发票集中打印)
///      Return：CTHOSPITAL.Rowid
///      DingSH  20200513
///      Others: 
///      w ##class(web.DHCINSUPortUse).GetHOSPID("8","AdmDr")
///      w ##class(web.DHCINSUPortUse).GetHOSPID("67","BillDr")
///      w ##class(web.DHCINSUPortUse).GetHOSPID("1345","INVPrtDr")
///      w ##class(web.DHCINSUPortUse).GetHOSPID("12","PEPrtDr")
///      w ##class(web.DHCINSUPortUse).GetHOSPID("14","JustThread")
ClassMethod GetHOSPID(ArgVal As %String = "", ArgType As %String = "") As %String
{
	n (ArgVal,ArgType)
	
	s HospDr = ""
	
	s ArgType=$ZCVT(ArgType,"U")
	
	//1 进程号(发票集中打印)取院区
	i ArgType="JUSTTHREAD" d
	.s ArgVal=..GetACCColFirstPRTDr(ArgVal)
	.s ArgType="INVPRTDR"
	
	//2 帐单Dr取院区
	i (ArgType="BILLDR") d
	.s ArgVal =$P(^DHCPB(ArgVal),"^",1)
	.s ArgType="ADMDR"
	
	//3 就诊Dr取院区
	i (ArgType="ADMDR") d
	.s HospDr = $P(^PAADM(ArgVal,2),"^",85) ;//PAADMHospitalDR
	.i HospDr ="" d
	..s DepCodeDR = ""
	..s DepCodeDR = $P(^PAADM(ArgVal),"^",4)
	..s:DepCodeDR'="" HospDr=$P(^CTLOC(DepCodeDR),"^",22)
	
	//4 门诊发票表Dr取院区
	i (ArgType="INVPRTDR") d
	.s HospDr = $P(^DHCINVPRT(ArgVal),"^",39)
	
	//5 体检发票表Dr取院区
	i (ArgType="PEPRTDR") d
	.s HospDr =$P(^DHCPEINVPRT(ArgVal),"^",26)
	
	

	q HospDr
}

/// Description:根据进程号(发票集中打印)获取首个发票表Rowid
///       Input:
///               JustThread: ^DHCTMPACCColPRT("GetTarArcimIP",{JustThread})
///      Return：PrtDr:DHCINVPRT.Rowid
///      DingSH  20200512
///      w ##class(web.DHCINSUPortUse).GetACCColFirstPRTDr("14")
ClassMethod GetACCColFirstPRTDr(JustThread) As %String
{
	s Flag="N",FirstInvPrtDr=""
	s AdmReasonId=""
	f  s AdmReasonId=$o(^DHCTMPACCColPRT("IP",JustThread,AdmReasonId))     q:(AdmReasonId="")||(Flag="Y")    d
	.s myIdx=""
    .f  s myIdx=$o(^DHCTMPACCColPRT("IP",JustThread,AdmReasonId,myIdx)) q:(myIdx="")||(Flag="Y")   d
    ..s tmpPrtRowID=""
    ..f  s tmpPrtRowID=$o(^DHCTMPACCColPRT("IP",JustThread,AdmReasonId,myIdx,"PrtRowID",tmpPrtRowID)) q:(tmpPrtRowID="")||(Flag="Y")  d
    ...s Flag="Y"
    ...s FirstInvPrtDr=tmpPrtRowID
    q FirstInvPrtDr
}

}
