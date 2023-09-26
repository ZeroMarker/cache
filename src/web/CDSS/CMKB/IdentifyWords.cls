/// Description：识别词字典表
/// Table：CT.WDT.CDSS.IdentifyWords
Class web.CDSS.CMKB.IdentifyWords Extends %RegisteredObject
{

/// Creator：丁亚男
/// CreatDate: 2021-01-11
/// Description：查询识别词字典表
/// Table：CT.WDT.CDSS.IdentifyWords
/// Input：desc 
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.IdentifyWords","GetList","","","","","","","","","")
Query GetList(rowid, desc, WType, SState, WState, UUser, AUser, SUpdateDate, EUpdateDate, Quote) As %Query(ROWSPEC = "WordsRowId,WordsCode,WordsDesc,WordsType,WordsState,UpdateUser,UpdateDate,AuditUser,AuditDate,SplitState,Remarks,QuoteFlag")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, desc, WType, SState, WState, UUser, AUser, SUpdateDate, EUpdateDate, Quote) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 if (rowid'="") //根据rowid返回该条记录
 {
	s WordsRowId=rowid
	s WordsCode=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),2)
	s WordsDesc=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),3)
	s WordsType=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),4)
	s WordsState=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),5)
	s UpdateUser=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),6)
	s UpdateDate=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),7)
	s AuditUser=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),8)
	s AuditDate=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),9)
	s SplitState=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),10)
	s Remarks=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),11)
	s QuoteFlag=""
	//s Flag=##class(web.CDSS.CMKB.IdentifyWords).GetQuoteInfo(WordsRowId)
	s Flag=..GetQuoteFlag(WordsRowId)
	if (Flag=0){
		s QuoteFlag="否"
	}else{
		s QuoteFlag="是"
	}
	
	d OutputRow
 }
 else
 {
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写 
	s:UUser'="" UUser=$ZCONVERT(UUser,"U")
	s:AUser'="" AUser=$ZCONVERT(AUser,"U")
	if (desc'="")
	{
		s WordsRowId=""
		for
		{ 
			s WordsRowId=$o(^CT.WDT.CDSS.IdentifyWordsI("DescIndex"," "_$ZCONVERT(desc,"U"),WordsRowId)) q:WordsRowId="" 
			s WordsCode=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),2)
			s WordsDesc=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),3)
			s WordsType=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),4)
			s WordsState=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),5)
			s UpdateUser=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),6)
			s UpdateDate=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),7)
			s AuditUser=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),8)
			s AuditDate=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),9)
			s SplitState=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),10)
			s Remarks=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),11)
			s QuoteFlag=""
			//s Flag=##class(web.CDSS.CMKB.IdentifyWords).GetQuoteInfo(WordsRowId)
			s Flag=..GetQuoteFlag(WordsRowId)
			continue:(Quote'="")&&(Quote'=Flag)
			if (Flag=0){
				s QuoteFlag="否"
			}else{
				s QuoteFlag="是"
			}
			
			s UpdateDateUDate="", UpdateDateUTime=""
			if (UpdateDate'="")
			{ 
				s UpdateDateU=$ZDTH(UpdateDate,3)
				s UpdateDateUDate=$p(UpdateDateU,",",1)
				s UpdateDateUTime=$p(UpdateDateU,",",2)
			}	
			
			s SUpdateDateFlag=1
			if (SUpdateDate'="")
			{
				s SUpdateDateU=$ZDTH(SUpdateDate,3)
				s SUpdateDateUDate=$p(SUpdateDateU,",",1)
				s SUpdateDateUTime=$p(SUpdateDateU,",",2)
				if (SUpdateDateUDate>UpdateDateUDate)||((SUpdateDateUDate=UpdateDateUDate)&(SUpdateDateUTime>UpdateDateUTime))
				{
					s SUpdateDateFlag=0	
				}
			}
			s EUpdateDateFlag=1
			if (EUpdateDate'="")
			{
				s EUpdateDateU=$ZDTH(EUpdateDate,3)
				s EUpdateDateUDate=$p(EUpdateDateU,",",1)
				s EUpdateDateUTime=$p(EUpdateDateU,",",2)
				if (EUpdateDateUDate<UpdateDateUDate)||((EUpdateDateUDate=UpdateDateUDate)&(EUpdateDateUTime<UpdateDateUTime))
				{
					s EUpdateDateFlag=0	
				}
			}
			
			if ($ZCONVERT(WordsType,"U")[WType)&&($ZCONVERT(SplitState,"U")[SState)&&($ZCONVERT(WordsState,"U")[WState)&&($ZCONVERT(AuditUser,"U")[AUser)
			&&($ZCONVERT(UpdateUser,"U")[UUser)&&(SUpdateDateFlag=1)&&(EUpdateDateFlag=1)	//过滤条件
			{
				d OutputRow
			}
		}
		
	}
	s date=""
	for{
		s date=$o(^CT.WDT.CDSS.IdentifyWordsI("DateIndex",date),-1) q:date=""
		s WordsRowId=""
		for
		{ 
			s WordsRowId=$o(^CT.WDT.CDSS.IdentifyWordsI("DateIndex",date,WordsRowId),-1) q:WordsRowId="" 
			s WordsCode=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),2)
			s WordsDesc=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),3)
			continue:$ZCONVERT(WordsDesc,"U")=desc
			s WordsType=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),4)
			s WordsState=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),5)
			s UpdateUser=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),6)
			s UpdateDate=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),7)
			s AuditUser=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),8)
			s AuditDate=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),9)
			s SplitState=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),10)
			s Remarks=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),11)
			s QuoteFlag=""
			//s Flag=##class(web.CDSS.CMKB.IdentifyWords).GetQuoteInfo(WordsRowId)
			s Flag=..GetQuoteFlag(WordsRowId)
			continue:(Quote'="")&&(Quote'=Flag)
			if (Flag=0){
				s QuoteFlag="否"
			}else{
				s QuoteFlag="是"
			}
			s UpdateDateUDate="", UpdateDateUTime=""
			if (UpdateDate'="")
			{ 
				s UpdateDateU=$ZDTH(UpdateDate,3)
				s UpdateDateUDate=$p(UpdateDateU,",",1)
				s UpdateDateUTime=$p(UpdateDateU,",",2)
			}	
			
			s SUpdateDateFlag=1
			if (SUpdateDate'="")
			{
				s SUpdateDateU=$ZDTH(SUpdateDate,3)
				s SUpdateDateUDate=$p(SUpdateDateU,",",1)
				s SUpdateDateUTime=$p(SUpdateDateU,",",2)
				if (SUpdateDateUDate>UpdateDateUDate)||((SUpdateDateUDate=UpdateDateUDate)&(SUpdateDateUTime>UpdateDateUTime))
				{
					s SUpdateDateFlag=0	
				}
			}
			s EUpdateDateFlag=1
			if (EUpdateDate'="")
			{
				s EUpdateDateU=$ZDTH(EUpdateDate,3)
				s EUpdateDateUDate=$p(EUpdateDateU,",",1)
				s EUpdateDateUTime=$p(EUpdateDateU,",",2)
				if (EUpdateDateUDate<UpdateDateUDate)||((EUpdateDateUDate=UpdateDateUDate)&(EUpdateDateUTime<UpdateDateUTime))
				{
					s EUpdateDateFlag=0	
				}
			}
			
			if (($ZCONVERT(WordsDesc,"U")[desc))&&($ZCONVERT(SplitState,"U")[SState)&&($ZCONVERT(WordsState,"U")[WState)&&($ZCONVERT(AuditUser,"U")[AUser)
			&&($ZCONVERT(UpdateUser,"U")[UUser)&&(SUpdateDateFlag=1)&&(EUpdateDateFlag=1)	//过滤条件
			{
				
				if (WType'=""){
					if (WordsType=WType){
						d OutputRow
					}
				} else {
					d OutputRow
				}
			}
		}
	}
}
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(WordsRowId,WordsCode,WordsDesc,WordsType,WordsState,UpdateUser,UpdateDate,AuditUser,AuditDate,SplitState,Remarks,QuoteFlag)
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

/// Function:用于实现数据校验功能的方法
/// Creator:基础数据平台组 丁亚男
/// CreateDate:2021-01-11    
/// w ##class(web.CDSS.CMKB.IdentifyWords).FormValidate("","","")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, desc As %String, type As %String) As %String
{
	if type="" s type=-100000000000000
	s flag="",flagd=""
	s:desc'="" flagd=$d(^CT.WDT.CDSS.IdentifyWordsI("DescTypeIndex",desc,type))
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagd>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idd=""
		s:desc'="" idd=$o(^CT.WDT.CDSS.IdentifyWordsI("DescTypeIndex",desc,type,0))
		
		if ((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志

	}
	q flag
}

/// Creator：丁亚男
/// CreatDate: 2021-01-11
/// Description:代码自动生成  SBC00001 代码最大值加1
/// Other: w ##class(web.CDSS.CMKB.IdentifyWords).GetLastCode()
ClassMethod GetLastCode() As %String
{
  	s CodeLen=10   //代码长度
  	s StartCode="SBC"  //代码起始字符
  	s code=""
	s StartCodeLen=$Length(StartCode)
	s WordsRowId="", preCode=""    //寻找符合识别词的最大的代码
	for {
		s WordsRowId=$o(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId),-1) q:WordsRowId=""
		s WordsCode=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),2)
		if ($e(WordsCode,1,StartCodeLen)=StartCode)
		{
			s preCode=WordsCode
			q 
		}	
	}
	if (preCode="")   //如果没有符合识别词的代码，则生成第一个
	{
		s zeroLen=CodeLen-StartCodeLen
		s zeroStr=""
		s count=0
		for
		{
			s count=count+1
			q:count>zeroLen
			s zeroStr=zeroStr_"0"
		}
		s preCode=StartCode_zeroStr
	}
	s CodeNum=$p(preCode,StartCode,2)+1     //ZD后的数字+1
	s CodeNumLen=$Length(CodeNum)     //数字的长度
	s code=$e(preCode,1,CodeLen-CodeNumLen)_CodeNum  //组合

	q code
}

/// Creator：丁亚男
/// CreatDate: 2020-06-19
/// Description：数据保存方法
/// Table：CT.WDT.CDSS.IdentifyWords
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.IdentifyWords).SaveEntity()
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.IdentifyWords) As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{ 
		s eobj.WordsDesc=$Zstrip(eobj.WordsDesc,"<>W")
		s flag=..FormValidate(eobj.WordsRowId,eobj.WordsDesc,eobj.WordsType)
		if (flag=1)	 //校验重复
		{
			q "{success:'false',errorinfo:'该记录已存在！'}"
		}
		if (eobj.WordsRowId="")  //如果RowId未赋值则增加
		{ 
			s obj=##class(CT.WDT.CDSS.IdentifyWords).%New() 
			s eobj.WordsCode=..GetLastCode()
		}
		else   //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.IdentifyWords).%OpenId(eobj.WordsRowId)
			s bobj = ##class(web.CDSSEntity.CMKB.IdentifyWords).%New() 
			s bobj.WordsCode = obj.WordsCode  
			s bobj.WordsDesc = obj.WordsDesc  
			s bobj.WordsType = obj.WordsType 
			s bobj.WordsState = obj.WordsState 
			s bobj.UpdateUser = obj.UpdateUser 
			s bobj.UpdateDate = obj.UpdateDate
			s bobj.AuditUser = obj.AuditUser
			s bobj.AuditDate = obj.AuditDate
			s bobj.SplitState = obj.SplitState 
			s bobj.Remarks = obj.Remarks
			s eobj.WordsCode=obj.WordsCode
			s eobj.WordsState = obj.WordsState
			s eobj.SplitState = obj.SplitState
			s eobj.AuditUser = obj.AuditUser
			s eobj.AuditDate = obj.AuditDate
			
		}
		s eobj.UpdateUser=$g(%session.Data("LOGON.USERNAME"))
		s eobj.UpdateDate=$zdt($h,3)
		s obj.WordsCode = eobj.WordsCode  
		s obj.WordsDesc = eobj.WordsDesc 
		s obj.WordsType = eobj.WordsType 
		s obj.WordsState = eobj.WordsState
		s obj.UpdateUser =eobj.UpdateUser 
		s obj.UpdateDate = eobj.UpdateDate
		s obj.AuditUser = eobj.AuditUser
		s obj.AuditDate = eobj.AuditDate
		s obj.SplitState = eobj.SplitState
		s obj.Remarks = eobj.Remarks
		
		
			
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" 
			//保存日志
			d:eobj.WordsRowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.IdentifyWords","CT.WDT.CDSS.IdentifyWords","识别词字典表",id,eobj.WordsDesc,"A",eobj)
			d:eobj.WordsRowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.IdentifyWords","CT.WDT.CDSS.IdentifyWords","识别词字典表",eobj.WordsRowId,eobj.WordsDesc,"U",eobj,bobj)
			//同步修改规则用到的识别词名称
			if (eobj.WordsRowId'="")&&(eobj.WordsDesc'=bobj.WordsDesc)
			{
				d ##class(web.CDSS.CMKB.IdentifyWords).SynchroIdentifyWord(eobj.WordsRowId,eobj.WordsDesc,bobj.WordsDesc)
			}
			
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("识别词字典表","web.CDSS.CMKB.IdentifyWords","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"  
	} 
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("识别词字典表","web.CDSS.CMKB.IdentifyWords","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator:丁亚男
/// CreatDate:2021-11-02
/// Input：ID:识别词ID NewIdentifyWord识别词修改后的名称 OldIdentifyWord识别词修改前的名称
/// Description:识别词名称修改，规则同步修改
/// Return:count 修改成功了几处，修改失败几处
/// w ##class(web.CDSS.CMKB.IdentifyWords).SynchroIdentifyWord("83079","胃溃疡1","胃溃疡")
ClassMethod SynchroIdentifyWord(ID As %String, NewIdentifyWord As %String, OldIdentifyWord As %String) As %String
{
	s count=0,fcount=0
	s WordsType=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(ID)),4)
	s ItemCategory="西医"
	if (WordsType["中医")
	{
		s ItemCategory="中医"
	}
	
	s:WordsType="D" WordsType="诊断条件"
	s:WordsType="I" WordsType="识别词"
	s:WordsType["识别条件" WordsType="识别词"
	s:WordsType["诊断条件" WordsType="诊断条件"
	
	if ($d(^CT.WDT.CDSS.RuleConditionI("ValueIndex",OldIdentifyWord)))&(WordsType'="")
	{
		s ConditionRowId = ""
		for
		{
			s ConditionRowId = $o(^CT.WDT.CDSS.RuleConditionI("ValueIndex",OldIdentifyWord,ConditionRowId)) q:ConditionRowId=""
			s NodeDR  = $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowId)),2)
			s ConditionItemCategory  = $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowId)),10) //项目类别（中医/西医）
			s:ConditionItemCategory="" ConditionItemCategory="西医"
			if (ConditionItemCategory=ItemCategory)
			{
				s RuleDR="",RuleDesc="",RuleType="",ChartTypeDesc="",NodeType="",NodeTypeDesc=""
				s:NodeDR'="" RuleDR=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),2)
				s:NodeDR'="" NodeType=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),5)
				s:NodeType'="" NodeTypeDesc=$lg($g(^CT.WDT.CDSS.NodeTypeD(NodeType)),3)
				//节点类型为 主要条件-识别词 否定条件-识别词  诊断条件
				if NodeTypeDesc[WordsType
				{
					s obj=##class(CT.WDT.CDSS.RuleCondition).%OpenId(ConditionRowId)
					s obj.ConditionItemValue = NewIdentifyWord
					s sc=obj.%Save()
					d obj.%Close()
					If $$$ISOK(sc)
					{
						s count=count+1		
					}
					else
					{
						s fcount=fcount+1		
					}
				}
			}
		}
	}
   
    q "成功修改"_count_"处！失败"_fcount_"处！"
}

