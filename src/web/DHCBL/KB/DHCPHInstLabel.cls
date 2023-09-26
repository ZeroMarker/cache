Import SQLUser

/// 名称: 知识库目录字典维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2014-10-31
/// 最后修改日期: 2015-8-12
Class web.DHCBL.KB.DHCPHInstLabel Extends %RegisteredObject
{

/// Description：修改时打开的数据
/// Table：User.DHCPHInstLabel
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCPHInstLabel).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	s str=""
	s pobj = ##class(User.DHCPHInstLabel).%OpenId(id)	
	s eobj = ##class(web.Entity.KB.DHCPHInstLabel).%New()
	s eobj.PINLRowID=id
	s eobj.PINLCode=pobj.PINLCode
	s eobj.PINLDesc=pobj.PINLDesc
	s eobj.PINLOrderNum=pobj.PINLOrderNum
	s eobj.PINLManageMode=pobj.PINLManageMode
	s eobj.PINLIcon=pobj.PINLIcon
	s eobj.PINLAllFlag=pobj.PINLAllFlag
	s:eobj.PINLAllFlag'="N" eobj.PINLAllFlag="true" 
	if $IsObject(pobj.PINLLabelDr){
		s eobj.PINLLabelDr = pobj.PINLLabelDr.%Id() 
	}
	s eobj.PINLAlertMsg=pobj.PINLAlertMsg
	s eobj.PINLHref=pobj.PINLHref
	s eobj.PINLGenFlag=pobj.PINLGenFlag
	s:eobj.PINLGenFlag'="N" eobj.PINLGenFlag="true" 
	s eobj.PINLProFlag=pobj.PINLProFlag
	s:eobj.PINLProFlag'="N" eobj.PINLProFlag="true" 
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()	
	d eobj.%Close()
	s str = "{list:["_str_"]}"
	q str
}

/// Description：修改时打开的数据
/// Table：User.DHCPHInstLabel
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCPHInstLabel).OpenData("1")
ClassMethod NewOpenData(id As %String) As %String
{
	s str=""
	s pobj = ##class(User.DHCPHInstLabel).%OpenId(id)	
	s eobj = ##class(web.Entity.KB.DHCPHInstLabel).%New()
	s eobj.PINLRowID=id
	s eobj.PINLCode=pobj.PINLCode
	s eobj.PINLDesc=pobj.PINLDesc
	s eobj.PINLOrderNum=pobj.PINLOrderNum
	s eobj.PINLManageMode=pobj.PINLManageMode
	s eobj.PINLIcon=pobj.PINLIcon
	s eobj.PINLAllFlag=pobj.PINLAllFlag
	s:eobj.PINLAllFlag'="N" eobj.PINLAllFlag="Y"
	if $IsObject(pobj.PINLLabelDr){
		s eobj.PINLLabelDr = pobj.PINLLabelDr.%Id() 
	}
	s eobj.PINLAlertMsg=pobj.PINLAlertMsg
	s eobj.PINLHref=pobj.PINLHref
	s eobj.PINLGenFlag=pobj.PINLGenFlag
	s:eobj.PINLGenFlag'="N" eobj.PINLGenFlag="Y"
	s eobj.PINLProFlag=pobj.PINLProFlag
	s:eobj.PINLProFlag'="N" eobj.PINLProFlag="Y" 
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()	
	d eobj.%Close()
	//s str = "{list:["_str_"]}"
	q str
}

