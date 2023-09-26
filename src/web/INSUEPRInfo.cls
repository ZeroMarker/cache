Class web.INSUEPRInfo Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property EpisodeID As %String(CONTENT = "就诊流水号");

Property HDSD0011006 As %String(CONTENT = "病案流水号");

Property HDSD0011140 As %String(CONTENT = "住院流水号");

Property HDSD0011118 As %String(CONTENT = "医疗机构名称");

Property HDSD0011119 As %String(CONTENT = "医疗机构组织机构代码");

Property HDSD0011117 As %String(CONTENT = "医疗费用支付方式代码");

Property HDSD0011139 As %String(CONTENT = "住院次数");

Property HDSD0011053 As %String(CONTENT = "居民健康卡号");

Property HDSD00111181 As %String(CONTENT = "医保卡号");

Property HDSD00110061 As %String(CONTENT = "病案号");

Property HDSD0011110 As %String(CONTENT = "患者姓名");

Property HDSD0011109 As %String(CONTENT = "性别代码");

Property HDSD0011014 As %String(CONTENT = "出生日期");

Property HDSD0011079 As %String(CONTENT = "年龄(岁)");

Property HDSD0011036 As %String(CONTENT = "国籍代码");

Property HDSD0011080 As %String(CONTENT = "月龄(月)");

Property HDSD0011107 As %String(CONTENT = "新生儿出生体重(g)");

Property HDSD0011108 As %String(CONTENT = "新生儿入院体重(g)");

Property HDSD0011011 As %String(CONTENT = "出生地_省(区、市)");

Property HDSD0011012 As %String(CONTENT = "出生地_市");

Property HDSD0011013 As %String(CONTENT = "出生地_县");

Property HDSD0011051 As %String(CONTENT = "籍贯_省(区、市)");

Property HDSD0011052 As %String(CONTENT = "籍贯_市");

Property HDSD0011077 As %String(CONTENT = "民族编码");

Property HDSD0011049 As %String(CONTENT = "患者身份证件类别代码");

Property HDSD0011048 As %String(CONTENT = "患者身份证件号码");

Property HDSD0011125 As %String(CONTENT = "职业类别代码");

Property HDSD0011050 As %String(CONTENT = "婚姻状况代码");

Property HDSD0011102 As %String(CONTENT = "现住址 _ 省 (区、市)");

Property HDSD0011103 As %String(CONTENT = "现住址-市（地区、州）");

Property HDSD0011104 As %String(CONTENT = "现住址 - 县（区）");

Property HDSD0011105 As %String(CONTENT = "现住址 - 乡（镇、街道办事处）");

Property HDSD0011100 As %String(CONTENT = "现住址 - 村（街、路、弄等）");

Property HDSD0011101 As %String(CONTENT = "现住址-门牌号码");

Property HDSD0011106 As %String(CONTENT = "现住址_邮政编码");

Property HDSD0011026 As %String(CONTENT = "患者电话号码");

Property HDSD0011043 As %String(CONTENT = "户口地址-省（自治区、直辖市）");

Property HDSD0011044 As %String(CONTENT = "户口地址-市（地区、州）");

Property HDSD0011045 As %String(CONTENT = "户口地址-县（区）");

Property HDSD0011046 As %String(CONTENT = "户口地址-乡（镇、街道办事处）");

Property HDSD0011041 As %String(CONTENT = "户口地址-村（街、路、弄等）");

Property HDSD0011042 As %String(CONTENT = "户口地址-门牌号码");

Property HDSD0011047 As %String(CONTENT = "户口地址_邮政编码");

Property HDSD0011035 As %String(CONTENT = "工作单位名称");

Property HDSD0011029 As %String(CONTENT = "工作单位地址_省(自治 区、直辖市)");

Property HDSD0011030 As %String(CONTENT = "工作单位地址_市(地区、州)");

Property HDSD0011031 As %String(CONTENT = "工作单位地址_县(区)");

Property HDSD0011032 As %String(CONTENT = "工作单位地址_乡(镇、街道办事处)");

Property HDSD0011027 As %String(CONTENT = "工作单位地址_村(街、路、弄等)");

Property HDSD0011028 As %String(CONTENT = "工作单位地址_门牌号码");

Property HDSD0011033 As %String(CONTENT = "工作单位地址_邮政编码");

Property HDSD0011034 As %String(CONTENT = "工作单位电话号码");

Property HDSD0011065 As %String(CONTENT = "联系人姓名");

Property HDSD0011066 As %String(CONTENT = "联系人与患者的关系代码");

