Class web.DHCBL.MKB.MKBKnoExpression Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：李欣
/// CreatDate: 2018-05-16
/// Description：根据知识id得到类型（树形，列表形）
/// Table：User.MKBTermBase
/// Input：base
/// Other: w ##class(web.DHCBL.MKB.MKBKnoExpression).GetBaseType("5")
ClassMethod GetBaseType(base)
{
	q:base="" ""
	s type=$LG($G(^User.MKBTermBaseD(base)),4)
	q type
}

/// Creator：李欣
/// CreatDate: 2018-05-16
/// Description：查询列表子术语库内容
/// Table：User.MKBTerm
/// Input：rowid,desc,base
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBKnoExpression","GetListTerm","","5","")
Query GetListTerm(rowid, base, q) As %Query(ROWSPEC = "MKBTRowId,MKBTDesc,MKBTSequence")
{
}

ClassMethod GetListTermExecute(ByRef qHandle As %Binary, rowid, base, q) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s desc=q 
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
					
					;s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBTDescU)
					s PINYIN=""
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
/// Other:w ##class(web.DHCBL.MKB.MKBKnoExpression).GetComOrAlias(14626)
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
/// Other:w ##class(web.DHCBL.MKB.MKBKnoExpression).GetTreeTerm(31,"")
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
		s PINYINDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE(Caption)
		s PINYINDesc=$ZCONVERT(PINYINDesc,"L")    
		if count>1 w ","
		w "{""id"":"""_myRowID_""",""text"":"""_Caption_""",""pydesc"":"""_PINYINDesc_""""
		w ",""state"":""open"""
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

/// Creator：丁亚男
/// CreatDate: 2018-05-2
/// Description：获取某个父节点下的所有子节点 用^连接，并按照顺序排列  
/// Table：User.MKBTerm
/// Input：父节点
/// Return：所有子节点 用^连接
/// w ##class(web.DHCBL.MKB.MKBKnoExpression).GetChildOrderedIDStr("")
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

/// Creator：李欣
/// CreatDate: 2018-05-16
/// Description：查询诊断属性父表内容
/// Table：User.MKBTermProperty
/// Input：rowid, code, desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBKnoExpression","GetProperty","","14626","")
Query GetProperty(rowid, termdr, q) As %Query(ROWSPEC = "MKBTPRowId,MKBTPDesc,MKBTPSequence")
{
}

