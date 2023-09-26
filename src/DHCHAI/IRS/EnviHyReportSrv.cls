/// 名称: DHCHAI.IRS.EnviHyReportSrv
/// 描述: 环境卫生学监测报告单服务
/// 编写者：liyi
/// 编写日期: 2018-01-15
Class DHCHAI.IRS.EnviHyReportSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2020-09-24
/// Description:  查询环境卫生学科室申请单打印报告
/// Table：       DHCHAI.IR.EnviHyReport
/// Input:        报告ID 列表
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.EnviHyReportSrv","QryEnviPrintRepInfo","1")
Query QryEnviPrintRepInfo(aReportID As %Text) As %Query(ROWSPEC = "ReportID:%String,BarCode:%String,BactDesc:%String,Result:%String,StandardDesc:%String,EvItemObjDesc:%String,EvItemDesc:%String,SpenTypeDesc:%String,MonitorLocDesc:%String,RepDate:%String,RepUserDesc:%String,ApplyLocDesc:%String,ApplyUserDesc:%String,NormDesc:%String,RepBarCode:%String,CheckUserDesc:%String,Flag:%String,txtEHResume:%String,ResumeFlag:%String") [ SqlProc ]
{
}

ClassMethod QryEnviPrintRepInfoExecute(ByRef qHandle As %Binary, aReportID As %Text) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:aReportID="" $$$OK
	Set IREnviResult= ##class(DHCHAI.BT.Config).GetValByCode("IREnviResult")  //获取判断结果配置
	For i=1:1:$l(aReportID,"^") {
		Set ReportID=$p(aReportID,"^",i)
		Continue:ReportID=""
		
		Set objRep = ##class(DHCHAI.IR.EnviHyReport).GetObjById(ReportID)
		Continue:'$IsObject(objRep)
		
		Set objEvItem = objRep.EHItemDr
		Continue:'$IsObject(objEvItem)
		//检测对象
		Set EvItemObjDesc="",EHSpecimenType=""
		Set objItemObj = objRep.EHItemObjDr
		If $IsObject(objItemObj){
			Set EvItemObjID = objItemObj.%Id()
			Set EvItemObjDesc = objItemObj.EHObjDesc
			Set objTypeDr=objItemObj.EHSpecimenTypeDr
			Set:$IsObject(objTypeDr) EHSpecimenType=objTypeDr.BTDesc
		}
		Set objTypeDr=objEvItem.EHSpecimenTypeDr
		Set:$IsObject(objTypeDr) EHSpecimenType=objTypeDr.BTDesc
		Set EHItemObjTxt=objRep.EHItemObjTxt
		Set txtEHResume=objRep.EHResume
		//导出功能前台不能拼接，需要后台拼接
		if (EvItemObjDesc="")&&(EHItemObjTxt'=""){
			Set EvItemObjDesc = EHItemObjTxt
		}elseif(EHItemObjTxt'="")&&(EvItemObjDesc'=""){
			Set EvItemObjDesc = EvItemObjDesc_"["_EHItemObjTxt_"]"
		}elseif(EHItemObjTxt ="")&&(EvItemObjDesc =""){
			Set EvItemObjDesc = ""
		}
		Set:EvItemObjDesc="" EvItemObjDesc=EHSpecimenType
		Set SpenTypeDesc = objEvItem.EHSpecimenTypeDr.BTDesc	// 标本类型
		// 检测科室
		Set MonitorLocDesc=""
		Set objMonitorLoc = objRep.EHMonitorLocDr
		If $IsObject(objMonitorLoc){
			Set MonitorLocID = objMonitorLoc.%Id()
			If objMonitorLoc.BTDesc2=""{
				Set MonitorLocDesc = objMonitorLoc.BTDesc
			}else{
				Set MonitorLocDesc = objMonitorLoc.BTDesc2
			}
		}
		//报告日期
		Set RepDate = objRep.EHRepDate
		Set:RepDate'="" RepDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
		//报告人
		Set RepUserDesc=""
		Set objRepUser = objRep.EHRepUserDr
		If $IsObject(objRepUser){
			Set RepUserID = objRepUser.%Id()
			Set RepUserDesc = objRepUser.BTDesc
		}
		//审核人
		Set CheckUserDesc=""
		Set xStatusDr=""
		For {
			Set xStatusDr=$o(^DHCHAI.IR.EnviHyReportI("Log","IndexReportStatus",ReportID,xStatusDr),-1)
			Quit:xStatusDr=""
			Set StatusDesc=""
			Set StusData=$g(^DHCHAI.BT.DictionaryD(xStatusDr))
			Set:StusData'="" StatusDesc=$li(StusData,3)
			Continue:StatusDesc'="审核结果"
			Set xSubID=0
			For {
				Set xSubID=$o(^DHCHAI.IR.EnviHyReportI("Log","IndexReportStatus",ReportID,xStatusDr,xSubID))
				Quit:xSubID=""
				Set objLog=##class(DHCHAI.IR.EnviHyReportLog).GetObjById(ReportID_"||"_xSubID)
				Continue:'$IsObject(objLog)
				Continue:objLog.EHIsActive'=1
				Set EHUpdateUserDr=objLog.EHUpdateUserDr
				If $IsObject(EHUpdateUserDr){
					Set RepUserID = EHUpdateUserDr.%Id()
					Set CheckUserDesc = EHUpdateUserDr.BTDesc
				}
			}
		}
		//监测项目： （Ⅳ级）洁净手术室空气监测
		Set EvItemDesc = objEvItem.EHItemDesc
 		// 申请科室
 		Set ApplyLocDesc=""
		Set objApplyLoc = objRep.EHApplyLocDr
		If $IsObject(objApplyLoc){
			Set ApplyLocID = objApplyLoc.%Id()
			If objApplyLoc.BTDesc2=""{
				Set ApplyLocDesc = objApplyLoc.BTDesc
			}else{
				Set ApplyLocDesc = objApplyLoc.BTDesc2
			}
		}
		// 申请人
 		Set ApplyUserDesc=""
		Set objApplyUser = objRep.EHApplyUserDr
		If $IsObject(objApplyUser){
			Set ApplyUserID = objApplyUser.%Id()
			Set ApplyUserDesc = objApplyUser.BTDesc
		}
		Set tNormDesc = objEvItem.EHNorm           		// 检测标准
		Set NormMax   = objEvItem.EHNormMax              // 中心值
		Set NormMin   = objEvItem.EHNormMin          	// 周边值

		//达标情况
		Set StandardDesc=""
		Set objStandard = objRep.EHStandard
		If $IsObject(objStandard){
			Set StandardID = objStandard.%Id()
			Set StandardDesc = objStandard.BTDesc
		}
		// 检验号 
		Set RepBarCode=##class(DHCHAI.IR.EnviHyReport).GetBarCode(ReportID)
		
		Set SpecimenNum=objRep.EHSpecimenNum
		Set CenterNum=objRep.EHCenterNum               //中心点个数
		Set CenterNum=+CenterNum
		Set SurroundNum=objRep.EHSurroundNum           //周边点个数
		Set SurroundNum=+SurroundNum
		Set num = CenterNum+SurroundNum
		Set EnterTypeCode=objRep.EHEnterTypeDr.BTCode  //录入方式
		Set ReferToNum=objRep.EHReferToNum             //参照点个数
		Set ReferToNum=+ReferToNum
		Set ForMula=objRep.EHItemDr.EHForMula          //计算公式
		Set NormMax=objRep.EHItemDr.EHNormMax	       //正常上限(中心值,周边值)
		Set NormMin=objRep.EHItemDr.EHNormMin	       //正常下限(中心值,周边值)
		
	    Set EHItemTypeDr=objRep.EHItemDr.EHItemTypeDr  //监测项目类型
	    Set EHItemTypeDesc=EHItemTypeDr.BTDesc
		//结果信息
		Set ResultCnt=0,ResultList="",BacList="",BacList1=""	
		Set xSpecNumber=""
		For {
			Set xSpecNumber=$o(^DHCHAI.IR.EnviHyReportI("Result","IndexSpecNumber",ReportID,xSpecNumber))
			Quit:xSpecNumber=""
			
			Set SubID=$o(^DHCHAI.IR.EnviHyReportI("Result","IndexSpecNumber",ReportID,xSpecNumber,""))
			Continue:SubID=""
			Set objResult=##class(DHCHAI.IR.EnviHyRepResult).GetObjById(ReportID_"||"_SubID)
			Set RstTypeCode=objResult.EHRstTypeDr.BTCode  //结果类型 "EHRstType"（菌落数、大于、小于、检出菌、未检出、阴性等）
			Set RstTypeDesc=objResult.EHRstTypeDr.BTDesc
			Set Result=objResult.EHResult                 //菌落数
			Set BactID="",BactDesc=""                     //检出菌/致病菌
			If $IsObject(objResult.EHBactDr){
				Set BactID=objResult.EHBactDr.%Id()
				Set BactDesc=objResult.EHBactDr.BTBacDesc
			}
			Set SpecNumber=objResult.EHSpecNumber         //标本顺序号（大排行）
			Set ResultCnt=ResultCnt+1
			Set ResultList=ResultList_$lb($lb(RstTypeCode,RstTypeDesc,Result,BactID,BactDesc,SpecNumber))
		}
		//（1按项目、2按标本、3其他[1中心+1周边]）
		If (EnterTypeCode=1){
			Set SurroundNum=0 //按项目,周边默认为0，只有中心
		}
		If (SurroundNum>0){ //空培打印两条记录中心周边就行
			//判断达标情况（0不合格、1合格）
			Set StandardCode=1,StandardCode1=1
			
			//首先判断检出菌，检出菌不合格
			For indRst=1:1:$ll(ResultList){
				Quit:indRst>num  //排除参照点
				Set tRowInfo=$lg(ResultList,indRst)
				Continue:tRowInfo=""
				
				Set tBactID=$lg(tRowInfo,4)
				Set tBactDesc=$lg(tRowInfo,5)
				Continue:(tBactID="")&&(tBactDesc="")
				//（1按项目、2按标本、3其他[1中心+1周边]）
				If (EnterTypeCode=3){ // 3其他[1中心+1周边]
					If (indRst=1){
						Set StandardCode=0  // 中心是否合格
						Set:tBactDesc'="" BacList=BacList_","_tBactDesc
					}Else{
						Set StandardCode1=0 // 周边是否合格
						Set:tBactDesc'="" BacList1=BacList1_","_tBactDesc      // 周边细菌
					}
				}Else{ // 2按标本
					If (indRst>CenterNum){
						Set StandardCode1=0  // 周边是否合格
						Set:tBactDesc'="" BacList1=BacList1_","_tBactDesc      // 周边细菌
					}Else{
						Set StandardCode=0
						Set:tBactDesc'="" BacList=BacList_","_tBactDesc
					}
				}
			}
			Set:BacList'="" BacList=$e(BacList,2,$l(BacList))
			Set:BacList1'="" BacList1=$e(BacList1,2,$l(BacList1))
			//其次判断结果值，根据公式计算
			Set tmpResult="",tmpResult1="",ResumeFlag=1
			Set (CenterVal,SurroundVal,SpecimenVal)=0
			For indRst=1:1:$ll(ResultList){
				Quit:indRst>num  //排除参照点
				Set tRowInfo=$lg(ResultList,indRst)
				Continue:tRowInfo=""
				
				Set tRstTypeCode=$lg(tRowInfo,1)
				Set tResult=$lg(tRowInfo,3)
				Set tSpecNumber=$lg(tRowInfo,6)
				Continue:(tResult="")&&(tRstTypeCode'=5)&&(tRstTypeCode'=6)  //无结果，表示无异常
				Continue:(tRstTypeCode'="")&&(tRstTypeCode'=1)&&(tRstTypeCode'=2)&&(tRstTypeCode'=3)&&(tRstTypeCode'=5)&&(tRstTypeCode'=6)
				Set val=0
				If tRstTypeCode=2 {
					If (EnterTypeCode=3){ // 3其他[1中心+1周边]
						If (indRst=1){
							Set StandardCode=0
							Set tmpResult="菌落数>"_tResult
						}Else{
							Set StandardCode1=0
							Set tmpResult1="菌落数>"_tResult
						}
					}Else{
						//大于，表示异常
						If (indRst>CenterNum){
							Set StandardCode1=0
							Set tmpResult1="菌落数>"_tResult
						}Else{
							Set StandardCode=0
							Set tmpResult="菌落数>"_tResult
						}
					}
					Continue
				} ElseIf tRstTypeCode=3 {
					//小于，表示无异常
					Set val=0
				} ElseIf tRstTypeCode=5 {
					//核酸阳性
					If (EnterTypeCode=3){ // 3其他[1中心+1周边]
						If (indRst=1){
							Set StandardCode=0
							Set tmpResult="阳性"
						}Else{
							Set StandardCode1=0
							Set tmpResult1="阳性"
						}
					}Else{
						//大于，表示异常
						If (indRst>CenterNum){
							Set StandardCode1=0
							Set tmpResult="阳性"
						}Else{
							Set StandardCode=0
							Set tmpResult="阳性"
						}
					}
					Set StandardCode=0
				} ElseIf tRstTypeCode=6 {
					//核酸阴性
					If (EnterTypeCode=3){ // 3其他[1中心+1周边]
						If (indRst=1){
							Set tmpResult="阴性"
						}Else{
							Set tmpResult1="阴性"
						}
					}Else{
						//大于，表示异常
						If (indRst>CenterNum){
							Set tmpResult="阴性"
						}Else{
							Set tmpResult="阴性"
						}
						Set val=0
					}
				} Else {
					Set val=..GetEnviHyResult(ForMula,+tResult)
				}
				If (CenterNum>0)||(SurroundNum>0){
					If (EnterTypeCode=3){ // 3其他[1中心+1周边]
						If (indRst=1){
							Set CenterVal=CenterVal+val
						}Else{
							Set SurroundVal=SurroundVal+val
						}
					}Else{
						If tSpecNumber<=CenterNum {
							Set CenterVal=CenterVal+val
						} Else {
							Set SurroundVal=SurroundVal+val
						}
					}
				} Else{
					Set SpecimenVal=SpecimenVal+val
				}
			}
			
			If (CenterNum>0)||(SurroundNum>0){
				If CenterNum>0 {
					If (IREnviResult=0){
						Set:(CenterVal/CenterNum)>NormMax StandardCode=0
						Set:tmpResult="" tmpResult=$FN((CenterVal/CenterNum),"",2)
					}else{
						Set:CenterVal>NormMax StandardCode=0
						Set:tmpResult="" tmpResult=CenterVal
					}
				}
				If SurroundNum>0 {
					If (IREnviResult=0){
						Set:(SurroundVal/SurroundNum)>NormMin StandardCode1=0
						Set:tmpResult1="" tmpResult1=$FN((SurroundVal/SurroundNum),"",2)
					}else{
						Set:SurroundVal>NormMin StandardCode1=0
						Set:tmpResult1="" tmpResult1=SurroundVal
					}
				}
			} Else{
				If SpecimenNum>0 {
					If (IREnviResult=0){
						Set:(SpecimenVal/SpecimenNum)>(+NormMax) StandardCode=0
						Set:tmpResult="" tmpResult=$FN((SpecimenVal/SpecimenNum),"",2)
					}else{
						Set:SpecimenVal>(+NormMax) StandardCode=0
						Set:tmpResult="" tmpResult=SpecimenVal
					}
				}
			}
			
			Set:StandardCode=0 StandardDesc="不合格"
			Set:StandardCode=1 StandardDesc="合格"
			Set:StandardCode1=0 StandardDesc1="不合格"
			Set:StandardCode1=1 StandardDesc1="合格"	
			if ((tmpResult="阳性")||(tmpResult="阴性")){
				Set NormDesc=tNormDesc
			}Else{	
				Set NormDesc="≤"_NormMax_tNormDesc
			}	
			Set:BacList="" BacList="无"
			Set:BacList1="" BacList1="无"  
			Set BarCode=RepBarCode
			Set Result=$FN((CenterVal/CenterNum),"",2)
			Set:tmpResult'="" Result=tmpResult
			Set SurBarCode=BarCode
			If (SurroundNum>0){
				Set BarCode=BarCode_"[中心]"
				Set SurBarCode=SurBarCode_"[周边]"
			}
			If (num<SpecimenNum) Set ResumeFlag=0
			If SurroundNum>0  Set ResumeFlag=0
			Set Data=$lb(ReportID,BarCode,BacList,Result,StandardDesc,EvItemObjDesc,EvItemDesc,SpenTypeDesc,MonitorLocDesc,RepDate,RepUserDesc,ApplyLocDesc,ApplyUserDesc,NormDesc,RepBarCode,CheckUserDesc,0,txtEHResume,ResumeFlag)
			Set ^CacheTemp(repid,ind)=Data
    		Set ind=ind+1
    		// 周边结果输出
    		If SurroundNum>0 {
	    		if ((tmpResult1="阳性")||(tmpResult1="阴性")){
					Set NormDesc=tNormDesc
				}Else{	
					Set NormDesc="≤"_NormMin_tNormDesc
				}
	    		Set Result=$FN((SurroundVal/SurroundNum),"",2)
	    		Set:tmpResult1'="" Result=tmpResult1
	    		If (num>=SpecimenNum) Set ResumeFlag=1 
				Set Data=$lb(ReportID,SurBarCode,BacList1,Result,StandardDesc1,EvItemObjDesc,EvItemDesc,SpenTypeDesc,MonitorLocDesc,RepDate,RepUserDesc,ApplyLocDesc,ApplyUserDesc,NormDesc,RepBarCode,CheckUserDesc,1,txtEHResume,ResumeFlag)
				Set ^CacheTemp(repid,ind)=Data
	    		Set ind=ind+1
    		}
    		//增加参照点输出
    		If (num<SpecimenNum){
	    		Set ResumeFlag=0
				For indRst=(num+1):1:$ll(ResultList){
					Set tRowInfo=$lg(ResultList,indRst)
					Continue:tRowInfo=""
					Set tmpResult=""
					Set tRstTypeCode=$lg(tRowInfo,1)
					If tRstTypeCode=5 {
						//阳性
						Set StandardDesc="不合格"
						Set tmpResult="阳性"
					} ElseIf tRstTypeCode=6 {
						//阴性
						Set StandardDesc="合格"
						Set tmpResult="阴性"
					}
					Set:indRst=SpecimenNum ResumeFlag=1
					Set tBarCode="参照点"_(indRst-num)
					Set Data=$lb(ReportID,tBarCode,"",tmpResult,StandardDesc,EvItemObjDesc,EvItemDesc,SpenTypeDesc,MonitorLocDesc,RepDate,RepUserDesc,ApplyLocDesc,ApplyUserDesc,"阴性",RepBarCode,CheckUserDesc,1,txtEHResume,ResumeFlag)
					Set ^CacheTemp(repid,ind)=Data
	    			Set ind=ind+1
				}
			}
		}Else{
			//按项目录结果，按标本的物表、手
			//首先判断检出菌，检出菌不合格
			Set StandardCode=1
			For indRst=1:1:$ll(ResultList){
				Quit:indRst>num  //排除参照点
				Set tRowInfo=$lg(ResultList,indRst)
				Continue:tRowInfo=""
				
				Set tBactID=$lg(tRowInfo,4)
				Set tBactDesc=$lg(tRowInfo,5)
				Continue:(tBactID="")&&(tBactDesc="")
				Set StandardCode=0  // 是否合格
				Set:tBactDesc'="" BacList=BacList_","_tBactDesc
			}
			Set:BacList'="" BacList=$e(BacList,2,$l(BacList))
			//其次判断结果值，根据公式计算
			Set tmpResult="",ResumeFlag=1
			If (num<SpecimenNum) Set ResumeFlag=0
			Set (CenterVal,SurroundVal,SpecimenVal)=0
			For indRst=1:1:$ll(ResultList){
				Quit:indRst>num  //排除参照点
				Set tRowInfo=$lg(ResultList,indRst)
				Continue:tRowInfo=""
				
				Set tRstTypeCode=$lg(tRowInfo,1)
				Set tResult=$lg(tRowInfo,3)
				Set tSpecNumber=$lg(tRowInfo,6)
				Continue:(tResult="")&&(tRstTypeCode'=5)&&(tRstTypeCode'=6)  //无结果，表示无异常
				Continue:(tRstTypeCode'="")&&(tRstTypeCode'=1)&&(tRstTypeCode'=2)&&(tRstTypeCode'=3)&&(tRstTypeCode'=5)&&(tRstTypeCode'=6)&&(tRstTypeCode'=7)
				If tRstTypeCode=2 {
					Set StandardCode=0
					Set tmpResult="菌落数>"_tResult
					Continue
				} ElseIf tRstTypeCode=5 {
					//核酸阳性
					Set StandardCode=0
					Set tmpResult="阳性"
					Continue
				} ElseIf tRstTypeCode=6 {
					//核酸阴性
					Set tmpResult="阴性"
					Set val=0
				}ElseIf tRstTypeCode=3 {
					//小于，表示无异常
					Set val=0
					Set tmpResult="菌落数<"_tResult
				} Else {
					Set val=..GetEnviHyResult(ForMula,+tResult)
				}
				If (CenterNum>0){
					Set CenterVal=CenterVal+val
				} Else{
					Set SpecimenVal=SpecimenVal+val
				}
			}
			If (CenterNum>0){
				If CenterNum>0 {
					If EHItemTypeDesc="紫外线监测"{
						If (IREnviResult=0){
							Set:(CenterVal/CenterNum)<NormMax StandardCode=0
							Set:tmpResult="" tmpResult=$FN((CenterVal/CenterNum),"",2)
						}else{
							Set:CenterVal<NormMax StandardCode=0
							Set:tmpResult="" tmpResult=CenterVal
							}
						
					}Else{
							If (IREnviResult=0){
								Set:(CenterVal/CenterNum)>NormMax StandardCode=0
								Set:tmpResult="" tmpResult=$FN((CenterVal/CenterNum),"",2)
							}else{
								Set:CenterVal>NormMax StandardCode=0
								Set:tmpResult="" tmpResult=CenterVal
								}
						}
				}
			} Else{
				If SpecimenNum>0 {
					If (IREnviResult=0){
						Set:(SpecimenVal/SpecimenNum)>(+NormMax) StandardCode=0
						Set:tmpResult="" tmpResult=$FN((SpecimenVal/SpecimenNum),"",2)
					}else{
						Set:SpecimenVal>(+NormMax) StandardCode=0
						Set:tmpResult="" tmpResult=SpecimenVal
						}
				}
			}
			
			Set:StandardCode=0 StandardDesc="不合格"
			Set:StandardCode=1 StandardDesc="合格"	
			if ((tmpResult="阳性")||(tmpResult="阴性")){
				Set NormDesc=tNormDesc
			}Else{	
				If EHItemTypeDesc="紫外线监测"{
					Set NormDesc="≥"_NormMax_tNormDesc
				}Else{
					Set NormDesc="≤"_NormMax_tNormDesc
				}
			}	
			Set:BacList="" BacList="无"
			Set BarCode=RepBarCode
			Set Result=$FN((CenterVal/CenterNum),"",2)
			Set:tmpResult'="" Result=tmpResult
			
			Set Data=$lb(ReportID,BarCode,BacList,Result,StandardDesc,EvItemObjDesc,EvItemDesc,SpenTypeDesc,MonitorLocDesc,RepDate,RepUserDesc,ApplyLocDesc,ApplyUserDesc,NormDesc,RepBarCode,CheckUserDesc,0,txtEHResume,ResumeFlag)
			Set ^CacheTemp(repid,ind)=Data
    		Set ind=ind+1
    		//增加参照点输出
    		If (num<SpecimenNum){
	    		Set ResumeFlag=0
				For indRst=(num+1):1:$ll(ResultList){
					Set tRowInfo=$lg(ResultList,indRst)
					Continue:tRowInfo=""
					Set tmpResult=""
					Set tRstTypeCode=$lg(tRowInfo,1)
					If tRstTypeCode=5 {
						//阳性
						Set StandardDesc="不合格"
						Set tmpResult="阳性"
					} ElseIf tRstTypeCode=6 {
						//阴性
						Set StandardDesc="合格"
						Set tmpResult="阴性"
					}
					Set tBarCode="参照点"_(indRst-num)
					Set:indRst=SpecimenNum ResumeFlag=1
					Set Data=$lb(ReportID,tBarCode,"",tmpResult,StandardDesc,EvItemObjDesc,EvItemDesc,SpenTypeDesc,MonitorLocDesc,RepDate,RepUserDesc,ApplyLocDesc,ApplyUserDesc,"阴性",RepBarCode,CheckUserDesc,1,txtEHResume,ResumeFlag)
					Set ^CacheTemp(repid,ind)=Data
	    			Set ind=ind+1
				}
			}
		}
	}
	Quit $$$OK
}

