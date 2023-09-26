/// Creator:丁亚男
/// CreatDate:2021-09-02
/// Description：医用知识库诊断属性类
/// Table：CT.WDT.CDSS.TermProperty
Class web.CDSS.CMKB.TermProperty Extends %RegisteredObject
{

/// Creator：丁亚男
/// CreatDate: 2021-09-02
/// Description：查询诊断属性父表内容
/// Table：CT.WDT.CDSS.TermProperty
/// Input：rowid, code, desc
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.TermProperty","GetList","","15805","")
Query GetList(rowid, termdr, desc) As %Query(ROWSPEC = "MKBTPRowId,MKBTPDesc,MKBTPDDesc,MKBTPType,MKBTPTermDr,MKBTPConfig,MKBTPName,MKBTPFlag,MKBTPPublic,MKBTPDefinedNode,MKBTPSequence,MKBTPDDescCount,MKBTPDDescF,MKBTPCodeRules")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, termdr, desc) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s MKBTPRowId=rowid
		s MKBTPDesc=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),3)
		//s MKBTPDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPDesc)
		s MKBTPType=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),4)
		
		s MKBTPDDescF=""
		s MKBTPDDesc=""
		if (MKBTPType="SD")
		{
			s MKBTPDDesc=..GetALLDetail(MKBTPType,MKBTPRowId)  //属性内容
			//s MKBTPDDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPDDesc)
			s MKBTPDDescF=MKBTPDDesc
			s MKBTPDDesc=##class(web.CDSS.CMKB.MKBKnoExpression).GetDiagDesc(MKBTPDDesc)	
		}
		elseif (MKBTPType="SS")
		{
			if ($d(^CT.WDT.CDSS.TermProDetailI("ProIdx",MKBTPRowId))){
	        	s MKBTPDRowId=$o(^CT.WDT.CDSS.TermProDetailI("ProIdx",MKBTPRowId,0)) 
	        	s MKBTPDDescF=$listGet($g(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),3)  //术语条目id
	       		s MKBTPDDesc=..GetALLDetail(MKBTPType,MKBTPRowId)  //属性内容
        	}
		}
		
		else
		{
			s MKBTPDDesc=..GetALLDetail(MKBTPType,MKBTPRowId)  //属性内容
			//s MKBTPDDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPDDesc)	
		}
		s MKBTPTermDr=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),6)
		s Config=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),5)
		if (MKBTPType="R")||(MKBTPType="CB")||(MKBTPType="C")||(MKBTPType="M")||(MKBTPType="SS")
		{
			s MKBTPConfig=Config
		}
		else
		{
			s:Config'="" MKBTPConfig=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(Config)),3)
			s:Config="" MKBTPConfig=""
		}
		/*if (MKBTPType="M") 
		{
			s:Config'="" MKBTPConfig=##class(web.CDSS.CMKB.MKBKLMappingBase).GetDesc(Config)
			s:Config="" MKBTPConfig=""	
		}*/
		s MKBTPName=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),7)
		//s MKBTPName=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPName)
		s MKBTPFlag=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),8)
		s MKBTPPublic=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),9)
		s MKBTPDefinedNode=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),10)
		s:MKBTPDefinedNode'="" MKBTPDefinedNode=$LISTGET($G(^CT.WDT.CDSS.TermD(MKBTPDefinedNode)),3)
		s MKBTPSequence=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),11)
		s MKBTPDDescCount=..GetDetailCount(MKBTPType,MKBTPRowId)  //属性内容数量
		s MKBTPCodeRules=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),12)
		d OutputRow
	}
	else
	{
		if (termdr'=""){
			s:desc'="" desc=$ZCONVERT(desc,"U")
			//输出中心词、检索码、备注、上级节点
			s MKBTDesc=$listGet($g(^CT.WDT.CDSS.TermD(termdr)),3)  //描述
			//s MKBTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTDesc)
			s MKBTDescU=$ZCONVERT(MKBTDesc,"U")
			s MKBTLastLevel=$listGet($g(^CT.WDT.CDSS.TermD(termdr)),5)  //上级节点
			s MKBTPYCode=$listGet($g(^CT.WDT.CDSS.TermD(termdr)),6)  //检索码
			//s MKBTPYCode=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPYCode)
			s MKBTPYCodeU=$ZCONVERT(MKBTPYCode,"U")
			s MKBTNote=$listGet($g(^CT.WDT.CDSS.TermD(termdr)),7)  //备注
			//s MKBTNote=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTNote)
			s MKBTBaseDR=$listGet($g(^CT.WDT.CDSS.TermD(termdr)),4)  //术语库注册的id 
			s MKBTBType=$listget($g(^CT.WDT.CDSS.TermBaseD(MKBTBaseDR)),4)
			if ("中心词"[desc)||("ZXC"[desc) 
			{
				s MKBTPRowId="MKBTDesc"_"-"_termdr
				s MKBTPDesc="中心词"
				s MKBTPType="TX"
				s MKBTPDDesc=MKBTDesc
				s MKBTPPublic="Y"
				d OutputRow	
			}
			if ("检索码"[desc)||("JSM"[desc) 
			{
				s MKBTPRowId="MKBTPYCode"_"-"_termdr
				s MKBTPDesc="检索码"
				s MKBTPType="TX"
				s MKBTPDDesc=MKBTPYCode
				s MKBTPPublic="Y"
				d OutputRow	
			}
			if (MKBTBType="T")
			{
				if ("上级节点"[desc)||("SJJD"[desc) 
				{
					s MKBTPRowId="MKBTLastLevel"_"-"_termdr
					s MKBTPDesc="上级节点"
					s MKBTPType="SS"
					s MKBTPDDescF=MKBTLastLevel
					s MKBTPDDesc=""
					s:MKBTLastLevel'="" MKBTPDDesc=$listGet($g(^CT.WDT.CDSS.TermD(MKBTLastLevel)),3)
					s MKBTPConfig=MKBTBaseDR
					s MKBTPPublic="Y"
					d OutputRow	
				}
			}
			if ("备注"[desc)||("BZ"[desc) 
			{
				s MKBTPRowId="MKBTNote"_"-"_termdr
				s MKBTPDesc="备注"
				s MKBTPType="TA"
				s MKBTPDDesc=MKBTNote
				s MKBTPPublic="Y"
				s MKBTPConfig=""
				s MKBTPDDescF=""
				d OutputRow	
			}
			
			// 公有按照 知识库注册的顺序取，私有属性按照现有的顺序
			k myArray
			s MKBTPRowId=0
			for 
			{
				s MKBTPRowId=$o(^CT.WDT.CDSS.TermPropertyI("TermIndex",termdr,MKBTPRowId)) q:MKBTPRowId="" 
				s MKBTPDesc=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),3)
				s MKBTPDescU=$ZCONVERT(MKBTPDesc,"U")
				s MKBTBaseDR=$LISTGET($G(^CT.WDT.CDSS.TermD(termdr)),4)
				s MKBTPSequence=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),11)
				if ($d(^CT.WDT.CDSS.TermBasePropertyI("DescIndex",MKBTBaseDR)))&($d(^CT.WDT.CDSS.TermBasePropertyI("DescIndex",MKBTBaseDR," "_MKBTPDescU)))
				{
					s MKBTBPRowId=$o(^CT.WDT.CDSS.TermBasePropertyI("DescIndex",MKBTBaseDR," "_MKBTPDescU,""))
					s MKBTBPSequence=0
					s:MKBTBPRowId'="" MKBTBPSequence=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(MKBTBPRowId)),9)
					s myArray(MKBTBPSequence,MKBTPRowId)=""
				}
				else
				{
					s myArray(MKBTPSequence,MKBTPRowId)=""	
					
				}		
			}
			
			
			
			
			/*//输出属性 按照顺序取数据	
			s MKBTPSequence=""
			for  
			{	
				s MKBTPSequence=$o(^CT.WDT.CDSS.TermPropertyI("SeqIndex",termdr,MKBTPSequence)) q:MKBTPSequence=""
				s MKBTPRowId=0
				for 
				{
					s MKBTPRowId=$o(^CT.WDT.CDSS.TermPropertyI("SeqIndex",termdr,MKBTPSequence,MKBTPRowId)) q:MKBTPRowId="" */
			//输出属性 按照排序好的公私有属性数据取数据
			s MKBTPSequence=0
			for  
			{	
				s MKBTPSequence=$o(myArray(MKBTPSequence)) q:MKBTPSequence=""
				
				s MKBTPRowId=0
				for 
				{
					s MKBTPRowId=$o(myArray(MKBTPSequence,MKBTPRowId)) q:MKBTPRowId=""
					
					s MKBTPDesc=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),3)
					//s MKBTPDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPDesc)
					s MKBTPDescU=$ZCONVERT(MKBTPDesc,"U")
					s MKBTPType=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),4)
					
					s MKBTPDDescF=""
					s MKBTPDDesc=""
					if (MKBTPType="SD")
					{
						s MKBTPDDesc=..GetALLDetail(MKBTPType,MKBTPRowId)  //属性内容
						//s MKBTPDDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPDDesc)
						s MKBTPDDescF=MKBTPDDesc
						s MKBTPDDesc=##class(web.CDSS.CMKB.MKBKnoExpression).GetDiagDesc(MKBTPDDesc)	
					}
					elseif (MKBTPType="SS")
					{
						if ($d(^CT.WDT.CDSS.TermProDetailI("ProIdx",MKBTPRowId))){
				        	s MKBTPDRowId=$o(^CT.WDT.CDSS.TermProDetailI("ProIdx",MKBTPRowId,0)) 
				        	s MKBTPDDescF=$listGet($g(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),3)  //术语条目id
				       		s MKBTPDDesc=..GetALLDetail(MKBTPType,MKBTPRowId)  //属性内容
			        	}
					}
					elseif (MKBTPType="M")
					{
				       	s MKBTPDDesc=..GetDetailForMPro(MKBTPRowId)  //属性内容
					}
					else
					{
						s MKBTPDDesc=..GetALLDetail(MKBTPType,MKBTPRowId)  //属性内容
						//s MKBTPDDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPDDesc)	
					}
					s MKBTPTermDr=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),6)
					s Config=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),5)
					if (MKBTPType="R")||(MKBTPType="CB")||(MKBTPType="C")||(MKBTPType="M")||(MKBTPType="SS")
					{
						s MKBTPConfig=Config
					}
					else
					{
						s:Config'="" MKBTPConfig=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(Config)),3)
						s:Config="" MKBTPConfig=""
					}
	        
					s MKBTPName=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),7)
					//s MKBTPName=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPName)
					s MKBTPFlag=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),8)
					s MKBTPPublic=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),9)
					s MKBTPDefinedNode=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),10)
					s:MKBTPDefinedNode'="" MKBTPDefinedNode=$LISTGET($G(^CT.WDT.CDSS.TermD(MKBTPDefinedNode)),3)
					s MKBTPCodeRules=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),12)
					//s MKBTPSequence=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),11)
					s MKBTPDDescCount=..GetDetailCount(MKBTPType,MKBTPRowId)  //属性内容数量
					
					if (desc'="")
					{
						s PINYIN=""
						s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBTPDescU)
						i ((MKBTPDescU[desc)||(PINYIN[desc))   //条件
						{
							d OutputRow
						}
					}
					else
					{
						d OutputRow	
					}		
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(MKBTPRowId,MKBTPDesc,MKBTPDDesc,MKBTPType,MKBTPTermDr,MKBTPConfig,MKBTPName,MKBTPFlag,MKBTPPublic,MKBTPDefinedNode,MKBTPSequence,MKBTPDDescCount,MKBTPDDescF,MKBTPCodeRules)
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

/// Function:获取明细，列表型显示第一列的数据，树形只显示第一级，文本显示文本。最多显示12个字符。后面。。。显示。
/// Creator:丁亚男
/// CreateDate:2018-4-16    
/// Input：MKBTPType 属性格式  MKBTPRowId 属性(术语库大类)id 
/// w ##class(web.CDSS.CMKB.TermProperty).GetDetailCount("S",31222)
ClassMethod GetDetailCount(MKBTPType As %String, MKBTPRowId As %String) As %String
{
    
    q:(MKBTPType="")||(MKBTPRowId="") ""
    
    s count=0  //明细数量
    if (MKBTPType="L")  //列表型显示第一列的数据||(MKBTPType="F")||(MKBTPType="TA")||(MKBTPType="TX")
    {
        s MKBTPDRowId=0
        for  
        {   
            s MKBTPDRowId=$o(^CT.WDT.CDSS.TermProDetailI("ProIdx",MKBTPRowId,MKBTPDRowId)) q:MKBTPDRowId="" 
            s count=count+1
        }
    }
    if ((MKBTPType="R")||(MKBTPType="CB")||(MKBTPType="C")||(MKBTPType="TA")||(MKBTPType="TX")||(MKBTPType="SD"))
    {  
        s count=1
	}
    if (MKBTPType="T") //树形只显示第一级
    {
        s LastLevel=-100000000000000
        s MKBTPDRowId=0
        for {
            s MKBTPDRowId=$o(^CT.WDT.CDSS.TermProDetailI("ProParIndex",MKBTPRowId,LastLevel,MKBTPDRowId)) q:(MKBTPDRowId="")
            s count=count+1
        }
    }

    if (MKBTPType="S") //引用术语  引用属性 数据来源格式就显示内容
    {
        s MKBTPDRowId=0
        for{
        	s MKBTPDRowId=$o(^CT.WDT.CDSS.TermProDetailI("ProIdx",MKBTPRowId,MKBTPDRowId)) q:MKBTPDRowId=""
        	s count=count+1
        }
        
    }
   if (MKBTPType="P")
   {
	   s MKBTPDRowId=$o(^CT.WDT.CDSS.TermProDetailI("ProIdx",MKBTPRowId,0))   //属性明细表ID
        s descStr=""
        s:MKBTPDRowId'="" descStr=$listGet($g(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),3) //属性内容
        if (descStr'="")
        {
            s argsLen=$Length(descStr,",")
            s count=argsLen
        }
	   
	}
	
    q count
}

/// Function:获取明细，列表型显示第一列的数据，树形只显示第一级，文本显示文本。最多显示12个字符。后面。。。显示。
/// Creator:丁亚男
/// CreateDate:2018-4-16    
/// Input：MKBTPType 属性格式  MKBTPRowId 属性(术语库大类)id 
/// w ##class(web.CDSS.CMKB.TermProperty).GetDetail("S",31222)
ClassMethod GetDetail(MKBTPType As %String, MKBTPRowId As %String) As %String
{
    
    q:(MKBTPType="")||(MKBTPRowId="") ""
    
    s Detail=""  //明细
    if ((MKBTPType="L")||(MKBTPType="F")||(MKBTPType="TA")||(MKBTPType="TX")||(MKBTPType="SD")||(MKBTPType="ETX"))  //列表型显示第一列的数据
    {
        s MKBTPDRowId=0
        for  
        {   
            s MKBTPDRowId=$o(^CT.WDT.CDSS.TermProDetailI("ProIdx",MKBTPRowId,MKBTPDRowId)) q:MKBTPDRowId="" 
            s MKBTPDDesc=$listGet($g(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),3)  //描述
            s:Detail'="" Detail=Detail_","_MKBTPDDesc
            s:Detail="" Detail=MKBTPDDesc
            if ($l(Detail)>12)
            {
                 s Detail=$e(Detail,1,12)_"..."
                 s Detail=##class(web.DHCBL.BDP.FunLib).EvalJSONB(Detail)
                 q
            }
        }
    }
    if ((MKBTPType="R")||(MKBTPType="CB")||(MKBTPType="C"))
    {  
        if ($d(^CT.WDT.CDSS.TermProDetailI("ProIdx",MKBTPRowId))){
	        s MKBTPDRowId=$o(^CT.WDT.CDSS.TermProDetailI("ProIdx",MKBTPRowId,0)) 
	        s MKBTPDDesc=$listGet($g(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),3)  //描述
	        s:Detail'="" Detail=Detail_","_MKBTPDDesc
		    s:Detail="" Detail=MKBTPDDesc
	        
	        if ($l(Detail)>12)
	        {
	             s Detail=$e(Detail,1,12)_"..."
	             q
	        } 
        }
	}
    if (MKBTPType="T") //树形只显示第一级
    {
        s LastLevel=-100000000000000
        s MKBTPDRowId=0
        for {
            s MKBTPDRowId=$o(^CT.WDT.CDSS.TermProDetailI("ProParIndex",MKBTPRowId,LastLevel,MKBTPDRowId))
            q:(MKBTPDRowId="")
            s MKBTPDDesc=$listGet($g(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),3)  //描述
            s:Detail'="" Detail=Detail_","_MKBTPDDesc
            s:Detail="" Detail=MKBTPDDesc
            if ($l(Detail)>12)
            {
                 s Detail=$e(Detail,1,12)_"..."
                 q
            }
            
        }
    }

    if (MKBTPType="S") //引用术语 数据来源格式就显示内容
    {
        s DATSOU=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),5)
        s MKBTBType=""  
        s:DATSOU'="" MKBTBType=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(DATSOU)),4)  //术语库注册-类型（树形、或者列表型）
        
    	s MKBTPDRowId=0
    	for{
        	s MKBTPDRowId=$o(^CT.WDT.CDSS.TermProDetailI("ProIdx",MKBTPRowId,MKBTPDRowId)) q:MKBTPDRowId=""
        	s descid=$listGet($g(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),3)
       		s desc1=""
       		s:descid'="" desc1=$listGet($g(^CT.WDT.CDSS.TermD(descid)),3)
            s:Detail'="" Detail=Detail_","_desc1
            s:Detail="" Detail=desc1
         
            if ($l(Detail)>12)
            {
                 s Detail=$e(Detail,1,12)_"..."
                 q
            }
    	}
        
    }
    if (MKBTPType="P") //引用属性型
    {
        s MKBTPDRowId=$o(^CT.WDT.CDSS.TermProDetailI("ProIdx",MKBTPRowId,0))   //属性明细表ID
        s descStr=""
        s:MKBTPDRowId'="" descStr=$listGet($g(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),3) //属性内容
        if (descStr'="")
        {
            s argsLen=$Length(descStr,",")
            for i=1:1:argsLen   
            {     
                s descAndType=$p(descStr,",",i)  //术语属性id&展示类型
                s MKBTPRowId=$p(descAndType,"&",1)  //术语属性id
                s MKBTPDesc=$listget($g(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),3)  //术语属性描述
                s:Detail'="" Detail=Detail_","_MKBTPDesc
                s:Detail="" Detail=MKBTPDesc
                if ($l(Detail)>12)
                {
                     s Detail=$e(Detail,1,12)_"..."
                     q
                }
            }
        }
    }
	 if (MKBTPType="SS")
    {  
        if ($d(^CT.WDT.CDSS.TermProDetailI("ProIdx",MKBTPRowId))){
	        s MKBTPDRowId=$o(^CT.WDT.CDSS.TermProDetailI("ProIdx",MKBTPRowId,0)) 
	        s MKBTermDR=$listGet($g(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),3)  //术语条目id
	        s MKBTDesc=$listGet($g(^CT.WDT.CDSS.TermD(MKBTermDR)),3)  //术语条目描述
	        s MKBTLastLevel=$listGet($g(^CT.WDT.CDSS.TermD(MKBTermDR)),5)  //术语条目上级节点
	        s:MKBTLastLevel'="" Detail=..GetLastLevelDesc(MKBTDesc,MKBTLastLevel)
	        s:MKBTLastLevel="" Detail=MKBTDesc
	        if ($l(Detail)>12)
            {
                 s Detail=$e(Detail,1,12)_"..."
            }
        }
	}
    q Detail
}

/// Function:获取知识表达式类型的配置项（basedr）
/// Creator:丁亚男
/// CreateDate:2018-5-16    
/// Input  MKBTPRowId 属性(术语库大类)id 
/// w ##class(web.CDSS.CMKB.TermProperty).GetSDBaseDR(26326)
ClassMethod GetSDBaseDR(MKBTPRowId As %String) As %String
{
    
    q:(MKBTPRowId="") ""
    
    s Config=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),5)
    q Config
}

