/// Creator:高姗姗
/// CreatDate:2019-09-29
/// Description：结构化诊断相关取频次类
/// Table：User.BDPDataFrequency
Class web.DHCBL.MKB.SDSDataFrequency Extends %RegisteredObject
{

/// Creator：高姗姗
/// CreatDate: 2018-08-23
/// Description：属性列表检索条件为空时取频次表
/// Table：User.BDPDataFrequency
/// Input：proTemplId属性诊断模板的id;indexTemplate点击的诊断展示名中的诊断属性位置索引
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.SDSDataFrequency","GetStructProDetail","18156","18156","")
Query GetStructProDetail(proTemplId As %String, indexTemplate As %String, desc As %String, SearchMode As %String = "") As %Query(ROWSPEC = "id,text,note")
{
}

ClassMethod GetStructProDetailExecute(ByRef qHandle As %Binary, proTemplId As %String, indexTemplate As %String, desc As %String, SearchMode As %String = "") As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 if (indexTemplate'=""){
	k ^TMPSDSDATAFREQ("SDSDataFrequency")
 	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
 	//取相关科室属性频次
 	if $d(%session) s LocID = $Get(%session.Data("LOGON.CTLOCID"))
 	//s LocID = 95
	s BDPDAFFrequency=""
	for
	{
		s BDPDAFFrequency=$o(^User.BDPDataFrequencyI("TableLocFreqIdx"," USER.SDSSTRUCTDIAGNOSPRODETAIL"_proTemplId,LocID,BDPDAFFrequency),-1) q:BDPDAFFrequency="" 
		s RowId=""
		for
		{
			s RowId=$o(^User.BDPDataFrequencyI("TableLocFreqIdx"," USER.SDSSTRUCTDIAGNOSPRODETAIL"_proTemplId,LocID,BDPDAFFrequency,RowId)) q:RowId="" 
			s text=$listget($g(^User.BDPDataFrequencyD(RowId)),4)        /// 对应表数据描述 节点 4
			s id=$listget($g(^User.BDPDataFrequencyD(RowId)),3)          /// 对应表数据ID 节点 3  BDPDAFDataReference 
			s ^TMPSDSDATAFREQ("SDSDataFrequency",id,text)=""
			
			s trids=$p(id,"#",1)
			s MKBRowId=$p(id,"#",2)
			continue:(MKBRowId="")
			s DKBBCRowId=$p(trids,"_",1)
			s childId=$p(trids,"_",2)
			s showType=$p(trids,"_",3)
			s childType=$p(trids,"_",4)
			s treeNode=$p(trids,"_",5)
			s isTOrP=$p(trids,"_",6)
			/*if (showType="T"){
				if ((childType="T")&(##class(web.DHCBL.MKB.MKBTermProDetail).GetDesc(treeNode)'="其他文本描述")){
					s myRowID=$p(id,"#",2)
					if (myRowID'=""){
						s note=$LISTGET($G(^User.MKBTermProDetailD(myRowID)),7) //树形
					}
				}
				if (childType="S"){
					s definedNode=$p(id,"#",2)
					s note=$LISTGET($G(^User.MKBTermD(definedNode)),7)  //引用树形术语
				}	
			}else{
				s note=""	
			}*/
			
			s PYDesc="",AlisaDesc="",note=""
			if (childType="L"){
				if (isTOrP="P"){
					s PYDesc=$LISTGET($G(^User.MKBTermProDetailD(MKBRowId)),10)  //检索码
					s PYDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(PYDesc)
					s AlisaDesc=##class(web.DHCBL.MKB.MKBTermProDetail).GetExtendVal(MKBRowId,childId,"别名")   //别名
					s note=$LISTGET($G(^User.MKBTermProDetailD(MKBRowId)),7) //说明
					s note= ##class(web.DHCBL.BDP.FunLib).EvalJSONB(note)
				}else{ //术语标识
					s PYDesc=$listGet($g(^User.MKBTermD(MKBRowId)),6)  //检索码
					s PYDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(PYDesc) 
				}
			}
			if (childType="T"){
				if (isTOrP="P"){
					s PYDesc=$LISTGET($G(^User.MKBTermProDetailD(MKBRowId)),10)  //检索码
					s PYDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(PYDesc)
					s AlisaDesc=##class(web.DHCBL.MKB.MKBTermProDetail).GetExtendVal(MKBRowId,childId,"别名")   //别名
					s note=$LISTGET($G(^User.MKBTermProDetailD(MKBRowId)),7)
				}else{ //术语标识
					s PYDesc=$listGet($g(^User.MKBTermD(MKBRowId)),6)  //检索码
					s PYDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(PYDesc)
					s AlisaDesc=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(MKBRowId)  //常用名别名及拼音码
					s note=$LISTGET($G(^User.MKBTermD(MKBRowId)),7)   ///备注
					s note = ##class(web.DHCBL.BDP.FunLib).EvalJSONB(note)
				}
			}
			if ((childType="TX")||(childType="TA")||(childType="R")||(childType="CB")||(childType="C")){
				//var TXRetStr = tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetTextInfo",childId); 
			}
			if (childType="S"){
				if ((showType="C")||(showType="CB")||(showType="CG")||(showType="G")) { //引用术语 展示为下拉框
					s PYDesc=$listGet($g(^User.MKBTermD(MKBRowId)),6)  //已选术语拼音码
				}
				elseif (showType="T"){
					s PYDesc=$LISTGET($G(^User.MKBTermD(MKBRowId)),6)   //检索码
					s note=$LISTGET($G(^User.MKBTermD(MKBRowId)),7)  //备注
				}
				else{
					//var SRetStr = tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetDocSourseDetailInfo",childId); 
				}
			}
			if (childType="P"){}
			if (childType="SS"){
				s PYDesc=$listGet($g(^User.MKBTermD(MKBRowId)),6)  //检索码
				s PYDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(PYDesc)
				s AlisaDesc=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(MKBRowId)  //常用名别名及拼音码
				s note=$LISTGET($G(^User.MKBTermD(MKBRowId)),7)   ///备注
				s note = ##class(web.DHCBL.BDP.FunLib).EvalJSONB(note)
			}
			
			if (((indexTemplate'["_")&(DKBBCRowId=indexTemplate))||((indexTemplate["_")&(trids=indexTemplate))){
				if (SearchMode = ""){ //模糊检索
					if (($ZCONVERT(text,"U")[desc)||(desc="")||($ZCONVERT(PYDesc,"U")[desc)||($ZCONVERT(AlisaDesc,"U")[desc)){
						d OutputRowDetail
					}
				}
				if (SearchMode = "A"){ //全匹配检索
					if (($ZCONVERT(text,"U")=desc)||(desc="")||($ZCONVERT(PYDesc,"U")=desc)||($ZCONVERT(AlisaDesc,"U")=desc)){
						d OutputRowDetail
					}
				}
			}
		}
	}
	
	//取demo预导入属性频次
	s USERID=$o(^SSU("SSUSR",0,"SSUSR_Initials","DEMO",0)) //demo id
	s CTLOCID=$p($g(^SSU("SSUSR",USERID)),"^",4) //demo 默认登录科室id
	s BDPDAFFrequency=""
	for
	{
		s BDPDAFFrequency=$o(^User.BDPDataFrequencyI("TableLocFreqIdx"," USER.SDSSTRUCTDIAGNOSPRODETAIL"_proTemplId,CTLOCID,BDPDAFFrequency),-1) q:BDPDAFFrequency="" 
		s RowId=""
		for
		{
			s RowId=$o(^User.BDPDataFrequencyI("TableLocFreqIdx"," USER.SDSSTRUCTDIAGNOSPRODETAIL"_proTemplId,CTLOCID,BDPDAFFrequency,RowId)) q:RowId="" 
			s text=$listget($g(^User.BDPDataFrequencyD(RowId)),4)        /// 对应表数据描述 节点 4
			s id=$listget($g(^User.BDPDataFrequencyD(RowId)),3)          /// 对应表数据ID 节点 3  BDPDAFDataReference 
			//过滤当前登录科室已存在的属性频次
			continue:$d(^TMPSDSDATAFREQ("SDSDataFrequency",id,text)) 
			
			s trids=$p(id,"#",1)
			s MKBRowId=$p(id,"#",2)
			continue:(MKBRowId="")
			s DKBBCRowId=$p(trids,"_",1)
			s childId=$p(trids,"_",2)
			s showType=$p(trids,"_",3)
			s childType=$p(trids,"_",4)
			s treeNode=$p(trids,"_",5)
			s isTOrP=$p(trids,"_",6)
			
			s PYDesc="",AlisaDesc="",note=""
			if (childType="L"){
				if (isTOrP="P"){
					s PYDesc=$LISTGET($G(^User.MKBTermProDetailD(MKBRowId)),10)  //检索码
					s PYDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(PYDesc)
					s AlisaDesc=##class(web.DHCBL.MKB.MKBTermProDetail).GetExtendVal(MKBRowId,childId,"别名")   //别名
					s note=$LISTGET($G(^User.MKBTermProDetailD(MKBRowId)),7) //说明
					s note= ##class(web.DHCBL.BDP.FunLib).EvalJSONB(note)
				}else{ //术语标识
					s PYDesc=$listGet($g(^User.MKBTermD(MKBRowId)),6)  //检索码
					s PYDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(PYDesc) 
				}
			}
			if (childType="T"){
				if (isTOrP="P"){
					s PYDesc=$LISTGET($G(^User.MKBTermProDetailD(MKBRowId)),10)  //检索码
					s PYDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(PYDesc)
					s AlisaDesc=##class(web.DHCBL.MKB.MKBTermProDetail).GetExtendVal(MKBRowId,childId,"别名")   //别名
					s note=$LISTGET($G(^User.MKBTermProDetailD(MKBRowId)),7)
				}else{ //术语标识
					s PYDesc=$listGet($g(^User.MKBTermD(MKBRowId)),6)  //检索码
					s PYDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(PYDesc)
					s AlisaDesc=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(MKBRowId)  //常用名别名及拼音码
					s note=$LISTGET($G(^User.MKBTermD(MKBRowId)),7)   ///备注
					s note = ##class(web.DHCBL.BDP.FunLib).EvalJSONB(note)
				}
			}
			if ((childType="TX")||(childType="TA")||(childType="R")||(childType="CB")||(childType="C")){
				//var TXRetStr = tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetTextInfo",childId); 
			}
			if (childType="S"){
				if ((showType="C")||(showType="CB")||(showType="CG")||(showType="G")) { //引用术语 展示为下拉框
					s PYDesc=$listGet($g(^User.MKBTermD(MKBRowId)),6)  //已选术语拼音码
				}
				elseif (showType="T"){
					s PYDesc=$LISTGET($G(^User.MKBTermD(MKBRowId)),6)   //检索码
					s note=$LISTGET($G(^User.MKBTermD(MKBRowId)),7)  //备注
				}
				else{
					//var SRetStr = tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetDocSourseDetailInfo",childId); 
				}
			}
			if (childType="P"){}
			if (childType="SS"){
				s PYDesc=$listGet($g(^User.MKBTermD(MKBRowId)),6)  //检索码
				s PYDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(PYDesc)
				s AlisaDesc=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(MKBRowId)  //常用名别名及拼音码
				s note=$LISTGET($G(^User.MKBTermD(MKBRowId)),7)   ///备注
				s note = ##class(web.DHCBL.BDP.FunLib).EvalJSONB(note)
			}
			
			if (((indexTemplate'["_")&(DKBBCRowId=indexTemplate))||((indexTemplate["_")&(trids=indexTemplate))){
				if (SearchMode = ""){ //模糊检索
					if (($ZCONVERT(text,"U")[desc)||(desc="")||($ZCONVERT(PYDesc,"U")[desc)||($ZCONVERT(AlisaDesc,"U")[desc)){
						d OutputRowDetail
					}
				}
				if (SearchMode = "A"){ //全匹配检索
					if (($ZCONVERT(text,"U")=desc)||(desc="")||($ZCONVERT(PYDesc,"U")=desc)||($ZCONVERT(AlisaDesc,"U")=desc)){
						d OutputRowDetail
					}
				}
			}
		}
	}
 }
      
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowDetail
    set Data=$lb(id,text,note)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetStructProDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetStructProDetailExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetStructProDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetStructProDetailExecute ]
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