/// Creator:丁亚男
/// CreatDate:2021-1-14
/// Input:RowId 识别词ID Status 状态
/// Return:
/// Other:w ##class(web.CDSS.CMKB.IdentifyWords).ChangeStatus(132048,"编辑")
ClassMethod ChangeStatus(RowId, Opreation)
{
	s result="{success:'true'}"
	s eobj = ##class(web.CDSSEntity.CMKB.IdentifyWords).%New()
	if (Opreation="编辑") s eobj.WordsState="编辑中"
	if (Opreation="提交") s eobj.WordsState="待审核"
	if Opreation="上线" s eobj.WordsState="已上线"
	if Opreation="不通过" s eobj.WordsState="审核不通过"
	if Opreation="下线" s eobj.WordsState="已下线"
	//if Opreation="通过" s eobj.WordsState="审核通过"
	//点击通过时，遍历识别词每个节点（开始、结束除外）是否有内容，没有内容则不能通过
	if (Opreation="通过") 
	{
		//节点下是否有内容 1有 0无
		s ContentFlag=1
		if ($d(^CT.WDT.CDSS.WordsNodeI("WordsDRIndex",RowId)))
	    {
		    s NodeDR=0
		    for
		    {
			    s NodeDR=$O(^CT.WDT.CDSS.WordsNodeI("WordsDRIndex",RowId,NodeDR)) q:(NodeDR="")||(ContentFlag=0)
			    
			    s NodeType=$lg($g(^CT.WDT.CDSS.WordsNodeD(NodeDR)),5)
				s NodeTypeDesc=""
				s:NodeType'="" NodeTypeDesc=$lg($g(^CT.WDT.CDSS.NodeTypeD(NodeType)),3)
				continue:(NodeTypeDesc="开始")||(NodeTypeDesc="结束")
				//节点下是否有内容
				if ('$d(^CT.WDT.CDSS.WordsConditionI("NodeDRIndex",NodeDR)))
			    {
				  s ContentFlag=0  
			    }
				
			}
	    }
	    if (ContentFlag=1)
	    {
			s eobj.WordsState="审核通过"
	    }
	    else
	    {
		   s eobj.WordsState="审核不通过" 
		}
	}
	
	if Opreation="驳回" s eobj.WordsState="编辑中"
	 	
 	s obj=##class(CT.WDT.CDSS.IdentifyWords).%OpenId(RowId)
 	s bobj = ##class(web.CDSSEntity.CMKB.IdentifyWords).%New()
	s bobj.WordsState=obj.WordsState
	s bobj.UpdateDate=obj.UpdateDate
	s bobj.AuditDate=obj.AuditDate
	s bobj.UpdateUser=obj.UpdateUser
	s bobj.AuditUser=obj.AuditUser
	s UpdateUserName=""
 	if ($d(%session)){ s UpdateUserName=%session.Get("LOGON.USERNAME")}         //当前用户

 	if ((Opreation="提交")||(Opreation="编辑")){
	 	s obj.WordsState=eobj.WordsState
	 	s obj.UpdateUser=UpdateUserName
 		s obj.UpdateDate=$zdt($h,3)
 		
	} elseif ((Opreation="审核")||(Opreation="不通过")||(Opreation="通过")||(Opreation="驳回")){
 		s obj.AuditUser=UpdateUserName
 		s obj.AuditDate=$zdt($h,3)
	}

	if ((Opreation'="审核") && (Opreation'="编辑")){
 		s obj.WordsState=eobj.WordsState
	}
	
 	if (eobj.WordsState="待审核"){
	 s eobj.SplitState = 0
	 s obj.SplitState = 0
	}
 	Ts
 	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{
		Tc
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
		if (Opreation="上线")||(Opreation="审核通过")
		{
			s rtn= ##class(web.CDSS.CMKB.RuleIndex).CreateIdentifyWIndexById(id,1)
			if (rtn["true")
			{
				s info="索引同步成功！"
			}
			else
			{
				s info="索引同步失败！"
			}
			s result = "{success:'true',id:'"_id_"',info:'"_info_"'}" //返回RowId
		}
		
		if (Opreation="下线")
		{
			s rtn=##class(web.CDSS.CMKB.RuleIndex).DeleteIdentifyWIndexById(id)
			if (rtn["true")
			{
				s info="索引同步成功！"
			}
			else
			{
				s info="索引同步失败！"
			}
			s result = "{success:'true',id:'"_id_"',info:'"_info_"'}" //返回RowId
		}
		//保存日志 描述拼接操作，在日志中读取显示
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.IdentifyWords","CT.WDT.CDSS.IdentifyWords","识别词管理",RowId,obj.WordsDesc_"&&"_eobj.WordsState,"U",eobj,bobj)  
		//d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.IdentifyWords","CT.WDT.CDSS.IdentifyWords","识别词管理",RowId,obj.WordsDesc_"&&"_Opreation,"U",eobj,bobj)  

		
	}
	else
	{
		Trollback
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("识别词管理","web.CDSS.CMKB.IdentifyWords","ChangeStatus",eobj)
   		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

/// Creator:石萧伟
/// CreatDate:2021-04-25
/// Input:RowId 识别词ID
/// Return:
/// Other:w ##class(web.CDSS.CMKB.IdentifyWords).ChangeStatus(182,"上线")
ClassMethod ChangeAuditUser(RowId)
{
	s result="{success:'true'}"
	s eobj = ##class(web.CDSSEntity.CMKB.IdentifyWords).%New()
 	s obj=##class(CT.WDT.CDSS.IdentifyWords).%OpenId(RowId)
 	s bobj = ##class(web.CDSSEntity.CMKB.IdentifyWords).%New()
 	s bobj.AuditDate=obj.AuditDate
 	s bobj.AuditUser=obj.AuditUser 

 	s obj.AuditDate=$zdt($h,3)
 	s obj.AuditUser=$g(%session.Data("LOGON.USERNAME"))
 	Ts
 	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{
		Tc
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
		//保存日志 描述拼接操作，在日志中读取显示
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.IdentifyWords","CT.WDT.CDSS.IdentifyWords","识别词管理",RowId,obj.WordsDesc_"&&"_"审核","U",eobj,bobj)  
		
	}
	else
	{
		Trollback
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("识别词管理","web.CDSS.CMKB.IdentifyWords","ChangeStatus",eobj)
   		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

/// Creator：丁亚男
/// CreatDate: 2021-01-11
/// Description：数据打开方法
/// Table：CT.WDT.CDSS.IdentifyWords
/// Input：RowId
/// Return:Json
/// Other: w ##class(web.CDSS.CMKB.IdentifyWords).OpenData("3")
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s obj=##class(CT.WDT.CDSS.IdentifyWords).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.IdentifyWords).%New() 
	s bobj.WordsCode = obj.WordsCode  
	s bobj.WordsDesc = obj.WordsDesc  
	s bobj.WordsType = obj.WordsType 
	s bobj.WordsState = obj.WordsState 
	s bobj.UpdateUser = obj.UpdateUser 
	s bobj.UpdateDate = obj.UpdateDate
	s bobj.AuditUser = obj.AuditUser
	s bobj.AuditDate = obj.AuditDate
	s bobj.SplitState = obj.SplitState 
	s bobj.Remarks = obj.Remarks
	d obj.%Close()	
	k obj	
	
	s str = bobj.JsonS()	
	q str
}

/// Creator:丁亚男
/// CreatDate:2020-08-19
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// 目前没有引用手术的表、病因等用到但是保存的是手术名称，不影响
/// w ##class(web.CDSS.CMKB.IdentifyWords).GetRefFlag1("66532")
ClassMethod GetRefFlag1(id As %String) As %String
{
    s return="",myInfo=""
    s flag=0
    s WordsDesc=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(id)),3)
    s WordsType=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(id)),4)
    
    if ($d(^CT.WDT.CDSS.RuleConditionI("ValueIndex",WordsDesc)))
    {
	    s ConditionRowId = ""
		for
		{
			s ConditionRowId = $o(^CT.WDT.CDSS.RuleConditionI("ValueIndex",WordsDesc,ConditionRowId)) q:ConditionRowId=""
			s NodeDR  = $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowId)),2)
			s RuleDR="",RuleDesc="",RuleType="",ChartTypeDesc="",NodeType="",NodeTypeDesc=""
			s:NodeDR'="" RuleDR=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),2)
			s:NodeDR'="" NodeType=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),5)
			s:NodeType'="" NodeTypeDesc=$lg($g(^CT.WDT.CDSS.NodeTypeD(NodeType)),3)
			
			s:RuleDR'="" RuleDesc=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleDR)),3)
			s:RuleDR'="" RuleType=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleDR)),6)
			s:RuleType'="" ChartTypeDesc=$lg($g(^CT.WDT.CDSS.ChartTypeD(RuleType)),3)
			
			
            if (WordsType="识别条件")&((NodeTypeDesc="主要条件-识别词")||(NodeTypeDesc="否定条件-识别词")||(NodeTypeDesc="通过条件"))
            {
            	s flag=1
            	s myInfo=myInfo_"<"_ChartTypeDesc_":"_RuleDesc_">"
            }
	        if (WordsType="诊断条件")&((NodeTypeDesc="诊断条件")||(NodeTypeDesc="否定条件-诊断"))
            {
            	s flag=1
            	s myInfo=myInfo_"<"_ChartTypeDesc_":"_RuleDesc_">"
            }
	    }
    }
    //i myInfo="" s return="0^未被引用可删除!"
    //else  s return="1^在"_myInfo_"表里被引用,不能删除!"
    if (myInfo=""){
		s return="0^未被引用可删除!"
	}else{
		s myInfoLen=$l(myInfo,">")
		if (myInfoLen>25){				//因前台展示问题，当引用信息过多时，截取部分数据展示
			s myInfo=$p(myInfo,">",1,25)
			s myInfo=myInfo_">"
			s return="1^在"_myInfo_"等表里被引用,不能删除!"
		} else {
			s return="1^在"_myInfo_"表里被引用,不能删除!"
		}
	}  
    q return
}

