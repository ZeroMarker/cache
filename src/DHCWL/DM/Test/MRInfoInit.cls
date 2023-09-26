Import DHCWL.DM.T

Class DHCWL.DM.Test.MRInfoInit Extends %RegisteredObject
{

// d ##class(DHCWL.DM.Test.MRInfoInit).NewProject()

ClassMethod NewProject()
{
	d ##class(DHCWL.DM.T.TypeConfig).TestData()
	d ##class(DHCWL.DM.T.Namespace).TestData()
	d ##class(DHCWL.DM.T.DataType).TestData()
	d ##class(DataSourceConfig).TestData()
  //定义系统中使用的键值对类型的数据
  d ##class(DHCWL.DM.T.KeyValueConfig).TestData()
  s type=##class(TypeConfig).GetByPath("DATASOURCE:JDBC")
  s obj=##class(DataSourceConfig).GetByPath("JDBC:DHCAPP_LOCAL")
  if obj=""{
	  s obj=##class(DataSourceConfig).%New()
		s obj.Type=type
		s obj.Code="DHCAPP_LOCAL"
		s obj.Name="CachéDHCAPP_LOCAL连接配置"
		s obj.Description="连接localhostCaché数据库的DHC-APP命名空间"
		s obj.IsActived="N"
		d obj.%Save()
		s id=obj.%Id()
		q:id=""
		w id,","
		w !,"KVRowId:"
		s master="DataSourceConfig-"_id
		&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'url','jdbc:Cache://localhost:1972/dhc-app'))
		w %ROWID,","
		&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'user','_SYSTEM'))
		w %ROWID,","
		&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'password','SYS'))
		w %ROWID,","
		&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'driver','com.intersys.jdbc.CacheDriver'))
		w %ROWID,!
		&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'schema','sqluser'))
		w %ROWID,!
  }
}

// d ##class(DHCWL.DM.Test.MRInfoInit).InitMeta()

ClassMethod InitMeta()
{
	
	s type=##class(TypeConfig).GetByPath("META:FACT")
	s ns=##class(Namespace).MetaNamespace("/")
	s ds=##class(DataSourceConfig).GetByPath("JDBC:DHCAPP_LOCAL") //DHCAPP_LOCAL
	s obj=##class(MetaTableBase).GetByPath("/DHCMRInfo.mf")
	if obj=""{
		s obj=##class(MetaTableBase).%New()
		s obj.Type=type
		s obj.Namespace=ns
		s obj.Code="DHCMRInfo"
		s obj.Name="病案"
		s obj.Description="综合查询病案数据仓库，包括405个字段"
		s obj.DSConfig=ds
		s obj.Creator="lhh"
		s obj.CreatedDate=+$h
		d obj.%Save()
		w obj.%Id(),","
		s id=obj.%Id()
		q:id=""
		s master="MetaTableBase-MDS-"_obj.%Id()
		&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'table','DHCMRInfo'))
		w %ROWID,","
		;&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'catalog',''))
		;w %ROWID,","
		&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'schema','SQLUSER'))
		w %ROWID,","
		s status=##class(DHCWL.DM.I.Manage).MetaInfoBuild("/DHCMRInfo.mf")
	}
}

// d ##class(DHCWL.DM.Test.MRInfoInit).InitMetaProNameDes()

