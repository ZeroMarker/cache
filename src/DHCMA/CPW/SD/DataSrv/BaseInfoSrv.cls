Class DHCMA.CPW.SD.DataSrv.BaseInfoSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// s a=##class(DHCMA.CPW.SD.DataSrv.BaseInfoSrv).GetDataByAdm(87,"1||270")
ClassMethod GetDataByAdm(aEpisodeID As %String, aItemID As %String = "") As DHCMA.CPW.SD.Data.FeeInfo
{
	New (aEpisodeID,aItemID)
	Set return=""
	Set $zt="GetDataByAdmErr"
	set ^tmpzgz991=aEpisodeID_","_aItemID
	Set BaseID=$o(^DHCMA.CPW.SD.Data.BaseInfoI("IdxAdm",aEpisodeID,""),-1)
	If (BaseID="") {
		d ..SynBaseByAdm(aEpisodeID)	
		Set BaseID=$o(^DHCMA.CPW.SD.Data.BaseInfoI("IdxAdm",aEpisodeID,""),-1)
	}
	Quit:BaseID="" return
	Set xobj=""
	Set xobj=##class(DHCMA.CPW.SD.Data.BaseInfo).GetObjById(BaseID)
	Set Birthday=xobj.Birthday
	Set xobj.Birthday=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(xobj.Birthday)
	If (aItemID'=""){
		Set objItem=##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(aItemID)
		Quit:'$IsObject(objItem) xobj
		Set aItemDesc=objItem.BTDesc
		Set DicID=##class(DHCMA.CPW.SDS.QCItemDataConfigSrv).GetStandDicID(aItemDesc)
		Quit:DicID="" xobj
		Set TabelInfo=##class(DHCMA.CPW.SD.Stand.TableInfo).GetTableStrByDic(DicID)
		Quit:TabelInfo="" xobj
		Quit:TabelInfo'["Base" xobj
		Set Field=$p(TabelInfo,"^",2)
		Set $property(xobj,Field)="*"_$property(xobj,Field)
	}
	d xobj.%Close()
	Set return=xobj
	Quit return
GetDataByAdmErr
	Quit return
}

