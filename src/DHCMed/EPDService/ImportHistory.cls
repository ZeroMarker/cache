Class DHCMed.EPDService.ImportHistory Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

/// Kill ^TMP("DHCMed.EPDService.ImportHistory")
/// 	Kill ^DHCMed.EPD
/// 	Kill ^DHCMed.EPDi
/// w ##Class(DHCMed.EPDService.ImportHistory).ToNewReport(0)
ClassMethod ToNewReport(argFormat As %String) As %String
{
	New (argFormat)
	Set $ZT="ToNewReportErr"
	
	k ^DHCMed.EPDCHistory
	s ^DHCMed.EPDCHistory("NullDic","保育员") = "保育员及保姆" 
	s ^DHCMed.EPDCHistory("NullDic","公务人员及职员") = "干部职员" 
	s ^DHCMed.EPDCHistory("NullDic","其他") = "其他（     ）" 
	s ^DHCMed.EPDCHistory("NullDic","商务人员") = "商业服务" 
	s ^DHCMed.EPDCHistory("NullDic","学生") = "学生（大中小学）" 
	s ^DHCMed.EPDCHistory("NullDic","家政、家务及待业") = "家务及待业" 
	s ^DHCMed.EPDCHistory("NullDic","离退休人员") = "离退人员" 
	s ^DHCMed.EPDCHistory("NullDic","餐饮食品人员") = "餐饮食品业" 
	s ^DHCMed.EPDCHistory("NullDic","医学观察病例") = "疑似病例" 
	s ^DHCMed.EPDCHistory("NullDic","慢性(乙型肝炎、血吸虫病填写)") = "慢性(乙型肝炎、丙型肝炎、血吸虫病填写)" 
	s ^DHCMed.EPDCHistory("NullDic","人类感染猪链球菌") = "人感染猪链球菌" 
	s ^DHCMed.EPDCHistory("NullDic","发热伴血小板减少综合征") = "发热伴血小板减少综合症" 
	s ^DHCMed.EPDCHistory("NullDic","病毒性丁型肝炎") = "病毒性肝炎未分型" 
	s ^DHCMed.EPDCHistory("NullDic","病毒性丙型肝炎") = "丙型病毒性肝炎" 
	s ^DHCMed.EPDCHistory("NullDic","病毒性乙型肝炎") = "乙型病毒性肝炎" 
	s ^DHCMed.EPDCHistory("NullDic","病毒性戊型肝炎") = "戊型病毒性肝炎" 
	s ^DHCMed.EPDCHistory("NullDic","病毒性甲型肝炎") = "甲型病毒性肝炎" 
	s ^DHCMed.EPDCHistory("NullDic","结核性胸膜炎(细菌或组织证实)") = "结核性胸膜炎" 
	s ^DHCMed.EPDCHistory("NullDic","除霍乱、细菌性和阿米巴性痢疾、伤寒和副伤寒以外的感染性腹泻病") = "其它感染性腹泻病" 
	s ^DHCMed.EPDCHistory("NullDic","非淋菌性尿道(宫颈)炎") = "非淋菌性尿道炎" 
	s ^DHCMed.EPDCHistory("NullDic","其它疾病") = "其它"
	s ^DHCMed.EPDCHistory("NullDic","流行性乙行脑炎") = "流行性乙型脑炎"
	s ^DHCMed.EPDCHistory("NullDic","结核性胸膜炎(未证实)")="结核性胸膜炎"
	
	s ^DHCMed.EPDCHistory("NullDic","性病性淋巴肉芽肿")="淋病"
	s ^DHCMed.EPDCHistory("NullDic","有机磷中毒")="有机磷中毒性周围神经病"
	s ^DHCMed.EPDCHistory("NullDic","渔民")="渔（船）民"
	s ^DHCMed.EPDCHistory("NullDic","矽肺")="其它"
	
	Set RepID=0
	For {
		Set RepID=$o(^DHCMEPD(RepID))
		Quit:RepID=""
		
		Set RepInfo=$g(^DHCMEPD(RepID))
		
		//传染病诊断
		Set ICDDR=..ChangeICDByID($p(RepInfo,"^",5))
		Set objICD=##Class(DHCMed.EPD.Infection).GetObjById(ICDDR)
		Continue:'$IsObject(objICD)
		Continue:objICD.MIFIsActive'="Y"
		
		//区域
		Set Area=..ChangeDicByCode("EpidemicReportRegion","EpidemicReportRegion",$p(RepInfo,"^",2))
		//职业
		Set Occupation=..ChangeDicByCode("Career","Career",$p(RepInfo,"^",3))
		//密切接触情况
		Set IntimateCode=..ChangeDicByCode("EpidemicContact","EpidemicContact",$p(RepInfo,"^",6))
		//诊断分类(诊断程度)
		Set DiagDegree=..ChangeDicByCode("EpidemicDiagnoseDegree","EpidemicDiagnoseDegree",$p(RepInfo,"^",9))
		//诊断日期(2011-01-01 9:00)
		Set DiagDate=$p(RepInfo,"^",10),DiagTime=""
		If DiagDate'="" {
			Set DiagDate=$p(DiagDate," ",1)
			Set DiagTime=$p(DiagDate," ",2)
			Set:DiagDate="12-4-2010" DiagDate="2010-04-12"
			Set:DiagDate="undefined-undefined-2001" DiagDate="2001-01-01"
			Set:DiagDate'="" DiagDate=$zdh(DiagDate,3)
			Set:DiagTime'="" DiagTime=$zth(DiagTime,1)
		}
		//发病性质(发病程度)
		Set SickKind=..ChangeDicByCode("EpidemicSickQuality","EpidemicSickQuality",$p(RepInfo,"^",11))
		//上报位置
		Set RepPlace=..ChangeDicByCode("RepPlace","RepPlace",$p(RepInfo,"^",14))
		//报告状态
		Set Status=..ChangeDicByCode("EpidemicReportStatus","EpidemicReportStatus",$p(RepInfo,"^",15))
		
		Set obj=##Class(DHCMed.EPD.Epidemic).%New()
		Continue:'$IsObject(obj)
		
		Set obj.MEPDPapmiDR=$p(RepInfo,"^",1)       //PatientID
		Set obj.MEPDArea=Area                       //***区域
		Set obj.MEPDOccupation=Occupation           //职业
		Set FamName=$p(RepInfo,"^",4)
		Set:$l(FamName)>30 FamName=""
		Set:FamName="同上" FamName=""
		Set obj.MEPDFamName=FamName                 //家长姓名
		Set obj.MEPDICDDR=objICD                    //***传染病诊断
		Set obj.MEPDIntimateCode=IntimateCode       //***密切接触情况
		Set obj.MEPDDiagnoseType=$p(RepInfo,"^",7)  //诊断类型(描述)
		Set obj.MEPDSickDate=$p(RepInfo,"^",8)      //发病日期
		Set obj.MEPDDiagDegree=DiagDegree           //***诊断分类(诊断程度)
		Set obj.MEPDDiagDate=DiagDate               //***诊断日期(2011-01-01 9:00)
		Set obj.MEPDSickKind=SickKind               //***发病性质(发病程度)
		Set obj.MEPDDeathDate=$p(RepInfo,"^",12)    //死亡日期
		Set obj.MEPDLocDR=$p(RepInfo,"^",13)        //科室
		Set obj.MEPDRepPlace=RepPlace               //***上报位置
		Set obj.MEPDStatus=Status                   //***报告状态
		Set obj.MEPDRepUsrDR=$p(RepInfo,"^",16)     //报告人
		Set obj.MEPDRepDate=$p(RepInfo,"^",17)      //报告日期
		Set obj.MEPDRepTime=$p(RepInfo,"^",18)      //报告时间
		Set obj.MEPDCheckUsrDR=$p(RepInfo,"^",19)   //审核人
		Set obj.MEPDCheckDate=$p(RepInfo,"^",20)    //审核日期
		Set obj.MEPDCheckTime=$p(RepInfo,"^",21)    //审核时间
		Set obj.MEPDDemo=$p(RepInfo,"^",22)         //备注
		Set obj.MEPDDelReason=$p(RepInfo,"^",23)    //删除原因
		Set obj.MEPDMepdDR=""                       //订正报告ID
		Set obj.MEPDTelPhone=$p(RepInfo,"^",25)     //电话
		Set obj.MEPDAddress=$p(RepInfo,"^",26)      //地址
		Set obj.MEPDCompany=$p(RepInfo,"^",27)      //工作单位
		Set obj.MEPDIDAddress=$p(RepInfo,"^",28)    //户籍地址
		
		Set PatientID=$p(RepInfo,"^",1)
		Set RepDate=$p(RepInfo,"^",17)
		Set Paadm=$p(RepInfo,"^",29)
		If (Paadm="")||($p($g(^PAADM(+Paadm)),"^",6)'=PatientID) {
			Set Paadm=""
			Set AdmType=""
			For {
				Set AdmType=$o(^PAPERdr(+PatientID,"ADM",AdmType))
				Quit:AdmType=""
				
				Set tmpPaadm="",Paadm1=""
				For {
					Set tmpPaadm=$o(^PAPERdr(+PatientID,"ADM",AdmType,tmpPaadm),-1)
					Quit:tmpPaadm=""
					Quit:Paadm1'=""
					Continue:$p($g(^PAADM(tmpPaadm)),"^",20)="C"
					//Set AdmDate=$p($g(^PAADM(tmpPaadm)),"^",6)
					//upadte by pylian 2016-02-18 修改入院时间取值方式
    				Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(tmpPaadm)
					Set AdmDate=$p(AdmDateTime,"^",1)
					Continue:AdmDate>RepDate
					Set Paadm1=tmpPaadm
				}
				
				Set:Paadm="" Paadm=Paadm1
				Set:Paadm1>Paadm Paadm=Paadm1
			}
		}
		
		Set obj.MEPDText1=Paadm     //就诊号
		Set obj.MEPDText2=DiagTime  //诊断时间
		Set obj.MEPDIsUpload="Y"    // 是否已经上传数据
		Set obj.MEPDProvince=""     // 居住地省
		Set obj.MEPDCity=""         // 居住地城市
		Set obj.MEPDCounty=""       // 居住地县 区
		Set obj.MEPDVillage=""      // 居住地县 乡
		Set obj.MEPDRoad=""         // 街道门牌号
		
		If argFormat=1 {
			Set sc=obj.%Save()
			If $system.Status.IsError(sc) {
		   		Do $system.OBJ.DisplayError(sc)
			}Else{
				Write obj.%Id()
			}
		}
		Do obj.%Close()
	}
	
	Quit "ToNewReport() Over!"
	
