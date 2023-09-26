Import SQLUser

/// 维护ACR表达式用到的函数或方法
/// By ZF 2008-11-26
Class web.DHCWMRQuality.BOACRExpFunction Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 11;

/// *****************************************************
/// 功能       : 取病人已出院时间(单位:小时)
///            : 计算的是出院时间到当前时间的差值
///            : 出院日期和时间各家医院有不同,根据医院编码区分
/// 参数       :
/// EpisodeID  : 就诊号
/// 返回值     :
/// ret        : 数值(Number)
/// 返回值说明 : 返回已出院时间(单位:小时)
/// 调试       : w ##Class(web.DHCWMRQuality.BOACRExpFunction).GetDischHour(EpisodeID)
/// *****************************************************
ClassMethod GetDischHour(EpisodeID)
{
	n (EpisodeID)
	s ret=0
	s DisDate=$p($g(^PAADM(EpisodeID)),"^",59)    //医疗结算日期
	s DisTime=$p($g(^PAADM(EpisodeID)),"^",60)    //医疗结算时间
	s CurrDate=+$h,CurrTime=$p($h,",",2)
	s cDay=0,cSecond=0
	s:DisDate'="" cDay=CurrDate-DisDate
	s:DisTime'="" cSecond=(CurrTime-DisTime)\3600
	s ret=cDay*24+cSecond
	q ret
}

