/// 传染病导出接口
/// 创建者：李阳
/// 创建时间：2015-05-18
Class DHCMed.EPDService.EpdExportInterface Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

/// w ##class(DHCMed.EPDService.EpdExportInterface).Test()
ClassMethod Test()
{
	Set ret=##class(DHCMed.EPDService.EpdExportInterface).GetExportString(73)
	Set ResultCode=$p(ret,$c(1),1)
	Set Err=$p(ret,$c(1),2)
	Set Detail=$p(ret,$c(1),3)
	For i=1:1:$l(Detail,"^") {
		Set Row=$p(Detail,"^",i)
		Continue:Row=""
		Set Caption=$p(Row,"|",1)
		Set Value=$p(Row,"|",2)
		Write Caption_"   :   "_Value,!
	}
	
	W "====ERROR====",!
	For i=1:1:$l(Err,$c(2)) {
		Set Row=$p(Err,$c(2),i)
		Continue:Row=""
		Set Value=$p(Row,"^",1)
		Set DicName=$p(Row,"^",2)
		Write Value_"   :   "_DicName,!
	}
	
	w $tr(Err,$c(1),$c(13))
	Quit "OK"
}

/// 功能：在此函数中调用系统平台组的接口，并将是否上报CDC的字段设置为“Y”
/// 参数：
///      ReportID : 需要导出的报告ID
/// 返回值：
///      -1 ：没有找到报告，1：成功
ClassMethod ExportReport(ReportID As %String)
{
	n (ReportID)
	Set objRep=##class(DHCMed.EPD.Epidemic).GetObjById(ReportID)
	Quit:'$IsObject(objRep) -1
	Set objRep.MEPDIsUpload="Y"
	Do objRep.%Save()
	Do objRep.%Close()
	
	
	
	Quit 1
}

