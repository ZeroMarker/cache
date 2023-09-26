Import SQLUser

/// Creator:    dws
/// CreateDate: 2017-05-15
/// Descript:   用药与指标监测查询
/// Class web.DHCSTPHCMedIndexMonitoringInquiry Extends %Persistent [ Not ProcedureBlock ]
/// { 
Class web.DHCSTPHCMedIndexMonitoringInquiry Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// 药品指标维护界面药品信息
/// w ##class(web.DHCSTPHCMedIndexMonitoringInquiry).DrugInfo("20","1","")
ClassMethod DrugInfo(rows As %String, page As %String, code As %String, desc As %String, hospID = "")
{
	n (rows, page,code,desc,hospID)
	s End = page*rows
    s Start = (page-1)*rows+1  
    S pid=##class(web.DHCSTPHCMCOMMON).GetPID()
	d ..killTmpGlobal(pid)
	s h=0,count=0
	s inciRowId=""
	s inciArcimDr=""
	s BDPHospAut=##class(PHA.FACE.IN.Com).GetHospAut() //医院级别授权是否开启
	f  s inciRowId=$o(^INCI(inciRowId)) q:(inciRowId="")  d
	.q:'$d(^INCI(+inciRowId,1))
	.q:(hospID'="")&&(##class(PHA.FACE.IN.Com).GetShowDataFlag("INC_Itm",inciRowId,hospID)="N")         //(BDPHospAut="Y")&('$d(^ITMADDHOP(0,"HospInc",hospID,+inciRowId))) //医院级别授权
	.s inciArcimDr=$p(^INCI(inciRowId,1),"^",3)
	.q:inciArcimDr=""
	.s sub=$p(inciArcimDr,"||",1)
	.s sub=+sub
	.s ver=$p(inciArcimDr,"||",2)
	.s ver=+ver
	.q:'$d(^ARCIM(sub,ver,1))
	.s arciCode=$p(^ARCIM(sub,ver,1),"^",1)
	.s arciDesc=$p(^ARCIM(sub,ver,1),"^",2)
	.s ItemCatDR=$p(^ARCIM(sub,ver,1),"^",10) //医嘱子类
	.s OrderType=$p(^ARC("IC",ItemCatDR),"^",7)            //医嘱类型
	.q:OrderType'="R"           //lbb  2020/6/12  增加过滤非药品的医嘱
	.s TempStr=arciCode_"^"_arciDesc_"^"_sub
	.q:((arciCode'[code)&&(arciDesc'[desc))||((arciCode'[code)||(arciDesc'[desc))
	.s h=h+1
	.s ^TMP("DHCST","web.DHCSTPHCMedIndexMonitoringInquiry","DrugInfo",pid,h)=TempStr
	
	q:h=0 ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(h) //返回Json空串符

	///转换数据为Json格式
	s Title="Code^Desc^Id"
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(h) //返回Json串起始符
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCSTPHCMedIndexMonitoringInquiry","DrugInfo",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCST","web.DHCSTPHCMedIndexMonitoringInquiry","DrugInfo",pid,index))	
	.s count = count+1
	.q:(count<Start)||(count>End)
	.i count=Start d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdate) //格式化Json数据串
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdate) //格式化Json数据串
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //返回Json串结束符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// 药品指标维护界面指标信息
/// w ##class(web.DHCSTPHCMedIndexMonitoringInquiry).IndexInfo("20","1","1")
ClassMethod IndexInfo(rows As %String, page As %String, phdcDr As %String)
{
	n (rows, page,phdcDr)
	s End = page*rows
    s Start = (page-1)*rows+1  
    S pid=##class(web.DHCSTPHCMCOMMON).GetPID()
	d ..killTmpGlobal(pid)
	s h=0,count=0
	s testCodeDr=""
	f  s testCodeDr=$o(^DHCPHDINi("P",phdcDr,testCodeDr)) q:(testCodeDr="")  d
	.s TestCodeData=$g(^dbo.BTTestCodeD(testCodeDr))
	.s TestCodeName = $lg(TestCodeData,3) //指标名称
	.s IndexCode = $lg(TestCodeData,2) //指标代码
	.s TempStr=IndexCode_"^"_TestCodeName_"^"_testCodeDr
	.s h=h+1
	.s ^TMP("DHCST","web.DHCSTPHCMedIndexMonitoringInquiry","IndexInfo",pid,h)=TempStr
	
	q:h=0 ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(h) //返回Json空串符

	///转换数据为Json格式
	s Title="IndexCode^TestCodeName^Id"
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(h) //返回Json串起始符
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCSTPHCMedIndexMonitoringInquiry","IndexInfo",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCST","web.DHCSTPHCMedIndexMonitoringInquiry","IndexInfo",pid,index))	
	.s count = count+1
	.q:(count<Start)||(count>End)
	.i count=Start d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdate) //格式化Json数据串
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdate) //格式化Json数据串
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //返回Json串结束符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// 下拉框所有指标信息
/// w ##class(web.DHCSTPHCMedIndexMonitoringInquiry).GetAllIndexInfo("10","1","*白")
ClassMethod GetAllIndexInfo(rows As %String, page As %String, input As %String)
{
	n (rows, page,input)
	s End = page*rows
    s Start = (page-1)*rows+1  
    S pid=##class(web.DHCSTPHCMCOMMON).GetPID()
	d ..killTmpGlobal(pid)
	s h=0,count=0
	s rowid=""
	f  s rowid=$o(^dbo.BTTestCodeD(rowid)) q:rowid=""  d
	.s TestCodeData=$g(^dbo.BTTestCodeD(rowid))
	.s TestCodeName = $lg(TestCodeData,3) //指标名称
	.s IndexCode = $lg(TestCodeData,2) //指标代码
	.q:TestCodeName'[input
	.s TempStr=IndexCode_"^"_TestCodeName
	.s h=h+1
	.s ^TMP("DHCST","web.DHCSTPHCMedIndexMonitoringInquiry","IndexInfo",pid,h)=TempStr
	
	q:h=0 ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(h) //返回Json空串符

	///转换数据为Json格式
	s Title="IndexCode^TestCodeName"
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(h) //返回Json串起始符
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCSTPHCMedIndexMonitoringInquiry","IndexInfo",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCST","web.DHCSTPHCMedIndexMonitoringInquiry","IndexInfo",pid,index))	
	.s count = count+1
	.q:(count<Start)||(count>End)
	.i count=Start d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdate) //格式化Json数据串
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdate) //格式化Json数据串
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //返回Json串结束符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// 删除药品关联指标
/// w ##class(web.DHCSTPHCMedIndexMonitoringInquiry).DelIndex(2,1)
ClassMethod DelIndex(phdcDr As %String, testCodeDr As %String)
{
	&sql(delete from DHC_PHDrugIndex where PHDI_PHCD_DR=:phdcDr and PHDI_TestCode_DR=:testCodeDr)
	q SQLCODE
}