ClassMethod GetPropertyExecute(ByRef qHandle As %Binary, rowid, termdr, q) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s desc=q
	if (rowid'="") //根据rowid返回该条记录
	{
		s MKBTPRowId=rowid
		s MKBTPDesc=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),3)
		s MKBTPType=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),4)
		s MKBTPDetail = ##class(web.DHCBL.MKB.MKBTermProperty).GetDetail(MKBTPType,MKBTPRowId)
		s MKBTPSequence=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),11)
		d OutputRowPro
	}
	else
	{
		if (termdr'=""){
			s:desc'="" desc=$ZCONVERT(desc,"U")
			s MKBTPRowId=0
			for  
			{	
				s MKBTPRowId=$o(^User.MKBTermPropertyI("TermIndex",termdr,MKBTPRowId)) q:MKBTPRowId="" 
				s MKBTPDesc=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),3)
				s MKBTPDescU=$ZCONVERT(MKBTPDesc,"U")
				s MKBTPType=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),4)
        		s MKBTPDetail = ##class(web.DHCBL.MKB.MKBTermProperty).GetDetail(MKBTPType,MKBTPRowId)
				s MKBTPSequence=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),11)
				s PINYIN=""
				s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBTPDescU)
				if (MKBTPDetail'="")
				{
					i ((MKBTPDescU[desc)||(PINYIN[desc))&((MKBTPType="T")||(MKBTPType="L")||(MKBTPType="S")||(MKBTPType="SS"))   //条件
					{
						d OutputRowPro
					}		
				}
					
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowPro
    set Data=$lb(MKBTPRowId,MKBTPDesc,MKBTPSequence)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetPropertyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPropertyExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPropertyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPropertyExecute ]
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

/// Creator：李欣
/// CreatDate: 2018-05-16
/// Description：根据属性id得到类型（树形，列表形）
/// Table：User.MKBTermBase
/// Input：base
/// Other: w ##class(web.DHCBL.MKB.MKBKnoExpression).GetProType("5")
ClassMethod GetProType(pro)
{
	q:pro="" ""
	s type=$LG($G(^User.MKBTermPropertyD(pro)),4)
	q type
}

/// Creator：李欣
/// CreatDate:2018-05-16
/// Description：获取树形属性内容数据
/// Table：User.MKBTermProDetail
/// Input：父节点 
/// Return：treegrid格式数据串
/// w ##class(web.DHCBL.MKB.MKBKnoExpression).GetTreeDetail("","1899")
ClassMethod GetTreeDetail(id As %String, property As %String) As %String
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
		s mySeq=$o(^User.MKBTermProDetailI("ProParSeqIndex",property,parentcatdr,mySeq)) q:(mySeq="")
		s n=n+1
		s a(n)= $g(mySeq)
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
			s myRowID=$o(^User.MKBTermProDetailI("ProParSeqIndex",property,parentcatdr,mySeq,myRowID)) q:(myRowID="")
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
	for 
	{
		s mySeq=$o(myArray(mySeq)) q:(mySeq="")
		s myRowID=$g(myArray(mySeq))
		//continue:$LISTGET($G(^User.MKBTermProDetailD(myRowID)),6)'="Y"
		s count=count+1
		s MKBTPDDesc=$LISTGET($G(^User.MKBTermProDetailD(myRowID)),3)
		s MKBTPDDesc=$tr(MKBTPDDesc,"""","")
		if count>1 w ","
		s MKBTPDCode=$LISTGET($G(^User.MKBTermProDetailD(myRowID)),2)
		s MKBTPDRemark=$LISTGET($G(^User.MKBTermProDetailD(myRowID)),7)
		s MKBTPDSequence=$LISTGET($G(^User.MKBTermProDetailD(myRowID)),9)
		s MKBTPDLastLevel=$LISTGET($G(^User.MKBTermProDetailD(myRowID)),4)
		if MKBTPDLastLevel'="" s MKBTPDLastLevel=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDLastLevel)),3)
		
		s MKBTPDLevel=$LISTGET($G(^User.MKBTermProDetailD(myRowID)),5)
		s PINYINDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBTPDDesc)
		s PINYINDesc=$ZCONVERT(PINYINDesc,"L")  
		w "{""id"":"""_myRowID_""",""text"":"""_MKBTPDDesc_""",""pydesc"":"""_PINYINDesc_""""
		w ",""state"":""open""" 
		s childStr=..GetChildOrderedIDStr(myRowID,property)
		if childStr'=""
		{
			//一次性加载   
			w ",""state"":""open"""   //closed节点不展开,open节点展开
			w ",""children"":"
			w ..GetTreeDetail(myRowID,property)
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

/// Creator：李欣
/// CreatDate:2018-05-16
/// Description：获取树形属性内容数据
/// Table：User.MKBTermProDetail
/// Input：父节点 
/// Return：treegrid格式数据串
/// w ##class(web.DHCBL.MKB.MKBKnoExpression).GetSTreeDetail("","72250")
ClassMethod GetSTreeDetail(id As %String, property As %String) As %String
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
		s mySeq=$o(^User.MKBTermProDetailI("ProParSeqIndex",property,parentcatdr,mySeq)) q:(mySeq="")
		s n=n+1
		s a(n)= $g(mySeq)
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
			s myRowID=$o(^User.MKBTermProDetailI("ProParSeqIndex",property,parentcatdr,mySeq,myRowID)) q:(myRowID="")
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
	for 
	{
		s mySeq=$o(myArray(mySeq)) q:(mySeq="")
		s myRowID=$g(myArray(mySeq))
		s count=count+1
		s MKBTPDDesc=$LISTGET($G(^User.MKBTermProDetailD(myRowID)),3)
		s MKBTPDDesc=$LG($G(^User.MKBTermD(MKBTPDDesc)),3)
		s MKBTPDDesc=$tr(MKBTPDDesc,"""","")
		if count>1 w ","
		s MKBTPDCode=$LISTGET($G(^User.MKBTermProDetailD(myRowID)),2)
		s MKBTPDRemark=$LISTGET($G(^User.MKBTermProDetailD(myRowID)),7)
		s MKBTPDSequence=$LISTGET($G(^User.MKBTermProDetailD(myRowID)),9)
		s MKBTPDLastLevel=$LISTGET($G(^User.MKBTermProDetailD(myRowID)),4)
		if MKBTPDLastLevel'="" s MKBTPDLastLevel=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDLastLevel)),3)
		
		s MKBTPDLevel=$LISTGET($G(^User.MKBTermProDetailD(myRowID)),5)
		s PINYINDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBTPDDesc)
		s PINYINDesc=$ZCONVERT(PINYINDesc,"L")  
		w "{""id"":"""_myRowID_""",""text"":"""_MKBTPDDesc_""",""pydesc"":"""_PINYINDesc_""""
		w ",""state"":""open""" 
		s childStr=..GetChildOrderedIDStr(myRowID,property)
		if childStr'=""
		{
			//一次性加载   
			w ",""state"":""open"""   //closed节点不展开,open节点展开
			w ",""children"":"
			w ..GetSTreeDetail(myRowID,property)
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
/// CreatDate:2018-03-30
/// Description：获取某个父节点下的所有子节点 用^连接，并按照顺序排列  
/// Table：User.MKBTermProDetail
/// Input：父节点
/// Return：所有子节点 用^连接
/// w ##class(web.DHCBL.MKB.MKBTermProDetail).GetChildOrderedIDStr("")
ClassMethod GetChildOrderedIDStr(LastLevel As %String, property As %String) As %String
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
		s mySeq=$o(^User.MKBTermProDetailI("ProParSeqIndex",property,LastLevel,mySeq)) q:(mySeq="")
		s n=n+1
		s a(n)= $g(mySeq)
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
			s myRowID=$o(^User.MKBTermProDetailI("ProParSeqIndex",property,LastLevel,mySeq,myRowID)) q:(myRowID="")
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
		
		s childStr=..GetChildOrderedIDStr(myRowID, property)
		if childStr'="" s childStr=myRowID_"^"_childStr
		if childStr="" s childStr=myRowID
		
		if IDStr="" s IDStr=childStr
		else  s IDStr=IDStr_"^"_childStr
	}
	q IDStr
}

/// Creator：李欣
/// CreatDate: 2018-05-16
/// Description：查询诊断属性父表内容
/// Table：User.MKBTermProperty
/// Input：rowid, code, desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBKnoExpression","GetListDetail","","1769","")
Query GetListDetail(rowid, property, q) As %Query(ROWSPEC = "MKBTPDRowId,MKBTPDDesc")
{
}

ClassMethod GetListDetailExecute(ByRef qHandle As %Binary, rowid, property, q) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s desc=q
	if (property'="")
	{
		if (rowid'="") //根据rowid返回该条记录
		{
			
			s MKBTPDRowId=rowid
			s MKBTPDDesc=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)
			s MKBTPDDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPDDesc)
			s MKBTPDDescU=$ZCONVERT(MKBTPDDesc,"U")
			d OutputRowListDetail
		}
		else
		{
			s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
			s MKBTPDRowId=0
			for  
			{	
				s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProIdx",property,MKBTPDRowId)) 
				q:MKBTPDRowId="" 

				s MKBTPDDesc=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)
				s MKBTPDDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPDDesc)
				s MKBTPDDescU=$ZCONVERT(MKBTPDDesc,"U")

				s PINYIN=""
				s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBTPDDesc)
				i ((MKBTPDDescU[desc)||(PINYIN[desc))   //条件
				{
					d OutputRowListDetail
				}	
			}
		}	
	}

	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowListDetail
    set Data=$lb(MKBTPDRowId,MKBTPDDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetListDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListDetailExecute ]
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

/// Creator：李欣
/// CreatDate: 2018-05-16
/// Description：查询诊断列表型引用术语属性父表内容
/// Table：User.MKBTermProperty
/// Input：rowid, code, desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBKnoExpression","GetSListDetail","","72250","")
Query GetSListDetail(rowid, property, q) As %Query(ROWSPEC = "MKBTPDRowId,MKBTPDDesc")
{
}

ClassMethod GetSListDetailExecute(ByRef qHandle As %Binary, rowid, property, q) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s desc=q
	if (property'="")
	{
		if (rowid'="") //根据rowid返回该条记录
		{
			
			s MKBTPDRowId=rowid
			s MKBTPDDesc=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)
			s MKBTPDDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPDDesc)
			s MKBTPDDesc = $LG($G(^User.MKBTermD(MKBTPDDesc)),3)
			s MKBTPDDescU=$ZCONVERT(MKBTPDDesc,"U")
			d OutputRowSListDetail
		}
		else
		{	
			s MKBTPDRowId=0
			for  
			{	
				s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProIdx",property,MKBTPDRowId)) 
				q:MKBTPDRowId="" 

				s MKBTPDDesc=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)
				s temp = ""
				s temp = MKBTPDRowId
				s MKBTPDRowId = "S"_MKBTPDDesc
				s MKBTPDDesc = $LG($G(^User.MKBTermD(MKBTPDDesc)),3)
				s MKBTPDDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPDDesc)
				s MKBTPDDescU=$ZCONVERT(MKBTPDDesc,"U")
				
				s PINYIN=""
				s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBTPDDesc)
				
				i ((MKBTPDDescU[desc)||(PINYIN[desc))   //条件
				{
					d OutputRowSListDetail
				}		
				s MKBTPDRowId = temp
			}
		}	
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowSListDetail
    set Data=$lb(MKBTPDRowId,MKBTPDDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetSListDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSistDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetSListDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSListDetailExecute ]
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

/// 获取常用名
ClassMethod GetCYM(termid)
{

	s result=""
	s result=$P($P(##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(termid),"[A]",1),"&%",1)
	
	if (result="")
	{
		s result=$LG($G(^User.MKBTermD(termid)),3)	
	}
	q result
}

/// Creator:李欣
/// CreateDate:20180515
/// Desc:将诊断表达式类数据id转换成字符串
/// w ##class(web.DHCBL.MKB.MKBKnoExpression).GetDiagDesc("16381-69785:S16510;&16381-71675:S16995")
ClassMethod GetDiagDesc(diag)
{
	q:diag="" ""
	s result=""
	s len = $L(diag,";")
	for i=1:1:len
	{
		s str = $P(diag,";",i)
		continue:(str="")||(str="&")||(str="|")
		if (i=1)
		{
			s TermId = $P(str,"-",1)
			s TermDesc = ..GetCYM(TermId)
			s result = TermDesc
			s sub = $P(str,"-",2)
			if (sub'="")
			{
				s ProId = $P(sub,":",1)
				s ProDesc = $LG($G(^User.MKBTermPropertyD(ProId)),3)
				s ProType = $LG($G(^User.MKBTermPropertyD(ProId)),4)
				s result = result_"("_ProDesc_"="
				s DetStr = $P(sub,":",2)
				s DetNum = $L(DetStr,"*")
				for j=1:1:DetNum
				{
					s DetDesc=""
					s DetId = $P(DetStr,"*",j)
					if (DetId'="")
					{
						if (ProType="T")||(ProType="L")
						{
							s DetDesc = ##class(web.DHCBL.MKB.MKBTermProDetail).GetExtendVal(DetId,ProId,"展示名")
							s:DetDesc="" DetDesc = $LG($G(^User.MKBTermProDetailD(DetId)),3)		
						}
						if (ProType="S")
						{
							if (DetId'="")
							{
								s souid=$p(DetId,"S",2)
								s:souid'="" DetDesc = ..GetCYM(souid)
							}
						}
						if (ProType="SS")
						{
							s:DetId["S" DetDesc=$LISTGET($G(^User.MKBTermD($P(DetId,"S",2))),3)
							s:DetId'["S" DetDesc=$LISTGET($G(^User.MKBTermD(DetId)),3)
							s DetDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(DetDesc)
						}
					}
					if (j=1)
					{
						s result = result_DetDesc	
					}
					else
					{
						s result = result_","_DetDesc	
					}
				}	
				s result = result_")"
			}		
		}
		else
		{
			s TermStr = $P(str,"-",1)
			s Con = $E(TermStr,1)
			if (Con="&")
			{
				s result = result_" 且 "	
			}
			else
			{
				s result = result_" 或 "	
			}
			s TermId = $E(TermStr,2,$L(TermStr))
			s TermDesc = ..GetCYM(TermId)
			s result = result_TermDesc
			s sub = $P(str,"-",2)
			if (sub'="")
			{
				s ProId = $P(sub,":",1)
				s ProDesc = $LG($G(^User.MKBTermPropertyD(ProId)),3)
				s ProType = $LG($G(^User.MKBTermPropertyD(ProId)),4)
				s result=result_"("_ProDesc_"="
				s DetStr = $P(sub,":",2)
				s DetNum = $L(DetStr,"*")
				for j=1:1:DetNum
				{
					s DetDesc=""
					s DetId = $P(DetStr,"*",j)
					if (DetId'="")
					{
						if (ProType="T")||(ProType="L")
						{
							s DetDesc = ##class(web.DHCBL.MKB.MKBTermProDetail).GetExtendVal(DetId,ProId,"展示名")
							s:DetDesc="" DetDesc = $LG($G(^User.MKBTermProDetailD(DetId)),3)
						}
						if (ProType="S")
						{
							if (DetId'="")
							{
								s souid=$p(DetId,"S",2)
								s:souid'="" DetDesc = ..GetCYM(souid)
							}
							
						}
						if (ProType="SS")
						{
							s DetDesc=$LISTGET($G(^User.MKBTermD(DetId)),3)
							s DetDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(DetDesc)							
						}
					}
					if (j=1)
					{
						s result = result_DetDesc	
					}
					else
					{
						s result = result_","_DetDesc	
					}
				}	
				s result = result_")"
			}
			
		}
	}
	q result
}

/// w ##class(web.DHCBL.MKB.MKBKnoExpression).GetSProType(1768)
ClassMethod GetSProType(proid)
{
	q:proid="" ""
	s config = $LG($G(^User.MKBTermPropertyD(proid)),5)
	q:config="" ""
	s type = $LG($G(^User.MKBTermBaseD(config)),4)
	q type
}

/// Creator:李欣
/// CreatDate:2018-04-13
/// Description：提供获取引用树形术语的接口 获取选中节点信息—— Json格式
/// Input:LastLevel ：上级节点id property:属性id
/// return:父节点及其所有子节点 Json格式
/// Other:w ##class(web.DHCBL.MKB.MKBKnoExpression).GetDocSourseTreeJson("","68030")
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
		
			w "["
			w "{""id"":"""_"S"_definedNode_""",""text"":"""_definedNodeDesc_""""
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

		if count>1 w ","
		w "{""id"":"""_"S"_myRowID_""",""text"":"""_Caption_""""
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

/// Desc:判断术语下是否有可取内容
/// Return:空 ：Y  非空 ：N
/// Debug:w ##class(web.DHCBL.MKB.MKBKnoExpression).EmptyDetail(14626)
ClassMethod EmptyDetail(termdr)
{
	s Flag="Y"
	if (termdr'="")
	{
		s MKBTPRowId=0
		for  
		{	
			s MKBTPRowId=$o(^User.MKBTermPropertyI("TermIndex",termdr,MKBTPRowId)) q:MKBTPRowId="" 
			s MKBTPType=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),4)
			s MKBTPDetail = ##class(web.DHCBL.MKB.MKBTermProperty).GetDetail(MKBTPType,MKBTPRowId)
			if (MKBTPDetail'="")
			{
				i ((MKBTPType="T")||(MKBTPType="L")||(MKBTPType="S"))   //条件
				{
					s Flag="N"
				}		
			}
					
		}	
	}
	q Flag
}

/// Creator:谷雪萍-----石萧伟更到此类
/// CreatDate:2018-12-21
/// Description：引用起始节点格式的属性内容展示区数据显示，如果有属性内容，则内容区域显示该节点及以下的节点
/// Input: property:属性id
/// return:引用术语的- 起始节点父节点及其所有子节点 Json格式
/// Other:w ##class(web.DHCBL.MKB.MKBKnoExpression).GetSourseSingleTermJson(property)
ClassMethod GetSourseSingleTermJson(property As %String) As %String
{
	
	q:(property="") "[]"
	
	s DATSOU=$LISTGET($G(^User.MKBTermPropertyD(property)),5)  //配置项

	q:(DATSOU="") "[]"

	s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProIdx",property,0))  //属性内容id
	//q:(MKBTPDRowId="") "[]"
	s definedNode=""
	s:MKBTPDRowId'="" definedNode=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)  //属性内容中心词
	if (definedNode="")  //如果起始节点为空，显示所有术语数据
	{
		w ..GetSourseJsonDataForCmb(DATSOU,definedNode,"")
		//w ##class(web.DHCBL.MKB.MKBTermProDetail).GetSourseJsonDataForCmb(DATSOU,definedNode,"")
	} 
	else  //如果定义了起始节点，显示该节点及以下的节点
	{
		s definedNodeDesc=$listGet($g(^User.MKBTermD(definedNode)),3)  //已选术语描述
		s definedNodeDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSONB(definedNodeDesc)
		s MKBTPYCode=$LISTGET($G(^User.MKBTermD(definedNode)),6)   //检索码
		if (MKBTPYCode'="")
		{
			s MKBTPYCode=$ZCONVERT(MKBTPYCode,"U") //转换成大写
			s MKBTPYCode= ##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPYCode)
		}
		
		w "["
		w "{""id"":""S"_definedNode_""",""text"":"""_definedNodeDesc_""""
		w ",""state"":""open"""
		
		if $d(^User.MKBTermI("ParentIndex",DATSOU,definedNode))  //如果有子节点
		{
			
			w ",""children"":"
			w ..GetSourseJsonDataForCmb(DATSOU,definedNode,"")
			//w ##class(web.DHCBL.MKB.MKBTermProDetail).GetSourseJsonDataForCmb(DATSOU,definedNode,"")
			//d ..GetTreeTermJsonForDoc(definedNode,DATSOU)
		}
		else
		{
			w ",""checked"":false"		
		
		}

		w "}"
		w "]"
	}

	
	q ""
}

/// Creator：谷雪萍 -----石萧伟更到此类
/// CreatDate:2018-05-08
/// Description：：获取引用-树形术语-tree的数据，如果属性中定义了初始节点，则内容区域显示该节点及以下的节点，如果没有定义起始节点，显示全部
/// Table：User.BDPItemCategory
/// Input：base-术语库注册id，   id-父节点id， selItemIds-要选中的节点
/// Return：treegrid格式数据串
/// w ##class(web.DHCBL.MKB.MKBTermProDetail).GetSourseJsonDataForCmb("31","")
ClassMethod GetSourseJsonDataForCmb(base As %String, id As %String, selItemIds As %String) As %String
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
			s Caption=$LISTGET($G(^User.MKBTermD(myRowID)),3)
			s Caption=##class(web.DHCBL.BDP.FunLib).EvalJSONB(Caption)
			s MKBTPYCode=$LISTGET($G(^User.MKBTermD(myRowID)),6)   //检索码
			if (MKBTPYCode'="")
			{
				s MKBTPYCode=$ZCONVERT(MKBTPYCode,"U") //转换成大写
				s MKBTPYCode= ##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPYCode)
			}
			if count>1 w ","
			w "{""id"":""S"_myRowID_""",""text"":"""_Caption_""""
			w ",""state"":""open"""
			
			s strId=","_myRowID_","
			
			//s childStr=##class(web.DHCBL.MKB.MKBTerm).GetChildOrderedIDStr(base,myRowID)
			//if childStr'=""
			if $d(^User.MKBTermI("ParentIndex",base,myRowID))
			{
				w ",""children"":"
				w ..GetSourseJsonDataForCmb(base,myRowID,selItemIds)	
			}
			else
			{
				if (selItemIds[strId){
					w ",""checked"":true"
				}
				else{
					w ",""checked"":false"
				}
			
			}
			w "}"
			
		}
	}
	w "]"
	q ""
}

/// Creator:陈代雷
/// CreatDate:2020-02-08
/// Description:辅助功能区自定义复合查询，如果属性类型为下拉框型，获取下拉框内容
/// Table: User.MKBTermBaseProperty
/// Input:str : 下拉框内容拼串
/// Return:返回规范下拉框内容
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBKnoExpression","GetDataResource","同码同义,同码不同义,不同码同义,不同码不同义")
Query GetDataResource(str As %String) As %Query(ROWSPEC = "value:%String,desc:%String")
{
}

ClassMethod GetDataResourceExecute(ByRef qHandle As %Binary, str As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	q:str=""
 	s len=$l(str,",")
 	for i=1:1:len
 	{
	 	s value=$p(str,",",i)
	 	s desc=$p(str,",",i)
	 	d OutputRow8
 	}
 	
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(value,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetDataResourceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataResourceExecute ]
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

ClassMethod GetDataResourceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataResourceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