ClassMethod InitMetaProNameDes()
{
	s mrinfoObj=##class(DHCWL.DM.T.MetaTableBase).GetByPath("/DHCMRInfo.mf")
	s proCodes="MR_YLFFFS,MR_JKKH,MR_ZYCS,MR_BAH,MR_ZYH,MR_ADM,MR_PapmiDr,MR_XM,MR_XB,MR_CSRQ,MR_NN,MR_GJ,MR_BZZSNN,MR_XSECSTZ,MR_XSERYTZ,MR_CSD,MR_JG,MR_MZ,MR_SFZH,MR_ZY,MR_HY,MR_XZZ,MR_XZZDH,MR_XZZYB,MR_HKDZ,MR_HKYB,MR_GZDWDZ,MR_GZDWDH,MR_GZDWYB,MR_LXRXM,MR_LXRGX,MR_LXRDZ,MR_LXRDH,MR_RYTJ,MR_RYRQ,MR_RYKB,MR_RYBF,MR_ZKKB,MR_CYRQ,MR_CYKB,MR_CYBF,MR_SJZYTS,MR_MJZZDMC,MR_MJZZDJBBM,MR_RYBQ,MR_LYFS,MR_LYFSYLJSJGMC,MR_RYZD,MR_RYZDMC,MR_RYZDRYBQ,MR_RYHQZRQ,MR_CYZYZD,MR_CYZYZDMC,MR_CYZYZDRYBQ,MR_CYZYZDZLJG,MR_CYQTZD1,MR_CYQTZDMC1,MR_CYQTZDRYBQ1,MR_ZYQTZDZLJG1,MR_CYQTZD2,MR_CYQTZDMC2,MR_CYQTZDRYBQ2,MR_CYQTZDZLJG2,MR_CYQTZD3,MR_CYQTZDMC3,MR_CYQTZDRYBQ3,MR_CYQTZDZLJG3,MR_CYQTZD4,MR_CYQTZDMC4,MR_CYQTZDRYBQ4,MR_CYQTZDZLJG4,MR_CYQTZD5,MR_CYQTZDMC5,MR_CYQTZDRYBQ5,MR_CTQTZDZLJG5,MR_CYQTZD6,MR_CYQTZDMC6,MR_CYQTZDRYBQ6,MR_CYQTZDZLJG6,MR_CYQTZD7,MR_CYQTZDMC7,MR_CYQTZDRYBQ7,MR_CYQTZDZLJG7,MR_CYQTZD8,MR_CYQTZDMC8,MR_CYQTZDRYBQ8,MR_CYQTZDZLJG8,MR_CYQTZD9,MR_CYQTZDMC9,MR_CYQTZDRYBQ9,MR_CYQTZDZLJG9,MR_CYQTZD10,MR_CYQTZDMC10,MR_CYQTZDRYBQ10,MR_CYQTZDZLJG10,MR_CYQTZD11,MR_CYQTZDMC11,MR_CYQTZDRYBQ11,MR_CYQTZDZLJG11,MR_CYQTZD12,MR_CYQTZDMC12,MR_CYQTZDRYBQ12,MR_CYQTZDZLJG12,MR_CYQTZD13,MR_CYQTZDMC13,MR_CYQTZDRYBQ13,MR_CYQTZDZLJG13,MR_CYQTZD14,MR_CYQTZDMC14,MR_CYQTZDRYBQ14,MR_CYQTZDZLJG14,MR_CYQTZD15,MR_CYQTZDMC15,MR_CYQTZDRYBQ15,MR_CYQTZDZLJG15,MR_YYGRMCBM,MR_YYGRZDQK,MR_YYGRZDMC,MR_SSBM1,MR_SSJB1,MR_SSRQ1,MR_SSMC1,MR_SSCZYS1,MR_SSIZ1,MR_SSIIZ1,MR_SSMZFS1,MR_SSQKYHDJ1,MR_SSMZYS1,MR_SSSFZQ1,MR_SSBM2,MR_SSJB2,MR_SSRQ2,MR_SSMC2,MR_SSCZYS2,MR_SSIZ2,MR_SSIIZ2,MR_SSMZFS2,MR_SSQKYHDJ2,MR_SSMZYS2,MR_SSSFZQ2,MR_SSBM3,MR_SSJB3,MR_SSRQ3,MR_SSMC3,MR_SSCZYS3,MR_SSIZ3,MR_SSIIZ3,MR_SSMZFS3,MR_SSQKYHDJ3,MR_SSMZYS3,MR_SSSFZQ3,MR_SSBM4,MR_SSJB4,MR_SSRQ4,MR_SSMC4,MR_SSCZYS4,MR_SSIZ4,MR_SSIIZ4,MR_SSMZFS4,MR_SSQKYHDJ4,MR_SSMZYS4,MR_SSSFZQ4,MR_SSBM5,MR_SSJB5,MR_SSRQ5,MR_SSMC5,MR_SSCZYS5,MR_SSIZ5,MR_SSIIZ5,MR_SSMZFS5,MR_SSQKYHDJ5,MR_SSMZYS5,MR_SSSFZQ5,MR_SSBM6,MR_SSJB6,MR_SSRQ6,MR_SSMC6,MR_SSCZYS6,MR_SSIZ6,MR_SSIIZ6,MR_SSMZFS6,MR_SSQKYHDJ6,MR_SSMZYS6,MR_SSSFZQ6,MR_SSBM7,MR_SSJB7,MR_SSRQ7,MR_SSMC7,MR_SSCZYS7,MR_SSIZ7,MR_SSIIZ7,MR_SSMZFS7,MR_SSQKYHDJ7,MR_SSMZYS7,MR_SSSFZQ7,MR_SSBM8,MR_SSJB8,MR_SSRQ8,MR_SSMC8,MR_SSCZYS8,MR_SSIZ8,MR_SSIIZ8,MR_SSMZFS8,MR_SSQKYHDJ8,MR_SSMZYS8,MR_SSSFZQ8,MR_SSBM9,MR_SSJB9,MR_SSRQ9,MR_SSMC9,MR_SSCZYS9,MR_SSIZ9,MR_SSIIZ9,MR_SSMZFS9,MR_SSQKYHDJ9,MR_SSMZYS9,MR_SSSFZQ9,MR_SSBM10,MR_SSJB10,MR_SSRQ10,MR_SSMC10,MR_SSCZYS10,MR_SSIZ10,MR_SSIIZ10,MR_SSMZFS10,MR_SSQKYHDJ10,MR_SSMZYS10,MR_SSSFZQ10,MR_QJCS,MR_QJCGCS,MR_ZYZFF,MR_ZFJE,MR_YBYLFWF,MR_YBYLCZF,MR_HLF,MR_QTFY,MR_BLZDF,MR_SYSZDF,MR_YXXZDF,MR_LCZDXMF,MR_FSSZLXMF,MR_LCWLZLF,MR_SSZLF,MR_MZF,MR_SSF,MR_KFF,MR_ZYZLF,MR_XYF,MR_KJYWFY,MR_ZCHENGYF,MR_ZCAOYF,MR_XF,MR_BDBLZPF,MR_QDBLZPF,MR_JCYYCXYYCLF,MR_ZLYYCXYYCLF,MR_SSYYCXYYCLF,MR_QTF,MR_SSZDDWBYS,MR_SSZDDJBBM,MR_BLZD,MR_BLZDBM,MR_BLH,MR_YWGMBZ,MR_YWGMW,MR_SWHZSJ,MR_XX,MR_RH,MR_KZR,MR_ZRYS,MR_ZZYS,MR_ZYYS,MR_ZRHS,MR_JXYS,MR_XXYS,MR_BMY,MR_BAZL,MR_ZKYS,MR_ZKHS,MR_ZKRQ,MR_MRDate,MR_ZZYJH,MR_ZZYMD,MR_SFTBZZZY,MR_LNSSRYQHMSJT,MR_LNSSRYQHMSJS,MR_LNSSRYQHMSJF,MR_LNSSRYHHMSJT,MR_LNSSRYHHMSJS,MR_LNSSRYHHMSJF,MR_BAFX,MR_SFSSZZJH,MR_JHSJRRQSJ,MR_JHSTCRQSJ,MR_SFDBZGL,MR_SFSSLCLJGL,MR_SFSSDGL,MR_SFSYKSS,MR_SYKSSYW,MR_SFLHSYKSS,MR_LHSYKSSYW,MR_SFXJPYBBSJ,MR_SFFDCRB,MR_ZLFQ,MR_XSEAPF,MR_HXB,MR_XXB,MR_XJ,MR_QX,MR_SFFSRC,MR_SFFSYLSG,MR_SFFSYLCC,MR_SFSZ,MR_SZSJN,MR_SZSJY,MR_SZSJZ,MR_TSHLTS,MR_YJHLTS,MR_EJHLTS,MR_SJHLTS,MR_WZBRQJBZ,MR_SFSX,MR_SXFY,MR_SFCFSSS,MR_SFSY,MR_SYFY,MR_XSECS,MR_CFCS,MR_YYCUSW,MR_SSYWYL,MR_YYXQX,MR_YYXYWCCLS,MR_BYXJC,MR_SSBFZ,MR_SSBFZMC,MR_SWSFFSZWSSQN,MR_SFYNFSDDHZCSJ,MR_SHCD,MR_MZRYZDFHQK,MR_RYCYZDFHQK,MR_SQSHZDFHQK,MR_LCBLZDFHQK,MR_FSBLZDFHQK,MR_SSBDSLBLZDFH,MR_SEXZLSQSHZDFH,MR_GEXZLSQSHZDFH,MR_FEXZLSQSHZDFH,MR_WEXZLSQSHZDFH,MR_ZCEXZLSQSHZDFH,MR_JCEXZLSQSHZDFH,MR_LXYZLZPF,MR_XBYZLZPF,MR_ZYZD_MJZZDMC,MR_ZYZD_MJZZDBMBM,MR_ZYZH_MJZZDMC,MR_ZYZH_MJZZDZHBM,MR_ZYSSLCLJBZDM,MR_SYYLJGZYZJBZ,MR_SYZYZLSBBZ,MR_SYZYZLJSBZ,MR_ZYBZSHBZ,MR_CYZYZD_ZBMC,MR_CYZYZD_ZBBM,MR_CYZYZD_ZBRYBQ,MR_CYZYZD_ZZMC,MR_CYZYZD_ZZBM,MR_CYZYZD_ZZRYBQ,MR_ZYZDF,MR_ZYWZF,MR_ZYZCYJFF,MR_ZYTNZLF,MR_ZYGCZLF,MR_ZYTSZLF,MR_ZYQTF,MR_ZYTSTPJGF,MR_ZYBZSSF,MR_CYZYZD_ZZMC2,MR_CYZYZD_ZZBM2,MR_CYZYZD_ZZRYBQ2,MR_CYZYZD_ZZMC3,MR_CYZYZD_ZZBM3,MR_CYZYZD_ZZRYBQ3,MR_CYZYZD_ZZMC4,MR_CYZYZD_ZZBM4,MR_CYZYZD_ZZRYBQ4,MR_CYZYZD_ZZMC5,MR_CYZYZD_ZZBM5,MR_CYZYZD_ZZRYBQ5,MR_CYZYZD_ZZMC6,MR_CYZYZD_ZZBM6,MR_CYZYZD_ZZRYBQ6,MR_CYZYZD_ZZMC7,MR_CYZYZD_ZZBM7,MR_CYZYZD_ZZRYBQ7,MR_CYZYZD_ZZMC8,MR_CYZYZD_ZZBM8,MR_CYZYZD_ZZRYBQ8,MR_CYZYZD_ZZMC9,MR_CYZYZD_ZZBM9,MR_CYZYZD_ZZRYBQ9,MR_CYZYZD_ZZMC10,MR_CYZYZD_ZZBM10,MR_CYZYZD_ZZRYBQ10,MR_ZYZLLBDM,MR_FWBJ"
	s proDes="医疗付费方式,健康卡号,住院次数,病案号,住院号,就诊号,Papatmas,姓名,性别,出生日期,年龄,国籍,（年龄不足一周岁）年龄,新生儿出生体重,新生儿入院体重,出生地,籍贯,民族,身份证号,职业,婚姻,现住址,电话,邮编,户口地址,邮编,工作单位地址,电话,邮编,联系人姓名,关系,地址,电话,入院途径,入院日期,入院科别,病房,转科科别,出院日期,出院科别,病房,实际住院天数,门（急）诊诊断名称,门（急）诊疾病编码,入院病情,离院方式,医嘱转社区卫生服务机构/乡镇卫生院，接受医疗机构名称,入院诊断,入院诊断名称,入院诊断入院病情,入院后确诊日期,出院主要诊断,出院主要诊断名称,出院主要诊断入院病情,出院主要诊断治疗结果,出院其他诊断1,出院其他诊断名称1,出院其他诊断入院病情1,出院其他诊断治疗结果1,出院其他诊断2,出院其他诊断名称2,出院其他诊断入院病情2,出院其他诊断治疗结果2,出院其他诊断3,出院其他诊断名称3,出院其他诊断入院病情3,出院其他诊断治疗结果3,出院其他诊断4,出院其他诊断名称4,出院其他诊断入院病情4,出院其他诊断治疗结果4,出院其他诊断5,出院其他诊断名称5,出院其他诊断入院病情5,出院其他诊断治疗结果5,出院其他诊断6,出院其他诊断名称6,出院其他诊断入院病情6,出院其他诊断治疗结果6,出院其他诊断7,出院其他诊断名称7,出院其他诊断入院病情7,出院其他诊断治疗结果7,出院其他诊断8,出院其他诊断名称8,出院其他诊断入院病情8,出院其他诊断治疗结果8,出院其他诊断9,出院其他诊断名称9,出院其他诊断入院病情9,出院其他诊断治疗结果9,出院其他诊断10,出院其他诊断名称10,出院其他诊断入院病情10,出院其他诊断治疗结果10,出院其他诊断11,出院其他诊断名称11,出院其他诊断入院病情11,出院其他诊断治疗结果11,出院其他诊断12,出院其他诊断名称12,出院其他诊断入院病情12,出院其他诊断治疗结果12,出院其他诊断13,出院其他诊断名称13,出院其他诊断入院病情13,出院其他诊断治疗结果13,出院其他诊断14,出院其他诊断名称14,出院其他诊断入院病情14,出院其他诊断治疗结果14,出院其他诊断15,出院其他诊断名称15,出院其他诊断入院病情15,出院其他诊断治疗结果15,医院感染名称编码,医院感染诊断情况,医院感染诊断名称,手术编码1,手术级别1,手术日期1,手术名称1,手术操作医师1,I助1,II助1,麻醉方式1/麻醉分级1,切口愈合等级1,麻醉医师1,手术是否择期1,手术编码2,手术级别2,手术日期2,手术名称2,手术操作医师2,I助2,II助2,麻醉方式2/麻醉分级2,切口愈合等级2,麻醉医师2,手术是否择期2,手术编码3,手术级别3,手术日期3,手术名称3,手术操作医师3,I助3,II助3,麻醉方式3/麻醉分级3,切口愈合等级3,麻醉医师3,手术是否择期3,手术编码4,手术级别4,手术日期4,手术名称4,手术操作医师4,I助4,II助4,麻醉方式4/麻醉分级4,切口愈合等级4,麻醉医师4,手术是否择期4,手术编码5,手术级别5,手术日期5,手术名称5,手术操作医师5,I助5,II助5,麻醉方式5/麻醉分级5,切口愈合等级5,麻醉医师5,手术是否择期5,手术编码6,手术级别6,手术日期6,手术名称6,手术操作医师6,I助6,II助6,麻醉方式6/麻醉分级6,切口愈合等级6,麻醉医师6,手术是否择期6,手术编码7,手术级别7,手术日期7,手术名称7,手术操作医师7,I助7,II助7,麻醉方式7/麻醉分级7,切口愈合等级7,麻醉医师7,手术是否择期7,手术编码8,手术级别8,手术日期8,手术名称8,手术操作医师8,I助8,II助8,麻醉方式8/麻醉分级8,切口愈合等级8,麻醉医师8,手术是否择期8,手术编码9,手术级别9,手术日期9,手术名称9,手术操作医师9,I助9,II助9,麻醉方式9/麻醉分级9,切口愈合等级9,麻醉医师9,手术是否择期9,手术编码10,手术级别10,手术日期10,手术名称10,手术操作医师10,I助10,II助10,麻醉方式10/麻醉分级10,切口愈合等级10,麻醉医师10,手术是否择期10,抢救次数,抢救成功次数,住院总费用,自付金额,一般医疗服务费,一般医疗操作费,护理费,其他费用,病理诊断费,实验室诊断费,影像学诊断费,临床诊断项目费,非手术治疗项目费,临床物理治疗费,手术治疗费,麻醉费,手术费,康复费,中医治疗费,西药费,抗菌药物费用,中成药费,中草药费,血费,白蛋白类制品费,球蛋白类制品费,检查用一次性医用材料费,治疗用一次性医用材料费,手术用一次性医用材料费,其他费,损伤中毒的外部因素,损伤中毒的疾病编码,病理诊断,病理诊断编码,病理号,药物过敏标志,药物过敏物,死亡患者是否尸检,血型,RH,科主任,主（副主）任医师,主治医师,住院医师,责任护士,进修医师,实习医师,编码员,病案质量,质控医师,质控护士,质控日期,取数日期,是否有出院31天内再住院计划,31内再住院目的,是否同病种再住院,颅脑损伤患者入院前昏迷天,颅脑损伤患者入院前昏迷小时,颅脑损伤患者入院前昏迷分钟,颅脑损伤患者入院后昏迷天,颅脑损伤患者入院后昏迷小时,颅脑损伤患者入院后昏迷分钟,病案分型,是否实施重症监护,监护室进入日期时间,监护室退出日期时间,是否单病种管理,是否实施临床路径管理,是否实施DRGs管理,是否使用抗生素,使用抗生素药物,是否联合使用抗生素,联合使用抗生素药物,是否细菌培养标本送检,是否法定传染病,肿瘤分期,新生儿Apgar评分,红细胞,血小板,血浆,全血,是否发生褥疮,是否发生医疗事故,是否发生医疗差错,是否随诊,随诊时间年,随诊时间月,随诊时间周,特殊护理天数,一级护理天数,二级护理天数,三级护理天数,危重病人抢救标志,是否输血,输血反应,是否重返手术室,是否输液,输液反应,新生儿产伤,产妇产伤,用药错误死亡,手术异物遗留,医源性气胸,医源性意外穿刺裂伤,病原学检查,手术并发症,手术并发症名称,死亡是否发生在围手术期内,是否院内发生跌倒或坠床事件,伤害程度,门诊与入院诊断符合情况,入院与出院诊断符合情况,术前与术后诊断符合情况,临床与病理诊断符合情况,放射与病理诊断符合情况,手术冰冻与石蜡病理诊断是否符合,肾恶性肿瘤手术前诊断与术后病理诊断是否符合,肝恶性肿瘤手术前诊断与术后病理诊断是否符合,肺恶性肿瘤手术前诊断与术后病理诊断是否符合,胃恶性肿瘤手术前诊断与术后病理诊断是否符合,直肠恶性肿瘤手术前诊断与术后病理诊断是否符合,结肠恶性肿瘤手术前诊断与术后病理诊断是否符合,凝血因子类制品费,细胞因子类制品费,门急诊诊断（中医诊断）名称,门急诊诊断（中医诊断）病名编码,门急诊诊断（中医症候）名称,门急诊诊断（中医症候）症候编码,中医实施临床路径标志代码,使用医疗机构中药制剂标志,使用中医诊疗设备标志,使用中医诊疗技术标志,中医辨证施护标志,出院中医诊断-主病名称,出院中医诊断-主病编码,出院中医诊断-主病-入院病情代码,出院中医诊断-主证名称,出院中医诊断-主证编码,出院中医诊断-主证-入院病情代码,中医诊断费,中医外治费,中医针刺与灸法费,中医推拿治疗费,中医肛肠治疗费,中医特殊治疗费,中医其他费,中医特殊调配加工费,中医辨证施膳费,出院中医诊断-主证名称2,出院中医诊断-主证编码2,出院中医诊断-主证-入院病情代码2,出院中医诊断-主证名称3,出院中医诊断-主证编码3,出院中医诊断-主证-入院病情代码3,出院中医诊断-主证名称4,出院中医诊断-主证编码4,出院中医诊断-主证-入院病情代码4,出院中医诊断-主证名称5,出院中医诊断-主证编码5,出院中医诊断-主证-入院病情代码5,出院中医诊断-主证名称6,出院中医诊断-主证编码6,出院中医诊断-主证-入院病情代码6,出院中医诊断-主证名称7,出院中医诊断-主证编码7,出院中医诊断-主证-入院病情代码7,出院中医诊断-主证名称8,出院中医诊断-主证编码8,出院中医诊断-主证-入院病情代码8,出院中医诊断-主证名称9,出院中医诊断-主证编码9,出院中医诊断-主证-入院病情代码9,出院中医诊断-主证名称10,出院中医诊断-主证编码10,出院中医诊断-主证-入院病情代码10,治疗类别代码,服务半径"
	w $l(proCodes,",")=$l(proDes,",")
	f i=1:1:$l(proCodes,","){
	  s code=$p(proCodes,",",i)
	  s des=$p(proDes,",",i)
	  s proObj=mrinfoObj.GetProperty(code)
	  continue:proObj=""
	  s proObj.Name=des
	  s proObj.Description=des
	  w proObj.%Save()
	  s proObj=""
	}
}

