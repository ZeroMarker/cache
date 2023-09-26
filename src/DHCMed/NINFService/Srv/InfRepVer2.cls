/// 名称: DHCMed.NINFService.Srv.InfRepVer2
/// 描述: 处理院感2.0报告数据问题
/// 编写者：zhufei
/// 编写日期: 2012-10-20
Class DHCMed.NINFService.Srv.InfRepVer2 Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// 对照【感染诊断、感染部位、易感因素、侵害性操作】字典
/// w ##Class(DHCMed.NINFService.Srv.InfRepVer2).ProcessData()
ClassMethod ProcessData() As %String
{
	New
	
	//Kill ^DHCMed.NINF("InfRep")
	//Kill ^DHCMed.NINFi("InfRep")
	Set ^DHCMed.NINF("InfRep")=0
	
	Kill ^DHCMed.NINFMapRst
	Kill ^DHCMed.NINFMapErr
	Kill ^DHCMed.NINFMapDic
	Kill ^DHCMed.NINFMapDesc
	
	//北京协和字典对照
	s ^DHCMed.NINFMapDesc("NINFInfCuteType","I") = "1" 
	s ^DHCMed.NINFMapDesc("NINFInfCuteType","II") = "2" 
	s ^DHCMed.NINFMapDesc("NINFInfCuteType","III") = "3" 
	s ^DHCMed.NINFMapDesc("NINFInfCuteType","IV") = "4" 
	s ^DHCMed.NINFMapDesc("NINFInfCuteType","V") = "4" 
	s ^DHCMed.NINFMapDesc("NINFInfReportStatus","已审") = "审核" 
	s ^DHCMed.NINFMapDesc("NINFInfReportStatus","待审") = "提交" 
	s ^DHCMed.NINFMapDesc("NINFInfReportType","院感报告") = "医院感染报告" 
	s ^DHCMed.NINFMapDesc("NINFInfSenTestRst","中敏") = "中介" 
	s ^DHCMed.NINFMapDesc("NINFInfAnesthesia","腰硬联合麻醉") = "硬膜外麻" 
	s ^DHCMed.NINFMapDesc("NINFInfAnesthesia","腰麻") = "局部麻醉" 
	s ^DHCMed.NINFMapDesc("NINFInfInfFactors","使用免疫抑制剂") = "免疫抑制剂" 
	s ^DHCMed.NINFMapDesc("NINFInfInfFactors","使用激素") = "激素" 
	s ^DHCMed.NINFMapDesc("NINFInfInfFactors","慢性肾功能衰竭") = "肾病" 
	s ^DHCMed.NINFMapDesc("NINFInfInfFactors","血液系统恶性肿瘤") = "癌症" 
	s ^DHCMed.NINFMapDesc("NINFInfInfFactors","长期使用广谱抗菌药物") = "抗菌药物大量应用" 
	s ^DHCMed.NINFMapDesc("NINFInfInvasiveOper","其它") = "其他" 
	s ^DHCMed.NINFMapDesc("NINFInfInvasiveOper","气管切开") = "气管插管/切开" 
	s ^DHCMed.NINFMapDesc("NINFInfMedPurpose","未明") = "无指征" 
	s ^DHCMed.NINFMapDesc("NINFInfOperInfType","术后肺炎") = "其它" 
	s ^DHCMed.NINFMapDesc("NINFInfReportType","NICU院感报告") = "新生儿感染报告" 
	s ^DHCMed.NINFMapDesc("NINFInfSpecimen","其它") = "其他" 
	s ^DHCMed.NINFMapDesc("NINFInfSpecimen","大便") = "便" 
	s ^DHCMed.NINFMapDesc("NINFInfSpecimen","皮肤下段") = "皮肤下端" 
    s ^DHCMed.NINFMapDesc("NINFInfAdminRoute","其它") = "其他" 
	
	s ^DHCMed.NINFMapDesc("InfPos","关节和关节囊感染-非手术相关") = "骨和关节" 
    s ^DHCMed.NINFMapDesc("InfPos","口腔、舌、牙龈部位感染-手术相关") = "眼、耳、口腔" 
    s ^DHCMed.NINFMapDesc("InfPos","心膜炎-非手术相关") = "心脏瓣膜" 
    s ^DHCMed.NINFMapDesc("InfPos","急性盆腔炎-手术相关") = "腹(盆)腔内组织" 
    s ^DHCMed.NINFMapDesc("InfPos","椎管内感染-手术相关") = "中枢神经系统" 
    s ^DHCMed.NINFMapDesc("InfPos","气管炎、支气管炎-") = "下呼吸道" 
    s ^DHCMed.NINFMapDesc("InfPos","病毒性肝炎-") = "腹(盆)腔内组织" 
    s ^DHCMed.NINFMapDesc("InfPos","皮肤软组织-褥疮感染") = "皮肤软组织" 
    s ^DHCMed.NINFMapDesc("InfPos","纵膈感染-手术相关") = "纵膈" 
    s ^DHCMed.NINFMapDesc("InfPos","纵膈感染-非手术相关") = "纵膈" 
    s ^DHCMed.NINFMapDesc("InfPos","胃肠道-") = "胃肠道" 
    s ^DHCMed.NINFMapDesc("InfPos","透析相关感染-血管通路感染") = "透析相关" 
    s ^DHCMed.NINFMapDesc("InfPos","颅内脓肿-手术相关") = "中枢神经系统" 
    s ^DHCMed.NINFMapDesc("InfPos","颅内脓肿-非手术相关") = "中枢神经系统" 
	s ^DHCMed.NINFMapDesc("InfPos","上呼吸道感染-上呼吸道感染") = "上呼吸道" 
    s ^DHCMed.NINFMapDesc("InfPos","关节和关节囊感染-手术相关") = "骨和关节" 
    s ^DHCMed.NINFMapDesc("InfPos","其它-") = "其它" 
    s ^DHCMed.NINFMapDesc("InfPos","其它-其它") = "其它" 
    s ^DHCMed.NINFMapDesc("InfPos","口腔、舌、牙龈部位感染-非手术相关") = "眼、耳、口腔" 
    s ^DHCMed.NINFMapDesc("InfPos","外阴切口感染-外阴切口感染") = "生殖系统" 
    s ^DHCMed.NINFMapDesc("InfPos","无症状的泌尿系感染-") = "泌尿道" 
    s ^DHCMed.NINFMapDesc("InfPos","无症状的泌尿系感染-导尿管相关泌尿系感染") = "泌尿道" 
    s ^DHCMed.NINFMapDesc("InfPos","无症状的泌尿系感染-非导尿管相关") = "泌尿道" 
    s ^DHCMed.NINFMapDesc("InfPos","有症状的泌尿道感染-导尿管相关泌尿系感染") = "泌尿道" 
    s ^DHCMed.NINFMapDesc("InfPos","有症状的泌尿道感染-非导尿管相关") = "泌尿道" 
    s ^DHCMed.NINFMapDesc("InfPos","气管炎、支气管炎-气管炎、支气管炎") = "下呼吸道" 
    s ^DHCMed.NINFMapDesc("InfPos","深部切口-") = "深部切口-手术部位" 
    s ^DHCMed.NINFMapDesc("InfPos","深部切口-深部切口") = "深部切口-手术部位" 
    s ^DHCMed.NINFMapDesc("InfPos","男女性生殖道的其它感染-非手术相关") = "生殖系统" 
    s ^DHCMed.NINFMapDesc("InfPos","病毒性肝炎-病毒性肝炎") = "腹(盆)腔内组织" 
    s ^DHCMed.NINFMapDesc("InfPos","皮肤软组织-") = "皮肤软组织" 
    s ^DHCMed.NINFMapDesc("InfPos","皮肤软组织-皮肤感染") = "皮肤软组织" 
    s ^DHCMed.NINFMapDesc("InfPos","皮肤软组织-软组织感染") = "皮肤软组织" 
    s ^DHCMed.NINFMapDesc("InfPos","细菌性脑膜炎、脑室炎-手术相关") = "中枢神经系统" 
    s ^DHCMed.NINFMapDesc("InfPos","细菌性脑膜炎、脑室炎-非手术相关") = "中枢神经系统" 
    s ^DHCMed.NINFMapDesc("InfPos","肺炎-") = "下呼吸道" 
    s ^DHCMed.NINFMapDesc("InfPos","肺炎-其他肺炎") = "下呼吸道" 
    s ^DHCMed.NINFMapDesc("InfPos","肺炎-呼吸机相关性肺炎") = "下呼吸道" 
    s ^DHCMed.NINFMapDesc("InfPos","肺炎-术后肺炎") = "下呼吸道" 
    s ^DHCMed.NINFMapDesc("InfPos","胃肠道-感染性腹泻") = "胃肠道" 
    s ^DHCMed.NINFMapDesc("InfPos","胃肠道-抗菌药物相关性腹泻") = "胃肠道" 
    s ^DHCMed.NINFMapDesc("InfPos","胃肠道-胃肠道感染") = "胃肠道" 
    s ^DHCMed.NINFMapDesc("InfPos","胸膜腔感染-手术相关") = "胸膜腔" 
    s ^DHCMed.NINFMapDesc("InfPos","胸膜腔感染-非手术相关") = "胸膜腔" 
    s ^DHCMed.NINFMapDesc("InfPos","腹(盆)腔内组织感染-手术相关") = "腹(盆)腔内组织" 
    s ^DHCMed.NINFMapDesc("InfPos","腹(盆)腔内组织感染-非手术相关") = "腹(盆)腔内组织" 
    s ^DHCMed.NINFMapDesc("InfPos","腹水感染-腹水感染") = "腹(盆)腔内组织" 
    s ^DHCMed.NINFMapDesc("InfPos","血管相关性感染-") = "动静脉" 
    s ^DHCMed.NINFMapDesc("InfPos","血管相关性感染-手术相关") = "动静脉" 
    s ^DHCMed.NINFMapDesc("InfPos","血管相关性感染-非手术相关") = "动静脉" 
    s ^DHCMed.NINFMapDesc("InfPos","表浅切口感染-表浅切口感染") = "表浅切口-手术部位" 
    s ^DHCMed.NINFMapDesc("InfPos","败血症-") = "血液" 
    s ^DHCMed.NINFMapDesc("InfPos","败血症-其他原发血流感染") = "血液" 
    s ^DHCMed.NINFMapDesc("InfPos","败血症-导管相关性血流感染") = "血液" 
    s ^DHCMed.NINFMapDesc("InfPos","败血症-继发血流感染") = "血液" 
    
	s ^DHCMed.NINFMapDesc("InfDiag","上呼吸道感染-上呼吸道感染") = "上呼吸道感染" 
	s ^DHCMed.NINFMapDesc("InfDiag","关节和关节囊感染-手术相关") = "关节和关节囊感染" 
	s ^DHCMed.NINFMapDesc("InfDiag","其它-") = "其它" 
	s ^DHCMed.NINFMapDesc("InfDiag","其它-其它") = "其它" 
	s ^DHCMed.NINFMapDesc("InfDiag","外阴切口感染-外阴切口感染") = "外阴切口感染" 
	s ^DHCMed.NINFMapDesc("InfDiag","无症状的泌尿系感染-") = "无症状菌尿症" 
	s ^DHCMed.NINFMapDesc("InfDiag","无症状的泌尿系感染-导尿管相关泌尿系感染") = "无症状菌尿症" 
	s ^DHCMed.NINFMapDesc("InfDiag","无症状的泌尿系感染-非导尿管相关") = "无症状菌尿症" 
	s ^DHCMed.NINFMapDesc("InfDiag","有症状的泌尿道感染-导尿管相关泌尿系感染") = "有症状的泌尿道感染" 
	s ^DHCMed.NINFMapDesc("InfDiag","有症状的泌尿道感染-非导尿管相关") = "有症状的泌尿道感染" 
	s ^DHCMed.NINFMapDesc("InfDiag","气管炎、支气管炎-气管炎、支气管炎") = "气管炎、支气管炎" 
	s ^DHCMed.NINFMapDesc("InfDiag","深部切口-") = "深部手术切口感染" 
	s ^DHCMed.NINFMapDesc("InfDiag","深部切口-深部切口") = "深部手术切口感染" 
	s ^DHCMed.NINFMapDesc("InfDiag","病毒性肝炎-病毒性肝炎") = "病毒性肝炎" 
	s ^DHCMed.NINFMapDesc("InfDiag","皮肤软组织-") = "皮肤感染" 
	s ^DHCMed.NINFMapDesc("InfDiag","皮肤软组织-皮肤感染") = "皮肤感染" 
	s ^DHCMed.NINFMapDesc("InfDiag","皮肤软组织-软组织感染") = "软组织感染" 
	s ^DHCMed.NINFMapDesc("InfDiag","细菌性脑膜炎、脑室炎-手术相关") = "细菌性脑膜炎、脑室炎" 
	s ^DHCMed.NINFMapDesc("InfDiag","细菌性脑膜炎、脑室炎-非手术相关") = "细菌性脑膜炎、脑室炎" 
	s ^DHCMed.NINFMapDesc("InfDiag","肺炎-") = "肺炎" 
	s ^DHCMed.NINFMapDesc("InfDiag","肺炎-其他肺炎") = "肺炎" 
	s ^DHCMed.NINFMapDesc("InfDiag","肺炎-呼吸机相关性肺炎") = "肺炎" 
	s ^DHCMed.NINFMapDesc("InfDiag","肺炎-术后肺炎") = "肺炎" 
	s ^DHCMed.NINFMapDesc("InfDiag","胃肠道-感染性腹泻") = "感染性腹泻" 
	s ^DHCMed.NINFMapDesc("InfDiag","胃肠道-抗菌药物相关性腹泻") = "抗菌药物相关性腹泻" 
	s ^DHCMed.NINFMapDesc("InfDiag","胃肠道-胃肠道感染") = "胃肠道感染" 
	s ^DHCMed.NINFMapDesc("InfDiag","胸膜腔感染-手术相关") = "胸膜腔感染" 
	s ^DHCMed.NINFMapDesc("InfDiag","腹(盆)腔内组织感染-手术相关") = "腹（盆）腔内组织感染" 
	s ^DHCMed.NINFMapDesc("InfDiag","腹(盆)腔内组织感染-非手术相关") = "腹（盆）腔内组织感染" 
	s ^DHCMed.NINFMapDesc("InfDiag","腹水感染-腹水感染") = "腹水感染" 
	s ^DHCMed.NINFMapDesc("InfDiag","血管相关性感染-手术相关") = "血管相关性感染" 
	s ^DHCMed.NINFMapDesc("InfDiag","血管相关性感染-非手术相关") = "血管相关性感染" 
	s ^DHCMed.NINFMapDesc("InfDiag","表浅切口感染-表浅切口感染") = "表浅手术切口感染" 
	s ^DHCMed.NINFMapDesc("InfDiag","败血症-") = "败血症（bacteremia）" 
	s ^DHCMed.NINFMapDesc("InfDiag","败血症-其他原发血流感染") = "败血症（bacteremia）" 
	s ^DHCMed.NINFMapDesc("InfDiag","败血症-导管相关性血流感染") = "败血症（bacteremia）" 
	s ^DHCMed.NINFMapDesc("InfDiag","败血症-继发血流感染") = "败血症（bacteremia）" 
	s ^DHCMed.NINFMapDesc("InfDiag","口腔、舌、牙龈部位感染-非手术相关") = "口腔、舌、牙龈部位感染" 
	s ^DHCMed.NINFMapDesc("InfDiag","男女性生殖道的其它感染-非手术相关") = "男女性生殖道的其它感染" 
	s ^DHCMed.NINFMapDesc("InfDiag","胸膜腔感染-非手术相关") = "胸膜腔感染" 
	s ^DHCMed.NINFMapDesc("InfDiag","血管相关性感染-") = "血管相关性感染" 
	s ^DHCMed.NINFMapDesc("InfDiag","关节和关节囊感染-非手术相关") = "关节和关节囊感染" 
	s ^DHCMed.NINFMapDesc("InfDiag","口腔、舌、牙龈部位感染-手术相关") = "口腔、舌、牙龈部位感染" 
	s ^DHCMed.NINFMapDesc("InfDiag","心膜炎-非手术相关") = "心内膜炎" 
	s ^DHCMed.NINFMapDesc("InfDiag","急性盆腔炎-手术相关") = "急性盆腔炎" 
	s ^DHCMed.NINFMapDesc("InfDiag","椎管内感染-手术相关") = "椎管内感染" 
	s ^DHCMed.NINFMapDesc("InfDiag","气管炎、支气管炎-") = "气管炎、支气管炎" 
	s ^DHCMed.NINFMapDesc("InfDiag","病毒性肝炎-") = "病毒性肝炎" 
	s ^DHCMed.NINFMapDesc("InfDiag","皮肤软组织-褥疮感染") = "褥疮感染" 
	s ^DHCMed.NINFMapDesc("InfDiag","纵膈感染-手术相关") = "纵膈感染" 
	s ^DHCMed.NINFMapDesc("InfDiag","纵膈感染-非手术相关") = "纵膈感染" 
	s ^DHCMed.NINFMapDesc("InfDiag","胃肠道-") = "胃肠道感染" 
	s ^DHCMed.NINFMapDesc("InfDiag","透析相关感染-血管通路感染") = "透析相关感染" 
	s ^DHCMed.NINFMapDesc("InfDiag","颅内脓肿-手术相关") = "颅内脓肿" 
	s ^DHCMed.NINFMapDesc("InfDiag","颅内脓肿-非手术相关") = "颅内脓肿" 
	s ^DHCMed.NINFMapDesc("NINFInfDiagCategory","上呼吸道感染-上呼吸道感染") = "无" 
	s ^DHCMed.NINFMapDesc("NINFInfDiagCategory","关节和关节囊感染-手术相关") = "无" 
	s ^DHCMed.NINFMapDesc("NINFInfDiagCategory","其它-") = "无" 
	s ^DHCMed.NINFMapDesc("NINFInfDiagCategory","其它-其它") = "无" 
	s ^DHCMed.NINFMapDesc("NINFInfDiagCategory","外阴切口感染-外阴切口感染") = "无" 
	s ^DHCMed.NINFMapDesc("NINFInfDiagCategory","无症状的泌尿系感染-") = "非导尿管相关泌尿系感染" 
	s ^DHCMed.NINFMapDesc("NINFInfDiagCategory","无症状的泌尿系感染-导尿管相关泌尿系感染") = "导尿管相关泌尿系感染(CA-UTI)" 
	s ^DHCMed.NINFMapDesc("NINFInfDiagCategory","无症状的泌尿系感染-非导尿管相关") = "非导尿管相关泌尿系感染" 
	s ^DHCMed.NINFMapDesc("NINFInfDiagCategory","有症状的泌尿道感染-导尿管相关泌尿系感染") = "导尿管相关泌尿系感染(CA-UTI)" 
	s ^DHCMed.NINFMapDesc("NINFInfDiagCategory","有症状的泌尿道感染-非导尿管相关") = "非导尿管相关泌尿系感染" 
	s ^DHCMed.NINFMapDesc("NINFInfDiagCategory","气管炎、支气管炎-气管炎、支气管炎") = "无" 
	s ^DHCMed.NINFMapDesc("NINFInfDiagCategory","深部切口-") = "无" 
	s ^DHCMed.NINFMapDesc("NINFInfDiagCategory","深部切口-深部切口") = "无" 
	s ^DHCMed.NINFMapDesc("NINFInfDiagCategory","病毒性肝炎-病毒性肝炎") = "无" 
	s ^DHCMed.NINFMapDesc("NINFInfDiagCategory","皮肤软组织-") = "无" 
	s ^DHCMed.NINFMapDesc("NINFInfDiagCategory","皮肤软组织-皮肤感染") = "无" 
	s ^DHCMed.NINFMapDesc("NINFInfDiagCategory","皮肤软组织-软组织感染") = "无" 
	s ^DHCMed.NINFMapDesc("NINFInfDiagCategory","细菌性脑膜炎、脑室炎-手术相关") = "手术相关" 
	s ^DHCMed.NINFMapDesc("NINFInfDiagCategory","细菌性脑膜炎、脑室炎-非手术相关") = "非手术相关" 
	s ^DHCMed.NINFMapDesc("NINFInfDiagCategory","肺炎-") = "其他肺炎" 
	s ^DHCMed.NINFMapDesc("NINFInfDiagCategory","肺炎-其他肺炎") = "其他肺炎" 
	s ^DHCMed.NINFMapDesc("NINFInfDiagCategory","肺炎-呼吸机相关性肺炎") = "呼吸机相关性肺炎(VAP)" 
	s ^DHCMed.NINFMapDesc("NINFInfDiagCategory","肺炎-术后肺炎") = "术后肺炎" 
	s ^DHCMed.NINFMapDesc("NINFInfDiagCategory","胃肠道-感染性腹泻") = "无" 
	s ^DHCMed.NINFMapDesc("NINFInfDiagCategory","胃肠道-抗菌药物相关性腹泻") = "无" 
	s ^DHCMed.NINFMapDesc("NINFInfDiagCategory","胃肠道-胃肠道感染") = "无" 
	s ^DHCMed.NINFMapDesc("NINFInfDiagCategory","胸膜腔感染-手术相关") = "手术相关" 
	s ^DHCMed.NINFMapDesc("NINFInfDiagCategory","腹(盆)腔内组织感染-手术相关") = "手术相关" 
	s ^DHCMed.NINFMapDesc("NINFInfDiagCategory","腹(盆)腔内组织感染-非手术相关") = "非手术相关" 
	s ^DHCMed.NINFMapDesc("NINFInfDiagCategory","腹水感染-腹水感染") = "无" 
	s ^DHCMed.NINFMapDesc("NINFInfDiagCategory","血管相关性感染-手术相关") = "手术相关" 
	s ^DHCMed.NINFMapDesc("NINFInfDiagCategory","血管相关性感染-非手术相关") = "非手术相关" 
	s ^DHCMed.NINFMapDesc("NINFInfDiagCategory","表浅切口感染-表浅切口感染") = "无" 
	s ^DHCMed.NINFMapDesc("NINFInfDiagCategory","败血症-") = "其他原发性血流感染" 
	s ^DHCMed.NINFMapDesc("NINFInfDiagCategory","败血症-其他原发血流感染") = "其他原发性血流感染" 
	s ^DHCMed.NINFMapDesc("NINFInfDiagCategory","败血症-导管相关性血流感染") = "导管相关性血流感染(CR-BSI)" 
	s ^DHCMed.NINFMapDesc("NINFInfDiagCategory","败血症-继发血流感染") = "继发性血流感染" 
	s ^DHCMed.NINFMapDesc("NINFInfDiagCategory","口腔、舌、牙龈部位感染-非手术相关") = "非手术相关" 
	s ^DHCMed.NINFMapDesc("NINFInfDiagCategory","男女性生殖道的其它感染-非手术相关") = "非手术相关" 
	s ^DHCMed.NINFMapDesc("NINFInfDiagCategory","胸膜腔感染-非手术相关") = "非手术相关" 
	s ^DHCMed.NINFMapDesc("NINFInfDiagCategory","血管相关性感染-") = "无" 
	s ^DHCMed.NINFMapDesc("NINFInfDiagCategory","关节和关节囊感染-非手术相关") = "非手术相关" 
	s ^DHCMed.NINFMapDesc("NINFInfDiagCategory","口腔、舌、牙龈部位感染-手术相关") = "手术相关" 
	s ^DHCMed.NINFMapDesc("NINFInfDiagCategory","心膜炎-非手术相关") = "非手术相关" 
	s ^DHCMed.NINFMapDesc("NINFInfDiagCategory","急性盆腔炎-手术相关") = "手术相关" 
	s ^DHCMed.NINFMapDesc("NINFInfDiagCategory","椎管内感染-手术相关") = "手术相关" 
	s ^DHCMed.NINFMapDesc("NINFInfDiagCategory","气管炎、支气管炎-") = "无" 
	s ^DHCMed.NINFMapDesc("NINFInfDiagCategory","病毒性肝炎-") = "无" 
	s ^DHCMed.NINFMapDesc("NINFInfDiagCategory","皮肤软组织-褥疮感染") = "无" 
	s ^DHCMed.NINFMapDesc("NINFInfDiagCategory","纵膈感染-手术相关") = "手术相关" 
	s ^DHCMed.NINFMapDesc("NINFInfDiagCategory","纵膈感染-非手术相关") = "非手术相关" 
	s ^DHCMed.NINFMapDesc("NINFInfDiagCategory","胃肠道-") = "无" 
	s ^DHCMed.NINFMapDesc("NINFInfDiagCategory","透析相关感染-血管通路感染") = "导管相关性血流感染(CR-BSI)" 
	s ^DHCMed.NINFMapDesc("NINFInfDiagCategory","颅内脓肿-手术相关") = "手术相关" 
	s ^DHCMed.NINFMapDesc("NINFInfDiagCategory","颅内脓肿-非手术相关") = "非手术相关" 
	
	Set xRepID=0
	For {
		Set xRepID=$o(^DHCMed.INF.ReportD(xRepID))
		Quit:xRepID=""
		
		Write "ReportID="_xRepID,!
		
		//1 报告信息
		Set xobjRep=##class(DHCMed.INF.Report).GetObjById(xRepID)
		Continue:'$IsObject(xobjRep)
		Set EpisodeID=xobjRep.PaadmDR
		Set tmpCode=xobjRep.Type
		Continue:tmpCode'=1
		Set ReportType=..ChangeDic("NINFInfReportType","","InfectionType"_":"_tmpCode,"")
		Set ReportLoc=xobjRep.CtLoc
		Set ReportUser=xobjRep.UserDR
		Set ReportDate=xobjRep.RepDate
		Set ReportTime=xobjRep.RepTime
		Set tmpCode=xobjRep.StatusDr
		Set ReportStatus=..ChangeDic("NINFInfReportStatus","","InfectionReportStatus"_":"_tmpCode,"")
		
		Set tmpTrans=..GetTransLoc(EpisodeID,"E",ReportDate,ReportTime)
		Set TransID=$p(tmpTrans,$c(1),1)
		Set TransLoc=$p(tmpTrans,$c(1),2)
		
		Set inputStr=""
		Set inputStr=inputStr_$c(1)_EpisodeID
		Set inputStr=inputStr_$c(1)_ReportType
		Set inputStr=inputStr_$c(1)_TransID
		Set inputStr=inputStr_$c(1)_ReportLoc
		Set inputStr=inputStr_$c(1)_ReportUser
		Set inputStr=inputStr_$c(1)_ReportDate
		Set inputStr=inputStr_$c(1)_ReportTime
		Set inputStr=inputStr_$c(1)_ReportStatus
		Set inputStr=inputStr_$c(1)_ReportLoc_$c(2)_ReportUser_$c(2)_ReportStatus
		Set flg=##Class(DHCMed.NINFService.Rep.InfReport).SaveRepRec(inputStr,$c(1)_","_$c(2))
		Set ^DHCMed.NINFMapRst(xRepID,"Rep")=flg
		Continue:flg<1
		Set ReportID=flg
		
		//2 摘要信息
		Set xSummID=$o(^DHCMed.INF.SummaryI("InfRepDr",xRepID,""),-1)
		If xSummID'="" {
			Set xobjSumm=##class(DHCMed.INF.Summary).GetObjById(xSummID)
			If $IsObject(xobjSumm) {
				Set tmpCode=xobjSumm.LapseTo
				Set DiseasePrognosis=..ChangeDic("NINFInfDiseasePrognosis","","InfectionDiagnosePrognosis"_":"_tmpCode,"")
				Set DeathRelation=""
				If DiseasePrognosis'="" {
					Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(DiseasePrognosis)
					If $IsObject(objDic) {
						If objDic.Description="死亡" {
							Set tmpCode=xobjSumm.DeathConnection
							Set DeathRelation=..ChangeDic("NINFInfDeathRelation","","InfDieRelation"_":"_tmpCode,"")
						}
					}
				}
				Set DiagnosisBasis=xobjSumm.Treatment
				Set DiseaseCourse=xobjSumm.Analysis
				Set InfFactors=""
				Set InvasiveOper=""
				Set tmpDesc=$s(xobjSumm.ICUFlag=1:"是",1:"否")
				If tmpDesc="否" {
					Set num=##class(DHCMed.NINFService.Rep.InfReportOpr).IsCheckICU(EpisodeID)
					If (num>0) {
						Set tmpDesc="是"
					}
				}
				Set tmpDesc=$s(xobjSumm.ICUFlag=1:"是",1:"否")
				Set ICUBoolean=..ChangeDic("NINFInfICUBoolean","","",tmpDesc)
				Set ICULocation=""
				Set tmpDesc="否"
				If $d(^DHCMed.INF.RepOPRI("InfRepDr",xRepID)) {
					Set tmpDesc="是"
				}
				If tmpDesc="否" {
					Set num=##class(DHCMed.NINFService.Rep.InfReportOpr).IsCheckOpr(EpisodeID)
					If (num>0) {
						Set tmpDesc="是"
					}
				}
				Set OprBoolean=..ChangeDic("NINFInfOprBoolean","","",tmpDesc)
				Set tmpDesc="否"
				If $d(^DHCMed.INF.PathogenyI("InfRepDr",xRepID)) {
					Set tmpDesc="是"
				}
				If tmpDesc="否" {
					Set num=##class(DHCMed.NINFService.Rep.InfReportLab).IsCheckLab(EpisodeID)
					If (num>0) {
						Set tmpDesc="是"
					}
				}
				Set LabBoolean=..ChangeDic("NINFInfLabBoolean","","",tmpDesc)
				Set tmpDesc="否"
				If $d(^DHCMed.INF.RepDrugI("InfRepDr",xRepID)) {
					Set tmpDesc="是"
				}
				If tmpDesc="否" {
					Set num=##class(DHCMed.NINFService.Rep.InfReportAnti).IsCheckAnti(EpisodeID)
					If (num>0) {
						Set tmpDesc="是"
					}
				}
				Set AntiBoolean=..ChangeDic("NINFInfAntiBoolean","","",tmpDesc)
				Set tmpDesc=$s(xobjSumm.DrugEffect="Y":"有",1:"无")
				Set AdverseReaction=..ChangeDic("NINFInfAdverseReaction","","",tmpDesc)
				Set tmpDesc=$s(xobjSumm.DblInfFlag="Y":"有",1:"无")
				Set Superinfection=..ChangeDic("NINFInfSuperinfection","","",tmpDesc)
				Set BornWeight=""
			}
		}
		
		Set xReaID=0,InfFactors=""
		For {
			Set xReaID=$o(^DHCMed.INF.RepReasonI("InfRepDr",xRepID,xReaID))
			Quit:xReaID=""
			Set xobjRea=##class(DHCMed.INF.RepReason).GetObjById(xReaID)
			Continue:'$IsObject(xobjRea)
			Set tmpCode=xobjRea.InfReason
			Set InfFactor=..ChangeDic("NINFInfInfFactors","","InfectionDangerousFactor"_":"_tmpCode,"")
			Set InfFactors=InfFactors_$c(2)_InfFactor
		}
		Set:InfFactors'="" InfFactors=$e(InfFactors,2,$l(InfFactors))
		
		Set xInfPosID=0,InvasiveOpers=""
		For {
			Set xInfPosID=$o(^DHCMed.INF.RepPosI("InfRepDr",xRepID,xInfPosID))
			Quit:xInfPosID=""
			Set xobjInfPos=##class(DHCMed.INF.RepPos).GetObjById(xInfPosID)
			Continue:'$IsObject(xobjInfPos)
			Set tmpCode=xobjInfPos.InroadOpr
			Set InvasiveOper=..ChangeDic("NINFInfInvasiveOper","","InfectionDestructiveOperation"_":"_tmpCode,"")
			Set InvasiveOpers=InvasiveOpers_$c(2)_InvasiveOper
		}
		Set:InvasiveOpers'="" InvasiveOpers=$e(InvasiveOpers,2,$l(InvasiveOpers))
		
		Set inputStr=ReportID
		Set inputStr=inputStr_$c(1)_""
		Set inputStr=inputStr_$c(1)_$g(DiseasePrognosis)
		Set inputStr=inputStr_$c(1)_$g(DeathRelation)
		Set inputStr=inputStr_$c(1)_$g(DiagnosisBasis)
		Set inputStr=inputStr_$c(1)_$g(DiseaseCourse)
		Set inputStr=inputStr_$c(1)_$g(InfFactors)
		Set inputStr=inputStr_$c(1)_$g(InvasiveOper)
		Set inputStr=inputStr_$c(1)_$g(ICUBoolean)
		Set inputStr=inputStr_$c(1)_$g(ICULocation)
		Set inputStr=inputStr_$c(1)_$g(OprBoolean)
		Set inputStr=inputStr_$c(1)_$g(LabBoolean)
		Set inputStr=inputStr_$c(1)_$g(AntiBoolean)
		Set inputStr=inputStr_$c(1)_$g(AdverseReaction)
		Set inputStr=inputStr_$c(1)_$g(Superinfection)
		Set inputStr=inputStr_$c(1)_$g(BornWeight)
		Set inputStr=inputStr_$c(1)_$g(TransID)
		Set inputStr=inputStr_$c(1)_$g(TransLoc)
		Set flg=##class(DHCMed.NINFService.Rep.InfReportSumm).SaveSubRec(inputStr,$c(1)_","_$c(2))
		Set ^DHCMed.NINFMapRst(xRepID,"Summ")=flg
		
		//3 疾病诊断
		Set inputStr=""
		Set xICD=""
		For {
			Set xICD=$o(^DHCMed.INF.RepDiagRelI("TypeA"," "_xobjRep.Type," "_xRepID,xICD))
			Quit:xICD=""
			Set xDiagID=0
			For {
				Set xDiagID=$o(^DHCMed.INF.RepDiagRelI("TypeA"," "_xobjRep.Type," "_xRepID,xICD,xDiagID))
				Quit:xDiagID=""
				Set xobjDiag=##class(DHCMed.INF.RepDiagRel).GetObjById(xDiagID)
				Continue:'$IsObject(xobjDiag)
				
				Set DataSource=""
				Set DiagnosID=xobjDiag.ICDDr
				Set DiagnosDesc=xobjDiag.ICD10Desc
				If (DiagnosDesc="")&&(DiagnosID'="") {
					Set DiagnosDesc=$p($g(^MRC("ID",DiagnosID)),"^",2)
				}
				Set DiagnosDate=xobjDiag.DiagDate
				Set DiagnosTime=xobjDiag.DiagTime
				
				Set inputStr=ReportID
				Set inputStr=inputStr_$c(1)_""
				Set inputStr=inputStr_$c(1)_DataSource
				Set inputStr=inputStr_$c(1)_DiagnosID
				Set inputStr=inputStr_$c(1)_DiagnosDesc
				Set inputStr=inputStr_$c(1)_DiagnosDate
				Set inputStr=inputStr_$c(1)_DiagnosTime
				Set inputStr=inputStr_$c(1)_""  //诊断类型
				
				Set flg=##class(DHCMed.NINFService.Rep.InfReportDiag).SaveSubRec(inputStr,$c(1)_","_$c(2))
				Set ^DHCMed.NINFMapRst(xRepID,"Diag")=$g(^DHCMed.NINFMapRst(xRepID,"Diag"))_","_flg
			}
		}
		
		//4 感染信息
		Set inputStr=""
		Kill ^TMP($zn,$j,"InfPosData")
		If xSummID'="" {
			Set xInfPosID=0
			For {
				Set xInfPosID=$o(^DHCMed.INF.RepPosI("InfRepDr",xSummID,xInfPosID))
				Quit:xInfPosID=""
				Set xobjInfPos=##class(DHCMed.INF.RepPos).GetObjById(xInfPosID)
				Continue:'$IsObject(xobjInfPos)
				Set ^TMP($zn,$j,"InfPosData",xRepID," "_xobjInfPos.InfPosCode," "_xobjInfPos.InfDate," "_xobjInfPos.InfDiagDR," "_xobjInfPos.InroadOpr,xInfPosID)=""
			}
		}
		Set InfPosCode=""
		For {
			Set InfPosCode=$o(^TMP($zn,$j,"InfPosData",xRepID,InfPosCode))
			Quit:InfPosCode=""
			Set InfDate=""
			For {
				Set InfDate=$o(^TMP($zn,$j,"InfPosData",xRepID,InfPosCode,InfDate))
				Quit:InfDate=""
				Set InfDiagDR=""
				For {
					Set InfDiagDR=$o(^TMP($zn,$j,"InfPosData",xRepID,InfPosCode,InfDate,InfDiagDR))
					Quit:InfDiagDR=""
					
					Set InroadOpr="",InvasiveOpers=""
					For {
						Set InroadOpr=$o(^TMP($zn,$j,"InfPosData",xRepID,InfPosCode,InfDate,InfDiagDR,InroadOpr))
						Quit:InroadOpr=""
						Set tmpCode=$e(InroadOpr,2,$l(InroadOpr))
						Set InvasiveOper=..ChangeDic("NINFInfInvasiveOper","","InfectionDestructiveOperation"_":"_tmpCode,"")
						Set InvasiveOpers=InvasiveOpers_$c(2)_InvasiveOper
						Set InvasiveOpers=InvasiveOpers_$c(3)_""
						Set InvasiveOpers=InvasiveOpers_$c(3)_""
						Set InvasiveOpers=InvasiveOpers_$c(3)_""
						Set InvasiveOpers=InvasiveOpers_$c(3)_""
					}
					Set:InvasiveOpers'="" InvasiveOpers=$e(InvasiveOpers,2,$l(InvasiveOpers))
					
					Set tmpPosID=$e(InfPosCode,2,$l(InfPosCode))
					Set tmpDiagID=$e(InfDiagDR,2,$l(InfDiagDR))
					Set xInfPos=..ChangeDic("InfPos",tmpPosID_","_tmpDiagID,"","")
					Set xInfDate=$e(InfDate,2,$l(InfDate))
					Set xInfDiag=..ChangeDic("InfDiag",tmpPosID_","_tmpDiagID,"","")
					Set xInfDiagCat=..ChangeDic("NINFInfDiagCategory",tmpPosID_","_tmpDiagID,"","")
					
					Set inputStr=ReportID
					Set inputStr=inputStr_$c(1)_""
					Set inputStr=inputStr_$c(1)_""
					Set inputStr=inputStr_$c(1)_xInfPos
					Set inputStr=inputStr_$c(1)_xInfDate
					Set inputStr=inputStr_$c(1)_xInfDiag
					Set inputStr=inputStr_$c(1)_InvasiveOpers
					Set inputStr=inputStr_$c(1)_""
					Set inputStr=inputStr_$c(1)_""
					Set inputStr=inputStr_$c(1)_""
					Set inputStr=inputStr_$c(1)_""
					Set inputStr=inputStr_$c(1)_xInfDiagCat
					
					Set flg=##class(DHCMed.NINFService.Rep.InfReportInfPos).SaveSubRec(inputStr,$c(1)_","_$c(2)_","_$c(3)_","_$c(4))
					Set ^DHCMed.NINFMapRst(xRepID,"InfPos")=$g(^DHCMed.NINFMapRst(xRepID,"InfPos"))_","_flg
				}
			}
		}
		Kill ^TMP($zn,$j,"InfPosData")
		
		//5 手术信息
		Set xOprID=0
		For {
			Set xOprID=$o(^DHCMed.INF.RepOPRI("InfRepDr",xRepID,xOprID))
			Quit:xOprID=""
			
			Set xobjOpr=##class(DHCMed.INF.RepOPR).GetObjById(xOprID)
			Continue:'$IsObject(xobjOpr)
			
			Set OperationID=""
			Set OperationDesc=xobjOpr.OperationDesc
			Set OEORIDr=xobjOpr.OEORIDr
			If OEORIDr'="" {
				Set OrdsOperFlag=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("OrdsOperFlag","")
			 	If OrdsOperFlag=0 {
			 		Set DataSource="OEITEM:"_OEORIDr
			 	} ElseIf OrdsOperFlag=2 {
			 		Set DataSource="OPANA:"_OEORIDr
			 		Set tmpOper=$g(^OR(+OEORIDr,"ANA",+$p(OEORIDr,"||",2),"OP",+$p(OEORIDr,"||",3)))
		    		If tmpOper'="" {
			    		Set OperationID=$p(tmpOper,"^",6)
			    		Set:OperationID'="" OperationDesc=$p($g(^ORC("OPER",OperationID)),"^",2)
			    	}
				} Else {
					Set DataSource="OEITEM:"_OEORIDr
				}
			}
			Continue:OperationDesc=""
			
			Set OperStartDate=xobjOpr.DateFrom
			Set OperStartTime=xobjOpr.TimeFrom
			Set OperEndDate=xobjOpr.DateTo
			Set OperEndTime=xobjOpr.TimeTo
			Set OperDoc=xobjOpr.OprDoc
			Set tmpDesc=$s(xobjOpr.EmerOprFlag="Y":"急诊",1:"择期")
			Set OperationType=..ChangeDic("NINFInfOperationType","","",tmpDesc)
			Set tmpCode=xobjOpr.Anaesthesia
			Set Anesthesia=..ChangeDic("NINFInfAnesthesia","","InfectionNarcosisType"_":"_tmpCode,"")
			Set tmpCode=xobjOpr.CuteType
			Set CuteType=..ChangeDic("NINFInfCuteType","","InfectionOpeCutType"_":"_tmpCode,"")
			Set tmpCode=xobjOpr.Concrescence
			Set CuteHealing=..ChangeDic("NINFInfCuteHealing","","InfectionWoundCicatrize"_":"_tmpCode,"")
			Set tmpDesc=$s(xobjOpr.CuteInfFlag="Y":"是",1:"否")
			Set CuteInfFlag=..ChangeDic("NINFInfCuteInfFlag","","",tmpDesc)
			Set tmpCode=xobjOpr.OprCuteType
			Set OperInfType=..ChangeDic("NINFInfOperInfType","","InfectionOperationCutType"_":"_tmpCode,"")
			Set tmpDesc=$s(xobjOpr.InfectionFlag="Y":"是",1:"否")
			Set InHospInfFlag=..ChangeDic("NINFInfCuteInfFlag","","",tmpDesc)
			
			Set inputStr=ReportID
			Set inputStr=inputStr_$c(1)_""
			Set inputStr=inputStr_$c(1)_DataSource
			Set inputStr=inputStr_$c(1)_OperationID
			Set inputStr=inputStr_$c(1)_OperationDesc
			Set inputStr=inputStr_$c(1)_OperStartDate
			Set inputStr=inputStr_$c(1)_OperStartTime
			Set inputStr=inputStr_$c(1)_OperEndDate
			Set inputStr=inputStr_$c(1)_OperEndTime
			Set inputStr=inputStr_$c(1)_OperDoc
			Set inputStr=inputStr_$c(1)_OperationType
			Set inputStr=inputStr_$c(1)_Anesthesia
			Set inputStr=inputStr_$c(1)_CuteType
			Set inputStr=inputStr_$c(1)_CuteHealing
			Set inputStr=inputStr_$c(1)_CuteInfFlag
			Set inputStr=inputStr_$c(1)_OperInfType
			Set inputStr=inputStr_$c(1)_InHospInfFlag
			
			Set flg=##class(DHCMed.NINFService.Rep.InfReportOpr).SaveSubRec(inputStr,$c(1)_","_$c(2))
			Set ^DHCMed.NINFMapRst(xRepID,"Opr",xOprID)=flg
		}
		
		//6 检验信息
		Set xLabID=0
		For {
			Set xLabID=$o(^DHCMed.INF.PathogenyI("InfRepDr",xRepID,xLabID))
			Quit:xLabID=""
			
			Set xobjLab=##class(DHCMed.INF.Pathogeny).GetObjById(xLabID)
			Continue:'$IsObject(xobjLab)
			
			Set OEOrdItem=xobjLab.OEORIDR
			Set objOEItem=##class(DHCMed.Base.OrdItem).GetObjById(OEOrdItem)
			Continue:'$IsObject(objOEItem)
			Set DataSource="OEITEM:"_OEOrdItem
			Set ArcimID=objOEItem.OEORIItmMastDR
			Set:ArcimID'="" ArcimDesc=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",2)
			Continue:ArcimDesc=""
			
			Set tmpCode=xobjLab.Sample
			Set Specimen=..ChangeDic("NINFInfSpecimen","","InfectionLabSampleType"_":"_tmpCode,"")
			Set tmpID=xobjLab.InfPosDR
			Set InfectionPos=..ChangeDic("InfPos",tmpID,"","")
			Set SubmissionDate=xobjLab.PathDate
			Set tmpCode=xobjLab.Method
			Set AssayMethod=..ChangeDic("NINFInfAssayMethod","","InfectionPathogenyCheckMethod"_":"_tmpCode,"")
			Set tmpCode=xobjLab.DrugFlag
			Set PathogenTest=..ChangeDic("NINFInfPathogenTest","","InfectionLabSensitive"_":"_tmpCode,"")
			Set TestResults=""
			Set xPyID=0
			For {
				Set xPyID=$o(^DHCMed.INF.PyObjI("InfPathDr",xLabID,xPyID))
				Quit:xPyID=""
				
				Set xobjPy=##class(DHCMed.INF.PyObj).GetObjById(xPyID)
				Continue:'$IsObject(xobjPy)
				Set tmpID=xobjPy.Object
				Set PathogenyID=..ChangeDic("InfPy",tmpID,"","")
				Set PathogenyDesc=""
				Set objPathogeny=##class(DHCMed.NINF.Dic.Pathogeny).GetObjById(PathogenyID)
				If $IsObject(objPathogeny) {
					Set PathogenyDesc=objPathogeny.PYDesc
				}
				Continue:PathogenyDesc=""
				
				Set DrugSenTest=""
				Set xPyAntiID=0
				For {
					Set xPyAntiID=$o(^DHCMed.INF.PyObjDrugI("InfPyObjDr",xPyID,xPyAntiID))
					Quit:xPyAntiID=""
					
					Set xobjPyAnti=##class(DHCMed.INF.PyObjDrug).GetObjById(xPyAntiID)
					Continue:'$IsObject(xobjPyAnti)
					Set tmpID=xobjPyAnti.DrugDR
					Set AntibioticsID=..ChangeDic("InfPyAnti",tmpID,"","")
					Set AntibioticsDesc=""
					Set objAntibiotics=##class(DHCMed.NINF.Dic.Antibiotics).GetObjById(AntibioticsID)
					If $IsObject(objAntibiotics) {
						Set AntibioticsDesc=objAntibiotics.ANTDesc
					}
					Continue:AntibioticsDesc=""
					Set tmpCode=xobjPyAnti.Flag
					Set:tmpCode="C" tmpCode="I"
					Set:tmpCode="Y" tmpCode="S"
					Set:tmpCode="N" tmpCode="R"
					Set SenTestRst=..ChangeDic("NINFInfSenTestRst","","InfectionLabSenCheck"_":"_tmpCode,"")
					Set DrugSenTest=DrugSenTest_$c(4)_AntibioticsID
					Set DrugSenTest=DrugSenTest_$c(5)_AntibioticsDesc
					Set DrugSenTest=DrugSenTest_$c(5)_SenTestRst
				}
				Set:DrugSenTest'="" DrugSenTest=$e(DrugSenTest,2,$l(DrugSenTest))
				
				Set TestResults=TestResults_$c(2)_PathogenyID
				Set TestResults=TestResults_$c(3)_PathogenyDesc
				Set TestResults=TestResults_$c(3)_DrugSenTest
			}
			Set:TestResults'="" TestResults=$e(TestResults,2,$l(TestResults))
			
			Set inputStr=ReportID
			Set inputStr=inputStr_$c(1)_""
			Set inputStr=inputStr_$c(1)_DataSource
			Set inputStr=inputStr_$c(1)_ArcimID
			Set inputStr=inputStr_$c(1)_ArcimDesc
			Set inputStr=inputStr_$c(1)_Specimen
			Set inputStr=inputStr_$c(1)_InfectionPos
			Set inputStr=inputStr_$c(1)_SubmissionDate
			Set inputStr=inputStr_$c(1)_AssayMethod
			Set inputStr=inputStr_$c(1)_PathogenTest
			Set inputStr=inputStr_$c(1)_TestResults
			
			Set flg=##class(DHCMed.NINFService.Rep.InfReportLab).SaveSubRec(inputStr,$c(1)_","_$c(2)_","_$c(3)_","_$c(4)_","_$c(5)_","_$c(6))
			Set ^DHCMed.NINFMapRst(xRepID,"Lab",xLabID)=flg
		}
		
		//7 抗生素信息
		Set xAntiID=0
		For {
			Set xAntiID=$o(^DHCMed.INF.RepDrugI("InfRepDr",xRepID,xAntiID))
			Quit:xAntiID=""
			
			Set xobjAnti=##class(DHCMed.INF.RepDrug).GetObjById(xAntiID)
			Continue:'$IsObject(xobjAnti)
			
			Set ArcimID=xobjAnti.OEORIDR
			Set:ArcimID'="" ArcimDesc=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",2)
			Continue:ArcimDesc=""
			
			Set OrdID=$o(^OEORD(0,"Adm",EpisodeID,""),-1)
			Continue:OrdID=""
			Set xSttDat=$o(^OEORDi(0,"ARCIM",OrdID,ArcimID,""),-1)
			Continue:xSttDat=""
			Set xSubID=$o(^OEORDi(0,"ARCIM",OrdID,ArcimID,xSttDat,""),-1)
			Continue:xSubID=""
			Set OEOrdItem=OrdID_"||"_xSubID
			Set objOEItem=##class(DHCMed.Base.OrdItem).GetObjById(OEOrdItem)
			Continue:'$IsObject(objOEItem)
			Set DataSource="OEITEM:"_OEOrdItem
			
			Set StartDate=xobjAnti.DateFrom
			Set StartTime=""
			Set EndDate=xobjAnti.DateTo
			Set EndTime=""
			Set DoseQty=objOEItem.OEORIDoseQty
			Set DoseUnit=objOEItem.OEORIUnitDR
			Set PhcFreq=objOEItem.OEORIPHFreqDR
			Set PhcFreqDesc=""
			Set:PhcFreq'="" PhcFreqDesc=$p($g(^PHCFR(PhcFreq)),"^",3)
			Set tmpDesc=""
			Set:PhcFreqDesc["术前" tmpDesc="术前用药"
			Set:PhcFreqDesc["术中" tmpDesc="术中用药"
			Set:PhcFreqDesc["术后" tmpDesc="术后用药"
			Set MedUsePurpose=..ChangeDic("NINFInfMedUsePurpose","","",tmpDesc)
			//Set tmpCode=xobjAnti.Mode
			Set tmpCode=xobjAnti.Instr  //给药途径
			Set AdminRoute=..ChangeDic("NINFInfAdminRoute","","InfectionAdministerDrugsRoute"_":"_tmpCode,"")
			Set tmpCode=xobjAnti.Aim
			Set MedPurpose=..ChangeDic("NINFInfMedPurpose","","InfectionAdministerDrugsGoal"_":"_tmpCode,"")
			Set tmpCode=xobjAnti.CureDrugMode
			Set TreatmentMode=..ChangeDic("NINFInfTreatmentMode","","InfectionCureAdministerDrugsType"_":"_tmpCode,"")
			Set tmpCode=xobjAnti.PrevDrugMode
			Set PreMedIndicat=..ChangeDic("NINFInfPreMedIndicat","","InfectionAdministerDrugs"_":"_tmpCode,"")
			Set tmpCode=xobjAnti.PrevDrugEffect
			Set PreMedEffect=..ChangeDic("NINFInfPreMedEffect","","InfDefendDrugEffect"_":"_tmpCode,"")
			Set tmpCode=xobjAnti.UniteDrug
			Set CombinedMed=..ChangeDic("NINFInfCombinedMed","","InfUnionDrug"_":"_tmpCode,"")
			Set PreMedTime=""
			Set PostMedDays=""
			
			Set inputStr=ReportID
			Set inputStr=inputStr_$c(1)_""
			Set inputStr=inputStr_$c(1)_DataSource
			Set inputStr=inputStr_$c(1)_ArcimID
			Set inputStr=inputStr_$c(1)_ArcimDesc
			Set inputStr=inputStr_$c(1)_StartDate
			Set inputStr=inputStr_$c(1)_StartTime
			Set inputStr=inputStr_$c(1)_EndDate
			Set inputStr=inputStr_$c(1)_EndTime
			Set inputStr=inputStr_$c(1)_DoseQty
			Set inputStr=inputStr_$c(1)_DoseUnit
			Set inputStr=inputStr_$c(1)_PhcFreq
			Set inputStr=inputStr_$c(1)_MedUsePurpose
			Set inputStr=inputStr_$c(1)_AdminRoute
			Set inputStr=inputStr_$c(1)_MedPurpose
			Set inputStr=inputStr_$c(1)_TreatmentMode
			Set inputStr=inputStr_$c(1)_PreMedIndicat
			Set inputStr=inputStr_$c(1)_PreMedEffect
			Set inputStr=inputStr_$c(1)_CombinedMed
			Set inputStr=inputStr_$c(1)_PreMedTime
			Set inputStr=inputStr_$c(1)_PostMedDays
			
			Set flg=##class(DHCMed.NINFService.Rep.InfReportAnti).SaveSubRec(inputStr,$c(1)_","_$c(2))
			Set ^DHCMed.NINFMapRst(xRepID,"Anti",xAntiID)=flg
		}
	}
	
	Set ^DHCMed.NINF("InfRep")=$o(^DHCMed.NINF("InfRep",""),-1)
	Quit "OK"
}

/// w ##Class(DHCMed.NINFService.Srv.InfRepVer2).ProcessPyAnti()
ClassMethod ProcessPyAnti()
{
	//update by zf 20160308 数据池相关程序修改(检验)
	//此任务由问题，删除此方法，如果用到再单独写一个方法
	
	Quit "OK"
}

ClassMethod ChangeDic(aTypeCode As %String, aDicID As %String, aDicCode As %String, aDicDesc As %String) As %String
{
	New (aTypeCode,aDicID,aDicCode,aDicDesc)
	Set return=""
	Quit:aTypeCode="" return
	Quit:(aDicID="")&&(aDicCode="")&&(aDicDesc="") return
	Quit:(aDicCode[":")&&($p(aDicCode,":",2)="") return
	
	If aTypeCode="InfPos" {
		Set InfPosDesc=""
		Set InfDiagDesc=""
		If aDicID'="" {
			Set InfPosID=$p(aDicID,",",1)
			Set objInfPos=##class(DHCMed.INF.InfPosition).GetObjById(InfPosID)
			If $IsObject(objInfPos) {
				Set InfPosDesc=objInfPos.InfPosition
			}
			
			Set InfDiagID=$p(aDicID,",",2)
			Set objInfDiag=##class(DHCMed.INF.InfDiagnose).GetObjById(InfDiagID)
			If $IsObject(objInfDiag) {
				Set InfDiagDesc=objInfDiag.DiseaseName
			}
		}
		Quit:(InfDiagDesc="")&&(InfPosDesc="") return
		Set InfPosDesc=InfPosDesc_"-"_InfDiagDesc
		
		If $g(^DHCMed.NINFMapDesc(aTypeCode,InfPosDesc))'="" {
			Set InfPosDesc=$g(^DHCMed.NINFMapDesc(aTypeCode,InfPosDesc))
		}
		
		If $g(^DHCMed.NINFMapDic(aTypeCode,InfPosDesc))="" {
			Quit:$d(^DHCMed.NINFMapErr(aTypeCode,InfPosDesc)) return
			Set InfPosID=0
			For {
				Set InfPosID=$o(^DHCMed.NINFD("InfPos",InfPosID))
				Quit:InfPosID=""
				Quit:return'=""
				Set objInfPos=##class(DHCMed.NINF.Dic.InfPosition).GetObjById(InfPosID)
				Continue:'$IsObject(objInfPos)
				If objInfPos.IPDesc=InfPosDesc {
					Set ^DHCMed.NINFMapDic(aTypeCode,InfPosDesc)=InfPosID
					Set return=InfPosID
				}
			}
			If return="" {
				Set ^DHCMed.NINFMapErr(aTypeCode,InfPosDesc)=""
			}
		} Else {
			Set return=$g(^DHCMed.NINFMapDic(aTypeCode,InfPosDesc))
		}
	} ElseIf aTypeCode="InfDiag" {
		Set InfPosDesc=""
		Set InfDiagDesc=""
		If aDicID'="" {
			Set InfPosID=$p(aDicID,",",1)
			Set objInfPos=##class(DHCMed.INF.InfPosition).GetObjById(InfPosID)
			If $IsObject(objInfPos) {
				Set InfPosDesc=objInfPos.InfPosition
			}
			
			Set InfDiagID=$p(aDicID,",",2)
			Set objInfDiag=##class(DHCMed.INF.InfDiagnose).GetObjById(InfDiagID)
			If $IsObject(objInfDiag) {
				Set InfDiagDesc=objInfDiag.DiseaseName
			}
		}
		Quit:(InfDiagDesc="")&&(InfPosDesc="") return
		Set InfDiagDesc=InfPosDesc_"-"_InfDiagDesc
		
		If $g(^DHCMed.NINFMapDesc(aTypeCode,InfDiagDesc))'="" {
			Set InfDiagDesc=$g(^DHCMed.NINFMapDesc(aTypeCode,InfDiagDesc))
		} Else {
			Set ^DHCMed.NINFMapErr(aTypeCode,InfDiagDesc)=""
			Quit return
		}
		
		If $g(^DHCMed.NINFMapDic(aTypeCode,InfDiagDesc))="" {
			Quit:$d(^DHCMed.NINFMapErr(aTypeCode,InfDiagDesc)) return
			Set InfDiagID=0
			For {
				Set InfDiagID=$o(^DHCMed.NINFD("InfDia",InfDiagID))
				Quit:InfDiagID=""
				Quit:return'=""
				Set objInfDiag=##class(DHCMed.NINF.Dic.InfDiagnose).GetObjById(InfDiagID)
				Continue:'$IsObject(objInfDiag)
				If objInfDiag.IDDesc=InfDiagDesc {
					Set ^DHCMed.NINFMapDic(aTypeCode,InfDiagDesc)=InfDiagID
					Set return=InfDiagID
				}
			}
			If return="" {
				Set ^DHCMed.NINFMapErr(aTypeCode,InfDiagDesc)=""
			}
		} Else {
			Set return=$g(^DHCMed.NINFMapDic(aTypeCode,InfDiagDesc))
		}
	} ElseIf aTypeCode="NINFInfDiagCategory" {
		Set InfPosDesc=""
		Set InfDiagDesc=""
		If aDicID'="" {
			Set InfPosID=$p(aDicID,",",1)
			Set objInfPos=##class(DHCMed.INF.InfPosition).GetObjById(InfPosID)
			If $IsObject(objInfPos) {
				Set InfPosDesc=objInfPos.InfPosition
			}
			
			Set InfDiagID=$p(aDicID,",",2)
			Set objInfDiag=##class(DHCMed.INF.InfDiagnose).GetObjById(InfDiagID)
			If $IsObject(objInfDiag) {
				Set InfDiagDesc=objInfDiag.DiseaseName
			}
		}
		Quit:(InfDiagDesc="")&&(InfPosDesc="") return
		Set DicDesc=InfPosDesc_"-"_InfDiagDesc
		
		If $g(^DHCMed.NINFMapDesc(aTypeCode,DicDesc))'="" {
			Set DicDesc=$g(^DHCMed.NINFMapDesc(aTypeCode,DicDesc))
		} Else {
			Set ^DHCMed.NINFMapErr(aTypeCode,DicDesc)=""
			Quit return
		}
		Quit:DicDesc="无" return //把不需要对照的过滤掉
		
		If $g(^DHCMed.NINFMapDic(aTypeCode,DicDesc))="" {
			Quit:$d(^DHCMed.NINFMapErr(aTypeCode,DicDesc)) return
			Set DicID=##Class(DHCMed.NINFService.Srv.CommonCls).GetDicIDByDesc(aTypeCode,DicDesc)
			If DicID'="" {
				Set ^DHCMed.NINFMapDic(aTypeCode,DicDesc)=DicID
				Set return=DicID
			} Else {
				Set ^DHCMed.NINFMapErr(aTypeCode,DicDesc)=""
			}
		} Else {
			Set return=$g(^DHCMed.NINFMapDic(aTypeCode,DicDesc))
		}
	} ElseIf aTypeCode="InfPy" {
		Set InfPyDesc=aDicDesc
		If aDicID'="" {
			Set objInfPy=##class(DHCMed.INF.InfPathogenDic).GetObjById(aDicID)
			If $IsObject(objInfPy) {
				Set InfPyDesc=objInfPy.Description
			} Else {
				Set ^DHCMed.NINFMapErr(aTypeCode,aDicID)=""
				Quit return
			}
		}
		Quit:InfPyDesc="" return
		
		If $g(^DHCMed.NINFMapDesc(aTypeCode,InfPyDesc))'="" {
			Set InfPyDesc=$g(^DHCMed.NINFMapDesc(aTypeCode,InfPyDesc))
		}
		
		If $g(^DHCMed.NINFMapDic(aTypeCode,InfPyDesc))="" {
			Quit:$d(^DHCMed.NINFMapErr(aTypeCode,InfPyDesc)) return
			Set InfPyID=$o(^DHCMed.NINFDi("Py",0,"IndexDesc"," "_$zcvt(InfPyDesc,"U"),0))
			If InfPyID="" {
				Set InfPyID=$o(^DHCMed.NINFDi("Py",0,"IndexDesc1"," "_$zcvt(InfPyDesc,"U"),0))
			}
			If InfPyID'="" {
				Set ^DHCMed.NINFMapDic(aTypeCode,InfPyDesc)=InfPyID
				Set return=InfPyID
			} Else {
				Set ^DHCMed.NINFMapErr(aTypeCode,InfPyDesc)=""
			}
		} Else {
			Set return=$g(^DHCMed.NINFMapDic(aTypeCode,InfPyDesc))
		}
	} ElseIf aTypeCode="InfPyAnti" {
		Set InfAntiDesc=aDicDesc
		If aDicID'="" {
			Set objInfAnti=##class(DHCMed.INF.InfAntiDic).GetObjById(aDicID)
			If $IsObject(objInfAnti) {
				Set InfAntiDesc=objInfAnti.Description
			} Else {
				Set ^DHCMed.NINFMapErr(aTypeCode,aDicID)=""
				Quit return
			}
		}
		Quit:InfAntiDesc="" return
		
		If $g(^DHCMed.NINFMapDesc(aTypeCode,InfAntiDesc))'="" {
			Set InfAntiDesc=$g(^DHCMed.NINFMapDesc(aTypeCode,InfAntiDesc))
		}
		
		If $g(^DHCMed.NINFMapDic(aTypeCode,InfAntiDesc))="" {
			Quit:$d(^DHCMed.NINFMapErr(aTypeCode,InfAntiDesc)) return
			Set InfAntiID=$o(^DHCMed.NINFDi("Anti",0,"IndexDesc"," "_$zcvt(InfAntiDesc,"U"),0))
			If InfAntiID="" {
				Set InfAntiID=$o(^DHCMed.NINFDi("Anti",0,"IndexDesc1"," "_$zcvt(InfAntiDesc,"U"),0))
			}
			If InfAntiID'="" {
				Set ^DHCMed.NINFMapDic(aTypeCode,InfAntiDesc)=InfAntiID
				Set return=InfAntiID
			} Else {
				Set ^DHCMed.NINFMapErr(aTypeCode,InfAntiDesc)=""
			}
		} Else {
			Set return=$g(^DHCMed.NINFMapDic(aTypeCode,InfAntiDesc))
		}
	} Else {
		Set DicDesc=aDicDesc
		If aDicID'="" {
			Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(aDicID)
			If $Isobject(objDic) {
				Set DicDesc=objDic.Description
			} Else {
				Set ^DHCMed.NINFMapErr(aTypeCode,aDicID)=""
			}
		} ElseIf aDicCode'="" {
			Set DicType=$p(aDicCode,":",1)
			Set DicCode=$p(aDicCode,":",2)
			Set objDic=##class(DHCMed.SS.Dictionary).GetByTypeCode(DicType,DicCode,"")
			If $Isobject(objDic) {
				Set DicDesc=objDic.Description
			} Else {
				Set ^DHCMed.NINFMapErr(aTypeCode,DicCode)=""
			}
		}
		Quit:DicDesc="" return
		
		If $g(^DHCMed.NINFMapDesc(aTypeCode,DicDesc))'="" {
			Set DicDesc=$g(^DHCMed.NINFMapDesc(aTypeCode,DicDesc))
		}
		
		If $g(^DHCMed.NINFMapDic(aTypeCode,DicDesc))="" {
			Quit:$d(^DHCMed.NINFMapErr(aTypeCode,DicDesc)) return
			Set DicID=##Class(DHCMed.NINFService.Srv.CommonCls).GetDicIDByDesc(aTypeCode,DicDesc)
			If DicID'="" {
				Set ^DHCMed.NINFMapDic(aTypeCode,DicDesc)=DicID
				Set return=DicID
			} Else {
				Set ^DHCMed.NINFMapErr(aTypeCode,DicDesc)=""
			}
		} Else {
			Set return=$g(^DHCMed.NINFMapDic(aTypeCode,DicDesc))
		}
	}
	
	Quit return
}

