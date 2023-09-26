/// lixin 20181017
/// /全文检索索引方法类
/// User.BDPMKBIndex
Class web.DHCBL.MKB.BDPMKBIndex Extends %RegisteredObject
{

/// Creator:谷雪萍
/// CreatDate:2018-05-10
/// Description：生成索引-过滤特殊字符
/// Input：str-字符串
/// Return:str-过滤后的字符串
/// w ##class(web.DHCBL.MKB.BDPMKBIndex).Filter("血、尿、便常规")
ClassMethod Filter(str As %String) As %String
{
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

/// Creator:谷雪萍
/// CreatDate:2018-05-10
/// Description：生成索引-过滤特殊字符
/// Input：str-字符串
/// Return:str-过滤后的字符串
/// w ##class(web.DHCBL.MKB.BDPMKBIndex).Combo("123456789abc")
ClassMethod Combo(str As %String) As %String
{
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

/// Creator:谷雪萍
/// CreatDate:2018-05-10
/// Description：生成索引数据并保存到索引表
/// Input:str-术语信息,termid-术语ID或者术语id_"D"_术语内容ID
/// return:1
/// w ##class(web.DHCBL.MKB.BDPMKBIndex).SaveStrIdx("12345","2")
ClassMethod SaveStrIdx(str As %String, termid As %String)
{
	q:((str="")||(termid="")) 0
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
	    s upDesc=" "_$ZCONVERT(desc,"U") //转换成大写  
	    if ($D(^User.BDPMKBIndexI("DescIndex",upDesc,termid))=0)
		{
			s obj2=##class(User.BDPMKBIndex).%New()
			s obj2.BDPCode=termid
			s obj2.BDPDesc = desc          //修改描述
			s sc2=obj2.%Save()
			d obj2.%Close()	
		}
	}

	q 1
}

/// Creator:谷雪萍
/// CreatDate:2018-05-10
/// Description：生成索引数据并保存到索引表
/// Input:str-要删除的术语信息,termid-术语ID或者术语id_"D"_术语内容ID
/// return:1
/// w ##class(web.DHCBL.MKB.BDPMKBIndex).DeleteStrIdx("A00A09","2")
ClassMethod DeleteStrIdx(str As %String, termid As %String) As %String
{
	q:((str="")||(termid="")) 0
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
	    s upDesc=" "_$ZCONVERT(desc,"U") //转换成大写  
	    if ($d(^User.BDPMKBIndexI("DescIndex",upDesc)))  //如果有这个描述了
		{
			s idStr=0
			for
			{
				s idStr=$o(^User.BDPMKBIndexI("DescIndex",upDesc,idStr))
				q:idStr=""
				
				s id=0
				for
				{
					s id = $o(^User.BDPMKBIndexI("DescIndex",upDesc,idStr,id))
					q:id=""
					
					d ##class(User.BDPMKBIndex).%DeleteId(id)
				}
			}

		}
	}

	q 1
}

/// Creator:谷雪萍
/// CreatDate:2018-05-10
/// Description：修改索引数据并保存到索引表
/// Input:oldData-原术语信息,newData-术语信息,termid-术语ID或者术语id_"D"_术语内容ID
/// return:1
/// w ##class(web.DHCBL.MKB.BDPMKBIndex).UpdateStrIdx("A00B99","acssj","1")
ClassMethod UpdateStrIdx(oldData As %String, newData As %String, termid As %String) As %String
{
	s result1=..DeleteStrIdx(oldData,termid)
	s result2=..SaveStrIdx(newData,termid)
	q result1_"^"_result2
}

/// Creator:谷雪萍
/// CreatDate:2018-05-10
/// Description：遍历医用知识库知识生成索引
/// Input：flag-为空时属性内容不生成全文索引，为1时属性内容生成全文索引，默认为空
/// Return:str-过滤后的字符串
/// w ##class(web.DHCBL.MKB.BDPMKBIndex).SaveTermIdx()
ClassMethod SaveTermIdx(flag As %String = "") As %String
{
	k ^User.BDPMKBIndexD
	k ^User.BDPMKBIndexI
	k base
	//循环术语表User.MKBTerm
	
	s time1=$NOW()
	s MKBTermCatBase=$o(^User.MKBTermBaseI("DescIndex"," 术语分类",0))
	s MKBTermCatRowid=$o(^User.MKBTermI("DescIndex",MKBTermCatBase," 全文检索",0))
	s MKBTermBase=0
	for
	{
		s MKBTermBase=$o(^User.MKBTermBaseD(MKBTermBase))
		q:MKBTermBase=""
		s MKBTBCatDr=$LISTGET($G(^User.MKBTermBaseD(MKBTermBase)),9)
		s CatDrStr="&%"_MKBTBCatDr_"&%"
		s CatRowIdStr="&%"_MKBTermCatRowid_"&%"
		if CatDrStr[CatRowIdStr
		{
			s base(MKBTermBase)=""
		}
	}
	
	/*
	s base($O(^User.MKBTermBaseI("FlagIndex"," DIAGNOSE",0)))=""
	s base($O(^User.MKBTermBaseI("FlagIndex"," PART",0)))=""
	s base($O(^User.MKBTermBaseI("FlagIndex"," ICD11",0)))=""
	s base($O(^User.MKBTermBaseI("FlagIndex"," ICD10INTER",0)))=""
	*/
	if ($d(base)'=0)
	{
		s ICD11Base=$O(^User.MKBTermBaseI("FlagIndex"," ICD11",0))
		s MKBTBRowId=0
		for
		{
			s MKBTBRowId=$O(base(MKBTBRowId))
			q:MKBTBRowId=""
			
			s MKBTRowId=0
			for
			{
				s MKBTRowId=$O(^User.MKBTermI("BaseIndex",MKBTBRowId,MKBTRowId))
				q:MKBTRowId=""
				
				if (MKBTBRowId=ICD11Base)  //如果是ICD11 则代码也加入全文索引
				{
					s MKBTCode=$listGet($g(^User.MKBTermD(MKBTRowId)),2)  //代码			
					d ..SaveStrIdx(MKBTCode,MKBTRowId)
				}
				s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTRowId)),3)  //描述
				d ..SaveStrIdx(MKBTDesc,MKBTRowId)
				s MKBTPYCode=$listGet($g(^User.MKBTermD(MKBTRowId)),6)  //检索码
				d ..SaveStrIdx(MKBTPYCode,MKBTRowId)
				s MKBTNote=$listGet($g(^User.MKBTermD(MKBTRowId)),7)  //备注
				//d ..SaveStrIdx(MKBTNote,MKBTRowId)
				
				//if (flag=1)
				//{
					s property=0   //循环属性表User.MKBTermProperty
					for  
					{	
						s property=$o(^User.MKBTermPropertyI("TermIndex",MKBTRowId,property)) q:property=""
						s propertyName=$LISTGET($G(^User.MKBTermPropertyD(property)),3)  //属性名
						if (flag="")	//默认为空时，生成中心词和别名的索引
						{
							continue:propertyName'="别名"	
						}		
						
						
						s propertyType=$LISTGET($G(^User.MKBTermPropertyD(property)),4)  //属性格式
								
						s MKBTPDRowId=0  //循环属性内容表	
						for  
						{	
							s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProIdx",property,MKBTPDRowId)) q:MKBTPDRowId="" 
							s idxId=MKBTRowId_"D"_MKBTPDRowId
							
							s MKBTPDDesc=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)  //引用术语的id
							continue:MKBTPDDesc=""
							
							if (propertyType="S") //引用术语格式的属性
							{
								
								s termDesc=$listGet($g(^User.MKBTermD(MKBTPDDesc)),3)  //引用术语的描述
								d ..SaveStrIdx(termDesc,idxId)   //内容描述生成索引
							}
							elseif(propertyType="P") //知识应用模板格式的属性
							{
								s strProperty=""
						        s argsLen=$Length(MKBTPDDesc,",")
						        for i=1:1:argsLen  
						        { 
						          s argstr=$p(MKBTPDDesc,",",i)
						          s MKBTPRowId=$p(argstr,"&",1)
						          s MKBTPShowType=$p(argstr,"&",2)  //展示格式
						          s MKBTPTreeNode=$p(argstr,"&",3)  //定义节点
						          continue:MKBTPRowId=""
						          s MKBTPDesc=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),3) //属性描述 
						          s treeNodeDesc=""
						          s:MKBTPTreeNode'="" treeNodeDesc=$LISTGET($G(^User.MKBTermProDetailD(MKBTPTreeNode)),3) //定义节点的描述 
						          s strProperty=strProperty_MKBTPDesc_treeNodeDesc			          

						        }
								
								d ..SaveStrIdx(strProperty,idxId)   //内容描述生成索引					
							}
							elseif(propertyType="SD")
							{
								s expDesc=##class(web.DHCBL.MKB.MKBKnoExpression).GetDiagDesc(MKBTPDDesc)
								d ..SaveStrIdx(expDesc,idxId)   //内容描述生成索引	
							}
							else
							{
								d ..SaveStrIdx(MKBTPDDesc,idxId)   //内容描述生成索引
							}
														
							
							s MKBTPDRemark=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),7)
							//d ..SaveStrIdx(MKBTPDRemark,idxId)   //内容备注生成索引
							s ExtendStr=""   //知识点扩展属性子表的字段

							s subId=0  //循环扩展属性子表User.MKBTermProperty
							for 
							{
								S subId=$o(^User.MKBTermPropertyD(property,"ChildExtPro",subId)) q:subId=""
								s MKBTEPRowId=property_"||"_subId  //扩展属性表的ID
								s MKBTEPType=$LISTGET($G(^User.MKBTermPropertyD(property,"ChildExtPro",subId)),3)   //扩展属性类型
								s MKBTEPVRowId=$o(^User.MKBTermExtendProValI("ValIndex",MKBTPDRowId,MKBTEPRowId,0))  //扩展属性内容表的id
								s MKBTEPVValue=""
						        s:MKBTEPVRowId'="" MKBTEPVValue=$LISTGET($G(^User.MKBTermExtendProValD(MKBTEPVRowId)),4) //扩展属性内容的值
						        if (MKBTEPVValue'="")
						        {	
									if (MKBTEPType="S")  //数据来源型 (注意要换成MKBTerm)
									{	
										s MKBTEPVValue=$listGet($g(^User.MKBTermD(MKBTEPVValue)),3) //获取描述
														  
									}
									if (MKBTEPType="SD")  //引用诊断型
									{		  
										s MKBTEPVValue=##class(web.DHCBL.MKB.MKBKnoExpression).GetDiagDesc(MKBTEPVValue)		  	  
									}
						        }
								d ..SaveStrIdx(MKBTEPVValue,idxId)   //内容描述生成索引
								
							}
							
						}
					}	
				//}
			} 
				
		}
	}
	s time2=$NOW()
	w time1,"--",time2,!
	q 1
}

