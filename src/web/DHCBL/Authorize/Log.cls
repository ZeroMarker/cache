/// 日志授权
/// 2015-07-09
/// 基础数据平台 陈莹
Class web.DHCBL.Authorize.Log Extends web.BDP.sys.ExtPreferences
{

/// w ##class(web.DHCBL.Authorize.Log).SaveAuthorizeData("G","1","[{ID:1},{ID:2}]")
/// w ##class(web.DHCBL.Authorize.Log).GetTreeJson("menuTreeRoot","G","1")
Parameter ParaAppKey = "SYS";

Parameter ParaAppSubKey = "Log";

Parameter EntityClassName = "web.Entity.Authorize.Log";

Parameter DataSplitString = "JSON";

/// 获取授权的Data
ClassMethod GetAutJson(ObjectType As %String, ObjectReference As %String) As %String
{
	s strAutMenu=##class(web.DHCBL.Authorize.Log).DHCGetDataByReference(ObjectType,ObjectReference)
	q strAutMenu
}

/// 一级授权中获取Tree类型的json串
/// ParentID： 父ID
/// ObjectType: 需要显示的优先级类别
/// ObjectReference： 在界面上 选择的 Group或者User或者CTLoc(登录科室)
ClassMethod GetTreeJson(ParentID As %String, ObjectType As %String, ObjectReference As %String) As %String
{
	if (ParentID="menuTreeRoot") s ParentID=-100000000000000
	;q:ObjectReference="" ""
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
	
	//获取授权JSON
	;s strAutMenu=##class(web.DHCBL.Authorize.Log).DHCGetDataByReference(ObjectType,ObjectReference)
	
	//输出菜单JSON串
	s mySMRowID=0
	s myMenuSeq=0
	s myJsonStr=""
	for {
		;q:(+myMenuSeq>1)
		s myMenuSeq=$o(myMenuArray(myMenuSeq))
		q:(myMenuSeq="")
		s mySMRowID=$g(myMenuArray(myMenuSeq))
		
		s myMenuObj=##Class(User.BDPMenu).%OpenId(mySMRowID,0)
		if $IsObject(myMenuObj) {
			s myCode = myMenuObj.Code
			s myCaption = myMenuObj.Caption
			s myLinkUrl = myMenuObj.LinkUrl
			s myImage = myMenuObj.Image
			s:myImage'="" myImage= "../scripts/bdp/Framework/BdpIconsLib/"_myMenuObj.Image
			/*if (myImage'=""){
				s:(($e(myImage,1)="/")||($e(myImage,1)="\")) myImage=$e(myImage,2,$l(myImage))
				s myImage=$tr(myImage,"\","/")
				s myImage="../scripts/bdp/Framework/icons/"_myImage
			}*/
			
			//判断是否有子菜单
			if ((myLinkUrl="")) s myChildFlag=1
			else  s myChildFlag=0
			/*
			//判断菜单是否已授权,有则checked:true
			s strMenu="{ID:"_mySMRowID_"}"
			if (strAutMenu[strMenu) s myMenuEnable=1
			else  s myMenuEnable=0
			*/
			s:(myJsonStr'="") myJsonStr=myJsonStr_","
			s myJsonStr=myJsonStr_"{"
			s myJsonStr=myJsonStr_"""id"":"""_""_mySMRowID_""",""text"":"""_myCaption_""","
			s myJsonStr=myJsonStr_"""iconCls"":"""_""_myImage_""","
			
			s myJsonStr=myJsonStr_"""checked"":false,"
			/*if (+myMenuEnable){
				s myJsonStr=myJsonStr_"""checked"":true,"
			}else{
				s myJsonStr=myJsonStr_"""checked"":false,"
			}*/
			if (+myChildFlag'=0) {
				s myJsonStr=myJsonStr_"""leaf"":false,"
				s myJsonStr=myJsonStr_"""expanded"":true,"
				//获取子菜单
				s myJsonStr=myJsonStr_"""children"":"_..GetTreeJson(mySMRowID,ObjectType,ObjectReference)
			}else {
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

/// 二级授权中获取Tree类型的json串, 界面的控件也可以是Grid
/// 功能描述： 根据当前登录用户(有二级授权用户的)的Session信息获取到该用户可以  给别人授权的数据；
/// ParentID： 父ID
/// ObjectType: 需要显示的优先级类别
/// ObjectReference： 在界面上 选择的 Group或者User或者CTLoc(登录科室)
/// SessionStr: session串
/// w ##class(web.DHCBL.Authorize.Log).GetTreeJson2("menuTreeRoot","G",1,"^1^102^1^^DHCHEALTH^^")
ClassMethod GetTreeJson2(ParentID As %String, ObjectType As %String, ObjectReference As %String, SessionStr As %String) As %String
{
	s grpId=$p(SessionStr,"^",4)
	;s ^temp("aa")=SessionStr
	if (ParentID="menuTreeRoot") s ParentID=-100000000000000
	;q:ObjectReference="" ""
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
	
	//获取授权JSON
	;s strAutMenu=##class(web.DHCBL.Authorize.Log).DHCGetDataByReference(ObjectType,ObjectReference)
	s strAutMenu2=##class(web.DHCBL.Authorize.Log).DHCGetDataByDefaultSession()
	
	//输出菜单JSON串
	s mySMRowID=0
	s myMenuSeq=0
	s myJsonStr=""
	for {
		;q:(+myMenuSeq>1)
		s myMenuSeq=$o(myMenuArray(myMenuSeq))
		q:(myMenuSeq="")
		s mySMRowID=$g(myMenuArray(myMenuSeq))
		
		s myMenuObj=##Class(User.BDPMenu).%OpenId(mySMRowID,0)
		if $IsObject(myMenuObj) {
			s myCode = myMenuObj.Code
			s myCaption = myMenuObj.Caption
			s myLinkUrl = myMenuObj.LinkUrl
			s myImage = myMenuObj.Image
			s:myImage'="" myImage= "../scripts/bdp/Framework/BdpIconsLib/"_myMenuObj.Image
			s myActiveFlag = myMenuObj.ActiveFlag
			
			
			s Activeflag =$p(myActiveFlag,"^",1)
			
		
			/*if (myImage'=""){
				s:(($e(myImage,1)="/")||($e(myImage,1)="\")) myImage=$e(myImage,2,$l(myImage))
				s myImage=$tr(myImage,"\","/")
				s myImage="../scripts/bdp/Framework/icons/"_myImage
			}*/
			
			//判断是否有子菜单
			if ((myLinkUrl="")) s myChildFlag=1
			else  s myChildFlag=0
			
			//判断菜单是否已授权,有则checked:true
			s strMenu="{ID:"_mySMRowID_"}"
			/*if (strAutMenu[strMenu) s myMenuEnable=1
			else  s myMenuEnable=0*/
			
			//判断菜单是否有权显示
			if (((strAutMenu2[strMenu)||(1=grpId))&(Activeflag=1)) s myMenuEn=1
			else  s myMenuEn=0
			
			if (+myMenuEn) {
				s:(myJsonStr'="") myJsonStr=myJsonStr_","
				s myJsonStr=myJsonStr_"{"
				s myJsonStr=myJsonStr_"""id"":"""_""_mySMRowID_""",""text"":"""_myCaption_""","
				s myJsonStr=myJsonStr_"""icon"":"""_""_myImage_""","
				
				s myJsonStr=myJsonStr_"""checked"":false,"
				/*
				if (+myMenuEnable){
					s myJsonStr=myJsonStr_"""checked"":true,"
				}else{
					s myJsonStr=myJsonStr_"""checked"":false,"
				}
				*/
				if (+myChildFlag'=0) {
					s myJsonStr=myJsonStr_"""leaf"":false,"
					s myJsonStr=myJsonStr_"""expanded"":true"
					//获取子菜单
					//s myJsonStr=myJsonStr_"""children"":"_..GetTreeJson2(mySMRowID,ObjectType,ObjectReference,SessionStr)
				}else {
					s myJsonStr=myJsonStr_"""leaf"":true"
				}
				s myJsonStr=myJsonStr_"}"
			}
			
			d myMenuObj.%Close()
		}
	}
	
	k myMenuArray
	s myJsonStr="["_myJsonStr_"]"
	
	q myJsonStr
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
