/// 名称: DHCHAI.STATV2.S380HandHyCom
/// 描述: 医务人员手卫生依从率统计表统计表
/// 编写者：zhoubo
/// 编写日期: 2019-11-06
Class DHCHAI.STATV2.S380HandHyCom Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2022-06-16
/// Description:  医务人员手卫生依从率
/// Table：       DHCHAI.IR.HandHyReg
/// Input:        aHospIDs  : 多个医院用"|"连接
///               aDateFrom ：开始日期
///               aDateTo   ：结束日期
///               aMethod   ：调查方式（字典维护的ID）
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S380HandHyCom","QryHandHyRegSta","1|2","2021-06-25","2023-03-21","")
Query QryHandHyRegSta(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aMethod As %String = "", aObsType As %String = "", aLocID As %String = "") As %Query(ROWSPEC = "DimensKey:%String,DimensDesc:%String,ObsPatCount:%String,HandCount:%String,SoapCount:%String,NotCount:%String,CompRatio:%String,CorrectCount:%String,CorrectRatio:%String,PBeforeHandCount:%String,PBeforeSoapCount:%String,PBeforeNotCount:%String,PBeforeCompRatio:%String,PBeforeCorrectCount:%String,PBeforeCorrectRatio:%String,OBeforeHandCount:%String,OBeforeSoapCount:%String,OBeforeNotCount:%String,OBeforeCompRatio:%String,OBeforeCorrectCount:%String,OBeforeCorrectRatio:%String,SapHandCount:%String,SapSoapCount:%String,SapNotCount:%String,SapCompRatio:%String,SapCorrectCount:%String,SapCorrectRatio:%String,PAfterHandCount:%String,PAfterSoapCount:%String,PAfterNotCount:%String,PAfterCompRatio:%String,PAfterCorrectCount:%String,PAfterCorrectRatio:%String,HAfterHandCount:%String,HAfterSoapCount:%String,HAfterNotCount:%String,HAfterCompRatio:%String,HAfterCorrectCount:%String,HAfterCorrectRatio:%String,SHandCount:%String,PBeforeSHandCount:%String,OBeforeSHandCount:%String,SapSHandCount:%String,PAfterSHandCount:%String,HAfterSHandCount:%String,ObsType:%String,ObsTypeID:%String,ErrCountRatio:%String,ErrWZXCount:%String,ErrBWWQBDDCount:%String,ErrSJBGCount:%String,ErrQTCount:%String") [ SqlProc ]
{
}

