/// 描述: 业务执行表User.MKBBusExecute方法类
/// 编写者：基础数据平台组-石萧伟
/// 编写日期: 2018-03-27
Class web.DHCBL.MKB.MKBBusExecute Extends %RegisteredObject
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

/// Creator：石萧伟
/// CreatDate: 2018-03-27
/// Description：获取上级rowid
/// Input:myRowID数据id
/// return:上级rowid^下级rowid
/// other:w ##class(web.DHCBL.MKB.MKBBusExecute).GetTreeComboId("24")
ClassMethod GetTreeComboId(myRowID As %String) As %String
{
	s str=myRowID
	for
	{
		s myRowID=$LISTGET($G(^User.MKBBusExecuteD(myRowID)),5)
		q:myRowID=""
		s str=myRowID_"^"_str
	}
	q str
}

/// Creator：石萧伟
/// CreatDate: 2018-03-27
/// Description：获取浏览界面树
/// Input:LastLevel上级rowid
/// return:Json格式字符串
/// Other: w ##class(web.DHCBL.MKB.MKBBusExecute).GetNewTreeJson("")
ClassMethod GetNewTreeJson(id As %String) As %String
{
	s myJsonStr=""
	if (id="") s id=-100000000000000
	s myRowID=0
	s myCount=0
	s mySeq=0
	k myArray
	
	//生成菜单索引数组
	s mySeq=0
	s n=0
	for {
		s mySeq=$o(^User.MKBBusExecuteI("ParLevelIndex",id,mySeq))
		q:(mySeq="")
		s n=n+1
		//s a(n)= $p(mySeq," ",2)
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
		for {
			s myRowID=$o(^User.MKBBusExecuteI("ParLevelIndex",id,mySeq,myRowID))
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
		s myObj=##Class(User.MKBBusExecute).%OpenId(myRowID,0)
		if $IsObject(myObj) {
			s MKBBERowId=myRowID
			s MKBBECode = myObj.MKBBECode
			s MKBBEBusExe = myObj.MKBBEBusExe
			s MKBBEBusScene = myObj.MKBBEBusScene
			s MKBBELastLevel = myObj.MKBBELastLevel.MKBBEBusExe
			s MKBBELevel = myObj.MKBBELevel
			s MKBBEActive = myObj.MKBBEActive
			s PINYINDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBBEBusExe)
			s PINYINDesc=$ZCONVERT(PINYINDesc,"L")			
			s MKBBEInterfDr=""
			s:myObj.MKBBEInterfDr'="" MKBBEInterfDr = myObj.MKBBEInterfDr.%Id()
			s MKBINMDesc=""
			s:MKBBEInterfDr'="" MKBINMDesc=$LISTGET($G(^User.MKBInterfaceManageD(MKBBEInterfDr)),3)
			s:(myJsonStr'="") myJsonStr=myJsonStr_","
			s myJsonStr=myJsonStr_"{"
			s myJsonStr=myJsonStr_"""id"":"""_MKBBERowId_""",""MKBBELastLevel"":"""_MKBBELastLevel_""",""MKBBECode"":"""_MKBBECode_""",""MKBBEBusExe"":"""_MKBBEBusExe_""",""MKBBEBusScene"":"""_MKBBEBusScene_""",""MKBBEActive"":"""_MKBBEActive_""",""MKBBELevel"":"""_MKBBELevel_""",""PINYINDesc"":"""_PINYINDesc_""",""MKBINMDesc"":"""_MKBINMDesc_""","
			s myJsonStr=myJsonStr_"""state"":""open"""
				if ($d(^User.MKBBusExecuteI("ParLevelIndex",myRowID))){
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

/// Creator：石萧伟
/// CreatDate: 2018-03-27
/// Input:ParentID上级rowid
/// return:Json格式字符串
/// Description：获取修改时的下拉框
/// Other: w ##class(web.DHCBL.MKB.MKBBusExecute).GetNewTreeComboJson()
ClassMethod GetNewTreeComboJson(ParentID As %String) As %String
{
	if (ParentID="") s ParentID=-100000000000000
	s myJsonStr=""
	s myRowID=0
	s myCount=0
	s mySeq=0
	k myArray
	
	//生成菜单索引数组
	s mySeq=""
	s n=0
	for {
		s mySeq=$o(^User.MKBBusExecuteI("ParLevelIndex",ParentID,mySeq))
		q:(mySeq="")
		s n=n+1
		s a(n)=mySeq
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
			s myRowID=$o(^User.MKBBusExecuteI("ParLevelIndex",ParentID,mySeq,myRowID))
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
		
		s myObj=##Class(User.MKBBusExecute).%OpenId(myRowID,0)
		if $IsObject(myObj) {
			s myCode = myObj.MKBBECode
			s myDesc = myObj.MKBBEBusExe
			s myLastLevel=myObj.MKBBELastLevel
			s myLevel = myObj.MKBBELevel
			s myActiveFlag = myObj.MKBBEActive
			//s PINYINDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE(myDesc)
			//s PINYINDesc=$ZCONVERT(PINYINDesc,"L") 	
			s:(myJsonStr'="") myJsonStr=myJsonStr_","
			s myJsonStr=myJsonStr_"{"
			s myJsonStr=myJsonStr_"""id"":"""_""_myRowID_""",""text"":"""_myDesc_""","
		    s myJsonStr=myJsonStr_"""state"":""open"""
				if ($d(^User.MKBBusExecuteI("ParLevelIndex",myRowID))){
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

/// Creator：石萧伟
/// CreatDate: 2018-03-27
/// Description：获取修改数据
/// Input:id获取数据的rowid
/// return:Json格式字符串
/// Other: w ##class(web.DHCBL.MKB.MKBBusExecute).NewOpenData()
ClassMethod NewOpenData(id As %String) As %String
{
	s str=""	
	s eobj = ##class(web.Entity.MKB.MKBBusExecute).%New()
	s pobj = ##class(User.MKBBusExecute).%OpenId(id)
	s eobj.MKBBERowId = id
	s eobj.MKBBECode = pobj.MKBBECode
	s eobj.MKBBEBusExe = pobj.MKBBEBusExe
	s:pobj.MKBBELastLevel'="" eobj.MKBBELastLevel = pobj.MKBBELastLevel.%Id()
	s eobj.MKBBEBusScene = pobj.MKBBEBusScene
	s eobj.MKBBELevel = pobj.MKBBELevel
	s eobj.MKBBEActive=pobj.MKBBEActive
	s:pobj.MKBBEInterfDr'="" eobj.MKBBEInterfDr = pobj.MKBBEInterfDr.%Id()
	s str = eobj.JsonS()	
	//s str = "{data:["_str_"]}"
	q str
}

/// Function:用于实现数据校验功能的方法
/// Creator:基础数据平台组 高姗姗
/// CreateDate:2014-10-30    
/// w ##class(web.DHCBL.MKB.MKBBusExecute).FormValidate("8","55")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String) As %String
{
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	s flag="",flagc=""
	s:code'="" flagc=$d(^User.MKBBusExecuteI("CodeIndex"," "_code))
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagc>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc="",idd=""
		s:code'="" idc=$o(^User.MKBBusExecuteI("CodeIndex"," "_code,0))
  		if ((idc'="")&(idc'=id)&(flagc>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	q flag
}

/// Creator：高姗姗
/// CreatDate: 2017-5-11
/// Description：保存修改内容
/// Table：User.MKBBusExecute
/// Input：web.Entity.MKB.MKBBusExecute 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: w ##class(web.DHCBL.MKB.MKBBusExecute).SaveData()
ClassMethod SaveData(eobj As web.Entity.MKB.MKBBusExecute) As %String
{
	
	s result = ""
	if $IsObject(eobj)
	{
		s flag=..FormValidate(eobj.MKBBERowId,eobj.MKBBECode)  //调用重复验证
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在'}"
		}
		else
		{
			if (eobj.MKBBERowId="")  //如果RowId未赋值则增加
			{
				s obj=##class(User.MKBBusExecute).%New()
			}
			else  //如果RowId已赋值则修改
			{
				s obj=##class(User.MKBBusExecute).%OpenId(eobj.MKBBERowId)
				s bobj = ##class(web.Entity.MKB.MKBBusExecute).%New()
				s bobj.MKBBERowId = eobj.MKBBERowId
				s bobj.MKBBECode = obj.MKBBECode
				s bobj.MKBBEBusExe = obj.MKBBEBusExe
				s:obj.MKBBELastLevel'="" bobj.MKBBELastLevel = obj.MKBBELastLevel.%Id()
				s bobj.MKBBEBusScene = obj.MKBBEBusScene
				s bobj.MKBBELevel = obj.MKBBELevel
				s bobj.MKBBEActive= obj.MKBBEActive
				s:obj.MKBBEInterfDr'="" bobj.MKBBEInterfDr = obj.MKBBEInterfDr.%Id()
			}
	
			s obj.MKBBECode = eobj.MKBBECode
			s obj.MKBBEBusExe = eobj.MKBBEBusExe
			d:eobj.MKBBELastLevel'="" obj.MKBBELastLevelSetObjectId(eobj.MKBBELastLevel)
			d:eobj.MKBBELastLevel="" obj.MKBBELastLevelSetObjectId("")
			s obj.MKBBEBusScene = eobj.MKBBEBusScene
			s obj.MKBBELevel = eobj.MKBBELevel
			d:eobj.MKBBEInterfDr'="" obj.MKBBEInterfDrSetObjectId(eobj.MKBBEInterfDr)
			d:eobj.MKBBEInterfDr="" obj.MKBBEInterfDrSetObjectId("")
			i eobj.MKBBEActive="Y"
			{
				s obj.MKBBEActive = "Y"
			}
			else
			{
				s obj.MKBBEActive = "N"
			}
		
			Ts
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc){
				Tc
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}" //返回RowId
				d:eobj.MKBBERowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_BusExecute","User.MKBBusExecute","执行业务表",id,eobj.MKBBEBusExe,"A",eobj)
				d:eobj.MKBBERowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_BusExecute","User.MKBBusExecute","执行业务表",eobj.MKBBERowId,eobj.MKBBEBusExe,"U",eobj,bobj)
			}else{
				Trollback
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
				s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("执行业务表","web.DHCBL.MKB.MKBBusExecute","SaveData",eobj)
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

/// Creator:高姗姗
/// CreatDate:2014-10-30
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""

	i ($o(^User.MKBBusExecuteI("ParentIndex",id,""))){
		s myInfo=myInfo_"<业务执行表>"
	}
		
	i myInfo="" s return="0^未被引用可删除!"
 	else  s return="1^在"_myInfo_"表里被引用,不能删除!"
 	q return
}

/// Creator:高姗姗
/// CreatDate:2014-10-30
/// Description:根据id删除
/// Table:User.MKBBusExecute
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.MKB.MKBBusExecute).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	s return="",myInfo=""
	s re=##class(web.DHCBL.MKB.MKBBusExecute).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag'=0){
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}
	else
	{
		Tstart
		s eobj = ##class(web.Entity.MKB.MKBBusExecute).%New()
		s pobj = ##class(User.MKBBusExecute).%OpenId(id)
		s eobj.MKBBERowId = id
		s eobj.MKBBECode = pobj.MKBBECode
		s eobj.MKBBEBusExe = pobj.MKBBEBusExe
		s:pobj.MKBBELastLevel'="" eobj.MKBBELastLevel = pobj.MKBBELastLevel.%Id()
		s eobj.MKBBEBusScene = pobj.MKBBEBusScene
		s eobj.MKBBELevel = pobj.MKBBELevel
		s eobj.MKBBEActive = pobj.MKBBEActive
		s:pobj.MKBBEInterfDr'="" eobj.MKBBEInterfDr = pobj.MKBBEInterfDr.%Id()
	
		s sc=##class(User.MKBBusExecute).%DeleteId(id)
		if $$$ISOK(sc){
			Tcommit
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_BusExecute","User.MKBBusExecute","执行业务表",id,eobj.MKBBEBusExe,"D",eobj)
		}
		else{
			Trollback
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("执行业务表","web.DHCBL.MKB.MKBBusExecute","DeleteData",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	q result
}

/// Description:顺序自动生成  获取顺序最大值
/// w ##class(web.DHCBL.MKB.MKBBusExecute).GetLastSort(13)
ClassMethod GetLastSort(LastLevel) As %String
{
	if (LastLevel="") s LastLevel=-100000000000000
	s LastSort=""
	if ($d(^User.MKBBusExecuteI("ParentIndex",LastLevel))>0){
		s sort=0
	  	for{
		  s sort=$o(^User.MKBBusExecuteI("ParentIndex",LastLevel,sort)) q:sort="" 
		  s LastSort=sort
	  	}
	}else{
		s LastSort="0"
	}
	q LastSort
}

/// 根据id获取描述
/// Other:w ##class(web.DHCBL.MKB.MKBBusExecute).GetDesc("2")
ClassMethod GetDesc(RowId As %String) As %String
{
	;w ##class(web.DHCBL.MKB.MKBBusExecute).GetDesc("25")
	s MKBBEBusExe=""
	if (RowId'=""){
		s MKBBEBusExe=$LISTGET($G(^User.MKBBusExecuteD(RowId)),3)
	}
	q MKBBEBusExe
}

/// 获取上级分类及描述
/// w ##class(web.DHCBL.MKB.MKBBusExecute).GetLastLevel(2)
ClassMethod GetLastLevel(id) As %String
{
	s myLastLevel = $LISTGET($G(^User.MKBBusExecuteD(id)),5)
	s myLastDesc=""
	s:myLastLevel'="" myLastDesc=$LISTGET($G(^User.MKBBusExecuteD(myLastLevel)),3)
	s LastLevel=myLastLevel_"^"_myLastDesc
	q LastLevel
}

// 同级拖拽级别生成

ClassMethod DragNode(id, parentid, orderstr) As %String
{
	s result=""
	s:parentid="TreeRoot" parentid=""
	s obj=##class(User.MKBBusExecute).%OpenId(id)
	d:parentid="" obj.MKBBELastLevelSetObjectId("")
	d:parentid'="" obj.MKBBELastLevelSetObjectId(parentid)

	Ts	
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc){
		Tc
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
		s orderLen=$Length(orderstr,"^")
		for i=1:1:orderLen   
		{      
		   s rowid=$p(orderstr,"^",i)
	       s obj=##class(User.MKBBusExecute).%OpenId(rowid)
		   s obj.MKBBELevel =i
		   s sc=obj.%Save()
		   d obj.%Close()		      
		}
	}else{
		Trollback
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
	}
	q result
}

}
