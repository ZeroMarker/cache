/// 名称: web.DHCCPW.MR.OutPathWayOEOrdSrv
/// 描述: 临床路径路径外医嘱统计
/// 编写者：zhufei
/// 编写日期: 2012-02-24
Class web.DHCCPW.MR.OutPathWayOEOrdSrv Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2012-02-24
/// Description:  自动生成临床路径实施记录
/// Table：       
/// Input：       argPathWayID:   路径ID
/// Return：      return
/// w ##class(web.DHCCPW.MR.OutPathWayOEOrdSrv).AutoGenImpl(29)
ClassMethod AutoGenImpl(aPathWayID As %String, aStepID As %String = "", aImplFlag As %String = "") As %String
{
	New (aPathWayID,aStepID,aImplFlag)
	Set return=0
	Quit:aPathWayID="" return
	
	Set $ZT="AutoGenImplErr"
	
	//判断是否已保存实施记录
	//保存过实施记录不再重复同步数据
	Quit:+$g(^DHCMR("IMPL",aPathWayID))=1 1
	
	Set ZIndex=$zn,JIndex=$j
	Kill ^TMP(ZIndex,JIndex,"AutoGenImpl")
	
	Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(aPathWayID)
	Quit:'$IsObject(objPathWay) return
	
	Set MRAdm=objPathWay.CPWMRADMDR
	Set EpisodeID=##class(web.DHCCPW.MR.PAADMSrv).GetEpisodeID(MRAdm)
	
	Set %ZIndex=ZIndex, %JIndex=JIndex, %NIndex="AutoGenImpl"
	Set %EpisodeID=EpisodeID
	
	Set StartDate="",StartTime=""
	Set EstTimeLS=##class(web.DHCCPW.MR.ClinPathWaysEstimate).GetObjByPathWayID(aPathWayID)
	Quit:EstTimeLS="" return
	
	Set EstTimesCnt=$listlength(EstTimeLS)
	For EstTimesInd=1:1:EstTimesCnt {
		Set objEstTime=$list(EstTimeLS,EstTimesInd)
		Set EpStepDR=$list(objEstTime,1)
		Continue:(aStepID'="")&&(aStepID'=EpStepDR)
		Set IsCurrStep=$list(objEstTime,2)
		Set IsOverStep=$list(objEstTime,9)
		Continue:(IsCurrStep'=1)&&(IsOverStep'=1)
		//获取当前要同步的步骤
		Set ^TMP(ZIndex,JIndex,"AutoGenImpl","CurrEpStep",EpStepDR)=objEstTime
	}
	
	Set EpStepID=""
	For {
		Set EpStepID=$o(^TMP(ZIndex,JIndex,"AutoGenImpl","CurrEpStep",EpStepID))
		Quit:EpStepID=""
		
		Set CurrEstTime=$g(^TMP(ZIndex,JIndex,"AutoGenImpl","CurrEpStep",EpStepID))
		Set ImplEstTime=$g(^DHCMR("IMPL",aPathWayID,"EpStep",EpStepID))
		If ($list(CurrEstTime,2)'=1)&&(ImplEstTime'="")
		{
			//非当前步骤,而且已经同步过,需要校验时间区间是否相符
			Set flg2=($list(CurrEstTime,2)=$list(ImplEstTime,2))
			Set flg3=($list(CurrEstTime,3)=$list(ImplEstTime,3))
			Set flg4=($list(CurrEstTime,4)=$list(ImplEstTime,4))
			Set flg5=($list(CurrEstTime,5)=$list(ImplEstTime,5))
			Set flg6=($list(CurrEstTime,6)=$list(ImplEstTime,6))
			Set flg7=($list(CurrEstTime,7)=$list(ImplEstTime,7))
			Set flg8=($list(CurrEstTime,8)=$list(ImplEstTime,8))
			Set flg9=($list(CurrEstTime,9)=$list(ImplEstTime,9))
			Continue:(flg2&flg3&flg4&flg5&flg6&flg7&flg8&flg9)
		}
		
		Kill ^DHCMR("IMPL",aPathWayID,"EpStep",EpStepID)
		
		Set %StartDate=$list(CurrEstTime,3)
		Set %StartTime=$list(CurrEstTime,4)
		Set %EndDate=$list(CurrEstTime,5)
		Set %EndTime=$list(CurrEstTime,6)
		
		//1 主表单项目检查
		Set CPWID=$p(EpStepID,"||",1)
		Set EpID=$p(EpStepID,"||",2)
		Set StepID=$p(EpStepID,"||",3)
		Set ItemID=0
		For {
			Set ItemID=$o(^DHCMRC("CPW",CPWID,"EP",EpID,"STEP",StepID,"ITEM",ItemID))
			Quit:ItemID=""
			Set ItemRowID=CPWID_"||"_EpID_"||"_StepID_"||"_ItemID
			Set objItem=##class(web.DHCCPW.MRC.PathWEpStepItem).GetObjById(ItemRowID)
			Continue:'$IsObject(objItem)
			//w "ItemRowID1="_ItemRowID,!
			Do AutoGenImplSub
		}
		
		//合并症表单项目检查
		Set ComStepList=$list(CurrEstTime,8)
		For indComStep=1:1:$listlength(ComStepList) {
			Set ComEpStepID=$list(ComStepList,indComStep)
			Continue:ComEpStepID=""
			Set CPWID=$p(ComEpStepID,"||",1)
			Set EpID=$p(ComEpStepID,"||",2)
			Set StepID=$p(ComEpStepID,"||",3)
			Set ItemID=0
			For {
				Set ItemID=$o(^DHCMRC("CPW",CPWID,"EP",EpID,"STEP",StepID,"ITEM",ItemID))
				Quit:ItemID=""
				Set ItemRowID=CPWID_"||"_EpID_"||"_StepID_"||"_ItemID
				Set objItem=##class(web.DHCCPW.MRC.PathWEpStepItem).GetObjById(ItemRowID)
				Continue:'$IsObject(objItem)
				//w "ItemRowID2="_ItemRowID,!
				Do AutoGenImplSub
			}
		}
		
		Set ^DHCMR("IMPL",aPathWayID,"EpStep",EpStepID)=CurrEstTime
	}
	
	//Set ^DHCMR("IMPL",aPathWayID)=1
	
	Kill ^TMP(ZIndex,JIndex,"AutoGenImpl")
	Quit 1
	
AutoGenImplSub
	//检查关联医嘱
	If objItem.CPWSIARCIM.Count()>0
	{
		For indLink=1:1:objItem.CPWSIARCIM.Count()
		{
			Set objLink=objItem.CPWSIARCIM.GetAt(indLink)
			Continue:objLink=""
			Set lnkArcimID=objLink.ITMARCIMDR
			Continue:lnkArcimID=""
			//w "lnkArcimID="_lnkArcimID,!
			If $d(^DHCMR("IMPL",aPathWayID,"EpStep",EpStepID,"ARCIM",lnkArcimID))
			{
				Set tmpItemRowID=$o(^DHCMR("IMPL",aPathWayID,"EpStep",EpStepID,"ARCIM",lnkArcimID,""))
				M ^DHCMR("IMPL",aPathWayID,"EpStep",EpStepID,"ARCIM",lnkArcimID,ItemRowID)=^DHCMR("IMPL",aPathWayID,"EpStep",EpStepID,"ARCIM",lnkArcimID,tmpItemRowID)
				Continue  //同一步骤下,如果此项目已处理过一遍,不再处理第二遍
			}
			Set Result=..MainToArcim(lnkArcimID)
			Continue:$list(Result,1)<1
			Set ResultList=$list(Result,2)
			For indResult=1:1:$listlength(ResultList)
			{
				Set ResultDtl=$list(ResultList,indResult)
				Set ResultCode=$list(ResultDtl,1)
				Continue:ResultCode=""
				Set ^DHCMR("IMPL",aPathWayID,"EpStep",EpStepID,"ARCIM",lnkArcimID,ItemRowID,ResultCode)=ResultDtl
			}
		}
	}
	
	Quit
	
AutoGenImplErr
	Kill ^TMP(ZIndex,JIndex,"AutoGenImpl")
	Quit -999
}

