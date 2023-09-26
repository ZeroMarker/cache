Class DHCEPRFS.BL.BLMREpisodeFee Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// debug: s entity = ##Class(DHCEPRFS.BL.BLMREpisodeFee).CreateEMREpisodeFeeDHC("update","1","5742458","DHC")
ClassMethod CreateEMREpisodeFeeDHC(AType As %String, AMRPatientID As %String, AEpisodeID As %String, ASysCode As %String) As DHCEPRFS.Entity.EMREpisodeFee
{
	//b "s"
	s entity = ##Class(DHCEPRFS.Entity.EMREpisodeFee).%New()
	// 02 系统标识号
	s entity.MREpisodeID = ##class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm(AEpisodeID,ASysCode)
	//w !,"2:entity.MREpisodeID: "_entity.MREpisodeID
	// 03 病人标识号
	s entity.MRPatientID = AMRPatientID
	//w !,"3:entity.MRPatientID: "_entity.MRPatientID
	// 04 医疗组织机构代码
	s entity.CompanyCode = ""
	//w !,"4:entity.CompanyCode: "_entity.CompanyCode
	if (AType = "create")
	{
		s entity.CreateDate = $p($h,",",1)  
		s entity.CreateTime = $p($h,",",2)  //06
	}
	else
	{
		s mrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxEpisodeID"," "_AMRPatientID, " "_ASysCode, " "_AEpisodeID, ""))
		s mrEpisodeFeeID = $o(^DHCEPRFS.INST.MREpisodeFeeI("IdxMREpisodeID"," "_mrEpisodeID,""))
		s:(mrEpisodeFeeID = $c(0)) mrEpisodeFeeID = ""
		if (mrEpisodeFeeID = "")
		{
			s entity.CreateDate = $p($h,",",1)  
			s entity.CreateTime = $p($h,",",2)  //06
		}
		else
		{
 			s obj = ##class(DHCEPRFS.INST.MREpisodeFee).%OpenId(mrEpisodeFeeID)
			s entity.CreateDate = obj.CreateDate 
			s entity.CreateTime = obj.CreateTime
			d obj.%Close()	
		}
	}
		//w !,"5:entity.CreateDate: "_entity.CreateDate
	//w !,"6:entity.CreateTime: "_entity.CreateTime
	// 07 最后修改日期
	s entity.LastModifyDate = $p($h,",",1)
	//w !,"7:entity.LastModifyDate: "_entity.LastModifyDate
	// 08 最后修改时间
	s entity.LastModifyTime = $p($h,",",2)
	//w !,"8:entity.LastModifyTime: "_entity.LastModifyTime	
	s InPatFee = ##class(DHCEPRFS.BL.HISInfo.BLFeeInfo).InPatCostTrakCareNew(AEpisodeID,"")
	s InPatSubFee = ##class(DHCEPRFS.BL.HISInfo.BLFeeInfo).InPatCostTrakCareSubNew(AEpisodeID,"")
	// 09 总费用 
	s entity.F00TotalFee = $P($P(InPatFee,"!",1),"^",3)
	/// 10 一般医疗服务费(01)
	s entity.F01YBYLFWF = $P($P(InPatFee,"!",33),"^",3)

	/// 11 一般治疗操作费(02)
	s entity.F02YBZLCZF = $P($P(InPatFee,"!",22),"^",3)
	
	/// 12 护理费(03)
	s entity.F03HLF = $P($P(InPatFee,"!",11),"^",3)
	
	/// 13 其他费用(04)
	s entity.F04QTFY = $P($P(InPatFee,"!",31),"^",3)
	
	/// 14 病理诊断费(05)
	s entity.F05BLZDF = $P($P(InPatFee,"!",8),"^",3)
	
	/// 15 实验室诊断费(06)
	s entity.F06SYSZDF = $P($P(InPatFee,"!",12),"^",3)
	
	/// 16 影像学诊断费(07)
	s entity.F07YXXZDF = $P($P(InPatFee,"!",9),"^",3)
	
	/// 17 临床诊断项目费(08)
	s entity.F08LCZDXMF = $P($P(InPatFee,"!",24),"^",3)
	
	/// 18 非手术治疗项目费(09)
	s entity.F09FSSZLF = $P($P(InPatFee,"!",19),"^",3)
	
	/// 19 手术治疗费(10)
	s entity.F10SSZLF = $P($P(InPatFee,"!",15),"^",3)
	
	/// 20 康复费(11)
	s entity.F11KFF = $P($P(InPatFee,"!",18),"^",3)
	
	/// 21 中医治疗费(12)
	s entity.F12ZYZLF = $P($P(InPatFee,"!",17),"^",3)
	
	/// 22 西药费(13)
	s entity.F13XYF = $P($P(InPatFee,"!",3),"^",3)
	
	/// 23 中成药费(14)
	s entity.F14ZCHYF = $P($P(InPatFee,"!",4),"^",3)
	
	/// 24 中草药费(15)
	s entity.F15ZCYF = $P($P(InPatFee,"!",23),"^",3)
	
	/// 25 血费(16)
	s entity.F16XF = $P($P(InPatFee,"!",16),"^",3)
	
	/// 26 白蛋白类制品费(17)
	s entity.F17BDBLF = $P($P(InPatFee,"!",6),"^",3)
	
	/// 27 球蛋白类制品费(18)
	s entity.F18QDBLF = $P($P(InPatFee,"!",7),"^",3)
	
	/// 28 凝血因子类制品费(19)
	s entity.F19NXYZF = $P($P(InPatFee,"!",10),"^",3)
	
	/// 29 细胞因子类制品费(20)
	s entity.F20XBYZF = $P($P(InPatFee,"!",21),"^",3)
	
	/// 30 检查用一次性医用材料费(21)
	s entity.F21JCYYCXCLF = $P($P(InPatFee,"!",13),"^",3)
	
	/// 31 治疗用一次性医用材料费(22)
	s entity.F22ZLYYCXCLF = $P($P(InPatFee,"!",2),"^",3)
	
	/// 32 手术用一次性医用材料费(23)
	s entity.F23SSYYCXCLF = $P($P(InPatFee,"!",32),"^",3)
	
	/// 33 其他费(24)
	s entity.F24QTF = $P($P(InPatFee,"!",14),"^",3)
	
	/// 34 临床物理治疗费(09-01)
	s entity.F0901LCWLZLF = $P($P(InPatSubFee,"!",49),"^",3)
	
	/// 35 麻醉费(10-01)
	s entity.F1001MZF = $P($P(InPatSubFee,"!",50),"^",3)
	
	/// 36 手术费(10-02)
	s entity.F1002SSF = $P($P(InPatSubFee,"!",28),"^",3)
	
	/// 37 抗菌药物费用(13-01)
	s entity.F1301KJYWF = $P($P(InPatSubFee,"!",51),"^",3)
		
	q entity
}

