Import SQLUser

Class web.DHCWMRChineseCtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 32;

ClassMethod GetChinese(Ind)
{
	s ret=""
	s:Ind="WorkItemEdit" ret="无"
	s:Ind="PrintBarCode" ret="病案条码^病案卷条码"
	s:Ind="MrNoLenEdit" ret="全院统一取号^按科室取号"
	s:Ind="InputHistory" ret="删除^男^女"
	s:Ind="EmergencyDetailEdit" ret="(必输)"
	s:Ind="EmergencyList" ret="全部^活动^非活动"
	s:Ind="EmergencyEdit" ret="文本^数字^日期^字典^无"
	s:Ind="AdmitPatientMain" ret="黑体^宋体^床 头 卡^姓名^性别^年龄^住院号^科室^入院日期^付费种类^临床种类^剩余病案号数量:^个,请联系病案科获取更多病案号!^请联系病案科获取更多病案号!^门诊就诊,请确认是否接诊!"
	s:Ind="DischargeList" ret="黑体^宋体^出院日期:^眼科病房^普外三区^普外二区^胸外二区^骨科二区^神外病房^普外一区^普外科日间病房^心脏内三区^心脏二区^风湿病区^康复病区^心脏一区^心脏CCU^中心ICU病房^耳鼻喉病房^热研病房^胸外一区^内八感染病房^骨科一区^血液科病区^医保中心二区^医保中心一区^胃肠肝胆科一区^胃肠肝胆科二区^肝病病房^综一区^综二区^综四区^综五区^综六区^呼吸内科一区^综三区^内分泌皮肤病区^肾内病房^神内一区^神内二区^急诊病房ICU^急诊病房^妇科病房^产休病房^泌尿病房^肾移植病房^儿科病房"
	s:Ind="HistoryAdvancedQueryCond" ret="全部^男^女"
	s:Ind="HistoryQueryByNo1" ret="病案号^登记号^姓名^性别^生日^身份证号^工作单位^家庭住址"
	s:Ind="HistoryInfoDisplay" ret="死亡病案^    已复印病案^    已封存病案^对不起,没有找到这个病人的信息!"
	s:Ind="WorkFlowModifyStatus" ret="突发^(突发)^在病案架上^未在病案架上"
	s:Ind="DHC.WMR.WorkFlow.SequenceRun" ret="Emergency^突发#Emergency1^(突发)#Normal^正常#NotStayIn^未在病案架上#Volume^(卷)#NoPower^您没有任何病案流程操作的权利!"
	s:Ind="MrEvalationTest" ret="编号<field>问题<field>范畴<field>数量<field>金额<field>责任人<field>所在科室<field>责任人类型^分数:^等级:"
	s:Ind="DHC.WMR.PrintCard" ret="HeiTi^黑体#SongTi^宋体#PID^身份证号:#Name^姓名#MrNo^住院号码#Sex^性别#Age^年龄#NativePlace^籍贯#Dep^科别#Company^单位#CompanyZip^邮政编码#Address^住址#AddressZip^邮政编码#AdmitDate^入院日期#DischargeDate^出院日期#Diagnose^临床诊断"
	s:Ind="DHC.WMR.DictionaryTool" ret="PleaseChoose^请选择#RootDic^根字典"
	s:Ind="DHC.WMR.AdmitVisit" ret="请认真选择就诊记录重新接诊!^请输入医护人员签名!"
	s:Ind="DHC.WMR.PrintCard.List" ret="黑体^住院病人查询报表^宋体^(登)^全部^第一次住院^多次住院"
	s:Ind="DHC.WMR.ICDVersion.Edit" ret="D--疾病诊断^O--手术编码"
	s:Ind="DHC.WMR.Req.List" ret="HeiTi^首都医科大学附属北京妇产医院病案出库清单^HeiTi^首都医科大学附属北京妇产医院^病案申请条^卡号^姓名^病案类型^病案号^申请科室^申请人^申请操作日期^申请类型^申请操作^号别^挂号时间^时段^(急)^前一申请科室"
	s:Ind="DHC.WMR.ReqFirstFlag.List" ret="HeiTi^首都医科大学附属北京妇产医院病案出库清单^HeiTi^首都医科大学附属北京妇产医院^病案申请条^卡号^姓名^病案类型^病案号^申请科室^申请人^申请操作日期^申请类型^申请操作^号别^挂号时间^时段^(急)^前一申请科室"
	s:Ind="DHC.WMR.Paadm.List" ret="病人死亡^正常就诊^病历有效^病历无效^病历在架^病历不在架^病案号^建病案日期"
	q ret
}

}
