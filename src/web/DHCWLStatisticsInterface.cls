/// 统计室系统模块接口类
Class web.DHCWLStatisticsInterface Extends %RegisteredObject
{

/// Creator：      	chenyi
/// CreatDate：    	2018-07
/// Description:：	通过adm获取诊断，诊断顺序可以设置
/// Table：       	
/// Input：       	入参admId
/// Output：      	
/// Return：      	
/// Others：      	w ##class(web.DHCWLStatisticsInterface).GetMedNoByAdm(1)
ClassMethod GetMedNoByAdm(admId) As %String
{
	s ret=""
	q:admId="" ret
	//s ret=##Class(web.DHCWMRService).IGetMrNoByEpisodeID(admId)
	//s ret=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(Paadm,"I")  ;三版：
	s ret=##Class(MA.IPMR.IO.OutService).GetMrNoByEpisodeID(admId)   ;四版：
	q ret
}

/// Creator：      	chenyi
/// CreatDate：    	2018-07
/// Description:：	通过adm获取诊断，诊断顺序可以设置
/// Table：       	
/// Input：       	入参admId
/// Output：      	
/// Return：      	
/// Others：      	w ##class(web.DHCWLStatisticsInterface).GetDiagByAdm(1,"")
ClassMethod GetDiagByAdm(admId, order) As %String
{
	s ret=""
	
	i order="" s order="M,DIS"
	s ln=$l(order,",")
	f i=1:1:ln d
	.s arr(i)=$p(order,",",i)
	s i=0 f  s i=$o(arr(i)) q:(i="")||(ret'="")  d
	.s type=$g(arr(i))
	.i type'="M" s ret=$$GetFriDisDiagnos^DHCWLCommon(admId,type)
	.e  s ret=##class(web.DHCWLTJSCommonFunction).GetMainDiagTimeByAdm(admId)  //8.3版本发现：主要诊断变成了一个标志了
	i (ret="")||(ret="Null")||(ret="NULL") s ret=$$GetFriDisDiagnos^DHCWLCommon(admId,"")
	/*
	i order="M" s flag="Y"
	e  s flag=""
	s ret=##class(DHCDoc.Interface.Inside.ServiceDiag).GetAdmDiagDesc(admId,"",flag)
	*/
	q ret
}

/// Creator：      	chenyi
/// CreatDate：    	2018-08
/// Description:：	各类型患者明细动态接口
/// Table：       	
/// Input：       	入参admId
/// Output：      	
/// Return：      	
/// Others：      	w ##class(web.DHCWLStatisticsInterface).GetDetPatInfoActive(1,"死亡")
ClassMethod GetDetPatInfoActive(admId, dateType) As %String
{
	s ret="0"
	i dateType["死亡" s ret=##class(web.DHCWLStatisticsInterface).GetDieFlagByAdm(admId)
	i dateType["抢救" s ret=##class(web.DHCWLStatisticsInterface).GetQJFlagByAdm(admId)
	q ret
}

// ;/ Others：      	w ##class(web.DHCWLStatisticsInterface).GetDieFlagByAdm(1)

/// Creator：      	chenyi
/// CreatDate：    	2018-07
/// Description:：	通过adm判断患者是否死亡，死亡返回1，否则返回0
/// Table：       	
/// Input：       	入参admId
/// Output：      	
/// Return：      	1：死亡，0：未死亡
ClassMethod GetDieFlagByAdm(admId) As %String
{
	s ret=0
	s ordDr=0 f  s ordDr=$o(^OEORD(0,"Adm",admId,ordDr)) q:ordDr=""  d
	.s ordSubDr=0 f  s ordSubDr=$o(^OEORD(ordDr,"I",ordSubDr)) q:ordSubDr=""  d
	..s arcimDr=$p($g(^OEORD(ordDr,"I",ordSubDr,1)),"^",2)
	..s arcimDesc=$$GetARCIMName^DHCWLBuildDimDataARCIM(arcimDr)
	..s orderDate=$p($g(^OEORD(ordDr,"I",ordSubDr,3)),"^",7)
	..i orderDate'="" s orderDate=$zd(orderDate,3)
	..e  s orderDate=""
	..i arcimDesc["死亡" s ret="1"_"^"_arcimDesc_"^"_orderDate
	;s ret="1"_"^"_"死亡"_"^"_"2019-01-01"
	q ret
}

ClassMethod GetQJFlagByAdm(admId) As %String
{
	s ret=0
	s ordDr=0 f  s ordDr=$o(^OEORD(0,"Adm",admId,ordDr)) q:ordDr=""  d
	.s ordSubDr=0 f  s ordSubDr=$o(^OEORD(ordDr,"I",ordSubDr)) q:ordSubDr=""  d
	..s arcimDr=$p($g(^OEORD(ordDr,"I",ordSubDr,1)),"^",2)
	..s arcimDesc=$$GetARCIMName^DHCWLBuildDimDataARCIM(arcimDr)
	..s orderDate=$p($g(^OEORD(ordDr,"I",ordSubDr,3)),"^",7)
	..i orderDate'="" s orderDate=$zd(orderDate,3)
	..e  s orderDate=""
	..i arcimDesc["抢救" s ret="1"_"^"_arcimDesc_"^"_orderDate
	;s ret="1"_"^"_"抢救"_"^"_"2019-01-01"
	q ret
}

/// Creator：      	chenyi
/// CreatDate：    	2018-07
/// Description:：	通过adm获取服务半径
/// Table：       	
/// Input：       	入参admId
/// Output：      	
/// Return：      	籍贯所在的"省^市"
/// Others：      	w ##class(web.DHCWLStatisticsInterface).GetserviceRadius(1)
ClassMethod GetserviceRadius(admId) As %String
{
	s provinceDesc="未填",cityAreaDesc="未填"
	s papmi=$p(^PAADM(admId),"^",1)
	s provinceDr=$p(^PAPER(papmi,"PER",4),"^",2)
	i provinceDr'="" s provinceDesc=$p(^CT("PROV",provinceDr),"^",2)   //省
	s cityAreaDr=$p(^PAPER(papmi,"PER",4),"^",9)	//市
	i cityAreaDr'="" s cityAreaDesc=$p(^CT("CITAREA",cityAreaDr),"^",2)
	q provinceDesc_"^"_cityAreaDesc
}

/// Creator：      	chenyi
/// CreatDate：    	2018-07
/// Description:：	住院统一调查表，西药费等费用分类接口
/// Table：       	
/// Input：       	入参workload表rowid
/// Output：      	
/// Return：      	费用类型：也就是统计子组描述
/// Others：      	w ##class(web.DHCWLStatisticsInterface).GetZYDCBFeeType(wlId)
ClassMethod GetZYDCBFeeType(wlId) As %String
{
	s code="ZYDCB"
	s tarICate=$p(^DHCWorkLoad(wlId),"^",41)  	//核算分类
	q $p(##class(DHCWL.CodeCfgData.FunctionModule).GetSubGrpByItemDr(tarICate,code),"^",1)
}

/// Creator：      	chenyi
/// CreatDate：    	2018-07
/// Description:：	住院统一调查表，医保费用
/// Table：       	
/// Input：       	入参admid
/// Output：      	
/// Return：      	保险统筹基金支付费用^个人账户支付^患者自负费用
/// Others：      	w ##class(web.DHCWLStatisticsInterface).GetZYDCBYBFee(adm)
ClassMethod GetZYDCBYBFee(adm) As %String
{
	q "0^0^0"   //根据项目实际情况修改,这里直接返回0
	s sumTczf=0,sumZhzf=0,sumGrzf=0
    s pbId=0 f  s pbId=$o(^DHCPB(0,"ADM",adm,pbId)) q:pbId=""  d
  	.s pbRefundFlag=$P(^DHCPB(pbId),"^",17)
  	.q:pbRefundFlag="B"
  	.s ybfyStr=##class(web.DHCINSUPort).GetDivideInfoIPPre("",pbId)
 	.q:ybfyStr=-1
  	.s tczf=$P(ybfyStr,"^",3)  //统筹支付
  	.s zhzf=$P(ybfyStr,"^",2)  //账户支付
  	.s grzf=$P(ybfyStr,"^",4)  //个人支付(患者自付)
  	.s sumTczf=sumTczf+tczf    //统筹
  	.s sumZhzf=sumZhzf+zhzf    //账户
  	.s sumGrzf=sumGrzf+grzf    //个人
  	s ret=$g(sumTczf)_"^"_$g(sumZhzf)_"^"_$g(sumGrzf)
	q ret
}

/// Creator：      	chenyi
/// CreatDate：    	2018-07
/// Description:：	门诊统一调查表，西药费等费用分类接口
/// Table：       	
/// Input：       	入参workload表rowid
/// Output：      	
/// Return：      	费用类型：也就是统计子组描述
/// Others：      	w ##class(web.DHCWLStatisticsInterface).GetMZDCBFeeType(wlId)
ClassMethod GetMZDCBFeeType(wlId) As %String
{
	s code="MZDCB"
	s tarICate=$p(^DHCWorkLoad(wlId),"^",41)  	//核算分类
	q $p(##class(DHCWL.CodeCfgData.FunctionModule).GetSubGrpByItemDr(tarICate,code),"^",1)
}

/// Creator：      	chenyi
/// CreatDate：    	2018-07
/// Description:：	门诊统一调查表，医保费用
/// Table：       	
/// Input：       	入参admid
/// Output：      	
/// Return：      	保险统筹基金支付费用^个人账户支付^患者自负费用
/// Others：      	w ##class(web.DHCWLStatisticsInterface).GetMZDCBYBFee(adm)
ClassMethod GetMZDCBYBFee(adm) As %String
{
	q "0^0^0"   //根据项目实际情况修改,这里直接返回0
	s sumTczf=0,sumZhzf=0,sumGrzf=0  
  	s bciRowid=0 f  s bciRowid=$o(^DHCBCI(0,"ADM",adm,bciRowid)) q:bciRowid=""  d
  	.s prtId=$p(^DHCBCI(bciRowid),"^",1) 
  	.s ybfyStr=##class(web.DHCINSUPort).GetDivideInfoIPPre(prtId,"")
  	.;w "ybfyStr="_prtId_"^"_ybfyStr,!
  	.q:ybfyStr=-1
  	.;w "ybfyStr="_ybfyStr,!
  	.s tczf=$P(ybfyStr,"^",3)  //统筹支付
  	.s zhzf=$P(ybfyStr,"^",2)  //账户支付
  	.s grzf=$P(ybfyStr,"^",4)  //个人支付(患者自付)
  	.s sumTczf=sumTczf+tczf    //统筹
  	.s sumZhzf=sumZhzf+zhzf    //账户
  	.s sumGrzf=sumGrzf+grzf    //个人
  	s ret=$g(sumTczf)_"^"_$g(sumZhzf)_"^"_$g(sumGrzf)
	q ret
}

/// Creator：      	chenyi
/// CreatDate：    	2019-07
/// Description:：	获取病案首页的高危颜色
/// Table：       	
/// Input：       	入参admid
/// Output：      	
/// Return：      	颜色（黄色，绿色，橙色，红色，紫色）
/// Others：      	w ##class(web.DHCWLStatisticsInterface).GetGWYSByAdm(adm)
ClassMethod GetGWYSByAdm(adm) As %String
{
	q:adm="" ""
	s mAdmData=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(adm,"HDSD00.03.01")
	s GWData=mAdmData.GetAt("HDSD00.03.506")
	q $g(GWData)
}

/// Creator：      	chenyi
/// CreatDate：    	2018-07
/// Description:：	获取损伤、中毒的外部原因
/// Table：       	
/// Input：       	入参admid
/// Output：      	
/// Return：      	损伤、中毒的外部原因
/// Others：      	w ##class(web.DHCWLStatisticsInterface).GetSSZDWBYYByAdm(adm)
ClassMethod GetSSZDWBYYByAdm(adm) As %String
{
	s mTraumaStr=##Class(web.DHCWMRCodingInterface).getFrontPageICD(adm,"D/5","1")
	s sszdDesc=$p(mTraumaStr,$c(2),2)
	q $g(sszdDesc)
}

/// Creator：      	ZCX
/// CreatDate：    	2018-07-04
/// Description:：	判断病人是否死亡
/// Table：       	PA_Adm
/// Input：       	开始时间，结束时间，统计项id
/// Output：      	
/// Return：      	1：死亡 0,：未死亡
/// Others：      	d ##class(web.DHCWLStatisticsInterface).GetDisAdmIsDeadFlag(admid)
ClassMethod GetDisAdmIsDeadFlag(admid) As %String
{
	
 	q:$g(admid)="" 0
 	s mrifId=$o(^DHCMRInfo(0,"MR_PAADM_DR",admid,""))
 	q:$g(mrifId)="" 0
 	s lyfs=$p(^DHCMRInfo(mrifId),"^",46)	;离院方式
 	i lyfs="死亡" s flag=1
 	e  s flag=0
	q flag
}

/// Creator：      	？？？
/// CreatDate：    	2018-07-04
/// Description:：	判断病人是否抢救
/// Table：       	DHC_workLoad
/// Input：       	开始时间，结束时间，统计项id
/// Output：      	
/// Return：      	1：抢救 0,：未抢救
/// Others：      	d ##class(web.DHCWLStatisticsInterface).GetDisAdmIsRescueFlag(admid)
ClassMethod GetDisAdmIsRescueFlag(admid) As %String
{
	
 	q:$g(admid)="" 0
 	s mrifId=$o(^DHCMRInfo(0,"MR_PAADM_DR",admid,""))
 	q:$g(mrifId)="" 0
 	s qjcs=$p(^DHCMRInfo(mrifId),"^",229)	;抢救次数
 	i +$g(qjcs)>0 s flag=1
 	e  s flag=0
	q flag
}

/// Creator：      	ZCX
/// CreatDate：    	2018-07-04
/// Description:：	判断病人是否传染病
/// Table：       	MR_Adm
/// Input：       	admid
/// Output：      	（出院主诊断传染病ICD编码范围：A00.--至B49.--)
/// Return：      	1：有传染病 0,：没有传染病
/// Others：      	d ##class(web.DHCWLStatisticsInterface).GetDisAdmIsCRFlag(admid)
ClassMethod GetDisAdmIsCRFlag(admid) As %String
{
	
 	q:$g(admid)="" 0
 	s flag=0
 	s str=$$GetFriDisDiagnos^DHCWLCommon(admid,"DIS")
	s cyzdCode=$p(str,"^",2)
	i (cyzdCode["A")||(cyzdCode["B0")||(cyzdCode["B1")||(cyzdCode["B2")||(cyzdCode["B3")||(cyzdCode["B4") d
 	.s flag=1
	q flag
}

/// Creator：      	ZCX
/// CreatDate：    	2018-07-04
/// Description:：	判断病人是否为手术病人
/// Table：       	DHCWL_Anaesthesia
/// Input：       	admid
/// Output：      	
/// Return：      	1：有手术 0,：没有手术
/// Others：      	d ##class(web.DHCWLStatisticsInterface).GetDisAdmIsOPerFlag(admid)
ClassMethod GetDisAdmIsOPerFlag(admid) As %String
{
 	q:$g(admid)="" 0
 	s mrifId=$o(^DHCMRInfo(0,"MR_PAADM_DR",admid,""))
 	q:$g(mrifId)="" 0
 	s ssbm1=$p(^DHCMRInfo(mrifId),"^",119)	;主手术编码
 	i ssbm1'="" s flag=1
 	e  s flag=0
	q flag
}

/// Creator：      	ZCX
/// CreatDate：    	2018-07-04
/// Description:：	判断病人是否为感染病人
/// Table：       	DHCMRInfo
/// Input：       	admid
/// Output：      	
/// Return：      	1：有手术 0,：没有手术
/// Others：      	d ##class(web.DHCWLStatisticsInterface).GetDisAdmIsGRFlag(admid)
ClassMethod GetDisAdmIsGRFlag(admid) As %String
{
 	q:$g(admid)="" 0
 	s mrifId=$o(^DHCMRInfo(0,"MR_PAADM_DR",admid,""))
 	q:$g(mrifId)="" 0
 	s ssbm1=$p(^DHCMRInfo(mrifId),"^",116)	;院内感染编码
 	i ssbm1'="" s flag=1
 	e  s flag=0
	q flag
}

}