// d ##class(DHCWL.DM.Test.MRInfoInit).InitTheme()

ClassMethod InitTheme()
{
	s theme= ##class(DHCWL.DM.T.ThemeBase).BuildThemeFromMeta("/DHCMRInfo.mf","MR_CYRQ",$lb("MR_CYRQ","MR_PapmiDr","MR_YLFFFS","MR_JKKH","MR_XM","MR_XB","MR_CSRQ","MR_NN","MR_GJ","MR_BZZSNN","MR_XSECSTZ","MR_XSERYTZ","MR_CSD","MR_JG","MR_MZ","MR_SFZH","MR_ZY","MR_HY","MR_XZZ","MR_XZZDH","MR_XZZYB","MR_HKDZ","MR_HKYB","MR_GZDWDZ","MR_GZDWDH","MR_GZDWYB","MR_LXRXM","MR_LXRGX","MR_LXRDZ","MR_LXRDH","MR_RYTJ","MR_RYRQ","MR_RYKB","MR_RYBF","MR_ZKKB","MR_CYKB","MR_CYBF","MR_MJZZDMC","MR_MJZZDJBBM","MR_RYBQ","MR_LYFS","MR_LYFSYLJSJGMC","MR_RYZD","MR_RYZDMC","MR_RYZDRYBQ","MR_RYHQZRQ","MR_CYZYZD","MR_CYZYZDMC","MR_CYZYZDRYBQ","MR_CYZYZDZLJG","MR_CYQTZD1","MR_CYQTZDMC1","MR_CYQTZDRYBQ1","MR_CYQTZD2","MR_CYQTZDMC2","MR_CYQTZDRYBQ2","MR_CYQTZDZLJG2","MR_CYQTZD3","MR_CYQTZDMC3","MR_CYQTZDRYBQ3","MR_CYQTZDZLJG3","MR_CYQTZD4","MR_CYQTZDMC4","MR_CYQTZDRYBQ4","MR_CYQTZDZLJG4","MR_CYQTZD5","MR_CYQTZDMC5","MR_CYQTZDRYBQ5","MR_CYQTZD6","MR_CYQTZDMC6","MR_CYQTZDRYBQ6","MR_CYQTZDZLJG6","MR_CYQTZD7","MR_CYQTZDMC7","MR_CYQTZDRYBQ7","MR_CYQTZDZLJG7","MR_CYQTZD8","MR_CYQTZDMC8","MR_CYQTZDRYBQ8","MR_CYQTZDZLJG8","MR_CYQTZD9","MR_CYQTZDMC9","MR_CYQTZDRYBQ9","MR_CYQTZDZLJG9","MR_CYQTZD10","MR_CYQTZDMC10","MR_CYQTZDRYBQ10","MR_CYQTZDZLJG10","MR_CYQTZD11","MR_CYQTZDMC11","MR_CYQTZDRYBQ11","MR_CYQTZDZLJG11","MR_CYQTZD12","MR_CYQTZDMC12","MR_CYQTZDRYBQ12","MR_CYQTZDZLJG12","MR_CYQTZD13","MR_CYQTZDMC13","MR_CYQTZDRYBQ13","MR_CYQTZDZLJG13","MR_CYQTZD14","MR_CYQTZDMC14","MR_CYQTZDRYBQ14","MR_CYQTZDZLJG14","MR_CYQTZD15","MR_CYQTZDMC15","MR_CYQTZDRYBQ15","MR_CYQTZDZLJG15","MR_YYGRMCBM","MR_YYGRZDQK","MR_YYGRZDMC","MR_SSBM1","MR_SSJB1","MR_SSRQ1","MR_SSMC1","MR_SSCZYS1","MR_SSIZ1","MR_SSIIZ1","MR_SSMZFS1","MR_SSQKYHDJ1","MR_SSMZYS1","MR_SSSFZQ1","MR_SSBM2","MR_SSJB2","MR_SSRQ2","MR_SSMC2","MR_SSCZYS2","MR_SSIZ2","MR_SSIIZ2","MR_SSMZFS2","MR_SSQKYHDJ2","MR_SSMZYS2","MR_SSSFZQ2","MR_SSBM3","MR_SSJB3","MR_SSRQ3","MR_SSMC3","MR_SSCZYS3","MR_SSIZ3","MR_SSIIZ3","MR_SSMZFS3","MR_SSQKYHDJ3","MR_SSMZYS3","MR_SSSFZQ3","MR_SSBM4","MR_SSJB4","MR_SSRQ4","MR_SSMC4","MR_SSCZYS4","MR_SSIZ4","MR_SSIIZ4","MR_SSMZFS4","MR_SSQKYHDJ4","MR_SSMZYS4","MR_SSSFZQ4","MR_SSBM5","MR_SSJB5","MR_SSRQ5","MR_SSMC5","MR_SSCZYS5","MR_SSIZ5","MR_SSIIZ5","MR_SSMZFS5","MR_SSQKYHDJ5","MR_SSMZYS5","MR_SSSFZQ5","MR_SSBM6","MR_SSJB6","MR_SSRQ6","MR_SSMC6","MR_SSCZYS6","MR_SSIZ6","MR_SSIIZ6","MR_SSMZFS6","MR_SSQKYHDJ6","MR_SSMZYS6","MR_SSSFZQ6","MR_SSBM7","MR_SSJB7","MR_SSRQ7","MR_SSMC7","MR_SSCZYS7","MR_SSIZ7","MR_SSIIZ7","MR_SSMZFS7","MR_SSQKYHDJ7","MR_SSMZYS7","MR_SSSFZQ7","MR_SSBM8","MR_SSJB8","MR_SSRQ8","MR_SSMC8","MR_SSCZYS8","MR_SSIZ8","MR_SSIIZ8","MR_SSMZFS8","MR_SSQKYHDJ8","MR_SSMZYS8","MR_SSSFZQ8","MR_SSBM9","MR_SSJB9","MR_SSRQ9","MR_SSMC9","MR_SSCZYS9","MR_SSIZ9","MR_SSIIZ9","MR_SSMZFS9","MR_SSQKYHDJ9","MR_SSMZYS9","MR_SSSFZQ9","MR_SSBM10","MR_SSJB10","MR_SSRQ10","MR_SSMC10","MR_SSCZYS10","MR_SSIZ10","MR_SSIIZ10","MR_SSMZFS10","MR_SSQKYHDJ10","MR_SSMZYS10","MR_SSSFZQ10","MR_QJCS","MR_QJCGCS","MR_SSZDDWBYS","MR_SSZDDJBBM","MR_BLZD","MR_BLZDBM","MR_BLH","MR_YWGMBZ","MR_YWGMW","MR_SWHZSJ","MR_XX","MR_RH","MR_KZR","MR_ZRYS","MR_ZZYS","MR_ZYYS","MR_ZRHS","MR_JXYS","MR_XXYS","MR_BMY","MR_BAZL","MR_ZKYS","MR_ZKHS","MR_ZKRQ","MR_MRDate","MR_ZZYJH","MR_ZZYMD","MR_SFTBZZZY","MR_BAFX","MR_SFSSZZJH","MR_JHSJRRQSJ","MR_JHSTCRQSJ","MR_SFDBZGL","MR_SFSSLCLJGL","MR_SFSSDGL","MR_SFSYKSS","MR_SYKSSYW","MR_SFLHSYKSS","MR_LHSYKSSYW","MR_SFXJPYBBSJ","MR_SFFDCRB","MR_ZLFQ","MR_XSEAPF","MR_HXB","MR_XXB","MR_XJ","MR_QX","MR_SFFSRC","MR_SFFSYLSG","MR_SFFSYLCC","MR_SFSZ","MR_SZSJN","MR_SZSJY","MR_SZSJZ","MR_TSHLTS","MR_YJHLTS","MR_EJHLTS","MR_SJHLTS","MR_WZBRQJBZ","MR_SFSX","MR_SXFY","MR_SFCFSSS","MR_SFSY","MR_SYFY","MR_XSECS","MR_CFCS","MR_YYCUSW","MR_SSYWYL","MR_YYXQX","MR_YYXYWCCLS","MR_BYXJC","MR_SSBFZ","MR_SSBFZMC","MR_SWSFFSZWSSQN","MR_SFYNFSDDHZCSJ","MR_SHCD","MR_MZRYZDFHQK","MR_RYCYZDFHQK","MR_SQSHZDFHQK","MR_LCBLZDFHQK","MR_FSBLZDFHQK","MR_SSBDSLBLZDFH","MR_SEXZLSQSHZDFH","MR_GEXZLSQSHZDFH","MR_FEXZLSQSHZDFH","MR_WEXZLSQSHZDFH","MR_ZCEXZLSQSHZDFH","MR_JCEXZLSQSHZDFH","MR_LXYZLZPF","MR_XBYZLZPF","MR_ZYZD_MJZZDBMBM","MR_ZYZH_MJZZDMC","MR_ZYZH_MJZZDZHBM","MR_ZYSSLCLJBZDM","MR_SYYLJGZYZJBZ","MR_SYZYZLSBBZ","MR_SYZYZLJSBZ","MR_ZYBZSHBZ","MR_CYZYZD_ZBMC","MR_CYZYZD_ZBBM","MR_CYZYZD_ZBRYBQ","MR_CYZYZD_ZZMC","MR_CYZYZD_ZZBM","MR_CYZYZD_ZZRYBQ","MR_CYZYZD_ZZMC2","MR_CYZYZD_ZZBM2","MR_CYZYZD_ZZRYBQ2","MR_CYZYZD_ZZMC3","MR_CYZYZD_ZZBM3","MR_CYZYZD_ZZRYBQ3","MR_CYZYZD_ZZMC4","MR_CYZYZD_ZZBM4","MR_CYZYZD_ZZRYBQ4","MR_CYZYZD_ZZMC5","MR_CYZYZD_ZZBM5","MR_CYZYZD_ZZRYBQ5","MR_CYZYZD_ZZMC6","MR_CYZYZD_ZZBM6","MR_CYZYZD_ZZRYBQ6","MR_CYZYZD_ZZMC7","MR_CYZYZD_ZZBM7","MR_CYZYZD_ZZRYBQ7","MR_CYZYZD_ZZMC8","MR_CYZYZD_ZZBM8","MR_CYZYZD_ZZRYBQ8","MR_CYZYZD_ZZMC9","MR_CYZYZD_ZZBM9","MR_CYZYZD_ZZRYBQ9","MR_CYZYZD_ZZMC10","MR_CYZYZD_ZZBM10","MR_CYZYZD_ZZRYBQ10","MR_ZYZLLBDM","MR_FWBJ","MR_BAH","MR_ZYH","MR_ADM"),$lb("MR_ZYCS","MR_SJZYTS","MR_ZYZFF","MR_ZFJE","MR_YBYLFWF","MR_YBYLCZF","MR_HLF","MR_QTFY","MR_BLZDF","MR_SYSZDF","MR_YXXZDF","MR_LCZDXMF","MR_FSSZLXMF","MR_LCWLZLF","MR_SSZLF","MR_MZF","MR_SSF","MR_KFF","MR_ZYZLF","MR_XYF","MR_KJYWFY","MR_ZCHENGYF","MR_ZCAOYF","MR_XF","MR_BDBLZPF","MR_QDBLZPF","MR_JCYYCXYYCLF","MR_ZLYYCXYYCLF","MR_SSYYCXYYCLF","MR_QTF","MR_LNSSRYQHMSJT","MR_LNSSRYQHMSJS","MR_LNSSRYQHMSJF","MR_LNSSRYHHMSJT","MR_LNSSRYHHMSJS","MR_LNSSRYHHMSJF","MR_ZYZDF","MR_ZYWZF","MR_ZYZCYJFF","MR_ZYTNZLF","MR_ZYGCZLF","MR_ZYTSZLF","MR_ZYQTF","MR_ZYTSTPJGF","MR_ZYBZSSF"))
    w theme,!
    d theme.ChangeDimType($lb("MR_BAH","MR_ZYH","MR_ADM"),"R")
}

