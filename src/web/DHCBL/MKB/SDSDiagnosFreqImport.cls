Class web.DHCBL.MKB.SDSDiagnosFreqImport Extends %RegisteredObject
{

/// Creator：高姗姗
/// CreatDate: 2020-01-11
/// Description：初始化导入属性信息到频次表  session中用户设置为demo id，科室设置为demo默认登录科室id
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnosFreqImport).ImportProToFreq() 
ClassMethod ImportProToFreq() As %String
{
	k ^TMPPROTOFREQ("count")
	s base=##class(web.DHCBL.MKB.MKBTermBase).GetIdByFlag("Diagnose")
	s TermId=""
	for {
		s TermId=$o(^User.MKBTermI("BaseIndex",base,TermId)) q:TermId=""
		//s TermId="14870"
		s ^TMPPROTOFREQ("count",TermId)=1
		s TempStr=##class(web.DHCBL.MKB.MKBTermProDetail).GetDiaTemplate(TermId) //诊断模板
		if (TempStr'=""){
			s DKBBCRowId=$p(TempStr,"^",1) //属性模板id
			s emptyInfo=$p(TempStr,"^",2)
			s modeJsonInfo=$e($p(TempStr,"^",3),2,*-1)
			if (emptyInfo'=""){
				s splitStr = "},{"
				for i=1:1:$l(modeJsonInfo,splitStr){
					s itemJsonStr = $p(modeJsonInfo,splitStr,i)
					if $e(itemJsonStr,1)'="{" s itemJsonStr="{"_itemJsonStr
					if $e(itemJsonStr,$l(itemJsonStr))'="}" s itemJsonStr=itemJsonStr_"}"
					s objMode= ##class(ext.util.JsonObject).FromJSON(itemJsonStr)
	       			s childId=objMode.GetValue("catRowId")
	       			s childDesc=objMode.GetValue("catDesc")
	       			s childType=objMode.GetValue("catType")
	       			s showType=objMode.GetValue("showType")
	       			s catFlag=objMode.GetValue("catFlag")
	       			s treeNode=objMode.GetValue("treeNode")
	       			s choiceType=objMode.GetValue("choiceType")
	       			s ifRequired=objMode.GetValue("ifRequired")
	       			s isTOrP=objMode.GetValue("isTOrP")
	       			s trids=DKBBCRowId_"_"_childId_"_"_showType_"_"_childType_"_"_treeNode_"_"_isTOrP
	       			if (childType="L"){
						if (isTOrP="P"){
							//var ListRetStr = tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetListDetailInfo", "", childId, "0", "1000");
							d ..GetListDetailInfo("",childId,0,1000,DKBBCRowId,trids)
						}else{ //术语标识
							//var ListRetStr = tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetListTermJsonForDoc", "", childId, "", "1000", "1");
							d ..GetListTermJsonForDoc("",childId,"","1000","1",DKBBCRowId,trids)
						}
					}
					if (childType="T"){
						if (isTOrP="P"){
							//var TreeRetUrl="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetTreeDetailJson&id="+treeNode+"&property="+childId
							d ..GetTreeDetailJson(treeNode,childId,DKBBCRowId,trids)
						}else{ //术语标识
							//var TreeRetUrl="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetTreeTermJsonForDoc&id="+treeNode+"&base="+childId
							d ..GetTreeTermJsonForDoc(treeNode,childId,DKBBCRowId,trids)
						}
					}
					if ((childType="TX")||(childType="TA")||(childType="R")||(childType="CB")||(childType="C")){
						//var TXRetStr = tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetTextInfo",childId); 
					}
					if (childType="S"){
						if ((showType="C")||(showType="CB")||(showType="CG")||(showType="G")) { //引用术语 展示为下拉框
							//var ListRetStr = tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetDocSourseList", childId, showType, ""); 
							d ..GetDocSourseList(childId,showType,"",DKBBCRowId,trids)
						}
						elseif (showType="T"){
							//var TreeRetUrl="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetDocSourseTreeJson&LastLevel=&property="+childId
							d ..GetDocSourseTreeJson("",childId,DKBBCRowId,trids)
						}
						else{
							//var SRetStr = tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetDocSourseDetailInfo",childId); 
						}
					}
					if (childType="P"){
						//var ListRetStr = tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetDocPropertyList",childId, ""); 
						d ..GetDocPropertyList(childId, "",DKBBCRowId,trids)
					}
					if (childType="SS"){
						//var TreeRetUrl="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetSSProDetailJsonForDoc&property="+childId
						d ..GetSSProDetailJsonForDoc(childId,DKBBCRowId,trids)
					}
				}
			}
		}
	}
	q 1
}

