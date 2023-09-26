Class DHCEPRFS.BL.BLMREpisodeFP Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc:	创建MREpisode
/// Debug: w ##Class(DHCEPRFS.BL.BLMREpisodeFP).UpdateMREpisodeFP("1")
ClassMethod UpdateMREpisodeFP(AMREpisodeID As %String, ASysCode As %String = "DHC") As %String
{
	//b "s"
	s objMREpisode = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(AMREpisodeID)
	s mrPatientID = objMREpisode.MRPatientID 
	s episodeID = objMREpisode.EpisodeID
	d objMREpisode.%Close()
	
	//此处可通过适配器适配其他系统患者基本信息
	s entity = ..CreateEMREpisodeFPDHC("update",mrPatientID, episodeID, ASysCode)
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_AMREpisodeID,""))
	s:(MREpisodeFPID = $c(0)) MREpisodeFPID = ""
	s obj = ""
	if (MREpisodeFPID = "")
	{
		s obj = ##Class(DHCEPRFS.INST.MREpisodeFP).%New()
	}
	else
	{
		s obj = ##Class(DHCEPRFS.INST.MREpisodeFP).%OpenId(MREpisodeFPID)
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
	// 09 主要诊断ID
	s obj.DiagMainID = entity.DiagMainID
	// 10 主要诊断编码
	s obj.DiagMainCode = entity.DiagMainCode
	/// 11 主要诊断描述
	s obj.DiagMainDesc = entity.DiagMainDesc
	
	/// 12 主要诊断入院病情
	s obj.DiagMainState = entity.DiagMainState
	
	/// 13 其它诊断01ID    
	s obj.Diag01ID = entity.Diag01ID
	
	/// 14 其它诊断01编码
	s obj.Diag01Code = entity.Diag01Code
	
	/// 15 其它诊断01描述
	s obj.Diag01Desc = entity.Diag01Desc
	
	/// 16 其它诊断01入院病情
	s obj.Diag01State = entity.Diag01State
	
	/// 17 其它诊断02ID    
	s obj.Diag02ID = entity.Diag02ID
	
	/// 18 其它诊断02编码
	s obj.Diag02Code = entity.Diag02Code
	
	/// 19 其它诊断02描述
	s obj.Diag02Desc = entity.Diag02Desc
	
	/// 20 其它诊断02入院病情
	s obj.Diag02State = entity.Diag02State
	
	/// 21 其它诊断03ID    
	s entity.Diag03ID = entity.Diag03ID
	
	/// 22 其它诊断03编码
	s obj.Diag03Code = entity.Diag03Code
	
	/// 23 其它诊断03描述
	s obj.Diag03Desc = entity.Diag03Desc
	
	/// 24 其它诊断03入院病情
	s obj.Diag03State = entity.Diag03State
	
	/// 25 其它诊断04ID    
	s obj.Diag04ID = entity.Diag04ID
	
	/// 26 其它诊断04编码
	s obj.Diag04Code = entity.Diag04Code
	
	/// 27 其它诊断04描述
	s obj.Diag04Desc = entity.Diag04Desc
	
	/// 28 其它诊断04入院病情
	s obj.Diag04State = entity.Diag04State
	
	/// 29 其它诊断05ID    
	s obj.Diag05ID = entity.Diag05ID
	
	/// 30 其它诊断05编码
	s obj.Diag05Code = entity.Diag05Code
	
	/// 31 其它诊断05描述
	s obj.Diag05Desc = entity.Diag05Desc
	
	/// 32 其它诊断05入院病情
	s obj.Diag05State = entity.Diag05State
	
	/// 33 其它诊断06ID    
	s obj.Diag06ID = entity.Diag06ID
	
	/// 34 其它诊断06编码
	s obj.Diag06Code = entity.Diag06Code
	
	/// 35 其它诊断06描述
	s obj.Diag06Desc = entity.Diag06Desc
	
	/// 36 其它诊断06入院病情
	s obj.Diag06State = entity.Diag06State
	
	/// 37 其它诊断07ID    
	s obj.Diag07ID = entity.Diag07ID
	
	/// 38 其它诊断07编码
	s obj.Diag07Code = entity.Diag07Code
	
	/// 39 其它诊断07描述
	s obj.Diag07Desc = entity.Diag07Desc
	
	/// 40 其它诊断07入院病情
	s obj.Diag07State = entity.Diag07State
	
	/// 41 其它诊断08ID    
	s obj.Diag08ID = entity.Diag08ID
	
	/// 42 其它诊断08编码
	s obj.Diag08Code = entity.Diag08Code
	
	/// 43 其它诊断08描述
	s obj.Diag08Desc = entity.Diag08Desc
	
	/// 44 其它诊断08入院病情
	s obj.Diag08State = entity.Diag08State
	
	/// 45 其它诊断09ID    
	s obj.Diag09ID = entity.Diag09ID
	
	/// 46 其它诊断09编码
	s obj.Diag09Code = entity.Diag09Code
	
	/// 47 其它诊断09描述
	s obj.Diag09Desc = entity.Diag09Desc
	
	/// 48 其它诊断09入院病情
	s obj.Diag09State = entity.Diag09State
	
	/// 49 其它诊断10ID    
	s obj.Diag10ID = entity.Diag10ID
	
	/// 50 其它诊断10编码
	s obj.Diag10Code = entity.Diag10Code
	
	/// 51 其它诊断10描述
	s obj.Diag10Desc = entity.Diag10Desc
	
	/// 52 其它诊断10入院病情
	s obj.Diag10State = entity.Diag10State
	
	/// 53 手术01ID
	s obj.Oper01ID = entity.Oper01ID
	
	/// 54 手术01编码
	s obj.Oper01Code = entity.Oper01Code
	
	/// 55 手术01描述
	s obj.Oper01Desc = entity.Oper01Desc
	
	/// 56 手术01等级
	s obj.Oper01Level = entity.Oper01Level
	
	/// 57 手术01日期
	s obj.Oper01Date = entity.Oper01Date
	
	/// 58 手术01操作医师ID
	s obj.Oper01DocID = entity.Oper01DocID
	
	/// 59 手术01操作医师姓名
	s obj.Oper01DocName = entity.Oper01DocName
	
	/// 60 手术01一助ID
	s obj.Oper01Assist1ID = entity.Oper01Assist1ID
	
	/// 61 手术01一助姓名
	s obj.Oper01Assist1Name = entity.Oper01Assist1Name
	
	/// 62 手术01二助ID
	s obj.Oper01Assist2ID = entity.Oper01Assist2ID
	
	/// 63 手术01二助姓名
	s obj.Oper01Assist2Name = entity.Oper01Assist2Name
	
	/// 64 手术01切口愈合等级
	s obj.Oper01CutLevel = entity.Oper01CutLevel
	
	/// 65 手术01麻醉方式
	s obj.Oper01AnaMethod = entity.Oper01AnaMethod
	
	/// 66 手术01麻醉医师ID
	s obj.Oper01AnaDocID = entity.Oper01AnaDocID
	
	/// 67 手术01麻醉医师姓名
	s obj.Oper01AnaDocName = entity.Oper01AnaDocName
	
	/// 68 手术02ID
	s obj.Oper02ID = entity.Oper02ID
	
	/// 69 手术02编码
	s obj.Oper02Code = entity.Oper02Code
	
	/// 70 手术02描述
	s obj.Oper02Desc = entity.Oper02Desc
	
	/// 71 手术02等级
	s obj.Oper02Level = entity.Oper02Level
	
	/// 72 手术02日期
	s obj.Oper02Date = entity.Oper02Date
	
	/// 73 手术02操作医师ID
	s obj.Oper02DocID = entity.Oper02DocID
	
	/// 74 手术02操作医师姓名
	s obj.Oper02DocName = entity.Oper02DocName
	
	/// 75 手术02一助ID
	s obj.Oper02Assist1ID = entity.Oper02Assist1ID
	
	/// 76 手术02一助姓名
	s obj.Oper02Assist1Name = entity.Oper02Assist1Name
	
	/// 77 手术02二助ID
	s obj.Oper02Assist2ID = entity.Oper02Assist2ID
	
	/// 78 手术02二助姓名
	s obj.Oper02Assist2Name = entity.Oper02Assist2Name
	
	/// 79 手术02切口愈合等级
	s obj.Oper02CutLevel = entity.Oper02CutLevel
	
	/// 80 手术02麻醉方式
	s obj.Oper02AnaMethod = entity.Oper02AnaMethod
	
	/// 81 手术02麻醉医师ID
	s obj.Oper02AnaDocID = entity.Oper02AnaDocID
	
	/// 82 手术02麻醉医师姓名
	s obj.Oper02AnaDocName = entity.Oper02AnaDocName
	
	/// 83 手术03ID
	s obj.Oper03ID = entity.Oper03ID
	
	/// 84 手术03编码
	s obj.Oper03Code = entity.Oper03Code
	
	/// 85 手术03描述
	s obj.Oper03Desc = entity.Oper03Desc
	
	/// 86 手术03等级
	s obj.Oper03Level = entity.Oper03Level
	
	/// 87 手术03日期
	s obj.Oper03Date = entity.Oper03Date
	
	/// 88 手术03操作医师ID
	s obj.Oper03DocID = entity.Oper03DocID
	
	/// 89 手术03操作医师姓名
	s obj.Oper03DocName = entity.Oper03DocName
	
	/// 90 手术03一助ID
	s obj.Oper03Assist1ID = entity.Oper03Assist1ID
	
	/// 91 手术03一助姓名
	s obj.Oper03Assist1Name = entity.Oper03Assist1Name
	
	/// 92 手术03二助ID
	s obj.Oper03Assist2ID = entity.Oper03Assist2ID
	
	/// 93 手术03二助姓名
	s obj.Oper03Assist2Name = entity.Oper03Assist2Name
	
	/// 94 手术03切口愈合等级
	s obj.Oper03CutLevel = entity.Oper03CutLevel
	
	/// 95 手术03麻醉方式
	s obj.Oper03AnaMethod = entity.Oper03AnaMethod
	
	/// 96 手术03麻醉医师ID
	s obj.Oper03AnaDocID = entity.Oper03AnaDocID 
	
	/// 97 手术03麻醉医师姓名
	s obj.Oper03AnaDocName = entity.Oper03AnaDocName
	
	/// 98 手术04ID
	s obj.Oper04ID = entity.Oper04ID
	
	/// 99 手术04编码
	s obj.Oper04Code = entity.Oper04Code
	
	/// 100 手术04描述
	s obj.Oper04Desc = entity.Oper04Desc
	
	/// 101 手术04等级
	s obj.Oper04Level = entity.Oper04Level
	
	/// 102 手术04日期
	s obj.Oper04Date = entity.Oper04Date
	
	/// 103 手术04操作医师ID
	s obj.Oper04DocID = entity.Oper04DocID
	
	/// 104 手术04操作医师姓名
	s obj.Oper04DocName = entity.Oper04DocName
	
	/// 105 手术04一助ID
	s obj.Oper04Assist1ID = entity.Oper04Assist1ID
	
	/// 106 手术04一助姓名
	s obj.Oper04Assist1Name = entity.Oper04Assist1Name
	
	/// 107 手术04二助ID
	s obj.Oper04Assist2ID = entity.Oper04Assist2ID
	
	/// 108 手术04二助姓名
	s obj.Oper04Assist2Name = entity.Oper04Assist2Name
	
	/// 109 手术04切口愈合等级
	s obj.Oper04CutLevel = entity.Oper04CutLevel
	
	/// 110 手术04麻醉方式
	s obj.Oper04AnaMethod = entity.Oper04AnaMethod
	
	/// 111 手术04麻醉医师ID
	s obj.Oper04AnaDocID = entity.Oper04AnaDocID
	
	/// 112 手术04麻醉医师姓名
	s obj.Oper04AnaDocName = entity.Oper04AnaDocName
	
	/// 113 手术05ID
	s obj.Oper05ID = entity.Oper05ID
	
	/// 114 手术05编码
	s obj.Oper05Code = entity.Oper05Code
	
	/// 115 手术05描述
	s obj.Oper05Desc = entity.Oper05Desc
	
	/// 116 手术05等级
	s obj.Oper05Level = entity.Oper05Level
	
	/// 117 手术05日期
	s obj.Oper05Date = entity.Oper05Date
	
	/// 118 手术05操作医师ID
	s obj.Oper05DocID = entity.Oper05DocID
	
	/// 119 手术05操作医师姓名
	s obj.Oper05DocID = entity.Oper05DocID
	
	/// 120 手术05一助ID
	s obj.Oper05Assist1ID = entity.Oper05Assist1ID
	
	/// 121 手术05一助姓名
	s obj.Oper05Assist1ID = entity.Oper05Assist1ID
	
	/// 122 手术05二助ID
	s obj.Oper05Assist2ID = entity.Oper05Assist2ID
	
	/// 123 手术05二助姓名
	s obj.Oper05Assist2Name = entity.Oper05Assist2Name
	
	/// 124 手术05切口愈合等级
	s obj.Oper05CutLevel = entity.Oper05CutLevel
	
	/// 125 手术05麻醉方式
	s obj.Oper05AnaMethod = entity.Oper05AnaMethod
	
	/// 126 手术05麻醉医师ID
	s obj.Oper05AnaDocID = entity.Oper05AnaDocID
	
	/// 127 手术05麻醉医师姓名
	s obj.Oper05AnaDocName = entity.Oper05AnaDocName
	
	/// 128 手术06ID
	s obj.Oper06ID = entity.Oper06ID
	
	/// 129 手术06编码
	s obj.Oper06Code = entity.Oper06Code
	
	/// 130 手术06描述
	s obj.Oper06Desc = entity.Oper06Desc
	
	/// 131 手术06等级
	s obj.Oper06Level = entity.Oper06Level
	
	/// 132 手术06日期
	s obj.Oper06Date = entity.Oper06Date
	
	/// 133 手术06操作医师ID
	s obj.Oper06DocID = entity.Oper06DocID
	
	/// 134 手术06操作医师姓名
	s obj.Oper06DocName = entity.Oper06DocName
	
	/// 135 手术06一助ID
	s obj.Oper06Assist1ID = entity.Oper06Assist1ID
	
	/// 136 手术06一助姓名
	s obj.Oper06Assist1Name = entity.Oper06Assist1Name
	
	/// 137 手术06二助ID
	s obj.Oper06Assist2ID = entity.Oper06Assist2ID
	
	/// 138 手术06二助姓名
	s obj.Oper06Assist2Name = entity.Oper06Assist2Name
	
	/// 139 手术06切口愈合等级
	s obj.Oper06CutLevel = entity.Oper06CutLevel
	
	/// 140 手术06麻醉方式
	s obj.Oper06AnaMethod = entity.Oper06AnaMethod
	
	/// 141 手术06麻醉医师ID
	s obj.Oper06AnaDocID = entity.Oper06AnaDocID
	
	/// 142 手术06麻醉医师姓名
	s obj.Oper06AnaDocName = entity.Oper06AnaDocName
	
	/// 143 手术07ID
	s obj.Oper07ID = entity.Oper07ID
	
	/// 144 手术07编码
	s obj.Oper07Code = entity.Oper07Code
	
	/// 145 手术07描述
	s obj.Oper07Desc = entity.Oper07Desc
	
	/// 146 手术07等级
	s obj.Oper07Level = entity.Oper07Level
	
	/// 147 手术07日期
	s obj.Oper07Date = entity.Oper07Date
	
	/// 148 手术07操作医师ID
	s obj.Oper07DocID = entity.Oper07DocID
	
	/// 149 手术07操作医师姓名
	s obj.Oper07DocName = entity.Oper07DocName
	
	/// 150 手术07一助ID
	s obj.Oper07Assist1ID = entity.Oper07Assist1ID
	
	/// 151 手术07一助姓名
	s obj.Oper07Assist1Name = entity.Oper07Assist1Name
	
	/// 152 手术07二助ID
	s obj.Oper07Assist2ID = entity.Oper07Assist2ID
	
	/// 153 手术07二助姓名
	s obj.Oper07Assist2Name = entity.Oper07Assist2Name
	
	/// 154 手术07切口愈合等级
	s obj.Oper07CutLevel = entity.Oper07CutLevel
	
	/// 155 手术07麻醉方式
	s obj.Oper07AnaMethod = entity.Oper07AnaMethod
	
	/// 156 手术07麻醉医师ID
	s obj.Oper07AnaDocID = entity.Oper07AnaDocID
	
	/// 157 手术07麻醉医师姓名
	s obj.Oper07AnaDocName = entity.Oper07AnaDocName
	
	/// 158 手术08ID
	s obj.Oper08ID = entity.Oper08ID
	
	/// 159 手术08编码
	s obj.Oper08Code = entity.Oper08Code
	
	/// 160 手术08描述
	s obj.Oper08Desc = entity.Oper08Desc
	
	/// 161 手术08等级
	s obj.Oper08Level = entity.Oper08Level
	
	/// 162 手术08日期
	s obj.Oper08Date = entity.Oper08Date
	
	/// 163 手术08操作医师ID
	s obj.Oper08DocID = entity.Oper08DocID
	
	/// 164 手术08操作医师姓名
	s obj.Oper08DocName = entity.Oper08DocName
	
	/// 165 手术08一助ID
	s obj.Oper08Assist1ID = entity.Oper08Assist1ID
	
	/// 166 手术08一助姓名
	s obj.Oper08Assist1Name = entity.Oper08Assist1Name
	
	/// 167 手术08二助ID
	s obj.Oper08Assist2ID = entity.Oper08Assist2ID
	
	/// 168 手术08二助姓名
	s obj.Oper08Assist2Name = entity.Oper08Assist2Name
	
	/// 169 手术08切口愈合等级
	s obj.Oper08CutLevel = entity.Oper08CutLevel
	
	/// 170 手术08麻醉方式
	s obj.Oper08AnaMethod = entity.Oper08AnaMethod
	
	/// 171 手术08麻醉医师ID
	s obj.Oper08AnaDocID = entity.Oper08AnaDocID
	
	/// 172 手术08麻醉医师姓名
	s obj.Oper08AnaDocName = entity.Oper08AnaDocName
	
	/// 173 门急诊诊断ID
	s obj.DiagOutID = entity.DiagOutID
	
	/// 174 门急诊诊断编码
	s obj.DiagOutCode = entity.DiagOutCode
	
	/// 175 门急诊诊断描述
	s obj.DiagOutDesc = entity.DiagOutDesc
	
	/// 176 入院诊断ID
	s obj.DiagAdmID = entity.DiagAdmID
	
	/// 177 入院诊断编码
	s obj.DiagAdmCode = entity.DiagAdmCode
	
	/// 178 入院诊断描述
	s obj.DiagAdmDesc = entity.DiagAdmDesc
	
	/// 179 入院诊断入院情况
	s obj.DiagAdmState = entity.DiagAdmState
	
	/// 180 病理诊断
	s obj.DiagPathDesc = entity.DiagPathDesc
	
	/// 181 病理诊断代码
	s obj.DiagPathCode = entity.DiagPathCode
	
	/// 182 病历主要诊断编码
	s obj.EMRMainDiagCode=entity.EMRMainDiagCode
	
	/// 183 病历主要诊断描述
	s obj.EMRMainDiagDesc=entity.EMRMainDiagDesc
	
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
/// Debug: w ##Class(DHCEPRFS.BL.BLMREpisodeFP).CreateMREpisodeFP("1","5742458","DHC")
ClassMethod CreateMREpisodeFP(AMRPatientID As %String, AEpisodeID As %String, ASysCode As %String = "DHC", ATypeCode As %String = "DHC") As %String
{
	//此处可通过适配器适配其他系统患者基本信息
	
	//默认从医政组病案管理的编目系统取编目信息（DHC），若系统参数配置MRH（病案首页取编目信息），需先配置绑定术语集
	if (ATypeCode = "MRH")
	{
		s entity = ..CreateEMREpisodeFPMRH("create",AMRPatientID, AEpisodeID, ASysCode)
	}
	//从医政组首页数据池取信息
	elseif (ATypeCode = "MRQ")
	{
		s entity = ..CreateEMREpisodeFPMRQ("create",AMRPatientID, AEpisodeID, ASysCode)
	}
	//if (ATypeCode = "DHC")
	else
	{
		s entity = ..CreateEMREpisodeFPDHC("create",AMRPatientID, AEpisodeID, ASysCode)
	}

	s obj = ##Class(DHCEPRFS.INST.MREpisodeFP).%New()
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
	// 09 主要诊断ID
	s obj.DiagMainID = entity.DiagMainID
	// 10 主要诊断编码
	s obj.DiagMainCode = entity.DiagMainCode
	/// 11 主要诊断描述
	s obj.DiagMainDesc = entity.DiagMainDesc
	
	/// 12 主要诊断入院病情
	s obj.DiagMainState = entity.DiagMainState
	
	/// 13 其它诊断01ID    
	s obj.Diag01ID = entity.Diag01ID
	
	/// 14 其它诊断01编码
	s obj.Diag01Code = entity.Diag01Code
	
	/// 15 其它诊断01描述
	s obj.Diag01Desc = entity.Diag01Desc
	
	/// 16 其它诊断01入院病情
	s obj.Diag01State = entity.Diag01State
	
	/// 17 其它诊断02ID    
	s obj.Diag02ID = entity.Diag02ID
	
	/// 18 其它诊断02编码
	s obj.Diag02Code = entity.Diag02Code
	
	/// 19 其它诊断02描述
	s obj.Diag02Desc = entity.Diag02Desc
	
	/// 20 其它诊断02入院病情
	s obj.Diag02State = entity.Diag02State
	
	/// 21 其它诊断03ID    
	s obj.Diag03ID = entity.Diag03ID
	
	/// 22 其它诊断03编码
	s obj.Diag03Code = entity.Diag03Code
	
	/// 23 其它诊断03描述
	s obj.Diag03Desc = entity.Diag03Desc
	
	/// 24 其它诊断03入院病情
	s obj.Diag03State = entity.Diag03State
	
	/// 25 其它诊断04ID    
	s obj.Diag04ID = entity.Diag04ID
	
	/// 26 其它诊断04编码
	s obj.Diag04Code = entity.Diag04Code
	
	/// 27 其它诊断04描述
	s obj.Diag04Desc = entity.Diag04Desc
	
	/// 28 其它诊断04入院病情
	s obj.Diag04State = entity.Diag04State
	
	/// 29 其它诊断05ID    
	s obj.Diag05ID = entity.Diag05ID
	
	/// 30 其它诊断05编码
	s obj.Diag05Code = entity.Diag05Code
	
	/// 31 其它诊断05描述
	s obj.Diag05Desc = entity.Diag05Desc
	
	/// 32 其它诊断05入院病情
	s obj.Diag05State = entity.Diag05State
	
	/// 33 其它诊断06ID    
	s obj.Diag06ID = entity.Diag06ID
	
	/// 34 其它诊断06编码
	s obj.Diag06Code = entity.Diag06Code
	
	/// 35 其它诊断06描述
	s obj.Diag06Desc = entity.Diag06Desc
	
	/// 36 其它诊断06入院病情
	s obj.Diag06State = entity.Diag06State
	
	/// 37 其它诊断07ID    
	s obj.Diag07ID = entity.Diag07ID
	
	/// 38 其它诊断07编码
	s obj.Diag07Code = entity.Diag07Code
	
	/// 39 其它诊断07描述
	s obj.Diag07Desc = entity.Diag07Desc
	
	/// 40 其它诊断07入院病情
	s obj.Diag07State = entity.Diag07State
	
	/// 41 其它诊断08ID    
	s obj.Diag08ID = entity.Diag08ID
	
	/// 42 其它诊断08编码
	s obj.Diag08Code = entity.Diag08Code
	
	/// 43 其它诊断08描述
	s obj.Diag08Desc = entity.Diag08Desc
	
	/// 44 其它诊断08入院病情
	s obj.Diag08State = entity.Diag08State
	
	/// 45 其它诊断09ID    
	s obj.Diag09ID = entity.Diag09ID
	
	/// 46 其它诊断09编码
	s obj.Diag09Code = entity.Diag09Code
	
	/// 47 其它诊断09描述
	s obj.Diag09Desc = entity.Diag09Desc
	
	/// 48 其它诊断09入院病情
	s obj.Diag09State = entity.Diag09State
	
	/// 49 其它诊断10ID    
	s obj.Diag10ID = entity.Diag10ID
	
	/// 50 其它诊断10编码
	s obj.Diag10Code = entity.Diag10Code
	
	/// 51 其它诊断10描述
	s obj.Diag10Desc = entity.Diag10Desc
	
	/// 52 其它诊断10入院病情
	s obj.Diag10State = entity.Diag10State
	
	/// 53 手术01ID
	s obj.Oper01ID = entity.Oper01ID
	
	/// 54 手术01编码
	s obj.Oper01Code = entity.Oper01Code
	
	/// 55 手术01描述
	s obj.Oper01Desc = entity.Oper01Desc
	
	/// 56 手术01等级
	s obj.Oper01Level = entity.Oper01Level
	
	/// 57 手术01日期
	s obj.Oper01Date = entity.Oper01Date
	
	/// 58 手术01操作医师ID
	s obj.Oper01DocID = entity.Oper01DocID
	
	/// 59 手术01操作医师姓名
	s obj.Oper01DocName = entity.Oper01DocName
	
	/// 60 手术01一助ID
	s obj.Oper01Assist1ID = entity.Oper01Assist1ID
	
	/// 61 手术01一助姓名
	s obj.Oper01Assist1Name = entity.Oper01Assist1Name
	
	/// 62 手术01二助ID
	s obj.Oper01Assist2ID = entity.Oper01Assist2ID
	
	/// 63 手术01二助姓名
	s obj.Oper01Assist2Name = entity.Oper01Assist2Name
	
	/// 64 手术01切口愈合等级
	s obj.Oper01CutLevel = entity.Oper01CutLevel
	
	/// 65 手术01麻醉方式
	s obj.Oper01AnaMethod = entity.Oper01AnaMethod
	
	/// 66 手术01麻醉医师ID
	s obj.Oper01AnaDocID = entity.Oper01AnaDocID
	
	/// 67 手术01麻醉医师姓名
	s obj.Oper01AnaDocName = entity.Oper01AnaDocName
	
	/// 68 手术02ID
	s obj.Oper02ID = entity.Oper02ID
	
	/// 69 手术02编码
	s obj.Oper02Code = entity.Oper02Code
	
	/// 70 手术02描述
	s obj.Oper02Desc = entity.Oper02Desc
	
	/// 71 手术02等级
	s obj.Oper02Level = entity.Oper02Level
	
	/// 72 手术02日期
	s obj.Oper02Date = entity.Oper02Date
	
	/// 73 手术02操作医师ID
	s obj.Oper02DocID = entity.Oper02DocID
	
	/// 74 手术02操作医师姓名
	s obj.Oper02DocName = entity.Oper02DocName
	
	/// 75 手术02一助ID
	s obj.Oper02Assist1ID = entity.Oper02Assist1ID
	
	/// 76 手术02一助姓名
	s obj.Oper02Assist1Name = entity.Oper02Assist1Name
	
	/// 77 手术02二助ID
	s obj.Oper02Assist2ID = entity.Oper02Assist2ID
	
	/// 78 手术02二助姓名
	s obj.Oper02Assist2Name = entity.Oper02Assist2Name
	
	/// 79 手术02切口愈合等级
	s obj.Oper02CutLevel = entity.Oper02CutLevel
	
	/// 80 手术02麻醉方式
	s obj.Oper02AnaMethod = entity.Oper02AnaMethod
	
	/// 81 手术02麻醉医师ID
	s obj.Oper02AnaDocID = entity.Oper02AnaDocID
	
	/// 82 手术02麻醉医师姓名
	s obj.Oper02AnaDocName = entity.Oper02AnaDocName
	
	/// 83 手术03ID
	s obj.Oper03ID = entity.Oper03ID
	
	/// 84 手术03编码
	s obj.Oper03Code = entity.Oper03Code
	
	/// 85 手术03描述
	s obj.Oper03Desc = entity.Oper03Desc
	
	/// 86 手术03等级
	s obj.Oper03Level = entity.Oper03Level
	
	/// 87 手术03日期
	s obj.Oper03Date = entity.Oper03Date
	
	/// 88 手术03操作医师ID
	s obj.Oper03DocID = entity.Oper03DocID
	
	/// 89 手术03操作医师姓名
	s obj.Oper03DocName = entity.Oper03DocName
	
	/// 90 手术03一助ID
	s obj.Oper03Assist1ID = entity.Oper03Assist1ID
	
	/// 91 手术03一助姓名
	s obj.Oper03Assist1Name = entity.Oper03Assist1Name
	
	/// 92 手术03二助ID
	s obj.Oper03Assist2ID = entity.Oper03Assist2ID
	
	/// 93 手术03二助姓名
	s obj.Oper03Assist2Name = entity.Oper03Assist2Name
	
	/// 94 手术03切口愈合等级
	s obj.Oper03CutLevel = entity.Oper03CutLevel
	
	/// 95 手术03麻醉方式
	s obj.Oper03AnaMethod = entity.Oper03AnaMethod
	
	/// 96 手术03麻醉医师ID
	s obj.Oper03AnaDocID = entity.Oper03AnaDocID 
	
	/// 97 手术03麻醉医师姓名
	s obj.Oper03AnaDocName = entity.Oper03AnaDocName
	
	/// 98 手术04ID
	s obj.Oper04ID = entity.Oper04ID
	
	/// 99 手术04编码
	s obj.Oper04Code = entity.Oper04Code
	
	/// 100 手术04描述
	s obj.Oper04Desc = entity.Oper04Desc
	
	/// 101 手术04等级
	s obj.Oper04Level = entity.Oper04Level
	
	/// 102 手术04日期
	s obj.Oper04Date = entity.Oper04Date
	
	/// 103 手术04操作医师ID
	s obj.Oper04DocID = entity.Oper04DocID
	
	/// 104 手术04操作医师姓名
	s obj.Oper04DocName = entity.Oper04DocName
	
	/// 105 手术04一助ID
	s obj.Oper04Assist1ID = entity.Oper04Assist1ID
	
	/// 106 手术04一助姓名
	s obj.Oper04Assist1Name = entity.Oper04Assist1Name
	
	/// 107 手术04二助ID
	s obj.Oper04Assist2ID = entity.Oper04Assist2ID
	
	/// 108 手术04二助姓名
	s obj.Oper04Assist2Name = entity.Oper04Assist2Name
	
	/// 109 手术04切口愈合等级
	s obj.Oper04CutLevel = entity.Oper04CutLevel
	
	/// 110 手术04麻醉方式
	s obj.Oper04AnaMethod = entity.Oper04AnaMethod
	
	/// 111 手术04麻醉医师ID
	s obj.Oper04AnaDocID = entity.Oper04AnaDocID
	
	/// 112 手术04麻醉医师姓名
	s obj.Oper04AnaDocName = entity.Oper04AnaDocName
	
	/// 113 手术05ID
	s obj.Oper05ID = entity.Oper05ID
	
	/// 114 手术05编码
	s obj.Oper05Code = entity.Oper05Code
	
	/// 115 手术05描述
	s obj.Oper05Desc = entity.Oper05Desc
	
	/// 116 手术05等级
	s obj.Oper05Level = entity.Oper05Level
	
	/// 117 手术05日期
	s obj.Oper05Date = entity.Oper05Date
	
	/// 118 手术05操作医师ID
	s obj.Oper05DocID = entity.Oper05DocID
	
	/// 119 手术05操作医师姓名
	s obj.Oper05DocID = entity.Oper05DocID
	
	/// 120 手术05一助ID
	s obj.Oper05Assist1ID = entity.Oper05Assist1ID
	
	/// 121 手术05一助姓名
	s obj.Oper05Assist1ID = entity.Oper05Assist1ID
	
	/// 122 手术05二助ID
	s obj.Oper05Assist2ID = entity.Oper05Assist2ID
	
	/// 123 手术05二助姓名
	s obj.Oper05Assist2Name = entity.Oper05Assist2Name
	
	/// 124 手术05切口愈合等级
	s obj.Oper05CutLevel = entity.Oper05CutLevel
	
	/// 125 手术05麻醉方式
	s obj.Oper05AnaMethod = entity.Oper05AnaMethod
	
	/// 126 手术05麻醉医师ID
	s obj.Oper05AnaDocID = entity.Oper05AnaDocID
	
	/// 127 手术05麻醉医师姓名
	s obj.Oper05AnaDocName = entity.Oper05AnaDocName
	
	/// 128 手术06ID
	s obj.Oper06ID = entity.Oper06ID
	
	/// 129 手术06编码
	s obj.Oper06Code = entity.Oper06Code
	
	/// 130 手术06描述
	s obj.Oper06Desc = entity.Oper06Desc
	
	/// 131 手术06等级
	s obj.Oper06Level = entity.Oper06Level
	
	/// 132 手术06日期
	s obj.Oper06Date = entity.Oper06Date
	
	/// 133 手术06操作医师ID
	s obj.Oper06DocID = entity.Oper06DocID
	
	/// 134 手术06操作医师姓名
	s obj.Oper06DocName = entity.Oper06DocName
	
	/// 135 手术06一助ID
	s obj.Oper06Assist1ID = entity.Oper06Assist1ID
	
	/// 136 手术06一助姓名
	s obj.Oper06Assist1Name = entity.Oper06Assist1Name
	
	/// 137 手术06二助ID
	s obj.Oper06Assist2ID = entity.Oper06Assist2ID
	
	/// 138 手术06二助姓名
	s obj.Oper06Assist2Name = entity.Oper06Assist2Name
	
	/// 139 手术06切口愈合等级
	s obj.Oper06CutLevel = entity.Oper06CutLevel
	
	/// 140 手术06麻醉方式
	s obj.Oper06AnaMethod = entity.Oper06AnaMethod
	
	/// 141 手术06麻醉医师ID
	s obj.Oper06AnaDocID = entity.Oper06AnaDocID
	
	/// 142 手术06麻醉医师姓名
	s obj.Oper06AnaDocName = entity.Oper06AnaDocName
	
	/// 143 手术07ID
	s obj.Oper07ID = entity.Oper07ID
	
	/// 144 手术07编码
	s obj.Oper07Code = entity.Oper07Code
	
	/// 145 手术07描述
	s obj.Oper07Desc = entity.Oper07Desc
	
	/// 146 手术07等级
	s obj.Oper07Level = entity.Oper07Level
	
	/// 147 手术07日期
	s obj.Oper07Date = entity.Oper07Date
	
	/// 148 手术07操作医师ID
	s obj.Oper07DocID = entity.Oper07DocID
	
	/// 149 手术07操作医师姓名
	s obj.Oper07DocName = entity.Oper07DocName
	
	/// 150 手术07一助ID
	s obj.Oper07Assist1ID = entity.Oper07Assist1ID
	
	/// 151 手术07一助姓名
	s obj.Oper07Assist1Name = entity.Oper07Assist1Name
	
	/// 152 手术07二助ID
	s obj.Oper07Assist2ID = entity.Oper07Assist2ID
	
	/// 153 手术07二助姓名
	s obj.Oper07Assist2Name = entity.Oper07Assist2Name
	
	/// 154 手术07切口愈合等级
	s obj.Oper07CutLevel = entity.Oper07CutLevel
	
	/// 155 手术07麻醉方式
	s obj.Oper07AnaMethod = entity.Oper07AnaMethod
	
	/// 156 手术07麻醉医师ID
	s obj.Oper07AnaDocID = entity.Oper07AnaDocID
	
	/// 157 手术07麻醉医师姓名
	s obj.Oper07AnaDocName = entity.Oper07AnaDocName
	
	/// 158 手术08ID
	s obj.Oper08ID = entity.Oper08ID
	
	/// 159 手术08编码
	s obj.Oper08Code = entity.Oper08Code
	
	/// 160 手术08描述
	s obj.Oper08Desc = entity.Oper08Desc
	
	/// 161 手术08等级
	s obj.Oper08Level = entity.Oper08Level
	
	/// 162 手术08日期
	s obj.Oper08Date = entity.Oper08Date
	
	/// 163 手术08操作医师ID
	s obj.Oper08DocID = entity.Oper08DocID
	
	/// 164 手术08操作医师姓名
	s obj.Oper08DocName = entity.Oper08DocName
	
	/// 165 手术08一助ID
	s obj.Oper08Assist1ID = entity.Oper08Assist1ID
	
	/// 166 手术08一助姓名
	s obj.Oper08Assist1Name = entity.Oper08Assist1Name
	
	/// 167 手术08二助ID
	s obj.Oper08Assist2ID = entity.Oper08Assist2ID
	
	/// 168 手术08二助姓名
	s obj.Oper08Assist2Name = entity.Oper08Assist2Name
	
	/// 169 手术08切口愈合等级
	s obj.Oper08CutLevel = entity.Oper08CutLevel
	
	/// 170 手术08麻醉方式
	s obj.Oper08AnaMethod = entity.Oper08AnaMethod
	
	/// 171 手术08麻醉医师ID
	s obj.Oper08AnaDocID = entity.Oper08AnaDocID
	
	/// 172 手术08麻醉医师姓名
	s obj.Oper08AnaDocName = entity.Oper08AnaDocName
	
	/// 173 门急诊诊断ID
	s obj.DiagOutID = entity.DiagOutID
	
	/// 174 门急诊诊断编码
	s obj.DiagOutCode = entity.DiagOutCode
	
	/// 175 门急诊诊断描述
	s obj.DiagOutDesc = entity.DiagOutDesc
	
	/// 176 入院诊断ID
	s obj.DiagAdmID = entity.DiagAdmID
	
	/// 177 入院诊断编码
	s obj.DiagAdmCode = entity.DiagAdmCode
	
	/// 178 入院诊断描述
	s obj.DiagAdmDesc = entity.DiagAdmDesc
	
	/// 179 入院诊断入院情况
	s obj.DiagAdmState = entity.DiagAdmState
	
	/// 180 病理诊断
	s obj.DiagPathDesc = entity.DiagPathDesc
	
	/// 180 病理诊断代码
	s obj.DiagPathCode = entity.DiagPathCode
	
	/// 182 病历主要诊断编码
	s obj.EMRMainDiagCode=entity.EMRMainDiagCode
	
	/// 183 病历主要诊断描述
	s obj.EMRMainDiagDesc=entity.EMRMainDiagDesc
	
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

/// debug: s entity = ##Class(DHCEPRFS.BL.BLMREpisodeFP).CreateEMREpisodeFPDHC("update","1","5742458","DHC")
ClassMethod CreateEMREpisodeFPDHC(AType As %String, AMRPatientID As %String, AEpisodeID As %String, ASysCode As %String) As DHCEPRFS.Entity.EMREpisodeFP
{
	//b "s"
	s entity = ##Class(DHCEPRFS.Entity.EMREpisodeFP).%New()
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
		s mrEpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_mrEpisodeID,""))
		if (mrEpisodeFPID = "")
		{
			s entity.CreateDate = $p($h,",",1)  
			s entity.CreateTime = $p($h,",",2)  //06
		}
		else
		{
			s obj = ##class(DHCEPRFS.INST.MREpisodeFP).%OpenId(mrEpisodeFPID)
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
	
	s FPInfoDiag = ##class(DHCWMR.IO.OutService).IGetFrontPageICDAll(AEpisodeID,"D")
	s MainDiagInfoStr = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetFPInfoByTypecode(FPInfoDiag,"1","1")
	
	// 09 主要诊断ID
	//s entity.DiagMainID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetDiagMain(AEpisodeID,"0")
	s entity.DiagMainID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetValByType(MainDiagInfoStr,"0")
	//w !,"9:entity.DiagMainID: "_entity.DiagMainID
	// 10 主要诊断编码
	//s entity.DiagMainCode = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetDiagMain(AEpisodeID,"1")
	s entity.DiagMainCode = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetValByType(MainDiagInfoStr,"1")
	//w !,"10:entity.DiagMainCode: "_entity.DiagMainCode
	/// 11 主要诊断描述
	//s entity.DiagMainDesc = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetDiagMain(AEpisodeID,"2")
	s entity.DiagMainDesc = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetValByType(MainDiagInfoStr,"2")
	//w !,"11:entity.DiagMainDesc: "_entity.DiagMainDesc
	/// 12 主要诊断入院病情
	//s entity.DiagMainState = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetDiagMain(AEpisodeID,"3")
	s entity.DiagMainState = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetValByType(MainDiagInfoStr,"3")
	//w !,"12:entity.DiagMainState: "_entity.DiagMainState
	
	s OtherDiagInfoStr01 = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetFPInfoByTypecode(FPInfoDiag,"2","1")
	/// 13 其它诊断01ID    
	//s entity.Diag01ID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetDiag01(AEpisodeID,"0")
	s entity.Diag01ID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetValByType(OtherDiagInfoStr01,"0")
	//w !,"13:entity.Diag01ID: "_entity.Diag01ID	
	/// 14 其它诊断01编码
	//s entity.Diag01Code = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetDiag01(AEpisodeID,"1")
	s entity.Diag01Code =  ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetValByType(OtherDiagInfoStr01,"1")
	//w !,"14:entity.Diag01Code: "_entity.Diag01Code	
	/// 15 其它诊断01描述
	//s entity.Diag01Desc = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetDiag01(AEpisodeID,"2")
	s entity.Diag01Desc = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetValByType(OtherDiagInfoStr01,"2")
	//w !,"15:entity.Diag01Desc: "_entity.Diag01Desc	
	/// 16 其它诊断01入院病情
	//s entity.Diag01State = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetDiag01(AEpisodeID,"3")
	s entity.Diag01State = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetValByType(OtherDiagInfoStr01,"3")
	//w !,"16:entity.Diag01State: "_entity.Diag01State
	
	s OtherDiagInfoStr02 = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetFPInfoByTypecode(FPInfoDiag,"2","2")
	/// 17 其它诊断02ID    
	//s entity.Diag02ID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetDiag02(AEpisodeID,"0")
	s entity.Diag02ID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetValByType(OtherDiagInfoStr02,"0")
	//w !,"17:entity.Diag02ID: "_entity.Diag02ID	
	/// 18 其它诊断02编码
	//s entity.Diag02Code = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetDiag02(AEpisodeID,"1")
	s entity.Diag02Code = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetValByType(OtherDiagInfoStr02,"1")
	//w !,"18:entity.Diag02Code: "_entity.Diag02Code	
	/// 19 其它诊断02描述
	//s entity.Diag02Desc = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetDiag02(AEpisodeID,"2")
	s entity.Diag02Desc = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetValByType(OtherDiagInfoStr02,"2")
	//w !,"19:entity.Diag02Desc: "_entity.Diag02Desc
	/// 20 其它诊断02入院病情
	//s entity.Diag02State = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetDiag02(AEpisodeID,"3")
	s entity.Diag02State = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetValByType(OtherDiagInfoStr02,"3")
	//w !,"20:entity.Diag02State: "_entity.Diag02State
	
	/// 21 其它诊断03ID    
	s entity.Diag03ID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetDiag03(AEpisodeID,"0")
	//w !,"21:entity.Diag03ID: "_entity.Diag03ID	
	/// 22 其它诊断03编码
	s entity.Diag03Code = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetDiag03(AEpisodeID,"1")
	//w !,"22:entity.Diag03Code: "_entity.Diag03Code	
	/// 23 其它诊断03描述
	s entity.Diag03Desc = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetDiag03(AEpisodeID,"2")
	//w !,"23:entity.Diag03Desc: "_entity.Diag03Desc	
	/// 24 其它诊断03入院病情
	s entity.Diag03State = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetDiag03(AEpisodeID,"3")
	//w !,"24:entity.Diag03State: "_entity.Diag03State
	
	/// 25 其它诊断04ID    
	s entity.Diag04ID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetDiag04(AEpisodeID,"0")
	//w !,"25:entity.Diag04ID: "_entity.Diag04ID
	/// 26 其它诊断04编码
	s entity.Diag04Code = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetDiag04(AEpisodeID,"1")
	//w !,"26:entity.Diag04Code: "_entity.Diag04Code	
	/// 27 其它诊断04描述
	s entity.Diag04Desc = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetDiag04(AEpisodeID,"2")
	//w !,"27:entity.Diag04Desc: "_entity.Diag04Desc	
	/// 28 其它诊断04入院病情
	s entity.Diag04State = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetDiag04(AEpisodeID,"3")
	//w !,"28:entity.Diag04State: "_entity.Diag04State
	
	/// 29 其它诊断05ID    
	s entity.Diag05ID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetDiag05(AEpisodeID,"0")
	//w !,"29:entity.Diag05ID: "_entity.Diag05ID
	/// 30 其它诊断05编码
	s entity.Diag05Code = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetDiag05(AEpisodeID,"1")
	//w !,"30:entity.Diag05Code: "_entity.Diag05Code
	/// 31 其它诊断05描述
	s entity.Diag05Desc = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetDiag05(AEpisodeID,"2")
	//w !,"31:entity.Diag05Desc: "_entity.Diag05Desc
	/// 32 其它诊断05入院病情
	s entity.Diag05State = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetDiag05(AEpisodeID,"3")
	//w !,"32:entity.Diag05State: "_entity.Diag05State
	
	/// 33 其它诊断06ID    
	s entity.Diag06ID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetDiag06(AEpisodeID,"0")
	//w !,"33:entity.Diag06ID: "_entity.Diag06ID
	/// 34 其它诊断06编码
	s entity.Diag06Code = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetDiag06(AEpisodeID,"1")
	//w !,"34:entity.Diag06Code: "_entity.Diag06Code
	/// 35 其它诊断06描述
	s entity.Diag06Desc = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetDiag06(AEpisodeID,"2")
	//w !,"35:entity.Diag06Desc: "_entity.Diag06Desc
	/// 36 其它诊断06入院病情
	s entity.Diag06State = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetDiag06(AEpisodeID,"3")
	//w !,"36:entity.Diag06State: "_entity.Diag06State
	
	/// 37 其它诊断07ID    
	s entity.Diag07ID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetDiag07(AEpisodeID,"0")
	//w !,"37:entity.Diag07ID: "_entity.Diag07ID
	/// 38 其它诊断07编码
	s entity.Diag07Code = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetDiag07(AEpisodeID,"1")
	//w !,"38:entity.Diag07Code: "_entity.Diag07Code	
	/// 39 其它诊断07描述
	s entity.Diag07Desc = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetDiag07(AEpisodeID,"2")
	//w !,"39:entity.Diag07Desc: "_entity.Diag07Desc	
	/// 40 其它诊断07入院病情
	s entity.Diag07State = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetDiag07(AEpisodeID,"3")
	//w !,"40:entity.Diag07State: "_entity.Diag07State
	
	/// 41 其它诊断08ID    
	s entity.Diag08ID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetDiag08(AEpisodeID,"0")
	//w !,"41:entity.Diag08ID: "_entity.Diag08ID	
	/// 42 其它诊断08编码
	s entity.Diag08Code = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetDiag08(AEpisodeID,"1")
	//w !,"42:entity.Diag08Code: "_entity.Diag08Code
	/// 43 其它诊断08描述
	s entity.Diag08Desc = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetDiag08(AEpisodeID,"2")
	//w !,"43:entity.Diag08Desc: "_entity.Diag08Desc
	/// 44 其它诊断08入院病情
	s entity.Diag08State = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetDiag08(AEpisodeID,"3")
	//w !,"44:entity.Diag08State: "_entity.Diag08State
	
	/// 45 其它诊断09ID    
	s entity.Diag09ID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetDiag09(AEpisodeID,"0")
	//w !,"45:entity.Diag09ID: "_entity.Diag09ID
	/// 46 其它诊断09编码
	s entity.Diag09Code = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetDiag09(AEpisodeID,"1")
	//w !,"46:entity.Diag09Code: "_entity.Diag09Code
	/// 47 其它诊断09描述
	s entity.Diag09Desc = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetDiag09(AEpisodeID,"2")
	//w !,"47:entity.Diag09Desc: "_entity.Diag09Desc
	/// 48 其它诊断09入院病情
	s entity.Diag09State = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetDiag09(AEpisodeID,"3")
	//w !,"48:entity.Diag09State: "_entity.Diag09State
	
	/// 49 其它诊断10ID    
	s entity.Diag10ID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetDiag10(AEpisodeID,"0")
	//w !,"49:entity.Diag10ID: "_entity.Diag10ID
	/// 50 其它诊断10编码
	s entity.Diag10Code = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetDiag10(AEpisodeID,"1")
	//w !,"50:entity.Diag10Code: "_entity.Diag10Code
	/// 51 其它诊断10描述
	s entity.Diag10Desc = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetDiag10(AEpisodeID,"2")
	//w !,"51:entity.Diag10Desc: "_entity.Diag10Desc
	/// 52 其它诊断10入院病情
	s entity.Diag10State = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetDiag10(AEpisodeID,"3")
	//w !,"52:entity.Diag10State: "_entity.Diag10State
	
	//b "s"
	
	/// 53 手术01ID
	s entity.Oper01ID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper01(AEpisodeID,"0")
	//w !,"53:entity.Oper01ID: "_entity.Oper01ID
	/// 54 手术01编码
	s entity.Oper01Code = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper01(AEpisodeID,"1")
	//w !,"54:entity.Oper01Code: "_entity.Oper01Code
	/// 55 手术01描述
	s entity.Oper01Desc = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper01(AEpisodeID,"2")
	//w !,"55:entity.Oper01Desc: "_entity.Oper01Desc
	/// 56 手术01等级
	s entity.Oper01Level = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper01(AEpisodeID,"3")
	//w !,"56:entity.Oper01Level: "_entity.Oper01Level
	/// 57 手术01日期
	s entity.Oper01Date = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper01(AEpisodeID,"4")
	//w !,"57:entity.Oper01Date: "_entity.Oper01Date
	/// 58 手术01操作医师ID
	s entity.Oper01DocID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper01(AEpisodeID,"5")
	//w !,"58:entity.Oper01DocID: "_entity.Oper01DocID
	/// 59 手术01操作医师姓名
	s entity.Oper01DocName = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper01(AEpisodeID,"6")
	//w !,"59:entity.Oper01DocName: "_entity.Oper01DocName
	/// 60 手术01一助ID
	s entity.Oper01Assist1ID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper01(AEpisodeID,"7")
	//w !,"60:entity.Oper01Assist1ID: "_entity.Oper01Assist1ID
	/// 61 手术01一助姓名
	s entity.Oper01Assist1Name = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper01(AEpisodeID,"8")
	//w !,"61:entity.Oper01Assist1Name: "_entity.Oper01Assist1Name
	/// 62 手术01二助ID
	s entity.Oper01Assist2ID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper01(AEpisodeID,"9")
	//w !,"62:entity.Oper01Assist2ID: "_entity.Oper01Assist2ID
	/// 63 手术01二助姓名
	s entity.Oper01Assist2Name = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper01(AEpisodeID,"10")
	//w !,"63:entity.Oper01Assist2Name: "_entity.Oper01Assist2Name
	/// 64 手术01切口愈合等级
	s entity.Oper01CutLevel = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper01(AEpisodeID,"11")
	//w !,"64:entity.Oper01CutLevel: "_entity.Oper01CutLevel
	/// 65 手术01麻醉方式
	s entity.Oper01AnaMethod = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper01(AEpisodeID,"12")
	//w !,"65:entity.Oper01AnaMethod: "_entity.Oper01AnaMethod
	/// 66 手术01麻醉医师ID
	s entity.Oper01AnaDocID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper01(AEpisodeID,"13")
	//w !,"66:entity.Oper01AnaDocID: "_entity.Oper01AnaDocID
	/// 67 手术01麻醉医师姓名
	s entity.Oper01AnaDocName = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper01(AEpisodeID,"14")
	//w !,"67:entity.Oper01AnaDocName: "_entity.Oper01AnaDocName
	
	/// 68 手术02ID
	s entity.Oper02ID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper02(AEpisodeID,"0")
	//w !,"68:entity.Oper02ID: "_entity.Oper02ID
	/// 69 手术02编码
	s entity.Oper02Code = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper02(AEpisodeID,"1")
	//w !,"69:entity.Oper02Code: "_entity.Oper02Code
	/// 70 手术02描述
	s entity.Oper02Desc = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper02(AEpisodeID,"2")
	//w !,"70:entity.Oper02Desc: "_entity.Oper02Desc
	/// 71 手术02等级
	s entity.Oper02Level = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper02(AEpisodeID,"3")
	//w !,"71:entity.Oper02Level: "_entity.Oper02Level
	/// 72 手术02日期
	s entity.Oper02Date = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper02(AEpisodeID,"4")
	//w !,"72:entity.Oper02Date: "_entity.Oper02Date
	/// 73 手术02操作医师ID
	s entity.Oper02DocID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper02(AEpisodeID,"5")
	//w !,"73:entity.Oper02DocID: "_entity.Oper02DocID
	/// 74 手术02操作医师姓名
	s entity.Oper02DocName = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper02(AEpisodeID,"6")
	//w !,"74:entity.Oper02DocName: "_entity.Oper02DocName
	/// 75 手术02一助ID
	s entity.Oper02Assist1ID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper02(AEpisodeID,"7")
	//w !,"75:entity.Oper02Assist1ID: "_entity.Oper02Assist1ID
	/// 76 手术02一助姓名
	s entity.Oper02Assist1Name = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper02(AEpisodeID,"8")
	//w !,"76:entity.Oper02Assist1Name: "_entity.Oper02Assist1Name
	/// 77 手术02二助ID
	s entity.Oper02Assist2ID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper02(AEpisodeID,"9")
	//w !,"77:entity.Oper02Assist2ID: "_entity.Oper02Assist2ID
	/// 78 手术02二助姓名
	s entity.Oper02Assist2Name = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper02(AEpisodeID,"10")
	//w !,"78:entity.Oper02Assist2Name: "_entity.Oper02Assist2Name
	/// 79 手术02切口愈合等级
	s entity.Oper02CutLevel = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper02(AEpisodeID,"11")
	//w !,"79:entity.Oper02CutLevel: "_entity.Oper02CutLevel
	/// 80 手术02麻醉方式
	s entity.Oper02AnaMethod = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper02(AEpisodeID,"12")
	//w !,"80:entity.Oper02AnaMethod: "_entity.Oper02AnaMethod
	/// 81 手术02麻醉医师ID
	s entity.Oper02AnaDocID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper02(AEpisodeID,"13")
	//w !,"81:entity.Oper02AnaDocID: "_entity.Oper02AnaDocID
	/// 82 手术02麻醉医师姓名
	s entity.Oper02AnaDocName = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper02(AEpisodeID,"14")
	//w !,"82:entity.Oper02AnaDocName: "_entity.Oper02AnaDocName
	
	/// 83 手术03ID
	s entity.Oper03ID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper03(AEpisodeID,"0")
	//w !,"83:entity.Oper03ID: "_entity.Oper03ID
	/// 84 手术03编码
	s entity.Oper03Code = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper03(AEpisodeID,"1")
	//w !,"84:entity.Oper03Code: "_entity.Oper03Code
	/// 85 手术03描述
	s entity.Oper03Desc = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper03(AEpisodeID,"2")
	//w !,"85:entity.Oper03Desc: "_entity.Oper03Desc
	/// 86 手术03等级
	s entity.Oper03Level = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper03(AEpisodeID,"3")
	//w !,"86:entity.Oper03Level: "_entity.Oper03Level
	/// 87 手术03日期
	s entity.Oper03Date = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper03(AEpisodeID,"4")
	//w !,"87:entity.Oper03Date: "_entity.Oper03Date
	/// 88 手术03操作医师ID
	s entity.Oper03DocID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper03(AEpisodeID,"5")
	//w !,"88:entity.Oper03DocID: "_entity.Oper03DocID
	/// 89 手术03操作医师姓名
	s entity.Oper03DocName = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper03(AEpisodeID,"6")
	//w !,"89:entity.Oper03DocName: "_entity.Oper03DocName
	/// 90 手术03一助ID
	s entity.Oper03Assist1ID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper03(AEpisodeID,"7")
	//w !,"90:entity.Oper03Assist1ID: "_entity.Oper03Assist1ID
	/// 91 手术03一助姓名
	s entity.Oper03Assist1Name = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper03(AEpisodeID,"8")
	//w !,"91:entity.Oper03Assist1Name: "_entity.Oper03Assist1Name
	/// 92 手术03二助ID
	s entity.Oper03Assist2ID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper03(AEpisodeID,"9")
	//w !,"92:entity.Oper03Assist2ID: "_entity.Oper03Assist2ID
	/// 93 手术03二助姓名
	s entity.Oper03Assist2Name = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper03(AEpisodeID,"10")
	//w !,"93:entity.Oper03Assist2Name: "_entity.Oper03Assist2Name
	/// 94 手术03切口愈合等级
	s entity.Oper03CutLevel = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper03(AEpisodeID,"11")
	//w !,"94:entity.Oper03CutLevel: "_entity.Oper03CutLevel
	/// 95 手术03麻醉方式
	s entity.Oper03AnaMethod = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper03(AEpisodeID,"12")
	//w !,"95:entity.Oper03AnaMethod: "_entity.Oper03AnaMethod
	/// 96 手术03麻醉医师ID
	s entity.Oper03AnaDocID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper03(AEpisodeID,"13")
	//w !,"96:entity.Oper03AnaDocID: "_entity.Oper03AnaDocID
	/// 97 手术03麻醉医师姓名
	s entity.Oper03AnaDocName = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper03(AEpisodeID,"14")
	//w !,"97:entity.Oper03AnaDocName: "_entity.Oper03AnaDocName
	
	/// 98 手术04ID
	s entity.Oper04ID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper04(AEpisodeID,"0")
	//w !,"98:entity.Oper04ID: "_entity.Oper04ID
	/// 99 手术04编码
	s entity.Oper04Code = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper04(AEpisodeID,"1")
	//w !,"99:entity.Oper04Code: "_entity.Oper04Code
	/// 100 手术04描述
	s entity.Oper04Desc = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper04(AEpisodeID,"2")
	//w !,"100:entity.Oper04Desc: "_entity.Oper04Desc
	/// 101 手术04等级
	s entity.Oper04Level = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper04(AEpisodeID,"3")
	//w !,"101:entity.Oper04Level: "_entity.Oper04Level
	/// 102 手术04日期
	s entity.Oper04Date = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper04(AEpisodeID,"4")
	//w !,"102:entity.Oper04Date: "_entity.Oper04Date
	/// 103 手术04操作医师ID
	s entity.Oper04DocID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper04(AEpisodeID,"5")
	//w !,"103:entity.Oper04DocID: "_entity.Oper04DocID
	/// 104 手术04操作医师姓名
	s entity.Oper04DocName = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper04(AEpisodeID,"6")
	//w !,"104:entity.Oper04DocName: "_entity.Oper04DocName
	/// 105 手术04一助ID
	s entity.Oper04Assist1ID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper04(AEpisodeID,"7")
	//w !,"105:entity.Oper04Assist1ID: "_entity.Oper04Assist1ID
	/// 106 手术04一助姓名
	s entity.Oper04Assist1Name = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper04(AEpisodeID,"8")
	//w !,"106:entity.Oper04Assist1Name: "_entity.Oper04Assist1Name
	/// 107 手术04二助ID
	s entity.Oper04Assist2ID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper04(AEpisodeID,"9")
	//w !,"107:entity.Oper04Assist2ID: "_entity.Oper04Assist2ID
	/// 108 手术04二助姓名
	s entity.Oper04Assist2Name = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper04(AEpisodeID,"10")
	//w !,"108:entity.Oper04Assist2Name: "_entity.Oper04Assist2Name
	/// 109 手术04切口愈合等级
	s entity.Oper04CutLevel = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper04(AEpisodeID,"11")
	//w !,"109:entity.Oper04CutLevel: "_entity.Oper04CutLevel
	/// 110 手术04麻醉方式
	s entity.Oper04AnaMethod = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper04(AEpisodeID,"12")
	//w !,"110:entity.Oper04AnaMethod: "_entity.Oper04AnaMethod
	/// 111 手术04麻醉医师ID
	s entity.Oper04AnaDocID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper04(AEpisodeID,"13")
	//w !,"111:entity.Oper04AnaDocID: "_entity.Oper04AnaDocID
	/// 112 手术04麻醉医师姓名
	s entity.Oper04AnaDocName = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper04(AEpisodeID,"14")
	//w !,"112:entity.Oper04AnaDocName: "_entity.Oper04AnaDocName
	
	/// 113 手术05ID
	s entity.Oper05ID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper05(AEpisodeID,"0")
	//w !,"113:entity.Oper05ID: "_entity.Oper05ID
	/// 114 手术05编码
	s entity.Oper05Code = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper05(AEpisodeID,"1")
	//w !,"114:entity.Oper05Code: "_entity.Oper05Code
	/// 115 手术05描述
	s entity.Oper05Desc = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper05(AEpisodeID,"2")
	//w !,"115:entity.Oper05Desc: "_entity.Oper05Desc
	/// 116 手术05等级
	s entity.Oper05Level = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper05(AEpisodeID,"3")
	//w !,"116:entity.Oper05Level: "_entity.Oper05Level
	/// 117 手术05日期
	s entity.Oper05Date = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper05(AEpisodeID,"4")
	//w !,"117:entity.Oper05Date: "_entity.Oper05Date
	/// 118 手术05操作医师ID
	s entity.Oper05DocID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper05(AEpisodeID,"5")
	//w !,"118:entity.Oper05DocID: "_entity.Oper05DocID
	/// 119 手术05操作医师姓名
	s entity.Oper05DocName = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper05(AEpisodeID,"6")
	//w !,"119:entity.Oper05DocName: "_entity.Oper05DocName
	/// 120 手术05一助ID
	s entity.Oper05Assist1ID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper05(AEpisodeID,"7")
	//w !,"120:entity.Oper05Assist1ID: "_entity.Oper05Assist1ID
	/// 121 手术05一助姓名
	s entity.Oper05Assist1Name = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper05(AEpisodeID,"8")
	//w !,"121:entity.Oper05Assist1Name: "_entity.Oper05Assist1Name
	/// 122 手术05二助ID
	s entity.Oper05Assist2ID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper05(AEpisodeID,"9")
	//w !,"122:entity.Oper05Assist2ID: "_entity.Oper05Assist2ID
	/// 123 手术05二助姓名
	s entity.Oper05Assist2Name = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper05(AEpisodeID,"10")
	//w !,"123:entity.Oper05Assist2Name: "_entity.Oper05Assist2Name
	/// 124 手术05切口愈合等级
	s entity.Oper05CutLevel = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper05(AEpisodeID,"11")
	//w !,"124:entity.Oper05CutLevel: "_entity.Oper05CutLevel
	/// 125 手术05麻醉方式
	s entity.Oper05AnaMethod = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper05(AEpisodeID,"12")
	//w !,"125:entity.Oper05AnaMethod: "_entity.Oper05AnaMethod
	/// 126 手术05麻醉医师ID
	s entity.Oper05AnaDocID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper05(AEpisodeID,"13")
	//w !,"126:entity.Oper05AnaDocID: "_entity.Oper05AnaDocID
	/// 127 手术05麻醉医师姓名
	s entity.Oper05AnaDocName = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper05(AEpisodeID,"14")
	//w !,"127:entity.Oper05AnaDocName: "_entity.Oper05AnaDocName
	
	/// 128 手术06ID
	s entity.Oper06ID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper06(AEpisodeID,"0")
	//w !,"128:entity.Oper06ID: "_entity.Oper06ID
	/// 129 手术06编码
	s entity.Oper06Code = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper06(AEpisodeID,"1")
	//w !,"129:entity.Oper06Code: "_entity.Oper06Code
	/// 130 手术06描述
	s entity.Oper06Desc = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper06(AEpisodeID,"2")
	//w !,"130:entity.Oper06Desc: "_entity.Oper06Desc
	/// 131 手术06等级
	s entity.Oper06Level = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper06(AEpisodeID,"3")
	//w !,"131:entity.Oper06Level: "_entity.Oper06Level
	/// 132 手术06日期
	s entity.Oper06Date = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper06(AEpisodeID,"4")
	//w !,"132:entity.Oper06Date: "_entity.Oper06Date
	/// 133 手术06操作医师ID
	s entity.Oper06DocID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper06(AEpisodeID,"5")
	//w !,"133:entity.Oper06DocID: "_entity.Oper06DocID
	/// 134 手术06操作医师姓名
	s entity.Oper06DocName = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper06(AEpisodeID,"6")
	//w !,"134:entity.Oper06DocName: "_entity.Oper06DocName
	/// 135 手术06一助ID
	s entity.Oper06Assist1ID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper06(AEpisodeID,"7")
	//w !,"135:entity.Oper06Assist1ID: "_entity.Oper06Assist1ID
	/// 136 手术06一助姓名
	s entity.Oper06Assist1Name = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper06(AEpisodeID,"8")
	//w !,"136:entity.Oper06Assist1Name: "_entity.Oper06Assist1Name
	/// 137 手术06二助ID
	s entity.Oper06Assist2ID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper06(AEpisodeID,"9")
	//w !,"137:entity.Oper06Assist2ID: "_entity.Oper06Assist2ID
	/// 138 手术06二助姓名
	s entity.Oper06Assist2Name = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper06(AEpisodeID,"10")
	//w !,"138:entity.Oper06Assist2Name: "_entity.Oper06Assist2Name
	/// 139 手术06切口愈合等级
	s entity.Oper06CutLevel = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper06(AEpisodeID,"11")
	//w !,"139:entity.Oper06CutLevel: "_entity.Oper06CutLevel
	/// 140 手术06麻醉方式
	s entity.Oper06AnaMethod = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper06(AEpisodeID,"12")
	//w !,"140:entity.Oper06AnaMethod: "_entity.Oper06AnaMethod
	/// 141 手术06麻醉医师ID
	s entity.Oper06AnaDocID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper06(AEpisodeID,"13")
	//w !,"141:entity.Oper06AnaDocID: "_entity.Oper06AnaDocID
	/// 142 手术06麻醉医师姓名
	s entity.Oper06AnaDocName = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper06(AEpisodeID,"14")
	//w !,"142:entity.Oper06AnaDocName: "_entity.Oper06AnaDocName
	
	/// 143 手术07ID
	s entity.Oper07ID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper07(AEpisodeID,"0")
	//w !,"143:entity.Oper07ID: "_entity.Oper07ID
	/// 144 手术07编码
	s entity.Oper07Code = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper07(AEpisodeID,"1")
	//w !,"144:entity.Oper07Code: "_entity.Oper07Code
	/// 145 手术07描述
	s entity.Oper07Desc = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper07(AEpisodeID,"2")
	//w !,"145:entity.Oper07Desc: "_entity.Oper07Desc
	/// 146 手术07等级
	s entity.Oper07Level = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper07(AEpisodeID,"3")
	//w !,"146:entity.Oper07Level: "_entity.Oper07Level
	/// 147 手术07日期
	s entity.Oper07Date = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper07(AEpisodeID,"4")
	//w !,"147:entity.Oper07Date: "_entity.Oper07Date
	/// 148 手术07操作医师ID
	s entity.Oper07DocID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper07(AEpisodeID,"5")
	//w !,"148:entity.Oper07DocID: "_entity.Oper07DocID
	/// 149 手术07操作医师姓名
	s entity.Oper07DocName = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper07(AEpisodeID,"6")
	//w !,"149:entity.Oper07DocName: "_entity.Oper07DocName
	/// 150 手术07一助ID
	s entity.Oper07Assist1ID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper07(AEpisodeID,"7")
	//w !,"150:entity.Oper07Assist1ID: "_entity.Oper07Assist1ID
	/// 151 手术07一助姓名
	s entity.Oper07Assist1Name = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper07(AEpisodeID,"8")
	//w !,"151:entity.Oper07Assist1Name: "_entity.Oper07Assist1Name
	/// 152 手术07二助ID
	s entity.Oper07Assist2ID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper07(AEpisodeID,"9")
	//w !,"152:entity.Oper07Assist2ID: "_entity.Oper07Assist2ID
	/// 153 手术07二助姓名
	s entity.Oper07Assist2Name = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper07(AEpisodeID,"10")
	//w !,"153:entity.Oper07Assist2Name: "_entity.Oper07Assist2Name
	/// 154 手术07切口愈合等级
	s entity.Oper07CutLevel = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper07(AEpisodeID,"11")
	//w !,"154:entity.Oper07CutLevel: "_entity.Oper07CutLevel
	/// 155 手术07麻醉方式
	s entity.Oper07AnaMethod = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper07(AEpisodeID,"12")
	//w !,"155:entity.Oper07AnaMethod: "_entity.Oper07AnaMethod
	/// 156 手术07麻醉医师ID
	s entity.Oper07AnaDocID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper07(AEpisodeID,"13")
	//w !,"156:entity.Oper07AnaDocID: "_entity.Oper07AnaDocID
	/// 157 手术07麻醉医师姓名
	s entity.Oper07AnaDocName = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper07(AEpisodeID,"14")
	//w !,"157:entity.Oper07AnaDocName: "_entity.Oper07AnaDocName
	
	/// 158 手术08ID
	s entity.Oper08ID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper08(AEpisodeID,"0")
	//w !,"158:entity.Oper08ID: "_entity.Oper08ID
	/// 159 手术08编码
	s entity.Oper08Code = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper08(AEpisodeID,"1")
	//w !,"159:entity.Oper08Code: "_entity.Oper08Code
	/// 160 手术08描述
	s entity.Oper08Desc = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper08(AEpisodeID,"2")
	//w !,"160:entity.Oper08Desc: "_entity.Oper08Desc
	/// 161 手术08等级
	s entity.Oper08Level = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper08(AEpisodeID,"3")
	//w !,"161:entity.Oper08Level: "_entity.Oper08Level
	/// 162 手术08日期
	s entity.Oper08Date = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper08(AEpisodeID,"4")
	//w !,"162:entity.Oper08Date: "_entity.Oper08Date
	/// 163 手术08操作医师ID
	s entity.Oper08DocID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper08(AEpisodeID,"5")
	//w !,"163:entity.Oper08DocID: "_entity.Oper08DocID
	/// 164 手术08操作医师姓名
	s entity.Oper08DocName = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper08(AEpisodeID,"6")
	//w !,"164:entity.Oper08DocName: "_entity.Oper08DocName
	/// 165 手术08一助ID
	s entity.Oper08Assist1ID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper08(AEpisodeID,"7")
	//w !,"165:entity.Oper08Assist1ID: "_entity.Oper08Assist1ID
	/// 166 手术08一助姓名
	s entity.Oper08Assist1Name = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper08(AEpisodeID,"8")
	//w !,"166:entity.Oper08Assist1Name: "_entity.Oper08Assist1Name
	/// 167 手术08二助ID
	s entity.Oper08Assist2ID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper08(AEpisodeID,"9")
	//w !,"167:entity.Oper08Assist2ID: "_entity.Oper08Assist2ID
	/// 168 手术08二助姓名
	s entity.Oper08Assist2Name = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper08(AEpisodeID,"10")
	//w !,"168:entity.Oper08Assist2Name: "_entity.Oper08Assist2Name
	/// 169 手术08切口愈合等级
	s entity.Oper08CutLevel = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper08(AEpisodeID,"11")
	//w !,"169:entity.Oper08CutLevel: "_entity.Oper08CutLevel
	/// 170 手术08麻醉方式
	s entity.Oper08AnaMethod = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper08(AEpisodeID,"12")
	//w !,"170:entity.Oper08AnaMethod: "_entity.Oper08AnaMethod
	/// 171 手术08麻醉医师ID
	s entity.Oper08AnaDocID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper08(AEpisodeID,"13")
	//w !,"171:entity.Oper08AnaDocID: "_entity.Oper08AnaDocID
	/// 172 手术08麻醉医师姓名
	s entity.Oper08AnaDocName = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetOper08(AEpisodeID,"14")
	//w !,"172:entity.Oper08AnaDocName: "_entity.Oper08AnaDocName
	
	//b "s"
	/// 173 门急诊诊断ID
	s entity.DiagOutID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetDiagOut(AEpisodeID,"0")
	//w !,"173:entity.DiagOutID: "_entity.DiagOutID
	/// 174 门急诊诊断编码
	s entity.DiagOutCode = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetDiagOut(AEpisodeID,"1")
	//w !,"174:entity.DiagOutCode: "_entity.DiagOutCode
	/// 175 门急诊诊断描述
	s entity.DiagOutDesc = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetDiagOut(AEpisodeID,"2")
	//w !,"175:entity.DiagOutDesc: "_entity.DiagOutDesc
	
	/// 176 入院诊断ID
	s entity.DiagAdmID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetDiagAdm(AEpisodeID,"0")
	//w !,"176:entity.DiagAdmID: "_entity.DiagAdmID
	/// 177 入院诊断编码
	s entity.DiagAdmCode = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetDiagAdm(AEpisodeID,"1")
	//w !,"177:entity.DiagAdmCode: "_entity.DiagAdmCode
	/// 178 入院诊断描述
	s entity.DiagAdmDesc = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetDiagAdm(AEpisodeID,"2")
	//w !,"178:entity.DiagAdmDesc: "_entity.DiagAdmDesc
	
	/// 179 入院诊断入院情况
	s entity.DiagAdmState = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetAdmState(AEpisodeID)
	//w !,"179:entity.DiagAdmState: "_entity.DiagAdmState
	
	/// 180 病理诊断
	s entity.DiagPathDesc = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetDiagPath(AEpisodeID,"2")
	//w !,"180:entity.DiagPathDesc: "_entity.DiagPathDesc
	
	/// 181 病理诊断代码
	s entity.DiagPathCode = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeFPInfo).GetDiagPath(AEpisodeID,"1")
	//w !,"180:entity.DiagPathCode: "_entity.DiagPathCode
	
	//取术语集
	s Glossary = ##Class(EPRservice.BOScatterData).GetDataByGlossaryCategory(AEpisodeID,"HDSD00.11")
	/// 182 病历主要诊断编码
	s entity.EMRMainDiagCode=Glossary.GetAt("HDSD00.11.023")
	
	/// 183 病历主要诊断描述
	s entity.EMRMainDiagDesc =Glossary.GetAt("HDSD00.11.024")
	q entity
}

