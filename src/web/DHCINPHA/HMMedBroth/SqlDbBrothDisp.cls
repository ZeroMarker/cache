/// Description:揭药室揭药操作表结构相关
/// Creator:    hulihua
/// CreateDate: 2017-09-08
/// Table:      DHC_PhaMedBroth-揭药主表、DHC_PhaMedBrothItm-揭药子表
Class web.DHCINPHA.HMMedBroth.SqlDbBrothDisp Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Description:更新揭药子表表结构方法
/// Creator:	hulihua
/// CreateDate:	2017-09-08
/// Table:      DHC_PhaMedBroth-揭药主表、DHC_PhaMedBrothItm-揭药子表
/// Input:		
/// Output:		
/// Return：	0-成功，非0-失败 
/// w ##class(web.DHCINPHA.HMMedBroth.SqlDbBrothDisp).SaveBrothDispDb("3##")
ClassMethod SaveBrothDispDb(listData As %String, BrothDispUser As %String) As %String
{
	n (listData, BrothDispUser)
	s Phmbi=$p(listData,"^",1)
	q:Phmbi="" -1
	s ActUncovMedPocNum=$p(listData,"^",3)
	s ActUncovMedDate=+$h
	s ActUncovMedTime=$p($h,",",2)
	s ReMark=$p(listData,"^",4)
	s UncovMedFlag=$p(^DHCPHAMEDB(+Phmbi,"I",$p(Phmbi,"||",2)),"^",5)
	q:UncovMedFlag="Y" -2
	s BatNo=$p(listData,"^",5)
	s err=0
	ts ;开启事务
	s $ZT="Error^DHCSTERROR"							;增加错误处理
	s err=..UpChPatWardLoc(Phmbi)
	i err'=0 tro
	q:err'=0 err
	s obj=##class(User.DHCPhaMedBrothItm).%OpenId(Phmbi)
	d obj.PHMBIBrothDispUserDRSetObjectId(BrothDispUser)
	s obj.PHMBIActUncovMedDate=ActUncovMedDate
	s obj.PHMBIActUncovMedTime=ActUncovMedTime
	s obj.PHMBIActUncovMedPocNum=ActUncovMedPocNum
	s obj.PHMBIUncovMedFlag="Y"
	s obj.PHMBIRemarks=ReMark
	s obj.PHMBIBatNo=BatNo
	s sc=obj.%Save()
	i $$$ISERR(sc) d
	.s err=-4
	i err'=0 tro
	q:err'=0 $SYSTEM.Status.GetErrorText(sc)
	s err=..UpMedBrothComFlag(+Phmbi)
	i err'=0 tro
	q:err'=0 err
	tc ;提交事务
	q err
}