/// Creator:高姗姗
/// CreatDate:2020-01-14
/// Description:频次导入前增加重复校验，重复则不再导入
/// w ##class(web.DHCBL.MKB.SDSDiagnosFreqImport).SaveFreq("BDPDAFTableName^BDPDAFDataReference^BDPDAFDesc^BDPDAFFrequency^BDPDAFType")
ClassMethod SaveFreq(SaveDataStr) As %String
{
	
	s BDPDAFTableName=$P(SaveDataStr,"^",1)  //表名
	s BDPDAFDataReference= $P(SaveDataStr,"^",2)  //rowid
	s BDPDAFDesc=$P(SaveDataStr,"^",3)   //中心词
	
	s DKBBCRowId=$p(BDPDAFTableName,"User.SDSStructDiagnosProDetail",2)
	s TermId=$LISTGET($G(^User.MKBTermPropertyD(DKBBCRowId)),6)
	q:($g(^TMPPROTOFREQ("count",TermId))>20) "" //仅导入前20条属性到频次
	
	if ('$d(^User.BDPDataFrequencyI("TableReferenceIdx",BDPDAFTableName,BDPDAFDataReference))){
		d ##class(web.DHCBL.BDP.BDPDataFrequency).SaveData(BDPDAFTableName_"^"_BDPDAFDataReference_"^"_BDPDAFDesc) //频次导入
	}

	s ^TMPPROTOFREQ("count",TermId)=^TMPPROTOFREQ("count",TermId)+1
	q ""
}