/// 选择指标名称获取指标id
/// w ##class(web.DHCSTPHCMedIndexMonitoringInquiry).GetIndexId("*平均红细胞血红蛋白含量")
ClassMethod GetIndexId(IndexCode As %String, TestCodeName As %String)
{
	s Id=""
	&sql(select RowID into:Id from dbo.BT_TestCode where Code=:IndexCode and CName=:TestCodeName)
	q Id
}

/// 保存数据
/// w ##class(web.DHCSTPHCMedIndexMonitoringInquiry).SaveDrugIndex("2^1^undefined&&2^2^1")
ClassMethod SaveDrugIndex(rowstr As %String)
{
	s result=""
	s len=$l(rowstr,"&&")
	f i=1:1:len d
	.s tmpStr=$p(rowstr,"&&",i) ;2^1^1
	.s result= ..CheckDrugIndex(tmpStr) ;新增(3/存在、-3/不存在) 更新(2)
	.s:result="3" result="3" ;有重复数据退出
	.s:result="-3" result=..InsDrugIndex(tmpStr)
	q result
}

/// 检查要保存的数据是否存在与表里
/// w ##class(web.DHCSTPHCMedIndexMonitoringInquiry).CheckDrugIndex("2^1^1")
ClassMethod CheckDrugIndex(tmpStr As %String)
{
	s phdcDr=$p(tmpStr,"^",1)
	s testCodeDr=$p(tmpStr,"^",2)
	s flag=$p(tmpStr,"^",3)
	if (flag="undefined"){
		q:$d(^DHCPHDINi("P",phdcDr,testCodeDr)) "3"
		q:'$d(^DHCPHDINi("P",phdcDr,testCodeDr)) "-3"
	}
	else{
		q:$d(^DHCPHDINi("P",phdcDr,testCodeDr)) "3"
		d ..UpdDrugIndex(tmpStr)
	}
}

/// 增加数据
/// w ##class(web.DHCSTPHCMedIndexMonitoringInquiry).InsDrugIndex("2^2")
ClassMethod InsDrugIndex(tmpStr As %String)
{
	s phdcDr=$p(tmpStr,"^",1)
	s testCodeDr=$p(tmpStr,"^",2)
	&sql(insert into DHC_PHDrugIndex values(:phdcDr,:testCodeDr))
	q SQLCODE
}

/// 更新数据
/// w ##class(web.DHCSTPHCMedIndexMonitoringInquiry).UpdDrugIndex("2^1^1")
ClassMethod UpdDrugIndex(tmpStr As %String)
{
	s phdcDr=$p(tmpStr,"^",1)
	s testCodeDr=$p(tmpStr,"^",2)
	s flag=$p(tmpStr,"^",3)
	s rowId=""
	&sql(select PHDI_RowID into:rowId from DHC_PHDrugIndex where PHDI_PHCD_DR=:phdcDr and PHDI_TestCode_DR=:flag)
	&sql(update DHC_PHDrugIndex set PHDI_PHCD_DR=:phdcDr,PHDI_TestCode_DR=:testCodeDr where PHDI_RowID=:rowId)
	q SQLCODE
}

