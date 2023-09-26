/// Creator:基础数据平台组 谷雪萍
/// CreateDate:2016-04-25
/// Desc:基础数据平台   收费项目分类
Class web.DHCBL.CT.BDPItemCategory Extends %RegisteredObject [ Not ProcedureBlock ]
{

Parameter SQLTableName = "BDP_ItemCategory";

/// w ##class(web.DHCBL.CT.BDPItemCategory).GetTreeJson("")
ClassMethod GetTreeJson(LastLevel As %String, nodeStr As %String, hospid As %String = "") As %String
{
	n (LastLevel,nodeStr,hospid)
	if (LastLevel="TreeRoot") s LastLevel=-100000000000000
	if (LastLevel="") s LastLevel=-100000000000000
	
	//if (Type="") s Type="ItemCat"
	s myJsonStr=""
	s myRowID=0
	s myCount=0
	s mySeq=0
	k myArray
	k a
	//生成菜单索引数组
	s mySeq=0
	s n=0
	for {
		s mySeq=$o(^User.BDPItemCategoryI("ParSeqIdx",LastLevel,mySeq))
		q:(mySeq="")
		s n=n+1
		s a(n)= $p(mySeq," ",2)
	}
	set left=1,right=n
	d:$d(a) ##class(web.DHCBL.BDP.FunLib).QuickSort(.a,left,right) //排序
	
	s n=0
	s mySeq=0
	for {
		s n=$o(a(n))
		q:(n="")
		s mySeq=$g(a(n))
		s myRowID=0
		for {
			s myRowID=$o(^User.BDPItemCategoryI("ParSeqIdx",LastLevel," "_mySeq,myRowID))
			q:(myRowID="")
			s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,myRowID,hospid)
			continue:showflag="N"
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
		
		s myObj=##Class(User.BDPItemCategory).%OpenId(myRowID,0)
		if $IsObject(myObj) {
			s myCode = myObj.Code
			s myDesc = myObj.Caption		
			s myActiveFlag = myObj.ActiveFlag
			s myType = myObj.Type
			s nodeId="<"_myRowID_">"
			
			//if (myType=Type){
			
				s:(myJsonStr'="") myJsonStr=myJsonStr_","
				s myJsonStr=myJsonStr_"{"
				s myJsonStr=myJsonStr_"""id"":"""_""_myRowID_""",""text"":"""_myDesc_""","
			//	s myJsonStr=myJsonStr_"""iconCls"":"""_""_myImage_""","

				s myJsonStr=myJsonStr_"""leaf"":false,"
				if (nodeStr[nodeId){
					s myJsonStr=myJsonStr_"""expanded"":false"
				}
				else{
					s myJsonStr=myJsonStr_"""expanded"":true"
				}

				s myJsonStr=myJsonStr_"}"
			//}
			d myObj.%Close()
		}
	}
	k myArray

	s myJsonStr="["_myJsonStr_"]"
	
	q myJsonStr
}

/// w ##class(web.DHCBL.CT.BDPItemCategory).GetTreeComboId("24")
/// w ##class(web.DHCBL.CT.BDPItemCategory).GetTreeComboJson("CatTreeRoot")
ClassMethod GetTreeComboJson(ParentID As %String, Type As %String, hospid As %String = "") As %String
{
	n (ParentID,Type,hospid)
	if (ParentID="CatTreeRoot") s ParentID=-100000000000000
	//if (Type="") s Type="ItemCat"
	s myJsonStr=""
	s myRowID=0
	s myCount=0
	s mySeq=0
	k myArray
	k a
	//生成菜单索引数组
	s mySeq=0
	s n=0
	for {
		s mySeq=$o(^User.BDPItemCategoryI("ParSeqIdx",ParentID,mySeq))
		q:(mySeq="")
		s n=n+1
		s a(n)= $p(mySeq," ",2)
	}
	set left=1,right=n
	d:$d(a) ##class(web.DHCBL.BDP.FunLib).QuickSort(.a,left,right) //排序
	
	s n=0
	s mySeq=0
	for {
		s n=$o(a(n))
		q:(n="")
		s mySeq=$g(a(n))
		s myRowID=0
		for {
			s myRowID=$o(^User.BDPItemCategoryI("ParSeqIdx",ParentID," "_mySeq,myRowID))
			q:(myRowID="")
			s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,myRowID,hospid)
			continue:showflag="N"
			s myCount=myCount+1
			s myArray(myCount)=myRowID
			;w !,myRowID
		}
	}
	//获取父类id
	/*if (nodeid'=""){
		s str=##class(web.DHCBL.CT.BDPItemCategory).GetTreeComboId(nodeid)
		s strLen=$Length(str,"^")			
		for i=1:1:strLen
		{
			s rowid = $p(str,"^",i)
			s arr(rowid)=i
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
		
		s myObj=##Class(User.BDPItemCategory).%OpenId(myRowID,0)
		if $IsObject(myObj) {
			s myCode = myObj.Code
			s myDesc = myObj.Caption
			s myType=myObj.Type
			s myLastLevel=myObj.ParentCatDr
			s myLevel = myObj.Sequence
			s myActiveFlag = myObj.ActiveFlag
			if myActiveFlag="Y"
			{
				//if (myType=Type){
	
					s:(myJsonStr'="") myJsonStr=myJsonStr_","
					s myJsonStr=myJsonStr_"{"
					s myJsonStr=myJsonStr_"""id"":"""_""_myRowID_""",""text"":"""_myDesc_""","
				//	s myJsonStr=myJsonStr_"""iconCls"":"""_""_myImage_""","

					s myJsonStr=myJsonStr_"""leaf"":false,"
					/*if (nodeid'=""){
						if ($d(arr(myRowID))){ 
							s myJsonStr=myJsonStr_"""expanded"":true"
						}
						else{
							s myJsonStr=myJsonStr_"""expanded"":false"	
						}
					}
					else{*/
						s myJsonStr=myJsonStr_"""expanded"":false"	
					//}
					s myJsonStr=myJsonStr_"}"
				//}
			}
			d myObj.%Close()
		}
	}
	k myArray

	s myJsonStr="["_myJsonStr_"]"
	
	q myJsonStr
}

/// Function:用于实现数据校验功能的方法
/// Creator:基础数据平台组 谷雪萍
/// CreateDate:2016-4-25
/// w ##class(web.DHCBL.CT.BDPItemCategory).FormValidate("","","")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, hospid As %String = "") As %String
{
	n (id,code,hospid)
 	s flag=0
	if code'=""
	{
		s idc=0
		for
		{
			s idc=$o(^User.BDPItemCategoryI("UniqueCodeIndex"," "_$zcvt(code,"U"),idc)) q:idc=""
			if (idc'=id)
			{
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,idc,hospid)
				continue:showflag="N"
				s flag=1
			}
		}
	}
	q flag
}

/// Creator：谷雪萍
/// CreatDate: 2016-4-25
/// Description：保存修改内容
/// Table：User.BDPItemCategory
/// Input：web.Entity.CT.BDPItemCategory 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.Entity.CT.BDPItemCategory) As %String
{
	s result = ""
	if $IsObject(eobj)
	{		
		IF eobj.Type="" s eobj.Type="ItemCat"
		s flag=..FormValidate(eobj.ID ,eobj.Code,eobj.LinkHospId)  //调用重复验证
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在'}"
		}
		else
		{
			if (eobj.ID="")  //如果RowId未赋值则增加
			{
				s obj=##class(User.BDPItemCategory).%New()
			}
			else  //如果RowId已赋值则修改
			{
				s obj=##class(User.BDPItemCategory).%OpenId(eobj.ID)
				s bobj = ##class(web.Entity.CT.BDPItemCategory).%New()
				s bobj.ID = eobj.ID
				s bobj.Code = obj.Code
				s bobj.Caption = obj.Caption
				s:obj.ParentCatDr'="" bobj.ParentCatDr = obj.ParentCatDr.%Id()
				s bobj.Sequence = obj.Sequence
				s bobj.Type = obj.Type
				s bobj.ActiveFlag=  obj.ActiveFlag
			}
	
			s obj.Code = eobj.Code
			s obj.Caption = eobj.Caption
			//s obj.ParentCatDr = eobj.ParentCatDr
			d:eobj.ParentCatDr'="" obj.ParentCatDrSetObjectId(eobj.ParentCatDr)
			d:eobj.ParentCatDr="" obj.ParentCatDrSetObjectId("")
			s obj.Sequence = eobj.Sequence
			s obj.Type = eobj.Type 
			i eobj.ActiveFlag="Y"
			{
				s obj.ActiveFlag = "Y"
			}
			else
			{
				s obj.ActiveFlag = "N"
			}

			Ts
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc){
				Tc
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}" //返回RowId
				d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_ItemCategory","User.BDPItemCategory","收费项目分类",id,eobj.Caption,"A",eobj)
				d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_ItemCategory","User.BDPItemCategory","收费项目分类",eobj.ID,eobj.Caption,"U",eobj,bobj)
			}
			else{
				Trollback
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
		     	s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("收费项目分类","web.DHCBL.CT.BDPItemCategory","SaveEntity",eobj)
		    	s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
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
/// CreatDate: 2016-4-25
/// Description：获取修改时的记录
/// Table：User.BDPItemCategory
/// Other: d ##class(web.DHCBL.CT.BDPItemCategory).OpenData()
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s eobj = ##class(web.Entity.CT.BDPItemCategory).%New()
	
	s pobj = ##class(User.BDPItemCategory).%OpenId(id)
	s eobj.ID = id
	s eobj.Code = pobj.Code
	s eobj.Caption = pobj.Caption
	s:pobj.ParentCatDr'="" eobj.ParentCatDr = pobj.ParentCatDr.%Id()
	s eobj.Sequence = pobj.Sequence
	s eobj.Type = pobj.Type
	s:pobj.ActiveFlag="Y" eobj.ActiveFlag="true"
	
	s str = eobj.JsonS()	
	s str = "{data:["_str_"]}"
	q str
}

/// 删除时验证数据是否被引用
ClassMethod GetRefFlag(id As %String) As %String
{
	n (id)
	s return="",myInfo=""
	//1 是否被"收费项目"引用
	i ($d(^DHCTARI(0,"SIC",id)))  s myInfo=myInfo_"<收费项目>"
 	i myInfo="" s return="0^未被引用可删除!"
 	
 	i ($d(^User.BDPItemCategoryI("ParSeqIdx",id)))  s myInfo=myInfo_"<收费项目分类>"
 	i myInfo="" s return="0^未被引用可删除!"
 	
 	
 	else  s return="1^在"_myInfo_"表里被引用,不能删除!"
	q return
}

/// Creator:谷雪萍
/// CreatDate:2016-4-25
/// Description:根据id删除
/// Table:User.BDPItemCategory
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.CT.BDPItemCategory).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	//验证是否被引用
	i ($d(^DHCTARI(0,"SIC",id)))
	{
		s result= "{success:'false',info:'在"_"<收费项目>"_"表里被引用,不能删除'}"
		q result
	}
	
 	i ($d(^User.BDPItemCategoryI("ParSeqIdx",id)))
 	{
	 	s result= "{success:'false',info:'该数据下已有子节点,禁止删除'}"
		q result
 	}
	 
	 s eobj = ##class(web.Entity.CT.BDPItemCategory).%New()
	s pobj = ##class(User.BDPItemCategory).%OpenId(id)
	s eobj.ID = id
	s eobj.Code = pobj.Code
	s eobj.Caption = pobj.Caption
	s:pobj.ParentCatDr'="" eobj.ParentCatDr = pobj.ParentCatDr.%Id()
	s eobj.Sequence = pobj.Sequence
	s eobj.Type = pobj.Type
	s eobj.ActiveFlag = pobj.ActiveFlag
	Tstart
	s sc=##class(User.BDPItemCategory).%DeleteId(id)
	if $$$ISOK(sc){
		Tcommit
		s result="{success:'true',info:'删除成功！'}"
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_ItemCategory","User.BDPItemCategory","收费项目分类",id,eobj.Caption,"D",eobj)
	}
	else{
		Trollback
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	    s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("收费项目分类","web.DHCBL.CT.BDPItemCategory","DeleteData",eobj)
	    s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	
	q result
}