// d ##class(DHCWL.DM.Test.MRInfoInit).AddFunDim()

ClassMethod AddFunDim()
{
	s theme=##class(DHCWL.DM.T.ThemeBase).GetByPath("/DHCMRInfo.t")
	s obj=theme.GetDim("TMethodTest")
	if (obj=""){
		s obj=##class(ThemeDims).%New()
	}
	s obj.ThemeBase=theme,obj.Code="TMethodTest",obj.Name="主题方法测试" ,obj.DataType=##class(DHCWL.DM.T.DataType).GetByPath("string")
	s obj.ProExpression="ThemeDynDimFun"
	s obj.UpdateDate=+$p($h,",",1)
	s obj.CreateType=##class(DHCWL.DM.T.TypeConfig).GetByPath("TD:DYNPROFUN")
	s obj.DimType=##class(DHCWL.DM.T.TypeConfig).GetByPath("TD:LD")
	s obj.SrcFetchConfig=##class(ThemeFetchConfig).GetAt("/DHCMRInfo.t",1)
	s obj.SrcMeta=##class(DHCWL.DM.T.MetaTableBase).GetByPath("/DHCMRInfo.mf")
	w obj.%Save(),!
	w obj.%Id(),","
}

// d ##class(DHCWL.DM.Test.MRInfoInit).InitFetchFilter()