ToNewReportErr
	Write "Error:"_$ZError,!
	Quit "ToNewReport() Error!"
}

ClassMethod ChangeDicByCode(argFromType As %String, argToType As %String, argCode As %String) As %String
{
	New (argFromType,argToType,argCode)
	Set return=""
	Quit:(argFromType="")||(argToType="")||(argCode="") return
	
	Set xDicID=$o(^DHCMDIC("0","TypeCode",argFromType,argCode,0))
	Set xDicDesc=$p($g(^DHCMDIC(+xDicID)),"^",2)
	Set:xDicDesc'="" nullDic=$g(^DHCMed.EPDCHistory("NullDic",xDicDesc))
	Set:$g(nullDic)'="" xDicDesc=$g(nullDic)
	If xDicDesc'="" {
		Set yDicID=$o(^DHCMed.SS.DictionaryI("IndexTypeDesc"," "_$ZCVT(argToType,"U")," "_$ZCVT(xDicDesc,"U"),0))
		Set:yDicID="" yDicID=$g(^TMP("DHCMed.EPDService.ImportHistory","ChangeDicByCode","To",argToType,xDicDesc))
		If yDicID="" {
			Set ^TMP("DHCMed.EPDService.ImportHistory","ChangeDicByCode","To",argToType,xDicDesc)=""
			Set ^DHCMed.EPDCHistory("NullDic",xDicDesc)=""
		}Else{
			Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(yDicID)
			Set return=objDic.Code
		}
	}Else{
		Set ^TMP("DHCMed.EPDService.ImportHistory","ChangeDicByCode","From",argFromType,argCode)=""
	}
	Quit return
}