ClassMethod QryHandHyRegStaExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aMethod As %String = "", aObsType As %String = "", aLocID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
    Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	Set IsLc = 0
 	Set xLcLocID =""
 	if (aLocID'="")
 	{
	 	//如果是临床打开报表进行特殊处理,借用aHospIDs传入科室ID
	 	Set IsLc =1
	 	Set xLcLocID = aLocID
	 	// Add by zhaoyj 2022-06-16 Global方式
	 	Set xLcLocData=$g(^DHCHAI.BT.LocationD(xLcLocID))
	 	Set:$lg(xLcLocData,8)'="" aHospIDs=$lg(xLcLocData,8)
	}
 	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
 	Set NIndex="QryHandHyRegSta"
	Kill ^TMP($zn,$j,NIndex)
	
 	For xDate=aDateFrom:1:aDateTo {	
 		Set xPage=""
 		For {
			Set xPage=$o(^DHCHAI.IR.HandHyRegI("IndexDatePage",xDate,xPage))
			Quit:xPage=""
			
			Set xID=""
			For {
				Set xID=$o(^DHCHAI.IR.HandHyRegI("IndexDatePage",xDate,xPage,xID))
				Quit:xID=""
				Set RegID=xID
				Set RegData=$g(^DHCHAI.IR.HandHyRegD(RegID))
				Continue:RegData=""
				//增加调查方式过滤条件
				if (aMethod'=""){
					continue:aMethod'=$lg(RegData,10)
				}
				
				Set LocDr = $li(RegData,2)
				Set LocData = $g(^DHCHAI.BT.LocationD(LocDr))
				
				Set GroupDr  = $li(LocData,7)
				If GroupDr="" {
					Set GroupDesc="其他科"
					Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
				}
				Set HospDr=$li(LocData,8)
				
				Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)
				Set IsActive=$li(RegData,6)
				Continue:IsActive'=1
				
				//临时按角色记录人数
				Set ResInfo=##Class(%ArrayOfDataTypes).%New()
				
				Set xType=""
				For {
					Set xType=$o(^DHCHAI.IR.HandHyRegI("Cnt","IndexType",RegID,xType))
					Quit:xType=""
					Continue:(aObsType'="")&&(xType'=aObsType)
					Set initVal =+ResInfo.GetAt(xType)		
					Set ObsPatCount=0			
					Set xSign=""
					For {
						Set xSign=$o(^DHCHAI.IR.HandHyRegI("Cnt","IndexType",RegID,xType,xSign))
						Quit:xSign=""
						Set xSubID=""
						For {
							Set xSubID=$o(^DHCHAI.IR.HandHyRegI("Cnt","IndexType",RegID,xType,xSign,xSubID))
							Quit:xSubID=""
							Set ChildCntID=RegID_"||"_xSubID
							
							Set ChildCntData=$g(^DHCHAI.IR.HandHyRegD(RegID,"Cnt",xSubID))
							Set tmpPatCount = $li(ChildCntData,3)
							Set ObsPatCount = ObsPatCount+tmpPatCount
						}
					}
					Do ResInfo.SetAt(initVal+ObsPatCount,xType)
				}
			
				Set LocTypeDr = $li(LocData,5)
				Continue:LocTypeDr=""
				Set:LocTypeDr'="" LocTypeData = $g(^DHCHAI.BT.DictionaryD(LocTypeDr))
				Continue:LocTypeData=""
				Set LocType = $li(LocTypeData,2)
				
				Set DimensKeyList=$lb("全院",LocDr)
				For xDimensIndex=1:1:$ListLength(DimensKeyList) {
					Set xDimensKey=$List(DimensKeyList,xDimensIndex)
					Continue:xDimensKey=""
										
					Set xType=""
					For {
						Set xType=$o(^DHCHAI.IR.HandHyRegI("Tim","IndexObsTypeTime",RegID,xType))
						Quit:xType=""
						Continue:(aObsType'="")&&(xType'=aObsType)
						
						// 检查人数
						Set num=+$g(^TMP($zn,$j,NIndex,xDimensKey,xType,"ObsPatCount"))
						Set ObsPatCount=+ResInfo.GetAt(xType)
						Set ^TMP($zn,$j,NIndex,xDimensKey,xType,"ObsPatCount")=num+ObsPatCount
						Set xTim=""
						For {
							Set xTim=$o(^DHCHAI.IR.HandHyRegI("Tim","IndexObsTypeTime",RegID,xType,xTim))
							Quit:xTim=""
							
							Set xSign=""
							For {
								Set xSign=$o(^DHCHAI.IR.HandHyRegI("Tim","IndexObsTypeTime",RegID,xType,xTim,xSign))
								Quit:xSign=""
							
								
								Set xSubID=""
								For {
									Set xSubID=$o(^DHCHAI.IR.HandHyRegI("Tim","IndexObsTypeTime",RegID,xType,xTim,xSign,xSubID))
									Quit:xSubID=""
									Set ChildTimID=RegID_"||"_xSubID
									Set ChildTimData=$g(^DHCHAI.IR.HandHyRegD(RegID,"Tim",xSubID))
									// 手卫生指征
									Set OpportListDesc=""
									Set OpportList = $li(ChildTimData,8)
									If (OpportList'=""){
										For i=1:1:$l(OpportList,",") {
											Set OpportID=$p(OpportList,",",i)
											Set OpportData=$g(^DHCHAI.BT.DictionaryD(OpportID))
											Set BTDesc = $li(OpportData,3)
											Set:BTDesc'="" OpportListDesc=OpportListDesc_","_BTDesc
										}
									}
									Set OpportList=OpportListDesc
									// 手卫生措施(行为)
									Set FacID=$li(ChildTimData,5)
									Set FacData=$g(^DHCHAI.BT.DictionaryD(FacID))
									Set FacDesc = $li(FacData,3)
									Set IsGloving = $li(ChildTimData,6)   // 是否戴手套
									Set IsCorrect = $li(ChildTimData,7)   // 是否正确
									
									If (FacDesc="手消"){
										// 手消人次
										Set num = $i(^TMP($zn,$j,NIndex,xDimensKey,xType,"HandCount"))
									}
									If (FacDesc="洗手"){
										// 洗手人次
										Set num = $i(^TMP($zn,$j,NIndex,xDimensKey,xType,"SoapCount"))
									}
									If (FacDesc="洗手+手消"){
										// 洗手人次
										Set num = $i(^TMP($zn,$j,NIndex,xDimensKey,xType,"SHandCount"))
									}
									If (FacDesc="无")||(FacDesc="未采取") {
										// 未洗手人次
										Set num = $i(^TMP($zn,$j,NIndex,xDimensKey,xType,"NotCount"))
									}
									If (IsCorrect=1){
										// 洗手正确数
										Set num = $i(^TMP($zn,$j,NIndex,xDimensKey,xType,"CorrectCount"))
									}
									else
									{
										//增加不正确类型计数
										Set num = $i(^TMP($zn,$j,NIndex,xDimensKey,xType,"ErrCount"))
										// 手卫生不正确原因
										Set ErrListDesc=""
										Set ErrList = $li(ChildTimData,10)
										If (ErrList'=""){
											For i=1:1:$l(ErrList,",") {
												Set ErrID=$p(ErrList,",",i)
												Set ErrData=$g(^DHCHAI.BT.DictionaryD(ErrID))
												Set BTDesc = $li(ErrData,3)
												Set:BTDesc'="" ErrListDesc=ErrListDesc_","_BTDesc
											}
										}
										If (ErrListDesc["未执行"){
											Set num = $i(^TMP($zn,$j,NIndex,xDimensKey,xType,"ErrWZXCount"))
										}
										If (ErrListDesc["部位未全部达到"){
											Set num = $i(^TMP($zn,$j,NIndex,xDimensKey,xType,"ErrBWWQBDDCount"))
										}
										If (ErrListDesc["时间不够"){
											Set num = $i(^TMP($zn,$j,NIndex,xDimensKey,xType,"ErrSJBGCount"))
										}
										If (ErrListDesc["其他"){
											Set num = $i(^TMP($zn,$j,NIndex,xDimensKey,xType,"ErrQTCount"))
										}
									}								
									
									If (OpportList["病人前"){
										If (FacDesc="手消"){
											// 手消人次
											Set num = $i(^TMP($zn,$j,NIndex,xDimensKey,xType,"PBeforeHandCount"))
										}
										If (FacDesc="洗手"){
											// 洗手人次
											Set num = $i(^TMP($zn,$j,NIndex,xDimensKey,xType,"PBeforeSoapCount"))
										}
										If (FacDesc="洗手+手消"){
											// 洗手人次
											Set num = $i(^TMP($zn,$j,NIndex,xDimensKey,xType,"PBeforeSHandCount"))
										}
										If (FacDesc="无")||(FacDesc="未采取") {
											// 未洗手人次
											Set num = $i(^TMP($zn,$j,NIndex,xDimensKey,xType,"PBeforeNotCount"))
										}
										If (IsCorrect=1){
											// 洗手正确数
											Set num = $i(^TMP($zn,$j,NIndex,xDimensKey,xType,"PBeforeCorrectCount"))
										}
									}
									If (OpportList["操作前"){
										If (FacDesc="手消"){
											// 手消人次
											Set num = $i(^TMP($zn,$j,NIndex,xDimensKey,xType,"OBeforeHandCount"))
										}
										If (FacDesc="洗手"){
											// 洗手人次
											Set num = $i(^TMP($zn,$j,NIndex,xDimensKey,xType,"OBeforeSoapCount"))
										}
										If (FacDesc="洗手+手消"){
											// 洗手人次
											Set num = $i(^TMP($zn,$j,NIndex,xDimensKey,xType,"OBeforeSHandCount"))
										}
										If (FacDesc="无")||(FacDesc="未采取") {
											// 未洗手人次
											Set num = $i(^TMP($zn,$j,NIndex,xDimensKey,xType,"OBeforeNotCount"))
										}
										If (IsCorrect=1){
											// 洗手正确数
											Set num = $i(^TMP($zn,$j,NIndex,xDimensKey,xType,"OBeforeCorrectCount"))
										}
									}
									If (OpportList["体液后"){
										If (FacDesc="手消"){
											// 手消人次
											Set num = $i(^TMP($zn,$j,NIndex,xDimensKey,xType,"SapHandCount"))
										}
										If (FacDesc="洗手"){
											// 洗手人次
											Set num = $i(^TMP($zn,$j,NIndex,xDimensKey,xType,"SapSoapCount"))
										}
										If (FacDesc="洗手+手消"){
											// 洗手人次
											Set num = $i(^TMP($zn,$j,NIndex,xDimensKey,xType,"SapSHandCount"))
										}
										If (FacDesc="无")||(FacDesc="未采取") {
											// 未洗手人次
											Set num = $i(^TMP($zn,$j,NIndex,xDimensKey,xType,"SapNotCount"))
										}
										If (IsCorrect=1){
											// 洗手正确数
											Set num = $i(^TMP($zn,$j,NIndex,xDimensKey,xType,"SapCorrectCount"))
										}
									}
									If (OpportList["病人后"){
										If (FacDesc="手消"){
											// 手消人次
											Set num = $i(^TMP($zn,$j,NIndex,xDimensKey,xType,"PAfterHandCount"))
										}
										If (FacDesc="洗手"){
											// 洗手人次
											Set num = $i(^TMP($zn,$j,NIndex,xDimensKey,xType,"PAfterSoapCount"))
										}
										If (FacDesc="洗手+手消"){
											// 洗手人次
											Set num = $i(^TMP($zn,$j,NIndex,xDimensKey,xType,"PAfterSHandCount"))
										}
										If (FacDesc="无")||(FacDesc="未采取") {
											// 未洗手人次
											Set num = $i(^TMP($zn,$j,NIndex,xDimensKey,xType,"PAfterNotCount"))
										}
										If (IsCorrect=1){
											// 洗手正确数
											Set num = $i(^TMP($zn,$j,NIndex,xDimensKey,xType,"PAfterCorrectCount"))
										}
									}
									If (OpportList["环境后"){
										If (FacDesc="手消"){
											// 手消人次
											Set num = $i(^TMP($zn,$j,NIndex,xDimensKey,xType,"HAfterHandCount"))
										}
										If (FacDesc="洗手"){
											// 洗手人次
											Set num = $i(^TMP($zn,$j,NIndex,xDimensKey,xType,"HAfterSoapCount"))
										}
										If (FacDesc="洗手+手消"){
											// 洗手人次
											Set num = $i(^TMP($zn,$j,NIndex,xDimensKey,xType,"HAfterSHandCount"))
										}
										If (FacDesc="无")||(FacDesc="未采取") {
											// 未洗手人次
											Set num = $i(^TMP($zn,$j,NIndex,xDimensKey,xType,"HAfterNotCount"))
										}
										If (IsCorrect=1){
											// 洗手正确数
											Set num = $i(^TMP($zn,$j,NIndex,xDimensKey,xType,"HAfterCorrectCount"))
										}
									}
								}
							}
						}
					}
				}
 			}
 		}
 	}
 	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListToString(aHospIDs,"|")
 	
	// 输出Data
	Do:xLcLocID="" BuildData("全院","全院")		// 全院Data
	
	Set KeyList=$lb("")
	Set xLocIndNo="",LocIdx=0
	For {
		Set xLocIndNo=$o(^DHCHAI.BT.LocationI("IndexIndNoLocDesc",xLocIndNo))
		Quit:xLocIndNo=""
		
		Set xLocDesc=""
		For {
			Set xLocDesc=$o(^DHCHAI.BT.LocationI("IndexIndNoLocDesc",xLocIndNo,xLocDesc))
			Quit:xLocDesc=""
			
			Set xLocID=0
			For {
				Set xLocID=$o(^DHCHAI.BT.LocationI("IndexIndNoLocDesc",xLocIndNo,xLocDesc,xLocID))
				Quit:xLocID=""

				Set LocData = $g(^DHCHAI.BT.LocationD(xLocID))
				Continue:LocData=""
				Continue:$li(LocData,8)=""
				Set IsActive	=$li(LocData,14)
				Continue:(xLcLocID'="")&(xLcLocID'=xLocID)
				Continue:($lf(KeyList,xLocID)>0)
				Set KeyList=KeyList_$lb(xLocID)
				
				Set LocDesc=$li(LocData,3)
				Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
				Set LocDesc2=$li(LocData,4)
				Set:LocDesc2'="" LocDesc=LocDesc2
				
				Do BuildData(xLocID,"    "_LocDesc)			// 科室Data
			}
		}
	}
 	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
	
BuildData(DimensKey,DimensDesc)
	Set xRsType=""
	For {
		Set xRsType=$o(^TMP($zn,$j,NIndex,DimensKey,xRsType))
		Quit:xRsType=""
		Set objDict = ##class(DHCHAI.BT.Dictionary).GetObjById(xRsType)
		Quit:'$Isobject(objDict)
		Set xRsTypeDesc = objDict.BTDesc
		Set ObsPatCount  =+$g(^TMP($zn,$j,NIndex,DimensKey,xRsType,"ObsPatCount"))  //调查人数
		Set HandCount    =+$g(^TMP($zn,$j,NIndex,DimensKey,xRsType,"HandCount"))    //手消人次
		Set SoapCount    =+$g(^TMP($zn,$j,NIndex,DimensKey,xRsType,"SoapCount"))    //洗手人次
		Set SHandCount   =+$g(^TMP($zn,$j,NIndex,DimensKey,xRsType,"SHandCount"))   //+洗手手消人次
		Set NotCount     =+$g(^TMP($zn,$j,NIndex,DimensKey,xRsType,"NotCount"))     //未洗手人次
		Set CompRatio="0.00%"                                                //依从率%
		Set:(HandCount+SoapCount+SHandCount+NotCount)>0 CompRatio=$fn(((HandCount+SoapCount+SHandCount)/(HandCount+SoapCount+SHandCount+NotCount))*100,"",2)_"%" 
		Set CorrectCount =+$g(^TMP($zn,$j,NIndex,DimensKey,xRsType,"CorrectCount")) //洗手正确数
		Set CorrectRatio="0.00%"                                             //正确率%
		Set:(HandCount+SoapCount+SHandCount)>0 CorrectRatio=$fn((CorrectCount/(HandCount+SoapCount+SHandCount))*100,"",2)_"%" 
		// 病人前
		Set PBeforeHandCount    =+$g(^TMP($zn,$j,NIndex,DimensKey,xRsType,"PBeforeHandCount"))     //手消人次
		Set PBeforeSoapCount    =+$g(^TMP($zn,$j,NIndex,DimensKey,xRsType,"PBeforeSoapCount"))     //洗手人次
		Set PBeforeSHandCount   =+$g(^TMP($zn,$j,NIndex,DimensKey,xRsType,"PBeforeSHandCount"))    //洗手+手消人次	
		Set PBeforeNotCount     =+$g(^TMP($zn,$j,NIndex,DimensKey,xRsType,"PBeforeNotCount"))      //未洗手人次
		Set PBeforeCompRatio="0.00%"                                                        //依从率%
		Set Denominator = PBeforeHandCount+PBeforeSoapCount+PBeforeSHandCount+PBeforeNotCount
		Set Molecule    = PBeforeHandCount+PBeforeSoapCount+PBeforeSHandCount
		Set:Denominator>0 PBeforeCompRatio=$fn((Molecule/Denominator)*100,"",2)_"%" 
		Set PBeforeCorrectCount =+$g(^TMP($zn,$j,NIndex,DimensKey,xRsType,"PBeforeCorrectCount"))  //洗手正确数
		Set PBeforeCorrectRatio="0.00%"                                             //正确率%
		Set:Molecule>0 PBeforeCorrectRatio=$fn((PBeforeCorrectCount/Molecule)*100,"",2)_"%" 
		// 操作前 
		Set OBeforeHandCount    =+$g(^TMP($zn,$j,NIndex,DimensKey,xRsType,"OBeforeHandCount"))     //手消人次
		Set OBeforeSoapCount    =+$g(^TMP($zn,$j,NIndex,DimensKey,xRsType,"OBeforeSoapCount"))     //洗手人次
		Set OBeforeSHandCount   =+$g(^TMP($zn,$j,NIndex,DimensKey,xRsType,"OBeforeSHandCount"))    //洗手+手消人次	
		Set OBeforeNotCount     =+$g(^TMP($zn,$j,NIndex,DimensKey,xRsType,"OBeforeNotCount"))      //未洗手人次
		Set OBeforeCompRatio="0.00%"                                                        //依从率%
		Set Denominator = OBeforeHandCount+OBeforeSoapCount+OBeforeSHandCount+OBeforeNotCount
		Set Molecule    = OBeforeHandCount+OBeforeSoapCount+OBeforeSHandCount
		Set:Denominator>0 OBeforeCompRatio=$fn((Molecule/Denominator)*100,"",2)_"%"
		Set OBeforeCorrectCount =+$g(^TMP($zn,$j,NIndex,DimensKey,xRsType,"OBeforeCorrectCount"))  //洗手正确数
		Set OBeforeCorrectRatio="0.00%"                                             //正确率%
		Set:Molecule>0 OBeforeCorrectRatio=$fn((OBeforeCorrectCount/Molecule)*100,"",2)_"%" 
		// 体液后 
		Set SapHandCount        =+$g(^TMP($zn,$j,NIndex,DimensKey,xRsType,"SapHandCount"))         //手消人次
		Set SapSoapCount        =+$g(^TMP($zn,$j,NIndex,DimensKey,xRsType,"SapSoapCount"))         //洗手人次
		Set SapSHandCount       =+$g(^TMP($zn,$j,NIndex,DimensKey,xRsType,"SapSHandCount"))        //洗手+手消人次	
		Set SapNotCount         =+$g(^TMP($zn,$j,NIndex,DimensKey,xRsType,"SapNotCount"))          //未洗手人次
		Set SapCompRatio="0.00%"                                                        //依从率%
		Set Denominator = SapHandCount+SapSoapCount+SapSHandCount+SapNotCount
		Set Molecule    = SapHandCount+SapSoapCount+SapSHandCount
		Set:Denominator>0 SapCompRatio=$fn((Molecule/Denominator)*100,"",2)_"%"
		Set SapCorrectCount     =+$g(^TMP($zn,$j,NIndex,DimensKey,xRsType,"SapCorrectCount"))      //洗手正确数
		Set SapCorrectRatio="0.00%"                                             //正确率%
		Set:Molecule>0 SapCorrectRatio=$fn((SapCorrectCount/Molecule)*100,"",2)_"%" 
		// 病人后 
		Set PAfterHandCount    =+$g(^TMP($zn,$j,NIndex,DimensKey,xRsType,"PAfterHandCount"))       //手消人次
		Set PAfterSoapCount    =+$g(^TMP($zn,$j,NIndex,DimensKey,xRsType,"PAfterSoapCount"))       //洗手人次
		Set PAfterSHandCount   =+$g(^TMP($zn,$j,NIndex,DimensKey,xRsType,"PAfterSHandCount"))      //洗手+手消人次	
		Set PAfterNotCount     =+$g(^TMP($zn,$j,NIndex,DimensKey,xRsType,"PAfterNotCount"))        //未洗手人次
		Set PAfterCompRatio="0.00%"                                                        //依从率%
		Set Denominator = PAfterHandCount+PAfterSoapCount+PAfterSHandCount+PAfterNotCount
		Set Molecule    = PAfterHandCount+PAfterSoapCount+PAfterSHandCount
		Set:Denominator>0 PAfterCompRatio=$fn((Molecule/Denominator)*100,"",2)_"%"
		Set PAfterCorrectCount =+$g(^TMP($zn,$j,NIndex,DimensKey,xRsType,"PAfterCorrectCount"))    //洗手正确数
		Set PAfterCorrectRatio="0.00%"                                             //正确率%
		Set:Molecule>0 PAfterCorrectRatio=$fn((PAfterCorrectCount/Molecule)*100,"",2)_"%" 
		// 环境后 
		Set HAfterHandCount    =+$g(^TMP($zn,$j,NIndex,DimensKey,xRsType,"HAfterHandCount"))       //手消人次
		Set HAfterSoapCount    =+$g(^TMP($zn,$j,NIndex,DimensKey,xRsType,"HAfterSoapCount"))       //洗手人次
		Set HAfterSHandCount   =+$g(^TMP($zn,$j,NIndex,DimensKey,xRsType,"HAfterSHandCount"))      //洗手+手消人次	
		Set HAfterNotCount     =+$g(^TMP($zn,$j,NIndex,DimensKey,xRsType,"HAfterNotCount"))        //未洗手人次
		Set HAfterCompRatio="0.00%"                                                        //依从率%
		Set Denominator = HAfterHandCount+HAfterSoapCount+HAfterSHandCount+HAfterNotCount
		Set Molecule    = HAfterHandCount+HAfterSoapCount+HAfterSHandCount
		Set:Denominator>0 HAfterCompRatio=$fn((Molecule/Denominator)*100,"",2)_"%"
		Set HAfterCorrectCount =+$g(^TMP($zn,$j,NIndex,DimensKey,xRsType,"HAfterCorrectCount"))    //洗手正确数
		Set HAfterCorrectRatio="0.00%"                                             //正确率%
		Set:Molecule>0 HAfterCorrectRatio=$fn((HAfterCorrectCount/Molecule)*100,"",2)_"%" 
		//增加不正确输出
		//Set RsErrCount =+$g(^TMP($zn,$j,NIndex,DimensKey,xRsType,"ErrCount"))    //洗手不正确数
		Set RsErrCountRatio="0.00%"                                             //不正确率%
		Set:(HandCount+SoapCount+SHandCount)>0 RsErrCountRatio=$fn((100-$fn((CorrectCount/(HandCount+SoapCount+SHandCount))*100,"",2)),"",2)_"%"  
		Set RsErrWZXCount =+$g(^TMP($zn,$j,NIndex,DimensKey,xRsType,"ErrWZXCount"))    //未执行
		Set RsErrBWWQBDDCount =+$g(^TMP($zn,$j,NIndex,DimensKey,xRsType,"ErrBWWQBDDCount"))    //部位未全部达到
		Set RsErrSJBGCount =+$g(^TMP($zn,$j,NIndex,DimensKey,xRsType,"ErrSJBGCount"))    //时间不够
		Set RsErrQTCount =+$g(^TMP($zn,$j,NIndex,DimensKey,xRsType,"ErrQTCount"))    //其他
		
		Quit:(ObsPatCount<1)		
		Set Data=$lb(DimensKey,DimensDesc,ObsPatCount,HandCount,SoapCount,NotCount,CompRatio,CorrectCount,CorrectRatio,PBeforeHandCount,PBeforeSoapCount,PBeforeNotCount,PBeforeCompRatio,PBeforeCorrectCount,PBeforeCorrectRatio,OBeforeHandCount,OBeforeSoapCount,OBeforeNotCount,OBeforeCompRatio,OBeforeCorrectCount,OBeforeCorrectRatio,SapHandCount,SapSoapCount,SapNotCount,SapCompRatio,SapCorrectCount,SapCorrectRatio,PAfterHandCount,PAfterSoapCount,PAfterNotCount,PAfterCompRatio,PAfterCorrectCount,PAfterCorrectRatio,HAfterHandCount,HAfterSoapCount,HAfterNotCount,HAfterCompRatio,HAfterCorrectCount,HAfterCorrectRatio,SHandCount,PBeforeSHandCount,OBeforeSHandCount,SapSHandCount,PAfterSHandCount,HAfterSHandCount,xRsTypeDesc,xRsType,RsErrCountRatio,RsErrWZXCount,RsErrBWWQBDDCount,RsErrSJBGCount,RsErrQTCount)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit
}

ClassMethod QryHandHyRegStaClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHandHyRegStaExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryHandHyRegStaFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHandHyRegStaExecute ]
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

/// Creator：     pylian
/// CreatDate：   2021-06-28
/// Description:  医务人员手卫生依从率明细
/// Table：       DHCHAI.IR.HandHyReg、DHCHAI.IR.HandHyRegTim
/// Input:        aHospIDs  : 多个医院用"|"连接
///               aLocID    : 科室
///               aDateFrom ：开始日期
///               aDateTo   ：结束日期
///               aMethod   ：调查方式（字典维护的ID）
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S380HandHyCom","QryHandHyRegTim","1|2","","2021-12-20","2021-12-28","","洗手+手消")
Query QryHandHyRegTim(aHospIDs As %String, aLocID As %String, aDateFrom As %String, aDateTo As %String, aMethod As %String = "", aFacDesc As %String = "", aIsCorrect As %String = "", aObsType As %String = "") As %Query(ROWSPEC = "RegID:%String,Tim:%String,LocID:%String,LocDesc:%String,ObsDate:%String,ObsName:%String,TypeDesc:%String,OpportList:%String,BRQOpport:%String,CZQOpport:%String,TYQOpport:%String,BRHOpport:%String,WJHOpport:%String,SFacDesc:%String,XFacDesc:%String,XSFacDesc:%String,WFacDesc:%String,IsGloving:%String,IsCorrect:%String,ErrDesc:%String") [ SqlProc ]
{
}

ClassMethod QryHandHyRegTimExecute(ByRef qHandle As %Binary, aHospIDs As %String, aLocID As %String, aDateFrom As %String, aDateTo As %String, aMethod As %String = "", aFacDesc As %String = "", aIsCorrect As %String = "", aObsType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
    Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	
 	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
 	Set NIndex="QryHandHyRegTim"
	Kill ^TMP($zn,$j,NIndex)
	
	Set ObsOpportlist=##class(DHCHAI.BTS.DictionarySrv).GetDicList("HandHyOpportunity")
	Set OpportlistLen = $l(ObsOpportlist,$c(1))
	
 	For xDate=aDateFrom:1:aDateTo {	
 		Set xPage=""
 		For {
			Set xPage=$o(^DHCHAI.IR.HandHyRegI("IndexDatePage",xDate,xPage))
			Quit:xPage=""
			
			Set xID=""
			For {
				Set xID=$o(^DHCHAI.IR.HandHyRegI("IndexDatePage",xDate,xPage,xID))
				Quit:xID=""
				Set RegID=xID
				Set RegData=$g(^DHCHAI.IR.HandHyRegD(RegID))
				Continue:RegData=""
				Set IsActive=$li(RegData,6)
				Continue:IsActive'=1
				
				//增加调查方式过滤条件
				If (aMethod'=""){
					continue:aMethod'=$lg(RegData,10)
				}
				
				Set LocDr = $li(RegData,2)
				Continue:(aLocID'="")&&(aLocID'="全院")&&(aLocID'=LocDr)
				Set LocData = $g(^DHCHAI.BT.LocationD(LocDr))
				Set LocDesc = $li(LocData,3)
				Set HospDr=$li(LocData,8)
				Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)	
				Set ObsDate = $li(RegData,3)
				Set:ObsDate'="" ObsDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ObsDate)	

				Set xType=""
				For {
					Set xType=$o(^DHCHAI.IR.HandHyRegI("Tim","IndexObsTypeTime",RegID,xType))
					Quit:xType=""
					Continue:(aObsType'="")&&(xType'=aObsType)
					
					Set xTim=""
					For {
						Set xTim=$o(^DHCHAI.IR.HandHyRegI("Tim","IndexObsTypeTime",RegID,xType,xTim))
						Quit:xTim=""
						
						Set xSign=""
						For {
							Set xSign=$o(^DHCHAI.IR.HandHyRegI("Tim","IndexObsTypeTime",RegID,xType,xTim,xSign))
							Quit:xSign=""					
							
							Set xSubID=""
							For {
								Set xSubID=$o(^DHCHAI.IR.HandHyRegI("Tim","IndexObsTypeTime",RegID,xType,xTim,xSign,xSubID))
								Quit:xSubID=""
								Set ChildTimID=RegID_"||"_xSubID
								Set ChildTimData=$g(^DHCHAI.IR.HandHyRegD(RegID,"Tim",xSubID))
								// 手卫生指征
								Set (BRQOpport,CZQOpport,TYQOpport,BRHOpport,WJHOpport)=""
								Set OpportListDesc=""
								Set OpportList = $li(ChildTimData,8)
								If (OpportList'=""){
									For i=1:1:$l(OpportList,",") {
										Set OpportID=$p(OpportList,",",i)
										Set OpportData=$g(^DHCHAI.BT.DictionaryD(OpportID))
										Set BTDesc = $li(OpportData,3)
										Set:BTDesc'="" OpportListDesc=OpportListDesc_","_BTDesc
										Set:BTDesc["病人前" BRQOpport="是"
										Set:BTDesc["操作前" CZQOpport="是"
										Set:BTDesc["体液后" TYQOpport="是"
										Set:BTDesc["病人后" BRHOpport="是"
										Set:BTDesc["环境后" WJHOpport="是"
									}
								}
								Set OpportList=OpportListDesc
								
								// 手卫生措施(行为)
								Set FacID=$li(ChildTimData,5)
								Set FacData=$g(^DHCHAI.BT.DictionaryD(FacID))
								Set FacDesc = $li(FacData,3)
								Set FacCode = $li(FacData,2)
								Continue:(aFacDesc'="")&&(aFacDesc'=FacCode)
								Set (SFacDesc,XFacDesc,XSFacDesc,WFacDesc)=""
								Set:FacDesc="手消" SFacDesc="是"
								Set:FacDesc="洗手" XFacDesc="是"
								Set:FacDesc["洗手+手消" XSFacDesc="是"
								Set:(SFacDesc="")&&(XFacDesc="")&&(XSFacDesc="") WFacDesc="是"
								
								Set IsGloving = $li(ChildTimData,6)   // 是否戴手套
								Set IsGloving = $s(IsGloving="1":"是",1:"")   
								Set IsCorrect = $li(ChildTimData,7)   // 是否正确
								Continue:(aIsCorrect'="")&&(aIsCorrect'=IsCorrect)  
								Set IsCorrect = $s(IsCorrect="1":"是",1:"")   // 是否正确 
								
								Set ObsName = $li(ChildTimData,9)     // 姓名
								Set TypeData=$g(^DHCHAI.BT.DictionaryD(xType))
								Set TypeDesc = $li(TypeData,3)
								Set ErrResDrList = $li(ChildTimData,10)   // 不正确原因
								Set ErrResList=""
								If (ErrResDrList'=""){
									For i=1:1:$l(ErrResDrList,",") {
										Set ErrResID=$p(ErrResDrList,",",i)
										Set ErrResData=$g(^DHCHAI.BT.DictionaryD(ErrResID))
										Set ErrResDesc = $li(ErrResData,3)
										Set:ErrResDesc'="" ErrResList=ErrResList_","_ErrResDesc
									}
								}
							    Set:ErrResList'="" ErrResList=$e(ErrResList,2,$l(ErrResList))
							
								Set Data=$lb(RegID,xTim,LocDr,LocDesc,ObsDate,ObsName,TypeDesc,OpportList,BRQOpport,CZQOpport,TYQOpport,BRHOpport,WJHOpport,SFacDesc,XFacDesc,XSFacDesc,WFacDesc,IsGloving,IsCorrect,ErrResList)
								Set ^CacheTemp(repid,ind)=Data
								Set ind=ind+1

							}
						}
					}
				}
 			}
 		}
 	}
	Quit $$$OK
}

ClassMethod QryHandHyRegTimClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHandHyRegTimExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryHandHyRegTimFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHandHyRegTimExecute ]
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

}
