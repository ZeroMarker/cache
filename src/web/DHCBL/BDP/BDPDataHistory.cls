/// Creator:李欣
/// CreatDate:2017-08-23
/// Description:对数据平台操作历史表的操作
/// Table:User.BDPDataFrequency
Class web.DHCBL.BDP.BDPDataHistory Extends %RegisteredObject
{

/// Creator:chenying
/// CreatDate:2018-05-26
/// Description:增加/修改 
/// Table:User.BDPDataHistory、User.BDPDataFrequency
/// Return:成功返回success:'true'和新增或修改的数据的ID;失败返回success:'false'和失败原因
/// Others:w ##class(web.DHCBL.BDP.BDPDataHistory).SaveFH("BDPDAHTableName^BDPDAHDataReference^BDPDAHDesc")
ClassMethod SaveFH(DataStr) As %String
{
	s TableName = $p(DataStr,"^",1)
	if (TableName="User.MKBGlobal")
	{
		s Desc=$p(DataStr,"^",3)
		//s Desc=$p(Desc,"(",2)
		//s Desc =$p(Desc,")",1)
		s DataStr=$p(DataStr,"^",1,2)
		s DataStr=DataStr_"^"_Desc
		s rs1= ##class(web.DHCBL.BDP.BDPDataHistory).SaveData(DataStr)
		s rs2= ##class(web.DHCBL.BDP.BDPDataFrequency).SaveData(DataStr)
	}
	else
	{	
		s rs1= ##class(web.DHCBL.BDP.BDPDataHistory).SaveData(DataStr)
		s rs2= ##class(web.DHCBL.BDP.BDPDataFrequency).SaveData(DataStr)
	}
	if (rs1["success:'true'")&&(rs2["success:'true'") q 1
	else  q 0
}

/// Creator:chenying
/// CreatDate:2018-08-02
/// Description:删除一个表下的所有频次和历史记录
/// Table:User.BDPDataHistory、User.BDPDataFrequency
/// Return:
/// Others:w ##class(web.DHCBL.BDP.BDPDataHistory).DeleteAll("User.ARCItemCat")
ClassMethod DeleteAll(tablename) As %String
{
	if tablename'=""
	{
		s RowId=0
		for
		{
			s RowId=$o(^User.BDPDataHistoryI("TableNameIndex"," "_$zcvt(tablename,"U"),RowId)) q:RowId="" 
			d ##class(User.BDPDataHistory).%DeleteId(RowId)			
		}
		s RowId=0
		for
		{
			s RowId=$o(^User.BDPDataFrequencyI("TableNameIndex"," "_$zcvt(tablename,"U"),RowId)) q:RowId="" 
			d ##class(User.BDPDataFrequency).%DeleteId(RowId)			
		}	
	}
	q ""
}

/// Creator:chenying
/// CreatDate:2018-05-26
/// Description:删除
/// Table:User.BDPDataHistory、User.BDPDataFrequency
/// Return:成功返回success:'true'和新增或修改的数据的ID;失败返回success:'false'和失败原因
/// Others:w ##class(web.DHCBL.BDP.BDPDataHistory).DeleteFH("BDPDAHTableName^BDPDAHDataReference")
ClassMethod DeleteFH(DataStr) As %String
{
	s rs1= ##class(web.DHCBL.BDP.BDPDataHistory).DeleteDataStr(DataStr)
	s rs2= ##class(web.DHCBL.BDP.BDPDataFrequency).DeleteDataStr(DataStr)
	if (rs1["success:'true'")&&(rs2["success:'true'") q 1
	else  q 0
}

/// Creator:李欣
/// CreatDate:2017-08-24
/// Description:增加/修改 
/// Table:User.BDPDataHistory
/// Return:成功返回success:'true'和新增或修改的数据的ID;失败返回success:'false'和失败原因
/// Others:w ##class(web.DHCBL.BDP.BDPDataHistory).SaveData("User.MKBTermProperty14495^MKBTDesc-14495^中心词")
ClassMethod SaveData(SaveDataStr) As %String
{
	s eobj=##class(web.Entity.BDP.BDPDataHistory).%New()
	s eobj.BDPDAHTableName=$P(SaveDataStr,"^",1)  //表名
	s eobj.BDPDAHDataReference= $P(SaveDataStr,"^",2)  //rowid
	s eobj.BDPDAHDesc=$P(SaveDataStr,"^",3)   //中心词
	S rs = ##class(web.DHCBL.BDP.BDPDataHistory).SaveEntity(eobj)
	Q rs
}

/// Creator:李欣
/// CreatDate:2017-08-23
/// Description:增加/修改 
/// Table:User.BDPDataHistory
/// Input:web.Entity.BDP.BDPDataHistory
/// Return:成功返回success:'true'和新增或修改的数据的ID;失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.Entity.BDP.BDPDataHistory) As %String
{
    s $ZT="ERROR"
	s result=""
	if $IsObject(eobj)
	{
		s eobj.BDPDAHUserID=$Get(%session.Data("LOGON.USERID"))
		
		q:(eobj.BDPDAHTableName="")||(eobj.BDPDAHDataReference="")||(eobj.BDPDAHDesc="") "{success:'false',errorinfo:'没有获取到表名和术语ID！'}"
		s uptablename=" "_$ZCONVERT(eobj.BDPDAHTableName,"U")
		s dataReference=" "_$ZCONVERT(eobj.BDPDAHDataReference,"U")
		s BDPDAHUserID = eobj.BDPDAHUserID
		if BDPDAHUserID'=""
		{
			s RowId=$o(^User.BDPDataHistoryI("TableUserRefIdx",uptablename,BDPDAHUserID,dataReference,0))
			s eobj.ID=RowId

			if (eobj.ID="")      
			{
				s obj=##class(User.BDPDataHistory).%New()
				s eobj.BDPDAHDate=$h //新增时，日期为当前
			}
			else                           
			{
				s obj=##class(User.BDPDataHistory).%OpenId(eobj.ID)
				
				s eobj.BDPDAHDate=$h  //修改时，日期更新为当前
				
				s bobj=##class(web.Entity.BDP.BDPDataHistory).%New()
				
				s bobj.ID = eobj.ID
				s bobj.BDPDAHTableName = obj.BDPDAHTableName
				s bobj.BDPDAHDataReference   = obj.BDPDAHDataReference
				s bobj.BDPDAHDesc = obj.BDPDAHDesc
				s bobj.BDPDAHDate = obj.BDPDAHDate
				if $IsObject(obj.BDPDAHUserID){
						s bobj.BDPDAHUserID = obj.BDPDAHUserID.%Id() 
					}
			}
			s obj.BDPDAHTableName = eobj.BDPDAHTableName
			s obj.BDPDAHDataReference   = eobj.BDPDAHDataReference
			s obj.BDPDAHDesc = eobj.BDPDAHDesc
			s obj.BDPDAHDate = eobj.BDPDAHDate
			d obj.BDPDAHUserIDSetObjectId(eobj.BDPDAHUserID)
			s sc=obj.%Save()
			do obj.%Close()
			if $$$ISOK(sc){
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}"
			}else{
				s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"    //返回错误信息
			}
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
ERROR
	s result = "{success:'false',errorinfo:'"_$ze_"'}"
	q result
}

/// Creator:李欣
/// CreatDate:2017-08-24
/// Description:删除
/// Table:User.BDPDataHistory
/// Input:tablename^datareference
/// Output:
/// Return:删除操作的结果
/// Others:w ##class(web.DHCBL.BDP.BDPDataHistory).DeleteDataStr("tablename^datareference")
ClassMethod DeleteDataStr(DeleteDataStr As %String) As %String
{
	s result = ""
	s BDPDAHTableName = $p(DeleteDataStr,"^",1) //表名
	s BDPDAHDataReference= $P(DeleteDataStr,"^",2) //rowid
	s uptablename = " "_$ZCONVERT(BDPDAHTableName,"U")
	s dataReference = " "_BDPDAHDataReference
	s RowId = $o( ^User.BDPDataHistoryI("TableRefIdx",uptablename,dataReference,0))
	s:RowId'="" result = ..DeleteData(RowId)
	q result
}

/// Creator:李欣
/// CreatDate:2017-08-24
/// Description:数据删除
/// Table:User.BDPDataHistory
/// Input:RowId
/// Output:
/// Return:删除操作的结果
/// Others:w ##class(web.DHCBL.BDP.BDPDataHistory).DeleteData(4)
ClassMethod DeleteData(id As %String) As %String
{
	s result = ""
	s rtn = ##class(User.BDPDataHistory).%DeleteId(id)
	if (rtn=1)
	{
		s result = "{success:'true',id:'"_id_"'}"	
	}
	else
	{
		s result = "{success:'false',info:'"_$SYSTEM.Status.GetErrorText(rtn)_"'}"
	}
	Q result
}

/// Description:SaveEntity测试（使用前请注释掉SaveEntity中eobj.BDPDAHUserID的赋值）
/// Others:w ##class(web.DHCBL.BDP.BDPDataHistory).SaveTest()
ClassMethod SaveTest()
{
	s eobj = ##class(web.Entity.BDP.BDPDataHistory).%New()
	s eobj.BDPDAHTableName = "Test_Table"
	s eobj.BDPDAHDataReference = 3
	s eobj.BDPDAHDesc = "Desc"
	s eobj.BDPDAHUserID = "1001"
	q ..SaveEntity(eobj)
}

/// Creator:李欣
/// CreatDate:2017-08-24   extjs 第二版医用知识库用tkb
/// Description:为combobox查询取数据
/// Table:User.BDPDataHistory
/// Input:content:,tablename：表名,desc:输入框内容,combolimit:显示条数
/// w ##class(web.DHCBL.BDP.BDPDataHistory).GetList("Test_Table","",10)
ClassMethod GetList(tablename As %String, desc As %String, combolimit As %String)
{
	s BDPDAHUserID = $Get(%session.Data("LOGON.USERID"))
	s count=0	
	w "{""data"":["
	s CurrentCount=0
	
	if (desc="")
	{
		if (tablename'="")
		{
			s tablename=" "_$ZCONVERT(tablename,"U")
			s BDPDAHDate=""
			for
			{
				s BDPDAHDate=$o(^User.BDPDataHistoryI("TableUserDateIdx",tablename,BDPDAHUserID,BDPDAHDate),-1) q:BDPDAHDate="" 
				s RowId=""
				for
				{
					s RowId=$o(^User.BDPDataHistoryI("TableUserDateIdx",tablename,BDPDAHUserID,BDPDAHDate,RowId),-1) q:RowId="" 
					s Desc=$listget($g(^User.BDPDataHistoryD(RowId)),4)        /// 对应表数据描述 节点 4
					s ID=$listget($g(^User.BDPDataHistoryD(RowId)),3)          /// 对应表数据ID 节点 3  BDPDAFDataReference 
					
					if (CurrentCount=0) 
					{
						s CurrentCount=1
					}
					else
					{
						s CurrentCount=CurrentCount+1
						w ","
					}
					w "{""RowId"":"""_RowId_""",""ID"":"""_ID_""",""Desc"":"""_Desc_"""}" 
					s count=count+1
					q:count=combolimit
				}
				q:count=combolimit			
			}	
			
		}
		w "],""total"":"""_count_""",""success"":""true""}"
		q ""
	}
	else
	{
		s start=1
		if (tablename'="")
		{
			s:desc'="" desc=$ZCONVERT(desc,"U")
			s tablename=" "_$ZCONVERT(tablename,"U")
			
			s BDPDAFFrequency=""
			for
			{
				s BDPDAFFrequency=$o(^User.BDPDataFrequencyI("TableFreqIdx",tablename,BDPDAFFrequency),-1) q:BDPDAFFrequency="" 
				s RowId=""
				for
				{
					s RowId=$o(^User.BDPDataFrequencyI("TableFreqIdx",tablename,BDPDAFFrequency,RowId),-1) q:RowId="" 
					s Desc=$listget($g(^User.BDPDataFrequencyD(RowId)),4)        /// 对应表数据描述 节点 4
					s ID=$listget($g(^User.BDPDataFrequencyD(RowId)),3)          /// 对应表数据ID 节点 3  BDPDAFDataReference 
					s UserID=$listget($g(^User.BDPDataFrequencyD(RowId)),6)  
					continue:UserID'=BDPDAHUserID
					s PINYIN=""
					s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(Desc)
					s (Alias,AliasPY,Com,ComPY,AliasFlag,ComFlag)=""
					if (tablename["USER.TKBTREM")&&(tablename'["EXTEND")
					{
						if ($d(^TKBTRECOMi(0,"Tre","A",ID))'=0)
						{
							s AliasID=$o(^TKBTRECOMi(0,"Tre","A",ID,""))
							s Alias=$p($g(^TKBTRECOM(AliasID)),"^",3)
							s AliasPY=##class(web.DHCBL.BDP.FunLib).GetPYCODE(Alias)
							if ($ZCONVERT(Alias,"U")[desc)||(AliasPY[desc)
							{
								s AliasFlag="Y"
							}
						}
						if ($d(^TKBTRECOMi(0,"Tre","C",ID))'=0)
						{
							s ComID=$o(^TKBTRECOMi(0,"Tre","C",ID,""))
							s Com=$p($g(^TKBTRECOM(ComID)),"^",3)
							s ComPY=##class(web.DHCBL.BDP.FunLib).GetPYCODE(Com)
							if ($ZCONVERT(Com,"U")[desc)||(ComPY[desc)
							{
								s ComFlag="Y"
							}
						}	
					}
			
					i (($ZCONVERT(Desc,"U")	[desc)||(PINYIN[desc))||(AliasFlag="Y")||(ComFlag="Y")
					{
						s count=count+1
						if (count<start) continue
						if ((count<(start+combolimit)))
						{
							
							if (CurrentCount=0) 
							{
								s CurrentCount=1
							}
							else
							{
								s CurrentCount=CurrentCount+1
								w ","
							}
							w "{""RowId"":"""_RowId_""",""ID"":"""_ID_""",""Desc"":"""_Desc_"""}" 
						
						}
						q:((count>=(start+combolimit)))
					}
				}
			
			}	
			
		}
			
	}
	w "],""total"":"""_count_""",""success"":""true""}"
	q ""
}

/// Creator：陈莹
/// CreatDate: 2018-05-16
/// Description：为combobox 下拉检索框查询取数据  hisui 第三版医用知识库用mkb
/// Table：User.BDPDataHistory,User.BDPDataFrequency
/// Input：tablename,q
/// Return：ID,Desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPDataHistory","GetDataForCmb1","User.MKBTerm5","血管")
Query GetDataForCmb1(tablename As %String, q As %String) As %Query(ROWSPEC = "ID:%String,Desc:%String,BDPDAFFrequency:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, tablename As %String, q As %String) As %Status
{
	s repid=$I(^CacheTemp)	
	s ind=1
	K Output
	s q=$P(q,"(",1) //"中心词(别名)"检索时，截取中心词部分
	if (tablename'="")&&(tablename'="undefined")  //&&(tablename'="User.MKBGlobal")
	{
		
		s BDPDAHUserID ="1"
		if $d(%session) s BDPDAHUserID =$Get(%session.Data("LOGON.USERID"))
		s desc=$ZCONVERT(q,"U")
		if (desc="")   //不输入条件显示最近的历史记录
		{
			s combolimit=10,count=0	
			s BDPDAHDate=""
			for
			{
				s BDPDAHDate=$o(^User.BDPDataHistoryI("TableUserDateIdx"," "_$ZCONVERT(tablename,"U"),BDPDAHUserID,BDPDAHDate),-1) q:BDPDAHDate="" 
				s RowId=""
				for
				{
					s RowId=$o(^User.BDPDataHistoryI("TableUserDateIdx"," "_$ZCONVERT(tablename,"U"),BDPDAHUserID,BDPDAHDate,RowId),-1) q:RowId="" 
					s Desc=$listget($g(^User.BDPDataHistoryD(RowId)),4)        /// 对应表数据描述 节点 4
					s ID=$listget($g(^User.BDPDataHistoryD(RowId)),3)          /// 对应表数据ID 节点 3  BDPDAFDataReference 
					s BDPDAFFrequency=$listget($g(^User.BDPDataFrequencyD(RowId)),5)
					s count=count+1
					q:count>combolimit
					if $d(Output(ID))=0
					{
						s Output(ID)=Desc
						d OutputRowCmb
					}
				}
						
			}
		}
		else  ///描述不为空时，取频次表
		{
			k LocArryay,FreqArryay,UniqueArray
			s arraycount=0
			s BDPCTLocDRID =""
			if $d(%session) s BDPCTLocDRID =$Get(%session.Data("LOGON.CTLOCID"))
			s currentLocCount=0
			s combolimit=10
			s BDPDAFFrequency=""
			for
			{
				s BDPDAFFrequency=$o(^User.BDPDataFrequencyI("TableFreqIdx"," "_$ZCONVERT(tablename,"U"),BDPDAFFrequency),-1) q:BDPDAFFrequency=""
				b ;22
				s RowId=""
				for
				{
					s RowId=$o(^User.BDPDataFrequencyI("TableFreqIdx"," "_$ZCONVERT(tablename,"U"),BDPDAFFrequency,RowId),-1) q:RowId="" 
					s Desc=$listget($g(^User.BDPDataFrequencyD(RowId)),4)        /// 对应表数据描述 节点 4
					s ID=$listget($g(^User.BDPDataFrequencyD(RowId)),3)          /// 对应表数据ID 节点 3  BDPDAFDataReference 	
					q:(currentLocCount>(combolimit+1))
					s PINYIN=""
					s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(Desc)
					i ((($ZCONVERT(Desc,"U")[desc)||(PINYIN[desc)))
					{
						s arraycount=arraycount+1
						s LocDR=$listget($g(^User.BDPDataFrequencyD(RowId)),8)  
						if LocDR=BDPCTLocDRID //本科室的频次
						{
							s LocArryay(arraycount)=ID_"^"_Desc_"^"_BDPDAFFrequency
							s currentLocCount=currentLocCount+1
							s UniqueArray(ID)=Desc
							if (currentLocCount=(combolimit+1))  //如果超过十条，显示... 2020-05-29
							{
								s ID="..."
								s Desc="..."
								if $d(Output(ID))=0
								{
									s Output(ID)=Desc
									d OutputRowCmb	
								}
							}
							q:(currentLocCount>(combolimit))
							if $d(Output(ID))=0
							{
								s Output(ID)=Desc
								d OutputRowCmb
							}
						}
						else ///其他科室的频次
						{
							s FreqArryay(arraycount)=ID_"^"_Desc_"^"_BDPDAFFrequency
						}
						
					}
					else
					{
						s Aliasstr=""
						if ($e(tablename,1,12)="User.MKBTerm")&&(($l(tablename)>12)&&($e(tablename,13,$l(tablename))?1n.n))  //中心词 支持常用名别名检索。2018-06-13
						{
							  //只考虑User.MKBTerm+baseid，不考虑字表
							s Aliasstr=##class(web.DHCBL.MKB.MKBTermProperty).GetComAndAlias(ID)
						}
						elseif (tablename="User.MKBGlobal")  //全局化词表 支持展示名+查询名检索 2020-05-29 chenying  
						{
							s Aliasstr=##class(web.DHCBL.MKB.MKBGlobal).GetDisplayNameAndQueryName(ID)	
							
						}
						if Aliasstr'=""
						{
							s MatchDesc=""
							s AliasLength=$L(Aliasstr,"^")
							for counti=1:1:AliasLength
							{
								s Aliasi=$p(Aliasstr,"^",counti)
								s AliasDesc=$P(Aliasi,"$",1)
								s AliasPY=$P(Aliasi,"$",2)
								
								if ($ZCONVERT(AliasDesc,"U")[desc)||($ZCONVERT(AliasPY,"U")[desc)
								{
									s MatchDesc=AliasDesc	
									q
								}
								
							}
							
							if (MatchDesc'="")  //查询名或者展示名符合条件
							{
								s arraycount=arraycount+1
								s LocDR=$listget($g(^User.BDPDataFrequencyD(RowId)),8)  
								if LocDR=BDPCTLocDRID // 本科室的频次
								{
									s Desc=Desc_"("_MatchDesc_")"  //别名或者展示名符合条件时，展示数据拼接该名称
									s LocArryay(arraycount)=ID_"^"_Desc_"^"_BDPDAFFrequency
									s currentLocCount=currentLocCount+1
									s UniqueArray(ID)=Desc
									
									if (currentLocCount=(combolimit+1))  //如果超过十条，显示... 2020-05-29
									{
										s ID="..."
										s Desc="..."
										if $d(Output(ID))=0
										{
											s Output(ID)=Desc
											d OutputRowCmb
										}
									}
									q:(currentLocCount>(combolimit))
									if $d(Output(ID))=0
									{
										s Output(ID)=Desc
										d OutputRowCmb
									}
									
								}
								else   //其他科室的频次
								{
									s FreqArryay(arraycount)=ID_"^"_Desc_"("_MatchDesc_")"_"^"_BDPDAFFrequency
								}
								
							}
						}
					}
					
				}
			}
			
			
			if (currentLocCount<combolimit)  //如果本科室频次不够10条,取其他科室的频次高的数据
			{
				s arraycount=0
				for
				{
					s arraycount=$o(FreqArryay(arraycount)) q:arraycount=""
					s ID=$p($g(FreqArryay(arraycount)),"^",1)
					continue:$d(UniqueArray(ID))>0
					s Desc=$p($g(FreqArryay(arraycount)),"^",2)
					s BDPDAFFrequency=$p($g(LocArryay(arraycount)),"^",3)
					//s BDPDAFFrequency="F"_$p($g(FreqArryay(arraycount)),"^",3)
					s currentLocCount=currentLocCount+1
					q:(currentLocCount>combolimit)
					if $d(Output(ID))=0
					{
						s Output(ID)=Desc
						d OutputRowCmb
					}	
				}	
			}	
		}
	}
	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(ID,Desc,BDPDAFFrequency)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
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

/// Creator:谷雪萍
/// CreatDate:2019-03-25
/// Description:删除重复数据，表名+用户+诊断应该是唯一才对，现在有出现了两个的数据，因为重新生成索引时，还进行了保存操作
/// Table:User.BDPDataHistory
/// Input:
/// Return:1
/// Other:w ##class(web.DHCBL.BDP.BDPDataHistory).DeleteRepeatData()
ClassMethod DeleteRepeatData() As %String
{
	s ID=0
	for
	{
		s ID=$o(^User.BDPDataHistoryD(ID)) q:(ID="")
		s BDPDAHTableName=$listget($g(^User.BDPDataHistoryD(ID)),2)  //表名
		s BDPDAHDataReference=$listget($g(^User.BDPDataHistoryD(ID)),3)  //数据id
		s BDPDAHDesc=$listget($g(^User.BDPDataHistoryD(ID)),4)        /// 对应表数据描述 节点 4
		s BDPDAHUserID=$listget($g(^User.BDPDataHistoryD(ID)),6)   //用户
		continue:(BDPDAHTableName="")||(BDPDAHDataReference="")||(BDPDAHUserID="")
		s uptablename=" "_$ZCONVERT(BDPDAHTableName,"U")
		s dataReference=" "_$ZCONVERT(BDPDAHDataReference,"U")

		s count=0
		s RowId=0
		for
		{
			s RowId=$o(^User.BDPDataHistoryI("TableUserRefIdx",uptablename,BDPDAHUserID,dataReference,RowId)) q:RowId="" 
			s count=count+1
			continue:count=1
			s sc=##class(User.BDPDataHistory).%DeleteId(RowId)
			if $$$ISOK(sc){
				s result="{success:'true',info:'删除成功！'}"
			}
			else{
				s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
				
			}
		}
	}

	q 1
}

}