/// debug: s entity = ##Class(DHCEPRFS.BL.BLMREpisodeFP).CreateEMREpisodeFPMRH("update","1","5742458","DHC")
ClassMethod CreateEMREpisodeFPMRH(AType As %String, AMRPatientID As %String, AEpisodeID As %String, ASysCode As %String) As DHCEPRFS.Entity.EMREpisodeFP
{
	s Glossary = ##Class(EPRservice.BOScatterData).GetDataByGlossaryCategory(AEpisodeID,"HDSD00.19")
	
	s entity = ##Class(DHCEPRFS.Entity.EMREpisodeFP).%New()
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
		s mrEpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_mrEpisodeID,""))
		if (mrEpisodeFPID = "")
		{
			s entity.CreateDate = $p($h,",",1)  
			s entity.CreateTime = $p($h,",",2)  //06
		}
		else
		{
			s obj = ##class(DHCEPRFS.INST.MREpisodeFP).%OpenId(mrEpisodeFPID)
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
	// 09 主要诊断ID
	s entity.DiagMainID = ""
	//w !,"9:entity.DiagMainID: "_entity.DiagMainID
	// 10 主要诊断编码
	s entity.DiagMainCode = Glossary.GetAt("HDSD00.19.023")
	//w !,"10:entity.DiagMainCode: "_entity.DiagMainCode
	/// 11 主要诊断描述
	s entity.DiagMainDesc = Glossary.GetAt("HDSD00.19.024")
	//w !,"11:entity.DiagMainDesc: "_entity.DiagMainDesc
	/// 12 主要诊断入院病情
	s entity.DiagMainState = Glossary.GetAt("HDSD00.19.304")
	//w !,"12:entity.DiagMainState: "_entity.DiagMainState
	
	/// 13 其它诊断01ID    
	s entity.Diag01ID = ""
	//w !,"13:entity.Diag01ID: "_entity.Diag01ID	
	/// 14 其它诊断01编码
	s entity.Diag01Code = Glossary.GetAt("HDSD00.19.020")
	//w !,"14:entity.Diag01Code: "_entity.Diag01Code	
	/// 15 其它诊断01描述
	s entity.Diag01Desc = Glossary.GetAt("HDSD00.19.021")
	//w !,"15:entity.Diag01Desc: "_entity.Diag01Desc	
	/// 16 其它诊断01入院病情
	s entity.Diag01State = Glossary.GetAt("HDSD00.19.305")
	//w !,"16:entity.Diag01State: "_entity.Diag01State
	
	/// 17 其它诊断02ID    
	s entity.Diag02ID = ""
	//w !,"17:entity.Diag02ID: "_entity.Diag02ID	
	/// 18 其它诊断02编码
	s entity.Diag02Code = Glossary.GetAt("HDSD00.19.307")
	//w !,"18:entity.Diag02Code: "_entity.Diag02Code	
	/// 19 其它诊断02描述
	s entity.Diag02Desc = Glossary.GetAt("HDSD00.19.306")
	//w !,"19:entity.Diag02Desc: "_entity.Diag02Desc
	/// 20 其它诊断02入院病情
	s entity.Diag02State = Glossary.GetAt("HDSD00.19.309")
	//w !,"20:entity.Diag02State: "_entity.Diag02State
	
	/// 21 其它诊断03ID    
	s entity.Diag03ID = ""
	//w !,"21:entity.Diag03ID: "_entity.Diag03ID	
	/// 22 其它诊断03编码
	s entity.Diag03Code = Glossary.GetAt("HDSD00.19.311")
	//w !,"22:entity.Diag03Code: "_entity.Diag03Code	
	/// 23 其它诊断03描述
	s entity.Diag03Desc = Glossary.GetAt("HDSD00.19.310")
	//w !,"23:entity.Diag03Desc: "_entity.Diag03Desc	
	/// 24 其它诊断03入院病情
	s entity.Diag03State = Glossary.GetAt("HDSD00.19.313")
	//w !,"24:entity.Diag03State: "_entity.Diag03State
	
	/// 25 其它诊断04ID    
	s entity.Diag04ID = ""
	//w !,"25:entity.Diag04ID: "_entity.Diag04ID
	/// 26 其它诊断04编码
	s entity.Diag04Code = Glossary.GetAt("HDSD00.19.315")
	//w !,"26:entity.Diag04Code: "_entity.Diag04Code	
	/// 27 其它诊断04描述
	s entity.Diag04Desc = Glossary.GetAt("HDSD00.19.314")
	//w !,"27:entity.Diag04Desc: "_entity.Diag04Desc	
	/// 28 其它诊断04入院病情
	s entity.Diag04State = Glossary.GetAt("HDSD00.19.317")
	//w !,"28:entity.Diag04State: "_entity.Diag04State
	
	/// 29 其它诊断05ID    
	s entity.Diag05ID = ""
	//w !,"29:entity.Diag05ID: "_entity.Diag05ID
	/// 30 其它诊断05编码
	s entity.Diag05Code = Glossary.GetAt("HDSD00.19.319")
	//w !,"30:entity.Diag05Code: "_entity.Diag05Code
	/// 31 其它诊断05描述
	s entity.Diag05Desc = Glossary.GetAt("HDSD00.19.318")
	//w !,"31:entity.Diag05Desc: "_entity.Diag05Desc
	/// 32 其它诊断05入院病情
	s entity.Diag05State = Glossary.GetAt("HDSD00.19.321")
	//w !,"32:entity.Diag05State: "_entity.Diag05State
	
	/// 33 其它诊断06ID    
	s entity.Diag06ID = ""
	//w !,"33:entity.Diag06ID: "_entity.Diag06ID
	/// 34 其它诊断06编码
	s entity.Diag06Code = Glossary.GetAt("HDSD00.19.323")
	//w !,"34:entity.Diag06Code: "_entity.Diag06Code
	/// 35 其它诊断06描述
	s entity.Diag06Desc = Glossary.GetAt("HDSD00.19.322")
	//w !,"35:entity.Diag06Desc: "_entity.Diag06Desc
	/// 36 其它诊断06入院病情
	s entity.Diag06State = Glossary.GetAt("HDSD00.19.325")
	//w !,"36:entity.Diag06State: "_entity.Diag06State
	
	/// 37 其它诊断07ID    
	s entity.Diag07ID = ""
	//w !,"37:entity.Diag07ID: "_entity.Diag07ID
	/// 38 其它诊断07编码
	s entity.Diag07Code = Glossary.GetAt("HDSD00.19.327")
	//w !,"38:entity.Diag07Code: "_entity.Diag07Code	
	/// 39 其它诊断07描述
	s entity.Diag07Desc = Glossary.GetAt("HDSD00.19.326")
	//w !,"39:entity.Diag07Desc: "_entity.Diag07Desc	
	/// 40 其它诊断07入院病情
	s entity.Diag07State = Glossary.GetAt("HDSD00.19.329")
	//w !,"40:entity.Diag07State: "_entity.Diag07State
	
	/// 41 其它诊断08ID    
	s entity.Diag08ID = ""
	//w !,"41:entity.Diag08ID: "_entity.Diag08ID	
	/// 42 其它诊断08编码
	s entity.Diag08Code = Glossary.GetAt("HDSD00.19.331")
	//w !,"42:entity.Diag08Code: "_entity.Diag08Code
	/// 43 其它诊断08描述
	s entity.Diag08Desc = Glossary.GetAt("HDSD00.19.330")
	//w !,"43:entity.Diag08Desc: "_entity.Diag08Desc
	/// 44 其它诊断08入院病情
	s entity.Diag08State = Glossary.GetAt("HDSD00.19.333")
	//w !,"44:entity.Diag08State: "_entity.Diag08State
	
	/// 45 其它诊断09ID    
	s entity.Diag09ID = ""
	//w !,"45:entity.Diag09ID: "_entity.Diag09ID
	/// 46 其它诊断09编码
	s entity.Diag09Code = Glossary.GetAt("HDSD00.19.335")
	//w !,"46:entity.Diag09Code: "_entity.Diag09Code
	/// 47 其它诊断09描述
	s entity.Diag09Desc = Glossary.GetAt("HDSD00.19.334")
	//w !,"47:entity.Diag09Desc: "_entity.Diag09Desc
	/// 48 其它诊断09入院病情
	s entity.Diag09State = Glossary.GetAt("HDSD00.19.337")
	//w !,"48:entity.Diag09State: "_entity.Diag09State
	
	/// 49 其它诊断10ID    
	s entity.Diag10ID = ""
	//w !,"49:entity.Diag10ID: "_entity.Diag10ID
	/// 50 其它诊断10编码
	s entity.Diag10Code = Glossary.GetAt("HDSD00.19.339")
	//w !,"50:entity.Diag10Code: "_entity.Diag10Code
	/// 51 其它诊断10描述
	s entity.Diag10Desc = Glossary.GetAt("HDSD00.19.338")
	//w !,"51:entity.Diag10Desc: "_entity.Diag10Desc
	/// 52 其它诊断10入院病情
	s entity.Diag10State = Glossary.GetAt("HDSD00.19.341")
	//w !,"52:entity.Diag10State: "_entity.Diag10State
	
	//b "s"
	
	/// 53 手术01ID
	s entity.Oper01ID = ""
	//w !,"53:entity.Oper01ID: "_entity.Oper01ID
	/// 54 手术01编码
	s entity.Oper01Code = Glossary.GetAt("HDSD00.19.089")
	//w !,"54:entity.Oper01Code: "_entity.Oper01Code
	/// 55 手术01描述
	s entity.Oper01Desc = Glossary.GetAt("HDSD00.19.090")
	//w !,"55:entity.Oper01Desc: "_entity.Oper01Desc
	/// 56 手术01等级
	s entity.Oper01Level = Glossary.GetAt("HDSD00.19.605")
	//w !,"56:entity.Oper01Level: "_entity.Oper01Level
	/// 57 手术01日期
	s entity.Oper01Date = Glossary.GetAt("HDSD00.19.091")
	//w !,"57:entity.Oper01Date: "_entity.Oper01Date
	/// 58 手术01操作医师ID
	s entity.Oper01DocID = ""
	//w !,"58:entity.Oper01DocID: "_entity.Oper01DocID
	/// 59 手术01操作医师姓名
	s entity.Oper01DocName = Glossary.GetAt("HDSD00.19.094")
	//w !,"59:entity.Oper01DocName: "_entity.Oper01DocName
	/// 60 手术01一助ID
	s entity.Oper01Assist1ID = ""
	//w !,"60:entity.Oper01Assist1ID: "_entity.Oper01Assist1ID
	/// 61 手术01一助姓名
	s entity.Oper01Assist1Name = Glossary.GetAt("HDSD00.19.001")
	//w !,"61:entity.Oper01Assist1Name: "_entity.Oper01Assist1Name
	/// 62 手术01二助ID
	s entity.Oper01Assist2ID = ""
	//w !,"62:entity.Oper01Assist2ID: "_entity.Oper01Assist2ID
	/// 63 手术01二助姓名
	s entity.Oper01Assist2Name = Glossary.GetAt("HDSD00.19.002")
	//w !,"63:entity.Oper01Assist2Name: "_entity.Oper01Assist2Name
	/// 64 手术01切口愈合等级
	s entity.Oper01CutLevel = Glossary.GetAt("HDSD00.19.616")
	//w !,"64:entity.Oper01CutLevel: "_entity.Oper01CutLevel
	/// 65 手术01麻醉方式
	s entity.Oper01AnaMethod = Glossary.GetAt("HDSD00.19.852")
	//w !,"65:entity.Oper01AnaMethod: "_entity.Oper01AnaMethod
	/// 66 手术01麻醉医师ID
	s entity.Oper01AnaDocID = ""
	//w !,"66:entity.Oper01AnaDocID: "_entity.Oper01AnaDocID
	/// 67 手术01麻醉医师姓名
	s entity.Oper01AnaDocName = Glossary.GetAt("HDSD00.19.074")
	//w !,"67:entity.Oper01AnaDocName: "_entity.Oper01AnaDocName
	
	/// 68 手术02ID
	s entity.Oper02ID = ""
	//w !,"68:entity.Oper02ID: "_entity.Oper02ID
	/// 69 手术02编码
	s entity.Oper02Code = Glossary.GetAt("HDSD00.19.410")
	//w !,"69:entity.Oper02Code: "_entity.Oper02Code
	/// 70 手术02描述
	s entity.Oper02Desc = Glossary.GetAt("HDSD00.19.414")
	//w !,"70:entity.Oper02Desc: "_entity.Oper02Desc
	/// 71 手术02等级
	s entity.Oper02Level = Glossary.GetAt("HDSD00.19.606")
	//w !,"71:entity.Oper02Level: "_entity.Oper02Level
	/// 72 手术02日期
	s entity.Oper02Date = Glossary.GetAt("HDSD00.19.411")
	//w !,"72:entity.Oper02Date: "_entity.Oper02Date
	/// 73 手术02操作医师ID
	s entity.Oper02DocID = ""
	//w !,"73:entity.Oper02DocID: "_entity.Oper02DocID
	/// 74 手术02操作医师姓名
	s entity.Oper02DocName =Glossary.GetAt("HDSD00.19.416")
	//w !,"74:entity.Oper02DocName: "_entity.Oper02DocName
	/// 75 手术02一助ID
	s entity.Oper02Assist1ID = ""
	//w !,"75:entity.Oper02Assist1ID: "_entity.Oper02Assist1ID
	/// 76 手术02一助姓名
	s entity.Oper02Assist1Name = Glossary.GetAt("HDSD00.19.418")
	//w !,"76:entity.Oper02Assist1Name: "_entity.Oper02Assist1Name
	/// 77 手术02二助ID
	s entity.Oper02Assist2ID = ""
	//w !,"77:entity.Oper02Assist2ID: "_entity.Oper02Assist2ID
	/// 78 手术02二助姓名
	s entity.Oper02Assist2Name = Glossary.GetAt("HDSD00.19.420")
	//w !,"78:entity.Oper02Assist2Name: "_entity.Oper02Assist2Name
	/// 79 手术02切口愈合等级
	s entity.Oper02CutLevel = Glossary.GetAt("HDSD00.19.618")
	//w !,"79:entity.Oper02CutLevel: "_entity.Oper02CutLevel
	/// 80 手术02麻醉方式
	s entity.Oper02AnaMethod = Glossary.GetAt("HDSD00.19.853")
	//w !,"80:entity.Oper02AnaMethod: "_entity.Oper02AnaMethod
	/// 81 手术02麻醉医师ID
	s entity.Oper02AnaDocID = ""
	//w !,"81:entity.Oper02AnaDocID: "_entity.Oper02AnaDocID
	/// 82 手术02麻醉医师姓名
	s entity.Oper02AnaDocName = Glossary.GetAt("HDSD00.19.424")
	//w !,"82:entity.Oper02AnaDocName: "_entity.Oper02AnaDocName
	
	/// 83 手术03ID
	s entity.Oper03ID = ""
	//w !,"83:entity.Oper03ID: "_entity.Oper03ID
	/// 84 手术03编码
	s entity.Oper03Code = Glossary.GetAt("HDSD00.19.425")
	//w !,"84:entity.Oper03Code: "_entity.Oper03Code
	/// 85 手术03描述
	s entity.Oper03Desc = Glossary.GetAt("HDSD00.19.429")
	//w !,"85:entity.Oper03Desc: "_entity.Oper03Desc
	/// 86 手术03等级
	s entity.Oper03Level = Glossary.GetAt("HDSD00.19.607")
	//w !,"86:entity.Oper03Level: "_entity.Oper03Level
	/// 87 手术03日期
	s entity.Oper03Date = Glossary.GetAt("HDSD00.19.426")
	//w !,"87:entity.Oper03Date: "_entity.Oper03Date
	/// 88 手术03操作医师ID
	s entity.Oper03DocID = ""
	//w !,"88:entity.Oper03DocID: "_entity.Oper03DocID
	/// 89 手术03操作医师姓名
	s entity.Oper03DocName = Glossary.GetAt("HDSD00.19.431")
	//w !,"89:entity.Oper03DocName: "_entity.Oper03DocName
	/// 90 手术03一助ID
	s entity.Oper03Assist1ID = ""
	//w !,"90:entity.Oper03Assist1ID: "_entity.Oper03Assist1ID
	/// 91 手术03一助姓名
	s entity.Oper03Assist1Name = Glossary.GetAt("HDSD00.19.433")
	//w !,"91:entity.Oper03Assist1Name: "_entity.Oper03Assist1Name
	/// 92 手术03二助ID
	s entity.Oper03Assist2ID = ""
	//w !,"92:entity.Oper03Assist2ID: "_entity.Oper03Assist2ID
	/// 93 手术03二助姓名
	s entity.Oper03Assist2Name = Glossary.GetAt("HDSD00.19.435")
	//w !,"93:entity.Oper03Assist2Name: "_entity.Oper03Assist2Name
	/// 94 手术03切口愈合等级
	s entity.Oper03CutLevel = Glossary.GetAt("HDSD00.19.620")
	//w !,"94:entity.Oper03CutLevel: "_entity.Oper03CutLevel
	/// 95 手术03麻醉方式
	s entity.Oper03AnaMethod = Glossary.GetAt("HDSD00.19.854")
	//w !,"95:entity.Oper03AnaMethod: "_entity.Oper03AnaMethod
	/// 96 手术03麻醉医师ID
	s entity.Oper03AnaDocID = ""
	//w !,"96:entity.Oper03AnaDocID: "_entity.Oper03AnaDocID
	/// 97 手术03麻醉医师姓名
	s entity.Oper03AnaDocName = Glossary.GetAt("HDSD00.19.439")
	//w !,"97:entity.Oper03AnaDocName: "_entity.Oper03AnaDocName
	
	/// 98 手术04ID
	s entity.Oper04ID = ""
	//w !,"98:entity.Oper04ID: "_entity.Oper04ID
	/// 99 手术04编码
	s entity.Oper04Code = Glossary.GetAt("HDSD00.19.440")
	//w !,"99:entity.Oper04Code: "_entity.Oper04Code
	/// 100 手术04描述
	s entity.Oper04Desc = Glossary.GetAt("HDSD00.19.444")
	//w !,"100:entity.Oper04Desc: "_entity.Oper04Desc
	/// 101 手术04等级
	s entity.Oper04Level = Glossary.GetAt("HDSD00.19.608")
	//w !,"101:entity.Oper04Level: "_entity.Oper04Level
	/// 102 手术04日期
	s entity.Oper04Date = Glossary.GetAt("HDSD00.19.441")
	//w !,"102:entity.Oper04Date: "_entity.Oper04Date
	/// 103 手术04操作医师ID
	s entity.Oper04DocID = ""
	//w !,"103:entity.Oper04DocID: "_entity.Oper04DocID
	/// 104 手术04操作医师姓名
	s entity.Oper04DocName = Glossary.GetAt("HDSD00.19.446")
	//w !,"104:entity.Oper04DocName: "_entity.Oper04DocName
	/// 105 手术04一助ID
	s entity.Oper04Assist1ID = ""
	//w !,"105:entity.Oper04Assist1ID: "_entity.Oper04Assist1ID
	/// 106 手术04一助姓名
	s entity.Oper04Assist1Name = Glossary.GetAt("HDSD00.19.448")
	//w !,"106:entity.Oper04Assist1Name: "_entity.Oper04Assist1Name
	/// 107 手术04二助ID
	s entity.Oper04Assist2ID = ""
	//w !,"107:entity.Oper04Assist2ID: "_entity.Oper04Assist2ID
	/// 108 手术04二助姓名
	s entity.Oper04Assist2Name = Glossary.GetAt("HDSD00.19.450")
	//w !,"108:entity.Oper04Assist2Name: "_entity.Oper04Assist2Name
	/// 109 手术04切口愈合等级
	s entity.Oper04CutLevel = Glossary.GetAt("HDSD00.19.622")
	//w !,"109:entity.Oper04CutLevel: "_entity.Oper04CutLevel
	/// 110 手术04麻醉方式
	s entity.Oper04AnaMethod = Glossary.GetAt("HDSD00.19.855")
	//w !,"110:entity.Oper04AnaMethod: "_entity.Oper04AnaMethod
	/// 111 手术04麻醉医师ID
	s entity.Oper04AnaDocID = ""
	//w !,"111:entity.Oper04AnaDocID: "_entity.Oper04AnaDocID
	/// 112 手术04麻醉医师姓名
	s entity.Oper04AnaDocName = Glossary.GetAt("HDSD00.19.454")
	//w !,"112:entity.Oper04AnaDocName: "_entity.Oper04AnaDocName
	
	/// 113 手术05ID
	s entity.Oper05ID = ""
	//w !,"113:entity.Oper05ID: "_entity.Oper05ID
	/// 114 手术05编码
	s entity.Oper05Code = Glossary.GetAt("HDSD00.19.455")
	//w !,"114:entity.Oper05Code: "_entity.Oper05Code
	/// 115 手术05描述
	s entity.Oper05Desc = Glossary.GetAt("HDSD00.19.459")
	//w !,"115:entity.Oper05Desc: "_entity.Oper05Desc
	/// 116 手术05等级
	s entity.Oper05Level = Glossary.GetAt("HDSD00.19.609")
	//w !,"116:entity.Oper05Level: "_entity.Oper05Level
	/// 117 手术05日期
	s entity.Oper05Date = Glossary.GetAt("HDSD00.19.456")
	//w !,"117:entity.Oper05Date: "_entity.Oper05Date
	/// 118 手术05操作医师ID
	s entity.Oper05DocID = ""
	//w !,"118:entity.Oper05DocID: "_entity.Oper05DocID
	/// 119 手术05操作医师姓名
	s entity.Oper05DocName = Glossary.GetAt("HDSD00.19.461")
	//w !,"119:entity.Oper05DocName: "_entity.Oper05DocName
	/// 120 手术05一助ID
	s entity.Oper05Assist1ID = ""
	//w !,"120:entity.Oper05Assist1ID: "_entity.Oper05Assist1ID
	/// 121 手术05一助姓名
	s entity.Oper05Assist1Name = Glossary.GetAt("HDSD00.19.463")
	//w !,"121:entity.Oper05Assist1Name: "_entity.Oper05Assist1Name
	/// 122 手术05二助ID
	s entity.Oper05Assist2ID = ""
	//w !,"122:entity.Oper05Assist2ID: "_entity.Oper05Assist2ID
	/// 123 手术05二助姓名
	s entity.Oper05Assist2Name = Glossary.GetAt("HDSD00.19.465")
	//w !,"123:entity.Oper05Assist2Name: "_entity.Oper05Assist2Name
	/// 124 手术05切口愈合等级
	s entity.Oper05CutLevel = Glossary.GetAt("HDSD00.19.62")
	//w !,"124:entity.Oper05CutLevel: "_entity.Oper05CutLevel
	/// 125 手术05麻醉方式
	s entity.Oper05AnaMethod = Glossary.GetAt("HDSD00.19.856")
	//w !,"125:entity.Oper05AnaMethod: "_entity.Oper05AnaMethod
	/// 126 手术05麻醉医师ID
	s entity.Oper05AnaDocID = ""
	//w !,"126:entity.Oper05AnaDocID: "_entity.Oper05AnaDocID
	/// 127 手术05麻醉医师姓名
	s entity.Oper05AnaDocName = Glossary.GetAt("HDSD00.19.469")
	//w !,"127:entity.Oper05AnaDocName: "_entity.Oper05AnaDocName
	
	/// 128 手术06ID
	s entity.Oper06ID = ""
	//w !,"128:entity.Oper06ID: "_entity.Oper06ID
	/// 129 手术06编码
	s entity.Oper06Code = Glossary.GetAt("HDSD00.19.470")
	//w !,"129:entity.Oper06Code: "_entity.Oper06Code
	/// 130 手术06描述
	s entity.Oper06Desc = Glossary.GetAt("HDSD00.19.474")
	//w !,"130:entity.Oper06Desc: "_entity.Oper06Desc
	/// 131 手术06等级
	s entity.Oper06Level = Glossary.GetAt("HDSD00.19.610")
	//w !,"131:entity.Oper06Level: "_entity.Oper06Level
	/// 132 手术06日期
	s entity.Oper06Date = Glossary.GetAt("HDSD00.19.471")
	//w !,"132:entity.Oper06Date: "_entity.Oper06Date
	/// 133 手术06操作医师ID
	s entity.Oper06DocID = ""
	//w !,"133:entity.Oper06DocID: "_entity.Oper06DocID
	/// 134 手术06操作医师姓名
	s entity.Oper06DocName = Glossary.GetAt("HDSD00.19.476")
	//w !,"134:entity.Oper06DocName: "_entity.Oper06DocName
	/// 135 手术06一助ID
	s entity.Oper06Assist1ID = ""
	//w !,"135:entity.Oper06Assist1ID: "_entity.Oper06Assist1ID
	/// 136 手术06一助姓名
	s entity.Oper06Assist1Name = Glossary.GetAt("HDSD00.19.478")
	//w !,"136:entity.Oper06Assist1Name: "_entity.Oper06Assist1Name
	/// 137 手术06二助ID
	s entity.Oper06Assist2ID = ""
	//w !,"137:entity.Oper06Assist2ID: "_entity.Oper06Assist2ID
	/// 138 手术06二助姓名
	s entity.Oper06Assist2Name = Glossary.GetAt("HDSD00.19.480")
	//w !,"138:entity.Oper06Assist2Name: "_entity.Oper06Assist2Name
	/// 139 手术06切口愈合等级
	s entity.Oper06CutLevel = Glossary.GetAt("HDSD00.19.626")
	//w !,"139:entity.Oper06CutLevel: "_entity.Oper06CutLevel
	/// 140 手术06麻醉方式
	s entity.Oper06AnaMethod = Glossary.GetAt("HDSD00.19.857")
	//w !,"140:entity.Oper06AnaMethod: "_entity.Oper06AnaMethod
	/// 141 手术06麻醉医师ID
	s entity.Oper06AnaDocID = ""
	//w !,"141:entity.Oper06AnaDocID: "_entity.Oper06AnaDocID
	/// 142 手术06麻醉医师姓名
	s entity.Oper06AnaDocName = Glossary.GetAt("HDSD00.19.484")
	//w !,"142:entity.Oper06AnaDocName: "_entity.Oper06AnaDocName
	
	/// 143 手术07ID
	s entity.Oper07ID = ""
	//w !,"143:entity.Oper07ID: "_entity.Oper07ID
	/// 144 手术07编码
	s entity.Oper07Code = ""
	//w !,"144:entity.Oper07Code: "_entity.Oper07Code
	/// 145 手术07描述
	s entity.Oper07Desc = ""
	//w !,"145:entity.Oper07Desc: "_entity.Oper07Desc
	/// 146 手术07等级
	s entity.Oper07Level = ""
	//w !,"146:entity.Oper07Level: "_entity.Oper07Level
	/// 147 手术07日期
	s entity.Oper07Date = ""
	//w !,"147:entity.Oper07Date: "_entity.Oper07Date
	/// 148 手术07操作医师ID
	s entity.Oper07DocID = ""
	//w !,"148:entity.Oper07DocID: "_entity.Oper07DocID
	/// 149 手术07操作医师姓名
	s entity.Oper07DocName = ""
	//w !,"149:entity.Oper07DocName: "_entity.Oper07DocName
	/// 150 手术07一助ID
	s entity.Oper07Assist1ID = ""
	//w !,"150:entity.Oper07Assist1ID: "_entity.Oper07Assist1ID
	/// 151 手术07一助姓名
	s entity.Oper07Assist1Name = ""
	//w !,"151:entity.Oper07Assist1Name: "_entity.Oper07Assist1Name
	/// 152 手术07二助ID
	s entity.Oper07Assist2ID = ""
	//w !,"152:entity.Oper07Assist2ID: "_entity.Oper07Assist2ID
	/// 153 手术07二助姓名
	s entity.Oper07Assist2Name = ""
	//w !,"153:entity.Oper07Assist2Name: "_entity.Oper07Assist2Name
	/// 154 手术07切口愈合等级
	s entity.Oper07CutLevel = ""
	//w !,"154:entity.Oper07CutLevel: "_entity.Oper07CutLevel
	/// 155 手术07麻醉方式
	s entity.Oper07AnaMethod = ""
	//w !,"155:entity.Oper07AnaMethod: "_entity.Oper07AnaMethod
	/// 156 手术07麻醉医师ID
	s entity.Oper07AnaDocID = ""
	//w !,"156:entity.Oper07AnaDocID: "_entity.Oper07AnaDocID
	/// 157 手术07麻醉医师姓名
	s entity.Oper07AnaDocName = ""
	//w !,"157:entity.Oper07AnaDocName: "_entity.Oper07AnaDocName
	
	/// 158 手术08ID
	s entity.Oper08ID = ""
	//w !,"158:entity.Oper08ID: "_entity.Oper08ID
	/// 159 手术08编码
	s entity.Oper08Code = ""
	//w !,"159:entity.Oper08Code: "_entity.Oper08Code
	/// 160 手术08描述
	s entity.Oper08Desc = ""
	//w !,"160:entity.Oper08Desc: "_entity.Oper08Desc
	/// 161 手术08等级
	s entity.Oper08Level = ""
	//w !,"161:entity.Oper08Level: "_entity.Oper08Level
	/// 162 手术08日期
	s entity.Oper08Date =""
	//w !,"162:entity.Oper08Date: "_entity.Oper08Date
	/// 163 手术08操作医师ID
	s entity.Oper08DocID = ""
	//w !,"163:entity.Oper08DocID: "_entity.Oper08DocID
	/// 164 手术08操作医师姓名
	s entity.Oper08DocName = ""
	//w !,"164:entity.Oper08DocName: "_entity.Oper08DocName
	/// 165 手术08一助ID
	s entity.Oper08Assist1ID = ""
	//w !,"165:entity.Oper08Assist1ID: "_entity.Oper08Assist1ID
	/// 166 手术08一助姓名
	s entity.Oper08Assist1Name = ""
	//w !,"166:entity.Oper08Assist1Name: "_entity.Oper08Assist1Name
	/// 167 手术08二助ID
	s entity.Oper08Assist2ID = ""
	//w !,"167:entity.Oper08Assist2ID: "_entity.Oper08Assist2ID
	/// 168 手术08二助姓名
	s entity.Oper08Assist2Name = ""
	//w !,"168:entity.Oper08Assist2Name: "_entity.Oper08Assist2Name
	/// 169 手术08切口愈合等级
	s entity.Oper08CutLevel = ""
	//w !,"169:entity.Oper08CutLevel: "_entity.Oper08CutLevel
	/// 170 手术08麻醉方式
	s entity.Oper08AnaMethod = ""
	//w !,"170:entity.Oper08AnaMethod: "_entity.Oper08AnaMethod
	/// 171 手术08麻醉医师ID
	s entity.Oper08AnaDocID = ""
	//w !,"171:entity.Oper08AnaDocID: "_entity.Oper08AnaDocID
	/// 172 手术08麻醉医师姓名
	s entity.Oper08AnaDocName = ""
	//w !,"172:entity.Oper08AnaDocName: "_entity.Oper08AnaDocName
	
	//b "s"
	/// 173 门急诊诊断ID
	s entity.DiagOutID = ""
	//w !,"173:entity.DiagOutID: "_entity.DiagOutID
	/// 174 门急诊诊断编码
	s entity.DiagOutCode = Glossary.GetAt("HDSD00.19.075")
	//w !,"174:entity.DiagOutCode: "_entity.DiagOutCode
	/// 175 门急诊诊断描述
	s entity.DiagOutDesc = Glossary.GetAt("HDSD00.19.076")
	//w !,"175:entity.DiagOutDesc: "_entity.DiagOutDesc
	
	/// 176 入院诊断ID
	s entity.DiagAdmID = ""
	//w !,"176:entity.DiagAdmID: "_entity.DiagAdmID
	/// 177 入院诊断编码
	s entity.DiagAdmCode = ""
	//w !,"177:entity.DiagAdmCode: "_entity.DiagAdmCode
	/// 178 入院诊断描述
	s entity.DiagAdmDesc = ""
	//w !,"178:entity.DiagAdmDesc: "_entity.DiagAdmDesc
	
	/// 179 入院诊断入院情况
	s entity.DiagAdmState = ""
	//w !,"179:entity.DiagAdmState: "_entity.DiagAdmState
	
	/// 180 病理诊断
	s entity.DiagPathDesc = Glossary.GetAt("HDSD00.19.010")
	//w !,"180:entity.DiagPathDesc: "_entity.DiagPathDesc
	
	/// 181 病理诊断代码
	s entity.DiagPathCode = Glossary.GetAt("HDSD00.19.009")
	//w !,"180:entity.DiagPathCode: "_entity.DiagPathCode
	q entity
}

