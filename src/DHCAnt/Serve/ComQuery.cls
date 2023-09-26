/// CTOR: QP
/// DATE: 2020-05-22
/// DESC: 抗菌药物公共Query
Class DHCAnt.Serve.ComQuery Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DESC: 获取待审核抗菌药物信息【Portal产品组】
/// IN  : userCode 医生工号, locIDStr 科室ID串(^), 
/// 	  type 审核类型(KSF 科室预审, KS 科室审核, LAST 最终审核, ALL 所有)
/// OUT : id,text
/// EXEC: d ##Class(%ResultSet).RunQuery("DHCAnt.Serve.ComQuery","QryUnAuditList","YS01","95","ALL","2020-01-21","2020-05-22")
Query QryUnAuditList(userCode = "", locIDStr = "", type = "", sDate = "", eDate = "") As %Query(ROWSPEC = "AppRowid,locID,episodeID,patName,unDoType,OrderName,phcformdesc,PoisonLevel,UsePurpseDesc,Reason,infPart,DAUPOPerDesc,InstrDesc,AppSdate,orderDays,AppTime,AppUserName,Submission,ConsultStatus")
{
}

ClassMethod QryUnAuditListExecute(ByRef qHandle As %Binary, userCode = "", locIDStr = "", type = "", sDate = "", eDate = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	
 	;参数处理
 	if (userCode="")||(locIDStr="")||(sDate="")||(eDate="")||(type="") {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s userCode=$zcvt(userCode,"U") 
	s uid=$o(^SSU("SSUSR",0,"SSUSR_Initials",userCode,""))
	s docid=##class(DHCAnt.KSS.Common.Method).TransSSUserToCTCare(uid)
	if (docid="") {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s sDate=$zdh(sDate,3),eDate=$zdh(eDate,3)
	
	;循环处理
	for i=1:1:$l(locIDStr,"^") {
		s CLoc=$p(locIDStr,"^",i)
		s CHosp=$p(^CTLOC(CLoc),"^",22)
		for CDate=sDate:1:eDate {
			s AppRowid=""
			for {
				s (locID,episodeID,patName,unDoType,OrderName,phcformdesc,PoisonLevel,UsePurpseDesc,Reason)=""
				s (infPart,DAUPOPerDesc,InstrDesc,AppSdate,orderDays,AppTime,AppUserName,Submission,ConsultStatus)=""
				s locID=CLoc
				s AppRowid=$o(^DHCDAAi("ApplyDate",CDate,AppRowid))  
				q:AppRowid=""
				s ApplyStatus=$p($g(^DHCDAA("ANT",AppRowid)),"^",12)
				s CProcess=$p($g(^DHCDAA("ANT",AppRowid,1)),"^",36)		;当前流程
				s LastAuditLoc=$p($g(^DHCDAA("ANT",AppRowid,1)),"^",37)	;最终审核科室
				s ApplyLocID=$p(^DHCDAA("ANT",AppRowid,1),"^",25)
				continue:ApplyLocID'=CLoc
				s unDoType=""
				s exitFlag=$$IsExit(type,ApplyStatus,CProcess,AppRowid,.unDoType)
				continue:exitFlag=1
				s arcim=$p(^DHCDAA("ANT",AppRowid),"^",2)
				s OrderName=$p(^ARCIM(+arcim,$p(arcim,"||",2),1),"^",2)	;药品名称
				s phcdf=$p(^ARCIM(+arcim,$p(arcim,"||",2),1),"^",12)
				s pdcf=$p(^PHCD(+phcdf,"DF",$p(phcdf,"||",2),1),"^",1)
				s phcformdesc=$p(^PHCF(pdcf),"^",2)
				s KssCode=##class(DHCAnt.KSS.Common.Method).GetKssCate(arcim)
				s PoisonRowid=##class(DHCAnt.KSS.Common.Method).GetKssPoisonId(arcim)   
				i KssCode="KSS3"   s PoisonLevel="特殊级"         
				i KssCode="KSS2"   s PoisonLevel="限制级"
				i KssCode="KSS1"   s PoisonLevel="非限制级"
				s episodeID=$p(^DHCDAA("ANT",AppRowid),"^",1)
				s PAAdmType=##class(DHCAnt.KSS.Common.Method).GetPAAdmType(episodeID)
				s authFlag=##class(DHCAnt.KSS.Common.Method).GetDoctorTypePoisonFlag(docid,PAAdmType,PoisonRowid,CHosp)
				continue:authFlag'=1
				s PapmiDR=$P($G(^PAADM(episodeID)),"^",1)
				s patName=$p($G(^PAPER(PapmiDR,"ALL")),"^",1)
				s UseReasonID=$p($g(^DHCDAA("ANT",AppRowid,1)),"^",20)
				continue:'$d(^DAUP("DAUP",UseReasonID))
				s ReasonID=$P(^DAUP("DAUP",UseReasonID),"^",20)
				i ReasonID'="" s UsePurpseDesc=$p(^DHCAntBasePurposeDataConfigD(ReasonID),"^",3)
				s BodyPartDr=$p($g(^DAUP("DAUP",UseReasonID)),"^",6)      
				i BodyPartDr'="" s infPart=$p(^DHCAntBasePurposeDataConfigD(BodyPartDr),"^",3)
				s OPerIndDr=$P($g(^DAUP("DAUP",UseReasonID)),"^",10)
				i OPerIndDr'="" s DAUPOPerDesc=$p(^DHCAntBasePurposeDataConfigD(OPerIndDr),"^",3) 
				s Appdate=$P(^DHCDAA("ANT",AppRowid),"^",10)
				s AppTime=$P(^DHCDAA("ANT",AppRowid),"^",11)
				s Appdate=##class(DHCAnt.KSS.Common.Method).DateLogicalToHtml(Appdate)	
				s AppTime=$zt(AppTime,2)
				s AppTime=Appdate_" "_AppTime
				s AppUserDr=$p(^DHCDAA("ANT",AppRowid),"^",9)   
				s AppUserName=$p(^SSU("SSUSR",AppUserDr),"^",2)
				s Submission=$P(^DAUP("DAUP",UseReasonID),"^",15)
				i Submission=1 s Submission="是"
				e  s Submission="否"
				i CProcess["H" {
					s ConsultNums=$p($g(^DHCDAA("ANT",AppRowid,1)),"^",35)
					s ConsultationID1=$p($g(^DHCDAA("ANT",AppRowid,1)),"^",22)
					s ConsultationID2=$p($g(^DHCDAA("ANT",AppRowid,1)),"^",26)
					s ConsultationID3=$p($g(^DHCDAA("ANT",AppRowid,1)),"^",29)
					s agreeInfo1="",agreeInfo2="",agreeInfo3=""
					i ConsultationID1'= "" {
						s agreeInfo1=##Class(web.DHCEMConsInterface).GetConsentAnti(ConsultationID1)
					}
					i ConsultationID2'= "" {
						s agreeInfo2=##Class(web.DHCEMConsInterface).GetConsentAnti(ConsultationID2)
					}
					i ConsultationID3'= "" {
						s agreeInfo3=##Class(web.DHCEMConsInterface).GetConsentAnti(ConsultationID3)
					}
					i ConsultNums=1 {
						i agreeInfo1="Y" s ConsultStatus="同意"	
					}
					i ConsultNums=2 {
						i (agreeInfo1="Y")&&(agreeInfo2="Y") s ConsultStatus="同意"	
					}
					i ConsultNums=3 {
						i (agreeInfo1="Y")&&(agreeInfo2="Y")&&(agreeInfo3="Y") s ConsultStatus="同意"	
					}
				}
				
				
				d OutPut1
			}  
		}
		
	}
 	
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
IsExit(type,ApplyStatus,CProcess,AppRowid,unDoType)
	s mRtn=1 	;默认退出
	q:(ApplyStatus="C")||(ApplyStatus="R")||(ApplyStatus="U") 1
	
	if (type="KSF") {
		s unDoType="KSF"
		i (ApplyStatus="A")&&(CProcess["F") s mRtn=0
	}
	if (type="KS") {
		s unDoType="KS"
		q:CProcess'["S" 1
		i CProcess["H" {
			i ApplyStatus="H" s mRtn=0
		} elseif CProcess["F" {
			i ApplyStatus="F" s mRtn=0
		} else {
			i ApplyStatus="A" s mRtn=0	
		}
	}
	if (type="LAST") {
		s unDoType="LAST"
		Q:CProcess'["U" 1
		i CProcess["S" {
			i ApplyStatus="S" s mRtn=0
		} elseif CProcess["H" {
			i ApplyStatus="H" s mRtn=0
		} elseif CProcess["F" {
			i ApplyStatus="F" s mRtn=0	
		} else {
			i ApplyStatus="A" s mRtn=0	
		}
	}
	if (type="ALL") {
		i ApplyStatus="A" {
			if CProcess["F" {
				s unDoType="KSF"
				s mRtn=0
			}elseif CProcess["H" {
				s unDoType="H"
				s mRtn=1	;会诊过滤
			}elseif CProcess["S" {
				s unDoType="KS"
				s mRtn=0
			}else {
				s unDoType="LAST"	
				s mRtn=0
			}
		}
		i ApplyStatus="F" {
			if CProcess["H" {
				s unDoType="H"
				s mRtn=1	;会诊过滤
			}elseif CProcess["S" {
				s unDoType="KS"
				s mRtn=0
			}else {
				s unDoType="LAST"	
				s mRtn=0
			}
		}
		i ApplyStatus="H" {
			if CProcess["S" {
				s unDoType="KS"
			}else {
				s unDoType="LAST"	
			}
			s mRtn=0
		}
		i ApplyStatus="S" {
			if CProcess["U" {
				s unDoType="LAST"
				s mRtn=0
			} else {
				s mRtn=1	
			}
		}
	}
	q mRtn
	
OutPut1
	set Data=$lb(AppRowid,locID,episodeID,patName,unDoType,OrderName,phcformdesc,PoisonLevel,UsePurpseDesc,Reason,infPart,DAUPOPerDesc,InstrDesc,AppSdate,orderDays,AppTime,AppUserName,Submission,ConsultStatus)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryUnAuditListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryUnAuditListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryUnAuditListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryUnAuditListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

}
