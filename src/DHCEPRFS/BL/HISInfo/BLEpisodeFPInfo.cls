Class DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo Extends %RegisteredObject [ ProcedureBlock ]
{

ClassMethod GetPatientID(AEpisodeID As %String) As %String
{
	q:(AEpisodeID="") ""
	s retValue = $P($g(^PAADM(AEpisodeID)),"^",1)
	q:(retValue '= "") retValue

	//华西医院：global节点中的数据丢失，但sql语句可以查询出数据
	&sql(select PAADM_PAPMI_DR into :retValue from SQLUser.PA_Adm where PAADM_RowId = :argAdmId)
	q retValue
}

/// Type:0 rowid 1 code 2 desc 3 curestatus
ClassMethod GetDiagMain(AEpisodeID As %String, Type As %String) As %String
{
	q:(AEpisodeID="") ""
	s Diagnose = ##Class(web.DHCWMRCodingInterface).getFrontPageICD(AEpisodeID,"D/1",1)
	s retValue = ..GetValByType(Diagnose,Type)
	
	q retValue
}

/// Type:0 rowid 1 code 2 desc 3 curestatus
ClassMethod GetDiag01(AEpisodeID As %String, Type As %String) As %String
{
	q:(AEpisodeID="") ""
	s Diagnose = ##Class(web.DHCWMRCodingInterface).getFrontPageICD(AEpisodeID,"D/2",1)
	s retValue = ..GetValByType(Diagnose,Type)
	
	q retValue
}

/// Type:0 rowid 1 code 2 desc 3 curestatus
ClassMethod GetDiag02(AEpisodeID As %String, Type As %String) As %String
{
	q:(AEpisodeID="") ""
	s Diagnose = ##Class(web.DHCWMRCodingInterface).getFrontPageICD(AEpisodeID,"D/2",2)
	s retValue = ..GetValByType(Diagnose,Type)
	
	q retValue
}

/// Type:0 rowid 1 code 2 desc 3 curestatus
ClassMethod GetDiag03(AEpisodeID As %String, Type As %String) As %String
{
	q:(AEpisodeID="") ""
	s Diagnose = ##Class(web.DHCWMRCodingInterface).getFrontPageICD(AEpisodeID,"D/2",3)
	s retValue = ..GetValByType(Diagnose,Type)
	
	q retValue
}

/// Type:0 rowid 1 code 2 desc 3 curestatus
ClassMethod GetDiag04(AEpisodeID As %String, Type As %String) As %String
{
	q:(AEpisodeID="") ""
	s Diagnose = ##Class(web.DHCWMRCodingInterface).getFrontPageICD(AEpisodeID,"D/2",4)
	s retValue = ..GetValByType(Diagnose,Type)
	
	q retValue
}

/// Type:0 rowid 1 code 2 desc 3 curestatus
ClassMethod GetDiag05(AEpisodeID As %String, Type As %String) As %String
{
	q:(AEpisodeID="") ""
	s Diagnose = ##Class(web.DHCWMRCodingInterface).getFrontPageICD(AEpisodeID,"D/2",5)
	s retValue = ..GetValByType(Diagnose,Type)
	
	q retValue
}

/// Type:0 rowid 1 code 2 desc 3 curestatus
ClassMethod GetDiag06(AEpisodeID As %String, Type As %String) As %String
{
	q:(AEpisodeID="") ""
	s Diagnose = ##Class(web.DHCWMRCodingInterface).getFrontPageICD(AEpisodeID,"D/2",6)
	s retValue = ..GetValByType(Diagnose,Type)
	
	q retValue
}

/// Type:0 rowid 1 code 2 desc 3 curestatus
ClassMethod GetDiag07(AEpisodeID As %String, Type As %String) As %String
{
	q:(AEpisodeID="") ""
	s Diagnose = ##Class(web.DHCWMRCodingInterface).getFrontPageICD(AEpisodeID,"D/2",7)
	s retValue = ..GetValByType(Diagnose,Type)
	
	q retValue
}

/// Type:0 rowid 1 code 2 desc 3 curestatus
ClassMethod GetDiag08(AEpisodeID As %String, Type As %String) As %String
{
	q:(AEpisodeID="") ""
	s Diagnose = ##Class(web.DHCWMRCodingInterface).getFrontPageICD(AEpisodeID,"D/2",8)
	s retValue = ..GetValByType(Diagnose,Type)
	
	q retValue
}

/// Type:0 rowid 1 code 2 desc 3 curestatus
ClassMethod GetDiag09(AEpisodeID As %String, Type As %String) As %String
{
	q:(AEpisodeID="") ""
	s Diagnose = ##Class(web.DHCWMRCodingInterface).getFrontPageICD(AEpisodeID,"D/2",9)
	s retValue = ..GetValByType(Diagnose,Type)
	
	q retValue
}

/// Type:0 rowid 1 code 2 desc 3 curestatus
ClassMethod GetDiag10(AEpisodeID As %String, Type As %String) As %String
{
	q:(AEpisodeID="") ""
	s Diagnose = ##Class(web.DHCWMRCodingInterface).getFrontPageICD(AEpisodeID,"D/2",10)
	s retValue = ..GetValByType(Diagnose,Type)
	
	q retValue
}

// ##Class(web.DHCWMRCodingInterface).getFrontPageICD(Adm,"D/6",1)

ClassMethod GetDiagOut(AEpisodeID As %String, Type As %String) As %String
{
	q:(AEpisodeID="") ""
	s Diagnose = ##Class(web.DHCWMRCodingInterface).getFrontPageICD(AEpisodeID,"D/6",1)
	s retValue = ..GetValByType(Diagnose,Type)
	
	q retValue
}

ClassMethod GetDiagAdm(AEpisodeID As %String, Type As %String) As %String
{
	q:(AEpisodeID="") ""
	s Diagnose = ##Class(web.DHCWMRCodingInterface).getFrontPageICD(AEpisodeID,"D/7",1)
	s retValue = ..GetValByType(Diagnose,Type)
	
	q retValue
}

ClassMethod GetDiagPath(AEpisodeID As %String, Type As %String) As %String
{
	q:(AEpisodeID="") ""
	s Diagnose = ##Class(web.DHCWMRCodingInterface).getFrontPageICD(AEpisodeID,"D/3",1)
	s retValue = ..GetValByType(Diagnose,Type)
	
	q retValue
}

ClassMethod GetAdmState(AEpisodeID As %String) As %String
{
	q:(AEpisodeID="") ""
	s GlossaryObj = ##Class(EPRservice.BOScatterData).GetDataByGlossaryCategory(AEpisodeID,"HDSD00.11")
	s retValue = GlossaryObj.GetAt("HDSD00.11.884")
	
	q retValue
}

ClassMethod GetValByType(DiagStr As %String, Type As %String) As %String
{
	q:(DiagStr="") ""
	
	if (Type="0")
	{
		s retValue = $p($g(DiagStr),$c(2),1)
	}
	elseif (Type="1")
	{
		s retValue = $p($g(DiagStr),$c(2),1)
	}
	elseif (Type="2")
	{
		s retValue = $p($g(DiagStr),$c(2),2)
	}
	elseif (Type="3")
	{
		s retValue = $p($g(DiagStr),$c(2),3)
	}
	else
	{
		s retValue = ""
		}
	
	q retValue
}

/// Type:0 rowid 1 code 2 desc 3 curestatus
ClassMethod GetOper01(AEpisodeID As %String, Type As %String) As %String
{
	q:(AEpisodeID="") ""
	s Operation = ##Class(web.DHCWMRCodingInterface).getFrontPageICD(AEpisodeID,"O/1",1)
	s retValue = ..GetOperValByType(Operation,Type)
	
	q retValue
}

ClassMethod GetOper02(AEpisodeID As %String, Type As %String) As %String
{
	q:(AEpisodeID="") ""
	s Operation = ##Class(web.DHCWMRCodingInterface).getFrontPageICD(AEpisodeID,"O/1",2)
	s retValue = ..GetOperValByType(Operation,Type)
	
	q retValue
}

ClassMethod GetOper03(AEpisodeID As %String, Type As %String) As %String
{
	q:(AEpisodeID="") ""
	s Operation = ##Class(web.DHCWMRCodingInterface).getFrontPageICD(AEpisodeID,"O/1",3)
	s retValue = ..GetOperValByType(Operation,Type)
	
	q retValue
}

ClassMethod GetOper04(AEpisodeID As %String, Type As %String) As %String
{
	q:(AEpisodeID="") ""
	s Operation = ##Class(web.DHCWMRCodingInterface).getFrontPageICD(AEpisodeID,"O/1",4)
	s retValue = ..GetOperValByType(Operation,Type)
	
	q retValue
}

ClassMethod GetOper05(AEpisodeID As %String, Type As %String) As %String
{
	q:(AEpisodeID="") ""
	s Operation = ##Class(web.DHCWMRCodingInterface).getFrontPageICD(AEpisodeID,"O/1",5)
	s retValue = ..GetOperValByType(Operation,Type)
	
	q retValue
}

ClassMethod GetOper06(AEpisodeID As %String, Type As %String) As %String
{
	q:(AEpisodeID="") ""
	s Operation = ##Class(web.DHCWMRCodingInterface).getFrontPageICD(AEpisodeID,"O/1",6)
	s retValue = ..GetOperValByType(Operation,Type)
	
	q retValue
}

ClassMethod GetOper07(AEpisodeID As %String, Type As %String) As %String
{
	q:(AEpisodeID="") ""
	s Operation = ##Class(web.DHCWMRCodingInterface).getFrontPageICD(AEpisodeID,"O/1",7)
	s retValue = ..GetOperValByType(Operation,Type)
	
	q retValue
}

ClassMethod GetOper08(AEpisodeID As %String, Type As %String) As %String
{
	q:(AEpisodeID="") ""
	s Operation = ##Class(web.DHCWMRCodingInterface).getFrontPageICD(AEpisodeID,"O/1",8)
	s retValue = ..GetOperValByType(Operation,Type)
	
	q retValue
}

ClassMethod GetDPDiagnose(AEpisodeID As %String, Type As %String) As %String
{
	q:(AEpisodeID="") ""
	s Diagnose = ##Class(web.DHCWMRCodingInterface).getFrontPageICD(AEpisodeID,"D/DPDiagnose",1)
	s retValue = ..GetValByType(Diagnose,Type)
	
	q retValue
}

/// Type:0 operid 1 opercode 2 operdesc 3 operlevel 4 operdate
///     5 operdocid 6 operdocname 7 OperAssist1ID 8 OperAssist1name 9 OperAssist2ID
///     10 OperAssist2name 11 OperCutLevel 12 OperAnaMethod 13 OperAnaDocID 14 OperAnaDocName
ClassMethod GetOperValByType(OperStr As %String, Type As %String) As %String
{
	q:(OperStr="") ""
	
	if (Type="0")
	{
		//0 operid
		s retValue = $p($g(OperStr),$c(2),1)
	}
	elseif (Type="1")
	{
		//1 opercode
		s retValue = $p($g(OperStr),$c(2),1)
	}
	elseif (Type="2")
	{
		//2 operdesc
		s retValue = $p($g(OperStr),$c(2),2)
	}
	elseif (Type="3")
	{
		//3 operlevel
		s retValue = $p($g(OperStr),$c(2),10)
	}
	elseif (Type="4")
	{
		//4 operdate
		s retValue = $p($g(OperStr),$c(2),3)
	}
	elseif (Type="5")
	{
		//5 operdocid
		s retValue = $p($g(OperStr),$c(2),4)
	}
	elseif (Type="6")
	{
		//6 operdocname
		s retValue = $p($g(OperStr),$c(2),4)
	}
	elseif (Type="7")
	{
		//7 OperAssist1ID
		s retValue = $p($g(OperStr),$c(2),5)
	}
	elseif (Type="8")
	{
		//8 OperAssist1name
		s retValue = $p($g(OperStr),$c(2),5)
	}
	elseif (Type="9")
	{
		//9 OperAssist2ID
		s retValue = $p($g(OperStr),$c(2),6)
	}
	elseif (Type="10")
	{
		//10 OperAssist2name
		s retValue = $p($g(OperStr),$c(2),6)
	}
	elseif (Type="11")
	{
		//11 OperCutLevel
		s retValue = $p($g(OperStr),$c(2),8)
	}
	elseif (Type="12")
	{
		//12 OperAnaMethod
		s retValue = $p($g(OperStr),$c(2),7)
	}
	elseif (Type="13")
	{
		//13 OperAnaDocID
		s retValue = $p($g(OperStr),$c(2),9)
	}
	elseif (Type="14")
	{
		//14 OperAnaDocName
		s retValue = $p($g(OperStr),$c(2),9)
	}
	else
	{
		s retValue = ""
		}
	
	q retValue
}

// *******************************新增**********************************************

/// 根据诊断信息、编目类型、顺序号 获取信息
/// 入参：aDiagInfo诊断信息串##class(DHCWMR.IO.OutService).IGetFrontPageICDAll(EpisodeID,"D")
/// 		 aType类型 1主要诊断、2次要诊断、3医院感染诊断、4:病理诊断、5:损伤中毒诊断、6:门急诊诊断、7:入院诊断、8:肿瘤编码
/// 		 aInd顺序号 默认空，数字表示为第几条记录
/// 出参：诊断返回值 ICD10 $c(2) 诊断描述 $c(2) 出院情况
ClassMethod GetFPInfoByTypecode(aDiagInfo As %String, aType As %String, aInd As %String = "1")
{
	Set ret = ""
	Set DiagStr=""
	For ind=1:1:$l(aDiagInfo,$c(1)) {
		Set tDiagnosStr=$p(aDiagInfo,$c(1),ind)
		Continue:tDiagnosStr=""
		/*
		Set ICD10=$p(tDiagnosStr,$c(2),1)
		Set ICDDesc=$p(tDiagnosStr,$c(2),2)
		Set FPDDischCondCode=$p(tDiagnosStr,$c(2),3)
		Set FPDDischCond=$p(tDiagnosStr,$c(2),4)
		Set FPDAdmitCondCode=$p(tDiagnosStr,$c(2),5)
		Set FPDAdmitCond=$p(tDiagnosStr,$c(2),6)
		*/
		Set FPDTypeCode=$p(tDiagnosStr,$c(2),9)
		
		if (FPDTypeCode = aType)
		{
			if (ret = "")
			{
				s ret = tDiagnosStr
			}
			else
			{
				s ret = ret_$c(1)_tDiagnosStr
			}
		}
	}
	Set ret=$p(ret,$c(1),aInd)

	q ret
}

}