/// Creator：     zhufei
/// CreatDate：   2012-02-24
/// Description:  关联医嘱表达式解析主题程序
/// Table：       
/// Input：       ArcimID: 关联医嘱ID
/// Return：      返回检查结果  $lb(Count,$lb($lb(Desc,Date,Time),...))
/// w ##class(web.DHCCPW.MR.OutPathWayOEOrdSrv).MainToArcim("1||1")
ClassMethod MainToArcim(argArcimID As %String) As %String
{
	New (argArcimID,%EpisodeID,%StartDate,%StartTime,%EndDate,%EndTime)
	Set return=$lb(0,"")
	Quit:(argArcimID="")||(%EpisodeID="") return
	Quit:(%StartDate="")||(%StartTime="")||(%EndDate="")||(%EndTime="") return
	
	Set $ZT="MainToArcimErr"
	
	Set Count=0,ArcimList=""
	Set OrdID=$o(^OEORD(0,"Adm",+%EpisodeID,""))
	Set ArcimDesc=$p($g(^ARCIM(+argArcimID,+$p(argArcimID,"||",2),1)),"^",2)
	Set tmpDate=%StartDate-1
	For {
		Set tmpDate=$o(^OEORDi(0,"ARCIM",OrdID,argArcimID,tmpDate))
		Quit:tmpDate=""
		Quit:tmpDate>%EndDate
		Set SubID=""
		For {
			Set SubID=$o(^OEORDi(0,"ARCIM",OrdID,argArcimID,tmpDate,SubID))
			Quit:SubID=""
			Set StartDate=$p($g(^OEORD(OrdID,"I",SubID,1)),"^",9)
			Set StartTime=$p($g(^OEORD(OrdID,"I",SubID,1)),"^",10)
			Continue:(StartDate=%StartDate)&&(StartTime<%StartTime)
			Continue:(StartDate=%EndDate)&&(StartTime>%EndTime)
			Set OeoriStatus=$p($g(^OEORD(OrdID,"I",SubID,1)),"^",13)
			Set OeoriStatus=$p($g(^OEC("OSTAT",+OeoriStatus)),"^",2)
			Continue:OeoriStatus["停"  //医嘱状态  停止
			Set Count=Count+1
			Set OEItemID=OrdID_"||"_SubID
			Set ArcimList=ArcimList_$lb($lb("OEItemID:"_OEItemID,ArcimDesc,StartDate,StartTime))
		}
	}
	
	Set return=$lb(Count,ArcimList)
	Quit return
	
MainToArcimErr
	Set return=$lb(-999,$ZERROR)
	Quit return
}

}