/// 病人药品医嘱信息
/// w ##class(web.DHCSTPHCMedIndexMonitoringInquiry).GetCheOEInfo("15","1","1")
ClassMethod GetCheOEInfo(rows As %String, page As %String, AdmDr As %String) As %GlobalCharacterStream
{
	N (rows,page,AdmDr,priCode)
	Q:AdmDr="" "-1"
	S EndPage=page*rows  //结束行
	S StPage=((page-1)*rows)+1 //开始行
	S ord=$o(^OEORD(0,"Adm",AdmDr,"")) //医嘱主表id
	S pid=##class(web.DHCSTPHCMCOMMON).GetPID()
	d ..killTmpGlobal(pid)
	s OutBinStream=##Class(%GlobalCharacterStream).%New() //定义流stream
	S Num=0
    S chl=0 
    F  S chl=$o(^OEORD(ord,"I",chl)) q:(chl="")||(chl=0)  d
	.S orditm=ord_"||"_chl
	.Q:..isPatTaked(orditm)'=1   /// 过滤已经停止的医嘱
	.S priDr=+$p(^OEORD(ord,"I",chl,1),"^",8) 
    .Q:priDr=0 
    .S priorty=$p(^OECPR(priDr),"^",1) //医嘱优先级代码                 
    .S priorty=$p(^OECPR(priDr),"^",2) //医嘱优先级
    .S StatDr=$p(^OEORD(ord,"I",chl,1),"^",13)
    .S OeFlag=$p(^OEC("OSTAT",StatDr),"^",1) 
	.S FillerNo=$p(^OEORD(ord,"I",chl,9),"^",12) //滚医嘱来源信息 OEORI_FillerNo
    .Q:(FillerNo'="")&(FillerNo'=orditm_"!!"_orditm)&(OeFlag'="D")  //长嘱非首日和截止日期的记录过滤
	.S ArcItmId=$p(^OEORD(ord,"I",chl,1),"^",2)  //医嘱 ARC_ItmMast ARCIM_RowId
	.S ItemCatDR=$p(^ARCIM($p(ArcItmId,"||",1),$p(ArcItmId,"||",2),1),"^",10)
    .S ordertype=$P(^ARC("IC",ItemCatDR),"^",7)
    .Q:(ordertype'="R")
	.S inci=$o(^INCI(0,"ARCIM_DR",$p(ArcItmId,"||",1),"")) 
	.Q:inci=""  //医嘱名称
	.S incidesc=$p(^INCI(inci,1),"^",2) //药品名称
	.s indexResult=..getDrugIfIndex(incidesc)
	.q:indexResult="-1"
	.s repeatFlag=..filtRepeatDrug(incidesc,pid) 
	.q:repeatFlag="1" //存在重复药品
	.S dosage=$p(^OEORD(ord,"I",chl,2),"^",1) //剂量
	.S dosuomID=+$p(^OEORD(ord,"I",chl,2),"^",3)
	.S doseuom=$p($g(^CT("UOM",dosuomID)),"^",2) //剂量单位
	.S freqdr=+$p($g(^OEORD(ord,"I",chl,2)),"^",4) //OEORI_PHFreq_DR
    .S freq=$p($g(^PHCFR(freqdr)),"^",3) //频率
    .S instrudr=+$p(^OEORD(ord,"I",chl,2),"^",7)
    .S instru=$p($g(^PHCIN(instrudr)),"^",2) //用法
    .s durId=+$p(^OEORD(ord,"I",chl,2),"^",6)
	.S duration=$p($g(^PHCDU(durId)),"^",3) //用药疗程
    .S arcim=$p($g(^INCI(inci,1)),"^",3)
    .q:arcim=""
    .S phcdf=$p(^ARCIM($p(ArcItmId,"||",1),$p(ArcItmId,"||",2),1),"^",12) q:phcdf=""
    .s genenicdr=+$p($g(^PHCD(+phcdf,4)),"^",1)
    .s genenic=$p($g(^PHCGE("GE",genenicdr)),"^",2) //通用名
    .s formdr=$p(^PHCD(+phcdf,"DF",$p(phcdf,"||",2),1),"^",1)
    .s form=$p(^PHCF(formdr),"^",2) //剂型
    .s manf=""
    .s manfdr=$p($g(^PHCD(+phcdf,2)),"^",4) //厂家
    .s:manfdr'="" manf=$p($p($g(^PHMNF(manfdr)),"^",2),"-",2)
    .s apprdocu=""
    .s itminfo=$o(^DHCITMINFO(0,"INCI",inci,""))
    .i itminfo'="" s apprdocu=$p(^DHCITMINFO(itminfo),"^",10) //批准文号
    .S spec="["_$p(^INCI(inci,3),"^",9)_"]" //规格
    .S EndDate=$p(^OEORD(ord,"I",chl,3),"^",34)     //停止日期
	.S:EndDate'="" EndDate=$zd(EndDate,3)
	.i FillerNo'="" d
	..S orditm=$p(FillerNo,"!!",1)
	.S StartDate=$p(^OEORD(ord,"I",$p(orditm,"||",2),1),"^",9)  //开始日期
	.S:StartDate'="" StartDate=$zd(StartDate,3)
	.S moeori=##class(web.DHCSTCNTSCOMMON).GetMainOeori(orditm) //主医嘱
    .S index=StartDate_"||"_moeori_"||"_orditm
    .i $d(^TMP("DHCST","web.DHCSTPHCMedIndexMonitoringInquiry","GetCheOEInfo",pid,index)) d
	..S $p(^TMP("DHCST","web.DHCSTPHCMedIndexMonitoringInquiry","GetCheOEInfo",pid,index),"^",21)=EndDate
	..S $p(^TMP("DHCST","web.DHCSTPHCMedIndexMonitoringInquiry","GetCheOEInfo",pid,index),"^",22)=OeFlag
	.E  D
	..S Num=Num+1
	..S ^TMP("DHCST","web.DHCSTPHCMedIndexMonitoringInquiry","GetCheOEInfo",pid,index)=orditm_"^"_phcdf_"^"_incidesc_"^"_dosage_doseuom_"^"_dosuomID_"^"_freqdr_"^"_freq_"^"_instrudr_"^"_instru_"^"_durId_"^"_duration_"^"_genenicdr_"^"_genenic_"^"_formdr_"^"_form_"^"_manfdr_"^"_manf_"^"_apprdocu_"^"_spec_"^"_StartDate_"^"_EndDate_"^"_OeFlag_"^"_priorty

	Q:Num=0 ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串
	
	S Title="orditm^phcdf^incidesc^dosage^dosuomID^freqdr^freq^instrudr^instru^durId^duration^genenicdr^genenic^formdr^form^manfdr^manf^apprdocu^spec^StartDate^EndDate^OeFlag^priorty"
	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	d OutBinStream.Write("[") //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMedIndexMonitoringInquiry","GetCheOEInfo",pid,index)) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCST","web.DHCSTPHCMedIndexMonitoringInquiry","GetCheOEInfo",pid,index)
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage d
	..d OutBinStream.Write(##class(web.DHCSTPHCMJsonCommon).getJsonData(Title,mdata,"^"))
	.e  d
	..d OutBinStream.Write(","_##class(web.DHCSTPHCMJsonCommon).getJsonData(Title,mdata,"^"))
	
	d OutBinStream.Write("]") //输出json结尾符
	d ..killTmpGlobal(pid)
	//D OutBinStream.OutputToDevice()
	q OutBinStream
}

/// 检查该医嘱是否维护了检验指标
/// w ##class(web.DHCSTPHCMedIndexMonitoringInquiry).getDrugIfIndex("阿司匹林肠溶片(拜阿司匹灵)[100mg*30]")
ClassMethod getDrugIfIndex(incidesc As %String)
{
	n (incidesc)
	s inciRowId=""
	s inciRowId=$o(^INCI(0,"Desc",$$ALPHAUP^SSUTIL4(incidesc),inciRowId))
	s testCodeDr=""
	s indexResult="-1" ;药品没有维护指标
	f  s testCodeDr=$o(^DHCPHDINi("P",inciRowId,testCodeDr)) q:(testCodeDr="")  d
	s:$d(^DHCPHDINi("P",inciRowId)) indexResult="1" ;药品维护了指标
	q indexResult
}

/// 列表过滤掉重复的药品
/// w ##class(web.DHCSTPHCMedIndexMonitoringInquiry).filtRepeatDrug("阿司匹林肠溶片(拜阿司匹灵)[100mg*30]")
ClassMethod filtRepeatDrug(incidesc As %String, pid As %String)
{
	n (incidesc,pid)
	s flag="-1"
	s:$d(^TMP("DHCST","web.DHCSTPHCMedIndexMonitoringInquiry",pid,incidesc)) flag="1" //存在
	s ^TMP("DHCST","web.DHCSTPHCMedIndexMonitoringInquiry",pid,incidesc)=incidesc
	q flag
}

/// 病人检验检查项目 检验L、检查S
/// w ##class(web.DHCSTPHCMedIndexMonitoringInquiry).InspectionItems("140","药箅子[1个]")
/// w ##class(web.DHCSTPHCMedIndexMonitoringInquiry).InspectionItems("41","复合维生素B片[100片]")
/// w ##class(web.DHCCM.DrugAdvice).InspectionItems("1")
ClassMethod InspectionItems(EpisodeID As %String, incidesc As %String) As %GlobalCharacterStream
{
	n (EpisodeID,incidesc)
	S pid=##class(web.DHCSTPHCMCOMMON).GetPID()
    D ..killTmpGlobal(pid) //k掉临时global
    s result=""
    s inciRowId=""
    s OutBinStream=##Class(%GlobalCharacterStream).%New()
    s inciRowId=$o(^INCI(0,"Desc",$$ALPHAUP^SSUTIL4(incidesc),inciRowId))
    d OutBinStream.Write("[")  //输出json前缀串
    s SynonymAll="RBC^HGB^HCT^MCH"
    s testCodeDr=""
	f  s testCodeDr=$o(^DHCPHDINi("P",inciRowId,testCodeDr)) q:(testCodeDr="")  d
	.s TestCodeData=$g(^dbo.BTTestCodeD(testCodeDr))
	.s IndexCode = $lg(TestCodeData,2) //指标代码
	.s result=result_..GetPatLabItem(EpisodeID,IndexCode)_"," ;正式数据
	.;s result=result_..IndexChangeInfo(SynonymCode,SynonymAll)_"," ;测试数据
	d OutBinStream.Write($e(result,1,$l(result)-1))
	d OutBinStream.Write("]")   //输出json结尾符
	;D OutBinStream.OutputToDevice()
	D ..killTmpGlobal(pid) //k掉临时global
	Q OutBinStream
}

/// 指标变化情况
/// d ##class(web.DHCSTPHCMedIndexMonitoringInquiry).IndexChangeInfo("RBC","RBC^HGB^HCT^MCV")
ClassMethod IndexChangeInfo(SynonymCode As %String, SynonymAll As %String) As %GlobalCharacterStream
{
	n (SynonymCode,SynonymAll)
	s result=""
    S pid=##class(web.DHCSTPHCMCOMMON).GetPID()
    d ..killTmpGlobal(pid) //k掉临时global
    s h=0,count=0
    s pid=7
    i SynonymCode=$p(SynonymAll,"^",1) d
	.s ^TMP("DHCST","web.DHCSTPHCMedIndexMonitoringInquiry","IndexChangeInfo",pid,1)="2017-03-12^*红细胞计数^3.80"
	.s ^TMP("DHCST","web.DHCSTPHCMedIndexMonitoringInquiry","IndexChangeInfo",pid,2)="2017-04-12^*红细胞计数^4.80"
	.s ^TMP("DHCST","web.DHCSTPHCMedIndexMonitoringInquiry","IndexChangeInfo",pid,3)="2017-05-24^*红细胞计数^5.80"
	
	i SynonymCode=$p(SynonymAll,"^",2) d
	.s ^TMP("DHCST","web.DHCSTPHCMedIndexMonitoringInquiry","IndexChangeInfo",pid,1)="2017-05-09^*血红蛋白量^120"
	
	i SynonymCode=$p(SynonymAll,"^",3) d
	.s ^TMP("DHCST","web.DHCSTPHCMedIndexMonitoringInquiry","IndexChangeInfo",pid,1)="2017-03-12^*红细胞比积^35"
	.s ^TMP("DHCST","web.DHCSTPHCMedIndexMonitoringInquiry","IndexChangeInfo",pid,2)="2016-09-25^*红细胞比积^50"
	
	i SynonymCode=$p(SynonymAll,"^",4) d
	.s ^TMP("DHCST","web.DHCSTPHCMedIndexMonitoringInquiry","IndexChangeInfo",pid,1)="2017-03-12^*平均红细胞体积^82"
	.s ^TMP("DHCST","web.DHCSTPHCMedIndexMonitoringInquiry","IndexChangeInfo",pid,2)="2016-09-25^*平均红细胞体积^95"
	
	///转换数据为Json格式
	s Title="name^group^value"
	s result=result_"[" //输出json前缀
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCSTPHCMedIndexMonitoringInquiry","IndexChangeInfo",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCST","web.DHCSTPHCMedIndexMonitoringInquiry","IndexChangeInfo",pid,index))	
	.s count = count+1
	.i count=1 d
	..s result=result_##class(web.DHCSTPHCMJsonCommon).getSisJsonData(Title,mdate,"^") //格式化Json数据串
	.e  d
	..s result=result_","_##class(web.DHCSTPHCMJsonCommon).getSisJsonData(Title,mdate,"^") //格式化Json数据串
	s result=result_"]" //输出json结尾
	d ..killTmpGlobal(pid) //k掉临时global
	q result
}

/// Descript: 病人检验项目
/// d ##class(web.DHCSTPHCMedIndexMonitoringInquiry).GetPatLabItem("1122")
ClassMethod GetPatLabItem(EpisodeID As %String, IndexCode As %String)
{
	n (EpisodeID,IndexCode)
	S pid=##class(web.DHCSTPHCMCOMMON).GetPID()
	s result=""
	Q:EpisodeID="" ""
	
	s ord=$o(^OEORD(0,"Adm",EpisodeID,""))
	Q:ord="" "[]"
	
	s PatLoc="",HospCode=""
	s PatLocID=$p(^PAADM(EpisodeID),"^",4)     /// 科室
	i PatLocID'="" D
	.s PatLoc=$p($p(^CTLOC(PatLocID),"^",2),"-",2)
	.s HospID=$p(^CTLOC(PatLocID),"^",22)
	.s HospCode=$p(^CT("HOSP",HospID),"^",1)   /// 医院
	
	s AdmDate=$p(^PAADM(EpisodeID),"^",6)  /// 就诊日期
	s AdmTime=$p(^PAADM(EpisodeID),"^",7)  /// 就诊时间
	i AdmDate'="" s AdmDate=$zd(AdmDate,3)
	i AdmTime'="" s AdmTime=$zt(AdmTime,1)
	
	s AdmType=$p(^PAADM(EpisodeID),"^",2)  /// 就诊类型
	s AdmType=$s(AdmType="O":"门诊",AdmType="E":"急诊",AdmType="I":"住院",AdmType="H":"体检",1:"")

	s num=""
	s itm=0
	f  s itm=$o(^OEORD(ord,"I",itm)) q:itm=""  d 
	.s orditm=ord_"||"_itm
	.s ItemStatDR=$p(^OEORD(ord,"I",itm,1),"^",13) //医嘱状态
	.i ItemStatDR'="" s ItemStatCode=$p(^OEC("OSTAT",ItemStatDR),"^",1)
	.Q:(ItemStatCode'="V")&(ItemStatCode'="E")
	.s arcimid=$p(^OEORD(ord,"I",itm,1),"^",2)  //医嘱 ARC_ItmMast ARCIM_RowId
	.Q:'##Class(web.DHCLabOrder).isLabTS(arcimid)
	.s itmmastid=$p(arcimid,"||",1)
	.s itmmastver=$p(arcimid,"||",2)
	.s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2) /// 医嘱项名称
	.s LabEpisode=$p(^OEORD(ord,"I",itm,3),"^",20)     	   /// 检验号---  OE_OrdItem   OEORI_LabEpisodeNo
	.s LabTestSetRow=$p(^OEORD(ord,"I",itm,3),"^",35)      /// 报告ID---  OE_OrdItem   OEORI_LabTestSetRow
	.s reqdate=$p(^OEORD(ord,"I",itm,3),"^",7)   /// 申请日期
	.s:reqdate'="" reqdate=$zd(reqdate,3)
	.s reqtime=$p(^OEORD(ord,"I",itm,1),"^",17)  /// 申请时间
	.s:reqtime'="" reqtime=$zt(reqtime,2)
	.s reqDateTime=reqdate_" "_reqtime
	.s WorkGroupMachineDR="NULL"
	.s VisitNumberDR=$o(^dbo.RPVisitNumberI("IndexVisitNumber",##Class(LIS.Util.Common).IndexData(LabEpisode),""))
	.i $l(LabTestSetRow) s WorkGroupMachineDR=$lg($g(^dbo.RPVisitNumberTestSetD(LabTestSetRow)),5)
	.i '$l(WorkGroupMachineDR) s WorkGroupMachineDR="NULL"
	./// 标本类型
	.s specCode="",specName=""
	.s specDr=$o(^OEORD(ord,"I",itm,"SPEC",""),-1)
	.i specDr'="" s specCode=$p(^OEORD(ord,"I",itm,"SPEC",specDr),"^",1)
	.i specCode'="" s specName=$p(##Class(DHCLIS.DHCCommon).GetSpecimen(specCode,HospCode),$c(2),2)
	./// 采集日期时间Collection
	.s specDateTime=""
	.s retval=##Class(web.DHCNurSpecerNo).GetspecCollDatetime(orditm)
	.i $l(retval) d
	..s specDate=$p(retval,"^",2)
	..i $l(specDate) s specDate=$zd(specDate,3)
	..s specTime=$p(retval,"^",3)
	..i $l(specTime) s specTime=$zt(specTime)
	..s specDateTime=specDate_" "_specTime
	./// 接收日期
	.s recDateTime="",authDateTime="",tsResultAnomaly="",transComm="",reportID=""
	.i $l(VisitNumberDR) d
	..s recDate=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),66)
	..s recTime=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),67)
	..i $l(recTime) s recTime=$zt(recTime)
	..i $l(recDate) s recDateTime=$e(recDate,1,4)_"-"_$e(recDate,5,6)_"-"_$e(recDate,7,8)_" "_recTime
	../// 审核日期
	..s Order=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,""))
	..i $l(Order) d 
	...;^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,OrderNo,ID)
	...s reportID=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,Order,""))
	...d ..GetPatLabItemDetail(pid,EpisodeID,reportID,IndexCode)
	
	/// 转换数据为Json格式
	s ListTitle="name^group^value"
	s result=result_"[" //输出json前缀
	s index="",quitflag=0,count=0
	f  s index=$o(^TMP("DHCST","web.DHCSTPHCMedIndexMonitoringInquiry","GetPatLabItemDetail",pid,index)) Q:index=""  D
	.s ListData=$g(^TMP("DHCST","web.DHCSTPHCMedIndexMonitoringInquiry","GetPatLabItemDetail",pid,index))
	.s count = count+1
	.I count=1 d
	..s result=result_##Class(web.DHCSTPHCMJsonCommon).getSisJsonData(ListTitle,ListData,"^")
	.e  d
	..s result=result_","_##Class(web.DHCSTPHCMJsonCommon).getSisJsonData(ListTitle,ListData,"^")
	s result=result_"]"   //输出json结尾符
	D ..killTmpGlobal(pid) //k掉临时global
	Q result
}

