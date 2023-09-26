/// 名称: DHCHAI.STA.OccRepStaSrv
/// 描述: 职业暴露统计服务
/// 编写者：zhoubo
/// 编写日期: 2020-03-13
Class DHCHAI.STA.OccRepStaSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2020-03-13
/// Description:  查询职业暴露需统计的字典项目
/// Table：       DHCHAI.BT.DicType
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.STA.OccRepStaSrv","QryDicType")
Query QryDicType() As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String") [ SqlProc ]
{
}

ClassMethod QryDicTypeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	//设置需统计的项目代码，根据实际情况可以修改
	Set ItemCodeList = $lb("OEWorkAge","OEExpAddr","OEDuty","OERegType","OEPosition","OEDegree")
	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.BT.DicTypeD(xID))
		Quit:xID=""
		
		Set objDic = ##class(DHCHAI.BT.DicType).GetObjById(xID)
		Continue:'$Isobject(objDic)
		
		Set Code = objDic.BTCode
		Set Desc = objDic.BTDesc
		Continue:($LF(ItemCodeList,Code)<1)	
			
		Set Data = $lb(xID,Code,Desc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryDicTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDicTypeExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryDicTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDicTypeExecute ]
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

/// Creator：     zhoubo
/// CreatDate：   2020-03-16
/// Description:  查询职业暴露各项目例数
/// Table：       DHCHAI.IR.OccExpRegExt
/// Input:        aRegType  : 暴露类型
/// 			  aDateFrom : 开始日期
/// 			  aDateTo   : 结束日期  
///               aDicTypeCode : 暴露项目Code:DHCHAI.BT.DicType.Code
/// d ##class(%ResultSet).RunQuery("DHCHAI.STA.OccRepStaSrv","QryOccCaseSata","2","2020-02-01","2020-03-16","OEDuty")
Query QryOccCaseSata(aHospIDs As %String, aRegType As %String, aDateFrom As %String, aDateTo As %String, aDicTypeCode As %String, aDateType As %String = "") As %Query(ROWSPEC = "ID:%String,BTDesc:%String,Numerator:%String") [ SqlProc ]
{
}

