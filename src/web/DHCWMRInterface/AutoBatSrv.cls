/// 病案自动任务接口
Class web.DHCWMRInterface.AutoBatSrv Extends (%Library.RegisteredObject, websys.Abstract) [ Not ProcedureBlock ]
{

Parameter BUILD = 15;

/// 自动任务更新丢失的病案号
/// w ##Class(web.DHCWMRInterface.AutoBatSrv).CheckMrNo()
ClassMethod CheckMrNo()
{
	New
	Set return="Error"
	
	Set $ZT="CheckMrNoError"
	
	//取病案类型设置
	Set strMrType=##class(web.DHCWMRNoCtl).GetMrNoFormat(7)
	Quit:strMrType="" return
	Set MrNoField=$p($p(strMrType,"^",5),"/",2)
	Quit:MrNoField="" return
	
	//在院患者列表
	Set WardID="",Count=0
	For {
		Set WardID=$o(^PAADMi("CurrWard",WardID))
		Quit:WardID=""
		Set RoomID=""
		For {
			Set RoomID=$o(^PAADMi("CurrWard",WardID,RoomID))
			Quit:RoomID=""
			Set Paadm=""
			For {
				Set Paadm=$o(^PAADMi("CurrWard",WardID,RoomID,Paadm))
				Quit:Paadm=""
				
				Set AdmInfo=$g(^PAADM(Paadm))
				Continue:$p(AdmInfo,"^",2)'="I"      //就诊类型过滤
				Set PatientID=$p(AdmInfo,"^",1)
				Continue:PatientID=""
				
				Do DoCheckMrNo
			}
		}
	}
	
	//当天出院患者列表
	For xDate=(+$h-1):1:(+$h) {
		Set Paadm=0
		For {
			Set Paadm=$o(^PAADMi("DischDate",xDate,Paadm))
			Quit:Paadm=""
			
			Set AdmInfo=$g(^PAADM(Paadm))
			Continue:$p(AdmInfo,"^",2)'="I"      //就诊类型过滤
			Set PatientID=$p(AdmInfo,"^",1)
			Continue:PatientID=""
			
			Do DoCheckMrNo
		}
	}
	
	Quit "OK"
	
CheckMrNoError
	Quit "Error"
	
DoCheckMrNo
	Set MrNo=""
	Set:MrNoField="A" MrNo=##class(web.DHCWMRMedBaseCtl).GetMrNoA(PatientID)
	Set:MrNoField="B" MrNo=##class(web.DHCWMRMedBaseCtl).GetMrNoB(PatientID)
	Set:MrNoField="C" MrNo=##class(web.DHCWMRMedBaseCtl).GetMrNoC(PatientID)
	Set:MrNoField="D" MrNo=##class(web.DHCWMRMedBaseCtl).GetMrNoD(PatientID)
	
	;Quit:MrNo'=""
	
	Set VolID=0,MrNo=""
	For {
		Set VolID=$o(^DHCWMRVOL(0,"PaadmDr",Paadm,VolID))
		Quit:VolID=""
		Quit:MrNo'=""
		
		Set IsActive=$p($g(^DHCWMRVOL(VolID)),"^",7)
		Continue:IsActive'["Y"
		Set MainID=$p($g(^DHCWMRVOL(VolID)),"^",1)
		Continue:MainID=""
		Set IsActive=$p($g(^DHCWMRMAIN(MainID)),"^",6)
		Continue:IsActive'["Y"
		Set MrType=$P(^DHCWMRMAIN(MainID),"^",1)
		Continue:MrType'=7
		Set MrNo=$p($g(^DHCWMRMAIN(MainID)),"^",2)
	}
	Quit:MrNo=""
	
	Set:MrNoField="A" flg=##class(web.DHCWMRMedBaseCtl).UpdateMrNoA(MrNo,PatientID)
	Set:MrNoField="B" flg=##class(web.DHCWMRMedBaseCtl).UpdateMrNoB(MrNo,PatientID)
	Set:MrNoField="C" flg=##class(web.DHCWMRMedBaseCtl).UpdateMrNoC(MrNo,PatientID)
	Set:MrNoField="D" flg=##class(web.DHCWMRMedBaseCtl).UpdateMrNoD(MrNo,PatientID)
	
	Quit
}

/// 自动任务更新丢失的病案号
/// w ##Class(web.DHCWMRInterface.AutoBatSrv).CheckMrNoByAdm(206)
ClassMethod CheckMrNoByAdm(aEpisodeID As %String)
{
	New (aEpisodeID)
	Set return=""
	
	Set $ZT="CheckMrNoByAdmError"
	
	//取病案类型设置
	Set strMrType=##class(web.DHCWMRNoCtl).GetMrNoFormat(7)
	Quit:strMrType="" return
	Set MrNoField=$p($p(strMrType,"^",5),"/",2)
	Quit:MrNoField="" return
	
	Set Paadm=aEpisodeID
	Set AdmInfo=$g(^PAADM(Paadm))
	Quit:$p(AdmInfo,"^",2)'="I" return
	Set PatientID=$p(AdmInfo,"^",1)
	Quit:PatientID="" return
	
	Do DoCheckMrNo
	
	Set:MrNoField="A" MrNo=##class(web.DHCWMRMedBaseCtl).GetMrNoA(PatientID)
	Set:MrNoField="B" MrNo=##class(web.DHCWMRMedBaseCtl).GetMrNoB(PatientID)
	Set:MrNoField="C" MrNo=##class(web.DHCWMRMedBaseCtl).GetMrNoC(PatientID)
	Set:MrNoField="D" MrNo=##class(web.DHCWMRMedBaseCtl).GetMrNoD(PatientID)
	Quit MrNo
	
CheckMrNoByAdmError
	Quit ""
}

/// 描述：根据就诊日期处理丢失病案号
/// Debug:Do ##Class(web.DHCWMRInterface.AutoBatSrv).CheckMrNoByAdmDate("2013-09-03","2013-09-06")
ClassMethod CheckMrNoByAdmDate(DateFrom As %String, DateTo As %String) As %String
{
	New (DateFrom,DateTo)
	
	Set:DateFrom["/" DateFrom=$zdh(DateFrom,4)
	Set:DateTo["/" DateTo=$zdh(DateTo,4)
	Set:DateFrom["-" DateFrom=$zdh(DateFrom,3)
	Set:DateTo["-" DateTo=$zdh(DateTo,3)
	Set DateFrom=+DateFrom
	Set DateTo=+DateTo
	
	//取病案类型设置
	Set strMrType=##class(web.DHCWMRNoCtl).GetMrNoFormat(7)
	Quit:strMrType="" ""
	Set MrNoField=$p($p(strMrType,"^",5),"/",2)
	Quit:MrNoField="" ""
	
	Set Count=0
	Set StaDate=DateFrom-1
	For {
		Set StaDate=$o(^PAADMi("PAADM_AdmDate",StaDate))
		Quit:(StaDate="")
		Quit:(StaDate=0)||(StaDate>DateTo)
		
		Set Paadm=0
		For {
			Set Paadm=$o(^PAADMi("PAADM_AdmDate",StaDate,Paadm))	
			Quit:Paadm=""
			
			Set Papmi=$p(^PAADM(Paadm),"^",1)
			Continue:Papmi=""
			
			Set PMrNo=""
			Set:MrNoField="A" PMrNo=##class(web.DHCWMRMedBaseCtl).GetMrNoA(Papmi)
			Set:MrNoField="B" PMrNo=##class(web.DHCWMRMedBaseCtl).GetMrNoB(Papmi)
			Set:MrNoField="C" PMrNo=##class(web.DHCWMRMedBaseCtl).GetMrNoC(Papmi)
			Set:MrNoField="D" PMrNo=##class(web.DHCWMRMedBaseCtl).GetMrNoD(Papmi)     
			
			Set MainID=0,MrNo=""
			;^DHCWMRMAIN(0,"PAPMI",{Papmi_Dr},{Rowid})
			For {
				Set MainID=$O(^DHCWMRMAIN(0,"PAPMI",Papmi,MainID))
				Quit:(MainID="")||(MrNo'="")
				
				Set IsActive=$P(^DHCWMRMAIN(MainID),"^",6)
				Continue:IsActive="N"
				Set MrType=$P(^DHCWMRMAIN(MainID),"^",1)
				Continue:MrType'=7
				Set MrNo=$P(^DHCWMRMAIN(MainID),"^",2)
		    }
			
		    If ((MrNo'="")&&(MrNo'=PMrNo)){
				Set PatName=$p(^PAPER(Papmi,"ALL"),"^",1) 
				Set PapmiNo=$p(^PAPER(Papmi,"PAT",1),"^",1)
				Set:MrNoField="A" flg=##class(web.DHCWMRMedBaseCtl).UpdateMrNoA(MrNo,Papmi)
				Set:MrNoField="B" flg=##class(web.DHCWMRMedBaseCtl).UpdateMrNoB(MrNo,Papmi)
				Set:MrNoField="C" flg=##class(web.DHCWMRMedBaseCtl).UpdateMrNoC(MrNo,Papmi)
				Set:MrNoField="D" flg=##class(web.DHCWMRMedBaseCtl).UpdateMrNoD(MrNo,Papmi)	  
				w "姓名："_PatName_" 登记号："_PapmiNo_" 病案号："_MrNo,!  
				Set Count=$i(Count)
			} ElseIf PMrNo["JZ" {
				Set PatName=$p(^PAPER(Papmi,"ALL"),"^",1)
				Set PapmiNo=$p(^PAPER(Papmi,"PAT",1),"^",1)
				Set:MrNoField="A" flg=##class(web.DHCWMRMedBaseCtl).UpdateMrNoA("",Papmi)
				Set:MrNoField="B" flg=##class(web.DHCWMRMedBaseCtl).UpdateMrNoB("",Papmi)
				Set:MrNoField="C" flg=##class(web.DHCWMRMedBaseCtl).UpdateMrNoC("",Papmi)
				Set:MrNoField="D" flg=##class(web.DHCWMRMedBaseCtl).UpdateMrNoD("",Papmi)	  
				w "姓名："_PatName_" 登记号："_PapmiNo_" 病案号："_MrNo,!  
				Set Count=$i(Count)
			}
		}	
	}
	w "共计："_Count,!
	Quit Count
}

}