/// Descript: 病人检验项目指标
ClassMethod GetPatLabItemDetail(pid As %String, EpisodeID As %String, reportID As %String, IndexCode As %String) As %String
{
	n (pid, EpisodeID, reportID,IndexCode)
	Q:EpisodeID="" ""
	Q:reportID="" ""
	
	s PatientID=$p(^PAADM(EpisodeID),"^",1)      /// 病人ID
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)  /// 病人登记号
	
	Q:'$d(^dbo.RPVisitNumberReportD(reportID)) ""
	s AuthDate=$lg($g(^dbo.RPVisitNumberReportD(reportID)),19)
	s AuthTime=$zt($lg($g(^dbo.RPVisitNumberReportD(reportID)),20),1)
	s ReAuthDate=$lg($g(^dbo.RPVisitNumberReportD(reportID)),23)
	s ReAuthTime=$zt($lg($g(^dbo.RPVisitNumberReportD(reportID)),24),1)
	//如果有重审时间，审核时间为重审时间，用于前次结果查询
	i $l($g(ReAuthDate)) s AuthDate = ReAuthDate
	i $l($g(ReAuthTime)) s AuthTime = ReAuthTime
	
	s TestCodeDRs = ##Class(web.DHCSTPHCMedIndexMonitoringInquiry).GetTestCodeDRsByReportDR(reportID)
	Q:TestCodeDRs="" ""
	s TLength = $l(TestCodeDRs,",")
	for i=1:1:TLength {
		s TestCodeDR = $p(TestCodeDRs,",",i)
		s TestCodeData=$g(^dbo.BTTestCodeD(TestCodeDR))
		s TestCodeName = $lg(TestCodeData,3)
		s Code = $lg(TestCodeData,2) /// 代码
		s Units = $lg(TestCodeData,8)   /// 单位
		s $LIST(TestCodeData,1)=TestCodeDR
		s ResultFormat=$LIST(TestCodeData,9) /// 结果格式(N数字,X文本,S列表,A血型ABO,R血型RH,M微生物)
		s ReportResult=##Class(web.DHCSTPHCMedIndexMonitoringInquiry).GetReportResult(reportID,TestCodeDR)
		s ResClass =  $lg(ReportResult,10)   /// 结果类别(0普通,1危急)
		s Result = $lg(ReportResult,5)
		s ExtraRes = $lg(ReportResult,6)
		//结果描述，细菌名称
        //i ResultFormat="M",$l(Result) d  s Result=$lg(^dbo.BTOrganismD(Result),3)

		s AbFlag = $lg(ReportResult,9) //异常提示
		s RefRanges = $lg(ReportResult,12) //参考范围
		s ClinicalSignifyS = $lg(TestCodeData,20) //临床意义
		s (ValueLow,ValueHigh,PanicLow,PanicHigh,UnacceptLow,UnacceptHigh)=""
	
		//获取前一次结果
		s PreResultList=##Class(web.DHCSTPHCMedIndexMonitoringInquiry).GetPreResult(PatNo,TestCodeDR,AuthDate,AuthTime)
		s PreResult=$p(PreResultList,"^",1),PreAbFlag=$p(PreResultList,"^",2),PreResultDR=$p(PreResultList,"^",3)
		s PreResultList=$lb(PreResult,PreAbFlag,PreResultDR)
		s ListData=TestCodeDR_"^"_Code_"^"_TestCodeName_"^"_Units_"^"_ResultFormat_"^"_ResClass_"^"_Result_"^"_ExtraRes_"^"_AbFlag_"^"_RefRanges_"^"_ClinicalSignifyS_"^"_PreResultList
		continue:Code'=IndexCode ;筛选出对应的检验项指标
		s:Result="" Result="0"
		;输出所有的该相关指标
		s ^TMP("DHCST","web.DHCSTPHCMedIndexMonitoringInquiry","GetPatLabItemDetail",pid,reportID)=AuthDate_"^"_TestCodeName_"^"_Result
		
	}
}

