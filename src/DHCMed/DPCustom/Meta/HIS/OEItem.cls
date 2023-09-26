/// 名称:DHCMed.DPCustom.Meta.HIS.OEItem
/// 描述: 医嘱项目 数据抽取
/// 编写者：李阳
/// 编写日期: 2013-12-07
Class DHCMed.DPCustom.Meta.HIS.OEItem Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

/// 抽取诊断数据
/// FromDate:医嘱的开始日期
/// ToDate：医嘱的结束日期
/// 
ClassMethod ExtractData(FromDate As %Date, ToDate As %Date) As %String
{
	n (FromDate,ToDate)
	For tmpDate=FromDate:1:ToDate {
		Set OrderID=""
		For {
			Set OrderID=$o(^OEORDi(0,"StDt",tmpDate,OrderID))
			Quit:OrderID=""
			Set ChildSub=""
			For {
				Set ChildSub=$o(^OEORDi(0,"StDt",tmpDate,OrderID,ChildSub))
				Quit:ChildSub=""
				Set tmp=$$ExtractOdrItm(OrderID, ChildSub)
			}
		}
	}
	Quit 1
	
ExtractOdrItm(OrderID, ChildSub)
	n (OrderID,ChildSub)
	
	Set obj=##class(DHCMed.Base.OrdItem).GetObjById(OrderID_"||"_ChildSub)
	Quit:'$IsObject(obj) -1
	Do obj.%Close()
	
	//保存ActMain
	Set strArg=""
	Set $p(strArg,"^",1)=""
	Set $p(strArg,"^",2)=EpisodeID
	Set $p(strArg,"^",3)="OE"
	Set $p(strArg,"^",4)="OE-HIS-ANTI"
	Set $p(strArg,"^",5)=obj.OESttDate
	Set $p(strArg,"^",6)=obj.OEArcimCode_"--"_obj.OEArcimDesc
	Set $p(strArg,"^",7)=OrderID_"||"_ChildSub
	Set $p(strArg,"^",8)=obj.OEORIXDate //XDate
	Set $p(strArg,"^",9)=1 //IsActive
	Set $p(strArg,"^",10)=+$h
	Set $p(strArg,"^",11)=$p($h,",",2)
	Set $p(strArg,"^",12)=objDia.AliasDiagText
	Set ActMainID=##class(DHCMed.DP.Meta.ActMain).Update(strArg,"^")
	
	Set strArg=""
	Set $p(strArg,"^",1)=""	
	Set $p(strArg,"^",1)=ActMainID
	Set $p(strArg,"^",1)="OE-HIS-ANTI"
	Set $p(strArg,"^",1)=OrderID_"||"_ChildSub
	Set $p(strArg,"^",1)=obj.OEArcimCode
	Set $p(strArg,"^",1)=obj.OEArcimDesc
	Set $p(strArg,"^",1)=obj.OECPRDesc
	Set $p(strArg,"^",1)=obj.OEORISttDat
	Set $p(strArg,"^",1)=obj.OEORISttTim
	Set $p(strArg,"^",1)=obj.OEORIXDate
	Set $p(strArg,"^",1)=obj.OEORIXTime
	Set OrderDep=$p($g(^OEORD(OrderID,"I",ChildSub)),"^",3)
	Set objDep=##class(DHCMed.Base.Ctloc).GetObjById(OrderDep)
	Set $p(strArg,"^",1)=objDep.Descs
	Set $p(strArg,"^",1)=obj.DocCode_" "_obj.DocDesc
	Set $p(strArg,"^",1)=obj.Descs
	Set $p(strArg,"^",1)=obj.OEORIDoseQty
	Set $p(strArg,"^",1)=obj.CTUOMDesc
	Set $p(strArg,"^",1)=obj.PHCFRDesc1
	Set $p(strArg,"^",1)=obj.PHCINDesc1
	Set $p(strArg,"^",1)="" //管制分类(抗生素)
	Set $p(strArg,"^",1)="" //用药目的(抗生素)
	Set $p(strArg,"^",1)="" //是否送检(抗生素)
	Set $p(strArg,"^",1)="" //Resume
	Set ret=##Class(DHCMed.DP.Meta.OEItem).Update(strArg,"^")
	Quit ret
}

}
