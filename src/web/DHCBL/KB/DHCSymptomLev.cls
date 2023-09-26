/// 名称: 症状分级表
/// 描述: 症状分级表方法类
/// 编写者：谷雪萍
/// 编写日期: 2016-05-13
Class web.DHCBL.KB.DHCSymptomLev Extends %RegisteredObject
{

/// 快速排序
ClassMethod QuickSort(ByRef a As %String, left As %String, right As %String) As %String
{
 s m=a(left),temp=0
 s i=left,j=right
 
 while (i<j)
 {
  for
  {
   if ((i<j)&(a(j)>=m))  s j=j-1        //a(j)>=m ,不加=号的话，当输入相等的数时会报错
    else  s temp=m,a(i)=a(j),a(j)=temp 
    quit:a(j)=m
  }
   for
  {
    if ((i<j)&(a(i)<=m)) s i=i+1         //a(i)<=m ,不加=号的话，当输入相等的数时会报错
    else  s temp=m,a(j)=a(i),a(i)=temp
    quit:a(i)=m 
  }
 }
  s a(i)=m
  if ((i-left)> 1)
    {
   d ..QuickSort(.a,left,i-1)
 }
  if ((right-i)> 1)  
 {
   d ..QuickSort(.a,i+1,right)
 }
    quit i
}

/// w ##class(web.DHCBL.KB.DHCSymptomLev).GetTreeJson("")
ClassMethod GetTreeJson(LastLevel As %String, nodeStr As %String) As %String
{
	if (LastLevel["Con")    //如果父菜单包含Con
	{
		q "[]"
	}
	if (LastLevel="TreeRoot") s LastLevel=-100000000000000
	s myJsonStr=""
	s myRowID=0
	s myCount=0
	s mySeq=0
	k myArray
	
	//生成菜单索引数组
	s mySeq=0
	s n=0
	for {
		s mySeq=$o(^User.DHCSymptomLevI("ParSeqIdx",LastLevel,mySeq))
		q:(mySeq="")
		s n=n+1
		s a(n)= $p(mySeq," ",2)
	}
	set left=1,right=n
	d:$d(a) ..QuickSort(.a,left,right) //排序
	
	
	s myRowID=0
	s n=0
	s mySeq=0
	for {
		s n=$o(a(n))
		q:(n="")
		s mySeq=$g(a(n))
		for {
			s myRowID=$o(^User.DHCSymptomLevI("ParSeqIdx",LastLevel," "_mySeq,myRowID))
			q:(myRowID="")
			s myCount=myCount+1
			s myArray(myCount)=myRowID
			;w !,myRowID
		}
	}
	
	//获取关联的症状id,并排序
	s mySeq=0
	s n=0
	for {
		s mySeq=$o(^DHCSYMCONi(0,"SEQ",LastLevel,mySeq))
		q:(mySeq="")
		s n=n+1
		s a(n)= mySeq
	}
	set left=1,right=n
	d:$d(a) ..QuickSort(.a,left,right) //排序
	
	s myRowID=0
	s n=0
	s mySeq=0
	for {
		s n=$o(a(n))
		q:(n="")
		s mySeq=$g(a(n))
		if (mySeq'=""){  //新增时不加此判断88上报错
			for {
				s myRowID=$o(^DHCSYMCONi(0,"SEQ",LastLevel,mySeq,myRowID))
				q:(myRowID="")
				s myCount=myCount+1
				s myArray(myCount)="Con"_myRowID
				;w !,myRowID
			}
		}
	}
	
	/*s FieldRowId=0
	for 
	{
		s FieldRowId=$o(^DHCSYMCONi(0,LastLevel,FieldRowId)) q:FieldRowId=""
		s SYCRowId=""
		i FieldRowId'="" 
		{
			s SYCRowId=$o(^DHCSYMCONi(0,LastLevel,FieldRowId,0))
			s myCount=myCount+1
			s myArray(myCount)="Con"_SYCRowId
		}
	}*/

	//输出菜单JSON串
	s myRowID=0
	s mySeq=0
	s myJsonStr=""
	
	for {
		;q:(+mySeq>1)
		s mySeq=$o(myArray(mySeq))
		q:(mySeq="")
		s myRowID=$g(myArray(mySeq))
		
		if (myRowID["Con")
		{
			s myID=$p(myRowID,"Con",2)
			s myObj=##Class(User.DHCSymptomCon).%OpenId(myID)
		}
		else
		{
			s myObj=##Class(User.DHCSymptomLev).%OpenId(myRowID,0)
		}
		if $IsObject(myObj) {

			if (myRowID["Con")
			{
				s SYCFieldDr=myObj.SYCFieldDr.%Id()
				s SYFActiveFlag=""
				if (SYCFieldDr'="")
				{
					s myDesc=$p($g(^DHCSYMFEI(SYCFieldDr)),"^",2)
					s SYFAge=$p($g(^DHCSYMFEI(SYCFieldDr)),"^",4)
					if (SYFAge'="")
					{
						s:SYFAge="A" SYFAge="成人"
						s:SYFAge="C" SYFAge="儿童"
						s myDesc=myDesc_"（"_SYFAge_"）"
					}
					s SYFActiveFlag=$p($g(^DHCSYMFEI(SYCFieldDr)),"^",3)
				}
				continue:SYFActiveFlag="N"
				
				s myImage="../scripts/bdp/Framework/icons/leaf.png"
			}
			else
			{
				s myDesc = myObj.SYLDesc
			}
			s nodeId="<"_myRowID_">"
			s:(myJsonStr'="") myJsonStr=myJsonStr_","
			s myJsonStr=myJsonStr_"{"
			s myJsonStr=myJsonStr_"""id"":"""_""_myRowID_""",""text"":"""_myDesc_""","
			if ((myRowID["Con")){
				s myJsonStr=myJsonStr_"""icon"":"""_""_myImage_""","
			}

			s myJsonStr=myJsonStr_"""leaf"":false,"
			
			if (nodeStr[nodeId){
				s myJsonStr=myJsonStr_"""expanded"":false"
			}
			else{
				s myJsonStr=myJsonStr_"""expanded"":true"
			}

			s myJsonStr=myJsonStr_"}"
		
			d myObj.%Close()
		}
	}
	k myArray

	s myJsonStr="["_myJsonStr_"]"
	
	q myJsonStr
}

/// w ##class(web.DHCBL.KB.DHCSymptomLev).GetTreeComboJson("LevTreeRoot")
ClassMethod GetTreeComboJson(ParentID As %String) As %String
{
	if (ParentID="LevTreeRoot") s ParentID=-100000000000000
	s myJsonStr=""
	s myRowID=0
	s myCount=0
	s mySeq=0
	k myArray
	
	//生成菜单索引数组
	s mySeq=0
	s n=0
	for {
		s mySeq=$o(^User.DHCSymptomLevI("ParSeqIdx",ParentID,mySeq))
		q:(mySeq="")
		s n=n+1
		s a(n)= $p(mySeq," ",2)
	}
	set left=1,right=n
	d:$d(a) ..QuickSort(.a,left,right) //排序
	s myRowID=0
	s n=0
	s mySeq=0
	for {
		s n=$o(a(n))
		q:(n="")
		s mySeq=$g(a(n))
		for {
			s myRowID=$o(^User.DHCSymptomLevI("ParSeqIdx",ParentID," "_mySeq,myRowID))
			q:(myRowID="")
			s myCount=myCount+1
			s myArray(myCount)=myRowID
			;w !,myRowID
		}
	}

	//输出菜单JSON串
	s myRowID=0
	s mySeq=0
	s myJsonStr=""
	
	for {
		;q:(+mySeq>1)
		s mySeq=$o(myArray(mySeq))
		q:(mySeq="")
		s myRowID=$g(myArray(mySeq))
		
		s myObj=##Class(User.DHCSymptomLev).%OpenId(myRowID,0)
		if $IsObject(myObj) {
			s myCode = myObj.SYLCode
			s myDesc = myObj.SYLDesc

				s:(myJsonStr'="") myJsonStr=myJsonStr_","
				s myJsonStr=myJsonStr_"{"
				s myJsonStr=myJsonStr_"""id"":"""_""_myRowID_""",""text"":"""_myDesc_""","
			//	s myJsonStr=myJsonStr_"""iconCls"":"""_""_myImage_""","

				s myJsonStr=myJsonStr_"""leaf"":false,"
				s myJsonStr=myJsonStr_"""expanded"":false"	

				s myJsonStr=myJsonStr_"}"
			
			d myObj.%Close()
		}
	}
	k myArray

	s myJsonStr="["_myJsonStr_"]"
	
	q myJsonStr
}

/// Function:用于实现数据校验功能的方法
/// Creator:基础数据平台组 谷雪萍
/// CreateDate:2016-05-13    
/// w ##class(web.DHCBL.KB.DHCSymptomLev).FormValidate("","","")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
 s:code'="" code=" "_$ZCONVERT(code,"U") //转换成大写
 s:desc'="" desc=" "_$ZCONVERT(desc,"U") //转换成大写
 s flag="",flagc="",flagd=""
 s:code'="" flagc=$d(^User.DHCSymptomLevI("CodeIndex",code))
 s:desc'="" flagd=$d(^User.DHCSymptomLevI("DescIndex",desc))
 if (id="") //如果为空，增加时的重复判断
 {
  	if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
	else  s flag=0 //返回不重复标志
 }
 else //如果不为空，修改时的重复判断
 {
    s idc="",idd=""
    s:code'="" idc=$o(^User.DHCSymptomLevI("CodeIndex",code,0))
    s:desc'="" idd=$o(^User.DHCSymptomLevI("DescIndex",desc,0))
	if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
	else  s flag=0 //返回不重复标志
 }
 q flag
}

/// Creator：谷雪萍
/// CreatDate: 2016-05-13
/// Description：保存修改内容
/// Table：User.DHCSymptomLev
/// Input：web.Entity.KB.DHCSymptomLev 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.Entity.KB.DHCSymptomLev) As %String
{
	s result = ""
	if $IsObject(eobj)
	{
				
		s flag=..FormValidate(eobj.SYLRowId ,eobj.SYLCode,eobj.SYLDesc)  //调用重复验证
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在'}"
		}
		else
		{
			s:eobj.SYLSequence'="" eobj.SYLSequence=$ZCONVERT(eobj.SYLSequence,"U")
			if (eobj.SYLRowId="")  //如果RowId未赋值则增加
			{
				s obj=##class(User.DHCSymptomLev).%New()
			}
			else  //如果RowId已赋值则修改
			{
				s obj=##class(User.DHCSymptomLev).%OpenId(eobj.SYLRowId)
				s bobj = ##class(web.Entity.KB.DHCSymptomLev).%New()
				s bobj.SYLRowId = eobj.SYLRowId
				s bobj.SYLCode = obj.SYLCode
				s bobj.SYLDesc = obj.SYLDesc
				s:obj.SYLLastRowid'="" bobj.SYLLastRowid = obj.SYLLastRowid.%Id()
				s bobj.SYLSequence = obj.SYLSequence
				s bobj.SYLLevel = obj.SYLLevel

			}
	
			s obj.SYLCode = eobj.SYLCode
			s obj.SYLDesc = eobj.SYLDesc
			//s obj.SYLLastRowid = eobj.SYLLastRowid
			d:eobj.SYLLastRowid'="" obj.SYLLastRowidSetObjectId(eobj.SYLLastRowid)
			d:eobj.SYLLastRowid="" obj.SYLLastRowidSetObjectId("")
			s obj.SYLSequence = eobj.SYLSequence
			s obj.SYLLevel = eobj.SYLLevel
			
			Ts
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc){
				Tc
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}" //返回RowId
				d:eobj.SYLRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_SymptomLev","User.DHCSymptomLev","症状分级字典",id,eobj.SYLDesc,"A",eobj)
				d:eobj.SYLRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_SymptomLev","User.DHCSymptomLev","症状分级字典",eobj.SYLRowId,eobj.SYLDesc,"U",eobj,bobj)
			}
			else{
				Trollback
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
				s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("症状分级字典","web.DHCBL.KB.DHCSymptomLev","SaveData",eobj)
    			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			}
		}	
	}	

	else
	{
		s result = "{success:'false',errorinfo:'对象不存在'}"
	}
	
	q result
}

/// Description：保存症状分级表拖拽的内容
/// Table：User.DHCSymptomLev
/// Input：id, parentid,orderstr
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: w ##class(web.DHCBL.KB.DHCSymptomCon).SaveData()
ClassMethod DragNode(id, parentid, orderstr) As %String
{
	s result=""
	q:(id="") "{success:'false',errorinfo:'没有拖拽的节点'}"
	q:(parentid["Con") "{success:'false',errorinfo:'不允许拖拽到症状下'}"
	s:parentid="TreeRoot" parentid=""
	if (id["Con")  //如果移动的是症状
	{
		s conId=$p(id,"Con",2)
		s obj=##class(User.DHCSymptomCon).%OpenId(conId)
		s fieldDr=obj.SYCFieldDr.%Id()
		s LevDr=obj.SYCLevDr.%Id()
		if ($d(^DHCSYMCONi(0,parentid,fieldDr)))&(LevDr'=parentid)
		{
			q "{success:'false',errorinfo:'该症状分级下已经有此症状'}"
		}
		d:parentid="" obj.SYCLevDrSetObjectId("")
		d:parentid'="" obj.SYCLevDrSetObjectId(parentid)
	
		Ts	
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'Con"_id_"'}" //返回RowId
		
			  s orderLen=$Length(orderstr,"^")
			  s count=0
			  for i=1:1:orderLen   
			  {      
			      s rowid=$p(orderstr,"^",i)
			      if (rowid["Con")
			      {
				     s count=count+1
			      	 s rowid=$p(rowid,"Con",2)
			      	 s obj=##class(User.DHCSymptomCon).%OpenId(rowid)
				     s obj.SYCSequence =count
				     s sc=obj.%Save()
				     d obj.%Close()  
                
			      }
			      else
			      {
	 				continue
			      }
			  }
		  
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
		}

		
	}
	else    //移动的是症状分级
	{
	
		s obj=##class(User.DHCSymptomLev).%OpenId(id)
		d:parentid="" obj.SYLLastRowidSetObjectId("")
		d:parentid'="" obj.SYLLastRowidSetObjectId(parentid)
		
		s:parentid'="" level=..GetLevel(parentid)
		s:parentid="" level=0
		s obj.SYLLevel =level+1
	
		Ts	
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" //返回RowId
		
			  s orderLen=$Length(orderstr,"^")
			  s count=0
			  for i=1:1:orderLen   
			  {      
			      s rowid=$p(orderstr,"^",i)
			      if (rowid["Con")
			      {   
	                 continue
			      }
			      else
			      {
				     s count=count+1
			      	 s obj=##class(User.DHCSymptomLev).%OpenId(rowid)
				     s obj.SYLSequence =count
				     s sc=obj.%Save()
				     d obj.%Close()
			      }
			  }
		  
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
		}
	}
	q result
}

/// Creator：谷雪萍
/// CreatDate: 2016-05-13
/// Description：获取修改时的记录
/// Table：User.DHCSymptomLev
/// Other: d ##class(web.DHCBL.KB.DHCSymptomLev).OpenData()
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s eobj = ##class(web.Entity.KB.DHCSymptomLev).%New()
	
	s pobj = ##class(User.DHCSymptomLev).%OpenId(id)
	s eobj.SYLRowId = id
	s eobj.SYLCode = pobj.SYLCode
	s eobj.SYLDesc = pobj.SYLDesc
	s:pobj.SYLLastRowid'="" eobj.SYLLastRowid = pobj.SYLLastRowid.%Id()
	s eobj.SYLSequence = pobj.SYLSequence
	s eobj.SYLLevel = pobj.SYLLevel
	
	s str = eobj.JsonS()	
	s str = "{data:["_str_"]}"
	q str
}

/// Creator:谷雪萍
/// CreatDate:2016-5-17
/// Description:看子节点有没有关联症状
/// Return:1-被引用不可删除,0-未被引用可删除
/// Other: d ##class(web.DHCBL.KB.DHCSymptomLev).GetRefChildFlag("2")
ClassMethod GetRefChildFlag(id As %String) As %String
{
	s childLevId=0,flag=0
	for
	{
		s childLevId=$o(^User.DHCSymptomLevI("ParIdx",id,childLevId)) q:(childLevId="")||(flag=1)  d
		s haslev=$d(^DHCSYMCONi(0,childLevId))
		if haslev
		{
			s flag=1
		}
		else
		{
			s flag= ..GetRefChildFlag(childLevId)
		}
		
	}
	q flag
}

/// Creator:谷雪萍
/// CreatDate:2014-12-2
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// Other: d ##class(web.DHCBL.KB.DHCSymptomLev).GetRefFlag("2")
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""
	//是不是有关联的父节点
	s childLevId=0,flag=0
	if $d(^DHCSYMCONi(0,id))
	{
		s flag=1
	}
	else
	{
		s flag= ..GetRefChildFlag(id)
	}

	if (flag){
		s myInfo=myInfo_"<关联症状>"
	}	
	
	i myInfo="" s return="0^未被引用可删除！"
	else  s return="1^该节点或其子节点在"_myInfo_"表里被引用,不能删除！"
	
	q return
}

/// Creator:谷雪萍
/// CreatDate:2016-05-13-30
/// Description:根据id删除
/// Table:User.DHCSymptomLev
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.KB.DHCSymptomLev).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	s return="",myInfo=""
	
	s re=##class(web.DHCBL.KB.DHCSymptomLev).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag'=0){
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}
	else
	{
		
		s eobj = ##class(web.Entity.KB.DHCSymptomLev).%New()
		s pobj = ##class(User.DHCSymptomLev).%OpenId(id)
		s eobj.SYLRowId = id
		s eobj.SYLCode = pobj.SYLCode
		s eobj.SYLDesc = pobj.SYLDesc
		s:pobj.SYLLastRowid'="" eobj.SYLLastRowid = pobj.SYLLastRowid.%Id()
		s eobj.SYLSequence = pobj.SYLSequence
		s eobj.SYLLevel = pobj.SYLLevel
		
		Tstart
		s sc=##class(User.DHCSymptomLev).%DeleteId(id)
		if $$$ISOK(sc){
			Tcommit
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_SymptomLev","User.DHCSymptomLev","症状分级字典",id,eobj.SYLDesc,"D",eobj)
		}
		else{
			Trollback
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("症状分级字典","web.DHCBL.KB.DHCSymptomLev","DeleteData",eobj)
    		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	q result
}

/// w ##class(web.DHCBL.KB.DHCSymptomLev).GetLevel("3")
ClassMethod GetLevel(myRowID As %String) As %String
{
	s SYLLevel=""
	s:myRowID'="" SYLLevel=$listGet($g(^User.DHCSymptomLevD(myRowID)),5)
	q SYLLevel
}

/// 添加时获取显示顺序
/// 入参：父菜单id
/// w ##class(web.DHCBL.BDP.DHCProductLine).GetSequence("1")
ClassMethod GetSequence(id As %String) As %String
{
 if (id="TreeRoot") s id=-100000000000000
 s mySMRowID=0
 s myLineCount=0
 s mySMSeq=0
 k myLineArray
 
 //生成菜单索引数组
 s mySMSeq=0
 s n=0
 for {
  s mySMSeq=$o(^User.DHCSymptomLevI("ParSeqIdx",id,mySMSeq))
  q:(mySMSeq="")
  s n=n+1
  s a(n)= $p(mySMSeq," ",2)
 }
 set left=1,right=n
 d:$d(a) ..QuickSort(.a,left,right) //排序
 s mySMRowID=0
 s n=0
 s mySMSeq=0
 for {
  s n=$o(a(n))
  q:(n="")
  s mySMSeq=$g(a(n))
 }
 
 q mySMSeq+1
}

}
