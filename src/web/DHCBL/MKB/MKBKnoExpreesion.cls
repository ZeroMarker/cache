Class web.DHCBL.MKB.MKBKnoExpreesion Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：李欣
/// CreatDate: 2018-05-16
/// Description：查询列表子术语库内容
/// Table：User.MKBTerm
/// Input：rowid,desc,base
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBKnoExpreesion","GetListTerm","","5","")
Query GetListTerm(rowid, base, desc) As %Query(ROWSPEC = "MKBTRowId,MKBTDesc,MKBTSequence")
{
}

ClassMethod GetListTermExecute(ByRef qHandle As %Binary, rowid, base, desc) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	  
	if (base'="") //如果子术语库大类未选中
	{
		if (rowid'="") //根据rowid返回该条记录
		{
			s MKBTRowId=rowid
			s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTRowId)),3)  //描述
			s MKBTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTDesc)
			s MKBTSequence=$listGet($g(^User.MKBTermD(MKBTRowId)),8)  //顺序
			d OutputRowListTerm
		}
		else
		{
			s:desc'="" desc=$ZCONVERT(desc,"U")
			if ($d(^User.MKBTermI("BaseIndex",base)))  //该术语库下有数据
			{
				s MKBTRowId=""
				for  
				{	
					s MKBTRowId=$o(^User.MKBTermI("BaseIndex",base,MKBTRowId),-1) q:MKBTRowId="" 
					s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTRowId)),3)  //描述
					s MKBTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTDesc)
					s MKBTDescU=$ZCONVERT(MKBTDesc,"U")
					s MKBTPYCode=$listGet($g(^User.MKBTermD(MKBTRowId)),6)  //检索码
					s MKBTPYCodeU=$ZCONVERT(MKBTPYCode,"U")
					s MKBTSequence=$listGet($g(^User.MKBTermD(MKBTRowId)),8)
					
					s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBTDescU)
					s strAlias=..GetComOrAlias(MKBTRowId)  
					s aliasDesc=$p(strAlias,"||",1)  //常用名、别名
					s aliasKey=$p(strAlias,"||",2)  //常用名、别名检索码
					s aliasDescU=$ZCONVERT(aliasDesc,"U")
					s aliasKeyU=$ZCONVERT(aliasKey,"U")
					
					i ((MKBTDescU[desc)||(MKBTPYCodeU[desc)||(PINYIN[desc)||(aliasDescU[desc)||(aliasKeyU[desc))  //条件
					{
						d OutputRowListTerm
					}		
					
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowListTerm
    set Data=$lb(MKBTRowId,MKBTDesc,MKBTSequence)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListTermClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListTermExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetListTermFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListTermExecute ]
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

/// Description：获取常用名/别名列表(AL)及拼音码
/// Table：User.MKBTermProperty
/// Input：termdr
/// Return:常用名/别名列表(AL)||拼音码
/// Date:2018-05-16
/// creator：李欣
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
		s MKBTPDDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPDDesc)
		
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
			s MKBTEPVValue=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTEPVValue)	
			s:keyStr'="" keyStr=keyStr_","_MKBTEPVValue
			s:keyStr="" keyStr=MKBTEPVValue	
		}

		s:str'="" str=str_","_MKBTPDDesc
		s:str="" str=MKBTPDDesc	
		
	}
 	q str_"||"_keyStr
}

