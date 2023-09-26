Class web.DHCBL.KB.DHCPHExtIngr Extends %RegisteredObject
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

/// w ##class(web.DHCBL.KB.DHCPHExtIngr).GetTreeJson("TreeRoot","^<44>^<38>^<18>^<27>")
ClassMethod GetTreeJson(LastLevel As %String, nodeStr As %String) As %String
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
        s mySeq=$o(^User.DHCPHExtIngrI("ParSeqIdx",LastLevel,mySeq))
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
            s myRowID=$o(^User.DHCPHExtIngrI("ParSeqIdx",LastLevel," "_mySeq,myRowID))
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
        s myObj=##Class(User.DHCPHExtIngr).%OpenId(myRowID,0)
        if $IsObject(myObj) {
            s myCode = myObj.PHEINGCode
            s myDesc = myObj.PHEINGDesc
            s myLastLevel = myObj.PHEINGLastLevel
            s myLevel = myObj.PHEINGLevel
            s myActiveFlag = myObj.PHEINGActiveFlag
            s mySysFlag = myObj.PHEINGSysFlag
            s nodeId="<"_myRowID_">"
            
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

/// w ##class(web.DHCBL.KB.DHCPHExtIngr).GetTreeComboId("24")
ClassMethod GetTreeComboId(myRowID As %String) As %String
{
    s str=myRowID
        for
        {
            s myRowID=$listGet($g(^User.DHCPHExtIngrD(myRowID)),4)
            q:myRowID=""
            s str=myRowID_"^"_str
        }
    q str
}

/// w ##class(web.DHCBL.KB.DHCPHExtIngr).GetTreeComboJson("CatTreeRoot","")
ClassMethod GetTreeComboJson(ParentID As %String, nodeid As %String) As %String
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
        s mySeq=$o(^User.DHCPHExtIngrI("ParSeqIdx",ParentID,mySeq))
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
            s myRowID=$o(^User.DHCPHExtIngrI("ParSeqIdx",ParentID," "_mySeq,myRowID))
            q:(myRowID="")
            s myCount=myCount+1
            s myArray(myCount)=myRowID
            ;w !,myRowID
        }
    }
    //获取父类id
    if (nodeid'=""){
    s str=##class(web.DHCBL.KB.DHCPHExtIngr).GetTreeComboId(nodeid)
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
        
        s myObj=##Class(User.DHCPHExtIngr).%OpenId(myRowID,0)
        if $IsObject(myObj) {
            s myCode = myObj.PHEINGCode
            s myDesc = myObj.PHEINGDesc
            s myLastLevel=myObj.PHEINGLastLevel
            s myLevel = myObj.PHEINGLevel
            s myActiveFlag = myObj.PHEINGActiveFlag
            continue:myActiveFlag="N"
            s mySysFlag = myObj.PHEINGSysFlag
    
            s:(myJsonStr'="") myJsonStr=myJsonStr_","
            s myJsonStr=myJsonStr_"{"
            s myJsonStr=myJsonStr_"""id"":"""_""_myRowID_""",""text"":"""_myDesc_""","
            
            s myJsonStr=myJsonStr_"""leaf"":false,"
            if ($o(^User.DHCPHExtIngrI("ParCatIdx",myRowID,0))=""){
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

            d myObj.%Close()
        }
    }
    k myArray

    s myJsonStr="["_myJsonStr_"]"
    
    q myJsonStr
}

/// w ##class(web.DHCBL.KB.DHCPHExtIngr).GetListDesc(id)
ClassMethod GetListDesc(id) As %String
{
	if (id'="undefined")&&(id'="")
	{
		q $lg($g(^User.DHCPHExtIngrD(id)),3)
	}
	else{
		q "" 
	}
}

/// w ##class(web.DHCBL.KB.DHCPHExtIngr).GetNewTreeComboJson("")
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
        s mySeq=$o(^User.DHCPHExtIngrI("ParSeqIdx",ParentID,mySeq))
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
            s myRowID=$o(^User.DHCPHExtIngrI("ParSeqIdx",ParentID,mySeq,myRowID))
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
        
        s myObj=##Class(User.DHCPHExtIngr).%OpenId(myRowID,0)
        if $IsObject(myObj) {
            s myCode = myObj.PHEINGCode
            s myDesc = myObj.PHEINGDesc
            //s myLastLevel=myObj.MKBINMLastLevel
            //s myLevel = myObj.MKBINMLevel
            //s myActiveFlag = myObj.MKBINMActive
            //continue:myActiveFlag'="Y"
            s:(myJsonStr'="") myJsonStr=myJsonStr_","
            s myJsonStr=myJsonStr_"{"
            s myJsonStr=myJsonStr_"""id"":"""_""_myRowID_""",""text"":"""_myDesc_""","
            
            s myJsonStr=myJsonStr_"""state"":""open"""
            
				if ($d(^User.DHCPHExtIngrI("ParSeqIdx",myRowID))){
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

/// Function:用于实现数据校验功能的方法
/// Creator:基础数据平台组 高姗姗
/// CreateDate:2014-10-30    
/// w ##class(web.DHCBL.KB.DHCPHExtIngr).FormValidate("29","a12","烟碱")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
    s:code'="" code=" "_$ZCONVERT(code,"U") //转换成大写
    s:desc'="" desc=" "_$ZCONVERT(desc,"U") //转换成大写
    s flag="",flagc="",flagd=""
    s:code'="" flagc=$d(^User.DHCPHExtIngrI("CodeIndex",code))
    s:desc'="" flagd=$d(^User.DHCPHExtIngrI("DescIndex",desc))
    if (id="") //如果为空，增加时的重复判断
    {
        if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    else //如果不为空，修改时的重复判断
    {
        s idc="",idd=""
        s:code'="" idc=$o(^User.DHCPHExtIngrI("CodeIndex",code,0))
        s:desc'="" idd=$o(^User.DHCPHExtIngrI("DescIndex",desc,0))
        if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    q flag
}

/// Creator：高姗姗
/// CreatDate: 2014-10-30
/// Description：保存修改内容
/// Table：User.DHCPHExtIngr
/// Input：web.Entity.KB.DHCPHExtIngr 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.Entity.KB.DHCPHExtIngr) As %String
{
    
    s result = ""
    if $IsObject(eobj)
    {
            
        s flag=..FormValidate(eobj.PHEINGRowId,eobj.PHEINGCode,eobj.PHEINGDesc)  //调用重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在'}"
        }
        else
        {
            if (eobj.PHEINGRowId="")  //如果RowId未赋值则增加
            {
                s obj=##class(User.DHCPHExtIngr).%New()
            }
            else  //如果RowId已赋值则修改
            {
                s obj=##class(User.DHCPHExtIngr).%OpenId(eobj.PHEINGRowId)
                s bobj = ##class(web.Entity.KB.DHCPHExtIngr).%New()
                s bobj.PHEINGRowId = eobj.PHEINGRowId
                s bobj.PHEINGCode = obj.PHEINGCode
                s bobj.PHEINGDesc = obj.PHEINGDesc
                s:obj.PHEINGLastLevel'="" bobj.PHEINGLastLevel = obj.PHEINGLastLevel.%Id()
                s bobj.PHEINGLevel = obj.PHEINGLevel
                s bobj.PHEINGActiveFlag= obj.PHEINGActiveFlag
                s bobj.PHEINGSysFlag = obj.PHEINGSysFlag
                s bobj.PHEINGRelation = obj.PHEINGRelation
                s bobj.PHEINGPivaTotalQty = obj.PHEINGPivaTotalQty
            }
    
            s obj.PHEINGCode = eobj.PHEINGCode
            s obj.PHEINGDesc = eobj.PHEINGDesc
            d:eobj.PHEINGLastLevel'="" obj.PHEINGLastLevelSetObjectId(eobj.PHEINGLastLevel)
            d:eobj.PHEINGLastLevel="" obj.PHEINGLastLevelSetObjectId("")
            s obj.PHEINGLevel = eobj.PHEINGLevel
            s obj.PHEINGRelation = eobj.PHEINGRelation
            s obj.PHEINGPivaTotalQty = eobj.PHEINGPivaTotalQty
            i eobj.PHEINGActiveFlag="Y"
            {
                s obj.PHEINGActiveFlag = "Y"
            }
            else
            {
                s obj.PHEINGActiveFlag = "N"
            }
            i eobj.PHEINGSysFlag="Y"
            {
                s obj.PHEINGSysFlag = "Y"
            }
            else
            {
                s obj.PHEINGSysFlag = "N"
            }
            Ts
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc){
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}" //返回RowId
                d:eobj.PHEINGRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHExtIngr","User.DHCPHExtIngr","药品成分字典",id,eobj.PHEINGDesc,"A",eobj)
                d:eobj.PHEINGRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHExtIngr","User.DHCPHExtIngr","药品成分字典",eobj.PHEINGRowId,eobj.PHEINGDesc,"U",eobj,bobj)
            }else{
                Trollback
                s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"   //返回错误信息
                s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("药品成分字典","web.DHCBL.KB.DHCPHExtIngr","SaveData",eobj)
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
/// Table：User.DHCPHExtIngr
/// Other: d ##class(web.DHCBL.KB.DHCPHExtIngr).NewOpenData()
ClassMethod NewOpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.KB.DHCPHExtIngr).%New()
    s pobj = ##class(User.DHCPHExtIngr).%OpenId(id)
    s eobj.PHEINGRowId = id
    s eobj.PHEINGCode = pobj.PHEINGCode
    s eobj.PHEINGDesc = pobj.PHEINGDesc
    s:pobj.PHEINGLastLevel'="" eobj.PHEINGLastLevel = pobj.PHEINGLastLevel.%Id()
    s eobj.PHEINGLevel = pobj.PHEINGLevel
    s eobj.PHEINGActiveFlag=pobj.PHEINGActiveFlag
    s eobj.PHEINGSysFlag=pobj.PHEINGSysFlag  
    s eobj.PHEINGRelation = pobj.PHEINGRelation
    s eobj.PHEINGPivaTotalQty = pobj.PHEINGPivaTotalQty

    s str = eobj.JsonS()    
    ;s str = "{data:["_str_"]}"
    q str
}

/// Creator：高姗姗
/// CreatDate: 2014-10-30
/// Description：获取修改时的记录
/// Table：User.DHCPHExtIngr
/// Other: d ##class(web.DHCBL.KB.DHCPHExtIngr).OpenData()
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.KB.DHCPHExtIngr).%New()
    s pobj = ##class(User.DHCPHExtIngr).%OpenId(id)
    s eobj.PHEINGRowId = id
    s eobj.PHEINGCode = pobj.PHEINGCode
    s eobj.PHEINGDesc = pobj.PHEINGDesc
    s:pobj.PHEINGLastLevel'="" eobj.PHEINGLastLevel = pobj.PHEINGLastLevel.%Id()
    s eobj.PHEINGLevel = pobj.PHEINGLevel
    s:pobj.PHEINGActiveFlag="Y" eobj.PHEINGActiveFlag="true"
    s:pobj.PHEINGSysFlag="Y" eobj.PHEINGSysFlag="true"  
    s eobj.PHEINGRelation = pobj.PHEINGRelation
    s eobj.PHEINGPivaTotalQty = pobj.PHEINGPivaTotalQty

    s str = eobj.JsonS()    
    s str = "{data:["_str_"]}"
    q str
}

/// Creator:高姗姗
/// CreatDate:2014-10-30
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""
    
    s PHEGIRowId=0,flag=0
    for
    {
        s PHEGIRowId=$o(^DHCPHEGENIN(PHEGIRowId)) q:(PHEGIRowId="")||(flag=1)  d
        s PHEGIIngrDr=$p($g(^DHCPHEGENIN(PHEGIRowId)),"^",2)
        i PHEGIIngrDr=id
        {
            s flag=1
            s myInfo=myInfo_"<药品成分明细表>"
        }
    }
    
    s PHINIRowId=0,flag=0
    for
    {
        s PHINIRowId=$o(^DHCPHINI(PHINIRowId)) q:(PHINIRowId="")||(flag=1)  d
        s PHINIIngrDr=$p($g(^DHCPHINI(PHINIRowId)),"^",2)
        i PHINIIngrDr=id
        {
            s flag=1
            s myInfo=myInfo_"<药品成分业务表>"
        }
    }
    s PHECRowId=0,flag=0
    for
    {
        s PHECRowId=$o(^DHCPHEC(PHECRowId)) q:(PHECRowId="")||(flag=1)  d
        s PHECPHExtIngr=$p($g(^DHCPHEC(PHECRowId)),"^",2)
        i PHECPHExtIngr=id
        {
            s flag=1
            s myInfo=myInfo_"<整组浓度含量>"
        }
    }
    i ($o(^User.DHCPHExtIngrI("ParCatIdx",id,""))){
        s myInfo=myInfo_"<药品成分字典>"
    }
        
    i myInfo="" s return="0^未被引用可删除!"
    else  s return="1^在"_myInfo_"表里被引用,不能删除!"
    q return
}

/// Creator:高姗姗
/// CreatDate:2014-10-30
/// Description:根据id删除
/// Table:User.DHCPHExtIngr
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.KB.DHCPHExtIngr).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
    s return="",myInfo=""
    s re=##class(web.DHCBL.KB.DHCPHExtIngr).GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag'=0){
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    }
    else
    {
        Tstart
        s eobj = ##class(web.Entity.KB.DHCPHExtIngr).%New()
        s pobj = ##class(User.DHCPHExtIngr).%OpenId(id)
        s eobj.PHEINGRowId = id
        s eobj.PHEINGCode = pobj.PHEINGCode
        s eobj.PHEINGDesc = pobj.PHEINGDesc
        s:pobj.PHEINGLastLevel'="" eobj.PHEINGLastLevel = pobj.PHEINGLastLevel.%Id()
        s eobj.PHEINGLevel = pobj.PHEINGLevel
        s eobj.PHEINGActiveFlag = pobj.PHEINGActiveFlag
        s eobj.PHEINGSysFlag = pobj.PHEINGSysFlag
        s eobj.PHEINGRelation = pobj.PHEINGRelation
        s eobj.PHEINGPivaTotalQty = pobj.PHEINGPivaTotalQty
    
        s sc=##class(User.DHCPHExtIngr).%DeleteId(id)
        if $$$ISOK(sc){
            Tcommit
            s result="{success:'true',info:'删除成功！'}"
            d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHExtIngr","User.DHCPHExtIngr","药品成分字典",id,eobj.PHEINGDesc,"D",eobj)
        }
        else{
            Trollback
            s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
            s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("药品成分字典","web.DHCBL.KB.DHCPHExtIngr","DeleteData",eobj)
            s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
        }
    }
    q result
}

/// 获取上级分类及描述
/// w ##class(web.DHCBL.KB.DHCPHExtIngr).GetLastLevel(3)
ClassMethod GetLastLevel(id) As %String
{
    s myLastLevel = $listGet($g(^User.DHCPHExtIngrD(id)),4)
    s myLastDesc=""
    s:myLastLevel'="" myLastDesc=$listGet($g(^User.DHCPHExtIngrD(myLastLevel)),3)
    s LastLevel=myLastLevel_"^"_myLastDesc
    q LastLevel
}

ClassMethod DragNode(id, parentid, orderstr) As %String
{
    s result=""
    s:parentid="TreeRoot" parentid=""
    s obj=##class(User.DHCPHExtIngr).%OpenId(id)
    d:parentid="" obj.PHEINGLastLevelSetObjectId("")
    d:parentid'="" obj.PHEINGLastLevelSetObjectId(parentid)

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
           s obj=##class(User.DHCPHExtIngr).%OpenId(rowid)
           s obj.PHEINGLevel =i
           s sc=obj.%Save()
           d obj.%Close()             
        }
    }else{
        Trollback
        s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"   //返回错误信息
    }
    q result
}

/// Description：保存拖拽的内容
/// Table：User.DHCPHExtIngr
/// Input：begin，end  ，type
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: w ##class(web.DHCBL.KB.DHCPHExtIngr).SaveDropData()
ClassMethod SaveDropData(begin As %String, end As %String, type As %String) As %String
{

    s result=""
    q:(begin="")||(end="")||(type="") "{success:'false',errorinfo:'没有拖拽的节点'}"
    s objbegin=##class(User.DHCPHExtIngr).%OpenId(begin)
    s objend=##class(User.DHCPHExtIngr).%OpenId(end)
    
    s eobj = ##class(web.Entity.KB.DHCPHExtIngr).%New()
    s eobj.PHEINGRowId = begin
    s eobj.PHEINGCode = objbegin.PHEINGCode
    s eobj.PHEINGDesc = objbegin.PHEINGDesc
    s eobj.PHEINGActiveFlag= objbegin.PHEINGActiveFlag
    s eobj.PHEINGSysFlag = objbegin.PHEINGSysFlag
    if (type="above")
    {
        s:objend.PHEINGLastLevel'="" eobj.PHEINGLastLevel = objend.PHEINGLastLevel.%Id()
        s eobj.PHEINGLevel = objend.PHEINGLevel
        q:objbegin.PHEINGLastLevel=objend.PHEINGLastLevel "{success:'false',errorinfo:'同级拖拽没有效果'}"
        
    }
    if (type="below")
    {
        s:objend.PHEINGLastLevel'="" eobj.PHEINGLastLevel = objend.PHEINGLastLevel.%Id()
        s eobj.PHEINGLevel = objend.PHEINGLevel
        q:objbegin.PHEINGLastLevel=objend.PHEINGLastLevel "{success:'false',errorinfo:'同级拖拽没有效果'}"
        
    }
    if (type="append")
    {
        s eobj.PHEINGLastLevel = end
        s eobj.PHEINGLevel = objend.PHEINGLevel
    }
    s result=..SaveData(eobj)  //调用重复验证 

    q result
}

/// Description:代码自动生成  ZD0000000 代码最大值加1
/// Table：User.DHCPHExtIngr
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// w ##class(web.DHCBL.KB.DHCPHExtIngr).GetLastCode()
ClassMethod GetLastCode() As %String
{
    s AutoCode=$g(^TMPAUTOINGRCODE("AutoCode"))  //是否手动输入
    s CodeLen=$g(^TMPAUTOINGRCODE("CodeLen"))    //代码长度
    s StartCode=$g(^TMPAUTOINGRCODE("StartCode"))  //代码起始字符
    s code=""
    if (AutoCode="false")  //自动生成代码
    {
        s StartCodeLen=$Length(StartCode)
        s PHEINGRowId=0, preCode=""    //寻找符合规则的最大的代码
        for {
            s PHEINGRowId=$o(^User.DHCPHExtIngrD(PHEINGRowId))
            q:PHEINGRowId=""
            s PHEINGCode=$listget($g(^User.DHCPHExtIngrD(PHEINGRowId)),2)
            if ($e(PHEINGCode,1,StartCodeLen)=StartCode)
            {
                s preCode=PHEINGCode
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
/// Others:w ##class(web.DHCBL.KB.DHCPHExtIngr).SaveAutoCode()
ClassMethod SaveAutoCode(AutoCode, CodeLen, StartCode) As %String
{
 
   k ^TMPAUTOINGRCODE
   s result=""
   if ($Length(StartCode)>=CodeLen)
   {
       s result=2
       s ^TMPAUTOINGRCODE("AutoCode")="true"
       s ^TMPAUTOINGRCODE("CodeLen")=""
       s ^TMPAUTOINGRCODE("StartCode")=""
   } 
   else
   {
       if (AutoCode="")||(AutoCode="0")   //自动生成代码
       {
        s ^TMPAUTOINGRCODE("AutoCode")="false"
        s ^TMPAUTOINGRCODE("CodeLen")=CodeLen
        s ^TMPAUTOINGRCODE("StartCode")=StartCode
       }
       else    //手动输入代码
       {
        s ^TMPAUTOINGRCODE("AutoCode")="true"
        s ^TMPAUTOINGRCODE("CodeLen")=""
        s ^TMPAUTOINGRCODE("StartCode")=""
       }
        s result=1
   }
   q result
}

/// 给表单赋值
/// Others:w ##class(web.DHCBL.KB.DHCPHExtIngr).ShowAutoCode("CodeLen")
ClassMethod ShowAutoCode(code) As %String
{
 
   s result=""
   s result=$g(^TMPAUTOINGRCODE(code))
   q result
}

/// 获取关系及配液整组含量
/// w ##class(web.DHCBL.KB.DHCPHExtIngr).GetRelation(17)
ClassMethod GetRelation(id) As %String
{
    s return=""
    s PHEINGRelation = $listGet($g(^User.DHCPHExtIngrD(id)),8)
    s PHEINGPivaTotalQty = $listGet($g(^User.DHCPHExtIngrD(id)),9)
    s return = PHEINGRelation_"^"_PHEINGPivaTotalQty
    q return
}

/// Creator：丁亚男
/// CreatDate: 2018-08-15
/// Description：获取某个父节点下的所有子节点 用^连接，并按照顺序排列  
/// Table：User.MKBTerm
/// Input：父节点
/// Return：所有子节点 用^连接
/// w ##class(web.DHCBL.KB.DHCPHLibCat).GetTreeChildOrderedIDStr("6")
ClassMethod GetTreeChildOrderedIDStr(LastLevel As %String) As %String
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
		s mySeq=$o(^User.DHCPHExtIngrI("ParSeqIdx",LastLevel,mySeq)) q:(mySeq="")
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
			s myRowID=$o(^User.DHCPHExtIngrI("ParSeqIdx",LastLevel," "_mySeq,myRowID)) q:(myRowID="")
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
		
		s childStr=..GetTreeChildOrderedIDStr(myRowID)
		if childStr'="" s childStr=myRowID_"^"_childStr
		if childStr="" s childStr=myRowID
		
		if IDStr="" s IDStr=childStr
		else  s IDStr=IDStr_"^"_childStr
	}
	q IDStr
}

/// Creator:丁亚男
/// CreatDate:2018-8-15
/// Description:获取药品成分
/// Table:User.DHCPHExtIngr
/// Return:成功返回树形json数据
/// w ##class(web.DHCBL.KB.DHCPHExtIngr).NewGetTreeJson("TreeRoot","^<44>^<38>^<18>^<27>")
ClassMethod NewGetTreeJson(LastLevel As %String) As %String
{
    if (LastLevel="") s LastLevel=-100000000000000
    s myJsonStr=""
    s myRowID=0
    s myCount=0
    s mySeq=0
    k myArray
    
    //生成菜单索引数组
    s mySeq=0
    s n=0
    for {
        s mySeq=$o(^User.DHCPHExtIngrI("ParSeqIdx",LastLevel,mySeq))
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
            s myRowID=$o(^User.DHCPHExtIngrI("ParSeqIdx",LastLevel," "_mySeq,myRowID))
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
        
        s mySeq=$o(myArray(mySeq))
        q:(mySeq="")
        s myRowID=$g(myArray(mySeq))
        s myObj=##Class(User.DHCPHExtIngr).%OpenId(myRowID,0)
        if $IsObject(myObj) {
            s myCode = myObj.PHEINGCode
            s myDesc = myObj.PHEINGDesc
            s myLastLevel = myObj.PHEINGLastLevel
            s myLevel = myObj.PHEINGLevel
            s myActiveFlag = myObj.PHEINGActiveFlag
            s mySysFlag = myObj.PHEINGSysFlag
            s count=count+1
            if count>1 w ","
            
           	w "{""id"":"""_""_myRowID_""",""text"":"""_myDesc_""""
            s childStr=..GetTreeChildOrderedIDStr(myRowID)
			if (childStr'="")
			{
				w ",""state"":""open"""
				w ",""children"":"
				w ..NewGetTreeJson(myRowID)	
			}
			else
			{
				w ",""state"":""open"""
			}
			w "}"

            d myObj.%Close()
        }
    }
   w "]"
   q ""
}

}
