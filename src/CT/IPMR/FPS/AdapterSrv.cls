/// 名称: CT.IPMR.FPS.AdapterSrv
/// 描述: 适配服务
/// 创建者：zhouyang
/// 创建日期: 2022-04-21
Class CT.IPMR.FPS.AdapterSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(CT.IPMR.FPS.AdapterSrv).Test()
ClassMethod Test()
{
	Set xmlStream = ##class(%GlobalCharacterStream).%New()
	do xmlStream.Write("<DataMaster><DataItems><!--医疗付费方式--><P0100101>新型农村合作医疗</P0100101><!--医疗付费方式代码--><P0100102>3</P0100102><!--医疗机构组织机构--><P0100201/><!--医疗机构组织机构代码--><P0100202/><!--健康卡号--><P0100301>11010115890</P0100301><!--病案号--><P0100401>100106</P0100401><!--住院号--><P0100501/><!--住院次数--><P0100601>1</P0100601><!--姓名--><P0100701>林婉桐</P0100701><!--性别--><P0100801>女</P0100801><!--性别代码--><P0100802>2</P0100802><!--出生日期--><P0100901>1980-01-23</P0100901><!--年龄（岁）--><P0101001>38</P0101001><!--年龄（月）--><P0101101/><!--年龄（天）--><P0101201/><!--新生儿出生体重（g）--><P0101301>0</P0101301><!--新生儿入院体重（g）--><P0101401>0</P0101401><!--国籍--><P0101501>中国</P0101501><!--国籍代码--><P0101502>CHN</P0101502><!--出生地-省（自治区、直辖市）--><P0101601>北京市</P0101601><!--出生地-省（自治区、直辖市）代码--><P0101602>110000</P0101602><!--出生地-市（地区、州）--><P0101701>北京市市辖区</P0101701><!--出生地-市（地区、州）代码--><P0101702>110100</P0101702><!--出生地-县（区）--><P0101801>东城区</P0101801><!--出生地-县（区）代码--><P0101802>110101</P0101802><!--籍贯-省（自治区、直辖市）--><P0101901>北京市</P0101901><!--籍贯-省（自治区、直辖市）代码--><P0101902>110000</P0101902><!--籍贯-市（地区、州）--><P0102001>北京市市辖区</P0102001><!--籍贯-市（地区、州）代码--><P0102002>110100</P0102002><!--民族--><P0102101>汉族</P0102101><!--民族代码--><P0102102>1</P0102102><!--患者身份证件号码--><P0102201>110101198001231120</P0102201><!--职业--><P0102301>自由职业者</P0102301><!--职业代码--><P0102302>51</P0102302><!--婚姻--><P0102401>已婚</P0102401><!--婚姻代码--><P0102402>2</P0102402><!--现住址-省（自治区、直辖市）--><P0102501>北京市</P0102501><!--现住址-省（自治区、直辖市）代码--><P0102502>110000</P0102502><!--现住址-市（地区、州）--><P0102601>北京市市辖区</P0102601><!--现住址-市（地区、州）代码--><P0102602>110100</P0102602><!--现住址-县（区）--><P0102701>东城区</P0102701><!--现住址-县（区）代码--><P0102702>110101</P0102702><!--现住址-完整地址--><P0102801/><!--现住址-电话号码--><P0102901>13897652324</P0102901><!--现住址-邮政编码--><P0103001>100000</P0103001><!--户口地址-省（自治区、直辖市）--><P0103101>北京市</P0103101><!--户口地址-省（自治区、直辖市）代码--><P0103102>110000</P0103102><!--户口地址-市（地区、州）--><P0103201>北京市市辖区</P0103201><!--户口地址-市（地区、州）代码--><P0103202>110100</P0103202><!--户口地址-县（区）--><P0103301>东城区</P0103301><!--户口地址-县（区）代码--><P0103302>110101</P0103302><!--户口地址-完整地址--><P0103401/><!--户口地址-邮政编码--><P0103501>100000</P0103501><!--工作单位及地址--><P0103601>北京市东城区</P0103601><!--工作单位电话--><P0103701>13897652324</P0103701><!--工作单位-邮政编码--><P0103801>100000</P0103801><!--联系人姓名--><P0103901>林思远</P0103901><!--联系人与患者的关系--><P0104001>父母</P0104001><!--联系人与患者的关系代码--><P0104002>5</P0104002><!--联系人地址-完整地址--><P0104101>北京市西城区林荫大道555号</P0104101><!--联系人电话--><P0104201>13593252324</P0104201><!--入院途径--><P0104301>其他</P0104301><!--入院途径代码--><P0104302>9</P0104302><!--入院日期时间--><P0104401>2018-10-18 20:36:00</P0104401><!--入院科别--><P0104501>胸外科</P0104501><!--入院科别代码--><P0104502>ZYZY029</P0104502><!--入院病房--><P0104601>心胸2病室</P0104601><!--转科科别--><P0104701>无</P0104701><!--出院日期时间--><P0104801>2018-10-28 14:32:00</P0104801><!--出院科别--><P0104901>胸外科</P0104901><!--出院科别代码--><P0104902>ZYZY029</P0104902><!--出院病房--><P0105001>心胸2病室</P0105001><!--实际住院天数--><P0105101>10</P0105101><!--病理号--><P0105201>-</P0105201><!--药物过敏--><P0105301>无</P0105301><!--药物过敏代码--><P0105302>1</P0105302><!--过敏药物--><P0105401>-</P0105401><!--死亡患者尸检--><P0105501>否</P0105501><!--死亡患者尸检代码--><P0105502>2</P0105502><!--ABO血型--><P0105601>未查</P0105601><!--ABO血型代码--><P0105602>6</P0105602><!--Rh血型--><P0105701>未查</P0105701><!--Rh血型代码--><P0105702>4</P0105702><!--科主任--><P0105801>汪晶</P0105801><!--科主任代码--><P0105802>5688</P0105802><!--主任（副主任）医师--><P0105901>张丽[1619]</P0105901><!--主任（副主任）医师代码--><P0105902>1619</P0105902><!--主治医师--><P0106001>张海波</P0106001><!--主治医师代码--><P0106002>1638</P0106002><!--住院医师--><P0106101>张丽[1619]</P0106101><!--住院医师代码--><P0106102>1619</P0106102><!--责任护士--><P0106201>张进敏</P0106201><!--责任护士代码--><P0106202>1914</P0106202><!--进修医师--><P0106301>-</P0106301><!--进修医师代码--><P0106302/><!--实习医师--><P0106401>-</P0106401><!--实习医师代码--><P0106402/><!--编码员--><P0106501>病案系统管理员</P0106501><!--编码员代码--><P0106502>ipmr</P0106502><!--病案质量--><P0106601>甲</P0106601><!--病案质量代码--><P0106602>1</P0106602><!--质控医师--><P0106701>崔林林</P0106701><!--质控医师代码--><P0106702>2277</P0106702><!--质控护士--><P0106801>张静</P0106801><!--质控护士代码--><P0106802>7006</P0106802><!--质控日期--><P0106901>2018-10-28</P0106901><!--离院方式--><P0107001>医嘱离院</P0107001><!--离院方式代码--><P0107002>1</P0107002><!--医嘱转院，拟接收医疗机构名称--><P0107101>-</P0107101><!--医嘱转院，拟接收医疗机构名称代码--><P0107102/><!--医嘱转社区卫生服务机构/乡镇卫生院，拟接收医疗机构名称--><P0107201>-</P0107201><!--医嘱转社区卫生服务机构/乡镇卫生院，拟接收医疗机构名称代码--><P0107202/><!--是否有出院31天内再住院计划--><P0107401>无</P0107401><!--是否有出院31天内再住院计划代码--><P0107402>1</P0107402><!--出院31天内再住院目的--><P0107501>-</P0107501><!--颅脑损伤患者入院前昏迷时间-d--><P0107601>0</P0107601><!--颅脑损伤患者入院前昏迷时间-h--><P0107701>0</P0107701><!--颅脑损伤患者入院前昏迷时间-min--><P0107801>0</P0107801><!--颅脑损伤患者入院后昏迷时间-d--><P0107901>0</P0107901><!--颅脑损伤患者入院后昏迷时间-h--><P0108001>0</P0108001><!--颅脑损伤患者入院后昏迷时间-min--><P0108101>0</P0108101><!--治疗类别--><P0108201/><!--治疗类别代码--><P0108202/><!--实施临床路径标志--><P0108301/><!--实施临床路径标志代码--><P0108302/><!--使用医疗机构中药制剂--><P0108401/><!--使用医疗机构中药制剂代码--><P0108402/><!--使用中医诊疗设备--><P0108501/><!--使用中医诊疗设备代码--><P0108502/><!--使用中医诊疗技术--><P0108601/><!--使用中医诊疗技术代码--><P0108602/><!--辨证施护--><P0108701/><!--辨证施护代码--><P0108702/><!--登记号--><P0108801/><!--医保卡号--><P0108901/><!--入院时情况--><P0109001/><!--入院时情况代码--><P0109002/><!--转科时间1--><P0109101/><!--转科科别1--><P0109201/><!--转科科别代码1--><P0109202/><!--转科时间2--><P0109301/><!--转科科别2--><P0109401/><!--转科科别代码2--><P0109402/><!--转科时间3--><P0109501/><!--转科科别3--><P0109601/><!--转科科别代码3--><P0109602/><!--入院后确诊日期--><P0109701/><!--门（急）诊医生--><P0109801/><!--门（急）诊医生代码--><P0109802/><!--病例分型--><P0109901/><!--病例分型代码--><P0109902/><!--抢救次数--><P0110001/><!--成功次数--><P0110101/><!--诊断符合情况:门诊与出院--><P0110201/><!--诊断符合情况:门诊与出院代码--><P0110202/><!--诊断符合情况:临床与病理--><P0110301/><!--诊断符合情况:临床与病理代码--><P0110302/><!--新生儿出生体重2--><P0110401/><!--新生儿出生体重3--><P0110501/><!--III级护理天数--><P0110601/><!--II级护理天数--><P0110701/><!--I级护理天数--><P0110801/><!--特级护理天数--><P0110901/><!--特级护理小时数--><P0111001/><!--入院时生活能力评分--><P0111101/><!--出院时生活能力评分--><P0111201/><!--病理号2--><P0111301/><!--病理号3--><P0111401/><!--HBs-Ag--><P0111501/><!--HBs-Ag代码--><P0111502/><!--HCV-Ab--><P0111601/><!--HCV-Ab代码--><P0111602/><!--HIV-Ab--><P0111701/><!--HIV-Ab代码--><P0111702/><!--是否有输血反应--><P0111801/><!--是否有输血反应代码--><P0111802/><!--红细胞--><P0111901/><!--血小板--><P0112001/><!--血浆--><P0112101/><!--全血--><P0112201/><!--自体回收--><P0112301/><!--呼吸机使用时间（小时）--><P0112401/><!--呼吸机使用时间（总分钟数）--><P0112501/><!--病人来源--><P0112601/><!--病人来源代码--><P0112602/><!--重症监护病房类型1--><P0112701/><!--重症监护病房类型代码1--><P0112702/><!--进重症监护室时间1--><P0112801/><!--出重症监护室时间1--><P0112901/><!--重症监护持续时间合计（小时）1--><P0113001/><!--重症监护病房类型2--><P0113101/><!--重症监护病房类型代码2--><P0113102/><!--进重症监护室时间2--><P0113201/><!--出重症监护室时间2--><P0113301/><!--重症监护持续时间合计（小时）2--><P0113401/><!--重症监护病房类型3--><P0113501/><!--重症监护病房类型代码3--><P0113502/><!--进重症监护室时间3--><P0113601/><!--出重症监护室时间3--><P0113701/><!--重症监护持续时间合计（小时）3--><P0113801/><!--重症监护病房类型4--><P0113901/><!--重症监护病房类型代码4--><P0113902/><!--进重症监护室时间4--><P0114001/><!--出重症监护室时间4--><P0114101/><!--重症监护持续时间合计（小时）4--><P0114201/><!--重症监护病房类型5--><P0114301/><!--重症监护病房类型代码5--><P0114302/><!--进重症监护室时间5--><P0114401/><!--出重症监护室时间5--><P0114501/><!--重症监护持续时间合计（小时）5--><P0114601/><!--门（急）诊诊断地区疾病术语--><P0114701/><!--门（急）诊诊断地区疾病编码--><P0114801/><!--入院途径-转入医院名称--><P0114901/><!--病危或病重--><P0115001/><!--病危或病重代码--><P0115002/><!--是否疑难病例--><P0115101/><!--是否疑难病例代码--><P0115102/><!--肿瘤分期T--><P0115201/><!--肿瘤分期T代码--><P0115202/><!--白蛋白--><P0115301/><!--冷沉淀--><P0115401/><!--是否随诊--><P0115501/><!--是否随诊代码--><P0115502/><!--随诊周数--><P0115601/><!--随诊月数--><P0115701/><!--随诊年数--><P0115801/><!--主诊医师--><P0115901/><!--主诊医师代码--><P0115902/><!--是否实施临床路径管理--><P0116301/><!--是否实施临床路径管理代码--><P0116302/><!--是否完成临床路径--><P0116401/><!--是否完成临床路径代码--><P0116402/><!--退出原因（临床路径）--><P0116501/><!--是否变异（临床路径）--><P0116601/><!--是否变异（临床路径）代码--><P0116602/><!--变异原因（临床路径）--><P0116701/><!--变异原因（临床路径）代码--><P0116702/><!--CT检查--><P0116801/><!--CT检查代码--><P0116802/><!--Petct检查--><P0116901/><!--Petct检查代码--><P0116902/><!--双源ct检查--><P0117001/><!--双源ct检查代码--><P0117002/><!--X片检查--><P0117101/><!--X片检查代码--><P0117102/><!--B超检查--><P0117201/><!--B超检查代码--><P0117202/><!--超声心动图检查--><P0117301/><!--超声心动图检查代码--><P0117302/><!--MRI检查--><P0117401/><!--MRI检查代码--><P0117402/><!--同位素检查--><P0117501/><!--同位素检查代码--><P0117502/><!--是否同病种再次入院--><P0117601/><!--是否同病种再次入院代码--><P0117602/><!--与上次住院间隔天数--><P0117701/><!--输血其他--><P0117801/><!--规培医生--><P0117901/><!--规培医生代码--><P0117902/><!--出生地-详细地址--><P0118001/><!--证件类型--><P0118101/><!--证件类型代码--><P0118102/><!--新生儿出生体重4--><P0118201/><!--新生儿出生体重5--><P0118301/><!--工作单位--><P0118401/><!--入院病区--><P0118501/><!--入院病区代码--><P0118502/><!--出院病区--><P0118601/><!--出院病区代码--><P0118602/><!--是否院内感染--><P0118701/><!--是否院内感染代码--><P0118702/><!--医院感染名称--><P0118801/><!--医院感染总次数--><P0118901/><!--病原菌名称--><P0119001/><!--诊断符合情况:入院与出院--><P0119101/><!--诊断符合情况:入院与出院代码--><P0119102/><!--诊断符合情况:术前与术后--><P0119201/><!--诊断符合情况:术前与术后代码--><P0119202/><!--诊断符合情况:放射与病理--><P0119301/><!--诊断符合情况:放射与病理代码--><P0119302/><!--手术、治疗、检查、诊断是否为本院第一例--><P0119401/><!--手术、治疗、检查、诊断是否为本院第一例代码--><P0119402/><!--示教病例--><P0119501/><!--示教病例代码--><P0119502/><!--过敏史--><P0119601/><!--过敏史代码--><P0119602/><!--过敏源--><P0119701/><!--是否有输液反应--><P0119801/><!--是否有输液反应代码--><P0119802/><!--研究生实习医师--><P0119901/><!--研究生实习医师代码--><P0119902/><!--是否急症病例--><P0120001/><!--是否急症病例代码--><P0120002/><!--是否使用呼吸机--><P0120101/><!--是否使用呼吸机代码--><P0120102/><!--新生儿入院类型--><P0120201>-</P0120201><!--新生儿入院类型代码--><P0120202/><!--现住址-乡（镇、街道办事处）--><P0120301>下城街</P0120301><!--现住址-村（街、路、弄等）--><P0120401/><!--现住址-门牌号码--><P0120501/><!--户口地址-乡（镇、街道办事处）--><P0120601>顺城大街</P0120601><!--户口地址-村（街、路、弄等）--><P0120701/><!--户口地址-门牌号码--><P0120801/><!--传染病是否上报--><P0120901/><!--传染病是否上报代码--><P0120902/><!--Ⅰ类手术切口是否使用预防性应用抗菌药物--><P0121001/><!--Ⅰ类手术切口是否使用预防性应用抗菌药物代码--><P0121002/><!--Ⅰ类手术切口使用预防性应用抗菌药物持续时间--><P0121101/><!--Ⅰ类手术切口是否联合用药--><P0116001/><!--Ⅰ类手术切口是否联合用药代码--><P0116002/><!--是否应用抗菌药物--><P0121201/><!--是否应用抗菌药物代码--><P0121202/><!--使用抗菌药物持续时间--><P0116101/><!--是否联合应用抗菌药物--><P0116201/><!--是否联合应用抗菌药物代码--><P0116202/><!--应用抗菌药物累计DDD数--><P0121301/><!--是否会诊--><P0121401/><!--是否会诊代码--><P0121402/><!--院内会诊次数--><P0121501/><!--院外会诊次数--><P0121601/><!--会诊其他--><P0121701/><!--呼吸机使用时间（天）--><P0121801/><!--呼吸机使用时间（分钟）--><P0121901/><!--是否入住重症监护病房--><P0122001/><!--是否入住重症监护病房代码--><P0122002/><!--重症监护病房类型6--><P0122101/><!--重症监护病房类型代码6--><P0122102/><!--进重症监护室时间6--><P0122201/><!--出重症监护室时间6--><P0122301/><!--重症监护持续时间合计（小时）6--><P0122401/><!--是否再次入住ICU1--><P0122501/><!--是否再次入住ICU代码1--><P0122502/><!--是否再次入住ICU2--><P0122601/><!--是否再次入住ICU代码2--><P0122602/><!--是否再次入住ICU3--><P0122701/><!--是否再次入住ICU代码3--><P0122702/><!--是否再次入住ICU4--><P0122801/><!--是否再次入住ICU代码4--><P0122802/><!--是否再次入住ICU5--><P0122901/><!--是否再次入住ICU代码5--><P0122902/><!--再次入住ICU原因1--><P0123001/><!--再次入住ICU原因2--><P0123101/><!--再次入住ICU原因3--><P0123201/><!--再次入住ICU原因4--><P0123301/><!--再次入住ICU原因5--><P0123401/><!--患者入住重症监护室是否使用器械--><P0123501/><!--患者入住重症监护室是否使用器械代码--><P0123502/><!--重症监护器械使用情况-ICU类型1--><P0123601/><!--重症监护器械使用情况-ICU类型代码1--><P0123602/><!--重症监护器械使用情况-使用器械及导管类型1--><P0123701/><!--重症监护器械使用情况-使用器械及导管类型代码1--><P0123702/><!--重症监护器械使用情况-开始使用时间1--><P0123801/><!--重症监护器械使用情况-结束使用时间1--><P0123901/><!--重症监护器械使用情况-是否发生器械或导管相关感染1--><P0124001/><!--重症监护器械使用情况-是否发生器械或导管相关感染代码1--><P0124002/><!--重症监护器械使用情况-发生器械或导管相关感染累计时间(小时)1--><P0124101/><!--重症监护器械使用情况-ICU类型2--><P0124201/><!--重症监护器械使用情况-ICU类型代码2--><P0124202/><!--重症监护器械使用情况-使用器械及导管类型2--><P0124301/><!--重症监护器械使用情况-使用器械及导管类型代码2--><P0124302/><!--重症监护器械使用情况-开始使用时间2--><P0124401/><!--重症监护器械使用情况-结束使用时间2--><P0124501/><!--重症监护器械使用情况-是否发生器械或导管相关感染2--><P0124601/><!--重症监护器械使用情况-是否发生器械或导管相关感染代码2--><P0124602/><!--重症监护器械使用情况-发生器械或导管相关感染累计时间(小时)2--><P0124701/><!--重症监护器械使用情况-ICU类型3--><P0124801/><!--重症监护器械使用情况-ICU类型代码3--><P0124802/><!--重症监护器械使用情况-使用器械及导管类型3--><P0124901/><!--重症监护器械使用情况-使用器械及导管类型代码3--><P0124902/><!--重症监护器械使用情况-开始使用时间3--><P0125001/><!--重症监护器械使用情况-结束使用时间3--><P0125101/><!--重症监护器械使用情况-是否发生器械或导管相关感染3--><P0125201/><!--重症监护器械使用情况-是否发生器械或导管相关感染代码3--><P0125202/><!--重症监护器械使用情况-发生器械或导管相关感染累计时间(小时)3--><P0125301/><!--重症监护器械使用情况-ICU类型4--><P0125401/><!--重症监护器械使用情况-ICU类型代码4--><P0125402/><!--重症监护器械使用情况-使用器械及导管类型4--><P0125501/><!--重症监护器械使用情况-使用器械及导管类型代码4--><P0125502/><!--重症监护器械使用情况-开始使用时间4--><P0125601/><!--重症监护器械使用情况-结束使用时间4--><P0125701/><!--重症监护器械使用情况-是否发生器械或导管相关感染4--><P0125801/><!--重症监护器械使用情况-是否发生器械或导管相关感染代码4--><P0125802/><!--重症监护器械使用情况-发生器械或导管相关感染累计时间(小时)4--><P0125901/><!--重症监护器械使用情况-ICU类型5--><P0126001/><!--重症监护器械使用情况-ICU类型代码5--><P0126002/><!--重症监护器械使用情况-使用器械及导管类型5--><P0126101/><!--重症监护器械使用情况-使用器械及导管类型代码5--><P0126102/><!--重症监护器械使用情况-开始使用时间5--><P0126201/><!--重症监护器械使用情况-结束使用时间5--><P0126301/><!--重症监护器械使用情况-是否发生器械或导管相关感染5--><P0126401/><!--重症监护器械使用情况-是否发生器械或导管相关感染代码5--><P0126402/><!--重症监护器械使用情况-发生器械或导管相关感染累计时间(小时)5--><P0126501/><!--重症监护器械使用情况-ICU类型6--><P0126601/><!--重症监护器械使用情况-ICU类型代码6--><P0126602/><!--重症监护器械使用情况-使用器械及导管类型6--><P0126701/><!--重症监护器械使用情况-使用器械及导管类型代码6--><P0126702/><!--重症监护器械使用情况-开始使用时间6--><P0126801/><!--重症监护器械使用情况-结束使用时间6--><P0126901/><!--重症监护器械使用情况-是否发生器械或导管相关感染6--><P0127001/><!--重症监护器械使用情况-是否发生器械或导管相关感染代码6--><P0127002/><!--重症监护器械使用情况-发生器械或导管相关感染累计时间(小时)6--><P0127101/><!--重症监护器械使用情况-ICU类型7--><P0127201/><!--重症监护器械使用情况-ICU类型代码7--><P0127202/><!--重症监护器械使用情况-使用器械及导管类型7--><P0127301/><!--重症监护器械使用情况-使用器械及导管类型代码7--><P0127302/><!--重症监护器械使用情况-开始使用时间7--><P0127401/><!--重症监护器械使用情况-结束使用时间7--><P0127501/><!--重症监护器械使用情况-是否发生器械或导管相关感染7--><P0127601/><!--重症监护器械使用情况-是否发生器械或导管相关感染代码7--><P0127602/><!--重症监护器械使用情况-发生器械或导管相关感染累计时间(小时)7--><P0127701/><!--重症监护器械使用情况-ICU类型8--><P0127801/><!--重症监护器械使用情况-ICU类型代码8--><P0127802/><!--重症监护器械使用情况-使用器械及导管类型8--><P0127901/><!--重症监护器械使用情况-使用器械及导管类型代码8--><P0127902/><!--重症监护器械使用情况-开始使用时间8--><P0128001/><!--重症监护器械使用情况-结束使用时间8--><P0128101/><!--重症监护器械使用情况-是否发生器械或导管相关感染8--><P0128201/><!--重症监护器械使用情况-是否发生器械或导管相关感染代码8--><P0128202/><!--重症监护器械使用情况-发生器械或导管相关感染累计时间(小时)8--><P0128301/><!--重症监护器械使用情况-ICU类型9--><P0128401/><!--重症监护器械使用情况-ICU类型代码9--><P0128402/><!--重症监护器械使用情况-使用器械及导管类型9--><P0128501/><!--重症监护器械使用情况-使用器械及导管类型代码9--><P0128502/><!--重症监护器械使用情况-开始使用时间9--><P0128601/><!--重症监护器械使用情况-结束使用时间9--><P0128701/><!--重症监护器械使用情况-是否发生器械或导管相关感染9--><P0128801/><!--重症监护器械使用情况-是否发生器械或导管相关感染代码9--><P0128802/><!--重症监护器械使用情况-发生器械或导管相关感染累计时间(小时)9--><P0128901/><!--重症监护器械使用情况-ICU类型10--><P0129001/><!--重症监护器械使用情况-ICU类型代码10--><P0129002/><!--重症监护器械使用情况-使用器械及导管类型10--><P0129101/><!--重症监护器械使用情况-使用器械及导管类型代码10--><P0129102/><!--重症监护器械使用情况-开始使用时间10--><P0129201/><!--重症监护器械使用情况-结束使用时间10--><P0129301/><!--重症监护器械使用情况-是否发生器械或导管相关感染10--><P0129401/><!--重症监护器械使用情况-是否发生器械或导管相关感染代码10--><P0129402/><!--重症监护器械使用情况-发生器械或导管相关感染累计时间(小时)10--><P0129501/><!--重症监护器械使用情况-ICU类型11--><P0129601/><!--重症监护器械使用情况-ICU类型代码11--><P0129602/><!--重症监护器械使用情况-使用器械及导管类型11--><P0129701/><!--重症监护器械使用情况-使用器械及导管类型代码11--><P0129702/><!--重症监护器械使用情况-开始使用时间11--><P0129801/><!--重症监护器械使用情况-结束使用时间11--><P0129901/><!--重症监护器械使用情况-是否发生器械或导管相关感染11--><P0130001/><!--重症监护器械使用情况-是否发生器械或导管相关感染代码11--><P0130002/><!--重症监护器械使用情况-发生器械或导管相关感染累计时间(小时)11--><P0130101/><!--重症监护器械使用情况-ICU类型12--><P0130201/><!--重症监护器械使用情况-ICU类型代码12--><P0130202/><!--重症监护器械使用情况-使用器械及导管类型12--><P0130301/><!--重症监护器械使用情况-使用器械及导管类型代码12--><P0130302/><!--重症监护器械使用情况-开始使用时间12--><P0130401/><!--重症监护器械使用情况-结束使用时间12--><P0130501/><!--重症监护器械使用情况-是否发生器械或导管相关感染12--><P0130601/><!--重症监护器械使用情况-是否发生器械或导管相关感染代码12--><P0130602/><!--重症监护器械使用情况-发生器械或导管相关感染累计时间(小时)12--><P0130701/><!--重症监护器械使用情况-发生器械或导管相关感染累计时间(分钟)1--><P0130801/><!--重症监护器械使用情况-发生器械或导管相关感染累计时间(分钟)2--><P0130901/><!--重症监护器械使用情况-发生器械或导管相关感染累计时间(分钟)3--><P0131001/><!--重症监护器械使用情况-发生器械或导管相关感染累计时间(分钟)4--><P0131101/><!--重症监护器械使用情况-发生器械或导管相关感染累计时间(分钟)5--><P0131201/><!--重症监护器械使用情况-发生器械或导管相关感染累计时间(分钟)6--><P0131301/><!--重症监护器械使用情况-发生器械或导管相关感染累计时间(分钟)7--><P0131401/><!--重症监护器械使用情况-发生器械或导管相关感染累计时间(分钟)8--><P0131501/><!--重症监护器械使用情况-发生器械或导管相关感染累计时间(分钟)9--><P0131601/><!--重症监护器械使用情况-发生器械或导管相关感染累计时间(分钟)10--><P0131701/><!--重症监护器械使用情况-发生器械或导管相关感染累计时间(分钟)11--><P0131801/><!--重症监护器械使用情况-发生器械或导管相关感染累计时间(分钟)12--><P0131901/><!--是否做病原学检查--><P0132001/><!--是否做病原学检查代码--><P0132002/><!--病原学诊断--><P0132101/><!--是否两周内再住院--><P0132201/><!--是否两周内再住院代码--><P0132202/><!--工作单位地址-省（自治区、直辖市）--><P0132301/><!--工作单位地址-省（自治区、直辖市）代码--><P0132302/><!--工作单位地址-市（地区、州）--><P0132401/><!--工作单位地址-市（地区、州）代码--><P0132402/><!--工作单位地址-县（区）--><P0132501/><!--工作单位地址-县（区）代码--><P0132502/><!--工作单位地址-乡（镇、街道办事处）--><P0132601/><!--工作单位地址-村（街、路、弄等）--><P0132701/><!--工作单位地址-门牌号码--><P0132801/><!--联系人地址-省（自治区、直辖市）--><P0132901/><!--联系人地址-省（自治区、直辖市）代码--><P0132902/><!--联系人地址-市（地区、州）--><P0133001/><!--联系人地址-市（地区、州）代码--><P0133002/><!--联系人地址-县（区）--><P0133101/><!--联系人地址-县（区）代码--><P0133102/><!--联系人地址-乡（镇、街道办事处）--><P0133201/><!--联系人地址-村（街、路、弄等）--><P0133301/><!--联系人地址-门牌号码--><P0133401/><!--住院费用（总费用）--><F0100101>73.20</F0100101><!--住院费用（自付金额）--><F0100201>73.20</F0100201><!--综合医疗服务类（一般医疗服务费）--><F0100301>0.00</F0100301><!--综合医疗服务类（一般治疗操作费）--><F0100401>0.00</F0100401><!--综合医疗服务类（护理费）--><F0100501>20.72</F0100501><!--综合医疗服务类（其他费用）--><F0100601>9.00</F0100601><!--诊断类（病理诊断费）--><F0100701>0.00</F0100701><!--诊断类（实验室诊断费）--><F0100801>0.00</F0100801><!--诊断类（影像学诊断费）--><F0100901>0.00</F0100901><!--诊断类（临床诊断项目费）--><F0101001>0.00</F0101001><!--治疗类（非手术治疗项目费）--><F0101101>43.48</F0101101><!--治疗类（非手术治疗项目费-临床物理治疗费）--><F0101201>13.48</F0101201><!--治疗类（手术治疗费）--><F0101301>0.00</F0101301><!--治疗类（手术治疗费-麻醉费）--><F0101401>0.00</F0101401><!--治疗类（手术治疗费-手术费）--><F0101501>0.00</F0101501><!--康复类（康复费）--><F0101601>0.00</F0101601><!--中医类（中医治疗）--><F0101701>0.00</F0101701><!--西药类（西药费）--><F0101801>0.00</F0101801><!--西药类（西药费-抗菌药物费用）--><F0101901>0.00</F0101901><!--中药类（中成药费）--><F0102001>0.00</F0102001><!--中药类（中草药费）--><F0102101>0.00</F0102101><!--血液和血液制品类（血费）--><F0102201>0.00</F0102201><!--血液和血液制品类（白蛋白类制品费）--><F0102301>0.00</F0102301><!--血液和血液制品类（球蛋白类制品费）--><F0102401>0.00</F0102401><!--血液和血液制品类（凝血因子类制品费）--><F0102501>0.00</F0102501><!--血液和血液制品类（细胞因子类制品费）--><F0102601>0.00</F0102601><!--耗材类（检查用一次性医用材料费）--><F0102701>0.00</F0102701><!--耗材类（治疗用一次性医用材料费）--><F0102801>0.00</F0102801><!--耗材类（手术用一次性医用材料费）--><F0102901>0.00</F0102901><!--其他类（其他费）--><F0103001>0.00</F0103001><!--综合医疗服务类（一般医疗服务费-中医辨证论治费）--><F0103101/><!--综合医疗服务类（一般医疗服务费-中医辨证论治会诊费）--><F0103201/><!--诊察费--><F0103301/><!--普通床位费--><F0103401/><!--重症监护床位--><F0103501/><!--中医类（中医诊断）--><F0103601/><!--中医类（中医治疗-中医外治）--><F0103701/><!--中医类（中医治疗-中医骨伤）--><F0103801/><!--中医类（中医治疗-针刺与灸法）--><F0103901/><!--中医类（中医治疗-中医推拿治疗）--><F0104001/><!--中医类（中医治疗-中医肛肠治疗）--><F0104101/><!--中医类（中医治疗-中医特殊治疗）--><F0104201/><!--中医类（中医其他）--><F0104301/><!--中医类（中医其他费-中医特殊调配加工）--><F0104401/><!--中医类（中医其他费-辨证施膳费）--><F0104501/><!--中药类（中成药费-医疗机构中药制剂费）--><F0104601/><!--婴儿序号1--><B0100101/><!--婴儿性别1--><B0100201/><!--婴儿性别代码1--><B0100202/><!--分娩结果1--><B0100301/><!--分娩结果代码1--><B0100302/><!--婴儿体重1--><B0100401/><!--婴儿转归1--><B0100501/><!--婴儿转归代码1--><B0100502/><!--婴儿呼吸1--><B0100601/><!--婴儿呼吸代码1--><B0100602/><!--婴儿抢救次数1--><B0100701/><!--婴儿抢救成功次数1--><B0100801/><!--婴儿序号2--><B0100901/><!--婴儿性别2--><B0101001/><!--婴儿性别代码2--><B0101002/><!--分娩结果2--><B0101101/><!--分娩结果代码2--><B0101102/><!--婴儿体重2--><B0101201/><!--婴儿转归2--><B0101301/><!--婴儿转归代码2--><B0101302/><!--婴儿呼吸2--><B0101401/><!--婴儿呼吸代码2--><B0101402/><!--婴儿抢救次数2--><B0101501/><!--婴儿抢救成功次数2--><B0101601/><!--婴儿序号3--><B0101701/><!--婴儿性别3--><B0101801/><!--婴儿性别代码3--><B0101802/><!--分娩结果3--><B0101901/><!--分娩结果代码3--><B0101902/><!--婴儿体重3--><B0102001/><!--婴儿转归3--><B0102101/><!--婴儿转归代码3--><B0102102/><!--婴儿呼吸3--><B0102201/><!--婴儿呼吸代码3--><B0102202/><!--婴儿抢救次数3--><B0102301/><!--婴儿抢救成功次数3--><B0102401/><!--婴儿序号4--><B0102501/><!--婴儿性别4--><B0102601/><!--婴儿性别代码4--><B0102602/><!--分娩结果4--><B0102701/><!--分娩结果代码4--><B0102702/><!--婴儿体重4--><B0102801/><!--婴儿转归4--><B0102901/><!--婴儿转归代码4--><B0102902/><!--婴儿呼吸4--><B0103001/><!--婴儿呼吸代码4--><B0103002/><!--婴儿抢救次数4--><B0103101/><!--婴儿抢救成功次数4--><B0103201/><!--肿瘤分期类型--><T0100101/><!--肿瘤分期类型代码--><T0100102/><!--肿瘤专科-肿瘤分期T--><T0100201/><!--肿瘤专科-肿瘤分期T代码--><T0100202/><!--肿瘤专科-肿瘤分期N--><T0100301/><!--肿瘤专科-肿瘤分期N代码--><T0100302/><!--肿瘤专科-肿瘤分期M--><T0100401/><!--肿瘤专科-肿瘤分期M代码--><T0100402/><!--肿瘤分期--><T0100501/><!--放疗方式--><T0100601/><!--放疗方式代码--><T0100602/><!--放疗程式--><T0100701/><!--放疗程式代码--><T0100702/><!--放疗装置--><T0100801/><!--放疗装置代码--><T0100802/><!--原发灶剂量CY--><T0100901/><!--原发灶剂量次--><T0101001/><!--原发灶剂量天--><T0101101/><!--原发灶剂量开始时间--><T0101201/><!--原发灶剂量停止时间--><T0101301/><!--区域淋巴结剂量CY--><T0101401/><!--区域淋巴结剂量次--><T0101501/><!--区域淋巴结剂量天--><T0101601/><!--区域淋巴结剂量开始时间--><T0101701/><!--区域淋巴结剂量停止时间--><T0101801/><!--转移灶剂量自定义--><T0101901/><!--转移灶剂量CY--><T0102001/><!--转移灶剂量次--><T0102101/><!--转移灶剂量天--><T0102201/><!--转移灶剂量开始时间--><T0102301/><!--转移灶剂量停止时间--><T0102401/><!--化疗方式--><T0102501/><!--化疗方式代码--><T0102502/><!--化疗方法--><T0102601/><!--化疗方法代码--><T0102602/><!--化疗开始日期1--><T0102701/><!--化疗结束日期1--><T0102801/><!--化疗药物名称（剂量）1--><T0102901/><!--化疗疗程1--><T0103001/><!--化疗疗效1--><T0103101/><!--化疗疗效代码1--><T0103102/><!--化疗开始日期2--><T0103201/><!--化疗结束日期2--><T0103301/><!--化疗药物名称（剂量）2--><T0103401/><!--化疗疗程2--><T0103501/><!--化疗疗效2--><T0103601/><!--化疗疗效代码2--><T0103602/><!--化疗开始日期3--><T0103701/><!--化疗结束日期3--><T0103801/><!--化疗药物名称（剂量）3--><T0103901/><!--化疗疗程3--><T0104001/><!--化疗疗效3--><T0104101/><!--化疗疗效代码3--><T0104102/><!--CCHI名称1--><C0100101/><!--CCHI名称2--><C0100102/><!--CCHI名称3--><C0100103/><!--CCHI名称4--><C0100104/><!--CCHI名称5--><C0100105/><!--CCHI名称6--><C0100106/><!--CCHI名称7--><C0100107/><!--CCHI名称8--><C0100108/><!--CCHI名称9--><C0100109/><!--CCHI名称10--><C0100110/><!--CCHI名称11--><C0100111/><!--CCHI名称12--><C0100112/><!--CCHI名称13--><C0100113/><!--CCHI名称14--><C0100114/><!--CCHI名称15--><C0100115/><!--CCHI名称16--><C0100116/><!--CCHI编码1--><C0100201/><!--CCHI编码2--><C0100202/><!--CCHI编码3--><C0100203/><!--CCHI编码4--><C0100204/><!--CCHI编码5--><C0100205/><!--CCHI编码6--><C0100206/><!--CCHI编码7--><C0100207/><!--CCHI编码8--><C0100208/><!--CCHI编码9--><C0100209/><!--CCHI编码10--><C0100210/><!--CCHI编码11--><C0100211/><!--CCHI编码12--><C0100212/><!--CCHI编码13--><C0100213/><!--CCHI编码14--><C0100214/><!--CCHI编码15--><C0100215/><!--CCHI编码16--><C0100216/><!--CCHI修饰符1--><C0100301/><!--CCHI修饰符2--><C0100302/><!--CCHI修饰符3--><C0100303/><!--CCHI修饰符4--><C0100304/><!--CCHI修饰符5--><C0100305/><!--CCHI修饰符6--><C0100306/><!--CCHI修饰符7--><C0100307/><!--CCHI修饰符8--><C0100308/><!--CCHI修饰符9--><C0100309/><!--CCHI修饰符10--><C0100310/><!--CCHI修饰符11--><C0100311/><!--CCHI修饰符12--><C0100312/><!--CCHI修饰符13--><C0100313/><!--CCHI修饰符14--><C0100314/><!--CCHI修饰符15--><C0100315/><!--CCHI修饰符16--><C0100316/><!--CCHI是否主要治疗方式1--><C0100401/><!--CCHI是否主要治疗方式2--><C0100402/><!--CCHI是否主要治疗方式3--><C0100403/><!--CCHI是否主要治疗方式4--><C0100404/><!--CCHI是否主要治疗方式5--><C0100405/><!--CCHI是否主要治疗方式6--><C0100406/><!--CCHI是否主要治疗方式7--><C0100407/><!--CCHI是否主要治疗方式8--><C0100408/><!--CCHI是否主要治疗方式9--><C0100409/><!--CCHI是否主要治疗方式10--><C0100410/><!--CCHI是否主要治疗方式11--><C0100411/><!--CCHI是否主要治疗方式12--><C0100412/><!--CCHI是否主要治疗方式13--><C0100413/><!--CCHI是否主要治疗方式14--><C0100414/><!--CCHI是否主要治疗方式15--><C0100415/><!--CCHI是否主要治疗方式16--><C0100416/></DataItems><Diagnoses><Diagnose><DiagTypeCode>1</DiagTypeCode><DiagTypeDesc>门急诊诊断</DiagTypeDesc><ICD10>A01.300</ICD10><ICD10Desc>副伤寒丙</ICD10Desc><ICDinPair/><ClinicICD10>A01.300</ClinicICD10><ClinicICD10Desc>(待定)副伤寒丙</ClinicICD10Desc></Diagnose><Diagnose><DiagTypeCode>3</DiagTypeCode><DiagTypeDesc>主要诊断</DiagTypeDesc><ICD10>J06.900</ICD10><ICD10Desc>急性上呼吸道感染</ICD10Desc><ICDinPair/><AdmitCondCode>1</AdmitCondCode><AdmitCondDesc>有</AdmitCondDesc><DischCondCode>2</DischCondCode><DischCondDesc>好转</DischCondDesc><IsDefiniteCode>1</IsDefiniteCode><IsDefiniteDesc>是</IsDefiniteDesc><TumICD10/><TumICDDesc/><TumDifferCode/><TumDifferDesc/><TumStagesCode/><TumStagesDesc/><ClinicICD10>J06.900</ClinicICD10><ClinicICD10Desc>急性上呼吸道感染</ClinicICD10Desc><InjuryICD10/><InjuryICDDesc/></Diagnose><Diagnose><DiagTypeCode>4</DiagTypeCode><DiagTypeDesc>其他诊断</DiagTypeDesc><ICD10>D21.303</ICD10><ICD10Desc>肩胛区结缔组织良性肿瘤</ICD10Desc><ICDinPair/><AdmitCondCode>3</AdmitCondCode><AdmitCondDesc>情况不明</AdmitCondDesc><DischCondCode>2</DischCondCode><DischCondDesc>好转</DischCondDesc><IsDefiniteCode>1</IsDefiniteCode><IsDefiniteDesc>是</IsDefiniteDesc><TumICD10>M80000/1</TumICD10><TumICDDesc>动态未定肿瘤</TumICDDesc><TumDifferCode>2</TumDifferCode><TumDifferDesc>中分化</TumDifferDesc><TumStagesCode>3</TumStagesCode><TumStagesDesc>III期</TumStagesDesc><ClinicICD10>A18.000x034†M90.0*</ClinicICD10><ClinicICD10Desc>肢体骨结核</ClinicICD10Desc><InjuryICD10/><InjuryICDDesc/></Diagnose><Diagnose><DiagTypeCode>4</DiagTypeCode><DiagTypeDesc>其他诊断</DiagTypeDesc><ICD10>A18.000x034</ICD10><ICD10Desc>肢体骨结核</ICD10Desc><ICDinPair>†M90.0*</ICDinPair><AdmitCondCode>3</AdmitCondCode><AdmitCondDesc>情况不明</AdmitCondDesc><DischCondCode>2</DischCondCode><DischCondDesc>好转</DischCondDesc><IsDefiniteCode>1</IsDefiniteCode><IsDefiniteDesc>是</IsDefiniteDesc><TumICD10/><TumICDDesc/><TumDifferCode/><TumDifferDesc/><TumStagesCode/><TumStagesDesc/><ClinicICD10>D21.303</ClinicICD10><ClinicICD10Desc>肢体骨结核</ClinicICD10Desc><InjuryICD10/><InjuryICDDesc/></Diagnose><Diagnose><DiagTypeCode>4</DiagTypeCode><DiagTypeDesc>其他诊断</DiagTypeDesc><ICD10>S12.010</ICD10><ICD10Desc>开放性第一颈椎骨折</ICD10Desc><ICDinPair/><AdmitCondCode>1</AdmitCondCode><AdmitCondDesc>有</AdmitCondDesc><DischCondCode>2</DischCondCode><DischCondDesc>好转</DischCondDesc><IsDefiniteCode>1</IsDefiniteCode><IsDefiniteDesc>是</IsDefiniteDesc><TumICD10/><TumICDDesc/><TumDifferCode/><TumDifferDesc/><TumStagesCode/><TumStagesDesc/><ClinicICD10>S12.010</ClinicICD10><ClinicICD10Desc>开放性颈椎骨折</ClinicICD10Desc><InjuryICD10>V28.x00</InjuryICD10><InjuryICDDesc>骑摩托车人员在非碰撞性运输事故中的损伤</InjuryICDDesc></Diagnose><Diagnose><DiagTypeCode>5</DiagTypeCode><DiagTypeDesc>损伤中毒诊断</DiagTypeDesc><ICD10>V29.000</ICD10><ICD10Desc>非交通事故中摩托车与其他机动车辆碰撞造成骑摩托车人员的损伤</ICD10Desc><ICDinPair/><ClinicICD10>V29.000</ClinicICD10><ClinicICD10Desc>非交通事故中摩托车与其他机动车辆碰撞造成骑摩托车人员的损伤</ClinicICD10Desc></Diagnose><Diagnose><DiagTypeCode>7</DiagTypeCode><DiagTypeDesc>病理诊断</DiagTypeDesc><ICD10>M80010/0</ICD10><ICD10Desc>良性瘤细胞</ICD10Desc><ICDinPair/><ClinicICD10>M80010/0</ClinicICD10><ClinicICD10Desc>良性瘤细胞</ClinicICD10Desc></Diagnose></Diagnoses><Operations><Operation><ICD9>00.1201</ICD9><ICD9Desc>一氧化氮疗法</ICD9Desc><OperTypeCode>3</OperTypeCode><OperTypeDesc>治疗性操作</OperTypeDesc><SttDate>2020-05-09</SttDate><SttTime>12:23:00</SttTime><EndDate>2020-05-09</EndDate><EndTime>18:31:54</EndTime><CutTypeCode>1</CutTypeCode><CutTypeDesc>Ⅰ</CutTypeDesc><HealingCode>3</HealingCode><HealingDesc>丙</HealingDesc><OperatorCode>1441</OperatorCode><OperatorName>刘天顺</OperatorName><Assistant1Code>1581</Assistant1Code><Assistant1Name>张建宏</Assistant1Name><Assistant2Code>1808</Assistant2Code><Assistant2Name>孔祥红</Assistant2Name><NarcosisTypeCode>101</NarcosisTypeCode><NarcosisTypeDesc>静脉麻醉 （全凭静脉麻醉）</NarcosisTypeDesc><NarcosisDocCode>1535</NarcosisDocCode><NarcosisDocName>讲世菊</NarcosisDocName><OperLevelCode>3</OperLevelCode><OperLevelDesc>三级手术</OperLevelDesc><MainOperCode>1</MainOperCode><MainOperDesc>是</MainOperDesc><AppendOper>0</AppendOper><NarcosisLevelCode>3</NarcosisLevelCode><NarcosisLevelDesc>P3</NarcosisLevelDesc><OperSiteCode>02</OperSiteCode><OperSiteDesc>臀部</OperSiteDesc><OperLocCode>ZYZY029</OperLocCode><OperLocDesc>胸外科</OperLocDesc><BackOperCode>1</BackOperCode><BackOperDesc>是</BackOperDesc><NNISLevelCode>2</NNISLevelCode><NNISLevelDesc>NNIS1</NNISLevelDesc><OperCatCode>2</OperCatCode><OperCatDesc>择期</OperCatDesc><DurationTime>6h</DurationTime><ClinicICD9>00.1201</ClinicICD9><ClinicICD9Desc>一氧化氮治疗</ClinicICD9Desc><IsEmergencyCode>1</IsEmergencyCode><IsEmergencyDesc>是</IsEmergencyDesc><IsMiniInvaCode>1</IsMiniInvaCode><IsMiniInvaDesc>是</IsMiniInvaDesc><IsChooseDateCode>0</IsChooseDateCode><IsChooseDateDesc>否</IsChooseDateDesc><NarcosisSttDate>2020-05-09</NarcosisSttDate><NarcosisSttTime>12:23:00</NarcosisSttTime><NarcosisEndDate>2020-05-09</NarcosisEndDate><NarcosisEndTime>19:58:00</NarcosisEndTime></Operation><Operation><ICD9>00.1400</ICD9><ICD9Desc>噁唑烷酮类抗生素注射或输注</ICD9Desc><OperTypeCode>3</OperTypeCode><OperTypeDesc>治疗性操作</OperTypeDesc><SttDate>2020-05-09</SttDate><SttTime>12:23:00</SttTime><EndDate>2020-05-09</EndDate><EndTime>18:31:00</EndTime><CutTypeCode>1</CutTypeCode><CutTypeDesc>Ⅰ</CutTypeDesc><HealingCode>2</HealingCode><HealingDesc>乙</HealingDesc><OperatorCode>1441</OperatorCode><OperatorName>刘天顺</OperatorName><Assistant1Code>1581</Assistant1Code><Assistant1Name>张建宏</Assistant1Name><Assistant2Code>1808</Assistant2Code><Assistant2Name>孔祥红</Assistant2Name><NarcosisTypeCode>101</NarcosisTypeCode><NarcosisTypeDesc>静脉麻醉 （全凭静脉麻醉）</NarcosisTypeDesc><NarcosisDocCode>1535</NarcosisDocCode><NarcosisDocName>讲世菊</NarcosisDocName><OperLevelCode>3</OperLevelCode><OperLevelDesc>三级手术</OperLevelDesc><MainOperCode>0</MainOperCode><MainOperDesc>否</MainOperDesc><AppendOper>0</AppendOper><NarcosisLevelCode>3</NarcosisLevelCode><NarcosisLevelDesc>P3</NarcosisLevelDesc><OperSiteCode>02</OperSiteCode><OperSiteDesc>臀部</OperSiteDesc><OperLocCode>ZYZY029</OperLocCode><OperLocDesc>胸外科</OperLocDesc><BackOperCode>1</BackOperCode><BackOperDesc>是</BackOperDesc><NNISLevelCode>2</NNISLevelCode><NNISLevelDesc>NNIS1</NNISLevelDesc><OperCatCode>2</OperCatCode><OperCatDesc>择期</OperCatDesc><DurationTime>6h</DurationTime><ClinicICD9>00.1400</ClinicICD9><ClinicICD9Desc>噁唑烷酮类抗生素注射</ClinicICD9Desc><IsEmergencyCode>1</IsEmergencyCode><IsEmergencyDesc>是</IsEmergencyDesc><IsMiniInvaCode>1</IsMiniInvaCode><IsMiniInvaDesc>是</IsMiniInvaDesc><IsChooseDateCode>0</IsChooseDateCode><IsChooseDateDesc>否</IsChooseDateDesc><NarcosisSttDate>2020-05-09</NarcosisSttDate><NarcosisSttTime>12:23:00</NarcosisSttTime><NarcosisEndDate>2020-05-09</NarcosisEndDate><NarcosisEndTime>19:58:00</NarcosisEndTime></Operation></Operations></DataMaster>")
	Set aSource="XXBA"
	Set return = ..SaveFromStream(aSource,xmlStream)
	Quit return
}