ClassMethod ChangeICDByID(argID As %String) As %String
{
	New (argID)
	Set return=""
	Quit:(argID="") return
	
	Set xDicDesc=$p($g(^DHCMIF(argID)),"^",2)
	Set:xDicDesc'="" nullDic=$g(^DHCMed.EPDCHistory("NullDic",xDicDesc))
	Set:$g(nullDic)'="" xDicDesc=$g(nullDic)
	If xDicDesc'="" {
		If '$d(^TMP("DHCMed.EPDService.ImportHistory","ChangeICDByID","To")) {
			Set InfID=0
			For {
				Set InfID=$o(^DHCMed.EPDC("IF",InfID))
				Quit:InfID=""
				Set InfDesc=$p($g(^DHCMed.EPDC("IF",InfID)),"^",2)
				Set ^TMP("DHCMed.EPDService.ImportHistory","ChangeICDByID","To",InfDesc)=InfID
			}
		}
		Set yDicID=$g(^TMP("DHCMed.EPDService.ImportHistory","ChangeICDByID","To",xDicDesc))
		If yDicID="" {
			Set ^DHCMed.EPDCHistory("NullDic",xDicDesc)=""
		}Else{
			Set return=yDicID
		}
	}Else{
		Set ^TMP("DHCMed.EPDService.ImportHistory","ChangeICDByID","From",argID)=""
	}
	
	Quit return
}