/// Creator:谷雪萍
/// CreatDate:2018-04-11
/// Description：提供列表型属性数据获取接口,展示格式是下拉框、单选框、多选框。
/// Input：desc, cat, start, limit
/// Return:id:中心词:备注：顺序：展示名：别名：拼音码
/// Other:w ##class(web.DHCBL.MKB.MKBTermProDetail).GetListDetailInfo("","1",0,10)
ClassMethod GetListDetailInfo(desc As %String, property As %String, start As %String, limit As %String, DKBBCRowId, trids) As %String
{
	s result="",total=0,jsonstr=""
	q:property="" "{data:[], success:false, total:0}"   //如果子术语库大类未选中
	s:desc'="" desc=$ZCONVERT(desc,"U")
	s start=start+1  ////start=0  从1条开始 不加会导致第一页显示的记录比设置的“每页显示记录数”少一条

	s MKBTPDRowId=0
	for  
	{	
		s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProIdx",property,MKBTPDRowId)) q:MKBTPDRowId="" 

		s MKBTPDDesc=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),3) //描述
		s MKBTPDDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTPDDesc)
		s MKBTPDDescU=$ZCONVERT(MKBTPDDesc,"U")
		s MKBTPDRemark=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),7) //说明
		s MKBTPDRemark= ##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPDRemark)
		s MKBTPDSequence=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),9)  //顺序


		//s ExtendStr=..GetDocTreeExtendInfo(TKBTDRowId,property)  //别名^拼音码^常用名
		s comDesc=##class(web.DHCBL.MKB.MKBTermProDetail).GetExtendVal(MKBTPDRowId,property,"展示名")  //展示名
		s:comDesc="" comDesc=MKBTPDDesc   //展示名为空则展示中心词
		s AlisaDesc=##class(web.DHCBL.MKB.MKBTermProDetail).GetExtendVal(MKBTPDRowId,property,"别名")   //别名
		//s PYDesc=..GetExtendVal(MKBTPDRowId,property,"检索码")   //检索码
		s PYDesc=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),10)  //检索码
		s PYDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(PYDesc)
		s PINYIN=""
		if (desc'="")
		{ 
			if (PYDesc'="")
			{
				s PINYIN=PYDesc
			}
			else
			{ 
				s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBTPDDescU)
			}
		}
		
		d ..SaveFreq("User.SDSStructDiagnosProDetail"_DKBBCRowId_"^"_trids_"#"_MKBTPDRowId_"^"_comDesc) //频次导入
		
		i ((MKBTPDDescU[desc)||(PINYIN[desc))   //条件
		{
			s total=total+1
			if (total<start) continue
			if ((total<(start+limit)))
			{
				s mainstr="{""MKBTPDRowId"":"""_MKBTPDRowId_""",""MKBTPDDesc"":"""_MKBTPDDesc_""",""MKBTPDRemark"":"""_MKBTPDRemark_""",""MKBTPDSequence"":"""_MKBTPDSequence_""",""comDesc"":"""_comDesc_""",""AlisaDesc"":"""_AlisaDesc_""",""PYDesc"":"""_PYDesc_"""}"
				if (jsonstr'="")
				{ 
					s jsonstr=jsonstr_","_mainstr
				}
				else
				{
					s jsonstr=mainstr
				}
			}
		}
		
	}
	s result="{data:["_jsonstr_"], success:true, total:"_total_"}"
	q result
}

/// Creator:谷雪萍
/// CreatDate:2018-11-27
/// Description:给医生站提供接口——如果诊断模板里选的是术语（列表型）则展示格式是下拉框（下拉框数据描述-拼音码）、单选框、多选框、多选下拉框
/// Table：User.MKBTerm
/// Input：rowid-诊断术语ID,base-术语库注册父表的ID,desc-根据描述、常用名及拼音码查询，rows-每页显示行数 page-第几页
/// return:Json数据
/// w ##class(web.DHCBL.MKB.MKBTermProDetail).GetListTermJsonForDoc(rowid,base, desc, rows, page)
/// w ##class(web.DHCBL.MKB.MKBTermProDetail).GetListTermJsonForDoc("",5,"fj",8,1)
ClassMethod GetListTermJsonForDoc(rowid As %String, base As %String, desc As %String, rows As %String, page As %String, DKBBCRowId, trids) As %String
{
	
	s result="",total=0,jsonstr=""	
	
	if (base="")
	{
		//w "{""rows"":[], ""total"":0}"    //术语库注册id为空
		q "{data:[], success:false, total:0}"  
	}
	
	//w "{""rows"":["
	if (rowid'="") //根据rowid返回该条记录
	{
		s total=1
		s MKBTRowId=rowid
		s MKBTCode=$listGet($g(^User.MKBTermD(MKBTRowId)),2)  
		s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTRowId)),3)  //描述
		s MKBTDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTDesc) 			
		s MKBTPYCode=$listGet($g(^User.MKBTermD(MKBTRowId)),6)  //检索码
		s MKBTPYCode= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTPYCode) 
		/*s MKBTNote=$listGet($g(^User.MKBTermD(MKBTRowId)),7)  
		s MKBTNote= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTNote)
		s MKBTNote = ##class(web.BDP.util.String).Replace(MKBTNote,"<br/>","")*/
		s mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_"""}"	
		//w mainstr
		s jsonstr=mainstr
	}
	else
	{
		s endpage=page*rows  //结束行
		s stpage=((page-1)*rows)+1 //开始行

		s:desc'="" desc=$ZCONVERT(desc,"U")
		if ($d(^User.MKBTermI("BaseIndex",base)))  //该术语库下有数据
		{
			s MKBTRowId=""
			for  
			{	
				s MKBTRowId=$o(^User.MKBTermI("BaseIndex",base,MKBTRowId),-1) q:MKBTRowId="" 
				
				//封闭的数据不显示
				s MKBTActiveFlag=$listGet($g(^User.MKBTermD(MKBTRowId)),9)
				continue:MKBTActiveFlag="N"  //判断是否显示封闭数据

				s MKBTCode=$listGet($g(^User.MKBTermD(MKBTRowId)),2)  //代码
				s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTRowId)),3)  //描述
				s MKBTDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTDesc) 
				s MKBTPYCode=$listGet($g(^User.MKBTermD(MKBTRowId)),6)  //检索码
				s MKBTPYCode= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTPYCode) 
				/*s MKBTNote=$listGet($g(^User.MKBTermD(MKBTRowId)),7)  
				s MKBTNote= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTNote)
				s MKBTNote = ##class(web.BDP.util.String).Replace(MKBTNote,"<br/>","")*/
				
				d ..SaveFreq("User.SDSStructDiagnosProDetail"_DKBBCRowId_"^"_trids_"#"_MKBTRowId_"^"_MKBTDesc) //频次导入
					
				i (($ZCONVERT(MKBTDesc,"U")[desc)||($ZCONVERT(MKBTPYCode,"U")[desc))   //条件
				{
					s total=total+1
					if (total<stpage) continue
					if (total<=endpage)
					{	
						s mainstr="{""MKBTRowId"":"""_MKBTRowId_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTPYCode"":"""_MKBTPYCode_"""}"					
						if (jsonstr'="")
						{ 
							//w ","
							s jsonstr=jsonstr_","_mainstr
						}
						else
						{
							s jsonstr=mainstr
						}
						//w mainstr
					}
				}
					
			}			
					
		}
	}

	//w "], ""total"":"_total_"}"	
	//q ""
	s result="{data:["_jsonstr_"], success:true, total:"_total_"}"	
	q result
}

