/// Creator:      fengliang
/// CreatDate:    2021-03-12
/// Description:  PDA主页模块配置	
Class CT.NUR.MNIS.MainModule Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property ModuleName As %String(TRUNCATE = 1);

Property ModuleCode As %String(TRUNCATE = 1);

Property ModuleSort As %String(TRUNCATE = 1);

Property ModuleCanFlag As %String(TRUNCATE = 1);

Property ModuleMenu As %String(TRUNCATE = 1);

Index codeIndex On ModuleCode;

Index sortIndex On ModuleSort;

/// Creator: 		lms
/// CreatDate: 		2019-12-20
/// Description: 	保存维护的模板配置	
/// Input			"模板名称^模板代码^顺序^是否启用^模板Id^用户Id"
/// Return：		""
/// Method			w ##class(CT.NUR.MNIS.MainModule).Save("床位图^BEDMAP^1^Y^^1")
/// Method			w ##class(CT.NUR.MNIS.MainModule).Save("医嘱查询^ORDERSEARCH^2^Y^^1")
/// Method			w ##class(CT.NUR.MNIS.MainModule).Save("医嘱执行^ORDEREXECUTE^3^Y^^1")
/// Method			w ##class(CT.NUR.MNIS.MainModule).Save("入院分床^ALLOTBED^4^Y^^1")
/// Method			w ##class(CT.NUR.MNIS.MainModule).Save("生命体征^VITALSIGN^5^Y^^1")
/// Method			w ##class(CT.NUR.MNIS.MainModule).Save("事件管理^EVENTS^6^Y^^1")
/// Method			w ##class(CT.NUR.MNIS.MainModule).Save("医嘱单^DOCORDERLIST^7^Y^^1")
/// Method			w ##class(CT.NUR.MNIS.MainModule).Save("检查报告^CHECK^8^Y^^1")
/// Method			w ##class(CT.NUR.MNIS.MainModule).Save("检验报告^LAB^9^Y^^1")
/// Method			w ##class(CT.NUR.MNIS.MainModule).Save("检验打包^LABOUT^10^Y^^1")
/// Method			w ##class(CT.NUR.MNIS.MainModule).Save("护理病历^MODELDETAIL^11^Y^^1")
/// Method			w ##class(CT.NUR.MNIS.MainModule).Save("护理巡视^NURTOUR^12^Y^^1")
/// Method			w ##class(CT.NUR.MNIS.MainModule).Save("输液复核^DOSINGREVIEW^13^Y^^1")
/// Method			w ##class(CT.NUR.MNIS.MainModule).Save("手术查询^OPERATION^14^Y^^1")
/// Method			w ##class(CT.NUR.MNIS.MainModule).Save("输血闭环^BLOOD^15^Y^^1")
/// Method			w ##class(CT.NUR.MNIS.MainModule).Save("母乳闭环^MILK^16^Y^^1")
/// Method			w ##class(CT.NUR.MNIS.MainModule).Save("母婴关联^MOTHERBABYLINK^17^Y^^1")
/// Method			w ##class(CT.NUR.MNIS.MainModule).Save("静配接收^IFOrdRec^18^Y^^1")
/// Method			w ##class(CT.NUR.MNIS.MainModule).Save("病理运送^PLYOUT^19^Y^^1")
/// Method			w ##class(CT.NUR.MNIS.MainModule).Save("输液总览^MODELDETAIL^20^Y^^1")
/// Method			w ##class(CT.NUR.MNIS.MainModule).Save("健康宣教^HealthEduFragment^21^Y^^1")
/// Method			w ##class(CT.NUR.MNIS.MainModule).Save("任务总览^TaskOverviewFragment^22^Y^^1")
/// Method			w ##class(CT.NUR.MNIS.MainModule).Save("护理计划^NurPlanFragment^23^Y^^1")
/// Method			w ##class(CT.NUR.MNIS.MainModule).Save("血糖采集^BloodSugarFragment^24^Y^^1")
ClassMethod Save(parr As %String) As %String
{
	s modelName=$p(parr,"^",1)
	s modelCode=$p(parr,"^",2)
	s modelSort=$p(parr,"^",3)
	s modelcanFlag=$p(parr,"^",4)
	s modelId=$p(parr,"^",5)
	s moduleMenu=$p(parr,"^",6)
	i modelcanFlag="" s modelcanFlag="Y"
	i modelId=""{
		s obj=##class(CT.NUR.MNIS.MainModule).%New()
	}
	else
	{
		s obj=##class(CT.NUR.MNIS.MainModule).%OpenId(modelId)
	}
	
	s obj.ModuleName=modelName
	s obj.ModuleCode=modelCode
	s obj.ModuleSort=modelSort
	s obj.ModuleCanFlag=modelcanFlag
	s obj.ModuleMenu=moduleMenu
	d obj.%Save()
	d obj.%Close()

	q ""
}

