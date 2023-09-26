/// 名称: web.DHCCPW.MR.ClinPathWaysVarianceDtl
/// 描述: 临床路径路径外医嘱统计
/// 编写者：zhufei
/// 编写日期: 2012-02-24
Class web.DHCCPW.MR.ClinPathWaysVarianceDtl Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod BuildBaseData(aPaadm As %String) As %List
{
	New (aPaadm)
	Set Data=""
	
	Set objPaadm=##Class(User.PAAdm).%OpenId(aPaadm)
    Quit:'$IsObject(objPaadm) Data
	
    If $IsObject(objPaadm.PAADMPAPMIDR)
    {
	    Set objPatient=objPaadm.PAADMPAPMIDR
	    Set PatientID=objPatient.%Id()
	    //Set PapmiNo=objPatient.PAPMINo
	    Set PapmiNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)
	    Set PatName=objPatient.PAPMIName
	    Set:$IsObject(objPatient.PAPMISexDR) Sex=objPatient.PAPMISexDR.CTSEXDesc
	    Set Birthday=objPatient.PAPMIDOB
		Set:Birthday'="" Birthda=$zd(Birthday,3)
		
		//update by zf 20150228 统一调用年龄计算方法
		Set Age=##class(web.DHCCPW.IO.FromHisSrv).GetPapmiAge(PatientID,aPaadm,"","")	//返回“*岁*月*天”

	    Set PersonalID=objPatient.PAPMIID
	}
	
    //Set AdmitDate=objPaadm.PAADMAdmDate
    //Set AdmitTime=objPaadm.PAADMAdmTime
    //upadte by pylian 2016-02-18 修改入院时间取值方式
    Set AdmDateTime=##Class(web.DHCCPW.IO.FromAdmSrv).GetAdmDateTime(aPaadm)
	Set AdmitDate=$p(AdmDateTime,"^",1)
	Set AdmitTime=$p(AdmDateTime,"^",2)
    //Set DisDate=objPaadm.PAADMDischgDate
    //Set DisTime=objPaadm.PAADMDischgTime
    //Update by pylian 2016-01-21 修改出院时间取值方式
	Set DischDateTime=##Class(web.DHCCPW.IO.FromAdmSrv).GetDischDateTime(aPaadm)
	Set DisDate=$p(DischDateTime,"^",1)
	Set DisTime=$p(DischDateTime,"^",2)
    If DisDate'="" {
	    Set AdmDays=DisDate-AdmitDate
    } Else {
		Set AdmDays=+$h-AdmitDate
	}
    Set:AdmitDate'="" AdmitDate=$zd(AdmitDate,3)
    Set:AdmitTime'="" AdmitTime=$zt(AdmitTime,1)
    Set:DisDate'="" DisDate=$zd(DisDate,3)
    Set:DisTime'="" DisTime=$zt(DisTime,1)
    If $IsObject(objPaadm.PAADMDepCodeDR)
    {
	    Set AdmLoc=objPaadm.PAADMDepCodeDR.CTLOCDesc
	    Set:$p(AdmLoc,"-",2)'="" AdmLoc=$p(AdmLoc,"-",2)
	}
    If $IsObject(objPaadm.PAADMCurrentWardDR)
    {
	    Set AdmWard=objPaadm.PAADMCurrentWardDR.WARDDesc
	    Set:$p(AdmWard,"-",2)'="" AdmWard=$p(AdmWard,"-",2)
	}
	If $IsObject(objPaadm.PAADMCurrentRoomDR)
	{
		Set AdmRoom=objPaadm.PAADMCurrentRoomDR.ROOMDesc
	}
	If $IsObject(objPaadm.PAADMCurrentBedDR)
	{
		Set AdmBed=objPaadm.PAADMCurrentBedDR.BEDCode
	}
	If $IsObject(objPaadm.PAADMAdmDocCodeDR)
	{
		Set AdmDoc=objPaadm.PAADMAdmDocCodeDR.CTPCPDesc
	}
	//Set AdmStatus=objPaadm.PAADMVisitStatus
	Set AdmStatus=..getOutStatus(aPaadm)
	Set strCost=..GetAdmCateFee(aPaadm)
	Set CountCost=+$p(strCost,"^",1)  //住院总费用
	Set DrugCost=+$p(strCost,"^",2)   //药费
	If (CountCost'=0)&&(DrugCost'=0) {                //药费比例
		Set DrugRatio=$fn((DrugCost/CountCost)*100,"",2)_"%"
	} Else {
		Set DrugRatio="00.00%"
	}
	Set:CountCost'="" CountCost=$fn(CountCost,"",2)
	Set:DrugCost'="" DrugCost=$fn(DrugCost,"",2)
	
    Set InMedicare=..GetInMedicare("",aPaadm)
	
	//就诊信息
    Set Data=Data_$lb($g(PatientID))
    Set Data=Data_$lb($g(PapmiNo))
    Set Data=Data_$lb($g(InMedicare))
    Set Data=Data_$lb($g(PatName))
    Set Data=Data_$lb($g(Sex))
    Set Data=Data_$lb($g(Birthday))
    Set Data=Data_$lb($g(Age))
    Set Data=Data_$lb($g(PersonalID))
	Set Data=Data_$lb($g(AdmitDate))
	Set Data=Data_$lb($g(AdmitTime))
	Set Data=Data_$lb($g(DisDate))
	Set Data=Data_$lb($g(DisTime))
	Set Data=Data_$lb($g(AdmLoc))
	Set Data=Data_$lb($g(AdmWard))
	Set Data=Data_$lb($g(AdmRoom))
	Set Data=Data_$lb($g(AdmBed))
	Set Data=Data_$lb($g(AdmDoc))
	Set Data=Data_$lb($g(AdmStatus))
	Set Data=Data_$lb($g(AdmDays))
	Set Data=Data_$lb($g(CountCost))
	Set Data=Data_$lb($g(DrugRatio))
	
	Quit Data
}