/// Creator：     zhouyang
/// CreatDate：   2022-04-21
/// Description:  根据XML流存储编目回传数据
/// InPut:	   aSource：适配器配置代码
/// 			   xmlStream：XML流
/// Return：      失败：代码(<=0)^失败原因，正常：代码(>0)
/// w ##class(CT.IPMR.FPS.AdapterSrv).SaveFromStream()
ClassMethod SaveFromStream(aSource As %String, xmlStream As %GlobalCharacterStream, ByRef ErrMsg As %String) As %String
{
	Set return=0
	Set ErrMsg = ""
	Set ^ZT="SaveFromStreamErr"
	Quit:aSource="" return
	
	Set SourceID = $o(^CT.IPMR.FP.AT.SourceI("IndexCode"," "_$zcvt(aSource,"U"),0))
	Set objSource = ##class(CT.IPMR.FP.AT.Source).GetObjById(SourceID)
	Quit:'$IsObject(objSource) return
	Quit:'$IsObject(objSource.FAConfigDr) return
	
	// 诊断库、手术库
	Set objConfig = objSource.FAConfigDr
	Quit:'$IsObject(objConfig) return
	Quit:'$IsObject(objConfig.FCICDVer) return
	Quit:'$IsObject(objConfig.FCOprVer) return
	Quit:'$IsObject(objConfig.FCICDVer2) return
	Set ICDVerID 	= objConfig.FCICDVer.%Id()
	Set OprVerID 	= objConfig.FCOprVer.%Id()
	Set ICDVerID2 	= objConfig.FCICDVer2.%Id()
	Set ICDVerCode	= objConfig.FCICDVer.FICode
	Set OprVerCode	= objConfig.FCOprVer.FICode
	Set ICDVerCode2= objConfig.FCICDVer2.FICode
	
	// 读取XML流数据
	Set return="-1^数据读取失败"
	Set flg=##class(%XML.XPATH.Document).CreateFromStream(xmlStream,.documentList)
	Quit:flg'=1 return
	
	Set MrNo 		= ..GetValByCode("P01.004.01",SourceID,.documentList)		// 病案号
	Set AdmTimes 	= ..GetValByCode("P01.006.01",SourceID,.documentList) 		// 住院次数
	Set AdmDate 	= ..GetValByCode("P01.044.01",SourceID,.documentList)		// 住院日期
	Set CodeUser 	= ..GetValByCode("P01.065.01",SourceID,.documentList) 		// 编码员
	
	// 取就诊号
	Set return="-2^就诊信息获取失败"
	Set EpisodeID=..GetValByCode("EpisodeID",SourceID,.documentList)
	Set:EpisodeID="" EpisodeID = ##class(CT.IPMR.FPS.AdapterSrv).GetEpisodeIDByMrNo(MrNo,"I",AdmDate,AdmTimes)
	Quit:EpisodeID="" return
	
	// 取患者病案信息
	Set objVolPaadm = ##Class(MA.IPMR.SS.VolPaadm).GetPatObjByAdm(EpisodeID)
	Quit:'$IsObject(objVolPaadm) return
	Quit:'$IsObject(objVolPaadm.Parref) return
	Quit:'$IsObject(objVolPaadm.Parref.SVMainDr) return
	Quit:'$IsObject(objVolPaadm.Parref.SVMainDr.SMNoType) return
	Set xVolID 	= objVolPaadm.Parref.%Id()
	Set MrTypeID	= +(objVolPaadm.Parref.SVMainDr.SMNoType.%Id())
	
	// 工作流项目
	set objWorkFItem = ##class(CT.IPMR.BT.WorkFItem).GetWFItemBySysOpera(MrTypeID,"FP")
	Quit:'$IsObject(objWorkFItem) return
	Set WFItemID 	= objWorkFItem.%Id()
	
	// 同步病历首页信息
	d ##class(MA.IPMR.FPS.EmrRecordSrv).getEmrDataByVol(xVolID)
	
	// 取主表信息
	Set return="-3^首页信息获取失败"
	Set MasterID 	= $o(^MA.IPMR.FP.DataMasterI("IndexVolumeConfig",xVolID,objConfig.%Id(),"")) 
	Set objMaster	= ##class(MA.IPMR.FP.DataMaster).GetObjById(MasterID)
	if $Isobject(objMaster) {
		Set objFPType 	= objMaster.FDFPTypeDr
		Quit:'$IsObject(objFPType) return	
	}else{
		// 没有东华电子病历生成，根据治疗类别判断首页类型
		Set TreatType 	= ..GetValByCode("P01.082.01",SourceID,.documentList) 		// 治疗类别
		if (TreatType="西医")||(TreatType="") {
			Set objFPType 	= ##class(CT.IPMR.BT.Dictionary).GetByTypeCode("FrontPageType","HDSD00.11")
			Quit:'$IsObject(objFPType) return
		}elseif TreatType["中" || TreatType="民族医" {
			Set objFPType 	= ##class(CT.IPMR.BT.Dictionary).GetByTypeCode("FrontPageType","HDSD00.12")
			Quit:'$IsObject(objFPType) return
		}else{
			Quit return
		}
		Set MasterID = ##class(CT.IPMR.FPS.AdapterSrv).GetNewMasterID(xVolID,objConfig.%Id(),objFPType.%Id())
	}	
	
	Set (MasterInfo,DiagInfo,OperInfo,PatInfo,AttDiagInfo) = ""
	Set MasterInfo = MasterID_$c(1)_xVolID_$c(1)_objFPType.%Id()_$c(1)_"C"_$c(1)_CodeUser_$c(1)_""_$c(1)_WFItemID_$c(1)_objConfig.%Id()
	Set DiagInfo	= ..GetDiagInfo()
	Set OperInfo	= ..GetOperInfo()
	Set PatInfo 	= ..GetPatInfo()
	
	Set MasterID = ##class(MA.IPMR.FPS.DataMasterSrv).SaveResult(MasterInfo,DiagInfo,OperInfo,PatInfo,AttDiagInfo)
	Set return = MasterID
	Quit return
SaveFromStreamErr
	Set ErrMsg = "-999^"_$ZE
	Quit ErrMsg
}

/// 取诊断信息
ClassMethod GetDiagInfo()
{
	Set return = ""
	Set DiagStr = ""
	
	Set ICD10Node = ..GetNodeByCode("ICD10",SourceID)
	Set DiagListNode = $p(ICD10Node,"/",1,$l(ICD10Node,"/")-2)
	Set DiagNode = $p(ICD10Node,"/",1,$l(ICD10Node,"/")-1)
	Quit:(DiagListNode="")||(DiagNode="") return
	
	Set sc = documentList.EvaluateExpression(DiagListNode,"count("_$p(DiagNode,"/",$l(DiagNode,"/"))_")",.documentNode)
	Quit:($$$ERROR(sc)||(documentNode.GetAt(1)="")) return
	Set DiagCount = documentNode.GetAt(1).Value
	
	for indDiag=1:1:DiagCount
	{
		Set DiagTmpStr = ""
		Set (ICDID,ICD10,ICDDesc,DischCondID,DischCondCode,DischCondDesc,AdmitCondID,AdmitCondCode,AdmitCondDesc)=""
		Set (IsDefiniteID,IsDefiniteCode,IsDefiniteDesc,TypeID,TypeCode,TypeDesc,ICDinPair,Index,TempData)=""
		Set (TumICDID,TumICD10,TumICDDesc,TumDifferID,TumDifferCode,TumDifferDesc,TumStagesID,TumStagesCode,TumStagesDesc,ClinicICD10,ClinicICDDesc)=""
		Set (InjuryICDID,InjuryICD10,InjuryICDDesc)=""
		
		// 诊断类型字典
		Set TypeCodeNode = ..GetNodeByCode("DiagTypeCode",SourceID)
		Set TypeDescNode = ..GetNodeByCode("DiagTypeDesc",SourceID)
		Set:TypeCodeNode'="" TypeCode=..GetValueByNode(DiagNode_"["_indDiag_"]/"_$p(TypeCodeNode,"/",$l(TypeCodeNode,"/")),.documentList)	
		Set:TypeDescNode'="" TypeDesc=..GetValueByNode(DiagNode_"["_indDiag_"]/"_$p(TypeDescNode,"/",$l(TypeDescNode,"/")),.documentList)
		
		Set DiagType = $s((objFPType.BDCode="HDSD00.11"):"DiagType",1:"CMDiagType")
		If TypeDesc'="" {
			Set objDic=##class(CT.IPMR.BT.Dictionary).GetByTypeDesc(DiagType,TypeDesc,"",1)
			Set:$IsObject(objDic) TypeID=objDic.%Id()
		}
		if (TypeID="")&&(TypeDesc'="")&&(TypeCode'="") {
			Set DicStr = "^"_DiagType_"^"_TypeCode_"^"_TypeDesc_"^"_"^"_"^"_"^"_"^"_"^"_"^"_1_"^"_aSource_"^"
			Set ret = ##class(CT.IPMR.BT.Dictionary).Update(DicStr,"^")
			Set:+ret>0 TypeID=ret
		}
		Continue:TypeID=""
		
		// ICD字典（ICD10,ICD描述，副码）
		Set ICD10Node 		= ..GetNodeByCode("ICD10",SourceID)
		Set ICDDescNode 	= ..GetNodeByCode("ICD10Desc",SourceID)
		Set ICDinPairNode	= ..GetNodeByCode("ICDinPair",SourceID)
		Set:ICD10Node'="" ICD10=..GetValueByNode(DiagNode_"["_indDiag_"]/"_$p(ICD10Node,"/",$l(ICD10Node,"/")),.documentList)	
		Set:ICDDescNode'="" ICDDesc=..GetValueByNode(DiagNode_"["_indDiag_"]/"_$p(ICDDescNode,"/",$l(ICDDescNode,"/")),.documentList)
		Set:ICDinPairNode'="" ICDinPair=..GetValueByNode(DiagNode_"["_indDiag_"]/"_$p(ICDinPairNode,"/",$l(ICDinPairNode,"/")),.documentList)
		Continue:(ICD10="")||(ICDDesc="")
		
		Set xICDVerID = ICDVerID
		if (TypeCode=10)||(TypeCode=11)||(TypeCode=12)||(TypeCode=13)||(TypeCode=14) { 
			// 中医诊断
			Set xICDVerID = ICDVerID2
		}
		Set objICD=##class(CT.IPMR.FP.ICDDx).GetObjByICD10(xICDVerID,ICD10)
		If $IsObject(objICD){
			Set ICDID = objICD.%Id()
		}
		if ICDID="" {
			Set ICDCode	= ICD10_ICDinPair
			Set ICDStr 	= "^"_ICDCode_"^"_ICDDesc_"^"_xICDVerCode_"^"_ICD10_"^"_ICDinPair_"^"_"^"_"^"_"^"_"^"_(+$h)_"^"_"^"_1
			Set LogInfo 	= "^"_aSource_"^"_"第三方回传时导入"
			Set ret 	= ##class(CT.IPMR.FPS.ICDDxSrv).SaveICD(ICDStr,"",LogInfo,"^")
			Set:+ret>0 ICDID=ret
		}
		Continue:ICDID=""
		
		// 入院病情字典
		Set AdmitCondCodeNode = ..GetNodeByCode("AdmitCondCode",SourceID)
		Set AdmitCondDescNode = ..GetNodeByCode("AdmitCondDesc",SourceID)
		Set:AdmitCondCodeNode'="" AdmitCondCode=..GetValueByNode(DiagNode_"["_indDiag_"]/"_$p(AdmitCondCodeNode,"/",$l(AdmitCondCodeNode,"/")),.documentList)	
		Set:AdmitCondDescNode'="" AdmitCondDesc=..GetValueByNode(DiagNode_"["_indDiag_"]/"_$p(AdmitCondDescNode,"/",$l(AdmitCondDescNode,"/")),.documentList)
		If AdmitCondDesc'="" {
			Set objDic=##class(CT.IPMR.BT.Dictionary).GetByTypeDesc("DiseaseResult",AdmitCondDesc,"",1)
			Set:$IsObject(objDic) AdmitCondID=objDic.%Id()
		}
		if (AdmitCondID="")&&(AdmitCondDesc'="")&&(AdmitCondCode'="") {
			Set DicStr = "^"_"DiseaseResult"_"^"_AdmitCondCode_"^"_AdmitCondDesc_"^"_"^"_"^"_"^"_"^"_"^"_"^"_1_"^"_aSource_"^"
			Set ret = ##class(CT.IPMR.BT.Dictionary).Update(DicStr,"^")
			Set:+ret>0 AdmitCondID=ret
		}
		
		// 出院情况字典
		Set DischCondCodeNode = ..GetNodeByCode("DischCondCode",SourceID)
		Set DischCondDescNode = ..GetNodeByCode("DischCondDesc",SourceID)
		Set:DischCondCodeNode'="" DischCondCode=..GetValueByNode(DiagNode_"["_indDiag_"]/"_$p(DischCondCodeNode,"/",$l(DischCondCodeNode,"/")),.documentList)	
		Set:DischCondDescNode'="" DischCondDesc=..GetValueByNode(DiagNode_"["_indDiag_"]/"_$p(DischCondDescNode,"/",$l(DischCondDescNode,"/")),.documentList)
		If DischCondDesc'="" {
			Set objDic=##class(CT.IPMR.BT.Dictionary).GetByTypeDesc("Prognosis",DischCondDesc,"",1)
			Set:$IsObject(objDic) DischCondID=objDic.%Id()
		}
		if (DischCondID="")&&(DischCondDesc'="")&&(DischCondCode'="") {
			Set DicStr = "^"_"Prognosis"_"^"_DischCondCode_"^"_DischCondDesc_"^"_"^"_"^"_"^"_"^"_"^"_"^"_1_"^"_aSource_"^"
			Set ret = ##class(CT.IPMR.BT.Dictionary).Update(DicStr,"^")
			Set:+ret>0 DischCondID=ret
		}
		
		// 是否确诊字典
		Set DefiniteCodeNode = ..GetNodeByCode("IsDefiniteCode",SourceID)
		Set DefiniteDescNode = ..GetNodeByCode("IsDefiniteDesc",SourceID)
		Set:DefiniteCodeNode'="" IsDefiniteCode=..GetValueByNode(DiagNode_"["_indDiag_"]/"_$p(DefiniteCodeNode,"/",$l(DefiniteCodeNode,"/")),.documentList)	
		Set:DefiniteDescNode'="" IsDefiniteDesc=..GetValueByNode(DiagNode_"["_indDiag_"]/"_$p(DefiniteDescNode,"/",$l(DefiniteDescNode,"/")),.documentList)
		If IsDefiniteDesc'="" {
			Set objDic=##class(CT.IPMR.BT.Dictionary).GetByTypeDesc("IsDefinite",IsDefiniteDesc,"",1)
			Set:$IsObject(objDic) IsDefiniteID=objDic.%Id()
		}
		if (IsDefiniteID="")&&(IsDefiniteDesc'="")&&(IsDefiniteCode'="") {
			Set DicStr = "^"_"IsDefinite"_"^"_IsDefiniteCode_"^"_IsDefiniteDesc_"^"_"^"_"^"_"^"_"^"_"^"_"^"_1_"^"_aSource_"^"
			Set ret = ##class(CT.IPMR.BT.Dictionary).Update(DicStr,"^")
			Set:+ret>0 IsDefiniteID=ret
		}
		
		// 肿瘤形态学
		Set TumICD10Node 	= ..GetNodeByCode("TumICD10",SourceID)
		Set TumICDDescNode 	= ..GetNodeByCode("TumICDDesc",SourceID)
		Set:TumICD10Node'="" TumICD10=..GetValueByNode(DiagNode_"["_indDiag_"]/"_$p(TumICD10Node,"/",$l(TumICD10Node,"/")),.documentList)	
		Set:TumICDDescNode'="" TumICDDesc=..GetValueByNode(DiagNode_"["_indDiag_"]/"_$p(TumICDDescNode,"/",$l(TumICDDescNode,"/")),.documentList)
		
		Set objTumICD=##class(CT.IPMR.FP.ICDDx).GetObjByICD10(ICDVerID,TumICD10)
		If $IsObject(objTumICD){
			Set TumICDID = objTumICD.%Id()
		}
		if (TumICD10'="")&&(TumICDID="") {
			Set ICDStr 	= "^"_TumICD10_"^"_TumICDDesc_"^"_ICDVerID_"^"_TumICD10_"^"_"^"_"^"_"^"_"^"_"^"_(+$h)_"^"_"^"_1
			Set LogInfo 	= "^"_aSource_"^"_"第三方回传时导入"
			Set ret 	= ##class(CT.IPMR.FPS.ICDDxSrv).SaveICD(ICDStr,"",LogInfo,"^")
			Set:+ret>0 TumICD10=ret
		}
		
		// 分化程度
		Set TumDifferCodeNode = ..GetNodeByCode("TumDifferCode",SourceID)
		Set TumDifferDescNode = ..GetNodeByCode("TumDifferDesc",SourceID)
		Set:TumDifferCodeNode'="" TumDifferCode=..GetValueByNode(DiagNode_"["_indDiag_"]/"_$p(TumDifferCodeNode,"/",$l(TumDifferCodeNode,"/")),.documentList)	
		Set:TumDifferDescNode'="" TumDifferDesc=..GetValueByNode(DiagNode_"["_indDiag_"]/"_$p(TumDifferDescNode,"/",$l(TumDifferDescNode,"/")),.documentList)
		If TumDifferDesc'="" {
			Set objDic=##class(CT.IPMR.BT.Dictionary).GetByTypeDesc("TumDiffer",TumDifferDesc,"",1)
			Set:$IsObject(objDic) TumDifferID=objDic.%Id()
		}
		if (TumDifferID="")&&(TumDifferDesc'="")&&(TumDifferCode'="") {
			Set DicStr = "^"_"TumDiffer"_"^"_TumDifferCode_"^"_TumDifferDesc_"^"_"^"_"^"_"^"_"^"_"^"_"^"_1_"^"_aSource_"^"
			Set ret = ##class(CT.IPMR.BT.Dictionary).Update(DicStr,"^")
			Set:+ret>0 TumDifferID=ret
		}
		
		// 肿瘤分期
		Set TumStagesCodeNode = ..GetNodeByCode("TumStagesCode",SourceID)
		Set TumStagesDescNode = ..GetNodeByCode("TumStagesDesc",SourceID)
		Set:TumStagesCodeNode'="" TumStagesCode=..GetValueByNode(DiagNode_"["_indDiag_"]/"_$p(TumStagesCodeNode,"/",$l(TumStagesCodeNode,"/")),.documentList)	
		Set:TumStagesDescNode'="" TumStagesDesc=..GetValueByNode(DiagNode_"["_indDiag_"]/"_$p(TumStagesDescNode,"/",$l(TumStagesDescNode,"/")),.documentList)
		If TumStagesDesc'="" {
			Set objDic=##class(CT.IPMR.BT.Dictionary).GetByTypeDesc("TumStages",TumStagesDesc,"",1)
			Set:$IsObject(objDic) TumStagesID=objDic.%Id()
		}
		if (TumStagesID="")&&(TumStagesDesc'="")&&(TumStagesCode'="") {
			Set DicStr = "^"_"TumStages"_"^"_TumStagesCode_"^"_TumStagesDesc_"^"_"^"_"^"_"^"_"^"_"^"_"^"_1_"^"_aSource_"^"
			Set ret = ##class(CT.IPMR.BT.Dictionary).Update(DicStr,"^")
			Set:+ret>0 TumStagesID=ret
		}
		
		// 临床诊断
		Set ClinicICD10Node = ..GetNodeByCode("ClinicICD10",SourceID)
		Set ClinicICDDescNode = ..GetNodeByCode("ClinicICD10Desc",SourceID)
		Set:ClinicICD10Node'="" ClinicICD10=..GetValueByNode(DiagNode_"["_indDiag_"]/"_$p(ClinicICD10Node,"/",$l(ClinicICD10Node,"/")),.documentList)	
		Set:ClinicICDDescNode'="" ClinicICDDesc=..GetValueByNode(DiagNode_"["_indDiag_"]/"_$p(ClinicICDDescNode,"/",$l(ClinicICDDescNode,"/")),.documentList)

		// 损伤中毒原因
		Set InjuryICD10Node 	= ..GetNodeByCode("InjuryICD10",SourceID)
		Set InjuryICDDescNode 	= ..GetNodeByCode("InjuryICDDesc",SourceID)
		Set:InjuryICD10Node'="" InjuryICD10=..GetValueByNode(DiagNode_"["_indDiag_"]/"_$p(InjuryICD10Node,"/",$l(InjuryICD10Node,"/")),.documentList)	
		Set:InjuryICDDescNode'="" InjuryICDDesc=..GetValueByNode(DiagNode_"["_indDiag_"]/"_$p(InjuryICDDescNode,"/",$l(InjuryICDDescNode,"/")),.documentList)
		
		Set objInjuryICD=##class(CT.IPMR.FP.ICDDx).GetObjByICD10(ICDVerID,InjuryICD10)
		If $IsObject(objInjuryICD){
			Set InjuryICDID = objInjuryICD.%Id()
		}
		if (InjuryICD10'="")&&(InjuryICDID="") {
			Set ICDStr 	= "^"_InjuryICD10_"^"_InjuryICDDesc_"^"_ICDVerID_"^"_InjuryICD10_"^"_"^"_"^"_"^"_"^"_"^"_(+$h)_"^"_"^"_1
			Set LogInfo 	= "^"_aSource_"^"_"第三方回传时导入"
			Set ret 	= ##class(CT.IPMR.FPS.ICDDxSrv).SaveICD(ICDStr,"",LogInfo,"^")
			Set:+ret>0 InjuryICDID=ret
		}
		
		Set Index = indDiag
		Set DiagTmpStr = $c(2)_Index_$c(2)_ICDID_$c(2)_TypeID_$c(2)_AdmitCondID_$c(2)_DischCondID_$c(2)_IsDefiniteID
			_$c(2)_TempData_$c(2)_TumICDID_$c(2)_TumICD10_$c(2)_TumICDDesc_$c(2)_TumDifferID_$c(2)_TumStagesID
			_$c(2)_ClinicICDDesc_$c(2)_ICD10_$c(2)_ICDDesc_$c(2)_InjuryICDID_$c(2)_InjuryICD10_$c(2)_InjuryICDDesc_$c(2)_ClinicICD10
		Set:DiagStr'="" DiagStr = DiagStr_$c(1)
		Set DiagStr = DiagStr_DiagTmpStr
	}
	Set return = DiagStr
	Quit return
}