/// w ##Class(DHCMed.NINFService.Srv.InfRepVer2).GetTransLoc()
ClassMethod GetTransLoc(aEpisodeID As %String, aTransType As %String, aDate As %String, aTime As %String) As %String
{
	New (aEpisodeID,aTransType,aDate,aTime)
	Set return=""
	Quit:(aEpisodeID="")||(aTransType="")||(aDate="")||(aTime="") return
	
	Set CurrTransID=""
	Set xTransID="",PrevTransLoc=""
	For {
		Set xTransID=$o(^PAADM(aEpisodeID,"TRANS",xTransID))
		Quit:xTransID=""
		
		Set tmpTrans=$g(^PAADM(aEpisodeID,"TRANS",xTransID))
		Continue:tmpTrans=""
		
		If aTransType="W" {
			Set TransLoc=$p($p(tmpTrans,"^",8),"||",1)
			Continue:TransLoc=""
			Set TransLoc=$p($g(^PAWARD(TransLoc)),"^",5)
		} Else {
			Set TransLoc=$p(tmpTrans,"^",6)
			Continue:TransLoc=""
		}
		Continue:TransLoc=""
		Continue:PrevTransLoc=TransLoc
		Set PrevTransLoc=TransLoc
		
		Set TransDate=+$p($g(^PAADM(aEpisodeID,"TRANS",xTransID)),"^",1)
		Set TransTime=+$p($g(^PAADM(aEpisodeID,"TRANS",xTransID)),"^",2)
		If (CurrTransID="")||(TransDate<aDate)||((TransDate=aDate)&&(TransTime<aTime)) {
			Set CurrTransID=aEpisodeID_"||"_xTransID
			Set CurrTransLoc=TransLoc
			Set CurrTransLocDesc=$p($g(^CTLOC(+CurrTransLoc)),"^",2)
			Set:$p(CurrTransLocDesc,"-",2)'="" CurrTransLocDesc=$p(CurrTransLocDesc,"-",2)
		} Else {
			Quit  //找到对应值，退出循环
		}
	}
	
	Set return=CurrTransID_$c(1)_CurrTransLoc_$c(1)_CurrTransLocDesc
	Quit return
}

}
