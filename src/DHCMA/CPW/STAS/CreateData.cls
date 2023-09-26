/// 名称: DHCMA.CPW.STAS.CreateData
/// 描述: 临床路径 生成统计所需数据
/// 编写者：jiangpengpeng
/// 编写日期: 2019-03-21
Class DHCMA.CPW.STAS.CreateData Extends DHCMA.CPW.STAS.CommonSrv [ Abstract, ClassType = "", Not ProcedureBlock ]
{

/// Creator：     jiangpengpeng
/// CreatDate：   2019-03-21
/// Description:  按月份生成数据
/// Table：       DHCMA.CPW.STA.DataResults
/// Input：       入参为月份2019-03
/// Return：      
/// w ##class(DHCMA.CPW.STAS.CreateData).SyncDataByMonth("2021-01","2021-03")
ClassMethod SyncDataByMonth(aFromDate As %String, aToDate As %String) As %String
{
	New (aFromDate,aToDate)
	Set $ZT="SyncDataByMonthErr"
	Set return=""
	Quit:(aFromDate="")||(aToDate="") return
	
	Set aFromDate=..GetMonthStaLastDay(aFromDate,1)
	Set aFromDate=$p(aFromDate,"^",1)
	
	Set aToDate=..GetMonthStaLastDay(aToDate,1)
	Set aToDate=$p(aToDate,"^",2)
	Quit:(aFromDate>aToDate) return
	Quit:(aFromDate="")||(aToDate="") return
	
	//记录执行任务日志
	Set Date=$zd(+$h,3),Time=$zt($p($h,",",2),1)
	Set YY=$p(Date,"-",1)
	Set MM=$p(Date,"-",2)
	Set DD=+$p(Date,"-",3)
	Set NUM=$i(^DHCMA.CPW.STAS.CreateData(YY_"-"_MM,DD))
	Set ^DHCMA.CPW.STAS.CreateData(YY_"-"_MM,DD,NUM,"命令")="SyncDataByMonth("_aFromDate_","_aToDate_")"
	Set ^DHCMA.CPW.STAS.CreateData(YY_"-"_MM,DD,NUM,"开始")=$zd(+$h,3)_" "_$zt($p($h,",",2),1)
	
	Set NIndex="GetDataByMonth"
    Kill ^TMP($zn,$j,NIndex)
    
    Set StatusList=$lb("T","I","O","C")		//需要统计的路径状态列表
    Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
    Set xDate=aFromDate-1
    For {
    	Set xDate=$o(^DHCMA.Util.EPx.EpisodeI("IdxOfDischDate",SYSDr,xDate))
    	Quit:xDate=""
    	Quit:xDate>aToDate
    	
    	Set xfirstDay=..GetMonthStaLastDay($zd(xDate,3),1)
		Continue:xfirstDay=""
		Set xfirstDay=$p(xfirstDay,"^",1)
    	
    	Set xEpisodeID=""
    	For {
    		Set xEpisodeID=$o(^DHCMA.Util.EPx.EpisodeI("IdxOfDischDate",SYSDr,xDate,xEpisodeID))
    		Quit:xEpisodeID=""
    		
    		Set AdmInfo=$g(^DHCMA.Util.EPx.EpisodeD(xEpisodeID))
    		Continue:AdmInfo=""
    		Set DischDate=$Lg(AdmInfo,30)
    		Continue:DischDate=""			//直接通过出院日期过滤，考虑出院召回患者状态未发生变化但出院日期已存在
    		Set Status=$Lg(AdmInfo,5)
    		//Continue:Status'="D"
    		Set MotherDr=$lg(AdmInfo,36)
    		Continue:MotherDr'=""			//过滤婴儿
    		
    		Set AdmDays=$Lg(AdmInfo,32)	//住院天数
    		Set EpisodeID=$Lg(AdmInfo,2)
    		Set AdmLocID=$P(^PAADM($p(EpisodeID,"!!",1)),"^",4)_"!!"_SYSDr
    		Set objLoc = ##class(DHCMA.Util.EP.Location).GetObjByOID(AdmLocID)
    		Continue:'$IsObject(objLoc)
    		Set HospID=$p(objLoc.BTHospID,"!!",1)
    		Continue:HospID=""
    		Set AdmOutLocID=$P(^PAADM($p(EpisodeID,"!!",1)),"^",4)_"!!"_SYSDr		//出院科室
    		Set AdmLocID=AdmLocID_"^"_AdmOutLocID
    		Set num=$i(^TMP($zn,$j,NIndex,xfirstDay,HospID,AdmLocID,"DischCount"))	//出院人数
    		
    		Set FeeStr=..getCostInfo(+EpisodeID)	//住院总费用
    		Set AdmFees=$p(FeeStr,"^",1)
			Set DrugCost=$p(FeeStr,"^",2)
			Set LabCost=$p(FeeStr,"^",3)
			Set MaterialCost=$p(FeeStr,"^",5)
    		Set IsHAI=..CheckHAIByAdm(+EpisodeID)	//是否发生院感
    	
			Set xPathwayID=$o(^DHCMA.CPW.CP.PathwayI("IdxofEpisodeID",EpisodeID,""),-1)
			Continue:xPathwayID=""
			
			Set objCPW=##class(DHCMA.CPW.CP.Pathway).GetObjById(xPathwayID)
			Continue:'$IsObject(objCPW)
			Set CPWStatus=objCPW.CPStatus
			Continue:$lf(StatusList,CPWStatus)<1
			Set InLocID=objCPW.CPInLocID
			Continue:'$IsObject(objCPW.CPFormDr.FormPathDr)
			Set PathID=objCPW.CPFormDr.FormPathDr.%Id()
			Set:InLocID="" InLocID=..GetApplyLoc(xPathwayID)	//获取不入径申请的科室
			//Continue:'$IsObject(objCPW.CPFormDr.FormPathDr.BTEntityDr)	//过滤没有单病种信息的路径
			//Set:InLocID'="" AdmLocID=InLocID
			Continue:InLocID=""
			Set AdmLocID=InLocID_"^"_AdmOutLocID
			
			Set num=$i(^TMP($zn,$j,NIndex,xfirstDay,HospID,AdmLocID,PathID,"ForCP"))	//应入人数
			Set ^TMP($zn,$j,NIndex,xfirstDay,HospID,AdmLocID,PathID,"ForCPWID")=$g(^TMP($zn,$j,NIndex,xfirstDay,HospID,AdmLocID,PathID,"ForCPWID"))_$lb(xPathwayID)
			
			//除应入人数，其他指标一律只统计进入路径的病例 add by yankai20210514
			Continue:((CPWStatus'="I")&&(CPWStatus'="O")&&(CPWStatus'="C")) 		
			Set num=$i(^TMP($zn,$j,NIndex,xfirstDay,HospID,AdmLocID,PathID,"InCP"))	//入径人数
			Set ^TMP($zn,$j,NIndex,xfirstDay,HospID,AdmLocID,PathID,"InCPWID")=$g(^TMP($zn,$j,NIndex,xfirstDay,HospID,AdmLocID,PathID,"InCPWID"))_$lb(xPathwayID)
			If (IsHAI=1) {
    			Set num=$i(^TMP($zn,$j,NIndex,xfirstDay,HospID,AdmLocID,PathID,"HAI"))	//发生院感人数
				Set ^TMP($zn,$j,NIndex,xfirstDay,HospID,AdmLocID,PathID,"HAICPWID")=$g(^TMP($zn,$j,NIndex,xfirstDay,HospID,AdmLocID,PathID,"HAICPWID"))_$lb(xPathwayID)
			}
			//总住院日
			Set ^TMP($zn,$j,NIndex,xfirstDay,HospID,AdmLocID,PathID,"Day")=+$g(^TMP($zn,$j,NIndex,xfirstDay,HospID,AdmLocID,PathID,"Day"))+AdmDays
			//总费用
			Set ^TMP($zn,$j,NIndex,xfirstDay,HospID,AdmLocID,PathID,"Fee")=+$g(^TMP($zn,$j,NIndex,xfirstDay,HospID,AdmLocID,PathID,"Fee"))+AdmFees
			
			If (CPWStatus="O") {
				Set num=$i(^TMP($zn,$j,NIndex,xfirstDay,HospID,AdmLocID,PathID,"OutCP"))	//出径人数
				Set ^TMP($zn,$j,NIndex,xfirstDay,HospID,AdmLocID,PathID,"OutCPWID")=$g(^TMP($zn,$j,NIndex,xfirstDay,HospID,AdmLocID,PathID,"OutCPWID"))_$lb(xPathwayID)
			}
			If (CPWStatus="C") {
				Set num=$i(^TMP($zn,$j,NIndex,xfirstDay,HospID,AdmLocID,PathID,"ClsCP"))	//完成人数
				Set ^TMP($zn,$j,NIndex,xfirstDay,HospID,AdmLocID,PathID,"ClsCPWID")=$g(^TMP($zn,$j,NIndex,xfirstDay,HospID,AdmLocID,PathID,"ClsCPWID"))_$lb(xPathwayID)
			}
			
			Set IsVar=0
			Set xVarID=""
			For {
				Set xVarID=$o(^DHCMA.CPW.CP.PathwayD(xPathwayID,"VAR",xVarID))
				Quit:xVarID=""
				
				Set objVar=##class(DHCMA.CPW.CP.PathwayVar).GetObjById(xPathwayID_"||"_xVarID)
		 		Continue:'$IsObject(objVar)
			 	Continue:(objVar.CPOrdDID="")&&('$IsObject(objVar.CPImplDr))
			 	
			 	Set IsVar=1
			 	Quit
			}
			If (+IsVar=1) {
				Set num=$i(^TMP($zn,$j,NIndex,xfirstDay,HospID,AdmLocID,PathID,"VarCP"))	//发生变异人数
				Set ^TMP($zn,$j,NIndex,xfirstDay,HospID,AdmLocID,PathID,"VarCPWID")=$g(^TMP($zn,$j,NIndex,xfirstDay,HospID,AdmLocID,PathID,"VarCPWID"))_$lb(xPathwayID)
			}
		
			Set IsReAdm=..CheckReByAdm(xEpisodeID)	//是否当天再入院
			If (+IsReAdm=1) {
				Set num=$i(^TMP($zn,$j,NIndex,xfirstDay,HospID,AdmLocID,PathID,"ReAdm"))  //当天再入院人数
			}
			
			Set ret=..Check24hOutByAdm(xEpisodeID,xPathwayID)	//是否24小时内退出
			If (+ret=1) {
				Set num=$i(^TMP($zn,$j,NIndex,xfirstDay,HospID,AdmLocID,PathID,"24Out"))  //24小时内退出人数
			}
			
			Set DaysBeforeOpr=..GetDaysBeforeOpr(xEpisodeID)	 //术前住院日
			Set ^TMP($zn,$j,NIndex,xfirstDay,HospID,AdmLocID,PathID,"DaysBeforeOpr")=+$g(^TMP($zn,$j,NIndex,xfirstDay,HospID,AdmLocID,PathID,"DaysBeforeOpr"))+DaysBeforeOpr
			Set DischCond=..GetDischCond(+EpisodeID)	//出院情况
			
			If (DischCond="治愈") {
				Set num=$i(^TMP($zn,$j,NIndex,xfirstDay,HospID,AdmLocID,PathID,"Healing"))
			} ElseIf (DischCond="好转") {
				Set num=$i(^TMP($zn,$j,NIndex,xfirstDay,HospID,AdmLocID,PathID,"Better"))
			} ElseIf (DischCond="死亡") {
				Set num=$i(^TMP($zn,$j,NIndex,xfirstDay,HospID,AdmLocID,PathID,"Dead"))
			}Else{}
			
			Set ret=..CheckOprInf(+EpisodeID)	//是否手术感染
			If (+ret=1) {
				Set num=$i(^TMP($zn,$j,NIndex,xfirstDay,HospID,AdmLocID,PathID,"OprInf"))
			}
			Set ret=..CheckReOprPat(+EpisodeID)	//是否非计划重返手术
			If (+ret=1) {
				Set num=$i(^TMP($zn,$j,NIndex,xfirstDay,HospID,AdmLocID,PathID,"ReOper"))
			}
			// 药费
			Set ^TMP($zn,$j,NIndex,xfirstDay,HospID,AdmLocID,PathID,"DrugCost")=+$g(^TMP($zn,$j,NIndex,xfirstDay,HospID,AdmLocID,PathID,"DrugCost"))+DrugCost
			// 检验费
			Set ^TMP($zn,$j,NIndex,xfirstDay,HospID,AdmLocID,PathID,"LabCost")=+$g(^TMP($zn,$j,NIndex,xfirstDay,HospID,AdmLocID,PathID,"LabCost"))+LabCost
			// 耗材费
			Set ^TMP($zn,$j,NIndex,xfirstDay,HospID,AdmLocID,PathID,"MaterialCost")=+$g(^TMP($zn,$j,NIndex,xfirstDay,HospID,AdmLocID,PathID,"MaterialCost"))+MaterialCost
			
			Set ret=..CheckPreDrug(+EpisodeID) //是否使用预防性抗菌药物
			If (+ret=1) {
				Set num=$i(^TMP($zn,$j,NIndex,xfirstDay,HospID,AdmLocID,PathID,"PreDrug"))
			}
			Set ret=..Check3Pharmacy(+EpisodeID) // 是否使用三线抗菌药物
			If (+ret=1) {
				Set num=$i(^TMP($zn,$j,NIndex,xfirstDay,HospID,AdmLocID,PathID,"3Pharmacy"))
			}
			Set AntInfo=..GetPatAntInfoById(+EpisodeID) //抗生素信息
			Set IsUsed=$p(AntInfo,"^",1)
			If (+IsUsed=1) {
				Set num=$i(^TMP($zn,$j,NIndex,xfirstDay,HospID,AdmLocID,PathID,"Pharmacy"))
			}
			
			Set PhcCostDays=..GetPhcCostDays(+EpisodeID) //抗生素费用、天数
			Set PhcCost=$p(PhcCostDays,"^",1)
			Set PhcDays=$p(PhcCostDays,"^",2)
			Set ^TMP($zn,$j,NIndex,xfirstDay,HospID,AdmLocID,PathID,"PhcCost")=+$g(^TMP($zn,$j,NIndex,xfirstDay,HospID,AdmLocID,PathID,"PhcCost"))+PhcCost
			Set ^TMP($zn,$j,NIndex,xfirstDay,HospID,AdmLocID,PathID,"PhcDays")=+$g(^TMP($zn,$j,NIndex,xfirstDay,HospID,AdmLocID,PathID,"PhcDays"))+PhcDays
			
			Set NextDays=..GetTimesInHospDays(+EpisodeID) //再入院天数
			Set:(NextDays>=0)&&(NextDays<=14) num=$i(^TMP($zn,$j,NIndex,xfirstDay,HospID,AdmLocID,PathID,"ReAdmIn14"))
			Set:(NextDays>=0)&&(NextDays<=31) num=$i(^TMP($zn,$j,NIndex,xfirstDay,HospID,AdmLocID,PathID,"ReAdmIn31"))
			
			Set IsExistCompl=..IsExistCompl(xPathwayID)
			Set:IsExistCompl=1 num=$i(^TMP($zn,$j,NIndex,xfirstDay,HospID,AdmLocID,PathID,"ExistCompl"))
    		
    	}
    }
    
    Set TypeList=$lb("ForCPWID","InCPWID","OutCPWID","ClsCPWID","VarCPWID","HAICPWID")
    Set xTime=""
    For {
    	Set xTime=$o(^TMP($zn,$j,NIndex,xTime))
    	Quit:xTime=""
    	
    	Set xHospID=""
    	For {
	    	Set xHospID=$o(^TMP($zn,$j,NIndex,xTime,xHospID))
    		Quit:xHospID=""	
    		
    		Set xLocID=""
	    	For {
	    		Set xLocID=$o(^TMP($zn,$j,NIndex,xTime,xHospID,xLocID))
	    		Quit:xLocID=""
	    		//入经或就诊科室
	    		Set objLoc=##class(DHCMA.Util.EP.Location).GetObjByOID($p(xLocID,"^",1))
				Continue:'$IsObject(objLoc)
				Set LocDesc=objLoc.BTDesc	//科室名称
				Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
				//新增出院科室
				Set AdmOutLocID=$p(xLocID,"^",2)
				Set objOutLoc=##class(DHCMA.Util.EP.Location).GetObjByOID(AdmOutLocID)
				Continue:'$IsObject(objOutLoc)
				Set LocOutDesc=objOutLoc.BTDesc	//科室名称
				Set:LocOutDesc["-" LocOutDesc=$p(LocOutDesc,"-",2)
				If $p(xLocID,"^",1)=$p(xLocID,"^",2){
					Set DischCount=$g(^TMP($zn,$j,NIndex,xTime,xHospID,xLocID,"DischCount"))
	    			//生成/更新科室月出院人数唯一记录
	    			//Set MthDischStr=xTime_"^"_xHospID_"^"_xLocID_"^"_DischCount
	    			Set MthDischStr=xTime_"^"_xHospID_"^"_$p(xLocID,"^",1)_"^"_DischCount
	    		
	    			Do ##class(DHCMA.CPW.STA.MonthDischData).Update(MthDischStr,"^")
				}
	    		
	    		Set xPathID=""
	    		For {
	    			Set xPathID=$o(^TMP($zn,$j,NIndex,xTime,xHospID,xLocID,xPathID))
	    			Quit:xPathID=""
	    			Continue:xPathID="DischCount"
	    			Set objPath=##class(DHCMA.CPW.BT.PathMast).GetObjById(xPathID)
	    			Continue:'$IsObject(objPath)
	    			
	    			Set PathID=xPathID
	    			Set PathDesc=objPath.BTDesc					//路径名称
	    			Set PathTypeID=objPath.BTTypeDr.%Id()
	    			Set PathTypeDesc=objPath.BTTypeDr.BTDesc		//路径类型
	    			Set SDID="" ,SDDesc=""
	    			If $IsObject(objPath.BTEntityDr) {
	    				Set SDID=objPath.BTEntityDr.%Id()
	    				Set SDDesc=objPath.BTEntityDr.BTDesc	 		//单病种名称
	    			}
	    			Set ForCPCount=+$g(^TMP($zn,$j,NIndex,xTime,xHospID,xLocID,xPathID,"ForCP"))	//应入人数
	    			Set InCPCount =+$g(^TMP($zn,$j,NIndex,xTime,xHospID,xLocID,xPathID,"InCP"))		//入径人数
	    			Set HAICount  =+$g(^TMP($zn,$j,NIndex,xTime,xHospID,xLocID,xPathID,"HAI"))		//感染人数
	    			Set OutCPCount=+$g(^TMP($zn,$j,NIndex,xTime,xHospID,xLocID,xPathID,"OutCP"))	//出径人数
	    			Set ClsCPCount=+$g(^TMP($zn,$j,NIndex,xTime,xHospID,xLocID,xPathID,"ClsCP"))	//完成人数
	    			Set VarCPCount=+$g(^TMP($zn,$j,NIndex,xTime,xHospID,xLocID,xPathID,"VarCP"))	//发生变异人数
	    			Set DaysCount =+$g(^TMP($zn,$j,NIndex,xTime,xHospID,xLocID,xPathID,"Day"))		//总住院日
	    			Set FeesCount =+$g(^TMP($zn,$j,NIndex,xTime,xHospID,xLocID,xPathID,"Fee"))		//总费用
	    			
	    			Set Inputs=xTime_"^"_xHospID_"^"_$p(xLocID,"^",1)_"^"_LocDesc_"^"_PathTypeID_"^"_PathTypeDesc
	    			Set Inputs=Inputs_"^"_PathID_"^"_PathDesc_"^"_SDID_"^"_SDDesc
	    			Set Inputs=Inputs_"^"_ForCPCount_"^"_InCPCount_"^"_OutCPCount_"^"_ClsCPCount_"^"_VarCPCount
	    			Set Inputs=Inputs_"^"_HAICount_"^"_DaysCount_"^"_FeesCount
	    			
	    			Set ReAdmCount=$g(^TMP($zn,$j,NIndex,xTime,xHospID,xLocID,xPathID,"ReAdm"))
	    			Set OutCP24hCount=$g(^TMP($zn,$j,NIndex,xTime,xHospID,xLocID,xPathID,"24Out"))
	    			Set OprInHospDays=$g(^TMP($zn,$j,NIndex,xTime,xHospID,xLocID,xPathID,"DaysBeforeOpr"))
	    			Set HealingCount=$g(^TMP($zn,$j,NIndex,xTime,xHospID,xLocID,xPathID,"Healing"))
	    			Set BetterCount=$g(^TMP($zn,$j,NIndex,xTime,xHospID,xLocID,xPathID,"Better"))
	    			Set DeadCount=$g(^TMP($zn,$j,NIndex,xTime,xHospID,xLocID,xPathID,"Dead"))
	    			Set OprInfCount=$g(^TMP($zn,$j,NIndex,xTime,xHospID,xLocID,xPathID,"OprInf"))
	    			Set ReOperCount=$g(^TMP($zn,$j,NIndex,xTime,xHospID,xLocID,xPathID,"ReOper"))
	    			Set DrugCost=$g(^TMP($zn,$j,NIndex,xTime,xHospID,xLocID,xPathID,"DrugCost"))
	    			Set LabCost=$g(^TMP($zn,$j,NIndex,xTime,xHospID,xLocID,xPathID,"LabCost"))
	    			Set MaterialCost=$g(^TMP($zn,$j,NIndex,xTime,xHospID,xLocID,xPathID,"MaterialCost"))
	    			Set PreDrugCount=$g(^TMP($zn,$j,NIndex,xTime,xHospID,xLocID,xPathID,"PreDrug"))
	    			Set TPharmacyCount=$g(^TMP($zn,$j,NIndex,xTime,xHospID,xLocID,xPathID,"3Pharmacy"))
	    			Set PharmacyCount=$g(^TMP($zn,$j,NIndex,xTime,xHospID,xLocID,xPathID,"Pharmacy"))
	    			Set PharmacyDays=$g(^TMP($zn,$j,NIndex,xTime,xHospID,xLocID,xPathID,"PhcDays"))
	    			Set PharmacyCost=$g(^TMP($zn,$j,NIndex,xTime,xHospID,xLocID,xPathID,"PhcCost"))
	    			Set ReAdmIn14Count=$g(^TMP($zn,$j,NIndex,xTime,xHospID,xLocID,xPathID,"ReAdmIn14"))
	    			Set ReAdmIn31Count=$g(^TMP($zn,$j,NIndex,xTime,xHospID,xLocID,xPathID,"ReAdmIn31"))
	    			Set ComplCount=$g(^TMP($zn,$j,NIndex,xTime,xHospID,xLocID,xPathID,"ExistCompl"))	//合并症
					Set ComplCount2=0	//并发症
				
					Set Inputs=Inputs_"^"_ReAdmCount_"^"_OutCP24hCount_"^"_OprInHospDays_"^"_HealingCount_"^"_BetterCount_"^"_DeadCount
	    			Set Inputs=Inputs_"^"_OprInfCount_"^"_ReOperCount_"^"_DrugCost_"^"_LabCost_"^"_MaterialCost_"^"_PreDrugCount
	    			Set Inputs=Inputs_"^"_TPharmacyCount_"^"_PharmacyCount_"^"_PharmacyDays_"^"_PharmacyCost_"^"_ReAdmIn14Count_"^"_ReAdmIn31Count
	    			Set Inputs=Inputs_"^"_ComplCount_"^"_ComplCount2_"^"_DischCount_"^"_AdmOutLocID_"^"_LocOutDesc
	    			
	    			Set return=##class(DHCMA.CPW.STA.DataResults).Update(Inputs)
	    			
	    			//保存明细信息
	    			//已经在保存父表数据时清除旧数据
	    			Set ResultID=return
	    			For ind=1:1:$listlength(TypeList) {
		    			Set type=$listget(TypeList,ind)
		    			Set IDlist=$g(^TMP($zn,$j,NIndex,xTime,xHospID,xLocID,xPathID,type))
		    			Continue:IDlist=""
	    				Set ret=..SaveDetails(ResultID,type,IDlist)
	    			}
	    		}
	    	}
	    }  	
    }
    
    //记录执行任务日志（成功标记）
	Set ^DHCMA.CPW.STAS.CreateData(YY_"-"_MM,DD,NUM,"结束")=$zd(+$h,3)_" "_$zt($p($h,",",2),1)
   	Quit return
   	
SyncDataByMonthErr
	Quit "Error"
}

/// Creator：     jiangpengpeng
/// CreatDate：   2019-03-21
/// Description:  2019年3月之前的程序，做不入径申请时，出入径记录里没有保存科室，
/// 				  所以这里取申请科室
/// Table：       DHCMA.CPW.STA.DataResults
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.STAS.CreateData).GetApplyLoc("8")
ClassMethod GetApplyLoc(aPathwayID As %String) As %String
{
	New (aPathwayID)
	Set return=""
	Quit:aPathwayID="" return
	
	Set objDic=##class(DHCMA.Util.BT.Dictionary).GetObjByPCodeItemDesc("CPWVariatType","未入径原因")
	Quit:'$IsObject(objDic) return
	
	Set TypeID=objDic.%Id()
	Set xID=""
	Set xID=$o(^DHCMA.CPW.CP.PathwayI("APPLY","IdxofParRef",aPathwayID,TypeID,""))
	Quit:xID="" return
	
	Set objApp=##class(DHCMA.CPW.CP.PathwayApply).GetObjById(aPathwayID_"||"_xID)
	Quit:'$IsObject(objApp) return
	
	Set LocID=objApp.CPLocID
	
	Set return=LocID
	Quit return
}

ClassMethod SaveDetails(aResultID As %String, aType As %String, aCPWList As %List) As %String
{
	New (aResultID,aType,aCPWList)
	Set return=""
	Quit:(aResultID="")||(aType="")||(aCPWList="")
	
	Set xType=$Case(aType,"ForCPWID":"F","InCPWID":"I","OutCPWID":"O","ClsCPWID":"C","VarCPWID":"V","HAICPWID":"H")
	For ind=1:1:$listlength(aCPWList) {
		Set xID=$listget(aCPWList,ind)
		Continue:xID=""
		
		Set obj=##class(DHCMA.CPW.STA.DataDetails).%New()
		Set obj.STACPWID=xID
		Set obj.STAType=xType
		Do obj.ParrefSetObjectId(aResultID)
   		Do obj.%Save()
	}
	
	Set return=1
	Quit return
}

/// Creator:	yankai
/// CreatDate:	2021-06-24
/// Desc:		取入径患者是否有合并症
/// w ##class(DHCMA.CPW.STAS.CreateData).IsExistCompl()
ClassMethod IsExistCompl(aPathwayID As %String) As %String
{
	New (aPathwayID)
	Set return=0
	Quit:aPathwayID="" return
	
	Set xComplEtyID=""
	For {
		Set xComplEtyID=$o(^DHCMA.CPW.CP.PathwayI("COMPL","IdxofCompl",xComplEtyID))
		Quit:xComplEtyID=""
		Quit:return=1
		
		Set xSubPwComplID=""
		For {
			Set xSubPwComplID=$o(^DHCMA.CPW.CP.PathwayI("COMPL","IdxofCompl",xComplEtyID,aPathwayID,xSubPwComplID))
			Quit:xSubPwComplID=""
			Quit:return=1
			
			Set xPwComplID=aPathwayID_"||"_xSubPwComplID
			Set objPwCompl=##class(DHCMA.CPW.CP.PathwayCompl).GetObjById(xPwComplID)
			Continue:'$IsObject(objPwCompl)
			Continue:'objPwCompl.CPIsActive
			Set return=1
		}
	}
	
	Quit return
}

}
