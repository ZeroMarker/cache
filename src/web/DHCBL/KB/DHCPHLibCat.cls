Class web.DHCBL.KB.DHCPHLibCat Extends %RegisteredObject
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

/// w ##class(web.DHCBL.KB.DHCPHLibCat).GetTreeJson("TreeRoot","10","^^^^<37>^<20>^<18>^<7>^<6>^<2>")
ClassMethod GetTreeJson(LastLevel As %String, LibDr As %String, nodeStr As %String) As %String
{
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
        s mySeq=$o(^User.DHCPHLibCatI("ParSeqIdx",LastLevel,mySeq))
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
            s myRowID=$o(^User.DHCPHLibCatI("ParSeqIdx",LastLevel," "_mySeq,myRowID))
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
        
        s myObj=##Class(User.DHCPHLibCat).%OpenId(myRowID,0)
        if $IsObject(myObj) {
            s myCode = myObj.PHICCode
            s myDesc = myObj.PHICDesc
            s myLevel = myObj.PHICLevel
            s:myObj.PHICLibDr'="" myLibDr = myObj.PHICLibDr.%Id()
            s myPHLICode = $p($g(^DHCPHLIBL(myLibDr)),"^",1)
            s myActiveFlag = myObj.PHICActiveFlag
            s mySysFlag = myObj.PHICSysFlag
            s mySkinTestFlag = myObj.PHICSkinTestFlag
            s nodeId="<"_myRowID_">"
        
            s:LibDr'="" PHLICode = $p($g(^DHCPHLIBL(LibDr)),"^",1)
            s:LibDr="" PHLICode="DRUG"
            s:PHLICode="SPEC" PHLICode="LAB"     //检验项目检验标本同取检验项目的分类
            if (myPHLICode=PHLICode){
            
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
            }
            d myObj.%Close()
        }
    }
    k myArray
    s myJsonStr="["_myJsonStr_"]"
    
    q myJsonStr
}

/// Creator：丁亚男
/// CreatDate: 2018-08-13
/// Description：获取某个父节点下的所有子节点 用^连接，并按照顺序排列  
/// Table：User.MKBTerm
/// Input：父节点
/// Return：所有子节点 用^连接
/// w ##class(web.DHCBL.KB.DHCPHLibCat).GetTreeChildOrderedIDStr("6","10")
ClassMethod GetTreeChildOrderedIDStr(LastLevel As %String, LibDr As %String) As %String
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
		s mySeq=$o(^User.DHCPHLibCatI("ParSeqIdx",LastLevel,mySeq)) q:(mySeq="")
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
			s myRowID=$o(^User.DHCPHLibCatI("ParSeqIdx",LastLevel," "_mySeq,myRowID)) q:(myRowID="")
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
		
		s childStr=..GetTreeChildOrderedIDStr(myRowID,LibDr)
		if childStr'="" s childStr=myRowID_"^"_childStr
		if childStr="" s childStr=myRowID
		
		if IDStr="" s IDStr=childStr
		else  s IDStr=IDStr_"^"_childStr
	}
	q IDStr
}