/// 从医政组首页数据池取编目手术信息
/// debug: s entity = ##Class(DHCEPRFS.BL.BLMREpisodeFP).CreateEMREpisodeFPMRQ("update","1","5742458","DHC")
ClassMethod CreateEMREpisodeFPMRQ(AType As %String, AMRPatientID As %String, AEpisodeID As %String, ASysCode As %String) As DHCEPRFS.Entity.EMREpisodeFP
{
	//获取就诊的首页数据
	s arr = ##class(DHCEPRFS.BL.HISInfo.BLMRQInfo).GetArrayOfDataByAdm(AEpisodeID)
	//b "s"
	s entity = ##Class(DHCEPRFS.Entity.EMREpisodeFP).%New()
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
		s mrEpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_mrEpisodeID,""))
		if (mrEpisodeFPID = "")
		{
			s entity.CreateDate = $p($h,",",1)  
			s entity.CreateTime = $p($h,",",2)  //06
		}
		else
		{
			s obj = ##class(DHCEPRFS.INST.MREpisodeFP).%OpenId(mrEpisodeFPID)
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
	// 09 主要诊断ID
	s entity.DiagMainID = "P21010100"
	//w !,"9:entity.DiagMainID: "_entity.DiagMainID
	// 10 主要诊断编码
	s entity.DiagMainCode = arr.GetAt("P21010101")
	//w !,"10:entity.DiagMainCode: "_entity.DiagMainCode
	/// 11 主要诊断描述
	s entity.DiagMainDesc = arr.GetAt("P21010100")
	//w !,"11:entity.DiagMainDesc: "_entity.DiagMainDesc
	/// 12 主要诊断入院病情
	s entity.DiagMainState = arr.GetAt("P21010200")
	//w !,"12:entity.DiagMainState: "_entity.DiagMainState
	
	/// 13 其它诊断01ID    
	s entity.Diag01ID = "P22010100"
	//w !,"13:entity.Diag01ID: "_entity.Diag01ID	
	/// 14 其它诊断01编码
	s entity.Diag01Code = arr.GetAt("P22010101")
	//w !,"14:entity.Diag01Code: "_entity.Diag01Code	
	/// 15 其它诊断01描述
	s entity.Diag01Desc = arr.GetAt("P22010100")
	//w !,"15:entity.Diag01Desc: "_entity.Diag01Desc	
	/// 16 其它诊断01入院病情
	s entity.Diag01State = arr.GetAt("P22010200")
	//w !,"16:entity.Diag01State: "_entity.Diag01State
	
	/// 17 其它诊断02ID    
	s entity.Diag02ID = "P22020100"
	//w !,"17:entity.Diag02ID: "_entity.Diag02ID	
	/// 18 其它诊断02编码
	s entity.Diag02Code = arr.GetAt("P22020101")
	//w !,"18:entity.Diag02Code: "_entity.Diag02Code	
	/// 19 其它诊断02描述
	s entity.Diag02Desc = arr.GetAt("P22020100")
	//w !,"19:entity.Diag02Desc: "_entity.Diag02Desc
	/// 20 其它诊断02入院病情
	s entity.Diag02State = arr.GetAt("P22020200")
	//w !,"20:entity.Diag02State: "_entity.Diag02State
	
	/// 21 其它诊断03ID    
	s entity.Diag03ID = "P22030100"
	//w !,"21:entity.Diag03ID: "_entity.Diag03ID	
	/// 22 其它诊断03编码
	s entity.Diag03Code = arr.GetAt("P22030101")
	//w !,"22:entity.Diag03Code: "_entity.Diag03Code	
	/// 23 其它诊断03描述
	s entity.Diag03Desc = arr.GetAt("P22030100")
	//w !,"23:entity.Diag03Desc: "_entity.Diag03Desc	
	/// 24 其它诊断03入院病情
	s entity.Diag03State = arr.GetAt("P22030200")
	//w !,"24:entity.Diag03State: "_entity.Diag03State
	
	/// 25 其它诊断04ID    
	s entity.Diag04ID = "P22040100"
	//w !,"25:entity.Diag04ID: "_entity.Diag04ID
	/// 26 其它诊断04编码
	s entity.Diag04Code = arr.GetAt("P22040101")
	//w !,"26:entity.Diag04Code: "_entity.Diag04Code	
	/// 27 其它诊断04描述
	s entity.Diag04Desc = arr.GetAt("P22040100")
	//w !,"27:entity.Diag04Desc: "_entity.Diag04Desc	
	/// 28 其它诊断04入院病情
	s entity.Diag04State = arr.GetAt("P22040200")
	//w !,"28:entity.Diag04State: "_entity.Diag04State
	
	/// 29 其它诊断05ID    
	s entity.Diag05ID = "P22050100"
	//w !,"29:entity.Diag05ID: "_entity.Diag05ID
	/// 30 其它诊断05编码
	s entity.Diag05Code = arr.GetAt("P22050101")
	//w !,"30:entity.Diag05Code: "_entity.Diag05Code
	/// 31 其它诊断05描述
	s entity.Diag05Desc = arr.GetAt("P22050100")
	//w !,"31:entity.Diag05Desc: "_entity.Diag05Desc
	/// 32 其它诊断05入院病情
	s entity.Diag05State = arr.GetAt("P22050200")
	//w !,"32:entity.Diag05State: "_entity.Diag05State
	
	/// 33 其它诊断06ID    
	s entity.Diag06ID = "P22060100"
	//w !,"33:entity.Diag06ID: "_entity.Diag06ID
	/// 34 其它诊断06编码
	s entity.Diag06Code = arr.GetAt("P22060101")
	//w !,"34:entity.Diag06Code: "_entity.Diag06Code
	/// 35 其它诊断06描述
	s entity.Diag06Desc = arr.GetAt("P22060100")
	//w !,"35:entity.Diag06Desc: "_entity.Diag06Desc
	/// 36 其它诊断06入院病情
	s entity.Diag06State = arr.GetAt("P22060200")
	//w !,"36:entity.Diag06State: "_entity.Diag06State
	
	/// 37 其它诊断07ID    
	s entity.Diag07ID = "P22070100"
	//w !,"37:entity.Diag07ID: "_entity.Diag07ID
	/// 38 其它诊断07编码
	s entity.Diag07Code = arr.GetAt("P22070101")
	//w !,"38:entity.Diag07Code: "_entity.Diag07Code	
	/// 39 其它诊断07描述
	s entity.Diag07Desc = arr.GetAt("P22070100")
	//w !,"39:entity.Diag07Desc: "_entity.Diag07Desc	
	/// 40 其它诊断07入院病情
	s entity.Diag07State = arr.GetAt("P22070200")
	//w !,"40:entity.Diag07State: "_entity.Diag07State
	
	/// 41 其它诊断08ID    
	s entity.Diag08ID = "P22080100"
	//w !,"41:entity.Diag08ID: "_entity.Diag08ID	
	/// 42 其它诊断08编码
	s entity.Diag08Code = arr.GetAt("P22080101")
	//w !,"42:entity.Diag08Code: "_entity.Diag08Code
	/// 43 其它诊断08描述
	s entity.Diag08Desc = arr.GetAt("P22080100")
	//w !,"43:entity.Diag08Desc: "_entity.Diag08Desc
	/// 44 其它诊断08入院病情
	s entity.Diag08State = arr.GetAt("P22080200")
	//w !,"44:entity.Diag08State: "_entity.Diag08State
	
	/// 45 其它诊断09ID    
	s entity.Diag09ID = "P22090100"
	//w !,"45:entity.Diag09ID: "_entity.Diag09ID
	/// 46 其它诊断09编码
	s entity.Diag09Code = arr.GetAt("P22090101")
	//w !,"46:entity.Diag09Code: "_entity.Diag09Code
	/// 47 其它诊断09描述
	s entity.Diag09Desc = arr.GetAt("P22090100")
	//w !,"47:entity.Diag09Desc: "_entity.Diag09Desc
	/// 48 其它诊断09入院病情
	s entity.Diag09State = arr.GetAt("P22090200")
	//w !,"48:entity.Diag09State: "_entity.Diag09State
	
	/// 49 其它诊断10ID    
	s entity.Diag10ID = "P22100100"
	//w !,"49:entity.Diag10ID: "_entity.Diag10ID
	/// 50 其它诊断10编码
	s entity.Diag10Code = arr.GetAt("P22100101")
	//w !,"50:entity.Diag10Code: "_entity.Diag10Code
	/// 51 其它诊断10描述
	s entity.Diag10Desc = arr.GetAt("P22100100")
	//w !,"51:entity.Diag10Desc: "_entity.Diag10Desc
	/// 52 其它诊断10入院病情
	s entity.Diag10State = arr.GetAt("P22100200")
	//w !,"52:entity.Diag10State: "_entity.Diag10State
	
	//b "s"
	
	/// 53 手术01ID
	s entity.Oper01ID = "P40010100"
	//w !,"53:entity.Oper01ID: "_entity.Oper01ID
	/// 54 手术01编码
	s entity.Oper01Code = arr.GetAt("P40010101")
	//w !,"54:entity.Oper01Code: "_entity.Oper01Code
	/// 55 手术01描述
	s entity.Oper01Desc = arr.GetAt("P40010100")
	//w !,"55:entity.Oper01Desc: "_entity.Oper01Desc
	/// 56 手术01等级
	s entity.Oper01Level = arr.GetAt("P40010300")
	//w !,"56:entity.Oper01Level: "_entity.Oper01Level
	/// 57 手术01日期
	s entity.Oper01Date = arr.GetAt("P40010200")
	//w !,"57:entity.Oper01Date: "_entity.Oper01Date
	/// 58 手术01操作医师ID
	s entity.Oper01DocID = arr.GetAt("P40010401")
	//w !,"58:entity.Oper01DocID: "_entity.Oper01DocID
	/// 59 手术01操作医师姓名
	s entity.Oper01DocName = arr.GetAt("P40010400")
	//w !,"59:entity.Oper01DocName: "_entity.Oper01DocName
	/// 60 手术01一助ID
	s entity.Oper01Assist1ID = arr.GetAt("P40010501")
	//w !,"60:entity.Oper01Assist1ID: "_entity.Oper01Assist1ID
	/// 61 手术01一助姓名
	s entity.Oper01Assist1Name = arr.GetAt("P40010500")
	//w !,"61:entity.Oper01Assist1Name: "_entity.Oper01Assist1Name
	/// 62 手术01二助ID
	s entity.Oper01Assist2ID = arr.GetAt("P40010601")
	//w !,"62:entity.Oper01Assist2ID: "_entity.Oper01Assist2ID
	/// 63 手术01二助姓名
	s entity.Oper01Assist2Name = arr.GetAt("P40010600")
	//w !,"63:entity.Oper01Assist2Name: "_entity.Oper01Assist2Name
	/// 64 手术01切口愈合等级
	s entity.Oper01CutLevel = arr.GetAt("P40010800")
	//w !,"64:entity.Oper01CutLevel: "_entity.Oper01CutLevel
	/// 65 手术01麻醉方式
	s entity.Oper01AnaMethod = arr.GetAt("P40010700")
	//w !,"65:entity.Oper01AnaMethod: "_entity.Oper01AnaMethod
	/// 66 手术01麻醉医师ID
	s entity.Oper01AnaDocID = arr.GetAt("P40010902")
	//w !,"66:entity.Oper01AnaDocID: "_entity.Oper01AnaDocID
	/// 67 手术01麻醉医师姓名
	s entity.Oper01AnaDocName = arr.GetAt("P40010900")
	//w !,"67:entity.Oper01AnaDocName: "_entity.Oper01AnaDocName
	
	/// 68 手术02ID
	s entity.Oper02ID = "P40020100"
	//w !,"68:entity.Oper02ID: "_entity.Oper02ID
	/// 69 手术02编码
	s entity.Oper02Code = arr.GetAt("P40020101")
	//w !,"69:entity.Oper02Code: "_entity.Oper02Code
	/// 70 手术02描述
	s entity.Oper02Desc = arr.GetAt("P40020100")
	//w !,"70:entity.Oper02Desc: "_entity.Oper02Desc
	/// 71 手术02等级
	s entity.Oper02Level = arr.GetAt("P40020300")
	//w !,"71:entity.Oper02Level: "_entity.Oper02Level
	/// 72 手术02日期
	s entity.Oper02Date = arr.GetAt("P40020200")
	//w !,"72:entity.Oper02Date: "_entity.Oper02Date
	/// 73 手术02操作医师ID
	s entity.Oper02DocID = arr.GetAt("P40020401")
	//w !,"73:entity.Oper02DocID: "_entity.Oper02DocID
	/// 74 手术02操作医师姓名
	s entity.Oper02DocName = arr.GetAt("P40020400")
	//w !,"74:entity.Oper02DocName: "_entity.Oper02DocName
	/// 75 手术02一助ID
	s entity.Oper02Assist1ID = arr.GetAt("P40020501")
	//w !,"75:entity.Oper02Assist1ID: "_entity.Oper02Assist1ID
	/// 76 手术02一助姓名
	s entity.Oper02Assist1Name = arr.GetAt("P40020500")
	//w !,"76:entity.Oper02Assist1Name: "_entity.Oper02Assist1Name
	/// 77 手术02二助ID
	s entity.Oper02Assist2ID = arr.GetAt("P40020601")
	//w !,"77:entity.Oper02Assist2ID: "_entity.Oper02Assist2ID
	/// 78 手术02二助姓名
	s entity.Oper02Assist2Name = arr.GetAt("P40020600")
	//w !,"78:entity.Oper02Assist2Name: "_entity.Oper02Assist2Name
	/// 79 手术02切口愈合等级
	s entity.Oper02CutLevel = arr.GetAt("P40020800")
	//w !,"79:entity.Oper02CutLevel: "_entity.Oper02CutLevel
	/// 80 手术02麻醉方式
	s entity.Oper02AnaMethod = arr.GetAt("P40020700")
	//w !,"80:entity.Oper02AnaMethod: "_entity.Oper02AnaMethod
	/// 81 手术02麻醉医师ID
	s entity.Oper02AnaDocID = arr.GetAt("P40020901")
	//w !,"81:entity.Oper02AnaDocID: "_entity.Oper02AnaDocID
	/// 82 手术02麻醉医师姓名
	s entity.Oper02AnaDocName = arr.GetAt("P40020900")
	//w !,"82:entity.Oper02AnaDocName: "_entity.Oper02AnaDocName
	
	/// 83 手术03ID
	s entity.Oper03ID = "P40030100"
	//w !,"83:entity.Oper03ID: "_entity.Oper03ID
	/// 84 手术03编码
	s entity.Oper03Code = arr.GetAt("P40030101")
	//w !,"84:entity.Oper03Code: "_entity.Oper03Code
	/// 85 手术03描述
	s entity.Oper03Desc = arr.GetAt("P40030100")
	//w !,"85:entity.Oper03Desc: "_entity.Oper03Desc
	/// 86 手术03等级
	s entity.Oper03Level = arr.GetAt("P40030300")
	//w !,"86:entity.Oper03Level: "_entity.Oper03Level
	/// 87 手术03日期
	s entity.Oper03Date = arr.GetAt("P40030200")
	//w !,"87:entity.Oper03Date: "_entity.Oper03Date
	/// 88 手术03操作医师ID
	s entity.Oper03DocID = arr.GetAt("P40030401")
	//w !,"88:entity.Oper03DocID: "_entity.Oper03DocID
	/// 89 手术03操作医师姓名
	s entity.Oper03DocName = arr.GetAt("P40030400")
	//w !,"89:entity.Oper03DocName: "_entity.Oper03DocName
	/// 90 手术03一助ID
	s entity.Oper03Assist1ID = arr.GetAt("P40030501")
	//w !,"90:entity.Oper03Assist1ID: "_entity.Oper03Assist1ID
	/// 91 手术03一助姓名
	s entity.Oper03Assist1Name = arr.GetAt("P40030500")
	//w !,"91:entity.Oper03Assist1Name: "_entity.Oper03Assist1Name
	/// 92 手术03二助ID
	s entity.Oper03Assist2ID = arr.GetAt("P40030601")
	//w !,"92:entity.Oper03Assist2ID: "_entity.Oper03Assist2ID
	/// 93 手术03二助姓名
	s entity.Oper03Assist2Name = arr.GetAt("P40030600")
	//w !,"93:entity.Oper03Assist2Name: "_entity.Oper03Assist2Name
	/// 94 手术03切口愈合等级
	s entity.Oper03CutLevel = arr.GetAt("P40030800")
	//w !,"94:entity.Oper03CutLevel: "_entity.Oper03CutLevel
	/// 95 手术03麻醉方式
	s entity.Oper03AnaMethod = arr.GetAt("P40030700")
	//w !,"95:entity.Oper03AnaMethod: "_entity.Oper03AnaMethod
	/// 96 手术03麻醉医师ID
	s entity.Oper03AnaDocID = arr.GetAt("P40030901")
	//w !,"96:entity.Oper03AnaDocID: "_entity.Oper03AnaDocID
	/// 97 手术03麻醉医师姓名
	s entity.Oper03AnaDocName = arr.GetAt("P40030900")
	//w !,"97:entity.Oper03AnaDocName: "_entity.Oper03AnaDocName
	
	/// 98 手术04ID
	s entity.Oper04ID = "P40040100"
	//w !,"98:entity.Oper04ID: "_entity.Oper04ID
	/// 99 手术04编码
	s entity.Oper04Code = arr.GetAt("P40040101")
	//w !,"99:entity.Oper04Code: "_entity.Oper04Code
	/// 100 手术04描述
	s entity.Oper04Desc = arr.GetAt("P40040100")
	//w !,"100:entity.Oper04Desc: "_entity.Oper04Desc
	/// 101 手术04等级
	s entity.Oper04Level = arr.GetAt("P40040300")
	//w !,"101:entity.Oper04Level: "_entity.Oper04Level
	/// 102 手术04日期
	s entity.Oper04Date = arr.GetAt("P40040200")
	//w !,"102:entity.Oper04Date: "_entity.Oper04Date
	/// 103 手术04操作医师ID
	s entity.Oper04DocID = arr.GetAt("P40040401")
	//w !,"103:entity.Oper04DocID: "_entity.Oper04DocID
	/// 104 手术04操作医师姓名
	s entity.Oper04DocName = arr.GetAt("P40040400")
	//w !,"104:entity.Oper04DocName: "_entity.Oper04DocName
	/// 105 手术04一助ID
	s entity.Oper04Assist1ID = arr.GetAt("P40040501")
	//w !,"105:entity.Oper04Assist1ID: "_entity.Oper04Assist1ID
	/// 106 手术04一助姓名
	s entity.Oper04Assist1Name = arr.GetAt("P40040500")
	//w !,"106:entity.Oper04Assist1Name: "_entity.Oper04Assist1Name
	/// 107 手术04二助ID
	s entity.Oper04Assist2ID = arr.GetAt("P40040601")
	//w !,"107:entity.Oper04Assist2ID: "_entity.Oper04Assist2ID
	/// 108 手术04二助姓名
	s entity.Oper04Assist2Name = arr.GetAt("P40040600")
	//w !,"108:entity.Oper04Assist2Name: "_entity.Oper04Assist2Name
	/// 109 手术04切口愈合等级
	s entity.Oper04CutLevel = arr.GetAt("P40040800")
	//w !,"109:entity.Oper04CutLevel: "_entity.Oper04CutLevel
	/// 110 手术04麻醉方式
	s entity.Oper04AnaMethod = arr.GetAt("P40040700")
	//w !,"110:entity.Oper04AnaMethod: "_entity.Oper04AnaMethod
	/// 111 手术04麻醉医师ID
	s entity.Oper04AnaDocID = arr.GetAt("P40040901")
	//w !,"111:entity.Oper04AnaDocID: "_entity.Oper04AnaDocID
	/// 112 手术04麻醉医师姓名
	s entity.Oper04AnaDocName = arr.GetAt("P40040900")
	//w !,"112:entity.Oper04AnaDocName: "_entity.Oper04AnaDocName
	
	/// 113 手术05ID
	s entity.Oper05ID = "P40050100"
	//w !,"113:entity.Oper05ID: "_entity.Oper05ID
	/// 114 手术05编码
	s entity.Oper05Code = arr.GetAt("P40050101")
	//w !,"114:entity.Oper05Code: "_entity.Oper05Code
	/// 115 手术05描述
	s entity.Oper05Desc = arr.GetAt("P40050100")
	//w !,"115:entity.Oper05Desc: "_entity.Oper05Desc
	/// 116 手术05等级
	s entity.Oper05Level = arr.GetAt("P40050300")
	//w !,"116:entity.Oper05Level: "_entity.Oper05Level
	/// 117 手术05日期
	s entity.Oper05Date = arr.GetAt("P40050200")
	//w !,"117:entity.Oper05Date: "_entity.Oper05Date
	/// 118 手术05操作医师ID
	s entity.Oper05DocID = arr.GetAt("P40050401")
	//w !,"118:entity.Oper05DocID: "_entity.Oper05DocID
	/// 119 手术05操作医师姓名
	s entity.Oper05DocName = arr.GetAt("P40050400")
	//w !,"119:entity.Oper05DocName: "_entity.Oper05DocName
	/// 120 手术05一助ID
	s entity.Oper05Assist1ID = arr.GetAt("P40050501")
	//w !,"120:entity.Oper05Assist1ID: "_entity.Oper05Assist1ID
	/// 121 手术05一助姓名
	s entity.Oper05Assist1Name = arr.GetAt("P40050500")
	//w !,"121:entity.Oper05Assist1Name: "_entity.Oper05Assist1Name
	/// 122 手术05二助ID
	s entity.Oper05Assist2ID = arr.GetAt("P40050601")
	//w !,"122:entity.Oper05Assist2ID: "_entity.Oper05Assist2ID
	/// 123 手术05二助姓名
	s entity.Oper05Assist2Name = arr.GetAt("P40050600")
	//w !,"123:entity.Oper05Assist2Name: "_entity.Oper05Assist2Name
	/// 124 手术05切口愈合等级
	s entity.Oper05CutLevel = arr.GetAt("P40050800")
	//w !,"124:entity.Oper05CutLevel: "_entity.Oper05CutLevel
	/// 125 手术05麻醉方式
	s entity.Oper05AnaMethod = arr.GetAt("P40050700")
	//w !,"125:entity.Oper05AnaMethod: "_entity.Oper05AnaMethod
	/// 126 手术05麻醉医师ID
	s entity.Oper05AnaDocID = arr.GetAt("P40050901")
	//w !,"126:entity.Oper05AnaDocID: "_entity.Oper05AnaDocID
	/// 127 手术05麻醉医师姓名
	s entity.Oper05AnaDocName = arr.GetAt("P40050900")
	//w !,"127:entity.Oper05AnaDocName: "_entity.Oper05AnaDocName
	
	/// 128 手术06ID
	s entity.Oper06ID = "P40060100"
	//w !,"128:entity.Oper06ID: "_entity.Oper06ID
	/// 129 手术06编码
	s entity.Oper06Code = arr.GetAt("P40060101")
	//w !,"129:entity.Oper06Code: "_entity.Oper06Code
	/// 130 手术06描述
	s entity.Oper06Desc = arr.GetAt("P40060100")
	//w !,"130:entity.Oper06Desc: "_entity.Oper06Desc
	/// 131 手术06等级
	s entity.Oper06Level = arr.GetAt("P40060300")
	//w !,"131:entity.Oper06Level: "_entity.Oper06Level
	/// 132 手术06日期
	s entity.Oper06Date = arr.GetAt("P40060200")
	//w !,"132:entity.Oper06Date: "_entity.Oper06Date
	/// 133 手术06操作医师ID
	s entity.Oper06DocID = arr.GetAt("P40060401")
	//w !,"133:entity.Oper06DocID: "_entity.Oper06DocID
	/// 134 手术06操作医师姓名
	s entity.Oper06DocName = arr.GetAt("P40060400")
	//w !,"134:entity.Oper06DocName: "_entity.Oper06DocName
	/// 135 手术06一助ID
	s entity.Oper06Assist1ID = arr.GetAt("P40060501")
	//w !,"135:entity.Oper06Assist1ID: "_entity.Oper06Assist1ID
	/// 136 手术06一助姓名
	s entity.Oper06Assist1Name = arr.GetAt("P40060500")
	//w !,"136:entity.Oper06Assist1Name: "_entity.Oper06Assist1Name
	/// 137 手术06二助ID
	s entity.Oper06Assist2ID = arr.GetAt("P40060601")
	//w !,"137:entity.Oper06Assist2ID: "_entity.Oper06Assist2ID
	/// 138 手术06二助姓名
	s entity.Oper06Assist2Name = arr.GetAt("P40060600")
	//w !,"138:entity.Oper06Assist2Name: "_entity.Oper06Assist2Name
	/// 139 手术06切口愈合等级
	s entity.Oper06CutLevel = arr.GetAt("P40060800")
	//w !,"139:entity.Oper06CutLevel: "_entity.Oper06CutLevel
	/// 140 手术06麻醉方式
	s entity.Oper06AnaMethod = arr.GetAt("P40060700")
	//w !,"140:entity.Oper06AnaMethod: "_entity.Oper06AnaMethod
	/// 141 手术06麻醉医师ID
	s entity.Oper06AnaDocID = arr.GetAt("P40060901")
	//w !,"141:entity.Oper06AnaDocID: "_entity.Oper06AnaDocID
	/// 142 手术06麻醉医师姓名
	s entity.Oper06AnaDocName = arr.GetAt("P40060900")
	//w !,"142:entity.Oper06AnaDocName: "_entity.Oper06AnaDocName
	
	/// 143 手术07ID
	s entity.Oper07ID = "P40070100"
	//w !,"143:entity.Oper07ID: "_entity.Oper07ID
	/// 144 手术07编码
	s entity.Oper07Code = arr.GetAt("P40070101")
	//w !,"144:entity.Oper07Code: "_entity.Oper07Code
	/// 145 手术07描述
	s entity.Oper07Desc = arr.GetAt("P40070100")
	//w !,"145:entity.Oper07Desc: "_entity.Oper07Desc
	/// 146 手术07等级
	s entity.Oper07Level = arr.GetAt("P40070300")
	//w !,"146:entity.Oper07Level: "_entity.Oper07Level
	/// 147 手术07日期
	s entity.Oper07Date = arr.GetAt("P40070200")
	//w !,"147:entity.Oper07Date: "_entity.Oper07Date
	/// 148 手术07操作医师ID
	s entity.Oper07DocID = arr.GetAt("P40070401")
	//w !,"148:entity.Oper07DocID: "_entity.Oper07DocID
	/// 149 手术07操作医师姓名
	s entity.Oper07DocName = arr.GetAt("P40070400")
	//w !,"149:entity.Oper07DocName: "_entity.Oper07DocName
	/// 150 手术07一助ID
	s entity.Oper07Assist1ID = arr.GetAt("P40070501")
	//w !,"150:entity.Oper07Assist1ID: "_entity.Oper07Assist1ID
	/// 151 手术07一助姓名
	s entity.Oper07Assist1Name = arr.GetAt("P40070500")
	//w !,"151:entity.Oper07Assist1Name: "_entity.Oper07Assist1Name
	/// 152 手术07二助ID
	s entity.Oper07Assist2ID = arr.GetAt("P40070601")
	//w !,"152:entity.Oper07Assist2ID: "_entity.Oper07Assist2ID
	/// 153 手术07二助姓名
	s entity.Oper07Assist2Name = arr.GetAt("P40070600")
	//w !,"153:entity.Oper07Assist2Name: "_entity.Oper07Assist2Name
	/// 154 手术07切口愈合等级
	s entity.Oper07CutLevel = arr.GetAt("P40070800")
	//w !,"154:entity.Oper07CutLevel: "_entity.Oper07CutLevel
	/// 155 手术07麻醉方式
	s entity.Oper07AnaMethod = arr.GetAt("P40070700")
	//w !,"155:entity.Oper07AnaMethod: "_entity.Oper07AnaMethod
	/// 156 手术07麻醉医师ID
	s entity.Oper07AnaDocID = arr.GetAt("P40070901")
	//w !,"156:entity.Oper07AnaDocID: "_entity.Oper07AnaDocID
	/// 157 手术07麻醉医师姓名
	s entity.Oper07AnaDocName = arr.GetAt("P40070900")
	//w !,"157:entity.Oper07AnaDocName: "_entity.Oper07AnaDocName
	
	/// 158 手术08ID
	s entity.Oper08ID = "P40080100"
	//w !,"158:entity.Oper08ID: "_entity.Oper08ID
	/// 159 手术08编码
	s entity.Oper08Code = arr.GetAt("P40080101")
	//w !,"159:entity.Oper08Code: "_entity.Oper08Code
	/// 160 手术08描述
	s entity.Oper08Desc = arr.GetAt("P40080100")
	//w !,"160:entity.Oper08Desc: "_entity.Oper08Desc
	/// 161 手术08等级
	s entity.Oper08Level = arr.GetAt("P40080300")
	//w !,"161:entity.Oper08Level: "_entity.Oper08Level
	/// 162 手术08日期
	s entity.Oper08Date = arr.GetAt("P40080200")
	//w !,"162:entity.Oper08Date: "_entity.Oper08Date
	/// 163 手术08操作医师ID
	s entity.Oper08DocID = arr.GetAt("P40080401")
	//w !,"163:entity.Oper08DocID: "_entity.Oper08DocID
	/// 164 手术08操作医师姓名
	s entity.Oper08DocName = arr.GetAt("P40080400")
	//w !,"164:entity.Oper08DocName: "_entity.Oper08DocName
	/// 165 手术08一助ID
	s entity.Oper08Assist1ID = arr.GetAt("P40080501")
	//w !,"165:entity.Oper08Assist1ID: "_entity.Oper08Assist1ID
	/// 166 手术08一助姓名
	s entity.Oper08Assist1Name = arr.GetAt("P40080500")
	//w !,"166:entity.Oper08Assist1Name: "_entity.Oper08Assist1Name
	/// 167 手术08二助ID
	s entity.Oper08Assist2ID = arr.GetAt("P40080601")
	//w !,"167:entity.Oper08Assist2ID: "_entity.Oper08Assist2ID
	/// 168 手术08二助姓名
	s entity.Oper08Assist2Name = arr.GetAt("P40080600")
	//w !,"168:entity.Oper08Assist2Name: "_entity.Oper08Assist2Name
	/// 169 手术08切口愈合等级
	s entity.Oper08CutLevel = arr.GetAt("P40080800")
	//w !,"169:entity.Oper08CutLevel: "_entity.Oper08CutLevel
	/// 170 手术08麻醉方式
	s entity.Oper08AnaMethod = arr.GetAt("P40080700")
	//w !,"170:entity.Oper08AnaMethod: "_entity.Oper08AnaMethod
	/// 171 手术08麻醉医师ID
	s entity.Oper08AnaDocID = arr.GetAt("P40080901")
	//w !,"171:entity.Oper08AnaDocID: "_entity.Oper08AnaDocID
	/// 172 手术08麻醉医师姓名
	s entity.Oper08AnaDocName = arr.GetAt("P40080900")
	//w !,"172:entity.Oper08AnaDocName: "_entity.Oper08AnaDocName
	
	//b "s"
	/// 173 门急诊诊断ID
	s entity.DiagOutID = "P23010100"
	//w !,"173:entity.DiagOutID: "_entity.DiagOutID
	/// 174 门急诊诊断编码
	s entity.DiagOutCode = arr.GetAt("P23010101")
	//w !,"174:entity.DiagOutCode: "_entity.DiagOutCode
	/// 175 门急诊诊断描述
	s entity.DiagOutDesc = arr.GetAt("P23010100")
	//w !,"175:entity.DiagOutDesc: "_entity.DiagOutDesc
	
	/// 176 入院诊断ID
	s entity.DiagAdmID = "P24010100"
	//w !,"176:entity.DiagAdmID: "_entity.DiagAdmID
	/// 177 入院诊断编码
	s entity.DiagAdmCode = arr.GetAt("P24010101")
	//w !,"177:entity.DiagAdmCode: "_entity.DiagAdmCode
	/// 178 入院诊断描述
	s entity.DiagAdmDesc = arr.GetAt("P24010100")
	//w !,"178:entity.DiagAdmDesc: "_entity.DiagAdmDesc
	
	/// 179 入院诊断入院情况
	s entity.DiagAdmState = arr.GetAt("P24010200")
	//w !,"179:entity.DiagAdmState: "_entity.DiagAdmState
	
	/// 180 病理诊断
	s entity.DiagPathDesc = arr.GetAt("P25010100")
	//w !,"180:entity.DiagPathDesc: "_entity.DiagPathDesc
	
	/// 181 病理诊断代码
	s entity.DiagPathCode = arr.GetAt("P25010101")
	//w !,"180:entity.DiagPathCode: "_entity.DiagPathCode
	q entity
}

