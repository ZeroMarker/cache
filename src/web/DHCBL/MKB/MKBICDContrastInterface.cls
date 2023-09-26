/// Creator:李得原
/// CreatDate:2019-08-14
/// Description：给珊珊提供接口
/// Table：
Class web.DHCBL.MKB.MKBICDContrastInterface Extends %RegisteredObject
{

/// Creator：李得原
/// CreatDate: 2019-08-14
/// Description：根据诊断短语描述取各版本icd对照中得数据
/// Table：User.MKBICDContrast
/// Input： desc,version（必填）
/// Other: w ##class(web.DHCBL.MKB.MKBICDContrastInterface).GetTermListForDocViaIndex("霍乱","ICD526474",4,1)
ClassMethod GetTermListForDocViaIndex(desc, version, rows, page)
{
	s result="",total=0,jsonstr=""
	s version=$tr(version,"ICD","")
	w "{""rows"":["
	s endpage=page*rows ///结束行
	s stpage=((page-1)*rows)+1
	if desc'=""          //如果描述不为空
	{
		s desc=$zstrip(desc,"<>W")
		s tmpnum=0        //记录关键词个数
		for i=1:1:$l(desc," ")
		{
			continue:desc=""
			s subdesc = $P(desc," ",i)
			continue:((subdesc="")||($zstrip(subdesc,"<>W")=""))
			s tmpnum=tmpnum+1
			s MKBICDRowid=0
			for
			{
				s MKBICDRowid=$o(^User.MKBStructIndexI("DescIndex"," "_$zconvert(subdesc,"U"),MKBICDRowid))
				q:MKBICDRowid=""
				continue:MKBICDRowid'["ICD"
				s MKBRowid=$e(MKBICDRowid,1,*-3)
				s MKBICD=$lg($g(^User.MKBICDContrastD(MKBRowid)),4)
				continue:MKBICD=""
				s MKBType=$lg($g(^User.MKBICDContrastD(MKBRowid)),6)
				continue:MKBType'[version
		
				if $D(tmpdesc(MKBRowid))
				{
					s tmpdesc(MKBRowid)=tmpdesc(MKBRowid)+1	
				}
				else
				{
					s tmpdesc(MKBRowid)=1	
				}
			}
		}
		s MKBICDRowid=0                   //不满足匹配到每个关键词的则不输出
		for
		{
			s MKBICDRowid=$O(tmpdesc(MKBICDRowid))
			q:MKBICDRowid=""
			k:tmpdesc(MKBICDRowid)'=tmpnum tmpdesc(MKBICDRowid)	
		}
		
		s MKBICDRowid=0                      //按汉字ASCII码排序        
		for
		{
			s MKBICDRowid=$o(tmpdesc(MKBICDRowid))
			q:MKBICDRowid=""
			s MKBICDDesc=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),3)
			s tempout(MKBICDDesc,MKBICDRowid)=""
		}
		
		s flag=0
		s Desc=""
		for
		{
			s Desc=$o(tempout(Desc))
			q:Desc=""
			s MKBICDRowid=0
			for
			{
				s MKBICDRowid=$o(tempout(Desc,MKBICDRowid))
				q:MKBICDRowid=""
				
				d GetData
				s total=total+1
				if (total<stpage) continue
				if (total<=endpage)
				{
					s mainstr="{""MKBSDRowId"":"""_MKBICDRowid_""",""MKBSDDesc"":"""_MKBICDDesc_""",""MKBSDRRowId"":"""_MKBICDRowid_"||"_MKBICDRRowid_""",""MKBSDRTermDr"":"""_MKBICDRRTerm_""",""MKBSDRExpId"":"""_MKBICDRResult_""",""MKBSDRExp"":"""_Result_""",""MKBSDRSup"":"""_MKBICDRRSup_""",""LinkIcdDesc"":"""_LinkIcdDesc_""",""LinkIcdCode"":"""_LinkIcdCode_"""}"	
					if (flag=0)
					{
						s flag=1
					}
					else
					{
						w ","
					}
					w mainstr	
				}
			}
		}
	}
	else                  //如果描述为空取所有
	{
		s MKBICDRowid=0
		for
		{
			s MKBICDRowid=$o(^User.MKBICDContrastD(MKBICDRowid))
			q:MKBICDRowid=""
			s MKBICD=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),4)
			continue:MKBICD=""
			s MKBType=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),6)
			continue:MKBType'[version
			s flag=0
			d GetData
			s total=total+1
			if (total<stpage) continue
			if (total<=endpage)
			{
				s mainstr="{""MKBSDRowId"":"""_MKBICDRowid_""",""MKBSDDesc"":"""_MKBICDDesc_""",""MKBSDRRowId"":"""_MKBICDRowid_"||"_MKBICDRRowid_""",""MKBSDRTermDr"":"""_MKBICDRRTerm_""",""MKBSDRExpId"":"""_MKBICDRResult_""",""MKBSDRExp"":"""_Result_""",""MKBSDRSup"":"""_MKBICDRRSup_""",""LinkIcdDesc"":"""_LinkIcdDesc_""",""LinkIcdCode"":"""_LinkIcdCode_"""}"	
				if (flag=0)
				{
					s flag=1
				}
				else
				{
					w ","
				}
				w mainstr	
			}
		}
	}
	w "], ""total"":"_total_"}"
	q ""
GetData
	s MKBICDDesc=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),3)
	s sequence=$o(^User.MKBICDContrastResultI("SeqIndex",MKBICDRowid,0))
	if sequence'=""
	{
		s MKBICDRRowid=$o(^User.MKBICDContrastResultI("SeqIndex",MKBICDRowid,sequence,0))
		s MKBICDRResult=$lg($g(^User.MKBICDContrastD(MKBICDRowid,"MKBICDContrastResult",MKBICDRRowid)),2)
		s MKBICDRRTerm=$lg($g(^User.MKBICDContrastD(MKBICDRowid,"MKBICDContrastResult",MKBICDRRowid)),4)
		s MKBICDRRSup=$lg($g(^User.MKBICDContrastD(MKBICDRowid,"MKBICDContrastResult",MKBICDRRowid)),5)
		s Result= ##class(web.DHCBL.MKB.MKBStructuredData).StdGetChiForNewSeqStrucIDs(MKBICDRResult,MKBICDRRTerm)
	}
	else
	{
		s MKBICDRRSup=""
		s MKBICDRRTerm=""
		s MKBICDRResult=""
		s MKBICDRRowid=""
		s Result=""
	}
	s icd=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),4)
	s extend=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),5)
	s LinkIcdCode=icd_extend //在ICD字段取值
	
	s LinkIcdDesc=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),3)  //在ICD描述字段取值
}

/// Creator:tianhhh
/// CreateDate:2019-08-15
/// Desc:根据结构化ICD数据获取非结构化ICD数据
/// w ##class(web.DHCBL.MKB.MKBICDContrastInterface).GetDiagViaStruct("ICD526477","15562-68963:S16562")
ClassMethod GetDiagViaStruct(version, ids)
{
	s version=$tr(version,"ICD","")
	q:(version="")||(ids="") ""  //如果版本ID或者结构化id串传过来为空，则直接返回空
	s ICDNSFlag = ##class(web.DHCBL.MKB.MKBConfig).GetConfigValue("SDSNonstandardICD")  //获取平台配置中是否允许录入非标ICD
	s result=""
	//s LocId=$G(%session.Data("LOGON.CTLOCID"))
	;s ^lee(0)=LocId
	//s IsChinaMed =$P($G(^CTLOC(LocId,"DHC")),"^",16)

	s TermId=$P(ids,"-",1)        //取termid
	s ProDets=$P(ids,"-",2)       //取属性、属性内容
	if (ProDets'="")
	{
		///记录所有传入属性内容
		k dets
		///包含属性内容串个数
		s len = $L(ProDets,",")      //属性个数
		for i=1:1:len
		{
			s subProDets=$P(ProDets,",",i)
			s Pro=$P(subProDets,":",1)         //单个属性
			s Dets=$P(subProDets,":",2)        //单个属性内容带*
			for j=1:1:$L(Dets,"*")
			{
				s dets(Pro,$P(Dets,"*",j))=""	   //dets(属性，属性内容)=""
			}

		}
		///记录属性内容个数	
		s detNum=0
		s pro=0
		for
		{
			s pro=$O(dets(pro))
			q:pro=""
			
			s det=0
			for
			{
				s det=$O(dets(pro,det))
				q:det=""
				
				s detNum=detNum+1	
			}	
		}
		///初始权重，每包含其中一个属性内容累加权重
		s initPriority=1/detNum
		
		///计算权重列表
		s pro=0
		for
		{
			s pro=$O(dets(pro))
			q:pro=""
			
			s det=0
			for
			{
				s det=$O(dets(pro,det))
				q:det=""
				
				s dets(pro,det)=initPriority   //:   1/detNum
				
				s protype = $LG($G(^User.MKBTermPropertyD(pro)),4)   //类型
				s config=$LG($G(^User.MKBTermPropertyD(pro)),5)     //引用base
				s contype=""
				if (protype="S")||(protype="SS")
				{
					s contype=$LG($G(^User.MKBTermBaseD(config)),4)	  //类型
				}
				
				///树性结构
				if ((protype="T")||(((protype="SS")||(protype="S"))&&(contype="T")))
				{
					
					///树形属性
					if (protype="T")
					{
						///先找出所有上级节点
						s tmp=det
						s tmpPrio=1
						while($LG($G(^User.MKBTermProDetailD(tmp)),4)'="")    //找detail的上级节点
						{
							s par=$LG($G(^User.MKBTermProDetailD(tmp)),4)
							s tmpPrio=tmpPrio-0.1
							s dets(pro,par)=initPriority*tmpPrio
							s tmp=par
						}
						
						///所有下级节点权重暂等于当前节点
						s childs = ##class(web.DHCBL.MKB.MKBTermProDetail).GetChildOrderedIDStr(det,pro)
						if (childs'="")
						{
							for k=1:1:$L(childs,"^")
							{
								s dets(pro,$P(childs,"^",k))=initPriority	
							}		
						}
							
					}
					elseif (protype="SS")||(protype="S")
					{
						
						//当前选中的TermId
						s curTemrId=$P(det,"S",2)
						
						///找出所有上级节点
						s tmp=curTemrId
						s tmpPrio=1
						while($LG($G(^User.MKBTermD(tmp)),5)'="")
						{
							s par=$LG($G(^User.MKBTermD(tmp)),5)
							s tmpPrio=tmpPrio-0.1
							s dets(pro,"S"_par)=initPriority*tmpPrio
							s tmp=par
						}	
						
						///所有下级节点暂定权重不变
						
						s childs = ##class(web.DHCBL.MKB.MKBTerm).GetChildOrderedIDStr(config,curTemrId)
						if (childs'="")
						{
							for k=1:1:$L(childs,"^")
							{
								s dets(pro,"S"_$P(childs,"^",k))=initPriority	
							}		
						}
						
					}	
				}	
			}
		}
		
		s SortExp = ##class(web.DHCBL.MKB.MKBICDRely).SortExp(ProDets)	  //对结构化结果id串排序   2:23*43   2:43*23
		if ($D(^User.MKBICDContrastResultI("SortIndex",TermId,SortExp))'=0) //完全匹配
		{
			s MKBSDRowId=""
			for
			{
				s MKBSDRowId=$O(^User.MKBICDContrastResultI("SortIndex",TermId,SortExp,MKBSDRowId))	
				q:MKBSDRowId=""
				s MKBSDInitialICD=$LG($G(^User.MKBICDContrastD(MKBSDRowId)),17) //最匹配短语
				s sequence=$o(^User.MKBICDContrastResultI("SeqIndex",MKBSDRowId,0))
				s MKBSDRRowId=$O(^User.MKBICDContrastResultI("SortIndex",TermId,SortExp,MKBSDRowId,0))	
				s seq=$LG($G(^User.MKBICDContrastD(MKBSDRowId,"MKBICDContrastResult",MKBSDRRowId)),7)
				
				s ICDDesc = $LG($G(^User.MKBICDContrastD(MKBSDRowId)),3)
				s ICDCode = $LG($G(^User.MKBICDContrastD(MKBSDRowId)),4)
				//s ICDDr = ##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).GetMRCIDByCodeDesc(ICDCode,ICDDesc)
				if (ICDNSFlag'="Y")
				{
					s ICDDr =##class(web.DHCBL.MKB.SDSDiagnosInterface).GetHISICDRowId(ICDCode,ICDDesc)
					continue:ICDDr=""
					/*s MRCIDBillFlag3=$p($g(^MRC("ID",ICDDr)),"^",15) //中医诊断标志
					continue:((MRCIDBillFlag3="Y")&&(IsChinaMed=0))	*/
				}
				if seq=sequence
				{
					if MKBSDInitialICD="Y"
					{
						s par(100000000002,MKBSDRowId)=""
					}
					else
					{
						s par(100000000000,MKBSDRowId)=""
					}
					s all(MKBSDRowId)=""
				}
				
			}
		}
	}
	if ($D(all)=0)    //没有完全匹配
	{
		s MKBSDRowId=0
		for
		{
			s MKBSDRowId=$O(^User.MKBICDContrastResultI("TermIndex",TermId,MKBSDRowId))
			q:MKBSDRowId=""
			s ICDDesc = $LG($G(^User.MKBICDContrastD(MKBSDRowId)),3)
			s ICDCode = $LG($G(^User.MKBICDContrastD(MKBSDRowId)),4)
			//s ICDDr = ##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).GetMRCIDByCodeDesc(ICDCode,ICDDesc)
			if (ICDNSFlag'="Y")
			{
				s ICDDr =##class(web.DHCBL.MKB.SDSDiagnosInterface).GetHISICDRowId(ICDCode,ICDDesc)
				continue:ICDDr=""
				//s MRCIDBillFlag3=$p($g(^MRC("ID",ICDDr)),"^",15) //中医诊断标志
				//continue:((MRCIDBillFlag3="Y")&&(IsChinaMed=0))	
			}
			s MKBSDInitialICD=$LG($G(^User.MKBICDContrastD(MKBSDRowId)),17) //最匹配短语
			s sequence=$o(^User.MKBICDContrastResultI("SeqIndex",MKBSDRowId,0))
			s MKBSDRRowId=$O(^User.MKBICDContrastResultI("TermIndex",TermId,MKBSDRowId,0))	
			s seq=$LG($G(^User.MKBICDContrastD(MKBSDRowId,"MKBICDContrastResult",MKBSDRRowId)),7)
			s MKBICDResult=$LG($G(^User.MKBICDContrastD(MKBSDRowId,"MKBICDContrastResult",MKBSDRRowId)),2)
			if (seq=sequence)&(MKBICDResult="")
			{
				if MKBSDInitialICD="Y"
				{
					s par(100000000001,MKBSDRowId)=""
				}
			}
			s MKBSDRRowId=0
			for
			{
				s MKBSDRRowId=$O(^User.MKBICDContrastResultI("TermIndex",TermId,MKBSDRowId,MKBSDRRowId))	
				q:MKBSDRRowId=""
				
				s ResultExp = $LG($G(^User.MKBICDContrastD(MKBSDRowId,"MKBICDContrastResult",MKBSDRRowId)),2)
				
				//s:Fre="" Fre=0
				if (ProDets="")
				{
					if (ResultExp="")
					{
						s par(1,MKBSDRowId)=""	
					}		
					continue
				}
				
				//该条记录匹配度
				
				s priority=0
				
				if (ResultExp="")
				{	
					s par(0,MKBSDRowId)=""	
					continue	
				}
				///存储子表中结构化结果的属性内容
				k resdets
				
				for i=1:1:$L(ResultExp,",")
				{
					s Pro=$P($P(ResultExp,",",i),":",1)
					s Dets=$P($P(ResultExp,",",i),":",2)
					continue:Pro=""
					continue:Dets=""
					for j=1:1:$L(Dets,"*")
					{
						s resdets(Pro,$P(Dets,"*",j))=""	
					}	
				}
				
				///end 存储
				
				///对子表每一个内容进行判断
				s ResPro=0
				for
				{
					s ResPro=$O(resdets(ResPro))
					q:ResPro=""
					
					s ResDet=0
					for
					{
						s ResDet=$O(resdets(ResPro,ResDet))
						q:ResDet=""
						
						if ($D(dets(ResPro,ResDet)))                  //ResultExp= 2:22*23
						{
							s priority=priority+dets(ResPro,ResDet)   //dets(2,22)=0.3   dets(2,23)=0.4
						}
					}	
				}
				///按权重存储
				///s par(priority*10,Fre,MKBSDRowId)=""
				s par(priority*10,MKBSDRowId)=""
			}	
		}
		;b:MKBSDRowId=764	
	}
	k unique
	s result = ""
	s priority = ""
	for 
	{
		s priority = $o(par(priority),-1)
		q:priority=""

			s MKBSDRowId=""
			s MKBSDICD=""
			for
			{
				s MKBSDRowId=$O(par(priority,MKBSDRowId))
				q:MKBSDRowId=""
			
				if $D(unique(MKBSDRowId))=0
				{
					s unique(MKBSDRowId)=""	
				}
				else
				{
					continue	
				}
				
			    s MKBSDICD=$LG($G(^User.MKBICDContrastD(MKBSDRowId)),6)
			    
			    if (MKBSDICD[version)
			    {
				s:result'="" result=result_","_MKBSDRowId
				s:result="" result=MKBSDRowId
			    }		
			}
	}		
	

	q result
}

/// Creator:陈代雷
/// CreatDate:2019-11-14
/// Description:根据id获取各版本ICD对照内容，并通过描述控制输出结果
/// Table:User.MKBICDContrast
/// Input:id: 各版本id，desc：描述
/// Return:诊断短语id^ICD代码^ICD描述^结构化TermDr^结构化Value^结构化补充诊断
/// w ##class(web.DHCBL.MKB.MKBICDContrastInterface).GetSameDiag(526474,"伤寒杆菌败血症")
ClassMethod GetSameDiag(id As %String, desc As %String)
{
	s result=""
	s id=$tr(id,"ICD","")
	s MKBSDRowid=0      //各版本ICD对照ID
	for
	{
		s MKBSDRowid=$o(^User.MKBICDContrastI("DescIndex"," "_$zconvert(desc,"U"),MKBSDRowid))
		q:MKBSDRowid=""
		s MKBICDDiaSource=$lg($g(^User.MKBICDContrastD(MKBSDRowid)),6)   //ICD版本ID
		//w MKBICDDiaSource_"MKBICDDiaSource",!
		continue:MKBICDDiaSource'[id
		//continue:MKBSDRowid["ICD"
		//continue:MKBSDRowid["L"
		//s (MKBSDDesc,MKBSDBase,MKBSDICD,MKBSDICDDesc)=""
		s MKBSDDesc=$lg($g(^User.MKBICDContrastD(MKBSDRowid)),3)    //描述 
		s MKBSDICD= $lg($g(^User.MKBICDContrastD(MKBSDRowid)),4)    //ICD编码
		s ChildSub=0
		s sequence=$o(^User.MKBICDContrastResultI("SeqIndex",MKBSDRowid,0))   //获得诊断结果中最小的顺序
		s ChildSub=$o(^User.MKBICDContrastResultI("SeqIndex",MKBSDRowid,sequence,ChildSub)) //通过父表ID和顺序找到子表ID
		continue:ChildSub=""
		s MKBSDResultTermdr=$lg($g(^User.MKBICDContrastD(MKBSDRowid,"MKBICDContrastResult",ChildSub)),4)  //结构化TermDr
		s MKBSDResultID=$lg($g(^User.MKBICDContrastD(MKBSDRowid,"MKBICDContrastResult",ChildSub)),2)  //结构化Value
		s MKBSDSupplement=$lg($g(^User.MKBICDContrastD(MKBSDRowid,"MKBICDContrastResult",ChildSub)),5)  //结构化补充诊断
		s result=MKBSDRowid_"^"_MKBSDICD_"^"_MKBSDDesc_"^"_MKBSDResultTermdr_"^"_MKBSDResultID_"^"_MKBSDSupplement
	}
	q result
}

/// d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBICDContrastInterface","GetICDForCMB","ICD526477","15879-18158:38122")
Query GetICDForCMB(version, str) As %Query(ROWSPEC = "DiagExp,MRCID,HISCode,HISDesc")
{
}

ClassMethod GetICDForCMBExecute(ByRef qHandle As %Binary, version, str) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s resultIds = ..GetDiagViaStruct(version,str)
	s version=$tr(version,"ICD","")
	if (resultIds'="")	
	{
		s MKBICRowId=0
		for i=1:1:$L(resultIds,",")
		{
			s MKBICRowId=$P(resultIds,",",i)
			
			s MKBICDDiaSource=$LG($G(^User.MKBICDContrastD(MKBICRowId)),6)
			s MRCID=""  
			s ICDCode=$LG($G(^User.MKBICDContrastD(MKBICRowId)),4)_$LG($G(^User.MKBICDContrastD(MKBICRowId)),5)
			s ICDDesc=$LG($G(^User.MKBICDContrastD(MKBICRowId)),3)
			if (MKBICDDiaSource[version)
			{
				s sortindex=$O(^User.MKBICDContrastResultI("SeqIndex",MKBICRowId,0))
				continue:sortindex=""
				s MKBICRChild=$O(^User.MKBICDContrastResultI("SeqIndex",MKBICRowId,sortindex,0))
					
				if (MKBICRChild'="")
				{
					s MKBICRTermDr=$LG($G(^User.MKBICDContrastD(MKBICRowId,"MKBICDContrastResult",MKBICRChild)),4)	
					if (MKBICRTermDr'="")
					{
						s MKBICRExpId = $LG($G(^User.MKBStructuredDataD(MKBICRowId,"MKBSDStructResult",MKBICRChild)),2)
						s DiagDesc = ##class(web.DHCBL.MKB.MKBStructuredData).GetChiForStrucIDs(MKBICRExpId,MKBICRTermDr)	
						
						d OutputRowCMB	
					}
					
				}	
			}
			
			
		}	
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCMB
    set Data=$lb(DiagDesc,MRCID,ICDCode,ICDDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetICDForCMBClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetICDForCMBExecute ]
{

	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetICDForCMBFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetICDForCMBExecute ]
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

/// Creator:陈代雷
/// CreatDate:2019-12-09
/// Description:导出各版本ICD对照中诊断的实际匹配结果
/// Table:User.MKBICDContrast
/// Input: ICDDiaSource ：诊断短语数据来源id
/// Return:ICD描述,结构化结果,实际匹配结果,是否完全匹配
/// d ##class(web.DHCBL.MKB.MKBICDContrastInterface).ExportICDResult(526477)
ClassMethod ExportICDResult(ICDDiaSource As %String)
{
	s sum=0
	s DiaSourceDesc=$lg($g(^User.MKBTermD(ICDDiaSource)),3)   //诊断来源描述 
	s Path=##class(%File).GetDirectory() //D:\DtHealth\db\dthis\data\
	s Disk=$p(Path,":",1) //截取盘符
	s fileName=DiaSourceDesc_"实际匹配结果.csv"
	s P=Disk_":\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\"_fileName
	s file=##class(%File).%New(P)
	//s file=##class(%File).%New("E:/DataFile/各版本ICD对照实际匹配结果.csv")
	d file.Open("NWS")
	d file.WriteLine("ICD描述,结构化结果,ICD编码,实际匹配结果,是否完全匹配")
	s MKBICDRowId=0    
	for           //遍历各版本ICD对照表
	{
		s MKBICDRowId = $o(^User.MKBICDContrastD(MKBICDRowId))
		q:MKBICDRowId=""
		s MKBICDDiaSource=$lg($g(^User.MKBICDContrastD(MKBICDRowId)),6)  //诊断短语数据来源
		if (MKBICDDiaSource'[ICDDiaSource)   //过滤掉不是该版本的数据
		{
			continue
		}
		s MKBICDConDesc=$lg($g(^User.MKBICDContrastD(MKBICDRowId)),3)   //ICD描述
		s MKBICDNumber=$lg($g(^User.MKBICDContrastD(MKBICDRowId)),4) //ICD编码
		s sequence=$o(^User.MKBICDContrastResultI("SeqIndex",MKBICDRowId,0))   //获得诊断结果中最小的顺序
		if (sequence'="")
		{
			s MKBICDResultId=$o(^User.MKBICDContrastResultI("SeqIndex",MKBICDRowId,sequence,0)) //通过父表ID和顺序找到子表ID
		}
		else
		{
			s MKBICDResultId=""
		}
		//s MKBICDResultId =$o(^User.MKBICDContrastResultI("MKBICDContrastIndex",MKBICDRowId,0))  //结构化结果子表ID
		if (MKBICDResultId="")    //是否有结构化结果
		{
			s ICDResult=""
			s Matching="否"
			s RealMatchDia=""
		}
		else
		{
			s MKBICDResult=$lg($g(^User.MKBICDContrastD(MKBICDRowId,"MKBICDContrastResult",MKBICDResultId)),2)  //结构化结果的ID串
			s MKBICDTerm=$lg($g(^User.MKBICDContrastD(MKBICDRowId,"MKBICDContrastResult",MKBICDResultId)),4)
			s ICDResult=##class(web.DHCBL.MKB.MKBStructuredData).StdGetChiForNewSeqStrucIDs(MKBICDResult,MKBICDTerm)  //结构化结果描述
			s RealMatchDiaId=$p(..GetDiagViaStruct(ICDDiaSource,MKBICDTerm_"-"_MKBICDResult),",",1)   //实际匹配结果
			if (RealMatchDiaId="")
			{
				s RealMatchDia=""
			}
			else
			{
				s RealMatchDia=$LISTGET($G(^User.MKBICDContrastD(RealMatchDiaId)),3) 
			}
			s Matching="否"
			if (MKBICDConDesc=RealMatchDia)
			{
				s Matching="是"
			}
		}
		s MKBICDConDesc=$replace(MKBICDConDesc,",","，")
		s MKBICDNumber=$replace(MKBICDNumber,",","，")
		s ICDResult=$replace(ICDResult,",","，")
		s RealMatchDia=$replace(RealMatchDia,",","，")
		s str=MKBICDConDesc_","_ICDResult_","_MKBICDNumber_","_RealMatchDia_","_Matching
		d file.WriteLine(str)
		s sum = sum+1

	}
	d file.%Save()
	d file.%Close()
	//w sum 
	q "{fileName:"""_fileName_"""}"
	//q fileName
}

}