/// 取手术信息
ClassMethod GetOperInfo()
{
	Set return = "",OperStr = ""	
	Set ICD9Node = ..GetNodeByCode("ICD9",SourceID)
	Set OperListNode = $p(ICD9Node,"/",1,$l(ICD9Node,"/")-2)
	Set OperNode = $p(ICD9Node,"/",1,$l(ICD9Node,"/")-1)
	Quit:(OperListNode="")||(OperNode="") return
	
	Set sc = documentList.EvaluateExpression(OperListNode,"count("_$p(OperNode,"/",$l(OperNode,"/"))_")",.documentNode)
	Quit:($$$ERROR(sc)||(documentNode.GetAt(1)="")) return
	Set OperCount = documentNode.GetAt(1).Value
	
	for indOper=1:1:OperCount
	{
		Set OperTmpStr = ""
		Set (Index,ICDID,ICD9,ICDDesc,SttDate,SttTime,EndDate,EndTime,OperatorID,OperatorCode,OperatorName)=""
		Set (Assistant1ID,Assistant1Code,Assistant1Name,Assistant2ID,Assistant2Name,Assistant2Code)=""
		Set (NarcosisTypeID,NarcosisTypeCode,NarcosisTypeDesc,NarcosisDocID,NarcosisDocCode,NarcosisDocName)=""
		Set (CutTypeID,CutTypeCode,CutTypeDesc,HealingID,HealingCode,HealingDesc,OperLevelID,OperLevelCode,OperLevelDesc)=""
		Set (MainOperID,MainOperCode,MainOperDesc,TempData,AppendOper,AisOperID,NarcosisLevelID,NarcosisLevelCode,NarcosisLevelDesc)=""
		Set (OperSiteID,OperSiteCode,OperSiteDesc,OperLocID,OperLocCode,OperLocDesc,BackOperID,BackOperCode,BackOperDesc)=""
		Set (NNISLevelID,NNISLevelCode,NNISLevelDesc,OperCatID,OperCatCode,OperCatDesc,DurationTime,ClinicICD10,ClinicICDDesc)=""
		Set (IsEmergencyID,IsEmergencyCode,IsEmergencyDesc,IsMiniInvaID,IsMiniInvaCode,IsMiniInvaDesc)=""
		Set (IsChooseDateID,IsChooseDateCode,IsChooseDateDesc,NarcosisSttDate,NarcosisSttTime,NarcosisEndDate,NarcosisEndTime)=""
		// 手术类型字典
		Set TypeCodeNode = ..GetNodeByCode("OperTypeCode",SourceID)
		Set TypeDescNode = ..GetNodeByCode("OperTypeDesc",SourceID)
		Set:TypeCodeNode'="" TypeCode=..GetValueByNode(OperNode_"["_indOper_"]/"_$p(TypeCodeNode,"/",$l(TypeCodeNode,"/")),.documentList)	
		Set:TypeDescNode'="" TypeDesc=..GetValueByNode(OperNode_"["_indOper_"]/"_$p(TypeDescNode,"/",$l(TypeDescNode,"/")),.documentList)
		
		If TypeDesc'="" {
			Set objDic=##class(CT.IPMR.BT.Dictionary).GetByTypeDesc("OperType",TypeDesc,"",1)
			Set:$IsObject(objDic) TypeID=objDic.%Id()
		}
		if (TypeID="")&&(TypeDesc'="")&&(TypeCode'="") {
			Set DicStr = "^"_"OperType"_"^"_TypeCode_"^"_TypeDesc_"^"_"^"_"^"_"^"_"^"_"^"_"^"_1_"^"_aSource_"^"
			Set ret = ##class(CT.IPMR.BT.Dictionary).Update(DicStr,"^")
			Set:+ret>0 TypeID=ret
		}
		Continue:TypeID=""
		
		// ICD字典（ICD9,ICD描述，副码）
		Set ICD9Node = ..GetNodeByCode("ICD9",SourceID)
		Set ICD9DescNode = ..GetNodeByCode("ICD9Desc",SourceID)
		Set:ICD9Node'="" ICD9=..GetValueByNode(OperNode_"["_indOper_"]/"_$p(ICD9Node,"/",$l(ICD9Node,"/")),.documentList)	
		Set:ICD9DescNode'="" ICDDesc=..GetValueByNode(OperNode_"["_indOper_"]/"_$p(ICD9DescNode,"/",$l(ICD9DescNode,"/")),.documentList)
		Continue:(ICD9="")||(ICDDesc="")
		
		Set ICDCode = ICD9
		Set objICD=##class(CT.IPMR.FP.ICDDx).GetObjByICD10(OprVerID,ICD9)
		If $IsObject(objICD){
			Set ICDID = objICD.%Id()
		}
		
		if ICDID="" {
			Set ICDStr 	= "^"_ICDCode_"^"_ICDDesc_"^"_OprVerCode_"^"_ICD9_"^"_"^"_"^"_"^"_"^"_"^"_(+$h)_"^"_"^"_1
			Set LogInfo 	= "^"_aSource_"^"_"第三方回传时导入"
			Set ret 	= ##class(CT.IPMR.FPS.ICDDxSrv).SaveICD(ICDStr,"",LogInfo,"^")
			Set:+ret>0 ICDID=ret
		}
		Continue:ICDID=""
		
		// 手术日期
		Set SttDateNode = ..GetNodeByCode("SttDate",SourceID)
		Set SttTimeNode = ..GetNodeByCode("SttTime",SourceID)
		Set EndDateNode = ..GetNodeByCode("EndDate",SourceID)
		Set EndTimeNode = ..GetNodeByCode("EndTime",SourceID)
		Set:SttDateNode'="" SttDate=..GetValueByNode(OperNode_"["_indOper_"]/"_$p(SttDateNode,"/",$l(SttDateNode,"/")),.documentList)	
		Set:SttTimeNode'="" SttTime=..GetValueByNode(OperNode_"["_indOper_"]/"_$p(SttTimeNode,"/",$l(SttTimeNode,"/")),.documentList)
		Set:EndDateNode'="" EndDate=..GetValueByNode(OperNode_"["_indOper_"]/"_$p(EndDateNode,"/",$l(EndDateNode,"/")),.documentList)	
		Set:EndTimeNode'="" EndTime=..GetValueByNode(OperNode_"["_indOper_"]/"_$p(EndTimeNode,"/",$l(EndTimeNode,"/")),.documentList)
		
		Set SttDate=$tr(SttDate,"年","-")
		Set SttDate=$tr(SttDate,"月","-")
		Set SttDate=$tr(SttDate,"日","")
		Set EndDate=$tr(EndDate,"年","-")
		Set EndDate=$tr(EndDate,"月","-")
		Set EndDate=$tr(EndDate,"日","")
		
		// 术者
		Set OperatorCodeNode = ..GetNodeByCode("OperatorCode",SourceID)
		Set OperatorNameNode = ..GetNodeByCode("OperatorName",SourceID)
		Set:OperatorCodeNode'="" OperatorCode=..GetValueByNode(OperNode_"["_indOper_"]/"_$p(OperatorCodeNode,"/",$l(OperatorCodeNode,"/")),.documentList)	
		Set:OperatorNameNode'="" OperatorName=..GetValueByNode(OperNode_"["_indOper_"]/"_$p(OperatorNameNode,"/",$l(OperatorNameNode,"/")),.documentList)
		if OperatorCode'="" {
			Set UserStr = ##class(MA.IPMR.BTS.SSUserSrv).GetUserStrByInitials(OperatorCode)
			Set:UserStr'="" OperatorName=$p(UserStr,"^",3)
			Set:UserStr'="" OperatorID=$p(UserStr,"^",1)
		}else{
			Set UserStr = ##class(MA.IPMR.BTS.SSUserSrv).GetUserStrByName(OperatorName)
			Set:UserStr'="" OperatorName=$p(UserStr,"^",3)
			Set:UserStr'="" OperatorID=$p(UserStr,"^",1)
		}
		
		// 一助
		Set Assistant1CodeNode = ..GetNodeByCode("Assistant1Code",SourceID)
		Set Assistant1NameNode = ..GetNodeByCode("Assistant1Name",SourceID)
		Set:Assistant1CodeNode'="" Assistant1Code=..GetValueByNode(OperNode_"["_indOper_"]/"_$p(Assistant1CodeNode,"/",$l(Assistant1CodeNode,"/")),.documentList)	
		Set:Assistant1NameNode'="" Assistant1Name=..GetValueByNode(OperNode_"["_indOper_"]/"_$p(Assistant1NameNode,"/",$l(Assistant1NameNode,"/")),.documentList)
		if Assistant1Code'="" {
			Set UserStr = ##class(MA.IPMR.BTS.SSUserSrv).GetUserStrByInitials(Assistant1Code)
			Set:UserStr'="" Assistant1Name=$p(UserStr,"^",3)
			Set:UserStr'="" Assistant1ID=$p(UserStr,"^",1)
		}else{
			Set UserStr = ##class(MA.IPMR.BTS.SSUserSrv).GetUserStrByName(Assistant1Name)
			Set:UserStr'="" Assistant1Name=$p(UserStr,"^",3)
			Set:UserStr'="" Assistant1ID=$p(UserStr,"^",1)
		}
		
		// 二助
		Set Assistant2CodeNode = ..GetNodeByCode("Assistant2Code",SourceID)
		Set Assistant2NameNode = ..GetNodeByCode("Assistant2Name",SourceID)
		Set:Assistant2CodeNode'="" Assistant2Code=..GetValueByNode(OperNode_"["_indOper_"]/"_$p(Assistant2CodeNode,"/",$l(Assistant2CodeNode,"/")),.documentList)	
		Set:Assistant2NameNode'="" Assistant2Name=..GetValueByNode(OperNode_"["_indOper_"]/"_$p(Assistant2NameNode,"/",$l(Assistant2NameNode,"/")),.documentList)
		if Assistant2Code'="" {
			Set UserStr = ##class(MA.IPMR.BTS.SSUserSrv).GetUserStrByInitials(Assistant2Code)
			Set:UserStr'="" Assistant2Name=$p(UserStr,"^",3)
			Set:UserStr'="" Assistant2ID=$p(UserStr,"^",1)
		}else{
			Set UserStr = ##class(MA.IPMR.BTS.SSUserSrv).GetUserStrByName(Assistant2Name)
			Set:UserStr'="" Assistant2Name=$p(UserStr,"^",3)
			Set:UserStr'="" Assistant2ID=$p(UserStr,"^",1)
		}
		
		// 麻醉方式字典
		Set NarTypeCodeNode = ..GetNodeByCode("NarcosisTypeCode",SourceID)
		Set NarTypeDescNode = ..GetNodeByCode("NarcosisTypeDesc",SourceID)
		Set:NarTypeCodeNode'="" NarcosisTypeCode=..GetValueByNode(OperNode_"["_indOper_"]/"_$p(NarTypeCodeNode,"/",$l(NarTypeCodeNode,"/")),.documentList)	
		Set:NarTypeDescNode'="" NarcosisTypeDesc=..GetValueByNode(OperNode_"["_indOper_"]/"_$p(NarTypeDescNode,"/",$l(NarTypeDescNode,"/")),.documentList)
		If NarcosisTypeDesc'="" {
			Set objDic=##class(CT.IPMR.BT.Dictionary).GetByTypeDesc("NarcosisType",NarcosisTypeDesc,"",1)
			Set:$IsObject(objDic) NarcosisTypeID=objDic.%Id()
		}
		if (NarcosisTypeID="")&&(NarcosisTypeDesc'="")&&(NarcosisTypeCode'="") {
			Set DicStr = "^"_"NarcosisType"_"^"_NarcosisTypeCode_"^"_NarcosisTypeDesc_"^"_"^"_"^"_"^"_"^"_"^"_"^"_1_"^"_aSource_"^"
			Set ret = ##class(CT.IPMR.BT.Dictionary).Update(DicStr,"^")
			Set:+ret>0 NarcosisTypeID=ret
		}
		
		// 麻醉医师
		Set NarDocCodeNode = ..GetNodeByCode("NarcosisDocCode",SourceID)
		Set NarDocNameNode = ..GetNodeByCode("NarcosisDocName",SourceID)
		Set:NarDocCodeNode'="" NarcosisDocCode=..GetValueByNode(OperNode_"["_indOper_"]/"_$p(NarDocCodeNode,"/",$l(NarDocCodeNode,"/")),.documentList)	
		Set:NarDocNameNode'="" NarcosisDocName=..GetValueByNode(OperNode_"["_indOper_"]/"_$p(NarDocNameNode,"/",$l(NarDocNameNode,"/")),.documentList)
		if NarcosisDocCode'="" {
			Set UserStr = ##class(MA.IPMR.BTS.SSUserSrv).GetUserStrByInitials(NarcosisDocCode)
			Set:UserStr'="" NarcosisDocName=$p(UserStr,"^",3)
			Set:UserStr'="" NarcosisDocID=$p(UserStr,"^",1)
		}else{
			Set UserStr = ##class(MA.IPMR.BTS.SSUserSrv).GetUserStrByName(NarcosisDocName)
			Set:UserStr'="" NarcosisDocName=$p(UserStr,"^",3)
			Set:UserStr'="" NarcosisDocID=$p(UserStr,"^",1)
		}
		
		// 切口类型字典
		Set CutTypeCodeNode = ..GetNodeByCode("CutTypeCode",SourceID)
		Set CutTypeDescNode = ..GetNodeByCode("CutTypeDesc",SourceID)
		Set:CutTypeCodeNode'="" CutTypeCode=..GetValueByNode(OperNode_"["_indOper_"]/"_$p(CutTypeCodeNode,"/",$l(CutTypeCodeNode,"/")),.documentList)	
		Set:CutTypeDescNode'="" CutTypeDesc=..GetValueByNode(OperNode_"["_indOper_"]/"_$p(CutTypeDescNode,"/",$l(CutTypeDescNode,"/")),.documentList)
		If CutTypeDesc'="" {
			Set objDic=##class(CT.IPMR.BT.Dictionary).GetByTypeDesc("CutType",CutTypeDesc,"",1)
			Set:$IsObject(objDic) CutTypeID=objDic.%Id()
		}
		if (CutTypeID="")&&(CutTypeDesc'="")&&(CutTypeCode'="") {
			Set DicStr = "^"_"CutType"_"^"_CutTypeCode_"^"_CutTypeDesc_"^"_"^"_"^"_"^"_"^"_"^"_"^"_1_"^"_aSource_"^"
			Set ret = ##class(CT.IPMR.BT.Dictionary).Update(DicStr,"^")
			Set:+ret>0 CutTypeID=ret
		}
		
		// 愈合等级字典
		Set HealingCodeNode = ..GetNodeByCode("HealingCode",SourceID)
		Set HealingDescNode = ..GetNodeByCode("HealingDesc",SourceID)
		Set:HealingCodeNode'="" HealingCode=..GetValueByNode(OperNode_"["_indOper_"]/"_$p(HealingCodeNode,"/",$l(HealingCodeNode,"/")),.documentList)	
		Set:HealingDescNode'="" HealingDesc=..GetValueByNode(OperNode_"["_indOper_"]/"_$p(HealingDescNode,"/",$l(HealingDescNode,"/")),.documentList)
		If HealingDesc'="" {
			Set objDic=##class(CT.IPMR.BT.Dictionary).GetByTypeDesc("Healing",HealingDesc,"",1)
			Set:$IsObject(objDic) HealingID=objDic.%Id()
		}
		if (HealingID="")&&(HealingDesc'="")&&(HealingCode'="") {
			Set DicStr = "^"_"Healing"_"^"_HealingCode_"^"_HealingDesc_"^"_"^"_"^"_"^"_"^"_"^"_"^"_1_"^"_aSource_"^"
			Set ret = ##class(CT.IPMR.BT.Dictionary).Update(DicStr,"^")
			Set:+ret>0 HealingID=ret
		}
		
		// 手术等级字典
		Set OperLevelCodeNode = ..GetNodeByCode("OperLevelCode",SourceID)
		Set OperLevelDescNode = ..GetNodeByCode("OperLevelDesc",SourceID)
		Set:OperLevelCodeNode'="" OperLevelCode=..GetValueByNode(OperNode_"["_indOper_"]/"_$p(OperLevelCodeNode,"/",$l(OperLevelCodeNode,"/")),.documentList)	
		Set:OperLevelDescNode'="" OperLevelDesc=..GetValueByNode(OperNode_"["_indOper_"]/"_$p(OperLevelDescNode,"/",$l(OperLevelDescNode,"/")),.documentList)
		If OperLevelDesc'="" {
			Set objDic=##class(CT.IPMR.BT.Dictionary).GetByTypeDesc("OperationRank",OperLevelDesc,"",1)
			Set:$IsObject(objDic) OperLevelID=objDic.%Id()
		}
		if (OperLevelID="")&&(OperLevelDesc'="")&&(OperLevelCode'="") {
			Set DicStr = "^"_"OperationRank"_"^"_OperLevelCode_"^"_OperLevelDesc_"^"_"^"_"^"_"^"_"^"_"^"_"^"_1_"^"_aSource_"^"
			Set ret = ##class(CT.IPMR.BT.Dictionary).Update(DicStr,"^")
			Set:+ret>0 OperLevelID=ret
		}
		
		// 主手术字典
		Set MainOperCodeNode = ..GetNodeByCode("MainOperCode",SourceID)
		Set MainOperDescNode = ..GetNodeByCode("MainOperDesc",SourceID)
		Set:MainOperCodeNode'="" MainOperCode=..GetValueByNode(OperNode_"["_indOper_"]/"_$p(MainOperCodeNode,"/",$l(MainOperCodeNode,"/")),.documentList)	
		Set:MainOperDescNode'="" MainOperDesc=..GetValueByNode(OperNode_"["_indOper_"]/"_$p(MainOperDescNode,"/",$l(MainOperDescNode,"/")),.documentList)
		If MainOperDesc'="" {
			Set objDic=##class(CT.IPMR.BT.Dictionary).GetByTypeDesc("MainOper",MainOperDesc,"",1)
			Set:$IsObject(objDic) MainOperID=objDic.%Id()
		}
		if (MainOperID="")&&(MainOperDesc'="")&&(MainOperCode'="") {
			Set DicStr = "^"_"MainOper"_"^"_MainOperCode_"^"_MainOperDesc_"^"_"^"_"^"_"^"_"^"_"^"_"^"_1_"^"_aSource_"^"
			Set ret = ##class(CT.IPMR.BT.Dictionary).Update(DicStr,"^")
			Set:+ret>0 MainOperID=ret
		}
		
		// 附属手术
		Set AppendOperNode = ..GetNodeByCode("AppendOper",SourceID)
		Set:AppendOperNode'="" AppendOper=..GetValueByNode(OperNode_"["_indOper_"]/"_$p(AppendOperNode,"/",$l(AppendOperNode,"/")),.documentList)	
		Set AppendOper = $s((AppendOper="是"):1,1:0)
		
		// 麻醉分级
		Set NarcosisLevelCodeNode = ..GetNodeByCode("NarcosisLevelCode",SourceID)
		Set NarcosisLevelDescNode = ..GetNodeByCode("NarcosisLevelDesc",SourceID)
		Set:NarcosisLevelCodeNode'="" NarcosisLevelCode=..GetValueByNode(OperNode_"["_indOper_"]/"_$p(NarcosisLevelCodeNode,"/",$l(NarcosisLevelCodeNode,"/")),.documentList)	
		Set:NarcosisLevelDescNode'="" NarcosisLevelDesc=..GetValueByNode(OperNode_"["_indOper_"]/"_$p(NarcosisLevelDescNode,"/",$l(NarcosisLevelDescNode,"/")),.documentList)
		If NarcosisLevelDesc'="" {
			Set objDic=##class(CT.IPMR.BT.Dictionary).GetByTypeDesc("NarcosisLevel",NarcosisLevelDesc,"",1)
			Set:$IsObject(objDic) NarcosisLevelID=objDic.%Id()
		}
		if (NarcosisLevelID="")&&(NarcosisLevelDesc'="")&&(NarcosisLevelCode'="") {
			Set DicStr = "^"_"NarcosisLevel"_"^"_NarcosisLevelCode_"^"_NarcosisLevelDesc_"^"_"^"_"^"_"^"_"^"_"^"_"^"_1_"^"_aSource_"^"
			Set ret = ##class(CT.IPMR.BT.Dictionary).Update(DicStr,"^")
			Set:+ret>0 NarcosisLevelID=ret
		}
		
		// 手术部位
		Set OperSiteCodeNode = ..GetNodeByCode("OperSiteCode",SourceID)
		Set OperSiteDescNode = ..GetNodeByCode("OperSiteDesc",SourceID)
		Set:OperSiteCodeNode'="" OperSiteCode=..GetValueByNode(OperNode_"["_indOper_"]/"_$p(OperSiteCodeNode,"/",$l(OperSiteCodeNode,"/")),.documentList)	
		Set:OperSiteDescNode'="" OperSiteDesc=..GetValueByNode(OperNode_"["_indOper_"]/"_$p(OperSiteDescNode,"/",$l(OperSiteDescNode,"/")),.documentList)
		If OperSiteDesc'="" {
			Set objDic=##class(CT.IPMR.BT.Dictionary).GetByTypeDesc("OperSite",OperSiteDesc,"",1)
			Set:$IsObject(objDic) OperSiteID=objDic.%Id()
		}
		if (OperSiteID="")&&(OperSiteDesc'="")&&(OperSiteCode'="") {
			Set DicStr = "^"_"OperSite"_"^"_OperSiteCode_"^"_OperSiteDesc_"^"_"^"_"^"_"^"_"^"_"^"_"^"_1_"^"_aSource_"^"
			Set ret = ##class(CT.IPMR.BT.Dictionary).Update(DicStr,"^")
			Set:+ret>0 OperSiteID=ret
		}
		
		// 术者所在科室
		Set OperLocCodeNode = ..GetNodeByCode("OperLocCode",SourceID)
		Set OperLocDescNode = ..GetNodeByCode("OperLocDesc",SourceID)
		Set:OperLocCodeNode'="" OperLocCode=..GetValueByNode(OperNode_"["_indOper_"]/"_$p(OperLocCodeNode,"/",$l(OperLocCodeNode,"/")),.documentList)	
		Set:OperLocDescNode'="" OperLocDesc=..GetValueByNode(OperNode_"["_indOper_"]/"_$p(OperLocDescNode,"/",$l(OperLocDescNode,"/")),.documentList)
		If OperLocDesc'="" {
			Set OperLocID = $o(^MA.IPMR.BT.LocationI("IdxOfDesc"," "_$zcvt(OperLocDesc,"U"),0))
		}
		
		// 非计划重返手术
		Set BackOperCodeNode = ..GetNodeByCode("BackOperCode",SourceID)
		Set BackOperDescNode = ..GetNodeByCode("BackOperDesc",SourceID)
		Set:BackOperCodeNode'="" BackOperCode=..GetValueByNode(OperNode_"["_indOper_"]/"_$p(BackOperCodeNode,"/",$l(BackOperCodeNode,"/")),.documentList)	
		Set:BackOperDescNode'="" BackOperDesc=..GetValueByNode(OperNode_"["_indOper_"]/"_$p(BackOperDescNode,"/",$l(BackOperDescNode,"/")),.documentList)
		If BackOperDesc'="" {
			Set objDic=##class(CT.IPMR.BT.Dictionary).GetByTypeDesc("BackOper",BackOperDesc,"",1)
			Set:$IsObject(objDic) BackOperID=objDic.%Id()
		}
		if (BackOperID="")&&(BackOperDesc'="")&&(BackOperCode'="") {
			Set DicStr = "^"_"BackOper"_"^"_BackOperCode_"^"_BackOperDesc_"^"_"^"_"^"_"^"_"^"_"^"_"^"_1_"^"_aSource_"^"
			Set ret = ##class(CT.IPMR.BT.Dictionary).Update(DicStr,"^")
			Set:+ret>0 BackOperID=ret
		}
		
		// 手术风险等级
		Set NNISLevelCodeNode = ..GetNodeByCode("NNISLevelCode",SourceID)
		Set NNISLevelDescNode = ..GetNodeByCode("NNISLevelDesc",SourceID)
		Set:NNISLevelCodeNode'="" NNISLevelCode=..GetValueByNode(OperNode_"["_indOper_"]/"_$p(NNISLevelCodeNode,"/",$l(NNISLevelCodeNode,"/")),.documentList)	
		Set:NNISLevelDescNode'="" NNISLevelDesc=..GetValueByNode(OperNode_"["_indOper_"]/"_$p(NNISLevelDescNode,"/",$l(NNISLevelDescNode,"/")),.documentList)
		If NNISLevelDesc'="" {
			Set objDic=##class(CT.IPMR.BT.Dictionary).GetByTypeDesc("NNISLevel",NNISLevelDesc,"",1)
			Set:$IsObject(objDic) NNISLevelID=objDic.%Id()
		}
		if (NNISLevelID="")&&(NNISLevelDesc'="")&&(NNISLevelCode'="") {
			Set DicStr = "^"_"NNISLevel"_"^"_NNISLevelCode_"^"_NNISLevelDesc_"^"_"^"_"^"_"^"_"^"_"^"_"^"_1_"^"_aSource_"^"
			Set ret = ##class(CT.IPMR.BT.Dictionary).Update(DicStr,"^")
			Set:+ret>0 NNISLevelID=ret
		}
		
		// 手术类别
		Set OperCatCodeNode = ..GetNodeByCode("OperCatCode",SourceID)
		Set OperCatDescNode = ..GetNodeByCode("OperCatDesc",SourceID)
		Set:OperCatCodeNode'="" OperCatCode=..GetValueByNode(OperNode_"["_indOper_"]/"_$p(OperCatCodeNode,"/",$l(OperCatCodeNode,"/")),.documentList)	
		Set:OperCatDescNode'="" OperCatDesc=..GetValueByNode(OperNode_"["_indOper_"]/"_$p(OperCatDescNode,"/",$l(OperCatDescNode,"/")),.documentList)
		If OperCatDesc'="" {
			Set objDic=##class(CT.IPMR.BT.Dictionary).GetByTypeDesc("OperCat",OperCatDesc,"",1)
			Set:$IsObject(objDic) OperCatID=objDic.%Id()
		}
		if (OperCatID="")&&(OperCatDesc'="")&&(OperCatCode'="") {
			Set DicStr = "^"_"OperCat"_"^"_OperCatCode_"^"_OperCatDesc_"^"_"^"_"^"_"^"_"^"_"^"_"^"_1_"^"_aSource_"^"
			Set ret = ##class(CT.IPMR.BT.Dictionary).Update(DicStr,"^")
			Set:+ret>0 OperCatID=ret
		}
		
		// 手术持续时间
		Set DurationTimeNode = ..GetNodeByCode("DurationTime",SourceID)
		Set:DurationTimeNode'="" DurationTime=..GetValueByNode(OperNode_"["_indOper_"]/"_$p(DurationTimeNode,"/",$l(DurationTimeNode,"/")),.documentList)	
		
		// 临床手术
		Set ClinicICD10Node = ..GetNodeByCode("ClinicICD9",SourceID)
		Set ClinicICDDescNode = ..GetNodeByCode("ClinicICD9Desc",SourceID)
		Set:ClinicICD10Node'="" ClinicICD10=..GetValueByNode(OperNode_"["_indOper_"]/"_$p(ClinicICD10Node,"/",$l(ClinicICD10Node,"/")),.documentList)	
		Set:ClinicICDDescNode'="" ClinicICDDesc=..GetValueByNode(OperNode_"["_indOper_"]/"_$p(ClinicICDDescNode,"/",$l(ClinicICDDescNode,"/")),.documentList)	
		
		// 是否急诊手术
		Set IsEmergencyCodeNode = ..GetNodeByCode("IsEmergencyCode",SourceID)
		Set IsEmergencyDescNode = ..GetNodeByCode("IsEmergencyDesc",SourceID)
		Set:IsEmergencyCodeNode'="" IsEmergencyCode=..GetValueByNode(OperNode_"["_indOper_"]/"_$p(IsEmergencyCodeNode,"/",$l(IsEmergencyCodeNode,"/")),.documentList)	
		Set:IsEmergencyDescNode'="" IsEmergencyDesc=..GetValueByNode(OperNode_"["_indOper_"]/"_$p(IsEmergencyDescNode,"/",$l(IsEmergencyDescNode,"/")),.documentList)
		If IsEmergencyDesc'="" {
			Set objDic=##class(CT.IPMR.BT.Dictionary).GetByTypeDesc("YesOrNo",IsEmergencyDesc,"",1)
			Set:$IsObject(objDic) IsEmergencyID=objDic.%Id()
		}
		
		// 是否微创手术
		Set IsMiniInvaCodeNode = ..GetNodeByCode("IsMiniInvaCode",SourceID)
		Set IsMiniInvaDescNode = ..GetNodeByCode("IsMiniInvaDesc",SourceID)
		Set:IsMiniInvaCodeNode'="" IsMiniInvaCode=..GetValueByNode(OperNode_"["_indOper_"]/"_$p(IsMiniInvaCodeNode,"/",$l(IsMiniInvaCodeNode,"/")),.documentList)	
		Set:IsMiniInvaDescNode'="" IsMiniInvaDesc=..GetValueByNode(OperNode_"["_indOper_"]/"_$p(IsMiniInvaDescNode,"/",$l(IsMiniInvaDescNode,"/")),.documentList)
		If IsMiniInvaDesc'="" {
			Set objDic=##class(CT.IPMR.BT.Dictionary).GetByTypeDesc("YesOrNo",IsMiniInvaDesc,"",1)
			Set:$IsObject(objDic) IsMiniInvaID=objDic.%Id()
		}
		
		// 是否择期手术
		Set IsChooseDateCodeNode = ..GetNodeByCode("IsChooseDateCode",SourceID)
		Set IsChooseDateDescNode = ..GetNodeByCode("IsChooseDateDesc",SourceID)
		Set:IsChooseDateCodeNode'="" IsChooseDateCode=..GetValueByNode(OperNode_"["_indOper_"]/"_$p(IsChooseDateCodeNode,"/",$l(IsChooseDateCodeNode,"/")),.documentList)	
		Set:IsChooseDateDescNode'="" IsChooseDateDesc=..GetValueByNode(OperNode_"["_indOper_"]/"_$p(IsChooseDateDescNode,"/",$l(IsChooseDateDescNode,"/")),.documentList)
		If IsChooseDateDesc'="" {
			Set objDic=##class(CT.IPMR.BT.Dictionary).GetByTypeDesc("YesOrNo",IsChooseDateDesc,"",1)
			Set:$IsObject(objDic) IsChooseDateID=objDic.%Id()
		}
		
		// 麻醉时间
		Set NarcosisSttDateNode = ..GetNodeByCode("NarcosisSttDate",SourceID)
		Set NarcosisSttTimeNode = ..GetNodeByCode("NarcosisSttTime",SourceID)
		Set NarcosisEndDateNode = ..GetNodeByCode("NarcosisEndDate",SourceID)
		Set NarcosisEndTimeNode = ..GetNodeByCode("NarcosisEndTime",SourceID)
		Set:NarcosisSttDateNode'="" NarcosisSttDate=..GetValueByNode(OperNode_"["_indOper_"]/"_$p(NarcosisSttDateNode,"/",$l(NarcosisSttDateNode,"/")),.documentList)	
		Set:NarcosisSttTimeNode'="" NarcosisSttTime=..GetValueByNode(OperNode_"["_indOper_"]/"_$p(NarcosisSttTimeNode,"/",$l(NarcosisSttTimeNode,"/")),.documentList)
		Set:NarcosisEndDateNode'="" NarcosisEndDate=..GetValueByNode(OperNode_"["_indOper_"]/"_$p(NarcosisEndDateNode,"/",$l(NarcosisEndDateNode,"/")),.documentList)	
		Set:NarcosisEndTimeNode'="" NarcosisEndTime=..GetValueByNode(OperNode_"["_indOper_"]/"_$p(NarcosisEndTimeNode,"/",$l(NarcosisEndTimeNode,"/")),.documentList)
		
		Set NarcosisSttDate=$tr(NarcosisSttDate,"年","-")
		Set NarcosisSttDate=$tr(NarcosisSttDate,"月","-")
		Set NarcosisSttDate=$tr(NarcosisSttDate,"日","")
		Set NarcosisEndDate=$tr(NarcosisEndDate,"年","-")
		Set NarcosisEndDate=$tr(NarcosisEndDate,"月","-")
		Set NarcosisEndDate=$tr(NarcosisEndDate,"日","")
		Set:NarcosisSttDate="-" NarcosisSttDate=""
		Set:NarcosisSttTime="-" NarcosisSttTime=""
		Set:NarcosisEndDate="-" NarcosisEndDate=""
		Set:NarcosisEndTime="-" NarcosisEndTime=""
		Set OperTmpStr = $c(2)_indOper_$c(2)_ICDID_$c(2)_TypeID_$c(2)_SttDate_$c(2)_SttTime_$c(2)_EndDate_$c(2)_EndTime
			_$c(2)_OperatorID_$c(2)_OperatorName_$c(2)_Assistant1ID_$c(2)_Assistant1Name_$c(2)_Assistant2ID_$c(2)_Assistant2Name
			_$c(2)_NarcosisTypeID_$c(2)_NarcosisDocID_$c(2)_NarcosisDocName_$c(2)_CutTypeID_$c(2)_HealingID
			_$c(2)_OperLevelID_$c(2)_MainOperID_$c(2)_TempData_$c(2)_AppendOper_$c(2)_AisOperID_$c(2)_NarcosisLevelID
			_$c(2)_OperSiteID_$c(2)_OperLocID_$c(2)_BackOperID_$c(2)_NNISLevelID_$c(2)_OperCatID_$c(2)_DurationTime
			_$c(2)_ClinicICDDesc_$c(2)_IsEmergencyID_$c(2)_IsMiniInvaID_$c(2)_IsChooseDateID
			_$c(2)_NarcosisSttDate_$c(2)_NarcosisSttTime_$c(2)_NarcosisEndDate_$c(2)_NarcosisEndTime_$c(2)_ClinicICD10
		
		Set:OperStr'="" OperStr = OperStr_$c(1)
		Set OperStr = OperStr_OperTmpStr
	}
	Set return = OperStr
	Quit return
}