/// 功能：校验报告信息（只校验了部分信息，其它许多信息在报告时便已经检查了）
/// 参数：
///     ReportID : 需要导出的报告ID
/// 返回值：
///     错误列表，每个错误之间用“^”分割
/// w ##class(DHCMed.EPDService.EpdExportInterface).ValidateContent(73)
ClassMethod ValidateContent(ReportID As %String) As %String
{
	n (ReportID)
	Set repid=$I(^CacheTemp)
	Set ret=""
	Set tt=##class(DHCMed.EPDService.EpdExportInterface).GetExportString(ReportID)
	
	Set t=$p(tt,$c(1),3)
	For i=1:1:$l(t,"^") {
		Set Row=$p(t,"^",i)
		Continue:Row=""
		Set Caption=$p(Row,"|",1)
		Set Value=$p(Row,"|",2)
		Continue:Caption=""
		Set ^CacheTemp(repid,Caption)=Value
	}	
 		 //1、患者姓名不能为空
 		Set:$g(^CacheTemp(repid,"NM_PATIENT"))="" ret=ret_"患者姓名不能为空^"
 		 //2、患者姓名最长为20个字
 		 Set:$l($g(^CacheTemp(repid,"NM_PATIENT")))>20 ret=ret_"患者姓名最长为20个字^"
 		 //3、患者父/母姓名最长为20个字
 		 Set:$l($g(^CacheTemp(repid,"NM_PARENT")))>20 ret=ret_"患者父/母姓名最长为20个字^"
 		 //4、性别不能为空
 		 Set:$l($g(^CacheTemp(repid,"DD_SEX")))>20 ret=ret_"性别不能为空^"
 		 //5、性别编码错误
 		 
 		 //6、联系电话最长为18个字
 		 Set:$l($g(^CacheTemp(repid,"NO_TEL")))>18 ret=ret_"联系电话最长为18个字^"
 		 
 		 //7、身份证编码格式不正确
 		 //8、工作单位最长为50个字
 		 //9、详细现住地址不能为空
 		 Set:$g(^CacheTemp(repid,"NT_LIVEADDRESS"))="" ret=ret_"详细现住地址不能为空^"
 		 //10、 详细现住地址最长为50个字
 		 Set:$l($g(^CacheTemp(repid,"NT_LIVEADDRESS")))>50 ret=ret_"详细现住地址最长为50个字^"
 		 //11、 现住地址编码不能为空
 		 Set:$g(^CacheTemp(repid,"DD_LIVEZONECODE"))="" ret=ret_"现住地址编码不能为空^"
 		 //12、 现住地址编码必须选择到乡级
 		 Set:$Extract($g(^CacheTemp(repid,"DD_LIVEZONECODE")),9,10)="00" ret=ret_"现住地址编码必须选择到乡级^"
 		 //13、 地区编码错误
 		 //14、 现住地址类型不能为空
 		 Set:$g(^CacheTemp(repid,"DD_LIVETYPECODE"))="" ret=ret_"现住地址类型不能为空^"
 		 //15、 现住地址类型值填写错误
 		 //16、 职业编码不能为空
 		 Set:$g(^CacheTemp(repid,"DD_OCCUPATION"))="" ret=ret_"职业编码不能为空^"
 		 //17、 职业编码错误
 		 //18、 患者是学生时，工作单位项应填写患者所在学校
 		 //19、 患者是教师时，工作单位不能为空
 		 //Set:(($g(^CacheTemp(repid,"DD_OCCUPATION"))="4")&&()) ret=ret_"患者是教师时，工作单位不能为空^"
 		 //20、 患者是医务人员时，工作单位不能为空
 		 //21、 患者是幼托儿童时，工作单位项应填写患者所在的托幼机构
 		 //22、 患者是工人时，工作单位不能为空
 		 //23、 患者是民工时，工作单位项应填写患者所工作的工地或建筑队
 		 //24、 患者是干部职员时，工作单位不能为空
 		 //25、 职业选择“其它”时，其它具体职业不能为空
 		 //26、 发病日期不能为空
 		 Set:$g(^CacheTemp(repid,"DT_ILL"))="" ret=ret_"发病日期不能为空^"
 		 //27、 发病日期格式错误，必须为不带时分秒的日期格式（YYYY-MM-DD）
 		 //28、 发病日期必须小于等于当前时间
 		 //29、 发病日期必须小于等于死亡日期
 		 //30、 发病日期必须小于等于医生填卡日期
 		 //31、 发病日期必须小于等于诊断时间
 		 //32、 诊断时间不能为空
 		 Set:$g(^CacheTemp(repid,"TM_DIAG"))="" ret=ret_"诊断时间不能为空^"
 		 //33、 诊断时间格式错误，必须为带时或者时分秒的时间格式（yyyy-MM-dd HH）
 		 //34、 诊断时间必须小于等于当前时间
 		 //35、 诊断时间必须小于等于医生填卡日期
 		 //36、 诊断时间必须小于等于死亡日期
 		 //37、 死亡日期格式错误，必须为不带时分秒的日期格式（YYYY-MM-DD）
 		 //38、 死亡日期必须小于等于当前日期
 		 //39、 诊断类型编码不能为空
 		 Set:$g(^CacheTemp(repid,"DD_DIAGTYPE"))="" ret=ret_"诊断类型编码不能为空^"
 		 //40、 诊断类型编码错误
 		 //41、 病例分类不能为空
 		 //42、 病例分类值填写错误
 		 //43、 填卡医生不能为空
 		 Set:$g(^CacheTemp(repid,"NM_INPUTDT"))="" ret=ret_"填卡医生不能为空^"
 		 //44、 填卡医生最长为8个字
 		 Set:$l($g(^CacheTemp(repid,"填卡医生不能为空")))>8 ret=ret_"填卡医生最长为8个字^"
 		 //45、 疾病名称不能为空
 		 //46、 疾病名称为HIV时，疾病分类才能是阳性检测
 		 //47、 采供血机构才能选择献血员阳性检测结果
 		 //48、 疾病名称为梅毒时，疾病分类只能是实验室确诊病例和疑似病例
 		 //49、 疾病名称为淋病时，病例分类只能是实验室确诊病例和疑似病例
 		 //50、 疾病名称为尖锐湿疣时，病例分类只能是实验室确诊病例和临床诊断病例
 		 //51、 疾病名称为生殖器包疹时，病例分类只能是实验室确诊病例和临床诊断病例
 		 //52、 疾病名称为生殖道沙眼衣原体感染时，病例分类只能是实验室确诊病例
 		 //53、 疾病名称为霍乱、脊灰、乙肝、伤寒、副伤寒、间日疟或恶性疟时，病例分类才能是病原携带者
 		 //54、 疾病名称为菌（-）或未痰检时，疾病分类不能为实验室确诊病例
 		 //55、 疾病名称为艾滋病、HIV、涂（+）或仅陪阳时，疾病分类不能为临床诊断病例
 		 //56、 疾病名称为“其它”时，其他传染病具体名称不能为空
 		 //57、 疾病名称为其他疾病时，病例分类只能为未分型
 		 //58、 疾病名称只有为乙肝、丙肝或血吸虫病时，病例分类中才可以为急性或者慢性
 		 //59、 新生儿破伤风疾病患者的出生日期和医生填卡日期最大只能相差28天
 		 //60、 从业人员年龄不能在14岁以下
 		 //61、 患者年龄小于等于14岁时，患者家长的姓名必须填写
 		 //62、 患者年龄小于等于14岁时，联系电话必须填写
 		 //63、 14岁以上不能是幼托儿童和散居儿童
 		 //64、 疾病病种错误，注意某些大类病种是不能录入传染病报告卡的
 		 //65、 密切接触者有无相同症状不能为空
 		 //66、 密切接触者有无相同症状值填写错误
 		 //67、 备注最长为40个字
 		 //68、 出生日期不能为空
 		 //69、 出生日期格式错误,必须为不带时分秒的日期格式（YYYY-MM-DD）
 		 //70、 出生日期必须小于等于发病日期
 		 //71、 出生日期必须小于等于当前日期
 		 //72、 出生日期必须小于等于诊断时间
 		 //73、 出生日期必须小于等于医生填卡日期
 		 //74、 出生日期必须小于等于死亡日期
 		 //75、 医生填卡日期不能为空
 		 //76、 医生填卡日期格式错误，必须为不带时分秒的日期格式（YYYY-MM-DD）
 		 //77、 医生填卡日期必须小于等于当前时间
 		 //二、乙肝校验（子卡）
 		 //1、首次出现乙肝症状和体征时间格式错误，必须为不带日时分秒的日期格式（YYYY-MM）
 		 //2、首次出现乙肝症状和体征时间应小于等于当前时间
 		 //三、手足口校验（子卡）
 		 //1、是否是重病患者不能为空
 		 //2、报告手足口病为实验室确诊病例时，实验室结果不能为空
 		 //3、只有“病例类型”是“实验室确诊病例”时，才允许选择“实验室结果”
 		 //四、AFP检验（子卡）
 		 //1、麻痹日期不能为空
 		 //2、发病日期必须小于等于麻痹日期
 		 //3、麻痹日期必须小于等于诊断时间
 		 //4、病人所属为异地时，来现就诊日期不能为空
 		 //5、病人所属为异地时，来现就诊日期必须小于等于诊断时间
 		 //五、艾滋病校验（子卡）
 		 //1、病人即不属于港澳台，又不属于外籍，并且病例分类为临床诊断病例或者实验室诊断病例时
 		 //（1）、婚姻状况不能为空
 		 //（2）、文化程度不能为空
 		 //（3）、接触史不能为空
 		 //（4）、最有可能感染途径不能为空
 		 //（5）、样本来源不能为空
 		 //2、民族不能为空
 		 //3、户籍详细地址不能为空
 		 //4、户籍详细地址最长为40个字
 		 //5、户籍地址编码不能为空
 		 //6、户籍地址编码必须选择到乡级
 		 //7、户籍所在地类型不能为空
 		 //8、户籍所在地类型值错误
 		 //9、病人属性与户籍地址关系错误
 		 //10、性别为“女”时，接触史不能为“男男性行为史”
 		 //11、注射毒品史中，共用注射器人数必须为大于等于0的整数
 		 //12、非婚异性性接触史中，非婚性行为人数必须为大于等于0的整数
 		 //13、男男性行为史中，同性性行为必须为大于等于0的整数
 		 //14、接触史为其他时，其他接触史不能为空
 		 //15、性病史不能为空
 		 //16、最有可能感染途径不能为空
 		 //17、最有可能感染途径为其他时，其他有可能感染途径不能为空
 		 //18、最有可能感染途径为注射毒品时，接触史必须有“注射毒品史”
 		 //19、最有可能感染途径为异性传播时，接触史必须有“非婚异性性接触史”或“配偶/固定性伴阳性”
 		 //20、最有可能感染途径为同性传播时，接触史必须有“男男性行为史”
 		 //21、最有可能感染途径为同性传播时，性别必须为男性
 		 //22、最有可能感染途径为性接触+注射毒品，接触史必须有“注射毒品史+（非婚异性性接触史，配偶/固定性伴阳性，男男性行为史三者之一或以上）”
 		 //23、最有可能感染途径为采血（浆），接触史必须有“献血（浆）史”
 		 //24、最有可能感染途径为输血/血制品，接触史必须有“输血/血制品史” 
 		 //25、最有可能感染途径为母婴传播时，接触史必须有“母亲阳性”
 		 //26、最有可能感染途径为母婴传播时，年龄必须小于18岁
 		 //27、最有可能感染途径为职业暴露时，接触史必须有“职业暴露史”
 		 //28、样品来源为其他时，其他样品来源不能为空
 		 //29、样品来源为“孕妇期检查”时，性别必须为女性
 		 //30、实验室检测结论不能为空
 		 //31、实验室检测结论为确认结果阳性或者替代策略检测阳性时；
 		 //    （1）、确认（替代策略）检测阳性日期不能为空
 		 //    （2）、确认（替代策略）检测阳性日期格式不正确，必须为不带时分秒的日期格式（YYYY-MM-DD）
 		 //    （3）、确认（替代策略）检测阳性日期必须小于等于当前日期
 		 //    （4）、确认（替代策略）检测阳性日期必须小于等于诊断时间
 		 //    （5）、确认（替代策略）检测单位不能为空
 		 //32、艾滋病确诊日期不能为空
 		 //33、艾滋病确诊日期格式不正确，必须为不带时分秒的日期格式（YYYY-MM-DD）
 		 //34、艾滋病确诊日期必须小于等于当前日期
 		 //35、诊断时间必须小于等于艾滋病确诊日期?
 		 //	
 	Kill ^CacheTemp(repid)
	Quit ret
}

