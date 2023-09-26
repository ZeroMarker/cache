Class web.DHCBL.BDP.ExportDiag Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator:陈莹
/// CreatDate:2021.01.20
/// Description:导出某个就诊日期段 全院或者某个科室 某个就诊类型的患者诊断
/// Input:DateFrom（就诊开始日期），DateTo（就诊结束日期），path(路径），admtyp患者就诊类型（空时查询所有，门急诊OE，门诊O，住院I，急诊E）,ctlocrowid（科室rowid,为空时查询所有科室数据)
/// Output: txt 列顺序为  登记号^姓名^性别^出生日期^费别^就诊日期^就诊科室^就诊类型^诊断^行数
/// 用于结构化诊断平台数据分析
/// Debug:  1.导出2020.01.01至2020.12.31 xx科室 门急诊患者诊断
/// d ##class(web.DHCBL.BDP.ExportDiag).FindDiagByAdmType("2020-01-01","2020-12-31","D:\","OE","")   //windows服务器
/// d ##class(web.DHCBL.BDP.ExportDiag).FindDiagByAdmType("2020-01-01","2020-12-31","/tmp/","OE","")  //小机
/// Debug:  2.导出2020.01.01至2020.12.31 xx科室 出院患者诊断
/// d ##class(web.DHCBL.BDP.ExportDiag).FindDiagByAdmType("2020-01-01","2020-12-31","D:\","I","")   //windows服务器
/// d ##class(web.DHCBL.BDP.ExportDiag).FindDiagByAdmType("2020-01-01","2020-12-31","/tmp/","I","")  //小机
/// Test：d ##class(web.DHCBL.BDP.ExportDiag).FindDiagByAdmType("2020-12-01","2020-12-01","D:\","","")  //测试导出12-01的所有患者诊断
ClassMethod FindDiagByAdmType(DateFrom As %String, DateTo As %String, path As %String, admtype As %String, ctlocrowid As %String = "") As %String
{
	s CTLocDesc=""
	if ctlocrowid'=""
    {
        s CTLocDesc=$P($G(^CTLOC(ctlocrowid)),"^",2)  //科室名称
        s CTLocDesc=$tr(CTLocDesc,"/","")   //过滤特殊符号，windows文件名里不允许存在这些符号
		s CTLocDesc=$tr(CTLocDesc,"\","")
		s CTLocDesc=$tr(CTLocDesc,":","")
		s CTLocDesc=$tr(CTLocDesc,"?","")
		s CTLocDesc=$tr(CTLocDesc,"<","")
		s CTLocDesc=$tr(CTLocDesc,">","")
		s CTLocDesc=$tr(CTLocDesc,"""","")
		s CTLocDesc=$tr(CTLocDesc,"*","")
    }
	s file=path_"DHC"_admtype_"Diag"_CTLocDesc_DateFrom_"-"_DateTo_".txt"
	k pData
	k PLIST
	o file:"WNS"
	u file
	w "登记号^姓名^性别^出生日期^费别^就诊日期^就诊科室^就诊类型^诊断^行数"
	
	s DateFrom=$ZDH(DateFrom,3)
	s DateTo=$ZDH(DateTo,3)
	s Num=0 
	for Date=DateFrom:1:DateTo
	{
		s AdmRowid=0
		for
		{	
			s AdmRowid=$o(^PAADMi("PAADM_AdmDate",Date,AdmRowid)) q:AdmRowid=""   //PA_Adm
			s AdmType=$p($g(^PAADM(AdmRowid)),"^",2)  //患者就诊类型 O门诊,E急诊,I住院,H体检
			continue:((admtype'="")&&(admtype'[AdmType))  //根据就诊类型入参过滤患者数据    是门急诊患者还是住院患者,空不过滤数据
			s AdmType=$case(AdmType,"O":"门诊","E":"急诊","I":"住院","H":"体检",:AdmType)  //患者就诊类型
			s AdmStatus=$p($g(^PAADM(AdmRowid)),"^",20)
			continue:AdmStatus="C"                   //过滤退号患者
			;;患者基本信息
			s PAPMIID=$P($G(^PAADM(AdmRowid)),"^",1)
			continue:PAPMIID=""
			s patDep=$P($g(^PAADM(AdmRowid)),"^",4)  //就诊科室
			continue:((ctlocrowid'="")&&(patDep'=ctlocrowid))    //根据科室过滤
			s CTLocDesc="",AdmReason=""
			i patDep'="" s CTLocDesc=$p($g(^CTLOC(patDep)),"^",2)  //就诊科室，名称
			s Name=$p($g(^PAPER(PAPMIID,"ALL")),"^",1) //姓名
			s BirthDay=$p($g(^PAPER(PAPMIID,"ALL")),"^",6) //出生日期
			s:BirthDay>0 BirthDay=$ZD(+BirthDay,3)
			s Sex=$p($g(^PAPER(PAPMIID,"ALL")),"^",7) //性别
			s:Sex'="" Sex=$p($g(^CT("SEX",Sex)),"^",2) //性别，描述
			s PatNo=$p($g(^PAPER(PAPMIID,"PAT",1)),"^",2) //登记号
			s AdmReasonId=$p($g(^PAADM(AdmRowid,1)),"^",7)  //费别rowid
			i AdmReasonId'="" s AdmReason=$p($g(^PAC("ADMREA",AdmReasonId)),"^",2) //费别，描述
			s PatDiag=..GetMRDiagnosandTypeToEMRJson(AdmRowid)   //改成返回Json串   //..GetMRDiagnosToEMR(AdmRowid) //诊断
			continue:PatDiag=""
			s Num=Num+1
			;"登记号^姓名^性别^出生日期^费别^就诊日期^就诊科室^诊断^就诊类型^行数"
			w !,PatNo_"^"_Name_"^"_Sex_"^"_BirthDay_"^"_AdmReason_"^"_$ZD(Date,3)_"^"_CTLocDesc_"^"_AdmType_"^"_PatDiag_"^"_Num
		}
	}
	c file
	W !,file_" 生成成功，共"_Num_"条"
	Q ""
}

/// Creator:陈莹
/// CreatDate:2021.01.20
/// Description:根据就诊rowid获取患者诊断
/// Input:EpisodeID（就诊rowid）
/// Output: 患者诊断  格式：（  1.诊断1[主诊断];2.诊断2）
/// Debug: w ##class(web.DHCBL.BDP.ExportDiag).GetMRDiagnosToEMR(50506360)
ClassMethod GetMRDiagnosToEMR(EpisodeID As %String) As %String
{
	q:EpisodeID="" ""
	s mradm=$p($g(^PAADM(EpisodeID)),"^",61)   //MR_Adm RowId
	if mradm="" q ""
	s ret=""
	s num=0
	s sub=0
	for  s sub=$o(^MR(mradm,"DIA",sub)) Quit:sub=""  do   //User.MRDiagnos
	.s desc=""
	.s desid=$g(^MR(mradm,"DIA",sub,"DES",0))   ///DHCMRDiagnosMainDiag 主诊断
	.if +desid'=0 Set desc=$p($g(^MR(mradm,"DIA",sub,"DES",desid)),"^",1)  //主诊断
	.s ICDId=$p($g(^MR(mradm,"DIA",sub)),"^",1) //诊断rowid
	.if ICDId'="" do
	..s ICDDesc=$p($g(^MRC("ID",ICDId)),"^",2)  //诊断名称
	..s ICD10=$p($g(^MRC("ID",ICDId)),"^",4)  //诊断ICD10
	..if desc'="" s desc=ICDDesc_"["_desc_"]"  //诊断[主诊断]
	..else  s desc=ICDDesc
	.Quit:desc=""
	.s num=num+1
	.if ret="" s ret=num_". "_desc
	.else  s ret=ret_";"_num_". "_desc
	Quit ret
}

/// Creator：陈莹
/// CreatDate: 2020-07-03
/// Description：根据就诊rowid获取患者诊断,比GetMRDiagnosToEMR方法多获取一个诊断类型
/// Table：User.ARCItemCat
/// Input：就诊rowid
/// Return：1.诊断[主诊断]【初步诊断】;2.诊断[主诊断]【入院诊断】;
/// w ##class(web.DHCBL.BDP.ExportDiag).GetMRDiagnosandTypeToEMR(50506360)
ClassMethod GetMRDiagnosandTypeToEMR(EpisodeID As %String) As %String
{

    s mradm=$p($g(^PAADM(EpisodeID)),"^",61)   //MR_Adm RowId
    if mradm="" q ""
    s ret=""
    s num=0
    s ret=""
    s sub=0
    for  s sub=$o(^MR(mradm,"DIA",sub)) Quit:sub=""  do   //User.MRDiagnos
    .s desc=""
    .s desid=$g(^MR(mradm,"DIA",sub,"DES",0))   ///DHCMRDiagnosMainDiag 主诊断
    .if +desid'=0 Set desc=$g(^MR(mradm,"DIA",sub,"DES",desid))
    .s ICDId=$p($g(^MR(mradm,"DIA",sub)),"^",1) //User.MRDiagnos
    .if ICDId'="" do
    ..s ICDDesc=$p($g(^MRC("ID",ICDId)),"^",2)
	..s ICDDesc=$tr(ICDDesc,$c(10),"")
	..s ICDDesc=$tr(ICDDesc,$c(13),"")
	..s ICDDesc=$tr(ICDDesc,$c(0),"")
    ..s ICD10=$p($g(^MRC("ID",ICDId)),"^",4)  //诊断ICD10
    ..if desc'="" s desc=ICDDesc_"["_desc_"]"  //诊断[主诊断]
    ..else  s desc=ICDDesc
    .Quit:desc=""
    .s num=num+1
    .if ret="" s ret=num_". "_desc
    .else  s ret=ret_";"_num_". "_desc
    .;2020-07-03 获取诊断类型 主诊断/入院诊断/门诊诊断
    .s ICDType=""
    .s type=0
    .for  s type=$o(^MR(mradm,"DIA",sub,"TYP",type)) Quit:type=""  do   //User.MRDiagType ///诊断类型
    ..s TYPMRCDiagTyp=$p($g(^MR(mradm,"DIA",sub,"TYP",type)),"^",1)
    ..s:TYPMRCDiagTyp'="" TYPMRCDiagTyp=$p($g(^MRC("DTYP",TYPMRCDiagTyp)),"^",2)
    ..if ICDType="" s ICDType=TYPMRCDiagTyp
    ..else  s ICDType=ICDType_"/"_TYPMRCDiagTyp
    ..if ret="" s ret=ret_"【"_ICDType_"】"
    ..else  s ret=ret_"【"_ICDType_"】"
    Quit ret
}

/// Creator:陈莹
/// CreatDate:2021.02.04
/// Description:根据就诊rowid获取患者诊断
/// Input:EpisodeID（就诊rowid）
/// Output: 患者诊断  格式 [{"number":"1","MRCIDDesc":"诊断1","ICD10":"A00.001","Remarks":"注释","ICDType":"主诊断"},{"number":"2","MRCIDDesc":"诊断2","ICD10":"A00.002","Remarks":"","ICDType":"出院诊断"}]
/// Debug: w ##class(web.DHCBL.BDP.ExportDiag).GetMRDiagnosandTypeToEMRJson(1)
ClassMethod GetMRDiagnosandTypeToEMRJson(EpisodeID As %String) As %String
{
	q:EpisodeID="" ""
	s mradm=$p($g(^PAADM(EpisodeID)),"^",61)   //MR_Adm RowId
	if mradm="" q ""
	s ret=""
	s num=0
	s sub=0
	for
	{
		s sub=$o(^MR(mradm,"DIA",sub)) Quit:sub=""    //User.MRDiagnos
		s maindesc=""
		s desc=""
		s maindescid=$o(^MR(mradm,"DIA",sub,"DES",""),-1)   ///DHCMRDiagnosMainDiag 主诊断
		if maindescid>0 Set maindesc=$p($g(^MR(mradm,"DIA",sub,"DES",maindescid)),"^",1)  //主诊断
		s maindesc=$tr(maindesc,$c(10),"")
		s maindesc=$tr(maindesc,$c(13),"")
		s maindesc=$tr(maindesc,$c(0),"")
		s ICDRowId=$p($g(^MR(mradm,"DIA",sub)),"^",1) //诊断rowid
		if ICDRowId'=""
		{
			s ICDDesc=$p($g(^MRC("ID",ICDRowId)),"^",2)  //诊断名称
			s ICDDesc=$tr(ICDDesc,$c(10),"")
			s ICDDesc=$tr(ICDDesc,$c(13),"")
			s ICDDesc=$tr(ICDDesc,$c(0),"")
			s ICD10=$p($g(^MRC("ID",ICDRowId)),"^",4)  //诊断ICD10
			s num=num+1
			;2020-07-03 获取诊断类型 主诊断/入院诊断/门诊诊断
		    s ICDType=""
		    s type=0
		    for
		    {
			    s type=$o(^MR(mradm,"DIA",sub,"TYP",type)) Quit:type=""   //User.MRDiagType ///诊断类型
		    	s TYPMRCDiagTyp=$p($g(^MR(mradm,"DIA",sub,"TYP",type)),"^",1)
		    	s:TYPMRCDiagTyp'="" TYPMRCDiagTyp=$p($g(^MRC("DTYP",TYPMRCDiagTyp)),"^",2)  //诊断类型
		    	if ICDType="" s ICDType=TYPMRCDiagTyp
		    	else  s ICDType=ICDType_"/"_TYPMRCDiagTyp
		    }
			s desc="{""number"":"""_num_""",""MRCIDDesc"":"""_ICDDesc_""",""ICD10"":"""_ICD10_""",""Remarks"":"""_maindesc_""",""ICDType"":"""_ICDType_"""}"
			if ret=""
			{
				s ret=desc
			}
			else
			{
				s ret=ret_","_desc
			}
		}
	}
	if ret'="" s ret="["_ret_"]"
	Quit ret
}

/// Creator：陈莹
/// CreatDate: 2020-07-03
/// Description：导出某个日期段所有患者开过的医嘱(不考虑长期医嘱多条执行记录的问题） 
/// Input：开始日期，结束日期，路径  科室rowid(为空时导出所有科室数据
/// 用于临床决策支持系统，在对应的路径下生成 OrderItem科室名称开始日期-结束日期.txt文件
/// d ##class(web.DHCBL.BDP.ExportDiag).FindOrderItem("2020-10-17","2020-11-17","D:\",1348)  //windows服务器
/// d ##class(web.DHCBL.BDP.ExportDiag).FindOrderItem("2020-11-07","2020-11-17","/tmp/",1348)   //小机
ClassMethod FindOrderItem(DateFrom As %String, DateTo As %String, path As %String, CTLOCRowid As %String = "") As %String
{
    S CTLocDesc=""
    if CTLOCRowid'=""
    {
        s CTLocDesc=$P($G(^CTLOC(CTLOCRowid)),"^",2)  //科室名称
        s CTLocDesc=$tr(CTLocDesc,"/","")   //过滤特殊符号，windows文件名里不允许存在这些符号
		s CTLocDesc=$tr(CTLocDesc,"\","")
		s CTLocDesc=$tr(CTLocDesc,":","")
		s CTLocDesc=$tr(CTLocDesc,"?","")
		s CTLocDesc=$tr(CTLocDesc,"<","")
		s CTLocDesc=$tr(CTLocDesc,">","")
		s CTLocDesc=$tr(CTLocDesc,"""","")
		s CTLocDesc=$tr(CTLocDesc,"*","")
    }
    s file=path_"OrderItem"_CTLocDesc_DateFrom_"-"_DateTo_".txt"
    o file:"WNS"
    u file
    w "登记号^姓名^性别^出生日期^就诊科室代码^就诊科室名称^医嘱代码^医嘱名称^医嘱大类^医嘱子分类^诊断^就诊日期^就诊类型^行数"
    s DateFrom=$ZDH(DateFrom,3)
    s DateTo=$ZDH(DateTo,3)
    
    s Num=0 
    f Date=DateFrom:1:DateTo
    {
        //^OEORDi(0,"ItemDate",{OEORI_Date},{OE_Order.OEORD_RowId},{OEORI_Childsub})
        ///医嘱表
        s OEORDRowId=0
        for
        {
            s OEORDRowId=$o(^OEORDi(0,"ItemDate",Date,OEORDRowId)) q:(OEORDRowId="")  //User.OEOrder  就诊日期索引
            continue:'$d(^OEORD(OEORDRowId))
            s AdmRowid=$p($G(^OEORD(OEORDRowId)),"^",1)  //患者信息表 id
            continue:AdmRowid=""
            s AdmType=$p($g(^PAADM(AdmRowid)),"^",2)  //就诊类型
            s AdmType=$case(AdmType,"O":"门诊","E":"急诊","I":"住院","H":"体检",:AdmType)  //患者就诊类型
            s AdmStatus=$p($g(^PAADM(AdmRowid)),"^",20)
            continue:AdmStatus="C"                    ;过滤退号患者
            
            ;;患者基本信息
            s PAPMIID=$P($G(^PAADM(AdmRowid)),"^",1)
            continue:PAPMIID=""
            s PAPMIName=$p($g(^PAPER(PAPMIID,"ALL")),"^",1) ;姓名
            s BirthDate=$p($g(^PAPER(PAPMIID,"ALL")),"^",6) ;出生日期
            s:(BirthDate>0) BirthDate=$ZD(BirthDate,3)
            s Sex=$p($g(^PAPER(PAPMIID,"ALL")),"^",7) ;性别
            s:Sex'="" Sex=$P($G(^CT("SEX",Sex)),"^",2)
            s PatNo=$p($g(^PAPER(PAPMIID,"PAT",1)),"^",2) ;登记号
            s patDep=$P($G(^PAADM(AdmRowid)),"^",4)
            continue:patDep=""
            continue:(CTLOCRowid'="")&&(CTLOCRowid'=patDep)  //根据患者开医嘱科室过滤数据 2020-07-29
            continue:('$d(^CTLOC(patDep)))
            s CTLOCDesc=$p($g(^CTLOC(patDep)),"^",2)       //科室名称
            s CTLOCCode=$p($g(^CTLOC(patDep)),"^",1)        //科室代码
            //s AdmReasonId=$p($g(^PAADM(AdmRowid,1)),"^",7)
            //i AdmReasonId'="" s AdmReason=$p($g(^PAC("ADMREA",AdmReasonId)),"^",2) ;费别
            s PatDiag=..GetMRDiagnosandTypeToEMRJson(AdmRowid)  //诊断，改成返回JSON格式   //..GetMRDiagnosandTypeToEMR(AdmRowid) ;诊断
            continue:PatDiag=""
            
            s OEORIChildsub=0
            for
            {
                s OEORIChildsub=$o(^OEORDi(0,"ItemDate",Date,OEORDRowId,OEORIChildsub)) q:(OEORIChildsub="")   ///User.OEOrdItem  医嘱表
                S OEORIItmMastDR=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",2)  //医嘱项id
                s ARCIMSubscript=$p(OEORIItmMastDR,"||",1)
                s ARCIMVersion=$p(OEORIItmMastDR,"||",2)
                continue:(ARCIMSubscript="")||(ARCIMVersion="")
                s ARCIMCode =$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)          ; 医嘱代码
                s ARCIMDesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)           ; 医嘱名称
                s ARCIMItemCatDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10) ; 医嘱子类rowid
                s ARCIMItemCatDRDesc="",OECOrderCatDR="",OECOrderCatDRDesc=""
                if (ARCIMItemCatDR'="")
                {
                    s ARCIMItemCatDRDesc=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",2)     //医嘱子类描述
                    s OECOrderCatDR=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",8)
                    if OECOrderCatDR'="" s OECOrderCatDRDesc=$p($g(^OEC("ORCAT",OECOrderCatDR)),"^",2)  //医嘱大类描述
                }
                s Num=Num+1
                
                //"登记号^姓名^性别^出生日期^就诊科室代码^就诊科室名称^医嘱代码^医嘱名称^医嘱大类^医嘱子类^诊断^就诊日期^就诊类型^行数"
                w !,PatNo_"^"_PAPMIName_"^"_Sex_"^"_BirthDate_"^"_CTLOCCode_"^"_CTLOCDesc_"^"_ARCIMCode_"^"_ARCIMDesc_"^"_OECOrderCatDRDesc_"^"_ARCIMItemCatDRDesc_"^"_PatDiag_"^"_$ZD(Date,3)_"^"_AdmType_"^"_Num
            }
        }
    }
    
   c file
   W !,file_" 生成成功，共"_Num_"条"
   Q ""
}

/// Creator：陈莹
/// CreatDate: 2021-02-03
/// Description：导出某个日期段所有患者开过的手术申请
/// Table:CIS.AN.OperSchedule
/// Input：开始日期，结束日期，路径  CTLOCRowid科室rowid(患者所在科室ID，为空时导出所有科室数据)
/// 用于临床决策支持系统，在对应的路径下生成 OperScheduleList科室名称开始日期-结束日期.txt文件
/// d ##class(web.DHCBL.BDP.ExportDiag).FindOperScheduleList("2020-12-01","2020-12-01","D:\","")  //windows服务器
/// d ##class(web.DHCBL.BDP.ExportDiag).FindOperScheduleList("2020-11-07","2020-11-17","/tmp/",1348)   //小机
ClassMethod FindOperScheduleList(DateFrom As %String, DateTo As %String, path As %String, CTLOCRowid As %String = "") As %String
{
    S CTLocDesc=""
    if CTLOCRowid'=""
    {
        s CTLocDesc=$P($G(^CTLOC(CTLOCRowid)),"^",2)
        s CTLocDesc=$tr(CTLocDesc,"/","")   //过滤特殊符号，windows文件名里不允许存在这些符号
		s CTLocDesc=$tr(CTLocDesc,"\","")
		s CTLocDesc=$tr(CTLocDesc,":","")
		s CTLocDesc=$tr(CTLocDesc,"?","")
		s CTLocDesc=$tr(CTLocDesc,"<","")
		s CTLocDesc=$tr(CTLocDesc,">","")
		s CTLocDesc=$tr(CTLocDesc,"""","")
		s CTLocDesc=$tr(CTLocDesc,"*","")
    }
    s file=path_"OperScheduleList"_CTLocDesc_DateFrom_"-"_DateTo_".txt"
    o file:"WNS"
    u file
    w "手术名称^手术ICD10^手术申请科室名称^患者所在科室名称^患者所在医院^手术日期^患者登记号^姓名^患者性别^患者出生日期^患者就诊类型^手术备注^行数"
    s DateFrom=$ZDH(DateFrom,3)
    s DateTo=$ZDH(DateTo,3)
    s Num=0 
    
    if $d(^CIS.AN.OperScheduleD)  //新手术申请列表
    {
		for Date=DateFrom:1:DateTo   //Date:手术日期
	    {
		    set opsId=0
			for
			{
				set opsId=$order(^CIS.AN.OperScheduleI("OPDate",Date,opsId)) quit:(opsId="")  //手术日期的索引
				s (OPERDesc,OPERICD10,OPERRemarks,AppDeptID,PatDeptID,CTLOCHospitalDR,OperDate,RegNo,PatName,PatGender,PatDOB,AdmType)=""
				set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)   //手术申请表
				
				set AppDeptID=operSchedule.AppDeptID   /// 手术申请科室ID
				S:AppDeptID'="" AppDeptID=$p($g(^CTLOC(AppDeptID)),"^",2)  /// 手术申请科室描述
				
				set PatDeptID=operSchedule.PatDeptID   /// 手术申请时，患者所在的科室ID
				continue:(CTLOCRowid'="")&&(CTLOCRowid'=PatDeptID)  //根据患者所在的科室过滤数据
				s:PatDeptID'="" CTLOCHospitalDR=$p($g(^CTLOC(PatDeptID)),"^",22)     //医院
	        	s:CTLOCHospitalDR'="" CTLOCHospitalDR=$p($g(^CT("HOSP",CTLOCHospitalDR)),"^",2)   //医院描述
				S:PatDeptID'="" PatDeptID=$p($g(^CTLOC(PatDeptID)),"^",2)  /// 手术申请时，患者所在的科室描述
				
				if (operSchedule.Status'="")   /// 手术状态  //CT.AN.OperStatus
				{
					set StatusID=operSchedule.Status.%Id()
					set StatusCode=operSchedule.Status.Code
					continue:((operSchedule.OPAStatus="Cancel")||(operSchedule.OPAStatus="Decline"))  ///过滤掉状态为取消和拒绝的手术 
					set StatusDescription=operSchedule.Status.Description
				}
				set OperDate=operSchedule.OperDate   /// 手术日期
				s:OperDate>0 OperDate=$zd(OperDate,3)
				//set OPAdmType=operSchedule.OPAdmType   /// 手术就诊类型  门诊手术,住院手术
				//s OPAdmType=$case(OPAdmType,"OOP":"门诊手术","IOP":"住院手术",:OPAdmType)  /// 手术就诊类型  门诊手术,住院手术
				
				;;患者基本信息
				set EpisodeID=operSchedule.EpisodeID   /// 就诊ID  PA_Adm
				continue:EpisodeID=""
	            //s PAPMIID=$P($G(^PAADM(EpisodeID)),"^",1)
	            //continue:PAPMIID=""
	            //s PAPMIName=$p($g(^PAPER(PAPMIID,"ALL")),"^",1) ;患者姓名=PatName
	            //s BirthDate=$p($g(^PAPER(PAPMIID,"ALL")),"^",6) ;出生日期
	            //s:(BirthDate>0) BirthDate=$ZD(BirthDate,3)
	            //s Sex=$p($g(^PAPER(PAPMIID,"ALL")),"^",7) ;性别=PatGender
	            //s:Sex'="" Sex=$P($G(^CT("SEX",Sex)),"^",2)
	            //s PatNo=$p($g(^PAPER(PAPMIID,"PAT",1)),"^",2) ;登记号  =RegNo         
				set PatName=operSchedule.PatName   /// 患者姓名
				set PatGender=operSchedule.PatGender   /// 患者性别  存得描述?
				set PatDOB=operSchedule.PatDOB   /// 患者出生日期
				s:(PatDOB>0) PatDOB=$ZD(PatDOB,3)  /// 患者出生日期 ,转换格式
				set RegNo=operSchedule.RegNo   /// 患者登记号
				s AdmType=$p($g(^PAADM(EpisodeID)),"^",2)  //患者就诊类型
				s AdmType=$case(AdmType,"O":"门诊","E":"急诊","I":"住院","H":"体检",:AdmType)  //患者就诊类型
	            s AdmStatus=$p($g(^PAADM(EpisodeID)),"^",20) //就诊状态
	            continue:AdmStatus="C"                    ;过滤退号患者
	            s OperListRowId=0
	            for
	            {
		            s OperListRowId=$o(^CIS.AN.OperListI("IOPS",opsId,OperListRowId)) q:OperListRowId=""  //CIS.AN.OperList 实施手术信息
					s OperationId=$LISTGET($G(^CIS.AN.OperListD(OperListRowId)),2)  //手术rowid ORC_Operation
					s:OperationId'="" OPERDesc=$p($g(^ORC("OPER",OperationId)),"^",2)   //手术名称
					s:OperationId'="" OPERICD10=$p($g(^ORC("OPER",OperationId)),"^",14)  //手术ICD10
		            //"手术名称^手术ICD10^手术申请科室名称^患者所在科室名称^患者所在医院^手术日期^患者登记号^姓名^患者性别^患者出生日期^患者就诊类型^手术备注^行数"
	    			s Num=Num+1
		            w !,OPERDesc_"^"_OPERICD10_"^"_AppDeptID_"^"_PatDeptID_"^"_CTLOCHospitalDR_"^"_OperDate_"^"_RegNo_"^"_PatName_"^"_PatGender_"^"_PatDOB_"^"_AdmType_"^"_""_"^"_Num
	            }
	            d operSchedule.%Close()
			}	
		}
    }
    else
    {
	    //手术排班表DHC_AN_OPArrange    ^DHCANOPArrange(0,"Adm",{OPA_Adm_dr},{OPA_RowId})
		//麻醉表OR_Anaesthesia          ^OR({PA_Adm.EpisodeID_RowID},"ANA",{ANA_Childsub})  
		//手术表OR_Anaest_Operation     ^OR({PA_Adm.EpisodeID_RowID},"ANA",{Childsub},"OP",{ANAOP_Childsub})
		//手术状态opaStatus："A"是申请，"D"是拒绝，"R"是安排，"I"是术中，"P"是恢复室，"L"是离室，"F"是完成。""是全部。可以用"ARF"这样的组合查询多个状态。
		//旧手术申请列表数据  DHC_AN_OPArrange
	    for Date=DateFrom:1:DateTo   //Date:手术日期 OPAStartDate
	    {
		    set OPARowId=0
			for
			{
				set OPARowId=$order(^DHCANOPArrange(0,"SDate",Date,OPARowId)) quit:(OPARowId="")  //手术日期的索引 OPAStartDate
				s (OPERDesc,OPERICD10,OPERRemarks,AppDeptID,PatDeptID,CTLOCHospitalDR,OperDate,RegNo,PatName,PatGender,PatDOB,AdmType)=""
				set operSchedule=##class(User.DHCANOPArrange).%OpenId(OPARowId)   //手术申请列表
				set EpisodeID=operSchedule.OPAAdmDr   /// 患者就诊ID  PA_Adm
				continue:EpisodeID=""
				s OPAAnaestDr=operSchedule.OPAAnaestDr  //麻醉表
				s anaSub=$P(OPAAnaestDr,"||",2)
				continue:anaSub=""
				
				
				continue:((operSchedule.OPAStatus="C")||(operSchedule.OPAStatus="D"))  ///过滤掉状态为取消和拒绝的手术   /// 手术状态
				
				s AppDeptID=$p(^DHCANOPArrange(OPARowId),"^",54) //手术申请科室 OPA_AppLoc_Dr
				S:AppDeptID'="" AppDeptID=$p($g(^CTLOC(AppDeptID)),"^",2)  /// 手术申请科室描述
				
				set PatDeptID=operSchedule.OPAPatDeptDr   /// 手术申请时，患者所在的科室ID
				continue:(CTLOCRowid'="")&&(CTLOCRowid'=PatDeptID)  //根据患者所在的科室过滤数据
				
				s:PatDeptID'="" CTLOCHospitalDR=$p($g(^CTLOC(PatDeptID)),"^",22)     //医院
	        	s:CTLOCHospitalDR'="" CTLOCHospitalDR=$p($g(^CT("HOSP",CTLOCHospitalDR)),"^",2)   //医院描述
				S:PatDeptID'="" PatDeptID=$p($g(^CTLOC(PatDeptID)),"^",2)  /// 手术申请时，患者所在的科室描述
				set OperDate=operSchedule.OPAStartDate   /// 手术日期
				s:OperDate>0 OperDate=$zd(OperDate,3)
				
				;;患者基本信息
	            s PAPMIID=$P($G(^PAADM(EpisodeID)),"^",1)
	            continue:PAPMIID=""
	            s PatName=$p($g(^PAPER(PAPMIID,"ALL")),"^",1) ;患者姓名
	            s PatDOB=$p($g(^PAPER(PAPMIID,"ALL")),"^",6) ;出生日期
	            S:(PatDOB>0) PatDOB=$ZD(PatDOB,3)
	            s PatGender=$p($g(^PAPER(PAPMIID,"ALL")),"^",7) ;性别
	            s:PatGender'="" PatGender=$P($G(^CT("SEX",PatGender)),"^",2) ;性别描述
	            s RegNo=$p($g(^PAPER(PAPMIID,"PAT",1)),"^",2) ;登记号   $p($g(^PAPER(PAPMIID,"PAT",1)),"^",1)  //?	            
	            s AdmType=$p($g(^PAADM(EpisodeID)),"^",2)  //患者就诊类型
				s AdmType=$case(AdmType,"O":"门诊","E":"急诊","I":"住院","H":"体检",:AdmType)  //患者就诊类型
	            s AdmStatus=$p($g(^PAADM(EpisodeID)),"^",20) //就诊状态
	            continue:AdmStatus="C"                    ;过滤退号患者
	            s anaopSub=0,fe=0
				for
				{
					s anaopSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:(anaopSub="")  //手术表OR_Anaest_Operation
					s opaOperId=$P($g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)),"^",6)
					s:opaOperId'="" OPERDesc=$p($g(^ORC("OPER",opaOperId)),"^",2) //手术名称	
					s:opaOperId'="" OPERICD10=$p($g(^ORC("OPER",opaOperId)),"^",14)  //手术ICD10
					s OPERRemarks=$P($g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"DHC")),"^",2)
					//"手术名称^手术ICD10^手术申请科室名称^患者所在科室名称^患者所在医院^手术日期^患者登记号^姓名^患者性别^患者出生日期^患者就诊类型^手术备注^行数"
	            	s Num=Num+1
	           		w !,OPERDesc_"^"_OPERICD10_"^"_AppDeptID_"^"_PatDeptID_"^"_CTLOCHospitalDR_"^"_OperDate_"^"_RegNo_"^"_PatName_"^"_PatGender_"^"_PatDOB_"^"_AdmType_"^"_OPERRemarks_"^"_Num
					//if OPERDesc="" b ;1
				}
	            d operSchedule.%Close()
			}	
		}
	    
    }
	c file
	W !,file_" 生成成功，共"_Num_"条"
	Q ""
}

/// Creator：陈莹
/// CreatDate: 2021-02-03
/// Description：导出项目上检查检验治疗护理手术医嘱字典
/// Table:User.ARCItmMast
/// Input：path路径
/// 在对应的路径下生成 ExportARCItmMast.txt文件
/// d ##class(web.DHCBL.BDP.ExportDiag).ExportARCItmMast("D:\")  //windows服务器
/// d ##class(web.DHCBL.BDP.ExportDiag).ExportARCItmMast("/tmp/")   //小机
ClassMethod ExportARCItmMast(path As %String) As %String
{
   
    s file=path_"ExportARCItmMast.txt"
    o file:"WNS"
    u file
    w "医嘱代码^医嘱名称^医嘱大类^医嘱子类^医嘱开始日期^医嘱结束日期^医嘱账单单位^行数"
    s Num=0
    s ARCIMSubscript=0
    for
	{
		s ARCIMSubscript=$o(^ARCIM(ARCIMSubscript))   q:ARCIMSubscript=""  
		CONTINUE:$D(^INCI(0,"ARCIM_DR",ARCIMSubscript))>0 //过滤掉关联了库存项的医嘱项  药品和材料
		s ARCIMVersion=0
		for 
		{
			s ARCIMVersion=$o(^ARCIM(ARCIMSubscript,ARCIMVersion))  q:ARCIMVersion="" 
			continue:$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)=""  //过滤空数据	
			s ARCIMItemCatDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10) //医嘱子分类
			if ARCIMItemCatDR'=""
			{
				s ARCICOrderType=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",7)  //医嘱子分类类型
				if (ARCICOrderType'="R")&&(ARCICOrderType'="M")  //过滤药品和材料
				{
					s ARCIMCode =$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)          ; 医嘱代码
					s ARCIMDesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)           ; 医嘱名称
					s ARCIMItemCatDRDesc=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",2)     //医嘱子类名称
					s OECOrderCatDR=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",8)         //医嘱大类RowId
					if OECOrderCatDR'="" s OECOrderCatDR=$p($g(^OEC("ORCAT",OECOrderCatDR)),"^",2)  //医嘱大类名称
					
					s ARCIMBillingUOMDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",14)           ; 计帐单位 
					s:ARCIMBillingUOMDR'="" ARCIMBillingUOMDR=$p($g(^CT("UOM",ARCIMBillingUOMDR)),"^",2)
					s ARCIMEffDate=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",13)       ; 开始日期
					s:ARCIMEffDate'="" ARCIMEffDate=$p(ARCIMEffDate,"Z",1)
					s:ARCIMEffDate'="" ARCIMEffDate=$p(ARCIMEffDate,",",1)
					s ARCIMEffDateTo=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",1)      ; 结束日期 
					s:ARCIMEffDate>0 ARCIMEffDate=$zd(ARCIMEffDate,3)     ; 开始日期
					s:ARCIMEffDateTo>0 ARCIMEffDateTo=$zd(ARCIMEffDateTo,3)   ; 结束日期
					s Num=Num+1
					;"医嘱代码^医嘱名称^医嘱大类^医嘱子类^医嘱开始日期^医嘱结束日期^医嘱账单单位^行数"
            		w !,ARCIMCode_"^"_ARCIMDesc_"^"_OECOrderCatDR_"^"_ARCIMItemCatDRDesc_"^"_ARCIMEffDate_"^"_ARCIMEffDateTo_"^"_ARCIMBillingUOMDR_"^"_Num
				}
			}	
		}
	}
	c file
	W !,file_" 生成成功，共"_Num_"条"
	Q ""
}

/// Creator：陈莹
/// CreatDate: 2021-02-03
/// Description：导出项目上药品医嘱字典
/// Table:User.PHCDrgMast
/// Input：path路径
/// 在对应的路径下生成 ExportDrug.txt文件
/// d ##class(web.DHCBL.BDP.ExportDiag).ExportDrug("D:\")  //windows服务器
/// d ##class(web.DHCBL.BDP.ExportDiag).ExportDrug("/tmp/")   //小机
ClassMethod ExportDrug(path As %String) As %String
{
    s file=path_"ExportDrug.txt"
    o file:"WNS"
    u file
    w "药品代码^药品名称^医嘱大类^医嘱子分类^开始日期^结束日期^基本单位^计价单位^入库单位^门诊发药单位^住院发药单位^药品通用名^剂型^频次英文名称^频次中文名称^用法中文名^用法英文名^规格^厂商(新字段)^厂商(旧字段)^行数"
    s Num=0
    s INCIRowId=0
	for
	{
		s INCIRowId=$o(^INCI(INCIRowId)) q:((INCIRowId="")||(INCIRowId'>0))  //库存项表INC_Itm
		continue:$p($g(^INCI(INCIRowId,1)),"^",1)=""  //过滤空数据
		S INCIOriginalARCIMDR=$P($G(^INCI(INCIRowId,1)),"^",3)  ///医嘱项指针  ARC_ItmMast
		S INFORowId=""
		S:INCIRowId'="" INFORowId=$o(^DHCITMINFO(0,"INCI",INCIRowId,0))
		if INCIOriginalARCIMDR'=""
		{
			s ARCIMSubscript=$p(INCIOriginalARCIMDR,"||",1)
			s ARCIMVersion=$p(INCIOriginalARCIMDR,"||",2)
			continue:((ARCIMSubscript="")||(ARCIMVersion=""))
			s PHCDFRowId=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",12)  //药学项指针，PHC_DrgForm
			continue:PHCDFRowId=""
			s PHCDRowId=$p(PHCDFRowId,"||",1)
			s PHCDFChildSub=$p(PHCDFRowId,"||",2)
			continue:((PHCDRowId="")||(PHCDFChildSub=""))
			s ARCIMItemCatDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10) //医嘱子分类rowid
			if ARCIMItemCatDR'=""
			{
				s ARCICOrderType=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",7)  //医嘱子分类类型
				if (ARCICOrderType="R")
				{
					s ARCIMCode =$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)          ; 医嘱代码
					s ARCIMDesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)           ; 医嘱名称
					s ARCIMItemCatDRDesc=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",2)     //医嘱子类名称
					s OECOrderCatDR=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",8)         //医嘱大类RowId
					if OECOrderCatDR'="" s OECOrderCatDR=$p($g(^OEC("ORCAT",OECOrderCatDR)),"^",2)  //医嘱大类名称
					s ARCIMEffDate=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",13)       ; 开始日期
					s:ARCIMEffDate'="" ARCIMEffDate=$p(ARCIMEffDate,"Z",1)
					s:ARCIMEffDate'="" ARCIMEffDate=$p(ARCIMEffDate,",",1)
					s ARCIMEffDateTo=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",1)      ; 结束日期 
					s:ARCIMEffDate>0 ARCIMEffDate=$zd(ARCIMEffDate,3)
					s:ARCIMEffDateTo>0 ARCIMEffDateTo=$zd(ARCIMEffDateTo,3)
					s ARCIMBillingUOMDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",14)           ; 医嘱账单单位 
					s:ARCIMBillingUOMDR'="" ARCIMBillingUOMDR=$p($g(^CT("UOM",ARCIMBillingUOMDR)),"^",2)
										
					s INCICTUOMOutPatDR=$p($g(^INCI(INCIRowId,1)),"^",12)  //门诊发药单位
					s:INCICTUOMOutPatDR'="" INCICTUOMOutPatDR=$p($g(^CT("UOM",INCICTUOMOutPatDR)),"^",2)   //门诊发药单位
					
					s INCICTUOMInPatDR=$p($g(^INCI(INCIRowId,1)),"^",13)  //住院发药单位
					s:INCICTUOMInPatDR'="" INCICTUOMInPatDR=$p($g(^CT("UOM",INCICTUOMInPatDR)),"^",2)   //住院发药单位
					
					s INCICTUOMDR=$p($g(^INCI(INCIRowId,1)),"^",10)  //基本单位
					s:INCICTUOMDR'="" INCICTUOMDR=$p($g(^CT("UOM",INCICTUOMDR)),"^",2)  //基本单位
					
					s INCICTUOMPurchDR=$p($g(^INCI(INCIRowId,3)),"^",6)  //入库单位
					s:INCICTUOMPurchDR'="" INCICTUOMPurchDR=$p($g(^CT("UOM",INCICTUOMPurchDR)),"^",2)  //入库单位
						
					s PHCDGenericDR=$p($g(^PHCD(PHCDRowId,4)),"^",1)  // 药品通用名id
					s PHCDFPHCFDR=$p($g(^PHCD(PHCDRowId,"DF",PHCDFChildSub,1)),"^",1)  //剂型   //适用于8.3之前项目
					s:PHCDFPHCFDR'="" PHCDFPHCFDR=$p($g(^PHCF(PHCDFPHCFDR)),"^",2) //剂型
					
					
					if (PHCDGenericDR'="")&&($d(^DHCINCTAR)>0)  //8.3及以后项目，新医嘱模式 剂型存在药品通用名上。
					{
						s PHCDFPHCFDR=$p($g(^PHCGE("GE",PHCDGenericDR,"DHC")),"^",5)
						s:PHCDFPHCFDR'="" PHCDFPHCFDR=$p($g(^PHCF(PHCDFPHCFDR)),"^",2) //剂型
					}
					
					s:PHCDGenericDR'="" PHCDGenericDR=$p($g(^PHCGE("GE",PHCDGenericDR)),"^",2) // 药品通用名
					
					
					s (PHCDFPHCFRDRDesc1,PHCDFPHCFRDRDesc2,PHCDFPHCINDRDesc1,PHCDFPHCINDRDesc2,PHCDPHMNFDR,INFOSpec)=""
					s PHCDFPHCFRDR=$p($g(^PHCD(PHCDRowId,"DF",PHCDFChildSub,1)),"^",4) //频次
					s:PHCDFPHCFRDR'="" PHCDFPHCFRDRDesc1=$p($g(^PHCFR(PHCDFPHCFRDR)),"^",3)  //频次英文名
					s:PHCDFPHCFRDR'="" PHCDFPHCFRDRDesc2=$p($g(^PHCFR(PHCDFPHCFRDR)),"^",4)  //频次中文名
					
					s PHCDFPHCINDR=$p($g(^PHCD(PHCDRowId,"DF",PHCDFChildSub,1)),"^",5) //用法
					s:PHCDFPHCINDR'="" PHCDFPHCINDRDesc1=$p($g(^PHCIN(PHCDFPHCINDR)),"^",3)  //用法英文名
					s:PHCDFPHCINDR'="" PHCDFPHCINDRDesc2=$p($g(^PHCIN(PHCDFPHCINDR)),"^",2)  //用法中文名
					
					if INFORowId'=""
					{
						s PHCDPHMNFDR=$p($g(^DHCITMINFO(INFORowId)),"^",48) //厂商（新字段）
						s:PHCDPHMNFDR'="" PHCDPHMNFDR=$p($g(^PHMNF(PHCDPHMNFDR)),"^",2)  //厂商
						s INFOSpec=$p($g(^DHCITMINFO(INFORowId)),"^",27)  //规格
					}
					//a.INCI_ARCIM_DR->ARCIM_PHCDF_DR->PHCDF_PHCD_ParRef->PHCD_PHMNF_DR->PHMNF_Name,--厂商 老版本
					s PHCDPHMNFDR2=$p($g(^PHCD(PHCDRowId,2)),"^",4)  // 厂商（旧字段）
					s:PHCDPHMNFDR2'="" PHCDPHMNFDR2=$p($g(^PHMNF(PHCDPHMNFDR2)),"^",2)  //厂商
					s Num=Num+1
					//"药品代码^药品名称^医嘱大类^医嘱子分类^开始日期^结束日期^基本单位^计价单位^入库单位^门诊发药单位^住院发药单位^药品通用名^剂型^频次英文名称^频次中文名称^用法中文名^用法英文名^规格^厂商(新字段)^厂商(旧字段)^行数"
    				w !,ARCIMCode_"^"_ARCIMDesc_"^"_OECOrderCatDR_"^"_ARCIMItemCatDRDesc_"^"_ARCIMEffDate_"^"_ARCIMEffDateTo_"^"_INCICTUOMDR_"^"_ARCIMBillingUOMDR_"^"_INCICTUOMPurchDR_"^"_INCICTUOMOutPatDR_"^"_INCICTUOMInPatDR_"^"_PHCDGenericDR_"^"_PHCDFPHCFDR_"^"_PHCDFPHCFRDRDesc1_"^"_PHCDFPHCFRDRDesc2_"^"_PHCDFPHCINDRDesc1_"^"_PHCDFPHCINDRDesc2_"^"_INFOSpec_"^"_PHCDPHMNFDR_"^"_PHCDPHMNFDR2_"^"_Num		
				}
			}	
		}
	}
	c file
	W !,file_" 生成成功，共"_Num_"条"
	Q ""
}

/// Creator：陈莹
/// CreatDate: 2021-05-10
/// Description：导出项目上手术字典
/// Table:User.ORCOperation
/// Input：path路径
/// 在对应的路径下生成 ExportORCOperation.txt文件
/// d ##class(web.DHCBL.BDP.ExportDiag).ExportORCOperation("D:\")  //windows服务器
/// d ##class(web.DHCBL.BDP.ExportDiag).ExportORCOperation("/tmp/")   //小机
ClassMethod ExportORCOperation(path As %String) As %String
{
    s file=path_"ExportORCOperation.txt"
    o file:"WNS"
    u file
    w "手术代码^手术名称^手术ICD10^手术分级^开始日期^结束日期"
    s Num=0
    s OPERRowId=0
	for
	{
		s OPERRowId=$o(^ORC("OPER",OPERRowId)) q:((OPERRowId="")||(OPERRowId'>0))
		s OPERCode=$p($g(^ORC("OPER",OPERRowId)),"^",1)  //手术代码
		s OPERDesc=$p($g(^ORC("OPER",OPERRowId)),"^",2)  //手术名称
		s OPERICD10=$p($g(^ORC("OPER",OPERRowId)),"^",14)  //手术ICD
		s OPERDefaultCategoryDR=$p($g(^ORC("OPER",OPERRowId)),"^",7)
		i OPERDefaultCategoryDR'=""
		{
			s OPERDefaultCategoryDR=$p($g(^ORC("CATEG",OPERDefaultCategoryDR)),"^",2) //手术分级
		}
		s OPERDateActiveFrom=$p($g(^ORC("OPER",OPERRowId)),"^",5)  //开始日期
		s OPERActiveDateTo=$p($g(^ORC("OPER",OPERRowId)),"^",6)  //结束日期^
		s:OPERDateActiveFrom'="" OPERDateActiveFrom=$zd(OPERDateActiveFrom,3)
		s:OPERActiveDateTo'="" OPERActiveDateTo=$zd(OPERActiveDateTo,3)
		s Num=Num+1
		//"手术代码^手术名称^手术ICD10^手术分级^开始日期^结束日期"
    	w !,OPERCode_"^"_OPERDesc_"^"_OPERICD10_"^"_OPERDefaultCategoryDR_"^"_OPERDateActiveFrom_"^"_OPERActiveDateTo		
		
	}
	c file
	W !,file_" 生成成功，共"_Num_"条"
	Q ""
}

/// Creator：陈莹
/// CreatDate: 2021-05-10
/// Description：导出项目上诊断字典
/// Table:User.MRCICDDx
/// Input：path路径
/// 在对应的路径下生成 ExportMRCICDDx.txt文件
/// d ##class(web.DHCBL.BDP.ExportDiag).ExportMRCICDDx("D:\")  //windows服务器
/// d ##class(web.DHCBL.BDP.ExportDiag).ExportMRCICDDx("/tmp/")   //小机
ClassMethod ExportMRCICDDx(path As %String) As %String
{
    s file=path_"ExportMRCICDDx.txt"
    o file:"WNS"
    u file
    w "诊断代码^诊断名称^诊断ICD10^开始日期^结束日期^是否中医诊断^是否中医症型^肿瘤形态学编码标志^损伤中毒外部原因标志^HIS RowId^就诊类型（门诊O。急诊E。住院I。体检H。新生儿N）^诊断类型描述^性别描述^开始年龄^结束年龄^副编码^ICD9代码^注释^国家标准名称"
    s Num=0
    s MRCIDRowId=0
	for
	{
		s MRCIDRowId=$o(^MRC("ID",MRCIDRowId)) q:((MRCIDRowId="")||(MRCIDRowId'>0))
		s MRCIDCode=$p($g(^MRC("ID",MRCIDRowId)),"^",1)  //代码
		s MRCIDDesc=$p($g(^MRC("ID",MRCIDRowId)),"^",2)   //名称
		s MRCIDICD9CMCode=$p($g(^MRC("ID",MRCIDRowId)),"^",4)     ///ICD10
		s MRCIDDateActiveFrom=$p($g(^MRC("ID",MRCIDRowId)),"^",6)  //开始日期
		s MRCIDDateActiveTo=$p($g(^MRC("ID",MRCIDRowId)),"^",7)  //结束日期
		s MRCIDBillFlag3=$p($g(^MRC("ID",MRCIDRowId)),"^",15) //中医诊断标志
		s MRCIDBillFlag1=$p($g(^MRC("ID",MRCIDRowId)),"^",13) //中医标志证型
		s MRCIDMetastaticSite=$p($g(^MRC("ID",MRCIDRowId)),"^",40) //肿瘤形态学编码标志
		s MRCIDInjuryPoisoningCode=$p($g(^MRC("ID",MRCIDRowId)),"^",41) //损伤中毒外部原因标志
		s:MRCIDDateActiveFrom'="" MRCIDDateActiveFrom=$zd(MRCIDDateActiveFrom,3)
		s:MRCIDDateActiveTo'="" MRCIDDateActiveTo=$zd(MRCIDDateActiveTo,3)
		
		s MRCIDClinicType = $p($g(^MRC("ID",MRCIDRowId)),"^",47)   //就诊类型
		if MRCIDClinicType="" s MRCIDClinicType = "O,E,I,H,N"   //就诊类型为空时 默认门诊O。急诊E。住院I。体检H。新生儿N都可以开
		
		s MRCIDTypeDR=$p($g(^MRC("ID",MRCIDRowId)),"^",46)   //诊断类型
		s:MRCIDTypeDR'="" MRCIDTypeDR=$p($g(^MRC("ICDTYPE",MRCIDTypeDR)),"^",2)  //诊断类型描述
	
		s MRCIDSexDR=$p($g(^MRC("ID",MRCIDRowId)),"^",10)  //性别指针
		s:MRCIDSexDR'="" MRCIDSexDR=$p($g(^CT("SEX",MRCIDSexDR)),"^",2) //性别描述
		
		
		s MRCIDAgeFrom=$p($g(^MRC("ID",MRCIDRowId)),"^",8)  //开始年龄
		s MRCIDAgeTo=$p($g(^MRC("ID",MRCIDRowId)),"^",9)  //结束年龄
		
		s MRCID2ndCodeInPair=$p($g(^MRC("ID",MRCIDRowId)),"^",43)   //副编码
		
		s MRCIDICD9Map=$p($g(^MRC("ID",MRCIDRowId)),"^",35)     //ICD9代码
		
		s MRCIDLongDescription=$p($g(^MRC("ID",MRCIDRowId)),"^",36)   //注释
		s MRCIDNationalDesc=$p($g(^MRC("ID",MRCIDRowId)),"^",49)  //国家标准名称
		
		s Num=Num+1
		//"诊断代码^诊断名称^诊断ICD10^开始日期^结束日期^是否中医诊断^是否中医症型^肿瘤形态学编码标志^损伤中毒外部原因标志^HIS RowId^就诊类型（门诊O。急诊E。住院I。体检H。新生儿N）^诊断类型描述^性别描述^开始年龄^结束年龄^副编码^ICD9代码^注释^国家标准名称"
		w !,MRCIDCode_"^"_MRCIDDesc_"^"_MRCIDICD9CMCode_"^"_MRCIDDateActiveFrom_"^"_MRCIDDateActiveTo_"^"_MRCIDBillFlag3_"^"_MRCIDBillFlag1_"^"_MRCIDMetastaticSite_"^"_MRCIDInjuryPoisoningCode_"^"_MRCIDRowId_"^"_MRCIDClinicType_"^"_MRCIDTypeDR_"^"_MRCIDSexDR_"^"_MRCIDAgeFrom_"^"_MRCIDAgeTo_"^"_MRCID2ndCodeInPair_"^"_MRCIDICD9Map_"^"_MRCIDLongDescription_"^"_MRCIDNationalDesc		
		
	}
	c file
	W !,file_" 生成成功，共"_Num_"条"
	Q ""
}

/// Creator：陈莹
/// CreatDate: 2021-05-10
/// Description：导出项目上科室字典
/// Table:User.CTLoc
/// Input：path路径
/// 在对应的路径下生成 ExportCTLoc.txt文件
/// d ##class(web.DHCBL.BDP.ExportDiag).ExportCTLoc("D:\")  //windows服务器
/// d ##class(web.DHCBL.BDP.ExportDiag).ExportCTLoc("/tmp/")   //小机
ClassMethod ExportCTLoc(path As %String) As %String
{
    s file=path_"ExportCTLoc.txt"
    o file:"WNS"
    u file
    w "科室RowId^科室代码^科室名称^科室部门组^科室类型^开始日期^结束日期^医院"
    s Num=0
    s CTLOCRowID=0
	for
	{
		s CTLOCRowID=$o(^CTLOC(CTLOCRowID)) q:((CTLOCRowID="")||(CTLOCRowID'>0))
        s CTLOCCode=$p($g(^CTLOC(CTLOCRowID)),"^",1)        //科室代码
        s CTLOCDesc=$p($g(^CTLOC(CTLOCRowID)),"^",2)       //科室名称
        s CTLOCDepDR=$p($g(^CTLOC(CTLOCRowID)),"^",19)      //科室部门组 
        s:CTLOCDepDR'="" CTLOCDepDR=$p($g(^RBC("DEP",CTLOCDepDR)),"^",2)  //科室部门组名称
        s CTLOCType=$p($g(^CTLOC(CTLOCRowID)),"^",13)       //类型
        s CTLOCDateActiveFrom=$p($G(^CTLOC(CTLOCRowID)),"^",24) //开始日期
        s CTLOCDateActiveTo=$p($g(^CTLOC(CTLOCRowID)),"^",25)    //结束日期
        s:CTLOCDateActiveFrom'="" CTLOCDateActiveFrom=$zd(CTLOCDateActiveFrom,3) //转换日期格式
        s:CTLOCDateActiveTo'="" CTLOCDateActiveTo=$zd(CTLOCDateActiveTo,3) //转换日期格式
        s CTLOCHospitalDR=$p($g(^CTLOC(CTLOCRowID)),"^",22)     //医院
        s:CTLOCHospitalDR'="" CTLOCHospitalDR=$p($g(^CT("HOSP",CTLOCHospitalDR)),"^",2)   //医院描述       
       	s Num=Num+1
		//"科室RowId^科室代码^科室名称^科室部门组^科室类型^开始日期^结束日期^医院"
    	w !,CTLOCRowID_"^"_CTLOCCode_"^"_CTLOCDesc_"^"_CTLOCDepDR_"^"_CTLOCType_"^"_CTLOCDateActiveFrom_"^"_CTLOCDateActiveTo_"^"_CTLOCHospitalDR		
		
	}
	c file
	W !,file_" 生成成功，共"_Num_"条"
	Q ""
}

/// Creator：陈莹
/// CreatDate: 2021-07-27
/// Description：导出项目上检检验对应外部代码字典  HIS医嘱-检验大项（ 项目组合套）
/// Table:User.ARCItemExternalCodes
/// Input：path路径
/// 在对应的路径下生成 ExportARCItemExternalCodes.txt文件
/// d ##class(web.DHCBL.BDP.ExportDiag).ExportARCItemExternalCodes("D:\")  //windows服务器
/// d ##class(web.DHCBL.BDP.ExportDiag).ExportARCItemExternalCodes("/tmp/")   //小机
ClassMethod ExportARCItemExternalCodes(path As %String) As %String
{
   
    s file=path_"ExportARCItemExternalCodes.txt"
    o file:"WNS"
    u file
    w "医嘱代码^医嘱名称^医嘱大类^医嘱子类^医嘱开始日期^医嘱结束日期^对应检验项目代码^对应检验项目名称^接收科室^对应开始日期^对应结束日期"
    s Num=0
    s ARCIMSubscript=0
    for
	{
		s ARCIMSubscript=$o(^ARCIM(ARCIMSubscript))   q:ARCIMSubscript=""  
		CONTINUE:$D(^INCI(0,"ARCIM_DR",ARCIMSubscript))>0 //过滤掉关联了库存项的医嘱项  药品和材料
		s ARCIMVersion=0
		for 
		{
			s ARCIMVersion=$o(^ARCIM(ARCIMSubscript,ARCIMVersion))  q:ARCIMVersion="" 
			continue:$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)=""  //过滤空数据	
			s ARCIMItemCatDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10) //医嘱子分类
			if ARCIMItemCatDR'=""
			{
				s OECOrderCatDR=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",8)         //医嘱大类RowId
				if OECOrderCatDR'="" s OECOrderCatDR=$p($g(^OEC("ORCAT",OECOrderCatDR)),"^",2)  //医嘱大类名称
				s EXTChildSub=0
				for
				{
					s EXTChildSub=$o(^ARCIM(ARCIMSubscript,ARCIMVersion,"EXT",EXTChildSub)) q:EXTChildSub=""
					s EXTRowId=ARCIMSubscript_"||"_ARCIMVersion_"||"_EXTChildSub
					s EXTCode=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,"EXT",EXTChildSub)),"^",4)
					s EXTDesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,"EXT",EXTChildSub)),"^",6)
					s EXTCTLOCDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,"EXT",EXTChildSub)),"^",8)
					s:EXTCTLOCDR'="" EXTCTLOCDR=$p($g(^CTLOC(EXTCTLOCDR)),"^",2) //获取科室描述
					s EXTDateFrom=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,"EXT",EXTChildSub)),"^",1)  //对应开始日期
					s EXTDateTo=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,"EXT",EXTChildSub)),"^",2)  //对应结束日期
					continue:((EXTDateTo'="")&&(EXTDateTo<+$h))
					s:EXTDateFrom'="" EXTDateFrom=$zd(EXTDateFrom,3) //转换日期格式
					s:EXTDateTo'="" EXTDateTo=$zd(EXTDateTo,3) //转换日期格式
					s ARCIMCode =$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)          ; 医嘱代码
					s ARCIMDesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)           ; 医嘱名称
					s ARCIMItemCatDRDesc=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",2)     //医嘱子类名称	
					s ARCIMBillingUOMDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",14)           ; 计帐单位 
					s:ARCIMBillingUOMDR'="" ARCIMBillingUOMDR=$p($g(^CT("UOM",ARCIMBillingUOMDR)),"^",2)
					s ARCIMEffDate=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",13)       ; 开始日期
					s:ARCIMEffDate'="" ARCIMEffDate=$p(ARCIMEffDate,"Z",1)
					s:ARCIMEffDate'="" ARCIMEffDate=$p(ARCIMEffDate,",",1)
					s ARCIMEffDateTo=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",1)      ; 结束日期 
					s:ARCIMEffDate'="" ARCIMEffDate=$zd(ARCIMEffDate,3)     ; 医嘱项开始日期
					s:ARCIMEffDateTo'="" ARCIMEffDateTo=$zd(ARCIMEffDateTo,3)   ;  医嘱项结束日期
					s Num=Num+1
					;"医嘱代码^医嘱名称^医嘱大类^医嘱子类^医嘱开始日期^医嘱结束日期^对应检验项目代码^对应检验项目名称^接收科室^对应开始日期^对应结束日期"
	        		w !,ARCIMCode_"^"_ARCIMDesc_"^"_OECOrderCatDR_"^"_ARCIMItemCatDRDesc_"^"_ARCIMEffDate_"^"_ARCIMEffDateTo_"^"_EXTCode_"^"_EXTDesc_"^"_EXTCTLOCDR_"^"_EXTDateFrom_"^"_EXTDateTo
				}	
			}
		}
	}
	c file
	W !,file_" 生成成功，共"_Num_"条"
	Q ""
}

/// Creator：陈莹
/// CreatDate: 2021-07-27
/// Description：导出项目上检验项目（检验组合套）-检验小项-HIS检验医嘱
/// Table:dbo.BTTestSetLayout /User.ARCItemExternalCodes
/// Input：path路径
/// 在对应的路径下生成 ExportBTTestSetLayout.txt文件
/// d ##class(web.DHCBL.BDP.ExportDiag).ExportBTTestSetLayout("D:\")  //windows服务器
/// d ##class(web.DHCBL.BDP.ExportDiag).ExportBTTestSetLayout("/tmp/")   //小机
ClassMethod ExportBTTestSetLayout(path As %String) As %String
{
   
    s file=path_"ExportBTTestSetLayout.txt"
    o file:"WNS"
    u file
    w "检验大项代码^检验大项名称^检验大项激活状态^检验大项医院^检验小项代码^检验小项名称^检验小项对应标准码^检验小项激活状态^检验小项医院^HIS医嘱代码^HIS医嘱名称^医嘱大类^医嘱子类^医嘱开始日期^医嘱结束日期^HIS接收科室^对照开始日期^对照结束日期^标本类型^采集提示"
    s Num=0
    s RowID=0
	for 
	{
		s RowID=$o(^dbo.BTTestSetLayoutD(RowID)) q:RowID=""
		s TestSetDR =$lg($g(^dbo.BTTestSetLayoutD(RowID)),2)  //检验组合套
		s (TestSetCode,TestSetCName,TestSetActive,TestSetHospitalDR,SpecimenDR,CollectPromptDR)=""
		if TestSetDR'=""
		{
			s TestSetCode= $lg($g(^dbo.BTTestSetD(TestSetDR)),2)
			s TestSetCName= $lg($g(^dbo.BTTestSetD(TestSetDR)),3)		//名称
			s TestSetActive= $lg($g(^dbo.BTTestSetD(TestSetDR)),18)		//激活
			s TestSetActive=$CASE(TestSetActive,"1":"Y","0":"N","":"Y",:"N")
			s TestSetHospitalDR= $lg($g(^dbo.BTTestSetD(TestSetDR)),4)		//医院
			s:TestSetHospitalDR'="" TestSetHospitalDR=$lg($g(^dbo.BTHospitalD(TestSetHospitalDR)),3)
			
			s SpecimenDR= $lg($g(^dbo.BTTestSetD(TestSetDR)),10)	//默认标本类型 
			s:SpecimenDR'="" SpecimenDR=$lg($g(^dbo.BTSpecimenD(SpecimenDR)),3)	//默认标本类型描述
			
			s CollectPromptDR= $lg($g(^dbo.BTTestSetD(TestSetDR)),15)		//采集提示 
			s:CollectPromptDR'="" CollectPromptDR=$lg($g(^dbo.BTCollectPromptD(CollectPromptDR)),3)	//采集提示描述 
		}
		s (Code,CName,SCode,Active,HospitalDR)=""
		s TestCodeDR=$lg($g(^dbo.BTTestSetLayoutD(RowID)),4)  //检验小项
		if TestCodeDR'=""
		{
			s Code= $lg($g(^dbo.BTTestCodeD(TestCodeDR)),2)		//代码
			s CName= $lg($g(^dbo.BTTestCodeD(TestCodeDR)),3)		//描述
			s HospitalDR = $lg($g(^dbo.BTTestCodeD(TestCodeDR)),4)  //医院DR
			s:HospitalDR'="" HospitalDR=$lg($g(^dbo.BTHospitalD(HospitalDR)),3)	//医院描述
			s SCode = $lg($g(^dbo.BTTestCodeD(TestCodeDR)),14)		//标准码
			s:SCode'="" SCode=$lg($g(^dbo.BTTestCodeSCodeD(SCode)),3)	//标准码描述
			s Active = $lg($g(^dbo.BTTestCodeD(TestCodeDR)),25)   //激活
			s Active=$CASE(Active,"1":"Y","0":"N","":"Y",:"N")
			
		}
		s (ARCIMCode,ARCIMDesc,OECOrderCatDR,ARCIMItemCatDRDesc,ARCIMEffDate,ARCIMEffDateTo,EXTCTLOCDR,EXTDateFrom,EXTDateTo)=""
		
		if TestSetCode'=""
		{
			s ARCIMSubscript=0
		    for
			{
				s ARCIMSubscript=$o(^ARCIM(0,"ExtCode",$$ALPHAUP^SSUTIL4(TestSetCode),ARCIMSubscript)) q:ARCIMSubscript=""  
				s ARCIMVersion=0
				for 
				{
					s ARCIMVersion=$o(^ARCIM(0,"ExtCode",$$ALPHAUP^SSUTIL4(TestSetCode),ARCIMSubscript,ARCIMVersion))  q:ARCIMVersion="" 
					continue:$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)=""  //过滤空数据	
					s ARCIMItemCatDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10) //医嘱子分类
					if ARCIMItemCatDR'=""
					{
						s OECOrderCatDR=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",8)         //医嘱大类RowId
						if OECOrderCatDR'="" s OECOrderCatDR=$p($g(^OEC("ORCAT",OECOrderCatDR)),"^",2)  //医嘱大类名称	
					}
					s ARCIMCode =$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)          ; 医嘱代码
					s ARCIMDesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)           ; 医嘱名称
					s ARCIMItemCatDRDesc=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",2)     //医嘱子类名称	
					s ARCIMBillingUOMDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",14)           ; 计帐单位 
					s:ARCIMBillingUOMDR'="" ARCIMBillingUOMDR=$p($g(^CT("UOM",ARCIMBillingUOMDR)),"^",2)
					s ARCIMEffDate=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",13)       ; 开始日期
					s:ARCIMEffDate'="" ARCIMEffDate=$p(ARCIMEffDate,"Z",1)
					s:ARCIMEffDate'="" ARCIMEffDate=$p(ARCIMEffDate,",",1)
					s ARCIMEffDateTo=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",1)      ; 结束日期
					continue:(ARCIMEffDateTo'="")&&(ARCIMEffDateTo<+$h)
					s:ARCIMEffDate'="" ARCIMEffDate=$zd(ARCIMEffDate,3)     ; 开始日期
					s:ARCIMEffDateTo'="" ARCIMEffDateTo=$zd(ARCIMEffDateTo,3)   ; 结束日期
					
					s EXTChildSub=0
					for 
					{
						s EXTChildSub=$o(^ARCIM(0,"ExtCode",$$ALPHAUP^SSUTIL4(TestSetCode),ARCIMSubscript,ARCIMVersion,EXTChildSub))  q:EXTChildSub="" 
						
						s EXTCTLOCDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,"EXT",EXTChildSub)),"^",8)
						s:EXTCTLOCDR'="" EXTCTLOCDR=$p($g(^CTLOC(EXTCTLOCDR)),"^",2) //获取科室描述
						s EXTDateFrom=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,"EXT",EXTChildSub)),"^",1)
						s EXTDateTo=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,"EXT",EXTChildSub)),"^",2)
						continue:(EXTDateTo'="")&&(EXTDateTo<+$h)
						s:EXTDateFrom'="" EXTDateFrom=$zd(EXTDateFrom,3) //转换日期格式
        				s:EXTDateTo'="" EXTDateTo=$zd(EXTDateTo,3) //转换日期格式
						s Num=Num+1
						;"检验大项代码^检验大项名称^检验大项激活状态^检验大项医院^检验小项代码^检验小项名称^检验小项对应标准码^检验小项激活状态^检验小项医院^HIS医嘱代码^HIS医嘱名称^医嘱大类^医嘱子类^医嘱开始日期^医嘱结束日期^接收科室^对应开始日期^对应结束日期^标本类型^采集提示"
						w !,TestSetCode_"^"_TestSetCName_"^"_TestSetActive_"^"_TestSetHospitalDR_"^"_Code_"^"_CName_"^"_SCode_"^"_Active_"^"_HospitalDR_"^"_ARCIMCode_"^"_ARCIMDesc_"^"_OECOrderCatDR_"^"_ARCIMItemCatDRDesc_"^"_ARCIMEffDate_"^"_ARCIMEffDateTo_"^"_EXTCTLOCDR_"^"_EXTDateFrom_"^"_EXTDateTo_"^"_SpecimenDR_"^"_CollectPromptDR
		
					}
				}
			}
		}
		else
		{
			s Num=Num+1
			;"检验大项代码^检验大项名称^检验大项激活状态^检验大项医院^检验小项代码^检验小项名称^检验小项对应标准码^检验小项激活状态^检验小项医院^HIS医嘱代码^HIS医嘱名称^医嘱大类^医嘱子类^医嘱开始日期^医嘱结束日期^接收科室^对应开始日期^对应结束日期^标本类型^采集提示"
			w !,TestSetCode_"^"_TestSetCName_"^"_TestSetActive_"^"_TestSetHospitalDR_"^"_Code_"^"_CName_"^"_SCode_"^"_Active_"^"_HospitalDR_"^"_ARCIMCode_"^"_ARCIMDesc_"^"_OECOrderCatDR_"^"_ARCIMItemCatDRDesc_"^"_ARCIMEffDate_"^"_ARCIMEffDateTo_"^"_EXTCTLOCDR_"^"_EXTDateFrom_"^"_EXTDateTo_"^"_SpecimenDR_"^"_CollectPromptDR		
		}
		
	}
    
	c file
	W !,file_" 生成成功，共"_Num_"条"
	Q ""
}

/// Creator：陈莹
/// CreatDate: 2021-07-27
/// Description：导出项目上检验大项
/// Table:dbo.BTTestSet
/// Input：path路径
/// 在对应的路径下生成 ExportBTTestSet.txt文件
/// d ##class(web.DHCBL.BDP.ExportDiag).ExportBTTestSet("D:\")  //windows服务器
/// d ##class(web.DHCBL.BDP.ExportDiag).ExportBTTestSet("/tmp/")   //小机
ClassMethod ExportBTTestSet(path As %String) As %String
{
   
    s file=path_"ExportBTTestSet.txt"
    o file:"WNS"
    u file
    w "检验大项代码^检验大项名称^检验大项激活状态^检验大项医院^标本类型^采集提示"
    s Num=0
    s RowID=0
	for 
	{
		s RowID=$o(^dbo.BTTestSetD(RowID)) q:RowID=""
		s TestSetCode= $lg($g(^dbo.BTTestSetD(RowID)),2)
		s TestSetCName= $lg($g(^dbo.BTTestSetD(RowID)),3)		//名称
		s TestSetActive= $lg($g(^dbo.BTTestSetD(RowID)),18)		//激活
		s TestSetActive=$CASE(TestSetActive,"1":"Y","0":"N","":"Y",:"N")
		s TestSetHospitalDR= $lg($g(^dbo.BTTestSetD(RowID)),4)		//医院
		s:TestSetHospitalDR'="" TestSetHospitalDR=$lg($g(^dbo.BTHospitalD(TestSetHospitalDR)),3)
		
		s SpecimenDR= $lg($g(^dbo.BTTestSetD(RowID)),10)	//默认标本类型 
		s:SpecimenDR'="" SpecimenDR=$lg($g(^dbo.BTSpecimenD(SpecimenDR)),3)	//默认标本类型描述
		
		s CollectPromptDR= $lg($g(^dbo.BTTestSetD(RowID)),15)		//采集提示 
		s:CollectPromptDR'="" CollectPromptDR=$lg($g(^dbo.BTCollectPromptD(CollectPromptDR)),3)	//采集提示描述 
		s Num=Num+1
		;"检验大项代码^检验大项名称^检验大项激活状态^检验大项医院^标本类型^采集提示"
		w !,TestSetCode_"^"_TestSetCName_"^"_TestSetActive_"^"_TestSetHospitalDR_"^"_SpecimenDR_"^"_CollectPromptDR
	}
    
	c file
	W !,file_" 生成成功，共"_Num_"条"
	Q ""
}

/// Creator：陈莹
/// CreatDate: 2021-08-17
/// Description：导出项目上-检验小项
/// Table:dbo.BTTestCode
/// Input：path路径
/// 在对应的路径下生成 ExportBTTestCode.txt文件
/// d ##class(web.DHCBL.BDP.ExportDiag).ExportBTTestCode("D:\")  //windows服务器
/// d ##class(web.DHCBL.BDP.ExportDiag).ExportBTTestCode("/tmp/")   //小机
ClassMethod ExportBTTestCode(path As %String) As %String
{
   
    s file=path_"ExportBTTestCode.txt"
    o file:"WNS"
    u file
    w "检验小项代码^检验小项名称^检验小项对应标准码^检验小项激活状态^检验小项医院"
    s Num=0
    s RowID=0
	for 
	{
		s RowID=$o(^dbo.BTTestCodeD(RowID)) q:RowID=""
		s Code= $lg($g(^dbo.BTTestCodeD(RowID)),2)		//代码
		s CName= $lg($g(^dbo.BTTestCodeD(RowID)),3)		//描述
		s HospitalDR = $lg($g(^dbo.BTTestCodeD(RowID)),4)  //医院DR
		s:HospitalDR'="" HospitalDR=$lg($g(^dbo.BTHospitalD(HospitalDR)),3)	//医院描述
		s SCode = $lg($g(^dbo.BTTestCodeD(RowID)),14)		//标准码
		s:SCode'="" SCode=$lg($g(^dbo.BTTestCodeSCodeD(SCode)),3)	//标准码描述
		s Active = $lg($g(^dbo.BTTestCodeD(RowID)),25)   //激活
		s Active=$CASE(Active,"1":"Y","0":"N","":"Y",:"N")
		s Num=Num+1
		;"检验小项代码^检验小项名称^检验小项对应标准码^检验小项激活状态^检验小项医院"
		w !,Code_"^"_CName_"^"_SCode_"^"_Active_"^"_HospitalDR
	}
    
	c file
	W !,file_" 生成成功，共"_Num_"条"
	Q ""
}

}
