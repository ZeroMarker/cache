/// 名称:DHCMed.DTH.MaternalReport
/// 描述: 孕产妇死亡登记副卡
/// 编写者：pylian
/// 编写日期: 2016-07-18
Class DHCMed.DTH.MaternalReport Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 基本信息ID Pa_Patmas
Property PatientID As %String [ Required ];

/// 就诊表 ID
Property EpisodeID As %String [ Required ];

/// 死亡报告ID DHCMed.DTH.Report
Property DthReportID As %String;

/// 编号
Property DTHNo As %String;

/// 姓名
Property Name As %String;

/// 常住址 省
Property ConProvince As DHCMed.SS.AreaDic;

/// 常住址  市
Property ConCity As DHCMed.SS.AreaDic;

/// 常住址  县（区）
Property ConCounty As DHCMed.SS.AreaDic;

/// 常住址 乡
Property ConVillage As DHCMed.SS.AreaDic;

/// 常住址 小区（村）
Property ConRoad As %String(TRUNCATE = 1);

/// 暂住址 省
Property TempProvince As DHCMed.SS.AreaDic;

/// 暂住址 市
Property TempCity As DHCMed.SS.AreaDic;

/// 暂住址 县（区）
Property TempCounty As DHCMed.SS.AreaDic;

/// 暂住址 乡
Property TempVillage As DHCMed.SS.AreaDic;

/// 暂住址 小区（村）
Property TempRoad As %String(TRUNCATE = 1);

/// 户口 1. 本地    2. 非本地 
Property RegType As DHCMed.SS.Dictionary;

/// 计划内外
Property IsPlan As DHCMed.SS.Dictionary;

/// 年龄
Property Age As %String(TRUNCATE = 1);

/// 民族 1. 汉族   2. 少数民族  
Property Nation As DHCMed.SS.Dictionary;

/// 文化程度 1. 大专及以上  2. 高中或中专 3. 初中   4. 小学   5. 文盲 
Property Education As DHCMed.SS.Dictionary;

/// 家庭年人均收入（元）1. <1000元   2. 1000元~   3. 2000元~   4. 4000元~   5. 8000元~ 
Property FamilIncome As DHCMed.SS.Dictionary;

/// 常住址区 1. 平原  2.山区  3. 其他地区  
Property ConType As DHCMed.SS.Dictionary;

/// 孕次
Property PreTimes As %Numeric;

/// 产次
Property ProTimes As %Numeric;

/// 人工流产、引产次
Property LaborTimes As %Numeric;

/// 末次月经 
Property LastMenDate As %Date;

/// 分娩日期
Property DeliveryDate As %Date;

/// 分娩时间
Property DeliveryTime As %Time;

/// 死亡日期
Property DeathDate As %Date;

/// 死亡时间
Property DeathTime As %Time;

/// 分娩地点  1.省(地、市)级医院 2. 区县级医院 3.街道(乡镇)卫生院 
/// 4. 村接生室 5.家中    6. 途中    7. 其它    9.不详  0.未娩或28周之前流产
Property DeliveryPosition As DHCMed.SS.Dictionary;

/// 死亡地点  1.省(地、市)级医院 2. 区县级医院 3.街道(乡镇)卫生院 
/// 4. 村接生室 5.家中    6. 途中    7. 其它    9.不详 0.未娩或28周之前流产
Property DeathPosition As DHCMed.SS.Dictionary;

/// 分娩方式  0. 未娩    1. 自然产   2. 阴道手术产  3. 剖宫产 
Property DeliveryWay As DHCMed.SS.Dictionary;

/// 新法接生  1. 是      2. 否  
Property IsNewWay As DHCMed.SS.Dictionary;

/// 接生者    1. 医务人员  2. 乡村医生 3. 接生员  4. 其他人员 
Property Deliveryer As DHCMed.SS.Dictionary;

/// 产前检查  1. 有      2. 无 
Property IsPreCheck As DHCMed.SS.Dictionary;

