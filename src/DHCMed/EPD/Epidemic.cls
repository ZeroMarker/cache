Class DHCMed.EPD.Epidemic Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MEPD_Rowid, SqlTableName = Epidemic, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCMedEpidemicSub As DHCMed.EPD.EpidemicSub [ Cardinality = children, Inverse = MEPDSParRef ];

/// PatientID(Pa_Patmas.ID)
Property MEPDPapmiDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = MEPD_Papmi_DR ];

/// 传染病患者所属区域(DHCMed.SS.Dictionary->Code)（本县区、本市其他县区、本省其它地市、外省、港澳台、外籍）
Property MEPDArea As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MEPD_Area ];

/// 职业(DHCMed.SS.Dictionary->Code)
Property MEPDOccupation As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = MEPD_Occupation ];

/// 家长姓名
Property MEPDFamName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = MEPD_FamName ];

/// 传染病诊断
Property MEPDICDDR As DHCMed.EPD.Infection [ SqlColumnNumber = 6, SqlFieldName = MEPD_ICD_DR ];

/// 传染病人密切接触情况(DHCMed.SS.Dictionary->Code)（有、无）
Property MEPDIntimateCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = MEPD_IntimateCode ];

/// 诊断类型
Property MEPDDiagnoseType As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = MEPD_DiagnoseType ];

/// 发病日期
Property MEPDSickDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = MEPD_SickDate ];

/// 传染病诊断分类(DHCMed.SS.Dictionary->Code)（临床诊断病例、实验室确诊病例、疑似病例、病原携带者、阳性检测结果）
Property MEPDDiagDegree As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = MEPD_DiagDegree ];

/// 诊断日期
Property MEPDDiagDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = MEPD_DiagDate ];

/// 传染病发病程度(DHCMed.SS.Dictionary->Code)（急性、慢性、未分类）
Property MEPDSickKind As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = MEPD_SickKind ];

/// 死亡日期
Property MEPDDeathDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = MEPD_DeathDate ];

/// 报告科室(CT_Loc.ID)
Property MEPDLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = MEPD_Loc_DR ];

/// 上报位置(DHCMed.SS.Dictionary->Code)（门诊、急诊、住院）
Property MEPDRepPlace As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = MEPD_RepPlace ];

/// 报告状态(DHCMed.SS.Dictionary->Code)
Property MEPDStatus As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = MEPD_Status ];

/// 填报人(SS_User.ID)
Property MEPDRepUsrDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = MEPD_RepUsr_DR ];

/// 报告日期
Property MEPDRepDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 18, SqlFieldName = MEPD_RepDate ];

/// 报告时间
Property MEPDRepTime As %Library.Time [ SqlColumnNumber = 19, SqlFieldName = MEPD_RepTime ];

/// 审核人(SS_User.ID)
Property MEPDCheckUsrDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = MEPD_CheckUsr_DR ];

/// 审核日期
Property MEPDCheckDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 21, SqlFieldName = MEPD_CheckDate ];

/// 审核时间
Property MEPDCheckTime As %Library.Time [ SqlColumnNumber = 22, SqlFieldName = MEPD_CheckTime ];

/// 备注信息
Property MEPDDemo As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = MEPD_Demo ];

/// 删除原因
Property MEPDDelReason As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = MEPD_DelReason ];

/// 指向被订正报告
Property MEPDMepdDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 25, SqlFieldName = MEPD_Mepd_DR ];

/// 联系电话
Property MEPDTelPhone As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = MEPD_TelPhone ];

/// 现住址详细地址
Property MEPDAddress As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = MEPD_Address ];

/// 工作单位/学校
Property MEPDCompany As %Library.String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = MEPD_Company ];

/// 户籍地址详细地址
Property MEPDIDAddress As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = MEPD_IDAddress ];

/// 就诊号
Property MEPDText1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = MEPD_Text1 ];

/// 报告编号
Property MEPDText2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = MEPD_Text2 ];

