/// 名称: web.DHCCPW.MR.ImplementAutoGen
/// 描述: 临床路径实施记录生成
/// 编写者：zhufei
/// 编写日期: 2012-02-16
Class web.DHCCPW.MR.ImplementAutoGen Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2012-02-16
/// Description:  自动生成临床路径实施记录
/// Table：       
/// Input：       argPathWayID:   路径ID
/// Return：      return
/// w ##class(web.DHCCPW.MR.ImplementAutoGen).AutoGenImpl(3)
ClassMethod AutoGenImpl(aPathWayID As %String, aStepID As %String = "", aImplFlag As %String = "") As %String
{
	New (aPathWayID,aStepID,aImplFlag)
	Set return=0
	Quit:aPathWayID="" return
	
	Set $ZT="AutoGenImplErr"
	
	//判断是否已保存实施记录
	//保存过实施记录不再重复同步数据
	//Quit:+$g(^DHCMR("IMPL",aPathWayID))=1 1
	
	Set ZIndex=$zn,JIndex=$j
	Kill ^TMP(ZIndex,JIndex,"AutoGenImpl")
	
	Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(aPathWayID)
	Quit:'$IsObject(objPathWay) return
	
	Set MRAdm=objPathWay.CPWMRADMDR
	Set EpisodeID=##class(web.DHCCPW.MR.PAADMSrv).GetEpisodeID(MRAdm)
	
	//同步执行记录数据
	Set StDtTmIndex=##class(web.DHCCPW.MRC.BaseConfig).GetValueByCode("OEOrdItemStDtTmIndex")
	If StDtTmIndex="YYGL" {             //航天中心医院
		Set flg=##Class(web.DHCCPW.MR.InterfaceToPrj).getOEOrdExec(EpisodeID)
	} ElseIf StDtTmIndex="StDtTmNew" {  //新版本医嘱
		Set flg=..getOEOrdExecNew(EpisodeID)
	} Else {                            //旧版本医嘱
		Set flg=..getOEOrdExec(EpisodeID)
	}
	
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
	
	//保存同步的实施记录
	If aImplFlag="Y" {
		Set ^DHCMR("IMPL",aPathWayID,"EpStep",EpStepID,"ARCIM",RstCode)=ResultDtl
		Set StepID=""
		For {
			Set StepID=$o(^DHCMR("IMPL",aPathWayID,"EpStep",StepID))
			Quit:StepID=""
			Set TypeCode=""
			For {
				Set TypeCode=$o(^DHCMR("IMPL",aPathWayID,"EpStep",StepID,TypeCode))
				Quit:TypeCode=""
				Set ItemID=""
				For {
					Set ItemID=$o(^DHCMR("IMPL",aPathWayID,"EpStep",StepID,TypeCode,ItemID))
					Quit:ItemID=""
					
					Set StepItemID=""
					For {
						Set StepItemID=$o(^DHCMR("IMPL",aPathWayID,"EpStep",StepID,TypeCode,ItemID,StepItemID))
						Quit:StepItemID=""
						
						Set inputImpl=""
						Set inputImpl=inputImpl_"^"_aPathWayID  //CPWEParRef
						Set inputImpl=inputImpl_"^"_TypeCode_"!"_ItemID_"!"_$list(ResultDtl,1)  //CPWEOEORIDR
						Set inputImpl=inputImpl_"^"_StepItemID_"-"_EpStepID   //CPWEStepItemDR
						Set inputImpl=inputImpl_"^"_$list(ResultDtl,3)  //CPWEImplementDate
						Set inputImpl=inputImpl_"^"_$list(ResultDtl,4)  //CPWEImplementTime
						Set inputImpl=inputImpl_"^"_""   //CPWEDoctorDR
						Set inputImpl=inputImpl_"^"_""   //CPWEDate
						Set inputImpl=inputImpl_"^"_""   //CPWETime
						Set inputImpl=inputImpl_"^"_""   //CPWEUserDR
						Set inputImpl=inputImpl_"^"_"Y"  //CPWEActive
						Set inputImpl=inputImpl_"^"_""   //CPWEUpdoDate
						Set inputImpl=inputImpl_"^"_""   //CPWEUpdoTime
						Set inputImpl=inputImpl_"^"_""   //CPWEUpdoUserDR
						Set inputImpl=inputImpl_"^"_$list(ResultDtl,2)  //CPWEProcNote
						
						Set flg=##class(web.DHCCPW.MR.Implement).InsertImpl(inputImpl)
					}
					
				}
			}
		}
		Set ^DHCMR("IMPL",aPathWayID)=1
	}
	
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
			Set Result=##class(web.DHCCPW.Lib.Analytic).MainToArcim(lnkArcimID)
			Continue:(Result="")||(Result=0)	//update by liuyh 2013-06-18 Result=0 时报错
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
	
	//检查关联项目
	If objItem.CPWSIBLItmList.Count()>0
	{
		For indLink=1:1:objItem.CPWSIBLItmList.Count()
		{
			Set objLink=objItem.CPWSIBLItmList.GetAt(indLink)
			Continue:objLink=""
			Continue:'$IsObject(objLink.ITMBLItmDR)
			Set lnkItemID=objLink.ITMBLItmDR.%Id()
			//w "lnkItemID="_lnkItemID,!
			If $d(^DHCMR("IMPL",aPathWayID,"EpStep",EpStepID,"LNKITM",lnkItemID))
			{
				Set tmpItemRowID=$o(^DHCMR("IMPL",aPathWayID,"EpStep",EpStepID,"LNKITM",lnkItemID,""))
				Set ^DHCMR("IMPL",aPathWayID,"EpStep",EpStepID,"LNKITM",lnkItemID,ItemRowID)=^DHCMR("IMPL",aPathWayID,"EpStep",EpStepID,"LNKITM",lnkItemID,tmpItemRowID)
				Continue  //同一步骤下,如果此项目已处理过一遍,不再处理第二遍
			}
			Set Result=##class(web.DHCCPW.Lib.Analytic).MainToLnkItm(lnkItemID)
			Continue:(Result="")||(Result=0)	//update by liuyh 2013-06-18 Result=0 时报错
			Continue:$list(Result,1)<1
			Set ResultList=$list(Result,2)
			For indResult=1:1:$listlength(ResultList)
			{
				Set ResultDtl=$list(ResultList,indResult)
				Set ResultCode=$list(ResultDtl,1)
				Continue:ResultCode=""
				Set ^DHCMR("IMPL",aPathWayID,"EpStep",EpStepID,"LNKITM",lnkItemID,ItemRowID,ResultCode)=ResultDtl
			}
		}
	}
	Quit
	
AutoGenImplErr
	Kill ^TMP(ZIndex,JIndex,"AutoGenImpl")
	Quit -999
}