/// d ##class(web.DHCSTPHCMedIndexMonitoringInquiry).getRelaDrugName("1","611")
ClassMethod getRelaDrugName(EpisodeID As %String, TestCodeDR As %String, AuthDate As %String, pid As %String, reportID As %String)
{
	s ord=$o(^OEORD(0,"Adm",EpisodeID,""))
	q:ord=""
	s phdcDr=""
	s inciRowId=""
	s oeoriSttDat=""
	s oeoriChiSub=""
	s oeoreExstdate=""
	s qty=""
	f  s phdcDr=$o(^DHCPHDINi("T",TestCodeDR,phdcDr)) q:phdcDr=""  d
	.s drugDesc=$p(^INCI(phdcDr,1),"^",2)
	.f  s inciRowId=$o(^INCI(0,"Desc",$$ALPHAUP^SSUTIL4(drugDesc),inciRowId)) q:inciRowId=""  d
	..q:'$d(^INCI(+inciRowId,1))
	..s inciArcimDr=$p(^INCI(inciRowId,1),"^",3)
	..q:inciArcimDr=""
	..f  s oeoriSttDat=$o(^OEORDi(0,"ARCIM",ord,inciArcimDr,oeoriSttDat)) q:oeoriSttDat=""  d
	...f  s oeoriChiSub=$o(^OEORDi(0,"ARCIM",ord,inciArcimDr,oeoriSttDat,oeoriChiSub)) q:oeoriChiSub=""  d
	....f  s oeoreExstdate=$o(^OEORDi(0,"OrdItem",ord,oeoriChiSub,oeoreExstdate)) q:oeoreExstdate=""  d
	....s qty=$p(^OEORD(ord,"I",oeoriChiSub,2),"^",1)
}

