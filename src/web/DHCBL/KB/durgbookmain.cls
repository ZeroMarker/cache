/// 知识库 药品说明书
/// by caihz 2014-12-3
Class web.DHCBL.KB.durgbookmain Extends %RegisteredObject
{

/// Creator：蔡昊哲
/// CreatDate: 2014-12-3
/// Description：获取药品说明书list
/// Table：User.DHCAllergyFeild
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCAllergyFeild","GetList","","","","","")
Query GetList(rowid, code, desc) As %Query(ROWSPEC = "ALFRowId,ALFCode,ALFDesc,ALFActiveFlag,ALFSysFlag")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, code, desc) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权Json
	//s AuStr=##class(web.DHCBL.Authorize.SSUser).DHCGetDataByDefaultSession()
	;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
	;假设未授权情况下默认全部显示数据
	//s AuFlag=0
	//if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s ALFRowId=rowid
		s ALFCode=$p($g(^DHCALLERGY(ALFRowId)),"^",1)  //代码
		s ALFDesc=$p($g(^DHCALLERGY(ALFRowId)),"^",2)  //描述
		s ALFActiveFlag=$p($g(^DHCALLERGY(ALFRowId)),"^",3)  //是否可用
		s ALFSysFlag=$p($g(^DHCALLERGY(ALFRowId)),"^",4)  //是否系统标识
		
		d OutputRow
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s ALFRowId=0
		for  
		{	
			s ALFRowId=$o(^DHCALLERGY(ALFRowId)) q:ALFRowId="" 
			s strRowId = "{ID:"_ALFRowId_"}"
			//i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			//{
				s ALFCode=$p($g(^DHCALLERGY(ALFRowId)),"^",1)  //代码
				s ALFCodeU=$ZCONVERT(ALFCode,"U")
				s ALFDesc=$p($g(^DHCALLERGY(ALFRowId)),"^",2)  //描述
				s ALFDescU=$ZCONVERT(ALFDesc,"U")
				s ALFActiveFlag=$p($g(^DHCALLERGY(ALFRowId)),"^",3)  //是否可用
				s ALFSysFlag=$p($g(^DHCALLERGY(ALFRowId)),"^",4)  //是否系统标识
		
				i (ALFCodeU[code)&(ALFDescU[desc)   //条件
				{
					d OutputRow
				}		
			//}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ALFRowId,ALFCode,ALFDesc,ALFActiveFlag,ALFSysFlag)
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

/// Creator：高姗姗
/// CreatDate: 2014-11-25
/// Description：查询药品通用名和剂型关联字典表内容
/// Table：User.DHCGenLinkPointer
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCGenLinkPointer","GetList","","","")
Query GetDrugList(rowid, gen, pointer) As %Query(ROWSPEC = "GlPRowId,GlPGenDr,PHEGDesc,GlPPointer,PHEFDesc,GlPActiveFlag,GlPSysFlag")
{
}

ClassMethod GetDrugListExecute(ByRef qHandle As %Binary, rowid, gen, pointer) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权Json
	//s AuStr=##class(web.DHCBL.Authorize.SSUser).DHCGetDataByDefaultSession()
	;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
	;假设未授权情况下默认全部显示数据
	//s AuFlag=0
	//if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s GlPRowId=rowid
		s GlPGenDr=$p($g(^DHCGENLINP(GlPRowId)),"^",1)  //通用名Dr
		s:GlPGenDr'="" PHEGDesc=$p($g(^DHCPHEGEN(GlPGenDr)),"^",2) //通用名名称 
		
		s PHEGLibDr=$p($g(^DHCPHEGEN(GlPGenDr)),"^",7) 
		s:PHEGLibDr'="" PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) //知识库标识 药品
		s PHLICode1=$ZCONVERT(PHLICode,"U")
		
		s GlPPointer=$p($g(^DHCGENLINP(GlPRowId)),"^",2)  //指针
		s:GlPPointer'="" PHEFDesc=$p($g(^DHCPHEF(GlPPointer)),"^",2) //指针名称 
		s GlPActiveFlag=$p($g(^DHCGENLINP(GlPRowId)),"^",3)  //是否可用
		s GlPSysFlag=$p($g(^DHCGENLINP(GlPRowId)),"^",4)  //是否系统标识
		
		d OutputRow
	}
	else
	{
		s:gen'="" gen=$ZCONVERT(gen,"U")
		s:pointer'="" text=$ZCONVERT(pointer,"U")
		s GlPRowId=0
		for  
		{	
			s GlPRowId=$o(^DHCGENLINP(GlPRowId)) q:GlPRowId="" 
			s strRowId = "{ID:"_GlPRowId_"}"
			//i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			//{
				s GlPGenDr=$p($g(^DHCGENLINP(GlPRowId)),"^",1)  //通用名Dr
				s GlPGenDrU=$ZCONVERT(GlPGenDr,"U")
				s:GlPGenDr'="" PHEGDesc=$p($g(^DHCPHEGEN(GlPGenDr)),"^",2) //通用名名称 
				
				s PHEGLibDr=$p($g(^DHCPHEGEN(GlPGenDr)),"^",7) 
				s:PHEGLibDr'="" PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) //知识库标识 药品
				s PHLICode1=$ZCONVERT(PHLICode,"U")
		
				s GlPPointer=$p($g(^DHCGENLINP(GlPRowId)),"^",2)  //指针
				s:GlPPointer'="" PHEFDesc=$p($g(^DHCPHEF(GlPPointer)),"^",2) //指针名称  
				s GlPPointerU=$ZCONVERT(GlPPointer,"U")
				s GlPActiveFlag=$p($g(^DHCGENLINP(GlPRowId)),"^",3)  //是否可用
				s GlPSysFlag=$p($g(^DHCGENLINP(GlPRowId)),"^",4)  //是否系统标识
		
				i (PHLICode1="PHIC")&((GlPPointerU=pointer)||(pointer=""))&((GlPGenDrU=gen)||(gen=""))   //条件
				{
					d OutputRow
				}		
			//}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(GlPRowId,GlPGenDr,PHEGDesc,GlPPointer,PHEFDesc,GlPActiveFlag,GlPSysFlag)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDrugListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDrugListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDrugListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDrugListExecute ]
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

/// Creator：蔡昊哲
/// CreatDate: 2014-11-24
/// Description：查询标识为药品的通用名字典表内容
/// Table：User.DHCPHExtGeneric
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHExtGeneric","GetList","","","","","")
Query GetGenList(rowid, code, desc, lib) As %Query(ROWSPEC = "PHEGRowId,PHEGCode,PHEGDesc,PHEGActiveFlag,PHEGLibDr,PHLIDesc,PHEGSysFlag")
{
}

ClassMethod GetGenListExecute(ByRef qHandle As %Binary, rowid, code, desc, lib) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权Json
	//s AuStr=##class(web.DHCBL.Authorize.SSUser).DHCGetDataByDefaultSession()
	;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
	;假设未授权情况下默认全部显示数据
	//s AuFlag=0
	//if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s PHEGRowId=rowid
		s PHEGCode=$p($g(^DHCPHEGEN(PHEGRowId)),"^",1)  //代码
		s PHEGDesc=$p($g(^DHCPHEGEN(PHEGRowId)),"^",2)  //描述
		s PHEGActiveFlag=$p($g(^DHCPHEGEN(PHEGRowId)),"^",6)  //是否可用
		s PHEGLibDr=$p($g(^DHCPHEGEN(PHEGRowId)),"^",7)  //知识库标识DR
		s:PHEGLibDr'="" PHLIDesc=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",2) //知识库标识名称
		s PHEGSysFlag=$p($g(^DHCPHEGEN(PHEGRowId)),"^",8)  //是否系统标识
		
		d OutputRow
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s:lib'="" lib=$ZCONVERT(lib,"U")
		s PHEGRowId=0
		for  
		{	
			s PHEGRowId=$o(^DHCPHEGEN(PHEGRowId)) q:PHEGRowId="" 
			s strRowId = "{ID:"_PHEGRowId_"}"
			//i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			//{
				s PHEGCode=$p($g(^DHCPHEGEN(PHEGRowId)),"^",1)  //代码
				s PHEGCodeU=$ZCONVERT(PHEGCode,"U")
				s PHEGDesc=$p($g(^DHCPHEGEN(PHEGRowId)),"^",2)  //描述
				s PHEGDescU=$ZCONVERT(PHEGDesc,"U")
				s PHEGActiveFlag=$p($g(^DHCPHEGEN(PHEGRowId)),"^",6)  //是否可用
				s PHEGLibDr=$p($g(^DHCPHEGEN(PHEGRowId)),"^",7)  //知识库标识DR
				s PHEGLibDrU=$ZCONVERT(PHEGLibDr,"U")
				s:PHEGLibDr'="" PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) //知识库标识代码
				s PHLICodeU=$ZCONVERT(PHLICode,"U")
				s:PHEGLibDr'="" PHLIDesc=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",2) //知识库标识名称
				s PHEGSysFlag=$p($g(^DHCPHEGEN(PHEGRowId)),"^",8)  //是否系统标识
				
				s DHCGenLin=##class(web.DHCBL.KB.DHCGenLinkPointer).GetJson(PHEGRowId,"PHIC")
				
				i (PHLICodeU="PHIC")&(PHEGCodeU[code)&(PHEGDescU[desc)&((PHEGLibDrU=lib)||(lib=""))   //条件
				{
					d OutputRow
				}		
			//}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PHEGRowId,PHEGCode,PHEGDesc,PHEGActiveFlag,PHEGLibDr,PHLIDesc,PHEGSysFlag)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetGenListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetGenListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
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

/// 2013-5-21 by 蔡昊哲
/// Description：获取菜单树,按字段'显示顺序'大小排序,用于BDPMain.js
/// Table：User.BDPMenu
/// Input：id:父节点rowid, SessionStr
/// Ohter: w ##class(web.DHCBL.BDP.BDPMenuDefine).GetMenu("menuTreeRoot","^^^1^^^^")
ClassMethod GetMenu1(id As %String, SessionStr As %String) As %String
{
 s grpId=$p(SessionStr,"^",4)
 if (id="menuTreeRoot") s id=-100000000000000
 s mySMRowID=0
 s myMenuCount=0
 s mySMSeq=0
 k myMenuArray
 
 //生成菜单索引数组
 s mySMSeq=0
 s n=0
 for {
  s mySMSeq=$o(^User.BDPMenuI("ParSeqIdx",id,mySMSeq))
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
   s mySMRowID=$o(^User.BDPMenuI("ParSeqIdx",id," "_mySMSeq,mySMRowID))
   q:(mySMRowID="")
   s myMenuCount=myMenuCount+1
   s myMenuArray(myMenuCount)=mySMRowID
   ;w !,mySMRowID
  }
 }
 
 //获取授权JSON
 s myGroupId=""
 s strAutMenu=##class(web.DHCBL.Authorize.Menu).DHCGetDataByDefaultSession()
 
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
   s myActiveFlag = myMenuObj.ActiveFlag
   continue:(myActiveFlag'="")&&('$p(myActiveFlag,"^",1)) //查看该菜单是否被激活
   
   s myCode = myMenuObj.Code
   s myCaption = myMenuObj.Caption
   s myLinkFuntionDR = myMenuObj.LinkFuntionDR
   s myLinkUrl = myMenuObj.LinkUrl
   s myImage = myMenuObj.Image
   s myMethod = myMenuObj.Method
   s myShowInNewWindow = myMenuObj.ShowInNewWindow
   /*if (myImage'=""){
    s:(($e(myImage,1)="/")||($e(myImage,1)="\")) myImage=$e(myImage,2,$l(myImage))
    s myImage=$tr(myImage,"\","/")
    s myImage="../scripts/bdp/Framework/icons/"_myImage
   }*/
   if (myLinkUrl'=""){
    s myLinkUrl="dhc.bdp.ext.sys.csp?BDPMENU="_mySMRowID
   }
   //判断是否有子菜单
   if ((myLinkUrl="")) s myChildFlag=1
   else  s myChildFlag=0
   
   //判断菜单是否有权显示
   s strMenu="{ID:"_mySMRowID_"}"
   if ((strAutMenu[strMenu)||(1=grpId)) s myMenuEnable=1
   else  s myMenuEnable=0
   
   if (+myMenuEnable) {
    s:(myJsonStr'="") myJsonStr=myJsonStr_","
    s myJsonStr=myJsonStr_"{"
    s myJsonStr=myJsonStr_"""id"":"""_""_mySMRowID_""",""text"":"""_myCaption_""","
    s myJsonStr=myJsonStr_"""iconCls"":"""_""_myImage_""","
    if (+myChildFlag'=0) {
     s myJsonStr=myJsonStr_"""leaf"":false"
    }else {
     s myJsonStr=myJsonStr_"""myhref"":"""_""_myLinkUrl_""","
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

/// 2013-5-21 by 蔡昊哲
/// Description：获取菜单树,按字段'显示顺序'大小排序,用于BDPMain.js
/// Table：User.BDPMenu
/// Input：id:父节点rowid, SessionStr
/// Ohter: w ##class(web.DHCBL.BDP.BDPMenuDefine).GetMenu("menuTreeRoot","^^^1^^^^")
ClassMethod GetMenu(id As %String, SessionStr As %String) As %String
{
	s myJsonStr = "[{""id"":""1"",""text"":""用药频率"",""icon"":""/dthealth/web/scripts/bdp/Framework/imgs/KB/yypl.png"",""myhref"":""/dthealth/web/csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHDiseaseFreq"",""leaf"":true}"
	_",{""id"":""2"",""text"":""用药方法"",""icon"":""/dthealth/web/scripts/bdp/Framework/imgs/KB/yyff.png"",""myhref"":""/dthealth/web/csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHDiseaseUse"",""leaf"":true},"
	_"{""id"":""3"",""text"":""适应症"",""icon"":""/dthealth/web/scripts/bdp/Framework/imgs/KB/syz.png"",""myhref"":""/dthealth/web/csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHDrugDiseaseInd"",""leaf"":true},"
	_"{""id"":""4"",""text"":""用法用量"",""icon"":""/dthealth/web/scripts/bdp/Framework/imgs/KB/yfyl.png"",""myhref"":""/dthealth/web/csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHUsageDosage"",""leaf"":true},"
	_"{""id"":""5"",""text"":""禁忌症"",""icon"":""/dthealth/web/scripts/bdp/Framework/imgs/KB/jjz.png"",""myhref"":""/dthealth/web/csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHDrugDiseaseCon"",""leaf"":true}"
	_",{""id"":""6"",""text"":""相互作用"",""icon"":""/dthealth/web/scripts/bdp/Framework/imgs/KB/xhzy.png"",""myhref"":""/dthealth/web/csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHDiseaseInteract"",""leaf"":true},"
	_"{""id"":""7"",""text"":""禁忌"",""icon"":""/dthealth/web/scripts/bdp/Framework/imgs/KB/jj.png"",""myhref"":""/dthealth/web/csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHDrugContrain"",""leaf"":true},"
	_"{""id"":""8"",""text"":""不良反应"",""icon"":""/dthealth/web/scripts/bdp/Framework/imgs/KB/blfy.png"",""myhref"":""/dthealth/web/csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHDAR"",""leaf"":true},"
	_"{""id"":""9"",""text"":""注意事项"",""icon"":""/dthealth/web/scripts/bdp/Framework/imgs/KB/zysx.png"",""myhref"":""/dthealth/web/csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHDMHA"",""leaf"":true}]"
 
	 q myJsonStr
}

/// 2013-5-21 by 蔡昊哲
/// Description：获取菜单树,按字段'显示顺序'大小排序,用于BDPMain.js
/// Table：User.BDPMenu
/// Input：id:父节点rowid, SessionStr
/// Ohter: w ##class(web.DHCBL.BDP.BDPMenuDefine).GetMenu("menuTreeRoot","^^^1^^^^")
ClassMethod GetDurgBookList(id As %String, SessionStr As %String) As %String
{
	//s TypeDr=$o(^DHCPHPINL("0","Code","USAGE",0))
	s PDFInstDr=0
	for{
		s PDFInstDr=$o(^DHCPHINSTRUC("0","GP",GenDr,PointerType,PointerDr,PDFInstDr))	q:PDFInstDr=""
		s PHINSTSex=$p(^DHCPHINSTRUC(PDFInstDr),"^",9)
		
	}
		s ALFRowId=rowid
		s ALFCode=$p($g(^DHCALLERGY(ALFRowId)),"^",1)  //代码
		s ALFDesc=$p($g(^DHCALLERGY(ALFRowId)),"^",2)  //描述
		s ALFActiveFlag=$p($g(^DHCALLERGY(ALFRowId)),"^",3)  //是否可用
		s ALFSysFlag=$p($g(^DHCALLERGY(ALFRowId)),"^",4)  //是否系统标识
		
 	s rjson = "{data:[{PHINSTRowId:'1',PHINSTDesc:'每隔六小时，每隔8小时',PHINSTGroupDesc:'用药频率'},{PHINSTRowId:'2',PHINSTDesc:'口服',PHINSTGroupDesc:'用药方法'},{PHINSTRowId:'3',PHINSTDesc:'葡萄球肺炎',PHINSTGroupDesc:'适应症'},{PHINSTRowId:'4',PHINSTDesc:'每日5次',PHINSTGroupDesc:'用法用量'},{PHINSTRowId:'5',PHINSTDesc:'怀孕',PHINSTGroupDesc:'禁忌症'},{PHINSTRowId:'5',PHINSTDesc:'硫黄畏朴硝，水银畏砒霜，狼毒畏密陀僧，巴豆畏牵牛，丁香畏郁金，川乌、草乌畏犀角，牙硝畏三棱，官桂畏石脂，人参畏五灵脂。硫黄畏朴硝，水银畏砒霜，狼毒畏密陀僧，巴豆畏牵牛，丁香畏郁金，川乌、草乌畏犀角，牙硝畏三棱，官桂畏石脂，人参畏五灵脂。硫黄畏朴硝，水银畏砒霜，狼毒畏密陀僧，巴豆畏牵牛，丁香畏郁金，川乌、草乌畏犀角，牙硝畏三棱，官桂畏石脂，人参畏五灵脂。',PHINSTGroupDesc:'禁忌'},{PHINSTRowId:'6',PHINSTDesc:'阿莫西林',PHINSTGroupDesc:'相互作用'},{PHINSTRowId:'7',PHINSTDesc:'辛辣海鲜',PHINSTGroupDesc:'不良反应'},{PHINSTRowId:'8',PHINSTDesc:'谨遵医嘱',PHINSTGroupDesc:'注意事项'}], success:true, total:20}"
	q rjson
}

/// Creator：蔡昊哲
/// CreatDate: 2014-12-5
/// Description：获取主界面信息
/// Table：User.DHCPHUsageDosage
/// Input：rowid
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.durgbookmain","GetDurgBookList1","4","FORM","1")
Query GetDurgBookList1(GenDr, PointerType, PointerDr) As %Query(ROWSPEC = "PHINSTRowId,PHINSTDesc,PHINSTGroupDesc")
{
}

ClassMethod GetDurgBookList1Execute(ByRef qHandle As %Binary, GenDr, PointerType, PointerDr) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	//s TypeDr=$o(^DHCPHPINL("0","Code","USAGE",0))
	s PDFInstDr=0
	for{
		s PDFInstDr=$o(^DHCPHINSTRUC("0","GP",GenDr,PointerType,PointerDr,PDFInstDr))	q:PDFInstDr=""
		s PHINSTTypeDr=$p(^DHCPHINSTRUC(PDFInstDr),"^",1)
		s PINLCode=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",1)
		s PHINSTRowId = PDFInstDr
		s PHINSTGroupDesc = $p($g(^DHCPHPINL(PHINSTTypeDr)),"^",2)
		
		if (PINLCode="PreMet") ;用药方法
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCPHDiseaseUse).GetData(PDFInstDr)
		}
		if (PINLCode="Freq") ;用药频率
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCPHDiseaseFreq).GetData(PDFInstDr)
		}
		if (PINLCode="Usage") ;用法用量
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCPHUsageDosage).GetData(PDFInstDr)
		}
		if (PINLCode="Indic") ;适应症
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCPHDrugDiseaseI).GetIndData(PDFInstDr)
		}
		if (PINLCode="Contr") ;禁忌症
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCPHDrugDiseaseC).GetConData(PDFInstDr)
		}
		if (PINLCode="Taboo") ;禁忌
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCPHDrugContrain).GetData(PDFInstDr)
		}
		if (PINLCode="InterEach") ;相互作用
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCPHDiseaseInteract).GetData(PDFInstDr)
		}
		if (PINLCode="AdvRea") ;不良反应
		{
			s PHINSTDesc =$p(^DHCPHINSTRUC(PDFInstDr),"^",15)
		}
		if (PINLCode="MatNeAt") ;注意事项
		{
			s PHINSTDesc =$p(^DHCPHINSTRUC(PDFInstDr),"^",15)
		}
		
		d OutputRow
	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PHINSTRowId,PHINSTDesc,PHINSTGroupDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDurgBookList1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDurgBookList1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDurgBookList1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
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

}