/// debug: s entity = ##Class(DHCEPRFS.BL.BLMREpisodeFee).CreateEMREpisodeFeeDHC("update","1","5742458","DHC")
ClassMethod CreateEMREpisodeFeeMRQ(AType As %String, AMRPatientID As %String, AEpisodeID As %String, ASysCode As %String) As DHCEPRFS.Entity.EMREpisodeFee
{
	//获取就诊的首页数据
	s arr = ##class(DHCEPRFS.BL.HISInfo.BLMRQInfo).GetArrayOfDataByAdm(AEpisodeID)
	//b "s"
	s entity = ##Class(DHCEPRFS.Entity.EMREpisodeFee).%New()
	// 02 系统标识号
	s entity.MREpisodeID = ##class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm(AEpisodeID,ASysCode)
	//w !,"2:entity.MREpisodeID: "_entity.MREpisodeID
	// 03 病人标识号
	s entity.MRPatientID = AMRPatientID
	//w !,"3:entity.MRPatientID: "_entity.MRPatientID
	// 04 医疗组织机构代码
	s entity.CompanyCode = ""
	//w !,"4:entity.CompanyCode: "_entity.CompanyCode
	if (AType = "create")
	{
		s entity.CreateDate = $p($h,",",1)  
		s entity.CreateTime = $p($h,",",2)  //06
	}
	else
	{
		s mrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxEpisodeID"," "_AMRPatientID, " "_ASysCode, " "_AEpisodeID, ""))
		s mrEpisodeFeeID = $o(^DHCEPRFS.INST.MREpisodeFeeI("IdxMREpisodeID"," "_mrEpisodeID,""))
		s:(mrEpisodeFeeID = $c(0)) mrEpisodeFeeID = ""
		if (mrEpisodeFeeID = "")
		{
			s entity.CreateDate = $p($h,",",1)  
			s entity.CreateTime = $p($h,",",2)  //06
		}
		else
		{
 			s obj = ##class(DHCEPRFS.INST.MREpisodeFee).%OpenId(mrEpisodeFeeID)
			s entity.CreateDate = obj.CreateDate 
			s entity.CreateTime = obj.CreateTime
			d obj.%Close()	
		}
	}
		//w !,"5:entity.CreateDate: "_entity.CreateDate
	//w !,"6:entity.CreateTime: "_entity.CreateTime
	// 07 最后修改日期
	s entity.LastModifyDate = $p($h,",",1)
	//w !,"7:entity.LastModifyDate: "_entity.LastModifyDate
	// 08 最后修改时间
	s entity.LastModifyTime = $p($h,",",2)
	//w !,"8:entity.LastModifyTime: "_entity.LastModifyTime	
	// 09 总费用 
	s entity.F00TotalFee = arr.GetAt("P60000000")
	/// 10 一般医疗服务费(01)
	s entity.F01YBYLFWF = arr.GetAt("P60010000")

	/// 11 一般治疗操作费(02)
	s entity.F02YBZLCZF = arr.GetAt("P60020000")
	
	/// 12 护理费(03)
	s entity.F03HLF = arr.GetAt("P60030000")
	
	/// 13 其他费用(04)
	s entity.F04QTFY = arr.GetAt("P60040000")
	
	/// 14 病理诊断费(05)
	s entity.F05BLZDF = arr.GetAt("P60050000")
	
	/// 15 实验室诊断费(06)
	s entity.F06SYSZDF = arr.GetAt("P60060000")
	
	/// 16 影像学诊断费(07)
	s entity.F07YXXZDF = arr.GetAt("P60070000")
	
	/// 17 临床诊断项目费(08)
	s entity.F08LCZDXMF = arr.GetAt("P60080000")
	
	/// 18 非手术治疗项目费(09)
	s entity.F09FSSZLF = arr.GetAt("P60090000")
	
	/// 19 手术治疗费(10)
	s entity.F10SSZLF = arr.GetAt("P60100000")
	
	/// 20 康复费(11)
	s entity.F11KFF = arr.GetAt("P60110000")
	
	/// 21 中医治疗费(12)
	s entity.F12ZYZLF = arr.GetAt("P60130000")
	
	/// 22 西药费(13)
	s entity.F13XYF = arr.GetAt("P60150000")
	
	/// 23 中成药费(14)
	s entity.F14ZCHYF = arr.GetAt("P60160000")
	
	/// 24 中草药费(15)
	s entity.F15ZCYF = arr.GetAt("P60170000")
	
	/// 25 血费(16)
	s entity.F16XF = arr.GetAt("P60180000")
	
	/// 26 白蛋白类制品费(17)
	s entity.F17BDBLF = arr.GetAt("P60190000")
	
	/// 27 球蛋白类制品费(18)
	s entity.F18QDBLF = arr.GetAt("P60200000")
	
	/// 28 凝血因子类制品费(19)
	s entity.F19NXYZF = arr.GetAt("P60210000")
	
	/// 29 细胞因子类制品费(20)
	s entity.F20XBYZF = arr.GetAt("P60220000")
	
	/// 30 检查用一次性医用材料费(21)
	s entity.F21JCYYCXCLF = arr.GetAt("P60230000")
	
	/// 31 治疗用一次性医用材料费(22)
	s entity.F22ZLYYCXCLF = arr.GetAt("P60240000")
	
	/// 32 手术用一次性医用材料费(23)
	s entity.F23SSYYCXCLF = arr.GetAt("P60250000")
	
	/// 33 其他费(24)
	s entity.F24QTF = arr.GetAt("P60260000")
	
	/// 34 临床物理治疗费(09-01)
	s entity.F0901LCWLZLF = arr.GetAt("P61009001")
	
	/// 35 麻醉费(10-01)
	s entity.F1001MZF = arr.GetAt("P61010001")
	
	/// 36 手术费(10-02)
	s entity.F1002SSF = arr.GetAt("P61010002")
	
	/// 37 抗菌药物费用(13-01)
	s entity.F1301KJYWF = arr.GetAt("P61013001")
		
	q entity
}

