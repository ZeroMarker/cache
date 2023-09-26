/// 名称: web.DHCCPW.MRC.FormExam
/// 描述: 实施路径表单展现
/// 编写者：zhufei
/// 编写日期: 2011-07-07
Class web.DHCCPW.MRC.FormExam Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2012-08-03
/// Description:  签名时检查变异情况
/// Input：       argPathWayID  : 出入径ID
///               argEpStepID   : 步骤ID
///               argUserType   : 类型(D医生,N护士)
/// Return：      返回检查结果  return>0:有变异,return=0 无变异
/// w ##Class(web.DHCCPW.MRC.FormExam).ChkVarItemList("23","78||3||1","D")
ClassMethod ChkVarItemList(argPathWayID As %String, argEpStepID As %String, argUserType As %String) As %String
{
	New (argPathWayID,argEpStepID,argUserType)
	Set return=0,Count=0
	Quit:(argPathWayID="")||(argEpStepID="")||(argUserType="") return
	
	Set rs=##Class(%ResultSet).%New("web.DHCCPW.MRC.FormExam:QryVarItemList")
	Do rs.Execute(argPathWayID,argEpStepID,argUserType)
	While (rs.Next()){
		Set Count=Count+1
	}
	Do rs.Close()
	
	Set return=Count
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-08-03
/// Description:  查询变异内容列表
/// Input：       PathWayID,EpStepID,UserType
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MRC.FormExam","QryVarItemList","23","78||3||1","D")
Query QryVarItemList(argPathWayID As %String, argEpStepID As %String, argUserType As %String) As %Query(ROWSPEC = "VarItemInd:%String,VarItemCode:%String,VarItemDesc:%String,VarItemGroup:%String")
{
}

ClassMethod QryVarItemListExecute(ByRef qHandle As %Binary, argPathWayID As %String, argEpStepID As %String, argUserType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Quit:argUserType="" $$$OK
	
	Set ZIndex=$zn,JIndex=$j,NIndex="QryVarItemList"
	Kill ^TMP(ZIndex,JIndex,NIndex)
	
	//1 步骤时间调整
	Set IsCheck=##class(web.DHCCPW.MRC.BaseConfig).GetValueByCode("CheckStepTimeAdjustToSign")
	If (IsCheck'="N")&&(argUserType="D") {
		Set flg=..chkStepTimeAdjust(ZIndex,JIndex,NIndex,argPathWayID,argEpStepID,argUserType)
		//W "CheckStepTimeAdjustToSign="_flg,!
	}
	//2 路径外医嘱
	Set IsCheck=##class(web.DHCCPW.MRC.BaseConfig).GetValueByCode("CheckOutOEItemToSign")
	If (IsCheck="Y")||(IsCheck[argUserType) {
		Set flg=..chkFormOutOeOrdItem(ZIndex,JIndex,NIndex,argPathWayID,argEpStepID,argUserType)
		//W "CheckOutOEItemToSign="_flg,!
	}
	//3 必选项目未执行
	Set IsCheck=##class(web.DHCCPW.MRC.BaseConfig).GetValueByCode("CheckFormRequiredItemToSign")
	If (IsCheck'="N")||(IsCheck[argUserType) {
		Set flg=..chkFormRequiredItem(ZIndex,JIndex,NIndex,argPathWayID,argEpStepID,argUserType)
		//W "CheckFormRequiredItemToSign="_flg,!
	}
	//4 可选项目已执行
	Set IsCheck=##class(web.DHCCPW.MRC.BaseConfig).GetValueByCode("CheckFormOptionalItemToSign")
	If (IsCheck="Y")||(IsCheck[argUserType) {
		Set flg=..chkFormOptionalItem(ZIndex,JIndex,NIndex,argPathWayID,argEpStepID,argUserType)
		//W "CheckFormOptionalItemToSign="_flg,!
	}
	
	Set ItemInd=0
	For {
		Set ItemInd=$o(^TMP(ZIndex,JIndex,NIndex,ItemInd))
		Quit:ItemInd=""
		Set Data=$g(^TMP(ZIndex,JIndex,NIndex,ItemInd))
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^TMP(ZIndex,JIndex,NIndex)
	
	Quit $$$OK
}

ClassMethod QryVarItemListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryVarItemListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryVarItemListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryVarItemListExecute ]
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
/// CreatDate：   2012-08-03
/// Description:  查询步骤时间调整
/// Input：       argPathWayID  : 出入径ID
///               argEpStepID   : 步骤ID
///               argUserType   : 类型(D医生,N护士)
/// Return：      返回检查结果  return>0:有变异,return=0 无变异
/// w ##Class(web.DHCCPW.MRC.FormExam).chkStepTimeAdjust("15","54||1||1","")
ClassMethod chkStepTimeAdjust(ZIndex As %String, JIndex As %String, NIndex As %String, argPathWayID As %String, argEpStepID As %String, argUserType As %String) As %String
{
	New (ZIndex,JIndex,NIndex,argPathWayID,argEpStepID,argUserType)
	Set return=0
	Quit:(argPathWayID="")||(argEpStepID="")||(argUserType="") return
	
	//取步骤时间段内对应医嘱(医嘱开始时间)
	Set CurrStepTime=""
	Set EstTimeLS=##class(web.DHCCPW.MR.ClinPathWaysEstimate).GetObjByPathWayID(argPathWayID)
	If EstTimeLS'="" {
		Set EstTimesCnt=$listlength(EstTimeLS)
		For EstTimesInd=1:1:EstTimesCnt {
			Set objEstTime=$list(EstTimeLS,EstTimesInd)
			Set EstEpStepDR=$list(objEstTime,1)
			Continue:argEpStepID'=EstEpStepDR
			Set CurrStepTime=$list(objEstTime,7)
		}
	}
	Quit:CurrStepTime="" return
	
	Set (Day,Hour,Min)=0
	Set zCurrStepTime=CurrStepTime
	If zCurrStepTime["天" {
		Set Day=+zCurrStepTime
		set zCurrStepTime=$p(zCurrStepTime,"天",2)
	}
	If zCurrStepTime["小时" {
		Set Hour=+zCurrStepTime
		set zCurrStepTime=$p(zCurrStepTime,"小时",2)
	}
	Set Min=+zCurrStepTime
	
	Set objEpStep=##class(web.DHCCPW.MRC.PathWEpStep).GetObjById(argEpStepID)
	Quit:'$IsObject(objEpStep) return
	Set StepTimeUnit=objEpStep.CPWSUnit
	Set EpStepTime=objEpStep.CPWSDay
	Set StepDesc=objEpStep.CPWSDesc
	Set EpStepMinTime=+$p(EpStepTime,"-",1)
	Set:EpStepMinTime<1 EpStepMinTime=1
	Set EpStepMaxTime=+$p(EpStepTime,"-",2)
	If EpStepMaxTime<EpStepMinTime {
		Set EpStepMaxTime=EpStepMinTime
	}
	Set Desc="",TimeAdjust=""
	If StepTimeUnit="H" {
		Set Hour=(Day*24)+Hour
		If Hour<EpStepMinTime {
			Set TimeAdjust="Min"
			Set Desc="步骤时间缩短"
		} ElseIf Hour>EpStepMaxTime {
			Set TimeAdjust="Max"
			Set Desc="步骤时间延长"
		} Else {
			//正常
		}
	} ElseIf StepTimeUnit="M" {
		Set Min=((Day*24)+Hour)*60+Min
		If Min<EpStepMinTime {
			Set TimeAdjust="Min"
			Set Desc="步骤时间缩短"
		} ElseIf Min>EpStepMaxTime {
			Set TimeAdjust="Max"
			Set Desc="步骤时间延长"
		} Else {
			//正常
		}
	} Else {
		Set:Hour>=2 Day=Day+1
		If Day<EpStepMinTime {
			Set TimeAdjust="Min"
			Set Desc="步骤时间缩短"
		} ElseIf Day>EpStepMaxTime {
			Set TimeAdjust="Max"
			Set Desc="步骤时间延长"
		} Else {
			//正常
		}
	}
	Quit:Desc="" return
	
	//判断签名时未填写变异
	Set ChildSub="",IsHaveVarRst="N"
	For {
		Set ChildSub=$o(^DHCMR("CPW",argPathWayID,"VAR",ChildSub))
		Quit:ChildSub=""
		Quit:IsHaveVarRst="Y"
		Set CPWVID=argPathWayID_"||"_ChildSub
		Set objVariance=##class(web.DHCCPW.MR.ClinPathWaysVariance).GetObjById(CPWVID)
		If $IsObject(objVariance){
			Set UpdoFlag=objVariance.CPWVUpdoFlag
			Continue:UpdoFlag="Y"
			Set ExtraValues=objVariance.CPWVExtraValues
			Continue:(ExtraValues'[("STEPTIME:"_TimeAdjust_"-"_argEpStepID))
			Set IsHaveVarRst="Y"
		}
	}
	Quit:IsHaveVarRst="Y" return
	
	Set num=$i(^TMP(ZIndex,JIndex,NIndex))
	Set Code="STEPTIME:"_TimeAdjust_"-"_argEpStepID
	Set Desc=Desc_"("_StepDesc_")"
	Set Type="步骤时间调整"
	Set ^TMP(ZIndex,JIndex,NIndex,num)=$lb(num,Code,Desc,Type)
	
	Set return=1
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-08-03
/// Description:  查询路径外医嘱
/// Input：       argPathWayID  : 出入径ID
///               argEpStepID   : 步骤ID
///               argUserType   : 类型(D医生,N护士)
/// Return：      返回检查结果  return>0:有变异,return=0 无变异
/// w ##Class(web.DHCCPW.MRC.FormExam).chkFormOutOeOrdItem("15","54||1||1","")
ClassMethod chkFormOutOeOrdItem(ZIndex As %String, JIndex As %String, NIndex As %String, argPathWayID As %String, argEpStepID As %String, argUserType As %String) As %String
{
	New (ZIndex,JIndex,NIndex,argPathWayID,argEpStepID,argUserType)
	Set return=0,num=0
	Quit:(argPathWayID="")||(argEpStepID="")||(argUserType="") return
	
	Set CPWID=$p(argEpStepID,"||",1)
	Set EpID=$p(argEpStepID,"||",2)
	Set StepID=$p(argEpStepID,"||",3)
	Set CompStepList=""
	Quit:(argPathWayID="")||(argEpStepID="") return
	Quit:(CPWID="")||(EpID="")||(StepID="") return
	
	//Add by zf 20120217
	//自动同步关联医嘱和关联项目数据
	Set flg=##class(web.DHCCPW.MR.ImplementAutoGen).AutoGenImpl(argPathWayID,argEpStepID)
	
	//如果没有当前步骤对应的同步记录,退出
	Set objEstTime=$g(^DHCMR("IMPL",argPathWayID,"EpStep",argEpStepID))
	Quit:objEstTime="" return
	Set StartDate=$list(objEstTime,3)
	Set StartTime=$list(objEstTime,4)
	Set EndDate=$list(objEstTime,5)
	Set EndTime=$list(objEstTime,6)
	
	Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(argPathWayID)
	Quit:'$IsObject(objPathWay) return
	Set MRAdm=objPathWay.CPWMRADMDR
	Set EpisodeID=##class(web.DHCCPW.MR.PAADMSrv).GetEpisodeID(MRAdm)
	
	Set ArcimCategList=##Class(web.DHCCPW.MR.ClinPathWaysVariance).GetListFromConfig("OutFormArcimCateg",",")
	Set ArcimSubCatList=##Class(web.DHCCPW.MR.ClinPathWaysVariance).GetListFromConfig("OutFormArcimSubCat",",")
	
	Set StDtTmIndex=##class(web.DHCCPW.MRC.BaseConfig).GetValueByCode("OEOrdItemStDtTmIndex")
	If StDtTmIndex="YYGL" {  //航天中心医院
		
		//获取HIS系统的住院号
		Set ZYH=##Class(web.DHCCPW.MR.InterfaceToPrj).ChangeAdmToIPNo(EpisodeID)
		Quit:ZYH="" return
		
		//查询路径外医嘱
		Set YZDM=""
		For {
			Set YZDM=$o(^DHCMR("OEOrdExec",ZYH,YZDM))
			Quit:YZDM=""
			
			//医嘱项代码转换为医嘱项ID
			//update by zf 20120628
			Set ArcimID="",ArcSub="",ArcVer=""
			Set ArcSub=$o(^ARCIM(0,"Code",YZDM,""))
			Set:ArcSub'="" ArcVer=$o(^ARCIM(0,"Code",YZDM,ArcSub,""))
			If (ArcSub'="")&&(ArcVer'="") {
				Set ArcimID=ArcSub_"||"_ArcVer
			}
			
			If ArcimID'="" {
				//有对应的实施记录
				Continue:$d(^DHCMR("IMPL",argPathWayID,"EpStep",argEpStepID,"ARCIM","ArcimID:"_ArcimID))
				Continue:$d(^DHCMR("IMPL",argPathWayID,"EpStep",argEpStepID,"ARCIM",ArcimID))
				
				//判断录医嘱时未填写变异
				Set ChildSub="",IsHaveVarRst="N"
				For {
					Set ChildSub=$o(^DHCMR("CPW",argPathWayID,"VAR",ChildSub))
					Quit:ChildSub=""
					Quit:IsHaveVarRst="Y"
					Set CPWVID=argPathWayID_"||"_ChildSub
					Set objVariance=##class(web.DHCCPW.MR.ClinPathWaysVariance).GetObjById(CPWVID)
					If $IsObject(objVariance){
						Set UpdoFlag=objVariance.CPWVUpdoFlag
						Continue:UpdoFlag="Y"
						Set ExtraValues=objVariance.CPWVExtraValues
						Continue:ExtraValues'[("ARCIM:"_ArcimID_"-"_argEpStepID)
						Set IsHaveVarRst="Y"
					}
				}
				Continue:IsHaveVarRst="Y" //填写过变异记录不再显示
			}
			
			Set YZXH=0
			For {
				Set YZXH=$o(^DHCMR("OEOrdExec",ZYH,YZDM,YZXH))
				Quit:YZXH=""
				Set tmpData=$g(^DHCMR("OEOrdExec",ZYH,YZDM,YZXH,"OEOrdItem"))
				Continue:tmpData=""
				Set OEItemID=YZXH
				Set ArcimDesc=$listget(tmpData,6)         //医嘱名称
				Set OEItemDateTime=$listget(tmpData,12)   //开始日期时间
				Set OEItemDate=$p(OEItemDateTime," ",1)
				Set OEItemTime=$p(OEItemDateTime," ",2)
				Set OEItemDoc=$listget(tmpData,16)        //YSXM 医生姓名
				
				Set IsOutOEItem="N"  //路径外医嘱标记
				
				Set ExecType=$g(^DHCMR("OEOrdExec",ZYH,YZDM,YZXH,"ExecType"))
				If ExecType=1 {  //持续医嘱
					Set xStartDate=$o(^DHCMR("OEOrdExec",ZYH,YZDM,YZXH,"ExStDate",0))
					Continue:xStartDate=""
					Set xStartTime=$o(^DHCMR("OEOrdExec",ZYH,YZDM,YZXH,"ExStDate",xStartDate,0))
					Set xEndDate=$o(^DHCMR("OEOrdExec",ZYH,YZDM,YZXH,"ExStDate",xStartDate))
					If xEndDate="" {
						Set xEndDate=+$h,xEndTime=$p($h,",",2)
					} Else {
						Set xEndTime=$o(^DHCMR("OEOrdExec",ZYH,YZDM,YZXH,"ExStDate",xEndDate,0))
					}
					
					Continue:xEndDate<StartDate
					Continue:(xEndDate=StartDate)&&(xEndTime<StartTime)
					Continue:xStartDate>EndDate
					Continue:(xStartDate=EndDate)&&(xStartTime>EndTime)
					
					Set IsOutOEItem="Y"  //路径外医嘱标记
					
					Set OEExecID=OEItemID_"||"_xStartDate_"||"_xStartTime
					//w OEExecID,!
					//判断签名时未填写变异
					Set ChildSub="",IsHaveVarRst="N"
					For {
						Set ChildSub=$o(^DHCMR("CPW",argPathWayID,"VAR",ChildSub))
						Quit:ChildSub=""
						Quit:IsHaveVarRst="Y"
						Set CPWVID=argPathWayID_"||"_ChildSub
						Set objVariance=##class(web.DHCCPW.MR.ClinPathWaysVariance).GetObjById(CPWVID)
						If $IsObject(objVariance){
							Set UpdoFlag=objVariance.CPWVUpdoFlag
							Continue:UpdoFlag="Y"
							Set ExtraValues=objVariance.CPWVExtraValues
							Continue:ExtraValues'[("OEITEM:"_OEExecID_"-"_argEpStepID)
							Set IsHaveVarRst="Y"
						}
					}
					Continue:IsHaveVarRst="Y" //填写过变异记录不再显示
					
					Set num=$i(^TMP(ZIndex,JIndex,NIndex))
					Set Code="OEITEM:"_OEExecID_"-"_argEpStepID
					Set Desc=ArcimDesc_"("_OEItemDoc_"  "_$zd(xStartDate,3)_" "_$zt(xStartTime,2)_")"
					Set Type="表单外医嘱"
					Set ^TMP(ZIndex,JIndex,NIndex,num)=$lb(num,Code,Desc,Type)
				} Else {  //非持续医嘱
					Set xDate=StartDate-1
					For {
						Set xDate=$o(^DHCMR("OEOrdExec",ZYH,YZDM,YZXH,"ExStDate",xDate))
						Quit:xDate=""
						//Quit:IsOutOEItem="Y"
						Quit:xDate>EndDate
						
						Set xTime=$s(xDate=StartDate:StartTime,1:0)
						For {
							Set xTime=$o(^DHCMR("OEOrdExec",ZYH,YZDM,YZXH,"ExStDate",xDate,xTime))
							Quit:xTime=""
							//Quit:IsOutOEItem="Y"
							Quit:(xDate=EndDate)&&(xTime>EndTime)
							
							Set IsOutOEItem="Y"  //路径外医嘱标记
							
							Set OEExecID=OEItemID_"||"_xDate_"||"_xTime
							//w OEExecID,!
							//判断签名时未填写变异
							Set ChildSub="",IsHaveVarRst="N"
							For {
								Set ChildSub=$o(^DHCMR("CPW",argPathWayID,"VAR",ChildSub))
								Quit:ChildSub=""
								Quit:IsHaveVarRst="Y"
								Set CPWVID=argPathWayID_"||"_ChildSub
								Set objVariance=##class(web.DHCCPW.MR.ClinPathWaysVariance).GetObjById(CPWVID)
								If $IsObject(objVariance){
									Set UpdoFlag=objVariance.CPWVUpdoFlag
									Continue:UpdoFlag="Y"
									Set ExtraValues=objVariance.CPWVExtraValues
									Continue:ExtraValues'[("OEITEM:"_OEExecID_"-"_argEpStepID)
									Set IsHaveVarRst="Y"
								}
							}
							Continue:IsHaveVarRst="Y" //填写过变异记录不再显示
							
							Set num=$i(^TMP(ZIndex,JIndex,NIndex))
							Set Code="OEITEM:"_OEExecID_"-"_argEpStepID
							Set Desc=ArcimDesc_"("_OEItemDoc_"  "_$zd(xDate,3)_" "_$zt(xTime,2)_")"
							Set Type="表单外医嘱"
							Set ^TMP(ZIndex,JIndex,NIndex,num)=$lb(num,Code,Desc,Type)
						}
					}
				}
			}
		}
	} ElseIf StDtTmIndex="StDtTmNew" {  //新版本医嘱,医嘱无效通过OE_OrdItem表状态和OE_OrdExec状态判断
		Set OrdID=$o(^OEORD(0,"Adm",EpisodeID,""))
		Set ArcimID=""
		For {
			Set ArcimID=$o(^OEORDi(0,"ARCIM",OrdID,ArcimID))
			Quit:ArcimID=""
			
			Set ItemSubCatDR=$P($g(^ARCIM($P(ArcimID,"||",1),$P(ArcimID,"||",2),1)),"^",10)
			Set ItemSubCatDesc=$p(^ARC("IC",ItemSubCatDR),"^",2)
			Continue:(ArcimSubCatList'="")&&($listfind(ArcimSubCatList,ItemSubCatDesc)>0)  //医嘱子类
			Set OrdCatDR=$p(^ARC("IC",ItemSubCatDR),"^",8)
			Set OrdCatDesc=$p(^OEC("ORCAT",OrdCatDR),"^",2)
			Continue:(ArcimCategList'="")&&($listfind(ArcimCategList,OrdCatDesc)>0)       //医嘱大类
			
			//有对应的实施记录
			Continue:$d(^DHCMR("IMPL",argPathWayID,"EpStep",argEpStepID,"ARCIM","ArcimID:"_ArcimID))
			Continue:$d(^DHCMR("IMPL",argPathWayID,"EpStep",argEpStepID,"ARCIM",ArcimID))
			
			Set ArcimDesc=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",2)      //add by wuqk 2012-02-24
			
			//判断录医嘱时未填写变异
			Set ChildSub="",IsHaveVarRst="N"
			For {
				Set ChildSub=$o(^DHCMR("CPW",argPathWayID,"VAR",ChildSub))
				Quit:ChildSub=""
				Quit:IsHaveVarRst="Y"
				Set CPWVID=argPathWayID_"||"_ChildSub
				Set objVariance=##class(web.DHCCPW.MR.ClinPathWaysVariance).GetObjById(CPWVID)
				If $IsObject(objVariance){
					Set UpdoFlag=objVariance.CPWVUpdoFlag
					Continue:UpdoFlag="Y"
					Set ExtraValues=objVariance.CPWVExtraValues
					Continue:ExtraValues'[("ARCIM:"_ArcimID_"-"_argEpStepID)
					Set IsHaveVarRst="Y"
				}
			}
			Continue:IsHaveVarRst="Y" //填写过变异记录不再显示
			
			//Set ^DHCMR("IMPL",aPathWayID,"EpStep",EpStepID,"ARCIM",lnkArcimID,ItemRowID,ResultCode)
			Set xOEItemID=""
			For {
				Set xOEItemID=$o(^DHCMR("OEOrdExec",EpisodeID,ArcimID,xOEItemID))
				Quit:xOEItemID=""
				
				Set OeoriStatus=""
				Set OeoriStatusID=$p($g(^OEORD(+xOEItemID,"I",$p(xOEItemID,"||",2),1)),"^",13)
				Set:OeoriStatusID'="" OeoriStatus=$p($g(^OEC("OSTAT",OeoriStatusID)),"^",1)
				Continue:OeoriStatus=""
				Continue:OeoriStatus["C"  //医嘱状态  撤销
				Continue:OeoriStatus["U"  //医嘱状态  作废
				Continue:OeoriStatus["I"  //医嘱状态  未审核
				
				//取持续医嘱的停止时间,未停取当前时间
				Set OEXDate=$p($g(^OEORD(+xOEItemID,"I",$p(xOEItemID,"||",2),3)),"^",34)
				Set OEXTime=+$p($g(^OEORD(+xOEItemID,"I",$p(xOEItemID,"||",2),2)),"^",15)
				Set:OEXDate="" OEXDate=+$h,OEXTime=$p($h,",",2)
				
				Set OEItemInfo=$g(^OEORD(+xOEItemID,"I",$p(xOEItemID,"||",2),1))
				Set OEItemDate=$p(OEItemInfo,"^",9)
				Set:OEItemDate'="" OEItemDate=$zd(OEItemDate,3)
				Set OEItemTime=$p(OEItemInfo,"^",10)
				Set:OEItemTime'="" OEItemTime=$zt(OEItemTime,2)
				Set OEItemDoc=$p(OEItemInfo,"^",11)
				If OEItemDoc'="" {
					Set OEDocType=$p($g(^CTPCP(+OEItemDoc,1)),"^",4)
					Set:OEDocType'="" OEDocType=$p($g(^CT("CPT",OEDocType)),"^",4)
					Continue:OEDocType'[argUserType
					Set OEItemDoc=$p($g(^CTPCP(+OEItemDoc,1)),"^",2)
				}
				
				Set ExecType=$g(^DHCMR("OEOrdExec",EpisodeID,ArcimID,xOEItemID,"ExecType"))
				
				Set xDate=StartDate-1
				For {
					Set xDate=$o(^DHCMR("OEOrdExec",EpisodeID,ArcimID,xOEItemID,"ExStDate",xDate))
					Quit:xDate=""
					Quit:xDate>EndDate
					
					If ExecType=1 {  //持续医嘱
						Set xTime=0
					} Else {  //非持续医嘱
						Set xTime=$s(xDate=StartDate:StartTime,1:0)
					}
					Set xTime=xTime-1
					For {
						Set xTime=$o(^DHCMR("OEOrdExec",EpisodeID,ArcimID,xOEItemID,"ExStDate",xDate,xTime))
						Quit:xTime=""
						Quit:(xDate=EndDate)&&(xTime>EndTime)
						
						Set OEExecID=$o(^DHCMR("OEOrdExec",EpisodeID,ArcimID,xOEItemID,"ExStDate",xDate,xTime,""))
						Continue:OEExecID=""
						
						Set OeAdmStatus=""
						If $p(OEExecID,"||",3)'=""  //存在执行记录
						{
							Set OeAdmStatusID=$p($g(^OEORD(+OEExecID,"I",$p(OEExecID,"||",2),"X",$p(OEExecID,"||",3))),"^",16)
							Set:OeAdmStatusID'="" OeAdmStatus=$p($g(^OEC("STAT",OeAdmStatusID)),"^",1)
							Continue:OeAdmStatus="D"  //医嘱执行状态  停止执行
							Continue:OeAdmStatus="C"  //医嘱执行状态  撤销执行
							Continue:OeAdmStatus="R"  //医嘱执行状态  拒绝执行
						}
						//Continue:OeAdmStatus=""
						
						If ExecType=1 {  //持续医嘱
							//取当前执行记录的停止日期和时间
							Set OEExecXDate=xDate
							If OEXDate>xDate {
								Set OEExecXTime=$zth("23:59:59",1)
							} ElseIf OEXDate=xDate {
								Set OEExecXTime=xTime
							} Else {    //停止日期小于执行记录日期,执行记录无效
								Continue
							}
							//停止时间小于开始时间,退出
							Continue:OEExecXDate<StartDate
							Continue:(OEExecXDate=StartDate)&&(OEExecXTime<StartTime)
						} Else {
							Continue:xDate>OEXDate
							Continue:(xDate=OEXDate)&&(xTime>OEXTime)
						}
						
						Set IsOutOEItem="Y"  //路径外医嘱标记
						
						//判断签名时未填写变异
						Set ChildSub="",IsHaveVarRst="N"
						For {
							Set ChildSub=$o(^DHCMR("CPW",argPathWayID,"VAR",ChildSub))
							Quit:ChildSub=""
							Quit:IsHaveVarRst="Y"
							Set CPWVID=argPathWayID_"||"_ChildSub
							Set objVariance=##class(web.DHCCPW.MR.ClinPathWaysVariance).GetObjById(CPWVID)
							If $IsObject(objVariance){
								Set UpdoFlag=objVariance.CPWVUpdoFlag
								Continue:UpdoFlag="Y"
								Set ExtraValues=objVariance.CPWVExtraValues
								Continue:(ExtraValues'[("OEITEM:"_OEExecID_"-"_argEpStepID))&&(ExtraValues'[("OEITEM:"_xOEItemID_"-"_argEpStepID))
								Set IsHaveVarRst="Y"
							}
						}
						Continue:IsHaveVarRst="Y" //填写过变异记录不再显示
						
						Set num=$i(^TMP(ZIndex,JIndex,NIndex))
						Set Code="OEITEM:"_OEExecID_"-"_argEpStepID
						Set Desc=ArcimDesc_"("_OEItemDoc_"  "_$zd(xDate,3)_" "_$zt(xTime,2)_")"
						Set Type="表单外医嘱"
						Set ^TMP(ZIndex,JIndex,NIndex,num)=$lb(num,Code,Desc,Type)
					}
				}
			}
		}
	} Else {   //旧版本医嘱,医嘱无效通过OE_OrdItem表状态判断
		Set OrdID=$o(^OEORD(0,"Adm",EpisodeID,""))
		Set ArcimID=""
		For {
			Set ArcimID=$o(^OEORDi(0,"ARCIM",OrdID,ArcimID))
			Quit:ArcimID=""
			
			Set ItemSubCatDR=$P($g(^ARCIM($P(ArcimID,"||",1),$P(ArcimID,"||",2),1)),"^",10)
			Set ItemSubCatDesc=$p(^ARC("IC",ItemSubCatDR),"^",2)
			Continue:(ArcimSubCatList'="")&&($listfind(ArcimSubCatList,ItemSubCatDesc)>0)  //医嘱子类
			Set OrdCatDR=$p(^ARC("IC",ItemSubCatDR),"^",8)
			Set OrdCatDesc=$p(^OEC("ORCAT",OrdCatDR),"^",2)
			Continue:(ArcimCategList'="")&&($listfind(ArcimCategList,OrdCatDesc)>0)       //医嘱大类
			
			//有对应的实施记录
			Continue:$d(^DHCMR("IMPL",argPathWayID,"EpStep",argEpStepID,"ARCIM","ArcimID:"_ArcimID))
			Continue:$d(^DHCMR("IMPL",argPathWayID,"EpStep",argEpStepID,"ARCIM",ArcimID))
			
			Set ArcimDesc=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",2)      //add by wuqk 2012-02-24
			
			//判断录医嘱时未填写变异
			Set ChildSub="",IsHaveVarRst="N"
			For {
				Set ChildSub=$o(^DHCMR("CPW",argPathWayID,"VAR",ChildSub))
				Quit:ChildSub=""
				Quit:IsHaveVarRst="Y"
				Set CPWVID=argPathWayID_"||"_ChildSub
				Set objVariance=##class(web.DHCCPW.MR.ClinPathWaysVariance).GetObjById(CPWVID)
				If $IsObject(objVariance){
					Set UpdoFlag=objVariance.CPWVUpdoFlag
					Continue:UpdoFlag="Y"
					Set ExtraValues=objVariance.CPWVExtraValues
					Continue:ExtraValues'[("ARCIM:"_ArcimID_"-"_argEpStepID)
					Set IsHaveVarRst="Y"
				}
			}
			Continue:IsHaveVarRst="Y" //填写过变异记录不再显示
			
			//Set ^DHCMR("IMPL",aPathWayID,"EpStep",EpStepID,"ARCIM",lnkArcimID,ItemRowID,ResultCode)
			Set xOEItemID=""
			For {
				Set xOEItemID=$o(^DHCMR("OEOrdExec",EpisodeID,ArcimID,xOEItemID))
				Quit:xOEItemID=""
				
				Set OeoriStatus=""
				Set OeoriStatusID=$p($g(^OEORD(+xOEItemID,"I",$p(xOEItemID,"||",2),1)),"^",13)
				Set:OeoriStatusID'="" OeoriStatus=$p($g(^OEC("OSTAT",OeoriStatusID)),"^",1)
				Continue:OeoriStatus=""
				//Continue:OeoriStatus["D"  //医嘱状态  停止
				Continue:OeoriStatus["I"  //医嘱状态  未审核
				
				//取持续医嘱的停止时间,未停取当前时间
				Set OEXDate=$p($g(^OEORD(+xOEItemID,"I",$p(xOEItemID,"||",2),3)),"^",34)
				Set OEXTime=+$p($g(^OEORD(+xOEItemID,"I",$p(xOEItemID,"||",2),2)),"^",15)
				Set:OEXDate="" OEXDate=+$h,OEXTime=$p($h,",",2)
				
				Set OEItemInfo=$g(^OEORD(+xOEItemID,"I",$p(xOEItemID,"||",2),1))
				Set OEItemDate=$p(OEItemInfo,"^",9)
				Set:OEItemDate'="" OEItemDate=$zd(OEItemDate,3)
				Set OEItemTime=$p(OEItemInfo,"^",10)
				Set:OEItemTime'="" OEItemTime=$zt(OEItemTime,2)
				Set OEItemDoc=$p(OEItemInfo,"^",11)
				If OEItemDoc'="" {
					Set OEDocType=$p($g(^CTPCP(+OEItemDoc,1)),"^",4)
					Set:OEDocType'="" OEDocType=$p($g(^CT("CPT",OEDocType)),"^",4)
					Continue:OEDocType'[argUserType
					Set OEItemDoc=$p($g(^CTPCP(+OEItemDoc,1)),"^",2)
				}
				
				Set ExecType=$g(^DHCMR("OEOrdExec",EpisodeID,ArcimID,xOEItemID,"ExecType"))
				
				Set xDate=StartDate-1
				For {
					Set xDate=$o(^DHCMR("OEOrdExec",EpisodeID,ArcimID,xOEItemID,"ExStDate",xDate))
					Quit:xDate=""
					Quit:xDate>EndDate
					
					If ExecType=1 {  //持续医嘱
						Set xTime=0
					} Else {  //非持续医嘱
						Set xTime=$s(xDate=StartDate:StartTime,1:0)
					}
					Set xTime=xTime-1
					For {
						Set xTime=$o(^DHCMR("OEOrdExec",EpisodeID,ArcimID,xOEItemID,"ExStDate",xDate,xTime))
						Quit:xTime=""
						Quit:(xDate=EndDate)&&(xTime>EndTime)
						
						Set OEExecID=$o(^DHCMR("OEOrdExec",EpisodeID,ArcimID,xOEItemID,"ExStDate",xDate,xTime,""))
						Continue:OEExecID=""
						
						If ExecType=1 {  //持续医嘱
							//取当前执行记录的停止日期和时间
							Set OEExecXDate=xDate
							If OEXDate>xDate {
								Set OEExecXTime=$zth("23:59:59",1)
							} ElseIf OEXDate=xDate {
								Set OEExecXTime=xTime
							} Else {    //停止日期小于执行记录日期,执行记录无效
								Continue
							}
							//停止时间小于开始时间,退出
							Continue:OEExecXDate<StartDate
							Continue:(OEExecXDate=StartDate)&&(OEExecXTime<StartTime)
						} Else {
							Continue:xDate>OEXDate
							Continue:(xDate=OEXDate)&&(xTime>OEXTime)
						}
						
						Set IsOutOEItem="Y"  //路径外医嘱标记
						
						//判断签名时未填写变异
						Set ChildSub="",IsHaveVarRst="N"
						For {
							Set ChildSub=$o(^DHCMR("CPW",argPathWayID,"VAR",ChildSub))
							Quit:ChildSub=""
							Quit:IsHaveVarRst="Y"
							Set CPWVID=argPathWayID_"||"_ChildSub
							Set objVariance=##class(web.DHCCPW.MR.ClinPathWaysVariance).GetObjById(CPWVID)
							If $IsObject(objVariance){
								Set UpdoFlag=objVariance.CPWVUpdoFlag
								Continue:UpdoFlag="Y"
								Set ExtraValues=objVariance.CPWVExtraValues
								Continue:(ExtraValues'[("OEITEM:"_OEExecID_"-"_argEpStepID))&&(ExtraValues'[("OEITEM:"_xOEItemID_"-"_argEpStepID))
								Set IsHaveVarRst="Y"
							}
						}
						Continue:IsHaveVarRst="Y" //填写过变异记录不再显示
						
						Set num=$i(^TMP(ZIndex,JIndex,NIndex))
						Set Code="OEITEM:"_OEExecID_"-"_argEpStepID
						Set Desc=ArcimDesc_"("_OEItemDoc_"  "_$zd(xDate,3)_" "_$zt(xTime,2)_")"
						Set Type="表单外医嘱"
						Set ^TMP(ZIndex,JIndex,NIndex,num)=$lb(num,Code,Desc,Type)
					}
				}
			}
		}
	}
	
	Set return=num
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-08-03
/// Description:  查询必选项目未执行
/// Input：       argPathWayID  : 出入径ID
///               argEpStepID   : 步骤ID
///               argUserType   : 类型(D医生,N护士)
/// Return：      返回检查结果  return>0:有变异,return=0 无变异
/// w ##Class(web.DHCCPW.MRC.FormExam).chkFormRequiredItem("15","54||1||1","")
ClassMethod chkFormRequiredItem(ZIndex As %String, JIndex As %String, NIndex As %String, argPathWayID As %String, argEpStepID As %String, argUserType As %String) As %String
{
	New (ZIndex,JIndex,NIndex,argPathWayID,argEpStepID,argUserType)
	Set return=0,num=0
	Quit:(argPathWayID="")||(argEpStepID="")||(argUserType="") return
	
	Kill ^TMP(ZIndex,JIndex,"chkFormRequiredItem")
	Kill ^TMP(ZIndex,JIndex,"chkFormRequiredItemTMP")
	Set CPWID=$p(argEpStepID,"||",1)
	Set EpID=$p(argEpStepID,"||",2)
	Set StepID=$p(argEpStepID,"||",3)
	Set CompStepList=""
	Quit:(argPathWayID="")||(argEpStepID="") return
	Quit:(CPWID="")||(EpID="")||(StepID="") return
	
	//Add by zf 20120217
	//自动同步关联医嘱和关联项目数据
	Set flg=##class(web.DHCCPW.MR.ImplementAutoGen).AutoGenImpl(argPathWayID,argEpStepID)
	
	//取步骤时间段内对应医嘱(医嘱开始时间)
	If argPathWayID'="" {
		Set StartDate="",StartTime=""
		Set EstTimeLS=##class(web.DHCCPW.MR.ClinPathWaysEstimate).GetObjByPathWayID(argPathWayID)
		If EstTimeLS'="" {
			Set EstTimesCnt=$listlength(EstTimeLS)
			For EstTimesInd=1:1:EstTimesCnt {
				Set objEstTime=$list(EstTimeLS,EstTimesInd)
				Set EstEpStepDR=$list(objEstTime,1)
				Continue:argEpStepID'=EstEpStepDR
				//Set StartDate=$list(objEstTime,3)
				//Set StartTime=$list(objEstTime,4)
				//Set EndDate=$list(objEstTime,5)
				//Set EndTime=$list(objEstTime,6)
				Set CompStepList=$list(objEstTime,8)
			}
		}
	}
	
	Set ItemID=0
	For {
		Set ItemID=$o(^DHCMRC("CPW",CPWID,"EP",EpID,"STEP",StepID,"ITEM",ItemID))
		Quit:ItemID=""
		
		Set StepItemID=CPWID_"||"_EpID_"||"_StepID_"||"_ItemID
		Set (ItemDesc,ItemType,GroupNo)=""
		Set objItem=##class(web.DHCCPW.MRC.PathWEpStepItem).GetObjById(StepItemID)
		If $IsObject(objItem) {
			Set ItemDesc=objItem.CPWSIDesc
			Set IsMust=objItem.CPWSIIsMust
			Continue:IsMust["Y"    //显示必选项目、过滤可选项目
			If $IsObject(objItem.CPWSISubCategory) {
				Set ItemPower=objItem.CPWSISubCategory.SISCPower
				Continue:(argUserType="D")&&((ItemPower'="D")&&(ItemPower'="OE"))
				Continue:(argUserType="N")&&((ItemPower'="N")&&(ItemPower'="NE"))
				If $IsObject(objItem.CPWSISubCategory.SISCParRef) {
					Set ItemType=objItem.CPWSISubCategory.SISCParRef.SICDesc
				}
			}
			Set GroupNo=+objItem.CPWSIGroupNo
			Set:GroupNo="" GroupNo=999
		}
		Continue:ItemDesc=""
		
		Set IsImplement=##Class(web.DHCCPW.MRC.FormShow).IsItemImpl(ZIndex,JIndex,argPathWayID,StepItemID_"-"_argEpStepID,"chkFormRequiredItemTMP")
		Continue:IsImplement>0  //显示未执行项目、过滤已执行项目
		Set ^TMP(ZIndex,JIndex,"chkFormRequiredItem",GroupNo,StepItemID)=ItemDesc
	}
	
	Set IsCheck=""
	Set objConfig=##class(web.DHCCPW.MRC.BaseConfig).GetObjByCode("ExamSyndrome")
	If $IsObject(objConfig){
		Set IsCheck=objConfig.BCValue
	}
	If IsCheck'="N" {
		For compIndex=1:1:$listlength(CompStepList) {
			Set CompStepID=$list(CompStepList,compIndex)
			Set CPWID=$p(CompStepID,"||",1)
			Set EpID=$p(CompStepID,"||",2)
			Set StepID=$p(CompStepID,"||",3)
			Continue:(CPWID="")||(EpID="")||(StepID="")
			
			Set ItemID=0
			For {
				Set ItemID=$o(^DHCMRC("CPW",CPWID,"EP",EpID,"STEP",StepID,"ITEM",ItemID))
				Quit:ItemID=""
				
				Set StepItemID=CPWID_"||"_EpID_"||"_StepID_"||"_ItemID
				Set (ItemDesc,ItemType,GroupNo)=""
				Set objItem=##class(web.DHCCPW.MRC.PathWEpStepItem).GetObjById(StepItemID)
				If $IsObject(objItem) {
					Set ItemDesc=objItem.CPWSIDesc
					Set IsMust=objItem.CPWSIIsMust
					Continue:IsMust["Y"    //显示必选项目、过滤可选项目
					If $IsObject(objItem.CPWSISubCategory) {
						Set ItemPower=objItem.CPWSISubCategory.SISCPower
						Continue:(argUserType="D")&&((ItemPower'="D")&&(ItemPower'="OE"))
						Continue:(argUserType="N")&&((ItemPower'="N")&&(ItemPower'="NE"))
						If $IsObject(objItem.CPWSISubCategory.SISCParRef) {
							Set ItemType=objItem.CPWSISubCategory.SISCParRef.SICDesc
						}
					}
					Set GroupNo=+objItem.CPWSIGroupNo
					Set:GroupNo="" GroupNo=999
					Set GroupNo=(compIndex*100)+GroupNo
				}
				Continue:ItemDesc=""
				
				Set IsImplement=##Class(web.DHCCPW.MRC.FormShow).IsItemImpl(ZIndex,JIndex,argPathWayID,StepItemID_"-"_argEpStepID,"chkFormRequiredItemTMP")
				Continue:IsImplement>0  //显示未执行项目、过滤已执行项目
				Set ^TMP(ZIndex,JIndex,"chkFormRequiredItem",GroupNo,StepItemID)=ItemDesc
			}
		}
	}
	
	Set GroupNo=""
	For {
		Set GroupNo=$o(^TMP(ZIndex,JIndex,"chkFormRequiredItem",GroupNo))
		Quit:GroupNo=""
		
		Set ItemID="",GroupDesc=""
		For {
			Set ItemID=$o(^TMP(ZIndex,JIndex,"chkFormRequiredItem",GroupNo,ItemID))
			Quit:ItemID=""
			Set objItem=##class(web.DHCCPW.MRC.PathWEpStepItem).GetObjById(ItemID)
			Continue:'$IsObject(objItem)
			Continue:'$IsObject(objItem.CPWSISubCategory)
			Continue:'$IsObject(objItem.CPWSISubCategory.SISCParRef)
			Set ItemDesc=objItem.CPWSIDesc
			Set CategDesc=objItem.CPWSISubCategory.SISCParRef.SICDesc
			Set SubCatDesc=objItem.CPWSISubCategory.SISCDesc
			
			Set ChildSub="",IsHaveVarRst="N"
			For {
				Set ChildSub=$o(^DHCMR("CPW",argPathWayID,"VAR",ChildSub))
				Quit:ChildSub=""
				Quit:IsHaveVarRst="Y"
				Set CPWVID=argPathWayID_"||"_ChildSub
				Set objVariance=##class(web.DHCCPW.MR.ClinPathWaysVariance).GetObjById(CPWVID)
				If $IsObject(objVariance){
					Set UpdoFlag=objVariance.CPWVUpdoFlag
					Continue:UpdoFlag="Y"
					Set ExtraValues=objVariance.CPWVExtraValues
					Continue:ExtraValues'[("CPWITM:"_ItemID_"-"_argEpStepID)
					Set IsHaveVarRst="Y"
				}
			}
			Continue:IsHaveVarRst="Y" //填写过变异记录不再显示
			
			Set num=$i(^TMP(ZIndex,JIndex,NIndex))
			Set Code="CPWITM:"_ItemID_"-"_argEpStepID
			Set Desc=ItemDesc_"("_CategDesc_"-"_SubCatDesc_")"
			Set Type="必选项目未执行"
			Set ^TMP(ZIndex,JIndex,NIndex,num)=$lb(num,Code,Desc,Type)
		}
	}
	Kill ^TMP(ZIndex,JIndex,"chkFormRequiredItem")
	Kill ^TMP(ZIndex,JIndex,"chkFormRequiredItemTMP")
	
	Set return=num
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-08-03
/// Description:  查询可选项目已执行
/// Input：       argPathWayID  : 出入径ID
///               argEpStepID   : 步骤ID
///               argUserType   : 类型(D医生,N护士)
/// Return：      返回检查结果  return>0:有变异,return=0 无变异
/// w ##Class(web.DHCCPW.MRC.FormExam).chkFormOptionalItem("15","54||1||1","")
ClassMethod chkFormOptionalItem(ZIndex As %String, JIndex As %String, NIndex As %String, argPathWayID As %String, argEpStepID As %String, argUserType As %String) As %String
{
	New (ZIndex,JIndex,NIndex,argPathWayID,argEpStepID,argUserType)
	Set return=0,num=0
	Quit:(argPathWayID="")||(argEpStepID="")||(argUserType="") return
	
	Kill ^TMP(ZIndex,JIndex,"chkFormOptionalItem")
	Kill ^TMP(ZIndex,JIndex,"chkFormOptionalItemTMP")
	Set CPWID=$p(argEpStepID,"||",1)
	Set EpID=$p(argEpStepID,"||",2)
	Set StepID=$p(argEpStepID,"||",3)
	Set CompStepList=""
	Quit:(argPathWayID="")||(argEpStepID="") return
	Quit:(CPWID="")||(EpID="")||(StepID="") return
	
	//Add by zf 20120217
	//自动同步关联医嘱和关联项目数据
	Set flg=##class(web.DHCCPW.MR.ImplementAutoGen).AutoGenImpl(argPathWayID,argEpStepID)
	
	//取步骤时间段内对应医嘱(医嘱开始时间)
	If argPathWayID'="" {
		Set StartDate="",StartTime=""
		Set EstTimeLS=##class(web.DHCCPW.MR.ClinPathWaysEstimate).GetObjByPathWayID(argPathWayID)
		If EstTimeLS'="" {
			Set EstTimesCnt=$listlength(EstTimeLS)
			For EstTimesInd=1:1:EstTimesCnt {
				Set objEstTime=$list(EstTimeLS,EstTimesInd)
				Set EstEpStepDR=$list(objEstTime,1)
				Continue:argEpStepID'=EstEpStepDR
				//Set StartDate=$list(objEstTime,3)
				//Set StartTime=$list(objEstTime,4)
				//Set EndDate=$list(objEstTime,5)
				//Set EndTime=$list(objEstTime,6)
				Set CompStepList=$list(objEstTime,8)
			}
		}
	}
	
	Set ItemID=0
	For {
		Set ItemID=$o(^DHCMRC("CPW",CPWID,"EP",EpID,"STEP",StepID,"ITEM",ItemID))
		Quit:ItemID=""
		
		Set StepItemID=CPWID_"||"_EpID_"||"_StepID_"||"_ItemID
		Set (ItemDesc,ItemType,GroupNo)=""
		Set objItem=##class(web.DHCCPW.MRC.PathWEpStepItem).GetObjById(StepItemID)
		If $IsObject(objItem) {
			Set ItemDesc=objItem.CPWSIDesc
			Set IsMust=objItem.CPWSIIsMust
			Continue:IsMust'["Y"    //显示可选项目、过滤必选项目
			If $IsObject(objItem.CPWSISubCategory) {
				Set ItemPower=objItem.CPWSISubCategory.SISCPower
				Continue:(argUserType="D")&&((ItemPower'="D")&&(ItemPower'="OE"))
				Continue:(argUserType="N")&&((ItemPower'="N")&&(ItemPower'="NE"))
				If $IsObject(objItem.CPWSISubCategory.SISCParRef) {
					Set ItemType=objItem.CPWSISubCategory.SISCParRef.SICDesc
				}
			}
			Set GroupNo=+objItem.CPWSIGroupNo
			Set:GroupNo="" GroupNo=999
		}
		Continue:ItemDesc=""
		
		Set IsImplement=##Class(web.DHCCPW.MRC.FormShow).IsItemImpl(ZIndex,JIndex,argPathWayID,StepItemID_"-"_argEpStepID,"chkFormOptionalItemTMP")
		Continue:IsImplement<1  //显示已执行项目、过滤未执行项目
		Set ^TMP(ZIndex,JIndex,"chkFormOptionalItem",GroupNo,StepItemID)=ItemDesc
	}
	
	Set IsCheck=""
	Set objConfig=##class(web.DHCCPW.MRC.BaseConfig).GetObjByCode("ExamSyndrome")
	If $IsObject(objConfig){
		Set IsCheck=objConfig.BCValue
	}
	If IsCheck'="N" {
		For compIndex=1:1:$listlength(CompStepList) {
			Set CompStepID=$list(CompStepList,compIndex)
			Set CPWID=$p(CompStepID,"||",1)
			Set EpID=$p(CompStepID,"||",2)
			Set StepID=$p(CompStepID,"||",3)
			Continue:(CPWID="")||(EpID="")||(StepID="")
			
			Set ItemID=0
			For {
				Set ItemID=$o(^DHCMRC("CPW",CPWID,"EP",EpID,"STEP",StepID,"ITEM",ItemID))
				Quit:ItemID=""
				
				Set StepItemID=CPWID_"||"_EpID_"||"_StepID_"||"_ItemID
				Set (ItemDesc,ItemType,GroupNo)=""
				Set objItem=##class(web.DHCCPW.MRC.PathWEpStepItem).GetObjById(StepItemID)
				If $IsObject(objItem) {
					Set ItemDesc=objItem.CPWSIDesc
					Set IsMust=objItem.CPWSIIsMust
					Continue:IsMust'["Y"    //显示可选项目、过滤必选项目
					If $IsObject(objItem.CPWSISubCategory) {
						Set ItemPower=objItem.CPWSISubCategory.SISCPower
						Continue:(argUserType="D")&&((ItemPower'="D")&&(ItemPower'="OE"))
						Continue:(argUserType="N")&&((ItemPower'="N")&&(ItemPower'="NE"))
						If $IsObject(objItem.CPWSISubCategory.SISCParRef) {
							Set ItemType=objItem.CPWSISubCategory.SISCParRef.SICDesc
						}
					}
					Set GroupNo=+objItem.CPWSIGroupNo
					Set:GroupNo="" GroupNo=999
					Set GroupNo=(compIndex*100)+GroupNo
				}
				Continue:ItemDesc=""
				
				Set IsImplement=##Class(web.DHCCPW.MRC.FormShow).IsItemImpl(ZIndex,JIndex,argPathWayID,StepItemID_"-"_argEpStepID,"chkFormOptionalItemTMP")
				Continue:IsImplement<1  //显示已执行项目、过滤未执行项目
				Set ^TMP(ZIndex,JIndex,"chkFormOptionalItem",GroupNo,StepItemID)=ItemDesc
			}
		}
	}
	
	Set GroupNo=""
	For {
		Set GroupNo=$o(^TMP(ZIndex,JIndex,"chkFormOptionalItem",GroupNo))
		Quit:GroupNo=""
		
		Set ItemID="",GroupDesc=""
		For {
			Set ItemID=$o(^TMP(ZIndex,JIndex,"chkFormOptionalItem",GroupNo,ItemID))
			Quit:ItemID=""
			Set objItem=##class(web.DHCCPW.MRC.PathWEpStepItem).GetObjById(ItemID)
			Continue:'$IsObject(objItem)
			Continue:'$IsObject(objItem.CPWSISubCategory)
			Continue:'$IsObject(objItem.CPWSISubCategory.SISCParRef)
			Set ItemDesc=objItem.CPWSIDesc
			Set CategDesc=objItem.CPWSISubCategory.SISCParRef.SICDesc
			Set SubCatDesc=objItem.CPWSISubCategory.SISCDesc
			
			Set ChildSub="",IsHaveVarRst="N"
			For {
				Set ChildSub=$o(^DHCMR("CPW",argPathWayID,"VAR",ChildSub))
				Quit:ChildSub=""
				Quit:IsHaveVarRst="Y"
				Set CPWVID=argPathWayID_"||"_ChildSub
				Set objVariance=##class(web.DHCCPW.MR.ClinPathWaysVariance).GetObjById(CPWVID)
				If $IsObject(objVariance){
					Set UpdoFlag=objVariance.CPWVUpdoFlag
					Continue:UpdoFlag="Y"
					Set ExtraValues=objVariance.CPWVExtraValues
					Continue:ExtraValues'[("CPWITM:"_ItemID_"-"_argEpStepID)
					Set IsHaveVarRst="Y"
				}
			}
			Continue:IsHaveVarRst="Y" //填写过变异记录不再显示
			
			Set num=$i(^TMP(ZIndex,JIndex,NIndex))
			Set Code="CPWITM:"_ItemID_"-"_argEpStepID
			Set Desc=ItemDesc_"("_CategDesc_"-"_SubCatDesc_")"
			Set Type="可选项目已执行"
			Set ^TMP(ZIndex,JIndex,NIndex,num)=$lb(num,Code,Desc,Type)
		}
	}
	Kill ^TMP(ZIndex,JIndex,"chkFormOptionalItemTMP")
	Kill ^TMP(ZIndex,JIndex,"chkFormOptionalItem")
	
	Set return=num
	Quit return
}

}
