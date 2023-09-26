Import SQLUser

/// 名称: DHCWMR.SSService.MrNoSrv
/// 描述: 病案号取值 个性化服务
/// 编写者：zhufei
/// 编写日期: 2014-11-22
Class DHCWMR.SSService.MrNoSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2015-01-09
/// Description:  根据病案号取病人ID接口
/// Table：       DHCWMR.SS.Main、DHCWMR.SS.Volume、DHCWMR.SS.VolPaadm
/// Input：       MrNo ：病案号
///               MrTypeID ：病案类型
/// Return：      返回String(多值逗号分隔)
/// w ##class(DHCWMR.SSService.MrNoSrv).GetPatientIDByMrNo("0028337",7)
ClassMethod GetPatientIDByMrNo(aMrNo As %String, aMrTypeID As %String) As %String
{
	New (aMrNo,aMrTypeID)
	Set return=""
	Quit:(aMrNo="")||(aMrTypeID="") return
	
	Set aMrNo=##Class(DHCWMR.SSService.CommonSrv).ChangeMrNo(aMrNo)
	Quit:aMrNo="" return
	
	Set objMrType=##class(DHCWMR.SS.MrType).GetObjById(aMrTypeID)
	Quit:'$IsObject(objMrType) return
	
	Set MainID=$o(^DHCWMR.SS.MainI("IndexTypeNoAct",aMrTypeID," "_$zcvt(aMrNo,"U"),1,0))
	If MainID'="" {
		Set return=##Class(DHCWMR.SS.Main).GetPatientIDs(MainID)
	}
	If return="" {
		Set NoField=objMrType.MTNoFiled.SDCode
		If (NoField="A"){
			Set xPatID=0
			For {
				Set xPatID=$o(^PAPERi("Govern",$zcvt(aMrNo,"U")_"Z",xPatID))
				Quit:xPatID=""
				Set return=return_","_xPatID
			}
		}
		If (NoField="B"){
			Set xPatID=0
			For {
				Set xPatID=$o(^PAPERi("Medicare1",$zcvt(aMrNo,"U"),xPatID))
				Quit:xPatID=""
				Set return=return_","_xPatID
			}
		}
		If (NoField="C"){
			Set xDHCPatID=0
			For {
				Set xDHCPatID=$o(^DHCPERSON(0,"FCMedicareCode1",$zcvt(aMrNo,"U"),xDHCPatID))
				Quit:xDHCPatID=""
				Set xPatID=$p($g(^DHCPERSON(xDHCPatID)),"^",1)
				Continue:xPatID=""
				Set return=return_","_xPatID
			}
		}
		If (NoField="D"){
			Set xDHCPatID=0
			For {
				Set xDHCPatID=$o(^DHCPERSON(0,"FCMedicareCode2",$zcvt(aMrNo,"U"),xDHCPatID))
				Quit:xDHCPatID=""
				Set xPatID=$p($g(^DHCPERSON(xDHCPatID)),"^",1)
				Continue:xPatID=""
				Set return=return_","_xPatID
			}
		}
		If (NoField="E"){
			Set xDHCPatID=0
			For {
				Set xDHCPatID=$o(^DHCPERSON(0,"SGMedicareCode1",$zcvt(aMrNo,"U"),xDHCPatID))
				Quit:xDHCPatID=""
				Set xPatID=$p($g(^DHCPERSON(xDHCPatID)),"^",1)
				Continue:xPatID=""
				Set return=return_","_xPatID
			}
		}
		If (NoField="F"){
			Set xDHCPatID=0
			For {
				Set xDHCPatID=$o(^DHCPERSON(0,"SGMedicareCode2",$zcvt(aMrNo,"U"),xDHCPatID))
				Quit:xDHCPatID=""
				Set xPatID=$p($g(^DHCPERSON(xDHCPatID)),"^",1)
				Continue:xPatID=""
				Set return=return_","_xPatID
			}
		}
		If (NoField="G"){
			Set xDHCPatID=0
			For {
				Set xDHCPatID=$o(^DHCPERSON(0,"SGMedicareCode3",$zcvt(aMrNo,"U"),xDHCPatID))
				Quit:xDHCPatID=""
				Set xPatID=$p($g(^DHCPERSON(xDHCPatID)),"^",1)
				Continue:xPatID=""
				Set return=return_","_xPatID
			}
		}
		Set:return'="" return=$e(return,2,$l(return))
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-01-09
/// Description:  根据EpisodeID取新生儿病案号接口
/// Table：       DHCWMR.SS.Main、DHCWMR.SS.Volume、DHCWMR.SS.VolPaadm
/// Input：       EpisodeID ：就诊号（分娩记录）
/// w ##Class(DHCWMR.SSService.MrNoSrv).GetNewBabyMrNo(aEpisodeID)
ClassMethod GetNewBabyMrNo(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	//母亲分娩记录对应就诊号
	Set PatientID=$p($g(^PAADM(aEpisodeID)),"^",1)
	Set MotherDr=$p($g(^PAADM(aEpisodeID)),"^",75)
	Quit:MotherDr="" return
	Set MotherPatID=$p($g(^PAADM(MotherDr)),"^",1)
	
	Set MotherMrNo=##class(DHCWMR.SSService.MrNoSrv).GetMrNoByEpisodeID(MotherDr,"")
	Quit:MotherMrNo="" return
	
	Set MrNo="",BabyPatList=""
	Set xMotherAdmID=""
	For {
		Set xMotherAdmID=$o(^PAPERdr(MotherPatID,"ADM","I",xMotherAdmID))
		Quit:xMotherAdmID=""
		Quit:MrNo'=""
		
		Set VisitStatus=$p($g(^PAADM(xMotherAdmID)),"^",20)
		Continue:VisitStatus="C"  //取消就诊
		
		//分娩记录
		Set xEpisodeID=""
		For {
			Set xEpisodeID=$o(^PAADMi("Mother",xMotherAdmID,xEpisodeID))
			Quit:xEpisodeID=""
			Quit:MrNo'=""
			
			Set BabyVisitStatus=$p($g(^PAADM(xEpisodeID)),"^",20)
			Continue:BabyVisitStatus="C"  //取消就诊
			Set MotherDr=$p($g(^PAADM(xEpisodeID)),"^",75)
			Continue:MotherDr=""  //无母亲指向
			
			Set PatientDr=$p($g(^PAADM(xEpisodeID)),"^",1)
			Continue:$listfind(BabyPatList,PatientDr)>0
			Set BabyPatList=BabyPatList_$lb(PatientDr)
			Continue:PatientDr'=PatientID
			
			Set Number=$listfind(BabyPatList,PatientID)
			Set MrNo=MotherMrNo_$e("ABCDEFGHIJKLMN",Number,Number)
		}
	}
	Set return=MrNo
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-12-30
/// Description:  根据默认号码类型格式化病案号
/// Table：       DHCWMR.SS.MrType、DHCWMR.SS.NoType
/// Input：       MrNo : 病案号
///               MrTypeID : 病案类型
/// w ##class(DHCWMR.SSService.MrNoSrv).FormatMrNo("111",7)
ClassMethod FormatMrNo(aMrNo As %String, aMrTypeID As %String) As %String
{
	New (aMrNo,aMrTypeID)
	Set return=""
	Quit:(aMrNo="")||(aMrTypeID="") return
	
	Set aMrNo=##Class(DHCWMR.SSService.CommonSrv).ChangeMrNo(aMrNo)
	Quit:aMrNo="" return
	
	Set MrNo=""
 	Set xSub=0
 	For {
	 	Set xSub=$o(^DHCWMR.SS.MrTypeD(aMrTypeID,"NT",xSub))
	 	Quit:xSub=""
	 	Quit:MrNo'=""
	 	
	 	Set obj=##class(DHCWMR.SS.NoType).GetObjById(aMrTypeID_"||"_xSub)
	 	Continue:'$IsObject(obj)
	 	Continue:obj.NTIsActive'=1
	 	Continue:obj.NTIsDefault'=1
	 	
	 	Set NoLen=obj.NTNoLen
		Set NoLen=+NoLen
	 	Set NoHead=obj.NTNoHead
		If NoHead'="" {
			If $e(aMrNo,1,$l(NoHead))=NoHead {
				Set aMrNo=$e(aMrNo,$l(NoHead)+1,$l(aMrNo))
			}
		}
		
		If NoLen>$l(aMrNo) {
			Set $p(MrNo,"0",NoLen+1-$l(aMrNo))=aMrNo
		} Else {
			Set MrNo=aMrNo
		}
		Set:NoHead'="" MrNo=$zcvt(NoHead,"U")_MrNo
 	}
 	Quit:MrNo'="" MrNo
	
	Set return=aMrNo
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-11-22
/// Description:  根据PatientID取病案号【接口】
/// Table：       DHCWMR.SS.Main、DHCWMR.SS.Volume、DHCWMR.SS.VolPaadm
/// Input：       PatientID : 病人信息ID
///               AdmType : 就诊类型
///               HospitalID : 医院ID（CT_Hospital.ID）
/// w ##class(DHCWMR.SSService.MrNoSrv).GetMrNoByPatientID(10,7)
ClassMethod GetMrNoByPatientID(aPatientID As %String, aMrTypeID As %String) As %String
{
	New (aPatientID,aMrTypeID)
	Set return=""
	Quit:(aPatientID="")||(aMrTypeID="") return
	
	Set PatientID=aPatientID
	Set MrTypeID=aMrTypeID
	Set objMrType=##class(DHCWMR.SS.MrType).GetObjById(MrTypeID)
	Quit:'$IsObject(objMrType) return
	Quit:'$IsObject(objMrType.MTReceiptType) return
	Set ReceiptType=objMrType.MTReceiptType.SDCode  //接诊方式
	If ReceiptType="M" {
		//按病人分号
		Set MrNo=##class(DHCWMR.SSService.MrNoSrv).GetMrNoByPatientIDX(PatientID,MrTypeID) //最新号码
		Quit:MrNo'="" MrNo  //病案系统表
		Quit:'$IsObject(objMrType.MTNoFiled) return
		Set NoField=objMrType.MTNoFiled.SDCode  //病案号存储字段
		Set MrNo=##class(DHCWMR.SSService.MrNoSrv).GetHisMrNo(PatientID,NoField)
		Quit:MrNo'="" MrNo  //病人信息表
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-11-22
/// Description:  根据EpisodeID取病案号【接口】
/// Table：       DHCWMR.SS.Main、DHCWMR.SS.Volume、DHCWMR.SS.VolPaadm
/// Input：       EpisodeID : 就诊号
/// w ##class(DHCWMR.SSService.MrNoSrv).GetMrNoByEpisodeID()
ClassMethod GetMrNoByEpisodeID(aEpisodeID As %String, aMrTypeID As %String = "") As %String
{
	New (aEpisodeID,aMrTypeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	//取EpisodeID对应病案号
	Set MrNo=##class(DHCWMR.SSService.MrNoSrv).GetMrNoByEpisodeIDX(aEpisodeID)
	Quit:MrNo'="" MrNo  //病案系统表
	
	//取PatientID对应病案号
	Set PatientID=$p($g(^PAADM(aEpisodeID)),"^",1)
	Quit:(PatientID="")||(aMrTypeID="") return
	Set objMrType=##class(DHCWMR.SS.MrType).GetObjById(aMrTypeID)
	Quit:'$IsObject(objMrType) return
	Quit:'$IsObject(objMrType.MTReceiptType) return
	Set ReceiptType=objMrType.MTReceiptType.SDCode  //接诊方式
	If ReceiptType="M" { //按病人分号
		Set MrNo=##class(DHCWMR.SSService.MrNoSrv).GetMrNoByPatientIDX(PatientID,aMrTypeID) //最新号码
		Quit:MrNo'="" MrNo  //病案系统表
		
		Quit:'$IsObject(objMrType.MTNoFiled) MrNo
		Set NoField=objMrType.MTNoFiled.SDCode  //病案号存储字段
		Set MrNo=##class(DHCWMR.SSService.MrNoSrv).GetHisMrNo(PatientID,NoField)
		Quit:MrNo'="" MrNo  //病人信息表
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-11-22
/// Description:  根据PatientID取病案号【病案系统】
/// Table：       DHCWMR.SS.Main、DHCWMR.SS.Volume、DHCWMR.SS.VolPaadm
/// Input：       PatientID : 就诊号
/// w ##class(DHCWMR.SSService.MrNoSrv).GetMrNoByPatientIDX(10,7)
ClassMethod GetMrNoByPatientIDX(aPatientID As %String, aMrTypeID As %String) As %String
{
	New (aPatientID,aMrTypeID)
	Set return=""
	Quit:aPatientID="" return
	
	//病案系统取病案号
	Set xVolID="",MrNo=""
	For {
		Set xVolID=$o(^DHCWMR.SS.VolumeI("VP","IndexPatientID"," "_aPatientID,xVolID),-1)
		Quit:xVolID=""
		
		//add by zf 20150318 避免卷有效、就诊无效情况
		Set xSubID=0,IsActive=0
		For {
			Set xSubID=$o(^DHCWMR.SS.VolumeI("VP","IndexPatientID"," "_aPatientID,xVolID,xSubID))
			Quit:xSubID=""
			Set objVolPaadm=##Class(DHCWMR.SS.VolPaadm).GetObjById(xVolID_"||"_xSubID)
			Continue:'$IsObject(objVolPaadm)
			Set Paadm=objVolPaadm.VPEpisodeID
			Continue:Paadm=""
			Continue:$p($g(^PAADM(Paadm)),"^",20)="C"  //取消就诊
			Set IsActive=1
			Quit:IsActive=1
		}
		Continue:IsActive=0
		
		Set objVol=##class(DHCWMR.SS.Volume).GetObjById(xVolID)
		Continue:'$IsObject(objVol)
		Continue:objVol.SVIsActive'=1
		Set objMain=objVol.SVMainDr
		Continue:'$IsObject(objMain)
		Continue:objMain.SMIsActive'=1
		Continue:objMain.SMMrType.%Id()'=aMrTypeID
		Set MrNo=objMain.SMMrNo
		Quit:MrNo'="" //病案号不为空退出
	}
	Quit:MrNo'="" MrNo
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-11-22
/// Description:  根据EpisodeID取病案号【病案系统】
/// Table：       DHCWMR.SS.Main、DHCWMR.SS.Volume、DHCWMR.SS.VolPaadm
/// Input：       EpisodeID : 就诊号
/// w ##class(DHCWMR.SSService.MrNoSrv).GetMrNoByEpisodeIDX()
ClassMethod GetMrNoByEpisodeIDX(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	//病案系统取病案号
	Set xVolID="",MrNo=""
	For {
		Set xVolID=$o(^DHCWMR.SS.VolumeI("VP","IndexEpisodeID"," "_aEpisodeID,xVolID))
		Quit:xVolID=""
		
		Set objVol=##class(DHCWMR.SS.Volume).GetObjById(xVolID)
		Continue:'$IsObject(objVol)
		Continue:objVol.SVIsActive'=1
		Set objMain=objVol.SVMainDr
		Continue:'$IsObject(objMain)
		Continue:objMain.SMIsActive'=1
		Set MrNo=objMain.SMMrNo
		Quit:MrNo'="" //病案号不为空退出
	}
	Quit:MrNo'="" MrNo
	
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2014-09-09
/// Description:  根据PatientID和字段代码取病案号
/// Table：       Pa_Patmas、Pa_Person
/// Input：       PatientID : 病人ID
///               NoFiled : 字段代码
/// w ##class(DHCWMR.SSService.MrNoSrv).GetHisMrNo(282,"I")
ClassMethod GetHisMrNo(aPatientID As %String, aNoFiled As %String) As %String
{
	New (aPatientID,aNoFiled)
	Set return=""
	Quit:(aPatientID="")||(aNoFiled="") return
	Set:aNoFiled="A" return=$p($g(^PAPER(aPatientID,"PER",4)),"^",4)
	Set:aNoFiled="B" return=$p($g(^PAPER(aPatientID,"PAT",1)),"^",22)
	Set DHCPersonID=$O(^DHCPERSON(0,"PAPERSON",aPatientID,""))
	Set:aNoFiled="C" return=$p($g(^DHCPERSON(+DHCPersonID)),"^",5)
	Set:aNoFiled="D" return=$p($g(^DHCPERSON(+DHCPersonID)),"^",6)
	Set:aNoFiled="E" return=$p($g(^DHCPERSON(+DHCPersonID)),"^",2)
	Set:aNoFiled="F" return=$p($g(^DHCPERSON(+DHCPersonID)),"^",3)
	Set:aNoFiled="G" return=$p($g(^DHCPERSON(+DHCPersonID)),"^",4)
	Set:return'="" return=##Class(DHCWMR.SSService.CommonSrv).ChangeMrNo(return)
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2014-09-03
/// Description:  更新病案号到HIS
/// Input：       aMrNo：病案号，aPapmi：病人ID，aNoFiled：更新字段          
/// Return:		  成功：>0  失败:<0
/// w ##class(DHCWMR.SSService.MrNoSrv).UpdateHisMrNo(8,"B","00000789")
ClassMethod UpdateHisMrNo(aPatientID As %String, aNoFiled As %String, aMrNo As %String) As %String
{
	New (aPatientID,aNoFiled,aMrNo)
	Set return=0
	Quit:(aPatientID="")||(aNoFiled="") return
	
	If (aNoFiled="A"){
		&sql(update pa_person set paper_governcardno=:aMrNo where paper_rowid=:aPatientID)
   		Quit:SQLCODE<0 SQLCODE
	}
	If (aNoFiled="B"){
		&sql(update PA_PatMas set PAPMI_Medicare=:aMrNo,PAPMI_SafetyNetCardNo=:aMrNo where PAPMI_RowId=:aPatientID)
   		Quit:SQLCODE<0 SQLCODE
	}
	If (aNoFiled="C"){
		If $d(^DHCPERSON(0,"PAPERSON",aPatientID)) {
	 		&sql(update DHC_Person set PAPER_FCMedicareCode1=:aMrNo where PAPER_PaPerson_dr=:aPatientID)
		} Else {
	 		&sql(insert into DHC_Person(PAPER_PaPerson_dr,PAPER_FCMedicareCode1) values(:aPatientID,:aMrNo))
		}
	 	Quit:SQLCODE<0 SQLCODE
	}
	If (aNoFiled="D"){
		If $d(^DHCPERSON(0,"PAPERSON",aPatientID)) {
	 		&sql(update DHC_Person set PAPER_FCMedicareCode2=:aMrNo where PAPER_PaPerson_dr=:aPatientID)
		} Else {
	 		&sql(insert into DHC_Person(PAPER_PaPerson_dr,PAPER_FCMedicareCode2) values(:aPatientID,:aMrNo))
		}
		Quit:SQLCODE<0 SQLCODE
	}
	If (aNoFiled="E"){
		If $d(^DHCPERSON(0,"PAPERSON",aPatientID)) {
	 		&sql(update DHC_Person set PAPER_SGMedicareCode1=:aMrNo where PAPER_PaPerson_dr=:aPatientID)
		} Else {
	 		&sql(insert into DHC_Person(PAPER_PaPerson_dr,PAPER_SGMedicareCode1) values(:aPatientID,:aMrNo))
		}
		Quit:SQLCODE<0 SQLCODE
	}
	If (aNoFiled="F"){
		If $d(^DHCPERSON(0,"PAPERSON",aPatientID)) {
	 		&sql(update DHC_Person set PAPER_SGMedicareCode2=:aMrNo where PAPER_PaPerson_dr=:aPatientID)
		} Else {
	 		&sql(insert into DHC_Person(PAPER_PaPerson_dr,PAPER_SGMedicareCode2) values(:aPatientID,:aMrNo))
		}
		Quit:SQLCODE<0 SQLCODE
	}
	If (aNoFiled="G"){
		If $d(^DHCPERSON(0,"PAPERSON",aPatientID)) {
	 		&sql(update DHC_Person set PAPER_SGMedicareCode3=:aMrNo where PAPER_PaPerson_dr=:aPatientID)
		} Else {
	 		&sql(insert into DHC_Person(PAPER_PaPerson_dr,PAPER_SGMedicareCode3) values(:aPatientID,:aMrNo))
		}
		Quit:SQLCODE<0 SQLCODE
	}
	
	Set return=1
	Quit return
}

}
