/// Creator:Xuwenhu
/// CreatDate:2022-11-30
/// Table：CT.WDT.CDSS.AssBaseFieldItem
Class web.CDSS.Access.AssBaseFieldItem Extends %RegisteredObject
{

/// Creator：Xuwenhu
/// CreatDate: 2022-11-30
/// Description：查询评估表字段选项表内容
/// Table：CT.WDT.CDSS.AssBaseFieldItem
/// Input：base 评估表注册表id
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.Access.AssBaseFieldItem","GetList","859||136")
Query GetList(base As %String) As %Query(ROWSPEC = "ABFIRowId,ItemValue,ItemScore,ItemExclusion,ItemJumpOption,ItemSequence,RuleDR,Remarks")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, base As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1

	if (base'="")
	{
		s BaseId=$p(base,"||",1)
		s FieldId=$p(base,"||",2)
		s ItemSequence = ""
		for
		{
			s ItemSequence = $O(^CT.WDT.CDSS.AssBaseFieldItemI("SeqIndex",BaseId,FieldId,ItemSequence))
			q:ItemSequence=""
			s ABFIChildSub = 0
			for
			{
				s ABFIChildSub = $O(^CT.WDT.CDSS.AssBaseFieldItemI("SeqIndex",BaseId,FieldId,ItemSequence,ABFIChildSub))
				q:ABFIChildSub=""
				s ABFIRowId = base_"||"_ABFIChildSub
				s ItemValue = $LG($G(^CT.WDT.CDSS.AssBaseD(BaseId,"ChildField",FieldId,"ChildItem",ABFIChildSub)),2)
				s ItemScore = $LG($G(^CT.WDT.CDSS.AssBaseD(BaseId,"ChildField",FieldId,"ChildItem",ABFIChildSub)),3)
				s ItemExclusion = $LG($G(^CT.WDT.CDSS.AssBaseD(BaseId,"ChildField",FieldId,"ChildItem",ABFIChildSub)),4)
				s ItemJumpOption = $LG($G(^CT.WDT.CDSS.AssBaseD(BaseId,"ChildField",FieldId,"ChildItem",ABFIChildSub)),5)
				//s ItemSequence = $LG($G(^CT.WDT.CDSS.AssBaseD(BaseId,"ChildField",FieldId,"ChildItem",ABFIChildSub)),6)
				s RuleDR =	$LG($G(^CT.WDT.CDSS.AssBaseD(BaseId,"ChildField",FieldId,"ChildItem",ABFIChildSub)),7)
				s Remarks = $LG($G(^CT.WDT.CDSS.AssBaseD(BaseId,"ChildField",FieldId,"ChildItem",ABFIChildSub)),8)
				d OutputRow	
			}
		}	
	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ABFIRowId,ItemValue,ItemScore,ItemExclusion,ItemJumpOption,ItemSequence,RuleDR,Remarks)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)

	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：Xuwenhu
/// CreatDate: 2022-11-30
/// Description：数据保存方法
/// Table：CT.WDT.CDSS.AssBaseFieldItem
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: w ##class(web.CDSS.Access.AssBaseFieldItem).SaveEntity("873||224&^&^1&^1&^&^&^")
ClassMethod SaveEntity(str) As %String
{
	s result=""
	if str["%CSP.CharacterStream"
	{
		s AllStr=""
		while 'file.AtEnd
		{
			s AllStr=AllStr_file.ReadLine()
		}	
	}
	else
	{
		s AllStr=str	
	}
	s eobj = ##class(web.CDSSEntity.Access.AssBaseFieldItem).%New()
	s eobj.ABFIParRef = $P(str,"&^",1)
	s eobj.ABFIRowId = $P(str,"&^",2)
	s eobj.ItemValue = $P(str,"&^",3)
	s eobj.ItemScore = $P(str,"&^",4)
	s eobj.ItemExclusion = $P(str,"&^",5)
	s eobj.ItemJumpOption = $P(str,"&^",6)
	s eobj.ItemSequence = $P(str,"&^",7)
	//s eobj.RuleDR=$P(str,"&^",8)
	s eobj.Remarks=$P(str,"&^",9)
	q:eobj.ABFIParRef="" "{success:'false',info:'未选择父表！'}"
	if $IsObject(eobj)
	{ 
		if (eobj.ABFIRowId="")  //如果RowId未赋值则增加
		{ 
			s obj=##class(CT.WDT.CDSS.AssBaseFieldItem).%New(eobj.ABFIParRef)
		}
		else   //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.AssBaseFieldItem).%OpenId(eobj.ABFIRowId)
			s bobj=##class(web.CDSSEntity.Access.AssBaseFieldItem).%New()
			s bobj.ABFIRowId = obj.%Id()
			s bobj.ABFIParRef = obj.ABFIParRef.%Id()
			s bobj.ItemValue = obj.ItemValue
			s bobj.ItemScore = obj.ItemScore
			s bobj.ItemExclusion = obj.ItemExclusion
			s bobj.ItemJumpOption = obj.ItemJumpOption
			s bobj.ItemSequence = obj.ItemSequence
			s bobj.Remarks=obj.Remarks
		}
		d obj.ABFIParRefSetObjectId(eobj.ABFIParRef)
		s obj.ItemValue = eobj.ItemValue
		s obj.ItemScore = eobj.ItemScore
		s obj.ItemExclusion = eobj.ItemExclusion
		s obj.ItemJumpOption = eobj.ItemJumpOption
		s obj.ItemSequence = eobj.ItemSequence
		s obj.Remarks = eobj.Remarks
		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		s id=""
		If $$$ISOK(sc)
		{
			tc
			//保存日志
			s id = obj.%Id()
			d:eobj.ABFIRowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.AssBaseFieldItem","CT.WDT.CDSS.AssBaseFieldItem","评估表字段选项表",id,eobj.ItemValue,"A",eobj)
			d:eobj.ABFIRowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.AssBaseFieldItem","CT.WDT.CDSS.AssBaseFieldItem","评估表字段选项表",eobj.ABFIRowId,eobj.ItemValue,"U",eobj,bobj)
			s result = "{success:'true',id:'"_id_"'}"    
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'保存失败!"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
			;s errortip = $SYSTEM.Status.GetErrorText(sc)
			//s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("评估表字段选项表","web.CDSS.Access.AssBaseFieldItem","SaveEntity",eobj)
			//s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")   
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
		//s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("评估表字段选项表","web.CDSS.Access.AssBaseFieldItem","SaveEntity","")
		//s ^ERRORLOGINFO(logid)="对象不存在！"   
	} 
	q result
}

/// Creator：Xuwenhu
/// CreatDate: 2022-12-14
/// Description：数据删除方法
/// Table：CT.WDT.CDSS.AssBaseFieldItem
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: w ##class(web.CDSS.Access.AssBaseFieldItem).DeleteData("876||5622||8")
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	if ($d(^CT.WDT.CDSS.AssBaseD($P(id,"||",1),"ChildField",$P(id,"||",2),"ChildItem",$P(id,"||",3)))=0)
	{
		s result = "{success:'false',info:'输入的id不存在'}"
		q result	
	}
	s eobj = ##class(web.CDSSEntity.Access.AssBaseFieldItem).%New()
	s obj = ##class(CT.WDT.CDSS.AssBaseFieldItem).%OpenId(id)
	
	s eobj.ABFIRowId = id
	s eobj.ABFIParRef = obj.ABFIParRef.%Id()
	s eobj.ItemValue = obj.ItemValue
	s eobj.ItemScore = obj.ItemScore
	s eobj.ItemExclusion = obj.ItemExclusion
	s eobj.ItemJumpOption = obj.ItemJumpOption
	s eobj.ItemSequence = obj.ItemSequence
	s:obj.RuleDR'="" eobj.RuleDR=obj.RuleDR.%Id()
	s:obj.RuleDR="" eobj.RuleDR=""
	s eobj.Remarks=obj.Remarks
	
	d obj.%Close()
	k obj
	
	Tstart
	
	s sc=##class(CT.WDT.CDSS.AssBaseFieldItem).%DeleteId(id)
	if $$$ISOK(sc)
	{
		d eobj.%Close()
		Tcommit
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.AssBaseFieldItem","CT.WDT.CDSS.AssBaseFieldItem","评估表字段选项表",id,eobj.ItemValue,"D",eobj)
		s result="{success:'true',info:'删除成功！'}"
	}
	else
	{
		Tro
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
    q result
}

/// Creator：Xuwenhu
/// CreatDate: 2022-12-14
/// Description：数据导入方法
/// Table：CT.WDT.CDSS.AssBaseFieldItem
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: w ##class(web.CDSS.Access.AssBaseFieldItem).ImportData()
ClassMethod ImportData() As %String
{
	k ^CT.WDT.CDSS.AssBaseFieldItemI
	
	TS
	s base=0
	for
	{
		s base=$o(^CT.WDT.CDSS.AssBaseD(base))
		q:base=""
		s MKBABFSequence = ""
		for
		{
			s MKBABFSequence = $O(^CT.WDT.CDSS.AssBaseFieldI("SeqIndex",base,MKBABFSequence))
			q:MKBABFSequence=""
			s MKBABFChildSub = 0
			for
			{
				s MKBABFChildSub = $O(^CT.WDT.CDSS.AssBaseFieldI("SeqIndex",base,MKBABFSequence,MKBABFChildSub))
				q:MKBABFChildSub=""
				
				s ABFIParRef=base_"||"_MKBABFChildSub
				s MKBABFConfig = $LG($G(^CT.WDT.CDSS.AssBaseD(base,"ChildField",MKBABFChildSub)),5)
				
				s optionLen=$l(MKBABFConfig,"&%")
				for optionLeni=1:1:optionLen-1
				{
					s optioniAndSore = $p($g(MKBABFConfig),"&%",optionLeni) 
					s optioni = $p($g(optioniAndSore),"[BDP]",1)		//选项
					s optioniSore = $p($g(optioniAndSore),"[BDP]",2)	//分数
					s optionexcu=$p($g(optioniAndSore),"[BDP]",3)		//互斥项
					s optionjump=$p($g(optioniAndSore),"[BDP]",4)		//跳转项
					
					if optioniSore["data:image" s optioni=optioniSore s optioniSore=""
					s obj=##class(CT.WDT.CDSS.AssBaseFieldItem).%New()
					d obj.ABFIParRefSetObjectId(ABFIParRef)
					s obj.ItemValue=optioni
					s obj.ItemScore=optioniSore
					s obj.ItemExclusion=optionexcu
					s obj.ItemJumpOption=optionjump
					s obj.ItemSequence=optionLeni
					s obj.Remarks=""
					s obj.RuleDR=""
					s sc=obj.%Save()
					d obj.%Close()
					if $$$ISOK(sc)
					{
						
					}
					else
					{
						w base,!
					}
				}
				
			}
		}
	}
	q "success"
}

/// Creator：Xuwenhu
/// CreatDate: 2022-12-21
/// Description：查询题目和选项关联规则
/// Table：CT.WDT.CDSS.AssBaseField
/// Input：id
/// Return:json
/// Other: w ##class(web.CDSS.Access.AssBaseFieldItem).GetJsonData("671")
ClassMethod GetJsonData(baseid As %String) As %String
{
	s DataJSON=[]
	s MKBABFSequence = 0
	for
	{
		s MKBABFSequence = $O(^CT.WDT.CDSS.AssBaseFieldI("SeqIndex",baseid,MKBABFSequence))
		q:MKBABFSequence=""
		s MKBABFChildSub = 0
		for
		{
			s MKBABFChildSub = $O(^CT.WDT.CDSS.AssBaseFieldI("SeqIndex",baseid,MKBABFSequence,MKBABFChildSub))
			q:MKBABFChildSub=""
			s MKBABFRowId = baseid_"_"_MKBABFChildSub
			s MKBABFCode = $LG($G(^CT.WDT.CDSS.AssBaseD(baseid,"ChildField",MKBABFChildSub)),2)
			s MKBABFDesc = $LG($G(^CT.WDT.CDSS.AssBaseD(baseid,"ChildField",MKBABFChildSub)),3)					//题目
			s FieldJSON={}
			d FieldJSON.%Set("id",MKBABFRowId)
			d FieldJSON.%Set("Desc",MKBABFDesc)
			d FieldJSON.%Set("RuleDR","")
			d FieldJSON.%Set("RuleDesc","")
			d FieldJSON.%Set("state","open")
			s OptionArr=[]
			s ItemSequence=0
			for
			{
				s ItemSequence = $O(^CT.WDT.CDSS.AssBaseFieldItemI("SeqIndex",baseid,MKBABFChildSub,ItemSequence))
				q:ItemSequence=""
				s ABFIChildSub = 0
				for
				{
					s ABFIChildSub = $O(^CT.WDT.CDSS.AssBaseFieldItemI("SeqIndex",baseid,MKBABFChildSub,ItemSequence,ABFIChildSub))
					q:ABFIChildSub=""
					s ABFIRowId = MKBABFRowId_"_"_ABFIChildSub
					s ItemValue = $LG($G(^CT.WDT.CDSS.AssBaseD(baseid,"ChildField",MKBABFChildSub,"ChildItem",ABFIChildSub)),2)
					continue:ItemValue["data:image"
					s ItemScore = $LG($G(^CT.WDT.CDSS.AssBaseD(baseid,"ChildField",MKBABFChildSub,"ChildItem",ABFIChildSub)),3)		//选项
					s ItemExclusion = $LG($G(^CT.WDT.CDSS.AssBaseD(baseid,"ChildField",MKBABFChildSub,"ChildItem",ABFIChildSub)),4)		//互斥
					s ItemJumpOption = $LG($G(^CT.WDT.CDSS.AssBaseD(baseid,"ChildField",MKBABFChildSub,"ChildItem",ABFIChildSub)),5)	//跳转
					//s ItemSequence = $LG($G(^CT.WDT.CDSS.AssBaseD(baseid,"ChildField",MKBABFChildSub,"ChildItem",ABFIChildSub)),6)	
					s RuleDR =	$LG($G(^CT.WDT.CDSS.AssBaseD(baseid,"ChildField",MKBABFChildSub,"ChildItem",ABFIChildSub)),7)			//规则id
					s Remarks = $LG($G(^CT.WDT.CDSS.AssBaseD(baseid,"ChildField",MKBABFChildSub,"ChildItem",ABFIChildSub)),8)			//备注
					s RuleDesc=""
					s:RuleDR'="" RuleDesc=$LG($G(^CT.WDT.CDSS.RuleDictD(RuleDR)),3)		//规则描述 
					s OptionChild={}
					d OptionChild.%Set("id",ABFIRowId)
					d OptionChild.%Set("Desc",ItemValue)
					d OptionChild.%Set("RuleDR",RuleDR)
					d OptionChild.%Set("RuleDesc",RuleDesc)	
					d OptionChild.%Set("state","open")
					d OptionArr.%Push(OptionChild)
				}
			}
			d FieldJSON.%Set("children",OptionArr)
			d DataJSON.%Push(FieldJSON)
		}
	}
	q DataJSON.%ToJSON()
}

/// Creator：Xuwenhu
/// CreatDate: 2022-12-21
/// Description：打开数据
/// Table：CT.WDT.CDSS.AssBaseField
/// Input：id
/// Return:json
/// Other: w ##class(web.CDSS.Access.AssBaseFieldItem).OpenData("671")
ClassMethod OpenData(id As %String) As %String
{
	s str=""
	s id=$replace(id,"_","||")
	s obj=##class(CT.WDT.CDSS.AssBaseFieldItem).%OpenId(id)
	
	s bobj = ##class(web.CDSSEntity.Access.AssBaseFieldItem).%New() 
	s bobj.ItemValue = obj.ItemValue
	s:obj.RuleDR'="" bobj.RuleDR = obj.RuleDR.%Id()  
	s:obj.RuleDR="" bobj.RuleDR=""
	d obj.%Close()	
	k obj	
	
	s str = bobj.JsonS()	
	q str
}

/// Creator：Xuwenhu
/// CreatDate: 2022-12-21
/// Description：打开数据
/// Table：CT.WDT.CDSS.AssBaseField
/// Input：id
/// Return:json
/// Other: w ##class(web.CDSS.Access.AssBaseFieldItem).SaveRuleData("876_5620_41764","13719")
ClassMethod SaveRuleData(id As %String, Ruledr As %String) As %String
{
	s result=""
	s id=$replace(id,"_","||")
	s obj=##class(CT.WDT.CDSS.AssBaseFieldItem).%OpenId(id)
	d obj.RuleDRSetObjectId(Ruledr)
	
	s sc=obj.%Save()
	d obj.%Close()
	s id=""
	If $$$ISOK(sc)
	{
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}"    
	}
	else
	{
		s result = "{success:'false',errorinfo:'保存失败!"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
	}
	q result
}

/// Creator：Xuwenhu
/// CreatDate: 2022-12-21
/// Description：打开数据
/// Table：CT.WDT.CDSS.AssBaseField
/// Input：id
/// Return:json
/// Other: w ##class(web.CDSS.Access.AssBaseFieldItem).DeleteRuleData("876_5620_41764")
ClassMethod DeleteRuleData(id As %String) As %String
{
	s result=""
	s id=$replace(id,"_","||")
	s obj=##class(CT.WDT.CDSS.AssBaseFieldItem).%OpenId(id)
	d obj.RuleDRSetObjectId("")
	
	s sc=obj.%Save()
	d obj.%Close()
	s id=""
	If $$$ISOK(sc)
	{
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}"    
	}
	else
	{
		s result = "{success:'false',errorinfo:'保存失败!"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
	}
	q result
}

/// Creator：Xuwenhu
/// CreatDate: 2022-12-21
/// Description： 根据评估表名和题目选项顺序号获取选项id
/// Table：CT.WDT.CDSS.AssBaseField
/// Input：AssName-评估表名称，Str-Q1T1
/// Return:json
/// Other: w ##class(web.CDSS.Access.AssBaseFieldItem).GetItemId("欧洲心脏手术风险评分系统（European System for Cardiac Operative Risk Evaluation,EuroSCORE）","Q1T1")
/// w ##class(web.CDSS.Access.AssBaseFieldItem).GetItemId("急性肺炎早期评估得分（aPNea)","Q1T1")
ClassMethod GetItemId(AssName As %String, Str As %String) As %String
{
	s Result=""
	q:AssName="" 
	s AssId=$o(^CT.WDT.CDSS.AssBaseI("DescIndex"," "_$ZCONVERT(AssName,"U"),0))
	if AssId=""
	{
		s Result="-1^未找到评估表"
	}
	else
	{
		s Qseq=$p(Str,"T",1),Qseq=$p(Qseq,"Q",2)
		s Tseq=$p(Str,"T",2)
		s FieldId=$o(^CT.WDT.CDSS.AssBaseFieldI("SeqIndex",AssId,Qseq,0))
		if FieldId=""
		{
			s Result="-1^未找到题目"
		}
		else
		{
			s ItemId=$o(^CT.WDT.CDSS.AssBaseFieldItemI("SeqIndex",AssId,FieldId,Tseq,0))
			if ItemId=""
			{
				s Result="-1^未找到选项"	
			}
			else
			{
				s Result=AssId_"||"_FieldId_"||"_ItemId	
			}
		} 
	}
	q Result
}

/// Creator：Xuwenhu
/// CreatDate: 2022-12-21
/// Description： 新增规则
/// Table：CT.WDT.CDSS.AssBaseField
/// Input：id
/// Return:json
/// Other: w ##class(web.CDSS.Access.AssBaseFieldItem).AddNewRule("886_5708_21090")
/// w ##class(web.CDSS.Access.AssBaseFieldItem).AddNewRule()
ClassMethod AddNewRule(id As %String) As %String
{
	s id=$replace(id,"_","||")
	s BaseId=$p(id,"||",1)		//评估表id
	s AssDesc=$lg($g(^CT.WDT.CDSS.AssBaseD(BaseId)),3)		//评估表名称
	s Qseq=$LG($G(^CT.WDT.CDSS.AssBaseD(BaseId,"ChildField",$p(id,"||",2))),6)
	s Tseq=$LG($G(^CT.WDT.CDSS.AssBaseD(BaseId,"ChildField",$p(id,"||",2),"ChildItem",$p(id,"||",3))),6)
	
	s eobj=##class(web.CDSSEntity.CMKB.RuleDict).%New()
	s eobj.RuleDesc=AssDesc_"Q"_Qseq_"T"_Tseq
	s eobj.RuleStatus="编辑中"
	s eobj.RuleType=18
	
	s re=##class(web.CDSS.CMKB.RuleDict).SaveData(eobj)
	if re["success"
	{
		s RuleId=$p($p(re,"id:'",2),"'",1)
		s itemobj=##class(CT.WDT.CDSS.AssBaseFieldItem).%OpenId(id)
		d itemobj.RuleDRSetObjectId(RuleId)
		d itemobj.%Save()
		d itemobj.%Close()
	}
	else
	{
		s RuleId=""
	}
	q RuleId
}

}
