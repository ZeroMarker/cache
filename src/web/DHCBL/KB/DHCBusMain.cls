/// 知识库 药品说明书编辑器、检验编辑器、检查项目编辑器、心电编辑器、以及浏览器类
/// by caihz 2014-12-3
/// 修改：谷雪萍 2016-10-11 
/// 修改描述：加了配伍禁忌
Class web.DHCBL.KB.DHCBusMain Extends %RegisteredObject
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
				
				s DHCGenLin=##class(web.DHCBL.KB.DHCGenLinkPointer).GetJson(PHEGRowId,"DRUG")
				
				i (PHLICodeU="DRUG")&(PHEGCodeU[code)&(PHEGDescU[desc)&((PHEGLibDrU=lib)||(lib=""))   //条件
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
/// Ohter: w ##class(web.DHCBL.KB.DHCBusMain).GetMenu("TREAT","适应证#0^禁忌证#1","")
ClassMethod GetMenu(code As %String, countInfo As %String, pointType As %String) As %String
{
	s myJsonStr = ""
	s jsonstr=""
	if (code="DRUG") //药品
	{
		s countFreq=0,countPreMet=0,countIndic=0,countUsage=0,countContr=0,countInterEach=0,countTaboo=0,
		countAdvRea=0,countMatNeAt=0,countSolvent=0,countDrgAlone=0,countEleCon=0,countMenstruum=0,countMustDrug=0,countAssDrugNum=0,countRepeat=0,countProcessingAct=0,countDrippingSpeed=0
		s len=$Length(countInfo,"^")
		for i=1:1:len
		{
			s info=$p(countInfo,"^",i)
			s desc = $p(info,"#",1)
			s count = $p(info,"#",2)
			if (desc="用药频率"){
				if (count=0) s countFreq=""
				else  s countFreq="<h6 style=color:#FFFFFF;background-color:#99BBFF;border-radius:25px>"_count_"</h6>"
			}
			if (desc="给药途径"){
				if (count=0) s countPreMet=""
				else  s countPreMet="<h6 style=color:#FFFFFF;background-color:#99BBFF;border-radius:25px>"_count_"</h6>"
			}
			if (desc="适应证"){
				if (count=0) s countIndic=""
				else  s countIndic="<h6 style=color:#FFFFFF;background-color:#99BBFF;border-radius:25px>"_count_"</h6>"
			}
			if (desc="用法用量"){
				if (count=0) s countUsage=""
				else  s countUsage="<h6 style=color:#FFFFFF;background-color:#99BBFF;border-radius:25px>"_count_"</h6>"
			}
			if (desc="禁忌证"){
				if (count=0) s countContr=""
				else  s countContr="<h6 style=color:#FFFFFF;background-color:#99BBFF;border-radius:25px>"_count_"</h6>"
			} 
			if (desc="相互作用"){
				if (count=0) s countInterEach=""
				else  s countInterEach="<h6 style=color:#FFFFFF;background-color:#99BBFF;border-radius:25px>"_count_"</h6>"
			}
			if (desc="配伍禁忌"){
				if (count=0) s countTaboo=""
				else  s countTaboo="<h6 style=color:#FFFFFF;background-color:#99BBFF;border-radius:25px>"_count_"</h6>"
			}
			if (desc="不良反应"){
				if (count=0) s countAdvRea=""
				else  s countAdvRea="<h6 style=color:#FFFFFF;background-color:#99BBFF;border-radius:25px>"_count_"</h6>"
			} 
			if (desc="注意事项"){
				if (count=0) s countMatNeAt=""
				else  s countMatNeAt="<h6 style=color:#FFFFFF;background-color:#99BBFF;border-radius:25px>"_count_"</h6>"
			}
			if (desc="浓度"){
				if (count=0) s countSolvent=""
				else  s countSolvent="<h6 style=color:#FFFFFF;background-color:#99BBFF;border-radius:25px>"_count_"</h6>"
			} 
			if (desc="可配伍药品"){
				if (count=0) s countDrgAlone=""
				else  s countDrgAlone="<h6 style=color:#FFFFFF;background-color:#99BBFF;border-radius:25px>"_count_"</h6>"
			} 
			if (desc="成分含量(g)"){
				if (count=0) s countEleCon=""
				else  s countEleCon="<h6 style=color:#FFFFFF;background-color:#99BBFF;border-radius:25px>"_count_"</h6>"
			}
			if (desc="溶媒量"){
				if (count=0) s countMenstruum=""
				else  s countMenstruum="<h6 style=color:#FFFFFF;background-color:#99BBFF;border-radius:25px>"_count_"</h6>"
			} 
			if (desc="联合用药"){
				if (count=0) s countMustDrug=""
				else  s countMustDrug="<h6 style=color:#FFFFFF;background-color:#99BBFF;border-radius:25px>"_count_"</h6>"
			}
			if (desc="辅助用药个数"){
				if (count=0) s countAssDrugNum=""
				else  s countAssDrugNum="<h6 style=color:#FFFFFF;background-color:#99BBFF;border-radius:25px>"_count_"</h6>"
			} 
			if (desc="重复用药"){
				if (count=0) s countRepeat=""
				else  s countRepeat="<h6 style=color:#FFFFFF;background-color:#99BBFF;border-radius:25px>"_count_"</h6>"
			}
			if (desc="炮制作用"){
				if (count=0) s countProcessingAct=""
				else  s countProcessingAct="<h6 style=color:#FFFFFF;background-color:#99BBFF;border-radius:25px>"_count_"</h6>"
			} 
			if (desc="滴速"){
				if (count=0) s countDrippingSpeed=""
				else  s countDrippingSpeed="<h6 style=color:#FFFFFF;background-color:#99BBFF;border-radius:25px>"_count_"</h6>"
			}  
		}
		
	
		/*s myJsonStr = "["
		_"{""id"":""1"",""text"":""成分含量(g)"_countEleCon_""",""icon"":""../scripts/bdp/Framework/imgs/KB/zzndhl.png"",""myhref"":""../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHEleCon"",""leaf"":true},"
		_"{""id"":""2"",""text"":""适应证"_countIndic_""",""icon"":""../scripts/bdp/Framework/imgs/KB/syz.png"",""myhref"":""../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHDrugDiseaseInd"",""leaf"":true},"
		_"{""id"":""3"",""text"":""用法用量"_countUsage_""",""icon"":""../scripts/bdp/Framework/imgs/KB/yfyl.png"",""myhref"":""../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHUsageDosage"",""leaf"":true},"
		_"{""id"":""4"",""text"":""溶媒量"_countMenstruum_""",""icon"":""../scripts/bdp/Framework/imgs/KB/rml.png"",""myhref"":""../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHMenstruumQty"",""leaf"":true},"
	    _"{""id"":""5"",""text"":""浓度"_countSolvent_""",""icon"":""../scripts/bdp/Framework/imgs/KB/lcyy.png"",""myhref"":""../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHDrgSolvent"",""leaf"":true},"
		_"{""id"":""6"",""text"":""给药途径"_countPreMet_""",""icon"":""../scripts/bdp/Framework/imgs/KB/yyff.png"",""myhref"":""../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHDiseaseUse"",""leaf"":true},"
		_"{""id"":""7"",""text"":""用药频率"_countFreq_""",""icon"":""../scripts/bdp/Framework/imgs/KB/yypl.png"",""myhref"":""../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHDiseaseFreq"",""leaf"":true},"
		_"{""id"":""8"",""text"":""滴速"_countDrippingSpeed_""",""icon"":""../scripts/bdp/Framework/imgs/KB/ds.png"",""myhref"":""../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHDrippingSpeed"",""leaf"":true},"
		_"{""id"":""9"",""text"":""不良反应"_countAdvRea_""",""icon"":""../scripts/bdp/Framework/imgs/KB/blfy.png"",""myhref"":""../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHDAR"",""leaf"":true},"
		_"{""id"":""10"",""text"":""禁忌证"_countContr_""",""icon"":""../scripts/bdp/Framework/imgs/KB/jjz.png"",""myhref"":""../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHDrugDiseaseCon"",""leaf"":true},"		
		_"{""id"":""11"",""text"":""配伍禁忌"_countTaboo_""",""icon"":""../scripts/bdp/Framework/imgs/KB/jj.png"",""myhref"":""../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHDrugContrain"",""leaf"":true},"		
		_"{""id"":""12"",""text"":""注意事项"_countMatNeAt_""",""icon"":""../scripts/bdp/Framework/imgs/KB/zysx.png"",""myhref"":""../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHDMHA"",""leaf"":true},"
		_"{""id"":""13"",""text"":""相互作用"_countInterEach_""",""icon"":""../scripts/bdp/Framework/imgs/KB/xhzy.png"",""myhref"":""../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHDiseaseInteract"",""leaf"":true},"
		_"{""id"":""14"",""text"":""可配伍药品"_countDrgAlone_""",""icon"":""../scripts/bdp/Framework/imgs/KB/ddyy.png"",""myhref"":""../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHDrgAlone"",""leaf"":true},"
		_"{""id"":""15"",""text"":""联合用药"_countMustDrug_""",""icon"":""../scripts/bdp/Framework/imgs/KB/lhyy.png"",""myhref"":""../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHMustDrug"",""leaf"":true},"
		_"{""id"":""16"",""text"":""辅助用药个数"_countAssDrugNum_""",""icon"":""../scripts/bdp/Framework/imgs/KB/fzyygs.png"",""myhref"":""../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHAssDrugNum"",""leaf"":true},"
		_"{""id"":""17"",""text"":""重复用药"_countRepeat_""",""icon"":""../scripts/bdp/Framework/imgs/KB/cfyy.png"",""myhref"":""../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHRepeatItm"",""leaf"":true},"
		_"{""id"":""18"",""text"":""炮制作用"_countProcessingAct_""",""icon"":""../scripts/bdp/Framework/imgs/KB/pzzy.png"",""myhref"":""../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHProcessingAct"",""leaf"":true}]"
		//_"{""id"":""10"",""text"":""医嘱优先级"",""icon"":""../scripts/bdp/Framework/imgs/KB/yzyxj.png"",""myhref"":""../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHDiseasePriority"",""leaf"":true}]"*/
	}
	if (code="LAB")  //检验
	{
		s countLabIndic=0,countLabContr=0,countLabClinical=0,countLabInterEach=0,countLabMatNeAt=0,countLabResultDiag=0
		s len=$Length(countInfo,"^")
		for i=1:1:len
		{
			s info=$p(countInfo,"^",i)
			s desc = $p(info,"#",1)
			s count = $p(info,"#",2)
			if (desc="适应证"){
				if (count=0) s countLabIndic=""
				else  s countLabIndic="<h6 style=color:#FFFFFF;background-color:#99BBFF;border-radius:25px>"_count_"</h6>"
			}
			if (desc="禁忌证"){
				if (count=0) s countLabContr=""
				else  s countLabContr="<h6 style=color:#FFFFFF;background-color:#99BBFF;border-radius:25px>"_count_"</h6>"
			}
			if (desc="临床意义"){
				if (count=0) s countLabClinical=""
				else  s countLabClinical="<h6 style=color:#FFFFFF;background-color:#99BBFF;border-radius:25px>"_count_"</h6>"
			}
			if (desc="相互作用"){
				if (count=0) s countLabInterEach=""
				else  s countLabInterEach="<h6 style=color:#FFFFFF;background-color:#99BBFF;border-radius:25px>"_count_"</h6>"
			}
			if (desc="注意事项"){
				if (count=0) s countLabMatNeAt=""
				else  s countLabMatNeAt="<h6 style=color:#FFFFFF;background-color:#99BBFF;border-radius:25px>"_count_"</h6>"
			}
			if (desc="检验结果辅助诊断"){
				if (count=0) s countLabResultDiag=""
				else  s countLabResultDiag="<h6 style=color:#FFFFFF;background-color:#99BBFF;border-radius:25px>"_count_"</h6>"
			}
		}
		
		/*s myJsonStr = "["
		_"{""id"":""1"",""text"":""适应证"_countLabIndic_""",""icon"":""../scripts/bdp/Framework/imgs/KB/syz.png"",""myhref"":""../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_LABDiseaseInd"",""leaf"":true},"	
		_"{""id"":""2"",""text"":""禁忌证"_countLabContr_""",""icon"":""../scripts/bdp/Framework/imgs/KB/jjz.png"",""myhref"":""../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus//DHC_LABDiseaseCon"",""leaf"":true},"
		_"{""id"":""3"",""text"":""临床意义"_countLabClinical_""",""icon"":""../scripts/bdp/Framework/imgs/KB/lcyy.png"",""myhref"":""../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_LabClinical"",""leaf"":true},"
		_"{""id"":""4"",""text"":""相互作用"_countLabInterEach_""",""icon"":""../scripts/bdp/Framework/imgs/KB/xhzy.png"",""myhref"":""../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_LABDiseaseInteract"",""leaf"":true},"
		_"{""id"":""5"",""text"":""注意事项"_countLabMatNeAt_""",""icon"":""../scripts/bdp/Framework/imgs/KB/zysx.png"",""myhref"":""../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_LABMHA"",""leaf"":true},"
		_"{""id"":""6"",""text"":""检验结果辅助诊断"_countLabResultDiag_""",""icon"":""../scripts/bdp/Framework/imgs/KB/fzzd.png"",""myhref"":""../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHLibResultDiag"",""leaf"":true}]"*/
	}
	if (code="ULTR") || (code="RADI") || (code="ENDO") //检查 超声，胃镜，放射
	{
		s countCheckIndic=0,countCheckContr=0,countCheckAdvRea=0,countCheckMatNeAt=0
		s len=$Length(countInfo,"^")
		for i=1:1:len
		{
			s info=$p(countInfo,"^",i)
			s desc = $p(info,"#",1)
			s count = $p(info,"#",2)
			if (desc="适应证"){
				if (count=0) s countCheckIndic=""
				else  s countCheckIndic="<h6 style=color:#FFFFFF;background-color:#99BBFF;border-radius:25px>"_count_"</h6>"
			}
			if (desc="禁忌证"){
				if (count=0) s countCheckContr=""
				else  s countCheckContr="<h6 style=color:#FFFFFF;background-color:#99BBFF;border-radius:25px>"_count_"</h6>"
			}
			if (desc="不良反应"){
				if (count=0) s countCheckAdvRea=""
				else  s countCheckAdvRea="<h6 style=color:#FFFFFF;background-color:#99BBFF;border-radius:25px>"_count_"</h6>"
			}
			if (desc="注意事项"){
				if (count=0) s countCheckMatNeAt=""
				else  s countCheckMatNeAt="<h6 style=color:#FFFFFF;background-color:#99BBFF;border-radius:25px>"_count_"</h6>"
			}
		}
		/*s myJsonStr = "["
		
		_"{""id"":""1"",""text"":""适应证"_countCheckIndic_""",""icon"":""../scripts/bdp/Framework/imgs/KB/syz.png"",""myhref"":""../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_CheckDiseaseInd"",""leaf"":true},"	
		_"{""id"":""2"",""text"":""禁忌证"_countCheckContr_""",""icon"":""../scripts/bdp/Framework/imgs/KB/jjz.png"",""myhref"":""../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus//DHC_CheckDiseaseCon"",""leaf"":true},"
		_"{""id"":""3"",""text"":""不良反应"_countCheckAdvRea_""",""icon"":""../scripts/bdp/Framework/imgs/KB/blfy.png"",""myhref"":""../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_CheckAR"",""leaf"":true},"
		_"{""id"":""4"",""text"":""注意事项"_countCheckMatNeAt_""",""icon"":""../scripts/bdp/Framework/imgs/KB/zysx.png"",""myhref"":""../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_CheckMHA"",""leaf"":true}]"*/
	}
	if (code="ELECT") //心电
	{
		s countELECTIndic=0,countELECTContr=0,countELECTInterEach=0,countELECTAdvRea=0,countELECTMatNeAt=0
		s len=$Length(countInfo,"^")
		for i=1:1:len
		{
			s info=$p(countInfo,"^",i)
			s desc = $p(info,"#",1)
			s count = $p(info,"#",2)
			if (desc="适应证"){
				if (count=0) s countELECTIndic=""
				else  s countELECTIndic="<h6 style=color:#FFFFFF;background-color:#99BBFF;border-radius:25px>"_count_"</h6>"
			}
			if (desc="禁忌证"){
				if (count=0) s countELECTContr=""
				else  s countELECTContr="<h6 style=color:#FFFFFF;background-color:#99BBFF;border-radius:25px>"_count_"</h6>"
			}
			if (desc="相互作用"){
				if (count=0) s countELECTInterEach=""
				else  s countELECTInterEach="<h6 style=color:#FFFFFF;background-color:#99BBFF;border-radius:25px>"_count_"</h6>"
			}
			if (desc="不良反应"){
				if (count=0) s countELECTAdvRea=""
				else  s countELECTAdvRea="<h6 style=color:#FFFFFF;background-color:#99BBFF;border-radius:25px>"_count_"</h6>"
			}
			if (desc="注意事项"){
				if (count=0) s countELECTMatNeAt=""
				else  s countELECTMatNeAt="<h6 style=color:#FFFFFF;background-color:#99BBFF;border-radius:25px>"_count_"</h6>"
			}
		}
		/*s myJsonStr = "["
		
		_"{""id"":""1"",""text"":""适应证"_countELECTIndic_""",""icon"":""../scripts/bdp/Framework/imgs/KB/syz.png"",""myhref"":""../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_ECGDiseaseInd"",""leaf"":true},"	
		_"{""id"":""2"",""text"":""禁忌证"_countELECTContr_""",""icon"":""../scripts/bdp/Framework/imgs/KB/jjz.png"",""myhref"":""../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus//DHC_ECGDiseaseCon"",""leaf"":true},"
		_"{""id"":""3"",""text"":""相互作用"_countELECTInterEach_""",""icon"":""../scripts/bdp/Framework/imgs/KB/xhzy.png"",""myhref"":""../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_ECGInteract"",""leaf"":true},"
		_"{""id"":""4"",""text"":""不良反应"_countELECTAdvRea_""",""icon"":""../scripts/bdp/Framework/imgs/KB/blfy.png"",""myhref"":""../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_ECGAR"",""leaf"":true},"		
		_"{""id"":""5"",""text"":""注意事项"_countELECTMatNeAt_""",""icon"":""../scripts/bdp/Framework/imgs/KB/zysx.png"",""myhref"":""../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_ECGMHA"",""leaf"":true}]"*/
	}
	if (code="OPERATION") //手术
	{
		s countOPERRemind=0
		s len=$Length(countInfo,"^")
		for i=1:1:len
		{
			s info=$p(countInfo,"^",i)
			s desc = $p(info,"#",1)
			s count = $p(info,"#",2)
			if (desc="高危提醒"){
				if (count=0) s countOPERRemind=""
				else  s countOPERRemind="<h6 style=color:#FFFFFF;background-color:#99BBFF;border-radius:25px>"_count_"</h6>"
			}
			
		}
		/*s myJsonStr = "["
		_"{""id"":""1"",""text"":""高危提醒"_countOPERRemind_""",""icon"":""../scripts/bdp/Framework/imgs/KB/gwtx.png"",""myhref"":""../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_OPERRemind"",""leaf"":true}]"*/	

	}
	if (code="TREAT") //治疗项目
	{
		s countTreatIndic=0,countTreatContr=0
		s len=$Length(countInfo,"^")
		for i=1:1:len
		{
			s info=$p(countInfo,"^",i)
			s desc = $p(info,"#",1)
			s count = $p(info,"#",2)
			if (desc="适应证"){
				if (count=0) s countTreatIndic=""
				else  s countTreatIndic="<h6 style=color:#FFFFFF;background-color:#99BBFF;border-radius:25px>"_count_"</h6>"
			}
			if (desc="禁忌证"){
				if (count=0) s countTreatContr=""
				else  s countTreatContr="<h6 style=color:#FFFFFF;background-color:#99BBFF;border-radius:25px>"_count_"</h6>"
			}
		}
	}
	s order=0
	for 
	{
		s order=$o(^DHCPHPINL(0,"Order",order))
		q:order=""
		s PINLRowID=0
		for 
		{
			s PINLRowID=$o(^DHCPHPINL(0,"Order",order,PINLRowID))
			q:PINLRowID=""
			s PINLCode=$p($g(^DHCPHPINL(PINLRowID)),"^",1)
			s PINLDesc=$p($g(^DHCPHPINL(PINLRowID)),"^",2)	
			s PINLIcon=$p($g(^DHCPHPINL(PINLRowID)),"^",6)
			s PHLIRowId=$p($g(^DHCPHPINL(PINLRowID)),"^",5)
			s myhref=$p($g(^DHCPHPINL(PINLRowID)),"^",11)
			s PINLGenFlag=$p($g(^DHCPHPINL(PINLRowID)),"^",9)
			s PINLProFlag=$p($g(^DHCPHPINL(PINLRowID)),"^",10)
			continue:(pointType="Form")&(PINLGenFlag="N")
			continue:(pointType="ProName")&(PINLProFlag="N")
			continue:PHLIRowId=""
			s PHLICode=$p($g(^DHCPHLIBL(PHLIRowId)),"^",1)
			if (PHLICode=code)
			{
				if (code="DRUG") //药品
				{

					if (PINLDesc="用药频率"){
						s myhref="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHDiseaseFreq"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/yypl.png"
						s PINLDesc=PINLDesc_countFreq
					}
					if (PINLDesc="给药途径"){
						s myhref="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHDiseaseUse"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/yyff.png"
						s PINLDesc=PINLDesc_countPreMet
					}
					if (PINLDesc="适应证"){
						s myhref="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHDrugDiseaseInd"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/syz.png"
						s PINLDesc=PINLDesc_countIndic
					}
					if (PINLDesc="用法用量"){
						s myhref="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHUsageDosage"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/yfyl.png"
						s PINLDesc=PINLDesc_countUsage
					}
					if (PINLDesc="禁忌证"){
						s myhref="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHDrugDiseaseCon"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/jjz.png"
						s PINLDesc=PINLDesc_countContr
					} 
					if (PINLDesc="相互作用"){
						s myhref="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHDiseaseInteract"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/xhzy.png"
						s PINLDesc=PINLDesc_countInterEach
					}
					if (PINLDesc="配伍禁忌"){
						s myhref="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHDrugContrain"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/jj.png"
						s PINLDesc=PINLDesc_countTaboo
					}
					if (PINLDesc="不良反应"){
						s myhref="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHDAR"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/blfy.png"
						s PINLDesc=PINLDesc_countAdvRea
					} 
					if (PINLDesc="注意事项"){
						s myhref="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHDMHA"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/zysx.png"
						s PINLDesc=PINLDesc_countMatNeAt
					}
					if (PINLDesc="浓度"){
						s myhref="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHDrgSolvent"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/lcyy.png"
						s PINLDesc=PINLDesc_countSolvent
					} 
					if (PINLDesc="可配伍药品"){
						s myhref="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHDrgAlone"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/ddyy.png"
						s PINLDesc=PINLDesc_countDrgAlone
					} 
					if (PINLDesc="成分含量(g)"){
						s myhref="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHEleCon"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/zzndhl.png"
						s PINLDesc=PINLDesc_countEleCon
					}
					if (PINLDesc="溶媒量"){
						s myhref="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHMenstruumQty"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/rml.png"
						s PINLDesc=PINLDesc_countMenstruum
					} 
					if (PINLDesc="联合用药"){
						s myhref="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHMustDrug"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/lhyy.png"
						s PINLDesc=PINLDesc_countMustDrug
					}
					if (PINLDesc="辅助用药个数"){
						s myhref="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHAssDrugNum"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/fzyygs.png"
						s PINLDesc=PINLDesc_countAssDrugNum
					} 
					if (PINLDesc="重复用药"){
						s myhref="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHRepeatItm"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/cfyy.png"
						s PINLDesc=PINLDesc_countRepeat
					}
					if (PINLDesc="炮制作用"){
						s myhref="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHProcessingAct"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/pzzy.png"
						s PINLDesc=PINLDesc_countProcessingAct
					} 
					if (PINLDesc="滴速"){
						s myhref="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHDrippingSpeed"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/ds.png"
						s PINLDesc=PINLDesc_countDrippingSpeed
					}  
				}
				
				if (code="LAB") //检验
				{
		    
					if (PINLDesc="适应证"){
						s myhref="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_LABDiseaseInd"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/syz.png"
						s PINLDesc=PINLDesc_countLabIndic
					}
					if (PINLDesc="禁忌证"){
						s myhref="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus//DHC_LABDiseaseCon"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/jjz.png"
						s PINLDesc=PINLDesc_countLabContr
					}
					if (PINLDesc="临床意义"){
						s myhref="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_LabClinical"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/lcyy.png"
						s PINLDesc=PINLDesc_countLabClinical
					}
					if (PINLDesc="相互作用"){
						s myhref="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_LABDiseaseInteract"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/xhzy.png"
						s PINLDesc=PINLDesc_countLabInterEach
					}
					if (PINLDesc="注意事项"){
						s myhref="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_LABMHA"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/zysx.png"
						s PINLDesc=PINLDesc_countLabMatNeAt
					} 
					if (PINLDesc="检验结果辅助诊断"){
						s myhref="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHLibResultDiag"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/fzzd.png"
						s PINLDesc=PINLDesc_countLabResultDiag
					}
				
				}
				
				if ((code="ULTR") || (code="RADI") || (code="ENDO")) //检查 超声，胃镜，放射
				{
							    
					if (PINLDesc="适应证"){
						s myhref="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_CheckDiseaseInd"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/syz.png"
						s PINLDesc=PINLDesc_countCheckIndic
					}
					if (PINLDesc="禁忌证"){
						s myhref="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus//DHC_CheckDiseaseCon"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/jjz.png"
						s PINLDesc=PINLDesc_countCheckContr
					}
					if (PINLDesc="不良反应"){
						s myhref="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_CheckAR"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/blfy.png"
						s PINLDesc=PINLDesc_countCheckAdvRea
					}
					if (PINLDesc="注意事项"){
						s myhref="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_CheckMHA"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/zysx.png"
						s PINLDesc=PINLDesc_countCheckMatNeAt
					}
				}
				
				if (code="ELECT") //心电
				{
					if (PINLDesc="适应证"){
						s myhref="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_ECGDiseaseInd"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/syz.png"
						s PINLDesc=PINLDesc_countELECTIndic
					}
					if (PINLDesc="禁忌证"){
						s myhref="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus//DHC_ECGDiseaseCon"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/jjz.png"
						s PINLDesc=PINLDesc_countELECTContr
					}
					if (PINLDesc="相互作用"){
						s myhref="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_ECGInteract"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/xhzy.png"
						s PINLDesc=PINLDesc_countELECTInterEach
					}
					if (PINLDesc="不良反应"){
						s myhref="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_ECGAR"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/blfy.png"
						s PINLDesc=PINLDesc_countELECTAdvRea
					}
					if (PINLDesc="注意事项"){
						s myhref="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_ECGMHA"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/zysx.png"
						s PINLDesc=PINLDesc_countELECTMatNeAt
					}
				}

				if (code="OPERATION")  //手术
				{
					if (PINLDesc="高危提醒"){
						s myhref="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_OPERRemind"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/gwtx.png"
						s PINLDesc=PINLDesc_countOPERRemind
					}

				}
				
				if (code="TREAT") //治疗项目
				{
							    
					if (PINLDesc="适应证"){
						s myhref="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_CheckDiseaseInd"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/syz.png"
						s PINLDesc=PINLDesc_countTreatIndic
					}
					if (PINLDesc="禁忌证"){
						s myhref="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus//DHC_CheckDiseaseCon"
						s:PINLIcon="" PINLIcon="../scripts/bdp/Framework/imgs/KB/jjz.png"
						s PINLDesc=PINLDesc_countTreatContr
					}
				}
				s mainstr="{""id"":"""_PINLRowID_""",""text"":"""_PINLDesc_""",""icon"":"""_PINLIcon_""",""myhref"":"""_myhref_""",""leaf"":true}"
			    if (jsonstr'="")
				{ 
					s jsonstr=jsonstr_","_mainstr
				}
				else
				{
					s jsonstr=mainstr
				}
						
							
			}
		}
						

		
	}
	s myJsonStr="["_jsonstr_"]"
	
	q myJsonStr
}

/// 2013-5-21 by 蔡昊哲
/// Description：获取菜单树,不良
/// Table：User.BDPMenu
/// Input：id:父节点rowid, SessionStr
/// Ohter: w ##class(web.DHCBL.BDP.BDPMenuDefine).GetMenu("menuTreeRoot","^^^1^^^^")
ClassMethod GetMenuOpen(code As %String, ruleDesc As %String) As %String
{
	s result=""
	if (code="DRUG") //药品
	{
		if (ruleDesc="用药频率")
		{
			s result="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHDiseaseFreq"
		}
		if (ruleDesc="给药途径")
		{
			s result="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHDiseaseUse"
		}
		if (ruleDesc="适应证")
		{
			s result="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHDrugDiseaseInd"
		}
		if (ruleDesc="用法用量")
		{
			s result="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHUsageDosage"
		}
		if (ruleDesc="禁忌证")
		{
			s result="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHDrugDiseaseCon"
		}
		if (ruleDesc="相互作用")
		{
			s result="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHDiseaseInteract"
		}
		if (ruleDesc="浓度")
		{
			s result="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHDrgSolvent"
		}
		if (ruleDesc="可配伍药品")
		{
			s result="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHDrgAlone"
		}
		if (ruleDesc="配伍禁忌")
		{
			s result="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHDrugContrain"
		}
		if (ruleDesc="不良反应")
		{
			s result="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHDAR"
		}
		if (ruleDesc="注意事项")
		{
			s result="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHDMHA"
		}
		if (ruleDesc="成分含量(g)")
		{
			s result="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHEleCon"
		}
		if (ruleDesc="溶媒量")
		{
			s result="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHMenstruumQty"
		}
		if (ruleDesc="联合用药")
		{
			s result="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHMustDrug"
		}
		if (ruleDesc="辅助用药个数")
		{
			s result="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHAssDrugNum"
		}
		if (ruleDesc="重复用药")
		{
			s result="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHRepeatItm"
		}
		if (ruleDesc="炮制作用")
		{
			s result="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHProcessingAct"
		}
		if (ruleDesc="滴速")
		{
			s result="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHDrippingSpeed"
		}
		/*if (ruleDesc="医嘱优先级")
		{
			s result="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHDiseasePriority"
		}*/
	}
	if (code="LAB")  //检验
	{
		if (ruleDesc="适应证")
		{
			s result="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_LABDiseaseInd"
		}
		if (ruleDesc="禁忌证")
		{
			s result="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus//DHC_LABDiseaseCon"
		}
		if (ruleDesc="相互作用")
		{
			s result="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_LABDiseaseInteract"
		}
		if (ruleDesc="临床意义")
		{
			s result="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_LabClinical"
		}
		if (ruleDesc="注意事项")
		{
			s result="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_LABMHA"
		}
		if (ruleDesc="检验结果辅助诊断")
		{
			s result="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_PHLibResultDiag"
		}
		
	}
	if (code="ULTR") || (code="RADI") || (code="ENDO")  //检查 超声，胃镜，放射
	{
		if (ruleDesc="适应证")
		{
			s result="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_CheckDiseaseInd"
		}
		if (ruleDesc="禁忌证")
		{
			s result="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus//DHC_CheckDiseaseCon"
		}
		if (ruleDesc="不良反应")
		{
			s result="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_CheckAR"
		}
		if (ruleDesc="注意事项")
		{
			s result="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_CheckMHA"
		}
	}
	if (code="ELECT") //心电
	{
		if (ruleDesc="适应证")
		{
			s result="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_ECGDiseaseInd"
		}
		if (ruleDesc="禁忌证")
		{
			s result="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_ECGDiseaseCon"
		}
		if (ruleDesc="相互作用")
		{
			s result="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_ECGInteract"
		}
		if (ruleDesc="不良反应")
		{
			s result="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_ECGAR"
		}
		if (ruleDesc="注意事项")
		{
			s result="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_ECGMHA"
		}
	}
	if (code="OPERATION") //手术
	{
		if (ruleDesc="高危提醒")
		{
			s result="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_OPERRemind"
		}
	}
	if (code="TREAT")  //治疗项目
	{
		if (ruleDesc="适应证")
		{
			s result="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus/DHC_CheckDiseaseInd"
		}
		if (ruleDesc="禁忌证")
		{
			s result="../csp/dhc.bdp.ext.default.csp?extfilename=App/KB/Bus//DHC_CheckDiseaseCon"
		}
	}
	q result
}

/// 2013-5-21 by 蔡昊哲
/// Description：获取菜单树,按字段'显示顺序'大小排序,用于BDPMain.js
/// Table：User.BDPMenu
/// Input：id:父节点rowid, SessionStr
/// Ohter: w ##class(web.DHCBL.BDP.BDPMenuDefine).GetMenu("menuTreeRoot","^^^1^^^^")
ClassMethod GetDrugBookList(id As %String, SessionStr As %String) As %String
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
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCBusMain","GetDrugBookList1","3363","Form","1")
Query GetDrugBookList1(GenDr, PointerType, PointerDr) As %Query(ROWSPEC = "PHINSTRowId,PHINSTDesc,PHINSTGroupDesc,PHINSTSoft,PHINSTCount")
{
}

ClassMethod GetDrugBookList1Execute(ByRef qHandle As %Binary, GenDr, PointerType, PointerDr) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s countPreMet=0,countFreq=0,countUsage=0,countIndic=0,countContr=0,countTaboo=0,countInterEach=0,countAdvRea=0,countMatNeAt=0,countSolvent=0,countDrgAlone=0,countEleCon=0,countMenstruum=0,countMustDrug=0,countAssDrugNum=0,countRepeat=0,countProcessingAct=0,countDrippingSpeed=0 //药品
	s countLabIndic=0,countLabContr=0,countLabClinical=0,countLabInterEach=0,countLabMatNeAt=0,countLabResultDiag=0 //检验
	s countCheckContr=0,countCheckIndic=0,countCheckMatNeAt=0,countCheckAdvRea=0 //检查
	s countELECTIndic=0,countELECTContr=0,countELECTInterEach=0,countELECTMatNeAt=0,countELECTAdvRea=0 //心电
	s countOPERRemind=0 //手术
	//s countTreatContr=0 ,countTreatIndic=0  //治疗项目
	//s TypeDr=$o(^DHCPHPINL("0","Code","USAGE",0))
	s PDFInstDr=0
	for{
		s PDFInstDr=$o(^DHCPHINSTRUC("0","GP",GenDr,PointerType,PointerDr,PDFInstDr))	q:PDFInstDr=""
		s PHINSTTypeDr=$p(^DHCPHINSTRUC(PDFInstDr),"^",1)
		s PINLCode=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",1)
		s PHINSTSoft=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",3)  //顺序
		s PHINSTRowId = PDFInstDr
		s PHINSTGroupDesc = $p($g(^DHCPHPINL(PHINSTTypeDr)),"^",2)
		
		if (PINLCode="PreMet") ;给药途径
		{	
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCPHDiseaseUse).GetData(PDFInstDr)
			//s PHINSTSoft = 6
			s countPreMet=countPreMet+1
			s PHINSTCount=countPreMet
		}
		if (PINLCode="Freq") ;用药频率
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCPHDiseaseFreq).GetData(PDFInstDr)
			//s PHINSTSoft = 7
			s countFreq=countFreq+1
			s PHINSTCount=countFreq
		}
		if (PINLCode="Usage") ;用法用量
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCPHUsageDosage).GetData(PDFInstDr)
			s PHUSDORowId = $o(^DHCPHUSDO("0","Inst",PDFInstDr,0)) continue:PHUSDORowId=""
			//s PHINSTSoft = 3
			s countUsage=countUsage+1
			s PHINSTCount=countUsage
		}
		if (PINLCode="Indic") ;适应症
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCPHDrugDiseaseI).GetIndData(PDFInstDr)
			//s PHINSTSoft = 2
			s countIndic=countIndic+1
			s PHINSTCount=countIndic
		}
		if (PINLCode="Contr") ;禁忌症
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCPHDrugDiseaseC).GetConData(PDFInstDr)
			//s PHINSTSoft = 10
			s countContr=countContr+1
			s PHINSTCount=countContr
		}
		if (PINLCode="Taboo") ;配伍禁忌
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCPHDrugContrain).GetData(PDFInstDr)
			//s PHINSTSoft = 11
			s countTaboo=countTaboo+1
			s PHINSTCount=countTaboo
		}
		if (PINLCode="InterEach") ;相互作用
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCPHDiseaseInteract).GetData(PDFInstDr)
			//s PHINSTSoft = 13
			s countInterEach=countInterEach+1
			s PHINSTCount=countInterEach
		}
		if (PINLCode="AdvRea") ;不良反应
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCPHDAR).GetData(PDFInstDr)
			//s PHINSTSoft = 9
			s countAdvRea=countAdvRea+1
			s PHINSTCount=countAdvRea
		}
		if (PINLCode="MatNeAt") ;注意事项
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCPHDMHA).GetData(PDFInstDr)
			//s PHINSTSoft = 12
			s countMatNeAt=countMatNeAt+1
			s PHINSTCount=countMatNeAt
		}
		if (PINLCode="Solvent") ;浓度
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCPHDrgSolvent).GetData(PDFInstDr)
			//s PHINSTSoft = 5
			s countSolvent=countSolvent+1
			s PHINSTCount=countSolvent
		}
		if (PINLCode="DrgAlone") ;可配伍药品
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCPHDrgAlone).GetData(PDFInstDr)
			//s PHINSTSoft = 14
			s countDrgAlone=countDrgAlone+1
			s PHINSTCount=countDrgAlone
		}
		if (PINLCode="EleCon") ;成分含量(g)
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCPHEleCon).GetData(PDFInstDr)
			//s PHINSTSoft = 1
			s countEleCon=countEleCon+1
			s PHINSTCount=countEleCon
		}
		if (PINLCode="Menstruum") ;溶媒量
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCPHMenstruumQty).GetData(PDFInstDr)
			//s PHINSTSoft = 4
			s countMenstruum=countMenstruum+1
			s PHINSTCount=countMenstruum
		}
		if (PINLCode="MustDrug") ;联合用药
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCPHMustDrug).GetData(PDFInstDr)
			//s PHINSTSoft = 15
			s countMustDrug=countMustDrug+1
			s PHINSTCount=countMustDrug
		}
		if (PINLCode="AssDrugNum") ;辅助用药个数
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCPHAssDrugNum).GetData(PDFInstDr)
			//s PHINSTSoft = 16
			s countAssDrugNum=countAssDrugNum+1
			s PHINSTCount=countAssDrugNum
		}
		if (PINLCode="Repeat") ;重复用药
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCPHRepeatItm).GetData(PDFInstDr)
			//s PHINSTSoft = 17
			s countRepeat=countRepeat+1
			s PHINSTCount=countRepeat
		}
		if (PINLCode="ProcessingAct") ;炮制作用
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCPHProcessingAct).GetData(PDFInstDr)
			//s PHINSTSoft = 18
			s countProcessingAct=countProcessingAct+1
			s PHINSTCount=countProcessingAct
		}
		if (PINLCode="DrippingSpeed") ;滴速
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCPHDrippingSpeed).GetData(PDFInstDr)
			//s PHINSTSoft = 8
			s countDrippingSpeed=countDrippingSpeed+1
			s PHINSTCount=countDrippingSpeed
		}
		/*if (PINLCode="Priority") ;医嘱优先级
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCPHDiseasePriority).GetData(PDFInstDr)
			//s PHINSTSoft = 10
		}*/
		//检验
		if (PINLCode="LabContr") ;禁忌证
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCLABDiseaseC).GetConData(PDFInstDr)
			s countLabIndic=countLabIndic+1
			s PHINSTCount=countLabIndic
		}
		if (PINLCode="LabIndic") ;适应证
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCLABDiseaseI).GetIndData(PDFInstDr)
			s countLabContr=countLabContr+1
			s PHINSTCount=countLabContr
		}
		if (PINLCode="LabClinical") ;临床意义
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCLabClinical).GetData(PDFInstDr)
			s countLabClinical=countLabClinical+1
			s PHINSTCount=countLabClinical
		}
			if (PINLCode="LabInterEach") ;相互作用
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCLABDiseaseInteract).GetData(PDFInstDr)
			s countLabInterEach=countLabInterEach+1
			s PHINSTCount=countLabInterEach
		}
		if (PINLCode="LabMatNeAt") ;注意事项
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCLABMHA).GetData(PDFInstDr)
			s countLabMatNeAt=countLabMatNeAt+1
			s PHINSTCount=countLabMatNeAt
		}
		if (PINLCode="LabResultDiag") ;检验结果辅助诊断
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCPHLibResultDiag).GetData(PDFInstDr)
			s countLabResultDiag=countLabResultDiag+1
			s PHINSTCount=countLabResultDiag
		}
		
		//检查项目,放射,超声,治疗项目
		
		if (PINLCode="RADIContr")||(PINLCode="ULTRContr")||(PINLCode="ENDOContr")||(PINLCode="CheckContr")||(PINLCode="TreatContr") ;禁忌证
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCCheckDiseaseC).GetConData(PDFInstDr)
			s countCheckContr=countCheckContr+1
			s PHINSTCount=countCheckContr
			b ;11
		}
		if (PINLCode="RADIIndic")||(PINLCode="ULTRIndic")||(PINLCode="ENDOIndic")||(PINLCode="CheckIndic")||(PINLCode="TreatIndic") ;适应证
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCCheckDiseaseI).GetIndData(PDFInstDr)
			s countCheckIndic=countCheckIndic+1
			s PHINSTCount=countCheckIndic
		}
		if (PINLCode="RADIMatNeAt")||(PINLCode="ULTRMatNeAt")||(PINLCode="ENDOMatNeAt")||(PINLCode="CheckMatNeAt") ;注意事项
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCCheckMHA).GetData(PDFInstDr)
			s countCheckMatNeAt=countCheckMatNeAt+1
			s PHINSTCount=countCheckMatNeAt
		}
		if (PINLCode="RADIAdvRea")||(PINLCode="ULTRAdvRea")||(PINLCode="ENDOAdvRea")||(PINLCode="CheckAdvRea") ;不良反应
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCCheckAR).GetData(PDFInstDr)
			s countCheckAdvRea=countCheckAdvRea+1
			s PHINSTCount=countCheckAdvRea
		}


		//心电
		
		if (PINLCode="ELECTIndic") ;适应症
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCECGDiseaseI).GetIndData(PDFInstDr)
			s countELECTIndic=countELECTIndic+1
			s PHINSTCount=countELECTIndic
		}
		if (PINLCode="ELECTContr") ;禁忌症
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCECGDiseaseC).GetConData(PDFInstDr)
			s countELECTContr=countELECTContr+1
			s PHINSTCount=countELECTContr
		}
		if (PINLCode="ELECTInterEach") ;相互作用
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCECGInteract).GetData(PDFInstDr)
			s countELECTInterEach=countELECTInterEach+1
			s PHINSTCount=countELECTInterEach
		}
		if (PINLCode="ELECTMatNeAt") ;注意事项
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCECGMHA).GetData(PDFInstDr)
			s countELECTMatNeAt=countELECTMatNeAt+1
			s PHINSTCount=countELECTMatNeAt
		}
		if (PINLCode="ELECTAdvRea") ;不良反应
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCECGAR).GetData(PDFInstDr)
			s countELECTAdvRea=countELECTAdvRea+1
			s PHINSTCount=countELECTAdvRea
		}
		
		//手术
		
		if (PINLCode="OPERRemind") ;高危提醒
		{
			s PHINSTDesc = ##class(web.DHCBL.KB.DHCOPERRemind).GetData(PDFInstDr)
			s countOPERRemind=countOPERRemind+1
			s PHINSTCount=countOPERRemind
		}
		
		
		if (PHINSTGroupDesc'="")
		{	
			d OutputRow
		}
	}
	/*
	//别称
	s PHEGAlRowId=0
	for  
	{	
		s PHEGAlRowId=$o(^DHCPHEGALi(0,"Gen",GenDr,PHEGAlRowId)) q:PHEGAlRowId="" 
		s PHINSTGroupDesc="别称"
		s PHINSTDesc=$p($g(^DHCPHEGAL(PHEGAlRowId)),"^",2)
		
		d OutputRow
	}*/
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PHINSTRowId,PHINSTDesc,PHINSTGroupDesc,PHINSTSoft,PHINSTCount)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDrugBookList1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDrugBookList1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDrugBookList1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
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
/// CreatDate: 2015-1-8
/// Description：根据知识库标识查询药品通用名关联字典表内容
/// Input: lib=DRUG/LAB/CHECK
/// Table：User.DHCGenLinkPointer
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCBusMain","GetInstrList","OPERATION","","")  
Query GetInstrList(lib, desc, point) As %Query(ROWSPEC = "GlPRowId,GlPGenDr,PHEGDesc,GlPPointer,PHEFDesc,GlPActiveFlag,GlPSysFlag")
{
}

ClassMethod GetInstrListExecute(ByRef qHandle As %Binary, lib, desc, point) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s:lib'="" lib=$ZCONVERT(lib,"U")	
	s:desc'="" desc=$ZCONVERT(desc,"U")
	//s:pointer'="" text=$ZCONVERT(pointer,"U")
	s GlPRowId=0
	for  
	{	
		s GlPRowId=$o(^DHCGENLINP(GlPRowId)) q:GlPRowId="" 

		s GlPGenDr=$p($g(^DHCGENLINP(GlPRowId)),"^",1)  //通用名Dr
		s GlPGenDrU=$ZCONVERT(GlPGenDr,"U")
		s PHEGDesc=""
		s:GlPGenDr'="" PHEGDesc=$p($g(^DHCPHEGEN(GlPGenDr)),"^",2) //通用名名称 PHEGActiveFlag
		s:GlPGenDr'="" PHEGActiveFlag=$p($g(^DHCPHEGEN(GlPGenDr)),"^",6) //通用名是否可用 
			
		s PHEGLibDr=$p($g(^DHCPHEGEN(GlPGenDr)),"^",7)
	 
		s:PHEGLibDr'="" PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) //知识库标识 药品
		s PHLICode1=$ZCONVERT(PHLICode,"U")	
		;b
		s GlPPointer=$p($g(^DHCGENLINP(GlPRowId)),"^",2)  //指针
		s PHEFDesc=""
		if (PHLICode1="DRUG")
		{
			s:GlPPointer'="" PHEFDesc=$p($g(^DHCPHEF(GlPPointer)),"^",2) //指针名称 
		}
		if (PHLICode1="LAB")
		{
			s:GlPPointer'="" PHEFDesc=$p($g(^DHCPHEGEN(GlPPointer)),"^",2) //指针名称 
		}
		if (PHLICode1="ULTR") || (PHLICode1="RADI") || (PHLICode1="ENDO") || (PHLICode1="ELECT") || (PHLICode1="OPERATION") || (PHLICode1="TREAT")
		{
			s:GlPPointer'="" PHEFDesc=$p($g(^DHCPHEPA(GlPPointer)),"^",2) //指针名称 
		} 
		
		
		s GlPPointerU=$ZCONVERT(GlPPointer,"U")
		s GlPActiveFlag=$p($g(^DHCGENLINP(GlPRowId)),"^",3)  //是否可用
		s GlPSysFlag=$p($g(^DHCGENLINP(GlPRowId)),"^",4)  //是否系统标识
		
		
		
		s PINYINPHEG=""
		s:desc'="" PINYINPHEG= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(PHEGDesc))
		//s PINYINPHEF= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(PHEFDesc))
		//别名查询
		s ALIASText1=""
		s ALIASText=""
		if (GlPGenDr'=""){
			for{
				s ALIASText=$o(^DHCPHEGALi(0,"GenText",GlPGenDr,ALIASText))
				q:ALIASText=""
				s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
			}
		}
		
		i (PHLICode1=lib)&((PHEGDesc[desc)||(ALIASText1[desc)||(PINYINPHEG[desc))&((GlPPointer=point)||(point=""))&(PHEGActiveFlag'="N") &(GlPActiveFlag'="N")  //条件PHEGActiveFlag
		{
			d OutputRow
		}
		
		;i (PHLICode1=lib)&((GlPPointerU=pointer)||(pointer=""))&((GlPGenDrU=gen)||(gen=""))   //条件
		;{
		;	d OutputRow
		;}		
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(GlPRowId,GlPGenDr,PHEGDesc,GlPPointer,PHEFDesc,GlPActiveFlag,GlPSysFlag)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetInstrListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetInstrListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
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

// 根据his通用名代码获取药品通用名id

/// w ##class(web.DHCBL.KB.DHCGenItmContrast).getGenRowId("药箅子")
ClassMethod getGenRowId(code As %String) As %String
{
	s str=-1
	if code="" q str
	s GICTId=$o(^DHCPHGENCON(0,"HisCode",code,0))  //获取对照表id
	if (GICTId'=""){
		s GICTDesc = $p($g(^DHCPHGENCON(GICTId)),"^",2)  //获取通用名描述
		s GICTDescU=$ZCONVERT(GICTDesc,"U")
		//s GICTDescU=$$ALPHAUP^SSUTIL4(GICTDesc) //转换成大写
		s id = $o(^DHCPHEGENi(0,"Desc",GICTDescU,0))  
		if (id=""){q str}
		s str=id
	}
	q str
}

/// 根据his通用名代码获取药品通用名desc
/// w ##class(web.DHCBL.KB.DHCGenItmContrast).getGenDesc("药箅子")
ClassMethod getGenDesc(code As %String) As %String
{
	s str=""
	if code="" q str
	s GICTId=$o(^DHCPHGENCON(0,"HisCode",code,0))  //获取对照表id
	if (GICTId'=""){
		s GICTDesc = $p($g(^DHCPHGENCON(GICTId)),"^",2)  //获取通用名描述
		s str=GICTDesc
	}
	q str
}

/// 根据his通用名代码获取剂型id
/// w ##class(web.DHCBL.KB.DHCBusMain).getFormRowId("软胶囊")
ClassMethod getFormRowId(code As %String) As %String
{
	s str=-1
	if code="" q str
	s FormId=$o(^DHCPHFOCON(0,"HisCode",code,0))  //获取对照表id
	if (FormId'=""){
		s FormDesc = $p($g(^DHCPHFOCON(FormId)),"^",2)  //获取剂型描述
		s FormDescU=$ZCONVERT(FormDesc,"U")
		s id = $o(^DHCPHEFi(0,"Desc",FormDescU,0)) 
		if (id=""){q str}
		s str=id
	}
	q str
}

/// 根据his通用名代码获取剂型desc
/// w ##class(web.DHCBL.KB.DHCBusMain).getFormDesc("材料")
ClassMethod getFormDesc(code As %String) As %String
{
	s str=""
	if (code="NULL")||(code="")
	{
		s str="NULL"
	}
	else
	{
		s FormId=$o(^DHCPHFOCON(0,"HisCode",code,0))  //获取对照表id
		if (FormId'=""){
			s FormDesc = $p($g(^DHCPHFOCON(FormId)),"^",2)  //获取剂型描述 
			s str=FormDesc
		}
	}
	q str
}

/// 根据his检查部位代码获取检查部位id
/// w ##class(web.DHCBL.KB.DHCBusMain).getPartRowId(NULL)
ClassMethod getPartRowId(code As %String = "") As %String
{
	s str=-1
	if (code="")
	{
	  s code="NULL"
	}
	
	if (code="NULL")
	{
		s PartId=""
		for
		{
			s PartId=$o(^DHCPHEPA(PartId)) q:PartId=""
			s PartDesc = $p($g(^DHCPHEPA(PartId)),"^",2)
			if (PartDesc ="NULL")
			{
				s str=PartId	
			}
			 	
		}  	
	}
	else
	{
		s PartId=$o(^DHCPHPACON(0,"HisCode",code,0))  //获取对照表id
		if (PartId'=""){
				s PartDesc = $p($g(^DHCPHPACON(PartId)),"^",2)  //获取部位描述
				s PartDescU=$ZCONVERT(PartDesc,"U")
				s id = $o(^DHCPHEPA(0,"Desc",PartDescU,0)) 
				if (id=""){q str}
				s str=id
			}
	
	}
	
	q str
}

/// 根据his检查部位代码获取检查部位desc
/// w ##class(web.DHCBL.KB.DHCBusMain).getPartDesc("")
ClassMethod getPartDesc(code As %String = "") As %String
{
	s str=""
	if (code="NULL")||(code="")
	{
		s str="NULL"
	}
	else
	{
		s PartId=$o(^DHCPHPACON(0,"HisCode",code,0))  //获取对照表id
		if (PartId'=""){
			s PartDesc = $p($g(^DHCPHPACON(PartId)),"^",2)  //获取部位描述 
			s str=PartDesc
		}

	}
	q str
}

/// Creator：谷雪萍
/// CreatDate: 2020-07-30
/// Description：根据his通用名代码获取知识库标识
/// Input：hiscode-his通用名代码
/// Output：知识库标识代码
/// w ##class(web.DHCBL.KB.DHCBusMain).GetLibCodeByHisCode("GZ00001")
ClassMethod GetLibCodeByHisCode(hiscode As %String) As %String
{
	q:hiscode="" ""
	s GICTId=$o(^DHCPHGENCON(0,"HisCode",hiscode,0))  //获取对照表id
	q:GICTId="" ""

	s GICTDesc = $p($g(^DHCPHGENCON(GICTId)),"^",2)  //获取通用名描述
	q:GICTDesc="" ""
	s GICTDescU=$ZCONVERT(GICTDesc,"U")
	//s GICTDescU=$$ALPHAUP^SSUTIL4(GICTDesc) //转换成大写
	s GenId = $o(^DHCPHEGENi(0,"Desc",GICTDescU,0))   //通用名字典ID 
	q:GenId="" ""
	s PHLICode=""
	s PHEGLibDr=$p($g(^DHCPHEGEN(GenId)),"^",7)  //知识库标识DR
    s:PHEGLibDr'="" PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) //知识库标识代码	
	q PHLICode
}

}