/// 是否已经上传数据（Y、N）
Property MEPDIsUpload As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 32, SqlFieldName = MEPD_IsUpload ];

/// 居住地省市（DHCMed.EPD.AreaDic.ID）
Property MEPDProvince As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = MEPD_Province ];

/// 居住地地市（DHCMed.EPD.AreaDic.ID）
Property MEPDCity As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = MEPD_City ];

/// 居住地区县（DHCMed.EPD.AreaDic.ID）
Property MEPDCounty As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = MEPD_County ];

/// 居住地乡镇（DHCMed.EPD.AreaDic.ID）
Property MEPDVillage As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = MEPD_Village ];

/// 街道门牌号
Property MEPDRoad As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 37, SqlFieldName = MEPD_Road ];

/// 诊断日期时间(格式：2016-01-01 10:11)
Property MEPDDiagDateTime As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = MEPD_DiagDateTime ];

/// 报告病区（CT_Loc.ID）
Property MEPDText3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 39, SqlFieldName = MEPD_Text3 ];

/// 证件类型
/// 病人基本信息表证件类型字段：Pa_patmas.Papmi_CardType_Dr
Property MEPDText4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 40, SqlFieldName = MEPD_Text4 ];

/// 证件号码
/// 如果证件类型为身份证，证件号码回写病人基本信息表
/// 病人基本信息表证件号码字段：Pa_patmas.Papmi_DVNumber
Property MEPDText5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = MEPD_Text5 ];

/// 其他人群
/// 备用字段6
Property MEPDText6 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 42, SqlFieldName = MEPD_Text6 ];

/// 临床严重程度  (DHCMed.SS.Dictionary->Code)（无症状感染者、轻症病例、普通肺炎、重症肺炎、危重症肺炎）
/// 用于新型冠状病毒感染的肺炎填报 add 20200203
Property MEPDSeverity As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 43, SqlFieldName = MEPD_Severity ];

/// 是否为输入病例
Property MEPDIsInEPD As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 44, SqlFieldName = MEPD_IsInEPD ];

/// 入境前居住国家或地区
Property MEPDContr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 45, SqlFieldName = MEPD_Contr ];

/// 首次报卡日期
Property MEPDFirRepDate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 46, SqlFieldName = MEPD_FirRepDate ];

Index IndexOfEpisode On MEPDText1;

Index MEPDIsUploadIndex On MEPDIsUpload;

Index IndexRepDate On MEPDRepDate;