/*ClassMethod InitFetchFilter()
{
	s list= ##class(DHCWL.DM.T.ThemeFetchConfig).Get("/DHCMRInfo.t")
	s mr=list.GetAt(1)
	s fetchBaseId=mr.%Id()
	w fetchBaseId,!
	q:+fetchBaseId=0
	&sql(update DHCWL_DM_T.ThemeFetchFilter set JoinLogicalForAfter='AND ' where FetchBase=:fetchBaseId and ExecuteOrder=2)
	s obj=##class(ThemeFetchFilter).%New()
	s obj.FetchBase=mr,obj.FilterField=mr.FactMetaTable.GetProperty("DHCMRInfo_RowID")
	s obj.FilterFunction=">",obj.FilterParam="0",obj.ExecuteOrder=3,obj.JoinLogicalForAfter="",obj.HasNotLogical="N"
	s sc= obj.%Save()
	i $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) 
	w obj.%Id(),","
}*/

// d ##class(DHCWL.DM.Test.MRInfoInit).InitCube()

ClassMethod InitCube()
{
    s status= ##class(DHCWL.DM.T.CubeBase).NewCube2("/DHCMRInfo.t",$lb("MR_CYRQ","MR_PapmiDr","MR_YLFFFS","MR_JKKH","MR_XM","MR_XB","MR_CSRQ","MR_NN","MR_GJ","MR_BZZSNN","MR_XSECSTZ","MR_XSERYTZ","MR_CSD","MR_JG","MR_MZ","MR_SFZH","MR_ZY","MR_HY","MR_XZZ","MR_XZZDH","MR_XZZYB","MR_HKDZ","MR_HKYB","MR_GZDWDZ","MR_GZDWDH","MR_GZDWYB","MR_LXRXM","MR_LXRGX","MR_LXRDZ","MR_LXRDH","MR_RYTJ","MR_RYRQ","MR_RYKB","MR_RYBF","MR_ZKKB","MR_CYKB","MR_CYBF","MR_MJZZDMC","MR_MJZZDJBBM","MR_RYBQ","MR_LYFS","MR_LYFSYLJSJGMC","MR_RYZD","MR_RYZDMC","MR_RYZDRYBQ","MR_RYHQZRQ","MR_CYZYZD","MR_CYZYZDMC","MR_CYZYZDRYBQ","MR_CYZYZDZLJG","MR_CYQTZD1","MR_CYQTZDMC1","MR_CYQTZDRYBQ1","MR_CYQTZD2","MR_CYQTZDMC2","MR_CYQTZDRYBQ2","MR_CYQTZDZLJG2","MR_CYQTZD3","MR_CYQTZDMC3","MR_CYQTZDRYBQ3","MR_CYQTZDZLJG3","MR_CYQTZD4","MR_CYQTZDMC4","MR_CYQTZDRYBQ4","MR_CYQTZDZLJG4","MR_CYQTZD5","MR_CYQTZDMC5","MR_CYQTZDRYBQ5","MR_CYQTZD6","MR_CYQTZDMC6","MR_CYQTZDRYBQ6","MR_CYQTZDZLJG6","MR_CYQTZD7","MR_CYQTZDMC7","MR_CYQTZDRYBQ7","MR_CYQTZDZLJG7","MR_CYQTZD8","MR_CYQTZDMC8","MR_CYQTZDRYBQ8","MR_CYQTZDZLJG8","MR_CYQTZD9","MR_CYQTZDMC9","MR_CYQTZDRYBQ9","MR_CYQTZDZLJG9","MR_CYQTZD10","MR_CYQTZDMC10","MR_CYQTZDRYBQ10","MR_CYQTZDZLJG10","MR_CYQTZD11","MR_CYQTZDMC11","MR_CYQTZDRYBQ11","MR_CYQTZDZLJG11","MR_CYQTZD12","MR_CYQTZDMC12","MR_CYQTZDRYBQ12","MR_CYQTZDZLJG12","MR_CYQTZD13","MR_CYQTZDMC13","MR_CYQTZDRYBQ13","MR_CYQTZDZLJG13","MR_CYQTZD14","MR_CYQTZDMC14","MR_CYQTZDRYBQ14","MR_CYQTZDZLJG14","MR_CYQTZD15","MR_CYQTZDMC15","MR_CYQTZDRYBQ15","MR_CYQTZDZLJG15","MR_YYGRMCBM","MR_YYGRZDQK","MR_YYGRZDMC","MR_SSBM1","MR_SSJB1","MR_SSRQ1","MR_SSMC1","MR_SSCZYS1","MR_SSIZ1","MR_SSIIZ1","MR_SSMZFS1","MR_SSQKYHDJ1","MR_SSMZYS1","MR_SSSFZQ1","MR_SSBM2","MR_SSJB2","MR_SSRQ2","MR_SSMC2","MR_SSCZYS2","MR_SSIZ2","MR_SSIIZ2","MR_SSMZFS2","MR_SSQKYHDJ2","MR_SSMZYS2","MR_SSSFZQ2","MR_SSBM3","MR_SSJB3","MR_SSRQ3","MR_SSMC3","MR_SSCZYS3","MR_SSIZ3","MR_SSIIZ3","MR_SSMZFS3","MR_SSQKYHDJ3","MR_SSMZYS3","MR_SSSFZQ3","MR_SSBM4","MR_SSJB4","MR_SSRQ4","MR_SSMC4","MR_SSCZYS4","MR_SSIZ4","MR_SSIIZ4","MR_SSMZFS4","MR_SSQKYHDJ4","MR_SSMZYS4","MR_SSSFZQ4","MR_SSBM5","MR_SSJB5","MR_SSRQ5","MR_SSMC5","MR_SSCZYS5","MR_SSIZ5","MR_SSIIZ5","MR_SSMZFS5","MR_SSQKYHDJ5","MR_SSMZYS5","MR_SSSFZQ5","MR_SSBM6","MR_SSJB6","MR_SSRQ6","MR_SSMC6","MR_SSCZYS6","MR_SSIZ6","MR_SSIIZ6","MR_SSMZFS6","MR_SSQKYHDJ6","MR_SSMZYS6","MR_SSSFZQ6","MR_SSBM7","MR_SSJB7","MR_SSRQ7","MR_SSMC7","MR_SSCZYS7","MR_SSIZ7","MR_SSIIZ7","MR_SSMZFS7","MR_SSQKYHDJ7","MR_SSMZYS7","MR_SSSFZQ7","MR_SSBM8","MR_SSJB8","MR_SSRQ8","MR_SSMC8","MR_SSCZYS8","MR_SSIZ8","MR_SSIIZ8","MR_SSMZFS8","MR_SSQKYHDJ8","MR_SSMZYS8","MR_SSSFZQ8","MR_SSBM9","MR_SSJB9","MR_SSRQ9","MR_SSMC9","MR_SSCZYS9","MR_SSIZ9","MR_SSIIZ9","MR_SSMZFS9","MR_SSQKYHDJ9","MR_SSMZYS9","MR_SSSFZQ9","MR_SSBM10","MR_SSJB10","MR_SSRQ10","MR_SSMC10","MR_SSCZYS10","MR_SSIZ10","MR_SSIIZ10","MR_SSMZFS10","MR_SSQKYHDJ10","MR_SSMZYS10","MR_SSSFZQ10","MR_QJCS","MR_QJCGCS","MR_SSZDDWBYS","MR_SSZDDJBBM","MR_BLZD","MR_BLZDBM","MR_BLH","MR_YWGMBZ","MR_YWGMW","MR_SWHZSJ","MR_XX","MR_RH","MR_KZR","MR_ZRYS","MR_ZZYS","MR_ZYYS","MR_ZRHS","MR_JXYS","MR_XXYS","MR_BMY","MR_BAZL","MR_ZKYS","MR_ZKHS","MR_ZKRQ","MR_MRDate","MR_ZZYJH","MR_ZZYMD","MR_SFTBZZZY","MR_BAFX","MR_SFSSZZJH","MR_JHSJRRQSJ","MR_JHSTCRQSJ","MR_SFDBZGL","MR_SFSSLCLJGL","MR_SFSSDGL","MR_SFSYKSS","MR_SYKSSYW","MR_SFLHSYKSS","MR_LHSYKSSYW","MR_SFXJPYBBSJ","MR_SFFDCRB","MR_ZLFQ","MR_XSEAPF","MR_HXB","MR_XXB","MR_XJ","MR_QX","MR_SFFSRC","MR_SFFSYLSG","MR_SFFSYLCC","MR_SFSZ","MR_SZSJN","MR_SZSJY","MR_SZSJZ","MR_TSHLTS","MR_YJHLTS","MR_EJHLTS","MR_SJHLTS","MR_WZBRQJBZ","MR_SFSX","MR_SXFY","MR_SFCFSSS","MR_SFSY","MR_SYFY","MR_XSECS","MR_CFCS","MR_YYCUSW","MR_SSYWYL","MR_YYXQX","MR_YYXYWCCLS","MR_BYXJC","MR_SSBFZ","MR_SSBFZMC","MR_SWSFFSZWSSQN","MR_SFYNFSDDHZCSJ","MR_SHCD","MR_MZRYZDFHQK","MR_RYCYZDFHQK","MR_SQSHZDFHQK","MR_LCBLZDFHQK","MR_FSBLZDFHQK","MR_SSBDSLBLZDFH","MR_SEXZLSQSHZDFH","MR_GEXZLSQSHZDFH","MR_FEXZLSQSHZDFH","MR_WEXZLSQSHZDFH","MR_ZCEXZLSQSHZDFH","MR_JCEXZLSQSHZDFH","MR_LXYZLZPF","MR_XBYZLZPF","MR_BAH","MR_ZYH","MR_ADM"),$lb("MR_ZYCS","MR_SJZYTS","MR_ZYZFF","MR_ZFJE","MR_YBYLFWF","MR_YBYLCZF","MR_HLF","MR_QTFY","MR_BLZDF","MR_SYSZDF","MR_YXXZDF","MR_LCZDXMF","MR_FSSZLXMF","MR_LCWLZLF","MR_SSZLF","MR_MZF","MR_SSF","MR_KFF","MR_ZYZLF","MR_XYF","MR_KJYWFY","MR_ZCHENGYF","MR_ZCAOYF","MR_XF","MR_BDBLZPF","MR_QDBLZPF","MR_JCYYCXYYCLF","MR_ZLYYCXYYCLF","MR_SSYYCXYYCLF","MR_QTF","MR_LNSSRYQHMSJT","MR_LNSSRYQHMSJS","MR_LNSSRYQHMSJF","MR_LNSSRYHHMSJT","MR_LNSSRYHHMSJS","MR_LNSSRYHHMSJF"))
    if status'=$$$OK {
	    w status
	    q status
    }
    d ##class(DHCWL.DM.T.CubeDBDPPart).AddThemePart("/DHCMRInfo.t")
    d ##class(DHCWL.DM.T.CubeDBDPPart).AddThemePart("/DHCMRInfo.t")
    d ##class(DHCWL.DM.T.CubeDBDPPart).AddThemePart("/DHCMRInfo.t")
    d ##class(DHCWL.DM.T.CubeDBDPPart).AddThemePart("/DHCMRInfo.t")
}

