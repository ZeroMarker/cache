/// 描述: 菜单关联功能元素
/// 编写者：钟荣枫
/// 编写日期: 2021-11-24
Class web.DHCBL.CT.FunctionalElement Extends %RegisteredObject
{

/// Creator：钟荣枫 		
/// CreatDate: 2020-11-24
/// Description：查询 菜单关联功能元素
/// Table:CT.BDP.CT.FunctionalElement 菜单关联功能元素
/// Input:id ,code,desc
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.FunctionalElement","GetList","","","","3","","9")
Query GetList(ParRef As %String, rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID,ParRef,ItemCode,ItemName,ItemType")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, ParRef As %String, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	if (rowid'="") //根据rowid返回该条记录
	{
		s ID=rowid
		s Pid=$p(rowid,"||",1)
		s Cid=$p(rowid,"||",2)
		s ItemCode=$lg($g(^User.BDPMenuD(Pid,"ChildItem",Cid)),2)   //功能元素代码
		s ItemName=$lg($g(^User.BDPMenuD(Pid,"ChildItem",Cid)),3)		//功能元素名称
		s ItemType=$lg($g(^User.BDPMenuD(Pid,"ChildItem",Cid)),4)		//按钮类型
		
		d OutputRow	
	}
	else
	{
		if (ParRef'="")
		{
			s Cid=""
			for
			{
				s Cid=$o(^User.BDPMenuD(ParRef,"ChildItem",Cid))  //遍历别名表
				q:Cid=""
				s ID=ParRef_"||"_Cid
				s ItemCode=$lg($g(^User.BDPMenuD(ParRef,"ChildItem",Cid)),2)   //功能元素代码
				s ItemName=$lg($g(^User.BDPMenuD(ParRef,"ChildItem",Cid)),3)		//功能元素名称
				s ItemType=$lg($g(^User.BDPMenuD(ParRef,"ChildItem",Cid)),4)		//按钮类型
				
				s PINYIN=""
				s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(ItemName)
			  	if (($ZCONVERT(ItemName,"U")[desc)||(PINYIN[desc))&&($ZCONVERT(ItemCode,"U")[code)	//过滤
			  	{
			  		d OutputRow
			 	}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ID,ParRef,ItemCode,ItemName,ItemType)
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

/// Creator:钟荣枫 
/// CreatDate:2021-11-24
/// Description:数据重复验证方法,js调用
/// Table:CT.BDP.CT.FunctionalElement  菜单关联功能元素
/// Input:id, 
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.CT.FunctionalElement).FormValidate(2951,"2951||1","TextDesc")
ClassMethod FormValidate(parref As %String, id As %String, code As %String) As %String
{
	s flag="",flagc=""
	s:id'="" parref=$p(id,"||",1)
	q:parref="" ""
    if (code'="")
    {
	    s idc=$o(^CT.BDP.CT.FunctionalElementI("UnCodeIndex",parref," "_$zcvt(code,"U"),0))
	    s rowid=parref_"||"_idc
	    if ((idc'="")&&(rowid'=id))
	    {
		 	s flag=1   
	    }
    }
    
	q flag
}

/// Creator:钟荣枫 
/// CreatDate: 2020-6-16
/// Description：菜单关联功能元素 保存
/// Table:CT.BDP.CT.FunctionalElement 菜单关联功能元素
/// Input: eobj As web.Entity.CT.FunctionalElement
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.DHCBL.CT.FunctionalElement).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.FunctionalElement) As %String
{
	s result=""
	if $IsObject(eobj)
	{	
		if (eobj.ParRef="")	
		{
			q "{success:'false',errorinfo:'父表指针为空！'}"
		}
		s flag=..FormValidate(eobj.ParRef,eobj.ID,eobj.ItemCode)  //调用重复验证
		if (flag=1)	//校验重复
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.ID="")	//新增
		{	
	        s obj=##class(CT.BDP.CT.FunctionalElement).%New(eobj.ParRef)
		}
		else	//修改
		{
			s obj=##class(CT.BDP.CT.FunctionalElement).%OpenId(eobj.ID)
			s bobj = ##class(web.Entity.CT.FunctionalElement).%New(eobj.ParRef)
			s bobj.ID = eobj.ID
			if $IsObject(obj.ParRef)
			{
				s bobj.ParRef=obj.ParRef.%Id() 
			}
			
			s bobj.ItemCode=obj.ItemCode   //功能元素代码
			s bobj.ItemName=obj.ItemName		//功能元素名称
			s bobj.ItemType=obj.ItemType		//按钮类型
			
		}
		d:eobj.ParRef'="" obj.ParRefSetObjectId(eobj.ParRef)
		s obj.ItemCode=eobj.ItemCode   //功能元素代码
		s obj.ItemName=eobj.ItemName		//功能元素名称
		s obj.ItemType=eobj.ItemType		//按钮类型
		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.ID="" ##class(web.DHCBL.MKB.MKBDataChangeLog).SaveLog("CT.BDP.CT.FunctionalElement","CT.BDP.CT.FunctionalElement","菜单关联功能元素",id,eobj.ItemName,"A",eobj)
			d:eobj.ID'="" ##class(web.DHCBL.MKB.MKBDataChangeLog).SaveLog("CT.BDP.CT.FunctionalElement","CT.BDP.CT.FunctionalElement","菜单关联功能元素",id,eobj.ItemName,"U",eobj,bobj)
			
		}
		else
		{
			Trollback
			s logid= ##class(web.DHCBL.MKB.SysErrorLog).SaveLog("菜单关联功能元素","web.DHCBL.CT.FunctionalElement","SaveEntity",eobj)
    		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
		}	
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/// Creator：钟荣枫 
/// CreatDate: 2021-11-24
/// Description：根据id删除 菜单关联功能元素
/// Table：CT.BDP.CT.FunctionalElement
/// Input：id 
/// Return：成功返回true，失败返回false和info
/// Other: w ##class(web.DHCBL.CT.FunctionalElement).DeleteData()
ClassMethod DeleteData(id) As %String
{

	s result=""

	s pobj=##class(CT.BDP.CT.FunctionalElement).%OpenId(id)
	s eobj = ##class(web.Entity.CT.FunctionalElement).%New()
	s eobj.ID = id
	if $IsObject(pobj.ParRef)
	{
		s eobj.ParRef=pobj.ParRef.%Id() 
	}
	
	s eobj.ItemCode=pobj.ItemCode   //功能元素代码
	s eobj.ItemName=pobj.ItemName		//功能元素名称
	s eobj.ItemType=pobj.ItemType		//按钮类型
	
	d pobj.%Close()
	kill pobj
	Tstart
	s sc=##class(CT.BDP.CT.FunctionalElement).%DeleteId(id)
	IF $$$ISOK(sc){
		Tc
		s result="{success:'true',info:'删除成功！'}"
		d ##class(web.DHCBL.MKB.MKBDataChangeLog).SaveLog("CT.BDP.CT.FunctionalElement","CT.BDP.CT.FunctionalElement","菜单关联功能元素",id,eobj.ItemName,"D",eobj)
	}
	else{
		Trollback
		s logid= ##class(web.DHCBL.MKB.SysErrorLog).SaveLog("菜单关联功能元素","web.DHCBL.CT.FunctionalElement","DeleteData",eobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	
	
	
	q result
}

/// Creator：钟荣枫 
/// CreatDate: 2021-11-24
/// Description：新增，修改时打开Form，根据RowID查询
/// Table：CT.BDP.CT.FunctionalElement
/// Input：RowId RetFlag=""或"Y"时，用于EXT, =JSON时，RetFlag="N"时用于HISUI，不输出 "{list:["_str_"]}"
/// Other: w ##class(web.DHCBL.CT.FunctionalElement).OpenData(2915)
ClassMethod OpenData(id As %String, RetFlag As %String = "") As %String
{
    s str = ""
    s pobj=##class(CT.BDP.CT.FunctionalElement).%OpenId(id)
	s eobj = ##class(web.Entity.CT.FunctionalElement).%New()
	s eobj.ID = id
	if $IsObject(pobj.ParRef)
	{
		s eobj.ParRef=pobj.ParRef.%Id() 
	}
	
	s eobj.ItemCode=pobj.ItemCode   //功能元素代码
	s eobj.ItemName=pobj.ItemName		//功能元素名称
	s eobj.ItemType=pobj.ItemType		//按钮类型
	
	d pobj.%Close()
	kill pobj
	s str = eobj.JsonS()
	if (RetFlag="")||(RetFlag="Y")
	{
		s str = "{list:["_str_"]}"
	}
	q str
}

/// Creator：钟荣枫 
/// CreatDate: 2021-11-24
/// Description：获取有/无权限的元素		
/// Table：CT.BDP.CT.FunctionalElement
/// Input：RowId
/// Other: w ##class(web.DHCBL.CT.FunctionalElement).GetItemJson("G",1,216,1)
ClassMethod GetItemJson(ObjectType As %String, ObjectReference As %String, MenuID As %String, Desc As %String, DisableFlag As %String = "") As %String
{
	q:ObjectReference="" "{data:[], success:true, total:0}"
	q:MenuID="" "{data:[], success:true, total:0}"
	s:Desc'="" Desc=$zconvert(Desc,"U")
	s ItemJson="",Count=0
		
	s ItemStr=##class(web.DHCBL.Authorize.Executables).DHCGetDataByReference(ObjectType,ObjectReference,MenuID)
	s ItemID=""
	for
	{
		s ItemID=$o(^User.BDPMenuD(MenuID,"ChildItem",ItemID))  //遍历别名表
		q:ItemID=""
		s ItemCode=$lg($g(^User.BDPMenuD(MenuID,"ChildItem",ItemID)),2)   //功能元素代码
		s ItemName=$lg($g(^User.BDPMenuD(MenuID,"ChildItem",ItemID)),3)		//功能元素名称
		s ItemType=$lg($g(^User.BDPMenuD(MenuID,"ChildItem",ItemID)),4)		//按钮类型
		if (Desc'="")
		{
			s Pinyin=##class(web.DHCBL.BDP.FunLib).GetPYCODE(ItemName)
			continue:((ItemName'[Desc)&&(Pinyin'[Desc))	
		}
		s rowid=MenuID_"||"_ItemID
		s ItemStr2="{ID:"_rowid_"}"
		s delflag=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPDisableDel")   ///chenying，20140928，一键禁用删除按钮
    
		if (DisableFlag="")		//有权限
		{
			continue:((ItemType["D")&(ItemType'="DF")&(delflag = "Y")&(ItemStr=""))||(ItemStr[ItemStr2)  //如果没有权则跳到下一条
		}
		else	//无权限
		{
			continue:'((ItemType ["D")&(ItemType'="DF")&(delflag = "Y")&(ItemStr=""))
			continue:(ItemStr'[ItemStr2) //如果有权则跳到下一条
		}
	
		if (ItemJson="") 
		{
			s ItemJson ="{""ID"":"""_rowid_""",""Code"":"""_ItemCode_""",""Name"":"""_ItemName_""",""Type"":"""_ItemType_"""}"
		}
		else  
		{
			s ItemJson =ItemJson_",{""ID"":"""_rowid_""",""Code"":"""_ItemCode_""",""Name"":"""_ItemName_""",""Type"":"""_ItemType_"""}"
		}
		s Count=Count+1
	}
	s ItemJson = "["_ItemJson_"]"
	q ItemJson
}

/// Creator：钟荣枫 
/// CreatDate: 2021-11-25
/// Description：获取菜单树		
/// Table：User.BDPMenu
/// Input：
/// Other: w ##class(web.DHCBL.CT.FunctionalElement).GetExecutableTreeJson("2940")
ClassMethod GetExecutableTreeJson(ParentID As %String) As %String
{
	s parentcatdr=ParentID
	s IDStr=""
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
		s mySeq=$o(^User.BDPMenuI("ParSeqIdx",parentcatdr,mySeq)) q:(mySeq="")
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
			s myRowID=$o(^User.BDPMenuI("ParSeqIdx",parentcatdr," "_mySeq,myRowID)) q:(myRowID="")
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
		s IsMKBMenu=$LISTGET($G(^User.BDPMenuD(myRowID)),21)
		
		s Code=$LISTGET($G(^User.BDPMenuD(myRowID)),2)   //代码
		s Caption=$LISTGET($G(^User.BDPMenuD(myRowID)),3)   //描述
		s ActiveFlag=$LISTGET($G(^User.BDPMenuD(myRowID)),16)
		s LinkUrl=$LISTGET($G(^User.BDPMenuD(myRowID)),5)
		s myFuntionDR = $LISTGET($G(^User.BDPMenuD(myRowID)),4)
		s myExeCode=""
		s:myFuntionDR'="" myExeCode=$LISTGET($G(^User.BDPExecutablesD(myFuntionDR)),4)
            
		s actMenuBDP="0"
		s actMenuAutItem="0"
		s:ActiveFlag'="" actMenuBDP=$p(ActiveFlag,"^",1)
		s:ActiveFlag'="" actMenuAutItem=$p(ActiveFlag,"^",2)
		continue:actMenuAutItem="0"
		s count=count+1
		if count>1 w ","
		w "{""id"":"""_myRowID_""""
		w ",""code"":"""_Code_""",""text"":"""_Caption_""",""myExeCode"":"""_myExeCode
		w """"
		
		if (LinkUrl="") s myChildFlag=1
		else  s myChildFlag=0
		//s childStr=##class(web.DHCBL.MKB.Menu).GetChildOrderedIDStr(myRowID)
		if (myChildFlag'=0) 
		{
			w ",""state"":""open"""   //closed节点不展开,open节点展开
			w ",""children"":"
			w ..GetExecutableTreeJson(myRowID)
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

/// Creator：钟荣枫 
/// CreatDate: 2021-11-24
/// Description：获取无权限的元素对应的代码		
/// Table：CT.BDP.CT.FunctionalElement
/// Input：RowId
/// Other: w ##class(web.DHCBL.CT.FunctionalElement).GetDisableItemCode(216)
ClassMethod GetDisableItemCode(MenuID As %String = "") As %String
{
	q:MenuID="" ""
	//通过session获取到用户、科室、安全组的id
	s myFuntionDR = $LISTGET($G(^User.BDPMenuD(MenuID)),4)
	s myExeCode=""
	s:myFuntionDR'="" myExeCode=$LISTGET($G(^User.BDPExecutablesD(myFuntionDR)),4)
			
	s result=""
	s codeI = $ZCONVERT(myExeCode,"U")
	s ItemStr=##class(web.DHCBL.Authorize.Executables).DHCGetDataByDefaultSession(MenuID) 
	
	s falg = ##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPDisableDel") //判断是否默认禁用删除按钮
	s StandardAutStr=""
	s:myExeCode'="" StandardAutStr= ##class(web.DHCBL.BDP.BDPTableList).GetTableAUDRights(myExeCode)  // 调用接口   "1#U"  //
	s StandardFlag=$p(StandardAutStr,"#") // 是否标准数据类型
	s StandardAut=$p(StandardAutStr,"#",2) 
	s ItemID = 0
	for
	{
		s ItemID=$o(^User.BDPMenuD(MenuID,"ChildItem",ItemID))
		q:ItemID=""
		s id1 = MenuID_"||"_ItemID
		s ItemStr2="{ID:"_id1_"}"
		s ItemCode=$lg($g(^User.BDPMenuD(MenuID,"ChildItem",ItemID)),2)   //功能元素代码
		s ItemType=$lg($g(^User.BDPMenuD(MenuID,"ChildItem",ItemID)),4)
		s ItemCode=##class(web.BDP.util.String).Replace(ItemCode,$c(32), "")
		if (StandardFlag=1)  ///  标准数据 需要在表结构登记里取 是否可以增删改的权限 然后再跟功能元素授权一起控制
		{
			if ((ItemType ="D")||(ItemType="A")||(ItemType ="U"))   ; 默认表结构登记里只控制 主表字典的按钮，对应类型为D A U ,不限制 A1 D1 U1
		 	{
			 	if (StandardAut[ItemType)||(ItemStr[ItemStr2)   /// 是标准数据 并且做过授权 才禁用
		 		{
			 		if (result="")
					{
						s result=ItemCode	
					}
					else
					{
						s result=result_"^"_ItemCode	
					}
		 		}
		 		else    // D1  A1 U1 的情况
		 		{
			 		if ((ItemType ["D")&(ItemType'="DF")&(falg = "Y"))&(ItemStr="")  //判断是否默认禁用删除按钮，如果默认禁用，在没授权时删除按钮都为禁用
		 			{
			 			if (result="")
						{
							s result=ItemCode	
						}
						else
						{
							s result=result_"^"_ItemCode	
						}
					
		 			}
		 		}
		 	}
		 	if (ItemStr[ItemStr2)  //判断是否有权限
		 	{
			 	if (result="")
				{
					s result=ItemCode	
				}
				else
				{
					s result=result_"^"_ItemCode	
				}
		 	}
		} 
		else    ///非标准数据 
		{
			if ((ItemType ["D")&(ItemType'="DF")&(falg = "Y"))&(ItemStr="")  //判断是否默认禁用删除按钮，如果默认禁用，在没授权时删除按钮都为禁用
		 	{
			 	if (result="")
				{
					s result=ItemCode	
				}
				else
				{
					s result=result_"^"_ItemCode	
				}
		 	}
		 
		 	if (ItemStr[ItemStr2)  //判断是否有权限
		 	{
			 	if (result="")
				{
					s result=ItemCode	
				}
				else
				{
					s result=result_"^"_ItemCode	
				}
		 	}
		}
	 
	}
	q result
}

/// Creator：钟荣枫 
/// CreatDate: 2021-12-07
/// Description：导入菜单的元素	
/// Table：CT.BDP.CT.FunctionalElement
/// Input：filepath
/// Other: w ##class(web.DHCBL.CT.FunctionalElement).ImportElement()
ClassMethod ImportElement(path)
{
	Set path1 = ##Class(%File).NormalizeFilename(path) //获取当前路径 D
	if '##class(%File).Exists(path1) 
	{
   		q "文件不存在"
    }
    Set file=##class(%File).%New(path)

	d file.Open("R")
	s continuecount=0
	s savecount=0
	s num=0
	
	k myFileAry
	TS
	for i=1:1:file.Size 
	{
		s data=file.Read()
		q:data=""
		s num=num+1
		continue:num=1  //跳过第一行
		s myFileAry(i)=data
		continue:data=""
		s MenuCode=$p(data,$c(9),1)	//菜单代码
		s MenuCode=$zstrip(MenuCode,"<>W")
		s MenuDesc=$p(data,$c(9),2)	//菜单描述
		s ElementCode=$p(data,$c(9),3)	//元素代码
		s ElementCode=$zstrip(ElementCode,"<>W")
		s ElementDesc=$p(data,$c(9),4)	//元素描述
		s ElementDesc=$zstrip(ElementDesc,"<>W")
		s ElementType=$p(data,$c(9),5)	//元素类型
		
		s MenuID=$o(^User.BDPMenuI("UniqueCodeIndex"," "_$ZCONVERT(MenuCode,"U"),0))
		if ((MenuID'="")&&(ElementCode'="")&&(ElementDesc'=""))
		{
			s ItemID=$o(^CT.BDP.CT.FunctionalElementI("UnCodeIndex",MenuID," "_$ZCONVERT(ElementCode,"U"),0))
			s eobj = ##class(web.Entity.CT.FunctionalElement).%New(MenuID)
			s:ItemID'="" eobj.ID = MenuID_"||"_ItemID
			s eobj.ParRef=MenuID
			
			s eobj.ItemCode=ElementCode   //功能元素代码
			s eobj.ItemName=ElementDesc		//功能元素名称
			s eobj.ItemType=ElementType		//按钮类型
			s re=..SaveEntity(eobj)
			if (re["false")
			{
				if (re["存在")
				{
					s continuecount=continuecount+1	
				}
			}
			else
			{
				s savecount=savecount+1	
			}
		}
		else
		{
			s continuecount=continuecount+1		
		}
	}
	
	c file
	k file
	w "读取数据总共"_(num-1)_"条",!
	w "跳过："_continuecount,!
	w "保存："_savecount,!
	tc
	q "success"
}

/// Creator：钟荣枫 
/// CreatDate: 2021-12-07
/// Description：判断菜单是否有配置功能元素
/// Table：CT.BDP.CT.FunctionalElement
/// Input：MenuID
/// Other: w ##class(web.DHCBL.CT.FunctionalElement).HaveItems()
ClassMethod HaveItems(MenuID)
{
	q:MenuID="" "N"
	s result="N"
	s ItemID=$o(^User.BDPMenuD(MenuID,"ChildItem",""))
	if (ItemID'="")
	{
		s result="Y"
	}
	q result
}

}