ClassMethod CreateFSMREpisodeFP(AMREpisodeID As %String, AMRPatientID As %String = "") As %String
{
	if (AMRPatientID = "")
	{
		s objMREpisode = ##class(DHCEPRFS.INST.MREpisode).%OpenId(AMREpisodeID)	
		s AMRPatientID = objMREpisode.MRPatientID
	}
	
	s obj = ##class(DHCEPRFS.INST.MREpisodeFP).%New()
	s obj.CompanyCode = "DHC"
	s obj.MREpisodeID = AMREpisodeID
	s obj.MRPatientID = AMRPatientID
	
	s obj.CreateDate = $p($h,",",1)
	s obj.CreateTime = $p($h,",",2)
	s obj.LastModifyDate = $p($h,",",1)
	s obj.LastModifyTime = $p($h,",",2)
	
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		q obj.%Id()
	}
	else
	{
		q "-1"
	}
}

/// debug w ##class(DHCEPRFS.BL.BLMREpisodeFP).AddFPDiagnosis("39","Diag","急性重型甲型病毒性肝炎伴肝昏迷","B15.002","临床未确定")
ClassMethod AddFPDiagnosis(AMREpisodeID As %String, ADiagnosisType As %String, ADiagnosisDesc As %String, ADiagnosisCode As %String, ADiagnosisState As %String) As %String
{
	s mrEpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_AMREpisodeID,""))
	if (mrEpisodeFPID = "")
	{
		//不存在对应的编目信息，则新建
		s mrEpisodeFPID = ..CreateFSMREpisodeFP(AMREpisodeID)
			
	}
	//其他诊断需要拼数字，最多10个其他诊断
	if (ADiagnosisType = "Diag")
	{
		//检查已有了几个其他诊断
		s obj = ##class(DHCEPRFS.INST.MREpisodeFP).%OpenId(mrEpisodeFPID)
		if ((obj.Diag01Desc = "") && (obj.Diag01Code = "") && (obj.Diag01State = ""))
		{
			d $ZOBJCLASSMETHOD("DHCEPRFS.BL.BLMREpisodeFP","Diag01",mrEpisodeFPID,ADiagnosisDesc,ADiagnosisCode,ADiagnosisState)
			q "1"
		}
		elseif ((obj.Diag02Desc = "") && (obj.Diag02Code = "") && (obj.Diag02State = ""))
		{
			d $ZOBJCLASSMETHOD("DHCEPRFS.BL.BLMREpisodeFP","Diag02",mrEpisodeFPID,ADiagnosisDesc,ADiagnosisCode,ADiagnosisState)
			q "1"
		}
		elseif ((obj.Diag03Desc = "") && (obj.Diag03Code = "") && (obj.Diag03State = ""))
		{
			d $ZOBJCLASSMETHOD("DHCEPRFS.BL.BLMREpisodeFP","Diag03",mrEpisodeFPID,ADiagnosisDesc,ADiagnosisCode,ADiagnosisState)
			q "1"
		}
		elseif ((obj.Diag04Desc = "") && (obj.Diag04Code = "") && (obj.Diag04State = ""))
		{
			d $ZOBJCLASSMETHOD("DHCEPRFS.BL.BLMREpisodeFP","Diag04",mrEpisodeFPID,ADiagnosisDesc,ADiagnosisCode,ADiagnosisState)
			q "1"
		}
		elseif ((obj.Diag05Desc = "") && (obj.Diag05Code = "") && (obj.Diag05State = ""))
		{
			d $ZOBJCLASSMETHOD("DHCEPRFS.BL.BLMREpisodeFP","Diag05",mrEpisodeFPID,ADiagnosisDesc,ADiagnosisCode,ADiagnosisState)
			q "1"
		}
		elseif ((obj.Diag06Desc = "") && (obj.Diag06Code = "") && (obj.Diag06State = ""))
		{
			d $ZOBJCLASSMETHOD("DHCEPRFS.BL.BLMREpisodeFP","Diag06",mrEpisodeFPID,ADiagnosisDesc,ADiagnosisCode,ADiagnosisState)
			q "1"
		}
		elseif ((obj.Diag07Desc = "") && (obj.Diag07Code = "") && (obj.Diag07State = ""))
		{
			d $ZOBJCLASSMETHOD("DHCEPRFS.BL.BLMREpisodeFP","Diag07",mrEpisodeFPID,ADiagnosisDesc,ADiagnosisCode,ADiagnosisState)
			q "1"
		}
		elseif ((obj.Diag08Desc = "") && (obj.Diag08Code = "") && (obj.Diag08State = ""))
		{
			d $ZOBJCLASSMETHOD("DHCEPRFS.BL.BLMREpisodeFP","Diag08",mrEpisodeFPID,ADiagnosisDesc,ADiagnosisCode,ADiagnosisState)
			q "1"
		}
		elseif ((obj.Diag09Desc = "") && (obj.Diag09Code = "") && (obj.Diag09State = ""))
		{
			d $ZOBJCLASSMETHOD("DHCEPRFS.BL.BLMREpisodeFP","Diag09",mrEpisodeFPID,ADiagnosisDesc,ADiagnosisCode,ADiagnosisState)
			q "1"
		}
		elseif ((obj.Diag10Desc = "") && (obj.Diag10Code = "") && (obj.Diag10State = ""))
		{
			d $ZOBJCLASSMETHOD("DHCEPRFS.BL.BLMREpisodeFP","Diag10",mrEpisodeFPID,ADiagnosisDesc,ADiagnosisCode,ADiagnosisState)
			q "1"
		}
		else
		{
			q "-1"	
		}
	}
	else
	{
		d $ZOBJCLASSMETHOD("DHCEPRFS.BL.BLMREpisodeFP",ADiagnosisType,mrEpisodeFPID,ADiagnosisDesc,ADiagnosisCode,ADiagnosisState)
		q "1"
	}
}