/// Creator:丁亚楠
/// CreatDate:2018-05-02
/// Description：树形术语库部分
/// Input：上级节点，术语库注册表的ID
/// Return:成功返回术语类型
/// Other:w ##class(web.DHCBL.MKB.MKBKnoExpreesion)GetTreeTerm(31,"")
ClassMethod GetTreeTerm(base As %String, LastLevel As %String) As %String
{
	s IDStr=""
	s parentcatdr=LastLevel
	if (parentcatdr="") s parentcatdr=-100000000000000
	
	s myJsonStr=""
	s myRowID=0
	
	s mySeq=0
	k myArray
	k a
	//生成索引数组
	s mySeq=0
	s n=0
	for {
		s mySeq=$o(^User.MKBTermI("ParSeqIndex",base,parentcatdr,mySeq)) q:(mySeq="")
		s n=n+1
		s a(n)= mySeq
	}
	set left=1,right=n
	d:$d(a) ##class(web.DHCBL.BDP.FunLib).QuickSort(.a,left,right) //排序

	s n=0
	s mySeq=0
	s myCount=0
	for {
		s n=$o(a(n)) q:(n="")
		s mySeq=$g(a(n))
		s myRowID=0
		for {
			s myRowID=$o(^User.MKBTermI("ParSeqIndex",base,parentcatdr,mySeq,myRowID)) 
			q:(myRowID="")
			s myCount=myCount+1
			s myArray(myCount)=myRowID
		}
	}
	//输出菜单JSON串
	s myRowID=0
	s mySeq=0
	s childStr=""
	w "["
	s count=0
	for {
		s mySeq=$o(myArray(mySeq)) q:(mySeq="")
		s myRowID=$g(myArray(mySeq))
		s count=count+1
		s Caption=$LISTGET($G(^User.MKBTermD(myRowID)),3)   ///中心词
		s Caption=$tr(Caption,"""","")
		s MKBTLastLevel=$LISTGET($G(^User.MKBTermD(myRowID)),5)   ///上级分类
		s MKBTSequence=$LISTGET($G(^User.MKBTermD(myRowID)),8)   ///顺序
		if count>1 w ","
		w "{""id"":"""_myRowID_""""
		w ",""MKBTRowId"":"""_myRowID_""",""Caption"":"""_Caption_""",""MKBTLastLevel"":"""_MKBTLastLevel_""",""MKBTSequence"":"""_MKBTSequence_""""
		s childStr=..GetTreeChildOrderedIDStr(base,myRowID)
		if childStr'=""
		{
			w ",""state"":""open"""
			w ",""children"":"
			w ..GetTreeTerm(base,myRowID)	
		}
		else
		{
			w ",""state"":""open"""
		}
		w "}"
		
	}
	w "]"
	q ""
}

