/// 名称: DHCMed.CCService.Lib.ICUOpr
/// 描述: 与ICU导管（导尿管、呼吸机、动静脉插管等）相关的函数库
/// 编写者：zhufei
/// 编写日期: 2013-05-07
Class DHCMed.CCService.Lib.ICUOpr Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(DHCMed.CCService.Lib.ICUOpr).Test()
ClassMethod Test()
{
	New
	
	Set %EpisodeID=197
	Set %ExtraData=$lb("")
	Set %ErrorData=$lb("")
	Set return=..GetICUOEByID01("医嘱||2097||导尿管")
	Write "%ExtraData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ExtraData,"///"),!
	Write "%ErrorData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ErrorData,"///"),!
	Write "return="_return,!
	
	Quit "Over"
}

/// Creator：     zhufei
/// CreatDate：   2013-05-07
/// Description:  旧版本医嘱模式、临时医嘱（插管医嘱、拔管医嘱）处理方式
///               通过医嘱ID取ICU导管（导尿管、呼吸机、动静脉插管等）相关医嘱
/// Table：       OE_OrdItem
/// Input：       
/// Return：      返回医嘱数量  ret=-1:Error
/// w ##class(DHCMed.CCService.Lib.ICUOpr).GetICUOEByID01("")
ClassMethod GetICUOEByID01(argInput As %String) As %String
{
	New (argInput,%EpisodeID,%ExtraData,%ErrorData)
	Set return=0,Count=0
	Quit:argInput="" return
	
	Set $ZT="GetICUOEByID01Err"
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	
	Set ArcimID=$p(argInput,"||",2)
	Quit:ArcimID="" return
	Set ArcimID=ArcimID_"||1"
	Set ArcimName=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",2)
	Quit:ArcimName="" return
	
	Set OrderID=$o(^OEORD(0,"Adm",%EpisodeID,0))
	Quit:OrderID="" return
	
	Set SttDate=0
	For {
		Set SttDate=$o(^OEORDi(0,"ARCIM",OrderID,ArcimID,SttDate))
		Quit:SttDate=""
		
		Set SubID=0
		For {
			Set SubID=$o(^OEORDi(0,"ARCIM",OrderID,ArcimID,SttDate,SubID))
			Quit:SubID=""
			
			//过滤无效医嘱
			Set isValid=##class(DHCMed.CCService.Lib.OEOrdItem).IsValidOEItem(OrderID_"||"_SubID)
			Continue:(isValid=0)
			
			Set Count=Count+1
			Set StartDate=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",9)  //医嘱开始日期
			Set StartTime=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",10) //医嘱开始时间
			Set:StartDate'="" StartDate=$zd(StartDate,3)
			Set:StartTime'="" StartTime=$zt(StartTime,2)
			Set Doctor=$p($g(^OEORD(+OrderID,"I",SubID,1)),"^",11)   //开医嘱医生
			Set Doctor=$p($g(^CTPCP(+Doctor,1)),"^",2)
			
			//ExtraData=$lb(Summary,ActDate,ActTime,DataValue,ObjectID,UserID,Parameters)
			Set Record=""
			Set $p(Record,$c(3),1)=ArcimName  //_" "_StartDate_" "_StartTime_" "_Doctor
			Set $p(Record,$c(3),2)=StartDate
			Set $p(Record,$c(3),3)=StartTime
			Set $p(Record,$c(3),4)=ArcimName_" "_StartDate_" "_StartTime_" "_Doctor
			Set $p(Record,$c(3),5)=OrderID_"||"_SubID
			Set $p(Record,$c(3),6)=+$p($g(^OEORD(+OrderID,"I",SubID,8)),"^",12)
			Set $p(Record,$c(3),7)="argInput="_argInput
			Set %ExtraData=%ExtraData_$lb(Record)
		}
	}
	
	Set return=Count
	Quit return
	
GetICUOEByID01Err
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
}

}