ClassMethod DiagMain(AMREpisodeFPID As %String, ADiagnosisDesc As %String, ADiagnosisCode As %String, ADiagnosisState As %String)
{
	s obj = ##class(DHCEPRFS.INST.MREpisodeFP).%OpenId(AMREpisodeFPID)
	s obj.DiagMainCode = ADiagnosisCode
	s obj.DiagMainState = ADiagnosisState
	s obj.DiagMainDesc = ADiagnosisDesc
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		q obj.%Id()
	}
	q "-1"
}

ClassMethod DiagPath(AMREpisodeFPID As %String, ADiagnosisDesc As %String, ADiagnosisCode As %String, ADiagnosisState As %String)
{
	s obj = ##class(DHCEPRFS.INST.MREpisodeFP).%OpenId(AMREpisodeFPID)
	s obj.DiagPathCode = ADiagnosisCode
	s obj.DiagPathDesc = ADiagnosisDesc
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		q obj.%Id()
	}
	q "-1"
}

ClassMethod DiagOut(AMREpisodeFPID As %String, ADiagnosisDesc As %String, ADiagnosisCode As %String, ADiagnosisState As %String)
{
	s obj = ##class(DHCEPRFS.INST.MREpisodeFP).%OpenId(AMREpisodeFPID)
	s obj.DiagOutCode = ADiagnosisCode
	s obj.DiagOutDesc = ADiagnosisDesc
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		q obj.%Id()
	}
	q "-1"
}