/// Descript: 根据报告id取项目的id串
ClassMethod GetTestCodeDRsByReportDR(ReportDR As %String) As %String
{
	n (ReportDR)
	s TestCodeDRs=""
	s VisitNumberDR=$lg($g(^dbo.RPVisitNumberReportD(ReportDR)),2)
	s WorkGroupMachineDR = $lg($g(^dbo.RPVisitNumberReportD(ReportDR)),4)
	s WorkGroupDR = $lg(^dbo.BTWorkGroupMachineD(WorkGroupMachineDR),4)
	i '$l(WorkGroupDR) Q ""
	s TestSetDR="" 
	f  s TestSetDR=$o(^dbo.RPVisitNumberTestSetI("IndexMaster",VisitNumberDR,TestSetDR)) q:TestSetDR=""  d
	.s VisNumTSDR = $o(^dbo.RPVisitNumberTestSetI("IndexMaster",VisitNumberDR,TestSetDR,""))
	.s tWorkGroupMachineDR=$lg($g(^dbo.RPVisitNumberTestSetD(VisNumTSDR)),5)
	.i tWorkGroupMachineDR'=WorkGroupMachineDR q
	.s TestCodeDR="" f  s TestCodeDR=$o(^dbo.BTTestSetLayoutI("IndexMaster",TestSetDR,WorkGroupDR,TestCodeDR)) q:TestCodeDR=""  d
	..i $l($g(TestCodeDRs)) d
	...s TestCodeDRs = TestCodeDRs_","_TestCodeDR
	..else  d
	...s TestCodeDRs = TestCodeDR
	Q TestCodeDRs
}

