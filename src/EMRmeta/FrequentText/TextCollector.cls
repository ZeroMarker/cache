/// 常用文本信息
Class EMRmeta.FrequentText.TextCollector Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property Summary As %String(MAXLEN = 99);

Property Content As %String(MAXLEN = 9999);

Property DiseaseID As %String;

Property ChapterID As %String;

Property CategoryID As %String;

Property Sequence As %Integer;

/// 个人文本、科室文本为CTLOC
Property UsrID As %String;

Index IdxDiseaseSeq On (DiseaseID, CategoryID, ChapterID, UsrID, Sequence);

Index IdxChapterSeq On (ChapterID, DiseaseID, CategoryID, UsrID, Sequence);

Index IdxUsrID On UsrID;

/// d ##Class(EMRmeta.FrequentText.TextCollector).newText()
ClassMethod newText()
{
	//ts
	s DiseaseID=""
	s ctloc = "1"
	s seq=1
	///////////////////////////////////////////
	s name="可摘局部义齿"
	d NewDisease	
	s cseq=1
	s cid=""
	s cname="初诊1：直接修复"
	d NewCategory	
	s cname="初诊2：治疗设计"
	d NewCategory
	s cname="初诊3：前牙修复"
	d NewCategory
	s cname="初诊4：即刻义齿"
	d NewCategory
	s cname="复诊1:试支架"
	d NewCategory
	s cname="复诊2:戴牙"
	d NewCategory
	s cname="复诊3:"
	d NewCategory
	s cname="复诊4:"
	d NewCategory
	
	//////////////////////////////////////
	s name="全口义齿"
	d NewDisease
	s cseq=1
	s cid=""
	s cname="初诊："		
	d NewCategory
	s cname="复诊1:确定颌位关系"		
	d NewCategory
	s cname="复诊2:试排牙"		
	d NewCategory
	s cname="复诊3:初戴"		
	d NewCategory
	s cname="复诊4:疼痛"		
	d NewCategory
	s cname="复诊5:附着体"		
	d NewCategory
	
	///////////////////////////////////////
	s name="颌面缺损修复"
	d NewDisease	
	s cseq=1
	s cid=""
	s cname="初诊1：腭护板"		
	d NewCategory	
	s cname="初诊2：赝复体"		
	d NewCategory
	s cname="复诊1:确定颌位关系"		
	d NewCategory
	s cname="复诊2:试排牙"		
	d NewCategory
	s cname="复诊3:初戴"		
	d NewCategory
	s cname="复诊4:腭护板初戴"		
	d NewCategory
	
	////////////////////////////////////////
	s name="慢性牙周炎"
	d NewDisease	
	s cseq=1
	s cid=""
	s cname="初诊"		
	d NewCategory	
	s cname="复诊记表"		
	d NewCategory
	s cname="复诊刮治"		
	d NewCategory	
	
	//////////////////////////////////////////////
	s name="菌斑性龈炎"
	d NewDisease
	
	
	////////////////////////////////////////	
	s name="牙周脓肿"
	d NewDisease	
	s cseq=1
	s cid=""
	s cname="初诊"		
	d NewCategory
	
	//////	
	s name="妊娠期龈炎"
	d NewDisease	
	s name="药物性牙龈增生"
	d NewDisease	
	////////////////////
	
	s name="乳牙慢性牙髓炎初诊"
	d NewDisease
	s cseq=1
	s cid=""
	s cname="拔髓初扩"		
	d NewCategory	
	s cname="一次性根充"		
	d NewCategory			
	
	s name="乳牙慢性根尖周炎初诊"
	d NewDisease
	s cseq=1
	s cid=""
	s cname="拔髓初扩"		
	d NewCategory	
	s cname="一次性根充"		
	d NewCategory
	
	
	s name="年轻恒牙牙髓炎初诊"
	d NewDisease	
	s name="年轻恒牙根尖周炎初诊"
	d NewDisease	
	s name="窝沟封闭初诊"
	d NewDisease	
	s name="乳牙拔除病历"
	d NewDisease	
	
	////////////////////////////////////////////
	s name="乳牙牙髓炎/根尖周炎复诊"
	d NewDisease
	s cseq=1
	s cid=""
	s cname="根管预备+封药"		
	d NewCategory	
	s cname="一次性根管治疗"		
	d NewCategory	
	
	//tcommit
 
	//tro
	q
NewDisease	
	s obj = ##Class(EMRmeta.FrequentText.Disease).%New()
	s obj.CTLocID=ctloc
	s obj.Name=name
	s obj.Sequence=seq
	d obj.%Save()
	s DiseaseID=obj.%Id()
	w "DiseaseID:"_DiseaseID_"    name:"_name_ " seq:"_seq,!
	s seq=seq+1
	q
NewCategory
	s obj = ##Class(EMRmeta.FrequentText.Category).%New()
	s obj.Name = cname
	s obj.DiseaseID=DiseaseID
	s obj.Sequence=cseq
	d obj.%Save()
	s cseq=cseq+1
	s cid=obj.%Id()
	w "DiseaseID:"_DiseaseID_"  cid:"_cid_"   cname:"_cname_" cseq:"_cseq,!
	q
}