ClassMethod DiagAdm(AMREpisodeFPID As %String, ADiagnosisDesc As %String, ADiagnosisCode As %String, ADiagnosisState As %String)
{
	s obj = ##class(DHCEPRFS.INST.MREpisodeFP).%OpenId(AMREpisodeFPID)
	s obj.DiagAdmCode = ADiagnosisCode
	s obj.DiagAdmState = ADiagnosisState
	s obj.DiagAdmDesc = ADiagnosisDesc
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		q obj.%Id()
	}
	q "-1"
}

ClassMethod Diag01(AMREpisodeFPID As %String, ADiagnosisDesc As %String, ADiagnosisCode As %String, ADiagnosisState As %String)
{
	s obj = ##class(DHCEPRFS.INST.MREpisodeFP).%OpenId(AMREpisodeFPID)
	s obj.Diag01Code = ADiagnosisCode
	s obj.Diag01State = ADiagnosisState
	s obj.Diag01Desc = ADiagnosisDesc
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		q obj.%Id()
	}
	q "-1"
}

ClassMethod Diag02(AMREpisodeFPID As %String, ADiagnosisDesc As %String, ADiagnosisCode As %String, ADiagnosisState As %String)
{
	s obj = ##class(DHCEPRFS.INST.MREpisodeFP).%OpenId(AMREpisodeFPID)
	s obj.Diag02Code = ADiagnosisCode
	s obj.Diag02State = ADiagnosisState
	s obj.Diag02Desc = ADiagnosisDesc
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		q obj.%Id()
	}
	q "-1"
}