ClassMethod QryOccCaseSataExecute(ByRef qHandle As %Binary, aHospIDs As %String, aRegType As %String, aDateFrom As %String, aDateTo As %String, aDicTypeCode As %String, aDateType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="")||(aDicTypeCode="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
	Set aHospIDs  = ##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	Set ZIndex=$zn,JIndex=$j,NIndex="Incidence"
	Kill ^TMP(ZIndex,JIndex,NIndex)
	
	Set xRegType=""
	For {
		Set xRegType=$o(^DHCHAI.IR.OccExpRegI("IndexRegTypeDate",xRegType))
		Quit:xRegType=""
		Continue:(aRegType'="")&&(aRegType'=xRegType)
		
		// 获取关联的字典
		Set ItemID=""
		Set xTypeExtCode=""
		For {
			Set xTypeExtCode=$o(^DHCHAI.IR.OccExpTypeI("EXT","IndexCode",xRegType,xTypeExtCode))
			Quit:xTypeExtCode=""
			
			Set TypeExtSub=$o(^DHCHAI.IR.OccExpTypeI("EXT","IndexCode",xRegType,xTypeExtCode,""))
			Set objTypeExt=##class(DHCHAI.IR.OccExpTypeExt).GetObjById(xRegType_"||"_TypeExtSub)
			Continue:'$IsObject(objTypeExt)
			
			Set BTDicType=objTypeExt.BTDicType
			Continue:'$IsObject(BTDicType)
			
			If (aDicTypeCode=BTDicType.BTCode) {
				Set ItemID=xRegType_"||"_TypeExtSub
				Quit
			}
		}
		Continue:ItemID=""
		
		//日期类型
		If (aDateType=1){	//登记日期
			Set OccRegIndex="IndexRegTypeDate"
		}
		else{				//暴露日期
			Set OccRegIndex="IndexTypeExpDate"
		}
		// 报告内填写的数据
		For xData=aDateFrom:1:aDateTo {
			Set xRepID=""
			For {
				Set xRepID=$o(^DHCHAI.IR.OccExpRegI(OccRegIndex,xRegType,xData,xRepID))
				Quit:xRepID=""
				
				Set objRep=##class(DHCHAI.IR.OccExpReg).GetObjById(xRepID)
				Continue:'$IsObject(objRep)
				
				Set objStatus  = objRep.OEStatusDr
			    Set StatusCode="",StatusDesc=""
				If $IsObject(objStatus) {
					Set StatusCode = objStatus.BTCode
					Set StatusDesc = objStatus.BTDesc
				}
				Continue:StatusCode=3   // 过滤删除的报告
				Set objLoc = objRep.OEExpLocDr
			    Continue:'$IsObject(objLoc)
				If $IsObject(objLoc.BTHospDr){
					Set HospID = objLoc.BTHospDr.%Id()			
					Continue:(aHospIDs'="")&($listfind(aHospIDs,HospID)<1)	//医院过滤	
				}
	
				//报告内详细项目
				Set xSubID=""
				For {
					Set xSubID=$o(^DHCHAI.IR.OccExpRegI("EXT","IndexItem",xRepID,ItemID,xSubID))
					Quit:xSubID=""
					
					Set objRepExt=##class(DHCHAI.IR.OccExpRegExt).GetObjById(xRepID_"||"_xSubID)
					Continue:'$IsObject(objRepExt)
					
					Set ResultDr=objRepExt.OEResultDr
					Set ResultList=objRepExt.OEResultList
					
					//结果
					If $IsObject(ResultDr) {
						Set Num = $i(^TMP(ZIndex,JIndex,NIndex,ResultDr.%Id()))
					}
					//结果List
					If (ResultList'="") {
						For indx = 1:1:ResultList.Count(){
						 	Set objDic = ResultList.GetAt(indx)
							Continue:'$IsObject(objDic)	
							Set Num = $i(^TMP(ZIndex,JIndex,NIndex,objDic.%Id()))
						} 
					}
				}
			}
		}
	}
	
	//遍历该字典类别的所有字典项目
	Set DicTypeID=$o(^DHCHAI.BT.DicTypeI("IdxofCode",aDicTypeCode,0))
	Quit:DicTypeID="" $$$OK
	Set xDicCode = ""
	For {
		Set xDicCode = $o(^DHCHAI.BT.DictionaryI("IdxofTypeDrCode",DicTypeID,xDicCode))
		Quit:xDicCode=""
		
		Set xID = ""
		For {
			Set xID = $o(^DHCHAI.BT.DictionaryI("IdxofTypeDrCode",DicTypeID,xDicCode,xID))
			Quit:xID=""
			
			Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjById(xID)
			Continue:'$Isobject(objDic)
			
			Set IsActive = objDic.BTIsActive
			Continue:IsActive'="1"
			
			Set BTDesc=objDic.BTDesc
			Set Numerator=+$g(^TMP(ZIndex,JIndex,NIndex,xID))
			
			Set Data=$lb(xID,BTDesc,Numerator)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Kill ^TMP(ZIndex,JIndex,NIndex)
	Quit $$$OK
}

ClassMethod QryOccCaseSataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOccCaseSataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOccCaseSataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOccCaseSataExecute ]
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

/// Creator：     zhoubo
/// CreatDate：   2020-03-19
/// Description:  查询职业暴露
/// Table：       DHCHAI.IR.OccExpReg
/// Input：		  aHospIDs  : 多个医院用"|"连接
/// 			  aRepType  : 报告类型
/// 			  aDateType : 日期类型
/// 			  aDateFrom : 开始日期
/// 			  aDateTo   : 结束日期       
/// d ##class(%ResultSet).RunQuery("DHCHAI.STA.OccRepStaSrv","QryOccExpReg","","2","1","2020-03-01","2020-03-19")
Query QryOccExpReg(aHospIDs As %String, aRepType As %String, aDateType As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "RepID:%String,LocDesc:%String,ResultDesc:%String") [ SqlProc ]
{
}

ClassMethod QryOccExpRegExecute(ByRef qHandle As %Binary, aHospIDs As %String, aRepType As %String, aDateType As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aHospIDs  = ##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom>aDateTo) $$$OK
 	Set:aDateFrom>+$h aDateFrom=+$h
 	Set:aDateTo>+$h aDateTo=+$h
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	
 	If aDateType=1 { //登记日期
	 	Set xType="" 
	 	For {
	 		Set xType=$o(^DHCHAI.IR.OccExpRegI("IndexRegTypeDate",xType))
			Quit:xType=""
			Continue:(aRepType'="")&&(aRepType'=xType)
			
			Set xDate=aDateFrom-1
			For {
				Set xDate=$o(^DHCHAI.IR.OccExpRegI("IndexRegTypeDate",xType,xDate))  //登记日期
				Quit:xDate=""
				Quit:xDate>aDateTo  
				
				Set xID=""
				For {
		 			Set xID=$o(^DHCHAI.IR.OccExpRegI("IndexRegTypeDate",xType,xDate,xID))
					Quit:xID=""
					
					Set Data=..BuildExpReg(xID)
					Continue:Data=""
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
	 	}
 	}Else {  //暴露日期
	 	Set xType="" 
	 	For {
	 		Set xType=$o(^DHCHAI.IR.OccExpRegI("IndexTypeExpDate",xType))
			Quit:xType=""
			Continue:(aRepType'="")&&(aRepType'=xType)
			
			Set xDate=aDateFrom-1
			For {
				Set xDate=$o(^DHCHAI.IR.OccExpRegI("IndexTypeExpDate",xType,xDate))  //暴露日期
				Quit:xDate=""
				Quit:xDate>aDateTo  
				
				Set xID=""
				For {
		 			Set xID=$o(^DHCHAI.IR.OccExpRegI("IndexTypeExpDate",xType,xDate,xID))
					Quit:xID=""	
					
					Set Data=..BuildExpReg(xID)
					Continue:Data=""
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}	
			}
		}
 	}
 	
	Quit $$$OK
}

ClassMethod QryOccExpRegClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOccExpRegExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOccExpRegFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOccExpRegExecute ]
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

/// Creator：     zhoubo
/// CreatDate：   2020-05-15
/// Description:  查询职业暴露明细
/// Table：       DHCHAI.IR.OccExpReg
/// Input：		  aHospIDs  : 多个医院用"|"连接
/// 			  aRepType  : 报告类型
/// 			  aDateType : 日期类型
/// 			  aDateFrom : 开始日期
/// 			  aDateTo   : 结束日期
///               aLocDesc  : 科室 
///               aOEDuty   : 职业类别     
/// d ##class(%ResultSet).RunQuery("DHCHAI.STA.OccRepStaSrv","QryOccExpRegDtl","","1","1","2020-03-01","2020-05-15","","本院医师")
Query QryOccExpRegDtl(aHospIDs As %String, aRepType As %String, aDateType As %String, aDateFrom As %String, aDateTo As %String, aLocDesc As %String, aOEDuty As %String) As %Query(ROWSPEC = "RepID:%String,RegTypeID:%String,RegTypeCode:%String,RegTypeDesc:%String,LocDesc:%String,OEDuty:%String,RegLocID:%String,RegLocDesc:%String,RegUserCode:%String,RegUserDesc:%String,ExposerCode:%String,ExposerDesc:%String,Name:%String,RegNo:%String,Sex:%String,Age:%String,WorkAge:%String,Duty:%String,ExpAddr:%String,TelPhone:%String,RegDate:%String,RegTime:%String,StatusCode:%String,StatusDesc:%String,ExpDate:%String,ExpTime:%String") [ SqlProc ]
{
}

ClassMethod QryOccExpRegDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String, aRepType As %String, aDateType As %String, aDateFrom As %String, aDateTo As %String, aLocDesc As %String, aOEDuty As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aHospIDs  = ##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom>aDateTo) $$$OK
 	Set:aDateFrom>+$h aDateFrom=+$h
 	Set:aDateTo>+$h aDateTo=+$h
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	
 	If aDateType=1 { //登记日期
	 	Set xType="" 
	 	For {
	 		Set xType=$o(^DHCHAI.IR.OccExpRegI("IndexRegTypeDate",xType))
			Quit:xType=""
			Continue:(aRepType'="")&&(aRepType'=xType)
			
			Set xDate=aDateFrom-1
			For {
				Set xDate=$o(^DHCHAI.IR.OccExpRegI("IndexRegTypeDate",xType,xDate))  //登记日期
				Quit:xDate=""
				Quit:xDate>aDateTo  
				
				Set xID=""
				For {
		 			Set xID=$o(^DHCHAI.IR.OccExpRegI("IndexRegTypeDate",xType,xDate,xID))
					Quit:xID=""
					
					Set Data=..BuildExpRegS(xID)
					Continue:Data=""
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
	 	}
 	}Else {  //暴露日期
	 	Set xType="" 
	 	For {
	 		Set xType=$o(^DHCHAI.IR.OccExpRegI("IndexTypeExpDate",xType))
			Quit:xType=""
			Continue:(aRepType'="")&&(aRepType'=xType)
			
			Set xDate=aDateFrom-1
			For {
				Set xDate=$o(^DHCHAI.IR.OccExpRegI("IndexTypeExpDate",xType,xDate))  //暴露日期
				Quit:xDate=""
				Quit:xDate>aDateTo  
				
				Set xID=""
				For {
		 			Set xID=$o(^DHCHAI.IR.OccExpRegI("IndexTypeExpDate",xType,xDate,xID))
					Quit:xID=""	
					
					Set Data=..BuildExpRegS(xID)
					Continue:Data=""
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}	
			}
		}
 	}
 	
	Quit $$$OK
}

ClassMethod QryOccExpRegDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOccExpRegDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOccExpRegDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOccExpRegDtlExecute ]
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

/// 取单个职业暴露报告主表信息
ClassMethod BuildExpRegS(aRepID As %String) As %List
{
	Set return = ""
	Quit:aRepID="" return
    
	Set objReg = ##class(DHCHAI.IR.OccExpReg).GetObjById(aRepID)
	Quit:'$IsObject(objReg) return

	Set objRegTypeDr  = objReg.OERegTypeDr
	Set RegTypeID="", RegTypeCode="",RegTypeDesc=""
	If $IsObject(objRegTypeDr) {
		Set RegTypeID = objRegTypeDr.%Id()
		Set RegTypeCode = objRegTypeDr.BTCode
		Set RegTypeDesc = objRegTypeDr.BTDesc
	}	   
    Set RegDate  = objReg.OERegDate
    Set:RegDate'="" RegDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RegDate) 
    Set RegTime  = objReg.OERegTime
 	Set:RegTime'="" RegTime=$zt(RegTime,1)
	   	
    Set objRegUser = objReg.OERegUserDr
    Set RegUserID="", RegUserCode="",RegUserDesc=""
	If $IsObject(objRegUser) {
		Set RegUserID = objRegUser.%Id()
		Set RegUserCode = objRegUser.BTCode
		Set RegUserDesc = objRegUser.BTDesc
	}	   	
    Set objStatus  = objReg.OEStatusDr
    Set StatusID="", StatusCode="",StatusDesc=""
	If $IsObject(objStatus) {
		Set StatusID = objStatus.%Id()
		Set StatusCode = objStatus.BTCode
		Set StatusDesc = objStatus.BTDesc
	}
	Quit:StatusCode=3 return  // 过滤删除的报告
    Set objRegLoc  = objReg.OERegLocDr	
    Set RegLocID="", RegLocCode="",RegLocDesc=""
	If $IsObject(objRegLoc) {
		Set RegLocID = objRegLoc.%Id()
		Set RegLocCode = objRegLoc.BTCode
		Set RegLocDesc = objRegLoc.BTDesc
		If $IsObject(objRegLoc.BTHospDr){
			Set HospID=objRegLoc.BTHospDr.%Id()	
		}
	}
	Set objLoc = objReg.OEExpLocDr	
    Set LocID="",LocDesc=""
    Quit:'$IsObject(objLoc) return
	Set LocID   = objLoc.%Id()
	Set LocDesc = objLoc.BTDesc
	Quit:(aLocDesc'="")&&(aLocDesc'=LocDesc) return
	If $IsObject(objLoc.BTHospDr){
		Set HospID = objLoc.BTHospDr.%Id()			
		Quit:(aHospIDs'="")&($listfind(aHospIDs,HospID)<1) return 	//医院过滤	
	}
    Set objExposer = objReg.OEExposerDr
    Set ExposerID="", ExposerCode="",ExposerDesc=""
	If $IsObject(objExposer) {
		Set ExposerID = objExposer.%Id()
		Set ExposerCode = objExposer.BTCode
		Set ExposerDesc = objExposer.BTDesc
	}	   	
    Set ExpDate  = objReg.OEExpDate
    Set:ExpDate'="" ExpDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ExpDate) 
    Set ExpTime  = objReg.OEExpTime
    Set:ExpTime'="" ExpTime=$zt(ExpTime,1)
    
    Set Name    = objReg.OEName
    Set RegNo   = objReg.OERegNo
    Set Sex     = objReg.OESex
    Set Sex = $s(Sex="M":"男",Sex="F":"女",Sex="O":"其他")  //M男、F女、O其他
    Set Age     = objReg.OEAge
    Set WorkAge = objReg.OEWorkAge
    Set Duty    = objReg.OEDuty
    Set ExpAddr = objReg.OEExpAddr
    Set TelPhone= objReg.OETelPhone
 	Set OEDuty=""
 	Set xSubID = ""
	For {
		Set xSubID =$o(^DHCHAI.IR.OccExpRegD(aRepID,"EXT",xSubID))
		Quit:xSubID=""
		
		Set ExtID=aRepID_"||"_xSubID
		Set objExt = ##class(DHCHAI.IR.OccExpRegExt).GetObjById(ExtID)
	    Continue:'$IsObject(objExt) 
		Set objItemDr  = objExt.OEItemDr
	    Continue:'$IsObject(objItemDr)
	    Set Code = objItemDr.BTCode	   
	    Set Desc = objItemDr.BTDesc
	    
	    Continue:'$IsObject(objItemDr.BTDicType)	    
	    Set TypeCode = objItemDr.BTDicType.BTCode	   
	    Set TypeDesc = objItemDr.BTDicType.BTDesc
	  	Continue:TypeCode'="OEDuty" 
	  	
		Set objResult = objExt.OEResultDr
		Set ResultID="", ResultCode="",ResultDesc=""
		If $IsObject(objResult) {
			Set ResultID = objResult.%Id()
			Set ResultCode = objResult.BTCode
			Set ResultDesc = objResult.BTDesc
		}
		Continue:ResultDesc=""
		Set OEDuty=ResultDesc
	}
	Quit:(aOEDuty'="")&&(aOEDuty'=OEDuty) ""
	Quit:OEDuty="" ""
	//取工龄存在了子表中
	Set WorkAge=""
 	Set xSubID = ""
	For {
		Set xSubID =$o(^DHCHAI.IR.OccExpRegD(aRepID,"EXT",xSubID))
		Quit:xSubID=""
		
		Set ExtID=aRepID_"||"_xSubID
		Set objExt = ##class(DHCHAI.IR.OccExpRegExt).GetObjById(ExtID)
	    Continue:'$IsObject(objExt) 
		Set objItemDr  = objExt.OEItemDr
	    Continue:'$IsObject(objItemDr)
	    Set Code = objItemDr.BTCode	   
	    Set Desc = objItemDr.BTDesc
	    
	    Continue:'$IsObject(objItemDr.BTDicType)	    
	    Set TypeCode = objItemDr.BTDicType.BTCode	   
	    Set TypeDesc = objItemDr.BTDicType.BTDesc
	  	Continue:TypeCode'="OEWorkAge" 
	  	
		Set objResult = objExt.OEResultDr
		Set ResultID="", ResultCode="",ResultDesc=""
		If $IsObject(objResult) {
			Set ResultID = objResult.%Id()
			Set ResultCode = objResult.BTCode
			Set ResultDesc = objResult.BTDesc
		}
		Continue:ResultDesc=""
		Set WorkAge=ResultDesc
	}
    Set return=$lb(aRepID,RegTypeID,RegTypeCode,RegTypeDesc,LocDesc,OEDuty,RegLocID,RegLocDesc,RegUserCode,RegUserDesc,ExposerCode,ExposerDesc,Name,RegNo,Sex,Age,WorkAge,Duty,ExpAddr,TelPhone,RegDate,RegTime,StatusCode,StatusDesc,ExpDate,ExpTime)
    Quit return
}

/// 取单个职业暴露报告主表信息
ClassMethod BuildExpReg(aRepID As %String) As %List
{
	Set return = ""
	Quit:aRepID="" return
    
	Set objReg = ##class(DHCHAI.IR.OccExpReg).GetObjById(aRepID)
	Quit:'$IsObject(objReg) return
      	
    Set objStatus = objReg.OEStatusDr
    Set StatusID="", StatusCode="",StatusDesc=""
	If $IsObject(objStatus) {
		Set StatusID   = objStatus.%Id()
		Set StatusCode = objStatus.BTCode
		Set StatusDesc = objStatus.BTDesc
	}
	Quit:StatusCode=3 return  // 过滤删除的报告
    
    Set objLoc = objReg.OEExpLocDr	
    Set LocID="",LocDesc=""
    Quit:'$IsObject(objLoc) return
	Set LocID   = objLoc.%Id()
	Set LocDesc = objLoc.BTDesc
	If $IsObject(objLoc.BTHospDr){
		Set HospID = objLoc.BTHospDr.%Id()			
		Quit:(aHospIDs'="")&($listfind(aHospIDs,HospID)<1) return 	//医院过滤	
	}
	
	Set xSubID = ""
	For {
		Set xSubID =$o(^DHCHAI.IR.OccExpRegD(aRepID,"EXT",xSubID))
		Quit:xSubID=""
		
		Set ExtID=aRepID_"||"_xSubID
		Set objExt = ##class(DHCHAI.IR.OccExpRegExt).GetObjById(ExtID)
	    Continue:'$IsObject(objExt) 
		Set objItemDr  = objExt.OEItemDr
	    Continue:'$IsObject(objItemDr)
	    Set Code = objItemDr.BTCode	   
	    Set Desc = objItemDr.BTDesc
	    
	    Continue:'$IsObject(objItemDr.BTDicType)	    
	    Set TypeCode = objItemDr.BTDicType.BTCode	   
	    Set TypeDesc = objItemDr.BTDicType.BTDesc
	  	Continue:TypeCode'="OEDuty" 
	  	
		Set objResult = objExt.OEResultDr
		Set ResultID="", ResultCode="",ResultDesc=""
		If $IsObject(objResult) {
			Set ResultID = objResult.%Id()
			Set ResultCode = objResult.BTCode
			Set ResultDesc = objResult.BTDesc
		}
		Continue:ResultDesc=""
		Set return=$lb(aRepID,LocDesc,ResultDesc)
	}
	
    Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2020-03-13
/// Description:  查询职业暴露需统计的字典项目
/// Table：       DHCHAI.BT.DicType
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.STA.OccRepStaSrv","QryDateType")
Query QryDateType() As %Query(ROWSPEC = "ID:%String,Desc:%String") [ SqlProc ]
{
}

ClassMethod QryDateTypeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set Data = $lb("1","登记日期")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	
	Set Data = $lb("2","暴露日期")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	
	Quit $$$OK
}

ClassMethod QryDateTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDateTypeExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryDateTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDateTypeExecute ]
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