/// w ##Class(DHCMed.EPDService.ImportHistory).ChangePaadm(1)
ClassMethod ChangePaadm(argFormat As %String) As %String
{
	New (argFormat)
	
	Set RepID=0
	For {
		Set RepID=$o(^DHCMed.EPD("EPD",RepID))
		Quit:RepID=""
		
		Set obj=##Class(DHCMed.EPD.Epidemic).%OpenId(RepID)
		Continue:'$IsObject(obj)
		Set RepLoc=obj.MEPDLocDR
		Set PatientID=obj.MEPDPapmiDR
		Set RepDate=obj.MEPDRepDate
		Set xxPaadm=obj.MEPDText1
		
		Set Paadm=""
		Set AdmType=""
		For {
			Set AdmType=$o(^PAPERdr(+PatientID,"ADM",AdmType))
			Quit:AdmType=""
			
			Set tmpPaadm="",Paadm1=""
			For {
				Set tmpPaadm=$o(^PAPERdr(+PatientID,"ADM",AdmType,tmpPaadm),-1)
				Quit:tmpPaadm=""
				Quit:Paadm1'=""
				Continue:$p($g(^PAADM(tmpPaadm)),"^",20)="C"
				//upadte by pylian 2016-02-18 修改入院时间取值方式
    			Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(tmpPaadm)
				Set AdmDate=$p(AdmDateTime,"^",1)
				//Set AdmDate=$p($g(^PAADM(tmpPaadm)),"^",6)
				Continue:AdmDate>RepDate
				Set AdmLoc=$p($g(^PAADM(tmpPaadm)),"^",4)
				Continue:RepLoc'=AdmLoc
				Set Paadm1=tmpPaadm
			}
			
			Set:Paadm="" Paadm=Paadm1
			Set:Paadm1>Paadm Paadm=Paadm1
		}
		Set obj.MEPDText1=Paadm
		
		If argFormat=1 {
			Set sc=obj.%Save()
			If $system.Status.IsError(sc) {
		   		Do $system.OBJ.DisplayError(sc)
			}Else{
				Write obj.%Id()
			}
		}
		Do obj.%Close()
	}
	
	Quit "OK"
}

Storage Default
{
<Data name="ImportHistoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCMed.EPDSer5BD.ImportHistoryD</DataLocation>
<DefaultData>ImportHistoryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.EPDSer5BD.ImportHistoryD</IdLocation>
<IndexLocation>^DHCMed.EPDSer5BD.ImportHistoryI</IndexLocation>
<StreamLocation>^DHCMed.EPDSer5BD.ImportHistoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
