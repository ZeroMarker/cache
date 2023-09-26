/// 功能：综合监测的公共类库
/// 创建者：李阳
/// 创建日期：2012-07-20
Class DHCMed.CCService.IntegratedControl.Common Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
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
		if ((DateType=1)!(DateType=2)) 
		{
			//住院日期的索引是  ^PAADMi("PAADM_AdmDate",{PAADM_AdmDate},{PAADM_RowID})
			//出院日期的索引是：^PAADMi("DischDate",{PAADM_DischgDate},{PAADM_RowID}) 或 ^PAADMi("EstDisch",{PAADM_EstimDischargeDate},{PAADM_RowID}) 
			Set:DateType=1 IndexNode="PAADM_AdmDate"
			Set:DateType=2 IndexNode="DischDate"
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

}