/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.ClinPathWaysVarianceDtl","QryVarianceDtl","2012-02-01","2012-02-10","")
Query QryVarianceDtl(argDateFrom As %String, argDateTo As %String, argCPWID As %String = "") As %Query(ROWSPEC = "IndVarDtl:%String,PatientID:%String,PapmiNo:%String,InMedicare:%String,PatName:%String,Sex:%String,Birthday:%String,Age:%String,PersonalID:%String,AdmitDate:%String,AdmitTime:%String,DisDate:%String,DisTime:%String,AdmLoc:%String,AdmWard:%String,AdmRoom:%String,AdmBed:%String,AdmDoc:%String,AdmStatus:%String,AdmDays:%String,CountCost:%String,DrugRatio:%String,CPWDesc:%String,CPWStatus:%String,CPWStepDesc:%String,CPWVarType:%String,CPWItemDesc:%String,OEItemDesc:%String,OEItemDate:%String,OEItemTime:%String,CPWVarDesc:%String")
{
}

ClassMethod QryVarianceDtlExecute(ByRef qHandle As %Binary, argDateFrom As %String, argDateTo As %String, argCPWID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set:argDateFrom["/" argDateFrom=$zdh(argDateFrom,4)
	Set:argDateFrom["-" argDateFrom=$zdh(argDateFrom,3)
	Set:argDateFrom'="" argDateFrom=+argDateFrom
	Set:argDateTo["/" argDateTo=$zdh(argDateTo,4)
	Set:argDateTo["-" argDateTo=$zdh(argDateTo,3)
	Set:argDateTo'="" argDateTo=+argDateTo
	Quit:(argDateFrom="")||(argDateTo="") $$$OK
	
	Set ArcimCategList=##Class(web.DHCCPW.MR.ClinPathWaysVariance).GetListFromConfig("OutFormArcimCateg",",")
	Set ArcimSubCatList=##Class(web.DHCCPW.MR.ClinPathWaysVariance).GetListFromConfig("OutFormArcimSubCat",",")
	
	//^PAADMi("DischDate",{PAADM_DischgDate},{PAADM_RowID})
	Set DischDateIndex=##Class(web.DHCCPW.IO.FromAdmSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引
	For DischDate=argDateFrom:1:argDateTo {
		Set Paadm=0
		For {
			Set Paadm=$o(^PAADMi(DischDateIndex,DischDate,Paadm))
			Quit:Paadm=""
			Set AdmInfo=$g(^PAADM(Paadm))
			Continue:$p(AdmInfo,"^",2)'="I"           //就诊类型过滤
			Continue:$p(AdmInfo,"^",20)="C"           //就诊状态过滤
			
			Set MRAdm=##class(web.DHCCPW.MR.PAADMSrv).GetMRAdm(Paadm)
			Continue:MRAdm=""
			Set PathWayID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm,""),-1)
			Continue:PathWayID=""
			
			//取路径信息
			Set objPathWay=##Class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
			Continue:'$IsObject(objPathWay)
			Continue:'$IsObject(objPathWay.CPWPathwayDR)
			Continue:objPathWay.CPWPathwayDR.CPWVerDate<$zdh("2011-11-03",3)
			Set CPWDesc=objPathWay.CPWPathwayDR.CPWDesc
			Set CPWStatus=objPathWay.CPWStatus
			Set CPWStatus=$s(CPWStatus["I":"入径",CPWStatus["O":"出径",CPWStatus["C":"完成",1:"")
			
			//同步实施记录
			Set flg=..AutoGenImpl(PathWayID,"")
			
			//取基本信息
			Set BaseData=..BuildBaseData(Paadm)
			Continue:BaseData=""
			
			
			Set EpStepID=""
			For {
				Set EpStepID=$o(^DHCMR("IMPL",PathWayID,"EpStep",EpStepID))
				Quit:EpStepID=""
				
				Set objEpStep=##class(web.DHCCPW.MRC.PathWEpStep).GetObjById(EpStepID)
				Continue:'$IsObject(objEpStep)
				Set CPWEpStepDesc=objEpStep.CPWSDesc
				
				Set VarDescStr=""
				Set VarID=0
				For {
					Set VarID=$o(^DHCMR("CPW",PathWayID,"VAR",VarID))
					Quit:VarID=""
					Set objVar=##class(web.DHCCPW.MR.ClinPathWaysVariance).GetObjById(PathWayID_"||"_VarID)
					Continue:'$IsObject(objVar)
					Continue:'$IsObject(objVar.CPWVEpStepDR)
					Continue:objVar.CPWVEpStepDR.%Id()'=EpStepID
					Continue:'$IsObject(objVar.CPWVReasonDR)
					Set VarDesc=objVar.CPWVReasonDR.VRDesc
					If objVar.CPWVNote'=""
					{
						Set VarDescStr=VarDescStr_VarDesc_","_objVar.CPWVNote_";"
					} Else {
						Set VarDescStr=VarDescStr_VarDesc_";"
					}
				}
				
				//1 路径外医嘱
				Set ArcimID=""
				For {
					Set ArcimID=$o(^DHCMR("IMPL",PathWayID,"EpStep",EpStepID,"OutARCIM",ArcimID))
					Quit:ArcimID=""
					
					Set (ArcimSubCatID,ArcimSubCat,ArcimCategID,ArcimCateg)=""
					Set ArcimSubCatID=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",10)
					Set:ArcimSubCatID'="" ArcimSubCat=$p($g(^ARC("IC",+ArcimSubCatID)),"^",2)
					Set:ArcimSubCatID'="" ArcimCategID=$p($g(^ARC("IC",+ArcimSubCatID)),"^",8)
					Set:ArcimCategID'="" ArcimCateg=$p($g(^OEC("ORCAT",+ArcimCategID)),"^",2)
					Continue:(ArcimCategList'="")&&(ArcimCateg'="")&&($listfind(ArcimCategList,ArcimCateg)>0)
					Continue:(ArcimSubCatList'="")&&(ArcimSubCat'="")&&($listfind(ArcimSubCatList,ArcimSubCat)>0)
					
					Set ArcimDesc=$p($g(^ARCIM(+ArcimID,$p(ArcimID,"||",2),1)),"^",2)
					Set OEORI=""
					For {
						Set OEORI=$o(^DHCMR("IMPL",PathWayID,"EpStep",EpStepID,"OutARCIM",ArcimID,OEORI))
						Quit:OEORI=""
						Set OEORIDtl=$g(^DHCMR("IMPL",PathWayID,"EpStep",EpStepID,"OutARCIM",ArcimID,OEORI))
						Set OEORIID=$list(OEORIDtl,1)
						Set OEORIDate=$list(OEORIDtl,3)
						Set:OEORIDate'="" OEORIDate=$zd(OEORIDate,3)
						Set OEORITime=$list(OEORIDtl,4)
						Set:OEORITime'="" OEORITime=$zt(OEORITime,1)
						
						Set VarDtlData=$lb(CPWDesc,CPWStatus,CPWEpStepDesc,"路径外医嘱","",ArcimDesc,OEORIDate,OEORITime,VarDescStr)
						Set Data=$lb(ind)_BaseData_VarDtlData
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
					}
				}
				
				//主表单项目检查
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
					Set ItemDesc=objItem.CPWSIDesc
					Set isItemImpl=..IsItemImpl(PathWayID,ItemRowID_"-"_EpStepID)
					If objItem.CPWSIIsMust["Y"
					{
						//2 可选项目
						Continue:isItemImpl<1
						Set VarDtlData=$lb(CPWDesc,CPWStatus,CPWEpStepDesc,"可选项目已执行",ItemDesc,"","","",VarDescStr)
					} Else {
						//3 必选项目
						Continue:isItemImpl>0
						Set VarDtlData=$lb(CPWDesc,CPWStatus,CPWEpStepDesc,"必选项目未执行",ItemDesc,"","","",VarDescStr)
					}
					
					Set Data=$lb(ind)_BaseData_VarDtlData
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
				
				//合并症表单项目检查
				Set ImplEstTime=$g(^DHCMR("IMPL",PathWayID,"EpStep",EpStepID))
				Set ComStepList=$list(ImplEstTime,8)
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
						Set ItemDesc=objItem.CPWSIDesc
						Set isItemImpl=..IsItemImpl(PathWayID,ItemRowID_"-"_EpStepID)
						If objItem.CPWSIIsMust["Y"
						{
							//2 可选项目
							Continue:isItemImpl<1
							Set VarDtlData=$lb(CPWDesc,CPWStatus,CPWEpStepDesc,"可选项目已执行",ItemDesc,"","","",VarDescStr)
						} Else {
							//3 必选项目
							Continue:isItemImpl>0
							Set VarDtlData=$lb(CPWDesc,CPWStatus,CPWEpStepDesc,"必选项目未执行",ItemDesc,"","","",VarDescStr)
						}
						
						Set Data=$lb(ind)_BaseData_VarDtlData
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
					}
				}
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryVarianceDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryVarianceDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryVarianceDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryVarianceDtlExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2012-02-24
/// Description:  自动生成临床路径实施记录
/// Table：       
/// Input：       argPathWayID:   路径ID
/// Return：      return
/// w ##class(web.DHCCPW.MR.ClinPathWaysVarianceDtl).AutoGenImpl(29)
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
	
	//检查路径外医嘱
	Set OrdID=$o(^OEORD(0,"Adm",+EpisodeID,""))
	Set OutArcimID=""
	For {
		Set OutArcimID=$o(^OEORDi(0,"ARCIM",OrdID,OutArcimID))
		Quit:OutArcimID=""
		Continue:$d(^DHCMR("IMPL",aPathWayID,"EpStep",EpStepID,"ARCIM",OutArcimID))
		Set Result=..MainToArcim(OutArcimID)
		Continue:$list(Result,1)<1
		Set ResultList=$list(Result,2)
		For indResult=1:1:$listlength(ResultList)
		{
			Set ResultDtl=$list(ResultList,indResult)
			Set ResultCode=$list(ResultDtl,1)
			Continue:ResultCode=""
			Set ^DHCMR("IMPL",aPathWayID,"EpStep",EpStepID,"OutARCIM",OutArcimID,ResultCode)=ResultDtl
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
/// w ##class(web.DHCCPW.MR.ClinPathWaysVarianceDtl).MainToArcim("1||1")
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

/// w ##Class(web.DHCCPW.MR.ClinPathWaysVarianceDtl).IsItemImpl(1,"4||2||1||1")
ClassMethod IsItemImpl(aPathWayID As %String, aItemID As %String) As %String
{
	New (aPathWayID,aItemID)
	Set return=0
	Quit:(aPathWayID="")||(aItemID="") return
	
	Set $ZT="IsItemImplErr"
	
	Set aStepID=$p(aItemID,"-",2)
	Set aItemID=$p(aItemID,"-",1)
	Set:aStepID="" aStepID=$p(aItemID,"||",1)_"||"_$p(aItemID,"||",2)_"||"_$p(aItemID,"||",3)
	
	//1 判断实时记录，查看表单项目是否执行
	Set ImplID=""
	For {
		Set ImplID=$o(^DHCMRi(0,"IMPL","IndexStepItem",aPathWayID,aItemID,ImplID))
		Quit:ImplID=""
		Set ImplRowid=aPathWayID_"||"_ImplID
		Set objImpl=##class(web.DHCCPW.MR.Implement).GetObjById(ImplRowid)
		Continue:'$IsObject(objImpl)
		Set IsActive=objImpl.CPWEActive
		Continue:IsActive'["Y"
		If $IsObject(objImpl.CPWEStepDR){
			Set ImplStepID=objImpl.CPWEStepDR.%Id()
			Continue:aStepID'=ImplStepID
		}
		Set OeoriID=objImpl.CPWEOEORIDR
		Set OeoriStatus=""
		If OeoriID'="" {
			Set OeoriStatus=$p($g(^OEORD(+OeoriID,"I",+$p(OeoriID,"||",2),1)),"^",13)
			Set OeoriStatus=$p($g(^OEC("OSTAT",+OeoriStatus)),"^",2)
		}
		Continue:OeoriStatus["停"  //医嘱状态  停止
		Set return=return+1
	}
	Quit:return>0 return
	
	//2 关联医嘱，查看表单项目是否执行
	Set objItem=##class(web.DHCCPW.MRC.PathWEpStepItem).GetObjById(aItemID)
	If $IsObject(objItem) {
		//2.1 关联医嘱检查,查看表单项目是否执行
		Set ItemArcimCnt=objItem.CPWSIARCIM.Count()
		For ItemArcimInd=1:1:ItemArcimCnt {
			Set objItemArcim=objItem.CPWSIARCIM.GetAt(ItemArcimInd)
			Continue:'$IsObject(objItemArcim)
			Set ArcimID=objItemArcim.ITMARCIMDR
			Continue:ArcimID=""   //医嘱项ID
			Set IsMain=objItemArcim.ITMIsMain
			//Continue:IsMain'["Y"  //不是主要项目，不检查
			//w "ItemID="_aItemID_",ArcimID="_ArcimID,!
			If $l(ArcimID,"||")=2 {
				Continue:$g(^ARCIM(+ArcimID,$p(ArcimID,"||",2),1))=""  //无此医嘱
				//w "ArcimID="_ArcimID,!
				Continue:'$d(^DHCMR("IMPL",aPathWayID,"EpStep",aStepID,"ARCIM",ArcimID,aItemID))
				Set return=return+1
			}Else{
				//^ARCOS(ARCOSRowid,"DATE",ARCOSDateRowid,"ITM",item)
				Set ARCOSRowid=ArcimID
				Continue:$g(^ARCOS(+ARCOSRowid))=""  //无此医嘱套
				//取医嘱套的日期节点
				Set ARCOSDateID=0
				For {
					Set ARCOSDateID=$o(^ARCOS(ARCOSRowid,"DATE",ARCOSDateID))
					Quit:ARCOSDateID=""
					//判断医嘱套下的医嘱项
					Set ARCOSItemID=0
					For {
						Set ARCOSItemID=$o(^ARCOS(ARCOSRowid,"DATE",ARCOSDateID,"ITM",ARCOSItemID))
						Quit:ARCOSItemID=""
						Set ARCOSARCIMID=$p($g(^ARCOS(ARCOSRowid,"DATE",ARCOSDateID,"ITM",ARCOSItemID)),"^",1)
						Continue:$g(^ARCIM(+ARCOSARCIMID,$p(ARCOSARCIMID,"||",2),1))=""  //无此医嘱
						//w "ARCOSARCIMID="_ARCOSARCIMID,!
						Continue:'$d(^DHCMR("IMPL",aPathWayID,"EpStep",aStepID,"ARCIM",ARCOSARCIMID,aItemID))
						Set return=return+1
					}
					//医嘱套下的医嘱子套
					Set ARCOSOSID=0
					For {
						Set ARCOSOSID=$o(^ARCOS(ARCOSRowid,"DATE",ARCOSDateID,"OS",ARCOSOSID))
						Quit:ARCOSOSID=""
						Set ARCOSSubID=$p($g(^ARCOS(ARCOSRowid,"DATE",ARCOSDateID,"OS",ARCOSOSID)),"^",1)
						//取医嘱子套的日期节点
						Set ARCOSSubDateID=0
						For {
							Set ARCOSSubDateID=$o(^ARCOS(ARCOSSubID,"DATE",ARCOSSubDateID))
							Quit:ARCOSSubDateID=""
							//取医嘱子套的医嘱项
							Set ARCOSSubItemID=0
							For {
								Set ARCOSSubItemID=$o(^ARCOS(ARCOSSubID,"DATE",ARCOSSubDateID,"ITM",ARCOSSubItemID))
								Quit:ARCOSSubItemID=""
								Set ARCOSSubARCIMID=$p($g(^ARCOS(ARCOSSubID,"DATE",ARCOSSubDateID,"ITM",ARCOSSubItemID)),"^",1)
								Continue:$g(^ARCIM(+ARCOSSubARCIMID,$p(ARCOSSubARCIMID,"||",2),1))=""  //无此医嘱
								//w "ARCOSSubARCIMID="_ARCOSSubARCIMID,!
								Continue:'$d(^DHCMR("IMPL",aPathWayID,"EpStep",aStepID,"ARCIM",ARCOSSubARCIMID,aItemID))
								Set return=return+1
							}
						}
					}
				}
			}
		}
	}
	
	Quit return
	
IsItemImplErr
	Quit 0
}

/// ##class(web.DHCCPW.MR.SysBaseSrv).GetInMedicare("",Paadm)
ClassMethod GetInMedicare(aPatientID As %String, aEpisodeID As %String)
{
	New (aPatientID,aEpisodeID)
	Set return=""
	Set $ZT="GetInMedicareErr"
	If aEpisodeID'=""
	{
		Set PatientID=$p($g(^PAADM(+aEpisodeID)),"^",1)
		Set EpisodeID=aEpisodeID
	} Else {
		Set PatientID=aPatientID
		Set EpisodeID=""
	}
	
	Set GetInMedicareField="GovernCardNo"
	If GetInMedicareField="GovernCardNo"
	{
		Set return=$p($g(^PAPER(PatientID,"PER",4)),"^",4)
	} Else {
		Set return=$p($g(^PAPER(PatientID,"PAT",1)),"^",22)
	}
	
	Quit return
GetInMedicareErr
	Quit ""
}

ClassMethod GetAdmCateFee(argEpisodeID As %String) As %String
{
	New (argEpisodeID)
	Set return=""
	Quit:argEpisodeID="" return
	
	Set $ZT="GetAdmCateFeeErr"
	
	//取东华HIS费用数据
	Set strCateFee=##Class(web.UDHCJFBaseCommon).GetAdmCateFee(argEpisodeID)
	
	Set CountCost=0,DrugCost=0
	For Index=1:1:$l(strCateFee,"&")
	{
		Set Fee=$p(strCateFee,"&",Index)
		Set CountCost=CountCost+$p(Fee,"^",2)
		Set:Fee["药" DrugCost=DrugCost+$p(Fee,"^",2)
	}
	
	Set return=CountCost_"^"_DrugCost
	Quit return
	
GetAdmCateFeeErr
	Quit return
}

/// 出院情况(治愈/好转/死亡)
ClassMethod getOutStatus(argPaadm As %String) As %String
{
	New (argPaadm)
	Set return=""
	Quit:argPaadm="" return
	
	Set MRAdm=##class(web.DHCCPW.MR.PAADMSrv).GetMRAdm(argPaadm)
	Quit:MRAdm="" return
	
	Set DischCondID=$p($g(^MR(+MRAdm,"PRO",1)),"^",10)
	Set DischCondDesc=$p($g(^PAC("DISCON",+DischCondID)),"^",2)
	Set:DischCondDesc["痊愈" DischCondDesc="治愈"
	Set:DischCondDesc["治愈" DischCondDesc="治愈"
	Set:DischCondDesc["好转" DischCondDesc="好转"
	Set:DischCondDesc["已故" DischCondDesc="死亡"
	Set:DischCondDesc["死亡" DischCondDesc="死亡"
	Set return=DischCondDesc
	
	Quit return
}

/// 获取Http服务器信息
/// Trakcare的服务器，不是Medtrak的
/// 	w ##Class(web.DHCCPW.MR.ClinPathWaysVarianceDtl).GetServerInfo()
ClassMethod GetServerInfo() As %String
{
	n
    Set CurrentNS=$ZNSPACE
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    //Set Server=Config.WebServer
    Set Server=$p(Config.LayoutManager,":",2)
    Set Path=Config.PathToReports
    Set LayOutManager=Config.LayoutManager
    Set WebServerAppURL = "http://"_Config.WebServer_Config.PathToApp //Modified By LiYang 2008-10-08 获取CSP服务器的IP地址以及程序路径
   // Set WebServerAppURL = "http://127.0.0.1"_Config.PathToApp //Modified By LiYang 2008-10-08 获取CSP服务器的IP地址以及程序路径
    d Config.%Close()
    s s=CurrentNS_$c(1)_MEDDATA_$c(1)_LABDATA_$c(1)_Server_$c(1)_Path_$c(1)_LayOutManager_$C(1)_WebServerAppURL
	q s
}

/// w ##Class(web.DHCCPW.MR.ClinPathWaysVarianceDtl).QryVarianceDtlToPrint("fillxlSheet","2012-02-01^2012-02-01^")
ClassMethod QryVarianceDtlToPrint(itmjs As %String, strArguments As %String) As %String
{
	n (itmjs,strArguments)
	s Count=0
	
	s DateFrom=$p(strArguments,"^",1)
	s DateTo=$p(strArguments,"^",2)
	s CPWID=$p(strArguments,"^",3)

	s ds = ##class(%Library.ResultSet).%New("web.DHCCPW.MR.ClinPathWaysVarianceDtl:QryVarianceDtl")
	d ds.Execute(DateFrom,DateTo,CPWID)
	s StartRow=2
	while(ds.Next())
	{
		s IndVarDtl=ds.Data("IndVarDtl")    //序号
		s PapmiNo=ds.Data("PapmiNo")        //登记号
		s InMedicare=ds.Data("InMedicare")        //病案号
		s PatName=ds.Data("PatName")        //姓名
		s Sex=ds.Data("Sex")        //性别
		s Age=ds.Data("Age")        //年龄
		s CPWDesc=ds.Data("CPWDesc")        //路径名称
		s CPWStatus=ds.Data("CPWStatus")        //路径状态
		s CPWStepDesc=ds.Data("CPWStepDesc")        //步骤名称
		s CPWVarType=ds.Data("CPWVarType")        //变异类型
		s CPWItemDesc=ds.Data("CPWItemDesc")        //路径项目
		s OEItemDesc=ds.Data("OEItemDesc")        //医嘱名称
		s OEItemDate=ds.Data("OEItemDate")        //医嘱日期
		s OEItemTime=ds.Data("OEItemTime")        //医嘱时间
		s CPWVarDesc=ds.Data("CPWVarDesc")        //变异原因
		s AdmitDate=ds.Data("AdmitDate")        //入院日期
		s AdmitTime=ds.Data("AdmitTime")        //入院时间
		s DisDate=ds.Data("DisDate")        //出院日期
		s DisTime=ds.Data("DisTime")        //出院时间
		s AdmDays=ds.Data("AdmDays")        //住院天数
		s CountCost=ds.Data("CountCost")        //住院费用
		s DrugRatio=ds.Data("DrugRatio")        //药费比例
		s AdmStatus=ds.Data("AdmStatus")        //出院状态
		s AdmLoc=ds.Data("AdmLoc")        //科室
		s AdmWard=ds.Data("AdmWard")        //病区
		s AdmDoc=ds.Data("AdmDoc")        //医生
		
		s valCells=IndVarDtl_$c(1)_PapmiNo_$c(1)_InMedicare_$c(1)_PatName_$c(1)_Sex
		s valCells=valCells_$c(1)_Age_$c(1)_CPWDesc_$c(1)_CPWStatus_$c(1)_CPWStepDesc_$c(1)_CPWVarType
		s valCells=valCells_$c(1)_CPWItemDesc_$c(1)_OEItemDesc_$c(1)_OEItemDate_$c(1)_OEItemTime_$c(1)_CPWVarDesc
		s valCells=valCells_$c(1)_AdmitDate_$c(1)_AdmitTime_$c(1)_DisDate_$c(1)_DisTime_$c(1)_AdmDays
		s valCells=valCells_$c(1)_CountCost_$c(1)_DrugRatio_$c(1)_AdmStatus_$c(1)_AdmLoc_$c(1)_AdmWard
		s valCells=valCells_$c(1)_AdmDoc
		
		s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',"_StartRow_",1);"
		&javascript<#(retval)#>
		
		s Count=Count+1
		s StartRow=StartRow+1
	}
	
	d ds.Close()
	
	q Count
}

}