/// Creator:丁亚男
/// CreatDate:2018-08-13
/// Description：树形 分类/类型字典
/// Input：上级节点，类别
/// Return:成功返回分类/类型字典
/// w ##class(web.DHCBL.KB.DHCPHLibCat).NewGetTreeJson("6","10")
ClassMethod NewGetTreeJson(LastLevel As %String, LibDr As %String) As %String
{
    if (LastLevel="") s LastLevel=-100000000000000
    s myJsonStr=""
    s myRowID=0
    s myCount=0
    s mySeq=0
    k myArray
    
    //生成索引数组
    s mySeq=0
    s n=0
    for {
        s mySeq=$o(^User.DHCPHLibCatI("ParSeqIdx",LastLevel,mySeq))
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
            s myRowID=$o(^User.DHCPHLibCatI("ParSeqIdx",LastLevel," "_mySeq,myRowID))
            q:(myRowID="")
            s myCount=myCount+1
            s myArray(myCount)=myRowID
        }
    }

    //输出JSON串
    s myRowID=0
    s mySeq=0
    s childStr=""
	w "["
	s count=0
    for {
	    
        s mySeq=$o(myArray(mySeq))
        q:(mySeq="")
        s myRowID=$g(myArray(mySeq))
       
        s myObj=##Class(User.DHCPHLibCat).%OpenId(myRowID,0)
        if $IsObject(myObj) {
	        s myPHLICode=""
            s myCode = myObj.PHICCode
            s myDesc = myObj.PHICDesc
            s myDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(myDesc)
            s myLevel = myObj.PHICLevel
            s myLibDr=""
            s:myObj.PHICLibDr'="" myLibDr = myObj.PHICLibDr.%Id()
            s:myLibDr'="" myPHLICode = $p($g(^DHCPHLIBL(myLibDr)),"^",1)
            
            s myActiveFlag = myObj.PHICActiveFlag
            s mySysFlag = myObj.PHICSysFlag
            s mySkinTestFlag = myObj.PHICSkinTestFlag
           
        
            s:LibDr'="" PHLICode = $p($g(^DHCPHLIBL(LibDr)),"^",1)
            s:LibDr="" PHLICode="DRUG"
            s:PHLICode="SPEC" PHLICode="LAB"     //检验项目检验标本同取检验项目的分类
            if (myPHLICode=PHLICode){
	            s count=count+1
            	if count>1 w ","
                w "{""id"":"""_myRowID_""",""text"":"""_myDesc_""""
                s childStr=..GetTreeChildOrderedIDStr(myRowID,LibDr)
				if (childStr'="")
				{
					w ",""state"":""open"""
					w ",""children"":"
					w ..NewGetTreeJson(myRowID,LibDr)	
				}
				else
				{
					w ",""state"":""open"""
				}
				w "}"
            }
            d myObj.%Close()
        }
    }
    w "]"
	q ""
}

/// w ##class(web.DHCBL.KB.DHCPHLibCat).GetTreeComboId("24")
ClassMethod GetTreeComboId(myRowID As %String) As %String
{
    s str=myRowID
        for
        {
            s myRowID=$listGet($g(^User.DHCPHLibCatD(myRowID)),4)
            q:myRowID=""
            s str=myRowID_"^"_str
        }
    q str
}

