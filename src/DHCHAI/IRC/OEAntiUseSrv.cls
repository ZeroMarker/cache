/// 名称: DHCHAI.IRC.OEAntiUseSrv
/// 描述: 抗生素使用检查规则
/// 编写者：zhufei
/// 编写日期: 2017-05-22
Class DHCHAI.IRC.OEAntiUseSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2017-05-22
/// Description:  检查规则-抗生素使用
/// Table：       DHCHAI.IR.CCResult
/// Input：       aEpisodeDr : 就诊号（DHCHAI.DP.PAAdm.ID）
///               aSttDate : 开始日期
///               aEndDate : 截止日期
///               aItmMastID : 监控项目（DHCHAI.IR.CCItmMast.ID）
/// Return：      返回String
/// w ##class(DHCHAI.IRC.OEAntiUseSrv).Check(aEpisodeDr,aSttDate,aEndDate,aItmMastID)
ClassMethod Check(aEpisodeDr As %String, aSttDate As %String, aEndDate As %String, aItmMastID As %String) As %String
{
	new (aEpisodeDr,aSttDate,aEndDate,aItmMastID)
	Set return=0
	Quit:(aSttDate="")||(aEndDate="")||(aItmMastID="") return
	Quit:aEpisodeDr="" return
	
	Set $ZT="CheckErr"
	
	Kill arrOEOrdItem
	
	//^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate")
	//^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseXDate")
	//就诊医嘱开始日期索引
	Set xSCode=""
	For {
		Set xSCode=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeDr,xSCode))
		Quit:xSCode=""
		
		Set xDate=aSttDate-1
		For {
			Set xDate=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeDr,xSCode,1,xDate))
			Quit:xDate=""
			Quit:xDate>aEndDate
			
			Set xID=0
			For {
				Set xID=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeDr,xSCode,1,xDate,xID))
				Quit:xID=""
				
				Continue:$d(arrOEOrdItem(xID))
				Set arrOEOrdItem(xID)=""
				
				//获取筛查结果
				Do ..GetCheck(xID,aItmMastID)
			}
		}
	}
	
	//就诊医嘱停止日期索引
	Set xSCode=""
	For {
		Set xSCode=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseXDate",aEpisodeDr,xSCode))
		Quit:xSCode=""
		
		Set xDate=aSttDate-1
		For {
			Set xDate=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseXDate",aEpisodeDr,xSCode,1,xDate))
			Quit:xDate=""
			Quit:xDate>aEndDate
			
			Set xID=0
			For {
				Set xID=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseXDate",aEpisodeDr,xSCode,1,xDate,xID))
				Quit:xID=""
				
				Continue:$d(arrOEOrdItem(xID))
				Set arrOEOrdItem(xID)=""
				
				//获取筛查结果
				Do ..GetCheck(xID,aItmMastID)
			}
		}
	}
	Kill arrOEOrdItem
	
	Quit 1
	
CheckErr
	Quit "-999^"_$ZError
}

/// Creator：     zhufei
/// CreatDate：   2017-05-22
/// Description:  检查规则-抗生素使用
/// Table：       DHCHAI.IR.CCResult
/// Input：       aEpisodeDr : 就诊号（DHCHAI.DP.PAAdm.ID）
///               aSttDate : 开始日期
///               aEndDate : 截止日期
///               aItmMastID : 监控项目（DHCHAI.IR.CCItmMast.ID）
/// Return：      返回String
/// w ##class(DHCHAI.IRC.OEAntiUseSrv).Check2(aEpisodeDr,aSttDate,aEndDate,aItmMastID)
ClassMethod Check2(aEpisodeDr As %String, aSttDate As %String, aEndDate As %String, aItmMastID As %String) As %String
{
	new (aEpisodeDr,aSttDate,aEndDate,aItmMastID)
	Set return=0
	Quit:(aSttDate="")||(aEndDate="")||(aItmMastID="") return
	Quit:aEpisodeDr="" return
	
	Set $ZT="Check2Err"
	
	//就诊更新日期索引
	Set xDate=aSttDate-1
	For {
		Set xDate=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisUpdateDate",aEpisodeDr,xDate))
		Quit:xDate=""
		Quit:xDate>aEndDate
		
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisUpdateDate",aEpisodeDr,xDate,xID))
			Quit:xID=""
			
			//获取筛查结果
			Set ret = ..GetCheck(xID,aItmMastID)
			If (+ret)<1{
				Set objOEItem=##class(DHCHAI.DP.OEOrdItem).GetObjById(xID)
				If $IsObject(objOEItem){
					Set SCode=objOEItem.OESCode
					D ##class(DHCHAI.IRC.CtrlResultSrv).CancelCCResult(aEpisodeDr,aItmMastID,SCode,xID)
				}
			}
		}
	}
	
	Quit 1
	