ClassMethod QryEnviPrintRepInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEnviPrintRepInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryEnviPrintRepInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEnviPrintRepInfoExecute ]
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

/// Creator：     songzihang
/// CreatDate：   2018-05-10
/// Description:  环境卫生学结果打印
/// Table：       DHCHAI.IR.EnviHyReport,DHCHAI.IR.EnviHyRepResult
/// Input:        aReportID  ：查询代码
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.EnviHyReportSrv","QryPrintDetail",38)
Query QryPrintDetail(aReportID As %String) As %Query(ROWSPEC = "RepBarCode:%String,LogDateTime:%String,EHApplyLoc:%String,EHItem:%String,EHItemObj:%String,EHApplyUser:%String,BarCode:%String,BactDesc:%String,Result:%String,EHStandardDesc:%String,EHNormRange:%String,LogUserDesc:%String,EHApplyDate:%String,EHResume:%String,HospDesc:%String") [ SqlProc ]
{
}

ClassMethod QryPrintDetailExecute(ByRef qHandle As %Binary, aReportID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)

	Set objRep=##class(DHCHAI.IR.EnviHyReport).GetObjById(aReportID)
	Quit:'$IsObject(objRep) $$$OK
	Quit:'$IsObject(objRep.EHItemDr) $$$OK

	Set EHApplyDate			=$zd(objRep.EHApplyDate,3)
	Set EHResume			=objRep.EHResume
	Set RepBarCode=##class(DHCHAI.IR.EnviHyReport).GetBarCode(aReportID)		//申请号
	Set SpecimenNum			= objRep.EHItemDr.EHSpecimenNum						//标本个数
	Set EHApplyLoc			= objRep.EHApplyLocDr.BTDesc2						//申请科室
	Set EHApplyUser			= objRep.EHApplyUserDr.BTDesc						//申请人
	Set EHItem				= objRep.EHItemDr.EHItemDesc						//检测项目
	Set EHItemObj			= objRep.EHItemObjDr.EHObjDesc						//监测对象
	Set EHStandardDesc 		= objRep.EHStandard.BTDesc							//达标情况
	
	Set BTHospDr			= objRep.EHApplyLocDr.BTHospDr
	If (BTHospDr.BTDesc2){
		Set HospDesc		= BTHospDr.BTDesc2
	}else{
		Set HospDesc		= BTHospDr.BTDesc
	}
	If (EHStandardDesc="合格"){
		Set EHStandardDesc="是"
	}Else{
		Set EHStandardDesc="否"
	}
	
	Set EnviHyItemobj	    = objRep.EHItemDr
	Set EHNormMax			= EnviHyItemobj.EHNormMax							//中心值
	Set EHNormMin			= EnviHyItemobj.EHNormMin							//周边值
	
	Set EHCenterNum         = EnviHyItemobj.EHCenterNum                         //中心数量
	Set EHSurroundNum       = EnviHyItemobj.EHSurroundNum                       //周边数量
	Set testnum=""
	For indBar=1:1:SpecimenNum {
		Set BarCode=##class(DHCHAI.IR.EnviHyReport).GetSpenBarCode(aReportID,indBar)		//标本条码号
		
		Set SubID = $o(^DHCHAI.IR.EnviHyReportI("Result","IndexOnSpenBarCode",BarCode,aReportID,""),-1)
		Set i=$l(BarCode)
		
		If (SpecimenNum>10){
			Set testnum=$E(BarCode,i-1,i)
		}Else{
			Set testnum=$E(BarCode,i,i)
		}
	
		If (EHCenterNum>0)&&(testnum<=EHCenterNum)&&(testnum'="") {
			Set BarCode=BarCode_"[中心]",EHNormRange=EHNormMax
		}ElseIf(EHSurroundNum>0)&&(testnum<=(EHCenterNum+EHSurroundNum))&&(testnum'="") {
		 	Set BarCode=BarCode_"[周边]",EHNormRange=EHNormMin	
		}ElseIf(EHSurroundNum>0)||(EHCenterNum>0){
		 	Set BarCode=BarCode_"[参照]",EHNormRange=EHNormMax	
		}Else{
			Set BarCode=BarCode_"[检测]",EHNormRange=EHNormMax
		}
		Set (Result,BactID,BactDesc,LogDate,LogTime,LogUserID,LogUserDesc)=""
		Set objResult = ##class(DHCHAI.IR.EnviHyRepResult).GetObjById(aReportID_"||"_SubID)
		If $IsObject(objResult){
			Set Result = objResult.EHResult				//菌落数
			Set objBact = objResult.EHBactDr
			If $IsObject(objBact){
				Set BactID		= objBact.%Id()			//致病菌ID
				Set BactDesc	= objBact.BTBacDesc		//致病菌描述
			}
		}
		Set SubLogID = $o(^DHCHAI.IR.EnviHyReportI("Log","IndexOnSpenBarCode",BarCode,aReportID,""),-1)
		Set objLog = ##class(DHCHAI.IR.EnviHyReportLog).GetObjById(aReportID_"||"_SubLogID)
		If $IsObject(objLog){
			If objLog.EHUpdateStatusDr.BTCode=4{
				Set LogDate 	= ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(objLog.EHUpdateDate)	//结果录入日期
				Set LogTime		= $zt(objLog.EHUpdateTime)												//结果录入时间
				Set LogDateTime = LogDate_" "_LogTime
				Set LogUserID	= objLog.EHUpdateUserDr.%Id()											//结果录入人ID
				Set LogUserDesc	= objLog.EHUpdateUserDr.BTDesc											//结果录入人
			}
		}
		Set Data=$lb(RepBarCode,LogDateTime,EHApplyLoc,EHItem,EHItemObj,EHApplyUser,BarCode,BactDesc,Result,EHStandardDesc,EHNormRange,LogUserDesc,EHApplyDate,EHResume,HospDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryPrintDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPrintDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryPrintDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPrintDetailExecute ]
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

/// Creator：     liyi
/// CreatDate：   2018-01-15
/// Description:  查询监测报告单
/// Table：       DHCHAI.IR.EnviHyReport
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.EnviHyReportSrv","QryEvReport","2","","2019-09-01","2019-09-18","","","","")
Query QryEvReport(aHospIDs As %String, aDateType As %String, aDateFrom As %String, aDateTo As %String, aMonitorLoc As %String = "", aItemID As %String = "", aStatusCode As %String = "", aFlowFlg As %String = "", aStandard As %String = "") As %Query(ROWSPEC = "indNo:%String,ReportID:%String,HospID:%String,HospDesc:%String,BarCode:%String,EvItemID:%String,EvItemDesc:%String,EvItemObjID:%String,EvItemObjDesc:%String,RepStatusID:%String,RepStatusCode:%String,RepStatusDesc:%String,MonitorDate:%String,ApplyDate:%String,ApplyTime:%String,ApplyLocID:%String,ApplyLocDesc:%String,ApplyUserID:%String,ApplyUserDesc:%String,EvItemSpenNum:%String,SpecimenNum:%Float,RepDate:%String,RepTime:%String,RepLocID:%String,RepLocDesc:%String,RepUserID:%String,RepUserDesc:%String,StandardID:%String,StandardDesc:%String,Resume:%String,SpenTypeDesc:%String,NormDesc:%String,NormMax:%String,NormMin:%String,CenterNum:%String,SurroundNum:%String,RepCenterNum:%String,RepSurroundNum:%String,ReCheckRepID:%String,IsChecked:%String,ReCheckSign:%String,EHItemObjTxt:%String,MonitorLocID:%String,MonitorLocDesc:%String,ReferToNum:%String,IsObjNull:%String,EnterTypeId:%String,EnterTypeDesc:%String,SampleResult:%String,Reason:%String,Action:%String,ReCheckReps:%String") [ SqlProc ]
{
}

ClassMethod QryEvReportExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateType As %String, aDateFrom As %String, aDateTo As %String, aMonitorLoc As %String, aItemID As %String, aStatusCode As %String = "", aFlowFlg As %String = "", aStandard As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	//Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
 	Quit:(aHospIDs="")||(aDateFrom="")||(aDateTo="") $$$OK
 	Set RepIDList=$lb("")
 	Set NIndex="QryEvReport"
	Kill ^TMP($zn,$j,NIndex)
 	For xDate = aDateFrom:1:aDateTo{
	 	Set xID = ""
	 	if (aDateType="ApplyDate") {
		 	For {
				Set xID = $o(^DHCHAI.IR.EnviHyReportI("IndexOnApplyDate",xDate,xID))
				Quit:xID=""
				continue:$lf(RepIDList,xID)>0
				Set RepIDList=RepIDList_$lb(xID)
				Set ReCheckRepID=..GetReCheckRepID(xID)
				Set:ReCheckRepID'="" RepIDList=RepIDList_ReCheckRepID
			}
		 }else{
		 	For {
				Set xID = $o(^DHCHAI.IR.EnviHyReportI("IndexOnMonitorDate",xDate,xID))
				Quit:xID=""
				continue:$lf(RepIDList,xID)>0
				Set RepIDList=RepIDList_$lb(xID)
				Set ReCheckRepID=..GetReCheckRepID(xID)
				Set:ReCheckRepID'="" RepIDList=RepIDList_ReCheckRepID
			}
		 }
 	}
 	for i=1:1:$ll(RepIDList) {
	 	Set xID=$lg(RepIDList,i)
	 	continue:xID=""
	 	Set objRep = ##class(DHCHAI.IR.EnviHyReport).GetObjById(xID)
		Continue:'$IsObject(objRep)
		
		Set (HospID,HospDesc,EvItemID,EvItemDesc,EvItemObjID,EvItemObjDesc,RepStatusID,RepStatusCode,RepStatusDescApplyLocID,ApplyLocDesc,ApplyUserID,ApplyUserDesc,RepLocID,RepLocDesc,RepUserID,RepUserDesc,StandardID,StandardDesc,MonitorLocID,MonitorLocDesc)=""
		Set BarCode = ##class(DHCHAI.IR.EnviHyReport).GetBarCode(xID)
		Set objEvItem 		= objRep.EHItemDr
		Continue:'$IsObject(objEvItem)
		Set EvItemSpenNum 	= objEvItem.EHSpecimenNum
		Set SpenTypeDesc	= objEvItem.EHSpecimenTypeDr.BTDesc	// 标本类型
		Set NormDesc		= objEvItem.EHNorm           		// 检测标准
		Set NormMax			= objEvItem.EHNormMax          		// 中心值
		Set NormMin			= objEvItem.EHNormMin          		// 周边值
		Set CenterNum		= objEvItem.EHCenterNum        		// 中心个数
		Set SurroundNum		= objEvItem.EHSurroundNum      		// 周边个数
		Set EvItemID 		= objEvItem.%Id()
		Set EvItemDesc 		= objEvItem.EHItemDesc
		Set IsObjNull 		= objEvItem.EHIsObjNull
		Continue:(aItemID'="")&&(aItemID'=EvItemID)
		
		Set objItemObj 		= objRep.EHItemObjDr
		If $IsObject(objItemObj){
			Set EvItemObjID = objItemObj.%Id()
			Set EvItemObjDesc = objItemObj.EHObjDesc
		}
		Set EHItemObjTxt=objRep.EHItemObjTxt
		//Set:EvItemObjDesc="" EvItemObjDesc=EHItemObjTxt
		//导出功能前台不能拼接，需要后台拼接
		if (EvItemObjDesc="")&&(EHItemObjTxt'=""){
			Set EvItemObjDesc = "["_EHItemObjTxt_"]"
		}elseif(EHItemObjTxt'="")&&(EvItemObjDesc'=""){
			Set EvItemObjDesc = EvItemObjDesc_"["_EHItemObjTxt_"]"
		}elseif(EHItemObjTxt ="")&&(EvItemObjDesc =""){
			Set EvItemObjDesc = ""
		}
		Set objRepStatus 	= objRep.EHRepStatus
		If $IsObject(objRepStatus){
			Set RepStatusID = objRepStatus.%Id()
			Set RepStatusCode = objRepStatus.BTCode
			Set RepStatusDesc = objRepStatus.BTDesc
		}
		Continue:((aStatusCode="")&&(RepStatusCode="0"))
		if aFlowFlg'=""{
			Set UndoFlg = ..CheckOperUndo(xID,aStatusCode)
			if aStatusCode=1{ //材料发放
				Continue:'((RepStatusCode="1")||((RepStatusCode'="1")&&(UndoFlg=1)))
			}ElseIf aStatusCode="2" { //标本接收
				Continue:'((RepStatusCode="2")||((RepStatusCode'="2")&&(UndoFlg=1)))
			} ElseIf aStatusCode="3" { //录入结果
				Continue:'((RepStatusCode="3")||((RepStatusCode'="3")&&(UndoFlg=1)))
			}
		}else{
			Continue:(aStatusCode'="")&&(aStatusCode'=RepStatusCode)
		}
		Set MonitorDate 	= objRep.EHMonitorDate
		Set:MonitorDate'="" MonitorDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(MonitorDate)
		Set ApplyDate 		= objRep.EHApplyDate
		Set:ApplyDate'="" ApplyDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ApplyDate)
		Set ApplyTime 		= objRep.EHApplyTime
		Set:ApplyTime'="" ApplyTime = $zt(ApplyTime)
		Set objApplyLoc 	= objRep.EHApplyLocDr
		If $IsObject(objApplyLoc){
			Set ApplyLocID = objApplyLoc.%Id()
			If objApplyLoc.BTDesc2=""{
				Set ApplyLocDesc = objApplyLoc.BTDesc
			}else{
				Set ApplyLocDesc = objApplyLoc.BTDesc2
			}
			Set objHosp = objApplyLoc.BTHospDr
			If $IsObject(objHosp){
				Set HospID = objHosp.%Id()
				If objHosp.BTDesc2=""{
					Set HospDesc = objHosp.BTDesc
				}else{
					Set HospDesc = objHosp.BTDesc2
				}
				
			}
		}
		Set objMonitorLoc 	= objRep.EHMonitorLocDr
		If $IsObject(objMonitorLoc){
			Set MonitorLocID = objMonitorLoc.%Id()
			If objMonitorLoc.BTDesc2=""{
				Set MonitorLocDesc = objMonitorLoc.BTDesc
			}else{
				Set MonitorLocDesc = objMonitorLoc.BTDesc2
			}
			Set objHosp = objMonitorLoc.BTHospDr
			If $IsObject(objHosp){
				Set HospID = objHosp.%Id()
				If objHosp.BTDesc2=""{
					Set HospDesc = objHosp.BTDesc
				}else{
					Set HospDesc = objHosp.BTDesc2
				}
			}
		}
		Set:MonitorLocID="" MonitorLocID=ApplyLocID,MonitorLocDesc=ApplyLocDesc
		Continue:("|"_aHospIDs_"|")'[("|"_HospID_"|")
		Continue:(aMonitorLoc'="")&&(aMonitorLoc'=MonitorLocID)
		
		Set objApplyUser 	= objRep.EHApplyUserDr
		If $IsObject(objApplyUser){
			Set ApplyUserID = objApplyUser.%Id()
			Set ApplyUserDesc = objApplyUser.BTDesc
		}
		Set SpecimenNum 	= +objRep.EHSpecimenNum
		Set RepCenterNum 	= +objRep.EHCenterNum
		Set RepSurroundNum 	= +objRep.EHSurroundNum
		Set RepDate 		= objRep.EHRepDate
		Set:RepDate'="" RepDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
		Set RepTime 		= objRep.EHRepTime
		Set:RepTime'="" RepTime = $zt(RepTime)
		Set objRepLoc 		= objRep.EHRepLocDr
		If $IsObject(objRepLoc){
			Set RepLocID = objRepLoc.%Id()
			If objRepLoc.BTDesc2=""{
				Set RepLocDesc = objRepLoc.BTDesc
			}else{
				Set RepLocDesc = objRepLoc.BTDesc2
			}
		}
		Set objRepUser 		= objRep.EHRepUserDr
		If $IsObject(objRepUser){
			Set RepUserID = objRepUser.%Id()
			Set RepUserDesc = objRepUser.BTDesc
		}
		Set objStandard 	= objRep.EHStandard
		Set StandardDesc=""
		Set StandardYN=""
		If $IsObject(objStandard){
			Set StandardID = objStandard.%Id()
			Set StandardDesc = objStandard.BTDesc
			Set:StandardDesc["不" StandardYN="N"
			Set:StandardYN="" StandardYN="Y"
		}
		Continue:((aStandard'="")&&(StandardYN'="")&&(aStandard'[StandardYN))
		Continue:((aStandard'="")&&(StandardDesc=""))
		Set Resume 			= objRep.EHResume
		Set ReCheckRepID 	= +objRep.EHReCheckRepDr
		Set ReStatusCode = ""
		Set xReRepID=$o(^DHCHAI.IR.EnviHyReportI("IdxReCheckRepDr"," "_xID,""),-1)
		Set objReCheck = ##class(DHCHAI.IR.EnviHyReport).GetObjById(xReRepID)
		If ($IsObject(objReCheck)&&($IsObject(objReCheck.EHRepStatus))){
			//报告状态
			Set ReStatusCode=objReCheck.EHRepStatus.BTCode
		}
		Set IsChecked = ""  //不合格报告是否已复检
		Set:ReStatusCode>0 IsChecked=1
		Set ReCheckSign=""
		Set:((IsChecked=1)&&(ReCheckRepID=0)) ReCheckSign=1 ;原始报告
		Set:((ReCheckRepID>0)&&(IsChecked=1)) ReCheckSign=2  ;中间报告
		Set:((ReCheckRepID>0)&&(IsChecked="")) ReCheckSign=3 ;最后报告
		Set ReferToNum = objRep.EHReferToNum
		//录入方式（1按项目、2按标本、3其他[1中心+1周边]）
		Set EnterTypeId="",EnterTypeDesc=""
		If $IsObject(objRep.EHEnterTypeDr){
			Set EnterTypeId=objRep.EHEnterTypeDr.%Id()
			Set EnterTypeDesc=objRep.EHEnterTypeDr.BTDesc
		}
		Set CSurrNum=(+CenterNum)+(+SurroundNum)
		Set SampleResult=""
		If (CSurrNum<EvItemSpenNum){
			Set cntNum=1
			For indBar=(CSurrNum+1):1:EvItemSpenNum {
				Set SubID = $o(^DHCHAI.IR.EnviHyReportI("Result","IndexSpecNumber",xID,indBar,""),-1)
				Set objResult = ##class(DHCHAI.IR.EnviHyRepResult).GetObjById(xID_"||"_SubID)
				If $IsObject(objResult){
					If $IsObject(objResult.EHRstTypeDr){ 
					   Set tRstTypeDesc = objResult.EHRstTypeDr.BTDesc
					   Set SampleResult=SampleResult_",参照值"_cntNum_":"_tRstTypeDesc
					   Set cntNum = cntNum+1
					}
				}
			}
		}
		Set:SampleResult'="" SampleResult=$e(SampleResult,2,$l(SampleResult))
         // 不正确原因和改进措施
        Set Val=##class(DHCHAI.IR.EnviHyReCheck).GetValue(xID)
        Set Reason=$p(Val,"^",1)
        Set Action=$p(Val,"^",2) 
        Set ReCheckReps=""
        Set ReCheckList=##class(DHCHAI.IRS.EnviHyReportSrv).GetReCheckRepID(xID)
        Set:ReCheckList'="" ReCheckReps=$listtoString(ReCheckList)
        //多语言处理
        Set EvItemDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("EHItemDesc",EvItemDesc,"DHCHAI.IR.EnviHyItem")
        Set RepStatusDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",RepStatusDesc,"DHCHAI.BT.Dictionary")
        Set EvItemObjDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("EHObjDesc",EvItemObjDesc,"DHCHAI.IR.EnviHyObject")
        Set MonitorLocDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",MonitorLocDesc,"User.CTLoc")
        Set ApplyLocDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",ApplyLocDesc,"User.CTLoc")
        Set EnterTypeDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",EnterTypeDesc,"DHCHAI.BT.Dictionary")
        Set ApplyUserDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("SSUSRName",ApplyUserDesc,"User.SSUser")
        Set Data = $lb(ind,xID,HospID,HospDesc,BarCode,EvItemID,EvItemDesc,EvItemObjID,EvItemObjDesc,RepStatusID,RepStatusCode,RepStatusDesc,MonitorDate,ApplyDate,ApplyTime,ApplyLocID,ApplyLocDesc,ApplyUserID,ApplyUserDesc,EvItemSpenNum,SpecimenNum,RepDate,RepTime,RepLocID,RepLocDesc,RepUserID,RepUserDesc,StandardID,StandardDesc,Resume,SpenTypeDesc,NormDesc,NormMax,NormMin,CenterNum,SurroundNum,RepCenterNum,RepSurroundNum,ReCheckRepID,IsChecked,ReCheckSign,EHItemObjTxt,MonitorLocID,MonitorLocDesc,ReferToNum,IsObjNull,EnterTypeId,EnterTypeDesc,SampleResult,Reason,Action,ReCheckReps)
		//Set ^TMP($zn,$j,NIndex,xID)=Data
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	 }
	/*Set xxId=""
	For {
		Set xxId=$o(^TMP($zn,$j,NIndex,xxId),-1)
		Quit:xxId=""
		Set Data=$g(^TMP($zn,$j,NIndex,xxId))
		Continue:Data=""
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	 }*/
	KILL ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryEvReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEvReportExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryEvReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEvReportExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     liyi
/// CreatDate：   2018-03-07
/// Description:  查询环境卫生学监测条码当前状态列表
/// Table：       DHCHAI.IR.EnviHyReport,DHCHAI.IR.EnviHyReportLog
/// Input:        aReportID  ：报告ID
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.EnviHyReportSrv","QryBarCodeStatus",152)
Query QryBarCodeStatus(aReportID As %String) As %Query(ROWSPEC = "BarCode:%String,StatusCode:%String,StatusDesc:%String,LogDate:%String,LogTime:%String,LogUser:%String,CurrFlag:%String")
{
}

ClassMethod QryBarCodeStatusExecute(ByRef qHandle As %Binary, aReportID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)

	Set objRep=##class(DHCHAI.IR.EnviHyReport).GetObjById(aReportID)
	Quit:'$IsObject(objRep) $$$OK
	Quit:'$IsObject(objRep.EHRepStatus) $$$OK
	Quit:'$IsObject(objRep.EHItemDr) $$$OK
	
	Set RepStatusCode = objRep.EHRepStatus.BTCode
	Set RepStatusDesc = objRep.EHRepStatus.BTDesc
	Set SpecimenNum   = objRep.EHItemDr.EHSpecimenNum
	Set ApplyDate     = objRep.EHApplyDate
	Set ApplyTime     = objRep.EHApplyTime
	Set RepBarCode = ##class(DHCHAI.IR.EnviHyReport).GetBarCode(aReportID)
	Set:ApplyDate'="" ApplyDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ApplyDate)
	Set:ApplyTime'="" ApplyTime=$zt(ApplyTime,1)
	Set objApplyUser=objRep.EHApplyUserDr
	Set (ApplyUser,ApplyUserID)=""
	If $IsObject(objApplyUser){
		Set ApplyUser   = objApplyUser.BTDesc
		Set ApplyUserID = objApplyUser.%Id()
	}

	Kill BarCodeList
	For indBar=1:1:SpecimenNum {
		Set SpenBarCode=##class(DHCHAI.IR.EnviHyReport).GetSpenBarCode(aReportID,indBar)
		If RepStatusCode="1" {
			Set BarCodeList(SpenBarCode)=$lb(RepStatusCode,RepStatusDesc,ApplyDate,ApplyTime,ApplyUser)
		}else{
			Set SpenBarInfo = ..GetSpenInfo(SpenBarCode)
			Continue:SpenBarInfo=""
			
			Set SpenStatusCode = $p(SpenBarInfo,"^",1)
			Set SpenStatusDesc = $p(SpenBarInfo,"^",2)
			Set OperDate = $p(SpenBarInfo,"^",3)
			Set OperTime = $p(SpenBarInfo,"^",4)
			Set OperUser = $p(SpenBarInfo,"^",6)
			Set:OperDate'="" OperDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OperDate)
			Set:OperTime'="" OperTime=$zt(OperTime,1)
			Set BarCodeList(SpenBarCode)=$lb(SpenStatusCode,SpenStatusDesc,OperDate,OperTime,OperUser)
		}
	}
	Set SpenBarCode=""
	For {
		Set SpenBarCode = $o(BarCodeList(SpenBarCode))
		Quit:SpenBarCode=""
		
		Set BarInfo=$g(BarCodeList(SpenBarCode))
		Set StatusCode=$list(BarInfo,1)
		Set StatusDesc=$list(BarInfo,2)
		Set LogDate=$list(BarInfo,3)
		Set LogTime=$list(BarInfo,4)
		Set LogUser=$list(BarInfo,5)
		Set CurrFlag=""
		Set Data=$lb(SpenBarCode,StatusCode,StatusDesc,LogDate,LogTime,LogUser,CurrFlag)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Kill BarCodeList
	Quit $$$OK
}

ClassMethod QryBarCodeStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryBarCodeStatusExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryBarCodeStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryBarCodeStatusExecute ]
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

/// Creator：     liyi
/// CreatDate：   2018-03-07
/// Description:  查询环境卫生学监测结果
/// Table：       DHCHAI.IR.EnviHyReport,DHCHAI.IR.EnviHyRepResult
/// Input:        aReportID  ：查询代码
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.EnviHyReportSrv","QryResultDetail",47)
Query QryResultDetail(aReportID As %String) As %Query(ROWSPEC = "BarCode:%String,Result:%String,BactID:%String,BactDesc:%String,LogDate:%String,LogTime:%String,LogUserID:%String,LogUserDesc:%String,RstTypeID:%String,RstTypeDesc:%String")
{
}

ClassMethod QryResultDetailExecute(ByRef qHandle As %Binary, aReportID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Set objRep=##class(DHCHAI.IR.EnviHyReport).GetObjById(aReportID)
	Quit:'$IsObject(objRep) $$$OK
	Quit:'$IsObject(objRep.EHItemDr) $$$OK
	
	Set RepBarCode  =##class(DHCHAI.IR.EnviHyReport).GetBarCode(aReportID)
	Set objTypeDr   = objRep.EHEnterTypeDr
	Quit:'$IsObject(objTypeDr) return
	Set EnterTypeCode=objTypeDr.BTCode  //录入方式
	If EnterTypeCode="1" {  //按项目录入结果
		Set SpecimenNum = 1
	} ElseIf EnterTypeCode="3" {  //其他（1中心+1周边）
		Set SpecimenNum=2
	}Else{  // 按标本
		Set SpecimenNum = objRep.EHSpecimenNum
	}
	Set EHCenterNum   = +objRep.EHCenterNum
	Set EHSurroundNum = +objRep.EHSurroundNum
	Set CSurrNum =EHCenterNum+EHSurroundNum
	For indBar=1:1:SpecimenNum {
		Set BarCode=##class(DHCHAI.IR.EnviHyReport).GetSpenBarCode(aReportID,indBar)
		Set SubID = $o(^DHCHAI.IR.EnviHyReportI("Result","IndexSpecNumber",aReportID,indBar,""),-1)
		Set (Result,BactID,BactDesc,LogDate,LogTime,LogUserID,LogUserDesc,RstTypeID,RstTypeDesc)=""
		Set objResult = ##class(DHCHAI.IR.EnviHyRepResult).GetObjById(aReportID_"||"_SubID)
		If $IsObject(objResult){
			Set Result = objResult.EHResult
			Set objBact = objResult.EHBactDr
			If $IsObject(objBact){
				Set BactID		= objBact.%Id()
				Set BactDesc	= objBact.BTBacDesc
			}
			If $IsObject(objResult.EHRstTypeDr){ 
			   Set RstTypeID = objResult.EHRstTypeDr.%Id()
			   Set RstTypeDesc = objResult.EHRstTypeDr.BTDesc
			}
		}
		
		
		Set objStatus=##class(DHCHAI.BT.Dictionary).GetObjByCode("EHRepStatus",4)
		Set StatusDr=objStatus.%Id()
		Set SubLogID = $o(^DHCHAI.IR.EnviHyReportI("Log","IndexOnSpenBarCodeStatus",BarCode,StatusDr,aReportID,""),-1)
		Set objLog = ##class(DHCHAI.IR.EnviHyReportLog).GetObjById(aReportID_"||"_SubLogID)
		If $IsObject(objLog){
			if (BactID'="")||(Result'="")||(RstTypeID'=""){  // 修复bug：
				Set LogDate 	= ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(objLog.EHUpdateDate)
				Set LogTime		= $zt(objLog.EHUpdateTime)
                if $IsObject(objLog.EHUpdateUserDr){
                    Set LogUserID   = objLog.EHUpdateUserDr.%Id()
                    Set LogUserDesc = objLog.EHUpdateUserDr.BTDesc
                }
			}
		}
		If (indBar>CSurrNum){
			Set BarCode=BarCode_"(参照点)"	
		}
		Set Data=$lb(BarCode,Result,BactID,BactDesc,LogDate,LogTime,LogUserID,LogUserDesc,RstTypeID,RstTypeDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryResultDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryResultDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryResultDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryResultDetailExecute ]
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

/// Creator：     liyi
/// CreatDate：   2018-02-28
/// Description:  通过标本条码获取结果
/// Table：       DHCHAI.IR.EnviHyRepResult
/// Input：       aSpenBarCode
/// Return：      返回String
/// w ##class(DHCHAI.IRS.EnviHyReportSrv).GetResultBySpenBar("0000000101")
ClassMethod GetResultBySpenBar(aSpenBarCode As %String) As %String
{
	New (aSpenBarCode)
	Set return = ""
	Quit:aSpenBarCode="" return
	
	Set RepID = ..GetRepIDBySpenBar(aSpenBarCode)
	Quit:RepID="" return
	
	Set SubID = $o(^DHCHAI.IR.EnviHyReportI("Result","IndexOnSpenBarCode",aSpenBarCode,RepID,""),-1)
	Quit:SubID="" return

	Set objResult = ##class(DHCHAI.IR.EnviHyRepResult).GetObjById(RepID_"||"_SubID)
	Quit:'$IsObject(objResult) return
	
	Set Result = objResult.EHResult
	Set objBact = objResult.EHBactDr
	Set BactID="",BactDesc=""
	If $IsObject(objBact){
		Set BactID=objBact.%Id()
		Set BactDesc=objBact.BTBacDesc
	}
	Set SpenBarCode = objResult.EHSpenBarCode
	
	Set return = SpenBarCode_"^"_Result_"^"_BactID_"^"_BactDesc
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2018-02-28
/// Description:  通过标本条码获取标本信息
/// Input：       aSpenBarCode
/// Return：      返回String
/// w ##class(DHCHAI.IRS.EnviHyReportSrv).GetSpenInfo("0000000601")
ClassMethod GetSpenInfo(aSpenBarCode As %String) As %String
{
	New (aSpenBarCode)
	Set return = ""
	Quit:aSpenBarCode="" return

	Set RepID = ..GetRepIDBySpenBar(aSpenBarCode)
	Quit:RepID="" return
	
	If $d(^DHCHAI.IR.EnviHyReportI("Log","IndexOnSpenBarCode",aSpenBarCode,RepID)){
		Set SubID = $o(^DHCHAI.IR.EnviHyReportI("Log","IndexOnSpenBarCode",aSpenBarCode,RepID,""),-1)
		Set objLog = ##class(DHCHAI.IR.EnviHyReportLog).GetObjById(RepID_"||"_SubID)
		Set SpenStausCode =  objLog.EHUpdateStatusDr.BTCode
		Set SpenStausDesc =  objLog.EHUpdateStatusDr.BTDesc
		Set UpdateDate	  =  objLog.EHUpdateDate
		Set UpdateTime    =  objLog.EHUpdateTime
		Set objUser       =  objLog.EHUpdateUserDr
		Set objLoc   	  =  objLog.EHUpdateLocDr
		Set return = SpenStausCode_"^"_SpenStausDesc_"^"_UpdateDate_"^"_UpdateTime_"^"_objUser.%Id()_"^"_objUser.BTDesc_"^"_objLoc.%Id()_"^"_objLoc.BTDesc
	}else{
		Set objRep = ##class(DHCHAI.IR.EnviHyReport).GetObjById(RepID)
		Set RepStatusCode = objRep.EHRepStatus.BTCode
		Set RepStatusDesc = objRep.EHRepStatus.BTDesc
		Set xSubID= ""
		For {
			Set xSubID = $o(^DHCHAI.IR.EnviHyReportD(RepID,"Log",xSubID))
			Quit:xSubID=""
			
			Set objLog = ##class(DHCHAI.IR.EnviHyReportLog).GetObjById(RepID_"||"_xSubID)
			COntinue:'$IsObject(objLog)
			COntinue:objLog.EHSpenBarCode'=""
			
			if objLog.EHUpdateStatusDr.BTCode=1{
				Set SpenStausCode =objLog.EHUpdateStatusDr.BTCode
				Set SpenStausDesc =objLog.EHUpdateStatusDr.BTDesc
				Set UpdateDate	  =  objLog.EHUpdateDate
				Set UpdateTime    =  objLog.EHUpdateTime
				Set objUser       =  objLog.EHUpdateUserDr
				Set objLoc   	  =  objLog.EHUpdateLocDr
				Set return = SpenStausCode_"^"_SpenStausDesc_"^"_UpdateDate_"^"_UpdateTime_"^"_objUser.%Id()_"^"_objUser.BTDesc_"^"_objLoc.%Id()_"^"_objLoc.BTDesc
			}
		}
	}
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2018-02-28
/// Description:  根据标本条码获取报告ID
/// Input：       aSpenBarCode
/// Return：      返回String
/// w ##class(DHCHAI.IRS.EnviHyReportSrv).GetRepIDBySpenBar("0000000501")
ClassMethod GetRepIDBySpenBar(aSpenBarCode As %String) As %String
{
	New (aSpenBarCode)
	Set return=""
	Quit:aSpenBarCode="" return
	Quit:$length(aSpenBarCode)'=10 return
	
	Set ReportID = +($e(aSpenBarCode,0,8))
	Set obj = ##class(DHCHAI.IR.EnviHyReport).GetObjById(ReportID)
	Quit:'$IsObject(obj) return
	
	Quit ReportID
}

/// Creator：     liyi
/// CreatDate：   2018-02-28
/// Description:  判断是否还有标本在某个状态（申请、材料发放、标本接收、结果录入）
/// Input：       aRepID、aStatusCode
/// Return：      1:有 0:无
/// w ##class(DHCHAI.IRS.EnviHyReportSrv).CheckOperUndo("1",1)
ClassMethod CheckOperUndo(aRepID As %String, aStatusCode As %String) As %String
{
	New (aRepID,aStatusCode)
	Set return=0
	Quit:(aRepID="")||(aStatusCode="") return
	
	Set objStatus = ##class(DHCHAI.BT.Dictionary).GetObjByCode("EHRepStatus",aStatusCode)
	Quit:'$IsObject(objStatus) return
	
	Set objRep = ##class(DHCHAI.IR.EnviHyReport).GetObjById(aRepID)
	Quit:'$IsObject(objRep) return
	Quit:'$IsObject(objRep.EHItemDr) return
	
	Set SpecimenNum   = objRep.EHItemDr.EHSpecimenNum
	Set RepBarCode = ##class(DHCHAI.IR.EnviHyReport).GetBarCode(aRepID)
	For indBar=1:1:SpecimenNum {
		Set SpenBarCode=##class(DHCHAI.IR.EnviHyReport).GetSpenBarCode(aRepID,indBar)
		Set SpenInfo = ..GetSpenInfo(SpenBarCode)
		Set SpenStausCode = $p(SpenInfo,"^",1)
		if SpenStausCode=aStatusCode{
			Set return = 1
		}
	}
	Quit return
}

/// 获得近7日内环境卫生监测报告报告不合格数据
/// w ##class(DHCHAI.IRS.EnviHyReportSrv).GetRemindEnvRt()
ClassMethod GetRemindEnvRt(aLocID As %String) As %String
{
	New (aLocID)
	
	Set return=0
	Set objLoc=##class(DHCHAI.BT.Location).GetObjById(aLocID)
	Quit:'$IsObject(objLoc) return
	Quit:'$IsObject(objLoc.BTHospDr) return
	Quit:'$IsObject(objLoc.BTHospDr.BTGroupDr) return
	Set HospID=objLoc.BTHospDr.%Id() 	
    Set HospGrpID=objLoc.BTHospDr.BTGroupDr.%Id()
    
	Set Count=0
 	For xDate = (+$h-7):1:(+$h) {
		Set xID=""
		For {
 			Set xID=$o(^DHCHAI.IR.EnviHyReportI("IndexOnMonitorDate",xDate,xID))
			Quit:xID=""	
			
			Set objRep = ##class(DHCHAI.IR.EnviHyReport).GetObjById(xID)
			Continue:'$IsObject(objRep) 
            Set Standard     = objRep.EHStandard.BTCode
            Continue:Standard'=0
            Set objMonitorLoc 	= objRep.EHMonitorLocDr
            Continue:'$IsObject(objMonitorLoc)
			Continue:'$IsObject(objMonitorLoc.BTHospDr)
			Continue:'$IsObject(objMonitorLoc.BTHospDr.BTGroupDr)
			Set tHospGrpID=objMonitorLoc.BTHospDr.BTGroupDr.%Id()
	
			Continue:HospGrpID'=tHospGrpID
			Set objStatus=objRep.EHRepStatus
			Continue:($IsObject(objStatus))&(objStatus.BTCode="4")  //删除状态
		
			Set Count=Count+1	
		}
	}
	
   Set return = Count
   Quit return
}

/// Description:  查询7日内环境卫生学不合格报告
/// Input:        aLocID：登录科室ID
/// Do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.EnviHyReportSrv","QryRemindEnvRt","119")
Query QryRemindEnvRt(aLocID As %String) As %Query(ROWSPEC = "Count:%String") [ SqlProc ]
{
}

ClassMethod QryRemindEnvRtExecute(ByRef qHandle As %Binary, aLocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set objLoc=##class(DHCHAI.BT.Location).GetObjById(aLocID)
	Quit:'$IsObject(objLoc) $$$OK
	Quit:'$IsObject(objLoc.BTHospDr) $$$OK
	Quit:'$IsObject(objLoc.BTHospDr.BTGroupDr) $$$OK
	Set HospID=objLoc.BTHospDr.%Id() 	
    
    Kill arrExpReg
	Set Count=0
 	Set xDate=""
 	For {
 		Set xDate=$o(^DHCHAI.IR.EnviHyReportI("IndexOnMonitorDate",xDate))
		Quit:xDate=""
		Set xID=""
		For {
 			Set xID=$o(^DHCHAI.IR.EnviHyReportI("IndexOnMonitorDate",xDate,xID))
			Quit:xID=""	
			
			Set objReg = ##class(DHCHAI.IR.EnviHyReport).GetObjById(xID)
			Continue:'$IsObject(objReg) 
            Set EvCount     = objReg.EHStandard.BTCode
            Set EvDate      = objReg.EHMonitorDate
            Set EvDateFrom  = $zdh($zdate(+$h,1),1)
            Set EvDateh     = EvDateFrom - EvDate
			Set arrExpReg(xID)=""
			Set:((EvCount=0) & (EvDateh < 7 )) Count=Count+1	
		}
	}

	Kill arrExpReg
	Set ^CacheTemp(repid,ind)=$lb(Count)
	Set ind=ind+1

	Quit $$$OK
}

ClassMethod QryRemindEnvRtClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySpanInfScreenCntExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryRemindEnvRtFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySpanInfScreenCntExecute ]
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

/// w ##class(DHCHAI.IRS.EnviHyReportSrv).GetLastMonth()
ClassMethod GetLastMonth() As %String
{
	//可以通过配置获取需要显示历史申请单的月数
	Set MonthHis=""
	//默认显示历史月份 5个月 (包含当月6个月)
	Set:MonthHis="" MonthHis=5
	Set count=0,json="["
	Set CurrentMonth=$e($zd(+$h,3),1,7)
	//{text:'上呼吸道感染',id:"x1"}
	Set json=json_"{text:'"_CurrentMonth_"',id:"""_CurrentMonth_""",selected:true}"
	While(count<MonthHis) {
		Set tmpdate = CurrentMonth_"-"_01
		Set tmpdate = $zdh(tmpdate,3)
		Set CurrentMonth=$e($zd(tmpdate-1,3),1,7)
		Set count=count+1
		Set json=json_",{text:'"_CurrentMonth_"',id:"""_CurrentMonth_"""}"
	}
	Set json=json_"]"
	Quit json
}

/// Description:  查询监测报告单
/// Table：       DHCHAI.IR.EnviHyReport
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.EnviHyReportSrv","QryEvReportByMonth","1|2","2019-09")
Query QryEvReportByMonth(aHospIDs As %String, aMonth As %String, aMonitorLoc As %String = "") As %Query(ROWSPEC = "ReportID:%String,HospID:%String,HospDesc:%String,BarCode:%String,EvItemID:%String,EvItemDesc:%String,EvItemObjID:%String,EvItemObjDesc:%String,EHItemObjTxt:%String,RepStatusID:%String,RepStatusCode:%String,RepStatusDesc:%String,MonitorDate:%String,ApplyDate:%String,ApplyTime:%String,ApplyLocID:%String,ApplyLocDesc:%String,ApplyUserID:%String,ApplyUserDesc:%String,EvItemSpenNum:%String,SpecimenNum:%String,RepDate:%String,RepTime:%String,RepLocID:%String,RepLocDesc:%String,RepUserID:%String,RepUserDesc:%String,StandardID:%String,StandardDesc:%String,Resume:%String,SpenTypeDesc:%String,NormDesc:%String,NormMax:%String,NormMin:%String,CenterNum:%String,SurroundNum:%String,RepCenterNum:%String,RepSurroundNum:%String,MonitorLocID:%String,MonitorLocDesc:%String,ReferToNum:%String") [ SqlProc ]
{
}

ClassMethod QryEvReportByMonthExecute(ByRef qHandle As %Binary, aHospIDs As %String, aMonth As %String, aMonitorLoc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
 	//Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
 	Quit:(aHospIDs="")||(aMonth="") $$$OK
 	Set aDateFrom=$zdh((aMonth_"-01"),3)
 	Set tmpDate=$zd(aDateFrom+32,3)
 	Set tmpDate=$e(tmpDate,1,7)_"-01"
 	Set tmpDate=$zdh(tmpDate,3)-1
 	Set:tmpDate>+$h tmpDate=+$h
 	Set aDateTo=tmpDate
 	For xDate = aDateFrom:1:aDateTo{
	 	Set xID = ""
	 	For {
			Set xID = $o(^DHCHAI.IR.EnviHyReportI("IndexOnMonitorDate",xDate,xID))
			Quit:xID=""
			
			Set objRep = ##class(DHCHAI.IR.EnviHyReport).GetObjById(xID)
			Continue:'$IsObject(objRep)
			
			Set (HospID,HospDesc,EvItemID,EvItemDesc,EvItemObjID,EvItemObjDesc,RepStatusID,RepStatusCode,RepStatusDescApplyLocID,ApplyLocDesc,ApplyUserID,ApplyUserDesc,RepLocID,RepLocDesc,RepUserID,RepUserDesc,StandardID,StandardDesc,MonitorLocID,MonitorLocDesc)=""
			Set BarCode = ##class(DHCHAI.IR.EnviHyReport).GetBarCode(xID)
			Set objEvItem 		= objRep.EHItemDr
			Continue:'$IsObject(objEvItem)
			
			Set EvItemSpenNum 	= objEvItem.EHSpecimenNum
			Set SpenTypeDesc	= objEvItem.EHSpecimenTypeDr.BTDesc	// 标本类型
			Set NormDesc		= objEvItem.EHNorm           		// 检测标准
			Set NormMax			= objEvItem.EHNormMax          		// 中心值
			Set NormMin			= objEvItem.EHNormMin          		// 周边值
			Set CenterNum		= objEvItem.EHCenterNum        		// 中心个数
			Set SurroundNum		= objEvItem.EHSurroundNum      		// 周边个数
			Set EvItemID 		= objEvItem.%Id()
			Set EvItemDesc 		= objEvItem.EHItemDesc			
			Set objItemObj 		= objRep.EHItemObjDr
			If $IsObject(objItemObj){
				Set EvItemObjID = objItemObj.%Id()
				Set EvItemObjDesc = objItemObj.EHObjDesc
			}
			Set objRepStatus 	= objRep.EHRepStatus
			If $IsObject(objRepStatus){
				Set RepStatusID = objRepStatus.%Id()
				Set RepStatusCode = objRepStatus.BTCode
				Set RepStatusDesc = objRepStatus.BTDesc
			}
			Continue:RepStatusDesc="删除"
			Set MonitorDate 	= objRep.EHMonitorDate
			Set:MonitorDate'="" MonitorDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(MonitorDate)
			Set ApplyDate 		= objRep.EHApplyDate
			Set:ApplyDate'="" ApplyDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ApplyDate)
			Set ApplyTime 		= objRep.EHApplyTime
			Set:ApplyTime'="" ApplyTime = $zt(ApplyTime)
			Set objApplyLoc 	= objRep.EHApplyLocDr
			If $IsObject(objApplyLoc){
				Set ApplyLocID = objApplyLoc.%Id()
				If objApplyLoc.BTDesc2=""{
					Set ApplyLocDesc = objApplyLoc.BTDesc
				}else{
					Set ApplyLocDesc = objApplyLoc.BTDesc2
				}
				Set objHosp = objApplyLoc.BTHospDr
				If $IsObject(objHosp){
					Set HospID = objHosp.%Id()
					Set HospDesc = objHosp.BTDesc2
				}
			}
			Set objMonitorLoc 	= objRep.EHMonitorLocDr
			If $IsObject(objMonitorLoc){
				Set MonitorLocID = objMonitorLoc.%Id()
				If objMonitorLoc.BTDesc2=""{
					Set MonitorLocDesc = objMonitorLoc.BTDesc
				}else{
					Set MonitorLocDesc = objMonitorLoc.BTDesc2
				}
				Set objHosp = objMonitorLoc.BTHospDr
				If $IsObject(objHosp){
					Set HospID = objHosp.%Id()
					Set HospDesc = objHosp.BTDesc2
				}
			}
			Set:MonitorLocID="" MonitorLocID=ApplyLocID,MonitorLocDesc=ApplyLocDesc
			Continue:("|"_aHospIDs_"|")'[("|"_HospID_"|")
			Continue:(aMonitorLoc'="")&&(aMonitorLoc'=MonitorLocID)	
			Set objApplyUser 	= objRep.EHApplyUserDr
			If $IsObject(objApplyUser){
				Set ApplyUserID = objApplyUser.%Id()
				Set ApplyUserDesc = objApplyUser.BTDesc
			}
			Set SpecimenNum 	= +objRep.EHSpecimenNum
			Set RepCenterNum 	= +objRep.EHCenterNum
			Set RepSurroundNum 	= +objRep.EHSurroundNum
			Set RepDate 		= objRep.EHRepDate
			Set:RepDate'="" RepDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
			Set RepTime 		= objRep.EHRepTime
			Set:RepTime'="" RepTime = $zt(RepTime)
			Set objRepLoc 		= objRep.EHRepLocDr
			If $IsObject(objRepLoc){
				Set RepLocID = objRepLoc.%Id()
				If objRepLoc.BTDesc2=""{
					Set RepLocDesc = objRepLoc.BTDesc
				}else{
					Set RepLocDesc = objRepLoc.BTDesc2
				}
			}
			Set objRepUser 		= objRep.EHRepUserDr
			If $IsObject(objRepUser){
				Set RepUserID = objRepUser.%Id()
				Set RepUserDesc = objRepUser.BTDesc
			}
			Set objStandard 	= objRep.EHStandard
			If $IsObject(objStandard){
				Set StandardID = objStandard.%Id()
				Set StandardDesc = objStandard.BTDesc
			}
			Set Resume 			= objRep.EHResume
			Set ReferToNum 		= objRep.EHReferToNum
			Set EHItemObjTxt	= objRep.EHItemObjTxt
			Set Data = $lb(xID,HospID,HospDesc,BarCode,EvItemID,EvItemDesc,EvItemObjID,EvItemObjDesc,EHItemObjTxt,RepStatusID,RepStatusCode,RepStatusDesc,MonitorDate,ApplyDate,ApplyTime,ApplyLocID,ApplyLocDesc,ApplyUserID,ApplyUserDesc,EvItemSpenNum,SpecimenNum,RepDate,RepTime,RepLocID,RepLocDesc,RepUserID,RepUserDesc,StandardID,StandardDesc,Resume,SpenTypeDesc,NormDesc,NormMax,NormMin,CenterNum,SurroundNum,RepCenterNum,RepSurroundNum,MonitorLocID,MonitorLocDesc,ReferToNum)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1	
		}
 	}
	Quit $$$OK
}

ClassMethod QryEvReportByMonthClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEvReportByMonthExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryEvReportByMonthFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEvReportByMonthExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// w ##class(DHCHAI.IRS.EnviHyReportSrv).GetReCheckRepID(90)
ClassMethod GetReCheckRepID(RepID) As %Library.List
{
	new (RepID)
	Set ReCheckFlg=1,RepList=""
	while(ReCheckFlg){
		if ('$d(^DHCHAI.IR.EnviHyReportI("IdxReCheckRepDr"," "_RepID))) {
			Set ReCheckFlg=0
			Quit
		}
		Set RepID=$o(^DHCHAI.IR.EnviHyReportI("IdxReCheckRepDr"," "_RepID,""),-1)
		Set obj = ##class(DHCHAI.IR.EnviHyReport).GetObjById(RepID)
		Quit:'$IsObject(obj)
		Quit:'$IsObject(obj.EHRepStatus)
		//报告状态
		Set StatusCode=obj.EHRepStatus.BTCode
		Quit:StatusCode=0  // 排除删除的报告
		Set:RepList'="" RepList=RepList_$lb(RepID)
		Set:RepList="" RepList=$lb(RepID)
	}
	Quit RepList
}

/// Creator：     zhufei
/// CreatDate：   2019-09-16
/// Description:  发放材料、接收标本等批量操作
/// Input:        aReportIDs  ：报告ID
///               aBarcodes   ：条码(报告条码/标本条码)
///               aStatusCode ：状态代码(1申请、2材料发放、3标本接收、4录入结果、0删除)
///               aLogonLocDr ：登录科室
///               aLogonUserDr：登录用户
/// w ##class(DHCHAI.IRS.EnviHyReportSrv).SaveBactRepOpera("2","0000000201","3","242","8")
ClassMethod SaveBactRepOpera(aReportIDs As %String, aBarcode As %String, aStatusCode As %String, aLogonLocDr As %String, aLogonUserDr As %String)
{
	New (aReportIDs, aBarcode, aStatusCode, aLogonLocDr, aLogonUserDr)
	Set return=0,Count=0
	Quit:(aReportIDs="")&&(aBarcode="") return
	Quit:(aStatusCode="")||(aLogonLocDr="")||(aLogonUserDr="") return
	
	If aReportIDs'="" {
		//生成批次号
		Set BactNumber=##class(DHCHAI.IR.EnviHyReportLog).GetBactNumber()
		TStart
		Set isError=0
		For indRep=1:1:$l(aReportIDs,","){
			Set ReportID=$p(aReportIDs,",",indRep)
			Continue:ReportID=""
			
			Set flg=..SaveReportOpera(ReportID,aBarcode,aStatusCode,aLogonLocDr,aLogonUserDr,BactNumber)
			If (+flg)>0 {
				Set Count=Count+1
			} Else {
				Set isError=1
				TRollback
				Quit
			}
		}
		Quit:isError>0 return
		TCommit
	} Else {
		Set flg=..SaveReportOpera("",aBarcode,aStatusCode,aLogonLocDr,aLogonUserDr,"")
		If (+flg)>0 {
			Set Count=Count+1
		}
	}
	Set return=Count
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2019-09-20
/// Description:  发放材料、接收标本等单条记录的操作
/// Input:        aReportID   ：报告ID
///               aBarcodes   ：条码号
///               aStatusCode ：状态代码(1申请、2材料发放、3标本接收、4录入结果、0删除)
///               aLogonLocDr ：登录科室
///               aLogonUserDr：登录用户
/// w ##class(DHCHAI.IRS.EnviHyReportSrv).SaveReportOpera("3","","3","242","8")
ClassMethod SaveReportOpera(aReportID As %String, aBarcode As %String, aStatusCode As %String, aLogonLocDr As %String, aLogonUserDr As %String, aBactNumber As %String = "") As %String
{
	New (aReportID, aBarcode, aStatusCode, aLogonLocDr, aLogonUserDr, aBactNumber)
	Set return=0,Count=0
	Quit:(aReportID="")&&(aBarcode="") return
	Quit:(aStatusCode="")||(aLogonLocDr="")||(aLogonUserDr="") return
	
	//生成报告ID
	If aReportID="" {
		Set ReportID=+$e(aBarcode,0,8)
	} Else {
		Set ReportID=aReportID
	}
	Quit:ReportID<1 return
	
	Set objStatus=##class(DHCHAI.BT.Dictionary).GetObjByCode("EHRepStatus",aStatusCode)
	Quit:'$IsObject(objStatus) return
	Set StatusCode=objStatus.BTCode
	
	Set objRep=##Class(DHCHAI.IR.EnviHyReport).GetObjById(ReportID)
	Quit:'$IsObject(objRep) return
	Set ReportID=objRep.%Id()
	
	Set $ZT="SaveReportOperaXErr"
	
	TStart
	
	//保存操作日志
	Set return="-1^保存操作日志失败"
	Set InputStr=ReportID_"^"_aLogonLocDr_"^"_aLogonUserDr_"^"_StatusCode_"^"_aBarcode_"^"_aBactNumber_"^"_1
	Set flg=##Class(DHCHAI.IR.EnviHyReportLog).Update(InputStr,"^")	// 标本日志
	If (+flg)<1 {
		TRollback
		Quit return
	}
	
	//更新报告状态信息
	Set return="-1^更新报告状态信息失败"
	Set InputStr=ReportID
	Set InputStr=InputStr_"^"_StatusCode
	Set InputStr=InputStr_"^"_aLogonLocDr
	Set InputStr=InputStr_"^"_aLogonUserDr
	Set flg=##class(DHCHAI.IR.EnviHyReport).UpdateStatus(InputStr)
	If (+flg)<1 {
		TRollback
		Quit return
	}
	Set ReportID=+flg
	
	TCommit
	
	Set return=ReportID
	Quit return
	
SaveReportOperaXErr
	TRollback
	Quit "-999^"_$ZError
}

/// 获取报告信息
/// w ##class(DHCHAI.IRS.EnviHyReportSrv).GetReportInfo("","22071200201")
ClassMethod GetReportInfo(aReportID As %String, aBarcode As %String = "") As %String
{
	New (aReportID,aBarcode)
	Set return=""
	Quit:(aReportID="")&&(aBarcode="") return
	If (aReportID'=""){
		Set ReportID=aReportID
	}elseif($l(aBarcode)>=11){
		
		Set RepApplayDate="20"_$e(aBarcode,1,6)
		Set RepApplayDate=$zdh(RepApplayDate,8)
		Set RepOrderCode=+$e(aBarcode,7,9)
		Set ReportID = $o(^DHCHAI.IR.EnviHyReportI("IdxApplyCode",RepApplayDate,RepOrderCode,""))
	}else{
		
		Set aBarcode=..BarCodeFormat(aBarcode)
		Set ReportID=+($e(aBarcode,1,8))
	}
	Quit:ReportID="" return
	Set objRep=##class(DHCHAI.IR.EnviHyReport).GetObjById(ReportID)
	Quit:'$IsObject(objRep) return
	Quit:'$IsObject(objRep.EHItemDr) return       //监测项目不允许为空
	Quit:'$IsObject(objRep.EHRepStatus) return    //状态不允许为空
	Quit:'$IsObject(objRep.EHEnterTypeDr) return  //录入方式不允许为空
	Set ReportID=objRep.%Id()
	//监测项目
	Set ItemDesc=objRep.EHItemDr.EHItemDesc        //项目名称
	Set SpecTypeCode="",SpecTypeDesc=""            //标本类型
	If $IsObject(objRep.EHItemDr.EHSpecimenTypeDr){
		Set SpecTypeCode=objRep.EHItemDr.EHSpecimenTypeDr.BTCode
		Set SpecTypeDesc=objRep.EHItemDr.EHSpecimenTypeDr.BTDesc
	}
	Set Norm=objRep.EHItemDr.EHNorm                //标准单位（例；个/30min?φ90皿）
	Set NormMax=objRep.EHItemDr.EHNormMax          //正常上限（注：中心值,周边值,参考值）
	Set NormMin=objRep.EHItemDr.EHNormMin          //正常下限（注：中心值,周边值,参考值）
	Set ForMula=objRep.EHItemDr.EHForMula          //计算公式
	Set ItemUom=objRep.EHItemDr.EHUom              //单位（例：cfu/cm2）
	Set IsObjNull=objRep.EHItemDr.EHIsObjNull      //下申请时是否允许对象为空
		
	//监测对象
	Set ItemObjID="",ItemObjDesc=""
	If $IsObject(objRep.EHItemObjDr){
		Set ItemObjID=objRep.EHItemObjDr.%Id()
		Set ItemObjDesc=objRep.EHItemObjDr.EHObjDesc
	}
	Set txtResume=objRep.EHResume
	Set ItemObjTxt=objRep.EHItemObjTxt
	//监测日期
	Set MonitorDate=objRep.EHMonitorDate
	Set:MonitorDate'="" MonitorDate=$zd(MonitorDate,3)
	//报告状态
	Set StatusCode=objRep.EHRepStatus.BTCode
	Set StatusDesc=objRep.EHRepStatus.BTDesc
	Set IsAllDone=objRep.EHIsAllDone
	//标本数量、中心点个数、周边点个数、参照点个数
	Set SpecimenNum=objRep.EHSpecimenNum
	Set CenterNum=objRep.EHCenterNum
	Set SurroundNum=objRep.EHSurroundNum
	Set ReferToNum=objRep.EHReferToNum
	Set SpecimenNum=+SpecimenNum
	Set CenterNum=+CenterNum
	Set SurroundNum=+SurroundNum
	Set ReferToNum=+ReferToNum
	//达标情况
	Set StandardCode="",StandardDesc=""
	If $IsObject(objRep.EHStandard){
		Set StandardCode=objRep.EHStandard.BTCode
		Set StandardDesc=objRep.EHStandard.BTDesc
	}
	//录入方式（1按项目、2按标本、3其他[1中心+1周边]）
	Set EnterTypeCode=objRep.EHEnterTypeDr.BTCode
	Set EnterTypeDesc=objRep.EHEnterTypeDr.BTDesc
	
	//是否复检、复检指针（指向原报告）
	Set IsReCheck=objRep.EHIsReCheck
	Set ReCheckRepDr=""
	If $IsObject(objRep.EHReCheckRepDr){
		Set ReCheckRepDr=objRep.EHReCheckRepDr.%Id()
	}
	
	//申请日期、时间、科室、申请人
	Set ApplyDate=objRep.EHApplyDate
	Set:ApplyDate'="" ApplyDate=$zd(ApplyDate,3)
	Set ApplyTime=objRep.EHApplyTime
	Set:ApplyTime'="" ApplyTime=$zt(ApplyTime,1)
	Set ApplyLoc=""
	If $IsObject(objRep.EHApplyLocDr){
		Set ApplyLoc=objRep.EHApplyLocDr.BTDesc
	}
	Set ApplyUser=""
	If $IsObject(objRep.EHApplyUserDr){
		Set ApplyUser=objRep.EHApplyUserDr.BTDesc
	}
	
	//采集日期、时间、采集人
	Set CollDate=objRep.EHCollDate
	Set:CollDate'="" CollDate=$zd(CollDate,3)
	Set CollTime=objRep.EHCollTime
	Set:CollTime'="" CollTime=$zt(CollTime,1)
	Set CollUser=""
	If $IsObject(objRep.EHCollUserDr){
		Set CollUser=objRep.EHCollUserDr.BTDesc
	}
	
	//接收日期、时间、接收者
	Set RecDate=objRep.EHRecDate
	Set:RecDate'="" RecDate=$zd(RecDate,3)
	Set RecTime=objRep.EHRecTime
	Set:RecTime'="" RecTime=$zt(RecTime,1)
	Set RecUser=""
	If $IsObject(objRep.EHRecUserDr){
		Set RecUser=objRep.EHRecUserDr.BTDesc
	}
	
	//报告日期、时间、科室、报告人
	Set RepDate=objRep.EHRepDate
	Set:RepDate'="" RepDate=$zd(RepDate,3)
	Set RepTime=objRep.EHRepTime
	Set:RepTime'="" RepTime=$zt(RepTime,1)
	Set RepLoc=""
	If $IsObject(objRep.EHRepLocDr){
		Set RepLoc=objRep.EHRepLocDr.BTDesc
	}
	Set RepUser=""
	If $IsObject(objRep.EHRepUserDr){
		Set RepUser=objRep.EHRepUserDr.BTDesc
	}
	
	Set return=ReportID
	Set return=return_"^"_aBarcode
	Set return=return_"^"_ItemDesc
	Set return=return_"^"_SpecTypeCode_"!!"_SpecTypeDesc
	Set return=return_"^"_Norm
	Set return=return_"^"_NormMax
	Set return=return_"^"_NormMin
	Set return=return_"^"_ForMula
	Set return=return_"^"_ItemUom
	Set return=return_"^"_IsObjNull
	Set return=return_"^"_ItemObjID_"!!"_ItemObjDesc_"!!"_ItemObjTxt
	Set return=return_"^"_MonitorDate
	Set return=return_"^"_StatusCode_"!!"_StatusDesc_"!!"_IsAllDone
	Set return=return_"^"_SpecimenNum_"!!"_CenterNum_"!!"_SurroundNum_"||"_ReferToNum
	Set return=return_"^"_StandardCode_"!!"_StandardDesc
	Set return=return_"^"_EnterTypeCode_"!!"_EnterTypeDesc
	Set return=return_"^"_IsReCheck
	Set return=return_"^"_ReCheckRepDr
	Set return=return_"^"_ApplyDate_"!!"_ApplyTime_"!!"_ApplyLoc_"!!"_ApplyUser
	Set return=return_"^"_CollDate_"!!"_CollTime_"!!"_CollUser
	Set return=return_"^"_RecDate_"!!"_RecTime_"!!"_RecUser
	Set return=return_"^"_RepDate_"!!"_RepTime_"!!"_RepLoc_"!!"_RepUser
	Set return=return_"^"_txtResume
	Quit return
}

/// 获取报告录入结果
/// w ##class(DHCHAI.IRS.EnviHyReportSrv).GetReportResults(158,"")
ClassMethod GetReportResults(aReportID As %String, aBarcode As %String = "") As %String
{
	New (aReportID,aBarcode)
	Set return=""
	Quit:(aReportID="")&&(aBarcode="") return
	If (aReportID'=""){
		Set ReportID=aReportID
		Set BarNumber=""
	}elseif($l(aBarcode)>=11){
		
		Set RepApplayDate=$e(aBarcode,1,8)
		Set RepApplayDate=$zdh(RepApplayDate,8)
		Set RepOrderCode=+$e(aBarcode,9,11)
		Set ReportID = $o(^DHCHAI.IR.EnviHyReportI("IdxApplyCode",RepApplayDate,RepOrderCode,""))
		Set BarNumber=+($e(aBarcode,12,13))
	}else{
		
		Set aBarcode=..BarCodeFormat(aBarcode)
		Set ReportID=+($e(aBarcode,1,8))
		Set BarNumber=+($e(aBarcode,9,10))
	}
	Quit:ReportID="" return
	
	Set objRep=##class(DHCHAI.IR.EnviHyReport).GetObjById(ReportID)
	Quit:'$IsObject(objRep) return
	Quit:'$IsObject(objRep.EHItemDr) return       //监测项目不允许为空
	Quit:'$IsObject(objRep.EHRepStatus) return    //状态不允许为空
	Quit:'$IsObject(objRep.EHEnterTypeDr) return  //录入方式不允许为空
	Set ReportID=objRep.%Id()
	
	//标本数量、中心点个数、周边点个数、参照点个数
	Set SpecimenNum=objRep.EHSpecimenNum
	Set CenterNum=objRep.EHCenterNum
	Set SurroundNum=objRep.EHSurroundNum
	Set ReferToNum=objRep.EHReferToNum
	Set SpecimenNum=+SpecimenNum
	Set CenterNum=+CenterNum
	Set SurroundNum=+SurroundNum
	Set ReferToNum=+ReferToNum
	//达标情况
	Set StandardCode="",StandardDesc=""
	If $IsObject(objRep.EHStandard){
		Set StandardCode=objRep.EHStandard.BTCode
		Set StandardDesc=objRep.EHStandard.BTDesc
	}
	
	//录入方式（1按项目、2按标本、3其他[1中心+1周边]）
	Set EnterTypeCode=objRep.EHEnterTypeDr.BTCode
	Set EnterTypeDesc=objRep.EHEnterTypeDr.BTDesc
	
	//项目值(中心值、周边值)
	Set SpecNumberList=""
	If EnterTypeCode=1 {
		Set SpecNumberList=SpecNumberList_$lb($lb(1,"项目值"))
		Set EndNumber=1
	} ElseIf EnterTypeCode=2 {
		For indRow=1:1:(SpecimenNum-ReferToNum){
			If (CenterNum>0)||(SurroundNum>0) { //输出中心值、周边值
				If indRow<=CenterNum {
					Set SpecNumberList=SpecNumberList_$lb($lb(indRow,"中心值"_indRow))
				} Else {
					Set SpecNumberList=SpecNumberList_$lb($lb(indRow,"周边值"_indRow))
				}
			} Else {
				If SpecimenNum>1 {
					Set SpecNumberList=SpecNumberList_$lb($lb(indRow,"项目值"_indRow))
				} Else {
					Set SpecNumberList=SpecNumberList_$lb($lb(indRow,"项目值"))
				}
			}
			Set EndNumber=indRow
		}
	} ElseIf EnterTypeCode=3 {
		Set SpecNumberList=SpecNumberList_$lb($lb(1,"中心值"))
		Set SpecNumberList=SpecNumberList_$lb($lb(2,"周边值"))
		Set EndNumber=2
	} Else {
		Quit return
	}
	//参照值
	For indRow=1:1:ReferToNum {
		If ReferToNum>1 {
			Set SpecNumberList=SpecNumberList_$lb($lb(EndNumber+indRow,"参照值"_indRow))
		} Else {
			Set SpecNumberList=SpecNumberList_$lb($lb(EndNumber+indRow,"参照值"))
		}
	}
	
	For indNum=1:1:$ll(SpecNumberList){
		Set tmpSpecNumber=$lg(SpecNumberList,indNum)
		Set SpecNumber=$lg(tmpSpecNumber,1)
		Set SpecNumDesc=$lg(tmpSpecNumber,2)
		Continue:(BarNumber>0)&&(SpecNumber'=BarNumber)
		
		Set (RstTypeCode,RstTypeDesc,Result,BactID,BactDesc)=""
		Set SubID=$o(^DHCHAI.IR.EnviHyReportI("Result","IndexSpecNumber",ReportID,SpecNumber,""))
		If SubID'="" {
			Set objResult=##class(DHCHAI.IR.EnviHyRepResult).GetObjById(ReportID_"||"_SubID)
			If $IsObject(objResult){
				Set RstTypeCode=objResult.EHRstTypeDr.BTCode  //结果类型 "EHRstType"（菌落数、大于、小于、检出菌、未检出、阴性等）
				Set RstTypeDesc=objResult.EHRstTypeDr.BTDesc
				Set Result=objResult.EHResult                 //菌落数
				If $IsObject(objResult.EHBactDr){             //检出菌/致病菌
					Set BactID=objResult.EHBactDr.%Id()
					Set BactDesc=objResult.EHBactDr.BTBacDesc
				}
				Set SpecNumber=objResult.EHSpecNumber         //标本顺序号（大排行）
			}
		}
		Set rowInfo=SpecNumber_"^"_SpecNumDesc_"^"_RstTypeCode_"^"_RstTypeDesc_"^"_Result_"^"_BactID_"^"_BactDesc
		If return'="" {
			Set return=return_"!!"_rowInfo
		} Else {
			Set return=rowInfo
		}
	}
	Quit return
}

/// 保存报告录入结果
/// w ##class(DHCHAI.IRS.EnviHyReportSrv).SaveReportResults("2^^193^8^4","")
ClassMethod SaveReportResults(aBaseInfo As %String, aResultInfo As %String) As %String
{
	New (aBaseInfo,aResultInfo)
	Set return=0
	Quit:(aBaseInfo="")||(aResultInfo="") return
	
	Set ReportID   = $p(aBaseInfo,"^",1)
	Set Barcode    = $p(aBaseInfo,"^",2)
	Set LocID      = $p(aBaseInfo,"^",3)
	Set UserID     = $p(aBaseInfo,"^",4)
	Set StatusCode = $p(aBaseInfo,"^",5)
	Set txtResume  = $p(aBaseInfo,"^",7)
	Quit:(ReportID="")&&(Barcode="") return
	
	If ReportID="" {
		Set ReportID=+$e(Barcode,0,8)
	}
	Set flg=##Class(DHCHAI.IR.EnviHyReport).UpdateResume(ReportID,txtResume)
	Set objRep=##Class(DHCHAI.IR.EnviHyReport).GetObjById(ReportID)
	Quit:'$IsObject(objRep) return
	Quit:'$IsObject(objRep.EHEnterTypeDr) return
	Set SpecimenNum=objRep.EHSpecimenNum
	Set SpecimenNum=+SpecimenNum
	Set ReferToNum=objRep.EHReferToNum
	Set ReferToNum=+ReferToNum
	Set EnterTypeCode=objRep.EHEnterTypeDr.BTCode
	
	Set objStatus=##class(DHCHAI.BT.Dictionary).GetObjByCode("EHRepStatus",StatusCode)
	Quit:'$IsObject(objStatus) return
	
	//Set $ZT="SaveReportResultsErr"
	
	TStart
	
	Set return="-1^保存结果失败"
	Set isError=0
	For indRow=1:1:$l(aResultInfo,"!!"){
		Set tResult=$p(aResultInfo,"!!",indRow)
		Continue:tResult=""
		
		Set SpecNumber  = $p(tResult,"^",1)
		Set SpecNumDesc = $p(tResult,"^",2)
		Set RstTypeCode = $p(tResult,"^",3)
		Set RstTypeDesc = $p(tResult,"^",4)
		Set Result      = $p(tResult,"^",5)
		Set BactID      = $p(tResult,"^",6)
		Set BactDesc    = $p(tResult,"^",7)
		
		Set RstTypeID=""
		Set objRstType=##class(DHCHAI.BT.Dictionary).GetObjByCode("EHRstType",RstTypeCode)
		If $IsObject(objRstType){
			Set RstTypeID=objRstType.%Id()
		}
		
		Set InputStr=ReportID_"^^"_Result_"^"_BactID_"^"_""_"^"_SpecNumber_"^"_RstTypeID
		Set flg=##class(DHCHAI.IR.EnviHyRepResult).Update(InputStr,"^")
		If (+flg)<1 {
			Set isError=1
			Trollback
			Quit
		}
		//保存结果明细操作日志
		Set return="-2^保存操作日志失败"
		Set BarCode=##class(DHCHAI.IR.EnviHyReport).GetSpenBarCode(ReportID,SpecNumber)
		Set InputStr=ReportID_"^"_LocID_"^"_UserID_"^"_StatusCode_"^"_BarCode_"^"_""_"^"_1
		Set flg=##Class(DHCHAI.IR.EnviHyReportLog).Update(InputStr,"^")	// 标本日志
		If (+flg)<1 {
			Trollback
			Quit
		}
	}
	Quit:isError>0 return
	
	
	
	//更新报告状态信息
	Set return="-4^更新报告状态信息失败"
	Set InputStr=ReportID
	Set InputStr=InputStr_"^"_StatusCode
	Set InputStr=InputStr_"^"_LocID
	Set InputStr=InputStr_"^"_UserID
	Set flg=##class(DHCHAI.IR.EnviHyReport).UpdateStatus(InputStr)
	If (+flg)<1 {
		Trollback
		Quit return
	}
	Set ReportID=+flg
	
	TCommit
	
	Set return=ReportID
	Quit return
	
SaveReportResultsErr
	TRollback
	Quit "-999^"_$ZError
}

/// 保存报告录入结果
/// w ##class(DHCHAI.IRS.EnviHyReportSrv).UpdateStatus("","")
ClassMethod UpdateStatus(aReportID As %String, aStatusCode As %String) As %String
{
	New (aReportID,aStatusCode)
	Set return=0
	Quit:(aReportID="")||(aStatusCode="") return
	Set $ZT="UpdateStatusErr"
	Set objStatus=##class(DHCHAI.BT.Dictionary).GetObjByCode("EHRepStatus",aStatusCode)
	Quit:'$IsObject(objStatus) return
	
	Quit:'##class(DHCHAI.IR.EnviHyReport).%ExistsId(+aReportID) return
	
	Set obj=##Class(DHCHAI.IR.EnviHyReport).%OpenId(+aReportID)
	
	Set obj.EHRepStatus = objStatus
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
	
UpdateStatusErr
	Quit "-999^"_$ZError
}

/// 条码格式化
/// w ##class(DHCHAI.IRS.EnviHyReportSrv).BarCodeFormat("22071200201")
ClassMethod BarCodeFormat(aBarcode As %String) As %String
{
	New (aBarcode)
	Set return=""
	Quit:aBarcode="" return
	Quit:(+aBarcode)<1 return
	
	Set BarCode="0000000000"_(+aBarcode)
	Set return=$e(BarCode,$l(BarCode)-9,$l(BarCode))
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2019-09-19
/// Description:  查询监测报告单
/// Table：       DHCHAI.IR.EnviHyReport
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.EnviHyReportSrv","QryReportByDate","1|2","2018-09-01","2019-09-16","","","","")
Query QryReportByDate(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aMonitorLocDr As %String = "", aItemDr As %String = "", aStatusCode As %String = "", aStandardCode As %String = "", aBarCode As %String = "") As %Query(ROWSPEC = "ReportID:%String,ItemID:%String,ItemDesc:%String,ItemObjID:%String,ItemObjDesc:%String,ItemObjTxt:%String,SpecTypeDesc:%String,NormDesc:%String,NormMax:%String,NormMin:%String,StatusID:%String,StatusCode:%String,StatusDesc:%String,IsAllDone:%String,MonitorDate:%String,MonitorLocID:%String,MonitorLocDesc:%String,HospID:%String,HospDesc:%String,SpecimenNum:%String,CenterNum:%String,SurroundNum:%String,ApplyDate:%String,ApplyTime:%String,ApplyLocID:%String,ApplyLocDesc:%String,ApplyUserID:%String,ApplyUserDesc:%String,CollDate:%String,CollTime:%String,CollUserID:%String,CollUserDesc:%String,RecDate:%String,RecTime:%String,RecUserID:%String,RecUserDesc:%String,RepDate:%String,RepTime:%String,RepLocID:%String,RepLocDesc:%String,RepUserID:%String,RepUserDesc:%String,EnterTypeCode:%String,EnterTypeDesc:%String,StandardID:%String,StandardCode:%String,StandardDesc:%String,IsReCheck:%String,ReCheckRepDr:%String,Resume:%String,BarCode:%String,ReCheckSign:%String,Reason:%String,Action:%String") [ SqlProc ]
{
}

ClassMethod QryReportByDateExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aMonitorLocDr As %String, aItemDr As %String, aStatusCode As %String = "", aStandardCode As %String = "", aBarCode As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//Set ^TMPZF=$lb(aHospIDs, aDateFrom, aDateTo, aMonitorLocDr, aItemDr, aStatusCode, aStandardCode)
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	//前端页面第一次加载时医院没有值，后台加上初始值（前台已解决，延迟加载）
	//if (aHospIDs="") Set aHospIDs="1|2"	
 	Quit:(aHospIDs="")||(aDateFrom="")||(aDateTo="") $$$OK
 	Set:aItemDr'="" aItemDr=","_aItemDr_","
 	
 	Set RepIDList=$lb("")
 	For xDate=aDateFrom:1:aDateTo{
	 	Set xID=""
 		For {
			Set xID = $o(^DHCHAI.IR.EnviHyReportI("IndexOnMonitorDate",xDate,xID))
			Quit:xID=""
			Continue:$lf(RepIDList,xID)>0
			Set RepIDList=RepIDList_$lb(xID)
			Set ReCheckRepID=..GetReCheckRepID(xID)
			Set:ReCheckRepID'="" RepIDList=RepIDList_ReCheckRepID
			
		 }
 	}
 	for i=1:1:$ll(RepIDList) {
	 	Set xID=$lg(RepIDList,i)
	 	continue:xID=""
	 	Set objRep = ##class(DHCHAI.IR.EnviHyReport).GetObjById(xID)
		Continue:'$IsObject(objRep)
 
			
		Set (ItemID,ItemDesc,ItemObjID,ItemObjDesc,ItemObjTxt)=""
		Set (SpecTypeDesc,NormDesc,NormMax,NormMin)=""
		Set (StatusID,StatusCode,StatusDesc,IsAllDone)=""
		Set (MonitorDate,MonitorLocID,MonitorLocDesc,HospID,HospDesc)=""
		Set (SpecimenNum,CenterNum,SurroundNum)=""
		Set (ApplyDate,ApplyTime,ApplyLocID,ApplyLocDesc,ApplyUserID,ApplyUserDesc)=""
		Set (CollDate,CollTime,CollUserID,CollUserDesc)=""
		Set (RecDate,RecTime,RecUserID,RecUserDesc)=""
		Set (RepDate,RepTime,RepLocID,RepLocDesc,RepUserID,RepUserDesc)=""
		Set (EnterTypeCode,EnterTypeDesc,StandardID,StandardCode,StandardDesc)=""
		Set (IsReCheck,ReCheckRepDr,Resume)=""
		
		Set BarCode = ##class(DHCHAI.IR.EnviHyReport).GetBarCode(xID)	//新增打印条码
		Set tmpBarCode ="E"_BarCode    //根据条码号过滤
		Set tmpBarCodeL = $L(tmpBarCode)
		Set aBarCodeL=""
		Set:aBarCode'="" aBarCodeL=$L(aBarCode)
		if (tmpBarCodeL>aBarCodeL){
			Continue:(aBarCode'="")&&(tmpBarCode'[aBarCode)
		}else{
			Set:aBarCode'["E" aBarCode="E"_aBarCode
			Continue:(aBarCode'="")&&(aBarCode'[tmpBarCode)
			}
		Set ItemID 		    = objRep.EHItemDr.%Id()                 //监测项目ID
		Set ItemDesc 		= objRep.EHItemDr.EHItemDesc            //监测项目名称
		Continue:(aItemDr'="")&&(aItemDr'[(","_ItemID_","))
		Set NormDesc		= objRep.EHItemDr.EHNorm           		//检测标准
		Set NormMax			= objRep.EHItemDr.EHNormMax          	//正常上限(项目值|中心值,周边值)
		Set NormMin			= objRep.EHItemDr.EHNormMin          	//正常下限(项目值|中心值,周边值)
		If $IsObject(objRep.EHItemDr.EHSpecimenTypeDr){
			Set SpecTypeDesc=objRep.EHItemDr.EHSpecimenTypeDr.BTDesc //标本类型
		}
		Set SpecimenNum 	= objRep.EHSpecimenNum                  //标本数量
		Set CenterNum		= objRep.EHCenterNum        		    //中心个数
		Set SurroundNum		= objRep.EHSurroundNum      		    //周边个数
		If $IsObject(objRep.EHItemObjDr){
			Set ItemObjID   = objRep.EHItemObjDr.%Id()              //项目对象ID
			Set ItemObjDesc = objRep.EHItemObjDr.EHObjDesc          //项目对象名称
		}
		Set ItemObjTxt      = objRep.EHItemObjTxt                   //项目对象文本
		//导出功能前台不能拼接，需要后台拼接
		if (ItemObjDesc="")&&(ItemObjTxt'=""){
			Set ItemObjDesc = "["_ItemObjTxt_"]"
		}elseif(ItemObjTxt'="")&&(ItemObjDesc'=""){
			Set ItemObjDesc = ItemObjDesc_"["_ItemObjTxt_"]"
		}elseif(ItemObjTxt ="")&&(ItemObjDesc =""){
			Set ItemObjDesc = ""
		}
		If $IsObject(objRep.EHRepStatus){
			Set StatusID    = objRep.EHRepStatus.%Id()              //状态ID
			Set StatusCode  = objRep.EHRepStatus.BTCode             //状态代码
			Set StatusDesc  = objRep.EHRepStatus.BTDesc             //状态名称
		}
		Continue:(((aStatusCode'="")&&(aStatusCode'=StatusCode))||((aStatusCode="")&&(StatusCode=0)))
		Set IsAllDone       = objRep.EHIsAllDone                    //当前操作是否全部完成
		
		Set MonitorDate 	= objRep.EHMonitorDate                  //监测日期
		Set:MonitorDate'="" MonitorDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(MonitorDate)
		If $IsObject(objRep.EHMonitorLocDr){
			Set MonitorLocID   = objRep.EHMonitorLocDr.%Id()        //监测科室ID
			Set MonitorLocDesc = objRep.EHMonitorLocDr.BTDesc       //监测科室名称
			Set MonitorLocDesc2= objRep.EHMonitorLocDr.BTDesc2
			Set:MonitorLocDesc2'="" MonitorLocDesc=MonitorLocDesc2
			If $IsObject(objRep.EHMonitorLocDr.BTHospDr){
				Set HospID   = objRep.EHMonitorLocDr.BTHospDr.%Id()   //医院ID
				Set HospDesc = objRep.EHMonitorLocDr.BTHospDr.BTDesc2 //医院名称
			}
		}
		Continue:("|"_aHospIDs_"|")'[("|"_HospID_"|")
		Continue:(aMonitorLocDr'="")&&(aMonitorLocDr'=MonitorLocID)
		Set ApplyDate 		= objRep.EHApplyDate                    //申请日期
		Set:ApplyDate'="" ApplyDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ApplyDate)
		Set ApplyTime 		= objRep.EHApplyTime                    //申请时间
		Set:ApplyTime'="" ApplyTime=$zt(ApplyTime)
		If $IsObject(objRep.EHApplyLocDr){
			Set ApplyLocID   = objRep.EHApplyLocDr.%Id()            //申请科室ID
			Set ApplyLocDesc = objRep.EHApplyLocDr.BTDesc           //申请科室名称
			Set ApplyLocDesc2= objRep.EHApplyLocDr.BTDesc2
			Set:ApplyLocDesc2'="" ApplyLocDesc=ApplyLocDesc2
		}
		If $IsObject(objRep.EHApplyUserDr){
			Set ApplyUserID  = objRep.EHApplyUserDr.%Id()           //申请人ID
			Set ApplyUserDesc= objRep.EHApplyUserDr.BTDesc          //申请人
		}
		Set CollDate 		 = objRep.EHCollDate                    //采集日期
		Set:CollDate'="" CollDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(CollDate)
		Set CollTime 		 = objRep.EHCollTime                    //采集时间
		Set:CollTime'="" CollTime=$zt(CollTime)
		If $IsObject(objRep.EHCollUserDr){
			Set CollUserID    = objRep.EHCollUserDr.%Id()           //采集人ID
			Set CollUserDesc  = objRep.EHCollUserDr.BTDesc          //采集人
		}
		Set RecDate 		 = objRep.EHRecDate                     //接收日期
		Set:RecDate'="" RecDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RecDate)
		Set RecTime 		 = objRep.EHRecTime                     //接收时间
		Set:RecTime'="" RecTime=$zt(RecTime)
		If $IsObject(objRep.EHRecUserDr){
			Set RecUserID    = objRep.EHRecUserDr.%Id()             //接收人ID
			Set RecUserDesc  = objRep.EHRecUserDr.BTDesc            //接收人
		}
		Set RepDate 		 = objRep.EHRepDate                     //报告日期
		Set:RepDate'="" RepDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
		Set RepTime 		 = objRep.EHRepTime                     //报告时间
		Set:RepTime'="" RepTime=$zt(RepTime)
		If $IsObject(objRep.EHRepLocDr){
			Set RepLocID     = objRep.EHRepLocDr.%Id()              //报告科室ID
			Set RepLocDesc   = objRep.EHRepLocDr.BTDesc             //报告科室名称
			Set RepLocDesc2  = objRep.EHRepLocDr.BTDesc2
			Set:RepLocDesc2'="" RepLocDesc=RepLocDesc2
		}
		If $IsObject(objRep.EHRepUserDr){
			Set RepUserID    = objRep.EHRepUserDr.%Id()             //报告人ID
			Set RepUserDesc  = objRep.EHRepUserDr.BTDesc            //报告人
		}
		If $IsObject(objRep.EHStandard){
			Set StandardID   = objRep.EHStandard.%Id()              //达标情况ID
			Set StandardCode = objRep.EHStandard.BTCode             //达标情况代码
			Set StandardDesc = objRep.EHStandard.BTDesc             //达标情况名称
		}
		Continue:(aStandardCode'="")&&(aStandardCode'=StandardCode)
		If $IsObject(objRep.EHEnterTypeDr){                         //结果录入方式（1按项目、2按标本、3其他[1中心+1周边]）
			Set EnterTypeCode=objRep.EHEnterTypeDr.BTCode
			Set EnterTypeDesc=objRep.EHEnterTypeDr.BTDesc
		}
		Set IsReCheck=objRep.EHIsReCheck                             //是否复检
		Set ReStatusCode = ""
		Set xReRepID=$o(^DHCHAI.IR.EnviHyReportI("IdxReCheckRepDr"," "_xID,""),-1)
		Set objReCheck = ##class(DHCHAI.IR.EnviHyReport).GetObjById(xReRepID)
		If ($IsObject(objReCheck)&&($IsObject(objReCheck.EHRepStatus))){
			//报告状态
			Set ReStatusCode=objReCheck.EHRepStatus.BTCode
		}
		Set:ReStatusCode=0 IsReCheck=0
		
		Set ReCheckRepDr=+objRep.EHReCheckRepDr                      //复检指针（指向原报告）
		Set Resume 	= objRep.EHResume                      //备注
        Set IsReCheck=$s(IsReCheck=1:"是",1:"否")
        Set IsChecked=""
        Set:ReStatusCode>0 IsChecked=1
		Set ReCheckSign=""
		Set:((IsChecked=1)&&(ReCheckRepDr=0)) ReCheckSign=1 ;原始报告
		Set:((ReCheckRepDr>0)&&(IsChecked=1)) ReCheckSign=2  ;中间报告
		Set:((ReCheckRepDr>0)&&(IsChecked="")) ReCheckSign=3 ;最后报告
        // 不正确原因和改进措施
        Set Val=##class(DHCHAI.IR.EnviHyReCheck).GetValue(xID)
        Set Reason=$p(Val,"^",1)
        Set Action=$p(Val,"^",2)
		Set Data=$lb(xID,ItemID,ItemDesc,ItemObjID,ItemObjDesc,ItemObjTxt)
		Set Data=Data_$lb(SpecTypeDesc,NormDesc,NormMax,NormMin)
		Set Data=Data_$lb(StatusID,StatusCode,StatusDesc,IsAllDone)
		Set Data=Data_$lb(MonitorDate,MonitorLocID,MonitorLocDesc,HospID,HospDesc)
		Set Data=Data_$lb(SpecimenNum,CenterNum,SurroundNum)
		Set Data=Data_$lb(ApplyDate,ApplyTime,ApplyLocID,ApplyLocDesc,ApplyUserID,ApplyUserDesc)
		Set Data=Data_$lb(CollDate,CollTime,CollUserID,CollUserDesc)
		Set Data=Data_$lb(RecDate,RecTime,RecUserID,RecUserDesc)
		Set Data=Data_$lb(RepDate,RepTime,RepLocID,RepLocDesc,RepUserID,RepUserDesc)
		Set Data=Data_$lb(EnterTypeCode,EnterTypeDesc,StandardID,StandardCode,StandardDesc,IsReCheck,ReCheckRepDr,Resume,BarCode,ReCheckSign)
        Set Data=Data_$lb(Reason,Action)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1	
	}
	Quit $$$OK
}

ClassMethod QryReportByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryReportByDateExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryReportByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryReportByDateExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.EnviHyReportSrv","QryRepStatus",152)
Query QryRepStatus(aReportID As %String) As %Query(ROWSPEC = "UpdateLocDesc:%String,UpdateUser:%String,UpdateDate:%String,UpdateTime:%String,UpdateStatus:%String,SpenBarCode:%String,BatchNumber:%String,IsActive:%String,UpdoDate:%String,UpdoTime:%String,UpdoUser:%String")
{
}

ClassMethod QryRepStatusExecute(ByRef qHandle As %Binary, aReportID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)

	Set objRep=##class(DHCHAI.IR.EnviHyReport).GetObjById(aReportID)
	Quit:'$IsObject(objRep) $$$OK
	Quit:'$IsObject(objRep.EHRepStatus) $$$OK
	Quit:'$IsObject(objRep.EHItemDr) $$$OK
	Set LogID=""
	For {
		Set LogID=$o(^DHCHAI.IR.EnviHyReportD(aReportID,"Log",LogID))
		Quit:LogID=""
		Set (UpdateLocDesc,UpdateUser,UpdateDate,UpdateTime,UpdateStatus,SpenBarCode,BatchNumber,IsActive,UpdoDate,UpdoTime,UpdoUser)=""
		Set LogRowID=aReportID_"||"_LogID
		Set objLog=##class(DHCHAI.IR.EnviHyReportLog).GetObjById(LogRowID)
		Set UpdateLocDesc=objLog.EHUpdateLocDr.BTDesc /// 更新科室
		Set UpdateUser=objLog.EHUpdateUserDr.BTDesc /// 更新人员
		Set UpdateDate=$zd(objLog.EHUpdateDate,3)
		Set UpdateTime=$zt(objLog.EHUpdateTime)		/// 更新时间
		Set UpdateStatus=objLog.EHUpdateStatusDr.BTDesc
		Set SpenBarCode=objLog.EHSpenBarCode
		Set BatchNumber=objLog.EHBatchNumber
		Set IsActive=objLog.EHIsActive
		Set IsActive=$s(IsActive=1:"是",1:"否")
		if (objLog.EHUpdoDate'="") {
			Set UpdoDate=$zd(objLog.EHUpdoDate,3)
			Set UpdoTime=$zt(objLog.EHUpdoTime)
			Set UpdoUser=objLog.EHUpdoUserDr.BTDesc
		}
		Set Data=$lb(UpdateLocDesc,UpdateUser,UpdateDate,UpdateTime,UpdateStatus,SpenBarCode,BatchNumber,IsActive,UpdoDate,UpdoTime,UpdoUser)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryRepStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRepStatusExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryRepStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRepStatusExecute ]
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

/// 取配置状态列表
/// w ##class(DHCHAI.IRS.EnviHyReportSrv).GetStatusList()
ClassMethod GetStatusList()
{
	New
	Set return=""
	Set objType=##class(DHCHAI.BT.DicType).GetObjByCode("EHRepStatus")
	Quit:'$IsObject(objType) return
	Set TypeDr=objType.%Id()
	
	Set actStatusList=""
	Set xCode=""
	For {
		Set xCode=$o(^DHCHAI.BT.DictionaryI("IdxofTypeDrCode",TypeDr,xCode))
		Quit:xCode=""
		
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.BT.DictionaryI("IdxofTypeDrCode",TypeDr,xCode,xID))
			Quit:xID=""
			
			Set objDic=##class(DHCHAI.BT.Dictionary).GetObjById(xID)
			Continue:'$IsObject(objDic)
			Set IsActive=objDic.BTIsActive
			Continue:IsActive'=1
			Set Code=objDic.BTCode
			Set actStatusList=actStatusList_$lb(Code)
		}
	}
	
	//执行顺序（1申请、2发放材料、3接收标本、4录入结果、5审核结果、6采集标本）
	Set tStatusList=$lb(1,2,6,3,4,5)
	For indS=1:1:$ll(tStatusList){
		Set tStatus=$lg(tStatusList,indS)
		Continue:tStatus=""
		Continue:$listfind(actStatusList,tStatus)<1
		Set return=return_"|"_tStatus
	}
	Set return=return_"|"
	Quit return
}

/// 取配置状态字典列表
/// w ##class(DHCHAI.IRS.EnviHyReportSrv).GetStatusDicList()
ClassMethod GetStatusDicList()
{
	New
	Set return=""
	Set objType=##class(DHCHAI.BT.DicType).GetObjByCode("EHRepStatus")
	Quit:'$IsObject(objType) return
	Set TypeDr=objType.%Id()
	
	//执行顺序（1申请、2发放材料、3接收标本、4录入结果、5审核结果、6采集标本）
	Set tStatusList=$lb(1,2,6,3,4,5)
	
	Set StatusDicList=""
	For indS=1:1:$ll(tStatusList){
		Set tStatus=$lg(tStatusList,indS)
		Continue:tStatus=""
		
		Set xID=""
		For {
			Set xID=$o(^DHCHAI.BT.DictionaryI("IdxofTypeDrCode",TypeDr,tStatus,xID))
			Quit:xID=""
			
			Set objDic=##class(DHCHAI.BT.Dictionary).GetObjById(xID)
			Continue:'$IsObject(objDic)
			Set IsActive=objDic.BTIsActive
			Continue:IsActive'=1
			Set Desc=objDic.BTDesc
			Set StatusDicList=StatusDicList_","_tStatus_"^"_Desc
		}
	}
	Set:StatusDicList'="" StatusDicList=$e(StatusDicList,2,$l(StatusDicList))
	Set return=StatusDicList
	
	Quit return
}

/// Creator：     zhangdc
/// CreatDate：   2020-02-27
/// Description:  查询环境卫生学科室申请单打印报告
/// Table：       DHCHAI.IR.EnviHyReport
/// Input:        报告ID
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.EnviHyReportSrv","QryEnvihyApplyRepInfo","11")
Query QryEnvihyApplyRepInfo(aReportID As %String) As %Query(ROWSPEC = "ReportID:%String,HospID:%String,HospDesc:%String,BarCode:%String,EvItemID:%String,EvItemDesc:%String,EvItemObjID:%String,EvItemObjDesc:%String,RepStatusID:%String,RepStatusCode:%String,RepStatusDesc:%String,MonitorDate:%String,ApplyDate:%String,ApplyTime:%String,ApplyLocID:%String,ApplyLocDesc:%String,ApplyUserID:%String,ApplyUserDesc:%String,EvItemSpenNum:%String,SpecimenNum:%String,RepDate:%String,RepTime:%String,RepLocID:%String,RepLocDesc:%String,RepUserID:%String,RepUserDesc:%String,StandardID:%String,StandardDesc:%String,Resume:%String,SpenTypeDesc:%String,NormDesc:%String,NormMax:%String,NormMin:%String,CenterNum:%String,SurroundNum:%String,RepCenterNum:%String,RepSurroundNum:%String,ReCheckRepID:%String,IsChecked:%String,ReCheckSign:%String,EHItemObjTxt:%String,MonitorLocID:%String,MonitorLocDesc:%String,ReferToNum:%String,IsObjNull:%String") [ SqlProc ]
{
}

ClassMethod QryEnvihyApplyRepInfoExecute(ByRef qHandle As %Binary, aReportID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:aReportID="" $$$OK
	
	Set Data = ..BuildEnvihyINFRepData(aReportID)
	Quit:Data="" $$$OK
	
	Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryEnvihyApplyRepInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEnvihyApplyRepInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryEnvihyApplyRepInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEnvihyApplyRepInfoExecute ]
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

/// 取监测报告单信息
ClassMethod BuildEnvihyINFRepData(aReportID As %String) As %String
{
	New (aReportID)
	Set return = ""
	Quit:aReportID="" return
	
	Set objRep = ##class(DHCHAI.IR.EnviHyReport).GetObjById(aReportID)
	Quit:'$IsObject(objRep) return
	
	Set (HospID,HospDesc,EvItemID,EvItemDesc,EvItemObjID,EvItemObjDesc,RepStatusID,RepStatusCode,RepStatusDescApplyLocID,ApplyLocDesc,ApplyUserID,ApplyUserDesc,RepLocID,RepLocDesc,RepUserID,RepUserDesc,StandardID,StandardDesc,MonitorLocID,MonitorLocDesc)=""
	Set BarCode = ##class(DHCHAI.IR.EnviHyReport).GetBarCode(aReportID)
	Set objEvItem 		= objRep.EHItemDr
	Quit:'$IsObject(objEvItem)
	Set EvItemSpenNum 	= objEvItem.EHSpecimenNum
	Set SpenTypeDesc	= objEvItem.EHSpecimenTypeDr.BTDesc	// 标本类型
	Set NormDesc		= objEvItem.EHNorm           		// 检测标准
	Set NormMax			= objEvItem.EHNormMax          		// 中心值
	Set NormMin			= objEvItem.EHNormMin          		// 周边值
	Set CenterNum		= objEvItem.EHCenterNum        		// 中心个数
	Set SurroundNum		= objEvItem.EHSurroundNum      		// 周边个数
	Set EvItemID 		= objEvItem.%Id()
	Set EvItemDesc 		= objEvItem.EHItemDesc
	Set IsObjNull 		= objEvItem.EHIsObjNull
	
	Set objItemObj 		= objRep.EHItemObjDr
	If $IsObject(objItemObj){
		Set EvItemObjID = objItemObj.%Id()
		Set EvItemObjDesc = objItemObj.EHObjDesc
	}
	Set EHItemObjTxt=objRep.EHItemObjTxt
	//导出功能前台不能拼接，需要后台拼接
	if (EvItemObjDesc="")&&(EHItemObjTxt'=""){
		Set EvItemObjDesc = "["_EHItemObjTxt_"]"
	}elseif(EHItemObjTxt'="")&&(EvItemObjDesc'=""){
		Set EvItemObjDesc = EvItemObjDesc_"["_EHItemObjTxt_"]"
	}elseif(EHItemObjTxt ="")&&(EvItemObjDesc =""){
		Set EvItemObjDesc = ""
	}
	Set objRepStatus 	= objRep.EHRepStatus
	If $IsObject(objRepStatus){
		Set RepStatusID = objRepStatus.%Id()
		Set RepStatusCode = objRepStatus.BTCode
		Set RepStatusDesc = objRepStatus.BTDesc
	}
	Set MonitorDate 	= objRep.EHMonitorDate
	Set:MonitorDate'="" MonitorDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(MonitorDate)
	Set ApplyDate 		= objRep.EHApplyDate
	Set:ApplyDate'="" ApplyDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ApplyDate)
	Set ApplyTime 		= objRep.EHApplyTime
	Set:ApplyTime'="" ApplyTime = $zt(ApplyTime)
	Set objApplyLoc 	= objRep.EHApplyLocDr
	If $IsObject(objApplyLoc){
		Set ApplyLocID = objApplyLoc.%Id()
		If objApplyLoc.BTDesc2=""{
			Set ApplyLocDesc = objApplyLoc.BTDesc
		}else{
			Set ApplyLocDesc = objApplyLoc.BTDesc2
		}
			Set objHosp = objApplyLoc.BTHospDr
			If $IsObject(objHosp){
				Set HospID = objHosp.%Id()
				Set HospDesc = objHosp.BTDesc2
			}
		}
	Set objMonitorLoc 	= objRep.EHMonitorLocDr
	If $IsObject(objMonitorLoc){
		Set MonitorLocID = objMonitorLoc.%Id()
		If objMonitorLoc.BTDesc2=""{
			Set MonitorLocDesc = objMonitorLoc.BTDesc
		}else{
			Set MonitorLocDesc = objMonitorLoc.BTDesc2
		}
			Set objHosp = objMonitorLoc.BTHospDr
			If $IsObject(objHosp){
				Set HospID = objHosp.%Id()
				Set HospDesc = objHosp.BTDesc2
			}
		}
	Set:MonitorLocID="" MonitorLocID=ApplyLocID,MonitorLocDesc=ApplyLocDesc
	Set objApplyUser 	= objRep.EHApplyUserDr
	If $IsObject(objApplyUser){
		Set ApplyUserID = objApplyUser.%Id()
		Set ApplyUserDesc = objApplyUser.BTDesc
	}
	Set SpecimenNum 	= +objRep.EHSpecimenNum
	Set RepCenterNum 	= +objRep.EHCenterNum
	Set RepSurroundNum 	= +objRep.EHSurroundNum
	Set RepDate 		= objRep.EHRepDate
	Set:RepDate'="" RepDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
	Set RepTime 		= objRep.EHRepTime
	Set:RepTime'="" RepTime = $zt(RepTime)
	Set objRepLoc 		= objRep.EHRepLocDr
	If $IsObject(objRepLoc){
		Set RepLocID = objRepLoc.%Id()
		If objRepLoc.BTDesc2=""{
			Set RepLocDesc = objRepLoc.BTDesc
		}else{
			Set RepLocDesc = objRepLoc.BTDesc2
			}
		}
	Set objRepUser 		= objRep.EHRepUserDr
	If $IsObject(objRepUser){
		Set RepUserID = objRepUser.%Id()
		Set RepUserDesc = objRepUser.BTDesc
		}
	Set objStandard 	= objRep.EHStandard
	Set StandardYN=""
	If $IsObject(objStandard){
		Set StandardID = objStandard.%Id()
		Set StandardDesc = objStandard.BTDesc
		Set:StandardDesc["不" StandardYN="N"
		Set:StandardYN="" StandardYN="Y"
		}
	Set Resume 			= objRep.EHResume
	Set ReCheckRepID 	= +objRep.EHReCheckRepDr
	Set IsChecked		= ""  //不合格报告是否已复检
	Set:$d(^DHCHAI.IR.EnviHyReportI("IdxReCheckRepDr"," "_aReportID)) IsChecked=1
	Set ReCheckSign=""	
	Set:((IsChecked=1)&&(ReCheckRepID=0)) ReCheckSign=1 ;原始报告
	Set:((ReCheckRepID>0)&&(IsChecked=1)) ReCheckSign=2  ;中间报告
	Set:((ReCheckRepID>0)&&(IsChecked="")) ReCheckSign=3 ;最后报告
	Set ReferToNum = objRep.EHReferToNum	
	
	Set return = $lb(xID,HospID,HospDesc,BarCode,EvItemID,EvItemDesc,EvItemObjID,EvItemObjDesc,RepStatusID,RepStatusCode,RepStatusDesc,MonitorDate,ApplyDate,ApplyTime,ApplyLocID,ApplyLocDesc,ApplyUserID,ApplyUserDesc,EvItemSpenNum,SpecimenNum,RepDate,RepTime,RepLocID,RepLocDesc,RepUserID,RepUserDesc,StandardID,StandardDesc,Resume,SpenTypeDesc,NormDesc,NormMax,NormMin,CenterNum,SurroundNum,RepCenterNum,RepSurroundNum,ReCheckRepID,IsChecked,ReCheckSign,EHItemObjTxt,MonitorLocID,MonitorLocDesc,ReferToNum,IsObjNull)
	Quit return
}

/// Creator：     zhangdc
/// CreatDate：   2020-03-03
/// Description:  查询环境卫生学科室申请单打印报告每个标本信息
/// Table：       DHCHAI.IR.EnviHyRepResult
/// Input:        报告ID
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.EnviHyReportSrv","QryEnvihyApplyResultInfo","39")
Query QryEnvihyApplyResultInfo(aReportID As %String) As %Query(ROWSPEC = "BarCode:%String,Result:%String,BactID:%String,BactDesc:%String,LogDate:%String,LogTime:%String,LogUserID:%String,LogUserDesc:%String,RstTypeID:%String,RstTypeDesc:%String,Norm:%String,StandardDesc:%String") [ SqlProc ]
{
}

ClassMethod QryEnvihyApplyResultInfoExecute(ByRef qHandle As %Binary, aReportID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set objRep=##class(DHCHAI.IR.EnviHyReport).GetObjById(aReportID)
	Quit:'$IsObject(objRep) $$$OK
	Quit:'$IsObject(objRep.EHItemDr) $$$OK
	
	Set RepBarCode=##class(DHCHAI.IR.EnviHyReport).GetBarCode(aReportID)
	Set SpecimenNum=objRep.EHSpecimenNum
	Set CenterNum=objRep.EHCenterNum               //中心点个数
	Set CenterNum=+CenterNum
	Set SurroundNum=objRep.EHSurroundNum           //周边点个数
	Set SurroundNum=+SurroundNum
	Set num = CenterNum+SurroundNum
	Set EnterTypeCode=objRep.EHEnterTypeDr.BTCode  //录入方式
	Set ReferToNum=objRep.EHReferToNum             //参照点个数
	Set ReferToNum=+ReferToNum
	Set ForMula=objRep.EHItemDr.EHForMula          //计算公式
	Set NormMax=objRep.EHItemDr.EHNormMax	       //正常上限(中心值,周边值)
	Set NormMin=objRep.EHItemDr.EHNormMin	       //正常下限(中心值,周边值)
	
	For indBar=1:1:num {
		Set BarCode=##class(DHCHAI.IR.EnviHyReport).GetSpenBarCode(aReportID,indBar) //标本条码
		Set SubID = $o(^DHCHAI.IR.EnviHyReportI("Result","IndexSpecNumber",aReportID,indBar,""),-1)
		Set (Result,BactID,BactDesc,LogDate,LogTime,LogUserID,LogUserDesc,RstTypeID,RstTypeDesc,Norm,StandardDesc)=""
		Set objResult = ##class(DHCHAI.IR.EnviHyRepResult).GetObjById(aReportID_"||"_SubID)
		If $IsObject(objResult){
			Set Result = objResult.EHResult	// 菌落数
			Set objBact = objResult.EHBactDr	// 检出菌/致病菌
			If $IsObject(objBact){
				Set BactID		= objBact.%Id()
				Set BactDesc	= objBact.BTBacDesc
			}
			If $IsObject(objResult.EHRstTypeDr){ 	// 结果类型
			   Set RstTypeID = objResult.EHRstTypeDr.%Id()
			   Set RstTypeDesc = objResult.EHRstTypeDr.BTDesc
			}
		}
		
		Set objStatus=##class(DHCHAI.BT.Dictionary).GetObjByCode("EHRepStatus",4)
		Set StatusDr=objStatus.%Id()
		Set SubLogID = $o(^DHCHAI.IR.EnviHyReportI("Log","IndexOnSpenBarCodeStatus",BarCode,StatusDr,aReportID,""),-1)
		Set objLog = ##class(DHCHAI.IR.EnviHyReportLog).GetObjById(aReportID_"||"_SubLogID)
		If $IsObject(objLog){
			if (BactID'="")||(Result'="")||(RstTypeID'=""){  // 修复bug：
				Set LogDate 	= ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(objLog.EHUpdateDate)
				Set LogTime		= $zt(objLog.EHUpdateTime)
				Set LogUserID	= objLog.EHUpdateUserDr.%Id()
				Set LogUserDesc	= objLog.EHUpdateUserDr.BTDesc
			}
		}
		
		//判断达标情况（0不合格、1合格）
		Set StandardCode=""
		Set (CenterVal,SurroundVal,SpecimenVal)=0
		
		
		if (indBar<=CenterNum) {	//中心标本
		
			if (ForMula=""){
			
			if (("小于"=RstTypeDesc)||("菌落数"=RstTypeDesc))&&(Result<=NormMax) {
			Set StandardCode=1
			}elseif (("小于"=RstTypeDesc)||("菌落数"=RstTypeDesc))&&(Result>NormMax){
				Set StandardCode=0
				}
				
			}elseif(("大于"=RstTypeDesc)){
				Set StandardCode=0
			}elseif(("未检出"=RstTypeDesc)){
				Set StandardCode=1
			}else{
				if ("小于"=RstTypeDesc){
					Set val=0
				}
				if ("菌落数"=RstTypeDesc){
					Set val=..GetEnviHyResult(ForMula,+tResult)
				}
				Set CenterVal=CenterVal+val
				//Set:(CenterVal/CenterNum)>(+$p(NormMax,",",1)) StandardCode=0
				if ((CenterVal/CenterNum)>(+$p(NormMax,",",1))){
					Set StandardCode=0
				}else {
					Set StandardCode=1
				}
			}
			Set BarCode= BarCode_""_"[中心]"
			Set Norm=NormMax
		}else{						//周边标本
		
			if (ForMula=""){
				
			if (("小于"=RstTypeDesc)||("菌落数"=RstTypeDesc))&&(Result<=NormMin) {
			Set StandardCode=1
			}elseif (("小于"=RstTypeDesc)||("菌落数"=RstTypeDesc))&&(Result>NormMin){
				Set StandardCode=0
				}
			}elseif(("大于"=RstTypeDesc)){
				Set StandardCode=0
			}elseif(("未检出"=RstTypeDesc)){
				Set StandardCode=1
			}else{
				if ("小于"=RstTypeDesc){
					Set val=0
				}
				if ("菌落数"=RstTypeDesc){
					Set val=..GetEnviHyResult(ForMula,+tResult)
				}
				Set SurroundVal=SurroundVal+val
				//Set:(CenterVal/CenterNum)>(+$p(NormMax,",",1)) StandardCode=0
				if ((SurroundVal/SurroundNum)>(+$p(NormMax,",",2))){
					Set StandardCode=0
				}else {
					Set StandardCode=1
				}
			}
			Set BarCode= BarCode_""_"[周边]"
			Set Norm=NormMin
		}
		if ("大于"=RstTypeDesc) {
			Set StandardCode=0
			
		}
		if (""=Result) {
			Set StandardCode=1
			
		}
		if (BactID'="")&&(BactDesc'="") {
			Set StandardCode=0
			
		}
			
		Set:StandardCode=0 StandardDesc="否"
		Set:StandardCode=1 StandardDesc="是"		
		Set Data=$lb(BarCode,Result,BactID,BactDesc,LogDate,LogTime,LogUserID,LogUserDesc,RstTypeID,RstTypeDesc,Norm,StandardDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryEnvihyApplyResultInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEnvihyApplyResultInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryEnvihyApplyResultInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEnvihyApplyResultInfoExecute ]
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

/// 结果计算公式
ClassMethod GetEnviHyResult(aItemForMula As %String, aResult As %String, ByRef ErrMsg As %String) As %String
{
	New (aItemForMula,aResult,ErrMsg)
	Set return=""
	Quit:aResult="" return
	
	Set $ZT="GetEnviHyResultErr"
	If aItemForMula="" {
		Set return=aResult
	} Else {
		For {
			Quit:aItemForMula'["N"
			Set tmpForMula=$p(aItemForMula,"N",1)
			Set aItemForMula=tmpForMula_aResult_$e(aItemForMula,$l(tmpForMula)+2,$l(aItemForMula))
		}
		If ($e(aItemForMula,1,1)="(")&&($e(aItemForMula,$l(aItemForMula),$l(aItemForMula))=")"){
			Set aItemForMula="Set return="_aItemForMula
		} Else {
			Set aItemForMula="Set return=("_aItemForMula_")"
		}
		X aItemForMula
	}
	Quit return
	
GetEnviHyResultErr
	Set ErrMsg=$ZError
	Quit ""
}

///  Input：       aId,aValue1 ,aValue2   
///  Return：      返回 >=1,成功 "",有问题
/// w ##class(DHCHAI.IRS.EnviHyReportSrv).ReCheckDate("98","2022-07-18")
ClassMethod ReCheckDate(aReCheckRepId As %String, aEHMonitorDate As %String) As %String
{
    
    new (aReCheckRepId ,aEHMonitorDate)
    Set return=""
    Quit:(aReCheckRepId="")||(aEHMonitorDate="") return
    
    Set ID=aReCheckRepId
    //Set ID= $o(^DHCHAI.IR.EnviHyReportI("IdxReCheckRepDr"," "_+aReCheckRepId,""))
    //Quit:ID="" "无复检记录"
    Set obj=##Class(DHCHAI.IR.EnviHyReport).%OpenId(ID)
    Quit:'$IsObject(obj) "没有复检报告"
    Set obj.EHMonitorDate   = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aEHMonitorDate)
   
    Set sc=obj.%Save()
    If $System.Status.IsError(sc) {  //检查Save是否成功
        Do $system.OBJ.DisplayError(sc)
        Set return=-1
    } Else {
        Set return=obj.%Id()
    }
    If obj'="" Do obj.%Close()

    Quit return
}

}
