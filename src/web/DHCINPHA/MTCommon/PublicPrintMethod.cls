/// Description:公共打印方法类
/// Creator:    hulihua
/// CreateDate: 2017-12-01
/// Table:
Class web.DHCINPHA.MTCommon.PublicPrintMethod Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description:获取打印中药调剂单的内容
/// Creator:	hulihua
/// CreateDate:	2017-12-01
/// Table:      
/// Input:		phac-发药主表ID
/// Output:		主信息串！！明细信息串
/// Return： 	0-不可发药,1-可发药 
/// Others:		
/// Debug:		w ##class(web.DHCINPHA.MTCommon.PublicPrintMethod).GetPrtDispSheetInfo("230")
ClassMethod GetPrtDispSheetInfo(phac As %String) As %Library.String
{
	n (phac,%session)
	q:phac="" ""
	s PhaLocDr=$p(^DHCPHAC(phac),"^",1)   			//发药科室
	s PhaLocDesc=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetLocInfoById(PhaLocDr),"^",2)
	s prescNo=$p($g(^DHCPHAC(phac,1)),"^",1)	//处方号
	q:prescNo="" ""
	s Warddr=$p(^DHCPHAC(phac),"^",4)
	s WardLocdr=$p(^PAWARD(Warddr),"^",5)  	
	s Ward=$p(^CTLOC(WardLocdr),"^",2)				//病区
	s Phor=$o(^DHCPHORDM(0,"PrescNo",prescNo,""))
	s ChkUser=""
	i Phor'="" d
	.s ChkUserdr=$p(^DHCPHORDM(Phor),"^",1)
	.s ChkUser=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetUserInfoById(ChkUserdr),"^",2)  //审核人
	s prescOrdInfo=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPreOrdInfo(prescNo)
	s DocLoc=$p(prescOrdInfo,"^",1)  														//开单科室	
	s prescInfoStr=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPaQueInfo(prescNo)
	s Instruc=$p(prescInfoStr,"^",1)														//用法
	s Factor=$p(prescInfoStr,"^",2)															//付数
	s StDate=$p(prescInfoStr,"^",4)															//开始日期
	s CoookType=$p(prescInfoStr,"^",7)														//煎药方式
	s:CoookType["代" CoookType="煎"
	s:CoookType["免" CoookType="免"
	s:CoookType["自" CoookType="自"
	s PrescForm=$p(prescInfoStr,"^",8) 														//处方剂型
	s PrescMoney=0																			//处方金额
	s FreqDesc=$p(prescInfoStr,"^",9)  														//频次
	s PreConfig=$p(prescInfoStr,"^",10)														//配置
	s OrderQtyDesc=$p(prescInfoStr,"^",11)													//用量
	s DrugInfo=$p(prescInfoStr,"^",12) 														//功效（解表类 一般类 滋补类）
	s PrescName=$p(prescInfoStr,"^",13)														//处方名
	s Doctor=$p(prescInfoStr,"^",26)  														//开单医生
	s admDr=$p(prescInfoStr,"^",27)															//就诊ID
	s patInfo=##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).GetPatInfo(admDr,phac)
	s PatNo=$p(patInfo,"^",1)
	s PatName=$p(patInfo,"^",3)
	s PameNo=$p(patInfo,"^",12)																//病案号
	s curBedcode=$p(patInfo,"^",13)															//床号
	s PrescCount=##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetPrescNoCount(prescNo)	//处方味数
	//先取处方的关联诊断，如果取空了再取该患者的中医诊断！
	//s PadiagNose=##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetPrescDiagnos(prescNo) 	//诊断
	s PadiagNose=##class(PHA.FACE.IN.Com).GetMRDiagnosDesc(prescNo,",")				//取处方关联诊断
    s:PadiagNose="" PadiagNose=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(admDr,",","GC")
	s LabelType="住"
	s PreString1=PhaLocDesc_"^"_PatNo_"^"_PatName_"^"_PadiagNose_"^"_LabelType
	s PreString2=Instruc_"^"_Factor_"^"_StDate_"^"_PreConfig_"^"_PrescName
	s PreString3=DocLoc_"^"_Doctor_"^"_PrescCount_"^"_PrescMoney_"^"_prescNo
	s PreString4=FreqDesc_"^"_DrugInfo_"^"_PrescForm_"^"_ChkUser_"^"_Ward
	s PreString5=curBedcode_"^"_PameNo_"^"_CoookType_"^"_OrderQtyDesc
	s PreString=PreString1_"^"_PreString2_"^"_PreString3_"^"_PreString4_"^"_PreString5
	//以下为明细
	s phacch="",medstring=""
	f  s phacch=$o(^DHCPHAC(phac,"I",phacch))  q:phacch=""  d
	.s DispId=$p(^DHCPHAC(phac,"I",phacch),"^",13)
	.q:DispId=""
	.s phacsub=""
	.f  s phacsub=$o(^DHCPHAC(phac,"I",phacch,"B",phacsub))  q:phacsub=""  d
	..s Inclb=$p(^DHCPHAC(phac,"I",phacch,"B",phacsub),"^",1)
	..q:Inclb=""
	..s Inci=+Inclb
	..s InciDesc=$p(^INCI(Inci,1),"^",2)
	..s Qty=$p(^DHCPHAC(phac,"I",phacch,"B",phacsub),"^",2)
	..s Qty=Qty/Factor
	..s Qty=##Class(web.DHCSTPCHCOLLPRN).getPackQty(Inci,Qty)
	..s SpAmt=$p(^DHCPHAC(phac,"I",phacch,"B",phacsub),"^",6)
	..s PrescMoney=PrescMoney+SpAmt
	..s tmpsting=InciDesc_"^"_Qty
	..i medstring="" d
	...s medstring=tmpsting
	..e  d
	...s medstring=medstring_"@"_tmpsting
	..
	.
	s $p(PreString,"^",14)=PrescMoney 
	s $p(^DHCPHAC(phac),"^",16)=+$p(^DHCPHAC(phac),"^",16)+1	//记录打印次数
	q PreString_"!!"_medstring
}

/// Description:获取打印中药调剂单的内容
/// Creator:	psc
/// CreateDate:	2017-12-01
/// Table:      
/// Input:		phac-发药主表id
/// Output:		
/// Return： 	处方号^姓名^登记号^开单医生^开单科室^开始时间^用法^频次^用量
/// Others:		 
/// Debug:		w ##class(web.DHCINPHA.MTCommon.PublicPrintMethod).GetPrintPrescLabelInfo("230")
ClassMethod GetPrintPrescLabelInfo(Phac As %String) As %String
{
	n (Phac)
	q:Phac="" ""
	s Locdr=$p(^DHCPHAC(Phac),"^",1)
	s LocDesc=$p(^CTLOC(Locdr),"^",2)
	s prescNo=$p($g(^DHCPHAC(Phac,1)),"^",1)	//处方号
	q:prescNo="" ""
	s prescOrdInfo=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPreOrdInfo(prescNo)
	s DoctorLoc=$p(prescOrdInfo,"^",1)  		//开单科室
	s prescInfoStr=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPaQueInfo(prescNo)
	s Instruc=$p(prescInfoStr,"^",1)  			//用法
	s Quexdate=$p(prescInfoStr,"^",5)  			//开始时间
	s PrescForm=$p(prescInfoStr,"^",8) 			//处方剂型
	s FreqDesc=$p(prescInfoStr,"^",9)  			//频次
	s OrderQtyDesc=$p(prescInfoStr,"^",11) 		//用量
	s DrugInfo=$p(prescInfoStr,"^",12) 			//功效（解表类 一般类 滋补类）
	s DurationDesc=$p(prescInfoStr,"^",14)  	//疗程
	s Doctor=$p(prescInfoStr,"^",26)  			//开单医生
	s admDr=$p(prescInfoStr,"^",27)				//就诊ID
	s patInfo=##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).GetPatInfo(admDr)
	s PatNo=$p(patInfo,"^",1)  					//登记号
	s PatName=$p(patInfo,"^",3) 				//姓名
	s dataStr1=prescNo_"^"_PatNo_"^"_PatName_"^"_Doctor_"^"_DoctorLoc
	s dataStr2=Quexdate_"^"_Instruc_"^"_FreqDesc_"^"_OrderQtyDesc	
	s dataStr3=LocDesc_"^"_PrescForm_"^"_DrugInfo_"^"_DurationDesc
	s dataStr=dataStr1_"^"_dataStr2_"^"_dataStr3
	q $g(dataStr)
}

}
