/// 名称: 	  DHCWMR.IO.OutService
/// 描述: 	  病案管理对外接口程序
/// 编写者：  朱飞
/// 编写日期: 2014-03-17
Class DHCWMR.IO.OutService Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2015-01-10
/// NUM: 01
/// Description:  取病案管理系统版本号(3:旧版本,4:新版本)
/// w ##Class(DHCWMR.IO.OutService).GetMRSVersion()
ClassMethod GetMRSVersion() As %String
{
	New
	Set $ZT="GetVersionErr"
	Set return=##Class(MA.IPMR.IO.OutService).GetIPMRVersion()
	if return="" {
		Set return=+$g(^DHCWMR.SS.VersionC)
	} 
	Quit return
GetVersionErr
	Set return=+$g(^DHCWMR.SS.VersionC)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-03-17
/// NUM: 02
/// Description:  就诊号取病案号接口
/// Table：       DHC_WMR_Main,DHC_WMR_MainVolume
/// Input：       EpisodeID ：就诊号
///               MedType   ：门诊(O)、急诊(E)、住院(I)
/// w ##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(394,"I",.ErrMsg)
ClassMethod IGetMrNoByEpisodeID(EpisodeID As %String, MedType As %String, ByRef ErrMsg As %String) As %String
{
	New (EpisodeID,MedType,ErrMsg)
	
	// 版本判断
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		set return=##class(DHCWMR.IO.ToOutService).IGetMrNoByEpisodeID(EpisodeID,MedType,.ErrMsg)
		quit return
	}elseif ($e(MRSVersion,0,1)="4"){
		set return=##Class(MA.IPMR.IO.OutService).GetMrNoByEpisodeID(EpisodeID,.ErrMsg)
		quit return
	}
	
	Set return="",ErrMsg="-1:参数错误"
	Quit:(EpisodeID="")||(MedType="") return
	
	//暂时未处理集团化医院情况
	Set AdmLoc=$p($g(^PAADM(EpisodeID)),"^",4)
	Set HospitalID=$p($g(^CTLOC(+AdmLoc)),"^",22)
	
	Set $ZT="IGetMrNoByEpisodeIDError"
	
	Set ErrMsg="-2:就诊不存在"
	Quit:'$d(^PAADM(EpisodeID)) return
	
	Set MrNo=""
	If MedType="I" {
		Set MotherDr=$p($g(^PAADM(EpisodeID)),"^",75)  //母亲分娩记录对应就诊号
		If MotherDr'="" {
			//新生儿的病案号取值
			Set MrNo=..GetNewBabyMrNo(EpisodeID)
			Set ErrMsg="-3.1:新生儿住院病案号不存在"
			Quit:MrNo="" return
		} Else {
			//普通病人病案号取值
			Set xVolID=""
			For {
				Set xVolID=$o(^DHCWMRVOL(0,"PaadmDr",EpisodeID,xVolID),-1)
				Quit:xVolID=""
				Quit:MrNo'=""
				
				Set IsActive=$p($g(^DHCWMRVOL(xVolID)),"^",7)
				Continue:IsActive'="Y"
				
				Set MainID=$p($g(^DHCWMRVOL(xVolID)),"^",1)
				Set IsActive=$p($g(^DHCWMRMAIN(+MainID)),"^",6)
				Continue:IsActive'="Y"
				Set MrType=$p($g(^DHCWMRMAIN(+MainID)),"^",1)
				
				Set LeadingFactor=##class(web.DHCWMRGroup.DHCWMRGroupReceipt).GetLeadingFactor(MrType)
				If $ZCVT(LeadingFactor,"U")="V" {
					Set MrNo=$p($g(^DHCWMRVOL(xVolID)),"^",10)
				} Else {
					Set MrNo=$p($g(^DHCWMRMAIN(+MainID)),"^",2)
				}
			}
			Set ErrMsg="-3.2:患者住院病案号不存在"
			Quit:MrNo="" return
		}
	} ElseIf MedType="O" {
		Set PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
		Set xMainID=""
		For {
			Set xMainID=$o(^DHCWMRMAIN(0,"PAPMI",+PatientID,xMainID),-1)
			Quit:xMainID=""
			Quit:MrNo'=""
			
			Set IsActive=$p($g(^DHCWMRVOL(xMainID)),"^",6)
			Continue:IsActive'="Y"
			Set MrNo=$p($g(^DHCWMRMAIN(xMainID)),"^",2)
		}
		Set ErrMsg="-4:患者门诊病案号不存在"
		Quit:MrNo="" return
	} ElseIf MedType="E" {
		Set xVolID=""
		For {
			Set xVolID=$o(^DHCWMRVOL(0,"PaadmDr",EpisodeID,xVolID),-1)
			Quit:xVolID=""
			Quit:MrNo'=""
			
			Set IsActive=$p($g(^DHCWMRVOL(xVolID)),"^",7)
			Continue:IsActive'="Y"
			
			Set MainID=$p($g(^DHCWMRVOL(xVolID)),"^",1)
			Set IsActive=$p($g(^DHCWMRMAIN(+MainID)),"^",6)
			Continue:IsActive'="Y"
			Set MrType=$p($g(^DHCWMRMAIN(+MainID)),"^",1)
			
			Set LeadingFactor=##class(web.DHCWMRGroup.DHCWMRGroupReceipt).GetLeadingFactor(MrType)
			If $ZCVT(LeadingFactor,"U")="V" {
				Set MrNo=$p($g(^DHCWMRVOL(xVolID)),"^",10)
			} Else {
				Set MrNo=$p($g(^DHCWMRMAIN(+MainID)),"^",2)
			}
		}
		If MrNo="" {
			Set PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
			Set xMainID=""
			For {
				Set xMainID=$o(^DHCWMRMAIN(0,"PAPMI",+PatientID,xMainID),-1)
				Quit:xMainID=""
				Quit:MrNo'=""
				
				Set IsActive=$p($g(^DHCWMRVOL(xMainID)),"^",6)
				Continue:IsActive'="Y"
				Set MrType=$p($g(^DHCWMRMAIN(xMainID)),"^",1)
				Set LeadingFactor=##class(web.DHCWMRGroup.DHCWMRGroupReceipt).GetLeadingFactor(MrType)
				If $ZCVT(LeadingFactor,"U")="V" {
					Set MrNo=""
				} Else {
					Set MrNo=$p($g(^DHCWMRMAIN(xMainID)),"^",2)
				}
			}
		}
		Set ErrMsg="-5:患者门诊病案号不存在"
		Quit:MrNo="" return
	} Else {}
	
	Set ErrMsg="",return=MrNo
	Quit return
	
