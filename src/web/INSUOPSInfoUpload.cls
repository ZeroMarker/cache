Class web.INSUOPSInfoUpload Extends (%RegisteredObject, %XML.Adaptor)
{

//根据账单事情取医嘱信息集合[内部函数]

//w ##class(web.INSUOPSInfoUpload).GetOPSINFO(9)

ClassMethod GetOPSINFO(Adm As %String = "") As %ListOfDataTypes
{
		
	
	s sub=$i(^||GetOPSINFO)
	s rtnList=##class(%ListOfDataTypes).%New()
	q:Adm="" rtnList
		 
	//说明：此处调用接口方法，将返回的结果集返回给ret
	//参数，使用的是就诊号，同时若是需要，可以根据时间查询，具体的参数配置，请参照方法体的说明
	s ret=##class(web.DHCANAdaptor).GetANOperation("","",Adm,"","")
	Set reader = ##class(%XML.Reader).%New()
	
	//解析ret
	Do reader.OpenStream(ret)
	
	Do reader.Correlate("PatInfo","web.DHCANInterface")
	
	
	//遍历数据，返回实际的结果，并拼接成字符串返回。
	While (reader.Next(.object,.sc)) {
    
    s OpaId=object.OpaId
    i $d(^||GetOPSINFO(sub,OpaId))=0 d
    .s opsobj=##class(web.INSUOPSInfo).%New()
	
	.s opsobj.JzStat=object.JzStat			;急诊(E)/择期(B)
	.s opsobj.RegNo=object.RegNo			;登记号
	.s opsobj.EpisodeID=object.EpisodeID			;就诊号
	.s opsobj.OPAAdmDr=object.OPAAdmDr			;就诊号
	.s opsobj.MedCareNo=object.MedCareNo			;病案号
	.s opsobj.PatName=object.PatName			;病人姓名
	.s opsobj.Birthday=object.Birthday			;病人出生日期
	.s opsobj.Age=object.Age			;病人年龄
	.s opsobj.Sex=object.Sex			;病人性别
	.s opsobj.PaAdmType=object.PaAdmType			;就诊类型
	.s opsobj.Ward=object.Ward			;病人病区
	.s opsobj.Bed=object.Bed			;病人床位
	.s opsobj.BedRoom=object.BedRoom			;病人所在房间
	.s opsobj.OPAPatDeptDr=object.OPAPatDeptDr			;病人所在科室Id
	.s opsobj.PatLoc=object.PatLoc			;病人所在科室描述
	.s opsobj.OPAPATestHBsAg=object.OPAPATestHBsAg			;乙肝
	.s opsobj.OPAPATestHCVAb=object.OPAPATestHCVAb			;丙肝
	.s opsobj.OPAPATestHivAb=object.OPAPATestHivAb			;HIV
	.s opsobj.OPAPATestTPAb=object.OPAPATestTPAb			;梅毒
	.s opsobj.OPAPATestOther=object.OPAPATestOther			;其它
	.s opsobj.OPALabResult=object.OPALabResult			;特殊感染
	.s opsobj.OpaId=object.OpaId			;手术排班表Id
	.s opsobj.AnaesthesiaID=object.AnaesthesiaID			;麻醉表Id
	.s opsobj.OPAStatus=object.OPAStatus			;手术状态
	.s opsobj.StatCode=object.StatCode			;状态代码
	.s opsobj.OPAAppLocDr=object.OPAAppLocDr			;手术申请医生
	.s opsobj.OPAAppDate=object.OPAAppDate			;手术申请日期
	.s opsobj.OPAArrangeUser=object.OPAArrangeUser			;手术安排用户
	.s opsobj.OPAArrangeDate=object.OPAArrangeDate			;手术安排日期
	.s opsobj.OPAArrangeTime=object.OPAArrangeTime			;手术安排时间
	.s opsobj.OPAStartDateTime=object.OPAStartDateTime			;手术开始日期时间（术前时为计划值）
	.s opsobj.OPAEndDateTime=object.OPAEndDateTime			;手术结束日期时间
	.s opsobj.PlanOPAStartDateTime=object.PlanOPAStartDateTime			;计划手术开始日期时间
	.s opsobj.PlanOPAEndDateTime=object.PlanOPAEndDateTime			;计划手术结束日期时间
	.s opsobj.OpDate=object.OpDate			;手术日期
	.s opsobj.OpTime=object.OpTime			;手术时间
	.s opsobj.InRoomTime=object.InRoomTime			;入室时间
	.s opsobj.LeaveRoomTime=object.LeaveRoomTime			;离室时间
	.s opsobj.ANAStartDate=object.ANAStartDate			;麻醉开始日期
	.s opsobj.ANAStartTime=object.ANAStartTime			;麻醉开始时间
	.s opsobj.ANAEndDate=object.ANAEndDate			;麻醉结束日期
	.s opsobj.ANAEndTime=object.ANAEndTime			;麻醉结束时间
	.s opsobj.SurgeonStartDate=object.SurgeonStartDate			;手术医生开始手术日期
	.s opsobj.SurgeonStartTime=object.SurgeonStartTime			;手术医生开始手术时间
	.s opsobj.SurgeonEndDate=object.SurgeonEndDate			;手术医生结束日期
	.s opsobj.SurgeonEndTime=object.SurgeonEndTime			;手术医生结束时间
	.s opsobj.OPAFinishTime=object.OPAFinishTime			;手术结束
	.s opsobj.OPAPACUInTime=object.OPAPACUInTime			;入恢复室时间
	.s opsobj.OPAPACUOutTime=object.OPAPACUOutTime			;离开恢复室时间
	.s opsobj.ANASourceTypeDesc=object.ANASourceTypeDesc			;手术类型（择期，急诊）
	.s opsobj.OperId=object.OperId			;手术码表Id
	.s opsobj.AnaMethod=object.AnaMethod			;麻醉方法
	.s opsobj.ASA=object.ASA			;ASA分级
	.s opsobj.OpName=object.OpName			;手术名称
	.s opsobj.ANAOPBladeTypeId=object.ANAOPBladeTypeId			;切口类型Id
	.s opsobj.ANAOPBladeType=object.ANAOPBladeType			;切口类型
	.s opsobj.BodsDesc=object.BodsDesc			;手术部位
	.s opsobj.OperPosition=object.OperPosition			;手术体位
	.s opsobj.ANAOPPreopDiagDR=object.ANAOPPreopDiagDR			;术前诊断ID
	.s opsobj.ANAOPPreopDiag=object.ANAOPPreopDiag			;术前诊断
	.s opsobj.Prediag=object.Prediag			;Prediag
	.s opsobj.OPAOperLocDr=object.OPAOperLocDr			;手术科室Id
	.s opsobj.OPAOpRoomDr=object.OPAOpRoomDr			;手术间Id
	.s opsobj.OPAOpRoom=object.OPAOpRoom			;手术间
	.s opsobj.OPASeq=object.OPASeq			;手术台次
	.s opsobj.ANAOPSurgeonDR=object.ANAOPSurgeonDR			;手术医师Id
	.s opsobj.OpDocCtcpId=object.OpDocCtcpId			;OpDocCtcpId
	.s opsobj.ANAOPSurgeon=object.ANAOPSurgeon			;手术医师
	.s opsobj.OpDoctor=object.OpDoctor			;备注信息
	.s opsobj.AssistantFirstCtcpId=object.AssistantFirstCtcpId			;一助Id
	.s opsobj.AssistantFirstCtcp=object.AssistantFirstCtcp			;一助
	.s opsobj.AssistantFirstCtcpCode=object.AssistantFirstCtcpCode			;一助Code
	.s opsobj.AssistantSecondCtcpId=object.AssistantSecondCtcpId			;二助Id
	.s opsobj.AssistantSecondCtcp=object.AssistantSecondCtcp			;二助
	.s opsobj.AssistantSecondCtcpCode=object.AssistantSecondCtcpCode			;二助Code
	.s opsobj.AssistantThirdCtcpId=object.AssistantThirdCtcpId			;三助Id
	.s opsobj.AssistantThirdCtcp=object.AssistantThirdCtcp			;三助
	.s opsobj.AssistantThirdCtcpCode=object.AssistantThirdCtcpCode			;三助Code
	.s opsobj.AssOtherCtcpStrId=object.AssOtherCtcpStrId			;其他助手Id
	.s opsobj.AssOtherCtcpStr=object.AssOtherCtcpStr			;其他助手
	.s opsobj.AnaDocCtcpId=object.AnaDocCtcpId			;麻醉医生Id
	.s opsobj.AnaDoctor=object.AnaDoctor			;麻醉医生
	.s opsobj.AnaDoctorCode=object.AnaDoctorCode			;麻醉医生Code
	.s opsobj.ScrubNurFirstCtcpId=object.ScrubNurFirstCtcpId			;器械护士一Id
	.s opsobj.OPSCNScrubNurseDR=object.OPSCNScrubNurseDR			;OPSCNScrubNurseDR
	.s opsobj.ScrubNurFirstCtcp=object.ScrubNurFirstCtcp			;器械护士一
	.s opsobj.ScrubNurSecondCtcpId=object.ScrubNurSecondCtcpId			;器械护士二Id
	.s opsobj.ScrubNurSecondCtcp=object.ScrubNurSecondCtcp			;器械护士二
	.s opsobj.ScrubNurThirdCtcpId=object.ScrubNurThirdCtcpId			;器械护士三Id
	.s opsobj.ScrubNurThirdCtcp=object.ScrubNurThirdCtcp			;器械护士三
	.s opsobj.CirculNurFirstCtcpId=object.CirculNurFirstCtcpId			;巡回护士一Id
	.s opsobj.ANAOPCirculNurseDR=object.ANAOPCirculNurseDR			;ANAOPCirculNurseDR
	.s opsobj.CirculNurFirstCtcp=object.CirculNurFirstCtcp			;巡回护士一
	.s opsobj.CirculNurSecondCtcpId=object.CirculNurSecondCtcpId			;巡回护士二Id
	.s opsobj.CirculNurSecondCtcp=object.CirculNurSecondCtcp			;巡回护士二
	.s opsobj.CirculNurThirdCtcpId=object.CirculNurThirdCtcpId			;巡回护士三Id
	.s opsobj.CirculNurThirdCtcp=object.CirculNurThirdCtcp			;巡回护士三
	.s opsobj.OPAStartDate=object.OPAStartDate			;OPAStartDate
	.s opsobj.opLevelId=object.opLevelId			;手术分类Id
	.s opsobj.opLevelDesc=object.opLevelDesc			;手术分类描述
	.s opsobj.bloodType=object.bloodType			;血型
	.s opsobj.OPAUseSelfBlood=object.OPAUseSelfBlood			;自体血回输
	.s opsobj.OPAExCirculation=object.OPAExCirculation			;体外循环
	.s opsobj.returnOpe=object.returnOpe			;重返手术
	.s opsobj.RejectReason=object.RejectReason			;拒绝原因
	.s opsobj.NorInstrument=object.NorInstrument			;常规器械
	.s opsobj.SpeInstrument=object.SpeInstrument			;特殊器械
	.s opsobj.Analgesia=object.Analgesia			;术后镇痛
	.s opsobj.StewardScore=object.StewardScore			;Steward评分
	.s opsobj.PRKillip=object.PRKillip			;心功能分级
	.s opsobj.ANAOPSurgeonCode=object.ANAOPSurgeonCode			;手术医师Code
	
	.s opsobj.SSMXLSH=""			;手术明细流水号
	.s opsobj.RJSSBZ=""			;日间手术标志
	.s opsobj.SSHZD=""			;手术后诊断
	.s opsobj.SSXH=""			;手术序号
	.s opsobj.ZDYS=""			;指导医师编码
	.s opsobj.YYXSU=""			;医源性手术
	.s opsobj.SSLY=""			;手术来源
	.s opsobj.MZFY=""			;麻醉反应
	.s opsobj.SSBFZ=""			;手术并发症
	.s opsobj.SSZH=""			;手术组号
	.s opsobj.ZCBZ=""			;主次标志。
	.s opsobj.SSGC=""			;手术过程
	
    e  d
    .s opsobj=rtnList.GetAt(^||GetOPSINFO(sub,OpaId))
	
	i $d(^||GetOPSINFO(sub,OpaId))=0 d
	.d rtnList.Insert(opsobj)
	.s ^||GetOPSINFO(sub,OpaId)=1
	e  d
	.d rtnList.InsertAt(opsobj,^||GetOPSINFO(sub,OpaId))
	.s ^||GetOPSINFO(sub,OpaId)=+^||GetOPSINFO(sub,OpaId)+1
	
	}
	
	If $system.Status.IsError(sc) do $system.OBJ.DisplayError(sc)
	;w $system.OBJ.Dump(rtnList.GetAt(1))
	q rtnList
}

}