Property HDSD0011060 As %String(CONTENT = "联系人地址_ 省(自治区、直辖市)");

Property HDSD0011061 As %String(CONTENT = "联系人地址_ 市(地区、州)");

Property HDSD0011062 As %String(CONTENT = "联系人地址_ 县(区)");

Property HDSD0011063 As %String(CONTENT = "联系人地址_ 乡(镇、街 道办事处)");

Property HDSD0011058 As %String(CONTENT = "联系人地址_ 村(街、路、弄等)");

Property HDSD0011059 As %String(CONTENT = "联系人地址_门牌号码");

Property HDSD0011064 As %String(CONTENT = "联系人电话号码");

Property HDSD0011086 As %String(CONTENT = "入院途径");

Property HDSD0011085 As %String(CONTENT = "入院日期时间");

Property HDSD00111004 As %String(CONTENT = "入院科室代码");

Property HDSD0011084 As %String(CONTENT = "入院科室名称");

Property HDSD0011083 As %String(CONTENT = "入院病房");

Property HDSD0011144C As %String(CONTENT = "转科科室代码");

Property HDSD0011144 As %String(CONTENT = "转科科室名称");

Property HDSD0011019 As %String(CONTENT = "出院日期时间");

Property HDSD00111005 As %String(CONTENT = "出院科室代码");

Property HDSD0011018 As %String(CONTENT = "出院科室名称");

Property HDSD0011017 As %String(CONTENT = "出院病房");

Property HDSD0011087 As %String(CONTENT = "实际住院天数");

Property HDSD0012084 As %String(CONTENT = "门（急）诊诊断（中医诊断）病名编码");

Property HDSD0012085 As %String(CONTENT = "门（急）诊诊断（中医诊断）名称");

Property HDSD0012087 As %String(CONTENT = "门（急）诊诊断（中医证候）证候编码");

Property HDSD0012086 As %String(CONTENT = "门（急）诊诊断（中医证候）名称");

Property HDSD0011075 As %String(CONTENT = "门（急）诊诊断（西医诊断）疾病编码");

Property HDSD0011076 As %String(CONTENT = "门（急）诊诊断（西医诊断）名称");

Property HDSD00121016 As %String(CONTENT = "实施临床路径标志代码");

Property HDSD00122001 As %String(CONTENT = "使用医疗机构中药制剂标志");

Property HDSD00122002 As %String(CONTENT = "使用中医诊疗设备标志");

Property HDSD00122003 As %String(CONTENT = "使用中医技术标志");

Property HDSD00122004 As %String(CONTENT = "辨证施护标志");

Property HDSD0011097 As %String(CONTENT = "损伤中毒的外部原因编码");

Property HDSD0011010 As %String(CONTENT = "病理诊断");

Property HDSD0011009 As %String(CONTENT = "病理诊断编码");

Property HDSD0011008 As %String(CONTENT = "病理号");

Property HDSD0011116 As %String(CONTENT = "药物过敏标志");

Property HDSD0011037 As %String(CONTENT = "过敏药物");

Property HDSD0011095 As %String(CONTENT = "死亡患者尸检标志");

Property HDSD0011003 As %String(CONTENT = "ABO 血型代码");

Property HDSD0011004 As %String(CONTENT = "Rh(D) 血型代码");

Property HDSD0011056 As %String(CONTENT = "科主任姓名");

Property HDSD0011137 As %String(CONTENT = "主任(副主任)医师姓名");

Property HDSD0011577 As %String(CONTENT = "主治医师编号");

Property HDSD0011138 As %String(CONTENT = "主治医师姓名");

Property HDSD0011141 As %String(CONTENT = "住院医师姓名");

Property HDSD0011120 As %String(CONTENT = "责任护士姓名");

Property HDSD0011054 As %String(CONTENT = "进修医师姓名");

Property HDSD0011088 As %String(CONTENT = "实习医师姓名");

Property HDSD0011005 As %String(CONTENT = "病案编码员姓名");

Property HDSD0011007 As %String(CONTENT = "病案质量");

Property HDSD0011128 As %String(CONTENT = "质控医师姓名");

Property HDSD0011126 As %String(CONTENT = "质控护士姓名");

Property HDSD0011127 As %String(CONTENT = "质控日期");

Property HDSD0011603 As %String(CONTENT = "离院方式");

Property HDSD00111001 As %String(CONTENT = "拟接收医疗机构名称");

Property HDSD0011015 As %String(CONTENT = "出院 31 天内再住院标志");