/// Creator:丁亚男
/// CreatDate:2021-01-11
/// Description:数据删除方法
/// Table: CT.WDT.CDSS.IdentifyWords
/// Input: id 
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.IdentifyWords).DeleteData("1")
ClassMethod DeleteData(id As %String)
{
	s result=""
	s re=##class(web.CDSS.CMKB.IdentifyWords).GetRefFlag1(id)
    s RefFlag=$p(re,"^",1)  
    if (RefFlag'=0){
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    }
    else
    {
	
		Ts
		s obj=##class(CT.WDT.CDSS.IdentifyWords).%OpenId(id)
		s bobj = ##class(web.CDSSEntity.CMKB.IdentifyWords).%New() 
		s bobj.WordsCode = obj.WordsCode  
		s bobj.WordsDesc = obj.WordsDesc  
		s bobj.WordsType = obj.WordsType 
		s bobj.WordsState = obj.WordsState 
		s bobj.UpdateUser = obj.UpdateUser 
		s bobj.UpdateDate = obj.UpdateDate
		s bobj.AuditUser = obj.AuditUser
		s bobj.AuditDate = obj.AuditDate
		s bobj.SplitState = obj.SplitState 
		s bobj.Remarks = obj.Remarks
		//删除节点
		s NodeRowId=0,resultstr=""
		for 
		{
			s NodeRowId = $o(^CT.WDT.CDSS.WordsNodeI("WordsDRIndex",id,NodeRowId)) q:NodeRowId=""
			s Noderesult=##class(web.CDSS.CMKB.WordsNode).DeleteData(NodeRowId)  //删除节点及节点连线
			s:resultstr'="" resultstr=resultstr_","_Noderesult
			s:resultstr="" resultstr=Noderesult
		}
		//删除流程图表
		s ChartRowId=0,resultstr=""
		for 
		{
			s ChartRowId = $o(^CT.WDT.CDSS.WordsChartI("WordsDRIndex",id,ChartRowId)) q:ChartRowId=""
			s Chartresult=##class(web.CDSS.CMKB.WordsChart).DeleteData(ChartRowId)  //删除流程图表
			s:resultstr'="" resultstr=resultstr_","_Chartresult
			s:resultstr="" resultstr=Chartresult
		}
			
		s sc=##class(CT.WDT.CDSS.IdentifyWords).%DeleteId(id)
		if $$$ISOK(sc)
		{
			Tc
			s result = "{success:'true',info:'删除成功！'}"	
			//保存日志
			d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.IdentifyWords","CT.WDT.CDSS.IdentifyWords","识别词字典表",id,bobj.WordsDesc,"D",bobj)
			d bobj.%Close()
		}
		else
		{
			Tro
			s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("识别词字典表","web.CDSS.CMKB.IdentifyWords","DeleteData",bobj)
	       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
    }
	q result
}

/// Creator：丁亚男
/// CreatDate: 2020-06-03
/// Description：查询 识别词
/// Table：CT.WDT.CDSS.IdentifyWords
/// Input：rowid, desc
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.IdentifyWords","GetDataForCmb1","","","","诊断条件","")
Query GetDataForCmb1(rowid As %String, desc As %String, q As %String, type As %String = "", medicineType As %String = "") As %Query(ROWSPEC = "WordsRowId:%String,WordsDesc:%String,WordsType,WordsDR")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String, q As %String, type As %String = "", medicineType As %String = "") As %Status
{
	
	s repid=$I(^CacheTemp)
	s ind=1
	if (rowid'="") //根据rowid返回该条记录
	{
		s WordsRowId=rowid
		s WordsDesc=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),3)
		d OutputRowCmb
	}
	else
	{
		s:q'="" desc=q	
		//s:q'="" desc=$ZCONVERT(q,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		
		k ^TempDataHandle($ZNAME,repid,$JOB,"Short")
		
  		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.IdentifyWordsD(ID))
			q:ID=""
			s WordsDesc=$lg($g(^CT.WDT.CDSS.IdentifyWordsD(ID)),3)		//名称
			//continue:((desc'="")&&($ZCONVERT(WordsDesc,"U")'[desc))
			s length=$l(WordsDesc)
			s ^TempDataHandle($ZNAME,repid,$JOB,"Short",length,ID)=ID
		}
		s le=0
		s num=0
		for
		{
			s le=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le))
			q:le=""
			s WordsRowId=0
			for
			{
				s WordsRowId=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le,WordsRowId)) q:WordsRowId=""
				s WordsDR=WordsRowId
				s WordsDesc=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),3)
				s WordsType=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),4)
				s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(WordsDesc)  
				if (medicineType="中医") {
					s joinType= medicineType_type
				} else{
					s joinType= type
				}
				s:WordsType'="" WordsType= $ZCONVERT(WordsType,"U")
				if (joinType'=WordsType) continue
				if ((($ZCONVERT(WordsDesc,"U")[desc)||(PINYIN[desc))) {
					s num=num+1
					d OutputRowCmb
				}
				
				q:num=1000
				
			}
	        q:num=1000
		}
		k ^TempDataHandle($ZNAME,repid,$JOB,"Short")
	}
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb
    set Data=$lb(WordsRowId,WordsDesc,WordsType,WordsDR)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
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

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:丁亚男
/// CreatDate:2021-02-04
/// Description:根据识别词ID获取该识别词的状态变化的日志 生成临时global
/// Input: WordsRowId 识别词ID
/// Return: 是否成功 
/// others:w ##class(web.CDSS.CMKB.IdentifyWords).CreateTEMPLogGlobal("182")
ClassMethod CreateTEMPLogGlobal(WordsRowId As %String)
{
	s str="sucess"	
	k ^TEMPWordsLog
	
    //状态发生变化的日志
	s ID="",ClassName="CT.WDT.CDSS.IdentifyWords"
    for
    {
    	s ID=$o(^CF.WDT.CDSS.DataChangeLogI("ObjectReferIndex",ClassName,WordsRowId,ID)) q:ID=""
    	s UpdateUserName=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(ID)),7)
    	s UpdateDate=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(ID)),8)
      	s UpdateTime=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(ID)),9)
      	s ObjectDesc=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(ID)),13)   //新增对象描述
      	if (ObjectDesc["&&")
      	{
          	s Opreation=$p(ObjectDesc,"&&",2)
          	s ^TEMPWordsLog("WordsLog",UpdateDate,UpdateTime)=ID_"^"_UpdateUserName_"^"_Opreation
        }
     	else
     	{
      		s ^TEMPWordsLog("WordsLog",UpdateDate,UpdateTime)=ID_"^"_UpdateUserName_"^"_"编辑中"
     	}
    }
	q str
}

/// Creator:丁亚男
/// CreatDate:2021-02-04
/// Description:根据识别词ID获取该识别词的状态变化的日志
/// Table: CT.WDT.CDSS.IdentifyWords、CF.WDT.CDSS.DataChangeLog
/// Input: WordsRowId 识别词ID
/// Return:返回识别词ID获取该识别词的状态变化的日志
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.IdentifyWords","GetWordsLogList","22")
Query GetWordsLogList(WordsRowId As %String) As %Query(ROWSPEC = "LogID,UpdateDate,UpdateTime,UpdateUserName,Opreation")
{
}

