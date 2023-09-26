/// CTOR: QP
/// DATE: 2020-08-17
/// DESC: 医嘱套录入
Class DHCDoc.Chemo.Model.ArcosItem Extends %RegisteredObject
{

/// 序号
Property id As %String;

/// 医嘱类型
Property OrderPrior As %String;

Property OrderPriorRowid As %String;

/// 关联
Property OrderMasterSeqNo As %String;

/// 医嘱
Property OrderName As %String;

Property OrderARCIMRowid As %String;

/// 厂家
Property ManuFactor As %String;

/// 单次剂量
Property OrderDoseQty As %String;

/// 剂量单位
Property OrderDoseUOM As %String;

Property OrderDoseUOMRowid As %String;

/// 频次
Property OrderFreq As %String;

Property OrderFreqRowid As %String;

/// 用法
Property OrderInstr As %String;

Property OrderInstrRowid As %String;

/// 备注
Property OrderDepProcNote As %String;

/// 疗程
Property OrderDur As %String;

Property OrderDurRowid As %String;

/// 数量
Property OrderPackQty As %String;

/// 数量单位
Property OrderPackUOM As %String;

Property OrderPackUOMRowid As %String;

/// 接收科室
Property OrderRecDep As %String;

Property OrderRecDepRowid As %String;

/// 皮试
Property OrderSkinTest As %String;

/// 皮试备注
Property OrderAction As %String;

Property OrderActionRowid As %String;

/// 输液流速
Property OrderSpeedFlowRate As %String;

/// 流速单位
Property OrderFlowRateUnit As %String;

Property OrderFlowRateUnitRowId As %String;

/// 计算公式
Property Formula As %String;

/// 外院剂量
Property HospDose As %String;

/// 外院记录ID
Property HDID As %String;

/// 标准值
Property BSAUnitSTD As %String;

ClassMethod GetInfo(Arcim, LinkNo, Para, PatientID, EpisodeID) As DHCDoc.Chemo.Model.ArcosItem
{
	S MObj=##class(DHCDoc.Chemo.Model.ArcosItem).%New()
	S MObj.OrderARCIMRowid=Arcim
	
	S ARC=+Arcim,VER=$P(Arcim,"||",2)
	S MObj.OrderName=$p(^ARCIM(ARC,VER,1),"^",2)
	S MObj.OrderMasterSeqNo=LinkNo
	S OrderDoseStr=$P(Para,"^",1)
	S MObj.OrderDoseQty=$P(OrderDoseStr,$C(1),1)
	S MObj.OrderDoseUOM=$P(OrderDoseStr,$C(1),2)
	S MObj.OrderDoseUOMRowid=$P(OrderDoseStr,$C(1),3)
	S OrderFreqStr=$P(Para,"^",2)
	S MObj.OrderFreq=$P(OrderFreqStr,$C(1),1)
	S MObj.OrderFreqRowid=$P(OrderFreqStr,$C(1),2)
	S OrderInstrucStr=$P(Para,"^",3)
	S MObj.OrderInstr=$P(OrderInstrucStr,$C(1),1)
	S MObj.OrderInstrRowid=$P(OrderInstrucStr,$C(1),2)
	S OrderDurStr=$P(Para,"^",4)
	S MObj.OrderDur=$P(OrderDurStr,$C(1),1)
	S MObj.OrderDurRowid=$P(OrderDurStr,$C(1),2)
	S OrderPackStr=$P(Para,"^",5)
	S MObj.OrderPackQty=$P(OrderPackStr,$C(1),1)
	S MObj.OrderPackUOM=$P(OrderPackStr,$C(1),2)
	S MObj.OrderPackUOMRowid=$P(OrderPackStr,$C(1),3)
	S OrderPriorStr=$P(Para,"^",6)
	S MObj.OrderPrior=$P(OrderPriorStr,$C(1),1)
	S MObj.OrderPriorRowid=$P(OrderPriorStr,$C(1),2)
	s MObj.OrderDepProcNote=$P(Para,"^",10)
	s HDID=##class(DHCDoc.Chemo.BS.HospDose).FindRecord(PatientID,Arcim)
	S MObj.HDID=HDID
 	i HDID'="" {
	 	s HospDose=$p(^BS.DOC.Chemo.HospDoseD(HDID),"^",4)
	 	S MObj.HospDose=HospDose
 	}
 	S RecLoc=##class(DHCDoc.Chemo.COM.CallMethod).GetDefaultRecLoc(EpisodeID,Arcim)
 	S MObj.OrderRecDepRowid=RecLoc
 	i RecLoc'="" S MObj.OrderRecDep=$P(^CTLOC(RecLoc),"^",2)
	
	Q MObj
}

}