/// Creator:谷雪萍
/// CreatDate:2018-04-12
/// Description：给医生站提供获取树形术语库的接口——不输出定义的初始节点
/// Input:id ：上级节点id，如果模板中定义了起始节点treeNode，则取值为treeNode的值，否则起始节点为空；property:属性id
/// return:所有子节点 Json格式
/// w ##class(web.DHCBL.MKB.MKBTermProDetail).GetTreeDetailJson("","2")
ClassMethod GetTreeDetailJson(id As %String, property As %String, DKBBCRowId, trids) As %String
{
	s parentcatdr=id
	if (parentcatdr="") s parentcatdr=-100000000000000
	
	s childStr=""
	s count=0
	w "["
	s mySeq=""
	for {
		s mySeq=$o(^User.MKBTermProDetailI("ProParSeqIndex",property,parentcatdr,mySeq)) q:(mySeq="")
		s myRowID=0
		for {
			s myRowID=$o(^User.MKBTermProDetailI("ProParSeqIndex",property,parentcatdr,mySeq,myRowID)) q:(myRowID="")
			s count=count+1
			s Caption=$LISTGET($G(^User.MKBTermProDetailD(myRowID)),3)
			s Caption= ##class(web.DHCBL.BDP.FunLib).EvalJSON(Caption)
			if count>1 w ","
			s MKBTPDRemark=$LISTGET($G(^User.MKBTermProDetailD(myRowID)),7)
			s comDesc=##class(web.DHCBL.MKB.MKBTermProDetail).GetExtendVal(myRowID,property,"展示名")  //展示名
			s:comDesc="" comDesc=Caption   //展示名为空则展示中心词
			s AlisaDesc=##class(web.DHCBL.MKB.MKBTermProDetail).GetExtendVal(myRowID,property,"别名")   //别名
			s PYDesc=$LISTGET($G(^User.MKBTermProDetailD(myRowID)),10)  //检索码
			s PYDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(PYDesc)

			s spanDesc=AlisaDesc_"^"_PYDesc_"^"_Caption_"^"_MKBTPDRemark  //别名^拼音码^中心词^备注 
			s spanDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(spanDesc)
			
			d ..SaveFreq("User.SDSStructDiagnosProDetail"_DKBBCRowId_"^"_trids_"#"_myRowID_"^"_comDesc) //频次导入
		
			w "{""id"":"""_""_myRowID_""",""text"":"""_comDesc_"<span class='hidecls'>"_spanDesc_"</span>"""

			if $d(^User.MKBTermProDetailI("ProParIndex",property,myRowID))
			{
				//一次性加载   
				w ",""state"":""open"""   //closed节点不展开,open节点展开
				w ",""children"":"
				w ..GetTreeDetailJson(myRowID,property,DKBBCRowId, trids)
			}
			else
			{
				w ",""state"":""open"""
			}
			w "}"
			
		}
	}
	w "]"
	q ""
}