ClassMethod GetWordsLogListExecute(ByRef qHandle As %Binary, WordsRowId As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s str="",preUpdateUserName="",preOpreation=""
 	if (WordsRowId'="") s str=##class(web.CDSS.CMKB.IdentifyWords).CreateTEMPLogGlobal(WordsRowId)
 	if (str="sucess")
 	{
	 	s UpdateDateID=""
		for
		{
			s UpdateDateID = $o(^TEMPWordsLog("WordsLog",UpdateDateID),-1) q:UpdateDateID=""
			s UpdateDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(UpdateDateID)
			s UpdateTimeID=""
		    for
		    {
		    	s UpdateTimeID=$o(^TEMPWordsLog("WordsLog",UpdateDateID,UpdateTimeID),-1) q:UpdateTimeID=""
		    	s UpdateTime=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(UpdateTimeID) 
		    	s LogID=$P(^TEMPWordsLog("WordsLog",UpdateDateID,UpdateTimeID),"^",1)
		    	s UpdateUserName=$P(^TEMPWordsLog("WordsLog",UpdateDateID,UpdateTimeID),"^",2)
		    	s Opreation=$P(^TEMPWordsLog("WordsLog",UpdateDateID,UpdateTimeID),"^",3)
		    	s:Opreation="" Opreation="编辑中"
		    	continue:(preOpreation=Opreation)&&(preUpdateUserName=UpdateUserName) 
		    	s preOpreation=Opreation
		    	s preUpdateUserName=UpdateUserName	
		    	d OutputRowLog
		    }
	    }
	}
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowLog
	set Data=$lb(LogID,UpdateDate,UpdateTime,UpdateUserName,Opreation)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetWordsLogListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCTPMExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetWordsLogListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetWordsLogListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:丁亚男
/// CreatDate:2021-02-05
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// type:项目名称（取自识别词项目字典表的标准名称）,name:项目名称
/// w ##class(web.CDSS.CMKB.IdentifyWords).GetRefFlag(type,name)
ClassMethod GetRefFlag(type As %String, name As %String) As %String
{
    s WordsDescStr=""
    s WordsItemRowId=""
    if (type'="")
    {
	    s WordsItemRowId=$O(^CT.WDT.CDSS.WordsItemI("DescIndex"," "_$ZCONVERT(type,"U"),""))
	}
	if (WordsItemRowId'="")
	{
		if ($d(^CT.WDT.CDSS.WordsConditionI("ItemDRConditionIndex",WordsItemRowId,name)))
		{
			s ConditionRowId = ""
			for
			{
				s ConditionRowId = $o(^CT.WDT.CDSS.WordsConditionI("ItemDRConditionIndex",WordsItemRowId,name,ConditionRowId),-1) q:ConditionRowId=""
				
				s NodeDR  = $lg($g(^CT.WDT.CDSS.WordsConditionD(ConditionRowId)),2)
				s WordsDR=$lg($g(^CT.WDT.CDSS.WordsNodeD(NodeDR)),2)
				s WordsDesc=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsDR)),3)
				s:WordsDescStr'="" WordsDescStr=WordsDescStr_","_WordsDesc
				s:WordsDescStr="" WordsDescStr=WordsDesc
				
			}
		}
		
	}
    q WordsDescStr
}

/// Creator:丁亚男
/// CreatDate:2021-02-24
/// Description:把疾病导入识别词
/// Table:CT.WDT.CDSS.DiseaseDict、CT.WDT.CDSS.IdentifyWords
/// Input:
/// Return:
/// Other:w ##class(web.CDSS.CMKB.IdentifyWords).ImportDiseToIWords()
ClassMethod ImportDiseToIWords()
{
	s count=0
	s CDSSDiseaseRowId=0
	for
	{
 		s CDSSDiseaseRowId = $o(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)) q:CDSSDiseaseRowId=""
 		
 		s DiseaseName=$lg($g(^CT.WDT.CDSS.DiseaseDictD(CDSSDiseaseRowId)),3)
		if ('$d(^CT.WDT.CDSS.IdentifyWordsI("DescIndex"," "_$ZCONVERT(DiseaseName,"U"))))
		{
			s Wordsobj=##class(CT.WDT.CDSS.IdentifyWords).%New() 
			s Wordsobj.WordsCode = ##class(web.CDSS.CMKB.IdentifyWords).GetLastCode()
			s Wordsobj.WordsDesc = DiseaseName
			s Wordsobj.WordsType="诊断条件"
			s Wordsobj.WordsState="编辑中"
			s Wordsobj.UpdateDate = $zdt($h,3)
			s Wordssc=Wordsobj.%Save()
			d Wordsobj.%Close()
        	if $$$ISOK(Wordssc)
			{
				s count=count+1
			}
			else
			{
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(Wordssc)_"'}"  //返回错误信息
				//w !,DiseaseName_"识别词没有导入成功"
			}
			k Wordsobj
		}		
	}
	q count_"条数据导入成功！"
}

/// Creator:石萧伟
/// CreatDate:2021-04026
/// Description：下载查询到得数据
/// Input：
/// Return:
/// Other:w ##class(web.CDSS.CMKB.IdentifyWords).DownLoadFile()
ClassMethod DownLoadFile(desc, WType, SState, WState, UUser, AUser, SUpdateDate, EUpdateDate)
{
	s User=1 //%session.Get("LOGON.USERID")
	s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1)
	s PathDir=Disk_":\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\"
	s ifExistsDir=##class(%File).DirectoryExists(PathDir)
	if ifExistsDir'=1
	{
		d ##class(%File).CreateDirectory("D:\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\")
	}
	s P=Disk_":\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\识别词拆分导出数据"_User_".csv"
	s file=##class(%File).%New(P)
	s filename = "识别词拆分导出数据"_User_".csv"
	d file.Open("NWS")
	d file.Write("识别词编码,"_"识别词名称,"_"识别词类型,"_"识别词状态,"_"编辑人,"_"编辑时间,"_"审核人,"_"审核时间,"_"是否拆分,"_"备注")
	d file.WriteLine()
	s date=""
	for
	{
		s date=$o(^CT.WDT.CDSS.IdentifyWordsI("DateIndex",date),-1) q:date=""
		s WordsRowId=""
		for
		{ 
			s WordsRowId=$o(^CT.WDT.CDSS.IdentifyWordsI("DateIndex",date,WordsRowId),-1) q:WordsRowId="" 
			s WordsCode=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),2)
			s WordsDesc=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),3)
			s WordsType=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),4)
			s WordsState=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),5)
			s UpdateUser=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),6)
			s UpdateDate=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),7)
			s AuditUser=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),8)
			s AuditDate=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),9)
			s SplitState=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),10)
			s Remarks=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),11)
			s UpdateDateUDate="", UpdateDateUTime=""
			if (UpdateDate'="")
			{ 
				s UpdateDateU=$ZDTH(UpdateDate,3)
				s UpdateDateUDate=$p(UpdateDateU,",",1)
				s UpdateDateUTime=$p(UpdateDateU,",",2)
			}	
						
			s SUpdateDateFlag=1
			if (SUpdateDate'="")
			{
				s SUpdateDateU=$ZDTH(SUpdateDate,3)
				s SUpdateDateUDate=$p(SUpdateDateU,",",1)
				s SUpdateDateUTime=$p(SUpdateDateU,",",2)
				if (SUpdateDateUDate>UpdateDateUDate)||((SUpdateDateUDate=UpdateDateUDate)&(SUpdateDateUTime>UpdateDateUTime))
				{
					s SUpdateDateFlag=0	
				}
			}
			s EUpdateDateFlag=1
			if (EUpdateDate'="")
			{
				s EUpdateDateU=$ZDTH(EUpdateDate,3)
				s EUpdateDateUDate=$p(EUpdateDateU,",",1)
				s EUpdateDateUTime=$p(EUpdateDateU,",",2)
				if (EUpdateDateUDate<UpdateDateUDate)||((EUpdateDateUDate=UpdateDateUDate)&(EUpdateDateUTime<UpdateDateUTime))
				{
					s EUpdateDateFlag=0	
				}
			}
			s SplitStateC=""
			if (SplitState = 0){
				s SplitStateC = "已拆分"
			} elseif (SplitState=1){
				s SplitStateC = "未拆分"
			}
			 if (($ZCONVERT(WordsDesc,"U")[desc))&&($ZCONVERT(WordsType,"U")[WType)&&($ZCONVERT(SplitState,"U")[SState)&&($ZCONVERT(WordsState,"U")[WState)&&($ZCONVERT(AuditUser,"U")[AUser)
			&&($ZCONVERT(UpdateUser,"U")[UUser)&&(SUpdateDateFlag=1)&&(EUpdateDateFlag=1){
				d file.Write(WordsCode_",")
				d file.Write(WordsDesc_",")
				d file.Write(WordsType_",")
				d file.Write(WordsState_",")
				d file.Write(UpdateUser_",")
				d file.Write(UpdateDate_",")
				d file.Write(AuditUser_",")
				d file.Write(AuditDate_",")
				d file.Write(SplitStateC_",")
				d file.Write(Remarks)
				d file.WriteLine()
			}
		}
			
		///"诊断名,"_"结构化结果,"_"专业科室,"_"处理状态,"_"ICD编码,"_"ICD中文描述,"_"参考中心词,"_"分词,"_"数据类型,"_"别名,"_"其他描述,"_"总频次"		d file.Write(Desc_",")

	}
	d file.%Save()
	d file.%Close()
	q filename
}

/// Creator：石萧伟
/// CreatDate: 2020-05-29
/// Description:获取科室下拉框数据
/// Table：CT.WDT.CDSS.UserJoinDept、CT.WDT.CDSS.DeptDict
/// Input：desc科室名称
/// d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.IdentifyWords","GetJoinDeptForCmb","")
Query GetJoinDeptForCmb(desc As %String) As %Query(ROWSPEC = "DeptRowId:%String,DeptCode:%String,DeptName:%String")
{
}

ClassMethod GetJoinDeptForCmbExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
	
	s repid=$I(^CacheTemp)
	s ind=1
	s:desc'="" desc=$ZCONVERT(desc,"U")
	s parentdr=-100000000000000
	s DeptRowId=""
	for  
	{	
		s DeptRowId=$o(^CT.WDT.CDSS.DiseaseDeptDictI("ParentIndex",parentdr,DeptRowId)) q:(DeptRowId="")
		s DeptCode=$listGet($g(^CT.WDT.CDSS.DeptDictD(DeptRowId)),2)  //科室编码
		s DeptName=$listGet($g(^CT.WDT.CDSS.DeptDictD(DeptRowId)),3)  //科室名称
		i (($ZCONVERT(DeptName,"U")[desc)||(desc=""))  //条件
		{
			d OutputRowCmbJoinDept
        }

	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmbJoinDept
    set Data=$lb(DeptRowId,DeptCode,DeptName)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetJoinDeptForCmbClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetJoinDeptForCmbExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetJoinDeptForCmbFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetJoinDeptForCmbExecute ]
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

/// Creator:丁亚男
/// CreatDate:2021-08-12
/// Input:RowId 识别词ID
/// Return:
/// Other:w ##class(web.CDSS.CMKB.IdentifyWords).IsExistNode(182)
ClassMethod IsExistNode(RowId) As %String
{
	s flag=0 //赋初值 不存在
	if $d(^CT.WDT.CDSS.WordsNodeI("WordsDRIndex",RowId)) s flag=1
	q flag
}

/// Creator:丁亚男
/// CreatDate:2021-10-18
/// Input:RowId 识别词ID
/// Return:
/// Other:w ##class(web.CDSS.CMKB.IdentifyWords).ChangeSplitState(182)
ClassMethod ChangeSplitState(RowId)
{
	s result="{success:'true'}"
	//遍历识别词每个节点（开始、结束除外）是否有内容，没有内容则不能通过
	s ContentFlag=1 //节点下是否有内容 1有 0无
	if ($d(^CT.WDT.CDSS.WordsNodeI("WordsDRIndex",RowId)))
    {
	    s NodeDR=0
	    for
	    {
		    s NodeDR=$O(^CT.WDT.CDSS.WordsNodeI("WordsDRIndex",RowId,NodeDR)) q:(NodeDR="")||(ContentFlag=0)
		    s NodeType=$lg($g(^CT.WDT.CDSS.WordsNodeD(NodeDR)),5)
			s NodeTypeDesc=""
			s:NodeType'="" NodeTypeDesc=$lg($g(^CT.WDT.CDSS.NodeTypeD(NodeType)),3)
			continue:(NodeTypeDesc="开始")||(NodeTypeDesc="结束")
			//节点下是否有内容
			if ('$d(^CT.WDT.CDSS.WordsConditionI("NodeDRIndex",NodeDR)))
		    {
				s ContentFlag=0  
		    }
		}
    }
    else
    {
		s ContentFlag=0  
	}
    if (ContentFlag=1)
    {
		s obj=##class(CT.WDT.CDSS.IdentifyWords).%OpenId(RowId)
		s obj.SplitState = 0
		Ts
	 	s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" //返回RowId
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("识别词管理","web.CDSS.CMKB.IdentifyWords","ChangeStatus",eobj)
	   		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
    }
	q result
}

/// Creator:丁亚男
/// CreatDate:2022-01-26
/// Description:识别词不同状态的数据统计
/// Table:CT.WDT.CDSS.IdentifyWords
/// Input:
/// Return:总数据量^编辑中的数据量^已审核的数据量(审核通过+已上线)^待审核的数据量
/// Other:w ##class(web.CDSS.CMKB.IdentifyWords).CountData()
ClassMethod CountData()
{
	s Totalcount=0,Editcount=0,Reviewedcount=0,Tobereviewedcount=0
	s WordsRowId=0
	for
	{ 
		s WordsRowId=$o(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)) q:WordsRowId="" 
		s WordsState=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),5)
	 	if (WordsState="")||(WordsState="编辑中")||(WordsState="审核不通过")
	 	{
		 	s Totalcount=Totalcount+1
		 	s Editcount=Editcount+1	
		}
		elseif (WordsState="已上线")||(WordsState="审核通过")
		{
			s Totalcount=Totalcount+1
		 	s Reviewedcount=Reviewedcount+1		
		}
		elseif (WordsState="待审核")
		{
			s Totalcount=Totalcount+1
		 	s Tobereviewedcount=Tobereviewedcount+1		
		}
	}
	
	q Totalcount_"^"_Editcount_"^"_Reviewedcount_"^"_Tobereviewedcount
}

/// Creator:赵文伟
/// CreatDate:2022-06-23
/// Description:查找已上线但未拆分的识别词并下线【弃用】
/// Table:CT.WDT.CDSS.IdentifyWords
/// Input:
/// Return:
/// Other:d ##class(web.CDSS.CMKB.IdentifyWords).OffLineIdentifyWordsOld()
ClassMethod OffLineIdentifyWordsOld()
{
	s count=0
	s WordsRowId=0
	for
	{
		s WordsRowId=$o(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)) q:WordsRowId="" 
		s obj=##class(CT.WDT.CDSS.IdentifyWords).%OpenId(WordsRowId)
		s WordsState=obj.WordsState
		s SplitState=obj.SplitState	//拆分状态（0是/1否）

		/***************判断流程图完整性******************/
		s StartFlag=0	//开始节点
		s EndFlag=0		//结束节点
		s ContentFlag=0	//内容节点
		s FlowFlag=0	//流程图完整性标志
		if ($d(^CT.WDT.CDSS.WordsNodeI("WordsDRIndex",WordsRowId))){		//节点表不为空
			s NodeDR=0
		    for
		    {
			    s NodeDR=$O(^CT.WDT.CDSS.WordsNodeI("WordsDRIndex",WordsRowId,NodeDR)) q:NodeDR=""
			    s NodeType=$lg($g(^CT.WDT.CDSS.WordsNodeD(NodeDR)),5)
				s NodeTypeDesc=""
				s:NodeType'="" NodeTypeDesc=$lg($g(^CT.WDT.CDSS.NodeTypeD(NodeType)),3)
				if (NodeTypeDesc="开始"){
					s StartFlag=1
				} elseif (NodeTypeDesc="结束"){
					s EndFlag=1
				}
				continue:(NodeTypeDesc="开始")||(NodeTypeDesc="结束")
				//内容节点下是否有内容
				if ($d(^CT.WDT.CDSS.WordsConditionI("NodeDRIndex",NodeDR)))
			    {
					s ContentFlag=1
			    }
			}
			if (StartFlag=1)&(EndFlag=1)&(ContentFlag=1){	//如果开始节点、结束节点、内容节点存在，且内容节点不为空
				&sql(SELECT COUNT(*) INTO :nodenum FROM CT_WDT_CDSS.WordsNode WHERE WordsDR=:WordsRowId)
				&sql(SELECT COUNT(*) INTO :linknum FROM CT_WDT_CDSS.WordsLink WHERE WordsDR=:WordsRowId)
				if (linknum'=(nodenum-1)){
					s FlowFlag=1	//线数据不完整
				}
			} else{
				s FlowFlag=1	//节点及节点内容不完整
			}
			/*******************判断流程图完整性结束********************/
			
		} 
		else{	//节点表为空
			s FlowFlag=1
		}
		
		if (WordsState="已上线")&(SplitState="1"){	//已上线识别词，拆分状态为”否“时，下线
			
			s obj.WordsState="已下线"
			s obj.UpdateDate=$zdt($h,3)
			s sc=obj.%Save()
			If $$$ISOK(sc)
			{
				s count=count+1
			}
		} elseif(WordsState="已上线")&(SplitState=0)&(FlowFlag=1){	//已上线识别词，拆分状态为”是“，拆分流程图不完整时，下线
			s obj.WordsState="已下线"
			s obj.UpdateDate=$zdt($h,3)
			s sc=obj.%Save()
			If $$$ISOK(sc)
			{
				s count=count+1
			}
			
		}
		d obj.%Close()
	}
	w "success^共处理"_count_"条数据！"
}

/// Creator:赵文伟
/// CreatDate:2022-06-23
/// Description:查找已上线但未拆分的识别词并下线【弃用】
/// Table:CT.WDT.CDSS.IdentifyWords
/// Input:
/// Return:
/// Other:d ##class(web.CDSS.CMKB.IdentifyWords).OffLineIdentifyWords()
ClassMethod OffLineIdentifyWords()
{
	s count=0
	s WordsRowId=0
	for
	{ 
		s WordsRowId=$o(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)) q:WordsRowId="" 
		s obj=##class(CT.WDT.CDSS.IdentifyWords).%OpenId(WordsRowId)
		s WordsState=obj.WordsState
		s SplitState=obj.SplitState	//拆分状态（0是/1否）
		
		if WordsState'="已上线" continue
		/***************判断流程图完整性******************/
		s StartFlag=0	//开始节点
		s EndFlag=0		//结束节点
		s ContentFlag=0	//内容节点
		s FlowFlag=0	//流程图完整性标志
		
		s SQL="SELECT DISTINCT FlowChartNum FROM CT_WDT_CDSS.WordsNode WHERE WordsDR="_WordsRowId_""
		s tStatement=##class(%SQL.Statement).%New()
		s qStatus = tStatement.%Prepare(SQL)
		if qStatus '= 1
		{
			w "%Prepare failed:"
			d $System.Status.DisplayError(qStatus)
			q
		}
		s rset= tStatement.%Execute()
		while rset.%Next() 
		{
			s FlowChartNum= rset.FlowChartNum
			s NodeDR=0
		    for
		    {
			    s NodeDR=$O(^CT.WDT.CDSS.WordsNodeI("WordsChartIndex",WordsRowId,FlowChartNum,NodeDR)) q:NodeDR=""
			    s NodeType=$lg($g(^CT.WDT.CDSS.WordsNodeD(NodeDR)),5)
				s NodeTypeDesc=""
				s:NodeType'="" NodeTypeDesc=$lg($g(^CT.WDT.CDSS.NodeTypeD(NodeType)),3)
				if (NodeTypeDesc="开始"){
					s StartFlag=1
					
				} elseif (NodeTypeDesc="结束"){
					s EndFlag=1
				}
				continue:((NodeTypeDesc="开始")||(NodeTypeDesc="结束"))
				//内容节点下是否有内容
				if ($d(^CT.WDT.CDSS.WordsConditionI("NodeDRIndex",NodeDR)))
				{
					s ContentFlag=1
				}
			}
			if (StartFlag=1)&(EndFlag=1)&(ContentFlag=1){	//如果开始节点、结束节点、内容节点存在，且内容节点不为空
			
				&sql(SELECT COUNT(*) INTO :nodenum FROM CT_WDT_CDSS.WordsNode WHERE WordsDR=:WordsRowId AND FlowChartNum=:FlowChartNum)
				&sql(SELECT COUNT(*) INTO :linknum FROM CT_WDT_CDSS.WordsLink WHERE WordsDR=:WordsRowId AND FlowChartNum=:FlowChartNum)
				if (linknum'=(nodenum-1)){	//线数据不完整
				
					s FlowFlag=1	
					
				}
#;				if ('$d(^CT.WDT.CDSS.WordsLinkI("WordsDRIndex",WordsRowId)))		//线数据不存在
#;				{
#;					s FlowFlag=1
#;				}
			} else{
				s FlowFlag=1	//节点及节点内容不完整
			}
			/*******************判断流程图完整性结束********************/
			
			if (WordsState="已上线")&(SplitState="1"){	//已上线识别词，拆分状态为”否“时，下线
			
				s obj.WordsState="已下线"
				s obj.UpdateDate=$zdt($h,3)
				s sc=obj.%Save()
				If $$$ISOK(sc)
				{
					s count=count+1
				}
			} elseif(WordsState="已上线")&(SplitState=0)&(FlowFlag=1){	//已上线识别词，拆分状态为”是“，拆分流程图不完整时，下线
				s obj.WordsState="已下线"
				s obj.UpdateDate=$zdt($h,3)
				s sc=obj.%Save()
				If $$$ISOK(sc)
				{
					s count=count+1
				}
			}
			d obj.%Close()
		}
	}
	w "success^共处理"_count_"条数据！"
}

/// Creator:赵文伟
/// CreatDate:2022-07-01
/// Description: 查找已上线但未完成拆分（流程图不完整的、拆分状态为否的）的识别词并下线[按照流程图顺序取数据判断]
/// Table: CT.WDT.CDSS.IdentifyWords、CT.WDT.CDSS.WordsNode、CT.WDT.CDSS.WordsLink
/// Input: 
/// Return: count
/// Other: d ##class(web.CDSS.CMKB.IdentifyWords).OffLineData()
ClassMethod OffLineData() As %String
{
	s count=0
	s WordsDR=""
	for
	{ 
		s WordsDR=$o(^CT.WDT.CDSS.IdentifyWordsD(WordsDR)) q:WordsDR="" 
		s obj=##class(CT.WDT.CDSS.IdentifyWords).%OpenId(WordsDR)
		s WordsState=obj.WordsState
		s SplitState=obj.SplitState	//拆分状态（0是/1否）
		if WordsState'="已上线" continue
		
		s StartNodeType=1	//开始
		
		s NodeRowId=""
	 	for{
		 	s NodeRowId = $o(^CT.WDT.CDSS.WordsNodeI("WordsTypeIndex",WordsDR,StartNodeType,NodeRowId)) q:NodeRowId=""	//开始节点
	 		s NodeId=NodeRowId
	 		s FlowFlag=0
			s FlowFlag=..JudgeFollow(WordsDR,NodeId)
		
			if (FlowFlag=0){
				q
			}
	 	}
	 	
	 	if (WordsState="已上线")&(SplitState="1"){	//已上线识别词，拆分状态为”否“时，下线
				
				s obj.WordsState="已下线"
				s obj.UpdateDate=$zdt($h,3)
				s sc=obj.%Save()
				If $$$ISOK(sc)
				{
					s count=count+1
				}
			} elseif(WordsState="已上线")&(SplitState=0)&(FlowFlag=0){	//已上线识别词，拆分状态为”是“，拆分流程图不完整时，下线
				s obj.WordsState="已下线"
				s obj.UpdateDate=$zdt($h,3)
				
				s sc=obj.%Save()
				If $$$ISOK(sc)
				{
					s count=count+1
				}
			}
			d obj.%Close()
	 	
	}
	
 	w "共处理"_count_"条数据！"
}

/// Creator:赵文伟
/// CreatDate:2022-07-01
/// Description:【递归取开始节点后续节点】
/// Table: CT.WDT.CDSS.IdentifyWords
/// Input: 
/// Return:
/// Other: w ##class(web.CDSS.CMKB.IdentifyWords).JudgeFollow("","")
ClassMethod JudgeFollow(WordsDR As %String, NodeId As %String) As %String
{
	s flag=0
	s LinkRowId = ""
	for
	{
		s LinkRowId = $o(^CT.WDT.CDSS.WordsLinkI("WordsPreNodeIndex",WordsDR,NodeId,LinkRowId)) q:LinkRowId=""
		
		s NextNode  = $lg($g(^CT.WDT.CDSS.WordsLinkD(LinkRowId)),5)
		
		if (NextNode="") continue
		s NodeDR=NextNode
		
		s NodeType  = $lg($g(^CT.WDT.CDSS.WordsNodeD(NodeDR)),5)
		s NodeTypeDesc=""
		s:NodeType'="" NodeTypeDesc= $lg($g(^CT.WDT.CDSS.NodeTypeD(NodeType)),3)
		
		if (NodeTypeDesc="结束"){		//找到结束节点，下一条流程
			s flag=1
			q
			
		} 
		else 	//当前流程后续数据
		{
			
			s flag= ..JudgeFollow(WordsDR,NodeDR)
			
		}
	}
	q flag
}

/// Creator:赵文伟
/// CreatDate:2022-08-08
/// Description:
/// Table: CT.WDT.CDSS.IdentifyWords
/// Input: 
/// Return:
/// Other: w ##class(web.CDSS.CMKB.IdentifyWords).getWordType("")
ClassMethod getWordType(rowid As %String) As %String
{
	s WordsType=""
	s:rowid'="" WordsType=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(rowid)),4)	
	q WordsType
}

/// Creator:丁亚男
/// CreatDate:2022-06-14
/// Description：按照给定表格的数据导入诊断条件的识别词及拆分
/// Input：
/// Return:
/// Other:w ##class(web.CDSS.CMKB.IdentifyWords).ExportIWContent("D:\诊断已对照数据.csv")
ClassMethod ExportIWContent(path)
{
	s readcount=0
	s savecount=0
	s nosavecount=0
	s id=0
	//导出数据	
	s ExPath=##class(%File).GetDirectory()
	s ExDisk=$p(ExPath,":",1)
	s ExPathDir=ExDisk_":\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\"
	s ifExistsDir=##class(%File).DirectoryExists(ExPathDir)
	if ifExistsDir'=1
	{
		d ##class(%File).CreateDirectory("D:\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\")
	}
	s ExP=ExDisk_":\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\诊断识别词拆分导出数据.csv"
	s Exfile=##class(%File).%New(ExP)
	s Exfilename = "诊断识别词拆分导出数据.csv"
	d Exfile.Open("NWS")  //识别词项目	项目名称	是否有属性（1是0否）
	d Exfile.Write("客户名称,"_"ICD编码,"_"疾病名称,"_"对照情况,"_"项目名称")
	d Exfile.WriteLine()
	
	
	//读取数据
	s file=##class(%File).%New(path)
	d file.Open("RS")
	d file.ReadLine()		//读取第一行
	while 'file.AtEnd
	{
		s str=file.ReadLine()
		continue:str=""
		s CustomerName=$p(str,",",1) //客户名称
		s ICDCode=$p(str,",",2) //ICDCode
		s DiseaseName=$p(str,",",3) //疾病名称
		s ConState=$p(str,",",4) //状态
		continue:DiseaseName=""
		s DiseaseName=$zstrip(DiseaseName,"<>W")
		s DiseDetail="",WordsItemDRN=""
		s WordsRowId=""
		for
		{ 
			s WordsRowId=$o(^CT.WDT.CDSS.IdentifyWordsI("DescIndex"," "_$ZCONVERT(DiseaseName,"U"),WordsRowId)) q:WordsRowId="" 
			s WordsType=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),4)
			continue:WordsType'="诊断条件"
			
			s NodeRowId = ""
			for
			{
				s NodeRowId = $o(^CT.WDT.CDSS.WordsNodeI("WordsTypeIndex",WordsRowId,6,NodeRowId)) q:NodeRowId=""  //6-主要条件-识别词
				s parentdr=-100000000000000
				
				s myRowID=0
				for 
				{
					s myRowID=$o(^CT.WDT.CDSS.WordsConditionI("NodeParentIndex",NodeRowId,parentdr,myRowID)) q:(myRowID="")
					s WordsItemDR  = $lg($g(^CT.WDT.CDSS.WordsConditionD(myRowID)),3)
					s WordsItemDRN=""
					s:WordsItemDR'="" WordsItemDRN= $lg($g(^CT.WDT.CDSS.WordsItemD(WordsItemDR)),3)
					continue:WordsItemDRN'="诊断名称"
					s ConditionItemValue  = $lg($g(^CT.WDT.CDSS.WordsConditionD(myRowID)),9)
					s:DiseDetail'="" DiseDetail=DiseDetail_"|"_ConditionItemValue
					s:DiseDetail="" DiseDetail=ConditionItemValue
					
				}
			}
			
		}
		s str=CustomerName_","_ICDCode_","_DiseaseName_","_ConState_","_WordsItemDRN_","_DiseDetail
		d Exfile.Write(str)
		d Exfile.WriteLine()	
	}
	d file.%Close()
	
	d Exfile.%Save()
	d Exfile.%Close()
	q Exfilename
}

/// Creator:丁亚男
/// CreatDate:2022-08-15
/// Description：按照给定表格的数据导出诊断条件的识别词及拆分
/// Input：
/// Return:
/// Other:w ##class(web.CDSS.CMKB.IdentifyWords).ExportDiagIWContent()
ClassMethod ExportDiagIWContent()
{
	s readcount=0
	s savecount=0
	s nosavecount=0
	s id=0
	//导出数据	
	s ExPath=##class(%File).GetDirectory()
	s ExDisk=$p(ExPath,":",1)
	s ExPathDir=ExDisk_":\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\"
	s ifExistsDir=##class(%File).DirectoryExists(ExPathDir)
	if ifExistsDir'=1
	{
		d ##class(%File).CreateDirectory("D:\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\")
	}
	s ExP=ExDisk_":\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\诊断识别词拆分导出数据.csv"
	s Exfile=##class(%File).%New(ExP)
	s Exfilename = "诊断识别词拆分导出数据.csv"
	d Exfile.Open("NWS")  //识别词项目	项目名称	是否有属性（1是0否）
	d Exfile.Write("识别词名称,"_"项目名称,"_"拆分内容")
	d Exfile.WriteLine()
	

	s WordsRowId=""
	for
	{ 
		s WordsRowId=$o(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)) q:WordsRowId="" 
		s WordsDesc=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),3)
		s WordsType=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),4)
		continue:WordsType'="诊断条件"
		s DiseDetail=""
		s NodeRowId = ""
		for
		{
			s NodeRowId = $o(^CT.WDT.CDSS.WordsNodeI("WordsTypeIndex",WordsRowId,6,NodeRowId)) q:NodeRowId=""  //6-主要条件-识别词
			s parentdr=-100000000000000
			
			s myRowID=0
			for 
			{
				s myRowID=$o(^CT.WDT.CDSS.WordsConditionI("NodeParentIndex",NodeRowId,parentdr,myRowID)) q:(myRowID="")
				s WordsItemDR  = $lg($g(^CT.WDT.CDSS.WordsConditionD(myRowID)),3)
				s WordsItemDRN=""
				s:WordsItemDR'="" WordsItemDRN= $lg($g(^CT.WDT.CDSS.WordsItemD(WordsItemDR)),3)
				continue:WordsItemDRN'="诊断名称"
				s ConditionItemValue  = $lg($g(^CT.WDT.CDSS.WordsConditionD(myRowID)),9)
				s:DiseDetail'="" DiseDetail=DiseDetail_"|"_ConditionItemValue
				s:DiseDetail="" DiseDetail=ConditionItemValue
				
			}
		}
			
		
		s str=WordsDesc_","_WordsItemDRN_","_DiseDetail
		d Exfile.Write(str)
		d Exfile.WriteLine()	
	}
	d Exfile.%Save()
	d Exfile.%Close()
	q Exfilename
}