IGetMrNoByEpisodeIDError
     Set ErrMsg="-999:"_$ZE
     Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-03-17
/// NUM: 03
/// Description:  病人ID取病案号接口
/// Table：       DHC_WMR_Main,DHC_WMR_MainVolume
/// Input：       PatientID ：病人ID
///               MedType   ：门诊（O）、急诊（E）、住院（I）
/// w ##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(225,"I","",.ErrMsg)
ClassMethod IGetMrNoByPatientID(PatientID As %String, MedType As %String, HospitalID As %String = "", ByRef ErrMsg As %String = "")
{
	New (PatientID,MedType,HospitalID,ErrMsg)
	
	Set ErrMsg="-1.1:兼容原有接口错误"
	// 版本判断
	Set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	If MRSVersion=3 {
		Set return=##class(DHCWMR.IO.ToOutService).IGetMrNoByPatientID(PatientID,MedType,HospitalID,.ErrMsg)
		Quit return
	}ElseIf $e(MRSVersion,0,1)="4" {
		Set return=##class(MA.IPMR.IO.OutService).GetMrNoByPatientID(PatientID,MedType,HospitalID,"",.ErrMsg)
		Quit return
	}
	
	Set return="",ErrMsg="-1:参数错误"
	Quit:(PatientID="")||(MedType="") return
	
	//暂时未处理集团化医院情况
	Set HospitalID=$g(HospitalID)
	
	Set $ZT="IGetMrNoByPatientIDError"
	
	Set ErrMsg="-2:患者不存在"
	Quit:'$d(^PAPER(PatientID)) return
	
	Set EpisodeID=""
	If MedType="I" {
		Set xEpisodeID=""
		For {
			Set xEpisodeID=$o(^PAPERdr(PatientID,"ADM","I",xEpisodeID),-1)
			Quit:xEpisodeID=""
			Quit:EpisodeID'=""
			
			Set AdmLoc=$p($g(^PAADM(xEpisodeID)),"^",4)
			Set AdmHosp=$p($g(^CTLOC(+AdmLoc)),"^",22)
			Continue:(AdmHosp'="")&&(AdmHosp'=HospitalID)
			Set EpisodeID=xEpisodeID
		}
	} ElseIf MedType="O" {
		Set xEpisodeID=""
		For {
			Set xEpisodeID=$o(^PAPERdr(PatientID,"ADM","O",xEpisodeID),-1)
			Quit:xEpisodeID=""
			Quit:EpisodeID'=""
			
			Set AdmLoc=$p($g(^PAADM(xEpisodeID)),"^",4)
			Set AdmHosp=$p($g(^CTLOC(+AdmLoc)),"^",22)
			Continue:(AdmHosp'="")&&(AdmHosp'=HospitalID)
			Set EpisodeID=xEpisodeID
		}
	} ElseIf MedType="E" {
		Set xEpisodeID=""
		For {
			Set xEpisodeID=$o(^PAPERdr(PatientID,"ADM","E",xEpisodeID),-1)
			Quit:xEpisodeID=""
			Quit:EpisodeID'=""
			
			Set AdmLoc=$p($g(^PAADM(xEpisodeID)),"^",4)
			Set AdmHosp=$p($g(^CTLOC(+AdmLoc)),"^",22)
			Continue:(AdmHosp'="")&&(AdmHosp'=HospitalID)
			Set EpisodeID=xEpisodeID
		}
	} Else {}
	Set ErrMsg="-3:就诊号不存在"
	Quit:EpisodeID="" return
	
	Set MrNo=..IGetMrNoByEpisodeID(EpisodeID,MedType,.ErrMsg)
	Quit:MrNo="" return
	
	Set ErrMsg="",return=MrNo
	Quit return
	
IGetMrNoByPatientIDError
     Set ErrMsg="-999:"_$ZE
     Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-03-17
/// NUM: 04
/// Description:  病案号取病人ID
/// Table：       DHC_WMR_Main,DHC_WMR_MainVolume
/// Input：       MrNo ：病案号
///               MedType   ：门诊（O）、急诊（E）、住院（I）
/// w ##Class(DHCWMR.IO.OutService).IGetPatientIDByMrNo("000113","I","",.ErrMsg)
ClassMethod IGetPatientIDByMrNo(MrNo As %String, MedType As %String, HospitalID As %String = "", ByRef ErrMsg As %String) As %String
{
	New (MrNo,MedType,HospitalID,ErrMsg)
	
	// 版本判断
	Set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	If MRSVersion=3 {
		Set return=##class(DHCWMR.IO.ToOutService).IGetPatientIDByMrNo(MrNo,MedType,HospitalID,.ErrMsg)
		Quit return
	}ElseIf $e(MRSVersion,0,1)="4" {
		Set return=##class(MA.IPMR.IO.OutService).GetPatientIDByMrNo(MrNo,MedType,.ErrMsg)
		Quit return
	}
	
	Set return="",ErrMsg="-1:参数错误"
	Quit:(MrNo="")||(MedType="") return
	
	//暂时未处理集团化医院情况
	Set HospitalID=$g(HospitalID)
	
	Set $ZT="IGetPatientIDByMrNoError"
	
	Set MrType=""
	If MedType="I" {
		Set xMrType=0
		For {
			Set xMrType=$O(^DHCWMRMAIN(0,"TypeNO",xMrType))
			Quit:xMrType=""
			
			Continue:'$d(^DHCWMRDIC(xMrType))
			Set MrTypeDesc=$p($g(^DHCWMRDIC(xMrType)),"^",3)
			Continue:MrTypeDesc'["住院"
			Set MrType=xMrType
		}
	} ElseIf MedType="O" {
		Set xMrType=0
		For {
			Set xMrType=$O(^DHCWMRMAIN(0,"TypeNO",xMrType))
			Quit:xMrType=""
			
			Continue:'$d(^DHCWMRDIC(xMrType))
			Set MrTypeDesc=$p($g(^DHCWMRDIC(xMrType)),"^",3)
			Continue:MrTypeDesc'["门诊"
			Set MrType=xMrType
		}
	} ElseIf MedType="E" {
		Set xMrType=0
		For {
			Set xMrType=$O(^DHCWMRMAIN(0,"TypeNO",xMrType))
			Quit:xMrType=""
			
			Continue:'$d(^DHCWMRDIC(xMrType))
			Set MrTypeDesc=$p($g(^DHCWMRDIC(xMrType)),"^",3)
			Continue:MrTypeDesc'["急诊"
			Set MrType=xMrType
		}
	} Else {}
	Set ErrMsg="-2:病案类型不存在"
	Quit:MrType="" return
	
	Set PatientID=""
	Set LeadingFactor=##class(web.DHCWMRGroup.DHCWMRGroupReceipt).GetLeadingFactor(MrType)
	If $ZCVT(LeadingFactor,"U")="V" {
		Set xVolID=""
		For {
			Set xVolID=$o(^DHCWMRVOL(0,"VolNo",MrNo,"Y",xVolID),-1)
			Quit:xVolID=""
			Quit:PatientID'=""
			
			Set IsActive=$p($g(^DHCWMRVOL(xVolID)),"^",7)
			Continue:IsActive'="Y"
			
			Set MainID=$p($g(^DHCWMRVOL(xVolID)),"^",1)
			Set IsActive=$p($g(^DHCWMRMAIN(+MainID)),"^",6)
			Continue:IsActive'="Y"
			Set tmpMrType=$p($g(^DHCWMRMAIN(+MainID)),"^",1)
			Continue:tmpMrType'=MrType
			
			Set PatientID=$p($g(^DHCWMRMAIN(+MainID)),"^",3)
		}
	} Else {
		Set xMainID=""
		For {
			Set xMainID=$o(^DHCWMRMAIN(0,"TypeNO",MrType,MrNo,xMainID),-1)
			Quit:xMainID=""
			Quit:PatientID'=""
			
			Set IsActive=$p($g(^DHCWMRMAIN(xMainID)),"^",6)
			Continue:IsActive'="Y"
			Set PatientID=$p($g(^DHCWMRMAIN(xMainID)),"^",3)
		}
	}
	Set ErrMsg="-3:病人ID不存在"
	Quit:PatientID="" return
	
	Set ErrMsg="",return=PatientID
	Quit return
	
IGetPatientIDByMrNoError
    Set ErrMsg="-999:"_$ZE
    Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-03-17
/// NUM: 05
/// Description:  就诊号(分娩记录)取新生儿病案号接口
/// Table：       DHC_WMR_Main,DHC_WMR_MainVolume
/// Input：       aEpisodeID ：就诊号
/// w ##Class(DHCWMR.IO.OutService).GetNewBabyMrNo(145)
ClassMethod GetNewBabyMrNo(aEpisodeID As %String, ByRef ErrMsg As %String) As %String
{
	New (aEpisodeID,ErrMsg)
	
	// 版本判断
	Set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	If MRSVersion=3 {
		Set return=##class(DHCWMR.IO.ToOutService).GetNewBabyMrNo(aEpisodeID,"")
		Quit return
	}ElseIf $e(MRSVersion,0,1)="4" {
		Set return=##Class(MA.IPMR.IO.OutService).GetNewBabyMrNo(aEpisodeID)
		Quit return
	}
	
	Set MrNo=""
	Quit:aEpisodeID="" MrNo
	
	//母亲分娩记录对应就诊号
	Set PatientID=$p($g(^PAADM(aEpisodeID)),"^",1)
	Set MotherDr=$p($g(^PAADM(aEpisodeID)),"^",75)
	Quit:MotherDr="" MrNo
	Set MotherPatID=$p($g(^PAADM(MotherDr)),"^",1)
	
	Set MotherMrNo=""
	Set xVolID=0
	For {
		Set xVolID=$o(^DHCWMRVOL(0,"PaadmDr",MotherDr,xVolID))
		Quit:xVolID=""
		Quit:MotherMrNo'=""
		
		Set IsActive=$p($g(^DHCWMRVOL(xVolID)),"^",7)
		Continue:IsActive'="Y"
		Set MainID=+$p($g(^DHCWMRVOL(xVolID)),"^",1)
		Set IsActive=$p($g(^DHCWMRMAIN(MainID)),"^",6)
		Continue:IsActive'="Y"
		
		Set MotherMrNo=$p($g(^DHCWMRMAIN(MainID)),"^",2)
	}
	Quit:MotherMrNo="" MrNo
	
	//^PAPERdr({PAADM_PAPMI_DR},"ADM",{PAADM_Type},{PAADM_RowID})
	Set BabyPatList=""
	Set xMotherAdmID=""
	For {
		Set xMotherAdmID=$o(^PAPERdr(MotherPatID,"ADM","I",xMotherAdmID))
		Quit:xMotherAdmID=""
		Quit:MrNo'=""
		
		Set VisitStatus=$p($g(^PAADM(xMotherAdmID)),"^",20)
		Continue:VisitStatus="C"  //取消就诊
		
		Set xEpisodeID=""
		For {
			Set xEpisodeID=$o(^PAADMi("Mother",xMotherAdmID,xEpisodeID))
			Quit:xEpisodeID=""
			Quit:MrNo'=""
			
			//Set VisitStatus=$p($g(^PAADM(xEpisodeID)),"^",20)
			//Continue:VisitStatus="C"  //取消就诊
			Set MotherDr=$p($g(^PAADM(xEpisodeID)),"^",75)
			Continue:MotherDr=""      //非分娩记录全部过滤掉
			
			Set PatientDr=$p($g(^PAADM(xEpisodeID)),"^",1)
			Continue:$listfind(BabyPatList,PatientDr)>0
			Set BabyPatList=BabyPatList_$lb(PatientDr)
			Continue:PatientDr'=PatientID
			
			Set Number=$listfind(BabyPatList,PatientID)
			Set MrNo=MotherMrNo_$e("ABCDEFGHIJKLMN",Number,Number)
		}
	}
	
	Quit MrNo
}

/// Creator：     zhufei
/// CreatDate：   2014-12-30
/// NUM: 06
/// Description:  就诊对应第几次住院
/// Input：       EpisodeID : 就诊号
/// Return：      返回String
/// w ##class(DHCWMR.IO.OutService).IGetIPTimes(394)
ClassMethod IGetIPTimes(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=-1
	Quit:aEpisodeID="" return
	// 版本判断
	Set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	If MRSVersion=3 {
		Set return=##class(DHCWMR.SSService.VolumeSrv).GetIPTimes(aEpisodeID)
	}ElseIf $e(MRSVersion,0,1)="4"{
		Set return=##class(MA.IPMR.IO.OutService).GetIPTimes(aEpisodeID)
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-12-30
/// NUM: 07
/// Description:  根据病案号查询住院次数
/// Input：       MrTypeID : 病案类型,V4需传号码类型
///               MrNo : 病案号
/// Return：      返回String
/// w ##class(DHCWMR.IO.OutService).IGetIPCount("7||1","000113")
ClassMethod IGetIPCount(aMrTypeID As %String, aMrNo As %String) As %String
{
	New (aMrTypeID,aMrNo)
	Set return=-1
	Quit:(aMrTypeID="")||(aMrNo="") return
	// 版本判断
	Set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	If MRSVersion=3 {
		Set return=##class(DHCWMR.SSService.VolumeSrv).GetIPCount(aMrTypeID,aMrNo)
	}ElseIf $e(MRSVersion,0,1)="4"{
		Set NoType=aMrTypeID
		Set return=##class(MA.IPMR.IO.OutService).GetIPCount(aMrNo)	
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-12-08
/// NUM: 10
/// Description:  取病案编目(诊断、手术)接口方法
/// Table：       DHCWMR.FP.FrontPage
/// Input：       EpisodeID:就诊号
///               GetType:类型
///               -------:诊断(D/1:主要诊断、D/2:次要诊断、D/3:医院感染诊断、D/4:病理诊断、D/5:损伤中毒的外部因素、D/6:门急诊诊断、D/7:入院诊断)
///               -------:手术(O/1:手术、O/2:操作)
///               RowIndex:顺序号
///               FPCode:编目代码(主要是处理多次编目情况,指向工作流项目系统操作代码)
/// Return：      返回String
///               -------:诊断(ICD10_$c(2)_诊断描述_$c(2)_出院情况代码_$c(2)_出院情况描述_$c(2)_入院病情代码_$c(2)_入院病情描述_$c(2)_怀疑诊断代码_$c(2)_怀疑诊断描述_$c(2)_诊断类型代码)
///               -------:手术(ICD10_$c(2)_手术名称_$c(2)_手术操作日期_$c(2)_切口类型代码_$c(2)_切口类型_$c(2)_愈合情况代码_$c(2)_愈合情况_$c(2)_术者代码_$c(2)_术者_$c(2)_麻醉方式代码_$c(2)_麻醉方式_$c(2)_是否附加手术_$c(2)_1助代码_$c(2)_1助_$c(2)_2助代码_$c(2)_2助_$c(2)_麻醉医师代码_$c(2)_麻醉医师_$c(2)_手术级别代码_$c(2)_手术级别)
/// w ##class(DHCWMR.IO.OutService).IGetFrontPageICD(394,"D/1",1)
ClassMethod IGetFrontPageICD(aEpisodeID As %String, aGetType As %String, aRowIndex As %String = "1", aFPCode As %String = "F") As %String
{
	New (aEpisodeID,aGetType,aRowIndex,aFPCode)
	
	Set return=##class(DHCWMR.FPService.OutputSrv).GetFrontPageICD(aEpisodeID,aGetType,aRowIndex,aFPCode)
	if return="" {
		Set ICDType=$p(aGetType,"/",1)
		Set ICDSubType=$p(aGetType,"/",2)
		Quit:(ICDType'="D")&&(ICDType'="O") return
		If (ICDType="D"){
			if ICDSubType=1 {
				set ICDSubType=3
			}elseif ICDSubType=2 {
				set ICDSubType=4
			}elseif ICDSubType=3 {
				set ICDSubType=6
			}elseif ICDSubType=4 {
				set ICDSubType=7
			}elseif ICDSubType=5 {
				set ICDSubType=5
			}elseif ICDSubType=6 {
				set ICDSubType=1
			}elseif ICDSubType=7 {
				set ICDSubType=2
			}
		}else{}
		set aGetType = ICDType_"/"_ICDSubType
		Set return = ##class(MA.IPMR.IO.OutService).GetICDByAdm(aEpisodeID,aGetType,aRowIndex)
		if (return'="") {
			If (ICDType="D"){
				Set TypeCode=$p(return,$c(2),9)
				if TypeCode=1 {
					set $p(return,$c(2),9)=6
				}elseif TypeCode=2 {
					set $p(return,$c(2),9)=7
				}elseif TypeCode=3 {
					set $p(return,$c(2),9)=1
				}elseif TypeCode=4 {
					set $p(return,$c(2),9)=2
				}elseif TypeCode=5 {
					set $p(return,$c(2),9)=5
				}elseif TypeCode=6 {
					set $p(return,$c(2),9)=3
				}elseif TypeCode=7 {
					set $p(return,$c(2),9)=4
				}
			}
		}
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-12-08
/// NUM: 11
/// Description:  取病案编目(诊断、手术)接口方法
/// Table：       DHCWMR.FP.FrontPage
/// Input：       EpisodeID:就诊号
///               GetType:类型
///               -------:诊断(D)
///               -------:手术(O/1:手术、O/2:操作)
///               RowIndex:顺序号
///               FPCode:编目代码(主要是处理多次编目情况,指向工作流项目系统操作代码)
/// Return：      返回String，多条记录$c(1)分隔 	  
///               -------:诊断(ICD10_$c(2)_诊断描述_$c(2)_出院情况代码_$c(2)_出院情况描述_$c(2)_入院病情代码_$c(2)_入院病情描述_$c(2)_怀疑诊断代码_$c(2)_怀疑诊断描述_$c(2)_诊断类型代码)
///               -------:手术(ICD10_$c(2)_手术名称_$c(2)_手术操作日期_$c(2)_切口类型代码_$c(2)_切口类型_$c(2)_愈合情况代码_$c(2)_愈合情况_$c(2)_术者代码_$c(2)_术者_$c(2)_麻醉方式代码_$c(2)_麻醉方式_$c(2)_是否附加手术_$c(2)_1助代码_$c(2)_1助_$c(2)_2助代码_$c(2)_2助_$c(2)_麻醉医师代码_$c(2)_麻醉医师_$c(2)_手术级别代码_$c(2)_手术级别)
/// Resume：	  诊断类型代码说明：1:主要诊断、2:次要诊断、3:医院感染诊断、4:病理诊断、5:损伤中毒的外部因素、6:门急诊诊断、7:入院诊断
/// w ##class(DHCWMR.IO.OutService).IGetFrontPageICDAll(394,"D")
ClassMethod IGetFrontPageICDAll(aEpisodeID As %String, aGetType As %String, aFPCode As %String = "F") As %String
{
	New (aEpisodeID,aGetType,aFPCode)
	// 版本判断
	Set return=##class(DHCWMR.FPService.OutputSrv).GetFrontPageICDAll(aEpisodeID,aGetType,aFPCode)
	if return="" {
		Set ICDType=$p(aGetType,"/",1)
		Set ICDSubType=$p(aGetType,"/",2)
		Quit:(ICDType'="D")&&(ICDType'="O") return
		If (ICDType="D"){
			if ICDSubType=1 {
				set ICDSubType=3
			}elseif ICDSubType=2 {
				set ICDSubType=4
			}elseif ICDSubType=3 {
				set ICDSubType=6
			}elseif ICDSubType=4 {
				set ICDSubType=7
			}elseif ICDSubType=5 {
				set ICDSubType=5
			}elseif ICDSubType=6 {
				set ICDSubType=1
			}elseif ICDSubType=7 {
				set ICDSubType=2
			}
		}else{}
		If ICDSubType'="" {
			set aGetType = ICDType_"/"_ICDSubType
		}
		Set return = ##class(MA.IPMR.IO.OutService).GetICDAllByAdm(aEpisodeID,aGetType)
		Set ret = ""
		if (return'="") {
			For xind = 1:1:$length(return,$c(1)) {
				Set ICDStr = $p(return,$c(1),xind)
				If (ICDType="D"){
					Set TypeCode=$p(ICDStr,$c(2),9)
					if TypeCode=1 {
						set $p(ICDStr,$c(2),9)=6
					}elseif TypeCode=2 {
						set $p(ICDStr,$c(2),9)=7
					}elseif TypeCode=3 {
						set $p(ICDStr,$c(2),9)=1
					}elseif TypeCode=4 {
						set $p(ICDStr,$c(2),9)=2
					}elseif TypeCode=5 {
						set $p(ICDStr,$c(2),9)=5
					}elseif TypeCode=6 {
						set $p(ICDStr,$c(2),9)=3
					}elseif TypeCode=7 {
						set $p(ICDStr,$c(2),9)=4
					}
				}
				Set ret = $s(ret="":ICDStr,1:ret_$c(1)_ICDStr)
			}
		}
		Set return = ret
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-03-17
/// NUM: 12
/// Description:  根据EpisodeID取卷ID
/// Table：       DHCWMR.SS.Volume、DHCWMR.SS.VolPaadm
/// Input：       EpisodeID ：就诊号
/// Return：      返回String
/// w ##class(DHCWMR.IO.OutService).IGetVolumeID(394)
ClassMethod IGetVolumeID(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	
	// 版本判断
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		Set objVol=##Class(DHCWMR.SS.Volume).GetObjByPaadm(aEpisodeID)
	}ElseIf $e(MRSVersion,0,1)="4" {
		Set volID = ##class(MA.IPMR.IO.OutService).GetVolumeID(aEpisodeID)
	}
	
	Set return=volID
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2016-03-25
/// NUM: 13
/// Description:  通过就诊ID取病历编目日期
/// Table：       DHCWMR.FP.FrontPage
/// Input：       aEpisodeID ：就诊ID
/// Return：      返回String
///               未编目：0^
/// 				  已编目：1^编目日期
/// Debug：w ##class(DHCWMR.IO.OutService).IGetFrontpageInfo(394)
ClassMethod IGetFrontpageInfo(aEpisodeID As %String, ByRef ErrMsg As %String) As %String
{
	New (aEpisodeID,ErrMsg)
	Set return="",ErrMsg="-1:参数错误"
	Quit:aEpisodeID="" return
	
	Set $ZT="GetFrontpageInfoErr"
	// 版本判断
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		Set ErrMsg="-2:程序错误"
		Set objFrontPage=##class(DHCWMR.FPService.FrontPageSrv).GetFPObjByAdm(aEpisodeID)
		If $isobject(objFrontPage) {
			Set BuildDate=objFrontPage.FPBuildDate
			Set return=1_"^"_$zd(BuildDate,3)
		} Else {
			Set return=0_"^"
		}
	}ElseIf $e(MRSVersion,0,1)="4"{
		Set return=##class(MA.IPMR.IO.OutService).GetFrontpageInfo(aEpisodeID)
		Set:return'="0^" return=$p(return,"^",1)_"^"_$p(return,"^",2)
	}
	Quit return
	
GetFrontpageInfoErr
    Set ErrMsg="-999:"_$ZE
    Quit return
}

/// Creator：     mxp
/// CreatDate：   2017-07-06
/// NUM: 14
/// Description:  通过就诊ID取病历编目人员、编目日期
/// Table：       DHCWMR.FP.FrontPage
/// Input：       aEpisodeID ：就诊ID
/// Return：      已编目：编码员ID^Name^编码日期
/// 			  未编目：空
/// Debug：w ##class(DHCWMR.IO.OutService).IGetFPBuildInfo(394)
ClassMethod IGetFPBuildInfo(aEpisodeID As %String, ByRef ErrMsg As %String) As %String
{
	New (aEpisodeID,ErrMsg)
	Set return="",ErrMsg="-1:参数错误"
	Quit:aEpisodeID="" return
	
	Set $ZT="IGetFPBuildInfoErr"
	// 版本判断
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		Set ErrMsg="-2:程序错误"
		Set objFrontPage=##class(DHCWMR.FPService.FrontPageSrv).GetFPObjByAdm(aEpisodeID)
		If $isobject(objFrontPage) {
			Set BuildUser = objFrontPage.FPBuildUser
			Set Name = $p($g(^SSU("SSUSR",+BuildUser)),"^",2)
			Set BuildDate = objFrontPage.FPBuildDate
			Set return = BuildUser_"^"_Name_"^"_$zd(BuildDate,3)
		}
	}ElseIf $e(MRSVersion,0,1)="4" {
		Set return=##class(MA.IPMR.IO.OutService).GetFrontpageInfo(aEpisodeID)
		Set:return="0^" return=""
		If return="0^"{
			Set return=""
		}Else{
			Set BuildUser	= "" // $p(return,"^",4)
			Set Name		= $p(return,"^",4)
			Set BuildDate	= $p(return,"^",2)
			Set return = BuildUser_"^"_Name_"^"_BuildDate
		}
	}
	Quit return
	
IGetFPBuildInfoErr
    Set ErrMsg="-999:"_$ZE
    Quit return
}

/*************************************以下接口未兼容V4**************************************/
/// Creator：     zhufei
/// CreatDate：   2015-01-12
/// NUM: 08
/// Description:  取编目就诊记录（To统计组）
/// Table：       DHCWMR.FP.FrontPage
/// Input：       InputStr ：查询日期（编目日期）^开始时间^开始ID^空^空^截止日期^截止时间
/// Return：      返回String
///               查询日期（编目日期）^结束日期^结束ID^完成标志(1:完成，0:未完成)^就诊号字符串(英文逗号分隔)^截止日期^截止时间
/// Set ErrMsg=""
/// w ##class(DHCWMR.IO.OutService).IGetFPCodingAdms("",.ErrMsg)
/// w ErrMsg	; 查看信息
ClassMethod IGetFPCodingAdms(aInputStr As %String, ByRef ErrMsg As %String = "") As %String
{
	New (aInputStr,ErrMsg)
	Set return=""
	
	// 版本判断
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		set return=##class(DHCWMR.IO.ToOutService).IGetFPCodingAdms(aInputStr,ErrMsg)
		quit return
	}ElseIf $e(MRSVersion,0,1)="4" {
		Set ErrMsg="请使用新接口MA.IPMR.IO.OutService.cls : GetEpisodeList"
	}
	
    Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-03-17
/// NUM: 09
/// Description:  取病案操作对应就诊记录（To平台组）
/// Table：       DHCWMR.SS.Operation、DHCWMR.SS.Volume、DHCWMR.SS.VolStatus
/// Input：       InputStr ：查询日期（操作日期）^开始时间^开始ID^空^空^截止日期^截止时间
///               MrClass : 病案分类代码
///               SysOperCode : 系统操作代码
///               HospitalID : 医院ID
/// Return：      返回String
///               查询日期（操作日期）^结束日期^结束ID^完成标志(1:完成，0:未完成)^就诊号字符串(英文逗号分隔)^截止日期^截止时间
/// w ##class(DHCWMR.IO.OutService).IGetMrOperaAdms()
ClassMethod IGetMrOperaAdms(aInputStr As %String, aMrClass As %String, aSysOperCode As %String, aHospitalID As %String = "", ByRef ErrMsg As %String = "") As %String
{
	New (aInputStr,aMrClass,aSysOperCode,aHospitalID,ErrMsg)
	Set return=""
	
	// 版本判断
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		set return=##class(DHCWMR.IO.ToOutService).IGetFPCodingAdms(aInputStr,aMrClass,aSysOperCode,aHospitalID,ErrMsg)
		quit return
	}ElseIf $e(MRSVersion,0,1)="4"{
		Set ErrMsg="暂无..."
	}
	
    Quit return
}

/**********************************************
/// 以下为部分接口调用实例
/// 
/// 1 循环调用病案编目记录调用实例
for mDate=stdata:1:enddata {
	set $p(strInput,"^",1)=mDate
	set $p(strInput,"^",2)=$s(mDate=stdata:sttime,1:0)
	set $p(strInput,"^",3)=0
	set $p(strInput,"^",4)=""
	set $p(strInput,"^",5)=""
	set $p(strInput,"^",6)=enddata
	set $p(strInput,"^",7)=endtime
	for {
		set strOutput=##class(DHCWMR.IO.OutService).IGetFPCodingAdms(strInput,"")
		quit:strOutput=""
		set IsFinish=+$p(strOutput,"^",4)
		set AdmList=$p(strOutput,"^",5)
		quit:AdmList=""
		for indAdm=1:1:$l(AdmList,",") {
			set admdr=$p(AdmList,",",indAdm)
			continue:admdr=""
			//就诊号
		}
		quit:IsFinish=1
		set $p(strInput,"^",1)=$p(strOutput,"^",1)
		set $p(strInput,"^",2)=$p(strOutput,"^",2)
		set $p(strInput,"^",3)=$p(strOutput,"^",3)
		set $p(strInput,"^",4)=""
		set $p(strInput,"^",5)=""
		set $p(strInput,"^",6)=$p(strOutput,"^",6)
		set $p(strInput,"^",7)=$p(strOutput,"^",7)
	}
}

/// 2 循环调用病案操作记录调用实例
for mDate=stdata:1:enddata {
	set $p(strInput,"^",1)=mDate
	set $p(strInput,"^",2)=$s(mDate=stdata:sttime,1:0)
	set $p(strInput,"^",3)=0
	set $p(strInput,"^",4)=""
	set $p(strInput,"^",5)=""
	set $p(strInput,"^",6)=enddata
	set $p(strInput,"^",7)=endtime
	for {
		set strOutput=##class(DHCWMR.IO.OutService).IGetMrOperaAdms(strInput,"I","RC","","")
		quit:strOutput=""
		set IsFinish=+$p(strOutput,"^",4)
		set AdmList=$p(strOutput,"^",5)
		quit:AdmList=""
		for indAdm=1:1:$l(AdmList,",") {
			set admdr=$p(AdmList,",",indAdm)
			continue:admdr=""
			//就诊号
		}
		quit:IsFinish=1
		set $p(strInput,"^",1)=$p(strOutput,"^",1)
		set $p(strInput,"^",2)=$p(strOutput,"^",2)
		set $p(strInput,"^",3)=$p(strOutput,"^",3)
		set $p(strInput,"^",4)=""
		set $p(strInput,"^",5)=""
		set $p(strInput,"^",6)=$p(strOutput,"^",6)
		set $p(strInput,"^",7)=$p(strOutput,"^",7)
	}
}

/// 3 病人ID取病案号接口调用实例
s MrNo=##Class(DHCWMR.IO.OutService).IGetPatientIDByMrNo(PAPMIID,"I","","")
**********************************************/
}