/// Creator:谷雪萍
/// CreatDate:2018-05-11
/// Description：添加术语或属性内容时生成索引。 注意：修改时调用要先在保存之前调一次DeleteTermIndex，然后在保存之后调一次AddTermIndex
/// Input：id-术语或属性内容id ，type-标识:术语T /属性内容D
/// Return: 1
/// w ##class(web.DHCBL.MKB.BDPMKBIndex).AddTermIndex()
ClassMethod AddTermIndex(id As %String, type As %String) As %String
{
	q:((id="")||(type="")) 0
	
	if (type="T")
	{
		s MKBTRowId=id
		s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTRowId)),3)  //描述
		d ..SaveStrIdx(MKBTDesc,MKBTRowId)
		s MKBTPYCode=$listGet($g(^User.MKBTermD(MKBTRowId)),6)  //检索码
		d ..SaveStrIdx(MKBTPYCode,MKBTRowId)
		s MKBTNote=$listGet($g(^User.MKBTermD(MKBTRowId)),7)  //备注
		//d ..SaveStrIdx(MKBTNote,MKBTRowId)
	}
	if (type="D")
	{
		s MKBTPDRowId=id
		s property=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),6)  //属性id
		q:property="" 0
		s propertyType=$LISTGET($G(^User.MKBTermPropertyD(property)),4)  //属性格式
		s MKBTRowId=$LISTGET($G(^User.MKBTermPropertyD(property)),6)  //术语id
		q:MKBTRowId="" 0
		s idxId=MKBTRowId_"D"_MKBTPDRowId
		s MKBTPDDesc=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)  //引用术语的id
	
		if (propertyType="S") //引用术语格式的属性
		{
			s termDesc=$listGet($g(^User.MKBTermD(MKBTPDDesc)),3)  //引用术语的描述
			d ..SaveStrIdx(termDesc,idxId)   //内容描述生成索引
		}
		elseif(propertyType="P") //知识应用模板格式的属性
		{
			s strProperty=""
	        s argsLen=$Length(MKBTPDDesc,",")
	        for i=1:1:argsLen  
	        { 
	          s argstr=$p(MKBTPDDesc,",",i)
	          s MKBTPRowId=$p(argstr,"&",1)
	          s MKBTPShowType=$p(argstr,"&",2)  //展示格式
	          s MKBTPTreeNode=$p(argstr,"&",3)  //定义节点
	          continue:MKBTPRowId=""
	          s MKBTPDesc=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),3) //属性描述 
	          s treeNodeDesc=""
	          s:MKBTPTreeNode'="" treeNodeDesc=$LISTGET($G(^User.MKBTermProDetailD(MKBTPTreeNode)),3) //定义节点的描述 
	          s strProperty=strProperty_MKBTPDesc_treeNodeDesc			          

	        }
			
			d ..SaveStrIdx(strProperty,idxId)   //内容描述生成索引					
		}
		elseif(propertyType="SD")
		{
			s expDesc=##class(web.DHCBL.MKB.MKBKnoExpression).GetDiagDesc(MKBTPDDesc)
			d ..SaveStrIdx(expDesc,idxId)   //内容描述生成索引	
		}
		else
		{
			d ..SaveStrIdx(MKBTPDDesc,idxId)   //内容描述生成索引
		}
									
		
		s MKBTPDRemark=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),7)
		//d ..SaveStrIdx(MKBTPDRemark,idxId)   //内容备注生成索引
		s ExtendStr=""   //知识点扩展属性子表的字段

		s subId=0  //循环扩展属性子表User.MKBTermProperty
		for 
		{
			S subId=$o(^User.MKBTermPropertyD(property,"ChildExtPro",subId)) q:subId=""
			s MKBTEPRowId=property_"||"_subId  //扩展属性表的ID
			s MKBTEPType=$LISTGET($G(^User.MKBTermPropertyD(property,"ChildExtPro",subId)),3)   //扩展属性类型
			s MKBTEPVRowId=$o(^User.MKBTermExtendProValI("ValIndex",MKBTPDRowId,MKBTEPRowId,0))  //扩展属性内容表的id
			s MKBTEPVValue=""
	        s:MKBTEPVRowId'="" MKBTEPVValue=$LISTGET($G(^User.MKBTermExtendProValD(MKBTEPVRowId)),4) //扩展属性内容的值
	        if (MKBTEPVValue'="")
	        {	
				if (MKBTEPType="S")  //数据来源型 (注意要换成MKBTerm)
				{	
					s MKBTEPVValue=$listGet($g(^User.MKBTermD(MKBTEPVValue)),3) //获取描述
									  
				}
				if (MKBTEPType="SD")  //引用诊断型
				{		  
					s MKBTEPVValue=##class(web.DHCBL.MKB.MKBKnoExpression).GetDiagDesc(MKBTEPVValue)		  	  
				}
	        }
			d ..SaveStrIdx(MKBTEPVValue,idxId)   //内容描述生成索引
			
		}
					
		
	}
		

	q 1
}

