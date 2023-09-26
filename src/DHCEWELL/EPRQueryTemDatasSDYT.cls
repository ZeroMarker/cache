/// Creator:	yejian
/// CreatDate:  2016-4-21
/// Desc:		烟台区域医疗需在shadow库提供视图表接口
/// Input：		AEpisodeID 就诊号
Class DHCEWELL.EPRQueryTemDatasSDYT Extends %RegisteredObject
{

// debug d ##Class(DHCEWELL.EPRQueryTemDatasSDYT).GetFPEpisodeIDList("2015-8-23","2016-8-23")

ClassMethod GetFPEpisodeIDList(DateFrom As %String, DateTo As %String) As %String
{
	;n (DateFrom,DateTo)
	s EpisodeIDStr=""
	
	s ds = ##class(%Library.ResultSet).%New("web.DHCWMRInterface.FrontPage:QryFrontPage")
	d ds.Execute(DateFrom,DateTo)
	while(ds.Next())
	{
		s Paadm=ds.Data("Paadm")           //就诊号
		s FPDate=ds.Data("FPDate")         //编码日期 2009-01-01
		q:FPDate=""
		s:FPDate'="" FPDate=$zdh(FPDate,3)
		s FPTime=ds.Data("FPTime")         //编码时间
		s FPUserID=ds.Data("FPUserID")     //编码员ID
		s FPUserDesc=ds.Data("FPUserDesc") //编码员
		
		s EpisodeIDStr=EpisodeIDStr_"^"_Paadm
		
	}
	d ds.Close()
	
	s EpisodeIDStr = $e(EpisodeIDStr,2,$l(EpisodeIDStr))
	q EpisodeIDStr
}

/// Creator:	yejian
/// CreatDate:  2012-7-9
/// Desc:		住院病案首页第一部分
/// Input：		aCategoryID：术语范畴Id
/// Return：	EPRservice.dataset.EDataElementDataset: 术语集dataset
/// Debug:		d ##Class(%ResultSet).RunQuery("DHCEWELL.EPRQueryTemDatasSDYT","GetINPUTCASEFIRP",58)
Query GetINPUTCASEFIRP(DateFrom As %String, DateTo As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "JZLSH:%String,YLJGDM:%String,RYSJ:%String,RYLX:%String,KH:%String,KLX:%String,BXLX:%String,YLFFFS:%String,ZYCS:%String,BAH:%String,CH:%String,RYBQ:%String,CYBQ:%String,XM:%String,XB:%String,CSNY:%String,XSECSTZ:%String,XSERYTZ:%String,HYZK:%String,MZ:%String,GJ:%String,JG:%String,CSD:%String,SFZ:%String,LXDH:%String,GZDW:%String,GZDWDH:%String,GZDWYB:%String,ZYBM:%String,JZD:%String,XZZDH:%String,XZZYB:%String,HKDZ:%String,HKDH:%String,HKYB:%String,DQBM:%String,QXBM:%String,JDBM:%String,LXRXM:%String,LXRGX:%String,LXRDZ:%String,LXRDH:%String,LXRTXDZ:%String,RYKSBM:%String,ZKKSBM1:%String,ZKKSBM2:%String,ZKKSBM3:%String,SZBQ:%String,CYSJ:%String,CYKSBM:%String,SJZYTS:%String,CYFS:%String,RYQK:%String,RYQWYZZ:%String,QZRQ:%String,YYGRMC:%String,YYGRJG:%String,MZCYZD:%String,RYCYZD:%String,SQSHZD:%String,LCBLZD:%String,FSBLZD:%String,SSZD:%String,SSZDBM:%String,YWGM:%String,HBSAG_JG:%String,HCVab_JG:%String,HIVab_JG:%String,QJCS:%String,CGCS:%String,SFCXWJN:%String,SSDYL:%String,XX:%String,HXBSXL:%String,XXBSXL:%String,XJSXL:%String,QXSXL:%String,QTSXL:%String,SXFY:%String,CRBBG:%String,ZLBG:%String,XSEBG:%String,SWBG:%String,QTBG:%String,SZ:%String,SZQX:%String,SZQXDW:%String,SJBL:%String,SJ:%String,RSMDSC:%String,XSEJBSC:%String,CHCYL:%String,XSE_XB:%String,XSE_TZ:%String,ZRYSGH:%String,ZRYSXM:%String,ZZYSGH:%String,ZZYSXM:%String,ZYYSGH:%String,ZYYSXM:%String,HSZGH:%String,HSZXM:%String,ZRHSGH:%String,ZRHSXM:%String,JXYSGH:%String,JXYSXM:%String,SXYSGH:%String,SXYSXM:%String,BMYGH:%String,BMYXM:%String,BAZL:%String,ZKYSGH:%String,ZKYSXM:%String,ZKHSGH:%String,ZKHSZM:%String,ZKRQ:%String,BLH:%String,SWGBYY:%String,SWSJ:%String,MZYSGH:%String,MZYSXM:%String,SYFY:%String,SFKYBA:%String,LYFS:%String,NJSYYMC:%String,ZZYJH_31:%String,RYQHMSJ:%String,RYHHMSJ:%String,ZYF:%String,ZLF:%String,ZHF:%String,HLF:%String,SSCLF:%String,JCF:%String,HYF:%String,TSF:%String,SPF:%String,SXF:%String,SYF:%String,XYF:%String,ZCYF:%String,ZCAF:%String,QTF:%String,ZFY:%String,ZFJE:%String,YLFWF:%String,ZLCZF:%String,BLZDF:%String,SYSZDF:%String,YXXZDF:%String,LCZDXMF:%String,FSSZLXMF:%String,LCWLZLF:%String,SSZLF:%String,MZF:%String,SSF:%String,KFF:%String,ZYZLF:%String,KJYWFY:%String,XF:%String,BDBZPF:%String,QDBZPF:%String,NXYZZPF:%String,XBYZZPF:%String,JCYYCLF:%String,ZLYYCLF:%String,SSYYCLF:%String,QTF_1:%String,KZRXM:%String,KZRGH:%String,FZRYSXM:%String,FZRYSGH:%String,ZLLB:%String,SSLCLJ:%String,ISJGZYZJ:%String,ISZYZLSB:%String,ISZYZLJS:%String,ISBZSH:%String,ZYBZLZF:%String,ZYBZLZHZF:%String,ZYZDF:%String,ZYWZF:%String,ZYGSF:%String,ZCYJFF:%String,ZYTNZLF:%String,ZYGCZLF:%String,ZYTSZLF:%String,ZYQTF:%String,ZYTSTPF:%String,ZYZJF:%String,BZ:%String,MJ:%String,XGBZ:%String,YLYL1:%String,YLYL2:%String,", SELECTMODE = "RUNTIME") [ SqlProc ]
{
}

ClassMethod GetINPUTCASEFIRPExecute(ByRef qHandle As %Binary, DateFrom As %String, DateTo As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:($g(AEpisodeID) = "") $$$OK
	
	s AGlossaryCategoryID = "HDSD00.12"
	
	s StartDate	= $g(DateFrom)
	s EndDate	= $g(DateTo)
	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StartDate)," ",1)
	s EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndDate)," ",1)
	i EndDate<StartDate Set qHandle=$lb(0,repid,0)	Quit $$$OK
	
	s AEpisodeID=""
	
	f tmpdate=+StartDate:1:+EndDate
	{
		s AEpisodeID=""
		for {
		s AEpisodeID= $o(^PAADMi("DischDate",tmpdate,AEpisodeID))
		q:(AEpisodeID = "")
		
		s StandDataArry = ..GetDataByGlossaryCategory(AEpisodeID,AGlossaryCategoryID)
		s (JZLSH,YLJGDM,RYSJ,RYLX,KH,KLX,BXLX,YLFFFS,ZYCS,BAH,CH,RYBQ,CYBQ,XM,XB,CSNY,XSECSTZ,XSERYTZ,HYZK,MZ,GJ,JG,CSD,SFZ,LXDH,GZDW,GZDWDH,GZDWYB,ZYBM,JZD,XZZDH,XZZYB,HKDZ,HKDH,HKYB,DQBM,QXBM,JDBM,LXRXM,LXRGX,LXRDZ,LXRDH,LXRTXDZ,RYKSBM,ZKKSBM1,ZKKSBM2,ZKKSBM3,SZBQ,CYSJ,CYKSBM,SJZYTS,CYFS,RYQK,RYQWYZZ,QZRQ,YYGRMC,YYGRJG,MZCYZD,RYCYZD,SQSHZD,LCBLZD,FSBLZD,SSZD,SSZDBM,YWGM,HBSAGJG,HCVabJG,HIVabJG,QJCS,CGCS,SFCXWJN,SSDYL,XX,HXBSXL,XXBSXL,XJSXL,QXSXL,QTSXL,SXFY,CRBBG,ZLBG,XSEBG,SWBG,QTBG,SZ,SZQX,SZQXDW,SJBL,SJ,RSMDSC,XSEJBSC,CHCYL,XSEXB,XSETZ,ZRYSGH,ZRYSXM,ZZYSGH,ZZYSXM,ZYYSGH,ZYYSXM,HSZGH,HSZXM,ZRHSGH,ZRHSXM,JXYSGH)=""
		s (JXYSXM,SXYSGH,SXYSXM,BMYGH,BMYXM,BAZL,ZKYSGH,ZKYSXM,ZKHSGH,ZKHSZM,ZKRQ,BLH,SWGBYY,SWSJ,MZYSGH,MZYSXM,SYFY,SFKYBA,LYFS,NJSYYMC,ZZYJH31,RYQHMSJ,RYHHMSJ,ZYF,ZLF,ZHF,HLF,SSCLF,JCF,HYF,TSF,SPF,SXF,SYF,XYF,ZCYF,ZCAF,QTF,ZFY,ZFJE,YLFWF,ZLCZF,BLZDF,SYSZDF,YXXZDF,LCZDXMF,FSSZLXMF,LCWLZLF,SSZLF,MZF,SSF,KFF,ZYZLF,KJYWFY,XF,BDBZPF,QDBZPF,NXYZZPF,XBYZZPF,JCYYCLF,ZLYYCLF,SSYYCLF,QTF1,KZRXM,KZRGH,FZRYSXM,FZRYSGH,ZLLB,SSLCLJ,ISJGZYZJ,ISZYZLSB,ISZYZLJS,ISBZSH,ZYBZLZF,ZYBZLZHZF,ZYZDF,ZYWZF,ZYGSF,ZCYJFF,ZYTNZLF,ZYGCZLF,ZYTSZLF,ZYQTF,ZYTSTPF,ZYZJF,BZ,MJ,XGBZ,YLYL1,YLYL2)=""
	
		s JZLSH= AEpisodeID //住院就诊流水号
		s YLJGDM= StandDataArry.GetAt("HDSD00.12.134") //医疗机构代码
		s RYSJ= StandDataArry.GetAt("HDSD00.12.096") //入院时间
		s RYLX= StandDataArry.GetAt("HDSD00.12.097") //入院类型（途径）
		s KH= StandDataArry.GetAt("HDSD00.12.055") //卡号
		s KLX= StandDataArry.GetAt("HDSD00.12.056") //卡类型
		s BXLX= "" //保险类型
		s YLFFFS= StandDataArry.GetAt("HDSD00.12.132") //医疗付费方式
		s ZYCS= StandDataArry.GetAt("HDSD00.12.166") //住院次数
		s BAH= StandDataArry.GetAt("HDSD00.12.007") //病案号
		s CH= "" //床号
		s RYBQ= StandDataArry.GetAt("HDSD00.12.094") //入院病区（房）
		s CYBQ= StandDataArry.GetAt("HDSD00.12.018") //出院病区（房）
		s XM= StandDataArry.GetAt("HDSD00.12.125") //姓名
		s XB= StandDataArry.GetAt("HDSD00.12.124") //性别
		s CSNY= StandDataArry.GetAt("HDSD00.12.015") //出生日期
		s XSECSTZ= StandDataArry.GetAt("HDSD00.12.122") //新生儿出生体重
		s XSERYTZ= StandDataArry.GetAt("HDSD00.12.123") //新生儿入院体重
		s HYZK= StandDataArry.GetAt("HDSD00.12.057") //婚姻状况
		s MZ= StandDataArry.GetAt("HDSD00.12.088") //民族
		s GJ= StandDataArry.GetAt("HDSD00.12.043") //国籍
		s JG= StandDataArry.GetAt("HDSD00.12.058") //籍贯
		s CSD= StandDataArry.GetAt("HDSD00.12.012") //出生地
		s SFZ= StandDataArry.GetAt("HDSD00.12.055") //身份证号
		s LXDH= StandDataArry.GetAt("HDSD00.12.071") //联系电话
		s GZDW= StandDataArry.GetAt("HDSD00.12.042") //工作单位
		s GZDWDH= StandDataArry.GetAt("HDSD00.12.041") //工作单位电话
		s GZDWYB= StandDataArry.GetAt("HDSD00.12.134") //工作单位邮编
		s ZYBM= StandDataArry.GetAt("HDSD00.12.134") //职业
		s JZD= StandDataArry.GetAt("HDSD00.12.134") //居住地（现住址）
		s XZZDH= StandDataArry.GetAt("HDSD00.12.134") //现住址电话
		s XZZYB= StandDataArry.GetAt("HDSD00.12.040") //现住址邮编
		s HKDZ= StandDataArry.GetAt("HDSD00.12.050") //户口地址
		s HKDH= StandDataArry.GetAt("HDSD00.12.049") //户口电话
		s HKYB= StandDataArry.GetAt("HDSD00.12.054") //户口邮编
		s DQBM= StandDataArry.GetAt("HDSD00.12.118") //地区
		s QXBM= StandDataArry.GetAt("HDSD00.12.119") //区县
		s JDBM= StandDataArry.GetAt("HDSD00.12.115") //街道
		s LXRXM= StandDataArry.GetAt("HDSD00.12.072") //联系人姓名
		s LXRGX= StandDataArry.GetAt("HDSD00.12.073") //联系人关系
		s LXRDZ= StandDataArry.GetAt("HDSD00.12.067") //联系人地址
		s LXRDH= StandDataArry.GetAt("HDSD00.12.134") //联系人电话
		s LXRTXDZ= StandDataArry.GetAt("HDSD00.12.071") //联系人通信地址
		s RYKSBM= StandDataArry.GetAt("HDSD00.12.095") //入院科室编码
		s ZKKSBM1= StandDataArry.GetAt("HDSD00.12.171") //转科科室编码1
		s ZKKSBM2= "" //转科科室编码2
		s ZKKSBM3= "" //转科科室编码3
		s SZBQ= "" //所转病区
		s CYSJ= StandDataArry.GetAt("HDSD00.12.020") //出院时间
		s CYKSBM= StandDataArry.GetAt("HDSD00.12.019") //出院科室编码
		s SJZYTS= StandDataArry.GetAt("HDSD00.12.098") //实际住院天数
		s CYFS= StandDataArry.GetAt("HDSD00.12.064") //出院方式
		s RYQK= StandDataArry.GetAt("HDSD00.12.029") //入院时情况
		s RYQWYZZ= "" //入院前经外院诊治
		s QZRQ= StandDataArry.GetAt("HDSD00.12.096") //确诊日期
		s YYGRMC="" //医院感染名称
		s YYGRJG= "" //医院感染结果
		s MZCYZD= StandDataArry.GetAt("HDSD00.12.084") //门诊出院诊断符合编码
		s RYCYZD= StandDataArry.GetAt("HDSD00.12.027") //入院出院诊断符合编码
		s SQSHZD= StandDataArry.GetAt("HDSD00.12.084") //术前术后诊断符合编码
		s LCBLZD= StandDataArry.GetAt("HDSD00.12.084") //临床病理诊断符合编码
		s FSBLZD= StandDataArry.GetAt("HDSD00.12.084") //放射病理诊断符合编码
		s SSZD= StandDataArry.GetAt("HDSD00.12.111") //损伤中毒的外部因素
		s SSZDBM= StandDataArry.GetAt("HDSD00.12.112") //损伤中毒的外部原因的疾病编码
		s YWGM= StandDataArry.GetAt("HDSD00.12.044") //药物过敏
		s HBSAGJG= "" //HBSAG检查结果编码
		s HCVabJG= "" //HCVab检查结果编码
		s HIVabJG= "" //HIVab检查结果编码
		s QJCS= StandDataArry.GetAt("HDSD00.12.569") //抢救次数
		s CGCS= StandDataArry.GetAt("HDSD00.12.570") //成功次数
		s SFCXWJN= StandDataArry.GetAt("HDSD00.12.567") //住院是否出现危重、急症、疑难
		s SSDYL= "" //手术治疗检查诊断为本院第一例
		s XX= StandDataArry.GetAt("HDSD00.12.003") //血型
		s HXBSXL= "" //红细胞输血量
		s XXBSXL= "" //血小板输血量
		s XJSXL= "" //血浆输血量
		s QXSXL= "" //全血输血量
		s QTSXL= "" //其它输血量
		s SXFY= "" //有输血反应
		s CRBBG= "" //有传染病报告
		s ZLBG= "" //有肿瘤报告
		s XSEBG= "" //有新生儿死亡报告
		s SWBG= "" //孕产妇死亡报告
		s QTBG= "" //有其它报告
		s SZ= StandDataArry.GetAt("HDSD00.12.571") //是否随诊
		s SZQX= StandDataArry.GetAt("HDSD00.12.572") //随诊期限
		s SZQXDW= "" //随诊期限单位
		s SJBL= "" //是否示教病例
		s SJ= StandDataArry.GetAt("HDSD00.12.596") //（死亡患者）是否尸检
		s RSMDSC= "" //是否妊娠梅毒筛查
		s XSEJBSC= "" //新生儿疾病筛查
		s CHCYL= "" //产后出血量
		s XSEXB= "" //新生儿性别
		s XSETZ= StandDataArry.GetAt("HDSD00.12.122") //新生儿体重
		s ZRYSGH= "" //主任医师工号
		s ZRYSXM= StandDataArry.GetAt("HDSD00.12.164") //主任医师姓名
		s ZZYSGH= "" //主治医师工号
		s ZZYSXM= StandDataArry.GetAt("HDSD00.12.165") //主治医师姓名
		s ZYYSGH= "" //住院医师工号
		s ZYYSXM= StandDataArry.GetAt("HDSD00.12.168") //住院医师姓名
		s HSZGH= "" //护士长工号
		s HSZXM= StandDataArry.GetAt("HDSD00.12.135") //护士长姓名
		s ZRHSGH= "" //责任护士工号
		s ZRHSXM= StandDataArry.GetAt("HDSD00.12.135") //责任护士姓名
		s JXYSGH= "" //进修医师工号
		s JXYSXM= StandDataArry.GetAt("HDSD00.12.061") //进修医师姓名
		s SXYSGH= "" //实习医师工号
		s SXYSXM= StandDataArry.GetAt("HDSD00.12.100") //实习医师姓名
		s BMYGH= "" //编码员工号
		s BMYXM= StandDataArry.GetAt("HDSD00.12.005") //编码员姓名
		s BAZL= StandDataArry.GetAt("HDSD00.12.008") //病案质量
		s ZKYSGH= "" //质控医师工号
		s ZKYSXM= StandDataArry.GetAt("HDSD00.12.143") //质控医师姓名
		s ZKHSGH= "" //质控护士工号
		s ZKHSZM= StandDataArry.GetAt("HDSD00.12.141") //质控护士姓名
		s ZKRQ= StandDataArry.GetAt("HDSD00.12.142") //质控日期
		s BLH= StandDataArry.GetAt("HDSD00.12.009") //病理号
		s SWGBYY= "" //死亡根本原因
		s SWSJ= "" //死亡时间
		s MZYSGH= "" //门诊医师工号
		s MZYSXM= "" //门诊医师姓名
		s SYFY= StandDataArry.GetAt("HDSD00.12.599") //输液反应
		s SFKYBA= "" //是否为科研病案
		s LYFS= StandDataArry.GetAt("HDSD00.12.064") //离院方式
		s NJSYYMC= StandDataArry.GetAt("HDSD00.12.089") //离院后拟接收医疗机构名称
		s ZZYJH31= StandDataArry.GetAt("HDSD00.12.016") //是否有出院31天内再住院计划
		s RYQHMSJ= StandDataArry.GetAt("HDSD00.12.077") //颅脑损伤患者入院前昏迷时间
		s RYHHMSJ= StandDataArry.GetAt("HDSD00.12.074") //颅脑损伤患者入院后昏迷时间
		s ZYF= StandDataArry.GetAt("HDSD00.12.169") //住院费
		s ZLF= StandDataArry.GetAt("HDSD00.12.174") //诊疗费
		s ZHF= StandDataArry.GetAt("HDSD00.12.147") //治疗费
		s HLF= StandDataArry.GetAt("HDSD00.12.172") //护理费
		s SSCLF= StandDataArry.GetAt("HDSD00.12.046") //手术材料费
		s JCF= StandDataArry.GetAt("HDSD00.12.045") //检查费
		s HYF= "" //化验费
		s TSF= "" //透视费
		s SPF= "" //摄片费
		s SXF= "" //输血费
		s SYF= "" //输氧费
		s XYF= StandDataArry.GetAt("HDSD00.12.113") //西药费
		s ZCYF= StandDataArry.GetAt("HDSD00.12.151") //中成药费
		s ZCAF= StandDataArry.GetAt("HDSD00.12.150") //中草药费
		s QTF= StandDataArry.GetAt("HDSD00.12.092") //其他费用
		s ZFY= StandDataArry.GetAt("HDSD00.12.169") //总费用
		s ZFJE= StandDataArry.GetAt("HDSD00.12.170") //自付金额
		s YLFWF= StandDataArry.GetAt("HDSD00.12.174") //一般医疗服务费
		s ZLCZF= StandDataArry.GetAt("HDSD00.12.177") //一般治疗操作费
		s BLZDF= StandDataArry.GetAt("HDSD00.12.136") //病理诊断费
		s SYSZDF= StandDataArry.GetAt("HDSD00.12.138") //实验室诊断费
		s YXXZDF= StandDataArry.GetAt("HDSD00.12.139") //影像学诊断费
		s LCZDXMF= StandDataArry.GetAt("HDSD00.12.137") //临床诊断项目费
		s FSSZLXMF= StandDataArry.GetAt("HDSD00.12.145") //非手术治疗项目费
		s LCWLZLF= "" //临床物理治疗费
		s SSZLF= StandDataArry.GetAt("HDSD00.12.147") //手术治疗费
		s MZF= StandDataArry.GetAt("HDSD00.12.148") //麻醉费
		s SSF= StandDataArry.GetAt("HDSD00.12.149") //手术费
		s KFF= StandDataArry.GetAt("HDSD00.12.062") //康复费
		s ZYZLF= StandDataArry.GetAt("HDSD00.12.157") //中医治疗费
		s KJYWFY= StandDataArry.GetAt("HDSD00.12.114") //抗菌药物费用
		s XF= StandDataArry.GetAt("HDSD00.12.130") //血费
		s BDBZPF= StandDataArry.GetAt("HDSD00.12.126") //白蛋白类制品费
		s QDBZPF= StandDataArry.GetAt("HDSD00.12.128") //球蛋白类制品费
		s NXYZZPF= StandDataArry.GetAt("HDSD00.12.127") //凝血因子类制品费
		s XBYZZPF= StandDataArry.GetAt("HDSD00.12.129") //细胞因子类制品费
		s JCYYCLF= StandDataArry.GetAt("HDSD00.12.045") //检查用一次性医用材料费
		s ZLYYCLF= StandDataArry.GetAt("HDSD00.12.047") //治疗用一次性医用材料费
		s SSYYCLF= StandDataArry.GetAt("HDSD00.12.046") //手术用一次性医用材料费
		s QTF1= StandDataArry.GetAt("HDSD00.12.092") //其他费
		s KZRXM= StandDataArry.GetAt("HDSD00.12.575") //科主任姓名
		s KZRGH= "" //科主任工号
		s FZRYSXM= StandDataArry.GetAt("HDSD00.12.576") //副主任医师姓名
		s FZRYSGH= "" //副主任医师工号
		s ZLLB= StandDataArry.GetAt("HDSD00.12.144") //治疗类别
		s SSLCLJ= StandDataArry.GetAt("HDSD00.12.099") //实施临床路径
		s ISJGZYZJ= StandDataArry.GetAt("HDSD00.12.101") //使用医疗机构中药制剂
		s ISZYZLSB= StandDataArry.GetAt("HDSD00.12.103") //使用中医诊疗设备
		s ISZYZLJS= StandDataArry.GetAt("HDSD00.12.102") //使用中医诊疗技术
		s ISBZSH= StandDataArry.GetAt("HDSD00.12.006") //辨证施护
		s ZYBZLZF= StandDataArry.GetAt("HDSD00.12.175") //中医辨证论治费
		s ZYBZLZHZF= StandDataArry.GetAt("HDSD00.12.177") //中医辨证论治会诊费
		s ZYZDF= StandDataArry.GetAt("HDSD00.12.157") //中医诊断费
		s ZYWZF= StandDataArry.GetAt("HDSD00.12.163") //中医外治费
		s ZYGSF= StandDataArry.GetAt("HDSD00.12.160") //中医骨伤费
		s ZCYJFF= StandDataArry.GetAt("HDSD00.12.158") //针刺与灸法费
		s ZYTNZLF= StandDataArry.GetAt("HDSD00.12.162") //中医推拿治疗费
		s ZYGCZLF= StandDataArry.GetAt("HDSD00.12.159") //中医肛肠治疗费
		s ZYTSZLF= StandDataArry.GetAt("HDSD00.12.161") //中医特殊治疗费
		s ZYQTF= StandDataArry.GetAt("HDSD00.12.153") //中医其他费
		s ZYTSTPF= StandDataArry.GetAt("HDSD00.12.155") //中药特殊调配加工费
		s ZYZJF= StandDataArry.GetAt("HDSD00.12.152") //医疗机构中药制剂费
		s BZ= "" //备注
		s MJ= "" //密级
		s XGBZ= "" //修改标志
		s YLYL1= "" //预留一
		s YLYL2= "" //预留二

    
		s Data = $lb(JZLSH,YLJGDM,RYSJ,RYLX,KH,
				KLX,BXLX,YLFFFS,ZYCS,BAH,
				CH,RYBQ,CYBQ,XM,XB,
				CSNY,XSECSTZ,XSERYTZ,HYZK,MZ,
				GJ,JG,CSD,SFZ,LXDH,
				GZDW,GZDWDH,GZDWYB,ZYBM,JZD,
				XZZDH,XZZYB,HKDZ,HKDH,HKYB,
				DQBM,QXBM,JDBM,LXRXM,LXRGX,
				LXRDZ,LXRDH,LXRTXDZ,RYKSBM,ZKKSBM1,
				ZKKSBM2,ZKKSBM3,SZBQ,CYSJ,CYKSBM,
				SJZYTS,CYFS,RYQK,RYQWYZZ,QZRQ,
				YYGRMC,YYGRJG,MZCYZD,RYCYZD,SQSHZD,
				LCBLZD,FSBLZD,SSZD,SSZDBM,YWGM,
				HBSAGJG,HCVabJG,HIVabJG,QJCS,CGCS,
				SFCXWJN,SSDYL,XX,HXBSXL,XXBSXL,
				XJSXL,QXSXL,QTSXL,SXFY,CRBBG,
				ZLBG,XSEBG,SWBG,QTBG,SZ,
				SZQX,SZQXDW,SJBL,SJ,RSMDSC,
				XSEJBSC,CHCYL,XSEXB,XSETZ,ZRYSGH,
				ZRYSXM,ZZYSGH,ZZYSXM,ZYYSGH,ZYYSXM,
				HSZGH,HSZXM,ZRHSGH,ZRHSXM,JXYSGH,
				JXYSXM,SXYSGH,SXYSXM,BMYGH,BMYXM,
				BAZL,ZKYSGH,ZKYSXM,ZKHSGH,ZKHSZM,
				ZKRQ,BLH,SWGBYY,SWSJ,MZYSGH,
				MZYSXM,SYFY,SFKYBA,LYFS,NJSYYMC,
				ZZYJH31,RYQHMSJ,RYHHMSJ,ZYF,ZLF,
				ZHF,HLF,SSCLF,JCF,HYF,
				TSF,SPF,SXF,SYF,XYF,
				ZCYF,ZCAF,QTF,ZFY,ZFJE,
				YLFWF,ZLCZF,BLZDF,SYSZDF,YXXZDF,
				LCZDXMF,FSSZLXMF,LCWLZLF,SSZLF,MZF,
				SSF,KFF,ZYZLF,KJYWFY,XF,
				BDBZPF,QDBZPF,NXYZZPF,XBYZZPF,JCYYCLF,
				ZLYYCLF,SSYYCLF,QTF1,KZRXM,KZRGH,
				FZRYSXM,FZRYSGH,ZLLB,SSLCLJ,ISJGZYZJ,
				ISZYZLSB,ISZYZLJS,ISBZSH,ZYBZLZF,ZYBZLZHZF,
				ZYZDF,ZYWZF,ZYGSF,ZCYJFF,ZYTNZLF,
				ZYGCZLF,ZYTSZLF,ZYQTF,ZYTSTPF,ZYZJF,
				BZ,MJ,XGBZ,YLYL1,YLYL2)
	
	s ^CacheTemp(repid,ind) = Data
	s ind = ind + 1
	}
	}
	q $$$OK
}

ClassMethod GetINPUTCASEFIRPFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetINPUTCASEFIRPExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if ind="" {	
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	} else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetINPUTCASEFIRPClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetINPUTCASEFIRPExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// Creator:	yejian
/// CreatDate:  2012-7-9
/// Desc:		出院小结
/// Input：		aCategoryID：术语范畴Id
/// Return：	EPRservice.dataset.EDataElementDataset: 术语集dataset
/// Debug:		d ##Class(%ResultSet).RunQuery("DHCEWELL.EPRQueryTemDatasSDYT","GetOUTPUTSUMMARY",58)
Query GetOUTPUTSUMMARY(DateFrom As %String, DateTo As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "JZLSH:%String,YLJGDM:%String,KS:%String,KSMC:%String,KH:%String,KLX:%String,CH:%String,XM:%String,XB:%String,NL:%String,RYSJ:%String,CYSJ:%String,ZYTS:%String,MZZD:%String,RYZD:%String,CYZD:%String,RYZZTZ:%String,JCHZ:%String,TSJC:%String,ZLGC:%String,HBZ:%String,CYQK:%String,CYYZ:%String,ZLJG:%String,ZLJGMS:%String,ZZYSGH:%String,ZZYSXM:%String,ZYYSGH:%String,ZYYSXM:%String,YYZTB1:%String,YYZTB2:%String,WJLJ:%String,XGBZ:%String,MJ:%String,YLYL1:%String,YLYL2:%String") [ SqlProc ]
{
}