/// 初检孕周 周
Property PregWeek As %Numeric;

/// 产检次数
Property PregCheckTime As %Numeric;

/// 死因诊断依据    1. 尸检   2. 病理    3. 临床   4. 死后推断  
Property DiagnoseBasis As DHCMed.SS.Dictionary;

/// 省级医疗保健机构评审结果  1. 可避免   2. 不可避免 
Property ProResult As DHCMed.SS.Dictionary;

/// 省级 影响死亡的主要因素       编号1    编号2  编号3
Property ProReason As DHCMed.SS.Dictionary;

/// 国家级评审结果            1. 可避免   2. 不可避免 
Property CountryResult As DHCMed.SS.Dictionary;

/// 国家 影响死亡的主要因素       编号1    编号2  编号3
Property CountryReason As DHCMed.SS.Dictionary;

/// 医生
Property RepDocDR As %String;

/// 报告科室
Property RepLocDR As %String;

/// 报告人
Property RepUsrDR As %String;

/// 报告日期
Property RepDate As %Date;

/// 报告时间
Property RepTime As %Time;

/// 报告状态
Property RepStatusDR As DHCMed.SS.Dictionary;

/// 审核人
Property CheckUser As %String;

/// 审核日期
Property CheckDate As %Date;

/// 审核时间
Property CheckTime As %Time;

/// 备注
Property ResumeText As %String;

/// add 2018-11-15
/// 末次月经类型 //如流产或分娩后未来月经而再次妊娠者，则末次月经时间全填填0；若末次月经不详者，则末次月经时间全填9
Property LastMenDR As DHCMed.SS.Dictionary;

/// 分娩时间分类  //如未分娩或28周以前流产者，分娩时间全填0 ,不详者分娩时间全填9
Property DeliDateDR As DHCMed.SS.Dictionary;

/// 死因分类编号  //01 流产、02 异位妊娠 03 妊娠剧吐 ....
Property CategoryDR As DHCMed.SS.Dictionary;

/// 病人ID索引
Index IndexPatientID On PatientID;

/// 报告日期索引
Index IndexDate On RepDate;

/// 死亡日期索引
Index IndexDeathDate On DeathDate;

/// 死亡证明书编号索引
Index IndexDeathNo On DTHNo;

/// 医学死亡证明书ID索引
Index IndexDthReportID On DthReportID;

/// Description: 根据Id得到DHCMed.DTH.Report对象
/// Input:       Id:RowId
/// Output:      DHCMed.DTH.MaternalReport对象
/// w ##Class(DHCMed.DTH.Report).GetObjById(44)
ClassMethod GetObjById(id As %String) As DHCMed.DTH.MaternalReport
{

	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.DTH.MaternalReport).%ExistsId(+id) return
	set obj=##Class(DHCMed.DTH.MaternalReport).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator:    pylian