/// Creator:赵文伟
/// CreatDate:2022-08-19
/// Description:识别词被引用信息
/// Table: CT.WDT.CDSS.IdentifyWords
/// Input: 识别词id
/// Return: 引用该识别词的规则id、规则所属菜单名、规则描述
/// Other: w ##class(web.CDSS.CMKB.IdentifyWords).GetQuoteInfo("84469")
ClassMethod GetQuoteInfo(WordsRowId As %String) As %String
{
	if WordsRowId="" q
	s WordsDesc=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),3)
	s WordsType=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),4)
	s QuoteStr=""
	if ($d(^CT.WDT.CDSS.RuleConditionI("ValueIndex",WordsDesc))){
		s QuoteStr=QuoteStr_"["
		s count=0
		s RuleConditionDR=""
		for
		{
			s RuleConditionDR = $O(^CT.WDT.CDSS.RuleConditionI("ValueIndex",WordsDesc,RuleConditionDR))  q:RuleConditionDR=""
			
			s NodeDR = $lg($g(^CT.WDT.CDSS.RuleConditionD(RuleConditionDR)),2)
			s NodeTypeDR=""
			s:NodeDR'="" NodeTypeDR = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),5)	 //节点类型
			s RuleTypeDR=""
			s:NodeDR'="" RuleTypeDR  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),10)
			s ConditionItemCategory=$lg($g(^CT.WDT.CDSS.RuleConditionD(RuleConditionDR)),10)
			continue:(((WordsType["中医")&&(ConditionItemCategory'="中医"))||((WordsType'["中医")&&(ConditionItemCategory="中医")))
			if (NodeTypeDR=6)||(NodeTypeDR=7)||(NodeTypeDR=31)||(NodeTypeDR=5)||(NodeTypeDR=27){	//主要条件-识别词||否定条件-识别词||通过条件||诊断条件||否定条件—诊断
				
				continue:((WordsType="诊断条件")&&((NodeTypeDR=6)||(NodeTypeDR=7)||(NodeTypeDR=31)))
				continue:((WordsType="识别条件")&&((NodeTypeDR=5)||(NodeTypeDR=27)))
				
				s RuleDR = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),2)
				s RuleDesc=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleDR)),3)
				s RuleTypeDRWarm = $lg($g(^CT.WDT.CDSS.RuleDictD(RuleDR)),6)				//规则流程类型
				
				if (RuleTypeDR=""){	
					if (RuleTypeDRWarm'=1){	//预警
						s RuleType=""
						s:RuleTypeDRWarm'="" RuleType = $lg($g(^CT.WDT.CDSS.ChartTypeD(RuleTypeDRWarm)),3)
					} else{					//推荐治疗方案
						
						s RuleType="推荐治疗方案"
					}
					
				}else{
					s RuleType=""
					s:RuleTypeDR'="" RuleType = $lg($g(^CT.WDT.CDSS.ChartTypeD(RuleTypeDR)),3)	
				}
				if count>0 s QuoteStr=QuoteStr_","
				s count=count+1
				s RuleDesc=..EvalJSONW(RuleDesc)
				//s RuleDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(RuleDesc)
				s QuoteStr=QuoteStr_"{""RuleDR"":"""_RuleDR_""",""RuleType"":"""_RuleType_""",""RuleDesc"":"""_RuleDesc_"""}"
				
			}		
		}
		s QuoteStr=QuoteStr_"]"
	}
	q QuoteStr
}

/// Creator：李得原
/// CreatDate: 2022-08-24
/// Description：查询 识别词
/// Table：CT.WDT.CDSS.IdentifyWords
/// Input：rowid, desc
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.IdentifyWords","GetDataForCmb2","","咳嗽","","识别条件","中医")
Query GetDataForCmb2(rowid As %String, desc As %String, q As %String, type As %String = "", medicineType As %String = "") As %Query(ROWSPEC = "WordsRowId:%String,WordsDesc:%String,WordsType")
{
}

ClassMethod GetDataForCmb2Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String, q As %String, type As %String = "", medicineType As %String = "") As %Status
{
	
	s repid=$I(^CacheTemp)
	s ind=1
	if (rowid'="") //根据rowid返回该条记录
	{
		s WordsRowId=rowid
		s WordsDesc=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),3)
		d OutputRowCmb
	}
	else
	{
		s:q'="" desc=q	
		//s:q'="" desc=$ZCONVERT(q,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		
		s le=0
		s num=0
		
		//s Str1 = "SELECT TOP 1000 WordsDesc, ID, WordsType FROM CT_WDT_CDSS.IdentifyWords WHERE WordsDesc LIKE"
		//s Str2 = " ""%"_desc_"%"""_" ORDER BY Len(WordsDesc)"
		//s SqlStr = Str1_Str2
		
		
		s Str1 = "SELECT TOP 1000 WordsDesc, ID, WordsType FROM CT_WDT_CDSS.IdentifyWords "
		s Str2 = " WordsDesc LIKE ""%"_desc_"%"""_" OR WordsDesc ="""_desc_""""
		s Str3 = " ORDER BY Len(WordsDesc)"
		if desc'=""
		{
			s SqlStr = Str1_"WHERE"_Str2
		}
		else
		{
			s SqlStr = Str1
		}
		
		if type'=""
		{

			if medicineType="中医"
			{
				s Str4 = "WordsType="_""""_medicineType_type_""""
			}
			else
			{
				s Str4 = "WordsType="_""""_type_""""
			}
		}
		else
		{
			if medicineType="中医"
			{
				s Str4 = "WordsType LIKE "_""""_medicineType_%_""""
			}
		}
		
		if Str4'=""
		{
			if SqlStr["WHERE"
			{
				s SqlStr = SqlStr_" AND "_Str4
			}
			else
			{
				s SqlStr = SqlStr_" WHERE "_Str4
			}
		}
		
		s SqlStr = SqlStr_Str3

		
		s Sql= ##class(%ResultSet).%New()
		s Status = Sql.Prepare(SqlStr)
		s ret = Sql.Execute()
		while Sql.Next()
		{
			s WordsRowId=Sql.Data("ID")
			s WordsDesc=Sql.Data("WordsDesc")
			s WordsType=Sql.Data("WordsType")
			s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(WordsDesc)  
			
			if (medicineType="中医") {
				s joinType= medicineType_type
			} else{
				s joinType= type
			}
			s:WordsType'="" WordsType= $ZCONVERT(WordsType,"U")
			
			continue:joinType'=WordsType
			
			d OutputRowCmb
		}
	}
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb
    set Data=$lb(WordsRowId,WordsDesc,WordsType)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb2Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb2Execute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
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

ClassMethod GetDataForCmb2Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb2Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：赵文伟
/// CreatDate: 2022-09-01
/// Description：查询 识别词【取全部数据，不区分类型，返回数据中带类型】
/// Table：CT.WDT.CDSS.IdentifyWords
/// Input：rowid, desc
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.IdentifyWords","GetDataForCmb3","","肝淋巴","")
Query GetDataForCmb3(rowid As %String, desc As %String, q As %String) As %Query(ROWSPEC = "WordsRowId:%String,WordsDesc:%String,WordsDR")
{
}

ClassMethod GetDataForCmb3Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String, q As %String) As %Status
{
	
	s repid=$I(^CacheTemp)
	s ind=1
	if (rowid'="") //根据rowid返回该条记录
	{
		s WordsRowId=rowid
		s WordsDesc=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),3)
		d OutputRowCmb
	}
	else
	{
		s:q'="" desc=q	
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		
		k ^TempDataHandle($ZNAME,repid,$JOB,"Short")
		
  		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.IdentifyWordsD(ID))
			q:ID=""
			s WordsDesc=$lg($g(^CT.WDT.CDSS.IdentifyWordsD(ID)),3)		//名称
			//continue:((desc'="")&&($ZCONVERT(WordsDesc,"U")'[desc))
			s length=$l(WordsDesc)
			s ^TempDataHandle($ZNAME,repid,$JOB,"Short",length,ID)=ID
		}
		s le=0
		s num=0
		for
		{
			s le=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le))
			q:le=""
			s WordsRowId=0
			for
			{
				s WordsRowId=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le,WordsRowId)) q:WordsRowId=""
				s WordsDR=WordsRowId
				s WordsDesc=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),3)
				s WordsType=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),4)
				s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(WordsDesc)  
				if (WordsType["中医")||(WordsType="") continue
				s WordsType= $ZCONVERT(WordsType,"U")
				
				if ((($ZCONVERT(WordsDesc,"U")[desc)||(PINYIN[desc))) {
					s num=num+1
					s WordsDesc=WordsDesc_"("_WordsType_")"
					d OutputRowCmb
				}
				
				q:num=1000
				
			}
	        q:num=1000
		}
		k ^TempDataHandle($ZNAME,repid,$JOB,"Short")
	}
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb
    set Data=$lb(WordsRowId,WordsDesc,WordsDR)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb3Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb3Execute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
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

ClassMethod GetDataForCmb3Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb3Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：ZWW
/// CreatDate: 2022-09-16
/// Description：查询识别词字典表[真分页查询，返回指定页数据]
/// Table：CT.WDT.CDSS.IdentifyWords
/// Input：desc
/// Output: "{""rows"":[], ""total"":0}" 
/// Other: w ##class(web.CDSS.CMKB.IdentifyWords).GetMyList("","20","1","创伤","","","","","","","","")
/// Other: w ##class(web.CDSS.CMKB.IdentifyWords).GetMyList("","20","1","免疫功能异常","识别条件","","","","","","","")
ClassMethod GetMyList(rowid, rows, page, desc, WType, SState, WState, UUser, AUser, SUpdateDate, EUpdateDate, Quote) As %String
{
 s jsonstr="",total=0
 w "{""rows"":["
 
 if (rowid'="") //根据rowid返回该条记录
 {
	s total=total+1 
	s WordsRowId=rowid
	s WordsCode=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),2)
	s WordsDesc=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),3)
	//s WordsDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(WordsDesc)
	s WordsDesc=..EvalJSONW(WordsDesc)
	s WordsType=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),4)
	s WordsState=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),5)
	s UpdateUser=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),6)
	s UpdateDate=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),7)
	s AuditUser=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),8)
	s AuditDate=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),9)
	s SplitState=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),10)
	s Remarks=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),11)
	s QuoteFlag=""
	s Flag=..GetQuoteFlag(WordsRowId)
	if (Flag=0){
		s QuoteFlag="否"
	}else{
		s QuoteFlag="是"
	}
	
	s mainstr="{""WordsRowId"":"""_WordsRowId_""",""WordsCode"":"""_WordsCode_""",""WordsDesc"":"""_WordsDesc_""",""WordsType"":"""_WordsType_""",""WordsState"":"""_WordsState
		_""",""UpdateUser"":"""_UpdateUser_""",""UpdateDate"":"""_UpdateDate_""",""AuditUser"":"""_AuditUser
		_""",""AuditDate"":"""_AuditDate_""",""SplitState"":"""_SplitState_""",""Remarks"":"""_Remarks_""",""QuoteFlag"":"""_QuoteFlag_"""}"
 	w mainstr
 }
 else
 {
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写 
	s:UUser'="" UUser=$ZCONVERT(UUser,"U")
	s:AUser'="" AUser=$ZCONVERT(AUser,"U")
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	
	if (desc'="")
	{
		s WordsRowId=""
		for
		{ 
			
			s WordsRowId=$o(^CT.WDT.CDSS.IdentifyWordsI("DescIndex"," "_$ZCONVERT(desc,"U"),WordsRowId)) q:WordsRowId="" 
			s WordsCode=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),2)
			s WordsDesc=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),3)
			//s WordsDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(WordsDesc)
			s WordsDesc=..EvalJSONW(WordsDesc)
			s WordsType=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),4)
			s WordsState=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),5)
			s UpdateUser=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),6)
			s UpdateDate=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),7)
			s AuditUser=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),8)
			s AuditDate=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),9)
			s SplitState=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),10)
			s Remarks=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),11)
			s QuoteFlag=""
			s Flag=..GetQuoteFlag(WordsRowId)
			continue:(Quote'="")&&(Quote'=Flag)
			if (Flag=0){
				s QuoteFlag="否"
			}else{
				s QuoteFlag="是"
			}
			
			s UpdateDateUDate="", UpdateDateUTime=""
			if (UpdateDate'="")
			{ 
				s UpdateDateU=$ZDTH(UpdateDate,3)
				s UpdateDateUDate=$p(UpdateDateU,",",1)
				s UpdateDateUTime=$p(UpdateDateU,",",2)
			}	
			
			s SUpdateDateFlag=1
			if (SUpdateDate'="")
			{
				s SUpdateDateU=$ZDTH(SUpdateDate,3)
				s SUpdateDateUDate=$p(SUpdateDateU,",",1)
				s SUpdateDateUTime=$p(SUpdateDateU,",",2)
				if (SUpdateDateUDate>UpdateDateUDate)||((SUpdateDateUDate=UpdateDateUDate)&(SUpdateDateUTime>UpdateDateUTime))
				{
					s SUpdateDateFlag=0	
				}
			}
			s EUpdateDateFlag=1
			if (EUpdateDate'="")
			{
				s EUpdateDateU=$ZDTH(EUpdateDate,3)
				s EUpdateDateUDate=$p(EUpdateDateU,",",1)
				s EUpdateDateUTime=$p(EUpdateDateU,",",2)
				if (EUpdateDateUDate<UpdateDateUDate)||((EUpdateDateUDate=UpdateDateUDate)&(EUpdateDateUTime<UpdateDateUTime))
				{
					s EUpdateDateFlag=0	
				}
			}
			
			if ($ZCONVERT(WordsType,"U")[WType)&&($ZCONVERT(SplitState,"U")[SState)&&($ZCONVERT(WordsState,"U")[WState)&&($ZCONVERT(AuditUser,"U")[AUser)
			&&($ZCONVERT(UpdateUser,"U")[UUser)&&(SUpdateDateFlag=1)&&(EUpdateDateFlag=1)	//过滤条件
			{
				if ((total+1<stpage)||(total+1>endpage)){ //如果不是当前页，则只计数，不输出
					s total=total+1
					continue
				}	
				s total=total+1
				s mainstr=""
				s mainstr="{""WordsRowId"":"""_WordsRowId_""",""WordsCode"":"""_WordsCode_""",""WordsDesc"":"""_WordsDesc_""",""WordsType"":"""_WordsType_""",""WordsState"":"""_WordsState
					_""",""UpdateUser"":"""_UpdateUser_""",""UpdateDate"":"""_UpdateDate_""",""AuditUser"":"""_AuditUser
					_""",""AuditDate"":"""_AuditDate_""",""SplitState"":"""_SplitState_""",""Remarks"":"""_Remarks_""",""QuoteFlag"":"""_QuoteFlag_"""}"
			 	
				if (jsonstr'="")
					{ 
						w ","
						s jsonstr=jsonstr_","_mainstr
					}
					else
					{
						s jsonstr=mainstr
					}
					w mainstr
			}
		}
		
	} 
	s date=""
	for{
		s date=$o(^CT.WDT.CDSS.IdentifyWordsI("DateIndex",date),-1) q:date=""
		s WordsRowId=""
		for
		{ 
			s WordsRowId=$o(^CT.WDT.CDSS.IdentifyWordsI("DateIndex",date,WordsRowId),-1) q:WordsRowId="" 
			s WordsCode=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),2)
			s WordsDesc=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),3)
			//s WordsDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(WordsDesc)
			s WordsDesc=..EvalJSONW(WordsDesc)
			continue:$ZCONVERT(WordsDesc,"U")=desc
			s WordsType=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),4)
			s WordsState=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),5)
			s UpdateUser=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),6)
			s UpdateDate=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),7)
			s AuditUser=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),8)
			s AuditDate=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),9)
			s SplitState=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),10)
			s Remarks=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),11)
			s QuoteFlag=""
			s Flag=..GetQuoteFlag(WordsRowId)
			continue:(Quote'="")&&(Quote'=Flag)
			if (Flag=0){
				s QuoteFlag="否"
			}else{
				s QuoteFlag="是"
			}
			s UpdateDateUDate="", UpdateDateUTime=""
			if (UpdateDate'="")
			{ 
				s UpdateDateU=$ZDTH(UpdateDate,3)
				s UpdateDateUDate=$p(UpdateDateU,",",1)
				s UpdateDateUTime=$p(UpdateDateU,",",2)
			}	
			
			s SUpdateDateFlag=1
			if (SUpdateDate'="")
			{
				s SUpdateDateU=$ZDTH(SUpdateDate,3)
				s SUpdateDateUDate=$p(SUpdateDateU,",",1)
				s SUpdateDateUTime=$p(SUpdateDateU,",",2)
				if (SUpdateDateUDate>UpdateDateUDate)||((SUpdateDateUDate=UpdateDateUDate)&(SUpdateDateUTime>UpdateDateUTime))
				{
					s SUpdateDateFlag=0	
				}
			}
			s EUpdateDateFlag=1
			if (EUpdateDate'="")
			{
				s EUpdateDateU=$ZDTH(EUpdateDate,3)
				s EUpdateDateUDate=$p(EUpdateDateU,",",1)
				s EUpdateDateUTime=$p(EUpdateDateU,",",2)
				if (EUpdateDateUDate<UpdateDateUDate)||((EUpdateDateUDate=UpdateDateUDate)&(EUpdateDateUTime<UpdateDateUTime))
				{
					s EUpdateDateFlag=0	
				}
			}
			
			if (($ZCONVERT(WordsDesc,"U")[desc))&&($ZCONVERT(SplitState,"U")[SState)&&($ZCONVERT(WordsState,"U")[WState)&&($ZCONVERT(AuditUser,"U")[AUser)
			&&($ZCONVERT(UpdateUser,"U")[UUser)&&(SUpdateDateFlag=1)&&(EUpdateDateFlag=1)&&((WType="")||((WType'="")&(WordsType=WType)))	//过滤条件
			{
				/*s QuoteFlag=""
				s Flag=..GetQuoteFlag(WordsRowId)
				if (Quote'=""){
					if (Quote="0"){		//查未被引用的，过滤被引用的
						continue:Flag=1	
						s QuoteFlag="否"
					} elseif(Quote="1"){	//查被引用的，过滤未被引用的
						continue:Flag=0
						s QuoteFlag="是"
					}
				}else{
					if (Flag=0){
						s QuoteFlag="否"
					}else{
						s QuoteFlag="是"
					}
				}*/
				if ((total+1<stpage)||(total+1>endpage)){ //如果不是当前页，则只计数，不输出
					s total=total+1
					continue
					
				}	
				s total=total+1
				s mainstr=""
				s mainstr="{""WordsRowId"":"""_WordsRowId_""",""WordsCode"":"""_WordsCode_""",""WordsDesc"":"""_WordsDesc_""",""WordsType"":"""_WordsType_""",""WordsState"":"""_WordsState
					_""",""UpdateUser"":"""_UpdateUser_""",""UpdateDate"":"""_UpdateDate_""",""AuditUser"":"""_AuditUser
					_""",""AuditDate"":"""_AuditDate_""",""SplitState"":"""_SplitState_""",""Remarks"":"""_Remarks_""",""QuoteFlag"":"""_QuoteFlag_"""}"
				 	
				if (jsonstr'="")
				{ 
					w ","
					s jsonstr=jsonstr_","_mainstr
				}
				else
				{
					s jsonstr=mainstr
				}
				w mainstr
			}
		}
	}
	 
}
 w "], ""total"":"_total_"}"
 Q ""
}

/// Creator:赵文伟
/// CreatDate:2022-09-16
/// Description:识别词被引用,只返回引用标志
/// Table: CT.WDT.CDSS.IdentifyWords
/// Input: 识别词id
/// Return: 引用该识别词的规则id、规则所属菜单名、规则描述
/// Other: w ##class(web.CDSS.CMKB.IdentifyWords).GetQuoteFlag("10506")
ClassMethod GetQuoteFlag(WordsRowId As %String) As %String
{
	if WordsRowId="" q
	s flag=0
	s WordsDesc=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),3)
	s WordsType=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),4)
	s QuoteStr=""
	if ($d(^CT.WDT.CDSS.RuleConditionI("ValueIndex",WordsDesc))){
		
		s RuleConditionDR=""
		for
		{
			s RuleConditionDR = $O(^CT.WDT.CDSS.RuleConditionI("ValueIndex",WordsDesc,RuleConditionDR))  q:RuleConditionDR=""
			
			s NodeDR = $lg($g(^CT.WDT.CDSS.RuleConditionD(RuleConditionDR)),2)
			s NodeTypeDR=""
			s:NodeDR'="" NodeTypeDR = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),5)	 //节点类型
			s RuleTypeDR=""
			s:NodeDR'="" RuleTypeDR  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),10)
			s ConditionItemCategory=$lg($g(^CT.WDT.CDSS.RuleConditionD(RuleConditionDR)),10)
			continue:(((WordsType["中医")&&(ConditionItemCategory'="中医"))||((WordsType'["中医")&&(ConditionItemCategory="中医")))
			if (NodeTypeDR=6)||(NodeTypeDR=7)||(NodeTypeDR=31)||(NodeTypeDR=5)||(NodeTypeDR=27){	//主要条件-识别词||否定条件-识别词||通过条件||诊断条件||否定条件—诊断
				
				continue:((WordsType="诊断条件")&&((NodeTypeDR=6)||(NodeTypeDR=7)||(NodeTypeDR=31)))
				continue:((WordsType="识别条件")&&((NodeTypeDR=5)||(NodeTypeDR=27)))
				s RuleDR = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),2)
				s RuleDesc=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleDR)),3)
				
				if (RuleDesc'="") s flag=1
				q:flag=1
				
			}		
		}
	}
	q flag
}

/// Creator:zww
/// CreatDate:2022-10-11 
/// Description：处理'\'导致的JSON解析问题[对数据特殊字符处理\转换成\\  英文的双引号转换成\"]
/// Input：instr -输入的字符串
/// Return:mystr -处理特殊字符后的字符串
/// Other:w ##class(web.CDSS.CMKB.IdentifyWords)EvalJSONW("")      
ClassMethod EvalJSONW(instr As %String) As %String
{
	s mystr = instr
	q:(mystr="") mystr	
	s mystr = ##class(web.BDP.util.String).Replace(mystr,"\","\\")
	//s mystr = ##class(web.BDP.util.String).Replace(mystr,"""","\""")
	//不保留回车换行
	s mystr = ##class(web.CDSS.CMKB.FunLib).TransLinefeed(mystr,"")	
	//s mystr= ##class(web.DHCBL.BDP.FunLib).Util(mystr)	//处理字符串里的不可见字符
	q mystr
}

/// Creator：丁亚男
/// CreatDate: 2020-06-03
/// Description：查询 识别词
/// Table：CT.WDT.CDSS.IdentifyWords
/// Input：rowid, desc
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.IdentifyWords","GetDataForCmb4","","","")
Query GetDataForCmb4(rowid As %String, desc As %String, q As %String) As %Query(ROWSPEC = "WordsRowId:%String,WordsDesc:%String,WordsType,WordsDR")
{
}

ClassMethod GetDataForCmb4Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String, q As %String) As %Status
{
	
	s repid=$I(^CacheTemp)
	s ind=1
	if (rowid'="") //根据rowid返回该条记录
	{
		s WordsRowId=rowid
		s WordsDesc=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),3)
		d OutputRowCmb
	}
	else
	{
		s:q'="" desc=q	
		//s:q'="" desc=$ZCONVERT(q,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		
		k ^TempDataHandle($ZNAME,repid,$JOB,"Short")
		
  		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.IdentifyWordsD(ID))
			q:ID=""
			s WordsDesc=$lg($g(^CT.WDT.CDSS.IdentifyWordsD(ID)),3)		//名称
			//continue:((desc'="")&&($ZCONVERT(WordsDesc,"U")'[desc))
			s length=$l(WordsDesc)
			s ^TempDataHandle($ZNAME,repid,$JOB,"Short",length,ID)=ID
		}
		s le=0
		s num=0
		for
		{
			s le=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le))
			q:le=""
			s WordsRowId=0
			for
			{
				s WordsRowId=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le,WordsRowId)) q:WordsRowId=""
				s WordsDR=WordsRowId
				s WordsDesc=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),3)
				s WordsType=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),4)
				s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(WordsDesc)  
				
				if ((($ZCONVERT(WordsDesc,"U")[desc)||(PINYIN[desc))) {
					s num=num+1
					d OutputRowCmb
				}
				
				q:num=1000
				
			}
	        q:num=1000
		}
		k ^TempDataHandle($ZNAME,repid,$JOB,"Short")
	}
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb
    set Data=$lb(WordsRowId,WordsDesc,WordsType,WordsDR)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb4Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb4Execute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
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

ClassMethod GetDataForCmb4Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb4Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：丁亚男
/// CreatDate: 2023-04-03
/// Description：查询 同名识别词拆分来自诊断相关项目（诊断症状、既往史等）的诊断条件识别词
/// Table：CT.WDT.CDSS.IdentifyWords
/// Input：WordsDR
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.IdentifyWords","GetDataForCmb5","24397")
Query GetDataForCmb5(WordsDR As %String) As %Query(ROWSPEC = "WordsRowId:%String,WordsDesc:%String,WordsType:%String")
{
}

ClassMethod GetDataForCmb5Execute(ByRef qHandle As %Binary, WordsDR As %String) As %Status
{
	
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (WordsDR'="")&($d(^CT.WDT.CDSS.IdentifyWordsD(WordsDR))) 
	{
		s Type=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsDR)),4)
		s WordsType="西医"
		if (Type["中医")
		{
			s WordsType="中医"
		}
		s NodeTypeDR=$O(^CT.WDT.CDSS.NodeTypeI("DescIndex"," 主要条件-识别词",""))
		if (NodeTypeDR'="")
		{
			s NodeDR=0
			for 
			{
				s NodeDR=$O(^CT.WDT.CDSS.WordsNodeI("WordsTypeIndex",WordsDR,NodeTypeDR,NodeDR)) q:NodeDR=""
				s ConditionDR=0
				for 
				{
					s ConditionDR=$O(^CT.WDT.CDSS.WordsConditionI("NodeDRIndex",NodeDR,ConditionDR)) q:ConditionDR=""
					s WordsItemDR  = $lg($g(^CT.WDT.CDSS.WordsConditionD(ConditionDR)),3)
					s WordsItemDRN=""
					s:WordsItemDR'="" WordsItemDRN= $lg($g(^CT.WDT.CDSS.WordsItemD(WordsItemDR)),3)
					continue:WordsItemDRN'["诊断"
					s ConditionItemValue  = $lg($g(^CT.WDT.CDSS.WordsConditionD(ConditionDR)),9)
					continue:ConditionItemValue=""
					s WordsDesc=ConditionItemValue
					if (WordsType="中医")&&($d(^CT.WDT.CDSS.IdentifyWordsI("DescTypeIndex",ConditionItemValue,"中医诊断条件")))
					{
						s WordsRowId=$O(^CT.WDT.CDSS.IdentifyWordsI("DescTypeIndex",ConditionItemValue,"中医诊断条件",""))
						d OutputRowCmb
					}
					elseif (WordsType="西医")&&($d(^CT.WDT.CDSS.IdentifyWordsI("DescTypeIndex",ConditionItemValue,"诊断条件")))
					{
						s WordsRowId=$O(^CT.WDT.CDSS.IdentifyWordsI("DescTypeIndex",ConditionItemValue,"诊断条件",""))
						d OutputRowCmb
					}
		
				}
				
			}
			
		}
		
		
		
	}
	
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb
    set Data=$lb(WordsRowId,WordsDesc,WordsType)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb5Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb5Execute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
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

ClassMethod GetDataForCmb5Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb5Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
