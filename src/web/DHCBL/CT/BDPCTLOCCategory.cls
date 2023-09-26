/// Creator:基础数据平台组 钟荣枫
/// CreateDate:2019-12-27
/// Desc:科室层级分类维护
Class web.DHCBL.CT.BDPCTLOCCategory Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：钟荣枫
/// CreatDate: 2019-12-27
/// Description：获取修改时的记录
/// Table：User.BDPCTLOCCategory
/// Other: w ##class(web.DHCBL.CT.BDPCTLOCCategory).OpenData("1","")
/// RetFlag=""时，用于EXT, =JSON时，时用于HISUI，不输出 "{list:["_str_"]}"
ClassMethod OpenData(id As %String, RetFlag As %String = "") As %String
{
	n (id,RetFlag)
	s str=""	
	s eobj = ##class(web.Entity.CT.BDPCTLOCCategory).%New()
	
	s pobj = ##class(User.BDPCTLOCCategory).%OpenId(id)
	s eobj.ID = id
	s eobj.Code = pobj.Code
	s eobj.Caption = pobj.Caption
	s:pobj.ParentCatDr'="" eobj.ParentCatDr = pobj.ParentCatDr.%Id()
	s eobj.Sequence = pobj.Sequence
	s eobj.Type = pobj.Type
	s:pobj.ActiveFlag="Y" eobj.ActiveFlag="true"
	
	s str = eobj.JsonS()
	if (RetFlag="JSON")
	{	
		s str = "{data:["_str_"]}"
	}
	q str
}

