Class web.DHCINSUPortUse Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
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
	s DaysInfo=##class(web.UDHCJFBaseCommon).GetPatAdmInDays(AdmDr,BillDr)
	s Days=$p(DaysInfo,"^",3)
	q Days
}

/// Creator：      	詹明超
/// CreatDate：    	20200515
/// Description:：  根据医嘱项Rowid取所有库存项ID
/// Table：       
/// Input：        	Arcim:医嘱项表的Rowid
/// Output：      
/// Return：      	$lb(inci1,inci2)
/// w ##class(web.DHCINSUPortUse).GetInciListByARCIMDr()
ClassMethod GetInciListByARCIMDr(ARCIMDr As %String, HospatilDr As %String) As %String
{
 n (ARCIMDr,HospatilDr)
 ;s inciList=##class(PHA.COM.Drug).GetInciListByArcim(ARCIMDr,"")
 s inciList=##class(PHA.FACE.OUT.Com).GetInciListByArcim(ARCIMDr,"")
 q inciList
}

/// Creator：      	詹明超
/// CreatDate：    	20200515
/// Description:：  根据医嘱明细表的Rowid取库存项
/// Table：       
/// Input：        	orditmRowid:医嘱明细表的Rowid
/// Output：      
/// Return：      	$lb(inci1,inci2)
/// w ##class(web.DHCINSUPortUse).GetInciListByOrditmID()
ClassMethod GetInciListByOrditmID(orditmRowid As %String, HospatilDr As %String) As %String
{
 n (orditmRowid,HospatilDr)
 s orderID=+orditmRowid
 s ordSub=$p(orditmRowid,"||",2)
 s arcimid=$p(^OEORD(orderID,"I",ordSub,1),"^",2)
 ;s inciList=##class(PHA.COM.Drug).GetInciListByArcim(arcimid,"")
 s inciList=##class(PHA.FACE.OUT.Com).GetInciListByArcim(arcimid,"")
 q inciList
}

/// 取草药单复方标志 Lou 2010-07-05
/// w ##class(web.DHCINSUPortUse).GetFFByPrescNo(PrescNo,OEORIDDr)
/// 有问题 把取明细时用的方法更新过来20200514
ClassMethod GetFFByPrescNo(PrescNo As %String, OEORIDDr As %String) As %String
{
	 n (PrescNo,OEORIDDr)
	 
	 s OEORIRowId=$p(OEORIDDr,"||",1)
	 s OEORIChildsub=$p(OEORIDDr,"||",2)
	 s ArcItmID=$p(^OEORD(OEORIRowId,"I",OEORIChildsub,1),"^",2)
	 s ADMRowID=$P(^OEORD(OEORIRowId),"^",1)
	 s HospDr = ##class(web.UDHCHospitalGroup).GetHospitalByAdm(AdmDr)
	 
    //st--是否单复方判断 DingSH 20180529
	s IsCNMedItem=##Class(web.DHCDocOrderCommon).IsCNMedItem(ArcItmID,HospDr) ;mod HospDr DingSH 20200520
	s OrderPrescNo=$P($G(^OEORD(OEORIRowId,"I",OEORIChildsub,1)),"^",14)
	s OrderPrescSeqNo=$P($G(^OEORD(OEORIRowId,"I",OEORIChildsub,1)),"^",15)
	s FF=""       ;草药单复方标识(非草药为空)
	if (IsCNMedItem=1) d 
	.i ($P(OrderPrescSeqNo,"/",2)>1) d
	..s FF=1 ;草药复方
	.e  d
	..s FF=0 ;草药单方
	//ed --是否单复方判断 DingSH 20180529
	 
	 q FF
}