/// Creator:谷雪萍
/// CreatDate:2018-05-11
/// Description：删除术语或属性内容时生成索引
/// Input：id-术语或属性内容id ，type-标识:术语T /属性内容D
/// Return: 1
/// w ##class(web.DHCBL.MKB.BDPMKBIndex).DeleteTermIndex(2,"T")
ClassMethod DeleteTermIndex(id As %String, type As %String) As %String
{
	q:((id="")||(type="")) 0
	
	if (type="T")
	{
		s MKBTRowId=id
		s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTRowId)),3)  //描述
		d ..DeleteStrIdx(MKBTDesc,MKBTRowId)
		s MKBTPYCode=$listGet($g(^User.MKBTermD(MKBTRowId)),6)  //检索码
		d ..DeleteStrIdx(MKBTPYCode,MKBTRowId)
		s MKBTNote=$listGet($g(^User.MKBTermD(MKBTRowId)),7)  //备注
		//d ..DeleteStrIdx(MKBTNote,MKBTRowId)
	}
	if (type="D")
	{
		s MKBTPDRowId=id
		s property=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),6)  //属性id
		q:property="" 0
		s propertyType=$LISTGET($G(^User.MKBTermPropertyD(property)),4)  //属性格式
		s MKBTRowId=$LISTGET($G(^User.MKBTermPropertyD(property)),6)  //术语id
		q:MKBTRowId="" 0
		s idxId=MKBTRowId_"D"_MKBTPDRowId
		s MKBTPDDesc=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)  //引用术语的id
	
		if (propertyType="S") //引用术语格式的属性
		{
			s termDesc=$listGet($g(^User.MKBTermD(MKBTPDDesc)),3)  //引用术语的描述
			d ..DeleteStrIdx(termDesc,idxId)   //内容描述生成索引
		}
		elseif(propertyType="P") //知识应用模板格式的属性
		{
			s strProperty=""
	        s argsLen=$Length(MKBTPDDesc,",")
	        for i=1:1:argsLen  
	        { 
	          s argstr=$p(MKBTPDDesc,",",i)
	          s MKBTPRowId=$p(argstr,"&",1)
	          s MKBTPShowType=$p(argstr,"&",2)  //展示格式
	          s MKBTPTreeNode=$p(argstr,"&",3)  //定义节点
	          continue:MKBTPRowId=""
	          s MKBTPDesc=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),3) //属性描述 
	          s treeNodeDesc=""
	          s:MKBTPTreeNode'="" treeNodeDesc=$LISTGET($G(^User.MKBTermProDetailD(MKBTPTreeNode)),3) //定义节点的描述 
	          s strProperty=strProperty_MKBTPDesc_treeNodeDesc			          

	        }
			
			d ..DeleteStrIdx(strProperty,idxId)   //内容描述生成索引					
		}
		elseif(propertyType="SD")
		{
			s expDesc=##class(web.DHCBL.MKB.MKBKnoExpression).GetDiagDesc(MKBTPDDesc)
			d ..DeleteStrIdx(expDesc,idxId)   //内容描述生成索引	
		}
		else
		{
			d ..DeleteStrIdx(MKBTPDDesc,idxId)   //内容描述生成索引
		}
									
		
		s MKBTPDRemark=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),7)
		//d ..DeleteStrIdx(MKBTPDRemark,idxId)   //内容备注生成索引
		s ExtendStr=""   //知识点扩展属性子表的字段

		s subId=0  //循环扩展属性子表User.MKBTermProperty
		for 
		{
			S subId=$o(^User.MKBTermPropertyD(property,"ChildExtPro",subId)) q:subId=""
			s MKBTEPRowId=property_"||"_subId  //扩展属性表的ID
			s MKBTEPType=$LISTGET($G(^User.MKBTermPropertyD(property,"ChildExtPro",subId)),3)   //扩展属性类型
			s MKBTEPVRowId=$o(^User.MKBTermExtendProValI("ValIndex",MKBTPDRowId,MKBTEPRowId,0))  //扩展属性内容表的id
			s MKBTEPVValue=""
	        s:MKBTEPVRowId'="" MKBTEPVValue=$LISTGET($G(^User.MKBTermExtendProValD(MKBTEPVRowId)),4) //扩展属性内容的值
	        if (MKBTEPVValue'="")
	        {	
				if (MKBTEPType="S")  //数据来源型 (注意要换成MKBTerm)
				{	
					s MKBTEPVValue=$listGet($g(^User.MKBTermD(MKBTEPVValue)),3) //获取描述
									  
				}
				if (MKBTEPType="SD")  //引用诊断型
				{		  
					s MKBTEPVValue=##class(web.DHCBL.MKB.MKBKnoExpression).GetDiagDesc(MKBTEPVValue)		  	  
				}
	        }
			d ..DeleteStrIdx(MKBTEPVValue,idxId)   //内容描述生成索引
			
		}
					
		
	}
		

	q 1
}

/// Creator:谷雪萍
/// CreatDate:2018-05-10
/// Description：Kill索引数据
/// Input：
/// Return:1
/// d ##class(web.DHCBL.MKB.BDPMKBIndex).KillIndexGlobal()
ClassMethod KillIndexGlobal()
{
	k ^User.BDPMKBIndexD
	k ^User.BDPMKBIndexI
	
	q 1
}

/// Creator:谷雪萍
/// CreatDate:2018-05-10
/// Description：导出索引数据
/// Input：
/// Return:1
/// d ##class(web.DHCBL.MKB.BDPMKBIndex).ExportIndexGlobal()
ClassMethod ExportIndexGlobal()
{
	k CList
	k myIdx	
	
	s CList($i(CList))= "User.BDPMKBIndexD.GBL"  
	s CList($i(CList))= "User.BDPMKBIndexI.GBL"  
    
	s items = ""
	f {
		s myIdx = $i(myIdx)
		q:(myIdx>$g(CList))
		s:((items'="")&&(CList(myIdx)'="")) items= items_","

		s items = items_CList(myIdx)
	}
	d $SYSTEM.OBJ.Export(items, "D:\BDPMKBIndex.gof", "", .log)
}

}