/// Creator:李欣
/// CreatDate:2018-04-13
/// Description：提供获取引用树形术语的接口 获取选中节点信息—— Json格式
/// Input:LastLevel ：上级节点id property:属性id
/// return:父节点及其所有子节点 Json格式
/// Other:w ##class(web.DHCBL.MKB.MKBKnoExpreesion).GetDocSourseTreeJson("","68030")
ClassMethod GetDocSourseTreeJson(LastLevel As %String, property As %String) As %String
{
	
	q:(property="") "[]"
	
	s DATSOU=$LISTGET($G(^User.MKBTermPropertyD(property)),5)  //配置项
	q:(DATSOU="") "[]"
	
	s selItemIds= ##class(web.DHCBL.MKB.MKBTermProDetail).GetSelTermIdsStr(property)
	s selItemIds=","_selItemIds_","
	s definedNode=$LISTGET($G(^User.MKBTermPropertyD(property)),10)  //起始节点
	
	if (definedNode="")  //如果起始节点为空，显示所有术语数据
	{
		w ..GetDocSourseJsonDataForCmb(DATSOU,definedNode,selItemIds)
	} 
	else  //如果定义了起始节点，显示该节点及以下的节点
	{		
		s strId=","_definedNode_","
		if (selItemIds[strId){
				
			s definedNodeDesc=$listGet($g(^User.MKBTermD(definedNode)),3)  //已选术语描述
			s definedNodeDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSONB(definedNodeDesc)
			s MKBTNote=$LISTGET($G(^User.MKBTermD(definedNode)),7)  //备注
			s strComAndAlisa=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(definedNode)
			s strCom=$p(strComAndAlisa,"[A]",1)
			s comDesc=$p(strCom,"&%",1) //常用名
			s MKBTPYCode=$LISTGET($G(^User.MKBTermD(definedNode)),6)   //检索码

			s spanDesc=comDesc_"^"_MKBTPYCode_"^"_definedNodeDesc_"^"_MKBTNote  //常用名^拼音码^中心词^备注 
			s spanDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSONB(spanDesc)
		
			w "["
			w "{""id"":"""_"S"_definedNode_""",""text"":"""_definedNodeDesc_"<span style'hidden:true'>"_spanDesc_"</span>"""
			w ",""state"":""open"""

			if $d(^User.MKBTermI("ParentIndex",DATSOU,definedNode))  //如果有子节点
			{
				w ",""children"":"
				w ..GetDocSourseJsonDataForCmb(DATSOU,definedNode,selItemIds)
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

/// Creator：丁亚男
/// CreatDate: 2018-05-2
/// Description：获取某个父节点下的所有子节点 用^连接，并按照顺序排列  
/// Table：User.MKBTerm
/// Input：父节点
/// Return：所有子节点 用^连接
/// w ##class(web.DHCBL.MKB.MKBTerm).GetChildOrderedIDStr("")
ClassMethod GetTreeChildOrderedIDStr(base As %String, LastLevel As %String) As %String
{
	s IDStr=""
	if (LastLevel="") s LastLevel=-100000000000000
	
	s myJsonStr=""
	s myRowID=0
	
	s mySeq=0
	k myArray
	k a
	//生成菜单索引数组
	s mySeq=0
	s n=0
	for {
		s mySeq=$o(^User.MKBTermI("ParSeqIndex",base,LastLevel,mySeq)) q:(mySeq="")
		s n=n+1
		s a(n)= mySeq
	}
	set left=1,right=n
	d:$d(a) ##class(web.DHCBL.BDP.FunLib).QuickSort(.a,left,right) //排序

	s n=0
	s mySeq=0
	s myCount=0
	for {
		s n=$o(a(n)) q:(n="")
		s mySeq=$g(a(n))
		s myRowID=0
		for {
			s myRowID=$o(^User.MKBTermI("ParSeqIndex",base,LastLevel,mySeq,myRowID)) q:(myRowID="")
			s myCount=myCount+1
			s myArray(myCount)=myRowID
		}
	}
	//输出菜单JSON串
	s myRowID=0
	s mySeq=0
	s childStr=""
	for {
		s mySeq=$o(myArray(mySeq)) q:(mySeq="")
		s myRowID=$g(myArray(mySeq))
		
		s childStr=..GetTreeChildOrderedIDStr(base,myRowID)
		if childStr'="" s childStr=myRowID_"^"_childStr
		if childStr="" s childStr=myRowID
		
		if IDStr="" s IDStr=childStr
		else  s IDStr=IDStr_"^"_childStr
	}
	q IDStr
}

/// Creator：谷雪萍
/// CreatDate:2018-05-09
/// Description：：获取引用-树形术语-tree的数据，如果属性中定义了初始节点，则内容区域显示该节点及以下的节点，如果没有定义起始节点，显示全部
/// Table：User.MKBTerm
/// Input：base-术语库注册id，   id-父节点id， selItemIds-要选中的节点
/// Return：treegrid格式数据串
/// w ##class(web.DHCBL.MKB.MKBTerm).GetDocSourseJsonDataForCmb("31","")
ClassMethod GetDocSourseJsonDataForCmb(base As %String, id As %String, selItemIds As %String) As %String
{
	
	s IDStr=""
	s parentcatdr=id
	if (parentcatdr="") s parentcatdr=-100000000000000
	
	s myJsonStr=""
	s myRowID=0
	
	s mySeq=0
	k myArray
	k a
	//生成索引数组
	s mySeq=0
	s n=0
	for {
		s mySeq=$o(^User.MKBTermI("ParSeqIndex",base,parentcatdr,mySeq)) q:(mySeq="")
		s n=n+1
		s a(n)= mySeq
	}
	set left=1,right=n
	d:$d(a) ##class(web.DHCBL.BDP.FunLib).QuickSort(.a,left,right) //排序

	s n=0
	s mySeq=0
	s myCount=0
	for {
		s n=$o(a(n)) q:(n="")
		s mySeq=$g(a(n))
		s myRowID=0
		for {
			s myRowID=$o(^User.MKBTermI("ParSeqIndex",base,parentcatdr,mySeq,myRowID)) q:(myRowID="")
			s myCount=myCount+1
			s myArray(myCount)=myRowID
		}
	}
	//输出菜单JSON串
	s myRowID=0
	s mySeq=0
	s childStr=""
	w "["
	s count=0
	for {
		s mySeq=$o(myArray(mySeq)) q:(mySeq="")
		s myRowID=$g(myArray(mySeq))
		s strId=","_myRowID_","
		if '(selItemIds[strId){
			continue
		}
		s count=count+1
		s Caption=$LISTGET($G(^User.MKBTermD(myRowID)),3)
		s Caption= ##class(web.DHCBL.BDP.FunLib).EvalJSONB(Caption)
		s MKBTNote=$LISTGET($G(^User.MKBTermD(myRowID)),7)  //备注
		s strComAndAlisa=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(myRowID)
		s strCom=$p(strComAndAlisa,"[A]",1)
		s comDesc=$p(strCom,"&%",1) //常用名
		s MKBTPYCode=$LISTGET($G(^User.MKBTermD(myRowID)),6)   //检索码

		s spanDesc=comDesc_"^"_MKBTPYCode_"^"_Caption_"^"_MKBTNote  //常用名^拼音码^中心词^备注 
		s spanDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSONB(spanDesc)
		//s Caption=$tr(Caption,"""","")
		if count>1 w ","
		w "{""id"":"""_"S"_myRowID_""",""text"":"""_Caption_"<span class='hidecls'>"_spanDesc_"</span>"""
		s childStr=..GetDocChildOrderedIDStr(base,myRowID,selItemIds)
		if childStr'=""
		{
			w ",""state"":""open"""
			w ",""children"":"
			w ..GetDocSourseJsonDataForCmb(base,myRowID,selItemIds)	
		}
		else
		{
			w ",""state"":""open"""
		}
		w "}"
		
	}
	w "]"
	q ""
}

/// Creator：谷雪萍
/// CreatDate:2018-05-09
/// Description：获取某个父节点下的所有子节点 用^连接，并按照顺序排列  
/// Table：User.MKBTerm
/// Input：base-术语库注册id，   id-父节点id， selItemIds-要选中的节点
/// Return：所有子节点 用^连接
/// w ##class(web.DHCBL.MKB.MKBTerm).GetDocChildOrderedIDStr("")
ClassMethod GetDocChildOrderedIDStr(base As %String, LastLevel As %String, selItemIds As %String) As %String
{
	s IDStr=""
	if (LastLevel="") s LastLevel=-100000000000000
	
	s myJsonStr=""
	s myRowID=0
	
	s mySeq=0
	k myArray
	k a
	//生成菜单索引数组
	s mySeq=0
	s n=0
	for {
		s mySeq=$o(^User.MKBTermI("ParSeqIndex",base,LastLevel,mySeq)) q:(mySeq="")
		s n=n+1
		s a(n)= mySeq
	}
	set left=1,right=n
	d:$d(a) ##class(web.DHCBL.BDP.FunLib).QuickSort(.a,left,right) //排序

	s n=0
	s mySeq=0
	s myCount=0
	for {
		s n=$o(a(n)) q:(n="")
		s mySeq=$g(a(n))
		s myRowID=0
		for {
			s myRowID=$o(^User.MKBTermI("ParSeqIndex",base,LastLevel,mySeq,myRowID)) q:(myRowID="")
			s myCount=myCount+1
			s myArray(myCount)=myRowID
		}
	}
	//输出菜单JSON串
	s myRowID=0
	s mySeq=0
	s childStr=""
	for {
		s mySeq=$o(myArray(mySeq)) q:(mySeq="")
		s myRowID=$g(myArray(mySeq))
		s strId=","_myRowID_","
		if '(selItemIds[strId){
			continue
		}		
		s childStr=..GetDocChildOrderedIDStr(base,myRowID,selItemIds)
		if childStr'="" s childStr=myRowID_"^"_childStr
		if childStr="" s childStr=myRowID
		
		if IDStr="" s IDStr=childStr
		else  s IDStr=IDStr_"^"_childStr
	}
	q IDStr
}

}