/// w ##class(web.DHCBL.KB.DHCPHLibCat).GetTreeComboJson("CatTreeRoot","","10")
ClassMethod GetTreeComboJson(ParentID As %String, nodeid As %String, libDr As %String) As %String
{
    if (ParentID="CatTreeRoot") s ParentID=-100000000000000
    s myJsonStr=""
    s myRowID=0
    s myCount=0
    s mySeq=0
    k myArray
    
    //生成菜单索引数组
    s mySeq=0
    s n=0
    for {
        s mySeq=$o(^User.DHCPHLibCatI("ParSeqIdx",ParentID,mySeq))
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
            s myRowID=$o(^User.DHCPHLibCatI("ParSeqIdx",ParentID," "_mySeq,myRowID))
            q:(myRowID="")
            s myCount=myCount+1
            s myArray(myCount)=myRowID
            ;w !,myRowID
        }
    }
    //获取父类id
    if (nodeid'=""){
    s str=##class(web.DHCBL.KB.DHCPHLibCat).GetTreeComboId(nodeid)
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
        
        s myObj=##Class(User.DHCPHLibCat).%OpenId(myRowID,0)
        if $IsObject(myObj) {
            s myCode = myObj.PHICCode
            s myDesc = myObj.PHICDesc
            s:myObj.PHICLastLevel'="" myLastLevel=myObj.PHICLastLevel.%Id()
            s myLevel = myObj.PHICLevel
            s:myObj.PHICLibDr'="" myLibDr = myObj.PHICLibDr.%Id()
            s myPHLICode = $p($g(^DHCPHLIBL(myLibDr)),"^",1)
            s myActiveFlag = myObj.PHICActiveFlag
            continue:myActiveFlag="N"
            s mySysFlag = myObj.PHICSysFlag
            
            s:libDr'="" PHLICode = $p($g(^DHCPHLIBL(libDr)),"^",1)
            
            if (myPHLICode=PHLICode){
            //continue:(myActiveFlag'="")&&('$p(myActiveFlag,"^",3)) //查看该菜单是否被激活
            /*if (myImage'=""){
                s:(($e(myImage,1)="/")||($e(myImage,1)="\")) myImage=$e(myImage,2,$l(myImage))
                s myImage=$tr(myImage,"\","/")
                s myImage="../scripts/bdp/Framework/icons/"_myImage
            }*/
                s:(myJsonStr'="") myJsonStr=myJsonStr_","
                s myJsonStr=myJsonStr_"{"
                s myJsonStr=myJsonStr_"""id"":"""_""_myRowID_""",""text"":"""_myDesc_""","
            //  s myJsonStr=myJsonStr_"""iconCls"":"""_""_myImage_""","
                s myJsonStr=myJsonStr_"""leaf"":false,"
                if ($o(^User.DHCPHLibCatI("ParCatIdx",myRowID,0))=""){
                    s myJsonStr=myJsonStr_"""cls"":""x-tree-node-leaf x-tree-node-icon""," 
                    s myJsonStr=myJsonStr_"""leaf"":true,"
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
            }
            d myObj.%Close()
        }
    }
    k myArray

    s myJsonStr="["_myJsonStr_"]"
    
    q myJsonStr
}

/// w ##class(web.DHCBL.KB.DHCPHLibCat).GetTreeProComboJson("CatTreeRoot")
ClassMethod GetTreeProComboJson(ParentID As %String, nodeid As %String, lib As %String) As %String
{
    if (ParentID="CatTreeRoot") s ParentID=-100000000000000
    s myJsonStr=""
    s myRowID=0
    s myCount=0
    s mySeq=0
    k myArray
    
    //生成菜单索引数组
    s mySeq=0
    s n=0
    for {
        s mySeq=$o(^User.DHCPHLibCatI("ParSeqIdx",ParentID,mySeq))
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
            s myRowID=$o(^User.DHCPHLibCatI("ParSeqIdx",ParentID," "_mySeq,myRowID))
            q:(myRowID="")
            s myCount=myCount+1
            s myArray(myCount)=myRowID
            ;w !,myRowID
        }
    }
    //获取父类id
    if (nodeid'=""){
    s str=##class(web.DHCBL.KB.DHCPHLibCat).GetTreeComboId(nodeid)
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
        
        s myObj=##Class(User.DHCPHLibCat).%OpenId(myRowID,0)
        if $IsObject(myObj) {
            s myCode = myObj.PHICCode
            s myDesc = myObj.PHICDesc
            s myLastLevel=myObj.PHICLastLevel
            s myLevel = myObj.PHICLevel
            s:myObj.PHICLibDr'="" myLibDr = myObj.PHICLibDr.%Id()
            s myPHLICode = $p($g(^DHCPHLIBL(myLibDr)),"^",1)
            s myActiveFlag = myObj.PHICActiveFlag
            continue:myActiveFlag="N"
            s mySysFlag = myObj.PHICSysFlag
            
            s:lib="" lib="DRUG"
            s:lib="SPEC" lib="LAB" 
            if (myPHLICode=lib){
            //continue:(myActiveFlag'="")&&('$p(myActiveFlag,"^",3)) //查看该菜单是否被激活
            /*if (myImage'=""){
                s:(($e(myImage,1)="/")||($e(myImage,1)="\")) myImage=$e(myImage,2,$l(myImage))
                s myImage=$tr(myImage,"\","/")
                s myImage="../scripts/bdp/Framework/icons/"_myImage
            }*/
    
                s:(myJsonStr'="") myJsonStr=myJsonStr_","
                s myJsonStr=myJsonStr_"{"
                s myJsonStr=myJsonStr_"""id"":"""_""_myRowID_""",""text"":"""_myDesc_""","
            //  s myJsonStr=myJsonStr_"""iconCls"":"""_""_myImage_""","

                s myJsonStr=myJsonStr_"""leaf"":false,"
                if ($o(^User.DHCPHLibCatI("ParCatIdx",myRowID,0))=""){
                    s myJsonStr=myJsonStr_"""cls"":""x-tree-node-leaf x-tree-node-icon""," 
                    s myJsonStr=myJsonStr_"""leaf"":true,"
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
            }
            d myObj.%Close()
        }
    }
    k myArray

    s myJsonStr="["_myJsonStr_"]"
    
    q myJsonStr
}

/// Function:用于实现数据校验功能的方法
/// Creator:基础数据平台组 高姗姗
/// CreateDate:2014-11-27    
/// w ##class(web.DHCBL.KB.DHCPHLibCat).FormValidate("","","")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
 s:code'="" code=" "_$ZCONVERT(code,"U") //转换成大写
 s:desc'="" desc=" "_$ZCONVERT(desc,"U") //转换成大写
 s flag="",flagc="",flagd=""
 s:code'="" flagc=$d(^User.DHCPHLibCatI("CodeIndex",code))
 s:desc'="" flagd=$d(^User.DHCPHLibCatI("DescIndex",desc))
 if (id="") //如果为空，增加时的重复判断
 {
    if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
    else  s flag=0 //返回不重复标志
 }
 else //如果不为空，修改时的重复判断
 {
  s idc="",idd=""
  s:code'="" idc=$o(^User.DHCPHLibCatI("CodeIndex",code,0))
  s:desc'="" idd=$o(^User.DHCPHLibCatI("DescIndex",desc,0))
  if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
    else  s flag=0 //返回不重复标志
 }
 q flag
}

/// Creator：高姗姗
/// CreatDate: 2014-10-30
/// Description：保存修改内容
/// Table：User.DHCPHLibCat
/// Input：web.Entity.KB.DHCPHLibCat 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.Entity.KB.DHCPHLibCat) As %String
{
    s result = ""
    if $IsObject(eobj)
    {
        
        
        s flag=..FormValidate(eobj.PHICRowId ,eobj.PHICCode,eobj.PHICDesc)  //调用重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在'}"
        }
        else
        {
            if (eobj.PHICRowId="")  //如果RowId未赋值则增加
            {
                s obj=##class(User.DHCPHLibCat).%New()
            }
            else  //如果RowId已赋值则修改
            {
                s obj=##class(User.DHCPHLibCat).%OpenId(eobj.PHICRowId)
                s bobj = ##class(web.Entity.KB.DHCPHLibCat).%New()
                s bobj.PHICRowId = eobj.PHICRowId
                s bobj.PHICCode = obj.PHICCode
                s bobj.PHICDesc = obj.PHICDesc
                s:obj.PHICLastLevel'="" bobj.PHICLastLevel = obj.PHICLastLevel.%Id()
                s bobj.PHICLevel = obj.PHICLevel
                s:obj.PHICLibDr'="" bobj.PHICLibDr = obj.PHICLibDr.%Id()
                s bobj.PHICActiveFlag=  obj.PHICActiveFlag
                s bobj.PHICSysFlag = obj.PHICSysFlag
                s bobj.PHICSkinTestFlag = obj.PHICSkinTestFlag
            }
    
            s obj.PHICCode = eobj.PHICCode
            s obj.PHICDesc = eobj.PHICDesc
            d:eobj.PHICLastLevel'="" obj.PHICLastLevelSetObjectId(eobj.PHICLastLevel)
            d:eobj.PHICLastLevel="" obj.PHICLastLevelSetObjectId("")
            s obj.PHICLevel = eobj.PHICLevel
            d:eobj.PHICLibDr'="" obj.PHICLibDrSetObjectId(eobj.PHICLibDr)
            d:eobj.PHICLibDr="" obj.PHICLibDrSetObjectId("")     
            i eobj.PHICActiveFlag="Y"
            {
                s obj.PHICActiveFlag = "Y"
            }
            else
            {
                s obj.PHICActiveFlag = "N"
            }
            i eobj.PHICSysFlag="Y"
            {
                s obj.PHICSysFlag = "Y"
            }
            else
            {
                s obj.PHICSysFlag = "N"
            }
            i eobj.PHICSkinTestFlag="Y"
            {
                s obj.PHICSkinTestFlag = "Y"
            }
            else
            {
                s obj.PHICSkinTestFlag = "N"
            }
            Ts
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc){
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}" //返回RowId
                d:eobj.PHICRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHLibCat","User.DHCPHLibCat","分类/类型字典",id,eobj.PHICDesc,"A",eobj)
                d:eobj.PHICRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHLibCat","User.DHCPHLibCat","分类/类型字典",eobj.PHICRowId,eobj.PHICDesc,"U",eobj,bobj)
            }
            else{
                Trollback
                s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"   //返回错误信息
                s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("分类/类型字典","web.DHCBL.KB.DHCPHLibCat","SaveData",eobj)
                s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
            }
        }   
    }   

    else
    {
        s result = "{success:'false',errorinfo:'对象不存在'}"
    }
    
    q result
}

/// Creator：高姗姗
/// CreatDate: 2014-10-30
/// Description：获取修改时的记录
/// Table：User.DHCPHLibCat
/// Other: d ##class(web.DHCBL.KB.DHCPHLibCat).OpenData()
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.KB.DHCPHLibCat).%New()
    
    s pobj = ##class(User.DHCPHLibCat).%OpenId(id)
    s eobj.PHICRowId = id
    s eobj.PHICCode = pobj.PHICCode
    s eobj.PHICDesc = pobj.PHICDesc
    s:pobj.PHICLastLevel'="" eobj.PHICLastLevel = pobj.PHICLastLevel.%Id()
    s eobj.PHICLevel = pobj.PHICLevel
    s:pobj.PHICLibDr'="" eobj.PHICLibDr = pobj.PHICLibDr.%Id()
    s:pobj.PHICActiveFlag="Y" eobj.PHICActiveFlag="true"
    s:pobj.PHICSysFlag="Y" eobj.PHICSysFlag="true"  
    s:pobj.PHICSkinTestFlag="Y" eobj.PHICSkinTestFlag="true"
    
    s str = eobj.JsonS()    
    s str = "{data:["_str_"]}"
    q str
}

/// Creator：丁亚男
/// CreatDate: 2018-08-10
/// Description：获取修改时的记录
/// Table：User.DHCPHLibCat
/// Other: d ##class(web.DHCBL.KB.DHCPHLibCat).NewOpenData()
ClassMethod NewOpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.KB.DHCPHLibCat).%New()
    
    s pobj = ##class(User.DHCPHLibCat).%OpenId(id)
    s eobj.PHICRowId = id
    s eobj.PHICCode = pobj.PHICCode
    s eobj.PHICDesc = pobj.PHICDesc
    s:pobj.PHICLastLevel'="" eobj.PHICLastLevel = pobj.PHICLastLevel.%Id()
    s eobj.PHICLevel = pobj.PHICLevel
    s:pobj.PHICLibDr'="" eobj.PHICLibDr = pobj.PHICLibDr.%Id()
    s eobj.PHICActiveFlag=pobj.PHICActiveFlag
    s eobj.PHICSysFlag=pobj.PHICSysFlag  
    s eobj.PHICSkinTestFlag=pobj.PHICSkinTestFlag
    
    s str = eobj.JsonS()    
    ;s str = "{data:["_str_"]}"
    q str
}

/// Creator:高姗姗
/// CreatDate:2014-12-2
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""

    s PHGPRRowId=0,flag=0
    for
    {
        s PHGPRRowId=$o(^DHCPHDGP(PHGPRRowId)) q:(PHGPRRowId="")||(flag=1)  d
        s PHGPRCatDr=$p($g(^DHCPHDGP(PHGPRRowId)),"^",4)
        i PHGPRCatDr=id
        {
            s flag=1
            s myInfo=myInfo_"<通用名药品属性表>"
        }
    }
    s LGPRowId=0,flag=0
    for
    {
        s LGPRowId=$o(^DHCLISGP(LGPRowId)) q:(LGPRowId="")||(flag=1)  d
        s LGPCatDr=$p($g(^DHCLISGP(LGPRowId)),"^",3)
        i LGPCatDr=id
        {
            s flag=1
            s myInfo=myInfo_"<通用名检验属性表>"
        }
    }
    s LSCRowId=0,flag=0
    for
    {
        s LSCRowId=$o(^DHCLSCCARE(LSCRowId)) q:(LSCRowId="")||(flag=1)  d
        s LSCCatDr=$p($g(^DHCLSCCARE(LSCRowId)),"^",2)
        i LSCCatDr=id
        {
            s flag=1
            s myInfo=myInfo_"<通用名标本采集注意事项>"
        }
    }
    
    s CATIRowId=0,flag=0
    for
    {
        s CATIRowId=$o(^DHCLIBCATI(CATIRowId)) q:(CATIRowId="")||(flag=1)  d
        s CATICatDr=$p($g(^DHCLIBCATI(CATIRowId)),"^",2)
        i CATICatDr=id
        {
            s flag=1
            s myInfo=myInfo_"<分类业务表>"
        }
    }
    i ($o(^User.DHCPHLibCatI("ParCatIdx",id,""))){
        s myInfo=myInfo_"<分类/类型字典表>"
    }
    
    i myInfo="" s return="0^未被引用可删除!"
    else  s return="1^在"_myInfo_"表里被引用,不能删除!"
    q return
}

/// Creator:高姗姗
/// CreatDate:2014-10-30
/// Description:根据id删除
/// Table:User.DHCPHLibCat
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.KB.DHCPHLibCat).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
    s return="",myInfo=""
    
    s re=##class(web.DHCBL.KB.DHCPHLibCat).GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag'=0){
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    }
    else
    {
        Tstart
        s eobj = ##class(web.Entity.KB.DHCPHLibCat).%New()
        s pobj = ##class(User.DHCPHLibCat).%OpenId(id)
        s eobj.PHICRowId = id
        s eobj.PHICCode = pobj.PHICCode
        s eobj.PHICDesc = pobj.PHICDesc
        s:pobj.PHICLastLevel'="" eobj.PHICLastLevel = pobj.PHICLastLevel.%Id()
        s eobj.PHICLevel = pobj.PHICLevel
        s:pobj.PHICLibDr'="" eobj.PHICLibDr = pobj.PHICLibDr.%Id()  
        s eobj.PHICActiveFlag = pobj.PHICActiveFlag
        s eobj.PHICSysFlag = pobj.PHICSysFlag
        s eobj.PHICSkinTestFlag=pobj.PHICSkinTestFlag
    
        s sc=##class(User.DHCPHLibCat).%DeleteId(id)
        if $$$ISOK(sc){
            Tcommit
            s result="{success:'true',info:'删除成功！'}"
            d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHLibCat","User.DHCPHLibCat","分类/类型字典",id,eobj.PHICDesc,"D",eobj)
        }
        else{
            Trollback
            s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
            s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("分类/类型字典","web.DHCBL.KB.DHCPHLibCat","DeleteData",eobj)
            s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
        }
    }
    q result
}

/// 获取知识库标识为药品的id
/// w ##class(web.DHCBL.KB.DHCPHLibCat).GetDrugId("DRUG")
ClassMethod GetDrugId(code As %String) As %String
{
    s DrugId=""
    s:code'="" code=$ZCONVERT(code,"U")
    s DrugId=$o(^DHCPHLIBL("0","Code",code,0)) 
    q DrugId
}

/// 获取上级分类及描述
/// w ##class(web.DHCBL.KB.DHCPHLibCat).GetLastLevel(3)
ClassMethod GetLastLevel(id) As %String
{
    s myLastLevel = $listGet($g(^User.DHCPHLibCatD(id)),4)
    s myLastDesc=""
    s:myLastLevel'="" myLastDesc=$listGet($g(^User.DHCPHLibCatD(myLastLevel)),3)
    s LastLevel=myLastLevel_"^"_myLastDesc
    q LastLevel
}

ClassMethod DragNode(id, parentid, orderstr) As %String
{
    s result=""
    s:parentid="TreeRoot" parentid=""
    s obj=##class(User.DHCPHLibCat).%OpenId(id)
    d:parentid="" obj.PHICLastLevelSetObjectId("")
    d:parentid'="" obj.PHICLastLevelSetObjectId(parentid)

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
           s obj=##class(User.DHCPHLibCat).%OpenId(rowid)
           s obj.PHICLevel =i
           s sc=obj.%Save()
           d obj.%Close()             
        }
    }else{
        Trollback
        s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"   //返回错误信息
    }
    q result
}

}
