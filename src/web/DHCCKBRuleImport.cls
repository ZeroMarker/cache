Import sqluser

Class web.DHCCKBRuleImport Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description:	临时存储导入数据
/// Creator:		QuNianpeng
/// CreateDate:		2019-07-04
/// Input:			pid,行,数据
/// return:			
/// other:			
/// w ##class(web.DHCCKBRuleImport).TmpImportData(20,"")
ClassMethod TmpImportData(pid, mListData)
{

	n (pid,mListData)
	
	i $CLASSNAME(mListData)="%CSP.CharacterStream" d
	.d ..InsTmpGlobalStream(pid, mListData)
	e  d
	.d ..InsTmpGlobalString(pid, mListData)
	q 0
}

/// Descript: 临时存储数据[流]
/// W ##Class(web.DHCCKBRuleImport).InsTmpGlobalStream("1","")
ClassMethod InsTmpGlobalStream(pid As %String, mListData) As %String
{
	n (pid, mListData)

	s spac="[next]"
	s rowspac="[row]"
	k TmpGlobal	
	
	d mListData.Rewind()
	while (mListData.AtEnd = 0) { 
		s IOStrLen=5000			
		s listData=mListData.Read(.IOStrLen)
		s connetData=$g(TmpGlobal(1))_""_listData	
		i connetData[rowspac  d
		.f i=1:1:$L(connetData,rowspac) d
	    ..s mData=$p(connetData,rowspac,i)
	    ..i mData[$c(2) d	   
	    ...s row=$I(^TMP("Num",pid))	
	   	...s ^TMP("DHCCKB","web.DHCCKBRuleImport","TmpImportData",pid,row)=$p(mData,$c(2))
	   	...k TmpGlobal(1)
	   	...s TmpGlobal(1)=$p(mData,$c(2),2)	//[row]被分开
		..e  d
		...s TmpGlobal(1)=mData
		e  d
		.//s TmpGlobal(1)=$g(TmpGlobal(1))_""_connetData
		.s TmpGlobal(1)=connetData			
	}
	
	if $g(TmpGlobal(1))[$c(2) d
	.s row=$I(^TMP("Num",pid))
	.s ^TMP("DHCCKB","web.DHCCKBRuleImport","TmpImportData",pid,row)=$p($g(TmpGlobal(1)),$c(2))
	
	k TmpGlobal
	q ""
}

/// Descript: 临时存储数据[字符串]
/// W ##Class(web.DHCCKBRuleImport).InsTmpGlobal("1","")
ClassMethod InsTmpGlobalString(pid As %String, mListData) As %String
{
	n (pid, mListData)
	
	s spac="[next]"
	s rowspac="[row]"
	F i=1:1:$L(mListData,rowspac) D
	.s listData=$p(mListData,rowspac,i)
	.//s row=$p(listData,spac,1)+1	// 序号
	.s row=$I(^TMP("Num",pid))
	.s listData=$tr(listData,$c(2),"")
	.s ^TMP("DHCCKB","web.DHCCKBRuleImport","TmpImportData",pid,row)=listData
	.
	Q ""
}

/// w ##class(web.DHCCKBRuleImport).SaveRule(1577346229615)
ClassMethod SaveRule(pid, loginInfo)
{
	n (pid,loginInfo)
	

	s mDel=""		// 空字符
	s spec="[next]"	// 分隔符
	set $ZT="ERROR" // 设置一个异常
	s total=0,successNum=0,errNum=0 // 计数器 总数,成功,失败
	s msg=""		// 提示信息
	
	k ^TMP("DHCCKB","web.DHCCKBRuleExport","ExportDataErrMsg")
	s generID=..DeleteDicRule(pid)
 	q:generID="" ""
	
	s row="" 
	f  s row=$o(^TMP("DHCCKB","web.DHCCKBRuleImport","TmpImportData",pid,row))  q:row=""  d	
	.s rowData=$g(^TMP("DHCCKB","web.DHCCKBRuleImport","TmpImportData",pid,row))
	.//s rowObj=..StrToObj(rowData,"")	
	.s baseObj=..StrToObj(rowData,"base")
	.s ruleObj=..StrToObj(rowData,"rule")
	.s outPutObj=..StrToObj(rowData,"output")
	.
	.q:baseObj.%Size()=0		// 空对象
	.s num=baseObj.%Get("num")	// 序号
	.s err=1					// 事务标志		
	.s total=total+1
	.
	.TS
	.// 药名+原文+病症+系统疾病+症状+不明确列 （暂存，导出用）
	.//d ..SaveTmpDrugGlobal(pid,baseObj,ruleObj)
	.
	.s atomArr=[],orArr=[]					// 数组存储数据串信息
	.s alertCat=outPutObj.%Get("alertCat")	// 警戒类型(含过敏)
	.
	.// 保存药品代码和描述(带剂型的商品名)
	.//i (baseObj.%Get("itmCode")="")||(baseObj.%Get("itmGeneName")="") s err=0,msg="通用名代码/描述不存在，请检查数据或者列头"
	.i (baseObj.%Get("itmGeneName")="") s err=0,msg="通用名代码/描述不存在，请检查数据或者列头"
	.i err=0 d SetTroInfo
	.q:err=0
	.s generIDStr=..SaveRuleDic(baseObj.%Get("itmGeneName"),baseObj.%Get("itmGeneName"),"itmGeneName")
	.s generID=$p(generIDStr,"^",1)
	.i +generID="" s err=0,msg="通用名保存失败"
	.i +generID=0 d SetTroInfo
	.q:+generID=0
	.// 保存目录
	.s labelID=..SaveRuleDic(baseObj.%Get("itmLibary"),baseObj.%Get("itmLibary"),"itmLibary")	
	.s:+labelID=0 err=0,msg="关系目录保存失败"
	.i err=0 d SetTroInfo
	.q:err=0
	.
	.// 目录保存后,在药品的属性下面建立对应的关联属性,用于关联存储原文
	.s drugProp=##class(web.DHCCKBCommon).GetDrugProp()
	.s labelPropID=..SaveLinkProp(drugProp,labelID)
	.s labelArr(labelPropID)=$case($d(labelArr(labelPropID))>0,1:$g(labelArr(labelPropID))+1,:1)
	.s:+labelPropID=0 err=0,msg="关系目录属性保存失败"
	.i err=0 d SetTroInfo
	.q:err=0
	.
	.s labValueObj=0
	.d CommonBaseSave	// 保存药品基本信息列(药品信息类只需要报存一次)
	.i err=0 d SetTroInfo
	.q:err=0
	.d CommonRuleSave	// 保存规则列，并生成规则json
	.i err=0 d SetTroInfo
	.
	.q:err=0
	.
	.// 规则json串处理	
	.s root={},inputRuleObj={},ifObj={},thenObj={},elseObj={}
	.d SetInputRuleObj
	.// 输出信息json串处理	
	.d SetRuleOutPutObj
	.s labelDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(labelID)),3)		// 目录描述	
	.s tipsFlag=$case((labelDesc["用法用量")||(labelDesc["适应"),1:1,:0) 
	.i (tipsFlag=1)&(ifObj.%ToJSON()="{}") s elseObj={}	// 规则为空时,错误输出的提醒不需要
	.i (tipsFlag=0)&(ifObj.%ToJSON()="{}") s thenObj={}
	.
	.i (((tipsFlag=1)&(thenObj.%Size()'=0))||((tipsFlag=0)&(elseObj.%Size()'=0)))&(ifObj.%Size()=0) d 
	..d SetTipAtOnce
	..d SetInputRuleObj
	.
	.i (ifObj.%Size()=0)&&(thenObj.%Size()=0)&&(elseObj.%Size()=0) s err=0,msg="规则为空"
	.i err=0 d SetTroInfo
	.
	.q:err=0
	.
	.d inputRuleObj.%Set("if",ifObj).%Set("then",thenObj).%Set("else",elseObj).%Set("_name","rule").%Set("remark","")
	.d root.%Set("rule",inputRuleObj)	// root={rule:{remark:"",if:{and:{atom:{},or:{}}},then:{},else:{},_name:"rule"}}
	.s dicStr=generID_"^"_labelID	// 药品名称id^目录id
	.s status="Release"
	.s ret=##class(web.DHCCKBRuleSave).save(0,status,root.%ToJSON(),"",dicStr,loginInfo)	// save方法中,root是json字符串,不成直接传json对象
	.i ret<0 s err=0
	.
	.k root,inputRuleObj,ifObj,thenObj,elseObj,atomArr,orArr
	.
	.i err=1 do
	..s successNum=successNum+1
	..TCOMMIT
	.else  d SetTroInfo
	
	s outObj={}
	i (successNum'=0) 	d
	.d outObj.%Set("code","success").%Set("total",total).%Set("successNum",successNum).%Set("errNum",errNum).%Set("msg","")
	e  d
	.d outObj.%Set("code","err").%Set("total",total).%Set("successNum",successNum).%Set("errNum",errNum).%Set("msg",$case(msg,"":"系统错误,代码"_$ze,:msg))
	
	d ..killTmpGlobal(pid)
	q outObj.%ToJSON()

	
SetTroInfo
	tro
	s errNum=errNum+1
	s ^TMP("DHCCKB","web.DHCCKBRuleExport","ExportDataErrMsg",pid,row)=rowData_"[next]"_"errMsg"_$c(1)_msg	// 记录提交失败信息
	Quit	
	
ERROR
	set $ZT=""
	set ErrorMsg=$ZE                  //$ZE 获取错误信息
	TROLLBACK	                      //有异常，则回滚事务(Golbal才可以回滚,普通变量不能回滚)
	s ^TMP("DHCCKB","web.DHCCKBRuleExport","ExportDataErrMsg",pid,row)=rowData	// 记录提交失败信息
	s outObj={}
	d outObj.%Set("code","err").%Set("total",total).%Set("successNum",successNum).%Set("errNum",errNum).%Set("msg","系统错误,代码"_ErrorMsg)
	d ..killTmpGlobal(pid)
	Quit outObj.%ToJSON()             //返回错误信息
	
	
CommonBaseSave					/// 药品基本信息保存

	set itr = baseObj.%GetIterator()
	while itr.%GetNext(.key,.val) {
	
		continue:val=""		// value是空则不需要保存
		continue:val=" "	// 空格
		continue:(key="num")||(key="itmCode")||(key="itmGeneName")||(key="itmLibary")	//序号,编码,通用名
		if (key="itmText"){	
			
			if ($g(labelArr(labelPropID)) = 1){
				s linkID=..SaveCommonDicLinkAttr(generID,labelPropID,mDel,val)
				if linkID<0 s err=0,msg=..GetErrMsg(key,linkID)				
			}				
		}
		continue:(key="itmText")
	
		if (total = 1){
			
			// 英文名称/原文 	需要保存和通用名的关联关系		
			if (key="itmEnName")||(key="prioCondition"){	
				s linkID=..SaveCommonDicLinkAttr(generID,key,mDel,val)
				if linkID<0 s err=0,msg=..GetErrMsg(key,linkID)		
			}		 
			elseif (key="itmProName"){		//商品名  需要保存和通用名的关联关系	
				s dicIDStr=..SaveRuleDic(baseObj.%Get("itmCode"),val,key)		// 将字典数据存储起来
				i +dicIDStr<=0 s err=0,msg=..GetErrMsg(key,dicIDStr)	
				continue:err=0
				s linkID=..SaveCommonDicLinkAttr(generID,key,dicIDStr)
				i $g(linkID)<0 s err=0,msg=..GetErrMsg(key,linkID)				
			}
			// 成分	格式： 成分1:10mg 或者成分1 "空格" 10mg (多个成分之间用顿号)
			elseif (key="itmIngre"){
				s dicIDStr=..SaveRuleDic(val,val,key)		// 将字典数据存储起来
				i +dicIDStr<=0 s err=0,msg=..GetErrMsg(key,dicIDStr)	
				continue:err=0			
				s linkID=..SaveDicLinkIngre(generID,dicIDStr,val)
				i $g(linkID)<0 s err=0,msg=..GetErrMsg(key,linkID)					
			}		
			//辅料/剂型,  需要保存和通用名的关联关系
			elseif (key="itmExcipient")||(key="itmForm"){			
				s dicIDStr=..SaveRuleDic(val,val,key)		// 将字典数据存储起来
				i +dicIDStr<=0 s err=0,msg=..GetErrMsg(key,dicIDStr)	
				continue:err=0
				s linkID=..SaveCommonDicLinkAttr(generID,key,dicIDStr)
				i $g(linkID)<0 s err=0,msg=..GetErrMsg(key,linkID)
				
			}else{
				s dicIDStr=..SaveRuleDic(val,val,key)		// 将字典数据存储起来
				i +dicIDStr<=0 s err=0,msg=..GetErrMsg(key,linkID)
			}
		}		
	
		q:err=0	
	}

	quit 

CommonRuleSave				/// 规则中不含数值和单位的字典形规则保存

	set itr = ruleObj.%GetIterator()
	while itr.%GetNext(.key,.val) {
		s val=$tr(val,$c(13),"")
		s val=$tr(val,$c(10),"")
		s val=$tr(val,$c(13,10),"")
	
		continue:val=""					// value是空则不需要保存
		continue:val=" "	
		continue:key="linkAdvice"		// 特别推荐不保存
		continue:key="otherNoSureDis"	// 与适应证相关列不保存
		// 检验指标,检验指标值，特别推荐
		s flag=(key="linkLabItm")||(key="linkLabValue")||(key="linkAdvice")
		// 年龄,体重,溶媒浓度,溶媒体积
		s flag=flag||(key="linkAge")||(key="linkWeight")||(key="linkSolDens")||(key="linkSolVolume")
		// 溶液浓度,溶液体积,给药速度,给药时间,
		s flag=flag||(key="linkSolutionDens")||(key="linkSolutionVolume")||(key="linkSpeed")||(key="linkDrugUseTime")
		// 剂量,频次,疗程内用药时长  最大量,极量,疗程
		s flag=flag||(key="linkDose")||(key="linkDoseMax")||(key="linkDoseLimit")||(key="linkTreat")
		//疗程间间隔,连续用药,阶梯给药
		s flag=flag||(key="linkSpaceTreat")||(key="carryUseDrug")||(key="spaceSendTime")
		// 以上这些列，不能直接保存，需要拆出单位，保存单位，然后生成规则
		
		if flag=1 d commonRuleUnitSave
		continue:flag=1			
		s dicIDStr=..SaveRuleDic(val,val,key)		// 将字典数据存储起来
		i +dicIDStr<=0 s err=0,msg=..GetErrMsg(key,dicIDStr)	
		q:+dicIDStr<=0		
		s out=$extract(key,1,3)		// 除外标志

		if (key="outDrugAllergy"){					// 环境过敏因素
			s tmpObj=..GetPatHisAllergyObj(dicIDStr)
			s:(+tmpObj<=0)||(tmpObj={}) err=0,msg=..GetErrMsg(key,tmpObj)
			continue:(+tmpObj<=0)||(tmpObj={})
			i tmpObj.%Get("atom")="" d atomArr.%Push(tmpObj) 				
			e  d orArr.%Push(tmpObj)					
		}
		elseif (key="linkProName")||(key="linkCat")||(key="linkIngre"){		// (商品名,分类,成分)
			i alertCat["过敏" s tmpObj=..GetPatHisAllergyObj(dicIDStr)
			e  s tmpObj=..GetCommonObj(key,dicIDStr)
			s:(+tmpObj<=0)||(tmpObj={}) err=0,msg=..GetErrMsg(key,tmpObj)	
			continue:(+tmpObj<=0)||(tmpObj={})
			i tmpObj.%Get("atom")="" d atomArr.%Push(tmpObj) 				
			e  d orArr.%Push(tmpObj)					
		}
		elseif (key["out"){		// 含除外的列		
			if (key="outLinkCat")||(key="outLinkIngre"){						// 除外过敏
				i alertCat["过敏" s tmpObj=..GetPatHisAllergyObj(dicIDStr,"out")
				e  s tmpObj=..GetCommonObj(key,dicIDStr,"out")
				s:(+tmpObj<=0)||(tmpObj={}) err=0,msg=..GetErrMsg(key,tmpObj)
				continue:(+tmpObj<=0)||(tmpObj={})				
				i tmpObj.%Get("atom")="" d atomArr.%Push(tmpObj) 				
				e  d orArr.%Push(tmpObj)			
			}else{
				s tmpObj=..GetCommonObj(key,dicIDStr,"out")
				s:(+tmpObj<=0)||(tmpObj={}) err=0,msg=..GetErrMsg(key,tmpObj)		
				continue:(+tmpObj<=0)||(tmpObj={})
				i tmpObj.%Get("atom")="" d atomArr.%Push(tmpObj) 				
				e  d orArr.%Push(tmpObj)		
			}	
		
		}
		else{			
		
			s tmpObj=..GetCommonObj(key,dicIDStr)
			s:(+tmpObj<=0)||(tmpObj={}) err=0,msg=..GetErrMsg(key,tmpObj)	
			continue:(+tmpObj<=0)||(tmpObj={})
			i tmpObj.%Get("atom")="" d atomArr.%Push(tmpObj) 				
			e  d orArr.%Push(tmpObj)			
		}
	
		q:err=0
	}

	Quit
		
commonRuleUnitSave	//规则中含数值和单位形式的规则保存	
	b   ///rule1
	if (key ="linkLabItm"){						
		if (ruleObj.%Get("linkLabValue")=""){	// 指标值列 不含指标名称，只有指标范围值
			s dicIDStr=..SaveRuleDic(val,val,key)		// 将指标值范围为空时,存指标范围	
			i +dicIDStr<=0 s err=0,msg=..GetErrMsg(key,dicIDStr)
			q:+dicIDStr<=0						
			s tmpObj=..GetCommonObj(key,dicIDStr)
			s:(+tmpObj<=0)||(tmpObj={}) err=0,msg=..GetErrMsg(key,tmpObj)		
			q:(+tmpObj<=0)||(tmpObj={})
			i tmpObj.%Get("atom")="" d atomArr.%Push(tmpObj) 				
			e  d orArr.%Push(tmpObj)
		}
								
	}elseif (key="linkLabValue"){	//检验指标值
		// 格式可能：格式1，心率<45次/分、P-Q间期>0.24秒、收缩压<100mmHg  		格式2：指标测试1  >=12ml 格式3
		s labItm=$case(ruleObj.%Get("linkLabItm")="",1:"",:ruleObj.%Get("linkLabItm"))
		s labValueObj=##class(web.DHCCKBRuleImport).GetLabValueObj(labItm,val,key)

		s:labValueObj=0 err=0,msg=..GetErrMsg(key,tmpStr)	
		q:err=0
				
	}elseif (key="spaceSendTime"){	//阶梯给药
		

	}elseif (key="linkDose"){		// 剂量,频次,疗程内用药时长
		s str=##Class(ext.util.String).Replace(val,",","!!")	// 中英文逗号分隔
		s str=##Class(ext.util.String).Replace(str,"，","!!")
		s doseStr=$p(str,"!!",1)		// 剂量	
		s freqStr=$p(str,"!!",2)		// 频次	
		s treatStr=$p(str,"!!",3)		//疗程内用药时长
	
		if (doseStr'="")&(doseStr'=0){				// 剂量
			s tmpStr=..GetCommonValueUnit(doseStr,"<=")			
			s:(tmpStr<0)||(tmpStr=0) err=0,msg=..GetErrMsg(key,tmpStr)
			q:(tmpStr<0)||(tmpStr=0) 
			s tmpKey=$select((doseStr["日")||(doseStr["天"):"dayDose",doseStr["次":"onceDose",1:"onceDose")
			s tmpObj=..GetCommonObj(tmpKey,tmpStr)
			s:(+tmpObj<=0)||(tmpObj={}) err=0,msg=..GetErrMsg(tmpKey,tmpObj)
			q:(+tmpObj<=0)||(tmpObj={}) 
			i tmpObj.%Get("atom")="" d atomArr.%Push(tmpObj) 				
			e  d orArr.%Push(tmpObj)
		
		}			
		if (freqStr'="")&(freqStr'=0){			// 频次	
			s str=..SaveFreqUnit(freqStr)		
			s:str=0 err=0,msg=..GetErrMsg(key,str)
			q:str=0
			s tmpObj=..GetCommonObj("drugFreq",str)
			s:(+tmpObj<=0)||(tmpObj={}) err=0,msg=..GetErrMsg(key,tmpObj)
			q:(+tmpObj<=0)||(tmpObj={}) 
			i tmpObj.%Get("atom")="" d atomArr.%Push(tmpObj) 				
			e  d orArr.%Push(tmpObj)
		
		}				
		//疗程内用药时长
		
	}elseif(key="linkDoseMax"){		// 最大量
		s str=..GetCommonValueUnit(val,"<=")
		s:(str<0)||(str=0) err=0,msg=..GetErrMsg(key,str)
		q:(str<0)||(str=0)
		s tmpKey=$select((val["日")||(val["天"):"dayDoseMax",val["次":"onceDoseMax",1:"onceDoseMax")
		s tmpObj=..GetCommonObj(tmpKey,str)
		s:(+tmpObj<=0)||(tmpObj={}) err=0,msg=..GetErrMsg(key,tmpObj)
		q:(+tmpObj<=0)||(tmpObj={}) 
		i tmpObj.%Get("atom")="" d atomArr.%Push(tmpObj) 				
		e  d orArr.%Push(tmpObj)
				
	}elseif(key="linkDoseLimit"){	// 极量
		s str=..GetCommonValueUnit(val,"<=")
		s:(str<0)||(str=0) err=0,msg=..GetErrMsg(key,str)
		q:(str<0)||(str=0)
		s tmpKey=$select((val["日")||(val["天"):"dayDoseLimit",val["次":"onceDoseLimit",1:"onceDoseLimit")
		s tmpObj=..GetCommonObj(tmpKey,str)
		s:(+tmpObj<=0)||(tmpObj={}) err=0,msg=..GetErrMsg(key,tmpObj)
		q:(+tmpObj<=0)||(tmpObj={}) 	
		i tmpObj.%Get("atom")="" d atomArr.%Push(tmpObj) 				
		e  d orArr.%Push(tmpObj)
		   
	}	
	else{	
		s str=..GetCommonValueUnit(val,"=")	// 默认是等于
		s:(str<0)||(str=0) err=0,msg=..GetErrMsg(key,str)
		q:(str<0)||(str=0)
		s tmpObj=..GetCommonObj(key,str)

		s:(+tmpObj<=0)||(tmpObj={}) err=0,msg=..GetErrMsg(key,tmpObj)
		q:(+tmpObj<=0)||(tmpObj={}) 
		i tmpObj.%Get("atom")="" d atomArr.%Push(tmpObj) 				
		e  d orArr.%Push(tmpObj)	
	}

	Quit	
	
	
SetInputRuleObj		// 规则json串处理
	
	//规则json输出串	
	//s ifObj={},andObj={}
	s andObj={}
	// and json
	i (atomArr.%Size())=1  d			// atomArr数组中只有一个元素,则需要输出atom:{}. 多个元素则输出atom:[]
	.d andObj.%Set("atom",atomArr.%Get(0))
	i (atomArr.%Size())>1 d
	.d andObj.%Set("atom",atomArr)

	i orArr.%Size()=1 d				// orArr数组中只有一个元素,则需要输出or:{}. 多个元素则输出or:[]
	.d andObj.%Set("or",orArr.%Get(0))
	i (orArr.%Size())>1 d
	.d andObj.%Set("or",orArr)	
	
	i labValueObj'=0 d
	.i labValueObj.%Size()=1 d andObj.%Set("and",labValueObj)	// 检验对象比较特殊
	.e  d
	..s tmpOrObj={}
	..d tmpOrObj.%Set("and",labValueObj)
	..d andObj.%Set("or",tmpOrObj)	// 检验对象
	
	q:andObj.%ToJSON()="{}" ""

	i (atomArr.%Size()=0)&(orArr.%Size()=1) d	//root={rule:{remark:"",if:{and:{or:{},atom:{},or:{}}},then:{},else:{},_name:"rule"}}
	.d ifObj.%Set("or",andObj.%Get("or"))		
	e  d
	.d ifObj.%Set("and",andObj)
	
	
	//d inputRuleObj.%Set("if",ifObj)
	k andObj
	//k ifObj,andObj
	Quit
	

SetRuleOutPutObj		//输出信息json串处理

	//s thenObj={},elseObj={}
	// 输出除了用法用量,适应症(进一步说明的都在then里面),其他的都是满足了给提醒(禁忌证、相互作用、配伍禁忌等)(进一步说明的都在else里面)
	s exlanMsg=outPutObj.%Get("linkExlanMsg")		// 进一步说明
	s labelDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(labelID)),3)	// 目录描述	
	i exlanMsg'=""  d
	.i (labelDesc["用法用量")||(labelDesc["适应")  d
	..d thenObj.%Set("var-assign",..GetAssignObj(1,outPutObj))
	.e  d
	..d elseObj.%Set("var-assign",..GetAssignObj(1,outPutObj))
	
	i (labelDesc["用法用量")||(labelDesc["适应")  d	// 不通过提醒
	.d elseObj.%Set("var-assign",..GetAssignObj(0,outPutObj))
	e  d
	.d thenObj.%Set("var-assign",..GetAssignObj(0,outPutObj))

	//d inputRuleObj.%Set("then",thenObj)
	//d inputRuleObj.%Set("else",elseObj)
	//d inputRuleObj.%Set("_name","rule")
	//d inputRuleObj.%Set("remark","")
	//k thenObj,elseObj
	
	Quit
	
	
SetTipAtOnce	// 设置空规则的json串
	s tmpId=##class(web.DHCCKBCommon).GetDicIdByCode("true")
	q:+tmpId=0
	s tmpObj=..GetCommonObj("TipsAtOnceProp",tmpId)
	s:(+tmpObj<=0)||(tmpObj={}) err=0,msg=..GetErrMsg("TipsAtOnceProp",tmpObj)
	quit:(+tmpObj<=0)||(tmpObj={})	
	i tmpObj.%Get("atom")="" d atomArr.%Push(tmpObj) 				
	e  d orArr.%Push(tmpObj)	
	
	Quit
}

/// Description:	药名+原文+病症+系统疾病+症状+不明确列 （暂存，导出用）
/// Creator:		QuNianpeng 
/// CreateDate:		2019-10-14	
/// Input:			
/// return:			
/// other:			w ##class(web.DHCCKBRuleImport).SaveTmpDrugGlobal()
ClassMethod SaveTmpDrugGlobal(pid, baseObj, ruleObj) As %String
{
	n (pid,baseObj, ruleObj)
	
	s spec="[next]"	// 分隔符
	s tmpExprotData=baseObj.%Get("num")_spec_baseObj.%Get("itmCode")_spec_baseObj.%Get("itmText")_spec_ruleObj.%Get("linkDisease")
	s tmpExprotData=tmpExprotData_spec_ruleObj.%Get("linkOtherDis")_spec_ruleObj.%Get("linkSym")_spec_ruleObj.%Get("otherNoSureDis")	
	
	s ^TMP("DHCCKB","web.DHCCKBRuleExport","ExportData",pid,$i(^TMP("SaveTmpDrugGlobal")))=tmpExprotData
}

/// Description:	保存规则中的字典公共方法
/// Creator:		QuNianpeng 
/// CreateDate:		2019-10-14	
/// Input:			字典代码串,字典描述串,字典类型
/// return:			成功 字典id，失败代码 0
/// other:			w ##class(web.DHCCKBRuleImport).SaveRuleDic("多发性脑梗死","多发性脑梗死","linkDisease")
ClassMethod SaveRuleDic(codeStr, descStr, type)
{
	n (codeStr,descStr,type)	
	
	s ret = 0,err=0
	q:(codeStr="")&(descStr="") ret	// 代码和描述不可同时为空,  代码可为空，如成分：阿莫西林

	s codeStr = ##class(web.DHCCKBCommonUtil).ReplaceStr(codeStr,"&&")	// 替换分割付
	s descStr = ##class(web.DHCCKBCommonUtil).ReplaceStr(descStr,"&&")	
	s typeDataID = 0
	
	s quitVal = ""
	
	// 需要有保存字典的字典代码(如保存药品,需要现有药品字典)
	s typeDataID = ..GetDicTypeDataID(type)
	q:+typeDataID=0 "-99"
	//s existFlag = 0				// qunianpeng 2020/4/3 新增退出标记，用于判断字典是否存在的情况
	s len=$l(descStr,"&&")		// 字典字符串
	f i=1:1:len  Q:+err<0  d
	.s dicID=""
	.s desc=$p(descStr,"&&",i)
	.s:type="linkOperTime" desc=$Select(desc["术前":"术前",desc["术中":"术中",desc["术后":"术后",1:"")
	.s:type="itmIngre" desc=$select(desc[" ":$p(desc," ",1),desc[":":$p(desc,":",1),desc["：":$p(desc,"：",1),1:desc)	// 成分格式： 成分1:10mg/成分1 10mg/成分1
	.q:desc=""
	.s code=$p(codeStr,"&&",i)
	.s:type="linkOperTime" code=$Select(code["术前":"术前",code["术中":"术中",code["术后":"术后",1:"")
	.s:type="itmIngre" code=$select(code[" ":$p(code," ",1),code[":":$p(code,":",1),code["：":$p(code,"：",1),1:code)	// 成分格式： 成分1:10mg/成分1 10mg/成分1
	.s:code="" code = desc 		// 代码为空时,可以使用描述作为代码
	.s code=##class(web.DHCCKBCommonUtil).ReplaceWordStr(code)
	.s desc=##class(web.DHCCKBCommonUtil).ReplaceWordStr(desc)	
	.s dicID=##Class(web.DHCCKBRuleImport).SaveCommonDic(code,desc,typeDataID)
	.s quitVal = code
	.s err =	dicID
	.q:+err<=0
	.q:+dicID<=0		
	.//i +dicID<=0 s existFlag=-88  // qunianpeng 2020/4/3
	.i ret=0 s ret=dicID
	.e  s ret=ret_"^"_dicID	
 q:+err<=0 err_"^"_quitVal
	q ret
}

/// 特定格式的字符串转换为对象 	// 通用名$c(1)阿莫西林 [next] 剂型2$c(1) 片剂	
/// w ##class(web.DHCCKBRuleImport).StrToObj("编码1"_$c(1)_"11111[next]药品商品名1"_$c(1)_"阿莫西林").%ToJSON()
ClassMethod StrToObj(mData, type = "") As %String
{
	n (mData,type)
	
	s spec="[next]"
	s del=$c(1)
	s len=$length(mData,spec)
	s dataObj={}

	f i=1:1:len	d
	.s tmpData=$p(mData,spec,i)
	.s key=$p(tmpData,del,1)
	.i type="base" d
	..s key=..SetBaseKey(key)
	.e  i type="rule" d
	..s key=..SetRuleKey(key)
	.e  i type="output" d
	..s key=..SetOutPutKey(key)
	.e  d
	..s key=..SetRowKey(key)
	.q:key=""
	.s value=$p(tmpData,del,2)
	.d dataObj.%Set(key,value)
	
	q dataObj
}

/// 生成整行对象的key
/// w ##class(web.DHCCKBRuleImport).SetRowKey(20,"")
ClassMethod SetRowKey(key) As %String
{
	n (key)

	s keyObj={}
	d keyObj.%Set("编码1","itmCode").%Set("药品商品名1","itmProName").%Set("通用名（带剂型）1","itmGeneName")
	d keyObj.%Set("英文名称1","itmEnName").%Set("成分1","itmIngre").%Set("辅料1","itmExcipient")
	d keyObj.%Set("剂型1","itmForm").%Set("关系","itmLibary").%Set("原文","itmText").%Set("药品商品名","linkProName")
	d keyObj.%Set("通用名（含剂型）","linkGeneName").%Set("同类药物","linkCat").%Set("成分","linkIngre")
	d keyObj.%Set("除外的药品类型","outLinkCat").%Set("除外的药品成分","outLinkIngre").%Set("药品之外的过敏因素","outDrugAllergy")
	d keyObj.%Set("检验指标","linkLabItm").%Set("检验指标值","linkLabValue").%Set("病原体","linkVirus")
	d keyObj.%Set("病原体组","linkVirusCat").%Set("病原体除外","outLinkVirus").%Set("病症","linkDisease")
	d keyObj.%Set("系统疾病","linkOtherDis").%Set("症状","linkSym").%Set("与适应症相关的不明确列","otherNoSureDis")
	d keyObj.%Set("除外病症","outLinkDis").%Set("除外系统疾病","outLinkOtherDis").%Set("除外症状","outLinkSym")
	d keyObj.%Set("特别推荐","linkAdvice").%Set("手术时段","linkOperTime").%Set("人群","linkPeople")
	d keyObj.%Set("年龄","linkAge").%Set("体重","linkWeight").%Set("性别","linkSex").%Set("职业","lilnkProfess")
	d keyObj.%Set("给药途径","linkPreMet").%Set("溶媒（带剂型的通用名）","linkSolvent").%Set("溶媒浓度","linkSolDens")
	d keyObj.%Set("溶媒体积","linkSolVolume").%Set("溶液（带剂型的通用名）","linkSolution").%Set("溶液浓度","linkSolutionDens")
	d keyObj.%Set("溶液体积","linkSolutionVolume").%Set("给药速度","linkSpeed").%Set("给药时间","lindSendTime")
	d keyObj.%Set("剂量,频次,疗程内用药时长","linkDose").%Set("是否首次","isFirst").%Set("阶梯给药","spaceSendTime")
	d keyObj.%Set("最大量","linkDoseMax").%Set("极量","linkDoseLimit").%Set("疗程","linkTreat")
	d keyObj.%Set("疗程间间隔","linkSpaceTreat").%Set("连续用药","carryUseDrug").%Set("进一步说明","linkExlanMsg")
	d keyObj.%Set("不合理用药原因说明","linkErrMsg").%Set("提示级别","levelMsg").%Set("提示依据","msgSource")
	d keyObj.%Set("合用类别","togetherType").%Set("警戒类型","alertCat")
	d keyObj.%Set("前置条件/后置影响","prioCondition").%Set("num","num").%Set("errMsg","errMsg")
	
	q keyObj.%Get(key)
}

/// 生成药品基本信息对象的key
ClassMethod SetBaseKey(key) As %String
{
	n (key)

	s keyObj={}
	d keyObj.%Set("num","num").%Set("编码1","itmCode").%Set("药品商品名1","itmProName").%Set("通用名（带剂型）1","itmGeneName")
	d keyObj.%Set("英文名称1","itmEnName").%Set("成分1","itmIngre").%Set("辅料1","itmExcipient")
	d keyObj.%Set("剂型1","itmForm").%Set("关系","itmLibary").%Set("关系1","itmLibary").%Set("原文","itmText")
	
	q keyObj.%Get(key)
}

/// 生成规则对象的key
ClassMethod SetRuleKey(key) As %String
{
	n (key)

	s keyObj={}
	d keyObj.%Set("药品商品名","linkProName").%Set("通用名（含剂型）","linkGeneName")
	d keyObj.%Set("同类药物","linkCat").%Set("成分","linkIngre").%Set("除外的药品类型","outLinkCat").%Set("除外的药品成分","outLinkIngre")
	d keyObj.%Set("药品之外的过敏因素","outDrugAllergy").%Set("检验指标","linkLabItm").%Set("检验指标值","linkLabValue")
	d keyObj.%Set("病原体","linkVirus").%Set("病原体组","linkVirusCat").%Set("病原体除外","outLinkVirus")
	d keyObj.%Set("病症","linkDisease").%Set("系统疾病","linkOtherDis").%Set("症状","linkSym").%Set("与适应症相关的不明确列","otherNoSureDis")
	d keyObj.%Set("除外病症","outLinkDis").%Set("除外系统疾病","outLinkOtherDis").%Set("除外症状","outLinkSym")
	d keyObj.%Set("特别推荐","linkAdvice").%Set("手术时段","linkOperTime").%Set("人群","linkPeople")
	d keyObj.%Set("年龄","linkAge").%Set("体重","linkWeight").%Set("性别","linkSex").%Set("职业","lilnkProfess")
	d keyObj.%Set("给药途径","linkPreMet").%Set("溶媒（带剂型的通用名）","linkSolvent").%Set("溶媒浓度","linkSolDens")
	d keyObj.%Set("溶媒体积","linkSolVolume").%Set("溶液（带剂型的通用名）","linkSolution").%Set("溶液浓度","linkSolutionDens")
	d keyObj.%Set("溶液体积","linkSolutionVolume").%Set("给药速度","linkSpeed").%Set("给药时间","linkDrugUseTime")
	d keyObj.%Set("剂量,频次,疗程内用药时长","linkDose").%Set("是否首次","isFirst").%Set("阶梯给药","spaceSendTime") 
	d keyObj.%Set("最大量","linkDoseMax").%Set("极量","linkDoseLimit").%Set("疗程","linkTreat")
	d keyObj.%Set("疗程间间隔","linkSpaceTreat").%Set("连续用药","carryUseDrug").%Set("合用类别","togetherType")
	
	q keyObj.%Get(key)
}

/// 生成输出对象的key
ClassMethod SetOutPutKey(key) As %String
{
	n (key)

	s keyObj={}
	d keyObj.%Set("进一步说明","linkExlanMsg").%Set("不合理用药原因说明","linkErrMsg").%Set("提示级别","levelMsg")
	d keyObj.%Set("提示依据","msgSource").%Set("警戒类型","alertCat")
	d keyObj.%Set("前置条件/后置影响","prioCondition")
	
	q keyObj.%Get(key)
}

/// 通过键值对的代码，获取代码对应的列头描述,用于日志信息的输出
ClassMethod GetValueByCode(key) As %String
{
	n (key)

	s keyObj={}
	d keyObj.%Set("linkProName","药品商品名").%Set("linkGeneName","通用名（含剂型）")
	d keyObj.%Set("linkCat","同类药物").%Set("linkIngre","成分").%Set("outLinkCat","除外的药品类型").%Set("outLinkIngre","除外的药品成分")
	d keyObj.%Set("outDrugAllergy","药品之外的过敏因素").%Set("linkLabItm","检验指标").%Set("linkLabValue","检验指标值")
	d keyObj.%Set("linkVirus","病原体").%Set("linkVirusCat","病原体组").%Set("outLinkVirus","病原体除外")
	d keyObj.%Set("linkDisease","病症").%Set("linkOtherDis","系统疾病").%Set("linkSym","症状").%Set("otherNoSureDis","与适应症相关的不明确列")
	d keyObj.%Set("outLinkDis","除外病症").%Set("outLinkOtherDis","除外系统疾病").%Set("outLinkSym","除外症状")
	d keyObj.%Set("linkAdvice","特别推荐").%Set("linkOperTime","手术时段").%Set("linkPeople","人群")
	d keyObj.%Set("linkAge","年龄").%Set("linkWeight","体重").%Set("linkSex","性别").%Set("lilnkProfess","职业")
	d keyObj.%Set("linkPreMet","给药途径").%Set("linkSolvent","溶媒（带剂型的通用名）").%Set("linkSolDens","溶媒浓度")
	d keyObj.%Set("linkSolVolume","溶媒体积").%Set("linkSolution","溶液（带剂型的通用名）").%Set("linkSolutionDens","溶液浓度")
	d keyObj.%Set("linkSolutionVolume","溶液体积").%Set("linkSpeed","给药速度").%Set("linkDrugUseTime","给药时间")
	d keyObj.%Set("linkDose","剂量,频次,疗程内用药时长").%Set("isFirst","是否首次").%Set("spaceSendTime","阶梯给药") 
	d keyObj.%Set("linkDoseMax","最大量").%Set("linkDoseLimit","极量").%Set("linkTreat","疗程")
	d keyObj.%Set("linkSpaceTreat","疗程间间隔").%Set("carryUseDrug","连续用药").%Set("TipsAtOnceProp","开医嘱提醒")
	d keyObj.%Set("linkGeneNoDos","通用名").%Set("DiluteProp","必须稀释后给药")
	
	q keyObj.%Get(key)
}

/// Description:	保存关联关系
/// Creator:		QuNianpeng 
/// CreateDate:		2019-07-08	
/// Input:			实体id^属性id^属性id^属性值text
/// return:			成功id，失败代码
/// other:			w ##class(web.DHCCKBRuleImport).SaveCommonDicLinkAttr()
ClassMethod SaveCommonDicLinkAttr(dicID, linkAttrCode, attr, attrValue = "")
{
	n (dicID,linkAttrCode,attr,attrValue)
	
	s linkAttrDr=""
	i +linkAttrCode'=0  d					// 目录（原文）
	.s linkAttrDr=linkAttrCode
	e  i linkAttrCode="itmProName"  d		// 药品->商品名	
	.s linkAttrDr=##class(web.DHCCKBCommon).GetProNameProp()	// 商品名属性id	
	e  i linkAttrCode="itmEnName"	d		// 药品->英文名称
	.s linkAttrDr=##class(web.DHCCKBCommon).GetEngNameProp()	// 英文名称属性id
	e  i linkAttrCode="itmIngre"  d			// 药品->成分
	.s linkAttrDr=##class(web.DHCCKBCommon).GetIngreProp()		// 成分属性id
	e  i linkAttrCode="itmExcipient"  d		// 药品->辅料
	.s linkAttrDr=##class(web.DHCCKBCommon).GetExcipientProp()	// 辅料属性id
	e  i linkAttrCode="itmForm"  d			// 药品->剂型
	.s linkAttrDr=##class(web.DHCCKBCommon).GetFormProp()		// 剂型属性id
	e  i linkAttrCode="prioCondition" d		// 药品->前置条件
	.s linkAttrDr=##class(web.DHCCKBCommon).GetGetPrioCondProp()	// 前置条件id
	e  i linkAttrCode="drugCat" d			// 药品->药学分类
	.s linkAttrDr=##class(web.DHCCKBCommon).GetPhCategory()		// 药学分类属性
	e  i linkAttrCode="drugManf" d			// 药品->生产企业
	.s linkAttrDr=##class(web.DHCCKBCommon).GetDrugManf()		// 生产企业	
	
	q:+linkAttrDr=0 "-99"
	
	s ret="-97"
	
	i (attrValue'="")&(linkAttrCode="itmEnName") d
	.s attrValue=##class(web.DHCCKBCommonUtil).ReplaceStr(attrValue,"&&")
	.s len=$length(attrValue,"&&")
	.f i=1:1:len  d
	..s tmpAttrValue=$p(attrValue,"&&",i)
	..s tmpListData="^"_dicID_"^"_linkAttrDr_"^"_attr_"^"_tmpAttrValue
	..q:linkAttrDr=""
	..s ret=##class(web.DHCCKBDicLinkAttr).SaveDicAttrNew(tmpListData)
	e  d
	.s len=$length(attr,"^")
	.f i=1:1:len  d
	..s tmpattr=$p(attr,"^",i)
	..s tmpListData="^"_dicID_"^"_linkAttrDr_"^"_tmpattr_"^"_attrValue
	..q:linkAttrDr=""
	..s ret=##class(web.DHCCKBDicLinkAttr).SaveDicAttrNew(tmpListData)

	
	q ret
}

/// Description:	保存关联关系(模板形式)
/// Creator:		QuNianpeng 
/// CreateDate:		2019-12-19	
/// Input:			实体id^属性id^属性id^属性值text
/// return:			成功id，失败代码
/// other:			w ##class(web.DHCCKBRuleImport).SaveCommonDicLinkAttr()
ClassMethod SaveDicLinkIngre(dicID, attrStr, attrValue)
{
	n (dicID,attrStr,attrValue) 	

	s linkAttrDr=##class(web.DHCCKBCommon).GetIngreProp()		// 成分属性id
	q:+linkAttrDr=0 "-99"	
	s ret="-97"	
	
	s ingreCode=##class(web.DHCCKBCommon).GetIngredientCode()	// 成分代码
	s ingreMete=##class(web.DHCCKBCommon).GetIngredientMete()	// 成分剂量
	s ingreUnit=##class(web.DHCCKBCommon).GetIngredientUnit()	// 成分单位
	s unitDataID=##class(web.DHCCKBCommon).GetUnitData()		// 单位字典
		
	s ingreStr="^"_dicID_"^"_linkAttrDr
	s ret=##class(web.DHCCKBDicLinkAttr).SaveDicAttrNew(ingreStr)
	
	s attrValue=##class(web.DHCCKBCommonUtil).ReplaceStr(attrValue,"&&")
	s len=$length(attrValue,"&&")
	f i=1:1:len  d
	.s value=$p(attrValue,"&&",i)
	.s mete=$Select(value[" ":$p(value," ",2),value[":":$p(value,":",2),value["：":$p(value,"：",2),1:"")
	.s num=$case(mete'="",1:##class(web.DHCCKBCommonUtil).GetNum(mete),:"")	//数字
	.s unit=$case(mete'="",1:$p(mete,num,2),:"")
	.s unitID=$case(unit'="",1:##Class(web.DHCCKBRuleImport).SaveCommonDic(unit,unit,unitDataID),:"")	
	.s groupNum=##class(web.DHCCKBCommonUtil).NewPid()_i	
	.s ingreCodeStr="^"_dicID_"^"_ingreCode_"^"_$p(attrStr,"^",i)_"^"_""_"^"_groupNum
	.s ingreMeteStr="^"_dicID_"^"_ingreMete_"^"_""_"^"_num_"^"_groupNum
	.s ingreUnitStr="^"_dicID_"^"_ingreUnit_"^"_unitID_"^"_""_"^"_groupNum
	.//s tmpListData=ingreStr_"&&"_ingreCodeStr_"&&"_ingreMeteStr_"&&"_ingreUnitStr
	.//s ret=##class(web.DHCCKBDicLinkAttr).saveGridData(ingreStr)	
	.s ret=##class(web.DHCCKBDicLinkAttr).SaveDicAttrNew(ingreCodeStr)
	.s ret=##class(web.DHCCKBDicLinkAttr).SaveDicAttrNew(ingreMeteStr)
	.s ret=##class(web.DHCCKBDicLinkAttr).SaveDicAttrNew(ingreUnitStr)
	.q:ret<0

	q ret
}

/// Description:	规则json
/// other:			w ##class(web.DHCCKBRuleImport).GetCommonObj("sinSoluMass","=@@@1@3924","")
ClassMethod GetCommonObj(key, str, sign = "")
{
	n (key,str,sign)
	
	s tmpArr=[],atomObj={}
	s variable="variable",constant="Constant"
	s sign=$case(sign,"out":"NotEquals",:"Equals")
	s propRequiredFlag=0	// 属性是否必要标志
	s entityID=""
	s propID=""
	
	// 需要获取到规则的实体 规则的属性id 进行组装json
	if (key = "linkGeneName"){
		s entityID=##class(web.DHCCKBCommon).GetDrug()			// 药品实体id
		s propID=##class(web.DHCCKBCommon).GetGeneralFromProp()
		s propRequiredFlag=1
		
	}elseif (key = "MedDrugName"){
		s entityID=##class(web.DHCCKBCommon).GetDrug()			// 西药实体
		
	}elseif (key = "ChineseDrugName"){
		s entityID=##class(web.DHCCKBCommon).GetChineseDrug()			//中药实体
		
	}elseif (key = "linkProName"){
		s entityID=##class(web.DHCCKBCommon).GetDrug()			// 药品实体id
		s propID=##class(web.DHCCKBCommon).GetProNameProp()		// 商品名属性id
		s propRequiredFlag=1
		
	}elseif (key = "linkGeneNoDos"){
		s entityID=##class(web.DHCCKBCommon).GetDrug()				// 药品实体id
		s propID=##class(web.DHCCKBCommon).GetGenerNameProp()		// 通用名属性id
		s propRequiredFlag=1
		
	}elseif(key = "linkCat")||(key = "outLinkCat"){
		s entityID=##class(web.DHCCKBCommon).GetDrug()			// 药品实体id
		s propID=##class(web.DHCCKBCommon).GetPhCategory()		// 药学分类属性id
		s propRequiredFlag=1
		
	}elseif (key = "linkIngre")||(key ="outLinkIngre"){
		s entityID=##class(web.DHCCKBCommon).GetDrug()			// 药品实体id
		s propID=##class(web.DHCCKBCommon).GetDrugIngredient()	// 药学成分属性id
		s propRequiredFlag=1
	
	}elseif (key = "linkLabItm"){
		s entityID=##class(web.DHCCKBCommon).GetLabItm()		// 检验项实体id
	
	}elseif (key ="linkLabValue"){
		s entityID=##class(web.DHCCKBCommon).GetLabItm()		// 检验项实体id
		s propID=##class(web.DHCCKBCommon).GetLabItmValueLimitProp()	// 检验项范围值id
		s propRequiredFlag=1

	}elseif (key = "linkVirus")||(key ="outLinkVirus"){
		s entityID=##class(web.DHCCKBCommon).GetBacteria()		// 细菌实体id
	
	}elseif (key = "linkVirusCat"){
		s entityID=##class(web.DHCCKBCommon).GetBacteriaCat()	// 细菌实体id
	
	}elseif (key = "linkDisease")||(key = "linkOtherDis")||(key = "outLinkDis")||(key = "outLinkOtherDis"){
		s entityID=##class(web.DHCCKBCommon).GetDisease()		// 疾病实体id
	
	}
	elseif (key = "IcdCompare"){
		s entityID=##class(web.DHCCKBCommon).GetDisease()		// 西医疾病 
		s propID=##class(web.DHCCKBCommon).GetIcdAttrCodeId()		// ICD
		
	}elseif(key = "linkSym")||(key ="outLinkSym"){
		s entityID=##class(web.DHCCKBCommon).GetSymptom()		// 症状字典id
	
	}elseif (key = "linkPeople"){
		s entityID=##class(web.DHCCKBCommon).GetPatient()		// 患者实体id
		s propID=##class(web.DHCCKBCommon).GetSpecialPopProp()	// 特殊人群属性id
		s propRequiredFlag=1
	
	}elseif(key = "linkSex"){
		s entityID=##class(web.DHCCKBCommon).GetPatient()		// 患者实体id
		s propID=##class(web.DHCCKBCommon).GetSexProp()			// 性别属性id
		s propRequiredFlag=1
	
	}elseif(key = "lilnkProfess"){
		s entityID=##class(web.DHCCKBCommon).GetPatient()		// 患者实体id
		s propID=##class(web.DHCCKBCommon).GetProfessProp()		// 职业属性id
		s propRequiredFlag=1
	
	}elseif(key = "linkPreMet"){
		s entityID=##class(web.DHCCKBCommon).GetDrug()			// 药品实体id
		s propID=##class(web.DHCCKBCommon).GetDrugPreMet()		// 给药途径属性id
		s propRequiredFlag=1
	
	}elseif(key = "linkSolvent"){
		s entityID=##class(web.DHCCKBCommon).GetDrug()			// 药品实体id
		s propID=##class(web.DHCCKBCommon).GetSolventProp()		// 溶媒属性id
		s propRequiredFlag=1
	
	}elseif (key = "linkSolution"){
		s entityID=##class(web.DHCCKBCommon).GetDrug()			// 药品实体id
		s propID=##class(web.DHCCKBCommon).GetSolutionProp()	// 溶液属性id
		s propRequiredFlag=1
	
	}elseif (key = "isFirst"){
		s entityID=##class(web.DHCCKBCommon).GetDrug()			// 药品实体id
		s propID=##class(web.DHCCKBCommon).GetIsFirstUseProp()	// 是否首次属性id
		s propRequiredFlag=1
	}
	elseif (key ="linkAge"){
		s entityID=##class(web.DHCCKBCommon).GetPatient()		// 患者实体id
		s propID=##class(web.DHCCKBCommon).GetAgeProp()			// 年龄属性id
		s propRequiredFlag=1
	}
	elseif (key ="linkWeight"){
		s entityID=##class(web.DHCCKBCommon).GetPatient()		// 患者实体id
		s propID=##class(web.DHCCKBCommon).GetWeightProp()		// 体重属性id
	}
	elseif (key ="linkSolDens"){
		s entityID=##class(web.DHCCKBCommon).GetDrug()				// 药品实体id
		s propID=##class(web.DHCCKBCommon).GetSolventDensityProp()	// 溶媒浓度属性id
		s propRequiredFlag=1
	}
	elseif (key ="linkSolVolume"){
		s entityID=##class(web.DHCCKBCommon).GetDrug()				// 药品实体id
		s propID=##class(web.DHCCKBCommon).GetSolventvolumeProp()	// 溶媒体积属性id
		s propRequiredFlag=1
	
	}elseif (key ="linkSolutionDens"){
		s entityID=##class(web.DHCCKBCommon).GetDrug()				// 药品实体id
		s propID=##class(web.DHCCKBCommon).GetSolutionDensityProp()	// 溶液浓度属性id
		s propRequiredFlag=1
	}
	elseif (key ="linkSolutionVolume"){
		s entityID=##class(web.DHCCKBCommon).GetDrug()				// 药品实体id
		s propID=##class(web.DHCCKBCommon).GetSolutionVolumeProp()	// 溶液体积属性id
		s propRequiredFlag=1
	}
	elseif (key ="linkSpeed"){
		s entityID=##class(web.DHCCKBCommon).GetDrug()				// 药品实体id
		s propID=##class(web.DHCCKBCommon).GetDurgSpeedProp()		// 给药速度属性id
		s propRequiredFlag=1
	} //32
	elseif (key ="linkDrugUseTime"){
		s entityID=##class(web.DHCCKBCommon).GetDrug()				// 药品实体id
		s propID=##class(web.DHCCKBCommon).GetDrugUseTimeProp()	// 给药时间属性id
		s propRequiredFlag=1
	
	}elseif (key = "onceDose"){
		s entityID=##class(web.DHCCKBCommon).GetDrug()				// 药品实体id
		s propID=##class(web.DHCCKBCommon).GetOnceDoseProp()		// 单次用药量属性id	
		s sign="LessThenEquals"
		s propRequiredFlag=1
	}		
	elseif (key = "dayDose"){
		s entityID=##class(web.DHCCKBCommon).GetDrug()				// 药品实体id
		s propID=##class(web.DHCCKBCommon).GetDayDoseProp()			// 每日用药量属性id
		s sign="LessThenEquals"
		s propRequiredFlag=1
	}
	elseif (key = "drugFreq"){
		s entityID=##class(web.DHCCKBCommon).GetDrug()				// 药品实体id
		s propID=##class(web.DHCCKBCommon).GetDrugFreqProp()		// 频率属性id
		s propRequiredFlag=1

	}
	elseif (key = "onceDoseMax"){
		s entityID=##class(web.DHCCKBCommon).GetDrug()				// 药品实体id
		s propID=##class(web.DHCCKBCommon).GetOnceDoseMaxProp()		// 单次用药量属性id
		s sign="LessThenEquals"
		s propRequiredFlag=1
	}
	elseif (key = "dayDoseMax"){
		s entityID=##class(web.DHCCKBCommon).GetDrug()				// 药品实体id
		s propID=##class(web.DHCCKBCommon).GetDayDoseMaxProp()		// 每日用药最大量属性id
		s sign="LessThenEquals"
		s propRequiredFlag=1

	}
	elseif (key = "onceDoseLimit"){ 
		s entityID=##class(web.DHCCKBCommon).GetDrug()				// 药品实体id
		s propID=##class(web.DHCCKBCommon).GetOnceDoseLimitProp()	// 单次用药极量属性id
		s propRequiredFlag=1

	}elseif (key = "dayDoseLimit"){
		s entityID=##class(web.DHCCKBCommon).GetDrug()				// 药品实体id
		s propID=##class(web.DHCCKBCommon).GetDayDoseLimitProp()	// 每日用药极量属性id
		s sign="LessThenEquals"
		s propRequiredFlag=1

	} //39
	elseif (key = "linkTreat"){
		s entityID=##class(web.DHCCKBCommon).GetDrug()				// 药品实体id
		s propID=##class(web.DHCCKBCommon).GetTreatmentProp()		// 疗程属性id
		s propRequiredFlag=1
	}
	elseif (key = "linkSpaceTreat"){
		s entityID=##class(web.DHCCKBCommon).GetDrug()				// 药品实体id
		s propID=##class(web.DHCCKBCommon).GetTreatBettenDayProp()	// 疗程间间隔时长
		s propRequiredFlag=1
	} //42
	elseif (key = "carryUseDrug"){
		s entityID=##class(web.DHCCKBCommon).GetDrug()				// 药品实体id
		s propID=##class(web.DHCCKBCommon).GetcarryUseDrugTimeProp()	// 连续用药时间
		s propRequiredFlag=1
	}
	elseif (key = "drugFreq"){
		s entityID=##class(web.DHCCKBCommon).GetDrug()					// 药品实体id
		s propID=##class(web.DHCCKBCommon).GetcarryUseDrugTimeProp()	// 连续用药时间
		s propRequiredFlag=1
	}elseif (key = "togetherType"){
		s entityID=##class(web.DHCCKBCommon).GetDrug()					// 药品实体id
		s propID=##class(web.DHCCKBCommon).GetTogetherProp()			// 药品的合用类别
		s propRequiredFlag=1
	}
	elseif (key = "linkOperTime"){
		s entityID=##class(web.DHCCKBCommon).GetDrug()					// 药品实体id
		s propID=##class(web.DHCCKBCommon).GetMedicalTimeProp()			// 药品的用药时机
		s propRequiredFlag=1
	}
	elseif (key = "TipsAtOnceProp"){
		s entityID=##class(web.DHCCKBCommon).GetDrug()					// 药品实体id
		s propID=##class(web.DHCCKBCommon).GetTipsAtOnceProp()			// 药品的开医嘱提醒
		s propRequiredFlag=1
	}elseif((key="linkCHNDisease")||(key="outCHNLinkDis")) {			//   sufan20200424
		s entityID=##class(web.DHCCKBCommon).ChineseDisease()		    // 中医疾病实体id
	}elseif(key="MedGuidRemProp"){
		s entityID=##class(web.DHCCKBCommon).GetDrug()					// 药品实体id		sufan20200526
		s propID=##class(web.DHCCKBCommon).GetMedDrugNameProp()			// 用药指导提醒
		s propRequiredFlag=1
	}elseif(key="ChnGuidRemProp"){
		s entityID=##class(web.DHCCKBCommon).GetChineseDrug()			// 药品实体id		sufan20200526
		s propID=##class(web.DHCCKBCommon).GetChineseDrugNameProp()		// 用药指导提醒
		s propRequiredFlag=1
	}elseif(key="linkFormProp"){
		s entityID=##class(web.DHCCKBCommon).GetDrug()					// 药品实体id		sufan20200526
		s propID=##class(web.DHCCKBCommon).GetDrugForm()				// 剂型
		s propRequiredFlag=1
	}elseif(key="sinSoluMass"){
		s entityID=##class(web.DHCCKBCommon).GetDrug()					// 药品实体id		sufan20200526
		s propID=##class(web.DHCCKBCommon).GetSinSolMassProp()			// 单支溶质量
		s sign="LessThenEquals"
		s propRequiredFlag=1
	}elseif(key="isNeceSolMed"){
		s entityID=##class(web.DHCCKBCommon).GetDrug()					// 药品实体id		sufan20200526
		s propID=##class(web.DHCCKBCommon).GetNeceSolMedProp()			// 是否必用溶媒药品
		s propRequiredFlag=1
	}elseif(key="sinOrdVehVol"){
		s entityID=##class(web.DHCCKBCommon).GetDrug()					// 药品实体id		sufan20200526
		s propID=##class(web.DHCCKBCommon).GetSinOrdVehVolProp()		// 单次医嘱对应溶媒量
		s sign="LessThenEquals"
		s propRequiredFlag=1
	}elseif(key="isNeceSolDrug"){
		s entityID=##class(web.DHCCKBCommon).GetDrug()					// 药品实体id		sufan20200526
		s propID=##class(web.DHCCKBCommon).GetNeceSolDrugProp()			// 是否必用溶液药品
		s propRequiredFlag=1
	}elseif(key="sinOrdCor"){
		s entityID=##class(web.DHCCKBCommon).GetDrug()					// 药品实体id		sufan20200526
		s propID=##class(web.DHCCKBCommon).GetSingleOrdCorProp()		// 单次医嘱对应溶液量
		s propRequiredFlag=1
	}elseif(key="auxDrugsNum"){
		s entityID=##class(web.DHCCKBCommon).GetDrug()					// 药品实体id		sufan20200526
		s propID=##class(web.DHCCKBCommon).GetAuxDrugsNumProp()			// 辅助用药个数
		s propRequiredFlag=1
	}elseif (key = "bodySurArea"){
		s entityID=##class(web.DHCCKBCommon).GetPatient()				// 患者实体id
		s propID=##class(web.DHCCKBCommon).GetBodySurAreaProp()			// 体表面积属性id
		s propRequiredFlag=1
	
	}elseif (key = "isDiluteProp"){
		s entityID=##class(web.DHCCKBCommon).GetDrug()				// 药品实体id
		s propID=##class(web.DHCCKBCommon).GetDiluteProp()			// 是否必须稀释后给药id
		s propRequiredFlag=1
	
	}
	
	
#;	elseif (key = "linkSpaceTreat"){
#;		s entityID=##class(web.DHCCKBCommon).GetDrug()				// 药品实体id
#;		s propID=##class(web.DHCCKBCommon).GetTreatDayNumProp()		// 疗程内用药间隔
#;		s propRequiredFlag=1
#;	}	

	q:+entityID=0 "-96"		
	q:((propRequiredFlag=1)&(+propID=0)) "-98"

	//	s value=ruleDrugCatIDStr_"&"_constant						// 属性值id&_type (属性值id是一个id串,^分割)
	// @test： left="7^124^variable"  value="124^125&Constant" 
	// @test:	w ##class(web.DHCCKBRuleImprotTest).GetAtomObj("7^124^variable","124^125&Constant")
	// >:GreaterThen, >=:GreaterThenEquals, <:LessThen,<=:LessThenEquals,=:Equals,!=:NotEquals
	// 输入值:Input,输入值(带单位):InputUom,输入值(上下线):InputLimit,选择变量:Variable,选择数据集:选择数据集,选择规则:Parameter

	s left=entityID_"^"_propID_"^"_variable 				// 实体id^属性id^_type
	s len=$length(str,"^")
	f i=1:1:len d
	.s tmpValue=$p(str,"^",i)		//字典数据时,tmpValue：id. 带单位数值时tmpvalue :比值符号@左值@左单位id@右值@右单位id
	.s tmpSign=""
	.s:tmpValue["@" tmpSign=$p(tmpValue,"@",1)
	.i tmpSign'="" s sign=$case(tmpSign,">=":"GreaterThenEquals",">":"GreaterThen","<=":"LessThenEquals","<":"LessThen","Between":"Between",:"Equals")
	.i tmpSign'="" s type=$case(tmpSign,"":"Input","Between":"InputLimit",:"InputUom")
	.i tmpSign="" s type=constant
	.d tmpArr.%Push(..GetAtomObj(left,tmpValue_"&"_type,sign))	
	
	i len=1 q tmpArr.%Get(0)				// 空
	i len>1 q atomObj.%Set("atom",tmpArr)	//{"atom":[]}
}

/// Description:	过敏史Json
/// other:			w ##class(web.DHCCKBRuleImprotTest).GetPatHisAllergyObj("124")
ClassMethod GetPatHisAllergyObj(str, type = "")
{
	n (str,type)
	
	s tmpArr=[],atomObj={}
	
	s variable="variable",constant="Constant",valueType="Constant"
	s sign=$case(type,"out":"NotEquals",:"Equals")
	s entityID=##class(web.DHCCKBCommon).GetPatient()			// 患者实体id
	s propID=##class(web.DHCCKBCommon).GetHisAllergyProp()		// 过敏史属性id	
	
	q:entityID=0 "-99"
	q:entityID=0 "-98"
	
	s left=entityID_"^"_propID_"^"_variable 			// 实体id^属性id^_type

	s len=$length(str,"^")
	f i=1:1:len d
	.s tmpvalue=$p(str,"^",i)
	.q:tmpvalue=""
	.d tmpArr.%Push(..GetAtomObj(left,tmpvalue_"&"_valueType,sign))	
	i len=1 q tmpArr.%Get(0)				// 空
	i len>1 q atomObj.%Set("atom",tmpArr)	//{"atom":[]}
}

/// value: value格式有两种，第一种是普通的输入值，值&值类型. 第二种是带单位的输入，比值符号@左值@左值id@右值@右值id
/// w ##class(web.DHCCKBRuleImport).GetAtomObj("82166^^variable","83264&Constant","Equals")
ClassMethod GetAtomObj(left, value, op)
{
	n (left,value,op)
	
	s entityID=$p(left,"^",1)	// left=实体id^属性id^_type
	s propID=$p(left,"^",2)
	s leftType=$p(left,"^",3)
	
	s valueID=$p(value,"&",1)		// value=属性值id&_type (属性值id是一个id串,^分割)"
	s valueType=$p(value,"&",2)
							
	s atomObj={}	// 一条返回json  --//两条返回json数组

	// 左边 
	s leftObj={}	
	d leftObj.%Set("_varCategoryId",entityID)
	i (+propID'=0)	d  d leftObj.%Set("_var",propID)
	d leftObj.%Set("_type",leftType)

	// 右边
	s valueObj={}
	s tmpvalue=valueID	
	i valueType="Input" d
	.d valueObj.%Set("_content",tmpvalue)	
	e  i valueType="InputUom"  d
	.i tmpvalue["@" d valueObj.%Set("_content",$p(tmpvalue,"@",4))
	.i tmpvalue["@" d valueObj.%Set("_uom",$p(tmpvalue,"@",5)) 
	e  i valueType="InputLimit" d
	.i tmpvalue["@" d valueObj.%Set("_content",$p(tmpvalue,"@",2))			
	.i tmpvalue["@" d valueObj.%Set("_limit",$p(tmpvalue,"@",4))
	.i tmpvalue["@" d valueObj.%Set("_uom",$p(tmpvalue,"@",5))  
	e  i valueType="Constant" d
	.d valueObj.%Set("_const",tmpvalue)
	//e  i Variable="Variable" d
	//e  i Variable="Parameter" d
	
	d valueObj.%Set("_type",valueType)
	d atomObj.%Set("left",leftObj)
	d atomObj.%Set("value",valueObj)
	d atomObj.%Set("_op",op)
	k leftObj,valueObj

	q atomObj
}

/// 输出信息json串
/// w ##class(web.DHCCKBRuleImport).GetAssignObj("",1)
ClassMethod GetAssignObj(flag, rowData)
{
	n (flag,rowData)
			
	s exlanMsg=rowData.%Get("linkExlanMsg")	// 进一步说明
	s errMsg=rowData.%Get("linkErrMsg")		// 错误原因
	s levelFlag=rowData.%Get("levelMsg")	// 提示级别(0,1,2,3)
	i levelFlag="" s levelFlag=1			// 默认为1
	s levelFlag=$case(levelFlag,"0":"Normal","1":"Tips","2":"Warn","3":"Forbid")	
	s sourceMsg=rowData.%Get("msgSource")	// 提示依据
	s alertCat=rowData.%Get("alertCat")		// 警戒类型 
	s OutMsgTips=rowData.%Get("OutMsgTips") // 提醒标记  sufan 2020-04-22
	s variable="variable",constant="Constant"
	s knowledgeSource=rowData.%Get("knowledgeSource") //知识来源   shy 2022-8-26

	k assignArr
	s assignArr=[] 
	s drugPrintID=##class(web.DHCCKBCommon).GetDrugPrint()				// 药品输出实体id
	s passFlagPropID=##class(web.DHCCKBCommon).GetPassFlagProp()		// 通过标记
	s levelFlagPropID=##class(web.DHCCKBCommon).GetLevelFlagProp()		// 管理级别
	s warnMessagePropID=##class(web.DHCCKBCommon).GetWarnMessageProp()	// 提示信息
	s controlLevelPropID=##class(web.DHCCKBCommon).GetControlLevelProp() // 管理力度（警戒类型）
	s sourceMsgPropID=##class(web.DHCCKBCommon).GetSourceMsgProp()		// 提示依据
	s outMsgTipsID=##class(web.DHCCKBCommon).GetControlOutMsgTips()		//消息提醒标记
	s knowledgeSourceID=##class(web.DHCCKBCommon).GetKnowSource()  //知识来源
	
	// 通过标记	
	s left=drugPrintID_"^"_passFlagPropID_"^"_variable
	i flag=1 s passValue=##class(web.DHCCKBCommon).GetDicIdByCode("HasPass")	// 通过
	i flag=0 s passValue=##class(web.DHCCKBCommon).GetDicIdByCode("NotPass")	// 不通过
	i flag="" s passValue=##class(web.DHCCKBCommon).GetDicIdByCode("HasPass")	// 通过sufan 202005028  用药指导
	s value=passValue_"&"_constant
	d assignArr.%Push(..GetAssignComomon(left,value))
	
	// 管理级别	
	s left=drugPrintID_"^"_levelFlagPropID_"^"_variable
	i flag=1 s levelValue=##class(web.DHCCKBCommon).GetDicIdByCode("Normal")	// 正常
	i flag=0 s levelValue=##class(web.DHCCKBCommon).GetDicIdByCode(levelFlag)	
	i flag="" s levelValue=##class(web.DHCCKBCommon).GetDicIdByCode("Normal")	// 正常 sufan 202005028  用药指导
	s value=levelValue_"&"_constant
	d assignArr.%Push(..GetAssignComomon(left,value))
	
	// 提示信息
	s left=drugPrintID_"^"_warnMessagePropID_"^"_variable
	i flag=1 s msg=exlanMsg
	i flag=0 s msg=errMsg
	i flag="" s msg=errMsg					// 提示信息 sufan 202005028  用药指导
	i msg'="" d
	.s value=msg_"&"_"Input"
	.d assignArr.%Push(..GetAssignComomon(left,value))
	
	// 管理力度（警戒类型）
	i alertCat'=""  d	
	.s left=drugPrintID_"^"_controlLevelPropID_"^"_variable
	.s alertCat=$replace(alertCat,"（","(")
	.i alertCat["(" s alertCat=$p(alertCat,"(",1)
	.s alertCatId=..SaveRuleDic(alertCat,alertCat,"togetherType")
	.q:+alertCatId=0
	.s value=alertCatId_"&"_constant
	.d assignArr.%Push(..GetAssignComomon(left,value))
	.
	// 提示依据
	i sourceMsg'=""  d	
	.s left=drugPrintID_"^"_sourceMsgPropID_"^"_variable
	.s value=sourceMsg_"&"_"Input"
	.d assignArr.%Push(..GetAssignComomon(left,value))
		
	// 消息提示标记  sufan 2020-04-30 OutMsgTips
	i OutMsgTips'=""  d
	.s left=drugPrintID_"^"_outMsgTipsID_"^"_variable
	.s OutMsgValue=##class(web.DHCCKBCommon).GetDicIdByCode(OutMsgTips)	
	.s value=OutMsgValue_"&"_constant
	.d assignArr.%Push(..GetAssignComomon(left,value))
	
	// 知识来源   shy 2022-8-26
	i knowledgeSource'=""  d
	.s left=drugPrintID_"^"_knowledgeSourceID_"^"_variable
	.s OutMsgValue=##class(web.DHCCKBCommon).GetDicIdByDesc(knowledgeSource)	
	.s value=OutMsgValue_"&"_constant
	.d assignArr.%Push(..GetAssignComomon(left,value))
	
	i assignArr.%Size()=1 q assignArr.%Get(0)
	i assignArr.%Size()>1 q assignArr
}

/// 输出串
/// w ##class(web.DHCCKBRuleImport).GetAssignComomon("16^74698^variable","26852&Constant")
ClassMethod GetAssignComomon(left, value)
{
	n (left,value)
	
	s drugPrintID=$p(left,"^",1)	// left=药品输出实体id^属性id^_type "_type": "variable"
	s drugPrintPropID=$p(left,"^",2)
	s leftType=$p(left,"^",3)
	
	s valueID=$p(value,"&",1)		// value=属性值id/文本&_type"
	s valueType=$p(value,"&",2)
	
	s assignObj={}
	
	d assignObj.%Set("_varCategoryId",drugPrintID)
	d assignObj.%Set("_var",drugPrintPropID)
	d assignObj.%Set("_type",leftType)
	
	s valueObj={}
	d valueObj.%Set("_type",valueType)
	i valueType="Constant" d
	.i valueID'="" d valueObj.%Set("_const",valueID)
	e  i valueType="Input"  d 
	.i valueID'="" d valueObj.%Set("_content",valueID)

	d assignObj.%Set("value",valueObj)
	
	q assignObj
}

/// Description:	拆分含单位的数值公共方法(规定：含有数值的规则，必须要有单位)
/// Creator:		QuNianpeng 
/// CreateDate:		2019-07-19	
/// Input:			含单位的字符串
/// return:			比值符号@左值@左单位@右值@右单位
/// other:			w ##class(web.DHCCKBRuleImport).GetCommonValueUnit("1月-2岁","=") ≤2周 ＜10mg/kg/日	 ("25mg/日","=") 0.5%～4%溶液"
ClassMethod GetCommonValueUnit(str, calcSign)
{
	
	n (str,calcSign)
	s:calcSign="" calcSign="="

	s str = ##Class(ext.util.String).Replace(str,"、", "&&")	// 中文顿号分割
	s str = ##Class(ext.util.String).Replace(str,"，", "&&")	// 中文逗号分割
	s str = ##Class(ext.util.String).Replace(str,"。","&&")		// 中文句号分割	（英文的点不能替换，可能是小数点）
	s str = ##class(web.DHCCKBCommonUtil).ReplaceSpaceStr(str,"_")	// 统一间隔符
	s str= ##class(web.DHCCKBCommonUtil).ReplaceSignStr(str)		// 统一比值符号
	s str = ##Class(ext.util.String).Replace(str,",", "&&")		// 英文逗号分割
	s str=##Class(ext.util.String).Replace(str," ", "")	

	// 处理逻辑： 先看串中是否有比值符号. 
	//	如果有，则用比值符号分割，前面是比值符号。后面为数字和单位。拆出数字和单位 <10g
	// 	如果没有比值符号,看有没有分割符号-或~，用分割符号切割出单位和数字	1-10g 1g-10g
	s unitDataID=##class(web.DHCCKBCommon).GetUnitData()	// 单位字典默认存在（确保先有单位字典）

	q:+unitDataID=0 "-99"
	
	i str="单次" s str="1次"	// 疗程中，存在单次特殊标记，转换为1次
	s signList=$lb(">=","<=",">","<","=","!=")	// 存在风险,符号的位置不能移动，<不能放到<=前面
	
	s retStr=0,errCode=0
	
	s len=$l(str,"&&")	
	f i=1:1:len  q:errCode'=0  d
	.s tmpstr=$p(str,"&&",i)
	.s flag=0,sign="",leftValue="",leftUnit="",rightValue="",rightUnit=""
	.s size=$LISTLENGTH(signList)		
	.// 获取比值符号标记
	.f k=1:1:size  q:flag=1  d					// 有比值符号
	..s sign=$List(signList,k)
	..q:tmpstr'[sign
	..s flag=1
	..
	.
	.// 包含比值符号
	.i flag=1 d								// 包含了比值符号
	..s rightstr=$p(tmpstr,sign,2)			// 用比值符号分割,拆出数值
	..s rightValue=##class(web.DHCCKBCommonUtil).GetNum(rightstr)	//$zstrip(rightstr,"*A")	// 拆出字符中的数字
	..s:rightValue="" errCode="-94"
	..q:rightValue=""
	..s rightUnit=$p(rightstr,rightValue,2)	// 用数字作为分隔符,拆除单位
	..s:rightUnit="" errCode="-95"
	..q:rightUnit="" 
	..s rightUnit=..ChangeUintByDesc(rightUnit)	// 单位进行转换确认
	..s dicID=##Class(web.DHCCKBRuleImport).SaveCommonDic(rightUnit,rightUnit,unitDataID)	// 拼串（>10g  --）	
	..q:+dicID<=0
	..s rightValue=$case(rightValue["%",1:$p(rightValue,"%",1)/100,:rightValue)
	..s ret=sign_"@@@"_rightValue_"@"_dicID	// ret结构：比值符号@左边值@左边单位@右边值@右边单位
	..i retStr=0 s retStr=ret				// 当只有左值时，把左值和左单位放在右值的位置上
	..e  s retStr=retStr_"^"_ret
	.
	.// 不包含比值符号
	.i flag=0 d								
	..i (tmpstr["_") d						// 1-10kg  1g-10kg
	...s leftstr=$p(tmpstr,"_",1)			// 左边可能是数值，可能是带单位的数值 （10,10kg)
	...s leftValue=##class(web.DHCCKBCommonUtil).GetNum(leftstr) //$zstrip(leftstr,"*A")	// 拆出字符中的数字	
	...s:leftValue="" errCode="-94"
	...q:leftValue=""
	...s leftUnit=$p(leftstr,leftValue,2)
	...s leftUnit=..ChangeUintByDesc(leftUnit)	// 单位进行转换确认
	...s leftUnitID=""
	...i leftUnit'="" d							// 左边含单位,
	....s leftUnitID=##Class(web.DHCCKBRuleImport).SaveCommonDic(leftUnit,leftUnit,unitDataID)
	....q:+leftUnitID<=0	
	...
	...s rightUnitID=""									
	...s rightstr=$p(tmpstr,"_",2)	
	...s rightValue=##class(web.DHCCKBCommonUtil).GetNum(rightstr) //$zstrip(rightstr,"*A")	// 拆出字符中的数字
	...s:rightValue="" errCode="-94"
	...q:rightValue="" 
	...s rightUnit=$p(rightstr,rightValue,2)
	...s:rightUnit="" errCode="-95"
	...q:rightUnit=""
	...s rightUnit=..ChangeUintByDesc(rightUnit)	// 单位进行转换确认
	...i rightUnit'="" d						
	....s rightUnitID=##Class(web.DHCCKBRuleImport).SaveCommonDic(rightUnit,rightUnit,unitDataID)
	....q:+rightUnitID<=0	
	...q:errCode="-95"
	...s leftValue=$case(leftValue["%",1:$p(leftValue,"%",1)/100,:leftValue)
	...s rightValue=$case(rightValue["%",1:$p(rightValue,"%",1)/100,:rightValue)	
	...// 左右单位相同
	...i (rightUnitID'="")&((leftUnitID=rightUnitID)||(leftUnitID=""))  d	//只有一个单位，或单位相同
	....i leftUnitID="" s leftUnitID=rightUnitID
	....s ret="Between"_"@"_leftValue_"@"_leftUnitID_"@"_rightValue_"@"_rightUnitID
	....i retStr=0 s retStr=ret
	....e  s retStr=retStr_"^"_ret
	...
	...// 左右单位不同
	...i (leftUnitID'="")&(leftUnitID'=rightUnitID)  d // 左右单位不同时，拆成两条 // 分隔符前后单位不一致的，拆成两条(3个月-12岁)
	....s leftret=">="_"@@@"_leftValue_"@"_leftUnitID
	....s rightret="<="_"@@@"_rightValue_"@"_rightUnitID	
	....s ret=leftret_"^"_rightret
	....i retStr=0 s retStr=ret
	....e  s retStr=retStr_"^"_ret
	..
	..e  d	// 没有分隔符  1:10000没有考虑
	...s rightValue=##class(web.DHCCKBCommonUtil).GetNum(tmpstr)	//$zstrip(tmpstr,"*A")	// 拆出字符中的数字	
	...s:rightValue="" errCode="-94"
	...q:rightValue=""
	...s rightUnit=$p(tmpstr,rightValue,2)
	...s:rightUnit="" errCode="-95"
	...q:(rightUnit="")
	...s rightUnit=..ChangeUintByDesc(rightUnit)	// 单位进行转换确认
	...s rightUnitID=""
	...i rightUnit'="" d						
	....s rightUnitID=##Class(web.DHCCKBRuleImport).SaveCommonDic(rightUnit,rightUnit,unitDataID)
	....q:+rightUnitID<=0	
	....s rightValue=$case(rightValue["%",1:$p(rightValue,"%",1)/100,:rightValue)
	....s ret=calcSign_"@@@"_rightValue_"@"_rightUnitID
	....i retStr=0 s retStr=ret
	....e  s retStr=retStr_"^"_ret	

	q:errCode'=0 errCode
	q retStr
}

/// Description:	根据汉字转换为具体单位
/// Creator:		QuNianpeng 
/// CreateDate:		2019-07-08	
/// Input:			
/// return:		
/// other:			w ##class(web.DHCCKBRuleImprotTest).ChangeUintByDesc("mg/kg/次")
ClassMethod ChangeUintByDesc(desc)
{
	n (desc)
	q:desc="" ""
	
	i (desc["/日")||(desc["/天")||(desc["/次") d
	.s len=$Length(desc,"/")
	.s:len>1 desc=$p(desc,"/",1,len-1)	//mg/kg/日-> mg/kg    kg/日->kg
	e  i desc["年" s desc="年"
	e  i desc["岁" s desc="岁"
	e  i desc["月" s desc="月"
	e  i desc["周" s desc="周"
	e  i desc["日" s desc="日"
	e  i desc["天" s desc="天"
	e  i desc["小时" s desc="小时"
	e  i desc["分钟" s desc="分钟"
	e  i desc["秒" s desc="秒"
	
	q desc
	
	s unitDataID=##class(web.DHCCKBCommon).GetUnitData()	// 单位字典默认存在（确保先有单位字典）
	i (dosestr["日")||(dosestr["天") d			// 包含日(每日用药量)	0.4g/日 40mg/kg/日
	.s value=##class(web.DHCCKBCommonUtil).GetNum(dosestr)	//$zstrip(dosestr,"*A")	// 拆出字符中的数字
	.s type="day"
	.s tmpstr=$p(dosestr,value,2)  	// g/日 mg/kg/日
	.q:tmpstr=""
	.s value=$case(value["%",1:$p(value,"%",1)/100,:value)
	.s tmplen=$length(tmpstr,"/")
	.s unitstr=""
	.i tmplen>1 s unitstr=$p(tmpstr,"/",1,tmplen-1)	//mg/kg
	.i tmplen=1 s unitstr=$p(tmpstr,"/",1)			//g
	.q:unitstr=""
	.s dicID=..SaveRuleDic(unitstr,unitstr,"unitData")
	.q:+dicID<=0
	.s ret=sign_"@"_value_"@"_dicID_"@"_type
	.
	e  i dosestr["次" d			// 包含次(每次用药量)	0.5g/次 40mg/kg/次
	.s value=##class(web.DHCCKBCommonUtil).GetNum(dosestr)	//$zstrip(dosestr,"*A")	// 拆出字符中的数字
	.s type="once"
	.s tmpstr=$p(dosestr,value,2)  	// g/次 40mg/kg/次
	.q:tmpstr=""
	.s value=$case(value["%",1:$p(value,"%",1)/100,:value)
	.s tmplen=$length(tmpstr,"/")
	.s unitstr=""
	.i tmplen>1 s unitstr=$p(tmpstr,"/",1,tmplen-1)	//g
	.i tmplen=1 s unitstr=$p(tmpstr,"/",1)			//mg/kg
	.q:unitstr=""
	.s dicID=..SaveRuleDic(unitstr,unitstr,"unitData")
	.q:+dicID<=0
	.s ret=sign_"@"_value_"@"_dicID_"@"_type
	e  i (dosestr'["日")&(dosestr'["次")  d	// 0.4g 40mg/kg 40mg/kg/周
	.s value=##class(web.DHCCKBCommonUtil).GetNum(dosestr)	//$zstrip(dosestr,"*A")	// 拆出字符中的数字
	.s type="once"
	.s tmpstr=$p(dosestr,value,2)  			// g mg/kg
	.q:tmpstr=""
	.s value=$case(value["%",1:$p(value,"%",1)/100,:value)
	.s tmplen=$length(tmpstr,"/")
	.s unitstr=""
	.i tmplen=1 s unitstr=$p(tmpstr,"/",1)			//mg/kg 
	.i tmplen>1 s unitstr=$p(tmpstr,"/",1,tmplen-1)	//g		
	.s dicID=""
	.i unitstr'="" d
	..s dicID=..SaveRuleDic(unitstr,unitstr,"unitData")
	.	
	.s ret=sign_"@"_value_"@"_dicID_"@"_type
	
	q ret
}

/// Description:	保存用药频率
/// Creator:		QuNianpeng 
/// CreateDate:		2019-07-08	
/// Input:			str
/// return:			成功id，失败代码
/// other:			w ##class(web.DHCCKBRuleImport).SaveFreqUnit("6~8小时/次") ("bid")	("6~8小时/次")
ClassMethod SaveFreqUnit(str)
{
	n (str)
	
	q:str=0 0
	// 可能存在的格式：【q8h】【q12h】【2次、3次】 【3-4次】 【3～4次/日】 【1-2次/日】 【8小时/次】 【顿服(once)】【1次/12小时】 【1次/周】 【1次/12-24小时:1次/12小时,1次/13小时,......,1次/24小时】
	// (单位中没有日,则默认为日频次.可能还有年，月，周，小时，分,秒)
	// 先将数据转化为固定格式 2次/日(年,月)
	s str=##class(web.DHCCKBCommonUtil).ReplaceSpaceStr(str,"_")	
	//s str=##class(web.DHCCKBCommonUtil).ReplaceStr(str,"&&")
	//s str=$REPLACE(str,"_","&&")  

	s ret=0
	s len=$length(str,"&&")		// 频率为2-4次/日,拆成每日两次，每日3次，每日4次
	f i=1:1:len  d
	.s tmpstr=$p(str,"&&",i)
	.i tmpstr["/"  d			//【3～4次/日】 【8小时/次】 【1次/12小时】 【8小时/次】【1次/周】【1次/12-24小时】
	..s leftstr=$p(tmpstr,"/",1)
	..s rightstr=$p(tmpstr,"/",2)
	..s leftstr=##class(web.DHCCKBCommonUtil).ReplaceSpaceStr(leftstr,"_")	
	..s rightstr=##class(web.DHCCKBCommonUtil).ReplaceSpaceStr(rightstr,"_")
	..i (leftstr["_")&(rightstr'["_") d SaveCode1	//【3～4次/日】【3～4次/周】 【1～2小时/次】【3～4次/2周】
	..//i (leftstr["_")&(rightstr["_") d SaveCode1	//【1-3次/2-5小时】 不支持
	..i (leftstr'["_")&(rightstr'["_") d SaveCode2	//【8小时/次】 【1次/12小时】 【1次/周】
	..i (leftstr'["_")&(rightstr["_") d SaveCode3	//【1次/12-24小时】
	.e   d		// 没有"/" 【q8h】【q12h】【2次】【3-4次】【顿服(once)】 【bid】
	..s tmpstr=##class(web.DHCCKBCommonUtil).ReplaceSpaceStr(tmpstr,"_")
	..i tmpstr'["_" d
	...d SaveCode4
	..e   d
	...d SaveCode5	

	q ret	
	
SaveCode1old	//【3～4次/日】【3～4次/周】 【1～2小时/次】【3～4次/2周】 【"1～2小时/次"】
	s leftStartNum=+$p(leftstr,"_",1)	// 左区间
	s leftEnd=$p(leftstr,"_",2)		// 右区间
	s leftEndNum=##class(web.DHCCKBCommonUtil).GetNum(leftEnd)	//右数字
	s leftEndUnit=$p(leftEnd,leftEndNum,2)	// 右单位
	f num=leftStartNum:1:leftEndNum  d	
	.s freq=""
	.s dicID=0
	.s code=num_leftEndUnit		// 数字加单位
	.i leftEndUnit["次"	s freq=$case(+rightstr'=0,1:rightstr_code,:"1"_rightstr_code)	//【3～4次/日】【3～4次/2周】
	.i rightstr["次" s freq=$case(+rightstr'=0,1:code_rightstr,:code_"1"_rightstr)	//【1～3小时/次】1小时1次  2小时1次  3小时1次 【1～3小时/2次】1小时2次 2小时2次
	.s dicID=..SaveRuleDic(freq,freq,"freqData")
	.q:+dicID<=0
	.i ret=0 s ret=dicID
	.e  s ret=ret_"^"_dicID	
		
	quit
	
SaveCode1	//【3～4次/日】【3～4次/周】 【1～2小时/次】【3～4次/2周】 【"1～2小时/次"】 2020-04-22 qunianpeng 导入成3-4 次/日 
	s leftStartNum=+$p(leftstr,"_",1)	// 左区间 
	s leftEnd=$p(leftstr,"_",2)		// 右区间	  
	s leftEndNum=##class(web.DHCCKBCommonUtil).GetNum(leftEnd)	//右数字
	s leftEndUnit=$p(leftEnd,leftEndNum,2)	// 右单位
	s leftEndUnitStr=leftEndUnit_"/"_rightstr
	s unitDataID=##class(web.DHCCKBCommon).GetUnitData()	// 单位字典默认存在（确保先有单位字典）
	s leftEndUnitID=..SaveRuleDic(leftEndUnitStr,leftEndUnitStr,"unitData")
	i +leftEndUnitID<0 s ret=0
	s ret="Between"_"@"_leftStartNum_"@"_leftEndUnitID_"@"_leftEndNum_"@"_leftEndUnitID

	quit
	
SaveCode2	//【8小时/次】 【1次/12小时】 【1次/周】
	s freq=""
	s dicID=0
	i leftstr["次" s freq=$case(+rightstr'=0,1:rightstr_leftstr,:"1"_rightstr_leftstr)	//【1次/12小时】 【2次/周】
	i rightstr["次" s freq=$case(+rightstr'=0,1:leftstr_rightstr,:leftstr_"1"_rightstr)	//【8小时/次】【8小时/2次】
	q:freq="" ""
	s dicID=..SaveRuleDic(freq,freq,"freqData")	
	q:+dicID<=0
	i ret=0 s ret=dicID
	e  s ret=ret_"^"_dicID	
	
	quit

SaveCode3	//  【1次/12-24小时】 
	s freq=""
	s dicID=0
	s rightStartNum=+$p(rightstr,"_",1)	// 左区间
	s rightEnd=$p(rightstr,"_",2)		// 右区间
	s rightEndNum=##class(web.DHCCKBCommonUtil).GetNum(rightEnd)	//右数字
	s rightEndUnit=$p(rightEnd,rightEndNum,2)	// 右单位
	f num=rightStartNum:1:rightEndNum  d	
	.s freq=""
	.s dicID=0
	.s code=num_rightEndUnit			// 数字加单位	
	.s freq=code_leftstr	
	.q:freq=""
	.s dicID=..SaveRuleDic(freq,freq,"freqData")	
	.q:+dicID<=0
	.i ret=0 s ret=dicID
	.e  s ret=ret_"^"_dicID
	quit

SaveCode4
	s dicID=0
	i (tmpstr="顿服")||(tmpstr="once") d  
	.s dicID=..SaveRuleDic("once",tmpstr,"freqData")	
	e  i (tmpstr["q")&(tmpstr["h") d  
	.s dicID=..SaveRuleDic(tmpstr,tmpstr,"freqData")	 //【q8h】【q12h】
	e  d  
	.i (tmpstr["次")&(tmpstr'["日")&(tmpstr'["周") s dicID=..SaveRuleDic("每日"_tmpstr,"每日"_tmpstr,"freqData")
	.e   s dicID=..SaveRuleDic(tmpstr,tmpstr,"freqData")
	
	q:+dicID<=0 ""
	i ret=0 s ret=dicID
	e  s ret=ret_"^"_dicID	

	quit


SaveCode5old	//【3-4次】	
	s freq=""
	s dicID=0
	s leftStartNum=+$p(tmpstr,"_",1)	// 左区间
	s rightEnd=$p(tmpstr,"_",2)		// 右区间
	s rightEndNum=##class(web.DHCCKBCommonUtil).GetNum(rightEnd)	//右数字
	s rightEndUnit=$p(rightEnd,rightEndNum,2)	// 右单位
	f num=leftStartNum:1:rightEndNum  d	
	.s freq=""
	.s dicID=0
	.s code=num_rightEndUnit			// 数字加单位	
	.s freq="每日"_code	
	.s dicID=..SaveRuleDic(freq,freq,"freqData")
	.q:+dicID<=0
	.i ret=0 s ret=dicID
	.e  s ret=ret_"^"_dicID
	
SaveCode5	//【3-4次】	2020-04-22 qunianpeng 导入成3-4 次/日
	s freq=""
	s dicID=0
	s leftStartNum=+$p(tmpstr,"_",1)	// 左区间
	s rightEnd=$p(tmpstr,"_",2)		// 右区间
	s rightEndNum=##class(web.DHCCKBCommonUtil).GetNum(rightEnd)	//右数字
	s rightEndUnit=$p(rightEnd,rightEndNum,2)	// 右单位	
	s rightEndUnitStr=rightEndUnit_"/"_"日"
	s rightEndUnitID=..SaveRuleDic(rightEndUnitStr,rightEndUnitStr,"unitData")
	i +rightEndUnitID<=0 s ret=0
	q:+rightEndUnitID<=0 ""
	s ret="Between"_"@"_leftStartNum_"@"_rightEndUnitID_"@"_rightEndNum_"@"_rightEndUnitID

	quit
}

/// Description:	规则中if区域json串
/// Creator:		QuNianpeng 
/// CreateDate:		2019-07-08	
/// Input:			str
/// return:			成功id，失败代码
/// other:			w ##class(web.DHCCKBRuleImport).SaveFreqUnit("6~8小时/次")
ClassMethod SetIfObj(atomArr, orArr)
{
	n (atomArr,orArr)
	//规则json输出串	
	s ruleObj={},ifObj={},andObj={}
	
	// and json
	i (atomArr.%Size())=1  d			// atomArr数组中只有一个元素,则需要输出atom:{}. 多个元素则输出atom:[]
	.d andObj.%Set("atom",atomArr.%Get(0))
	i (atomArr.%Size())>1 d
	.d andObj.%Set("atom",atomArr)
	
	i orArr.%Size()=1 d				// orArr数组中只有一个元素,则需要输出or:{}. 多个元素则输出or:[]
	.d andObj.%Set("or",orArr.%Get(0))
	i (orArr.%Size())>1 d
	.d andObj.%Set("or",orArr)	
	
	q:andObj.%ToJSON()="{}" ""

	i (atomArr.%Size()=0)&(orArr.%Size()=1) d	//root={rule:{remark:"",if:{and:{or:{},atom:{},or:{}}},then:{},else:{},_name:"rule"}}
	.d ifObj.%Set("or",andObj.%Get("or"))		
	.e  d
	..d ifObj.%Set("and",andObj)
	
	
	q ruleObj.%Set("if",ifObj)
}

/// Description:	保存代码和描述（公共部分）
/// Creator:		QuNianpeng 
/// CreateDate:		2019-07-08	
/// Input:			代码,描述,所属字典表id
/// return:			成功id，失败代码<0
/// other:			w ##class(web.DHCCKBRuleImport).SaveCommonDic("催眠药","催眠药",106)
ClassMethod SaveCommonDic(code, desc, parref)
{
	n (code,desc,parref)
	
	q:(code="")&(desc="") 0
	/*
	s codeID=##class(web.DHCCKBCommon).GetDicIdByCode(code)				// code是%时发生错误
	s descID=##class(web.DHCCKBCommon).GetDicIdByDesc(desc)
	q:(descID'=0)&(codeID'=descID) descID 	// 代码和描述同时存在，则以描述为主
	q:descID'=0 descID
	*/
	s icdCompare=##class(web.DHCCKBCommon).GetIcdAttrCodeId()
	s dicID=..CheckDictionExist(code,desc,parref)
	s:parref=icdCompare dicID=##class(web.DHCCKBGenDrugLinkIcd).IsDiaHave(desc)  //如果是icd诊断字典 走这个判断 shy 2022-8-22
	q:+dicID'=0 dicID
	q:+dicID=0 -88	// qunianpeng 2020/4/3 不存在的数据不新增
	s dicID=0
	s dicID=##class(web.DHCCKBDiction).SaveDic("^"_code_"^"_desc_"^"_parref)	//保存
	
	q dicID
}

/// Description:	获取错误信息
/// Creator:		QuNianpeng 
/// CreateDate:		2019-10-17	
/// Input:			
/// return:			
/// other:			w ##class(web.DHCCKBRuleImport).SaveFreqUnit("6~8小时/次")
ClassMethod GetErrMsg(key, incode)
{
	n (key,incode)
	
	s code = $p(incode,"^",1)
	s quitval = $p(incode,"^",2)
	
	s msg=""
	
	if (code = "-99"){
		s msg=..GetValueByCode(key)_":字典缺失."_"(错误代码)"_key
	}elseif(code="-98"){
		s msg=..GetValueByCode(key)_":属性缺失."_"(错误代码)"_key
	}elseif(code="-97"){
		s msg=..GetValueByCode(key)_":属性关联失败."_"(系统错误代码)"_key
	}elseif(code="-96"){
		s msg=..GetValueByCode(key)_":实体缺失."_"(错误代码)"_key
	}elseif(code="-95"){
		s msg=..GetValueByCode(key)_":含数字运算的规则,必须包含单位."_"(错误代码)"_key
	}elseif(code="-94"){
		s msg=..GetValueByCode(key)_":含数字运算的规则,必须包含数值."_"(错误代码)"_key
	}elseif(code=-88){
		s msg=..GetValueByCode(key)_":"_" 字典数据 """_quitval_""" 不存在,请先新增"_..GetValueByCode(key)	// qunianpeng 2020/4/3
	}
	elseif(code<0){
		s msg=..GetValueByCode(key)_":"_"(错误代码_"_code_")"_key
	}

	elseif(+code=0)||(code={}){
		s msg=..GetValueByCode(key)_":系统错误-json拼串错误/字典数据保存失败."_"(系统错误代码)"_key
	}	
	
	q msg
}

/// Description:	存储关联属性
/// Creator:		QuNianpeng 
/// CreateDate:		2019-11-06	
/// Input:			
/// return:			
/// other:			w ##class(web.DHCCKBRuleImport).SaveLinkProp(50,103)
ClassMethod SaveLinkProp(parref, linkDr)
{
	n (parref,linkDr)
	
	q:(+parref=0)||(+linkDr=0) 0
	// 目录保存后,在药品的属性下面建立对应的关联属性,用于关联存储原文
	s ret=0
	i $d(^CT.CKB.PDSS.CommonDictionI("ParrefLinkDr",parref,linkDr))  d
	.s ret=$o(^CT.CKB.PDSS.CommonDictionI("ParrefLinkDr",parref,linkDr,""),-1)
	e  d
	.s ret=##class(web.DHCCKBDiction).SaveDic("^^^"_parref_"^"_linkDr)
	
	q ret
}

/// Description:	清除药品之前的规则
/// Creator:		QuNianpeng 
/// CreateDate:		2019-11-05	
/// Input:			
/// return:			
/// other:			w ##class(web.DHCCKBRuleImport).DeleteDicRule("")
ClassMethod DeleteDicRule(pid)
{
	n (pid)
	
	s row="",exitFlag=0,dicID=""
	f  s row=$o(^TMP("DHCCKB","web.DHCCKBRuleImport","TmpImportData",pid,row))  q:(row="")||(exitFlag=1)  d	
	.s rowData=$g(^TMP("DHCCKB","web.DHCCKBRuleImport","TmpImportData",pid,row))	
	.s baseObj=..StrToObj(rowData,"base")
	.q:baseObj.%Size()=0
	.q:baseObj.%Get("itmGeneName")=""
	.s generIDStr=..SaveRuleDic(baseObj.%Get("itmGeneName"),baseObj.%Get("itmGeneName"),"itmGeneName")
	.s generID=$p(generIDStr,"^",1)
	.i +generID'=0 s exitFlag=1,dicID=generID

	q:dicID="" ""

	s RDRowId=""	// 这一段删除很慢
	f  s RDRowId=$o(^CT.CKB.PDSS.RuleDicI("Dic",dicID,RDRowId))  q:RDRowId=""  d
	.q:RDRowId=0
	.s ruleId=$lg($g(^CT.CKB.PDSS.RuleDicD(RDRowId)),2)
	.q:+ruleId=0
	.d ##class(web.DHCCKBRuleSave).RemoveRule(ruleId)
	.&sql(delete from CKB_PDSS.RuleDataLog where RDL_Rule=:ruleId)
	.&sql(delete from CKB_PDSS.RuleLog where RL_Rule=:ruleId)
	.&sql(delete from CKB_PDSS.RuleAction where RA_RuleId=:ruleId)
	.
	s drugPropID=##class(web.DHCCKBCommon).GetDrugProp()
	s drugLibaryPropID=##class(web.DHCCKBCommon).GetDrugLibary()
	s ingreTempID=##class(web.DHCCKBCommon).GetIngredientPropTemp()
	s attrCode=""
	f  s attrCode=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",dicID,attrCode))  q:attrCode=""  d
	.q:attrCode=0
	.s parref=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrCode)),4)
	.q:(drugPropID'=parref)&(drugLibaryPropID'=parref)&(ingreTempID'=parref)
	.s linkDr=""
	.f  s linkDr=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",dicID,attrCode,linkDr))  q:linkDr=""  d
	..q:linkDr=0
	..&sql(delete from CT_CKB_PDSS.DicLinkAttr where DLA_RowID=:linkDr)

	q dicID
}

/// Description:	判断字典级别下的代码和描述是否存在
/// Creator:		QuNianpeng 
/// CreateDate:		2020-01-22	
/// Input:			代码，描述，字典id
/// return:			存在则返回id，不存在则返回0
/// w ##class(web.DHCCKBRuleImport).CheckDictionExist("CYP2D6酶抑制剂","CYP2D6酶抑制剂",106)
ClassMethod CheckDictionExist(dicCode, dicDesc, parref)
{
	n (dicCode,dicDesc,parref)
	q:(dicCode="")&(dicDesc="") 0
	
	s ret=0,codeExistFlag=0,descExistFlag=0,codeDr=0,descDr=0	
	i (dicCode'="")&&($d(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(dicCode))))  d	// 代码存在（代码是唯一项）
	.s tmpDicID=""
	.f  s tmpDicID=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(dicCode),tmpDicID))  q:(tmpDicID="")||(codeExistFlag=1)  d
	..s tmpParref=$lg($g(^CT.CKB.PDSS.CommonDictionD(tmpDicID)),4)
	..q:(parref'="")&(parref'=..GetDicParrefId(tmpDicID))			//sufan 2020-06-03
	..Q:##class(web.DHCCKBCommon).IsEnabled(tmpDicID)'=1
	..s codeExistFlag=1
	..s codeDr=tmpDicID
	..s ret=-98	
	.
	i (ret=0)&(dicDesc'="")&&($d(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(dicDesc))))  d	// 描述存在
	.s tmpDicID=""
	.f  s tmpDicID=$o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(dicDesc),tmpDicID))  q:(tmpDicID="")||(descExistFlag=1)  d
	..s tmpParref=$lg($g(^CT.CKB.PDSS.CommonDictionD(tmpDicID)),4)
	..q:(parref'="")&(parref'=..GetDicParrefId(tmpDicID))
	..Q:##class(web.DHCCKBCommon).IsEnabled(tmpDicID)'=1
	..s descExistFlag=1
	..s descDr=tmpDicID
	//q:(codeDr'=0)&(codeDr'=descDr) codeDr 	// 代码和描述同时存在，则以code为主
	q:codeDr'=0 codeDr
	q:descDr'=0 descDr

	q 0
}

/// Descript:根据元素Id，取元素字典Id
/// Creator:sufan
/// CreateDate:2020-06-03
/// Input:元素Id
/// Output：字典Id
/// w ##class(web.DHCCKBRuleImport).GetDicParrefId(214294)
ClassMethod GetDicParrefId(dicId)
{
	n (dicId)
	
	s parrefId = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicId)),4)
	i parrefId'="" d
	.s prentId = ..GetDicParrefId(parrefId)
	e  s prentId = dicId
	Q prentId
}

ClassMethod killTmpGlobal(pid) As %String
{
	n (pid)
	
	k ^TMP("DHCCKB","web.DHCCKBRuleImport","TmpImportData",pid)
}

/// 提交规则
/// s Err=##class(web.DHCCKBRuleImport).ImportNew()
/// 					  baseObj,ruleObj,outPutObj,	1,				0,				1,labGenObj,"",LoginInfo
ClassMethod ImportNew(baseObj, ruleObj, outPutObj, successNum = 1, errNum = 0, total = 1, labGenObj = "", Inflag = "", LoginInfo, emRuleObj)
{
	n (baseObj,ruleObj,outPutObj,successNum, errNum,total,labGenObj,Inflag,LoginInfo,emRuleObj)

	s mDel=""
	s num=baseObj.%Get("num")	// 序号
	s err=1,msg = ""					// 事务标志		
	//目录和药品名称
	s generID="",labelID=""
	TS
	// 药名+原文+病症+系统疾病+症状+不明确列 （暂存，导出用）
	//d ..SaveTmpDrugGlobal(pid,baseObj,ruleObj)
	s atomArr=[],orArr=[]					// 数组存储数据串信息
	s alertCat=outPutObj.%Get("alertCat")	// 警戒类型(含过敏)
	// 保存药品代码和描述(带剂型的商品名)
	//i (baseObj.%Get("itmCode")="")||(baseObj.%Get("itmGeneName")="") s err=0,msg="通用名代码/描述不存在，请检查数据或者列头"
	
	i Inflag=1  {
		i (baseObj.%Get("itmGeneName")="") s err=0,msg="通用名代码/描述不存在，请检查数据或者列头"
		i err=0 d SetTroInfoNew
		q:err=0 "-1"
		s generIDStr=..SaveRuleDic(baseObj.%Get("itmGeneName"),baseObj.%Get("itmGeneName"),"itmGeneName")
		s generID=$p(generIDStr,"^",1)
		i +generID="" s err=0,msg="通用名保存失败"
		i +generID=0 d SetTroInfoNew
		q:+generID=0 "-2"
		// 保存目录
		s labelID=..SaveRuleDic(baseObj.%Get("itmLibary"),baseObj.%Get("itmLibary"),"itmLibary")	
		s:+labelID=0 err=0,msg="关系目录保存失败"
		i err=0 d SetTroInfoNew
		q:err=0 "-3"
	
		// 目录保存后,在药品的属性下面建立对应的关联属性,用于关联存储原文
		s drugProp=##class(web.DHCCKBCommon).GetDrugProp()
		s labelPropID=..SaveLinkProp(drugProp,labelID)
		s labelArr(labelPropID)=$case($d(labelArr(labelPropID))>0,1:$g(labelArr(labelPropID))+1,:1)
		s:+labelPropID=0 err=0,msg="关系目录属性保存失败"
		i err=0 d SetTroInfoNew
		q:err=0 "-4"	
		d CommonBaseSaveNew	// 保存药品基本信息列(药品信息类只需要报存一次)
		i err=0 d SetTroInfoNew
		q:err=0 "-5"
	}
	i Inflag'=1  d
	.s generID=labGenObj.%Get("generID"),labelID=labGenObj.%Get("labelID")
	s labValueObj=0,mensObj=0,solutObj=0
	d CommonRuleSaveNew	// 保存规则列，并生成规则json	
	i err=0 d SetTroInfoNew
	
	s outObj = {}
	s outObj.code = "err"
	s outObj.content = msg
	q:err=0 outObj.%ToJSON()
	
	// 规则json串处理	
	s root={},inputRuleObj={},ifObj={},thenObj={},elseObj={}
	d SetInputRuleObjNew
	
	// 输出信息json串处理
	d SetRuleOutPutObjNew
	s tmpkey=emRuleObj.%Get("empRuletip")
	s labelDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(labelID)),3)			// 目录描述	
	s tipsFlag=$case(
		(labelDesc["用法用量")||(labelDesc["适应")||(labelDesc["功能主治")
		||(labelDesc["同用药品间隔使用方法")||(labelDesc["严重药品不良反应前兆")||(labelDesc["用药后的身体反应")
		||(labelDesc["特殊人群和特殊职业者")||(labelDesc["特殊的储存方法")||(labelDesc["漏服药品的处理办法")
		||(labelDesc["对用药过程的指导")||(labelDesc["服药期间饮食方面需要注意的事项")||(labelDesc["装置")
		||(labelDesc["生活中需要特别注意的事项")||(labelDesc["有效期")||(tmpkey="MedGuidRemProp")||(tmpkey="ChnGuidRemProp"),
		1:1,:0
	) 

	i (tipsFlag=1)&(ifObj.%ToJSON()="{}") s elseObj={}	// 规则为空时,错误输出的提醒不需要
	i (tipsFlag=0)&(ifObj.%ToJSON()="{}") s thenObj={}
	i (((tipsFlag=1)&(thenObj.%Size()'=0))||((tipsFlag=0)&(elseObj.%Size()'=0)))&(ifObj.%Size()=0) d 
	.d SetTipAtOnceNew									//空规则处理
	.d SetInputRuleObjNew

	i (ifObj.%Size()=0)&(thenObj.%Size()=0)&(elseObj.%Size()=0) s err=0,msg="规则为空"
	i err=0 d SetTroInfoNew
	
	s outObj.code = "err"
	s outObj.content = msg
	q:err=0 outObj.%ToJSON()
	
	d inputRuleObj.%Set("if",ifObj).%Set("then",thenObj).%Set("else",elseObj).%Set("_name","rule").%Set("remark","")
	d root.%Set("rule",inputRuleObj)	// root={rule:{remark:"",if:{and:{atom:{},or:{}}},then:{},else:{},_name:"rule"}}
	s dicStr=generID_"^"_labelID	// 药品名称id^目录id
	//s status="Release"
	s userId = $p(LoginInfo,"^",1) 
	s ret= ..SubmitRule(root.%ToJSON(),userId,dicStr,LoginInfo)	// save方法中,root是json字符串,不成直接传json对象 2021/6/25 qnp

	//s ret=##class(web.DHCCKBRuleSave).save(0,status,root.%ToJSON(),"",dicStr,LoginInfo)	// save方法中,root是json字符串,不成直接传json对象
	i ret<0 s err=0
	k root,inputRuleObj,ifObj,thenObj,elseObj,atomArr,orArr
	i err=1 do
	.s successNum=successNum+1
	.TCOMMIT
	else  d SetTroInfoNew
	i (successNum'=0) 	d
	.d outObj.%Set("code","success").%Set("total",total).%Set("successNum",successNum).%Set("errNum",errNum).%Set("msg","").%Set("rule",ret)
	e  d
	.d outObj.%Set("code","err").%Set("total",total).%Set("successNum",successNum).%Set("errNum",errNum).%Set("msg",$case(msg,"":"系统错误,代码"_$ze,:msg)).%Set("rule",$g(ret))
	q outObj.%ToJSON()
	
	
SetTroInfoNew
	tro
	s errNum=errNum+1
	i Inflag=1  d
	.s ^TMP("DHCCKB","web.DHCCKBRuleExport","ExportDataErrMsg",pid,row)=rowData_"[next]"_"errMsg"_$c(1)_msg	// 记录提交失败信息
	Quit	
CommonBaseSaveNew					/// 药品基本信息保存

	set itr = baseObj.%GetIterator()

	while itr.%GetNext(.key,.val) {
	
		continue:val=""		// value是空则不需要保存
		continue:val=" "	// 空格
		continue:(key="num")||(key="itmCode")||(key="itmGeneName")||(key="itmLibary")	//序号,编码,通用名
		if (key="itmText"){	
			
			if ($g(labelArr(labelPropID)) = 1){
				s linkID=..SaveCommonDicLinkAttr(generID,labelPropID,mDel,val)
				if linkID<0 s err=0,msg=..GetErrMsg(key,linkID)				
			}				
		}
		continue:(key="itmText")
	
		if (total = 1){
			
			// 英文名称/原文 	需要保存和通用名的关联关系		
			if (key="itmEnName")||(key="prioCondition"){	
				s linkID=..SaveCommonDicLinkAttr(generID,key,mDel,val)
				if linkID<0 s err=0,msg=..GetErrMsg(key,linkID)		
			}		 
			elseif (key="itmProName"){		//商品名  需要保存和通用名的关联关系	
				s dicIDStr=..SaveRuleDic(baseObj.%Get("itmCode"),val,key)		// 将字典数据存储起来
				i +dicIDStr<=0 s err=0,msg=..GetErrMsg(key,dicIDStr)	
				continue:err=0
				s linkID=..SaveCommonDicLinkAttr(generID,key,dicIDStr)
				i $g(linkID)<0 s err=0,msg=..GetErrMsg(key,linkID)				
			}
			// 成分	格式： 成分1:10mg 或者成分1 "空格" 10mg (多个成分之间用顿号)
			elseif (key="itmIngre"){
				s dicIDStr=..SaveRuleDic(val,val,key)		// 将字典数据存储起来
				i +dicIDStr<=0 s err=0,msg=..GetErrMsg(key,dicIDStr)	
				continue:err=0			
				s linkID=..SaveDicLinkIngre(generID,dicIDStr,val)
				i $g(linkID)<0 s err=0,msg=..GetErrMsg(key,linkID)					
			}		
			//辅料/剂型,  需要保存和通用名的关联关系
			elseif (key="itmExcipient")||(key="itmForm"){			
				s dicIDStr=..SaveRuleDic(val,val,key)		// 将字典数据存储起来
				i +dicIDStr<=0 s err=0,msg=..GetErrMsg(key,dicIDStr)	
				continue:err=0
				s linkID=..SaveCommonDicLinkAttr(generID,key,dicIDStr)
				i $g(linkID)<0 s err=0,msg=..GetErrMsg(key,linkID)
				
			}else{
				s dicIDStr=..SaveRuleDic(val,val,key)		// 将字典数据存储起来
				i +dicIDStr<=0 s err=0,msg=..GetErrMsg(key,linkID)
			}
		}		
	
		q:err=0	
	}

	quit 
CommonRuleSaveNew				/// 规则中不含数值和单位的字典形规则保存
	
	set itr = ruleObj.%GetIterator()
	while itr.%GetNext(.key,.val) {
		s val=$tr(val,$c(13),"")
		s val=$tr(val,$c(10),"")
		s val=$tr(val,$c(13,10),"")
		continue:val=""					// value是空则不需要保存
		continue:val=" "	
		continue:key="linkAdvice"		// 特别推荐不保存
		continue:key="otherNoSureDis"	// 与适应证相关列不保存
		continue:key="OnceDose"	
		continue:key="DayDose"					
	 	continue:key="linkDoseMax"				
	 	continue:key="linkDoseLimit"		
	 	continue:key="onceDoseMax"
	 	continue:key="onceDoseLimit"
	 	continue:key="linkDose"
		// 检验指标,检验指标值，特别推荐
		s flag=(key="linkLabItm")||(key="linkLabValue")||(key="linkAdvice")
		// 年龄,体重,溶媒浓度,溶媒体积
		s flag=flag||(key="linkAge")||(key="linkWeight")||(key="linkSolDens")||(key="linkSolVolume")
		// 溶液浓度,溶液体积,给药速度,给药时间,
		s flag=flag||(key="linkSolutionDens")||(key="linkSolutionVolume")||(key="linkSpeed")||(key="linkDrugUseTime")
		// 剂量,频次,疗程内用药时长  最大量,极量,疗程
		s flag=flag||(key="linkDose")||(key="linkDoseMax")||(key="linkDoseLimit")||(key="linkTreat")
		//疗程间间隔,连续用药,阶梯给药
		s flag=flag||(key="linkSpaceTreat")||(key="carryUseDrug")||(key="spaceSendTime")
		//单支溶质量,单次医嘱对应溶媒量,单次医嘱对应溶液量
		s flag=flag||(key="sinSoluMass")||(key="sinOrdVehVol")||(key="sinOrdCor")
		//体表面积
		s flag=flag||(key="bodySurArea")||(key="DrugFreq")||(key="TreatDayNUm")
		// 以上这些列，不能直接保存，需要拆出单位，保存单位，然后生成规则
		if flag=1 d commonRuleUnitSaveNew
		continue:flag=1	
		if (key="auxDrugsNum") d
		.s entityID=##class(web.DHCCKBCommon).GetDrug()			// 西药实体
		.s propID=##class(web.DHCCKBCommon).GetAuxDrugsNumProp()			// 辅助用药个数
		.s variable="variable"
		.s sign="Equals" 
		.s left=entityID_"^"_propID_"^"_variable
		.d atomArr.%Push(..GetAtomObj(left,val_"&"_"Input",sign))
				
	 	continue:key="auxDrugsNum"					//辅助用药个数单独处理
	  	continue:key="isNeceSolMed"				//是否必用溶媒不导入
	 	continue:key="isNeceSolDrug"		 //是否必用溶液不导入
		
		s dicIDStr=..SaveRuleDic(val,val,key)		// 将字典数据存储起来		
		i +dicIDStr<=0 s err=0,msg=..GetErrMsg(key,dicIDStr)	
		q:+dicIDStr<=0		
		s out=$extract(key,1,3)		// 除外标志
		
		if (key="outDrugAllergy"){					// 环境过敏因素
			s tmpObj=..GetPatHisAllergyObj(dicIDStr)
			s:(+tmpObj<=0)||(tmpObj={}) err=0,msg=..GetErrMsg(key,tmpObj)
			continue:(+tmpObj<=0)||(tmpObj={})
			i tmpObj.%Get("atom")="" d atomArr.%Push(tmpObj) 				
			e  d orArr.%Push(tmpObj)					
		}
		elseif (key="linkGeneNoDos")||(key="linkGeneName")||(key="linkProName")||(key="linkCat")||(key="linkIngre")||(key="itmExcipient"){		// (通用名，商品名,分类,成分)
			
			i alertCat["过敏" s tmpObj=..GetPatHisAllergyObj(dicIDStr)
			e  s tmpObj=..GetCommonObj(key,dicIDStr,"")
			s:(+tmpObj<=0)||(tmpObj={}) err=0,msg=..GetErrMsg(key,tmpObj)	
			continue:(+tmpObj<=0)||(tmpObj={})
			i tmpObj.%Get("atom")="" d atomArr.%Push(tmpObj) 				
			e  d orArr.%Push(tmpObj)	
			
		}
		elseif (key["out"){		// 含除外的列		
			if (key="outLinkCat")||(key="outLinkIngre"){						// 除外过敏
				i alertCat["过敏" s tmpObj=..GetPatHisAllergyObj(dicIDStr,"out")
				e  s tmpObj=..GetCommonObj(key,dicIDStr,"out")
				s:(+tmpObj<=0)||(tmpObj={}) err=0,msg=..GetErrMsg(key,tmpObj)
				continue:(+tmpObj<=0)||(tmpObj={})				
				i tmpObj.%Get("atom")="" d atomArr.%Push(tmpObj) 				
				e  d orArr.%Push(tmpObj)			
			}else{
				s tmpObj=..GetCommonObj(key,dicIDStr,"out")
				s:(+tmpObj<=0)||(tmpObj={}) err=0,msg=..GetErrMsg(key,tmpObj)		
				continue:(+tmpObj<=0)||(tmpObj={})
				i tmpObj.%Get("atom")="" d atomArr.%Push(tmpObj) 				
				e  d orArr.%Push(tmpObj)		
			}	
	
		}elseif (key="linkSolvent"){
					s neceSol=$case(ruleObj.%Get("isNeceSolMed")="",1:"",:ruleObj.%Get("isNeceSolMed"))						//是否必用溶媒药品	
				s solvolume=$case(ruleObj.%Get("linkSolVolume")="",1:"",:ruleObj.%Get("linkSolVolume"))		//溶媒体积
				s solConcent=$case(ruleObj.%Get("linkSolDens")="",1:"",:ruleObj.%Get("linkSolDens"))					//溶媒浓度
				s sinOrdVe=$case(ruleObj.%Get("sinOrdVehVol")="",1:"",:ruleObj.%Get("sinOrdVehVol"))					//单次医嘱对应溶媒量
				s mensObj=##class(web.DHCCKBRuleImport).GetSolutObj(neceSol_"^"_"isNeceSolMed",solvolume_"^"_"linkSolVolume",solConcent_"^"_"linkSolDens",sinOrdVe_"^"_"sinOrdVehVol",val,key)
				
				s:mensObj=0 err=0,msg=..GetErrMsg(key,tmpStr)	
		}elseif (key="linkSolution"){
				s neceSol=$case(ruleObj.%Get("isNeceSolDrug")="",1:"",:ruleObj.%Get("isNeceSolDrug"))					//是否必用溶液药品	
				s solvolume=$case(ruleObj.%Get("linkSolutionVolume")="",1:"",:ruleObj.%Get("linkSolutionVolume"))		//溶液体积
				s solConcent=$case(ruleObj.%Get("linkSolutionDens")="",1:"",:ruleObj.%Get("linkSolutionDens"))					//溶液浓度
				s sinOrdVe=$case(ruleObj.%Get("sinOrdCor")="",1:"",:ruleObj.%Get("sinOrdCor"))					//单次医嘱对应溶液量
				s solutObj=##class(web.DHCCKBRuleImport).GetSolutObj(neceSol_"^"_"isNeceSolDrug",solvolume_"^"_"linkSolutionVolume",solConcent_"^"_"linkSolutionDens",sinOrdVe_"^"_"sinOrdCor",val,key)
				s:solutObj=0 err=0,msg=..GetErrMsg(key,tmpStr)				
		}
		else{
			s tmpObj=..GetCommonObj(key,dicIDStr)
			s:(+tmpObj<=0)||(tmpObj={}) err=0,msg=..GetErrMsg(key,tmpObj)	
			continue:(+tmpObj<=0)||(tmpObj={})
			i tmpObj.%Get("atom")="" d atomArr.%Push(tmpObj) 				
			e  d orArr.%Push(tmpObj)	
			
		}
		q:err=0
	}

	Quit
commonRuleUnitSaveNew	//规则中含数值和单位形式的规则保存	
	
	if (key ="linkLabItm"){						
		if (ruleObj.%Get("linkLabValue")=""){	// 指标值列 不含指标名称，只有指标范围值
			s dicIDStr=..SaveRuleDic(val,val,key)		// 将指标值范围为空时,存指标范围	
			i +dicIDStr<=0 s err=0,msg=..GetErrMsg(key,dicIDStr)
			q:+dicIDStr<=0						
			s tmpObj=..GetCommonObj(key,dicIDStr)
			s:(+tmpObj<=0)||(tmpObj={}) err=0,msg=..GetErrMsg(key,tmpObj)		
			q:(+tmpObj<=0)||(tmpObj={})
			i tmpObj.%Get("atom")="" d atomArr.%Push(tmpObj) 				
			e  d orArr.%Push(tmpObj)
		}
								
	}elseif (key="linkLabValue"){	//检验指标值
	
		// 格式可能：格式1，心率<45次/分、P-Q间期>0.24秒、收缩压<100mmHg  		格式2：指标测试1  >=12ml 格式3
		s labItm=$case(ruleObj.%Get("linkLabItm")="",1:"",:ruleObj.%Get("linkLabItm"))
	
		s labValueObj=##class(web.DHCCKBRuleImport).GetLabValueObj(labItm,val,key)
		s:labValueObj=0 err=0,msg=..GetErrMsg(key,tmpStr)	
		q:err=0
		
				
	}elseif (key="spaceSendTime"){	//阶梯给药
		

	}elseif (key="linkDose"){		// 剂量,频次,疗程内用药时长
		s str=##Class(ext.util.String).Replace(val,",","!!")	// 中英文逗号分隔
		s str=##Class(ext.util.String).Replace(str,"，","!!")
		s doseStr=$p(str,"!!",1)		// 剂量	
		s freqStr=$p(str,"!!",2)		// 频次	
		s treatStr=$p(str,"!!",3)		//疗程内用药时长
		if (doseStr'="")&(doseStr'=0){				// 剂量
			s tmpStr=..GetCommonValueUnit(doseStr,"<=")		
			s:(tmpStr<0)||(tmpStr=0) err=0,msg=..GetErrMsg(key,tmpStr)
			q:(tmpStr<0)||(tmpStr=0) 
			s tmpKey=$select((doseStr["日")||(doseStr["天"):"dayDose",doseStr["次":"onceDose",1:"onceDose")
			s tmpObj=..GetCommonObj(tmpKey,tmpStr)
			s:(+tmpObj<=0)||(tmpObj={}) err=0,msg=..GetErrMsg(tmpKey,tmpObj)
			q:(+tmpObj<=0)||(tmpObj={}) 
			i tmpObj.%Get("atom")="" d atomArr.%Push(tmpObj) 				
			e  d orArr.%Push(tmpObj)
		
		}
		
		if (freqStr'="")&(freqStr'=0){			// 频次	
			s str=..SaveFreqUnit(freqStr)	
			s:str=0 err=0,msg=..GetErrMsg(key,str)
			q:str=0
			s tmpObj=..GetCommonObj("drugFreq",str)
			s:(+tmpObj<=0)||(tmpObj={}) err=0,msg=..GetErrMsg(key,tmpObj)
			q:(+tmpObj<=0)||(tmpObj={}) 
			i tmpObj.%Get("atom")="" d atomArr.%Push(tmpObj) 				
			e  d orArr.%Push(tmpObj)
		
		}				
		//疗程内用药时长
		
	}elseif (key="DrugFreq"){
		s str=..SaveFreqUnit(val)	
		s:str=0 err=0,msg=..GetErrMsg(key,str)
		q:str=0
		s tmpObj=..GetCommonObj("drugFreq",str)
		s:(+tmpObj<=0)||(tmpObj={}) err=0,msg=..GetErrMsg(key,tmpObj)
		q:(+tmpObj<=0)||(tmpObj={}) 
		i tmpObj.%Get("atom")="" d atomArr.%Push(tmpObj) 				
		e  d orArr.%Push(tmpObj)
	}
	elseif(key="linkDoseMax"){		// 最大量
		s str=..GetCommonValueUnit(val,"<=")
		s:(str<0)||(str=0) err=0,msg=..GetErrMsg(key,str)
		q:(str<0)||(str=0)
		s tmpKey=$select((val["日")||(val["天"):"dayDoseMax",val["次":"onceDoseMax",1:"onceDoseMax")
		s tmpObj=..GetCommonObj(tmpKey,str)
		s:(+tmpObj<=0)||(tmpObj={}) err=0,msg=..GetErrMsg(key,tmpObj)
		q:(+tmpObj
		<=0)||(tmpObj={}) 
		i tmpObj.%Get("atom")="" d atomArr.%Push(tmpObj) 				
		e  d orArr.%Push(tmpObj)
				
	}elseif(key="linkDoseLimit"){	// 极量
		s str=..GetCommonValueUnit(val,"<=")
		s:(str<0)||(str=0) err=0,msg=..GetErrMsg(key,str)
		q:(str<0)||(str=0)
		s tmpKey=$select((val["日")||(val["天"):"dayDoseLimit",val["次":"onceDoseLimit",1:"onceDoseLimit")
		s tmpObj=..GetCommonObj(tmpKey,str)
		s:(+tmpObj<=0)||(tmpObj={}) err=0,msg=..GetErrMsg(key,tmpObj)
		q:(+tmpObj<=0)||(tmpObj={}) 	
		i tmpObj.%Get("atom")="" d atomArr.%Push(tmpObj) 				
		e  d orArr.%Push(tmpObj)
		   
	}elseif ((key="linkSolDens")||(key="linkSolVolume")||(key="sinOrdVehVol")||(key="sinOrdVehVol")){	//溶媒信息
	
	}elseif ((key="linkSolutionDens")||(key="linkSolutionVolume")||(key="isNeceSolDrug")||(key="sinOrdCor")){ //溶液信息
		
	}else{	 
		s str=..GetCommonValueUnit(val,"=")	// 默认是等于
		s:(str<0)||(str=0) err=0,msg=..GetErrMsg(key,str)
		q:(str<0)||(str=0)
		s tmpObj=..GetCommonObj(key,str)
		s:(+tmpObj<=0)||(tmpObj={}) err=0,msg=..GetErrMsg(key,tmpObj)
		q:(+tmpObj<=0)||(tmpObj={}) 
		//d atomArr.%Push(tmpObj.%Get("atom")) 	// 3月-1岁 2020/5/8 qnp
		i tmpObj.%Get("atom")="" d atomArr.%Push(tmpObj) 				
		e  d orArr.%Push(tmpObj)	
	}

	Quit
SetInputRuleObjNew		// 规则json串处理
	
	//规则json输出串	
	//s ifObj={},andObj={}
	s andObj={}
	s linkDose = $case(ruleObj.%Get("linkDose")="",1:"",:ruleObj.%Get("linkDose"))
	s onceDose = $case(ruleObj.%Get("OnceDose")="",1:"",:ruleObj.%Get("OnceDose"))
	s dayDoseMax = $case(ruleObj.%Get("onceDoseMax")="",1:"",:ruleObj.%Get("onceDoseMax"))
	s linkDoseMax = $case(ruleObj.%Get("linkDoseMax")="",1:"",:ruleObj.%Get("linkDoseMax"))
	s linkDoseLimit = $case(ruleObj.%Get("linkDoseLimit")="",1:"",:ruleObj.%Get("linkDoseLimit"))
	s onceDoseLimit = $case(ruleObj.%Get("onceDoseLimit")="",1:"",:ruleObj.%Get("onceDoseLimit"))
	//s linkDosObj = ##class(web.DHCCKBRuleImport).GetDoseObj(linkDose,onceDose,dayDoseMax,linkDoseMax,linkDoseLimit,onceDoseLimit)
	s linkDosObj = ##class(web.DHCCKBRuleImport).GetDoseObjNew(linkDose,onceDose,dayDoseMax,linkDoseMax,linkDoseLimit,onceDoseLimit)
	// and json
	i linkDosObj.%ToJSON()'="{}" d
	.i linkDosObj.%Get("atom")="" d atomArr.%Push(linkDosObj) 				
	.e  d orArr.%Push(linkDosObj)
	
	i (atomArr.%Size())=1  d			// atomArr数组中只有一个元素,则需要输出atom:{}. 多个元素则输出atom:[]
	.d andObj.%Set("atom",atomArr.%Get(0))
	i (atomArr.%Size())>1 d
	.d andObj.%Set("atom",atomArr)

	i orArr.%Size()=1 d				// orArr数组中只有一个元素,则需要输出or:{}. 多个元素则输出or:[]
	.d andObj.%Set("or",orArr.%Get(0))
	i (orArr.%Size())>1 d
	.d andObj.%Set("or",orArr)	
	
	i labValueObj'=0 d
	.i labValueObj.%Size()=1 d andObj.%Set("union2",labValueObj)	// 检验对象比较特殊
	.e  d
	..s tmpOrObj={}
	..d tmpOrObj.%Set("and",labValueObj)
	..d andObj.%Set("or",tmpOrObj)	// 检验对象   mensObj
	

	i mensObj'=0 d
	.d andObj.%Set("union1",mensObj)		// 溶媒对象
	

 	i solutObj'=0 d
	.d andObj.%Set("union",solutObj)	// 溶液对象

	//i linkDosObj.%Get("atom").%Size()'="0"  d
	//.d andObj.%Set("or",linkDosObj)		// 液体量的处理sufan 2021-01-14
	q:andObj.%ToJSON()="{}" ""
	i (atomArr.%Size()=0)&(orArr.%Size()=1)&(solutObj=0)&&(mensObj=0) d	//root={rule:{remark:"",if:{and:{or:{},atom:{},or:{}}},then:{},else:{},_name:"rule"}}
	.d ifObj.%Set("or",andObj.%Get("or"))		
	e  d
	.d ifObj.%Set("and",andObj)

	//d inputRuleObj.%Set("if",ifObj)
	k andObj
	//k ifObj,andObj
	Quit
SetRuleOutPutObjNew		//输出信息json串处理
	s tmpkey=emRuleObj.%Get("empRuletip")
	//s thenObj={},elseObj={}
	// 输出除了用法用量,适应症(进一步说明的都在then里面),其他的都是满足了给提醒(禁忌证、相互作用、配伍禁忌等)(进一步说明的都在else里面)
	s exlanMsg=outPutObj.%Get("linkExlanMsg")		// 进一步说明
	s labelDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(labelID)),3)	// 目录描述	
	i exlanMsg'=""  d
	.i (labelDesc["用法用量")||(labelDesc["适应")||(labelDesc["功能")||(labelDesc["液体配置")  d
	..d thenObj.%Set("var-assign",..GetAssignObj(1,outPutObj))
	.e  d
	..d elseObj.%Set("var-assign",..GetAssignObj(1,outPutObj))
	
	i (labelDesc["用法用量")||(labelDesc["适应")||(labelDesc["功能")||(labelDesc["液体配置")    d	// 不通过提醒
	.d elseObj.%Set("var-assign",..GetAssignObj(0,outPutObj))
	e  i (tmpkey="MedGuidRemProp")||(tmpkey="ChnGuidRemProp")||(labelDesc["同用药品间隔使用方法")||(labelDesc["严重药品不良反应前兆")||(labelDesc["用药后的身体反应")||(labelDesc["特殊人群和特殊职业者")||(labelDesc["特殊的储存方法")||(labelDesc["漏服药品的处理办法")||(labelDesc["对用药过程的指导")||(labelDesc["服药期间饮食方面需要注意的事项")||(labelDesc["装置")||(labelDesc["生活中需要特别注意的事项")||(labelDesc["有效期")  d
	.d thenObj.%Set("var-assign",..GetAssignObj("",outPutObj))
	e  d
	.d thenObj.%Set("var-assign",..GetAssignObj(0,outPutObj))
	
	//d inputRuleObj.%Set("then",thenObj)
	//d inputRuleObj.%Set("else",elseObj)
	//d inputRuleObj.%Set("_name","rule")
	//d inputRuleObj.%Set("remark","")
	//k thenObj,elseObj
	
	Quit
	
	
SetTipAtOnceNew	// 设置空规则的json串
	s tmpId=##class(web.DHCCKBCommon).GetDicIdByCode("true")
	q:+tmpId=0
	s key=emRuleObj.%Get("empRuletip")
	i (key="MedGuidRemProp")||(key="ChnGuidRemProp") s tmpId=generID
	s tmpObj=..GetCommonObj(key,tmpId)
	s:(+tmpObj<=0)||(tmpObj={}) err=0,msg=##class(web.DHCCKBRuleImport).GetErrMsg(key,tmpObj)
	quit:(+tmpObj<=0)||(tmpObj={})	
	i tmpObj.%Get("atom")="" d atomArr.%Push(tmpObj) 				
	e  d orArr.%Push(tmpObj)	
	Quit
}

/// Description:	检验和检验值单独进行处理
/// Creator:		QuNianpeng
/// CreateDate:		2020-03-03
/// Input:			列头描述
/// return:			>0字典id  0 获取失败
/// other:
/// 心率<45次/分、P-Q间期>0.24秒、收缩压<100mmHg  		格式2：指标测试1  >=12ml 格式3
/// w ##class(web.DHCCKBRuleImport).GetLabValueObj("内生肌酐清除率",">100mg/kg","linkLabValue")
ClassMethod GetLabValueObj(labItmStr, str, key)
{
	n (labItmStr,str,key)

	s str = ##Class(ext.util.String).Replace(str,"、", "&&")	// 中文顿号分割
	s str = ##Class(ext.util.String).Replace(str,"，", "&&")	// 中文逗号分割
	s str = ##Class(ext.util.String).Replace(str,"。","&&")		// 中文句号分割	（英文的点不能替换，可能是小数点）
	s str = ##class(web.DHCCKBCommonUtil).ReplaceSpaceStr(str,"_")	// 统一间隔符
	s str= ##class(web.DHCCKBCommonUtil).ReplaceSignStr(str)		// 统一比值符号
	s str = ##Class(ext.util.String).Replace(str,",", "&&")		// 英文逗号分割
	s str=##Class(ext.util.String).Replace(str," ", "")	

	// 处理逻辑： 先看串中是否有比值符号. 
	//	如果有，则用比值符号分割，前面是比值符号。后面为数字和单位。拆出数字和单位 <10g
	// 	如果没有比值符号,看有没有分割符号-或~，用分割符号切割出单位和数字	1-10g 1g-10g
	s unitDataID=##class(web.DHCCKBCommon).GetUnitData()	// 单位字典默认存在（确保先有单位字典）

	q:+unitDataID=0 "-99"
	
	s signList=$lb(">=","<=",">","<","=","!=")	// 存在风险,符号的位置不能移动，<不能放到<=前面
	
	s retStr=0,errCode=0
	
	s andArr=[]
	s existFlag = 0
	s len=$l(str,"&&")	
	f i=1:1:len  q:existFlag=1  d
	.s tmpstr=$p(str,"&&",i)
	.s flag=0,sign="",leftValue="",leftUnit="",rightValue="",rightUnit=""
	.s size=$LISTLENGTH(signList)		
	.// 获取比值符号标记
	.f k=1:1:size  q:flag=1  d					// 有比值符号
	..s sign=$List(signList,k)
	..q:tmpstr'[sign
	..s flag=1
	..
	.q:(flag=0)&(labItmStr="")	// 没有比值符号
	.s atomArr=[]
	.i (labItmStr="")&(flag=1)	d
	..s labItm=$p(tmpstr,sign,1)	//	 检验项,检验套
	..s labValue=$p(tmpstr,sign,2)
	.i labItmStr'="" d
	..s labItm=labItmStr			//	 检验项,检验套
	..s labValue=tmpstr
	.s:sign="" sign="<="
	.// 插入检验项
	.s dicIDStr=..SaveRuleDic(labItm,labItm,"linkLabItm")		// 将指标值范围为空时,存指标范围
	.i +dicIDStr<=0 s err=0,msg=..GetErrMsg("linkLabItm",dicIDStr)
	.s:+dicIDStr<=0 existFlag=1
	.q:existFlag=1
	.s tmpObj=..GetCommonObj("linkLabItm",dicIDStr)
	.s:(+tmpObj<=0)||(tmpObj={}) err=0,msg=..GetErrMsg("linkLabItm",tmpObj),existFlag=1	
	.q:existFlag=1
	.d atomArr.%Push(tmpObj)
	.k tmpObj
	.// 插入检验指标范围值
	.s tmpStr=..GetCommonValueUnit(labValue,sign)
	
	.s:(tmpStr<0)||(tmpStr=0) err=0,msg=..GetErrMsg(key,tmpStr),existFlag=1
	.q:existFlag=1
	.s tmpObj=..GetCommonObj(key,tmpStr)
	.s:(+tmpObj<=0)||(tmpObj={}) err=0,msg=..GetErrMsg(key,tmpObj)
	.q:(+tmpObj<=0)||(tmpObj={}) 
	.d atomArr.%Push(tmpObj)
	.k andObj
	.s andObj={}
	.d andObj.%Set("atom",atomArr)
	.d andArr.%Push(andObj)
	
	s len=andArr.%Size()
	q:len=0 0
	q:len=1 andArr.%Get(0) // 退出一个json
	q:len>1 andArr		   // 退出一个数组
}

/// 组织溶媒溶液串
/// 溶媒串，是否必用，溶媒体积，溶媒浓度,单次医嘱对应得溶媒量，单次医嘱对应得溶媒量key
/// w ##class(web.DHCCKBRuleImport).GetSolutObj("Y^isNeceSolMed","100ml^linkSolVolume","10ml/kg^linkSolDens","100ml^sinOrdVehVol","注射用青霉素钠","linkSolvent")
/// w ##class(web.DHCCKBRuleImport).GetSolutObj("Y^isNeceSolDrug","200ml^linkSolutionVolume","20mg/ml^linkSolutionDens","^sinOrdCor","注射用苯唑西林钠,注射用氟氯西林钠","linkSolution")
/// w ##class(web.DHCCKBRuleImport).GetSolutObj("Y^isNeceSolDrug","200ml^linkSolutionVolume","20mg/ml^linkSolutionDens","^sinOrdCor","注射用苯唑西林钠","linkSolution")
ClassMethod GetSolutObj(neceSolsStr, solvolumeStr, solConcentStr, sinOrdVeStr, value, key)
{
	n (neceSolsStr, solvolumeStr, solConcentStr, sinOrdVeStr, value, key)
	
	s solvolume = ..DealSymSign($p(solvolumeStr,"^",1))					 //溶媒/溶液体积
	s solConcent = ..DealSymSign($p(solConcentStr,"^",1))				//溶媒/溶液浓度
	s sinOrdVe = ..DealSymSign($p(sinOrdVeStr,"^",1))								//单次医嘱对应溶媒/溶液量
	s unitDataID=##class(web.DHCCKBCommon).GetUnitData()	// 单位字典默认存在（确保先有单位字典）

	q:+unitDataID=0 "-99"
	
	k tmpObj
	
	s signList=$lb(">=","<=",">","<","=","!=")	// 存在风险,符号的位置不能移动，<不能放到<=前面
	s retStr=0,errCode=0
	s andArr=[]
 	//组织溶媒
	 s existFlag=0,err=1
	s atomArr=[],orArr=[]
	i value'=""  d
	 .s dicIDStr=..SaveRuleDic(value,value,key)				
	.i +dicIDStr<=0 s err=0,msg=..GetErrMsg(key,dicIDStr)
	.s:+dicIDStr<=0 existFlag=1
	 .s tmpObj=..GetCommonObj(key,dicIDStr)
	.s:(+tmpObj<=0)||(tmpObj={}) err=0,msg=..GetErrMsg(key,tmpObj)
	.i $l(dicIDStr,"^")>1  d
	..d orArr.%Push(tmpObj)
	.e  d
	..d atomArr.%Push(tmpObj)
	.k tmpObj
	//是否必用溶媒药品
	s neceSol = $p(neceSolsStr,"^",1)
	s necekey = $p(neceSolsStr,"^",2)
	i neceSol'=""   d
	.s dicIDStr=..SaveRuleDic(neceSol,neceSol,necekey)		
	.i +dicIDStr<=0 s err=0,msg=..GetErrMsg(necekey,dicIDStr)		
	.s tmpObj=..GetCommonObj(necekey,dicIDStr)
	.s:(+tmpObj<=0)||(tmpObj={}) err=0,msg=..GetErrMsg(necekey,tmpObj)
	.d atomArr.%Push(tmpObj) 		
	.k tmpObj		
	//溶媒/溶液体积 solvolume, solConcent, str
	s solvolume = $p(solvolumeStr,"^",1)
	s solvolumekey = $p(solvolumeStr,"^",2)
	i solvolume'=""  d
	.s sign=..GetSigns(solvolume,signList)
	.s tmpStr=..GetCommonValueUnit(solvolume,sign)			
	.s:(tmpStr<0)||(tmpStr=0) err=0,msg=..GetErrMsg(solvolumekey,tmpStr),existFlag=1
	.s tmpObj=..GetCommonObj(solvolumekey,tmpStr)
	.s:(+tmpObj<=0)||(tmpObj={}) err=0,msg=..GetErrMsg(solvolumekey,tmpObj)
	.d atomArr.%Push(tmpObj)
	.k tmpObj
	//溶媒/溶液浓度
	s solConcent = $p(solConcentStr,"^",1)
	s solConcentkey = $p(solConcentStr,"^",2)
	i solConcent'=""  d
	.s sign=..GetSigns(solConcent,signList)
	.s tmpStr=..GetCommonValueUnit(solConcent,sign)			
	.s:(tmpStr<0)||(tmpStr=0) err=0,msg=..GetErrMsg(solConcentkey,tmpStr),existFlag=1
	.s tmpObj=..GetCommonObj(solConcentkey,tmpStr)
	.s:(+tmpObj<=0)||(tmpObj={}) err=0,msg=..GetErrMsg(solConcentkey,tmpObj)
	.d atomArr.%Push(tmpObj)
	.k tmpObj
	//单次医嘱对应溶媒/溶液量
	s sinOrdVe = $p(sinOrdVeStr,"^",1)
	s sinOrdVekey = $p(sinOrdVeStr,"^",2)
	i sinOrdVe'=""  d
	.s sign=..GetSigns(sinOrdVe,signList)
	.s tmpStr=..GetCommonValueUnit(sinOrdVe,sign)			
	.s:(tmpStr<0)||(tmpStr=0) err=0,msg=..GetErrMsg(sinOrdVekey,tmpStr)
	.s tmpObj=..GetCommonObj(sinOrdVekey,tmpStr)
	.d atomArr.%Push(tmpObj)
	.k tmpObj
	k andObj
	s andObj={}
	i atomArr.%Size()'=0 d andObj.%Set("atom",atomArr)
	i orArr.%Size()'=0  d andObj.%Set("or",orArr)
	d andArr.%Push(andObj)
	
	s len=andArr.%Size()
	q:len=0 0
	q:len=1 andArr.%Get(0) // 退出一个json
	q:len>1 andArr		   // 退出一个数组
}

/// w ##class("web.DHCCKBRuleImport").GetDoseObj("1g,,","3粒/日","3粒/日")
ClassMethod GetDoseObj(linkDose, onceDose, onceDoseMax, linkDoseMax, linkDoseLimit, onceDoseLimit)
{
	n (linkDose,onceDose,onceDoseMax,linkDoseMax,linkDoseLimit,onceDoseLimit)
	s atomArr = []
	s orArr = []
	s andArr = []
	s err = 1
	if (onceDose'="")
	{
		s str=..GetCommonValueUnit(onceDose,"<=")
		s:(str<0)||(str=0) err=0,msg=..GetErrMsg("onceDose",str)
		q:(str<0)||(str=0)
		s tmpKey="onceDose"
		s tmpObj=..GetCommonObj(tmpKey,str)
		s:(+tmpObj<=0)||(tmpObj={}) err=0,msg=..GetErrMsg("onceDose",tmpObj)
		q:(+tmpObj<=0)||(tmpObj={}) 
		i tmpObj.%Get("atom")="" d atomArr.%Push(tmpObj) 				
		e  d orArr.%Push(tmpObj)
	}
	Q:err=0 ""
	if (linkDose'=""){
		
			s str=##Class(ext.util.String).Replace(linkDose,",","!!")	// 中英文逗号分隔
			s str=##Class(ext.util.String).Replace(str,"，","!!")
			s doseStr=$p(str,"!!",1)		// 剂量	
			s freqStr=$p(str,"!!",2)		// 频次	
			s treatStr=$p(str,"!!",3)		//疗程内用药时长
			if (doseStr'="")&(doseStr'=0){				// 剂量
				s tmpStr=..GetCommonValueUnit(doseStr,"<=")		
				s:(tmpStr<0)||(tmpStr=0) err=0,msg=..GetErrMsg("linkDose",tmpStr)
				q:(tmpStr<0)||(tmpStr=0) 
				s tmpKey="dayDose"			//$select((doseStr["日")||(doseStr["天"):"dayDose",doseStr["次":"onceDose",1:"onceDose")
				s tmpObj=..GetCommonObj(tmpKey,tmpStr)
				s:(+tmpObj<=0)||(tmpObj={}) err=0,msg=..GetErrMsg(tmpKey,tmpObj)
				q:(+tmpObj<=0)||(tmpObj={}) 
				i tmpObj.%Get("atom")="" d atomArr.%Push(tmpObj) 				
				e  d orArr.%Push(tmpObj)
			
			}			
		
	}
	
	Q:err=0 ""
	if (onceDoseMax'="")
	{
		s str=..GetCommonValueUnit(linkDoseMax,"<=")
		s:(str<0)||(str=0) err=0,msg=..GetErrMsg("dayDoseMax",str)
		q:(str<0)||(str=0)
		s tmpKey="onceDoseMax"   //$select((linkDoseMax["日")||(linkDoseMax["天"):"dayDoseMax",linkDoseMax["次":"onceDoseMax",1:"onceDoseMax")
		s tmpObj=..GetCommonObj(tmpKey,str)
		s:(+tmpObj<=0)||(tmpObj={}) err=0,msg=..GetErrMsg("dayDoseMax",tmpObj)
		q:(+tmpObj<=0)||(tmpObj={}) 
		i tmpObj.%Get("atom")="" d atomArr.%Push(tmpObj) 				
		e  d orArr.%Push(tmpObj)
	}
	Q:err=0 ""
	if (linkDoseMax'="")
	{
		s str=..GetCommonValueUnit(linkDoseMax,"<=")
		s:(str<0)||(str=0) err=0,msg=..GetErrMsg("linkDoseMax",str)
		q:(str<0)||(str=0)
		s tmpKey="dayDoseMax"   //$select((linkDoseMax["日")||(linkDoseMax["天"):"dayDoseMax",linkDoseMax["次":"onceDoseMax",1:"onceDoseMax")
		s tmpObj=..GetCommonObj(tmpKey,str)
		s:(+tmpObj<=0)||(tmpObj={}) err=0,msg=..GetErrMsg("dayDoseMax",tmpObj)
		q:(+tmpObj<=0)||(tmpObj={}) 
		i tmpObj.%Get("atom")="" d atomArr.%Push(tmpObj) 				
		e  d orArr.%Push(tmpObj)
	}
	Q:err=0 ""
	
	if (onceDoseLimit'="")
	{
		s str=..GetCommonValueUnit(onceDoseLimit,"<=")
		s:(str<0)||(str=0) err=0,msg=..GetErrMsg("onceDoseLimit",str)
		q:(str<0)||(str=0)
		s tmpKey="onceDoseLimit"  //$select((linkDoseLimit["日")||(linkDoseLimit["天"):"dayDoseLimit",linkDoseLimit["次":"onceDoseLimit",1:"onceDoseLimit")
		s tmpObj=..GetCommonObj(tmpKey,str)
		s:(+tmpObj<=0)||(tmpObj={}) err=0,msg=..GetErrMsg("onceDoseLimit",tmpObj)
		q:(+tmpObj<=0)||(tmpObj={}) 	
		i tmpObj.%Get("atom")="" d atomArr.%Push(tmpObj) 				
		e  d orArr.%Push(tmpObj)
	}
	Q:err=0 ""
	if (linkDoseLimit'="")
	{
		s str=..GetCommonValueUnit(linkDoseLimit,"<=")
		s:(str<0)||(str=0) err=0,msg=..GetErrMsg("linkDoseLimit",str)
		q:(str<0)||(str=0)
		s tmpKey="dayDoseLimit"  //$select((linkDoseLimit["日")||(linkDoseLimit["天"):"dayDoseLimit",linkDoseLimit["次":"onceDoseLimit",1:"onceDoseLimit")
		s tmpObj=..GetCommonObj(tmpKey,str)
		s:(+tmpObj<=0)||(tmpObj={}) err=0,msg=..GetErrMsg("linkDoseLimit",tmpObj)
		q:(+tmpObj<=0)||(tmpObj={}) 	
		i tmpObj.%Get("atom")="" d atomArr.%Push(tmpObj) 				
		e  d orArr.%Push(tmpObj)
	}
	Q:err=0 ""
	s andObj={}
	d andObj.%Set("atom",atomArr)
	d andObj.%Set("or",orArr)
	d andArr.%Push(andObj)
	
	s len=andArr.%Size()
	q:len=0 0
	q:len=1 andArr.%Get(0) // 退出一个json
	q:len>1 andArr		   // 退出一个数组
}

/// Descript:处理特殊符号
ClassMethod DealSymSign(str)
{
			n (str)
			s str = ##Class(ext.util.String).Replace(str,"、", "&&")		// 中文顿号分割
			s str = ##Class(ext.util.String).Replace(str,"，", "&&")		// 中文逗号分割
			s str = ##Class(ext.util.String).Replace(str,"。","&&")			// 中文句号分割	（英文的点不能替换，可能是小数点）
			s str = ##class(web.DHCCKBCommonUtil).ReplaceSpaceStr(str,"_")	// 统一间隔符
			s str = ##class(web.DHCCKBCommonUtil).ReplaceSignStr(str)		// 统一比值符号
			s str = ##Class(ext.util.String).Replace(str,",", "&&")		 // 英文逗号分割
			s str = ##Class(ext.util.String).Replace(str," ", "")	
			Q str
}

ClassMethod GetSigns(input, signList)
{
			n (input,signList)
			s size=$LISTLENGTH(signList)		
			s ret=""
	  // 获取比值符号标记
			f k=1:1:size  q:ret'=""  d					// 有比值符号
			.s sign=$List(signList,k)
			.q:input'[sign
			.s ret=sign
			Q ($s(ret'="":ret,1:"="))
}

/// Description:	通过导入数据的列表，获取数据需要保存的字典位置(提取之前保存中的部分，为公共方法)
/// Creator:		QuNianpeng
/// CreateDate:		2020-04-03
/// Input:			列头描述
/// return:			>0字典id  0 获取失败
/// other:
ClassMethod GetDicTypeDataID(type)
{

	n (type)
	
	s typeDataID = 0
	// 需要有保存字典的字典代码(如保存药品,需要现有药品字典)
	
	i (type = "itmGeneName") s typeDataID = ##class(web.DHCCKBCommon).GetGeneralData()  // 西药通用名字典表   2020-04-23 修改指向
	e  i (type = "linkGeneName")||(type = "linkSolvent")||(type = "linkSolution") s typeDataID = ##class(web.DHCCKBCommon).GetGeneralFromData()   	// 带剂型通用名字典
	
	e  i (type = "itmProName")||(type = "linkProName") s typeDataID = ##class(web.DHCCKBCommon).GetDrugProNameData()	// 商品名字典
	
	e  i (type = "itmIngre")||(type = "linkIngre")||(type = "outLinkIngre") s typeDataID = ##class(web.DHCCKBCommon).GetIngreData()	// 成分字典表
	
	e  i type = "itmExcipient" s typeDataID = ##class(web.DHCCKBCommon).GetExcipientData()	// 辅料字典表
	
	e  i type = "itmForm" 	s typeDataID = ##class(web.DHCCKBCommon).GetFormData()			// 剂型字典表
	
	e  i type = "itmLibary" s typeDataID = ##class(web.DHCCKBCommon).GetDrugLibaryData()		// 药品规则目录
	
	e  i (type = "linkCat")||(type = "outLinkCat") s typeDataID = ##class(web.DHCCKBCommon).GetDrugCategoryData()	// 药学分类字典
	
	e  i type = "outDrugAllergy" s typeDataID = ##class(web.DHCCKBCommon).GetEnvironReasonData()	// 药品之外的过敏因素（环境因素）
	
	e  i (type = "linkLabItm")||(type = "linkLabValue") s typeDataID = ##class(web.DHCCKBCommon).GetLabItmData()	// 检验指标字典
	
	e  i (type = "linkVirus")||(type = "outLinkVirus") s typeDataID = ##class(web.DHCCKBCommon).GetBacteriaData()	// 细菌字典表
	
	e  i type = "linkVirusCat" s typeDataID = ##class(web.DHCCKBCommon).GetBacteriaCatData()	// 菌属字典表
	
	e  i (type = "linkDisease")||(type = "linkOtherDis")||(type = "outLinkDis")||(type = "outLinkOtherDis") s typeDataID = ##class(web.DHCCKBCommon).GetDiseaseData() // 病症字典表
	
	e  i (type = "linkSym")||(type = "outLinkSym") s typeDataID = ##class(web.DHCCKBCommon).GetSymptomData()		// 症状字典表
	
	e  i (type = "IcdCompare") s typeDataID = ##class(web.DHCCKBCommon).GetIcdAttrCodeId()	// ICD诊断字典
		
	e  i (type = "linkPeople") s typeDataID = ##class(web.DHCCKBCommon).GetSpecPopData()	// 特殊人群字典
	
	e  i (type = "unitData") s typeDataID = ##class(web.DHCCKBCommon).GetUnitData()			// 单位字典
	
	e  i (type = "linkSex")  s typeDataID = ##class(web.DHCCKBCommon).GetSexData()			// 性别字典
	
	e  i (type = "lilnkProfess")  s typeDataID = ##class(web.DHCCKBCommon).GetProfessData()	// 职业字典
	
	e  i (type = "linkPreMet")  s typeDataID =##class(web.DHCCKBCommon).GetDrugPreMetData()	// 给药途径
	
	e  i (type = "isFirst")  s typeDataID =##class(web.DHCCKBCommon).GetFirstUseData()		// 是否首次字典
	
	e  i (type = "freqData") s typeDataID=##class(web.DHCCKBCommon).GetDrugFreqData()	// 用药频率字典默认存在（确保先有用药频率字典）
	
	e  i (type = "linkLabItm") s typeDataID=##class(web.DHCCKBCommon).GetLabItmData()	// 检验指标字典默认存在（确保先有用药频率字典）
	
	e  i (type = "togetherType") s typeDataID=##class(web.DHCCKBCommon).GetTogetherData()	// 合用类别字典
	
	e  i (type = "linkOperTime") s typeDataID=##class(web.DHCCKBCommon).GetMedicalTimeData()	// 用药时机字典
	
	e  i (type = "outCHNLinkDis")||(type = "linkCHNDisease") s typeDataID = ##class(web.DHCCKBCommon).ChineseDiseaseData()	// 中医疾病字典 sufan  20200426 
	
	e  i (type = "linkGeneNoDos") s typeDataID = ##class(web.DHCCKBCommon).GetGeneralData()		// 通用名字典 sufan  20200426 
	
	e  i (type = "linkFormProp") s typeDataID = ##class(web.DHCCKBCommon).GetFormData()			// 剂型字典 sufan  20200426 
	
	e  i (type = "isNeceSolMed")||(type = "isNeceSolDrug")||(type = "isDiluteProp") s typeDataID = ##class(web.DHCCKBCommon).GetTipsData()			// 提醒字典 sufan  20200426 
	
	e  s typeDataID = 0
	
	
	q typeDataID
}

/// w ##class("web.DHCCKBRuleImport").GetDoseObj("1g,,","3粒/日","3粒/日")
ClassMethod GetDoseObjNew(linkDose, onceDose, onceDoseMax, linkDoseMax, linkDoseLimit, onceDoseLimit)
{
	n (linkDose,onceDose,onceDoseMax,linkDoseMax,linkDoseLimit,onceDoseLimit)
	s atomArr = []
	s atomObj = {}
	s err = 1
	/*单次剂量 */
	if (onceDose'=""){
		s str=..GetCommonValueUnit(onceDose,"<=")
		s:(str<0)||(str=0) err=0,msg=..GetErrMsg("onceDose",str)
		q:(str<0)||(str=0)
		s tmpKey="onceDose"
		s tmpObj=..GetCommonObj(tmpKey,str)
		s:(+tmpObj<=0)||(tmpObj={}) err=0,msg=..GetErrMsg("onceDose",tmpObj)
		q:(+tmpObj<=0)||(tmpObj={}) 
		s tmpArr = ..GetAloneObj(tmpObj)
		s atomArr = ##class(web.DHCCKBCommonUtil).Concat(atomArr,tmpArr)
	}
	Q:err=0 atomObj
	
	/* 单日剂量 */
	if (linkDose'=""){			
		s str=##Class(ext.util.String).Replace(linkDose,",","!!")	// 中英文逗号分隔
		s str=##Class(ext.util.String).Replace(str,"，","!!")
		s doseStr=$p(str,"!!",1)		// 剂量	
		s freqStr=$p(str,"!!",2)		// 频次	
		s treatStr=$p(str,"!!",3)		//疗程内用药时长
		if (doseStr'="")&(doseStr'=0){				// 剂量
			s tmpStr=..GetCommonValueUnit(doseStr,"<=")		
			s:(tmpStr<0)||(tmpStr=0) err=0,msg=..GetErrMsg("linkDose",tmpStr)
			q:(tmpStr<0)||(tmpStr=0) 
			s tmpKey="dayDose"			
			s tmpObj=..GetCommonObj(tmpKey,tmpStr)
			s:(+tmpObj<=0)||(tmpObj={}) err=0,msg=..GetErrMsg(tmpKey,tmpObj)
			q:(+tmpObj<=0)||(tmpObj={}) 
			s tmpArr = ..GetAloneObj(tmpObj)
			s atomArr = ##class(web.DHCCKBCommonUtil).Concat(atomArr,tmpArr)
		}		
	}	
	Q:err=0 atomObj
	
	/* 次最大量 */
	if (onceDoseMax'=""){
		s str=..GetCommonValueUnit(linkDoseMax,"<=")
		s:(str<0)||(str=0) err=0,msg=..GetErrMsg("dayDoseMax",str)
		q:(str<0)||(str=0)
		s tmpKey="onceDoseMax"   
		s tmpObj=..GetCommonObj(tmpKey,str)
		s:(+tmpObj<=0)||(tmpObj={}) err=0,msg=..GetErrMsg("dayDoseMax",tmpObj)
		q:(+tmpObj<=0)||(tmpObj={}) 
		s tmpArr = ..GetAloneObj(tmpObj)
		s atomArr = ##class(web.DHCCKBCommonUtil).Concat(atomArr,tmpArr)
	}
	Q:err=0 atomObj
	
	/* 日最大量 */
	if (linkDoseMax'=""){
		s str=..GetCommonValueUnit(linkDoseMax,"<=")
		s:(str<0)||(str=0) err=0,msg=..GetErrMsg("linkDoseMax",str)
		q:(str<0)||(str=0)
		s tmpKey="dayDoseMax"   
		s tmpObj=..GetCommonObj(tmpKey,str)
		s:(+tmpObj<=0)||(tmpObj={}) err=0,msg=..GetErrMsg("dayDoseMax",tmpObj)
		q:(+tmpObj<=0)||(tmpObj={}) 
		s tmpArr = ..GetAloneObj(tmpObj)
		s atomArr = ##class(web.DHCCKBCommonUtil).Concat(atomArr,tmpArr)
	}
	Q:err=0 atomArr
		
	/* 次极限量 */
	if (onceDoseLimit'="")	{
		s str=..GetCommonValueUnit(onceDoseLimit,"<=")
		s:(str<0)||(str=0) err=0,msg=..GetErrMsg("onceDoseLimit",str)
		q:(str<0)||(str=0)
		s tmpKey="onceDoseLimit" 
		s tmpObj=..GetCommonObj(tmpKey,str)
		s:(+tmpObj<=0)||(tmpObj={}) err=0,msg=..GetErrMsg("onceDoseLimit",tmpObj)
		q:(+tmpObj<=0)||(tmpObj={}) 	
		s tmpArr = ..GetAloneObj(tmpObj)
		s atomArr = ##class(web.DHCCKBCommonUtil).Concat(atomArr,tmpArr)
	}
	Q:err=0 atomObj
	
	/* 日极限量 */
	if (linkDoseLimit'=""){
		s str=..GetCommonValueUnit(linkDoseLimit,"<=")
		s:(str<0)||(str=0) err=0,msg=..GetErrMsg("linkDoseLimit",str)
		q:(str<0)||(str=0)
		s tmpKey="dayDoseLimit"  //$select((linkDoseLimit["日")||(linkDoseLimit["天"):"dayDoseLimit",linkDoseLimit["次":"onceDoseLimit",1:"onceDoseLimit")
		s tmpObj=..GetCommonObj(tmpKey,str)
		s:(+tmpObj<=0)||(tmpObj={}) err=0,msg=..GetErrMsg("linkDoseLimit",tmpObj)
		q:(+tmpObj<=0)||(tmpObj={}) 	
		s tmpArr = ..GetAloneObj(tmpObj)
		s atomArr = ##class(web.DHCCKBCommonUtil).Concat(atomArr,tmpArr)
	}
	Q:err=0 atomObj
	i atomArr.%Size()=1 q atomArr.%Get(0)				// 空
	i atomArr.%Size()>1 q atomObj.%Set("atom",atomArr)	//{"atom":[]}
	
	q atomObj
}

/// Description:	拆分提交规则中的json信息,返回json数组
/// Creator:		QuNianpeng
/// CreateDate:		2021-05-24
/// Input:			
/// return:			
/// other:			
ClassMethod GetAloneObj(obj) As %String
{
	n (obj)
	
	s arr = []
	i obj.%Get("atom")="" d 
	.d arr.%Push(obj) 	
	e  d
	.s tmpArr = obj.%Get("atom") // {"atom":[]}
	.f i=0:1:tmpArr.%Size()-1  d
	..s tmpObj = tmpArr.%Get(i)
	..d arr.%Push(tmpObj) 
	
	q arr
}

/// Description:	保存规则
/// Creator:		QuNianpeng 
/// CreateDate:		2021-06-05	
/// Input:			
/// return:			
/// other:			w ##class(##class(web.DHCCKBRuleImport).SaveRule()
ClassMethod SubmitRule(root, userId, dicStr, loginInfo) As %String
{
	n (root, userId, dicStr, loginInfo)	

	s opStatus = "add"
	s status = ""
	
	s ret=##class(web.DHCCKBRuleSave).save(0,status,root,userId,dicStr,loginInfo)
	
	i ret>0 d	
	.s status = "Release"
	.s opStatus = ""
	.s root = ##class(web.DHCCKBExportRuleManage).GetRuleObj(opStatus,ret)
	.s ret=##class(web.DHCCKBRuleSave).save(ret,status,root,userId,dicStr,loginInfo)
	q ret
	
	// ret<=0 失败 新生成的ruleId
}

/// Descript:组织药品信息
ClassMethod manDrugData(filepath, catArr, repArr)
{
	n (filepath,catArr,repArr)
	s count = 0
	
	q:filepath="" $$$OK
	s del = "^"
	o filepath:"RS":2
	u filepath
	s ret=0
	s end=0
	d $ZU(68,40,1)
	for  d  q:(end'=0)||(ret'=0)
	.R onerow
	.s end = $ZEOF
	.q:end'=0
	.q:onerow=""
	.b   //22
	.s count=count+1
	.Q:count=1
	.s listData = $tr(onerow,$c(9),del)
	.b
	.s list = $p(listData,"^",2)_"^"_$p(listData,"^",3)
	.s repIndex = $p(listData,"^",2)_$p(listData,"^",3)
	.Q:$p(listData,"^",3)=""
	.Q:$d(repArr(repIndex))
	.s repArr(repIndex) = list
	.s index = $p(listData,"^",3)
	.s icdList = $p(listData,"^",1)_"%"_$p(listData,"^",2)
	.i $d(catArr(index))  d
 	..s $p(catArr(index),"^",1) = $p(catArr(index),"^",1)_","_icdList
 	.e  d
 	..s catArr(index) = icdList_"^"_$p(listData,"^",3)
	c filepath
	q ""
}

/// Descript:导入通用名和适应症的规则
/// Creator:sufan
/// CreateDate:2022-04-24
/// Input:
/// w ##class(web.DHCCKBRuleImport).ImpIndicatRule("D:\temp\zlfasj.txt")
ClassMethod ImpIndicatRule(filepath)
{
	n (filepath)
	k catArr
	k repArr
	s loginInfo = ""
	d ..manDrugData(filepath,.catArr,.repArr)
	s h=0
	s baseObj={}
	s ruleObj={}		//规则
	s outPutObj={}		//输出
	s labGenObj={}
	s emRuleObj={}
	s tymParId = ##class(web.DHCCKBCommon).GetGeneralFromData()
	s index = ""
	for  s index = $o(catArr(index))  Q:index=""  d
	.s listData = catArr(index)
	.s disease = $p(listData,"^",1)
	.s tymc = $p(listData,"^",2)
	./*组织规则信息*/
	.d ruleObj.%Set("linkDisease",disease)
	.d ruleObj.%Set("linkSym","")
	.d ruleObj.%Set("linkPeople","")
	.d ruleObj.%Set("linkAge","")
	.d ruleObj.%Set("linkSex","")
	.d ruleObj.%Set("linkLabItm","")
	.d ruleObj.%Set("linkLabValue","")
	.d ruleObj.%Set("linkWeight","")
	.d ruleObj.%Set("linkDose","")
	.d ruleObj.%Set("linkDrugDose","")
	./*组织输出信息*/
	.s outMsg = "适宜的适应症是"_disease
	.d outPutObj.%Set("linkErrMsg",outMsg)
	.d outPutObj.%Set("OutMsgTips","Y")
	./*组织药品信息*/
	.s generId = ##class(web.DHCCKBCommon).GetDicIdByDesc(tymc,tymParId)
	.;Q:tymc'="注射用尿激酶"
	.s:generId=0 ^tempNotym(tymc) = tymc
	.Q:generId=0
	.s proexistFlag = ##class(web.DHCCKBRuleImport).IsProjectUse(generId)
	.Q:proexistFlag'=1
	.s ^tempTymRule(generId) = disease
	.s h = h+1
	.;s existFlag = ..IsExistRule(generId,disease)
	.;Q:existFlag=1
	.;s labelId = 73
	.;d labGenObj.%Set("generID",generId)
	.;d labGenObj.%Set("labelID",labelId)
	.;d emRuleObj.%Set("empRuletip","TipsAtOnceProp")
	.;s jsonstr = ##class(web.DHCCKBRuleImport).ImportNew(baseObj,ruleObj,outPutObj,1,0,1,labGenObj,"",loginInfo,emRuleObj)
	.;s jsonObj = ##class(%DynamicAbstractObject).%FromJSON(jsonstr)
	.;s h= h+1
	
	
	q h
}

/// Descript:导入的通用名是否规则
/// w ##class(web.DHCCKBRuleImport).IsExistRule(79716,"肺栓塞,脑梗死,脑梗死后遗症,多发性脑梗死,腔隙性脑梗死,大面积脑梗死,颈内动脉栓塞,颈内动脉供血不足,颈内动脉狭窄,后循环缺血,下肢开放性伤口,女性盆腔粘连,女性盆腔腹膜粘连,玻璃体混浊,肾病综合征,急性肺血栓栓塞症,过敏性紫癜,脑血管病,脑干梗死,肾动脉血栓形成")
ClassMethod IsExistRule(generId, disease)
{
	n (generId,disease)
	s exsit = 0
	s ruleDicId = ""
	for  s ruleDicId = $o(^CT.CKB.PDSS.RuleDicI("Dic",generId,ruleDicId)) Q:(ruleDicId="")||(exsit=1)  d
	.s ruleId = $lg($g(^CT.CKB.PDSS.RuleDicD(ruleDicId)),2)
	.s ruleDataId = ""
	.for  s ruleDataId = $o(^CT.CKB.PDSS.RuleDataI("Rule",ruleId,ruleDataId))  Q:(ruleDataId="")||(exsit=1)  d
	..s leftDic = $lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),4)
	..Q:leftDic=""
	..s leftDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(leftDic)),3)
	..Q:leftDesc'="西医疾病"
	..s rightDic = $lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),8)
	..Q:rightDic=""
	..s rightDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(rightDic)),3)
	..Q:disease'[rightDesc_","
	..s exsit = 1
	Q exsit
}

/// Descript:判断该通用名是否是某个项目的药品[统计泰安]
/// w ##class(web.DHCCKBRuleImport).IsProjectUse(79178)
ClassMethod IsProjectUse(generId, inhospCode = "TASZXYYGXYYQ")
{
	n (generId,inhospCode)
	s existFlag = 0
	s attrId = ""
	for  s attrId = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkAttr",generId,attrId))  Q:attrId=""  d
	.s dicId = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrId)),2)
	.s libCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicId)),2)
	.Q:libCode=""	
	.s hisCode = ""
	.for  s hisCode = $o(^CKB.PDSS.ComContrastI("LibCode",$$UPPER^SSUTIL4(libCode),hisCode))  Q:hisCode=""  d
	..s conId = ""
	..for  s conId = $o(^CKB.PDSS.ComContrastI("LibCode",$$UPPER^SSUTIL4(libCode),hisCode,conId))  Q:conId=""  d
	...s hospId = $lg(^CKB.PDSS.ComContrastD(conId),7)
	...Q:+hospId="0"
	...s hospCode = $p(^CT("HOSP",hospId),"^",1)
	...Q:(inhospCode'="")&&(hospCode'=inhospCode)
	...s existFlag = 1
	Q existFlag
}

/// Descript:导出未匹配的通用名
/// Creator:sufan
/// CreateDate:2022-05-05
/// w ##Class(websys.Query).ToExcel("未对照药品和适应症","web.DHCCKBRuleImport","QueryTymMatch")
/// d ##class(%ResultSet).RunQuery("web.DHCCKBRuleImport","QueryTymMatch") 
Query QueryTymMatch() As websys.Query(ROWSPEC = "tym:%String:通用名,icdCode:%String:icd代码,icdDesc:%String:适应症")
{
}

ClassMethod QueryTymMatchExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)

	Set repid=$I(^CacheTemp)	
	Set ind=1
	k icdArr
	s index = ""
	for  s index = $o(^tempTymRule(index))   Q:index=""  d
	.s data = ^tempTymRule(index)
	.s tymDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(index)),3)
	.d ..IsMatchIcd(tymDesc,data,.icdArr)
	
	k repArr
	s icd = ""
	for  s icd = $o(icdArr(icd))  Q:icd=""  d
	.s icdStr = icdArr(icd)
	.s tym = $p(icd,"^",1)
	.s icdCode = $p(icdStr,"^",1)
	.s icdDesc = $p(icdStr,"^",2)
	.Q:$d(repArr(icdDesc))
	.s repArr(icdDesc) = icdDesc
	.Q:$D(^CKB.PDSS.ComContrastI("LibDesc",$$UPPER^SSUTIL4(icdDesc)))
	.set ^CacheTemp(repid,ind)=$lb(tym,icdCode,icdDesc)
	.set ind=ind+1	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// w ##class(web.DHCCKBRuleImport).IsMatchIcd()
ClassMethod IsMatchIcd(tymDesc, data, icdArr)
{
	n (tymDesc, data, icdArr)
	s len = $l(data,",")
	for i=1:1:len  d
	.s icdStr = $p(data,",",i)
	.s icdCode = $p(icdStr,"%",1)
	.s icdDesc = $p(icdStr,"%",2)
	.s index = tymDesc_"^"_icdDesc
	.Q:$D(icdArr(index))
	.s icdArr(index) = icdCode_"^"_icdDesc
	Q ""
}

/// Descript:导入检验指标相关规则
/// w ##class(web.DHCCKBRuleImport).ImportLabDiagRule("D:\temp\特殊人群（等于+等于）20221118.txt")
ClassMethod ImportLabDiagRule(filepath)
{
	n (filepath)
	s specPopDataId = ##class(web.DHCCKBCommon).GetSpecPopData()
	s icdDiagDataId = ##class(web.DHCCKBCommon).GetDicIdByCode("ICDDiagData")
	s diseaseDataId = ##class(web.DHCCKBCommon).GetDiseaseData()
	s addRuleFlagId = ##class(web.DHCCKBCommon).GetDicIdByCode("AddRuleFlag")
	s count = 0
	k tmpArr
	d ##class(web.DHCCKBIcdImport).readTetFile(filepath,.tmpArr)
	s index = ""
	for  s index = $o(tmpArr(index))  Q:index=""  d
	.s deaseDesc = $p(tmpArr(index),"!!",1)
	.;b  //s1
	.s deaseDesc = $replace(deaseDesc,"（","(")
	.s deaseDesc = $replace(deaseDesc,"）",")")  
	.s equalIcdList = $p(tmpArr(index),"!!",2)
	.s notEqualIcdList = $p(tmpArr(index),"!!",3)
	.s twoEqualIcdList = $p(tmpArr(index),"!!",4)
	.s dataList = "",equalSym = ""
	.s deaseId = ""
	.s:deaseDesc'="" deaseId = ##class(web.DHCCKBCommon).GetDicIdByDesc(deaseDesc,specPopDataId)
	.;s:spegroup'="" spegroupId = ##class(web.DHCCKBCommon).GetDicIdByDesc(spegroup,specPopDataId)
	.Q:(equalIcdList="")&&(notEqualIcdList="")
	.s count = count+1
	.Q:(deaseId="")&&(spegroupId="")
	.s id = deaseId
	.s allArr = []
	.i notEqualIcdList'="" d
	..s atomArr = []
	..;处理不等于
	..s notEqualIcdList = ..GetChildIcd(notEqualIcdList)
	..s noEquLen = $l(notEqualIcdList,"&&")
	..for n=1:1:noEquLen  d
	...s equalSym="NotEquals"
	...s leftObj = {}
	...s valueObj = {}
	...s reticdData = $p(notEqualIcdList,"&&",n)
	...Q:$p(reticdData,"^",2)=""
	...d leftObj.%Set("_varCategory","西医疾病")
	...d leftObj.%Set("_ruleData","0")
	...d leftObj.%Set("_varCategoryId","6")
	...d leftObj.%Set("_var","26983")
	...d leftObj.%Set("_varLabel","ICD诊断")
	...d leftObj.%Set("_datatype","String")
	...d leftObj.%Set("_type","variable")
	...d valueObj.%Set("_ruleData","0")
	...d valueObj.%Set("_const-category",$p(reticdData,"^",1))
	...d valueObj.%Set("_const",$p(reticdData,"^",1))
	...d valueObj.%Set("_const-label",$p(reticdData,"^",2))
	...d valueObj.%Set("_extconst","")
	...d valueObj.%Set("_extconstvar","")
	...d valueObj.%Set("_type","Constant")
	...s valObj = {}
	...d valObj.%Set("left",leftObj)
	...d valObj.%Set("value",valueObj)
	...d valObj.%Set("_op",equalSym)
	...d atomArr.%Push(valObj)
	..s atomObj = {}
	..d atomObj.%Set("atom",atomArr)
	..d allArr.%Push(atomObj)
	.i equalIcdList'=""  d
	..s equalIcdList = ..GetChildIcd(equalIcdList)
	..s equLen = $l(equalIcdList,"&&")
	..s atomArr = []
	..for k=1:1:equLen  d
	...s leftObj = {}
	...s valueObj = {}
	...s reticdData = $p(equalIcdList,"&&",k)
	...Q:$p(reticdData,"^",2)=""
	...d leftObj.%Set("_varCategory","西医疾病")
	...d leftObj.%Set("_ruleData","0")
	...d leftObj.%Set("_varCategoryId","6")
	...d leftObj.%Set("_var","26983")
	...d leftObj.%Set("_varLabel","ICD诊断")
	...d leftObj.%Set("_datatype","String")
	...d leftObj.%Set("_type","variable")
	...d valueObj.%Set("_ruleData","0")
	...d valueObj.%Set("_const-category",$p(reticdData,"^",1))
	...d valueObj.%Set("_const",$p(reticdData,"^",1))
	...d valueObj.%Set("_const-label",$p(reticdData,"^",2))
	...d valueObj.%Set("_extconst","")
	...d valueObj.%Set("_extconstvar","")
	...d valueObj.%Set("_type","Constant")
	...s valObj = {}
	...d valObj.%Set("left",leftObj)
	...d valObj.%Set("value",valueObj)
	...d valObj.%Set("_op","Equals")
	...d atomArr.%Push(valObj)
	..s atomObj = {}
	..d atomObj.%Set("atom",atomArr)
	..s orObj = {}
	..d orObj.%Set("or",atomObj) 
	..d allArr.%Push(orObj)
	.;处理等于信息
	.i twoEqualIcdList'=""  d
	..s atomArr = []
	..s twoEqualIcdList = ..GetChildIcd(twoEqualIcdList)
	..s twoEqLen = $l(twoEqualIcdList,"&&")
	..for l=1:1:twoEqLen  d
	...s leftObj = {}
	...s valueObj = {}
	...s reticdData = $p(twoEqualIcdList,"&&",l)
	...Q:$p(reticdData,"^",2)=""
	...d leftObj.%Set("_varCategory","西医疾病")
	...d leftObj.%Set("_ruleData","0")
	...d leftObj.%Set("_varCategoryId","6")
	...d leftObj.%Set("_var","26983")
	...d leftObj.%Set("_varLabel","ICD诊断")
	...d leftObj.%Set("_datatype","String")
	...d leftObj.%Set("_type","variable")
	...d valueObj.%Set("_ruleData","0")
	...d valueObj.%Set("_const-category",$p(reticdData,"^",1))
	...d valueObj.%Set("_const",$p(reticdData,"^",1))
	...d valueObj.%Set("_const-label",$p(reticdData,"^",2))
	...d valueObj.%Set("_extconst","")
	...d valueObj.%Set("_extconstvar","")
	...d valueObj.%Set("_type","Constant")
	...s valObj = {}
	...d valObj.%Set("left",leftObj)
	...d valObj.%Set("value",valueObj)
	...d valObj.%Set("_op","Equals")
	...d atomArr.%Push(valObj)
	..s atomObj = {}
	..d atomObj.%Set("atom",atomArr)
	..s orObj = {}
	..d orObj.%Set("or",atomObj) 
	..d allArr.%Push(orObj)
	.;处理其他信息
	.s subifObj = {}
	.d subifObj.%Set("and",allArr)
	.s ifObj = {}
	.d ifObj.%Set("and",subifObj)
	.s ruleObj = {}
	.d ruleObj.%Set("remark","")
	.d ruleObj.%Set("if",ifObj)
	.d ruleObj.%Set("then","")
	.d ruleObj.%Set("else","")
	.d ruleObj.%Set("_name","rule")
	.s obj = {}
	.d obj.%Set("rule",ruleObj)
	.b  //22
	.s ret = ##class(web.DHCCKBRuleSave).save("0","",obj.%ToJSON(),"11870",id,"11870^8^1^289^2")

	Q ret
}

/// Descript:获取所有的下级诊断
/// w ##class(web.DHCCKBRuleImport).GetChildIcd("【 B15.0 】 甲型肝炎，伴有肝昏迷")
ClassMethod GetChildIcd(icdList)
{
	n (icdList)
	s retList = ""
	s count = 0
	s icdList = $replace(icdList," ","")
	s icdLen = $l(icdList,"【")
	for i=1:1:icdLen   d
	.s icdStr = $p(icdList,"【",i)
	.Q:icdStr=""
	.s icdCode = $p(icdStr,"】",1)
	.s icdDesc = $p(icdStr,"】",2)
	.Q:icdDesc=""
	.Q:icdCode=""
	.s icdId = ##class(web.DHCCKBIcdImport).GetIdListByDesc(icdCode,icdDesc,"26938")
	.i icdId="" d
	..s parref = 205985
	..&sql(insert into CT_CKB_PDSS.CommonDiction (CD_Code,CD_Desc,CD_Parref_Dr) values (:icdCode,:icdDesc,:parref))
	..s icdId = %ROWID
	.s count = count+1
	.Q:icdId=""
	.s icdstr = icdId_"^"_icdDesc
	.i retList = "" s retList = icdstr
	.e  s retList = retList_"&"_icdstr
	
	s queIcdLsit = ""
	s strLen = $l(retList,"&")
	for j=1:1:strLen  d
	.s datastr = $p(retList,"&",j)
	.s queStr = ..GetLastNode(datastr)
	.i queIcdLsit="" s queIcdLsit = queStr
	.e  s queIcdLsit = queIcdLsit_"&&"_queStr
	Q queIcdLsit
}

/// w ##class(web.DHCCKBRuleImport).GetLastNode("206760^甲型肝炎，伴有肝昏迷")
ClassMethod GetLastNode(tmpStr)
{
	n (tmpStr)
	
	s retList = ""
	s deasclsId = $p(tmpStr,"^",1)
	s icdDec =  $p(tmpStr,"^",2)
	s dictionId = 26938
	i '$d(^CT.CKB.PDSS.CommonDictionI("Parref",deasclsId))  d
	.i retList = "" s retList = tmpStr
	.e  s retList = retList_"&&"_tmpStr
	e  d
	.s id = ""
	.for  s id = $o(^CT.CKB.PDSS.CommonDictionI("Parref",deasclsId,id))	Q:id=""  d
	..s dicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(id)),2)
	..s dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(id)),3)
	..s inList = id_"^"_dicDesc
	..s ret = ..GetLastNode(inList)
	..i retList = "" s retList = ret
	..e  s retList = retList_"&&"_ret
	Q retList
}

}
