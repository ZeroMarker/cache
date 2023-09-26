/// Description：诊疗规则管理
/// Table：CT.WDT.CDSS.RuleDict
Class web.CDSS.CMKB.RuleDict Extends %RegisteredObject
{

/// Creator：丁亚男
/// CreatDate: 2021-01-05
/// Description：查询诊疗规则管理
/// Table：CT.WDT.CDSS.RuleDict
/// Input：desc 
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.RuleDict","GetList","","","","","","","","","","","","","","")
Query GetList(rowid, desc, Loc, Source, UUser, AUser, BNum, Status, RType As %String, SUpdateDate, EUpdateDate, Provision, inputSource, diagCon) As %Query(ROWSPEC = "RuleRowId,RuleCode,RuleDesc,RuleLocDRs,RuleLoc,RuleSourceDRs,RuleSource,RuleTypeDR,RuleType,BatchNum,RuleStatus,UpdateUser,UpdateDate,AuditUser,AuditDate,Remarks,Statisticsstr,RuleProvision")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, desc, Loc, Source, UUser, AUser, BNum, Status, RType, SUpdateDate, EUpdateDate, Provision, inputSource, diagCon) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 if (rowid'="") //根据rowid返回该条记录
 {
	s RuleRowId=rowid
	s RuleCode=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),2)
	s RuleDesc=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),3)
	s RuleLocDRs=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),4)
	s RuleLoc=""
	if (RuleLocDRs'="")
 	{
	 	s LocLen=$L(RuleLocDRs,"&%")
	 	for iLoc=1:1:LocLen
	 	{
		 	s LocDR=$p(RuleLocDRs,"&%",iLoc)
		 	s:RuleLoc'="" RuleLoc=RuleLoc_"，"_$lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(LocDR)),3)
		 	s:RuleLoc="" RuleLoc=$lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(LocDR)),3)
		}
	}
	s RuleSourceDRs=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),5)
	s RuleSource=RuleSourceDRs
	/*if (RuleSourceDRs'="")
 	{
	 	s SourceLen=$L(RuleSourceDRs,"，")
	 	for iSource=1:1:SourceLen
	 	{
		 	s SourceDR=$p(RuleSourceDRs,"，",iSource)
		 	s:RuleSource'="" RuleSource=RuleSource_"，"_$lg($g(^CT.WDT.CDSS.DocuManageD(SourceDR)),3)
		 	s:RuleSource="" RuleSource=$lg($g(^CT.WDT.CDSS.DocuManageD(SourceDR)),3)
		}
	}*/
	s RuleTypeDR=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),6)
	s RuleType=""
	s:RuleTypeDR'="" RuleType=$LISTGET($G(^CT.WDT.CDSS.ChartTypeD(RuleTypeDR)),3)
	s BatchNum=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),7)
	s RuleStatus=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),8)
	s UpdateUser=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),9)
	s UpdateDate=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),10)
	s AuditUser=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),11)
	s AuditDate=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),12)
	s Remarks=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),13)
	s RuleProvision=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),14)
	s Statisticsstr=""
	if (RType="1")
	{
		
		if $d(^CT.WDT.CDSS.RuleNodeI("RuleTypeDRIndex",RuleRowId))
		{
			
			s RuleTypeDR1=""
			for 
			{
				s RuleTypeDR1=$o(^CT.WDT.CDSS.RuleNodeI("RuleTypeDRIndex",RuleRowId,RuleTypeDR1)) q:RuleTypeDR1="" 
				if (RuleTypeDR1=-100000000000000 )
				{
					s ChartTypeDesc="推荐治疗方案"
				}
				else
				{
					s ChartTypeDesc=$LISTGET($G(^CT.WDT.CDSS.ChartTypeD(RuleTypeDR1)),3)
				}
				s count=0
				s NodeRowId=0
				for 
				{
					s NodeRowId=$o(^CT.WDT.CDSS.RuleNodeI("RuleTypeDRIndex",RuleRowId,RuleTypeDR1,NodeRowId)) q:NodeRowId="" 
					s NodeType=$LISTGET($G(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),5)
					s NodeTypeDesc=""
					s:NodeType'="" NodeTypeDesc=$LISTGET($G(^CT.WDT.CDSS.NodeTypeD(NodeType)),3)
					
					if (NodeTypeDesc="结束")
					{
						s count=count+1
					}
				}
				s:Statisticsstr'="" Statisticsstr=Statisticsstr_"#"_ChartTypeDesc_"&"_count
				s:Statisticsstr="" Statisticsstr=ChartTypeDesc_"&"_count
			}
		}
	}else{
				s RuleTypeDR1=""
				for 
				{
					s RuleTypeDR1=$o(^CT.WDT.CDSS.RuleNodeI("RuleTypeDRIndex",RuleRowId,RuleTypeDR1)) q:RuleTypeDR1="" 

					s ChartTypeDesc=""

					s count=0
					s NodeRowId=0
					for 
					{
						s NodeRowId=$o(^CT.WDT.CDSS.RuleNodeI("RuleTypeDRIndex",RuleRowId,RuleTypeDR1,NodeRowId)) q:NodeRowId="" 
						s NodeType=$LISTGET($G(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),5)
						s NodeTypeDesc=""
						s:NodeType'="" NodeTypeDesc=$LISTGET($G(^CT.WDT.CDSS.NodeTypeD(NodeType)),3)
						
						if (NodeTypeDesc="结束")
						{
							s count=count+1
						}
					}
					s:Statisticsstr="" Statisticsstr=count
				}
		}


	d OutputRow
 }
 else
 {
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写 
	s:UUser'="" UUser=$ZCONVERT(UUser,"U")
	s:AUser'="" AUser=$ZCONVERT(AUser,"U")
	s:BNum'="" BNum=$ZCONVERT(BNum,"U")
	s:Provision'="" Provision=$ZCONVERT(Provision,"U")
	s:diagCon'="" diagCon=$ZCONVERT(diagCon,"U")
	s inputSource = $case(inputSource,"循证西医":"dhcc-西医","循证中医":"dhcc-中医","单病种":"sds",:inputSource) 
	s:inputSource'="" inputSource=$ZCONVERT(inputSource,"U")
	s date=""
	for{
		s date=$o(^CT.WDT.CDSS.RuleDictI("DateIndex",date),-1) q:date=""
		s RuleRowId=""
		for
		{ 
			s RuleRowId=$o(^CT.WDT.CDSS.RuleDictI("DateIndex",date,RuleRowId),-1) q:RuleRowId="" 
			
			s RuleCode=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),2)
			s RuleDesc=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),3)
			s RuleLocDRs=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),4)
			s RuleLoc="" ,LocFlag=0
			if (RuleLocDRs'="")
		 	{
			 	s LocLen=$L(RuleLocDRs,"&%")
			 	for iLoc=1:1:LocLen
			 	{
				 	s LocDR=$p(RuleLocDRs,"&%",iLoc)
				 	if (LocDR=Loc) s LocFlag=1 
				 	s:RuleLoc'="" RuleLoc=RuleLoc_"，"_$lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(LocDR)),3)
				 	s:RuleLoc="" RuleLoc=$lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(LocDR)),3)
				}
			}
			s RuleSourceDRs=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),5)
			s RuleSource=RuleSourceDRs/*,SourceFlag=0
			if (RuleSourceDRs'="")
		 	{
			 	s SourceLen=$L(RuleSourceDRs,"，")
			 	for iSource=1:1:SourceLen
			 	{
				 	s SourceDR=$p(RuleSourceDRs,"，",iSource)
				 	if (SourceDR=Source) s SourceFlag=1 
				 	s:RuleSource'="" RuleSource=RuleSource_"，"_$lg($g(^CT.WDT.CDSS.DocuManageD(SourceDR)),3)
				 	s:RuleSource="" RuleSource=$lg($g(^CT.WDT.CDSS.DocuManageD(SourceDR)),3)
				}
			}*/
			s RuleTypeDR=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),6)
			s RuleType=""
			s:RuleTypeDR'="" RuleType=$LISTGET($G(^CT.WDT.CDSS.ChartTypeD(RuleTypeDR)),3)
			s BatchNum=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),7)
			s RuleStatus=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),8)
			s UpdateUser=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),9)
			s UpdateDate=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),10)
			s AuditUser=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),11)
			s AuditDate=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),12)
			s Remarks=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),13)
			s RuleProvision=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),14)
			if (inputSource'=""){
				continue:($ZCONVERT(RuleProvision,"U")'=inputSource)
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
			s Statisticsstr=""
			
			if (RType="1")
			{
				if $d(^CT.WDT.CDSS.RuleNodeI("RuleTypeDRIndex",RuleRowId))
				{
					s RuleTypeDR1=""
					for 
					{
						s RuleTypeDR1=$o(^CT.WDT.CDSS.RuleNodeI("RuleTypeDRIndex",RuleRowId,RuleTypeDR1)) q:RuleTypeDR1="" 
						if (RuleTypeDR1=-100000000000000 )
						{
							s ChartTypeDesc="推荐治疗方案"
						}
						else
						{
							s ChartTypeDesc=$LISTGET($G(^CT.WDT.CDSS.ChartTypeD(RuleTypeDR1)),3)
						}
						s count=0
						s NodeRowId=0
						for 
						{
							s NodeRowId=$o(^CT.WDT.CDSS.RuleNodeI("RuleTypeDRIndex",RuleRowId,RuleTypeDR1,NodeRowId)) q:NodeRowId="" 
							s NodeType=$LISTGET($G(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),5)
							s NodeTypeDesc=""
							s:NodeType'="" NodeTypeDesc=$LISTGET($G(^CT.WDT.CDSS.NodeTypeD(NodeType)),3)
							if (NodeTypeDesc="结束")
							{
								s count=count+1
							}
						}
						s:Statisticsstr'="" Statisticsstr=Statisticsstr_"#"_ChartTypeDesc_"&"_count
						s:Statisticsstr="" Statisticsstr=ChartTypeDesc_"&"_count
					}
				}
			}else{
				
				s RuleTypeDR1=""
				for 
				{
					s RuleTypeDR1=$o(^CT.WDT.CDSS.RuleNodeI("RuleTypeDRIndex",RuleRowId,RuleTypeDR1)) q:RuleTypeDR1="" 
					
					s ChartTypeDesc=""

					s count=0
					s NodeRowId=0
					for 
					{
						s NodeRowId=$o(^CT.WDT.CDSS.RuleNodeI("RuleTypeDRIndex",RuleRowId,RuleTypeDR1,NodeRowId)) q:NodeRowId="" 
						s NodeType=$LISTGET($G(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),5)
						s NodeTypeDesc=""
						s:NodeType'="" NodeTypeDesc=$LISTGET($G(^CT.WDT.CDSS.NodeTypeD(NodeType)),3)
						
						if (NodeTypeDesc="结束")
						{
							s count=count+1
						}
					}
					s:Statisticsstr="" Statisticsstr=count
				}
			}
			
			if (($ZCONVERT(RuleDesc,"U")[desc))&&(((Loc'="")&&(LocFlag=1))||(Loc=""))&&(((Source'="")&&(RuleSourceDRs[Source))||(Source=""))&&($ZCONVERT(AuditUser,"U")[AUser)&&($ZCONVERT(UpdateUser,"U")[UUser)&&($ZCONVERT(RuleProvision,"U")[Provision)
			&&($ZCONVERT(RuleStatus,"U")[Status)&&($ZCONVERT(BatchNum,"U")[BNum)&&(((RType'="")&&(RuleTypeDR=RType))||(RType=""))&&(SUpdateDateFlag=1)&&(EUpdateDateFlag=1)	//过滤条件
			{
				if (RType=1)&&(diagCon'=""){		//Add By ZWW 2022-08-25
					s DiagNodeType=5	//主要条件-诊断
					s flagDia=0
					s NodeRowId=""
					for{
						s NodeRowId = $o(^CT.WDT.CDSS.RuleNodeI("RuleDRNodeTypeIndex",RuleRowId,DiagNodeType,NodeRowId)) q:NodeRowId=""
						if (flagDia=1) q
						s ConditionRowId=""
						for{
							s ConditionRowId = $o(^CT.WDT.CDSS.RuleConditionI("NodeDRIndex",NodeRowId,ConditionRowId),-1) q:ConditionRowId=""
							if (flagDia=1) q
							s ConditionItemValue  = $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowId)),6)
							if ($ZCONVERT(ConditionItemValue,"U")[diagCon){
								s flagDia=1
								d OutputRow
							}
						}
					}
				}elseif (diagCon'=""){
					s DiagNodeType=6	//主要条件—识别词
					s flagDia=0
					s NodeRowId=""
					for{
						s NodeRowId = $o(^CT.WDT.CDSS.RuleNodeI("RuleDRNodeTypeIndex",RuleRowId,DiagNodeType,NodeRowId)) q:NodeRowId=""
						if (flagDia=1) q
						s ConditionRowId=""
						for{
							s ConditionRowId = $o(^CT.WDT.CDSS.RuleConditionI("NodeDRIndex",NodeRowId,ConditionRowId),-1) q:ConditionRowId=""
							if (flagDia=1) q
							s ConditionItemValue  = $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowId)),6)
							if ($ZCONVERT(ConditionItemValue,"U")[diagCon){
								s flagDia=1
								d OutputRow
							}
						}
					}
				}else{
					d OutputRow
				}
			}
		}
	}
}
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(RuleRowId,RuleCode,RuleDesc,RuleLocDRs,RuleLoc,RuleSourceDRs,RuleSource,RuleTypeDR,RuleType,BatchNum,RuleStatus,UpdateUser,UpdateDate,AuditUser,AuditDate,Remarks,Statisticsstr,RuleProvision)
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
/// CreateDate:2021-01-05    
/// w ##class(web.CDSS.CMKB.RuleDict).FormValidate("","","")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, desc As %String, type As %String) As %String
{
	s flag="",flagd=""
	s:desc'="" flagd=$d(^CT.WDT.CDSS.RuleDictI("TypeDescIndex",type,desc))
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagd>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idd=""
		s:desc'="" idd=$o(^CT.WDT.CDSS.RuleDictI("TypeDescIndex",type,desc,0))
		
		if ((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志

	}
	q flag
}

/// Creator：丁亚男
/// CreatDate: 2021-01-05
/// Description:代码自动生成  GZ00001 代码最大值加1
/// Other: w ##class(web.CDSS.CMKB.RuleDict).GetLastCode()
ClassMethod GetLastCode() As %String
{
  	s CodeLen=7    //代码长度
  	s StartCode="GZ"  //代码起始字符
  	s code=""
	s StartCodeLen=$Length(StartCode)
	s RuleRowId="", preCode=""    //寻找符合规则的最大的代码
	for {
		s RuleRowId=$o(^CT.WDT.CDSS.RuleDictD(RuleRowId),-1) q:RuleRowId=""
		s RuleCode=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),2)
		if ($e(RuleCode,1,StartCodeLen)=StartCode)
		{
			s preCode=RuleCode
			q
		}
		
	}
	if (preCode="")   //如果没有符合规则的代码，则生成第一个
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
/// Table：CT.WDT.CDSS.RuleDict
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.RuleDict).SaveEntity()
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.RuleDict) As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{ 
		s eobj.RuleDesc=$Zstrip(eobj.RuleDesc,"<>W")
		s flag=..FormValidate(eobj.RuleRowId,eobj.RuleDesc,eobj.RuleType)
		if (flag=1)	 //校验重复
		{
			q "{success:'false',errorinfo:'该记录已存在！'}"
		}
		
		if (eobj.BatchNum'=""){		//校验批次号 ZWW 2023-03-13
			s tag=$MATCH(eobj.BatchNum,"^[0-9]*[1-9][0-9]*$")
			if (tag=0){
				q "{success:'false',errorinfo:'批次号不合法！'}"
			}
		}

		if (eobj.RuleRowId="")  //如果RowId未赋值则增加
		{ 
			s obj=##class(CT.WDT.CDSS.RuleDict).%New() 
			s eobj.RuleCode=..GetLastCode()
		}
		else   //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.RuleDict).%OpenId(eobj.RuleRowId)
			s bobj = ##class(web.CDSSEntity.CMKB.RuleDict).%New() 
			s bobj.RuleCode = obj.RuleCode  
			s bobj.RuleDesc = obj.RuleDesc  
			s bobj.RuleLoc = obj.RuleLoc 
			s bobj.RuleSource = obj.RuleSource 
			if $IsObject(obj.RuleType)
			{
			 	s bobj.RuleType = obj.RuleType.%Id()
			}
			s bobj.BatchNum = obj.BatchNum
			s bobj.RuleStatus = obj.RuleStatus
			s bobj.UpdateUser = obj.UpdateUser 
			s bobj.UpdateDate = obj.UpdateDate
			s bobj.AuditUser = obj.AuditUser
			s bobj.AuditDate = obj.AuditDate
			s bobj.Remarks = obj.Remarks
			s eobj.RuleCode=obj.RuleCode
			s bobj.RuleProvision=obj.RuleProvision
		}
		s eobj.UpdateUser="dhcc"
		if ($d(%session))
		{
			s eobj.UpdateUser=$g(%session.Data("LOGON.USERNAME"))
		}
		s eobj.UpdateDate=$zdt($h,3)
		s obj.RuleCode = eobj.RuleCode  
		s obj.RuleDesc = eobj.RuleDesc  
		s obj.RuleLoc = eobj.RuleLoc 
		s obj.RuleSource = eobj.RuleSource 
		d:eobj.RuleType'="" obj.RuleTypeSetObjectId(eobj.RuleType)
		s obj.BatchNum = eobj.BatchNum
		s obj.RuleStatus = eobj.RuleStatus
		s obj.UpdateUser =eobj.UpdateUser 
		s obj.UpdateDate = eobj.UpdateDate
		s obj.AuditUser = eobj.AuditUser
		s obj.AuditDate = eobj.AuditDate
		s obj.Remarks = eobj.Remarks
		s obj.RuleProvision=eobj.RuleProvision
		
			
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" 
			//保存日志
			d:eobj.RuleRowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.RuleDict","CT.WDT.CDSS.RuleDict","诊疗规则管理",id,eobj.RuleDesc,"A",eobj)
			d:eobj.RuleRowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.RuleDict","CT.WDT.CDSS.RuleDict","诊疗规则管理",eobj.RuleRowId,eobj.RuleDesc,"U",eobj,bobj)
			
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("诊疗规则管理","web.CDSS.CMKB.RuleDict","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"  
	} 
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("诊疗规则管理","web.CDSS.CMKB.RuleDict","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator:丁亚男
/// CreatDate:2021-1-14
/// Input:RowId 规则ID Status 状态
/// Return:
/// Other:w ##class(web.CDSS.CMKB.RuleDict).ChangeStatus("9707","提交")
ClassMethod ChangeStatus(RowId, Opreation)
{
	s result="{success:'true'}"
	s eobj = ##class(web.CDSSEntity.CMKB.RuleDict).%New()
	if (Opreation="提交") s eobj.RuleStatus="待审核"
	if Opreation="上线" s eobj.RuleStatus="已上线"
	if Opreation="不通过" s eobj.RuleStatus="审核不通过"
	if Opreation="下线" s eobj.RuleStatus="已下线"
	if Opreation="编辑" s eobj.RuleStatus="编辑中"
	//点击通过时，遍历规则下每个节点（开始、结束除外）是否有内容，没有内容则不能通过
	if (Opreation="通过") 
	{
		//节点下是否有内容 1有 0无
		s ContentFlag=1
		if ($d(^CT.WDT.CDSS.RuleNodeI("RuleDRIndex",RowId)))
	    {
		    s NodeDR=0
		    for
		    {
			    s NodeDR=$O(^CT.WDT.CDSS.RuleNodeI("RuleDRIndex",RowId,NodeDR)) q:(NodeDR="")||(ContentFlag=0)
			    
			    s NodeType=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),5)
				s NodeTypeDesc=""
				s:NodeType'="" NodeTypeDesc=$lg($g(^CT.WDT.CDSS.NodeTypeD(NodeType)),3)
				
				if (NodeTypeDesc="推荐检验/检查")||(NodeTypeDesc="推荐评估表")||(NodeTypeDesc="推荐护理措施")||(NodeTypeDesc="推荐治疗方案")||(NodeTypeDesc="推荐确诊")||(NodeTypeDesc="推荐鉴别诊断")||(NodeTypeDesc="推荐住院")
				{
					//节点下是否有内容
					if ('$d(^CT.WDT.CDSS.RuleResultI("NodeDRIndex",NodeDR)))
				    {
					  s ContentFlag=0  
				    }
					
				}
				elseif (NodeTypeDesc="推荐治疗方案-药品")||(NodeTypeDesc="推荐治疗方案-手术")
				{
					//节点下是否有内容
					if ('$d(^CT.WDT.CDSS.RuleDetailI("NodeDRIndex",NodeDR)))
				    {
					  s ContentFlag=0  
				    }
				}
				elseif (NodeTypeDesc="基本信息-年龄")||(NodeTypeDesc="基本信息-性别")||(NodeTypeDesc="主要条件-诊断")||(NodeTypeDesc="主要条件-识别词")||(NodeTypeDesc="否定条件-识别词")
				{
					//节点下是否有内容
					if ('$d(^CT.WDT.CDSS.RuleConditionI("NodeDRIndex",NodeDR)))
				    {
					  s ContentFlag=0  
				    }
				}
				if (ContentFlag=0){
				   s FlowChartNum=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),3)
				   s NodeNum=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),4)
				   s RuleTypeDR=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),10)
				   if (RuleTypeDR=""){
				   		s RuleTypeDRDesc="推荐治疗方案"
				   }else{
				   		s RuleTypeDRDesc=$lg($g(^CT.WDT.CDSS.ChartTypeD(RuleTypeDR)),3)
				   }
				}
			}
	    }
	    s statusFalse = 0
	    if (ContentFlag=1)
	    {
			s eobj.RuleStatus="审核通过"
	    }
	    else
	    {
		   s eobj.RuleStatus="审核不通过" 
		}
	}
	
	
	if Opreation="驳回" s eobj.RuleStatus="编辑中"
	 	
 	s obj=##class(CT.WDT.CDSS.RuleDict).%OpenId(RowId)
 	s bobj = ##class(web.CDSSEntity.CMKB.RuleDict).%New()
	s bobj.RuleStatus=obj.RuleStatus
	s bobj.UpdateDate=obj.UpdateDate
	s bobj.AuditDate=obj.AuditDate
	s bobj.UpdateUser=obj.UpdateUser
	s bobj.AuditUser=obj.AuditUser
	s UpdateUserName=%session.Get("LOGON.USERNAME")         //当前用户

 	if ((Opreation="提交")||(Opreation="编辑")){
	 	s obj.UpdateUser=UpdateUserName
 		s obj.UpdateDate=$zdt($h,3)
 		
	} elseif ((Opreation="审核")||(Opreation="不通过")||(Opreation="通过")||(Opreation="驳回")){
 		s obj.AuditUser=UpdateUserName
 		s obj.AuditDate=$zdt($h,3)
	}

	if ((Opreation'="审核") && (Opreation'="编辑")){
 		s obj.RuleStatus=eobj.RuleStatus
	}
	if (eobj.RuleStatus="审核通过")
	{
		s obj.BatchNum=$zd($h,8)
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
			s rtn= ##class(web.CDSS.CMKB.RuleIndex).CreateRuleIndexById(id,1)
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
			s rtn=##class(web.CDSS.CMKB.RuleIndex).DeleteRuleIndexById(id)
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
		if (Opreation="通过"){
			if (ContentFlag=0){
		   		s result = "{success:'true',errorinfo:'"_RuleTypeDRDesc_"中第"_FlowChartNum_"条线中的第"_NodeNum_"个节点（"_NodeTypeDesc_"）没有内容'}"  //返回错误信息

			}
		}
		//保存日志 描述拼接操作，在日志中读取显示
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.RuleDict","CT.WDT.CDSS.RuleDict","诊疗规则管理",RowId,obj.RuleDesc_"&&"_eobj.RuleStatus,"U",eobj,bobj)  
		
	}
	else
	{
		Trollback
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("诊疗规则管理","web.CDSS.CMKB.RuleDict","ChangeStatus",eobj)
   		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	
	q result
}