/// CreateDate: 2016-07-18
/// Description:通过医学死亡证明书编号查询孕产妇死亡登记副卡ID
/// Input：
///    DthRepID:医学死亡证明书ID
/// Output：
///    孕产妇死亡登记副卡的ID（DHCMed.DTH.MaternalReport）
/// w ##class(DHCMed.DTH.MaternalReport).GetRepIDByDthID(1)
ClassMethod GetRepIDByDthID(DthRepID As %String) As %String
{
	n (DthRepID)
	Set ret=""
	Set RepID=""
	For {
		Set RepID=$o(^DHCMed.DTHi("MaterREP","IndexDthReportID"," "_DthRepID,RepID))
		Quit:RepID=""
		Set o=##class(DHCMed.DTH.MaternalReport).GetObjById(RepID)
		
		Continue:'$IsObject(o)
		Continue:'$IsObject(o.RepStatusDR)
		Continue:(o.RepStatusDR.Description["删除")||(o.RepStatusDR.Description["作废")
		
		Set ret=o.%Id()
		Do o.%Close()
	}
	Quit ret
}

/// Creator:    pylian
/// CreateDate: 2016-07-18
/// Description:更新DHCMed.DTH.MaternalReport
/// Input:      aInput:字符串
///             aSeparate:分割符
/// Output:     更新成功返回RowId，失败返回小于0数字
/// w ##Class(DHCMed.DTH.MaternalReport).Update("","")
ClassMethod Update(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	
	Set ID=$p(aInput,aSeparate,1)
	If (ID="") {
		Set obj=##class(DHCMed.DTH.MaternalReport).%New()
	} Else {
		Set obj=##class(DHCMed.DTH.MaternalReport).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return

	Set obj.PatientID=$p(aInput,aSeparate,2) // 基本信息ID Pa_Patmas
	Set obj.EpisodeID=$p(aInput,aSeparate,3) // 就诊表 ID
	Set obj.DthReportID=$p(aInput,aSeparate,4) // 死亡报告ID DHCMed.DTH.Report
	//Set obj.DTHNo=$p(aInput,aSeparate,5) //编号
	Set objRep=##Class(DHCMed.DTH.Report).GetObjById(+$p(aInput,aSeparate,4))
	quit:'$IsObject(objRep) return
	Set obj.DTHNo = objRep.DeathNo
	Set obj.Name=$p(aInput,aSeparate,6) // 姓名
	
    Set obj.ConProvince=##class(DHCMed.SS.AreaDic).GetObjById(+$p(aInput,aSeparate,7))  // 常住址 省
    Set obj.ConCity=##class(DHCMed.SS.AreaDic).GetObjById(+$p(aInput,aSeparate,8))  // 常住址  市
    Set obj.ConCounty=##class(DHCMed.SS.AreaDic).GetObjById(+$p(aInput,aSeparate,9))  // 常住址  县（区）
    Set obj.ConVillage=##class(DHCMed.SS.AreaDic).GetObjById(+$p(aInput,aSeparate,10))  // 常住址 乡
    Set obj.ConRoad=$p(aInput,aSeparate,11)     // 常住址 小区（村）
    Set obj.TempProvince=##class(DHCMed.SS.AreaDic).GetObjById(+$p(aInput,aSeparate,12))  // 暂住址 省
    Set obj.TempCity=##class(DHCMed.SS.AreaDic).GetObjById(+$p(aInput,aSeparate,13))  // 暂住址 市
    Set obj.TempCounty=##class(DHCMed.SS.AreaDic).GetObjById(+$p(aInput,aSeparate,14))  // 暂住址 县（区）
    Set obj.TempVillage=##class(DHCMed.SS.AreaDic).GetObjById(+$p(aInput,aSeparate,15))  // 暂住址 乡
    Set obj.TempRoad=$p(aInput,aSeparate,16)  // 暂住址 小区（村）
   
    Set obj.RegType=##class(DHCMed.SS.Dictionary).GetObjById(+$p(aInput,aSeparate,17))  // 户口 1. 本地    2. 非本地 
    Set obj.IsPlan=##class(DHCMed.SS.Dictionary).GetObjById(+$p(aInput,aSeparate,18))  // 计划内外
    Set obj.Age=$p(aInput,aSeparate,19)                                              // 年龄
    Set obj.Nation=##class(DHCMed.SS.Dictionary).GetObjById(+$p(aInput,aSeparate,20))  // 民族 1. 汉族   2. 少数民族
    Set obj.Education=##class(DHCMed.SS.Dictionary).GetObjById(+$p(aInput,aSeparate,21))  // 文化程度 1. 大专及以上  2. 高中或中专 3. 初中   4. 小学   5. 文盲 
    Set obj.FamilIncome=##class(DHCMed.SS.Dictionary).GetObjById(+$p(aInput,aSeparate,22))  // 家庭年人均收入（元）1. <1000元   2. 1000元~   3. 2000元~   4. 4000元~   5. 8000元~ 
    Set obj.ConType=##class(DHCMed.SS.Dictionary).GetObjById(+$p(aInput,aSeparate,23))  // 常住址 区 1. 平原  2.山区  3. 其他地区  
 
	Set obj.PreTimes=$p(aInput,aSeparate,24) // 孕次
	Set obj.ProTimes=$p(aInput,aSeparate,25) //  产次
	Set obj.LaborTimes=$p(aInput,aSeparate,26) // 人工流产、引产次
	Set LastMenDate = $p(aInput,aSeparate,27)
	Set:LastMenDate'="" LastMenDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(LastMenDate)
	Set obj.LastMenDate=LastMenDate //末次月经日期
	Set DeliveryDate = $p(aInput,aSeparate,28)
	Set:DeliveryDate'="" DeliveryDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(DeliveryDate)
	Set obj.DeliveryDate=DeliveryDate //分娩日期
	set obj.DeliveryTime=$p(aInput,aSeparate,29)
    Set DeathDate = $p(aInput,aSeparate,30)
	Set:DeathDate'="" DeathDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(DeathDate)
	Set obj.DeathDate=DeathDate //死亡日期

	set obj.DeathTime=$p(aInput,aSeparate,31)

    Set obj.DeliveryPosition=##class(DHCMed.SS.Dictionary).GetObjById(+$p(aInput,aSeparate,32))  // 分娩地点  1.省(地、市)级医院 2. 区县级医院 3.街道(乡镇)卫生院  4. 村接生室 5.家中    6. 途中    7. 其它    9.不详 
    Set obj.DeathPosition=##class(DHCMed.SS.Dictionary).GetObjById(+$p(aInput,aSeparate,33))  //死亡地点  1.省(地、市)级医院 2. 区县级医院 3.街道(乡镇)卫生院 4. 村接生室 5.家中    6. 途中    7. 其它    9.不详
    Set obj.DeliveryWay=##class(DHCMed.SS.Dictionary).GetObjById(+$p(aInput,aSeparate,34))  // 分娩方式  0. 未娩    1. 自然产   2. 阴道手术产  3. 剖宫产 
    Set obj.IsNewWay=##class(DHCMed.SS.Dictionary).GetObjById(+$p(aInput,aSeparate,35))  // 新法接生  1. 是      2. 否  
    Set obj.Deliveryer=##class(DHCMed.SS.Dictionary).GetObjById(+$p(aInput,aSeparate,36))  // 接生者    1. 医务人员  2. 乡村医生 3. 接生员  4. 其他人员 
    Set obj.IsPreCheck=##class(DHCMed.SS.Dictionary).GetObjById(+$p(aInput,aSeparate,37))  // 产前检查  1. 有      2. 无 
  
    Set obj.PregWeek=$p(aInput,aSeparate,38) /// 初检孕周 周
	Set obj.PregCheckTime=$p(aInput,aSeparate,39) /// 产检次数
    Set obj.DiagnoseBasis=##class(DHCMed.SS.Dictionary).GetObjById(+$p(aInput,aSeparate,40))  // 死因诊断依据    1. 尸检   2. 病理    3. 临床   4. 死后推断  
    Set obj.ProResult=##class(DHCMed.SS.Dictionary).GetObjById(+$p(aInput,aSeparate,41))  // 省级医疗保健机构评审结果  1. 可避免   2. 不可避免 
    Set obj.ProReason=##class(DHCMed.SS.Dictionary).GetObjById(+$p(aInput,aSeparate,42))  // 省级 影响死亡的主要因素       编号1    编号2  编号3
    Set obj.CountryResult=##class(DHCMed.SS.Dictionary).GetObjById(+$p(aInput,aSeparate,43))  // 国家级评审结果            1. 可避免   2. 不可避免 
    Set obj.CountryReason=##class(DHCMed.SS.Dictionary).GetObjById(+$p(aInput,aSeparate,44))  // 国家 影响死亡的主要因素       编号1    编号2  编号3
	Set obj.RepDocDR=$p(aInput,aSeparate,45)
	Set obj.RepLocDR=$p(aInput,aSeparate,46)
	Set obj.RepUsrDR=$p(aInput,aSeparate,47)
	Set obj.RepDate=+$h
	Set obj.RepTime=$p($h,",",2)
	Set obj.RepStatusDR=##class(DHCMed.SS.Dictionary).GetByTypeCode("DTHRunningState",+$p(aInput,aSeparate,50),"1")  // 状态
	Set obj.LastMenDR=##class(DHCMed.SS.Dictionary).GetObjById(+$p(aInput,aSeparate,51))   // 末次月经分类
	Set obj.DeliDateDR=##class(DHCMed.SS.Dictionary).GetObjById(+$p(aInput,aSeparate,52))  // 分娩时间分类
	Set obj.CategoryDR=##class(DHCMed.SS.Dictionary).GetObjById(+$p(aInput,aSeparate,53))  // 死因分类
	
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator:     pylian
/// CreateDate:  2016-07-19
/// Description: 更新省级/国家级评审结果
/// Input:       Id:RowId 
///              aSeparate:分割符
/// Output:      返回字符串
/// w ##Class(DHCMed.DTH.MaternalReport).UpdateEvaluate("44","")
ClassMethod UpdateEvaluate(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	Quit:aInput="" return
	
	if ($g(aSeparate)=""){
	    Set aSeparate="^"
	}
	
	Set ReportID=$p(aInput,aSeparate,1)
	Quit:(ReportID="") return
	
	Set obj=##Class(DHCMed.DTH.MaternalReport).%OpenId(+ReportID)
	Set obj.ProResult=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,2))  // 省级医疗保健机构评审结果  1. 可避免   2. 不可避免 
    Set obj.ProReason=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,3))  // 省级 影响死亡的主要因素       编号1    编号2  编号3
    Set obj.CountryResult=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,4))  // 国家级评审结果            1. 可避免   2. 不可避免 
    Set obj.CountryReason=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,5))  // 国家 影响死亡的主要因素       编号1    编号2  编号3

	set sc=obj.%Save()
	if ($system.Status.IsError(sc)) {
		do $system.OBJ.DisplayError(sc)
		set return=-1
	} else {
		set return=obj.%Id()
	}	
	do obj.%Close()
	
	quit return
}