// d ##class(DHCWL.DM.Test.MRInfoInit).InitBaseDim()

ClassMethod InitBaseDim()
{
	s ds=##class(DataSourceConfig).GetByPath("JDBC:DHCAPP_LOCAL")
	s ns=##class(Namespace).MetaNamespace("/")
	s type=##class(TypeConfig).GetByPath("META:LOOKUP")
	s obj=##class(MetaTableBase).GetByPath("/CTLOC.ml")
	if obj=""{
		s obj=##class(MetaTableBase).%New()
		s obj.Type=type
		s obj.Namespace=ns
		s obj.Code="CTLOC"
		s obj.Name="科室维表"
		s obj.Description="科室维表"
		s obj.DSConfig=ds
		s obj.Creator="lhh"
		s obj.CreatedDate=+$h
		d obj.%Save()
		w obj.%Id(),","
		s id=obj.%Id()
		q:id=""
		s master="MetaTableBase-MDS-"_obj.%Id()
		&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'table','ct_loc'))
		w %ROWID,","
		&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'schema','SQLUSER'))
		w %ROWID,","
		s status=##class(DHCWL.DM.I.Manage).MetaInfoBuild("/CTLOC.ml")
	}
	
	s ml=##class(MetaTableBase).GetByPath("/CTLOC.ml")
	s ns=##class(Namespace).GetByPath("DI:/")
	s dim=##class(DimBase).GetByPath("/CTLOC.d")
	if dim=""{
		s dim=##class(DimBase).%New()
	}
	s dim.Namespace=ns,dim.Code="CTLOC",dim.Name="科室",dim.LinkedMetaDim=ml,dim.Description="科室维度，对应HIS的ct_loc表",dim.Creator="lhh",dim.CreatedDate=+$p($h,",",1)
	s dim.RowKeyFields="LocId"
	d dim.%Save()
	w dim.%Id(),","
	
	s base=##class(DimBase).GetByPath("/CTLOC.d")
	s dpmp=##class(TypeConfig).GetByPath("DIM:DPMP")
	s bsed=##class(TypeConfig).GetByPath("DIM:BSED")
	
	s obj=dim.GetProperty("LocId")
	s:obj="" obj=##class(DimProperty).%New()
	s obj.DimBase=base,obj.Code="LocId",obj.Name="科室ID",obj.Description="科室RowID"
	s obj.CreatedType=dpmp,obj.Expression="CTLOC_RowID", obj.IsLinked="N"
	d obj.%Save()
	w obj.%Id(),","
	s obj=dim.GetProperty("LocCode")
	s:obj="" obj=##class(DimProperty).%New()
	s obj.DimBase=base,obj.Code="LocCode",obj.Name="科室代码（名称）",obj.Description="科室名称汉语拼音首字母编码" ;,obj.DataType=##class(DataType).GetByPath("string")
	s obj.CreatedType=dpmp,obj.Expression="CTLOC_Code", obj.IsLinked="N"
	d obj.%Save()
	w obj.%Id(),","
	s obj=dim.GetProperty("LocDesc")
	s:obj="" obj=##class(DimProperty).%New()
	s obj.DimBase=base,obj.Code="LocDesc",obj.Name="科室描述",obj.Description="科室描述" ;,obj.DataType=##class(DataType).GetByPath("string")
	s obj.CreatedType=dpmp,obj.Expression="CTLOC_Desc", obj.IsLinked="N"
	d obj.%Save()
	w obj.%Id(),","
	s obj=dim.GetProperty("LocContact")
	s:obj="" obj=##class(DimProperty).%New()
	s obj.DimBase=base,obj.Code="LocContact",obj.Name="科室拼音检索码",obj.Description="科室拼音的首字母码，用于检索使用" ;,obj.DataType=##class(DataType).GetByPath("string")
	s obj.CreatedType=dpmp,obj.Expression="CTLOC_ContactName", obj.IsLinked="N"
	d obj.%Save()
	w obj.%Id(),","
	s obj=dim.GetProperty("LocFloor")
	s:obj="" obj=##class(DimProperty).%New()
	s obj.DimBase=base,obj.Code="LocFloor",obj.Name="科室楼层",obj.Description="科室楼层" ;,obj.DataType=##class(DataType).GetByPath("string")
	s obj.CreatedType=dpmp,obj.Expression="CTLOC_Floor", obj.IsLinked="N"
	d obj.%Save()
	w obj.%Id(),","
	
	
	
	s ds=##class(DataSourceConfig).GetByPath("JDBC:DHCAPP_LOCAL")
	s ns=##class(Namespace).MetaNamespace("/")
	s type=##class(TypeConfig).GetByPath("META:LOOKUP")
	s obj=##class(MetaTableBase).GetByPath("/CTPCP.ml")
	if obj=""{
		s obj=##class(MetaTableBase).%New()
		s obj.Type=type
		s obj.Namespace=ns
		s obj.Code="CTPCP"
		s obj.Name="医生维表"
		s obj.Description="医生维表"
		s obj.DSConfig=ds
		s obj.Creator="lhh"
		s obj.CreatedDate=+$h
		d obj.%Save()
		w obj.%Id(),","
		s id=obj.%Id()
		q:id=""
		s master="MetaTableBase-MDS-"_obj.%Id()
		&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'table','CT_CareProv'))
		w %ROWID,","
		&sql(insert into DHCWL_DM_T.KeyValueConfig(Master,KeyName,Value) values(:master,'schema','SQLUSER'))
		w %ROWID,","
		s status=##class(DHCWL.DM.I.Manage).MetaInfoBuild("/CTPCP.ml")
	}
	s ml=##class(MetaTableBase).GetByPath("/CTPCP.ml")
	s ns=##class(Namespace).GetByPath("DI:/")
	s dim=##class(DimBase).%New()
	s dim.Namespace=ns,dim.Code="CTPCP",dim.Name="医生",dim.LinkedMetaDim=ml,dim.Description="维度维度，对应HIS的CT_CareProv表",dim.Creator="lhh",dim.CreatedDate=+$p($h,",",1)
	s dim.RowKeyFields="DocId"
	d dim.%Save()
	w dim.%Id(),","
	
	s base=##class(DimBase).GetByPath("/CTPCP.d")
	s dpmp=##class(TypeConfig).GetByPath("DIM:DPMP")
	s bsed=##class(TypeConfig).GetByPath("DIM:BSED")
	
	s obj=dim.GetProperty("DocId")
	s:obj="" obj=##class(DimProperty).%New()
	s obj.DimBase=base,obj.Code="DocId",obj.Name="医生ID",obj.Description="医生RowID"
	s obj.CreatedType=dpmp,obj.Expression="CTPCP_RowId", obj.IsLinked="N"
	d obj.%Save()
	w obj.%Id(),","
	s obj=dim.GetProperty("DocCode")
	s:obj="" obj=##class(DimProperty).%New()
	s obj.DimBase=base,obj.Code="DocCode",obj.Name="医生工号",obj.Description="医生工号"
	s obj.CreatedType=dpmp,obj.Expression="CTPCP_Code", obj.IsLinked="N"
	d obj.%Save()
	w obj.%Id(),","
	s obj=dim.GetProperty("DocName")
	s:obj="" obj=##class(DimProperty).%New()
	s obj.DimBase=base,obj.Code="DocName",obj.Name="医生姓名",obj.Description="医生姓名"
	s obj.CreatedType=dpmp,obj.Expression="CTPCP_Desc", obj.IsLinked="N"
	d obj.%Save()
	w obj.%Id(),","
	
	//运行Java程序，完成维度数据的构建
	//运行  com.dhcwl.dm.core.DimDataBuilderTest.testBaseDim
}