/// Creator：丁亚男
/// CreatDate: 2021-01-05
/// Description：数据打开方法
/// Table：CT.WDT.CDSS.RuleDict
/// Input：RowId
/// Return:Json
/// Other: w ##class(web.CDSS.CMKB.RuleDict).OpenData("3")
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s obj=##class(CT.WDT.CDSS.RuleDict).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.RuleDict).%New() 
	s bobj.RuleCode = obj.RuleCode  
	s bobj.RuleDesc = obj.RuleDesc  
	s bobj.RuleLoc = obj.RuleLoc 
	s bobj.RuleSource = obj.RuleSource 
	if $IsObject(obj.RuleType)
	{
	 	s bobj.RuleType = obj.RuleType.%Id()
	}
	s bobj.BatchNum = obj.BatchNum
	s bobj.RuleStatus = obj.RuleStatus
	s bobj.UpdateUser = obj.UpdateUser 
	s bobj.UpdateDate = obj.UpdateDate
	s bobj.AuditUser = obj.AuditUser
	s bobj.AuditDate = obj.AuditDate
	s bobj.Remarks = obj.Remarks
	s bobj.RuleProvision = obj.RuleProvision
	d obj.%Close()	
	k obj	
	
	s str = bobj.JsonS()	
	q str
}

/// Creator:丁亚男
/// CreatDate:2021-01-05
/// Description:数据删除方法
/// Table: CT.WDT.CDSS.RuleDict
/// Input: id 
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.RuleDict).DeleteData("1")
ClassMethod DeleteData(id As %String)
{
	s result=""
	
	Ts
	s obj=##class(CT.WDT.CDSS.RuleDict).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.RuleDict).%New() 
	s bobj.RuleCode = obj.RuleCode  
	s bobj.RuleDesc = obj.RuleDesc  
	s bobj.RuleLoc = obj.RuleLoc 
	s bobj.RuleSource = obj.RuleSource 
	if $IsObject(obj.RuleType)
	{
	 	s bobj.RuleType = obj.RuleType.%Id()
	}
	s bobj.BatchNum = obj.BatchNum
	s bobj.RuleStatus = obj.RuleStatus
	s bobj.UpdateUser = obj.UpdateUser 
	s bobj.UpdateDate = obj.UpdateDate
	s bobj.AuditUser = obj.AuditUser
	s bobj.AuditDate = obj.AuditDate
	s bobj.Remarks = obj.Remarks
	s bobj.RuleProvision = obj.RuleProvision
	
	//删除节点
	s NodeRowId=0,resultstr=""
	for 
	{
		s NodeRowId = $o(^CT.WDT.CDSS.RuleNodeI("RuleDRIndex",id,NodeRowId)) q:NodeRowId=""
		s Noderesult=##class(web.CDSS.CMKB.RuleNode).DeleteData(NodeRowId)  //删除节点及节点连线
		s:resultstr'="" resultstr=resultstr_","_Noderesult
		s:resultstr="" resultstr=Noderesult
	}
	//删除流程图表
	s ChartRowId=0,resultstr=""
	for 
	{
		s ChartRowId = $o(^CT.WDT.CDSS.RuleChartI("RuleDRIndex",id,ChartRowId)) q:ChartRowId=""
		s Chartresult=##class(web.CDSS.CMKB.RuleChart).DeleteData(ChartRowId)  //删除流程图表
		s:resultstr'="" resultstr=resultstr_","_Chartresult
		s:resultstr="" resultstr=Chartresult
	}
	
	
	s sc=##class(CT.WDT.CDSS.RuleDict).%DeleteId(id)
	if $$$ISOK(sc)&(resultstr'["false")
	{
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.RuleDict","CT.WDT.CDSS.RuleDict","诊疗规则管理",id,bobj.RuleDesc,"D",bobj)
		d bobj.%Close()
	}
	else
	{
		Tro
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("诊疗规则管理","web.CDSS.CMKB.RuleDict","DeleteData",bobj)
       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
    
	q result
}

/// Creator：丁亚男
/// CreatDate: 2020-06-03
/// Description：查询 规则
/// Table：CT.WDT.CDSS.RuleDict
/// Input：rowid, desc
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.RuleDict","GetDataForCmb1","","","","1")
Query GetDataForCmb1(rowid As %String, desc As %String, q As %String, RuleType As %String = "") As %Query(ROWSPEC = "RuleRowId:%String,RuleDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String, q As %String, RuleType As %String = "") As %Status
{
	
 s repid=$I(^CacheTemp)
 s ind=1
 if (rowid'="") //根据rowid返回该条记录
 {
  s RuleRowId=rowid
  s RuleDesc=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),3)
  s RuleTypeDR=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),6)
  d OutputRowCmb
 }
 else
 {
  s:q'="" desc=q	
  s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
  s RuleRowId=""
  for{  
	  s RuleRowId=$o(^CT.WDT.CDSS.RuleDictD(RuleRowId),-1) q:RuleRowId=""  
	  s RuleDesc=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),3)
	  s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(RuleDesc)  
	  s RuleTypeDR=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),6)
	  continue:(RuleType'="")&&(RuleTypeDR'=RuleType)
	  if (($ZCONVERT(RuleDesc,"U")[desc)||(PINYIN[desc)) {
	  	d OutputRowCmb
	  }
  }
 }
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb
    set Data=$lb(RuleRowId,RuleDesc)
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
/// CreatDate:2021-01-27
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// type:诊断、识别词、药品、手术、检查、检验、评估表、治疗方案、护理措施 id:数据项id
/// w ##class(web.CDSS.CMKB.RuleDict).GetRefFlag("方剂","695")
ClassMethod GetRefFlag(type As %String, id As %String) As %String
{
    s RuleDescStr=""
    if (type="诊断")
    {
	    s RuleDescStr1=""
	    s DiseaseName=$lg($g(^CT.WDT.CDSS.DiseaseDictD(id)),3)
	    if ($d(^CT.WDT.CDSS.RuleConditionI("ValueIndex",DiseaseName)))  //判断诊疗节点内容表（触发条件类）是否引用
	    {
		    s ConditionRowId =0
		    for
		    {
		    	s ConditionRowId = $o(^CT.WDT.CDSS.RuleConditionI("ValueIndex",DiseaseName,ConditionRowId)) q:ConditionRowId=""
			    s NodeDR  = $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowId)),2)
			    if (NodeDR'="")
				{
					s NodeType=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),5)
					s NodeTypeDesc=""
					s:NodeType'="" NodeTypeDesc=$lg($g(^CT.WDT.CDSS.NodeTypeD(NodeType)),3)
					if (NodeTypeDesc="主要条件-诊断")||(NodeTypeDesc="否定条件-诊断")
					{
						
						s RuleDR=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),2)
						s RuleDesc=""
						if (RuleDR'="")
						{
							s RuleDesc=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleDR)),3)
							s:RuleDescStr1'="" RuleDescStr1=RuleDescStr1_","_RuleDesc
							s:RuleDescStr1="" RuleDescStr1=RuleDesc
						}
					}
				}
			}
			s:RuleDescStr1'="" RuleDescStr1=RuleDescStr1_"(主要条件-诊断)"
		}
		s RuleDescStr2=""
		if ($d(^CT.WDT.CDSS.RuleComplicationI("ComplicationDRIndex",id)))  //判断诊疗节点内容表（预警规则-并发症）是否引用
	    {
		    s ComplicationRowId =0
		    for
		    {
		    	s ComplicationRowId = $o(^CT.WDT.CDSS.RuleComplicationI("ComplicationDRIndex",id,ComplicationRowId)) q:ComplicationRowId=""
			    s NodeDR  = $lg($g(^CT.WDT.CDSS.RuleComplicationD(ConditionRowId)),2)
			    if (NodeDR'="")
				{
					s RuleDR=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),2)
					s RuleDesc=""
					if (RuleDR'="")
					{
						s RuleDesc=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleDR)),3)
						s:RuleDescStr2'="" RuleDescStr2=RuleDescStr2_","_RuleDesc
						s:RuleDescStr2="" RuleDescStr2=RuleDesc
					}
				}
			}
			s:RuleDescStr2'="" RuleDescStr2=RuleDescStr2_"(并发症)"
		}
		
		s RuleDescStr3=""
		if ($d(^CT.WDT.CDSS.RuleResultI("TypeResultIndex","确诊诊断",id)))  //判断诊疗节点内容表（辅助诊疗）是否引用
	    {
		    s ResultRowId = 0
			for
			{
				s ResultRowId = $o(^CT.WDT.CDSS.RuleResultI("TypeResultIndex","确诊诊断",id,ResultRowId)) q:ResultRowId=""
			    s NodeDR  = $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),2)
			    if (NodeDR'="")
				{
					s RuleDR=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),2)
					s RuleDesc=""
					if (RuleDR'="")
					{
						s RuleDesc=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleDR)),3)
						s:RuleDescStr3'="" RuleDescStr3=RuleDescStr3_","_RuleDesc
						s:RuleDescStr3="" RuleDescStr3=RuleDesc
					}
				}
			}
			s:RuleDescStr3'="" RuleDescStr3=RuleDescStr3_"(确诊诊断)"
		}
		s RuleDescStr=RuleDescStr1_RuleDescStr2_RuleDescStr3
    }
    elseif(type="识别词")
    {
	    s WordsDesc=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(id)),3)
	    if ($d(^CT.WDT.CDSS.RuleConditionI("ValueIndex",WordsDesc)))  //判断诊疗节点内容表（触发条件类）是否引用
	    {
		    s ConditionRowId =0
		    for
		    {
		    	s ConditionRowId = $o(^CT.WDT.CDSS.RuleConditionI("ValueIndex",WordsDesc,ConditionRowId)) q:ConditionRowId=""
			    s NodeDR  = $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowId)),2)
			    if (NodeDR'="")
				{
					s NodeType=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),5)
					s NodeTypeDesc=""
					s:NodeType'="" NodeTypeDesc=$lg($g(^CT.WDT.CDSS.NodeTypeD(NodeType)),3)
					if (NodeTypeDesc["识别词")
					{
						
						s RuleDR=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),2)
						s RuleDesc=""
						if (RuleDR'="")
						{
							s RuleDesc=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleDR)),3)
							s:RuleDescStr'="" RuleDescStr=RuleDescStr_","_RuleDesc
							s:RuleDescStr="" RuleDescStr=RuleDesc
						}
					}
				}
			}
			s:RuleDescStr'="" RuleDescStr=RuleDescStr_"(识别词)"
		}
	    
	}
    elseif((type="药品")||(type="手术")||(type="治法")||(type="方剂")||(type="处置")||(type="中药")||(type="药物")||(type="腧穴")||(type="方剂组成"))	//处置明细类型：中药、药物、腧穴
    {
	   if ($d(^CT.WDT.CDSS.RuleDetailI("DrugDRIndex"," "_id)))  //判断治疗方案明细表是否引用
	    {
		    s DetailRowId = 0
			for
			{
				s DetailRowId = $o(^CT.WDT.CDSS.RuleDetailI("DrugDRIndex"," "_id,DetailRowId)) q:DetailRowId=""
				s NodeDR  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),2)
				
				if (NodeDR'="")
				{
					s LastLevel  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),12)	//父级ID
					s FDrugUse=""
					s:LastLevel'="" FDrugUse  = $lg($g(^CT.WDT.CDSS.RuleDetailD(LastLevel)),5)	//父级DrugUse
					
					s NodeType=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),5)
					s NodeTypeDesc=""
					s:NodeType'="" NodeTypeDesc=$lg($g(^CT.WDT.CDSS.NodeTypeD(NodeType)),3)
					if ((NodeTypeDesc=("推荐治疗方案-"_type))||(type="方剂组成"))&&(LastLevel="") //推荐治疗方案-方剂-方剂组成
					{
						s RuleDR=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),2)
						
						s RuleDesc=""
						if (RuleDR'="")
						{
							s RuleDesc=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleDR)),3)
							s:RuleDescStr'="" RuleDescStr=RuleDescStr_","_RuleDesc
							s:RuleDescStr="" RuleDescStr=RuleDesc
						}
					} 
					elseif (LastLevel'="")&&(FDrugUse'="")&&(FDrugUse=type){	//处置明细中被引用 处置明细类型：中药、药物、腧穴 add by zww 2023-02-07
						s RuleDR=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),2)
						s RuleDesc=""
						if (RuleDR'="")
						{
							s RuleDesc=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleDR)),3)
							s:RuleDescStr'="" RuleDescStr=RuleDescStr_","_RuleDesc
							s:RuleDescStr="" RuleDescStr=RuleDesc
						}
					}
				}
			}
		}
	    
	}
    else  //type为检查、检验、评估表、治疗方案、护理措施
    {
	   if ($d(^CT.WDT.CDSS.RuleResultI("TypeResultIndex",type,id)))  //判断诊疗节点内容表（辅助诊疗）是否引用
	    {
		    s ResultRowId = 0
			for
			{
				s ResultRowId = $o(^CT.WDT.CDSS.RuleResultI("TypeResultIndex",type,id,ResultRowId)) q:ResultRowId=""
			    s NodeDR  = $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),2)
			    if (NodeDR'="")
				{
					s RuleDR=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),2)
					s RuleDesc=""
					if (RuleDR'="")
					{
						s RuleDesc=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleDR)),3)
						s:RuleDescStr'="" RuleDescStr=RuleDescStr_","_RuleDesc
						s:RuleDescStr="" RuleDescStr=RuleDesc
					}
				}
			}
		}
	    
	}
    q RuleDescStr
}

/// Creator:丁亚男
/// CreatDate:2021-02-04
/// Description:根据规则ID获取该规则的状态变化的日志 生成临时global
/// Input: RuleRowId 规则ID
/// Return: 是否成功 
/// others:w ##class(web.CDSS.CMKB.RuleDict).CreateTEMPLogGlobal("11326")
ClassMethod CreateTEMPLogGlobal(RuleRowId As %String)
{
	s str="sucess"	
	k ^TEMPRuleLog
	
    //状态发生变化的日志
	s ID="",ClassName="CT.WDT.CDSS.RuleDict"
    for
    {
    	s ID=$o(^CF.WDT.CDSS.DataChangeLogI("ObjectReferIndex",ClassName,RuleRowId,ID)) q:ID=""
    	s UpdateUserName=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(ID)),7)
    	s UpdateDate=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(ID)),8)
      	s UpdateTime=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(ID)),9)
      	s ObjectDesc=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(ID)),13)   //新增对象描述
      	if (ObjectDesc["&&")
      	{
          	s Opreation=$p(ObjectDesc,"&&",2)
          	s ^TEMPRuleLog("RuleLog",UpdateDate,UpdateTime)=ID_"^"_UpdateUserName_"^"_Opreation
        }
     	else
     	{
      		s ^TEMPRuleLog("RuleLog",UpdateDate,UpdateTime)=ID_"^"_UpdateUserName_"^"_"编辑中"
     	}
    }
	q str
}

/// Creator:丁亚男
/// CreatDate:2021-02-04
/// Description:根据规则ID获取该规则的状态变化的日志
/// Table: CT.WDT.CDSS.RuleDict、CF.WDT.CDSS.DataChangeLog
/// Input: RuleRowId 规则ID
/// Return:返回规则ID获取该规则的状态变化的日志
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.RuleDict","GetRuleLogList","9260")
Query GetRuleLogList(RuleRowId As %String) As %Query(ROWSPEC = "LogID,UpdateDate,UpdateTime,UpdateUserName,Opreation")
{
}