/// Desc:	创建MREpisode
/// Debug: w ##Class(DHCEPRFS.BL.BLMREpisodeFee).UpdateMREpisodeFee("86718")
ClassMethod UpdateMREpisodeFee(AMREpisodeID As %String, ASysCode As %String = "DHC") As %String
{
	//b "s"
	s objMREpisode = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(AMREpisodeID)
	s mrPatientID = objMREpisode.MRPatientID 
	s episodeID = objMREpisode.EpisodeID
	d objMREpisode.%Close()
	
	//此处可通过适配器适配其他系统患者基本信息
	s entity = ..CreateEMREpisodeFeeDHC("update",mrPatientID, episodeID, ASysCode)
	s MREpisodeFeeID = $o(^DHCEPRFS.INST.MREpisodeFeeI("IdxMREpisodeID"," "_AMREpisodeID,""))
	s:(MREpisodeFeeID = $c(0)) MREpisodeFeeID = ""
	s obj = ""
	if (MREpisodeFeeID = "")
	{
		s obj = ##Class(DHCEPRFS.INST.MREpisodeFee).%New()
	}
	else
	{
		s obj = ##Class(DHCEPRFS.INST.MREpisodeFee).%OpenId(MREpisodeFeeID)
	}
	q:(obj="") ""
	
	s obj.MREpisodeID = entity.MREpisodeID
	// 03 病人标识号
	s obj.MRPatientID = entity.MRPatientID
	// 04 医疗组织机构代码
	s obj.CompanyCode = entity.CompanyCode
	// 05 创建日期
	s obj.CreateDate = entity.CreateDate
	// 06 创建时间
	s obj.CreateTime = entity.CreateTime
	// 07 最后修改日期
	s obj.LastModifyDate = entity.LastModifyDate
	// 08 最后修改时间
	s obj.LastModifyTime = entity.LastModifyTime
	// 09 总费用 
	s obj.F00TotalFee = entity.F00TotalFee
	/// 10 一般医疗服务费(01)
	s obj.F01YBYLFWF = entity.F01YBYLFWF

	/// 11 一般治疗操作费(02)
	s obj.F02YBZLCZF = entity.F02YBZLCZF
	
	/// 12 护理费(03)
	s obj.F03HLF = entity.F03HLF
	
	/// 13 其他费用(04)
	s obj.F04QTFY = entity.F04QTFY
	
	/// 14 病理诊断费(05)
	s obj.F05BLZDF = entity.F05BLZDF
	
	/// 15 实验室诊断费(06)
	s obj.F06SYSZDF = entity.F06SYSZDF
	
	/// 16 影像学诊断费(07)
	s obj.F07YXXZDF = entity.F07YXXZDF
	
	/// 17 临床诊断项目费(08)
	s obj.F08LCZDXMF = entity.F08LCZDXMF
	
	/// 18 非手术治疗项目费(09)
	s obj.F09FSSZLF = entity.F09FSSZLF
	
	/// 19 手术治疗费(10)
	s obj.F10SSZLF = entity.F10SSZLF
	
	/// 20 康复费(11)
	s obj.F11KFF = entity.F11KFF //0
	
	/// 21 中医治疗费(12)
	s obj.F12ZYZLF = entity.F12ZYZLF //1
	
	/// 22 西药费(13)
	s obj.F13XYF = entity.F13XYF //2
	
	/// 23 中成药费(14)
	s obj.F14ZCHYF = entity.F14ZCHYF //3
	
	/// 24 中草药费(15)
	s obj.F15ZCYF = entity.F15ZCYF //4
	
	/// 25 血费(16)
	s obj.F16XF = entity.F16XF //5
	
	/// 26 白蛋白类制品费(17)
	s obj.F17BDBLF = entity.F17BDBLF //6
	
	/// 27 球蛋白类制品费(18)
	s obj.F18QDBLF = entity.F18QDBLF //7
	
	/// 28 凝血因子类制品费(19)
	s obj.F19NXYZF = entity.F19NXYZF //8
	
	/// 29 细胞因子类制品费(20)
	s obj.F20XBYZF = entity.F20XBYZF //9
	
	/// 30 检查用一次性医用材料费(21)
	s obj.F21JCYYCXCLF = entity.F21JCYYCXCLF //0
	
	/// 31 治疗用一次性医用材料费(22)
	s obj.F22ZLYYCXCLF = entity.F22ZLYYCXCLF //1
	
	/// 32 手术用一次性医用材料费(23)
	s obj.F23SSYYCXCLF = entity.F23SSYYCXCLF //2
	
	/// 33 其他费(24)
	s obj.F24QTF = entity.F24QTF //3
	
	/// 34 临床物理治疗费(09-01)
	s obj.F0901LCWLZLF = entity.F0901LCWLZLF //4
	
	/// 35 麻醉费(10-01)
	s obj.F1001MZF = entity.F1001MZF //5
	
	/// 36 手术费(10-02)
	s obj.F1002SSF = entity.F1002SSF
	
	/// 37 抗菌药物费用(13-01)
	s obj.F1301KJYWF = entity.F1301KJYWF	
	
	//b "s"
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		q obj.%Id()
	}
	else
	{
		q ""
	}
}

