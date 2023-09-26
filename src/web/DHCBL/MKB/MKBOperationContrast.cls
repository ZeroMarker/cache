/// Description:各版本手术对照处理
/// Creator：张云越
/// Date： 2019-10-23
Class web.DHCBL.MKB.MKBOperationContrast Extends %RegisteredObject
{

/// Creator:李得原
/// CreatDate:2019-05-16
/// Description：封闭了的引用术语标红，结构化结果ID串按照诊断模板顺序输出，如果诊断模板中已经删除属性，但结构化串中还有，也要显示。医保版的显示为黑色
/// Table：User.MKBStructuredDataResult
/// Input：子表id 
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBOperationContrast).GetChiForNewSeqStrucIDs("1768:S16415*S16426","14626")
ClassMethod GetChiForNewSeqStrucIDs(ids, termdr)
{
	s result=""
	q:termdr="" ""
	if '$d(^User.MKBTermD(termdr))
	{
		q ""
	}
	s strComAndAlisa=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(termdr) //睑内翻或睑外翻修补术&%JNFHJWFXBS[A] 描述+&%+拼音码+[A]+别名描述+别名检索码
	s strCom=$p(strComAndAlisa,"[A]",1) //常用名及拼音码
	s result=$p(strCom,"&%",1) //手术常用名
	if result=""
	{
		s result=$lg($g(^User.MKBTermD(termdr)),3)
	}
	if ids'=""
	{
		//获取知识应用模板id在这里是手术模板id
		s DiagTemplateDr=$o(^User.MKBTermPropertyI("FlagIndex",termdr," DT",0)) 
		q:DiagTemplateDr="" ""
		s MKBTPDRowid=$o(^User.MKBTermProDetailI("ProIdx",DiagTemplateDr,0)) //手术模板详细id
		
		q:MKBTPDRowid="" result
		if '$d(^User.MKBTermProDetailD(MKBTPDRowid))
		{
			q result	
		}
		//8910062&T&2187044&S&N&P,8910062&T&2305011&S&N&P,8910062&T&2305002&S&N&P,9441106&G&&S&N&P
		s Detail=$lg($g(^User.MKBTermProDetailD(MKBTPDRowid)),3)
		s len=$l(Detail,",") //分割手术模板中属性
		for i=1:1:len
		{
			s OnePiece=$p(Detail,",",i)
			continue:OnePiece=""
			s Prodr=$p(OnePiece,"&",1)  //属性ID
			s Type=$p(OnePiece,"&",2)
			s ProDetailDr=$p(OnePiece,"&",3) //属性内容ID
			if ProDetailDr'=""
			{
				s Sequence(i,Prodr,ProDetailDr)="" //手术模板中的第i个模板,propertyID,proDetailDR
				s str=##class(web.DHCBL.MKB.MKBTermProDetail).GetChildOrderedIDStr(ProDetailDr,Prodr) //父节点下所有节点2305016^2305008^2305014^2305017
				s strlen=$l(str,"^")
				for j=1:1:strlen
				{
					s ProDetail=$p(str,"^",j)
					continue:ProDetail=""
					s Details(i,Prodr,ProDetailDr,ProDetail)="" //手术模板中的第i个模板,propertyID,proDetailDR,proDetailDR
				}
			}
			else //属性内容为空
			{
				s Sequence(i,Prodr)="" //手术模板中的第i个模板,propertyID 
			}
		}
		s ValueString=""
		s ResultLen=$l(ids,",") //拆分结构化数据来自几个模板 8910062:2305009*2305003,9441106:2305005
		s seq=0
		for
		{
			s seq=$o(Sequence(seq))   //获取顺序
			q:seq=""
			s Pro=0
			for
			{
				s Pro=$o(Sequence(seq,Pro))    //获取顺序中的Prodr
				q:Pro=""
				for i=1:1:ResultLen     
				{
					s Result=$p(ids,",",i)
					s key=$p(Result,":",1) //propertyID 
					s Val=$p(Result,":",2) //proDetailDR  来自子表数据如::2305009*2305003
					if Pro=key
					{
						s valueslen=$l(Val,"*") //该模板中使用了几个节点
						for k=1:1:valueslen
						{
							s val=$p(Val,"*",k) //具体的结构化中属性
							s values=Pro_":"_val //propertyID:proDetailDR
							if values["S" //引用术语
							{
								d GetDesc
								s tempV(val)=""
								s tempK(Pro)=""
							}
							elseif $d(Sequence(seq,Pro)) 
							{
								if $d(Sequence(seq,Pro))=1 //没有子节点
								{
									d GetDesc
									s tempK(Pro)=""
									s tempV(val)=""
								}
								else
								{
									s SMark=0
									for
									{
										s SMark=$o(Sequence(seq,Pro,SMark)) //模板顺序，模板id，父节点
										q:SMark=""
										if $d(Details(seq,Pro,SMark,val)) //模板顺序，模板id，父节点，子节点(具体结构化属性)
										{
											if ('$d(tempV(val)))&&('$d(tempK(Pro))) 
											{
												d GetDesc
												s tempK(Pro)=""
												s tempV(val)=""
											}elseif '$d(tempV(val)) //相同模板下 张云越新增
											{
												d GetDesc
												s tempV(val)=""
											}
										}
									}
								}

							}
							/*else 张云越注释
							{
								s DNode=0
								for
								{
									s DNode=$o(Sequence(seq,Pro,DNode))   //引用起始节点
									q:DNode=""
									if $d(Details(seq,Pro,DNode,val))
									{
										if ('$d(^User.MKBTermPropertyD(key)))
										{
											continue
										}
										d GetDesc
										s tempV(val)=""
										s tempK(Pro)=""
									}
								}
							}*/
						}
					}
				}
			}
		}	
		for j=1:1:ResultLen ////拆分结构化数据来自几个模板 8910062:2305009*2305003,9441106:2305005
		{
			s Result=$p(ids,",",j)
			s key=$p(Result,":",1)
			s Val=$p(Result,":",2)
			s valueslen=$l(Val,"*")
			for k=1:1:valueslen
			{
				s values=""
				s value=$p(Val,"*",k)
				s values=key_":"_value
				if '$d(tempK(key))    //诊断模板中不存在的属性
				{
					continue:'$d(^User.MKBTermPropertyD(key)) //术语都没了就不输出
					d GetDesc
				}
				else
				{
					if '$d(tempV(value))         //诊断模板中不存在的属性内容
					{
						d GetDesc
					}
				}
			}
		}
		if ValueString=""
		{
			s result=result
		}
		else
		{
			s result=result_"["_ValueString_"]"	
		}
	}	
	;2020-1-6新增 封闭数据红色
	s ActiveFlag=$lg($g(^User.MKBTermD(termdr)),9)
	s:ActiveFlag="N" result="<font color=red>"_result_"</font>"
	
	;2020-1-7新增 医保版黑色
	s termBaseId = $o(^User.MKBTermBaseI("DescIndex"," 江苏省中医治疗手术",0))
	s termDesc = $lg($g(^User.MKBTermD(termdr)),3)
	s termDescU=$zconvert(termDesc,"U")
	if ($d(^User.MKBTermI("DescIndex",termBaseId," "_termDescU)))
	{
		s source=""
		s tempSourceId = $o(^User.MKBTermPropertyI("DescIndex",termdr," 数据来源",0)) //数据来源id
		s:tempSourceId'="" tempDetailId = $o(^User.MKBTermProDetailI("ProIdx",tempSourceId,0)) //数据来源属性内容id
		s:tempDetailId'="" source=$lg($g(^User.MKBTermProDetailD(tempDetailId)),3) //数据来源
		s:source["医保版" result="<font color=black>"_result_"</font>"
	}
	
	q result 
    
GetDesc             //串转描述
	if values["S"
	{
		s values=$tr(values,"S","")
		s ValueDr=$p(values,":",2)
		s Value=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComByTermId(ValueDr)
		s ActiveFlag=$lg($g(^User.MKBTermD(ValueDr)),9)
		;s Value=$lg($g(^User.MKBTermD(ValueDr)),3)
		
		if ValueString'=""
		{
			s ValueString=ValueString_","_Value
		}
		if ValueString=""
		{
			s ValueString=Value
		}	
		if ActiveFlag="N"
		{
			s ValueString="<font color=red>"_ValueString_"</font>"
		}
	}
	else
	{
		s ValueDr=$p(values,":",2)
		s Value= ##class(web.DHCBL.MKB.MKBTermProDetail).GetExtendVal(ValueDr,key,"展示名")
		if Value=""
		{
			s Value=$lg($g(^User.MKBTermProDetailD(ValueDr)),3)
		}
		if ValueString'=""
		{
			s ValueString=ValueString_","_Value
		}
		if ValueString=""
		{
			s ValueString=Value
		}
	}
}

/// Creator:张云越
/// CreatDate:2020-1-6
/// Description：导入医保版手术数据到江苏省中医治疗手术库
/// Table：User.MKBTerm 术语表
/// Input：filePath 文件路径 fileName 文件名
/// Return：success 或 false
/// Other: w ##class(web.DHCBL.MKB.MKBOperationContrast).ImportYiBaoICD9("D:\Import\","ICD9医保版.csv")
ClassMethod ImportYiBaoICD9(filePath As %String, fileName As %String) As %String
{
	TS
	s num = 0 //总数据量
	s tempNum=0 //算空记录用
	s successNum=0 //成功导入数量
	s repeatNum=0 //更新重复中心词编码数量
	s fileNum=0 //导入失败的
	s file = ##class(%File).%New(filePath_fileName)
	d file.Open("RS")
	d file.ReadLine()
	s termBase = $o(^User.MKBTermBaseI("DescIndex"," 江苏省中医治疗手术",0)) //知识库id
	While 'file.AtEnd
	{
		s num=num+1 
		s Line=file.ReadLine()
		continue:Line="" //过滤空数据
		s tempNum=tempNum+1
		
		s OpeNum=$p(Line,",",1) //手术编码
		s OpeNum=$p(OpeNum,"'",1) //从引号中取出值		
		//处理左右空格,中文符号
		s OpeNum = $tr(OpeNum," ","") //去除空格
		//s OpeNum = $zstrip(OpeNum,"<>W")
		s OpeNum=$Replace(OpeNum,"(","（")
		s OpeNum=$Replace(OpeNum,")","）")
		s OpeNum=##class(web.DHCBL.BDP.FunLib).EvalJSON(OpeNum)	
		//确保小数点后一位
		s tempNum=$p(OpeNum,".",2)	
		s length=$Length(tempNum)
		s tempNum=tempNum+1
		continue:length'=1 //过滤不满足条件的数据	

		s OpeDesc=$p(Line,",",2) //手术编码描述
		//处理左右空格,中文符号
		s OpeDesc = $tr(OpeDesc," ","") //去除空格
		//s OpeDesc = $zstrip(OpeDesc,"<>W") 
		s OpeDesc=$Replace(OpeDesc,"(","（")
		s OpeDesc=$Replace(OpeDesc,")","）")
		s OpeDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(OpeDesc)	
		//s OpeDesc=OpeDesc_"（医保）"
		s OpeDescU=$ZCONVERT(OpeDesc,"U") //转换大写
		
		if $d(^User.MKBTermI("DescIndex",termBase," "_OpeDescU)) //已有的中心词,更新编码和数据来源
		{
			s repeatNum=repeatNum+1
			s tempTermId = $o(^User.MKBTermI("DescIndex",termBase," "_OpeDescU,0))
			s tempNumberId = $o(^User.MKBTermPropertyI("DescIndex",tempTermId," 手术编码",0)) //编码属性id
			s tempSourceId = $o(^User.MKBTermPropertyI("DescIndex",tempTermId," 数据来源",0)) //数据来源id
			if '$d(^User.MKBTermProDetailI("ProIdx",tempNumberId)) //没有编码内容
			{	
				//新增编码内容
				TS
				s tempAddDetailObj = ##class(web.Entity.MKB.MKBTermProDetail).%New()					
				s tempAddDetailObj.MKBTPDProDR = tempNumberId 
				s tempAddDetailObj.MKBTPDDesc = OpeNum
				s tempResult = ##class(web.DHCBL.MKB.MKBTermProDetail).SaveData(tempAddDetailObj)
				if tempResult["true"
				{
					TCOMMIT
				}
				else
				{
					s fileNum=fileNum+1
					w "中心词:"_OpeDesc_"的编码导入失败"
					b
					TROLLBACK
				}
				d tempAddDetailObj.%Close()				
			}
			else
			{
				//修改编码内容
				s tempAddDetailObj = ##class(web.Entity.MKB.MKBTermProDetail).%New()					
				s tempAddDetailObj.MKBTPDProDR = tempNumberId 
				s tempDetailId = $o(^User.MKBTermProDetailI("ProIdx",tempNumberId,0)) //编码属性内容id
				if tempDetailId'=OpeNum 
				{
					s tempAddDetailObj.MKBTPDRowId=tempDetailId //编码内容id
					s tempAddDetailObj.MKBTPDDesc=OpeNum		
					TS
					s tempResult = ##class(web.DHCBL.MKB.MKBTermProDetail).SaveData(tempAddDetailObj)
					if tempResult["true"
					{
						TCOMMIT
					}
					else
					{
						s fileNum=fileNum+1
						w "中心词:"_OpeDesc_"的编码导入失败"
						b
						TROLLBACK
					}
					d tempAddDetailObj.%Close()	
				}
			}
			if '$d(^User.MKBTermProDetailI("ProIdx",tempSourceId)) //没有数据来源内容
			{
				//新增数据来源内容
				TS
				s tempAddDetailObj2 = ##class(web.Entity.MKB.MKBTermProDetail).%New()					
				s tempAddDetailObj2.MKBTPDProDR = tempSourceId 
				s tempAddDetailObj2.MKBTPDDesc = "医保版,江苏省中医"
				s result2 = ##class(web.DHCBL.MKB.MKBTermProDetail).SaveData(tempAddDetailObj2)
				if result2["true"
				{
					TC
				}
				else
				{
					s fileNum=fileNum+1
					w "中心词:"_OpeDesc_"的数据来源导入失败"
					TRO
				}
				d tempAddDetailObj2.%Close()
			}			
		}
		else //无重复则新增
		{
			//新增中心词
			TS
			s AddObj = ##class(web.Entity.MKB.MKBTerm).%New()
			s AddObj.MKBTBaseDR=termBase
			s AddObj.MKBTDesc=OpeDesc
			s result = ##class(web.DHCBL.MKB.MKBTerm).SaveData(AddObj) //{success:'true',id:'1438824'}
			if result["true"
			{
				TCOMMIT
				//新增属性内容
				s termId =$p(result,"'",4) //中心词ID
				s NumberId = $o(^User.MKBTermPropertyI("DescIndex",termId," 手术编码",0)) //编码属性id
				s AliasId = $o(^User.MKBTermPropertyI("DescIndex",termId," 别名",0)) //别名属性id
				s SourceId = $o(^User.MKBTermPropertyI("DescIndex",termId," 数据来源",0)) //数据来源属性id
				//新增编码内容
				TS
				s AddDetailObj1 = ##class(web.Entity.MKB.MKBTermProDetail).%New()					
				s AddDetailObj1.MKBTPDProDR = NumberId 
				s AddDetailObj1.MKBTPDDesc = OpeNum
				s result1 = ##class(web.DHCBL.MKB.MKBTermProDetail).SaveData(AddDetailObj1)
				if result1["true"
				{
					TCOMMIT
					//新增别名内容
					TS
					s AddDetailObj2 = ##class(web.Entity.MKB.MKBTermProDetail).%New()					
					s AddDetailObj2.MKBTPDProDR = AliasId 
					s AddDetailObj2.MKBTPDDesc = OpeDesc
					s result2 = ##class(web.DHCBL.MKB.MKBTermProDetail).SaveData(AddDetailObj2)
					if result2["true"
					{					
						TCOMMIT
						//新增数据来源
						TS
						s AddDetailObj3 = ##class(web.Entity.MKB.MKBTermProDetail).%New()					
						s AddDetailObj3.MKBTPDProDR = SourceId 
						s AddDetailObj3.MKBTPDDesc = "医保版"
						s result3 = ##class(web.DHCBL.MKB.MKBTermProDetail).SaveData(AddDetailObj3)
						if result3["true"
						{
							s successNum=successNum+1
							TC
						}
						else
						{
							s fileNum=fileNum+1
							w "中心词:"_OpeDesc_"的数据来源导入失败"
							TRO
						}
						d AddDetailObj3.%Close()
					}
					else
					{
						s fileNum=fileNum+1
						w "中心词:"_OpeDesc_"的别名导入失败"
						TROLLBACK
					}
					d AddDetailObj2.%Close()
				}
				else
				{
					s fileNum=fileNum+1
					w "中心词:"_OpeDesc_"的编码导入失败"
					b
					TROLLBACK
				}
				d AddDetailObj1.%Close()
			}
			else
			{
				w "中心词:"_OpeDesc_"导入失败"
				b
				TROLLBACK
			}
			d AddObj.%Close()
		}
	}
	s filterNull = num-tempNum //空记录
	s filterFour = num-successNum--fileNum-filterNull //不满足条件
	w "需导入总数:"_num_"条",!
	w "成功导入:"_successNum_"条",!
	w "更新重复中心词编码:"_repeatNum_"条",!
	w "过滤空记录:"_filterNull_"条",!
	w "过滤不满足编码条件记录:"_filterFour_"条",!
	q "success"
}

/// Creator:张云越
/// CreatDate:2020-1-7
/// Description：更新江苏省中医治疗手术(没编码的新增来源为江苏省中医)
/// Table：User.MKBTerm 术语表
/// Return："success" or "false"
/// Other: w ##class(web.DHCBL.MKB.MKBOperationContrast).UpdateSourceToJSSZLSS()
ClassMethod UpdateSourceToJSSZLSS() As %String
{
	TS
	s num=0
	s termBaseId = $o(^User.MKBTermBaseI("DescIndex"," 江苏省中医治疗手术",0)) //知识库id
	s termId=0
	for //遍历江苏省中医治疗手术
	{
		s termId =$o(^User.MKBTermI("BaseIndex",termBaseId,termId))
		q:termId=""
		s termDesc=$lg($g(^User.MKBTermD(termId)),3)
		s propertySourceId = $o(^User.MKBTermPropertyI("DescIndex",termId," 数据来源",0))
		if '$d(^User.MKBTermProDetailI("ProIdx",propertySourceId)) //没有数据来源内容
		{
			//新增数据来源内容
			TS
			s UpdateDetailObj = ##class(web.Entity.MKB.MKBTermProDetail).%New()					
			s UpdateDetailObj.MKBTPDProDR = propertySourceId 
			s UpdateDetailObj.MKBTPDDesc = "江苏省中医"
			s result = ##class(web.DHCBL.MKB.MKBTermProDetail).SaveData(UpdateDetailObj)
			if result["true"
			{
				s num=num+1
				TC
			}
			else
			{
				s fileNum=fileNum+1
				w "中心词:"_termDesc_"的数据来源更新失败"
				TRO
			}
			d UpdateDetailObj.%Close()
		}
	}
	w "成功更新了:"_num_"条记录",!
	q "success"
}

/// Creator:张云越
/// CreatDate:2019-1-2
/// Description：根据江苏省中医治疗手术更新各版本手术对照结构化
/// Table：User.MKBOperationContrast
/// Return："成功更新:"_num_"条各版本手术子表数据"
/// Other: w ##class(web.DHCBL.MKB.MKBOperationContrast).UpdateICD9ToOpeConRes()
ClassMethod UpdateICD9ToOpeConRes() As %String
{
	TS
	s num=0
	s termBaseId = $o(^User.MKBTermBaseI("DescIndex"," 江苏省中医治疗手术",0)) //知识库id
	s OpeConId = 0
	//遍历各版本手术里的数据
	for
	{
		//空数据在索引里是个15位数-100000000000000
		//s OpeConId = $o(^User.MKBOperationContrastI("StructIndex",-100000000000000,OpeConId)) 
		s OpeConId = $o(^User.MKBOperationContrastD(OpeConId))
		q:OpeConId=""
		s OperConNumber = $lg($g(^User.MKBOperationContrastD(OpeConId)),4) //取主要编码
		s OperConStructFlag=$lg($g(^User.MKBOperationContrastD(OpeConId)),17) //取结构化标志
		s OperConNumber1=$p(OperConNumber,".",1)
		s OperConNumber2=$p(OperConNumber,".",2)
		s OperConNumber2 = $Extract(OperConNumber2,1) //截取小数点后第一位
		s OperConNumber=OperConNumber1_"."_OperConNumber2
		s termId = 0
		for
		{
			s termId = $o(^User.MKBTermI("BaseIndex",termBaseId,termId)) //中心词id
			q:termId=""
			s termProId = $o(^User.MKBTermPropertyI("DescIndex",termId," 手术编码",0)) //属性id
			s termProDetailId = $o(^User.MKBTermProDetailI("ProIdx",termProId,0)) //属性内容id
			continue:termProDetailId="" //跳过没有手术编码的中心词
			s termNum = $lg($g(^User.MKBTermProDetailD(termProDetailId)),3)
			if OperConNumber=termNum
			{
				if OperConStructFlag=1 //已结构化的
				{
					s termFlag=0 //中心词重复标志 0不重复
					s rowid=0		
					for
					{
						s rowid=$o(^User.MKBOperationContrastD(OpeConId,"MKBOperationResult",rowid)) //childsub
						q:rowid=""
						s MKBOpeConTermDr=$lg(^User.MKBOperationContrastD(OpeConId,"MKBOperationResult",rowid),4) //子表中的termDr
						if MKBOpeConTermDr=termId //已有中心词结构化
						{
							s termFlag=1
							q
						}
					}
					if 'termFlag
					{
						;b ;1
						TS
						s UpdateStructObj = ##class(User.MKBOperationResult).%New(OpeConId)
						s sort=0 //结构化子表顺序
						if ($d(^User.MKBOperationResultI("SeqIndex")))
						{
							s sort=$o(^User.MKBOperationResultI("SeqIndex",OpeConId,""),-1) 
						}
						d UpdateStructObj.MKBOperationContrastSetObjectId(OpeConId) //对照表id
						d UpdateStructObj.MKBOperationConTermDrSetObjectId(termId) //中心词
						s UpdateStructObj.MKBOperationSequence=sort+1
						s result = UpdateStructObj.%Save()
						if $$$ISOK(result)
						{
							;b ;2
							TC
							d UpdateStructObj.%Close()
							s num=num+1
							//w UpdateStructObj.%Id(),!
						}
						else
						{
							TRO
							s result = "子表更新失败:"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(result)   //返回错误信息
							b
						}			
						q
					}
					
				}
				else //未结构化的
				{
					TS
					s UpdateOpeConObj = ##class(User.MKBOperationContrast).%OpenId(OpeConId)
					s UpdateOpeConObj.MKBOperationChildStructFlag = 1 //结构化标志置为1
					s sc = UpdateOpeConObj.%Save() 
					if $$$ISOK(sc)
					{
						TC
						d UpdateOpeConObj.%Close()
						TS
						s UpdateObj = ##class(User.MKBOperationResult).%New(OpeConId)
						s UpdateObj.MKBOperationSequence=1
						d UpdateObj.MKBOperationContrastSetObjectId(OpeConId) //对照表id
						d UpdateObj.MKBOperationConTermDrSetObjectId(termId) //中心词
						//s UpdateObj.MKBOperationConTermDr=termId
						s csc = UpdateObj.%Save()
						if $$$ISOK(csc)
						{
							TC
							d UpdateObj.%Close()
							s num=num+1
							//w UpdateOpeConObj.%Id(),!
						}
						else
						{
							TRO
							s result = "子表更新失败:"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(csc)   //返回错误信息
							b
						}				
					}
					else
					{
						TRO
						s result = "父表更新失败:"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)   //返回错误信息
						b
					}
					q
				}		
			}
		}
	}
	q "成功更新:"_num_"条各版本手术子表数据"
}

/// Creator:张云越
/// CreatDate:2019-12-20
/// Description:最优icd维护
/// Input: 对照表id和MKBOperationInitialICD(Y/N)
/// Return:success或false
/// Other:w ##class(web.DHCBL.MKB.MKBOperationContrast).InitialICDUpdate(45349,"Y")
ClassMethod InitialICDUpdate(rowid As %String, MKBICDInitialICD As %String) As %String
{
	if rowid=""
	{
		set result = "{success:'false',errorinfo:'rowid为空'}"
	}
	else
	{
		s obj=##class(User.MKBOperationContrast).%OpenId(rowid)        ;先备份再更新

		Set UpdateDate=$p($h,",",1)       //上传日期
    	Set UpdateUserDR=%session.Get("LOGON.USERID")   //上传人
		d obj.MKBOperationConUpdateUserSetObjectId(UpdateUserDR)
		s obj.MKBOperationConDate=UpdateDate
		s obj.MKBOperationInitialICD=MKBICDInitialICD
		Ts
		s sc=obj.%Save()
		if $$$ISOK(sc)
		{
			Tc
			set id=obj.%Id()
			set result = "{success:'true',id:'"_id_"'}" 
			;d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_ICDContrast","User.MKBICDContrast","各版本ICD对照-最优ICD维护",id,Diag,"U",eobj,bobj)
			;d eobj.%Close()
			;d bobj.%Close()
		}
		else
		{
			Tro
			s result = "{success:'false',errorinfo:'保存失败!"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			
		}
		d obj.%Close()
		quit result			
	}
}

/// Creator:张云越
/// CreatDate:2019-12-21
/// Description：获取结构化数据和父表 最优ICD设置所需判断数据(目前就默认判断第一条结构化结果)
/// Input：id 父表id 
/// Return：空值 OR result_"*"_parid
/// Other: w ##class(web.DHCBL.MKB.MKBOperationContrast).GetDescAndParid(7498)
ClassMethod GetDescAndParid(id As %String)
{
	s MKBOpeConChild=0
	s seq=-1
	s seq=$O(^User.MKBOperationResultI("SeqIndex",id,seq))
	q:seq="" ""
	s MKBOpeConChild=$O(^User.MKBOperationResultI("SeqIndex",id,seq,MKBOpeConChild))
	q:MKBOpeConChild="" ""	
	s TermId=$LG($G(^User.MKBOperationContrastD(id,"MKBOperationResult",MKBOpeConChild)),4)
	s ResultId=$LG($G(^User.MKBOperationContrastD(id,"MKBOperationResult",MKBOpeConChild)),2) 
	s:ResultId="" ResultId=-100000000000000
	s sort(TermId,ResultId)=""
	s MKBOpeConId=0
	for //遍历手术对照表
	{
		s MKBOpeConId=$O(^User.MKBOperationResultI("SortIndex",TermId,ResultId,MKBOpeConId))
		q:MKBOpeConId=""
		s Child=0
		for
		{
			s Child=$O(^User.MKBOperationResultI("SortIndex",TermId,ResultId,MKBOpeConId,Child))
			q:Child=""
			s tseq=-1
			s tseq=$O(^User.MKBOperationResultI("SeqIndex",MKBOpeConId,tseq))
			s tMKBOpeConChild=$O(^User.MKBOperationResultI("SeqIndex",MKBOpeConId,tseq,0))
			continue:Child'=tMKBOpeConChild
			s:MKBOpeConId'=id arr(MKBOpeConId)=""	
		}
		
	}	

	s result=""
	s parid=0
	for
	{
		s parid=$O(arr(parid))
		q:parid=""

		s InitFlag=$LG($G(^User.MKBOperationContrastD(parid)),18)
		if (InitFlag="Y")
		{
			s MKBOperationConDesc=$LG($G(^User.MKBOperationContrastD(parid)),3) //描述
			s MKBOperationDiaSource=$lg($g(^User.MKBOperationContrastD(parid)),6) //数据来源
			s result = MKBOperationConDesc_"*"_parid_"*"_MKBOperationDiaSource
		}	
	}
	q result
}

/// Creator：张云越
/// CreatDate: 2019-12-20
/// Description：通过中心词和结构化结果id串、补充诊断查找相同中心词的，但属性不同的
/// Table：User.MKBOperationContrast User.MKBOperationResult
/// Input：ids:模板ID:属性值ID termdr 中心词指向  supplement 补充诊断 source 数据来源版本
/// Return：
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBICDContrast","GetNotSameIdsButSameItem","","15614","","526474")
Query GetNotSameIdsButSameItem(ids As %String, termdr As %String, supplement As %String, source As %String) As %Query(ROWSPEC = "Rowid,MKBOperationConDesc,MKBOperationConNumber,Result,MKBOperationInitialICD,MKBOperationConCode,MKBOperationConExtendNumber,MKBOperationDiaSource,MKBOperationConStatus,MKBOperationResultRelation,MKBOperationConType,MKBOperationConOption,MKBOperationConCenterWordID,MKBOperationRemark,MKBOperationConSegmentation,MKBOperationConDate,MKBOperationConUpdateUser,MKBTPDDesc,MKBOpeConCenterWord")
{
}

ClassMethod GetNotSameIdsButSameItemExecute(ByRef qHandle As %Binary, ids As %String, termdr As %String, supplement As %String, source As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if ids'=""
	{
		k Det
		for i=1:1:$l(ids,",")
		{
			s subPro=$p(ids,",",i)
			
			s Pro=$p(subPro,":",1)
			s Detail=$p(subPro,":",2)
			for j=1:1:$l(Detail,"*")
			{
				continue:Detail=""
				s Det(Pro,$p(Detail,"*",j))=""      //把传进来的ids通过属性和属性内容的形式保存到Det数组中
			}
		}
		s detNum=0
		s pro=0
		for
		{
			s pro=$o(Det(pro))
			q:pro=""
			s det=0
			for
			{
				s det=$o(Det(pro,det))
				q:det=""
				s detNum=detNum+1               //detNum记录属性内容的个数
			}
		}
	}
	s Rowid=0
	for
	{
		s Rowid=$o(^User.MKBOperationResultI("TermIndex",termdr,Rowid)) //相同中心词的各版本手术对照表记录
		q:Rowid=""
		s MKBOperationDiaSource=$lg($g(^User.MKBOperationContrastD(Rowid)),6) //来源标识
		continue:MKBOperationDiaSource'[source
		
		s MKBOpeConRRowid=0
		for
		{
			s MKBOpeConRRowid=$o(^User.MKBOperationResultI("TermIndex",termdr,Rowid,MKBOpeConRRowid)) //结构化子表childsub
			q:MKBOpeConRRowid=""
			
			s MKBOpeConTermDr=$lg($g(^User.MKBOperationContrastD(Rowid,"MKBOperationResult",MKBOpeConRRowid)),4)
			s MKBOpeConSupplement=$lg($g(^User.MKBOperationContrastD(Rowid,"MKBOperationResult",MKBOpeConRRowid)),5) //补充诊断
			s MKBOpeConResultID=$lg($g(^User.MKBOperationContrastD(Rowid,"MKBOperationResult",MKBOpeConRRowid)),2)

			s Result=..GetChiForNewSeqStrucIDs(MKBOpeConResultID,MKBOpeConTermDr)
			if Result["["
			{
				s result=$p(Result,"[",2)
				s result=$p(result,"]",1)
				s resultlen=$l(result,",")
				
			}
			if MKBOpeConSupplement'=""
			{
				s MKBOpeConSupplement=$zstrip(MKBOpeConSupplement,"<>W")
				if Result["]"
				{
					s str=$e(Result,1,*-1)
					s Result=str_",("_MKBOpeConSupplement_")]"
				}
				else
				{
					s Result=Result_"[("_MKBOpeConSupplement_")]"
				}
			}
			if ids'=""
			{
				s Existflag=0
				s NotExistflag=0
				continue:MKBOpeConResultID=""
				for m=1:1:$l(MKBOpeConResultID,",")
				{
					s subResPro=$p(MKBOpeConResultID,",",m)
					s ResPro=$p(subResPro,":",1)
					s ResDetail=$p(subResPro,":",2)
					for n=1:1:$l(ResDetail,"*")
					{
						s resD=$p(ResDetail,"*",n)
						if $d(Det(ResPro,resD))
						{
							s Existflag=Existflag+1
							continue
						}
						s NotExistflag=NotExistflag+1
					}
				}
				if (supplement="")&(MKBOpeConSupplement'="")
				{
					s NotExistflag=NotExistflag+1
				}
			
				if (Existflag=detNum)&(NotExistflag>0)&(MKBOpeConSupplement[supplement)
				{
					;b
					d PrintOut
					d OutputRowCmb
				}
			}
			else
			{
				if Result["["
				{
					d PrintOut
					d OutputRowCmb
				}
			}
		}
		
	}
	
	

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(Rowid,MKBOperationConDesc,MKBOperationConNumber,Result,MKBOperationInitialICD,MKBOperationConCode,MKBOperationConExtendNumber,MKBOperationDiaSource,MKBOperationConStatus,MKBOperationResultRelation,MKBOperationConType,MKBOperationConOption,MKBOperationConCenterWordID,MKBOperationRemark,MKBOperationConSegmentation,MKBOperationConDate,MKBOperationConUpdateUser,MKBTPDDesc,MKBOpeConCenterWord)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
PrintOut	
	s MKBOperationConCode=$lg($g(^User.MKBOperationContrastD(Rowid)),2) //手术诊断代码
	s MKBOperationConDesc=$lg($g(^User.MKBOperationContrastD(Rowid)),3) //手术描述
	s MKBOpeDescCaption=$zconvert(MKBOperationConDesc,"U")
	s MKBOperationInitialICD=$lg($g(^User.MKBOperationContrastD(Rowid)),18) //是否最优
	s MKBOperationConNumber=$lg($g(^User.MKBOperationContrastD(Rowid)),4) //手术主要编码
	s MKBOperationConStatus=$lg($g(^User.MKBOperationContrastD(Rowid)),13) //是否处理
	s MKBOperationResultRelation=$lg($g(^User.MKBOperationContrastD(Rowid)),19) //结构化结果关系
	s MKBOperationConExtendNumber=$lg($g(^User.MKBOperationContrastD(Rowid)),5) //扩展编码
	s MKBOperationConType=$lg($g(^User.MKBOperationContrastD(Rowid)),7) //类别
	s MKBOperationConOption=$lg($g(^User.MKBOperationContrastD(Rowid)),8) //录入选项
	s MKBOperationConCenterWordID=$lg($g(^User.MKBOperationContrastD(Rowid)),9) //参考中心词id
	s MKBOperationRemark=$lg($g(^User.MKBOperationContrastD(Rowid)),11) //标记(可匹配)
	s MKBOperationConSegmentation=$lg($g(^User.MKBOperationContrastD(Rowid)),12) //分词
	s MKBOperationConDate=$lg($g(^User.MKBOperationContrastD(Rowid)),14) //操作时间
	s MKBOperationConUpdateUser=$lg($g(^User.MKBOperationContrastD(Rowid)),15) //操作人
	s MKBOperationTermDr=$lg($g(^User.MKBOperationContrastD(Rowid)),10)
	
	if MKBOperationTermDr'=""
	{
		s MKBTPRowId = $O(^User.MKBTermPropertyI("DescIndex",MKBOperationTermDr," 中文释义",0))
		s MKBTPDDesc = $LG($G(^User.MKBTermProDetailD($O(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,0)))),3)
		s MKBTDesc=$lg($g(^User.MKBTermD(MKBOperationTermDr)),3)
	}
	else
	{
		s MKBTPDDesc="" //中文释义
		s MKBTDesc=""
	}
	
	
	s PINYINDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBOperationConDesc)
	s Sources=$lg($g(^User.MKBOperationContrastD(Rowid)),6) //数据来源
	s sourcelen=$l(Sources,"&")
	s MKBOperationDiaSource=""
	for i=1:1:sourcelen
	{
		s Source=$p(Sources,"&",i)
		continue:Source=""
		//s SourceString=$select(Source="A":"北京临床-ICD9手术分类临床版",Source="B":"国家标准版-ICD9字典库2011",Source="C":"国家临床1.1-手术操作分类代码",Source="D":"国家临床2.0-手术操作分类代码")
		s SourceString=$Lg($g(^User.MKBTermD(Source)),3)
		s:MKBOperationDiaSource'="" MKBOperationDiaSource=MKBOperationDiaSource_"&"_SourceString
		s:MKBOperationDiaSource="" MKBOperationDiaSource=SourceString
	}
	
	s MKBOpeConCenterWord=""                         ;通过中心词id获取参考中心词描述
	if MKBOperationConCenterWordID'=""
	{
		s WordCount=$l(MKBOperationConCenterWordID,",")
		for i=1:1:WordCount
		{
			s WordEach=$p(MKBOperationConCenterWordID,",",i)
			s MKBOpeConWord=$lg($g(^User.MKBTermD(WordEach)),3) 
			s:MKBOpeConCenterWord'="" MKBOpeConCenterWord=MKBOpeConCenterWord_","_MKBOpeConWord
			s:MKBOpeConCenterWord="" MKBOpeConCenterWord=MKBOpeConWord
		}	
	}
}

ClassMethod GetNotSameIdsButSameItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetNotSameIdsButSameItemExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetNotSameIdsButSameItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetNotSameIdsButSameItemExecute ]
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

/// Creator:张云越
/// CreatDate:2019-12-20
/// Description：根据父表id，获取父表和结构化结果子表信息(跳转获取数据方法)
/// Table：User.MKBOperationResult
/// Input：父表id 
/// Return：子表信息串
/// Other: w ##class(web.DHCBL.MKB.MKBOperationContrast).GetRowData(1)
ClassMethod GetRowData(id As %String)
{
	q:id="" ""
	s MKBOpeConRowid=$g(id)
	s MKBOperationConDesc=$lg($g(^User.MKBOperationContrastD(MKBOpeConRowid)),3) //手术描述	
	s MKBOperationConNumber=$lg($g(^User.MKBOperationContrastD(MKBOpeConRowid)),4) //手术主要编码	
	s sequence=$o(^User.MKBOperationResultI("SeqIndex",MKBOpeConRowid,0))
	if sequence'=""
	{
		s MKBOpeConRRowid=$o(^User.MKBOperationResultI("SeqIndex",MKBOpeConRowid,sequence,0)) //结构化子表childsub
		if MKBOpeConRRowid'=""
		{
			s MKBOpeConResultID=$lg($g(^User.MKBOperationContrastD(MKBOpeConRowid,"MKBOperationResult",MKBOpeConRRowid)),2)  //获取结构化结果串
			s MKBOpeConTermDr=$lg($g(^User.MKBOperationContrastD(MKBOpeConRowid,"MKBOperationResult",MKBOpeConRRowid)),4) //获取结构化结果Termdr
			
			s Result=##class(web.DHCBL.MKB.MKBStructuredData).StdGetChiForNewSeqStrucIDs(MKBOpeConResultID,MKBOpeConTermDr)
			s MKBOpeConSupplement=$lg(^User.MKBOperationContrastD(MKBOpeConRowid,"MKBOperationResult",MKBOpeConRRowid),5)
			if MKBOpeConSupplement'=""
			{
				if Result["]"
				{
					s str=$e(Result,1,*-1)
					s Result=str_",("_MKBOpeConSupplement_")]"
				}
				else
				{
					s Result=Result_"[("_MKBOpeConSupplement_")]"
				}
			}					
		}
		else
		{
			s MKBOpeConResultID=""
			s MKBOpeConTermDr=""
			s MKBOpeConSupplement=""
			s Result=""
		}
	}
	else
	{
		s MKBOpeConResultID=""
		s MKBOpeConTermDr=""
		s MKBOpeConSupplement=""
		s Result=""
	}
	s thisStr="{""MKBOpeConRowid"":"""_MKBOpeConRowid_""",""MKBOperationConDesc"":"""_MKBOperationConDesc_""",""MKBOperationConNumber"":"""_MKBOperationConNumber_""",""Result"":"""_Result_""",""MKBOpeConResultID"":"""_MKBOpeConResultID_""",""MKBOpeConTermDr"":"""_MKBOpeConTermDr_""",""MKBOpeConSupplement"":"""_MKBOpeConSupplement_"""}"
	q thisStr
}

/// Creator：张云越
/// CreatDate: 2019-12-20
/// Description：通过结构化结果ID串和termdr找相同的诊断(版本控制)
/// Table：User.MKBOperationContrast User.MKBOperationResult
/// Input：ids:模板ID:属性值ID termdr 中心词指向  supplement 补充诊断 source 数据来源版本
/// Return：
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBOperationContrast","GetSameStructResult","",15614,"","526474")
Query GetSameStructResult(ids As %String, termdr As %String, supplement As %String, source As %String) As %Query(ROWSPEC = "Rowid,MKBOperationConDesc,MKBOperationConNumber,Result,MKBOperationInitialICD,MKBOperationConCode,MKBOperationConExtendNumber,MKBOperationDiaSource,MKBOperationConStatus,MKBOperationResultRelation,MKBOperationConType,MKBOperationConOption,MKBOperationConCenterWordID,MKBOperationRemark,MKBOperationConSegmentation,MKBOperationConDate,MKBOperationConUpdateUser,MKBTPDDesc,MKBOpeConCenterWord")
{
}

ClassMethod GetSameStructResultExecute(ByRef qHandle As %Binary, ids As %String, termdr As %String, supplement As %String, source As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s Result=..GetChiForNewSeqStrucIDs(ids,termdr)
	if supplement'=""
	{
		s supplement=$zstrip(supplement,"<>W")
		if Result["]"
		{
			s str=$e(Result,1,*-1)
			s Result=str_",("_supplement_")]"
		}
		else
		{
			s Result=Result_"[("_supplement_")]"
		}
	}
	s Rowid=0
	for
	{
		s Rowid=$o(^User.MKBOperationResultI("TermIndex",termdr,Rowid)) //相同中心词的各版本手术对照表记录
		q:Rowid=""
		s MKBOperationDiaSource=$lg($g(^User.MKBOperationContrastD(Rowid)),6) //来源标识
		continue:MKBOperationDiaSource'[source
		d PrintOut
		s MKBOpeConRRowid=0
		for
		{
			s MKBOpeConRRowid=$o(^User.MKBOperationResultI("TermIndex",termdr,Rowid,MKBOpeConRRowid)) //结构化子表childsub
			q:MKBOpeConRRowid=""
			
			s MKBOpeConTermDr=$lg($g(^User.MKBOperationContrastD(Rowid,"MKBOperationResult",MKBOpeConRRowid)),4)
			s MKBOpeConSupplement=$lg($g(^User.MKBOperationContrastD(Rowid,"MKBOperationResult",MKBOpeConRRowid)),5) //补充诊断
			s MKBOpeConResultID=$lg($g(^User.MKBOperationContrastD(Rowid,"MKBOperationResult",MKBOpeConRRowid)),2)
			
			s MKBOpeStructResult=..GetChiForNewSeqStrucIDs(MKBOpeConResultID,MKBOpeConTermDr) //结构化描述串
			if MKBOpeConSupplement'=""
			{
				s MKBOpeConSupplement=$zstrip(MKBOpeConSupplement,"<>W")
				if MKBOpeConSupplement["]"
				{
					s str=$e(MKBOpeConSupplement,1,*-1)
					s MKBOpeStructResult=str_",("_MKBOpeConSupplement_")]"
				}
				else
				{
					s MKBOpeStructResult=MKBOpeStructResult_"[("_MKBOpeConSupplement_")]"
				}
			}
			if MKBOpeStructResult=Result
			{
				d OutputRowCmb
			}
		}
	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK 

OutputRowCmb

    set Data=$lb(Rowid,MKBOperationConDesc,MKBOperationConNumber,Result,MKBOperationInitialICD,MKBOperationConCode,MKBOperationConExtendNumber,MKBOperationDiaSource,MKBOperationConStatus,MKBOperationResultRelation,MKBOperationConType,MKBOperationConOption,MKBOperationConCenterWordID,MKBOperationRemark,MKBOperationConSegmentation,MKBOperationConDate,MKBOperationConUpdateUser,MKBTPDDesc,MKBOpeConCenterWord)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
   
PrintOut
	s MKBOperationConCode=$lg($g(^User.MKBOperationContrastD(Rowid)),2) //手术诊断代码
	s MKBOperationConDesc=$lg($g(^User.MKBOperationContrastD(Rowid)),3) //手术描述
	s MKBOpeDescCaption=$zconvert(MKBOperationConDesc,"U")
	s MKBOperationInitialICD=$lg($g(^User.MKBOperationContrastD(Rowid)),18) //是否最优
	s MKBOperationConNumber=$lg($g(^User.MKBOperationContrastD(Rowid)),4) //手术主要编码
	s MKBOperationConStatus=$lg($g(^User.MKBOperationContrastD(Rowid)),13) //是否处理
	s MKBOperationResultRelation=$lg($g(^User.MKBOperationContrastD(Rowid)),19) //结构化结果关系
	s MKBOperationConExtendNumber=$lg($g(^User.MKBOperationContrastD(Rowid)),5) //扩展编码
	s MKBOperationConType=$lg($g(^User.MKBOperationContrastD(Rowid)),7) //类别
	s MKBOperationConOption=$lg($g(^User.MKBOperationContrastD(Rowid)),8) //录入选项
	s MKBOperationConCenterWordID=$lg($g(^User.MKBOperationContrastD(Rowid)),9) //参考中心词id
	s MKBOperationRemark=$lg($g(^User.MKBOperationContrastD(Rowid)),11) //标记(可匹配)
	s MKBOperationConSegmentation=$lg($g(^User.MKBOperationContrastD(Rowid)),12) //分词
	s MKBOperationConDate=$lg($g(^User.MKBOperationContrastD(Rowid)),14) //操作时间
	s MKBOperationConUpdateUser=$lg($g(^User.MKBOperationContrastD(Rowid)),15) //操作人	
	s MKBOperationTermDr=$lg($g(^User.MKBOperationContrastD(Rowid)),10) 
	
	if MKBOperationTermDr'=""
	{
		s MKBTPRowId = $O(^User.MKBTermPropertyI("DescIndex",MKBOperationTermDr," 中文释义",0))
		s MKBTPDDesc = $LG($G(^User.MKBTermProDetailD($O(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,0)))),3)
		s MKBTDesc=$lg($g(^User.MKBTermD(MKBOperationTermDr)),3)
	}
	else
	{
		s MKBTPDDesc="" //中文释义
		s MKBTDesc=""
	}
	
	
	s PINYINDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBOperationConDesc)
	s Sources=$lg($g(^User.MKBOperationContrastD(Rowid)),6) //数据来源
	s sourcelen=$l(Sources,"&")
	s MKBOperationDiaSource=""
	for i=1:1:sourcelen
	{
		s Source=$p(Sources,"&",i)
		continue:Source=""
		//s SourceString=$select(Source="A":"北京临床-ICD9手术分类临床版",Source="B":"国家标准版-ICD9字典库2011",Source="C":"国家临床1.1-手术操作分类代码",Source="D":"国家临床2.0-手术操作分类代码")
		s SourceString=$Lg($g(^User.MKBTermD(Source)),3)
		s:MKBOperationDiaSource'="" MKBOperationDiaSource=MKBOperationDiaSource_"&"_SourceString
		s:MKBOperationDiaSource="" MKBOperationDiaSource=SourceString
	}
	
	s MKBOpeConCenterWord=""                         ;通过中心词id获取参考中心词描述
	if MKBOperationConCenterWordID'=""
	{
		s WordCount=$l(MKBOperationConCenterWordID,",")
		for i=1:1:WordCount
		{
			s WordEach=$p(MKBOperationConCenterWordID,",",i)
			s MKBOpeConWord=$lg($g(^User.MKBTermD(WordEach)),3) 
			s:MKBOpeConCenterWord'="" MKBOpeConCenterWord=MKBOpeConCenterWord_","_MKBOpeConWord
			s:MKBOpeConCenterWord="" MKBOpeConCenterWord=MKBOpeConWord
		}	
	}
}

ClassMethod GetSameStructResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSameStructResultExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetSameStructResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSameStructResultExecute ]
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

/// Creator:张云越
/// CreatDate:2019-10-26
/// Description:获取治疗手术的数据
/// Table：User.MKBTerm
/// Input：rowid-诊断术语ID,base-术语库注册父表的ID,desc-根据描述、常用名及拼音码查询，rows-每页显示行数 page-第几页
/// return:Json数据
/// d ##class(web.DHCBL.MKB.MKBOperationContrast).GetTermListForDoc(rowid,base, desc, rows, page)
/// d ##class(web.DHCBL.MKB.MKBOperationContrast).GetTermListForDoc("",20,"fj",8,1)
ClassMethod GetTermListForDoc(rowid As %String, base As %String, desc As %String, rows As %String, page As %String) As %String
{
	
	s result="",total=0,jsonstr=""	
	
	if (base="")
	{
		w "{""rows"":[], ""total"":0}"    //术语库注册id为空
		q
	}
	
	w "{""rows"":["
	if (rowid'="") //根据rowid返回该条记录
	{
		s total=1
		s MKBTRowId=rowid
		s MKBTCode=$listGet($g(^User.MKBTermD(MKBTRowId)),2)  
		s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTRowId)),3)  //描述			
		s MKBTPYCode=$listGet($g(^User.MKBTermD(MKBTRowId)),6)  //检索码
		s MKBTPYCode= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTPYCode) 
		s MKBTNote=$listGet($g(^User.MKBTermD(MKBTRowId)),7)  
		s MKBTNote= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTNote)
		s MKBTNote = ##class(web.BDP.util.String).Replace(MKBTNote,"<br/>","")
		s strComAndAlisa=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(MKBTRowId)
		s strCom=$p(strComAndAlisa,"[A]",1)
		s comDesc=$p(strCom,"&%",1) //常用名
		s comKey=$p(strCom,"&%",2)	//常用名拼音码	
		s:comDesc="" comDesc=MKBTDesc
		s MKBTDesc=	comDesc_"("_MKBTDesc_")"
		s MKBTDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTDesc)
		s mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""comDesc"":"""_comDesc_""",""comKey"":"""_comKey_""",""MKBTNote"":"""_MKBTNote_"""}"
		w mainstr
	}
	else
	{
		s endpage=page*rows  //结束行
		s stpage=((page-1)*rows)+1 //开始行

		s:desc'="" desc=$ZCONVERT(desc,"U")
		if ($d(^User.MKBTermI("BaseIndex",base)))  //该术语库下有数据
		{									
			//遍历术语表，输出数据
			s MKBTRowId=""
			for  
			{	
				s MKBTRowId=$o(^User.MKBTermI("BaseIndex",base,MKBTRowId),-1) q:MKBTRowId="" 
				
				//封闭的数据不显示
				s MKBTActiveFlag=$listGet($g(^User.MKBTermD(MKBTRowId)),9)
				continue:MKBTActiveFlag="N"  //判断是否显示封闭数据
				s MKBTCode=$listGet($g(^User.MKBTermD(MKBTRowId)),2)  
				s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTRowId)),3)  //描述
				s MKBTPYCode=$listGet($g(^User.MKBTermD(MKBTRowId)),6)  //检索码
				s MKBTPYCode= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTPYCode) 
				s MKBTNote=$listGet($g(^User.MKBTermD(MKBTRowId)),7)  
				s MKBTNote= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTNote)
				s MKBTNote = ##class(web.BDP.util.String).Replace(MKBTNote,"<br/>","")
				s strComAndAlisa=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(MKBTRowId)  //常用名别名及拼音码
				s strCom=$p(strComAndAlisa,"[A]",1)   //常用名及拼音码
				s strAlias=$p(strComAndAlisa,"[A]",2) //别名及拼音码
				s comDesc=$p(strCom,"&%",1) //常用名
				s comKey=$p(strCom,"&%",2)	//常用名拼音码	
				s:comDesc="" comDesc=MKBTDesc
				s MKBTDesc=	comDesc_"("_MKBTDesc_")"
				s MKBTDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTDesc)	
				
				i (($ZCONVERT(MKBTDesc,"U")[desc)||($ZCONVERT(MKBTPYCode,"U")[desc)||($ZCONVERT(comDesc,"U")[desc)||($ZCONVERT(comKey,"U")[desc)||($ZCONVERT(strAlias,"U")[desc))   //条件
				{
					s total=total+1
				    if (total<stpage) continue
				    if (total<=endpage)
				    {
					    s mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""comDesc"":"""_comDesc_""",""comKey"":"""_comKey_""",""MKBTNote"":"""_MKBTNote_"""}"
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
	}

	w "], ""total"":"_total_"}"
		

	q ""
}

/// Creator:张云越
/// CreatDate:2019-10-23
/// Description:获取各版本数据
/// Table:User.MKBOperationContrast
/// Input:icd(手术编码) ope(手术描述) sdesc(结构化结果) status(处理状态) match(匹配度) sort(排序方式0为手术编码排序) source(编码来源) rows(行数) page(页数)
/// Return:查询数据
/// Other:d ##class(web.DHCBL.MKB.MKBOperationContrast).GetNewList("","结膜刮片检查术","","","A","0","2025614","20","1")
ClassMethod GetNewList(icd As %String, ope As %String, sdesc As %String, status As %String, match As %String, sort As %String, source As %String, rows As %String, page As %String)
{
	
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	
	s:ope'="" ope=$ZCONVERT(ope,"U") //转换成大写
	s:ope'="" ope=$zstrip(ope,"<>W")
	s:sdesc'="" sdesc=$ZCONVERT(sdesc,"U") //转换成大写
	s:sdesc'="" sdesc=$zstrip(sdesc,"<>W")
	s:icd'="" icd=$ZCONVERT(icd,"U")    //转换成大写
	s:icd'="" icd=$zstrip(icd,"<>W")
	s:status'="" status=$ZCONVERT(status,"U")  //转换成大写
	s User=%session.Get("LOGON.USERID")
	//s User=1
	k Sort(User)
	/*if source'=""
	{
		s SourceOriginal=$select(source="A":"北京临床-ICD9手术分类临床版",source="B":"国家标准版-ICD9字典库2011",source="C":"国家临床1.1-手术操作分类代码",source="D":"国家临床2.0-手术操作分类代码")
	}
	s:source="" SourceOriginal=""*/
	s total=0
	s jsonstr=""
	w "{""rows"":["
	if ((icd'="")||(ope'="")||(sdesc'=""))
	{
		if match="D"    //未匹配结构化诊断
		{
			s MKBICDRowid=0
			for
			{
				//s:ope'=""&icd="" MKBICDRowid=$o(^User.MKBOperationContrastI("DescIndex"," "_ope),MKBICDRowid)
				//s:icd'=""&ope="" MKBICDRowid=$o(^User.MKBOperationContrastI("NumberIndex"," "_icd),MKBICDRowid)
				//s:ope'=""&icd'="" MKBICDRowid=$o(^User.MKBOperationContrastI("DescIndex"," "_ope),MKBICDRowid)
				//s MKBICDRowid=$o(^User.MKBOperationContrastD(MKBICDRowid))
				s MKBICDRowid=$o(^User.MKBOperationContrastI("StructIndex",-100000000000000,MKBICDRowid))
				q:MKBICDRowid=""
				//continue:$d(^User.MKBOperationContrastI("StructIndex",-100000000000000,MKBICDRowid))
				continue:'$d(^User.MKBOperationContrastD(MKBICDRowid))
				s MKBOperationConCode=$lg($g(^User.MKBOperationContrastD(MKBICDRowid)),2)
				s MKBOperationConDesc=$lg($g(^User.MKBOperationContrastD(MKBICDRowid)),3)
				s MKBOpeDescCaption=$zconvert(MKBOperationConDesc,"U")
				s MKBOperationConNumber=$lg($g(^User.MKBOperationContrastD(MKBICDRowid)),4)
				if MKBOperationConNumber=""
				{
					s Number="zzzzz"
				}
				else
				{
					s Number=MKBOperationConNumber
				}
				s MKBOperationConStatus=$lg($g(^User.MKBOperationContrastD(MKBICDRowid)),13)
				s PINYINDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBOperationConDesc)
				s Sources=$lg($g(^User.MKBOperationContrastD(MKBICDRowid)),6)
				/*s sourcelen=$l(Sources,"&")
				s MKBOperationDiaSource=""
				for i=1:1:sourcelen
				{
					s Source=$p(Sources,"&",i)
					continue:Source=""
					s SourceString=$select(Source="A":"北京临床-ICD9手术分类临床版",Source="B":"国家标准版-ICD9字典库2011",Source="C":"国家临床1.1-手术操作分类代码",Source="D":"国家临床2.0-手术操作分类代码")
					s:MKBOperationDiaSource'="" MKBOperationDiaSource=MKBOperationDiaSource_"&"_SourceString
					s:MKBOperationDiaSource="" MKBOperationDiaSource=SourceString
				}  */
				if (MKBOperationConNumber[icd)&((MKBOperationConDesc[ope)||(PINYINDesc[ope))&(MKBOperationConStatus[status)&(Sources[source)
				{
					s (MKBTPDDesc,MKBTDesc,PINYINOpe)=""
					if sort=0    //按手术编码排序
					{
						s Sort(User,"ICDNumber","a"_Number,MKBICDRowid)=""
					}
					else       //按icd描述排序
					{
						s Sort(User,"ICDDesc",MKBOperationConDesc,MKBICDRowid)=""
					}
				}
			}
			s way=sort
			d ..PrintOut(.Sort,User,.total,way,stpage,endpage)
		}
		elseif match="B"    //已匹配结构化诊断
		{
			s MKBICDRowid=0
			for
			{
				//s MKBICDRowid=$o(^User.MKBOperationContrastD(MKBICDRowid))
				s MKBICDRowid=$o(^User.MKBOperationContrastI("StructIndex",1,MKBICDRowid)) //手术对照表id
				q:MKBICDRowid=""
				//continue:$d(^User.MKBOperationContrastI("StructIndex",1,MKBICDRowid))
				continue:'$d(^User.MKBOperationContrastD(MKBICDRowid))
				s MKBOperationConCode=$lg($g(^User.MKBOperationContrastD(MKBICDRowid)),2)
				s MKBOperationConDesc=$lg($g(^User.MKBOperationContrastD(MKBICDRowid)),3)
				s MKBOpeDescCaption=$zconvert(MKBOperationConDesc,"U")
				s MKBOperationConNumber=$lg($g(^User.MKBOperationContrastD(MKBICDRowid)),4)
				if MKBOperationConNumber=""
				{
					s Number="zzzzz"
				}
				else
				{
					s Number=MKBOperationConNumber
				}
				s MKBOperationConStatus=$lg($g(^User.MKBOperationContrastD(MKBICDRowid)),13)
				s PINYINDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBOperationConDesc)
				//2019-11-27新增
				s Result=..GetSDResult(MKBICDRowid) 
				s PINYINResult=##class(web.DHCBL.BDP.FunLib).GetPYCODE(Result)
				s Result=$zconvert(Result,"U")
				
				s Sources=$lg($g(^User.MKBOperationContrastD(MKBICDRowid)),6)
				/*s sourcelen=$l(Sources,"&")
				s MKBOperationDiaSource=""
				for i=1:1:sourcelen
				{
					s Source=$p(Sources,"&",i)
					continue:Source=""
					s SourceString=$select(Source="A":"北京临床-ICD9手术分类临床版",Source="B":"国家标准版-ICD9字典库2011",Source="C":"国家临床1.1-手术操作分类代码",Source="D":"国家临床2.0-手术操作分类代码")
					s:MKBOperationDiaSource'="" MKBOperationDiaSource=MKBOperationDiaSource_"&"_SourceString
					s:MKBOperationDiaSource="" MKBOperationDiaSource=SourceString
				}   */
				if (MKBOperationConNumber[icd)&((MKBOperationConDesc[ope)||(PINYINDesc[ope))&((Result[sdesc)||(PINYINResult[sdesc))&(MKBOperationConStatus[status)&(Sources[source)
				{
					s (MKBTPDDesc,MKBTDesc,PINYINOpe)=""
					if sort=0    //按手术编码排序
					{
						s Sort(User,"ICDNumber","a"_Number,MKBICDRowid)=""
					}
					else       //按icd描述排序
					{
						s Sort(User,"ICDDesc",MKBOperationConDesc,MKBICDRowid)=""
					}
				}
			}
			s way=sort
			d ..PrintOut(.Sort,User,.total,way,stpage,endpage)
		}
		else
		{
			s sum=0
			s MKBICDRowid=0
			
			for
			{
				s MKBICDRowid=$o(^User.MKBOperationContrastD(MKBICDRowid))
				q:MKBICDRowid=""
				continue:'$d(^User.MKBOperationContrastD(MKBICDRowid))
				s MKBOperationConCode=$lg($g(^User.MKBOperationContrastD(MKBICDRowid)),2)
				s MKBOperationConDesc=$lg($g(^User.MKBOperationContrastD(MKBICDRowid)),3)
				s MKBOpeDescCaption=$zconvert(MKBOperationConDesc,"U")
				s MKBOperationConNumber=$lg($g(^User.MKBOperationContrastD(MKBICDRowid)),4)
				if MKBOperationConNumber=""
				{
					s Number="zzzzz"
				}
				else
				{
					s Number=MKBOperationConNumber
				}
				s MKBOperationConStatus=$lg($g(^User.MKBOperationContrastD(MKBICDRowid)),13)
				s PINYINDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBOperationConDesc)
				//2019-11-27新增
				s Result=..GetSDResult(MKBICDRowid) 
				s PINYINResult=##class(web.DHCBL.BDP.FunLib).GetPYCODE(Result)
				s Result=$zconvert(Result,"U")
				
				s Sources=$lg($g(^User.MKBOperationContrastD(MKBICDRowid)),6)
				/*s sourcelen=$l(Sources,"&")
				s MKBOperationDiaSource=""
				for i=1:1:sourcelen
				{
					s Source=$p(Sources,"&",i)
					continue:Source=""
					s SourceString=$select(Source="A":"北京临床-ICD9手术分类临床版",Source="B":"国家标准版-ICD9字典库2011",Source="C":"国家临床1.1-手术操作分类代码",Source="D":"国家临床2.0-手术操作分类代码")
					s:MKBOperationDiaSource'="" MKBOperationDiaSource=MKBOperationDiaSource_"&"_SourceString
					s:MKBOperationDiaSource="" MKBOperationDiaSource=SourceString
				}   */
				if (MKBOperationConNumber[icd)&((MKBOperationConDesc[ope)||(PINYINDesc[ope))&((Result[sdesc)||(PINYINResult[sdesc))&(MKBOperationConStatus[status)&(Sources[source)
				{
					s (MKBTPDDesc,MKBTDesc,PINYINOpe)=""
					if sort=0    //按手术编码排序
					{
						s Sort(User,"ICDNumber","a"_Number,MKBICDRowid)=""
					}
					else       //按icd描述排序
					{
						s Sort(User,"ICDDesc",MKBOperationConDesc,MKBICDRowid)=""
					}
				}
			}
			s way=sort
			w ..PrintOut(.Sort,User,.total,way,stpage,endpage)
		}
	}
	else           //icd编码和ICD描述和结构化结果为空时候
	{
		if match="B"          //已匹配结构化诊断
		{
			s MKBICDRowid=0
			for
			{
				s MKBICDRowid=$o(^User.MKBOperationContrastI("StructIndex",1,MKBICDRowid))
				q:MKBICDRowid=""
				s Sources=$lg($g(^User.MKBOperationContrastD(MKBICDRowid)),6)
				s MKBOperationConDesc=$lg($g(^User.MKBOperationContrastD(MKBICDRowid)),3)
				s MKBOpeDescCaption=$zconvert(MKBOperationConDesc,"U")
				s MKBOperationConNumber=$lg($g(^User.MKBOperationContrastD(MKBICDRowid)),4)
				if MKBOperationConNumber=""
				{
					s Number="zzzzz"
				}
				else
				{
					s Number=MKBOperationConNumber
				}
				/*s sourcelen=$l(Sources,"&")
				s MKBOperationDiaSource=""
				for i=1:1:sourcelen
				{
					s Source=$p(Sources,"&",i)
					continue:Source=""
					s SourceString=$select(Source="A":"北京临床-ICD9手术分类临床版",Source="B":"国家标准版-ICD9字典库2011",Source="C":"国家临床1.1-手术操作分类代码",Source="D":"国家临床2.0-手术操作分类代码")
					s:MKBOperationDiaSource'="" MKBOperationDiaSource=MKBOperationDiaSource_"&"_SourceString
					s:MKBOperationDiaSource="" MKBOperationDiaSource=SourceString
				}*/
				s MKBOperationConStatus=$lg($g(^User.MKBOperationContrastD(MKBICDRowid)),13)
				if (MKBOperationConStatus[status)&(Sources[source) //&(MKBOperationDiaSource[SourceOriginal) 
				{
					s (MKBTPDDesc,MKBTDesc,PINYINOpe)=""
					if sort=0    //按手术编码排序
					{
						s Sort(User,"ICDNumber","a"_Number,MKBICDRowid)=""
					}
					else       //按icd描述排序
					{
						s Sort(User,"ICDDesc",MKBOperationConDesc,MKBICDRowid)=""
					}
				}
			}
			s way=sort
			w ..PrintOut(.Sort,User,.total,way,stpage,endpage)
			
		}
		elseif match="D"         //未匹配结构化诊断
		{
			s MKBICDRowid=0
			for
			{
				s MKBICDRowid=$o(^User.MKBOperationContrastI("StructIndex",-100000000000000,MKBICDRowid))
				q:MKBICDRowid=""
				s Sources=$lg($g(^User.MKBOperationContrastD(MKBICDRowid)),6)
				s MKBOperationConDesc=$lg($g(^User.MKBOperationContrastD(MKBICDRowid)),3)
				s MKBOpeDescCaption=$zconvert(MKBOperationConDesc,"U")
				s MKBOperationConNumber=$lg($g(^User.MKBOperationContrastD(MKBICDRowid)),4)
				if MKBOperationConNumber=""
				{
					s Number="zzzzz"
				}
				else
				{
					s Number=MKBOperationConNumber
				}
				/*s Sources=$lg($g(^User.MKBOperationContrastD(MKBICDRowid)),6)
				s sourcelen=$l(Sources,"&")
				s MKBOperationDiaSource=""
				for i=1:1:sourcelen
				{
					s Source=$p(Sources,"&",i)
					continue:Source=""
					s SourceString=$select(Source="A":"北京临床-ICD9手术分类临床版",Source="B":"国家标准版-ICD9字典库2011",Source="C":"国家临床1.1-手术操作分类代码",Source="D":"国家临床2.0-手术操作分类代码")
					s:MKBOperationDiaSource'="" MKBOperationDiaSource=MKBOperationDiaSource_"&"_SourceString
					s:MKBOperationDiaSource="" MKBOperationDiaSource=SourceString
				}*/
				s MKBOperationConStatus=$lg($g(^User.MKBOperationContrastD(MKBICDRowid)),13)
				if (MKBOperationConStatus[status)&(Sources[source) //&(MKBOperationDiaSource[SourceOriginal) 
				{
					s (MKBTPDDesc,MKBTDesc,PINYINOpe)=""
					if sort=0    //按手术编码排序
					{
						s Sort(User,"ICDNumber","a"_Number,MKBICDRowid)=""
					}
					else       //按icd描述排序
					{
						s Sort(User,"ICDDesc",MKBOperationConDesc,MKBICDRowid)=""
					}
				}
			}
			s way=sort
			w ..PrintOut(.Sort,User,.total,way,stpage,endpage)
		}
		else
		{
			s MKBICDRowid=0
			for
			{
				s MKBICDRowid=$o(^User.MKBOperationContrastD(MKBICDRowid))
				q:MKBICDRowid=""
				s Sources=$lg($g(^User.MKBOperationContrastD(MKBICDRowid)),6)
				s MKBOperationConDesc=$lg($g(^User.MKBOperationContrastD(MKBICDRowid)),3)
				s MKBOpeDescCaption=$zconvert(MKBOperationConDesc,"U")
				s MKBOperationConNumber=$lg($g(^User.MKBOperationContrastD(MKBICDRowid)),4)
				if MKBOperationConNumber=""
				{
					s Number="zzzzz"
				}
				else
				{
					s Number=MKBOperationConNumber
				}
				/*s sourcelen=$l(Sources,"&")
				s MKBOperationDiaSource=""
				for i=1:1:sourcelen
				{
					s Source=$p(Sources,"&",i)
					continue:Source=""
					s SourceString=$select(Source="A":"北京临床-ICD9手术分类临床版",Source="B":"国家标准版-ICD9字典库2011",Source="C":"国家临床1.1-手术操作分类代码",Source="D":"国家临床2.0-手术操作分类代码")
					s:MKBOperationDiaSource'="" MKBOperationDiaSource=MKBOperationDiaSource_"&"_SourceString
					s:MKBOperationDiaSource="" MKBOperationDiaSource=SourceString
				}*/
				s MKBOperationConStatus=$lg($g(^User.MKBOperationContrastD(MKBICDRowid)),13)
				
				if (MKBOperationConStatus[status)&(Sources[source) //&(MKBOperationDiaSource[SourceOriginal) 
				{
					s (MKBTPDDesc,MKBTDesc,PINYINOpe)=""
					if sort=0    //按手术编码排序
					{
						s Sort(User,"ICDNumber","a"_Number,MKBICDRowid)=""
					}
					else       //按icd描述排序
					{
						s Sort(User,"ICDDesc",MKBOperationConDesc,MKBICDRowid)=""
					}
				}
			}
			s way=sort
			w ..PrintOut(.Sort,User,.total,way,stpage,endpage)
		}
	}
	w "], ""total"":"_total_"}"
	b
	q ""
}

/// Creator:张云越
/// CreatDate:2019-11-27
/// Description：输出各版本手术数据到前台
/// Input：Sort排序列表 User用户 total行数 stpage开始页 endpage结束页 way排序方式(0是ICD排序)
/// Return:字符串
/// Other:w ##class(web.DHCBL.MKB.MKBOperationContrast).GetSDResult("7488")
ClassMethod PrintOut(ByRef Sort, User As %String, ByRef total, way As %String, stpage As %String, endpage As %String)
{
	s jsonstr=""
	s sort=way
	if sort=0   //icd编码排序
	{
		s Number=""
		for
		{
			s Number=$o(Sort(User,"ICDNumber",Number))
			q:Number=""

			s MKBICDRowid=0
			for
			{
				s MKBICDRowid=$o(Sort(User,"ICDNumber",Number,MKBICDRowid))
				q:MKBICDRowid=""
				s total=total+1
				if (total<stpage) continue
				if (total<=endpage)
				{
					d GetData
					d OutPut
				}
			}
		
		}
	}
	else
	{
		;s Sort(User,"ICDDesc",MKBOperationConDesc,MKBICDRowid)=""icd描述排序
		s MKBOperationConDesc=""
		for
		{
			s MKBOperationConDesc=$o(Sort(User,"ICDDesc",MKBOperationConDesc))
			q:MKBOperationConDesc=""
			s total=total+1
			if (total<stpage) continue
			if (total<=endpage)
			{
				s MKBICDRowid=0
				for
				{
					s MKBICDRowid=$o(Sort(User,"ICDDesc",MKBOperationConDesc,MKBICDRowid))
					q:MKBICDRowid=""
					d GetData
					d OutPut
				}
			}
		}
	}
	q ""
OutPut
	s thisStr=""
	
	s thisStr="{""Rowid"":"""_MKBICDRowid_""",""MKBOperationConCode"":"""_MKBOperationConCode_""",""MKBOperationConDesc"":"""_MKBOperationConDesc_""",""MKBOperationConNumber"":"""_MKBOperationConNumber_""",""MKBOperationConExtendNumber"":"""_MKBOperationConExtendNumber_""",""MKBOperationConCenterWordID"":"""_MKBOperationConCenterWordID_""",""MKBOperationConType"":"""_MKBOperationConType_""",""MKBOperationConOption"":"""_MKBOperationConOption_""",""MKBICDTermDr"":"""_MKBICDTermDr_""",""MKBTPDDesc"":"""_MKBTPDDesc_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBOperationRemark"":"""_MKBOperationRemark_""",""MKBOperationConSegmentation"":"""_MKBOperationConSegmentation_""",""MKBOperationConStatus"":"""_MKBOperationConStatus_""",""MKBOperationConDate"":"""_MKBOperationConDate_""",""MKBOperationConUpdateUser"":"""_MKBOperationConUpdateUser_""",""MKBOpeConCenterWord"":"""_MKBOpeConCenterWord_""",""MKBOperationInitialICD"":"""_MKBOperationInitialICD_""",""MKBOperationDiaSource"":"""_MKBOperationDiaSource_""",""Result"":"""_Result_""",""MKBOperationResultRelation"":"""_MKBOperationResultRelation_"""}"    

	if (jsonstr'="")
	{ 
		w ","
		s jsonstr=jsonstr_","_thisStr
	}
	else
	{
		s jsonstr=thisStr
	}
	w thisStr
GetData
	s MKBOperationConCode=$lg($g(^User.MKBOperationContrastD(MKBICDRowid)),2)
	s MKBOperationConDesc=$lg($g(^User.MKBOperationContrastD(MKBICDRowid)),3)
	s MKBOpeDescCaption=$zconvert(MKBOperationConDesc,"U")
	
	s MKBOperationConNumber=$lg($g(^User.MKBOperationContrastD(MKBICDRowid)),4)
	s MKBOperationConStatus=$lg($g(^User.MKBOperationContrastD(MKBICDRowid)),13)
	s MKBOperationResultRelation=$lg($g(^User.MKBOperationContrastD(MKBICDRowid)),19)
	s PINYINDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBOperationConDesc)
	s Sources=$lg($g(^User.MKBOperationContrastD(MKBICDRowid)),6)
	s sourcelen=$l(Sources,"&")
	s MKBOperationDiaSource=""
	for i=1:1:sourcelen
	{
		s Source=$p(Sources,"&",i)
		continue:Source=""
		//s SourceString=$select(Source="A":"北京临床-ICD9手术分类临床版",Source="B":"国家标准版-ICD9字典库2011",Source="C":"国家临床1.1-手术操作分类代码",Source="D":"国家临床2.0-手术操作分类代码")
		s SourceString=$Lg($g(^User.MKBTermD(Source)),3)
		s:MKBOperationDiaSource'="" MKBOperationDiaSource=MKBOperationDiaSource_"&"_SourceString
		s:MKBOperationDiaSource="" MKBOperationDiaSource=SourceString
	}
	s Result=""
	s sequence=0
	for
	{
		s sequence=$o(^User.MKBOperationResultI("SeqIndex",MKBICDRowid,sequence))
		q:sequence=""
		s MKBICDRRowid=0
		for
		{
			s MKBICDRRowid=$o(^User.MKBOperationResultI("SeqIndex",MKBICDRowid,sequence,MKBICDRRowid)) //结构化子表childsub
			q:MKBICDRRowid=""
			s MKBICDRResultID=$lg($g(^User.MKBOperationContrastD(MKBICDRowid,"MKBOperationResult",MKBICDRRowid)),2)  //获取结构化结果串
			s MKBICDResultTermdr=$lg($g(^User.MKBOperationContrastD(MKBICDRowid,"MKBOperationResult",MKBICDRRowid)),4) //获取结构化结果Termdr
			s SResult=..GetChiForNewSeqStrucIDs(MKBICDRResultID,MKBICDResultTermdr)
			s MKBICDSupplement=$lg(^User.MKBOperationContrastD(MKBICDRowid,"MKBOperationResult",MKBICDRRowid),5)
			if MKBICDSupplement'=""
			{
				if SResult["]"
				{
					s str=$e(Result,1,*-1)
					s SResult=str_",("_MKBICDSupplement_")]"
				}
				else
				{
					s SResult=SResult_"[("_MKBICDSupplement_")]"
				}
			}
			s:Result'="" Result=Result_"<br/>"_SResult
			s:Result="" Result=SResult
		}
	}

	s MKBOperationConExtendNumber=$lg($g(^User.MKBOperationContrastD(MKBICDRowid)),5)
	s MKBOperationConType=$lg($g(^User.MKBOperationContrastD(MKBICDRowid)),7)
	s MKBOperationConOption=$lg($g(^User.MKBOperationContrastD(MKBICDRowid)),8)
	s MKBOperationConCenterWordID=$lg($g(^User.MKBOperationContrastD(MKBICDRowid)),9)
	s MKBICDTermDr=$lg($g(^User.MKBOperationContrastD(MKBICDRowid)),10)
	if MKBICDTermDr'=""
	{
		s MKBTPRowId = $O(^User.MKBTermPropertyI("DescIndex",MKBICDTermDr," 中文释义",0))
		s MKBTPDDesc = $LG($G(^User.MKBTermProDetailD($O(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,0)))),3)
		s MKBTDesc=$lg($g(^User.MKBTermD(MKBICDTermDr)),3)
	}
	else
	{
		s MKBTPDDesc=""
		s MKBTDesc=""
	}
	s MKBOperationRemark=$lg($g(^User.MKBOperationContrastD(MKBICDRowid)),11)
	s MKBOperationConSegmentation=$lg($g(^User.MKBOperationContrastD(MKBICDRowid)),12)
	s MKBOperationConDate=$lg($g(^User.MKBOperationContrastD(MKBICDRowid)),14)
	s MKBOperationConUpdateUser=$lg($g(^User.MKBOperationContrastD(MKBICDRowid)),15)
	s MKBOperationInitialICD=$lg($g(^User.MKBOperationContrastD(MKBICDRowid)),18)
	s MKBOpeConCenterWord=""                         ;通过中心词id获取描述
	if MKBOperationConCenterWordID'=""
	{
		s WordCount=$l(MKBOperationConCenterWordID,",")
		for i=1:1:WordCount
		{
			s WordEach=$p(MKBOperationConCenterWordID,",",i)
			s MKBICDWord=$lg($g(^User.MKBTermD(WordEach)),3) 
			s:MKBOpeConCenterWord'="" MKBOpeConCenterWord=MKBOpeConCenterWord_","_MKBICDWord
			s:MKBOpeConCenterWord="" MKBOpeConCenterWord=MKBICDWord
		}	
	}
}

/// Creator:张云越
/// CreatDate:2019-11-27
/// Description：查询手术描述对应的结构化串
/// Input：id(各版本手术对照表id)
/// Return:字符串
/// Other:w ##class(web.DHCBL.MKB.MKBOperationContrast).GetSDResult("7488")
ClassMethod GetSDResult(id As %String) As %String
{
	s Result=""
	s sequence=0
	for
	{
		s sequence=$o(^User.MKBOperationResultI("SeqIndex",id,sequence))
		q:sequence=""
		s MKBICDRRowid=0
		for
		{
			s MKBICDRRowid=$o(^User.MKBOperationResultI("SeqIndex",id,sequence,MKBICDRRowid)) //结构化子表childsub
			q:MKBICDRRowid=""
			s MKBICDRResultID=$lg($g(^User.MKBOperationContrastD(id,"MKBOperationResult",MKBICDRRowid)),2)  //获取结构化结果串
			s MKBICDResultTermdr=$lg($g(^User.MKBOperationContrastD(id,"MKBOperationResult",MKBICDRRowid)),4) //获取结构化结果Termdr
			s SResult=..GetChiForNewSeqStrucIDs(MKBICDRResultID,MKBICDResultTermdr)
			s MKBICDSupplement=$lg(^User.MKBOperationContrastD(id,"MKBOperationResult",MKBICDRRowid),5)
			if MKBICDSupplement'=""
			{
				if SResult["]"
				{
					s str=$e(Result,1,*-1)
					s SResult=str_",("_MKBICDSupplement_")]"
				}
				else
				{
					s SResult=SResult_"[("_MKBICDSupplement_")]"
				}
			}
			s:Result'="" Result=Result_SResult
			s:Result="" Result=SResult
		}
	}
	q Result
}

/// Creator:张云越
/// CreatDate:2019-10-24
/// Description：查询国际码列表子术语库内容及中文释义
/// Input：rowid-行号，desc-描述, base-规则注册表id, descch-中文释义，rows-每页显示条数, page-页数
/// Return:Json格式的数据
/// Other:d ##class(web.DHCBL.MKB.MKBOperationContrast).GetMyList("E76","","1","11","1")
ClassMethod GetMyList(desc, descch, base, rows, page) As %String
{
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	if (desc'="")
	{
		s desc=$ZCONVERT(desc,"U")
		s desc=$tr(desc,".","")
		s desc=$tr(desc," ","")
	}
	w "{""rows"":["
	if (desc="")&(descch="")
	{
		s total=0
		s jsonstr=""
		s MKBTRowId=0
		for  
		{	
			
			s MKBTRowId=$o(^User.MKBTermI("BaseIndex",base,MKBTRowId)) 
			q:MKBTRowId="" 
			
			if ((total+1<stpage)||(total+1>endpage)) //如果不是当前页则只计数，不输出。
			{
				
			}
			else
			{
				s MKBTCode=$listGet($g(^User.MKBTermD(MKBTRowId)),2)  //手术编码
				s MKBTCode=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTCode)
				s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTRowId)),3)  //手术描述
				s MKBTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTDesc)
				continue:MKBTCode=MKBTDesc //过滤节点数据
				s MKBTPYCode=$listGet($g(^User.MKBTermD(MKBTRowId)),6)  //检索码
				s MKBTPYCode=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPYCode)
				s MKBTPYCodeU=$ZCONVERT(MKBTPYCode,"U")
				
				s MKBTPRowId = $O(^User.MKBTermPropertyI("DescIndex",MKBTRowId," 手术编码",0))
				s MKBTPDDesc = $LG($G(^User.MKBTermProDetailD($O(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,0)))),3)
				//s MKBTPRowIdE = $O(^User.MKBTermPropertyI("DescIndex",MKBTRowId," 英文释义",0))
				//s MKBTPDDescE = $LG($G(^User.MKBTermProDetailD($O(^User.MKBTermProDetailI("ProIdx",MKBTPRowIdE,0)))),3)			
			}
			s total=total+1
		    if (total<stpage) continue
		    if (total<=endpage)
		    {
			    s thisStr=""	
				s thisStr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTPDDesc"":"""_MKBTPDDesc_"""}"
				
				if (jsonstr'="")
				{ 
					w ","
					s jsonstr=jsonstr_","_thisStr
				}
				else
				{
					s jsonstr=thisStr
				}
				w thisStr
			 }		
		}
		w "], ""total"":"_total_"}"
	}
	elseif (desc'="" || descch'="")
	{
		s total=0
		s jsonstr=""
		s descstr=""
		s descchStr=""
		s str=""
		if desc'=""
		{
			s desc=$ZCONVERT(desc,"U")
			s desc=$tr(desc," ","")
			s descstr=##class(web.DHCBL.MKB.MKBOperationContrast).GetNationICD("编码",desc)
			if descch'=""
			{
				s descch=$tr(descch," ","")
				s descchStr=##class(web.DHCBL.MKB.MKBOperationContrast).GetNationICD("描述",descch)
				s NumOfStr=$l(descstr,"&%")
				s NumOfDescchstr=$l(descchStr,"&%")
				for i=1:1:NumOfStr
				{
					s EachOfDesc=$p(descstr,"&%",i)
					for j=1:1:NumOfDescchstr
					{
						s EachOfDescch=$p(descchStr,"&%",j)
						if EachOfDesc=EachOfDescch
						{
							s:str'="" str=str_"&%"_EachOfDesc
							s:str="" str=EachOfDesc
						}
					}
				}
				
			}
			else
			{
				s str=descstr
			}	
		}
		else
		{
			s descch=$tr(descch," ","")
			s str=##class(web.DHCBL.MKB.MKBOperationContrast).GetNationICD("描述",descch)
		}
		if str'=""
		{
			s NumOfStr=$l(str,"&%")
			for i=1:1:NumOfStr
			{
				s MKBTRowId=$p(str,"&%",i)
				s MKBTCode=$listGet($g(^User.MKBTermD(MKBTRowId)),2)  //手术编码
				s MKBTCode=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTCode)
				s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTRowId)),3)  //手术描述
				s MKBTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTDesc)
				continue:MKBTCode=MKBTDesc //过滤节点数据
				s MKBTPYCode=$listGet($g(^User.MKBTermD(MKBTRowId)),6)  //拼音码
				s MKBTPYCode=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPYCode)
				s MKBTPRowId = $O(^User.MKBTermPropertyI("DescIndex",MKBTRowId," 手术编码",0))
				s MKBTPDDesc = $LG($G(^User.MKBTermProDetailD($O(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,0)))),3)
				s descLen=$l(desc)
				s TempMKBTPDDesc=$tr(MKBTPDDesc,".","")
				continue:$extract(TempMKBTPDDesc,1,descLen)'=desc
				//s MKBTPRowIdE = $O(^User.MKBTermPropertyI("DescIndex",MKBTRowId," 英文释义",0))
				//s MKBTPDDescE = $LG($G(^User.MKBTermProDetailD($O(^User.MKBTermProDetailI("ProIdx",MKBTPRowIdE,0)))),3)
				s total=total+1
			    if (total<stpage) continue
			    if (total<=endpage)
			    {
				    s thisStr=""	
					s thisStr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTPDDesc"":"""_MKBTPDDesc_"""}"
					
					if (jsonstr'="")
					{ 
						w ","
						s jsonstr=jsonstr_","_thisStr
					}
					else
					{
						s jsonstr=thisStr
					}
					w thisStr
				 }
				 
			}
		}
			w "], ""total"":"_total_"}"
		
	}
	q ""
}

