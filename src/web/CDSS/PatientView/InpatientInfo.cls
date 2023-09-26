/// 名称: 病历信息
/// 描述: 获取病历信息的信息
/// 编写者：丁亚男-基础数据平台
/// 编写日期: 2020-05-08
Class web.CDSS.PatientView.InpatientInfo Extends %RegisteredObject
{

/// Creator:dingyanan
/// CreatDate:2020-05-08
/// Description：获取患者住院病历信息表
/// Table：WDT.CDSS.InpatientInfo
/// Input：IDNO 患者主索引 VisitID 就诊次数编号 VisitType就诊类型
/// Output：返回特定格式住院病历信息的json串患者
/// w ##class(web.CDSS.PatientView.InpatientInfo).GetBookInpatientInfo("DH001","te001","1","")
ClassMethod GetBookInpatientInfo(IDNO As %String, PatientDR As %String, VisitID As %String, VisitType As %String = "", Config As %String) As %String
{
	if (Config="") s Config=1	//是否启用流水号（急诊号、门诊号、住院号）为患者就诊唯一标识（0为是，1为否），默认为1
	s InpatientInfo="",Info=""
	s total=0
	if (Config=1)&(PatientDR'="")&(VisitID'="")&(VisitType'="") // 单个患者单次就诊 根据病人标识和就诊次数编号取数据
	{
		if ($d(^WDT.CDSS.InpatientInfoI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType)))
		{
			s InpatientID=0
			for
			{
				s InpatientID =$o(^WDT.CDSS.InpatientInfoI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType,InpatientID)) q:InpatientID=""
				s MRClass=$lg($g(^WDT.CDSS.InpatientInfoD(InpatientID)),7)
				s MRDesc=$lg($g(^WDT.CDSS.InpatientInfoD(InpatientID)),10)
				s MRDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(MRDesc)
				s Info="{""id"":"""_InpatientID_""",""MRClass"":"""_MRClass_""",""MRDesc"":"""_MRDesc_"""}"	
				
				if (InpatientInfo="")
				{
					s InpatientInfo=Info			
				}
				else
				{
					s InpatientInfo=InpatientInfo_","_Info
				}
				s total=total+1	
			}
		}
	}
	elseif (IDNO'="")  //患者主索引
	{
		s InpatientID=0
		for
		{
			s InpatientID =$o(^WDT.CDSS.InpatientInfoI("IDNOIndex"," "_$zcvt(IDNO,"U"),InpatientID)) q:InpatientID=""
			s MRClass=$lg($g(^WDT.CDSS.InpatientInfoD(InpatientID)),7)
			s MRDesc=$lg($g(^WDT.CDSS.InpatientInfoD(InpatientID)),10)
			s MRDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(MRDesc)
			s Info="{""id"":"""_InpatientID_""",""MRClass"":"""_MRClass_""",""MRDesc"":"""_MRDesc_"""}"	
			
			if (InpatientInfo="")
			{
				s InpatientInfo=Info			
			}
			else
			{
				s InpatientInfo=InpatientInfo_","_Info
			}
			s total=total+1	
		}
	}
	if (InpatientInfo="") //疾病id为空
	{
		s result="{""rows"":[], ""total"":0}"
		
	}
	else
	{
		s result="{""rows"":["_InpatientInfo_"], ""total"":"_total_"}"
	}
	q result
}

}
