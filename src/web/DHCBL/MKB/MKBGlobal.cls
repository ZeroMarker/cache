Class web.DHCBL.MKB.MKBGlobal Extends %RegisteredObject
{

/// Creator:谢海睿
/// CreatDate: 2020-7-7
/// Description:根据全局化词表ID获取引用场景的描述(只查临床实用诊断的)
/// Table：User.MKBGLobal
/// Input：GlobalRowId
/// w ##class(web.DHCBL.MKB.MKBGlobal).SearchReferenceListDesc("8090")
ClassMethod SearchReferenceListDesc(GlobalRowId As %String) As %String
{
	s RefRowId=0
	for
	{
		s RefRowId=$o(^User.MKBGlobalReferenceI("InverAllIndex",GlobalRowId,"T",RefRowId))    //通过索引表获得引用者的ID
		q:RefRowId=""
		s MKBGRRowId=$o(^User.MKBGlobalReferenceI("InverAllIndex",GlobalRowId,"T",RefRowId,0))  //引用表ID
		s MKBGRCode=$lg($g(^User.MKBTermD(RefRowId)),2)
		s MKBGRDesc=$lg($g(^User.MKBTermD(RefRowId)),3)
		s MKBGRType="术语"
		s BaseRowId=$lg($g(^User.MKBTermD(RefRowId)),4)
		s BaseDesc=$lg($g(^User.MKBTermBaseD(BaseRowId)),3)
		
		s MKBGRLevel=BaseDesc_"."_MKBGRDesc
		s MKBGRPYCode=$lg($g(^User.MKBTermD(RefRowId)),6)
		s MKBGRNote=$lg($g(^User.MKBTermD(RefRowId)),7)
		s LastLevel=$lg($g(^User.MKBTermD(RefRowId)),5)
		s MKBGRLastLevel=""
		while (LastLevel'="")
		{
			if (MKBGRLastLevel="")
			{
				s MKBGRLastLevel=$lg($g(^User.MKBTermD(LastLevel)),3)
			}
			else
			{
				s MKBGRLastLevel=$lg($g(^User.MKBTermD(LastLevel)),3)_"--"_MKBGRLastLevel
			}
			s LastLevel=$lg($g(^User.MKBTermD(LastLevel)),5)
			
		}  
		
		return MKBGRDesc
	}
}

/// Creator:谢海睿
/// CreatDate: 2020-7-7
/// Description:获全局化词表ID
/// Table：User.MKBGLobal
/// Input：desc
/// w ##class(web.DHCBL.MKB.MKBGlobal).SearchGlobalID("多发骨髓瘤")
ClassMethod SearchGlobalID(desc As %String) As %String
{
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s GlobalID=""
	s GlobalName=""	
    s MKBGFreq = " "
    s MKBGRowId=""
    s result="^"
    
    s endflag=0
    s MKBGloMark=""
    for
    {
	    s MKBGloMark = $o(^User.MKBGlobalI("MKBGMarkIndex",MKBGloMark))
	    q:MKBGloMark=""
	    s ID = 0
	    for
	    {
		    s ID = $o(^User.MKBGlobalI("MKBGMarkIndex",MKBGloMark,ID))
		    q:ID=""
		    s MKBGDesc=$lg($g(^User.MKBGlobalD(ID)),3)
		    s MKBGState=$lg($g(^User.MKBGlobalD(ID)),8)
		    s AliasId=0
			if (MKBGState'="U")
			{
				continue
			}
			for
			{
				s AliasId=$o(^User.MKBGlobalD(ID,"ChildGloAlias",AliasId))  //遍历别名表
				q:AliasId=""
				s AliasMark = $lg($g(^User.MKBGlobalD(ID,"ChildGloAlias",AliasId)),8)
				s MKBGADesc = $lg($g(^User.MKBGlobalD(ID,"ChildGloAlias",AliasId)),2) 
				if (($ZCONVERT(desc,"U")=MKBGADesc))
				{
					s MKBGRDesc=""
					s InitiativeID=0
					for
					{
						s InitiativeID=$o(^User.MKBGlobalReferenceI("InverAllIndex",ID,"T",InitiativeID))    //通过索引表获得引用者的ID
						q:InitiativeID=""
						s MKBGRDesc=$lg($g(^User.MKBTermD(InitiativeID)),3)
						//continue:(MKBGRDesc'=$ZCONVERT(desc,"U"))	//过滤引用和描述不一致的
						//s MKBGRRowId=$o(^User.MKBGlobalReferenceI("InverAllIndex",ID,"T",InitiativeID,0))  //引用表ID
						s MKBTActiveFlag=$listGet($g(^User.MKBTermD(InitiativeID)),9)
						continue:(MKBTActiveFlag="N")	//过滤封闭
						s MKBGRDesc=$lg($g(^User.MKBTermD(InitiativeID)),3)
						s result=ID_"^"_MKBGRDesc
						s endflag=1
						q:endflag=1 
					}
					//s GlobalID=ID
					//s GlobalName=MKBGRDesc
				}
				q:endflag=1
				
			}
			q:endflag=1
	    }
	    q:endflag=1
    }
    q result
    /*
    s MKBGADesc=""
    for
    {
	    s MKBGFreq = $o(^User.MKBGlobalI("MKBGFreqIndex",MKBGFreq),-1)
	    q:MKBGFreq=""
	    s ID = 0
	    for
	    {
		    s ID = $o(^User.MKBGlobalI("MKBGFreqIndex",MKBGFreq,ID))
		    q:ID=""
		    s MKBGRowId=ID
			s MKBGCode=$lg($g(^User.MKBGlobalD(MKBGRowId)),2)
			s MKBGDesc=$lg($g(^User.MKBGlobalD(MKBGRowId)),3)
			s MKBGLastLevel=$lg($g(^User.MKBGlobalD(ID)),7)
			s MKBGState=$lg($g(^User.MKBGlobalD(ID)),8)
			s MKBGConfirm=$lg($g(^User.MKBGlobalD(ID)),9)
			s MKBGloMark =$lg($g(^User.MKBGlobalD(MKBGRowId)),10)
			s MKBGDiaTotalFreq = $lg($g(^User.MKBGlobalD(ID)),11)
			s MKBGAlias=""
			s MKBGDisplaName=""
			s AliasId=0
			if (MKBGState'="U")
			{
				continue
			}
			for
			{
				s AliasId=$o(^User.MKBGlobalD(ID,"ChildGloAlias",AliasId))  //遍历别名表
				q:AliasId=""
				s AliasMark = $lg($g(^User.MKBGlobalD(MKBGRowId,"ChildGloAlias",AliasId)),8)
				s MKBGADesc = $lg($g(^User.MKBGlobalD(MKBGRowId,"ChildGloAlias",AliasId)),2) 
				if (($ZCONVERT(desc,"U")=MKBGADesc))
				{
					//return MKBGRowId
					s GlobalID=MKBGRowId
				}
				
			    if (AliasMark["查询名")
			    {
				    if (($ZCONVERT(desc,"U")=MKBGADesc))
					{
						//return MKBGRowId
						s GlobalID=MKBGRowId
					}
			    }
			    if (AliasMark["展示名")
			    {
				    s MKBGDisplaName=$lg($g(^User.MKBGlobalD(ID,"ChildGloAlias",AliasId)),2)   //展示名
				  
			    }
			    if ((MKBGADesc=MKBGDisplaName)&(MKBGDisplaName'=""))
			    {
				    s MKBGloMark=AliasMark
			    }
			    elseif (MKBGADesc=MKBGDesc)
			    {
				    s MKBGloMark=AliasMark
			    }
			    
			 					
			}
			
			s:MKBGDisplaName="" MKBGDisplaName=$lg($g(^User.MKBGlobalD(MKBGRowId)),3)
			if (($ZCONVERT(desc,"U")=MKBGDisplaName))
			{
				//return MKBGRowId
				s GlobalID=MKBGRowId
			}
			
			
		}
		
	}
	*/
	//q GlobalID_"^"_GlobalName
	//q GlobalID
}

/// Creator:谢海睿
/// CreatDate: 2020-7-2
/// Description：分词接口
/// Table：User.MKBGLobal
/// Input：desc
/// w ##class(web.DHCBL.MKB.MKBGlobal).GetStructedDataAPI("高血压3级(很高危)")
ClassMethod GetStructedDataAPI(content As %String) As %String
{
    
    set httpRequest = ##class(%Net.HttpRequest).%New()
    //s Url="http://111.205.6.207:1223/dn"
 	s Url="http://111.205.6.207:1242/test"
    Do httpRequest.SetHeader("Content-Type","application/x-www-form-urlencoded; charset=utf8")
    do httpRequest.InsertFormData("query", content)
    set status = httpRequest.Post(Url)
    If $$$ISERR(status) { Quit $system.OBJ.DisplayError(status) }
    s stream=##class(%Stream.GlobalCharacter).%New()
    s stream= httpRequest.HttpResponse.Data
    Set responseString =""
    while 'stream.AtEnd
    {
	    s responseString=responseString_stream.ReadLine()
	}
	s responseString=##class(web.DHCBL.BDP.FunLib).TransLinefeed(responseString,"")
	s data=[].%FromJSON(responseString)

	s json=""
	s total=0
	k ^TempSort
	set iter = data.%Get("分词结果").%GetIterator()
	while iter.%GetNext(.key, .value)
	{
		if (key="诊断")
		{
			for m1=0:1:value.%Size()
			{
				s DiagnosisPice=value.%Get(m1)
				
				continue:DiagnosisPice=""
				s structstr=..GetStructValueByDesc(DiagnosisPice)
				s structdata=$p(structstr,"#",1)
				s sortseq=0
				if ($p(structdata,"-",2)="")
				{
					s Type="临床实用诊断"
					s sortseq=0
				}
				else
				{
					s Type="常用诊断表达式"
					s sortseq=1
				}
				s total=total+1
				s ^TempSort(sortseq,total)=DiagnosisPice_"#@"_Type_"#@"_structdata
				
			}
		
		}
		else
		{
			for m1=0:1:value.%Size()
			{
				s Pice=value.%Get(m1)
				continue:Pice=""
				s structdata=""
				s total=total+1
				s sortseq=$case(key,"病因":"2","部位":"3","描述":"4",:"5")
				s ^TempSort(sortseq,total)=Pice_"#@"_key_"#@"_structdata
			}
		}
	}
	s seq=""
	for
	{
		s seq=$o(^TempSort(seq))
		q:seq=""
		s number=""
		for
		{
			s number=$o(^TempSort(seq,number))
			q:number=""
			s Desc=$p(^TempSort(seq,number),"#@",1)
			s Type=$p(^TempSort(seq,number),"#@",2)
			s structdata=$p(^TempSort(seq,number),"#@",3)
			s thisStr="{""Desc"":"""_Desc_""",""Type"":"""_Type_""",""Structdata"":"""_structdata_"""}"
			if (json="")
			{
				s json=thisStr
			}
			else
			{
				s json=json_","_thisStr
			}	
		}
	}
	s json="{""rows"":["_json_"], ""total"":"_total_"}"

    Quit json
}

/// 入参termid 返回其祖先节点的id
/// w ##class(web.DHCBL.MKB.MKBGlobal).GetFatherID("754143")
ClassMethod GetFatherID(id As %String)
{
	s MKBTLastLevel=id
	s FatherID = ""
	s num=0
	for
	{
		s MKBTLastLevel = $lg($g(^User.MKBTermD(MKBTLastLevel)),5)
		if (num=0)&&(MKBTLastLevel="")
		{
			s FatherID=id
		}
		q:MKBTLastLevel=""
		s num=num+1
		s FatherID=MKBTLastLevel
	}
	q FatherID
}

/// 获得祖先节点的json拼
/// w ##class(web.DHCBL.MKB.MKBGlobal).GetFatherJsonStr("754139")
ClassMethod GetFatherJsonStr(id As %String)
{
	s myRowID = id
	s MKBTDesc=$LISTGET($G(^User.MKBTermD(myRowID)),3)   ///中心词
	s MKBTDesc=$Replace(MKBTDesc,"""","")
	s MKBTDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTDesc)
	s MKBTCode=$LISTGET($G(^User.MKBTermD(myRowID)),2) ///代码
	s MKBTLastLevel=$LISTGET($G(^User.MKBTermD(myRowID)),5)   ///上级分类
	s:MKBTLastLevel'="" MKBTLastLevel=$LISTGET($G(^User.MKBTermD(MKBTLastLevel)),3)
	s MKBTPYCode=$LISTGET($G(^User.MKBTermD(myRowID)),6)
	s MKBTSequence=$LISTGET($G(^User.MKBTermD(myRowID)),8)   ///顺序
	s MKBTNote=$LISTGET($G(^User.MKBTermD(myRowID)),7)   ///顺序
	s MKBTNote = ##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTNote)
	w "[{""id"":"""_myRowID_""",""MKBTRowId"":"""_myRowID_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTCode"":"""_MKBTCode_""",""MKBTLastLevel"":"""_MKBTLastLevel_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTSequence"":"""_MKBTSequence_""",""MKBTNote"":"""_MKBTNote_""",""state"":""open"",""children"":"
	s CStr = $lg(##class(web.DHCBL.MKB.MKBAssInterface).GetTreeJson("79",id))
	//w CStr
	//FStr ="[{""id"":"_myRowID_",""MKBTRowId"":"_myRowID_",""MKBTDesc"":"_MKBTDesc_",""MKBTCode"":"_MKBTCode_",""MKBTLastLevel"":"_MKBTLastLevel_",""MKBTPYCode"":"_MKBTPYCode_",""MKBTSequence"":"_MKBTSequence_",""MKBTNote"":"_MKBTNote_",""state"":""open"",""children"":"_CStr_"}]"
	w "}]"
	q ""
}

/// 全局化词表查询用全文检索
/// Creator:范文凯
/// CreatDate:2019-12-30
/// Description:
/// Input：
/// Other:
ClassMethod SearchList(desc)
{
	s desc=$ZCONVERT(desc,"U")                  //转换成大写
	if (desc[",")||(desc["，")                 //逗号代表and
	{
		
	}
	if (desc[" ")                              //空格代表or
	{
		
	}
	else
	{
		s TermStr = 0
		for
		{
			s TermStr = $o(^User.BDPMKBIndexI("DescIndex"," "_desc,TermStr))
			q:TermStr=""
		}
	}
}

/// 在辅助功能区实现跳转界面提供参数
/// Creator:范文凯
/// CreatDate:2019-12-06
/// Description:入参MKBGRowid 
/// Input：BDPMenu TermID ProID
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).ReturnSkipParm("1")
ClassMethod ReturnSkipParm(MKBGRRowid As %String)
{
	s BDPMenu=""
	s TermID = ""
	s ProID =""
	s DataType = $lg($g(^User.MKBGlobalReferenceD(MKBGRRowid)),2)
	s DataId  = $lg($g(^User.MKBGlobalReferenceD(MKBGRRowid)),3)
	if (DataType = "T")
	{
		s TermBaseid = $lg($g(^User.MKBTermD(DataId)),4)
		s TermBaseDesc = $lg($g(^User.MKBTermBaseD(TermBaseid)),3)    //获得Desc
		s MenuID=""
		for
		{
			s MenuID = $o(^User.BDPMenuD(MenuID))
			q:MenuID=""
			s myActiveFlag = $LISTGET($g(^User.BDPMenuD(MenuID)),16)
			s IsMKBMenu=$LISTGET($g(^User.BDPMenuD(MenuID)),21)     //是否属于医学知识库
			continue:(IsMKBMenu'="Y")||($p(myActiveFlag,"^",1)'="1")   //过滤一些不符合要求的菜单
			s MenuDesc = $LISTGET($g(^User.BDPMenuD(MenuID)),3)
			if (MenuDesc=TermBaseDesc)
			{
				s BDPMenu = MenuID
			}
		}	
	}
	q BDPMenu_"^"_DataId_"^"_ProID
}

/// Creator:范文凯
/// CreatDate:2019-11-13
/// Description:入参为选中的界面id  方法用途，补全childStr字符串
/// Input：MKB_Global表的id 
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).EditChildIdStr("16385","16389,16390,525847")
ClassMethod EditChildIdStr(FatherId As %String, ChildIdStr As %String)
{
	s result =""
	s ChildLength = $l(ChildIdStr,",")
	for i=1:1:ChildLength
	{
		s ChildId = $p(ChildIdStr,",",i)
		s eobj = ##class(User.MKBTerm).%OpenId(ChildId)
	 	s DataFaterID = eobj.MKBTLastLevel.%Id()
	 	//b
	 	if (DataFaterID = FatherId)
	 	{
		 	s result = result_ChildId_","
		}
		else
		{
			s ID =..GetChildStr(FatherId,DataFaterID)
			if result[ID
			{
				s result=result_ChildId_","
			}
			else
			{
				s result=result_ID_","_ChildId_","
			}
		}
	}
	s result=$e(result,0,*-1)
	q result
}

/// 判断childid的父节点是否是FatherId
ClassMethod GetChildStr(FatherId As %String, ChildId As %String)
{
	s eobj = ##class(User.MKBTerm).%OpenId(ChildId)
	s DataFaterID = eobj.MKBTLastLevel.%Id()
	if (DataFaterID = FatherId)                //父节点为FatherId  返回该节点
	{
		q ChildId                          
	}
	else                                       //父节点不是FatherID  则重新调用改方法
	{
		//
	}
}

/// Creator:范文凯
/// CreatDate:2019-11-13
/// Description:主要部位子元素部分引用
/// Input：MKB_Global表的id 
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).ChildSaveData("752047","16387,16389,16390,525847")
ClassMethod ChildSaveData(FatherId As %String, ChildIdStr As %String)
{
	 s NewID = ""              //初始化变量
	 s ChildLength = $l(ChildIdStr,",")
	 for i=1:1:ChildLength
	 {
		s ChildId = $p(ChildIdStr,",",i)
		s eobj = ##class(User.MKBTerm).%OpenId(ChildId)
	 	s DataFaterID = eobj.MKBTLastLevel.%Id()
	 	if (DataFaterID = 16385)
	 	{
		 	s NewID=..SaveTermAndGloR(FatherId,ChildId)       //执行SaveData()  返回值为 刚刚SaveData产生新对象的id
	 	}
	 	else
	 	{
		 	//如果他的上级节点不是FatherID， 说明他不是FatherID 的直接子节点， 那么他的父节点应该为ChildStr的上一位所新增对象的ID，即全局变量NewID
		 	d ..SaveTermAndGloR(NewID,ChildId)
		 	/*s ID = $p(ChildIdStr,",",i-1)
		 	s InitiativeID = $o(^User.MKBGlobalReferenceI("AllIndex","T",ID,""),-1)
		 	d ..SaveTermAndGloR(InitiativeID,ChildId)	*/
		}
	 }
	 q "yes"
	 /*s ChildLength = $l(ChildIdStr,",")
	 for i=1:1:ChildLength
	 {
	 	s ChildId = $p(ChildIdStr,",",i)
	 	s eobj = ##class(User.MKBTerm).%OpenId(ChildId)
	 	s DataFaterID = eobj.MKBTLastLevel.%Id()
	 	if (DataFaterID = FatherId)
	 	{
		 	d ..SaveTermAndGloR(FatherId,ChildId)       //执行SaveData()   引用的子元素为直接子元素
	 	}
	 	else
	 	{
		 	s ^TmpFatherChild(DataFaterID)=""              //获得该节点的FatherID 的所有节点， 并添加这些节点
		}
		d eobj.%Close()
	 }
	 
	 s num = 0
	 for
	 {
		 s num = $o(^TmpFatherChild(num))
		 q:num=""
		 s eobj = ##class(User.MKBTerm).%OpenId(num)
		 s DataFaterID = eobj.MKBTLastLevel.%Id()
		 if (DataFaterID = FatherId)
	 	 {
		 	d ..SaveTermAndGloR(FatherId,num) 
		 	//执行SaveData 并把符合条件的ChildData也可执行
	 	 }
	 	 else
	 	 {
		 	 
		 }
     }
	 
	 //s FatherDesc = $lg($g(^User.MKBTermD(DataFaterID)),3)             //获得上级节点的描述
	 
	 //s obj = ##class(web.Entity.MKB.MKBTerm).%New()*/
}

/// 调用term的SaveData 以及 RefernenceCode 方法
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).SaveTermAndGloR("752047","525847")
ClassMethod SaveTermAndGloR(FatherId As %String, ChildId As %String)
{
	s res=""
	//s MKBGloblDesc =""
	s obj= ##class(web.Entity.MKB.MKBTerm).%New()
	s nobj = ##class(User.MKBTerm).%OpenId(ChildId)
	s obj.MKBTDesc = nobj.MKBTDesc
	//s MKBGloblDesc = obj.MKBTDesc                 //用他来获得Global的ID
	//s obj.MKBTCode ="PART01209"
	//d obj.MKBTBaseDRSetObjectId(nobj.MKBTBaseDR)
	//d obj.MKBTBaseDRSetObjectId(nobj.MKBTBaseDR.%Id())
	s obj.MKBTBaseDR="6"
	s obj.MKBTPYCode= nobj.MKBTPYCode
	s obj.MKBTNote = ##class(web.DHCBL.BDP.FunLib).EvalJSONB(nobj.MKBTNote)
	s obj.MKBTLastLevel = FatherId
	s rs=##class(web.DHCBL.MKB.MKBTerm).SaveData(obj)   //这个时候需要拿到保存成功之后的id
	s NewID = $e(rs,21,*-11)                             //获得刚刚新增元素的id   此id要用来保存到全局化引用表
	if (NewID="orinfo")
	{
		b
	}
	if rs["success"
	s res ="success"
	d obj.%Close()
	d nobj.%Close()
	s PassiveID = $o(^User.MKBGlobalReferenceI("AllIndex","T",ChildId,0))
	d ..ReferenceCode("",NewID,PassiveID,"T")                 //这个FatherId 有错
	q NewID
}

/// Creator:范文凯
/// CreatDate:2019-11-12
/// Description:判断该元素是否还有子元素
/// Input：MKB_Global表的id 
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).ReturnChild("125")
ClassMethod ReturnChild(termid As %String)
{
}

/// Creator:范文凯
/// CreatDate:2019-11-05
/// Description:为跳转按钮提供方法
/// Input：MKB_Global表的id 
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).Returntermid("125")
ClassMethod Returntermid(referenceid As %String)
{
	s termid = $lg($g(^User.MKBGlobalReferenceD(referenceid)),3)
	q termid
}

/// Creator:范文凯
/// CreatDate:2019-11-04
/// Description:入参为全局化词表的id 返回为可编辑的字段内容
/// Input：中心词
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBGlobal","GetEditList","1")
Query GetEditList(Id As %String) As %Query(ROWSPEC = "MKBGPDesc,MKBGPDDesc,MKBGPType")
{
}

ClassMethod GetEditListExecute(ByRef qHandle As %Binary, Id As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	// 在全局化词表中查找
 	/*s MKBGPDesc = "中心词"
    s MKBGPDDesc = $lg($g(^User.MKBGlobalD(Id)),3)
    s MKBGPType = "TX"
    d OutputRow8
    s MKBGPDesc = "英文名"
    s MKBGPDDesc = $lg($g(^User.MKBGlobalD(Id)),4)
    s MKBGPType = "TX"
    d OutputRow8
    s MKBGPDesc = "检索码"
    s MKBGPDDesc = $lg($g(^User.MKBGlobalD(Id)),6)
    s MKBGPType = "TX"
    d OutputRow8
    s MKBGPDesc = "标记"
    s MKBGPDDesc = $lg($g(^User.MKBGlobalD(Id)),10)
    s MKBGPType = "T"
    d OutputRow8 */
    s MKBGPDesc = "名称列表"
    s MKBGPDDesc=""
    s MKBGPType = "L"
    /*s tmpid=0
    for
    {
	    s tmpid = $o(^User.MKBGloAliasI("SeqIndex",Id,tmpid))
	    q:tmpid=""
	    s tmpdesc = $o(^User.MKBGloAliasI("SeqIndex",Id,tmpid,0))
	    s tmpdesc = $Zstrip(tmpdesc,"<>W")   
	    s MKBGPDDesc=MKBGPDDesc_tmpdesc_","
	}
	s MKBGPDDesc = $e(MKBGPDDesc,0,*-1)*/
	s MKBGMark =$lg($g(^User.MKBGlobalD(Id)),10)
	d OutputRow8 
	s MKBGPDesc = "备注"
    s MKBGPDDesc = $lg($g(^User.MKBGlobalD(Id)),5)
    s MKBGPType = "TA"
    d OutputRow8 
	if (MKBGMark["诊断")
	{
		s MKBGPDesc = "开立频次"
        s MKBGPDDesc=$lg($g(^User.MKBGlobalD(Id)),11)
        s MKBGPType = "Loc"
        d OutputRow8 
	}
	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(MKBGPDesc,MKBGPDDesc,MKBGPType)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetEditListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCTPMExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetEditListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEditListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:范文凯
/// CreatDate:2019-10-08
/// Description:取中心词，去MKBGlobal表中 查找 是否存在该中心词的数据
/// Input：中心词
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBGlobal","GetMKBGlobal","冠心病")
Query GetMKBGlobal(Desc As %String) As %Query(ROWSPEC = "MKBGRowId, MKBGCode, MKBGDesc, MKBGEnName, MKBGNote, MKBGPYCode, MKBTLastLevel, MKBGState , MKBGSource")
{
}

ClassMethod GetMKBGlobalExecute(ByRef qHandle As %Binary, Desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	// 在全局化词表中查找
 	s MKBGRowID = 0
	for
	{
		s MKBGRowID = $o(^User.MKBGlobalI("DescIndex"," "_Desc,MKBGRowID))
		q:MKBGRowID=""
		s MKBGState = $lg($g(^User.MKBGlobalD(MKBGRowID)),8)
		continue:MKBGState'="U"
		s MKBGDesc = $lg($g(^User.MKBGlobalD(MKBGRowID)),3)
		s MKBGCode = $lg($g(^User.MKBGlobalD(MKBGRowID)),2)
		s MKBGNote = $lg($g(^User.MKBGlobalD(MKBGRowID)),5)
		s MKBGEnName = $lg($g(^User.MKBGlobalD(MKBGRowID)),4)
		s MKBGPYCode = $lg($g(^User.MKBGlobalD(MKBGRowID)),6)
		s MKBTLastLevel = $lg($g(^User.MKBGlobalD(MKBGRowID)),7)
		s MKBGRowId = MKBGRowID
		s MKBGSource = ..ReturnMKBGSource(MKBGRowId)
		
		d OutputRow8
		
	}
	
	// 在全局化别名表里查找
	s MKBGARowId=0
	for
	{
		s MKBGARowId = $o(^User.MKBGloAliasI("DescIndex"," "_Desc,MKBGARowId))
		q:MKBGARowId=""
		s MKBGState = $lg($g(^User.MKBGlobalD(MKBGARowId)),8)
		continue:MKBGState'="U"
		s MKBGDesc = $lg($g(^User.MKBGlobalD(MKBGARowId)),3)
		s MKBGCode = $lg($g(^User.MKBGlobalD(MKBGARowId)),2)
		s MKBGNote = $lg($g(^User.MKBGlobalD(MKBGARowId)),5)
		s MKBGEnName = $lg($g(^User.MKBGlobalD(MKBGARowId)),4)
		s MKBGPYCode = $lg($g(^User.MKBGlobalD(MKBGARowId)),6)
		s MKBTLastLevel = $lg($g(^User.MKBGlobalD(MKBGARowId)),7) 
		s MKBGRowId = MKBGARowId
		s MKBGSource = ..ReturnMKBGSource(MKBGRowId)
		d OutputRow8
	}
	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(MKBGRowId, MKBGCode, MKBGDesc, MKBGEnName, MKBGNote, MKBGPYCode, MKBTLastLevel, MKBGState ,MKBGSource)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetMKBGlobalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCTPMExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMKBGlobalClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMKBGlobalExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:xiehairui
/// CreatDate:2020-6-22
/// Description:中心词，去MKBGlobal表中 查找 是否存在该中心词的数据
/// Input：中心词
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBGlobal","GetGlobalAndGloAlias","高血压性心脏病",1)
Query GetGlobalAndGloAlias(Desc As %String, globalflag) As %Query(ROWSPEC = "MKBGRowId, MKBGAliasId, MKBGADesc")
{
}

ClassMethod GetGlobalAndGloAliasExecute(ByRef qHandle As %Binary, Desc As %String, globalflag) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s:Desc'="" Desc=$ZCONVERT(Desc,"U") //转换成大写
 	// 在全局化词表中查找
 	s MKBGFreq = " "
 	s MKBGADesc=""
 	s MKBGAliasId=""
 	s MKBGRowId=""
    for
    {
	    s MKBGFreq = $o(^User.MKBGlobalI("MKBGFreqIndex",MKBGFreq),-1)
	    q:MKBGFreq=""
	    s ID = 0
	    for
	    {
		    s ID = $o(^User.MKBGlobalI("MKBGFreqIndex",MKBGFreq,ID))
		    q:ID=""
		    s MKBGRowId=ID
			s MKBGState=$lg($g(^User.MKBGlobalD(MKBGRowId)),8)
		
			continue:(MKBGState'="U")	//过滤非在使用的
		
			s MKBGDesc1=$lg($g(^User.MKBGlobalD(MKBGRowId)),3)
			if (Desc=MKBGDesc1)
			{
				s MKBGADesc=MKBGDesc1
				s MKBGAliasId = ""
			   	 d OutputRow8
					
			}
			if (globalflag'=1)
			{
				s MKBGAlias=""
				s MKBGDisplaName=""
				s AliasId=0
				for
				{
					s AliasId=$o(^User.MKBGlobalD(ID,"ChildGloAlias",AliasId))  //遍历别名表
					q:AliasId=""
					s MKBGADesc = $lg($g(^User.MKBGlobalD(MKBGRowId,"ChildGloAlias",AliasId)),2) 
				   
				    if (MKBGADesc=Desc)
				    {
					    s MKBGAliasId = MKBGRowId_"||"_AliasId
					    s MKBGADesc = MKBGDesc1_"("_MKBGADesc_")"
					    d OutputRow8
				    }
				 				
				}
			}
	    }
    }
	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(MKBGRowId, MKBGAliasId, MKBGADesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetGlobalAndGloAliasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetGlobalAndGloAliasExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetGlobalAndGloAliasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetGlobalAndGloAliasExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:范文凯
/// CreatDate:2019-10-08
/// Description:引用编码调用方法（加入到术语表或者属性表，但是编码用引用编码，同时操作全局化引用表新增数据）
/// Input：中心词
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).ReferenceCode()
ClassMethod ReferenceCode(MKBGCode As %String, TermId As %String, PassiveID As %String, Type As %String)
{
	s result = ""
	s eobj = ##class(web.Entity.MKB.MKBGlobalReference).%New()
	s eobj.MKBGRRowid = ""
	
	s eobj.InitiativeFlag=Type				//发起引用，主动引用标识
	s eobj.InitiativeID=TermId				//发起引用词的ID
	s eobj.PassiveID=PassiveID				//被引用词的ID
	s eobj.PassiveAliasID=""				//被引用词的名称列表ID
	s result= ..SaveReferenceEntity(eobj)
	if (result["true")	//保存成功
	{
		s result = "success"
	}
	else
	{
		s result = "false"
	}		
	q result
}

/// Creator:范文凯
/// CreatDate:2019-10-08
/// Description:新增编码调用方法（执行以前的保存术语或者属性方法，同时操作全局化词表新增数据）
/// Input：中心词
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).IncreaseCode(748675)
ClassMethod IncreaseCode(TermId As %String, Type As %String)
{
	s result=""
	if (Type="T")
	{
		s obj=##class(User.MKBTerm).%OpenId(TermId)
		s Desc=obj.MKBTDesc
		s sc= ..SaveGlobalLog("", obj.MKBTDesc, "", obj.MKBTNote, "U", "", "", "")
	}
	elseif (Type="D")
	{
		s obj=##class(User.MKBTermProDetail).%OpenId(TermId)
		s Desc=obj.MKBTPDDesc
		s sc= ..SaveGlobalLog("", obj.MKBTPDDesc, "", obj.MKBTPDRemark, "U", "", "", "")
	}
	else
	{
		q ""
	}
	
	//s sc = nobj.%Save()
	//s id = nobj.%Id()
	s restr=sc
	s restr=[].%FromJSON(re)
	s id=restr.%Get("id")
	if (id'="")		//保存术语成功
	{
		s sc1=..SaveAliasLog(id, "", Desc, "", "C", "", 1, "", "")		//新增别名
		s restr=[].%FromJSON(re)
		s aliasid=restr.%Get("id")
		
		s bobj = ##class(web.Entity.MKB.MKBGlobalReference).%New()
		s bobj.InitiativeFlag=Type				//发起引用，主动引用标识
		s bobj.InitiativeID=TermId				//发起引用词的ID
		s bobj.PassiveID=id				//被引用词的ID
		s bobj.PassiveAliasID=aliasid				//被引用词的名称列表ID
		s sc2=..SaveReferenceEntity(bobj)
	}
	if ((sc["true")&&(sc1["true")&&(sc2["true"))	//均保存成功
	{
		s result = "success"
	}
	else
	{
		s result = "false"
	}
	
	q result
}

/// Creator:范文凯
/// CreatDate:2019-10-08
/// Description:新增编码调用方法（执行以前的保存术语或者属性方法，同时操作全局化词表新增数据）
/// Input：中心词
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).RuternFlag("鼻骨","1","T")
ClassMethod RuternFlag(Desc As %String, termid As %String, Type As %String)
{
	s flag = 0
	s a = $d(^User.MKBGlobalI("DescIndex"," "_Desc))
	s b = $d(^User.MKBGloAliasI("DescIndex"," "_Desc))
	if ((a'=0)||(b'=0))
	{
		s flag = 1
	}
	if (flag=0)
	{
		if (Desc'["&S&N&P")
		{
			d ..IncreaseCode(termid,Type)
		}
	}
	q flag
}

/// Creator:范文凯
/// CreatDate:2019-10-10
/// Description:删除引用编码调用方法（执行以前的保存术语或者属性方法，同时操作全局化词表新增数据）  拿到termid之后判断一下 termbase  只执行主要部位的操作
/// Input：中心词
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).DeleteReference("751901","T")
ClassMethod DeleteReference(TermId As %String, Type As %String)
{
	s termbaseid  = $lg($g(^User.MKBTermD(TermId)),4)                //判断该术语是不是主要部位的
	if (termbaseid=6)
	{
		s num = 0    
		if ('$d(^User.MKBGlobalReferenceI("AllIndex",Type,TermId)))
		{
			q ""
		}
		s PassiveID = $o(^User.MKBGlobalReferenceI("AllIndex",Type,TermId,0))
		s termid = 0
		for
		{
			s termid = $o(^User.MKBGlobalReferenceI("InverAllIndex",PassiveID,"T",termid))
			q:termid=""
			s num = num + 1 
		}
		for
		{
			s termid = $o(^User.MKBGlobalReferenceI("InverAllIndex",PassiveID,"D",termid))
			q:termid=""
			s num = num + 1 
		}
		if (num=1)               //全局化词表就只有这一个引用,把全局化词表删掉 	把状态字段改为D  同时删除引用表的数据  
		{
			Ts
			
			s sc= ..SaveGlobalLog(PassiveID, "","","", "D", "", "", "")
			
			s MKBGRRowid = $o(^User.MKBGlobalReferenceI("AllIndex",Type,TermId,PassiveID,0))
			s sc1=..DeleteReferenceData(MKBGRRowid)
			
			if ((sc'["false")&&(sc1'["false"))  //术语保存成功，引用删除成功
			{
				TC	
			}
			else
			{
				Tro
			}
		}
		elseif (num'=0)&(num'=1)                    //如果全局化词表有多个引用， 只删除引用表的数据
		{
			Ts 
			s MKBGRRowid = $o(^User.MKBGlobalReferenceI("AllIndex",Type,TermId,PassiveID,0))
			s sc=..DeleteReferenceData(MKBGRRowid)
			
			if $$$ISOK(sc)
			{
				TC	
			}
			else
			{
				Tro
			}		
		}
	}
	q ""
}

/// Creator:范文凯
/// CreatDate:2019-10-14
/// Description:新增编码时，MKBG_Code的自动编码方法
/// Input：无
/// Return：MKBG_Code
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).AutoCode()
ClassMethod AutoCode()
{
	s AutoCode = ""
	s MKBGCode = ""
	s MKBGCode = $o(^User.MKBGlobalD(MKBGCode),-1)
	s AutoCode = MKBGCode + 1 
	q AutoCode
}

/// Creator:范文凯
/// CreatDate:2019-10-15
/// Description:返回MKBGSource
/// Input：MKGB_Rowid
/// Return：MKBG_Source
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).ReturnMKBGSource(106)
ClassMethod ReturnMKBGSource(MKBGRowid As %String)
{
	s MKBGSource = ""
	s MKBInitiativeID = $o(^User.MKBGlobalReferenceI("InverAllIndex",MKBGRowid,"T",0))
	if (MKBInitiativeID="")
	{
		q MKBGSource
	}
	s termid = MKBInitiativeID
	for
	{
		s Desc = $lg($g(^User.MKBTermD(termid)),3)
		s termid = $lg($g(^User.MKBTermD(termid)),5)            //获得上级元素
		s MKBGSource ="=>"_Desc_MKBGSource
		q:termid=""
	}
	s MKBGSource = $e(MKBGSource,3,*-0)
	q MKBGSource
}

/// Creator:范文凯
/// CreatDate:2019-10-20
/// Description:返回同名术语列表
/// Input：无
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBGlobal","GetSameGlobal","主动脉")
Query GetSameGlobal(Desc As %String) As %Query(ROWSPEC = "MKBGDesc,count")
{
}

ClassMethod GetSameGlobalExecute(ByRef qHandle As %Binary, Desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	if (Desc'="")              //如何描述不为空
 	{
	 	s Desc=$ZCONVERT(Desc,"U") //转换成大写
	 	if $d(^TmpMKBGDesc(" "_Desc))
	 	{
		 	s MKBGDesc = Desc
		 	s count = ^TmpMKBGDesc(" "_MKBGDesc)
		 	d OutputRow8
		}
		else
		{
			d OutputRow8
		}
	}
	else                    //描述为空 全遍历
	{
 		s MKBGDesc = 0 
 		for
 		{
	 		s MKBGDesc = $o(^TmpMKBGDesc(" "_MKBGDesc))
	 		q:MKBGDesc=""
	 		s count = ^TmpMKBGDesc(MKBGDesc)
	 		s MKBGDesc = $Replace(MKBGDesc," ","")
	 		d OutputRow8
		}
	}
	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(MKBGDesc, count)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetSameGlobalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCTPMExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetSameGlobalClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSameGlobalExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 为返回同名术语创建临时global
/// w ##class(web.DHCBL.MKB.MKBGlobal).TempGlobalDesc()
ClassMethod TempGlobalDesc()
{
	k ^TmpMKBGDesc
	s MKBGDesc =" "
	s ^TmpMKBGDesc=""
 	for
 	{
	 	s MKBGDesc = $o(^User.MKBGlobalI("DescIndex",MKBGDesc))
	 	q:MKBGDesc=""
	 	
	 	s count= 0
	 	s flag =""
	 	s MKBGRowid = "" 
	 	for 
	 	{
		 	s MKBGRowid = $o(^User.MKBGlobalI("DescIndex",MKBGDesc,MKBGRowid))
		 	q:MKBGRowid=""
		 	s MKBGState = $lg($g(^User.MKBGlobalD(MKBGRowid)),8)
		 	s MKBGConfirm = $lg($g(^User.MKBGlobalD(MKBGRowid)),9)
		 	continue:MKBGState'="U" 
 
		 	s count = count+1
		}
	 	if (count>1)
	 	{
		 	s ^TmpMKBGDesc(MKBGDesc)=count
		}
	}
	q ""
}

/// Creator: 陈代雷
/// CreatDate: 2019-09-29
/// Description:根据Base将数据导入全局化词表中 
/// Table: User.MKBGlobal User.MKBGloAlias
/// Input:Base：知识库ID
/// Return:
/// w ##class(web.DHCBL.MKB.MKBGlobal).ImportDataByBase("79")
ClassMethod ImportDataByBase(Base As %String)
{
	TS
	s ErrorInfo=""
	s TermRowId=0
	for
	{
		s TermRowId=$o(^User.MKBTermI("BaseIndex",Base,TermRowId))  //根据知识库ID取一条术语ID
		//w TermRowId,!
		q:TermRowId=""
		//b
		s eobj = ##class(web.Entity.MKB.MKBGlobal).%New()
		///保存该术语下的内容和属性内容
		//s eobj.MKBGCode=$lg($g(^User.MKBTermD(TermRowId)),2)    //术语代码
		s eobj.MKBGDesc=$lg($g(^User.MKBTermD(TermRowId)),3)    //术语描述
		//w eobj.MKBGDesc,!
		s eobj.MKBGPYCode=$lg($g(^User.MKBTermD(TermRowId)),6)    //术语拼音码
		s eobj.MKBGNote=$lg($g(^User.MKBTermD(TermRowId)),7)    //术语备注
		s EnRowId=0
		for
		{
			s EnRowId=$o(^User.MKBTermPropertyI("TermIndex",TermRowId,EnRowId))
			q:EnRowId=""
			if ($lg($g(^User.MKBTermPropertyD(EnRowId)),3)["英文名")   //判断获取英文名
			{
				s EnDRowId=$o(^User.MKBTermProDetailI("ProIdx",EnRowId,0))
				continue:EnDRowId=""
				s eobj.MKBGEnName=$lg($g(^User.MKBTermProDetailD(EnDRowId)),3)
				q
			}
		}
		s Termrs=..SaveGlobalEntity(eobj)   //保存术语到全局化词表中
		s Termsc=Termrs["true"
		if $$$ISOK(Termsc)
		{
			s json=##class(web.DHCBL.MKB.SDSCommonFromJson).%New()
			s jsontmp= json.%FromJSON(Termrs)
			s RowId=json.%Get("id")
			s Referencers=##class(web.DHCBL.MKB.MKBGlobalReference).SaveData("A",RowId,"T",TermRowId)    //保存引用表
			if (Referencers["error")
			{
				s ErrorInfo=ErrorInfo_"TermReference:"_TermRowId_"数据导入失败 "
				b
			}
		}
		else
		{
			s ErrorInfo=ErrorInfo_"Term:"_TermRowId_"数据导入失败 "
			b
		}
		///导入术语下的属性
		//TS
		s TermProRowId=0
		for
		{
			s TermProRowId=$o(^User.MKBTermPropertyI("TermIndex",TermRowId,TermProRowId))
			q:TermProRowId=""
			///导入别名到别名表中
			if ($lg($g(^User.MKBTermPropertyD(TermProRowId)),3)="别名")
			{
				
				s AliasDRowId=0
				if ($o(^User.MKBTermProDetailI("ProIdx",TermProRowId,AliasDRowId))="")
				{
					s aobj = ##class(web.Entity.MKB.MKBGloAlias).%New()  //别名表实体类对象
					s aobj.MKBGAParRef=RowId     //别名父表指针
					s aobj.MKBGADesc=$lg($g(^User.MKBTermD(TermRowId)),3)
					s aobj.MKBGACEFlag="C"
					;w aobj.MKBGAParRef_"--"_aobj.MKBGADesc,!
					s Aliasrs=..SaveAliasEntity(aobj)    //保存别名到别名表
					d aobj.%Close()
					s Aliassc=Aliasrs["false"
					if $$$ISOK(Aliassc)
					{
						s ErrorInfo=ErrorInfo_"Alias:"_AliasDRowId_"数据导入失败 "
						b
					}
				}
				else
				{
					for
					{
						s AliasDRowId=$o(^User.MKBTermProDetailI("ProIdx",TermProRowId,AliasDRowId))
						q:AliasDRowId=""
						s aobj = ##class(web.Entity.MKB.MKBGloAlias).%New()  //别名表实体类对象
						s aobj.MKBGAParRef=RowId     //别名父表指针
						//w TermRowId_"AAAA",!
						s aobj.MKBGADesc=$lg($g(^User.MKBTermProDetailD(AliasDRowId)),3)    //别名
						s aobj.MKBGANote=$lg($g(^User.MKBTermProDetailD(AliasDRowId)),7)    //别名备注
						s aobj.MKBGACEFlag="C"
						//w aobj.MKBGAParRef_" "_aobj.MKBGADesc_" "_aobj.MKBGANote_"AAAA",!
						s Aliasrs=..SaveAliasEntity(aobj)    //保存别名到别名表
						d aobj.%Close()
						s Aliassc=Aliasrs["false"
						if $$$ISOK(Aliassc)
						{
							s ErrorInfo=ErrorInfo_"Alias:"_AliasDRowId_"数据导入失败 "
							b
						}
					}
				}
			}
			
			///导入英文名到别名表中
			if ($lg($g(^User.MKBTermPropertyD(TermProRowId)),3)["英文名")   //判断获取英文名
			{
				s AliasDRowId=0
				for
				{
					s AliasDRowId=$o(^User.MKBTermProDetailI("ProIdx",TermProRowId,AliasDRowId))
					q:AliasDRowId=""
					s aobj = ##class(web.Entity.MKB.MKBGloAlias).%New()  //别名表实体类对象
					s aobj.MKBGAParRef=RowId     //别名父表指针
					//w TermRowId_"AAAA",!
					s aobj.MKBGADesc=$lg($g(^User.MKBTermProDetailD(AliasDRowId)),3)    //英文别名
					s aobj.MKBGANote=$lg($g(^User.MKBTermProDetailD(AliasDRowId)),7)    //英文别名备注
					s aobj.MKBGACEFlag="E"
					//w aobj.MKBGAParRef_" "_aobj.MKBGADesc_" "_aobj.MKBGANote_"AAAA",!
					s Aliasrs=..SaveAliasEntity(aobj)    //保存别名到别名表
					s Aliassc=Aliasrs["false"
					if $$$ISOK(Aliassc)
					{
						s ErrorInfo=ErrorInfo_"Alias:"_AliasDRowId_"数据导入失败 "
						b
					}
				}
			}
			s TermProType=$lg($g(^User.MKBTermPropertyD(TermProRowId)),4)
			//w "Type"_TermProType,!
			//b
			if (TermProType="TX")||(TermProType="TA")      //判断属性类型是否为文本或多行文本框
			{
				//w "OKOKOK",!
				s pobj = ##class(web.Entity.MKB.MKBGlobal).%New()
				///保存属性内容
				s TermProDRowId=$o(^User.MKBTermProDetailI("ProIdx",TermProRowId,0))
				continue:TermProDRowId=""
				//s pobj.MKBGCode=$lg($g(^User.MKBTermProDetailD(TermProDRowId)),2)    //属性内容代码
				s pobj.MKBGDesc=$lg($g(^User.MKBTermProDetailD(TermProDRowId)),3)    //属性内容描述
				//w pobj.MKBGDesc_"DD",!
				s pobj.MKBGPYCode=$lg($g(^User.MKBTermProDetailD(TermProDRowId)),10)    //属性内容拼音码
				s pobj.MKBGNote=$lg($g(^User.MKBTermProDetailD(TermProDRowId)),7)    //属性内容备注
				s ProDrs=..SaveGlobalEntity(pobj)      //保存该术语下的属性内容到全局化词表中
				
				
				
				
				s ProDsc=ProDrs["false"
				if (ProDsc)
				{
					s ErrorInfo=ErrorInfo_"ProDetail:"_TermProDRowId_"数据导入失败 "
					b
				}
				else
				{
					s jsonD=##class(web.DHCBL.MKB.SDSCommonFromJson).%New()
					s jsontmpD= jsonD.%FromJSON(ProDrs)
					s DRowId=jsonD.%Get("id")
					s ReferenceDrs=##class(web.DHCBL.MKB.MKBGlobalReference).SaveData("A",DRowId,"D",TermProDRowId)
					if (ReferenceDrs["error")
					{
						s ErrorInfo=ErrorInfo_"ProDetailReference:"_TermProDRowId_"数据导入失败 "
						b
					}
				}
			}
			else
			{
				continue
			}
		}
	}
	if (ErrorInfo="")
	{
		s ErrorInfo="数据导入成功！"
	}
	q ErrorInfo
}

/// Creator:陈代雷
/// CreatDate:2019-09-30
/// Description:保存数据到全局化词表中
/// Table : User.MKBGlobal
/// Entity : web.Entity.MKB.MKBGlobal
/// Return:成功返回success:'true'和新增或修改的数据的ID;失败返回success:'false'和失败原因
/// w ##class(web.DHCBL.MKB.MKBGlobal).SaveGlobalEntity(eobj)
ClassMethod SaveGlobalEntity(eobj As web.Entity.MKB.MKBGlobal) As %String
{
	s result = ""
	if $IsObject(eobj)
	{
		//w eobj.MKBGCode_"AAA",!
		if (eobj.MKBGCode="")
		{
			//s code=$lg($g(^User.MKBGlobalD($o(^User.MKBGlobalD(""),-1))),2)
			//s code=$Replace(code," ","")
			if ($o(^User.MKBGlobalD(""),-1)="")
			{
				s eobj.MKBGCode=1
			}
			else
			{
				s code=$lg($g(^User.MKBGlobalD($o(^User.MKBGlobalD(""),-1))),2)
				s code=$Replace(code," ","")
				s eobj.MKBGCode=code+1
			}
		}

		//w eobj.MKBGCode,!
		q:(eobj.MKBGCode="") "{""success"":""false"",""errorinfo"":""代码为空！""}"
		q:(eobj.MKBGDesc="") "{""success"":""false"",""errorinfo"":""描述为空！""}"
		s obj=##class(User.MKBGlobal).%New()
		if (eobj.MKBGRowId="")  //如果RowId未赋值则增加
		{
			s obj=##class(User.MKBGlobal).%New()
		}
		else  //如果RowId已赋值则修改
		{
			s obj=##class(User.MKBGlobal).%OpenId(eobj.MKBGRowId)
			s bobj = ##class(web.Entity.MKB.MKBGlobal).%New()
			s bobj.MKBGRowId = eobj.MKBGRowId
			s bobj.MKBGCode = obj.MKBGCode
			s bobj.MKBGDesc = obj.MKBGDesc
			s bobj.MKBGEnName=obj.MKBGEnName
			s bobj.MKBGNote = ##class(web.DHCBL.BDP.FunLib).Util(obj.MKBGNote)
			s bobj.MKBGPYCode=  obj.MKBGPYCode
			s bobj.MKBGLastLevel=obj.MKBGLastLevel
			
			s bobj.MKBGState=obj.MKBGState
			s bobj.MKBGConfirm=obj.MKBGConfirm
			s bobj.MKBGMark = obj.MKBGMark
			s bobj.MKBGDiaTotalFreq=obj.MKBGDiaTotalFreq
			
			//如果是修改数据,则先删除索引表的数据
			//d ##class(web.DHCBL.MKB.MKBTermProDetail).DeleteTermIndex(eobj.MKBTRowId,"T")
			}
	
		s obj.MKBGCode = eobj.MKBGCode
		s obj.MKBGDesc = ##class(web.DHCBL.BDP.FunLib).Util(eobj.MKBGDesc)
		s obj.MKBGEnName = eobj.MKBGEnName
		
		s obj.MKBGNote = ##class(web.DHCBL.BDP.FunLib).Util(eobj.MKBGNote)
		if ((eobj.MKBGPYCode="")&(eobj.MKBGDesc'=""))	//拼音码为空
		{
			s eobj.MKBGPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE($ZCONVERT(eobj.MKBGDesc,"U"))
		}
		s obj.MKBGPYCode = eobj.MKBGPYCode
		
		s obj.MKBGLastLevel=eobj.MKBGLastLevel
		if (eobj.MKBGState'="")		//状态不为空
		{
			s obj.MKBGState=eobj.MKBGState
		}
		s MKBGBDesc=""
		
		s obj.MKBGConfirm=eobj.MKBGConfirm
		if (eobj.MKBGMark'="")		//标志不为空
		{
			s obj.MKBGMark = eobj.MKBGMark
		}
		s obj.MKBGDiaTotalFreq=eobj.MKBGDiaTotalFreq
		Ts
		s sc=obj.%Save()	
		d obj.%Close()
		s id =""
		if $$$ISOK(sc){
			TC
			s id = obj.%Id()
			s result = "{""success"":""true"",""id"":"_id_"}"
			//保存日志
		 	d:eobj.MKBGRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_Global","User.MKBGlobal",MKBGBDesc,id,eobj.MKBGDesc,"A",eobj)
			d:eobj.MKBGRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_Global","User.MKBGlobal",MKBGBDesc,eobj.MKBGRowId,eobj.MKBGDesc,"U",eobj,bobj)
		 	d eobj.%Close()	
		}
		else{
			Trollback
			s result = "{""success"":""false"",""errorinfo"":"""_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"""}"   //返回错误信息
		}
	}	

	else
	{
		s result = "{""success"":""false"",""errorinfo"":""对象不存在""}"
	}
	
	q result
}

/// Creator:陈代雷
/// CreatDate:2019-10-15
/// Description:全局化词表保存/修改数据（前台全局化词表保存修改按钮调用），(同时同步修改Term表和detail表中数据(已屏蔽))
/// Table : User.MKBGlobal
/// Entity : web.Entity.MKB.MKBGlobal
/// Return:成功返回success:'true'和新增或修改的数据的ID;失败返回success:'false'和失败原因
/// w ##class(web.DHCBL.MKB.MKBGlobal).SaveGlobalData(eobj)
ClassMethod SaveGlobalData(eobj As web.Entity.MKB.MKBGlobal) As %String
{
	s result = ""
	if $IsObject(eobj)
	{
		//w eobj.MKBGCode_"AAA",!
		if (eobj.MKBGCode="")
		{
			//s code=$lg($g(^User.MKBGlobalD($o(^User.MKBGlobalD(""),-1))),2)
			//s code=$Replace(code," ","")
			if ($o(^User.MKBGlobalD(""),-1)="")
			{
				s eobj.MKBGCode=1
			}
			else
			{
				s code=$lg($g(^User.MKBGlobalD($o(^User.MKBGlobalD(""),-1))),2)
				s code=$Replace(code," ","")
				s eobj.MKBGCode=code+1
			}
		}
		//w eobj.MKBGCode,!
		q:(eobj.MKBGCode="") "{success:'false',errorinfo:'代码不能为空！'}"
		q:(eobj.MKBGDesc="") "{success:'false',errorinfo:'描述不能为空！'}"
		s obj=##class(User.MKBGlobal).%New()
		if (eobj.MKBGRowId="")  //如果RowId未赋值则增加
		{
			s obj=##class(User.MKBGlobal).%New()
		}
		else  //如果RowId已赋值则修改
		{
			s obj=##class(User.MKBGlobal).%OpenId(eobj.MKBGRowId)
			s bobj = ##class(web.Entity.MKB.MKBGlobal).%New()
			s bobj.MKBGRowId = eobj.MKBGRowId
			s bobj.MKBGCode = obj.MKBGCode
			s bobj.MKBGDesc = obj.MKBGDesc
			s bobj.MKBGEnName=obj.MKBGEnName
			s bobj.MKBGNote = ##class(web.DHCBL.BDP.FunLib).Util(obj.MKBGNote)
			s bobj.MKBGPYCode=  obj.MKBGPYCode
			s bobj.MKBGLastLevel=obj.MKBGLastLevel
			
			s bobj.MKBGState=obj.MKBGState
			s bobj.MKBGConfirm=obj.MKBGConfirm
			s bobj.MKBGMark = obj.MKBGMark
			s bobj.MKBGDiaTotalFreq=obj.MKBGDiaTotalFreq
		
		}
	
		s obj.MKBGCode = eobj.MKBGCode
		s obj.MKBGDesc = ##class(web.DHCBL.BDP.FunLib).Util(eobj.MKBGDesc)
		s obj.MKBGEnName = eobj.MKBGEnName
		s obj.MKBGLastLevel=eobj.MKBGLastLevel
		if (eobj.MKBGState'="")
		{
			s obj.MKBGState=eobj.MKBGState
		}
		s MKBGBDesc=""
			
		if (eobj.MKBGPYCode="")&(eobj.MKBGDesc'="")
		{
			s eobj.MKBGPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE($ZCONVERT(eobj.MKBGDesc,"U"))
		}
		s obj.MKBGPYCode = eobj.MKBGPYCode
		s obj.MKBGNote = ##class(web.DHCBL.BDP.FunLib).Util(eobj.MKBGNote)
		s obj.MKBGConfirm=eobj.MKBGConfirm
		s:eobj.MKBGMark'="" obj.MKBGMark=eobj.MKBGMark 
		s obj.MKBGDiaTotalFreq=eobj.MKBGDiaTotalFreq
		Ts
		s sc=obj.%Save()	
		d obj.%Close()
		s id =""
		if $$$ISOK(sc){
			TC
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			//保存日志
		 	d:eobj.MKBGRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_Global","User.MKBGlobal","全局化词表",id,eobj.MKBGDesc,"A",eobj)
			d:eobj.MKBGRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_Global","User.MKBGlobal","全局化词表",eobj.MKBGRowId,eobj.MKBGDesc,"U",eobj,bobj)
		 	if (eobj.MKBGRowId="")    //如果新增中心词，同时保存为别名
		 	{
			 	s eaobj=##class(web.Entity.MKB.MKBGloAlias).%New()
			 	s eaobj.MKBGADesc=eobj.MKBGDesc
			 	s eaobj.MKBGAParRef=id
			 	s eaobj.MKBGACEFlag="C"
			 	s eaobj.MKBGAMark="6"	//设为展示名
			 	s eaobj.IsDisplayName="Y"
			 	d ..SaveAliasData(eaobj)
			 	
		 	}	
		 	d eobj.%Close()
		 	
		}
		else{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
		}
	}	

	else
	{
		s result = "{success:'false',errorinfo:'对象不存在'}"
	}
	
	q result
}

/// Creator:谢海睿
/// CreatDate:2020-6-8
/// Description:全局化词表保存/修改数据（前台全局化词表保存修改按钮调用），(同时同步修改Term表和detail表中数据(已屏蔽))
/// Table : User.MKBGlobal
/// Entity : web.Entity.MKB.MKBGlobal
/// Return:成功返回success:'true'和新增或修改的数据的ID;失败返回success:'false'和失败原因
/// w ##class(web.DHCBL.MKB.MKBGlobal).SaveGlobalDataNotForm("从雕塑")
ClassMethod SaveGlobalDataNotForm(MKBGDesc As %String) As %String
{
	s result = ""
	q:(MKBGDesc="") "{success:'false',errorinfo:'术语名不能为空！'}"
	
	//查重：父表和子表联合查重
	s:MKBGDesc'="" MKBGDesc=$ZCONVERT(MKBGDesc,"U") //转换成大写	
	s MKBGFreq = " "
    for
    {
	    s MKBGFreq = $o(^User.MKBGlobalI("MKBGFreqIndex",MKBGFreq),-1)
	    q:MKBGFreq=""
	    s ID = 0
	    for
	    {
		    s ID = $o(^User.MKBGlobalI("MKBGFreqIndex",MKBGFreq,ID))
		    q:ID=""
		    s MKBGRowId=ID
		
			s MKBGDesc1=$lg($g(^User.MKBGlobalD(MKBGRowId)),3)
			if (MKBGDesc=MKBGDesc1)
			{

				s result = "{success:'false',errorinfo:'术语名重复！',Desc:'"_MKBGDesc1_"',id:'"_MKBGRowId_"'}"
				return result
				
			}
			s MKBGAlias=""
			s MKBGDisplaName=""
			s AliasId=0
			for
			{
				s AliasId=$o(^User.MKBGlobalD(ID,"ChildGloAlias",AliasId))  //遍历别名表
				q:AliasId=""
				s MKBGADesc = $lg($g(^User.MKBGlobalD(MKBGRowId,"ChildGloAlias",AliasId)),2) 
			   
			    if (MKBGADesc=MKBGDesc)
			    {
				    s result = "{success:'false',errorinfo:'术语名重复！',Desc:'"_MKBGDesc1_"("_MKBGADesc_")',id:'"_MKBGRowId_"',AliasId:'"_MKBGRowId_"||"_AliasId_"'}"
				    return result  
			    }
			 					
			}	
	    }
    }                       
	s obj=##class(User.MKBGlobal).%New()
	s obj.MKBGDesc = ##class(web.DHCBL.BDP.FunLib).Util($ZCONVERT(MKBGDesc,"U"))
	Ts
	s sc=obj.%Save()	
	d obj.%Close()
	s id =""
	if $$$ISOK(sc){
		TC
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}"
	 	s eaobj=##class(web.Entity.MKB.MKBGloAlias).%New()
	 	s eaobj.MKBGADesc=obj.MKBGDesc
	 	s eaobj.MKBGAParRef=id
	 	s eaobj.MKBGACEFlag="C"
	 	s eaobj.MKBGAMark="6"
	 	d ..SaveAliasData(eaobj)
	 	d obj.%Close()
	}
	else{
		Trollback
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
	}
	
	q result
}

/// Creator:钟荣枫
/// CreatDate:2020-11-19
/// Description:全局化词表保存/修改数据
/// Table : User.MKBGlobal
/// Entity : web.Entity.MKB.MKBGlobal
/// InPut:MKBGDesc 术语描述
/// Return:成功返回success:'true'和新增或修改的数据的ID;失败返回success:'false'和失败原因
/// w ##class(web.DHCBL.MKB.MKBGlobal).SaveGlobalDataNotForm2("腱鞘肿物")
ClassMethod SaveGlobalDataNotForm2(MKBGDesc As %String) As %String
{
	s result = ""
	q:(MKBGDesc="") "{success:'false',errorinfo:'术语名不能为空！'}"
	
	
	//查重：父表查重
	s:MKBGDesc'="" MKBGDesc=$ZCONVERT(MKBGDesc,"U") //转换成大写
	s MKBGRowID = $o(^User.MKBGlobalI("DescIndex"," "_$ZCONVERT(MKBGDesc,"U"),0))
	
	s saveflag=1
	
	if (MKBGRowID'="")
	{
		s MKBGState=$lg($g(^User.MKBGlobalD(MKBGRowID)),8)
		if (MKBGState'="U")
		{
			//删除别名，删除引用，删除频次
			d ..DeleteAll(MKBGRowID)
			
		}
		else
		{
			s saveflag	=0
			s MKBGDesc1=$lg($g(^User.MKBGlobalD(MKBGRowID)),3)
			s result = "{success:'false',errorinfo:'术语名重复！',Desc:'"_MKBGDesc1_"',id:'"_MKBGRowID_"'}"
		}
	}
	if (saveflag=1)
	{
		TS
		s eobj = ##class(web.Entity.MKB.MKBGlobal).%New()	
		s eobj.MKBGRowId=""
		
		s eobj.MKBGDesc = ##class(web.DHCBL.BDP.FunLib).Util($ZCONVERT(MKBGDesc,"U"))
		s eobj.MKBGMark = "常用诊断描述"
		s eobj.MKBGState="U"  
		 
		s result = ..SaveGlobalData(eobj)	//保存术语同时新增别名
		if (result["true")	//保存成功
		{
			TC
		}
		else{
			Trollback
		}
	}
	
	
	q result
}

/// Creator：陈代雷
/// CreatDate: 2019-09-30
/// Description：保存别名表的内容
/// Table：User.MKBGloAlias
/// Input：web.Entity.MKB.MKBGloAlias 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: w ##class(web.DHCBL.MKB.MKBGlobal).SaveAliasEntity(eobj)
ClassMethod SaveAliasEntity(eobj As web.Entity.MKB.MKBGloAlias) As %String
{
	s result = ""
	if $IsObject(eobj)
	{
		s ParRef=eobj.MKBGAParRef
		if (eobj.MKBGARowId="") 
		{
			s judgeRowId=$o(^User.MKBGloAliasI("DescIndex",ParRef," "_$ZCONVERT(eobj.MKBGADesc,"U"),0))
			if (judgeRowId'="")
			{
				s result = "{success:'false',errorinfo:'该记录已经存在'}"
				q result
			}
		}
		
		//s obj=##class(User.MKBGloAlias).%New()
		if (eobj.MKBGARowId="")  //如果RowId未赋值则增加
		{
			s obj=##class(User.MKBGloAlias).%New()
		}
		else  //如果RowId已赋值则修改
		{
			s obj=##class(User.MKBGloAlias).%OpenId(eobj.MKBGARowId)
			s bobj = ##class(web.Entity.MKB.MKBGloAlias).%New()
			s bobj.MKBGARowId = eobj.MKBGARowId
			s bobj.MKBGAParRef=obj.ParRef.%Id()
			s bobj.MKBGADesc=obj.MKBGADesc
			s bobj.MKBGAPYCode=  obj.MKBGAPYCode
			s bobj.MKBGANote = ##class(web.DHCBL.BDP.FunLib).Util(obj.MKBGANote)
			s bobj.MKBGAState=obj.MKBGAState
			s bobj.MKBGACEFlag=obj.MKBGACEFlag
			s bobj.MKBGASequence=obj.MKBGASequence
			s bobj.MKBGAMark=obj.MKBGAMark
			s bobj.IsDisplayName=obj.IsDisplayName
		}
	
		d:eobj.MKBGAParRef'="" obj.ParRefSetObjectId(eobj.MKBGAParRef)
		s obj.MKBGADesc = ##class(web.DHCBL.BDP.FunLib).Util(eobj.MKBGADesc)
		
		s MKBGABDesc=""
			
		if (eobj.MKBGAPYCode="")&(eobj.MKBGADesc'="")
		{
			s eobj.MKBGAPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE($ZCONVERT(eobj.MKBGADesc,"U"))
		}
		s obj.MKBGAPYCode = eobj.MKBGAPYCode
		s obj.MKBGANote = ##class(web.DHCBL.BDP.FunLib).Util(eobj.MKBGANote)
		s obj.MKBGACEFlag=eobj.MKBGACEFlag
		s obj.MKBGAMark = eobj.MKBGAMark
		if (eobj.MKBGASequence="")
		{
			s eobj.MKBGASequence=..GetLastSequence(eobj.MKBGAParRef)
		}
		s obj.MKBGASequence=eobj.MKBGASequence
		
		s obj.IsDisplayName=eobj.IsDisplayName

		Ts
		s sc=obj.%Save()	
		d obj.%Close()
		s id =""
		if $$$ISOK(sc)
		{
			TC
			//d ..RefHandle("1","1,2",eobj.MKBGAParRef)
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.MKBGARowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_GloAlias","User.MKBGloAlias","全局化词表别名表",id,eobj.MKBGADesc,"A",eobj)
			d:eobj.MKBGARowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_GloAlias","User.MKBGloAlias","全局化词表别名表",eobj.MKBGARowId,eobj.MKBGADesc,"U",eobj,bobj)
		}
		else{
			tro
			s result = "{""success"":""false"",""errorinfo"":"""_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"""}"   //返回错误信息
		}
	}	

	else
	{
		s result = "{""success"":""false"",""errorinfo"":""对象不存在""}"
	}
	
	q result
}

/// Creator：陈代雷
/// CreatDate: 2019-09-30
/// Description：保存/修改别名表
/// Table：User.MKBGloAlias
/// Input：web.Entity.MKB.MKBGloAlias 实体类对象
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: w ##class(web.DHCBL.MKB.MKBGlobal).SaveAliasData(eobj)
ClassMethod SaveAliasData(eobj As web.Entity.MKB.MKBGloAlias) As %String
{
	s result = ""
	s:eobj.MKBGAMark="1" eobj.MKBGAMark="别名"
	s:eobj.MKBGAMark="2" eobj.MKBGAMark="展示名"
	s:eobj.MKBGAMark="3" eobj.MKBGAMark="中心词"
	s:eobj.MKBGAMark="4" eobj.MKBGAMark="业务诊断"
	s:eobj.MKBGAMark="5" eobj.MKBGAMark="常用诊断表达式"
	if $IsObject(eobj)
	{
		s ParRef=eobj.MKBGAParRef
		if (eobj.MKBGARowId="") 
		{
			s judgeRowId=$o(^User.MKBGloAliasI("DescIndex",ParRef," "_$ZCONVERT(eobj.MKBGADesc,"U"),0))
			if (judgeRowId'="")
			{
				s result = "{success:'false',errorinfo:'该记录已经存在'}"
				q result
			}
		}
		if (eobj.MKBGARowId="")  //如果RowId未赋值则增加
		{
			s obj=##class(User.MKBGloAlias).%New()
		}
		else  //如果RowId已赋值则修改
		{
			s obj=##class(User.MKBGloAlias).%OpenId(eobj.MKBGARowId)
			s bobj = ##class(web.Entity.MKB.MKBGloAlias).%New()
			s bobj.MKBGARowId = eobj.MKBGARowId
			s bobj.MKBGAParRef=obj.ParRef.%Id()
			s bobj.MKBGADesc=obj.MKBGADesc
			s bobj.MKBGAPYCode=  obj.MKBGAPYCode
			s bobj.MKBGANote = ##class(web.DHCBL.BDP.FunLib).Util(obj.MKBGANote)
			s bobj.MKBGAState=obj.MKBGAState
			s bobj.MKBGACEFlag=obj.MKBGACEFlag
			s bobj.MKBGASequence=obj.MKBGASequence
			s bobj.MKBGAMark=obj.MKBGAMark
			s bobj.IsDisplayName=obj.IsDisplayName
		}
	
		d:eobj.MKBGAParRef'="" obj.ParRefSetObjectId(eobj.MKBGAParRef)
		s obj.MKBGADesc = ##class(web.DHCBL.BDP.FunLib).Util(eobj.MKBGADesc)
		
		s MKBGABDesc=""
			
		if (eobj.MKBGAPYCode="")&(eobj.MKBGADesc'="")	//拼音码不存在
		{
			s eobj.MKBGAPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE($ZCONVERT(eobj.MKBGADesc,"U"))
		}
		s obj.MKBGAPYCode = eobj.MKBGAPYCode
		s obj.MKBGANote = ##class(web.DHCBL.BDP.FunLib).Util(eobj.MKBGANote)
		s obj.MKBGACEFlag=eobj.MKBGACEFlag
		if (eobj.MKBGASequence="")
		{
			s eobj.MKBGASequence=..GetLastSequence(eobj.MKBGAParRef)
		}
		s obj.MKBGASequence=eobj.MKBGASequence
		if (eobj.MKBGAMark="中心词")
		{
			s returndesc = ..SetHeadWord(eobj.MKBGAParRef,eobj.MKBGADesc)
			s obj.MKBGADesc = returndesc
			s obj.MKBGAPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE($ZCONVERT(returndesc,"U"))
			
		}
		
		if (eobj.MKBGAMark="6")
		{
			s obj.MKBGAMark="展示名,查询名"
		}
		else
		{
			s:(eobj.MKBGAMark="")||((eobj.MKBGAMark'="业务诊断")&&(eobj.MKBGAMark'="常用诊断表达式")) obj.MKBGAMark="别名"
			s:(eobj.MKBGAMark="业务诊断") obj.MKBGAMark="业务诊断"
			s:(eobj.MKBGAMark="常用诊断表达式") obj.MKBGAMark="常用诊断表达式"	
			s:(eobj.MKBGAMark["残留") obj.MKBGAMark=eobj.MKBGAMark
		}
		s obj.IsDisplayName=eobj.IsDisplayName
		
		Ts
		s sc=obj.%Save()	
		d obj.%Close()
		s id =""
		if $$$ISOK(sc){
			TC
			d ..RefHandle("1","1,2",ParRef)
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.MKBGARowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_GloAlias","User.MKBGloAlias","全局化词表别名表",id,eobj.MKBGADesc,"A",eobj)
			d:eobj.MKBGARowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_GloAlias","User.MKBGloAlias","全局化词表别名表",eobj.MKBGARowId,eobj.MKBGADesc,"U",eobj,bobj)
		 		
		 	//d ##class(web.DHCBL.MKB.MKBTermProDetail).AddTermIndex(id,"T")
		 	d eobj.%Close()
		}
		else{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
		}	
	}	

	else
	{
		s result = "{success:'false',errorinfo:'对象不存在'}"
	}
	
	q result
}

/// Creator：chendailei
/// CreatDate: 2019-10-12
/// Description：获取全局化词表的内容
/// Table：User.MKBGLobal
/// Input：rowid,code,desc confirm:是否确认，Y显示已确认 N显示未确认 空全部显示
/// d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBGlobal","GetList","","","","","","1","临床实用诊断,常用诊断描述,业务诊断,展示名","","","","")
/// d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBGlobal","GetList","454045","","","","","","","","","","")
/// d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBGlobal","GetList","","","","","N","","部位,临床实用诊断,常用诊断描述,业务诊断,展示名","","locsort","1429031","5")
Query GetList(rowid As %String, code As %String, desc As %String, confirm As %String, Type As %String, LoadSameFlag As %String, MarkStr As %String, AliasMarkStr As %String, SortMethod As %String, SortLocStr As %String, LocFreq As %String) As %Query(ROWSPEC = "MKBGRowId:%String,MKBGCode:%String,MKBGDesc:%String,MKBGEnName:%String,MKBGNote:%String,MKBGPYCode:%String,MKBGLastLevel:%String,MKBGState:%String,MKBGConfirm:%String,MKBGAlias:%String,MKBGloMark:%String,MKBGDiaTotalFreq:%String,MKBGDisplaName:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, confirm As %String, Type As %String, LoadSameFlag As %String, MarkStr As %String, AliasMarkStr As %String, SortMethod As %String, SortLocStr As %String, LocFreq As %String) As %Status
{
	
	s repid=$I(^CacheTemp)
	s ind=1
	s MKBGloMark=""
	
	k ^TmpDataHandle
	k ^TempHandle("Freq")
	k ^TempMarkSortList	
	
	s ShowName=""
	if ($l(MarkStr,",")=1)
	{
		s MKBGMark = MarkStr
		s MarkNum = 0            //说明标志只有1个
	}
	else
	{
		s MKBGMark= MarkStr
		s MarkNum = 1            //说明标志有多个  判断的时候要用包含关系
	}
	
	s desc=$Replace(desc,"，",",")               //中文逗号改为英文逗号,方便后续方法处理数据
	
	if (LoadSameFlag '="")                       //用于返回全局化词表中Desc完全相同的术语
	{
		d ..TempGlobalDesc()
		s Desc = ""
		for
		{
			s Desc = $o(^TmpMKBGDesc(Desc))
			q:Desc=""
			s MKBGRowId=""
			for
			{
				s MKBGRowId = $o(^User.MKBGlobalI("DescIndex",Desc,MKBGRowId))	
				q:MKBGRowId=""
				//s leftstr=##class(web.DHCBL.MKB.MKBGlobal).IsLeave(MKBGRowId,AliasMarkStr)
				//continue:($p(leftstr,"^",1)=0)	//别名不含有某个别名标志
				
				s MKBGCode=$lg($g(^User.MKBGlobalD(MKBGRowId)),2)
				s MKBGDesc=$lg($g(^User.MKBGlobalD(MKBGRowId)),3)
				s MKBGEnName=$lg($g(^User.MKBGlobalD(MKBGRowId)),4)
				s MKBGNote=$lg($g(^User.MKBGlobalD(MKBGRowId)),5)
				s MKBGPYCode=$lg($g(^User.MKBGlobalD(MKBGRowId)),6)
				s MKBGLastLevel=$lg($g(^User.MKBGlobalD(MKBGRowId)),7)
				s MKBGState=$lg($g(^User.MKBGlobalD(MKBGRowId)),8)
				s MKBGloMark =$lg($g(^User.MKBGlobalD(MKBGRowId)),10)
				s MKBGDiaTotalFreq = $lg($g(^User.MKBGlobalD(MKBGRowId)),11)
				s MKBGAlias=""
				s AliasId=""
				for
				{
					s AliasId=$o(^User.MKBGlobalD(MKBGRowId,"ChildGloAlias",AliasId))  //遍历别名表
					q:AliasId=""
					s AliasMark = $lg($g(^User.MKBGlobalD(MKBGRowId,"ChildGloAlias",AliasId)),8) 
					continue:AliasMark'["查询名"
					if (MKBGAlias="")
					{
						s MKBGAlias=$lg($g(^User.MKBGlobalD(MKBGRowId,"ChildGloAlias",AliasId)),2)   //别名
					}
					else
					{
						s MKBGAlias=MKBGAlias_","_$lg($g(^User.MKBGlobalD(MKBGRowId,"ChildGloAlias",AliasId)),2)   //别名
					}
					
				}
				s ShowNameID=$o(^User.MKBGloAliasI("DisplayName",MKBGRowId," Y",""))
				s MKBGDisplaName=""
				s:ShowNameID'="" MKBGDisplaName=$lg($g(^User.MKBGlobalD(MKBGRowId,"ChildGloAlias",ShowNameID)),2)
				s:MKBGDisplaName="" MKBGDisplaName=MKBGDesc
				
				s flag=0
				if (MKBGMark="")
				{
					s flag=1
				}
				else
				{
					for m=1:1:$l(MKBGMark,",")
					{
						s mark=$p(MKBGMark,",",m)
						continue:(mark="")
						s:(MKBGloMark[mark) flag=1
						q:flag=1
					}
				}
				if (flag=1)
				{
					d OutputRow
					s ^TmpDataHandle(MKBGRowId)=""
					s Freq=MKBGDiaTotalFreq
					s:MKBGDiaTotalFreq="" Freq=" "_MKBGDiaTotalFreq
					s ^TempHandle("Freq",Freq,MKBGRowId)=MKBGRowId	
				}	
			}
		}
	}

	else           //用于常规查询
	{	
	    
		if (rowid'="") //根据rowid返回该条记录
		{
		
				s ID=rowid
				
				s MKBGRowId = ID
				
				s MKBGCode=$lg($g(^User.MKBGlobalD(MKBGRowId)),2)
				s MKBGDesc=$lg($g(^User.MKBGlobalD(MKBGRowId)),3)
				s MKBGEnName=$lg($g(^User.MKBGlobalD(ID)),4)
				s MKBGNote=$lg($g(^User.MKBGlobalD(ID)),5)
				s MKBGPYCode=$lg($g(^User.MKBGlobalD(ID)),6)
				s MKBGLastLevel=$lg($g(^User.MKBGlobalD(ID)),7)
				s MKBGState=$lg($g(^User.MKBGlobalD(ID)),8)
				s MKBGloMark =$lg($g(^User.MKBGlobalD(ID)),10)
				s MKBGDiaTotalFreq = $lg($g(^User.MKBGlobalD(ID)),11)
				s MKBGAlias=""
				s MKBGDisplaName=""
				s AliasId=0
				for
				{
					s AliasId=$o(^User.MKBGlobalD(ID,"ChildGloAlias",AliasId))  //遍历别名表
					q:AliasId=""
					s AliasMark = $lg($g(^User.MKBGlobalD(MKBGRowId,"ChildGloAlias",AliasId)),8)
					s MKBGADesc = $lg($g(^User.MKBGlobalD(MKBGRowId,"ChildGloAlias",AliasId)),2) 
					
				    if (AliasMark["查询名")
				    {
					    if (MKBGAlias="")
						{
							s MKBGAlias=$lg($g(^User.MKBGlobalD(ID,"ChildGloAlias",AliasId)),2)   //别名
						}
						else
						{
							s MKBGAlias=MKBGAlias_","_$lg($g(^User.MKBGlobalD(ID,"ChildGloAlias",AliasId)),2)   //别名
						}
				    }
				}
				s ShowNameID=$o(^User.MKBGloAliasI("DisplayName",MKBGRowId," Y",""))
				s MKBGDisplaName=""
				s:ShowNameID'="" MKBGDisplaName=$lg($g(^User.MKBGlobalD(MKBGRowId,"ChildGloAlias",ShowNameID)),2)
				s:MKBGDisplaName="" MKBGDisplaName=MKBGDesc
				
				s flag=0
				if (MKBGMark="")
				{
					s flag=1
				}
				else
				{
					for m=1:1:$l(MKBGMark,",")
					{
						s mark=$p(MKBGMark,",",m)
						continue:(mark="")
						s:(MKBGloMark[mark) flag=1
						q:flag=1
					}
				}
				if (flag=1)		//是业务域之一
				{
					d OutputRow
				    s ^TmpDataHandle(MKBGRowId)=""
				    s Freq=MKBGDiaTotalFreq
					s:MKBGDiaTotalFreq="" Freq=" "_MKBGDiaTotalFreq
					s ^TempHandle("Freq",Freq,MKBGRowId)=MKBGRowId	
				}
				
		}
		else           //如果rowid为空，则根据Desc来查询数据
		{
			
			s:code'="" code=$ZCONVERT(code,"U") //转换成大写
			s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
			s AllLocStr=""
			if (SortLocStr'="")
			{
				s AllLocStr=..GetSortedLocStr(SortLocStr)	//科室串按照从小到大排序
				s ^TempSearchLoc=AllLocStr_"^"_LocFreq
			}
			
		    d ..SortGlobal(SortMethod,AllLocStr,LocFreq)
			
				
			s NumCount=0			
			for
			{
				s NumCount=$o(^TempMarkSortList("Sort",NumCount))
				q:NumCount=""
				
				s MKBGRowId=^TempMarkSortList("Sort",NumCount)
				q:MKBGRowId=""
			    
			    s leftstr=##class(web.DHCBL.MKB.MKBGlobal).IsLeave(MKBGRowId,AliasMarkStr)
				continue:($p(leftstr,"^",1)=0)	//别名不含有某个别名标志
				s MKBGCode=$lg($g(^User.MKBGlobalD(MKBGRowId)),2)
				s MKBGDesc=$lg($g(^User.MKBGlobalD(MKBGRowId)),3)
				s MKBGEnName=$lg($g(^User.MKBGlobalD(MKBGRowId)),4)
				s MKBGNote=$lg($g(^User.MKBGlobalD(MKBGRowId)),5)
				s MKBGPYCode=$lg($g(^User.MKBGlobalD(MKBGRowId)),6)

				s MKBGLastLevel=$lg($g(^User.MKBGlobalD(MKBGRowId)),7)
				s MKBGState=$lg($g(^User.MKBGlobalD(MKBGRowId)),8)
				s MKBGConfirm=$lg($g(^User.MKBGlobalD(MKBGRowId)),9)
				if (confirm'="")
				{
					if (confirm="Y")&(MKBGConfirm'=confirm)
					{
						continue
					}
					if (confirm="N")&(MKBGConfirm'="")
					{
						continue
					}
				}
					
				s MKBGloMark =$lg($g(^User.MKBGlobalD(MKBGRowId)),10)
				s flag=0
				if (MKBGMark="")
				{
					s flag=1
				}
				else
				{
					for m=1:1:$l(MKBGMark,",")
					{
						s mark=$p(MKBGMark,",",m)
						continue:(mark="")
						s:(MKBGloMark[mark) flag=1
						q:flag=1
					}
				}
				continue:flag=0
				
				s MKBGDiaTotalFreq = $lg($g(^User.MKBGlobalD(MKBGRowId)),11)
				s Freq=MKBGDiaTotalFreq
				s:MKBGDiaTotalFreq="" Freq=" "_MKBGDiaTotalFreq
				
				s MKBGAlias=""
				s MKBGDisplaName=""
				s AliasId=0
				for
				{
					s AliasId=$o(^User.MKBGlobalD(MKBGRowId,"ChildGloAlias",AliasId))  //遍历别名表
					q:AliasId=""
					s AliasMark = $lg($g(^User.MKBGlobalD(MKBGRowId,"ChildGloAlias",AliasId)),8)
					s MKBGADesc = $lg($g(^User.MKBGlobalD(MKBGRowId,"ChildGloAlias",AliasId)),2) 
					
				    if (AliasMark["查询名")
				    {
					    if (MKBGAlias="")
						{
							s MKBGAlias=$lg($g(^User.MKBGlobalD(MKBGRowId,"ChildGloAlias",AliasId)),2)   //别名
						}
						else
						{
							s MKBGAlias=MKBGAlias_","_$lg($g(^User.MKBGlobalD(MKBGRowId,"ChildGloAlias",AliasId)),2)   //别名
						}
				    }
				}
				s ShowNameID=$o(^User.MKBGloAliasI("DisplayName",MKBGRowId," Y",""))
				s MKBGDisplaName=""
				s:ShowNameID'="" MKBGDisplaName=$lg($g(^User.MKBGlobalD(MKBGRowId,"ChildGloAlias",ShowNameID)),2)
				s:MKBGDisplaName="" MKBGDisplaName=MKBGDesc
				
				s AliasStr=..GetAliasInfo(MKBGRowId)  //获取别名和别名检索码的拼串
				s AliasDescStr=$p(AliasStr,"||",1)   //别名拼串
				s AliasPYCodeStr=$p(AliasStr,"||",2)   //别名检索码拼串
				if (MKBGState'="U")
				{
					continue
				}
				
				if (Type="SameGlobal")
				{
					s length = $l(desc," ")
			    	for i =1:1:length
			    	{
				    	s samedesc = $p(desc," ",i)
						if (($ZCONVERT(MKBGDesc,"U")=samedesc))
						{
							s MKBGDesc=$lg($g(^User.MKBGlobalD(MKBGRowId)),3)
	
							d OutputRow	
							s ^TmpDataHandle(MKBGRowId)=""
							
						  	s ^TempHandle("Freq",Freq,MKBGRowId)=MKBGRowId	
			                
						}
			   		}
				}
				else
				{
					
					if ($ZCONVERT(MKBGCode,"U")[code)&(($ZCONVERT(MKBGDesc,"U")[desc)||($ZCONVERT(MKBGPYCode,"U")[desc)||($ZCONVERT(AliasDescStr,"U")[desc)||($ZCONVERT(AliasPYCodeStr,"U")[desc))
					{
						s MKBGDesc=$lg($g(^User.MKBGlobalD(MKBGRowId)),3)
						
						d OutputRow	
						s ^TmpDataHandle(MKBGRowId)=""	
					  	s ^TempHandle("Freq",Freq,MKBGRowId)=MKBGRowId	
					}
					
				}
			}
			
				
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(MKBGRowId,MKBGCode,MKBGDesc,MKBGEnName,MKBGNote,MKBGPYCode,MKBGLastLevel,MKBGState,MKBGConfirm,MKBGAlias,MKBGloMark,MKBGDiaTotalFreq,MKBGDisplaName)
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

/// Creator：chendailei
/// CreatDate: 2019-10-12
/// Description：获取全局化词表子表的内容
/// Table：User.MKBGloAlias
/// d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBGlobal","GetAliasList","200559","")
Query GetAliasList(parref As %String, Mark As %String) As %Query(ROWSPEC = "MKBGARowId:%String,MKBGADesc:%String,MKBGAPYCode:%String,MKBGANote:%String,MKBGACEFlag:%String,MKBGASequence:%String,MKBGAMark:%String")
{
}

ClassMethod GetAliasListExecute(ByRef qHandle As %Binary, parref As %String, Mark As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (parref'="")
	{
		s AliasRowId=0
		for
		{
			s AliasRowId=$o(^User.MKBGlobalD(parref,"ChildGloAlias",AliasRowId))    //根据父表ID遍历子表ID
			q:AliasRowId=""
			s MKBGARowId=parref_"||"_AliasRowId       //拼接子表ID
			s MKBGADesc=$lg($g(^User.MKBGlobalD(parref,"ChildGloAlias",AliasRowId)),2)
			s MKBGAPYCode=$lg($g(^User.MKBGlobalD(parref,"ChildGloAlias",AliasRowId)),3)
			s MKBGANote=$lg($g(^User.MKBGlobalD(parref,"ChildGloAlias",AliasRowId)),4)
			s MKBGACEFlag=$lg($g(^User.MKBGlobalD(parref,"ChildGloAlias",AliasRowId)),5)
			s MKBGAState=$lg($g(^User.MKBGlobalD(parref,"ChildGloAlias",AliasRowId)),6)
			s MKBGASequence = $lg($g(^User.MKBGlobalD(parref,"ChildGloAlias",AliasRowId)),7)
			s MKBGAMark = $lg($g(^User.MKBGlobalD(parref,"ChildGloAlias",AliasRowId)),8)
			
			if (MKBGAState="M")
			{
				continue
			}
			if (MKBGAMark["展示名")
			{
				s ^MarkSort(1,AliasRowId)=""
				continue
			}
			elseif(MKBGAMark["临床实用诊断")
			{
				s ^MarkSort(2,AliasRowId)=""
				continue
			}
			elseif(MKBGAMark["常用诊断表达式")
			{
				s ^MarkSort(3,AliasRowId)=""
				continue
			}
			elseif(MKBGAMark["查询名")
			{
				s ^MarkSort(4,AliasRowId)=""
				continue
			}
			elseif(MKBGAMark["ICD诊断")
			{
				s ^MarkSort(5,AliasRowId)=""
				continue
			}
			elseif(MKBGAMark["英文名")
			{
				s ^MarkSort(6,AliasRowId)=""
				continue
			}
			elseif(MKBGAMark["英文简写码")
			{
				s ^MarkSort(7,AliasRowId)=""
				continue
			}
			elseif(MKBGAMark["别名")
			{
				s ^MarkSort(8,AliasRowId)=""
				continue
			}
			elseif(MKBGAMark="业务诊断")
			{
				s ^MarkSort(9,AliasRowId)=""
				continue
			}
			elseif(MKBGAMark="")
			{
				s ^MarkSort(10,AliasRowId)=""
				continue
			}
			else
			{
				s ^MarkSort(11,AliasRowId)=""
				continue
			}
			//if (MKBGACEFlag=CEFlag)
			//{*/	
				//d OutputRow
			//}
		}
		for Sorti=1:1:11
		{
			s AliasRowId = 0
			for
			{
				s AliasRowId = $o(^MarkSort(Sorti,AliasRowId))
				q:AliasRowId=""
				s MKBGARowId=parref_"||"_AliasRowId       //拼接子表ID
				s MKBGADesc=$lg($g(^User.MKBGlobalD(parref,"ChildGloAlias",AliasRowId)),2)
				s MKBGAPYCode=$lg($g(^User.MKBGlobalD(parref,"ChildGloAlias",AliasRowId)),3)
				s MKBGANote=$lg($g(^User.MKBGlobalD(parref,"ChildGloAlias",AliasRowId)),4)
				s MKBGACEFlag=$lg($g(^User.MKBGlobalD(parref,"ChildGloAlias",AliasRowId)),5)
				s MKBGAState=$lg($g(^User.MKBGlobalD(parref,"ChildGloAlias",AliasRowId)),6)
				s MKBGASequence = $lg($g(^User.MKBGlobalD(parref,"ChildGloAlias",AliasRowId)),7)
				s MKBGAMark = $lg($g(^User.MKBGlobalD(parref,"ChildGloAlias",AliasRowId)),8)
				d OutputRow
			} 
		}
	}
	k ^MarkSort
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(MKBGARowId,MKBGADesc,MKBGAPYCode,MKBGANote,MKBGACEFlag,MKBGASequence,MKBGAMark)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetAliasListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAliasListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAliasListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAliasListExecute ]
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

/// Creator：chendailei
/// CreatDate: 2019-10-12
/// Description：获取全局化词表引用表的内容及发起引用者的详细信息
/// Input: GlobalRowId-全局化词表RowID
/// Table：User.MKBGlobalReference
/// d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBGlobal","GetReferenceList","200743","")
Query GetReferenceList(GlobalRowId As %String, BaseID As %String) As %Query(ROWSPEC = "MKBGRRowId:%String,MKBGRCode:%String,MKBGRDesc:%String,MKBGRType:%String,MKBGRLevel:%String,MKBGRPYCode:%String,MKBGRNote:%String,MKBGRLastLevel:%String")
{
}

ClassMethod GetReferenceListExecute(ByRef qHandle As %Binary, GlobalRowId As %String, BaseID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s RefRowId=0
	for
	{
		s RefRowId=$o(^User.MKBGlobalReferenceI("InverAllIndex",GlobalRowId,"T",RefRowId))    //通过索引表获得引用者的ID
		q:RefRowId=""
		s MKBGRRowId=$o(^User.MKBGlobalReferenceI("InverAllIndex",GlobalRowId,"T",RefRowId,0))  //引用表ID
		s MKBGRCode=$lg($g(^User.MKBTermD(RefRowId)),2)
		s MKBGRDesc=$lg($g(^User.MKBTermD(RefRowId)),3)
		s MKBGRType="术语"
		s BaseRowId=$lg($g(^User.MKBTermD(RefRowId)),4)
		s BaseDesc=$lg($g(^User.MKBTermBaseD(BaseRowId)),3)
		if (BaseID '="" && BaseID'=0)
		{
			q:BaseRowId'=BaseID
		}
		s MKBGRLevel=BaseDesc_"."_MKBGRDesc
		
		//显示结构化诊断
		s MKBGRLevel=MKBGRLevel_"  ("_MKBGRDesc_")"
		s MKBGRPYCode=$lg($g(^User.MKBTermD(RefRowId)),6)
		s MKBGRNote=$lg($g(^User.MKBTermD(RefRowId)),7)
		s LastLevel=$lg($g(^User.MKBTermD(RefRowId)),5)
		s MKBGRLastLevel=""
		while (LastLevel'="")
		{
			if (MKBGRLastLevel="")
			{
				s MKBGRLastLevel=$lg($g(^User.MKBTermD(LastLevel)),3)
			}
			else
			{
				s MKBGRLastLevel=$lg($g(^User.MKBTermD(LastLevel)),3)_"--"_MKBGRLastLevel
			}
			s LastLevel=$lg($g(^User.MKBTermD(LastLevel)),5)
			
		}  
		
		d OutputRow
	}
	s RefRowId=0
	for
	{
		
		s RefRowId=$o(^User.MKBGlobalReferenceI("InverAllIndex",GlobalRowId,"D",RefRowId))    //通过索引表获得引用者的ID
		q:RefRowId=""
		s MKBGRRowId = 0
		for{
			
		s MKBGRRowId=$o(^User.MKBGlobalReferenceI("InverAllIndex",GlobalRowId,"D",RefRowId,MKBGRRowId))  //引用表ID
		q:MKBGRRowId=""
		//s dobj=##class(User.MKBTermProDetail).%OpenId(MKBGRRowId)    //根据ID获取属性内容表中内容
		s MKBGRCode=$lg($g(^User.MKBTermProDetailD(RefRowId)),2)
		//s TMPMKBGRDesc=$lg($g(^User.MKBTermProDetailD(RefRowId)),3)
		s PassiveAliasID = $lg($g(^User.MKBGlobalReferenceD(MKBGRRowId)),5)
		s:PassiveAliasID'="" MKBGRDesc=$lg($g(^User.MKBGlobalD(GlobalRowId,"ChildGloAlias",PassiveAliasID)),2)
		s:PassiveAliasID="" MKBGRDesc=$lg($g(^User.MKBGlobalD(GlobalRowId)),3)          //临时改动， 不符合所有情况
		s MKBGRType="属性内容"
		s ProRowId=$lg($g(^User.MKBTermProDetailD(RefRowId)),6)         //属性RowID
		q:ProRowId=""
		//w ProRowId_"AAAAAA",!
		s ProDesc=$lg($g(^User.MKBTermPropertyD(ProRowId)),3)         //属性名
		if (ProDesc = "常用诊断表达式")
		{
			s ProDetailDesc = $lg($g(^User.MKBTermProDetailD(RefRowId)),3)
		}
		s TermRowId=$lg($g(^User.MKBTermPropertyD(ProRowId)),6)     //术语RowID
		s TermDesc=$lg($g(^User.MKBTermD(TermRowId)),3)             //术语描述
		s BaseRowId=$lg($g(^User.MKBTermD(TermRowId)),4)          //知识库RowID
		s BaseDesc=$lg($g(^User.MKBTermBaseD(BaseRowId)),3)        //知识库描述
		if (BaseID '="" && BaseID'=0)
		{
			q:BaseRowId'=BaseID
		}
		if (ProDesc = "常用诊断表达式")
		{
			s MKBGRLevel=BaseDesc_"."_TermDesc_"."_ProDesc_"."_ProDetailDesc
			//显示结构化诊断
			//MKBGRRowId
			S subId=$o(^User.MKBTermPropertyD(ProRowId,"ChildExtPro",""))
			s MKBTEPVValueStr=##class(web.DHCBL.MKB.MKBTermProDetail).GetExtendProValValue(ProRowId,subId,RefRowId)
			s MKBTEPVValue=$p(MKBTEPVValueStr,"[A]",1)
			s MKBTEPVValueF=$p(MKBTEPVValueStr,"[A]",2)
			s MKBGRLevel=MKBGRLevel_"  ("_MKBTEPVValue_")"
			
		}
		else
		{
			s MKBGRLevel=BaseDesc_"."_TermDesc_"."_ProDesc
		}
		s MKBGRPYCode=$lg($g(^User.MKBTermProDetailD(RefRowId)),10)
		s MKBGRNote=$lg($g(^User.MKBTermProDetailD(RefRowId)),7)
		s MKBGRLastLevel=""
		d OutputRow
		}
	}
	s RefRowId=0
	for
	{
		s RefRowId=$o(^User.MKBGlobalReferenceI("InverAllIndex",GlobalRowId,"ICDCon",RefRowId))    //通过索引表获得引用者的ID
		q:RefRowId=""
		s MKBGRRowId=$o(^User.MKBGlobalReferenceI("InverAllIndex",GlobalRowId,"ICDCon",RefRowId,0))  //引用表ID
		//s dobj=##class(User.MKBTermProDetail).%OpenId(MKBGRRowId)    //根据ID获取属性内容表中内容
		s MKBGRCode="" //$lg($g(^User.MKBICDContrastD(RefRowId)),2)
		//s TMPMKBGRDesc=$lg($g(^User.MKBTermProDetailD(RefRowId)),3)
		s MKBGRDesc=$lg($g(^User.MKBICDContrastD(RefRowId)),3)          //临时改动， 不符合所有情况
		s MKBGRType="属性内容"
		s ICDCode = $lg($g(^User.MKBICDContrastD(RefRowId)),4)
		
		
		s MKBGRLevel="各版本ICD对照.("_ICDCode_")"
		s MKBGRPYCode="" //$lg($g(^User.MKBTermProDetailD(RefRowId)),10)
		s MKBGRNote="" //$lg($g(^User.MKBTermProDetailD(RefRowId)),7)
		s MKBGRLastLevel=""
		d OutputRow
	}
	s RefRowId=0
	for
	{
		s RefRowId=$o(^User.MKBGlobalReferenceI("InverAllIndex",GlobalRowId,"ICDSD",RefRowId))    //通过索引表获得引用者的ID
		q:RefRowId=""
		s MKBGRRowId=$o(^User.MKBGlobalReferenceI("InverAllIndex",GlobalRowId,"ICDSD",RefRowId,0))  //引用表ID
		//s dobj=##class(User.MKBTermProDetail).%OpenId(MKBGRRowId)    //根据ID获取属性内容表中内容
		s MKBGRCode="" //$lg($g(^User.MKBICDContrastD(RefRowId)),2)
		//s TMPMKBGRDesc=$lg($g(^User.MKBTermProDetailD(RefRowId)),3)
		s MKBGRDesc=$lg($g(^User.MKBStructuredDataD(RefRowId)),2)          //临时改动， 不符合所有情况
		s MKBGRType="属性内容"
		s ICDCode =$lg($g(^User.MKBStructuredDataD(RefRowId)),20) 
		s MKBSDBaseDr= $lg($g(^User.MKBStructuredDataD(RefRowId)),22)  	//工厂id
		s MKBSTBDesc=""		//工厂描述
		s:MKBSDBaseDr'="" MKBSTBDesc=$LISTGET($G(^User.MKBStructuredBaseD(MKBSDBaseDr)),2)
		s MKBSTBDesc=$p(MKBSTBDesc,"数据处理工厂",1)_"ICD"
		
		s MKBGRLevel=MKBSTBDesc_".("_ICDCode_")"
		s MKBGRPYCode="" //$lg($g(^User.MKBTermProDetailD(RefRowId)),10)
		s MKBGRNote="" //$lg($g(^User.MKBTermProDetailD(RefRowId)),7)
		s MKBGRLastLevel=""
		d OutputRow
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(MKBGRRowId,MKBGRCode,MKBGRDesc,MKBGRType,MKBGRLevel,MKBGRPYCode,MKBGRNote,MKBGRLastLevel)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetReferenceListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetReferenceListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetReferenceListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetReferenceListExecute ]
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

/// Creator：chendailei
/// CreatDate: 2019-10-14
/// Description：根据ID删除别名表的内容
/// Table：User.MKBGloAlias
/// Input：Id：别名子表ID
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// w ##class(web.DHCBL.MKB.MKBGlobal).DeleteAliasData("24||9279")
ClassMethod DeleteAliasData(Id As %String) As %String
{
	s result = ""
	//new Entity对象，用于保存日志
	s eobj = ##class(web.Entity.MKB.MKBGloAlias).%New()
	s eobj.MKBGAParRef=$p(Id,"||",1)
	s eobj.MKBGARowId=$p(Id,"||",2)
	s eobj.MKBGADesc=$lg($g(^User.MKBGlobalD(eobj.MKBGAParRef,"ChildGloAlias",eobj.MKBGARowId)),2)
	s eobj.MKBGAPYCode=$lg($g(^User.MKBGlobalD(eobj.MKBGAParRef,"ChildGloAlias",eobj.MKBGARowId)),3)
	s eobj.MKBGANote=$lg($g(^User.MKBGlobalD(eobj.MKBGAParRef,"ChildGloAlias",eobj.MKBGARowId)),4)
	Tstart
	s sc=##class(User.MKBGloAlias).%DeleteId(Id)
	if $$$ISOK(sc)
	{
		Tcommit
		d ..DelAliasMathRef(eobj.MKBGADesc,eobj.MKBGAParRef)
		//d ..RefHandle("1","1,2",eobj.MKBGAParRef)
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKBGLOBALALIAS","User.MKBGloAlias","全局化词表别名子表",Id,eobj.MKBGADesc,"D",eobj)
		d eobj.%Close()
	}
	else 
	{
		Trollback
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("全局化词表别名子表","web.DHCBL.MKB.MKBGlobal","DeleteAliasData",eobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

/// Creator：chendailei
/// CreatDate: 2019-10-16
/// Description：根据ID删除全局化词表的内容
/// Table：User.MKBGlobal
/// Input：GlobalId:全局化词表ID
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// w ##class(web.DHCBL.MKB.MKBGlobal).DeleteGlobalData("76651")
ClassMethod DeleteGlobalData(GlobalId As %String) As %String
{
	s result = ""
	//new Entity对象，用于保存日志
	s eobj = ##class(web.Entity.MKB.MKBGlobal).%New()
	s eobj.MKBGRowId=GlobalId
	s eobj.MKBGCode=$lg($g(^User.MKBGlobalD(GlobalId)),2)
	s eobj.MKBGDesc=$lg($g(^User.MKBGlobalD(GlobalId)),3)
	s eobj.MKBGEnName=$lg($g(^User.MKBGlobalD(GlobalId)),4)
	s eobj.MKBGNote=$lg($g(^User.MKBGlobalD(GlobalId)),5)
	s eobj.MKBGPYCode=$lg($g(^User.MKBGlobalD(GlobalId)),6)
	s eobj.MKBGLastLevel=$lg($g(^User.MKBGlobalD(GlobalId)),7)
	s eobj.MKBGState=$lg($g(^User.MKBGlobalD(GlobalId)),8)
	Tstart
	s sc=##class(User.MKBGlobal).%DeleteId(GlobalId)
	if $$$ISOK(sc)
	{
		Tcommit
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKBGLOBAL","User.MKBGlobal","全局化词表",GlobalId,eobj.MKBGDesc,"D",eobj)
		d eobj.%Close()
	}
	else 
	{
		Trollback
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("全局化词表","web.DHCBL.MKB.MKBGlobal","DeleteGlobalData",eobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

/// Creator：chendailei
/// CreatDate: 2019-10-16
/// Description：根据ID删除全局化词表引用表的内容
/// Table：User.MKBGlobalReference
/// Input：Id:全局化词表引用表ID
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// w ##class(web.DHCBL.MKB.MKBGlobal).DeleteReferenceData("76651")
ClassMethod DeleteReferenceData(Id As %String) As %String
{
	s result = ""
	//new Entity对象，用于保存日志
	Tstart
	s RefRowId=$lg($g(^User.MKBGlobalReferenceD(Id)),4)
	s sc=##class(User.MKBGlobalReference).%DeleteId(Id)
	if $$$ISOK(sc)
	{
		Tcommit
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		s desc=$lg($g(^User.MKBGlobalD(RefRowId)),3)
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_GlobalReference","User.MKBGlobalReference","全局化词表引用表",Id,desc_"-全局化词表引用","D","")
	}
	else 
	{
		Trollback
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("全局化词表引用表","web.DHCBL.MKB.MKBGlobalReference","DeleteReferenceData","")
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

/// Creator：chendailei
/// CreatDate: 2019-10-17
/// Description：根据传递的全局化词表的RowID串，将对应RowID的数据合并到第一个RowID中（包括别名子表和引用表的合并）
/// Table：User.MKBGlobal User.MKBGloAlias User.MKBGlobalReference
/// Input：RowIdStr 全局化词表RowId拼串，以“,”分隔
/// Return：成功返回"{success:'true',info:'合并成功！'}"；失败返回"{success:'false'和失败原因}
/// w ##class(web.DHCBL.MKB.MKBGlobal).MergeGlobalData("363740,363737,363738")
ClassMethod MergeGlobalData(RowIdStr As %String) As %String
{
	s result=""
	ts
	
	s strlen=$l(RowIdStr,",")
	if (strlen>1)     //判断是否选择两条及以上数据
	{
		s ToRowId=$p(RowIdStr,",",1)
		for i=2:1:strlen
		{
			s FromRowId=$p(RowIdStr,",",i)
			s res=..MergeTwoData(FromRowId,ToRowId)
			
			if (res["false")
			{
				s result=res
				q
			}
		}
		
		s result="{success:'true',info:'合并成功！'}"
		//d ..RefHandle("1","1,2",ToRowId)	 //合并成功之后 对该数据进行一次引用处理
		d ..MergeDiagFreq(RowIdStr)   //合并成功之后 对诊断开立频次进行一次累加
		d ..DoSelfCheckAliasMark(ToRowId)		//检查别名标志是否存在错误
	}
	else
	{
		s result="{success:'false',info:'请检查所选数据是否符合规则！'}"
	}
	if (result'["false")
	{
		tc	
	}
	else
	{
		tro	
	}
	q result
}

/// Creator：chendailei
/// CreatDate: 2019-10-17
/// Description：合并两条数据
/// Table：User.MKBGlobal User.MKBGloAlias User.MKBGlobalReference
/// Input：FromRowId :需要合并的数据ID  ToRowId ：合并到的数据ID
/// Return：成功返回"{success:'true',info:'合并成功！'}"；失败返回"{success:'false'和失败原因}
/// w ##class(web.DHCBL.MKB.MKBGlobal).MergeTwoData("3","1204")
ClassMethod MergeTwoData(FromRowId As %String, ToRowId As %String) As %String
{
	s result=""
	/***************合并子表******************/
	//先行判断合并到的术语的别名中是否有展示名，有则将合并的数据的别名标志修改，若无则将第一个别名改成展示名
	s aliasID=$o(^User.MKBGloAliasI("DisplayName",ToRowId," Y",0))
	if (aliasID="")	//没有展示名，添加展示名
	{
		d ..AddDisplayName(ToRowId)
	}
	
			
	s FARowId=0
	s ars=""
	for 
	{
		s FARowId=$o(^User.MKBGlobalD(FromRowId,"ChildGloAlias",FARowId))  //遍历被合并数据的子表RowID
		q:FARowId=""
		s FADesc=$lg($g(^User.MKBGlobalD(FromRowId,"ChildGloAlias",FARowId)),2) //被合并别名子表描述
		s TARowId=0
		s AFlag=0    //作为别名是否有相同的标志，0为没有，1为有
		for
		{
			s TARowId=$o(^User.MKBGlobalD(ToRowId,"ChildGloAlias",TARowId))  //遍历合并数据的子表RowID，比较别名是否相同，相同跳过，不同添加
			q:TARowId=""
			
			s TADesc=$lg($g(^User.MKBGlobalD(ToRowId,"ChildGloAlias",TARowId)),2) //合并别名子表描述
			if ($Zstrip(TADesc,"<>W")=$Zstrip(FADesc,"<>W"))
			//if (TADesc=FADesc)
			{
				
				s AFlag=1
				q
			}
		}
		if (AFlag=0)      //如果没有相同的别名，则需要增加到合并表中
		{
			s taeobj=##class(web.Entity.MKB.MKBGloAlias).%New()    //新建一个别名表实体类存储需要保存的别名数据
			s taeobj.MKBGAParRef=ToRowId
			s taeobj.MKBGADesc=FADesc
			s taeobj.MKBGAPYCode=$lg($g(^User.MKBGlobalD(FromRowId,"ChildGloAlias",FARowId)),3)
			s taeobj.MKBGANote=$lg($g(^User.MKBGlobalD(FromRowId,"ChildGloAlias",FARowId)),4)
			s taeobj.MKBGACEFlag=$lg($g(^User.MKBGlobalD(FromRowId,"ChildGloAlias",FARowId)),5)
			//s taeobj.MKBGAMark = $lg($g(^User.MKBGlobalD(FromRowId,"ChildGloAlias",FARowId)),8)
			s MKBGMrak = $lg($g(^User.MKBGlobalD(FromRowId,"ChildGloAlias",FARowId)),8)
			s MKBGMrak=##class(web.BDP.util.String).Replace(MKBGMrak,"展示名,","")
			s MKBGMrak=##class(web.BDP.util.String).Replace(MKBGMrak,",展示名","")
			s MKBGMrak=##class(web.BDP.util.String).Replace(MKBGMrak,"展示名","")
			s taeobj.MKBGAMark=	MKBGMrak	
			//s:MKBGMrak="业务诊断" taeobj.MKBGAMark ="业务诊断"
			//s ars=..SaveAliasData(taeobj)  //保存别名
			
			s ars=..SaveAliasEntity(taeobj)
		}

	}
	/***************合并引用表（直接修改被合并数据的被引者用ID为合并数据的ID）******************/
	s InitiativeFlag=""
	for
	{
		s InitiativeFlag=$o(^User.MKBGlobalReferenceI("InverAllIndex",FromRowId,InitiativeFlag))
		q:InitiativeFlag=""
		 
		s InitiativeID=0
		for
		{
			s InitiativeID=$o(^User.MKBGlobalReferenceI("InverAllIndex",FromRowId,InitiativeFlag,InitiativeID))    //通过索引表获得引用者的ID
			q:InitiativeID=""
			
			s RefRowId=""
			for
			{
				s RefRowId=$o(^User.MKBGlobalReferenceI("InverAllIndex",FromRowId,InitiativeFlag,InitiativeID,RefRowId))    //通过索引表获得引用者的ID
				q:RefRowId=""
			
				s PassiveAliasID = $lg($g(^User.MKBGlobalReferenceD(RefRowId)),5)
				s AliasDesc=$lg($g(^User.MKBGlobalD(FromRowId,"ChildGloAlias",PassiveAliasID)),2)
				s newAliasid=$o(^User.MKBGloAliasI("DescIndex",ToRowId," "_$zconvert(AliasDesc,"U"),""))
				if (newAliasid'="")		//别名位置不为空
				{
					s obj = ##class(User.MKBGlobalReference).%OpenId(RefRowId)	//修改引用
								
					s obj.PassiveID = ToRowId
					s obj.PassiveAliasID = newAliasid
					d obj.%Save()
					d obj.%Close()
				}
				else
				{
					//d ##class(web.DHCBL.MKB.MKBGlobal).SelfCheckReference()		//引用检查，给没有别名id的引用增加上
				}
			}
				
		}
	}
	
	s AliasRowId=0		//删除所有别名
	for 	
	{
		s AliasRowId=$o(^User.MKBGlobalD(FromRowId,"ChildGloAlias",AliasRowId))  
		q:AliasRowId=""
		d ..DeleteAliasData(FromRowId_"||"_AliasRowId)
	}
	
	s InitiativeFlag=""		//删除被合并术语的所有引用
	for
	{
		s InitiativeFlag=$o(^User.MKBGlobalReferenceI("InverAllIndex",FromRowId,InitiativeFlag))    //通过索引表获得引用者的ID
		q:InitiativeFlag=""
		s RefRowId=0
		for
		{
			s RefRowId=$o(^User.MKBGlobalReferenceI("InverAllIndex",FromRowId,InitiativeFlag,RefRowId))    //通过索引表获得引用者的ID
			q:RefRowId=""
			s RefenceRowId=$o(^User.MKBGlobalReferenceI("InverAllIndex",FromRowId,InitiativeFlag,RefRowId,0))
			
			d:(RefenceRowId'="") ##class(User.MKBGlobalReference).%DeleteId(RefenceRowId)		//删除引用
			
			
		}
	}
			
	/***************合并全局化词表******************/
	//s tobj=##class(User.MKBGlobal).%OpenId(ToRowId)  //打开合并数据
	/***************合并全局化词表英文名******************/
	s FEnName=$lg($g(^User.MKBGlobalD(FromRowId)),4)
	s ToEnName=""
	if (FEnName'="")	//英文名不为空
	{
		s ToEnName=$lg($g(^User.MKBGlobalD(ToRowId)),4)
		if (ToEnName'=FEnName)	//两英文名不一致
		{
			if (ToEnName="")	//要合并到的英文名为空
			{
				s ToEnName=FEnName
			}
			else
			{
				s ToEnName=TNote_","_FEnName
			}
		}
	}
	/***************合并全局化词表备注******************/
	s FNote=$lg($g(^User.MKBGlobalD(FromRowId)),5)
	s TNote=$lg($g(^User.MKBGlobalD(ToRowId)),5)
	if (FNote'="")		//备注不为空
	{
		if (TNote'=FNote)		//两备注不一致
		{
			if (TNote="")		//要合并到的备注为空
			{
				s TNote=FNote
			}
			else
			{
				s TNote=TNote_","_FNote
			}
		}
	}
	s gsc=..SaveGlobalLog(ToRowId, "", ToEnName,TNote,"", "", "", "")
	
	if (gsc["true")		//修改成功
	//if $$$ISOK(gsc)
	{
		//s fsc=..SaveGlobalLog(FromRowId, "", "","","M", "", "", "")
		s fsc=..DeleteAll(FromRowId)
		if (fsc["true")		//修改成功
		{
			s result="{success:'true',info:'合并成功！'}"
		}
		else
		{
			s result=fsc
		}
	}
	else
	{
		s result="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(gsc)_"""}"   //返回错误信息
	}
	q result
}

/// Creator：范文凯
/// CreatDate: 2019-10-23
/// Description：根据传递的全局化词表ID串修改其MKBGConfirm字段值为true
/// Table：User.MKBGlobal
/// Input：RowIdStr 全局化词表RowId拼串，以“,”分隔
/// Output：成功返回"{success:'true',info:'已确认！'}"；失败返回"{success:'false'和失败原因}
/// w ##class(web.DHCBL.MKB.MKBGlobal).Confirm("1,2,3")
ClassMethod Confirm(RowIdStr As %String) As %String
{
	s result=""
	s strlen=$l(RowIdStr,",")
	if (strlen>=1)                  //判断入参是否选择数据，为空则提示对应信息
	{
		for i=1:1:strlen
		{
			s RowId=$p(RowIdStr,",",i)
			s sc=..SaveGlobalLog(RowId, "", "","","", "Y", "", "")
			
			
			/*
			s obj=##class(User.MKBGlobal).%OpenId(RowId)
			s obj.MKBGConfirm="Y"
			s sc=obj.%Save()
			d obj.%Close()
			*/
			if (sc["false")
			//if '$$$ISOK(sc)
			{
				//s result="{""success"":""false"",""errorinfo"":"""_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"""}"   //返回错误信息
				q
			}
		}
		s result="{success:'true',info:'已确认！'}"
	}
	else
	{
		s result="{success:'false',info:'请检查所选数据是否符合规则！'}"
	}
	q result
}

/// Creator：chendailei
/// CreatDate: 2019-10-23
/// Description：根据传递的全局化词表中心词修改其MKBGConfirm字段值为true
/// Table：User.MKBGlobal
/// Input：desc
/// Return：成功返回"{success:'true',info:'已确认！'}"；失败返回"{success:'false'和失败原因}
/// w ##class(web.DHCBL.MKB.MKBGlobal).ConfirmByDesc("T-细胞淋巴瘤")
ClassMethod ConfirmByDesc(desc As %String) As %String
{
	s result=""
	if (desc'="")     //判断是否选择数据
	{
		s RowId=0    //全局化词表ID
		for
		{
			s RowId=$o(^User.MKBGlobalI("DescIndex"," "_$ZCONVERT(desc,"U"),RowId))    //通过描述索引找到RowID
			q:RowId=""
			
			s sc=..SaveGlobalLog(RowId, "", "","","", "Y", "", "")
			/*
			s obj=##class(User.MKBGlobal).%OpenId(RowId)
			s obj.MKBGConfirm="Y"
			s sc=obj.%Save()
			d obj.%Close()
			*/
			if (sc["false")
			//if '$$$ISOK(sc)
			{
				//s result="{""success"":""false"",""errorinfo"":"""_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"""}"   //返回错误信息
				q
			}
		}
		s result="{success:'true',info:'已确认！'}"
	}
	else
	{
		s result="{success:'false',info:'未选择数据！'}"
	}
	q result
}

/// Creator：chendailei
/// CreatDate: 2019-11-04
/// Description：根据中心词RowID获取其所有的别名和别名检索码：别名1，别名2，...||检索码1，检索码2，...
/// Table：User.MKBGloAlias
/// Input：id：中心词RowID
/// Return：别名1，别名2，...||检索码1，检索码2，...
/// w ##class(web.DHCBL.MKB.MKBGlobal).GetAliasInfo("8090")
ClassMethod GetAliasInfo(id As %String) As %String
{
	s AliasId=0
	s DescStr=""
	s PYCodeStr=""
	for
	{
		s AliasId=$o(^User.MKBGlobalD(id,"ChildGloAlias",AliasId))  //遍历别名表
		q:AliasId=""
		s Desc=$lg($g(^User.MKBGlobalD(id,"ChildGloAlias",AliasId)),2)   //别名
		s PYCode=$lg($g(^User.MKBGlobalD(id,"ChildGloAlias",AliasId)),3)    //别名检索码
		if (DescStr="")
		{
			s DescStr=Desc
		}
		else
		{
			s DescStr=DescStr_","_Desc
		}
		if (PYCodeStr="")
		{
			s PYCodeStr=PYCode
		}
		else
		{
			s PYCodeStr=PYCodeStr_","_PYCode
		}
	}
	q DescStr_"||"_PYCodeStr
}

/// Creator: 陈代雷
/// CreatDate: 2019-11-18
/// Description:根据Base和属性名将数据导入全局化词表引用表中 
/// Table: User.MKBGlobal User.MKBGloAlias
/// Input:Base：知识库ID  property：属性名
/// Return:
/// w ##class(web.DHCBL.MKB.MKBGlobal).ImportPropertyDetail(5,"部位")
ClassMethod ImportPropertyDetail(Base As %String, property As %String)
{
	TS
	s ErrorInfo=""
	s TermRowId=0
	for
	{
		s TermRowId=$o(^User.MKBTermI("BaseIndex",Base,TermRowId))  //根据知识库ID取一条术语ID
		;w TermRowId,!
		q:TermRowId=""
		///导入术语下的属性
		//TS
		s TermProRowId=0
		for
		{
			s TermProRowId=$o(^User.MKBTermPropertyI("TermIndex",TermRowId,TermProRowId))
			q:TermProRowId=""
			s TermProType=$lg($g(^User.MKBTermPropertyD(TermProRowId)),4)
			s TermProDesc=$lg($g(^User.MKBTermPropertyD(TermProRowId)),3)  //属性名
			//w "Type"_TermProType,!
			//b
			if (TermProDesc=property)      //判断属性名是否为部位
			{
				w "OKOKOK",!
				s pobj = ##class(web.Entity.MKB.MKBGlobal).%New()
				///保存属性内容到引用表中
				s TermProDRowId=$o(^User.MKBTermProDetailI("ProIdx",TermProRowId,0))
				continue:TermProDRowId=""
				//s pobj.MKBGCode=$lg($g(^User.MKBTermProDetailD(TermProDRowId)),2)    //属性内容代码
				s MKBTPDDesc=$lg($g(^User.MKBTermProDetailD(TermProDRowId)),3)    //属性内容描述
				continue:MKBTPDDesc=""
				w MKBTPDDesc_"--MKBTPDDesc",!
				s GlobalRowId=$o(^User.MKBGlobalReferenceI("AllIndex","T",MKBTPDDesc,0))  //获取对应全局化词表中的ID
				continue:GlobalRowId=""
				s ReferenceDrs=##class(web.DHCBL.MKB.MKBGlobalReference).SaveData("A",GlobalRowId,"D",TermProDRowId)
				if (ReferenceDrs["error")
				{
					s ErrorInfo=ErrorInfo_"ProDetailReference:"_TermProDRowId_"数据导入失败 "
				}
			}
			else
			{
				continue
			}
		}
	}
	if (ErrorInfo="")
	{
		s ErrorInfo="数据导入成功！"
	}
	q ErrorInfo
}

/// Creator:chendailei
/// CreatDate:2019-11-19
/// Input： ParRef ：别名子表的父表ID
/// Output: 最大顺序下一个
/// Description:顺序自动生成  获取顺序最大值
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).GetLastSequence(5)
ClassMethod GetLastSequence(ParRef) As %String
{
  	s LastSequence=0
  	s Sequence=$o(^User.MKBGloAliasI("SeqIndex",ParRef,""),-1)
  	s LastSequence=$g(Sequence)+1
  	
	q LastSequence
}

/// Creator: 陈代雷
/// CreatDate: 2019-11-19
/// Description:根据所传RowID将对应别名设为展示名（即将其顺序设为1） 
/// Table: User.MKBGloAlias
/// Input: id：别名ID 
/// Return:
/// w ##class(web.DHCBL.MKB.MKBGlobal).PromoteSeqToFirst("7995||13363")
ClassMethod PromoteSeqToFirst(id As %String)
{
	s result=""
	s par=$p(id,"||",1)
	s aliasID=$p(id,"||",2)
	s sequence = $lg($g(^User.MKBGlobalD(par,"ChildGloAlias",aliasID)),7)
	s MKBGAMark = $lg($g(^User.MKBGlobalD(par,"ChildGloAlias",aliasID)),8)
	
	s re2=""
	//先把原先的展示名改了
	s FirstRowId=""
	for
	{
		s FirstRowId=$o(^User.MKBGloAliasI("DisplayName",par," Y",FirstRowId))	//展示名的id
		q:FirstRowId=""
		s FMKBGAMark = $lg($g(^User.MKBGlobalD(par,"ChildGloAlias",FirstRowId)),8)
		s FMKBGAMark=$Replace(FMKBGAMark,"展示名,","")
		s FMKBGAMark=$Replace(FMKBGAMark,",展示名","")
		s FMKBGAMark=$Replace(FMKBGAMark,"展示名","")
		s re2=##class(web.DHCBL.MKB.MKBGlobal).SaveAliasLog(par, FirstRowId, "", "", "", "", sequence, FMKBGAMark, "")
	}
	
	//然后将现在的别名设为展示名
	
	s:MKBGAMark'["展示名" MKBGAMark=MKBGAMark_",展示名"
	//parref, AliasRowId, desc, note, activeflag, state, seq, mark, display
	s re1= ##class(web.DHCBL.MKB.MKBGlobal).SaveAliasLog(par, aliasID, "", "", "", "", 1, MKBGAMark, "Y")
	
	
	if ((re1'["false")&&(re2'["false"))
	{
		s rq= ..KeepSameDesc(par)
		s result="true"	
	}
	else
	{
		s result="false"	
	}
	q result
}

/// 范文凯
/// 12.18 全局化词表导入 知识库名、公有属性名、中心词、私有属性名
/// w ##class(web.DHCBL.MKB.MKBGlobal).ImportDataToMKBG()
ClassMethod ImportDataToMKBG()
{
	Ts
	s TermBaseID = 0
	for
	{
		//导入已有知识库名称
		s TermBaseID = $o(^User.MKBTermBaseD(TermBaseID))               //遍历知识库表 MKB_TermBase 
		q:TermBaseID=""
		s tbobj = ##class(web.Entity.MKB.MKBGlobal).%New()
		s tbobj.MKBGDesc= $lg($g(^User.MKBTermBaseD(TermBaseID)),3)     //获得知识库名称描述 MKBTBDesc
		s tbobj.MKBGPYCode=$lg($g(^User.MKBTermD(TermBaseID)),7)        //术语拼音码
		s tbobj.MKBGNote=$lg($g(^User.MKBTermD(TermBaseID)),8)          //术语备注
		s Termrs=..SaveGlobalEntity(tbobj)                              //保存已有知识库名称到全局化词表中
		s Termsc=Termrs["true"
		if $$$ISOK(Termsc)
		{
			s json=##class(web.DHCBL.MKB.SDSCommonFromJson).%New()
			s jsontmp= json.%FromJSON(Termrs)
			s RowId=json.%Get("id")
			s Referencers=##class(web.DHCBL.MKB.MKBGlobalReference).SaveData("A",RowId,"TB",TermBaseID)    //保存引用表
			//b
			if (Referencers["error")
			{
				s ErrorInfo=ErrorInfo_"TermReference:"_TermBaseID_"数据导入失败 "
			}
		}
		else
		{
			s ErrorInfo=ErrorInfo_"Term:"_TermBaseID_"数据导入失败 "
		}
		//导入术语中心词
		s ImpTermRs = ..ImportDataByBase(TermBaseID)
		if (ImpTermRS'="数据导入成功！")
		{
			s ErrorInfo=ErrorInfo_"TermReference:"_TermBaseID_"术语数据导入失败 "
		}
		//导入知识库公有属性
		s MKBTBPRowID = 0
		for
		{
			s MKBTBPRowID = $o(^User.MKBTermBasePropertyI("TermBaseIdx",TermBaseID,MKBTBPRowID))
			q:MKBTBPRowID=""
			s tbpobj = ##class(web.Entity.MKB.MKBGlobal).%New()
			s tbpobj.MKBGDesc= $lg($g(^User.MKBTermBasePropertyD(MKBTBPRowID)),3)     //获得公有属性描述 
			s tbpobj.MKBGPYCode=$lg($g(^User.MKBTermBasePropertyD(MKBTBPRowID)),12)        //公有属性拼音码
			s tbpobj.MKBGNote=$lg($g(^User.MKBTermBaseD(TermBaseID)),3)_"->公有属性"        //公有属性备注 不存在改字段，由TermBaseDesc_"公有属性"
 			s Termrs=..SaveGlobalEntity(tbpobj)                              //保存已有知识库名称到全局化词表中
			s Termsc=Termrs["true"
			if $$$ISOK(Termsc)
			{
				s json=##class(web.DHCBL.MKB.SDSCommonFromJson).%New()
				s jsontmp= json.%FromJSON(Termrs)
				s RowId=json.%Get("id")
				s Referencers=##class(web.DHCBL.MKB.MKBGlobalReference).SaveData("A",RowId,"PTP",MKBTBPRowID)    //保存引用表
				if (Referencers["error")
				{
					s ErrorInfo=ErrorInfo_"TermReference:"_TermBaseID_"公有属性数据导入失败 "
				}
			}
			else
			{
				s ErrorInfo=ErrorInfo_"Term:"_TermBaseID_"公有属性数据导入失败 "
			}
		}
		//导入知识库私有属性
		s TermRowID = 0
		for
		{
			s TermRowID = $o(^User.MKBTermI("BaseIndex",TermBaseID,TermRowID))
			q:TermRowID=""
			s TermProID = 0
			for
			{
				s TermProID = $o(^User.MKBTermPropertyI("TermIndex",TermRowID,TermProID))
				q:TermProID=""
				s MKBTPPublic=$lg($g(^User.MKBTermPropertyD(TermProID)),9)         //判断是否是公有属性
				q:MKBTPPublic="Y"                                                  //是公有属性则跳出
				s tpobj = ##class(web.Entity.MKB.MKBGlobal).%New()
				s tpobj.MKBGDesc= $lg($g(^User.MKBTermPropertyD(MKBTBPRowID)),3)     //获得私有属性描述 
				s tpobj.MKBGPYCode=$lg($g(^User.MKBTermPropertyD(MKBTBPRowID)),12)        //私有属性拼音码
				s tpobj.MKBGNote=$lg($g(^User.MKBTermBaseD(TermBaseID)),3)_"->"_$lg($g(^User.MKBTermD(TermRowID)),3)_"->私有属性"        //私有属性备注 不存在改字段，由TermBaseDesc_"公有属性"
 				s Termrs=..SaveGlobalEntity(tpobj)                              //保存已有知识库名称到全局化词表中
				s Termsc=Termrs["true"
				if $$$ISOK(Termsc)
				{
					s json=##class(web.DHCBL.MKB.SDSCommonFromJson).%New()
					s jsontmp= json.%FromJSON(Termrs)
					s RowId=json.%Get("id")
					s Referencers=##class(web.DHCBL.MKB.MKBGlobalReference).SaveData("A",RowId,"NPTP",TermProID)    //保存引用表
					if (Referencers["error")
					{
						s ErrorInfo=ErrorInfo_"TermReference:"_TermBaseID_"私有属性数据导入失败 "
					}
				}
				else
				{
					s ErrorInfo=ErrorInfo_"Term:"_TermBaseID_"私有属性数据导入失败 "
				}
			}	
		}
	}
	if (ErrorInfo="")
	{
		s ErrorInfo="数据导入成功！"
	}
	q ErrorInfo
}

/// 导入知识库名称
/// w ##class(web.DHCBL.MKB.MKBGlobal).ImportTermBaseDesc()
ClassMethod ImportTermBaseDesc()
{
	Ts
	s TermBaseID = 0
	s ErrorInfo =""
	for
	{
		//导入已有知识库名称
		s TermBaseID = $o(^User.MKBTermBaseD(TermBaseID))               //遍历知识库表 MKB_TermBase 
		q:TermBaseID=""
		s tbobj = ##class(web.Entity.MKB.MKBGlobal).%New()
		s tbobj.MKBGDesc= $lg($g(^User.MKBTermBaseD(TermBaseID)),3)     //获得知识库名称描述 MKBTBDesc
		s tbobj.MKBGPYCode=$lg($g(^User.MKBTermD(TermBaseID)),7)        //术语拼音码
		s tbobj.MKBGNote=$lg($g(^User.MKBTermD(TermBaseID)),8)          //术语备注
		s Termrs=..SaveGlobalEntity(tbobj)                              //保存已有知识库名称到全局化词表中
		s Termsc=Termrs["true"
		if $$$ISOK(Termsc)
		{
			s json=##class(web.DHCBL.MKB.SDSCommonFromJson).%New()
			s jsontmp= json.%FromJSON(Termrs)
			s RowId=json.%Get("id")
			s Referencers=##class(web.DHCBL.MKB.MKBGlobalReference).SaveData("A",RowId,"TB",TermBaseID)    //保存引用表
			//b
			if (Referencers["error")
			{
				s ErrorInfo=ErrorInfo_"TermReference:"_TermBaseID_"数据导入失败 "
			}
		}
		else
		{
			s ErrorInfo=ErrorInfo_"Term:"_TermBaseID_"数据导入失败 "
		}
	}
	if (ErrorInfo="")
	{
		s ErrorInfo="数据导入成功！"
	}
	q ErrorInfo
}

/// 导入中心词
/// w ##class(web.DHCBL.MKB.MKBGlobal).ImportTermDesc()
ClassMethod ImportTermDesc()
{
	Ts
	s TermBaseID = 0
	s ErrorInfo =""
	for
	{
		//导入已有知识库名称
		s TermBaseID = $o(^User.MKBTermBaseD(TermBaseID))               //遍历知识库表 MKB_TermBase 
		q:TermBaseID=""
		if (TermBaseID="6")
		{
			d ..ImportDataByBase(TermBaseID)
			tc
		}
		continue:TermBaseID="6"
		s TermRowId=0
		for
		{
			s TermRowId=$o(^User.MKBTermI("BaseIndex",TermBaseID,TermRowId))  //根据知识库ID取一条术语ID
			//w TermRowId,!
			q:TermRowId=""
			//b
			s eobj = ##class(web.Entity.MKB.MKBGlobal).%New()
			///保存该术语下的内容和属性内容
			//s eobj.MKBGCode=$lg($g(^User.MKBTermD(TermRowId)),2)    //术语代码
			s eobj.MKBGDesc=$lg($g(^User.MKBTermD(TermRowId)),3)    //术语描述
			//w eobj.MKBGDesc,!
			s eobj.MKBGPYCode=$lg($g(^User.MKBTermD(TermRowId)),6)    //术语拼音码
			s eobj.MKBGNote=$lg($g(^User.MKBTermD(TermRowId)),7)    //术语备注
			s Termrs=..SaveGlobalEntity(eobj)   //保存术语到全局化词表中
			s Termsc=Termrs["true"
			if $$$ISOK(Termsc)
			{
				s json=##class(web.DHCBL.MKB.SDSCommonFromJson).%New()
				s jsontmp= json.%FromJSON(Termrs)
				s RowId=json.%Get("id")
				s Referencers=##class(web.DHCBL.MKB.MKBGlobalReference).SaveData("A",RowId,"T",TermRowId)    //保存引用表
				if (Referencers["error")
				{
					s ErrorInfo=ErrorInfo_"TermReference:"_TermRowId_"数据导入失败 "
				}
			}
			else
			{
				s ErrorInfo=ErrorInfo_"Term:"_TermRowId_"数据导入失败 "
			}
		}
	}
	q "yes"
}

/// 导入公有属性
/// w ##class(web.DHCBL.MKB.MKBGlobal).ImpPublicPro()
ClassMethod ImpPublicPro()
{
	Ts
	s TermBaseID = 0
	s ErrorInfo =""
	for
	{
		//导入已有知识库名称
		s TermBaseID = $o(^User.MKBTermBaseD(TermBaseID))               //遍历知识库表 MKB_TermBase 
		q:TermBaseID=""
		s MKBTBPRowID = 0
		for
		{
			s MKBTBPRowID = $o(^User.MKBTermBasePropertyI("TermBaseIdx",TermBaseID,MKBTBPRowID))
			q:MKBTBPRowID=""
			s tbpobj = ##class(web.Entity.MKB.MKBGlobal).%New()
			s tbpobj.MKBGDesc= $lg($g(^User.MKBTermBasePropertyD(MKBTBPRowID)),3)     //获得公有属性描述 
			s tbpobj.MKBGPYCode=$lg($g(^User.MKBTermBasePropertyD(MKBTBPRowID)),12)        //公有属性拼音码
			s tbpobj.MKBGNote=$lg($g(^User.MKBTermBaseD(TermBaseID)),3)_"->公有属性"        //公有属性备注 不存在改字段，由TermBaseDesc_"公有属性"
 			s Termrs=..SaveGlobalEntity(tbpobj)                              //保存已有知识库名称到全局化词表中
			s Termsc=Termrs["true"
			if $$$ISOK(Termsc)
			{
				s json=##class(web.DHCBL.MKB.SDSCommonFromJson).%New()
				s jsontmp= json.%FromJSON(Termrs)
				s RowId=json.%Get("id")
				s Referencers=##class(web.DHCBL.MKB.MKBGlobalReference).SaveData("A",RowId,"PTP",MKBTBPRowID)    //保存引用表
				if (Referencers["error")
				{
					s ErrorInfo=ErrorInfo_"TermReference:"_TermBaseID_"公有属性数据导入失败 "
				}
			}
			else
			{
				s ErrorInfo=ErrorInfo_"Term:"_TermBaseID_"公有属性数据导入失败 "
			}
		}
	}
	q "yes"
}

/// 导入私有属性
/// w ##class(web.DHCBL.MKB.MKBGlobal).ImpNPublicPro()
ClassMethod ImpNPublicPro()
{
	Ts
	s num = 0
	s TermBaseID = 0
	s ErrorInfo =""
	for
	{
		//导入已有知识库名称
		s TermBaseID = $o(^User.MKBTermBaseD(TermBaseID))               //遍历知识库表 MKB_TermBase 
		q:TermBaseID=""
		s TermRowID= 0
		for
		{
			s TermRowID = $o(^User.MKBTermI("BaseIndex",TermBaseID,TermRowID))
			q:TermRowID=""
			s TermProID = 0
			for
			{
				s TermProID = $o(^User.MKBTermPropertyI("TermIndex",TermRowID,TermProID))
				q:TermProID=""
				s MKBTPPublic=$lg($g(^User.MKBTermPropertyD(TermProID)),9)         //判断是否是公有属性
				continue:MKBTPPublic="Y"                                                  //是公有属性则跳出
				s tpobj = ##class(web.Entity.MKB.MKBGlobal).%New()
				s tpobj.MKBGDesc= $lg($g(^User.MKBTermPropertyD(TermProID)),3)     //获得私有属性描述 
				s tpobj.MKBGPYCode=$lg($g(^User.MKBTermPropertyD(TermProID)),12)        //私有属性拼音码
				s tpobj.MKBGNote=$lg($g(^User.MKBTermBaseD(TermBaseID)),3)_"->"_$lg($g(^User.MKBTermD(TermRowID)),3)_"->私有属性"        //私有属性备注 不存在改字段，由TermBaseDesc_"公有属性"
 				s Termrs=..SaveGlobalEntity(tpobj)                              //保存已有知识库名称到全局化词表中
				s Termsc=Termrs["true"
				if $$$ISOK(Termsc)
				{
					s num = num+1
					s json=##class(web.DHCBL.MKB.SDSCommonFromJson).%New()
					s jsontmp= json.%FromJSON(Termrs)
					s RowId=json.%Get("id")
					s Referencers=##class(web.DHCBL.MKB.MKBGlobalReference).SaveData("A",RowId,"NPTP",TermProID)    //保存引用表
					if (Referencers["error")
					{
						s ErrorInfo=ErrorInfo_"TermReference:"_TermBaseID_"私有属性数据导入失败 "
					}
				}
				else
				{
					s ErrorInfo=ErrorInfo_"Term:"_TermBaseID_"私有属性数据导入失败 "
				}
			}	
		}
	}
	q "yes"_num
}

/// Creator：范文凯
/// CreatDate: 2020-02-25
/// Description：全局化词表导入从生到死的诊断
/// Table：User.MKBBirthToDeadDia
/// Input：GlobalId:全局化词表ID
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// w ##class(web.DHCBL.MKB.MKBGlobal).ImportBTDDiag()
ClassMethod ImportBTDDiag()
{
	TS
	s num =0
	s BTDid = 0
	for
	{
		s BTDid = $o(^User.MKBBirthToDeadDiaD(BTDid))
		q:BTDid=1000
		s Diagdesc = $lg($g(^User.MKBBirthToDeadDiaD(BTDid)),3)               //获得诊断
		//获得诊断之后，要判断诊断是否存在  利用 DescIndex 这个索引去判断 
		//if $d(^User.MKBGlobalI("DescIndex"," "_Diagdesc))         //该诊断已经存在 去诊断和科室关联表中获取数据
		if $d(^User.MKBGloAliasI("NameIndex"," "_Diagdesc))
		{
			s MKBGID = $o(^User.MKBGloAliasI("NameIndex"," "_Diagdesc,0))
			s BTDLoc =0
			for
			{
				s BTDLoc = $o(^User.MKBBirthToDeadDiaLocI("LocIndex",BTDid,BTDLoc))
				if (BTDLoc="")
				{
					d ..AddOtherLoc(MKBGID)
				}
				// 如果为空，说明该诊断没有对应上专业科室，需把频次累加到其他科室(暂加到其他临床科室)
				q:BTDLoc=""
				if $d(^User.MKBGDiagLocI("ProfDeptDRIndex",MKBGID,BTDLoc))
				{
					s MKBGDiagLocID = $o(^User.MKBGDiagLocI("ProfDeptDRIndex",MKBGID,BTDLoc,0))
					s obj = ##class(User.MKBGDiagLoc).%OpenId(MKBGDiagLocID)
					s obj.Frequency = obj.Frequency+1
					d obj.%Save()
					d obj.%Close()
				}
				else           //该科室目前不存在
				{
					s obj = ##class(User.MKBGDiagLoc).%New()
					d obj.DiaDRSetObjectId(MKBGID)
			        d obj.ProfDeptDRSetObjectId(BTDLoc)
			        s obj.Frequency=1
			        d obj.%Save()
					d obj.%Close()
					s num=num+1
				}
			}
			
		}
		else   // 不存在的情况  说明诊断描述未与全局化词表已有名称列表匹配  这是要去匹配结构化诊断表达式 去和引用场景去做匹配
		{
			w Diagdesc,!
			s BTDLoc =0
			s obj = ##class(web.Entity.MKB.MKBGlobal).%New()
			s obj.MKBGDesc = Diagdesc
			s obj.MKBGMark="业务诊断"
			s sc = ..SaveGlobalData(obj)
			//s sc = obj.%Save()
			//s id = obj.%Id()
			d obj.%Close()
			if (sc["success")
			{
				s MKBGID = $o(^User.MKBGlobalD(" "),-1)
			}
			for
			{
				s BTDLoc = $o(^User.MKBBirthToDeadDiaLocI("LocIndex",BTDid,BTDLoc))
				if (BTDLoc="")
				{
					d ..AddOtherLoc(MKBGID)
				}
				q:BTDLoc=""
				if $d(^User.MKBGDiagLocI("ProfDeptDRIndex",MKBGID,BTDLoc))
				{
					s MKBGDiagLocID = $o(^User.MKBGDiagLocI("ProfDeptDRIndex",MKBGID,BTDLoc,0))
					s obj = ##class(User.MKBGDiagLoc).%OpenId(MKBGDiagLocID)
					s obj.Frequency = obj.Frequency+1
					d obj.%Save()
					d obj.%Close()
				}
				else           //该科室目前不存在
				{
					s obj = ##class(User.MKBGDiagLoc).%New()
					d obj.DiaDRSetObjectId(MKBGID)
			        d obj.ProfDeptDRSetObjectId(BTDLoc)
			        s obj.Frequency=1
			        d obj.%Save()
					d obj.%Close()
					//s num=num+1
				}
			    /*If (sc["success")
			    {
				    s id = $o(^User.MKBGlobalD(" "),-1)
			        s eobj = ##class(User.MKBGDiagLoc).%New()
			        d eobj.DiaDRSetObjectId(id)
			        d eobj.ProfDeptDRSetObjectId(BTDLoc)
			        s eobj.Frequency=1
			        d eobj.%Save()
			        d eobj.%Close()
			        //s num=num+1
			    }*/
			}
			
		}
		
	}
	w num
	q "yes"
}

/// Creator：范文凯
/// CreatDate: 2020-03-17
/// Description：诊断无对应专业科室 需添加到其他科室累加频次
/// Table：User.MKBBirthToDeadDia
/// Input：GlobalId:全局化词表ID
/// Return：
/// w ##class(web.DHCBL.MKB.MKBGlobal).BTDMatchSDResult()
ClassMethod BTDMatchSDResult(BTDid As %String)
{
	s BTDSDResult = $lg($g(^User.MKBBirthToDeadDiaD(BTDid)),10)   //获得结构化结构id串 
	q:BTDSDResult=""                                              //不存在结构化结果则退出
	s TermDr = $p(BTDSDResult,"^",1)
	s ResultStr = $p(BTDSDResult,"^",2)          
	if (TermDr'="")&&(ResultStr="")       //结构化表达式只有一个TermDR
	{
		if $d(^User.MKBGlobalReferenceI("AllIndex","T",TermDr))     //表达式匹配 但名称不存在全局化词表中 需要把该诊断描述新增到GlobalID下的别名表
		{
			s MKBGlobalID  = $o(^User.MKBGlobalReferenceI("AllIndex","T",TermDr,0))     //取到GlobalID 把该描述 存入到别名表里
			s BTDDesc = $lg($g(^User.MKBBirthToDeadDiaD(BTDid)),3)  
			
			s obj = ##class(User.MKBGloAlias).%New()
			d obj.ParRefSetObjectId(MKBGlobalID)
			s obj.MKBGADesc = BTDDesc
			s obj.MKBGAMark = "别名"
			s obj.MKBGAPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE($ZCONVERT(eobj.BTDDesc,"U"))
			s obj.MKBGASequence=..GetLastSequence(MKBGlobalID)
			d obj.%Save()
			d obj.%Close()
		}
	}
}

/// Creator：范文凯
/// CreatDate: 2020-03-17
/// Description：诊断无对应专业科室 需添加到其他科室累加频次
/// Table：User.MKBBirthToDeadDia
/// Input：GlobalId:全局化词表ID
/// Return：
/// w ##class(web.DHCBL.MKB.MKBGlobal).AddOtherLoc()
ClassMethod AddOtherLoc(MKBGID As %String)
{
	s BTDLoc = 166631
	if $d(^User.MKBGDiagLocI("ProfDeptDRIndex",MKBGID,BTDLoc))    //如果其他科室已经存在  166631为本地其他临床科室的MKBTermID
	{
		s MKBGDiagLocID = $o(^User.MKBGDiagLocI("ProfDeptDRIndex",MKBGID,BTDLoc,0))
	    s obj = ##class(User.MKBGDiagLoc).%OpenId(MKBGDiagLocID)
		s obj.Frequency = obj.Frequency+1
		d obj.%Save()
		d obj.%Close()
	}
	else           //该科室目前不存在
	{
		s obj = ##class(User.MKBGDiagLoc).%New()
		d obj.DiaDRSetObjectId(MKBGID)
		d obj.ProfDeptDRSetObjectId(BTDLoc)
		s obj.Frequency=1
		d obj.%Save()
		d obj.%Close()
	}
	q ""
}

/// Creator：范文凯
/// CreatDate: 2020-02-26
/// Description：增加虚拟测试数据
/// Table：User.MKBBirthToDeadDia
/// Input：GlobalId:全局化词表ID
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// w ##class(web.DHCBL.MKB.MKBGlobal).DoFalseData()
ClassMethod DoFalseData()
{
	Ts
	s BTDid = 0
	s num = 0
	for
	{
		s BTDid = $o(^User.MKBBirthToDeadDiaD(BTDid))
		q:BTDid=100
		s obj=##class(User.MKBBirthToDeadDiaLoc).%New()
		d obj.DiaDRSetObjectId(BTDid)
		s obj.ActualDeptDesc = "范文凯测试科室"
		if (num<30)
		{
		   d obj.ProfDeptDRSetObjectId(17213)
		}
		if (num>29)&&(num<60)
		{
		   d obj.ProfDeptDRSetObjectId(17214)
		}
		if (num>59)&&(num<100)
		{
		   d obj.ProfDeptDRSetObjectId(17215)
		}
	    s sc = obj.%Save()
	    d obj.%Close()
	    s num = num+1
	}
	q "yes"
}

/// Creator：范文凯
/// CreatDate: 2020-02-28
/// Description：入参GlobalID 返回对应的科室频次
/// Table：User.MKBBirthToDeadDia
/// Input：GlobalId:全局化词表ID
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBGlobal","GetLocFreq","1429")
Query GetLocFreq(GlobalID As %String) As %Query(ROWSPEC = "MKBGLFRowId,LocName,LocFreq")
{
}

ClassMethod GetLocFreqExecute(ByRef qHandle As %Binary, GlobalID As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	// 在全局化词表中查找
 	s MKBGLFRowId = 0
 	for
 	{
	 	s MKBGLFRowId = $o(^User.MKBGDiagLocI("DiaDRIndex",GlobalID,MKBGLFRowId))
	 	q:MKBGLFRowId=""
	 	s LocDR = $lg($g(^User.MKBGDiagLocD(MKBGLFRowId)),3)
	 	s LocName = $lg($g(^User.MKBTermD(LocDR)),3)
	 	s LocFreq =$lg($g(^User.MKBGDiagLocD(MKBGLFRowId)),4) 
	 	d OutputRow8
	}
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(MKBGLFRowId,LocName,LocFreq)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetLocFreqFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCTPMExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetLocFreqClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocFreqExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator: 钟荣枫
/// CreatDate: 2020-08-4
/// Description:在全局化词表中获取完全匹配的项的id
/// Table: User.MKBGlobal User.MKBGloAlias
/// Input:desc 描述
/// Return:matchGlobalID  匹配的术语id
/// w ##class(web.DHCBL.MKB.MKBGlobal).GetCompMatch("肺癌")
ClassMethod GetCompMatch(desc)
{
	
	s MKBGRowId=$o(^User.MKBGlobalI("DescIndex"," "_$ZCONVERT(desc,"U"),0))
	s matchGlobalID=""
	if (MKBGRowId="")
	{
		for
		{
			s MKBGRowId=$o(^User.MKBGlobalD(MKBGRowId))  //遍历别名表
			q:MKBGRowId=""
			s AliasId=""
			for
			{
				s AliasId=$o(^User.MKBGlobalD(MKBGRowId,"ChildGloAlias",AliasId))  //遍历别名表
				q:AliasId=""
				s AliasMark = $lg($g(^User.MKBGlobalD(MKBGRowId,"ChildGloAlias",AliasId)),8)
				s MKBGADesc = $lg($g(^User.MKBGlobalD(MKBGRowId,"ChildGloAlias",AliasId)),2) 
				continue:(MKBGADesc'=desc)
				s matchflag=1
				s matchGlobalID=MKBGRowId
			}
		}
	}
	else	//完全匹配的全局化词表ID
	{
		s matchflag=1
		s matchGlobalID=MKBGRowId
	}
	q matchGlobalID
}

/// Creator: 钟荣枫
/// CreatDate: 2020-08-4
/// Description:将临床实用诊断的数据导入到全局化词表中 
/// Table: User.MKBGlobal User.MKBGloAlias
/// Input:
/// Return:
/// w ##class(web.DHCBL.MKB.MKBGlobal).ImportDataByTerm()
ClassMethod ImportDataByTerm()
{
	s count=0
	s maincount=0	//全局化词表
	s aliacount=0	//别名
	s unmaincount=0
	s unaliacount=0
	s unrefcount=0	//引用
	
	s TermRowId=0
	for
	{
		s TermRowId=$o(^User.MKBTermI("BaseIndex",5,TermRowId))  //根据知识库ID取一条术语ID
		q:TermRowId=""
		s count=count+1
		s RowId=""
		s MKBGDesc=$lg($g(^User.MKBTermD(TermRowId)),3)    //术语描述
		s MKBGDesc=$Replace(MKBGDesc," ","")
		
		s MKBGRowId=..GetCompMatch(MKBGDesc)		//全局化词表id
		
		if (MKBGRowId'="")	//修改
		{
			
			s MKBGMark =$lg($g(^User.MKBGlobalD(MKBGRowId)),10)
			
			//s obj=##class(User.MKBGlobal).%OpenId(MKBGRowId)
			if (MKBGMark="")
			{
				s MKBGMark="临床实用诊断"
				
			}
			elseif (MKBGMark'["临床实用诊断")
			{
				s MKBGMark=MKBGMark_",临床实用诊断"
				
			}
			s re=..SaveGlobalLog(MKBGRowId, "", "","","", "", MKBGMark, "")
			s re=[].%FromJSON(re)
			s RowId=re.%Get("id")
			//s RowId = obj.%Id()
		}
		else		//新增
		{
			s eobj = ##class(web.Entity.MKB.MKBGlobal).%New()  //保存到全局化词表
			
			
			///保存该术语下的内容和属性内容
			s eobj.MKBGDesc=MKBGDesc    //术语描述
			s eobj.MKBGRowId=MKBGRowId
			
			
			//w eobj.MKBGDesc,!
			s eobj.MKBGPYCode=$lg($g(^User.MKBTermD(TermRowId)),6)    //术语拼音码
			s eobj.MKBGNote=$lg($g(^User.MKBTermD(TermRowId)),7)    //术语备注
			s eobj.MKBGMark="临床实用诊断"
			s EnRowId=0
			for
			{
				s EnRowId=$o(^User.MKBTermPropertyI("TermIndex",TermRowId,EnRowId))
				q:EnRowId=""
				if ($lg($g(^User.MKBTermPropertyD(EnRowId)),3)["英文名")   //判断获取英文名
				{
					s EnDRowId=$o(^User.MKBTermProDetailI("ProIdx",EnRowId,0))
					continue:EnDRowId=""
					s eobj.MKBGEnName=$lg($g(^User.MKBTermProDetailD(EnDRowId)),3)
					q
				}
			}
			s Termrs=..SaveGlobalEntity(eobj)   //保存术语到全局化词表中
			s json=##class(web.DHCBL.MKB.SDSCommonFromJson).%New()
			s jsontmp= json.%FromJSON(Termrs)
			s RowId=json.%Get("id")
		}
		s ReferenceID=$o(^User.MKBGlobalReferenceI("InverAllIndex",RowId,"T",TermRowId,0))
		//s ReferenceID=$o(^User.MKBGlobalReferenceI("InverAllIndex",MKBGRowId,"T",TermRowId,0))
		if (ReferenceID="")
		{
			s Referencers=##class(web.DHCBL.MKB.MKBGlobalReference).SaveData("A",RowId,"T",TermRowId)    //保存引用表
			if (Referencers["error")
			{
				s unrefcount=unrefcount+1
				b
			}
		}
		//导入别名
		s TermProRowId=0
		for		
		{
			s num = 0
			s flag=""
			s TermProRowId=$o(^User.MKBTermPropertyI("TermIndex",TermRowId,TermProRowId))  
			q:TermProRowId=""
			s PropertyDesc=$lg($g(^User.MKBTermPropertyD(TermProRowId)),3)
			continue:(PropertyDesc'="别名")
			s DetailID=0
			for
			{
				s DetailID=$o(^User.MKBTermProDetailI("ProIdx",TermProRowId,DetailID))  //遍历临床实用诊断下的别名
				q:DetailID=""
				s MKBGADesc=$lg($g(^User.MKBTermProDetailD(DetailID)),3)    //别名
				s MKBGADesc=$Replace(MKBGADesc," ","")
				
				s MKBTPDSequence=$lg($g(^User.MKBTermProDetailD(DetailID)),9)	//顺序号 第几条数据
				s MKBGARowId=$O(^User.MKBGloAliasI("DescIndex",RowId," "_$ZCONVERT(MKBGADesc,"U"),0))
				if (MKBGARowId="")
				{
					s eobj = ##class(web.Entity.MKB.MKBGloAlias).%New()  //别名表实体类对象
					s eobj.MKBGAParRef=RowId     //别名父表指针
					//w TermRowId_"AAAA",!
					s eobj.MKBGADesc=MKBGADesc    //别名
					
					s eobj.MKBGANote=$lg($g(^User.MKBTermProDetailD(DetailID)),7)    //别名备注
					s eobj.MKBGACEFlag="C"
					s Aliasrs=..SaveAliasEntity(eobj)    //保存别名到别名表	
				}
				else
				{
					s AlisaRowid=RowId_"||"_MKBGARowId
					s MKBGAMark = $lg($g(^User.MKBGlobalD(RowId,"ChildGloAlias",MKBGARowId)),8)
					//s aobj=##class(User.MKBGloAlias).%OpenId(AlisaRowid)
					s NewMKBGAMark=MKBGAMark
					//s aobj = ##class(web.Entity.MKB.MKBGloAlias).%New()  //别名表实体类对象
					if (MKBTPDSequence=1)		//展示名 第一条数据
					{
						s aliasID = 0
						for
						{
							s aliasID=$o(^User.MKBGloAliasI("DisplayName",RowId," Y",aliasID))
							q:aliasID=""
							s OldMarkStr = $lg($g(^User.MKBGlobalD(RowId,"ChildGloAlias",aliasID)),8)
							//s OldMarkStr = Alobj.MKBGAMark
							s OldMarkStr=##class(web.BDP.util.String).Replace(OldMarkStr,"展示名,","")
							s OldMarkStr=##class(web.BDP.util.String).Replace(OldMarkStr,",展示名","")
							s OldMarkStr=##class(web.BDP.util.String).Replace(OldMarkStr,"展示名","")
							
							d ..SaveAliasLog(RowId, aliasID, "", "", "", "", "", OldMarkStr, "N")

						}
						if (NewMKBGAMark="")
						{
							s NewMKBGAMark="展示名"
						}
						else
						{
							s NewMKBGAMark=NewMKBGAMark_",展示名"
						}

						
					}
					if (MKBGADesc=MKBGDesc)		//临床实用诊断
					{
						if (NewMKBGAMark="")
						{
							s NewMKBGAMark="临床实用诊断"
						}
						elseif (NewMKBGAMark'["临床实用诊断")
						{
							s NewMKBGAMark=NewMKBGAMark_",临床实用诊断"
							
						}
						
					}
					d ..SaveAliasLog(RowId, MKBGARowId, "", "", "", "", "", NewMKBGAMark, "Y")

				}
						
			}
		}
	}
	q "ok"
}

/// Creator: 范文凯
/// CreatDate: 2020-03-03
/// Description:将临床实用诊断的数据导入到全局化词表中 
/// Table: User.MKBGlobal User.MKBGloAlias
/// Input:Base：知识库ID
/// Return:
/// w ##class(web.DHCBL.MKB.MKBGlobal).ImportDataByDiag()
ClassMethod ImportDataByDiag()
{
	TS
	s ErrorInfo=""
	s TermRowId=0
	for
	{
		s TermRowId=$o(^User.MKBTermI("BaseIndex",5,TermRowId))  //根据知识库ID取一条术语ID
		//w TermRowId,!
		q:TermRowId=""
		//b
		s eobj = ##class(web.Entity.MKB.MKBGlobal).%New()
		///保存该术语下的内容和属性内容
		//s eobj.MKBGCode=$lg($g(^User.MKBTermD(TermRowId)),2)    //术语代码
		s eobj.MKBGDesc=$lg($g(^User.MKBTermD(TermRowId)),3)    //术语描述
		//w eobj.MKBGDesc,!
		s eobj.MKBGPYCode=$lg($g(^User.MKBTermD(TermRowId)),6)    //术语拼音码
		s eobj.MKBGNote=$lg($g(^User.MKBTermD(TermRowId)),7)    //术语备注
		s eobj.MKBGMark="临床实用诊断"
		//s eobj.MKBGCode ="MKBTerm"_TermRowId
		s EnRowId=0
		for
		{
			s EnRowId=$o(^User.MKBTermPropertyI("TermIndex",TermRowId,EnRowId))
			q:EnRowId=""
			if ($lg($g(^User.MKBTermPropertyD(EnRowId)),3)["英文名")   //判断获取英文名
			{
				s EnDRowId=$o(^User.MKBTermProDetailI("ProIdx",EnRowId,0))
				continue:EnDRowId=""
				s eobj.MKBGEnName=$lg($g(^User.MKBTermProDetailD(EnDRowId)),3)
				q
			}
		}
		s Termrs=..SaveGlobalEntity(eobj)   //保存术语到全局化词表中
		s Termsc=Termrs["true"
		if $$$ISOK(Termsc)
		{
			s json=##class(web.DHCBL.MKB.SDSCommonFromJson).%New()
			s jsontmp= json.%FromJSON(Termrs)
			s RowId=json.%Get("id")
			s Referencers=##class(web.DHCBL.MKB.MKBGlobalReference).SaveData("A",RowId,"T",TermRowId)    //保存引用表
			if (Referencers["error")
			{
				s ErrorInfo=ErrorInfo_"TermReference:"_TermRowId_"数据导入失败 "
				b
			}
		}
		else
		{
			s ErrorInfo=ErrorInfo_"Term:"_TermRowId_"数据导入失败 "
			b
		}
		///导入术语下的属性
		//TS
		s TermProRowId=0
		for
		{
			s num = 0
			s flag=""
			s TermProRowId=$o(^User.MKBTermPropertyI("TermIndex",TermRowId,TermProRowId))
			q:TermProRowId=""
			///导入别名到别名表中
			if ($lg($g(^User.MKBTermPropertyD(TermProRowId)),3)="别名")
			{
				
				s AliasDRowId=0
				//if ($o(^User.MKBTermProDetailI("ProIdx",TermProRowId,AliasDRowId))="")
				//{
					s aobj = ##class(web.Entity.MKB.MKBGloAlias).%New()  //别名表实体类对象
					s aobj.MKBGAParRef=RowId     //别名父表指针
					s aobj.MKBGADesc=$lg($g(^User.MKBTermD(TermRowId)),3)
					s aobj.MKBGACEFlag="C"
					s aobj.MKBGAMark ="中心词"
					;w aobj.MKBGAParRef_"--"_aobj.MKBGADesc,!
					s Aliasrs=..SaveAliasEntity(aobj)    //保存别名到别名表
					d aobj.%Close()
					s Aliassc=Aliasrs["false"
					if $$$ISOK(Aliassc)
					{
						s ErrorInfo=ErrorInfo_"Alias:"_AliasDRowId_"数据导入失败 "
						b
					}
				//}
				//else
				//{
					for
					{
						s AliasDRowId=$o(^User.MKBTermProDetailI("ProIdx",TermProRowId,AliasDRowId))
						q:AliasDRowId=""
						s aobj = ##class(web.Entity.MKB.MKBGloAlias).%New()  //别名表实体类对象
						s aobj.MKBGAParRef=RowId     //别名父表指针
						//w TermRowId_"AAAA",!
						s aobj.MKBGADesc=$lg($g(^User.MKBTermProDetailD(AliasDRowId)),3)    //别名
						if ($d(^User.MKBGloAliasI("DescIndex",RowId," "_aobj.MKBGADesc))&&(num=0))
						{
							s AliasID = $o(^User.MKBGloAliasI("DescIndex",RowId," "_aobj.MKBGADesc,0))
							s MKBGAMark = $lg($g(^User.MKBGlobalD(RowId,"ChildGloAlias",AliasID)),8)
							s MKBGAMark  = MKBGAMark_",展示名"
							
							d ..SaveAliasLog(RowId, AliasID, "", "", "", "", "", MKBGAMark, "")
							/*
							s tobj = ##class(User.MKBGloAlias).%OpenId(RowId_"||"_AliasID)
							s tobj.MKBGAMark  = tobj.MKBGAMark_",展示名"
							d tobj.%Save()
							d tobj.%Close()
							*/
							s flag = 1
						}
						if (num=0)&&(flag'=1)
						{
						   s aobj.MKBGAMark = "展示名"
						}
						else
						{
						   s aobj.MKBGAMark = "别名"
						}
						continue:$d(^User.MKBGloAliasI("DescIndex",RowId," "_aobj.MKBGADesc))
						s aobj.MKBGANote=$lg($g(^User.MKBTermProDetailD(AliasDRowId)),7)    //别名备注
						s aobj.MKBGACEFlag="C"
						//w aobj.MKBGAParRef_" "_aobj.MKBGADesc_" "_aobj.MKBGANote_"AAAA",!
						s Aliasrs=..SaveAliasEntity(aobj)    //保存别名到别名表
						d aobj.%Close()
						s Aliassc=Aliasrs["false"
						if $$$ISOK(Aliassc)
						{
							s ErrorInfo=ErrorInfo_"Alias:"_AliasDRowId_"数据导入失败 "
							b
						}
						s num = num+1
					}
				//}
			}
			
			///导入英文名到别名表中
			/*if ($lg($g(^User.MKBTermPropertyD(TermProRowId)),3)["英文名")   //判断获取英文名
			{
				s AliasDRowId=0
				for
				{
					s AliasDRowId=$o(^User.MKBTermProDetailI("ProIdx",TermProRowId,AliasDRowId))
					q:AliasDRowId=""
					s aobj = ##class(web.Entity.MKB.MKBGloAlias).%New()  //别名表实体类对象
					s aobj.MKBGAParRef=RowId     //别名父表指针
					//w TermRowId_"AAAA",!
					s aobj.MKBGADesc=$lg($g(^User.MKBTermProDetailD(AliasDRowId)),3)    //英文别名
					s aobj.MKBGANote=$lg($g(^User.MKBTermProDetailD(AliasDRowId)),7)    //英文别名备注
					s aobj.MKBGACEFlag="E"
					//w aobj.MKBGAParRef_" "_aobj.MKBGADesc_" "_aobj.MKBGANote_"AAAA",!
					s Aliasrs=..SaveAliasEntity(aobj)    //保存别名到别名表
					s Aliassc=Aliasrs["false"
					if $$$ISOK(Aliassc)
					{
						s ErrorInfo=ErrorInfo_"Alias:"_AliasDRowId_"数据导入失败 "
						b
					}
				}
			}*/
			/*s TermProType=$lg($g(^User.MKBTermPropertyD(TermProRowId)),4)
			//w "Type"_TermProType,!
			//b
			if (TermProType="TX")||(TermProType="TA")      //判断属性类型是否为文本或多行文本框
			{
				//w "OKOKOK",!
				s pobj = ##class(web.Entity.MKB.MKBGlobal).%New()
				///保存属性内容
				s TermProDRowId=$o(^User.MKBTermProDetailI("ProIdx",TermProRowId,0))
				continue:TermProDRowId=""
				//s pobj.MKBGCode=$lg($g(^User.MKBTermProDetailD(TermProDRowId)),2)    //属性内容代码
				s pobj.MKBGDesc=$lg($g(^User.MKBTermProDetailD(TermProDRowId)),3)    //属性内容描述
				//w pobj.MKBGDesc_"DD",!
				s pobj.MKBGPYCode=$lg($g(^User.MKBTermProDetailD(TermProDRowId)),10)    //属性内容拼音码
				s pobj.MKBGNote=$lg($g(^User.MKBTermProDetailD(TermProDRowId)),7)    //属性内容备注
				s ProDrs=..SaveGlobalEntity(pobj)      //保存该术语下的属性内容到全局化词表中
				
				
				
				
				s ProDsc=ProDrs["false"
				if (ProDsc)
				{
					s ErrorInfo=ErrorInfo_"ProDetail:"_TermProDRowId_"数据导入失败 "
					b
				}
				else
				{
					s jsonD=##class(web.DHCBL.MKB.SDSCommonFromJson).%New()
					s jsontmpD= jsonD.%FromJSON(ProDrs)
					s DRowId=jsonD.%Get("id")
					s ReferenceDrs=##class(web.DHCBL.MKB.MKBGlobalReference).SaveData("A",DRowId,"D",TermProDRowId)
					if (ReferenceDrs["error")
					{
						s ErrorInfo=ErrorInfo_"ProDetailReference:"_TermProDRowId_"数据导入失败 "
						b
					}
				}
			}
			else
			{
				continue
			}*/
		}
	}
	if (ErrorInfo="")
	{
		s ErrorInfo="数据导入成功！"
	}
	q ErrorInfo
}

/// Creator: 范文凯
/// CreatDate: 2020-03-04
/// Description:批量处理多音字的检索码问题
/// Table: User.MKBGlobal User.MKBGloAlias
/// Input:Base：知识库ID
/// Return:
/// w ##class(web.DHCBL.MKB.MKBGlobal).PYEdit("α受体","αST")
ClassMethod PYEdit(StrDesc As %String, StrPYM As %String)
{
	s sucnum =0
	s MKBGlobalID = 0
	for
	{
		s MKBGlobalID = $o(^User.MKBGlobalD(MKBGlobalID))
		q:MKBGlobalID=""
		s MKBGDesc = $lg($g(^User.MKBGlobalD(MKBGlobalID)),3)
		if (MKBGDesc[StrDesc)
		{
			b
			s MKBGName = 0
			for 
			{
				s MKBGName = $o(^User.MKBGloAliasI("DescIndex",MKBGlobalID," "_MKBGName))
				q:MKBGName=""
				s MKBGName = $Zstrip(MKBGName,"<>W")
				if (MKBGName[StrDesc)
				{
					s MKBGAliasID = $o(^User.MKBGloAliasI("DescIndex",MKBGlobalID," "_MKBGName,0))
					
					s PYCode = $lg($g(^User.MKBGlobalD(MKBGlobalID,"ChildGloAlias",MKBGAliasID)),3)
					s num = $find(MKBGName,StrDesc)
					s len = $l(StrDesc)
					s left= $e(PYCode,0,num-1-len)
					s right = $e(PYCode,num,*)
					s NewPYCode =left_StrPYM_right
					/*w left_","_right,!
					w MKBGAliasID_"^"_NewPYCode,!*/

				    s obj = ##class(User.MKBGloAlias).%OpenId(MKBGlobalID_"||"_MKBGAliasID)
				    s obj.MKBGAPYCode = NewPYCode
				    d obj.%Save()
				    d obj.%Close()
					s sucnum=sucnum+1
				}
			}
		}
	}
	q sucnum
}

/// Creator: 范文凯
/// CreatDate: 2020-03-05
/// Description:通过全局化词表和ICD2.0数据进行对照
/// Table: User.MKBGlobal User.MKBGloAlias
/// Input:Base：知识库ID
/// Return:
/// w ##class(web.DHCBL.MKB.MKBGlobal).CommonExp()
ClassMethod CommonExp()
{
	Ts                //开启事务，保护数据安全
	s res=0
	s MKBGlobalID = ""
	for
	{
		s MKBGlobalID = $o(^User.MKBGlobalD(MKBGlobalID),-1)             //遍历全局化词表数据
		q:MKBGlobalID=""
		s MKBGMark = $lg($g(^User.MKBGlobalD(MKBGlobalID)),10)        //获得Mark值 进行条件过滤 
		;continue:MKBGlobalID'=9934		//后循环缺血
		continue:MKBGMark'="临床实用诊断"
		s NameDesc = 0
		for
		{
			s NameDesc = $o(^User.MKBGloAliasI("DescIndex",MKBGlobalID,NameDesc))
			q:NameDesc=""
			//d ..MatchSD(MKBGlobalID,NameDesc)
			if ($d(^User.MKBICDContrastI("DescIndex",NameDesc)))   //和ICD2.0匹配到一起
			{
				s MKBICDConID = $o(^User.MKBICDContrastI("DescIndex",NameDesc," "),-1)
				continue:$lg($g(^User.MKBICDContrastD(MKBICDConID)),4)=""    //不存在主要编码则跳出本次循环
				continue:$lg($g(^User.MKBICDContrastD(MKBICDConID)),18)'=1   //没有结构化的也退出
				s tmpid = $o(^User.MKBICDContrastD(MKBICDConID,"MKBICDContrastResult",0))
				s ResultIDStr = $lg($g(^User.MKBICDContrastD(MKBICDConID,"MKBICDContrastResult",tmpid)),2)  //获得结构化结构ID串
				s TermDR = $lg($g(^User.MKBICDContrastD(MKBICDConID,"MKBICDContrastResult",tmpid)),4) //获得TermDR  获得展示名ID
				if (TermDR'="")&&(ResultIDStr="")
				{
					s AliasID=$o(^User.MKBGloAliasI("DescIndex",MKBGlobalID,NameDesc,""))
					//传参 TermDR 传参MKBGlobalID 传参 MKBICDConID
					s flag=..MatchRef(TermDR,MKBGlobalID,MKBICDConID,AliasID)
					if flag="0"
					{
						s res=res+1
					}   // 计算TermDR'=TermID的数量
				}
				continue:ResultIDStr=""
				// MKBGlobalID NameDesc 以及 ConStr 作为入参 保存到临床实用诊断的常用诊断表达式属性中
				s MKBGTPDID = ..SaveDiagExp(MKBGlobalID,NameDesc,TermDR,ResultIDStr)
				//添加成功之后删除掉别名列表里原有的NameDesc 属性 (MKBGlobalID,NameDesc)
				//d ..DelOtherName(MKBGlobalID,NameDesc)
				//全局化词表的别名表里要删除掉这个数据  并且新增一个数据 
			    s MKBGloAliasID = $o(^User.MKBGloAliasI("DescIndex",MKBGlobalID,NameDesc,0))
			    d ##class(User.MKBGloAlias).%DeleteId(MKBGlobalID_"||"_MKBGloAliasID)
				//传参调用函数 新增一个全局化词表对象 重点是引用场景
				d ..AddMKBGloObj(NameDesc,MKBGTPDID)
			}
		}
	}
	q res
}

ClassMethod MatchSD(MKBGlobalID As %String, NameDesc As %String)
{
	if ($d(^User.MKBStructuredDataI("MKBSDDiagIndex",3,NameDesc))) //在医大一数据处理工厂中匹配到数据	
    {
        s SDID = $o(^User.MKBStructuredDataI("MKBSDDiagIndex",3,NameDesc,0))
		s ChildStructFlag = $lg($g(^User.MKBStructuredDataD(SDID)),14)
		s SDICD = $lg($g(^User.MKBStructuredDataD(SDID)),20)
		if (ChildStructFlag="1")&&(SDICD'="")
		{
			s obj = ##class(web.Entity.MKB.MKBGlobalReference).%New()
			
			s obj.InitiativeFlag="ICDSD"				//发起引用，主动引用标识
			s obj.InitiativeID=SDID				//发起引用词的ID
			s obj.PassiveID=MKBGlobalID				//被引用词的ID
			s obj.PassiveAliasID=""
			
			d ..SaveReferenceEntity(obj)
		}
	}
}

/// Creator: 范文凯
/// CreatDate: 2020-03-05
/// Description:如果各版本icd对照对的中心词 能对上引用的中心词，增加一条指向各版本icd对照的引用
/// Table: 
/// Input:TermDR 中心词id ，MKBGlobalID 术语id，MKBICDConID 各版本icd对照id，AliasID 术语别名id
/// Return:
/// w ##class(web.DHCBL.MKB.MKBGlobal).SaveDiagExp("11047","","")
ClassMethod MatchRef(TermDR As %String, MKBGlobalID As %String, MKBICDConID As %String, AliasID As %String)
{
	s result = ""
	s TermID = $o(^User.MKBGlobalReferenceI("InverAllIndex",MKBGlobalID,"T",0))
	if (TermDR=TermID)   //如果相等则满足 各版本ICD对照的 第一场景 引用逻辑
	{
		//该逻辑下 要求新增一条引用场景 指向各版本ICD中的内容

		s obj = ##class(web.Entity.MKB.MKBGlobalReference).%New()
			
		s obj.InitiativeFlag="ICDCon"				//发起引用，主动引用标识
		s obj.InitiativeID=MKBICDConID				//发起引用词的ID
		s obj.PassiveID=MKBGlobalID				//被引用词的ID
		s obj.PassiveAliasID=AliasID
		
		d ..SaveReferenceEntity(obj)
			
		s result="1"
	}
	else
	{
		s result="0"
	}
	q result
}

/// Creator: 范文凯
/// CreatDate: 2020-03-05
/// Description:保存数据到临床实用诊断常用诊断表达式属性
/// Table: User.MKBGlobal User.MKBGloAlias
/// Input:Base：知识库ID
/// Return:
/// w ##class(web.DHCBL.MKB.MKBGlobal).SaveDiagExp("11047","","")
ClassMethod SaveDiagExp(MKBGlobalID As %String, NameDesc As %String, TermDR As %String, ResultIDStr As %String)
{
	s Result = ""
	s TermID = $o(^User.MKBGlobalReferenceI("InverAllIndex",MKBGlobalID,"T",0))
	if (TermDR=TermID)
	{
		s MKBTRowid = TermID
	}
	else
	{
		s MKBTRowid = TermDR
	}
	s ConStr=TermDR_"-"_ResultIDStr
	//s MKBTRowid = $o(^User.MKBGlobalReferenceI("InverAllIndex",MKBGlobalID,"T",0))
	s MKBProRowid = $o(^User.MKBTermPropertyI("DescIndex",MKBTRowid," 常用诊断表达式",0))
	s eobj=##class(web.Entity.MKB.MKBTermProDetail).%New()
	s NameDesc=$Zstrip(NameDesc,"<>W")
    s eobj.MKBTPDDesc=NameDesc
    s eobj.MKBTPDProDR=MKBProRowid
    s Result= ##class(web.DHCBL.MKB.MKBTermProDetail).SaveData(eobj)
    d eobj.%Close()
    s Tmpid =$o(^User.MKBTermProDetailD(" "),-1)
    s TmpDesc = $lg($g(^User.MKBTermProDetailD(Tmpid)),3)
    //if TmpDesc = NameDesc
    //{
    if Result["success"
    {
	    s MKBExtendProID = $o(^User.MKBTermExtendProI("NameIndex",MKBProRowid," 诊断表示式",0))
	    s ExtendProDR = MKBProRowid_"||"_MKBExtendProID
		s DetailDR = $o(^User.MKBTermProDetailI("ProIdx",MKBProRowid," "),-1)
		s obj = ##class(User.MKBTermExtendProVal).%New()
		d obj.MKBTEPVDetailDrSetObjectId(DetailDR)
		d obj.MKBTEPVExtendDrSetObjectId(ExtendProDR)
		s obj.MKBTEPVValue=ConStr
		d obj.%Save()
		d obj.%Close()
	}
	else
	{
		;b ;;;
	}
	;w MKBGlobalID,!
	/*if NameDesc="风湿热"
				{
					b
				}*/
	q DetailDR
}

/// Creator: 范文凯
/// CreatDate: 2020-03-05
/// Description:删除NameDesc的别名属性值
/// Table: User.MKBGlobal User.MKBGloAlias
/// Input:Base：知识库ID
/// Return:
/// w ##class(web.DHCBL.MKB.MKBGlobal).DelOtherName("11047","")
ClassMethod DelOtherName(MKBGlobalID As %String, NameDesc As %String)
{
	s MKBTRowid = $o(^User.MKBGlobalReferenceI("InverAllIndex",MKBGlobalID,"T",0))
	s MKBProRowid = $o(^User.MKBTermPropertyI("DescIndex",MKBTRowid," 别名",0))
	s MKBProDetailID = 0
	for 
	{
		s MKBProDetailID = $o(^User.MKBTermProDetailI("ProIdx",MKBProRowid,MKBProDetailID))
		q:MKBProDetailID=""
		s DetailDesc = $lg($g(^User.MKBTermProDetailD(MKBProDetailID)),3)
		s NameDesc=$Zstrip(NameDesc,"<>W")
		if NameDesc=DetailDesc
		{
			s sc =##class(User.MKBTermProDetail).%DeleteId(MKBProDetailID)
		}
	}
	//b
}

/// Creator: 范文凯
/// CreatDate: 2020-03-05
/// Description:根据入参删除全局化词表别名表里的数据 这个数据用来新增一个对象
/// Table: User.MKBGlobal User.MKBGloAlias
/// Input:Base：知识库ID
/// Return:
/// w ##class(web.DHCBL.MKB.MKBGlobal).AddMKBGloObj("11047","")
ClassMethod AddMKBGloObj(NameDesc As %String, MKBTPID As %String)
{
	s result=""
	s NameDesc=$Zstrip(NameDesc,"<>W")
	s obj = ##class(web.Entity.MKB.MKBGlobal).%New()
	//s obj = ##class(User.MKBGlobal).%New()
	s obj.MKBGDesc = NameDesc
	s obj.MKBGMark = "常用诊断描述"
	//s obj.MKBGRowId=""
	s sc = ..SaveGlobalData(obj)
	//s sc = obj.%Save()
	d obj.%Close()
	//if $$$ISOK(sc)
	if (sc["success")
	{
		if (MKBTPID'="")
		{
			s MKBGlobalID = $o(^User.MKBGlobalD(" "),-1)
			s robj = ##class(web.Entity.MKB.MKBGlobalReference).%New()
			
			s robj.InitiativeFlag="D"				//发起引用，主动引用标识
			s robj.InitiativeID=MKBTPID				//发起引用词的ID
			s robj.PassiveID=MKBGlobalID			//被引用词的ID
			s robj.PassiveAliasID=""				//被引用词的名称列表ID
			d ..SaveReferenceEntity(robj)
			
			
			d ..MatchSD(MKBGlobalID," "_NameDesc)
			//d obj.%Close()
			s MKBICDConID = $o(^User.MKBICDContrastI("DescIndex"," "_NameDesc," "),-1)
			q:MKBICDConID="" "success"
			s icd = $lg($g(^User.MKBICDContrastD(MKBICDConID)),4)   //不存在主要编码则跳出本次循环
			s sdflag = $lg($g(^User.MKBICDContrastD(MKBICDConID)),18)   //没有结构化的也退
			//传参 TermDR 传参MKBGlobalID 传参 MKBICDConID
			if (icd'="")&&(sdflag=1)
			{
				s eobj = ##class(web.Entity.MKB.MKBGlobalReference).%New()
			
				s eobj.InitiativeFlag="ICDCon"				//发起引用，主动引用标识
				s eobj.InitiativeID=MKBICDConID				//发起引用词的ID
				s eobj.PassiveID=MKBGlobalID			//被引用词的ID
				s eobj.PassiveAliasID=""				//被引用词的名称列表ID
				d ..SaveReferenceEntity(eobj)
			}
		}
	}
	q "success"
}

/// Creator: 范文凯
/// CreatDate: 2020-03-05
/// Description:清一下全局化词表引用表的数据
/// Table: User.MKBGlobal User.MKBGloAlias
/// Input:Base：知识库ID
/// Return:
/// w ##class(web.DHCBL.MKB.MKBGlobal).CleanMKBGRef()
ClassMethod CleanMKBGRef()
{
	Ts
	s MKBGRID = 0
	for
	{
		s MKBGRID = $o(^User.MKBGlobalReferenceD(MKBGRID))
		q:MKBGRID=""
		s PassiveID = $lg($g(^User.MKBGlobalReferenceD(MKBGRID)),4)
		if ('$d(^User.MKBGlobalD(PassiveID)))
		{
			;w "1"
			d ..DeleteReferenceData(MKBGRID)
		}
	}
	q "yes"
}

/// Creator:范文凯
/// CreatDate:2019-11-05
/// Description:为跳转按钮提供方法
/// Input：MKB_Global表的id 
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).Returntermproid("125")
ClassMethod Returntermproid(referenceid As %String)
{
	s menuid=""
	s Termid=""
	s Termproid=""
	s menudesc=""
    s Flag =$lg($g(^User.MKBGlobalReferenceD(referenceid)),2)		//标志
    s MKBGID = $lg($g(^User.MKBGlobalReferenceD(referenceid)),4)	//术语id
	s MKBGMark = $lg($g(^User.MKBGlobalD(MKBGID)),10)
	
	
	
    if (Flag="T")   //指向的是termid
    {
	    s menuid = ##class(web.DHCBL.BDP.BDPMenuDefine).GetID("dhc.bdp.mkb.mtm.Diagnosis")
	    s menudesc = "临床实用诊断"		//"临床实用诊断"
	    s Termid = $lg($g(^User.MKBGlobalReferenceD(referenceid)),3)		//临床实用诊断id
	    s Termproid = ""
	    
	}
	elseif (Flag="D")
	{
		s Termprodetailid = $lg($g(^User.MKBGlobalReferenceD(referenceid)),3)		//常用诊断表达式id
	    s Termproid = $lg($g(^User.MKBTermProDetailD(Termprodetailid)),6)
	    s Termid = $lg($g(^User.MKBTermPropertyD(Termproid)),6)
	    if (MKBGMark["部位")
		{
			s menuid = ##class(web.DHCBL.BDP.BDPMenuDefine).GetID("dhc.bdp.mkb.mtm.SY000043")
			s menudesc = "主要部位测试"
		}
		else
		{
			s menuid = ##class(web.DHCBL.BDP.BDPMenuDefine).GetID("dhc.bdp.mkb.mtm.Diagnosis")
	    	s menudesc = "临床实用诊断"		//"临床实用诊断"
		}
	}
	q menuid_","_menudesc_","_Termid_","_Termproid
}

/// Creator:范文凯
/// CreatDate:2020-03-12
/// Description:全局化词表中的名称列表去匹配各版本ICD 匹配到的添加到引用场景中
/// Input：MKB_Global表的id ，已经NameDesc
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).MKBGMateICD("125")
ClassMethod MKBGMateICD(MKBGlobalID As %String, NameDesc As %String)
{
}

/// 获得全局化词表标记Json串
/// d ##class(web.DHCBL.MKB.MKBGlobal).GetMarkJsonStr("1")
ClassMethod GetMarkJsonStr(id As %String)
{
	w ##class(web.DHCBL.MKB.MKBAssInterface).GetTreeJson("80"," ")
	//q CStr
}

/// 通过GlobalID 来获取该中心词的全局化词表ID串
/// w ##class(web.DHCBL.MKB.MKBGlobal).GetMarkIDStr("1")
ClassMethod GetMarkIDStr(GlobalID As %String)
{
	 s MarkIDStr=""
	 s MKBGMark = $lg($g(^User.MKBGlobalD(GlobalID)),10)
	 s length = $l(MKBGMark,",")
	 for i=1:1:length
	 {
		 s MarkDesc = $p(MKBGMark,",",i)
		 s MarkID = $o(^User.MKBTermI("DescIndex",80," "_MarkDesc,0))
		 s MarkIDStr=MarkIDStr_MarkID_","
     }
     s MarkIDStr = $Zstrip(MarkIDStr,"<>W")   
	 s MarkIDStr = $e(MarkIDStr,0,*-1)
	 q MarkIDStr
}

/// 通过入参 保存全局化词表标志
ClassMethod SaveMKBGMark(GlobalID As %String, MarkStr As %String)
{
	d ..SaveGlobalLog(GlobalID, "", "","","", "", MarkStr, "")
	/*
	s obj = ##class(User.MKBGlobal).%OpenId(GlobalID)
	s obj.MKBGMark = MarkStr
	d obj.%Save()
	d obj.%Close()
	*/
	q "yes"
}

/// 全局化词表频次字段增加数据
/// w ##class(web.DHCBL.MKB.MKBGlobal).GetMKBGTotalFreq()
ClassMethod GetMKBGTotalFreq()
{
	Ts 
	s MKBGID = 0
	for
	{
		s MKBGID = $o(^User.MKBGlobalD(MKBGID))                //遍历全局化词表
		q:MKBGID=""
		s MKBGMark = $lg($g(^User.MKBGlobalD(MKBGID)),10)    //获得Mark 如果Mark中不包含[诊断 则退出
		continue:(MKBGMark'["诊断")
		s totalnum = 0
		s MKBGDiagLocID = 0
		for
		{
			s MKBGDiagLocID = $o(^User.MKBGDiagLocI("DiaDRIndex",MKBGID,MKBGDiagLocID))
			q:MKBGDiagLocID=""
			s Freq = $lg($g(^User.MKBGDiagLocD(MKBGDiagLocID)),4)
			s totalnum = totalnum+Freq
		}
		
		d ..SaveGlobalLog(MKBGID, "", "","","", "", "", totalnum)
		/*
		s obj = ##class(User.MKBGlobal).%OpenId(MKBGID)
		s obj.MKBGDiaTotalFreq = totalnum
		d obj.%Save()
		d obj.%Close()
		*/
	}
	q ""
}

/// DiffDiagSource
/// 返回主干次list
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CDSS.DiseJoinDiffDiag","DiffDiagSource","")
Query StemWordSource(q As %String) As %Query(ROWSPEC = "MKBDiagDR,MKBDiagDesc")
{
}

ClassMethod StemWordSourceExecute(ByRef qHandle As %Binary, q As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	s num = 0
 	s Desc=q
 	if (Desc'="")
 	{
		s DiagID = 0
		for
		{
			s DiagID = $o(^User.MKBTermI("BaseIndex",5,DiagID))
			q:DiagID=""
			s MKBDiagDR = DiagID
			s MKBDiagDesc = $lg($g(^User.MKBTermD(DiagID)),3)
			continue:MKBDiagDesc'[Desc
			d OutputRow8
		}
 	}
 	else
 	{
	 	s DiagID = 0
		for
		{
			s DiagID = $o(^User.MKBTermI("BaseIndex",5,DiagID))
			q:DiagID=""
			s MKBDiagDR = DiagID
			s MKBDiagDesc = $lg($g(^User.MKBTermD(DiagID)),3)
			d OutputRow8
			s num=num+1
            q:num=100
		}	
	}
    
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(MKBDiagDR,MKBDiagDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod StemWordSourceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCTPMExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod StemWordSourceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StemWordSourceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/*/// 提供组词查询
ClassMethod CreateWordSearch(prefStr As %String, suffStr As %String, stemWord As %String)
{
	s stemWordStr =""
	s MKBGlobalID  =  $o(^User.MKBGlobalI("DescIndex"," "_stemWord,0))
	if (MKBGlobalID'="")   //存在该名称
	{
		s MKBGloAliasID = 0
		for
		{
			
		}
	}
}*/
/// rangeStr: 1=当前选中术语 2=当前搜索到的术语集合 3=词表内所有术语
/// methodStr: 1=前后空格 2=左侧括号前后空格 3=右侧括号前后空格(前删除)
/// 提供空格处理方法
/// w ##class(web.DHCBL.MKB.MKBGlobal).SpaceHandle("3","1,2,3",8090)
ClassMethod SpaceHandle(rangeStr As %String, methodStr As %String, dataID As %String)
{
    if (rangeStr=1)                //对当前选中术语进行操作
    {
	    s Desc= $lg($g(^User.MKBGlobalD(dataID)),3)
	    //
	    if (methodStr["1")
	    {
		    s Desc = ..SpaceHandleMethod1(Desc)
		}
		if (methodStr["2")
		{
			s Desc = ..SpaceHandleMethod2(Desc)
		}
		if (methodStr["3")
		{
			s Desc = ..SpaceHandleMethod3(Desc)
		}
		
		d ..SaveGlobalLog(dataID, Desc, "","","", "", "", "")
		/*
		s obj = ##class(User.MKBGlobal).%OpenId(dataID)

		s obj.MKBGDesc = Desc
		s obj.MKBGPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE($ZCONVERT(Desc,"U"))
		s sc=obj.%Save()
		d obj.%Close()
		*/   
		s AliasID=0
		for
		{
			s AliasID=$o(^User.MKBGlobalD(dataID,"ChildGloAlias",AliasID))  
			q:AliasID=""
			s AliasDesc=$lg($g(^User.MKBGlobalD(dataID,"ChildGloAlias",AliasID)),2) //别名描述
			if (methodStr["1")
		    {
			    s AliasDesc = ..SpaceHandleMethod1(AliasDesc)
			}
			if (methodStr["2")
			{
				s AliasDesc = ..SpaceHandleMethod2(AliasDesc)
			}
			if (methodStr["3")
			{
				s AliasDesc = ..SpaceHandleMethod3(AliasDesc)
			}
			d ..SaveAliasLog(dataID, AliasID, AliasDesc, "", "", "", "", "", "")
		}
		d ..DeleteSameAlias(dataID)		//删除别名表中的重名
		
	}
	elseif(rangeStr=2)            //对当前搜索到的术语集合
	{
		s MKBGlobalID = 0
		for
		{
			s MKBGlobalID = $o(^TmpDataHandle(MKBGlobalID))
			q:MKBGlobalID=""
			s Desc = $lg($g(^User.MKBGlobalD(MKBGlobalID)),3)
			//
			if (methodStr["1")
		    {
			    s Desc = ..SpaceHandleMethod1(Desc)
			}
			if (methodStr["2")
			{
				s Desc = ..SpaceHandleMethod2(Desc)
			}
			if (methodStr["3")
			{
				s Desc = ..SpaceHandleMethod3(Desc)
			}
			d ..SaveGlobalLog(MKBGlobalID, Desc, "","","", "", "", "")
			/*
			s obj = ##class(User.MKBGlobal).%OpenId(MKBGlobalID)

			s obj.MKBGDesc = Desc
			s obj.MKBGPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE($ZCONVERT(Desc,"U"))
			s sc=obj.%Save()
			d obj.%Close()
	   		 */
			s AliasID=0
			for
			{
				s AliasID=$o(^User.MKBGlobalD(MKBGlobalID,"ChildGloAlias",AliasID))  
				q:AliasID=""
				s AliasDesc=$lg($g(^User.MKBGlobalD(MKBGlobalID,"ChildGloAlias",AliasID)),2) //别名描述
				if (methodStr["1")
			    {
				    s AliasDesc = ..SpaceHandleMethod1(AliasDesc)
				}
				if (methodStr["2")
				{
					s AliasDesc = ..SpaceHandleMethod2(AliasDesc)
				}
				if (methodStr["3")
				{
					s AliasDesc = ..SpaceHandleMethod3(AliasDesc)
				}
				d ..SaveAliasLog(MKBGlobalID, AliasID, AliasDesc, "", "", "", "", "", "")

			}
			d ..DeleteSameAlias(MKBGlobalID)		//删除别名表中的重名
		}
	}
	elseif(rangeStr=3)            //对词表内所有术语
	{
		s MKBGlobalID = 0
		for
		{
			s MKBGlobalID = $o(^User.MKBGlobalD(MKBGlobalID))
			q:MKBGlobalID=""
			s Desc  = $lg($g(^User.MKBGlobalD(MKBGlobalID)),3)
			if (methodStr["1")
		    {
			    s Desc = ..SpaceHandleMethod1(Desc)
			}

			if (methodStr["2")
			{
				s Desc = ..SpaceHandleMethod2(Desc)
			}
			
			if (methodStr["3")
			{
				s Desc = ..SpaceHandleMethod3(Desc)
			}
			d ..SaveGlobalLog(MKBGlobalID, Desc, "","","", "", "", "")

			s AliasID=0
			for
			{
				s AliasID=$o(^User.MKBGlobalD(MKBGlobalID,"ChildGloAlias",AliasID))  
				q:AliasID=""
				s AliasDesc=$lg($g(^User.MKBGlobalD(MKBGlobalID,"ChildGloAlias",AliasID)),2) //别名描述
				if (methodStr["1")
			    {
				    s AliasDesc = ..SpaceHandleMethod1(AliasDesc)
				}
				if (methodStr["2")
				{
					s AliasDesc = ..SpaceHandleMethod2(AliasDesc)
				}
				if (methodStr["3")
				{
					s AliasDesc = ..SpaceHandleMethod3(AliasDesc)
				}
				d ..SaveAliasLog(MKBGlobalID, AliasID, AliasDesc, "", "", "", "", "", "")
			}
			d ..DeleteSameAlias(MKBGlobalID)		//删除别名表中的重名
		}
	}
	//d ##class(User.MKBGlobal).%BuildIndices()
	q "success"
}

/// 处理方法1
ClassMethod SpaceHandleMethod1(Desc As %String)
{
	s NewDesc = $Zstrip(Desc,"<>W")
	q NewDesc
}

/// 处理方法2  处理"(" 左括号前后空格 
ClassMethod SpaceHandleMethod2(Desc As %String)
{
    if (Desc["(")
    {
	    s leftStr= $p(Desc,"(",1)
	    s rightStr = $p(Desc,"(",2)
	    s leftStr= $Zstrip(leftStr,"<>W")
	    s rightStr = $Zstrip(rightStr,"<>W")
	    s NewDesc = leftStr_"("_rightStr
	    q NewDesc
	}
	else
	{
		q Desc
	}
}

/// 处理方法3
ClassMethod SpaceHandleMethod3(Desc As %String)
{
	if (Desc[")")
    {
	    s leftStr= $p(Desc,")",1)
	    s rightStr = $p(Desc,")",2)
	    s leftStr= $Zstrip(leftStr,"<>W")
	    s rightStr = $Zstrip(rightStr,"<>W")
	    s NewDesc = leftStr_")"_rightStr
	    q NewDesc
	}
	else
	{
		q Desc
	}
}

/// 2020-03-26
/// 入参为MKBGlobalID 以及别名名称 
ClassMethod AddMKBGAlias(MKBGlobalID As %String, aliasname As %String)
{
	s result =""
	if $d(^User.MKBGloAliasI("DescIndex",MKBGlobalID," "_aliasname))
	{
		s result = "{success:'false',info:'该别名已经存在于本术语下'}"  //返回错误信息
	}
	else
	{
		s obj = ##class(User.MKBGloAlias).%New()
		s obj.MKBGADesc = ##class(web.DHCBL.BDP.FunLib).Util(aliasname)
		s obj.MKBGAMark="别名"
		d obj.ParRefSetObjectId(MKBGlobalID)
        s obj.MKBGASequence=..GetLastSequence(MKBGlobalID)
        s obj.MKBGAPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE($ZCONVERT(aliasname,"U"))
        s obj.MKBGACEFlag="C"
        s sc = obj.%Save()
        if $$$ISOK(sc)
        {
	        d obj.%Close()
	        s result = "{success:'success',info:'已成功添加别名'}"
	    }
	}
	q result
}

/// rangeStr: 1=当前选中术语 2=当前搜索到的术语集合 3=词表内所有术语
/// methodStr: 1=匹配ICD2.0 2=匹配医大一ICD 3=匹配临床实用诊断  delflag 删除原先的引用
/// 提供空格处理方法
/// w ##class(web.DHCBL.MKB.MKBGlobal).RefHandle("1","1,2",8889)
ClassMethod RefHandle(rangeStr As %String, methodStr As %String, dataID As %String, delflag = "")
{
	
	if (rangeStr=1)                //对当前选中术语进行操作
	{
		//d ..CheckReferenceToDelete(dataID)
		if (delflag'="")	//删除原先的医院引用或者各版本icd对照引用
		{
			//删除已经存在的ICD匹配引用场景
			d ..DelICDMatchRef(dataID,"ICDSD")
			d ..DelICDMatchRef(dataID,"ICDCon")
		}
			
		//dataID 是当前选中术语的id 需要通过该id遍历所有的别名 别名分别去匹配 完全匹配到的则进行引用场景的添加
		s MKBGloAliasDesc=""
		for
		{
			s MKBGloAliasDesc = $o(^User.MKBGloAliasI("DescIndex",dataID,MKBGloAliasDesc))
			q:MKBGloAliasDesc=""
			s PassiveAliasID=$o(^User.MKBGloAliasI("DescIndex",dataID,MKBGloAliasDesc,""))
			if (methodStr["1")		//数据处理工厂
			{
				s base=""
				for
				{
					s base=$o(^User.MKBStructuredDataI("MKBSDDiagIndex",base))
					q:base=""
					continue:((base'=3)&&(base'=9))		//医大一或者港大
					s SDflag = ..RefHandleStructuredBase(base,MKBGloAliasDesc)

					if (SDflag'="N")          //返回结果不为"N" 说明完全匹配到ICD 则添加到该dataID的引用场景下
					{
						s MKBGRRowid=$o(^User.MKBGlobalReferenceI("PassiveAliasIndex",dataID,PassiveAliasID,"ICDSD",SDflag,0)) 
						if (MKBGRRowid="")
						{
							s eobj = ##class(web.Entity.MKB.MKBGlobalReference).%New()
							s eobj.InitiativeFlag="ICDSD"				//发起引用，主动引用标识
							s eobj.InitiativeID=SDflag				//发起引用词的ID
							s eobj.PassiveID=dataID			//被引用词的ID
							s eobj.PassiveAliasID=PassiveAliasID				//被引用词的名称列表ID
							s re= ..SaveReferenceEntity(eobj)
						}
					}
				}
			}
			if (methodStr["2")		//各版本icd
			{
				s Conflag="N"
				s Conflag = ..RefHandleICDCon(MKBGloAliasDesc)   //各版本icd对照
				
				if (Conflag'="N")          //返回结果不为"N" 说明完全匹配到ICD 则添加到该dataID的引用场景下
				{
					s MKBGRRowid=$o(^User.MKBGlobalReferenceI("PassiveAliasIndex",dataID,PassiveAliasID,"ICDCon",Conflag,0)) 
					if (MKBGRRowid="")
					{
						s eobj = ##class(web.Entity.MKB.MKBGlobalReference).%New()
				
						s eobj.InitiativeFlag="ICDCon"				//发起引用，主动引用标识
						s eobj.InitiativeID=Conflag				//发起引用词的ID
						s eobj.PassiveID=dataID			//被引用词的ID
						s eobj.PassiveAliasID=PassiveAliasID				//被引用词的名称列表ID
						d ..SaveReferenceEntity(eobj)
					}
				}
				 
			}
		}
		 
	}
	elseif(rangeStr=2)            //对当前搜索到的术语集合
	{
		s MKBGlobalID = 0
		for
		{
			s MKBGlobalID = $o(^TmpDataHandle(MKBGlobalID))
			q:MKBGlobalID=""
			//d ..CheckReferenceToDelete(MKBGlobalID)
			if (delflag'="")	//删除原先的医院引用或者各版本icd对照引用
			{
				//删除已经存在的ICD匹配引用场景
				d ..DelICDMatchRef(MKBGlobalID,"ICDSD")
				d ..DelICDMatchRef(MKBGlobalID,"ICDCon")
			}
			s MKBGloAliasDesc=""
			for
			{
				s MKBGloAliasDesc = $o(^User.MKBGloAliasI("DescIndex",MKBGlobalID,MKBGloAliasDesc))
				q:MKBGloAliasDesc=""
				s PassiveAliasID=$o(^User.MKBGloAliasI("DescIndex",dataID,MKBGloAliasDesc,""))
				
				if (methodStr["1")		//数据处理工厂
				{
					s base=""
					for
					{
						s base=$o(^User.MKBStructuredDataI("MKBSDDiagIndex",base))
						q:base=""
						continue:((base'=3)&&(base'=9))		//医大一或者港大
						s SDflag = ..RefHandleStructuredBase(base,MKBGloAliasDesc)
						if (SDflag'="N")          //返回结果不为"N" 说明完全匹配到ICD 则添加到该dataID的引用场景下
						{
							s MKBGRRowid=$o(^User.MKBGlobalReferenceI("PassiveAliasIndex",MKBGlobalID,PassiveAliasID,"ICDSD",SDflag,0)) 
							if (MKBGRRowid="")
							{
								s eobj = ##class(web.Entity.MKB.MKBGlobalReference).%New()
								s eobj.InitiativeFlag="ICDSD"				//发起引用，主动引用标识
								s eobj.InitiativeID=SDflag				//发起引用词的ID
								s eobj.PassiveID=MKBGlobalID			//被引用词的ID
								s eobj.PassiveAliasID=PassiveAliasID			//被引用词的名称列表ID
								d ..SaveReferenceEntity(eobj)
							}
							
						}
					}
				}
				if (methodStr["2")		//各版本icd
				{
					s Conflag = ..RefHandleICDCon(MKBGloAliasDesc)   //去调用匹配医大一ICD的方法
					if (Conflag'="N")          //返回结果不为"N" 说明完全匹配到ICD 则添加到该dataID的引用场景下
					{
						s MKBGRRowid=$o(^User.MKBGlobalReferenceI("PassiveAliasIndex",MKBGlobalID,PassiveAliasID,"ICDCon",Conflag,0)) 
						if (MKBGRRowid="")
						{
							s eobj = ##class(web.Entity.MKB.MKBGlobalReference).%New()
							s eobj.InitiativeFlag="ICDCon"				//发起引用，主动引用标识
							s eobj.InitiativeID=Conflag				//发起引用词的ID
							s eobj.PassiveID=MKBGlobalID			//被引用词的ID
							s eobj.PassiveAliasID=PassiveAliasID			//被引用词的名称列表ID
							d ..SaveReferenceEntity(eobj)
						}
					}
				}
				
			}
			
		}
	}
	elseif(rangeStr=3)            //对词表内所有术语
	{
		s MKBGlobalID = 0
		for
		{
			s MKBGlobalID = $o(^User.MKBGlobalD(MKBGlobalID))
			q:MKBGlobalID=""
			//d ..CheckReferenceToDelete(MKBGlobalID)
			if (delflag'="")	//删除原先的医院引用或者各版本icd对照引用
			{
				//删除已经存在的ICD匹配引用场景
				d ..DelICDMatchRef(MKBGlobalID,"ICDSD")
				d ..DelICDMatchRef(MKBGlobalID,"ICDCon")
			}
			
			s MKBGloAliasDesc=""
			for
			{
				s MKBGloAliasDesc = $o(^User.MKBGloAliasI("DescIndex",MKBGlobalID,MKBGloAliasDesc))
				q:MKBGloAliasDesc=""
				s PassiveAliasID=$o(^User.MKBGloAliasI("DescIndex",dataID,MKBGloAliasDesc,""))
				if (methodStr["1")		//数据处理工厂
				{
					s base=""
					for
					{
						s base=$o(^User.MKBStructuredDataI("MKBSDDiagIndex",base))
						q:base=""
						continue:((base'=3)&&(base'=9))		//医大一或者港大
						s SDflag = ..RefHandleStructuredBase(base,MKBGloAliasDesc)
						if (SDflag'="N")          //返回结果不为"N" 说明完全匹配到ICD 则添加到该dataID的引用场景下
						{
							s MKBGRRowid=$o(^User.MKBGlobalReferenceI("PassiveAliasIndex",MKBGlobalID,PassiveAliasID,"ICDSD",SDflag,0)) 
							if (MKBGRRowid="")
							{
								s eobj = ##class(web.Entity.MKB.MKBGlobalReference).%New()
								s eobj.InitiativeFlag="ICDSD"				//发起引用，主动引用标识
								s eobj.InitiativeID=SDflag				//发起引用词的ID
								s eobj.PassiveID=MKBGlobalID			//被引用词的ID
								s eobj.PassiveAliasID=PassiveAliasID			//被引用词的名称列表ID
								d ..SaveReferenceEntity(eobj)
							}
							
						}
					}
				}
				if (methodStr["2")		//各版本icd
				{
					s Conflag = ..RefHandleICDCon(MKBGloAliasDesc)   //去调用匹配医大一ICD的方法
					if (Conflag'="N")          //返回结果不为"N" 说明完全匹配到ICD 则添加到该dataID的引用场景下
					{
						s MKBGRRowid=$o(^User.MKBGlobalReferenceI("PassiveAliasIndex",MKBGlobalID,PassiveAliasID,"ICDCon",Conflag,0)) 
						if (MKBGRRowid="")
						{
							s eobj = ##class(web.Entity.MKB.MKBGlobalReference).%New()
							s eobj.InitiativeFlag="ICDCon"				//发起引用，主动引用标识
							s eobj.InitiativeID=Conflag				//发起引用词的ID
							s eobj.PassiveID=MKBGlobalID			//被引用词的ID
							s eobj.PassiveAliasID=PassiveAliasID			//被引用词的名称列表ID
							d ..SaveReferenceEntity(eobj)
						}
					}
				}
			}
		}
	}
	q "success"
}

/// 引用处理 数据和医大一ICD进行匹配处理
/// 入参为需要进行匹配的诊断描述 
/// 输出 未匹配  已匹配 （匹配到的数据id）
/// w ##class(web.DHCBL.MKB.MKBGlobal).RefHandleYDY(" 胃恶性肿瘤")
ClassMethod RefHandleYDY(MKBGloAliasDesc As %String)
{
	if ($d(^User.MKBStructuredDataI("MKBSDDiagIndex",3,MKBGloAliasDesc)))   //说明医大一数据处理工厂中存在该数据
	{
		s MKBSDID = $o(^User.MKBStructuredDataI("MKBSDDiagIndex",3,MKBGloAliasDesc,0))
		s MKBSDICD = $lg($g(^User.MKBStructuredDataD(MKBSDID)),20)
		q:MKBSDICD="" "N"
		q:MKBSDICD'="" MKBSDID
	}
	else
	{
		q "N"
	}
}

/// 引用处理 数据和ICD2.0进行匹配处理
/// 入参为需要进行匹配的诊断描述 
/// 输出 未匹配  已匹配 （匹配到的数据id）
/// w ##class(web.DHCBL.MKB.MKBGlobal).RefHandleICDCon(" 嘌呤和嘧啶代谢紊乱")
ClassMethod RefHandleICDCon(MKBGloAliasDesc As %String)
{
	q:MKBGloAliasDesc="" "N"
	s TermBaseID =$o(^User.MKBTermBaseI("DescIndex"," ICD版本",0))
	q:TermBaseID="" "N"
	s ICDSource =$o(^User.MKBTermI("DescIndex",TermBaseID," 疾病分类与代码国家临床版2.0",0)) 
	q:ICDSource="" "N"
	s MKBConID="N"
	
	s ICDContrastDesc=""
	for
	{
		s ICDContrastDesc=$o(^User.MKBICDContrastI("DescIndex",ICDContrastDesc))
	
		q:ICDContrastDesc=""
		
		
		s NewDesc = ##class(web.DHCBL.BDP.FunLib).AutoSBDB(ICDContrastDesc,0)		//全角转半角
		s NewDesc=..SpaceHandleMethod1(NewDesc)
		s NewDesc=..SpaceHandleMethod2(NewDesc)
		s NewDesc=..SpaceHandleMethod3(NewDesc)
		s NewDesc=" "_NewDesc
		if (MKBGloAliasDesc=NewDesc)
		{
			s MKBConID = $o(^User.MKBICDContrastI("DescIndex",ICDContrastDesc,""))
			s MKBICDDiaSource=$lg($g(^User.MKBICDContrastD(MKBConID)),6) //来源标识
			continue:MKBICDDiaSource'[ICDSource
			q:MKBConID'=""
		}
	}
	
	q MKBConID
}

/// Creator:范文凯
/// CreatDate:2020-04-02
/// Description:删除名称列表内数据 会触发删除相对应的引用场景的数据
/// Input：AliasDesc 别名描述 ,Paref 术语id
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).DelAliasMathRef("2型糖尿病","1974")
ClassMethod DelAliasMathRef(AliasDesc As %String, Paref As %String)
{
	s MKBSDID = 0
	s MKBConID = 0
	for
	{
		s MKBSDID = $o(^User.MKBGlobalReferenceI("InverAllIndex",Paref,"ICDSD",MKBSDID))
		q:MKBSDID=""
		s MKBSDDesc = $lg($g(^User.MKBStructuredDataD(MKBSDID)),2)  //获得Desc
		if (AliasDesc=MKBSDDesc)
		{
			s MKBGloRefID = $o(^User.MKBGlobalReferenceI("InverAllIndex",Paref,"ICDSD",MKBSDID,0))
			d ..DeleteReferenceData(MKBGloRefID)
		}
	}
	for
	{
		s MKBConID = $o(^User.MKBGlobalReferenceI("InverAllIndex",Paref,"ICDCon",MKBConID))
		q:MKBConID=""
		s MKBConDesc = $lg($g(^User.MKBICDContrastD(MKBConID)),3)  //获得Desc
		if (AliasDesc=MKBConDesc)
		{
			s MKBGloRefID = $o(^User.MKBGlobalReferenceI("InverAllIndex",Paref,"ICDCon",MKBConID,0))
			d ..DeleteReferenceData(MKBGloRefID)
		}
	}
	q ""
}

/// Creator:范文凯
/// CreatDate:2020-04-02
/// Description:合并术语时 术语开立频次进行累加
/// Input：被合并的ID串
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).MergeDiagFreq("1868,2294")
ClassMethod MergeDiagFreq(RowIdStr As %String)
{
	s strlen=$l(RowIdStr,",")
	s ToRowId=$p(RowIdStr,",",1)
	for i=2:1:strlen
	{
		s FromRowId=$p(RowIdStr,",",i)
	    s LocID = 0
	    for
	    {
		    s LocID = $o(^User.MKBGDiagLocI("ProfDeptDRIndex",FromRowId,LocID))
		    q:LocID=""
		    //判断ToRowId下是否存在该科室
		    if $d(^User.MKBGDiagLocI("ProfDeptDRIndex",ToRowId,LocID))
		    {
			    s FormFreqID = $o(^User.MKBGDiagLocI("ProfDeptDRIndex",FromRowId,LocID,0))
			    s FromFreq = $lg($g(^User.MKBGDiagLocD(FormFreqID)),4)
			    s ToFreqID = $o(^User.MKBGDiagLocI("ProfDeptDRIndex",ToRowId,LocID,0))
			    s obj = ##class(User.MKBGDiagLoc).%OpenId(ToFreqID)
			    s obj.Frequency = obj.Frequency+FromFreq
			    s sc = obj.%Save()
			    d obj.%Close()
			    if $$$ISOK(sc)
			    {
				    d ..DelDiagLocData(FormFreqID)	//删除科室信息
				    s MKBGDiaTotalFreq = $lg($g(^User.MKBGlobalD(ToRowId)),11)
				    s MKBGDiaTotalFreq=MKBGDiaTotalFreq+FromFreq
				    
					d ..SaveGlobalLog(ToRowId, "", "","","", "", "", MKBGDiaTotalFreq)	//修改频率

				}
			}
			else
			{
				s FormFreqID = $o(^User.MKBGDiagLocI("ProfDeptDRIndex",FromRowId,LocID,0))
			    s FromFreq = $lg($g(^User.MKBGDiagLocD(FormFreqID)),4)
				s obj = ##class(User.MKBGDiagLoc).%New()
				d obj.DiaDRSetObjectId(ToRowId)
				d obj.ProfDeptDRSetObjectId(LocID)
				s obj.Frequency = FromFreq
				s sc = obj.%Save()
			    d obj.%Close()
			    if $$$ISOK(sc)
			    {
				    d ..DelDiagLocData(FormFreqID)		//删除科室信息
				    s MKBGDiaTotalFreq = $lg($g(^User.MKBGlobalD(ToRowId)),11)
				    s MKBGDiaTotalFreq=MKBGDiaTotalFreq+FromFreq
				    
					d ..SaveGlobalLog(ToRowId, "", "","","", "", "", MKBGDiaTotalFreq)	//修改频率
				}
			}
		}
	}
	q ""
}

/// Creator:范文凯
/// CreatDate:2020-04-07
/// Description:删除ICD匹配的引用场景
/// Input：被合并的ID串
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).DelICDMatchRef()
ClassMethod DelICDMatchRef(ID As %String, InitiativeFlag As %String)
{
	s InitiativeID = ""
	for
	{
		s InitiativeID = $o(^User.MKBGlobalReferenceI("InverAllIndex",ID,InitiativeFlag,InitiativeID))
		q:InitiativeID=""
		s MKBGRefID=""
		for
		{
			s MKBGRefID = $o(^User.MKBGlobalReferenceI("InverAllIndex",ID,InitiativeFlag,InitiativeID,MKBGRefID))
			q:MKBGRefID=""
			d ..DeleteReferenceData(MKBGRefID)		//删除引用
		}
	}
	q ""
}

/// Creator:范文凯
/// CreatDate:2020-04-08
/// Description:全局化词表名称列表维护功能 修改某描述为中心词
/// Input：全局化词表ID，Sequence，别名表id
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).SetHeadWord("1868,2294")
ClassMethod SetHeadWord(ParRef As %String, AliasDesc As %String)
{
	s AliasID = 0 
	if ($d(^User.MKBGloAliasI("MarkIndex",ParRef," 中心词")))    //判断该术语下是否已经存在中心词
	{
		s AliasID = $o(^User.MKBGloAliasI("MarkIndex",ParRef," 中心词",0))
		s returndesc =$lg($g(^User.MKBGlobalD(ParRef,"ChildGloAlias",AliasID)),2)
		
		d ..SaveAliasLog(ParRef, AliasID, AliasDesc, "", "", "", "", "", "")	//修改别名
		d ..SaveGlobalLog(ParRef, AliasDesc, "","","", "", "", "")	//修改术语描述

	}
	q returndesc
}

/// Creator:范文凯
/// CreatDate:2020-04-13
/// Description:遍历一个中心词下的名称列表 去和临床实用诊断做完全匹配
/// Input：全局化词表ID
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).AliasMatchDiag("898")
ClassMethod AliasMatchDiag(MKBGlobalID As %String)
{
	s result=""
	s MKBGloAliasSeq = 0
	for
	{
		s MKBGloAliasSeq = $o(^User.MKBGloAliasI("SeqIndex",MKBGlobalID,MKBGloAliasSeq))
		q:MKBGloAliasSeq=""
		s MKBGloAliasDesc = $o(^User.MKBGloAliasI("SeqIndex",MKBGlobalID,MKBGloAliasSeq,0))
		if (MKBGloAliasDesc'="")		//别名不为空
		{
			s MKBGloAliasDesc =  $Zstrip(MKBGloAliasDesc,"<>W")
			s MKBGloAliasDesc=$ZCONVERT(MKBGloAliasDesc,"U")
			s MKBTSeq = 0
			for
			{
				s MKBTSeq= $o(^User.MKBTermI("SeqIndex",5,MKBTSeq))
				q:MKBTSeq=""
				s MKBTRowId=$o(^User.MKBTermI("SeqIndex",5,MKBTSeq,0))
				continue:MKBTRowId=""
				s strAlias=##class(web.DHCBL.MKB.MKBTermProperty).GetComOrAlias(MKBTRowId)  
				s MKBTDescU = $ZCONVERT($listGet($g(^User.MKBTermD(MKBTRowId)),3),"U")
				s MKBTPYCodeU = $ZCONVERT($listGet($g(^User.MKBTermD(MKBTRowId)),6),"U")
				s aliasDesc=$p(strAlias,"||",1)  //常用名、别名
				s aliasKey=$p(strAlias,"||",2)  //常用名、别名检索码
				s aliasDescU=$ZCONVERT(aliasDesc,"U")
				s aliasKeyU=$ZCONVERT(aliasKey,"U")
				if ((MKBTDescU[MKBGloAliasDesc)||(MKBTPYCodeU[MKBGloAliasDesc)||(aliasDescU[MKBGloAliasDesc)||(aliasKeyU[MKBGloAliasDesc))  //条件
				{
					if (result'[MKBTRowId)
					{
						s result=result_MKBTRowId_","
					}
				}
			}
		}
	}
	s result=$e(result,0,*-1)
	q result
}

/// Creator:范文凯
/// CreatDate:2020-04-13
/// Description:遍历一个中心词下的名称列表 去和临床实用诊断做完全匹配
/// Input：全局化词表ID
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).AliasDescMatchDiag("肺炎")
ClassMethod AliasDescMatchDiag(Desc As %String)
{
	s result= "["
	s Desc = $ZCONVERT(Desc,"U")
	s MKBTSeq = 0
	for
	{
		s MKBTSeq= $o(^User.MKBTermI("SeqIndex",5,MKBTSeq))
		q:MKBTSeq=""
		s MKBTRowId=""
		for
		{
			s MKBTRowId=$o(^User.MKBTermI("SeqIndex",5,MKBTSeq,MKBTRowId))
			q:MKBTRowId=""
			
			s strAlias=##class(web.DHCBL.MKB.MKBTermProperty).GetComOrAlias(MKBTRowId)  
			s MKBTDesc = $listGet($g(^User.MKBTermD(MKBTRowId)),3)
			s MKBTDescU = $ZCONVERT(MKBTDesc,"U")
			
			s aliasDesc=$p(strAlias,"||",1)  //常用名、别名

			s aliasDescU=$ZCONVERT(aliasDesc,"U")
			if ((MKBTDescU=Desc)||(aliasDescU=Desc))  //条件
			{
				s MKBTPRowId=$o(^User.MKBTermPropertyI("DescIndex",MKBTRowId," 常用诊断表达式",0))
				if (result'[MKBTRowId)
				{
					s result=result_"{MKBTRowId:'"_MKBTRowId_"',MKBTDesc:'"_MKBTDesc_"',MKBTPRowId:'"_MKBTPRowId_"'},"
				}
			}
		}
		
	}
	s:result'="[" result=$e(result,0,*-1)
	q result_"]"
}

/// Creator:钟荣枫
/// CreatDate:2020-04-13
/// Description:遍历一个中心词下的名称列表 去和临床实用诊断做匹配
/// Input：全局化词表描述
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).AliasDescMatchDiag2("糖尿病","15879#胰岛内分泌异常性糖尿病")
ClassMethod AliasDescMatchDiag2(Desc As %String, StructValue As %String = "")
{
	s result= ""
	q:Desc="" ""
	s TermDR=""
	s DetailValue=""
	s MatchID=""
	if (StructValue="")
	{
		s StructValue=..GetStructValueByDesc(Desc,1)
	}
	s StructStr=$p(StructValue,"#",1)
	s StructDesc=$p(StructValue,"#",2)
	
	if (StructValue="")
	{
		q ""
	}
	elseif (StructValue["-")
	{
		s TermDR=$p(StructStr,"-",1)
		s DetailValue=$p(StructStr,"-",2)
		//s StructDesc=$p(StructValue,"-",3)
	}
	else
	{
		s TermDR=StructStr
		s DetailValue=""
		//s MatchID=""
	}
	if (TermDR'="")		//中心词不为空
	{
		s MKBTDesc = $listGet($g(^User.MKBTermD(TermDR)),3)
		s MKBTActiveFlag=$listGet($g(^User.MKBTermD(TermDR)),9)
		if (MKBTActiveFlag'="N")	//过滤封闭
		{
			s MKBTPRowId=$o(^User.MKBTermPropertyI("DescIndex",TermDR," 常用诊断表达式",0))
			s result=MKBTPRowId_"^"_MKBTDesc_"^"_StructStr_"#"_StructDesc
		}
	}
	q result
}

/// Creator:范文凯
/// CreatDate:2020-04-13
/// Description:遍历一个中心词下的名称列表 去和临床实用诊断做完全匹配
/// Input：全局化词表ID
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).AliasDescMatchDiag("胰岛内分泌异常性糖尿病")
ClassMethod AliasDescMatchDiag1(Desc As %String)
{
	s result= "["
	s Desc = $ZCONVERT(Desc,"U")
	s MKBTSeq = 0
	for
	{
		s MKBTSeq= $o(^User.MKBTermI("SeqIndex",5,MKBTSeq))
		q:MKBTSeq=""
		s MKBTRowId=$o(^User.MKBTermI("SeqIndex",5,MKBTSeq,0))
		continue:MKBTRowId=""
		s strAlias=##class(web.DHCBL.MKB.MKBTermProperty).GetComOrAlias(MKBTRowId)  
		s MKBTDesc = $listGet($g(^User.MKBTermD(MKBTRowId)),3)
		s MKBTDescU = $ZCONVERT($listGet($g(^User.MKBTermD(MKBTRowId)),3),"U")
		
		s aliasDesc=$p(strAlias,"||",1)  //常用名、别名
	
		s aliasDescU=$ZCONVERT(aliasDesc,"U")
	
		if ((MKBTDescU=Desc)||(aliasDescU=Desc))  //条件
		{
			s MKBTPRowId=$o(^User.MKBTermPropertyI("DescIndex",MKBTRowId," 常用诊断表达式",0))
			
			if (result'[MKBTRowId)
			{
				s result=result_"{MKBTRowId:'"_MKBTRowId_"',MKBTDesc:'"_MKBTDesc_"',MKBTPRowId:'"_MKBTPRowId_"'},"
			}
		}
	}
	s:result'="[" result=$e(result,0,*-1)
	q result_"]"
}

/// Creator:范文凯 钟荣枫
/// CreatDate:2020-04-15
/// Description:保存(新增/修改)数据 指定名称列表的数据引用场景指定为常用诊断表达式
/// Input：MKBGlobalID(User.MKBGloAlias表的RowID) , MKBTPDRowId(User.MKBTermProDetail表的RowID) ，RefRowID 同一诊断表达式引用的id   ,Type（EditObj/AddObj）
/// Output: 保存成功输出{success:'true'}，保存失败输出{success:'false'}
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).SaveReference("200533||205653","2308121","2670561","EditObj")
ClassMethod SaveReference(AliasID As %String, MKBTPDRowId As %String, RefRowID As %String)
{
	s result=""
	                                                  //修改引用对象  对应前台自检后触发修改发起引用对象
	
	s PassiveID = $p(AliasID,"||",1)
	s PassiveAliasID = $p(AliasID,"||",2)
	s MKBGAMark = $lg($g(^User.MKBGlobalD(PassiveID,"ChildGloAlias",PassiveAliasID)),8)

	if (RefRowID="")		//没有一致的诊断表达式引用
	{
		s RefRowID=$o(^User.MKBGlobalReferenceI("PassiveAliasIndex",PassiveID,PassiveAliasID,"D",""))
		s ReferenceID=""
		s:RefRowID'="" ReferenceID=$o(^User.MKBGlobalReferenceI("PassiveAliasIndex",PassiveID,PassiveAliasID,"D",RefRowID,""))
	}
	else
	{
		//Index PassiveAliasIndex On (PassiveID As Exact, PassiveAliasID As Exact, InitiativeFlag As Exact, InitiativeID As Exact);

		s ReferenceID=ReferenceID=$o(^User.MKBGlobalReferenceI("PassiveAliasIndex",PassiveID,PassiveAliasID,"D",RefRowID,""))
	}
	
	s eobj = ##class(web.Entity.MKB.MKBGlobalReference).%New()
	s eobj.MKBGRRowid = ReferenceID
	
	s eobj.InitiativeFlag="D"				//发起引用，主动引用标识
	s eobj.InitiativeID=MKBTPDRowId				//发起引用词的ID
	s eobj.PassiveID=PassiveID			//被引用词的ID
	s eobj.PassiveAliasID=PassiveAliasID				//被引用词的名称列表ID
	s result= ..SaveReferenceEntity(eobj)
	
	q result
}

/// Creator:范文凯
/// CreatDate:2020-04-17
/// Description:全局化词表常用诊断表达式引用后的自检方法
/// Input：GlobalID(User.MKBGlobal表的RowID),RefMKBTPDID(被引用的常用诊断表达式的id)
/// Output: 存在同名对象返回存在为ture+同名数据的ID{exist:'ture',MKBGARowId:'"_GlobalID_"||"_MKBGloAliasID_"'},不存在同名对象则返回false
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).SelfTestAftExpRef("200533||205653","2308121")
ClassMethod SelfTestAftExpRef(AliasID As %String, RefMKBTPDID As %String)
{
	s result=""
	
	s GlobalID=$P(AliasID,"||",1)
	S AliasRowID=$P(AliasID,"||",2)
	
	//Index AllIndex On (InitiativeFlag As Exact, InitiativeID As Exact, PassiveID As Exact);
	s MergeStr=""
	
	s PassiveID=""
	for
	{
		s PassiveID=$o(^User.MKBGlobalReferenceI("AllIndex",RefMKBTPDID,PassiveID))
		q:PassiveID=""
		continue:(GlobalID=PassiveID)
		if (MergeStr="")
		{
			s MergeStr=PassiveID
		}
		else
		{
			s MergeStr=MergeStr_","_PassiveID
		}
		
	}
	
	s TProRowId=$lg($g(^User.MKBTermProDetailD(RefMKBTPDID)),6)         //属性RowID
	if (TProRowId'="")
	{
		s subId=$o(^User.MKBTermPropertyD(TProRowId,"ChildExtPro",""))
		if (subId'="")
		{
			s MKBTEPRowId=TProRowId_"||"_subId  //扩展属性表的ID
		    s MKBTEPVValueStr=##class(web.DHCBL.MKB.MKBTermProDetail).GetExtendProValValue(TProRowId,subId,RefMKBTPDID)
			s MKBTEPVValue=$p(MKBTEPVValueStr,"[A]",2)		//结构化表达式
			s SameProValValueIDStr= ##class(web.DHCBL.MKB.MKBTermProDetail).GetSameProValValueID(TProRowId,MKBTEPVValue)
			
			if (SameProValValueIDStr'="")	//同表达式的常用诊断表达式的id串
			{
				for m1=1:1:$l(SameProValValueIDStr,",")
				{
					s InitiativeID=$p(SameProValValueIDStr,",",m1)
					continue:InitiativeID=""
					continue:(InitiativeID=RefMKBTPDID)
					s PassiveID=""
					for
					{
						s PassiveID=$o(^User.MKBGlobalReferenceI("AllIndex",InitiativeID,PassiveID))
						q:PassiveID=""
						continue:(GlobalID=PassiveID)
						if (MergeStr="")
						{
							s MergeStr=PassiveID
						}
						else
						{
							s MergeStr=MergeStr_","_PassiveID
						}
						
					}
					
				}
			}
		}
	}
	
	
	if (MergeStr'="")	//需要提示合并
	{
		s MergeStr=MergeStr_","_GlobalID
		s result = "{exist:'true',MergeStr:'"_MergeStr_"'}"
	}
	else
	{
		//Index PassiveAliasIndex On (PassiveID As Exact, PassiveAliasID As Exact, InitiativeFlag As Exact, InitiativeID As Exact);
		s InitiativeID=$o(^User.MKBGlobalReferenceI("PassiveAliasIndex",GlobalID,AliasRowID,"D",""))	//获取这个别名的常用诊断表达式引用
		if (InitiativeID'="")
		{
			
			if (InitiativeID=RefMKBTPDID)	
			{
				s result = "{exist:'true',errorinfo:'已存在相同诊断表达式！',id:'"_InitiativeID_"'}"
			}
			else
			{
				s result = "{exist:'true',errorinfo:'诊断表达式重名！',id:'"_InitiativeID_"'}"
			}
		}
	}
	s:result="" result = "{exist:'false'}"
    q result
}

/// Creator：范文凯 
/// CreatDate: 2020-04-17
/// Description：获取全局化词表数据For NLP
/// Input: GlobalRowId-全局化词表RowID
/// Table：User.MKBGlobalReference
/// d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBGlobal","ImportDataToNLP")
Query ImportDataToNLP() As %Query(ROWSPEC = "中心词,标记,名称列表,频次")
{
}

ClassMethod ImportDataToNLPExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s MKBGlobalID=0
	for
	{
		s MKBGlobalID=$o(^User.MKBGlobalD(MKBGlobalID))
		q:MKBGlobalID=""
		s 中心词 = $lg($g(^User.MKBGlobalD(MKBGlobalID)),3)
		s 标记 = $lg($g(^User.MKBGlobalD(MKBGlobalID)),10)
		s 频次 = $lg($g(^User.MKBGlobalD(MKBGlobalID)),11)
		s MKBGPDDesc = ""
		s tmpid=0
	    for
	    {
		    s tmpid = $o(^User.MKBGloAliasI("SeqIndex",MKBGlobalID,tmpid))
		    q:tmpid=""
		    s tmpdesc = $o(^User.MKBGloAliasI("SeqIndex",MKBGlobalID,tmpid,0))
		    s tmpdesc = $Zstrip(tmpdesc,"<>W")   
		    s MKBGPDDesc=MKBGPDDesc_tmpdesc_"，"
		}
		s 名称列表 = $e(MKBGPDDesc,0,*-1)
		d OutputRow
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(中心词,标记,名称列表,频次)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod ImportDataToNLPClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetReferenceListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ImportDataToNLPFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ImportDataToNLPExecute ]
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

/// Creator：范文凯 、钟荣枫
/// CreatDate: 2020-04-27
/// Description：修改MKBGloAlias表中的MKBGAMark字段
/// Input: 前台暂不支持导出字段的内容配置 暂无入参
/// Output: 全局化词表 "中心词,标记,名称列表,频次" 数据
/// w ##class(web.DHCBL.MKB.MKBGlobal).EditMKBGAMark("265132||316445","别名,查询名")
ClassMethod EditMKBGAMark(MKBGARowId As %String, MKBGAMark As %String)
{
	s result=""
	s SaveMark = MKBGAMark
	s MKBGlobalID = $p(MKBGARowId,"||",1)
	s MKBGAID = $p(MKBGARowId,"||",2)
	s OlMKBGADesc=$lg($g(^User.MKBGlobalD(MKBGlobalID,"ChildGloAlias",MKBGAID)),2)
	s OlMKBGAMark = $lg($g(^User.MKBGlobalD(MKBGlobalID,"ChildGloAlias",MKBGAID)),8)
	
	//s eobj = ##class(User.MKBGloAlias).%OpenId(MKBGARowId)           //修改User.MKBGloAlias 表的 MKBGMArk 标记字段
	//s eobj.MKBGADesc=$Replace(eobj.MKBGADesc," ","")
	s AliasName =" "_$ZCONVERT(OlMKBGADesc,"U")
	s OldMKbGAMark = OlMKBGAMark
	s Marklen = $l(MKBGAMark,",")
	for Marki=1:1:Marklen
	{
		s MarkStr = $p(MKBGAMark,",",Marki)
		continue:OldMKbGAMark[MarkStr            //本来就存在的标记无需做触发
		if (MarkStr="临床实用诊断")         //如果修改标记为临床实用诊断
		{
			if ($d(^User.MKBTermI("DescIndex",5,AliasName)))
			{
				s MKBTermID = $o(^User.MKBTermI("DescIndex",5,AliasName,0))
				//s eobj.MKBGAMark = MKBGAMark
				//完成标志的修改 并且要出发引用表新增指向
				//判断是否已经存在该引用
				if '$d(^User.MKBGlobalReferenceI("InverAllIndex",MKBGlobalID,"T",MKBTermID))
				{
					s MKBTActiveFlag=$listGet($g(^User.MKBTermD(MKBTermID)),9)
					if (MKBTActiveFlag'="N")	//临床实用诊断未被封闭
					{
						s nobj = ##class(web.Entity.MKB.MKBGlobalReference).%New()
			
						s nobj.InitiativeFlag="T"				//发起引用，主动引用标识
						s nobj.InitiativeID=MKBTermID				//发起引用词的ID
						s nobj.PassiveID=MKBGlobalID			//被引用词的ID
						s nobj.PassiveAliasID=MKBGAID				//被引用词的名称列表ID
						d ..SaveReferenceEntity(nobj)
						
					
					}
					else
					{
						s SaveMark=##class(web.BDP.util.String).Replace(SaveMark,"临床实用诊断,","")
						s SaveMark=##class(web.BDP.util.String).Replace(SaveMark,",临床实用诊断","")
						s SaveMark=##class(web.BDP.util.String).Replace(SaveMark,"临床实用诊断","")
						s result = "{success:'false',info:'该临床实用诊断已被封闭',type:'Term'}"
					}
				}
				//s result= "{success:'true'}"
			}
			else
			{
				//临床实用诊断未能匹配上 标记不能赋值临床实用诊断
				s SaveMark=##class(web.BDP.util.String).Replace(SaveMark,"临床实用诊断,","")
				s SaveMark=##class(web.BDP.util.String).Replace(SaveMark,",临床实用诊断","")
				s SaveMark=##class(web.BDP.util.String).Replace(SaveMark,"临床实用诊断","")
				s result = "{success:'false',info:'临床实用诊断术语集中不存在该名称描述',type:'Term'}"
			}
		}
		elseif(MarkStr="ICD诊断")
		{
			//去各版本icd搜索匹配
			s SDflag = ..RefHandleYDY(AliasName)   //去调用匹配医大一ICD的方法
			if (SDflag'="N")          //返回结果不为"N" 说明完全匹配到ICD 则添加到该dataID的引用场景下
			{
				if ('$d(^User.MKBGlobalReferenceI("InverAllIndex",MKBGlobalID,"ICDSD",SDflag)))
				{
					s obj = ##class(web.Entity.MKB.MKBGlobalReference).%New()
			
					s obj.InitiativeFlag=SDflag				//发起引用，主动引用标识
					s obj.InitiativeID=MKBTermID				//发起引用词的ID
					s obj.PassiveID=MKBGlobalID			//被引用词的ID
					s obj.PassiveAliasID=MKBGAID				//被引用词的名称列表ID
					d ..SaveReferenceEntity(obj)
				}
			}
			s Conflag = ..RefHandleICDCon(AliasName)   //去调用匹配医大一ICD的方法
			if (Conflag'="N")          //返回结果不为"N" 说明完全匹配到ICD 则添加到该dataID的引用场景下
			{
				if ('$d(^User.MKBGlobalReferenceI("InverAllIndex",MKBGlobalID,"ICDCon",Conflag)))
				{
					s obj = ##class(web.Entity.MKB.MKBGlobalReference).%New()
			
					s obj.InitiativeFlag="ICDCon"			//发起引用，主动引用标识
					s obj.InitiativeID=Conflag				//发起引用词的ID
					s obj.PassiveID=MKBGlobalID			//被引用词的ID
					s obj.PassiveAliasID=MKBGAID				//被引用词的名称列表ID
					d ..SaveReferenceEntity(obj)
					
				}
			}
			if ((SDflag="N")&&(Conflag="N"))         //都没匹配上
			{
				s SaveMark=##class(web.BDP.util.String).Replace(SaveMark,"ICD诊断,","")
				s SaveMark=##class(web.BDP.util.String).Replace(SaveMark,",ICD诊断","")
				s SaveMark=##class(web.BDP.util.String).Replace(SaveMark,"ICD诊断","")
				s result= "{success:'false',info:'ICD术语集中不存在该描述',type:'ICD'}"
			}
			else
			{
				//q "{success:'true'}"
			}
			//去医大一ICD搜索匹配
		}
		elseif(MarkStr="展示名")
		{
			//判断该名称列表中是否已经存在展示名
			if $d(^User.MKBGloAliasI("DisplayName",MKBGlobalID," Y"))   //已经存在展示名
			{
				//获得该字段ID
				s aliasID = $o(^User.MKBGloAliasI("DisplayName",MKBGlobalID," Y",0))
				if (aliasID'="")
				{
					//获得所有的展示名id
					s aliasID = 0
					for
					{
						s aliasID=$o(^User.MKBGloAliasI("DisplayName",MKBGlobalID," Y",aliasID))
						q:aliasID=""
						s TSMKBGAMark = $lg($g(^User.MKBGlobalD(MKBGlobalID,"ChildGloAlias",aliasID)),8)
						s OldMarkStr = TSMKBGAMark
						s OldMarkStr=##class(web.BDP.util.String).Replace(OldMarkStr,"展示名,","")
						s OldMarkStr=##class(web.BDP.util.String).Replace(OldMarkStr,",展示名","")
						s OldMarkStr=##class(web.BDP.util.String).Replace(OldMarkStr,"展示名","")
						d ..SaveAliasLog(MKBGlobalID, aliasID, "", "", "", "", "", OldMarkStr, "N")
						
					}
				}
			}
			else
			{
				/*
				s TSMKBGAMark = $lg($g(^User.MKBGlobalD(MKBGlobalID,"ChildGloAlias",MKBGAID)),8)
				if (TSMKBGAMark'="")	//标志为空
				{
					s TSMKBGAMark=TSMKBGAMark_",展示名"
				}
				else
				{
					s TSMKBGAMark="展示名,查询名"
				}
				//d ..SaveAliasLog(MKBGlobalID, MKBGAID, "", "", "", "", "", TSMKBGAMark, "Y")
				
				*/
			}
			//d ..KeepSameDesc(MKBGlobalID)
		}
		elseif (MarkStr="别名")
		{
			if ((SaveMark["临床实用诊断")||((SaveMark["展示名")&&(SaveMark'["英文展示名")))	//去除悲鸣和导入待审核
			{
				s SaveMark=##class(web.BDP.util.String).Replace(SaveMark,"别名,","")
				s SaveMark=##class(web.BDP.util.String).Replace(SaveMark,",别名","")
				s SaveMark=##class(web.BDP.util.String).Replace(SaveMark,"别名","")
				s SaveMark=##class(web.BDP.util.String).Replace(SaveMark,"导入待审核,","")
				s SaveMark=##class(web.BDP.util.String).Replace(SaveMark,",导入待审核","")
				s SaveMark=##class(web.BDP.util.String).Replace(SaveMark,"导入待审核","")
			}
		}
	}
	
	if ((SaveMark["展示名")&&(SaveMark'["英文展示名")&&(SaveMark'["查询名"))	//展示名需要增加上查询名
	{
		s SaveMark=SaveMark_",查询名"
	}
	//s eobj.MKBGAMark=SaveMark
	s IsDisplayName=$lg($g(^User.MKBGlobalD(MKBGlobalID,"ChildGloAlias",MKBGAID)),9)
	if ((SaveMark["展示名")&&(SaveMark'["英文展示名"))	//是展示名，是否展示名标志为"Y“
	{
		s IsDisplayName="Y"
	}
	s re= ..SaveAliasLog(MKBGlobalID, MKBGAID, "", "", "", "", "", SaveMark, IsDisplayName)
	s:result="" result=re
	if (result="")	//修改成功
	{
		if ((SaveMark["展示名")&&(SaveMark'["英文展示名"))
		{
			d ..KeepSameDesc(MKBGlobalID)
		}
		q "{success:'true'}"
	}
	else
	{
		q result
	}
}

/// Creator：范文凯 
/// CreatDate: 2020-04-28
/// Description：获取诊断标记对应的诊断id串
/// Input: 前台暂不支持导出字段的内容配置 暂无入参
/// Output: 全局化词表 "中心词,标记,名称列表,频次" 数据
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).GetCheckedTagIdStr("常用诊断表达式")
ClassMethod GetCheckedTagIdStr(CheckedTagStr As %String)
{
	s CheckedTagIdStr =""
    s TermBaseID = $o(^User.MKBTermBaseI("DescIndex"," 全局化词表标记",0))
	s StrLength = $l(CheckedTagStr,",")
	for Stri=1:1:StrLength
	{
		s Tag = $p(CheckedTagStr,",",Stri)
		s Tagid = $o(^User.MKBTermI("DescIndex",TermBaseID," "_Tag,0))
		s CheckedTagIdStr = CheckedTagIdStr_Tagid_","
	}
	s CheckedTagIdStr=$e(CheckedTagIdStr,0,*-1)
	q CheckedTagIdStr
}

/// Creator:高姗姗
/// CreatDate:2019-09-05
/// Description:提供标记模板信息
/// return：标记模板信息Json拼串
/// w ##class(web.DHCBL.MKB.MKBGlobal).GetTagTemplate()
ClassMethod GetTagTemplate() As %String
{
	s modeJsonInfo=""	
	s baseTag=##class(web.DHCBL.MKB.MKBTermBase).GetIdByDesc("全局化词表标记")
	s parentcatdr=-100000000000000
	s mySeq=0
	for {
		s mySeq=$o(^User.MKBTermI("ParSeqIndex",baseTag,parentcatdr,mySeq)) q:(mySeq="")
		s myRowID=0
		for {
			s myRowID=$o(^User.MKBTermI("ParSeqIndex",baseTag,parentcatdr,mySeq,myRowID)) q:(myRowID="")
			s MKBTDesc=$LISTGET($G(^User.MKBTermD(myRowID)),3)   ///中心词
			s MKBTDesc=$Replace(MKBTDesc,"""","")
			s MKBTDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTDesc)
			s PropertyId=$o(^User.MKBTermPropertyI("DescIndex",myRowID," 单选多选配置",0)) //属性id
			s DetailId=$o(^User.MKBTermProDetailI("ProIdx",PropertyId,0))
			s choiceType="" 
			s:DetailId'="" choiceType=$LISTGET($G(^User.MKBTermProDetailD(DetailId)),3)
			s str="{""catRowId"": """_myRowID_""",""catDesc"": """_MKBTDesc_""",""choiceType"": """_choiceType_"""}"
		    i modeJsonInfo="" s modeJsonInfo=str
			e  s modeJsonInfo=modeJsonInfo_","_str
		}
	}
	s:modeJsonInfo'="" modeJsonInfo="["_modeJsonInfo_"]"
	//s modeJsonInfo ="[{""catRowId"": ""65672"",""catDesc"": ""时效"",""choiceType"": """"},{""catRowId"": ""65654"",""catDesc"": ""程度"",""choiceType"": """"},{""catRowId"": ""65661"",""catDesc"": ""优先级"",""choiceType"": """"},{""catRowId"": ""65658"",""catDesc"": ""状态"",""choiceType"": """"},{""catRowId"": ""65664"",""catDesc"": ""业务"",""choiceType"": """"},{""catRowId"": ""129655"",""catDesc"": ""场景"",""choiceType"": """"},{""catRowId"": ""129661"",""catDesc"": ""诊断关系"",""choiceType"": """"}]"
	q modeJsonInfo
}

/// Creator：高姗姗
/// CreatDate: 2019-09-04
/// Description：获取诊断标记列表
/// Table：User.MKBTerm
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.SDSDiagnos","GetTagList","","")
Query GetTagList(desc As %String, parentid As %String) As %Query(ROWSPEC = "id,text")
{
}

ClassMethod GetTagListExecute(ByRef qHandle As %Binary, desc As %String, parentid As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 	;先取频次表数据
 	k ^TMPTAGFREQ("TagRowId")
 	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
 	
 	if $d(%session) s LocID = $Get(%session.Data("LOGON.CTLOCID"))
 	;s LocID="95"
	s BDPDAFFrequency=""
	for
	{
		s BDPDAFFrequency=$o(^User.BDPDataFrequencyI("TableLocFreqIdx"," USER.SDSTAG",LocID,BDPDAFFrequency),-1) q:BDPDAFFrequency="" 
		s RowId=""
		for
		{
			s RowId=$o(^User.BDPDataFrequencyI("TableLocFreqIdx"," USER.SDSTAG",LocID,BDPDAFFrequency,RowId),-1) q:RowId="" 
			s text=$listget($g(^User.BDPDataFrequencyD(RowId)),4)        /// 对应表数据描述 节点 4
			s id=$listget($g(^User.BDPDataFrequencyD(RowId)),3)          /// 对应表数据ID 节点 3  BDPDAFDataReference 
			s root=$p(id,"#",1)
			s tagid=$p(id,"#",2)
			s ^TMPTAGFREQ("TagRowId",tagid)=""
			s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(text)  
			if ((($ZCONVERT(text,"U")[desc)||(PINYIN[desc)||(desc=""))&((root=parentid)||(parentid=""))){
				d OutputRowTag
			}		
		}
	}
 	
 	;再取诊断标记中频次以外数据
	s baseTag=##class(web.DHCBL.MKB.MKBTermBase).GetIdByDesc("全局化词表标记")
	s rowid=""
	for
	{
		s rowid=$o(^User.MKBTermI("BaseIndex",baseTag,rowid)) q:rowid="" 

		s text=$LISTGET($G(^User.MKBTermD(rowid)),3)          
		s LastLevel=$LISTGET($G(^User.MKBTermD(rowid)),5)
		continue:(LastLevel="") //去除根节点
		continue:($d(^TMPTAGFREQ("TagRowId",rowid))) //去除频次表已有节点
		s root=..GetTagRoot(rowid)
		s id=root_"#"_rowid //根节点id#节点id
		s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(text)  
		if ((($ZCONVERT(text,"U")[desc)||(PINYIN[desc)||(desc=""))&((root=parentid)||(parentid=""))){
			d OutputRowTag
		}
		
	}

 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowTag
    set Data=$lb(id,text)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetTagListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTagListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetTagListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTagListExecute ]
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

/// Creator:高姗姗
/// CreatDate:2019-09-04
/// Description:获取已选标记的根节点
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnos).GetTagRoot(65674)
ClassMethod GetTagRoot(tagid) As %String
{
	s LastLevel=$LISTGET($G(^User.MKBTermD(tagid)),5)
	i LastLevel'="" d
	.s tagid=..GetTagRoot(LastLevel)
	q tagid
}

/// Creator:范文凯
/// CreatDate:2020-05-25
/// Description:批处理 标记为中心词的改为临床实用诊断 若无法匹配则修改标记为别名
/// Other: w ##class(web.DHCBL.MKB.MKBGlobal).EditAliasMark()
ClassMethod EditAliasMark()
{
	Ts 
	s parref = 0
	for
	{
		s parref = $o(^User.MKBGlobalD(parref))
		q:parref=""
		s AliasRowId=0
		for
		{
			s AliasRowId=$o(^User.MKBGlobalD(parref,"ChildGloAlias",AliasRowId))    //根据父表ID遍历子表ID
			q:AliasRowId=""
			s MKBGARowId=parref_"||"_AliasRowId       //拼接子表ID
			s MKBGAMark = $lg($g(^User.MKBGlobalD(parref,"ChildGloAlias",AliasRowId)),8)
			if (MKBGAMark="中心词")
			{
				s result = ..EditMKBGAMark(MKBGARowId,"临床实用诊断")
				if (result'["true")
				{
					d ..EditMKBGAMark(MKBGARowId,"别名")
				}
				
			}
		}
	}
}

/// Creator：谢海睿 
/// CreatDate: 2020-05-29
/// Description：获取诊断标记对应的诊断id串
/// Input: id
/// Output: "消渴病$XKB^糖尿病$TNB
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).GetDisplayNameAndQueryName(8090)
ClassMethod GetDisplayNameAndQueryName(id As %String)
{
	s FinallyStr=""
	s AliasRowId=0
	for
	{
		s AliasRowId=$o(^User.MKBGlobalD(id,"ChildGloAlias",AliasRowId))    //根据父表ID遍历子表ID
		q:AliasRowId=""
		s MKBGADesc=$lg($g(^User.MKBGlobalD(id,"ChildGloAlias",AliasRowId)),2) //名称
		s MKBGAPYCode=$lg($g(^User.MKBGlobalD(id,"ChildGloAlias",AliasRowId)),3) //检索码
		s MKBGAState=$lg($g(^User.MKBGlobalD(id,"ChildGloAlias",AliasRowId)),6) //过滤合并
		s MKBGAMark = $lg($g(^User.MKBGlobalD(id,"ChildGloAlias",AliasRowId)),8)
		if (MKBGAState="M")
		{
			continue
		}
		if ((MKBGAMark["展示名")||(MKBGAMark["查询名")||(MKBGAMark["临床实用诊断"))
		{
			if (FinallyStr="")
			{
				s FinallyStr=MKBGADesc_"$"_MKBGAPYCode
			}
			else
			{
				s FinallyStr=FinallyStr_"^"_MKBGADesc_"$"_MKBGAPYCode
			}
			
		}
		else{
			continue
		}
		
		
		
	}
	q FinallyStr
}

/// Creator：谢海睿 
/// CreatDate: 2020-05-29
/// Description：获取全局化词表的展示名，没有展示名的取中心词
/// Output: "全局话词表的表名^ID^展示名"
/// Other:d ##class(web.DHCBL.MKB.MKBGlobal).InitialSaveMKBGlobalFreq()
ClassMethod InitialSaveMKBGlobalFreq()
{
	s FinallyStr=""
    s ID = 0
    for
    {
	    s ID = $o(^User.MKBGlobalD(ID))
	    q:ID=""
	    s MKBGRowId=ID
		s MKBGAlias=""
		s MKBGDisplaName=""
		s AliasId=0
		for
		{
			s AliasId=$o(^User.MKBGlobalD(MKBGRowId,"ChildGloAlias",AliasId))  //遍历别名表
			q:AliasId=""
			s AliasMark = $lg($g(^User.MKBGlobalD(MKBGRowId,"ChildGloAlias",AliasId)),8) 
		    if (AliasMark["展示名")
		    {
			    s MKBGDisplaName=$lg($g(^User.MKBGlobalD(MKBGRowId,"ChildGloAlias",AliasId)),2)   //展示名
		    }					
		}
        s:MKBGDisplaName="" MKBGDisplaName=$lg($g(^User.MKBGlobalD(MKBGRowId)),3)
		s FinallyStr="User.MKBGlobal"_"^"_MKBGRowId_"^"_MKBGDisplaName
	    d ##class(web.DHCBL.BDP.BDPDataHistory).SaveFH(FinallyStr)
	    
    }
}

/// Creator：钟荣枫
/// CreatDate: 2020-7-29
/// Description：为全局化词表 人工分词下拉检索框查询取数据 查找所有有临床实用诊断或常用诊断表达式引用的词 
/// Table：User.MKBGlobal
/// Input：matchflag 完全匹配,allflag 显示全部,q 查询内容
/// Return：ID,Desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBGlobal","GetTermForCmb1","","","心脏病")
Query GetTermForCmb1(matchflag, allflag, q As %String) As %Query(ROWSPEC = "ID,Desc")
{
}

ClassMethod GetTermForCmb1Execute(ByRef qHandle As %Binary, matchflag, allflag, q As %String) As %Status
{
	s repid=$I(^CacheTemp)	
	s ind=1
	
	s desc=$ZCONVERT(q,"U")
	
	s ID=""
    s Desc=""
    s combolimit=10,totalcount=0
    
	s MKBGFreq = " "
    for
    {
	    s MKBGFreq = $o(^User.MKBGlobalI("MKBGFreqIndex",MKBGFreq),-1)
	    q:MKBGFreq=""
	
	    s GlobalID = ""
	    for
	    {
		    s GlobalID = $o(^User.MKBGlobalI("MKBGFreqIndex",MKBGFreq,GlobalID))
		    q:GlobalID=""
		    s MKBGDesc=$lg($g(^User.MKBGlobalD(GlobalID)),3)
		    s MKBGMark=$lg($g(^User.MKBGlobalD(GlobalID)),10)
			
			//s StructIDS=..GetStructIDS(GlobalID,MKBGDesc)
		    s RefNum=0
			s InitiativeID=0
			for
			{
				s InitiativeID=$o(^User.MKBGlobalReferenceI("InverAllIndex",GlobalID,"T",InitiativeID))    //通过索引表获得引用者的ID
				q:InitiativeID=""
				s MKBTActiveFlag=$listGet($g(^User.MKBTermD(InitiativeID)),9)
				continue:(MKBTActiveFlag="N")	//过滤封闭
				s RefNum=RefNum+1
			}
			s ReferenceDD=$o(^User.MKBGlobalReferenceI("InverAllIndex",GlobalID,"D","")) //是否含有常用诊断表达式的引用
			
			continue:((ReferenceDD="")&&(RefNum=0))
			s ShowNameID=$o(^User.MKBGloAliasI("DisplayName",GlobalID," Y",0))
			s ShowName=""
			s:ShowNameID'="" ShowName=$lg($g(^User.MKBGlobalD(GlobalID,"ChildGloAlias",ShowNameID)),2)
			s AliasId=0
			
			s showDesc=""
			s showCount=0
			for
			{
				s AliasId=$o(^User.MKBGlobalD(GlobalID,"ChildGloAlias",AliasId))  //遍历别名表
				q:AliasId=""
				s AliasMark = $lg($g(^User.MKBGlobalD(GlobalID,"ChildGloAlias",AliasId)),8)
				s MKBGADesc = $lg($g(^User.MKBGlobalD(GlobalID,"ChildGloAlias",AliasId)),2) 
				s MKBGAPYCode=$lg($g(^User.MKBGlobalD(GlobalID,"ChildGloAlias",AliasId)),3)
				s MKBGASequence=$lg($g(^User.MKBGlobalD(GlobalID,"ChildGloAlias",AliasId)),7)	//序号
				if (ShowName="")		//有标为展示名的数据
				{
					if (MKBGASequence=1)	//如果没有标记展示名，默认第一条为展示名
					{
						s ShowName=MKBGADesc
					}
				}
				if (matchflag'=1)
				{
					continue:((MKBGADesc'[desc)&&(MKBGAPYCode'[desc))
				}
				else
				{
					continue:(MKBGADesc'=desc)&&(MKBGAPYCode'=desc)
				}
				s showCount=showCount+1
				s:showCount=1 showDesc=MKBGADesc	//只取第一个符合的数据
			}
			if (showCount>0)
			{
				if (ShowName=showDesc)		//如果是展示名，直接展示
				{
					s Desc=ShowName
				}
				else		//如果没有标记的展示名，默认第一条为展示名
				{
					s Desc=ShowName_"("_showDesc_")"
				}
				
				s ID=ShowName
				s totalcount=totalcount+1
				
				if (allflag'=1)		//为1输出全部数据，不为1，仅输出10条
				{
					if (totalcount=(combolimit+1))  //如果超过十条，显示... 
					{
						s ID="..."
						s Desc="..."
						d OutputRowCmb	
						s totalcount=totalcount+1
					}
					q:(totalcount>combolimit)
				}	
				d OutputRowCmb
			}
			else
			{
				continue
			}
				
			

	    }
    }
	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(ID,Desc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetTermForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTermForCmb1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetTermForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTermForCmb1Execute ]
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

/// Creator：钟荣枫
/// CreatDate: 2020-8-13
/// Description：为全局化词表 术语合并下拉检索框查询取数据  
/// Table：User.MKBGlobal
/// Input：q
/// Return：ID,Desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBGlobal","GetTermForCmb2","部位,临床实用诊断,常用诊断描述,业务诊断,展示名","1","1","功能异常","termsort","","")
Query GetTermForCmb2(markstr, matchflag, allflag, q As %String, SortMethod, SortLocStr, LocFreq) As %Query(ROWSPEC = "ID,Desc")
{
}

ClassMethod GetTermForCmb2Execute(ByRef qHandle As %Binary, markstr, matchflag, allflag, q As %String, SortMethod, SortLocStr, LocFreq) As %Status
{
	
	s repid=$I(^CacheTemp)	
	s ind=1
	
	k ^TempMarkSortList
	k ^TmpDataHandle

	if ((^TempSearchLoc'="")&&(SortMethod="locsort")&&(SortLocStr=""))
	{
		s SortLocStr=$p(^TempSearchLoc,"^",1)
		s LocFreq=$p(^TempSearchLoc,"^",2)
		d ..SortGlobal(SortMethod,SortLocStr,LocFreq)
	}
	else
	{
		d ..SortGlobal(SortMethod,SortLocStr,LocFreq)
	}
	
	
	 
	 		
	s desc=$ZCONVERT(q,"U")
	
	s ID=""
    s Desc=""
    s combolimit=10,totalcount=0
    
    s endflag=0
    
    s NumCount=0			
	for
	{
		s NumCount=$o(^TempMarkSortList("Sort",NumCount))
		q:NumCount=""
		
		s GlobalID=^TempMarkSortList("Sort",NumCount)
		q:GlobalID=""
		q:endflag=1
	
    
		    s MKBGDesc=$lg($g(^User.MKBGlobalD(GlobalID)),3)
		    s MKBGPYCode=$lg($g(^User.MKBGlobalD(GlobalID)),6)
		    s MKBGState=$lg($g(^User.MKBGlobalD(GlobalID)),8)
		    continue:(MKBGState'="U")	//过滤非在使用的
		    		
		    s MKBGMark=$lg($g(^User.MKBGlobalD(GlobalID)),10)
			s markflag=0
			if (markstr'="")
			{
				for m=1:1:$l(markstr,",")
				{
					q:markflag=1
					for n=1:1:$l(MKBGMark,",")
					{
						s MKBGMarkPiece=$p(MKBGMark,",",n)
						continue:(MKBGMarkPiece="")
						s:(MKBGMarkPiece=$p(markstr,",",m)) markflag=1
						q:markflag=1
					}
					
				}
			}
			else
			{
				s markflag=1
			}

			continue:markflag=0
			
			s outputflag=0
			if (matchflag=1)		//完全匹配
			{
				if (((MKBGDesc=desc)||(MKBGPYCode=desc))&&(markflag=1))
				{
					s outputflag=1
				}
			}
			else
			{
				if (((MKBGDesc[desc)||(MKBGPYCode[desc))&&(markflag=1))
				{
					s outputflag=1
				}
			}
			
			if (outputflag=1)
			{
				s ID=GlobalID
				s Desc=MKBGDesc
				s ShowNameID=$o(^User.MKBGloAliasI("DisplayName",GlobalID," Y",0))
				s ShowName=""
				s:ShowNameID'="" ShowName=$lg($g(^User.MKBGlobalD(GlobalID,"ChildGloAlias",ShowNameID)),2)
				s:ShowName="" Desc=MKBGDesc
				s:ShowName'="" Desc=ShowName
				if (allflag'=1)		//为1输出全部数据，不为1，仅输出10条
				{
					
					s totalcount=totalcount+1
					if (totalcount=(combolimit+1))  //如果超过十条，显示... 
					{
						s ID="..."
						s Desc="..."
					}
					s ^TmpDataHandle(ID)=""
					d OutputRowCmb
					s:(totalcount>combolimit) endflag=1
				}
				else
				{
					s totalcount=totalcount+1
					s ^TmpDataHandle(ID)=""
					d OutputRowCmb
				}
				
			}
			else
			{
				s ShowNameID=$o(^User.MKBGloAliasI("DisplayName",GlobalID," Y",0))
				s ShowName=""
				s:ShowNameID'="" ShowName=$lg($g(^User.MKBGlobalD(GlobalID,"ChildGloAlias",ShowNameID)),2)
				//Index SeqIndex On (ParRef, MKBGASequence As Exact, MKBGADesc);
				s AliasId=0
				
				s showDesc=""
				s showCount=0
				for
				{
					s AliasId=$o(^User.MKBGlobalD(GlobalID,"ChildGloAlias",AliasId))  //遍历别名表
					q:AliasId=""
					s AliasMark = $lg($g(^User.MKBGlobalD(GlobalID,"ChildGloAlias",AliasId)),8)
					s MKBGADesc = $lg($g(^User.MKBGlobalD(GlobalID,"ChildGloAlias",AliasId)),2) 
					s MKBGAPYCode=$lg($g(^User.MKBGlobalD(GlobalID,"ChildGloAlias",AliasId)),3)
					s MKBGASequence=$lg($g(^User.MKBGlobalD(GlobalID,"ChildGloAlias",AliasId)),7)	//序号

					//^User.MKBGloAliasI("DisplayName",8648," Y",14827)
					if (ShowName="")		//有标为展示名的数据
					{
						if (MKBGASequence=1)	//如果没有标记展示名，默认第一条为展示名
						{
							s ShowName=MKBGADesc
						}
					}
						
					
					if (matchflag'=1)
					{
						continue:(MKBGADesc'[desc)&&(MKBGAPYCode'[desc)
					}
					else
					{
						
						continue:(MKBGADesc'=desc)&&(MKBGAPYCode'=desc)
					}
					s showCount=showCount+1
					s:showCount=1 showDesc=MKBGADesc	//只取第一个符合的数据
					
				}
				if (showCount>0)
				{
					s AliasId=""
					if (ShowName=showDesc)		//如果是展示名，直接展示
					{
						s Desc=ShowName
						s ID=GlobalID
					}
					else		//如果没有标记的展示名，默认第一条为展示名
					{
						s Desc=ShowName_"("_showDesc_")"
						s AliasId=$o(^User.MKBGloAliasI("DescIndex",GlobalID," "_$zconvert(showDesc,"U"),""))
						s ID=GlobalID_"||"_AliasId
					}
					
						
					//s ID=GlobalID_"||"_AliasId
					
					if (allflag'=1)		//为1输出全部数据，不为1，仅输出10条
					{
						
						s totalcount=totalcount+1
						if (totalcount=(combolimit+1))  //如果超过十条，显示... 
						{
							s ID="..."
							s Desc="..."
						}
						s ^TmpDataHandle(ID)=""
						d OutputRowCmb
						s:totalcount>combolimit endflag=1
						
					}
					else
					{
						s totalcount=totalcount+1
						s ^TmpDataHandle(ID)=""
						d OutputRowCmb
					}
					
					
				}
				else
				{
					continue	
				}
				
			}
    	
    }
	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(ID,Desc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetTermForCmb2Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTermForCmb2Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetTermForCmb2Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTermForCmb2Execute ]
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

/// Creator：钟荣枫 
/// CreatDate: 2020-05-29
/// Description：获取某个全局化词表的数据
/// Input: id
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).OpenGlobalData(8090)
ClassMethod OpenGlobalData(MKBGRowId)
{
	s str=""	
	s MKBGCode=$lg($g(^User.MKBGlobalD(MKBGRowId)),2)
	s MKBGDesc=$lg($g(^User.MKBGlobalD(MKBGRowId)),3)
	s MKBGDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBGDesc)
	s MKBGEnName=$lg($g(^User.MKBGlobalD(MKBGRowId)),4)
	s MKBGNote=$lg($g(^User.MKBGlobalD(MKBGRowId)),5)
	s MKBGPYCode=$lg($g(^User.MKBGlobalD(MKBGRowId)),6)
	s MKBGPYCode= ##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBGPYCode)
	s MKBGLastLevel=$lg($g(^User.MKBGlobalD(MKBGRowId)),7)
	s MKBGState=$lg($g(^User.MKBGlobalD(MKBGRowId)),8)
	s MKBGMark =$lg($g(^User.MKBGlobalD(MKBGRowId)),10)
	s MKBGDiaTotalFreq = $lg($g(^User.MKBGlobalD(MKBGRowId)),11)
	s MKBGAlias=""
	s MKBGDisplaName=""
	s AliasId=0
	for
	{
		s AliasId=$o(^User.MKBGlobalD(MKBGRowId,"ChildGloAlias",AliasId))  //遍历别名表
		q:AliasId=""
		s AliasMark = $lg($g(^User.MKBGlobalD(MKBGRowId,"ChildGloAlias",AliasId)),8)
		s MKBGADesc = $lg($g(^User.MKBGlobalD(MKBGRowId,"ChildGloAlias",AliasId)),2)
		
		if (AliasMark["查询名")
	    {
		    if (MKBGAlias="")
			{
				s MKBGAlias=$lg($g(^User.MKBGlobalD(MKBGRowId,"ChildGloAlias",AliasId)),2)   //别名
			}
			else
			{
				s MKBGAlias=MKBGAlias_","_$lg($g(^User.MKBGlobalD(MKBGRowId,"ChildGloAlias",AliasId)),2)   //别名
			}
	    }
	    if (AliasMark["展示名")
	    {
		    s MKBGDisplaName=$lg($g(^User.MKBGlobalD(MKBGRowId,"ChildGloAlias",AliasId)),2)   //展示名
		  
	    }
	    if ((MKBGADesc=MKBGDisplaName)&(MKBGDisplaName'=""))
	    {
		    s MKBGloMark=AliasMark
	    }
	    elseif (MKBGADesc=MKBGDesc)
	    {
		    s MKBGloMark=AliasMark
	    }
	    s:MKBGDisplaName="" MKBGDisplaName=$lg($g(^User.MKBGlobalD(MKBGRowId)),3)
	
	}
	s MKBGAlias=MKBGAlias
	s MKBGDisplaName=MKBGDisplaName
	s str="{""MKBGRowId"":"""_MKBGRowId_""",""MKBGCode"":"""_MKBGCode_""",""MKBGDesc"":"""_MKBGDesc_""",""MKBGEnName"":"""_MKBGEnName_""",""MKBGNote"":"""_MKBGNote_""",""MKBGPYCode"":"""_MKBGPYCode_""",""MKBGLastLevel"":"""_MKBGLastLevel_""",""MKBGState"":"""_MKBGState_""",""MKBGMark"":"""_MKBGMark_""",""MKBGDiaTotalFreq"":"""_MKBGDiaTotalFreq_""",""MKBGAlias"":"""_MKBGAlias_""",""MKBGDisplaName"":"""_MKBGDisplaName_"""}"
	q str
}

/// Creator:钟荣枫
/// CreatDate:2020-08-24
/// Description:全局化词表常用诊断表达式是否被引用检查方法
/// Input：RefMKBTPDID(被引用的常用诊断表达式的id)
/// Output: 存在同名对象返回存在为ture+同名数据的ID{exist:'ture',PassiveID:'"GlobalID"'},不存在同名对象则返回false
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).SelfTestInitiativeID("2303750")
ClassMethod SelfTestInitiativeID(RefMKBTPDID As %String)
{
	s result = "{exist:'false'}" 
	s IDstr=""
	s InitiativeFlag=""
	for
	{
		s InitiativeFlag=$o(^User.MKBGlobalReferenceI("AllIndex",InitiativeFlag))
		q:InitiativeFlag=""
		
		s PassiveID=""
		for
		{
			s PassiveID=$o(^User.MKBGlobalReferenceI("AllIndex",InitiativeFlag,RefMKBTPDID,PassiveID))	//是否含有临床实用诊断的引用
			q:PassiveID=""
			s MKBGState=$lg($g(^User.MKBGlobalD(PassiveID)),8)
		    continue:(MKBGState'="U")	//过滤非在使用的
		    
			if (PassiveID'="")
			{
				if (IDstr'="")
				{
					s IDstr=IDstr_","_PassiveID
				}
				else
				{
					s IDstr=PassiveID
				}
				 
			}
			
		}
	}
	s:IDstr'="" result = "{exist:'true',PassiveID:'"_IDstr_"'}"
    q result
}

/// Creator:钟荣枫
/// CreatDate:2020-09-3
/// Description:检查全局化词表的别名标志是否错误，若错误进行修改
/// Input：范围：1 当前选中术语，2 当前术语集，词表所有术语  GlobalID
/// Output: false 或者true
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).SelfCheckAliasMark("2303750")
ClassMethod SelfCheckAliasMark(rangeStr, dataID)
{
	s result=""
	s errorflag=0
	TS
	if (rangeStr=1)                //对当前选中术语进行操作
    {
	    s re= ..DoSelfCheckAliasMark(dataID)
	    s:re["false" errorflag=1
	}
	elseif(rangeStr=2)            //对当前搜索到的术语集合
	{
		s MKBGlobalID = 0
		s num=0
		for
		{
			s MKBGlobalID = $o(^TmpDataHandle(MKBGlobalID))
			q:MKBGlobalID=""
			s AlisaID=$o(^User.MKBGlobalD(MKBGlobalID,"ChildGloAlias",0))
			continue:AlisaID=""	//过滤没有别名的数据

			s re=..DoSelfCheckAliasMark(MKBGlobalID)
			s:re["false" errorflag=1
			q:errorflag=1
		}
	}
	elseif(rangeStr=3)            //对词表内所有术语
	{
		s num=0
		s MKBGlobalID = 0
		for
		{
			s MKBGlobalID = $o(^User.MKBGlobalD(MKBGlobalID))
			q:MKBGlobalID=""
			s MKBGState=$lg($g(^User.MKBGlobalD(MKBGlobalID)),8)
			s AlisaID=$o(^User.MKBGlobalD(MKBGlobalID,"ChildGloAlias",0))
			continue:AlisaID=""	//过滤没有别名的数据
			
			s re= ..DoSelfCheckAliasMark(MKBGlobalID)
			s:re["false" errorflag=1
			q:errorflag=1
		}
	}
	if (errorflag=1)	//失败
	{
		tro	
		s result="false"
	}
	else	//成功
	{
		tc
		s result="true"
	}
	q result
}

/// Creator:钟荣枫
/// CreatDate:2020-12-3
/// Description:检查某个全局化词表的别名标志是否错误，若错误进行修改
/// Input：GlobalID
/// Output: 
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).DoSelfCheckAliasMark("9136")
ClassMethod DoSelfCheckAliasMark(GlobalID)
{
	s result=""
	s errorflag=0
	TS
		
	s ShowNameID=$o(^User.MKBGloAliasI("DisplayName",GlobalID," Y",0))
	s AliasId=0
	for
	{
		s AliasId=$o(^User.MKBGlobalD(GlobalID,"ChildGloAlias",AliasId))  //遍历别名表
		q:AliasId=""
		
		s AliasMark = $lg($g(^User.MKBGlobalD(GlobalID,"ChildGloAlias",AliasId)),8)
		s MKBGADesc = $lg($g(^User.MKBGlobalD(GlobalID,"ChildGloAlias",AliasId)),2)
		s InitiativeIDD=$o(^User.MKBGlobalReferenceI("PassiveAliasIndex",GlobalID,AliasId,"D",0))
		s InitiativeIDT=$o(^User.MKBGlobalReferenceI("PassiveAliasIndex",GlobalID,AliasId,"T",0))
		if (InitiativeIDT'="")
		{
			s MKBTActiveFlag=$listGet($g(^User.MKBTermD(InitiativeIDT)),9)
			if (MKBTActiveFlag="N")	//临床实用诊断被封闭
			{
				s RefRowID=$o(^User.MKBGlobalReferenceI("PassiveAliasIndex",GlobalID,AliasId,"T",InitiativeIDT,0))
				//删除引用
				d ..DeleteReferenceData(RefRowID)
				s InitiativeIDT=""
			}
		}
		s OldAliasMark=AliasMark
		s NewAliasMark=""
		for m=1:1:$l(AliasMark,",")		//去除空的标志
		{
			s mark=$p(AliasMark,",",m)	
			if (mark'="")
			{
				if (NewAliasMark'="")
				{
					s NewAliasMark=NewAliasMark_","_mark
				}
				else
				{
					s NewAliasMark=mark
				}
			}
		}
		s AliasMark=NewAliasMark
		
		if (ShowNameID'=AliasId)
		{
			s AliasMark=##class(web.BDP.util.String).Replace(AliasMark,"展示名,","")
			s AliasMark=##class(web.BDP.util.String).Replace(AliasMark,",展示名","")
			s AliasMark=##class(web.BDP.util.String).Replace(AliasMark,"展示名","")
		}
		else
		{
			if (AliasMark'["展示名")
			{
				s AliasMark=AliasMark_",展示名"
			}
			else
			{
				if ($l(AliasMark,"展示名")>2)	//展示名重复
				{
					s AliasMark=##class(web.BDP.util.String).Replace(AliasMark,"展示名,","")
					s AliasMark=##class(web.BDP.util.String).Replace(AliasMark,",展示名","")
					s AliasMark=##class(web.BDP.util.String).Replace(AliasMark,"展示名","")
					s AliasMark=AliasMark_",展示名"
				}
			}
		}
		if ($l(AliasMark,"查询名")>2)	//查询名重复
		{
			s AliasMark=##class(web.BDP.util.String).Replace(AliasMark,"查询名,","")
			s AliasMark=##class(web.BDP.util.String).Replace(AliasMark,",查询名","")
			s AliasMark=##class(web.BDP.util.String).Replace(AliasMark,"查询名","")
			if (AliasMark="")
			{
				s AliasMark="查询名"
			}
			else
			{
				s AliasMark=AliasMark_",查询名"
			}
		}
		if ($l(AliasMark,"常用诊断表达式")>2)	//常用诊断表达式重复
		{
			s AliasMark=##class(web.BDP.util.String).Replace(AliasMark,"常用诊断表达式,","")
			s AliasMark=##class(web.BDP.util.String).Replace(AliasMark,",常用诊断表达式","")
			s AliasMark=##class(web.BDP.util.String).Replace(AliasMark,"常用诊断表达式","")
			if (AliasMark="")
			{
				s AliasMark="常用诊断表达式,查询名"
			}
			else
			{
				s AliasMark=AliasMark_",常用诊断表达式"
			}
		}
		//s taobj=##class(User.MKBGloAlias).%OpenId(GlobalID_"||"_AliasId)
		if (AliasMark["常用诊断表达式")
		{
			if (InitiativeIDD="")		//引用中没有常用诊断表达式
			{
				s AliasMark=##class(web.BDP.util.String).Replace(AliasMark,"常用诊断表达式,","")
				s AliasMark=##class(web.BDP.util.String).Replace(AliasMark,",常用诊断表达式","")
				s AliasMark=##class(web.BDP.util.String).Replace(AliasMark,"常用诊断表达式","")
			}
		}

		if (InitiativeIDD'="")		//引用中有常用诊断表达式
		{
			if (AliasMark="")
			{
				s AliasMark="常用诊断表达式"
			}
			elseif (AliasMark'["常用诊断表达式")
			{
				s AliasMark=AliasMark_",常用诊断表达式"
			}
		}
		
		s termid=$o(^User.MKBTermI("DescIndex",5," "_$zconvert(MKBGADesc,"U"),0))
		if (AliasMark["临床实用诊断")
		{
			if (InitiativeIDT="")		//没有引用
			{
				s AliasMark=##class(web.BDP.util.String).Replace(AliasMark,"临床实用诊断,","")
				s AliasMark=##class(web.BDP.util.String).Replace(AliasMark,",临床实用诊断","")
				s AliasMark=##class(web.BDP.util.String).Replace(AliasMark,"临床实用诊断","")
			}
		}
		
		if (InitiativeIDT'="")	//引用中有临床实用诊断
		{
			if (AliasMark="")
			{
				s AliasMark="临床实用诊断"
			}
			elseif (AliasMark'["临床实用诊断")
			{
				s AliasMark=AliasMark_",临床实用诊断"
			}
			
		}
		else
		{
			if (termid'="")
			{
				s MKBTActiveFlag=$listGet($g(^User.MKBTermD(termid)),9)
				if (MKBTActiveFlag'="N")	//临床实用诊断未被封闭
				{
					s bobj = ##class(web.Entity.MKB.MKBGlobalReference).%New()
					
					s bobj.InitiativeFlag="T"				//发起引用，主动引用标识
					s bobj.InitiativeID=termid				//发起引用词的ID
					s bobj.PassiveID= GlobalID			//被引用词的ID
					s bobj.PassiveAliasID=AliasId				//被引用词的名称列表ID
					d ..SaveReferenceEntity(bobj)

					if (AliasMark'["临床实用诊断")
					{
						if (AliasMark="")
						{
							s AliasMark="临床实用诊断"
						}
						elseif (AliasMark'["临床实用诊断")
						{
							s AliasMark=AliasMark_","_"临床实用诊断"
						}
					}
				}
			}
		}
		if ((AliasMark["常用诊断表达式")||(AliasMark["临床实用诊断")||(AliasMark["展示名")||(AliasMark["查询名"))
		{
			s AliasMark=##class(web.BDP.util.String).Replace(AliasMark,"别名,","")
			s AliasMark=##class(web.BDP.util.String).Replace(AliasMark,",别名","")
			s AliasMark=##class(web.BDP.util.String).Replace(AliasMark,"别名","")
			s AliasMark=##class(web.BDP.util.String).Replace(AliasMark,"导入待审核,","")
			s AliasMark=##class(web.BDP.util.String).Replace(AliasMark,",导入待审核","")
			s AliasMark=##class(web.BDP.util.String).Replace(AliasMark,"导入待审核","")	
			s AliasMark=##class(web.BDP.util.String).Replace(AliasMark,"业务诊断,","")
			s AliasMark=##class(web.BDP.util.String).Replace(AliasMark,",业务诊断","")
			s AliasMark=##class(web.BDP.util.String).Replace(AliasMark,"业务诊断","")
		}
		
		if ((AliasMark["展示名")&&(AliasMark'["查询名"))	//展示名后必定带有查询名
		{
			
			s AliasMark=AliasMark_",查询名"
		}
		if (OldAliasMark'=AliasMark)	//别名标志被修改了
		{
			s re=..SaveAliasLog(GlobalID, AliasId, "", "", "", "", "", AliasMark, "")
			s:re["false" errorflag=1
		}
		q:errorflag=1
	}
	if (errorflag=1)	//失败
	{
		tro	
		s result="false"
	}
	else	//成功
	{
		tc
		s result="true"
	}
	q result
}

/// Creator:钟荣枫
/// CreatDate:2020-09-8
/// Description:检查全局化词表的引用场景是否错误(别名id为空)，若错误进行修改
/// Input：
/// Output: false 失败，true 成功
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).SelfCheckReference()
ClassMethod SelfCheckReference()
{
	s result=""
	s errorflag=0
	TS
	s GlobalID=0
	for
	{
		s GlobalID=$o(^User.MKBGlobalReferenceI("InverAllIndex",GlobalID))
		q:GlobalID=""
		q:errorflag=1
		s InitiativeFlag=""
		for 
		{
			s InitiativeFlag=$o(^User.MKBGlobalReferenceI("InverAllIndex",GlobalID,InitiativeFlag))
			q:InitiativeFlag=""
			q:errorflag=1
			s PassiveID=""
			for
			{
				s PassiveID=$o(^User.MKBGlobalReferenceI("InverAllIndex",GlobalID,InitiativeFlag,PassiveID))
				q:PassiveID=""
				q:errorflag=1
				s ReferenceID=""
				for
				{
					s ReferenceID=$o(^User.MKBGlobalReferenceI("InverAllIndex",GlobalID,InitiativeFlag,PassiveID,ReferenceID))
					q:ReferenceID=""
					q:errorflag=1
					s PassiveAliasID = $lg($g(^User.MKBGlobalReferenceD(ReferenceID)),5)	//别名的id
					if (PassiveAliasID="")	//引用场景中别名的id为空
					{
						if (InitiativeFlag="T")
						{
							s MKBGRDesc=$lg($g(^User.MKBTermD(PassiveID)),3)		//引用场景中的描述
						}
						if (InitiativeFlag="D")
						{
							s MKBGRDesc=$lg($g(^User.MKBGlobalD(GlobalID)),3) 
						}
						if (InitiativeFlag="ICDCon")
						{
							s MKBGRDesc=$lg($g(^User.MKBICDContrastD(PassiveID)),3) 
						}
						if (InitiativeFlag="ICDSD")
						{
							s MKBGRDesc=$lg($g(^User.MKBStructuredDataD(PassiveID)),2) 
						}
						s NewDesc = ##class(web.DHCBL.BDP.FunLib).AutoSBDB(MKBGRDesc,0)		//全角转半角
						s NewDesc=..SpaceHandleMethod1(NewDesc)
						s NewDesc=..SpaceHandleMethod2(NewDesc)
						s NewDesc=..SpaceHandleMethod3(NewDesc)
		
						s NewPassiveAliasID=$o(^User.MKBGloAliasI("DescIndex",GlobalID," "_$ZCONVERT(NewDesc,"U"),0))	//在别名列表中的id
						if (NewPassiveAliasID'="")	//在别名表中能找到对应的描述
						{
							s frobj=##class(User.MKBGlobalReference).%OpenId(ReferenceID)   //打开被合并数据的引用表
							
							
							s feobj = ##class(web.Entity.MKB.MKBGlobalReference).%New()
							s feobj.MKBGRRowid = ReferenceID
							
							s feobj.InitiativeFlag=frobj.InitiativeFlag				//发起引用，主动引用标识
							s feobj.InitiativeID=frobj.InitiativeID				//发起引用词的ID
							s feobj.PassiveID=frobj.PassiveID				//被引用词的ID
							s feobj.PassiveAliasID=NewPassiveAliasID				//被引用词的名称列表ID
						 	s re= ..SaveReferenceEntity(feobj) 
						 	
						 	d frobj.%Close() 
						 	if (re["false")
						 	{
							 	if (re["存在")
							 	{
								 	s MKBGRRowid=$o(^User.MKBGlobalReferenceI("PassiveAliasIndex",feobj.PassiveID,feobj.PassiveAliasID,feobj.InitiativeFlag,feobj.InitiativeID,0)) 
							 		d:MKBGRRowid'="" ..DeleteReferenceData(MKBGRRowid)
							 	}
							 	else
							 	{
								 	s errorflag=1
							 	}
						 	}
						}
						else
						{
							d ..DeleteReferenceData(ReferenceID)	
						}
						
					}
				}
					
				
				
			}
		}
	}
	if (errorflag=1)	//失败
	{
		tro	
		s result="false"
	}
	else	//成功
	{
		tc
		s result="true"
	}
	q result
}

/// Creator:钟荣枫
/// CreatDate:2020-09-8
/// Description:提供全角转半角和半角转全角方法,同时处理其别名
/// Input：rangeStr: 1=当前选中术语 2=当前搜索到的术语集合 3=词表内所有术语  methodStr: 1=全角转半角 2=半角转全角
/// Output: false 失败，true 成功
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).FullDataHandle()
ClassMethod FullDataHandle(rangeStr As %String, methodStr As %String, dataID As %String)
{
	s result=""
	s errorflag=0
	TS
    if (rangeStr=1)                //对当前选中术语进行操作
    {
	    s Desc= $lg($g(^User.MKBGlobalD(dataID)),3)
	    //w ##class(web.DHCBL.BDP.FunLib).AutoSBDB("高血压2级（极高危）",0)
		//FLAG:0全角转为半角，1半角转为全角
	    if (methodStr="1")
	    {
		    s Desc = ##class(web.DHCBL.BDP.FunLib).AutoSBDB(Desc,0)
		}
		else
		{
			s Desc = ##class(web.DHCBL.BDP.FunLib).AutoSBDB(Desc,1)
		}
		s sc1= ..SaveGlobalLog(dataID, Desc, "","","", "", "", "")
		s:sc1["false" errorflag=1
		if (errorflag=0)
		{
			//处理别名
			s AliasId=0
			for
			{
				s AliasId=$o(^User.MKBGlobalD(dataID,"ChildGloAlias",AliasId))  //遍历别名表
				q:AliasId=""
				s MKBGADesc = $lg($g(^User.MKBGlobalD(dataID,"ChildGloAlias",AliasId)),2)
				if (methodStr="1")			//全角转半角
			    {
				    s MKBGADesc = ##class(web.DHCBL.BDP.FunLib).AutoSBDB(MKBGADesc,0)
				}		
				else		//半角转全角
				{
					s MKBGADesc = ##class(web.DHCBL.BDP.FunLib).AutoSBDB(MKBGADesc,1)
				}
				s sc2= ..SaveAliasLog(dataID, AliasId, MKBGADesc, "", "", "", "", "", "")
				s:sc2["false" errorflag=1
				q:errorflag=1
			}
		}
		d ..DeleteSameAlias(dataID)		//删除别名中的别名
		
	}
	elseif(rangeStr=2)            //对当前搜索到的术语集合
	{
		s MKBGlobalID = 0
		for
		{
			s MKBGlobalID = $o(^TmpDataHandle(MKBGlobalID))
			q:MKBGlobalID=""
			s Desc = $lg($g(^User.MKBGlobalD(MKBGlobalID)),3)
			//
			if (methodStr="1")
		    {
			    s Desc = ##class(web.DHCBL.BDP.FunLib).AutoSBDB(Desc,0)
			}
			else
			{
				s Desc = ##class(web.DHCBL.BDP.FunLib).AutoSBDB(Desc,1)
			}
			s sc1= ..SaveGlobalLog(MKBGlobalID, Desc, "","","", "", "", "")
			s:sc1["false" errorflag=1
			q:errorflag=1
			if (errorflag=0)
			{
				//处理别名
				s AliasId=0
				for
				{
					s AliasId=$o(^User.MKBGlobalD(MKBGlobalID,"ChildGloAlias",AliasId))  //遍历别名表
					q:AliasId=""
					s MKBGADesc = $lg($g(^User.MKBGlobalD(MKBGlobalID,"ChildGloAlias",AliasId)),2)
					if (methodStr="1")		//全角转半角
				    {
					    s MKBGADesc = ##class(web.DHCBL.BDP.FunLib).AutoSBDB(MKBGADesc,0)
					}
					else		//半角转全角
					{
						s MKBGADesc = ##class(web.DHCBL.BDP.FunLib).AutoSBDB(MKBGADesc,1)
					}
					s sc2= ..SaveAliasLog(MKBGlobalID, AliasId, MKBGADesc, "", "", "", "","" ,"")
					s:sc2["false" errorflag=1
					q:errorflag=1
				}
			}
			d ..DeleteSameAlias(MKBGlobalID)		//删除别名中的别名
		}
	}
	elseif(rangeStr=3)            //对词表内所有术语
	{
		s MKBGlobalID = 0
		for
		{
			s MKBGlobalID = $o(^User.MKBGlobalD(MKBGlobalID))
			q:MKBGlobalID=""
			s Desc  = $lg($g(^User.MKBGlobalD(MKBGlobalID)),3)
			//
			if (methodStr="1")
		    {
			    s Desc = ##class(web.DHCBL.BDP.FunLib).AutoSBDB(Desc,0)
			}
			else
			{
				s Desc = ##class(web.DHCBL.BDP.FunLib).AutoSBDB(Desc,1)
			}
			s sc1= ..SaveGlobalLog(MKBGlobalID, Desc, "","","", "", "", "")
			s:sc1["false" errorflag=1
			q:errorflag=1
			if (errorflag=0)
			{
				//处理别名
				s AliasId=0
				for
				{
					s AliasId=$o(^User.MKBGlobalD(MKBGlobalID,"ChildGloAlias",AliasId))  //遍历别名表
					q:AliasId=""
					s MKBGADesc = $lg($g(^User.MKBGlobalD(MKBGlobalID,"ChildGloAlias",AliasId)),2)
					if (methodStr="1")		//全角转半角
				    {
					    s MKBGADesc = ##class(web.DHCBL.BDP.FunLib).AutoSBDB(MKBGADesc,0)
					}
					else		//半角转全角
					{
						s MKBGADesc = ##class(web.DHCBL.BDP.FunLib).AutoSBDB(MKBGADesc,1)
					}
					s sc2= ..SaveAliasLog(MKBGlobalID, AliasId, MKBGADesc, "", "", "", "","", "")
					s:sc2["false" errorflag=1
					q:errorflag=1
				}
			}
			d ..DeleteSameAlias(MKBGlobalID)		//删除别名中的别名
		}
	}
	if (errorflag=1)	//失败
	{
		tro	
		s result="false"
	}
	else	//成功
	{
		tc
		s result="true"
	}
	q result
}

/// Creator:钟荣枫
/// CreatDate:2020-09-8
/// Description:提供拆词处理  需预先经过全角/半角处理
/// Input：rangeStr: 1=当前选中术语 2=当前搜索到的术语集合 3=词表内所有术语  methodStr: 1=逗号为拆分符 2=顿号为拆分符
/// Output: 
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).SplitDataHandle("1","1","264042")
ClassMethod SplitDataHandle(rangeStr As %String, methodStr As %String, dataID As %String)
{
	s result=""
	s errorflag=0
	k ^TempSplitDataCount
	
    if (rangeStr=1)                //对当前选中术语进行操作
    {
	    d ..SplitDataBySymbol(methodStr,dataID)
	}
	elseif(rangeStr=2)            //对当前搜索到的术语集合
	{
		s MKBGlobalID = 0
		s num=0
		for
		{
			s MKBGlobalID = $o(^TmpDataHandle(MKBGlobalID))
			q:MKBGlobalID=""
			s MKBGState=$lg($g(^User.MKBGlobalD(MKBGlobalID)),8)
			continue:(MKBGState'="U")	//过滤非在使用的
			s AlisaID=$o(^User.MKBGlobalD(MKBGlobalID,"ChildGloAlias",0))
			continue:AlisaID=""	//过滤没有别名的数据
			
			s num=num+1
			s ^TempSplitDataCount=num
			d ..SplitDataBySymbol(methodStr,MKBGlobalID)
		}
	}
	elseif(rangeStr=3)            //对词表内所有术语
	{
		s num=0
		s MKBGlobalID = 0
		for
		{
			s MKBGlobalID = $o(^User.MKBGlobalD(MKBGlobalID))
			q:MKBGlobalID=""
			s MKBGState=$lg($g(^User.MKBGlobalD(MKBGlobalID)),8)
			continue:(MKBGState'="U")	//过滤非在使用的
			s AlisaID=$o(^User.MKBGlobalD(MKBGlobalID,"ChildGloAlias",0))
			continue:AlisaID=""	//过滤没有别名的数据
			s num=num+1
			s ^TempSplitDataCount=num
			
			d ..SplitDataBySymbol(methodStr,MKBGlobalID)
		}
	}
	q "success"
}

/// Creator:钟荣枫
/// CreatDate:2020-09-14
/// Description:判断是否还有拆词残留
/// Input：GlobalID 术语id，AliasMarkStr 别名标志串，aliasflag 是否返回别名
/// Output: LeaveFlag_"^"_leaveid  LeaveFlag 是否存在，leaveid 术语id
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).IsLeave("220898")
ClassMethod IsLeave(GlobalID As %String, AliasMarkStr As %String, aliasflag As %String = "")
{
	s result=""
	s leaveid=""
	s LeaveFlag=0
	
	s MKBGAMark=0
	for
	{
		s MKBGAMark=$o(^User.MKBGloAliasI("MarkIndex",GlobalID,MKBGAMark))  //遍历别名表
		q:MKBGAMark=""
		s continueflag=1
		for m=1:1:$l(AliasMarkStr,",")
		{
			s mark=$p(AliasMarkStr,",",m)
			
			if (MKBGAMark[mark)	
			{
				s continueflag=0
				q 
			}
		}
		continue:continueflag=1
		s LeaveFlag=1
		if (aliasflag'="")		//是否返回别名
		{
			s AliasId=0
			for
			{
				s AliasId=$o(^User.MKBGloAliasI("MarkIndex",GlobalID,MKBGAMark,AliasId))  //遍历别名表
				q:AliasId=""
				if (leaveid="")		//别名id串为空
				{
					s leaveid=AliasId
				}
				else
				{
					s leaveid=leaveid_","_AliasId
				}
			}
		}
	}
	
	s result=LeaveFlag_"^"_leaveid
	q result
}

/// Creator:钟荣枫
/// CreatDate:2020-09-8
/// Description:对术语进行拆分   没有拆词残留的情况下，按照展示名来拆分
///   							有拆词残留的情况下，按照拆词残留来拆分
/// Input：symbol 、，等， GlobalID 术语id
/// Output: 
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).SplitDataBySymbol(1,"223870")
ClassMethod SplitDataBySymbol(symbol As %String, GlobalID As %String)
{
	q:symbol="" "false"
	s mark=$case(symbol,"1":"逗号残留","2":"顿号残留","3":"空格残留","4":"分号残留","5":"句号残留",:"")
	s symbol=$case(symbol,"1":",","2":"、","3":" ","4":";","5":"。",:"")
	s AliasMarkStr="逗号残留,顿号残留,空格残留,分号残留,句号残留"
	s leftstr=..IsLeave(GlobalID,AliasMarkStr,1)
	s leftflag=$p(leftstr,"^",1)
	s leftidstr=$p(leftstr,"^",2)
	if (leftflag=1)		//有拆词残留的情况下，按照拆词残留来拆分
	{
		for n=1:1:$l(leftidstr,",")
		{
			s AliasId=$p(leftidstr,",",n)
			s MKBGADesc = $lg($g(^User.MKBGlobalD(GlobalID,"ChildGloAlias",AliasId)),2)
			if (MKBGADesc[symbol)	//过滤不包含拆分符的
			{
				s remnant=..SplitData(symbol,MKBGADesc,GlobalID,AliasId)
				s:remnant=symbol remnant=""
				if (remnant="")	
				{
					d ..DeleteAliasData(GlobalID_"||"_AliasId)	
				}
			}
			else
			{
				continue
			}
			
		}
		s leftstr=..IsLeave(GlobalID,AliasMarkStr)
		s leftflag=$p(leftstr,"^",1)
		if (leftflag=0)		//拆分一次后没有拆分残留，删除术语和其所有的别名
		{
			
			s AlisaID=0
			for
			{
				s AlisaID=$o(^User.MKBGlobalD(GlobalID,"ChildGloAlias",AlisaID))
				q:AlisaID=""
				d ..DeleteAliasData(GlobalID_"||"_AlisaID)	//删除其下的别名
			}
			d ..SaveGlobalLog(GlobalID, "", "","","D", "", "", "")

		
		}
	}
	else		//没有拆词残留的情况下，按照展示名来拆分
	{
		s AliasId=$o(^User.MKBGloAliasI("DisplayName",GlobalID," Y",0))
		s MKBGADesc = $lg($g(^User.MKBGlobalD(GlobalID,"ChildGloAlias",AliasId)),2)
		if (MKBGADesc[symbol)	//过滤不包含拆分符的
		{
			s remnant=..SplitData(symbol,MKBGADesc,GlobalID,"")
			s:remnant=symbol remnant=""
			if ((remnant'="")&&(remnant'=MKBGADesc))	//拆分后有剩余，且不为其本身
			{	
				s MKBGAMark = $lg($g(^User.MKBGlobalD(GlobalID,"ChildGloAlias",AliasId)),8)	
				s:MKBGAMark'["拆词残留" MKBGAMark=MKBGAMark_",拆词残留"
				d ..SaveAliasLog(GlobalID, AliasId, "", "", "", "", "", MKBGAMark, "")

			}
			if (remnant="")		//拆分后无残留
			{
				s AlisaID=0
				for
				{
					s AlisaID=$o(^User.MKBGlobalD(GlobalID,"ChildGloAlias",AlisaID))
					q:AlisaID=""
					d ..DeleteAliasData(GlobalID_"||"_AlisaID)	//删除其下的别名
				}
				d ..SaveGlobalLog(GlobalID, "", "","","D", "", "", "")
			}
		}
	}
	q "success"
}

/// Creator:钟荣枫
/// CreatDate:2020-09-8
/// Description:对术语进行拆分   没有拆词残留的情况下，按照展示名来拆分
///   							有拆词残留的情况下，按照拆词残留来拆分
/// Input：symbol: ，、等 ，Desc 描述，GlobalID 术语id，AliasId 别名id
/// Output: remnant 拆分残留
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).SplitData()
ClassMethod SplitData(symbol As %String, Desc As %String, GlobalID As %String, AliasId)
{
	s mark=$case(symbol,",":"逗号残留","、":"顿号残留"," ":"空格残留",";":"分号残留","。":"句号残留",:"")
	s length=$l(Desc,symbol)
	s remnant=Desc
	s spliteleft=Desc
	if (length>1)		//用拆分符拆出来的数据多于一个
	{
		for m=1:1:length
		{
			s Piece=$p(Desc,symbol,m)
			if (Piece'="")	//拆分符拆出来不为空
			{
				//s existflag=..IsExist(Piece,GlobalID)
				s existstr= ..IsExist(Piece,GlobalID)
				s existflag=$p(existstr,"^",0)
				
				if (existflag=1)	//拆出来的数据在全局化词表中存在，去除
				{
					s remnant = ##class(web.BDP.util.String).Replace(remnant,symbol_Piece,"")
					s remnant = ##class(web.BDP.util.String).Replace(remnant,Piece_symbol,"")
					s remnant = ##class(web.BDP.util.String).Replace(remnant,Piece,"")
					
				}
				else		//拆除不成功的部分，新增一个别名，其标志是拆除残留
				{
					if (AliasId'="")	//从拆词残留中拆分
					{
						s MKBGAMark = $lg($g(^User.MKBGlobalD(GlobalID,"ChildGloAlias",AliasId)),8)
						s MKBGAMark=MKBGAMark_","_mark
						
						d ..SaveAliasLog(GlobalID, AliasId, Piece, "", "", "", "", MKBGAMark, "")

					}
					else		//拆分
					{
						s eobj=##class(web.Entity.MKB.MKBGloAlias).%New()    //新建一个别名表实体类存储需要保存的别名数据
						s eobj.MKBGAParRef=GlobalID
						s eobj.MKBGADesc=Piece
						s eobj.MKBGAPYCode=##class(web.DHCBL.BDP.FunLib).GetCNCODE(Piece,4,"")
						s eobj.MKBGANote=""
						s eobj.MKBGACEFlag="C"
						s eobj.MKBGAMark=mark	
						s ars=..SaveAliasEntity(eobj)  //保存别名
					}
				}
			}
		}
	}
	q remnant
}

/// Creator:钟荣枫
/// CreatDate:2020-09-8
/// Description:判断拆分出来的数据是否在全局化词表以及其别名中存在
/// Input： Desc  描述，GlobalID 术语id，inflag 是否在术语的别名表中查找,markstr 别名标志串 
/// Output: "existflag^gloablflag^"_TheID   existflag 是否存在，gloablflag 是否是术语，TheID 术语id或者别名id 
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).IsExist("重症肺炎","")
ClassMethod IsExist(Desc As %String, GlobalID As %String, inflag As %String = "", markstr As %String = "")
{
	s result=0
	s existflag=0
	if (markstr="")
	{
		s base=$o(^User.MKBTermBaseI("DescIndex"," 全局化词表标记",0))
		s markstrid=$o(^User.MKBTermI("DescIndex",base," 诊断",0))	//获取诊断
		
		s fixedmarkstr=##class(web.DHCBL.MKB.MKBTerm).GetChildOrderedIDStr(base,markstrid)
	}
	
	s TheID=0
	s oldFreq=0
	s existID=0
	for			//取用频率最高的数据
	{
		s existID=$o(^User.MKBGlobalI("DescIndex"," "_$ZCONVERT(Desc,"U"),existID))
		q:existID=""
		s MKBGState=$lg($g(^User.MKBGlobalD(existID)),8)
	    continue:(MKBGState'="U")	//过滤非在使用的
	    s MKBGMark=$lg($g(^User.MKBGlobalD(existID)),10)
	    
	    if (markstr="")		//为空时。默认诊断下的所有标志
	    {
		     s markstr=fixedmarkstr
	    }
	    if (markstr'="")
	    {
		    s markflag=0		//只处理诊断的数据
			for m=1:1:$l(markstr,"^")
			{
				s markid=$p(markstr,"^",m)
				q:(markid="")
				s MKBTDesc=$LISTGET($G(^User.MKBTermD(markid)),3)   ///中心词
				s:(MKBGMark[MKBTDesc) markflag=1
			}
			continue:markflag=0
	    }
		s MKBGDiaTotalFreq = $lg($g(^User.MKBGlobalD(existID)),11)
		s:MKBGDiaTotalFreq="" MKBGDiaTotalFreq=0
		if (MKBGDiaTotalFreq>=oldFreq)
		{
			s oldFreq=MKBGDiaTotalFreq
			s TheID=existID
		}
	}
	q:TheID'=0 "1^1^"_TheID
		//在别名中查找
	if (existflag=0)
	{
		//Index DescIndex On (ParRef As Exact, MKBGADesc);
		s oldFreq=0
		s Globalflag=0
		s Global=0
		for
		{
			s Global=$o(^User.MKBGloAliasI("NameIndex"," "_$ZCONVERT(Desc,"U"),Global))
			q:Global=""
			s MKBGState=$lg($g(^User.MKBGlobalD(Global)),8)
			continue:(MKBGState'="U")	//过滤非在使用的
			s MKBGMark=$lg($g(^User.MKBGlobalD(Global)),10)
			if (markstr'="")
	    		{
				s markflag=0		//只处理诊断的数据
				for m=1:1:$l(markstr,"^")
				{
					s markid=$p(markstr,"^",m)
					q:(markid="")
					s MKBTDesc=$LISTGET($G(^User.MKBTermD(markid)),3)   ///中心词
					s:(MKBGMark[MKBTDesc) markflag=1
						
				}
				continue:markflag=0
	    		}
			
			s MKBGDiaTotalFreq = $lg($g(^User.MKBGlobalD(Global)),11)
			s:MKBGDiaTotalFreq="" MKBGDiaTotalFreq=0
			if (MKBGDiaTotalFreq>=oldFreq)
			{
				s oldFreq=MKBGDiaTotalFreq
			}
			else
			{
				continue	
			}
			if (inflag'=1)	//不包含本身术语
			{
				continue:(Global=GlobalID)&&(GlobalID'="")
			}
			s AliasId=$o(^User.MKBGloAliasI("NameIndex"," "_$ZCONVERT(Desc,"U"),Global,0))
				
			s TheID=Global_"||"_AliasId
			
		}
		if (TheID'=0)
		{
			q "1^0^"_TheID
		}
		else
		{
			q "0"
		}
	}
	q result
}

/// Creator:钟荣枫
/// CreatDate:2020-09-11
/// Description:术语的首行别名设为展示名，存在展示名的不管
/// Input: GlobalID 术语id
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).AddDisplayName()
ClassMethod AddDisplayName(rowid As %String = "")
{
	s result=0
	s errorflag=0
	TS

	s GlobalID=""
	for
	{
		s GlobalID=$o(^User.MKBGlobalD(GlobalID))
		q:GlobalID=""
		continue:((rowid'="")&&(rowid'=GlobalID))
		s MKBGState=$lg($g(^User.MKBGlobalD(GlobalID)),8)
		//continue:(MKBGState'="U")
		//处理有多个展示名标志都为“Y”的数据
		s idstr=""
		s ShowNameID=""
		for
		{
			s ShowNameID=$o(^User.MKBGloAliasI("DisplayName",GlobalID," Y",ShowNameID))
			q:ShowNameID="" 
			s MKBGAMark = $lg($g(^User.MKBGlobalD(GlobalID,"ChildGloAlias",ShowNameID)),8)
			b ;1
			if (MKBGAMark'["展示名")
			{
				s re= ..SaveAliasLog(GlobalID, ShowNameID, "", "", "", "", "", MKBGAMark, "")
			}
			else
			{
				if (idstr="")
				{
					s idstr=ShowNameID
				}
				else
				{
					
					s idstr=idstr_"^"_ShowNameID
				}
			}
			
		}
	
		if ((idstr'="")&&($l(idstr,"^")=1))		//只有一个展示名
		{
			continue
		}
		elseif ((idstr'="")&&($l(idstr,"^")>1))	//仍存在多个 标志含“展示名”，且是否展示名为“Y”
		{
			
			for m=2:1:$l(idstr,"^")		//第二个之后的全部修改
			{
				s AliasId=$p(idstr,"^",m)
				s IsDisplayName=$lg($g(^User.MKBGlobalD(GlobalID,"ChildGloAlias",AliasId)),9)
				s MKBGAMark = $lg($g(^User.MKBGlobalD(GlobalID,"ChildGloAlias",AliasId)),8)
				s MKBGAMark=$Replace(MKBGAMark,",展示名","")
				s MKBGAMark=$Replace(MKBGAMark,"展示名,","")
				s MKBGAMark=$Replace(MKBGAMark,"展示名","")
				s re= ..SaveAliasLog(GlobalID, AliasId, "", "", "", "", "", MKBGAMark, "")
			}
		}
		else		//其他取序号第一的为展示名
		{
			s Seq=$o(^User.MKBGloAliasI("SeqIndex",GlobalID,""))
			s MKBGADesc=""
			for
			{
				s MKBGADesc=$o(^User.MKBGloAliasI("SeqIndex",GlobalID,Seq,MKBGADesc))  //遍历别名表
				q:MKBGADesc=""
				s AliasId=$o(^User.MKBGloAliasI("SeqIndex",GlobalID,Seq,MKBGADesc,0))
				s IsDisplayName=$lg($g(^User.MKBGlobalD(GlobalID,"ChildGloAlias",AliasId)),9)
				continue:(IsDisplayName="Y")
				s MKBGAMark = $lg($g(^User.MKBGlobalD(GlobalID,"ChildGloAlias",AliasId)),8)
				if (MKBGAMark'="")	//标志不为空
				{
					if (MKBGAMark'["展示名")	//不包含展示名
					{
						s MKBGAMark=MKBGAMark_",展示名"
						s:MKBGAMark'["查询名" MKBGAMark=MKBGAMark_",查询名"
					}
				}
				else
				{
					s MKBGAMark="展示名,查询名"
				}
				
				s re= ..SaveAliasLog(GlobalID, AliasId, "", "", "", "", "", MKBGAMark, "Y")
				s:re["false" errorflag=1
				q 
				
			}
		}
	}
	d ..KeepSameDesc(rowid)
	
	if (errorflag=1)
	{
		tro
		s result="false"
	}
	else
	{
		tc
		s result="true"
		
	}
	q result
}

/// Creator:钟荣枫
/// CreatDate:2020-09-11
/// Description:计算拆分global数量，方便计算进度
/// Input: rangeStr: 1=当前选中术语 2=当前搜索到的术语集合 3=词表内所有术语 
/// Output: ^TempSplitDataTotal 要拆分的数量
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).GetTotalCount()
ClassMethod GetTotalCount(rangeStr)
{
	k ^TempSplitDataTotal
	s ^TempSplitDataTotal=0
	if (rangeStr=1)                //对当前选中术语进行操作
    {
	}
	elseif(rangeStr=2)            //对当前搜索到的术语集合
	{
		s MKBGlobalID = 0
		s num=0
		for
		{
			s MKBGlobalID = $o(^TmpDataHandle(MKBGlobalID))
			q:MKBGlobalID=""
			s MKBGState=$lg($g(^User.MKBGlobalD(MKBGlobalID)),8)
			continue:(MKBGState'="U")	//过滤非在使用的
			s AlisaID=$o(^User.MKBGlobalD(MKBGlobalID,"ChildGloAlias",0))
			continue:AlisaID=""	//过滤没有别名的数据
			s num=num+1
		}
		s ^TempSplitDataTotal=num
	}
	elseif(rangeStr=3)            //对词表内所有术语
	{
		s num=0
		s MKBGlobalID = 0
		for
		{
			s MKBGlobalID = $o(^User.MKBGlobalD(MKBGlobalID))
			q:MKBGlobalID=""
			s MKBGState=$lg($g(^User.MKBGlobalD(MKBGlobalID)),8)
			continue:(MKBGState'="U")	//过滤非在使用的
			s AlisaID=$o(^User.MKBGlobalD(MKBGlobalID,"ChildGloAlias",0))
			continue:AlisaID=""	//过滤没有别名的数据
			s num=num+1
		}
		s ^TempSplitDataTotal=num
	}
	
	q ^TempSplitDataTotal
}

/// Creator:钟荣枫
/// CreatDate:2020-09-11
/// Description:计算拆分的进度
/// Output: rangeStr: 1=当前选中术语 2=当前搜索到的术语集合 3=词表内所有术语  
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).CountProgress()
ClassMethod CountProgress(rangeStr)
{
	q ^TempSplitDataCount
}

/// Creator:钟荣枫
/// CreatDate:2020-10-14
/// Description:修正原先的拆分处理中，未将仍有拆分残留的展示名追加拆分残留标记
/// Output: true 成功，false 失败
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).UpdateAlisaMark()
ClassMethod UpdateAlisaMark()
{
	s errorflag=0
	s result=""
	TS
	s AliasMarkStr="逗号残留,顿号残留,空格残留,分号残留,句号残留"
	s GlobalID = 0
	for
	{
		s GlobalID = $o(^User.MKBGlobalD(GlobalID))
		q:GlobalID=""
		s MKBGState=$lg($g(^User.MKBGlobalD(GlobalID)),8)
		continue:(MKBGState'="U")	//过滤非在使用的
		s HAlisaID=$o(^User.MKBGlobalD(GlobalID,"ChildGloAlias",0))
		continue:HAlisaID=""	//过滤没有别名的数据
		
		s leftstr=..IsLeave(GlobalID,AliasMarkStr,1)
		s leftflag=$p(leftstr,"^",1)
		if (leftflag=1)		//有拆词残留的情况下
		{
			s AliasId=$o(^User.MKBGloAliasI("DisplayName",GlobalID," Y",0))
			if (AliasId'="")
			{
				s MKBGAMark = $lg($g(^User.MKBGlobalD(GlobalID,"ChildGloAlias",AliasId)),8)
				//s obj=##class(User.MKBGloAlias).%OpenId(GlobalID_"||"_AliasId)
				if (MKBGAMark'="")
				{
					if (MKBGAMark'["拆词残留")
					{
						s MKBGAMark=MKBGAMark_",拆词残留"
					}
				}
				else
				{
					s MKBGAMark="展示名,查询名,拆词残留"
				}
				s rc= ..SaveAliasLog(GlobalID, AliasId, "", "", "", "", "", MKBGAMark, "")
				s:re["false" errorflag=1
			}
		}
		q:errorflag=1
		
	}
	if (errorflag=1)	//失败
	{
		tro	
		s result="false"
	}
	else	//成功
	{
		tc
		s result="true"
	}
	q result
}

/// Creator:钟荣枫
/// CreatDate:2020-10-15
/// Description:经过拆分处理后，仍存在残留，但感觉拆分结果和想象的不符合，感觉不正确，将别名恢复成原先的模样
/// Input: rangeStr: 1=当前选中术语 2=当前搜索到的术语集合 3=词表内所有术语  dataID: 当前术语id
/// Output: true 成功，false 失败
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).RecoveryAlisaHandle(210622)
ClassMethod RecoveryAlisaHandle(rangeStr, dataID)
{
	s result=""
	s errorflag=0
	TS
	if (rangeStr=1)                //对当前选中术语进行操作
    {
	    d ..RecoveryAlisa(dataID)
	    s:re["false" errorflag=1
	}
	elseif(rangeStr=2)            //对当前搜索到的术语集合
	{
		s MKBGlobalID = 0
		for
		{
			s MKBGlobalID = $o(^TmpDataHandle(MKBGlobalID))
			q:MKBGlobalID=""
			s MKBGState=$lg($g(^User.MKBGlobalD(MKBGlobalID)),8)
			continue:(MKBGState'="U")	//过滤非在使用的
			s AlisaID=$o(^User.MKBGlobalD(MKBGlobalID,"ChildGloAlias",0))
			continue:AlisaID=""	//过滤没有别名的数据
			s re= ..RecoveryAlisa(MKBGlobalID)
			s:re["false" errorflag=1
			q:errorflag=1
		}
	}
	elseif(rangeStr=3)            //对词表内所有术语
	{
		s MKBGlobalID = 0
		for
		{
			s MKBGlobalID = $o(^User.MKBGlobalD(MKBGlobalID))
			q:MKBGlobalID=""
			s MKBGState=$lg($g(^User.MKBGlobalD(MKBGlobalID)),8)
			continue:(MKBGState'="U")	//过滤非在使用的
			s AlisaID=$o(^User.MKBGlobalD(MKBGlobalID,"ChildGloAlias",0))
			continue:AlisaID=""	//过滤没有别名的数据
			
			s re= ..RecoveryAlisa(MKBGlobalID)
			s:re["false" errorflag=1
			q:errorflag=1
		}
	}
	if (errorflag=1)	//失败
	{
		tro	
		s result="false"
	}
	else	//成功
	{
		tc
		s result="true"
	}
	q result
}

/// Creator:钟荣枫
/// CreatDate:2020-10-15
/// Description:经过拆分处理后，仍存在残留，但感觉拆分结果和想象的不符合，感觉不正确，将别名恢复成原先的模样
/// Input: GlobalID 术语id
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).RecoveryAlisaHandle(210622)
ClassMethod RecoveryAlisa(GlobalID)
{
	
	s result="success"
	s errorflag=""
	s AliasMarkStr="逗号残留,顿号残留,空格残留,分号残留,句号残留"
	s leftstr=..IsLeave(GlobalID,AliasMarkStr,1)
	s leftflag=$p(leftstr,"^",1)
	TS
	if (leftflag=1)		//有拆词残留
	{
		//删除带残留的别名
		s leftidstr=$p(leftstr,"^",2)

		for n=1:1:$l(leftidstr,",")
		{
			s AliasId=$p(leftidstr,",",n)
			s result= ..DeleteAliasData(GlobalID_"||"_AliasId)
			if (result["false")		//删除失败
			{
				s errorflag=1
				q 
			}
		}
		
	}
	if (errorflag=1)	//失败
	{
		tro	
		s result="false"
	}
	else	//成功
	{
		tc
		s result="true"
	}
	q result
}

/// Creator:钟荣枫
/// CreatDate:2020-10-15
/// Description:  后缀处理  多级处理		     改为分三级，从最底层开始处理
/// （1）词表标记的一级节点   如果处理后在术语以及术语的别名中存在完全匹配的数据，则删除该数据（术语合并）
/// （2）词表标记的一级节点   如果处理后在术语以及术语的别名中不存在完全匹配的数据，则跳过
/// （3）词表标记的二级节点   如果处理后在术语以及术语的别名中存在完全匹配的数据，且不存在带一级节点后缀的该词，则  根据一级节点更改后缀，并合并到术语中
/// （4）词表标记的二级节点   如果处理后在术语以及术语的别名中存在完全匹配的数据，且存在带一级节点后缀的该词，则删除该词
/// Input: rangeStr: 1=当前选中术语 2=当前搜索到的术语集合 3=词表内所有术语  methodStr: 1=全部后缀，2=自选后缀，sufstr：后缀字符串，dataID 当前术语id,breakflag：是否一步步执行
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).SuffixHandle(2,2,"1710298,1710301",8090,1)
ClassMethod SuffixHandle(rangeStr As %String, methodStr, sufstr, dataID As %String, breakflag) As %String
{
	s result=""
	s FirtFloorstr=""
	s SecondFloorstr=""
	s ThirdFloorstr=""
	s base=$o(^User.MKBTermBaseI("DescIndex"," 全局化词表标记",0))
	
	s rowid=$o(^User.MKBTermI("DescIndex",base," 后缀",0))
	s markstrid=$o(^User.MKBTermI("DescIndex",base," 诊断",0))	//获取诊断
	s markstr=""		//##class(web.DHCBL.MKB.MKBTerm).GetChildOrderedIDStr(base,markstrid)
	//    根据范围获取一二三级节点         //
	if (methodStr=1)		//默认全部后缀
	{
		
		s FirtFloorstr=##class(web.DHCBL.MKB.MKBTerm).GetNextChildIDStr(base,rowid)	//后缀标记的下一层
		s SecondFloorstr=""
		for m=1:1:$l(FirtFloorstr,"^")
		{
			s myRowID=$p(FirtFloorstr,"^",m)
			s str=##class(web.DHCBL.MKB.MKBTerm).GetNextChildIDStr(base,myRowID)
			continue:(str="")
			if (SecondFloorstr="")	//二级节点为空
			{
				s SecondFloorstr=str
			}
			else
			{
				s SecondFloorstr=SecondFloorstr_"^"_str
			}
		}
		
		s ThirdFloorstr=""
		for n=1:1:$l(SecondFloorstr,"^")
		{
			s secondRowID=$p(SecondFloorstr,"^",n)
			continue:(secondRowID="")
			s str=##class(web.DHCBL.MKB.MKBTerm).GetNextChildIDStr(base,secondRowID)
			continue:(str="")
			if (ThirdFloorstr="")	//三级节点为空
			{
				s ThirdFloorstr=str
			}
			else
			{
				s ThirdFloorstr=ThirdFloorstr_"^"_str
			}
		}
		
	}
	elseif (methodStr=2)	//自选后缀
	{
		for m=1:1:$l(sufstr,",")		//节点
		{
			s myRowID=$p(sufstr,",",m)
			continue:(myRowID="")
			s MKBTLastLevelF=$LISTGET($G(^User.MKBTermD(myRowID)),5)   ///上级分类
			s MKBTDesc=$LISTGET($G(^User.MKBTermD(myRowID)),3)   ///中心词
			if (MKBTLastLevelF=rowid)	//一级节点
			{
				if (FirtFloorstr="")	//一级节点为空
				{
					s FirtFloorstr=myRowID
				}
				else
				{
					s FirtFloorstr=FirtFloorstr_"^"_myRowID
				}
			}
			else
			{
				s parent=$LISTGET($G(^User.MKBTermD(MKBTLastLevelF)),5)   ///上级分类2
				if (parent=rowid)	//二级节点
				{
					if (SecondFloorstr="")	//二级节点为空
					{
						s SecondFloorstr=myRowID
					}
					else
					{
						s SecondFloorstr=SecondFloorstr_"^"_myRowID
					}
				}
				else
				{
					s paparent=$LISTGET($G(^User.MKBTermD(parent)),5)   ///上级分类3
					if (paparent=rowid)	//三级节点
					{
						if (ThirdFloorstr="")	//三级节点为空
						{
							s ThirdFloorstr=myRowID
						}
						else
						{
							s ThirdFloorstr=ThirdFloorstr_"^"_myRowID
						}
					}
					
				} 
			}
			
		}
	}
	//    根据范围获取一二三级节点         //
	
	//    根据范围进行处理         //
	if (rangeStr=1)            //对当前搜索到的术语集合
	{
		if (ThirdFloorstr'="")	//三级节点不为空
		{
			s result= ..SuffixDoHandle(dataID, ThirdFloorstr,3,breakflag,markstr)
			
		}
		if (SecondFloorstr'="")		//二级节点不为空
		{
			s tresult=..SuffixDoHandle(dataID, SecondFloorstr,2,breakflag,markstr)
			s result=..GetSufHandleResult(result,tresult)
		}
		if (FirtFloorstr'="")	//一级节点不为空
		{
			s tresult=..SuffixDoHandle(dataID, FirtFloorstr,1,breakflag,markstr)
			s result=..GetSufHandleResult(result,tresult)
		}
		s:(result'="") result=dataID_","_result
		
		
	}
	elseif (rangeStr=2)            //对当前搜索到的术语集合
	{
		s endflag=0
		s FreqSort=""
		for
		{
			s FreqSort=$o(^TempHandle("Freq",FreqSort),-1)  q:FreqSort=""

			s MKBGlobalID = 0
			for
			{
				s MKBGlobalID=$o(^TempHandle("Freq",FreqSort,MKBGlobalID))  q:MKBGlobalID=""
				s MKBGState=$lg($g(^User.MKBGlobalD(MKBGlobalID)),8)
				continue:(MKBGState'="U")	//过滤非在使用的
				s AlisaID=$o(^User.MKBGlobalD(MKBGlobalID,"ChildGloAlias",0))
				continue:AlisaID=""	//过滤没有别名的数据
				s MKBGMark=$lg($g(^User.MKBGlobalD(MKBGlobalID)),10)
				s markflag=0		//只处理诊断的数据
				for m=1:1:$l(markstr,"^")
				{
					s markid=$p(markstr,"^",m)
					q:(markid="")
					s MKBTDesc=$LISTGET($G(^User.MKBTermD(markid)),3)   ///中心词
					s:(MKBGMark[MKBTDesc) markflag=1
					
				}
				continue:markflag=0
				s ^TempSuffixHandle=MKBGlobalID
				if (ThirdFloorstr'="")		//三级节点不为空
				{
					s tresult= ..SuffixDoHandle(MKBGlobalID, ThirdFloorstr,3,breakflag,markstr)
					if (breakflag=1)	//前台一步步执行
					{
						s result=..GetSufHandleResult(result,tresult)
					}
					
					
				}
				if (SecondFloorstr'="")		//二级节点不为空
				{
					s tresult=..SuffixDoHandle(MKBGlobalID, SecondFloorstr,2,breakflag,markstr)	
					if (breakflag=1)	//前台一步步执行
					{
						s result=..GetSufHandleResult(result,tresult)
					}
					
				}
				if (FirtFloorstr'="")	//一级节点不为空
				{
					s tresult=..SuffixDoHandle(MKBGlobalID, FirtFloorstr,1,breakflag,markstr)
					if (breakflag=1)	//前台一步步执行
					{
						s result=..GetSufHandleResult(result,tresult)
					}
				}
				if (result'="")	//结果不为空 
				{
					s result=MKBGlobalID_","_result
					s:breakflag=1 endflag=1		//一步步执行，需要跳出
				}
				q:endflag=1
			}
			q:endflag=1
		}
	}
	elseif(rangeStr=3)            //对词表内所有术语
	{
		s endflag=0
		s MKBGFreq = " "
	    for
	    {
		    s MKBGFreq = $o(^User.MKBGlobalI("MKBGFreqIndex",MKBGFreq),-1)
		    q:MKBGFreq=""

			s MKBGlobalID = 0
		    for
		    {
			    s MKBGlobalID = $o(^User.MKBGlobalI("MKBGFreqIndex",MKBGFreq,MKBGlobalID))
			    q:MKBGlobalID=""
			    s MKBGState=$lg($g(^User.MKBGlobalD(MKBGlobalID)),8)
				continue:(MKBGState'="U")	//过滤非在使用的
				s AlisaID=$o(^User.MKBGlobalD(MKBGlobalID,"ChildGloAlias",0))
				continue:AlisaID=""	//过滤没有别名的数据
				s MKBGMark=$lg($g(^User.MKBGlobalD(MKBGlobalID)),10)
				s markflag=0		//只处理诊断的数据
				for m=1:1:$l(markstr,"^")
				{
					s markid=$p(markstr,"^",m)
					q:(markid="")
					s MKBTDesc=$LISTGET($G(^User.MKBTermD(markid)),3)   ///中心词
					s:(MKBGMark[MKBTDesc) markflag=1
				}
				continue:markflag=0
				
				s ^TempSuffixHandle=MKBGlobalID
				if (ThirdFloorstr'="")		//三级节点不为空
				{
					s tresult=..SuffixDoHandle(MKBGlobalID, ThirdFloorstr,3,breakflag,markstr)
					if (breakflag=1)	//前台一步步执行
					{
						s result=..GetSufHandleResult(result,tresult)
					}
					
				}
				if (SecondFloorstr'="")		//二级节点不为空
				{
					s tresult=..SuffixDoHandle(MKBGlobalID, SecondFloorstr,2,breakflag,markstr)
					if (breakflag=1)		//前台一步步执行
					{
						s result=..GetSufHandleResult(result,tresult)
					}
					
				}
				if (FirtFloorstr'="")		//一级节点不为空
				{
					s tresult=..SuffixDoHandle(MKBGlobalID, FirtFloorstr,1,breakflag,markstr)
					if (breakflag=1)		//前台一步步执行
					{
						s result=..GetSufHandleResult(result,tresult)
					}
				}

				if (result'="")
				{
					s result=MKBGlobalID_","_result
					s:breakflag=1 endflag=1		//一步步执行，需要跳出
				}
				q:endflag=1
		    }
		    q:endflag=1
	    }
	}
	//    根据范围进行处理         //
	
	//将结果的术语和术语描述连接起来
	s resultstr=result
	q:resultstr="" ""
	if (resultstr'="")	//结果不为空
	{
		s result=""
		for m=1:1:$l(resultstr,",")
		{
			s global=$p(resultstr,",",m)
			q:global=""
			//显示展示名
			s AliasId=$o(^User.MKBGloAliasI("DisplayName",global," Y",0))
			s globaldesc = $lg($g(^User.MKBGlobalD(global,"ChildGloAlias",AliasId)),2) 
			
			if (result'="")		//结果不为空
			{
				s result=result_","_global_"^"_globaldesc
			}
			else
			{
				s result=global_"^"_globaldesc
			}
		}
	}
	q result
}

/// Creator:钟荣枫
/// CreatDate:2020-10-15
/// Description:  后缀处理 要合并的数据id串拼接
/// Input: result 先前的结果串，tresult 处理的串
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).GetSufHandleResult("259256,231050",231050)
ClassMethod GetSufHandleResult(result, tresult)
{
	if (result="")	//先前的结果串为空
	{
		s:(tresult'="") result=tresult
	}
	else
	{
		if (tresult'="")	//处理的串不为空
		{
			s sameflag=0
			for m=1:1:$l(result,",")
			{
				s globalid=$p(result,",",m)
				s:(globalid=tresult) sameflag=1
			}
			s:(sameflag=0) result=result_","_tresult
		}
	}
	q result
}

/// Creator:钟荣枫
/// CreatDate:2020-10-15
/// Description:  后缀处理 分层次进行处理 
/// Input: GlobalID 术语id，thestr 后缀id串，floor 第几层，breakflag 是否一步步执行，markstr 别名标志串
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).SuffixDoHandle("231050","1710289^1710303^1710304^1710305^1710306^1710298^1710293^1710295^1710307^1710292^1710300",1)
ClassMethod SuffixDoHandle(GlobalID, thestr, floor, breakflag, markstr)
{
	s result=""

	s endflag=0
	s AliasId=""
	for
	{
		s AliasId=$o(^User.MKBGlobalD(GlobalID,"ChildGloAlias",AliasId))  //遍历别名表
		q:AliasId=""
		s MKBGADesc = $lg($g(^User.MKBGlobalD(GlobalID,"ChildGloAlias",AliasId)),2) 
		s IsDisplayName=$lg($g(^User.MKBGlobalD(GlobalID,"ChildGloAlias",AliasId)),9)
		//continue:MKBGADesc'["不除外"

		for m=1:1:$l(thestr,"^")		//节点
		{
			s myRowID=$p(thestr,"^",m)
			continue:(myRowID="")
			s MKBTLastLevelF=$LISTGET($G(^User.MKBTermD(myRowID)),5)   ///上级分类
			s MKBTDesc=$LISTGET($G(^User.MKBTermD(myRowID)),3)   ///中心词
			s re1=MKBGADesc[MKBTDesc
			s re2=$p(MKBGADesc,MKBTDesc,2)
			s:floor=1 MKBTLastLevelF=""
			if ((re2="")&&(re1=1))
			{
				if ($d(^User.MKBGlobalD(GlobalID,"ChildGloAlias",AliasId))>0)
				{
					s theresu=..SuffixSuperiorHandle(MKBGADesc, MKBTDesc, GlobalID, AliasId, MKBTLastLevelF, myRowID,breakflag,markstr)
					if (breakflag=1)		//一步步执行
					{
						s result=..GetSufHandleResult(result,theresu)	//得到结果，结果去重
					}
				}
				
			}
			else	//不包含后缀,加上后缀查找
			{
				
				if (IsDisplayName="Y")		//只以术语的展示名添加各种 后缀，进行查找是否有完全匹配的术语霍别名
				{
					s sufdesc=MKBGADesc_MKBTDesc			//加上后缀
					s supexiststr= ..IsExist(sufdesc,GlobalID,1,markstr)

					s supexistflag=$p(supexiststr,"^",1)
					if (supexistflag=0)		//不存在
					{
						continue
					}
					else	//存在其他术语
					{
						s Globalflag=$p(supexiststr,"^",2)		//是否是术语
						s ID=$p(supexiststr,"^",3)	
						if (Globalflag=1)	//是术语
						{
							s existGlobal=ID
						}
						else
						{
							s existGlobal=$p(ID,"||",1)
						}
						if (existGlobal'=GlobalID)	
						{
							
							if (breakflag=1)	//一步步执行
							{
								s result=..GetSufHandleResult(result,existGlobal)	//得到结果，结果去重
							}
							else
							{
								s Freq1 = $lg($g(^User.MKBGlobalD(GlobalID)),11)
								s Freq2 = $lg($g(^User.MKBGlobalD(existGlobal)),11)
								if (Freq1>=Freq2)	//合并到频率较高的一方
								{
									d ..MergeGlobalData(GlobalID_","_existGlobal)
								}
								else
								{
									d ..MergeGlobalData(existGlobal_","_GlobalID)
								}
								
							}
						}
						
						
					}
				}
			}
		}
	}
	q result
}

/// Creator:钟荣枫
/// CreatDate:2020-10-15
/// Description: 后缀处理 根据是否存在上级节点进行处理
/// Input: MKBGADesc  别名描述，MKBTDesc 后缀描述，GlobalID 术语id，AliasId 别名id，MKBTLastLevelF 后缀上级分类，myRowID 后缀id，breakflag 是否一步步执行，markstr 别名标志串
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).SuffixSuperiorHandle()
ClassMethod SuffixSuperiorHandle(MKBGDesc, MKBTDesc, GlobalID, alisaid, superiorid, rowid, breakflag, markstr)
{
	s result=""
	if (superiorid="")	//无上级节点
	{
		s handledesc=##class(web.BDP.util.String).Replace(MKBGDesc,MKBTDesc,"")		//去除后缀
		//判断处理后在术语以及术语的别名中是否存在完全匹配的数据
		s existstr= ..IsExist(handledesc,GlobalID,1,markstr)
		s existflag=$p(existstr,"^",1)
		if (existflag=1)	//存在完全匹配的数据，则删除该数据（术语合并）
		{
			s Globalflag=$p(existstr,"^",2)		//是否是术语
			s ID=$p(existstr,"^",3)	
			if (Globalflag=1)	//是术语
			{
				s existGlobal=ID
			}
			else
			{
				s existGlobal=$p(ID,"||",1)
			}
				


			if (existGlobal=GlobalID)	//同一个术语,做删除
			{
				//d ..DeleteAliasData(GlobalID_"||"_alisaid)
			}
			else		//做合并
			{
				s result=existGlobal
				if (breakflag'=1)
				{
					s Freq1 = $lg($g(^User.MKBGlobalD(GlobalID)),11)
					s Freq2 = $lg($g(^User.MKBGlobalD(existGlobal)),11)
					if (Freq1>=Freq2)	//合并到频率较高的一方
					{
						d ..MergeGlobalData(GlobalID_","_existGlobal)
					}
					else
					{
						d ..MergeGlobalData(existGlobal_","_GlobalID)
					}
				}
				
			}
			
		}
	}
	else
	{
			
		s handledesc=##class(web.BDP.util.String).Replace(MKBGDesc,MKBTDesc,"")		//去除改后缀
		//判断处理后在术语以及术语的别名中是否存在完全匹配的数据
		s existstr= ..IsExist(handledesc,GlobalID,1,markstr)
		s existflag=$p(existstr,"^",1)
		if (existflag=1)	//如果处理后在术语以及术语的别名中存在完全匹配的数据，且不存在带一级节点后缀的该词，则  根据一级节点更改后缀，并合并到术语中
		{
			s Globalflag=$p(existstr,"^",2)		//是否是术语
			
			if (Globalflag=1)	//是术语
			{
			
				s ID=$p(existstr,"^",3)	
				if (ID=GlobalID)	//同一个术语,做删除
				{
					s Desc=$LISTGET($G(^User.MKBTermD(superiorid)),3)   ///中心词
					s supdesc=handledesc_Desc			//加上一级节点后缀
					s supexiststr= ..IsExist(supdesc,GlobalID,1,markstr)
					//s:supexiststr="0" supexiststr="0"
					s supexistflag=$p(supexiststr,"^",1)
					if (supexistflag=0)	//不存在带一级节点后缀的该词 ，并合并到术语中
					{
						d ..SaveAliasLog(GlobalID, alisaid, supdesc, "", "", "", "", "", "")
					}
					else	//存在完全匹配的数据，且存在带一级节点后缀的该词，则删除该词
					{
						s count=0
						s AliasId=0
						for
						{
							s AliasId=$o(^User.MKBGlobalD(GlobalID,"ChildGloAlias",AliasId))  //遍历别名表
							q:AliasId=""
							s count=count+1
						}
						if (count'=1)	//多个别名
						{
							d ..DeleteAliasData(GlobalID_"||"_alisaid)	//删除其下的别名
						}
						else	//只有一个别名
						{
							d ..DeleteAliasData(GlobalID_"||"_alisaid)
							d ..SaveGlobalLog(GlobalID, "", "","","D", "", "", "")
						}
					}
				}
				else		//做合并
				{
					S result=ID
					if (breakflag'=1)
					{
						s Freq1 = $lg($g(^User.MKBGlobalD(GlobalID)),11)
						s Freq2 = $lg($g(^User.MKBGlobalD(ID)),11)
						if (Freq1>=Freq2)	//合并到频率较高的一方
						{
							d ..MergeGlobalData(GlobalID_","_ID)
						}
						else
						{
							d ..MergeGlobalData(ID_","_GlobalID)
						}
					}
				}
				
			}
			else
			{
				s ID=$p(existstr,"^",3)	
				s existGlobal=$p(ID,"||",1)
				if (existGlobal=GlobalID)	//同一个术语
				{
					s Desc=$LISTGET($G(^User.MKBTermD(superiorid)),3)   ///中心词
					s supdesc=handledesc_Desc			//加上一级节点后缀
					s supexiststr= ..IsExist(supdesc,GlobalID,1,markstr)
					//s:supexiststr="0" supexiststr="0"
					s supexistflag=$p(supexiststr,"^",1)
					if (supexistflag=0)	//不存在带一级节点后缀的该词 ，并合并到术语中
					{
						d ..SaveAliasLog(GlobalID, alisaid, supdesc, "", "", "", "", "", "")

					}
					else	//存在完全匹配的数据，且存在带一级节点后缀的该词，则删除该词
					{
						s count=0
						s AliasId=0
						for
						{
							s AliasId=$o(^User.MKBGlobalD(GlobalID,"ChildGloAlias",AliasId))  //遍历别名表
							q:AliasId=""
							s count=count+1
						}
						if (count'=1)	//多个别名
						{
							d ..DeleteAliasData(GlobalID_"||"_alisaid)	//删除其下的别名
						}
						else	//只有一个别名
						{
							d ..DeleteAliasData(GlobalID_"||"_alisaid)
							d ..SaveGlobalLog(GlobalID, "", "","","D", "", "", "")

						}
					}

				}
				else		//做合并
				{
					S result=existGlobal
					if (breakflag'=1)
					{
						s Freq1 = $lg($g(^User.MKBGlobalD(GlobalID)),11)
						s Freq2 = $lg($g(^User.MKBGlobalD(existGlobal)),11)
						if (Freq1>=Freq2)	//合并到频率较高的一方
						{
							d ..MergeGlobalData(GlobalID_","_existGlobal)
						}
						else
						{
							d ..MergeGlobalData(existGlobal_","_GlobalID)
						}
					}
				}
			}
		}
		else
		{
			s Desc=$LISTGET($G(^User.MKBTermD(superiorid)),3)   ///中心词
			s supdesc=handledesc_Desc			//加上一级节点后缀
			s supexiststr= ..IsExist(supdesc,GlobalID,1)
			//s:supexiststr="0" supexiststr="0"
			s supexistflag=$p(supexiststr,"^",1)
			if (supexistflag=0)	//不存在带一级节点后缀的该词 ，并合并到术语中
			{
				d ..SaveAliasLog(GlobalID, alisaid, supdesc, "", "", "", "", "", "")

			}
			else
			{
				d ..DeleteAliasData(GlobalID_"||"_alisaid)
			}
		}
		
	}
	q result
}

/// Creator:钟荣枫
/// CreatDate:2020-10-26
/// Description:通过全局化词表和ICD2.0数据进行对照时存在问题，需要批量修改引用场景
/// Input：
/// Output: 
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).CheckReference()
ClassMethod CheckReference()
{
	s addcount=0
	s GlobalID=0
	for
	{
		s GlobalID=$o(^User.MKBGlobalReferenceI("InverAllIndex",GlobalID))
		q:GlobalID=""
		
		s InitiativeID=""		//场景id
		for
		{
			s InitiativeID=$o(^User.MKBGlobalReferenceI("InverAllIndex",GlobalID,"D",InitiativeID))
			q:InitiativeID=""
			s MKBTPDProDR=$LISTGET($G(^User.MKBTermProDetailD(InitiativeID)),6)		//属性id
			continue:(MKBTPDProDR="")
			
			s ReferenceID=$o(^User.MKBGlobalReferenceI("InverAllIndex",GlobalID,"D",InitiativeID,0))
			s PassiveAliasID = $lg($g(^User.MKBGlobalReferenceD(ReferenceID)),5)		//别名id
			s MKBGRDesc=$lg($g(^User.MKBGlobalD(GlobalID,"ChildGloAlias",PassiveAliasID)),2)  //描述
			
			s ProDetailDesc = $lg($g(^User.MKBTermProDetailD(InitiativeID)),3)	//引用描述
			if (MKBGRDesc'=ProDetailDesc)	//不一致，先看是否有相同的
			{
				s refid=""
				for
				{
					s refid=$o(^User.MKBTermProDetailI("ProIdx",MKBTPDProDR,refid))
					q:refid=""
					s MKBTPDDesc=$LISTGET($G(^User.MKBTermProDetailD(refid)),3)
					if (MKBTPDDesc=MKBGRDesc)	//和属于描述相同,修改
					{
						s Refrowid=$o(^User.MKBGlobalReferenceI("InverAllIndex",GlobalID,"D",refid,0))
						if (Refrowid="")  //无引用
						{
							s obj = ##class(web.Entity.MKB.MKBGlobalReference).%New()
							
							s obj.InitiativeFlag="D"			//发起引用，主动引用标识
							s obj.InitiativeID=refid				//发起引用词的ID
							s obj.PassiveID=GlobalID			//被引用词的ID
							s obj.PassiveAliasID=PassiveAliasID				//被引用词的名称列表ID
							d ..SaveReferenceEntity(obj)
							s addcount=addcount+1
							q
						}
					}
				}
			}
		}
		
	}
	q addcount
}

/// Creator:钟荣枫
/// CreatDate:2020-09-8
/// Description:处理术语和别名中的无效字符
/// Input：rangeStr: 1=当前选中术语 2=当前搜索到的术语集合 3=词表内所有术语  methodStr 要处理的无效字符串，dataID 当前术语id
/// Output: 
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).InvalidHandle()
ClassMethod InvalidHandle(rangeStr As %String, methodStr As %String, dataID As %String)
{
	s symbol=$case(symbol,"1":" ","2":"、","3":"。","4":"(0)",:"")
	
    if (rangeStr=1)                //对当前选中术语进行操作
    {
	    for m=1:1:$l(methodStr,",")
		{
			s characters=$p(methodStr,",",m)
			d ..DoInvalidHandle(characters,dataID)
		}
	    
	}
	elseif(rangeStr=2)            //对当前搜索到的术语集合
	{
		s MKBGlobalID = 0
		for
		{
			s MKBGlobalID = $o(^TmpDataHandle(MKBGlobalID))
			q:MKBGlobalID=""
			for m=1:1:$l(methodStr,",")
			{
				s characters=$p(methodStr,",",m)
				d ..DoInvalidHandle(characters,MKBGlobalID)
			}
			
		}
	}
	elseif(rangeStr=3)            //对词表内所有术语
	{
		s MKBGlobalID = 0
		for
		{
			s MKBGlobalID = $o(^User.MKBGlobalD(MKBGlobalID))
			q:MKBGlobalID=""
			s Desc  = $lg($g(^User.MKBGlobalD(MKBGlobalID)),3)
			for m=1:1:$l(methodStr,",")
			{
				s characters=$p(methodStr,",",m)
				d ..DoInvalidHandle(characters,MKBGlobalID)
			}
		}
	}
	q "success"
}

/// Creator:钟荣枫
/// CreatDate:2020-09-8
/// Description:处理术语和别名中的无效字符
/// Input：characters 后缀或者后缀 ，GlobalD 术语id
/// Output: 
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).DoInvalidHandle()
ClassMethod DoInvalidHandle(characters, GlobalD As %String)
{
	
	s Desc  = $lg($g(^User.MKBGlobalD(MKBGlobalID)),3)
	s re1=Desc[characters
	s re2=$p(Desc,characters,2)		//后缀
	s re3=$p(Desc,characters,1)		//前缀
	
	if (((re2="")||(re2=""))&&(re1=1))
	{
		d ..SaveGlobalLog(GlobalD, Desc, "","","", "", "", "")
	}
}

/// Creator:钟荣枫
/// CreatDate:2020-11-12
/// Description:术语拆分  寻找完全匹配的术语	查找展示名为选中别名的术语
/// Input：AlisaID 别名id
/// Output: 
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).IsMatch("9161||271809")
ClassMethod IsMatch(AlisaID)
{
	q:AlisaID="" "0"
	s result="0"
	
	s GlobalID=$p(AlisaID,"||",1)
	s AlisaRowID=$p(AlisaID,"||",2)
		
	s MatchDesc=$lg($g(^User.MKBGlobalD(GlobalID,"ChildGloAlias",AlisaRowID)),2)
	//寻找完全匹配的术语	 查找展示名为选中别名的术语
	s MatchGlobal=""
	s oldFreq=0
	s existID=0
	for			
	{
		
		
		s existID=$o(^User.MKBGloAliasI("NameIndex"," "_$ZCONVERT(MatchDesc,"U"),existID))
		q:existID=""
		continue:existID=GlobalID
		s MKBGState = $lg($g(^User.MKBGlobalD(existID)),8)
		continue:(MKBGState'="U")
		s theRowId=$o(^User.MKBGloAliasI("NameIndex"," "_$ZCONVERT(MatchDesc,"U"),existID,0))
		
		s IsDisplayName=$lg($g(^User.MKBGlobalD(existID,"ChildGloAlias",theRowId)),9)
		continue:(IsDisplayName'="Y")
		s MatchGlobal=existID
	}
	if (MatchGlobal="")		//需要新增
	{
		s result="0"
	}
	else	//已存在术语，提示重复
	{
		s result="1^"_MatchGlobal
	}
	
	q result
}

/// Creator:钟荣枫
/// CreatDate:2020-11-11
/// Description:术语拆分  将某个术语拆分开 
/// Input： RowIdStr 别名id的串, RefStr 引用的id串，global 匹配的术语id
/// Output: 
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).SplitGlobalData("8889||401815,8889||401816,8889||401817","150273,168865","")
ClassMethod SplitGlobalData(RowIdStr, RefStr, global)
{
	s result=""
	s length=$l(RowIdStr,",")
	if (length>=1)     //一条及以上数据
	{
		s GlobalID=$p($p(RowIdStr,",",1),"||",1)
		s dispalyalias=$p($p(RowIdStr,",",1),"||",2)
		s MatchDesc=$lg($g(^User.MKBGlobalD(GlobalID,"ChildGloAlias",dispalyalias)),2)
		
		s MatchGlobal=global

		if ((MatchGlobal="")||(MatchGlobal=0))		//新增，或者设为在用
		{
			s newid=$o(^User.MKBGlobalI("DescIndex"," "_$ZCONVERT(MatchDesc,"U"),0))
			if ((newid'="")&&(newid'=GlobalID))		//被合并的术语
			{
				s MatchGlobal=newid
			}
			else		//新增术语
			{
				
				s tobj = ##class(web.Entity.MKB.MKBGlobal).%New()
				s tobj.MKBGDesc = MatchDesc
				s tobj.MKBGMark = "常用诊断描述"
				s tobj.MKBGState="U"
				s re=..SaveGlobalEntity(tobj)
				s re=[].%FromJSON(re)
				s MatchGlobal=re.%Get("id")
			}
		}
		if ((MatchGlobal'="")&&((global=0)||(global="")))		//被合并的术语
		{
			d ..DeleteAllButGlobal(MatchGlobal)			//删除被合并的术语的所有别名、引用和频次
			s MKBGState = $lg($g(^User.MKBGlobalD(MatchGlobal)),8)
			if (MKBGState'="U")
			{
				d ..SaveGlobalLog(MatchGlobal, "", "","","U", "", "", 0)	//修改频率
			}
		}
		if (MatchGlobal'="")
		{
			//拆分别名
				
			for m=1:1:$l(RowIdStr,",")
			{
				s alias=$p(RowIdStr,",",m)
				q:alias=""
				s AliasRowId=$p(alias,"||",2)
				
				s MKBGAMark = $lg($g(^User.MKBGlobalD(GlobalID,"ChildGloAlias",AliasRowId)),8)
				s MKBGADesc=$lg($g(^User.MKBGlobalD(GlobalID,"ChildGloAlias",AliasRowId)),2)
				s sameflag=0
				s RowId=0				//描述不一致的，写入
				for
				{
					s RowId=$o(^User.MKBGlobalD(MatchGlobal,"ChildGloAlias",RowId))    //根据父表ID遍历子表ID
					q:RowId=""
					s ADesc=$lg($g(^User.MKBGlobalD(MatchGlobal,"ChildGloAlias",RowId)),2)
					if (MKBGADesc=ADesc)
					{
						s sameflag=1
						q
					}
				
				}
				if (sameflag=0)	//没有一致的别名
				{
					s IsDisplayName = "N"
					if (m=1)	//展示名
					{
						s IsDisplayName="Y"
						if (MKBGAMark'["展示名")
						{
							s MKBGAMark=MKBGAMark_",展示名"
						}
						
					}
					s eobj = ##class(web.Entity.MKB.MKBGloAlias).%New()
					s eobj.MKBGAParRef=MatchGlobal
					s eobj.MKBGADesc=MKBGADesc
					s eobj.MKBGAPYCode=$lg($g(^User.MKBGlobalD(GlobalID,"ChildGloAlias",AliasRowId)),3)
					s eobj.MKBGANote = $lg($g(^User.MKBGlobalD(GlobalID,"ChildGloAlias",AliasRowId)),4)
					s eobj.MKBGACEFlag=$lg($g(^User.MKBGlobalD(GlobalID,"ChildGloAlias",AliasRowId)),5)
					s eobj.IsDisplayName=IsDisplayName
					s eobj.MKBGAMark=MKBGAMark
					s sc= ..SaveAliasEntity(eobj)
				}
				
			}
			//拆分引用
			for n=1:1:$l(RefStr,",")
			{
				//MKBGADesc
				s refid=$p(RefStr,",",n)
				q:refid=""
				s InitiativeID = $lg($g(^User.MKBGlobalReferenceD(refid)),3)
				s InitiativeFlag = $lg($g(^User.MKBGlobalReferenceD(refid)),2)
				s PassiveAliasID = $lg($g(^User.MKBGlobalReferenceD(refid)),5)

				s AliasDesc=$lg($g(^User.MKBGlobalD(GlobalID,"ChildGloAlias",PassiveAliasID)),2)
					
				s newAliasid=$o(^User.MKBGloAliasI("DescIndex",MatchGlobal," "_$zconvert(AliasDesc,"U"),""))
				if (newAliasid'="")
				{
					s obj = ##class(User.MKBGlobalReference).%OpenId(refid)	//修改引用
								
					s obj.PassiveID = MatchGlobal
					s obj.PassiveAliasID = newAliasid
					d obj.%Save()
					d obj.%Close()
				}
				else
				{
					d ..DeleteReferenceData(refid)
				}
				
					
				
			}
			//删除原先的术语的别名	
			for n=1:1:length
			{
				s aliasrowid=$p(RowIdStr,",",n)
				d ##class(web.DHCBL.MKB.MKBGlobal).DeleteAliasData(aliasrowid)	//删除原先的术语的别名
			}
			//拆分频率
			if ((global="")||(global=0))	//新增或者修改原本被封闭的术语,需要修改频次
			{
			    s LocID = 0
			    for
			    {
				    s LocID = $o(^User.MKBGDiagLocI("ProfDeptDRIndex",GlobalID,LocID))
				    q:LocID=""
				    //判断MatchGlobal下是否存在该科室
				    if $d(^User.MKBGDiagLocI("ProfDeptDRIndex",MatchGlobal,LocID))
				    {
					    s ToFreqID = $o(^User.MKBGDiagLocI("ProfDeptDRIndex",MatchGlobal,LocID,0))
					    s obj = ##class(User.MKBGDiagLoc).%OpenId(ToFreqID)
					    s obj.Frequency = 1
					    s sc = obj.%Save()
					    d obj.%Close()
					    if $$$ISOK(sc)
					    {
						    s MKBGDiaTotalFreq = $lg($g(^User.MKBGlobalD(MatchGlobal)),11)
						    s MKBGDiaTotalFreq = MKBGDiaTotalFreq+1
							d ..SaveGlobalLog(MatchGlobal, "", "","","", "", "", MKBGDiaTotalFreq)
						}
					}
					else
					{
						s obj = ##class(User.MKBGDiagLoc).%New()
						d obj.DiaDRSetObjectId(MatchGlobal)
						d obj.ProfDeptDRSetObjectId(LocID)
						s obj.Frequency = 1
						s sc = obj.%Save()
					    d obj.%Close()
					    if $$$ISOK(sc)
					    {
						    s MKBGDiaTotalFreq = $lg($g(^User.MKBGlobalD(MatchGlobal)),11)
						    s MKBGDiaTotalFreq = MKBGDiaTotalFreq+1
							d ..SaveGlobalLog(MatchGlobal, "", "","","", "", "", MKBGDiaTotalFreq)
						}
					}
				}
			}
			d ##class(web.DHCBL.MKB.MKBGlobal).RefHandle("1","1,2",MatchGlobal)
			d ..DoSelfCheckAliasMark(MatchGlobal)		//检查别名标志是否存在错误
			
			s result="{success:'true',id:'"_MatchGlobal_"'}"
		}
		
		//原先的术语没有展示名时，添加展示名
		s aliasID=$o(^User.MKBGloAliasI("DisplayName",GlobalID," Y",0))
		if (aliasID="")	//展示名为空
		{
			s aliasDesc=$o(^User.MKBGloAliasI("SeqIndex",GlobalID,1,0))
			s aliasID=""
			s:aliasDesc'="" aliasID=$o(^User.MKBGloAliasI("SeqIndex",GlobalID,1,aliasDesc,0))
			if (aliasID'="")
			{
				s MKBGAMark = $lg($g(^User.MKBGlobalD(GlobalID,"ChildGloAlias",aliasID)),8)
				if (MKBGAMark'="")&&(MKBGAMark'["导入带审核")&&(MKBGAMark'["业务诊断")
				{
					s MKBGAMark= MKBGAMark_",展示名,查询名"
					
				}
				else
				{
					s MKBGAMark= "展示名"
				}
				d ..SaveAliasLog(GlobalID, aliasID, "", "", "", "", "", MKBGAMark, "Y")
			}
		}
		
	}
	q result
}

/// Creator:钟荣枫
/// CreatDate:2020-11-11
/// Description:根据别名获取对应的引用场景
/// Input: AliasRowID 别名id
/// Output:  引用的串
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).GetReference("8090||13546")
ClassMethod GetReference(AliasRowID)
{
	s result=""
	q:AliasRowID="" ""
	s GlobalID=$p(AliasRowID,"||",1)
	s AliasId=$p(AliasRowID,"||",2)
	s MKBGADesc=$lg($g(^User.MKBGlobalD(GlobalID,"ChildGloAlias",AliasId)),2)
	s MKBGAMark = $lg($g(^User.MKBGlobalD(GlobalID,"ChildGloAlias",AliasId)),8)
	s info=""
	s InitiativeFlag=""
	for
	{
		s InitiativeFlag=$o(^User.MKBGlobalReferenceI("InverAllIndex",GlobalID,InitiativeFlag))
		q:InitiativeFlag=""
		s InitiativeID=0
		for
		{
			s InitiativeID=$o(^User.MKBGlobalReferenceI("InverAllIndex",GlobalID,InitiativeFlag,InitiativeID))
			q:InitiativeID=""
			s RefRowID=$o(^User.MKBGlobalReferenceI("InverAllIndex",GlobalID,InitiativeFlag,InitiativeID,0))
			s PassiveAliasID = $lg($g(^User.MKBGlobalReferenceD(RefRowID)),5)
			//获取描述
			if (InitiativeFlag="T")		//临床实用诊断
			{
				s BaseRowId=$lg($g(^User.MKBTermD(InitiativeID)),4)
				s BaseDesc=$lg($g(^User.MKBTermBaseD(BaseRowId)),3)
				s MKBGRDesc=$lg($g(^User.MKBTermD(InitiativeID)),3)
						
				s MKBTActiveFlag=$listGet($g(^User.MKBTermD(InitiativeID)),9)
				if (MKBTActiveFlag="N")		//提示封闭	//判断是否是封闭状态
				{
					s info="存在引用的临床实用诊断已封闭！"
				}
				
	
				s MKBGRLevel=BaseDesc_"."_MKBGRDesc
			}
			elseif (InitiativeFlag="D")	//常用诊断表达式
			{
				s ProRowId=$lg($g(^User.MKBTermProDetailD(InitiativeID)),6)         //属性RowID
				q:ProRowId=""
				
				s TermRowId=$lg($g(^User.MKBTermPropertyD(ProRowId)),6)     //术语RowID
				s TermDesc=$lg($g(^User.MKBTermD(TermRowId)),3)             //术语描述
				s BaseRowId=$lg($g(^User.MKBTermD(TermRowId)),4)          //知识库RowID
				s BaseDesc=$lg($g(^User.MKBTermBaseD(BaseRowId)),3)        //知识库描述
		
				s:PassiveAliasID'="" MKBGRDesc=$lg($g(^User.MKBGlobalD(GlobalID,"ChildGloAlias",PassiveAliasID)),2)
				s:PassiveAliasID="" MKBGRDesc=$lg($g(^User.MKBGlobalD(GlobalID)),3) 
				
				s ProDesc=$lg($g(^User.MKBTermPropertyD(ProRowId)),3)         //属性名
				if (ProDesc = "常用诊断表达式")
				{
					s ProDetailDesc = $lg($g(^User.MKBTermProDetailD(InitiativeID)),3)
					s MKBGRLevel=BaseDesc_"."_TermDesc_"."_ProDesc_"."_ProDetailDesc
				}
				else
				{
					s MKBGRLevel=BaseDesc_"."_TermDesc_"."_ProDesc
				} 
			}
			elseif (InitiativeFlag="ICDCon")
			{
				s ICDCode = $lg($g(^User.MKBICDContrastD(InitiativeID)),4)
				s MKBGRLevel="各版本ICD对照.("_ICDCode_")"
				
				s MKBGRDesc=$lg($g(^User.MKBICDContrastD(InitiativeID)),3) 
			}
			elseif (InitiativeFlag="ICDSD")
			{
				s ICDCode =$lg($g(^User.MKBStructuredDataD(InitiativeID)),20)   
				s MKBGRLevel="医大一ICD.("_ICDCode_")"
				s MKBGRDesc=$lg($g(^User.MKBStructuredDataD(InitiativeID)),2) 
			}						
			continue:(MKBGRDesc'=MKBGADesc)
			if (result="")	//引用串为空
			{
				s result=RefRowID_"^"_MKBGRDesc_"^"_MKBGRLevel
			}
			else
			{
				s result=result_","_RefRowID_"^"_MKBGRDesc_"^"_MKBGRLevel
			}
		}
	}
	if ((result'["临床实用诊断")&&(MKBGAMark["临床实用诊断"))
	{
		s info="该别名不存在临床实用诊断的引用!"
	}
	s result = "{reidstr:'"_result_"',info:'"_info_"'}"
	q result
}

/// Creator:钟荣枫
/// CreatDate:2020-11-16
/// Description:批处理   部分术语的描述不存在于别名列表中，需要新增别名
/// Input：
/// Output: true 成功，false 失败
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).CheckForMissAlias()
ClassMethod CheckForMissAlias()
{
	s result=""
	s errorflag=0
	TS
	s base=$o(^User.MKBTermBaseI("DescIndex"," 全局化词表标记",0))
	s markstrid=$o(^User.MKBTermI("DescIndex",base," 诊断",0))	//获取诊断
	s markstr=##class(web.DHCBL.MKB.MKBTerm).GetChildOrderedIDStr(base,markstrid)
	
	s count=0
	s GlobalID=0
	for
	{
		s GlobalID=$o(^User.MKBGlobalD(GlobalID))
		q:GlobalID=""
		s MKBGDesc=$lg($g(^User.MKBGlobalD(GlobalID)),3)
		s MKBGState=$lg($g(^User.MKBGlobalD(GlobalID)),8)
	
		s sameflag=0
		s AliasId=0
		for
		{
			s AliasId=$o(^User.MKBGlobalD(GlobalID,"ChildGloAlias",AliasId))
			q:AliasId=""
			s MKBGADesc=$lg($g(^User.MKBGlobalD(GlobalID,"ChildGloAlias",AliasId)),2)
			if (MKBGADesc=MKBGDesc)	//重复
			{
				s sameflag=1
				q
			}
		}
		if (sameflag=0)		//不存在一致的描述
		{
			s count=count+1
			s taeobj=##class(web.Entity.MKB.MKBGloAlias).%New()    //新建一个别名表实体类存储需要保存的别名数据
			s taeobj.MKBGAParRef=GlobalID
			s taeobj.MKBGADesc=MKBGDesc
			s taeobj.MKBGAPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE($ZCONVERT(MKBGDesc,"U"))
			s taeobj.MKBGACEFlag="C"
			s taeobj.MKBGAMark = 2
			s taeobj.IsDisplayName="Y"
			s re= ..SaveAliasData(taeobj)
			s:re["false" errorflag=1
			
		}
		q:errorflag=1

	}
	if (errorflag=1)	//失败
	{
		s result="false"
		tro	
	}
	else
	{
		s result=count
		tc
	}
	q result
}

/// Creator:钟荣枫
/// CreatDate:2020-11-16
/// Description:批处理   部分术语的别名无序号，将无序号的别名批量处理，添加序号
/// Input：
/// Output: true 成功，false 失败
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).UpdateAliasSeq()
ClassMethod UpdateAliasSeq()
{
	s result=""
	s errorflag=0
	TS
	s GlobalID=0
	for
	{
		s GlobalID=$o(^User.MKBGlobalD(GlobalID))
		q:GlobalID=""
		q:errorflag=1
		s count=0
		s AliasId=0
		for
		{
			s AliasId=$o(^User.MKBGlobalD(GlobalID,"ChildGloAlias",AliasId))
			q:AliasId=""
			q:errorflag=1
			s count=count+1
			s sc= ..SaveAliasLog(GlobalID, AliasId, "", "", "", "", count, "", "")
			s:sc["false" errorflag=1
			/*	
			s MKBGASequence = $lg($g(^User.MKBGlobalD(GlobalID,"ChildGloAlias",AliasId)),7)
			if ((MKBGASequence="")||(MKBGASequence<0))	//序号小于0
			{
				 
				s Sequence=$o(^User.MKBGloAliasI("SeqIndex",GlobalID,""),-1)
				if ((Sequence="")||(Sequence<0))	//序号小于0
				{
					s Sequence=1
				}
				else
				{
					s Sequence=Sequence+1
				}
				
			}
			*/
			q:errorflag=1
			
		}
	}
	if (errorflag=1)	//失败
	{
		s result="false"
		tro	
	}
	else
	{
		s result="true"
		tc
	}
	q result
}

/// Creator:钟荣枫
/// CreatDate:2020-11-16
/// Description:删除术语的科室频次信息
/// Input：id 科室id
/// Output: true 成功，false 失败
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).DelDiagLocData(361143)
ClassMethod DelDiagLocData(id)
{

	s result = ""
	//new Entity对象，用于保存日志
	s eobj = ##class(web.Entity.MKB.MKBGDiagLoc).%New()
	s eobj.ID=id
	s eobj.DiaDR=$lg($g(^User.MKBGDiagLocD(id)),2)
	
	s eobj.ProfDeptDR=$lg($g(^User.MKBGDiagLocD(id)),3)
	s eobj.Frequency=$lg($g(^User.MKBGDiagLocD(id)),4)
	Tstart
	s sc=##class(User.MKBGDiagLoc).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tcommit
		s result = "{success:'true',info:'删除成功！'}"	
		s MKBGDesc=$lg($g(^User.MKBGlobalD(eobj.DiaDR)),3)
		//保存日志
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKBGDIAGLOC","User.MKBGDiagLoc","全局化词表频次子表",id,MKBGDesc,"D",eobj)
		d eobj.%Close()
	}
	else 
	{
		Trollback
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("全局化词表频次子表","web.DHCBL.MKB.MKBGlobal","DelDiagLocData",eobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

/// Creator:钟荣枫
/// CreatDate:2020-11-9
/// Description:获取结构化诊断的描述 有临床实用诊断用临床实用诊断，没有，用常用诊断表达式  多个常用诊断表达式，取用第一个
/// Input：GlobalID 术语id
/// Output: 有临床实用诊断，返回临床实用诊断id,常用诊断表达式返回表达式
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).GetReferenceIDS(201041)
ClassMethod GetReferenceIDS(GlobalID As %String)
{
	s IDStr=""
	s InitiativeID=0
	for
	{
		s InitiativeID=$o(^User.MKBGlobalReferenceI("InverAllIndex",GlobalID,"T",InitiativeID))    //通过索引表获得引用者的ID
		q:InitiativeID=""
		s MKBTActiveFlag=$listGet($g(^User.MKBTermD(InitiativeID)),9)
		continue:(MKBTActiveFlag="N")	//过滤封闭
		s IDStr=InitiativeID
		q		//取第一个临床实用诊断
	}
	if (IDStr="")	//没有临床实用诊断，取用常用诊断表达式
	{
		s InitiativeID=0
		for
		{
			s InitiativeID=$o(^User.MKBGlobalReferenceI("InverAllIndex",GlobalID,"D",InitiativeID))    //通过索引表获得引用者的ID
			q:InitiativeID=""
			
			s ProRowId=$lg($g(^User.MKBTermProDetailD(InitiativeID)),6)         //属性RowID
			q:ProRowId=""
			
			s TermRowId=$lg($g(^User.MKBTermPropertyD(ProRowId)),6)     //术语RowID
				
			s subId=$o(^User.MKBTermPropertyD(ProRowId,"ChildExtPro",0))
			s MKBTEPVValueStr=##class(web.DHCBL.MKB.MKBTermProDetail).GetExtendProValValue(ProRowId,subId,InitiativeID)
				
			s MKBTEPVValue=$p(MKBTEPVValueStr,"[A]",1)
			s MKBTEPVValueF=$p(MKBTEPVValueStr,"[A]",2)
			//s IDStr=TermRowId_"^"_ProRowId_":"_InitiativeID
			s IDStr=MKBTEPVValueF
			q		//取第一个常用诊断表达式
		}
	}
	q IDStr
}

/// Creator:钟荣枫
/// CreatDate:2020-11-9
/// Description:删除术语的别名、引用和频次
/// Input：术语id
/// Output: true 成功，false 失败
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).DeleteAllButGlobal(201041)
ClassMethod DeleteAllButGlobal(MKBGRowID)
{
	if (MKBGRowID="")	//术语id为空
	{
		q "false"
	}
	s result=""
	s errorflag=0
	TS
	s AliasRowId=0		//删除别名
	for 	
	{
		s AliasRowId=$o(^User.MKBGlobalD(MKBGRowID,"ChildGloAlias",AliasRowId))  
		q:AliasRowId=""
		s re1= ..DeleteAliasData(MKBGRowID_"||"_AliasRowId)
		s:re1["false" errorflag=1
		q:errorflag=1
	}
	s InitiativeFlag=""
	for
	{
		s InitiativeFlag=$o(^User.MKBGlobalReferenceI("InverAllIndex",MKBGRowID,InitiativeFlag))    //通过索引表获得引用者的ID
		q:InitiativeFlag=""
		q:errorflag=1
		s RefRowId=0
		for
		{
			s RefRowId=$o(^User.MKBGlobalReferenceI("InverAllIndex",MKBGRowID,InitiativeFlag,RefRowId))    //通过索引表获得引用者的ID
			q:RefRowId=""
			s RefenceRowId=$o(^User.MKBGlobalReferenceI("InverAllIndex",MKBGRowID,InitiativeFlag,RefRowId,0))
			if (RefenceRowId'="")				//删除引用
			{
				s re2= ##class(User.MKBGlobalReference).%DeleteId(RefenceRowId)	
				s:re2["false" errorflag=1
				q:errorflag=1	
			}
			
		}
	}
	s LocID = 0		//删除频率
    for
    {
	    s LocID = $o(^User.MKBGDiagLocI("ProfDeptDRIndex",MKBGRowID,LocID))
	    q:LocID=""
	    q:errorflag=1
	    if $d(^User.MKBGDiagLocI("ProfDeptDRIndex",MKBGRowID,LocID))	//存在科室信息 
	    {
		    s FreqID = $o(^User.MKBGDiagLocI("ProfDeptDRIndex",MKBGRowID,LocID,0))
		    s re3=..DelDiagLocData(FreqID)
		    s:re3["false" errorflag=1
		    q:errorflag=1
	    }
	    
    }
    if (errorflag=1)	//失败
    {
	   s result="false" 
	   tro
    }
    else
    {
	    s result="true" 
	    tc
    }
    q result
}

/// Creator:钟荣枫
/// CreatDate:2020-11-24
/// Description:删除术语的重复别名
/// Input：GlobalID 术语id
/// Output: true 成功，false 失败
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).DeleteSameAlias(9397)
ClassMethod DeleteSameAlias(GlobalID As %String = "")
{
	TS
	s result=""
	s errorflag=0
	s gcount=0
	
	s errorflag=0
	s DGlobalID=""
	for
	{
		s DGlobalID = $o(^User.MKBGloAliasI("DescIndex",DGlobalID))
		q:DGlobalID=""
		continue:((GlobalID'="")&&(GlobalID'=DGlobalID))
		q:errorflag=1
		s MKBGDesc=""
		for
		{
			s MKBGDesc=$o(^User.MKBGloAliasI("DescIndex",DGlobalID,MKBGDesc))
			q:MKBGDesc=""
			q:errorflag=1
			s updatealisa=""
			s updateflag=0
			k ^TEMPAMark
			
			
			s count=0
			s AliasID=0
			for
			{
				s AliasID=$o(^User.MKBGloAliasI("DescIndex",DGlobalID,MKBGDesc,AliasID))
				q:AliasID=""
				s AliasMark = $lg($g(^User.MKBGlobalD(DGlobalID,"ChildGloAlias",AliasID)),8)
				
				
				
				s count=count+1
				if (count>1)	//重复
				{
					s DAliasMark = $lg($g(^User.MKBGlobalD(DGlobalID,"ChildGloAlias",AliasID)),8)	//要被删除的别名的别名标志
					if (DAliasMark'="")
					{
						for m=1:1:$l(DAliasMark,",")
						{
							s DMarkP=$P(DAliasMark,",",m)
							continue:DMarkP=""
							if ($d(^TEMPAMark(DMarkP))<=0)	//原先没有的标志需要添加上
							{
								s ^TEMPAMark(DMarkP)=""
								s updateflag=1
							}								
						}	
					}
					s gcount=gcount+1
					s re= ..DeleteAliasData(DGlobalID_"||"_AliasID)
					s:re["false" errorflag=1	
				}
				else
				{
					s updatealisa=AliasID
					if (AliasMark'="")
					{
						for m=1:1:$l(AliasMark,",")
						{
							s MarkP=$P(AliasMark,",",m)
							continue:MarkP=""
							s ^TEMPAMark(MarkP)=""
						}	
					}
				}
				q:errorflag=1
			}
			s NewMark=""
			s Mark=""
			for
			{
				s Mark=$o(^TEMPAMark(Mark))
				q:Mark=""
				if (NewMark="")
				{
					s NewMark=Mark
				}
				else
				{
					s NewMark=NewMark_","_Mark
				}
			}
			if ((updateflag=1)&&(updatealisa'=""))	//和原先的别名标志不一样
			{
				d ..SaveAliasLog(DGlobalID,updatealisa,"","","","","",NewMark,"")
			}

		}
		
	}
	if (errorflag=0)	//未出错
	{
		d ..AddDisplayName(GlobalID)		//添加展示名
	}
	
	if (errorflag=0)	//成功
	{
		s result="true"
		tc
	}
	else
	{
		s result="false"
		tro
	}
	q result
}

/// Creator:钟荣枫
/// CreatDate:2020-11-30
/// Description:批处理    将术语的描述和展示名保持一致
/// Input：GlobalID 术语id
/// Output: true 成功，false 失败
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).KeepSameDesc()
ClassMethod KeepSameDesc(GlobalID As %String = "")
{
	s result=""
	s errorflag=0
	TS
	if (GlobalID="")	//入参术语ID为空
	{
		
		s GlobalID=0
		for
		{
			s GlobalID=$o(^User.MKBGlobalD(GlobalID))
			q:GlobalID=""
			q:errorflag=1
			s MKBGDesc=$lg($g(^User.MKBGlobalD(GlobalID)),3)		//术语描述
			s Alias=$o(^User.MKBGlobalD(GlobalID,"ChildGloAlias",0))
			
			if (Alias'="")	//存在别名
			{
				s aliasID=$o(^User.MKBGloAliasI("DisplayName",GlobalID," Y",0))

				if (aliasID="")		//别名不存在
				{
					d ..AddDisplayName(GlobalID)
				}
				else
				{
					s aliasID=$o(^User.MKBGloAliasI("DisplayName",GlobalID," Y",0))
					s MKBGADesc=$lg($g(^User.MKBGlobalD(GlobalID,"ChildGloAlias",aliasID)),2)
					if (MKBGADesc'=MKBGDesc)		//术语描述和展示名不一致
					{
						s sc= ..SaveGlobalLog(GlobalID, MKBGADesc, "","","", "", "", "")
						
						if (sc["false")
						{
							s errorflag=1
						}
					}
				}
			}
			
		}
	}
	else		//处理单个术语
	{
		s MKBGDesc=$lg($g(^User.MKBGlobalD(GlobalID)),3)		//术语描述
			
		s aliasID=$o(^User.MKBGloAliasI("DisplayName",GlobalID," Y",0))
		if (aliasID'="")
		{
		
			s MKBGADesc=$lg($g(^User.MKBGlobalD(GlobalID,"ChildGloAlias",aliasID)),2)
			if (MKBGADesc'=MKBGDesc)		//术语描述和展示名不一致
			{
				s sc= ..SaveGlobalLog(GlobalID, MKBGADesc, "","","", "", "", "")
				if (sc["false")
				{
					s errorflag=1
				}
			}
		}
		
	}
	if (errorflag=1)	//失败
	{
		s result="false"
		tro
	}
	else
	{
		s result="true"
		tc
	}
	q result
}

/// Creator:钟荣枫
/// CreatDate:2020-11-30
/// Description:批处理    同名合并  1、展示名一致的进行合并 2、合并后，同一描述的别名进行删除
/// Input：rangeStr  操作范围：1，当前术语，2 当前查询的术语集，3 所有的术语  dataID 当前选中的术语id
/// Output: true 成功，false 失败
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).MergeSameDesc(3,8090)
ClassMethod MergeSameDesc(rangeStr As %String, dataID As %String)
{
	s result=""
	s errorflag=0
	TS
	s count=0
	if (rangeStr=1)                //对当前选中术语进行操作
    {
	    s sc= ..DoMergeSameDesc(dataID)
	    if (sc["false")	//失败
		{
			s errorflag=1
		}
	}
	elseif(rangeStr=2)            //对当前搜索到的术语集合
	{
		s MKBGlobalID = 0
		for
		{
			s MKBGlobalID = $o(^TmpDataHandle(MKBGlobalID))
			q:MKBGlobalID=""
			s MKBGState=$lg($g(^User.MKBGlobalD(MKBGlobalID)),8)
			continue:(MKBGState'="U")	//过滤非在使用的
			s AlisaID=$o(^User.MKBGlobalD(MKBGlobalID,"ChildGloAlias",0))
			continue:AlisaID=""	//过滤没有别名的数据
			s count=count+1
			s sc= ..DoMergeSameDesc(MKBGlobalID)
			if (sc["false")	//失败
			{
				s errorflag=1
			}
			q:errorflag=1
		}
	}
	elseif(rangeStr=3)            //对词表内所有术语
	{
		s errorflag=0
		s MKBGFreq = " "
	    for
	    {
		    s MKBGFreq = $o(^User.MKBGlobalI("MKBGFreqIndex",MKBGFreq),-1)
		    q:MKBGFreq=""
		    q:errorflag=1
			s MKBGlobalID = 0
		    for
		    {
			    s MKBGlobalID = $o(^User.MKBGlobalI("MKBGFreqIndex",MKBGFreq,MKBGlobalID))
			    q:MKBGlobalID=""
			    
				s MKBGState=$lg($g(^User.MKBGlobalD(MKBGlobalID)),8)
				continue:(MKBGState'="U")	//过滤非在使用的
				s AlisaID=$o(^User.MKBGlobalD(MKBGlobalID,"ChildGloAlias",0))
				continue:AlisaID=""	//过滤没有别名的数据
				
				s count=count+1
				s sc= ..DoMergeSameDesc(MKBGlobalID)
				if (sc["false")
				{
					s errorflag=1
				}
				q:errorflag=1	
			}
		}
		
	}
	if (errorflag=1)	//失败
	{
		s result="false"
		tro
	}
	else
	{
		s result="true"
		tc
	}
	
	q result
}

/// Creator:钟荣枫
/// CreatDate:2020-11-30
/// Description:批处理    同名合并  1、展示名一致的进行合并 2、合并后，同一描述的别名进行删除
/// Input：GlobalID 术语id
/// Output: 成功true，失败 false
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).DoMergeSameDesc(8090)
ClassMethod DoMergeSameDesc(GlobalID As %String)
{
	s aliasID=$o(^User.MKBGloAliasI("DisplayName",GlobalID," Y",0))		//术语的展示名
	if (aliasID="")
	{
		d ..AddDisplayName(GlobalID)
	}
	s aliasID=$o(^User.MKBGloAliasI("DisplayName",GlobalID," Y",0))		//术语的展示名
	s Desc = $lg($g(^User.MKBGlobalD(GlobalID,"ChildGloAlias",aliasID)),2) 	//展示名
	
	s count=0
	s IDStr=""
	
	s MKBGlobalID=0
	for
	{
		s MKBGlobalID=$o(^User.MKBGloAliasI("NameIndex"," "_$zconvert(Desc,"U"),MKBGlobalID))
		q:MKBGlobalID=""
		continue:(GlobalID=MKBGlobalID)
		s count=count+1
		if (count>0)
		{
			s AliasID=$o(^User.MKBGloAliasI("NameIndex"," "_$zconvert(Desc,"U"),MKBGlobalID,0)) 
			s IsDisplayName=$lg($g(^User.MKBGlobalD(MKBGlobalID,"ChildGloAlias",AliasID)),9)
			if (IsDisplayName="Y")	//是展示名
			{
				if (IDStr="")		//拼接要合并的项
				{
					s IDStr=MKBGlobalID
				}
				else
				{
					s IDStr=IDStr_","_MKBGlobalID
				}
			}

		}		
	}
	s re=""
	if (IDStr'="")		//要进行合并的id串不为空
	{
		s IDStr=GlobalID_","_IDStr
		s re= ..MergeGlobalData(IDStr)
	}

	//同一描述的别名进行删除
	s re2= ..DeleteSameAlias(GlobalID)
	if ((re["false")||(re2["false"))	//其中一个失败
	{
		s result="false"
	}
	else
	{
		s result="true"	
	}
	q result
}

/// Creator:钟荣枫
/// CreatDate:2020-11-30
/// Description:批处理   处理所有带引号的别名 如  "xx
/// Input：
/// Output: true 成功，false 失败
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).HandleAliasWithQuotes()
ClassMethod HandleAliasWithQuotes()
{
	
	s result=""
	s errorflag=0
	TS
	s MKBGlobalID=0
	for
	{
		s MKBGlobalID=$o(^User.MKBGlobalD(MKBGlobalID))
		q:MKBGlobalID=""
		s TAliasID=$o(^User.MKBGlobalD(MKBGlobalID,"ChildGloAlias",0))
		continue:(TAliasID="")
		
		s AliasID=0
		for
		{
			s AliasID=$o(^User.MKBGlobalD(MKBGlobalID,"ChildGloAlias",AliasID))
			q:AliasID=""
			s MKBGADesc = $lg($g(^User.MKBGlobalD(MKBGlobalID,"ChildGloAlias",AliasID)),2)
			
			if (MKBGADesc["""")		//含引号
			{
				s MKBGADesc=##class(web.BDP.util.String).Replace(MKBGADesc,"""","")
				s re1= ..SaveAliasLog(MKBGlobalID, AliasID, MKBGADesc, "", "", "", "", "", "")	//保存别名
				s re2=..DeleteSameAlias(GlobalID)		//同一描述的别名进行删除
				if (re1["false")||(re2["false")
				{
					s errorflag=1
				}
			}
			q:errorflag=1
		}
		if (errorflag=0)	//未报错
		{
			s re3= ..KeepSameDesc(MKBGlobalID)
			if (re3["false")  //处理失败
			{
				s errorflag=1
			}
		}
		q:errorflag=1	
	}
	if (errorflag=1)	//出错
	{
		tro
		s result="false"
	}
	else
	{
		tc
		s result="true"	
	}
	
	q result
}

/// Creator：钟荣枫 
/// CreatDate: 2020-10-16
/// Description：导出同描述的术语和别名
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).ExportSameDescData()
ClassMethod ExportSameDescData()
{
	w "{""rows"":["
	s jsonstr=""
	s sum=0
	s GlobalID=""
	for
	{
		s GlobalID = $o(^User.MKBGloAliasI("DescIndex",GlobalID))
		q:GlobalID=""
		s MKBGState=$lg($g(^User.MKBGlobalD(GlobalID)),8)
		continue:(MKBGState'="U")	//过滤非在使用的
		s AlisaID=$o(^User.MKBGlobalD(GlobalID,"ChildGloAlias",0))
		continue:AlisaID=""	//过滤没有别名的数据
				
		s MKBGDesc=$lg($g(^User.MKBGlobalD(GlobalID)),3)
		
		s MKBGDesc=""
		for
		{
			s MKBGDesc=$o(^User.MKBGloAliasI("DescIndex",GlobalID,MKBGDesc))
			q:MKBGDesc=""
			s count=0
			s AliasID=0
			for
			{
				s AliasID=$o(^User.MKBGloAliasI("DescIndex",GlobalID,MKBGDesc,AliasID))
				q:AliasID=""
				s MKBGADesc = $lg($g(^User.MKBGlobalD(GlobalID,"ChildGloAlias",AliasID)),2)
				s count=count+1
				if (count>1)		//描述重复的数据
				{
					s AliasRowID=AliasID
					s thisStr="{""GlobalID"":"""_GlobalID_""",""MKBGDesc"":"""_MKBGDesc_""",""AliasRowID"":"""_AliasRowID_""",""MKBGADesc"":"""_MKBGADesc_"""}"
					if (jsonstr'="")
					{ 
						w ","
						s jsonstr=jsonstr_","_thisStr
					}
					else
					{
						s jsonstr=thisStr
					}
					s sum = sum+1
					w thisStr
		
		
				}
			}
		}
	}
	
	w "], ""total"":"_sum_"}"
	q ""
}

/// Creator:钟荣枫
/// CreatDate:2020-12-4
/// Description:批处理   删除所有被合并的术语的频次、别名、引用
/// Input：
/// Output: true 成功，false 失败
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).DeleteMergedData()
ClassMethod DeleteMergedData()
{
	s errorfalg=0
	s result=""
	TS
	s GlobalID=0
	for
	{
		s GlobalID = $o(^User.MKBGloAliasI("DescIndex",GlobalID))
		q:GlobalID=""
		s MKBGState=$lg($g(^User.MKBGlobalD(GlobalID)),8)
		if (MKBGState="M")		//删除被合并的术语的频次、别名、引用
		{
			s sc= ..DeleteAllButGlobal(GlobalID)
			s:sc["false" errorfalg=1
		}
		q:errorfalg=1
	}
	if (errorflag=1)	//出错
	{
		tro
		s result="false"
	}
	else
	{
		tc
		s result="true"	
	} 
	q result
}

/// Creator:钟荣枫
/// CreatDate:2020-12-9
/// Description:单修改术语的一个或者两个字段时，调用的保存日志方法
/// Input：id, desc 描述, state 状态, confirm 确认标识, mark 标志, freq 总频次
/// Output: result 保存结果
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).SaveGlobalLog(8090,"","","","","","","1")
ClassMethod SaveGlobalLog(id, desc, enname, note, state, confirm, mark, freq)
{
	s result=""
	if (id'="")		//修改
	{
		s MKBGCode=$lg($g(^User.MKBGlobalD(id)),2)
		s MKBGDesc=$lg($g(^User.MKBGlobalD(id)),3)
		s MKBGEnName=$lg($g(^User.MKBGlobalD(id)),4)
		s MKBGNote=$lg($g(^User.MKBGlobalD(id)),5)
		s MKBGPYCode=$lg($g(^User.MKBGlobalD(id)),6)
		s MKBGLastLevel=$lg($g(^User.MKBGlobalD(id)),7)
		s MKBGState=$lg($g(^User.MKBGlobalD(id)),8)
		s MKBConfirm =$lg($g(^User.MKBGlobalD(id)),9)
		s MKBGloMark =$lg($g(^User.MKBGlobalD(id)),10)
		s MKBGDiaTotalFreq = $lg($g(^User.MKBGlobalD(id)),11)
		if (desc'="")	//修改描述时，同时修改拼音码
		{
			s MKBGDesc=desc
			s MKBGPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE($ZCONVERT(desc,"U"))
		}
		s:enname'="" MKBGEnName=enname
		s:note'="" MKBGNote=note
		s:state'="" MKBGState=state
		s:confirm'="" MKBConfirm=confirm
		s:mark'="" MKBGloMark=mark
		s:freq'="" MKBGDiaTotalFreq=freq
	}
	else		//新增
	{
		s MKBGCode=""
		s MKBGDesc=desc
		s MKBGEnName=enname
		s MKBGNote=note
		s MKBGPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE($ZCONVERT(desc,"U"))
		s MKBGLastLevel=""
		s MKBGState=state
		s MKBConfirm =confirm
		s MKBGloMark =mark
		s MKBGDiaTotalFreq = freq
	}
	s bobj = ##class(web.Entity.MKB.MKBGlobal).%New()
	s bobj.MKBGRowId = id
	s bobj.MKBGCode = MKBGCode
	s bobj.MKBGDesc = MKBGDesc
	s bobj.MKBGEnName=MKBGEnName
	s bobj.MKBGNote = ##class(web.DHCBL.BDP.FunLib).Util(MKBGNote)
	s bobj.MKBGPYCode=  MKBGPYCode
	s bobj.MKBGLastLevel=MKBGLastLevel
	
	s bobj.MKBGState=MKBGState
	s bobj.MKBGConfirm=MKBConfirm
	s bobj.MKBGMark = MKBGloMark
	s bobj.MKBGDiaTotalFreq=MKBGDiaTotalFreq
	s result= ..SaveGlobalEntity(bobj)
	if ((bobj.MKBGRowId="")&&(result'["false"))    //如果新增中心词，同时保存为别名
 	{
	 	s eaobj=##class(web.Entity.MKB.MKBGloAlias).%New()
	 	s eaobj.MKBGADesc=eobj.MKBGDesc
	 	s eaobj.MKBGAParRef=id
	 	s eaobj.MKBGACEFlag="C"
	 	s eaobj.MKBGAMark="6"	//设为展示名
	 	s eaobj.IsDisplayName="Y"
	 	d ..SaveAliasData(eaobj)
	 	
 	}
	q result
}

/// Creator:钟荣枫
/// CreatDate:2020-12-9
/// Description:单修改别名的一个或者两个字段时，调用的保存日志方法
/// Input：parref 术语id,AliasRowId 别名id, desc 描述,note 备注，activeflag 是否激活, state 状态, seq 顺序号, mark 标志, display 是否展示名
/// Output: result 保存结果
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).SaveAliasLog()
ClassMethod SaveAliasLog(parref, AliasRowId, desc, note, activeflag, state, seq, mark, display)
{
	s result=""
	s MKBGARowId=parref_"||"_AliasRowId
	if (AliasRowId'="")		//修改
	{
		s MKBGADesc=$lg($g(^User.MKBGlobalD(parref,"ChildGloAlias",AliasRowId)),2)
		s MKBGAPYCode=$lg($g(^User.MKBGlobalD(parref,"ChildGloAlias",AliasRowId)),3)
		s MKBGANote=$lg($g(^User.MKBGlobalD(parref,"ChildGloAlias",AliasRowId)),4)
		s MKBGACEFlag=$lg($g(^User.MKBGlobalD(parref,"ChildGloAlias",AliasRowId)),5)
		s MKBGAState=$lg($g(^User.MKBGlobalD(parref,"ChildGloAlias",AliasRowId)),6)
		s MKBGASequence = $lg($g(^User.MKBGlobalD(parref,"ChildGloAlias",AliasRowId)),7)
		s MKBGAMark = $lg($g(^User.MKBGlobalD(parref,"ChildGloAlias",AliasRowId)),8)
		s IsDisplayName=$lg($g(^User.MKBGlobalD(parref,"ChildGloAlias",AliasRowId)),9)
		if (desc'="")	//修改描述时，同时修改拼音码
		{
			s MKBGADesc=desc
			s MKBGAPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE($ZCONVERT(desc,"U"))
		}
		s:note'="" MKBGANote=note
		s:activeflag'="" MKBGACEFlag=activeflag
		s:state'="" MKBGAState=state
		s:seq'="" MKBGASequence=seq
		s:mark'="" MKBGAMark=mark
		s:display'="" IsDisplayName=display

	}
	else		//新增
	{
		s MKBGARowId=""
		s MKBGADesc=desc
		s MKBGAPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE($ZCONVERT(desc,"U"))
		s MKBGANote=note
		s:activeflag="" activeflag="C"
		s MKBGACEFlag=activeflag
		s MKBGAState=state
		
		s MKBGASequence = seq
		s MKBGAMark =mark
		s IsDisplayName=display
	}
	s bobj = ##class(web.Entity.MKB.MKBGloAlias).%New()
	s bobj.MKBGARowId = MKBGARowId
	s bobj.MKBGAParRef=parref
	s bobj.MKBGADesc=MKBGADesc
	s bobj.MKBGAPYCode=  MKBGAPYCode
	s bobj.MKBGANote = ##class(web.DHCBL.BDP.FunLib).Util(MKBGANote)
	s bobj.MKBGACEFlag=MKBGACEFlag
	s bobj.MKBGAState=MKBGAState
	s bobj.MKBGASequence=MKBGASequence
	s bobj.MKBGAMark=MKBGAMark
	s bobj.IsDisplayName=IsDisplayName
	
	s result= ..SaveAliasEntity(bobj)
	d:((result'="false")&&(MKBGARowId="")) ..RefHandle("1","1,2",parref)	//添加引用
	d:IsDisplayName="Y" ..KeepSameDesc(parref)	//保持展示名和术语描述一致
	q result
}

/// Creator:钟荣枫
/// CreatDate:2020-12-9
/// Description:保存数据到全局化词表引用表中
/// Table : User.MKBGlobalReference
/// Entity : web.Entity.MKB.MKBGlobalReference
/// Return:成功返回success:'true'和新增或修改的数据的ID;失败返回success:'false'和失败原因
/// w ##class(web.DHCBL.MKB.MKBGlobal).SaveReferenceEntity(eobj)
ClassMethod SaveReferenceEntity(eobj As web.Entity.MKB.MKBGlobalReference) As %String
{
	s result=""
	if $IsObject(eobj)
	{	
		//Index PassiveAliasIndex On (PassiveID As Exact, PassiveAliasID As Exact, InitiativeFlag As Exact, InitiativeID As Exact);
		s MKBGRRowid=$o(^User.MKBGlobalReferenceI("PassiveAliasIndex",eobj.PassiveID,eobj.PassiveAliasID,eobj.InitiativeFlag,eobj.InitiativeID,0)) 
		if ((MKBGRRowid'="")&&(MKBGRRowid'=eobj.MKBGRRowid))			//校验重复存在
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}

		if (eobj.MKBGRRowid="")	//新增
		{	
	        s obj=##class(User.MKBGlobalReference).%New()
		}
		else	//修改
		{
			s obj=##class(User.MKBGlobalReference).%OpenId(eobj.MKBGRRowid)
			s bobj = ##class(web.Entity.MKB.MKBGlobalReference).%New()
			s bobj.MKBGRRowid = eobj.MKBGRRowid
			
			s bobj.InitiativeFlag=obj.InitiativeFlag				//发起引用，主动引用标识
			s bobj.InitiativeID=obj.InitiativeID				//发起引用词的ID
			s bobj.PassiveID=obj.PassiveID				//被引用词的ID
			s bobj.PassiveAliasID=obj.PassiveAliasID				//被引用词的名称列表ID
		}

		s obj.InitiativeFlag=eobj.InitiativeFlag				
		s obj.InitiativeID=eobj.InitiativeID
		s obj.PassiveID=eobj.PassiveID
		s obj.PassiveAliasID=eobj.PassiveAliasID				
		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.MKBGRRowid="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_GlobalReference","User.MKBGlobalReference","全局化词表引用表",id,eobj.PassiveID_"-"_eobj.InitiativeID,"A",eobj)
			d:eobj.MKBGRRowid'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_GlobalReference","User.MKBGlobalReference","全局化词表引用表",id,eobj.PassiveID_"-"_eobj.InitiativeID,"U",eobj,bobj)
			
		}
		else
		{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("全局化词表引用表","web.DHCBL.MKB.MKBGlobal","SaveReferenceEntity",eobj)
    		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
		}	
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/// Creator:钟荣枫
/// CreatDate:2020-12-4
/// Description:批处理   检查术语的代码
/// Input：
/// Output: true 成功，false 失败
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).CheckGlobalCode()
ClassMethod CheckGlobalCode()
{
	s errorflag=0
	s result=""
	TS
	s updatecount=0
	
			
	s GlobalID=0
	for
	{
		s GlobalID=	$o(^User.MKBGlobalD(GlobalID))
		q:GlobalID=""
		q:errorflag=1
		//s Numcount=Numcount+1
		s MKBGCode=$lg($g(^User.MKBGlobalD(GlobalID)),2)
	
		s updatecount=updatecount+1
		
		s obj=##class(User.MKBGlobal).%OpenId(GlobalID)
		s bobj = ##class(web.Entity.MKB.MKBGlobal).%New()
		s bobj.MKBGRowId = GlobalID
		
			
		s bobj.MKBGCode = obj.MKBGCode+100000000
		s bobj.MKBGDesc = obj.MKBGDesc
		s bobj.MKBGEnName=obj.MKBGEnName
		s bobj.MKBGNote = ##class(web.DHCBL.BDP.FunLib).Util(obj.MKBGNote)
		s bobj.MKBGPYCode=  obj.MKBGPYCode
		s bobj.MKBGLastLevel=obj.MKBGLastLevel
		
		s bobj.MKBGState=obj.MKBGState
		s bobj.MKBGConfirm=obj.MKBGConfirm
		s bobj.MKBGMark = obj.MKBGMark
		s bobj.MKBGDiaTotalFreq=obj.MKBGDiaTotalFreq
		s re=..SaveGlobalEntity(bobj)
		;w updatecount,!
		;s:re["false" errorflag=1
		if (re["false")
		{
			s errorflag=1
		}
		
		
		
	}
	;w "end",!
	s Numcount=0
	s GlobalID=0
	for
	{
		s GlobalID=	$o(^User.MKBGlobalD(GlobalID))
		q:GlobalID=""
		q:errorflag=1
		s Numcount=Numcount+1
		s MKBGCode=$lg($g(^User.MKBGlobalD(GlobalID)),2)
			
		s obj=##class(User.MKBGlobal).%OpenId(GlobalID)
		s bobj = ##class(web.Entity.MKB.MKBGlobal).%New()
		s bobj.MKBGRowId = GlobalID
		
		s bobj.MKBGCode = Numcount
		s bobj.MKBGDesc = obj.MKBGDesc
		s bobj.MKBGEnName=obj.MKBGEnName
		s bobj.MKBGNote = ##class(web.DHCBL.BDP.FunLib).Util(obj.MKBGNote)
		s bobj.MKBGPYCode=  obj.MKBGPYCode
		s bobj.MKBGLastLevel=obj.MKBGLastLevel
		
		s bobj.MKBGState=obj.MKBGState
		s bobj.MKBGConfirm=obj.MKBGConfirm
		s bobj.MKBGMark = obj.MKBGMark
		s bobj.MKBGDiaTotalFreq=obj.MKBGDiaTotalFreq
		s re=..SaveGlobalEntity(bobj)
		;w Numcount,!
		;s:re["false" errorflag=1
		if (re["false")
		{
			s errorflag=1
			;b ;
		}
		
	}
	
	
	if (errorflag=1)	//出错
	{
		tro
		s result="false"
	}
	else
	{
		tc
		s result="true"	
	} 
	q result
}

/// Creator:钟荣枫
/// CreatDate:2021-1-18
/// Description:删除术语的别名、引用和频次,并将删除术语
/// Input：术语id
/// Output: true 成功，false 失败
/// Other:w ##class(web.DHCBL.MKB.MKBGlobal).DeleteAll(201041)
ClassMethod DeleteAll(MKBGRowID)
{
	q:MKBGRowID="" "false"
	s result=""
	s re= ..DeleteAllButGlobal(MKBGRowID)
	s:re["false" result="false"
	s gre=..DeleteGlobalData(MKBGRowID)
	
	//s gre=..SaveGlobalLog(MKBGRowID, "", "","","D", "", "", "")
	s:gre["false" result="false"
	if (result="")
	{
		s result="true"
	}
	q result
}

/// Creator:钟荣枫
/// CreatDate:2021-1-18
/// Description：
/// Table：根据诊断表达式和术语ID，判断是否有这个引用
/// Input：structstr 结构化串，GlobalID 术语ID
/// Return：0 不存在 ， 1 存在,
/// Other: w ##class(web.DHCBL.MKB.MKBGlobal).ReffenceIsExist("16327-24015:878434,1776434:S128960",1)
ClassMethod ReffenceIsExist(structstr, GlobalID)
{
	q:((structstr="")||(GlobalID="")) 0
	//16327-24015:878434,1776434:S128960
	s result=0
	s termid=$p(structstr,"-",1)
	s detailstr=$p(structstr,"-",2)
	if '$d(^User.MKBTermD(termid))	//临床实用诊断不存在
	{
		q 0
	}
	s MKBProRowid = $o(^User.MKBTermPropertyI("DescIndex",termid," 常用诊断表达式",0))
	//9439980
	s RefRowID=""
	s endflag=0
	s MKBTPDRowId=""
	for  
	{	
		s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProIdx",MKBProRowid,MKBTPDRowId)) 
		q:MKBTPDRowId=""
		q:endflag=1
		s subId=0  //循环扩展属性子表User.MKBTermProperty
		for 
		{
			S subId=$o(^User.MKBTermPropertyD(MKBProRowid,"ChildExtPro",subId)) q:subId=""
			q:endflag=1
			s MKBTEPVValueStr=##class(web.DHCBL.MKB.MKBTermProDetail).GetExtendProValValue(MKBProRowid,subId,MKBTPDRowId)
			s MKBTEPVValue=$p(MKBTEPVValueStr,"[A]",1)
			s MKBTEPVValueF=$p(MKBTEPVValueStr,"[A]",2)
			if (MKBTEPVValueF=structstr)
			{
				s RefRowID=MKBTPDRowId
				s endflag=1
			}
		}
	}
	if (RefRowID'="")
	{
		s ReferenceID=$o(^User.MKBGlobalReferenceI("InverAllIndex",GlobalID,"D",RefRowID,0))
		s:ReferenceID'="" result=1
	}
	q result
}

/// Creator:钟荣枫
/// CreatDate:2020-11-26
/// Description：
/// Table：根据诊断表达式和术语ID，添加引用
/// Input：structstr 结构化串，GlobalID 术语ID,Desc 描述
/// Return："{success:'false',errorinfo:失败原因}"
/// Other: w ##class(web.DHCBL.MKB.MKBGlobal).AddReffence("16327-1776434:S128960",8788,"肾透明细胞癌")
ClassMethod AddReffence(structstr, GlobalID, Desc)
{
	q:(structstr="") "{success:'false',errorinfo:'诊断表达式为空！'}"
	q:(GlobalID="") "{success:'false',errorinfo:'术语为空！'}"
	q:(Desc="") "{success:'false',errorinfo:'术语描述为空！'}"
	//16327-24015:878434,1776434:S128960
	s result="{success:'true'}"
	s termid=$p(structstr,"-",1)
	s detailstr=$p(structstr,"-",2)
	if '$d(^User.MKBTermD(termid))	//临床实用诊断不存在
	{
		q "{success:'false',errorinfo:'临床实用诊断不存在！'}"
	}
	s MKBProRowid = $o(^User.MKBTermPropertyI("DescIndex",termid," 常用诊断表达式",0))
	s sub= $o(^User.MKBTermPropertyD(MKBProRowid,"ChildExtPro",0))
	//4332667[A]15805-17196:1877251,8878483:S12524
	s MKBTPDExtend=sub_"[A]"_structstr
	s SameProValValueID= ##class(web.DHCBL.MKB.MKBTermProDetail).GetSameProValValueID(MKBProRowid,structstr)
	if (SameProValValueID'="")	//找到相同结构化结果的项,不新增
	{
		s rowid=$p(SameProValValueID,",",1)		//取第一个id
	}
	else	//新增
	{
		if (detailstr'="")	//是常用诊断表达式
		{
			s bobj = ##class(web.Entity.MKB.MKBTermProDetail).%New()
			s bobj.MKBTPDCode = ##class(web.DHCBL.BDP.FunLib).GetPYCODE(Desc)
			
			s bobj.MKBTPDDesc = ##class(web.DHCBL.BDP.FunLib).Util(Desc)
			s bobj.MKBTPDProDR = MKBProRowid
			s bobj.MKBTPDActiveFlag=  "Y"
			s bobj.MKBTPDRemark = ""
			s bobj.MKBTPDSequence=  ""
			s bobj.MKBTPDPYCode = ##class(web.DHCBL.MKB.MKBTermProDetail).Filter(Desc)
			s bobj.MKBTPDPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(bobj.MKBTPDPYCode)
			s bobj.MKBTPDPYCode= ##class(web.DHCBL.BDP.FunLib).Util(bobj.MKBTPDPYCode)
			s bobj.MKBTPDExtend=MKBTPDExtend			
			s re=##class(web.DHCBL.MKB.MKBTermProDetail).SaveData(bobj)	
			if (re["true")	//保存到临床实用诊断-常用诊断表达式
			{

				s rowid=$p($p(re,"id:'",2),"'}",1)
			}
			else
			{
				if (re["存在")
				{
					s code=##class(web.DHCBL.BDP.FunLib).GetPYCODE(Desc)
					s rowid=$o(^User.MKBTermProDetailI("CodeIndex",MKBProRowid," "_$zconvert(code,"U"),0)) 
				}
				else
				{
					q re
				}
				
			}
		}
		else
		{
			s rowid=termid	
		}
		
	}
	if (rowid'="")
	{
		s AliasID = $o(^User.MKBGloAliasI("DescIndex",GlobalID," "_Desc,0))
		if (detailstr'="")	//是常用诊断表达式
		{
			if (AliasID'="")	//保存到全局化词表-引用表
			{
				s eobj = ##class(web.Entity.MKB.MKBGlobalReference).%New()
				
				s eobj.InitiativeFlag="D"				//发起引用，主动引用标识
				s eobj.InitiativeID=rowid				//发起引用词的ID
				s eobj.PassiveID=GlobalID				//被引用词的ID
				s eobj.PassiveAliasID=AliasID				//被引用词的名称列表ID
				s re2=..SaveReferenceEntity(eobj)
				if (re2["true")	//保存到临床实用诊断-常用诊断表达式
				{

					d ##class(web.DHCBL.MKB.MKBGlobal).DoSelfCheckAliasMark(GlobalID)
				}
				else
				{
					if (re2["存在")
					{
						s MKBGRRowid=$o(^User.MKBGlobalReferenceI("InverAllIndex",GlobalID,"D",rowid,0))
					}
					else
					{
						q re2
					}
					
				}
			}
		}
		else		//临床实用诊断
		{
			
			if (AliasID'="")	//保存到全局化词表-引用表
			{
				s eobj = ##class(web.Entity.MKB.MKBGlobalReference).%New()
				
				s eobj.InitiativeFlag="T"				//发起引用，主动引用标识
				s eobj.InitiativeID=rowid				//发起引用词的ID
				s eobj.PassiveID=GlobalID				//被引用词的ID
				s eobj.PassiveAliasID=AliasID				//被引用词的名称列表ID
				s re2=..SaveReferenceEntity(eobj)
				if (re2["true")	
				{

					d ##class(web.DHCBL.MKB.MKBGlobal).DoSelfCheckAliasMark(GlobalID)
				}
				else
				{
					if (re2["存在")
					{
						s MKBGRRowid=$o(^User.MKBGlobalReferenceI("InverAllIndex",GlobalID,"T",rowid,0))
					}
					else
					{
						q re2
					}
					
				}
			}
		}
	}						
					
	q result
}

/// Creator:钟荣枫
/// CreatDate:2021-1-22
/// Description：存在状态为U，但是没有别名、引用的数据  做批处理
/// Table：
/// Input：
/// Return：true ,false
/// Other: w ##class(web.DHCBL.MKB.MKBGlobal).AddAlias()
ClassMethod AddAlias()
{
	s result=""
	s errorflag=0
	TS
	s count=0
	s GlobalID=0
	for
	{
		s GlobalID=$o(^User.MKBGlobalD(GlobalID))
		q:GlobalID=""
		q:errorflag=1
		s MKBGDesc=$lg($g(^User.MKBGlobalD(GlobalID)),3)
		s MKBGState=$lg($g(^User.MKBGlobalD(GlobalID)),8)
		s AliasId=$o(^User.MKBGlobalD(GlobalID,"ChildGloAlias",0))
		if ((AliasId="")&&(MKBGState="U"))	//状态为U，但是没有别名
		{
			s count=count+1
			s eaobj=##class(web.Entity.MKB.MKBGloAlias).%New()
		 	s eaobj.MKBGADesc=MKBGDesc
		 	s eaobj.MKBGAParRef=GlobalID
		 	s eaobj.MKBGACEFlag="C"
		 	s eaobj.MKBGAMark="6"	//设为展示名
		 	s re= ..SaveAliasData(eaobj)
		 	s:re["false" errorflag=1
		}
	}
	if (errorflag=1)
	{
		s result="false"
		tro
	}
	else
	{
		s result="true"
		tc
	}
	//w "count："_count,!
	q result
}

/// Creator:钟荣枫
/// CreatDate:2021-2-2
/// Description：根据各版本icd对照的id，获取结构化id串
/// Table：
/// Input：MKBICDRowid
/// Return：id串
/// Other: w ##class(web.DHCBL.MKB.MKBGlobal).StructResult(MKBICDRowid)
ClassMethod StructResult(MKBICDRowid)
{
	s Result=""
	s sequence=0
	for
	{
		s sequence=$o(^User.MKBICDContrastResultI("SeqIndex",MKBICDRowid,sequence))
		q:sequence=""
		s MKBICDRRowid=0
		for
		{
			s MKBICDRRowid=$o(^User.MKBICDContrastResultI("SeqIndex",MKBICDRowid,sequence,MKBICDRRowid))
			q:MKBICDRRowid=""
			s MKBICDRResultID=$lg($g(^User.MKBICDContrastD(MKBICDRowid,"MKBICDContrastResult",MKBICDRRowid)),2)  //获取结构化结果串
			s MKBICDResultTermdr=$lg($g(^User.MKBICDContrastD(MKBICDRowid,"MKBICDContrastResult",MKBICDRRowid)),4) //获取结构化结果Termdr
			s SResult=""
			s:MKBICDRResultID'="" SResult=MKBICDResultTermdr_"-"_MKBICDRResultID
			s:MKBICDRResultID="" SResult=MKBICDResultTermdr
			/*
			s SResult=##class(web.DHCBL.MKB.MKBStructuredData).GetChiForNewSeqStrucIDs(MKBICDRResultID,MKBICDResultTermdr)
			s MKBICDSupplement=$lg(^User.MKBICDContrastD(MKBICDRowid,"MKBICDContrastResult",MKBICDRRowid),5)
			if MKBICDSupplement'=""
			{
				if SResult["]"
				{
					s str=$e(SResult,1,*-1)
					s SResult=str_",("_MKBICDSupplement_")]"
				}
				else
				{
					s SResult=SResult_"[("_MKBICDSupplement_")]"
				}
			}
			
			
			*/
			s:Result'="" Result=Result_"<br/>"_SResult
			s:Result="" Result=SResult
		}
	}
	q Result
}

/// Creator:钟荣枫
/// CreatDate:2021-2-2
/// Description：对结构化id串进行处理，过滤重复
/// Table：
/// Input：id串
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBGlobal).HandleStructResult("15614-14727:226600*226600,14727:226600,11:222S")
ClassMethod HandleStructResult(Result)
{
	s result=""
	q:Result="" ""
	s TermID=$p(Result,"-",1)
	s Detailstr=$p(Result,"-",2)
	if (Detailstr="")
	{
		s result=TermID
	}
	else
	{
		k ^tempItem
		for m=1:1:$l(Detailstr,",")
		{
			s Item=$p(Detailstr,",",m)
			continue:Item=""
			
			s ItemTitle=$p(Item,":",1)
			s ItemDetail=$p(Item,":",2)
			s ^tempItem("ItemTitle",ItemTitle)=""
			
			s newItemDetail=""
			for n=1:1:$l(ItemDetail,"*")
			{
				s Detail=$p(ItemDetail,"*",n)
				continue:(Detail="")
				s ^tempItem("ItemDetail",ItemTitle,Detail)=""
			}	
			
		}
		s ItemStr=""
		s ItemTitle=0
		for
		{
			//^tempItem("ItemTitle",ItemTitle)=""
			s ItemTitle=$o(^tempItem("ItemTitle",ItemTitle))
			q:ItemTitle=""
			s Detailstr=""
			s Detail=""
			for
			{
				s Detail=$o(^tempItem("ItemDetail",ItemTitle,Detail))
				q:Detail=""
				if (Detailstr="")
				{
					s Detailstr=Detail
				}
				else
				{
					s Detailstr=Detailstr_"*"_Detail
				}
			}
			if (ItemStr="")
			{
				s ItemStr=ItemTitle_":"_Detailstr
			}
			else
			{
				s ItemStr=ItemStr_","_ItemTitle_":"_Detailstr
			}
			
		}
		s result=TermID_"-"_ItemStr
	}
	q result
}

/// Creator:钟荣枫
/// CreatDate:2021-1-30
/// Description：各版本icd对照的数据到全局化词表
/// Table：
/// Input：
/// Return：true ,false
/// Other: w ##class(web.DHCBL.MKB.MKBGlobal).ICDContrastToGlobal()
ClassMethod ICDContrastToGlobal()
{
	// 各版本icd对照中数据 “霍乱，由于O1群霍乱弧菌，霍乱生物型所致” 霍乱[古典型]
	//		古典生物型霍乱 霍乱[古典型]
	//步骤1：“霍乱，由于O1群霍乱弧菌，霍乱生物型所致”，数据有效，诊断描述：诊断表达式 1:1， 
	//步骤2：诊断描述在全局化词表中未出现，新建
	//步骤3：标注为展示名/查询名
	//步骤4：引用位置1，诊断表达式“霍乱[古典型]”；引用位置2，各版本ICD对照，“霍乱[古典型]”
	//步骤5：“古典生物型霍乱”，数据有效
	//步骤6：诊断表达式“霍乱[古典型]”重名
	//步骤7：并入“霍乱，由于O1群霍乱弧菌，霍乱生物型所致”查询名
	s result=""
	s errorflag=0
	TS
	s count=0
	s addglobalcount=0		//添加术语
	s addrefcount=0			//添加常用诊断表达式
	s addglorefcount=0		//添加术语的引用
	s exsitgloablcount=0	//已存在术语
	s exsitrefcount=0	//已存在常用诊断表达式
	s MKBICDRowId=0
	for
	{
		s MKBICDRowId=$o(^User.MKBICDContrastD(MKBICDRowId))
		q:MKBICDRowId=""
		continue:'$d(^User.MKBICDContrastD(MKBICDRowId))
		q:errorflag=1
		s ResultID=$o(^User.MKBICDContrastResultI("MKBICDContrastIndex",MKBICDRowid,""))
		continue:(ResultID="")
		
		s MKBICDDiaSource=$lg($g(^User.MKBICDContrastD(MKBICDRowId)),6)  //诊断短语数据来源
		s sourcelen=$l(MKBICDDiaSource,"&")
		s exsitflag=0
		for i=1:1:sourcelen
		{
			s Source=$p(MKBICDDiaSource,"&",i)
			continue:Source=""
			s SourceString=$Lg($g(^User.MKBTermD(Source)),3)
			if (SourceString="疾病分类与代码国家临床版2.0")
			{
				s exsitflag=1
			}
		}
	
		continue:(exsitflag=0)
		//continue:(MKBICDDiaSource'["526477")
		s MKBICDConDesc=$lg($g(^User.MKBICDContrastD(MKBICDRowId)),3)   //ICD描述
		s MKBICDConDesc = ##class(web.DHCBL.BDP.FunLib).AutoSBDB(MKBICDConDesc,0)	//全角转半角
		//空格处理
		s MKBICDConDesc =..SpaceHandleMethod1(MKBICDConDesc)
		s MKBICDConDesc =..SpaceHandleMethod2(MKBICDConDesc)
		s MKBICDConDesc =..SpaceHandleMethod3(MKBICDConDesc)
		
		s MKBICDNumber=$lg($g(^User.MKBICDContrastD(MKBICDRowId)),4) //ICD编码
		s MKBICDCenterWordID=$lg($g(^User.MKBICDContrastD(MKBICDRowId)),9)	//中心词ID
		s MKBICDResultRelation=$lg($g(^User.MKBICDContrastD(MKBICDRowId)),19)
		continue:(MKBICDResultRelation'="")
			
		s StructResult=..StructResult(MKBICDRowId)
		s StructResult=..HandleStructResult(StructResult)
		continue:(StructResult="")
		s le=$l(StructResult,"&<br/>")
		if (StructResult'["&<br/>")	//只有一个诊断
		{
			s TermID=$p(StructResult,"-",1)
			s StructResultstr=$p(StructResult,"-",2)
			s count=count+1
			
			;w count,!
			
			s InitID=""
			s GlobalID=""
			
			if (TermID'="")	//有中心词，需要保存临床实用诊断
			{
				s AddDetailFlag=1
				s MKBProRowid = $o(^User.MKBTermPropertyI("DescIndex",TermID," 常用诊断表达式",0))
				
				s:(MKBProRowid="") AddDetailFlag=0
				/*
				s ContrastID=$o(^User.MKBICDContrastD(TermID,"MKBICDContrastResult",0))
				s MKBICDRResultID=""
				s:ContrastID'="" MKBICDRResultID=$lg($g(^User.MKBICDContrastD(TermID,"MKBICDContrastResult",ContrastID)),2)  //获取结构化结果串
				//s:(MKBICDRResultID="") AddDetailFlag=0
				*/
				s MKBICDRResultID=StructResult
				//保存到临床实用诊断
				if (AddDetailFlag=1)
				{
					s SameProValValueID= ##class(web.DHCBL.MKB.MKBTermProDetail).GetSameProValValueID(MKBProRowid,StructResult)
					if (SameProValValueID'="")	//找到相同结构化结果的项,不新增
					{
						for s1=1:1:$l(SameProValValueID,",")
						{
							s InitID=$p(SameProValValueID,",",s1)
							continue:InitID=""
							s:InitID'="" GlobalID=$o(^User.MKBGlobalReferenceI("AllIndex","D",InitID,0))	//被引用的术语
							q:GlobalID'=""
						}
					}
					else	//新增
					{
						
						
						if (StructResultstr'="")	//是常用诊断表达式
						{
							
							s sub= $o(^User.MKBTermPropertyD(MKBProRowid,"ChildExtPro",0))
							s MKBTPDExtend=sub_"[A]"_MKBICDRResultID
							//4332667[A]15805-17196:1877251,8878483:S12524
				
							s bobj = ##class(web.Entity.MKB.MKBTermProDetail).%New()
							s bobj.MKBTPDCode = ##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBICDConDesc)
							
							s bobj.MKBTPDDesc = ##class(web.DHCBL.BDP.FunLib).Util(MKBICDConDesc)
							s bobj.MKBTPDProDR = MKBProRowid
							s bobj.MKBTPDActiveFlag=  "Y"
							s bobj.MKBTPDRemark = ""
							s bobj.MKBTPDSequence=  ""
							
							s bobj.MKBTPDPYCode = ##class(web.DHCBL.MKB.MKBTermProDetail).Filter(MKBICDConDesc)
							s bobj.MKBTPDPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(bobj.MKBTPDPYCode)
							s bobj.MKBTPDPYCode= ##class(web.DHCBL.BDP.FunLib).Util(bobj.MKBTPDPYCode)
							s bobj.MKBTPDExtend=MKBTPDExtend			
							s re=##class(web.DHCBL.MKB.MKBTermProDetail).SaveData(bobj)	
							
							
							if (re["false")
							{
								if (re["存在")
								{
									//
									s InitID=$o(^User.MKBTermProDetailI("CodeIndex",bobj.MKBTPDProDR,bobj.MKBTPDCode,0))
									//Index CodeIndex On (MKBTPDProDR, MKBTPDCode) [ Unique ];
									s:InitID'="" GlobalID=$o(^User.MKBGlobalReferenceI("AllIndex","D",InitID,0))	//被引用的术语
									//合并到这个术语中
									//Index AllIndex On (InitiativeFlag As Exact, InitiativeID As Exact, PassiveID As Exact);
									
								}
								else
								{
									s errorflag=1
									;b ;term
									q:errorflag=1
								}
							}
							else
							{
								s InitID=$p(re,"'",4)		//获取id
								s addrefcount=addrefcount+1
								
	
								
							}
						}
						else
						{
							s InitID=TermID
							s:InitID'="" GlobalID=$o(^User.MKBGlobalReferenceI("AllIndex","T",InitID,0))	//被引用的术语
						}
					}
					
				}
				else
				{
					s InitID=TermID
					s GlobalID=$o(^User.MKBGlobalReferenceI("AllIndex","T",InitID,0))	//被引用的术语	
				}
				
			}
			
			
			s GlobalAlias=""
			if (GlobalID'="")		//被引用的术语不为空，合并到这个术语中
			{
				s eobj=##class(web.Entity.MKB.MKBGloAlias).%New()    //新建一个别名表实体类存储需要保存的别名数据
				s eobj.MKBGAParRef=GlobalID
				s eobj.MKBGADesc=MKBICDConDesc
				s eobj.MKBGAPYCode=##class(web.DHCBL.BDP.FunLib).GetCNCODE(MKBICDConDesc,4,"")
				s eobj.MKBGANote=""
				s eobj.MKBGACEFlag="C"
				s eobj.MKBGAMark="查询名"	
				s ars=..SaveAliasEntity(eobj)  //保存别名
				if (ars'["false")
				{
					s GlobalAlias=$p(ars,"'",4)
				}
				else
				{
					if (ars["存在")
					{
						s GlobalAlias=$o(^User.MKBGloAliasI("NameIndex"," "_$ZCONVERT(MKBICDConDesc,"U"),GlobalID,0))
					}
					else
					{
						s errorflag=1
						q:errorflag=1	
					}
				}
				
			}
			else	//新增术语,或找到这个术语
			{
				//保存到全局化词表
				s existstr=..IsExist(MKBICDConDesc,"")			//"existflag^gloablflag^"_TheID 
				s existflag=$p(existstr,"^",1)
				
				if (existflag=1)	//在全局化词表中存在
				{
					s exsitgloablcount=exsitgloablcount+1	//已存在术语
	
					s gloablflag=$p(existstr,"^",2)
					s TheID=$p(existstr,"^",3)
					if (gloablflag=1)	//是术语
					{
						s GlobalID=TheID
						s GlobalAlias=$o(^User.MKBGloAliasI("NameIndex"," "_$ZCONVERT(MKBICDConDesc,"U"),GlobalID,0))
					}
					else
					{
						s GlobalID=$p(TheID,"||",1)
						s GlobalAlias=$p(TheID,"||",2)
					}
				}
				else
				{
					s eobj = ##class(web.Entity.MKB.MKBGlobal).%New()
					s eobj.MKBGDesc = ##class(web.DHCBL.BDP.FunLib).Util($ZCONVERT(MKBICDConDesc,"U"))
					s eobj.MKBGMark = "常用诊断描述"
					s eobj.MKBGState="U"  
					 
					s gloresult = ..SaveGlobalData(eobj)	//保存术语同时新增别名
		
					if (gloresult["false")	
					{
						s errorflag=1
						q:errorflag=1
					}
					else
					{
						s addglobalcount=addglobalcount+1		//添加术语
								
						s GlobalID=$p(gloresult,"'",4)
						s GlobalAlias=$o(^User.MKBGloAliasI("NameIndex"," "_$ZCONVERT(MKBICDConDesc,"U"),GlobalID,0))
					}
				}
			}
			
			if ((GlobalAlias'="")&&(GlobalID'=""))	//存在这个别名
			{
				if ((InitID'="")&&(StructResultstr'=""))	//是常用诊断表达式
				{
					s Dflag=$o(^User.MKBGlobalReferenceI("InverAllIndex",GlobalID,"D",InitID,0))	//常用诊断表达式
					if (Dflag="")	//没有常用诊断表达式
					{
						s eobj = ##class(web.Entity.MKB.MKBGlobalReference).%New()
						
						s eobj.InitiativeFlag="D"				//发起引用，主动引用标识
						s eobj.InitiativeID=InitID				//发起引用词的ID
						s eobj.PassiveID=GlobalID			//被引用词的ID
						s eobj.PassiveAliasID=GlobalAlias				//被引用词的名称列表ID
						
						s reD= ..SaveReferenceEntity(eobj)
						if (reD["false")
						{
							s errorflag=1
							q:errorflag=1
						}
					}
				}
					
				//判断是否有icd
				//ICDCon 各版本ICD对照,ICDSD 医大一ICD
				s Conflag=$o(^User.MKBGlobalReferenceI("InverAllIndex",GlobalID,"ICDCon",MKBICDRowId,0))	//各版本ICD对照
				if (Conflag="")	//各版本ICD对照
				{
					
					s eobj = ##class(web.Entity.MKB.MKBGlobalReference).%New()
					
					s eobj.InitiativeFlag="ICDCon"				//发起引用，主动引用标识
					s eobj.InitiativeID=MKBICDRowId				//发起引用词的ID
					s eobj.PassiveID=GlobalID			//被引用词的ID
					s eobj.PassiveAliasID=GlobalAlias				//被引用词的名称列表ID
					s TTRowid=$o(^User.MKBGlobalReferenceI("InverAllIndex",eobj.PassiveID,eobj.InitiativeFlag,eobj.InitiativeID)) 
					
					s reCon= ..SaveReferenceEntity(eobj)
					if (reCon["false")
					{
						s errorflag=1
						q:errorflag=1
					}
					
				}
				q:errorflag=1
				s SDflag = ..RefHandleYDY(MKBICDConDesc)   //去调用匹配医大一ICD的方法
				if (SDflag'="N")          //返回结果不为"N" 说明完全匹配到ICD 则添加到该dataID的引用场景下
				{
					if ('$d(^User.MKBGlobalReferenceI("InverAllIndex",GlobalID,"ICDSD",SDflag)))
					{
						s obj = ##class(web.Entity.MKB.MKBGlobalReference).%New()
				
						s obj.InitiativeFlag="ICDSD"				//发起引用，主动引用标识
						s obj.InitiativeID=SDflag				//发起引用词的ID
						s obj.PassiveID=GlobalID			//被引用词的ID
						s obj.PassiveAliasID=GlobalAlias				//被引用词的名称列表ID
						s resd= ..SaveReferenceEntity(obj)
						if (reSD["false")
						{
							s errorflag=1
							q:errorflag=1
						}
					}
				}
				d ..DoSelfCheckAliasMark(GlobalID)	
			}
			
			
		}
		
	}
	;w "添加临床实用诊断的引用："_addrefcount,!
	;w "添加术语："_addglobalcount,!
	;w "已存在术语："_exsitgloablcount,!
	
	if (errorflag=1)
	{
		s result="false"
		tro	
	}
	else
	{
		s result="true"
		tc	
	}
	q result
}

/// Creator:钟荣枫
/// CreatDate:2021-2-4
/// Description：删除术语的所有数据  并非将状态改为“删除”
/// Table：
/// Input：
/// Return：true ,false
/// Other: w ##class(web.DHCBL.MKB.MKBGlobal).DelGlobalData()
ClassMethod DelGlobalData(MKBGRowId)
{
	s result=""
	s re= ..DeleteAllButGlobal(MKBGRowId)
	if (re["false")
    {
	    s result="删除别名、引用和频次失败！"
    }
    else
    {
	    s reglo=..DeleteGlobalData(MKBGRowId)
	    if (reglo["false")
	    {
		    s result=reglo
	    }
    }
    s:result="" result="{success:'true',info:'删除成功！'}"	
    q result
}

/// Creator:钟荣枫
/// CreatDate:2021-2-4
/// Description：删除全部已经合并或删除的术语数据
/// Table：
/// Input：
/// Return：true ,false
/// Other: w ##class(web.DHCBL.MKB.MKBGlobal).DelDeleteData()
ClassMethod DelDeleteData()
{
	s result=""
	s errorflag=0
	s count=0
	TS
	s MKBGRowId = 0
    for
    {
	    s MKBGRowId = $o(^User.MKBGlobalD(MKBGRowId))
	    q:MKBGRowId=""
	    q:errorflag=1
	    s MKBGState=$lg($g(^User.MKBGlobalD(MKBGRowId)),8)
	    if ((MKBGState="D")||(MKBGState="M"))
	    {
		    s count=count+1
		   ; w count,!
		    s re= ..DeleteAll(MKBGRowId)
		    if (re["false")
		    {
			    s errorflag=1
		    }
	    }
    }
    if (errorflag=1)
    {
		s result="false"
		tro    
    }
    else
    {
	 	s result="true"
	 	tc   
    }
    q result
}

/// Creator:钟荣枫
/// CreatDate:2021-2-4
/// Description：批处理 没有诊断表达式的，且超过15个字的术语，删除掉
/// Table：
/// Input：
/// Return：true ,false
/// Other: w ##class(web.DHCBL.MKB.MKBGlobal).DelOverLengthData()
ClassMethod DelOverLengthData()
{
	s result=""
	s errorflag=0
	s count=0
	TS
	s MKBGRowId = 0
    for
    {
	    s MKBGRowId = $o(^User.MKBGlobalD(MKBGRowId))
	    q:MKBGRowId=""
	    q:errorflag=1
	    s InitiativeIDD=$o(^User.MKBGlobalReferenceI("InverAllIndex",MKBGRowId,"D",0))		//常用诊断表达式
		s InitiativeIDT=$o(^User.MKBGlobalReferenceI("InverAllIndex",MKBGRowId,"T",0))		//临床实用诊断
		s MKBGDesc=$lg($g(^User.MKBGlobalD(MKBGRowId)),3)	//术语描述
		
		if (((InitiativeIDD="")&&(InitiativeIDT=""))&&($l(MKBGDesc)>15))	//条件
		{
			s count=count+1
		    ;w count,!
			s re= ..DelGlobalData(MKBGRowId)
		    if (re["false")
		    {
			    s errorflag=1
		    }
		}
	    
    }
    if (errorflag=1)
    {
		s result="false"
		tro    
    }
    else
    {
	 	s result="true"
	 	tc   
    }
    q result
}

/// Creator:钟荣枫
/// CreatDate:2021-2-8
/// Description：根据给的专业科室id串，获取到它以及它的所有下级的id串，并去重
/// Table：
/// Input：idstr  166626
/// Return：AllLocStr
/// Other: w ##class(web.DHCBL.MKB.MKBGlobal).GetLocStr("166626,77547")
ClassMethod GetLocStr(SortLocStr)
{
	s AllLocStr=""
	s base=$o(^User.MKBTermBaseI("DescIndex"," 专业科室",0))
	if (SortLocStr'="")
	{
		
		for s1=1:1:$l(SortLocStr,",")
		{
			s TheLoc=$p(SortLocStr,",",s1)
			continue:(TheLoc="")
			s childlocstr=##class(web.DHCBL.MKB.MKBTerm).GetChildOrderedIDStr(base,TheLoc)
			//Index ProfDeptDRIndex On (DiaDR, ProfDeptDR);
			
			if (AllLocStr="")
			{
				s:childlocstr'="" AllLocStr=TheLoc_"^"_childlocstr
			}
			else
			{
				s:childlocstr'="" AllLocStr=AllLocStr_"^"_TheLoc_"^"_childlocstr
			}
		}
	}
	s str=""
	for t1=1:1:$l(AllLocStr,"^")
	{
		s loc1=	$p(AllLocStr,"^",t1)
		s inflag=0
		for t2=1:1:$l(str,"^")
		{
			s loc2=	$p(str,"^",t2) 
			s:loc1=loc2 inflag=1
		}
		if (inflag=0)
		{
			if (str="")
			{
				s str=loc1
			}
			else
			{
				s str=str_"^"_loc1
			}
		}
	}
	s AllLocStr=str
	q AllLocStr
}

/// Creator:钟荣枫
/// CreatDate:2021-2-22
/// Description：专业科室id串，按照大小排序
/// Table：
/// Input：idstr  166626
/// Return：AllLocStr
/// Other: w ##class(web.DHCBL.MKB.MKBGlobal).GetSortedLocStr("166626,77547")
ClassMethod GetSortedLocStr(SortLocStr)
{
	s AllLocStr=""
	if (SortLocStr'="")
	{
		s mySeq=0
		k myArray
		k a
		//生成菜单索引数组
		s n=0
		for s1=1:1:$l(SortLocStr,",")
		{
			s TheLoc=$p(SortLocStr,",",s1)
			continue:(TheLoc="")
			s n=n+1
			s a(n)= TheLoc
		}
		set left=1,right=n
		d:$d(a) ##class(web.DHCBL.BDP.FunLib).QuickSort(.a,left,right) //排序

		s n=0
		s mySeq=0
		for {
			s n=$o(a(n)) q:(n="")
			s mySeq=$g(a(n))
			if (AllLocStr="")
			{
				s AllLocStr=mySeq
			}
			else
			{
				s AllLocStr=AllLocStr_"^"_mySeq
			}
		}
		
	}
	
	q AllLocStr
}

/// Creator:钟荣枫
/// CreatDate:2021-2-22
/// Description：根据排序方式，对术语进行排序
/// Table：
/// Input：idstr  166626
/// Return：AllLocStr
/// Other: w ##class(web.DHCBL.MKB.MKBGlobal).SortGlobal("termsort","","")
ClassMethod SortGlobal(SortMethod, AllLocStr, LocFreq)
{
	s count=0
	s countf1=0
	s countf2=0
	s countf3=0
	s countf4=0
	s countf5=0
	s MKBGFreq = " "
    for
    {
	    s MKBGFreq = $o(^User.MKBGlobalI("MKBGFreqIndex",MKBGFreq),-1)
	    q:MKBGFreq=""
	    s ID = 0
	    for
	    {
		    s ID = $o(^User.MKBGlobalI("MKBGFreqIndex",MKBGFreq,ID))
		    q:ID=""
		    s MKBGRowId=ID
			s MKBGState=$lg($g(^User.MKBGlobalD(MKBGRowId)),8)
		    if (MKBGState'="U")
			{
				continue
			}
			s MKBGDiaTotalFreq = $lg($g(^User.MKBGlobalD(MKBGRowId)),11)
			s MKBGloMark =$lg($g(^User.MKBGlobalD(MKBGRowId)),10)
			
		    if ((SortMethod="freqsort")||(SortMethod=""))	//频次排序
			{
				s count=count+1
				
				s ^TempMarkSortList(1,count)=MKBGRowId		
				continue
			}
			elseif (SortMethod="termsort")
			{
				s count=count+1
				s InitiativeIDD=$o(^User.MKBGlobalReferenceI("InverAllIndex",MKBGRowId,"D",0))		//常用诊断表达式
				s InitiativeIDT=$o(^User.MKBGlobalReferenceI("InverAllIndex",MKBGRowId,"T",0))		//临床实用诊断
					
				if (((InitiativeIDD'="")||(InitiativeIDT'=""))&&(MKBGloMark'["部位"))	//条件
				{
					s countf1=countf1+1
					s ^TempMarkSortList(1,countf1)=MKBGRowId
					//s ^TempMarkSortList(1,MKBGRowId)=""		//第一批，带常用诊断表达式、临床实用诊断的   挑出来，排序
					continue
				}
				else
				{
					
					s containflag=0
					s MKBGAMark=0
					for
					{
						s MKBGAMark=$o(^User.MKBGloAliasI("MarkIndex",MKBGRowId,MKBGAMark))  //遍历别名表
						q:MKBGAMark=""
						if (MKBGAMark["组合词条")	
						{
							s containflag=1
							q 
						}
					}
					if (((containflag=0)&&(MKBGDiaTotalFreq>=5))&&(MKBGloMark'["部位"))		//别名中不会包含"组合词条"且频次大于等于5
					{
						s countf2=countf2+1
						s ^TempMarkSortList(2,countf2)=MKBGRowId
						//s ^TempMarkSortList(2,MKBGRowId)=""		//第二批，剩下的，且不含组合词条，且频次大于等于5  挑出来，排序
						continue
					}
					else
					{
						if ((containflag=1)&&(MKBGloMark'["部位"))		//别名中包含"组合词条"
						{
							s countf3=countf3+1
							s ^TempMarkSortList(3,countf3)=MKBGRowId
							//s ^TempMarkSortList(3,MKBGRowId)=""		//第三批，剩下，且含组合词条  挑出来，排序
							continue
						}
						else
						{
							if (MKBGloMark'["部位")		//别名中包含"组合词条"
							{
								s countf4=countf4+1
								s ^TempMarkSortList(4,countf4)=MKBGRowId
								//s ^TempMarkSortList(4,MKBGRowId)=""		//第四批，剩下不是部位的 挑出来，排序
								continue
							}
							else
							{
								s countf5=countf5+1
								s ^TempMarkSortList(5,countf5)=MKBGRowId
								//s ^TempMarkSortList(5,MKBGRowId)=""		//第五批，剩下的部位  挑出来，排序
								continue
							}
						}
					}
					
				}
			}
			elseif (SortMethod="locsort")
			{
				s InitiativeIDD=$o(^User.MKBGlobalReferenceI("InverAllIndex",MKBGRowId,"D",0))		//常用诊断表达式
				s InitiativeIDT=$o(^User.MKBGlobalReferenceI("InverAllIndex",MKBGRowId,"T",0))		//临床实用诊断
							//SortLocStr	//..GetLocStr(SortLocStr)		//根据给的专业科室id串，获取到它以及它的所有下级的id串，并去重
				
				if ($d(^TempLocSort(AllLocStr))>0)		//存在已保存的临时global
				{
					
				}
				else
				{
					s TotalFreq=0
					for loci=1:1:$l(AllLocStr,"^")
					{
						s theloc=$p(AllLocStr,"^",loci)
						continue:theloc=""
						if ($d(^User.MKBGDiagLocI("ProfDeptDRIndex",MKBGRowId,theloc))>0)
						{
							s MKBGLFRowId = $o(^User.MKBGDiagLocI("ProfDeptDRIndex",MKBGRowId,theloc,0))
							if (MKBGLFRowId'="")
							{
								s theFreq =$lg($g(^User.MKBGDiagLocD(MKBGLFRowId)),4) 
								s:theFreq="" theFreq=0
								s TotalFreq=TotalFreq+theFreq
							}
						}
					}
					s count=count+1	
					if (((InitiativeIDD'="")||(InitiativeIDT'=""))&&(TotalFreq>=LocFreq))	//条件
					{
						
						s ^TempMarkSortList(1,TotalFreq,count)=MKBGRowId
								//有诊断表达式，同时2年内分科室使用频次>=3次
						continue
					}
					else
					{
						if (((InitiativeIDD="")&&(InitiativeIDT=""))&&(TotalFreq>=LocFreq))	//条件
						{
							s ^TempMarkSortList(2,TotalFreq,count)=MKBGRowId
									//无诊断表达式，同时2年内分科室使用频次>=3次
							continue
						}
						else
						{
							if (((InitiativeIDD'="")||(InitiativeIDT'=""))&&(TotalFreq<LocFreq))	//条件
							{
								s ^TempMarkSortList(3,TotalFreq,count)=MKBGRowId
										//有诊断表达式，同时2年内分科室使用频次<3次
								continue
							}
							else
							{
								if (((InitiativeIDD="")&&(InitiativeIDT=""))&&(TotalFreq<LocFreq))	//条件
								{
									s ^TempMarkSortList(4,TotalFreq,count)=MKBGRowId
											//无诊断表达式，同时2年内分科室使用频次<3次
									continue
								}
								else
								{
									s ^TempMarkSortList(5,TotalFreq,count)=MKBGRowId
											//
									continue
								}
						
							}						
						}
				
					}
					
				}
			}
			
				
	    }
    }
    if (SortMethod="locsort")
	{
		s count=0
		if ($d(^TempLocSort(AllLocStr))>0)		//存在已保存的临时global
		{
			// 将原先的临时global赋值过去
			for
			{
				s count=$o(^TempLocSort(AllLocStr,count))
				q:count=""
				s ^TempMarkSortList("Sort",count)=^TempLocSort(AllLocStr,count)
			}
		}
		else
		{
			for Sorti=1:1:11
			{
				s FreqCount=""
				for
				{
					s FreqCount=$o(^TempMarkSortList(Sorti,FreqCount),-1)
					q:FreqCount=""
					s NumCount=0
					for
					{
						s NumCount=$o(^TempMarkSortList(Sorti,FreqCount,NumCount))
						q:NumCount=""
						s count=count+1
						s ^TempMarkSortList("Sort",count)=^TempMarkSortList(Sorti,FreqCount,NumCount)
						s ^TempLocSort(AllLocStr,count)=^TempMarkSortList(Sorti,FreqCount,NumCount)
					}
				}
			}
		}
			
		
	}
	elseif (SortMethod="termsort")
	{
		s count=0
		for Sorti=1:1:11
		{
			
			s NumCount=0
			for
			{
				s NumCount=$o(^TempMarkSortList(Sorti,NumCount))
				q:NumCount=""
				q:^TempMarkSortList(Sorti,NumCount)=""
				s count=count+1
				s ^TempMarkSortList("Sort",count)=^TempMarkSortList(Sorti,NumCount)
			}
			
		}
	}
	else
	{
		s count=0
		
		s NumCount=0
		for
		{
			s NumCount=$o(^TempMarkSortList(1,NumCount))
			q:NumCount=""
			q:^TempMarkSortList(1,NumCount)=""
			s count=count+1
			s ^TempMarkSortList("Sort",count)=^TempMarkSortList(1,NumCount)
		}
			
	}
	q ""
}

/// Creator：钟荣枫
/// CreatDate: 2021-03-11
/// Description：导出术语以及别名
/// Table:
/// Input：
/// w ##class(web.DHCBL.MKB.MKBGlobal).ExportGlobalDataTXT()   
ClassMethod ExportGlobalDataTXT()
{
   	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
   	s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName=time_"全局化词表数据.txt"
	s file=Disk_":\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\"_fileName
	
    o file:"WNS"
    u file
    w "术语ID	术语描述	别名	对照上的中心词	是否结构化"   //注意此处是用tab隔开
    
    d ..SortGlobal("termsort","","")
    
	s mark="部位,临床实用诊断,常用诊断描述,业务诊断,展示名"		
	s Num=0
				
	s NumCount=0			
	for
	{
		s NumCount=$o(^TempMarkSortList("Sort",NumCount))
		q:NumCount=""
		
		s MKBGRowId=^TempMarkSortList("Sort",NumCount)
		q:MKBGRowId=""
	    s MKBGDesc=$lg($g(^User.MKBGlobalD(MKBGRowId)),3)
	    s MKBGloMark =$lg($g(^User.MKBGlobalD(MKBGRowId)),10)
		continue:(mark'[MKBGloMark)
		s MKBGAlias=""
		s AliasId=0
		for
		{
			s AliasId=$o(^User.MKBGlobalD(MKBGRowId,"ChildGloAlias",AliasId))  //遍历别名表
			q:AliasId=""
			s AliasMark = $lg($g(^User.MKBGlobalD(MKBGRowId,"ChildGloAlias",AliasId)),8) 
			if (MKBGAlias="")
			{
				s MKBGAlias=$lg($g(^User.MKBGlobalD(MKBGRowId,"ChildGloAlias",AliasId)),2)   //别名
			}
			else
			{
				s MKBGAlias=MKBGAlias_"#"_$lg($g(^User.MKBGlobalD(MKBGRowId,"ChildGloAlias",AliasId)),2)   //别名
			}	
		}
		s InitiativeIDD=$o(^User.MKBGlobalReferenceI("InverAllIndex",MKBGRowId,"D",""))		//常用诊断表达式
		s InitiativeIDT=$o(^User.MKBGlobalReferenceI("InverAllIndex",MKBGRowId,"T",""))		//临床实用诊断
		s IsChecked="未结构化"
		s TermStr=""
		if (InitiativeIDD'="")	//常用诊断表达式
		{
			s RefRowId=0
			for
			{
				
				s RefRowId=$o(^User.MKBGlobalReferenceI("InverAllIndex",MKBGRowId,"D",RefRowId))    //通过索引表获得引用者的ID
				q:RefRowId=""
				
				s ProRowId=$lg($g(^User.MKBTermProDetailD(RefRowId)),6)         //属性RowID
				continue:ProRowId=""
				s TermRowId=$lg($g(^User.MKBTermPropertyD(ProRowId)),6)     //术语RowID
				s TermDesc=$lg($g(^User.MKBTermD(TermRowId)),3)             //术语描述
				if (TermStr'="")
				{
					s TermStr=TermStr_"#"_TermDesc
				}
				else
				{
					s TermStr=TermDesc
				}
					
			}
		
		}
		if (InitiativeIDT'="")	//临床实用诊断
		{
			s RefRowId=0
			for
			{
				s RefRowId=$o(^User.MKBGlobalReferenceI("InverAllIndex",MKBGRowId,"T",RefRowId))    //通过索引表获得引用者的ID
				q:RefRowId=""
				s TermDesc=$lg($g(^User.MKBTermD(RefRowId)),3)             //术语描述
				if (TermStr'="")
				{
					s TermStr=TermStr_"#"_TermDesc
				}
				else
				{
					s TermStr=TermDesc
				}
			}
		
		
		}
		s:((InitiativeIDD'="")||(InitiativeIDT'="")) IsChecked="已结构化"
				
		s Num=Num+1
		w !,MKBGRowId_"	"_MKBGDesc_"	"_MKBGAlias_"	"_TermStr_"	"_IsChecked   //注意此处连接符是tab				
    		
	}	
    
    
	c file
	;W !,file_" 生成成功，共"_Num_"条"
	Q fileName
}

/// Creator:钟荣枫
/// CreatDate:2021-3-15
/// Description：通过描述获取结构化的id串
/// Table：
/// Input：MKBSDDiag 描述,rowidflag  增加rowidflag以返回匹配的常用诊断表达式的id
/// Return：TermDR_"-"_DetailValue
/// Other: w ##class(web.DHCBL.MKB.MKBGlobal).GetStructValueByDesc("高血压3级(很高危)")
ClassMethod GetStructValueByDesc(MKBSDDiag, rowidflag = "")
{
	q:MKBSDDiag="" ""
	s MKBSDDiag = ##class(web.DHCBL.BDP.FunLib).AutoSBDB(MKBSDDiag,0)		//全角转半角
	s MKBSDDiag=..SpaceHandleMethod1(MKBSDDiag)
	s MKBSDDiag=..SpaceHandleMethod2(MKBSDDiag)
	s MKBSDDiag=..SpaceHandleMethod3(MKBSDDiag)
	
	s value=""
	s existstr= ##class(web.DHCBL.MKB.MKBGlobal).IsExist(MKBSDDiag,"")
	s existflag=$p(existstr,"^",1)
	s Global=""
	if (existflag=1)	//在全局化词表中能找到描述
	{
		s gloablflag=$p(existstr,"^",2)
		s TheID=$p(existstr,"^",3)
		if (gloablflag=1)	//是术语
		{
			s Global=TheID
		}
		else
		{
			s Global=$p(TheID,"||",1)
		}
	}
	if (Global="")	//没有一致的描述
	{
		s value=""
	}
	else
	{
		s tcount=0
		s InitiativeIDT=""
		for
		{
			s InitiativeIDT=$o(^User.MKBGlobalReferenceI("InverAllIndex",Global,"T",InitiativeIDT))
			q:InitiativeIDT=""
			continue:(InitiativeIDT="undefined")
			s tcount=tcount+1
			
		}
		s dcount=0
		s InitiativeIDD=""
		for
		{
			s InitiativeIDD=$o(^User.MKBGlobalReferenceI("InverAllIndex",Global,"D",InitiativeIDD))
			q:InitiativeIDD=""
			continue:(InitiativeIDD="undefined")
			s dcount=dcount+1
		}
		s TermDR=""
		S DetailValue=""
		s StructDesc=""		//结构化描述
		s InitiativeT=""
		s InitiativeD=""
		if ((tcount+dcount)=1)	//只有一个临床实用诊断引用
		{
			if (tcount=1)
			{
				s InitiativeT=$o(^User.MKBGlobalReferenceI("InverAllIndex",Global,"T",""))    //通过索引表获得引用者的ID
			}
			else
			{
				s InitiativeD=$o(^User.MKBGlobalReferenceI("InverAllIndex",Global,"D",""))
			}
		}
		elseif ((tcount+dcount)>1)	//引用位置有多个临床实用诊断/常用诊断表达式，需要优选，首先找完全匹配项
		{
			
			s GlobalAlias=$o(^User.MKBGloAliasI("DescIndex",Global," "_$ZCONVERT(MKBSDDiag,"U"),""))
			//	//^User.MKBGlobalReferenceI("PassiveAliasIndex",265132,311396,"D",2564739,128937)
			//Index PassiveAliasIndex On (PassiveID As Exact, PassiveAliasID As Exact, InitiativeFlag As Exact, InitiativeID As Exact);
			s InitiativeIDD=$o(^User.MKBGlobalReferenceI("PassiveAliasIndex",Global,GlobalAlias,"D",""))		//常用诊断表达式
			s InitiativeIDT=$o(^User.MKBGlobalReferenceI("PassiveAliasIndex",Global,GlobalAlias,"T",""))		//临床实用诊断
			if (InitiativeIDT'="")		//优先取临床实用诊断
			{
				s InitiativeT=InitiativeIDT    //通过索引表获得引用者的ID
			}
			else	//常用诊断表达式
			{
				if (InitiativeIDD'="")	//首先找完全匹配项
				{
					s InitiativeD=InitiativeIDD
				}
				else	//不能完全匹配
				{
					if (tcount>0)
					{
						s InitiativeT=$o(^User.MKBGlobalReferenceI("InverAllIndex",Global,"T",""))
					}
				}
				
			}
		}
		
		if (InitiativeT'="")	//临床实用诊断引用为空
		{
			s TermDR=InitiativeT
			S DetailValue=""
			s StructDesc=$listGet($g(^User.MKBTermD(InitiativeT)),3)  //描述
		}
		elseif (InitiativeD'="")	//常用诊断表达式引用为空
		{
			s property=$LISTGET($G(^User.MKBTermProDetailD(InitiativeD)),6)	//属性id
			q:(property="") ""
			s SValue=""
			s Desc=""
			s subId=0  //循环扩展属性子表User.MKBTermProperty
			for 
			{
				S subId=$o(^User.MKBTermPropertyD(property,"ChildExtPro",subId)) q:subId=""
				s MKBTEPVValueStr=##class(web.DHCBL.MKB.MKBTermProDetail).GetExtendProValValue(property,subId,InitiativeD)
				s MKBTEPVValue=$p(MKBTEPVValueStr,"[A]",1)
				s MKBTEPVValueF=$p(MKBTEPVValueStr,"[A]",2)
				s SValue=MKBTEPVValueF
				s Desc=MKBTEPVValue
			}
			if (SValue'="")	//结构化表达式不为空
			{
				s TermDR=$p(SValue,"-",1)
				s DetailValue=$p(SValue,"-",2)
				s StructDesc=Desc
			}
		}
		if (TermDR'="")	//能找到中心词
		{
			if (DetailValue'="")
			{
				
				if (rowidflag'="")
				{
					s value=TermDR_"-"_DetailValue_"#"_StructDesc
				}
				else
				{
					s value=TermDR_"-"_DetailValue	
				}
			}
			else
			{
				if (rowidflag'="")
				{
					s value=TermDR_"#"_StructDesc
				}
				else
				{
					s value=TermDR	
				}
				
			}
		}
		else
		{
			s value=""
		}
	}
	q value
}

/// Creator:钟荣枫
/// CreatDate:2021-3-15
/// Description：数据处理工厂没有结构化的数据自动结构化
/// Table：User.MKBStructuredData
/// Input：MKBSDDiag 描述
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBGlobal).AutoProcessingStructData(1463100)
ClassMethod AutoProcessingStructData(MKBSDRowid)
{
	q:MKBSDRowid="" "false"
	s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2) 
	s result="false"
	s structvalue=..GetStructValueByDesc(MKBSDDiag)
	if (structvalue'="")
	{
		s TermDR=$p(structvalue,"-",1)
		s DetailValue=$p(structvalue,"-",2)
		if (TermDR'="")	//能找到中心词
		{
			s MKBSequence=$o(^User.MKBStructuredDataResultI("SeqIndex",MKBSDRowid,""))
			s:MKBSequence="" MKBSequence=0
			s MKBSequence=MKBSequence+1
			//Index SeqIndex On (MKBSDStructData As Exact, MKBSDSequence As Exact);
			
			s sobj=##class(User.MKBStructuredDataResult).%New(MKBSDRowid)
			d sobj.MKBSDStructDataSetObjectId(MKBSDRowid)
			s sobj.MKBSDSequence=MKBSequence
			s sobj.MKBSDStructResultID=DetailValue
			d sobj.MKBSDTermDRSetObjectId(TermDR)
			s ssc=sobj.%Save()
			d sobj.%Close()
			if $$$ISOK(ssc)
			{
				s result="true"	//$system.OBJ.DisplayError(ssc)
			}
			else
			{
				s result="false"	
			}
		}
		else
		{
			s result="false"
		}
	}
	else
	{
		s result="false"
	}
	q result
}

/// Creator:钟荣枫
/// CreatDate:2021-3-16
/// Description：修改术语的备注
/// Table：User.MKBGlobal
/// Input：GlobalID 术语id, note 备注
/// Return：result
/// Other: w ##class(web.DHCBL.MKB.MKBGlobal).AutoProcessingStructData()
ClassMethod SaveGlobalNote(GlobalID, note)
{
	q:GlobalID="" "false"
	s result=""
	s obj=##class(User.MKBGlobal).%OpenId(GlobalID)
	s bobj = ##class(web.Entity.MKB.MKBGlobal).%New()
	s bobj.MKBGRowId = GlobalID
	s bobj.MKBGCode = obj.MKBGCode
	s bobj.MKBGDesc = obj.MKBGDesc
	s bobj.MKBGEnName=obj.MKBGEnName
	s bobj.MKBGNote = ##class(web.DHCBL.BDP.FunLib).Util(note)
	s bobj.MKBGPYCode=  obj.MKBGPYCode
	s bobj.MKBGLastLevel=obj.MKBGLastLevel
	
	s bobj.MKBGState=obj.MKBGState
	s bobj.MKBGConfirm=obj.MKBGConfirm
	s bobj.MKBGMark = obj.MKBGMark
	s bobj.MKBGDiaTotalFreq=obj.MKBGDiaTotalFreq
	d obj.%Close()
	
	s result=..SaveGlobalEntity(bobj)
	q result
}

/// Creator：钟荣枫
/// CreatDate:2021-3-20
/// Description:导出全局化词表1.0的global
/// Input:path
/// Others：d ##class(web.DHCBL.MKB.MKBGlobal).ExportGlobalData("D:\GlobalData\")
ClassMethod ExportGlobalData(filePath)
{
	k MList
	k MIdx
	//术语关联科室
	s MList($i(MList))= "User.MKBGDiagLocD.GBL"  
	
	//术语
	s MList($i(MList))= "User.MKBGlobalC.GBL"  
	s MList($i(MList))= "User.MKBGlobalD.GBL"  
	
	//引用
	s MList($i(MList))= "User.MKBGlobalReferenceD.GBL"  
	
	//把所有GBL拼起来
	s items = ""
	for {
		s MIdx = $i(MIdx)
		q:(MIdx>$g(MList))
		s:items'="" items=items_","_MList(MIdx)
		s:items="" items=MList(MIdx)
	}
	s time = $zdt($h,3)
	s time=$p(time,":",1)
	s filename = filePath_"GlobalData"_time_".gof"
	s filename = $Replace(filename,"-","")
	d $SYSTEM.OBJ.Export(items, filename, "", .log)
}

/// Creator：钟荣枫
/// CreatDate:2021-4-13
/// Description:导入global后重新生成索引
/// Input:path
/// Others：d ##class(web.DHCBL.MKB.MKBGlobal).BuildIndices()
ClassMethod BuildIndices()
{
	d ##class(User.MKBGDiagLoc).%BuildIndices()
	d ##class(User.MKBGlobal).%BuildIndices()
	d ##class(User.MKBGlobalReference).%BuildIndices()
	d ##class(User.MKBGloAlias).%BuildIndices()
}

/// Creator：钟荣枫
/// CreatDate:2021-4-13
/// Description:删除数据处理工厂保存到全局化词表的未结构化数据   由于先前的数据处理工厂预处理方法存在问题，有许多能结构化的数据没有结构化，反而保存到全局化词表
/// Input:path
/// Others：w ##class(web.DHCBL.MKB.MKBGlobal).DeleteUnStructData("")
ClassMethod DeleteUnStructData(desc)
{
	s delcount=0
	s GlobalID=""
	for
	{
		s GlobalID=$o(^User.MKBGloAliasI("MarkIndex",GlobalID)) 
		q:GlobalID=""
		s count=0
		s exsitflag=0
		s MKBGAMark=0
		for
		{
			s MKBGAMark=$o(^User.MKBGloAliasI("MarkIndex",GlobalID,MKBGAMark))  //遍历别名表
			q:MKBGAMark=""	
			s count=count+1
			if (MKBGAMark[desc)
			{
				s exsitflag=1
			}
		}
		if ((exsitflag=1)&&(count=1))
		{
			s delcount=delcount+1
			d ..DeleteAll(GlobalID)
		}
	}
	q delcount
}

/// Creator：钟荣枫
/// CreatDate:2021-4-21
/// Description:将主要病因的数据导入到全局化词表
/// Input:path
/// Others：w ##class(web.DHCBL.MKB.MKBGlobal).ImportMainReasonToGlobal()
ClassMethod ImportMainReasonToGlobal()
{
	s addcount=0
	s base=7
	s myRowID=0
	for 
	{
		s myRowID=$o(^User.MKBTermI("BaseIndex",base,myRowID)) q:(myRowID="")
		
		s MKBTDesc=$LISTGET($G(^User.MKBTermD(myRowID)),3)   ///中心词
		s eobj = ##class(web.Entity.MKB.MKBGlobal).%New()	
		s eobj.MKBGRowId=""
		
		s eobj.MKBGDesc = MKBTDesc
		s eobj.MKBGMark = "常用诊断描述"
		s eobj.MKBGState="U"  
		 
		s gre = ##class(web.DHCBL.MKB.MKBGlobal).SaveGlobalEntity(eobj)	//保存术语同时新增别名
		if (gre["true")	//保存成功
		{
			s addcount=addcount+1
			s id=$p($p(gre,":",3),"}",1)
			//$p(gre,"""",4)
			s eaobj=##class(web.Entity.MKB.MKBGloAlias).%New()
		 	s eaobj.MKBGADesc=MKBTDesc
		 	s eaobj.MKBGAParRef=id
		 	s eaobj.MKBGACEFlag="C"
		 	s eaobj.MKBGAMark="展示名,主要病因"	//设为展示名
		 	s eaobj.IsDisplayName="Y"
		 	s alisare= ##class(web.DHCBL.MKB.MKBGlobal).SaveAliasEntity(eaobj)
		 	if (alisare'="false")
		 	{
				d ##class(web.DHCBL.MKB.MKBGlobal).RefHandle("1","1,2",id)
		 	}
		}	
	}
	q addcount
}

/// Creator：钟荣枫
/// CreatDate:2021-4-28
/// Description:重复的未机构化数据处理
/// Input:
/// Others：w ##class(web.DHCBL.MKB.MKBGlobal).HandelUnStuctData()
ClassMethod HandelUnStuctData()
{
	s mergecount=0
	s errorflag=0
	TS
	s GlobalID=""
	for
	{
		s GlobalID=$o(^User.MKBGloAliasI("MarkIndex",GlobalID)) 
		q:GlobalID=""
		q:errorflag=1
		s count=0
		s exsitflag=0
		s MKBGAMark=0
		for
		{
			s MKBGAMark=$o(^User.MKBGloAliasI("MarkIndex",GlobalID,MKBGAMark))  //遍历别名表
			q:MKBGAMark=""	
			s count=count+1
			if (MKBGAMark["数据处理工厂")
			{
				s exsitflag=1
			}
		}
		if ((exsitflag=1)&&(count=1))
		{
			s MKBGDesc = $lg($g(^User.MKBGlobalD(GlobalID)),3)
			s matchGlobal=""
			s Global=""
			for
			{
				s Global=$o(^User.MKBGloAliasI("NameIndex"," "_$ZCONVERT(MKBGDesc,"U"),Global))
				q:Global=""
				q:matchGlobal'=""
				continue:GlobalID=Global
				s matchGlobal=Global
			}
			if (matchGlobal'="")
			{
				s AlisaID=$o(^User.MKBGloAliasI("DescIndex",GlobalID," "_$ZCONVERT(MKBGDesc,"U"),""))
				s MKBGAMark = $lg($g(^User.MKBGlobalD(GlobalID,"ChildGloAlias",AlisaID)),8)
				s newmark=""
				for m=1:1:$l(MKBGAMark,",")
				{
					s piece=$p(MKBGAMark,",",m)
					if (piece'["数据处理工厂")
					{
						if (newmark="")
						{
							s newmark=piece
						}
						else
						{
							s newmark=newmark_","_piece
						}
					}
					
				}
				d ##class(web.DHCBL.MKB.MKBGlobal).SaveAliasLog(GlobalID,AlisaID,"", "", "", "", "", newmark, "")
				
					
				s re= ..MergeGlobalData(matchGlobal_","_GlobalID)
				if (re'["false")
				{
					s mergecount=mergecount+1
				}
				else
				{
					s errorflag=1	
				}
			}
		}
	}
	if (errorflag=1)
	{
		tro	
		s result="false"
	}
	else
	{
		s result=mergecount
		tc
	}
	q result
}

/// Creator：钟荣枫
/// CreatDate:2021-4-28
/// Description:已经结构化的数据，需要将数据处理工厂标记删除
/// Input:path
/// Others：w ##class(web.DHCBL.MKB.MKBGlobal).DelDoneStuctData()
ClassMethod DelDoneStuctData(base)
{
	s errorflag=0
	TS
	s MKBSTBDesc=$LISTGET($G(^User.MKBStructuredBaseD(base)),2)
	
	s MKBSDRowid=0
	for
	{
		//Index BaseIndex On MKBSDBaseDr;
		s MKBSDRowid=$O(^User.MKBStructuredDataI("BaseIndex",base,MKBSDRowid))	
		q:MKBSDRowid=""
		s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)  
		
		s StructuredDataID=$o(^User.MKBStructuredDataResultI("MKBSDStructDataIndex",MKBSDRowid,""))
		continue:(StructuredDataID="")
		s Diag = ##class(web.DHCBL.BDP.FunLib).AutoSBDB(MKBSDDiag,0)		//全角转半角
		s Diag=##class(web.DHCBL.MKB.MKBGlobal).SpaceHandleMethod1(Diag)
		s Diag=##class(web.DHCBL.MKB.MKBGlobal).SpaceHandleMethod2(Diag)
		s Diag=##class(web.DHCBL.MKB.MKBGlobal).SpaceHandleMethod3(Diag)
		s existstr= ##class(web.DHCBL.MKB.MKBGlobal).IsExist(Diag,"")
		s existflag=$p(existstr,"^",1)
		if (existflag'=0)		//已结构化的数据在全局化词表中存在
		{
			s Globalflag=$p(existstr,"^",2)		//是否是术语
			s TheID=$p(existstr,"^",3)
			s GlobalAlias=""
			s existGlobal=""
			if (Globalflag=1)	//是术语
			{
				s existGlobal=TheID
				s AlisaID=$o(^User.MKBGloAliasI("DescIndex",existGlobal," "_Diag,""))
			}
			else
			{
				s existGlobal=$p(TheID,"||",1)
				s GlobalAlias=$p(TheID,"||",2)
			}
			if (GlobalAlias'="")
			{
				s MKBGAMark = $lg($g(^User.MKBGlobalD(existGlobal,"ChildGloAlias",GlobalAlias)),8)
				if (MKBGAMark[MKBSTBDesc)	//标记没删除
				{
					s MKBGAMark=$Replace(MKBGAMark,","_MKBSTBDesc,"")
					s MKBGAMark=$Replace(MKBGAMark,MKBSTBDesc_",","")
					s MKBGAMark=$Replace(MKBGAMark,MKBSTBDesc,"")
					s:MKBGAMark="" MKBGAMark="别名"
					s re= ##class(web.DHCBL.MKB.MKBGlobal).SaveAliasLog(existGlobal,GlobalAlias,"", "", "", "", "", MKBGAMark, "")
					s:re["false" errorflag=1
				}
			}	
		}
	}
	if (errorflag=1)
	{
		tro	
		s result="false"
	}
	else
	{
		s result="true"
		tc
	}
	q result
}

/// Creator：钟荣枫
/// CreatDate:2021-4-28
/// Description:处理有展示名标记，但是ISDisplayName字段为空的数据
/// Input:path
/// Others：w ##class(web.DHCBL.MKB.MKBGlobal).HandleIsDisplayAlias()
ClassMethod HandleIsDisplayAlias()
{
	s errorflag=0
	s result=""
	TS
	s GlobalID=""
	for
	{
		s GlobalID=$o(^User.MKBGloAliasI("MarkIndex",GlobalID)) 
		q:GlobalID=""
		q:errorflag=1
		s DisaplayAliasID=$o(^User.MKBGloAliasI("DisplayName",GlobalID," Y",""))
		if (DisaplayAliasID'="")
		{
			s MKBGAMark=0
			for
			{
				s MKBGAMark=$o(^User.MKBGloAliasI("MarkIndex",GlobalID,MKBGAMark))  //遍历别名表
				q:MKBGAMark=""	
				if ((MKBGAMark["展示名")&&(MKBGAMark'["英文展示名"))
				{
					s Alias=""
					for
					{
						s Alias=$o(^User.MKBGloAliasI("MarkIndex",GlobalID,MKBGAMark,Alias))  //遍历别名表
						q:Alias=""
						continue:Alias=DisaplayAliasID
						s OldMarkStr = MKBGAMark
						s OldMarkStr=##class(web.BDP.util.String).Replace(OldMarkStr,"展示名,","")
						s OldMarkStr=##class(web.BDP.util.String).Replace(OldMarkStr,",展示名","")
						s OldMarkStr=##class(web.BDP.util.String).Replace(OldMarkStr,"展示名","")
						s re= ..SaveAliasLog(GlobalID, Alias, "", "", "", "", "", OldMarkStr, "N")
						s:re["false" errorflag=1
					}
				}
			}
		}
		else
		{
			s are= ..AddDisplayName(GlobalID)
			s:are["false" errorflag=1
		}
	}
	if (errorflag=1)
	{
		s result="false"
		tro
	}
	else
	{
		s result="true"
		tc	
	}
	q result
}

/// Creator：钟荣枫
/// CreatDate:2021-5-6
/// Description:处理术语id为空或者引用位置为空的引用
/// Input:
/// Others：w ##class(web.DHCBL.MKB.MKBGlobal).HandleErrorReference()
ClassMethod HandleErrorReference()
{
	s count=0
	s result=""
	s errorflag=0
	ts
	s ReferID=""
	for
	{
		s ReferID=$o(^User.MKBGlobalReferenceD(ReferID))    
		q:ReferID=""
		q:errorflag=1
		s InitiativeID=$lg($g(^User.MKBGlobalReferenceD(ReferID)),3)	//引用的ID，必填项
		s PassiveID=$lg($g(^User.MKBGlobalReferenceD(ReferID)),4)	//全局化词表ID，必填项
		s PassiveAliasID = $lg($g(^User.MKBGlobalReferenceD(ReferID)),5)
		if ((InitiativeID="")||(PassiveID="")||(InitiativeID["un")||(PassiveID["un"))
		{
			s count=count+1
			s re= ..DeleteReferenceData(ReferID)
			s:re["false" errorflag=1
		}
	}
	if (errorflag=0)
	{
		s result=count
		tc
	}
	else
	{
		s result="false"
		tro
	}
	q count
}

/// Creator：钟荣枫
/// CreatDate:2021-6-4
/// Description:引用处理 数据和各个医院的ICD进行匹配处理
/// Input:baseid， MKBGloAliasDesc需要进行匹配的诊断描述 
/// 输出 未匹配  已匹配 （匹配到的数据id）
/// w ##class(web.DHCBL.MKB.MKBGlobal).RefHandleStructuredBase(3," 高尿酸血症")
ClassMethod RefHandleStructuredBase(baseid As %String, MKBGloAliasDesc As %String)
{
	q:((baseid="")||(MKBGloAliasDesc="")) "N"
	//Index MKBSDDiagIndex On (MKBSDBaseDr, MKBSDDiag);
	//User.MKBStructuredData
	s MKBSDID="N"
	s StructuredDesc=""
	for
	{
		s StructuredDesc=$o(^User.MKBStructuredDataI("MKBSDDiagIndex",baseid,StructuredDesc))
		q:StructuredDesc=""
		s NewDesc=""
		s NewDesc = ##class(web.DHCBL.BDP.FunLib).AutoSBDB(StructuredDesc,0)		//全角转半角
		s NewDesc=..SpaceHandleMethod1(NewDesc)
		s NewDesc=..SpaceHandleMethod2(NewDesc)
		s NewDesc=..SpaceHandleMethod3(NewDesc)
		s NewDesc=" "_NewDesc
		if (MKBGloAliasDesc=NewDesc)
		{
			s MKBSDID = $o(^User.MKBStructuredDataI("MKBSDDiagIndex",baseid,StructuredDesc,0))
			q:MKBSDID'=""
		}
	}
	q MKBSDID
}

/// Creator：钟荣枫
/// CreatDate:2021-6-4
/// Description:导出数据处理工厂里能/不能与词表匹对的数据
/// Input:baseid，
/// OutPut: 
/// w ##class(web.DHCBL.MKB.MKBGlobal).ExportStructMatch(9)
ClassMethod ExportStructMatch(base)
{
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1)
	s PathDir=Disk_":\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\"
	s ifExistsDir=##class(%File).DirectoryExists(PathDir)
	if ifExistsDir'=1
	{
		d ##class(%File).CreateDirectory("D:\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\")
	}
	s P=Disk_":\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\与词表匹对的数据"_time_".csv"
	s file=##class(%File).%New(P)
	s filename = "与词表匹对的数据"_time_".csv"
	d file.Open("NWS")
	d file.Write("诊断描述,"_"诊断icd,"_"匹配的术语条目,"_"匹配的别名")
	d file.WriteLine()
	
	s P2=Disk_":\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\不能和词表匹对的数据"_time_".csv"
	s file2=##class(%File).%New(P2)
	s filename2 = "不能和词表匹对的数据"_time_".csv"
	d file2.Open("NWS")
	d file2.Write("诊断描述,"_"诊断icd")
	d file2.WriteLine()
	
    
	s Num=0
	
	s StructuredID=""
	for
	{
		s StructuredID=$o(^User.MKBStructuredDataI("BaseIndex",base,StructuredID))
		q:StructuredID=""
		s StructuredDesc=$lg($g(^User.MKBStructuredDataD(StructuredID)),2)  //诊断描述
		s MKBSDICD=$lg($g(^User.MKBStructuredDataD(StructuredID)),20)  //诊断icd
		s NewDesc=""
		s NewDesc = ##class(web.DHCBL.BDP.FunLib).AutoSBDB(StructuredDesc,0)		//全角转半角
		s NewDesc=..SpaceHandleMethod1(NewDesc)
		s NewDesc=..SpaceHandleMethod2(NewDesc)
		s NewDesc=..SpaceHandleMethod3(NewDesc)
		
		//Index NameIndex On MKBGADesc;
		
		s matchflag=0
		
		s GlobalID=""		//获取所有描述一致的
		for
		{
			s GlobalID=$o(^User.MKBGloAliasI("NameIndex"," "_$zconvert(NewDesc,"U"),GlobalID))
			q:GlobalID=""
			s GlobalDesc=$lg($g(^User.MKBGlobalD(GlobalID)),3)
			s AliasId=""
			for
			{
				s AliasId=$o(^User.MKBGloAliasI("NameIndex"," "_$zconvert(NewDesc,"U"),GlobalID,AliasId))
				q:AliasId=""
				s AliasDesc=$lg($g(^User.MKBGlobalD(GlobalID,"ChildGloAlias",AliasId)),2)   //别名
				/*
				s eobj = ##class(web.Entity.MKB.MKBGlobalReference).%New()
			
				s eobj.InitiativeFlag="ICDSD"				//发起引用，主动引用标识
				s eobj.InitiativeID=StructuredID				//发起引用词的ID
				s eobj.PassiveID=GlobalID			//被引用词的ID
				s eobj.PassiveAliasID=AliasId				//被引用词的名称列表ID
				d ..SaveReferenceEntity(eobj)
				*/
				d file.Write(StructuredDesc_",")
				d file.Write(MKBSDICD_",")
				d file.Write(GlobalDesc_",")
				d file.Write(AliasDesc)
				d file.WriteLine()
				s matchflag=1
			}
		}
		
		if (matchflag=0)
		{
			s snobj =##class(User.MKBStructuredData).%OpenId(StructuredID)
		   	s snobj.MKBSDStatus="G"
			s UpdateDate=$p($h,",",1)       //上传日期
			s snobj.MKBSDDate=UpdateDate
		   	s fwk = snobj.%Save()
		   	d snobj.%Close()
		   	
			d file2.Write(StructuredDesc_",")
			d file2.Write(MKBSDICD)
			d file2.WriteLine()
		}
	}
	d file.%Save()
	d file.%Close()
	d file2.%Save()
	d file2.%Close()
	q filename
}

/// Creator：钟荣枫
/// CreatDate:2021-6-4
/// Description:数据处理工厂不能结构化的数据处理 1、不能匹配上的数据，以ICD码为基准，反查国标ICD2.0
/// Input:baseid，
/// OutPut: 成功， 失败
/// w ##class(web.DHCBL.MKB.MKBGlobal).HandleICDContrast(9)
ClassMethod GetUnHandleStructData(base)
{
	q:((base="")||($d(^User.MKBStructuredDataI("BaseIndex",base))<=0)) "{""rows"":[], ""total"":0}"
	k ^TEMPStructSort
	s result="",total=0,jsonstr=""
	
	w "{""rows"":["
	s total=0
	s MKBSDRowid=""
	for
	{
		s MKBSDRowid=$O(^User.MKBStructuredDataI("BaseIndex",base,MKBSDRowid))	
		q:MKBSDRowid=""
		s MKBSDTCMDiagFlag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),24) 	//中医诊断标识
		s StructuredDataID=$o(^User.MKBStructuredDataResultI("MKBSDStructDataIndex",MKBSDRowid,""))
		continue:(StructuredDataID'="")	//过滤已结构化的数据
		s MKBSDICD=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),20)	//icd
		s MKBSDTotalFreq=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),13) 	//频次
		s ^TEMPStructSort("sort",MKBSDTotalFreq,MKBSDICD,MKBSDRowid)=""
		
	}
	
	s seq=""
	for
	{
		s seq=$O(^TEMPStructSort("sort",seq),-1)	
		q:seq=""
		s icd=""
		for
		{
			s icd=$O(^TEMPStructSort("sort",seq,icd))	
			q:icd=""
			s MKBSDRowid=""
			for
			{
				s MKBSDRowid=$O(^TEMPStructSort("sort",seq,icd,MKBSDRowid))
				q:MKBSDRowid=""
				s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)  
				s total=total+1
				q:total>5
				s mainstr="{""MKBSDRowid"":"""_MKBSDRowid_""",""MKBSDICD"":"""_icd_""",""MKBSDDiag"":"""_MKBSDDiag_"""}"
				if (jsonstr'="")
				{ 
					w ","
					s jsonstr=jsonstr_","_mainstr
				}
				else
				{
					s jsonstr=mainstr
				}
				w mainstr
										
			}
		}	
	}
	w "], ""total"":"_total_"}"
	q ""
}

/// Creator：钟荣枫
/// CreatDate:2021-6-10
/// Description:根据医大一患者诊断信息，重新计算诊断科室频次
/// Input:
/// OutPut: 
/// w ##class(web.DHCBL.MKB.MKBGlobal).HandleLocFreqList()
ClassMethod HandleLocFreqList()
{
	//k掉原先的科室频次
	k ^User.MKBGDiagLocI
	k ^User.MKBGDiagLocD
	ts
	
	k ^TEMPFreq
	s ID=0
	for 
	{   
		s ID=$o(^User.MKBBirthToDeadDiaD(ID))
		q:ID=""
		s PatDR=$lg($g(^User.MKBBirthToDeadDiaD(ID)),2)        /// 患者EMR表
		s Hospital=""
		s:PatDR'="" Hospital= $lg($g(^User.MKBPatInfoD(PatDR)),8)	
		continue:Hospital'="中国医科大学附属第一医院"	
		
		s DiaOriginal= $lg($g(^User.MKBBirthToDeadDiaD(ID)),3)	/// 诊断描述（前缀+诊断名+备注）
		s DiaOriginal = ##class(web.DHCBL.BDP.FunLib).AutoSBDB(DiaOriginal,0)		//全角转半角
		s DiaOriginal=..SpaceHandleMethod1(DiaOriginal)
		s DiaOriginal=..SpaceHandleMethod2(DiaOriginal)
		s DiaOriginal=..SpaceHandleMethod3(DiaOriginal)
		s MKBBirthToDeadDiaLocID=0
		for
		{
			
			s MKBBirthToDeadDiaLocID=$o(^User.MKBBirthToDeadDiaLocI("DiaDRIndex",ID,MKBBirthToDeadDiaLocID)) 
			q:MKBBirthToDeadDiaLocID=""
			s ProfDeptDR=$lg($g(^User.MKBBirthToDeadDiaLocD(MKBBirthToDeadDiaLocID)),4) //专业科室ID
			s ProfDesc=""
			if ($d(^TEMPFreq("Freq",DiaOriginal,ProfDeptDR))>0)		//已记录
			{
				s freq=^TEMPFreq("Freq",DiaOriginal,ProfDeptDR)
				s:freq="" freq=0
				s ^TEMPFreq("Freq",DiaOriginal,ProfDeptDR)=freq+1
			}
			else
			{
				s ^TEMPFreq("Freq",DiaOriginal,ProfDeptDR)=1
			}

		}
	}
	
	s Desc=""
	for
	{
		s Desc=$o(^TEMPFreq("Freq",Desc))
		q:Desc=""
		s GlobalID=""
		for
		{
			s GlobalID=$O(^User.MKBGloAliasI("NameIndex"," "_$zconvert(Desc,"U"),GlobalID))
			q:GlobalID=""
			
			s deptdr=""
			for
			{
				s deptdr=$o(^TEMPFreq("Freq",Desc,deptdr))
				q:deptdr=""
				if ($d(^User.MKBGDiagLocI("ProfDeptDRIndex",GlobalID,deptdr))>0)
			    {
				    s FreqID = $o(^User.MKBGDiagLocI("ProfDeptDRIndex",GlobalID,deptdr,0))
				    s obj = ##class(User.MKBGDiagLoc).%OpenId(FreqID)
					s oldfreq=obj.Frequency
					s obj.Frequency = ^TEMPFreq("Freq",Desc,deptdr)+oldfreq
				    s sc = obj.%Save()
				    d obj.%Close()
				    if $$$ISOK(sc)
				    {
					    
					}
				}
				else
				{
					s obj = ##class(User.MKBGDiagLoc).%New()
					d obj.DiaDRSetObjectId(GlobalID)
					d obj.ProfDeptDRSetObjectId(deptdr)
					s obj.Frequency = ^TEMPFreq("Freq",Desc,deptdr)
					s sc = obj.%Save()
				    d obj.%Close()
				    if $$$ISOK(sc)
				    {
					    
					}
				}

			}
				
		}
		
	}
	//修改频率
	s GlobalID=""
	for
	{
		s GlobalID=$O(^User.MKBGlobalD(GlobalID))
		q:GlobalID=""
		s MKBGDiaTotalFreq = 0
	    s MKBGLFRowId = 0
	 	for
	 	{
		 	s MKBGLFRowId = $o(^User.MKBGDiagLocI("DiaDRIndex",GlobalID,MKBGLFRowId))
		 	q:MKBGLFRowId=""

		 	s LocFreq =$lg($g(^User.MKBGDiagLocD(MKBGLFRowId)),4) 
		 	s MKBGDiaTotalFreq=MKBGDiaTotalFreq+LocFreq
		}
		d ..SaveGlobalLog(GlobalID, "", "","","", "", "", MKBGDiaTotalFreq)	//修改频率
	}
	k ^TEMPFreq
	q "success"
}

/// Creator：钟荣枫
/// CreatDate:2021-6-10
/// Description:根据术语id或者别名id，获取描述
/// Input:
/// OutPut: 
/// w ##class(web.DHCBL.MKB.MKBGlobal).GetDataDetailDesc()
ClassMethod GetDataDetailDesc(rowid)
{
	q:rowid="" ""
	s Desc=""
	if (rowid["||")
	{
		s GlobalID=$p(rowid,"||",1)
		s AliasID=$p(rowid,"||",2)
		s Desc=$lg($g(^User.MKBGlobalD(GlobalID,"ChildGloAlias",AliasID)),2)
	}
	else
	{
		s Desc=$lg($g(^User.MKBGlobalD(rowid)),3)
	}
	q Desc
}

/// Creator：钟荣枫
/// CreatDate:2021-6-10
/// Description:检查引用的数据是否被删除或封闭，如果已被删除或封闭，需要删除这条引用
/// Input:
/// OutPut: 
/// w ##class(web.DHCBL.MKB.MKBGlobal).CheckReferenceToDelete()
ClassMethod CheckReferenceToDelete(rowid = "")
{
	s count=0
	s GlobalID=""
	for
	{
		s GlobalID=$o(^User.MKBGlobalD(GlobalID))
		q:GlobalID=""
		continue:((rowid'="")&&(GlobalID'=rowid))
		s delflag=0
		s InitiativeFlag=""
		for
		{
			s InitiativeFlag=$o(^User.MKBGlobalReferenceI("InverAllIndex",GlobalID,InitiativeFlag))    //通过索引表获得引用者的ID
			q:InitiativeFlag=""
			s RefRowId=1
			for
			{
				s RefRowId=$o(^User.MKBGlobalReferenceI("InverAllIndex",GlobalID,InitiativeFlag,RefRowId))    //通过索引表获得引用者的ID
				q:RefRowId=""
				s flag=1
				if (InitiativeFlag="T")			//临床实用诊断
				{
					if ($d(^User.MKBTermD(RefRowId))<=0)
					{
						s flag=0
					}
					else
					{
						s MKBTActiveFlag=$listGet($g(^User.MKBTermD(RefRowId)),9)
						s:(MKBTActiveFlag="N") flag=0
					}
				}
				elseif (InitiativeFlag="D")		//常用诊断表达式
				{
					if ($d(^User.MKBTermProDetailD(RefRowId))<=0)	//被删除 不存在
					{
						s flag=0
					}
					else
					{
						s ProRowId=$lg($g(^User.MKBTermProDetailD(RefRowId)),6) 
						if (ProRowId="")
						{
							s flag=0
						}
						else
						{
							s TermRowId=$lg($g(^User.MKBTermPropertyD(ProRowId)),6)
							if (TermRowId="")
							{
								s flag=0
							}
							else
							{
								s MKBTActiveFlag=$listGet($g(^User.MKBTermD(TermRowId)),9)
								s:(MKBTActiveFlag="N") flag=0
							}
							 
						}
						
					}
					s:$d(^User.MKBTermProDetailD(RefRowId))<=0 flag=0
				}
				elseif (InitiativeFlag="ICDCon")		//各版本icd
				{
					s:$d(^User.MKBICDContrastD(RefRowId))<=0 flag=0
				}
				else
				{
					s:$d(^User.MKBStructuredDataD(RefRowId))<=0 flag=0
				}
				if (flag=0)		//引用的数据不存在时，删除引用
				{
					s RefID=""
					for
					{
						s RefID=$o(^User.MKBGlobalReferenceI("InverAllIndex",GlobalID,InitiativeFlag,RefRowId,RefID))    //通过索引表获得引用者的ID
						q:RefID=""
						s count=count+1
						d ..DeleteReferenceData(RefID)
						s delflag=1
					}
					
				}
			}
		}
	}
	q count
}

/// Creator：钟荣枫
/// CreatDate:2021-6-10
/// Description:根据所在的术语以及别名，得到对应的临床实用诊断或者常用诊断表达式
/// Input: Global  术语id ，Diag  描述
/// OutPut: TermDR_"-"_DetailValue_"#"_StructDesc   TermDR 中心词id，DetailValue 属性串，StructDesc 结构化描述
/// w ##class(web.DHCBL.MKB.MKBGlobal).GetStructIDS(200533,"高血压3级(很高危)")
ClassMethod GetStructIDS(Global, Diag)
{
	s result=""
	s tcount=0
	s InitiativeIDT=""
	for
	{
		s InitiativeIDT=$o(^User.MKBGlobalReferenceI("InverAllIndex",Global,"T",InitiativeIDT))
		q:InitiativeIDT=""
		continue:(InitiativeIDT="undefined")
		s tcount=tcount+1
		
	}
	s dcount=0
	s InitiativeIDD=""
	for
	{
		s InitiativeIDD=$o(^User.MKBGlobalReferenceI("InverAllIndex",Global,"D",InitiativeIDD))
		q:InitiativeIDD=""
		continue:(InitiativeIDD="undefined")
		s dcount=dcount+1
	}
	s TermDR=""
	S DetailValue=""
	s StructDesc=""		//结构化描述
	s InitiativeT=""
	s InitiativeD=""
	if ((tcount+dcount)=1)	//只有一个临床实用诊断引用
	{
		if (tcount=1)	//是临床实用诊断
		{
			s InitiativeT=$o(^User.MKBGlobalReferenceI("InverAllIndex",Global,"T",""))    //通过索引表获得引用者的ID
		}
		else
		{
			s InitiativeD=$o(^User.MKBGlobalReferenceI("InverAllIndex",Global,"D",""))
		}
	}
	elseif ((tcount+dcount)>1)	//引用位置有多个临床实用诊断/常用诊断表达式，需要优选，首先找完全匹配项
	{
		if (Diag'="")
		{
			s GlobalAlias=$o(^User.MKBGloAliasI("DescIndex",Global," "_$ZCONVERT(Diag,"U"),""))
			//	//^User.MKBGlobalReferenceI("PassiveAliasIndex",265132,311396,"D",2564739,128937)
			//Index PassiveAliasIndex On (PassiveID As Exact, PassiveAliasID As Exact, InitiativeFlag As Exact, InitiativeID As Exact);
			s InitiativeIDD=$o(^User.MKBGlobalReferenceI("PassiveAliasIndex",Global,GlobalAlias,"D",""))		//常用诊断表达式
			s InitiativeIDT=$o(^User.MKBGlobalReferenceI("PassiveAliasIndex",Global,GlobalAlias,"T",""))		//临床实用诊断
			if (InitiativeIDT'="")		//优先取临床实用诊断
			{
				s InitiativeT=InitiativeIDT    //通过索引表获得引用者的ID
			}
			else	//常用诊断表达式
			{
				if (InitiativeIDD'="")	//首先找完全匹配项
				{
					s InitiativeD=InitiativeIDD
				}
				else	//不能完全匹配
				{
					if (tcount>0)
					{
						s InitiativeT=$o(^User.MKBGlobalReferenceI("InverAllIndex",Global,"T",""))
					}
				}
				
			}
		}
		else
		{
			if (tcount>0)
			{
				s InitiativeT=$o(^User.MKBGlobalReferenceI("InverAllIndex",Global,"T",""))    //通过索引表获得引用者的ID	
			}
			else
			{
				s InitiativeD=$o(^User.MKBGlobalReferenceI("InverAllIndex",Global,"D",""))
			}	
		}
	}
	
	if (InitiativeT'="")	//临床实用诊断引用为空
	{
		s TermDR=InitiativeT
		S DetailValue=""
		s StructDesc=$listGet($g(^User.MKBTermD(InitiativeT)),3)  //描述
	}
	elseif (InitiativeD'="")	//常用诊断表达式引用为空
	{
		s property=$LISTGET($G(^User.MKBTermProDetailD(InitiativeD)),6)	//属性id
		q:(property="") ""
		s SValue=""
		s Desc=""
		s subId=0  //循环扩展属性子表User.MKBTermProperty
		for 
		{
			S subId=$o(^User.MKBTermPropertyD(property,"ChildExtPro",subId)) q:subId=""
			s MKBTEPVValueStr=##class(web.DHCBL.MKB.MKBTermProDetail).GetExtendProValValue(property,subId,InitiativeD)
			s MKBTEPVValue=$p(MKBTEPVValueStr,"[A]",1)
			s MKBTEPVValueF=$p(MKBTEPVValueStr,"[A]",2)
			s SValue=MKBTEPVValueF
			s Desc=MKBTEPVValue
		}
		if (SValue'="")	//结构化表达式不为空
		{
			s TermDR=$p(SValue,"-",1)
			s DetailValue=$p(SValue,"-",2)
			s StructDesc=Desc
		}
	}
	s result=TermDR_"-"_DetailValue_"#"_StructDesc
	q result
}

/// Creator：钟荣枫
/// CreatDate:2021-8-3
/// Description:引用处理 根据各个医院的ICD对照全局化词表处理
/// Input:baseid
/// w ##class(web.DHCBL.MKB.MKBGlobal).StructuredDataToRef(13)
ClassMethod StructuredDataToRef(baseid As %String)
{
	q:(baseid="") "false"
	k ^TempMarkSortList
	d ..SortGlobal("termsort","","")
	s mark="部位,临床实用诊断,常用诊断描述,业务诊断,展示名"	
	s count=0
	//各个医院的数据处理工厂
	
	if (baseid'["ICD")
	{
		k ^TempUnsave
		s unsavecount=0
		
		//Index BaseIndex On MKBSDBaseDr;

		s MKBSDRowid=""
		for
		{
			s MKBSDRowid=$o(^User.MKBStructuredDataI("BaseIndex",baseid,MKBSDRowid))
			q:MKBSDRowid=""
			continue:($d(^TempUnsave(MKBSDRowid))>0)
			s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)  //诊断描述
			s MKBSDIcd=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),20)		//icd
			//Index ICDIndex On MKBSDICD As Exact;
			//同码不同名的不导入全局化词表
			s icdcount=0
			s ICDSameID=""
			for
			{
				s ICDSameID=$o(^User.MKBStructuredDataI("ICDIndex",MKBSDIcd,ICDSameID))
				q:ICDSameID=""
				continue:(ICDSameID=MKBSDRowid)
				s ICDSameDiag=$lg($g(^User.MKBStructuredDataD(ICDSameID)),2)  //诊断描述
				if (ICDSameDiag'=MKBSDDiag)
				{
					s unsavecount=unsavecount+1
					s ^TempUnsave(ICDSameID)=""
				}
			}
			
			//同名不同码的不导入全局化词表
			//Index MKBSDDiagIndex On (MKBSDBaseDr, MKBSDDiag);
			s diagcount=0
			s DiagSameID=""
			for
			{
				s DiagSameID=$o(^User.MKBStructuredDataI("MKBSDDiagIndex",baseid,MKBSDDiag,DiagSameID))
				q:DiagSameID=""
				continue:(DiagSameID=MKBSDRowid)
				s DiagSameICD=$lg($g(^User.MKBStructuredDataD(DiagSameID)),20)		//icd
				
				if (DiagSameICD'=MKBSDIcd)
				{
					s unsavecount=unsavecount+1
					s ^TempUnsave(DiagSameID)=""
				}
			}
			s NewDesc=""
			s NewDesc = ##class(web.DHCBL.BDP.FunLib).AutoSBDB(MKBSDDiag,0)		//全角转半角
			s NewDesc=..SpaceHandleMethod1(NewDesc)
			s NewDesc=..SpaceHandleMethod2(NewDesc)
			s NewDesc=..SpaceHandleMethod3(NewDesc)
			
			s MatchAliasID=""
			
			s NumCount=0			
			for
			{
				s NumCount=$o(^TempMarkSortList("Sort",NumCount))
				q:NumCount=""
				q:MatchAliasID'=""
				s MKBGRowId=^TempMarkSortList("Sort",NumCount)
				q:MKBGRowId=""
			    s MKBGDesc=$lg($g(^User.MKBGlobalD(MKBGRowId)),3)
			    s MKBGloMark =$lg($g(^User.MKBGlobalD(MKBGRowId)),10)
				continue:(mark'[MKBGloMark)

				s AliasId=$o(^User.MKBGloAliasI("DescIndex",MKBGRowId," "_$ZCONVERT(NewDesc,"U"),0))
				s:AliasId'="" MatchAliasID=MKBGRowId_"||"_AliasId
			}
			
			if (MatchAliasID'="")	//能够匹配上
			{
				s GlobalID=$p(MatchAliasID,"||",1)
				s AliasID=$p(MatchAliasID,"||",2)
				s MKBGRRowid=$o(^User.MKBGlobalReferenceI("PassiveAliasIndex",GlobalID,AliasID,"ICDSD",MKBSDRowid,0)) 
				if (MKBGRRowid="")
				{
					s count=count+1
					s eobj = ##class(web.Entity.MKB.MKBGlobalReference).%New()
					s eobj.MKBGRRowid = ""
					
					s eobj.InitiativeFlag="ICDSD"				//发起引用，主动引用标识
					s eobj.InitiativeID=MKBSDRowid				//发起引用词的ID
					s eobj.PassiveID=GlobalID				//被引用词的ID
					s eobj.PassiveAliasID=AliasID				//被引用词的名称列表ID
					s result= ..SaveReferenceEntity(eobj)
					
				}
			}
		}
	}
	q count
}

/// Creator：钟荣枫
/// CreatDate:2021-8-3
/// Description:
/// Input:baseid
/// w ##class(web.DHCBL.MKB.MKBGlobal).CheckRefISNull()
ClassMethod CheckRefISNull()
{
	s count=0
	s GlobalRowId=""
	for
	{
		s GlobalRowId=$o(^User.MKBGlobalD(GlobalRowId))
		q:GlobalRowId=""
		continue:($d(^User.MKBGlobalReferenceI("InverAllIndex",GlobalRowId,"D"))<=0)
		s RefRowId=0
		for
		{
			s RefRowId=$o(^User.MKBGlobalReferenceI("InverAllIndex",GlobalRowId,"D",RefRowId))    //通过索引表获得引用者的ID
			q:RefRowId=""
			if ($d(^User.MKBTermProDetailD(RefRowId))<=0)		//引用已被删除
			{
				
				s MKBGRRowId=$o(^User.MKBGlobalReferenceI("InverAllIndex",GlobalRowId,"D",RefRowId,""))  //引用表ID
				s PassiveAliasID = $lg($g(^User.MKBGlobalReferenceD(MKBGRRowId)),5)
				if (PassiveAliasID'="")
				{
					s mark=$lg($g(^User.MKBGlobalD(GlobalRowId,"ChildGloAlias",PassiveAliasID)),8)
					s mark=$Replace(mark,",常用诊断表达式","")
					s mark=$Replace(mark,"常用诊断表达式,","")
					s mark=$Replace(mark,"常用诊断表达式","")
					s mark=$Replace(mark,",引用需删除","")
					d ..SaveAliasLog(GlobalRowId, PassiveAliasID, "", "", "", "", "", mark, "")
					s count=count+1
					d ..DeleteReferenceData(MKBGRRowId)
				}
			}
		}
		
	}
	q count
}

/// Creator：钟荣枫
/// CreatDate:2021-8-3  获取全局化词表和预处理表中类目+亚目：A06类目.0亚目，一致的数据
/// Description:
/// Input:baseid
/// w ##class(web.DHCBL.MKB.MKBGlobal).GetTempSearchICDResult()
ClassMethod GetTempSearchICDResult(icd)
{
	k ^TempICDResult
	s:icd="" ^TempICDResult=""
	//先全局化词表，后预处理表
	s GlobalRowId=""
	for
	{
		s GlobalRowId=$o(^User.MKBGlobalD(GlobalRowId))
		q:GlobalRowId=""	
		s RefSD=$o(^User.MKBGlobalReferenceI("InverAllIndex",GlobalRowId,"ICDSD",""))		//数据处理工厂
		s RefCon=$o(^User.MKBGlobalReferenceI("InverAllIndex",GlobalRowId,"ICDCon",""))	//各版本icd
		//ICDCon
		continue:((RefSD="")&&(RefCon=""))
		s continueflag=0
		s RefSD=""		//数据处理工厂
		for
		{
			s RefSD=$o(^User.MKBGlobalReferenceI("InverAllIndex",GlobalRowId,"ICDSD",RefSD))		//数据处理工厂
			q:RefSD=""
			q:continueflag=1
			s ICDCode=$lg($g(^User.MKBStructuredDataD(RefSD)),20)
			if (ICDCode[icd)	//类目+亚目一致
			{
				s ^TempICDResult(1,GlobalRowId)=""	
				s continueflag=1
			}
		}
		s RefCon=""		//各版本icd
		for
		{
			s RefCon=$o(^User.MKBGlobalReferenceI("InverAllIndex",GlobalRowId,"ICDCon",RefCon))	//数据处理工厂
			q:RefCon=""
			q:continueflag=1
			s ICDCode=$lg($g(^User.MKBICDContrastD(RefCon)),2)
			if (ICDCode[icd)	//类目+亚目一致
			{
				s ^TempICDResult(1,GlobalRowId)=""	
				s continueflag=1
			}
		}
		
	}
	s GlobalRowId=""
	for
	{
		s GlobalRowId=$o(^User.MKBHospGlobalD(GlobalRowId))
		q:GlobalRowId=""
		s RefSD=$o(^User.MKBHospGlobalReferenceI("InverAllIndex",GlobalRowId,"ICDSD",""))		//数据处理工厂
		s RefCon=$o(^User.MKBHospGlobalReferenceI("InverAllIndex",GlobalRowId,"ICDCon",""))	//各版本icd
		//ICDCon
		continue:((RefSD="")&&(RefCon=""))
		s continueflag=0
		s RefSD=""		//数据处理工厂
		for
		{
			s RefSD=$o(^User.MKBHospGlobalReferenceI("InverAllIndex",GlobalRowId,"ICDSD",RefSD))		//数据处理工厂
			q:RefSD=""
			q:continueflag=1
			s ICDCode=$lg($g(^User.MKBStructuredDataD(RefSD)),20)
			if (ICDCode[icd)	//类目+亚目一致
			{
				s ^TempICDResult(2,GlobalRowId)=""	
				s continueflag=1
			}
		}
		s RefCon=""		//各版本icd
		for
		{
			s RefCon=$o(^User.MKBHospGlobalReferenceI("InverAllIndex",GlobalRowId,"ICDCon",RefCon))	//数据处理工厂
			q:RefCon=""
			q:continueflag=1
			s ICDCode=$lg($g(^User.MKBICDContrastD(RefCon)),2)
			if (ICDCode[icd)	//类目+亚目一致
			{
				s ^TempICDResult(2,GlobalRowId)=""	
				s continueflag=1
			}
		}
		
	}
	q "OK"
}

/// Creator：
/// CreatDate:
/// Description：ICD查询
/// Table：
/// d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBGlobal","GetICDList","","J37.001","","","")
Query GetICDList(desc, ICDCode As %String, MarkStr As %String, AliasMarkStr As %String, Matchflag) As %Query(ROWSPEC = "MKBGRowId,MKBGDesc,Type")
{
}

ClassMethod GetICDListExecute(ByRef qHandle As %Binary, desc, ICDCode As %String, MarkStr As %String, AliasMarkStr As %String, Matchflag) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		
	s searchcode=$p(ICDCode,".",1)
	s searchcode=searchcode_"."_$e($p(ICDCode,".",2),1)
	s MKBGFreq = ""
    for
    {
	    s MKBGFreq = $o(^User.MKBGlobalI("MKBGFreqIndex",MKBGFreq),-1)
	    q:MKBGFreq=""
	    s MKBGRowId=""
		for
		{
			s MKBGRowId=$o(^User.MKBGlobalI("MKBGFreqIndex",MKBGFreq,MKBGRowId))
			q:MKBGRowId=""
			s RefSD=$o(^User.MKBGlobalReferenceI("InverAllIndex",MKBGRowId,"ICDSD",""))		//数据处理工厂
			s RefCon=$o(^User.MKBGlobalReferenceI("InverAllIndex",MKBGRowId,"ICDCon",""))	//各版本icd
			//ICDCon
			continue:((RefSD="")&&(RefCon=""))
					
			s continueflag=0
			s RefSD=""		//数据处理工厂
			for
			{
				s RefSD=$o(^User.MKBGlobalReferenceI("InverAllIndex",MKBGRowId,"ICDSD",RefSD))		//数据处理工厂
				q:RefSD=""
				q:continueflag=1
				s ICDCode=$lg($g(^User.MKBStructuredDataD(RefSD)),20)
				if (ICDCode[searchcode)	//类目+亚目一致
				{
					s ^TempICDResult(1,MKBGRowId)=""	
					s continueflag=1
				}
			}
			s RefCon=""		//各版本icd
			for
			{
				s RefCon=$o(^User.MKBGlobalReferenceI("InverAllIndex",MKBGRowId,"ICDCon",RefCon))	//数据处理工厂
				q:RefCon=""
				q:continueflag=1
				s ICDCode=$lg($g(^User.MKBICDContrastD(RefCon)),2)
				if (ICDCode[searchcode)	//类目+亚目一致
				{
					s ^TempICDResult(1,MKBGRowId)=""	
					s continueflag=1
				}
			}
			if (continueflag=1)
			{
				s AliasStr=##class(web.DHCBL.MKB.MKBGlobal).GetAliasInfo(MKBGRowId)  //获取别名和别名检索码的拼串
				s AliasDescStr=$p(AliasStr,"||",1)   //别名拼串
				s AliasPYCodeStr=$p(AliasStr,"||",2)   //别名检索码拼串
				s MKBGDesc=$lg($g(^User.MKBGlobalD(MKBGRowId)),3)
				if (($ZCONVERT(MKBGDesc,"U")[desc)||($ZCONVERT(AliasDescStr,"U")[desc))
				{
					
					s Type="全局化词表"
					d OutputRow
				}
				
			}
		}
    }	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(MKBGRowId,MKBGDesc,Type)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetICDListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetICDListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetICDListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetICDListExecute ]
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

/// Creator：钟荣枫
/// CreatDate:2021-8-3 
/// Description: 将全局化词表中未处理的数据导入，或者导入医院在全局化词表中不存在的数据
/// Input:baseid
/// w ##class(web.DHCBL.MKB.MKBGlobal).ImportGlobalData("")
ClassMethod ImportGlobalData(baseid)
{
	s errorflag=0
	s result=""
	d ##class(web.DHCBL.MKB.MKBGlobal).SortGlobal("termsort","","")	
	ts
	s count=0
	//导入医院的数据

	s MKBSTBDesc=$LISTGET($G(^User.MKBStructuredBaseD(baseid)),2)
	s MKBSDRowid=""
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataI("BaseIndex",baseid,MKBSDRowid))
		q:MKBSDRowid=""
		//continue:($d(^TempUnsave(MKBSDRowid))>0)
		s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)  //诊断描述
		s MKBSDIcd=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),20)		//icd
		s SumLoc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),13)
		s:SumLoc="" SumLoc=0
		s NewDesc=""
		s NewDesc = ##class(web.DHCBL.BDP.FunLib).AutoSBDB(MKBSDDiag,0)		//全角转半角
		s NewDesc=..SpaceHandleMethod1(NewDesc)
		s NewDesc=..SpaceHandleMethod2(NewDesc)
		s NewDesc=..SpaceHandleMethod3(NewDesc)
		s MatchGlobal=$o(^User.MKBGloAliasI("NameIndex"," "_$ZCONVERT(NewDesc,"U"),0))
		s count=count+1
		w !,count
		if (MatchGlobal="")	//不能够匹配上
		{
			
			s bobj = ##class(web.Entity.MKB.MKBGlobal).%New()
			s bobj.MKBGDesc = NewDesc
			s bobj.MKBGMark = "常用诊断描述"
			s bobj.MKBGDiaTotalFreq=SumLoc
			s gre= ..SaveGlobalEntity(bobj)
			if (gre'["false")
			{
				s GRowId=$p($p(gre,":",3),"}",1)
				s abobj = ##class(web.Entity.MKB.MKBGloAlias).%New()
				s abobj.MKBGAParRef=GRowId
				s abobj.MKBGADesc=NewDesc
				s abobj.MKBGASequence="1"
				s abobj.MKBGAMark="展示名,查询名,"_$Replace(MKBSTBDesc,"数据处理工厂","预处理")
				s abobj.MKBGACEFlag="C"
				s abobj.IsDisplayName="Y"
				 	
				s are= ..SaveAliasEntity(abobj)
				if (are["false")
				{
					s errorflag=1
				}
				else
				{
					s NewPassiveAliasID=$p(are,"'",4)
					s:NewPassiveAliasID["||" NewPassiveAliasID=$p(NewPassiveAliasID,"||",2)

					s rbobj = ##class(web.Entity.MKB.MKBGlobalReference).%New()
					s rbobj.InitiativeFlag="ICDSD"				//发起引用，主动引用标识
					s rbobj.InitiativeID=MKBSDRowid				//发起引用词的ID
					s rbobj.PassiveID=GRowId				//被引用词的ID
					s rbobj.PassiveAliasID=NewPassiveAliasID			//被引用词的名称列表ID
					s rre=..SaveReferenceEntity(rbobj)
					s:rre["false" errorflag=1
					if (errorflag=1)
					{
						b ;3
					}	
				}

				
			}
		}
		else	//存在其他术语
		{
			//Index DescIndex On (ParRef As Exact, MKBGADesc);
			s GlobalAlias=$o(^User.MKBGloAliasI("DescIndex",MatchGlobal," "_$ZCONVERT(NewDesc,"U"),""))
			if (GlobalAlias'="")
			{
				s MKBGAMark = $lg($g(^User.MKBGlobalD(MatchGlobal,"ChildGloAlias",GlobalAlias)),8)
				if (MKBGAMark'[MKBSTBDesc)
				{
					s MKBGAMark=MKBGAMark_","_MKBSTBDesc
					//SaveAliasLog(parref, AliasRowId, desc, note, activeflag, state, seq, mark, display)
					d ##class(web.DHCBL.MKB.MKBGlobal).SaveAliasLog(MatchGlobal,GlobalAlias,"", "", "", "", "", MKBGAMark, "")
				}
			}
			
		}
				
	}
	
	if (errorflag=1)
	{
		tro
		s result="false"	
	}
	else
	{
		s result="true"
		//tc	
	}
	q result
}

/// Creator：钟荣枫
/// CreatDate:2021-9-1
/// Description: 全局化词表引用、预处理表引用，别名id应该是不带有“||”的
/// Input:
/// w ##class(web.DHCBL.MKB.MKBGlobal).HandleAliasID()
ClassMethod HandleAliasID()
{
	s result=""
	s errorflag=0
	ts
	s RefRowID=""
	for
	{
		s RefRowID=$o(^User.MKBGlobalReferenceD(RefRowID))
		q:RefRowID=""
		q:errorflag=1
		s PassiveAliasID = $lg($g(^User.MKBGlobalReferenceD(RefRowID)),5)
		if (PassiveAliasID["||")
		{
			s obj=##class(User.MKBGlobalReference).%OpenId(RefRowID)
			s bobj = ##class(web.Entity.MKB.MKBGlobalReference).%New()
			s bobj.MKBGRRowid = RefRowID
			
			s bobj.InitiativeFlag=obj.InitiativeFlag				//发起引用，主动引用标识
			s bobj.InitiativeID=obj.InitiativeID				//发起引用词的ID
			s bobj.PassiveID=obj.PassiveID				//被引用词的ID
			s bobj.PassiveAliasID=$p(PassiveAliasID,"||",2)				//被引用词的名称列表ID
			d obj.%Close()
			s re= ..SaveReferenceEntity(bobj)
			if (re["false")
			{
				if (re["存在")
				{
					d ..DeleteReferenceData(RefRowID)
				}
				else
				{
					s errorflag=1
					b ;1
				}
				
			}
			
		}
	}
	
	s RefRowID=""
	for
	{
		s RefRowID=$o(^User.MKBHospGlobalReferenceD(RefRowID))
		q:RefRowID=""
		q:errorflag=1
		s PassiveAliasID = $lg($g(^User.MKBHospGlobalReferenceD(RefRowID)),5)
		if (PassiveAliasID["||")
		{
			s obj=##class(User.MKBHospGlobalReference).%OpenId(RefRowID)
			s bobj = ##class(web.Entity.MKB.MKBHospGlobalReference).%New()
			s bobj.MKBGRRowid = RefRowID
			
			s bobj.InitiativeFlag=obj.InitiativeFlag				//发起引用，主动引用标识
			s bobj.InitiativeID=obj.InitiativeID				//发起引用词的ID
			s bobj.PassiveID=obj.PassiveID				//被引用词的ID
			s bobj.PassiveAliasID=$p(PassiveAliasID,"||",2)				//被引用词的名称列表ID
			d obj.%Close()
			s re= ##class(web.DHCBL.MKB.MKBHospGlobal).SaveReferenceEntity(bobj)
			if (re["false")
			{
				if (re["存在")
				{
					d ##class(web.DHCBL.MKB.MKBHospGlobal).DeleteReferenceData(RefRowID)
				}
				else
				{
					s errorflag=1
				}

				
			}
			
		}
	}
	if (errorflag=1)
	{
		tro
		s result="false"	
	}
	else
	{
		tc
		s result="true"	
	}
	q result
}

}