ClassMethod GetObjById(ID As %String) As DHCMed.EPD.Epidemic
{
	New (ID)
	Set obj=##Class(DHCMed.EPD.Epidemic).%OpenId(ID)
	
	//注意：如果根据ID获取的obj不是一个对象，则返回空串""
	If $IsObject(obj){
		//通过计算得到卡片编号,存储在字段MEPDText2中
		Set ReportID=obj.%Id()
		Set tmpRepDate=obj.MEPDRepDate
		Set StartNum=$o(^DHCMed.EPDi("EPD",0,"RepDate",tmpRepDate,0))
		Set RepNo=(ReportID-StartNum)+1
		Set tmpRepNo=""
		Set $p(tmpRepNo,"0",4-$l(RepNo))=RepNo
		Set RepNo=$tr($zd(tmpRepDate,3),"-","")_tmpRepNo
		Set obj.MEPDText2=RepNo
		
		//add by zf 20120114 增加诊断日期+时间
		set DiagDateTime=obj.MEPDDiagDateTime
		if DiagDateTime="" {
			set DiagDate=obj.MEPDSickDate
			Set:DiagDate'="" DiagDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DiagDate)
			set:DiagDate'="" DiagDateTime=DiagDate_" 00:00"
		}
		set obj.MEPDDiagDateTime=DiagDateTime
		
		// *********************************************** //
		// Modified By zhufei 2012-07-17
		// FixBug：解决传染病上报时，由于前台误操作造成的EpisodeID和PatientID传值错误问题
		set Papmi=obj.MEPDPapmiDR
		set Paadm=obj.MEPDText1
		set:Paadm'="" Papmi=$p($g(^PAADM(Paadm)),"^",1)
		set obj.MEPDPapmiDR=Papmi
		// *********************************************** //
	}
	If obj'="" Do obj.%Close()
	Quit obj
}

Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
	} 
	set return=..%Id()_separete
	set return=return_..MEPDPapmiDR_separete
	set return=return_..MEPDArea_separete
	set return=return_..MEPDOccupation_separete
	set return=return_..MEPDFamName_separete
	set return=return_..MEPDICDDR.%Id()_separete
	set return=return_..MEPDIntimateCode_separete
	set return=return_..MEPDDiagnoseType_separete
	set return=return_##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(..MEPDSickDate)_separete
	set return=return_..MEPDDiagDegree_separete
	set return=return_##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(..MEPDDiagDate)_separete
	set return=return_..MEPDSickKind_separete
	set return=return_##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(..MEPDDeathDate)_separete
	set return=return_..MEPDLocDR_separete
	set return=return_..MEPDStatus_separete
	set return=return_..MEPDRepUsrDR_separete
	set return=return_##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(..MEPDRepDate)_separete
	set return=return_$s(+..MEPDRepTime>0:$zt(..MEPDRepTime,1),1:"")_separete
	set return=return_..MEPDCheckUsrDR_separete
	set return=return_##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(..MEPDCheckDate)_separete
	set return=return_$s(+..MEPDCheckTime>0:$zt(..MEPDCheckTime,1),1:"")_separete
	set return=return_..MEPDDemo_separete
	set return=return_..MEPDDelReason_separete
	set return=return_$s($IsObject(..MEPDMepdDR):..MEPDMepdDR.%Id(),1:"")_separete
	set return=return_..MEPDTelPhone_separete
	set return=return_..MEPDAddress_separete
	set return=return_..MEPDCompany_separete
	set return=return_..MEPDIDAddress_separete
	set return=return_..MEPDText1_separete	
	set return=return_..MEPDText2_separete
	set return=return_..MEPDIsUpload_separete
	set return=return_..MEPDProvince_separete
	set return=return_..MEPDCity_separete
	set return=return_..MEPDCounty_separete
	set return=return_..MEPDVillage_separete	
	set return=return_..MEPDRoad_separete
	
	//update by zf 20120114
	set DiagDateTime=..MEPDDiagDateTime
	if DiagDateTime="" {
		set DiagDate=..MEPDSickDate
		Set:DiagDate'="" DiagDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DiagDate)
		set:DiagDate'="" DiagDateTime=DiagDate_" 00:00"
	}
	set return=return_DiagDateTime_separete
	
	//add by zf 20120511
	set return=return_..MEPDText3_separete
	set return=return_..MEPDText4_separete
	set return=return_..MEPDText5_separete
	set return=return_..MEPDText6_separete  //update 20200203 
	set return=return_..MEPDSeverity  
	
	q return
}

/// Creator：     李阳
/// CreatDate：   2010-04-08
/// Description:  根据ID取传染病附卡信息
/// Input：       DHCMed.EPD.AppendixCard.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.EPD.Epidemic).GetStringById(1)
ClassMethod GetStringById(id As %String, separete As %String) As %String
{
	new (id,separete)
	set return=""
	set obj=..GetObjById(id)
	if $IsObject(obj){
		set return=obj.ToString($g(separete))
	}	
	quit return
}

