/// 描述: 知识库接口管理表User.MKBInterfaceManage方法类
/// 编写者：基础数据平台组-石萧伟
/// 编写日期: 2018-03-27
Class web.DHCBL.MKB.MKBInterfaceManage Extends %RegisteredObject
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

/// w ##class(web.DHCBL.MKB.MKBInterfaceManage).GetTreeComboId("24")
ClassMethod GetTreeComboId(myRowID As %String) As %String
{
    s str=myRowID
    for
    {
        s myRowID=$LISTGET($G(^User.MKBInterfaceManageD(myRowID)),6)
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
/// w ##class(web.DHCBL.MKB.MKBInterfaceManage).GetNewTreeJson("")
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
        s mySeq=$o(^User.MKBInterfaceManageI("ParLevelIndex",id,mySeq))
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
        for {
            s myRowID=$o(^User.MKBInterfaceManageI("ParLevelIndex",id,mySeq,myRowID))
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
        s myObj=##Class(User.MKBInterfaceManage).%OpenId(myRowID,0)
        if $IsObject(myObj) {
            s MKBINMRowId=myRowID
            s MKBINMCode = myObj.MKBINMCode
            s MKBINMDesc = myObj.MKBINMDesc
            s MKBINMFunction = myObj.MKBINMFunction
            s MKBINMReturnValue = myObj.MKBINMReturnValue
            s MKBINMLastLevel = myObj.MKBINMLastLevel.MKBINMDesc
            s MKBINMLevel = myObj.MKBINMLevel
            s MKBINMRemark = myObj.MKBINMRemark
            s:MKBINMRemark[$c(10) MKBINMRemark=$tr(MKBINMRemark,$c(10),"")
            s:MKBINMRemark[$c(13,10) MKBINMRemark=$tr(MKBINMRemark,$c(13,10),"")
            s MKBINMActive = myObj.MKBINMActive
			s PINYINDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBINMDesc)
			s PINYINDesc=$ZCONVERT(PINYINDesc,"L")
            s:(myJsonStr'="") myJsonStr=myJsonStr_","
            s myJsonStr=myJsonStr_"{"
            s myJsonStr=myJsonStr_"""id"":"""_MKBINMRowId_""",""MKBINMLastLevel"":"""_MKBINMLastLevel_""",""MKBINMCode"":"""_MKBINMCode_""",""MKBINMDesc"":"""_MKBINMDesc_""",""MKBINMFunction"":"""_MKBINMFunction_""",""MKBINMReturnValue"":"""_MKBINMReturnValue_""",""MKBINMRemark"":"""_MKBINMRemark_""",""MKBINMActive"":"""_MKBINMActive_""",""PINYINDesc"":"""_PINYINDesc_""",""MKBINMLevel"":"""_MKBINMLevel_""","
            s myJsonStr=myJsonStr_"""state"":""open"""
			if ($d(^User.MKBInterfaceManageI("ParLevelIndex",myRowID))){
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
/// w ##class(web.DHCBL.MKB.MKBInterfaceManage).GetNewTreeComboJson("")
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
        s mySeq=$o(^User.MKBInterfaceManageI("ParLevelIndex",ParentID,mySeq))
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
            s myRowID=$o(^User.MKBInterfaceManageI("ParLevelIndex",ParentID,mySeq,myRowID))
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
        
        s myObj=##Class(User.MKBInterfaceManage).%OpenId(myRowID,0)
        if $IsObject(myObj) {
            s myCode = myObj.MKBINMCode
            s myDesc = myObj.MKBINMDesc
            s myLastLevel=myObj.MKBINMLastLevel
            s myLevel = myObj.MKBINMLevel
            s myActiveFlag = myObj.MKBINMActive
			//s PINYINDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE(myDesc)
			//s PINYINDesc=$ZCONVERT(PINYINDesc,"L")            
            //continue:myActiveFlag'="Y"
            s:(myJsonStr'="") myJsonStr=myJsonStr_","
            s myJsonStr=myJsonStr_"{"
            s myJsonStr=myJsonStr_"""id"":"""_""_myRowID_""",""text"":"""_myDesc_""","
            s myJsonStr=myJsonStr_"""state"":""open"""
				if ($d(^User.MKBInterfaceManageI("ParLevelIndex",myRowID))){
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
/// Other: w ##class(web.DHCBL.MKB.MKBInterfaceManage).NewOpenData(6)
ClassMethod NewOpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.MKB.MKBInterfaceManage).%New()
    s pobj = ##class(User.MKBInterfaceManage).%OpenId(id)
    s eobj.MKBINMRowId = id
    s eobj.MKBINMCode = pobj.MKBINMCode
    s eobj.MKBINMDesc = pobj.MKBINMDesc
    s:pobj.MKBINMLastLevel'="" eobj.MKBINMLastLevel = pobj.MKBINMLastLevel.%Id()
    s eobj.MKBINMFunction = pobj.MKBINMFunction
    s eobj.MKBINMReturnValue = pobj.MKBINMReturnValue
    s eobj.MKBINMRemark = pobj.MKBINMRemark
    s eobj.MKBINMLevel = pobj.MKBINMLevel
    s eobj.MKBINMActive=pobj.MKBINMActive
    s eobj.id=id
    s str = eobj.JsonS()  
    //s str="{MKBINMActive:'"_eobj.MKBINMActive_"',MKBINMCode:'"_eobj.MKBINMCode_"',MKBINMDesc:'"_eobj.MKBINMDesc_"',MKBINMFunction:'"_eobj.MKBINMFunction_"',MKBINMLastLevel:'"_eobj.MKBINMLastLevel_"',MKBINMLevel:'"_eobj.MKBINMLevel_"',MKBINMRemark:'"_eobj.MKBINMRemark_"',MKBINMReturnValue:'"_eobj.MKBINMReturnValue_"',MKBINMRowId:'"_eobj.MKBINMRowId_"'}"
   //s str = "{data:["_str_"]}"
    q str
}

/// w ##class(web.DHCBL.MKB.MKBInterfaceManage).NewOpenData1(25)
ClassMethod NewOpenData1(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.MKB.MKBInterfaceManage).%New()
    s pobj = ##class(User.MKBInterfaceManage).%OpenId(id)
    s eobj.MKBINMRowId = id
    s eobj.id=id
    s eobj.MKBINMCode = pobj.MKBINMCode
    s eobj.MKBINMDesc = pobj.MKBINMDesc
    s:pobj.MKBINMLastLevel'="" eobj.MKBINMLastLevel = $lg(^User.MKBInterfaceManageD($lg(^User.MKBInterfaceManageD(id),6)),3)
    //s eobj.MKBINMLastLevel = pobj.MKBINMLastLevel
    s eobj.MKBINMFunction = pobj.MKBINMFunction
    s eobj.MKBINMReturnValue = pobj.MKBINMReturnValue
    s eobj.MKBINMRemark = pobj.MKBINMRemark
    s eobj.MKBINMLevel = pobj.MKBINMLevel
    s eobj.MKBINMActive=pobj.MKBINMActive
    s str = eobj.JsonS()  
    //s str="{MKBINMActive:'"_eobj.MKBINMActive_"',MKBINMCode:'"_eobj.MKBINMCode_"',MKBINMDesc:'"_eobj.MKBINMDesc_"',MKBINMFunction:'"_eobj.MKBINMFunction_"',MKBINMLastLevel:'"_eobj.MKBINMLastLevel_"',MKBINMLevel:'"_eobj.MKBINMLevel_"',MKBINMRemark:'"_eobj.MKBINMRemark_"',MKBINMReturnValue:'"_eobj.MKBINMReturnValue_"',MKBINMRowId:'"_eobj.MKBINMRowId_"'}"
   //s str = "{data:["_str_"]}"
    q str
}

/// Function:用于实现数据校验功能的方法
/// Creator:基础数据平台组 高姗姗
/// CreateDate:2014-10-30    
/// w ##class(web.DHCBL.MKB.MKBInterfaceManage).FormValidate("8","55")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String) As %String
{
    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
    s flag="",flagc=""
    s:code'="" flagc=$d(^User.MKBInterfaceManageI("CodeIndex"," "_code))
    if (id="") //如果为空，增加时的重复判断
    {
        if (flagc>0) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    else //如果不为空，修改时的重复判断
    {
        s idc="",idd=""
        s:code'="" idc=$o(^User.MKBInterfaceManageI("CodeIndex"," "_code,0))
        if ((idc'="")&(idc'=id)&(flagc>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    q flag
}

/// Creator：高姗姗
/// CreatDate: 2017-5-11
/// Description：保存修改内容
/// Table：User.MKBInterfaceManage
/// Input：web.Entity.MKB.MKBInterfaceManage 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因、
/// w ##class(web.DHCBL.MKB.MKBInterfaceManage).FormValidate(13,"ceshi")
ClassMethod SaveData(eobj As web.Entity.MKB.MKBInterfaceManage) As %String
{
    
    s result = ""
    if $IsObject(eobj)
    {
        s flag=..FormValidate(eobj.MKBINMRowId,eobj.MKBINMCode)  //调用重复验证
        //s ^tmp(1)=eobj.MKBINMRowId_"-"_eobj.MKBINMLevel
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在'}"
        }
        else
        {
            if (eobj.MKBINMRowId="")  //如果RowId未赋值则增加
            {
                s obj=##class(User.MKBInterfaceManage).%New()
            }
            else  //如果RowId已赋值则修改
            {
                s obj=##class(User.MKBInterfaceManage).%OpenId(eobj.MKBINMRowId)
                s bobj = ##class(web.Entity.MKB.MKBInterfaceManage).%New()
                s bobj.MKBINMRowId = eobj.MKBINMRowId
                s bobj.MKBINMCode = obj.MKBINMCode
                s bobj.MKBINMDesc = obj.MKBINMDesc
                s:obj.MKBINMLastLevel'="" bobj.MKBINMLastLevel = obj.MKBINMLastLevel.%Id()
                s bobj.MKBINMFunction = obj.MKBINMFunction
                s bobj.MKBINMReturnValue = obj.MKBINMReturnValue
                s bobj.MKBINMRemark = obj.MKBINMRemark
                s bobj.MKBINMLevel = obj.MKBINMLevel
                s bobj.MKBINMActive= obj.MKBINMActive
            }
    
            s obj.MKBINMCode = eobj.MKBINMCode
            s obj.MKBINMDesc = eobj.MKBINMDesc
            d:eobj.MKBINMLastLevel'="" obj.MKBINMLastLevelSetObjectId(eobj.MKBINMLastLevel)
            d:eobj.MKBINMLastLevel="" obj.MKBINMLastLevelSetObjectId("")
            s obj.MKBINMFunction = eobj.MKBINMFunction
            s obj.MKBINMReturnValue = eobj.MKBINMReturnValue
            s obj.MKBINMRemark = eobj.MKBINMRemark
            s obj.MKBINMLevel = eobj.MKBINMLevel
            i eobj.MKBINMActive="Y"
            {
                s obj.MKBINMActive = "Y"
            }
            else
            {
                s obj.MKBINMActive = "N"
            }
        
            Ts
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc){
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}" //返回RowId
                d:eobj.MKBINMRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_InterfaceManage","User.MKBInterfaceManage","知识库接口管理表",id,eobj.MKBINMDesc,"A",eobj)
                d:eobj.MKBINMRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_InterfaceManage","User.MKBInterfaceManage","知识库接口管理表",eobj.MKBINMRowId,eobj.MKBINMDesc,"U",eobj,bobj)
            }else{
                Trollback
                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
                s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("知识库接口管理表","web.DHCBL.MKB.MKBInterfaceManage","SaveData",eobj)
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

ClassMethod SaveData1(eobj As web.Entity.MKB.MKBInterfaceManage) As %String
{
    
    s result = ""
    if $IsObject(eobj)
    {
        s flag=..FormValidate(eobj.id,eobj.MKBINMCode)  //调用重复验证
        s ^tmp(1)=eobj.MKBINMLevel
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在'}"
        }
        else
        {
            if (eobj.id="")  //如果RowId未赋值则增加
            {
                s obj=##class(User.MKBInterfaceManage).%New()
            }
            else  //如果RowId已赋值则修改
            {
                s obj=##class(User.MKBInterfaceManage).%OpenId(eobj.id)
                s bobj = ##class(web.Entity.MKB.MKBInterfaceManage).%New()
                s bobj.id = eobj.id
                s bobj.MKBINMCode = obj.MKBINMCode
                s bobj.MKBINMDesc = obj.MKBINMDesc
                s:obj.MKBINMLastLevel'="" bobj.MKBINMLastLevel = obj.MKBINMLastLevel.%Id()
                s bobj.MKBINMFunction = obj.MKBINMFunction
                s bobj.MKBINMReturnValue = obj.MKBINMReturnValue
                s bobj.MKBINMRemark = obj.MKBINMRemark
                s bobj.MKBINMLevel = obj.MKBINMLevel
                s bobj.MKBINMActive= obj.MKBINMActive
            }
    
            s obj.MKBINMCode = eobj.MKBINMCode
            s obj.MKBINMDesc = eobj.MKBINMDesc
            d:eobj.MKBINMLastLevel'="" obj.MKBINMLastLevelSetObjectId(eobj.MKBINMLastLevel)
            d:eobj.MKBINMLastLevel="" obj.MKBINMLastLevelSetObjectId("")
            s obj.MKBINMFunction = eobj.MKBINMFunction
            s obj.MKBINMReturnValue = eobj.MKBINMReturnValue
            s obj.MKBINMRemark = eobj.MKBINMRemark
            s obj.MKBINMLevel = eobj.MKBINMLevel
            i eobj.MKBINMActive="Y"
            {
                s obj.MKBINMActive = "Y"
            }
            else
            {
                s obj.MKBINMActive = "N"
            }
        
            Ts
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc){
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}" //返回RowId
                d:eobj.id="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_InterfaceManage","User.MKBInterfaceManage","知识库接口管理表",id,eobj.MKBINMDesc,"A",eobj)
                d:eobj.id'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_InterfaceManage","User.MKBInterfaceManage","知识库接口管理表",eobj.id,eobj.MKBINMDesc,"U",eobj,bobj)
            }else{
                Trollback
                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
                s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("知识库接口管理表","web.DHCBL.MKB.MKBInterfaceManage","SaveData",eobj)
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
/// Other: w ##class(web.DHCBL.MKB.MKBInterfaceManage).GetRefFlag(12)
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""
    
    s MKBBETRowId=0,flag=0
    for
    {
        s MKBBETRowId=$o(^User.MKBBusExecuteD(MKBBETRowId)) q:(MKBBETRowId="")||(flag=1)  d
        
        s MKBBETInterfDr=$LISTGET($G(^User.MKBBusExecuteD(MKBBETRowId)),8)
        i (MKBBETInterfDr=id)
        {
            s flag=1
            s myInfo=myInfo_"<业务执行表>"
        }
    }
    
    i ($o(^User.MKBInterfaceManageI("ParentIndex",id,""))){
        s myInfo=myInfo_"<知识库接口管理表>"
    }
        
    i myInfo="" s return="0^未被引用可删除!"
    else  s return="1^在"_myInfo_"表里被引用,不能删除!"
    q return
}

/// Creator:高姗姗
/// CreatDate:2014-10-30
/// Description:根据id删除
/// Table:User.MKBInterfaceManage
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.MKB.MKBInterfaceManage).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
    s return="",myInfo=""
    s re=##class(web.DHCBL.MKB.MKBInterfaceManage).GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag'=0){
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    }
    else
    {
        Tstart
        s eobj = ##class(web.Entity.MKB.MKBInterfaceManage).%New()
        s pobj = ##class(User.MKBInterfaceManage).%OpenId(id)
        s eobj.MKBINMRowId = id
        s eobj.MKBINMCode = pobj.MKBINMCode
        s eobj.MKBINMDesc = pobj.MKBINMDesc
        s:pobj.MKBINMLastLevel'="" eobj.MKBINMLastLevel = pobj.MKBINMLastLevel.%Id()
        s eobj.MKBINMFunction = pobj.MKBINMFunction
        s eobj.MKBINMReturnValue = pobj.MKBINMReturnValue
        s eobj.MKBINMRemark = pobj.MKBINMRemark
        s eobj.MKBINMLevel = pobj.MKBINMLevel
        s eobj.MKBINMActive = pobj.MKBINMActive
    
        s sc=##class(User.MKBInterfaceManage).%DeleteId(id)
        if $$$ISOK(sc){
            Tcommit
            s result="{success:'true',info:'删除成功！'}"
            d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_InterfaceManage","User.MKBInterfaceManage","知识库接口管理表",id,eobj.MKBINMDesc,"D",eobj)
        }
        else{
            Trollback
            s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("知识库接口管理表","web.DHCBL.MKB.MKBInterfaceManage","DeleteData",eobj)
            s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
        }
    }
    q result
}

/// Description:顺序自动生成  获取顺序最大值
/// w ##class(web.DHCBL.MKB.MKBInterfaceManage).GetLastSort(8)
ClassMethod GetLastSort(LastLevel) As %String
{
    if (LastLevel="") s LastLevel=-100000000000000
    s LastSort=""
    if ($d(^User.MKBInterfaceManageI("ParentIndex",LastLevel))>0){
        s sort=0
        for{
          s sort=$o(^User.MKBInterfaceManageI("ParentIndex",LastLevel,sort)) q:sort="" 
          s LastSort=sort
        }   
    }else{
        s LastSort="1"
    }
    q LastSort
}

/// 根据id获取描述
ClassMethod GetDesc(RowId As %String) As %String
{
    ;w ##class(web.DHCBL.MKB.MKBInterfaceManage).GetDesc("6")
    s MKBINMDesc=""
    if (RowId'=""){
        s MKBINMDesc=$LISTGET($G(^User.MKBInterfaceManageD(RowId)),3)
    }
    q MKBINMDesc
}

/// 获取上级分类及描述
/// w ##class(web.DHCBL.MKB.MKBInterfaceManage).GetLastLevel(2)
ClassMethod GetLastLevel(id) As %String
{
    s myLastLevel =$LISTGET($G(^User.MKBInterfaceManageD(id)),6)
    s myLastDesc=""
    s:myLastLevel'="" myLastDesc=$LISTGET($G(^User.MKBInterfaceManageD(myLastLevel)),3)
    s LastLevel=myLastLevel_"^"_myLastDesc
    q LastLevel
}

ClassMethod DragNode(id, parentid, orderstr) As %String
{
    s result=""
    s:parentid="TreeRoot" parentid=""
    s obj=##class(User.MKBInterfaceManage).%OpenId(id)
    d:parentid="" obj.MKBINMLastLevelSetObjectId("")
    d:parentid'="" obj.MKBINMLastLevelSetObjectId(parentid)

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
           s obj=##class(User.MKBInterfaceManage).%OpenId(rowid)
           s obj.MKBINMLevel =i
           s sc=obj.%Save()
           d obj.%Close()             
        }
    }else{
        Trollback
        s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
    }
    q result
}

/// 取平台配置的密码
/// w ##class(web.DHCBL.MKB.MKBAssessmentBase).findPassWord()
ClassMethod findPassWord() As %String
{
	//取index
	s pwIndex=""
	s pwIndex=$o(^User.BDPPlatformConfigI("ConfigCodeI"," INTERFACEMANAGEPASSWORD",0))
	s password=$LISTGET($G(^User.BDPPlatformConfigD(pwIndex)),3)
	q password
}

}
