Class DHCMed.EPDService.Diseasevital Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:		chenrui
/// CreateDate:		2022-02-10
/// Description:  	传染病报告病种统计
/// Table：       	DHCMed.EPD.Infection、DHCMed.EPD.Epidemic
/// Input:        	aHospIDs： 多个医院用"|"连接
/// 			  	aDateFrom：开始日期
/// 			  	aDateTo：  结束日期
/// Return：      	返回ROWSPEC
/// 疾病列表：d ##class(%Library.ResultSet).RunQuery("DHCMed.EPDService.InfectionSrv","QryInfection","","")
/// d ##class(%Library.ResultSet).RunQuery("DHCMed.EPDService.Diseasevital","QryDisMap","2","2021-09-07","2022-02-10")
Query QryDisMap(aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "DisRank:%String,BTDecs:%String,DiseaseNum:%String") [ SqlProc ]
{
}

ClassMethod QryDisMapExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aRepStatus As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set DateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set DateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
	
 	Quit:(DateFrom>DateTo) $$$OK
 	
    Set:aHospIDs'="" aHospIDs=","_aHospIDs_","
    
	Set NIndex="QryDisMap"
	k ^TMP($zn,$j,NIndex)
	
	For xDate=DateFrom:1:DateTo{
		Set xLocID=""
		For{
			Set xLocID=$o(^DHCMed.EPDi("EPD",0,"DateLoc",xDate,xLocID))
			Quit:xLocID=""
			Set HospID=$p(^CTLOC(xLocID),"^",22)
			Continue:(aHospIDs'="")&&(aHospIDs'[(","_HospID_","))
			Set RepID=""
			For{
				Set RepID=$o(^DHCMed.EPDi("EPD",0,"DateLoc",xDate,xLocID,RepID))
				Quit:RepID=""
				Set objRep=##class(DHCMed.EPD.Epidemic).GetObjById(RepID)
				Continue:'$IsObject(objRep)
				Set Status=objRep.MEPDStatus
				Set objStatus=##class(DHCMed.SS.Dictionary).GetByTypeCode("EpidemicReportStatus",Status,"1")
				Continue:'$IsObject(objStatus)
				Set StatusDesc = objStatus.Description
				Continue:(StatusDesc="作废")  // 作废的报卡不统计
				Set DisRank = objRep.MEPDICDDR.MIFRank // 传染病等级
				Set:DisRank'="" DisRank = ..GetObjByTypeCode("EpidemicRank",DisRank)
				Set BTDecs=objRep.MEPDICDDR.MIFDisease
				Set ^TMP($zn,$j,NIndex,"Level",DisRank,"Desc",BTDecs,"Rep",RepID)=""
				Set Num=+$g(^TMP($zn,$j,NIndex,"Level",DisRank,"Desc",BTDecs))
				Set ^TMP($zn,$j,NIndex,"Level",DisRank,"Desc",BTDecs)=Num+1
			}
		}
	}
	Set xDisRank=""
	For{
		Set xDisRank=$o(^TMP($zn,$j,NIndex,"Level",xDisRank))
		Quit:xDisRank=""
		Set xBTDecs=""
		For{
			Set xBTDecs=$o(^TMP($zn,$j,NIndex,"Level",xDisRank,"Desc",xBTDecs))
			Quit:xBTDecs=""
			Set DiseaseNum=+$g(^TMP($zn,$j,NIndex,"Level",xDisRank,"Desc",xBTDecs))
			Set Data=$lb(xDisRank,xBTDecs,DiseaseNum)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}		
	}
	Quit $$$OK
}

ClassMethod QryDisMapClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDisMapExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDisMapFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDisMapExecute ]
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

/// Creator：     maxp
/// CreatDate：   2016-04-18
/// Description:  根据基础字典类别,基础字典项目名称获取基础字典记录
/// Table：       DHCMed.SS.Dictionary
/// Input：       type：   类型
///               code： 代码
/// Return：      返回obj
/// w ##class(DHCMed.EPDService.Diseasevital).GetObjByTypeCode("EpidemicRank","2")
ClassMethod GetObjByTypeCode(argTypeCode As %String, argCode As %String, argIsActive As %String = 1) As %String
{
	New (argTypeCode,argCode,argIsActive)
	Set return=""
	Quit:(argTypeCode="")||(argCode="") return
	
	Set TypeCode=$ZCVT(argTypeCode,"U")
	Set Code=$ZCVT(argCode,"U")
	Set DicID=0
	For {
		Set DicID=$o(^DHCMed.SS.DictionaryI("IndexTypeCode"," "_TypeCode," "_Code,DicID))
		Quit:DicID=""
		Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(DicID)
		Continue:'$IsObject(objDic)
		Set Code=objDic.Code
		Continue:Code'=argCode
		Set IsActive=objDic.Active
		Continue:(argIsActive'="")&&(argIsActive'=IsActive)
		Set return=objDic.Description
	}
	
	Quit return
}

}
