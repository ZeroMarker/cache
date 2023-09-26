Class web.DHCBL.MKB.MKBContextSearch Extends %RegisteredObject
{

/// CreateDate:2017-11-20
/// Creator:李欣
/// Description:针对描述长度（十为界限）生成查询索引
/// Input:desc : 搜索关键字
/// Return:flag:0为正常,1为不存在该数据
/// w ##class(web.DHCBL.MKB.MKBContextSearch).GetIndex("肺癌")
ClassMethod GetIndex(desc, spaceorder)
{

	s len = $l(desc)
	s flag = 0
	s lennum = len\10
	s:lennum*10<len lennum=lennum+1
	if (len>10)
	{
		
		for l=1:1:lennum
		{	
			s:l'=lennum descT = $e(desc,l-1*10+1,l*10)
			s:l=lennum descT=$e(desc,l-1*10+1,len)
			s descI = " "_$ZCONVERT(descT,"U")
			
			if ($D(^User.BDPMKBIndexI("DescIndex",descI))=0)
			{
				s flag=1
				q	
			}
			s IDStr=""
			for
			{
				s IDStr = $O(^User.BDPMKBIndexI("DescIndex",descI,IDStr))
				q:IDStr=""
				
				if (l=1)
				{
					s ^TMP("MKB","MKBIndex","IDStr",IDStr)=1
				}
				else
				{
					if $D(^TMP("MKB","MKBIndex","IDStr",IDStr))
					{
						s ^TMP("MKB","MKBIndex","IDStr",IDStr)=^TMP("MKB","MKBIndex","IDStr",IDStr)+1
					}
					else
					{
						s ^TMP("MKB","MKBIndex","IDStr",IDStr)	=1	
					}
				}
			}	
		}
		s IDStr = ""
		for
		{
			s IDStr = $O(^TMP("MKB","MKBIndex","IDStr",IDStr))
			q:IDStr=""
			continue:^TMP("MKB","MKBIndex","IDStr",IDStr)'=lennum
			if (IDStr["D")
			{
				s TermID = $p(IDStr,"D",1)
				s DetID = $p(IDStr,"D",2)
			}
			else
			{
				s TermID = IDStr
				s DetID = 0	
			}	
			if ($D(^TMP("MKB","MKBIndex","Data",TermID))=0)
			{
				s ^TMP("MKB","MKBIndex","Data",TermID,DetID)=1
				s ^TMP("MKB","MKBIndex","space",TermID,spaceorder)=""
			}
			else
			{
				if (DetID'=0)
				{
					k ^TMP("MKB","MKBIndex","Data",TermID,0)
					s ^TMP("MKB","MKBIndex","Data",TermID,DetID)=1	
				}
				else
				{
					if ($D(^TMP("MKB","MKBIndex","Data",TermID,DetID))=0)
					{
						s ^TMP("MKB","MKBIndex","Data",TermID,DetID)= 1	
					}
					else
					{
						s ^TMP("MKB","MKBIndex","Data",TermID,DetID)=^TMP("MKB","MKBIndex","Data",TermID,DetID)+1		
					}
				}
			}
		}
	}
	else
	{
		s descI = " "_$ZCONVERT(desc,"U")
		if ($D(^User.BDPMKBIndexI("DescIndex",descI))=0)
		{
			s flag=1
			q flag		
		}
		s IDStr=""
		for
		{
			s IDStr = $O(^User.BDPMKBIndexI("DescIndex",descI,IDStr))
			Q:IDStr=""
			
			if (IDStr["D")
			{
				s TermID = $p(IDStr,"D",1)
				s DetID = $p(IDStr,"D",2)
			}
			else
			{
				s TermID = IDStr
				s DetID = 0	
			}
			s ^TMP("MKB","MKBIndex","space",TermID,spaceorder)=""
			if ($D(^TMP("MKB","MKBIndex","Data",TermID))=0)
			{
				s ^TMP("MKB","MKBIndex","Data",TermID,DetID)=1		
				
			}
			else
			{
				if (DetID'=0)
				{
					k ^TMP("MKB","MKBIndex","Data",TermID,0)
					s ^TMP("MKB","MKBIndex","Data",TermID,DetID)=1	
				}
				else
				{
					if ($D(^TMP("MKB","MKBIndex","Data",TermID,DetID))=0)
					{
						s ^TMP("MKB","MKBIndex","Data",TermID,DetID)= 1	
					}
					else
					{
						s ^TMP("MKB","MKBIndex","Data",TermID,DetID)=^TMP("MKB","MKBIndex","Data",TermID,DetID)+1		
					}
							
				}
			}
			
		}	
	}
	/*
	s TermID=0
	for
	{
		s TermID = $O(^TMP("MKB","MKBIndex","Data",spaceorder,TermID))
		q:TermID=""
		
		s DetID=""
		for
		{
			s DetID = $O(^TMP("MKB","MKBIndex","Data",spaceorder,TermID,DetID))
			q:DetID=""
			
			for i =1:1:^TMP("MKB","MKBIndex","Data",spaceorder,TermID,DetID)
			{
				 k ^TMP("MKB","MKBIndex","SortData",i,TermID,DetID)
			}
			if (DetID=0)
			{
				s ^TMP("MKB","MKBIndex","SortData",^TMP("MKB","MKBIndex","Data",TermID,DetID)+0.5,TermID,DetID)=""			
			}
			else
			{
				s ^TMP("MKB","MKBIndex","SortData",^TMP("MKB","MKBIndex","Data",TermID,DetID),TermID,DetID)=""				
			}
		}	
	}
	*/
	q flag
}

ClassMethod ReDealTime()
{
	s TermID=0
	for
	{
		s TermID = $O(^TMP("MKB","MKBIndex","Data",TermID))
		q:TermID=""
		
		s ^TMP("MKB","MKBIndex","Data",TermID) = 0 
		s DetID=""
		for
		{
			s DetID = $O(^TMP("MKB","MKBIndex","Data",TermID,DetID))
			q:DetID=""
			
			s ^TMP("MKB","MKBIndex","Data",TermID) = ^TMP("MKB","MKBIndex","Data",TermID)+^TMP("MKB","MKBIndex","Data",TermID,DetID)	
		}
	}
}

ClassMethod SpaceDeal(spacelen)
{
	d ..ReDealTime()
	s TermID=0
	for
	{
		s TermID = $O(^TMP("MKB","MKBIndex","Data",TermID))
		q:TermID=""
		
		s max = 0
		
		s DetID=""
		
		;for
		;{
			;s DetID = $O(^TMP("MKB","MKBIndex","Data",TermID,DetID))
			;q:DetID=""
			
			s time=0
			for k=1:1:spacelen
			/*{
				if ($D(^TMP("MKB","MKBIndex","space",TermID,DetID,k))'=0)	
				{
					s time=time+1
				}
			}*/
			{
				if ($D(^TMP("MKB","MKBIndex","space",TermID,k))'=0)	
				{
					s time=time+1
				}
			}
			s:max<time max=time
		;}
		
		if ($D(^TMP("MKB","MKBIndex","space",TermID,"all"))'=0)                   //fwkadd
		{
			s max = "all"
		}
		 
		for
		{
			s DetID = $O(^TMP("MKB","MKBIndex","Data",TermID,DetID))
			q:DetID=""
			
			if (DetID=0)
			{
				s ^TMP("MKB","MKBIndex","SortData",max,^TMP("MKB","MKBIndex","Data",TermID)+0.5,TermID,DetID)=""			
			}
			else
			{
				s ^TMP("MKB","MKBIndex","SortData",max,^TMP("MKB","MKBIndex","Data",TermID),TermID,DetID)=""				
			}	
		}	
	}
}

/*
<div class="childdiv">
<span><a href="#">阑尾感染性疾病</a></span></br>
<span>&nbsp;&nbsp;&nbsp;<span class='pinkblue'>【映射<span class='red'>ICD</span>北京版】</span><span class='red'>ICD</span>北京版代码：C35.001;<span class='red'>ICD</span>北京版释义：急性阑尾炎伴穿孔;诊断中心词:阑尾感染性疾病</span></br>
<span>&nbsp;&nbsp;&nbsp;<span class='pinkblue'>【初始<span class='red'>ICD</span>】</span><span class='red'>ICD</span>代码：K35.007;<span class='red'>ICD</span>释义：急性坏疽性阑尾炎伴弥漫性腹膜炎</span></br>
<span>&nbsp;&nbsp;<span class='gray'>代码:ZD0002695,常用名:阑尾炎,备注:无</span></span></br></br>
</div>

*/
/// CreateDate:2017-11-20
/// Creator:李欣
/// Description:根据索引拿到对应数据进行拼串
/// Input:desc : 搜索关键字
/// Return:^TMP("MKB","MKBDiv",order,1or2or3)	 
/// w ##class(web.DHCBL.MKB.MKBContextSearch).ContextData("其他病历文书所需疾病史")
ClassMethod ContextData(desc As %String, id As %String) As %String
{
	k ^TMP("MKB","MKBIndex","IDStr")
	k ^TMP("MKB","MKBIndex","Data")
	k ^TMP("MKB","MKBIndex","SortData")
	k ^TMP("MKB","MKBIndex","space")
	k ^TMP("MKB","MKBTermbasedr")
	
	s termnum= $l(id,",")
	for tn=1:1:termnum
	{
		s tempid = $p(id,",",tn)
		continue:tempid=""
		s ^TMP("MKB","MKBTermbasedr",tempid)=""
	}

	
	s desc = $ZCONVERT(desc,"U")
	s dlen = $L(desc," ")
	s flag=""
	for k=1:1:dlen
	{
		s space(k)=$P(desc," ",k)
		s re = ..GetIndex(space(k),k)	
		s flag=flag_""_re
		
	}
	d ..QWJSPPYH(desc,dlen)
	if (flag'["0")
	{
		s flag=1	
	}
	else
	{
		s flag=0	
	}
	//s flag = ..GetIndex(desc)
	//s flag = ..GetAdvancedIndex(desc)
	q:flag=1 "error"
	d ..SpaceDeal(dlen)
	
	k ^TMP("MKB","MKBDiv")

	s i = 1
	
	s spacetime = ""
	for
	{
		s spacetime =$o(^TMP("MKB","MKBIndex","SortData",spacetime),-1)
		q:spacetime=""
	;}
	;for spacetime = dlen:-1:1
	;{
		s time=""
		for
		{
			s time = $O(^TMP("MKB","MKBIndex","SortData",spacetime,time),-1)
			q:time=""
			s MKBTRowId = 0
			for 
			{
				s MKBTRowId = $o(^TMP("MKB","MKBIndex","SortData",spacetime,time,MKBTRowId))
				q:MKBTRowId=""
				s tip=""
				s MKBTCode = $LG($G(^User.MKBTermD(MKBTRowId)),2) //代码
				s MKBTCode = ..EvalJSON(MKBTCode)
				s MKBTCodeU = $ZCONVERT(MKBTCode,"U")
				
				s MKBTDesc = $LG($G(^User.MKBTermD(MKBTRowId)),3)
				s MKBTDesc = ..EvalJSON(MKBTDesc)
				s MKBTDesc = $ZCONVERT(MKBTDesc,"U")
				
				s MKBTBaseDR = $LG($G(^User.MKBTermD(MKBTRowId)),4)
				continue:MKBTBaseDR=""
				continue:'$d(^TMP("MKB","MKBTermbasedr",MKBTBaseDR))
				s MKBTBCode = $LG($G(^User.MKBTermBaseD(MKBTBaseDR)),2)
				s MKBTBDesc = $LG($G(^User.MKBTermBaseD(MKBTBaseDR)),3)
				//continue:((MKBTBaseDR=1)||(MKBTBaseDR=23)||(MKBTBaseDR=35))
				s MKBTPYCode = $LG($G(^User.MKBTermD(MKBTRowId)),6)
				s MKBTPYCode = $ZCONVERT(MKBTPYCode,"U")
				
				s MKBTNote = $LG($G(^User.MKBTermD(MKBTRowId)),7)
				
				s strCom=..GetComOrAlias(MKBTRowId)
			    s comDesc=$p(strCom,"||",1)	//常用名描述
			    s comDesc=..EvalJSON(comDesc)
			    s comKey=$p(strCom,"||",2)	//常用名拼音码
			    s comKey=..EvalJSON(comKey)
			    s Flag=""
				s tip = "<span class='term'>"
				s count=0
				if (..GetContainFlag(.space,MKBTDesc)="Y")
				{
					s tip = tip_"<a href='javascript:void(0)' onClick='goTerm("""_MKBTBCode_""","""_MKBTBDesc_""","""_MKBTRowId_""","""","""")'><span class='blue'>【术语】</span></a>中心词:"_..ReplaceAll(.space,MKBTDesc)
					s count = 1
					s Flag=1
				}
				if (..GetContainFlag(.space,MKBTNote)="Y")
				{
					i (count=0)
					{
						s tip = tip_"<a href='javascript:void(0)' onClick='goTerm("""_MKBTBCode_""","""_MKBTBDesc_""","""_MKBTRowId_""","""","""")'>【术语】</a>备注:"_..ReplaceAll(.space,MKBTNote)
						s count = 1		
					}
					else
					{
						s tip = tip_" 备注:"_..ReplaceAll(.space,MKBTNote)
					}
					s Flag=1	
				}
				if (..GetContainFlag(.space,MKBTPYCode)="Y")
				{
					i (count=0)
					{				
						s tip = tip_"<a href='javascript:void(0)' onClick='goTerm("""_MKBTBCode_""","""_MKBTBDesc_""","""_MKBTRowId_""","""","""")'>【术语】</a>检索码:"_..ReplaceAll(.space,MKBTPYCode)
						s count = 1
					}
					else
					{
						s tip = tip_" 检索码:"_..ReplaceAll(.space,MKBTPYCode)

					}	
					s Flag=1
				}
				if (..GetContainFlag(.space,comDesc)="Y")
				{
					i (count=0)
					{
						s tip = tip_"<a href='javascript:void(0)' onClick='goTerm("""_MKBTBCode_""","""_MKBTBDesc_""","""_MKBTRowId_""","""","""")'>【术语】</a>常用名:"_..ReplaceAll(.space,comDesc)
						s count = 1		
					}
					else
					{
						s tip = tip_" 常用名:"_..ReplaceAll(.space,comDesc)
					}	
					s Flag=1
				}
				if (..GetContainFlag(.space,comKey)="Y")
				{
					i (count=0)
					{
						s tip = tip_"<a href='javascript:void(0)' onClick='goTerm("""_MKBTBCode_""","""_MKBTBDesc_""","""_MKBTRowId_""","""","""")'>【术语】</a>常用名拼音码:"_..ReplaceAll(.space,comKey)
						s count = 1		
					}
					else
					{
						s tip = tip_" 常用名拼音码:"_..ReplaceAll(.space,comKey)
					}	
					s Flag=1
				}
				s tip=tip_"</span></br><div id='tip"_i_"' class='tipcontent'>"
				s MKBTPDRowId=0
				for	
				{
					s MKBTPDRowId = $o(^TMP("MKB","MKBIndex","SortData",spacetime,time,MKBTRowId,MKBTPDRowId)) //属性内容ID
					q:MKBTPDRowId=""
					
					s tempDetId=MKBTPDRowId
					s MKBTPDDesc = $LG($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)
					s MKBTPDDesc = ..EvalJSON(MKBTPDDesc)
					s MKBTPDDesc = $ZCONVERT(MKBTPDDesc,"U")
					
					s MKBTPDRemark = $LG($G(^User.MKBTermProDetailD(MKBTPDRowId)),7)
					s MKBTPDRemark= ..EvalJSON(MKBTPDRemark)
					s MKBTPDRemark=$ZCONVERT(MKBTPDRemark,"U")
							
					s MKBTProId = $LG($G(^User.MKBTermProDetailD(MKBTPDRowId)),6)
					continue:MKBTProId=""
					s MKBTProDesc = $LG($G(^User.MKBTermPropertyD(MKBTProId)),3)
					s MKBTProDesc = ..EvalJSON(MKBTProDesc)
					s MKBTProDesc = $ZCONVERT(MKBTProDesc,"U")
					
					s MKBTProType = $LG($G(^User.MKBTermPropertyD(MKBTProId)),4)
					
					s MKBTProName = $LG($G(^User.MKBTermPropertyD(MKBTProId)),7)
					s MKBTProName = ..EvalJSON(MKBTProName)
					s MKBTProName = $ZCONVERT(MKBTProName,"U")
					
					if (MKBTProType="S")
					{
						s tempDetId=MKBTPDDesc
						s MKBTPDDesc = $LG($G(^User.MKBTermD(MKBTPDDesc)),3)
						s MKBTPDDesc = ..EvalJSON(MKBTPDDesc)
						s MKBTPDDesc = $ZCONVERT(MKBTPDDesc,"U")
						
					}
					s tip = tip_"<span class='pro'>"
					s count = 0
					if (..GetContainFlag(.space,MKBTPDDesc)="Y")	
					{
						s tip = tip_"<span class='pinkblue'><a href='javascript:void(0)' onClick='goTerm("""_MKBTBCode_""","""_MKBTBDesc_""","""_MKBTRowId_""","""_MKBTProId_""","""_tempDetId_""")'>【"_..ReplaceAll(.space,MKBTProDesc)_"】</a></span>"_MKBTProName_":"_..ReplaceAll(.space,MKBTPDDesc)
						s count = 1
						s Flag=1
					}
					if (..GetContainFlag(.space,MKBTPDRemark)="Y")
					{
						if (count=1)
						{
							s tip = tip_" 备注:"_..ReplaceAll(.space,MKBTPDRemark)
						}
						else
						{
							s tip = tip_"<span class='pinkblue'><a href='javascript:void(0)' onClick='goTerm("""_MKBTBCode_""","""_MKBTBDesc_""","""_MKBTRowId_""","""_MKBTProId_""","""_tempDetId_""")'>【"_..ReplaceAll(.space,MKBTProDesc)_"】</a></span>备注:"_..ReplaceAll(.space,MKBTPDRemark)
							s count = 1
						}
						s Flag=1	
					}
					s MKBTEPRowId = 0
					for
					{
						s MKBTEPRowId = $O(^User.MKBTermExtendProValI("ValIndex",MKBTPDRowId,MKBTEPRowId))	
						q:MKBTEPRowId=""
						
						s MKBTEPDesc = $LG($G(^User.MKBTermPropertyD($P(MKBTEPRowId,"||",1),"ChildExtPro",$P(MKBTEPRowId,"||",2))),2)
						s MKBTEPVRowId = $O(^User.MKBTermExtendProValI("ValIndex",MKBTPDRowId,MKBTEPRowId,0))	
						s MKBTEPVDesc = $LG($G(^User.MKBTermExtendProValD(MKBTEPVRowId)),4)
						s MKBTEPVDesc = ..EvalJSON(MKBTEPVDesc)
						s MKBTEPVDesc = $ZCONVERT(MKBTEPVDesc,"U")
						
						if (..GetContainFlag(.space,MKBTEPVDesc)="Y")
						{
							if (count=1)
							{
								s tip=tip_" "_MKBTEPDesc_":"_..ReplaceAll(.space,MKBTEPVDesc)
							}
							else
							{
								s tip = tip_"<span class='pinkblue'><a href='javascript:void(0)' onClick='goTerm("""_MKBTBCode_""","""_MKBTBDesc_""","""_MKBTRowId_""","""_MKBTProId_""","""_tempDetId_""")'>【"_..ReplaceAll(.space,MKBTProDesc)_"】</a></span>"_MKBTEPDesc_":"_..ReplaceAll(.space,MKBTEPVDesc)
								s count = 1 		
							}
							s Flag=1
						}
					}
					s tip = tip_"</span></br>"
				}
				s tip=tip_"</div>"
				s tip=..Replace(tip,"<span></span></br>","")
				s tip=..Replace(tip,"<span class='term'></span></br>","")
				continue:tip=""
				s:MKBTNote="" MKBTNote="无"
				s:$L(MKBTNote)>30 MKBTNote=$E(MKBTNote,1,30)_"...."
				s tip="<div><span class='term'><a onClick='goTerm("""_MKBTBCode_""","""_MKBTBDesc_""","""_MKBTRowId_""","""","""")'>"_..ReplaceAll(.space,MKBTDesc)_"</a></span><font size='4' color='#3CBBAA'>【"_MKBTBDesc_"】</font></br>"_tip_"</div>"
				s tip = tip_"<span><span class='gray'>代码:"_MKBTCode_",常用名:"_comDesc_",备注:"_MKBTNote_",拼音码:"_MKBTPYCode_"</span></span></br></br>"
				s tip="<div class='childdiv'>"_tip_"<a href='javascript:void(0)' id='btn"_i_"' onclick='hideandmore(this)'>查看更多</a></div>"
				s ^TMP("MKB","MKBDiv",i)=tip	
				s i = i + 1
				
			}
				
		}
		
	}
	
	q i-1
}

/// w ##class(web.DHCBL.MKB.MKBContextSearch).ReplaceAll(.space,"小细胞型肺癌")
ClassMethod ReplaceAll(ByRef a, str)
{
	s i=0
	for
	{
		s i=$O(a(i))
		q:i=""
		
		s str = ..Replace(str,a(i),"<font class='red'>"_a(i)_"</font>")		
	}
	q str
}

ClassMethod GetContainFlag(ByRef a, str)
{
	s flag="N"
	s i=0
	for
	{
		s i=$O(a(i))
		q:i=""
		
		if (str[a(i))
		{
			s flag="Y"	
		}	
	}
	q flag
}

/// w ##class(web.DHCBL.MKB.MKBContextSearch).SearchContext(1,4)
ClassMethod SearchContext(start, end)
{
	s result=""
	for i=start:1:end
	{
		s result=result_$g(^TMP("MKB","MKBDiv",i))
	}	
	q result
}

/// 要求被替换的内容不能=""
ClassMethod Replace(instr As %String, substr As %String, replacement As %String) As %String
{
	;w ..Replace()
	q:(substr="") instr
	;q:(replacement="") instr
	q:'($l(instr,substr)>1) instr
	
	s mylen=$l(instr,substr)
	for myIdx=1:1:mylen {
		s myary(myIdx)=$p(instr,substr, myIdx)
	}
	
	s mystr=""
	s myIdx=""
	s myIdx=$o(myary(myIdx))
	while (myIdx'=""){
		s myrepstr=""
		i ($o(myary(myIdx))=""){
			s myrepstr=myary(myIdx)
		}else{
			s myrepstr=myary(myIdx)_replacement
		}
		
		i (mystr=""){
			s mystr=myrepstr
		}else{
			s mystr=mystr_myrepstr
		}
		
		s myIdx=$o(myary(myIdx))
		q:(myIdx="")
	}
	
	q mystr
}

/// Description：获取常用名/别名列表(AL)及拼音码
/// Table：User.MKBTermProperty
/// Input：termdr
/// Return:常用名/别名列表(AL)||拼音码
/// Date:2018-05-16
/// creator：丁亚楠
/// Other:w ##class(web.DHCBL.MKB.MKBKnoExpreesion).GetComOrAlias(14626)
/// Description:获取常用名(C)或别名(A)||拼音码
ClassMethod GetComOrAlias(termdr As %String) As %String
{
	q:(termdr="") ""
	q:('$d(^User.MKBTermPropertyI("FlagIndex",termdr," AL"))) ""
	s str="",keyStr=""
	
	s MKBTPRowId=$o(^User.MKBTermPropertyI("FlagIndex",termdr," AL",0)) 
	s MKBTPDRowId=0
	for  
	{	
		s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,MKBTPDRowId)) q:MKBTPDRowId="" 
		s MKBTPDDesc=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)
		s MKBTPDDesc= ..EvalJSON(MKBTPDDesc)
		
		s subId=0  //循环扩展属性子表User.MKBTermProperty
		for 
		{
			S subId=$o(^User.MKBTermPropertyD(MKBTPRowId,"ChildExtPro",subId)) q:subId=""
			s MKBTEPRowId=MKBTPRowId_"||"_subId  //扩展属性表的ID
			s MKBTEPName=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId,"ChildExtPro",subId)),2)   //扩展属性名称
			continue:MKBTEPName'="检索码"
			s MKBTEPVRowId=$o(^User.MKBTermExtendProValI("ValIndex",MKBTPDRowId,MKBTEPRowId,0))  //扩展属性内容表的id
			s MKBTEPVValue=""
	        s:MKBTEPVRowId'="" MKBTEPVValue=$LISTGET($G(^User.MKBTermExtendProValD(MKBTEPVRowId)),4) //扩展属性内容的值
			s MKBTEPVValue=..EvalJSON(MKBTEPVValue)	
			s:keyStr'="" keyStr=keyStr_","_MKBTEPVValue
			s:keyStr="" keyStr=MKBTEPVValue	
		}

		s:str'="" str=str_","_MKBTPDDesc
		s:str="" str=MKBTPDDesc	
		
	}
 	q str_"||"_keyStr
}

/// CreateDate:2018-05-19
/// Creator:李欣
/// Description:处理字符串中特殊字符
/// Input:desc : 带处理字符串
/// Return: 处理后字符串
/// w ##class(web.DHCBL.MKB.MKBContextSearch).EvalJSON("112a/asd")
ClassMethod EvalJSON(desc)
{
	q:desc="" desc
	
	s:desc["[" desc=$tr(desc,"[","")
	
	s:desc["]" desc=$tr(desc,"]","")
	
	s:desc["(" desc=$tr(desc,"(","")
	
	s:desc[")" desc=$tr(desc,")","")
	
	s:desc["/" desc=$tr(desc,"/","")
	
	s:desc["</br>" desc=$tr(desc,"</br>","")
	
	s:desc["<br>" desc=$tr(desc,"<br>","")
	
	q desc
}

/// CreateDate:2019-09-25
/// Creator:范文凯
/// Description:得到全文检索包含的知识库
/// Input:desc : 
/// Return: 知识库的id
/// w ##class(web.DHCBL.MKB.MKBContextSearch).QWJSZSK()
ClassMethod QWJSZSK()
{
	s result = ""
	s SYFLid = $o(^User.MKBTermBaseI("DescIndex"," 术语分类",0))                    //获得术语分类的id
	s QWJSid = $o(^User.MKBTermI("DescIndex",SYFLid," 全文检索",0))                 //获得全文检索的id
	s termbaseid = 0
	for
	{
		s termbaseid = $o(^User.MKBTermBaseD(termbaseid))
		q:termbaseid=""
		s MKBTBCatDr = $lg($g(^User.MKBTermBaseD(termbaseid)),9)                    //取到知识库的术语分类  判断是否属于全文检索 即是否含有全文检索的id
		s CatDrnum = $l(MKBTBCatDr,"&%")
		for i=1:1:CatDrnum
		{
			s CatDr = $p(MKBTBCatDr,"&%",i)
			if (CatDr = QWJSid)
			{
				;s termdesc = $lg($g(^User.MKBTermBaseD(termbaseid)),3)
				s result = result_termbaseid_","
			}
		}
		
	}
	s result = $e(result,0,*-1)
	q result
}

/// Creator:范文凯
/// CreatDate:2019-09-26
/// Description：获得带有全文检索标识的知识库termbaseid
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBContextSearch","GetTermBase")
Query GetTermBase() As %Query(ROWSPEC = "TermBaseID, TermBaseDesc")
{
}

ClassMethod GetTermBaseExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	s SYFLid = $o(^User.MKBTermBaseI("DescIndex"," 术语分类",0))                    //获得术语分类的id
	s QWJSid = $o(^User.MKBTermI("DescIndex",SYFLid," 全文检索",0))                 //获得全文检索的id
	s TermBaseID = 0
	for
	{
		s TermBaseID = $o(^User.MKBTermBaseD(TermBaseID))
		q:TermBaseID=""
		s MKBTBCatDr = $lg($g(^User.MKBTermBaseD(TermBaseID)),9)                    //取到知识库的术语分类  判断是否属于全文检索 即是否含有全文检索的id
		s CatDrnum = $l(MKBTBCatDr,"&%")
		for i=1:1:CatDrnum
		{
			s CatDr = $p(MKBTBCatDr,"&%",i)
			if (CatDr = QWJSid)
			{
				s TermBaseDesc = $lg($g(^User.MKBTermBaseD(TermBaseID)),3)
				d OutputRow8
			}
		}
		
	}
    
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(TermBaseID, TermBaseDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetTermBaseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCTPMExecute ]
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

ClassMethod GetTermBaseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTermBaseExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// CreateDate:2019-09-29
/// Creator:范文凯
/// Description:多关键字全文检索，优秀返回MKBTermDesc都匹配的 Term。   QWJSPPYH（全文检索匹配优化）
/// Input:desc ，dlen
/// Return: 知识库的id
/// w ##class(web.DHCBL.MKB.MKBContextSearch).QWJSPPYH()
ClassMethod QWJSPPYH(desc, dlen)
{
	s termid=0
	for
	{
		s flag = 1
		s termid = $o(^TMP("MKB","MKBIndex","Data",termid))
		q:termid=""
		continue:(($D(^TMP("MKB","MKBIndex","space",termid,dlen)))=0)
		s termdesc= $lg($g(^User.MKBTermD(termid)),3)                      //取到术语描述
		for i=1:1:dlen
		{
			s descjs(i)=$p(desc," ",i)
			if (termdesc[descjs(i))
			{
				s flag(i)=1
			}
			else
			{
				s flag(i)=0
			}
		}
		for j=1:1:dlen
		{
			if ($g(flag(j))=0)
			{
				s flag=0                                   //有一个不满足的就令整体的flag=0
			}
		}
		if (flag=1)

		{
			s ^TMP("MKB","MKBIndex","space",termid,"all")=""
		}
	}
	q ""
}

}
