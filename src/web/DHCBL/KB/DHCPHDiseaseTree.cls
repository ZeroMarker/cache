/// 诊断逻辑推导目录
/// 描述: 增删改查方法类
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2017-4-13
Class web.DHCBL.KB.DHCPHDiseaseTree Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：石萧伟
/// CreatDate:2018-08-16
/// Description：获取修改时的记录
/// Table：User.DHCPHDiseaseTree
/// Other: d ##class(web.DHCBL.KB.DHCPHDiseaseTree).OpenData()
ClassMethod NewOpenData(id As %String) As %String
{
	n (id)
	s str=""	
	s eobj = ##class(web.Entity.KB.DHCPHDiseaseTree).%New()
	s pobj = ##class(User.DHCPHDiseaseTree).%OpenId(id)
	s eobj.PDTRowId = id
	s eobj.PDTCode = pobj.PDTCode
	s eobj.PDTDesc = pobj.PDTDesc
	s:pobj.PDTLastRowid'="" eobj.PDTLastRowid = pobj.PDTLastRowid.%Id()
	s eobj.PDTLevel = pobj.PDTLevel
	s eobj.PDTActiveFlag = pobj.PDTActiveFlag
	s eobj.PDTSysFlag = pobj.PDTSysFlag
	s:pobj.PDTActiveFlag="" eobj.PDTActiveFlag="Y"
	s:pobj.PDTSysFlag="" eobj.PDTSysFlag="Y"
	s str = eobj.JsonS()	
	//s str = "{data:["_str_"]}"
	q str
}