ClassMethod GetOUTPUTSUMMARYExecute(ByRef qHandle As %Binary, DateFrom As %String, DateTo As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:($g(AEpisodeID) = "") $$$OK
	
	s AGlossaryCategoryID = "HDSD00.16"
	s StartDate	= $g(DateFrom)
	s EndDate	= $g(DateTo)
	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StartDate)," ",1)
	s EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndDate)," ",1)
	i EndDate<StartDate Set qHandle=$lb(0,repid,0)	Quit $$$OK
	
	s AEpisodeID=""
	
	f tmpdate=+StartDate:1:+EndDate
	{
		s AEpisodeID=""
		for {
		s AEpisodeID= $o(^PAADMi("DischDate",tmpdate,AEpisodeID))
		q:(AEpisodeID = "")
		s StandDataArry = ..GetDataByGlossaryCategory(AEpisodeID,AGlossaryCategoryID)
		s (JZLSH,YLJGDM,KS,KSMC,KH,KLX,CH,XM,XB,NL,RYSJ,CYSJ,ZYTS,MZZD,RYZD,CYZD,RYZZTZ,JCHZ,TSJC,ZLGC,HBZ,CYQK,CYYZ,ZLJG,ZLJGMS,ZZYSGH,ZZYSXM,ZYYSGH,ZYYSXM,YYZTB1,YYZTB2,WJLJ,XGBZ,MJ,YLYL1,YLYL2)=""
	
		s JZLSH= AEpisodeID //住院就诊流水号
		s YLJGDM= "" //医疗机构代码
		s KS= "" //科室
		s KSMC= StandDataArry.GetAt("HDSD00.16.022") //科室名称
		s KH= "" //卡号
		s KLX= "" //卡类型
		s CH= StandDataArry.GetAt("HDSD00.16.001") //床号
		s XM= StandDataArry.GetAt("HDSD00.16.019") //姓名
		s XB= StandDataArry.GetAt("HDSD00.16.041") //性别
		s NL= StandDataArry.GetAt("HDSD00.16.026") //年龄
		s RYSJ= StandDataArry.GetAt("HDSD00.16.031") //入院时间
		s CYSJ= StandDataArry.GetAt("HDSD00.16.005") //出院时间
		s ZYTS= StandDataArry.GetAt("HDSD00.16.036") //住院天数
		s MZZD= StandDataArry.GetAt("HDSD00.16.030") //门诊诊断
		s RYZD= StandDataArry.GetAt("HDSD00.16.033") //入院诊断
		s CYZD= StandDataArry.GetAt("HDSD00.16.009") //出院诊断
		s RYZZTZ= StandDataArry.GetAt("HDSD00.16.030") //入院时主要症状及体征
		s JCHZ= StandDataArry.GetAt("HDSD00.16.042") //实验室检查及主要会诊
		s TSJC= StandDataArry.GetAt("HDSD00.16.042") //住院期间特殊检查
		s ZLGC= StandDataArry.GetAt("HDSD00.16.045") //诊疗过程
		s HBZ= "" //合并症
		s CYQK= StandDataArry.GetAt("HDSD00.16.004") //出院时情况
		s CYYZ= StandDataArry.GetAt("HDSD00.16.007") //出院医嘱
		s ZLJG= StandDataArry.GetAt("HDSD00.16.047") //治疗结果
		s ZLJGMS= "" //治疗结果描述
		s ZZYSGH= "" //主治医师工号
		s ZZYSXM= StandDataArry.GetAt("HDSD00.16.035") //主治医师姓名
		s ZYYSGH= "" //住院医师工号
		s ZYYSXM= StandDataArry.GetAt("HDSD00.16.053") //住院医师姓名
		s YYZTB1= "" //医院自填报内容1
		s YYZTB2= "" //医院自填报内容2
		s WJLJ= "" //文件链接
		s XGBZ= "" //修改标志
		s MJ= "" //密级
		s YLYL1= "" //预留一
		s YLYL2= "" //预留二

	
	
		s Data = $lb(JZLSH,YLJGDM,KS,KSMC,KH,
					KLX,CH,XM,XB,NL,
					RYSJ,CYSJ,ZYTS,MZZD,RYZD,
					CYZD,RYZZTZ,JCHZ,TSJC,ZLGC,
					HBZ,CYQK,CYYZ,ZLJG,ZLJGMS,
					ZZYSGH,ZZYSXM,ZYYSGH,ZYYSXM,YYZTB1,
					YYZTB2,WJLJ,XGBZ,MJ,YLYL1,
					YLYL2)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1
	}
	}
	q $$$OK
}

ClassMethod GetOUTPUTSUMMARYFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOUTPUTSUMMARYExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if ind="" {	
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	} else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetOUTPUTSUMMARYClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOUTPUTSUMMARYExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// Desc:	获取指定术语集范畴下的所有术语值
/// Input：	AEpisodeID : 就诊指针
/// 		ACategoryInternalID : 指定术语集范畴内部标识符
/// Output:	术语值数组
/// Debug:	w ##Class(EPRservice.BOScatterData).GetDataByGlossaryCategory("1","1")
ClassMethod GetDataByGlossaryCategory(AEpisodeID As %String, ACategoryInternalID As %String, instanceDataID As %String = "") As %ArrayOfDataTypes
{
	s glossaryCategoryID = $O(^DHCEPRM.GlossaryCategoryI("IdxOnInternalID"," "_ACategoryInternalID,""))
	q:(glossaryCategoryID="") ""

	s retArray = ##Class(%ArrayOfDataTypes).%New()

	s glossaryID = ""
	for {
		s glossaryID = $O(^DHCEPRM.GlossaryI("IdxCategoryID"," "_glossaryCategoryID,glossaryID))
		q:(glossaryID="")
	
		s objGlossary = ##Class(EPRmeta.Glossary).%OpenId(glossaryID)
		continue:(objGlossary="")
	
		s internalID = objGlossary.InternalID
		;s value = ##class(EPRservice.BOScatterData).GetScatterDataByGlossaryID(AEpisodeID,glossaryID)
		
		//通过注册号，术语rowId获取业务数据
		s strDataValue = ..GetScatterDataByGlossaryID(AEpisodeID,glossaryID,instanceDataID)
		if (strDataValue ="")
		{
			s strDataValue = ##class(EPRservice.BOScatterData).GetScatterDataByGlossaryID(AEpisodeID,glossaryID)
		}
		/*S objStandData =  ##Class(EPRservice.entity.EStandDataInfo).%New()
		S objStandData.strInternalID = internalID
		s strValue=$tr(value,"<","(")
		s strValue=$tr(strValue,">",")")
		S objStandData.displayName = strValue
		*/

		d retArray.SetAt(strDataValue, internalID)
	
	}
	q retArray
}