/// 功能：保存传染病附卡信息
/// 参数：Rowid^代码^描述^是否生效^类别^生效日期^备注
/// 返回值：生成的Rowid
/// w ##class(DHCMed.EPD.Epidemic).Update("^01^北京市性病报告卡^Y^类别^2011-6-11^备注","^")
ClassMethod Update(Instring As %String, separete As %String) As %String
{
	n (Instring,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
	}
	
	// *********************************************** //
	// Modified By zhufei 2012-07-17
	// FixBug：解决传染病上报时，由于前台误操作造成的EpisodeID和PatientID传值错误问题
	s Papmi=""
	s Paadm=$p(Instring,separete,30)
	s:Paadm'="" Papmi=$p($g(^PAADM(Paadm)),"^",1)
	// *********************************************** //
    
    s MEPDRowid=$p(Instring,separete,1)     ;MEPD_Rowid
	s epdReport=""
	s:MEPDRowid'="" epdReport=$g(^DHCMed.EPD("EPD",MEPDRowid))
	Set OldStatus = ""
	if (MEPDRowid'=""){
		Set OldStatus = $p(^DHCMed.EPD("EPD",MEPDRowid),"^",15)
	}
	
	
	// *********************************************** //
	// Modified By zhufei 2012-07-17
	// FixBug：解决传染病上报时，由于前台误操作造成的EpisodeID和PatientID传值错误问题
    s PLIST(2)=Papmi	//$p(Instring,separete,2)      ;MEPD_Papmi_DR
    // *********************************************** //
    
    s PLIST(3)=$p(Instring,separete,3)      ;MEPD_Area
    s PLIST(4)=$p(Instring,separete,4)      ;MEPD_Occupation
    s PLIST(5)=$p(Instring,separete,5)      ;MEPD_FamName
    s PLIST(6)=+$p(Instring,separete,6)      ;MEPD_ICD_DR //Modified By LiYang 如果保存草稿，可能无法选择疾病，所以必须保证索引不能为空
    s PLIST(7)=$p(Instring,separete,7)      ;MEPD_IntimateCode
    s PLIST(8)=$p(Instring,separete,8)      ;MEPD_DiagnoseType
    s PLIST(9)=$p(Instring,separete,9)      ;MEPD_SickDate
    s:(+PLIST(9))=0 PLIST(9)=""
    Set PLIST(9)=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(PLIST(9))
    s PLIST(10)=$p(Instring,separete,10)      ;MEPD_DiagDegree
    s DiagDateTime=$p(Instring,separete,11)   ;MEPD_DiagDate
    s DiagDate=$p(DiagDateTime," ",1)
    s DiagTime=$p(DiagDateTime," ",2)
    Set:DiagDate'="" DiagDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(DiagDate)
    s:DiagDate="" DiagDate=+$h
    s:DiagTime="" DiagTime=$p($h,",",2)
    s:DiagTime[":" DiagTime=$zth(DiagTime)
    s PLIST(11)=DiagDate
    s PLIST(12)=$p(Instring,separete,12)      ;MEPD_SickKind
    s PLIST(13)=$p(Instring,separete,13)      ;MEPD_DeathDate
    s:(+PLIST(13))=0 PLIST(13)=""
    Set PLIST(13)=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(PLIST(13))
    s PLIST(14)=$p(Instring,separete,14)      ;MEPD_Loc_DR
    s PLIST(15)=$p(Instring,separete,15)      ;MEPD_RepPlace
    s PLIST(17)=$p(Instring,separete,17)      ;MEPD_RepUsr_DR
    
    
	s PLIST(18)=$p(Instring,separete,18)      ;MEPD_RepDate
	Set PLIST(18)=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(PLIST(18))
	s:PLIST(18)="" PLIST(18)=+$h
	s PLIST(19)=$p(Instring,separete,19)      ;MEPD_RepTime
	s:PLIST(19)[":" PLIST(19)=$zth(PLIST(19))
	s:PLIST(19)="" PLIST(19)=$p($h,",",2) 
	// add by chenr 20220805   新增当报告状态由草稿转变为报告时，重新生成报告日期
    Set NewStatus = $p(Instring,separete,16)
    if ((MEPDRowid'="")&&(OldStatus="6")&&(NewStatus="1")){
	    Set PLIST(18)= +$h
    	Set PLIST(19)= $p($h,",",2)
    }
    s PLIST(16)=$p(Instring,separete,16)      ;MEPD_Status
    
    s PLIST(20)=$p(Instring,separete,20)      ;MEPD_CheckUsr_DR
    s PLIST(21)=$p(Instring,separete,21)      ;MEPD_CheckDate
    Set PLIST(21)=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(PLIST(21))
    s PLIST(22)=$p(Instring,separete,22)      ;MEPD_CheckTime
    s:PLIST(22)[":" PLIST(22)=$zth(PLIST(22))
    s PLIST(23)=$p(Instring,separete,23)      ;MEPD_Demo
    s PLIST(24)=$p(Instring,separete,24)      ;MEPD_DelReason
    s PLIST(25)=$p(Instring,separete,25)      ;MEPD_Mepd_DR      
    s PLIST(26)=$p(Instring,separete,26)      ;MEPD_TelPhone
    s PLIST(27)=$p(Instring,separete,27)      ;MEPD_Address
    s PLIST(28)=$p(Instring,separete,28)      ;MEPD_Company
    //add by zf 2008-11-08
    s PLIST(29)=$p(Instring,separete,29)      ;MEPD_IDAddress
    s PLIST(30)=$p(Instring,separete,30)      ;MEPD_TEXT1
    s PLIST(31)=$p(Instring,separete,31)      ;MEPD_TEXT2
    s PLIST(32)=$p(Instring,separete,32)      ;MEPDIsUpload
    s PLIST(33)=$p(Instring,separete,33)      ;MEPDProvince
    s PLIST(34)=$p(Instring,separete,34)      ;MEPDCity
    s PLIST(35)=$p(Instring,separete,35)      ;MEPDCounty
    s PLIST(36)=$p(Instring,separete,36)      ;MEPDVillage
    s PLIST(37)=$p(Instring,separete,37)      ;MEPDRoad
    
    s DiagDateTime=$p(Instring,separete,38)   ;MEPDDiagDateTime
    
    //s DiagDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DiagDate) update by liuyh 2019-4-19
    s DiagDate=$zd(DiagDate,3)	//##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DiagDate)
    s DiagTime=$zt(DiagTime,2)
    s DiagDateTime=DiagDate_" "_DiagTime
    s PLIST(38)=DiagDateTime
    
    s AdmWard=$p(Instring,separete,39)        ;MEPD_TEXT3
    //如果传入病区为空,取原报告病区
    s:AdmWard="" AdmWard=$p(epdReport,"^",31)
    //如果病区未传入,记录当前就诊病区
    if AdmWard="" {
	    s Paadm=$p(Instring,separete,30)
	    s AdmWard=$p($g(^PAADM(+Paadm)),"^",70)
	    s:AdmWard'="" AdmWard=$p($g(^PAWARD(+AdmWard)),"^",5)
	}
    s PLIST(39)=AdmWard
    s PLIST(40)=$p(Instring,separete,40)      ;MEPD_TEXT4
    s PLIST(41)=$zcvt($p(Instring,separete,41),"U")     ;MEPD_TEXT5
    s PLIST(42)=$p(Instring,separete,42)      ;MEPD_TEXT6
    s PLIST(43)=$p(Instring,separete,43)      ;MEPDSeverity  //add 20200203
    s PLIST(44)=$p(Instring,separete,44)     
    s PLIST(45)=$p(Instring,separete,45)     
    i $p(epdReport,"^",45)'="" d
    .s PLIST(46)=$p(epdReport,"^",45)
    e  d 
    .s PLIST(46)=$zd(PLIST(18),3)_" "_$zt(PLIST(19))		//$p(Instring,separete,46) //$zdt($h,3)
    i MEPDRowid="" d
    .&sql(insert into DHCMed_EPD.Epidemic values :PLIST())
    e  d
    .&sql(update DHCMed_EPD.Epidemic values :PLIST() where MEPD_Rowid=:MEPDRowid)
    q:SQLCODE SQLCODE
    s ret=$p(%ROWID,$c(1))
    q ret
}

ClassMethod UpdateCheckEPD(MEPDRowid, Status, CheckUsr, CheckDate, CheckTime, Demo) As %String
{
    Set CheckDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(CheckDate)
    s:CheckDate="" CheckDate=+$h
    s:CheckTime'="" CheckTime=$zth(CheckTime) 
    s:CheckTime="" CheckTime=$p($h,",",2)
    &sql(update DHCMed_EPD.Epidemic set MEPD_Status=:Status,MEPD_CheckUsr_DR=:CheckUsr,MEPD_CheckDate=:CheckDate,MEPD_CheckTime=:CheckTime,MEPD_DelReason=:Demo where MEPD_Rowid=:MEPDRowid)
    q:SQLCODE SQLCODE
    s ret=$p(%ROWID,$c(1))
    q ret
}

ClassMethod UpdateCorrectEPD(MEPDRowid, Status, Demo) As %String
{
  
    &sql(update DHCMed_EPD.Epidemic set MEPD_Status=:Status,MEPD_DelReason=:Demo where MEPD_Rowid=:MEPDRowid)
    q:SQLCODE SQLCODE
    s ret=$p(%ROWID,$c(1))
    q ret
}

/// 更新传染病报告是否上报CDC状态
ClassMethod UpdateUploadStatus(aRepID, aStatus) As %String
{
	New (aRepID,aStatus)
	Set return=-1
	
	Set obj=##class(DHCMed.EPD.Epidemic).GetObjById(aRepID)
	Quit:'$IsObject(obj) return
	
	Set obj.MEPDIsUpload=$s(aStatus["Y":"Y",1:"N")
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2020-08-26
/// 获取订正报告对应的被订报告ID 
/// w ##class(DHCMed.EPD.Epidemic).GetRevised(108)
ClassMethod GetRevised(aReportID) As %String
{
	New (aReportID)
	Set return=""
	
	Set objRep=##class(DHCMed.EPD.Epidemic).GetObjById(aReportID)
	Quit:'$IsObject(objRep) return
	//Quit:objRep.MEPDStatus'=3 return
	Set MepdDR = objRep.MEPDMepdDR         //被订正报告
	Set return = MepdDR
	Quit return
}

/// 检查传染病是否上报
/// w ##class(DHCMed.EPD.Epidemic).CheckIsRepEpd(105,"")
ClassMethod CheckIsRepEpd(aEpisodeID As %String, aEpdDiagnos As %String) As %String
{
	New (aEpisodeID,aEpdDiagnos)
	Set return=0
	Quit:(aEpisodeID="")||(aEpdDiagnos="") return
	/*
	Set xRepID=""
	For {
		Set xRepID=$o(^DHCMed.EPDi("EPD",0,"EpisodeID",aEpisodeID,xRepID))
		Quit:xRepID=""
		Quit:return=1
		
		Set objRep=##class(DHCMed.EPD.Epidemic).GetObjById(xRepID)
		Continue:'$IsObject(objRep)
		Continue:'$IsObject(objRep.MEPDICDDR)
		
		Continue:objRep.MEPDStatus="4"  //被订状态报告无效
		Continue:objRep.MEPDStatus="6"  //草稿状态报告无效
		Continue:objRep.MEPDStatus="7"  //删除状态报告无效
		
		Set EpdDesc=objRep.MEPDICDDR.MIFDisease
		Set EpdKindDesc=""
		Set EpdKind=objRep.MEPDICDDR.MIFKind
		If EpdKind'="" {
			Set objEpdKind=##class(DHCMed.SS.Dictionary).GetByTypeCode("EpdemicType",EpdKind,"")
			If $IsObject(objEpdKind){
				Set EpdKindDesc=objEpdKind.Description
			}
		}
		Continue:(aEpdDiagnos'[EpdDesc)&&(aEpdDiagnos'[EpdKindDesc)
		Set return=1
	}*/
	//modify by mxp 20180322 检查传染病是否上报，包含历史就诊
	Set PatientID=$p($g(^PAADM(aEpisodeID)),"^",1)
	Set InfectionDr=""
	For {
		Set InfectionDr=$o(^DHCMed.EPDi("EPD",0,"PAPMIICD",PatientID,InfectionDr))
		Quit:InfectionDr=""
		
		Set RowID=""
		For {
			Set RowID=$o(^DHCMed.EPDi("EPD",0,"PAPMIICD",PatientID,InfectionDr,RowID))
			Quit:RowID=""
			
			Set objRep=##class(DHCMed.EPD.Epidemic).GetObjById(RowID)
			Continue:'$IsObject(objRep)
			Continue:'$IsObject(objRep.MEPDICDDR)
			
			Continue:objRep.MEPDStatus="4"  //被订状态报告无效
			Continue:objRep.MEPDStatus="6"  //草稿状态报告无效
			Continue:objRep.MEPDStatus="7"  //删除状态报告无效
			
			Set EpdDesc=objRep.MEPDICDDR.MIFDisease
			Set EpdKindDesc=""
			Set EpdKind=objRep.MEPDICDDR.MIFKind
			If EpdKind'="" {
				Set objEpdKind=##class(DHCMed.SS.Dictionary).GetByTypeCode("EpdemicType",EpdKind,"")
				If $IsObject(objEpdKind){
					Set EpdKindDesc=objEpdKind.Description
				}
			}
			Continue:(aEpdDiagnos'[EpdDesc)&&(aEpdDiagnos'[EpdKindDesc)
			Set return=1
		}
	}
	
	Quit return
}

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCMed.EPD("EPD"))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="MEPD_Address">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="MEPD_Area">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MEPD_CheckDate">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="MEPD_CheckTime">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="MEPD_CheckUsr_DR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="MEPD_City">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="MEPD_Company">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="MEPD_Contr">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="MEPD_County">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="MEPD_DeathDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MEPD_DelReason">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="MEPD_Demo">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="MEPD_DiagDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MEPD_DiagDateTime">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="MEPD_DiagDegree">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MEPD_DiagnoseType">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MEPD_FamName">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MEPD_FirRepDate">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="MEPD_ICD_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MEPD_IDAddress">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="MEPD_IntimateCode">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MEPD_IsInEPD">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="MEPD_IsUpload">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="MEPD_Loc_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MEPD_Mepd_DR">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="MEPD_Occupation">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MEPD_Papmi_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MEPD_Province">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="MEPD_RepDate">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="MEPD_RepPlace">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="MEPD_RepTime">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="MEPD_RepUsr_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="MEPD_Road">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="MEPD_Severity">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="MEPD_SickDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MEPD_SickKind">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MEPD_Status">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="MEPD_TelPhone">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="MEPD_Text1">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="MEPD_Text2">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="MEPD_Text3">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="MEPD_Text4">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="MEPD_Text5">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="MEPD_Text6">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="MEPD_Village">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Global>^DHCMed.EPD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MEPD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"EPD"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{MEPD_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDateLoc">
<Global>^DHCMed.EPDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MEPD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"EPD"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>"DateLoc"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{MEPD_RepDate}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{MEPD_Loc_DR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{MEPD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEpisodeID">
<Global>^DHCMed.EPDi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"EPD"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>"EpisodeID"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{MEPD_Text1}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{MEPD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIsUpload">
<Global>^DHCMed.EPDi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"EPD"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>"ISUPLOAD"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{MEPD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAPMIICD">
<Global>^DHCMed.EPDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MEPD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"EPD"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>"PAPMIICD"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{MEPD_Papmi_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{MEPD_ICD_DR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{MEPD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRepDate">
<Global>^DHCMed.EPDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>{MEPD_Rowid}</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"EPD"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>"RepDate"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{MEPD_RepDate}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{MEPD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRepStatus">
<Global>^DHCMed.EPDi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"EPD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="3">
<Expression>"RepStatusDate"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MEPD_Status}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MEPD_RepDate}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{MEPD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Global>^DHCMed.EPDi</Global>
<Subscript name="1">
<Expression>"EPD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Status"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MEPD_Status}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MEPD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^DHCMed.EPD.EpidemicS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