/// Creator: 		lms
/// CreatDate: 		2019-12-20
/// Description: 	删除模板配置	
/// Input			"模板ID"
/// Return：		""
/// Method			w ##class(CT.NUR.MNIS.MainModule).Delete("1")
ClassMethod Delete(idStr As %String) As %String
{
	s len=$l(idStr,"^")
	f i=1:1:len  d
	.s modelId=$p(idStr,"^",i)
	.s obj=##class(CT.NUR.MNIS.MainModule).%OpenId(modelId)
	.d obj.%DeleteId(modelId)
	q ""
}

ClassMethod Update() As %String
{
	s change=0
	d ..Raw(.arr)
	s k=+$o(arr(""),-1)
	s d=+$g(^CT.NUR.MNIS.MainModuleD)
	s mode=$g(arr(0,"mode"))
	i (mode="full") {
		k ^CT.NUR.MNIS.MainModuleD
		s i=d f  s i=$o(arr(i)) q:(i="")  d
		.s data=$g(arr(i))
		.s ^CT.NUR.MNIS.MainModuleD(i)=data
		s change=1
	} else {
		k arr2
		s i=0 f  s i=$o(^CT.NUR.MNIS.MainModuleD(i)) q:(i="")  d
		.s data=$g(^CT.NUR.MNIS.MainModuleD(i))
		.s code=$lg(data,3)
		.q:(code="")
		.s arr2(code)=i
		;default increases
		i (k>d) {
			s i=d f  s i=$o(arr(i)) q:(i="")  d
			.s data=$g(arr(i))
			.s mode=$g(arr(i,"mode"))
			.s code=$lg(data,3)
			.q:(code="")
			.i ($d(arr2(code))) d
			..q:(mode'="overwrite")
			..s j=$g(arr2(code))
			..s r=$g(^CT.NUR.MNIS.MainModuleD(j))
			..q:(r=data)
			..s ^CT.NUR.MNIS.MainModuleD(j)=data
			..s change=1
			.e  d
			..s ^CT.NUR.MNIS.MainModuleD(i)=data
			..s change=1
			.k arr(i)
		}
		s d=+$o(^CT.NUR.MNIS.MainModuleD(""),-1)
		s i=0 f  s i=$o(arr(i)) q:(i="")  d
		.s data=$g(arr(i))
		.s mode=$g(arr(i,"mode"))
		.s code=$lg(data,3)
		.q:(code="")
		.i ($d(arr2(code))) d
		..q:(mode'="overwrite")
		..s j=$g(arr2(code))
		..s r=$g(^CT.NUR.MNIS.MainModuleD(j))
		..q:(r=data)
		..s ^CT.NUR.MNIS.MainModuleD(j)=data
		..s change=1
		.e  d
		..q:(mode'="overwrite")&&(mode'="increment")
		..s ^CT.NUR.MNIS.MainModuleD($i(d))=data
		..s change=1
		.k arr(i)
	}
	i (change) d
	.s d=$o(^CT.NUR.MNIS.MainModuleD(""),-1)
	.i (d>0) s ^CT.NUR.MNIS.MainModuleD=d
	.e  k ^CT.NUR.MNIS.MainModuleD
	.d ##class(CT.NUR.MNIS.MainModule).%BuildIndices()
	q change
}

ClassMethod Raw(ByRef arr) As %String
{
	k arr
	s arr(1)=$lb("","床位图","BEDMAP","1","Y","1")
	s arr(2)=$lb("","医嘱查询","ORDERSEARCH","2","Y","3")
	s arr(3)=$lb("","医嘱执行","ORDEREXECUTE","3","Y","2")
	s arr(4)=$lb("","入院分床","ALLOTBED","4","Y","1")
	s arr(5)=$lb("","生命体征","VITALSIGN","5","Y","1")
	s arr(6)=$lb("","事件管理","EVENTS","6","Y","1")
	s arr(7)=$lb("","医嘱单","DOCORDERLIST","7","Y","3")
	s arr(8)=$lb("","检查报告","CHECK","8","Y","3")
	s arr(9)=$lb("","检验报告","LAB","9","Y","3")
	s arr(10)=$lb("","检验打包","LABOUT","10","Y","4")
	s arr(11)=$lb("","护理病历","MODELDETAIL","11","Y","1")
	s arr(12)=$lb("","护理巡视","NURTOUR","12","Y","1")
	s arr(13)=$lb("","输液复核","DOSINGREVIEW","13","Y","2")
	s arr(14)=$lb("","手术查询","OPERATION","14","Y","3")
	s arr(15)=$lb("","输血闭环","BLOOD","15","Y","1")
	s arr(16)=$lb("","母乳闭环","MILK","16","N","4")
	s arr(17)=$lb("","母婴关联","MOTHERBABYLINK","17","N","4")
	s arr(18)=$lb("","静配接收","IFOrdRec","18","Y","2")
	s arr(19)=$lb("","病理运送","PLYOUT","19","Y","4")
	s arr(20)=$lb("","输液总览","InfusionSituation","20","Y","2")
	s arr(21)=$lb("","健康宣教","HealthEduFragment","21","Y","1")
	s arr(22)=$lb("","任务总览","TaskOverviewFragment","22","Y","1")
	s arr(23)=$lb("","护理计划","NurPlanFragment","23","Y","1")
	s arr(24)=$lb("","Rfid绑定","PatBindRfid","24","Y","4")
	s arr(25)=$lb("","外出管理","OutManageFragment","25","Y","4")
	s arr(26)=$lb("","血糖录入","BloodSugarFragment","26","Y","1")
	s arr(27)=$lb("","药品交接","DRUGHANDOVER","27","Y","2")
	s arr(28)=$lb("","摆药核对","DRUGPUT","28","N","2")
	s arr(29)=$lb("","输血系统*","BloodTransFragment","29","N","1")
	s arr(30)=$lb("","患者交接*","PatHandoverNewFragment","30","N","1")
	s arr(31)=$lb("","输液摆药","DRUGPUTSY","31","Y","2")
	s arr(32)=$lb("","口服摆药","DRUGPUTKF","32","Y","2")
	s arr(27,"mode")="overwrite"
	s arr(28,"mode")="overwrite"
	s arr(29,"mode")="increment"
	s arr(30,"mode")="increment"
	s arr(31,"mode")="increment"
	s arr(32,"mode")="increment"
	q ""
}

Storage Default
{
<Data name="MainModuleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ModuleName</Value>
</Value>
<Value name="3">
<Value>ModuleCode</Value>
</Value>
<Value name="4">
<Value>ModuleSort</Value>
</Value>
<Value name="5">
<Value>ModuleCanFlag</Value>
</Value>
<Value name="6">
<Value>ModuleMenu</Value>
</Value>
</Data>
<DataLocation>^CT.NUR.MNIS.MainModuleD</DataLocation>
<DefaultData>MainModuleDefaultData</DefaultData>
<IdLocation>^CT.NUR.MNIS.MainModuleD</IdLocation>
<IndexLocation>^CT.NUR.MNIS.MainModuleI</IndexLocation>
<StreamLocation>^CT.NUR.MNIS.MainModuleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