/// 取首页基本信息
ClassMethod GetPatInfo()
{
	Set (return,PatInfo) = ""
	Set ItemCode = ""
	For {
		Set ItemCode = $o(^CT.IPMR.FP.AT.AdapterI("IndexCode",SourceID,ItemCode))
		Quit:ItemCode=""
		
		Set AdapterID = $o(^CT.IPMR.FP.AT.AdapterI("IndexCode",SourceID,ItemCode,0))
		Set objAdapter = ##class(CT.IPMR.FP.AT.Adapter).GetObjById(AdapterID)
		Continue:'$IsObject(objAdapter)
		
		Set Node = objAdapter.FANode
		Set Code = objAdapter.FACode
		Set Code = $tr(Code,".","")
		Set Value = ..GetValueByNode(Node,.documentList)
		Continue:Value=""
		Set:PatInfo'="" PatInfo = PatInfo_$c(2)
		Set PatInfo = PatInfo_Code_$c(1)_Value
	}
	Set return = PatInfo
	Quit return
}

/// 根据ItemCode查找节点
ClassMethod GetNodeByCode(aAdapterCode As %String, aSourceID As %String)
{
	New (aAdapterCode,aSourceID)
	Set return = ""
	Quit:(aAdapterCode="")||(aSourceID="")
	
	Set AdapterID = $o(^CT.IPMR.FP.AT.AdapterI("IndexCode",aSourceID," "_$zcvt(aAdapterCode,"U"),0))
	Set objAdapter = ##class(CT.IPMR.FP.AT.Adapter).GetObjById(AdapterID)
	Quit:'$IsObject(objAdapter) return
	
	Set return = objAdapter.FANode
	Quit return
}