/// Creator:谷雪萍
/// CreatDate:2018-11-27
/// Description：给医生站提供获取树形术语库的接口
/// Input:id ：上级节点id，如果模板中定义了起始节点treeNode，则取值为treeNode的值，否则起始节点为空。base:术语库注册id——取自诊断模板接口里的catRowId
/// return:所有子节点 Json格式
/// w ##class(web.DHCBL.MKB.MKBTermProDetail).GetTreeTermJsonForDoc("16412","6")
ClassMethod GetTreeTermJsonForDoc(id As %String, base As %String, DKBBCRowId, trids) As %String
{
	s parentcatdr=id
	if (parentcatdr="") s parentcatdr=-100000000000000
	
	//输出树形JSON串
	s count=0
	s childStr=""
	w "["
	s mySeq=""
	s n=0
	for {
		s mySeq=$o(^User.MKBTermI("ParSeqIndex",base,parentcatdr,mySeq)) q:(mySeq="")
		s myRowID=0
		for {
			s myRowID=$o(^User.MKBTermI("ParSeqIndex",base,parentcatdr,mySeq,myRowID)) q:(myRowID="")
			s count=count+1
			
			//封闭的数据不显示
			s MKBTActiveFlag=$listGet($g(^User.MKBTermD(myRowID)),9)
			continue:MKBTActiveFlag="N"  //判断是否显示封闭数据
							
			s Caption=$LISTGET($G(^User.MKBTermD(myRowID)),3)   ///中心词
			s Caption=$tr(Caption,"""","")
			s Caption= ##class(web.DHCBL.BDP.FunLib).EvalJSON(Caption)
			s MKBTPYCode=$listGet($g(^User.MKBTermD(myRowID)),6)  //检索码
			s MKBTPYCode=##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTPYCode)
			s MKBTPYCodeU=$ZCONVERT(MKBTPYCode,"U")
			s MKBTNote=$LISTGET($G(^User.MKBTermD(myRowID)),7)   ///备注
			s MKBTNote = ##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTNote)
			s strComAndAlisa=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(myRowID)  //常用名别名及拼音码
			s strCom=$p(strComAndAlisa,"[A]",1)   //常用名及拼音码
			s strAlias=$p(strComAndAlisa,"[A]",2) //别名及拼音码
			s comDesc=$p(strCom,"&%",1) //常用名
			s comKey=$p(strCom,"&%",2)	//常用名拼音码
			if (comDesc'="")&(comKey'="")   //把常用名和拼音码也放在别名里
			{
				s:strAlias'="" strAlias=comDesc_$c(2)_comKey_$c(1)_strAlias
				s:strAlias="" strAlias=comDesc_$c(2)_comKey
			}
			s:comDesc="" comDesc=Caption   //展示名为空则展示中心词

			s spanDesc=strAlias_"^"_MKBTPYCodeU_"^"_Caption_"^"_MKBTNote  //别名^拼音码^中心词^备注 
			s spanDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(spanDesc)
			
			d ..SaveFreq("User.SDSStructDiagnosProDetail"_DKBBCRowId_"^"_trids_"#"_myRowID_"^"_comDesc) //频次导入
			
			if count>1 w ","
			w "{""id"":"""_""_myRowID_""",""text"":"""_comDesc_"<span class='hidecls'>"_spanDesc_"</span>"""

			s childStr=##class(web.DHCBL.MKB.MKBTerm).GetTreeChildOrderedIDStr(base,myRowID)
			if childStr'=""
			{
				//一次性加载   
				w ",""state"":""open"""   //closed节点不展开,open节点展开
				w ",""children"":"
				w ..GetTreeTermJsonForDoc(myRowID,base,DKBBCRowId, trids)
			}
			else
			{
				w ",""state"":""open"""
			}
			w "}"
			
		}
	}
	w "]"
	q ""
}

/// Creator:谷雪萍
/// CreatDate:2018-04-13
/// Description：给医生站提供的接口 如果引用的术语是列表型的则展示格式是下拉框（下拉框数据描述-拼音码）、单选框、多选框、多选下拉框
/// Input：property-属性ID,showType-展示类型,desc-检索条件
/// Return:Json 格式
/// Other:w ##class(web.DHCBL.MKB.MKBTermProDetail).GetDocSourseList("26320","C","")
ClassMethod GetDocSourseList(property As %String, showType As %String, desc As %String, DKBBCRowId, trids) As %String
{
	s result="",total=0,jsonstr=""
	q:property="" "{data:[], success:false, total:0}"   //如果子术语库大类未选中
	
	s:desc'="" desc=$ZCONVERT(desc,"U")

    s MKBTPDRowId=0
	for  
	{	
		s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProIdx",property,MKBTPDRowId)) q:MKBTPDRowId=""   //遍历该属性下的内容
		
		s MKBTRowId=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)  //属性内容表描述字段MKBTPDDesc存的值——术语id
		continue:MKBTRowId=""
		//封闭的数据不显示
		s MKBTActiveFlag=$listGet($g(^User.MKBTermD(MKBTRowId)),9)
		continue:MKBTActiveFlag="N"  //判断是否显示封闭数据
		s MKBTCode=$listGet($g(^User.MKBTermD(MKBTRowId)),2)  //已选术语代码
        s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTRowId)),3)  //已选术语描述
        s MKBTPYCode=$listGet($g(^User.MKBTermD(MKBTRowId)),6)  //已选术语拼音码

		/*if (showType="C"){
		  s MKBTDesc=MKBTDesc_"-"_MKBTPYCode
		}*/
		
		d ..SaveFreq("User.SDSStructDiagnosProDetail"_DKBBCRowId_"^"_trids_"#"_MKBTPDRowId_"^"_MKBTDesc) //频次导入
		
		i (($ZCONVERT(MKBTDesc,"U")[desc)||($ZCONVERT(MKBTPYCode,"U")[desc))   //条件
		{
			s total=total+1
			s mainstr= "{""MKBTRowId"":"""_MKBTRowId_""",""MKBTDesc"":"""_MKBTDesc_""",""PYDesc"":"""_MKBTPYCode_"""}"
			if (jsonstr'="")
			{	   
			  s jsonstr=jsonstr_","_mainstr
			}
			else
			{
			  s jsonstr=mainstr
			}		  	
		}
	}
		
	s result="{data:["_jsonstr_"], success:true, total:"_total_"}"
	q result
}

/// Creator:陈代雷
/// CreatDate:2019-11-25
/// Description：给医生站提供获取引用树形术语的接口 获取选中节点信息—— Json格式
/// Input:LastLevel ：上级节点id property:属性id
/// return:父节点及其所有子节点 Json格式
/// Other:w ##class(web.DHCBL.MKB.MKBTermProDetail).GetDocSourseTreeJson("","8819567")
ClassMethod GetDocSourseTreeJson(LastLevel As %String, property As %String, DKBBCRowId, trids) As %String
{
	
	q:(property="") "[]"
	
	s DATSOU=$LISTGET($G(^User.MKBTermPropertyD(property)),5)  //配置项
	q:(DATSOU="") "[]"
	
	s selItemIds= ##class(web.DHCBL.MKB.MKBTermProDetail).GetSelTermIdsStr(property)
	s selItemIds=","_selItemIds_","
	s definedNode=$LISTGET($G(^User.MKBTermPropertyD(property)),10)  //起始节点
	
	if (definedNode="")  //如果起始节点为空，显示所有术语数据
	{
		w "["
		w ($replace(..NewGetDocSourseJsonDataForCmb(DATSOU,definedNode,selItemIds,DKBBCRowId,trids),"}{","},{"))_"]"
	} 
	else  //如果定义了起始节点，显示该节点及以下的节点
	{
			//封闭的数据不显示
		s MKBTActiveFlag=$listGet($g(^User.MKBTermD(definedNode)),9)
		q:(MKBTActiveFlag="N") "[]" //判断是否显示封闭数据	
			
		s strId=","_definedNode_","
		if (selItemIds[strId){
				
			s definedNodeDesc=$listGet($g(^User.MKBTermD(definedNode)),3)  //已选术语描述
			s definedNodeDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(definedNodeDesc)
			s MKBTNote=$LISTGET($G(^User.MKBTermD(definedNode)),7)  //备注
			s comDesc=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComByTermId(definedNode)
			s MKBTPYCode=$LISTGET($G(^User.MKBTermD(definedNode)),6)   //检索码

			s spanDesc=comDesc_"^"_MKBTPYCode_"^"_definedNodeDesc_"^"_MKBTNote  //常用名^拼音码^中心词^备注 
			s spanDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(spanDesc)
			
			
			d ..SaveFreq("User.SDSStructDiagnosProDetail"_DKBBCRowId_"^"_trids_"#"_definedNode_"^"_definedNodeDesc) //频次导入
		
			w "["
			w "{""id"":"""_definedNode_""",""text"":"""_definedNodeDesc_"<span class='hidecls'>"_spanDesc_"</span>"""
			w ",""state"":""open"""

			if $d(^User.MKBTermI("ParentIndex",DATSOU,definedNode))  //如果有子节点
			{
				w ",""children"":["
				w ($replace(..NewGetDocSourseJsonDataForCmb(DATSOU,definedNode,selItemIds,DKBBCRowId,trids),"}{","},{"))_"]"
			}
			w "}"
			w "]"
		}
		else{
			q "[]"
		}
		
	}
	
	q ""
}

