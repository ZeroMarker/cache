Class EMRservice.InterfaceService.admCapriniRecord Extends %RegisteredObject
{

// creator：duan

// input: AEpisodeID 

// output:Y^Y^Y 是否写了量表^量表评分是否在入院24小时书写^量表评分是否大于4

// 维护程序配置CarpriniConfig 391^HDSD00.21.1001 docID^术语集合计评分code

// w ##class(EMRservice.InterfaceService.admCapriniRecord).GetCapriniRecord("30144937")

ClassMethod GetCapriniRecord(AEpisodeID As %String)
{
	s result=""
	q:AEpisodeID="" result
	s CarpriniConfig = ##class(EMRservice.BL.BLSysOption).GetOptionValueByName("CarpriniConfig")
	s docID=$P(CarpriniConfig,"^",1)
	s AGlossaryCode=$P(CarpriniConfig,"^",2)
	s isHave="N"
	s isHour="N"
	s isGrade="N"
	s result = isHave_"^"_isHour_"^"_isGrade
	//患者入院时间
	s admDate = ##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(AEpisodeID, "")
	s ecrecordId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID,docID,""))
	q:(ecrecordId = "") result
	s subId=""
	for{
			s subId = $o(^DHCEMRI.InstanceDataI("IdxECRecord",ecrecordId,subId))
			q:subId=""
			s instanceId =  ecrecordId_"||"_subId
			s obj = ##Class(EMRinstance.InstanceData).%OpenId(instanceId)
			continue:obj.Status'="Save"
			s isHave="Y"
			s createDate = obj.CreateDate
			s createtime = obj.CreateTime
			//取术语值数据
			s value = ##Class(EMRservice.BL.BLScatterData).GetDataByGlossary(AEpisodeID,AGlossaryCode,instanceId)
			s:(value>=5) isGrade="Y"
			s createDateTime = createDate_","_createtime
			s:'(createDateTime-admDate) isHour="Y"
			q
		}
	s result=isHave_"^"_isHour_"^"_isGrade
	q result
}

}