/// Creator:张云越
/// CreatDate:2019-10-24
/// Description：通过输入的条件检索国际码
/// tip:编码/中文  desc:检索条件
/// return :TermId&%TermId
/// w ##class(web.DHCBL.MKB.MKBOperationContrast).GetNationICD(编码,"S")
ClassMethod GetNationICD(tip, desc)
{
	s MKBTBRowId=$o(^User.MKBTermBaseI("DescIndex"," ICD9手术医保版",0))
	s result=""
	if ((tip'="")||(desc'=""))
	{
		s desc = ##class(web.DHCBL.MKB.BDPMKBIndex).Filter(desc)
		s Ids=0
		
		for
		{
			s Ids = $O(^User.BDPMKBIndexI("DescIndex"," "_$ZCONVERT(desc,"U"),Ids))	
			q:Ids=""
			
			if (tip="描述")
			{
				continue:Ids["D"
				continue:($D(^User.MKBTermI("BaseIndex",MKBTBRowId,Ids))=0)	
			
				s:result'="" result=result_"&%"_Ids
				s:result="" result=Ids
			}
			else
			{
				continue:Ids'["D"
				s TermId=$P(Ids,"D",1)
				continue:($D(^User.MKBTermI("BaseIndex",MKBTBRowId,TermId))=0)	
				
				s:result'="" result=result_"&%"_TermId
				s:result="" result=TermId	
			}
		}	
	}
	q result
}

/// Creator:张云越
/// CreatDate:2019-10-24
/// Description：结构化结果展示
/// Table：User.MKBOperationContrast
/// Input：父表id 
/// Return：
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBOperationContrast","GetResultList","")
Query GetResultList(id As %String) As %Query(ROWSPEC = "Rowid,MKBICDContrast,MKBICDConResultID,MKBICDConResult,MKBICDConTermDr,MKBICDConSupplement,MKBICDSequence,MKBTActiveFlag")
{
}

ClassMethod GetResultListExecute(ByRef qHandle As %Binary, id As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	if id'=""
	{
		s rowid=0
		for
		{
			s rowid=$o(^User.MKBOperationContrastD(id,"MKBOperationResult",rowid))
			q:rowid=""
			s Rowid=id_"||"_rowid
			s MKBICDConTermDr=$lg(^User.MKBOperationContrastD(id,"MKBOperationResult",rowid),4)
			s MKBTActiveFlag=$lg($g(^User.MKBTermD(MKBICDConTermDr)),9)
			s MKBICDConSupplement=$lg(^User.MKBOperationContrastD(id,"MKBOperationResult",rowid),5)
			s MKBICDStructData=id
			;s MKBICDConResult=$lg(^User.MKBICDContrastD(id,"MKBICDContrastResult",rowid),3)
			s MKBICDConResultID=$lg(^User.MKBOperationContrastD(id,"MKBOperationResult",rowid),2)
			s MKBICDConResult=..GetChiForNewSeqStrucIDs(MKBICDConResultID,MKBICDConTermDr)
			s MKBICDSequence=$lg(^User.MKBOperationContrastD(id,"MKBOperationResult",rowid),7)
			if MKBICDConSupplement'=""
			{
				s MKBICDConSupplement=$zstrip(MKBICDConSupplement,"<>W")
				if MKBICDConResult["]"
				{
					s str=$e(MKBICDConResult,1,*-1)
					s MKBICDConResult=str_",("_MKBICDConSupplement_")]"
				}
				else
				{
					s MKBICDConResult=MKBICDConResult_"[("_MKBICDConSupplement_")]"
				}
			}
			d getCTTitle
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
getCTTitle
	set Data=$lb(Rowid,MKBICDContrast,MKBICDConResultID,MKBICDConResult,MKBICDConTermDr,MKBICDConSupplement,MKBICDSequence,MKBTActiveFlag)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetResultListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetResultListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
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

/// Creator:张云越
/// CreatDate:2019-10-24
/// Description：获取单行数据
/// Table：User.MKBOperationContrast
/// Input：子表id 
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBOperationContrast).GetSingleData()
ClassMethod GetSingleData(id As %String) As %String
{
	s Result=""
	s MKBICDRowid=$g(id)
	if $d(^User.MKBOperationContrastD(id))
	{
		s sequence=0
		for
		{
			s sequence=$o(^User.MKBOperationResultI("SeqIndex",MKBICDRowid,sequence))
			q:sequence=""
			s MKBICDRRowid=0
			for
			{
				s MKBICDRRowid=$o(^User.MKBOperationResultI("SeqIndex",MKBICDRowid,sequence,MKBICDRRowid))
				q:MKBICDRRowid=""
				s MKBICDRResultID=$lg($g(^User.MKBOperationContrastD(MKBICDRowid,"MKBOperationResult",MKBICDRRowid)),2)  //获取结构化结果串
				s MKBICDResultTermdr=$lg($g(^User.MKBOperationContrastD(MKBICDRowid,"MKBOperationResult",MKBICDRRowid)),4) //获取结构化结果Termdr
				s SResult=..GetChiForNewSeqStrucIDs(MKBICDRResultID,MKBICDResultTermdr)
				s MKBICDSupplement=$lg(^User.MKBOperationContrastD(MKBICDRowid,"MKBOperationResult",MKBICDRRowid),5)
				if MKBICDSupplement'=""
				{
					if SResult["]"
					{
						s str=$e(Result,1,*-1)
						s SResult=str_",("_MKBICDSupplement_")]"
					}
					else
					{
						s SResult=SResult_"[("_MKBICDSupplement_")]"
					}
				}
				s:Result'="" Result=Result_"<br/>"_SResult
				s:Result="" Result=SResult
			}
		}
	}
	else
	{
		q ""
	}
	q Result
}

/// Creator:张云越
/// CreatDate:2019-10-24
/// Description：保存结构化结果 AND OR
/// Table：User.MKBOperationContrast
/// Input：子表id 
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBOperationContrast).SaveResultRelation()
ClassMethod SaveResultRelation(rowid As %String, flag As %String)
{
	s obj=##class(User.MKBOperationContrast).%OpenId(rowid)
	s obj.MKBOperationResultRelation=flag
	Ts
	s sc=obj.%Save()
	d obj.%Close()
	if $$$ISOK(sc)
	{
		Tc
		set id=obj.%Id()
		set result = "{success:'true',id:'"_id_"'}" 
	}
	else
	{
		Tro
		set result ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(sc)_"'}"
		
	}
	q result
}

/// Creator:张云越
/// CreatDate:2019-10-24
/// Description:可编辑表格更新数据
/// Table: 
/// Input:
/// Return:
/// Other:d ##class(web.DHCBL.MKB.MKBOperationContrast).EditUpdate(4310,"","","12464")
ClassMethod EditUpdate(rowid As %String, MKBICDConStatus As %String, MKBOperationRemark As %String, MKBICDTermDr As %String, MKBOperationInitialICD As %String) As %String
{
	if rowid=""
	{
		set result = "{success:'false',errorinfo:'rowid为空'}"
	}
	else
	{
		s obj=##class(User.MKBOperationContrast).%OpenId(rowid)        ;先备份再更新
		s bobj=##class(web.Entity.MKB.MKBOperationContrast).%New()
		s bobj.MKBOperationConCode=obj.MKBOperationConCode
		s bobj.MKBOperationConDesc=obj.MKBOperationConDesc
		s bobj.MKBOperationConNumber=obj.MKBOperationConNumber
		s bobj.MKBOperationTermDr = obj.MKBOperationTermDr
		s bobj.MKBOperationRemark=obj.MKBOperationRemark
		s bobj.MKBOperationConCenterWordID=obj.MKBOperationConCenterWordID
		s bobj.MKBOperationConSegmentation=obj.MKBOperationConSegmentation
		s bobj.MKBOperationConStatus=obj.MKBOperationConStatus
		s bobj.MKBOperationConDate=obj.MKBOperationConDate
		s bobj.MKBOperationConUpdateUser=obj.MKBOperationConUpdateUser
		s bobj.MKBOperationInitialICD=obj.MKBOperationInitialICD
		d bobj.%Close()
		//MKBICDConStatus As %String, MKBOperationRemark As %String, MKBICDTermDr As %String, MKBOperationInitialICD
		s eobj=##class(web.Entity.MKB.MKBOperationContrast).%New()
		s eobj.MKBOperationConStatus=MKBICDConStatus
		s eobj.MKBOperationRemark=MKBOperationRemark
		s eobj.MKBOperationTermDr=MKBICDTermDr
		s eobj.MKBOperationInitialICD=MKBOperationInitialICD
		d eobj.%Close()
	
		Set UpdateDate=$p($h,",",1)       //上传日期
    	Set UpdateUserDR=%session.Get("LOGON.USERID")   //上传人
		
		s obj.MKBOperationConDate=UpdateDate
		d obj.MKBOperationConUpdateUserSetObjectId(UpdateUserDR)
		if (MKBICDConStatus'=""){
			s obj.MKBOperationConStatus=MKBICDConStatus
		}
		if (MKBOperationRemark'=""){
			s obj.MKBOperationRemark=MKBOperationRemark
		}
		if (MKBICDTermDr'=""){
			d obj.MKBOperationTermDrSetObjectId(MKBICDTermDr)
		}
		if (MKBOperationInitialICD'=""){
			s obj.MKBOperationInitialICD=MKBOperationInitialICD
		}
		Ts
		s sc=obj.%Save()
		if $$$ISOK(sc)
		{
			Tc
			set id=obj.%Id()
			set result = "{success:'true',id:'"_id_"'}" 
			s Ope=$lg($g(^User.MKBOperationContrastD(rowid)),3)
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_OperationContrast","User.MKBOperationContrast","各版本手术对照手术短语",id,Ope,"U",eobj,bobj)
		}
		else
		{
			Tro
			set result ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(sc)_"'}"
			
		}
		d obj.%Close()
				
	}
	quit result
}

/// Creator:张云越
/// CreatDate:2019-10-24
/// Description：判断中心词是否封闭
/// Table：User.Term
/// Input：子表id 
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBOperationContrast).JustTermClose()
ClassMethod JustTermClose(rowid As %String)
{
	q:rowid="" ""
	s MKBTActiveFlag=$lg($g(^User.MKBTermD(rowid)),9)
	q MKBTActiveFlag
}

/// Creator:张云越
/// CreatDate:2019-10-24
/// Description:判断同名诊断
/// Table:
/// Input:
/// Return:有则拼串，没有返回""
/// Other:d ##class(web.DHCBL.MKB.MKBOperationContrast).justHasExist(119,26484)
ClassMethod justHasExist(parentid, proid)
{
	s existStr = ""
	if $d(^User.MKBOperationContrastD(parentid,"MKBOperationResult"))
	{
		s rowid=0
		
		for
		{
			s rowid=$o(^User.MKBOperationContrastD(parentid,"MKBOperationResult",rowid))
			q:rowid=""
			s MKBICDConTermDr=$lg(^User.MKBOperationContrastD(parentid,"MKBOperationResult",rowid),4)
			s MKBICDConResult=$lg(^User.MKBOperationContrastD(parentid,"MKBOperationResult",rowid),3)
			if (proid = MKBICDConTermDr)
			{
				s existStr = parentid_"||"_rowid _"^"_MKBICDConResult
				q
			}
			
		}
		
	}
	//else
	//{
	q existStr	
	//}
}

/// Creator:张云越
/// CreatDate:2019-10-24
/// Description：结构化结果子表的新增
/// Table：User.MKBOperationResult
/// Input：id
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: w ##class(web.DHCBL.MKB.MKBOperationContrast).SaveData(7486,"7486||131193","8842091:1864202","",1438820,"")
ClassMethod SaveData(Pid As %String, Cid As %String, StructResultID As %String, StructResult As %String, PropertyDR As %String, Supplement As %String)
{
	;s start=$p($now(),",",2)
	if Cid=""      ;如果为空 则新增子表数据
	{
		s obj=##class(User.MKBOperationResult).%New(Pid)
		s sort=0
		if ($d(^User.MKBOperationResultI("SeqIndex")))
		{
			s sort=$o(^User.MKBOperationResultI("SeqIndex",Pid,""),-1) 
		}
		s obj.MKBOperationSequence=sort+1			
	}
	else      ;如果不为空 则修改子表数据
	{
		s obj=##class(User.MKBOperationResult).%OpenId(Cid)
		s bobj=##class(web.Entity.MKB.MKBOperationResult).%New()
		s bobj.MKBOperationConSupplement=obj.MKBOperationConSupplement
		s bobj.MKBOperationConTermDr=obj.MKBOperationConTermDr
		s bobj.MKBOperationConResultID=obj.MKBOperationConResultID
		s bobj.MKBOperationConOther=obj.MKBOperationConOther
		s bobj.MKBOperationSequence=obj.MKBOperationSequence
		s bobj.MKBOperationCRowid=obj.MKBOperationContrast
		s bobj.MKBOperationCRRowid=obj.%Id()
		d bobj.%Close()

	}
	s eobj=##class(web.Entity.MKB.MKBOperationResult).%New()
	s:Pid'="" eobj.MKBOperationCRowid=Pid
	s:Cid'="" eobj.MKBOperationCRRowid=Cid
	s:StructResultID'="" eobj.MKBOperationConResultID=StructResultID
	s:StructResult'="" eobj.MKBOperationConResult=StructResult
	s:PropertyDR'="" eobj.MKBOperationConTermDr=PropertyDR
	s:Supplement'="" eobj.MKBOperationConSupplement=Supplement
		
	d obj.MKBOperationContrastSetObjectId(Pid)
	d obj.MKBOperationConTermDrSetObjectId(PropertyDR)
	s obj.MKBOperationConResult=StructResult
	s obj.MKBOperationConResultID=StructResultID
	s obj.MKBOperationConSupplement=Supplement
	s sc=obj.%Save()
	s errorinfo=""
	Ts
	if $$$ISOK(sc)
	{
		Tc
		set id=obj.%Id()
	
		set result = "{success:'true',id:'"_id_"'}" 
		s pobj=##class(User.MKBOperationContrast).%OpenId(Pid)
		s pobj.MKBOperationChildStructFlag=1
		Set UpdateDate=$p($h,",",1)       //上传日期
		Set UpdateUserDR=%session.Get("LOGON.USERID")   //上传人
		d pobj.MKBOperationConUpdateUserSetObjectId(UpdateUserDR)
		s pobj.MKBOperationConDate=UpdateDate
		s psc=pobj.%Save()
		d pobj.%Close()
		if $$$ERROR(psc)
		{
			tro
			s errorinfo=" "_$System.OBJ.DisplayError(psc)_" "
		}
		s delResult=##class(web.DHCBL.MKB.MKBReference).DeleteViaOriginal("OCR",id)
		if (PropertyDR'=""){
			if (Cid=""){
				s resultrefS = ##class(web.DHCBL.MKB.MKBReference).SaveDataById("","OCR",id,"T",PropertyDR)
			}	
			else{
				s refRowId = ##class(web.DHCBL.MKB.MKBReference).GetMKBRRowId("OCR", Cid, "T", PropertyDR)
				
				s resultRef = ##class(web.DHCBL.MKB.MKBReference).SaveDataById(refRowId, "OCR", Cid, "T", PropertyDR)
			}
	 			
		}
		
		if (StructResultID'=""){
			s resultref = ##class(web.DHCBL.MKB.MKBReference).SaveExpFroReference("OCR",id,StructResultID)
		}
		s Ope=$lg($g(^User.MKBOperationContrastD(Pid)),3)
		s OpeResult=##class(web.DHCBL.MKB.MKBStructuredData).StdGetChiForNewSeqStrucIDs(StructResultID,PropertyDR)			
		d:Cid="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_OperationContrastResult","User.MKBOperationResult","各版本手术对照结构化手术",id,Ope_"-"_OpeResult,"A",eobj)	
		d:Cid'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_OperationContrastResult","User.MKBOperationResult","各版本手术对照结构化手术",id,Ope_"-"_OpeResult,"U",eobj,bobj)
	
	}
	else
	{
		Tro
		set result ="{success:'false',errorinfo:'"_errorinfo_$System.OBJ.DisplayError(sc)_"'}"
	}
	d eobj.%Close()
	d obj.%Close()
	;s end=$p($now(),",",2)
	;w end-start,!
	quit result
}

/// Creator:张云越
/// CreatDate:2019-10-24
/// Description：结构化手术上移下移顺序
/// Other: w ##class(web.DHCBL.MKB.MKBOperationContrast).SaveDragOrder("9^12^11")
ClassMethod SaveDragOrder(order) As %String
{
	s $zt="ERROE"
	s result=""
	Ts
	s argsLen=$Length(order,"^")
	for i=1:1:argsLen		
	{
		s rowid=$p(order,"^",i)
		//选中行的顺序
		s obj=##class(User.MKBOperationResult).%OpenId(rowid)
		s obj.MKBOperationSequence=i
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			
		}
		else
		{
			s result = "{success:'false'}"  //返回错误信息
		}
	}
	if (result["false")
	{
		Trollback
		s result = "{success:'false',errorinfo:'保存失败'}"
	
	}
	else
	{
		Tc
		s result = "{success:'true',errorinfo:'保存成功'}"

	}
	q result
	
ERROE
	q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator:张云越
/// CreatDate:2019-10-24
/// Description：结构化结果子表的删除
/// Table：User.MKBOperationResult
/// Input：子表id 
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBOperationContrast).DeleteData()
ClassMethod DeleteData(id)
{
	if id'=""
	{
		Ts
		s Pid=$p(id,"||",1)
		s Cid=$p(id,"||",2)
		s Ope=$lg($g(^User.MKBOperationContrastD(Pid)),3)
		s OpeResultId=$lg($g(^User.MKBOperationContrastD(Pid,"MKBOperationResult",Cid)),2)
		s OpeTermdr=$lg($g(^User.MKBOperationContrastD(Pid,"MKBOperationResult",Cid)),4)
		s OpeResult=##class(web.DHCBL.MKB.MKBStructuredData).StdGetChiForNewSeqStrucIDs(OpeResultId,OpeTermdr)
		s bobj=##class(web.Entity.MKB.MKBOperationResult).%New()
		s bobj.MKBOperationConResultID=OpeResultId
		s bobj.MKBOperationConTermDr=OpeTermdr
		s sc= ##class(User.MKBOperationResult).%DeleteId(id)
		if $$$ISOK(sc)
		{
			Tc
			set result = "{success:'true',info:'删除成功！'}"
			if '$d(^User.MKBOperationContrastD(Pid,"MKBOperationResult"))
			{
				s pobj=##class(User.MKBOperationContrast).%OpenId(Pid)
				s pobj.MKBOperationChildStructFlag=""
				s psc=pobj.%Save()
				d pobj.%Close()
			}
			s refResult =  ##class(web.DHCBL.MKB.MKBReference).DeleteViaOriginal("OCR",id)
			d:id'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_OperationContrastResult","User.MKBOperationResult","各版本手术对照结构化手术",id,Ope_"-"_OpeResult,"D",bobj)	

		}
		else
		{
			Tro
			set result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}" 
		}
	}
	else
	{
		set result = "{success:'false',info:'id为空！'}"
	}
	d bobj.%Close()
	q result
}

/// Creator:张云越
/// CreatDate:2019-10-24
/// Description：获取结构化诊断的信息
/// Table：User.MKBStructuredData
/// Input：rowid 结构化诊断id
/// Return：术语属性内容值串^诊断展示名^诊断备注
/// Other: w ##class(web.DHCBL.MKB.MKBOperationContrast).GetData("7486","7486||131138")
ClassMethod GetData(parentid, rowid) As %String
{
	q:parentid="" ""
	q:rowid="" ""
	s result=""
	s parentid = $p($g(rowid),"||",1)
	s rowid = $p($g(rowid),"||",2)
	s SDSTermDR=$lg($g(^User.MKBOperationContrastD(parentid,"MKBOperationResult",rowid)),4) //诊断id
	s PropertyDR=..GetPropertyIdByFlag(SDSTermDR,"DT")
	d ..GetShowType(PropertyDR)
	
	s SDSValue=$lg(^User.MKBOperationContrastD(parentid,"MKBOperationResult",rowid),2)   
	s TreeCheckedIdStr=""
	s ComboCheckedIdStr=""
	s RadioCheckedIdStr=""
	s CheckBoxCheckedIdStr=""
	s CheckBoxCheckedIdStr=""
	s GridCheckedIdStr=""
	if (SDSValue'=""){
		s len=$Length(SDSValue,",")
		for i=1:1:len{
			s progroup=$p(SDSValue,",",i)
			s key=$p(progroup,":",1)
			s value=$p(progroup,":",2)
			s len2 = $Length(value,"*")		
			for j=1:1:len2{
				s value1=$p(value,"*",j)
				if (value1 [ "S"){
					s value1 = 	$p(value1,"S",2)
				}
			 	if ($g(^TMPMKBSHOWTYPE(key))="T"){
				 	if (TreeCheckedIdStr=""){
						s TreeCheckedIdStr=value1
					}else{
						s TreeCheckedIdStr=TreeCheckedIdStr_"&"_value1
					}
				}	
				if ($g(^TMPMKBSHOWTYPE(key))="C"){
					if (ComboCheckedIdStr=""){
						s ComboCheckedIdStr=value1
					}else{
						s ComboCheckedIdStr=ComboCheckedIdStr_"&"_value1
					}
				}
				if ($g(^TMPMKBSHOWTYPE(key))="CB"){
					if (RadioCheckedIdStr=""){
						s RadioCheckedIdStr=value1
					}else{
						s RadioCheckedIdStr=RadioCheckedIdStr_"&"_value1
					}
				}
				if ($g(^TMPMKBSHOWTYPE(key))="CG"){
					if (CheckBoxCheckedIdStr=""){
						s CheckBoxCheckedIdStr=value1
					}else{
						s CheckBoxCheckedIdStr=CheckBoxCheckedIdStr_"&"_value1
					}
				}
				if ($g(^TMPMKBSHOWTYPE(key))="G"){
					if (GridCheckedIdStr=""){
						s GridCheckedIdStr=value1
					}else{
						s GridCheckedIdStr=GridCheckedIdStr_"&"_value1
					}
				}
			}
		}
	}
	s result=TreeCheckedIdStr_"^"_ComboCheckedIdStr_"^"_RadioCheckedIdStr_"^"_CheckBoxCheckedIdStr_"^"_GridCheckedIdStr
	q result
}

/// Creator:张云越
/// CreatDate:2019-10-24
/// Description：根据标识获取属性id
/// Input: termid术语id，desc属性描述
/// return:属性id
/// Other:w ##class(web.DHCBL.MKB.MKBOperationContrast).GetPropertyIdByFlag("16354","DT")
ClassMethod GetPropertyIdByFlag(termid As %String, flag As %String) As %String
{
	s propertyid=""
	s propertyid=$o(^User.MKBTermPropertyI("FlagIndex",termid," "_flag,0))
	q propertyid
}

/// Creator:张云越
/// CreatDate:2019-10-24
/// Description：根据属性id获取诊断模板中的展示格式
/// Table：User.SDSStructDiagnos
/// Input：属性id
/// Other: w ##class(web.DHCBL.MKB.MKBOperationContrast).GetShowType("4989")
ClassMethod GetShowType(property) As %String
{
	k ^TMPMKBSHOWTYPE
	q:property="" ""
	s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProIdx",property,0))
	s MKBTPDDesc=""
	s:MKBTPDRowId'="" MKBTPDDesc=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)
	if (MKBTPDDesc'="")
	{
        s argsLen=$Length(MKBTPDDesc,",")
        for i=1:1:argsLen  
        { 
          s argstr=$p(MKBTPDDesc,",",i)
          s MKBTPRowId=$p(argstr,"&",1)
          s MKBTPShowType=$p(argstr,"&",2)  //展示格式
          s MKBTPTreeNode=$p(argstr,"&",3)  //定义节点
          s ^TMPMKBSHOWTYPE(MKBTPRowId)=MKBTPShowType
        }
	}
}

/// Creator:张云越
/// CreatDate:2019-10-24
/// Description：修改补充诊断即更新
/// Table：User.MKBStructuredDataResult
/// Input：Cid结构化子表id Supplement补充诊断
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: w ##class(web.DHCBL.MKB.MKBOperationContrast).UpdateSupplement()
ClassMethod UpdateSupplement(Cid As %String, Supplement As %String)
{
	s obj=##class(User.MKBOperationResult).%OpenId(Cid)
	s obj.MKBOperationConSupplement=Supplement
	s sc=obj.%Save()
	Ts
	if $$$ISOK(sc)
	{
		Tc
		set id=obj.%Id()
		set result = "{success:'true',id:'"_id_"'}" 
	}
	else
	{
		Tro
		set result ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(sc)_"'}"
	}
	d obj.%Close()
	quit result
}

/// Creator:张云越
/// CreatDate:2019-10-24
/// Description：根据termid取描述
/// Input:termid 中心词id
/// Return：中心词描述
/// Other: w ##class(web.DHCBL.MKB.MKBOperationContrast).findTermDescById(15026)
ClassMethod findTermDescById(termid As %String)
{
	q:termid="" ""  //描述
	s termDesc="" 
	s termDesc=$listGet($g(^User.MKBTermD(termid)),3) 
	s strComAndAlisa=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(termid)
	s strCom=$p(strComAndAlisa,"[A]",1)
	s comDesc=$p(strCom,"&%",1) //常用名
	//s comKey=$p(strCom,"&%",2)	//常用名拼音码	
	s:comDesc="" comDesc=termDesc
	q comDesc
}

/// Creater:张云越
/// Date:2020-2-20
/// Description:各版本手术对照中取手术版本界面的是否默认值为是的id
/// w ##class(web.DHCBL.MKB.MKBOperationContrast).getYesOrNot()
ClassMethod getYesOrNot()
{
	s MKBTBRowid=$o(^User.MKBTermBaseI("DescIndex"," ICD版本",0))
	q:MKBTBRowid="" "" //不存在ICD版本知识库的时候返回""
	s MKBTRowid=0
	for
	{
		s MKBTRowid=$o(^User.MKBTermI("BaseIndex",MKBTBRowid,MKBTRowid))
		q:MKBTRowid=""
		s MKBTPRowid=$o(^User.MKBTermPropertyI("DescIndex",MKBTRowid," 标识",0)) //标识的属性id
		continue:MKBTPRowid="" 
		s MKBTPDRowid=$o(^User.MKBTermProDetailI("ProIdx",MKBTPRowid,0)) //标识的属性值id
		continue:MKBTPDRowid="" 
		s TPDDesc=$lg($g(^User.MKBTermProDetailD(MKBTPDRowid)),3) //标识值
		continue:TPDDesc'="手术"
		s MKBTPDFRowid=$o(^User.MKBTermPropertyI("DescIndex",MKBTRowid," 是否默认",0))
		continue:MKBTPDFRowid=""
		s MKBTPDDFRowid=$o(^User.MKBTermProDetailI("ProIdx",MKBTPDFRowid,0))
		if MKBTPDDFRowid'=""
		{
			s MKBTPDDesc=$lg($g(^User.MKBTermProDetailD(MKBTPDDFRowid)),3)
			if MKBTPDDesc="是"
			{
				q 
			}
		}
	}
	q MKBTRowid
}

/// Creator:张云越
/// CreatDate:2019-11-13
/// Description：清除各版本手术对照界面的结构化数据以及对应的引用表数据
/// Input：
/// Return:清除数量
/// Other:d ##class(web.DHCBL.MKB.MKBOperationContrast).ClearOpeConSD()
ClassMethod ClearOpeConSD() As %String
{
	TS
	s clearOpeNum=0 //涉及的手术对照表数据数量
	s clearOpeResNum=0 //涉及的结构化数据子表数量
	//s clearRefNum=0 //涉及的引用表数据数量
	s OpeRowid=0
	for //遍历手术对照表
	{
		//s result=""
		s OpeRowid=$o(^User.MKBOperationContrastD(OpeRowid))
		q:OpeRowid=""
		s OperChildStructFlag=$lg($g(^User.MKBOperationContrastD(OpeRowid)),17) //结构化标志
		if OperChildStructFlag=1
		{
			s clearOpeNum=clearOpeNum+1
			//s obj=##class(User.MKBOperationResult).%OpenId(Cid)
			//s bobj=##class(web.Entity.MKB.MKBOperationContrast).%New()
			s obj=##class(User.MKBOperationContrast).%OpenId(OpeRowid)			
			s obj.MKBOperationChildStructFlag=""
			s sc=obj.%Save()
			if $$$ISOK(sc)
			{
				s id=obj.%Id()
				s result = "{success:'true',id:'"_id_"'}"
				s OpeResultId=0
				for //遍历结构化子表
				{
					s OpeResultId=$o(^User.MKBOperationContrastD(id,"MKBOperationResult",OpeResultId)) //结构化子表
					q:OpeResultId=""
					s ID=id_"||"_OpeResultId
					s DeleteResult=##class(web.DHCBL.MKB.MKBOperationContrast).DeleteData(ID)
					s clearOpeResNum=clearOpeResNum+1
					b:DeleteResult["false"
				}
			}
			else
			{
				s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
				b
			}
			w result,!
		}		
	}
	w "手术对照表:"_clearOpeNum,!
	w "手术对照结构化子表:"_clearOpeResNum,!
}

/// Creator:张云越
/// CreatDate:2019-11-14
/// Description：根据江苏省中医治疗手术的对照ICD属性更新江苏省中医治疗手术到各版本手术对照结构化列
/// Input：
/// Return:更新数量
/// Other:d ##class(web.DHCBL.MKB.MKBOperationContrast).UpdateOpeConSD()
ClassMethod UpdateOpeConSD() As %String
{
	TS
	s Num=0
	s RefNum=0
	s OpeConResNum=0
	s OpeConNum=0
	s TermBaseId=$o(^User.MKBTermBaseI("DescIndex"," 江苏省中医治疗手术",0)) //获得江苏省中医治疗手术的库id
	s TermId=0
	//s TempOpeConSource=""
	for
	{
		s TermId=$o(^User.MKBTermI("BaseIndex",TermBaseId,TermId)) //中心词id
		q:TermId=""
		s Num=Num+1
		//s TermProId=0
		//for
		//{
			s TermProId=$o(^User.MKBTermPropertyI("DescIndex",TermId," 对照ICD-9-CM-3 2017",0)) //属性id
			b:TermProId=""
			s TermProDetailId=0
			for
			{
				s Tempsource=""
				s TermProDetailId=$o(^User.MKBTermProDetailI("ProIdx",TermProId,TermProDetailId)) //属性值id
				q:TermProDetailId=""
				s TermProDetailDesc=$lg($g(^User.MKBTermProDetailD(TermProDetailId)),3) //属性值描述(这里指各版本手术对照里的手术)				
				s TermProDetailDesc = $zstrip(TermProDetailDesc,"<>W") //去除前后空格
				s TermProDetailDesc = $Replace(TermProDetailDesc,",","，") //把中文逗号换为英文逗号
				//把中文括号换为英文括号
				s TermProDetailDesc = $Replace(TermProDetailDesc,"(","（")
				s TermProDetailDesc = $Replace(TermProDetailDesc,")","）")
				
				s TermProDetailDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(TermProDetailDesc) //去除特殊字符
				if $d(^User.MKBOperationContrastI("DescIndex"," "_$zconvert(TermProDetailDesc,"U")))   //如果手术对照表里存在相同手术
				{					
					s TermProChildId=$o(^User.MKBTermExtendProI("NameIndex",TermProId," 对应标准版",0)) 
					s TermExtendProId=TermProId_"||"_TermProChildId //扩展属性id
					s TermExtendProValId=$o(^User.MKBTermExtendProValI("ValIndex",TermProDetailId,TermExtendProId,0)) //扩展属性值id
					continue:TermExtendProValId=""				
					s source=$lg($g(^User.MKBTermExtendProValD(TermExtendProValId)),4) 
					if source="北京临床" 
					{
						s source="A"
					}
					elseif source="国家标准版" 
					{ 
						s source="B"
					}
					elseif source="国家临床1.1" 
					{
						s source="C"
					}
					elseif source="国家临床2.0"
					{
						s source="D"
					}
					elseif source'=""
					{
						s TempSource=""
						s length=$length(source,"&%")
						for i=1:1:length
						{
							s TempSource=TempSource_$p(source,"&%",i)
						}
						s:TempSource["北京临床" Tempsource=Tempsource_"A"
						s:TempSource["国家标准版" Tempsource=Tempsource_"B"
						s:TempSource["国家临床1.1" Tempsource=Tempsource_"C"
						s:TempSource["国家临床2.0" Tempsource=Tempsource_"D"
					}
					s ExistRowid=0
					s Cid = 0
					for //遍历各版本手术对照相同手术
					{
						s TempOpeConSource=""
						s ExistRowid=$o(^User.MKBOperationContrastI("DescIndex"," "_TermProDetailDesc,ExistRowid)) //对照表id
						q:ExistRowid=""
						s Cid=$o(^User.MKBOperationResultI("MKBOperationContrastIndex",ExistRowid,Cid)) //获取childsub
						s OpeConSource=$lg($g(^User.MKBOperationContrastD(ExistRowid)),6)
						s length=$length(OpeConSource,"&")
						for i=1:1:length
						{
							s TempOpeConSource=TempOpeConSource_$p(OpeConSource,"&",i)
						}
						if Tempsource[TempOpeConSource //满足数据源条件
						{
							if '$d(^User.MKBOperationResultI("TermIndex",TermId,ExistRowid)) //若新增结构化不存在则新增子表数据
							{
								s childsub=0
								/*s TermDesc=$lg($g(^User.MKBTermD(TermId)),3)
								s Flag=0 //中心词重复标志 0不重复
								for
								{
									s childsub=$o(^User.MKBOperationContrastD(ExistRowid,"MKBOperationResult",childsub))
									q:childsub=""
									s ResultTermDr=$lg($g(^User.MKBOperationContrastD(ExistRowid,"MKBOperationResult",childsub)),4)
									s TempTermDesc=$lg($g(^User.MKBTermD(ResultTermDr)),3)
									if TermDesc=TempTermDesc
									{
										s Flag=Flag+1
										b
									}
								}
								q:Flag>0*/
								s obj=##class(User.MKBOperationResult).%New(ExistRowid)
								s sort=0
								if ($d(^User.MKBOperationResultI("SeqIndex")))
								{
									s sort=$o(^User.MKBOperationResultI("SeqIndex",ExistRowid,""),-1) 
								}
								s obj.MKBOperationSequence=sort+1
							}
							else 
							{
								continue //跳过重复数据
							}
							s eobj=##class(web.Entity.MKB.MKBOperationResult).%New()
							s:ExistRowid'="" eobj.MKBOperationCRowid=ExistRowid
							s:Cid'="" eobj.MKBOperationCRRowid=Cid
							s:TermId'="" eobj.MKBOperationConTermDr=TermId				
							d obj.MKBOperationContrastSetObjectId(ExistRowid)
							d obj.MKBOperationConTermDrSetObjectId(TermId)
							s sc=obj.%Save()
							if $$$ISOK(sc)
							{
								s OpeConResNum=OpeConResNum+1
								s id=obj.%Id()
								s pobj=##class(User.MKBOperationContrast).%OpenId(ExistRowid)
								s pobj.MKBOperationChildStructFlag=1
								s psc=pobj.%Save()
								d pobj.%Close()
								if $$$ERROR(psc)
								{
									tro
									s errorinfo=" "_$System.OBJ.DisplayError(psc)_" "
								}								
								s delResult=##class(web.DHCBL.MKB.MKBReference).DeleteViaOriginal("OCR",id)
								if TermId'=""
								{
									s refRowId = ##class(web.DHCBL.MKB.MKBReference).GetMKBRRowId("OCR", id, "T", TermId)
									s resultRef = ##class(web.DHCBL.MKB.MKBReference).SaveDataById(refRowId, "OCR", id, "T", TermId)
									s RefNum=RefNum+1
								}							
							}
							else
							{
								b ;1	
							}
						}
					}
				}
			
			}
		//}
	}
	w "江苏省中医治疗手术："_Num,!
	w "新增引用："_RefNum,!
	w "新增结构化子表："_OpeConResNum,!
	//w "涉及的手术对照："_OpeConNum,! s OpeConNum=OpeConNum+1
}

/// Creator：      	张云越
/// CreatDate：    	2020-2-20
/// Description:    将各版本手术中数据来源批处理为指向性dr
/// Table：         User.MKBOperationContrast 
/// Return:批处理数据量和是否成功
/// Others:w ##class(web.DHCBL.MKB.MKBOperationContrast).ProcessSources()
ClassMethod ProcessSources() As %String
{
	TS
	s MKBTBRowid=$o(^User.MKBTermBaseI("DescIndex"," ICD版本",0)) //ICD版本的知识库id
	s MKBTermAid=$o(^User.MKBTermI("DescIndex",MKBTBRowid," 北京临床-ICD9手术分类临床版",0))
	s MKBTermBid=$o(^User.MKBTermI("DescIndex",MKBTBRowid," 国家标准版-ICD9字典库2011",0))
	s MKBTermCid=$o(^User.MKBTermI("DescIndex",MKBTBRowid," 国家临床1.1-手术操作分类代码",0))
	s MKBTermDid=$o(^User.MKBTermI("DescIndex",MKBTBRowid," 国家临床2.0-手术操作分类代码",0))
	
	s UpdateNum=0
	s OpeConRowid=0
	for
	{
		s OpeConRowid=$o(^User.MKBOperationContrastD(OpeConRowid))
		q:OpeConRowid=""
		s Sources=$lg($g(^User.MKBOperationContrastD(OpeConRowid)),6) //数据来源
		s sourcelen=$l(Sources,"&")
		s MKBOperationSource=""
		for i=1:1:sourcelen //把写死的ABCD替换为dr指向
		{
			s Source=$p(Sources,"&",i)
			continue:Source=""
			s SourceString=$select(Source="A":MKBTermAid,Source="B":MKBTermBid,Source="C":MKBTermCid,Source="D":MKBTermDid)
			s:MKBOperationSource'="" MKBOperationSource=MKBOperationSource_"&"_SourceString
			s:MKBOperationSource="" MKBOperationSource=SourceString
		}
		s obj=##class(User.MKBOperationContrast).%OpenId(OpeConRowid)        
		s obj.MKBOperationDiaSource=MKBOperationSource
		Ts
		s sc=obj.%Save()
		if $$$ISOK(sc)
		{
			Tc
			s UpdateNum=UpdateNum+1
			//set id=obj.%Id()
			//set result = "{success:'true',id:'"_id_"'}" 
		}
		else
		{
			b
			s result = "{success:'false',errorinfo:'保存失败!"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			Tro		
		}
		d obj.%Close()
	}
	q "批处理成功,共处理:"_UpdateNum_"条数据"
}

/// Creator：张云越
/// CreatDate: 2020-2-20
/// Description：通过版本描述获取版本描述和id
/// Table：User.MKBTerm 术语表
/// Input：rowid,desc,base
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBOperationContrast","GetOpeEdition","")
Query GetOpeEdition(desc As %String) As %Query(ROWSPEC = "id,text")
{
}

ClassMethod GetOpeEditionExecute(ByRef qHandle As %Binary, desc) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s MKBTBRowid=$o(^User.MKBTermBaseI("DescIndex"," ICD版本",0))
	if MKBTBRowid=""
	{
		s MKBTDesc=""
		d OutputRow
	}
	else
	{
		if desc'=""
		{
			s MKBTRowid=0
			for
			{
				s MKBTRowid=$o(^User.MKBTermI("BaseIndex",MKBTBRowid,MKBTRowid))
				q:MKBTRowid=""
				s MKBTPRowid=$o(^User.MKBTermPropertyI("DescIndex",MKBTRowid," 标识",0)) //标识的属性id
				s:MKBTPRowid'="" MKBTPDRowid=$o(^User.MKBTermProDetailI("ProIdx",MKBTPRowid,0)) //标识的属性值id
				s:MKBTPDRowid'="" TPDDesc=$lg($g(^User.MKBTermProDetailD(MKBTPDRowid)),3) //标识值
				continue:TPDDesc'="手术"
				s MKBTDesc=$Lg($g(^User.MKBTermD(MKBTRowid)),3)
				if MKBTDesc[desc
				{
					d OutputRow
				}
			}
		}
		else
		{
			s MKBTRowid=0
			for
			{
				s MKBTRowid=$o(^User.MKBTermI("BaseIndex",MKBTBRowid,MKBTRowid))
				q:MKBTRowid=""
				s MKBTPRowid=$o(^User.MKBTermPropertyI("DescIndex",MKBTRowid," 标识",0)) //标识的属性id
				s:MKBTPRowid'="" MKBTPDRowid=$o(^User.MKBTermProDetailI("ProIdx",MKBTPRowid,0)) //标识的属性值id
				s:MKBTPDRowid'="" TPDDesc=$lg($g(^User.MKBTermProDetailD(MKBTPDRowid)),3) //标识值
				continue:TPDDesc'="手术"
				s MKBTDesc=$Lg($g(^User.MKBTermD(MKBTRowid)),3)
				d OutputRow
			}
		}
	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(MKBTRowid,MKBTDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetOpeEditionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetICDEditionExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetOpeEditionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetICDEditionExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
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

}