/// Creator：     zhufei
/// CreatDate：   2011-12-13
/// Description:  获取医嘱执行记录
///               ^DHCMR("OEOrdExec",就诊号)=医嘱序号
///               ^DHCMR("OEOrdExec",就诊号,医嘱项,医嘱ID,"OEOrdItem")=""
///               ^DHCMR("OEOrdExec",就诊号,医嘱项,医嘱ID,"XStatus")=医嘱状态（0正常，1停止）
///               ^DHCMR("OEOrdExec",就诊号,医嘱项,医嘱ID,"ExecType")=医嘱类型（0非持续医嘱，1持续医嘱）
///               ^DHCMR("OEOrdExec",就诊号,医嘱项,医嘱ID,"ExStDate")=执行记录ChildID
///               ^DHCMR("OEOrdExec",就诊号,医嘱项,医嘱ID,"ExStDate",医嘱日期,医嘱时间)=医嘱信息
/// Table：       
/// Input：       argEpisodeID:    就诊号
/// Return：      return=取医嘱是否成功
/// w ##Class(web.DHCCPW.MR.ImplementAutoGen).getOEOrdExec(68173)
ClassMethod getOEOrdExec(argEpisodeID As %String) As %String
{
	New (argEpisodeID)
	Set return=0
	Quit:argEpisodeID="" return
	Set $ZT="getOEOrdExecErr"
	
	Set xOrdID=$o(^OEORD(0,"Adm",argEpisodeID,0))
	Quit:xOrdID="" return
	
	//处理未完成的医嘱
	Set xArcimID=""
	For {
		Set xArcimID=$o(^DHCMR("OEOrdExec",argEpisodeID,xArcimID))
		Quit:xArcimID=""
		Set xOEItemID=""
		For {
			Set xOEItemID=$o(^DHCMR("OEOrdExec",argEpisodeID,xArcimID,xOEItemID))
			Quit:xOEItemID=""
			Continue:$g(^DHCMR("OEOrdExec",argEpisodeID,xArcimID,xOEItemID,"XStatus"))=1
			
			//处理医嘱执行记录
			Do getOEOrdExecDo
		}
	}
	
	//新增加的医嘱
	Set currOEItemID=$g(^DHCMR("OEOrdExec",argEpisodeID))
	Set xSubID=$s(currOEItemID="":0,1:+$p(currOEItemID,"||",2))
	For {
		Set xSubID=$o(^OEORD(xOrdID,"I",xSubID))
		Quit:xSubID=""
		Set xOEItemID=xOrdID_"||"_xSubID
		Set xArcimID=$p($g(^OEORD(xOrdID,"I",xSubID,1)),"^",2)
		Continue:xArcimID=""
		Continue:$g(^DHCMR("OEOrdExec",argEpisodeID,xArcimID,xOEItemID,"XStatus"))=1
		
		//处理医嘱执行记录
		Do getOEOrdExecDo
		
		//记录当前已处理医嘱ID(Max)
		Set ^DHCMR("OEOrdExec",argEpisodeID)=xOEItemID
	}
	
	Set return=1
	Quit return
	
getOEOrdExecDo
	//判断是否持续医嘱
	Set ^DHCMR("OEOrdExec",argEpisodeID,xArcimID,xOEItemID,"ExecType")=0
	Set ArcimUom=$p($g(^ARCIM(+xArcimID,+$p(xArcimID,"||",2),8)),"^",14)
	Set:ArcimUom'="" ArcimUom=$p($g(^CT("UOM",ArcimUom)),"^",1)
	If ArcimUom="HOUR" {
		Set ^DHCMR("OEOrdExec",argEpisodeID,xArcimID,xOEItemID,"ExecType")=1
	}
	Set OEPHFreq=$p($g(^OEORD(+xOEItemID,"I",+$p(xOEItemID,"||",2),2)),"^",4)
	Set:OEPHFreq'="" OEPHFreq=$p($g(^PHCFR(OEPHFreq)),"^",1)
	//If (OEPHFreq="持续") {
	//	Set ^DHCMR("OEOrdExec",argEpisodeID,xArcimID,xOEItemID,"ExecType")=1
	//}
	
	Set OEXDate=$p($g(^OEORD(+xOEItemID,"I",$p(xOEItemID,"||",2),3)),"^",34)
	Set OEXTime=$p($g(^OEORD(+xOEItemID,"I",$p(xOEItemID,"||",2),2)),"^",15)
	If OEXDate'="" {
		Set OEXDate=$zd(+OEXDate,3)
		Set OEXTime=$zt(+OEXTime,1)
	}
	Set OESttDate=$p($g(^OEORD(+xOEItemID,"I",$p(xOEItemID,"||",2),1)),"^",9)
	Set OESttTime=$p($g(^OEORD(+xOEItemID,"I",$p(xOEItemID,"||",2),1)),"^",10)
	If OESttDate'="" {
		Set OESttDate=$zd(+OESttDate,3)
		Set OESttTime=$zt(+OESttTime,1)
	}
	Set ArcimDesc=$p($g(^ARCIM(+xArcimID,+$p(xArcimID,"||",2),1)),"^",2)
	
	Set OEPriorityID=$p($g(^OEORD(+xOEItemID,"I",+$p(xOEItemID,"||",2),1)),"^",8)
	Set OEPriorityCode=$p($g(^OECPR(+OEPriorityID)),"^",1)   // PRN医嘱
	Set OEPriorityDesc=$p($g(^OECPR(+OEPriorityID)),"^",2)   // 医嘱类型
	
	//同步执行记录
	If $o(^OEORD(+xOEItemID,"I",$p(xOEItemID,"||",2),"X",0))'=""
	{
		Set xChildID=+$g(^DHCMR("OEOrdExec",argEpisodeID,xArcimID,xOEItemID,"ExStDate"))
		For {
			Set xChildID=$o(^OEORD(+xOEItemID,"I",$p(xOEItemID,"||",2),"X",xChildID))
			Quit:xChildID=""
			Set xData=$g(^OEORD(+xOEItemID,"I",$p(xOEItemID,"||",2),"X",xChildID))
			Set ExStDate=$p(xData,"^",1)
			Set ExStTime=+$p(xData,"^",2)
			Continue:ExStDate=""
			Set OEExecID=xOEItemID_"||"_xChildID
			Set ^DHCMR("OEOrdExec",argEpisodeID,xArcimID,xOEItemID,"ExStDate",ExStDate,ExStTime,OEExecID)=$lb($zd(ExStDate,3),$zt(ExStTime,1),ArcimDesc,OESttDate_" "_OESttTime,OEXDate_" "_OEXTime,OEPriorityDesc)
			Set ^DHCMR("OEOrdExec",argEpisodeID,xArcimID,xOEItemID,"ExStDate")=xChildID
		}
	} Else {
		//如果无执行记录，取下医嘱时间为执行时间
		Set xChildID=0    ;wangcs 2012-10-17
		Set ExStDate=$p($g(^OEORD(+xOEItemID,"I",$p(xOEItemID,"||",2),1)),"^",9)
		Set ExStTime=+$p($g(^OEORD(+xOEItemID,"I",$p(xOEItemID,"||",2),1)),"^",10)
		Set OEExecID=xOEItemID_"||0"
		If (ExStDate'="") {
			Set ^DHCMR("OEOrdExec",argEpisodeID,xArcimID,xOEItemID,"ExStDate",ExStDate,ExStTime,OEExecID)=$lb($zd(ExStDate,3),$zt(ExStTime,1),ArcimDesc,OESttDate_" "_OESttTime,OEXDate_" "_OEXTime,OEPriorityDesc)
			Set ^DHCMR("OEOrdExec",argEpisodeID,xArcimID,xOEItemID,"ExStDate")=0
		}
	}
	
	//判断是否长期医嘱(医嘱状态只考虑长期、临时情况)
	Set OEPriorityID=$p($g(^OEORD(+xOEItemID,"I",+$p(xOEItemID,"||",2),1)),"^",8)
	Set OEPriority=$p($g(^OECPR(+OEPriorityID)),"^",1)   // PRN医嘱
	
	Set ^DHCMR("OEOrdExec",argEpisodeID,xArcimID,xOEItemID,"XStatus")=1
	
	//根据频次判断是否PRN医嘱,PRN医嘱不设置完成状态
	If (OEPHFreq="Prn")||(OEPHFreq="PRN") {
		Set ^DHCMR("OEOrdExec",argEpisodeID,xArcimID,xOEItemID,"XStatus")=0
	}
	
	//根据医嘱类型判断是否PRN医嘱,PRN医嘱不设置完成状态
	If OEPriorityCode="PRN" {
		Set ^DHCMR("OEOrdExec",argEpisodeID,xArcimID,xOEItemID,"XStatus")=0
	}
	
	Quit
	