Property HDSD0011016 As %String(CONTENT = "出院 31 天内再住院目的");

Property HDSD0011070 As %String(CONTENT = "颅脑损伤患者入院前昏迷时间-d");

Property HDSD0011071 As %String(CONTENT = "颅脑损伤患者入院前昏迷时间-h");

Property HDSD0011072 As %String(CONTENT = "颅脑损伤患者入院前昏迷时间-min");

Property HDSD0011067 As %String(CONTENT = "颅脑损伤患者入院后昏迷时间-d");

Property HDSD0011068 As %String(CONTENT = "颅脑损伤患者入院后昏迷时间-h");

Property HDSD0011069 As %String(CONTENT = "颅脑损伤患者入院后昏迷时间-min");

Property HDSD0011805 As %String(CONTENT = "出院情况(病情转归)");

Property HDSD0011964 As %String(CONTENT = "诊断符合情况-门诊与住院");

Property HDSD0011963 As %String(CONTENT = "诊断符合情况-入院与出院");

Property HDSD0011777 As %String(CONTENT = "诊断符合情况-术前与术后");

Property HDSD0011965 As %String(CONTENT = "诊断符合情况-临床与病理");

Property HDSD0011966 As %String(CONTENT = "诊断符合情况-放射与病理");

Property HDSD0011569 As %String(CONTENT = "抢救次数");

Property HDSD0011570 As %String(CONTENT = "抢救成功次数");

Property HDSD0011142 As %String(CONTENT = "住院总费用(元)");

Property HDSD0011143 As %String(CONTENT = "住院总费用_自付金额(元)");

Property HDSD0011147 As %String(CONTENT = "综合医疗服务费_一般医疗服务费");

Property HDSD0011148 As %String(CONTENT = "综合医疗服务费_一般医疗服务费");

Property HDSD0012175 As %String(CONTENT = "一般医疗服务费_中医辨证论治费");

Property HDSD0012176 As %String(CONTENT = "一般医疗服务费_中医辨证论治会诊费");

Property HDSD0011145 As %String(CONTENT = "综合医疗服务费_护理费");

Property HDSD0011146 As %String(CONTENT = "综合医疗服务费_其他费用");

Property HDSD0011121 As %String(CONTENT = "诊断_病理诊断费");

Property HDSD0011123 As %String(CONTENT = "诊断_实验室诊断费");

Property HDSD0011124 As %String(CONTENT = "诊断_影像学诊断费");

Property HDSD0011122 As %String(CONTENT = "诊断_临床诊断项目费");

Property HDSD0011129 As %String(CONTENT = "治疗_非手术治疗项目费");

Property HDSD0011130 As %String(CONTENT = "治疗_非手术治疗项目费_临床物理治疗费");

Property HDSD0011131 As %String(CONTENT = "治疗_手术治疗费");

Property HDSD0011132 As %String(CONTENT = "治疗_手术治疗费_麻醉费");

Property HDSD0011133 As %String(CONTENT = "治疗_手术治疗费_手术费");

Property HDSD0011055 As %String(CONTENT = "康复类-康复费");

Property HDSD0012156 As %String(CONTENT = "中医类_中医诊断费");

Property HDSD0012157 As %String(CONTENT = "中医类_中医治疗费");

Property HDSD0012163 As %String(CONTENT = "中医类_中医治疗费_中医外治费");

Property HDSD0012160 As %String(CONTENT = "中医类_中医治疗费_中医骨伤费");

Property HDSD0012158 As %String(CONTENT = "中医类_中医治疗费_针刺与灸法费");

Property HDSD0012162 As %String(CONTENT = "中医类_中医治疗费_中医推拿治疗费");

Property HDSD0012159 As %String(CONTENT = "中医类_中医治疗费_中医肛肠治疗费");

Property HDSD0012161 As %String(CONTENT = "中医类_中医治疗费_中医特殊治疗费");

Property HDSD0012153 As %String(CONTENT = "中医类_中医其他费");

Property HDSD0012155 As %String(CONTENT = "中医类_中医其他费_中医特殊调配加工费");

Property HDSD0012154 As %String(CONTENT = "中医类_中医其他费_辨证施膳费");

Property HDSD0011098 As %String(CONTENT = "西药类-西药费");

Property HDSD0011099 As %String(CONTENT = "西药类-西药费_抗菌药物费用");

Property HDSD0011135 As %String(CONTENT = "中药类_中成药费");

Property HDSD0012152 As %String(CONTENT = "中成药费-医疗机构中药制剂费");