/// 功能：将报告信息导出为字符串
/// 参数：
///     ReportID : 需要导出的报告ID
/// 返回值：
///     结果^错误信息^报告导出字符串
/// w ##class(DHCMed.EPDService.EpdExportInterface).GetExportString(3)
ClassMethod GetExportString(RepID As %String) As %String
{
	n (RepID)
	Set rid=$I(^CacheTemp) //用于记录公共记录
	Set ret=""
	Set objRep=##class(DHCMed.EPD.Epidemic).GetObjById(RepID)
	Quit:'$IsObject(objRep) ret
	Set Epd=..ExportEpd(objRep)
	Set AFP=..ExportAFP(objRep)
	Set AIDS=..ExportAIDS(objRep)
	Set ShouZuKou=..ExportShouZuKou(objRep)
	Set H1N1=..ExportH1N1(objRep)
	
	Set Err=##class(DHCMed.EPDService.EpdExportCommon).GetUnMapData(rid)
	Set:$p(Epd,$c(1),1)'="OK" Err=Err_$p(Epd,$c(1),2)
	Set:$p(AFP,$c(1),1)'="OK" Err=Err_$p(AFP,$c(1),2)
	Set:$p(AIDS,$c(1),1)'="OK" Err=Err_$p(AIDS,$c(1),2)
	Set:$p(ShouZuKou,$c(1),1)'="OK" Err=Err_$p(ShouZuKou,$c(1),2)
	Set:$p(H1N1,$c(1),1)'="OK" Err=Err_$p(H1N1,$c(1),2)
	if (Err="") {
		Set ret="OK"_$c(1)_$c(1)_Epd_"^"_AFP_"^"_ShouZuKou_"^"_H1N1_"^"_AIDS
	}else
	{
		Set ret="Error"_$c(1)_Err_$c(1)_Epd_"^"_AFP_"^"_ShouZuKou_"^"_H1N1_"^"_AIDS
	}
	Quit ret
}