/// Description：保存拖拽的内容 2016/9/21
/// Table：User.DHCSymptomLev
/// Input：id, parentid,orderstr
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: w ##class(web.DHCBL.CT.BDPItemCategory).DragNode()
ClassMethod DragNode(id, parentid, orderstr) As %String
{
	s result=""
	q:(id="") "{success:'false',errorinfo:'没有拖拽的节点'}"
	//q:(parentid="") "{success:'false',errorinfo:'没有拖拽到准确的节点下'}"
	s:parentid="TreeRoot" parentid=""
	
	s obj=##class(User.BDPItemCategory).%OpenId(id)	
	d:parentid="" obj.ParentCatDrSetObjectId("")
	d:parentid'="" obj.ParentCatDrSetObjectId(parentid)

	Ts	
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{
		Tc
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
	
		s orderLen=$Length(orderstr,"^")
		for i=1:1:orderLen   
		{      
			s rowid=$p(orderstr,"^",i)
			s obj=##class(User.BDPItemCategory).%OpenId(rowid)
			s obj.Sequence =i
			s sc=obj.%Save()
			d obj.%Close()		      
		}
	}
	else
	{
		Trollback
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
	}
	q result
}

/// Creator：陈莹
/// CreatDate: 2018-03-13
/// Description：添加时获取显示顺序
/// Input：父菜单id
/// Return：顺序号
/// w ##class(web.DHCBL.CT.BDPItemCategory).GetSequence("1")
ClassMethod GetSequence(id As %String) As %String
{
 if (id="TreeRoot") s id=-100000000000000
 if (id="") s id=-100000000000000
 s mySMRowID=0
 s myLineCount=0
 s mySMSeq=0
 k myLineArray
 k a
 //生成菜单索引数组
 s mySMSeq=0
 s n=0
 for {
  s mySMSeq=$o(^User.BDPItemCategoryI("ParSeqIdx",id,mySMSeq))
  q:(mySMSeq="")
  s n=n+1
  s a(n)= $p(mySMSeq," ",2)
 }
 set left=1,right=n
 d:$d(a) ##class(web.DHCBL.BDP.FunLib).QuickSort(.a,left,right) //排序
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

/// Creator：陈莹
/// CreatDate: 2018-03-13
/// Description：获取某个父节点下的所有子节点 用^连接，并按照顺序排列  
/// Table：User.BDPItemCategory
/// Input：父节点
/// Return：所有子节点 用^连接
/// w ##class(web.DHCBL.CT.BDPItemCategory).GetChildOrderedIDStr("")
ClassMethod GetChildOrderedIDStr(LastLevel As %String) As %String
{
	n (LastLevel)
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
		s mySeq=$o(^User.BDPItemCategoryI("ParSeqIdx",LastLevel,mySeq)) q:(mySeq="")
		s n=n+1
		s a(n)= $p(mySeq," ",2)
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
			s myRowID=$o(^User.BDPItemCategoryI("ParSeqIdx",LastLevel," "_mySeq,myRowID)) q:(myRowID="")
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
		
		s childStr=..GetChildOrderedIDStr(myRowID)
		if childStr'="" s childStr=myRowID_"^"_childStr
		if childStr="" s childStr=myRowID
		
		if IDStr="" s IDStr=childStr
		else  s IDStr=IDStr_"^"_childStr
	}
	q IDStr
}