ClassMethod Diag03(AMREpisodeFPID As %String, ADiagnosisDesc As %String, ADiagnosisCode As %String, ADiagnosisState As %String)
{
	s obj = ##class(DHCEPRFS.INST.MREpisodeFP).%OpenId(AMREpisodeFPID)
	s obj.Diag03Code = ADiagnosisCode
	s obj.Diag03State = ADiagnosisState
	s obj.Diag03Desc = ADiagnosisDesc
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		q obj.%Id()
	}
	q "-1"
}

ClassMethod Diag04(AMREpisodeFPID As %String, ADiagnosisDesc As %String, ADiagnosisCode As %String, ADiagnosisState As %String)
{
	s obj = ##class(DHCEPRFS.INST.MREpisodeFP).%OpenId(AMREpisodeFPID)
	s obj.Diag04Code = ADiagnosisCode
	s obj.Diag04State = ADiagnosisState
	s obj.Diag04Desc = ADiagnosisDesc
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		q obj.%Id()
	}
	q "-1"
}

ClassMethod Diag05(AMREpisodeFPID As %String, ADiagnosisDesc As %String, ADiagnosisCode As %String, ADiagnosisState As %String)
{
	s obj = ##class(DHCEPRFS.INST.MREpisodeFP).%OpenId(AMREpisodeFPID)
	s obj.Diag05Code = ADiagnosisCode
	s obj.Diag05State = ADiagnosisState
	s obj.Diag05Desc = ADiagnosisDesc
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		q obj.%Id()
	}
	q "-1"
}

ClassMethod Diag06(AMREpisodeFPID As %String, ADiagnosisDesc As %String, ADiagnosisCode As %String, ADiagnosisState As %String)
{
	s obj = ##class(DHCEPRFS.INST.MREpisodeFP).%OpenId(AMREpisodeFPID)
	s obj.Diag06Code = ADiagnosisCode
	s obj.Diag06State = ADiagnosisState
	s obj.Diag06Desc = ADiagnosisDesc
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		q obj.%Id()
	}
	q "-1"
}

ClassMethod Diag07(AMREpisodeFPID As %String, ADiagnosisDesc As %String, ADiagnosisCode As %String, ADiagnosisState As %String)
{
	s obj = ##class(DHCEPRFS.INST.MREpisodeFP).%OpenId(AMREpisodeFPID)
	s obj.Diag07Code = ADiagnosisCode
	s obj.Diag07State = ADiagnosisState
	s obj.Diag07Desc = ADiagnosisDesc
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		q obj.%Id()
	}
	q "-1"
}

ClassMethod Diag08(AMREpisodeFPID As %String, ADiagnosisDesc As %String, ADiagnosisCode As %String, ADiagnosisState As %String)
{
	s obj = ##class(DHCEPRFS.INST.MREpisodeFP).%OpenId(AMREpisodeFPID)
	s obj.Diag08Code = ADiagnosisCode
	s obj.Diag08State = ADiagnosisState
	s obj.Diag08Desc = ADiagnosisDesc
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		q obj.%Id()
	}
	q "-1"
}

ClassMethod Diag09(AMREpisodeFPID As %String, ADiagnosisDesc As %String, ADiagnosisCode As %String, ADiagnosisState As %String)
{
	s obj = ##class(DHCEPRFS.INST.MREpisodeFP).%OpenId(AMREpisodeFPID)
	s obj.Diag09Code = ADiagnosisCode
	s obj.Diag09State = ADiagnosisState
	s obj.Diag09Desc = ADiagnosisDesc
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		q obj.%Id()
	}
	q "-1"
}

ClassMethod Diag10(AMREpisodeFPID As %String, ADiagnosisDesc As %String, ADiagnosisCode As %String, ADiagnosisState As %String)
{
	s obj = ##class(DHCEPRFS.INST.MREpisodeFP).%OpenId(AMREpisodeFPID)
	s obj.Diag10Code = ADiagnosisCode
	s obj.Diag10State = ADiagnosisState
	s obj.Diag10Desc = ADiagnosisDesc
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		q obj.%Id()
	}
	q "-1"
}

ClassMethod DeleteDiagOrOper(AMREpisodeID As %String, AType As %String) As %String
{
	s mrEpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_AMREpisodeID,""))
	q:(mrEpisodeFPID = "") "-1"
	s obj = ##class(DHCEPRFS.INST.MREpisodeFP).%OpenId(mrEpisodeFPID)
	if (AType = "DiagMain")
	{
		s obj.DiagMainCode = ""
		s obj.DiagMainDesc = ""
		s obj.DiagMainID = ""
		s obj.DiagMainState = ""
		s status = obj.%Save()
		if ($$$ISOK(status))
		{
			q obj.%Id()
		}
		q "-1"	
	}
	if (AType = "Diag01")
	{
		s obj.Diag01Code = ""
		s obj.Diag01Desc = ""
		s obj.Diag01ID = ""
		s obj.Diag01State = ""
		s status = obj.%Save()
		if ($$$ISOK(status))
		{
			q obj.%Id()
		}
		q "-1"	
	}
	if (AType = "Diag02")
	{
		s obj.Diag02Code = ""
		s obj.Diag02Desc = ""
		s obj.Diag02ID = ""
		s obj.Diag02State = ""
		s status = obj.%Save()
		if ($$$ISOK(status))
		{
			q obj.%Id()
		}
		q "-1"	
	}
	if (AType = "Diag03")
	{
		s obj.Diag03Code = ""
		s obj.Diag03Desc = ""
		s obj.Diag03ID = ""
		s obj.Diag03State = ""
		s status = obj.%Save()
		if ($$$ISOK(status))
		{
			q obj.%Id()
		}
		q "-1"	
	}
	if (AType = "Diag04")
	{
		s obj.Diag04Code = ""
		s obj.Diag04Desc = ""
		s obj.Diag04ID = ""
		s obj.Diag04State = ""
		s status = obj.%Save()
		if ($$$ISOK(status))
		{
			q obj.%Id()
		}
		q "-1"	
	}
	if (AType = "Diag05")
	{
		s obj.Diag05Code = ""
		s obj.Diag05Desc = ""
		s obj.Diag05ID = ""
		s obj.Diag05State = ""
		s status = obj.%Save()
		if ($$$ISOK(status))
		{
			q obj.%Id()
		}
		q "-1"	
	}
	if (AType = "Diag06")
	{
		s obj.Diag06Code = ""
		s obj.Diag06Desc = ""
		s obj.Diag06ID = ""
		s obj.Diag06State = ""
		s status = obj.%Save()
		if ($$$ISOK(status))
		{
			q obj.%Id()
		}
		q "-1"	
	}
	if (AType = "Diag07")
	{
		s obj.Diag07Code = ""
		s obj.Diag07Desc = ""
		s obj.Diag07ID = ""
		s obj.Diag07State = ""
		s status = obj.%Save()
		if ($$$ISOK(status))
		{
			q obj.%Id()
		}
		q "-1"	
	}
	if (AType = "Diag08")
	{
		s obj.Diag08Code = ""
		s obj.Diag08Desc = ""
		s obj.Diag08ID = ""
		s obj.Diag08State = ""
		s status = obj.%Save()
		if ($$$ISOK(status))
		{
			q obj.%Id()
		}
		q "-1"	
	}
	if (AType = "Diag09")
	{
		s obj.Diag09Code = ""
		s obj.Diag09Desc = ""
		s obj.Diag09ID = ""
		s obj.Diag09State = ""
		s status = obj.%Save()
		if ($$$ISOK(status))
		{
			q obj.%Id()
		}
		q "-1"	
	}
	if (AType = "Diag10")
	{
		s obj.Diag10Code = ""
		s obj.Diag10Desc = ""
		s obj.Diag10ID = ""
		s obj.Diag10State = ""
		s status = obj.%Save()
		if ($$$ISOK(status))
		{
			q obj.%Id()
		}
		q "-1"	
	}
	if (AType = "Oper01")
	{
		s obj.Oper01ID = ""
		s obj.Oper01Code = ""
		s obj.Oper01Desc = ""
		s obj.Oper01Level = ""
		s obj.Oper01Date = ""
		s obj.Oper01DocID = ""
		s obj.Oper01DocName = ""
		s obj.Oper01Assist1ID = ""
	    s obj.Oper01Assist1Name = ""
		s obj.Oper01Assist2ID = ""
		s obj.Oper01Assist2Name = ""
		s obj.Oper01CutLevel = ""
		s obj.Oper01AnaMethod = ""
		s obj.Oper01AnaDocID = ""
		s obj.Oper01AnaDocName = ""
		s status = obj.%Save()
		if ($$$ISOK(status))
		{
			q obj.%Id()
		}
		q "-1"	
	}
	if (AType = "Oper02")
	{
		s obj.Oper02ID = ""
		s obj.Oper02Code = ""
		s obj.Oper02Desc = ""
		s obj.Oper02Level = ""
		s obj.Oper02Date = ""
		s obj.Oper02DocID = ""
		s obj.Oper02DocName = ""
		s obj.Oper02Assist1ID = ""
	    s obj.Oper02Assist1Name = ""
		s obj.Oper02Assist2ID = ""
		s obj.Oper02Assist2Name = ""
		s obj.Oper02CutLevel = ""
		s obj.Oper02AnaMethod = ""
		s obj.Oper02AnaDocID = ""
		s obj.Oper02AnaDocName = ""
		s status = obj.%Save()
		if ($$$ISOK(status))
		{
			q obj.%Id()
		}
		q "-1"	
	}
	if (AType = "Oper03")
	{
		s obj.Oper03ID = ""
		s obj.Oper03Code = ""
		s obj.Oper03Desc = ""
		s obj.Oper03Level = ""
		s obj.Oper03Date = ""
		s obj.Oper03DocID = ""
		s obj.Oper03DocName = ""
		s obj.Oper03Assist1ID = ""
	    s obj.Oper03Assist1Name = ""
		s obj.Oper03Assist2ID = ""
		s obj.Oper03Assist2Name = ""
		s obj.Oper03CutLevel = ""
		s obj.Oper03AnaMethod = ""
		s obj.Oper03AnaDocID = ""
		s obj.Oper03AnaDocName = ""
		s status = obj.%Save()
		if ($$$ISOK(status))
		{
			q obj.%Id()
		}
		q "-1"	
	}
	if (AType = "Oper04")
	{
		s obj.Oper04ID = ""
		s obj.Oper04Code = ""
		s obj.Oper04Desc = ""
		s obj.Oper04Level = ""
		s obj.Oper04Date = ""
		s obj.Oper04DocID = ""
		s obj.Oper04DocName = ""
		s obj.Oper04Assist1ID = ""
	    s obj.Oper04Assist1Name = ""
		s obj.Oper04Assist2ID = ""
		s obj.Oper04Assist2Name = ""
		s obj.Oper04CutLevel = ""
		s obj.Oper04AnaMethod = ""
		s obj.Oper04AnaDocID = ""
		s obj.Oper04AnaDocName = ""
		s status = obj.%Save()
		if ($$$ISOK(status))
		{
			q obj.%Id()
		}
		q "-1"	
	}
	if (AType = "Oper05")
	{
		s obj.Oper05ID = ""
		s obj.Oper05Code = ""
		s obj.Oper05Desc = ""
		s obj.Oper05Level = ""
		s obj.Oper05Date = ""
		s obj.Oper05DocID = ""
		s obj.Oper05DocName = ""
		s obj.Oper05Assist1ID = ""
	    s obj.Oper05Assist1Name = ""
		s obj.Oper05Assist2ID = ""
		s obj.Oper05Assist2Name = ""
		s obj.Oper05CutLevel = ""
		s obj.Oper05AnaMethod = ""
		s obj.Oper05AnaDocID = ""
		s obj.Oper05AnaDocName = ""
		s status = obj.%Save()
		if ($$$ISOK(status))
		{
			q obj.%Id()
		}
		q "-1"	
	}
	if (AType = "Oper06")
	{
		s obj.Oper06ID = ""
		s obj.Oper06Code = ""
		s obj.Oper06Desc = ""
		s obj.Oper06Level = ""
		s obj.Oper06Date = ""
		s obj.Oper06DocID = ""
		s obj.Oper06DocName = ""
		s obj.Oper06Assist1ID = ""
	    s obj.Oper06Assist1Name = ""
		s obj.Oper06Assist2ID = ""
		s obj.Oper06Assist2Name = ""
		s obj.Oper06CutLevel = ""
		s obj.Oper06AnaMethod = ""
		s obj.Oper06AnaDocID = ""
		s obj.Oper06AnaDocName = ""
		s status = obj.%Save()
		if ($$$ISOK(status))
		{
			q obj.%Id()
		}
		q "-1"	
	}
	if (AType = "Oper07")
	{
		s obj.Oper07ID = ""
		s obj.Oper07Code = ""
		s obj.Oper07Desc = ""
		s obj.Oper07Level = ""
		s obj.Oper07Date = ""
		s obj.Oper07DocID = ""
		s obj.Oper07DocName = ""
		s obj.Oper07Assist1ID = ""
	    s obj.Oper07Assist1Name = ""
		s obj.Oper07Assist2ID = ""
		s obj.Oper07Assist2Name = ""
		s obj.Oper07CutLevel = ""
		s obj.Oper07AnaMethod = ""
		s obj.Oper07AnaDocID = ""
		s obj.Oper07AnaDocName = ""
		s status = obj.%Save()
		if ($$$ISOK(status))
		{
			q obj.%Id()
		}
		q "-1"	
	}
	if (AType = "Oper08")
	{
		s obj.Oper08ID = ""
		s obj.Oper08Code = ""
		s obj.Oper08Desc = ""
		s obj.Oper08Level = ""
		s obj.Oper08Date = ""
		s obj.Oper08DocID = ""
		s obj.Oper08DocName = ""
		s obj.Oper08Assist1ID = ""
	    s obj.Oper08Assist1Name = ""
		s obj.Oper08Assist2ID = ""
		s obj.Oper08Assist2Name = ""
		s obj.Oper08CutLevel = ""
		s obj.Oper08AnaMethod = ""
		s obj.Oper08AnaDocID = ""
		s obj.Oper08AnaDocName = ""
		s status = obj.%Save()
		if ($$$ISOK(status))
		{
			q obj.%Id()
		}
		q "-1"	
	}
	if (AType = "DiagOut")
	{
		s obj.DiagOutID = ""
		s obj.DiagOutCode = ""
		s obj.DiagOutDesc = ""
		s status = obj.%Save()
		if ($$$ISOK(status))
		{
			q obj.%Id()
		}
		q "-1"	
	}
	if (AType = "DiagAdm")
	{
		s obj.DiagAdmID = ""
		s obj.DiagAdmCode = ""
		s obj.DiagAdmDesc = ""
		s obj.DiagAdmState = ""
		s status = obj.%Save()
		if ($$$ISOK(status))
		{
			q obj.%Id()
		}
		q "-1"	
	}
	if (AType = "DiagPath")
	{
		s obj.DiagPathDesc = ""
		s obj.DiagPathCode = ""
		s status = obj.%Save()
		if ($$$ISOK(status))
		{
			q obj.%Id()
		}
		q "-1"	
	}
}