/// Creator:     pylian
/// CreateDate:  2016-07-19
/// Description: 更改报告的状态
/// Input:       ReportID:报告RowId；2 StatusID:报告的状态；3 UserID:用户ID；4 ResumeText
///              aSeparate:分割符
/// Output:     成功返回1，失败返回小于0的数字
/// w ##class(DHCMed.DTH.MaternalReport).ModifyStatus("1^","^")
ClassMethod ModifyStatus(ReportID As %String, StatusID As %String, UserID As %String, ResumeText As %String)
{
	n (ReportID,StatusID,UserID,ResumeText)
	Set obj=##class(DHCMed.DTH.MaternalReport).GetObjById(ReportID)
	Do obj.%Close()
	Set obj.RepStatusDR=##class(DHCMed.SS.Dictionary).GetObjById(StatusID)
	Set obj.ResumeText=ResumeText
	Set obj.CheckUser=UserID
	Set obj.CheckDate=+$h
	Set obj.CheckTime=$p($h,",",2)
	set sc=obj.%Save()
	if ($system.Status.IsError(sc)) {
		do $system.OBJ.DisplayError(sc)
		set return=-1
	} else {
		set return=obj.%Id()
	}	
	do obj.%Close()
	
	quit return
}

Storage Default
{
<Data name="MaternalReportDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PatientID</Value>
</Value>
<Value name="3">
<Value>EpisodeID</Value>
</Value>
<Value name="4">
<Value>DthReportID</Value>
</Value>
<Value name="5">
<Value>DTHNo</Value>
</Value>
<Value name="6">
<Value>Name</Value>
</Value>
<Value name="7">
<Value>ConProvince</Value>
</Value>
<Value name="8">
<Value>ConDCity</Value>
</Value>
<Value name="9">
<Value>ConDCounty</Value>
</Value>
<Value name="10">
<Value>TempProvince</Value>
</Value>
<Value name="11">
<Value>TempCity</Value>
</Value>
<Value name="12">
<Value>TempCounty</Value>
</Value>
<Value name="13">
<Value>RegType</Value>
</Value>
<Value name="14">
<Value>IsPlan</Value>
</Value>
<Value name="15">
<Value>Age</Value>
</Value>
<Value name="16">
<Value>Nation</Value>
</Value>
<Value name="17">
<Value>Education</Value>
</Value>
<Value name="18">
<Value>FamilIncome</Value>
</Value>
<Value name="19">
<Value>ConType</Value>
</Value>
<Value name="20">
<Value>PreTime</Value>
</Value>
<Value name="21">
<Value>ProTime</Value>
</Value>
<Value name="22">
<Value>LaborTime</Value>
</Value>
<Value name="23">
<Value>LastMenDate</Value>
</Value>
<Value name="24">
<Value>DeliveryDate</Value>
</Value>
<Value name="25">
<Value>DeliveryTime</Value>
</Value>
<Value name="26">
<Value>DeathDate</Value>
</Value>
<Value name="27">
<Value>DeathTime</Value>
</Value>
<Value name="28">
<Value>DeliveryPosition</Value>
</Value>
<Value name="29">
<Value>DeathPosition</Value>
</Value>
<Value name="30">
<Value>DeliveryWay</Value>
</Value>
<Value name="31">
<Value>IsNewWay</Value>
</Value>
<Value name="32">
<Value>Deliveryer</Value>
</Value>
<Value name="33">
<Value>IsPreCheck</Value>
</Value>
<Value name="34">
<Value>PregWeek</Value>
</Value>
<Value name="35">
<Value>CheckTime</Value>
</Value>
<Value name="36">
<Value>DiagnoseBasis</Value>
</Value>
<Value name="37">
<Value>ProResult</Value>
</Value>
<Value name="38">
<Value>ProReason</Value>
</Value>
<Value name="39">
<Value>CountryResult</Value>
</Value>
<Value name="40">
<Value>CountryReason</Value>
</Value>
<Value name="41">
<Value>PregCheckTime</Value>
</Value>
<Value name="42">
<Value>RepDocDR</Value>
</Value>
<Value name="43">
<Value>RepLocDR</Value>
</Value>
<Value name="44">
<Value>RepUsrDR</Value>
</Value>
<Value name="45">
<Value>RepDate</Value>
</Value>
<Value name="46">
<Value>RepTime</Value>
</Value>
<Value name="47">
<Value>RepStatusDR</Value>
</Value>
<Value name="48">
<Value>CheckUser</Value>
</Value>
<Value name="49">
<Value>CheckDate</Value>
</Value>
<Value name="50">
<Value>ResumeText</Value>
</Value>
<Value name="51">
<Value>ConVillage</Value>
</Value>
<Value name="52">
<Value>ConRoad</Value>
</Value>
<Value name="53">
<Value>TempVillage</Value>
</Value>
<Value name="54">
<Value>TempRoad</Value>
</Value>
<Value name="55">
<Value>PreTimes</Value>
</Value>
<Value name="56">
<Value>ProTimes</Value>
</Value>
<Value name="57">
<Value>LaborTimes</Value>
</Value>
<Value name="58">
<Value>ConCity</Value>
</Value>
<Value name="59">
<Value>ConCounty</Value>
</Value>
<Value name="60">
<Value>LastMenDR</Value>
</Value>
<Value name="61">
<Value>DeliDateDR</Value>
</Value>
<Value name="62">
<Value>CategoryDR</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DTH("MaterREP")</DataLocation>
<DefaultData>MaternalReportDefaultData</DefaultData>
<IdLocation>^DHCMed.DTH("MaterREP")</IdLocation>
<IndexLocation>^DHCMed.DTHi("MaterREP")</IndexLocation>
<StreamLocation>^DHCMed.DTH.MaternalReportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