Property HDSD0011134 As %String(CONTENT = "中药类_中草药费");

Property HDSD0011115 As %String(CONTENT = "血液和血液制品类-血费");

Property HDSD0011111 As %String(CONTENT = "血液和血液制品类-白蛋白类制品费");

Property HDSD0011113 As %String(CONTENT = "血液和血液制品类-球蛋白类制品费");

Property HDSD0011112 As %String(CONTENT = "血液和血液制品类-凝血因子类制品费");

Property HDSD0011114 As %String(CONTENT = "血液和血液制品类-细胞因子类制品费");

Property HDSD0011038 As %String(CONTENT = "耗材类-检查用一次性医用材料费");

Property HDSD0011040 As %String(CONTENT = "耗材类-治疗用一次性医用材料费");

Property HDSD0011039 As %String(CONTENT = "耗材类-治疗用一次性医用材料费");

Property HDSD0011081 As %String(CONTENT = "其他类-其他费");

Property BY001 As %String(CONTENT = "体重（kg）");

Property BY002 As %String(CONTENT = "备用 2");

Property BY003 As %String(CONTENT = "备用 3");

Property BY004 As %String(CONTENT = "备用 4");

Property BY005 As %String(CONTENT = "备用 5");

/*
Property HDSD001 As %String(CONTENT = "就诊号");

Property HDSD002 As %String(CONTENT = "患者姓名");

Property HDSD003 As %String(CONTENT = "病案首页类别");

Property HDSD004 As %String(CONTENT = "医疗付费方式");

Property HDSD005 As %String(CONTENT = "组织机构代码");

Property HDSD006 As %String(CONTENT = "就诊流水号");

Property HDSD007 As %String(CONTENT = "病案流水号");

Property HDSD008 As %String(CONTENT = "住院流水号");

Property HDSD009 As %String(CONTENT = "医疗机构名称");

Property HDSD010 As %String(CONTENT = "医疗机构组织机构代码");

Property HDSD011 As %String(CONTENT = "医疗费用支付方式代码");

Property HDSD012 As %String(CONTENT = "ICD版本");

Property HDSD013 As %String(CONTENT = "住院次数");

Property HDSD014 As %String(CONTENT = "工伤事故编号");

Property HDSD015 As %String(CONTENT = "居民健康卡号");

Property HDSD016 As %String(CONTENT = "个人医保编号");

Property HDSD017 As %String(CONTENT = "GD病人来源");

Property HDSD018 As %String(CONTENT = "医保卡号");

Property HDSD019 As %String(CONTENT = "病案号");

Property HDSD020 As %String(CONTENT = "患者姓名");

Property HDSD021 As %String(CONTENT = "性别代码");

Property HDSD022 As %String(CONTENT = "出生日期");

Property HDSD023 As %String(CONTENT = "年龄(岁)");

Property HDSD024 As %String(CONTENT = "国籍代码");

Property HDSD025 As %String(CONTENT = "月龄(月)");

Property HDSD026 As %String(CONTENT = "新生儿出生体重(g)");

Property HDSD027 As %String(CONTENT = "新生儿入院体重(g)");

Property HDSD028 As %String(CONTENT = "出生地_省(区、市)");

Property HDSD029 As %String(CONTENT = "出生地_市");

Property HDSD030 As %String(CONTENT = "出生地_县");

Property HDSD031 As %String(CONTENT = "籍贯_省(区、市)");

Property HDSD032 As %String(CONTENT = "籍贯_市");

Property HDSD033 As %String(CONTENT = "民族编码");

Property HDSD034 As %String(CONTENT = "患者身份证件类别代码");

Property HDSD035 As %String(CONTENT = "患者身份证件号码");

Property HDSD036 As %String(CONTENT = "职业类别代码");

Property HDSD037 As %String(CONTENT = "婚姻状况代码");

Property HDSD038 As %String(CONTENT = "现 住 址 _ 省(区、市)");

Property HDSD039 As %String(CONTENT = "现住址-市（地区、州）");

Property HDSD040 As %String(CONTENT = "现 住 址 - 县（区）");

Property HDSD041 As %String(CONTENT = "现 住 址 - 乡（镇、街道办事处）");

Property HDSD042 As %String(CONTENT = "现 住 址 - 村（街、路、弄等）");

Property HDSD043 As %String(CONTENT = "现住址- 门牌号码");

Property HDSD044 As %String(CONTENT = "现住址_ 邮政编码");

Property HDSD045 As %String(CONTENT = "患者电话号码");

Property HDSD046 As %String(CONTENT = "户口地址- 省（自治区、直辖市）");

Property HDSD047 As %String(CONTENT = "户口地址- 市（地区、州）");

Property HDSD048 As %String(CONTENT = "户口地址- 县（区）");

Property HDSD049 As %String(CONTENT = "户口地址- 乡（镇、街道办事处）");

Property HDSD050 As %String(CONTENT = "户口地址- 村（街、路、弄等）");

Property HDSD051 As %String(CONTENT = "户口地址- 门牌号码");

Property HDSD052 As %String(CONTENT = "户口地址_ 邮政编码");

Property HDSD053 As %String(CONTENT = "工作单位名称");

Property HDSD054 As %String(CONTENT = "工作单位地址_省(自治 区、直辖市)");

Property HDSD055 As %String(CONTENT = "工作单位地址_市(地区、州)");

Property HDSD056 As %String(CONTENT = "工作单位地址_县(区)");

Property HDSD057 As %String(CONTENT = "工作单位地址_乡(镇、街道办事处)");

Property HDSD058 As %String(CONTENT = "工作单位地址_村(街、路、弄等)");

Property HDSD059 As %String(CONTENT = "工作单位地址_门牌号码");

Property HDSD060 As %String(CONTENT = "工作单位地址_邮政编码");

Property HDSD061 As %String(CONTENT = "工作单位电话号码");

Property HDSD062 As %String(CONTENT = "联系人姓名");

Property HDSD063 As %String(CONTENT = "联系人与患者的关系代码");

Property HDSD064 As %String(CONTENT = "联系人地址_省(自治区、直辖市)");

Property HDSD065 As %String(CONTENT = "联系人地址_市(地区、州)");

Property HDSD066 As %String(CONTENT = "联系人地址_县(区)");

Property HDSD067 As %String(CONTENT = "联系人地址_乡(镇、街道办事处)");

Property HDSD068 As %String(CONTENT = "联系人地址村(街、路、弄等)");

Property HDSD069 As %String(CONTENT = "联系人地址门牌号码");

Property HDSD070 As %String(CONTENT = "联系人电话号码");

Property HDSD071 As %String(CONTENT = "经办人");

Property HDSD072 As %String(CONTENT = "经办时间");

Property HDSD073 As %String(CONTENT = "所属统筹区");

Property HDSD074 As %String(CONTENT = "入院科室代码");

Property HDSD075 As %String(CONTENT = "入院科室名称");

Property HDSD076 As %String(CONTENT = "入院时间");

Property HDSD077 As %String(CONTENT = "入院病房");

Property HDSD078 As %String(CONTENT = "入院途径编号");

Property HDSD079 As %String(CONTENT = "入院途径");

Property HDSD080 As %String(CONTENT = "转科科室代码");

Property HDSD081 As %String(CONTENT = "转科科室名称");

Property HDSD082 As %String(CONTENT = "出院日期时间");

Property HDSD083 As %String(CONTENT = "出院科室代码");

Property HDSD084 As %String(CONTENT = "出院科室名称");

Property HDSD085 As %String(CONTENT = "出院病房");

Property HDSD086 As %String(CONTENT = "实际住院天数");

Property HDSD087 As %String(CONTENT = "三级护理天数");

Property HDSD088 As %String(CONTENT = "二级护理天数");

Property HDSD089 As %String(CONTENT = "一级护理天数");

Property HDSD090 As %String(CONTENT = "特级护理");

Property HDSD091 As %String(CONTENT = "日常生活能力评定量表得分(入院)");

Property HDSD092 As %String(CONTENT = "日常生活能力评定量表得分（出院）");

Property HDSD093 As %String(CONTENT = "门（急）诊诊断编码");

Property HDSD094 As %String(CONTENT = "门（急）诊诊断疾病名");

Property HDSD095 As %String(CONTENT = "门、急诊医生编号");

Property HDSD096 As %String(CONTENT = "门、急诊医生");

Property HDSD097 As %String(CONTENT = "门诊 中医(主病)");

Property HDSD098 As %String(CONTENT = "门诊 中医(主病) 疾病编码");

Property HDSD099 As %String(CONTENT = "临床路径病例编号");

Property HDSD100 As %String(CONTENT = "临床路径病例");

Property HDSD101 As %String(CONTENT = "门（急）诊诊断（中医诊断）病名编码");

Property HDSD102 As %String(CONTENT = "门（急）诊诊断（中医诊断）名称");

Property HDSD103 As %String(CONTENT = "门（急）诊诊断（中医证候）证候编码");

Property HDSD104 As %String(CONTENT = "门（急）诊诊断（中医证候）名称");

Property HDSD105 As %String(CONTENT = "门（急）诊诊断（西医诊断）疾病编码");

Property HDSD106 As %String(CONTENT = "门（急）诊诊断（西医诊断）名称");

Property HDSD107 As %String(CONTENT = "实施临床路径标志代码");

Property HDSD108 As %String(CONTENT = "使用医疗机构中药制剂标志");

Property HDSD109 As %String(CONTENT = "使用中医诊疗设备标志");

Property HDSD110 As %String(CONTENT = "使用中医技术标志");

Property HDSD111 As %String(CONTENT = "辨证施护标志");

Property HDSD112 As %String(CONTENT = "损伤中毒的外部原因编码");

Property HDSD113 As %String(CONTENT = "病理诊断");

Property HDSD114 As %String(CONTENT = "病理诊断编码");

Property HDSD115 As %String(CONTENT = "病理号");

Property HDSD116 As %String(CONTENT = "是否药物过敏编号");

Property HDSD117 As %String(CONTENT = "药物过敏标志");

Property HDSD118 As %String(CONTENT = "过敏药物");

Property HDSD119 As %String(CONTENT = "是否尸检编号");

Property HDSD120 As %String(CONTENT = "死亡患者尸检标志");

Property HDSD121 As %String(CONTENT = "血型");

Property HDSD122 As %String(CONTENT = "ABO 血型代码");

Property HDSD123 As %String(CONTENT = "RH");

Property HDSD124 As %String(CONTENT = "Rh(D) 血型代码");

Property HDSD125 As %String(CONTENT = "科主任编号");

Property HDSD126 As %String(CONTENT = "科主任姓名");

Property HDSD127 As %String(CONTENT = "主任(副主任)医师姓名");

Property HDSD128 As %String(CONTENT = "主治医师编号");

Property HDSD129 As %String(CONTENT = "主治医师姓名");

Property HDSD130 As %String(CONTENT = "住院医生编号");

Property HDSD131 As %String(CONTENT = "进修医师编号");

Property HDSD132 As %String(CONTENT = "住院医师姓名");

Property HDSD133 As %String(CONTENT = "责任护士编号");

Property HDSD134 As %String(CONTENT = "责任护士姓名");

Property HDSD135 As %String(CONTENT = "进修医师姓名");

Property HDSD136 As %String(CONTENT = "实习医师编号");

Property HDSD137 As %String(CONTENT = "实习医师姓名");

Property HDSD138 As %String(CONTENT = "编码员编号");

Property HDSD139 As %String(CONTENT = "病案编码员姓名");

Property HDSD140 As %String(CONTENT = "病理号");

Property HDSD141 As %String(CONTENT = "病理疾病编码");

Property HDSD142 As %String(CONTENT = "病案质量编号");

Property HDSD143 As %String(CONTENT = "质控医师编号");

Property HDSD144 As %String(CONTENT = "病案质量");

Property HDSD145 As %String(CONTENT = "质控护士编号");

Property HDSD146 As %String(CONTENT = "质控医师姓名");

Property HDSD147 As %String(CONTENT = "质控护士姓名");

Property HDSD148 As %String(CONTENT = "质控日期");

Property HDSD149 As %String(CONTENT = "离院方式编号");

Property HDSD150 As %String(CONTENT = "离院方式");

Property HDSD151 As %String(CONTENT = "医嘱转院接收医疗机构名称");

Property HDSD152 As %String(CONTENT = "医嘱转社区卫生机构/乡镇卫生院接收医疗机构名称");

Property HDSD153 As %String(CONTENT = "首次转科统一科号");

Property HDSD154 As %String(CONTENT = "首次转科科别");

Property HDSD155 As %String(CONTENT = "首次转科日期");

Property HDSD156 As %String(CONTENT = "首次转科时间");

Property HDSD157 As %String(CONTENT = "疾病分型编号");

Property HDSD158 As %String(CONTENT = "疾病分型（病例分型）");

Property HDSD159 As %String(CONTENT = "拟接收医疗机构名称");

Property HDSD160 As %String(CONTENT = "是否有出院31天内再住院计划编号");

Property HDSD161 As %String(CONTENT = "是否有出院31天内再住院计划");

Property HDSD162 As %String(CONTENT = "出院 31 天内再住院标志");

Property HDSD163 As %String(CONTENT = "出院 31 天内再住院目的");

Property HDSD164 As %String(CONTENT = "入住重症监护室时间");

Property HDSD165 As %String(CONTENT = "呼吸机使用时间");

Property HDSD166 As %String(CONTENT = "进监护病房时间1");

Property HDSD167 As %String(CONTENT = "出监护病房时间1");

Property HDSD168 As %String(CONTENT = "进监护病房时间2");

Property HDSD169 As %String(CONTENT = "出监护病房时间2");

Property HDSD170 As %String(CONTENT = "进监护病房时间3");

Property HDSD171 As %String(CONTENT = "出监护病房时间3");

Property HDSD172 As %String(CONTENT = "进监护病房时间4");

Property HDSD173 As %String(CONTENT = "出监护病房时间4");

Property HDSD174 As %String(CONTENT = "进监护病房时间5");

Property HDSD175 As %String(CONTENT = "出监护病房时间5");

Property HDSD176 As %String(CONTENT = "颅脑损伤患者入院前昏迷时间-d");

Property HDSD177 As %String(CONTENT = "颅脑损伤患者入院前昏迷时间-h");

Property HDSD178 As %String(CONTENT = "颅脑损伤患者入院前昏迷时间-min");

Property HDSD179 As %String(CONTENT = "颅脑损伤患者入院后昏迷时间-d");

Property HDSD180 As %String(CONTENT = "颅脑损伤患者入院后昏迷时间-h");

Property HDSD181 As %String(CONTENT = "颅脑损伤患者入院后昏迷时间-min");

Property HDSD182 As %String(CONTENT = "使用医疗机构中药制剂");

Property HDSD183 As %String(CONTENT = "使用中医诊疗设备");

Property HDSD184 As %String(CONTENT = "使用中医诊疗技术");

Property HDSD185 As %String(CONTENT = "辩证施护");

Property HDSD186 As %String(CONTENT = "主病");

Property HDSD187 As %String(CONTENT = "主证");

Property HDSD188 As %String(CONTENT = "主证1出院中医诊断");

Property HDSD189 As %String(CONTENT = "主证1疾病编码");

Property HDSD190 As %String(CONTENT = "主证1入院病情");

Property HDSD191 As %String(CONTENT = "主证2出院中医诊断");

Property HDSD192 As %String(CONTENT = "主证2疾病编码");

Property HDSD193 As %String(CONTENT = "主证2入院病情");

Property HDSD194 As %String(CONTENT = "主证3出院中医诊断");

Property HDSD195 As %String(CONTENT = "主证3疾病编码");

Property HDSD196 As %String(CONTENT = "主证3入院病情");

Property HDSD197 As %String(CONTENT = "主证4中医诊断");

Property HDSD198 As %String(CONTENT = "主证4疾病编码");

Property HDSD199 As %String(CONTENT = "主证4入院病情");

Property HDSD200 As %String(CONTENT = "主证5中医诊断");

Property HDSD201 As %String(CONTENT = "主证5疾病编码");

Property HDSD202 As %String(CONTENT = "主证入院病情");

Property HDSD203 As %String(CONTENT = "主证6出院中医诊断");

Property HDSD204 As %String(CONTENT = "主证6疾病编码");

Property HDSD205 As %String(CONTENT = "主证6入院病情");

Property HDSD206 As %String(CONTENT = "主证7出院中医诊断");

Property HDSD207 As %String(CONTENT = "主证7疾病编码");

Property HDSD208 As %String(CONTENT = "主证7入院病情");

Property HDSD209 As %String(CONTENT = "质控编码员");

Property HDSD210 As %String(CONTENT = "实施临床路径");

Property HDSD211 As %String(CONTENT = "出院情况( 病情转归)");

Property HDSD212 As %String(CONTENT = "诊断符合情况-门诊与住院");

Property HDSD213 As %String(CONTENT = "诊断符合情况-入院与出院");

Property HDSD214 As %String(CONTENT = "诊断符合情况-术前与术后");

Property HDSD215 As %String(CONTENT = "诊断符合情况-临床与病理");

Property HDSD216 As %String(CONTENT = "诊断符合情况-放射与病理");

Property HDSD217 As %String(CONTENT = "抢救次数");

Property HDSD218 As %String(CONTENT = "抢救成功次数");

Property HDSD219 As %String(CONTENT = "付款方式编号");

Property HDSD220 As %String(CONTENT = "付款方式");

Property HDSD221 As %String(CONTENT = "住院总费用(元)");

Property HDSD222 As %String(CONTENT = "住院总费用自付金额(元)");

Property HDSD223 As %String(CONTENT = "综合医疗服务费、 一般医疗服务费");

Property HDSD224 As %String(CONTENT = "综合医疗服务费、一般治疗操作费");

Property HDSD225 As %String(CONTENT = "一般医疗服务费_中医辨证论治费");

Property HDSD226 As %String(CONTENT = "一般医疗服务费_中医辨证论治会诊费");

Property HDSD227 As %String(CONTENT = "综合医疗服务费_护理费");

Property HDSD228 As %String(CONTENT = "综合医疗服务费_其他费用");

Property HDSD229 As %String(CONTENT = "诊断_ 病理诊断费");

Property HDSD230 As %String(CONTENT = "诊断_ 实验室诊断费");

Property HDSD231 As %String(CONTENT = "诊断_ 影像学诊断费");

Property HDSD232 As %String(CONTENT = "诊断_ 临床诊断项目费");

Property HDSD233 As %String(CONTENT = "治疗_ 非手术治疗项目费");

Property HDSD234 As %String(CONTENT = "治疗_ 非手术治疗项目费_临床物理治疗费");

Property HDSD235 As %String(CONTENT = "治疗_ 手术治疗费");

Property HDSD236 As %String(CONTENT = "治疗_ 手术治疗费_麻醉费");

Property HDSD237 As %String(CONTENT = "治疗_ 手术治疗费_手术费");

Property HDSD238 As %String(CONTENT = "康复类- 康复费");

Property HDSD239 As %String(CONTENT = "中医类_ 中医诊断费");

Property HDSD240 As %String(CONTENT = "中成药费");

Property HDSD241 As %String(CONTENT = "中草药费");

Property HDSD242 As %String(CONTENT = "中医诊断");

Property HDSD243 As %String(CONTENT = "中医类_ 中医治疗费");

Property HDSD244 As %String(CONTENT = "中医类_中医治疗费_中医外治费");

Property HDSD245 As %String(CONTENT = "中医类_中医治疗费_中医骨伤费");

Property HDSD246 As %String(CONTENT = "中医类_中医治疗费_针刺与灸法费");

Property HDSD247 As %String(CONTENT = "中医类_中医治疗费_中医推拿治疗费");

Property HDSD248 As %String(CONTENT = "中医类_中医治疗费_中医肛肠治疗费");

Property HDSD249 As %String(CONTENT = "中医类_ 中医治疗费_ 中医特殊治疗费");

Property HDSD250 As %String(CONTENT = "中医类_ 中医其他费");

Property HDSD251 As %String(CONTENT = "中医类_ 中医其他费_ 中医特殊调配加工费");

Property HDSD252 As %String(CONTENT = "中医类_中医其他费_辨证施膳费");

Property HDSD253 As %String(CONTENT = "中药类：中成药费 其中协议机构中药制剂费（中医）");

Property HDSD254 As %String(CONTENT = "西药类- 西药费");

Property HDSD255 As %String(CONTENT = "西药类- 西药费_ 抗菌药物费用");

Property HDSD256 As %String(CONTENT = "中药类_ 中成药费");

Property HDSD257 As %String(CONTENT = "中成药费- 医疗机构中药制剂费");

Property HDSD258 As %String(CONTENT = "中药类_ 中草药费");

Property HDSD259 As %String(CONTENT = "血液和血液制品类-血费");

Property HDSD260 As %String(CONTENT = "血液和血液制品类-白蛋白类制品费");

Property HDSD261 As %String(CONTENT = "血液和血液制品类-球蛋白类制品费");

Property HDSD262 As %String(CONTENT = "血液和血液制品类- 凝血因子类制品费");

Property HDSD263 As %String(CONTENT = "血液和血液制品类- 细胞因子类制品费");

Property HDSD264 As %String(CONTENT = "耗材类- 检查用一次性医用材料费");

Property HDSD265 As %String(CONTENT = "耗材类- 治疗用一次性医用材料费");

Property HDSD266 As %String(CONTENT = "耗材类- 手术用一次性医用材料费");

Property HDSD267 As %String(CONTENT = "其他类- 其他费");

Property HDSD268 As %String(CONTENT = "体重（kg）");

Property HDSD269 As %String(CONTENT = "备用 2");

Property HDSD270 As %String(CONTENT = "备用 3");

Property HDSD271 As %String(CONTENT = "备用 4");

Property HDSD272 As %String(CONTENT = "备用 5");
*/
}