/// *****************************************************
/// 功能       : 取病人签床时间(单位:小时)
///            : 计算的是签床时间到当前时间的差值
/// 参数       :
/// EpisodeID  : 就诊号
/// 返回值     :
/// ret        : 数值(Number)
/// 返回值说明 : 返回已签床时间(单位:小时)
/// 调试       : w ##Class(web.DHCWMRQuality.BOACRExpFunction).GetSignBedHour(EpisodeID)
/// *****************************************************
ClassMethod GetSignBedHour(EpisodeID)
{
	n (EpisodeID)
	s ret=0
	
	;^DHCMedIPBK(0,"EpisodeIDTo",{EpisodeIDTo},{RowID})
	;^DHCMDIC("0","TypeCode",{MDIC_Type},{MDIC_Code},{MDIC_Rowid})
	q:'$d(^DHCMedIPBK(0,"EpisodeIDTo",+EpisodeID)) ret
	s tmpBookId="",BookId=0    //通过就诊号取入院正ID
	f  s tmpBookId=$o(^DHCMedIPBK(0,"EpisodeIDTo",+EpisodeID,tmpBookId),-1) q:(tmpBookId="")||(BookId'=0)  d
	.s tmpBook=$g(^DHCMedIPBK(+tmpBookId))
	.q:tmpBook=""
	.;q:$p(tmpBook,"^",9)'="Y"   //签床后有效状态为No
	.s BookId=tmpBookId
	s SignBedState=0,SignBedId=0    //通过状态取签床ID
	f  s SignBedState=$o(^DHCMDIC("0","TypeCode","IPBookingState","SignBed",SignBedState)) q:(SignBedState="")||(SignBedId'=0)  q
	.q:'$d(^DHCMDIC(+SignBedState))
	.q:$p($g(^DHCMDIC(+SignBedState)),"^",4)'="Y"
	.s SignBedId=SignBedState
	q:(+BookId=0)||(+SignBedState=0) ret
	;^DHCMedIPBKS(0,"BookID",{BookID}, {RowID})
	s BookStateId="",SignBedDate="",SignBedTime=""
	f  s BookStateId=$o(^DHCMedIPBKS(0,"BookID",BookId,BookStateId),-1) q:(BookStateId="")||(SignBedDate'="")  d
	.s tmpBookState=$g(^DHCMedIPBKS(BookStateId))
	.q:tmpBookState=""
	.q:$p(tmpBookState,"^",2)'=SignBedState
	.s SignBedDate=$p(tmpBookState,"^",4)
	.s SignBedTime=$p(tmpBookState,"^",5)
	q:((+SignBedDate)=0)||((+SignBedTime)=0)
	s CurrDate=+$h,CurrTime=$p($h,",",2)
	s cDay=0,cSecond=0
	s:SignBedDate'="" cDay=CurrDate-SignBedDate
	s:SignBedTime'="" cSecond=(CurrTime-SignBedTime)\3600
	s ret=cDay*24+cSecond
	q ret
}

/// *****************************************************
/// 功能         : 电子病历模板一致性检查/取值
/// *****************************************************
/// 功能列表     : UnifyType    功能描述
///              :**************************************
///              : "0101"       逻辑判断一组模板(内容相同)是否保存
///              : "0102"       逻辑判断一组模板(科室相同)是否保存
///              : "0103"       取模板(内容相同)保存时间
/// *****************************************************
/// 参数         :
/// EpisodeID    : 就诊号
/// UnifyType    : 一致性检查类型
/// EPRTempExp1  : EPR模板表达式1  如: EPR.IstSave.模板ID/EPR.IstCreateDate.模板ID
/// EPRTempExp2  : EPR模板表达式2  如: EPR.IstSave.模板ID/EPR.IstCreateDate.模板ID
/// ...
/// EPRTempExp15 : EPR模板表达式15  如: EPR.IstSave.模板ID/EPR.IstCreateDate.模板ID
/// *****************************************************
/// 参数说明     : 具体参数请参考类方法中的说明
/// *****************************************************
/// 返回值       :
/// ret          : true(1)/false(0)/error(-1)  或 返回相应值
/// *****************************************************
/// 调试         : w ##Class(web.DHCWMRQuality.BOACRExpFunction).CheckTemplateUnify(EpisodeID, UnifyType, EPRTempExp1, EPRTempExp2, EPRTempExp3, EPRTempExp4, EPRTempExp5, EPRTempExp6, EPRTempExp7, EPRTempExp8, EPRTempExp9, EPRTempExp10, EPRTempExp11, EPRTempExp12, EPRTempExp13, EPRTempExp14, EPRTempExp15
/// *****************************************************
ClassMethod CheckTemplateUnify(EpisodeID, UnifyType, EPRTempExp1, EPRTempExp2, EPRTempExp3, EPRTempExp4, EPRTempExp5, EPRTempExp6, EPRTempExp7, EPRTempExp8, EPRTempExp9, EPRTempExp10, EPRTempExp11, EPRTempExp12, EPRTempExp13, EPRTempExp14, EPRTempExp15)
{
	n (EpisodeID,UnifyType,EPRTempExp1,EPRTempExp2,EPRTempExp3,EPRTempExp4,EPRTempExp5,EPRTempExp6,EPRTempExp7,EPRTempExp8,EPRTempExp9,EPRTempExp10,EPRTempExp11,EPRTempExp12,EPRTempExp13,EPRTempExp14,EPRTempExp15)
	s ret=0
	q:(EpisodeID="")||(UnifyType="") ret
	
	//********************************************************
	//逻辑判断一组模板(内容相同)是否保存
	//适应条件：
	//检查入院记录 一般情况是否完成
	//...
	//参数：
	//EpisodeID   就诊号
	//UnifyType   "0101"
	//EPRTempExp1  : EPR模板表达式1  如: EPR.IstSave.模板ID
	//EPRTempExp2  : EPR模板表达式2  如: EPR.IstSave.模板ID
	//...
	//EPRTempExp15  : EPR模板表达式15  如: EPR.IstSave.模板ID
	//********************************************************
	i UnifyType="0101" d
	.s (IsSave1,IsSave2,IsSave3,IsSave4,IsSave5,IsSave6,IsSave7,IsSave8,IsSave9,IsSave10,IsSave11,IsSave12,IsSave13,IsSave14,IsSave15)=0
	.s:$g(EPRTempExp1)=1 IsSave1=1
	.s:$g(EPRTempExp2)=1 IsSave2=1
	.s:$g(EPRTempExp3)=1 IsSave3=1
	.s:$g(EPRTempExp4)=1 IsSave4=1
	.s:$g(EPRTempExp5)=1 IsSave5=1
	.s:$g(EPRTempExp6)=1 IsSave6=1
	.s:$g(EPRTempExp7)=1 IsSave7=1
	.s:$g(EPRTempExp8)=1 IsSave8=1
	.s:$g(EPRTempExp9)=1 IsSave9=1
	.s:$g(EPRTempExp10)=1 IsSave10=1
	.s:$g(EPRTempExp11)=1 IsSave11=1
	.s:$g(EPRTempExp12)=1 IsSave12=1
	.s:$g(EPRTempExp13)=1 IsSave13=1
	.s:$g(EPRTempExp14)=1 IsSave14=1
	.s:$g(EPRTempExp15)=1 IsSave15=1
	.s ret=(IsSave1 || IsSave2 || IsSave3 || IsSave4 || IsSave5 || IsSave6 || IsSave7 || IsSave8 || IsSave9 || IsSave10 || IsSave11 || IsSave12 || IsSave13 || IsSave14 || IsSave15)
	
	
	//********************************************************
	//逻辑判断一组模板(科室相同)是否保存
	//适应条件：
	//检查首次病程(通用)是否完成
	//检查首次病程(外科)是否完成
	//...
	//参数：
	//EpisodeID   就诊号
	//UnifyType   "0102"
	//EPRTempExp1  : EPR模板表达式1  如: EPR.IstSave.模板ID
	//EPRTempExp2  : EPR模板表达式2  如: EPR.IstSave.模板ID
	//...
	//EPRTempExp15  : EPR模板表达式15  如: EPR.IstSave.模板ID
	//********************************************************
	i UnifyType="0102" d
	.s (IsSave1,IsSave2,IsSave3,IsSave4,IsSave5,IsSave6,IsSave7,IsSave8,IsSave9,IsSave10,IsSave11,IsSave12,IsSave13,IsSave14,IsSave15)=1
	.s:$g(EPRTempExp1)'=1 IsSave1=0
	.s:$g(EPRTempExp2)'=1 IsSave2=0
	.s:$g(EPRTempExp3)'=1 IsSave3=0
	.s:$g(EPRTempExp4)'=1 IsSave4=0
	.s:$g(EPRTempExp5)'=1 IsSave5=0
	.s:$g(EPRTempExp6)'=1 IsSave6=0
	.s:$g(EPRTempExp7)'=1 IsSave7=0
	.s:$g(EPRTempExp8)'=1 IsSave8=0
	.s:$g(EPRTempExp9)'=1 IsSave9=0
	.s:$g(EPRTempExp10)'=1 IsSave10=0
	.s:$g(EPRTempExp11)'=1 IsSave11=0
	.s:$g(EPRTempExp12)'=1 IsSave12=0
	.s:$g(EPRTempExp13)'=1 IsSave13=0
	.s:$g(EPRTempExp14)'=1 IsSave14=0
	.s:$g(EPRTempExp15)'=1 IsSave15=0
	.s ret=(IsSave1 && IsSave2 && IsSave3 && IsSave4 && IsSave5 && IsSave6 && IsSave7 && IsSave8 && IsSave9 && IsSave10 && IsSave11 && IsSave12 && IsSave13 && IsSave14 && IsSave15)
	
	//********************************************************
	//取模板(内容相同)保存时间
	//适应条件：
	//检查首次病程 病程模板保存时间
	//...
	//参数：
	//EpisodeID   就诊号
	//UnifyType   "0101"
	//EPRTempExp1  : EPR模板表达式1  如: EPR.IstCreateDate.模板ID
	//EPRTempExp2  : EPR模板表达式2  如: EPR.IstCreateDate.模板ID
	//...
	//********************************************************
	i UnifyType="0103" d
	.s:$g(EPRTempExp1)'="" ret=$g(EPRTempExp1)
	.s:$g(EPRTempExp2)'="" ret=$g(EPRTempExp2)
	.s:$g(EPRTempExp3)'="" ret=$g(EPRTempExp3)
	.s:$g(EPRTempExp4)'="" ret=$g(EPRTempExp4)
	.s:$g(EPRTempExp5)'="" ret=$g(EPRTempExp5)
	.s:$g(EPRTempExp6)'="" ret=$g(EPRTempExp6)
	.s:$g(EPRTempExp7)'="" ret=$g(EPRTempExp7)
	.s:$g(EPRTempExp8)'="" ret=$g(EPRTempExp8)
	.s:$g(EPRTempExp9)'="" ret=$g(EPRTempExp9)
	.s:$g(EPRTempExp10)'="" ret=$g(EPRTempExp10)
	.s:$g(EPRTempExp11)'="" ret=$g(EPRTempExp11)
	.s:$g(EPRTempExp12)'="" ret=$g(EPRTempExp12)
	.s:$g(EPRTempExp13)'="" ret=$g(EPRTempExp13)
	.s:$g(EPRTempExp14)'="" ret=$g(EPRTempExp14)
	.s:$g(EPRTempExp15)'="" ret=$g(EPRTempExp15)
	
	q ret
}

/// *****************************************************
/// 功能         : 电子病历模板元素一致性检查
/// *****************************************************
/// 功能列表     : UnifyType    功能描述
///              :**************************************
///              : "0101"       逻辑判断,模板元数是否全部非空
///              : "0102"       逻辑判断,模板元数是否为全部为正数
///              :**************************************
///              : "0201"       [临床与病理]和[病理诊断]一致性检查
///              : "0201"       [放射与病理]和[病理诊断]一致性检查
///              : "0201"       [术前与术后]和[手术操作名称1]一致性检查
///              :**************************************
///              : "0301"       手术日期逻辑检查（允许多行检查）
///              : "0301"       -操作日期逻辑检查（允许多行检查）
///              : "0302"       监护时间逻辑检查(只能单行检查)
///              :**************************************
///              : "0401"       手术情况一致性检查
///              : "0402"       操作情况一致性检查
///              : "0403"       监护室一致性检查
/// *****************************************************
/// 参数         :
/// EpisodeID    : 就诊号
/// UnifyType    : 一致性检查类型
/// EPRElExp1       : EPR模板元素表达式1  如: EPR.TId.模板ID.元素ID
/// EPRElExp2       : EPR模板元素表达式2  如: EPR.TId.模板ID.元素ID
/// EPRElExp3       : EPR模板元素表达式3  如: EPR.TId.模板ID.元素ID
/// EPRElExp4       : EPR模板元素表达式4  如: EPR.TId.模板ID.元素ID
/// EPRElExp5       : EPR模板元素表达式5  如: EPR.TId.模板ID.元素ID
/// EPRElExp6       : EPR模板元素表达式6  如: EPR.TId.模板ID.元素ID
/// EPRElExp7       : EPR模板元素表达式7  如: EPR.TId.模板ID.元素ID
/// EPRElExp8       : EPR模板元素表达式8  如: EPR.TId.模板ID.元素ID
/// EPRElExp9       : EPR模板元素表达式9  如: EPR.TId.模板ID.元素ID
/// EPRElExp10      : EPR模板元素表达式10  如: EPR.TId.模板ID.元素ID
/// *****************************************************
/// 参数说明     : 具体参数请参考类方法中的说明
/// *****************************************************
/// 返回值       :
/// ret          : true(1)/false(0)/error(-1)
/// *****************************************************
/// 调试         : w ##Class(web.DHCWMRQuality.BOACRExpFunction).CheckElementUnify(EpisodeID,EPRElExp1,EPRElExp2,EPRElExp3,EPRElExp4,EPRElExp5,EPRElExp6,EPRElExp7,EPRElExp8,EPRElExp9,EPRElExp10)
///              : w ##class(web.DHCWMRQuality.BOACRExpExplain).GetEPRElement("EPR.TId.67.O0050","EPR.",10770)
/// *****************************************************
ClassMethod CheckElementUnify(EpisodeID, UnifyType, EPRElExp1, EPRElExp2, EPRElExp3, EPRElExp4, EPRElExp5, EPRElExp6, EPRElExp7, EPRElExp8, EPRElExp9, EPRElExp10)
{
	n (EpisodeID,UnifyType,EPRElExp1,EPRElExp2,EPRElExp3,EPRElExp4,EPRElExp5,EPRElExp6,EPRElExp7,EPRElExp8,EPRElExp9,EPRElExp10)
	s ret=0
	q:(EpisodeID="")||(UnifyType="") ret
	
	//********************************************************
	//逻辑判断,模板元数是否全部非空
	//适应条件：
	//检查一组模板元数是否全部为空,全部非空返回true(1),否则返回false(0)
	//参数：
	//EpisodeID   就诊号
	//UnifyType   "0101" 或者 ""
	//EPRElExp1      EPR模板元素 或 "/"
	//EPRElExp2      EPR模板元素 或 "/"
	//EPRElExp3      EPR模板元素 或 "/"
	//EPRElExp4      EPR模板元素 或 "/"
	//EPRElExp5      EPR模板元素 或 "/"
	//EPRElExp6      EPR模板元素 或 "/"
	//EPRElExp7      EPR模板元素 或 "/"
	//EPRElExp8      EPR模板元素 或 "/"
	//EPRElExp9      EPR模板元素 或 "/"
	//EPRElExp10     EPR模板元素 或 "/"
	//********************************************************
	i UnifyType="0101" d
	.s (IsUnify1,IsUnify2,IsUnify3,IsUnify4,IsUnify5,IsUnify6,IsUnify7,IsUnify8,IsUnify9,IsUnify10)=0
	.s:$g(EPRElExp1)'="" IsUnify1=1
	.s:$g(EPRElExp2)'="" IsUnify2=1
	.s:$g(EPRElExp3)'="" IsUnify3=1
	.s:$g(EPRElExp4)'="" IsUnify4=1
	.s:$g(EPRElExp5)'="" IsUnify5=1
	.s:$g(EPRElExp6)'="" IsUnify6=1
	.s:$g(EPRElExp7)'="" IsUnify7=1
	.s:$g(EPRElExp8)'="" IsUnify8=1
	.s:$g(EPRElExp9)'="" IsUnify9=1
	.s:$g(EPRElExp10)'="" IsUnify10=1
	.s ret=(IsUnify1 && IsUnify2 && IsUnify3 && IsUnify4 && IsUnify5 && IsUnify6 && IsUnify7 && IsUnify8 && IsUnify9 && IsUnify10)
	
	
	//********************************************************
	//逻辑判断,模板元数是否为全部为正数
	//适应条件：
	//出院情况中[抢救次数]为数值型(正数),不能为“\”或是负数
	//出院情况中[成功次数]为数值型(正数),不能为“\”或是负数
	//临护室中[监护时间]为数值型(正数),不能为“\”或是负数
	//[新生儿体重]为数值型(正数),不能为“\”或是负数
	//[入院体重]为数值型(正数),不能为“\”或是负数
	//参数：
	//EpisodeID   就诊号
	//UnifyType   "0102"
	//EPRElExp1      EPR模板元素
	//EPRElExp2      EPR模板元素
	//...
	//********************************************************
	i UnifyType="0102" d
	.s (IsUnify1,IsUnify2,IsUnify3,IsUnify4,IsUnify5,IsUnify6,IsUnify7,IsUnify8,IsUnify9,IsUnify10)=1
	.s:$g(EPRElExp1)'="" IsUnify1=..IsNumber($g(EPRElExp1))
	.s:$g(EPRElExp2)'="" IsUnify2=..IsNumber($g(EPRElExp2))
	.s:$g(EPRElExp3)'="" IsUnify3=..IsNumber($g(EPRElExp3))
	.s:$g(EPRElExp4)'="" IsUnify4=..IsNumber($g(EPRElExp4))
	.s:$g(EPRElExp5)'="" IsUnify5=..IsNumber($g(EPRElExp5))
	.s:$g(EPRElExp6)'="" IsUnify6=..IsNumber($g(EPRElExp6))
	.s:$g(EPRElExp7)'="" IsUnify7=..IsNumber($g(EPRElExp7))
	.s:$g(EPRElExp8)'="" IsUnify8=..IsNumber($g(EPRElExp8))
	.s:$g(EPRElExp9)'="" IsUnify9=..IsNumber($g(EPRElExp9))
	.s:$g(EPRElExp10)'="" IsUnify10=..IsNumber($g(EPRElExp10))
	.s ret=(IsUnify1 && IsUnify2 && IsUnify3 && IsUnify4 && IsUnify5 && IsUnify6 && IsUnify7 && IsUnify8 && IsUnify9 && IsUnify10)
	
	
	//********************************************************
	//[临床与病理]和[病理诊断]一致性检查
	//适应条件：
	//如果[临床与病理]值为"未做",[病理诊断]值为"无"
	//如果[临床与病理]值为"符合","不符合","不肯定",[病理诊断]值不能为"无","//","，","无，"等
	//参数：
	//EpisodeID   就诊号
	//UnifyType   "0201"
	//EPRElExp1      临床与病理
	//EPRElExp2      病理诊断
	//********************************************************
	//[放射与病理]和[病理诊断]一致性检查
	//适应条件：
	//如果[放射与病理]值为"未做",[病理诊断]值为"无"
	//如果[放射与病理]值为"符合","不符合","不肯定",[病理诊断]值不能为"无","//","，","无，"等
	//参数：
	//EpisodeID   就诊号
	//UnifyType   "0201"
	//EPRElExp1      放射与病理
	//EPRElExp2      病理诊断
	//********************************************************
	//[术前与术后]和[手术操作名称1]一致性检查
	//适应条件：
	//如果[术前与术后]值为"未做",[病理诊断]值为"无"
	//如果[术前与术后]值为"符合","不符合","不肯定",[手术操作名称1]值不能为"无","//","，","无，"等
	//参数：
	//EpisodeID   就诊号
	//UnifyType   "0201"
	//EPRElExp1      术前与术后
	//EPRElExp2      手术操作名称1
	//********************************************************
	i UnifyType="0201" d
	.s IsUnify1=..IsUnify($g(EPRElExp1),"=""未做""")
	.s IsUnify2=..IsUnify($g(EPRElExp2),"=""无""")
	.s IsUnify3=..IsUnify($g(EPRElExp2),"'=""""")&&..IsUnify($g(EPRElExp2),"'="" """)&&..IsUnify($g(EPRElExp2),"'=""无""")&&..IsUnify($g(EPRElExp2),"'=""//""")&&..IsUnify($g(EPRElExp2),"'=""无,""")
	.s:(IsUnify1=1)&&(IsUnify2=1) ret=1
	.s:(IsUnify1=0)&&(IsUnify3=1) ret=1
	
	
	//********************************************************
	//手术日期逻辑检查（允许多行检查）
	//适应条件：
	//手术日期必须大于等于入院日期并且小于等于出院日期(出院日期更具各家医院要求定)
	//参数：
	//EpisodeID   就诊号
	//UnifyType   "0301"
	//EPRElExp1      手术日期1
	//EPRElExp2      手术日期2
	//...
	//********************************************************
	//操作日期逻辑检查（允许多行检查）
	//适应条件：
	//操作日期必须大于等于入院日期并且小于等于出院日期(出院日期更具各家医院要求定)
	//参数：
	//EpisodeID   就诊号
	//UnifyType   "0301"
	//EPRElExp1      操作日期1
	//EPRElExp2      操作日期2
	//...
	//********************************************************
	i UnifyType="0301" d
	.s (IsUnify1,IsUnify2,IsUnify3,IsUnify4,IsUnify5,IsUnify6,IsUnify7,IsUnify8,IsUnify9,IsUnify10)=1
	.s:$g(EPRElExp1)'="" IsUnify1=..IsUnifyOperDate(EpisodeID,$g(EPRElExp1))
	.s:$g(EPRElExp2)'="" IsUnify2=..IsUnifyOperDate(EpisodeID,$g(EPRElExp2))
	.s:$g(EPRElExp3)'="" IsUnify3=..IsUnifyOperDate(EpisodeID,$g(EPRElExp3))
	.s:$g(EPRElExp4)'="" IsUnify4=..IsUnifyOperDate(EpisodeID,$g(EPRElExp4))
	.s:$g(EPRElExp5)'="" IsUnify5=..IsUnifyOperDate(EpisodeID,$g(EPRElExp5))
	.s:$g(EPRElExp6)'="" IsUnify6=..IsUnifyOperDate(EpisodeID,$g(EPRElExp6))
	.s:$g(EPRElExp7)'="" IsUnify7=..IsUnifyOperDate(EpisodeID,$g(EPRElExp7))
	.s:$g(EPRElExp8)'="" IsUnify8=..IsUnifyOperDate(EpisodeID,$g(EPRElExp8))
	.s:$g(EPRElExp9)'="" IsUnify9=..IsUnifyOperDate(EpisodeID,$g(EPRElExp9))
	.s:$g(EPRElExp10)'="" IsUnify10=..IsUnifyOperDate(EpisodeID,$g(EPRElExp10))
	.s ret=(IsUnify1 && IsUnify2 && IsUnify3 && IsUnify4 && IsUnify5 && IsUnify6 && IsUnify7 && IsUnify8 && IsUnify9 && IsUnify10)
	
	
	//********************************************************
	//监护时间逻辑检查(只能单行检查)
	//适应条件：
	//监护室中临护退出时间要大于进入时间
	//参数：
	//EpisodeID   就诊号
	//UnifyType   "0302"
	//EPRElExp2      进入时间
	//EPRElExp4      退出时间
	//********************************************************
	i UnifyType="0302" d
	.s (IsUnify1,IsUnify2,IsUnify3,IsUnify4,IsUnify5)=1
	.s:($g(EPRElExp1)'="")&&($g(EPRElExp2)'="") IsUnify1=..IsUnifyMonitorDate(EpisodeID,$g(EPRElExp1),$g(EPRElExp2))
	.s:($g(EPRElExp3)'="")&&($g(EPRElExp4)'="") IsUnify2=..IsUnifyMonitorDate(EpisodeID,$g(EPRElExp3),$g(EPRElExp4))
	.s:($g(EPRElExp5)'="")&&($g(EPRElExp6)'="") IsUnify3=..IsUnifyMonitorDate(EpisodeID,$g(EPRElExp5),$g(EPRElExp6))
	.s:($g(EPRElExp7)'="")&&($g(EPRElExp8)'="") IsUnify4=..IsUnifyMonitorDate(EpisodeID,$g(EPRElExp7),$g(EPRElExp8))
	.s:($g(EPRElExp9)'="")&&($g(EPRElExp10)'="") IsUnify5=..IsUnifyMonitorDate(EpisodeID,$g(EPRElExp9),$g(EPRElExp10))
	.s ret=(IsUnify1 && IsUnify2 && IsUnify3 && IsUnify4 && IsUnify5)
	
	
	//********************************************************
	//手术情况一致性检查
	//适应条件：
	//手术情况每一行除2助以外的其他任何单元要求整行完整
	//即,一个单元不为空,其所在整行除2助以外的其他单元也不能为空
	//参数：
	//EpisodeID   就诊号
	//UnifyType   "0401"
	//EPRElExp1      手术日期
	//EPRElExp2      手术名称
	//EPRElExp3      术者
	//EPRElExp4      一助
	//EPRElExp5      麻醉方式
	//EPRElExp6      切口等级
	//EPRElExp7      愈合等级
	//EPRElExp8      麻醉师
	//********************************************************
	i UnifyType="0401" d
	.s (IsUnify1,IsUnify21,IsUnify22,IsUnify3,IsUnify4,IsUnify5,IsUnify6,IsUnify7,IsUnify8,IsUnify9,IsUnify10)=0
	.s:$g(EPRElExp1)'="" IsUnify1=1
	.s IsUnify21=..IsUnify($g(EPRElExp2),"=""无""")||..IsUnify($g(EPRElExp2),"=""""")
	.s IsUnify22=..IsUnify($g(EPRElExp2),"'=""""")&&..IsUnify($g(EPRElExp2),"'="" """)&&..IsUnify($g(EPRElExp2),"'=""无""")&&..IsUnify($g(EPRElExp2),"'=""//""")&&..IsUnify($g(EPRElExp2),"'=""无,""")
	.s:$g(EPRElExp3)'="" IsUnify3=1
	.s:$g(EPRElExp4)'="" IsUnify4=1
	.s:$g(EPRElExp5)'="" IsUnify5=1
	.s:$g(EPRElExp6)'="" IsUnify6=1
	.s:$g(EPRElExp7)'="" IsUnify7=1
	.s:$g(EPRElExp8)'="" IsUnify8=1
	.s:(IsUnify22=1)&&(1=(IsUnify1 && IsUnify3 && IsUnify4 && IsUnify5 && IsUnify6 && IsUnify7 && IsUnify8)) ret=1
	.s:(IsUnify21=1)&&(0=(IsUnify1 || IsUnify3 || IsUnify4 || IsUnify5 || IsUnify6 || IsUnify7 || IsUnify8)) ret=1
	
	
	//********************************************************
	//操作情况一致性检查
	//适应条件：
	//操作情况中,只在操作日期、操作名称、术者之间进行整行完整性质控
	//参数：
	//EpisodeID   就诊号
	//UnifyType   "0402"
	//EPRElExp1      操作日期
	//EPRElExp2      操作名称
	//EPRElExp3      术者
	//********************************************************
	i UnifyType="0402" d
	.s (IsUnify1,IsUnify21,IsUnify22,IsUnify3,IsUnify4,IsUnify5,IsUnify6,IsUnify7,IsUnify8,IsUnify9,IsUnify10)=0
	.s:$g(EPRElExp1)'="" IsUnify1=1
	.s IsUnify21=..IsUnify($g(EPRElExp2),"=""无""")||..IsUnify($g(EPRElExp2),"=""""")
	.s IsUnify22=..IsUnify($g(EPRElExp2),"'=""""")&&..IsUnify($g(EPRElExp2),"'="" """)&&..IsUnify($g(EPRElExp2),"'=""无""")&&..IsUnify($g(EPRElExp2),"'=""//""")&&..IsUnify($g(EPRElExp2),"'=""无,""")
	.s:$g(EPRElExp3)'="" IsUnify3=1
	.s:(IsUnify22=1)&&(1=(IsUnify1 && IsUnify3)) ret=1
	.s:(IsUnify21=1)&&(0=(IsUnify1 || IsUnify3)) ret=1
	
	//********************************************************
	//监护室一致性检查
	//适应条件：
	//监护室中, 要求对其进行整行完整性质控
	//参数：
	//EpisodeID   就诊号
	//UnifyType   "0403"
	//EPRElExp1      重症监护室名称
	//EPRElExp2      进入时间
	//EPRElExp3      退出时间
	//********************************************************
	i UnifyType="0403" d
	.s (IsUnify11,IsUnify12,IsUnify2,IsUnify3,IsUnify4,IsUnify5,IsUnify6,IsUnify7,IsUnify8,IsUnify9,IsUnify10)=0
	.s IsUnify11=..IsUnify($g(EPRElExp1),"=""无""")||..IsUnify($g(EPRElExp1),"=""""")
	.s IsUnify12=..IsUnify($g(EPRElExp1),"'=""""")&&..IsUnify($g(EPRElExp1),"'="" """)&&..IsUnify($g(EPRElExp1),"'=""无""")&&..IsUnify($g(EPRElExp1),"'=""//""")&&..IsUnify($g(EPRElExp1),"'=""无,""")
	.s:$g(EPRElExp2)'="" IsUnify2=1
	.s:$g(EPRElExp3)'="" IsUnify3=1
	.s:(IsUnify12=1)&&(1=(IsUnify2 && IsUnify3)) ret=1
	.s:(IsUnify11=1)&&(0=(IsUnify2 || IsUnify3)) ret=1
	
	q ret
}

ClassMethod IsUnify(el, val)
{
    n (el,val)
    s IsUnify=0
    s el=""""_el_""""
    s Result="IsUnify="_el_val
    s @Result
    q IsUnify
}

ClassMethod IsNumber(el)
{
    n (el)
    s IsNumber=(((+el)=el)&&((+el)>(-1)))
    q IsNumber
}

ClassMethod IsUnifyOperDate(EpisodeID, el)
{
	n (EpisodeID,el)
	s ret=0
	q:EpisodeID="" ret
	s el=..ChangeDate(el)
    s el=$s((+el)=0:"",1:(+el))
    q:el="" ret
    s AdmDate=$p($g(^PAADM(EpisodeID)),"^",6)   //入院日期(住院登记日期)
    s DisDate=$p($g(^PAADM(EpisodeID)),"^",59)  //出院日期(医疗结算日期)
    q:AdmDate>el ret
    q:(DisDate'="")&&(DisDate<el) ret
    s ret=1
	q ret
}

ClassMethod IsUnifyMonitorDate(EpisodeID, el1, el2)
{
	n (EpisodeID, el1, el2)
	s ret=0
	q:EpisodeID="" ret
	s InDate=..ChangeDate($p($g(el1)," ",1))
    s InDate=$s((+InDate)=0:"",1:(+InDate))
    q:InDate="" ret
	s InTime=..ChangeTime($p($g(el1)," ",2))
    s InTime=$s((+InTime)=0:"",1:(+InTime))
    q:InTime="" ret
	s OutDate=..ChangeDate($p($g(el2)," ",1))
    s OutDate=$s((+OutDate)=0:"",1:(+OutDate))
    q:OutDate="" ret
	s OutTime=..ChangeTime($p($g(el2)," ",2))
    s OutTime=$s((+OutTime)=0:"",1:(+OutTime))
    q:OutTime="" ret
    q:((OutDate-InDate)*24*60*60+(OutDate-InTime))<0 ret
    s AdmDate=$p($g(^PAADM(EpisodeID)),"^",6)   //入院日期(住院登记日期)
    s DisDate=$p($g(^PAADM(EpisodeID)),"^",59)  //出院日期(医疗结算日期)
    q:AdmDate>InDate ret
    q:(DisDate'="")&&(DisDate<OutDate) ret
	s ret=1
	q ret
}

/// 电子病历日期格式转换
ClassMethod ChangeDate(date)
{
    n (date)
    q:date="" date
	s date=$tr($p(date," ",1),"年","-")
	s date=$tr(date,"月","-")
	s date=$tr(date,"日")
	s date=$tr(date,"/","-")
	s date=$zdh(date,3)
	q date
}

/// 电子病历时间格式转换
ClassMethod ChangeTime(time)
{
	n (time)
	q:time="" time
	s time=$zth(time,3)
	q time
}

/// ********************************************************************************
/// 病案首页每个页签必须填写整理后才能打印。
/// 出院情况中 术前与术后、临床与病理、放射与病理、之间的逻辑关系质控
/// 出院情况中 抢救次数、成功次数；临护室中 监护时间、新生儿体重、入院体重；必须为数值型，不能为“\”或是负数。
/// 手术日期或操作日期必须大于等于入院日期并且小于等于出院日期
/// 手术情况中 每一行除2助以外的其他任何单元要求整行完整（即，一个单元不为空，其所在整行除2助以外的其他单元也不能为空）
/// 操作情况中 只在 操作日期、操作名称、术者 之间进行整行完整性质控。
/// 监护室中 要求对其进行整行完整性质控。
/// 监护室中 临护退出时间 要大于进入时间
/// ********************************************************************************
ClassMethod WMRIvkTest(argMetaDR As %String)
{
	;EPR> 功能: 将中文格式日期 转换为 内部格式
	;EPR> 用途：将日期转为内部格式进行比较
	;EPR> d ##Class(EPRservice.SystemData).WMRIvkTest()
	;EPR> ##Class(EPRservice.SystemData).WMRIvkTest(EPR.TId.4.D0047)
    ;EPR> ##Class(EPRservice.SystemData).WMRIvkTest(EPR.TId.4.D0048)
	q:($d(argMetaDR)=0)||(argMetaDR ="") ""

	s test=argMetaDR
	s test=$tr($p(test," ",1),"年","-")
	s test=$tr(test,"月","-")
	s test=$tr(test,"日")
	s test=$zdh(test,3)
	
	q test
}

ClassMethod WMRIvkTest2(argMetaDR1 As %String, argMetaDR2 As %String, argMetaDR3 As %String, argMetaDR4 As %String, argMetaDR5 As %String, argMetaDR6 As %String, argMetaDR7 As %String)
{
	;EPR> 功能: 手术情况 整行填写必须完整
	;EPR> 用途：整行填写必须完整
	;EPR> d ##Class(EPRservice.SystemData).WMRIvkTest2()

	;q:($d(argMetaDR)=0)||(argMetaDR ="") ""

	s test=""
	s t1=argMetaDR1
	s t2=argMetaDR2
	s t3=argMetaDR3
	s t4=argMetaDR4
	s t5=argMetaDR5
	s t6=argMetaDR6
	s t7=argMetaDR7
	
	
	if t1'="" {s t1=1} else {s t1=0}
	if t2'="" {s t2=1} else {s t2=0}
	if t3'="" {s t3=1} else {s t3=0}
	if t4'="" {s t4=1} else {s t4=0}
	if t5'="" {s t5=1} else {s t5=0}
	if t6'="" {s t6=1} else {s t6=0}
	if t7'="" {s t7=1} else {s t7=0}
	
    q:((t1 || t2 || t3 || t4 || t5 || t6 || t7)=0) "1"
    
	if (t1 && t2 && t3 && t4 && t5 && t6 && t7)
	{ s test=1} else { s test=0 }

	q test
}

ClassMethod WMRIvkTest5(argMetaDR As %String)
{
	;EPR> WMR 质控类方法  费用合计与费用子项目的关系
	;EPR> (argMeta1 As %String, argMeta2 As %String, argMeta3 As %String, argMeta4 As %String, argMeta5 As %String, argMeta6 As %String, argMeta7 As %String, argMeta8 As %String, argMeta9 As %String, argMeta10 As %String, argMeta11 As %String, argMeta12 As %String, argMeta13 As %String, argMeta14 As %String, argMeta15 As %String, argMeta16 As %String, argMeta17 As %String)
	;EPR> ##Class(EPRservice.SystemData).WMRIvkTest5(316.67,0.00,1.00,4.78,0.35,257.00,0.00,0.00,3.00,0.00,0.00,0.00,0.00,24.54,26.00,0.00,0.00)
	;EPR> ##Class(EPRservice.SystemData).WMRIvkTest5(EPR.TId.1.S0060) ;AdmId
	;##Class(EPRservice.SystemData).WMRIvkTest5(EPR.TId.4.S0008,EPR.TId.4.S0010,EPR.TId.4.S0009,EPR.TId.4.S0011,EPR.TId.4.S0012,EPR.TId.4.S0027,EPR.TId.4.S0026,EPR.TId.4.S0024,EPR.TId.4.S0023,EPR.TId.4.S0022,EPR.TId.4.S0013,EPR.TId.4.S0021,EPR.TId.4.S0015,EPR.TId.4.S0014,EPR.TId.4.S0017,EPR.TId.4.S0019,EPR.TId.4.S0028)
	
	q:($d(argMetaDR)=0)||(argMetaDR ="") "1"
	
	s ^zTT(20)=argMetaDR
	s argMeta1=##Class(EPRservice.BOScatterData).GetScatterData(argMetaDR,4,"S0008")
	s argMeta1=$tr(argMeta1,"Null")
	
	s argMeta2=##Class(EPRservice.BOScatterData).GetScatterData(argMetaDR,4,"S0010")
	s argMeta2=$tr(argMeta2,"Null")
	
	s argMeta3=##Class(EPRservice.BOScatterData).GetScatterData(argMetaDR,4,"S0009")
	s argMeta3=$tr(argMeta3,"Null")
	
	s argMeta4=##Class(EPRservice.BOScatterData).GetScatterData(argMetaDR,4,"S0011")
	s argMeta4=$tr(argMeta4,"Null")
	
	s argMeta5=##Class(EPRservice.BOScatterData).GetScatterData(argMetaDR,4,"S0012")
	s argMeta5=$tr(argMeta5,"Null")
	
	s argMeta6=##Class(EPRservice.BOScatterData).GetScatterData(argMetaDR,4,"S0027")
	s argMeta6=$tr(argMeta6,"Null")
	
	s argMeta7=##Class(EPRservice.BOScatterData).GetScatterData(argMetaDR,4,"S0026")
	s argMeta7=$tr(argMeta7,"Null")
	
	s argMeta8=##Class(EPRservice.BOScatterData).GetScatterData(argMetaDR,4,"S0024")
	s argMeta8=$tr(argMeta8,"Null")
	
	s argMeta9=##Class(EPRservice.BOScatterData).GetScatterData(argMetaDR,4,"S0023")
	s argMeta9=$tr(argMeta9,"Null")
	
	s argMeta10=##Class(EPRservice.BOScatterData).GetScatterData(argMetaDR,4,"S0022")
	s argMeta10=$tr(argMeta10,"Null")
	
	s argMeta11=##Class(EPRservice.BOScatterData).GetScatterData(argMetaDR,4,"S0013")
	s argMeta11=$tr(argMeta11,"Null")
	
	s argMeta12=##Class(EPRservice.BOScatterData).GetScatterData(argMetaDR,4,"S0021")
	s argMeta12=$tr(argMeta12,"Null")
	
	s argMeta13=##Class(EPRservice.BOScatterData).GetScatterData(argMetaDR,4,"S0015")
	s argMeta13=$tr(argMeta13,"Null")
	
	s argMeta14=##Class(EPRservice.BOScatterData).GetScatterData(argMetaDR,4,"S0014")
	s argMeta14=$tr(argMeta14,"Null")
	
	s argMeta15=##Class(EPRservice.BOScatterData).GetScatterData(argMetaDR,4,"S0017")
	s argMeta15=$tr(argMeta15,"Null")
	
	s argMeta16=##Class(EPRservice.BOScatterData).GetScatterData(argMetaDR,4,"S0019")
	s argMeta16=$tr(argMeta16,"Null")
	
	s argMeta17=##Class(EPRservice.BOScatterData).GetScatterData(argMetaDR,4,"S0028")
	s argMeta17=$tr(argMeta17,"Null")
	
	q:(argMeta1="")||(argMeta2="")||(argMeta3="")||(argMeta4="")||(argMeta5="")||(argMeta6="")||(argMeta7="")||(argMeta8="")||(argMeta9="")||(argMeta10="")||(argMeta11="")||(argMeta12="")||(argMeta13="")||(argMeta14="")||(argMeta15="")||(argMeta16="")||(argMeta17="") "1"
	
    s test =""
	s t1 = argMeta1
	s t2 = argMeta2 + argMeta3 + argMeta4 + argMeta5 + argMeta6 + argMeta7 + argMeta8 + argMeta9 + argMeta10 + argMeta11 + argMeta12 + argMeta13 + argMeta14 + argMeta15 + argMeta16 + argMeta17
    
    s ^zTT(21)=t1_"++"_t2
	if t1=t2 {s test=1} else {s test=0}


	q test
}

ClassMethod WMRIvkTest6(argMetaDR As %String)
{
	;EPR> WMR 质控类方法  主要诊断描述不能为 无     诊断代码不能为 / /
	;EPR> (argMeta1 As %String, argMeta2 As %String)
	;EPR> ##Class(EPRservice.SystemData).WMRIvkTest6
	;EPR> ##Class(EPRservice.SystemData).WMRIvkTest6(EPR.TId.1.S0060) ;AdmId
	
	
	q:($d(argMetaDR)=0)||(argMetaDR ="") "1"
	
	s ^zTT(20)=argMetaDR
	s argMeta1=##Class(EPRservice.BOScatterData).GetScatterData(argMetaDR,2,"I0002")
	s argMeta1=$tr(argMeta1,"Null")
	
	s argMeta2=##Class(EPRservice.BOScatterData).GetScatterData(argMetaDR,2,"I0002","C")
	s argMeta2=$tr(argMeta2,"Null")
	
	q:(argMeta1="")||(argMeta2="") "1"
	
    s test =""
	s t1 = argMeta1
	s t2 = argMeta2
    
    s ^zTT(21)=t1_"++"_t2
	if (t1'="无")&&(t2'="/ /") {s test=1} else {s test=0}


	q test
}

}