/// Creator：     zhouyang
/// CreatDate：   2022-04-21
/// Description:  根据病案号-入院日期-住院次数获取就诊号
/// InPut:	   aMrNo：病案号
/// 			   aMrClass：病案分类
/// 			   aAdmDate：入院日期
/// 			   aAdmTimes：住院次数
/// Return：      失败：""，正常：就诊ID
/// w ##class(CT.IPMR.FPS.AdapterSrv).GetEpisodeIDByMrNo("100001","I","","1")
ClassMethod GetEpisodeIDByMrNo(aMrNo As %String, aMrClass As %String, aAdmDate As %String = "", aAdmTimes As %String = "") As %String
{
	New (aMrNo,aMrClass,aAdmDate,aAdmTimes)
	Set return=""
	Quit:(aMrNo="")||(aMrClass="") return
	
	Set aAdmDate = ##Class(MA.IPMR.ImedicalSrv).DateHtmlToLogical(aAdmDate)
	Quit:(aAdmDate="")&&(aAdmTimes="") return
	
	set xNoTypeID = ""
	For {
		set xNoTypeID = $o(^MA.IPMR.SS.MainI("IndexTypeNo",xNoTypeID))
		Quit:xNoTypeID=""
		Quit:return'=""
		
		set MrTypeID = +xNoTypeID
		set objMrType = ##class(CT.IPMR.BT.MrType).GetObjById(MrTypeID)
		Continue:'$isobject(objMrType)
		Continue:'$isobject(objMrType.BMMrClass)
		Continue:objMrType.BMMrClass.BMCode'=aMrClass
		
		Continue:'$d(^MA.IPMR.SS.MainI("IndexTypeNo",xNoTypeID," "_aMrNo))
		set MainID = $o(^MA.IPMR.SS.MainI("IndexTypeNo",xNoTypeID," "_aMrNo,""))
		Continue:MainID=""
		set objMain = ##class(MA.IPMR.SS.Main).GetObjById(MainID)
		Continue:'$isobject(objMain)
		continue:objMain.SMIsActive'=1

		set xVolID = ""
		For {
			set xVolID=$o(^MA.IPMR.SS.VolumeI("IndexMainDrAct",MainID,1,xVolID))
			Quit:xVolID=""
			Quit:return'=""
			
			Set AdmStr = ##Class(MA.IPMR.SSService.VolumeSrv).GetVolAdmStr(xVolID)
			Continue:AdmStr=""
			
			Set AdmDate = $lg(AdmStr,65)
			Set AdmDate = ##Class(MA.IPMR.ImedicalSrv).DateHtmlToLogical(AdmDate)
			Set AdmTimes = $lg(AdmStr,82)
			
			Continue:(AdmDate'="")&&(aAdmDate'="")&&(aAdmDate'=AdmDate)
			Continue:(AdmTimes'="")&&(aAdmTimes'="")&&(aAdmTimes'=AdmTimes)
			Set EpisodeID = $lg(AdmStr,27)
			Set return = EpisodeID
		}
	}
	Quit return
}

/// 根据%XML.XPATH.Document的节点取值
ClassMethod GetValueByNode(Node As %String, ByRef documentList As %XML.XPATH.Document) As %String
{
	New (Node,documentList)
	Set return = ""
	Quit:Node="" return
	
	Set sc = documentList.EvaluateExpression(Node,"text()",.result)
	Quit:($$$ERROR(sc)||(result.GetAt(1)="")) ""
	Set return = result.GetAt(1).Value
	Quit return
}

/// 根据ItemCode在XML中获取数据
/// w ##class(CT.IPMR.FPS.AdapterSrv).GetValByCode()
ClassMethod GetValByCode(aAdapterCode As %String, aSourceID As %String, ByRef documentList As %XML.XPATH.Document) As %String
{
	New (aAdapterCode,aSourceID,documentList)
	Set return  = ""
	Set Node = ##class(CT.IPMR.FPS.AdapterSrv).GetNodeByCode(aAdapterCode,aSourceID)
	Set Value =  ##class(CT.IPMR.FPS.AdapterSrv).GetValueByNode(Node,.documentList)
	Set return = Value
	Quit return
}

/// Creator：     zhouyang
/// CreatDate：   2022-04-21
/// Description:  若无首页数据，需产生新的MasterID数据
/// InPut:	   aVolID：病案卷ID
/// 			   aConfigID：编目配置ID
/// 			   aFPTypeID：首页类型
/// Return：      失败：<=0，正常：>0
/// w ##class(CT.IPMR.FPS.AdapterSrv).GetNewMasterID()
ClassMethod GetNewMasterID(aVolID As %String, aConfigID As %String, aFPTypeID As %String)
{
	New (aVolID,aConfigID,aFPTypeID)
	Set return=""
	Quit:(aVolID="")||(aConfigID="")||(aFPTypeID="") return
	
	Set inputStr=""
	Set inputStr=inputStr_$c(1)_aVolID
	Set inputStr=inputStr_$c(1)_aFPTypeID
	Set inputStr=inputStr_$c(1)_""
	Set inputStr=inputStr_$c(1)_""
	Set inputStr=inputStr_$c(1)_""
	Set inputStr=inputStr_$c(1)_""
	Set inputStr=inputStr_$c(1)_""
	Set inputStr=inputStr_$c(1)_aConfigID
	Set return=##class(MA.IPMR.FP.DataMaster).Update(inputStr,$c(1))
	Quit return
}

/// Creator：     zhouyang
/// CreatDate：   2022-04-21
/// Description:  导入适配项目
/// InPut:	   
/// Return：      失败：<=0，正常：>0
/// w ##class(CT.IPMR.FPS.AdapterSrv).ImportAdapter("^P01.001.01^P0100101^医疗付费方式^JCBA^")
ClassMethod ImportAdapter(aInputStr As %String, aSeparate As %String = "^") As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	
	Set SourceCode = $p(aInputStr,aSeparate,5)
	Set SourceID = $o(^CT.IPMR.FP.AT.SourceI("IndexCode"," "_$zcvt(SourceCode,"U"),0))
	Quit:SourceID="" return
	
	Set $p(aInputStr,aSeparate,5) = SourceID	
	Set AdapterID = ##class(CT.IPMR.FP.AT.Adapter).Update(aInputStr,aSeparate)
	Set return = AdapterID
	Quit return
}

}