/// d ##class(DHCMA.CPW.SD.DataSrv.BaseInfoSrv).SynBaseByAdm(87)
ClassMethod SynBaseByAdm(aEpisodeID) As %String
{
	New (aEpisodeID)
	Set return=""
	Set AdmStr=$g(^PAADM(aEpisodeID))
	Quit:AdmStr="" return
	Set PatientID=$p(AdmStr,"^",1)      // 病人ID
	Quit:PatientID="" return
	
	//病人基本信息
	Set PapmiNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)               // 登记号
	Set PatName=$p($g(^PAPER(PatientID,"ALL")),"^",1)                 // 病人姓名
	Set Sex=$p($g(^CT("SEX",$p($g(^PAPER(PatientID,"ALL")),"^",7))),"^",2)
	Set Sex=$s(Sex="男":"M",Sex="女":"F",1:"O")                       // 性别（M男、F女、O其他）
	Set Nation=$p($g(^PAPER(PatientID,"PER",2)),"^",1)
	Set:Nation'="" Nation=$p($g(^CT("NAT",Nation)),"^",2)             // 民族
	Set Birthday=$p($g(^PAPER(PatientID,"ALL")),"^",6)                // 出生日期
	Set IdentityCode=$p($g(^PAPER(PatientID,"ALL")),"^",9)            // 身份证号码
	
	Set HomeAddress=$g(^PAPER(PatientID,"PER","ADD",1))               // 现住址
	Set Company=$p($g(^PAPER(PatientID,"PER",4)),"^",18)              // 工作单位
	Set RelativeName=$p($g(^PAPER(PatientID,"PER",2)),"^",13)         // 联系人
	Set RelativeTel=$p($g(^PAPER(PatientID,"ALL")),"^",4)             // 联系人电话
	Set DeathDate=$p($g(^PAPER(PatientID,"ALL")),"^",13)              // 死亡日期
	Set DeathTime=$p($g(^PAPER(PatientID,"ALL")),"^",8)               // 死亡时间
	Set IsDeath=$s(DeathDate'="":1,1:0)                               // 死亡标志
	
	//患者就诊信息
	Set AdmType=$p(AdmStr,"^",2)	    // 就诊类型（门诊O、急诊E、住院I）
	Set VisitStatus=$p(AdmStr,"^",20)   // 就诊状态（预住院P、在院A、出院D、退院C、作废U）
	Set AdmNo=$p(AdmStr,"^",81)         // 住院号
	Set AdmTimes=$p(AdmStr,"^",29)      // 就诊次数
	Set MotherDr=$p(AdmStr,"^",75)		// 母亲就诊指针
	
	//就诊日期、时间、科室、病区、床位、医生
	Set AdmDateTime=##Class(DHCMA.Util.IO.FromHisSrv).GetAdmDateTime(aEpisodeID)
	Set AdmDate=$p(AdmDateTime,"^",1)
	Set AdmTime=$p(AdmDateTime,"^",2)
	Set FormatAdmDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
	Set FormatAdmTime=$zt(AdmTime,1)
	Set AdmDateT=FormatAdmDate_" "_FormatAdmTime
	Set AdmLocID=$p(AdmStr,"^",4)
	Set AdmLocDesc=$p($g(^CTLOC(+AdmLocID)),"^",2)
	Set:AdmLocDesc["-" AdmLocDesc=$p(AdmLocDesc,"-",2)
	Set AdmWardID=$p(AdmStr,"^",70)
	Set AdmWardID=$p($g(^PAWARD(+AdmWardID)),"^",5)  //病区科室转换一下
	Set AdmWardDesc=$p($g(^CTLOC(+AdmWardID)),"^",2)
	Set:AdmWardDesc["-" AdmWardDesc=$p(AdmWardDesc,"-",2)
	Set AdmRoom=$p(AdmStr,"^",69)
	Set:AdmRoom'="" AdmRoom=$p($g(^PAROOM(AdmRoom)),"^",2)
	Set AdmBed=$p(AdmStr,"^",73)
	Set:AdmBed'="" AdmBed=$p($g(^PAWARD(+AdmBed,"BED",$p(AdmBed,"||",2))),"^",1)
	Set AdmDocID=$p(AdmStr,"^",9)
	Set AdmDocName=$p($g(^CTPCP(+AdmDocID,1)),"^",2)
	//出院日期、出院时间
	Set DischDateTime=##Class(DHCMA.Util.IO.FromHisSrv).GetDischDateTime(aEpisodeID)
	Set DischDate=$p(DischDateTime,"^",1)
	Set DischTime=$p(DischDateTime,"^",2)
	Set DischDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(DischDate)
	Set DischTime=$zt(DischTime,1)
	Set DischDateT=""
	Set:DischDate'="" DischDateT=DischDate_" "_DischTime
	
	//病案号
	Set MrNo=##Class(DHCMA.Util.IO.FromHisSrv).GetMrNoByAdm(aEpisodeID)
	//年龄计算
	Set Age=##class(DHCMA.Util.IO.FromHisSrv).GetPapmiAge(PatientID,aEpisodeID,AdmDate,AdmTime)
	Set:(Age["月")||(Age["天") Age=0
	Set Age=+Age
	Set (CheckDoc,CheckNur,ClinicDoc,ClinicNur,ReAdm31,OcurDateT,OEDateT,InCCUDateT,OutCCUDateT,
		 InICUDateT,OutICUDateT,PayType,InHosWay,InHosTrans,OutHosWay)=""
	///取住院病案首页数据
	Set EMRCode=##class(DHCMA.Util.BT.Config).GetValueByCode("SDEMRCode")
	If (EMRCode'="") {
		Set Glossary=##Class(EPRservice.BOScatterData).GetDataByGlossaryCategory(aEpisodeID,$e(EMRCode,1,9))
		/// 质控医师 CheckDoc
		Set CheckDoc=Glossary.GetAt($p(EMRCode,"`",1))
		/// 质控护士 CheckNur
		Set CheckNur=Glossary.GetAt($p(EMRCode,"`",2))
		/// 主治医师 ClinicDoc
		Set ClinicDoc=Glossary.GetAt($p(EMRCode,"`",3))
		/// 责任护士 ClinicNur
		Set ClinicNur=Glossary.GetAt($p(EMRCode,"`",4))
		/// 是否出院后31天内重复住院 ReAdm31
		Set ReAdm31=Glossary.GetAt($p(EMRCode,"`",5))
		/// 费用支付方式 PayType
		Set PayType=Glossary.GetAt($p(EMRCode,"`",6))
		/// 收入住院途径 InHosWay
		Set InHosWay=Glossary.GetAt($p(EMRCode,"`",7))
		/// 离院方式 OutHosWay
		Set OutHosWay=Glossary.GetAt($p(EMRCode,"`",8))
	}

	/// 发病日期时间 OcurDateT
	Set OcurDateT=""
	/// 到达本院急诊或者门诊日期时间 OEDateT
	Set xPaadm="",OEDateT=""
	//获取上一次就诊的情况
	//此处默认ProcessDR=EpisodeID
	Set xPaadm=$o(^PAPRi("PAPMI",PatientID,aEpisodeID),-1)
	If (xPaadm'="") {
		Set AdmInfo=$g(^PAADM(xPaadm))
		If ("OE"]$p(AdmInfo,"^",2))  {        //就诊类型过滤(只需要门诊和急诊的)
			Set xAdmDateTime=##Class(DHCMA.Util.IO.FromHisSrv).GetAdmDateTime(xPaadm)
			Set xAdmDate=$p(xAdmDateTime,"^",1)
			Set xAdmTime=$p(xAdmDateTime,"^",2)
			//默认24小时内的门急诊为该次住院的关联就诊
			Set xHours=(AdmDate-xAdmDate)*24+(AdmTime-xAdmTime)\3600
			If (xHours<24) {
				Set xFormatAdmDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(xAdmDate)
				Set xFormatAdmTime=$zt(xAdmTime,1)
				Set OEDateT=xFormatAdmDate_" "_xFormatAdmTime
			}
		}
	}
	/// 到院交通工具 InHosTrans
	//到院交通工具默认私家车
	Set InHosTrans="私家车"
	Set PID=$o(^ARCIM(0,"Desc","救护车费",0)) 
	Set ARCIMID=PID_"||1"
	Set OEOrderID=$o(^OEORD(0,"Adm",aEpisodeID,0))
	Set:$d(^OEORDi(0,"ARCIM",OEOrderID,ARCIMID)) InHosTrans="救护车"		
	/// 入住CCU日期时间 InCCUDateT
	/// 离开CCU日期时间 OutCCUDateT
	/// 入住卒中中心/ICU日期时间 InICUDateT
	/// 离开卒中中心/ICU日期时间 OutICUDateT
	Set xSub=0
	For {
		Set xSub=$o(^PAADM(aEpisodeID,"TRANS",xSub))
		Quit:xSub=""
		Set tmpTrans=$g(^PAADM(aEpisodeID,"TRANS",xSub))
		Set StartDate=$p(tmpTrans,"^",1)
		Set StartTime=$p(tmpTrans,"^",2)
		Set TransLoc=$p(tmpTrans,"^",6)  //科室
		Set TransWard=$p(tmpTrans,"^",9)  //病区
		Set TransBed=$p(tmpTrans,"^",8)  //床位
		Continue:(TransWard'="")||(TransBed'="") //只检索转科记录
		Set LocDesc=$p($g(^CTLOC(TransLoc)),"^",2)
		Set xSDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(StartDate)
		Set xSTime=$zt(StartTime,1)
		Set xDateT=xSDate_" "_xSTime
		If (LocDesc["CCU")&&(InCCUDateT="") {
			Set InCCUDateT=xDateT
		}elseIf ((LocDesc["ICU")||(LocDesc["卒中"))&&(InCCUDateT="") {
			Set InCCUDateT=xDateT
		}elseIf(InCCUDateT'="")&&(OutCCUDateT=""){
			Set OutCCUDateT=xDateT
		}elseIf(InICUDateT'="")&&(OutICUDateT=""){
			Set OutICUDateT=xDateT
		}
		
	}
	Set ID=$o(^DHCMA.CPW.SD.Data.BaseInfoI("IdxAdm",aEpisodeID,0))
	If ID="" {                                  
		Set obj=##class(DHCMA.CPW.SD.Data.BaseInfo).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.SD.Data.BaseInfo).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	Set obj.EpisodeID	 = aEpisodeID	
	Set obj.PatientID	 = PatientID	
	Set obj.AdmType		 = AdmType		
	Set obj.VisitStatus	 = VisitStatus	
	Set obj.MrNo		 = MrNo		
	Set obj.Sex		 	 = Sex		
	Set obj.Nation		 = Nation		
	Set obj.Birthday	 = Birthday	
	Set obj.Age		     = Age		
	Set obj.IDNo		 = IdentityCode		
	Set obj.IsDeath		 = IsDeath		
	Set obj.AdmDateT	 = AdmDateT	
	Set obj.AdmLocID	 = AdmLocID	
	Set obj.AdmLocDesc	 = AdmLocDesc	
	Set obj.AdmDocName	 = AdmDocName	
	Set obj.DischDateT	 = DischDateT
	Set:CheckDoc="" CheckDoc=AdmDocName	
	Set obj.CheckDoc	 = CheckDoc	
	Set obj.CheckNur	 = CheckNur	
	Set obj.ClinicDoc	 = ClinicDoc	
	Set obj.ClinicNur	 = ClinicNur	
	Set obj.ReAdm31		 = ReAdm31		
	Set obj.OcurDateT	 = OcurDateT	
	Set obj.OEDateT		 = OEDateT		
	Set obj.InCCUDateT	 = InCCUDateT	
	Set obj.OutCCUDateT	 = OutCCUDateT	
	Set obj.InICUDateT	 = InICUDateT	
	Set obj.OutICUDateT	 = OutICUDateT	
	Set obj.PayType		 = PayType		
	Set obj.InHosWay	 = InHosWay	
	Set obj.InHosTrans	 = InHosTrans	
	Set obj.OutHosWay	 = OutHosWay
	Set obj.PatName	     = PatName
	//检查Save是否成功
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
}

/// s a=##class(DHCMA.CPW.SD.DataSrv.BaseInfoSrv).GetTitleByAdm(451)
ClassMethod GetTitleByAdm(aEpisodeID As %String) As DHCMA.CPW.SD.Data.FeeInfo
{
	New (aEpisodeID)
	Set return=""
	Set BaseID=$o(^DHCMA.CPW.SD.Data.BaseInfoI("IdxAdm",aEpisodeID,""),-1)
	If (BaseID="") {
		d ..SynBaseByAdm(aEpisodeID)	
		Set BaseID=$o(^DHCMA.CPW.SD.Data.BaseInfoI("IdxAdm",aEpisodeID,""),-1)
	}
	Quit:BaseID="" return
	Set return=##class(DHCMA.CPW.SD.Data.BaseInfo).GetObjById(BaseID)
	//&nbsp;&nbsp;张三&nbsp;&nbsp;32岁|男&nbsp;&nbsp;病案号:000001 &nbsp;&nbsp; 呼吸内科 &nbsp;&nbsp;2021-07-01 
	Set PatName=return.PatName
	Set Age=return.Age
	Set Sex=$s(return.Sex="M":"男",1:"女")
	Set MrNo=return.MrNo
	Set AdmLocDesc=return.AdmLocDesc
	Set AdmDateT=return.AdmDateT
	Set DischDateT=return.DischDateT
	Set return="&nbsp;&nbsp;"_PatName_"&nbsp;&nbsp;"_Age_"|"_Sex_"&nbsp;&nbsp;"_"病案号:"_MrNo_"&nbsp;&nbsp;"_AdmLocDesc_"&nbsp;&nbsp;入院时间："_AdmDateT
	Quit return
}

}