/// Desc:	创建MREpisode
/// Debug: w ##Class(DHCEPRFS.BL.BLMREpisodeFee).CreateMREpisodeFee("1","5742458","DHC")
ClassMethod CreateMREpisodeFee(AMRPatientID As %String, AEpisodeID As %String, ASysCode As %String = "DHC", ATypeCode As %String = "DHC") As %String
{
	//此处可通过适配器适配其他系统患者基本信息
	//从医政组首页数据池取信息
	if (ATypeCode = "MRQ")
	{
		s entity = ..CreateEMREpisodeFeeMRQ("create",AMRPatientID, AEpisodeID, ASysCode)
	}
	//if (ATypeCode = "DHC")
	else
	{
		s entity = ..CreateEMREpisodeFeeDHC("create",AMRPatientID, AEpisodeID, ASysCode)
	}
	s obj = ##Class(DHCEPRFS.INST.MREpisodeFee).%New()
	s obj.MREpisodeID = entity.MREpisodeID
	// 03 病人标识号
	s obj.MRPatientID = entity.MRPatientID
	// 04 医疗组织机构代码
	s obj.CompanyCode = entity.CompanyCode
	// 05 创建日期
	s obj.CreateDate = entity.CreateDate
	// 06 创建时间
	s obj.CreateTime = entity.CreateTime
	// 07 最后修改日期
	s obj.LastModifyDate = entity.LastModifyDate
	// 08 最后修改时间
	s obj.LastModifyTime = entity.LastModifyTime
	/// 10 一般医疗服务费(01)
	s obj.F01YBYLFWF = entity.F01YBYLFWF

	/// 11 一般治疗操作费(02)
	s obj.F02YBZLCZF = entity.F02YBZLCZF
	
	/// 12 护理费(03)
	s obj.F03HLF = entity.F03HLF
	
	/// 13 其他费用(04)
	s obj.F04QTFY = entity.F04QTFY
	
	/// 14 病理诊断费(05)
	s obj.F05BLZDF = entity.F05BLZDF
	
	/// 15 实验室诊断费(06)
	s obj.F06SYSZDF = entity.F06SYSZDF
	
	/// 16 影像学诊断费(07)
	s obj.F07YXXZDF = entity.F07YXXZDF
	
	/// 17 临床诊断项目费(08)
	s obj.F08LCZDXMF = entity.F08LCZDXMF
	
	/// 18 非手术治疗项目费(09)
	s obj.F09FSSZLF = entity.F09FSSZLF
	
	/// 19 手术治疗费(10)
	s obj.F10SSZLF = entity.F10SSZLF
	
	/// 20 康复费(11)
	s obj.F11KFF = entity.F11KFF //0
	
	/// 21 中医治疗费(12)
	s obj.F12ZYZLF = entity.F12ZYZLF //1
	
	/// 22 西药费(13)
	s obj.F13XYF = entity.F13XYF //2
	
	/// 23 中成药费(14)
	s obj.F14ZCHYF = entity.F14ZCHYF //3
	
	/// 24 中草药费(15)
	s obj.F15ZCYF = entity.F15ZCYF //4
	
	/// 25 血费(16)
	s obj.F16XF = entity.F16XF //5
	
	/// 26 白蛋白类制品费(17)
	s obj.F17BDBLF = entity.F17BDBLF //6
	
	/// 27 球蛋白类制品费(18)
	s obj.F18QDBLF = entity.F18QDBLF //7
	
	/// 28 凝血因子类制品费(19)
	s obj.F19NXYZF = entity.F19NXYZF //8
	
	/// 29 细胞因子类制品费(20)
	s obj.F20XBYZF = entity.F20XBYZF //9
	
	/// 30 检查用一次性医用材料费(21)
	s obj.F21JCYYCXCLF = entity.F21JCYYCXCLF //0
	
	/// 31 治疗用一次性医用材料费(22)
	s obj.F22ZLYYCXCLF = entity.F22ZLYYCXCLF //1
	
	/// 32 手术用一次性医用材料费(23)
	s obj.F23SSYYCXCLF = entity.F23SSYYCXCLF //2
	
	/// 33 其他费(24)
	s obj.F24QTF = entity.F24QTF //3
	
	/// 34 临床物理治疗费(09-01)
	s obj.F0901LCWLZLF = entity.F0901LCWLZLF //4
	
	/// 35 麻醉费(10-01)
	s obj.F1001MZF = entity.F1001MZF //5
	
	/// 36 手术费(10-02)
	s obj.F1002SSF = entity.F1002SSF
	
	/// 37 抗菌药物费用(13-01)
	s obj.F1301KJYWF = entity.F1301KJYWF
	
	//b "s"
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		q obj.%Id()
	}
	else
	{
		q ""
	}
}

}