/// 通过医嘱项目取对应的收费
/// 刘书凤 2013 03 28
/// Zhan 20181115修改，如果是药品要从药房接口取
/// w ##class(web.DHCINSUPortUse).GetTariDrByArcimRowid("4841||1","")
/// 20200213待核实->20200515如果是药品已改为从药房新接口取数据
ClassMethod GetTariDrByArcimRowid(ArcimRowid, ExpStr)
{
	s TariDrStr="",ExecuDate=""
	//s DrugFlag=$$GetDrugFlagBy^DHCINSUFacade(ArcimRowid)	//改为从接口取	
	;s DrugFlag=##class(PHA.COM.Drug).IsDrug(ArcimRowid,"")
	s DrugFlag=..IsDrug(ArcimRowid,"")
	i DrugFlag="1" d
	.;s tmptarstr=##class(web.DHCSTINTERFACE).GetTarIdByArcimDr(ArcimRowid)	//Zhan 20181115修改，如果是药品要从药房接口取
	.;s TariDrStr=$LTS($LFS(tmptarstr,","),"^")
	.s tmptarstr=##class(PHA.FACE.OUT.Com).GetTarListByArcim(ArcimRowid,"") //20200515如果是药品已改为从药房新接口取数据
	.;s TariDrStr=$LISTTOSTRING($LIST(tmptarstr,","),"^") 
	.s TariDrStr=$LISTTOSTRING(tmptarstr,"^") //m DingSH 20200610 
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

/// 调用医生站获取挂号扩展参数   具体可以参考北京代码
/// 作者：刘书凤
/// 有问题 DingSH 是否保留
/// 保留20200603 参考北京
///  w ##class(web.DHCINSUPortUse).GetOPRegExpByAdmDr()
ClassMethod GetOPRegExpByAdmDr(AdmDr, ExpStr) As %String
{
	//s GetOPRegExpByAdmDr="^11^ ^J101.01^感冒^^^^^^^^^^^" 
	q GetOPRegExpByAdmDr
}

/// Creator       詹明超
/// CreatDate    20200515
/// Description:   通过收费项ID判断收费项是否有效(医嘱是否有效，收费项是否有效，医嘱是否关联收费项，关联是否过期，任一项无效都返回N)
/// Table        
/// Input        TarDr收费项目Rowid,qDate日期,UnConCateStr=不进行对照的医嘱子类
/// Output       GetTarItemActiveFlag(Y/N)  Y表示项目有效，目录需要对照
/// Return       成功返回Y
/// Other	w ##class(web.DHCINSUPortUse).GetTarItemActiveFlag(1,+$h,"")
ClassMethod GetTarItemActiveFlag(TarDr As %String, TarDate As %String, HospatilDr As %String, OLTActDate As %String = "", UnConCateStr = "") As %String
{
	n (TarDr,TarDate,HospatilDr,OLTActDate,UnConCateStr)
	i OLTActDate="" d  //20220713 WangXQ
	.s OLTActDate=+$h
	
	s GetTarItemActive="N"
	s tmpActiFlag=""
	s DrugFlag=0
	s:TarDate="" TarDate=+$h
	q:TarDr="" GetTarItemActive
	s TarActFlag=$p($g(^DHCTARI(TarDr)),"^",7)	;收费项激活标志
	q:TarActFlag'="Y" GetTarItemActive
	s TmpTarDate=$p($g(^DHCTARI(TarDr)),"^",11)
	
	;q:(qDate'="")&&(qDate<TmpTarDate) GetTarItemActive // 收费项未启用 20220713 WangXQ 需要查询未启用收费项
	s TmpEndDate=$p($g(^DHCTARI(TarDr)),"^",12)
	q:(TarDate'="")&&(TarDate'<TmpEndDate)&&(TmpEndDate'="") GetTarItemActive // 收费项已截止
	;s IncList=##class(PHA.COM.Drug).GetIncListByTar(TarDr,qDate)
	s IncList=##class(PHA.FACE.OUT.Com).GetIncListByTar(TarDr,TarDate)
	f incIndex=1:1:$LISTLENGTH(IncList) d 
	.s incID=$LIST(IncList,incIndex)
	.s DrugFlag=..IsDrug("",incID)
	i DrugFlag=1 d //说明是药品
	.s GetDrugActive=##class(PHA.FACE.OUT.Com).IsValidTar(TarDr,TarDate)	//药房来判断此药品是否有效
	.s:GetDrugActive=1 tmpActiFlag="Y"
	e  d //说明是非药品
   .s OLTStartDate=""
	.;f  s OLTStartDate=$o(^DHCOLT(0,"TAR",TarDr,OLTStartDate))  q:(OLTStartDate="")||(OLTStartDate>(+$h))  d	//20220713注释
	.f  s OLTStartDate=$o(^DHCOLT(0,"TAR",TarDr,OLTStartDate))  q:(OLTStartDate="")||(OLTStartDate>OLTActDate)  d //20220713 WangXQ 需要查询未启用收费项
	..s OLTRowId=""
	..f  s OLTRowId=$o(^DHCOLT(0,"TAR",TarDr,OLTStartDate,OLTRowId)) q:(OLTRowId="")||(tmpActiFlag="Y")   d
	...s tmpActiFlag="" //xumin 值起始置为空
	...s ARCIMDR=$P($g(^DHCOLT(OLTRowId)),"^",1)
	...s oltSttDate=$P($g(^DHCOLT(OLTRowId)),"^",4)
	...;原来代码的问题：因为当将tmpActiFlag设置为N以后，下次循环的时候就会自动退出，不会再将tmpActiFlag设置为Y，
	...;会造成只要收费项对应的医嘱项，有一条失效就直接返回失效，违背了原来的意思；  
	...;应该是收费项对应的医嘱项有一条有效，就返回有效才对
	...;s:(oltSttDate'="")&(oltSttDate>(+$h)) tmpActiFlag="N"	//关联关系未生效
    ...b ;345
	...//q:(oltSttDate'="")&(oltSttDate>(+$h)) 	//关联关系未生效
	...q:(oltSttDate'="")&(oltSttDate>(+OLTActDate)) 	//关联关系未生效 20220713 
	...s OLTEndDate=$P($g(^DHCOLT(OLTRowId)),"^",5)
	...//q:(OLTEndDate'="")&(OLTEndDate'>(+$h)) 	//关联关系截止
	...q:(OLTEndDate'="")&(OLTEndDate'>(+OLTActDate)) 	//关联关系截止 20220713 
	...;q:tmpActiFlag="N"
	...s ItemCatCode=""
	...s ARCIMItemCatDR=$P($g(^ARCIM(+ARCIMDR,$p(ARCIMDR,"||",2),1)),"^",10)
	...s:ARCIMItemCatDR'="" ItemCatCode=$P($g(^ARC("IC",ARCIMItemCatDR)),"^",2)
	...;医嘱项分类加配置？？？？
	...q:((UnConCateStr'="")&&(("^"_UnConCateStr_"^")[("^"_ARCIMItemCatDR_"^"))) //2023-4-25 tangzf add 通用配置-医保基础信息-不进行对照的项目-医嘱子类
	...///xm 2021-08-17 i (ItemCatCode="暂停药物")||(ItemCatCode="未开展项目")||(ItemCatCode="信息材料")||(ItemCatCode="修配材料")||(ItemCatCode="试剂材料")   d
	...q:(ItemCatCode="暂停药物")||(ItemCatCode="未开展项目")||(ItemCatCode="信息材料")||(ItemCatCode="修配材料")  
	...;.s tmpActiFlag=tmpActiFlag_"N"
	...;q:tmpActiFlag="N"	//排除的医嘱分类
	...q:($d(^ARCIM(+ARCIMDR,$p(ARCIMDR,"||",2)))=0) 	//没有关联收费项
	...;q:tmpActiFlag="N"
	...s ARCIMEffDateTo=$P($g(^ARCIM(+ARCIMDR,$p(ARCIMDR,"||",2),7)),"^",1)
	...//q:(ARCIMEffDateTo'="")&(ARCIMEffDateTo'>+$h)  //d	//医嘱项截止
	...q:(ARCIMEffDateTo'="")&(ARCIMEffDateTo'>+OLTActDate)  //d	//医嘱项截止 20220713 
	...;.;s tmpActiFlag="N"
	...;q:tmpActiFlag="N"
	...s tmpActiFlag="Y"	;只要有一个有效就认为有效
	i tmpActiFlag="Y"  d
	.s GetTarItemActive="Y"
	e  d
	.s GetTarItemActive="N"
	q GetTarItemActive
}

/// Creator      詹明超
/// CreatDate    20151223
/// Description  通过就诊号、诊断类型取病人所有诊断信息。 
/// Input        :PAADM:就诊号,DiagType:诊断类型代码.(空 获取全部,不为空 获取指定诊断代码的诊断)
///              :ExpStr:Pac_AdmReason.Rowid^InsuType^itmjs
/// Return       
/// 			空值：无诊断
/// 			诊断表ID^诊断代码表ID^诊断代码表ICD代码^ICD诊断描述^诊断注释^诊断类型描述^诊断日期^发病日期^诊断状态描述^诊断级别(数字)^医保诊断编码^医保诊断名称^是否主诊断^诊断前缀^诊断序号^诊断科室Dr^诊断科室代码^诊断科室描述^诊断医生编码^诊断医生姓名^诊断时间^诊断分类(医保)^结构化诊断描述^国家医师编码
/// 			如果有多条诊断，以$作用行分割符
/// modify DingSH 20180316  增加 医保诊断编码^医保诊断名称
/// modify DingSH 20191029  增加是否主诊断:
/// modify DingSH 20200924  增加诊断序号,诊断序号^诊断科室Dr^诊断科室代码^诊断科室描述^诊断医生编码^诊断医生姓名^诊断时间
/// modify DingSH 20220107  增加 SDSDesc  结构化诊断描述	由基础数据平台返回的结构化诊断信息 
/// modify DingSH 20220830  国家医师编码
/// Others
/// w ##class(web.DHCINSUPortUse).GetPatAllDiagsByADM(5258,"","^00A^")
/// w ##class(web.DHCINSUPortUse).GetPatAllDiagsByADM(5258,"","^00A^HUIToJson")
ClassMethod GetPatAllDiagsByADM(PAADM As %String, DiagType As %String, ExpStr As %String = "^") As %String
{
	n (PAADM,DiagType,ExpStr)
	s retStr="",jsonStr="",itmjs=""
	s count=0
	s MRadm=$p($g(^PAADM(PAADM)),"^",61) ;指向MRADM
	//Set rset=##class(%ResultSet).%New("web.DHCDocDiagnosNew:DiagnosList")
	//do rset.Execute(MRadm,"",DiagType,"1") ;20160418 DingSH 医生站增加了一个入参 固定为1代表去空格
	
	//ICDType	显示类型.(1:仅显示中医,2:仅显示西医，空:全部)
	new rset
	s rset=##class(%ResultSet).%New("DHCDoc.Interface.Inside.Service:DiagnosList")
	s ICDType=$P($g(ExpStr),"^",4)
	do rset.Execute(MRadm,ICDType,DiagType) ;20220107 DingSH 
	s columns = rset.GetColumnCount()
	s AdmReasonDr=$P($g(ExpStr),"^",1)
	if AdmReasonDr="" d
	.s AdmReasonDr=$p(^PAADM(PAADM,1),"^",7)
	s HospDr = ##class(web.UDHCHospitalGroup).GetHospitalByAdm(PAADM) //+ DingSH 20200526
	s InsuType=$P($g(ExpStr),"^",2)
	s:(InsuType="") InsuType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AdmReasonDrToDLLType",AdmReasonDr,6,HospDr)
	s itmjs=$P($g(ExpStr),"^",3) ;DingSH 20190429
	#dim lstDataAry As %ListOfDataTypes 
	i $zcvt(itmjs,"U") ="HUITOJSON" d       //DingSH 20210910
	.s lstDataAry =  ##class(%ListOfDataTypes).%New()
	
	While (rset.Next()) {
		s DiagnosValue=rset.GetDataByName("DiagnosValue")	        ;诊断表ID(User.MRDiagnos)
		s DiagnosCodeRowid=rset.GetDataByName("DiagnosCodeRowid")	;诊断代码表ID(User.MRCICDDx)
		s DiagnosICDCode=rset.GetDataByName("DiagnosICDCode")	    ;诊断代码表ICD代码
		s DiagnosDesc=rset.GetDataByName("DiagnosDesc")          	;ICD诊断描述
		s DiagnosDesc=$replace(DiagnosDesc,"&nbsp","")              
		s DiagnosMRDesc=rset.GetDataByName("DiagnosMRDesc")	        ;诊断注释
		s DiagnosType=rset.GetDataByName("DiagnosType")	            ;诊断类型描述
		s DiagnosDate=rset.GetDataByName("DiagnosDate")	            ;诊断日期
		s DiagnosOnsetDate=rset.GetDataByName("DiagnosOnsetDate")	;发病日期
		s DiagStat=rset.GetDataByName("DiagStat")	                ;诊断状态描述
		s DiagnosLeavel=rset.GetDataByName("DiagnosLeavel")	        ;诊断级别(数字)
		s MainDiagFlag=rset.GetDataByName("MainDiagFlag")	        ;是否主诊断 20191029
		s DiagnosPrefix=rset.GetDataByName("DiagnosPrefix")	        ;诊断前缀 20200923 DingSH
		s DiagnosNumber = rset.GetDataByName("DiagnosNumber")	    ;诊断序号        20200924 DingSH
		s MRDIAAddLocDr = rset.GetDataByName("MRDIAAddLocDr")	    ;诊断科室Dr      20200924 DingSH
		s MRDIAAddLocCode="",MRDIAAddLocDesc=""
		i (MRDIAAddLocDr'="")
		{
		 s MRDIAAddLocCode = $P(^CTLOC(MRDIAAddLocDr),"^",1)        ;诊断科室代码   20200924 DingSH
		 s MRDIAAddLocDesc = $P(^CTLOC(MRDIAAddLocDr),"^",2)        ;诊断科室描述   20200924 DingSH
		}
		s MRDIADocCode = rset.GetDataByName("MRDIADocCode")	        ;诊断医生代码   20200924 DingSH
		s MRDIADocDesc = rset.GetDataByName("MRDIADocDesc")	        ;诊断医生姓名   20200924 DingSH
		s MRdiagnosTime = rset.GetDataByName("MRdiagnosTime")	    ;诊断时间       20200924 DingSH
		s DiagnosCat=rset.GetDataByName("DiagnosCat")               ;分类	西医、中医、证型
		s SDSDesc=rset.GetDataByName("SDSDesc")                     ;结构化诊断描述	由基础数据平台返回的结构化诊断信息 20220107 DingSH
		s InsuDiagInfo=""
		//取诊断医保医师信息
		s MRDIADocUnit=""   
		i MRDIADocCode'=""{
		   s MRDIADocId=$o(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(MRDIADocCode),""),-1)
		   i MRDIADocId'=""{
		      s MRDIADocUnit=$P(##class(web.DHCINSUBase).GetStdInfoByCareProvDR(MRDIADocId,HospDr),"^",1)
		   }
		}
		//取医保诊断信息
		s:DiagnosCodeRowid'="" InsuDiagInfo=$$GetConInfo^DHCINSUICDContrast(DiagnosCodeRowid,InsuType,"",HospDr)
		s InsuDiagCode=$P(InsuDiagInfo,"^",3)                       ;医保诊断编码
		s InsuDiagDesc=$P(InsuDiagInfo,"^",4)                       ;医保诊断描述
		//+HanZH 20221028
		s InsuDiagCate=$P(InsuDiagInfo,"^",8)                       ;医保诊断病种类别(M:慢特病病种; B:按病种结算病种; R:日间手术病种)
		s InsuDiagSubCate=$P(InsuDiagInfo,"^",9)                    ;医保诊断病种对应的就诊类型和医疗类别INDIS_SubCate IP|52
    	
    	//s MRdiagnosTime=$replace(MRdiagnosTime,"AM","")           //需要给项目反馈

		i (DiagnosNumber="")
		{
			s DiagnosNumber=$p(DiagnosCodeRowid,"||",2)
		}	
		//取医保诊断类别（diag_type 1:西医主要诊断,2:西医其他诊断,3:中医主病诊断,4:中医主证诊断）
   		s DiagnosSign=""   //诊断类别(医保)
		i DiagnosCat = "西医" do
		.i MainDiagFlag="Y" s DiagnosSign=1
		.e  s DiagnosSign=2
		i DiagnosCat="中医" do
		.s DiagnosSign=3
		i DiagnosCat="证型" do
		.s DiagnosSign=4

        //日期时间格式转换          
        i DiagnosDate'="" {     ;诊断日期
            s DiagnosDate = ##class(websys.Conversions).DateHtmlToLogical(DiagnosDate)
			s DiagnosDate = $zd(DiagnosDate,3)
		}
		i DiagnosOnsetDate'="" { ;发病日期
            s DiagnosOnsetDate = ##class(websys.Conversions).DateHtmlToLogical(DiagnosOnsetDate)
			s DiagnosOnsetDate = $zd(DiagnosOnsetDate,3)
		}
	    i MRdiagnosTime'="" { ;诊断时间 
            s MRdiagnosTime = ##class(websys.Conversions).TimeHtmlToLogical(MRdiagnosTime)
			s MRdiagnosTime = $zt(MRdiagnosTime,1)
		}
		//continue:Flag'=0
		s rowData=DiagnosValue_"^"_DiagnosCodeRowid_"^"_DiagnosICDCode_"^"_DiagnosDesc_"^"_DiagnosMRDesc_"^"_DiagnosType_"^"_DiagnosDate_"^"_DiagnosOnsetDate_"^"_DiagStat_"^"_DiagnosLeavel_"^"_InsuDiagCode_"^"_InsuDiagDesc_"^"_MainDiagFlag_"^"_DiagnosPrefix_"^"_DiagnosNumber_"^"_MRDIAAddLocDr_"^"_MRDIAAddLocCode_"^"_MRDIAAddLocDesc_"^"_MRDIADocCode_"^"_MRDIADocDesc_"^"_MRdiagnosTime_"^"_DiagnosSign_"^"_SDSDesc_"^"_MRDIADocUnit
		i retStr="" {
			s retStr=rowData
		    //s retStr=DiagnosValue_"^"_DiagnosCodeRowid_"^"_DiagnosICDCode_"^"_DiagnosDesc_"^"_DiagnosMRDesc_"^"_DiagnosType_"^"_DiagnosDate_"^"_DiagnosOnsetDate_"^"_DiagStat_"^"_DiagnosLeavel_"^"_InsuDiagCode_"^"_InsuDiagDesc_"^"_MainDiagFlag_"^"_DiagnosPrefix_"^"_DiagnosNumber_"^"_MRDIAAddLocDr_"^"_MRDIAAddLocCode_"^"_MRDIAAddLocDesc_"^"_MRDIADocCode_"^"_MRDIADocDesc_"^"_MRdiagnosTime_"^"_DiagnosSign_"^"_SDSDesc_"^"_MRDIADocUnit
		}else{
			s retStr=retStr_"$"_rowData
			//s retStr=retStr_"$"_DiagnosValue_"^"_DiagnosCodeRowid_"^"_DiagnosICDCode_"^"_DiagnosDesc_"^"_DiagnosMRDesc_"^"_DiagnosType_"^"_DiagnosDate_"^"_DiagnosOnsetDate_"^"_DiagStat_"^"_DiagnosLeavel_"^"_InsuDiagCode_"^"_InsuDiagDesc_"^"_MainDiagFlag_"^"_DiagnosPrefix_"^"_DiagnosNumber_"^"_MRDIAAddLocDr_"^"_MRDIAAddLocCode_"^"_MRDIAAddLocDesc_"^"_MRDIADocCode_"^"_MRDIADocDesc_"^"_MRdiagnosTime_"^"_DiagnosSign_"^"_SDSDesc_"^"_MRDIADocUnit
		}
		i $zcvt(itmjs,"U") ="HUITOJSON" d //DingSH 20210910
		.s dataAry=  ##class(%ArrayOfDataTypes).%New()
		.d dataAry.SetAt(DiagnosICDCode,"DiagnosICDCode")
		.s DiagnosDesc=DiagnosDesc
		.d dataAry.SetAt(DiagnosDesc,"DiagnosDesc")
		.d dataAry.SetAt(DiagnosMRDesc,"DiagnosMRDesc")
		.d dataAry.SetAt(DiagnosType,"DiagnosType")
		.d dataAry.SetAt(DiagStat,"DiagStat")
		.d dataAry.SetAt(InsuDiagCode,"InsuDiagCode")
		.d dataAry.SetAt(InsuDiagDesc,"InsuDiagDesc")
		.d dataAry.SetAt(MainDiagFlag,"MainDiagFlag")
		.d dataAry.SetAt(DiagnosPrefix,"DiagnosPrefix")
		.d dataAry.SetAt(DiagnosNumber,"DiagnosNumber")
		.d dataAry.SetAt(MRDIAAddLocDr,"MRDIAAddLocDr")
		.d dataAry.SetAt(MRDIAAddLocCode,"MRDIAAddLocCode")
		.d dataAry.SetAt(MRDIAAddLocDesc,"MRDIAAddLocDesc")
		.d dataAry.SetAt(MRDIADocCode,"MRDIADocCode")
		.d dataAry.SetAt(MRDIADocDesc,"MRDIADocDesc")
		.d dataAry.SetAt(DiagnosDate,"DiagnosDate")
		.d dataAry.SetAt(DiagnosOnsetDate,"DiagnosOnsetDate")
		.d dataAry.SetAt(MRdiagnosTime,"MRdiagnosTime")
		.d dataAry.SetAt(DiagnosSign,"DiagnosSign")
		.d dataAry.SetAt(SDSDesc,"SDSDesc")                 //+DingSH 20220107
		.d dataAry.SetAt(MRDIADocUnit,"MRDIADocUnit")       //+DingSH 20220830
		.d dataAry.SetAt(InsuDiagCate,"InsuDiagCate") 		//+HanZH 20221028
		.d dataAry.SetAt(InsuDiagSubCate,"InsuDiagSubCate") //+HanZH 20221028
		.d lstDataAry.Insert(dataAry)
		.//s tmpjson="{""DiagnosICDCode"":"""_DiagnosICDCode_""",""DiagnosDesc"":"""_DiagnosDesc_""",""DiagnosMRDesc"":"""_DiagnosMRDesc_""",""DiagnosType"":"""_DiagnosType_""",""DiagStat"":"""_DiagStat_""",""InsuDiagCode"":"""_InsuDiagCode_""",""InsuDiagDesc"":"""_InsuDiagDesc_""",""MainDiagFlag"":"""_MainDiagFlag_""",""DiagnosPrefix"":"""_DiagnosPrefix_""",""DiagnosNumber"":"""_DiagnosNumber_""",""MRDIAAddLocDr"":"""_MRDIAAddLocDr_""",""MRDIAAddLocCode"":"""_MRDIAAddLocCode_""",""MRDIAAddLocDesc"":"""_MRDIAAddLocDesc_""",""MRDIADocCode"":"""_MRDIADocCode_""",""MRDIADocDesc"":"""_MRDIADocDesc_""",""MRdiagnosTime"":"""_MRdiagnosTime_""""_"}"
		.//i jsonStr="" d
		.//.s jsonStr=jsonStr_tmpjson
		.//e  d
		.//.s jsonStr=jsonStr_","_tmpjson
	}
   d rset.Close()
   k rset
   i $zcvt(itmjs,"U") ="HUITOJSON" d //DingSH 20210910
   .//s jsonStr="["_jsonStr_"]"
   .s jsonStr=##class(web.INSUCacheJSON).Encode(lstDataAry)
   .s retStr=jsonStr 
	Q retStr
}

/// 根据Pa_Adm.Rowid,获取就诊日期时间信息
///  入参:AdmRowID:Pa_adm.Rowid,ExpStr:Pac_AdmReason.Rowid^InsuType
/// 返回:就诊日期^就诊时间
/// w ##class(web.DHCINSUPortUse).GetAdminDateTime("3790")
/// DingSH 2016-02-19
ClassMethod GetAdminDateTime(ADMRowID, ExpStr As %String = "") As %String
{
	n (ADMRowID,ExpStr)
	;-st DingSH 2016-04-09 非住院就诊日期和时间
	q:ADMRowID="" "^"
	q:$d(^PAADM(ADMRowID))=0 "^"
	s Type=$P(^PAADM(ADMRowID),"^",2)
	s ADMDate=$p(^PAADM(ADMRowID),"^",6) //入院日期 
	s ADMTime=$p(^PAADM(ADMRowID),"^",7) //入院时间
	
	/*非住院就诊日期和时间取值*/
	q:Type'="I" ADMDate_"^"_ADMTime
	;-ed DingSH 2016-04-09
	
	s HospDr = ##class(web.UDHCHospitalGroup).GetHospitalByAdm(ADMRowID) //+ DingSH 20200526
	s AdmReasonDR=$P($g(ExpStr),"^",1)
	s InsuType=$P($g(ExpStr),"^",2)
	s:AdmReasonDR="" AdmReasonDR=$p(^PAADM(ADMRowID,1),"^",7)  //病人计费类别
	s:(InsuType="")&&(AdmReasonDR'="") InsuType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AdmReasonDrToDLLType",AdmReasonDR,6,HospDr)
	s OutStr="^"
	
	;-st DingSH 20181012 如果已医保登记，取医保登记就诊时间
	s InAdmDr="",ActFlag="",Flag=0
	s InAdmDr=$O(^DHCINADM("0","ADM",ADMRowID,""),-1)
	s:InAdmDr'="" ActFlag=$P(^DHCINADM(InAdmDr),"^",11)
	i ((ActFlag="A")!(ActFlag="O")) d
	.s ADMDate=$P(^DHCINADM(InAdmDr),"^",12)
	.s ADMTime=$P(^DHCINADM(InAdmDr),"^",13)
	.s Flag=1
	
	/*医保已登记就诊日期和时间取值*/
	q:+Flag=1 ADMDate_"^"_ADMTime
	;-ed DingSH 20181012

    /*根据医保字典配置就诊日期和时间取值*/
 	s CTLFlag=+##class(web.INSUDicDataCom).GetDicByCodeAndInd("HISPROPerty"_InsuType,"AdmDateCtl",4,HospDr)	;1：取PA_ADM.AdmDate，2：取护理组
	q:((CTLFlag'=2)&&(InsuType'="")) ADMDate_"^"_ADMTime 


	/*护理接口取就诊日期和时间取值*/
	s ADMDate=$p(##class(web.DHCDischargeHistory).GetAdminDateTime(ADMRowID),"^",1)	;入院日期 
	s ADMTime=$p(##class(web.DHCDischargeHistory).GetAdminDateTime(ADMRowID),"^",2)	;入院时间 

	s OutStr=ADMDate_"^"_ADMTime
    q OutStr
}

/// 根据Pa_Adm.Rowid,获取出院日期时间信息
/// 入参:AdmRowID:Pa_adm.Rowid,ExpStr:Pac_AdmReason.Rowid^InsuType
/// 返回:出院日期^出院时间
/// w ##class(web.DHCINSUPortUse).GetDischargeDateTime("3790")
/// DingSH 2016-02-19
ClassMethod GetDischargeDateTime(ADMRowID, ExpStr As %String = "") As %String
{
	n (ADMRowID,ExpStr)
	s OutStr="^"
	s DischgDate1="",DischgTime1=""
	s DischgDate=$p(^PAADM(ADMRowID),"^",17) //出院日期 
	s DischgTime=$p(^PAADM(ADMRowID),"^",18) // //出院时间
	s HospDr = ##class(web.UDHCHospitalGroup).GetHospitalByAdm(ADMRowID) //+ DingSH 20200526
	s AdmReasonDR=$P($g(ExpStr),"^",1)
	s InsuType=$P($g(ExpStr),"^",2)
	s:AdmReasonDR="" AdmReasonDR=$p(^PAADM(ADMRowID,1),"^",7)  //病人计费类别
	s:(InsuType="")&&(AdmReasonDR'="") InsuType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AdmReasonDrToDLLType",AdmReasonDR,6,HospDr)
	
	/*根据医保字典配置出院日期和时间取值*/
	s CTLFlag=+##class(web.INSUDicDataCom).GetDicByCodeAndInd("HISPROPerty"_InsuType,"DischDateCtl",4,HospDr)	;1：取PA_ADM.DischDate，2：取护理组
	q:((CTLFlag'=2)&&(InsuType'="")) DischgDate_"^"_DischgTime 
	//b ;00
    /*护理接口取出院日期和时间取值*/
	s DischgDate=$p(##class(web.DHCDischargeHistory).GetDischargeDateTime(ADMRowID),"^",1)	
	s DischgTime=$p(##class(web.DHCDischargeHistory).GetDischargeDateTime(ADMRowID),"^",2)	
	
	s OutStr=DischgDate_"^"_DischgTime
    q OutStr
}

/// 根据医嘱明细表的ROWID取医嘱的数量及单位
/// 返回:数量1^基本单位名称$数量2^计价单位名称$数量3^整包装单位名称$数量4^协议包装单位名称
/// 66^g$^$396^g$396^
/// w ##class(web.DHCINSUPortUse).GetOEQty("1504||4")
/// add zdl desc 此函数截至2019-01-31 ，只有门诊审批在用。
/// Zhan 20160324
/// 	20200213除了医嘱的数据，其它数据改为调接口取；作废->找医生站要接口，20200514，已提需求 
/// 20200603 作废
ClassMethod GetOEQtyOld(oeoriRowId) As %String
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
/// Description: 取安全组配置的支付方式
/// Input:  GPRowID: SS_Group.RowId
/// 		TypeFlag="DEP" 预交金
/// 		TypeFlag="FEE" 收费	--默认
/// 		TypeFlag="REG" 挂号
/// 		TypeFlag="REF" 退费
/// 		TypeFlag="PEB" 体检收费
/// 		TypeFlag="PER" 体检退费
///         DefFlag: 是否需要设置默认标识
/// 20160809
/// 修改：20201009 增加取获取体检配置支付方式 DingSH 
/// 出参：空 或 支付方式Rowid^支付方式Code^支付方式Desc$c(2)支付方式Rowid^支付方式Code^支付方式Desc
/// w ##class(web.DHCINSUPortUse).ReadGSPMListBroker(238,"PEB",2)
ClassMethod ReadGSPMListBroker(GPRowID As %String = "", TypeFlag As %String = "", HospID As %String = "", InsType As %String = "", DefFlag As %String = "Y") As %String
{
	new (GPRowID, TypeFlag, HospID, InsType, DefFlag)
	set PayModeStr=""
	i TypeFlag["PE" 
	{
		s LocID=$P(TypeFlag,"PEB",2)
		;s PayModeStr=##class(web.DHCPE.DHCPEToOPBillInterface).GetTJPaymodeInfo(GPRowID,HospID,"",$e(TypeFlag,3)) //+DingSH 20201010 体检配置支付方式
		s PayModeStr=##class(web.DHCPE.DHCPEToOPBillInterface).GetTJPaymodeInfo(GPRowID,LocID,HospID,"",$e(TypeFlag,3)) //+DingSH 20201010 体检配置支付方式 upt 20221103
		q PayModeStr
	}
	set rs=##class(%ResultSet).%New("web.UDHCOPGSConfig:ReadGSINSPMList")
	do rs.Execute(GPRowID, HospID, InsType, TypeFlag, DefFlag)
	while (rs.Next()) {
		set PMStr=$g(rs.Data("CTPMRowID"))_"^"_($g(rs.Data("CTPMCode")))_"^"_($g(rs.Data("CTPMDesc")))
		if (PayModeStr="") set PayModeStr=PMStr
		else  set PayModeStr=PayModeStr_$C(2)_PMStr
	}
	quit PayModeStr
}

/// Description:通过收费项ID或医嘱项ID取药品必要信息(没有医嘱明细和账单时使用)
/// Input:	TarId:收费项ID	,ArcItmDr:医嘱项ID,qDate:查询日期,HospDr:医院ID
/// Return: 1厂商ID^2厂商代码^3厂商名称^4进口标识^5批准文号^6药品本位码^7规格^8基本单位^9整包装单位^10剂型dr^11剂型^12大包装单位^13整包装转换因子^14处方药标志^15处方药分类^16通用名^17高值类标志^18药品进货价格^19最高售价^20商品名^21每次用量(等效单位)^22频次^23剂量单位^24
/// w ##class(web.DHCINSUPortUse).GetDrugInfoByTar("1","","","")
/// w ##class(web.DHCINSUPortUse).GetDrugInfoByTar("","1||1","")
/// w ##class(web.DHCINSUPortUse).GetDrugInfoByTar("1","1||1","")
ClassMethod GetDrugInfoByTar(TarId As %String, ArcItmDr As %String, qDate As %String = "", HospDr As %String = "") As %String
{
	
	s rtnStr=""
	q:(TarId="")&&(ArcItmDr="") rtnStr
	s DrugPhcInfo="",DrugIncInfo=""
	i (ArcItmDr'="")&&(TarId="") d
	.s TarId=$list(##class(PHA.FACE.OUT.Com).GetTarListByArcim(ArcItmDr,""),1)	;收费项都是同一个
	e  d
	.s ArcListInfo=""
	.s:ArcItmDr="" ArcListInfo=##class(PHA.FACE.OUT.Com).GetArcListByTar(TarId,"")
	.s:$LISTLENGTH(ArcListInfo)>0 ArcItmDr=$list(##class(PHA.FACE.OUT.Com).GetArcListByTar(TarId,""),1)
	s DrugPhcInfo=##class(PHA.FACE.OUT.Com).GetDrugPhcInfo(ArcItmDr)
	s IncList=##class(PHA.FACE.OUT.Com).GetIncListByTar(TarId,qDate)
	;f incIndex=1:1:$LISTLENGTH(IncList) d 
	.;s incID=$LIST(IncList,incIndex)
	s incID=""
	s:$LISTLENGTH(IncList)>0 incID=$LIST(IncList,1)
	s DrugIncInfo=##class(PHA.FACE.OUT.Com).GetDrugIncInfo(incID)
	
	s rtnStr=$p(DrugIncInfo,"^",1)_"^"_$p(DrugIncInfo,"^",2)_"^"_$p(DrugIncInfo,"^",3)_"^"_$p(DrugIncInfo,"^",4)_"^"_$p(DrugIncInfo,"^",5)
	s rtnStr=rtnStr_"^"_$p(DrugIncInfo,"^",6)_"^"_$p(DrugIncInfo,"^",7)_"^"_$p(DrugIncInfo,"^",8)_"^"_$p(DrugIncInfo,"^",9)
	s rtnStr=rtnStr_"^"_$p(DrugPhcInfo,"^",1)_"^"_$p(DrugPhcInfo,"^",2)_"^"_$p(DrugIncInfo,"^",10)_"^"_$p(DrugIncInfo,"^",11)_"^"_$p(DrugPhcInfo,"^",3)
	s rtnStr=rtnStr_"^"_$p(DrugPhcInfo,"^",4)_"^"_$p(DrugPhcInfo,"^",5)_"^"_$p(DrugIncInfo,"^",12)_"^"_$p(DrugIncInfo,"^",13)_"^"_$p(DrugIncInfo,"^",14)
	s rtnStr=rtnStr_"^"_$p(DrugPhcInfo,"^",6)_"^"_$p(DrugPhcInfo,"^",7)_"^"_$p(DrugPhcInfo,"^",8)_"^"_"^"_$p(DrugPhcInfo,"^",9)
	q rtnStr
}

/// Description:根据收费项医嘱ID或执行记录ID取药品必要信息(库存已确定)
/// Input:		
/// Return: 1厂商ID^2厂商代码^3厂商名称^4进口标识^5批准文号^6药品本位码^7规格^8基本单位^9整包装单位^10剂型dr^11剂型^12大包装单位^13整包装转换因子^14处方药标志^15处方药分类^16通用名^17高值类标志^18药品进货价格^19最高售价^20商品名^21每次用量(等效单位)^22频次^23剂量单位^24
/// w ##class(web.DHCINSUPortUse).GetDrugInfoByOrdItmExec("","2054||3","","")
/// w ##class(web.DHCINSUPortUse).GetDrugInfoByTar("","","","")
/// w ##class(web.DHCINSUPortUse).GetDrugInfoByTar("1","","","")
/// 注意事项:门诊要根据医嘱,医嘱项和库存项如果不是1:1的关系,TarId能为空
ClassMethod GetDrugInfoByOrdItmExec(TarId As %String, ordItemDr As %String, ordExecDr As %String, HospDr As %String = "") As %String
{
	/*对于药品：医嘱项--库存项的关系 1:n ；库存项--收费项的关系 1:1*/
	s rtnStr=""
	q:ordItemDr=""&&ordExecDr="" rtnStr 
	
	s DrugPhcInfo="",DrugIncInfo="",SttDate=""
	s ArcItmDr="",incID=""
	s DSPRowId=""
	/*根据医嘱ID获取打包表Rowid(门诊用)*/
	i ordItemDr'="" d
	.s DSPRowId=$O(^DHCOEDISQTY(0,"OEORI",ordItemDr,DSPRowId))
	.s SttDate=$P(^OEORD(+ordItemDr,"I",$P(ordItemDr,"||",2),1),"^",9)
	
	/*根据执行记录获取打包表Rowid(住院用)*/
	i ordExecDr'="" d
	.s DSPRowId=$O(^DHCOEDISQTY(0,"OEORE",ordExecDr,DSPRowId))
	.s SttDate=$P(^OEORD(+ordExecDr,"I",$P(ordExecDr,"||",2),1),"^",9)
	
	/*取库存项Rowid*/
	i DSPRowId'="" d
	.s ArcItmDr=$P(^DHCOEDISQTY(DSPRowId),"^",30)
	.s DSPBChildsub=0
	.s DSPBChildsub=$O(^DHCOEDISQTY(DSPRowId,"I",DSPBChildsub))
	.s:DSPBChildsub'="" incID=$P(^DHCOEDISQTY(DSPRowId,"I",DSPBChildsub),"^",5)
	
	i TarId'="" d
	.s IncList=##class(PHA.FACE.OUT.Com).GetIncListByTar(TarId,SttDate)  
	.s:$LISTLENGTH(IncList)>0 incID=$LIST(IncList,1)
	
	s DrugPhcInfo=##class(PHA.FACE.OUT.Com).GetDrugPhcInfo(ArcItmDr)
	s DrugIncInfo=##class(PHA.FACE.OUT.Com).GetDrugIncInfo(incID)
	
	s rtnStr=$p(DrugIncInfo,"^",1)_"^"_$p(DrugIncInfo,"^",2)_"^"_$p(DrugIncInfo,"^",3)_"^"_$p(DrugIncInfo,"^",4)_"^"_$p(DrugIncInfo,"^",5)
	s rtnStr=rtnStr_"^"_$p(DrugIncInfo,"^",6)_"^"_$p(DrugIncInfo,"^",7)_"^"_$p(DrugIncInfo,"^",8)_"^"_$p(DrugIncInfo,"^",9)
	s rtnStr=rtnStr_"^"_$p(DrugPhcInfo,"^",1)_"^"_$p(DrugPhcInfo,"^",2)_"^"_$p(DrugIncInfo,"^",10)_"^"_$p(DrugIncInfo,"^",11)_"^"_$p(DrugPhcInfo,"^",3)
	s rtnStr=rtnStr_"^"_$p(DrugPhcInfo,"^",4)_"^"_$p(DrugPhcInfo,"^",5)_"^"_$p(DrugIncInfo,"^",12)_"^"_$p(DrugIncInfo,"^",13)_"^"_$p(DrugIncInfo,"^",14)
	s rtnStr=rtnStr_"^"_$p(DrugPhcInfo,"^",6)_"^"_$p(DrugPhcInfo,"^",7)_"^"_$p(DrugPhcInfo,"^",8)_"^"_"^"_$p(DrugPhcInfo,"^",9)
	q rtnStr
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

/// Creator: DingSH
/// CreatDate: 2020-05-22
/// Description: 取医嘱的基本单位信息
/// Input: arcim, oeitm
/// Output: 
/// Return: 基本单位(计价单位)Dr^Code^Desc
/// Debug: w ##class(web.DHCINSUPortUse).GetBaseUom("511||1", "70||182")
ClassMethod GetBaseUom(arcim As %String, oeitm As %String) As %String
{
	new (arcim, oeitm)
	q:oeitm="" "^^"
	i arcim="" d
	.s arcim=$p(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),1),"^",2)	//Zhan 20200528
	s AdmDr=$P(^OEORD(+oeitm),"^",1)
	s HospDr = ##class(web.UDHCHospitalGroup).GetHospitalByAdm(AdmDr)
	set isCNMedItem=##class(web.DHCDocOrderCommon).IsCNMedItem(arcim,HospDr)
	set ordCateType=##class(web.UDHCJFBaseCommon).GetOrdCateType(arcim, 0)
	s baseUomDR=""
	if ((ordCateType="R")&&(oeitm'="")) {
		if (+isCNMedItem=0) {
			set inci=$o(^INCI(0,"ARCIM_DR",+arcim,""))
			set baseUomDR=$s((+inci'=0):$p($g(^INCI(inci,1)),"^",10),1:"")
		}else {
			set baseUomDR=$p($g(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),2)),"^",3)   //1:n时取 药学项基本单位
		}
	}else {
		set baseUomDR=$p(^ARCIM(+arcim,+$p(arcim,"||",2),8),"^",14)
	}
	set baseUomCode=$s((+baseUomDR'=0):$p($g(^CT("UOM",baseUomDR)),"^",1),1:"")
	set baseUomDesc=$s((+baseUomDR'=0):$p($g(^CT("UOM",baseUomDR)),"^",2),1:"")

	quit baseUomDR_"^"_baseUomCode_"^"_baseUomDesc
}

/// Creator：     DingSH
/// CreatDate：   2020-05-27
/// Description:  病案号取病人ID
/// Table：       DHC_WMR_Main,DHC_WMR_MainVolume
/// Input：       MrNo ：病案号
///               MedType   ：门诊（O）、急诊（E）、住院（I）
/// w ##Class(web.DHCINSUPortUse).IGetPatientIDByMrNo("100302","I","","")
ClassMethod IGetPatientIDByMrNo(MrNo As %String, MedType As %String, HospitalID As %String, ByRef ErrMsg As %String) As %String
{
	n (MrNo,MedType,HospitalID,ErrMsg)
	s PatientID = ##Class(DHCWMR.IO.OutService).IGetPatientIDByMrNo(MrNo,MedType,HospitalID,.ErrMsg)
	q PatientID
}

/// Creator?      刘书凤
/// CreatDate?    2009 12 15
/// Description:   通过医嘱项的截止日期控制收费项目是否有效
/// Table?        
/// Input?        TarDr?收费项目Rowid
/// Output?       GetTarItemActive?(Y/N)  Y表示目录需要对照
/// Return?       成功返回 0
/// Others?		作废20200213->新开发20200514->Zhan 20200603修改
/// w ##class(DHCINSUPortUse).GetTarItemActive(TarDr,"","")
ClassMethod GetTarItemActive(TarDr, qdate, ExpStr) As %String
{
	n (TarDr,qdate,ExpStr)
	s GetTarItemActive="N"
	q:TarDr="" "N"
	s:qdate="" qdate=+$h
	s DrugFlag=0
	s IncList=##class(PHA.FACE.OUT.Com).GetIncListByTar(TarDr,qDate)
	f incIndex=1:1:$LISTLENGTH(IncList) d 
	.s incID=$LIST(IncList,incIndex)
	.s DrugFlag=..IsDrug("",incID)
	i DrugFlag=1 d //说明是药品
	.s arcidlist=##class(PHA.FACE.OUT.Com).GetArcListByTar(TarDr,qdate)
	.f incIndex=1:1:$LISTLENGTH(arcidlist) d 
	..s ARCIMDR=$LIST(arcidlist,incIndex)
	..q:$D(^ARCIM(+ARCIMDR,$p(ARCIMDR,"||",2)))=0
	..s ARCIMEffDateTo=$P($g(^ARCIM(+ARCIMDR,$p(ARCIMDR,"||",2),7)),"^",1)
	..i (ARCIMEffDateTo="")!(ARCIMEffDateTo>+$h)  d
	...s GetTarItemActive="Y"
	e  d
	.s OLTStartDate=""
	.f  s OLTStartDate=$o(^DHCOLT(0,"TAR",TarDr,OLTStartDate))  q:OLTStartDate=""  d
	..s OLTRowId=""
	..f  s OLTRowId=$o(^DHCOLT(0,"TAR",TarDr,OLTStartDate,OLTRowId)) q:OLTRowId=""   d
	...s ARCIMDR=$P($g(^DHCOLT(OLTRowId)),"^",1)
	...q:$D(^ARCIM(+ARCIMDR,$p(ARCIMDR,"||",2)))=0
	...s ARCIMEffDateTo=$P($g(^ARCIM(+ARCIMDR,$p(ARCIMDR,"||",2),7)),"^",1)
	...i (ARCIMEffDateTo="")!(ARCIMEffDateTo>+$h)  d
	....s GetTarItemActive="Y"


   q GetTarItemActive
}

/// Creator?      刘书凤
/// CreatDate?    2009 12 15
/// Description:   通过收费项是否有关联的医嘱项控制收费项目是否有效
/// Table?        
/// Input?        TarDr?收费项目Rowid
/// Output?       GetTarItemActive?(Y/N)  Y表示目录需要对照
/// Return?       成功返回 0
/// Others?		作废20200213->新开发20200514>Zhan 20200603修改
/// w ##class(DHCINSUPortUse).GetTarItemActiveByOlt(TarDr,"","")
ClassMethod GetTarItemActiveByOlt(TarDr, qdate, ExpStr) As %String
{
   n (TarDr,qdate,ExpStr)
   s GetTarItemActive="N"
   q:TarDr="" "N"
   s:qdate="" qdate=+$h
   s taractflag=$p(^DHCTARI(TarDr),"^",7)
   q:taractflag="N" "N"
   /*
   s GetTarItemActive="N"
   s OLTStartDate=""
   s taractflag=$p(^DHCTARI(TarDr),"^",7)
   q:taractflag="N" "N"
   f  s OLTStartDate=$o(^DHCOLT(0,"TAR",TarDr,OLTStartDate))  q:OLTStartDate=""  d
   .s OLTRowId=""
   .f  s OLTRowId=$o(^DHCOLT(0,"TAR",TarDr,OLTStartDate,OLTRowId)) q:(OLTRowId="")!(GetTarItemActive="Y")   d
   ..s ARCIMDR=$P($g(^DHCOLT(OLTRowId)),"^",1)
   ..s:($d(^ARCIM(+ARCIMDR,$p(ARCIMDR,"||",2)))'=0) GetTarItemActive="Y"
   */
	s DrugFlag=0
	s IncList=##class(PHA.FACE.OUT.Com).GetIncListByTar(TarDr,qDate)
	f incIndex=1:1:$LISTLENGTH(IncList) d 
	.s incID=$LIST(IncList,incIndex)
	.s DrugFlag=..IsDrug("",incID)
	i DrugFlag=1 d //说明是药品
	.s arcidlist=##class(PHA.FACE.OUT.Com).GetArcListByTar(TarDr,qdate)
	.f incIndex=1:1:$LISTLENGTH(arcidlist) d 
	..s ARCIMDR=$LIST(arcidlist,incIndex)
	..s:($d(^ARCIM(+ARCIMDR,$p(ARCIMDR,"||",2)))'=0) GetTarItemActive="Y"
	e  d
	.s OLTStartDate=""
	.f  s OLTStartDate=$o(^DHCOLT(0,"TAR",TarDr,OLTStartDate))  q:OLTStartDate=""  d
	..s OLTRowId=""
	..f  s OLTRowId=$o(^DHCOLT(0,"TAR",TarDr,OLTStartDate,OLTRowId)) q:(OLTRowId="")!(GetTarItemActive="Y")   d
	...s ARCIMDR=$P($g(^DHCOLT(OLTRowId)),"^",1)
	...s:($d(^ARCIM(+ARCIMDR,$p(ARCIMDR,"||",2)))'=0) GetTarItemActive="Y"
	.
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
/// w ##class(DHCINSUPortUse).GetTarItemActiveByARCIMItemCat(TarDr,"","")
ClassMethod GetTarItemActiveByARCIMItemCat(TarDr, qdate, ExpStr) As %String
{
   n (TarDr,qdate,ExpStr)
   s GetTarItemActive="N"
   q:TarDr="" "N"
   s:qdate="" qdate=+$h
   /*
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
   */
   
	s DrugFlag=0
	s IncList=##class(PHA.FACE.OUT.Com).GetIncListByTar(TarDr,qDate)
	f incIndex=1:1:$LISTLENGTH(IncList) d 
	.s incID=$LIST(IncList,incIndex)
	.s DrugFlag=..IsDrug("",incID)
	i DrugFlag=1 d //说明是药品   
	.s arcidlist=##class(PHA.FACE.OUT.Com).GetArcListByTar(TarDr,qdate)
	.f incIndex=1:1:$LISTLENGTH(arcidlist) d 
	..s ARCIMDR=$LIST(arcidlist,incIndex)
	..s ARCIMEffDateTo=$P($g(^ARCIM(+ARCIMDR,$p(ARCIMDR,"||",2),7)),"^",1)
	..s ARCIMItemCatDR=$P($g(^ARCIM(+ARCIMDR,$p(ARCIMDR,"||",2),1)),"^",10)
	..q:ARCIMItemCatDR="" 
	..s ItemCatCode=$P($g(^ARC("IC",ARCIMItemCatDR)),"^",2)
	..i (ItemCatCode'="暂停药物")&(ItemCatCode'="未开展项目")&(ItemCatCode'="信息材料")&(ItemCatCode'="低值易耗")&(ItemCatCode'="修配材料")&(ItemCatCode'="试剂材料")   d
	...s GetTarItemActive="Y"
	e  d
	.s OLTStartDate=""
	.f  s OLTStartDate=$o(^DHCOLT(0,"TAR",TarDr,OLTStartDate))  q:OLTStartDate=""  d
	..s OLTRowId=""
	..f  s OLTRowId=$o(^DHCOLT(0,"TAR",TarDr,OLTStartDate,OLTRowId)) q:OLTRowId=""   d
	...s ARCIMDR=$P($g(^DHCOLT(OLTRowId)),"^",1)
	...s ARCIMEffDateTo=$P($g(^ARCIM(+ARCIMDR,$p(ARCIMDR,"||",2),7)),"^",1)
	...;i (ARCIMEffDateTo="")!(ARCIMEffDateTo>+$h)  d
	...;.s GetTarItemActive="N"
	...s ARCIMItemCatDR=$P($g(^ARCIM(+ARCIMDR,$p(ARCIMDR,"||",2),1)),"^",10)
	...;s:ARCIMItemCatDR="" GetTarItemActive="N"
	...q:ARCIMItemCatDR="" 
	...s ItemCatCode=$P($g(^ARC("IC",ARCIMItemCatDR)),"^",2)
	...i (ItemCatCode'="暂停药物")&(ItemCatCode'="未开展项目")&(ItemCatCode'="信息材料")&(ItemCatCode'="低值易耗")&(ItemCatCode'="修配材料")&(ItemCatCode'="试剂材料")   d
	....s GetTarItemActive="Y"

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
/// w ##class(DHCINSUPortUse).GetTarItemActiveByOltDate(TarDr,"","")
ClassMethod GetTarItemActiveByOltDate(TarDr, qdate, ExpStr) As %String
{
	n (TarDr,qdate, ExpStr)
	s GetTarItemActive="N"
   
	s DrugFlag=0
	s IncList=##class(PHA.FACE.OUT.Com).GetIncListByTar(TarDr,qDate)
	f incIndex=1:1:$LISTLENGTH(IncList) d 
	.s incID=$LIST(IncList,incIndex)
	.s DrugFlag=..IsDrug("",incID)
	i DrugFlag=1 d //说明是药品 
	.s arcidlist=##class(PHA.FACE.OUT.Com).GetArcListByTar(TarDr,qdate)
	.f incIndex=1:1:$LISTLENGTH(arcidlist) d 
	..s ARCIMDR=$LIST(arcidlist,incIndex)
	..s OLTEndDate=$P($g(^DHCOLT(OLTRowId)),"^",5)
	..s:(OLTEndDate="")!(OLTEndDate>+$h) GetTarItemActive="Y"
	e  d
	.s OLTStartDate=""
	.f  s OLTStartDate=$o(^DHCOLT(0,"TAR",TarDr,OLTStartDate))  q:OLTStartDate=""  d
	..s OLTRowId=""
	..f  s OLTRowId=$o(^DHCOLT(0,"TAR",TarDr,OLTStartDate,OLTRowId)) q:(OLTRowId="")!(GetTarItemActive="Y")   d
	...s ARCIMDR=$P($g(^DHCOLT(OLTRowId)),"^",1)
	...s OLTEndDate=$P($g(^DHCOLT(OLTRowId)),"^",5)
	...s:(OLTEndDate="")!(OLTEndDate>+$h) GetTarItemActive="Y"
   q GetTarItemActive
}

/// Descript:    根据医嘱或库存项判断是否药品
/// CreateDate:  2020-05-13
/// Input:       医嘱项ID(Arc_ItemMast表ID),库存项ID(INC_Itm表ID)
/// OutPut：     1-是,0-否
/// w ##class(web.DHCINSUPortUse).IsDrug("509||1","")
ClassMethod IsDrug(arcimID As %String, inciID As %String) As %String
{
	q ##class(PHA.FACE.OUT.Com).IsDrug(arcimID,inciID)
}

/// 根据就诊Dr获取医生录入诊断(调用医生站接口)
/// 入参说明:
///          AdmDr:就诊号,DiagType:诊断类型代码.(空 获取全部,不为空 获取指定诊断代码的诊断)
///          ExpStr:Pac_AdmReason.Rowid^InsuType
/// 出参说明：
///   第1-6  DiagnosNum:诊断记录序号 ,DiagnosCodeRowid:诊断代码表ID,ICDCode:诊断代码表ICD代码,DiagName:ICD诊断描述,MedicalRecord:诊断注释,DiagnosType:诊断类型描述,
///   第7-14 DiagnosDate:诊断日期,DiagnosOnsetDate:发病日期,DiagStat:诊断状态描述,DiagnosLeavel:诊断级别(数字),MainDiagFlag:是否主诊断,DiagnosPrefix:诊断前缀,InsuDiagCode:医保诊断编码,InsuDiagDesc:医保诊断名称
///    DingSH 20200923 修改成调用医生站接口
///    DingSH 20200923 从 web.INSUAuditIP copy 
///    DingSH 20200924  增加诊断序号,诊断序号^诊断科室Dr^诊断科室代码^诊断科室描述^诊断医生编码^诊断医生姓名^诊断时间
///    DingSH 20220107 增加 SDSDesc  结构化诊断描述	由基础数据平台返回的结构化诊断信息
Query GetDiagnosInfo(AdmDr, DiagType As %String = "", ExpStr As %String = "") As %Query(ROWSPEC = "DiagnosNum,DiagnosCodeRowid,ICDCode,DiagName,MedicalRecord,DiagnosType,DiagnosDate,DiagnosOnsetDate,DiagStat,DiagnosLeavel,MainDiagFlag,DiagnosPrefix,InsuDiagCode,InsuDiagDesc,MRDIAAddLocDr,MRDIAAddLocCode,MRDIAAddLocDesc,MRDIADocCode,MRDIADocDesc,MRdiagnosTime,SDSDesc")
{
}

/// d ##Class(%ResultSet).RunQuery("web.DHCINSUPortUse","GetDiagnosInfo","2020")
/// d ##Class(%ResultSet).RunQuery("web.DHCINSUPortUse","GetDiagnosInfo","5258")
ClassMethod GetDiagnosInfoExecute(ByRef qHandle As %Binary, AdmDr, DiagType As %String = "", ExpStr As %String = "") As %Status
{
	new (qHandle,AdmDr,DiagType,ExpStr )
	Set repid1=$I(^CacheTemp)
 	If $g(ind1)="" Set ind1=1
 	i (AdmDr="")||($d(^PAADM(AdmDr))=0)
 	{
	 	Set qHandle=$lb(0,repid1,0)
		Quit $$$OK
	}
	s MRadm=$p($g(^PAADM(AdmDr)),"^",61) ;指向MRADM
	//Set rset=##class(%ResultSet).%New("web.DHCDocDiagnosNew:DiagnosList")
	//do rset.Execute(MRadm,"",DiagType,"1") ;20160418 DingSH 医生站增加了一个入参 固定为1代表去空格
	k rrset
	Set rrset=##class(%ResultSet).%New("DHCDoc.Interface.Inside.Service:DiagnosList")
	do rrset.Execute(MRadm,"",DiagType) ;20220107 DingSH 
	Set columns = rrset.GetColumnCount()

	s AdmReasonDr=$P($g(ExpStr),"^",1)
	if AdmReasonDr="" d
	.s AdmReasonDr=$p(^PAADM(AdmDr,1),"^",7)
	s HospDr = ##class(web.UDHCHospitalGroup).GetHospitalByAdm(AdmDr) //+ DingSH 20200526
	s InsuType=$P($g(ExpStr),"^",2)
	s:(InsuType="") InsuType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AdmReasonDrToDLLType",AdmReasonDr,6,HospDr)
	
	While (rrset.Next()) {
		s DiagnosValue=rrset.GetDataByName("DiagnosValue")	        ;诊断表ID(User.MRDiagnos)
		s DiagnosCodeRowid=rrset.GetDataByName("DiagnosCodeRowid")	;诊断代码表ID(User.MRCICDDx)
		s DiagnosICDCode=rrset.GetDataByName("DiagnosICDCode")	    ;诊断代码表ICD代码
		s DiagnosDesc=rrset.GetDataByName("DiagnosDesc")          	;ICD诊断描述
		s DiagnosMRDesc=rrset.GetDataByName("DiagnosMRDesc")	        ;诊断注释
		s DiagnosType=rrset.GetDataByName("DiagnosType")	            ;诊断类型描述
		s DiagnosDate=rrset.GetDataByName("DiagnosDate")	            ;诊断日期
		s DiagnosOnsetDate=rrset.GetDataByName("DiagnosOnsetDate")	;发病日期
		s DiagStat=rrset.GetDataByName("DiagStat")	                ;诊断状态描述
		s DiagnosLeavel=rrset.GetDataByName("DiagnosLeavel")	        ;诊断级别(数字)
		s MainDiagFlag=rrset.GetDataByName("MainDiagFlag")	        ;是否主诊断 20191029
		s DiagnosPrefix=rrset.GetDataByName("DiagnosPrefix")	        ;诊断前缀 20200923 DingSH
		s DiagnosNumber = rrset.GetDataByName("DiagnosNumber")	    ;诊断序号        20200924 DingSH
		s MRDIAAddLocDr = rrset.GetDataByName("MRDIAAddLocDr")	    ;诊断科室Dr      20200924 DingSH
		s MRDIAAddLocCode="",MRDIAAddLocDesc=""
		i (MRDIAAddLocDr'="")
		{
		 s MRDIAAddLocCode = $P(^CTLOC(MRDIAAddLocDr),"^",1)        ;诊断科室代码   20200924 DingSH
		 s MRDIAAddLocDesc = $P(^CTLOC(MRDIAAddLocDr),"^",2)        ;诊断科室描述   20200924 DingSH
		}
		s MRDIADocCode = rrset.GetDataByName("MRDIADocCode")	        ;诊断医生代码   20200924 DingSH
		s MRDIADocDesc = rrset.GetDataByName("MRDIADocDesc")	        ;诊断医生姓名   20200924 DingSH
		s MRdiagnosTime = rrset.GetDataByName("MRdiagnosTime")	    ;诊断时间       20200924 DingSH
		
		s InsuDiagInfo=""
		//b ;0222
		s:DiagnosCodeRowid'="" InsuDiagInfo=$$GetConInfo^DHCINSUICDContrast(DiagnosCodeRowid,InsuType,"",HospDr)
		s InsuDiagCode=$P(InsuDiagInfo,"^",3)                       ;医保诊断编码
		s InsuDiagDesc=$P(InsuDiagInfo,"^",4)                       ;医保诊断描述
	    s SDSDesc=rrset.GetDataByName("SDSDesc")                     ;结构化诊断描述	由基础数据平台返回的结构化诊断信息 20220107 DingSH
		s:SDSDesc="" SDSDesc=DiagnosDesc
		d GetDiagnosInfo

	}
	d rrset.Close()
	k rrset
	
  Set qHandle=$lb(0,repid1,0)
  Quit $$$OK
GetDiagnosInfo
	set Data=$lb(DiagnosNumber,DiagnosCodeRowid,DiagnosICDCode,DiagnosDesc,DiagnosMRDesc,DiagnosType,DiagnosDate,DiagnosOnsetDate,DiagStat,DiagnosLeavel,MainDiagFlag,DiagnosPrefix,InsuDiagCode,InsuDiagDesc,MRDIAAddLocDr,MRDIAAddLocCode,MRDIAAddLocDesc,MRDIADocCode,MRDIADocDesc,MRdiagnosTime,SDSDesc)
 	Set ^CacheTemp(repid1,ind1)=Data
 	
 	Set ind1=ind1+1
 	//b ;ind
	quit
}

ClassMethod GetDiagnosInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDiagnosInfoExecute ]
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

ClassMethod GetDiagnosInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDiagnosInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 获取生育住院相关信息
/// 生育证号^生育类型^计划手术类别^晚育标志^孕周^胎次^胎儿数^早产标志^计生手术日期或生育日期^出生证号^独生子女证号
/// 调用护理组接口
ClassMethod GetInsuBirthInfoByAdm(Adm As %String) As %String
{
	
	s rtn="^^^^^^^"
	//生育类别^计划生育手术类别^晚育标志^孕周^胎次^胎儿数^早产标志^计划生育手术日期(生育日期)
	;s InsuBirthInfo=##class(Nur.Interface.OutSide.Patient).getBirthInfo(Adm)
	s InsuBirthInfo=""
	//BirthNo_"^"_BirthType_"^"_OperType_"^"_LateBirthSign_"^"_GestationalWeek_"^"_PregNum_"^"_BabyNum_"^"_PrematureSign_"^"_BirthDate_"^"_BornNo_"^"_OneChildNo
	//生育证号^生育类型^计划手术类别^晚育标志^孕周^胎次^胎儿数^早产标志^计生手术日期或生育日期^出生证号^独生子女证号
	s InsuBirthInfo=##class(Nur.Interface.OutSide.Med.Fertility).GetData(Adm) //+DingSH 20220829
	s:InsuBirthInfo="" InsuBirthInfo= rtn

	q InsuBirthInfo
}

/// d ##class(%ResultSet).RunQuery("web.DHCINSUPortUse","Find","5401")
Query Find(mradm As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,mradm,MRDIAICDCodeDR,MRDIAICDCodeDRDesc,MRDIAICDCodeDRCode,MRDIADate:%Library.Date,MRDIATime:%Library.Time,MRDIADesc:%List,MRDIAUpdateUserDRSSUSRName")
{
	
SELECT MRDIA_RowID, MRDIA_MRADM_ParRef, MRDIA_ICDCode_DR, MRDIA_ICDCode_DR->MRCID_Desc, MRDIA_ICDCode_DR->MRCID_ICD9CM_Code, MRDIA_Date, MRDIA_Time, MRDIA_Desc, MRDIA_UpdateUser_DR->SSUSR_Name
FROM SQLUser.MR_Diagnos
WHERE MRDIA_MRADM_ParRef = :mradm
}

/// 描述：根据医院rowid和表名，返回配置信息
/// DingSH 
/// 2021-11-25
/// input: 医院id，表名（收费项DHC_TarItem、手术ORC_Operation、诊断MRC_ICDDx）
/// output: 配置信息 BDP、INSU、""
/// w ##class(web.DHCINSUPortUse).GetConfigByHospId("2","DHC_TarItem")
ClassMethod GetConfigByHospId(hospid As %String, table As %String) As %String
{
	
	q ##class(web.DHCBL.BDP.INSUConfig).GetConfigByHospId(hospid,table)
}

/// Function: 根据ICD诊断rowid获取诊断国家医保编码等信息
/// Creator:DingSH
/// CreateDate: 2021-11-25
/// Input:RowId:ICD诊断rowid
/// Return :诊断国家医保编码^诊断国家医保名称
/// Debug: w ##class(web.DHCINSUPortUse).GetStdInfoByMRCICDDxRowId("1")
ClassMethod GetStdInfoByMRCICDDxRowId(Rowid As %String, langId As %String = "") As %String
{
	n (Rowid,langId,%session)
	s StdCode="",StdDesc=""
	s StdCode=##class(web.DHCBL.CT.MRCICDDx).GetInsuCodeByRowId(Rowid)
	s StdDesc=##class(web.DHCBL.CT.MRCICDDx).GetInsuName(Rowid)
	q StdCode_"^"_StdDesc
}

/// Function: 根据手术rowid获取手术国家医保编码等信息
/// Creator:DingSH
/// CreateDate: 2021-11-25
/// Input:RowId:手术rowid
/// Return :手术国家医保编码^手术国家医保名称
/// Debug: w ##class(web.DHCINSUPortUse).GetStdInfoByORCOperRowId("1")
ClassMethod GetStdInfoByORCOperRowId(Rowid As %String) As %String
{
	s StdCode="",StdDesc=""
	s StdCode=##class(web.DHCBL.CT.ORCOperation).GetInsuCodeByRowId(Rowid)
	s StdDesc=##class(web.DHCBL.CT.ORCOperation).GetInsuName(Rowid)
	q StdCode_"^"_StdDesc
}

/// Function: 根据收费项rowid获取收费项国家医保编码等信息
/// Creator:DingSH
/// CreateDate: 2021-11-25
/// Input:TARIRowId： 收费项rowid
/// Return :国家医保编码^国家医保名称
/// Debug: w ##class(web.DHCINSUPortUse).GetStdInfoByDHCTarItemRowId("1")
ClassMethod GetStdInfoByDHCTarItemRowId(Rowid As %String) As %String
{
	s StdCode="",StdDesc=""
	s StdCode=##class(web.DHCBL.CT.DHCTarItem).GetInsuCodeByRowId(Rowid)
	s StdDesc=##class(web.DHCBL.CT.DHCTarItem).GetInsuName(Rowid)
	q StdCode_"^"_StdDesc
}

/// 标准接口：通过用户rowid返回国家医保编码
/// DingSH 20220628 
/// 基础数据
/// input: 用户rowid
/// output: 国家医保编码
/// w ##class(web.DHCINSUPortUse).GetINSUCodeByUserId("1")
ClassMethod GetINSUCodeByUserId(id As %String) As %String
{
	q ##class(web.DHCBL.CT.SSUser).GetINSUCodeByUserId(id)
}

/// 根据医嘱项Id获取中药单味使用标识
/// DingSH 20220628 
/// 规则，与项目沟通规则后修改：
/// (规则作废)1：根据收费项目对应的医保目录表的备注字段，是否包含单味使用不予支付，且全部使用也不予支付（不推荐）
/// （规则作废）2：根据收费项目对应的医保目录表的txbz字段 用医保目录表txbz字段维护一个值标识(，例如=3)
/// （规则作废）3：收费项目维护增加字段维护单位使用标识
/// (规则)：根据 1302 中药饮片目录表 CT.INSU.MI.TMDPLIST CPND_FLAG 字段进行判断
/// ArcItmID: 医嘱项Id
/// output: Y:是单味，N:非单味
/// w ##class(web.DHCINSUPortUse).GetINSUCodeByUserId("1")
ClassMethod GetDrugSingleUseFlag(ArcItmID As %String, HospDr As %String = "", HiType As %String = "") As %String
{
	//s SingleUseFlag=##class(web.DHCST.Common.DrugInfoCommon).GetDrugSingleUseFlag(ArcItmID)  //徐州中心 20220607
    //ArcItmID
    s SingleUseFlag="N"
    q:$g(ArcItmID)="" SingleUseFlag
    q:+$d(^ARCIM(+ArcItmID,$P(ArcItmID,"||",2)))=0 SingleUseFlag
    s ARCIMCode=$P(^ARCIM(+ArcItmID,$P(ArcItmID,"||",2)),"^",1)
    //^DHCTARI(0,"Code",{TARI_Code},{TARI_RowId})
    q:+$d(^DHCTARI(0,"Code",ARCIMCode))=0 SingleUseFlag
    s TARIRowId=$O(^DHCTARI(0,"Code",ARCIMCode,""),-1)
    q:$g(TARIRowId)="" SingleUseFlag
    s TarItemInsuInfo=$$GetConInfo^DHCINSUTarContrast(TARIRowId,HiType,"","",HospDr)
    q:TarItemInsuInfo="" SingleUseFlag
    //s INTIMtxbz=$P(TarItemInsuInfo,"^",6) //特殊项标志
    //i +INTIMtxbz=? d
    //.s SingleUseFlag="Y"
    //s INTIMbz=$P(TarItemInsuInfo,"^",22)  //备注
    s MedListCodg=$P(TarItemInsuInfo,"^",1)           //1302 中药饮片目录表 CT.INSU.MI.TMDPLIST
    s TRowId=""
    s TRowId=$O(^CT.INSU.MI.TMDPLISTI("IdxMEDLISTCODG",HospDr,MedListCodg,""),-1)  //单复方标志	CPND_FLAG
    q:TRowId="" SingleUseFlag
    s CpndFlag=$lg(^CT.INSU.MI.TMDPLISTD(TRowId),6)
    //i CpndFlag=""
    //1304 民族药品目录下载 CT.INSU.MI.NATYDRUGLIST MedListCodg IdxMEDLISTCODG ??没有单复方标识
    q SingleUseFlag
}

/// 根据表名，字段名，语言和翻译前中文，返回翻译后内容
/// w ##class(web.DHCINSUPortUse).GetTransDesc("User.INSUDicData","INDIDDicDesc",1,"甲类")
/// 组内的接口调用
/// +DingSH 20220727 
/// 其他说明：调用基础数据平台组接口
ClassMethod GetTransDesc(TableName, FieldName, langid, FieldDesc) As %String
{
	n (TableName, FieldName, langid, FieldDesc)
	//q FieldDesc  //不用其他功能的 放开
	q:$g(langid)="" FieldDesc
	s Languages=$p($g(^SS("LAN",langid)),"^",1)
    s TransDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc(TableName,FieldName,Languages,FieldDesc)
    q TransDesc
}

/// 根据中药处方剂型获取中药标志（中药饮片标志或中药配方颗粒标志）
/// 医生录入草药医嘱会保存中药处方类型代码： ^DHCDocConfig("PrescTypeCharge",DHCQueCMPrescTypeCode)
/// 入参：OrdId:医嘱Id,HiType:医保类型(可空,例如00A),HospDr:院区指针
/// 出参：1:中药饮片 或 2:中药配方颗粒 或 99:未配置 或 "":(非中药返回空)
/// 注意：项目需要在 医保字典CMPrescTypeToTcmdrugFlag/中药处方剂型到中药标志的对照 维护字典对照
/// 操作中药处方剂型字典：^DHCDocConfig("PrescTypeCharge",DHCQueCMPrescTypeCode)
/// +DingSH 20221123 
/// w ##class(web.DHCINSUPortUse).GetTcmdrugFlagByOrdId()
ClassMethod GetTcmdrugFlagByOrdId(OrdId, HiType As %String = "", HospDr As %String = "") As %String
{
	n (OrdId,HiType,HospDr)
	s $zt="GetTcmdrugFlagByOrdIdEx"
	q:$g(OrdId)="" ""
	s TcmdrugFlag = ""  //字典值：1:中药饮片 或 2:中药配方颗粒 或 ""
	s CMPrescTypeCode=""
	s OEORIRowId=$P(OrdId,"||",1)
	s OEORIChildsub=$P(OrdId,"||",2)
	s OrderPrescNo=$P($G(^OEORD(OEORIRowId,"I",OEORIChildsub,1)),"^",14)
	//s OrderPrescSeqNo=$P($G(^OEORD(+OEORIRowId,"I",OEORIChildsub,1)),"^",15)
	q:OrderPrescNo="" ""
	s QUE1RowID=$O(^PAQUE1(0,"PrescNo",OrderPrescNo,0))  //处方剂型 中药处方类型 
	i +QUE1RowID > 0 {
         s CMPrescTypeCode = $P($G(^PAQUE1(QUE1RowID,"DHC")),"^",26)
	}
    q:$g(CMPrescTypeCode)="" ""
	s AdmDr = $P(^OEORD(OEORIRowId),"^",1)
	i HospDr = ""{
		s HosPDr = ##class(web.UDHCHospitalGroup).GetHospitalByAdm(AdmDr)
	}
    i HiType = "" {
        s AdmReasonDR = $P($G(^OEORD(OEORIRowId,"I",OEORIChildsub,11)),"^",18)  // OEORIBBExtCode
		s HiType = ##class(web.INSUDicDataCom).GetDicByCodeAndInd("AdmReasonDrToDLLType",AdmReasonDR,6,hospDr)
		i HiType = "" {
			s AdmReasonDR =$P(^PAADM(AdmDr),"^",7)
			s HiType = ##class(web.INSUDicDataCom).GetDicByCodeAndInd("AdmReasonDrToDLLType",AdmReasonDR,6,hospDr)
		}
	}
    s TcmdrugFlag = ##class(web.INSUDicDataCom).GetDicByCodeAndInd("CMPrescTypeToTcmdrugFlag"_HiType,CMPrescTypeCode,6,HospDr)
	i TcmdrugFlag = ""{
		s TcmdrugFlag="99|未配置"
	}
    q TcmdrugFlag
GetTcmdrugFlagByOrdIdEx
   b ;GetTcmdrugFlagByOrdIdEx
   s $zt=""
   q "-99^程序异常："_$ze
}

/// 根据就诊号获取分诊级别
/// 入参：AdmDr:Pa_Adm.Rowid
/// 出参：分诊级别代码^分诊级别描述
/// 使用场景：分诊级别不同,医保结算时医疗类别也不同
///           例如南通：急诊1级别濒危 传医疗类别：139901；急诊2级别危重 传医疗类别：139902
/// 医保字典需要增加 EmPatLevelToMedType00A 
/// +DingSH 20221128 
/// w ##class(web.DHCINSUPortUse).GetEmPatLevel(5814)
ClassMethod GetEmPatLevel(AdmDr) As %String
{
   n (AdmDr)
   s rtnLv = ##Class(web.DHCEMInterfaceCom).GetEmPatLevel(AdmDr)
   q rtnLv
}

/// Creator: DingSH
/// CreatDate: 2023-04-03
/// Description: 根据收费项Id获取耗材厂家
/// Input: TarId:DHC_TarItem.Rowid
/// Return: 
/// Debug: w ##class(web.DHCINSUPortUse).GetManfByTarId(2816)
/// 医保目录对照获取耗材厂商使用
ClassMethod GetManfByTarId(TarId) As %String
{
   n (TarId)
   s ManF = ##class(web.DHCSTMHUI.DHCSTMSERVICE).GetManfByTarId(TarId)
   q ManF
}

/// Creator: DingSH
/// CreatDate: 2023-04-03
/// Description: 根据收费项Id获取物资库存项信息
/// Input:		TarItemId
/// return 厂家^规格^型号^基本单位^入库单位^注册证号^进口标志^高值标志
/// other: 医保目录对照界面显示厂家规格等信息
/// Debug: w ##class(web.DHCINSUPortUse).GetDHCSTMInciByTar(2816,2)
ClassMethod GetDHCSTMInciByTar(TarItemId, HospId = "")
{
   new (TarItemId,HospId)
   set $zt="GetDHCSTMInciByTarEx"
   set InciInfo ="^^^^^^^"
   set InciObj =##class(web.DHCSTMHUI.Interface).GetInciObjByTar(TarItemId,HospId)
   if $ISOBJECT(InciObj) {
	  set ManfDesc=InciObj."ManfDesc"         //厂家
	  set Spec=InciObj."Spec"                 //规格
	  set Model=InciObj."Model"               //型号
      set BUomDesc=InciObj."BUomDesc"         //基本单位
	  set PUomDesc=InciObj."PUomDesc"         //入库单位
	  set CertNo=InciObj."CertNo"             //注册证号
	  set ImpFlag=InciObj."ImpFlag"           //进口标志
	  set IncscDesc=InciObj."IncscDesc"       //高值标志
	  set InciInfo = ManfDesc_"^"_Spec_"^"_Model_"^"_BUomDesc_"^"_PUomDesc_"^"_CertNo_"^"_ImpFlag_"^"_IncscDesc
   }
   quit InciInfo
GetDHCSTMInciByTarEx
  set $zt=""
  b ;GetDHCSTMInciByTarEx
  quit "-99^GetDHCSTMInciByTar程序异常："_$ze
}

/// Creator: DingSH
/// CreatDate: 2023-04-23
/// Description: 根据操作员Id获取医护人员类型
/// Input:		UserID
/// return  例如 NURSER 
/// Debug: w ##class(web.DHCINSUPortUse).GetCareProvType(2816)
ClassMethod GetCareProvType(UserID)
{
   new (UserID)
   set $zt="GetCareProvTypeEx"
   set CareProvType =""
   set CareProvType =##class(web.DHCDocOrderCommon).GetCareProvType(UserID)
   quit CareProvType
GetCareProvTypeEx
  set $zt=""
  b ;GetCareProvTypeEx
  quit "-99^GetCareProvType程序异常："_$ze
}

/// Creator: DingSH
/// CreatDate: 2023-04-23
/// Description: 根据医嘱ID判断下医嘱人是否护士
/// Input:		OrderID:医嘱Id
/// return   Y或N
/// Debug: w ##class(web.DHCINSUPortUse).CheckOrderUserAddNurFlag("11||1")
/// 取费用明细集合时护士没有医保医师码，需要此判断跟新特殊处理
ClassMethod CheckOrderUserAddNurFlag(OrderID)
{
	new (OrderID)
	set $zt="CheckOrderUserAddNurFlagEx"
	quit:$g(OrderID)="" "N"
	set NurFlag="N"
	set UserAdd = $P($g(^OEORD(+OrderID,"I",$P(OrderID,"||",2),7)),"^",1)
	set CareProvType =""
	set CareProvType =..GetCareProvType(UserAdd)
	//set NurFlag=$case(CareProvType,"NURSE":"Y","Technician":"Y","Pharmacist":"Y",:"N")
	b ;rr
	set NurFlag=$case(CareProvType,"NURSE":"Y",:"N")
	quit NurFlag
CheckOrderUserAddNurFlagEx
	set $zt=""
	b ;CheckOrderUserAddNurFlagEx
	quit "-99^CheckOrderUserAddNurFlag程序异常："_$ze
}

/// Creator: DingSH
/// CreatDate: 2023-04-23
/// Description: 校验就诊诊断某一诊断类型是否有对应的主诊断
/// Input:		AdmDr:Paadm.Rowid
///             DiagType:1:入院诊断,2:出院诊断,3:门诊诊断,空：全部诊断
///            ExpStr:费别^医保类型^ ICDType(是否获取中医诊断.(1 中医,空或0 西医))
/// return   Y 或 N 
/// 特别说明 需要在 医保字典 DiagnosTypeCon00A下面维护his诊断类型与医保诊断类型的对照 
/// Debug: w ##class(web.DHCINSUPortUse).CheckAdmDiagMainFlag(58,"C008")
ClassMethod CheckAdmDiagMainFlag(AdmDr, DiagType, ExpStr = "")
{
    new (AdmDr,DiagType,ICDType)
    set $zt="CheckAdmDiagMainFlagEx"
	set MRadm=$p($g(^PAADM(AdmDr)),"^",61) ;指向MRADM
    set AdmReasonDr=$P($g(ExpStr),"^",1)
	if AdmReasonDr = "" {
     set AdmReasonDr = $p(^PAADM(AdmDr,1),"^",7)
	}
	set HospDr = ##class(web.UDHCHospitalGroup).GetHospitalByAdm(AdmDr) 
	set InsuType=$P($g(ExpStr),"^",2)
    set:(InsuType="") InsuType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AdmReasonDrToDLLType",AdmReasonDr,6,HospDr)
    set ICDType =  $P($g(ExpStr),"^",3)
	set DicDataStr = ##class(web.INSUDicDataCom).GetSys("","","DiagnosTypeCon"_InsuType,HospDr)
	//set DicDataStr="!25488^DiagnosTypeCon00A^C008^入院诊断二^^1^医保入院诊断登记^^^^^^^^"
	set DicDataCnt = $l(DicDataStr,"!")
	set MainDiagFlag="N"
	
	for DicDataIdx = 2:1:DicDataCnt{
		quit:MainDiagFlag="Y"
		set DicRowStr = $P(DicDataStr,"!",DicDataIdx)
		set tmpDiagType = $P(DicRowStr,"^",6) //:1:入院诊断,2:出院诊断,3:门诊诊断,空：全部诊断
		continue:tmpDiagType'=DiagType
		set DiagnosTypeCode = $P(DicRowStr,"^",4)
		continue:DiagnosTypeCode=""
		new rset
		set rset=##class(%ResultSet).%New("DHCDoc.Interface.Inside.Service:DiagnosList")
		do rset.Execute(MRadm,ICDType,DiagnosTypeCode) 
		while ((rset.Next()) && (MainDiagFlag'="Y")) {
			set DiagnosCodeRowid=rset.GetDataByName("DiagnosCodeRowid")	   ;诊断代码表ID(User.MRCICDDx)
			continue:DiagnosCodeRowid=""         //过滤非标准诊断
			set MainDiagFlag = rset.GetDataByName("MainDiagFlag")	     
		}
	}
	quit MainDiagFlag
CheckAdmDiagMainFlagEx
  set $zt=""
  b ;CheckAdmDiagMainFlagEx
  quit "-99^CheckAdmDiagMainFlag程序异常："_$ze
}

/// Creator:HanZH
/// CreatDate:2023-05-24
/// Description:为combobox查询取数据 版本字典  调用基础数据平台组取版本字典数据的接口
/// Input：rowid,code,desc,type,IsInsuFlag
/// Return: ID:RowId Type:类型 VersionCode:代码  VersionName：名称 IsInsuFlag:医保数据标识
/// Other:d ##class(%ResultSet).RunQuery("web.DHCINSUPortUse","GetBDVersionDic","","","","User.MRCICDDx","N")
Query GetBDVersionDic(rowid As %String, code As %String, desc As %String, type As %String, IsInsuFlag As %String = "") As %Query(ROWSPEC = "ID:%String,Type:%String,VersionCode:%String,VersionName:%String,tIsInsuFlag:%String")
{
}

ClassMethod GetBDVersionDicExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, type As %String, IsInsuFlag As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1  
	k newrset
	Set newrset=##class(%ResultSet).%New("web.DHCBL.CT.BDVersionDict:GetDataForCmb1")
	do newrset.Execute(rowid,code,desc,type) ;20220107 DingSH 
	Set columns = newrset.GetColumnCount()
	While (newrset.Next()) {
		s ID=newrset.GetDataByName("ID")						///RowID
		s Type=newrset.GetDataByName("Type")					///类型
		s VersionCode=newrset.GetDataByName("VersionCode")		///版本代码
		s VersionName=newrset.GetDataByName("VersionName")		///版本名称
		s tIsInsuFlag=newrset.GetDataByName("IsInsuFlag")		///医保数据标识
		continue:(IsInsuFlag="Y")&&(tIsInsuFlag'=IsInsuFlag)
		continue:(IsInsuFlag="")&&(tIsInsuFlag="Y")
		continue:(IsInsuFlag="N")&&(tIsInsuFlag="Y")
		d OutputRowCmb
	}
	d newrset.Close()
	k newrset

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
	set Data=$lb(ID,Type,VersionCode,VersionName,tIsInsuFlag)
	set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetBDVersionDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBDVersionDicExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetBDVersionDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBDVersionDicExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    
    Set ind=$o(^CacheTemp(repid,ind))
    If ind=""
    {
        //if there are no more rows,finish fetching...
        Set AtEnd=1
        Set Row=""
    }
    Else
    {
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// Creator:    HanZH
/// CreatDate:  2023-05-24
/// Description：根据版本id获取所有信息	调用基础数据平台组取版本字典数据的接口
/// Input：     ID
/// Return: 类型^版本代码^版本名称^开始日期^结束日期^同步到病案系统^中医数据标识^医保数据标识
/// Other: w ##class(web.DHCINSUPortUse).GetDictInfoByRowId("1")
ClassMethod GetDictInfoByRowId(ID As %String) As %String
{
	q:ID="" "N"
	s DictInfo=##class(web.DHCBL.CT.BDVersionDict).GetDictInfoByRowId(ID)	//(平台组接口)
	q DictInfo
}

/// Creator:    HanZH
/// CreatDate:  2023-05-24
/// Description：获取版本代码对应的版本信息	调用基础数据平台组取版本字典数据的接口
/// Input：     code 
/// Return: 版本rowid^类型^版本代码^版本名称^开始日期^结束日期^同步到病案系统^中医数据标识^医保数据标识
/// Other: w ##class(web.DHCINSUPortUse).GetDictInfoByCode("SSLCB1.0")
ClassMethod GetDictInfoByCode(code As %String) As %String
{
	q:code="" ""
	s DictInfo=##class(web.DHCBL.CT.BDVersionDict).GetDictInfoByCode(code)	//(平台组接口)
    q DictInfo
}

/// 医保诊断/手术信息同步到病案系统
/// HanZH 2023-05-24
/// Description：调用病案系统同步接口
/// 入参：
/// 	Instring	医保信息串
/// 	SendType	同步类型（diag/oper）
/// 	aIsActive	有效标志
/// 出参：
/// 	""   "rowid!保存医保诊断/手术成功,同步病案系统失败,同步失败原因"  "rowid!保存医保诊断/手术成功,同步病案系统成功"
/// w ##class(web.DHCINSUPortUse).SendICDInfo("","","")
ClassMethod SendICDInfo(Instring, SendType, aIsActive = "1") As %String
{
	n (Instring, aIsActive,SendType)
	q:SendType="" "-1!同步类型传入为空"
	s (HisVer,HisVerName,aCode,aICD10,aICDinPair,aDesc,aGrayCodeFlag,aMrcID,aOrcID,aActDate,aEndDate,aOperTypeDesc,aOperLevelDesc,aAlias,ErrMsg)=""
	s sendRtn=""
	i (SendType="diag"){
		s HisVer=$p(Instring,"^",24)         ;院内版本号（代码）      
		s DictStr=##class(web.DHCINSUPortUse).GetDictInfoByCode(HisVer)
		s HisVerId=$p(DictStr,"^",1)
		s IsSyncMedcas=##class(web.DHCBL.CT.BDVersionDict).GetDictIsSyncToMr(HisVerId)	;调用病案系统获取同步标识接口
		q:IsSyncMedcas'="Y" $p(Instring,"^",1) ;配置不同步病案直接返回rowid
		
		s HisVerName=$p(DictStr,"^",4)		;版本名称
		s aCode=$p(Instring,"^",3) 				;代码(诊断编码)
		s aICD10=$p(Instring,"^",3) 			;主码(诊断编码)
		s aICDinPair=""						;副码
		s aDesc =$p(Instring,"^",4) 			;ICD名称(诊断描述)
		s aGrayCodeFlag=""					;医保灰码标记
		s aMrcID=$p(Instring,"^",1)				;诊断ID
		s aOrcID=""							;手术ID
		s aActDate=$p(Instring,"^",14)			;启用日期
		s aEndDate=$p(Instring,"^",25)			;停用日期
		s aOperTypeDesc=""					;手术类型名称
		s aOperLevelDesc=""					;手术级别名称
		s aAlias=""							;别名
		s ErrMsg=""							;地址传递方式，记录接口错误信息
	}
	i (SendType="oper"){
		s HisVer=$P(Instring,"^",35)         ;院内版本号（代码）      
		s DictStr=##class(web.DHCINSUPortUse).GetDictInfoByCode(HisVer)	
		s HisVerId=$p(DictStr,"^",1)
		s IsSyncMedcas=##class(web.DHCBL.CT.BDVersionDict).GetDictIsSyncToMr(HisVerId)	;调用病案系统获取同步标识接口
		q:IsSyncMedcas'="Y" $p(Instring,"^",1) ;配置不同步病案直接返回
		
		s HisVerName=$p(DictStr,"^",4)				;版本名称
		;s aIsActive=$P(Instring,"^",22)			;有效标志
		s aCode=$P(Instring,"^",14) 				;代码(手术操作代码)
		s aICD10=$P(Instring,"^",14) 				;主码(手术操作代码)
		s aICDinPair=""								;副码
		s aDesc =$P(Instring,"^",15)				;ICD名称(手术操作名称)
		s aGrayCodeFlag=""							;医保灰码标记
		s aMrcID=""									;诊断ID
		s aOrcID=$p(Instring,"^",1)					;手术ID
		s aActDate=$P(Instring,"^",24)				;启用日期(数据创建日期)
		s:aActDate="" aActDate=$P(Instring,"^",30)	;启用日期(数据创建日期为空时取His创建日期)
		s aEndDate=""								;停用日期
		s aOperTypeDesc=""							;手术类型名称
		s aOperLevelDesc=""							;手术级别名称
		s aAlias=""									;别名
		s ErrMsg=""									;地址传递方式，记录接口错误信息
	}

	s ^temp("SendICDInfo20230203")=$lb(2,HisVer,HisVerName,aCode,aICD10,aICDinPair,aDesc,aGrayCodeFlag,aMrcID,aOrcID,aActDate,aEndDate,aIsActive,aOperTypeDesc,aOperLevelDesc,aAlias,ErrMsg)
	s sendRtn=##class(MA.IPMR.IO.OutService).SendICDInfo(2,HisVer,HisVerName,aCode,aICD10,aICDinPair,aDesc,aGrayCodeFlag,aMrcID,aOrcID,aActDate,aEndDate,aIsActive,aOperTypeDesc,aOperLevelDesc,aAlias,ErrMsg)	;调用病案系统同步版本接口
	q:+sendRtn<1 $p(Instring,"^",1)_"!保存成功,调用病案接口同步失败，接口返回："_$P(sendRtn,"^",1)_$P(sendRtn,"^",2)
	s sendRtn = $p(Instring,"^",1)_"!保存成功,同步病案系统成功："_$P(sendRtn,"^",1)
	q sendRtn
}

/// 诊断/手术对照信息同步到病案系统
/// HanZH 2023-05-24
/// Description：调用病案系统同步接口
/// 入参：
/// 	Instring	医保信息串
/// 	SendType	同步类型（diag/oper)
/// 	aIsActive	有效标志
/// 出参：
/// 	rowid   "rowid!保存对照成功,同步病案系统失败,同步失败原因"  "rowid!保存对照成功,同步病案系统成功"
/// w ##class(web.DHCINSUPortUse).SendICDMapInfo("","","")
ClassMethod SendICDMapInfo(Instring, SendType, aIsActive = "1") As %String
{
	new (Instring,aIsActive,SendType)
	q:SendType="" "-1!同步类型传入为空"
	s (HisVer,hiscode,InsuVer,insucode,aIsActive,ErrMsg)=""
	s sendRtn=""
	
	i (SendType="diag"){
		s HisVer=$p(Instring,"^",21)
		s DictStr1=##class(web.DHCINSUPortUse).GetDictInfoByCode(HisVer)
		s HisVerId=$p(DictStr1,"^",1)
		s InsuVer=$p(Instring,"^",22)
		s DictStr2=##class(web.DHCINSUPortUse).GetDictInfoByCode(InsuVer)
		s InsuVerId=$p(DictStr2,"^",1)
		s IsSyncMedcas= ##class(web.DHCBL.CT.BDVersionDictInsu).GetIsSyncToMr(HisVerId,InsuVerId)	;调用病案系统获取同步标识接口
		q:IsSyncMedcas'="Y" $p(Instring,"^",1) 	;配置不同步病案时直接返回
		s hiscode=$p(Instring,"^",3)	;ICD编码
		s insucode=$p(Instring,"^",6)	;对照ICD编码
		s ErrMsg=""					;此参数为地址传递方式，记录接口错误信息
	}
	i (SendType="oper"){
		s HisVer=$p(Instring,"^",23)
		s DictStr1=##class(web.DHCINSUPortUse).GetDictInfoByCode(HisVer)
		s HisVerId=$p(DictStr1,"^",1)
		s InsuVer=$p(Instring,"^",24)
		s DictStr2=##class(web.DHCINSUPortUse).GetDictInfoByCode(InsuVer)
		s InsuVerId=$p(DictStr2,"^",1)
		s IsSyncMedcas= ##class(web.DHCBL.CT.BDVersionDictInsu).GetIsSyncToMr(HisVerId,InsuVerId)	;调用病案系统获取同步标识接口
		q:IsSyncMedcas'="Y" $p(Instring,"^",1) 	;配置不同步病案时直接返回
		s hiscode=$p(Instring,"^",3)	;ICD编码
		s insucode=$p(Instring,"^",6)	;对照ICD编码
		s ErrMsg=""					;此参数为地址传递方式，记录接口错误信息
	}

	//调用同步
	s sendRtn=##class(MA.IPMR.IO.OutService).SendICDMapInfo(HisVer,hiscode,InsuVer,insucode,aIsActive,ErrMsg)	;调用病案系统同步版本接口
	q:(+sendRtn<1)&&(aIsActive="0") $P(sendRtn,"^",1)_"!删除对照失败,调用病案接口同步失败，接口返回："_$P(sendRtn,"^",2)
	q:+sendRtn<1 $p(Instring,"^",1)_"!对照失败,调用病案接口同步失败，接口返回："_$P(sendRtn,"^",1)_$P(sendRtn,"^",2)
	s sendRtn = $p(Instring,"^",1)_"!对照成功,调用病案接口成功："_$P(sendRtn,"^",1)
	q sendRtn
}

// ------------------------作废函数---------------------->

/*
/// Creator：      	刘书凤
/// CreatDate：    	2010 06 22
/// Description:：  根据医嘱项Rowid取库存项
/// Table：       
/// Input：        	Arcim:医嘱项表的Rowid
/// Output：      
/// Return：      	inci
/// Others：      作废20200213
/// w ##class(web.DHCINSUPortUse).GetInciGGByARCIMDr(29112)
ClassMethod GetInciGGByARCIMDrOld(ARCIMDr As %String) As %String
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
ClassMethod GetTarItemActiveByOltOld(TarDr) As %String
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
ClassMethod GetTarItemActiveByARCIMItemCatOld(TarDr) As %String
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
ClassMethod GetItmBaseInfoOld(IncID, ArcID, gFlag) As %String
{
	n (IncID,ArcID,gFlag)
	s GetItmBaseInfo=##class(web.DHCSTCOMINC).GetItmBaseInfo(IncID,ArcID,gFlag)
 	q GetItmBaseInfo
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
ClassMethod GetIncAddInfoOld(IncID, TarID, ArcID) As %String
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

/// Description:通过收费项ID取药品信息 
/// Input:	收费项ID	
/// Return：	规格、基本单位、入库单位、剂型dr、剂型、厂家、每次用量(等效单位)、频次、剂量单位、批准文号 
/// Others:		医保组上传数据调用，由于入参是收费项厂家取三大项默认的，等效单位只取第一个！
/// w ##class(web.DHCINSUPortUse).GetDrugInfoByTar("1")
/// 作废20200213,统一取药品信息接口，整理字段统一接口20200514
ClassMethod GetDrugInfoByTarOld(TarId As %String) As %String
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
ClassMethod GetInciStandardCodeOld(InciId) As %String
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
ClassMethod GetInciRemarkOld(InciId) As %String
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
ClassMethod GetInciImportFlagOld(InciId) As %String
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
ClassMethod GetOTCByArcimidOld(arcimid As %String) As %Library.String
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
ClassMethod GetManFInfoOld(InciId) As %String
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
ClassMethod GetManFInfoByTarCodeOld(tCode) As %String
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
*/

/// <-----------------------------------------------------//

}
