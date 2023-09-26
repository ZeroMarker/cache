/// 国家标准编码类别对照
/// 2016-4-12 by GuXueping
Class web.DHCBL.BDP.BDPNATDataConstract Extends web.BDP.sys.ExtPreferences
{

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
			//查看该菜单是否被激活（资源定义和分配资源到科室在授权页面不显示）
			continue:(myActiveFlag'="")&&('$p(myActiveFlag,"^",1))		
			continue:(myCode="dhc.bdp.KB")||(myCode="dhc.bdp.System")||(myCode="dhc.bdp.ProductConfig")  //系统配置、产品配置、临床知识库
			continue:(myCode="dhc.bdp.DHCST.DrugStock")||(myCode="dhc.bdp.DHCSTM.DrugStock")||(myCode="dhc.bdp.dhcopbillmenumaintenance")||(myCode="dhc.bdp.dhcem")||(myCode="dhc.bdp.dhcappreport")  //药品、物资、计费维护、分诊急诊维护、检查预约
			continue:(myCode="dhc.bdp.system.SystemParameter")||(myCode="dhc.bdp.system.INCSysCounter")||(myCode="DHC.BedFeeSet")||(myCode="DHC.BedFeeSet")||(myCode="dhc.bdp.OrderItem.INCItmTar")||(myCode="dhc.bdp.OrderItem.BDPItemCategory")||(myCode="dhc.bdp.dhcopbillmenu.settaritem2")  //系统参数、系统计数类型、床位费用设置、物流项物价信息维护、收费项目分类、收费项目查询新
			continue:(myCode="dhc.bdp.Order.RecLocSelect")||(myCode="dhc.bdp.resource.RBResource")||(myCode="dhc.bdp.Resource.RBResourceForEQ")||(myCode="dhc.bdp.KB.Dic.DHC_SymptomFeild")||(myCode="dhc.bdp.KB.Dic.DHC_SymptomLev")||(myCode="dhc.bdp.Stock.CTConFac")  //查询接收科室、资源定义、分配资源到科室、his症状字典、症状分级表、单位转换
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
				s myJsonStr=myJsonStr_"""myCode"":"""_""_myCode_""","
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

/// w ##class(web.DHCBL.BDP.BDPNATDataConstract).GetTreeJson("DHC.BDP.CARE.CTCAREPROV","","G","1",0,20,"","")
ClassMethod GetTreeJson(AutCode As %String, ParentID As %String, ObjectType As %String, ObjectReference As %String, start, limit, query, FilterCK) As %String
{
	if (ParentID="menuTreeRoot") s ParentID=-100000000000000
	
	s myJsonStr=""
	s myImage=""
	s:AutCode'="" AutCode=$ZCONVERT(AutCode,"U") //转换成大写
	
	//获取菜单已对照的表
	s AuStr=..GetAutJson(ObjectType, ObjectReference,AutCode)
	
	s RowId=0
	s count=0
	s end=start+limit
	
	for{
		s RowId=$o(^BDPDOMAINTYPE(RowId))
		q:RowId=""
		
	
			//过滤已选、未选
		s AuStr2="{ID:"_RowId_"}"
		if (FilterCK="checked") {
			if (AuStr[AuStr2) 
			else  continue
		}
		elseif (FilterCK="unchecked") {
			if (AuStr[AuStr2) continue
			else  
		}
			
		s Desc=$p($g(^BDPDOMAINTYPE(RowId)),"^",5)       
		continue:Desc=""
		//s Desc=$tr(Desc,$c(13,10),"")
		s Desc=##class(ext.util.String).EvalJSON(Desc)
		
		if ($ZCONVERT(Desc,"U")[$ZCONVERT(query,"U")){
			s count=count+1
			if ((count>start) & (count<=end)) || (end=0){
				s AuStr2="{ID:"_RowId_"}"
				if (AuStr[AuStr2) s myEnable=1
				else  s myEnable=0
				
				s:(myJsonStr'="") myJsonStr=myJsonStr_","
				s myJsonStr=myJsonStr_"{"
				s myJsonStr=myJsonStr_"""id"":"""_""_RowId_""",""text"":"""_Desc_""","
				
				if (+myEnable){
					s myJsonStr=myJsonStr_"""checked"":true,"
				}else{
					s myJsonStr=myJsonStr_"""checked"":false,"
				}
				s myJsonStr=myJsonStr_"""leaf"":true"
				s myJsonStr=myJsonStr_"}"
			}
		}
	}
	s myJsonStr="{data:["_myJsonStr_"],totalCount:"_count_"}"
	
	q myJsonStr
}

/// 保存基础数据授权
/// w ##class(web.DHCBL.BDP.BDPNATDataConstract).SaveConstractData("G","1","1||2^3","dhc.bdp.Care.CTCarPrvTp")
ClassMethod SaveConstractData(ObjectType As %String, ObjectReference As %String, Data As %String, AutCode As %String) As %String
{
	s flag=""  
	s result=""
	s AuStr=""
	s:AutCode'="" Code=$ZCONVERT(AutCode,"U") //转换成大写
	s deleteStr=$p(Data,"||",1)  //以前选中，现在没选中的数据，删除
	s addStr=$p(Data,"||",2)  //以前没有，现在选中的数据，加上
	TS
	if (deleteStr'=""){
		s deleteLen=$Length(deleteStr,"^")
		for i=1:1:deleteLen		
		{
			s deleteid=$p(deleteStr,"^",i)
			s NATDataType=$p($g(^BDPDOMAINTYPE(deleteid)),"^",4)
	 	 	s:NATDataType'="" NATDataType=$ZCONVERT(NATDataType,"U") //转换成大写
			s idc=$o(^User.BDPMenuNATDataTypeI("contrast"," "_Code," "_NATDataType,0))
			s sc=##class(User.BDPMenuNATDataType).%DeleteId(idc)
			IF $$$ISOK(sc) {	  
				s flag=flag_"^"_1
			}else {
				s flag=flag_"^"_0
			}
		}
	}
	//b ;1
	if (addStr'=""){
		s addLen=$Length(addStr,"^")
		for i=1:1:addLen		
		{					
			s addid=$p(addStr,"^",i)
			s Table=$p($g(^BDPDOMAINTYPE(addid)),"^",4)
	 	 	s obj=##class(User.BDPMenuNATDataType).%New()
			s obj.Menu=AutCode
			s obj.NATDataType=Table
			s sc=obj.%Save()
			If $$$ISOK(sc){
				s flag=flag_"^"_1
			}else{
				s flag=flag_"^"_0
			}
			d obj.%Close()			
			
		}
	}
	//b ;2
	if (flag[0)
	{		
		Trollback
		s result = "{success:'false',errorinfo:'保存失败！'}"			
	}
	else
	{
		Tc
		s result = "{success:'true',info:'保存成功！'}"	
	}
	q result
}

/// 获取已经对照的Data
/// w ##class(web.DHCBL.BDP.BDPNATDataConstract).GetAutJson("G","1","dhc.bdp.System.SSUser")
ClassMethod GetAutJson(ObjectType As %String, ObjectReference As %String, AutCode) As %String
{
	s:AutCode'="" AutCode=$ZCONVERT(AutCode,"U") //转换成大写
	s AuStr=""
	s ID=0
 	for{
	    s ID=$o(^BDPDOMAINTYPE(ID)) q:ID=""  
 	 	s NATDataType=$p($g(^BDPDOMAINTYPE(ID)),"^",4)
 	 	s:NATDataType'="" NATDataType=$ZCONVERT(NATDataType,"U") //转换成大写	
 	 	s flagc=$d(^User.BDPMenuNATDataTypeI("contrast"," "_AutCode," "_NATDataType))
 	 	if (flagc>0){
	 	 	if (AuStr=""){
		 	 	s AuStr="{ID:"_ID_"}"
	 	 	}else{
		 	 	s AuStr=AuStr_",{ID:"_ID_"}"
	 	 	}
 	 	}
 	}
 	s AuStr="["_AuStr_"]"
	q AuStr
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
