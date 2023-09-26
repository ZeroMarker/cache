/// 名称: DHCHAI.IRS.ASPOrdItemSrv
/// 描述: 抗菌用药导向计划医嘱相关服务
/// 编写者：mayanpeng
/// 编写日期: 2017-12-05
Class DHCHAI.IRS.ASPOrdItemSrv Extends (%RegisteredObject, DHCHAI.Abstract, User.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     mayanpeng
/// CreatDate：   2017-12-05
/// Description:  抗生素评估医嘱列表
/// Table：       DHCHAI.DP.OEOrdItem、DHCHAI.IR.ASPOrdItem
/// Input：       aEpisodeID : 就诊号
/// 			  aDateFrom:计算开始时间（默认当天）
/// 			  aDates:历史天数，默认15
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.ASPOrdItemSrv","QryAspOrdList","140755","2018-11-22","","1")
Query QryAspOrdList(aEpisodeID As %String, aDateFrom As %String, aDates As %String = 15, aPowerType As %String) As %Query(ROWSPEC = "ID:%String,OEGeneric:%String,AntiMastID:%String,OEPriority:%String,OEDoseQty:%String,OEDoseQtyUom:%String,OEFreqDesc:%String,OESttDate:%String,OEXDate:%String,OEOrdLoc:%String,OEDoctor:%String,IsOpinion:%String,PharProID:%String,PharOpinion:%String,ExperProID:%String,ExperOpinion:%String") [ SqlProc ]
{
}

ClassMethod QryAspOrdListExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aDateFrom As %String, aDates As %String = 15, aPowerType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:aEpisodeID="" $$$OK
 	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
 	Set:aDateFrom="" aDateFrom=$p($h,",",1)
 	Set objAdm=##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeID)
 	Quit:'$IsObject(objAdm) $$$OK
 	Set DischDate=objAdm.PADischDate //出院日期
 	
 	//配置的医嘱筛查类型
 	Set ASPOEOrdPriority=##class(DHCHAI.BT.Config).GetValByCode("ASPOEOrdPriority")
 	
 	Set xCode=""
 	For {
	 	Set xCode = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeID,xCode))
	 	Quit:xCode=""
	 	
	 	//倒序历史日期
	 	For xDate=aDateFrom:-1:aDateFrom-(+aDates-1) {
		 	Set OrdID = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeID,xCode,"1",xDate,""))
			Continue:OrdID=""
			
			Set IsOpinion=0
			Set xOrdID=""
			For {
				Set xOrdID = $o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeID,xCode,"1",xDate,xOrdID))
				Quit:xOrdID=""
				
				Set objOEOrd = ##class(DHCHAI.DP.OEOrdItem).GetObjById(xOrdID)
				Continue:'$IsObject(objOEOrd)
				Continue:objOEOrd.OEIsActive'=1
				
				Set Priority=objOEOrd.OEPriority //医嘱类型(长期/临时)
				If (ASPOEOrdPriority'="") {
					Continue:(ASPOEOrdPriority="1")&&(Priority'="长期医嘱")
					Continue:(ASPOEOrdPriority="2")&&(Priority'="临时医嘱")
				}
				
				Set OEOrdDesc = objOEOrd.OEOrdDesc
				Set objAntiMast=##class(DHCHAI.DP.OEAntiMastMap).GetObjByAntiDesc(xCode,OEOrdDesc)
				Continue:'$IsObject(objAntiMast)
				Set objOEAnti = objAntiMast.BTMapItemDr
				Continue:'$IsObject(objOEAnti)
				Set AntiMastID = objOEAnti.%Id()
				Set OEGeneric = objOEAnti.BTName
				
				//排除未维护的抗菌药物
				Continue:##class("DHCHAI.IRS.CRuleAntiSrv").IsExistAntiMast(OEGeneric)<1
				
				Set OEPriority = objOEOrd.OEPriority
				Set OEDoseQty = objOEOrd.OEDoseQty
				Set OEDoseQtyUom = objOEOrd.OEDoseQtyUom
				Set OEFreqDesc = objOEOrd.OEFreqDesc
				Set OESttDate = objOEOrd.OESttDate
				Set OEXDate = objOEOrd.OEXDate
				Set OEOrdLoc = objOEOrd.OEOrdLocDr.BTDesc
				Set:OEOrdLoc="" OEOrdLoc=$p(objOEOrd.OEOrdLoc,"|",3)
				Set OEDoctor = $p(objOEOrd.OEDoctor,"|",3)
				Set:OESttDate'="" OESttDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OESttDate)
				Set:(OEXDate="")&&(DischDate'="") OEXDate=DischDate
				Set:OEXDate'="" OEXDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OEXDate)
				
				//处置情况
				Set OpinionInfo=##class("DHCHAI.IRS.ASPProgramSrv").GetOpStatus(xOrdID)
				Set PharOpinion=$p(OpinionInfo,"^",1)
				Set ExperOpinion=$p(OpinionInfo,"^",2)
				
				Set IsOpinion=0
				Set:(aPowerType="0")&&(PharOpinion'="未处置")&&(PharOpinion'="需关注") IsOpinion=1
				Set:(aPowerType="1")&&(ExperOpinion'="未处置")&&(ExperOpinion'="需关注") IsOpinion=1
				If aPowerType="" {
					If (PharOpinion'="未处置")||(ExperOpinion'="未处置"){
						If (PharOpinion'="需关注")||(ExperOpinion'="需关注") {
							Set IsOpinion=1
						}
					}
				}
				Set PharProID=..GetProgramByOrdID(xOrdID,"0")
				Set ExperProID=..GetProgramByOrdID(xOrdID,"1")
				
				Set Data=$lb(xOrdID,OEGeneric,AntiMastID,OEPriority,OEDoseQty,OEDoseQtyUom,OEFreqDesc,OESttDate,OEXDate,OEOrdLoc,OEDoctor,IsOpinion,PharProID,PharOpinion,ExperProID,ExperOpinion)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
 	Quit $$$OK
}

ClassMethod QryAspOrdListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAspOrdListExnmecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAspOrdListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAspOrdListExecute ]
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

/// Creator：     mayanpeng
/// CreatDate：   2018-11-21
/// Description:  获取主评估ID
/// Table：       DHCHAI.IR.CRuleAnti
/// Input：       aOEOrdID:DHCHAI.IR.ASPOrdItem.ID, aPowerType:0药师、1专家
/// Return：      返回ID成功或小于0失败
/// w ##class("DHCHAI.IRS.ASPOrdItemSrv").GetProgramByOrdID("6231170","0")
ClassMethod GetProgramByOrdID(aOEOrdID As %String, aPowerType As %String) As %String
{
	New (aOEOrdID,aPowerType)
	Set return=0
	Quit:(aOEOrdID="") return
	Set aPowerType=$s(aPowerType="0":"1",aPowerType="1":"2",1:"1") //对应表数据,默认药师
	
	Set objOEOrd=##class(DHCHAI.DP.OEOrdItem).GetObjById(aOEOrdID)
	Quit:'$IsObject(objOEOrd) return
	Set EpisodeDr=objOEOrd.OEEpisodeDr
	Quit:'$IsObject(EpisodeDr) return
	Set EpisodeID=EpisodeDr.%Id()
	
	Set xProID=""
	For {
		Set xProID = $o(^DHCHAI.IR.ASPProgramI("IndexEpisodeDrType",EpisodeID,aPowerType,xProID))
		Quit:xProID=""
		Quit:return>0
		
		Set objPro=##class(DHCHAI.IR.ASPProgram).GetObjById(xProID)
		Continue:'$IsObject(objPro)
		
		Set xItemID=""
		For {
			Set xItemID=$o(^DHCHAI.IR.ASPOrdItemI("IndexProOrdItem",xProID,aOEOrdID,xItemID))
			Quit:xItemID=""
			
			Set return=xProID
			Quit
		}
	}
	Quit return
}

/// Creator：     mayanpeng
/// CreatDate：   2017-12-07
/// Description:  保存抗生素评估意见
/// Table：       DHCHAI.IR.CRuleAnti
/// Input：       各属性列表 ^分隔
/// Return：      返回1成功或小于0失败
/// w ##class("DHCHAI.IRS.ASPOrdItemSrv").UpdateAsp("147808^1^1^^^3884^7^合理^114|114^6222385|6222389","^")
ClassMethod UpdateAsp(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:(InStr="") return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	//DHCHAI.IR.ASPProgram
	Set EpisodeDr	= $p(InStr,aSeparete,1)
	Set CheckType	= $p(InStr,aSeparete,2)
	Set CheckResult	= $p(InStr,aSeparete,3)
	Set CheckDate	= $p(InStr,aSeparete,4)
	Set CheckTime	= $p(InStr,aSeparete,5)
	Set CheckUserDr	= $p(InStr,aSeparete,6)
	//DHCHAI.IR.ASPOrdItem
	Set AntiMastDr	= $p(InStr,aSeparete,7)
	Set OrdItemDr	= $p(InStr,aSeparete,8)
	//DHCHAI.IR.ASPOpinion
	Set OpinionCode	= $p(InStr,aSeparete,9)
	Set OpinionTxt	= $p(InStr,aSeparete,10)
	
	TStart
	
	Set ProId=0
	Set ProStr = "^"_EpisodeDr_"^"_CheckType_"^"_CheckResult_"^"_CheckDate_"^"_CheckTime_"^"_CheckUserDr
	Set ProId=##class(DHCHAI.IR.ASPProgram).Update(ProStr,"^")
	TrollBack:ProId<1
	Quit:ProId<1 return
	
	Set OrdId=0
	For j=1:1:$l(OrdItemDr,"|"){
		Set Anti = $p(AntiMastDr,"|",j)
		Set OEOrdId = $p(OrdItemDr,"|",j)
		Continue:(Anti="")||(OEOrdId="")
		Set OrdStr = "^"_ProId_"^"_Anti_"^"_OEOrdId
		Set OrdId = ##class(DHCHAI.IR.ASPOrdItem).Update(OrdStr,"^")
		Quit:OrdId<1
	}
	TrollBack:OrdId<1
	Quit:OrdId<1 return
	
	// 处置方案在合理时有可能为空
	If (OpinionCode'=""){
		Set OpinionId=0
		For i=1:1:$l(OpinionCode,"|"){
			Set Code = $p(OpinionCode,"|",i)
			Set Txt = $p(OpinionTxt,"|",i)
			Continue:(Code="")||(Txt="")
			Set DicID = ##Class(DHCHAI.BTS.DictionarySrv).GetIDByCode("IRASPOpinionType",Code,"")
			Continue:DicID=""
			Set OpinionStr = "^"_ProId_"^"_DicID_"^"_Txt
			Set OpinionId=##class(DHCHAI.IR.ASPOpinion).Update(OpinionStr,"^")
			Quit:OpinionId<1
		}
		TrollBack:OpinionId<1
		Quit:OpinionId<1 return
	}
	
	TCommit
	
	Quit 1
}

/// Creator：     mayanpeng
/// CreatDate：   2018-11-02
/// Description:  抗生素评估方案列表(字典表中取)
/// Table：       DHCHAI.BT.Dictionary
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.ASPOrdItemSrv","QryAspMethods","1|2|3","")
Query QryAspMethods(aDicCodes As %String, aIsActive As %String) As %Query(ROWSPEC = "ID:%String,DicCode:%String,DicDesc:%String,TypeCode:%String,TypeDesc:%String,IndNo:%String,IsActive:%String,IsActDesc:%String") [ SqlProc ]
{
}

ClassMethod QryAspMethodsExecute(ByRef qHandle As %Binary, aDicCodes As %String, aIsActive As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	If (aDicCodes=""){
	 	Set objType=##class(DHCHAI.BT.DicType).GetObjByCode("IRASPOpinionType")
		Quit:'$IsObject(objType) $$$OK
		Set TypeID=objType.%Id()
		
	 	Set xCode = ""
		For {
			Set xCode = $o(^DHCHAI.BT.DictionaryI("IdxofTypeDrCode",TypeID,xCode))
			Quit:xCode=""
			
			Set xID = ""
			For {
				Set xID = $o(^DHCHAI.BT.DictionaryI("IdxofTypeDrCode",TypeID,xCode,xID))
				Quit:xID=""
				
				Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjById(xID)
				Continue:'$Isobject(objDic)
				
				Set DicCode  = objDic.BTCode
			    Set DicDesc  = objDic.BTDesc	
			    Set TypeCode="",TypeDesc=""
			    If $Isobject(objDic.BTTypeDr){
				    Set TypeCode=objDic.BTTypeDr.BTCode
				    Set TypeDesc=objDic.BTTypeDr.BTDesc
			    }
			    Set IndNo    = objDic.BTIndNo
			    Set IsActive = objDic.BTIsActive
			   	Continue:(aIsActive'="")&&(aIsActive'=IsActive)
		        Set IsActDesc=$s(IsActive=1:"是",1:"否")
				Set Data=$lb(xID,DicCode,DicDesc,TypeCode,TypeDesc,IndNo,IsActive,IsActDesc)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	 } Else {
		 Set aDicCodes=##class(DHCHAI.Utils.CommonSrv).ListFromString(aDicCodes,"|")
		 For index=1:1:$ListLength(aDicCodes) {
			Set xDicCode=$List(aDicCodes,index)
			Set xDicID=##Class(DHCHAI.BTS.DictionarySrv).GetIDByCode("IRASPOpinionType",xDicCode,aIsActive)
			Continue:xDicID=""
			Set objDic=##class(DHCHAI.BT.Dictionary).GetObjById(xDicID)
			Continue:'$IsObject(objDic)
			
			Set DicCode  = objDic.BTCode
		    Set DicDesc  = objDic.BTDesc	
		    Set TypeCode="",TypeDesc=""
		    If $Isobject(objDic.BTTypeDr){
			    Set TypeCode=objDic.BTTypeDr.BTCode
			    Set TypeDesc=objDic.BTTypeDr.BTDesc
		    }
		    Set IndNo    = objDic.BTIndNo
		    Set IsActive = objDic.BTIsActive
		   	Continue:(aIsActive'="")&&(aIsActive'=IsActive)
	        Set IsActDesc=$s(IsActive=1:"是",1:"否")
			Set Data=$lb(xID,DicCode,DicDesc,TypeCode,TypeDesc,IndNo,IsActive,IsActDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
 	Quit $$$OK
}

ClassMethod QryAspMethodsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAspMethodsExnmecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAspMethodsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAspMethodsExecute ]
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

/// Creator：     mayanpeng
/// CreatDate：   2018-11-28
/// Description:  取出抗生素评估所有内容
/// Table：       DHCHAI.IR.ASPProgram,DHCHAI.IR.ASPOrdItem,DHCHAI.IR.ASPOpinion
/// Return：      返回ROWSPEC
/// w ##class(DHCHAI.IRS.ASPOrdItemSrv).getAllOpinion(24)
ClassMethod getAllOpinion(aProID As %String) As %String
{
	New (aProID)
	Set return=""
	Quit:(aProID="") return
	
	//DHCHAI.IR.ASPProgram
	Set objPro=##class(DHCHAI.IR.ASPProgram).GetObjById(aProID)
	Quit:'$IsObject(objPro) return
	Set CheckType	= objPro.IRCheckType //1药师审核Phar、2专家审核Exper
	Set CheckResult	= objPro.IRCheckResult //0不合理、1合理、2需关注
	Set CheckDate	= objPro.IRCheckDate
	Set CheckTime	= objPro.IRCheckTime
	Set CheckUserDr	= objPro.IRCheckUserDr
	Set (CheckUserID,CheckUserDesc)=""
	If $IsObject(CheckUserDr){
		Set CheckUserID=CheckUserDr.%Id()
		Set CheckUserDesc=CheckUserDr.BTDesc
	}
	Set Programs=aProID_"^"_CheckType_"^"_CheckResult_"^"_CheckDate_"^"_CheckTime_"^"_CheckUserID_"^"_CheckUserDesc
	
	//DHCHAI.IR.ASPOrdItem
	Set OrdItems=""
	Set xASPOrdID=""
	For {
		Set xASPOrdID=$o(^DHCHAI.IR.ASPOrdItemI("IndexProgramDr",aProID,xASPOrdID))
		Quit:xASPOrdID=""
		
		Set objASPOrd=##class(DHCHAI.IR.ASPOrdItem).GetObjById(xASPOrdID)
		Continue:'$IsObject(objASPOrd)
		Set xOEOrdID=objASPOrd.IROrdItemDr.%Id()
		Set xAntiID=objASPOrd.IRAntiMastDr.%Id()
		Set OrdItems=OrdItems_"|"_xOEOrdID_"^"_xAntiID
	}
	Set OrdItems=$e(OrdItems,2,$l(OrdItems))
	
	//DHCHAI.IR.ASPOpinion
	Set Opinions=""
	Set xDicID=""
	For {
		Set xDicID=$o(^DHCHAI.IR.ASPOpinionI("IndexOpinionDr",aProID,xDicID))
		Quit:xDicID=""
		
		Set objDic=##class(DHCHAI.BT.Dictionary).GetObjById(xDicID)
		Continue:'$IsObject(objDic)
		Continue:'$IsObject(objDic.BTTypeDr)
		Continue:objDic.BTTypeDr.BTCode'="IRASPOpinionType"
		
		Set xASPOpinID=""
		For {
			Set xASPOpinID=$o(^DHCHAI.IR.ASPOpinionI("IndexOpinionDr",aProID,xDicID,xASPOpinID))
			Quit:xASPOpinID=""
			
			Set objASPOpin=##class(DHCHAI.IR.ASPOpinion).GetObjById(xASPOpinID)
			Continue:'$IsObject(objASPOpin)
			
			Set DicID=xDicID
			Set DicCode=objDic.BTCode
			Set OpinionTxt=objASPOpin.IROpinionTxt
			Set Opinions=Opinions_"|"_DicID_"^"_DicCode_"^"_OpinionTxt
		}
	}
	Set Opinions=$e(Opinions,2,$l(Opinions))
	
	Quit Programs_"#"_OrdItems_"#"_Opinions
}

}