getOEOrdExecErr
	Set $ZT=""
	Quit -999
}

/// Creator：     zhufei
/// CreatDate：   2011-12-13
/// Description:  获取医嘱执行记录
///               ^DHCMR("OEOrdExec",就诊号)=医嘱序号
///               ^DHCMR("OEOrdExec",就诊号,医嘱项,医嘱ID,"OEOrdItem")=""
///               ^DHCMR("OEOrdExec",就诊号,医嘱项,医嘱ID,"XStatus")=医嘱状态（0正常，1停止）
///               ^DHCMR("OEOrdExec",就诊号,医嘱项,医嘱ID,"ExecType")=医嘱类型（0非持续医嘱，1持续医嘱）
///               ^DHCMR("OEOrdExec",就诊号,医嘱项,医嘱ID,"ExStDate")=执行记录ChildID
///               ^DHCMR("OEOrdExec",就诊号,医嘱项,医嘱ID,"ExStDate",医嘱日期,医嘱时间)=医嘱信息
/// Table：       
/// Input：       argEpisodeID:    就诊号
/// Return：      return=取医嘱是否成功
/// w ##Class(web.DHCCPW.MR.ImplementAutoGen).getOEOrdExecNew(148)
ClassMethod getOEOrdExecNew(argEpisodeID As %String) As %String
{
	New (argEpisodeID)
	Set return=0
	Quit:argEpisodeID="" return
	Set $ZT="getOEOrdExecNewErr"
	
	Set xOrdID=$o(^OEORD(0,"Adm",argEpisodeID,0))
	Quit:xOrdID="" return
	
	//处理未完成的医嘱
	Set xArcimID=""
	For {
		Set xArcimID=$o(^DHCMR("OEOrdExec",argEpisodeID,xArcimID))
		Quit:xArcimID=""
		Set xOEItemID=""
		For {
			Set xOEItemID=$o(^DHCMR("OEOrdExec",argEpisodeID,xArcimID,xOEItemID))
			Quit:xOEItemID=""
			Continue:$g(^DHCMR("OEOrdExec",argEpisodeID,xArcimID,xOEItemID,"XStatus"))=1
			
			//处理医嘱执行记录
			Do getOEOrdExecNewDo
		}
	}
	
	//新增加的医嘱
	Set currOEItemID=$g(^DHCMR("OEOrdExec",argEpisodeID))
	Set xSubID=$s(currOEItemID="":0,1:+$p(currOEItemID,"||",2))
	For {
		Set xSubID=$o(^OEORD(xOrdID,"I",xSubID))
		Quit:xSubID=""
		Set xOEItemID=xOrdID_"||"_xSubID
		Set xArcimID=$p($g(^OEORD(xOrdID,"I",xSubID,1)),"^",2)
		Continue:xArcimID=""
		Continue:$g(^DHCMR("OEOrdExec",argEpisodeID,xArcimID,xOEItemID,"XStatus"))=1
		
		//处理医嘱执行记录
		Do getOEOrdExecNewDo
		
		//记录当前已处理医嘱ID(Max)
		Set ^DHCMR("OEOrdExec",argEpisodeID)=xOEItemID
	}
	
	Set return=1
	Quit return
	
getOEOrdExecNewDo
	//判断是否持续医嘱
	Set ^DHCMR("OEOrdExec",argEpisodeID,xArcimID,xOEItemID,"ExecType")=0
	Set ArcimUom=$p($g(^ARCIM(+xArcimID,+$p(xArcimID,"||",2),8)),"^",14)
	Set:ArcimUom'="" ArcimUom=$p($g(^CT("UOM",ArcimUom)),"^",1)
	If ArcimUom="HOUR" {
		Set ^DHCMR("OEOrdExec",argEpisodeID,xArcimID,xOEItemID,"ExecType")=1
	}
	Set OEPHFreq=$p($g(^OEORD(+xOEItemID,"I",+$p(xOEItemID,"||",2),2)),"^",4)
	Set:OEPHFreq'="" OEPHFreq=$p($g(^PHCFR(OEPHFreq)),"^",1)
	//If OEPHFreq="持续" {
	//	Set ^DHCMR("OEOrdExec",argEpisodeID,xArcimID,xOEItemID,"ExecType")=1
	//}
	
	Set OEXDate=$p($g(^OEORD(+xOEItemID,"I",$p(xOEItemID,"||",2),3)),"^",34)
	Set OEXTime=$p($g(^OEORD(+xOEItemID,"I",$p(xOEItemID,"||",2),2)),"^",15)
	If OEXDate'="" {
		Set OEXDate=$zd(+OEXDate,3)
		Set OEXTime=$zt(+OEXTime,1)
	}
	Set OESttDate=$p($g(^OEORD(+xOEItemID,"I",$p(xOEItemID,"||",2),1)),"^",9)
	Set OESttTime=$p($g(^OEORD(+xOEItemID,"I",$p(xOEItemID,"||",2),1)),"^",10)
	If OESttDate'="" {
		Set OESttDate=$zd(+OESttDate,3)
		Set OESttTime=$zt(+OESttTime,1)
	}
	Set ArcimDesc=$p($g(^ARCIM(+xArcimID,+$p(xArcimID,"||",2),1)),"^",2)
	
	Set OEPriorityID=$p($g(^OEORD(+xOEItemID,"I",+$p(xOEItemID,"||",2),1)),"^",8)
	Set OEPriorityCode=$p($g(^OECPR(+OEPriorityID)),"^",1)   // PRN医嘱
	Set OEPriorityDesc=$p($g(^OECPR(+OEPriorityID)),"^",2)   // 医嘱类型
	
	//同步执行记录
	If $o(^OEORD(+xOEItemID,"I",$p(xOEItemID,"||",2),"X",0))'=""
	{
		Set xChildID=+$g(^DHCMR("OEOrdExec",argEpisodeID,xArcimID,xOEItemID,"ExStDate"))
		For {
			Set xChildID=$o(^OEORD(+xOEItemID,"I",$p(xOEItemID,"||",2),"X",xChildID))
			Quit:xChildID=""
			Set xData=$g(^OEORD(+xOEItemID,"I",$p(xOEItemID,"||",2),"X",xChildID))
			Set ExStDate=$p(xData,"^",1)
			Set ExStTime=+$p(xData,"^",2)
			Continue:ExStDate=""
			Set OEExecID=xOEItemID_"||"_xChildID
			Set ^DHCMR("OEOrdExec",argEpisodeID,xArcimID,xOEItemID,"ExStDate",ExStDate,ExStTime,OEExecID)=$lb($zd(ExStDate,3),$zt(ExStTime,1),ArcimDesc,OESttDate_" "_OESttTime,OEXDate_" "_OEXTime,OEPriorityDesc)
			Set ^DHCMR("OEOrdExec",argEpisodeID,xArcimID,xOEItemID,"ExStDate")=xChildID
		}
	}
	
	//判断是否长期医嘱(医嘱状态只考虑长期、临时情况)
	Set ISLongOrderPrior=0
	Set:OEPriorityID'="" ISLongOrderPrior=##class(appcom.OEOrdItem).ISLongOrderPrior(OEPriorityID)
	If ISLongOrderPrior=1 {
		//判断医嘱是否结束(长期停止或作废即停)
		Set OEStatus=$p($g(^OEORD(+xOEItemID,"I",+$p(xOEItemID,"||",2),1)),"^",13)
		Set:OEStatus'="" OEStatus=$p($g(^OEC("OSTAT",OEStatus)),"^",1)
		Set OEStatusList=$lb("C","U","D")   //Cancel撤销,Unused作废,Discontinued停止
		Set ^DHCMR("OEOrdExec",argEpisodeID,xArcimID,xOEItemID,"XStatus")=$s($listfind(OEStatusList,OEStatus)>0:1,1:0)
	} Else {
		//判断医嘱是否结束(临时开完即停)
		Set ^DHCMR("OEOrdExec",argEpisodeID,xArcimID,xOEItemID,"XStatus")=1
	}
	
	//根据频次判断是否PRN医嘱,PRN医嘱不设置完成状态
	If (OEPHFreq="Prn")||(OEPHFreq="PRN") {
		Set ^DHCMR("OEOrdExec",argEpisodeID,xArcimID,xOEItemID,"XStatus")=0
	}
	
	//根据医嘱类型判断是否PRN医嘱,PRN医嘱不设置完成状态
	If OEPriorityCode="PRN" {
		Set ^DHCMR("OEOrdExec",argEpisodeID,xArcimID,xOEItemID,"XStatus")=0
	}
	
	Quit
	
getOEOrdExecNewErr
	Set $ZT=""
	Quit -999
}

}
