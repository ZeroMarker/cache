/// 功能：综合监测的公共类库
/// 创建者：李阳
/// 创建日期：2012-07-20
Class DHCMed.CCService.IntegratedCtrl.Common Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// DateType:1-入院 2-出院 3-在院
/// w ##class(DHCMed.CCService.IntegratedCtrl.Common).GetEpisodeList("2011-1-1","2012-08-01",2,"I","2,8,9","")
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

/// 功能：获取某个EpisodeID的整个主题监控结果
/// 参数
/// EpisodeID:就诊ID PA_ADM表
/// SubjectCode：监控主题的代码，DHCMed.CC.Subject
/// 返回值：String
///   子类Code1^是否触发<C(1)>子类Code2^是否触发<C(1)>子类Code3^是否触发
/// 注意：触发为 1, 未触发为 0
/// 要求：主题必须是自动监控的，否则无法取出数据。
/// w ##class(DHCMed.CCService.IntegratedCtrl.Common).GetICResult("INFAW","5572278")
ClassMethod GetICResult(SubjectCode As %String, EpisodeID As %String, ConfigCode As %String = "") As %String
{
	New (SubjectCode, EpisodeID, ConfigCode)
	Set return=""
	Quit:((EpisodeID="")||((SubjectCode="")&&(ConfigCode=""))) return
	
	Set $ZT="GetICResultErr"
	
	Set SubjectID=""
	Set ConfigSubCatList=""
	If ConfigCode'="" {
		Set objConfig=##class(DHCMed.CC.SubjectConfig).GetObjByCode(ConfigCode)
		If $IsObject(objConfig) {
			Set ConfigID=objConfig.%Id()
			//^DHCMed.CC.MapSubjectSubCatI("IndexConfigCat",1,27,1)
			Set xSubCatID=0
			For {
				Set xSubCatID=$o(^DHCMed.CC.MapSubjectSubCatI("IndexConfigCat",ConfigID,xSubCatID))
				Quit:xSubCatID=""
				Set ConfigSubCatList=ConfigSubCatList_$lb(xSubCatID)
			}
		}
		Set SubjectID=##class(DHCMed.CCService.Sys.SubjectConfig).GetSubjectIDByConfigCode(ConfigCode)
	} ElseIf SubjectCode'="" {
		Set objSubject=##class(DHCMed.CC.Subject).GetObjByCode(SubjectCode)
		Quit:'$IsObject(objSubject) return
		Set SubjectID=objSubject.%Id()
	} Else {
		Quit return
	}
	
	New ArrInfAW
	Set ItemCatID=""
	For {
		Set ItemCatID=$o(^DHCMed.CCi("ItemCat",0,"SubjectIndex",SubjectID,ItemCatID))
		Quit:ItemCatID=""
		
		Set objCat=##class(DHCMed.CC.ItemCat).GetObjById(ItemCatID)
		Continue:'$IsObject(objCat)
		
		Set SubCode=""
		For {
			Set SubCode=$o(^DHCMed.CCi("ISubCat",0,"ISCCodeIndex",ItemCatID,SubCode))
			Quit:SubCode=""
			
			Set SubID=""
			For {
				Set SubID=$o(^DHCMed.CCi("ISubCat",0,"ISCCodeIndex",ItemCatID,SubCode,SubID))
				Quit:SubID=""
				
				Set objSub=##class(DHCMed.CC.ItemSubCat).GetObjById(SubID)
				Continue:'$IsObject(objSub)
				Continue:(ConfigSubCatList'="")&&($listfind(ConfigSubCatList,SubID)<1)
				
				Set ISCDesc=objSub.ISCDesc
				Set ISCKeyword=+objSub.ISCKeywordID
				Continue:ISCKeyword=0
				Set flg=$d(^DHCMed.CC.CtlResultI("Detail","IndexEpisodeKeyword",EpisodeID,SubjectID,ISCKeyword))
				If flg'=0 {
					Set ccFlag=1
				} Else {
					Set ccFlag=0
				}
				Set ArrInfAW(EpisodeID,ISCDesc)=ccFlag
			}
		}
	}
	
	Set ISCDesc=""
	For {
		Set ISCDesc=$o(ArrInfAW(EpisodeID,ISCDesc))
		Quit:ISCDesc=""
		Set return=return_$c(1)_ISCDesc_"^"_$g(ArrInfAW(EpisodeID,ISCDesc))
		Kill ArrInfAW(EpisodeID,ISCDesc)
	}
	Set:return'="" return=$e(return,2,$l(return))
	Quit return
	
GetICResultErr
	Quit ""
}

}