ClassMethod GetRuleLogListExecute(ByRef qHandle As %Binary, RuleRowId As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s str="",preUpdateUserName="",preOpreation=""
 	if (RuleRowId'="") s str=##class(web.CDSS.CMKB.RuleDict).CreateTEMPLogGlobal(RuleRowId)
 	if (str="sucess")
 	{
	 	s UpdateDateID=""
		for
		{
			s UpdateDateID = $o(^TEMPRuleLog("RuleLog",UpdateDateID),-1) q:UpdateDateID=""
			s UpdateDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(UpdateDateID)
			s UpdateTimeID=""
		    for
		    {
		    	s UpdateTimeID=$o(^TEMPRuleLog("RuleLog",UpdateDateID,UpdateTimeID),-1) q:UpdateTimeID=""
		    	s UpdateTime=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(UpdateTimeID) 
		    	s LogID=$P(^TEMPRuleLog("RuleLog",UpdateDateID,UpdateTimeID),"^",1)
		    	s UpdateUserName=$P(^TEMPRuleLog("RuleLog",UpdateDateID,UpdateTimeID),"^",2)
		    	s Opreation=$P(^TEMPRuleLog("RuleLog",UpdateDateID,UpdateTimeID),"^",3)
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

ClassMethod GetRuleLogListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCTPMExecute ]
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

ClassMethod GetRuleLogListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRuleLogListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:石萧伟
/// CreatDate:2021-04026
/// Description：下载查询到得数据
/// Input：
/// Return:
/// Other:w ##class(web.CDSS.CMKB.RuleDict).DownLoadFile('sxw','','','','','','','1','','')
ClassMethod DownLoadFile(desc, Loc, Source, UUser, AUser, BNum, Status, RType, SUpdateDate, EUpdateDate)
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
	s P=Disk_":\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\规则2.0导出数据"_User_".csv"
	s file=##class(%File).%New(P)
	s filename = "规则2.0导出数据"_User_".csv"
	d file.Open("NWS")
	d file.Write("规则编码,"_"规则名称,"_"科室,"_"来源,"_"编辑人,"_"编辑时间,"_"审核人,"_"审核时间,"_"状态,"_"批次号,"_"备注,"_"规则来源")
	d file.WriteLine()
	s date=""
	for
	{
		s date=$o(^CT.WDT.CDSS.RuleDictI("DateIndex",date),-1) q:date=""
		s RuleRowId=""
		for
		{ 
			s RuleRowId=$o(^CT.WDT.CDSS.RuleDictI("DateIndex",date,RuleRowId),-1) q:RuleRowId="" 
			s RuleCode=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),2)
			s RuleDesc=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),3)
			s RuleLocDRs=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),4)
			s RuleLoc="",LocFlag=0
			if (RuleLocDRs'="")
		 	{
			 	s LocLen=$L(RuleLocDRs,"，")
			 	for iLoc=1:1:LocLen
			 	{
				 	s LocDR=$p(RuleLocDRs,"，",iLoc)
				 	s:RuleLoc'="" RuleLoc=RuleLoc_"，"_$lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(LocDR)),3)
				 	s:RuleLoc="" RuleLoc=$lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(LocDR)),3)
				}
			}
			s RuleSourceDRs=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),5)
			s RuleSource=RuleSourceDRs /*,SourceFlag=0
			if (RuleSourceDRs'="")
		 	{
			 	s SourceLen=$L(RuleSourceDRs,"，")
			 	for iSource=1:1:SourceLen
			 	{
				 	s SourceDR=$p(RuleSourceDRs,"，",iSource)
				 	s:RuleSource'="" RuleSource=RuleSource_"，"_$lg($g(^CT.WDT.CDSS.DocuManageD(SourceDR)),3)
				 	s:RuleSource="" RuleSource=$lg($g(^CT.WDT.CDSS.DocuManageD(SourceDR)),3)
				}
			}*/
			s RuleTypeDR=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),6)
			s RuleType=""
			s:RuleTypeDR'="" RuleType=$LISTGET($G(^CT.WDT.CDSS.ChartTypeD(RuleTypeDR)),3)
			s BatchNum=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),7)
			s RuleStatus=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),8)
			s UpdateUser=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),9)
			s UpdateDate=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),10)
			s AuditUser=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),11)
			s AuditDate=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),12)
			s Remarks=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),13)
			s RuleProvision=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),14)
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
			s RuleSourceNew = $replace(RuleSource,",","，")	
			if ((($ZCONVERT(RuleDesc,"U")[desc))||(RuleDesc[desc))&&(((Loc'="")&&(LocFlag=1))||(Loc=""))&&(((Source'="")&&(RuleSourceDRs[Source))||(Source=""))&&($ZCONVERT(AuditUser,"U")[AUser)&&($ZCONVERT(UpdateUser,"U")[UUser)
			&&($ZCONVERT(RuleStatus,"U")[Status)&&($ZCONVERT(BatchNum,"U")[BNum)&&(((RType'="")&&(RuleTypeDR=RType))||(RType=""))&&(SUpdateDateFlag=1)&&(EUpdateDateFlag=1){
				d file.Write(RuleCode_",")
				d file.Write(RuleDesc_",")
				d file.Write(RuleLoc_",")
				d file.Write(RuleSourceNew_",")
				//d file.Write(RuleType_",")
				
				d file.Write(UpdateUser_",")
				d file.Write(UpdateDate_",")
				d file.Write(AuditUser_",")
				d file.Write(AuditDate_",")
				d file.Write(RuleStatus_",")

				d file.Write(BatchNum_",")
				d file.Write(Remarks_",")
				d file.Write(RuleProvision)
				d file.WriteLine()

			}
		}	
		///"诊断名,"_"结构化结果,"_"专业科室,"_"处理状态,"_"ICD编码,"_"ICD中文描述,"_"参考中心词,"_"分词,"_"数据类型,"_"别名,"_"其他描述,"_"总频次"		d file.Write(Desc_",")

	}
	d file.%Save()
	d file.%Close()
	q filename
}

/// Creator:丁亚男
/// CreatDate:2021-01-27
/// Description:获取规则下识别词是否都拆分完成
/// Return:1-有,0-无
/// Input:RuleDR 规则id
/// w ##class(web.CDSS.CMKB.RuleDict).GetSplitFlag(52)
ClassMethod GetSplitFlag(RuleDR As %String) As %String
{
    s SplitFlag=0 
    if (RuleDR="") q SplitFlag
    if ($d(^CT.WDT.CDSS.RuleNodeI("RuleDRIndex",RuleDR)))
    {
	    
	    s NodeDR=0
	    s SplitWords=""
	    for
	    {
		    s NodeDR=$O(^CT.WDT.CDSS.RuleNodeI("RuleDRIndex",RuleDR,NodeDR)) q:(NodeDR="")||(SplitFlag=1)
		    s NodeType=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),5)
			s NodeTypeDesc=""
			s:NodeType'="" NodeTypeDesc=$lg($g(^CT.WDT.CDSS.NodeTypeD(NodeType)),3)
			;b ;11
			if (NodeTypeDesc="主要条件-诊断")||(NodeTypeDesc="主要条件-识别词")||(NodeTypeDesc="否定条件-识别词")||(NodeTypeDesc="否定条件-诊断")||(NodeTypeDesc="通过条件")
			{
				if ($d(^CT.WDT.CDSS.RuleConditionI("NodeDRIndex",NodeDR)))
			    {
				    s ConditionDR=0
				    for
				    {
					    s ConditionDR=$O(^CT.WDT.CDSS.RuleConditionI("NodeDRIndex",NodeDR,ConditionDR)) q:(ConditionDR="")||(SplitFlag=1)
					    s ConditionItemValue=$lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionDR)),6)
					    ;b ;11
					    if ($d(^CT.WDT.CDSS.IdentifyWordsI("DescIndex"," "_$zconvert(ConditionItemValue,"U")))) 
			    		{
				    		s WordsDR=$O(^CT.WDT.CDSS.IdentifyWordsI("DescIndex"," "_$zconvert(ConditionItemValue,"U"),""))
				    		
				    		s SplitState=$lg($g(^CT.WDT.CDSS.IdentifyWordsD(WordsDR)),10)  //拆分状态（0是/1否）
				    		if (SplitState=1)||((SplitState=""))
				    		{
					    		//s SplitFlag=1	
					    		s:SplitWords'="" SplitWords=SplitWords_"，"_$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsDR)),3)

					    		s:SplitWords="" SplitWords=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsDR)),3)
					    	}
			    		}	
					}
			    }
				
			}
		}
    }
    
    q SplitWords
}

/// Creator:丁亚男
/// CreatDate:2021-09-07
/// Input:RowId 规则ID
/// Return:
/// Other:w ##class(web.CDSS.CMKB.RuleDict).IsExistNode(182)
ClassMethod IsExistNode(RowId) As %String
{
	s flag=0 //赋初值 不存在
	if $d(^CT.WDT.CDSS.RuleNodeI("RuleDRIndex",RowId)) s flag=1
	q flag
}

/// Creator:丁亚男
/// CreatDate:2021-10-29
/// Input:处理历史文献，将id转化成名称用&%链接
/// Return:
/// Other:w ##class(web.CDSS.CMKB.RuleDict).UpdateRuleSource()
ClassMethod UpdateRuleSource() As %String
{
	s count=0,fcount=0
	s RuleRowId=0
	for
	{ 
		s RuleRowId=$o(^CT.WDT.CDSS.RuleDictD(RuleRowId)) q:RuleRowId="" 
		s obj=##class(CT.WDT.CDSS.RuleDict).%OpenId(RuleRowId)
		s RuleSourceDRs = obj.RuleSource 
		s RuleSource=""
		if (RuleSourceDRs'="")
	 	{
		 	s SourceLen=$L(RuleSourceDRs,"，")
		 	for iSource=1:1:SourceLen
		 	{
			 	s SourceDR=$p(RuleSourceDRs,"，",iSource)
			 	if ($d(^CT.WDT.CDSS.DocuManageD(SourceDR)))
			 	{
				 	s SourceStr=$lg($g(^CT.WDT.CDSS.DocuManageD(SourceDR)),3)
				 	s:RuleSource'="" RuleSource=RuleSource_"&%"_SourceStr
				 	s:RuleSource="" RuleSource=SourceStr
			 	}
			}	
		}
		if (RuleSource="")&(RuleSourceDRs'="")
		{
			s RuleSource=RuleSourceDRs
		}
		
		s obj.RuleSource =RuleSource
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s count=count+1
			
		}
		else
		{
			Trollback
			s fcount=fcount+1
		}
	}
	q count_"条处理成功！"_fcount_"条处理失败！"
}

/// Creator:丁亚男
/// CreatDate:2022-01-26
/// Description:规则不同状态的数据统计
/// Table:CT.WDT.CDSS.RuleDict
/// Input:
/// Return:总数据量^编辑中的数据量^已审核的数据量(审核通过+已上线)^待审核的数据量
/// Other:w ##class(web.CDSS.CMKB.RuleDict).CountData("推荐治疗方案")
ClassMethod CountData(TypeDesc)
{
	s Totalcount=0,Editcount=0,Reviewedcount=0,Tobereviewedcount=0
	s ChartTypeDR=$o(^CT.WDT.CDSS.ChartTypeI("DescIndex"," "_$ZCONVERT(TypeDesc,"U"),""))
	if (ChartTypeDR'="") 
	{
		if ($d(^CT.WDT.CDSS.RuleDictI("TypeIndex",ChartTypeDR)))
		{
			s RuleRowId=0
			for
			{ 
				s RuleRowId=$o(^CT.WDT.CDSS.RuleDictI("TypeIndex",ChartTypeDR,RuleRowId)) q:RuleRowId=""
				
				s RuleStatus=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),8)
				if (RuleStatus="")||(RuleStatus="编辑中")||(RuleStatus="审核不通过")
			 	{
				 	s Totalcount=Totalcount+1
				 	s Editcount=Editcount+1	
				}
				elseif (RuleStatus="已上线")||(RuleStatus="审核通过")
				{
					s Totalcount=Totalcount+1
				 	s Reviewedcount=Reviewedcount+1		
				}
				elseif (RuleStatus="待审核")
				{
					s Totalcount=Totalcount+1
				 	s Tobereviewedcount=Tobereviewedcount+1		
				}
			}
		}
	}
	q Totalcount_"^"_Editcount_"^"_Reviewedcount_"^"_Tobereviewedcount
}

