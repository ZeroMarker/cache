/// 关于界面元素授权的维护
/// 2013-5-21 by lisen
Class web.DHCBL.Authorize.Executables Extends web.BDP.sys.ExtPreferencesSubKey
{

/// d ##class(web.DHCBL.Authorize.Executables).DHCSaveDataToServer("G","1","[{ID:1},{ID:2}]","CT_UOM")
/// w ##class(web.DHCBL.Authorize.Executables).DHCGetDataByReference("G","1","CT_UOM")
/// Element
Parameter ParaAppKey = "E";

Parameter EntityClassName = "web.Entity.Authorize.Executables";

Parameter DataSplitString = "JSON";

/// 获取功能JSON串
/// 分级
ClassMethod GetExecutableTreeJson(ParentID As %String) As %String
{
    if (ParentID="ExecutablegroupTreeRoot") s ParentID=-100000000000000
    s mySMRowID=0
    s myMenuCount=0
    s mySMSeq=0
    k myMenuArray
    
    //生成菜单索引数组
    s mySMSeq=0
    s n=0
    for {
        s mySMSeq=$o(^User.BDPMenuI("ParSeqIdx",ParentID,mySMSeq))
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
            s mySMRowID=$o(^User.BDPMenuI("ParSeqIdx",ParentID," "_mySMSeq,mySMRowID))
            q:(mySMRowID="")
            s myMenuCount=myMenuCount+1
            s myMenuArray(myMenuCount)=mySMRowID
            ;w !,mySMRowID
        }
    }
    
    //输出菜单JSON串
    s mySMRowID=0
    s myMenuSeq=0
    s myJsonStr=""
    for {
        s myMenuSeq=$o(myMenuArray(myMenuSeq))
        q:(myMenuSeq="")
        s mySMRowID=$g(myMenuArray(myMenuSeq))
        ;continue:mySMRowID=1 //屏蔽菜单:"系统配置"
        ;continue:mySMRowID=282 //屏蔽菜单:"产品组配置"
        
        s myMenuObj=##Class(User.BDPMenu).%OpenId(mySMRowID,0)
        if $IsObject(myMenuObj) {
            s myCode = myMenuObj.Code
            s myCaption = myMenuObj.Caption
            s myLinkUrl = myMenuObj.LinkUrl
            s myImage = myMenuObj.Image
            s:myImage'="" myImage= "../scripts/bdp/Framework/BdpIconsLib/"_myMenuObj.Image
            s myFuntionDR = myMenuObj.LinkFuntionDR
            s myExeCode = myMenuObj.LinkFuntionDR.Code
            s myActiveFlag = myMenuObj.ActiveFlag
            continue:(myActiveFlag'="")&&('$p(myActiveFlag,"^",2)) //查看该菜单是否被激活
            
            //判断是否有子菜单
            if (myLinkUrl="") s myChildFlag=1
            else  s myChildFlag=0
            
            s:(myJsonStr'="") myJsonStr=myJsonStr_","
            s myJsonStr=myJsonStr_"{"
            s myJsonStr=myJsonStr_"""id"":"""_""_mySMRowID_""",""text"":"""_myCaption_""","
            s myJsonStr=myJsonStr_"""icon"":"""_""_myImage_""","
            
            if (+myChildFlag'=0) {
                s myJsonStr=myJsonStr_"""leaf"":false,"
                s myJsonStr=myJsonStr_"""expanded"":true"
                //获取子菜单
                ;s myJsonStr=myJsonStr_"""children"":"_..GetExecutableTreeJson(mySMRowID)
            }else {
                s myJsonStr=myJsonStr_"""myExeCode"":"""_""_myExeCode_""","
                s myJsonStr=myJsonStr_"""leaf"":true"
            }
            s myJsonStr=myJsonStr_"}"
            
            d myMenuObj.%Close()
        }
    }
    
    k myMenuArray
    s myJsonStr="["_myJsonStr_"]"
    
    q myJsonStr
}

/// 获取功能JSON串
/// 不分级
ClassMethod GetExecutableTreeJson2(ExecutableDesc = "")
{
    s ETID = 0
    s code = ""
    s ETRTNJson = ""
    f  s ETID = $o(^User.BDPExecutablesD(ETID)) q:ETID=""  d
    .s obj = ##Class(User.BDPExecutables).%OpenId(ETID)
    .s code = obj.Code
    .s Caption = obj.Caption
    .if ($ZCONVERT(Caption,"U")[$ZCONVERT(ExecutableDesc,"U")) d
    ..if ETRTNJson="" d
    ...s ETRTNJson=ETRTNJson_"{id:'"_code_"',text:'"_Caption_"',leaf:true}"
    ..else  d
    ...s ETRTNJson=ETRTNJson_",{id:'"_code_"',text:'"_Caption_"',leaf:true}"
    q "["_ETRTNJson_"]"
}

/// modified by chenying  @2014-10-20
/// 添加一键禁用删除限制
/// w ##class(web.DHCBL.Authorize.Executables).GetDisableItemJson("G","1","SS_User")
ClassMethod GetDisableItemJson(ObjectType As %String, ObjectReference As %String, SubKey As %String) As %String
{
    //s ^temp("efase")=ObjectType_"^"_ObjectReference_"^"_SubKey
    q:ObjectReference="" "{data:[], success:true, total:0}"
    q:SubKey="" "{data:[], success:true, total:0}"
    s ItemJson="",Count=0
    //前台传的SubKey改为菜单ID，再通过菜单ID获取到SubKey
    s haveflag=##class(web.DHCBL.CT.FunctionalElement).HaveItems(SubKey)
    if (haveflag="N")	//菜单没有维护元素
    {
	    s myFuntionDR = $LISTGET($G(^User.BDPMenuD(SubKey)),4)
		s SubKey=""
		s:myFuntionDR'="" SubKey=$LISTGET($G(^User.BDPExecutablesD(myFuntionDR)),4)
	    s ItemStr=##class(web.DHCBL.Authorize.Executables).DHCGetDataByReference(ObjectType,ObjectReference,SubKey)
	    s:SubKey'="" SubKey=$ZCONVERT(SubKey,"U")
	    s ExecutableID = $o(^User.BDPExecutablesI("CodeIndex"," "_SubKey,""))
	    s ItemID=0
	    f  s ItemID=$o(^User.BDPExecutablesD(ExecutableID,"ChildExtExecItem",ItemID)) q:ItemID=""  d
	    .s Name=$LISTGET($G(^User.BDPExecutablesD(ExecutableID,"ChildExtExecItem",ItemID)),37)
	    .s Type=$LISTGET($G(^User.BDPExecutablesD(ExecutableID,"ChildExtExecItem",ItemID)),32)
	    .s rowid=ExecutableID_"||"_ItemID
	    .s ItemStr2="{ID:"_rowid_"}"
	    
	    .s delflag=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPDisableDel")   ///chenying，20140928，一键禁用删除按钮
	     
	    .if (Type ["D")&(Type'="DF")&(delflag = "Y")&(ItemStr="") d
	    ..if ItemJson'="" d
	    ...s ItemJson =ItemJson_",{ID:"""_rowid_""",Name:"""_Name_"""}"
	    ..else  d
	    ...s ItemJson =ItemJson_"{ID:"""_rowid_""",Name:"""_Name_"""}"
	    ..s Count=Count+1
	    
	    .else  d  //禁用但是有授权 或 不禁用 ，则取授权串
	    ..if (ItemStr[ItemStr2) d //如果有权则输出
	    ...if ItemJson'="" d
	    ....s ItemJson =ItemJson_",{ID:"""_rowid_""",Name:"""_Name_"""}"
	    ...else  d
	    ....s ItemJson =ItemJson_"{ID:"""_rowid_""",Name:"""_Name_"""}"
	    ...s Count=Count+1

	    s ItemJson = "{data:["_ItemJson_"], success:true, total:"_Count_"}"
    }
    else
    {
	    s MenuID=SubKey
	    s ItemStr=##class(web.DHCBL.Authorize.Executables).DHCGetDataByReference(ObjectType,ObjectReference,SubKey)
	    s delflag=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPDisableDel")   ///chenying，20140928，一键禁用删除按钮
	    	
		s ItemID=""
		for
		{
			s ItemID=$o(^User.BDPMenuD(MenuID,"ChildItem",ItemID))  //遍历别名表
			q:ItemID=""
			s ItemCode=$lg($g(^User.BDPMenuD(MenuID,"ChildItem",ItemID)),2)   //功能元素代码
			s ItemName=$lg($g(^User.BDPMenuD(MenuID,"ChildItem",ItemID)),3)		//功能元素名称
			s ItemType=$lg($g(^User.BDPMenuD(MenuID,"ChildItem",ItemID)),4)		//按钮类型
			
			s rowid=MenuID_"||"_ItemID
			s ItemStr2="{ID:"_rowid_"}"
			
	    	if (ItemType ["D")&(ItemType'="DF")&(delflag = "Y")&(ItemStr="") 
		    {
			    if ItemJson'="" 
		    	{
			    	s ItemJson =ItemJson_",{ID:"""_rowid_""",Name:"""_ItemName_"""}"
		    	}
			    else  
			    {
				    s ItemJson =ItemJson_"{ID:"""_rowid_""",Name:"""_ItemName_"""}"
			    }
		    	s Count=Count+1
		    }
		    else    //禁用但是有授权 或 不禁用 ，则取授权串
		    {
			    if (ItemStr[ItemStr2)  //如果有权则输出
		    	{
			    	if ItemJson'="" 
		    		{
			    		s ItemJson =ItemJson_",{ID:"""_rowid_""",Name:"""_ItemName_"""}"
		    		}
		    		else  
		    		{
			    		s ItemJson =ItemJson_"{ID:"""_rowid_""",Name:"""_ItemName_"""}"
		    		}
		    		s Count=Count+1
		    	}
		    }
		}
		s ItemJson = "{data:["_ItemJson_"], success:true, total:"_Count_"}"
    }
    q ItemJson
}

/// modified by chenying  @2014-10-20
/// 添加一键禁用删除限制
/// w ##class(web.DHCBL.Authorize.Executables).GetAbleItemJson("G","1","SS_User")
ClassMethod GetAbleItemJson(ObjectType As %String, ObjectReference As %String, SubKey As %String) As %String
{
    q:ObjectReference="" "{data:[], success:true, total:0}"
    q:SubKey="" "{data:[], success:true, total:0}"
    s ItemJson="",Count=0
    //前台传的SubKey改为菜单ID，再通过菜单ID获取到SubKey
    s haveflag=##class(web.DHCBL.CT.FunctionalElement).HaveItems(SubKey)
    if (haveflag="N")	//菜单没有维护元素
    {
	    s myFuntionDR = $LISTGET($G(^User.BDPMenuD(SubKey)),4)
		s SubKey=""
		s:myFuntionDR'="" SubKey=$LISTGET($G(^User.BDPExecutablesD(myFuntionDR)),4)
		
	    s ItemStr=##class(web.DHCBL.Authorize.Executables).DHCGetDataByReference(ObjectType,ObjectReference,SubKey)
	    s:SubKey'="" SubKey=$ZCONVERT(SubKey,"U")
	    s ExecutableID = $o(^User.BDPExecutablesI("CodeIndex"," "_SubKey,""))
	    s ItemID=0
	    f  s ItemID=$o(^User.BDPExecutablesD(ExecutableID,"ChildExtExecItem",ItemID)) q:ItemID=""  d
	    .s Name=$LISTGET($G(^User.BDPExecutablesD(ExecutableID,"ChildExtExecItem",ItemID)),37)
	    .s Type=$LISTGET($G(^User.BDPExecutablesD(ExecutableID,"ChildExtExecItem",ItemID)),32)
	    .s rowid=ExecutableID_"||"_ItemID
	    .s ItemStr2="{ID:"_rowid_"}"

	    .s delflag=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPDisableDel")   ///chenying，20140928，一键禁用删除按钮
	    
	    .q:((Type["D")&(Type'="DF")&(delflag = "Y")&(ItemStr=""))||(ItemStr[ItemStr2) //如果有权则跳到下一条
	    
	    .if ItemJson'="" d
	    ..s ItemJson =ItemJson_",{ID:"""_rowid_""",Name:"""_Name_"""}"
	    .else  d
	    ..s ItemJson =ItemJson_"{ID:"""_rowid_""",Name:"""_Name_"""}"
	    .s Count=Count+1
	    s ItemJson = "{data:["_ItemJson_"], success:true, total:"_Count_"}"
    }
    else		//从菜单配置的功能元素中取
    {
	    s MenuID=SubKey
	    s ItemStr=##class(web.DHCBL.Authorize.Executables).DHCGetDataByReference(ObjectType,ObjectReference,SubKey)
	    s delflag=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPDisableDel")   ///chenying，20140928，一键禁用删除按钮
		s ItemID=""
		for
		{
			s ItemID=$o(^User.BDPMenuD(MenuID,"ChildItem",ItemID))  //遍历别名表
			q:ItemID=""
			s ItemCode=$lg($g(^User.BDPMenuD(MenuID,"ChildItem",ItemID)),2)   //功能元素代码
			s ItemName=$lg($g(^User.BDPMenuD(MenuID,"ChildItem",ItemID)),3)		//功能元素名称
			s ItemType=$lg($g(^User.BDPMenuD(MenuID,"ChildItem",ItemID)),4)		//按钮类型
			
			s rowid=MenuID_"||"_ItemID
			s ItemStr2="{ID:"_rowid_"}"
			
	    	
	    	continue:((ItemType["D")&(ItemType'="DF")&(delflag = "Y")&(ItemStr=""))||(ItemStr[ItemStr2) //如果有权则跳到下一条
	    
		    if (ItemJson'="") 
		    {
			    s ItemJson =ItemJson_",{ID:"""_rowid_""",Name:"""_ItemName_"""}"
		    }
		    else  
		    {
			    s ItemJson =ItemJson_"{ID:"""_rowid_""",Name:"""_ItemName_"""}"
		    }
		    s Count=Count+1
		}
		s ItemJson = "{data:["_ItemJson_"], success:true, total:"_Count_"}"
    }
	
    q ItemJson
}

/// 用于元素授权页面中功能项颜色区分
/// w ##class(web.DHCBL.Authorize.Executables).GetItemPreferences("G","1")
ClassMethod GetItemPreferences(ObjectType As %String, ObjectReference As %String) As %String
{
    //^User.BDPPreferencesI("UqIndex"," G"," 1"," E"," OEC_ORDERCATEGORY",5)
    s json=""
    
    s sub=""
    for {
        s sub=$o(^User.BDPPreferencesI("UqIndex"," "_ObjectType," "_ObjectReference," E",sub))
        q:sub=""
        ;s rowid=$o(^User.BDPPreferencesI("UqIndex"," "_ObjectType," "_ObjectReference," E",sub,""))
        ;s AppSubKey=$LISTGET($g(^User.BDPPreferencesD(rowid)),2)
        ;s data=$LISTGET($g(^User.BDPPreferencesD(rowid)),7)
        s tablesID=$o(^User.BDPExecutablesI("CodeIndex",sub,""))
        s menuID=""
        for {
            s menuID=$o(^User.BDPMenuD(menuID))
            q:menuID=""
            s menuFunDR=$LISTGET($G(^User.BDPMenuD(menuID)),4)
            if (menuFunDR=tablesID) {
                if (json'="") {
                    s json =json_",{ID:"""_menuID_"""}"
                }
                else {
                    s json =json_"{ID:"""_menuID_"""}"
                }
                q
            }
        }
    }
    
    s json="["_json_"]"
    q json
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

}
