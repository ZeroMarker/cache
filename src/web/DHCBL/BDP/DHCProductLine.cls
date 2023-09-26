Import SQLUser

/// 描述: 东华产品线维护
/// 编写者：谷雪萍
/// 编写日期: 2015-10-15
Class web.DHCBL.BDP.DHCProductLine Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：谷雪萍
/// CreatDate: 2015-10-15
/// Description：修改时打开的数据
/// Table：User.DHCProductLine
/// Input：id
ClassMethod OpenData(id As %String) As %String
{
 s str="" 
 s eobj = ##class(web.Entity.BDP.DHCProductLine).%New()
 s eobj.ID = id
 s eobj.Code=$LISTGET($G(^User.DHCProductLineD(id)),2)
 s eobj.Caption=$LISTGET($G(^User.DHCProductLineD(id)),3)
 s eobj.ParentDr=$LISTGET($G(^User.DHCProductLineD(id)),4)
 s eobj.Shorthand=$LISTGET($G(^User.DHCProductLineD(id)),5)
 s eobj.Type=$LISTGET($G(^User.DHCProductLineD(id)),6)
 s eobj.Offer=$LISTGET($G(^User.DHCProductLineD(id)),7)
 s eobj.ProManMonth=$LISTGET($G(^User.DHCProductLineD(id)),8)
 s eobj.ImpManMonth=$LISTGET($G(^User.DHCProductLineD(id)),9)
 s eobj.ManMonth=$LISTGET($G(^User.DHCProductLineD(id)),10)
 s eobj.InQuotation=$LISTGET($G(^User.DHCProductLineD(id)),11)
 s eobj.OutQuotation=$LISTGET($G(^User.DHCProductLineD(id)),12)
 s eobj.ProDesc=$LISTGET($G(^User.DHCProductLineD(id)),13)
 s eobj.StandaloneFlag=$LISTGET($G(^User.DHCProductLineD(id)),14)
 s eobj.SalesFlag=$LISTGET($G(^User.DHCProductLineD(id)),15)
 s eobj.ActiveFlag=$LISTGET($G(^User.DHCProductLineD(id)),16)
 s eobj.Sequence=$LISTGET($G(^User.DHCProductLineD(id)),17)
 s:eobj.StandaloneFlag="Y" eobj.StandaloneFlag="true"
 s:eobj.SalesFlag="Y" eobj.SalesFlag="true"
 s:eobj.ActiveFlag="Y" eobj.ActiveFlag="true"
 
 s str = eobj.JsonS() 
 d eobj.%Close()
 s str = "{list:["_str_"]}"
 q str
}