// d ##class(DHCWL.DM.Test.MRInfoInit).InitThemeDimLinkPath()

ClassMethod InitThemeDimLinkPath()
{
	s theme= ##class(DHCWL.DM.T.ThemeBase).GetByPath("/DHCMRInfo.t")
    w theme.SetLinkPath("MR_RYBF","/CTLOC.d")
    w theme.SetLinkPath("MR_ZKKB","/CTLOC.d")
    w theme.SetLinkPath("MR_ZKKB","/CTLOC.d")
    w theme.SetLinkPath("MR_CYKB","/CTLOC.d")
    w theme.SetLinkPath("MR_CYBF","/CTLOC.d")
    w theme.SetLinkPath("MR_KZR","/CTPCP.d")
    w theme.SetLinkPath("MR_ZRYS","/CTPCP.d")
    w theme.SetLinkPath("MR_ZZYS","/CTPCP.d")
    w theme.SetLinkPath("MR_ZYYS","/CTPCP.d")
    w theme.SetLinkPath("MR_ZRHS","/CTPCP.d")
    w theme.SetLinkPath("MR_JXYS","/CTPCP.d")
    w theme.SetLinkPath("MR_XXYS","/CTPCP.d")
    w theme.SetLinkPath("MR_ZKYS","/CTPCP.d")
}

