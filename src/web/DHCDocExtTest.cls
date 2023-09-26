/// 名称: DHCMed.SSService.Main
/// 描述: dhcmed.main.csp页面数据加载方法  
///       dhcmed.security.csp页面数据加载及保存方法
/// 编写者：wuqk
/// 编写日期: 2010-03-30
Class web.DHCDocExtTest Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor) [ Inheritance = right, Not ProcedureBlock ]
{

/// w ##class(web.DHCDocExtTest).BuildMenuJsonItem("rootexam","1")
ClassMethod BuildMenuJsonItem(root As %String, LoopNode As %String) As %Stream.GlobalCharacter
{
	n (root,LoopNode,CFGFlag)
	Set Itemstream=##class(%Stream.GlobalCharacter).%New()
	do Itemstream.Rewind()
	d Itemstream.Write("[")
	
	set json=""
	s Node=0
	for {
		s amdValue="Node=$O(^DHCDocEntryTree("""_root_""","_LoopNode_","_Node_"))"
		s @amdValue
		q:Node=""
		s amdValue="Data=$g(^DHCDocEntryTree("""_root_""","_LoopNode_","_Node_"))"
		s @amdValue
		s Desc=$P(Data,"^",1)
		s Desc=##class(web.DHCDocUtil).UnEscape(Desc)
		s SpecItemValue=$P(Data,"^",2)
		s RefItemValue=$P(Data,"^",3)
		s RefARCOSItemValue=$P(Data,"^",4)
		s LeafDesc=$P(Data,"^",5)
		s LoopNodeIDStr=""
		for i=1:1:$l(LoopNode,",") {
			i LoopNodeIDStr="" s LoopNodeIDStr=$p(LoopNode,",",i)
			e  s LoopNodeIDStr=LoopNodeIDStr_"||"_$p(LoopNode,",",i)
		}
		i LeafDesc="leaf" {
			if CFGFlag=1 {
				i Itemstream.SizeGet()>1 d Itemstream.Write(",")
				d Itemstream.Write("{")
				d Itemstream.Write("""id"":"""_root_"||"_LoopNodeIDStr_"||"_Node_""",""text"":"""_Desc_""",""SpecItem"":"""_SpecItemValue_""",""RefItem"":"""_RefItemValue_""",""RefARCOSItem"":"""_RefARCOSItemValue_""",""LeafDesc"":"""_LeafDesc_""",")
				d Itemstream.Write("""leaf"":true")
				d Itemstream.Write("}")
			}
			
			//d Itemstream.Write("{")
			//d Itemstream.Write("""id"":"""_root_"||"_LoopNodeIDStr_"||"_Node_""",""text"":"""_Desc_""",""SpecItem"":"""_SpecItemValue_""",""RefItem"":"""_RefItemValue_""",""RefARCOSItem"":"""_RefARCOSItemValue_""",""LeafDesc"":"""_LeafDesc_""",")
			;i json'="" s json=json_","
			;s json=json_"{"
			;s json=json_"""id"":"""_root_"||"_LoopNodeIDStr_"||"_Node_""",""text"":"""_Desc_""",""SpecItem"":"""_SpecItemValue_""",""RefItem"":"""_RefItemValue_""",""RefARCOSItem"":"""_RefARCOSItemValue_""",""LeafDesc"":"""_LeafDesc_""","
			//d Itemstream.Write("""leaf"":true")
			//d Itemstream.Write("}")
			;s json=json_"""leaf"":true"
			;s json=json_"}"
		}else{
			i Itemstream.SizeGet()>1 d Itemstream.Write(",")
			d Itemstream.Write("{")
			d Itemstream.Write("""id"":"""_root_"||"_LoopNodeIDStr_"||"_Node_""",""text"":"""_Desc_""",""SpecItem"":"""_SpecItemValue_""",""RefItem"":"""_RefItemValue_""",""RefARCOSItem"":"""_RefARCOSItemValue_""",""LeafDesc"":"""_LeafDesc_""",")
			;i json'="" s json=json_","
			;s json=json_"{"
			;s json=json_"""id"":"""_root_"||"_LoopNodeIDStr_"||"_Node_""",""text"":"""_Desc_""",""SpecItem"":"""_SpecItemValue_""",""RefItem"":"""_RefItemValue_""",""RefARCOSItem"":"""_RefARCOSItemValue_""",""LeafDesc"":"""_LeafDesc_""","
			s amdValue="Collap=$O(^DHCDocEntryTree("""_root_""","_LoopNode_","_Node_",0))"
			s @amdValue
			if Collap="" s Collap="false"
			e  s Collap="true"
			d Itemstream.Write("""expanded"":false,""collapsible"":"_Collap_",")
			d Itemstream.Write("""leaf"":false")
			;s json=json_"""expanded"":false,""collapsible"":"_Collap_","
			;s json=json_"""leaf"":false"
			s jsonItem=..BuildMenuJsonItem(root,LoopNode_","_Node)
			i $IsObject(jsonItem) {
				d Itemstream.Write(",""children"":")
				d jsonItem.Rewind()
				While (jsonItem.AtEnd = 0) 
				{
					Set len = 1024
					set json= jsonItem.Read(len)
					d Itemstream.Write(json)
				}
			}
			d Itemstream.Write("}")
			;i jsonItem'="" s json=json_",""children"":"_jsonItem
			;s json=json_"}"
		}
	}
	
	d Itemstream.Write("]")
	;s json="["_json_"]"


	q Itemstream
}

/// CreatDate：   2010-03-30
/// Description:  菜单信息
/// Table：       
/// Input：       root 根节点,CFGFlag 是否显示数根节点表示 1 显示,其他 不显示
///               ParentId:  父菜单Id
/// Return：      返回json格式的菜单信息，
/// Others:       此方法内部调用，构建菜单树,最多支持5层结构树
/// d ##class(web.DHCDocExtTest).BuildMenuJson("rootexam",1)
ClassMethod BuildMenuJson(root, CFGFlag = "0") As %String
{
	s ^gry("BuildMenuJson")=root_","_CFGFlag
	set json=""
	if root="" quit json
	
	Set Itemstream=##class(%Stream.GlobalCharacter).%New()
	do Itemstream.Rewind()
	do Itemstream.Write("[")
	
	s Node1=0
	for {
		s Node1=$O(^DHCDocEntryTree(root,Node1)) q:Node1=""
		s Data=$g(^DHCDocEntryTree(root,Node1))
		s Desc=$P(Data,"^",1)
		s Desc=##class(web.DHCDocUtil).UnEscape(Desc)
		s SpecItemValue=$P(Data,"^",2)
		s RefItemValue=$P(Data,"^",3)
		s RefARCOSItemValue=$P(Data,"^",4)
		s LeafDesc=$P(Data,"^",5)
		
		i LeafDesc="leaf" {
			i Itemstream.SizeGet()>1 d Itemstream.Write(",")
			d Itemstream.Write("{")
			d Itemstream.Write("""id"":"""_root_"||"_Node1_""",""text"":"""_Desc_""",""SpecItem"":"""_SpecItemValue_""",""RefItem"":"""_RefItemValue_""",""RefARCOSItem"":"""_RefARCOSItemValue_""",""LeafDesc"":"""_LeafDesc_""",")
			;i json'="" s json=json_","
			;s json=json_"{"
			;s json=json_"""id"":"""_root_"||"_Node1_""",""text"":"""_Desc_""",""SpecItem"":"""_SpecItemValue_""",""RefItem"":"""_RefItemValue_""",""RefARCOSItem"":"""_RefARCOSItemValue_""",""LeafDesc"":"""_LeafDesc_""","
			d Itemstream.Write("""leaf"":true")
			d Itemstream.Write("}")
			;s json=json_"""leaf"":true"
			;s json=json_"}"
		}else{
			i Itemstream.SizeGet()>1 d Itemstream.Write(",")
			
			d Itemstream.Write("{")
			d Itemstream.Write("""id"":"""_root_"||"_Node1_""",""text"":"""_Desc_""",""SpecItem"":"""_SpecItemValue_""",""RefItem"":"""_RefItemValue_""",""RefARCOSItem"":"""_RefARCOSItemValue_""",""LeafDesc"":"""_LeafDesc_""",")
			;i json'="" s json=json_","
			;s json=json_"{"
			;s json=json_"""id"":"""_root_"||"_Node1_""",""text"":"""_Desc_""",""SpecItem"":"""_SpecItemValue_""",""RefItem"":"""_RefItemValue_""",""RefARCOSItem"":"""_RefARCOSItemValue_""",""LeafDesc"":"""_LeafDesc_""","
			s Collap=$O(^DHCDocEntryTree(root,Node1,0))
			if Collap="" s Collap="false"
			e  s Collap="true"
			d Itemstream.Write("""expanded"":false,""collapsible"":"_Collap_",")
			d Itemstream.Write("""leaf"":false")
			;s json=json_"""expanded"":false,""collapsible"":"_Collap_","
			;s json=json_"""leaf"":false"
			s jsonItem=..BuildMenuJsonItem(root,Node1)
			i $IsObject(jsonItem) {
				d Itemstream.Write(",""children"":")
				d jsonItem.Rewind()
				While (jsonItem.AtEnd = 0) 
				{
					Set len = 1024
					set json= jsonItem.Read(len)
					d Itemstream.Write(json)
				}
			}
			d Itemstream.Write("}")
			;i jsonItem'="" s json=json_",""children"":"_jsonItem
			;s json=json_"}"
		}
		
		
	}
	
	d Itemstream.Write("]")
	;s json="["_json_"]"
	
	d Itemstream.Rewind()
	While (Itemstream.AtEnd = 0) 
	{
		Set len = 1024
		set json= Itemstream.Read(len)
		w json
	}
	
	Q
}

/// 把noderowstr下的子串成json
/// 2011-12-1 wanghc
/// w ##class(web.DHCDocExtTest).getArcimJsonDataRowid("""rootlab"",23,2")
ClassMethod getArcimJsonDataRowid(NodeRowStr) As %String
{
	s CurLogonHosp=%session.Get("LOGON.HOSPID")
	s parentName="",amdValueRow="parentName=$g(^DHCDocEntryTree("_NodeRowStr_"))"
	s @amdValueRow,lab=$p(parentName,"^",2),parentName=$p(parentName,"^") 
	s rowcount=1 , NodeRow=0,myStrRow=""	;,GROUPID=1
	f  s amdValueRow="NodeRow=$O(^DHCDocEntryTree("_NodeRowStr_","_NodeRow_"))",@amdValueRow q:NodeRow=""  d
	.q:NodeRow=""
	.s amdValueRow="DataRow=$g(^DHCDocEntryTree("_NodeRowStr_","_NodeRow_"))"
	.s @amdValueRow
	.s DescRow=$P(DataRow,"^",1)
	.s DescRow=##class(web.DHCDocUtil).UnEscape(DescRow)
	.s LeafDescRow=$P(DataRow,"^",5)
	.q:LeafDescRow'="leaf"
	.s RowId="",Desc=""
	.s ActiveFlag=0,OrderAuthInValid=0
	.s RefARCOSItemValueRow=$P(DataRow,"^",4), RefItemValueRow=$P(DataRow,"^",3)	
	.i (RefARCOSItemValueRow'="")  d
	..s ActiveFlag=##class(web.DHCDocOrderEntry).ValARCOS(RefARCOSItemValueRow)
	..s ARCOSItemStr=..GetArcimStr(RefARCOSItemValueRow)
	..s CatRowId=$p($g(^ARCOS(RefARCOSItemValueRow)),"^",8)
	..s subCatRowId=$p($g(^ARCOS(RefARCOSItemValueRow)),"^",9)
	..;s OrderAuthInValid=##class(web.DHCDocOrderEntry).ValOrdcat(GROUPID,CatRowId,subCatRowId)
	..s OrderAuthInValid=##class(web.DHCDocOrderEntry).ValOrd("ARCOS",GROUPID,RefItemValueRow,"","",UserRowId,CurLogonDep)
	..s RowId=RefARCOSItemValueRow
	..i RowId'="" s Desc=$tr($p($g(^ARCOS(RowId)),"^",2),$c(13,10),"")
	..s ARCOSPrice=0.00
	..//取医嘱套价格
	..s Childsub=0
	..f  s Childsub=$o(^ARCOS(RowId,"DATE",Childsub)) q:Childsub=""  d
	...s ITMChildsub=0
	...f  s ITMChildsub=$o(^ARCOS(RowId,"DATE",Childsub,"ITM",ITMChildsub)) q:ITMChildsub=""  d
	....s ITMARCIMDR=$p(^ARCOS(RowId,"DATE",Childsub,"ITM",ITMChildsub),"^",1)
	....s PatType="", InsType="", PriorRowid="", InstrRowid="", LinkTo="", OEPrice="",SttDate=..%SysDate(),EpisodeID="",PAADMRegConDisDR=""
	....s ExpStrin="^^"_EpisodeID_"^"_""_"^"_CurLogonHosp
	....s retPrice=##class(web.DHCDocOrderEntry).GetOrderPrice(PatType, InsType, ITMARCIMDR, SttDate, PriorRowid, InstrRowid, LinkTo, OEPrice,PAADMRegConDisDR,"",ExpStrin)
	....s ItemPrice=$fn($P(retPrice,"^",1),"",2)
	....s ARCOSPrice=ARCOSPrice+ItemPrice
	..s ARCOSPrice=$fn(ARCOSPrice,"",2)
	..s Desc=Desc_" ("_ARCOSPrice_"元)"
	
	.i (RefItemValueRow'="") d
	..s ActiveFlag=##class(web.DHCDocOrderEntry).ValARCItem(RefItemValueRow)
	..s CatRowId=""
	..s subCatRowId=$p($g(^ARCIM(+RefItemValueRow,+$p(RefItemValueRow,"||",2),1)),"^",10)
	..i subCatRowId'="" s CatRowId=$p($g(^ARC("IC",subCatRowId)),"^",8)
	..;s OrderAuthInValid=##class(web.DHCDocOrderEntry).ValOrdcat(GROUPID,CatRowId,subCatRowId)
	..s OrderAuthInValid=##class(web.DHCDocOrderEntry).ValOrd("ARCIM",GROUPID,RefItemValueRow,"","",UserRowId,CurLogonDep)
	..s OrdOnItOwn=$p($g(^ARCIM(+RefItemValueRow,+$p(RefItemValueRow,"||",2),7)),"^",13)
	..s RowId=RefItemValueRow
	..i RowId'="" d
	...s Desc=$tr($p($g(^ARCIM(+RowId,$P(RowId,"||",2),1)),"^",2),$c(13,10),"")	
	...s PatType="", InsType="", PriorRowid="", InstrRowid="", LinkTo="", OEPrice="",SttDate=..%SysDate(),EpisodeID="",PAADMRegConDisDR=""
	...s ExpStrin="^^"_EpisodeID_"^"_""_"^"_CurLogonHosp
	...s retPrice=##class(web.DHCDocOrderEntry).GetOrderPrice(PatType, InsType, RowId, SttDate, PriorRowid, InstrRowid, LinkTo, OEPrice,PAADMRegConDisDR,"",ExpStrin)
	...s ItemPrice=$fn($P(retPrice,"^",1),"",2)_"元"
	...s Desc=Desc_" ("_ItemPrice_")"
	.q:(ActiveFlag=1)
	.q:(OrderAuthInValid=0)
	.q:(RefARCOSItemValueRow'="")&&(ARCOSItemStr="")
	.q:(RefItemValueRow'="")&&(OrdOnItOwn="N")
	.s:lab'="" RowId=RowId_$c(1)_lab
	.i (rowcount#3=1) d
	..s:(myStrRow'="")&&($e(myStrRow,$l(myStrRow),$l(myStrRow))'="}") myStrRow=myStrRow_"}"
	..i myStrRow="" s myStrRow="{""code"":"""_RowId_""",""select"":"""",""name"":"""_Desc_""",""parentName"":"""_parentName_""""
	..e  s myStrRow=myStrRow_","_"{""code"":"""_RowId_""",""select"":"""",""name"":"""_Desc_""",""parentName"":"""_parentName_""""
	.i (rowcount#3=2) d 
	..s myStrRow=myStrRow_",""code1"":"""_RowId_""",""select1"":"""",""name1"":"""_Desc_""""
	.i (rowcount#3=0) d 
	..s myStrRow=myStrRow_",""code2"":"""_RowId_""",""select2"":"""",""name2"":"""_Desc_"""}"
	.s rowcount=rowcount+1
	s:(myStrRow'="")&&($e(myStrRow,$l(myStrRow),$l(myStrRow))'="}") myStrRow=myStrRow_"}"
	q myStrRow
}

ClassMethod getArcimJsonDataItemNew(NodeStr As %String) As %Stream.GlobalCharacter
{
	n (NodeStr,results,GROUPID,CurLogonDep,UserRowId,groupCount,%session)
	if NodeStr="" Q ""	
	s Node=0
	for {
		s amdValue="Node=$O(^DHCDocEntryTree("_NodeStr_","_Node_"))"
		s @amdValue
		q:Node=""
		s amdValue="Data=$g(^DHCDocEntryTree("_NodeStr_","_Node_"))"
		s @amdValue
		s LeafDesc=$P(Data,"^",5)
		i (LeafDesc="leaf") {
			s tempStr = ..getArcimJsonDataRowid(NodeStr)
			i tempStr'="",groupCount'=0 w ","
			w tempStr
			s groupCount=groupCount+1
			q
		}else{
			d ..getArcimJsonDataItemNew(NodeStr_","_Node)
		}
	}
	Q ""
}

ClassMethod getArcimJsonDataItem(NodeStr As %String) As %String
{
	n (NodeStr,results,GROUPID)
	s myStr=""
	if NodeStr="" Q myStr
	s Node=0
	for {
		s amdValue="Node=$O(^DHCDocEntryTree("_NodeStr_","_Node_"))"
		s @amdValue
		q:Node=""
		s amdValue="Data=$g(^DHCDocEntryTree("_NodeStr_","_Node_"))"
		s @amdValue
		s Desc=$P(Data,"^",1)
		s Desc=##class(web.DHCDocUtil).UnEscape(Desc)
		s SpecItemValue=$P(Data,"^",2)
		s RefItemValue=$P(Data,"^",3)
		s RefARCOSItemValue=$P(Data,"^",4)
		s LeafDesc=$P(Data,"^",5)
		s LoopNodeIDStr=""

		i LeafDesc="leaf" {
			s RowId="",Desc=""
			if RefARCOSItemValue'="" {
				s ActiveFlag=##class(web.DHCDocOrderEntry).ValARCOS(RefARCOSItemValue)
				i ActiveFlag=1 continue
				s ARCOSItemStr=..GetArcimStr(RefARCOSItemValue)
				i ARCOSItemStr="" continue
				s CatRowId=$p($g(^ARCOS(RefARCOSItemValue)),"^",8)
				s subCatRowId=$p($g(^ARCOS(RefARCOSItemValue)),"^",9)
				s OrderAuthInValid=##class(web.DHCDocOrderEntry).ValOrdcat(GROUPID,CatRowId,subCatRowId)
				i OrderAuthInValid=1 continue
				s RowId=RefARCOSItemValue
				i RowId'="" s Desc=$p($g(^ARCOS(RowId)),"^",2)
			}
			if RefItemValue'="" {
				s ActiveFlag=##class(web.DHCDocOrderEntry).ValARCItem(RefItemValue)
				i ActiveFlag=1 continue
				s CatRowId=""
				s subCatRowId=$p($g(^ARCIM(+RefItemValue,+$p(RefItemValue,"||",2),1)),"^",10)
				i subCatRowId'="" s CatRowId=$p($g(^ARC("IC",subCatRowId)),"^",8)
				s OrderAuthInValid=##class(web.DHCDocOrderEntry).ValOrdcat(GROUPID,CatRowId,subCatRowId)
				i OrderAuthInValid=1 continue
				s OrdOnItOwn=$p($g(^ARCIM(+RefItemValue,+$p(RefItemValue,"||",2),7)),"^",13)
    			i $g(OrdOnItOwn)="N" continue
				s RowId=RefItemValue
				i RowId'="" s Desc=$p($g(^ARCIM(+RowId,$P(RowId,"||",2),1)),"^",2)
			}
			
			;i myStr="" s myStr="{""code"":"""_RowId_""",""select"":"""",""name"":"""_Desc_"""}"
			;e  s myStr=myStr_","_"{""code"":"""_RowId_""",""select"":"""",""name"":"""_Desc_"""}"
			i results#3=1 {
				i myStr="" s myStr="{""code"":"""_RowId_""",""select"":"""",""name"":"""_Desc_""""
				e  s myStr=myStr_","_"{""code"":"""_RowId_""",""select"":"""",""name"":"""_Desc_""""
			}
			i results#3=2 {
				;i myStr="" s myStr="{""code1"":"""_RowId_""",""select1"":"""",""name1"":"""_Desc_""""
				;e  s myStr=myStr_","_"{""code1"":"""_RowId_""",""select1"":"""",""name1"":"""_Desc_""""
				s myStr=myStr_","_"""code1"":"""_RowId_""",""select1"":"""",""name1"":"""_Desc_""""
			}
			i results#3=0 {
				s myStr=myStr_",""code2"":"""_RowId_""",""select2"":"""",""name2"":"""_Desc_"""}"
			} 
			s results=results+1
		}else{
			;s myStr=myStr_"{""code"":"""_RowId_""",""select"":"""",""name"":"""_Desc_""""
			;s myStr=myStr_",""code1"":"""_RowId_""",""select1"":"""",""name1"":"""_""_"""}"
			;s results=results+2
		} 
		
		s myItemStr=..getArcimJsonDataItem(NodeStr_","_Node)
		i myItemStr'="" {
			i myStr="" {
				s myStr=myItemStr
			}else{
				i $e(myStr,$l(myStr),$l(myStr))'="}" s myStr=myStr_myItemStr
				e  s myStr=myStr_","_myItemStr
			}
			;s:$e(myStr,$l(myStr),$l(myStr))'="}" myStr=myStr_"},{""code"":"""",""select"":"""",""name"":"""",""code1"":"""",""select1"":"""",""name1"":"""",""code2"":"""",""select2"":"""",""name2"":""""}"
		}
	}
	
	
	Q myStr
}

/// Creator：    
/// CreatDate：   2010-03-30
/// Description:  菜单信息
/// Table：       
/// Input：     
///               ParentId:  父菜单Id
/// Return：      返回json格式的菜单信息，
/// Others:       此方法内部递归调用，构建菜单树
/// w ##class(web.DHCDocExtTest).getArcimJsonData("rootlab||23||2")
ClassMethod getArcimJsonData(PrentId As %String = "") As %String
{
	s ^gry("getArcimJsonData")=PrentId
	s GROUPID=%session.Get("LOGON.GROUPID")  //29 
	s CurLogonDep=%session.Get("LOGON.CTLOCID") //110 
	s UserRowId=%session.Get("LOGON.USERID") //4634 
	s CurLogonHosp=%session.Get("LOGON.HOSPID") //2 
	;s GROUPID=1
	s json=""
	q:PrentId="" json
	s results=1,myStr=""
	s LoopNodeStr="",groupCount=0
	for i=1:1:$l(PrentId,"||") {
		s temp=$P(PrentId,"||",i)
		i i=1 s temp=""""_temp_""""
		i LoopNodeStr="" s LoopNodeStr=temp
		e  s LoopNodeStr=LoopNodeStr_","_temp
	}
	s newflag=1
	if newflag {
		w "{""rows"":["
		d ..getArcimJsonDataItemNew(LoopNodeStr)
		w "],""results"":0}"
	}else{
		s myStr=..getArcimJsonDataItem(LoopNodeStr)	//..getArcimJsonDataItem(LoopNodeStr)
		i (myStr'="")&($e(myStr,$l(myStr),$l(myStr))'="}") s myStr=myStr_"}"
		s json="{""results"":"_(results\3)_","
    	s json=json_"""rows"":["
    	s json=json_myStr
		s json=json_"]}"
	}
	Q json
}

ClassMethod DelNodeJsonData(myId As %String) As %String
{
	n (myId)
	s ^gry("DelNodeJsonData")=myId
	s myrtn=0
	Q:myId="" "未找到节点."
	
	s KillNodeStr=""
	for i=1:1:$l(myId,"||") {
		s Node=$p(myId,"||",i)
		i KillNodeStr="" s KillNodeStr=""""_Node_""""
		e  s KillNodeStr=KillNodeStr_","""_Node_""""
	}
	s aCmdValue="^DHCDocEntryTree("_KillNodeStr_")"
	s ^gry("DelNodeJsonData",1)=aCmdValue
	Kill @aCmdValue
	
	Q myrtn
}

/// creator:guorongyong
/// date:2011-09-14
/// desc:得检验标本项目记录,借用了成本核算组的公共方法
/// w ##class(web.DHCDocExtTest).SelectSpecItem("血","rootlab",0,10)
ClassMethod SelectSpecItem(searchValue As %String, RowId As %String, start As %String, limit As %String) As %String
{
	s ^gry("SelectSpecItem")=searchValue_","_RowId_","_start_","_limit
	s Count=0
	k ^TMPSelectSLAArcim($j)
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	s jsonTitle="rowId^code^name"

	/*s SpecId=0
	for {
		s SpecId=$O(^TTAB("SPEC",SpecId)) q:SpecId=""
		s rowId=SpecId
		s code=SpecId
		s name=$p($g(^TTAB("SPEC",SpecId)),"\",1)
		s DateFrom=$p($g(^TTAB("SPEC",SpecId)),"\",6)
		s DateTo=$p($g(^TTAB("SPEC",SpecId)),"\",7)
		if (searchValue'="")&&(code'[searchValue)&&(name'[searchValue) continue
		if (DateFrom'="")&&(DateFrom>+$H) continue
		if (DateTo'="")&&(DateTo<+$H) continue
		s tmp=rowId_"^"_code_"^"_name
		s Count=Count+1
		s ^TMPSelectSLAArcim($j,Count)=tmp
	}*/
	s HospitalCode=""
	i ($d(%session)) s HospitalCode=%session.Get("LOGON.HOSPID")
    i $d(^DHCLISBSVersion(1)) {
	    s HospitalCode=$g(HospitalCode)
		s HospitalDR=$o(^dbo.BTHospitalI("IndexCode",##Class(LIS.Util.Common).IndexData(HospitalCode),""))
		i '$l(HospitalDR) s HospitalDR = $o(^dbo.BTHospitalD(""))
		i $l(HospitalDR) {
			s SPECstr=""
			s SpecCode="" f  s SpecCode=$o(^dbo.BTSpecimenI("IndexCode",HospitalDR,SpecCode)) q:SpecCode=""  d
			.s SpecimenDR=$o(^dbo.BTSpecimenI("IndexCode",HospitalDR,SpecCode,""))
			.s SPECCode=$lg($g(^dbo.BTSpecimenD(SpecimenDR)),2)
			.s SPECDesc=$lg($g(^dbo.BTSpecimenD(SpecimenDR)),3)
			.s rowId=SpecimenDR
		    .s code=SPECCode
		    .s name=SPECDesc
		    .Q:(searchValue'="")&&(code'[searchValue)&&(name'[searchValue) 
		    .s tmp=rowId_"^"_code_"^"_name
		    .s Count=Count+1
		    .s ^TMPSelectSLAArcim($j,Count)=tmp
			
		}
    }else{
	 	s SpecId=0
	 for {
		s SpecId=$O(^TTAB("SPEC",SpecId)) q:SpecId=""
		s rowId=SpecId
		s code=SpecId
		s name=$p($g(^TTAB("SPEC",SpecId)),"\",1)
		s DateFrom=$p($g(^TTAB("SPEC",SpecId)),"\",6)
		s DateTo=$p($g(^TTAB("SPEC",SpecId)),"\",7)
		if (searchValue'="")&&(code'[searchValue)&&(name'[searchValue) continue
		if (DateFrom'="")&&(DateFrom>+$H) continue
		if (DateTo'="")&&(DateTo<+$H) continue
		s tmp=rowId_"^"_code_"^"_name
		s Count=Count+1
		s ^TMPSelectSLAArcim($j,Count)=tmp
	  }
    }
	
	for i=start+1:1:start+limit {
		s tmp=$g(^TMPSelectSLAArcim($j,i))
		d json.InsertRowData(tmp)
	}
	s resultString = json.getJsonData(jsonTitle,Count)
 	k json
 	k ^TMPSelectSLAArcim($j)
	q resultString
}

/// creator:guorongyong
/// date:2011-09-14
/// desc:得到叶子节点下的关联项目记录,借用了成本核算组的公共方法
/// w ##class(web.DHCDocExtTest).SelectSLAArcim("","2||1",0,10)
ClassMethod SelectSLAArcim(searchValue As %String, RowId As %String, start As %String, limit As %String, TYPE As %String = "") As %String
{
	s ^gry("SelectSLAArcim")=searchValue_","_RowId_","_start_","_limit_","_TYPE
	s Count=0
	k ^TMPSelectSLAArcim($j)
	Q:searchValue="" ""
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	s jsonTitle="rowId^code^name"
	
	Set rs=##Class(%ResultSet).%New("web.DHCOEOrdItemQuery:orderlookup")
	 If rs.QueryIsValid() { 
		 Set Status=rs.Execute(searchValue)
		 Set columns = rs.GetColumnCount()
	
		 If 'Status Quit
		 While rs.Next() {
			s rowId=rs.GetData(2)
			s datefrom=$p($g(^ARCIM(+rowId,1,1)),"^",13)
			continue:datefrom>$h
			s DateTo=$P($g(^ARCIM(+rowId,1,7)),"^", 1)
			continue:(DateTo'="")&&(DateTo<+$h)
			s subCATEG=$p($g(^ARCIM(+rowId,1,1)),"^",10)
			s OrderType=""
	        if subCATEG'="" s OrderType=$P(^ARC("IC",subCATEG),"^",7)
			i (TYPE="L^SERVICE")&&(##class(web.DHCDocOrderCommon).GetItemServiceFlag(rowId)'=1)&&(OrderType'="L") continue
			s code=##class(web.DHCDocUtil).EvalJSON(rs.GetData(3)) //rs.GetData(3)
			s name=##class(web.DHCDocUtil).EvalJSON(rs.GetData(1)) //rs.GetData(1)
			s tmp=rowId_"^"_code_"^"_name
			s Count=Count+1
			s ^TMPSelectSLAArcim($j,Count)=tmp		
		 }
	 }
	
	for i=start+1:1:start+limit {
		s tmp=$g(^TMPSelectSLAArcim($j,i))
		d json.InsertRowData(tmp)
	}
	s resultString = json.getJsonData(jsonTitle,Count)
 	k json
 	k ^TMPSelectSLAArcim($j)
	q resultString
}

/// creator:guorongyong
/// date:2011-09-14
/// desc:得到叶子节点下的关联项目记录,借用了成本核算组的公共方法
/// w ##class(web.DHCDocExtTest).SelectSLAArcos("","2||1",0,10)
ClassMethod SelectSLAArcos(searchValue As %String, RowId As %String, start As %String, limit As %String) As %String
{
	s ^gry("SelectSLAArcos")=searchValue_","_RowId_","_start_","_limit
	s Count=0
	k ^TMPSelectSLAArcim($j)
	Q:searchValue="" ""
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	s jsonTitle="rowId^code^name"
	
	Set rs=##Class(%ResultSet).%New("web.DHCOEOrdItemQuery:orderarcoslookup")
	 If rs.QueryIsValid() { 
		 Set Status=rs.Execute(searchValue)
		 Set columns = rs.GetColumnCount()
	
		 If 'Status Quit
		 While rs.Next() {
			s rowId=rs.GetData(2)
			s code=rs.GetData(3)
			s name=##class(web.DHCDocUtil).EvalJSON(rs.GetData(1))
			s tmp=rowId_"^"_code_"^"_name
			s Count=Count+1
			s ^TMPSelectSLAArcim($j,Count)=tmp		
		 }
	 }
	
	for i=start+1:1:start+limit {
		s tmp=$g(^TMPSelectSLAArcim($j,i))
		d json.InsertRowData(tmp)
	}
	s resultString = json.getJsonData(jsonTitle,Count)
 	k json
 	k ^TMPSelectSLAArcim($j)
	q resultString
}

/// w ##class(web.DHCDocExtTest).Save($g(^gry("Save")))
ClassMethod Save(Para As %String) As %String
{
	;s Para=SelNodeId_"^"_Desc_"^"_SpecFlag_"^"_SpecItemValue_"^"_ArcimFlag_"^"_RefItemValue_"^"_SLASDate_"^"_SLAEDate_"^"_ArcosFlag_"^"_RefARCOSItemValue_"^"_SLASArcosDate_"^"_SLAEArcosDate
	s ^gry("Save")=Para
	s myrtn=0
	s SelNodeId=$p(Para,"^",1)
	s RootNodeId=$p(Para,"^",2)
	s Desc=$p(Para,"^",3)
	s SpecFlag=$p(Para,"^",4)
	s SpecItemValue=$p(Para,"^",5)
	s ArcimFlag=$p(Para,"^",6)
	s RefItemValue=$p(Para,"^",7)
	s SLASDate=$p(Para,"^",8)
	s SLAEDate=$p(Para,"^",9)
	s ArcosFlag=$p(Para,"^",10)
	s RefARCOSItemValue=$p(Para,"^",11)
	s SLASArcosDate=$p(Para,"^",12)
	s SLAEArcosDate=$p(Para,"^",13)
	s Code=$p(Para,"^",14)
	s Desc=##class(web.DHCDocUtil).UnEscape(Desc)
	i SLASDate'="" s SLASDate=..%ZDH(SLASDate)
    i SLASArcosDate'="" s SLAEArcosDate=..%ZDH(SLAEArcosDate)
	/*if $l(SLASDate,"/")=3 s SLASDate=$zdh(SLASDate,4)
	if $l(SLAEDate,"/")=3 s SLAEDate=$zdh(SLAEDate,4)
	if $l(SLASDate,"-")=3 s SLASDate=$zdh(SLASDate,3)
	if $l(SLAEDate,"-")=3 s SLAEDate=$zdh(SLAEDate,3)
	if $l(SLASArcosDate,"/")=3 s SLASArcosDate=$zdh(SLASArcosDate,4)
	if $l(SLAEArcosDate,"/")=3 s SLAEArcosDate=$zdh(SLAEArcosDate,4)
	if $l(SLASArcosDate,"-")=3 s SLASArcosDate=$zdh(SLASArcosDate,3)
	if $l(SLAEArcosDate,"-")=3 s SLAEArcosDate=$zdh(SLAEArcosDate,3) */
	if (SelNodeId="root"){
		s aCmdValue="^DHCDocEntryTree("""_Code_""")="""_Desc_""""
    	s @aCmdValue
    	q 0
	}
	
	
    s ChildStr=0,ChildSub=1
    s Len=$L(SelNodeId,"||")
    for i=2:1:Len {
	    s ChildId=$p(SelNodeId,"||",i)
	    if +ChildId=0 Quit
	    i +ChildStr=0 s ChildStr=ChildId
	    e  s ChildStr=ChildStr_","_ChildId
    }
    i ChildStr'=0 {
	    s aCmdValue="ChildSub=$O(^DHCDocEntryTree("""_RootNodeId_""","_ChildStr_",""""),-1)"
	    s @aCmdValue
	    s ChildSub=$I(ChildSub)
	    s ChildStr=ChildStr_","_ChildSub
    }else{
	    s aCmdValue="ChildSub=$O(^DHCDocEntryTree("""_RootNodeId_""",""""),-1)"
	    s @aCmdValue
	    s ChildSub=$I(ChildSub)
	    s ChildStr=ChildSub
    }
    i (RefItemValue'="")||(RefARCOSItemValue'="") {
	    s NodeValue=Desc_"^"_SpecItemValue_"^"_RefItemValue_"^"_RefARCOSItemValue_"^"_"leaf"
    }else{
	    s NodeValue=Desc_"^"_SpecItemValue_"^"_RefItemValue_"^"_RefARCOSItemValue_"^"_""
    }
    s aCmdValue="^DHCDocEntryTree("""_RootNodeId_""","_ChildStr_")="""_NodeValue_""""
    s @aCmdValue
    
    Quit 0
}

ClassMethod UpdateNodeName(nodeId, desc) As %String
{
	q:nodeId ""
	q:desc ""
	s LoopNodeStr=""
	for i=1:1:$l(nodeId,"||") {
		s temp=$P(nodeId,"||",i)
		i i=1 s temp=""""_temp_""""
		i LoopNodeStr="" s LoopNodeStr=temp
		e  s LoopNodeStr=LoopNodeStr_","_temp
	}
	s aCmdValue="$p(^DHCDocEntryTree("_LoopNodeStr_"),""^"",1)=desc",@aCmdValue
	q ""
}

ClassMethod GetArcimStr(RowId As %String) As %String
{
	n (RowId)
	s ^gry("GetArcimStr")=RowId
	Q:RowId="" ""
	if RowId'["||" {
		s Str=""
		do ##class(web.DHCDocOrderEntry).OpenGetAllOrderSetItem(RowId)
		s count=0  f  s count=$o(^CacheTemp("ARCOI",$j,count)) q:count=""  d 
		.s item=0 f  s item=$o(^CacheTemp("ARCOI",$j,count,item)) q:item=""  s s=^(item) d
	 	..s ARCIMRowid=$p(s,"^",1)
	 	..s ARCOSItemQty=$p(s,"^",2)
	 	..s ARCIMDesc=$p($g(^ARCIM(+ARCIMRowid,$P(ARCIMRowid,"||",2),1)),"^",2)
	 	..i Str="" s Str=ARCIMRowid_$c(2)_ARCIMDesc
	 	..e  s Str=Str_"^"_ARCIMRowid_$c(2)_ARCIMDesc
		Q Str
	}
	Q ""
}

ClassMethod GetTarItems(ArcimRowid As %String) As %String
{
	n (ArcimRowid)
	s ^gry("GetTarItems")=ArcimRowid
	Q:ArcimRowid="" ""
	
	s id1=$p(ArcimRowid,"||",1)
	s id2=$p(ArcimRowid,"||",2)
	Q:$d(^ARCIM(id1,id2,1))=0 ""
	s ordcode=$p(^ARCIM(id1,id2,1),"^",1)
	s ordname2=$p(^ARCIM(id1,id2,1),"^",2)
    
    s Str=""
    s OLTStartDate="" f  s OLTStartDate=$o(^DHCOLT(0,"ARCIM",ArcimRowid,"Z",OLTStartDate)) q:OLTStartDate=""  d
	.s OLTRowId="" f  s OLTRowId=$o(^DHCOLT(0,"ARCIM",ArcimRowid,"Z",OLTStartDate,OLTRowId))  q:OLTRowId=""  d
	..s OLTEndDate=$p(^DHCOLT(OLTRowId),"^",5)
	..q:(OLTEndDate<=..%SysDate())&&($g(OLTEndDate)'="")
	..s TariffDR=$p(^DHCOLT(OLTRowId),"^",2)
	..s itmnum=$p(^DHCOLT(OLTRowId),"^",3)
	..q:TariffDR=""
	..s itmname=$p($g(^DHCTARI(TariffDR)),"^",2)
	..s itmcode=$p($g(^DHCTARI(TariffDR)),"^",1)
	..i Str="" s Str=TariffDR_$c(2)_itmname
	..e  s Str=Str_"^"_TariffDR_$c(2)_itmname
	
	Q Str
}

/// 移动节点
/// d ##class(web.DHCDocExtTest).MoveNode("rootexam||10||57","rootexam||10","rootexam||10",2,1,8)
ClassMethod MoveNode(nodeId, oldParentId, newParentId, oldParentDepth, newParentDepth, index)
{
	s ^gry("MoveNode")=nodeId_","_oldParentId_","_newParentId_","_oldParentDepth_","_newParentDepth_","_index 

	;不可移动到根节点下
	if newParentDepth=0 quit "-1"
	;不可跨检验,检查移动
	if $p(oldParentId,"||")'=$p(newParentId,"||") quit "-2"
	
		;同级移动
		if (oldParentDepth=newParentDepth){
			if oldParentId=newParentId {
				;同父节点移动
				d ..ReSortGlobal(newParentId,nodeId,index,"")
			}else{
				;不同父节点移动
				d ..ReSortGlobal(newParentId,nodeId,index,"Add")
				d ..ReSortGlobal(oldParentId,nodeId,index,"Low")
			}
		    
		}elseif (oldParentDepth>newParentDepth) {
			;向下级移动
			
			d ..ReSortGlobal(newParentId,nodeId,index,"Add")
			d ..ReSortGlobal(oldParentId,nodeId,index,"Low")
			
			
		}elseif (oldParentDepth>newParentDepth) {
			;向上级移动
			d ..ReSortGlobal(newParentId,nodeId,index,"Add")
			d ..ReSortGlobal(oldParentId,nodeId,index,"Low")
		}
}

ClassMethod ReSortGlobal(ParentId, Node, index, Type)
{
	n (ParentId,Node,index,Type)
	kill ^TMPNodeSort
	
	lock +(^TMPNodeSort):30
	b ;1
	if $Test {
		s ChildStr=""
		s Len=$L(ParentId,"||")
		s RootNodeId=$p(ParentId,"||",1)
	    for i=2:1:Len {
		    s ChildId=$p(ParentId,"||",i)
		    if +ChildId=0 Quit
		    i +ChildStr=0 s ChildStr=ChildId
		    e  s ChildStr=ChildStr_","_ChildId
	    }
	    if ChildStr="" s LoopChildStr=""""_RootNodeId_""""
	    else  s LoopChildStr=""""_RootNodeId_""","_ChildStr
	    if Type="" {
		    s CurChildStr=""
			s CurLen=$L(Node,"||")
			s CurRootNodeId=$p(Node,"||",1)
		    for i=2:1:CurLen {
			    s CurChildId=$p(Node,"||",i)
			    if +CurChildId=0 Quit
			    i +CurChildStr=0 s CurChildStr=CurChildId
			    e  s CurChildStr=CurChildStr_","_CurChildId
		    }
		    s aCmdNodeData="NodeData=^DHCDocEntryTree("""_CurRootNodeId_""","_CurChildStr_")"
		    s @aCmdNodeData
		    s NodeData=$g(NodeData)
		    b ;3,不使用type="Add"是因为使用之后NodeData在Low之后无法得到
		    s Count=0,ChildSub=0,SortChildSub=0,LatterDelFlag=0
		    for {
		    	s aCmdValue="ChildSub=$O(^DHCDocEntryTree("_LoopChildStr_","_ChildSub_"))"
		    	s @aCmdValue
		    	q:ChildSub=""
		    	s aCmdSortData="SortData=^DHCDocEntryTree("_LoopChildStr_","_ChildSub_")"
		    	s @aCmdSortData
		    	s SortData=$g(SortData)
		    	s Count=Count+1
		    	if Count>index {
			    	b ;4
			    	i SortChildSub=0 s SortChildSub=ChildSub
			    	if Count=(index+1) {
				    	b ;M 1
				    	if $p(Node,"||",$l(Node,"||"))>ChildSub {
					    	;节点往前调,插入节点应该在本次循环节点之前
					    	s SortChildSub=SortChildSub+1
					    	s aSortCmdValue="^TMPNodeSort("_LoopChildStr_","_SortChildSub_")="""_NodeData_""""
					    	s @aSortCmdValue
					    	b ;NodeData
					    	s aSortCmdValue="^TMPNodeSort("_LoopChildStr_","_SortChildSub_")=^DHCDocEntryTree("""_CurRootNodeId_""","_CurChildStr_")"
					    	m @aSortCmdValue
					    	d ..LowSortGlobal(Node)
				    	}else{
					    	;节点往后调,插入节点应该在本次循环节点之后
					    	s LatterDelFlag=1
				    	}
			    	}
			    	s SortChildSub=SortChildSub+1
			    	s aSortCmdValue="^TMPNodeSort("_LoopChildStr_","_SortChildSub_")="""_SortData_""""
			    	s @aSortCmdValue
			    	b ;SortData
			    	s aSortCmdValue="^TMPNodeSort("_LoopChildStr_","_SortChildSub_")=^DHCDocEntryTree("_LoopChildStr_","_ChildSub_")"
			    	m @aSortCmdValue
			    	i (LatterDelFlag=1)&&(Count=(index+1)) {
				    	s SortChildSub=SortChildSub+1
				    	s aSortCmdValue="^TMPNodeSort("_LoopChildStr_","_SortChildSub_")="""_NodeData_""""
				    	s @aSortCmdValue
				    	b ;NodeData
				    	s aSortCmdValue="^TMPNodeSort("_LoopChildStr_","_SortChildSub_")=^DHCDocEntryTree("""_CurRootNodeId_""","_CurChildStr_")"
				    	m @aSortCmdValue
				    	d ..LowSortGlobal(Node) 
			    	}
			    	b ;M 2
			    	s NeedDelNodeId=""
			    	for i=1:1:$L(LoopChildStr,",") {
				    	s TempDel=$p(LoopChildStr,",",i)
				    	if TempDel="" continue
				    	i i=1 s TempDel=$e(TempDel,2,$l(TempDel)-1)
				    	if NeedDelNodeId="" s NeedDelNodeId=TempDel
				    	else  s NeedDelNodeId=NeedDelNodeId_"||"_TempDel
			    	}
			    	s NeedDelNodeId=NeedDelNodeId_"||"_ChildSub
			    	d ..LowSortGlobal(NeedDelNodeId)
		    	}
		    }
		    b ;1111111
		    k ^tmpgry
		    m ^tmpgry=^TMPNodeSort
		    m ^DHCDocEntryTree=^TMPNodeSort
	    }elseif (Type="Add") {
		    ;仅增加节点
		    s CurChildStr=""
			s CurLen=$L(Node,"||")
			s CurRootNodeId=$p(Node,"||",1)
		    for i=2:1:CurLen {
			    s CurChildId=$p(Node,"||",i)
			    if +CurChildId=0 Quit
			    i +CurChildStr=0 s CurChildStr=CurChildId
			    e  s CurChildStr=CurChildStr_","_CurChildId
		    }
		    s aCmdNodeData="NodeData=^DHCDocEntryTree("""_CurRootNodeId_""","_CurChildStr_")"
		    s @aCmdNodeData
		    s NodeData=$g(NodeData)
		    b ;3
		    s Count=0,ChildSub=0,SortChildSub=0
		    for {
		    	s aCmdValue="ChildSub=$O(^DHCDocEntryTree("_LoopChildStr_","_ChildSub_"))"
		    	s @aCmdValue
		    	q:ChildSub=""
		    	s aCmdSortData="SortData=^DHCDocEntryTree("_LoopChildStr_","_ChildSub_")"
		    	s @aCmdSortData
		    	s SortData=$g(SortData)
		    	s Count=Count+1
		    	if Count>=index {
			    	b ;4
			    	i SortChildSub=0 s SortChildSub=ChildSub
			    	if Count=index {
				    	s SortChildSub=SortChildSub+1
				    	s aSortCmdValue="^TMPNodeSort("_LoopChildStr_","_SortChildSub_")="""_NodeData_""""
				    	s @aSortCmdValue
				    	b ;NodeData
				    	s aSortCmdValue="^TMPNodeSort("_LoopChildStr_","_SortChildSub_")=^DHCDocEntryTree("""_CurRootNodeId_""","_CurChildStr_")"
				    	m @aSortCmdValue 
				    	b ;M 1
				    	d ..LowSortGlobal(Node)
			    	}
			    	s SortChildSub=SortChildSub+1
			    	s aSortCmdValue="^TMPNodeSort("_LoopChildStr_","_SortChildSub_")="""_SortData_""""
			    	s @aSortCmdValue
			    	b ;SortData
			    	s aSortCmdValue="^TMPNodeSort("_LoopChildStr_","_SortChildSub_")=^DHCDocEntryTree("_LoopChildStr_","_ChildSub_")"
			    	m @aSortCmdValue
			    	b ;M 2
			    	;s NeedDelNodeId=RootNodeId_"||"_$tr(ChildStr,",","||")_"||"_ChildSub
			    	s NeedDelNodeId=""
			    	for i=1:1:$L(LoopChildStr,",") {
				    	s TempDel=$p(LoopChildStr,",",i)
				    	if TempDel="" continue
				    	i i=1 s TempDel=$e(TempDel,2,$l(TempDel)-1)
				    	if NeedDelNodeId="" s NeedDelNodeId=TempDel
				    	else  s NeedDelNodeId=NeedDelNodeId_"||"_TempDel
			    	}
			    	s NeedDelNodeId=NeedDelNodeId_"||"_ChildSub
			    	d ..LowSortGlobal(NeedDelNodeId)
		    	}
		    }
		    if Count=1
		    b ;1111111
		    m ^DHCDocEntryTree=^TMPNodeSort
		    
	    }
	}
	lock -(^TMPNodeSort)
}

ClassMethod LowSortGlobal(Node)
{
	s CurChildStr=""
	s CurLen=$L(Node,"||")
	s CurRootNodeId=$p(Node,"||",1)
    for i=2:1:CurLen {
	    s CurChildId=$p(Node,"||",i)
	    if +CurChildId=0 Quit
	    i +CurChildStr=0 s CurChildStr=CurChildId
	    e  s CurChildStr=CurChildStr_","_CurChildId
    }
    s aSortCmdKill="^DHCDocEntryTree("""_CurRootNodeId_""","_CurChildStr_")"
    b ;kill node
	kill @aSortCmdKill
}

ClassMethod LowTMPSortGlobal(Node)
{
	s CurChildStr=""
	s CurLen=$L(Node,"||")
	s CurRootNodeId=$p(Node,"||",1)
    for i=2:1:CurLen {
	    s CurChildId=$p(Node,"||",i)
	    if +CurChildId=0 Quit
	    i +CurChildStr=0 s CurChildStr=CurChildId
	    e  s CurChildStr=CurChildStr_","_CurChildId
    }
    s aSortCmdKill="^DHCDocEntryTree("""_CurRootNodeId_""","_CurChildStr_")"
    b ;kill node
	kill @aSortCmdKill
}

/// creator:郭荣勇
/// date:2012-02-20
/// 根据医嘱项目rowid得到医嘱提示
ClassMethod GetItemMsg(ArcimRowid As %String) As %String
{
	Q:ArcimRowid="" ""
	;s OrderMsg=$G(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),"RB",1))
	s OrderMsg=$G(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),"OEM",1))
	;s OrderMsg=$TR(OrderMsg,$C(13),"")
	;s OrderMsg=$TR(OrderMsg,$C(10),"")
	
	Q OrderMsg
}

/// 导入文本数据
/// 将文件命名为:LabTreeInfo.txt,放到导入服务器的D:\根目录下,为unix则放到/tmp/下
/// root:检验为rootlab,检查为rootexam
/// 现只导入四级以下结构数据
/// w ##class(web.DHCDocExtTest).ImportLab("rootlab")
/// w ##class(web.DHCDocExtTest).ImportLab("rootexam")
ClassMethod ImportLab(root) As %String
{
	if (root="rootlab") {
		Set file=##class(%File).%New("d:\LabTreeInfo.txt")
		set ExistsFlag=##class(%File).Exists("d:\LabTreeInfo.txt")
		if ExistsFlag'=1 d file.Open("N")
		d file.Close()
		
		Set stream=##class(%FileCharacterStream).%New()
		Set stream.Filename="d:\LabTreeInfo.txt"
	}
	if (root="rootexam") {
		Set file=##class(%File).%New("d:\ExamTreeInfo.txt")
		set ExistsFlag=##class(%File).Exists("d:\ExamTreeInfo.txt")
		if ExistsFlag'=1 d file.Open("N")
		d file.Close()
		
		Set stream=##class(%FileCharacterStream).%New()
		Set stream.Filename="d:\ExamTreeInfo.txt"
	}
	
	;Kill ^DHCDocEntryTree(root)
	
	w !,"导入中..."
	
	set Delimiter="	"
	set GroupCount=0,Count=0
	set myrtn=0

	While 'stream.AtEnd {
		Set line=stream.ReadLine()
		if line="" continue
		set Desc1=$p(line,Delimiter,1),Spec1=$p(line,Delimiter,2),ArcimCode1=$p(line,Delimiter,3),ArcosCode1=$p(line,Delimiter,4)
		set Desc2=$p(line,Delimiter,5),Spec2=$p(line,Delimiter,6),ArcimCode2=$p(line,Delimiter,7),ArcosCode2=$p(line,Delimiter,8)
		set Desc3=$p(line,Delimiter,9),Spec3=$p(line,Delimiter,10),ArcimCode3=$p(line,Delimiter,11),ArcosCode3=$p(line,Delimiter,12)
		set Desc4=$p(line,Delimiter,13),Spec4=$p(line,Delimiter,14),ArcimCode4=$p(line,Delimiter,15),ArcosCode4=$p(line,Delimiter,16)
		set Desc5=$p(line,Delimiter,17),Spec5=$p(line,Delimiter,18),ArcimCode5=$p(line,Delimiter,19),ArcosCode5=$p(line,Delimiter,20)
		
		s Desc1=$tr(Desc1,"""",""),Desc2=$tr(Desc2,"""",""),Desc3=$tr(Desc3,"""",""),Desc4=$tr(Desc4,"""","")
		set Spec1=$$ALPHAUP^SSUTIL4(Spec1),Spec2=$$ALPHAUP^SSUTIL4(Spec2)
		set Spec3=$$ALPHAUP^SSUTIL4(Spec3),Spec4=$$ALPHAUP^SSUTIL4(Spec4)
		set Spec5=$$ALPHAUP^SSUTIL4(Spec5)
		set Arcim1=$$getArcimIdByCode(ArcimCode1),Arcos1=$$getArcosIdByCode(ArcosCode1)
		set Arcim2=$$getArcimIdByCode(ArcimCode2),Arcos2=$$getArcosIdByCode(ArcosCode2)
		set Arcim3=$$getArcimIdByCode(ArcimCode3),Arcos3=$$getArcosIdByCode(ArcosCode3)
		set Arcim4=$$getArcimIdByCode(ArcimCode4),Arcos4=$$getArcosIdByCode(ArcosCode4)
		set Arcim5=$$getArcimIdByCode(ArcimCode5),Arcos5=$$getArcosIdByCode(ArcosCode5)
		
		if (ArcimCode1'="")&(Arcim1="") continue
		if (ArcosCode1'="")&(Arcos1="") continue
		if (ArcimCode2'="")&(Arcim2="") continue
		if (ArcosCode2'="")&(Arcos2="") continue
		if (ArcimCode3'="")&(Arcim3="") continue
		if (ArcosCode3'="")&(Arcos3="") continue
		if (ArcimCode4'="")&(Arcim4="") continue
		if (ArcosCode4'="")&(Arcos4="") continue
		if (ArcimCode5'="")&(Arcim5="") continue
		if (ArcosCode5'="")&(Arcos5="") continue
		
		s Count=Count+1
		
		;if Count>95 quit
		
		;找是否已经存在一级节点
		s findNode1=""
		s Node1Len=+$O(^DHCDocEntryTree(root,""),-1)
		for i=1:1:Node1Len {
			s Node1Data=$g(^DHCDocEntryTree(root,i))
			s Node1Desc=$p(Node1Data,"^",1),Node1Spec=$p(Node1Data,"^",2),Node1Arcim=$p(Node1Data,"^",3),Node1Arcos=$p(Node1Data,"^",4)
			if Node1Desc=Desc1 s findNode1=i quit
		}
		if findNode1="" s findNode1=Node1Len+1
		if (Arcim1'="")||(Arcos1'="") {
			s LeafNode="leaf"
			s ^DHCDocEntryTree(root,findNode1)=Desc1_"^"_Spec1_"^"_Arcim1_"^"_Arcos1_"^"_LeafNode
			continue
		}else{
			s LeafNode=""
			s ^DHCDocEntryTree(root,findNode1)=Desc1_"^"_Spec1_"^"_Arcim1_"^"_Arcos1_"^"_LeafNode
		}
		;找二级节点
		s findNode2=""
		s Node2Len=+$O(^DHCDocEntryTree(root,findNode1,""),-1)
		for i=1:1:Node2Len {
			s Node2Data=$g(^DHCDocEntryTree(root,findNode1,i))
			s Node2Desc=$p(Node2Data,"^",1),Node2Spec=$p(Node2Data,"^",2),Node2Arcim=$p(Node2Data,"^",3),Node2Arcos=$p(Node2Data,"^",4)
			if Node2Desc=Desc2 s findNode2=i quit
		}
		if findNode2="" s findNode2=Node2Len+1
		if (Arcim2'="")||(Arcos2'="") {
			s LeafNode="leaf"
			s ^DHCDocEntryTree(root,findNode1,findNode2)=Desc2_"^"_Spec2_"^"_Arcim2_"^"_Arcos2_"^"_LeafNode
			continue
		}else{
			s LeafNode=""
			s ^DHCDocEntryTree(root,findNode1,findNode2)=Desc2_"^"_Spec2_"^"_Arcim2_"^"_Arcos2_"^"_LeafNode
		}
		;找三级节点
		s findNode3=""
		s Node3Len=+$O(^DHCDocEntryTree(root,findNode1,findNode2,""),-1)
		for i=1:1:Node3Len {
			s Node3Data=$g(^DHCDocEntryTree(root,findNode1,findNode2,i))
			s Node3Desc=$p(Node3Data,"^",1)
			if Node3Desc=Desc3 s findNode3=i quit
		}
		if findNode3="" s findNode3=Node3Len+1
		if (Arcim3'="")||(Arcos3'="") {
			s LeafNode="leaf"
			s ^DHCDocEntryTree(root,findNode1,findNode2,findNode3)=Desc3_"^"_Spec3_"^"_Arcim3_"^"_Arcos3_"^"_LeafNode
			continue
		}else{
			s LeafNode=""
			s ^DHCDocEntryTree(root,findNode1,findNode2,findNode3)=Desc3_"^"_Spec3_"^"_Arcim3_"^"_Arcos3_"^"_LeafNode
		}
		;找四级节点
		s findNode4=""
		s Node4Len=+$O(^DHCDocEntryTree(root,findNode1,findNode2,findNode3,""),-1)
		for i=1:1:Node4Len {
			s Node4Data=$g(^DHCDocEntryTree(root,findNode1,findNode2,findNode3,i))
			s Node4Desc=$p(Node4Data,"^",1)
			if Node4Desc=Desc4 s findNode4=i quit
		}
		if findNode4="" s findNode4=Node4Len+1
		if (Arcim4'="")||(Arcos4'="") {
			s LeafNode="leaf"
			s ^DHCDocEntryTree(root,findNode1,findNode2,findNode3,findNode4)=Desc4_"^"_Spec4_"^"_Arcim4_"^"_Arcos4_"^"_LeafNode
			continue
		}else{
			s LeafNode=""
			s ^DHCDocEntryTree(root,findNode1,findNode2,findNode3,findNode4)=Desc4_"^"_Spec4_"^"_Arcim4_"^"_Arcos4_"^"_LeafNode
		}
		;找五级节点
		s findNode5=""
		s Node5Len=+$O(^DHCDocEntryTree(root,findNode1,findNode2,findNode3,findNode4,""),-1)
		for i=1:1:Node5Len {
			s Node5Data=$g(^DHCDocEntryTree(root,findNode1,findNode2,findNode3,findNode4,i))
			s Node5Desc=$p(Node5Data,"^",1)
			if Node5Desc=Desc5 s findNode5=i quit
		}
		if findNode5="" s findNode5=Node5Len+1
		if (Arcim5'="")||(Arcos5'="") {
			s LeafNode="leaf"
			s ^DHCDocEntryTree(root,findNode1,findNode2,findNode3,findNode4,findNode5)=Desc5_"^"_Spec5_"^"_Arcim5_"^"_Arcos5_"^"_LeafNode
			continue
		}else{
			s LeafNode=""
			s ^DHCDocEntryTree(root,findNode1,findNode2,findNode3,findNode4,findNode5)=Desc5_"^"_Spec5_"^"_Arcim5_"^"_Arcos5_"^"_LeafNode
		}
		

	}
	
	w !,"导入完成!"
	
	Q Count
getArcimIdByCode(ArcimCode)
	set ArcimRowid=""
	set ArcimCode=$$ALPHAUP^SSUTIL4(ArcimCode)
	Q:ArcimCode="" ""
	set Subscript=$O(^ARCIM(0,"Code",ArcimCode,0))
	if Subscript'="" {
		set Version=$O(^ARCIM(0,"Code",ArcimCode,Subscript,0))
		if Version'="" {
			set ArcimRowid=Subscript_"||"_Version
		}
	}
	
	;if ArcimRowid="" s ArcimRowid=ArcimCode
	Q ArcimRowid
getArcosIdByCode(ArcosCode)
	set ArcosRowid=""
	set ArcosCode=$$ALPHAUP^SSUTIL4(ArcosCode)
	Q:ArcosCode="" ""
	set ArcosRowid=$O( ^ARCOS(0,"Code",ArcosCode,0))
	
	;if ArcosRowid="" s ArcosRowid=ArcosCode
	Q ArcosRowid
}

}