Check2Err
	Quit "-999^"_$ZError
}

ClassMethod GetCheck(aOEItemID As %String, aItmMastID As %String) As %String
{
	New (aOEItemID,aItmMastID)
	Set return=0
	Quit:(aOEItemID="")||(aItmMastID="") return
	
	Set objOEItem=##class(DHCHAI.DP.OEOrdItem).GetObjById(aOEItemID)
	Quit:'$IsObject(objOEItem) return
	Quit:'$IsObject(objOEItem.OEEpisodeDr) return
	Set IsActive=objOEItem.OEIsActive
	Quit:IsActive'=1 return
	Set AntFlag=objOEItem.OEAntUseFlag  //修复bug:580110
	Quit:AntFlag'=1 return
	
	Set OEItemID=objOEItem.%Id()
	Set EpisodeID=objOEItem.OEEpisodeDr.%Id()
	Set SCode=objOEItem.OESCode             //子系统代码
	Set OrdDesc=objOEItem.OEOrdDesc         //抗生素名称
	Set SttDate=objOEItem.OESttDate         //医嘱开始日期
	Set SttTime=objOEItem.OESttTime         //医嘱开始时间
	Set Doctor=objOEItem.OEDoctor           //开医嘱人
	Set DocName=$p(Doctor,"|",3)
	Set XDate=objOEItem.OEXDate             //停医嘱日期
	Set XTime=objOEItem.OEXTime             //停医嘱时间
	Set DrgPoison=objOEItem.OEAntDrgPoison  //管制分类
	Set AntUsePurpose=objOEItem.OEAntUsePurpose  //使用目的
	Set AntOthPurpose=objOEItem.OEAntOthPurpose  //使用目的
	Set Priority=objOEItem.OEPriority       //医嘱类型
	If ((DrgPoison="KSS1")||(DrgPoison="KSS2")) { // 术前一天，术后两天内的非限制级和限制级抗生素排除筛查。
		Set OperFlg=..CheckOperAnti(EpisodeID,SttDate)
		Quit:OperFlg=1 return
	}
	Set IsNotEnd=1
	Set MapPriority=##class(DHCHAI.DP.PhraseMap).GetMapValue(SCode,"OEPriority",Priority)
	If MapPriority["S" {
		Set:XDate="" IsNotEnd=0  //长期医嘱未结束
	}
	//筛查结果过滤皮试医嘱、非全身用药
	Set Instruc=objOEItem.OEInstruc  //给药途径
	Quit:Instruc["皮试" return
	Set InstrucMapStr =  ##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"AntiAdminRoute",Instruc)		
	Quit:InstrucMapStr="" return
	Set InstrucMap = $p(InstrucMapStr,"^",3)
	Set InstrucList=##class(DHCHAI.BT.Config).GetValByCode("StatInstrucList")
    Set InstrucList=","_InstrucList_","
	Quit:(InstrucList'="")&&(InstrucList'[(","_InstrucMap_",")) return
				
	Set IsAbFlag=1
	Set MapAntUseInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"AntiMedPurpose",AntUsePurpose)
	Set MapAntUsePurp=$p(MapAntUseInfo,"^",3)	
	//w !,aOEItemID," " ,MapAntUsePurp," ",AntUsePurpose
	If MapAntUsePurp="预防" {  //预防用药
		Set IsAbFlag=0
	} ElseIf MapAntUsePurp["治疗" {  //治疗用药
		Set IsAbFlag=1
	} Else {
		If (AntOthPurpose["术前")||(AntOthPurpose["术中")||(AntOthPurpose["术后") {
			Set IsAbFlag=0  //预防用药
		} Else {
			If SttDate'="" {
				Set OperDates=##class(DHCHAI.DPS.OROperationSrv).GetOperaDates(EpisodeID)
				For indOP=1:1:$ll(OperDates){
					Set OperDate=$listget(OperDates,indOP)
					Continue:OperDate=""
					
					Set tDays=OperDate-SttDate
					Continue:tDays>1
					Continue:tDays<-3
					Set IsAbFlag=0  //预防用药
				}
			}
		}
	}
	//w !,MapAntUsePurp, " ",IsAbFlag
	Set obj=##class(DHCHAI.IRC.CtrlRecord).GetObj(EpisodeID,aItmMastID)
	Quit:'$IsObject(obj) return
	
	Set obj.CCResult    = OrdDesc      //抗生素
	Set obj.CCTextRes   = ""           //定性结果
	Set obj.CCUnit      = ""           //单位
	Set obj.CCActDate   = SttDate      //医嘱开始日期
	Set obj.CCActTime   = SttTime      //医嘱开始时间
	Set obj.CCActUser   = DocName      //开医嘱人
	Set obj.CCRepDate   = XDate        //停止日期
	Set obj.CCRepTime   = XTime        //停止时间
	Set obj.CCRepUser   = ""           //停止人
	Set obj.CCSCode     = SCode        //子系统代码
	Set obj.CCObjectID  = OEItemID
	Set obj.CCParams    = "OEItemID="_OEItemID
	
	Set obj.CCKeyWord   = "抗菌用药"   //关键词
	Set obj.CCIsAbFlag  = IsAbFlag     //0预防用药、1治疗用药
	Set obj.CCAntiDesc  = OrdDesc      //抗生素名称
	Set obj.CCAntiGrade = DrgPoison    //抗生素等级（管制分类）
	Set obj.CCIsNotEnd  = IsNotEnd     //未结束标记（长期医嘱）
	Set obj.CCSummary   = OrdDesc      //摘要信息
	
	Set return=##class(DHCHAI.IRC.CtrlResultSrv).SaveResult(obj)
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2018-01-05
/// Description:  术前一天，术后两天内的非限制级和限制级抗生素排除筛查。
/// Table：       DHCHAI.DP.OROperAnaes
/// Input：       aEpisodeDr
/// Return：      返回 0:不排除   1:排除
/// w ##class(DHCHAI.IRC.OEAntiUseSrv).CheckOperAnti("5391","64397")
ClassMethod CheckOperAnti(aEpisodeDr As %String, aSttDate As %String) As %String
{
	New (aEpisodeDr,aSttDate)
	Set return=0
	Quit:(aSttDate="")||(aEpisodeDr="") return
	
	Set DateFrom = aSttDate-2
	Set DateTo   = aSttDate+1
	Set xDate=DateFrom-1
	For{
		Set xDate=$o(^DHCHAI.DP.OROperAnaesI("IndexEpisodeDrOperDate",aEpisodeDr,xDate))
		Quit:(xDate="")||(return=1)
		Quit:xDate>DateTo
		Set xID=""
		For {	
			Set xID=$o(^DHCHAI.DP.OROperAnaesI("IndexEpisodeDrOperDate",aEpisodeDr,xDate,xID))
			Quit:(xID="")||(return=1)
			Set obj=##class(DHCHAI.DP.OROperAnaes).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:'$IsObject(obj.OREpisodeDr)
			Continue:obj.ORIsActive'=1
			Set return=1
		}
	}
	
	Quit return
}

}