/// Desc: 	使用术语集取电子病历打散数据
/// Return:	metaItemInfo$|value&|metaItemInfo$|value
/// Debug: 	w ##class(EPRservice.BLL.BLDataETranFactory).GetScatterDataByGlossaryID("58","1811","810||2")
ClassMethod GetScatterDataByGlossaryID(AEpisodeID As %String, AGlossaryID As %String, instanceDataID As %String = "") As %String
{
	s ret = ""
	q:($d(AEpisodeID) = 0)||(AEpisodeID = "") ret
	q:($d(AGlossaryID) = 0)||(AGlossaryID = "") ret
	s objGlossary = ##Class(EPRmeta.Glossary).%OpenId(AGlossaryID)
	q:(objGlossary = "") ret
	
	s name = objGlossary.Name
	s type = objGlossary.GlossaryType
	
	if ($zcvt(type,"U") = "TG")
	{
		s rowID = ""
		for {
			s rowID = $o(^DHCEPRM.GlossaryItemI("IdxGlossaryID",AGlossaryID,rowID))
			q:(rowID = "")
			
			s objItem = ##Class(EPRmeta.GlossaryItem).%OpenId(rowID)
			
			s itemCode = objItem.ItemCode
			s valueType = objItem.ValueType
			s templateID = objItem.TemplateID
			s ret = ""
			if (instanceDataID = ""){
			s ret = ##Class(EPRservice.BOScatterData).GetScatterData(AEpisodeID,templateID,itemCode,valueType)
			}else{
			s ret = ##Class(EPRservice.BOScatterData).GetMultipleScatterData(AEpisodeID,templateID,itemCode,instanceDataID,valueType)
			}
			q:(ret '= "")&&(ret '= "Null")
		}	
	}
	else
	{
		s parGlossaryID = objGlossary.ParentID
		q:(parGlossaryID = "") ret

		s objParGlossary = ##Class(EPRmeta.Glossary).%OpenId(parGlossaryID)
		q:(objParGlossary = "") ret
			
		s parRowID = ""
		for {
			s parRowID = $o(^DHCEPRM.GlossaryItemI("IdxGlossaryID",parGlossaryID,parRowID))
			q:(parRowID = "")
			
			s objParItem = ##Class(EPRmeta.GlossaryItem).%OpenId(parRowID)
			
			s parItemCode = objParItem.ItemCode
			s parValueType = objParItem.ValueType
			s parTemplateID = objParItem.TemplateID

			//s parItemValue = ##Class(EPRservice.BOScatterData).GetScatterData(AEpisodeID,parTemplateID,parItemCode,parValueType)
			//if (parItemValue = "")
			//{
			//	q
			//}
			s kbRowID = ""
			for {
				s kbRowID = $o(^DHCEPRM.GlossaryKBItemI("IdxGlossaryID",AGlossaryID,kbRowID))
				q:(kbRowID = "")
			
				s objParItem = ##Class(EPRmeta.GlossaryKBItem).%OpenId(kbRowID)
				s curItemCode = objParItem.ItemCode
				s curValueType = objParItem.ValueType
				s kbPartNo = objParItem.KBPartNo
				S KBNodeID = objParItem.KBNodeID
			
				s curTextSimpleRowID= ""
				for
				{
					s curTextSimpleRowID = $o(^DHCEPRI.ITextDescSimpleI("IdxForUpdate"," "_instanceDataID," "_parItemCode," "_KBNodeID," "_kbPartNo," "_curItemCode,curTextSimpleRowID))
					q:(curTextSimpleRowID = "")
					s curItemType = $e($tr(curItemCode," ",""),0,1)
					s curTextSimpleValue = ##Class(EPRservice.BOScatterData).GetITextDescSimpleValue(curTextSimpleRowID,curItemType,$tr(curValueType," ",""))
					if (curTextSimpleValue '= "")
					{
						s ret = curTextSimpleValue
						q	
					}	
				}	
			}	
		}
	}
	s:(ret="Null") ret = ""
	q ret
}

}