/// Creator:赵文伟
/// CreatDate:2022-03-16
/// Description：树形节点内容【根据项目名称或属性名称检索】
/// Input：流程图节点、诊疗节点内容名称、节点类型Id
/// Return: 成功返回树形节点内容
/// Other:d ##class(web.CDSS.CMKB.RuleDict).GetRuleJson("226702","验光","8")
/// Other:d ##class(web.CDSS.CMKB.RuleDict).GetRuleJson("226718","停药","10")
ClassMethod GetRuleJson(NodeDR As %String, ItemValue As %String, NodeTypeId As %String) As %String
{
	
	s:ItemValue'="" ItemValue=$ZCONVERT(ItemValue,"U")
	if ((NodeTypeId=8)||(NodeTypeId=9)||(NodeTypeId=10)||(NodeTypeId=11)||(NodeTypeId=14)||(NodeTypeId=22)||(NodeTypeId=23)||(NodeTypeId=25)){
		
		//（辅助诊疗-推荐检验检查8、推荐评估表9、推荐护理处置10、推荐治疗方案11、推荐确诊14、推荐鉴别诊断22、推荐住院23、出院指导25）CT.WDT.CDSS.RuleResult
		
		s count=0
		s ResultRowId = ""
		for
		{
			s ResultRowId = $o(^CT.WDT.CDSS.RuleResultI("NodeDRIndex",NodeDR,ResultRowId),-1) q:ResultRowId=""
			s Sequence  = $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),3)
			s RecommendType  = $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),4)
			s RecommendResult  = $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),5)
			s RecommendResultDesc=""
			if (RecommendType="检验") 
			{
				s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(RecommendResult)),4)
			}
			elseif(RecommendType="检查")
			{
				s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.ExamDictD(RecommendResult)),4)
			}
			elseif(RecommendType="检验医嘱")
			{
				s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(RecommendResult)),3)
			}
			elseif(RecommendType="评估表")
			{
				s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.AssBaseD(RecommendResult)),3)
			}
			elseif(RecommendType="治疗方案")
			{
				s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.TreatDictD(RecommendResult)),3)
			}
			elseif((RecommendType="确诊诊断")||(RecommendType="鉴别诊断"))
			{
				s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.DiseaseDictD(RecommendResult)),3)
			}
			elseif(RecommendType="护理措施")
			{
				s RecommendResultDesc=$LISTGET($G(^CT.WDT.CDSS.NursingDictD(RecommendResult)),4)
			}elseif(RecommendType="文献"){
				s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.DocuManageD(RecommendResult)),3) //中文文献名称
			}elseif(RecommendType="出院指导"){
				s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.DischargeGuideD(RecommendResult)),2)
			}
			s Remarks  = $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),6)
			s BaseTable  = $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),7)
			if ($ZCONVERT(RecommendResultDesc,"U")[ItemValue){
				s count=count+1
				if count>1 w ","
				w "{""ResultRowId"":"""_ResultRowId_""""
				w ",""Sequence"":"""_Sequence_""",""RecommendType"":"""_RecommendType_""",""RecommendResult"":"""_RecommendResult_""",""RecommendResultDesc"":"""
				_RecommendResultDesc_""",""Remarks"":"""_Remarks_""",""BaseTable"":"""_BaseTable_""""
				w "}"
			}
		}
	
	}
	elseif ((NodeTypeId=5)||(NodeTypeId=6)||(NodeTypeId=7)||(NodeTypeId=27)){
	
		//（主要条件-诊断5、否定条件-识别词7、主要条件-识别词6、否定条件-诊断27）CT.WDT.CDSS.RuleCondition
		s count=0
		S ConditionRowId=""
		for
		{
			s ConditionRowId = $o(^CT.WDT.CDSS.RuleConditionI("NodeDRIndex",NodeDR,ConditionRowId),-1) q:ConditionRowId=""
			s ConditionClass  = $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowId)),3)
			s ConditionItem  = $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowId)),4)
			s ConditionItemCalculate  = $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowId)),5)
			s ConditionItemValue  = $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowId)),6)
			s ConditionItemValUnit  = $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowId)),7)
			s ConditionItemValUnitN=""
			s:ConditionItemValUnit'="" ConditionItemValUnitN= $lg($g(^CT.WDT.CDSS.UnitDictD(ConditionItemValUnit)),3)
			s SpecialConfig  = $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowId)),8)
			s Remarks  = $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowId)),9)
			if ($ZCONVERT(ConditionItemValue,"U")[ItemValue){
				s count=count+1
				if count>1 w ","
				w "{""ConditionRowId"":"""_ConditionRowId_""""
				w ",""ConditionClass"":"""_ConditionClass_""",""ConditionItem"":"""_ConditionItem_""",""ConditionItemCalculate"":"""_ConditionItemCalculate
				_""",""ConditionItemValue"":"""_ConditionItemValue_""",""ConditionItemValUnit"":"""_ConditionItemValUnit
				_""",""ConditionItemValUnitN"":"""_ConditionItemValUnitN_""",""SpecialConfig"":"""_SpecialConfig_""",""Remarks"":"""_Remarks_""""
				w "}"	
			}
			
		}
	}elseif ((NodeTypeId=15)||(NodeTypeId=16)||(NodeTypeId=17)||(NodeTypeId=19)||(NodeTypeId=20)||(NodeTypeId=21)||(NodeTypeId=24)||(NodeTypeId=26)){
		
		//（检查15、检验16、手术17、护理/处置19、过敏20、输血21、药品24、诊断26 合理性）CT.WDT.CDSS.RuleRationality
		s RationalityRowId = ""
		s count=0
		for
		{
			s RationalityRowId = $o(^CT.WDT.CDSS.RuleRationalityI("NodeDRIndex",NodeDR,RationalityRowId),-1) q:RationalityRowId=""
			s Sequence  = $lg($g(^CT.WDT.CDSS.RuleRationalityD(RationalityRowId)),3)
			s WarningContent  = $lg($g(^CT.WDT.CDSS.RuleRationalityD(RationalityRowId)),4)
			s TabooLevel  = $lg($g(^CT.WDT.CDSS.RuleRationalityD(RationalityRowId)),5)
			s Remarks  = $lg($g(^CT.WDT.CDSS.RuleRationalityD(RationalityRowId)),6)
			
			if ($ZCONVERT(WarningContent,"U")[ItemValue){
				s count=count+1
				if count>1 w ","
				w "{""RationalityRowId"":"""_RationalityRowId_""""
				w ",""Sequence"":"""_Sequence_""",""WarningContent"":"""_WarningContent_""",""TabooLevel"":"""_TabooLevel_""",""Remarks"":"""_Remarks_""""
				w "}"
			}
		}
	}elseif ((NodeTypeId=18)){
		
		//（手术并发症18）CT.WDT.CDSS.RuleComplication
		s ComplicationRowId = ""
		s count=0
		for
		{
			s ComplicationRowId = $o(^CT.WDT.CDSS.RuleComplicationI("NodeDRIndex",NodeDR,ComplicationRowId),-1) q:ComplicationRowId=""
			s Sequence  = $lg($g(^CT.WDT.CDSS.RuleComplicationD(ComplicationRowId)),3)
			s ComplicationDR  = $lg($g(^CT.WDT.CDSS.RuleComplicationD(ComplicationRowId)),4)
			s ComplicationDRDesc=""
			s:ComplicationDR'="" ComplicationDRDesc=$lg($g(^CT.WDT.CDSS.DiseaseDictD(ComplicationDR)),3)
			s MainPoints  = $lg($g(^CT.WDT.CDSS.RuleComplicationD(ComplicationRowId)),5)
			s Remarks  = $lg($g(^CT.WDT.CDSS.RuleComplicationD(ComplicationRowId)),6)
			
			if ($ZCONVERT(ComplicationDRDesc,"U")[ItemValue)
			{
				s count=count+1
				if count>1 w ","
				w "{""ComplicationRowId"":"""_ComplicationRowId_""""
				w ",""Sequence"":"""_Sequence_""",""ComplicationDR"":"""_ComplicationDR_""",""ComplicationDRDesc"":"""_ComplicationDRDesc_""",""MainPoints"":"""
				_MainPoints_""",""Remarks"":"""_Remarks_""""
				w "}"
			}
		}
	}elseif ((NodeTypeId=12)||(NodeTypeId=13)||(NodeTypeId=28)||(NodeTypeId=29)||(NodeTypeId=30)){
		
		//（推荐治疗方案（药品12、手术13、方剂29、处置30、治法28））CT.WDT.CDSS.RuleDetail
		s DetailRowId = ""
		s count=0
		for
		{
			s DetailRowId = $o(^CT.WDT.CDSS.RuleDetailI("NodeLLevelIndex",NodeDR,-100000000000000,DetailRowId),-1) q:DetailRowId=""
			s NodeType=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),5)
			s NodeTypeDesc=""
			s:NodeType'="" NodeTypeDesc=$lg($g(^CT.WDT.CDSS.NodeTypeD(NodeType)),3)
						
			s Sequence  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),3)
			s DrugDR  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),4)
			s DrugUse  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),5)
			s DrugDRName="",DrugUseName=""
			if (NodeTypeDesc="推荐治疗方案-药品") 
			{
				s DrugDRName=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugDR)),4)
				s:DrugUse'="" DrugUseName=$lg($g(^CT.WDT.CDSS.UsageDictD(DrugUse)),3)
			}
			elseif(NodeTypeDesc="推荐治疗方案-手术") 
			{
				s DrugDRName=$lg($g(^CT.WDT.CDSS.OperationDictD(DrugDR)),4)
				s:DrugUse'="" DrugUseName=$lg($g(^CT.WDT.CDSS.UsageDictD(DrugUse)),3)
			}
			elseif(NodeTypeDesc="推荐治疗方案-治法")   //治疗方案-治法
			{
				s DrugDRName=$lg($g(^CT.WDT.CDSS.TCMTreatmentD(DrugDR)),3)
			}
			elseif(NodeTypeDesc="推荐治疗方案-方剂")   //治疗方案-方剂-方剂组成
			{
				s DrugDRName=$lg($g(^CT.WDT.CDSS.TCMPrescriptionD(DrugDR)),3)	//方剂名称
				
				s ChildDrugDRName="" //方剂组成
				s MedicineDR="" 
				for {
					s MedicineDR=$o(^CT.WDT.CDSS.TCMPreJoinMedI("PrescriptMedIndex",DrugDR,MedicineDR)) q:MedicineDR=""
					s MedicineName=$lg($g(^CT.WDT.CDSS.TCMMedicineD(MedicineDR)),3)
					if (ChildDrugDRName=""){
						s ChildDrugDRName=MedicineName
					}else{
						s ChildDrugDRName=ChildDrugDRName_"^"_MedicineName
					}
				}
			}
			elseif(NodeTypeDesc="推荐治疗方案-处置")   //治疗方案-处置(护理字典)-处置明细
			{
				s DrugDRName=$lg($g(^CT.WDT.CDSS.NursingDictD(DrugDR)),4)  //护理名称
			}
			continue:DrugDRName=""
			s DosageMIN  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),6)
			s DosageMINUnit  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),7)
			s DosageMINUnitName=""
			s:DosageMINUnit'="" DosageMINUnitName=$lg($g(^CT.WDT.CDSS.UnitDictD(DosageMINUnit)),3)
			
			s DosageMAX  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),8)
			s DosageMAXUnit  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),9)
			s DosageMAXUnitName=""
			s:DosageMAXUnit'="" DosageMAXUnitName=$lg($g(^CT.WDT.CDSS.UnitDictD(DosageMAXUnit)),3)
			
			s Frequency  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),10)
			s FrequencyName=""
			s:Frequency'="" FrequencyName=$lg($g(^CT.WDT.CDSS.FrequencyDictD(Frequency)),3)
			s Remarks  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),11)
			s LastLevel  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),12)
			//b ;51
			if ($ZCONVERT(DrugDRName,"U")[ItemValue)
			{
				s count=count+1
				if count>1 w ","
				w "{""DetailRowId"":"""_DetailRowId_""""
				w ",""NodeType"":"""_NodeType_""",""NodeTypeDesc"":"""_NodeTypeDesc_""",""Sequence"":"""_Sequence
				_""",""DrugDR"":"""_DrugDR_""",""DrugUse"":"""_DrugUse_""",""DrugDRName"":"""_DrugDRName_""",""DosageMIN"":"""_DosageMIN
				_""",""DosageMINUnit"":"""_DosageMINUnit_""",""DosageMINUnitName"":"""_DosageMINUnitName_""",""Frequency"":"""_Frequency
				_""",""FrequencyName"":"""_FrequencyName_""",""Remarks"":"""_Remarks_""",""LastLevel"":"""_LastLevel_""""
				w "}"	
			} else{				
				s DetailId = ""
				for
				{
					s DetailId = $o(^CT.WDT.CDSS.RuleDetailI("LastLevelIndex",DetailRowId,DetailId),-1) q:DetailId=""
					s LastLevelDrugDR=DrugDR
					s LastLevelDrugUse=DrugUse
					s CDrugDR  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailId)),4)
					
					s ChildDrugDRName=""
					if (NodeTypeDesc="推荐治疗方案-方剂")   //治疗方案-治法-方剂-方剂组成
					{
						
						s ChildDrugDRName=$lg($g(^CT.WDT.CDSS.TCMMedicineD(CDrugDR)),3)
						
					}
					elseif(NodeTypeDesc="推荐治疗方案-处置")   //治疗方案-处置(护理字典)-处置明细
					{
						
						if (LastLevelDrugUse="腧穴")
						{
							s ChildDrugDRName=$lg($g(^CT.WDT.CDSS.TCMAcupointsD(CDrugDR)),3)
						}
						elseif (LastLevelDrugUse="中药")
						{
							s ChildDrugDRName=$lg($g(^CT.WDT.CDSS.TCMMedicineD(CDrugDR)),3)
						}
						elseif (LastLevelDrugUse="药物")
						{
							s ChildDrugDRName=$lg($g(^CT.WDT.CDSS.DrugDictD(CDrugDR)),4)
						}
					}
					if ($ZCONVERT(ChildDrugDRName,"U")[ItemValue){
						s count=count+1
						if count>1 w ","
						w "{""DetailRowId"":"""_DetailRowId_""""
						w ",""NodeType"":"""_NodeType_""",""NodeTypeDesc"":"""_NodeTypeDesc_""",""Sequence"":"""_Sequence
						_""",""DrugDR"":"""_DrugDR_""",""DrugUse"":"""_DrugUse_""",""DrugDRName"":"""_DrugDRName_""",""DosageMIN"":"""_DosageMIN
						_""",""DosageMINUnit"":"""_DosageMINUnit_""",""DosageMINUnitName"":"""_DosageMINUnitName_""",""Frequency"":"""_Frequency
						_""",""FrequencyName"":"""_FrequencyName_""",""Remarks"":"""_Remarks_""",""LastLevel"":"""_LastLevel_""""
						w "}"
					}
				}
			}
		}
	}
	
	q ""
}

/// Creator:赵文伟
/// CreatDate:2022-03-21
/// Description：按条件返回规则流程图节点和线表数据
/// Input：规则ID、规则节点内容、节点类型ID、规则类型ID
/// Return: 返回流程图节点和线表数据
/// Other:w ##class(web.CDSS.CMKB.RuleDict).GetRuleNodeLineJson("11220","便秘","6","")
/// Other:w ##class(web.CDSS.CMKB.RuleDict).GetRuleNodeLineJson("480","男性患者不应开立女性性别限制诊断：急性女性盆腔炎！","26","")
ClassMethod GetRuleNodeLineJson(RuleDR As %String, ItemValue As %String, NodeTypeId As %String, RuleTypeId As %String = "") As %String
{
	s GlobalStr=""
	s:ItemValue'="" ItemValue=$ZCONVERT(ItemValue,"U") //转换成大写 
	s NodeDR=""
	s GlobalStr=GlobalStr_"["
	s count=0
	for
	{
		s NodeDR = $o(^CT.WDT.CDSS.RuleNodeI("RuleDRIndex",RuleDR,NodeDR)) q:NodeDR=""
		if ((NodeTypeId=8)||(NodeTypeId=9)||(NodeTypeId=10)||(NodeTypeId=11)||(NodeTypeId=14)||(NodeTypeId=22)||(NodeTypeId=23)||(NodeTypeId=25)){
		
			//（辅助诊疗-推荐检验检查8、推荐评估表9、推荐护理处置10、推荐治疗方案11、推荐确诊14、推荐鉴别诊断22、推荐住院23、出院指导25）CT.WDT.CDSS.RuleResult
			s ResultRowId = ""
			for
			{
				s ResultRowId = $o(^CT.WDT.CDSS.RuleResultI("NodeDRIndex",NodeDR,ResultRowId),-1) q:ResultRowId=""
			
				s RecommendType  = $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),4)
				s RecommendResult  = $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),5)
				s RecommendResultDesc=""
				if (RecommendType="检验") 
				{
					s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(RecommendResult)),4)
				}
				elseif(RecommendType="检查")
				{
					s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.ExamDictD(RecommendResult)),4)
				}
				elseif(RecommendType="检验医嘱")
				{
					s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(RecommendResult)),3)
				}
				elseif(RecommendType="评估表")
				{
					s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.AssBaseD(RecommendResult)),3)
				}
				elseif(RecommendType="治疗方案")
				{
					s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.TreatDictD(RecommendResult)),3)
				}
				elseif((RecommendType="确诊诊断")||(RecommendType="鉴别诊断"))
				{
					s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.DiseaseDictD(RecommendResult)),3)
				}
				elseif(RecommendType="护理措施")
				{
					s RecommendResultDesc=$LISTGET($G(^CT.WDT.CDSS.NursingDictD(RecommendResult)),4)
				}elseif(RecommendType="文献"){
					s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.DocuManageD(RecommendResult)),3) //中文文献名称
				}elseif(RecommendType="出院指导"){
					s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.DischargeGuideD(RecommendResult)),2)
				}
			
				if ($ZCONVERT(RecommendResultDesc,"U")[ItemValue){
				//if (RecommendResultDesc=ItemValue){
					s FlowChartNumT  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),3)
					s count=count+1
					if count>1 s GlobalStr=GlobalStr_","
					s GlobalStr=GlobalStr_..TraversalRuleNodeLineJson(RuleDR,FlowChartNumT,RuleTypeId)
				}	
			}
		}
		elseif ((NodeTypeId=5)||(NodeTypeId=6)||(NodeTypeId=7)||(NodeTypeId=27)||(NodeTypeId=31)){
			
			//（主要条件-诊断5、否定条件-识别词7、主要条件-识别词6、否定条件-诊断27、通过条件31）CT.WDT.CDSS.RuleCondition
			
			S ConditionRowId=""
			for
			{
				s ConditionRowId = $o(^CT.WDT.CDSS.RuleConditionI("NodeDRIndex",NodeDR,ConditionRowId),-1) q:ConditionRowId=""
				
				s ConditionItemValue  = $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowId)),6)
				
				if ($ZCONVERT(ConditionItemValue,"U")[ItemValue){
					s FlowChartNumT  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),3)
					s count=count+1
					if count>1 s GlobalStr=GlobalStr_","
					s GlobalStr=GlobalStr_..TraversalRuleNodeLineJson(RuleDR,FlowChartNumT,RuleTypeId)			
				}			
			}
		}elseif ((NodeTypeId=15)||(NodeTypeId=16)||(NodeTypeId=17)||(NodeTypeId=19)||(NodeTypeId=20)||(NodeTypeId=21)||(NodeTypeId=24)||(NodeTypeId=26)){
			
			//（检查15、检验16、手术17、护理/处置19、过敏20、输血21、药品24、诊断26 合理性）CT.WDT.CDSS.RuleRationality
			s RationalityRowId = ""
			
			for
			{
				s RationalityRowId = $o(^CT.WDT.CDSS.RuleRationalityI("NodeDRIndex",NodeDR,RationalityRowId),-1) q:RationalityRowId=""
				s WarningContent  = $lg($g(^CT.WDT.CDSS.RuleRationalityD(RationalityRowId)),4)
				
				if ($ZCONVERT(WarningContent,"U")[ItemValue){
					s FlowChartNumT  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),3)
					s count=count+1
					if count>1 s GlobalStr=GlobalStr_","
					
					s GlobalStr=GlobalStr_..TraversalRuleNodeLineJson(RuleDR,FlowChartNumT,RuleTypeId)
				}
			}
		}elseif ((NodeTypeId=18)){
			
			//（手术并发症18）CT.WDT.CDSS.RuleComplication
			s ComplicationRowId = ""
			
			for
			{
				s ComplicationRowId = $o(^CT.WDT.CDSS.RuleComplicationI("NodeDRIndex",NodeDR,ComplicationRowId),-1) q:ComplicationRowId=""
				s ComplicationDR  = $lg($g(^CT.WDT.CDSS.RuleComplicationD(ComplicationRowId)),4)
				s ComplicationDRDesc=""
				s:ComplicationDR'="" ComplicationDRDesc=$lg($g(^CT.WDT.CDSS.DiseaseDictD(ComplicationDR)),3)
			
				if ($ZCONVERT(ComplicationDRDesc,"U")[ItemValue)
				{
					s FlowChartNumT  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),3)
					s count=count+1
					if count>1 s GlobalStr=GlobalStr_","
					s GlobalStr=GlobalStr_..TraversalRuleNodeLineJson(RuleDR,FlowChartNumT,RuleTypeId)
				}
			}
		}elseif ((NodeTypeId=12)||(NodeTypeId=13)||(NodeTypeId=28)||(NodeTypeId=29)||(NodeTypeId=30)){
			
			//（推荐治疗方案（药品12、手术13、方剂29、处置30、治法28））CT.WDT.CDSS.RuleDetail
			s DetailRowId = ""
			
			for
			{
				s DetailRowId = $o(^CT.WDT.CDSS.RuleDetailI("NodeLLevelIndex",NodeDR,-100000000000000,DetailRowId),-1) q:DetailRowId=""
				s NodeType=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),5)
				s NodeTypeDesc=""
				s:NodeType'="" NodeTypeDesc=$lg($g(^CT.WDT.CDSS.NodeTypeD(NodeType)),3)
							
				s DrugDR  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),4)
				s DrugUse  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),5)
				s DrugDRName="",DrugUseName=""
				if (NodeTypeDesc="推荐治疗方案-药品") 
				{
					s DrugDRName=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugDR)),4)
					s:DrugUse'="" DrugUseName=$lg($g(^CT.WDT.CDSS.UsageDictD(DrugUse)),3)
				}
				elseif(NodeTypeDesc="推荐治疗方案-手术") 
				{
					s DrugDRName=$lg($g(^CT.WDT.CDSS.OperationDictD(DrugDR)),4)
					s:DrugUse'="" DrugUseName=$lg($g(^CT.WDT.CDSS.UsageDictD(DrugUse)),3)
				}
				elseif(NodeTypeDesc="推荐治疗方案-治法")   //治疗方案-治法-方剂-方剂组成
				{
					s DrugDRName=$lg($g(^CT.WDT.CDSS.TCMTreatmentD(DrugDR)),3)
				}
				elseif(NodeTypeDesc="推荐治疗方案-方剂")   //治疗方案-治法-方剂-方剂组成
				{
					s DrugDRName=$lg($g(^CT.WDT.CDSS.TCMPrescriptionD(DrugDR)),3)
				}
				elseif(NodeTypeDesc="推荐治疗方案-处置")   //治疗方案-处置(护理字典)-处置明细
				{
					s DrugDRName=$lg($g(^CT.WDT.CDSS.NursingDictD(DrugDR)),4)  //护理名称
				}
				continue:DrugDRName=""

				
				if ($ZCONVERT(DrugDRName,"U")[ItemValue)
				//if (DrugDRName=ItemValue)
				{
					s FlowChartNumT  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),3)
					s count=count+1
					if count>1 s GlobalStr=GlobalStr_","
					s GlobalStr=GlobalStr_..TraversalRuleNodeLineJson(RuleDR,FlowChartNumT,RuleTypeId)
				}
			}
		}
	}
	s GlobalStr=GlobalStr_"]"
	q GlobalStr
}

/// Creator:赵文伟
/// CreatDate:2022-03-21
/// Description：遍历节点和线数据
/// Input：规则ID、规则节点内容、节点类型ID、规则类型ID
/// Return: 返回流程图节点和线表数据
/// Other:d ##class(web.CDSS.CMKB.RuleDict).TraversalRuleNodeLineJson("480","1","")
ClassMethod TraversalRuleNodeLineJson(RuleDR As %String, FlowChartNumT As %String, RuleTypeId As %String) As %String
{
	s PartStr=""
	s count=0
	if RuleTypeId="" s RuleTypeId=-100000000000000
	//b ;1
	s PartStr=PartStr_"["
	//节点数据
	s NodeRowId = ""		
	for
	{
		s NodeRowId = $o(^CT.WDT.CDSS.RuleNodeI("TypeChartIndex",RuleDR,RuleTypeId,FlowChartNumT,NodeRowId)) q:NodeRowId=""
		s FlowChartNum  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),3)
		s NodeNum  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),4)
		s NodeType  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),5)
		s NodeTypeDesc=""
		s:NodeType'="" NodeTypeDesc= $lg($g(^CT.WDT.CDSS.NodeTypeD(NodeType)),3)	
		s MeetConditionNum  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),6)
		s Remarks  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),7)
		s ChartLeft  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),8)
		s ChartTop  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),9)
		s RuleTypeDR  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),10)
		s ChartTypeDesc=""
		s:RuleTypeDR'="" ChartTypeDesc= $lg($g(^CT.WDT.CDSS.ChartTypeD(RuleTypeDR)),3)
		
		s count=count+1
			if count>1 s PartStr=PartStr_ ","
			s PartStr=PartStr_ "{""NodeRowId"":"""_NodeRowId_""""
			s PartStr=PartStr_ ",""FlowChartNum"":"""_FlowChartNum_""",""NodeNum"":"""_NodeNum_""",""NodeType"":"""_NodeType_""",""NodeTypeDesc"":"""_NodeTypeDesc_""",""MeetConditionNum"":"""_MeetConditionNum
			_""",""ChartLeft"":"""_ChartLeft_""",""ChartTop"":"""_ChartTop_""",""RuleTypeDR"":"""_RuleTypeDR_""",""ChartTypeDesc"":"""_ChartTypeDesc_""""
			s PartStr=PartStr_"}"
					
	}
	//线表数据
	s LinkRowId = ""
	s countT=0
	for
	{
		s LinkRowId = $o(^CT.WDT.CDSS.RuleLinkI("TypeChartIndex",RuleDR,RuleTypeId,FlowChartNumT,LinkRowId)) q:LinkRowId=""
		s FlowChartNum  = $lg($g(^CT.WDT.CDSS.RuleLinkD(LinkRowId)),3)
		s PreNode  = $lg($g(^CT.WDT.CDSS.RuleLinkD(LinkRowId)),4)
		s PreNodeNum="",PreNodeType="",PreNodeTypeDesc=""
		if (PreNode'="")
		{
			s PreNodeNum=$lg($g(^CT.WDT.CDSS.RuleNodeD(PreNode)),4)
			s PreNodeType  = $lg($g(^CT.WDT.CDSS.RuleNodeD(PreNode)),5)
			s:PreNodeType'="" PreNodeTypeDesc= $lg($g(^CT.WDT.CDSS.NodeTypeD(PreNodeType)),3)
		} 
		s NextNode  = $lg($g(^CT.WDT.CDSS.RuleLinkD(LinkRowId)),5)
		s NextNodeNum="",NextNodeType="",NextNodeTypeDesc=""
		if (NextNode'="")
		{
			s NextNodeNum=$lg($g(^CT.WDT.CDSS.RuleNodeD(NextNode)),4)
			s NextNodeType  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NextNode)),5)
			s:NextNodeType'="" NextNodeTypeDesc= $lg($g(^CT.WDT.CDSS.NodeTypeD(NextNodeType)),3)
		}
							
		s Remarks  = $lg($g(^CT.WDT.CDSS.RuleLinkD(LinkRowId)),6)
		s RuleTypeDR  = $lg($g(^CT.WDT.CDSS.RuleLinkD(LinkRowId)),7)
		s ChartTypeDesc=""
		s:RuleTypeDR'="" ChartTypeDesc= $lg($g(^CT.WDT.CDSS.ChartTypeD(RuleTypeDR)),3)
							
		s countT=countT+1
		//if countT>1 w ","
		s PartStr=PartStr_ ","
		s PartStr=PartStr_ "{""LinkRowId"":"""_LinkRowId_""""
		s PartStr=PartStr_ ",""FlowChartNum"":"""_FlowChartNum_""",""PreNode"":"""_PreNode_""",""PreNodeNum"":"""_PreNodeNum_""",""PreNodeType"":"""_PreNodeType_""",""PreNodeTypeDesc"":"""_PreNodeTypeDesc
		_""",""NextNode"":"""_NextNode_""",""NextNodeNum"":"""_NextNodeNum_""",""NextNodeType"":"""_NextNodeType_""",""NextNodeTypeDesc"":"""_NextNodeTypeDesc
		_""",""RuleTypeDR"":"""_RuleTypeDR_""",""ChartTypeDesc"":"""_ChartTypeDesc_""""
		s PartStr=PartStr_"}"						
	}
	s PartStr=PartStr_"]"
	q PartStr
}

/// Creator:赵文伟
/// CreatDate:2022-03-22
/// Description：按条件返回规则流程图节点和线表数据【旧版已弃用，改为调用GetRuleNodeLineJsonNew()】
/// Input：规则ID、规则节点内容、节点类型ID、规则类型ID
/// Return: 返回流程图节点和线表数据 返回顺序【{开始节点-》内容节点-》线节点-》结束节点}，{}】
/// Other:w ##class(web.CDSS.CMKB.RuleDict).HandleGetRuleNodeLineJson("480","男性患者不应开立女性性别限制诊断：急性女性盆腔炎！","26","")
/// Other:w ##class(web.CDSS.CMKB.RuleDict).HandleGetRuleNodeLineJson("11223","zy","31","")
ClassMethod HandleGetRuleNodeLineJson(RuleDR As %String, ItemValue As %String, NodeTypeId As %String, RuleTypeId As %String = "") As %String
{
	s RawData= ..GetRuleNodeLineJson(RuleDR,ItemValue,NodeTypeId,RuleTypeId)
	s array=##class(%DynamicAbstractObject).%FromJSON(RawData)
	s outer=[]
	s result=[]
	s record={}
	s checkRowId=""
	for index=0:1:(array.%Size()-1)    //遍历array
	{
		s outer=array.%Get(index)	
		if outer.%ToJSON()="" continue
		s checkRowId=outer.%Get(0).NodeRowId
		s flag=record.%Get(checkRowId)
		if (flag=""){
			d record.%Set(checkRowId,checkRowId)
			s empty=[{}]
			s temp={}
			
			f j=0:1:(outer.%Size()-1)
			{	
				s item=outer.%Get(j)
				q:item=""
				if item.%ToJSON()="" continue
				if (item.NodeType="1")
				{
					d empty.%Set(0,item)
				}
				elseif (item.NodeType="2")
				{
					s temp=item	
				}
				else{
					
					d empty.%Push(item)
				}
			}
			d empty.%Push(temp)
			d result.%Push(empty)
		}
	}
	w result.%ToJSON()
	q ""
}

/// Creator:赵文伟
/// CreatDate:2022-03-31
/// Description:预警数据，统计流程图个数
/// Table:CT.WDT.CDSS.RuleDict
/// Input: TypeDesc
/// Return:总数据量^编辑中的数据量^已审核的数据量(审核通过+已上线)^待审核的数据量
/// Other:w ##class(web.CDSS.CMKB.RuleDict).CountWarningData("疾病预警")
ClassMethod CountWarningData(TypeDesc)
{
	s Totalcount=0,Editcount=0,Reviewedcount=0,Tobereviewedcount=0
	s ChartTypeDR=$o(^CT.WDT.CDSS.ChartTypeI("DescIndex"," "_$ZCONVERT(TypeDesc,"U"),""))
	if (ChartTypeDR'="") 
	{
		if ($d(^CT.WDT.CDSS.RuleDictI("TypeIndex",ChartTypeDR)))
		{
			s RuleRowId=0
			for
			{ 
				s RuleRowId=$o(^CT.WDT.CDSS.RuleDictI("TypeIndex",ChartTypeDR,RuleRowId)) q:RuleRowId=""
				s RuleStatus=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),8)
				s FlowNum={}
				s NodeRowId=0
				for 
				{
					s NodeRowId=$o(^CT.WDT.CDSS.RuleNodeI("RuleDRIndex",RuleRowId,NodeRowId)) q:NodeRowId=""
					
					s FlowChartNum  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),3)
					
					s flag=FlowNum.%Get(FlowChartNum)
					
					if (flag=""){
						d FlowNum.%Set(FlowChartNum,FlowChartNum)
						if (RuleStatus="")||(RuleStatus="编辑中")||(RuleStatus="审核不通过")
					 	{
						 	s Totalcount=Totalcount+1
						 	s Editcount=Editcount+1	
						}
						elseif (RuleStatus="已上线")||(RuleStatus="审核通过")
						{
							s Totalcount=Totalcount+1
						 	s Reviewedcount=Reviewedcount+1		
						}
						elseif (RuleStatus="待审核")
						{
							s Totalcount=Totalcount+1
						 	s Tobereviewedcount=Tobereviewedcount+1		
						}
					}
				}
				
			}
		}
	}
	q Totalcount_"^"_Editcount_"^"_Reviewedcount_"^"_Tobereviewedcount
}

/// Creator:赵文伟
/// CreatDate:2022-04-01
/// Description:循证规则(推荐治疗方案)数据统计接口【统计该种类规则下覆盖的诊断数（不考虑规则状态）】
/// Table:CT.WDT.CDSS.RuleDict
/// Input: TypeDesc
/// Return:总数据量
/// Other:w ##class(web.CDSS.CMKB.RuleDict).CountRuleData("推荐治疗方案")
ClassMethod CountRuleData(TypeDesc)
{
	
	s Totalcount=0
	s ChartTypeDR=$o(^CT.WDT.CDSS.ChartTypeI("DescIndex"," "_$ZCONVERT(TypeDesc,"U"),""))
	if (ChartTypeDR'="") 
	{
		if ($d(^CT.WDT.CDSS.RuleDictI("TypeIndex",ChartTypeDR)))
		{
			s ItemValue={}
			s RuleRowId=""
			for
			{ 
				s RuleRowId=$o(^CT.WDT.CDSS.RuleDictI("TypeIndex",ChartTypeDR,RuleRowId)) q:RuleRowId=""
				//s RuleStatus=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),8)
				s NodeRowId=0
				for 
				{
					s NodeRowId=$o(^CT.WDT.CDSS.RuleNodeI("RuleDRIndex",RuleRowId,NodeRowId)) q:NodeRowId=""
					s NodeType  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),5)
					s NodeTypeDesc=""
					s:NodeType'="" NodeTypeDesc= $lg($g(^CT.WDT.CDSS.NodeTypeD(NodeType)),3)	
					
					if ((NodeTypeDesc="主要条件-诊断")||(NodeTypeDesc="否定条件-诊断")){
						s ConditionRowId = ""
						for
						{
							s ConditionRowId = $o(^CT.WDT.CDSS.RuleConditionI("NodeDRIndex",NodeRowId,ConditionRowId)) q:ConditionRowId=""
							s ConditionItemValue  = $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowId)),6)
							s flag=ItemValue.%Get(ConditionItemValue)
							if (flag=""){
							d ItemValue.%Set(ConditionItemValue,ConditionItemValue)
							s Totalcount=Totalcount+1
							
							}	
						}
					}	
				}	
			}
		}
	}
	q Totalcount
}

/// Creator：石萧伟
/// CreatDate: 2022-04-07
/// Description：获取来源类型及路径
/// Table：CT.WDT.CDSS.RuleResult
/// Input：id type（推荐reco、预警warn、并发症comp）
/// Return:Json
/// Other: w ##class(web.CDSS.CMKB.RuleDict).GetSource("8260","reco")
/// remake:如果返回值html中有值，则无需考虑img中的展示，直接展示html值和doc即可
ClassMethod GetSource(id As %String, type As %String)
{
		if (id="")||(type="") q ""
		s result = ""
		s SourceImg=""
		if (type="reco"){
			s obj=##class(CT.WDT.CDSS.RuleResult).%OpenId(id)
			s Img  = obj.SourceImg 
			s len=Img.SizeGet()
	        d Img.Rewind()
	        s SourceImg=Img.Read(len)
		}elseif (type="warn"){
			s obj=##class(CT.WDT.CDSS.RuleRationality).%OpenId(id)
		}elseif (type="comp"){
			s obj=##class(CT.WDT.CDSS.RuleComplication).%OpenId(id)
		}

        s RuleBasisDR = ""
        if $IsObject(obj.RuleBasisDR)
		{
		 	s RuleBasisDR = obj.RuleBasisDR.%Id()
		}
		s docName = obj.TreatSource
		
		s isExistDoc = ##class(web.DHCBL.BDP.BDPUploadFile).IsExistsFile("scripts\\bdp\\CDSS\\Doc\\"_docName_".pdf")
		s docSource = ""
		if (isExistDoc=1){
			s docSource = docName_".pdf"
		}
		s htmlSource = ""
		if (RuleBasisDR'=""){
			s htmlSource = ##class(web.CDSS.CMKB.RuleBasis).getRuleSource(RuleBasisDR)
			s htmlSource=$replace(htmlSource,"""","\""")
		}
		s result = "[{""type"":""doc"",""source"":"""_docSource_"""},{""type"":""img"",""source"":"""_SourceImg_"""},{""type"":""html"",""source"":"""_htmlSource_"""}]"
		d obj.%Close()	
		k obj	
		q result
}

/// Creator:赵文伟
/// CreatDate:2022-05-30
/// Description:判断字典数据是否被循证规则及预警规则引用,返回引用标志【1：被引用; 0：未被引用】
/// Table:CT.WDT.CDSS.RuleDict
/// Input: Desc [字典数据名称，字典类型，数据ID]
/// Return: 引用标志 【被循证规则引用标志^被预警规则引用标志】
/// Other:w ##class(web.CDSS.CMKB.RuleDict).GetRuleQuoteFlag("诊断","结膜炎","	661")
ClassMethod GetRuleQuoteFlag(DictType As %String, Desc As %String, DictRowId As %String = "")
{
	
	s RuleFlag=0	//循证规则引用标志【1：被引用; 0：未被引用】
	s WarningFlag=0	//预警规则引用标志【1：被引用; 0：未被引用】
	if ($d(^CT.WDT.CDSS.WordsConditionI("ItemValueIndex",Desc))){	//判断该字典数据是否存在识别条件中
		s WordsConditionDR=""
		for
		{
			s WordsConditionDR = $O(^CT.WDT.CDSS.WordsConditionI("ItemValueIndex",Desc,WordsConditionDR))  q:WordsConditionDR=""
			
			s WordsItemDR = $lg($g(^CT.WDT.CDSS.WordsConditionD(WordsConditionDR)),3)	
			s WordsItemDesc = $lg($g(^CT.WDT.CDSS.WordsItemD(WordsItemDR)),3)	//识别项目
			s Type = $case(WordsItemDesc,"诊断名称":"诊断","既往诊断名称":"诊断","手术名称":"手术","既往手术名称":"手术","药品名称":"药品","护理项目名称":"护理","检查项目名称":"检查","检验项目名称":"检验","检验医嘱名称":"检验医嘱","输血品名称":"输血品",:"") 	
			
			s WordsNodeDR = $lg($g(^CT.WDT.CDSS.WordsConditionD(WordsConditionDR)),2)	//识别词节点DR
			continue:(WordsNodeDR="")
			s WordsDR = $lg($g(^CT.WDT.CDSS.WordsNodeD(WordsNodeDR)),2)			//识别词DR
			continue:(WordsDR="")
			s WordsDesc = $lg($g(^CT.WDT.CDSS.IdentifyWordsD(WordsDR)),3)		//识别词名称
			
			if (Type=DictType){		//如果字典类型与识别项目对应
				if ($d(^CT.WDT.CDSS.RuleConditionI("ValueIndex",WordsDesc))){	//判断该识别词是否存在规则触发条件中
					s RuleConditionDR=""
					for
					{
						s RuleConditionDR = $O(^CT.WDT.CDSS.RuleConditionI("ValueIndex",Desc,RuleConditionDR))  q:RuleConditionDR=""
						s RuleNodeDR = $lg($g(^CT.WDT.CDSS.RuleConditionD(RuleConditionDR)),2)	//规则节点DR
						continue:(RuleNodeDR="")
						s RuleDR = $lg($g(^CT.WDT.CDSS.RuleNodeD(RuleNodeDR)),2)
						continue:(RuleDR="")
						s RuleTypeDR = $lg($g(^CT.WDT.CDSS.RuleDictD(RuleDR)),6)					
						s RuleType = $lg($g(^CT.WDT.CDSS.ChartTypeD(RuleTypeDR)),3)				//规则类型
						
						if (RuleType="疾病预警")||(RuleType="检验合理性")||(RuleType="检查合理性")||(RuleType="手术并发症")||(RuleType="输血预警")||(RuleType="手术合理性")||(RuleType="药品合理性")||(RuleType="护理/处置合理性")||(RuleType="过敏预警"){			
							s WarningFlag=1		//预警规则引用
						} 
						else {
							s RuleFlag=1		//循证规则引用
						}
						if (Type="诊断")
						{
							if (RuleFlag=1)&&(WarningFlag=1) q
						}
						else 
						{
							if (WarningFlag=1) q
						}
					}
				}
			}
			
			if (DictType="诊断")
			{
				//（手术并发症）CT.WDT.CDSS.RuleComplication
				if ($d(^CT.WDT.CDSS.RuleComplicationI("ComplicationDRIndex",DictRowId)))
				{
					s WarningFlag=1
				}
				//判断如果已经被引用，不再遍历剩余数据
				if (RuleFlag=1)&&(WarningFlag=1) q		
			}
			else {				//其他字典
				if (WarningFlag=1) q
			}
		}
	}
	q RuleFlag_"^"_WarningFlag
}

/// Creator:赵文伟
/// CreatDate:2022-06-10
/// Description: 规则数据复制一条，修改最新规则名称
/// Table:CT.WDT.CDSS.RuleDict
/// Input: 被复制的规则ID、新的规则名称
/// Return: 
/// Other:d ##class(web.CDSS.CMKB.RuleDict).CopyNewRuleDict("9776","社区获得性肺炎-单病种")
/// Other:d ##class(web.CDSS.CMKB.RuleDict).CopyNewRuleDict("463","胆石病-单病种")
ClassMethod CopyNewRuleDict(RuleDR As %String, Desc As %String = "")
{
	s result=""
	/*************复制当前数据****************/
	s SQL="INSERT INTO CT_WDT_CDSS.RuleDict(RuleCode,RuleDesc,RuleLoc,RuleSource,RuleType,BatchNum,RuleStatus,UpdateUser,UpdateDate,AuditUser,AuditDate,Remarks)"_
	"SELECT RuleCode,RuleDesc,RuleLoc,RuleSource,RuleType,BatchNum,RuleStatus,UpdateUser,UpdateDate,AuditUser,AuditDate,Remarks FROM CT_WDT_CDSS.RuleDict"_
	" WHERE ID="_RuleDR_""
	s tStatement=##class(%SQL.Statement).%New()
	s qStatus = tStatement.%Prepare(SQL)
	if qStatus '= 1 
	{
		w "%Prepare failed:"
		d $System.Status.DisplayError(qStatus)
		q
	}
	s rset= tStatement.%Execute()
	/*****************获取ID*******************/
	s nStatement=##class(%SQL.Statement).%New()
	s SQLID="SELECT MAX(ID) AS num FROM CT_WDT_CDSS.RuleDict"
	s flag = nStatement.%Prepare(SQLID)
	if flag '= 1 
	{
		w "%Prepare failed:"
		d $System.Status.DisplayError(flag)
		q
	}
	s rset1 = nStatement.%Execute()
	
	while rset1.%Next() 
	{
		s RuleRowId= rset1.num
	}
	/****************获取并保存Code***************/
	s RuleCode = ..GetLastCode()
	s obj=##class(CT.WDT.CDSS.RuleDict).%OpenId(RuleRowId)
	s obj.RuleCode = RuleCode
	s obj.RuleDesc = Desc
	//s obj.UpdateUser=$g(%session.Data("LOGON.USERNAME"))
	s bj.UpdateUser="dhcc"
	if ($d(%session))
	{
		s obj.UpdateUser=$g(%session.Data("LOGON.USERNAME"))
	}
	s obj.UpdateDate=$zdt($h,3)
	s sc = obj.%Save()
	d obj.%Close()
	k obj
	If $$$ISOK(sc)
	{
		s result="true"
		
	} else{
		s result="false"
	}
	d ..CopyRuleNodeLine(RuleDR,RuleRowId)
	w result_"^"_RowId
	//w "规则数据复制完成！"
}

/// Creator:赵文伟
/// CreatDate:2022-06-10
/// Description: 复制节点、线、节点内容，并更新最新字段值
/// Table: CT.WDT.CDSS.RuleNode
/// Input: 被复制的规则ID、新的规则ID
/// Return: 
/// Other:w ##class(web.CDSS.CMKB.RuleDict).CopyRuleNodeLine("","")
ClassMethod CopyRuleNodeLine(RuleDR As %String, RuleRowId As %String)
{
	/**********************处理线数据****************************/
	s LinkDR=""
	for
	{
		s LinkDR = $o(^CT.WDT.CDSS.RuleLinkI("RuleDRIndex",RuleDR,LinkDR)) q:LinkDR=""
		s SQL="INSERT INTO CT_WDT_CDSS.RuleLink(RuleDR,FlowChartNum,PreNode,NextNode,Remarks,RuleTypeDR)"_
		"SELECT RuleDR,FlowChartNum,PreNode,NextNode,Remarks,RuleTypeDR FROM CT_WDT_CDSS.RuleLink"_
		" WHERE ID="_LinkDR_""
		s tStatement=##class(%SQL.Statement).%New()
		s qStatus = tStatement.%Prepare(SQL)
		if qStatus '= 1 
		{
			w "%Prepare failed:"
			d $System.Status.DisplayError(qStatus)
			q
		}
		s rset= tStatement.%Execute()
		//取ID
		s LStatement=##class(%SQL.Statement).%New()
		s SQLID="SELECT MAX(ID) AS num FROM CT_WDT_CDSS.RuleLink"
		s flag = LStatement.%Prepare(SQLID)
		if flag '= 1 
		{
			w "%Prepare failed:"
			d $System.Status.DisplayError(flag)
			q
		}
		s rsetL = LStatement.%Execute()
		while rsetL.%Next() 
		{
			s LinkRowId= rsetL.num
		}
		//修改线数据RuleDR
		
		s obj=##class(CT.WDT.CDSS.RuleLink).%OpenId(LinkRowId)
		d obj.RuleDRSetObjectId(RuleRowId)
		s sc = obj.%Save()
		d obj.%Close()
		k obj
	}
	/*************************处理节点数据*******************************/
	s NodeDR=""
	for
	{
		s NodeDR = $o(^CT.WDT.CDSS.RuleNodeI("RuleDRIndex",RuleDR,NodeDR)) q:NodeDR=""
		s SQL="INSERT INTO CT_WDT_CDSS.RuleNode(RuleDR,FlowChartNum,NodeNum,NodeType,MeetConditionNum,Remarks,ChartLeft,ChartTop,RuleTypeDR)"_
		"SELECT RuleDR,FlowChartNum,NodeNum,NodeType,MeetConditionNum,Remarks,ChartLeft,ChartTop,RuleTypeDR FROM CT_WDT_CDSS.RuleNode"_
		" WHERE ID="_NodeDR_""
		s tStatement=##class(%SQL.Statement).%New()
		s qStatus = tStatement.%Prepare(SQL)
		if qStatus '= 1 
		{
			w "%Prepare failed:"
			d $System.Status.DisplayError(qStatus)
			q
		}
		s rset= tStatement.%Execute()
		//取ID-最新复制数据ID
		s NStatement=##class(%SQL.Statement).%New()
		s SQLID="SELECT MAX(ID) AS num FROM CT_WDT_CDSS.RuleNode"
		s flag = NStatement.%Prepare(SQLID)
		if flag '= 1 
		{
			w "%Prepare failed:"
			d $System.Status.DisplayError(flag)
			q
		}
		s rsetN = NStatement.%Execute()
		while rsetN.%Next() 
		{
			s NodeRowId= rsetN.num
			//b ;1
		}
		//修改节点数据RuleDR
		s obj=##class(CT.WDT.CDSS.RuleNode).%OpenId(NodeRowId)
		d obj.RuleDRSetObjectId(RuleRowId)
		s sc = obj.%Save()
		d obj.%Close()
		k obj
		//修改线数据中的节点
		if ($d(^CT.WDT.CDSS.RuleLinkI("PreNodeIndex",NodeDR))){	//如果原节点存在于线表 流程图上一个节点
			s LinkId=""
			for 
			{
				s LinkId = $o(^CT.WDT.CDSS.RuleLinkI("RulePreNodeIndex",RuleRowId,NodeDR,LinkId)) q:LinkId=""
				s obj=##class(CT.WDT.CDSS.RuleLink).%OpenId(LinkId)
				d obj.PreNodeSetObjectId(NodeRowId)
				s sc = obj.%Save()
				d obj.%Close()
				k obj
			}
		} 
		if ($d(^CT.WDT.CDSS.RuleLinkI("NextNodeIndex",NodeDR))){	//如果原节点存在于线表 流程图下一个节点
			s LinkId=""
			for 
			{
				s LinkId = $o(^CT.WDT.CDSS.RuleLinkI("RuleNextNodeIndex",RuleRowId,NodeDR,LinkId)) q:LinkId=""
				s obj=##class(CT.WDT.CDSS.RuleLink).%OpenId(LinkId)
				d obj.NextNodeSetObjectId(NodeRowId)
				s sc = obj.%Save()
				d obj.%Close()
				k obj
			}
		}
		/******************复制当前节点内容***********************/
		s NodeTypeId = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),5)		//节点类型
		if ((NodeTypeId=8)||(NodeTypeId=9)||(NodeTypeId=10)||(NodeTypeId=11)||(NodeTypeId=14)||(NodeTypeId=22)||(NodeTypeId=23)||(NodeTypeId=25)){
		
			//（辅助诊疗-推荐检验检查8、推荐评估表9、推荐护理处置10、推荐治疗方案11、推荐确诊14、推荐鉴别诊断22、推荐住院23、出院指导25）CT.WDT.CDSS.RuleResult
			s ResultRowId = ""
			for
			{
				s ResultRowId = $o(^CT.WDT.CDSS.RuleResultI("NodeDRIndex",NodeDR,ResultRowId)) q:ResultRowId=""
				s SQL="INSERT INTO CT_WDT_CDSS.RuleResult(NodeDR,Sequence,RecommendType,RecommendResult,Remarks,BaseTable,TreatSource,SourceImg,RuleBasisDR)"_
				"SELECT NodeDR,Sequence,RecommendType,RecommendResult,Remarks,BaseTable,TreatSource,SourceImg,RuleBasisDR FROM CT_WDT_CDSS.RuleResult"_
				" WHERE ID="_ResultRowId_""
				s tStatement=##class(%SQL.Statement).%New()
				s qStatus = tStatement.%Prepare(SQL)
				if qStatus '= 1 
				{
					w "%Prepare failed:"
					d $System.Status.DisplayError(qStatus)
					q
				}
				s rset= tStatement.%Execute()
				//取ID
				s Statement=##class(%SQL.Statement).%New()
				s SQL="SELECT MAX(ID) AS num FROM CT_WDT_CDSS.RuleResult"
				s qStatus = Statement.%Prepare(SQL)
				if qStatus '= 1 
				{
					w "%Prepare failed:"
					d $System.Status.DisplayError(qStatus)
					q
				}
				s rset = Statement.%Execute()
				while rset.%Next() 
				{
					s ResultId= rset.num
				}
				//修改数据
				s obj=##class(CT.WDT.CDSS.RuleResult).%OpenId(ResultId)
				d obj.NodeDRSetObjectId(NodeRowId)
				s sc = obj.%Save()
				d obj.%Close()
				k obj
			}
		}
		elseif ((NodeTypeId=5)||(NodeTypeId=6)||(NodeTypeId=7)||(NodeTypeId=27)||(NodeTypeId=3)||(NodeTypeId=4)){
			//（主要条件-诊断5、否定条件-识别词7、主要条件-识别词6、否定条件-诊断27、基本信息-年龄3、基本信息-性别4）CT.WDT.CDSS.RuleCondition
			
			S ConditionRowId=""
			for
			{
				s ConditionRowId = $o(^CT.WDT.CDSS.RuleConditionI("NodeDRIndex",NodeDR,ConditionRowId)) q:ConditionRowId=""
				s SQL="INSERT INTO CT_WDT_CDSS.RuleCondition(NodeDR,ConditionClass,ConditionItem,ConditionItemCalculate,ConditionItemValue,ConditionItemValUnit,SpecialConfig,Remarks)"_
				"SELECT NodeDR,ConditionClass,ConditionItem,ConditionItemCalculate,ConditionItemValue,ConditionItemValUnit,SpecialConfig,Remarks FROM CT_WDT_CDSS.RuleCondition"_
				" WHERE ID="_ConditionRowId_""
				s tStatement=##class(%SQL.Statement).%New()
				s qStatus = tStatement.%Prepare(SQL)
				if qStatus '= 1 
				{
					w "%Prepare failed:"
					d $System.Status.DisplayError(qStatus)
					q
				}
				s rset= tStatement.%Execute()
				//取ID
				s Statement=##class(%SQL.Statement).%New()
				s SQL="SELECT MAX(ID) AS num FROM CT_WDT_CDSS.RuleCondition"
				s qStatus = Statement.%Prepare(SQL)
				if qStatus '= 1 
				{
					w "%Prepare failed:"
					d $System.Status.DisplayError(qStatus)
					q
				}
				s rset = Statement.%Execute()
				while rset.%Next() 
				{
					s ConditionId= rset.num
				}
				//修改数据
				s obj=##class(CT.WDT.CDSS.RuleCondition).%OpenId(ConditionId)
				d obj.NodeDRSetObjectId(NodeRowId)
				s sc = obj.%Save()
				d obj.%Close()
				k obj
			}
		}elseif ((NodeTypeId=15)||(NodeTypeId=16)||(NodeTypeId=17)||(NodeTypeId=19)||(NodeTypeId=20)||(NodeTypeId=21)||(NodeTypeId=24)||(NodeTypeId=26)){
			
			//（检查15、检验16、手术17、护理/处置19、过敏20、输血21、药品24、诊断26 合理性）CT.WDT.CDSS.RuleRationality
			s RationalityRowId = ""
			for
			{
				s RationalityRowId = $o(^CT.WDT.CDSS.RuleRationalityI("NodeDRIndex",NodeDR,RationalityRowId)) q:RationalityRowId=""
				s SQL="INSERT INTO CT_WDT_CDSS.RuleRationality(NodeDR,Sequence,WarningContent,TabooLevel,Remarks,TreatSource,RuleBasisDR)"_
				"SELECT NodeDR,Sequence,WarningContent,TabooLevel,Remarks,TreatSource,RuleBasisDR FROM CT_WDT_CDSS.RuleRationality"_
				" WHERE ID="_RationalityRowId_""
				s tStatement=##class(%SQL.Statement).%New()
				s qStatus = tStatement.%Prepare(SQL)
				if qStatus '= 1
				{
					w "%Prepare failed:"
					d $System.Status.DisplayError(qStatus)
					q
				}
				s rset= tStatement.%Execute()
				//取ID
				s Statement=##class(%SQL.Statement).%New()
				s SQL="SELECT MAX(ID) AS num FROM CT_WDT_CDSS.RuleRationality"
				s qStatus = Statement.%Prepare(SQL)
				if qStatus '= 1 
				{
					w "%Prepare failed:"
					d $System.Status.DisplayError(qStatus)
					q
				}
				s rset = Statement.%Execute()
				while rset.%Next() 
				{
					s RationalityId= rset.num
				}
				//修改数据
				s obj=##class(CT.WDT.CDSS.RuleRationality).%OpenId(RationalityId)
				d obj.NodeDRSetObjectId(NodeRowId)
				s sc = obj.%Save()
				d obj.%Close()
				k obj
			}
		}elseif ((NodeTypeId=18)){
			
			//（手术并发症18）CT.WDT.CDSS.RuleComplication
			s ComplicationRowId = ""
			for
			{
				s ComplicationRowId = $o(^CT.WDT.CDSS.RuleComplicationI("NodeDRIndex",NodeDR,ComplicationRowId)) q:ComplicationRowId=""
				s SQL="INSERT INTO CT_WDT_CDSS.RuleComplication(NodeDR,Sequence,ComplicationDR,MainPoints,Remarks,TreatSource,RuleBasisDR)"_
				"SELECT NodeDR,Sequence,ComplicationDR,MainPoints,Remarks,TreatSource,RuleBasisDR FROM CT_WDT_CDSS.RuleComplication"_
				" WHERE ID="_ComplicationRowId_""
				s tStatement=##class(%SQL.Statement).%New()
				s qStatus = tStatement.%Prepare(SQL)
				if qStatus '= 1
				{
					w "%Prepare failed:"
					d $System.Status.DisplayError(qStatus)
					q
				}
				s rset= tStatement.%Execute()
				//取ID
				s Statement=##class(%SQL.Statement).%New()
				s SQL="SELECT MAX(ID) AS num FROM CT_WDT_CDSS.RuleComplication"
				s qStatus = Statement.%Prepare(SQL)
				if qStatus '= 1 
				{
					w "%Prepare failed:"
					d $System.Status.DisplayError(qStatus)
					q
				}
				s rset = Statement.%Execute()
				while rset.%Next() 
				{
					s ComplicationId= rset.num
				}
				//修改数据
				s obj=##class(CT.WDT.CDSS.RuleComplication).%OpenId(ComplicationId)
				d obj.NodeDRSetObjectId(NodeRowId)
				s sc = obj.%Save()
				d obj.%Close()
				k obj
			}
		}elseif ((NodeTypeId=12)||(NodeTypeId=13)||(NodeTypeId=28)||(NodeTypeId=29)||(NodeTypeId=30)){
			
			//（推荐治疗方案（药品12、手术13、方剂29、处置30、治法28））CT.WDT.CDSS.RuleDetail
			s DetailRowId = ""
			for
			{
				s DetailRowId = $o(^CT.WDT.CDSS.RuleDetailI("NodeLLevelIndex",NodeDR,-100000000000000,DetailRowId)) q:DetailRowId=""
				s SQL="INSERT INTO CT_WDT_CDSS.RuleDetail(NodeDR,Sequence,DrugDR,DrugUse,DosageMIN,DosageMINUnit,DosageMAX,DosageMAXUnit,Frequency,Remarks,LastLevel)"_
				"SELECT NodeDR,Sequence,DrugDR,DrugUse,DosageMIN,DosageMINUnit,DosageMAX,DosageMAXUnit,Frequency,Remarks,LastLevel FROM CT_WDT_CDSS.RuleDetail"_
				" WHERE ID="_DetailRowId_""
				s tStatement=##class(%SQL.Statement).%New()
				s qStatus = tStatement.%Prepare(SQL)
				if qStatus '= 1
				{
					w "%Prepare failed:"
					d $System.Status.DisplayError(qStatus)
					q
				}
				s rset= tStatement.%Execute()
				//取ID
				s Statement=##class(%SQL.Statement).%New()
				s SQL="SELECT MAX(ID) AS num FROM CT_WDT_CDSS.RuleDetail"
				s qStatus = Statement.%Prepare(SQL)
				if qStatus '= 1 
				{
					w "%Prepare failed:"
					d $System.Status.DisplayError(qStatus)
					q
				}
				s rset = Statement.%Execute()
				while rset.%Next() 
				{
					s DetailId= rset.num
				}
				//修改数据
				s obj=##class(CT.WDT.CDSS.RuleDetail).%OpenId(DetailId)
				//s obj.NodeDR = NodeRowId
				d obj.NodeDRSetObjectId(NodeRowId)
				s sc = obj.%Save()
				d obj.%Close()
				k obj
			}
		}		
	}
	q
	//w "流程图复制完成！"
}

/// Creator:丁亚男
/// CreatDate:2022-06-15
/// Description: 规则复制包括规则下所有内容
/// Table:CT.WDT.CDSS.RuleDict
/// Input: 被复制的规则ID、新的规则名称
/// Return: 
/// Other:w ##class(web.CDSS.CMKB.RuleDict).CopyRuleDataToNewRule("9776","社区获得性肺炎-单病种")
ClassMethod CopyRuleDataToNewRule(RuleDR As %String, Desc As %String = "")
{
	s result="false"
	/*************复制规则字典数据到新的规则数据****************/
	if $d(^CT.WDT.CDSS.RuleDictD(RuleDR))
	{
		s eobj = ##class(web.CDSSEntity.CMKB.RuleDict).%New() 
		s obj=##class(CT.WDT.CDSS.RuleDict).%OpenId(RuleDR)
		s eobj.RuleCode = ..GetLastCode()
		s eobj.RuleDesc = Desc 
		s eobj.RuleLoc = obj.RuleLoc 
		s eobj.RuleSource = obj.RuleSource 
		if $IsObject(obj.RuleType)
		{
		 	s eobj.RuleType = obj.RuleType.%Id()
		}
		s eobj.BatchNum = obj.BatchNum
		s eobj.RuleStatus = "编辑中"
		s eobj.Remarks = obj.Remarks
		s eobj.RuleProvision=obj.RuleProvision
		TS
		d obj.%Close()
		s result=..SaveData(eobj)
		
		if (result["true")
		{
			TC
			s NewRuleID=$p(result,"'",4)
			//第一次复制流程图下的线
			s LinkRowId = ""
			for
			{
				s LinkRowId = $o(^CT.WDT.CDSS.RuleLinkI("RuleDRIndex",RuleDR,LinkRowId)) q:LinkRowId=""
				s linkobj=##class(CT.WDT.CDSS.RuleLink).%OpenId(LinkRowId)
				s linkeobj = ##class(web.CDSSEntity.CMKB.RuleLink).%New()
				s linkeobj.RuleDR = NewRuleID
				s linkeobj.FlowChartNum = linkobj.FlowChartNum
				if $IsObject(linkobj.PreNode)
				{
				 	s linkeobj.PreNode = linkobj.PreNode.%Id()
				}
				if $IsObject(linkobj.NextNode)
				{
				 	s linkeobj.NextNode = linkobj.NextNode.%Id()
				}
				s linkeobj.Remarks = linkobj.Remarks
				if $IsObject(linkobj.RuleTypeDR)
				{
				 	s linkeobj.RuleTypeDR = linkobj.RuleTypeDR.%Id()
				}
				TS
				d linkobj.%Close()
				s linkresult=##class(web.CDSS.CMKB.RuleLink).SaveData(linkeobj)
				if (linkresult["true")
				{
					TC
				} else{
					TRO
				}
			}
			
			//流程图下的节点及节点内容
			s NodeRowId = ""
			for
			{
				s NodeRowId = $o(^CT.WDT.CDSS.RuleNodeI("RuleDRIndex",RuleDR,NodeRowId)) q:NodeRowId=""
				s Nodobj=##class(CT.WDT.CDSS.RuleNode).%OpenId(NodeRowId)
				s Nodeobj = ##class(web.CDSSEntity.CMKB.RuleNode).%New()
				s Nodeobj.RuleDR = NewRuleID
				s Nodeobj.FlowChartNum = Nodobj.FlowChartNum  
				s Nodeobj.NodeNum = Nodobj.NodeNum 
				if $IsObject(Nodobj.NodeType)
				{
				 	s Nodeobj.NodeType = Nodobj.NodeType.%Id()
				}
				s Nodeobj.MeetConditionNum = Nodobj.MeetConditionNum
				s Nodeobj.Remarks = Nodobj.Remarks
				s Nodeobj.ChartLeft = Nodobj.ChartLeft
				s Nodeobj.ChartTop = Nodobj.ChartTop
				if $IsObject(Nodobj.RuleTypeDR)
				{
				 	s Nodeobj.RuleTypeDR = Nodobj.RuleTypeDR.%Id()
				}
				TS
				d Nodobj.%Close()
				s noderesult=##class(web.CDSS.CMKB.RuleNode).SaveData(Nodeobj)
			
				if (noderesult["true")	
				{
					TC
					s NewNodeID=$p(noderesult,"'",4)
					
					//复制节点内容
					//复制诊疗节点内容表（触发条件类）
					s ConditionRowId = 0
					for
					{
						s ConditionRowId = $o(^CT.WDT.CDSS.RuleConditionI("NodeDRIndex",NodeRowId,ConditionRowId)) q:ConditionRowId=""
						
						s Conditionobj=##class(CT.WDT.CDSS.RuleCondition).%OpenId(ConditionRowId)
						s Conditioneobj = ##class(web.CDSSEntity.CMKB.RuleCondition).%New() 
						s Conditioneobj.NodeDR = NewNodeID
						
						s Conditioneobj.ConditionClass = Conditionobj.ConditionClass  
						s Conditioneobj.ConditionItem = Conditionobj.ConditionItem 
						s Conditioneobj.ConditionItemValue = Conditionobj.ConditionItemValue 
						s Conditioneobj.ConditionItemCalculate = Conditionobj.ConditionItemCalculate
						if $IsObject(Conditionobj.ConditionItemValUnit)
						{
						 	s Conditioneobj.ConditionItemValUnit = Conditionobj.ConditionItemValUnit.%Id()
						}
						s Conditioneobj.SpecialConfig = Conditionobj.SpecialConfig
						s Conditioneobj.Remarks = Conditionobj.Remarks
						s Conditioneobj.ConditionItemCategory = Conditionobj.ConditionItemCategory
						TS
						d Conditionobj.%Close()
						s Conditionresult=##class(web.CDSS.CMKB.RuleCondition).SaveData(Conditioneobj)
						if (Conditionresult["true")	
						{
							TC
						} else {
							TRO
						}
					}
		
					//复制诊疗节点内容表（辅助诊疗-推荐辅助检验检查、推荐评估表、推荐护理措施、推荐治疗方案，推荐确诊）
					s ResultRowId = 0
					for
					{
						s ResultRowId = $o(^CT.WDT.CDSS.RuleResultI("NodeDRIndex",NodeRowId,ResultRowId)) q:ResultRowId=""
						s Resultobj=##class(CT.WDT.CDSS.RuleResult).%OpenId(ResultRowId)
						s Resulteobj = ##class(web.CDSSEntity.CMKB.RuleResult).%New() 
						
						s Resulteobj.NodeDR = NewNodeID
						s Resulteobj.Sequence = Resultobj.Sequence
						s Resulteobj.RecommendType = Resultobj.RecommendType
						s Resulteobj.RecommendResult = Resultobj.RecommendResult
						s Resulteobj.Remarks = Resultobj.Remarks
						s Resulteobj.BaseTable = Resultobj.BaseTable
						s Resulteobj.TreatSource = Resultobj.TreatSource
						s Resulteobj.SourceImg = Resultobj.SourceImg
						if $IsObject(Resultobj.RuleBasisDR)
						{
						 	s OldRuleBasisDR=Resultobj.RuleBasisDR.%Id()
						 	s NewRuleBasisDR=##class(web.CDSS.CMKB.RuleBasis).CopyNode(OldRuleBasisDR)
						 	if (NewRuleBasisDR'="")
						 	{
							 	s Resulteobj.RuleBasisDR =NewRuleBasisDR
							}
						 	else
						 	{
							 	d Resulteobj.RuleBasisDRObjectId("")
							}
						 	
						}
						TS
						d Resultobj.%Close()
						s Resultresult=##class(web.CDSS.CMKB.RuleResult).SaveData("", NewNodeID, Resulteobj.Sequence, Resulteobj.RecommendType, Resulteobj.RecommendResult, Resulteobj.Remarks, Resulteobj.BaseTable, Resulteobj.TreatSource, Resulteobj.SourceImg, Resulteobj.RuleBasisDR)
						if (Resultresult["true")	
						{
							TC
						} else {
							TRO
						}
					
					}
					//复制治疗方案明细表（推荐治疗方案-药品、推荐治疗方案-手术） 治法-方剂-方剂组成  /处置（护理字典）
					s DetailRowId = 0
					for
					{
						s DetailRowId = $o(^CT.WDT.CDSS.RuleDetailI("NodeLLevelIndex",NodeRowId,-100000000000000,DetailRowId)) q:DetailRowId=""
						s Detailobj=##class(CT.WDT.CDSS.RuleDetail).%OpenId(DetailRowId)
						s Detaileobj = ##class(web.CDSSEntity.CMKB.RuleDetail).%New() 
						s Detaileobj.NodeDR = NewNodeID
						s Detaileobj.Sequence = Detailobj.Sequence
						s Detaileobj.DrugDR = Detailobj.DrugDR 
						s Detaileobj.DrugUse = Detailobj.DrugUse 
						s Detaileobj.DosageMIN = Detailobj.DosageMIN 
						if $IsObject(Detailobj.DosageMINUnit)
						{
						 	s Detaileobj.DosageMINUnit = Detailobj.DosageMINUnit.%Id()
						}
						s Detaileobj.DosageMAX = Detailobj.DosageMAX 
						if $IsObject(Detailobj.DosageMAXUnit)
						{
						 	s Detaileobj.DosageMAXUnit = Detailobj.DosageMAXUnit.%Id()
						} 
						if $IsObject(Detailobj.Frequency)
						{
						 	s Detaileobj.Frequency = Detailobj.Frequency.%Id()
						}
						s Detaileobj.Remarks = Detailobj.Remarks
						
						if $IsObject(Detailobj.LastLevel)
						{
						 	s Detaileobj.LastLevel = Detailobj.LastLevel.%Id()
						}
						TS
						d Detailobj.%Close()
						s Detailresult=##class(web.CDSS.CMKB.RuleDetail).SaveData(Detaileobj)
						if (Detailresult["true")
						{
							TC
							s NewDetailParentID=$p(Detailresult,"'",4)
							//复制子节点 只有一级子节点
							s ChildRowId = ""
							for
							{
								s ChildRowId = $o(^CT.WDT.CDSS.RuleDetailI("LastLevelIndex",DetailRowId,ChildRowId)) q:ChildRowId=""
								s Childobj=##class(CT.WDT.CDSS.RuleDetail).%OpenId(ChildRowId)
								s Childeobj = ##class(web.CDSSEntity.CMKB.RuleDetail).%New() 
								s Childeobj.NodeDR = NewNodeID
								s Childeobj.Sequence = Childobj.Sequence
								s Childeobj.DrugDR = Childobj.DrugDR 
								s Childeobj.DrugUse = Childobj.DrugUse 
								s Childeobj.DosageMIN = Childobj.DosageMIN 
								if $IsObject(Childobj.DosageMINUnit)
								{
								 	s Childeobj.DosageMINUnit = Childobj.DosageMINUnit.%Id()
								}
								s Childeobj.DosageMAX = Childobj.DosageMAX 
								if $IsObject(Childobj.DosageMAXUnit)
								{
								 	s Childeobj.DosageMAXUnit = Childobj.DosageMAXUnit.%Id()
								} 
								if $IsObject(Childobj.Frequency)
								{
								 	s Childeobj.Frequency = Childobj.Frequency.%Id()
								}
								s Childeobj.Remarks = Childobj.Remarks
								s Childeobj.LastLevel = NewDetailParentID
								TS
								d Childobj.%Close()
								s Childresult=##class(web.CDSS.CMKB.RuleDetail).SaveData(Childeobj)
								if (Childresult["true")
								{
									TC
								}else{
									TRO
								}
							}
								
		
						} else{
							TRO
						}
		
					}
					
					//复制诊疗节点内容表（预警规则-合理性）
					s RationalityRowId = 0
					for
					{
						s RationalityRowId = $o(^CT.WDT.CDSS.RuleRationalityI("NodeDRIndex",NodeRowId,RationalityRowId)) q:RationalityRowId=""
						
						s Rationalityobj=##class(CT.WDT.CDSS.RuleRationality).%OpenId(RationalityRowId)
						s Rationalityeobj = ##class(web.CDSSEntity.CMKB.RuleRationality).%New() 
						
						s Rationalityeobj.NodeDR = NewNodeID
						s Rationalityeobj.Sequence = Rationalityobj.Sequence  
						s Rationalityeobj.WarningContent = Rationalityobj.WarningContent 
						s Rationalityeobj.TabooLevel = Rationalityobj.TabooLevel 
						s Rationalityeobj.Remarks = Rationalityobj.Remarks
						s Rationalityeobj.TreatSource = Rationalityobj.TreatSource
						if $IsObject(Rationalityeobj.RuleBasisDR)
						{
						 	s OldRuleBasisDR=Rationalityeobj.RuleBasisDR.%Id()
						 	s NewRuleBasisDR=##class(web.CDSS.CMKB.RuleBasis).CopyNode(OldRuleBasisDR)
						 	if (NewRuleBasisDR'="")
						 	{
							 	s Rationalityeobj.RuleBasisDR =NewRuleBasisDR
							}
						 	else
						 	{
							 	d Rationalityeobj.RuleBasisDRObjectId("")
							}
						 	
						}
						TS
						d Rationalityobj.%Close()
						s Rationalityresult=##class(web.CDSS.CMKB.RuleRationality).SaveData(Rationalityeobj)
						if (Rationalityresult["true")
						{
							TC
						}else{
							TRO
						}
					}
					
					//复制诊疗节点内容表（预警规则-并发症）
					s ComplicationRowId = 0
					for
					{
						s ComplicationRowId = $o(^CT.WDT.CDSS.RuleComplicationI("NodeDRIndex",NodeRowId,ComplicationRowId)) q:ComplicationRowId=""
						s Complicationobj=##class(CT.WDT.CDSS.RuleComplication).%OpenId(ComplicationRowId)
						s Complicationeobj = ##class(web.CDSSEntity.CMKB.RuleComplication).%New() 
						
						s Complicationeobj.NodeDR = NewNodeID
						s Complicationeobj.Sequence = Complicationobj.Sequence  
						if $IsObject(Complicationobj.ComplicationDR)
						{
						 	s Complicationeobj.ComplicationDR = Complicationobj.ComplicationDR.%Id()
						}
						s Complicationeobj.MainPoints = Complicationobj.MainPoints 
						s Complicationeobj.Remarks = Complicationobj.Remarks
						s Complicationeobj.TreatSource = Complicationobj.TreatSource
						if $IsObject(Complicationeobj.RuleBasisDR)
						{
						 	s OldRuleBasisDR=Complicationeobj.RuleBasisDR.%Id()
						 	s NewRuleBasisDR=##class(web.CDSS.CMKB.RuleBasis).CopyNode(OldRuleBasisDR)
						 	if (NewRuleBasisDR'="")
						 	{
							 	s Complicationeobj.RuleBasisDR =NewRuleBasisDR
							}
						 	else
						 	{
							 	d Complicationeobj.RuleBasisDRObjectId("")
							}
						 	
						}
						TS
						d Complicationobj.%Close()
						s Complicationresult=##class(web.CDSS.CMKB.RuleComplication).SaveData(Complicationeobj)
						if (Complicationresult["true")
						{
							TC
						}else{
							TRO
						}
					}
					//更新新规则的流程图线指向
					&sql(update CT_WDT_CDSS.RuleLink
					set PreNode=:NewNodeID
					where RuleDR=:NewRuleID AND PreNode=:NodeRowId)
					
					&sql(update CT_WDT_CDSS.RuleLink
					set NextNode=:NewNodeID
					where RuleDR=:NewRuleID AND NextNode=:NodeRowId)
				} else {
					TRO
					}
			}
		} else {
			TRO
		}
	}
	q result
}

/// Creator:赵文伟
/// CreatDate:2022-06-17
/// Description: 处理重复线数据，删除id最小的重复数据
/// Table:CT.WDT.CDSS.RuleDict
/// Input: 
/// Return: num [处理数据数量]
/// Other:d ##class(web.CDSS.CMKB.RuleDict).HandleRepeatData()
ClassMethod HandleRepeatData() As %String
{
	s num=0
	//&sql(SELECT * FROM CT_WDT_CDSS.RuleLink GROUP BY PreNode,NextNode HAVING count(*)>1)
	s SQL="SELECT ID AS id FROM CT_WDT_CDSS.RuleLink GROUP BY PreNode,NextNode HAVING count(*)>1 AND RuleDR=10460"
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
			s LinkId= rset.id
			s result= ##class(web.CDSS.CMKB.RuleLink).DeleteData(LinkId)
			if (result["success"){
				s num=num+1
			}
		}
		w "共处理"_num_"条数据！"
}

/// Creator:赵文伟
/// CreatDate:2022-06-17
/// Description: 处理重复线数据，删除id最小的重复数据
/// Table:CT.WDT.CDSS.RuleDict
/// Other:d ##class(web.CDSS.CMKB.RuleDict).HandleRepeatLinkData()
ClassMethod HandleRepeatLinkData() As %String
{
	
	s SQL="SELECT ID AS id FROM CT_WDT_CDSS.RuleLink GROUP BY PreNode,NextNode HAVING count(*)>1"
	s tStatement=##class(%SQL.Statement).%New()
		s qStatus = tStatement.%Prepare(SQL)
		if qStatus '= 1
		{
			w "%Prepare failed:"
			d $System.Status.DisplayError(qStatus)
			q
		}
		s rset= tStatement.%Execute()
		
		if (rset.id=""){
			w "数据处理完成！"
			q
		}
		while rset.%Next() 
		{
			s LinkId= rset.id
			s result= ##class(web.CDSS.CMKB.RuleLink).DeleteData(LinkId)

		}
		d ..HandleRepeatLinkData()
		
		w "数据处理完成2！"
}

/// Creator:赵文伟
/// CreatDate:2022-08-12
/// Description：按条件返回规则流程图节点和线表数据
/// Input：规则ID、规则节点内容、节点类型ID、规则类型ID
/// Return: 返回流程图节点和线表数据
/// Other:w ##class(web.CDSS.CMKB.RuleDict).GetRuleNodeLineJsonNew("987","脑梗死","6","12")
ClassMethod GetRuleNodeLineJsonNew(RuleDR As %String, ItemValue As %String, NodeTypeId As %String, RuleTypeId As %String = "") As %String
{
	if ItemValue="" q ""
	s GlobalStr=""
	s:ItemValue'="" ItemValue=$ZCONVERT(ItemValue,"U") //转换成大写 
	if RuleTypeId="" s RuleTypeId=-100000000000000
	
	s GlobalStr=GlobalStr_"["
	s count=0
	s FlowChartNumN=""
	for
	{
		s FlowChartNumN = $o(^CT.WDT.CDSS.RuleNodeI("TypeChartIndex",RuleDR,RuleTypeId,FlowChartNumN)) q:FlowChartNumN=""
		s WriteFlag=""
		s NodeDR=""
		for
		{
			s NodeDR = $o(^CT.WDT.CDSS.RuleNodeI("RuleChartTypeIndex",RuleDR,RuleTypeId,FlowChartNumN,NodeTypeId,NodeDR)) q:NodeDR=""
			if ((NodeTypeId=8)||(NodeTypeId=9)||(NodeTypeId=10)||(NodeTypeId=11)||(NodeTypeId=14)||(NodeTypeId=22)||(NodeTypeId=23)||(NodeTypeId=25)){
			
				//（辅助诊疗-推荐检验检查8、推荐评估表9、推荐护理处置10、推荐治疗方案11、推荐确诊14、推荐鉴别诊断22、推荐住院23、出院指导25）CT.WDT.CDSS.RuleResult
				s ResultRowId = ""
				for
				{
					s ResultRowId = $o(^CT.WDT.CDSS.RuleResultI("NodeDRIndex",NodeDR,ResultRowId),-1) q:ResultRowId=""
					
					s RecommendType  = $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),4)
					s RecommendResult  = $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),5)
					s RecommendResultDesc=""
					if (RecommendType="检验") 
					{
						s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(RecommendResult)),4)
					}
					elseif(RecommendType="检查")
					{
						s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.ExamDictD(RecommendResult)),4)
					}
					elseif(RecommendType="检验医嘱")
					{
						s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(RecommendResult)),3)
					}
					elseif(RecommendType="评估表")
					{
						s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.AssBaseD(RecommendResult)),3)
					}
					elseif(RecommendType="治疗方案")
					{
						s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.TreatDictD(RecommendResult)),3)
					}
					elseif((RecommendType="确诊诊断")||(RecommendType="鉴别诊断"))
					{
						s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.DiseaseDictD(RecommendResult)),3)
					}
					elseif(RecommendType="护理措施")
					{
						s RecommendResultDesc=$LISTGET($G(^CT.WDT.CDSS.NursingDictD(RecommendResult)),4)
					}elseif(RecommendType="文献"){
						s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.DocuManageD(RecommendResult)),3) //中文文献名称
					}elseif(RecommendType="出院指导"){
						s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.DischargeGuideD(RecommendResult)),2)
					}
				
					if ($ZCONVERT(RecommendResultDesc,"U")[ItemValue)
					{
						s count=count+1
						if count>1 s GlobalStr=GlobalStr_","
						s GlobalStr=GlobalStr_..TraversalRuleJson(RuleDR,FlowChartNumN,RuleTypeId)
						s WriteFlag=1
					}
					q:WriteFlag=1	
				}
			}
			elseif ((NodeTypeId=5)||(NodeTypeId=6)||(NodeTypeId=7)||(NodeTypeId=27)||(NodeTypeId=31)){
				
				//（主要条件-诊断5、否定条件-识别词7、主要条件-识别词6、否定条件-诊断27、通过条件31）CT.WDT.CDSS.RuleCondition
				
				S ConditionRowId=""
				for
				{
					s ConditionRowId = $o(^CT.WDT.CDSS.RuleConditionI("NodeDRIndex",NodeDR,ConditionRowId),-1) q:ConditionRowId=""
					s ConditionItemValue  = $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowId)),6)
					
					if ($ZCONVERT(ConditionItemValue,"U")[ItemValue){
						s count=count+1
						if count>1 s GlobalStr=GlobalStr_","
						s GlobalStr=GlobalStr_..TraversalRuleJson(RuleDR,FlowChartNumN,RuleTypeId)
						s WriteFlag=1
					}
					q:WriteFlag=1			
				}
			}elseif ((NodeTypeId=15)||(NodeTypeId=16)||(NodeTypeId=17)||(NodeTypeId=19)||(NodeTypeId=20)||(NodeTypeId=21)||(NodeTypeId=24)||(NodeTypeId=26)){
				
				//（检查15、检验16、手术17、护理/处置19、过敏20、输血21、药品24、诊断26 合理性）CT.WDT.CDSS.RuleRationality
				s RationalityRowId = ""
				
				for
				{
					s RationalityRowId = $o(^CT.WDT.CDSS.RuleRationalityI("NodeDRIndex",NodeDR,RationalityRowId),-1) q:RationalityRowId=""
					s WarningContent  = $lg($g(^CT.WDT.CDSS.RuleRationalityD(RationalityRowId)),4)
					
					if ($ZCONVERT(WarningContent,"U")[ItemValue){
						s count=count+1
						if count>1 s GlobalStr=GlobalStr_","
						s GlobalStr=GlobalStr_..TraversalRuleJson(RuleDR,FlowChartNumN,RuleTypeId)
						s WriteFlag=1
					}
					q:WriteFlag=1	
				}
			}elseif ((NodeTypeId=18)){
				
				//（手术并发症18）CT.WDT.CDSS.RuleComplication
				s ComplicationRowId = ""
				
				for
				{
					s ComplicationRowId = $o(^CT.WDT.CDSS.RuleComplicationI("NodeDRIndex",NodeDR,ComplicationRowId),-1) q:ComplicationRowId=""
					s ComplicationDR  = $lg($g(^CT.WDT.CDSS.RuleComplicationD(ComplicationRowId)),4)
					s ComplicationDRDesc=""
					s:ComplicationDR'="" ComplicationDRDesc=$lg($g(^CT.WDT.CDSS.DiseaseDictD(ComplicationDR)),3)
				
					if ($ZCONVERT(ComplicationDRDesc,"U")[ItemValue)
					{
						s count=count+1
						if count>1 s GlobalStr=GlobalStr_","
						s GlobalStr=GlobalStr_..TraversalRuleJson(RuleDR,FlowChartNumN,RuleTypeId)
						s WriteFlag=1
					}
					q:WriteFlag=1	
				}
			}elseif ((NodeTypeId=12)||(NodeTypeId=13)||(NodeTypeId=28)||(NodeTypeId=29)||(NodeTypeId=30)){
				
				//（推荐治疗方案（药品12、手术13、方剂29、处置30、治法28））CT.WDT.CDSS.RuleDetail
				s DetailRowId = ""
				for
				{
					s DetailRowId = $o(^CT.WDT.CDSS.RuleDetailI("NodeLLevelIndex",NodeDR,-100000000000000,DetailRowId),-1) q:DetailRowId=""
					s NodeType=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),5)
					s NodeTypeDesc=""
					s:NodeType'="" NodeTypeDesc=$lg($g(^CT.WDT.CDSS.NodeTypeD(NodeType)),3)
								
					s DrugDR  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),4)
					s DrugUse  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),5)
					s DrugDRName="",DrugUseName=""
					if (NodeTypeDesc="推荐治疗方案-药品") 
					{
						s DrugDRName=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugDR)),4)
						s:DrugUse'="" DrugUseName=$lg($g(^CT.WDT.CDSS.UsageDictD(DrugUse)),3)
					}
					elseif(NodeTypeDesc="推荐治疗方案-手术") 
					{
						s DrugDRName=$lg($g(^CT.WDT.CDSS.OperationDictD(DrugDR)),4)
						s:DrugUse'="" DrugUseName=$lg($g(^CT.WDT.CDSS.UsageDictD(DrugUse)),3)
					}
					elseif(NodeTypeDesc="推荐治疗方案-治法")   //治疗方案-治法-方剂-方剂组成
					{
						s DrugDRName=$lg($g(^CT.WDT.CDSS.TCMTreatmentD(DrugDR)),3)
					}
					elseif(NodeTypeDesc="推荐治疗方案-方剂")   //治疗方案-治法-方剂-方剂组成
					{
						s DrugDRName=$lg($g(^CT.WDT.CDSS.TCMPrescriptionD(DrugDR)),3)
					}
					elseif(NodeTypeDesc="推荐治疗方案-处置")   //治疗方案-处置(护理字典)-处置明细
					{
						s DrugDRName=$lg($g(^CT.WDT.CDSS.NursingDictD(DrugDR)),4)  //护理名称
					}
					continue:DrugDRName=""

					
					if ($ZCONVERT(DrugDRName,"U")[ItemValue)
					//if (DrugDRName=ItemValue)
					{
						s count=count+1
						if count>1 s GlobalStr=GlobalStr_","
						s GlobalStr=GlobalStr_..TraversalRuleJson(RuleDR,FlowChartNumN,RuleTypeId)
						s WriteFlag=1
					}
					q:WriteFlag=1	
				}
				
			}
			q:WriteFlag=1
		}
		continue:WriteFlag=1
	}
	s GlobalStr=GlobalStr_"]"
	q GlobalStr
}

/// Creator:赵文伟
/// CreatDate:2022-08-12
/// Description：遍历节点和线数据
/// Input：规则ID、规则节点内容、节点类型ID、规则类型ID
/// Return: 返回流程图节点和线表数据
/// Other:d ##class(web.CDSS.CMKB.RuleDict).TraversalRuleJson("480","1","")
ClassMethod TraversalRuleJson(RuleDR As %String, FlowChartNumT As %String, RuleTypeId As %String) As %String
{
	s GlobalStr=""
	s count=0
	if RuleTypeId="" s RuleTypeId=-100000000000000
	s startNodeType=1	//开始节点
	
	//1、先取符合条件的开始节点数据
	s NodeIdTemp={}
	
	s NodeRowId = ""		
	for
	{
		s NodeRowId = $o(^CT.WDT.CDSS.RuleNodeI("RuleChartTypeIndex",RuleDR,RuleTypeId,FlowChartNumT,startNodeType,NodeRowId)) q:NodeRowId=""
		s nflag=NodeIdTemp.%Get(NodeRowId)	//如果该值不存在，则返回空字符串“” 。
		
		if (nflag=""){
			d NodeIdTemp.%Set(NodeRowId,NodeRowId)
			
			s FlowChartNum = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),3)
			
			s NodeNum  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),4)
			s NodeType  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),5)
			s NodeTypeDesc=""
			s:NodeType'="" NodeTypeDesc= $lg($g(^CT.WDT.CDSS.NodeTypeD(NodeType)),3)	
			s MeetConditionNum  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),6)
			s Remarks  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),7)
			s ChartLeft  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),8)
			s ChartTop  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),9)
			s RuleTypeDR  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),10)
			s ChartTypeDesc=""
			s:RuleTypeDR'="" ChartTypeDesc= $lg($g(^CT.WDT.CDSS.ChartTypeD(RuleTypeDR)),3)
			
			s count=count+1
				if count>1 s PartStr=PartStr_ ","
				s GlobalStr=GlobalStr_ "[{""NodeRowId"":"""_NodeRowId_""""
				s GlobalStr=GlobalStr_ ",""FlowChartNum"":"""_FlowChartNum_""",""NodeNum"":"""_NodeNum_""",""NodeType"":"""_NodeType_""",""NodeTypeDesc"":"""_NodeTypeDesc_""",""MeetConditionNum"":"""_MeetConditionNum
				_""",""ChartLeft"":"""_ChartLeft_""",""ChartTop"":"""_ChartTop_""",""RuleTypeDR"":"""_RuleTypeDR_""",""ChartTypeDesc"":"""_ChartTypeDesc_""""
				s GlobalStr=GlobalStr_"}"
			//2、再按流程顺序取开始节点后续线和节点数据	
			s NodeId=NodeRowId
			s GlobalStr=##class(web.CDSS.CMKB.RuleNode).GetFollowRuleJson(GlobalStr,RuleDR,NodeId,RuleTypeId)	
			
		}
	}
	q GlobalStr
}

/// Creator:赵文伟
/// CreatDate:2022-11-03
/// Description：导出循证规则推荐检验检查模块下的检验数据
/// Input：
/// Return:
/// Other:w ##class(web.CDSS.CMKB.RuleDict).ExportLabData('','','','','','','','1','','')
ClassMethod ExportLabData(desc, Loc, Source, UUser, AUser, BNum, Status, RType, SUpdateDate, EUpdateDate) As %String
{
	//s User=1 //%session.Get("LOGON.USERID")
	/*s Path=##class(%File).GetDirectory()
	
	s Disk=$p(Path,":",1)
	b ;3
	s PathDir=Disk_":\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\"
	s ifExistsDir=##class(%File).DirectoryExists(PathDir)
	if ifExistsDir'=1
	{
		d ##class(%File).CreateDirectory("D:\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\")
	}
	s P=Disk_":\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\循证规则检验数据.csv"
	b ;1
	s file=##class(%File).%New(P)
	s filename = "循证规则检验数据.csv"
	*/
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"循证规则检验数据.csv"		
	s file=""			 	;key转放到web目录下
	if (Path["\"){
		s DirName = Path_"scripts\bdp\CDSS\DataExport\"
		s file = Path_"scripts\bdp\CDSS\DataExport\"_fileName
	}else{
		s DirName = Path_"scripts/bdp/CDSS/DataExport/"
		s file = Path_"scripts/bdp/CDSS/DataExport/"_fileName
	}
	if '##class(%File).DirectoryExists(DirName){	//文件保存路径不存在，新建文件夹
		d ##class(%File).CreateDirectoryChain(DirName)
	}
	d file.Open("NWS")
	d file.Write("规则ID,"_"规则编码,"_"规则名称,"_"流程图顺序号,"_"节点类型,"_"节点内容表ID,"_"类型,"_"名称")
	d file.WriteLine()
	s date=""
	for
	{
		s date=$o(^CT.WDT.CDSS.RuleDictI("DateIndex",date),-1) q:date=""
		b ;2
		s RuleRowId=""
		for
		{ 
			s RuleRowId=$o(^CT.WDT.CDSS.RuleDictI("DateIndex",date,RuleRowId),-1) q:RuleRowId="" 
			s RuleCode=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),2)
			s RuleDesc=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),3)
			s RuleLocDRs=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),4)
			s RuleLoc="",LocFlag=0
			if (RuleLocDRs'="")
		 	{
			 	s LocLen=$L(RuleLocDRs,"，")
			 	for iLoc=1:1:LocLen
			 	{
				 	s LocDR=$p(RuleLocDRs,"，",iLoc)
				 	s:RuleLoc'="" RuleLoc=RuleLoc_"，"_$lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(LocDR)),3)
				 	s:RuleLoc="" RuleLoc=$lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(LocDR)),3)
				}
			}
			s RuleSourceDRs=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),5)
			s RuleSource=RuleSourceDRs 
			s RuleTypeDR=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),6)
			s RuleType=""
			s:RuleTypeDR'="" RuleType=$LISTGET($G(^CT.WDT.CDSS.ChartTypeD(RuleTypeDR)),3)
			s BatchNum=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),7)
			s RuleStatus=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),8)
			s UpdateUser=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),9)
			s UpdateDate=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),10)
			s AuditUser=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),11)
			s AuditDate=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),12)
			s Remarks=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),13)
			s RuleProvision=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),14)
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
			s RuleSourceNew = $replace(RuleSource,",","，")	
			if ((($ZCONVERT(RuleDesc,"U")[desc))||(RuleDesc[desc))&&(((Loc'="")&&(LocFlag=1))||(Loc=""))&&(((Source'="")&&(RuleSourceDRs[Source))||(Source=""))&&($ZCONVERT(AuditUser,"U")[AUser)&&($ZCONVERT(UpdateUser,"U")[UUser)
			&&($ZCONVERT(RuleStatus,"U")[Status)&&($ZCONVERT(BatchNum,"U")[BNum)&&(((RType'="")&&(RuleTypeDR=RType))||(RType=""))&&(SUpdateDateFlag=1)&&(EUpdateDateFlag=1){
				//RuleTypeDR=12 【推荐检验检查】
				s NodeRowId = ""
				s NodeType= 8	//【推荐检验/检查】
				
				for
				{
					s NodeRowId = $o(^CT.WDT.CDSS.RuleNodeI("RuleDRNodeTypeIndex",RuleDR,NodeType,NodeRowId)) q:NodeRowId=""
					s FlowChartNum  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),3)
					s NodeNum  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),4)
					s NodeType  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),5)
					s NodeTypeDesc=""
					s:NodeType'="" NodeTypeDesc= $lg($g(^CT.WDT.CDSS.NodeTypeD(NodeType)),3)
					
					s ResultRowId = ""
					for
					{
						s ResultRowId = $o(^CT.WDT.CDSS.RuleResultI("NodeRecommendIndex",NodeRowId,"检验",ResultRowId),-1) q:ResultRowId=""
						
						s RecommendType  = $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),4)
						s RecommendResult  = $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),5)
						s RecommendResultDesc=""
						s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(RecommendResult)),4)
						//continue:RecommendType'="检验"
						
						/*if (RecommendType="检验") 
						{
							s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(RecommendResult)),4)
						}
						elseif(RecommendType="检查")
						{
							s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.ExamDictD(RecommendResult)),4)
						}
						elseif(RecommendType="检验医嘱")
						{
							s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(RecommendResult)),3)
						}*/
						//("规则ID,"_"规则编码,"_"规则名称,"_"流程图顺序号,"_"节点类型,"_"节点内容表ID,"_"类型,"_"名称")
						d file.Write(RuleRowId_",")
						d file.Write(RuleCode_",")
						d file.Write(RuleDesc_",")
						d file.Write(FlowChartNum_",")
						d file.Write(NodeTypeDesc_",")
						d file.Write(ResultRowId_",")
						d file.Write(RecommendType_",")
						d file.Write(RecommendResultDesc)
						d file.WriteLine()
					}
				}
			}
		}	
		
	}
	d file.%Save()
	d file.%Close()
	q filename
}

/// Creator:赵文伟
/// CreatDate:2022-11-03
/// Description：导出循证规则推荐检验检查模块下的检验数据
/// Input：
/// Return:
/// Other:w ##class(web.CDSS.CMKB.RuleDict).ExportLabDataT()
ClassMethod ExportLabDataT()
{
	//s User=1 //%session.Get("LOGON.USERID")
	/*s Path=##class(%File).GetDirectory()
	
	s Disk=$p(Path,":",1)
	b ;3
	s PathDir=Disk_":\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\"
	s ifExistsDir=##class(%File).DirectoryExists(PathDir)
	if ifExistsDir'=1
	{
		d ##class(%File).CreateDirectory("D:\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\")
	}
	s P=Disk_":\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\循证规则检验数据.csv"
	
	s file=##class(%File).%New(P)
	s filename = "循证规则检验数据.csv"
	*/
	s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName="循证规则检验数据.csv"
	s P=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\DataExport\"_fileName
	s file=##class(%File).%New(P)
	d file.Open("NWS")
	
	
	/*
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"循证规则检验数据.csv"		
	s file=""			 	;key转放到web目录下
	if (Path["\"){
		s DirName = Path_"scripts\bdp\CDSS\DataExport\"
		s file = Path_"scripts\bdp\CDSS\DataExport\"_fileName
	}else{
		s DirName = Path_"scripts/bdp/CDSS/DataExport/"
		s file = Path_"scripts/bdp/CDSS/DataExport/"_fileName
	}
	if '##class(%File).DirectoryExists(DirName){	//文件保存路径不存在，新建文件夹
		d ##class(%File).CreateDirectoryChain(DirName)
	}
	d file.Open("NWS")
	*/
	d file.Write("规则ID,"_"规则编码,"_"规则名称,"_"流程图顺序号,"_"节点类型,"_"节点内容表ID,"_"类型,"_"ID,"_"名称")
	d file.WriteLine()
	s date=""
	for
	{
		s date=$o(^CT.WDT.CDSS.RuleDictI("DateIndex",date),-1) q:date=""
		
		s RuleRowId=""
		for
		{ 
			s RuleRowId=$o(^CT.WDT.CDSS.RuleDictI("DateIndex",date,RuleRowId),-1) q:RuleRowId="" 
			s RuleCode=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),2)
			s RuleDesc=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),3)
			
			s RuleTypeDR=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),6)
			s RuleType=""
			s:RuleTypeDR'="" RuleType=$LISTGET($G(^CT.WDT.CDSS.ChartTypeD(RuleTypeDR)),3)
			
			//continue:RuleTypeDR'="1"
				//RuleTypeDR=12 【推荐检验检查】
				s NodeRowId = ""
				s NodeType= 8	//【推荐检验/检查】
				
				for
				{
					s NodeRowId = $o(^CT.WDT.CDSS.RuleNodeI("RuleDRNodeTypeIndex",RuleRowId,NodeType,NodeRowId)) q:NodeRowId=""
					
					s FlowChartNum  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),3)
					s NodeNum  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),4)
					s NodeType  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),5)
					s NodeTypeDesc=""
					s:NodeType'="" NodeTypeDesc= $lg($g(^CT.WDT.CDSS.NodeTypeD(NodeType)),3)
					
					s ResultRowId = ""
					for
					{
						s ResultRowId = $o(^CT.WDT.CDSS.RuleResultI("NodeRecommendIndex",NodeRowId,"检验",ResultRowId),-1) q:ResultRowId=""
						
						s RecommendType  = $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),4)
						s RecommendResult  = $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),5)
						s RecommendResultDesc=""
						s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(RecommendResult)),4)
						
						//continue:RecommendType'="检验"
						
						/*if (RecommendType="检验") 
						{
							s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(RecommendResult)),4)
						}
						elseif(RecommendType="检查")
						{
							s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.ExamDictD(RecommendResult)),4)
						}
						elseif(RecommendType="检验医嘱")
						{
							s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(RecommendResult)),3)
						}*/
						//("规则ID,"_"规则编码,"_"规则名称,"_"流程图顺序号,"_"节点类型,"_"节点内容表ID,"_"类型,"_"名称")
						d file.Write(RuleRowId_",")
						d file.Write(RuleCode_",")
						d file.Write(RuleDesc_",")
						d file.Write(FlowChartNum_",")
						d file.Write(NodeTypeDesc_",")
						d file.Write(ResultRowId_",")
						d file.Write(RecommendType_",")
						d file.Write(RecommendResult_",")
						d file.Write(RecommendResultDesc)
						d file.WriteLine()
					}
				}
			}
	}
	d file.%Save()
	d file.%Close()
	q fileName
}

/// Creator:赵文伟
/// CreatDate:2022-12-15
/// Description：个性化导出需求【导出规则推荐治疗方案下指定规则的“诊断条件--[主要条件-识别词/否定条件-识别词]--推荐治疗方案”】
/// Input：
/// Return:
/// Other:w ##class(web.CDSS.CMKB.RuleDict).ExportTreatData()
ClassMethod ExportTreatData()
{
	s dataStr = "慢性阻塞性肺病^糖尿病^高血压^脑血管病^精神障碍^肺结核^肝炎^肝炎（包含乙肝）^扁桃体恶性肿瘤^胃肠道恶性肿瘤^皮肤恶性肿瘤^胆囊恶性肿瘤"
	//s Path=##class(%File).GetDirectory()
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	
	s Disk=$p(Path,":",1) //截取盘符
	s fileName="规则流程导出数据.csv"
	s P=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\DataExport\"_fileName
	s file=##class(%File).%New(P)
	d file.Open("NWS")
	d file.Write("RuleRowId,"_"规则名称,"_"流程序号,"_"主要条件-诊断,"_"主要条件-识别词/否定条件-识别词,"_"推荐治疗方案类型,"_"推荐治疗方案内容")
	d file.WriteLine()
	
	s len = $l(dataStr,"^")
	for i=1:1:len {
		s RuleDesc = $p(dataStr,"^",i)
		
		if ($d(^CT.WDT.CDSS.RuleDictI("DescIndex"," "_$zconvert(RuleDesc,"U")))) 
		{
			s RuleRowId=$O(^CT.WDT.CDSS.RuleDictI("DescIndex"," "_$zconvert(RuleDesc,"U"),""))
			//s RuleTypeDR=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),6)
			//s RuleType=""
			//s:RuleTypeDR'="" RuleType=$LISTGET($G(^CT.WDT.CDSS.ChartTypeD(RuleTypeDR)),3)
			
			s NodeRowId = ""
			s RuleType= -100000000000000	//【推荐治疗方案】
			for j=1:1:100{
				
				for
				{
					//s NodeRowId = $o(^CT.WDT.CDSS.RuleNodeI("RuleTypeDRIndex",RuleRowId,RuleType,NodeRowId)) q:NodeRowId=""
					s NodeRowId = $o(^CT.WDT.CDSS.RuleNodeI("TypeChartIndex",RuleRowId,RuleType,j,NodeRowId)) q:NodeRowId=""
					s FlowChartNum  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),3)
					s NodeNum  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),4)
					s NodeType  = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),5)
					s NodeTypeDesc=""
					s:NodeType'="" NodeTypeDesc= $lg($g(^CT.WDT.CDSS.NodeTypeD(NodeType)),3)
					continue:(NodeTypeDesc'="主要条件-诊断")&&(NodeTypeDesc'="主要条件-识别词")&&(NodeTypeDesc'="否定条件-识别词")&&(NodeTypeDesc'["推荐治疗方案")
					
					d file.Write(RuleRowId_",")
					d file.Write(RuleDesc_",")  //规则名称
					d file.Write(FlowChartNum_",")
					if (NodeTypeDesc="主要条件-诊断"){
						s ConditionRowId=""
						s ConValueStr=""
						for{
							s ConditionRowId = $o(^CT.WDT.CDSS.RuleConditionI("NodeDRIndex",NodeRowId,ConditionRowId),-1) q:ConditionRowId=""
							
							s ConditionItemValue  = $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowId)),6)
							
							if (ConValueStr=""){
								s ConValueStr=ConditionItemValue
							} else{
								s ConValueStr=ConValueStr_"&"_ConditionItemValue
							}
						}
						d file.Write(ConValueStr_",")
						
					}else{
						d file.Write(""_",")
					}
					
					if (NodeTypeDesc="主要条件-识别词")||(NodeTypeDesc="否定条件-识别词"){
						s ConditionRowId=""
						
						s ConValueStr1=""
						for{
							s ConditionRowId = $o(^CT.WDT.CDSS.RuleConditionI("NodeDRIndex",NodeRowId,ConditionRowId),-1) q:ConditionRowId=""
							
							s ConditionItemValue  = $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowId)),6)
							if (ConValueStr1=""){
								s ConValueStr1=ConditionItemValue
							} else{
								s ConValueStr1=ConValueStr1_"&"_ConditionItemValue
							}
						}
						d file.Write(ConValueStr1_",")
					} else{
						d file.Write(""_",")
					}
					
					if (NodeTypeDesc["推荐治疗方案") {
						if (NodeTypeDesc="推荐治疗方案"){
							s ResultRowId = ""
							s RecommendStr=""
							for
							{
								s ResultRowId = $o(^CT.WDT.CDSS.RuleResultI("NodeDRIndex",NodeRowId,ResultRowId),-1) q:ResultRowId=""
								s Sequence  = $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),3)
								s RecommendType  = $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),4)
								s RecommendResult  = $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),5)
								s RecommendResultDesc=""
								if (RecommendType="治疗方案")
								{
									s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.TreatDictD(RecommendResult)),3)
									
									if (RecommendStr=""){
										s RecommendStr=RecommendResultDesc
									} else{
										s RecommendStr=RecommendStr_"&"_RecommendResultDesc
									}
								}
							}
							d file.Write(NodeTypeDesc_",")
							d file.Write(RecommendStr_",")
								
						} else{
							s DetailRowId = ""
							s DetailValStr=""
							for
							{
								s DetailRowId = $o(^CT.WDT.CDSS.RuleDetailI("NodeLLevelIndex",NodeRowId,-100000000000000,DetailRowId),-1) q:DetailRowId=""
								s NodeType=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),5)
								s NodeTypeDesc=""
								s:NodeType'="" NodeTypeDesc=$lg($g(^CT.WDT.CDSS.NodeTypeD(NodeType)),3)
											
								s DrugDR  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),4)
								s DrugUse  = $lg($g(^CT.WDT.CDSS.RuleDetailD(DetailRowId)),5)
								s DrugDRName="",DrugUseName=""
								
								if (NodeTypeDesc="推荐治疗方案-药品") 
								{
									s DrugDRName=$lg($g(^CT.WDT.CDSS.DrugDictD(DrugDR)),4)
									s:DrugUse'="" DrugUseName=$lg($g(^CT.WDT.CDSS.UsageDictD(DrugUse)),3)
								}
								elseif(NodeTypeDesc="推荐治疗方案-手术") 
								{
									
									s DrugDRName=$lg($g(^CT.WDT.CDSS.OperationDictD(DrugDR)),4)
									s:DrugUse'="" DrugUseName=$lg($g(^CT.WDT.CDSS.UsageDictD(DrugUse)),3)
								}
								elseif(NodeTypeDesc="推荐治疗方案-治法")   //治疗方案-治法-方剂-方剂组成
								{
									
									s DrugDRName=$lg($g(^CT.WDT.CDSS.TCMTreatmentD(DrugDR)),3)
								}
								elseif(NodeTypeDesc="推荐治疗方案-方剂")   //治疗方案-治法-方剂-方剂组成
								{
									s DrugDRName=$lg($g(^CT.WDT.CDSS.TCMPrescriptionD(DrugDR)),3)
								}
								elseif(NodeTypeDesc="推荐治疗方案-处置")   //治疗方案-处置(护理字典)-处置明细
								{
									s DrugDRName=$lg($g(^CT.WDT.CDSS.NursingDictD(DrugDR)),4)  //护理名称
								} 
								continue:DrugDRName=""
								if (DetailValStr=""){
									s DetailValStr=DrugDRName
								} else{
									s DetailValStr=DetailValStr_"&"_DrugDRName
								}
								
							}
							d file.Write(NodeTypeDesc_",")
							d file.Write(DetailValStr_",")
						}	
					} else{
						d file.Write(""_",")
						d file.Write(""_",")
					}
				d file.WriteLine()	
				} 
				
			}
		} 
		/*else{
			d file.Write(data_"不存在")
			d file.WriteLine()
			//w !,data_"不存在"
		}*/
		
	}
	d file.%Save()
	d file.%Close()
	q fileName
}

/// Creator:丁亚男
/// CreatDate:2023-03-08
/// Description:规则不同状态的流程图条数
/// Table:CT.WDT.CDSS.RuleDict
/// Input:
/// Return:总数据量^编辑中的数据量^已审核的数据量(审核通过+已上线)^待审核的数据量
/// Other:w ##class(web.CDSS.CMKB.RuleDict).CountFlowData("疾病预警")
ClassMethod CountFlowData(TypeDesc)
{
	s Totalcount=0,Editcount=0,Reviewedcount=0,Tobereviewedcount=0
	s ChartTypeDR=$o(^CT.WDT.CDSS.ChartTypeI("DescIndex"," "_$ZCONVERT(TypeDesc,"U"),""))
	if (ChartTypeDR'="") 
	{
		if ($d(^CT.WDT.CDSS.RuleDictI("TypeIndex",ChartTypeDR)))
		{
			s RuleRowId=0
			for
			{ 
				s RuleRowId=$o(^CT.WDT.CDSS.RuleDictI("TypeIndex",ChartTypeDR,RuleRowId)) q:RuleRowId=""
				s Flowcount=0
				s NodeRowId=0
				for 
				{
					s NodeRowId=$o(^CT.WDT.CDSS.RuleNodeI("RuleDRIndex",RuleRowId,NodeRowId)) q:NodeRowId="" 
					s NodeType=$LISTGET($G(^CT.WDT.CDSS.RuleNodeD(NodeRowId)),5)
					s NodeTypeDesc=""
					s:NodeType'="" NodeTypeDesc=$LISTGET($G(^CT.WDT.CDSS.NodeTypeD(NodeType)),3)
					if (NodeTypeDesc="结束")
					{
						s Flowcount=Flowcount+1
					}
				}
			
				s RuleStatus=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowId)),8)
				if (RuleStatus="")||(RuleStatus="编辑中")||(RuleStatus="审核不通过")
			 	{
				 	s Totalcount=Totalcount+Flowcount
				 	s Editcount=Editcount+Flowcount	
				}
				elseif (RuleStatus="已上线")||(RuleStatus="审核通过")
				{
					s Totalcount=Totalcount+Flowcount
				 	s Reviewedcount=Reviewedcount+Flowcount		
				}
				elseif (RuleStatus="待审核")
				{
					s Totalcount=Totalcount+Flowcount
				 	s Tobereviewedcount=Tobereviewedcount+Flowcount		
				}
			}
		}
	}
	q Totalcount_"^"_Editcount_"^"_Reviewedcount_"^"_Tobereviewedcount
}

}