/// Descript: 获取报告结果
ClassMethod GetReportResult(ReportDR As %String, TestCodeDR As %String) As %String
{
	n (ReportDR, TestCodeDR)
	s ReportDR=$g(ReportDR),TestCodeDR=$g(TestCodeDR)
	s RetVal=$lb("","","","","","","","","","","","","","","","","","","","","","","","","","")
	i '$l(ReportDR) q RetVal
	i '$l(TestCodeDR) q RetVal
	s ReportResultDR=$o(^dbo.RPVisitNumberReportResultI("IndexReportItem",ReportDR, TestCodeDR,""))
	i '$l(ReportResultDR) q RetVal
	s ReportResultData=$li($g(^dbo.RPVisitNumberReportResultD(ReportResultDR)),1,26)
	s $li(ReportResultData,1)=ReportResultDR
	Q ReportResultData
}

/// Descript: 获取最近一次结果"201501041","260",20150814,69214
ClassMethod GetPreResult(RegNo, TestCodeDR, AuthDate, AuthTime, WorkGroupMachineDR) As %String
{
	n (RegNo, TestCodeDR, AuthDate, AuthTime, WorkGroupMachineDR)
	s RegNo=$g(RegNo),TestCodeDR=$g(TestCodeDR),AuthDate=$g(AuthDate),AuthTime=$g(AuthTime),WorkGroupMachineDR=$g(WorkGroupMachineDR)
	s RetVal="",ReportResultDR=""
	i '$l(RegNo) q RetVal
	i '$l(TestCodeDR) q RetVal
	i '$l(AuthDate) d
	.s AuthDate=$o(^dbo.RPVisitNumberReportResultI("IndexPatientItem",##Class(LIS.Util.Common).IndexData(RegNo),TestCodeDR,""),-1)
	.i '$l(AuthDate) q
	.s AuthTime=$o(^dbo.RPVisitNumberReportResultI("IndexPatientItem",##Class(LIS.Util.Common).IndexData(RegNo),TestCodeDR,AuthDate,""),-1)
	.i '$l(AuthTime) q
	.s ReportResultDR=$o(^dbo.RPVisitNumberReportResultI("IndexPatientItem",##Class(LIS.Util.Common).IndexData(RegNo),TestCodeDR,AuthDate,AuthTime,""))
	e  d
	.i $l($o(^dbo.RPVisitNumberReportResultI("IndexPatientItem",##Class(LIS.Util.Common).IndexData(RegNo),TestCodeDR,AuthDate,AuthTime),-1)) d
	..s AuthTime = $o(^dbo.RPVisitNumberReportResultI("IndexPatientItem",##Class(LIS.Util.Common).IndexData(RegNo),TestCodeDR,AuthDate,AuthTime),-1)
	..s ReportResultDR=$o(^dbo.RPVisitNumberReportResultI("IndexPatientItem",##Class(LIS.Util.Common).IndexData(RegNo),TestCodeDR,AuthDate,AuthTime,""))
	.e  d
	..s AuthDate = $o(^dbo.RPVisitNumberReportResultI("IndexPatientItem",##Class(LIS.Util.Common).IndexData(RegNo),TestCodeDR,AuthDate),-1)
	..i AuthDate="" q
	..s AuthTime = $o(^dbo.RPVisitNumberReportResultI("IndexPatientItem",##Class(LIS.Util.Common).IndexData(RegNo),TestCodeDR,AuthDate,""),-1)
	..s ReportResultDR=$o(^dbo.RPVisitNumberReportResultI("IndexPatientItem",##Class(LIS.Util.Common).IndexData(RegNo),TestCodeDR,AuthDate,AuthTime,""))
	///获取结果
	i '$l(ReportResultDR) q RetVal
	s ReportResultData=$g(^dbo.RPVisitNumberReportResultD(ReportResultDR))
	s VisitNumberReportDR=$lg(ReportResultData,2)
	s TextRes=$lg(ReportResultData,5)
	s AbFlag=$lg(ReportResultData,9)
	s RetVal=TextRes_"^"_AbFlag_"^"_ReportResultDR
	Q RetVal
}

/// Descript: 医嘱是否存在执行记录
/// w ##Class(web.DHCSTPHCMedIndexMonitoringInquiry).isPatTaked("544||83")
ClassMethod isPatTaked(Oeori) As %String
{
	n (Oeori)
	q:Oeori="" ""
	s Ord=+Oeori, Itm=$p(Oeori,"||",2)
	s itemStatID=$p(^OEORD(Ord,"I",Itm,1),"^",13)
	q:itemStatID="" ""
	s itemStat=$p(^OEC("OSTAT",itemStatID),"^",1)
	q:(itemStat'="D")&(itemStat'="C")&(itemStat'="U") "1"  	//医嘱状态 D 停止 U作废 C撤销
	s QuitFlag=0
	s Sub=0
	f  s Sub=$o(^OEORD(Ord,"I",Itm,"X",Sub)) Q:(Sub="")||(QuitFlag'=0)  d
	.s ExecID=$p(^OEORD(Ord,"I",Itm,"X",Sub),"^",16)  /// 执行状态
	.q:ExecID=""		//qunianpeng 2017/11/30 医嘱的执行状态存在为空的情况(不知道原因)
	.s itemStat=$p(^OEC("STAT",ExecID),"^",1)
	.//Q:itemStat'="E"
	.q:itemStat'="F"	//qunianpeng 2017/11/30 只保留医嘱的执行状态为已执行的医嘱
	.s QuitFlag=1
	q QuitFlag
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCST","web.DHCSTPHCMedIndexMonitoringInquiry","DrugInfo")
	k ^TMP("DHCST","web.DHCSTPHCMedIndexMonitoringInquiry","IndexInfo")
	k ^TMP("DHCST","web.DHCSTPHCMedIndexMonitoringInquiry","GetCheOEInfo",pid) //药品医嘱
	k ^TMP("DHCST","web.DHCSTPHCMedIndexMonitoringInquiry","InspectionItems",pid) //药品医嘱关联的检验检查指标
	k ^TMP("DHCST","web.DHCSTPHCMedIndexMonitoringInquiry","IndexChangeInfo",pid) //检验检查指标变化
	k ^TMP("DHCST","web.DHCSTPHCMedIndexMonitoringInquiry","GetPatLabItemDetail",pid) //检验检查指标数量
}

Storage Default
{
<Data name="DHCSTPHCMedIndexMonitoringInquiryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCSTPHCMed9A74D</DataLocation>
<DefaultData>DHCSTPHCMedIndexMonitoringInquiryDefaultData</DefaultData>
<IdLocation>^web.DHCSTPHCMed9A74D</IdLocation>
<IndexLocation>^web.DHCSTPHCMed9A74I</IndexLocation>
<StreamLocation>^web.DHCSTPHCMed9A74S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