/// Function:获取文本、多行文本框、单选框、复选框、下拉框的属性内容明细
/// Creator:丁亚男
/// CreateDate:2018-5-16    
/// Input：MKBTPType 属性格式  MKBTPRowId 属性(术语库大类)id 
/// w ##class(web.CDSS.CMKB.TermProperty).GetOtherTypeDetail(26326)
ClassMethod GetOtherTypeDetail(MKBTPRowId As %String) As %String
{
    
    q:(MKBTPRowId="") ""
    
    s Detail=""  //明细
    s MKBTPType=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),4)
    if ($d(^CT.WDT.CDSS.TermProDetailI("ProIdx",MKBTPRowId))){
        s MKBTPDRowId=$o(^CT.WDT.CDSS.TermProDetailI("ProIdx",MKBTPRowId,0)) 
        s MKBTPDDesc=$listGet($g(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),3)  //描述
        if (MKBTPType="SD")
        {
	        s MKBTPDDesc=##class(web.CDSS.CMKB.MKBKnoExpression).GetDiagDesc(MKBTPDDesc)
	        }
        s:Detail'="" Detail=Detail_","_MKBTPDDesc
	    s:Detail="" Detail=MKBTPDDesc
        
    }
    q Detail
}

/// Function:获取文本、多行文本框、单选框、复选框、下拉框的属性内容明细,不省略显示
/// Creator:丁亚男
/// CreateDate:2018-5-16    
/// Input：MKBTPType 属性格式  MKBTPRowId 属性(术语库大类)id 
/// w ##class(web.CDSS.CMKB.TermProperty).GetALLDetail("CB",8769191)
ClassMethod GetALLDetail(MKBTPType As %String, MKBTPRowId As %String) As %String
{
    
    q:(MKBTPType="")||(MKBTPRowId="") ""
    
    s Detail=""  //明细
    if (MKBTPRowId["MKBT")
	{
		s desc=$p(MKBTPRowId,"-",1)	
		s termdr=$p(MKBTPRowId,"-",2)
		if (desc="MKBTDesc")
	    {
			s Detail = $listGet($g(^CT.WDT.CDSS.TermD(termdr)),3)  //描述
	    }
	    elseif(desc="MKBTPYCode")
	    {
			s Detail = $listGet($g(^CT.WDT.CDSS.TermD(termdr)),6)  //描述  
		}
		elseif(desc="MKBTLastLevel")
	    {
			s Detail= $listGet($g(^CT.WDT.CDSS.TermD(termdr)),5)  //上级节点  
		}
		elseif(desc="MKBTNote")
	    {
			s Detail = $listGet($g(^CT.WDT.CDSS.TermD(termdr)),7)  //上级节点   
		}
		
	}
	else
	{
	    if ((MKBTPType="L")||(MKBTPType="F"))  //列表型显示第一列的数据
	    {
	        s MKBTPDRowId=0
	        for  
	        {   
	            s MKBTPDRowId=$o(^CT.WDT.CDSS.TermProDetailI("ProIdx",MKBTPRowId,MKBTPDRowId)) q:MKBTPDRowId="" 
	            s MKBTPDDesc=$listGet($g(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),3)  //描述
	            s:Detail'="" Detail=Detail_","_MKBTPDDesc
	            s:Detail="" Detail=MKBTPDDesc

	        }
	    }
	    
	    elseif (MKBTPType="T") //树形只显示第一级
	    {
	        s LastLevel=-100000000000000
	        s MKBTPDRowId=0
	        for {
	            s MKBTPDRowId=$o(^CT.WDT.CDSS.TermProDetailI("ProParIndex",MKBTPRowId,LastLevel,MKBTPDRowId))
	            q:(MKBTPDRowId="")
	            s MKBTPDDesc=$listGet($g(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),3)  //描述
	            s:Detail'="" Detail=Detail_","_MKBTPDDesc
	            s:Detail="" Detail=MKBTPDDesc
	           
	        }
	    }

	    elseif (MKBTPType="S") //引用术语 数据来源格式就显示内容
	    {
	        s DATSOU=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),5)
	        s MKBTBType=""  
	        s:DATSOU'="" MKBTBType=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(DATSOU)),4)  //术语库注册-类型（树形、或者列表型）
	        
	    	s MKBTPDRowId=0
	    	for{
	        	s MKBTPDRowId=$o(^CT.WDT.CDSS.TermProDetailI("ProIdx",MKBTPRowId,MKBTPDRowId)) q:MKBTPDRowId=""
	        	s descid=$listGet($g(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),3)
	       		s desc1=""
	       		s:descid'="" desc1=$listGet($g(^CT.WDT.CDSS.TermD(descid)),3)
	            s:Detail'="" Detail=Detail_","_desc1
	            s:Detail="" Detail=desc1
	            
	    	}
	        
	    }
	    elseif (MKBTPType="P") //引用属性型
	    {
	        s MKBTPDRowId=$o(^CT.WDT.CDSS.TermProDetailI("ProIdx",MKBTPRowId,0))   //属性明细表ID
	        s descStr=""
	        s:MKBTPDRowId'="" descStr=$listGet($g(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),3) //属性内容
	        if (descStr'="")
	        {
	            s argsLen=$Length(descStr,",")
	            for i=1:1:argsLen   
	            {     
	                s descAndType=$p(descStr,",",i)  //术语属性id&展示类型
	                
	                s MKBTPRowId=$p(descAndType,"&",1)  //术语属性id
	                s MKBTPDesc=$listget($g(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),3)  //术语属性描述
	                /*s MKBTFlag=$p(descAndType,"&",6)  //术语属性标识
	                if (MKBTFlag="P")
	                {
	                	s MKBTPDesc=$listget($g(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),3)  //术语属性描述
	                }
	                else 
	                {
		                s MKBTPDesc=$listget($g(^CT.WDT.CDSS.TermBaseD(MKBTPRowId)),3)  //术语属性描述
		             }*/
	                s:Detail'="" Detail=Detail_","_MKBTPDesc
	                s:Detail="" Detail=MKBTPDesc
	         
	            }
	        }
	    }
	    elseif ((MKBTPType="TA")||(MKBTPType="TX")||(MKBTPType="SD")||(MKBTPType="ETX"))  //列表型显示第一列的数据
	    {
	        s MKBTPDRowId=0
	        for  
	        {   
	            s MKBTPDRowId=$o(^CT.WDT.CDSS.TermProDetailI("ProIdx",MKBTPRowId,MKBTPDRowId)) q:MKBTPDRowId="" 
	            s MKBTPDDesc=$listGet($g(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),3)  //描述
	            s:Detail'="" Detail=Detail_","_MKBTPDDesc
	            s:Detail="" Detail=MKBTPDDesc
	            s Detail = ##class(web.CDSS.CMKB.FunLib).TransLinefeed(Detail,"G")
	            //s Detail=..EvalJSON(Detail)
	        }
	    }
	    
	    elseif ((MKBTPType="R")||(MKBTPType="CB")||(MKBTPType="C"))
	    {  
	        if ($d(^CT.WDT.CDSS.TermProDetailI("ProIdx",MKBTPRowId))){
		        s MKBTPDRowId=$o(^CT.WDT.CDSS.TermProDetailI("ProIdx",MKBTPRowId,0)) 
		        s MKBTPDDesc=$listGet($g(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),3)  //描述
		        /*s len=0
		        s len=$length(MKBTPDDesc,",")
		        for i=1:1:len
		        {
			        s DDesc=..GetConfigName(MKBTPRowId,i) 
			        s:Detail'="" Detail=Detail_","_DDesc
			        s:Detail="" Detail=DDesc
		        }*/
		        s:Detail'="" Detail=Detail_","_MKBTPDDesc
			    s:Detail="" Detail=MKBTPDDesc
		        
	        }
		}
	    elseif (MKBTPType="SS")
	    {  
	        if ($d(^CT.WDT.CDSS.TermProDetailI("ProIdx",MKBTPRowId))){
		        s MKBTPDRowId=$o(^CT.WDT.CDSS.TermProDetailI("ProIdx",MKBTPRowId,0)) 
		        s MKBTermDR=$listGet($g(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),3)  //术语条目id
		        s MKBTDesc=$listGet($g(^CT.WDT.CDSS.TermD(MKBTermDR)),3)  //术语条目描述
		        s MKBTLastLevel=$listGet($g(^CT.WDT.CDSS.TermD(MKBTermDR)),5)  //术语条目上级节点
		        s:MKBTLastLevel'="" Detail=..GetLastLevelDesc(MKBTDesc,MKBTLastLevel)
		        s:MKBTLastLevel="" Detail=MKBTDesc
			    
	        }
		}
		elseif (MKBTPType="M")
		{
	       	s Detail=..GetDetailForMPro(MKBTPRowId)  //属性内容
		}
	}
    q Detail
}

/// Creator：丁亚男
/// CreatDate: 2019-01-04
/// Table：CT.WDT.CDSS.Term
/// Description：获取树形术语的子节点及父节点的描述串
/// Input：MKBTDesc:拼接的描述,MKBTLastLevel:术语条目id
/// Return：树形术语的子节点及父节点的描述串
/// Other:w ##class(web.CDSS.CMKB.TermProperty).GetLastLevelDesc("","Drug")
ClassMethod GetLastLevelDesc(MKBTDesc As %String, MKBTLastLevel As %String) As %String
{
   s MKBTDDesc=MKBTDesc
   s MKBTDesc1=$listGet($g(^CT.WDT.CDSS.TermD(MKBTLastLevel)),3)  //术语条目描述
   s MKBTLastLevel1=$listGet($g(^CT.WDT.CDSS.TermD(MKBTLastLevel)),5)  //术语条目上级节点
   s MKBTDDesc=MKBTDDesc_"-"_MKBTDesc1
   s:MKBTLastLevel1'="" Detail=..GetLastLevelDesc(MKBTDDesc,MKBTLastLevel1)
   s:MKBTLastLevel1="" Detail=MKBTDDesc
   q Detail
}