/// Description：数据重复验证方法，由js调用
/// Table：User.DHCProductLine
/// Input：id, code
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod Validate(id As %String, code As %String) As %String
{
 s:code'="" code=" "_$ZCONVERT(code,"U") //转换成大写
 s flag="",flagc=""
 s:code'="" flagc=$d(^User.DHCProductLineI("CodeIndex",code))
 if (id="") //如果为空，增加时的重复判断
 {
  if (flagc>0) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 else //如果不为空，修改时的重复判断
 {
  s idc=""
  s:code'="" idc=$o(^User.DHCProductLineI("CodeIndex",code,0))
  if (idc'=id)&(flagc>0) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 q flag
}

/// Description：保存修改
/// Table：User.DHCProductLine
/// Input：web.Entity.BDP.DHCProductLine 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.BDP.DHCProductLine).SaveData()
ClassMethod SaveData(eobj As web.Entity.BDP.DHCProductLine) As %String
{
 
 s result="",flag=""
 if $IsObject(eobj)
 {	
  s flag=..Validate(eobj.ID,eobj.Code)  //调用重复验证
  if (flag=1)
  {	  
  	 s result = "{success:'false',errorinfo:'该记录已经存在！'}"
  }
  else
  {
	   s:eobj.Sequence'="" eobj.Sequence=$ZCONVERT(eobj.Sequence,"U") 
	   if (eobj.ID="")  //如果RowId未赋值则增加
	   {
	    	s obj=##class(User.DHCProductLine).%New()
	   }
	   else                     //如果RowId已赋值则修改
	   {
		    s obj=##class(User.DHCProductLine).%OpenId(eobj.ID)
		    s bobj=##class(web.Entity.BDP.DHCProductLine).%New()
		    s bobj.ID=eobj.ID
		    s bobj.Code = obj.Code           
		    s bobj.Caption = obj.Caption          
		    s:obj.ParentDr'="" bobj.ParentDr=obj.ParentDr.%Id()
		    s bobj.Shorthand =  obj.Shorthand
		    s bobj.Type = obj.Type
		    s bobj.Offer = obj.Offer
		    s bobj.ProManMonth = obj.ProManMonth
		    s bobj.ImpManMonth = obj.ImpManMonth
		    s bobj.ManMonth = obj.ManMonth
		    s bobj.InQuotation = obj.InQuotation
		    s bobj.OutQuotation=obj.OutQuotation
			s bobj.ProDesc=obj.ProDesc
			s bobj.StandaloneFlag=obj.StandaloneFlag
			s bobj.SalesFlag=obj.SalesFlag
			s bobj.ActiveFlag=obj.ActiveFlag
			s bobj.Sequence=obj.Sequence
	   }
	    Ts
	   	s obj.Code = eobj.Code          //修改代码
	   	s obj.Caption = eobj.Caption          //修改描述
	   	d obj.ParentDrSetObjectId(eobj.ParentDr)
	    s obj.Shorthand =  eobj.Shorthand
	    s obj.Type = eobj.Type
	    s obj.Offer = eobj.Offer
	    s obj.ProManMonth = eobj.ProManMonth
	    s obj.ImpManMonth = eobj.ImpManMonth
	    s obj.ManMonth = eobj.ManMonth
	    s obj.InQuotation = eobj.InQuotation
	    s obj.OutQuotation=eobj.OutQuotation
		s obj.ProDesc=eobj.ProDesc
		s:eobj.StandaloneFlag="" eobj.StandaloneFlag ="N" 
		s obj.StandaloneFlag=eobj.StandaloneFlag
		s:eobj.SalesFlag="" eobj.SalesFlag ="N" 
		s obj.SalesFlag=eobj.SalesFlag
		s:eobj.ActiveFlag="" eobj.ActiveFlag ="N"
		s obj.ActiveFlag=eobj.ActiveFlag
		s obj.Sequence=eobj.Sequence
  
     
	   	s sc=obj.%Save()
	  	d obj.%Close()
	   	If $$$ISOK(sc)
	   	{
		    Tc
		    s id = obj.%Id()
		    s result = "{success:'true',id:'"_id_"'}"  //返回RowId
		    //保存日志
		    d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_ProductLine","User.DHCProductLine","东华产品线维护",id,eobj.Caption,"A",eobj)
		    d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_ProductLine","User.DHCProductLine","东华产品线维护",eobj.ID,eobj.Caption,"U",eobj,bobj)
		}
	   	else
	   	{
	   		Trollback
	    	s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息

	   		s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("东华产品线维护","web.DHCBL.BDP.DHCProductLine","SaveData",eobj)
     		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	   	}
  }
 }  
 else
 {
 	 s result = "{success:'false',errorinfo:'对象不存在！'}"
 }
 q result
}

/// Creator:谷雪萍
/// CreatDate:2017-10-09
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""
	s ID=0,flag=0
  
	for
	{
		s ID=$o(^User.BDPMenuD(ID)) q:(ID="")||(flag=1)
		s ProductLineDr=$LISTGET($G(^User.BDPMenuD(ID)),18)
		i ProductLineDr=id
		{
			s flag=1
			s myInfo=myInfo_"<菜单维护>"
		}
	}
	if $d(^User.DHCProductLineI("ParIndex",id)) //判断该菜单是否被引用
	{
		s myInfo=myInfo_"<东华产品线维护>"
	}

	i myInfo="" s return="0^未被引用可删除！"
	else  s return="1^在"_myInfo_"表里被引用,不能删除！"
	q return
}

/// Description：根据ID删除
/// Table：User.DHCProductLine
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
 s result = "",flag=""
 /*s flag=$d(^User.DHCProductLineI("ParIndex",id)) //判断该菜单是否被引用
 if (flag>0)
 {
  	  s result = "{success:'false',info:'该节点已被引用,禁止删除！'}"   
 }
 else
 {*/
 s re=##class(web.DHCBL.BDP.DHCProductLine).GetRefFlag(id)
 s RefFlag=$p(re,"^",1)
 if (RefFlag=0)
 {
	  s eobj = ##class(web.Entity.BDP.DHCProductLine).%New()
	  s eobj.ID = id
	  s eobj.Code=$LISTGET($G(^User.DHCProductLineD(id)),2)
	  s eobj.Caption=$LISTGET($G(^User.DHCProductLineD(id)),3)
	  s eobj.ParentDr=$LISTGET($G(^User.DHCProductLineD(id)),4)
	  s eobj.Shorthand=$LISTGET($G(^User.DHCProductLineD(id)),5)
	  s eobj.Type=$LISTGET($G(^User.DHCProductLineD(id)),6)
	  s eobj.Offer=$LISTGET($G(^User.DHCProductLineD(id)),7)
	  s eobj.ProManMonth=$LISTGET($G(^User.DHCProductLineD(id)),8)
	  s eobj.ImpManMonth=$LISTGET($G(^User.DHCProductLineD(id)),9)
	  s eobj.ManMonth=$LISTGET($G(^User.DHCProductLineD(id)),10)
	  s eobj.InQuotation=$LISTGET($G(^User.DHCProductLineD(id)),11)
	  s eobj.OutQuotation=$LISTGET($G(^User.DHCProductLineD(id)),12)
	  s eobj.ProDesc=$LISTGET($G(^User.DHCProductLineD(id)),13)
	  s eobj.StandaloneFlag=$LISTGET($G(^User.DHCProductLineD(id)),14)
	  s eobj.SalesFlag=$LISTGET($G(^User.DHCProductLineD(id)),15)
	  s eobj.ActiveFlag=$LISTGET($G(^User.DHCProductLineD(id)),16)
	  s eobj.Sequence=$LISTGET($G(^User.DHCProductLineD(id)),17)
  
	  s sc=##class(User.DHCProductLine).%DeleteId(id)
	  if $$$ISOK(sc)
	  {
	   s result = "{success:'true',info:'删除成功！'}" 
	   //保存日志
	   d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_ProductLine","User.DHCProductLine","东华产品线维护",id,eobj.Caption,"D",eobj)
	   d eobj.%Close()
	  }
	  else 
	  {
	   s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
  	    s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("东华产品线维护","web.DHCBL.BDP.DHCProductLine","DeleteData",eobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	  }
 }
 else
 {
	s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
 }
 q result
}

/// 获取产品线,用于combobox
/// 入参：id(根节点), nodeId(要屏蔽的菜单rowid)
/// w ##class(web.DHCBL.BDP.DHCProductLine).GetLineForCmb("CatTreeRoot",3)
ClassMethod GetLineForCmb(id As %String) As %String
{
 if (id="CatTreeRoot") s id=-100000000000000
 q:id="" "[]"
 s mySMRowID=0
 s myLineCount=0
 s mySMSeq=0
 k myLineArray
 
 //生成菜单索引数组
 s mySMSeq=0
 s n=0
 for {
  s mySMSeq=$o(^User.DHCProductLineI("ParSeqIdx",id,mySMSeq))
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
  for {
   s mySMRowID=$o(^User.DHCProductLineI("ParSeqIdx",id," "_mySMSeq,mySMRowID))
   q:(mySMRowID="")
   s myLineCount=myLineCount+1
   s myLineArray(myLineCount)=mySMRowID
   ;w !,mySMRowID
  }
 }
 
 //输出菜单JSON串
 s mySMRowID=0
 s myLineSeq=0
 s myJsonStr=""
 for {
  ;q:(+myLineSeq>1)
  s myLineSeq=$o(myLineArray(myLineSeq))
  q:(myLineSeq="")
  s mySMRowID=$g(myLineArray(myLineSeq))
  
  s myLineObj=##Class(User.DHCProductLine).%OpenId(mySMRowID,0)
  if $IsObject(myLineObj) {
   s myCode = myLineObj.Code
   s myCaption = myLineObj.Caption
   s ParentDr = myLineObj.ParentDr
   s Type = myLineObj.Type
 
    //判断是否有子菜单 
   s myChildFlag=$d(^User.DHCProductLineI("ParIndex",mySMRowID))
   if (myChildFlag) s myChildFlag=1     //有子菜单不是叶子节点
   else  s myChildFlag=0  
   
   
   //if (+myChildFlag'=0) {
    s:(myJsonStr'="") myJsonStr=myJsonStr_","
    s myJsonStr=myJsonStr_"{"
    s myJsonStr=myJsonStr_"""id"":"""_""_mySMRowID_""",""text"":"""_myCaption_""","
    if (+myChildFlag'=0) {
    	s myJsonStr=myJsonStr_"""leaf"":false,"
        //获取子菜单
	    s myJsonStr=myJsonStr_"""children"":"_..GetLineForCmb(mySMRowID)
	    
    }
    else{
	    s myJsonStr=myJsonStr_"""leaf"":true"
    }
    
	s myJsonStr=myJsonStr_"}"
   //}
   
   d myLineObj.%Close()
  }
 }
 
 k myLineArray
 s myJsonStr="["_myJsonStr_"]"
 
 q myJsonStr
}

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

/// 2015-10-15 by 谷雪萍
/// Description：获取产品组树形菜单
/// Table：User.DHCProductLine
/// Input：id:父节点rowid
/// Ohter: w ##class(web.DHCBL.BDP.DHCProductLineDefine).GetProLineTree("TreeRoot")
ClassMethod GetProLineTree(LastLevel As %String, nodeStr As %String) As %String
{
 if (LastLevel="TreeRoot") s LastLevel=-100000000000000
 s mySMRowID=0
 s myLineCount=0
 s mySMSeq=0
 k myLineArray
 
 //生成菜单索引数组
 s mySMSeq=0
 s n=0
 for {
  s mySMSeq=$o(^User.DHCProductLineI("ParSeqIdx",LastLevel,mySMSeq))
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
  for {
   s mySMRowID=$o(^User.DHCProductLineI("ParSeqIdx",LastLevel," "_mySMSeq,mySMRowID))
   q:(mySMRowID="")
   s myLineCount=myLineCount+1
   s myLineArray(myLineCount)=mySMRowID
   ;w !,mySMRowID
  }
 }
 //输出菜单JSON串
 s mySMRowID=0
 s myLineSeq=0
 s myJsonStr=""
 for {
  ;q:(+myLineSeq>1)
  s myLineSeq=$o(myLineArray(myLineSeq))
  q:(myLineSeq="")
  s mySMRowID=$g(myLineArray(myLineSeq))
  
  s myLineObj=##Class(User.DHCProductLine).%OpenId(mySMRowID,0)
  if $IsObject(myLineObj) {
   
   s myCode = myLineObj.Code
   s myCaption = myLineObj.Caption
   s ParentDr = myLineObj.ParentDr
   s Type = myLineObj.Type
   s nodeId="<"_mySMRowID_">"

 
   //判断是否有子菜单 
   s myChildFlag=$d(^User.DHCProductLineI("ParIndex",mySMRowID))
   if (myChildFlag) s myChildFlag=1     //有子菜单不是叶子节点
   else  s myChildFlag=0
   
    s:(myJsonStr'="") myJsonStr=myJsonStr_","
    s myJsonStr=myJsonStr_"{"
    s myJsonStr=myJsonStr_"""id"":"""_""_mySMRowID_""",""text"":"""_myCaption_""","
    if (+myChildFlag'=0) {
	 s myJsonStr=myJsonStr_"""leaf"":false"
    }else {
     s myJsonStr=myJsonStr_"""parentNode"":"""_""_ParentDr_""","
     s myJsonStr=myJsonStr_"""leaf"":true"
    }
    if (nodeStr[nodeId){
		s myJsonStr=myJsonStr_",""expanded"":false"
	}
	else{
		s myJsonStr=myJsonStr_",""expanded"":true"
	}
    
    
    s myJsonStr=myJsonStr_"}"
   
   d myLineObj.%Close()
  }
 }
 
 k myLineArray
 s myJsonStr="["_myJsonStr_"]"
 
 q myJsonStr
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
  s mySMSeq=$o(^User.DHCProductLineI("ParSeqIdx",id,mySMSeq))
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

/// Description：菜单维护的时候与产品线关联显示为数字
/// Table：User.DHCProductLine
/// Input：id
ClassMethod GetProDesc(id As %String) As %String
{
 s desc="" 
 s ProductLineDr=$LISTGET($G(^User.BDPMenuD(id)),18)
 s:ProductLineDr'="" desc=$LISTGET($G(^User.DHCProductLineD(ProductLineDr)),3)
 q desc
}

/// Description：保存拖拽的内容 2016/9/21
/// Table：User.DHCSymptomLev
/// Input：id, parentid,orderstr
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: w ##class(web.DHCBL.KB.DHCSymptomCon).SaveData()
ClassMethod DragNode(id, parentid, orderstr) As %String
{
	s result=""
	q:(id="") "{success:'false',errorinfo:'没有拖拽的节点'}"
	q:(parentid="") "{success:'false',errorinfo:'没有拖拽到准确的节点下'}"
	s:parentid="TreeRoot" parentid=""
	
	s obj=##class(User.DHCProductLine).%OpenId(id)	
	d:parentid="" obj.ParentDrSetObjectId("")
	d:parentid'="" obj.ParentDrSetObjectId(parentid)

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
	      	 s obj=##class(User.DHCProductLine).%OpenId(rowid)
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

}