/// Function:用于实现数据校验功能的方法
/// Creator:基础数据平台组 钟荣枫
/// CreateDate:2019-12-27
/// w ##class(web.DHCBL.CT.BDPCTLOCCategory).FormValidate("41","bb","aa","Area")
/// Return："1"(代码重复),"2"(同级描述重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String, type As %String) As %String
{
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
 	s flag=0
	s flagc=0
	s flagd=0
	s:code'="" flagc=$d(^User.BDPCTLOCCategoryI("UniqueCodeIndex"," "_code))
	s idc=""
	b ;111
	for
	{
		s idc=$o(^User.BDPCTLOCCategoryI("CaptionIdx"," "_desc,idc)) q:idc=""
		s Caption=$LISTGET($G(^User.BDPCTLOCCategoryD(idc)),3)
		s Code=$LISTGET($G(^User.BDPCTLOCCategoryD(idc)),2)
		s Type=$LISTGET($G(^User.BDPCTLOCCategoryD(idc)),4)
		if ((idc'=id)&&($ZCONVERT(Caption,"U")=desc)&&(Type=type))
		{
			
			s flag=2
			q
		}
	}
	if (id="")
	{
	   if (flagc>0) 
	   {
		  s flag=1  //返回重复标志 
	   }
	}
	else	//如果不为空，修改时的重复判断
	{
		s idd=""
	 	s:code'="" idd=$o(^User.BDPCTLOCCategoryI("UniqueCodeIndex"," "_code,0))
	 	if (idd'=id)&(flagc>0) s flag=1  //返回重复标志
	} 
	 q flag
}

/// Creator：钟荣枫
/// CreatDate: 2019-12-27
/// Description：保存修改内容
/// Table：User.BDPCTLOCCategory
/// Input：web.Entity.CT.BDPCTLOCCategory 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Others:	w ##class(web.DHCBL.CT.BDPCTLOCCategory).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.BDPCTLOCCategory) As %String
{
	n (eobj,%session)
	s result = ""
	if $IsObject(eobj)
	{		
		s:eobj.ActiveFlag="" eobj.ActiveFlag="N"
		s flag=..FormValidate(eobj.ID ,eobj.Code,eobj.Caption,eobj.Type)  //调用重复验证
		if (flag'=0)
		{
			if (flag=1)
			{
				s result = "{success:'false',errorinfo:'代码已经存在'}"
			}
			else
			{
				s result = "{success:'false',errorinfo:'同级别下描述已经存在'}"
			}
		}
		else
		{
			if (eobj.ID="")  //如果RowId未赋值则增加
			{
				s obj=##class(User.BDPCTLOCCategory).%New()
			}
			else  //如果RowId已赋值则修改
			{
				s obj=##class(User.BDPCTLOCCategory).%OpenId(eobj.ID)
				s bobj = ##class(web.Entity.CT.BDPCTLOCCategory).%New()
				s bobj.ID = eobj.ID
				s bobj.Code = obj.Code
				s bobj.Caption = obj.Caption
				s bobj.Type = obj.Type
				s:obj.ParentCatDr'="" bobj.ParentCatDr = obj.ParentCatDr.%Id()
				s bobj.Sequence = obj.Sequence
				s bobj.ActiveFlag=  obj.ActiveFlag
			}
	
			s obj.Code = eobj.Code			//代码
			s obj.Caption = eobj.Caption	//名称,中文描述
			d:eobj.ParentCatDr'="" obj.ParentCatDrSetObjectId(eobj.ParentCatDr)		//上级分类
			d:eobj.ParentCatDr="" obj.ParentCatDrSetObjectId("")
			s obj.Sequence = eobj.Sequence		//显示顺序
			s obj.Type = eobj.Type 			//片区/学科/学科分类
			i eobj.ActiveFlag="Y"			//激活状态(Y/N)
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
				d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_CTLOCCategory","User.BDPCTLOCCategory","科室层级分类",id,eobj.Caption,"A",eobj)
				d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_CTLOCCategory","User.BDPCTLOCCategory","科室层级分类",eobj.ID,eobj.Caption,"U",eobj,bobj)
			}
			else{
				Trollback
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
		     	s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("科室层级分类","web.DHCBL.CT.BDPCTLOCCategory","SaveEntity",eobj)
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

/// Other: w ##class(web.DHCBL.CT.BDPCTLOCCategory).SaveText()
ClassMethod SaveText()
{
	s obj=##class(web.Entity.CT.BDPCTLOCCategory).%New()
	s obj.ID=""
	s obj.Code="cs7"
	s obj.Caption="测试7"
	s obj.Type="A"	//片区 Area||A，学科 Subject||S，学科分类Subject Classification||SC
	s obj.ParentCatDr="5" 
	s obj.Sequence="1"
	s obj.ActiveFlag="Y"
	s result= ..SaveEntity(obj)
	q result
}

/// Creator:钟荣枫
/// CreatDate:2019-12-31
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// Other: w ##class(web.DHCBL.CT.BDPCTLOCCategory).GetRefFlag(2)
ClassMethod GetRefFlag(id As %String) As %String
{
	n (id)
	s return="",myInfo=""
	//CT_Loc
	s CTLOCRowID=0
    for  
    {
        s CTLOCRowID=$o(^CTLOC(CTLOCRowID)) q:CTLOCRowID=""
		s CategoryDR=$p($g(^CTLOC(CTLOCRowID)),"^",88)
		if (CategoryDR=id)
		{
			s myInfo=myInfo_"<科室>"
			q
		}
    }
	
	
 	i myInfo="" s return="0^未被引用可删除！"
	else  s return="1^在"_myInfo_"表里被引用,不能删除！"
	q return
}

/// Creator:钟荣枫
/// CreatDate:2019-12-27
/// Description:根据id删除
/// Table:User.BDPCTLOCCategory
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.BDPCTLOCCategory).DeleteData("4")
ClassMethod DeleteData(id As %String) As %String
{
	n (id,%session)
	s result=""
	s re=##class(web.DHCBL.CT.BDPCTLOCCategory).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0){
		
		i ($d(^User.BDPCTLOCCategoryI("ParSeqIdx",id))>0)
	 	{
		 	s result= "{success:'false',info:'该数据下已有子节点,禁止删除'}"
			q result
	 	}
		s eobj = ##class(web.Entity.CT.BDPCTLOCCategory).%New()
		s pobj = ##class(User.BDPCTLOCCategory).%OpenId(id)
		s eobj.ID = id
		s eobj.Code = pobj.Code
		s eobj.Caption = pobj.Caption
		s:pobj.ParentCatDr'="" eobj.ParentCatDr = pobj.ParentCatDr.%Id()
		s eobj.Sequence = pobj.Sequence
		s eobj.Type = pobj.Type
		s eobj.ActiveFlag = pobj.ActiveFlag
		Tstart
		s sc=##class(User.BDPCTLOCCategory).%DeleteId(id)
		if $$$ISOK(sc){
			Tcommit
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_CTLOCCategory","User.BDPCTLOCCategory","科室层级分类",id,eobj.Caption,"D",eobj)
		}
		else{
			Trollback
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		    s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("科室层级分类","web.DHCBL.CT.BDPCTLOCCategory","DeleteData",eobj)
		    s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}else{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"	
	}
	q result
}

/// Creator:钟荣枫
/// CreatDate:2019-12-27
/// Description：保存拖拽的内容 
/// Table：User.BDPCTLOCCategory
/// Input：id, parentid,orderstr
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: w ##class(web.DHCBL.CT.BDPCTLOCCategory).DragNode("9","5","9^5")
ClassMethod DragNode(id, parentid, orderstr) As %String
{
	n (id,parentid,orderstr)
	s result=""
	q:(id="") "{success:'false',errorinfo:'没有拖拽的节点'}"
	//q:(parentid="") "{success:'false',errorinfo:'没有拖拽到准确的节点下'}"
	s:parentid="TreeRoot" parentid=""
	
	s obj=##class(User.BDPCTLOCCategory).%OpenId(id)	
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
			s obj=##class(User.BDPCTLOCCategory).%OpenId(rowid)
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

/// Creator:钟荣枫
/// CreatDate:2019-12-27
/// Description：查询页面数据
/// Table：User.BDPCTLOCCategory
/// Input：父节点 
/// Return：treegrid格式数据串
/// w ##class(web.DHCBL.CT.BDPCTLOCCategory).GetJsonList("1")
ClassMethod GetJsonList(id As %String) As %String
{
	n (id)
	s parentcatdr=id
	if (parentcatdr="") s parentcatdr=-100000000000000
	s myJsonStr=""
	k myArray
	//生成索引数组
	
	s mySeq=0
	s n=0
	s outflag=0
	for {
		s mySeq=$o(^User.BDPCTLOCCategoryI("ParSeqIdx",parentcatdr,mySeq))
		q:outflag=1
		if (mySeq="") 
		{
			s flag=$d(^User.BDPCTLOCCategoryI("ParSeqIdx",parentcatdr,-100000000000000))
			if (flag>0)
			{
				s mySeq=-100000000000000
			}
			else
			{
				s outflag=1
				q
			}
		}
		s rowid=0
		for 
		{
			s rowid=$o(^User.BDPCTLOCCategoryI("ParSeqIdx",parentcatdr,mySeq,rowid)) q:rowid=""
			for i=1:1:n
			{
				if (myArray(i)=rowid)
				{
					s outflag=1
					q	
				}	
			}
			q:outflag=1
			s n=n+1
			s myArray(n)=rowid
		}
	}
	//输出菜单JSON串
	s myRowID=0
	s myCount=0
	s childStr=""
	s myJsonStr=myJsonStr_"["
	s count=0
	for 
	{
		s myCount=$o(myArray(myCount)) q:(myCount="")
		s myRowID=$g(myArray(myCount))
		s count=count+1
		s Caption=$LISTGET($G(^User.BDPCTLOCCategoryD(myRowID)),3)
		s Caption=$tr(Caption,"""","")
		if count>1 s myJsonStr=myJsonStr_","
		s Code=$LISTGET($G(^User.BDPCTLOCCategoryD(myRowID)),2)
		s Type=$LISTGET($G(^User.BDPCTLOCCategoryD(myRowID)),4)
		
		s ParentCatDr=$LISTGET($G(^User.BDPCTLOCCategoryD(myRowID)),5)
		s ActiveFlag=$LISTGET($G(^User.BDPCTLOCCategoryD(myRowID)),6)
		s Sequence=$LISTGET($G(^User.BDPCTLOCCategoryD(myRowID)),7)
		
		if ParentCatDr'="" s ParentCatDr=$LISTGET($G(^User.BDPCTLOCCategoryD(ParentCatDr)),3)
		s myJsonStr=myJsonStr_"{""id"":"""_myRowID_""""
		s myJsonStr=myJsonStr_",""ID"":"""_myRowID_""",""Code"":"""_Code_""",""Caption"":"""_Caption_""",""Type"":"""_Type_""",""ActiveFlag"":"""_ActiveFlag_""",""ParentCatDr"":"""_ParentCatDr_""",""Sequence"":"""_Sequence_""""
		
		s myChildFlag=$d(^User.BDPCTLOCCategoryI("ParCatIdx",myRowID))
        if (myChildFlag) s myChildFlag=1     //有子菜单不是叶子节点
	    else  s myChildFlag=0
		if (+myChildFlag'=0)
		{
			//一次性加载   
			s myJsonStr=myJsonStr_",""state"":""open"""   //closed节点不展开,open节点展开
			s myJsonStr=myJsonStr_",""children"":"
			s myJsonStr=myJsonStr_..GetJsonList(myRowID)
		}
		else
		{
			s myJsonStr=myJsonStr_",""state"":""open"""
		}
		s myJsonStr=myJsonStr_"}"
		
	}

	s myJsonStr=myJsonStr_"]"
	s myJsonStr=myJsonStr_""
	q myJsonStr
}

/// Creator:钟荣枫
/// CreatDate:2019-12-27
/// Description：查询页面数据
/// Table：User.BDPCTLOCCategory
/// Input：父节点 
/// Return：treegrid格式数据串
/// w ##class(web.DHCBL.CT.BDPCTLOCCategory).GetJsonDataForCmb("CatTreeRoot")
ClassMethod GetJsonDataForCmb(id As %String) As %String
{
	
	n (id)
	s IDStr=""
	s parentcatdr=id
	if (parentcatdr="") s parentcatdr=-100000000000000
	if (parentcatdr="CatTreeRoot") s parentcatdr=-100000000000000
	
	s myJsonStr=""
	
	s mySeq=0
	s n=0
	s outflag=0
	for {
		s mySeq=$o(^User.BDPCTLOCCategoryI("ParSeqIdx",parentcatdr,mySeq))
		q:outflag=1
		if (mySeq="") 
		{
			s flag=$d(^User.BDPCTLOCCategoryI("ParSeqIdx",parentcatdr,-100000000000000))
			if (flag>0)
			{
				s mySeq=-100000000000000
			}
			else
			{
				s outflag=1
				q
			}
		}
		s rowid=0
		for 
		{
			s rowid=$o(^User.BDPCTLOCCategoryI("ParSeqIdx",parentcatdr,mySeq,rowid)) q:rowid=""
			for i=1:1:n
			{
				if (myArray(i)=rowid)
				{
					s outflag=1
					q	
				}	
			}
			q:outflag=1
			s n=n+1
			s myArray(n)=rowid
		}
	}
	//输出菜单JSON串
	s myRowID=0
	s myCount=0
	s childStr=""
	w "["
	s count=0
	for {
		s myCount=$o(myArray(myCount)) q:(myCount="")
		s myRowID=$g(myArray(myCount))
		s count=count+1
		s Caption=$LISTGET($G(^User.BDPCTLOCCategoryD(myRowID)),3)
		s Caption=$tr(Caption,"""","")
		if count>1 w ","
		w "{""id"":"""_myRowID_""",""text"":"""_Caption_""""
		w ",""state"":""open"""
		w ",""attributes"":{""SPCode"":"""_##class(web.DHCBL.BDP.FunLib).GetPYCODE(Caption)_"""}"
		s myChildFlag=$d(^User.BDPCTLOCCategoryI("ParCatIdx",myRowID))
        if (myChildFlag) s myChildFlag=1     //有子菜单不是叶子节点
	    else  s myChildFlag=0
		if (+myChildFlag'=0)
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

/// Creator:钟荣枫
/// CreatDate:2019-12-27
/// Description：获取某个父节点下的所有子节点 用^连接，并按照顺序排列  
/// Table：User.BDPCTLOCCategory
/// Input：父节点
/// Return：所有子节点 用^连接
/// w ##class(web.DHCBL.CT.BDPCTLOCCategory).GetChildOrderedIDStr("")
ClassMethod GetChildOrderedIDStr(parentcatdr As %String) As %String
{
	n (parentcatdr)
	s IDStr=""
	if (parentcatdr="") s parentcatdr=-100000000000000
	if (parentcatdr="TreeRoot") s parentcatdr=-100000000000000
	
	s myJsonStr=""
	
	k myArray
	s mySeq=0
	s n=0
	s outflag=0
	for {
		s mySeq=$o(^User.BDPCTLOCCategoryI("ParSeqIdx",parentcatdr,mySeq))
		q:outflag=1
		if (mySeq="") 
		{
			s flag=$d(^User.BDPCTLOCCategoryI("ParSeqIdx",parentcatdr,-100000000000000))
			if (flag>0)
			{
				s mySeq=-100000000000000
			}
			else
			{
				s outflag=1
				q
			}
		}
		s rowid=0
		for 
		{
			s rowid=$o(^User.BDPCTLOCCategoryI("ParSeqIdx",parentcatdr,mySeq,rowid)) q:rowid=""
			for i=1:1:n
			{
				if (myArray(i)=rowid)
				{
					s outflag=1
					q	
				}	
			}
			q:outflag=1
			s n=n+1
			s myArray(n)=rowid
		}
	}
	//输出菜单JSON串
	s myRowID=0
	s myCount=0
	s childStr=""
	for {
		s myCount=$o(myArray(myCount)) q:(myCount="")
		s myRowID=$g(myArray(myCount))
		
		s childStr=..GetChildOrderedIDStr(myRowID)
		if childStr'="" s childStr=myRowID_"^"_childStr
		if childStr="" s childStr=myRowID
		
		if IDStr="" s IDStr=childStr
		else  s IDStr=IDStr_"^"_childStr
	}
	q IDStr
}

/// Creator:钟荣枫
/// CreatDate:2019-12-27
/// Description：添加时获取显示顺序  
/// Table：User.BDPCTLOCCategory
/// Input：父菜单id
/// Return：顺序号
/// w ##class(web.DHCBL.CT.BDPCTLOCCategory).GetSequence("1")
ClassMethod GetSequence(id As %String) As %String
{
	n (id)
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
  s mySMSeq=$o(^User.BDPCTLOCCategoryI("ParSeqIdx",id,mySMSeq))
  q:(mySMSeq="")
  s n=n+1
  s a(n)= mySMSeq
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

}