// d ##class(DHCWL.DM.Test.MRInfoInit).QueryMRInfo("2017-02-17","2017-02-17")

ClassMethod QueryMRInfo(sd, ed)
{
	s cql="rs1:{"_
            "from: /DHCMRInfo.t,"_
            //"dims : MR_XM,MR_CYZYZD,MR_RYRQ,MR_CYRQ,MR_RYBF,MR_ADM,MR_ZYH,MR_BAH,"_  //,TMethodTest(11),TMethodTest(22)
            "dims : MR_XM,MR_CYZYZD,MR_RYRQ,MR_CYRQ,MR_RYBF,MR_RYBF->LocCode,MR_ADM,MR_ZYH,MR_BAH,"_ 
            //"metrics: MR_ZYZFF,"_
            "filter: MR_CYRQ between("_sd_","_ed_"),"_ //&& MR_CYZYZD between (K00,K99)&&MR_XM like(张%)  && ( type contain([O,E]) ) && RecDep->Code = (门诊西药房)
            "sort: MR_XM,"_  //MR_ZYZFF desc,
            "print:true,"_
          "};"
	s parser=##class(DHCWL.DM.Core.CQLParser).%New()
	w parser.Parse(cql),!
	s executor=##class(DHCWL.DM.Core.PhysicalExecutor).%New(parser)
	w executor.Execute(),!
	s it=executor.GetIterator("rs1")
	w $lts(it.GetDimMeta(),"    ",1),"    "
	w $lts(it.GetMetricMeta(),"    ",1),!
	s count=0
	while (it.HasNext()){
	  w $lts(it.CurDims(),"^",1)_" : " _ $lts(it.CurMetrics(),"^",1),!	
	  s count=count+1
	}
	w "count:"_count,!
	d executor.Close()
	s executor="",parser=""
}

// d ##class(DHCWL.DM.Test.MRInfoInit).test()

ClassMethod test()
{
  s a("朱爱珍")=""
  s a("陈金玉")=""
  s a("喻杏兰")=""
  s a("蔡水平")=""
  s a("冯雁")=""
  zw a
}

ClassMethod QueryMRInfo2(sd, ed)
{
	s cql="rs1:{from: /DHCMRInfo.t,dims : MR_CYKB->LocDesc,MR_CYQTZD1,MR_CYQTZD10,MR_GJ,MR_GZDWDH,MR_GZDWDZ,MR_GZDWYB,MR_HKDZ,metrics: MR_BDBLZPF,MR_BLZDF,filter: MR_CYRQ DateRange(2017-02-17,2017-02-17),sort:,print:true,};"
	s parser=##class(DHCWL.DM.Core.CQLParser).%New()
	w parser.Parse(cql),!
	s executor=##class(DHCWL.DM.Core.PhysicalExecutor).%New(parser)
	w executor.Execute(),!
	s it=executor.GetIterator("rs1")
	w $lts(it.GetDimMeta(),"    ",1),"    "
	w $lts(it.GetMetricMeta(),"    ",1),!
	s count=0
	while (it.HasNext()){
	  w $lts(it.CurDims(),"^",1)_" : " _ $lts(it.CurMetrics(),"^",1),!	
	  s count=count+1
	}
	w "count:"_count,!
	d executor.Close()
	s executor="",parser=""
}

}