/// Creator：陈代雷
/// CreatDate:2019-11-25
/// Description：：获取引用-树形术语-tree的数据，如果属性中定义了初始节点，则内容区域显示该节点及以下的节点，如果没有定义起始节点，显示全部
/// Table：User.MKBTerm
/// Input：base-术语库注册id，   id-父节点id， selItemIds-要选中的节点
/// Return：treegrid格式数据串
/// w ##class(web.DHCBL.MKB.MKBTermProDetail).NewGetDocSourseJsonDataForCmb("6","",",16449,16393,16385,129357,16388,525737,16389,")
ClassMethod NewGetDocSourseJsonDataForCmb(base As %String, id As %String, selItemIds As %String, DKBBCRowId, trids) As %String
{
	s parentcatdr=id
	if (parentcatdr="") s parentcatdr=-100000000000000
	//输出树形JSON串
	s count=0
	s str=""
	s childStr=""
	s mySeq=""
	s n=0
	for {
		s mySeq=$o(^User.MKBTermI("ParSeqIndex",base,parentcatdr,mySeq)) q:(mySeq="")
		s myRowID=0
		for {
			s myRowID=$o(^User.MKBTermI("ParSeqIndex",base,parentcatdr,mySeq,myRowID)) q:(myRowID="")
			s strId=","_myRowID_","
			if '(selItemIds[strId)
			{	//w myRowID_" "
				s str=str_..NewGetDocSourseJsonDataForCmb(base,myRowID,selItemIds,DKBBCRowId,trids)
			}
			else
			{
				//封闭的数据不显示
				s MKBTActiveFlag=$listGet($g(^User.MKBTermD(myRowID)),9)
				continue:MKBTActiveFlag="N"  //判断是否显示封闭数据
				s count=count+1
				s Caption=$LISTGET($G(^User.MKBTermD(myRowID)),3)
				s Caption= ##class(web.DHCBL.BDP.FunLib).EvalJSON(Caption)
				s MKBTNote=$LISTGET($G(^User.MKBTermD(myRowID)),7)  //备注
				s comDesc=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComByTermId(myRowID)  ////常用名
				s MKBTPYCode=$LISTGET($G(^User.MKBTermD(myRowID)),6)   //检索码
				s spanDesc=comDesc_"^"_MKBTPYCode_"^"_Caption_"^"_MKBTNote  //常用名^拼音码^中心词^备注 
				s spanDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(spanDesc)
				//s Caption=$tr(Caption,"""","")
				
				d ..SaveFreq("User.SDSStructDiagnosProDetail"_DKBBCRowId_"^"_trids_"#"_myRowID_"^"_Caption) //频次导入
				
				if count>1 s str=str_","
				s str=str_"{""id"":"""_myRowID_""",""text"":"""_Caption_"<span class='hidecls'>"_spanDesc_"</span>"""
				s str=str_",""state"":""open"""
				s childStr=##class(web.DHCBL.MKB.MKBTermProDetail).GetDocChildOrderedIDStr(base,myRowID,selItemIds)
				if childStr'=""
				{	
					s str=str_",""children"":["
					s str=str_..NewGetDocSourseJsonDataForCmb(base,myRowID,selItemIds,DKBBCRowId,trids)_"]"	
				}
		
				s str=str_"}"
				if childStr=""
				{
					s str=str_..NewGetDocSourseJsonDataForCmb(base,myRowID,selItemIds,DKBBCRowId,trids)
				}
			}
		}
	}
	q str
}