/// Description:点击全送处理表结构的方法
/// Creator:	hulihua
/// CreateDate:	2017-09-08
/// Table:      DHC_PhaMedBroth-揭药主表、DHC_PhaMedBrothItm-揭药子表
/// Input:		
/// Output:		
/// Return：	0-成功，非0-失败 
/// w ##class(web.DHCINPHA.HMMedBroth.SqlDbBrothDisp).SaveAllSendBrothDisp("3##")
ClassMethod SaveAllSendBrothDisp(listData As %String, BrothDispUser As %String) As %String
{
	n (listData,BrothDispUser)
	s Phmbi=$p(listData,"^",1)
	s UncovMedFlag="N"
	s err=0
	s Phch=""
	f  s Phch=$o(^DHCPHAMEDBi("UncovMedFlag",UncovMedFlag,+Phmbi,Phch))  q:(Phch="")||(err'=0)  d
	.s $p(listData,"^",1)=+Phmbi_"||"_Phch
	.s ActUncovMedPocNum=$p(^DHCPHAMEDB(+Phmbi,"I",Phch),"^",6)
	.s $p(listData,"^",3)=ActUncovMedPocNum
	.s err=..SaveBrothDispDb(listData,BrothDispUser)
	.i err'=0 
	q:err'=0 err
	q err
}

/// Description:处理转科病人的揭药明细表信息
/// Creator:	hulihua
/// CreateDate:	2017-09-08
/// Table:      DHC_PhaMedBroth-揭药主表、DHC_PhaMedBrothItm-揭药子表
/// Input:		Phmbi-揭药子表ID		
/// Output:		
/// Return：	0-成功，非0-失败 
/// w ##class(web.DHCINPHA.HMMedBroth.SqlDbBrothDisp).UpChPatWardLoc("1||1")
ClassMethod UpChPatWardLoc(Phmbi As %String) As %String
{
	n (Phmbi)
	s UncovMedFlag="N"
	s Adm=$p(^DHCPHAMEDB(+Phmbi),"^",2)
	s AdmWard=$p(^PAADM(Adm),"^",70)  			;病人当前所在的病区
	s AdmWardLoc=$p(^PAWARD(AdmWard),"^",5)
	s WardLocDr=$p(^DHCPHAMEDB(+Phmbi,"I",$p(Phmbi,"||",2)),"^",1)
	q:AdmWardLoc=WardLocDr 0					;一致无需更新
	s OldPhboxId=$p(^DHCPHAMEDB(+Phmbi,"I",$p(Phmbi,"||",2)),"^",16)
	s PhboxId=""								;针对转科的撤销装箱
	//1、更新当前的这条
	s obj=##class(User.DHCPhaMedBrothItm).%OpenId(Phmbi)
	d obj.PHMBIOldWardLocDRSetObjectId(WardLocDr)
	d obj.PHMBIWardLocDRSetObjectId(AdmWardLoc)
	d obj.PHMBIPHBoxDrSetObjectId(PhboxId)
	s sc=obj.%Save()
	q:$$$ISERR(sc) $SYSTEM.Status.GetErrorText(sc)
	//2、其它未揭的也需更新
	s PhmbCh="",err=0,obj=""
	f  s PhmbCh=$o(^DHCPHAMEDBi("UncovMedFlag",UncovMedFlag,+Phmbi,PhmbCh))  q:(PhmbCh="")||(err'=0)  d
	.s PhmbiID=+Phmbi_"||"_PhmbCh
	.s obj=##class(User.DHCPhaMedBrothItm).%OpenId(PhmbiID)
	.d obj.PHMBIOldWardLocDRSetObjectId(WardLocDr)
	.d obj.PHMBIWardLocDRSetObjectId(AdmWardLoc)
	.s sc=obj.%Save()
	.i $$$ISERR(sc) d
	..s err=-3
	q:err'=0 $SYSTEM.Status.GetErrorText(sc)
	//3、箱子为空的记录删掉装箱记录
	i +OldPhboxId'="0" d
	.i '$d(^DHCPHAMEDBi("WardLocPHBoxDr",WardLocDr,OldPhboxId)) d
	..s result=##class(User.DHCPHBox).%DeleteId(OldPhboxId)
	..i $$$ISERR(result) d
	...s err=-4
	..e  d
	...s ^mdata("DHCPHBOX")=$o(^DHCPHBOX(""),-1)
	..s obj=""
	q err
}

/// Description:揭药子表完成之后最后处理揭药主表的揭药标志
/// Creator:	hulihua
/// CreateDate:	2017-12-09
/// Table:      DHC_PhaMedBroth-揭药主表、DHC_PhaMedBrothItm-揭药子表
/// Input:		PhmbId-揭药主表ID		
/// Output:		
/// Return：	0-成功，非0-失败 
/// w ##class(web.DHCINPHA.HMMedBroth.SqlDbBrothDisp).UpMedBrothComFlag("15")
ClassMethod UpMedBrothComFlag(PhmbId As %String) As %String
{
	n (PhmbId)
	q:$d(^DHCPHAMEDBi("UncovMedFlag","N",PhmbId)) 0
	s err=0
	s obj=##class(User.DHCPhaMedBroth).%OpenId(PhmbId)
	s obj.PHMBMedBroCompFlag="Y"
	s sc=obj.%Save()
	d obj.%Close()
	i $$$ISERR(sc) d
	.s err=-5
	q:err'=0 $SYSTEM.Status.GetErrorText(sc)
	q err
}

/// Description:从发药表获取到煎药信息并处理煎药相关表
/// Creator:	hulihua
/// CreateDate:	2017-11-15
/// Table:      DHC_PHACollected--住院发药主表
/// Input:		Phac-发药主表ID，BrothUserDR-揭药人ID，MedDataType-数据类型（""-手机端调剂，1-手工调剂或者协定方）		
/// Output:		
/// Return：	0-成功，非0-失败 
/// w ##class(web.DHCINPHA.HMMedBroth.SqlDbBrothDisp).GetMedBrothDataByPhc("232")
ClassMethod GetMedBrothDataByPhc(Phac As %String, BrothUserDR As %String = "", MedDataType As %String = "", batNo As %String = "") As %String
{
	n (Phac,BrothUserDR,MedDataType,batNo)
	s PhaCh=$o(^DHCPHAC(Phac,"I",""),-1)
	q:PhaCh="" "-11^HIS发药明细信息不存在！"
	s PhLocId=$p(^DHCPHAC(Phac),"^",1)
	s prescNo=$p($g(^DHCPHAC(Phac,1)),"^",1)
	q:prescNo="" "-19^该处方不是草药处方！"
	s PhmbType="I"
	s prescStr=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPaQueInfo(prescNo)
	s Factor=$p(prescStr,"^",2)
	s QueDate=$p(prescStr,"^",4)
	s preCoookType=$p(prescStr,"^",7)
	s prescForm=$p(prescStr,"^",8)
	q:((prescForm'["颗粒剂")&&(preCoookType["免煎"))||(preCoookType["自煎") 0
	s PrescForm=$p(prescStr,"^",8)
	s FreqFac=$p(prescStr,"^",16)
	s StartMedDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(QueDate)
	s:StartMedDate="" StartMedDate=+$h
	s TolPocNum=(+Factor)*(+FreqFac) 
	s AdmDr=$p(^DHCPHAC(Phac,"I",PhaCh),"^",3)
	s AdmWard=$p(^PAADM(AdmDr),"^",70)
	s WardLocId=$p(^PAWARD(AdmWard),"^",5)
	s IfAllSendMed=##class(web.DHCINPHA.MTCommon.PublicCallMethod).CheckIfAllSend(prescNo,PhLocId)
	s AllSendFlag=$s((MedDataType="1")||(IfAllSendMed="1"):"Y",1:"N")
	s MainData=prescNo_"^"_PhLocId_"^"_TolPocNum_"^"_Phac_"^"_AllSendFlag_"^"_PhmbType
	q:MainData="" "-12^获取处方主信息失败！"
	s PreStDate=$p(prescStr,"^",15)
	s DispUser=$p(^DHCPHAC(Phac),"^",34)
	s prescConfigSatr=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetHMPrescConfig(prescNo)
	s presAllSendFlag=$p(prescConfigSatr,"^",8)
	s num=0,DetailData=""
	s FactorNum=$s(AllSendFlag="Y":1,1:Factor)
	s UnMedPocNum=FreqFac
	f i=0:1:FactorNum-1  d
	.s (ActUnMedDate,ActUnMedTime,ActUnMedPocNum,Remarks)=""
	.s UncovMedFlag="N"
	.s MedDate=StartMedDate+i
	.s num=num+1
	.s BarCodeNum="0"_num
	.s BarCodeNum=$e(BarCodeNum,$l(BarCodeNum)-1,$l(BarCodeNum))
	.s BarCode=prescNo_BarCodeNum
	.i AllSendFlag="Y"  d
	..;1、如果满足全送的条件则所有揭药的信息都为揭药状态
	..s ActUnMedDate=+$h
	..s ActUnMedTime=$p($h,",",2)
	..//s UncovMedFlag="Y"
	..s ActUnMedPocNum=TolPocNum 
	..s Remarks=$s((MedDataType="1")||(presAllSendFlag="Y"):"揭药室采集",1:"煎药室打包")
	..s BrothUserDR=$s(BrothUserDR'="":BrothUserDR,1:DispUser)
	..s UnMedPocNum=TolPocNum
	.e  i (PreStDate["今")&&(i<2) d
	..;2、当日服用的在煎药室要把今明两天的都要送上去
	..s ActUnMedDate=+$h
	..s ActUnMedTime=$p($h,",",2)
	..//s UncovMedFlag="Y"
	..s ActUnMedPocNum=FreqFac 
	..s Remarks="煎药室已送"
	..s BrothUserDR=$s(BrothUserDR'="":BrothUserDR,1:DispUser)
	.s Detail1=WardLocId_"^"_MedDate_"^"_UnMedPocNum_"^"_BarCode_"^"_ActUnMedDate
	.s Detail2=ActUnMedTime_"^"_UncovMedFlag_"^"_ActUnMedPocNum_"^"_Remarks_"^"_BrothUserDR
	.s Detail3=batNo
	.s Detail=Detail1_"^"_Detail2_"^"_Detail3
	.s DetailData=$s(DetailData="":Detail,1:DetailData_"&&"_Detail)
	q:DetailData="" "-13^获取处方揭药明细信息失败！"
	s PhmbId=$o(^DHCPHAMEDBi("PrescNo",prescNo,""),-1)
	i PhmbId'=""  d
	.s ret=..UpdateMedBroth(PhmbId,MainData,DetailData)
	e  d
	.s ret=..InsertMedBroth(MainData,DetailData)
	q:ret'>0 ret
	q 0
}

/// Description:从第三方获取到煎药信息并处理煎药相关表
/// Creator:	hulihua
/// CreateDate:	2017-09-27
/// Table:      DHC_PhaMedBroth-揭药主表、DHC_PhaMedBrothItm-揭药子表
/// Input:		mainData-处方号^揭药药房^总袋数、detailData-揭药病区科室ID^揭药日期^应揭药袋数&&...		
/// Output:		
/// Return：	0-成功，非0-失败 
/// w ##class(web.DHCINPHA.HMMedBroth.SqlDbBrothDisp).InsertMedBroth("1||1")
ClassMethod InsertMedBroth(mainData As %String, detailData As %String) As %String
{
	n (mainData,detailData)
	s prescNo=$p(mainData,"^",1)
	l +^DHCINPHAHMLOCK(prescNo):2 e  q "-14^数据库加锁失败！"
	s err=0
	tstart
	s $ZT="Error^DHCSTERROR"						;增加错误处理
	s phmbid=$o(^DHCPHAMEDBi("PrescNo",prescNo,""),-1)
	i phmbid'="" d
	.s err=..DeletePhaMedBroth(phmbid)
	q:err'=0 "-15^删除揭药主表失败！"
	i err'=0 trollback  d Unlock
	s err=..InsertPhaMedBroth(mainData)
	i +err'>0 trollback  d Unlock
	q:+err'>0 "-16^插入揭药主表失败！"
	s main=+err
	s err=..InsertPhaMedBrothItm(main,detailData)
	i err<0 trollback  d Unlock
	q:err<0 "-17^插入揭药明细表失败！"
	s err=..UpMedBrothComFlag(main)
	i err<0 tro
	q:err<0 "-18^更新揭药主表状态失败！"
	tcommit
	d Unlock
	q main
	
Unlock 
	l -^DHCINPHAHMLOCK(prescNo)
	q
}

/// Description:从第三方获取到煎药信息之后如过表里面已经存在则直接更新
/// Creator:	hulihua
/// CreateDate:	2017-12-09
/// Table:      DHC_PhaMedBroth-揭药主表、DHC_PhaMedBrothItm-揭药子表
/// Input:		mainData-处方号^揭药药房^总袋数、detailData-揭药病区科室ID^揭药日期^应揭药袋数&&...		
/// Output:		
/// Return：	0-成功，非0-失败 
/// w ##class(web.DHCINPHA.HMMedBroth.SqlDbBrothDisp).UpdateMedBroth("1||1")
ClassMethod UpdateMedBroth(phmbid As %String, mainData As %String, detailData As %String) As %String
{
	n (phmbid,mainData,detailData)
	s prescNo=$p(mainData,"^",1)
	l +^DHCINPHAHMLOCK(prescNo):2 e  q "-14^数据库加锁失败！"
	s err=0
	tstart
	s $ZT="Error^DHCSTERROR"						;增加错误处理
	s err=..UpdatePhaMedBroth(phmbid,mainData)
	i err<0 trollback  d UnPlock
	q:err<0 "-15^更新揭药主表失败！"
	s main=+err
	s err=..UpdatePhaMedBrothItm(phmbid,detailData)
	i err<0 trollback  d UnPlock
	q:err<0 "-16^更新揭药明细表失败！"
	s err=..UpMedBrothComFlag(phmbid)
	i err<0 tro
	q:err<0 "-18^更新揭药主表状态失败！"
	tcommit
	d UnPlock
	q main
	
UnPlock 
	l -^DHCINPHAHMLOCK(prescNo)
	q
}

/// Description:插入揭药表相关信息
/// Creator:	hulihua
/// CreateDate:	2017-09-27
/// Table:      DHC_PhaMedBroth-揭药主表
/// Input:		mainData-处方号^揭药药房^总袋数		
/// Output:		
/// Return：	大于0-成功，小于0-失败 
/// w ##class(web.DHCINPHA.HMMedBroth.SqlDbBrothDisp).InsertPhaMedBroth("1||1")
ClassMethod InsertPhaMedBroth(mainData As %String) As %String
{
	n (mainData)
	s prescNo=$p(mainData,"^",1)
	s PhaLoc=$p(mainData,"^",2)
	s TolPocNum=$p(mainData,"^",3)
	s MedBroCompFlag="N"
	s Ord=$o(^OEORD(0,"PrescNo",prescNo,""),-1)
	s Adm=$p(^OEORD(Ord),"^",1)
	s Papmidr=$p(^PAADM(Adm),"^",1)
	s PhacId=$p(mainData,"^",4)
	s AllSendFlag=$p(mainData,"^",5)
	s PhmbType=$p(mainData,"^",6)
	s InsertDate=+$h,InsertTime=$p($h,",",2)
	s ret=0
	;初始化一个对象
	s obj=##class(User.DHCPhaMedBroth).%New()
	;对创建的对象的每一个属性进行赋值
	d obj.PHMBAdmDRSetObjectId(Adm)
	d obj.PHMBPapmiDRSetObjectId(Papmidr)
	d obj.PHMBPHALocDRSetObjectId(PhaLoc)
	d obj.PHMBPHADRSetObjectId(PhacId)
	s obj.PHMBPrescNo=prescNo
	s obj.PHMBTolPocNum=TolPocNum
	s obj.PHMBMedBroCompFlag=MedBroCompFlag
	s obj.PHMBInsertDate=InsertDate
	s obj.PHMBInsertTime=InsertTime
	s obj.PHMBMedAllSendFlag=AllSendFlag
	s obj.PHMBType=PhmbType
	;持久化对象
	s result=obj.%Save()
	d obj.%Close()
	i $$$ISERR(result) d
	.s obj=""
	.s ret=-1
    q:ret'=0 ret
    s MainId=obj.%Id()
    s obj=""
	q MainId
}

/// Description:更新揭药表相关信息
/// Creator:	hulihua
/// CreateDate:	2017-12-09
/// Table:      DHC_PhaMedBroth-揭药主表
/// Input:		mainData-处方号^揭药药房^总袋数		
/// Output:		
/// Return：	大于0-成功，小于0-失败 
/// w ##class(web.DHCINPHA.HMMedBroth.SqlDbBrothDisp).UpdatePhaMedBroth("1","^^4^")
ClassMethod UpdatePhaMedBroth(phmbId As %String, mainData As %String) As %String
{
	n (phmbId, mainData)
	s TolPocNum=$p(mainData,"^",3)
	s AllSendFlag=$p(mainData,"^",5) 
	s InsertDate=+$h,InsertTime=$p($h,",",2)
	s ret=0
	;初始化一个对象
	s obj=##class(User.DHCPhaMedBroth).%OpenId(phmbId)
	s obj.PHMBTolPocNum=TolPocNum
	s obj.PHMBInsertDate=InsertDate
	s obj.PHMBInsertTime=InsertTime
	s obj.PHMBMedAllSendFlag=AllSendFlag
	;持久化对象
	s result=obj.%Save()
	d obj.%Close()
	s obj=""
	i $$$ISERR(result) d
	.s ret=-1
    q:ret'=0 ret
	q 0
}

/// Description:插入揭药明细表相关信息
/// Creator:	hulihua
/// CreateDate:	2017-09-27
/// Table:      DHC_PhaMedBrothItm-揭药子表
/// Input:		phmb-主表ID、detailData-揭药病区科室ID^揭药日期^应揭药袋数		
/// Output:		
/// Return：	大于0-成功，小于0-失败 
/// w ##class(web.DHCINPHA.HMMedBroth.SqlDbBrothDisp).InsertPhaMedBrothItm("1||1")
ClassMethod InsertPhaMedBrothItm(phmb As %String, detailDataStr As %String) As %String
{
	n (phmb, detailDataStr)
	s rowcnt=$l(detailDataStr,"&&")
	s err=0
	f i=1:1:rowcnt  q:err<0  d
	.s detailData=$p(detailDataStr,"&&",i)
	.s WardLocId=$p(detailData,"^",1)
	.s UncovMedDate=$p(detailData,"^",2)
	.s UncovMedPocNum=$p(detailData,"^",3)
	.s BarCode=$p(detailData,"^",4)
	.s ActUnMedDate=$p(detailData,"^",5)
	.s ActUnMedTime=$p(detailData,"^",6)
	.s UncovMedFlag=$p(detailData,"^",7)
	.s ActUnMedPocNum=$p(detailData,"^",8)
 	.s Remarks=$p(detailData,"^",9)
 	.s BrothUserDR=$p(detailData,"^",10)
 	.s batNo=$p(detailData,"^",11)
	.;保存对象
    .s obj=##class(User.DHCPhaMedBrothItm).%New(phmb)
    .d obj.PHMBIPHMBParRefSetObjectId(+phmb)
    .d obj.PHMBIWardLocDRSetObjectId(WardLocId)
    .s obj.PHMBIUncovMedDate=UncovMedDate
    .s obj.PHMBIUncovMedFlag=UncovMedFlag
    .s obj.PHMBIUncovMedPocNum=UncovMedPocNum
    .s obj.PHMBIBarCode=BarCode
    .s obj.PHMBIActUncovMedDate=ActUnMedDate
    .s obj.PHMBIActUncovMedTime=ActUnMedTime
    .s obj.PHMBIActUncovMedPocNum=ActUnMedPocNum
    .s obj.PHMBIRemarks=Remarks
    .d obj.PHMBIBrothDispUserDRSetObjectId(BrothUserDR)
    .s obj.PHMBIBatNo=batNo
	.;持久化对象
	.s result=obj.%Save()
	.d obj.%Close()
	.s obj=""
	.i $$$ISERR(result) d
	..s err=-1
	q err
}

/// Description:更新揭药明细表相关信息
/// Creator:	hulihua
/// CreateDate:	2017-12-09
/// Table:      DHC_PhaMedBrothItm-揭药子表
/// Input:		phmb-主表ID、detailData-揭药病区科室ID^揭药日期^应揭药袋数		
/// Output:		
/// Return：	大于0-成功，小于0-失败 
/// w ##class(web.DHCINPHA.HMMedBroth.SqlDbBrothDisp).UpdatePhaMedBrothItm("1","405^64626^1^I1712080000501")
ClassMethod UpdatePhaMedBrothItm(phmb As %String, detailDataStr As %String) As %String
{
	n (phmb, detailDataStr)
	s rowcnt=$l(detailDataStr,"&&")
	s err=0
	f i=1:1:rowcnt  q:err<0  d
	.s detailData=$p(detailDataStr,"&&",i)
	.s WardLocId=$p(detailData,"^",1)
	.s UncovMedDate=$p(detailData,"^",2)
	.s UncovMedPocNum=$p(detailData,"^",3)
	.s BarCode=$p(detailData,"^",4)
	.s phmbich=$o(^DHCPHAMEDBi("BarCode",BarCode,phmb,""),-1)
	.s phmbiId=phmb_"||"_phmbich
	.s ActUnMedDate=$p(detailData,"^",5)
	.s ActUnMedTime=$p(detailData,"^",6)
	.s UncovMedFlag=$p(detailData,"^",7)
	.s ActUnMedPocNum=$p(detailData,"^",8)
 	.s Remarks=$p(detailData,"^",9)
 	.s BrothUserDR=$p(detailData,"^",10)
 	.s batNo=$p(detailData,"^",11)
	.;保存对象
    .s obj=##class(User.DHCPhaMedBrothItm).%OpenId(phmbiId)
    .d obj.PHMBIPHMBParRefSetObjectId(+phmb)
    .d obj.PHMBIWardLocDRSetObjectId(WardLocId)
    .s obj.PHMBIUncovMedDate=UncovMedDate
    .s obj.PHMBIUncovMedFlag=UncovMedFlag
    .s obj.PHMBIUncovMedPocNum=UncovMedPocNum
    .s obj.PHMBIBarCode=BarCode
    .s obj.PHMBIActUncovMedDate=ActUnMedDate
    .s obj.PHMBIActUncovMedTime=ActUnMedTime
    .s obj.PHMBIActUncovMedPocNum=ActUnMedPocNum
    .s obj.PHMBIRemarks=Remarks
    .d obj.PHMBIBrothDispUserDRSetObjectId(BrothUserDR)
    .s obj.PHMBIBatNo=batNo
	.;持久化对象
	.s result=obj.%Save()
	.d obj.%Close()
	.s obj=""
	.i $$$ISERR(result) d
	..s err=-1
	.
	q err
}

/// Description:揭药室扫描全送采集装箱数据
/// Creator:	hulihua
/// CreateDate:	2018-01-16
/// Table:      DHC_PhaMedBrothItm-揭药子表
/// Input:		PhmbiId-揭药子表ID、BrothBatNo-揭药批号		
/// Output:		
/// Return：	0-成功，非0-失败 
/// w ##class(web.DHCINPHA.HMMedBroth.SqlDbBrothDisp).SaveBrothCollectDb("15")
ClassMethod SaveBrothCollectDb(PhmbiId As %String, BrothBatNo As %String, PhBoxId As %String = "", BrothUserDR As %String = "") As %String
{
	n (PhmbiId,BrothBatNo,PhBoxId,BrothUserDR)
	s err=0
	;保存对象
    s obj=##class(User.DHCPhaMedBrothItm).%OpenId(PhmbiId)
    i BrothBatNo'=""  d
	.s obj.PHMBIBatNo=BrothBatNo
	.s obj.PHMBIActUncovMedDate=+$h
    .s obj.PHMBIActUncovMedTime=$p($h,",",2)
    .d obj.PHMBIBrothDispUserDRSetObjectId(BrothUserDR)
	e  d
	.d obj.PHMBIPHBoxDrSetObjectId(PhBoxId)
	;持久化对象
	s result=obj.%Save()
	d obj.%Close()
	i $$$ISERR(result) d
	.s err=-1
	s obj=""
	q:err'=0 $SYSTEM.Status.GetErrorText(result)
	
	/* add by MaYuqiang 20220113 插入装箱子表 */
	s prescNo = $p($g(^DHCPHAMEDB(+PhmbiId)), "^", 4)
	s err = ##class(PHA.DEC.MOB.Business).InsBoxItm(PhBoxId, PhmbiId, "HDD", prescNo)
	
	q err
}

/// Description:删除揭药表相关信息
/// Creator:	hulihua
/// CreateDate:	2017-09-27
/// Table:      DHC_PhaMedBroth-揭药主表
/// Input:		Phmbid-揭药主表ID		
/// Output:		
/// Return：	等于0-成功，小于0-失败 
/// w ##class(web.DHCINPHA.HMMedBroth.SqlDbBrothDisp).DeletePhaMedBroth("1||1")
ClassMethod DeletePhaMedBroth(Phmbid As %String) As %String
{
	n (Phmbid)
	s ret=0
	s result=##class(User.DHCPhaMedBroth).%DeleteId(Phmbid)
	i $$$ISERR(result) d
	.s ret=-1
	s obj=""
    q:ret'=0 ret
	q 0
}

/// Description:批量处理揭药主表中揭药完成标志错误的问题
/// Creator:	hulihua
/// CreateDate:	2018-01-08
/// Table:      DHC_PhaMedBroth-揭药主表
/// Input:			
/// Output:		
/// Return：	等于0-成功，小于0-失败 
/// w ##class(web.DHCINPHA.HMMedBroth.SqlDbBrothDisp).UpAllMedBrothComFlag()
ClassMethod UpAllMedBrothComFlag() As %String
{
	s PhmbId=0,num=0,err=0
	f  s PhmbId=$o(^DHCPHAMEDB(PhmbId))  q:(PhmbId="")||(err'=0)  d
	.q:'$d(^DHCPHAMEDBi("UncovMedFlag","N",PhmbId)) 
	.s obj=##class(User.DHCPhaMedBroth).%OpenId(PhmbId)
	.s obj.PHMBMedBroCompFlag="N"
	.s sc=obj.%Save()
	.d obj.%Close()
	.i $$$ISERR(sc) d
	..s err=-1
	.s num=num+1
	q:err'=0 $SYSTEM.Status.GetErrorText(sc)
	q num
}

}
