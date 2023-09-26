/// 常见病原体和抗生素敏感性统计结果
Class DHCMed.NINFService.Sta.CommonGermDrugSenSta Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// DateType:1-入院 2-出院 3-在院
/// w ##class(DHCMed.CCService.IntegratedControl.Common).GetEpisodeList("2011-1-1","2012-08-01",2,"I","2,8,9","")
ClassMethod GetEpisodeList(FromDate As %String, ToDate As %String, DateType As %Integer, EpisodeType As %String, CtlocIDList As %String, WardIDList As %String) As %Integer
{
		n (FromDate,CtlocIDList,DateType,ToDate,WardIDList,EpisodeType)
		Set repid=$I(^CacheTemp)
		
		Set:FromDate["/" FromDate=$zdh(FromDate,4)
		Set:ToDate["/" ToDate=$zdh(ToDate,4)
		Set:FromDate["-" FromDate=$zdh(FromDate,3)
		Set:ToDate["-" ToDate=$zdh(ToDate,3)
			
		Set CtlocIDList1=","_CtlocIDList_","
		Set WardIDList1=","_WardIDList_","
		if ((DateType=1)!(DateType=2)) {
			//住院日期的索引是  ^PAADMi("PAADM_AdmDate",{PAADM_AdmDate},{PAADM_RowID})
			//出院日期的索引是：^PAADMi("DischDate",{PAADM_DischgDate},{PAADM_RowID}) 或 ^PAADMi("EstDisch",{PAADM_EstimDischargeDate},{PAADM_RowID}) 
		    Set DischDateIndex=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引
			Set AdmDateIndex=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateIndex()      //update by pylian 2016-02-18取入院时间索引
			
			Set:DateType=1 IndexNode=AdmDateIndex
			Set:DateType=2 IndexNode=DischDateIndex
			For tmpDate=FromDate:1:ToDate {
				Set EpisodeID=""
				For {
					Set EpisodeID=$o(^PAADMi(IndexNode,tmpDate,EpisodeID))
					Quit:EpisodeID=""
					Continue:$d(^PAADMi("PAADM_Type",EpisodeType,EpisodeID))=0 //没有找到对应的Paadm
					Set AdmData=$g(^PAADM(EpisodeID))
					Set loc=","_$p(AdmData,"^",4)_","
					Set WardID=","_+##class(DHCMed.Base.PacWard).GetByLocLink(+$p(AdmData,"^",70))_","  //将病房ID转换成对应的CTLOC的ID
					;w "------"_EpisodeID_"   "_loc_"   "_WardID,!
					Continue:((CtlocIDList1'[loc)&&(CtlocIDList'="")) //科室不匹配
					Continue:((WardIDList1'[WardID)&&(WardIDList'="")) //病房不匹配
					;w EpisodeID_"   "_loc_"   "_WardID,!
					Set loc=$p(loc,",",2)
					Set WardID=$p(WardID,",",2)
					
					Set ^CacheTemp("EpisodeList",repid,"DepWard",+loc,+WardID,EpisodeID)=""
					Set ^CacheTemp("EpisodeList",repid,"All",EpisodeID)=""
				}
			}	
		}
		if (DateType=3)
		{
			Set WardID=""
			For {
				Set WardID=$o(^PAADMi("CurrWard",WardID))
				Quit:WardID=""
				Set objWard=##class(DHCMed.Base.PacWard).GetObjById(WardID)
				Set WardID1=","_objWard.CtlocDr_","
				Continue:((WardIDList1'[WardID1)&&(WardIDList'=""))					
				Set:$IsObject(objWard)=0 objWard=##class(DHCMed.Base.PacWard).%New()
				Do objWard.%Close()
				Set RoomID=""
				For {
					Set RoomID=$o(^PAADMi("CurrWard",WardID,RoomID))
					Quit:RoomID=""
					Set EpisodeID=""
					For {
						Set EpisodeID=$o(^PAADMi("CurrWard",WardID,RoomID,EpisodeID))
						Quit:EpisodeID=""
						Continue:$d(^PAADMi("PAADM_Type",EpisodeType,EpisodeID))=0 //没有找到对应的Paadm
						Set AdmData=$g(^PAADM(EpisodeID))
						Set loc=","_$p(AdmData,"^",4)_","	
						Continue:((CtlocIDList1'[loc)&&(CtlocIDList'="")) //科室不匹配		
						Set loc=$p(AdmData,"^",4)								
						Set ^CacheTemp("EpisodeList",repid,"DepWard",+loc,+WardID,EpisodeID)=""
						Set ^CacheTemp("EpisodeList",repid,"All",EpisodeID)=""										
					}
				}
			}
		}
		Quit repid
}

ClassMethod GetDrugSen(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set ret=""
	Quit:(aEpisodeID="") ret
	
	Set LabOEItemType=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("NINFInfLabOEItemType","")
	
	//update by zf 20160308 数据池相关程序修改(检验)
 	Set arrRec=##Class(DHCMed.DPCustom.Data.LabTestSet).GetDataByAdm(aEpisodeID,"","",LabOEItemType,"","")
	Set TSRepCount=arrRec.Count()
	For indTSRep=1:1:TSRepCount {
		Set objTSReport=arrRec.GetAt(indTSRep)
		Continue:'$IsObject(objTSReport)
		
		Set TSResCount=objRec.TestData.Count()
		For indTSRes=1:1:TSResCount {
			Set objTSResult=objRec.TestData.GetAt(indTSRes)
			Continue:'$IsObject(objTSResult)
			
			Set DataFormat=objTSResult.DataFormat
			Continue:DataFormat'="V"
			Set Result=objTSResult.DataText
			Continue:Result=""
			Set Antibiotics=objTSResult.Antibiotics
			
			For indS=1:1:$l(Antibiotics,$c(1)) {
				Set tSen=$p(Antibiotics,$c(1),indS)
				Continue:tSen=""
				Set AntiCode=$p(Antibiotics,$c(2),1)
				Set AntiDesc=$p(Antibiotics,$c(2),2)
				Set SenTestCode=$p(Antibiotics,$c(2),3)
				Set SenTestDesc=$p(Antibiotics,$c(2),4)
				Continue:(AntiDesc="")||(SenTestDesc="")
				Set SenTestID=##Class(DHCMed.NINFService.Srv.CommonCls).GetDicIDByDesc("NINFInfSenTestRst",SenTestDesc)
				
				Set tmp=Result_"^"_Result_"^"_AntiCode_"^"_AntiDesc_"^"_SenTestDesc
				Set:ret'="" ret=ret_$c(1)
				Set ret=ret_tmp
			}
		}
	}
	Quit ret
}

/// 查询常用抗生素、常见细菌的药敏情况
/// Do ##class(%Library.ResultSet).RunQuery("DHCMed.NINFService.Sta.CommonGermDrugSenSta","QryCommGermDrugSen","2008-01-01","2012-12-31",3)
Query QryCommGermDrugSen(FromDate As %String, ToDate As %String, DateType As %String, LocList As %String, WardList As %String) As %Query(ROWSPEC = "DepName:%String,WardName:%String,GermCode:%String,GermName:%String,DrugCode:%String,DrugName:%String,Result:%String") [ SqlProc ]
{
}

ClassMethod QryCommGermDrugSenExecute(ByRef qHandle As %Binary, FromDate As %String, ToDate As %String, DateType As %String, LocList As %String, WardList As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)	
	
	s:FromDate["-" FromDate=$zdh(FromDate,3)
	s:FromDate["/" FromDate=$zdh(FromDate,4)
	s:ToDate["-" ToDate=$zdh(ToDate,3)
	s:ToDate["/" ToDate=$zdh(ToDate,4)
	
	Set PaadmStoreID=##class(DHCMed.CCService.IntegratedControl.Common).GetEpisodeList(FromDate,ToDate,DateType,"I",LocList,WardList)
	Set DepID=""
	For {
		Set DepID=$o(^CacheTemp("EpisodeList",PaadmStoreID,"DepWard",DepID))	
		Quit:DepID=""
		Set objCtloc=##class(DHCMed.Base.Ctloc).GetObjById(DepID)
		Set:$IsObject(objCtloc)=0 objCtloc=##class(DHCMed.Base.Ctloc).%New()
		Do objCtloc.%Close()
		Set WardID=""
		For {
			Set WardID=$o(^CacheTemp("EpisodeList",PaadmStoreID,"DepWard",DepID,WardID))
			Quit:WardID=""
			Set objWard=##class(DHCMed.Base.PacWard).GetObjById(WardID)
			Set:$IsObject(objWard)=0 objWard=##class(DHCMed.Base.PacWard).%New()
			Do objWard.%Close()			
			Set EpisodeID=""
			For {
				Set EpisodeID=$o(^CacheTemp("EpisodeList",PaadmStoreID,"DepWard",DepID,WardID,EpisodeID))
				Quit:EpisodeID=""
				Set result=..GetDrugSen(EpisodeID)
				For i=1:1:$l(result,$c(1)) {
					Set Itm=$p(result,$c(1),i)
					Continue:Itm=""
					Set GermCode=$p(Itm,"^",1)
					Set Germ=$p(Itm,"^",2)
					Set DrugCode=$p(Itm,"^",3)
					Set Drug=$p(Itm,"^",4)
					Set SenResult=$p(Itm,"^",5)
						
					
					Set data=$lb("")
					Set $li(data,1)=objCtloc.Descs
					Set $li(data,2)=objWard.Descs
					Set $li(data,3)=GermCode
					Set $li(data,4)=Germ
					Set $li(data,5)=DrugCode
					Set $li(data,6)=Drug
					Set $li(data,7)=SenResult
					Set ^CacheTemp(repid,ind)=data
					Set ind=ind+1
				}
			}			
		}
	}		
	Kill ^CacheTemp("EpisodeList",PaadmStoreID)
	Quit $$$OK
}

ClassMethod QryCommGermDrugSenClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCommGermDrugSenExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryCommGermDrugSenFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCommGermDrugSenExecute ]
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

}
