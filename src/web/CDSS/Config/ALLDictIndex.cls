/// Creator:Xuwenhu
/// Description:全文检索方法类
/// CreatDate:2022-03-18
Class web.CDSS.Config.ALLDictIndex Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:Xuwenhu
/// CreatDate:2022-03-18
/// Description：生成索引-过滤特殊字符
/// Input:str-字符串
/// Return:str-过滤后的字符串
/// w ##class(web.CDSS.Config.ALLDictIndex).Filter("血、尿、便常规")
ClassMethod Filter(str As %String) As %String
{
	n (str)
	s str = ##class(web.BDP.util.String).Replace(str,"<br/>","")
	s str = ##class(web.BDP.util.String).Replace(str,"[A]","")
	s str = ##class(web.BDP.util.String).Replace(str,"[N]","")
	s str = ##class(web.BDP.util.String).Replace(str,$c(13),"")
	s str = ##class(web.BDP.util.String).Replace(str,$c(10),"")
	s str = ##class(web.BDP.util.String).Replace(str,$c(0),"")
	s str = ##class(web.BDP.util.String).Replace(str,"\","")
	s str = ##class(web.BDP.util.String).Replace(str,$c(10,10,10),"")
	for i=0:1:47
	{
		continue:i=10
		s:str[$c(i) str = ##class(web.BDP.util.String).Replace(str,$c(i),"")
	}

	for i=158:1:170
	{
		s:str[$c(i) str = ##class(web.BDP.util.String).Replace(str,$c(i),"")
	}
	s:str[" " str=$Translate(str," ","")
	s:str["`" str=$Translate(str,"`","")
	s:str["~" str=$Translate(str,"~","")
	s:str["!" str=$Translate(str,"!","")
	s:str["@" str=$Translate(str,"@","")
	s:str["#" str=$Translate(str,"#","")
	s:str["$" str=$Translate(str,"$","")
	s:str["%" str=$Translate(str,"%","")
	s:str["^" str=$Translate(str,"^","")
	s:str["&" str=$Translate(str,"&","")
	s:str["*" str=$Translate(str,"*","")
	s:str["(" str=$Translate(str,"(","")
	s:str[")" str=$Translate(str,")","")
	s:str["-" str=$Translate(str,"-","")
	s:str["_" str=$Translate(str,"_","")
	s:str["=" str=$Translate(str,"=","")
	s:str["+" str=$Translate(str,"+","")
	s:str["[" str=$Translate(str,"[","")
	s:str["{" str=$Translate(str,"{","")
	s:str["]" str=$Translate(str,"]","")
	s:str["}" str=$Translate(str,"}","")
	s:str["\" str=$Translate(str,"\","")
	s:str["|" str=$Translate(str,"|","")
	s:str[";" str=$Translate(str,";","")
	s:str[":" str=$Translate(str,":","")
	s:str["'" str=$Translate(str,"'","")
	s:str["“" str=$Translate(str,"“","")
	s:str["‘" str=$Translate(str,"‘","")
	s:str["’" str=$Translate(str,"’","")
	s:str["”" str=$Translate(str,"”","")
	s:str["," str=$Translate(str,",","")
	s:str["<" str=$Translate(str,"<","")
	s:str["." str=$Translate(str,".","")
	s:str[">" str=$Translate(str,">","")
	s:str["/" str=$Translate(str,"/","")
	s:str["?" str=$Translate(str,"?","")
	s:str["""" str=$Translate(str,"""","")
	s:str["·" str=$Translate(str,"·","")
	s:str["！" str=$Translate(str,"！","")
	s:str["￥" str=$Translate(str,"￥","")
	s:str["……" str=$Translate(str,"……","")
	s:str["（" str=$Translate(str,"（","")
	s:str["）" str=$Translate(str,"）","")
	s:str["—" str=$Translate(str,"—","")
	s:str["【" str=$Translate(str,"【","")
	s:str["】" str=$Translate(str,"】","")
	s:str["『" str=$Translate(str,"『","")
	s:str["』" str=$Translate(str,"』","")
	s:str["、" str=$Translate(str,"、","")
	s:str["；" str=$Translate(str,"；","")
	s:str["：" str=$Translate(str,"：","")
	s:str["，" str=$Translate(str,"，","")
	s:str["。" str=$Translate(str,"。","")
	s:str["《" str=$Translate(str,"《","")
	s:str["》" str=$Translate(str,"》","")
	s:str["？" str=$Translate(str,"？","")
	s:str["～" str=$Translate(str,"～","")

	Q str
}

/// Creator:Xuwenhu
/// CreatDate:2022-03-18
/// Description:生成索引-过滤特殊字符
/// Input:str-字符串
/// Return:str-过滤后的字符串
/// w ##class(web.CDSS.Config.ALLDictIndex).Combo("123456789abc")
ClassMethod Combo(str As %String) As %String
{
	n (str)
	s str = ..Filter(str)
	s len = $l(str)
	for i=1:1:len
	{
		s char(i) = $e(str,i)
		s arr(i) = char(i)	
	}
	s count = len + 1
	if (len>=10)
	{
		for l=1:1:len
		{
			if (l+9>=len)
			{
				s tlen = len 	
			}
			else
			{
				s tlen = l+9	
			}
			for m=l+1:1:tlen
			{
				s temp = ""
				for n=l:1:m
				{
					s temp = temp_char(n)
				}
				s arr(count) = temp
				s count = count + 1
			}	
		}		
	}
	else
	{
		for l=1:1:len
		{
			for m=l+1:1:len
			{
				s temp = ""
				for n=l:1:m
				{
					s temp = temp_char(n)
				}
				s arr(count) = temp
				s count = count + 1
			}	
		}		
	}
	s result = ""
	for p=1:1:count-1
	{
		if (p=1)
		{
			s result = arr(p)	
		}
		else
		{
			s result = result_"^"_arr(p)	
		}	
	}
	q result
}

/// Creator:Xuwenhu
/// CreatDate:2022-03-21
/// Description：生成索引数据并保存到索引表
/// Input:str-检索信息,dataid-数据所在表id,tableDesc-数据所在表名,dataSta-数据状态
/// return:1
/// w ##class(web.CDSS.Config.ALLDictIndex).SaveStrIdx("12345","1")
ClassMethod SaveStrIdx(str As %String, dataId As %String, tableDesc As %String, dataSta As %String, fieldNum As %String)
{
	n (str,dataId,tableDesc,dataSta,fieldNum)
	q:((str="")||(dataId="")) 0
	s str = ..Filter(str)
	s len = $l(str)
	for i=1:1:len
	{
		s char(i) = $e(str,i)
		s arr(i) = char(i)	
	}
	s count = len + 1
	if (len>=10)
	{
		for l=1:1:len
		{
			if (l+9>=len)
			{
				s tlen = len 	
			}
			else
			{
				s tlen = l+9	
			}
			for m=l+1:1:tlen
			{
				s temp = ""
				for n=l:1:m
				{
					s temp = temp_char(n)
				}
				s arr(count) = temp
				s count = count + 1
			}	
		}		
	}
	else
	{
		for l=1:1:len
		{
			for m=l+1:1:len
			{
				s temp = ""
				for n=l:1:m
				{
					s temp = temp_char(n)
				}
				s arr(count) = temp
				s count = count + 1
			}	
		}		
	}
	
	for p=1:1:count-1
	{   
	    s desc=arr(p)	
	    //s upDesc=" "_$ZCONVERT(desc,"U") //转换成大写  
	    if ($d(^CF.WDT.CDSS.ALLDictIndexI("DescIndex",desc,tableDesc,dataId))=0)
		{
			s obj=##class(CF.WDT.CDSS.ALLDictIndex).%New()
			s obj.CDSSDictDesc=tableDesc
			s obj.CDSSDictDR=dataId
			s obj.CDSSDesc=desc
			s obj.CDSSDataState=dataSta
			s obj.CDSSFieldNum=fieldNum
			s sc=obj.%Save()
			d obj.%Close()	
		}
	}
	q 1
}

/// Creator:Xuwenhu
/// CreatDate:2022-03-21
/// Description：删除索引
/// Input:str-要删除的检索信息,dataId-数据所在表id,tableDesc-数据所在表名
/// return:1
/// w ##class(web.CDSS.Config.ALLDictIndex).DeleteStrIdx("基础字典库","1","医学组数据统计配置表")
ClassMethod DeleteStrIdx(str As %String, dataId As %String, tableDesc As %String) As %String
{
	n (str,dataId,tableDesc)
	q:((str="")||(dataId="")) 0
	s str = ..Filter(str)
	s len = $l(str)
	for i=1:1:len
	{
		s char(i) = $e(str,i)
		s arr(i) = char(i)	
	}
	s count = len + 1
	if (len>=10)
	{
		for l=1:1:len
		{
			if (l+9>=len)
			{
				s tlen = len 	
			}
			else
			{
				s tlen = l+9	
			}
			for m=l+1:1:tlen
			{
				s temp = ""
				for n=l:1:m
				{
					s temp = temp_char(n)
				}
				s arr(count) = temp
				s count = count + 1
			}	
		}		
	}
	else
	{
		for l=1:1:len
		{
			for m=l+1:1:len
			{
				s temp = ""
				for n=l:1:m
				{
					s temp = temp_char(n)
				}
				s arr(count) = temp
				s count = count + 1
			}	
		}		
	}

	for p=1:1:count-1
	{     
	    s desc=arr(p)	
	    //s upDesc=" "_$ZCONVERT(desc,"U") //转换成大写  
	    if $d(^CF.WDT.CDSS.ALLDictIndexI("DescIndex",desc,tableDesc))  //如果有这个描述了
		{
			s id=$o(^CF.WDT.CDSS.ALLDictIndexI("DescIndex",desc,tableDesc,dataId,0))		
			d ##class(CF.WDT.CDSS.ALLDictIndex).%DeleteId(id)
		}
	}

	q 1
}

/// Creator:Xuwenhu
/// CreatDate:2022-03-21
/// Description：修改索引数据并保存到索引表
/// Input:oldData-原信息,newData-检索信息
/// return:1
/// w ##class(web.CDSS.Config.ALLDictIndex).UpdateStrIdx("A00B99","acssj","1")
ClassMethod UpdateStrIdx(oldData As %String, newData As %String, dataId As %String, tableDesc As %String, dataSta As %String, fieldNum As %String) As %String
{
	n (oldData,newData,dataId,tableDesc,dataSta,fieldNum)
	s result1=..DeleteStrIdx(oldData,dataId,tableDesc)
	s result2=..SaveStrIdx(newData,dataId,tableDesc,dataSta,fieldNum)
	q result1_"^"_result2
}

/// Creator:Xuwenhu
/// CreatDate:2022-03-21
/// Description：遍历配置表生成索引
/// Input:flag-为空时属性内容不生成全文索引，为1时属性内容生成全文索引，默认为空
/// Return:
/// w ##class(web.CDSS.Config.ALLDictIndex).SaveTermIdx()
ClassMethod SaveTermIdx() As %String
{
	k ^CF.WDT.CDSS.ALLDictIndexD
	k ^CF.WDT.CDSS.ALLDictIndexI

	w $ZDT($h,3),!
	
	s ConfigId=0
	for
	{
		s ConfigId=$o(^CF.WDT.CDSS.ALLDictSearchSetD(ConfigId))
		q:ConfigId=""
		
		s TableDictDesc=$lg($g(^CF.WDT.CDSS.ALLDictSearchSetD(ConfigId)),2)		//中文表名（与菜单名称保持一致）
		s TableName=$lg($g(^CF.WDT.CDSS.ALLDictSearchSetD(ConfigId)),3)			//数据表名称
		s TableFieldName=$lg($g(^CF.WDT.CDSS.ALLDictSearchSetD(ConfigId)),4)		//数据表字段名称
		s TableFieldNum=$lg($g(^CF.WDT.CDSS.ALLDictSearchSetD(ConfigId)),5)		//数据表字段顺序号
		s TableFieldDesc=$lg($g(^CF.WDT.CDSS.ALLDictSearchSetD(ConfigId)),6)		//数据表字段描述
		s MenuUrl=$lg($g(^CF.WDT.CDSS.ALLDictSearchSetD(ConfigId)),7)			//菜单url
		s Remarks=$lg($g(^CF.WDT.CDSS.ALLDictSearchSetD(ConfigId)),8)			//备注
		s DataStateNum=$lg($g(^CF.WDT.CDSS.ALLDictSearchSetD(ConfigId)),9)		//状态顺序号
		//百科单独处理，别名+中心词生成索引
		if TableName="CT.WDT.CDSS.Term"
		{
			s TermBaseDR=$o(^CT.WDT.CDSS.TermBaseI("DescIndex"," "_TableDictDesc,0))
			continue:TermBaseDR=""
			s MKBTRowId=0
			for  
			{	
				s MKBTRowId=$o(^CT.WDT.CDSS.TermI("BaseIndex",TermBaseDR,MKBTRowId)) 
				q:MKBTRowId="" 
				
				x "s DataDesc=$lg($g(^"_TableName_"D("_MKBTRowId_")),"_TableFieldNum_")"		//中心词
				x "s DataState=$lg($g(^"_TableName_"D("_MKBTRowId_")),"_DataStateNum_")"
				d ..SaveStrIdx(DataDesc,MKBTRowId,TableDictDesc,DataState,TableFieldNum)	
				s TermAliasID=$o(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," 别名",0))
				continue:TermAliasID=""
				s MKBTPDRowId=0
				for
				{
					s MKBTPDRowId=$o(^CT.WDT.CDSS.TermProDetailI("ProIdx",TermAliasID,MKBTPDRowId))
					q:MKBTPDRowId=""
					s AliasName=$lg($g(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),3)		//别名
					d ..SaveStrIdx(AliasName,MKBTRowId,TableDictDesc,DataState,TableFieldNum)
				}
			}
		}
		else
		{
			s DataId=0
			for
			{
				x "s DataId=$o(^"_TableName_"D("_DataId_"))"
				q:DataId=""
				//w "s DataDesc=$lg($g(^"_TableName_"D("_DataId_")),"_TableFieldNum_")"
				x "s DataDesc=$lg($g(^"_TableName_"D("_DataId_")),"_TableFieldNum_")"
				x "s DataState=$lg($g(^"_TableName_"D("_DataId_")),"_DataStateNum_")"
				d ..SaveStrIdx(DataDesc,DataId,TableDictDesc,DataState,TableFieldNum)	
			}
		}
	}
	w $ZDT($h,3),!
	q 1
}

/// Creator:Xuwenhu
/// CreatDate:2022-03-22
/// Description：Kill索引数据
/// Input：
/// Return:1
/// d ##class(web.CDSS.Config.ALLDictIndex).KillIndexGlobal()
ClassMethod KillIndexGlobal()
{
	k ^CF.WDT.CDSS.ALLDictIndexD
	k ^CF.WDT.CDSS.ALLDictIndexI
	
	q 1
}

/// Creator:Xuwenhu
/// CreatDate:2022-03-22
/// Description：导出索引数据
/// Input：
/// Return:1
/// d ##class(web.CDSS.Config.ALLDictIndex).ExportIndexGlobal()
ClassMethod ExportIndexGlobal()
{
	k CList
	k myIdx	
	
	s CList($i(CList))= "CF.WDT.CDSS.ALLDictIndexD.GBL"  
	s CList($i(CList))= "CF.WDT.CDSS.ALLDictIndexI.GBL"  
    
	s items = ""
	f {
		s myIdx = $i(myIdx)
		q:(myIdx>$g(CList))
		s:((items'="")&&(CList(myIdx)'="")) items= items_","

		s items = items_CList(myIdx)
	}
	d $SYSTEM.OBJ.Export(items, "D:\ALLDictIndex.gof", "", .log)
}

/// Creator:Xuwenhu
/// CreatDate:2022-03-23
/// Input:desc-描述，type-类型（百科/字典）默认全部
/// Description：查询数据
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.Config.ALLDictIndex","GetIndexList","子宫出血","")
Query GetIndexList(desc As %String, type As %String) As %Query(ROWSPEC = "DictDesc,CDSSDictDR,CDSSDictDesc,TableFieldName,TableFieldDesc,MenuUrl,CDSSDataState")
{
}

ClassMethod GetIndexListExecute(ByRef qHandle As %Binary, desc As %String, type As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	if desc'=""
 	{
	 	s CDSSDictDesc=""			//中文表名
	 	for
 		{
	 		s CDSSDictDesc=$o(^CF.WDT.CDSS.ALLDictIndexI("DescIndex",desc,CDSSDictDesc))
	 		q:CDSSDictDesc=""
	 		
	 		if type="百科"
	 		{
		 		continue:((CDSSDictDesc'="疾病")&(CDSSDictDesc'="检查")&(CDSSDictDesc'="检验")&(CDSSDictDesc'="手术")&(CDSSDictDesc'="护理"))		
		 	}
	 		s CDSSDictDR=""			//数据所在表ID
	 		for
	 		{
		 		s CDSSDictDR=$o(^CF.WDT.CDSS.ALLDictIndexI("DescIndex",desc,CDSSDictDesc,CDSSDictDR))
		 		q:CDSSDictDR=""
		 		
		 		s CDSSFieldNum=0
		 		for
		 		{
			 		s CDSSFieldNum=$o(^CF.WDT.CDSS.ALLDictIndexI("DescIndex",desc,CDSSDictDesc,CDSSDictDR,CDSSFieldNum))
			 		q:CDSSFieldNum=""
			 		
			 		s DictDesc=..GetFieldValue(CDSSDictDesc,CDSSDictDR,CDSSFieldNum)							//取完整描述
			 		
			 		s SerID=$o(^CF.WDT.CDSS.ALLDictSearchSetI("FieldNumIndex",CDSSDictDesc,CDSSFieldNum,0))	
			 		s (TableFieldName,TableFieldDesc,MenuUrl)=""
			 		s:SerID'="" TableFieldName=$lg($g(^CF.WDT.CDSS.ALLDictSearchSetD(SerID)),4)							//字段名称
			 		s:SerID'="" TableFieldDesc=$lg($g(^CF.WDT.CDSS.ALLDictSearchSetD(SerID)),6)							//字段描述
			 		s:SerID'="" MenuUrl=$lg($g(^CF.WDT.CDSS.ALLDictSearchSetD(SerID)),7)								//菜单url
			 		
				 	s ID=$o(^CF.WDT.CDSS.ALLDictIndexI("DescIndex",desc,CDSSDictDesc,CDSSDictDR,CDSSFieldNum,0))
				 	s CDSSDataState=$lg($g(^CF.WDT.CDSS.ALLDictIndexD(ID)),5)		//数据状态
				 	s CDSSDataState=$case(CDSSDataState,0:"编辑中",1:"已弃用",2:"已审核","":"编辑中",:"已审核")	
				 	d OutputRow	
		 		}
		 	}
	 	}
		 	
	}
 	
    
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(DictDesc,CDSSDictDR,CDSSDictDesc,TableFieldName,TableFieldDesc,MenuUrl,CDSSDataState)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetIndexListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetIndexListExecute ]
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

/// Creator:Xuwenhu
/// CreatDate:2022-03-23
/// Description：根据索引返回完整字段值
/// other: w ##class(web.CDSS.Config.ALLDictIndex).GetFieldValue("疾病字典","1","3") 
ClassMethod GetFieldValue(tableDesc As %String, dictId As %String, fieldNum As %String) As %String
{
	n (tableDesc,dictId,fieldNum)
	s DictDescStr=""
	s SerId=$o(^CF.WDT.CDSS.ALLDictSearchSetI("FieldNumIndex",tableDesc,fieldNum,0))
	s:SerId'="" TableName=$lg($g(^CF.WDT.CDSS.ALLDictSearchSetD(SerId)),3)			//数据表名称
	/*s FieldNum=0
	for
	{
		s FieldNum=$o(^CF.WDT.CDSS.ALLDictSearchSetI("FieldNumIndex",tableDesc,TableName,FieldNum))
		q:FieldNum=""
		
		x "s DictDesc=$lg($g(^"_TableName_"D("_dictId_")),"_FieldNum_")"
		if DictDescStr=""
		{
			s DictDescStr=DictDesc	
		}
		else
		{
			s DictDescStr=DictDescStr_","_DictDesc	
		}
	}*/
	x "s DictDesc=$lg($g(^"_TableName_"D("_dictId_")),"_fieldNum_")"
	q DictDesc
}

/// Creator:Xuwenhu
/// CreatDate:2022-03-28
/// Description：定时更新全文索引
/// other: w ##class(web.CDSS.Config.ALLDictIndex).UpdateIndex() 
ClassMethod UpdateIndex() As %String
{
	s LogId=0
	for
	{
		s LogId=$o(^CF.WDT.CDSS.DataChangeLogI("UpdateDateIndex",+$h,LogId))
		q:LogId=""
		
		s TableName = $lg($g(^CF.WDT.CDSS.DataChangeLogD(LogId)),2)			//表名
		s ClassName = $lg($g(^CF.WDT.CDSS.DataChangeLogD(LogId)),3)			//类名
		s ObjectReference = $lg($g(^CF.WDT.CDSS.DataChangeLogD(LogId)),4)	//ID
		s OperateType = $lg($g(^CF.WDT.CDSS.DataChangeLogD(LogId)),10)		//操作类型
		s NewValue = $lg($g(^CF.WDT.CDSS.DataChangeLogD(LogId)),11)			//新值
		s ClassNameDesc = $lg($g(^CF.WDT.CDSS.DataChangeLogD(LogId)),12)	//表名称描述
		s ObjectDesc = $lg($g(^CF.WDT.CDSS.DataChangeLogD(LogId)),13)		//操作数据的描述
		s OldValue = $lg($g(^CF.WDT.CDSS.DataChangeLogD(LogId)),15)			//旧值
		
		if $d(^CF.WDT.CDSS.ALLDictSearchSetI("FieldNameIndex",ClassNameDesc))		//如果操作的表在全文索引配置表里
		{
			s NewDataJson=[].%FromJSON(NewValue)
			s TableFieldName=""
			for
			{
				s TableFieldName=$o(^CF.WDT.CDSS.ALLDictSearchSetI("FieldNameIndex",ClassNameDesc,TableFieldName))
				q:TableFieldName=""
				
				if OperateType="A"		//新增值
				{
					s ConfigId=$o(^CF.WDT.CDSS.ALLDictSearchSetI("FieldNameIndex",ClassNameDesc,TableFieldName,0))
					s TableName=$lg($g(^CF.WDT.CDSS.ALLDictSearchSetD(ConfigId)),3)
					s FieldNum=$lg($g(^CF.WDT.CDSS.ALLDictSearchSetD(ConfigId)),5)
					s DataStateNum=$lg($g(^CF.WDT.CDSS.ALLDictSearchSetD(ConfigId)),9)
					x "s DataState=$lg($g(^"_TableName_"D("_ObjectReference_")),"_DataStateNum_")"
					if NewDataJson.%Get(TableFieldName)'=""
					{
						d ..SaveStrIdx(NewDataJson.%Get(TableFieldName),ObjectReference,ClassNameDesc,DataState,FieldNum)	
					}			
				}	
				elseif OperateType="U"		//修改值
				{
					s OldDataJson=[].%FromJSON(OldValue)
					s ConfigId=$o(^CF.WDT.CDSS.ALLDictSearchSetI("FieldNameIndex",ClassNameDesc,TableFieldName,0))
					s TableName=$lg($g(^CF.WDT.CDSS.ALLDictSearchSetD(ConfigId)),3)
					s FieldNum=$lg($g(^CF.WDT.CDSS.ALLDictSearchSetD(ConfigId)),5)
					s DataStateNum=$lg($g(^CF.WDT.CDSS.ALLDictSearchSetD(ConfigId)),9)
					x "s DataState=$lg($g(^"_TableName_"D("_ObjectReference_")),"_DataStateNum_")"
					if NewDataJson.%Get(TableFieldName)'=OldDataJson.%Get(TableFieldName)		//如果修改前后字段值没有变化则不修改索引数据
					{
						d ..UpdateStrIdx(OldDataJson.%Get(TableFieldName),NewDataJson.%Get(TableFieldName),ObjectReference,ClassNameDesc,DataState,FieldNum)
					}					
				}
				else					//删除
				{	
					if NewDataJson.%Get(TableFieldName)'=""
					{
						d ..DeleteStrIdx(NewDataJson.%Get(TableFieldName),ObjectReference,ClassNameDesc)
					} 	
				} 
			}
		}
	}
	
	q "success"
}

/// Creator:Xuwenhu
/// CreatDate:2022-03-23
/// Input:desc-描述，type-类型（百科/字典）默认全部
/// Description：查询数据（webservice调用接口）
/// Other: w ##class(web.CDSS.Config.ALLDictIndex).GetIndexList("霍奇金病","百科")
ClassMethod GetIndexList(desc, type) As %String
{
	n (desc,type)
	Set rs=##class(%ResultSet).%New("web.CDSS.Config.ALLDictIndex:GetIndexList")
	Set sc=rs.Execute(desc,type)
	If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) Quit
	s JSON={}
	s Data=[]
	Set columns=rs.GetColumnCount()
	For
	{  
		Quit:rs.Next(.sc)=0  
		if $$$ISOK(sc) 
		{ 
			s DataDetail={}
			For i=1:1:columns
			{
				d DataDetail.%Set(rs.GetColumnHeader(i),rs.GetData(i))
			}
		}
		else 
		{ 
			quit
		}
		d Data.%Push(DataDetail)
	}
	d JSON.%Set("rows",Data)
	d JSON.%Set("total",rs.%ROWCOUNT)
	if $$$ISERR(sc) do $system.OBJ.DisplayError(sc)
	q JSON.%ToJSON()
}

}