/// Creator：陈莹
/// CreatDate: 2018-03-13
/// Description：查询页面数据
/// Table：User.BDPItemCategory
/// Input：父节点 
/// Return：treegrid格式数据串
/// w ##class(web.DHCBL.CT.BDPItemCategory).GetJsonList("","")
ClassMethod GetJsonList(id As %String) As %String
{
	n (id)
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
		s mySeq=$o(^User.BDPItemCategoryI("ParSeqIdx",parentcatdr,mySeq)) q:(mySeq="")
		s n=n+1
		s a(n)= $p(mySeq," ",2)
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
			s myRowID=$o(^User.BDPItemCategoryI("ParSeqIdx",parentcatdr," "_mySeq,myRowID)) q:(myRowID="")
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
		//continue:$LISTGET($G(^User.BDPItemCategoryD(myRowID)),6)'="Y"
		s count=count+1
		s Caption=$LISTGET($G(^User.BDPItemCategoryD(myRowID)),3)
		s Caption=$tr(Caption,"""","")
		if count>1 w ","
		s Code=$LISTGET($G(^User.BDPItemCategoryD(myRowID)),2)
		s ActiveFlag=$LISTGET($G(^User.BDPItemCategoryD(myRowID)),6)
		s Sequence=$LISTGET($G(^User.BDPItemCategoryD(myRowID)),7)
		s ParentCatDr=$LISTGET($G(^User.BDPItemCategoryD(myRowID)),5)
		if ParentCatDr'="" s ParentCatDr=$LISTGET($G(^User.BDPItemCategoryD(ParentCatDr)),3)
		w "{""id"":"""_myRowID_""""
		w ",""ID"":"""_myRowID_""",""Code"":"""_Code_""",""Caption"":"""_Caption_""",""ActiveFlag"":"""_ActiveFlag_""",""ParentCatDr"":"""_ParentCatDr_""",""Sequence"":"""_Sequence_""""
		s childStr=..GetChildOrderedIDStr(myRowID)
		if childStr'=""
		{
			//一次性加载   
			w ",""state"":""open"""   //closed节点不展开,open节点展开
			w ",""children"":"
			w ..GetJsonList(myRowID)
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

/// Creator：陈莹
/// CreatDate: 2018-03-13
/// Description：查询页面数据
/// Table：User.BDPItemCategory
/// Input：父节点 
/// Return：treegrid格式数据串
/// w ##class(web.DHCBL.CT.BDPItemCategory).GetJsonDataForCmb("")
ClassMethod GetJsonDataForCmb(id As %String) As %String
{
	
	n (id)
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
		s mySeq=$o(^User.BDPItemCategoryI("ParSeqIdx",parentcatdr,mySeq)) q:(mySeq="")
		s n=n+1
		s a(n)= $p(mySeq," ",2)
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
			s myRowID=$o(^User.BDPItemCategoryI("ParSeqIdx",parentcatdr," "_mySeq,myRowID)) q:(myRowID="")
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
		s Caption=$LISTGET($G(^User.BDPItemCategoryD(myRowID)),3)
		s Caption=$tr(Caption,"""","")
		if count>1 w ","
		w "{""id"":"""_myRowID_""",""text"":"""_Caption_""""
		w ",""state"":""open"""
		w ",""attributes"":{""SPCode"":"""_##class(web.DHCBL.BDP.FunLib).GetPYCODE(Caption)_"""}"
		s childStr=..GetChildOrderedIDStr(myRowID)
		if childStr'=""
		{
			w ",""state"":""open"""
			w ",""children"":"
			w ..GetJsonDataForCmb(myRowID)	
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

/// Creator：陈莹
/// CreatDate: 2018-03-13
/// Description：获取修改时的记录
/// Other: w ##class(web.DHCBL.CT.BDPItemCategory).OpenDataJSON()
ClassMethod OpenDataJSON(id As %String) As %String
{
	s str=""	
	s eobj = ##class(web.Entity.CT.BDPItemCategory).%New()
	
	s pobj = ##class(User.BDPItemCategory).%OpenId(id)
	s eobj.ID = id
	s eobj.Code = pobj.Code
	s eobj.Caption = pobj.Caption
	s:pobj.ParentCatDr'="" eobj.ParentCatDr = pobj.ParentCatDr.%Id()
	s eobj.Sequence = pobj.Sequence
	s eobj.Type = pobj.Type
	
	s eobj.ActiveFlag = pobj.ActiveFlag
	//s:pobj.ActiveFlag="Y" eobj.ActiveFlag="true"
	
	s str = eobj.JsonS()	
	//s str = "{data:["_str_"]}"
	q str
}

}