/// 石萧伟
/// w ##class(web.DHCBL.KB.DHCPHDiseaseTree).GetTreeComboJson("CatTreeRoot","")
ClassMethod GetNewTreeComboJson(ParentID As %String) As %String
{
	n (ParentID)
	if (ParentID="") s ParentID=-100000000000000
	s myJsonStr=""
	s myCount=0
	k myArray	
	k arr
	s myRowID=0
	for {
		s myRowID=$o(^DHCPHDISTRi(0,"ParIdx",ParentID,myRowID))
		q:(myRowID="")
		s myCount=myCount+1
		s myArray(myCount)=myRowID
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
		
		s myObj=##Class(User.DHCPHDiseaseTree).%OpenId(myRowID,0)
		if $IsObject(myObj) {
			s myCode = myObj.PDTCode
			s myDesc = myObj.PDTDesc
			s myLastLevel=myObj.PDTLastRowid
			s myLevel = myObj.PDTLevel
			s myActiveFlag = myObj.PDTActiveFlag
			s PDTSysFlag = myObj.PDTSysFlag
	
			s:(myJsonStr'="") myJsonStr=myJsonStr_","
			s myJsonStr=myJsonStr_"{"
			s myJsonStr=myJsonStr_"""id"":"""_""_myRowID_""",""text"":"""_myDesc_""","
            s myJsonStr=myJsonStr_"""state"":""open"""
				if ($d(^DHCPHDISTRi(0,"ParIdx",myRowID))){
					s myJsonStr=myJsonStr_",""children"":"_..GetNewTreeComboJson(myRowID)
				}			
			s myJsonStr=myJsonStr_"}"

			d myObj.%Close()
		}
	}
	k myArray

	s myJsonStr="["_myJsonStr_"]"
	
	q myJsonStr
}

/// 石萧伟
/// w ##class(web.DHCBL.KB.DHCPHDiseaseTree).GetNewTreeJson("TreeRoot","^<44>^<38>^<18>^<27>")
ClassMethod GetNewTreeJson(id As %String) As %String
{
	n (id)
	if (id="") s id=-100000000000000
	//输出菜单JSON串
	s myRowID=0
	s myJsonStr=""	
	for {
		s myRowID=$o(^DHCPHDISTRi(0,"ParIdx",id,myRowID))
		q:(myRowID="")
		s myObj=##Class(User.DHCPHDiseaseTree).%OpenId(myRowID,0)
		if $IsObject(myObj) {
			s myCode = myObj.PDTCode
			s myDesc = myObj.PDTDesc
			s myid = myObj.PDTLastRowid
			s myLevel = myObj.PDTLevel
			s myActiveFlag = myObj.PDTActiveFlag
			s mySysFlag = myObj.PDTSysFlag
			
			s:(myJsonStr'="") myJsonStr=myJsonStr_","
			s myJsonStr=myJsonStr_"{"

			s myJsonStr=myJsonStr_"""id"":"""_""_myRowID_""",""text"":"""_myDesc_""","
			
			s myJsonStr=myJsonStr_"""state"":""open"""
    		if ($d(^DHCPHDISTRi(0,"ParIdx",myRowID))){
				s myJsonStr=myJsonStr_",""children"":"_..GetNewTreeJson(myRowID)
			}
			s myJsonStr=myJsonStr_"}"

			d myObj.%Close()
		}
	}
	k myArray
	s myJsonStr="["_myJsonStr_"]"
	
	q myJsonStr
}

/// w ##class(web.DHCBL.KB.DHCPHDiseaseTree).GetTreeJson("TreeRoot","^<44>^<38>^<18>^<27>")
ClassMethod GetTreeJson(LastLevel As %String, nodeStr As %String) As %String
{
	n (LastLevel,nodeStr)
	if (LastLevel="TreeRoot") s LastLevel=-100000000000000

	//输出菜单JSON串
	s myRowID=0
	s myJsonStr=""	
	for {
		s myRowID=$o(^DHCPHDISTRi(0,"ParIdx",LastLevel,myRowID))
		q:(myRowID="")
		s myObj=##Class(User.DHCPHDiseaseTree).%OpenId(myRowID,0)
		if $IsObject(myObj) {
			s myCode = myObj.PDTCode
			s myDesc = myObj.PDTDesc
			s myLastLevel = myObj.PDTLastRowid
			s myLevel = myObj.PDTLevel
			s myActiveFlag = myObj.PDTActiveFlag
			s mySysFlag = myObj.PDTSysFlag

			s nodeId="<"_myRowID_">"
			//判断是否有子菜单 
		   s myChildFlag=$d(^DHCPHDISTRi(0,"ParIdx",myRowID))
		   if (myChildFlag) s myChildFlag=1 //有子节点    
		   else  s myChildFlag=0
			
			s:(myJsonStr'="") myJsonStr=myJsonStr_","
			s myJsonStr=myJsonStr_"{"

			s myJsonStr=myJsonStr_"""id"":"""_""_myRowID_""",""text"":"""_myDesc_""","
			
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

/// w ##class(web.DHCBL.KB.DHCPHDiseaseTree).GetLevel("3")
ClassMethod GetLevel(myRowID As %String) As %String
{
	n (myRowID)
	s Level=""
	s:myRowID'="" Level=$p($g(^DHCPHDISTR(myRowID)),"^",4)
	q Level
}

/// w ##class(web.DHCBL.KB.DHCPHDiseaseTree).GetTreeComboId("24")
ClassMethod GetTreeComboId(myRowID As %String) As %String
{
	n (myRowID)
	s str=myRowID
	for
	{
		s myRowID=$p($g(^DHCPHDISTR(myRowID)),"^",3)
		q:myRowID=""
		s str=myRowID_"^"_str
	}
	q str
}

/// w ##class(web.DHCBL.KB.DHCPHDiseaseTree).GetTreeComboJson("CatTreeRoot","")
ClassMethod GetTreeComboJson(ParentID As %String, nodeid As %String) As %String
{
	n (nodeid,ParentID)
	if (ParentID="CatTreeRoot") s ParentID=-100000000000000
	s myJsonStr=""
	s myCount=0
	k myArray	
	k arr
	s myRowID=0
	for {
		s myRowID=$o(^DHCPHDISTRi(0,"ParIdx",ParentID,myRowID))
		q:(myRowID="")
		s myCount=myCount+1
		s myArray(myCount)=myRowID
	}

	//获取父类id
	if (nodeid'=""){
		s str=##class(web.DHCBL.KB.DHCPHDiseaseTree).GetTreeComboId(nodeid)
		s strLen=$Length(str,"^")			
		for i=1:1:strLen
		{
			s rowid = $p(str,"^",i)
			s arr(rowid)=i
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
		
		s myObj=##Class(User.DHCPHDiseaseTree).%OpenId(myRowID,0)
		if $IsObject(myObj) {
			s myCode = myObj.PDTCode
			s myDesc = myObj.PDTDesc
			s myLastLevel=myObj.PDTLastRowid
			s myLevel = myObj.PDTLevel
			s myActiveFlag = myObj.PDTActiveFlag
			s PDTSysFlag = myObj.PDTSysFlag
	
			s:(myJsonStr'="") myJsonStr=myJsonStr_","
			s myJsonStr=myJsonStr_"{"
			s myJsonStr=myJsonStr_"""id"":"""_""_myRowID_""",""text"":"""_myDesc_""","
					
			if ($o(^DHCPHDISTRi(0,"ParIdx",myRowID,0))=""){
				s myJsonStr=myJsonStr_"""leaf"":true,"
			}
			else
			{
				s myJsonStr=myJsonStr_"""leaf"":false,"
			}
			if (nodeid'=""){
				if ($d(arr(myRowID))){ 
					s myJsonStr=myJsonStr_"""expanded"":true"
				}
				else{
					s myJsonStr=myJsonStr_"""expanded"":false"
				}
			}
			else{
				s myJsonStr=myJsonStr_"""expanded"":false"	 
			}
			s myJsonStr=myJsonStr_"}"

			d myObj.%Close()
		}
	}
	k myArray

	s myJsonStr="["_myJsonStr_"]"
	
	q myJsonStr
}

/*ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s flag="",flagc="",flagd=""
	s:code'="" flagc=$d(^DHCPHDISTRi(0,"Code",code))
	s:desc'="" flagd=$d(^DHCPHDISTRi(0,"Desc",desc))
	if (id="") //如果为空，增加时的重复判断
	{
		if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc="",idd=""
		s:code'="" idc=$o(^DHCPHDISTRi(0,"Code",code,0))
  		s:desc'="" idd=$o(^DHCPHDISTRi(0,"Desc",desc,0))
		if (desc="")
		{
			if (idc'=id)&(flagc>0) s flag=1  //返回重复标志
			else  s flag=0 //返回不重复标志
		}
		elseif (code="")
		{
			if (idd'=id)&(flagd>0) s flag=1  //返回重复标志
			else  s flag=0 //返回不重复标志
		}
	}
	q flag
}*/
/// Function:用于实现数据校验功能的方法
/// Creator:基础数据平台组 谷雪萍
/// CreateDate:2017-4-13
/// w ##class(web.DHCBL.KB.DHCPHDiseaseTree).FormValidate("","测试","测试")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String) As %String
{
	n (code,id)
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	s flag="",flagc=""
	s:code'="" flagc=$d(^DHCPHDISTRi(0,"Code",code))
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagc>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc=""
		s:code'="" idc=$o(^DHCPHDISTRi(0,"Code",code,0))
		if (idc'=id)&(flagc>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志

	}
	q flag
}

/// Creator：谷雪萍
/// CreatDate: 2017-4-13
/// Description：保存修改内容
/// Table：User.DHCPHDiseaseTree
/// Input：web.Entity.KB.DHCPHDiseaseTree 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.Entity.KB.DHCPHDiseaseTree) As %String
{
	n (eobj,%session)
	s result = ""
	if $IsObject(eobj)
	{
			
		s flag=..FormValidate(eobj.PDTRowId,eobj.PDTCode)  //调用重复验证
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在'}"
		}
		else
		{
			if (eobj.PDTRowId="")  //如果RowId未赋值则增加
			{
				s obj=##class(User.DHCPHDiseaseTree).%New()
			}
			else  //如果RowId已赋值则修改
			{
				s obj=##class(User.DHCPHDiseaseTree).%OpenId(eobj.PDTRowId)
				s bobj = ##class(web.Entity.KB.DHCPHDiseaseTree).%New()
				s bobj.PDTRowId = eobj.PDTRowId
				s bobj.PDTCode = obj.PDTCode
				s bobj.PDTDesc = obj.PDTDesc
				s:obj.PDTLastRowid'="" bobj.PDTLastRowid = obj.PDTLastRowid.%Id()
				s bobj.PDTLevel = obj.PDTLevel
				s bobj.PDTActiveFlag= obj.PDTActiveFlag
				s bobj.PDTSysFlag = obj.PDTSysFlag
			}
	
			s obj.PDTCode = eobj.PDTCode
			s obj.PDTDesc = eobj.PDTDesc
			d:eobj.PDTLastRowid'="" obj.PDTLastRowidSetObjectId(eobj.PDTLastRowid)
			d:eobj.PDTLastRowid="" obj.PDTLastRowidSetObjectId("")
			s obj.PDTLevel = eobj.PDTLevel
			
			i eobj.PDTActiveFlag="Y"
			{
				s obj.PDTActiveFlag = "Y"
			}
			else
			{
				s obj.PDTActiveFlag = "N"
			}
			i eobj.PDTSysFlag="Y"
			{
				s obj.PDTSysFlag = "Y"
			}
			else
			{
				s obj.PDTSysFlag = "N"
			}

			Ts
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc){
				Tc
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}" //返回RowId
				d:eobj.PDTRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHDiseaseTree","User.DHCPHDiseaseTree","诊断逻辑推导目录",id,eobj.PDTDesc,"A",eobj)
				d:eobj.PDTRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHDiseaseTree","User.DHCPHDiseaseTree","诊断逻辑推导目录",id,eobj.PDTDesc,"U",eobj,bobj)
			
			}else{
				Trollback
				s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("诊断逻辑推导目录","web.DHCBL.KB.DHCPHDiseaseTree","SaveData",eobj)
	   			s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
			}
		}	
	}	
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在'}"
	}
	
	q result
}

/// Creator：谷雪萍
/// CreatDate:2017-4-13
/// Description：获取修改时的记录
/// Table：User.DHCPHDiseaseTree
/// Other: d ##class(web.DHCBL.KB.DHCPHDiseaseTree).OpenData()
ClassMethod OpenData(id As %String) As %String
{
	n (id)
	s str=""	
	s eobj = ##class(web.Entity.KB.DHCPHDiseaseTree).%New()
	s pobj = ##class(User.DHCPHDiseaseTree).%OpenId(id)
	s eobj.PDTRowId = id
	s eobj.PDTCode = pobj.PDTCode
	s eobj.PDTDesc = pobj.PDTDesc
	s:pobj.PDTLastRowid'="" eobj.PDTLastRowid = pobj.PDTLastRowid.%Id()
	s eobj.PDTLevel = pobj.PDTLevel
	s:pobj.PDTActiveFlag="Y" eobj.PDTActiveFlag="true"
	s:pobj.PDTSysFlag="Y" eobj.PDTSysFlag="true"
	s str = eobj.JsonS()	
	s str = "{data:["_str_"]}"
	q str
}

/// Creator:谷雪萍
/// CreatDate:2017-4-13
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
ClassMethod GetRefFlag(id As %String) As %String
{
	n (id)
	s return="",myInfo=""
	
	/*s RowId=0,flag=0
	for
	{
		s RowId=$o(^DKBDIAGNO(RowId)) q:(RowId="")||k(flag=1)  d
		s PositionDR=$p($g(^DKBDIAGNO(RowId)),"^",3)
		i PositionDR=id
		{
			s flag=1
			s myInfo=myInfo_"<诊断字典表>"
		}
	}*/
	i ($d(^DHCPHDISLILAi(0,"Tree",id))){
		s myInfo=myInfo_"<推导目录表>"
	}
	i ($d(^DHCPHDISTRi(0,"ParIdx",id))){
		s myInfo=myInfo_"<诊断逻辑推导目录>"
	}
	i ($d(^DHCPHDISLPROi(0,"Label",id))){
		s myInfo=myInfo_"<推导目录提示>"
	}	
	i myInfo="" s return="0^未被引用可删除!"
 	else  s return="1^在"_myInfo_"表里被引用,不能删除!"
 	q return
}

/// Creator:谷雪萍
/// CreatDate:2017-4-13
/// Description:根据id删除
/// Table:User.DHCPHDiseaseTree
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.KB.DHCPHDiseaseTree).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	n (id,%session)
	s return="",myInfo=""
	s re=##class(web.DHCBL.KB.DHCPHDiseaseTree).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag'=0){
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}
	else
	{
		Tstart
		s eobj = ##class(web.Entity.KB.DHCPHDiseaseTree).%New()
		s pobj = ##class(User.DHCPHDiseaseTree).%OpenId(id)
		s eobj.PDTRowId = id
		s eobj.PDTCode = pobj.PDTCode
		s eobj.PDTDesc = pobj.PDTDesc
		s:pobj.PDTLastRowid'="" eobj.PDTLastRowid = pobj.PDTLastRowid.%Id()
		s eobj.PDTLevel = pobj.PDTLevel
		s eobj.PDTActiveFlag = pobj.PDTActiveFlag
		s eobj.PDTSysFlag = pobj.PDTSysFlag
	
		s sc=##class(User.DHCPHDiseaseTree).%DeleteId(id)
		if $$$ISOK(sc){
			Tcommit
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHDiseaseTree","User.DHCPHDiseaseTree","诊断逻辑推导目录",id,eobj.PDTDesc,"D",eobj)
			s result="{success:'true',info:'删除成功！'}"
		}
		else{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("诊断逻辑推导目录","web.DHCBL.CT.DHCPHDiseaseTree","DeleteData",eobj)
	   		s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
	}
	q result
}

/// 获取上级分类及描述
/// w ##class(web.DHCBL.KB.DHCPHDiseaseTree).GetLastLevel(3)
ClassMethod GetLastLevel(id) As %String
{
	n (id)
	q:id="" ""
	s myLastLevel = $p($g(^DHCPHDISTR(id)),"^",3)
	s myLastDesc=""
	s:myLastLevel'="" myLastDesc=$p($g(^DHCPHDISTR(myLastLevel)),"^",2)
	s LastLevel=myLastLevel_"^"_myLastDesc
	q LastLevel
}

/// 获取描述
/// w ##class(web.DHCBL.KB.DHCPHDiseaseTree).GetLastLevel(3)
ClassMethod GetDesc(id) As %String
{
	n (id)
	s desc = ""
	s:id'="" desc=$p($g(^DHCPHDISTR(id)),"^",2)
	q desc
}

ClassMethod DragNode(id, parentid, orderstr) As %String
{
	n (id,parentid, orderstr,%session)
	s result=""
	s:parentid="TreeRoot" parentid=""
	s obj=##class(User.DHCPHDiseaseTree).%OpenId(id)
	d:parentid="" obj.PDTLastRowidSetObjectId("")
	d:parentid'="" obj.PDTLastRowidSetObjectId(parentid)
	s Desc=obj.PDTDesc
	
	s eobj = ##class(web.Entity.KB.DHCPHDiseaseTree).%New()
	s eobj.PDTRowId =id
	s eobj.PDTCode = obj.PDTCode
	s eobj.PDTDesc = obj.PDTDesc
	s eobj.PDTLastRowid = parentid
	s eobj.PDTLevel = obj.PDTLevel
	s eobj.PDTActiveFlag= obj.PDTActiveFlag
	s eobj.PDTSysFlag = obj.PDTSysFlag
	
	s bobj = ##class(web.Entity.KB.DHCPHDiseaseTree).%New()
	s bobj.PDTRowId = id
	s bobj.PDTCode = obj.PDTCode
	s bobj.PDTDesc = obj.PDTDesc
	s:obj.PDTLastRowid'="" bobj.PDTLastRowid = obj.PDTLastRowid.%Id()
	s bobj.PDTLevel = obj.PDTLevel
	s bobj.PDTActiveFlag= obj.PDTActiveFlag
	s bobj.PDTSysFlag = obj.PDTSysFlag
	
	Ts	
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc){
		Tc
		s id = obj.%Id()
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHDiseaseTree","User.DHCPHDiseaseTree","诊断逻辑推导目录",id,Desc,"U",eobj,bobj)	
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
	}else{
		Trollback
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("诊断逻辑推导目录","web.DHCBL.CT.DHCPHDiseaseTree","DragNode",eobj)
	   	s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
	}
	q result
}

/// Description:代码自动生成  ZD0000000 代码最大值加1
/// Table：User.DHCPHDiseaseTree
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// w ##class(web.DHCBL.KB.DHCPHDiseaseTree).GetLastCode()
ClassMethod GetLastCode() As %String
{
	n 
	s AutoCode=$g(^TMP("Auto","DHC_PHDiseaseTree","AutoCode"))  //是否手动输入
  	s CodeLen=$g(^TMP("Auto","DHC_PHDiseaseTree","CodeLen"))    //代码长度
  	s StartCode=$g(^TMP("Auto","DHC_PHDiseaseTree","StartCode"))  //代码起始字符
  	s code=""
	if (AutoCode="false")  //自动生成代码
	{
		s StartCodeLen=$Length(StartCode)
		s PDTRowId=0, preCode=""    //寻找符合规则的最大的代码
		for {
			s PDTRowId=$o(^DHCPHDISTR(PDTRowId))
			q:PDTRowId=""
			s PDTCode=$p($g(^DHCPHDISTR(PDTRowId)),"^",1)
			if ($e(PDTCode,1,StartCodeLen)=StartCode)
			{
				s preCode=PDTCode
			}
			
		}
		if (preCode="")   //如果没有符合规则的代码，则生成第一个
		{
			s zeroLen=CodeLen-StartCodeLen
			s zeroStr=""
			s count=0
			for
			{
				s count=count+1
				q:count>zeroLen
				s zeroStr=zeroStr_"0"
			}
			s preCode=StartCode_zeroStr
		}
		s CodeNum=$p(preCode,StartCode,2)+1     //ZD后的数字+1
		s CodeNumLen=$Length(CodeNum)     //数字的长度
		s code=$e(preCode,1,CodeLen-CodeNumLen)_CodeNum  //组合
	}
	else  //手动输入代码
	{
		s code=""
	}
	q code
}

/// 保存代码生成规则
/// Others:w ##class(web.DHCBL.KB.DHCPHDiseaseTree).SaveAutoCode()
ClassMethod SaveAutoCode(AutoCode, CodeLen, StartCode) As %String
{
 
   k ^TMP("Auto","DHC_PHDiseaseTree")
   s result=""
   if ($Length(StartCode)>=CodeLen)
   {
	   s result=2
	   s ^TMP("Auto","DHC_PHDiseaseTree","AutoCode")="true"
	   s ^TMP("Auto","DHC_PHDiseaseTree","CodeLen")=""
	   s ^TMP("Auto","DHC_PHDiseaseTree","StartCode")=""
   } 
   else
   {
	   if (AutoCode="")||(AutoCode="0")   //自动生成代码
	   {
		s ^TMP("Auto","DHC_PHDiseaseTree","AutoCode")="false"
	  	s ^TMP("Auto","DHC_PHDiseaseTree","CodeLen")=CodeLen
	  	s ^TMP("Auto","DHC_PHDiseaseTree","StartCode")=StartCode
	   }
	   else    //手动输入代码
	   {
	    s ^TMP("Auto","DHC_PHDiseaseTree","AutoCode")="true"
	  	s ^TMP("Auto","DHC_PHDiseaseTree","CodeLen")=""
	  	s ^TMP("Auto","DHC_PHDiseaseTree","StartCode")=""
	   }
   		s result=1
   }
   q result
}

/// 给表单赋值
/// Others:w ##class(web.DHCBL.KB.DHCPHDiseaseTree).ShowAutoCode("AutoCode")
ClassMethod ShowAutoCode(code) As %String
{
 	n (code)
	s result=""
	s result=$g(^TMP("Auto","DHC_PHDiseaseTree",code))
	q result
}

}