/// 功能：导出传染病报告卡信息
/// 参数：
///      objRep:传染病报告对象
///      Delimiter:分隔符，默认为“^”
/// 结果：
///      字段1|值1^字段2|值2^...
ClassMethod ExportEpd(objRep As DHCMed.EPD.Epidemic, Delimiter As %String = "^") As %String
{
	n (objRep,Delimiter,rid)
	
	Set ret=""
	Set ret=ret_"ID_HOSAREA|"_##Class(DHCMed.SS.Config).GetValueByKeyHosp("EpdHOSAREA","")_Delimiter //医院院区分区编码	ID_HOSAREA
	Set ret=ret_"ID_EHR|"_objRep.%Id()_Delimiter 										//医院电子病历检索ID	ID_EHR
	Set ret=ret_"DD_RPTZONE|"_##Class(DHCMed.SS.Config).GetValueByKeyHosp("EpdRPTZONE","")_Delimiter //*报告地区编码	DD_RPTZONE
	Set ret=ret_"DD_RPTORG|"_##Class(DHCMed.SS.Config).GetValueByKeyHosp("EpdRPTORG","")_Delimiter //*报告单位编码	DD_RPTORG
	
	Set objPat=##class(DHCMed.Base.Patient).GetObjById(objRep.MEPDPapmiDR)
	Do objPat.%Close()
	Set ret=ret_"NM_PATIENT|"_objPat.PatientName_Delimiter 								//*患者姓名	NM_PATIENT
	Set ret=ret_"NM_PARENT|"_objRep.MEPDFamName_Delimiter 								//患儿家长姓名	NM_PARENT
	Set ret=ret_"ID_PATIENT|"_objPat.PersonalID_Delimiter 								//身份证证件号码	ID_PATIENT
	Set ret=ret_"DD_SEX|"_$s(objPat.Sex="男":"1",1:"2")_Delimiter 					//*性别	DD_SEX
	Set ret=ret_"DT_BIRTH|"_objPat.Birthday_Delimiter 									//*出生日期	DT_BIRTH
	Set ret=ret_"NM_WORKPLACE|"_objRep.MEPDCompany_Delimiter 								//患者工作单位	NM_WORKPLACE
	Set ret=ret_"NO_TEL|"_objRep.MEPDTelPhone_Delimiter 								//联系电话-号码	NO_TEL
	Set ret=ret_"DD_LIVETYPECODE|"_##class(DHCMed.EPDService.EpdExportCommon).GetMap(objRep.MEPDArea,"","EpidemicReportRegion")_Delimiter //*现住地址类型代码	DD_LIVETYPECODE
	
	
	Set objAreaDic=##class(DHCMed.EPD.AreaDic).GetObjById(objRep.MEPDVillage)
	Set:'$IsObject(objAreaDic) objAreaDic=##class(DHCMed.EPD.AreaDic).%New()
	Do objAreaDic.%Close()
	Set ret=ret_"DD_LIVEZONECODE|"_objAreaDic.Code_Delimiter //*常住地址代码	DD_LIVEZONECODE
	Set ret=ret_"NT_LIVEADDRESS|"_objRep.MEPDIDAddress_Delimiter //*常住地详细地址	NT_LIVEADDRESS
	Set ret=ret_"DD_OCCUPATION|"_##class(DHCMed.EPDService.EpdExportCommon).GetMap(objRep.MEPDOccupation,"","Career")_Delimiter //*职业类别(传染病信息)代码	DD_OCCUPATION
	;Set ret=ret_"OT_OCCUPATION|"_Delimiter //其他职业	OT_OCCUPATION
	Set ret=ret_"DD_DIAGTYPE|"_##class(DHCMed.EPDService.EpdExportCommon).GetMap(objRep.MEPDDiagDegree,"","EpidemicDiagnoseDegree")_Delimiter //*病例分类代码(诊断类型)	DD_DIAGTYPE
	Set ret=ret_"DD_EMGSTATUS|"_##class(DHCMed.EPDService.EpdExportCommon).GetMap(objRep.MEPDSickKind,"","EpidemicSickQuality")_Delimiter //病例类型代码(急缓状态)	DD_EMGSTATUS
	Set ret=ret_"DT_ILL|"_$zd(objRep.MEPDSickDate,3)_Delimiter //*发病日期	DT_ILL
	Set ret=ret_"TM_DIAG|"_objRep.MEPDDiagDateTime_Delimiter //*诊断日期	TM_DIAG
	Set ret=ret_"DT_DEATH|"_$s(+objRep.MEPDDeathDate'=0:$zd(objRep.MEPDDeathDate,3),1:"")_Delimiter //死亡日期	DT_DEATH
	Set ret=ret_"DD_DISEASE|"_##class(DHCMed.EPDService.EpdExportCommon).GetMap(objRep.MEPDICDDR.MIFICD,"","Disease")_Delimiter //*疾病名称代码-传染病代码	DD_DISEASE
	Set ret=ret_"OT_DISEASE|"_Delimiter //其他疾病名称	OT_DISEASE
	Set objUser=##class(DHCMed.Base.SSUser).GetObjById(objRep.MEPDRepUsrDR)
	Set:'$IsObject(objUser) objUser=##class(DHCMed.Base.SSUser).%New()
	Do objUser.%Close()		
	Set ret=ret_"NM_INPUTDT|"_objUser.Name_Delimiter //（填卡医生）姓名"	NM_INPUTDT
	Set ret=ret_"DT_INPUTDT|"_$zd(objRep.MEPDRepDate,3)_Delimiter //*医生填卡日期	DT_INPUTDT
	Set ret=ret_"IS_CONTACTSMP|"_##class(DHCMed.EPDService.EpdExportCommon).GetMap(objRep.MEPDIntimateCode,objRep.MEPDIntimateCode,"EpidemicContact")_Delimiter //*密切接触者有无相同症状	IS_CONTACTSMP
	Set ret=ret_"NT_DESCRIPTION|"_objRep.MEPDDemo_Delimiter //备注	NT_DESCRIPTION
	Set ret=ret_"DD_CARDSTATUS|"_##class(DHCMed.EPDService.EpdExportCommon).GetDicDescByTypeCode("EpidemicReportStatus",objRep.MEPDStatus)_Delimiter //卡片状态	DD_CARDSTATUS	
	
	Quit ret
}

/// AFP字段导出
/// 参数：
///      objRep:传染病报告对象
///      Delimiter:分隔符，默认为“^”
/// 结果：
///      字段1|值1^字段2|值2^...
ClassMethod ExportAFP(objRep As DHCMed.EPD.Epidemic, Delimiter As %String = "^") As %String
{
	n (objRep,Delimiter,rid)
	Set pid=##class(DHCMed.EPDService.EpdExportCommon).PrepareEpdSub(objRep.%Id())
	Set ret=""
	Set tmp=##class(DHCMed.EPDService.EpdExportCommon).GetMap(objRep.MEPDArea,"","EpidemicReportRegion")
	Set tmp=$s(+tmp<"4":"0",1:"1")  //与主表中区域字段对照，如果是1、2、3则为本地，4、5、6为异地
	Set ret=ret_"AFP_ISLOCAL|"_tmp_Delimiter //病人所属地类型 	AFP_ISLOCAL
	Set ret=ret_"AFP_DTPOLIO|"_Delimiter //麻痹日期	AFP_DTPOLIO
	Set ret=ret_"AFP_DTSEE|"_##class(DHCMed.EPDService.EpdExportCommon).GetRepSubValue(pid,"就诊日期")_Delimiter //就诊日期	AFP_DTSEE
	Set ret=ret_"AFP_NTSYMP|"_##class(DHCMed.EPDService.EpdExportCommon).GetRepSubValue(pid,"麻痹情况（简述部位、肌力、肌张力、腱反射情况）")_Delimiter //麻痹症状	AFP_NTSYMP
	Set ret=ret_"AFP_DDSEETYPECODE|"_##Class(DHCMed.SS.Config).GetValueByKeyHosp("EpdRPTZONE","")_Delimiter //就诊地址类别	AFP_DDSEETYPECODE
	Set ret=ret_"AFP_DDSEEZONECODE|"_##Class(DHCMed.SS.Config).GetValueByKeyHosp("EpdDDSEEZONECODE","")_Delimiter //就诊地址编码	AFP_DDSEEZONECODE
	Set ret=ret_"AFP_NTSEEADDRESS|"_##Class(DHCMed.SS.Config).GetValueByKeyHosp("EpdNTSEEADDRESS","")_Delimiter //就诊地址	AFP_NTSEEADDRESS	
	Kill ^CacheTemp(pid)
	Quit ret=""
}

/// 手足口字段导出（目前没有手足口病的附卡）
/// 参数：
///      objRep:传染病报告对象
///      Delimiter:分隔符，默认为“^”
/// 结果：
///      字段1|值1^字段2|值2^...
ClassMethod ExportShouZuKou(objRep As DHCMed.EPD.Epidemic, Delimiter As %String = "^") As %String
{
	n (objRep,Delimiter,rid)
	Set pid=##class(DHCMed.EPDService.EpdExportCommon).PrepareEpdSub(objRep.%Id())
	Set ret=""
	Set ret=ret_"HFM_ISSERIOUS|"_Delimiter //重病患者标志	HFM_ISSERIOUS
	Set ret=ret_"HFM_DDLABRESULT|"_Delimiter //实验室结果代码	HFM_DDLABRESULT
	Kill ^CacheTemp(pid)
	Quit ret
}

/// H1N1字段导出（目前没有H1N1的附卡）
/// 参数：
///      objRep:传染病报告对象
///      Delimiter:分隔符，默认为“^”
/// 结果：
///      字段1|值1^字段2|值2^...
ClassMethod ExportH1N1(objRep As DHCMed.EPD.Epidemic, Delimiter As %String = "^") As %String
{
	n (objRep,Delimiter,rid)
	Set pid=##class(DHCMed.EPDService.EpdExportCommon).PrepareEpdSub(objRep.%Id())
	Set ret=""
	Set ret=ret_"H1N1_DDSTATUS|"_Delimiter //病情状态代码	H1N1_DDSTATUS
	Set ret=ret_"H1N1_ISINHOS|"_Delimiter //是否住院标志	H1N1_ISINHOS
	Set ret=ret_"H1N1_ISOK|"_Delimiter //是否治愈标志	H1N1_ISOK
	Set ret=ret_"H1N1_ISFROMAB|"_Delimiter //是否境外输入标志	H1N1_ISFROMAB
	Set ret=ret_"H1N1_DTOUT|"_Delimiter //出院日期	H1N1_DTOUT
	Set ret=ret_"H1N1_DTIN|"_Delimiter //住院日期	H1N1_DTIN
	Set ret=ret_"H1N1_DTOK|"_Delimiter //治愈日期	H1N1_DTOK	
	Kill ^CacheTemp(pid)
	Quit ret
}

/// AIDS字段导出
/// 参数：
///      objRep:传染病报告对象
///      Delimiter:分隔符，默认为“^”
/// 结果：
///      字段1|值1^字段2|值2^...
ClassMethod ExportAIDS(objRep As DHCMed.EPD.Epidemic, Delimiter As %String = "^") As %String
{
	n (objRep,Delimiter,rid)
	Set pid=##class(DHCMed.EPDService.EpdExportCommon).PrepareEpdSub(objRep.%Id())
	Set ret=""
	Set ret=ret_"AIDS_DTDIAG|"_##class(DHCMed.EPDService.EpdExportCommon).GetRepSubValue(pid,"艾滋病确诊日期")_Delimiter //艾滋病诊断日期	AIDS_DTDIAG
	Set ret=ret_"AIDS_ISINFECTED|"_##class(DHCMed.EPDService.EpdExportCommon).GetRepSubValue(pid,"生殖道沙眼衣原体感染")_Delimiter //生殖道沙眼衣原体感染标志	AIDS_ISINFECTED
	Set ret=ret_"AIDS_DRUGED|"_##class(DHCMed.EPDService.EpdExportCommon).GetRepSubValue(pid,"注射毒品史")_Delimiter //注射毒品史 	AIDS_DRUGED
	Set ret=ret_"AIDS_NUMINJECT|"_##class(DHCMed.EPDService.EpdExportCommon).GetRepSubValue(pid,"共用过注射器人数")_Delimiter //与病人共用过注射器人数	AIDS_NUMINJECT
	Set ret=ret_"AIDS_DDSOURCE|"_##class(DHCMed.EPDService.EpdExportCommon).GetRepSubValue(pid,"检测样本来源")_Delimiter //样本来源代码	AIDS_DDSOURCE
	Set ret=ret_"AIDS_DDINFECTFROM|"_##class(DHCMed.EPDService.EpdExportCommon).GetRepSubValue(pid,"最可能的感染途径")_Delimiter //最有可能感染途径代码	AIDS_DDINFECTFROM
	Set ret=ret_"AIDS_OTSOURCE|"_##class(DHCMed.EPDService.EpdExportCommon).GetRepSubValue(pid,"检测样本来源其他说明")_Delimiter //样本来源其它	AIDS_OTSOURCE
	
	Set t=""
	Set:##class(DHCMed.EPDService.EpdExportCommon).GetRepSubValue(pid,"注射毒品史")="1" t=t_"1"
	Set:##class(DHCMed.EPDService.EpdExportCommon).GetRepSubValue(pid,"非婚异性性接触史")="1" t=t_"2"
	Set:##class(DHCMed.EPDService.EpdExportCommon).GetRepSubValue(pid,"配偶/固定性伴阳性")="1" t=t_"3"
	Set:##class(DHCMed.EPDService.EpdExportCommon).GetRepSubValue(pid,"男男性行为史")="1" t=t_"4"
	Set:##class(DHCMed.EPDService.EpdExportCommon).GetRepSubValue(pid,"献血(浆)史")="1" t=t_"5"
	Set:##class(DHCMed.EPDService.EpdExportCommon).GetRepSubValue(pid,"输血/血制品史")="1" t=t_"6"
	Set:##class(DHCMed.EPDService.EpdExportCommon).GetRepSubValue(pid,"母亲阳性")="1" t=t_"7"
	Set:##class(DHCMed.EPDService.EpdExportCommon).GetRepSubValue(pid,"职业暴露史")="1" t=t_"8"
	Set:##class(DHCMed.EPDService.EpdExportCommon).GetRepSubValue(pid,"手术史")="1" t=t_"9"
	Set:##class(DHCMed.EPDService.EpdExportCommon).GetRepSubValue(pid,"接触史其他")="1" t=t_"10"
	Set:##class(DHCMed.EPDService.EpdExportCommon).GetRepSubValue(pid,"接触史不详")="1" t=t_"11"
	Set ret=ret_"AIDS_DDCONTACT|"_t_Delimiter //接触史代码	AIDS_DDCONTACT    *可能有多项*
	
	
	Set ret=ret_"AIDS_OTCONTACT|"_##class(DHCMed.EPDService.EpdExportCommon).GetRepSubValue(pid,"接触史其他")_Delimiter //接触史其它	AIDS_OTCONTACT
	Set ret=ret_"AIDS_OTINFECTFROM|"_Delimiter //感染途径其它	AIDS_OTINFECTFROM
	Set ret=ret_"AIDS_NTSEX|"_##class(DHCMed.EPDService.EpdExportCommon).GetRepSubValue(pid,"非婚异性性接触史")_Delimiter //非婚异性性接触史 	AIDS_NTSEX
	Set ret=ret_"AIDS_NUMSEX|"_##class(DHCMed.EPDService.EpdExportCommon).GetRepSubValue(pid,"非婚性行为人数")_Delimiter //与病人有非婚性行为人数	AIDS_NUMSEX
	Set ret=ret_"AIDS_NTMM|"_##class(DHCMed.EPDService.EpdExportCommon).GetRepSubValue(pid,"注射毒品史")_Delimiter //男男性行为史	AIDS_NTMM
	Set ret=ret_"AIDS_NUMMM|"_##class(DHCMed.EPDService.EpdExportCommon).GetRepSubValue(pid,"同性性行为人数")_Delimiter // 发生同性性行为人数	AIDS_NUMMM
	Set ret=ret_"AIDS_DDLABRESULT|"_##class(DHCMed.EPDService.EpdExportCommon).GetRepSubValue(pid,"实验室检测结论")_Delimiter //实验室检测结果代码	AIDS_DDLABRESULT
	Set ret=ret_"AIDS_DTAFFIRM|"_##class(DHCMed.EPDService.EpdExportCommon).GetRepSubValue(pid,"确认(替代策略)检测阳性日期")_Delimiter //确认（替代策略）检测阳性日期（建议拆成两个数据元）	AIDS_DTAFFIRM
	Set ret=ret_"AIDS_NMCHECKORG|"_##class(DHCMed.EPDService.EpdExportCommon).GetRepSubValue(pid,"确认(替代策略)检测单位")_Delimiter //确认（替代策略）检测单位名称	AIDS_NMCHECKORG
	Set ret=ret_"AIDS_DDSEXDISEASE|"_##class(DHCMed.EPDService.EpdExportCommon).GetRepSubValue(pid,"性病史")_Delimiter //性病史代码	AIDS_DDSEXDISEASE	
	Kill ^CacheTemp(pid)
	Quit ret
}

}