/// d ##Class(EMRmeta.FrequentText.TextCollector).insertCategory()
ClassMethod insertCategory1(ctloc As %String, DiseaseID As %String)
{
	s seq=1
	s id=""
	s name="初诊1：直接修复"
	d NewObject	
	s name="初诊2：治疗设计"
	d NewObject
	s name="初诊3：前牙修复"
	d NewObject
	s name="初诊4：即刻义齿"
	d NewObject
	s name="复诊1:试支架"
	d NewObject
	s name="复诊2:戴牙"
	d NewObject
	s name="复诊3:"
	d NewObject
	s name="复诊4:"
	d NewObject
	q
NewObject
	s obj = ##Class(EMRmeta.FrequentText.Category).%New()
	s obj.Name = name
	s obj.DiseaseID=DiseaseID
	s obj.Sequence=seq
	d obj.%Save()
	s seq=seq+1
	s id=obj.%Id()
	w id,!
	q
}

//主诉	现病史	既往史	过敏史	检查	诊断	治疗计划	处置	医嘱	备注

/// W ##Class(EMRmeta.FrequentText.TextCollector).insertChapter()
ClassMethod insertChapter()
{
							 
	s ctloc = "1"
	s seq=1

	s name="主诉"
	d NewObject
	s name="现病史"
	d NewObject
	s name="既往史"
	d NewObject
	s name="过敏史"
	d NewObject
	s name="检查"
	d NewObject
	s name="诊断"
	d NewObject
	s name="治疗计划"
	d NewObject
	s name="处置"
	d NewObject
	s name="医嘱"
	d NewObject	
	s name="备注"
	d NewObject	
	q	
NewObject
	s obj = ##Class(EMRmeta.FrequentText.Chapter).%New()

	s obj.Name = name
	s obj.CTLocID=ctloc
	s obj.Sequence=seq
	d obj.%Save()
	s seq=seq+1
	w obj.%Id(),!
}

/// d ##Class(EMRmeta.FrequentText.TextCollector).insertText()
ClassMethod insertText()
{
	s seq=1
	s Summary="要求重新修复"
	s Content="上、下多个牙齿缺失,数年前曾活动假牙修复,现又有牙齿脱落,咀嚼食物困难，要求重新修复。"
	s DiseaseID="167"
	s CategoryID="339"
	s ChapterID="2"
	s UsrID="CTLOC"
	d NewObject
	q		
NewObject	
 
	s obj=##Class(EMRmeta.FrequentText.TextCollector).%New()
	s obj.Summary=Summary
	s obj.Content=Content
	s obj.DiseaseID=DiseaseID
	s obj.ChapterID=ChapterID
	s obj.CategoryID=CategoryID
	s obj.UsrID=UsrID
	s obj.Sequence=seq
	d obj.%Save()
}

Storage Default
{
<Data name="TextCollectorDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Title</Value>
</Value>
<Value name="3">
<Value>Summary</Value>
</Value>
<Value name="4">
<Value>Content</Value>
</Value>
<Value name="5">
<Value>DiseaseID</Value>
</Value>
<Value name="6">
<Value>ChapterID</Value>
</Value>
<Value name="7">
<Value>Sequence</Value>
</Value>
<Value name="8">
<Value>UsrID</Value>
</Value>
<Value name="9">
<Value>CategoryID</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.FreqTxt.TextCollectorD</DataLocation>
<DefaultData>TextCollectorDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.FreqTxt.TextCollectorD</IdLocation>
<IndexLocation>^DHCEMRM.FreqTxt.TextCollectorI</IndexLocation>
<StreamLocation>^DHCEMRM.FreqTxt.TextCollectorS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
