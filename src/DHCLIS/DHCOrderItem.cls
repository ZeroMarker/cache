Class DHCLIS.DHCOrderItem Extends %RegisteredObject
{

/// 获取医嘱外部代码
/// OrderId医嘱ID Labno检验号  WorkGroupMachineDR工作小组 RecHospitalDR接收医院 
ClassMethod GetOrders(OrderId, Labno, WorkGroupMachineDR, RecHospitalDR) As %String
{
	s OrderId=$g(OrderId),Labno=$g(Labno),WorkGroupMachineDR=$g(WorkGroupMachineDR)
	k ^TMP($zn,$j)
	s num=0,recTSList="",tmpTS=""
	s childsub="" f  s childsub=$o(^OEORD(0,"EpisNo",Labno,OrderId,childsub)) q:childsub=""  d
	.s OrdRowID=OrderId_"||"_childsub
	.s arcim=$p(^OEORD(OrderId,"I",childsub,1),"^",2)
	.s ts="",RecTSDR=""
	.s ord=0 f  s ord=$o(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),"EXT",ord)) q:(ord="")!$l(RecTSDR)  d
	..s ExtCode=$p(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),"EXT",ord),"^",4)
	..s IsDefault=$p(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),"EXT",ord),"^",9)
	..s TestSetDR=$o(^dbo.BTTestSetI("IndexCode",RecHospitalDR,##Class(LIS.Util.Common).IndexData(ExtCode),""))
	..i '$l(TestSetDR) q
	..s tsWGMachineDR=$lg(^dbo.BTTestSetD(TestSetDR),13)
	..s ts=TestSetDR
	..i $l(WorkGroupMachineDR),tsWGMachineDR=WorkGroupMachineDR s RecTSDR=TestSetDR Q
	..i $l(WorkGroupMachineDR) Q
	..i IsDefault="Y" s RecTSDR=TestSetDR Q
	..s RecTSDR=TestSetDR Q
	.i $l(RecTSDR) d
	..s num=num+1
	..s OrdItmInfo=##Class(DHCLIS.DHCOrderItem).GetOrdItmInfo(OrderId,childsub,RecHospitalDR)
	..//医嘱ID SubID 检验医嘱套 标本 医嘱状态 计费状态 采集时间
	..s OrdItmInfo=OrderId_$c(1)_childsub_$c(1)_RecTSDR_$c(1)_OrdItmInfo
	..s recTSList=recTSList_$C(2)_OrdItmInfo
	i recTSList="" s recTSList=ts  ///用于判断接收科室提示	
	q num_"^"_recTSList
}

ClassMethod GetOrdItmInfo(OrderId, childsub, RecHospitalDR) As %String
{
	s OrderId=$g(OrderId),childsub=$g(childsub)
	//标本
	s Specimen="",Container=""
	s SpecChlSub="0" f  s SpecChlSub=$o(^OEORD(OrderId,"I",childsub,"SPEC",SpecChlSub)) q:SpecChlSub=""  d
	.s SpecCode=$p(^OEORD(OrderId,"I",childsub,"SPEC",SpecChlSub),"^",1),SpecimenDR=""
	.s ConCode=$p(^OEORD(OrderId,"I",childsub,"SPEC",SpecChlSub),"^",11),ContainerDR=""
	.i $l(SpecCode) s SpecimenDR=$o(^dbo.BTSpecimenI("IndexCode",RecHospitalDR,##Class(LIS.Util.Common).IndexData(SpecCode),""))
	.i $l(ConCode) s ContainerDR=$o(^dbo.BTContainerI("IndexCode",RecHospitalDR,##Class(LIS.Util.Common).IndexData(ConCode),""))
	.s Specimen=Specimen_SpecimenDR_","
	.s Container=Container_ContainerDR_","
	s:Specimen'="" Specimen=$e(Specimen,1,$l(Specimen)-1)
	s:Container'="" Container=$e(Container,1,$l(Container)-1)
 	//医嘱状态
	s OrdItmStat=$p($g(^OEC("OSTAT",+$p($g(^OEORD(OrderId,"I",childsub,1)),"^",13))),"^",1)
 	//病人类型
	s temPatType=""
	s temAdm=$p(^OEORD(OrderId),"^",1)
	i $l(temAdm),$d(^PAADM(temAdm)) s temPatType=$p(^PAADM(temAdm),"^",2) 
	//缴费状态
	s BiledFlag=""
	i temPatType="O" s BiledFlag=$p(^OEORD(OrderId,"I",childsub,3),"^",5)
	i temPatType="H" s BiledFlag=$p(^OEORD(OrderId,"I",childsub,3),"^",5)
	i temPatType="E" s BiledFlag=$p(^OEORD(OrderId,"I",childsub,3),"^",5)
	i temPatType="I" s BiledFlag="P" 
 	q Specimen_$c(1)_OrdItmStat_$c(1)_BiledFlag_$c(1)_Container
}

/// 获取标本采集时间
ClassMethod GetColDateTime(OrderId, childsub) As %String
{
	s execrowid="",OrdRowID=OrderId_"||"_childsub
	i $d(^DHCOrdExec(0,"OEOREDR",OrdRowID_"||1")) d
	.s execrowid=$o(^DHCOrdExec(0,"OEOREDR",OrdRowID_"||1",""))
	s (ColUser,ColDate,ColTime)=""
	i $l(execrowid),$d(^DHCOrdExec(execrowid)) d
 	.s ColUser=$p(^DHCOrdExec(execrowid),"^",12)
	.s ColDate=$p(^DHCOrdExec(execrowid),"^",13)
	.s ColTime=$p(^DHCOrdExec(execrowid),"^",14)
	q ColUser_"^"_ColDate_"^"_ColTime
}

ClassMethod CancelExec(rowid, usrid) As %String
{
	q ##Class(appcom.OEOrdItem).Verify(rowid,usrid)
}

}