/// Creator:谷雪萍
/// CreatDate:2018-04-13
/// Description：给医生站提供接口——如果是引用属性类型的属性则只能是下拉框（下拉框数据描述-拼音码）、单选框、多选框、多选下拉框
/// Input：property-属性ID,desc-检索条件
/// Return:Json 格式  catRowId:T/P-术语id/属性id-定义节点id 
/// Other:w ##class(web.DHCBL.MKB.MKBTermProDetail).GetDocPropertyList("4","")
ClassMethod GetDocPropertyList(property As %String, desc As %String, DKBBCRowId, trids) As %String
{
	s result="",total=0,jsonstr=""
	q:property="" "{data:[], success:false, total:0}"   //如果子术语库大类未选中
	
	s:desc'="" desc=$ZCONVERT(desc,"U")
		
	s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProIdx",property,0))  //术语明细表id
	if (MKBTPDRowId'="")
	{
	 	s MKBTPDDesc=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)  //术语明细表desc (存已选术语id串)
	    s argsLen=$Length(MKBTPDDesc,",")
	    for i=1:1:argsLen   
	    {
	        s argstr=$p(MKBTPDDesc,",",i)  //术语属性id&展示类型&起始节点
	        s catRowId=$p(argstr,"&",1)  //术语属性id
	        s showType=$p(argstr,"&",2) //展示类型
	        s treeNode=$p(argstr,"&",3) //定义起始节点
	        s:treeNode="undefined" treeNode=""
	        s choiceType=$p(argstr,"&",4)  //单选多选
	        s ifRequired=$p(argstr,"&",5)  //是否必填（Y/N）
	      	s isTOrP=$p(argstr,"&",6)  //术语T或属性P
	        
	      	s TOrPDesc="",TreeNodeDesc=""
			
	      	if (isTOrP="T") //术语
	      	{
		      	if (treeNode'="")   //节点描述取展示名、没有展示名再取描述 谷雪萍 2018-03-01
		      	{
			      	//s TreeNodeDesc=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComByTermId(treeNode)
			      	s TreeNodeDesc=$listGet($g(^User.MKBTermD(treeNode)),3)  //节点描述-术语中心词	
		      	}
		      	
		      	s catDesc=$LISTGET($G(^User.MKBTermBaseD(catRowId)),3)  //术语库描述

	      	}
	      	else    //属性
	      	{
		      	if (treeNode'="")   //节点描述取展示名、没有展示名再取描述 谷雪萍 2018-03-01
		      	{
			      	/*s TreeNodeDesc=..GetExtendVal(treeNode,catRowId,"展示名")  //获取展示名
					s:TreeNodeDesc="" TreeNodeDesc=$LISTGET($G(^User.MKBTermProDetailD(treeNode)),3) //节点描述*/
					s TreeNodeDesc=$LISTGET($G(^User.MKBTermProDetailD(treeNode)),3)  //节点描述-属性内容中心词	
		      	}

				s catDesc=$LISTGET($G(^User.MKBTermPropertyD(catRowId)),3)  //术语属性描述
	      	}
		   
			s isTOrPDesc=""		
			if (isTOrP="T"){
				s isTOrPDesc="术语"
			}
			else{
				s isTOrPDesc="属性"
			}
			
			s catDesc=isTOrPDesc_"-"_catDesc
			s:TreeNodeDesc'="" catDesc=catDesc_"-"_TreeNodeDesc

			s catRowId=isTOrP_"-"_catRowId
			s:treeNode'="" catRowId=catRowId_"-"_treeNode

			s ucatDesc=$ZCONVERT(catDesc,"U")
			s PINYIN=""   
			s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(ucatDesc) 
			
			d ..SaveFreq("User.SDSStructDiagnosProDetail"_DKBBCRowId_"^"_trids_"#"_catRowId_"^"_catDesc) //频次导入
			
			i ((ucatDesc[desc)||(PINYIN[desc))   //条件
			{
			  s total=total+1
			  s mainstr= "{""catRowId"":"""_catRowId_""",""catDesc"":"""_catDesc_"""}"
			  if (jsonstr'="")
			  {	   
			  	  s jsonstr=jsonstr_","_mainstr
			  }
			  else
			  {
				  s jsonstr=mainstr
			  }		  	
			}
	    }
	}
	s result="{data:["_jsonstr_"], success:true, total:"_total_"}"
	q result
}

/// Creator:谷雪萍
/// CreatDate:2018-12-24
/// Description：给医生站提供获取引用起始节点的属性内容的接口
/// Input:property-属性id
/// return:返回引用的起始节点的子节点
/// w ##class(web.DHCBL.MKB.MKBTermProDetail).GetSSProDetailJsonForDoc(property)
ClassMethod GetSSProDetailJsonForDoc(property As %String, DKBBCRowId, trids) As %String
{
	q:(property="") "[]"
	
	s DATSOU=$LISTGET($G(^User.MKBTermPropertyD(property)),5)  //配置项
	q:(DATSOU="") "[]"

	s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProIdx",property,0))  //属性内容id

	s definedNode=""
	s:MKBTPDRowId'="" definedNode=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)  //属性内容中心词

	d ..GetTreeTermJsonForDoc(definedNode,DATSOU,DKBBCRowId,trids)
	
	q ""
}

}