/// Description：数据重复验证方法，由js调用
/// Table：User.DHCPHInstLabel
/// Input：id, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod Validate(id As %String, code As %String) As %String
{
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	//s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s flag="",flagc="",flagd=""
	s:code'="" flagc=$d(^DHCPHPINL(0,"Code",code))
	//s:desc'="" flagd=$d(^DHCPHPINL(0,"Desc",desc))
	if (id="") //如果为空，增加时的重复判断
	{
		if ((flagc>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc="",idd=""
		s:code'="" idc=$o(^DHCPHPINL(0,"Code",code,0))
		if (idc'=id)&(flagc>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	q flag
}

/// Description：保存知识库目录字典的内容
/// Table：User.DHCPHInstLabel
/// Input：web.Entity.KB.DHCPHInstLabel 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCPHInstLabel).SaveData()
ClassMethod SaveData(eobj As web.Entity.KB.DHCPHInstLabel) As %String
{
	s $zt="ERROE"
	s result="",flag=""
	if $IsObject(eobj)
	{	
		s flag=..Validate(eobj.PINLRowID,eobj.PINLCode)  //调用重复验证
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		else
		{
			if (eobj.PINLRowID="")  //如果RowId未赋值则增加
			{
				s obj=##class(User.DHCPHInstLabel).%New()
			}
			else                     //如果RowId已赋值则修改
			{
				s obj=##class(User.DHCPHInstLabel).%OpenId(eobj.PINLRowID)
				s bobj=##class(web.Entity.KB.DHCPHInstLabel).%New()
				s bobj.PINLRowID=eobj.PINLRowID
				s bobj.PINLCode=obj.PINLCode
				s bobj.PINLDesc = obj.PINLDesc          //修改描述
				s bobj.PINLOrderNum = obj.PINLOrderNum          
				s bobj.PINLManageMode = obj.PINLManageMode
				s bobj.PINLIcon=obj.PINLIcon
				s bobj.PINLAllFlag=obj.PINLAllFlag
				if $IsObject(obj.PINLLabelDr){
					s bobj.PINLLabelDr = obj.PINLLabelDr.%Id() 
				}
				s bobj.PINLAlertMsg=obj.PINLAlertMsg
				s bobj.PINLHref=obj.PINLHref
				s bobj.PINLGenFlag=obj.PINLGenFlag
				s bobj.PINLProFlag=obj.PINLProFlag
			}
			Ts
			s obj.PINLCode = eobj.PINLCode
			s obj.PINLDesc = eobj.PINLDesc          //修改描述
			s obj.PINLOrderNum = eobj.PINLOrderNum         
			s obj.PINLManageMode = eobj.PINLManageMode
			s obj.PINLIcon=eobj.PINLIcon
			s:eobj.PINLAllFlag="" eobj.PINLAllFlag ="N" 
			s obj.PINLAllFlag=eobj.PINLAllFlag
			d obj.PINLLabelDrSetObjectId(eobj.PINLLabelDr)
			s obj.PINLAlertMsg=eobj.PINLAlertMsg
			s obj.PINLHref=eobj.PINLHref
			s:eobj.PINLGenFlag="" eobj.PINLGenFlag ="N"
			s obj.PINLGenFlag=eobj.PINLGenFlag
 			s:eobj.PINLProFlag="" eobj.PINLProFlag ="N" 
			s obj.PINLProFlag=eobj.PINLProFlag

					
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				Tc
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}"  //返回RowId
				//新增时，日志
				d:eobj.PINLRowID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstLabel","User.DHCPHInstLabel","知识库目录字典",id,eobj.PINLDesc,"A",eobj)
				//修改时，日志
				d:eobj.PINLRowID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstLabel","User.DHCPHInstLabel","知识库目录字典",eobj.PINLRowID,eobj.PINLDesc,"U",eobj,bobj)
			}
			else
			{
				Trollback
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
				s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("知识库目录字典","web.DHCBL.KB.DHCPHInstLabel","SaveData",eobj)
    			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			}
		}				
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
ERROE
	s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("知识库目录字典","web.DHCBL.KB.DHCPHInstLabel","SaveData",eobj)
  	s ^ERRORLOGINFO(logid)=$ze
	q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// w ##class(web.DHCBL.KB.DHCPHInstLabel).GetRefFlag("7")
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="", myInfo=""
	s ruledr=0,flag=0
	for  
	{
		s ruledr=$o(^DHCPHLIBRULE(ruledr)) q:(ruledr="")||(ruledr=0)||(flag=1)  d
		s labdr=$p(^DHCPHLIBRULE(ruledr),"^",2)
		i labdr=id
		{
			s flag=1
			s myInfo=myInfo_"<知识库规则配置>"
		}
	}
	i myInfo="" s return="0^未被引用可删除!"
 	else  s return="1^在"_myInfo_"里被引用,不能删除!"
 	q return
}

/// Description：根据ID删除知识库目录字典的内容
/// Table：User.DHCPHInstLabel
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
	s result = ""
	s re=##class(web.DHCBL.KB.DHCPHInstLabel).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0){
		//new Entity对象，用于保存日志
		s eobj = ##class(web.Entity.KB.DHCPHInstLabel).%New()
		s eobj.PINLRowID = id
		s eobj.PINLCode=$p($g(^DHCPHPINL(id)),"^",1)
		s eobj.PINLDesc=$p($g(^DHCPHPINL(id)),"^",2)
		s eobj.PINLOrderNum=$p($g(^DHCPHPINL(id)),"^",3)
		s eobj.PINLManageMode=$p($g(^DHCPHPINL(id)),"^",4)
		s eobj.PINLLabelDr=$p($g(^DHCPHPINL(id)),"^",5)
		s eobj.PINLIcon=$p($g(^DHCPHPINL(id)),"^",6)
		s eobj.PINLAllFlag=$p($g(^DHCPHPINL(id)),"^",7)
		s eobj.PINLAlertMsg=$p($g(^DHCPHPINL(id)),"^",8)
		s eobj.PINLGenFlag=$p($g(^DHCPHPINL(id)),"^",9)
		s eobj.PINLProFlag=$p($g(^DHCPHPINL(id)),"^",10)
		s eobj.PINLHref=$p($g(^DHCPHPINL(id)),"^",11)
		Tstart
		s sc=##class(User.DHCPHInstLabel).%DeleteId(id)
		if $$$ISOK(sc)
		{
			Tcommit
			s result = "{success:'true',info:'删除成功！'}"	
			//保存日志
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstLabel","User.DHCPHInstLabel","知识库目录字典",id,eobj.PINLDesc,"D",eobj)
			d eobj.%Close()
		}
		else 
		{
			Trollback
			s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		    s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("知识库目录字典","web.DHCBL.KB.DHCPHInstLabel","DeleteData",eobj)
		    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}
	q result
}

/// Description：查询知识库目录字典的内容
/// Table：User.DHCPHInstLabel
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHInstLabel","GetList","","","","")
Query GetList(rowid As %String, code As %String, desc As %String, lib As %String) As %Query(ROWSPEC = "PINLRowID:%String,PINLCode:%String,PINLDesc:%String,PINLOrderNum:%String,PINLManageMode:%String,PHLIRowId:%String,PINLLabelDr:%String,PINLIcon:%String,PINLAllFlag:%String,PINLAlertMsg:%String,PINLHref:%String,PINLGenFlag:%String,PINLProFlag:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, lib As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权
	//s AuStr=##class(web.DHCBL.Authorize.DHCPHInstLabel).DHCGetDataByDefaultSession()
	//s AuFlag=0
	//if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s PINLRowID=rowid
		s PINLCode=$p($g(^DHCPHPINL(PINLRowID)),"^",1)
		s PINLDesc=$p($g(^DHCPHPINL(PINLRowID)),"^",2)
		s PINLOrderNum=$p($g(^DHCPHPINL(PINLRowID)),"^",3)
		s PINLManageMode=$p($g(^DHCPHPINL(PINLRowID)),"^",4)
		s PINLIcon=$p($g(^DHCPHPINL(PINLRowID)),"^",6)
		s PINLAllFlag=$p($g(^DHCPHPINL(PINLRowID)),"^",7)
		s:PINLAllFlag'="N" PINLAllFlag="Y"
		s PHLIRowId=$p($g(^DHCPHPINL(PINLRowID)),"^",5)
		i PHLIRowId'="" {
			s PINLLabelDr=$p($g(^DHCPHLIBL(PHLIRowId)),"^",2)
		}
		else {
			s PINLLabelDr=""
		}
		s PINLAlertMsg=$p($g(^DHCPHPINL(PINLRowID)),"^",8)
		s PINLHref=$p($g(^DHCPHPINL(PINLRowID)),"^",11)
		s PINLGenFlag=$p($g(^DHCPHPINL(PINLRowID)),"^",9)
		s:PINLGenFlag'="N" PINLGenFlag="Y"
		s PINLProFlag=$p($g(^DHCPHPINL(PINLRowID)),"^",10)
		s:PINLProFlag'="N" PINLProFlag="Y"
	
		d OutputRow
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U") //转换成大写
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		s AuStr=##class(web.DHCBL.Authorize.DHCPHInstLabel).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s PINLRowID=0
		for {
			s PINLRowID=$o(^DHCPHPINL(PINLRowID))
			q:PINLRowID=""
			//筛选授权后的数据
			s strRowId="{ID:"_PINLRowID_"}"
			if (AuStr[strRowId)||(AuFlag=1) {
				s PINLCode=$p($g(^DHCPHPINL(PINLRowID)),"^",1)
				s PINLDesc=$p($g(^DHCPHPINL(PINLRowID)),"^",2)
				s PINLOrderNum=$p($g(^DHCPHPINL(PINLRowID)),"^",3)	
				s PINLManageMode=$p($g(^DHCPHPINL(PINLRowID)),"^",4)
				s PINLIcon=$p($g(^DHCPHPINL(PINLRowID)),"^",6)
				s PINLAllFlag=$p($g(^DHCPHPINL(PINLRowID)),"^",7)
				s:PINLAllFlag'="N" PINLAllFlag="Y"
				s PHLIRowId=$p($g(^DHCPHPINL(PINLRowID)),"^",5)
				i PHLIRowId'="" {
					s PINLLabelDr=$p($g(^DHCPHLIBL(PHLIRowId)),"^",2)
				}
				else {
					s PINLLabelDr=""
				}
				s PINLAlertMsg=$p($g(^DHCPHPINL(PINLRowID)),"^",8)
				s PINLHref=$p($g(^DHCPHPINL(PINLRowID)),"^",11)
				s PINLGenFlag=$p($g(^DHCPHPINL(PINLRowID)),"^",9)
				s:PINLGenFlag'="N" PINLGenFlag="Y"
				s PINLProFlag=$p($g(^DHCPHPINL(PINLRowID)),"^",10)
				s:PINLProFlag'="N" PINLProFlag="Y"
				
				s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(PINLDesc)
				if ($ZCONVERT(PINLCode,"U")[code)&(($ZCONVERT(PINLDesc,"U")[desc)||(PINYIN[desc))&((PHLIRowId=lib)||(lib=""))
				{
					d OutputRow
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PINLRowID,PINLCode,PINLDesc,PINLOrderNum,PINLManageMode,PHLIRowId,PINLLabelDr,PINLIcon,PINLAllFlag,PINLAlertMsg,PINLHref,PINLGenFlag,PINLProFlag)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
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

/// 获取管理模式，用于药品说明书中的级别设置默认值
/// w ##class(web.DHCBL.KB.DHCPHInstLabel).GetManageMode("Freq")
ClassMethod GetManageMode(code As %String) As %String
{
	s ManageMode=""
	s:code'="" code=$ZCONVERT(code,"U")
	s PINLRowID=$o(^DHCPHPINL("0","Code",code,0)) 
	s:PINLRowID'="" ManageMode=$p($g(^DHCPHPINL(PINLRowID)),"^",4)
	s:PINLRowID="" ManageMode=""

	q ManageMode
}

/// 2013-5-21 by lisen
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

/// Creator:石萧伟
/// CreatDate:2018-07-23
/// Description：保存知识库目录字典上移下移顺序
/// Other: w ##class().SaveDragOrder("9^12^11")
ClassMethod NewSaveDragOrder(order) As %String
{
	s $zt="ERROE"
	s result=""
	Ts
	s argsLen=$Length(order,"^")
	for i=1:1:argsLen		
	{
		s rowid=$p(order,"^",i)
		//选中行的顺序
		s obj=##class(User.DHCPHInstLabel).%OpenId(rowid)
		s obj.PINLOrderNum=i
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			
		}
		else
		{
			s result = "{success:'false'}"  //返回错误信息
		}
	}
	if (result["false")
	{
		Trollback
		s result = "{success:'false',errorinfo:'保存失败'}"
	
	}
	else
	{
		Tc
		s result = "{success:'true',errorinfo:'保存成功'}"

	}
	q result
	
ERROE
	q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Input：orderId :拖拽后的id串，afterOrder：拖拽后的顺序串
/// Description：保存知识库目录字典拖拽的顺序
/// Other: d ##class(web.DHCBL.KB.DHCPHInstLabel).SaveOrder("2","")
ClassMethod SaveDragOrder(orderId, afterOrder) As %String
{
	s $zt="ERROE"
	s result=""
	Ts
	s orderLen=$Length(afterOrder,"^")
	for n=1:1:orderLen		
	{
		s preOrder=$p(afterOrder,"^",n)
		s a(n)= preOrder
	}
	set left=1,right=orderLen
	d:$d(a) ..QuickSort(.a,left,right) //排序
	
	s argsLen=$Length(orderId,"^")
	for i=1:1:argsLen		
	{
		s rowid=$p(orderId,"^",i)
		//选中行的顺序
		s obj=##class(User.DHCPHInstLabel).%OpenId(rowid)
		s obj.PINLOrderNum=$g(a(i))
		s sc=obj.%Save()
		d obj.%Close()
		If '$$$ISOK(sc)
		{
			s result = "false"
		}
	}
	if (result["false")
	{
		Trollback
		s result = "{success:'false',errorinfo:'保存失败'}"
	}
	else
	{
		TC
		s result = "{success:'true',info:'保存成功'}"  
	}
	q result
ERROE
	q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Description：保存知识库目录字典上移下移的顺序
/// Other: d ##class(web.DHCBL.KB.DHCPHInstLabel).SaveOrder()
ClassMethod SaveOrder(checkId, changeId) As %String
{
	s $zt="ERROE"
	s result=""

	if ((checkId'="")&(changeId'=""))
	{
		
		//先保存选中行的顺序
		s obj1=##class(User.DHCPHInstLabel).%OpenId(checkId)
		s obj2=##class(User.DHCPHInstLabel).%OpenId(changeId)
		s OrderNum1=obj1.PINLOrderNum
		s OrderNum2=obj2.PINLOrderNum
		s obj1.PINLOrderNum=OrderNum2
		s obj2.PINLOrderNum=OrderNum1

		TS
		s sc1=obj1.%Save()
		s sc2=obj2.%Save()
		d obj1.%Close()
		d obj2.%Close()
		s sc=sc1&sc2
		If $$$ISOK(sc)
		{
			Tc
			s result = "{success:'true'}"  
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
	}	 
	else
	{
		s result = "{success:'true'}"
	}
	q result
ERROE
	q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// 获取最大顺序
/// w ##class(web.DHCBL.KB.DHCPHInstLabel).GetLastOrder()
ClassMethod GetLastOrder() As %String
{
	s sort=0
	if ($d(^DHCPHPINL("0","Order")))
	{
		s sort=$o(^DHCPHPINL("0","Order",""),-1) 
	}
	q sort+1
}

}