/// Creator：丁亚男
/// CreatDate: 2018-3-29
/// Table：CT.WDT.CDSS.TermProperty
/// Description：数据标识重复验证方法
/// Input：id, code:标识,termdr:术语id
/// Return："1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.CDSS.CMKB.TermProperty).ValidateFlag("","Drug")
ClassMethod ValidateFlag(id As %String, code As %String, termdr As %String) As %String
{
   s:code'="" code=$ZCONVERT(code,"U") //转换成大写
   s flag="",flagc=""
   s:code'="" flagc=$d(^CT.WDT.CDSS.TermPropertyI("FlagIndex",termdr," "_code))
   if (id="") //如果为空，增加时的重复判断
   {
     if (flagc>0) s flag=1  //返回重复标志
     else  s flag=0 //返回不重复标志
   }
  else //如果不为空，修改时的重复判断
  {
   s idc=""
   s:code'="" idc=$o(^CT.WDT.CDSS.TermPropertyI("FlagIndex",termdr," "_code,0))
   if ((idc'=id)&(flagc>0)) s flag=1  //返回重复标志
   else  s flag=0 //返回不重复标志
  }
 q flag
}

/// Creator：丁亚男
/// CreatDate: 2018-3-29
/// Table：CT.WDT.CDSS.TermProperty
/// Description:用于实现数据校验功能的方法  
/// Return："1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.CDSS.CMKB.TermProperty).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String, termdr As %String, CodeRules As %String) As %String
{
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s:CodeRules'="" CodeRules=$ZCONVERT(CodeRules,"U") //转换成大写
	s flag="",flagc="",flagd="",flage=""
	s:code'="" flagc=$d(^CT.WDT.CDSS.TermPropertyI("CodeIndex",termdr," "_code))
	s:desc'="" flagd=$d(^CT.WDT.CDSS.TermPropertyI("DescIndex",termdr," "_desc))
	s:CodeRules'="" flage=$d(^CT.WDT.CDSS.TermPropertyI("CodeRulesIndex",termdr," "_CodeRules))
	if (id="") //如果为空，增加时的重复判断
	{
		if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc="",idd="",ide=""
		s:code'="" idc=$o(^CT.WDT.CDSS.TermPropertyI("CodeIndex",termdr," "_code,0))
		s:desc'="" idd=$o(^CT.WDT.CDSS.TermPropertyI("DescIndex",termdr," "_desc,0))
		s:CodeRules'="" ide=$o(^CT.WDT.CDSS.TermPropertyI("CodeRulesIndex",termdr," "_CodeRules,0))
		if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0))||((ide'="")&(ide'=id)&(flage>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	q flag
}

/// Description:用于术语添加时：代码自动生成 根据注册时的编码规则生成
/// Table：CT.WDT.CDSS.Term
/// Date:2019-03-07
/// creator:丁亚男
/// Input：base：术语库注册表ID
/// Return：按照代码生成规则生成的代码-mycode
/// w ##class(web.CDSS.CMKB.TermProperty).GetMultiTermCode(5)
ClassMethod GetMultiTermProCode(term) As %String
{
	s mycode=""
  	//如果没有配置代码生成规则，则默认代码自动生成
	s StartCode=$listGet($g(^CT.WDT.CDSS.TermD(term)),2)  //代码	 	
	s StartCodeLen=$Length(StartCode)
	s Code="", preCode=""    //寻找符合规则的最大的代码
	if ($d(^CT.WDT.CDSS.TermI("CodeIndex",base)))
	{
		for {
			s Code=$o(^CT.WDT.CDSS.TermI("CodeIndex",base,Code),-1)
			q:Code=""
			s realCode=$tr(Code," ","")
			if ($e(realCode,1,StartCodeLen)=$ZCONVERT(StartCode,"U"))
			{
				s preCode=realCode
				q
			}
		
		}
	}
	s CodeNum=""
	if (preCode="")   //如果没有符合规则的代码，则生成第一个数字1
	{
		s CodeNum=1
	}
	else  //如果有符合规则的代码，则起始字符后的数字+1
	{		
		s CodeNum=$p(preCode,$ZCONVERT(StartCode,"U"),2)+1     //起始字符后的数字+1
	}
	s CodeNumLen=$Length(CodeNum)     //数字的长度

	s zeroLen=5-CodeNumLen  //中间0串的长度
	s zeroStr=""  //中间0串
	s count=0
	for
	{
		s count=count+1
		q:count>zeroLen
		s zeroStr=zeroStr_"0"
	}
	
	s mycode=StartCode_zeroStr_CodeNum  //起始字符_0串_数字 的组合

	q mycode
}

/// Creator：丁亚男
/// CreatDate: 2018-3-29
/// Description：保存修改内容
/// Table：CT.WDT.CDSS.TermProperty
/// Input：web.CDSSEntity.CMKB.TermProperty 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.CDSSEntity.CMKB.TermProperty, logFlag As %String = "") As %String
{
	
	s result = ""
	if $IsObject(eobj)
	{
		
		if (eobj.MKBTPCodeRules=""){
			//生成编码规则
			s eobj.MKBTPCodeRules=##class(web.DHCBL.BDP.FunLib).GetPYCODE(eobj.MKBTPDesc)
		}
		if (eobj.MKBTPCode=""){
			//生成属性代码：术语代码-术语属性编码规则
			s StartCode=$listGet($g(^CT.WDT.CDSS.TermD(eobj.MKBTPTermDr)),2)  //代码
			s eobj.MKBTPCode=StartCode_"-"_eobj.MKBTPCodeRules
		}
		if ((eobj.MKBTPType="TX")||(eobj.MKBTPType="TA")||(eobj.MKBTPType="R")||(eobj.MKBTPType="CB")||(eobj.MKBTPType="C")||(eobj.MKBTPType="F")||(eobj.MKBTPType="S")||(eobj.MKBTPType="P")||(eobj.MKBTPType="SD")||(eobj.MKBTPType="M")||(eobj.MKBTPType="SS")){
			s eobj.MKBTPName=eobj.MKBTPDesc
		}
		
		s flag=..FormValidate(eobj.MKBTPRowId,eobj.MKBTPCode,eobj.MKBTPDesc,eobj.MKBTPTermDr,eobj.MKBTPCodeRules)  //调用重复验证
		s contextflag=""
		if (eobj.MKBTPRowId'="")
		{
				
				s fobj=##class(CT.WDT.CDSS.TermProperty).%OpenId(eobj.MKBTPRowId)
				s MKBTPType=fobj.MKBTPType
				if ((MKBTPType="C")||(MKBTPType="CB")||(MKBTPType="R")){
					s MKBTPDDesc=..GetALLDetail(fobj.MKBTPType,eobj.MKBTPRowId)  //属性内容
					
					if (MKBTPDDesc'=""){
						s MKBTPDDescLen=$length(MKBTPDDesc,",")
						s ConfigLen=$length(eobj.MKBTPConfig,"&%")
						for j=1:1:MKBTPDDescLen
						{
							s MKBTPDDescstr=$p(MKBTPDDesc,",",j)
							s contextflagstr=0
							for k=1:1:ConfigLen
							{
								
								s Configstr=$p(eobj.MKBTPConfig,"&%",k)
								if (MKBTPDDescstr=Configstr)
								{
									s contextflagstr=1	
								}	
							}
							
							s:contextflag="" contextflag=contextflagstr
							s:contextflag'="" contextflag=contextflag_"^"_contextflagstr
						}
					}
					else
					{
						s contextflag=1
					}
				}
			if (contextflag["0")
			{
				s result = "{success:'false',errorinfo:'属性内容有引用配置项,不能修改原配置项信息！'}"	
			}
		}
		if (flag=1){
			s result = "{success:'false',errorinfo:'该记录（编码）已经存在！'}"
		}
		if (result="")
		{
			s blogJson=""
			if (eobj.MKBTPRowId="")  //如果RowId未赋值则增加
			{
				s obj=##class(CT.WDT.CDSS.TermProperty).%New()
			}
			else  //如果RowId已赋值则修改
			{
				s obj=##class(CT.WDT.CDSS.TermProperty).%OpenId(eobj.MKBTPRowId)
                
                //修改属性的时候也要加同名校验，不能和扩展属性名重名。
                s upName=""
                if (eobj.MKBTPName'="")
                {
                    s upName=$ZCONVERT(eobj.MKBTPName,"U") //转换成大写
                }
                else
                {
                    s upName=$ZCONVERT(eobj.MKBTPDesc,"U") //转换成大写
                }
                if (upName'="")
                {
                    s genLength=$d(^CT.WDT.CDSS.TermExtendProI("NameIndex",eobj.MKBTPRowId," "_upName))
                    if (genLength)
                    {
                        q "{success:'false',errorinfo:'主列名不能和扩展属性名重名!'}"
                    }
                }
               
               	//修改属性名称的时候判断在公有属性是否存在，不存在的话标识改成私有属性
               	s MKBTBaseDR=""
                s:eobj.MKBTPTermDr'="" MKBTBaseDR=$listGet($g(^CT.WDT.CDSS.TermD(eobj.MKBTPTermDr)),4)
                if (MKBTBaseDR'="")
                {
	                if '$d(^CT.WDT.CDSS.TermBasePropertyI("DescIndex",MKBTBaseDR," "_$ZCONVERT(eobj.MKBTPDesc,"U")))
	                {
		                s obj.MKBTPPublic="N"
		            }
		            else
		            {
			            s obj.MKBTPPublic="Y"
			        }
                }
				s bobj = ##class(web.CDSSEntity.CMKB.TermProperty).%New()
				s bobj.MKBTPRowId = eobj.MKBTPRowId
				s bobj.MKBTPCode = obj.MKBTPCode
				s bobj.MKBTPDesc = obj.MKBTPDesc
				s bobj.MKBTPType = obj.MKBTPType
				s:obj.MKBTPTermDr'="" bobj.MKBTPTermDr = obj.MKBTPTermDr.%Id()
				s bobj.MKBTPConfig=obj.MKBTPConfig
				s:obj.MKBTPDefinedNode'="" bobj.MKBTPDefinedNode = obj.MKBTPDefinedNode.%Id()
				s bobj.MKBTPName=obj.MKBTPName
				s bobj.MKBTPFlag=obj.MKBTPFlag
				s bobj.MKBTPSequence=obj.MKBTPSequence
				s bobj.MKBTPCodeRules=obj.MKBTPCodeRules
				s blogJson="{MKBTPRowId:"""_bobj.MKBTPRowId_""",MKBTPCode:"""_bobj.MKBTPCode_""",MKBTPDesc:"""_bobj.MKBTPDesc_""",MKBTPType:"""_bobj.MKBTPType_""",MKBTPTermDr:"""_bobj.MKBTPTermDr_""",MKBTPConfig:"""_bobj.MKBTPConfig_""",MKBTPName:"""_bobj.MKBTPName_""",MKBTPFlag:"""_bobj.MKBTPFlag_""",MKBTPSequence:"""_bobj.MKBTPSequence_""",MKBTPDefinedNode:"""_bobj.MKBTPDefinedNode_""",MKBTPCodeRules:"""_bobj.MKBTPCodeRules_"""}"
				
			}
	
			s obj.MKBTPCode = eobj.MKBTPCode
			s obj.MKBTPDesc = eobj.MKBTPDesc
			s obj.MKBTPType = eobj.MKBTPType
			d:eobj.MKBTPTermDr'="" obj.MKBTPTermDrSetObjectId(eobj.MKBTPTermDr)
			d:eobj.MKBTPTermDr="" obj.MKBTPTermDrSetObjectId("")
			
			s:eobj.MKBTPTermDr'="" MKBTDesc=$listGet($g(^CT.WDT.CDSS.TermD(eobj.MKBTPTermDr)),3)  //术语描述
			s MKBTBaseDR="",MKBTBDesc=""
			s:eobj.MKBTPTermDr'="" MKBTBaseDR=$listGet($g(^CT.WDT.CDSS.TermD(eobj.MKBTPTermDr)),4)  //术语注册id
			s:MKBTBaseDR'="" MKBTBDesc=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(MKBTBaseDR)),3)  //术语注册描述
			
			s obj.MKBTPConfig=eobj.MKBTPConfig
			d:eobj.MKBTPDefinedNode'="" obj.MKBTPDefinedNodeSetObjectId(eobj.MKBTPDefinedNode)
			d:eobj.MKBTPDefinedNode="" obj.MKBTPDefinedNodeSetObjectId("")
			s obj.MKBTPName=eobj.MKBTPName
			s obj.MKBTPFlag=eobj.MKBTPFlag
			if (obj.MKBTPSequence="")
			{
				s obj.MKBTPSequence=..GetLastSequence(eobj.MKBTPTermDr)
			}
			else
			{
				s obj.MKBTPSequence=bobj.MKBTPSequence
			}
			s obj.MKBTPCodeRules=eobj.MKBTPCodeRules
			s logJson="{MKBTPRowId:"""_eobj.MKBTPRowId_""",MKBTPCode:"""_eobj.MKBTPCode_""",MKBTPDesc:"""_eobj.MKBTPDesc_""",MKBTPType:"""_eobj.MKBTPType_""",MKBTPTermDr:"""_eobj.MKBTPTermDr_""",MKBTPConfig:"""_eobj.MKBTPConfig_""",MKBTPName:"""_eobj.MKBTPName_""",MKBTPFlag:"""_eobj.MKBTPFlag_""",MKBTPSequence:"""_obj.MKBTPSequence_""",MKBTPDefinedNode:"""_eobj.MKBTPDefinedNode_""",MKBTPCodeRules:"""_eobj.MKBTPCodeRules_"""}"
			
			Ts
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc){
				Tc
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}" //返回RowId
				//保存术语改变的日志
				d ##class(web.CDSS.CMKB.MedicalWikiStatis).UpdateLog(id)
				
				/*//引用术语、引用起始节点、知识表达式格式引用维护到引用表
				if ((eobj.MKBTPType="S")||(eobj.MKBTPType="SS")||(eobj.MKBTPType="SD")){
					if (eobj.MKBTPRowId=""){
						s resultRef=##class(web.CDSS.CMKB.MKBReference).SaveDataById("", "P", id, "B", obj.MKBTPConfig)
						s resultRefNode=""
						if (eobj.MKBTPDefinedNode'=""){
							s resultRefNode=##class(web.CDSS.CMKB.MKBReference).SaveDataById("", "P", id, "T", eobj.MKBTPDefinedNode)	
						}	 
					}else{
						s refRowId=""
						if (bobj.MKBTPType="M")
						{
							s refRowId=##class(web.CDSS.CMKB.MKBReference).GetMKBRRowId("P", id, "MB", bobj.MKBTPConfig)
						}
						elseif((bobj.MKBTPType="S")||(bobj.MKBTPType="SS")||(bobj.MKBTPType="SD")) 
						{
							s refRowId=##class(web.CDSS.CMKB.MKBReference).GetMKBRRowId("P", id, "B", bobj.MKBTPConfig)	
						}
						s resultRef=##class(web.CDSS.CMKB.MKBReference).SaveDataById(refRowId, "P", id, "B", obj.MKBTPConfig)
						s resultRefNode=""
						if (eobj.MKBTPDefinedNode'=""){
							s refNodeRowId=##class(web.CDSS.CMKB.MKBReference).GetMKBRRowId("P", id, "T", bobj.MKBTPDefinedNode)
							s resultRefNode=##class(web.CDSS.CMKB.MKBReference).SaveDataById(refNodeRowId, "P", id, "T", eobj.MKBTPDefinedNode)	 
						}	 
					}
					if ((resultRef["error")||(resultRefNode["error")){
						s result = "{success:'false',errorinfo:'引用表保存失败'}"
					}
				}elseif (eobj.MKBTPType="M"){ //映射格式属性的引用
					
					s resultRefNode=""
					if (eobj.MKBTPRowId=""){
						s resultRef=##class(web.CDSS.CMKB.MKBReference).SaveDataById("", "P", id, "MB", obj.MKBTPConfig)	 
					}else{
						s refRowId=""
						if (bobj.MKBTPType="M")
						{
							s refRowId=##class(web.CDSS.CMKB.MKBReference).GetMKBRRowId("P", id, "MB", bobj.MKBTPConfig)
						}
						elseif((bobj.MKBTPType="S")||(bobj.MKBTPType="SS")||(bobj.MKBTPType="SD")) 
						{
							s refRowId=##class(web.CDSS.CMKB.MKBReference).GetMKBRRowId("P", id, "B", bobj.MKBTPConfig)	
						}
						s resultRef=##class(web.CDSS.CMKB.MKBReference).SaveDataById(refRowId, "P", id, "MB", obj.MKBTPConfig)
						if (bobj.MKBTPDefinedNode'=""){
							s refNodeRowId=##class(web.CDSS.CMKB.MKBReference).GetMKBRRowId("P", id, "T", bobj.MKBTPDefinedNode)
							s resultRefNode=##class(web.CDSS.CMKB.MKBReference).SaveDataById(refNodeRowId, "P", id, "T", "")	 
						}		
							 
					}
					if ((resultRef["error")||(resultRefNode["error")){
						s result = "{success:'false',errorinfo:'引用表保存失败'}"
					} 
				}
				else{ //其他格式
					if (eobj.MKBTPRowId'=""){
						if ((bobj.MKBTPType="M")||(bobj.MKBTPType="S")||(bobj.MKBTPType="SS")||(bobj.MKBTPType="SD"))
						{
							s resultRef=##class(web.CDSS.CMKB.MKBReference).DeleteData("P",id)
							if (resultRef["error"){
								s result = "{success:'false',errorinfo:'引用表删除失败'}"
							} 
						}
					}		 
					
				}
				*/
				 //保存日志
				if (logFlag=""){
					d:eobj.MKBTPRowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLogForOther("CT_WDT_CDSS.TermProperty","CT.WDT.CDSS.TermProperty"_eobj.MKBTPTermDr,MKBTBDesc,id,MKBTDesc_"-"_eobj.MKBTPDesc,"A",logJson)
					if (logJson'=blogJson){
						d:eobj.MKBTPRowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLogForOther("CT_WDT_CDSS.TermProperty","CT.WDT.CDSS.TermProperty"_eobj.MKBTPTermDr,MKBTBDesc,eobj.MKBTPRowId,MKBTDesc_"-"_eobj.MKBTPDesc,"U",logJson,blogJson)
					}
				}
				/*
				//如果新增树形属性，则生成展示名、别名、检索码三个扩展属性
                if (eobj.MKBTPRowId="")&(eobj.MKBTPType="T")&(id'="")&(result'["false")
                {  
                    s str1="^"_id_"^展示名^TX^"
                    s catResult1=##class(web.CDSS.CMKB.TermExtendPro).SaveStrData(str1)
                    if (catResult1["false")&(catResult1'["该记录已经存在"){
                        s result =catResult1
                    }
                    
                    s str2="^"_id_"^别名^TX^"
                    s catResult2=##class(web.CDSS.CMKB.TermExtendPro).SaveStrData(str2)
                    if (catResult2["false")&(catResult2'["该记录已经存在"){
                        s result =catResult2
                    }
                    
                    s str3="^"_id_"^检索码^TX^"
                    s catResult3=##class(web.CDSS.CMKB.TermExtendPro).SaveStrData(str3)
                    if (catResult3["false")&(catResult3'["该记录已经存在"){
                        s result =catResult3
                    }
                }
                
                if (eobj.MKBTPRowId="")&(eobj.MKBTPType="T")&(eobj.MKBTPConfig'="")&(result'["false")  //如果是新增 树形 引用术语
                {
                    s sourceFlag=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(eobj.MKBTPConfig)),10)  //术语库注册-标识
                    s firstNode=eobj.MKBTPDefinedNode
                    if (firstNode="")  //如果没有定义起始节点,则默认所有的数据都复制过来
                    {
                        s firstNode="CatTreeRoot"               
                    }
                    else  //先保存初始节点
                    {
                        s MKBTPDCode="",MKBTPDDesc="",MKBTPDRemark=""
                        s myObj=##Class(CT.WDT.CDSS.Term).%OpenId(firstNode,0)
                        if $IsObject(myObj)
                        {
                            s MKBTPDCode = myObj.MKBTCode
                            s MKBTPDDesc = myObj.MKBTDesc
                            s MKBTPDRemark =  myObj.MKBTNote
                            d myObj.%Close()

                        }
                        
                        if (MKBTPDCode'="")&(MKBTPDDesc'="")&(id'="")
                        {	                        	                        
	                        s eobjDetail=##class(web.CDSSEntity.CMKB.TermProDetail).%New()
                            s eobjDetail.MKBTPDCode=MKBTPDCode
                            s eobjDetail.MKBTPDDesc=MKBTPDDesc
                            s eobjDetail.MKBTPDProDR=id  //属性Dr
                            s eobjDetail.MKBTPDLevel=1
                            s eobjDetail.MKBTPDRemark=MKBTPDRemark
                            s eobjDetail.MKBTPDExtend=..FindThreeExtendStr(eobj.MKBTPConfig,id,firstNode)  // 获取展示名、别名、拼音码的数据 谷雪萍 2018-03-08 
                            s detailResult=##class(web.CDSS.CMKB.TermProDetail).SaveData(eobjDetail)
		                    if (detailResult["false"){
		                        s result =detailResult
		                    }
                            
                        }
                    }
                    if (result'["false"){  //如果初始节点保存成功，则保存其子节点
                    	 s treeSaveflag=##class(web.CDSS.CMKB.TermProperty).SaveTreeSou(firstNode,eobj.MKBTPConfig,id,2)
                        if (treeSaveflag=1)
                        {
                            s result = "{success:'false',errorinfo:'该树形属性内容保存失败'}"   //返回错误信息
                        }
                    }
                        
                }
                
               */ 
               
              
                
			}else{
				Trollback
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
			}
		}	
	}	
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在'}"
	}
	
	q result
}

/// Function:获取展示名、别名、检索码信息，用于新建属性-部位 （格式为树形、选择了来源，和起始节点）保存的时候
/// Creator:基础数据平台组 丁亚男
/// CreateDate:2018-04-017   
/// w ##class(web.CDSS.CMKB.TermProperty).FindThreeExtendStr("9","18920","44")
/// Input:sou—属性来源 id-属性id
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FindThreeExtendStr(sou As %String, id As %String, firstNode As %String) As %String
{
    ///2018-03-08 谷雪萍 新建属性-部位 （格式为树形、选择了来源，和起始节点）。部位内容的展示名、检索码没带过来。
    //比如 肺癌 新建了一个部位属性 （格式是树形、来源是部位术语、起始节点是肺）
    //找到初始节点（肺）的展示名、别名、检索码的内容
    q:(sou="")||(id="")||(firstNode="") ""
    s extendStr=""
    s comDesc=""
    s comFieldChild=$o(^CT.WDT.CDSS.TermPropertyI("DescIndex",sou," 展示名",0))
    if (comFieldChild'="")
    {
        s comFieldRowId=sou_"||"_comFieldChild    //术语库注册-部位术语-展示名字段的id
        s comTermItmId=$o(^User.MKBTremExtendProValI("ValIndex",firstNode,comFieldRowId,0))  //术语明细表的id
		s:comTermItmId'="" comDesc=$listget($g(^User.MKBTremExtendProValD(comTermItmId)),4)  //术语明细表的内容
    }
    s aliasDesc=""
    s aliasFieldChild=$o(^CT.WDT.CDSS.TermPropertyI("DescIndex",sou," 别名",0))
    if (aliasFieldChild'="")
    {
        s aliasFieldRowId=sou_"||"_aliasFieldChild    //术语库注册-部位术语-别名字段的id
        s aliasTermItmId=$o(^User.MKBTremExtendProValI("ValIndex",firstNode,aliasFieldRowId,0))  //术语明细表的id
		s:aliasTermItmId'="" aliasDesc=$listget($g(^User.MKBTremExtendProValD(comTermItmId)),4)  //术语明细表的内容
    }
    s PYDesc=$listget($g(^CT.WDT.CDSS.TermBaseD(firstNode)),7) //检索码
    
    //找到扩展属性的id  肺癌-部位的展示名、别名、检索码
    s comCatChildsub=$o(^CT.WDT.CDSS.TermExtendProI("NameIndex",id,"展示名",0))
    s aliasCatChildsub=$o(^CT.WDT.CDSS.TermExtendProI("NameIndex",id,"别名",0))
    s PYCatChildsub=$o(^CT.WDT.CDSS.TermExtendProI("NameIndex",id,"检索码",0))
    s extendStr=comCatChildsub_"[A]"_comDesc_"[N]"_aliasCatChildsub_"[A]"_aliasDesc_"[N]"_PYCatChildsub_"[A]"_PYDesc
    q extendStr
}

/// Creator:丁亚男
/// CreatDate:2018-4-17
/// Input：ParentID 父节点Id，cat 属性ID ，base术语库注册ID ，leval级别
/// Return：flag  :1保存数据失败，"" 保存成功。
/// Description:属性格式为树形并且选择了数据来源定义了初始节点，则要把对应的术语数据保存到术语明细表里
/// w ##class(web.CDSS.CMKB.TermProperty).SaveTreeSou("14","2","1284448","1")
ClassMethod SaveTreeSou(ParentID As %String, base As %String, cat As %String, leval As %String) As %String
{
    q:(ParentID="")||(base="")||(cat="") ""
    if (ParentID="CatTreeRoot") s ParentID=-100000000000000
    s MKBTPDLevel=leval
    s flag =""
    s myRowID=0
    for {
        s myRowID=$o(^CT.WDT.CDSS.TermI("ParentIndex",base,ParentID,myRowID))
        q:(myRowID="")||(flag=1)
                
        s myObj=##Class(CT.WDT.CDSS.Term).%OpenId(myRowID,0)
        if $IsObject(myObj)
        {
            s MKBTCode=myObj.MKBTCode
            s MKBTDesc = myObj.MKBTDesc
            s MKBTLastLevel=""
            if $IsObject(myObj.MKBTLastLevel){
                s MKBTLastLevel = myObj.MKBTLastLevel.%Id()
            }
            s MKBTNote =  myObj.MKBTNote
            d myObj.%Close()
            
            s MKBTPDLastLevel=""   //术语明细表上级分类 
            if (MKBTLastLevel'="")  //术语表上级分类
            {
                s parentCode=$listget($g(^CT.WDT.CDSS.TermD(MKBTLastLevel)),2)  //术语表上级分类的代码
                s:parentCode'="" parentCode=$ZCONVERT(parentCode,"U") //转换成大写
                s MKBTPDLastLevel=$o(^CT.WDT.CDSS.TermProDetailI("CodeIndex",cat," "_parentCode,0))   //术语明细表上级分类-通过code找术语明细表的ID
            }
            
            s eobjDetail=##class(web.CDSSEntity.CMKB.TermProDetail).%New()
            s eobjDetail.MKBTPDCode=MKBTCode
            s eobjDetail.MKBTPDDesc=MKBTDesc
            s eobjDetail.MKBTPDProDR=cat //属性Dr
            s eobjDetail.MKBTPDLevel=MKBTPDLevel
            s eobjDetail.MKBTPDLastLevel=MKBTPDLastLevel
            s eobjDetail.MKBTPDRemark=MKBTNote
            s eobjDetail.MKBTPDExtend=..FindThreeExtendStr(base,cat,myRowID)   //获取展示名、别名、拼音码的数据 谷雪萍 2018-03-08 
            s detailResult=##class(web.CDSS.CMKB.TermProDetail).SaveData(eobjDetail)
            if (detailResult["true")
            {
                s nextLevel=MKBTPDLevel+1            
                s flag=..SaveTreeSou(myRowID,base,cat,nextLevel)
            }
            else
            {
	            s flag = 1
            }

        }
    }

    q flag
}

/// Creator：丁亚男
/// CreatDate: 2018-3-29
/// Description：获取修改时的记录
/// Table：CT.WDT.CDSS.TermProperty
/// Other: d ##class(web.CDSS.CMKB.TermProperty).OpenData()
ClassMethod OpenData(id As %String) As %String
{
	s str=""
	s eobj = ##class(web.CDSSEntity.CMKB.TermProperty).%New()
	if (id["MKBT")
	{
		s desc=$p(id,"-",1)	
		s termdr=$p(id,"-",2)
		if (desc="MKBTDesc")
	    {
		    s eobj.MKBTPRowId = id
			s eobj.MKBTPDDesc = $listGet($g(^CT.WDT.CDSS.TermD(termdr)),3)  //描述
			s eobj.MKBTPType = "TX"
			s eobj.MKBTPCodeRules=##class(web.DHCBL.BDP.FunLib).GetPYCODE(eobj.MKBTPDesc)  
	    }
	    elseif(desc="MKBTPYCode")
	    {
		 	s eobj.MKBTPRowId = id
			s eobj.MKBTPDDesc = $listGet($g(^CT.WDT.CDSS.TermD(termdr)),6)  //描述
			s eobj.MKBTPType = "TX"
			s eobj.MKBTPCodeRules=##class(web.DHCBL.BDP.FunLib).GetPYCODE(eobj.MKBTPDesc)   
		}
		elseif(desc="MKBTLastLevel")
	    {
		 	s eobj.MKBTPRowId = id
			s eobj.MKBTPDDesc = $listGet($g(^CT.WDT.CDSS.TermD(termdr)),5)  //上级节点
			s eobj.MKBTPType = "TX"
			s eobj.MKBTPCodeRules=##class(web.DHCBL.BDP.FunLib).GetPYCODE(eobj.MKBTPDesc)   
		}
		elseif(desc="MKBTNote")
	    {
		 	s eobj.MKBTPRowId = id
			s eobj.MKBTPDDesc = $listGet($g(^CT.WDT.CDSS.TermD(termdr)),7) 
			s eobj.MKBTPType = "TX"
			s eobj.MKBTPCodeRules=##class(web.DHCBL.BDP.FunLib).GetPYCODE(eobj.MKBTPDesc)   
		}
		
	}
	else
	{
		s pobj = ##class(CT.WDT.CDSS.TermProperty).%OpenId(id)
		s eobj.MKBTPRowId = id
		s eobj.MKBTPDesc = pobj.MKBTPDesc
		s eobj.MKBTPCode = pobj.MKBTPCode
		s eobj.MKBTPType = pobj.MKBTPType
		if (pobj.MKBTPType="SD")
		{
			s eobj.MKBTPDDescF=..GetALLDetail(pobj.MKBTPType,id)
			s eobj.MKBTPDDesc =##class(web.CDSS.CMKB.MKBKnoExpression).GetDiagDesc(id)	
		}
		
		s eobj.MKBTPConfig=pobj.MKBTPConfig
		s:pobj.MKBTPDefinedNode'="" eobj.MKBTPDefinedNode = pobj.MKBTPDefinedNode.%Id()
		s eobj.MKBTPName=pobj.MKBTPName
		s eobj.MKBTPFlag=pobj.MKBTPFlag
		s eobj.MKBTPCodeRules=pobj.MKBTPCodeRules
	}
	s str = eobj.JsonS()	
	q str
}

/// Creator:丁亚男
/// CreatDate:2021-09-02
/// Description:根据id删除,LogFlag 是否保存日志（N的话不保存）
/// Table:CT.WDT.CDSS.TermProperty
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.CDSS.CMKB.TermProperty).DeleteData("1")
ClassMethod DeleteData(id As %String, LogFlag As %String = "") As %String
{
    s result=""
    /*s re=##class(web.CDSS.CMKB.MKBReference).DeleteData("P",id)
	if (re'=""){
		s result= "{success:'false',info:'"_re_"'}"
	}
	else
	{*/
	    s MKBTPTermDr = $listGet($g(^CT.WDT.CDSS.TermPropertyD(id)),6) //术语id
	    s MKBTPRowId = ""
	    s MKBTPDescStr=""
	    s MKBTEPFlag=0
	    for
	    {
	        s MKBTPRowId=$o(^CT.WDT.CDSS.TermPropertyI("TermIndex",MKBTPTermDr,MKBTPRowId))
	        continue:MKBTPRowId=id 
	        q:MKBTPRowId=""
	        s MKBTPType = $listGet($g(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),4)
	        if (MKBTPType="P")
	        {
	            s MKBTPDesc=$listGet($g(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),3)
	            s MKBTPDRowId=""
	            s MKBTEPFlag=0
	            for
	            {
	                s MKBTPDRowId = $o(^CT.WDT.CDSS.TermProDetailI("ProIdx",MKBTPRowId,MKBTPDRowId))  //术语属性明细表
	                q:MKBTPDRowId=""||MKBTEPFlag=1
	                s MKBTPDDesc=$listGet($g(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),3)
	                s length=$Length(MKBTPDDesc,",")
	                for i=1:1:length
	                { 
	                	s argstr=$p(MKBTPDDesc,",",i)  //术语属性id&展示类型&起始节点
        				s catRowId=$p(argstr,"&",1)  //术语属性id
		                if (catRowId=id)
		                {
		                    s MKBTEPFlag=1
		                }
	                }
	            }
	            if (MKBTEPFlag=1){
		            if (MKBTPDescStr="")
		            {
		            	s MKBTPDescStr=MKBTPDesc
		            }
		            else
		            {
			        	s MKBTPDescStr=MKBTPDescStr_","_MKBTPDesc
			        }  
	            }
	        }
	    } 
	    if (MKBTPDescStr'="")
	    {
		    s result="{success:'false',info:'该属性被"_MKBTPDescStr_"引用,不可删除！'}"   
		}  
	    if (result="")
	    {
	        s eobj = ##class(web.CDSSEntity.CMKB.TermProperty).%New()
	        s pobj = ##class(CT.WDT.CDSS.TermProperty).%OpenId(id)
	        s eobj.MKBTPRowId = id
	        s eobj.MKBTPCode = pobj.MKBTPCode
	        s eobj.MKBTPDesc = pobj.MKBTPDesc
	        s eobj.MKBTPType = pobj.MKBTPType
	        s eobj.MKBTPConfig = pobj.MKBTPConfig
	        s:pobj.MKBTPTermDr'="" eobj.MKBTPTermDr = pobj.MKBTPTermDr.%Id()
	        
	        s:eobj.MKBTPTermDr'="" MKBTDesc=$listGet($g(^CT.WDT.CDSS.TermD(eobj.MKBTPTermDr)),3)  //术语描述
			s MKBTBaseDR="",MKBTBDesc=""
			s:eobj.MKBTPTermDr'="" MKBTBaseDR=$listGet($g(^CT.WDT.CDSS.TermD(eobj.MKBTPTermDr)),4)  //术语注册id
			s:MKBTBaseDR'="" MKBTBDesc=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(MKBTBaseDR)),3)  //术语注册描述
			
	        s eobj.MKBTPName=pobj.MKBTPName
	        s eobj.MKBTPFlag=pobj.MKBTPFlag
	        s eobj.MKBTPPublic=pobj.MKBTPPublic
	        s eobj.MKBTPDefinedNode = pobj.MKBTPDefinedNode
	        s eobj.MKBTPSequence = pobj.MKBTPSequence
	        s eobj.MKBTPCodeRules = pobj.MKBTPCodeRules       
	        Tstart
	        
	        //删除属性下的属性内容
	        s resultalldetail=##class(web.CDSS.CMKB.TermProDetail).DeleteAllSelTerm(id)
	        if (resultalldetail["false"){
				s result = "{success:'false',info:'术语属性内容删除失败！'}"
			}
			
	        //删除属性
	       	s sc=##class(CT.WDT.CDSS.TermProperty).%DeleteId(id)
	        
	        if $$$ISOK(sc)&'(result["false") 
	        {
	            
	            Tcommit
	            s result="{success:'true',info:'删除成功！'}"
	            //删除引用--2018-12-17
	           // d ##class(web.CDSS.CMKB.MKBReference).DeleteViaOriginal("T",id)
	            if (LogFlag'="N")
	            {
	            	//保存日志
		   			d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TermProperty","CT.WDT.CDSS.TermProperty"_eobj.MKBTPTermDr,MKBTBDesc,id,MKBTDesc_"-"_eobj.MKBTPDesc,"D",eobj)
	            }
	            d eobj.%Close()
	            
	        }
	        else
	        {
	            Trollback
				if '$$$ISOK(sc){
					s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}" 
					s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("医用知识库知识属性表","web.CDSS.CMKB.TermProperty","DeleteData",eobj)
		     		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 	
				}
				else{
					s result= result  
					 
				}

	        }  
	    }
	//} 
    q result
}

/// Creator:丁亚男
/// CreatDate:2019-07-23
/// Description:根据id删除数据及被引用数据
/// Table:CT.WDT.CDSS.TermProperty
/// Input：id-术语表CT.WDT.CDSS.TermProperty的id
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.CDSS.CMKB.TermProperty).DeleteDataAndRefer("2")
ClassMethod DeleteDataAndRefer(id As %String) As %String
{
	q:id="" "{success:'false',info:'没有获取到ID，删除失败'}"  //返回错误信息
	 //删除引用
	s result=""
    s result=##class(web.CDSS.CMKB.MKBReference).DeleteAll("P", id)
    if (result="")  //删除成功
    {
	    s result=..DeleteData(id)
    }
   	q result
}

/// Creator:丁亚男
/// CreatDate:2018-3-29
/// Description: 根据id获取描述
/// Table:CT.WDT.CDSS.TermProperty
/// Other:w ##class(web.CDSS.CMKB.TermProperty).GetDesc("1")
ClassMethod GetDesc(RowId As %String) As %String
{
	;w ##class(web.CDSS.CMKB.TermBaseProperty).GetDesc("41")
	s MKBTPDesc=""
	if (RowId'=""){
		s MKBTPDesc=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(RowId)),3)
	}
	q MKBTPDesc
}

/// Creator:石萧伟
/// CreatDate:2018-04-17
/// Description: 根据id获取类型
/// Table:CT.WDT.CDSS.TermProperty
/// Other:w ##class(web.CDSS.CMKB.TermProperty).GetType("1")
ClassMethod GetType(RowId As %String) As %String
{
	;w ##class(web.CDSS.CMKB.TermBaseProperty).GetDesc("41")
	s MKBTPType=""
	if (RowId'=""){
		s MKBTPType=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(RowId)),4)
	}
	q MKBTPType
}

/// Creator:丁亚男
/// CreatDate:2018-3-29
/// Description:顺序自动生成  获取顺序最大值
/// Other:w ##class(web.CDSS.CMKB.TermProperty).GetLastSequence(9)
ClassMethod GetLastSequence(termdr) As %String
{
  	s LastSequence=0
  	s Sequence=$o(^CT.WDT.CDSS.TermPropertyI("SeqIndex",termdr,""),-1)
  	s LastSequence=$g(Sequence)+1
	q LastSequence
}

/// Creator:丁亚男
/// CreatDate:2018-3-29
/// Description：保存诊断属性拖拽的顺序
/// Other: w ##class(web.CDSS.CMKB.TermProperty).SaveDragOrder("9^12^11")
ClassMethod SaveDragOrder(order, seq) As %String
{
	s $zt="ERROE"
	s result=""
	Ts
	s argsLen=$Length(order,"^")
	for i=1:1:argsLen		
	{
		s rowid=$p(order,"^",i)
		//选中行的顺序
		s obj=##class(CT.WDT.CDSS.TermProperty).%OpenId(rowid)
		s obj.MKBTPSequence=i+seq-1
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			
		}
		else
		{
			s result = "{success:'false'}"  //返回错误信息
		}
	}
	if (result["false")
	{
		Trollback
		s result = "{success:'false',errorinfo:'保存失败'}"
	
	}
	else
	{
		Tc
		s result = "{success:'true',errorinfo:'保存成功'}"

	}
	q result
	
ERROE
	q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator：丁亚男
/// CreatDate: 2018-3-31
/// Description：获取列表配置项
/// Table：CT.WDT.CDSS.TermProperty
/// Input:catid CT.WDT.CDSS.TermProperty id
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.TermProperty","GetConfigList","4")
Query GetConfigList(rowid As %String) As %Query(ROWSPEC = "ConfigNum:%String,ConfigName:%String")
{
}

ClassMethod GetConfigListExecute(ByRef qHandle As %Binary, rowid As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	if (rowid'="")
	{
		s MKBTPType=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(rowid)),4)
		s MKBTPConfig=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(rowid)),5)

  		if ((MKBTPType="R")||(MKBTPType="CB")||(MKBTPType="C")){
	  		if (MKBTPConfig'="")
			{
				s configLen=$Length(MKBTPConfig,"&%")
			    for i=1:1:configLen   
			    { 
			      s ConfigNum=i  
			      s ConfigName=$p(MKBTPConfig,"&%",i)
			      d OutputRowConfig
			    }
			}
	  	}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowConfig
    set Data=$lb(ConfigNum,ConfigName)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetConfigListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetConfigListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
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

ClassMethod GetConfigListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetConfigListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：丁亚男
/// CreatDate: 2018-5-31
/// Description：获取列表配置项，描述与id一致
/// Table：CT.WDT.CDSS.TermProperty
/// Input:catid CT.WDT.CDSS.TermProperty id
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.TermProperty","GetConfigDescList","4")
Query GetConfigDescList(rowid As %String) As %Query(ROWSPEC = "ConfigNum:%String,ConfigName:%String")
{
}

ClassMethod GetConfigDescListExecute(ByRef qHandle As %Binary, rowid As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	if (rowid'="")
	{
		s MKBTPType=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(rowid)),4)
		s MKBTPConfig=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(rowid)),5)

  		if ((MKBTPType="R")||(MKBTPType="CB")||(MKBTPType="C")){
	  		if (MKBTPConfig'="")
			{
				s configLen=$Length(MKBTPConfig,"&%")
			    for i=1:1:configLen   
			    { 
			      s ConfigNum=$p(MKBTPConfig,"&%",i) 
			      s ConfigName=$p(MKBTPConfig,"&%",i)
			      d OutputRowConfigDesc
			    }
			}
	  	}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowConfigDesc
    set Data=$lb(ConfigNum,ConfigName)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetConfigDescListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetConfigDescListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
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

ClassMethod GetConfigDescListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetConfigDescListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：丁亚男
/// CreatDate: 2018-3-31
/// Description:添加配置项 result="true"时添加成功
/// Input：id-大类id，extend-配置项
/// Other:w ##class(web.CDSS.CMKB.TermProperty).GetConfigDesc(id)
ClassMethod GetConfigDesc(id) As %String
{
	s result=""
	if (id'="")
	{
		s result=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(id)),5)
	}
	q result
}

/// Creator：丁亚男
/// CreatDate: 2018-3-31
/// Description:添加配置项 result="true"时添加成功
/// Input：id-大类id，extend-配置项
/// Other:w ##class(web.CDSS.CMKB.TermProperty).SaveConfig(id)
ClassMethod SaveConfig(id, config) As %String
{
	s result="",flag=""
	q:(config="") "配置项名称不能为空！"
	s obj=##class(CT.WDT.CDSS.TermProperty).%OpenId(id)
	s olds=obj.MKBTPConfig
	if (olds'="")
	{
		s oldLen=$Length(olds,",")
	    for i=1:1:oldLen   
	    {     
	      s old=$p(olds,",",i)
	      if (old=config){
		      s flag="N"    
		      s result="该配置项已经存在！"
	      }
	    }
	}

	if (flag'="N")
	{
		s:olds'="" obj.MKBTPConfig=olds_","_config
		s:olds="" obj.MKBTPConfig=config
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc){
			s result = "true"
		}else{
			s result = "添加失败！"
		}
	}
	q result
}

/// Creator：丁亚男
/// CreatDate: 2018-3-31
/// Description:修改配置项 result="true"时添加成功
/// Input：id-大类id，index-要修改的序号，config-配置项
/// Other:w ##class(web.CDSS.CMKB.TermProperty).UpdateConfig(id)
ClassMethod UpdateConfig(id, index, config) As %String
{
	s result="",flag="",new=""
	q:(config="") "配置项名称不能为空！"
	q:(index="") "未选中要修改的配置项！"
	s obj=##class(CT.WDT.CDSS.TermProperty).%OpenId(id)
	s olds=obj.MKBTPConfig
	if (olds'="")
	{
		s oldLen=$Length(olds,",")
	    for i=1:1:oldLen   
	    {     
	      s old=$p(olds,",",i)
	      if (old=config)&(index'=i){
		      s flag="N"    
		      s result="该配置项已经存在！"
	      }
	      if (index=i) //要修改的序号
	      {
	      	s:new'="" new=new_","_config
	      	s:new="" new=config
	      }
	      else
	      {
		    s:new'="" new=new_","_old
		    s:new="" new=old
	      }
	    }
	}

	if (flag'="N")
	{
		s obj.MKBTPConfig=new
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc){
			s result = "true"
		}else{
			s result = "修改失败！"
		}
	}

	q result
}

/// Creator：丁亚男
/// CreatDate: 2018-3-31 
/// Description:删除配置项，同时删除知识点配置项的值
/// Input：id-大类id，index-要修改的序号
/// Other:w ##class(web.CDSS.CMKB.TermProperty).DeleteConfig("33564","0")
ClassMethod DeleteConfig(id, index) As %String
{
	s result="",new="",flag=""
	q:(index="") "未选中要删除的配置项！"
	
	s obj=##class(CT.WDT.CDSS.TermProperty).%OpenId(id)
	s olds=obj.MKBTPConfig
	if (olds'="")
	{
		s oldLen=$Length(olds,"&%")
	    for i=1:1:oldLen   
	    {     
	      s old=$p(olds,"&%",i)
	      if (index+1=i){
		      s flag="Y"  
	      }else{
		      s:new'="" new=new_"&%"_old
		      s:new="" new=old
	      }
	    }
	}
	s contextflag=""
	s obj=##class(CT.WDT.CDSS.TermProperty).%OpenId(id)
	s MKBTPType=obj.MKBTPType
	s MKBTPDDesc=..GetALLDetail(obj.MKBTPType,id)  //属性内容
	if (MKBTPDDesc'=""){
		
		s MKBTPDDescLen=$length(MKBTPDDesc,",")
		s ConfigLen=$length(new,"&%")
		for j=1:1:MKBTPDDescLen
		{
			s MKBTPDDescstr=$p(MKBTPDDesc,",",j)
			s contextflagstr=0
			for k=1:1:ConfigLen
			{
				s Configstr=$p(new,"&%",k)
				if (MKBTPDDescstr=Configstr)
				{
					s contextflagstr=1	
				}	
			}
			
			s:contextflag="" contextflag=contextflagstr
			s:contextflag'="" contextflag=contextflag_"^"_contextflagstr
			
		}
	}
	else
	{
		s contextflag=1
	}
	if (contextflag["0")
	{
		s result = "该配置项信息被属性内容引用,不能删除!"	
	}
	else
	{		
		if (flag="Y")  //存在该配置项名称
		{
			//删除该配置项
			s obj.MKBTPConfig=new
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc){
				s result = "true"
			}else{
				s result = "删除失败！"
			}
		}
		else
		{
			s result = "该配置项名称不存在！"
		}
	}
	q result
}

/// Creator:丁亚男
/// CreatDate:2018-4-03
/// Description：复制属性及知识点到本术语
/// Table：CT.WDT.CDSS.TermProperty
/// Input：copypro-属性id, copyall-不为空的时候完全复制，为空的时候只复制格式
/// Return：成功返回success:'true' ,失败返回success:'false'
/// w ##class(web.CDSS.CMKB.TermProperty).CopyToSelf("24168","","病情描述1")
ClassMethod CopyToSelf(copypro, copyall, CopyMKBTPDesc) As %String
{

    s result = ""
    q:(copypro="") "{success:'false',errorinfo:'没有选择属性'}"
    s dia = $listGet($g(^CT.WDT.CDSS.TermPropertyD(copypro)),6)
    s diaDesc=$listGet($g(^CT.WDT.CDSS.TermD(dia)),3)  //术语描述
    
    //复制到术语扩展属性表： CT_WDT_CDSS.TermProperty
    s obj=##class(CT.WDT.CDSS.TermProperty).%OpenId(copypro)
    s nobj=##class(CT.WDT.CDSS.TermProperty).%New()
    s flag=..FormValidate("","",CopyMKBTPDesc,dia,"")  //调用重复验证
    
    s errorinfo="复制失败！"_diaDesc_"已经存在属性"_CopyMKBTPDesc_"!"  //错误信息
    q:(flag=1) "{success:'false',errorinfo:'"_errorinfo_"'}"

    //s nobj.MKBTPCode = CopyMKBTPDesc
   
	//生成编码规则
	s nobj.MKBTPCodeRules=##class(web.DHCBL.BDP.FunLib).GetPYCODE(CopyMKBTPDesc)
	//生成属性代码：术语代码-术语属性编码规则
	s StartCode=$listGet($g(^CT.WDT.CDSS.TermD(dia)),2)  //代码
	s nobj.MKBTPCode=StartCode_"-"_nobj.MKBTPCodeRules
		
		
    s nobj.MKBTPDesc = CopyMKBTPDesc
    
    s nobj.MKBTPType = obj.MKBTPType
    s nobj.MKBTPConfig = obj.MKBTPConfig
     
    d nobj.MKBTPTermDrSetObjectId(dia)
    s nobj.MKBTPName=CopyMKBTPDesc
    s nobj.MKBTPFlag=obj.MKBTPFlag
    s nobj.MKBTPPublic=""
    if (obj.MKBTPDefinedNode'="")
    {
        s nobj.MKBTPDefinedNode=obj.MKBTPDefinedNode
    }
	s nobj.MKBTPSequence=..GetLastSequence(dia)
	
    TS
    s sc=nobj.%Save()
    //s code = $SYSTEM.Status.GetErrorText(sc)
    d nobj.%Close()
    d obj.%Close()
    If $$$ISOK(sc)
    {
         s id = nobj.%Id()
         
        //复制到扩展属性表MKB_TermExtendPro
        s oldcatids=""  //原扩展属性的id拼串
        s newcatids=""  //现扩展属性的id拼串
        s MKBTPRowId=copypro,MKBTEPChildsub=0
        for 
        {	
            S MKBTEPChildsub=$o(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId,"ChildExtPro",MKBTEPChildsub)) q:MKBTEPChildsub=""
            s MKBTEPRowId=MKBTPRowId_"||"_MKBTEPChildsub  
            s:oldcatids'="" oldcatids=oldcatids_"^"_MKBTEPRowId
            s:oldcatids="" oldcatids=MKBTEPRowId     
            
            s objc=##class(CT.WDT.CDSS.TermExtendPro).%New(id)
            d objc.ParRefSetObjectId(id)
            s objc.MKBTEPName=$listGet($g(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId,"ChildExtPro",MKBTEPChildsub)),2)
            s idc =""
            s genLength=$d(^CT.WDT.CDSS.TermExtendProI("NameIndex",id," "_$ZCONVERT(objc.MKBTEPName,"U")))
            if (genLength=0)
            {
                s objc.MKBTEPType=$listGet($g(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId,"ChildExtPro",MKBTEPChildsub)),3)
                s objc.MKBTEPConfig=$listGet($g(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId,"ChildExtPro",MKBTEPChildsub)),4)   
                s scc=objc.%Save()
                do objc.%Close()
                if $$$ISOK(scc)
                {
                    s idc = objc.%Id()
                }
                else
                {
                    s result="false"
                }
            }
            else
            {
                s idc=$o(^CT.WDT.CDSS.TermExtendProI("NameIndex",id," "_$ZCONVERT(objc.MKBTEPName,"U"),0))
            }
            s:newcatids'="" newcatids=newcatids_"^"_idc
            s:newcatids="" newcatids=idc
            
        }

        //术语扩展属性表明细表 TKB_TremExtendDetail
        if (copyall'="")  //完全复制，要复制属性内容
        {
            s rs=""
            s MKBTPType=$listGet($g(^CT.WDT.CDSS.TermPropertyD(copypro)),4)
            if (MKBTPType="T")  //如果是树形属性，则要用递归，一级一级复制
            {
                s rs=..CopyTreeDetail("TreeRoot", copypro, id, oldcatids,newcatids)
            }
            else  //如果是其他格式的属性，则按rowid循环
            {
                s rs=..CopyListDetail(copypro, id, oldcatids,newcatids)
            }
            if (rs["false")
            {
                s result="false"
            }
    
        }
    }
    else
    {
        s result = "false"

    }
    if (result["false"){
        Trollback
        s result = "{success:'false',errorinfo:'复制失败！'}"
    }else{
        TC
        s result = "{success:'true',info:'复制成功！'}" //返回RowId
    }
    q result
}

/// Creator:丁亚男
/// CreatDate:2018-04-03
/// Desc:复制树形属性内容
/// Input：LastLevel-上级分类，copypro复制的属性，id 新加的属性 ,oldcatids-扩展属性ID
/// Return：成功返回success:'true'；失败返回success:'false'
/// Others:w ##class(web.CDSS.CMKB.TermProperty).CopyTreeDetail("TreeRoot")
ClassMethod CopyTreeDetail(LastLevel, copypro, id, oldcatids, newcatids) As %String
{
    
    
    s result=""
    q:(copypro="")||(id="") "false"
    if (LastLevel="TreeRoot") s LastLevel=-100000000000000
    s RowId=""
    ts
    for {
        s RowId=$o(^CT.WDT.CDSS.TermProDetailI("ProParIndex",copypro,LastLevel,RowId)) 
        q:(RowId="")||(result="false")
       
        s eobj = ##class(web.CDSSEntity.CMKB.TermProDetail).%New()
        s pobj = ##class(CT.WDT.CDSS.TermProDetail).%OpenId(RowId)
        s eobj.MKBTPDCode = pobj.MKBTPDCode
        s eobj.MKBTPDDesc = pobj.MKBTPDDesc
        s eobj.MKBTPDProDR = id
        if (pobj.MKBTPDLastLevel'="")   //树形
        {
          
            s parentid=""
            s MKBTPDLastLevel = pobj.MKBTPDLastLevel.%Id() //复制的父节点的id 
            s parentcode =$listGet($g(^CT.WDT.CDSS.TermProDetailD(MKBTPDLastLevel)),2)  //父节点的代码
            s parentcode=$ZCONVERT(parentcode,"U") //转换成大写    
            s parentid=$o(^CT.WDT.CDSS.TermProDetailI("CodeIndex",id," "_parentcode,0))  //父节点
            s eobj.MKBTPDLastLevel=parentid  
                         
        }
        s eobj.MKBTPDLevel = pobj.MKBTPDLevel
        s eobj.MKBTPDActiveFlag=pobj.MKBTPDActiveFlag
        s eobj.MKBTPDRemark = pobj.MKBTPDRemark
                
        if (oldcatids'="")  
        {
            s MKBTPDExtend=""
            s argsLen=$Length(oldcatids,"^")
            for i=1:1:argsLen   
            {
                s extendDr=$p(oldcatids,"^",i)  
                s MKBTEPVValue=""  //扩展属性子表字段的值-存在CT.WDT.CDSS.TermExtendVal表
                s MKBTEPVRowId=$o(^CT.WDT.CDSS.TermExtendProValI("ValIndex",RowId,extendDr,0))
                s:MKBTEPVRowId'="" MKBTEPVValue=$LISTGET($g(^CT.WDT.CDSS.TermExtendProValD(MKBTEPVRowId)),4)
                s newextendDr=$p(newcatids,"^",i) 
                s newchild=$p(newextendDr,"||",2)  //知识点扩展属性子表的child值
                s:MKBTPDExtend'="" MKBTPDExtend=MKBTPDExtend_"[N]"_newchild_"[A]"_MKBTEPVValue
                s:MKBTPDExtend="" MKBTPDExtend=newchild_"[A]"_MKBTEPVValue
            }
            s eobj.MKBTPDExtend=MKBTPDExtend
        }
                    
        s res=##class(web.CDSS.CMKB.TermProDetail).SaveData(eobj)
    	
        d eobj.%Close()
        d pobj.%Close() 
       
        if (res["true"){
            if ($d(^CT.WDT.CDSS.TermProDetailI("ProParIndex",copypro,RowId))){
	            
                d ..CopyTreeDetail(RowId,copypro,id,oldcatids, newcatids)  
            }else{
                continue    
            }
        }else{
            s result="false"   
        }
       
    }
    
    if (result="")
    {
        tc
        s result="true"
    }
    else
    {
        tro
        s result="false"
    }
    q result
}

/// Creator:丁亚男
/// CreatDate:2018-04-03
/// Desc:复制列表和其他（除树形以外）的属性内容
/// Input：LastLevel-上级分类，copypro复制的属性，id 新加的属性 ,oldcatids-扩展属性ID
/// Return：成功返回success:'true'；失败返回success:'false'
/// Others:w ##class(web.CDSS.CMKB.TermProperty).CopyTreeDetail("TreeRoot")
ClassMethod CopyListDetail(copypro, id, oldcatids, newcatids) As %String
{
   
    s result=""
    q:(copypro="")||(id="") "false"
    s RowId=""
    ts
    s RowId=0
    for  
    {   
        s RowId=$o(^CT.WDT.CDSS.TermProDetailI("ProIdx",copypro,RowId)) q:RowId="" 
        q:(RowId="")||(result="false")
        
        s eobj = ##class(web.CDSSEntity.CMKB.TermProDetail).%New()
        s pobj = ##class(CT.WDT.CDSS.TermProDetail).%OpenId(RowId)
        s eobj.MKBTPDCode = ""
        s eobj.MKBTPDDesc = pobj.MKBTPDDesc
        s eobj.MKBTPDDesc = ##class(web.DHCBL.BDP.FunLib).Util(eobj.MKBTPDDesc)
        continue:eobj.MKBTPDDesc=""
        s eobj.MKBTPDProDR = id
        s eobj.MKBTPDLastLevel=""                            
        s eobj.MKBTPDLevel = ""
        s eobj.MKBTPDActiveFlag=pobj.MKBTPDActiveFlag
        s eobj.MKBTPDRemark = pobj.MKBTPDRemark
                
        if (oldcatids'="")  
        {
            s MKBTPDExtend=""
            s argsLen=$Length(oldcatids,"^")
            for i=1:1:argsLen   
            {
                s extendDr=$p(oldcatids,"^",i)  
                s MKBTEPVValue=""  //扩展属性子表字段的值-存在User.TKBTremExtendVal表
                s MKBTEPVRowId=$o(^CT.WDT.CDSS.TermExtendProValI("ValIndex",RowId,extendDr,0))
                s:MKBTEPVRowId'="" MKBTEPVValue=$listget($g(^CT.WDT.CDSS.TermExtendProValD(MKBTEPVRowId)),4)
                s newextendDr=$p(newcatids,"^",i) 
                s newchild=$p(newextendDr,"||",2)  //知识点扩展属性子表的child值
                s:MKBTPDExtend'="" MKBTPDExtend=MKBTPDExtend_"[N]"_newchild_"[A]"_MKBTEPVValue
                s:MKBTPDExtend="" MKBTPDExtend=newchild_"[A]"_MKBTEPVValue
            }
            s eobj.MKBTPDExtend=MKBTPDExtend
        }
                    
        s res=##class(web.CDSS.CMKB.TermProDetail).SaveData(eobj)
    
        d eobj.%Close()
        d pobj.%Close()                         
       
        if (res["false"){
            s result="false"   
        }
       
    }
    
    if (result="")
    {
        tc
        s result="true"
    }
    else
    {
        tro
        s result="false"
    }
    q result
}

/// Creator:丁亚男
/// CreatDate:2018-04-03
/// Description：复制属性及知识点到其他术语
/// Table：CT.WDT.CDSS.TermProperty
/// Input：termStr-术语id串 ，copypro-属性id, copyall-不为空的时候完全复制，为空的时候只复制格式
/// Return：成功返回success:'true' ,失败返回success:'false'
/// w ##class(web.CDSS.CMKB.TermProperty).CopyToOtherTrem("65656^65666","171563","")
ClassMethod CopyToOtherTrem(termStr, copypro, copyall) As %String
{
    s result=""
    s validateinfo=""  //校验不通过的术语
    //TS
    if (termStr'="")
    {
          s termsLen=$Length(termStr,"^")
          for i=1:1:termsLen   
          {
            s MKBTRowId=$p(termStr,"^",i)
            s result=..SaveCopyData(MKBTRowId,copypro,copyall)
            
            if (result["false")
            {
                q
            }
        }
    }
	
    if (result["false"){
       // Trollback
    }else{
        //TC
        s result = "{success:'true',info:'复制成功！'}" //返回RowId
    }
    q result
}

/// Creator:丁亚男
/// CreatDate:2018-04-03
/// Description：复制属性及知识点
/// Table：User.TKBTremExtend
/// Input：dia-诊断条目id ，copypro-属性id,copyall-不为空的时候完全复制，为空的时候只复制格式
/// Return：成功返回success:'true'；失败返回success:'false'
/// w ##class(web.CDSS.CMKB.TermProperty).SaveCopyData("41208","51144","2")
ClassMethod SaveCopyData(dia, copypro, copyall) As %String
{
    s result = ""
    q:(dia="")||(copypro="") "{success:'false',errorinfo:'没有选中术语或没有选择属性'}"
    
    s diaDesc=$listget($g(^CT.WDT.CDSS.TermD(dia)),3)  //术语描述
    
    //复制到术语扩展属性表： CT_WDT_CDSS.TermProperty
    s obj=##class(CT.WDT.CDSS.TermProperty).%OpenId(copypro)
    if (copyall="2")
    {
		s obj.MKBTPDesc=obj.MKBTPDesc_"1"
		
		//生成编码规则
		s obj.MKBTPCodeRules=##class(web.DHCBL.BDP.FunLib).GetPYCODE(obj.MKBTPDesc)
		
		//生成属性代码：术语代码-术语属性编码规则
		s StartCode=$listGet($g(^CT.WDT.CDSS.TermD(obj.MKBTPTermDr)),2)  //代码
		s obj.MKBTPCode=StartCode_"-"_obj.MKBTPCodeRules
		
		//s obj.MKBTPCode=obj.MKBTPCode_"1"
	}
    s nobj=##class(CT.WDT.CDSS.TermProperty).%New()
    s flag=..FormValidate("",obj.MKBTPCode,obj.MKBTPDesc,dia,obj.MKBTPCodeRules)  //调用重复验证
    
    s errorinfo="复制失败！"_diaDesc_"已经存在"_obj.MKBTPDesc_"!"  //错误信息
    s repeatPro=$o(^CT.WDT.CDSS.TermPropertyI("DescIndex",dia," "_$ZCONVERT(obj.MKBTPDesc,"U"),0))  //重复的属性ID
    q:(flag=1) "{success:'false',errorinfo:'"_errorinfo_"',repeatPro:'"_repeatPro_"'}"
	
    s nobj.MKBTPCode = obj.MKBTPCode
    s nobj.MKBTPDesc = obj.MKBTPDesc
    s nobj.MKBTPType = obj.MKBTPType
    s nobj.MKBTPConfig = obj.MKBTPConfig
    d nobj.MKBTPTermDrSetObjectId(dia)
    s nobj.MKBTPName=obj.MKBTPName
    s nobj.MKBTPFlag=obj.MKBTPFlag
    s nobj.MKBTPPublic=obj.MKBTPPublic
    if (obj.MKBTPDefinedNode'="")
    {
        s nobj.MKBTPDefinedNode=obj.MKBTPDefinedNode
    }
	//s nobj.MKBTPSequence=..GetLastSequence(dia)
	s nobj.MKBTPSequence=obj.MKBTPSequence
	s nobj.MKBTPCodeRules=obj.MKBTPCodeRules
	
    TS
    s sc=nobj.%Save()
    d nobj.%Close()
    d obj.%Close()
    If $$$ISOK(sc)
    {
        s id = nobj.%Id()
		//复制到扩展属性表MKB_TermExtendPro
        s oldcatids=""  //原扩展属性的id拼串
        s newcatids=""  //现扩展属性的id拼串
        s MKBTPRowId=copypro,MKBTEPChildsub=0
        for 
        {
            S MKBTEPChildsub=$o(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId,"ChildExtPro",MKBTEPChildsub)) q:MKBTEPChildsub=""
            s MKBTEPRowId=MKBTPRowId_"||"_MKBTEPChildsub  
            s:oldcatids'="" oldcatids=oldcatids_"^"_MKBTEPRowId
            s:oldcatids="" oldcatids=MKBTEPRowId     
            
            s objc=##class(CT.WDT.CDSS.TermExtendPro).%New(id)
            d objc.ParRefSetObjectId(id)
            s objc.MKBTEPName=$listGet($g(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId,"ChildExtPro",MKBTEPChildsub)),2)
            s idc =""
            s genLength=$d(^CT.WDT.CDSS.TermExtendProI("NameIndex",id," "_$ZCONVERT(objc.MKBTEPName,"U")))
            if (genLength=0)
            {
                s objc.MKBTEPType=$listGet($g(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId,"ChildExtPro",MKBTEPChildsub)),3)
                s objc.MKBTEPConfig=$listGet($g(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId,"ChildExtPro",MKBTEPChildsub)),4) 
                s objc.MKBTEPSequence=$listGet($g(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId,"ChildExtPro",MKBTEPChildsub)),5)   
                s scc=objc.%Save()
                do objc.%Close()
                if $$$ISOK(scc)
                {
                    s idc = objc.%Id()
                }
                else
                {
                    s result="false"
                }
            }
            else
            {
                s idc=$o(^CT.WDT.CDSS.TermExtendProI("NameIndex",id," "_$ZCONVERT(objc.MKBTEPName,"U"),0))
            }
            s:newcatids'="" newcatids=newcatids_"^"_idc
            s:newcatids="" newcatids=idc
            
        }
        
        //术语扩展属性表明细表 TKB_TremExtendDetail
        if (copyall'="")  //完全复制，要复制属性内容
        {
            s rs=""
            s MKBTPType=$listGet($g(^CT.WDT.CDSS.TermPropertyD(copypro)),4)
            if (MKBTPType="T")  //如果是树形属性，则要用递归，一级一级复制
            {
                
                s rs=..CopyTreeDetail("TreeRoot", copypro, id, oldcatids,newcatids)
            }
            else  //如果是其他格式的属性，则按rowid循环
            {
                s rs=..CopyListDetail(copypro, id, oldcatids,newcatids)
            }
            if (rs["false")
            {
                s result="false"
            }
    
        }
    }
    else
    {
        s result = "false"

    }
    if (result["false"){
        Trollback
        s result = "{success:'false',errorinfo:'复制失败！'}"
    }else{
        TC
        s result = "{success:'true',info:'复制成功！'}" //返回RowId
    }
    q result
}

/// Description：复制属性到其他诊断时，如果其他诊断有重复的属性信息，则获取到该信息
/// Table：CT.WDT.CDSS.TermProperty
/// Input：cat-属性ID
/// Return:术语ID^来源^属性描述
/// Date:2018-04-08
/// create：丁亚男
/// Other:w ##class(web.CDSS.CMKB.TermProperty).GetRepeatProInfo(pro)
ClassMethod GetRepeatProInfo(pro As %String) As %String
{
    s result=""
    if (pro'="")
    {
        s MKBTPDesc=$listget($g(^CT.WDT.CDSS.TermPropertyD(pro)),3)  //描述
        s MKBTPType=$listget($g(^CT.WDT.CDSS.TermPropertyD(pro)),4)  //类型
        s MKBTPTermDr=$listget($g(^CT.WDT.CDSS.TermPropertyD(pro)),6) //指向的术语
        s MKBTDesc=""
        s:MKBTPTermDr'="" MKBTDesc=$listget($g(^CT.WDT.CDSS.TermD(MKBTPTermDr)),"^",3)  //术语描述
        s:MKBTDesc'="" MKBTDesc=MKBTDesc_"-"_MKBTPDesc_"属性"  ////术语描述-属性描述
        s result=MKBTPType_"^"_MKBTPTermDr_"^"_MKBTDesc
    }

    q result
}

/// Creator:丁亚男
/// CreatDate:2019-10-09
/// Description：如果知识库编码规则已存在，后面追加1
/// Input: 
/// return:新的编码
/// Other:w ##class(web.CDSS.CMKB.TermProperty).MKBTBCodeRules("16354","DT")
ClassMethod MKBTBCodeRules(MKBTBRowId As %String, CodeRules As %String) As %String
{
	s flag1="",MKBTBCodeRules=CodeRules
	s flag1=##class(web.CDSS.CMKB.TermBase).ValidateCodeRules(MKBTBRowId,CodeRules)
    if (flag1=1) 
    {
	    s result=CodeRules_"1"
	    s MKBTBCodeRules=##class(web.CDSS.CMKB.TermProperty).MKBTBCodeRules(MKBTBRowId,result)
	} 
	q MKBTBCodeRules
}

/// Description：树形和列表型属性升级为术语
/// Table：CT.WDT.CDSS.TermProperty
/// Input：pro-属性ID
/// Return:true/false
/// Date:2018-03-28
/// creator：丁亚男
/// Other:w ##class(web.CDSS.CMKB.TermProperty).PromotePro(396580)
ClassMethod PromotePro(pro As %String) As %String
{
    q:pro="" "{success:'false',errorinfo:'请选中要升级的属性！'}" 
    //
    s result=""
    s MKBTPTermDr=$listGet($g(^CT.WDT.CDSS.TermPropertyD(pro)),6)  //术语ID
    s MKBTPDesc=$listGet($g(^CT.WDT.CDSS.TermPropertyD(pro)),3)  //属性描述
    s MKBTPType=$listGet($g(^CT.WDT.CDSS.TermPropertyD(pro)),4)  //属性类型
    q:MKBTPTermDr="" "{success:'false',errorinfo:'没有获取到该属性所属的术语！'}" 
    s MKBTBaseDR=$listGet($g(^CT.WDT.CDSS.TermD(MKBTPTermDr)),4)  //术语注册ID
    q:MKBTBaseDR="" "{success:'false',errorinfo:'没有获取到该术语所属的术语注册ID！'}" 
    s MKBTBCatDr=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(MKBTBaseDR)),9) //术语分类
    /*s MKBTBCDesc=""
    s:MKBTBCatDr'="" MKBTBCDesc=##class(web.CDSS.CMKB.TermBase).GetCatText(MKBTBCatDr)  ///术语分类描述 
    s baseDesc=MKBTBCDesc  // 术语注册名
    s:MKBTPDesc'="" baseDesc=MKBTBCDesc_"_"_MKBTPDesc*/
	s baseDesc=MKBTPDesc
	
    s errorFlag=""  //错误标识      
    //在术语库注册生成一条数据。
    s base=""
    s baseCode=##class(web.CDSS.CMKB.TermBase).GetLastCode()  
    s eobj=##class(web.CDSSEntity.CMKB.TermBase).%New()
    s eobj.MKBTBRowId=""
    s eobj.MKBTBCode = baseCode                   
    s eobj.MKBTBDesc = baseDesc                      
    s eobj.MKBTBType = MKBTPType 
    s eobj.MKBTBPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE($ZCONVERT(baseDesc,"U"))
    s eobj.MKBTBCodeRules=##class(web.DHCBL.BDP.FunLib).GetPYCODE($ZCONVERT(baseDesc,"U"))
    s eobj.MKBTBCodeRules=##class(web.CDSS.CMKB.TermProperty).MKBTBCodeRules(eobj.MKBTBRowId,eobj.MKBTBCodeRules)
    s eobj.MKBTBCatDr=MKBTBCatDr
    
    TS
    s result1=##class(web.CDSS.CMKB.TermBase).SaveEntity(eobj)
    
    
    if (result1["true")
    {
        s base=$p(result1,"'",4)  //术语注册ID
        if (base'="")
        {
            //循环扩展属性表
            s proID=""   //扩展属性表ＩＤ
            s fieldID="" //术语库注册属性ID 
            s MKBTPRowId=pro,MKBTEPChildsub=0
            for 
            {
                S MKBTEPChildsub=$o(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId,"ChildExtPro",MKBTEPChildsub)) q:(MKBTEPChildsub="")||(errorFlag="N")
                s MKBTEPRowId=MKBTPRowId_"||"_MKBTEPChildsub
                s MKBTEPName=$listGet($g(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId,"ChildExtPro",MKBTEPChildsub)),2)
                s MKBTEPType=$listGet($g(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId,"ChildExtPro",MKBTEPChildsub)),3)
                s MKBTEPConfig=$listGet($g(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId,"ChildExtPro",MKBTEPChildsub)),4)
                //s MKBTPConfig=$tr(MKBTPConfig,"&%","&%")  //把配置项的,替换成^
                
                //扩展属性表的内容保存进术语库注册字段表
                s eobjf=##class(web.CDSSEntity.CMKB.TermBaseProperty).%New(base)

                s eobjf.MKBTBPCode =MKBTEPName   //  ##class(web.DHCBL.BDP.FunLib).GetPYCODE($ZCONVERT(MKBTEPName,"U"))   
                s eobjf.MKBTBPDesc = MKBTEPName
                s eobjf.MKBTBPType = MKBTEPType
                //s eobjf.TKBTRBNote =  ""
                s eobjf.MKBTBPConfig = MKBTEPConfig
                s eobjf.MKBTBPFlag = ""
                //s eobjf.TKBTRBSort =##class(web.CDSS.CMKB.TKBTremBaseField).GetLastSort(base)+1
                //s eobjf.TKBTRBRequire = "N"
                //s eobjf.MKBTBPRowId=""
                s eobjf.MKBTBPBaseDr=base
                if eobjf.MKBTBPDesc="别名" continue
                s resultf= ##class(web.CDSS.CMKB.TermBaseProperty).SaveEntity(eobjf)
                
                if (resultf["true")
                {
                    s:fieldID'="" fieldID=fieldID_"^"_$p(resultf,"'",4)  //术语注册属性ID
                    s:fieldID="" fieldID=$p(resultf,"'",4)  //术语注册属性ID
                    
                    s:proID'="" proID=proID_"^"_MKBTEPRowId  //扩展属性表ID
                    s:proID="" proID=MKBTEPRowId  //扩展属性表ID
                }
                else
                {
                    s errorFlag="N"
                }
                d eobjf.%Close()
            }
            
            if (errorFlag="N")
            { 
                s result="{success:'false',errorinfo:'扩展属性升级到术语库注册字段时出现问题！'}" 
            }
			
            //循环属性明细表,把属性内容升级到术语
            s resultDetail=""
            if (MKBTPType="T"){  
                s resultDetail=..PromoteTreeDetail("TreeRoot", pro, base, proID, fieldID)
            }
            else{
                s resultDetail=..PromoteListDetail(pro, base, proID, fieldID)
            }
    
            if (resultDetail["false")
            {
                s result= "{success:'false',errorinfo:'属性内容升级到术语维护界面时出现问题！'}"
            }
        }
        else
        {
            s result="{success:'false',errorinfo:'术语库注册失败！'}" 
        }
    }
    else
    {
        s result="{success:'false',errorinfo:'术语库注册失败！'}" 
    }
    d eobj.%Close()
    
    if (result["false")
    {
        tro
    }
    else
    {
        tc
        s result="{success:'true',info:'升级术语成功！',baseCode:'"_baseCode_"',baseDesc:'"_baseDesc_"'}"
    }
    q result
}

/// Creator:丁亚男
/// CreatDate:2018-03-28
/// Desc:复制树形属性内容
/// Input：LastLevel-上级分类，base-升级成的新术语注册ID，pro升级的属性，extID 扩展属性ID，fieldID术语库注册字段ID
/// Return：成功返回success:'true'；失败返回success:'false'
/// Others:w ##class(web.CDSS.CMKB.TermProperty).PromoteTreeDetail("TreeRoot", pro, base, extID, fieldID))
ClassMethod PromoteTreeDetail(LastLevel, pro, base, extID, fieldID) As %String
{
    s result=""
    s errorFlag=""
    q:(pro="")||(base="") "false"
    if (LastLevel="TreeRoot") s LastLevel=-100000000000000
    ts
    //循环属性内容表
    s MKBTPDRowId=0
    for  
    {   
        s MKBTPDRowId=$o(^CT.WDT.CDSS.TermProDetailI("ProParIndex",pro,LastLevel,MKBTPDRowId)) q:(MKBTPDRowId="")||(errorFlag="N")
        s MKBTPDCode=$listGet($g(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),2)  //代码
        s MKBTPDDesc=$listGet($g(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),3)  //描述
        s MKBTPDRemark=$listGet($g(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),7) //说明
        s MKBTPDLastLevel=$listGet($g(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),4) //上级分类
        s MKBTPDProDR=$listGet($g(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),6) //属性id
        
        s parentId=""
        if (MKBTPDLastLevel'="")   //树形的有上级分类的要重新获取id
        {   
           
            /*s parentCode =$listGet($g(^CT.WDT.CDSS.TermProDetailD(MKBTPDLastLevel)),2)  //父节点的代码
            s parentCode=$ZCONVERT(parentCode,"U") //转换成大写    
            s parentId=$o(^CT.WDT.CDSS.TermI("CodeIndex",base," "_parentCode,0))  //父节点 */
            //改了编码规则之后，不能用代码找id,修改取父节点id的方法  改成记录上次保存术语的rowid
            s parentId=$p(^TMPLASTTERMID("MKBDTResult"),"'",4)
                            
        }
                       
        //属性内容表的值保存到术语表
        s eobjt = ##class(web.CDSSEntity.CMKB.Term).%New()
        s eobjt.MKBTRowId = ""
        //s eobjt.MKBTCode = MKBTPDCode
        s eobjt.MKBTDesc = MKBTPDDesc
        s eobjt.MKBTBaseDR=base
        s eobjt.MKBTPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE($ZCONVERT(MKBTPDDesc,"U")) 
        s eobjt.MKBTNote = MKBTPDRemark
        s eobjt.MKBTLastLevel=parentId
        s resultt= ##class(web.CDSS.CMKB.Term).SaveData(eobjt)
        s ^TMPLASTTERMID("MKBDTResult")=resultt
        if (resultt["true"){
	        //获取扩展属性的值 除了别名
	        s termdr=$p(resultt,"'",4)
	        s MKBTPConfig=""
	        if (extID'="")
	        {
	              s extIDLen=$Length(extID,"^")
	              for i=1:1:extIDLen   
	              {
	          
	                  
	                  s MKBTEPRowId=$p(extID,"^",i) //扩展属性表ID
	                  s MKBTEPVRowId=$o(^CT.WDT.CDSS.TermExtendProValI("ValIndex",MKBTPDRowId,MKBTEPRowId,0))  //扩展属性值表ID
	                  s MKBTEPVValue=""
	                  s:MKBTEPVRowId'="" MKBTEPVValue=$listGet($g(^CT.WDT.CDSS.TermExtendProValD(MKBTEPVRowId)),4)  //扩展属性值
	                  s field=$p(fieldID,"^",i) //术语库注册属性ID
	                  s MKBTBPDesc=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(field)),3)
	                  s MKBTBPDescU=$ZCONVERT(MKBTBPDesc,"U") //转换成大写    
           			  s prodr=$o(^CT.WDT.CDSS.TermPropertyI("DescIndex",termdr," "_MKBTBPDescU,0))  //父节点
           			  
	                  if ((MKBTEPVValue'="")&(prodr'="")){
						  s obj=##class(web.CDSSEntity.CMKB.TermProDetail).%New()
						  
						  s obj.MKBTPDDesc=MKBTEPVValue
					 	  s obj.MKBTPDProDR=prodr
					 	  
						  s resultpd= ##class(web.CDSS.CMKB.TermProDetail).SaveData(obj)
						  
						  if (resultpd["false")
						  {
							  s result="false"  
						  }
						  d obj.%Close()
	              	}
	              }
	        }
	        
	        //单独处理别名
	        s AliasRowid=$o(^CT.WDT.CDSS.TermExtendProI("NameIndex",MKBTPDProDR," 别名",0))     ;如果存在别名则取值
			if AliasRowid'=""
			{
				s PCRowid = MKBTPDProDR_"||"_AliasRowid 
				s rowid=$o(^CT.WDT.CDSS.TermExtendProValI("ValIndex",MKBTPDRowId,PCRowid,0))
				if rowid'=""
				{
					s MKBTEPVValue=$lg(^CT.WDT.CDSS.TermExtendProValD(rowid),4)
					s prodr=$o(^CT.WDT.CDSS.TermPropertyI("DescIndex",termdr," 别名",0))  //父节点
					if ((MKBTEPVValue'="")&(prodr'="")){
						  s obj=##class(web.CDSSEntity.CMKB.TermProDetail).%New()
						  
						  s obj.MKBTPDDesc=MKBTEPVValue
					 	  s obj.MKBTPDProDR=prodr
					 	  
						  s resultpd= ##class(web.CDSS.CMKB.TermProDetail).SaveData(obj)
						  
						  if (resultpd["false")
						  {
							  s result="false"  
						  }
						  d obj.%Close()
	              	}
				}
			} 
			
            if ($d(^CT.WDT.CDSS.TermProDetailI("ProParIndex",pro,MKBTPDRowId))){
                d ..PromoteTreeDetail(MKBTPDRowId,pro, base, extID, fieldID)  
            }else{
                continue    
            }
        }else{
            s result="false"   
        }
       
    }
    
    if (result="")
    {
        tc
        s result="true"
    }
    else
    {
        tro
        s result="false"
    }
    q result
}

/// Creator:丁亚男
/// CreatDate:2018-03-28
/// Desc:复制列表和其他（除树形以外）的属性内容
/// Input：base-升级成的新术语注册ID，pro升级的属性，extID 注册属性ID，fieldID升级的属性扩展属性
/// Return：成功返回success:'true'；失败返回success:'false'
/// Others:w ##class(web.CDSS.CMKB.TermProperty).PromoteListDetail(pro, base, extID, fieldID))
ClassMethod PromoteListDetail(pro, base, extID, fieldID) As %String
{
	
    s result=""
    s errorFlag=""
    q:(pro="")||(base="") "false"
    ts
    //循环属性内容表
    s MKBTPDRowId=0
    for  
    {   
        
        s MKBTPDRowId=$o(^CT.WDT.CDSS.TermProDetailI("ProIdx",pro,MKBTPDRowId)) q:(MKBTPDRowId="")||(errorFlag="N")
        s MKBTPDCode=$listGet($g(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),2)  //代码
        s MKBTPDDesc=$listGet($g(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),3)  //描述
        s MKBTPDRemark=$listGet($g(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),7) //说明
        s MKBTPDLastLevel=$listGet($g(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),4) //上级分类
        s MKBTPDProDR=$listGet($g(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),6) //属性id
        
        s parentId=""
        if (MKBTPDLastLevel'="")   //树形的有上级分类的要重新获取id
        {  
            s parentCode =$listGet($g(^CT.WDT.CDSS.TermProDetailD(MKBTPDLastLevel)),2)  //父节点的代码
            s parentCode=$ZCONVERT(parentCode,"U") //转换成大写    
            s parentId=$o(^CT.WDT.CDSS.TermI("CodeIndex",base,parentCode,0))  //父节点                
        }
                        
        //属性内容表的值保存到术语表
        s eobjt = ##class(web.CDSSEntity.CMKB.Term).%New()
        s eobjt.MKBTRowId = ""
        //s eobjt.MKBTCode = MKBTPDCode
        s eobjt.MKBTDesc = MKBTPDDesc
        s eobjt.MKBTBaseDR=base
        s eobjt.MKBTPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE($ZCONVERT(MKBTPDDesc,"U")) 
        s eobjt.MKBTNote = MKBTPDRemark
        s eobjt.MKBTLastLevel=parentId
        
        s resultt= ##class(web.CDSS.CMKB.Term).SaveData(eobjt)
       	
        if (resultt["true")
        {
            s tremID=$p(resultt,"'",4)  //术语ID
            //获取扩展属性的值
	        s MKBTPConfig=""
	        if (extID'="")
	        {
	              s extIDLen=$Length(extID,"^")
	              for i=1:1:extIDLen   
	              {
					s MKBTEPRowId=$p(extID,"^",i) //扩展属性表ID
					s MKBTEPVRowId=$o(^CT.WDT.CDSS.TermExtendProValI("ValIndex",MKBTPDRowId,MKBTEPRowId,0))  //扩展属性值表ID
					s MKBTEPVValue=""
					s:MKBTEPVRowId'="" MKBTEPVValue=$listGet($g(^CT.WDT.CDSS.TermExtendProValD(MKBTEPVRowId)),4)  //扩展属性值
					s field=$p(fieldID,"^",i) //术语库注册属性ID
	                s MKBTBPDesc=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(field)),3)
	                s MKBTBPDescU=$ZCONVERT(MKBTBPDesc,"U") //转换成大写    
           			s prodr=$o(^CT.WDT.CDSS.TermPropertyI("DescIndex",tremID," "_MKBTBPDescU,0))  //父节点 
	                  
					s obj=##class(web.CDSSEntity.CMKB.TermProDetail).%New()
					  
					s obj.MKBTPDDesc=MKBTEPVValue
				 	s obj.MKBTPDProDR=prodr
				 	  
					//s field=$p(fieldID,"^",i) //术语库注册属性ID
					//s obj=##class(web.CDSSEntity.CMKB.TermProDetail).%New()
					//s obj.MKBTPDDesc=MKBTEPVValue
					//s obj.MKBTPDProDR=field
					s resultpd= ##class(web.CDSS.CMKB.TermProDetail).SaveData(obj)
					
					if (resultpd["false")
					{
						s errorFlag="N"
					}
					d obj.%Close()
	              }
	               //单独处理别名
		        s AliasRowid=$o(^CT.WDT.CDSS.TermExtendProI("NameIndex",MKBTPDProDR," 别名",0))     ;如果存在别名则取值
				if AliasRowid'=""
				{
					s PCRowid = MKBTPDProDR_"||"_AliasRowid 
					s rowid=$o(^CT.WDT.CDSS.TermExtendProValI("ValIndex",MKBTPDRowId,PCRowid,0))
					if rowid'=""
					{
						s MKBTEPVValue=$lg(^CT.WDT.CDSS.TermExtendProValD(rowid),4)
						s prodr=$o(^CT.WDT.CDSS.TermPropertyI("DescIndex",termdr," 别名",0))  //父节点
						if ((MKBTEPVValue'="")&(prodr'="")){
							  s obj=##class(web.CDSSEntity.CMKB.TermProDetail).%New()
							  
							  s obj.MKBTPDDesc=MKBTEPVValue
						 	  s obj.MKBTPDProDR=prodr
						 	  
							  s resultpd= ##class(web.CDSS.CMKB.TermProDetail).SaveData(obj)
							  
							  if (resultpd["false")
							  {
								  s errorFlag="N"  
							  }
							  d obj.%Close()
		              	}
					}
				} 
	        }
        }
        else
        {
            s errorFlag="N"
        }
        d eobjt.%Close()

    }
    
    if (errorFlag="")
    {
        tc
        s result="true"
    }
    else
    {
        tro
        s result="false"
    }
    q result
}

/// Description：树形和列表型属性升级为公有属性
/// Table：CT.WDT.CDSS.TermProperty
/// Input：pro-属性ID
/// Return:true/false
/// Date:2018-4-2
/// creator：丁亚男
/// Other:w ##class(web.CDSS.CMKB.TermProperty).PromoteProToPublic(31475)
ClassMethod PromoteProToPublic(pro As %String) As %String
{
    q:pro="" "{success:'false',errorinfo:'请选中要升级的属性！'}" 
    
    s result=""
    
    s MKBTPCode=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(pro)),2)  //代码
    s MKBTPDesc=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(pro)),3)  //描述
    s MKBTPType=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(pro)),4)
    s MKBTPConfig=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(pro)),5)
    s MKBTPTermDr=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(pro)),6)
    q:MKBTPTermDr="" "{success:'false',errorinfo:'没有获取到该属性所属的术语！'}" 
    s base=$LISTGET($G(^CT.WDT.CDSS.TermD(MKBTPTermDr)),4)  //术语注册ID
    q:base="" "{success:'false',errorinfo:'没有获取到该术语所属的术语注册ID！'}" 
    s MKBTPName=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(pro)),7)  //描述
    s MKBTPFlag=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(pro)),8)  //标识
    s MKBTPPublic=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(pro)),9)  //是否是公有属性
    s DefinedNode=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(pro)),10)  //定义初始节点
        

    s errorFlag=""  //错误标识      
    //在术语库注册-属性维护 生成一条数据。
    s eobj=##class(web.CDSSEntity.CMKB.TermBaseProperty).%New()
    s eobj.MKBTBPRowId=""
    //s eobj.MKBTBPCode = MKBTPCode                   
    s eobj.MKBTBPDesc = MKBTPDesc                      
    s eobj.MKBTBPType = MKBTPType 
    s eobj.MKBTBPConfig=MKBTPConfig      
    s eobj.MKBTBPBaseDr=base
    s eobj.MKBTBPName=MKBTPName
    s eobj.MKBTBPFlag=MKBTPFlag
    
    TS
    s result1=##class(web.CDSS.CMKB.TermBaseProperty).SaveEntity(eobj)
    
    if (result1["true")||(result1["repeat")
    {
        s parRef=$p(result1,"'",4)  //术语注册-属性表ID
       
        if (parRef'="")
        {
            //循环扩展属性表 
            s MKBTPRowId=pro,MKBTEPChildsub=0
            for 
            {
                S MKBTEPChildsub=$o(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId,"ChildExtPro",MKBTEPChildsub)) q:(MKBTEPChildsub="")||(result["false")
                s MKBTEPRowId=MKBTPRowId_"||"_MKBTEPChildsub
                s MKBTEPName=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId,"ChildExtPro",MKBTEPChildsub)),2)
                s MKBTEPType=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId,"ChildExtPro",MKBTEPChildsub)),3)
                s MKBTEPConfig=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId,"ChildExtPro",MKBTEPChildsub)),4)
                s MKBTEPConfig=$tr(MKBTEPConfig,",","^")  //把配置项的,替换成^
                
                //扩展属性表的内容保存进术语库注册-扩展属性表
                s eobjc = ##class(web.CDSSEntity.CMKB.TermBaseExtendPro).%New()
                s eobjc.MKBTBEPRowId = ""
                s eobjc.MKBTBEPParRef=parRef
                s eobjc.MKBTBEPConfig=MKBTEPConfig
                s eobjc.MKBTBEPName=MKBTEPName
                s eobjc.MKBTBEPType=MKBTEPType

                s resultc= ##class(web.CDSS.CMKB.TermBaseExtendPro).SaveEntity(eobjc)
				
                if (resultc["false")
                {
                    s result=resultc
                }

                d eobjc.%Close()
            }


        }
        else
        {
            s result="{success:'false',errorinfo:'术语库属性注册失败！'}" 
        }

    }
    else
    {
        s result=result1
    }
    d eobj.%Close()
   
    if (result["false")
    {
        tro
    }
    else
    {
        tc
        if (result1["repeat"){
	       
	        s str=$p(result1,"'",6)  //重复的属性
        	s result="{success:'true',info:'"_str_"'}"
        }
        else{
	        s result="{success:'true',info:'把该属性升级为公有属性升级成功！'}"
	        }
        
    }
    q result
}

/// Description：获取常用名/别名列表(AL)及拼音码
/// Table：CT.WDT.CDSS.TermProperty
/// Input：termdr
/// Return:常用名/别名列表(AL)||拼音码
/// Date:2018-5-8
/// creator：丁亚男
/// Other:w ##class(web.CDSS.CMKB.TermProperty).GetComOrAlias(14626)
/// Description:获取常用名(C)或别名(A)||拼音码
ClassMethod GetComOrAlias(termdr As %String) As %String
{
	q:(termdr="") ""
	q:('$d(^CT.WDT.CDSS.TermPropertyI("FlagIndex",termdr," AL"))) ""
	s str="",keyStr=""
	
	s comPropertyId=$o(^CT.WDT.CDSS.TermPropertyI("FlagIndex",termdr," AL",0)) //常用名的属性id
	
	s MKBTPRowId=$o(^CT.WDT.CDSS.TermPropertyI("FlagIndex",termdr," AL",0)) 
	s MKBTPDSequence=""
	for  
	{	
		s MKBTPDSequence=$o(^CT.WDT.CDSS.TermProDetailI("SeqIndex",MKBTPRowId,MKBTPDSequence)) q:MKBTPDSequence=""
		s MKBTPDRowId=0   //常用名的属性内容ID
		for 
		{
			s MKBTPDRowId=$o(^CT.WDT.CDSS.TermProDetailI("SeqIndex",MKBTPRowId,MKBTPDSequence,MKBTPDRowId)) q:MKBTPDRowId="" 

			s MKBTPDDesc=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),3)
			s MKBTPDDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPDDesc)
			
			//s comPY=##class(web.CDSS.CMKB.TermProDetail).GetExtendVal(MKBTPDRowId,comPropertyId,"检索码")   //检索码
			s comPY=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),10)  //检索码

			s:keyStr'="" keyStr=keyStr_","_comPY
			s:keyStr="" keyStr=comPY	

			s:str'="" str=str_","_MKBTPDDesc
			s:str="" str=MKBTPDDesc	
		}
		
	}
 	q str_"||"_keyStr
}

/// Creator：丁亚男
/// CreatDate: 2018-05-14
/// Description：保存修改属性名称
/// Table：CT.WDT.CDSS.TermProperty
/// Input：RowId-属性id,MKBTPDesc属性名称
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// w ##class(web.CDSS.CMKB.TermProperty).UpdateProperty(33551,"ceshi","")
ClassMethod UpdateProperty(RowId As %String, MKBTPDesc As %String, MKBTPDDesc As %String) As %String
{
	
	s result = ""
	if (RowId["MKBT")
	{
		s desc=$p(RowId,"-",1)	
		s termdr=$p(RowId,"-",2)
		s bobj=##class(web.CDSSEntity.CMKB.Term).%New()
		s obj=##class(CT.WDT.CDSS.Term).%OpenId(termdr)
		if (desc="MKBTDesc")
	    {
		    s bobj.MKBTRowId = termdr
		    s bobj.MKBTCode = obj.MKBTCode
			s bobj.MKBTDesc = MKBTPDDesc
			s:obj.MKBTBaseDR'="" bobj.MKBTBaseDR = obj.MKBTBaseDR.%Id()
			s bobj.MKBTPYCode=  ##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBTPDDesc)
			s bobj.MKBTNote = ##class(web.DHCBL.BDP.FunLib).Util(obj.MKBTNote)
			s bobj.MKBTSequence=  obj.MKBTSequence
			s:obj.MKBTLastLevel'="" bobj.MKBTLastLevel =obj.MKBTLastLevel.%Id()
			d obj.%Close()
			s result=##class(web.CDSS.CMKB.Term).SaveData(bobj)  
	    }
	    elseif(desc="MKBTPYCode")
	    {
		 	s bobj.MKBTRowId = termdr
		    s bobj.MKBTCode = obj.MKBTCode
			s bobj.MKBTDesc = obj.MKBTDesc
			s:obj.MKBTBaseDR'="" bobj.MKBTBaseDR = obj.MKBTBaseDR.%Id()
			s bobj.MKBTPYCode=  MKBTPDDesc
			s bobj.MKBTNote = ##class(web.DHCBL.BDP.FunLib).Util(obj.MKBTNote)
			s bobj.MKBTSequence=  obj.MKBTSequence
			s:obj.MKBTLastLevel'="" bobj.MKBTLastLevel =obj.MKBTLastLevel.%Id()
			d obj.%Close()
			s result=##class(web.CDSS.CMKB.Term).SaveData(bobj)  
		}
		elseif(desc="MKBTLastLevel")
	    {
		 	s bobj.MKBTRowId = termdr
		    s bobj.MKBTCode = obj.MKBTCode
			s bobj.MKBTDesc = obj.MKBTDesc
			s:obj.MKBTBaseDR'="" bobj.MKBTBaseDR = obj.MKBTBaseDR.%Id()
			s bobj.MKBTPYCode=  obj.MKBTPYCode
			s bobj.MKBTNote = ##class(web.DHCBL.BDP.FunLib).Util(obj.MKBTNote)
			s bobj.MKBTSequence=  obj.MKBTSequence
			s bobj.MKBTLastLevel=MKBTPDDesc
			d obj.%Close()
			s result=##class(web.CDSS.CMKB.Term).SaveData(bobj)  
		}
		elseif(desc="MKBTNote")
	    {
		 	s bobj.MKBTRowId = termdr
		    s bobj.MKBTCode = obj.MKBTCode
			s bobj.MKBTDesc = obj.MKBTDesc
			s:obj.MKBTBaseDR'="" bobj.MKBTBaseDR = obj.MKBTBaseDR.%Id()
			s bobj.MKBTPYCode=  obj.MKBTPYCode
			s bobj.MKBTNote = ##class(web.DHCBL.BDP.FunLib).Util(MKBTPDDesc)
			s bobj.MKBTSequence=  obj.MKBTSequence
			s:obj.MKBTLastLevel'="" bobj.MKBTLastLevel =obj.MKBTLastLevel.%Id()
			d obj.%Close()
			s result=##class(web.CDSS.CMKB.Term).SaveData(bobj)  
		}
		
	}
	else
	{
		s obj=##class(CT.WDT.CDSS.TermProperty).%OpenId(RowId)
		s MKBTPTermDr=obj.MKBTPTermDr
		//生成编码规则
		s MKBTPCodeRules=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBTPDesc)
		
		//生成属性代码：术语代码-术语属性编码规则
		s StartCode=$listGet($g(^CT.WDT.CDSS.TermD(obj.MKBTPTermDr)),2)  //代码
		s MKBTPCode=StartCode_"-"_MKBTPCodeRules
		
		s MKBTPType=obj.MKBTPType
		
		if ((MKBTPType="TX")||(MKBTPType="TA")||(MKBTPType="R")||(MKBTPType="CB")||(MKBTPType="C")||(MKBTPType="F")||(MKBTPType="S")||(MKBTPType="P")||(MKBTPType="SD")||(MKBTPType="M")||(MKBTPType="SS")){
			s MKBTPName=MKBTPDesc
		}
		else
		{
			s MKBTPName=obj.MKBTPName
		}
			
		s flag=..FormValidate(RowId,MKBTPCode,MKBTPDesc,MKBTPTermDr,MKBTPCodeRules)  //调用重复验证
			
		if (flag=1){
			s result = "{success:'false',errorinfo:'该属性记录已经存在'}"
		}
		else
		{
			s obj.MKBTPCode=MKBTPCode
			s obj.MKBTPDesc = MKBTPDesc
			s obj.MKBTPName = MKBTPName	
			s obj.MKBTPCodeRules=MKBTPCodeRules	
		}
		
	        
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc){
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" //返回RowId
			s eobj = ##class(web.CDSSEntity.CMKB.TermProDetail).%New()		
			if ($d(^CT.WDT.CDSS.TermProDetailI("ProIdx",id)))
			{
				s MKBTPDRowId=$o(^CT.WDT.CDSS.TermProDetailI("ProIdx",id,0))
				if (MKBTPDDesc'="")
				{	
					s eobj.MKBTPDRowId=MKBTPDRowId
					s eobj.MKBTPDDesc = ##class(web.DHCBL.BDP.FunLib).Util(MKBTPDDesc)
					s eobj.MKBTPDProDR=id
					s result1=##class(web.CDSS.CMKB.TermProDetail).SaveData(eobj)
				}
				else
				{
					s result1=##class(web.CDSS.CMKB.TermProDetail).DeleteData(MKBTPDRowId)
				}
			}
			else
			{
				if (MKBTPDDesc'=""){
					s eobj.MKBTPDDesc=##class(web.DHCBL.BDP.FunLib).Util(MKBTPDDesc)
					s eobj.MKBTPDProDR=id
					s result1=##class(web.CDSS.CMKB.TermProDetail).SaveData(eobj)
				}
				else{
					s result1="{success:'true',errorinfo:'没有属性内容信息'}"
				}
			}
			
			If (result1["true"){
				s result = result1 //返回RowId
			}	   
		}else{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
		}
	}
	q result
}

/// Creator：丁亚男
/// CreatDate: 2018-12-13
/// Description：保存修改部位、病因属性内容
/// Table：CT.WDT.CDSS.TermProperty
/// Input：MKBTRowId-术语id、MKBPartDesc部位内容、MKBDisDesc病因内容
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// w ##class(web.CDSS.CMKB.TermProperty).UpdateProperty(33551,"ceshi","")
ClassMethod UpdatePartDisProperty(MKBTRowId As %String, MKBPartDesc As %String, MKBDisDesc As %String) As %String
{
	
	s result = "",result1="",result2=""
	s MKBPartDR=$O(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," 部位",0))
	s MKBDisDR=$O(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," 病因",0))
	if (MKBPartDR'="")&(MKBPartDesc'="")
	{
		s result1=..UpdateProperty(MKBPartDR,"部位",MKBPartDesc)
	}
	if (MKBDisDR'="")&(MKBDisDesc'="")
	{
		s result2=..UpdateProperty(MKBDisDR,"病因",MKBDisDesc)
	}
	If ((result1["false")||(result2["false")){
		s result = "{success:'false',errorinfo:'保存失败'}"	
	}
	else
	{
		
		s result = "{success:'true',errorinfo:'保存成功'}"
	}
	q result
}

/// Creator：丁亚男
/// CreatDate: 2019-07-04
/// Description：根据OrgPartMKBTRowId的部位保存NewPartMKBTRowIds的部位
/// Table：CT.WDT.CDSS.TermProperty
/// Input：OrgPartMKBTRowId-模板术语id、NewPartMKBTRowIds-需要同步部位的术语串
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// w ##class(web.CDSS.CMKB.TermProperty).DealPartProperty(14504,"14505")
ClassMethod DealPartProperty(OrgPartMKBTRowId As %String, NewPartMKBTRowIds As %String) As %String
{
	
	s result = "",result1=""
	s MKBPartDR=$O(^CT.WDT.CDSS.TermPropertyI("DescIndex",OrgPartMKBTRowId," 部位",0))
	if ($d(^CT.WDT.CDSS.TermProDetailI("ProIdx",MKBPartDR))){
		 s MKBTPDRowId=$o(^CT.WDT.CDSS.TermProDetailI("ProIdx",MKBPartDR,0)) 
		 s MKBTermDR=$listGet($g(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),3)  //术语条目id
	}
	s len=$Length(NewPartMKBTRowIds,",")
	for j=1:1:len{
		s NewPartMKBTRowId=$p(NewPartMKBTRowIds,",",j)
		s NewPartProDR=$O(^CT.WDT.CDSS.TermPropertyI("DescIndex",NewPartMKBTRowId," 部位",0))	
		if (NewPartProDR'="")&(MKBTermDR'="")
		{
			
			s result1=result1_"^"_..UpdateProperty(NewPartProDR,"部位",MKBTermDR)
			
		}
	}
	If (result1["false"){
		s result = "{success:'false',errorinfo:'保存失败'}"	
	}
	else
	{
		
		s result = "{success:'true',errorinfo:'保存成功'}"
	}
	q result
}

/// Creator：丁亚男
/// CreatDate: 2019-07-04
/// Description：根据OrgPathogenyMKBTRowId的病因保存NewPathogenyMKBTRowIds的病因
/// Table：CT.WDT.CDSS.TermProperty
/// Input：OrgPartMKBTRowId-模板术语id、NewPartPartMKBTRowIds-需要同步病因的术语串
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// w ##class(web.CDSS.CMKB.TermProperty).DealPartProperty(14504,"14505")
ClassMethod DealPathogenyProperty(OrgPathogenyMKBTRowId As %String, NewPathogenyMKBTRowIds As %String) As %String
{
	
	s result = "",result1=""
	s MKBPathogenyDR=$O(^CT.WDT.CDSS.TermPropertyI("DescIndex",OrgPathogenyMKBTRowId," 病因",0))
	if ($d(^CT.WDT.CDSS.TermProDetailI("ProIdx",MKBPathogenyDR))){
		 s MKBTPDRowId=$o(^CT.WDT.CDSS.TermProDetailI("ProIdx",MKBPathogenyDR,0)) 
		 s MKBTermDR=$listGet($g(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),3)  //术语条目id
	}
	s len=$Length(NewPathogenyMKBTRowIds,",")
	for j=1:1:len{
		s NewPathogenyMKBTRowId=$p(NewPathogenyMKBTRowIds,",",j)
		s NewPathogenyProDR=$O(^CT.WDT.CDSS.TermPropertyI("DescIndex",NewPathogenyMKBTRowId," 病因",0))	
		if (NewPathogenyProDR'="")&(MKBTermDR'="")
		{
			
			s result1=result1_"^"_..UpdateProperty(NewPathogenyProDR,"病因",MKBTermDR)
			
		}
	}
	If (result1["false"){
		s result = "{success:'false',errorinfo:'保存失败'}"	
	}
	else
	{
		
		s result = "{success:'true',errorinfo:'保存成功'}"
	}
	q result
}

/// Creator:丁亚男
/// CreatDate:2018-05-15
/// Description：获取配置项的描述
/// Input：MKBTPRowId -属性id,ConfigNum第几个配置项
/// Return:ConfigName -属性id下第ConfigNum个配置项的名称
/// Other:w ##class(web.CDSS.CMKB.TermProperty).GetConfigName()
ClassMethod GetConfigName(MKBTPRowId As %String, ConfigNum As %String) As %String
{
	
	q:(MKBTPRowId="") ""
	q:(ConfigNum="") ""
		
	s MKBTPConfig=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),5)
	s ConfigName=""
	if (MKBTPConfig'="")
	{
		s configLen=$Length(MKBTPConfig,"&%")
		if (ConfigNum<=configLen)
	    {  
	      s ConfigName=$p(MKBTPConfig,"&%",ConfigNum)
	    }
	}
	q ConfigName
}

/// Creator:丁亚男
/// CreatDate:2018-05-15
/// Description：测试保存方法
/// Input：
/// Return:保存是否成功
/// w ##class(web.CDSS.CMKB.TermProperty).TestSave()
ClassMethod TestSave() As %String
{
	s rtn=""
	s eobj = ##class(web.CDSSEntity.CMKB.TermProperty).%New()
	s eobj.MKBTPRowId=""
	s eobj.MKBTPDesc = "测试列表"
	s eobj.MKBTPName=""
	s eobj.MKBTPFlag=""
	s eobj.MKBTPType = "L"
	s eobj.MKBTPTermDr=41162
	s eobj.MKBTPConfig=""
	
	s rtn= ..SaveEntity(eobj)
	q rtn
}

/// Creator:丁亚男
/// CreatDate:2018-05-15
/// Description：处理分型(私有)属性的历史数据
/// Input：
/// Return:是否成功
/// w ##class(web.CDSS.CMKB.TermProperty).ProCodeIndex()
ClassMethod ProCodeIndex() As %String
{
	s rtn=""
	s MKBTPRowId=0
	for  
	{	
		s MKBTPRowId=$o(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)) q:MKBTPRowId="" 
		s pobj = ##class(CT.WDT.CDSS.TermProperty).%OpenId(MKBTPRowId)
		s MKBTPDesc = pobj.MKBTPDesc
		if (MKBTPDesc="分型(私有)"){
		 s eobj = ##class(web.CDSSEntity.CMKB.TermProperty).%New()
		 s eobj.MKBTPRowId=MKBTPRowId
		 s eobj.MKBTPDesc = pobj.MKBTPDesc
		 s eobj.MKBTPCode=pobj.MKBTPDesc
		 s eobj.MKBTPType = pobj.MKBTPType
		 s eobj.MKBTPConfig=pobj.MKBTPConfig
		 s:pobj.MKBTPTermDr'="" eobj.MKBTPTermDr = pobj.MKBTPTermDr.%Id()
		 s:pobj.MKBTPDefinedNode'="" eobj.MKBTPDefinedNode = pobj.MKBTPDefinedNode.%Id()
		 s eobj.MKBTPName=pobj.MKBTPName
		 s eobj.MKBTPFlag=pobj.MKBTPFlag
		 s rtn= ..SaveEntity(eobj)
		}
	}
	q rtn
}

/// Creator:丁亚男
/// CreatDate:2018-9-19
/// Description：按照公有属性顺序保存术语这边属性的顺序
/// Other: w ##class(web.CDSS.CMKB.TermProperty).SaveTermProOrder()
ClassMethod SaveTermProOrder(MKBTBPRowId As %String, MKBTPSequence As %String) As %String
{
	s result=""
	if (MKBTBPRowId="")||(MKBTPSequence=""){
		q "{success:'false',errorinfo:'请输入正确的信息'}"
		}
	s MKBTBPDesc=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(MKBTBPRowId)),3)
	s MKBTBPDescU=$ZCONVERT(MKBTBPDesc,"U")
	s MKBTBPBaseDr=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(MKBTBPRowId)),5)
	if ($d(^CT.WDT.CDSS.TermI("BaseIndex",MKBTBPBaseDr)))  //该术语库下有数据
	{
		s MKBTRowId=""
		for  
		{	
			s MKBTRowId=$o(^CT.WDT.CDSS.TermI("BaseIndex",MKBTBPBaseDr,MKBTRowId),-1) q:MKBTRowId="" 
			if ($d(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," "_MKBTBPDescU))){
				s rowid=$o(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," "_MKBTBPDescU,0))
				if (rowid'=""){
					 s obj=##class(CT.WDT.CDSS.TermProperty).%OpenId(rowid)
					 s obj.MKBTPSequence=MKBTPSequence
					 s sc=obj.%Save()
					 d obj.%Close()
					If $$$ISOK(sc)
					{
						
					}
					else
					{
						s result = "{success:'false',errorinfo:'同步顺序失败！'}"  //返回错误信息
					}
				}
			}
		}
	}
		
	q result
	
ERROE
	q "{success:'false',errorinfo:'同步顺序失败！'}"
}

/// Creator:丁亚男
/// CreatDate:2018-11-22
/// Description：获取诊断模板id
/// Input：MKBTRowId -术语id
/// Return: diaproid-诊断模板id
/// Other:w ##class(web.CDSS.CMKB.TermProperty).GetDiaProDR(41166)
ClassMethod GetDiaProDR(MKBTRowId As %String) As %String
{
	
	q:(MKBTRowId="") ""
	s diaproid=""
	if ($d(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," 诊断模板")))
	{
		s diaproid=$O(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," 诊断模板",""))	
	}
	q diaproid
}

/// Creator:丁亚男
/// CreatDate:2018-11-28
/// Description：属性名为"其他描述"的属性增加两条属性内容 其他结构化诊断 其他文本描述
/// Input：MKBTRowId -术语id
/// Return: diaproid-诊断模板id
/// Other:w ##class(web.CDSS.CMKB.TermProperty).ProcessHistoryProData()
ClassMethod ProcessHistoryProData() As %String
{
	s result = "{success:'true',errorinfo:'其他描述属性处理成功'}"
	s MKBTRowId=""
	for  
	{	
		s MKBTRowId=$O(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId)) q:MKBTRowId="" 
		if ($d(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," 其他描述")))
		{
			s MKBTPRowId=$O(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," 其他描述",""))
			s MKBTPType=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(MKBTPRowId)),4)
			if (MKBTPType="T")
			{
				s MKBTPChildsub=0
				if ($d(^CT.WDT.CDSS.TermExtendProI("NameIndex",MKBTPRowId," 展示名")))
				{  
					s MKBTPChildsub=$o(^CT.WDT.CDSS.TermExtendProI("NameIndex",MKBTPRowId," 展示名",MKBTPChildsub))
					s eobj = ##class(web.CDSSEntity.CMKB.TermProDetail).%New()
					s eobj.MKBTPDProDR=MKBTPRowId
					s eobj.MKBTPDDesc="其他结构化描述"	
					s eobj.MKBTPDExtend=MKBTPChildsub_"[A]结构化"

					s ProDetail1=##class(web.CDSS.CMKB.TermProDetail).SaveData(eobj)
					do eobj.%Close()
				
				
					s eobj = ##class(web.CDSSEntity.CMKB.TermProDetail).%New()
					s eobj.MKBTPDProDR=MKBTPRowId
					s eobj.MKBTPDDesc="其他文本描述"
					s eobj.MKBTPDExtend=MKBTPChildsub_"[A]文本"	
					s ProDetail2=##class(web.CDSS.CMKB.TermProDetail).SaveData(eobj)
					do eobj.%Close()
					
					if (ProDetail1["false")||(ProDetail2["false")
					{
						s result = "{success:'false',errorinfo:'其他描述内容保存失败'}"    //返回错误信息
					}
				}
			}
		}
	}
	q result
}

/// lixin
/// 获取映射型属性内容
/// d ##class(web.CDSS.CMKB.MKBDataProcessing).GetDetailForMPro(391364)
ClassMethod GetDetailForMPro(pro)
{
	s result=""
	if (pro'="")
	{
		k arr
		s config = $LG($G(^CT.WDT.CDSS.TermPropertyD(pro)),5)
		s termid = $LG($G(^CT.WDT.CDSS.TermPropertyD(pro)),6)
		
		s MFSearch=""
			
		s MDRowId=0
		for
		{
			s MDRowId = $O(^User.MKBReferenceI("InverAllIndex","T",termid,"MD",MDRowId))	
			q:MDRowId=""
			continue:$D(^User.MKBKLMappingDetailI("BaseIndex",config,MDRowId))=0
			
			
			s RowNum = $LG($G(^User.MKBKLMappingDetailD(MDRowId)),4)
			s:MFSearch="" MFSearch=$LG($G(^User.MKBKLMappingDetailD(MDRowId)),3)
			
			s arr(RowNum)=""
			
		}
		q:$D(arr)=0 ""
		s MFSearchChild = $P(MFSearch,"||",2)
		s MFResultChild=""
		s Child=0
		for
		{
			s Child = $O(^User.MKBKLMappingBaseD(config,"ChildField",Child))
			q:Child=""
			
			if (Child'=MFSearchChild)
			{
				s MFType = $LG($G(^User.MKBKLMappingBaseD(config,"ChildField",Child)),4)	
				if ((MFType="K1")||(MFType="K2"))
				{
					s MFConfig = $LG($G(^User.MKBKLMappingBaseD(config,"ChildField",Child)),5)	
					if (MFConfig="Desc")
					{
						if (MFResultChild'="")
						{
							b	
						}
						s MFResultChild = Child	
					}
				}
			}	
		}
		
		s RowNum=0
		for	
		{
			s RowNum = $O(arr(RowNum))
			q:RowNum=""
			
			s MDRowId=0
			for
			{
				s MDRowId = $O(^User.MKBKLMappingDetailI("ValIndex",RowNum,config_"||"_MFResultChild,MDRowId))
				q:MDRowId=""
				
				s val = $LG($G(^User.MKBKLMappingDetailD(MDRowId)),2)
				s valDesc = ##class(web.CDSS.CMKB.Term).GetTreeComboDesc(val)	
				
				s:result'="" result=result_","_valDesc
				s:result="" result=valDesc
			}
		}
	}
	
	q result
}

/// Creator：丁亚男
/// CreatDate: 2019-07-10
/// Description：根据传过来的诊断id及科室id保存到科室专业诊断
/// Table：CT.WDT.CDSS.TermProperty
/// Input：
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// w ##class(web.CDSS.CMKB.TermProperty).DealProLocDia(14506,"77547,17228")
ClassMethod DealProLocDia(MKBRowIds As %String, Locs As %String) As %String
{
	
	s result = "",result1=""
	s MKBlen=$Length(MKBRowIds,",")
	s Loclen=$Length(Locs,",")
	for i=1:1:MKBlen
	{
		s MKBTRowId=$p(MKBRowIds,",",i)
		for j=1:1:Loclen
		{
			s Loc=$p(Locs,",",j)
			b ;00
			s result1=result1_"^"_##class(web.CDSS.CMKB.MKBKLMappingDetail).SaveLocProfessionalDia(MKBTRowId,Loc)
			b ;11
		}
	}
	If (result1["false"){
		s result = "{success:'false',errorinfo:'保存失败'}"	
	}
	else
	{
		
		s result = "{success:'true',errorinfo:'保存成功'}"
	}
	q result
}

/// Creator:石萧伟
/// CreatDate:2019-03-14
/// Description：根据标识获取属性id
/// Input: termid术语id，desc属性描述
/// return:属性id
/// Other:w ##class(web.CDSS.CMKB.TermProperty).GetPropertyIdByFlag("16354","DT")
ClassMethod GetPropertyIdByFlag(termid As %String, flag As %String) As %String
{
	s propertyid=""
	s propertyid=$o(^CT.WDT.CDSS.TermPropertyI("FlagIndex",termid," "_flag,0))
	q propertyid
}

/// Description：获取常用名/别名列表(AL)及拼音码
/// Table：CT.WDT.CDSS.TermProperty
/// Input：termdr
/// Return:常用名/别名列表(AL)||拼音码
/// Date:2020-05-29
/// creator：丁亚男
/// Other:w ##class(web.CDSS.CMKB.TermProperty).GetComAndAlias(14626)
/// Description:获取常用名(C)或别名(A)$拼音码^别名(A)$拼音码
ClassMethod GetComAndAlias(termdr As %String) As %String
{
	q:(termdr="") ""
	q:('$d(^CT.WDT.CDSS.TermPropertyI("FlagIndex",termdr," AL"))) ""
	s keyStr=""
	
	s comPropertyId=$o(^CT.WDT.CDSS.TermPropertyI("FlagIndex",termdr," AL",0)) //常用名的属性id
	
	s MKBTPRowId=$o(^CT.WDT.CDSS.TermPropertyI("FlagIndex",termdr," AL",0)) 
	s MKBTPDRowId=0
	for  
	{	
		s MKBTPDRowId=$o(^CT.WDT.CDSS.TermProDetailI("ProIdx",MKBTPRowId,MKBTPDRowId)) q:MKBTPDRowId="" 
		s MKBTPDDesc=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),3)
		s MKBTPDDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPDDesc)
		s comPY=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(MKBTPDRowId)),10)  //检索码

		s:keyStr'="" keyStr=keyStr_"^"_MKBTPDDesc_"$"_comPY
		s:keyStr="" keyStr=MKBTPDDesc_"$"_comPY
		
		
	}
 	q keyStr
}

}