/// Debug: do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMREpisodeFP","GetFPDiagnosisList","39")
Query GetFPDiagnosisList(AMREpisodeID As %String) As %Query(ROWSPEC = "DiagType:%String,DiagTypeDesc:%String,DiagCode:%String,DiagDesc:%String,DiagState:%String,PropertyName:%String")
{
}

ClassMethod GetFPDiagnosisListExecute(ByRef qHandle As %Binary, AMREpisodeID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1

	s mrEpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_AMREpisodeID,""))
	q:(mrEpisodeFPID = "") $$$OK
	s obj = ##class(DHCEPRFS.INST.MREpisodeFP).%OpenId(mrEpisodeFPID)
	if ((obj.DiagMainCode '= "") ||(obj.DiagMainDesc '= "") || (obj.DiagMainState '= ""))
	{
    	s data = $lb("DiagMain", "主要诊断", obj.DiagMainCode,obj.DiagMainDesc,obj.DiagMainState,"DiagMain")
		s ^CacheTemp(repid,ind)=data
		s ind=ind+1 
	}
	if ((obj.Diag01Code '= "") ||(obj.Diag01Desc '= "") || (obj.Diag01State '= ""))
	{
    	s data = $lb("Diag", "次要诊断", obj.Diag01Code,obj.Diag01Desc,obj.Diag01State,"Diag01")
		s ^CacheTemp(repid,ind)=data
		s ind=ind+1 
	}
	if ((obj.Diag02Code '= "") ||(obj.Diag02Desc '= "") || (obj.Diag02State '= ""))
	{
    	s data = $lb("Diag", "次要诊断", obj.Diag02Code,obj.Diag02Desc,obj.Diag02State,"Diag02")
		s ^CacheTemp(repid,ind)=data
		s ind=ind+1 
	}
	if ((obj.Diag03Code '= "") ||(obj.Diag03Desc '= "") || (obj.Diag03State '= ""))
	{
    	s data = $lb("Diag", "次要诊断", obj.Diag03Code,obj.Diag03Desc,obj.Diag03State,"Diag03")
		s ^CacheTemp(repid,ind)=data
		s ind=ind+1 
	}
	if ((obj.Diag04Code '= "") ||(obj.Diag04Desc '= "") || (obj.Diag04State '= ""))
	{
    	s data = $lb("Diag", "次要诊断", obj.Diag04Code,obj.Diag04Desc,obj.Diag04State,"Diag04")
		s ^CacheTemp(repid,ind)=data
		s ind=ind+1 
	}
	if ((obj.Diag05Code '= "") ||(obj.Diag05Desc '= "") || (obj.Diag05State '= ""))
	{
    	s data = $lb("Diag", "次要诊断", obj.Diag05Code,obj.Diag05Desc,obj.Diag05State,"Diag05")
		s ^CacheTemp(repid,ind)=data
		s ind=ind+1 
	}
	if ((obj.Diag06Code '= "") ||(obj.Diag06Desc '= "") || (obj.Diag06State '= ""))
	{
    	s data = $lb("Diag", "次要诊断", obj.Diag06Code,obj.Diag06Desc,obj.Diag06State,"Diag06")
		s ^CacheTemp(repid,ind)=data
		s ind=ind+1 
	}
	if ((obj.Diag07Code '= "") ||(obj.Diag07Desc '= "") || (obj.Diag07State '= ""))
	{
    	s data = $lb("Diag", "次要诊断", obj.Diag07Code,obj.Diag07Desc,obj.Diag07State,"Diag07")
		s ^CacheTemp(repid,ind)=data
		s ind=ind+1 
	}
	if ((obj.Diag08Code '= "") ||(obj.Diag08Desc '= "") || (obj.Diag08State '= ""))
	{
    	s data = $lb("Diag", "次要诊断", obj.Diag08Code,obj.Diag08Desc,obj.Diag08State,"Diag08")
		s ^CacheTemp(repid,ind)=data
		s ind=ind+1 
	}
	if ((obj.Diag09Code '= "") ||(obj.Diag09Desc '= "") || (obj.Diag09State '= ""))
	{
    	s data = $lb("Diag", "次要诊断", obj.Diag09Code,obj.Diag09Desc,obj.Diag09State,"Diag09")
		s ^CacheTemp(repid,ind)=data
		s ind=ind+1 
	}
	if ((obj.Diag10Code '= "") ||(obj.Diag10Desc '= "") || (obj.Diag10State '= ""))
	{
    	s data = $lb("Diag", "次要诊断", obj.Diag10Code,obj.Diag10Desc,obj.Diag10State,"Diag10")
		s ^CacheTemp(repid,ind)=data
		s ind=ind+1 
	}
	if ((obj.DiagPathCode '= "") ||(obj.DiagPathDesc '= ""))
	{
    	s data = $lb("DiagPath", "病理诊断", obj.DiagPathCode,obj.DiagPathDesc,"","DiagPath")
		s ^CacheTemp(repid,ind)=data
		s ind=ind+1 
	}
	if ((obj.DiagOutCode '= "") ||(obj.DiagOutDesc '= ""))
	{
    	s data = $lb("DiagOut", "门急诊诊断", obj.DiagOutCode,obj.DiagOutDesc,"","DiagOut")
		s ^CacheTemp(repid,ind)=data
		s ind=ind+1 
	}
	if ((obj.DiagAdmCode '= "") ||(obj.DiagAdmDesc '= "") || (obj.DiagAdmState '= ""))
	{
    	s data = $lb("DiagAdm", "入院诊断", obj.DiagAdmCode,obj.DiagAdmDesc,obj.DiagAdmState,"DiagAdm")
		s ^CacheTemp(repid,ind)=data
		s ind=ind+1 
	}

	Quit $$$OK
}

ClassMethod GetFPDiagnosisListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFPDiagnosisListExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetFPDiagnosisListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFPDiagnosisListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

ClassMethod AddFPOperation(AMREpisodeID As %String, AOperationDesc As %String, AOperationCode As %String, AOperationDate As %String, AOperationLevel As %String, AOperationAnaMethod As %String, AOperationCutLevel As %String) As %String
{
	s mrEpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_AMREpisodeID,""))
	if (mrEpisodeFPID = "")
	{
		//不存在对应的编目信息，则新建
		s mrEpisodeFPID = ..CreateFSMREpisodeFP(AMREpisodeID)
			
	}

	//检查已有了几个手术
	s obj = ##class(DHCEPRFS.INST.MREpisodeFP).%OpenId(mrEpisodeFPID)
	if ((obj.Oper01Code = "") && (obj.Oper01Desc = "") && (obj.Oper01Level = "") && (obj.Oper01Date = "") && (obj.Oper01CutLevel = "") && (obj.Oper01AnaMethod = ""))
	{
		s obj = ##class(DHCEPRFS.INST.MREpisodeFP).%OpenId(mrEpisodeFPID)
		s obj.Oper01Code = AOperationCode
		s obj.Oper01Desc = AOperationDesc
		s obj.Oper01Level = AOperationLevel
		s obj.Oper01Date = AOperationDate
		s obj.Oper01CutLevel = AOperationCutLevel
		s obj.Oper01AnaMethod = AOperationAnaMethod
		s status = obj.%Save()
		if ($$$ISOK(status))
		{
			q obj.%Id()
		}
		else
		{
			q "-1"
		}
	}
	elseif ((obj.Oper02Code = "") && (obj.Oper02Desc = "") && (obj.Oper02Level = "") && (obj.Oper02Date = "") && (obj.Oper02CutLevel = "") && (obj.Oper02AnaMethod = ""))
	{
		s obj = ##class(DHCEPRFS.INST.MREpisodeFP).%OpenId(mrEpisodeFPID)
		s obj.Oper02Code = AOperationCode
		s obj.Oper02Desc = AOperationDesc
		s obj.Oper02Level = AOperationLevel
		s obj.Oper02Date = AOperationDate
		s obj.Oper02CutLevel = AOperationCutLevel
		s obj.Oper02AnaMethod = AOperationAnaMethod
		s status = obj.%Save()
		if ($$$ISOK(status))
		{
			q obj.%Id()
		}
		else
		{
			q "-1"
		}
	}
	elseif ((obj.Oper03Code = "") && (obj.Oper03Desc = "") && (obj.Oper03Level = "") && (obj.Oper03Date = "") && (obj.Oper03CutLevel = "") && (obj.Oper03AnaMethod = ""))
	{
		s obj = ##class(DHCEPRFS.INST.MREpisodeFP).%OpenId(mrEpisodeFPID)
		s obj.Oper03Code = AOperationCode
		s obj.Oper03Desc = AOperationDesc
		s obj.Oper03Level = AOperationLevel
		s obj.Oper03Date = AOperationDate
		s obj.Oper03CutLevel = AOperationCutLevel
		s obj.Oper03AnaMethod = AOperationAnaMethod
		s status = obj.%Save()
		if ($$$ISOK(status))
		{
			q obj.%Id()
		}
		else
		{
			q "-1"
		}
	}
	elseif ((obj.Oper04Code = "") && (obj.Oper04Desc = "") && (obj.Oper04Level = "") && (obj.Oper04Date = "") && (obj.Oper04CutLevel = "") && (obj.Oper04AnaMethod = ""))
	{
		s obj = ##class(DHCEPRFS.INST.MREpisodeFP).%OpenId(mrEpisodeFPID)
		s obj.Oper04Code = AOperationCode
		s obj.Oper04Desc = AOperationDesc
		s obj.Oper04Level = AOperationLevel
		s obj.Oper04Date = AOperationDate
		s obj.Oper04CutLevel = AOperationCutLevel
		s obj.Oper04AnaMethod = AOperationAnaMethod
		s status = obj.%Save()
		if ($$$ISOK(status))
		{
			q obj.%Id()
		}
		else
		{
			q "-1"
		}
	}
	elseif ((obj.Oper05Code = "") && (obj.Oper05Desc = "") && (obj.Oper05Level = "") && (obj.Oper05Date = "") && (obj.Oper05CutLevel = "") && (obj.Oper05AnaMethod = ""))
	{
		s obj = ##class(DHCEPRFS.INST.MREpisodeFP).%OpenId(mrEpisodeFPID)
		s obj.Oper05Code = AOperationCode
		s obj.Oper05Desc = AOperationDesc
		s obj.Oper05Level = AOperationLevel
		s obj.Oper05Date = AOperationDate
		s obj.Oper05CutLevel = AOperationCutLevel
		s obj.Oper05AnaMethod = AOperationAnaMethod
		s status = obj.%Save()
		if ($$$ISOK(status))
		{
			q obj.%Id()
		}
		else
		{
			q "-1"
		}
	}
	elseif ((obj.Oper06Code = "") && (obj.Oper06Desc = "") && (obj.Oper06Level = "") && (obj.Oper06Date = "") && (obj.Oper06CutLevel = "") && (obj.Oper06AnaMethod = ""))
	{
		s obj = ##class(DHCEPRFS.INST.MREpisodeFP).%OpenId(mrEpisodeFPID)
		s obj.Oper06Code = AOperationCode
		s obj.Oper06Desc = AOperationDesc
		s obj.Oper06Level = AOperationLevel
		s obj.Oper06Date = AOperationDate
		s obj.Oper06CutLevel = AOperationCutLevel
		s obj.Oper06AnaMethod = AOperationAnaMethod
		s status = obj.%Save()
		if ($$$ISOK(status))
		{
			q obj.%Id()
		}
		else
		{
			q "-1"
		}
	}
	elseif ((obj.Oper07Code = "") && (obj.Oper07Desc = "") && (obj.Oper07Level = "") && (obj.Oper07Date = "") && (obj.Oper07CutLevel = "") && (obj.Oper07AnaMethod = ""))
	{
		s obj = ##class(DHCEPRFS.INST.MREpisodeFP).%OpenId(mrEpisodeFPID)
		s obj.Oper07Code = AOperationCode
		s obj.Oper07Desc = AOperationDesc
		s obj.Oper07Level = AOperationLevel
		s obj.Oper07Date = AOperationDate
		s obj.Oper07CutLevel = AOperationCutLevel
		s obj.Oper07AnaMethod = AOperationAnaMethod
		s status = obj.%Save()
		if ($$$ISOK(status))
		{
			q obj.%Id()
		}
		else
		{
			q "-1"
		}
	}
	elseif ((obj.Oper08Code = "") && (obj.Oper08Desc = "") && (obj.Oper08Level = "") && (obj.Oper08Date = "") && (obj.Oper08CutLevel = "") && (obj.Oper08AnaMethod = ""))
	{
		s obj = ##class(DHCEPRFS.INST.MREpisodeFP).%OpenId(mrEpisodeFPID)
		s obj.Oper08Code = AOperationCode
		s obj.Oper08Desc = AOperationDesc
		s obj.Oper08Level = AOperationLevel
		s obj.Oper08Date = AOperationDate
		s obj.Oper08CutLevel = AOperationCutLevel
		s obj.Oper08AnaMethod = AOperationAnaMethod
		s status = obj.%Save()
		if ($$$ISOK(status))
		{
			q obj.%Id()
		}
		else
		{
			q "-1"
		}
	}
}

/// Debug: do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMREpisodeFP","GetFPDiagnosisList","39")
Query GetFPOperationList(AMREpisodeID As %String) As %Query(ROWSPEC = "OperCode:%String,OperDesc:%String,OperLevel:%String,OperDate:%String,OperCutLevel:%String,OperAnaMethod:%String,PropertyName:%String")
{
}

ClassMethod GetFPOperationListExecute(ByRef qHandle As %Binary, AMREpisodeID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1

	s mrEpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_AMREpisodeID,""))
	q:(mrEpisodeFPID = "") $$$OK
	s obj = ##class(DHCEPRFS.INST.MREpisodeFP).%OpenId(mrEpisodeFPID)
	if ((obj.Oper01Code '= "") || (obj.Oper01Desc '= "") || (obj.Oper01Level '= "") || (obj.Oper01Date '= "") || (obj.Oper01CutLevel '= "") || (obj.Oper01AnaMethod '= ""))
	{
    	s data = $lb(obj.Oper01Code, obj.Oper01Desc, obj.Oper01Level,obj.Oper01Date,obj.Oper01CutLevel,obj.Oper01AnaMethod,"Oper01")
		s ^CacheTemp(repid,ind)=data
		s ind=ind+1 
	}
	if ((obj.Oper02Code '= "") || (obj.Oper02Desc '= "") || (obj.Oper02Level '= "") || (obj.Oper02Date '= "") || (obj.Oper02CutLevel '= "") || (obj.Oper02AnaMethod '= ""))
	{
    	s data = $lb(obj.Oper02Code, obj.Oper02Desc, obj.Oper02Level,obj.Oper02Date,obj.Oper02CutLevel,obj.Oper02AnaMethod,"Oper02")
		s ^CacheTemp(repid,ind)=data
		s ind=ind+1 
	}
	if ((obj.Oper03Code '= "") || (obj.Oper03Desc '= "") || (obj.Oper03Level '= "") || (obj.Oper03Date '= "") || (obj.Oper03CutLevel '= "") || (obj.Oper03AnaMethod '= ""))
	{
    	s data = $lb(obj.Oper03Code, obj.Oper03Desc, obj.Oper03Level,obj.Oper03Date,obj.Oper03CutLevel,obj.Oper03AnaMethod,"Oper03")
		s ^CacheTemp(repid,ind)=data
		s ind=ind+1 
	}
	if ((obj.Oper04Code '= "") || (obj.Oper04Desc '= "") || (obj.Oper04Level '= "") || (obj.Oper04Date '= "") || (obj.Oper04CutLevel '= "") || (obj.Oper04AnaMethod '= ""))
	{
    	s data = $lb(obj.Oper04Code, obj.Oper04Desc, obj.Oper04Level,obj.Oper04Date,obj.Oper04CutLevel,obj.Oper04AnaMethod,"Oper04")
		s ^CacheTemp(repid,ind)=data
		s ind=ind+1 
	}
	if ((obj.Oper05Code '= "") || (obj.Oper05Desc '= "") || (obj.Oper05Level '= "") || (obj.Oper05Date '= "") || (obj.Oper05CutLevel '= "") || (obj.Oper05AnaMethod '= ""))
	{
    	s data = $lb(obj.Oper05Code, obj.Oper05Desc, obj.Oper05Level,obj.Oper05Date,obj.Oper05CutLevel,obj.Oper05AnaMethod,"Oper05")
		s ^CacheTemp(repid,ind)=data
		s ind=ind+1 
	}
	if ((obj.Oper06Code '= "") || (obj.Oper06Desc '= "") || (obj.Oper06Level '= "") || (obj.Oper06Date '= "") || (obj.Oper06CutLevel '= "") || (obj.Oper06AnaMethod '= ""))
	{
    	s data = $lb(obj.Oper06Code, obj.Oper06Desc, obj.Oper06Level,obj.Oper06Date,obj.Oper06CutLevel,obj.Oper06AnaMethod,"Oper06")
		s ^CacheTemp(repid,ind)=data
		s ind=ind+1 
	}
	if ((obj.Oper07Code '= "") || (obj.Oper07Desc '= "") || (obj.Oper07Level '= "") || (obj.Oper07Date '= "") || (obj.Oper07CutLevel '= "") || (obj.Oper07AnaMethod '= ""))
	{
    	s data = $lb(obj.Oper07Code, obj.Oper07Desc, obj.Oper07Level,obj.Oper07Date,obj.Oper07CutLevel,obj.Oper07AnaMethod,"Oper07")
		s ^CacheTemp(repid,ind)=data
		s ind=ind+1 
	}
	if ((obj.Oper08Code '= "") || (obj.Oper08Desc '= "") || (obj.Oper08Level '= "") || (obj.Oper08Date '= "") || (obj.Oper08CutLevel '= "") || (obj.Oper08AnaMethod '= ""))
	{
    	s data = $lb(obj.Oper08Code, obj.Oper08Desc, obj.Oper08Level,obj.Oper08Date,obj.Oper08CutLevel,obj.Oper08AnaMethod,"Oper08")
		s ^CacheTemp(repid,ind)=data
		s ind=ind+1 
	}
	

	Quit $$$OK
}

ClassMethod GetFPOperationListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFPOperationListExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetFPOperationListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFPOperationListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

ClassMethod Test123() As %String
{
	s rowID = ""
	for {
		s rowID = $o(^DHCEPRFS.INST.MREpisodeD(rowID))
		q:(rowID="")
		s obj = ##class(DHCEPRFS.INST.MREpisode).%OpenId(rowID)
		s mrPatientID = obj.MRPatientID
		s objPat = ##class(DHCEPRFS.INST.MRPatient).%OpenId(mrPatientID)
		s patientID = objPat.PatientID
		s episodeID = obj.EpisodeID
		s rowIDEpisodeID = ""
		s rowIDEpisodeID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_rowID,rowIDEpisodeID))
		if (rowIDEpisodeID = "")
		{
			d ..CreateEMREpisodeFPMRH("create",patientID,episodeID,"DHC")
		}
		else
		{
			d ..CreateEMREpisodeFPMRH("update",patientID,episodeID,"DHC")
		}
	}
}

}
