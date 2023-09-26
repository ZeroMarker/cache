/// 科主任-今日工作量
Class DtPortal.DD.DD19TodayWork Extends %RegisteredObject
{

/// 名称: 
/// 描述: 今日手术完成率统计
/// 编写者：bmz
/// 编写日期:2020-11-16
/// 服务序号:DD19.01.01
/// w ##class(DtPortal.DD.DD19TodayWork).DD190101("95^98^93")
ClassMethod DD190101(LocGroupId As %String = "") As DtPortal.OutPut
{
	#Dim return As DtPortal.OutPut
	s locIDStr=##class(DtPortal.DD.DD00PublicService).getDDloc(LocGroupId,"")
	try{
		Set return = ##class(DtPortal.OutPut).%New()
		s StartDate=+$h,EndDate=+$h
		s DayOperAllNum=0,DayOperFinishNum=0,zeQiAllNum=0,zeQiFinishNum=0,operAllNum=0,operFinishNum=0
		for date=StartDate:1:EndDate{
			set opaId=""
			for  {
				s opaId=$O(^DHCANOPArrange(0,"SDate",date,opaId))
				q:opaId=""
				s EpisodeID=$P(^DHCANOPArrange(opaId),"^",1) 
				continue:EpisodeID=""
				s anaId=$P(^DHCANOPArrange(opaId),"^",2) ;手术麻醉Id
    			s anaSub=$P(anaId,"||",2)
    			
    			s operLocId=$P(^OR(EpisodeID,"ANA",anaSub,"OP",1),"^",10)
    			continue:operLocId=""
    			
    			s patLocID=$p($g(^PAADM(EpisodeID)),"^",4)
    			
    			//w !,$p(^CTLOC(patLocID),"^",2)_"&&&"_patLocID_"&&&"_locIDStr
    			
    			continue:("^"_locIDStr_"^")'[("^"_patLocID_"^")
    			
    			s hospIDCurr=$p($g(^CTLOC(operLocId)),"^",22)  
				s OPAStatus=$P(^DHCANOPArrange(opaId),"^",27)
				continue:OPAStatus=""
				continue:("DC"[OPAStatus)
				
				s operAllNum=operAllNum+1
				if (("PLF"[OPAStatus)){
					s operFinishNum=operFinishNum+1
				}
				
				
				s DayOperFlag=$P($g(^OR(EpisodeID,"ANA",anaSub,"OP",1)),"^",22)
				if (DayOperFlag="Y"){
					s DayOperAllNum=DayOperAllNum+1
					if (("PLF"[OPAStatus)){
						s DayOperFinishNum=DayOperFinishNum+1
					}
				}
				
				s anaSourceType=$P(^OR(EpisodeID,"ANA",anaSub),"^",32)   						;ANA_SourceType 急诊(E)/择期(B)
				i anaSourceType="E" s anaSourceTypeDesc="急诊"
				e  s anaSourceTypeDesc="择期"
		    	if (anaSourceTypeDesc="择期"){
					s zeQiAllNum=zeQiAllNum+1
					if (("PLF"[OPAStatus)){
						s zeQiFinishNum=zeQiFinishNum+1
					}
				}
			}
		}
		
		s consAllNum=0,consFinishNum=0
		//获取被邀会诊数据
		
		s ConStatusCodeFinish=##Class(DtPortal.Common.PublicService).getValueByCode("CONSULTFINISHSTATE")
		s ConStatusCodeNotFinish=##Class(DtPortal.Common.PublicService).getValueByCode("CONSULTNOTFINISHSTATE")
		set obj=##class(%ResultSet).%New("web.DHCEMConsInterface:QryDocCstList")
		d obj.Execute("","",StartDate,EndDate,"","C")
		f  Quit:'obj.Next()  d               
		.s ConsultId=obj.Data("CsItmID")
		.s CsLocID=obj.Data("CsLocID")    //会诊科室
		.q:(CsLocID="")
		.q:'$LF($LISTFROMSTRING(locIDStr,"^"),CsLocID)
		.s CsStatCode=obj.Data("CsStatCode")  
		.//从配置的完成、未完成中过滤
		.q:('$LF($LISTFROMSTRING(ConStatusCodeFinish,"^"),CsStatCode))&&('$LF($LISTFROMSTRING(ConStatusCodeNotFinish,"^"),CsStatCode))
		.i $LF($LISTFROMSTRING(ConStatusCodeFinish,"^"),CsStatCode) s consFinishNum=consFinishNum+1
		.s consAllNum=consAllNum+1
	
		

		
		
		
		set jsonObj =##class(DtPortal.Common.JsonObject).%New()
		d jsonObj.Put("operAllNum",operAllNum)
		d jsonObj.Put("operFinishNum",operFinishNum)
		d jsonObj.Put("consAllNum",consAllNum)
		d jsonObj.Put("consFinishNum",consFinishNum)
		
		s oPRate=0,consultationRate=0


		if (+operAllNum'=0){
			s oPRate=$fn(operFinishNum*100/operAllNum,"",2)
		}
		d jsonObj.Put("oPRate",oPRate)
		
		if (+consAllNum'=0){
			s consultationRate=$fn(consFinishNum*100/consAllNum,"",2)
		}
		
		d jsonObj.Put("consultationRate",consultationRate)
		
		
		Set return.status = 1
		Set return.errMSG = ""
		Set return.data = "["_jsonObj.Json()_"]"
		
	}catch exp{
		Set return.status = -1
		Set return.errMSG = $ze
		Set return.data = ""
	}
	Quit return
}

}
