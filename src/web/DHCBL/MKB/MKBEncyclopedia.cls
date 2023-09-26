Class web.DHCBL.MKB.MKBEncyclopedia Extends %RegisteredObject
{

/// CreatDate: 2018-05-02
/// Description：查询诊断属性父表内容
/// Table：User.MKBTermProperty
/// Input：rowid, code, desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBEncyclopedia","GetList","","1700873","")
Query GetList(rowid, termdr, desc) As %Query(ROWSPEC = "MKBTPRowId,MKBTPDesc,MKBTPDDesc,MKBTPType,MKBTPTermDr,MKBTPConfig,MKBTPName,MKBTPFlag,MKBTPPublic,MKBTPDefinedNode,MKBTPSequenceMKBTBPWikiShow")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, termdr, desc) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s MKBTPRowId=rowid
        s MKBTPDesc=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),3)
        s MKBTPType=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),4)
        
        s MKBTPDDesc=##class(web.DHCBL.MKB.MKBTermProperty).GetDetail(MKBTPType,MKBTPRowId)  //缩略名
        s MKBTPTermDr=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),6)
        s Config=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),5)
        if (MKBTPType="R")||(MKBTPType="CB")||(MKBTPType="C")
        {
            s:Config'="" MKBTPConfig=$LISTGET($G(^User.MKBTermBaseD(Config)),3)
            s:Config="" MKBTPConfig=""
        }
        else{
            s MKBTPConfig=Config
            
        }
        s MKBTPName=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),7)
        s MKBTPFlag=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),8)
        s MKBTPPublic=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),9)
        s DefinedNode=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),10)
        
        s:DefinedNode'="" MKBTPDefinedNode=$listget($g(^User.MKBTermD(DefinedNode)),3) 
        s:DefinedNode="" MKBTPDefinedNode="" 
        
        s MKBTPSequence=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),11)
        d OutputRow
    }
    else
    {
        if (termdr'=""){
            s:desc'="" desc=$ZCONVERT(desc,"U")
            // 公有按照 知识库注册的顺序取，私有属性按照现有的顺序
			k myArray
			s MKBTPRowId=0
			for 
			{
				s MKBTPRowId=$o(^User.MKBTermPropertyI("TermIndex",termdr,MKBTPRowId)) q:MKBTPRowId="" 
				s MKBTPDesc=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),3)
				s MKBTPDescU=$ZCONVERT(MKBTPDesc,"U")
				s MKBTBaseDR=$LISTGET($G(^User.MKBTermD(termdr)),4)
				s MKBTPSequence=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),11)
				if ($d(^User.MKBTermBasePropertyI("DescIndex",MKBTBaseDR)))&($d(^User.MKBTermBasePropertyI("DescIndex",MKBTBaseDR," "_MKBTPDescU)))
				{
					s MKBTBPRowId=$o(^User.MKBTermBasePropertyI("DescIndex",MKBTBaseDR," "_MKBTPDescU,""))
					s MKBTBPSequence=0
					s:MKBTBPRowId'="" MKBTBPSequence=$LISTGET($G(^User.MKBTermBasePropertyD(MKBTBPRowId)),9)
					s myArray(MKBTBPSequence,MKBTPRowId)=""
				}
				else
				{
					s myArray(MKBTPSequence,MKBTPRowId)=""	
					
				}		
			}
			s MKBTPSequence=0
			for  
			{	
				s MKBTPSequence=$o(myArray(MKBTPSequence)) q:MKBTPSequence=""
				
				s MKBTPRowId=0
				for 
				{
					s MKBTPRowId=$o(myArray(MKBTPSequence,MKBTPRowId)) q:MKBTPRowId=""
		            s MKBTPDesc=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),3)
	                s MKBTPDescU=$ZCONVERT(MKBTPDesc,"U")
	                s MKBTPType=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),4)
	                s MKBTPDDesc=##class(web.DHCBL.MKB.MKBTermProperty).GetDetail(MKBTPType,MKBTPRowId)  //缩略名
	                continue:MKBTPDDesc=""
	                s MKBTPTermDr=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),6)
	                s MKBTPFlag=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),8)
	  				if (MKBTPTermDr'="")
	                {
		                s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTPTermDr)),3)  //诊断描述
		                //新型冠状病毒肺炎的诊断展示名,常用名/别名列表,知识应用模板,其他描述不显示
		                continue:(MKBTDesc="新型冠状病毒肺炎")&((MKBTPFlag="S")||(MKBTPFlag="AL")||(MKBTPFlag="DT")||(MKBTPFlag="OD"))

	                }
	                s Config=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),5)
	                if (MKBTPType="S")||(MKBTPType="SD")||(MKBTPType="T")
	                {
	                    s:Config'="" MKBTPConfig=$LISTGET($G(^User.MKBTermBaseD(Config)),3)
	                    s:Config="" MKBTPConfig=""
	                }
	                else{
	                    s MKBTPConfig=Config
	                    
	                }
	                s MKBTPName=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),7)
	                s MKBTPPublic=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),9)
	                s DefinedNode=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),10)
	                s:DefinedNode'="" MKBTPDefinedNode=$listget($g(^User.MKBTermD(DefinedNode)),3) 
	                s:DefinedNode="" MKBTPDefinedNode="" 
	        
	                if (MKBTPPublic="Y")&(termdr'="")&(MKBTPDesc'="")  //如果是公有属性
	                {
		                s MKBTBaseDR=$listGet($g(^User.MKBTermD(termdr)),4) //知识库注册id
		                continue:MKBTBaseDR=""
		                s BaseProId=$o(^User.MKBTermBasePropertyI("DescIndex",MKBTBaseDR," "_$ZCONVERT(MKBTPDesc,"U"),0))  //知识库注册属性id
		                continue:BaseProId=""
	                	s MKBTBPWikiShow=$LISTGET($G(^User.MKBTermBasePropertyD(BaseProId)),13) //医为百科展示位置20200621
	                	continue:(MKBTBPWikiShow="hide")||(MKBTBPWikiShow="top")
	                }
	                s PINYIN=""
	                s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBTPDescU)
	                i ((MKBTPDescU[desc)||(PINYIN[desc))   //条件
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
    set Data=$lb(MKBTPRowId,MKBTPDesc,MKBTPDDesc,MKBTPType,MKBTPTermDr,MKBTPConfig,MKBTPName,MKBTPFlag,MKBTPPublic,MKBTPDefinedNode,MKBTPSequence,MKBTBPWikiShow)
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

/// w ##class(web.DHCBL.MKB.MKBEncyclopedia).GetTermInfo('14626')
ClassMethod GetTermInfo(id As %String) As %String
{
       q:id="" ""
       s MKBTCode=$listGet($g(^User.MKBTermD(id)),2) //代码
       s MKBTDesc=$listGet($g(^User.MKBTermD(id)),3)  //全称
       s MKBTBaseDR=$listGet($g(^User.MKBTermD(id)),4) 
       s:MKBTBaseDR'="" MKBTBaseDR=$listGet($g(^User.MKBTermBaseD(MKBTBaseDR)),3) //所属知识库
       s MKBTPYCode=$listGet($g(^User.MKBTermD(id)),6) //拼音码
       s MKBTNote=$listGet($g(^User.MKBTermD(id)),7) //备注
       s MKBTOther= ##class(web.DHCBL.MKB.MKBTermProperty).GetComOrAlias(id)
       q "{""MKBTCode"":"""_MKBTCode_""",""MKBTDesc"":"""_MKBTDesc_""",""MKBTBaseDR"":"""_MKBTBaseDR_""",""MKBTPYCode"":"""_MKBTPYCode_""",""MKBTNote"":"""_MKBTNote_""",""MKBTOther"":"""_MKBTOther_"""}"
}

ClassMethod GetSubId(property As %String) As %String
{
        q:property="" ""
        s subId= 0
        s subIdstr=""
        for{
            s subId=$o(^User.MKBTermPropertyD(property,"ChildExtPro",subId)) q:subId=""
            s:subIdstr'="" subIdstr=subIdstr_"^"_subId
            s:subIdstr="" subIdstr=subId
        }
        q subIdstr
}

/// Creator:chenghegui
/// CreatDate:2018-05-05
/// Description：获取属性内容列表的数据
/// Input：pro
/// Return:Html格式的字符串
/// Other:w ##class(web.DHCBL.MKB.MKBEncyclopedia).GetListHtml("1767")
ClassMethod GetListHtml(property As %String, termid As %String) As %String
{
    s htmlstr=""
    q:property="" ""
    s MKBTPDRowId=0
    for  
    {   
        s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProIdx",property,MKBTPDRowId)) q:MKBTPDRowId="" 
        s MKBTPDDesc=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)
        s MKBTPDDesc= ..EvalJSON(MKBTPDDesc)
        //s:MKBTPDDesc="" MKBTPDDesc="暂无"
        s MKBTPDDescU=$ZCONVERT(MKBTPDDesc,"U")
        s MKBTPDRemark=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),7)
        s MKBTPDRemark= ..EvalJSON(MKBTPDRemark)
        //s:MKBTPDRemark="" MKBTPDRemark="暂无"
        s MKBTPDSequence=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),9) 
        s ExtendStr=""   //知识点扩展属性子表的字段

        s subId=0  //循环扩展属性子表User.MKBTermProperty
        if ( termid'=1650775){//20200206
		    for 
	        {
	            S subId=$o(^User.MKBTermPropertyD(property,"ChildExtPro",subId)) q:subId=""
	            s MKBTEPRowId=property_"||"_subId  //扩展属性表的ID
	            s MKBTEPType=$LISTGET($G(^User.MKBTermPropertyD(property,"ChildExtPro",subId)),3)   //扩展属性类型
	          
	            s MKBTEPVRowId=$o(^User.MKBTermExtendProValI("ValIndex",MKBTPDRowId,MKBTEPRowId,0))  //扩展属性内容表的id
	            s MKBTEPVValue=""
	            s:MKBTEPVRowId'="" MKBTEPVValue=$LISTGET($G(^User.MKBTermExtendProValD(MKBTEPVRowId)),4) //扩展属性内容的值
	            if (MKBTEPVValue'="")
	            {   
	                if (MKBTEPType="S")  //数据来源型 (注意要换成MKBTerm)
	                {   
	                    s MKBTEPVValue=##class(web.DHCBL.MKB.MKBTerm).GetTreeComboDesc(MKBTEPVValue)  //获取描述，树形的所有上级节点也要显示  
	      
	                }
	                if (MKBTEPType="SD")  //引用诊断型
	                {         
	                    s MKBTEPVValue=##class(web.DHCBL.MKB.MKBKnoExpression).GetDiagDesc(MKBTEPVValue)              
	                }
	            }
	            s MKBTEPVValue=..EvalJSON(MKBTEPVValue) 
	            //s:MKBTEPVValue="" MKBTEPVValue="暂无"
	            s ExtendStr=ExtendStr_"<td>"_MKBTEPVValue_"</td>"
	        }

	    }
        s mainstr=""
        s mainstr="<td>"_MKBTPDDesc_"</td><td>"_MKBTPDRemark_"</td>"_ExtendStr
        if (htmlstr'="")
        { 
            s htmlstr=htmlstr_"<tr>"_mainstr_"</tr>"
        }
        else
        {
            s htmlstr="<tr>"_mainstr_"</tr>"
        }
             
    }
    q htmlstr
}

/// Creator：谷雪萍
/// CreatDate:2018-03-30
/// Description：获取树形属性内容数据
/// Table：User.MKBTermProDetail
/// Input：父节点 
/// Return：treegrid格式数据串
/// w ##class(web.DHCBL.MKB.MKBEncyclopedia).GetJsonList("","9365287")
ClassMethod GetJsonList(id As %String, property As %String) As %String
{
    s IDStr=""
    s parentcatdr=id
    if (parentcatdr="") s parentcatdr=-100000000000000
    
    s myJsonStr=""
    s myRowID=0
    
    s mySeq=0
    k myArray
    k a
    //生成索引数组
    s mySeq=0
    s n=0
    for {
        s mySeq=$o(^User.MKBTermProDetailI("ProParSeqIndex",property,parentcatdr,mySeq)) q:(mySeq="")
        s n=n+1
        s a(n)= $g(mySeq)
    }
    set left=1,right=n
    d:$d(a) ##class(web.DHCBL.BDP.FunLib).QuickSort(.a,left,right) //排序

    s n=0
    s mySeq=0
    s myCount=0
    for {
        s n=$o(a(n)) q:(n="")
        s mySeq=$g(a(n))
        s myRowID=0
        for {
            s myRowID=$o(^User.MKBTermProDetailI("ProParSeqIndex",property,parentcatdr,mySeq,myRowID)) q:(myRowID="")
            s myCount=myCount+1
            s myArray(myCount)=myRowID
        }
    }
    //输出菜单JSON串
    s myRowID=0
    s mySeq=0
    s childStr=""
    w "["
    s count=0
    for 
    {
        s mySeq=$o(myArray(mySeq)) q:(mySeq="")
        s myRowID=$g(myArray(mySeq))
        //continue:$LISTGET($G(^User.MKBTermProDetailD(myRowID)),6)'="Y"
        s count=count+1
        s MKBTPDDesc=$LISTGET($G(^User.MKBTermProDetailD(myRowID)),3)
        s MKBTPDDesc=$tr(MKBTPDDesc,"""","")
        s MKBTPDDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPDDesc)
       // s:MKBTPDDesc="" MKBTPDDesc="暂无"
        if count>1 w ","
        s MKBTPDCode=$LISTGET($G(^User.MKBTermProDetailD(myRowID)),2)
        s MKBTPDCode=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPDCode)
        //s:MKBTPDCode="" MKBTPDCode="暂无"
        s MKBTPDRemark=$LISTGET($G(^User.MKBTermProDetailD(myRowID)),7)
        s MKBTPDRemark=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPDRemark)
        //s:MKBTPDRemark="" MKBTPDRemark="暂无"
        s MKBTPDSequence=$LISTGET($G(^User.MKBTermProDetailD(myRowID)),9)
        s MKBTPDSequence=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPDSequence)
        //s:MKBTPDSequence="" MKBTPDSequence="暂无"
        s MKBTPDLastLevel=$LISTGET($G(^User.MKBTermProDetailD(myRowID)),4)
        s MKBTPDLastLevel=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPDLastLevel)
        if MKBTPDLastLevel'="" s MKBTPDLastLevel=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDLastLevel)),3)
        s MKBTPDLevel=$LISTGET($G(^User.MKBTermProDetailD(myRowID)),5)
        s MKBTPDLevel=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPDLevel)
        w "{""id"":"""_myRowID_""""
        w ",""MKBTPDCode"":"""_MKBTPDCode_""",""MKBTPDDesc"":"""_MKBTPDDesc_""",""MKBTPDRemark"":"""_MKBTPDRemark_""",""MKBTPDLastLevel"":"""_MKBTPDLastLevel_""",""MKBTPDSequence"":"""_MKBTPDSequence_""",""MKBTPDLevel"":"""_MKBTPDLevel_""""
        s ExtendStr=""   //知识点扩展属性子表的字段
        s subId=0  //循环扩展属性子表User.MKBTermProperty
        for 
        {
            S subId=$o(^User.MKBTermPropertyD(property,"ChildExtPro",subId)) q:subId=""
            s MKBTEPRowId=property_"||"_subId  //扩展属性表的ID
            s MKBTEPType=$LISTGET($G(^User.MKBTermPropertyD(property,"ChildExtPro",subId)),3)   //扩展属性类型
            s MKBTEPVRowId=$o(^User.MKBTermExtendProValI("ValIndex",myRowID,MKBTEPRowId,0))  //扩展属性内容表的id
            s MKBTEPVValue=""
            s:MKBTEPVRowId'="" MKBTEPVValue=$LISTGET($G(^User.MKBTermExtendProValD(MKBTEPVRowId)),4) //扩展属性内容的值
            if (MKBTEPVValue'="")
            {   
                if (MKBTEPType="S")  //数据来源型 (注意要换成MKBTerm)
                {   
                    s MKBTEPVValue=##class(web.DHCBL.MKB.MKBTerm).GetTreeComboDesc(MKBTEPVValue)  //获取描述，树形的所有上级节点也要显示  
      
                }
                if (MKBTEPType="SD")  //引用诊断型
                {         
                   s MKBTEPVValue=##class(web.DHCBL.MKB.MKBKnoExpression).GetDiagDesc(MKBTEPVValue)              
                }
            }
            //s MKBTEPVValue=..EvalJSON(MKBTEPVValue) 
            s MKBTEPVValue=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTEPVValue)
            //s:MKBTEPVValue="" MKBTEPVValue="暂无"
            s:ExtendStr'="" ExtendStr=ExtendStr_",""Extend"_subId_""":"""_MKBTEPVValue_""""
            s:ExtendStr="" ExtendStr="""Extend"_subId_""":"""_MKBTEPVValue_""""
            
        }
        if ExtendStr'=""
        {
            w ","_ExtendStr
        }
        s childStr=##class(web.DHCBL.MKB.MKBTermProDetail).GetChildOrderedIDStr(myRowID,property)
        if childStr'=""
        {
            //一次性加载   
            w ",""state"":""open"""   //closed节点不展开,open节点展开
            w ",""children"":"
            w ..GetJsonList(myRowID,property)
        }
        else
        {
            w ",""state"":""open"""
        }
        w "}"
        
    }
    w "]"
    q ""
}

/// Creator:谷雪萍
/// CreatDate:2018-03-27
/// Description：对JSON数据字符特殊字符处理
/// Input：instr -输入的字符串
/// Return:mystr -处理特殊字符后的字符串
/// Other:w ##class(web.DHCBL.MKB.MKBEncyclopedia).EvalJSON(a'b)
ClassMethod EvalJSON(instr As %String) As %String
{
    s mystr = instr
    
    q:(mystr="") mystr
        
    s mystr=$tr(mystr,"""","”")
    
    s mystr = ##class(web.BDP.util.String).Replace(mystr,$c(13), "")
    
    s mystr = ##class(web.BDP.util.String).Replace(mystr,$c(10), "<br/>")
    
    s mystr = ##class(web.BDP.util.String).Replace(mystr,"\","\\")
    
    s mystr = ##class(web.BDP.util.String).Replace(mystr,$c(10,10,10), "")
    
    q mystr
}

/// Creator:chenghegui
/// CreatDate:2018-05-05
/// Description：相关文献表格
/// Input：pro
/// Return:Html格式的字符串
/// w ##class(web.DHCBL.MKB.MKBEncyclopedia).RelationDocHtml1(14626)
ClassMethod RelationDocHtml1(rowid As %String) As %String
{
    q:rowid="" ""
    s doctr=""
    s doctd=""
    s count=0
    s MKBDMRowId=0
    for{  
          s MKBDMRowId=$o(^User.MKBDocManageD(MKBDMRowId)) q:MKBDMRowId=""   
          s MKBDMCode=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),2)
          s MKBDMDesc=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),3)
          s MKBDMPath=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),4)
          s MKBDMSource=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),5)
          s MKBDMType=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),6)
          s MKBDMUpdateUser=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),7)
          s:MKBDMUpdateUser'="" SSUSRName=$p($g(^SSU("SSUSR",MKBDMUpdateUser)),"^",2)
          s:MKBDMUpdateUser="" SSUSRName=""
          s MKBDMUpdateDate=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),8)
          s:MKBDMUpdateDate'="" MKBDMUpdateDate=$zd(MKBDMUpdateDate,3)
          s MKBDMExpression=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),9)
          s temrid = $p($G(MKBDMExpression),"-",1)
          s MKBICDRDiagDesc = ""
            if (MKBDMExpression'["&")
            {
                s MKBICDRDiagDesc = ##Class(web.DHCBL.MKB.MKBDocManage).GetDiagDescT(MKBDMExpression) 
                s Diag1=$P(MKBDMExpression,"-",1)   
            }
            else
            {
                s Len = $L(MKBDMExpression,"&")
                for i=1:1:Len
                {
                    s DiagIDs = $P(MKBDMExpression,"&",i)
                    if (OutFlag'="Y")
                    {
                        s OutFlag=##Class(web.DHCBL.MKB.MKBDocManage).GetComHasFlag($P(DiagIDs,"-",1))    
                    }
                    s temp = ##Class(web.DHCBL.MKB.MKBDocManage).GetDiagDescT(DiagIDs)
                    s:MKBICDRDiagDesc="" MKBICDRDiagDesc=temp
                    s:MKBICDRDiagDesc'="" MKBICDRDiagDesc=MKBICDRDiagDesc_"</br>"_temp
                }   
            }
          s MKBDMKeyWord=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),10)
          s MKBDMFlag=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),11)
          s MKBDMNote=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),12)
          if (rowid=temrid){
              s doctd="<td>"_MKBDMDesc_"</td><td>"_SSUSRName_"</td><td>"_MKBDMUpdateDate_"</td><td>"_MKBICDRDiagDesc_"</td><td style='text-align:center'><a href='#' class='pre'><img style='cursor:pointer' src='../scripts/bdp/Framework/icons/mkb/detailsview.png' class='preview'><span style='display:none'>"_MKBDMPath_"<span></img></a></td><td style='text-align:center'><a href='#' class='load'><img style='cursor:pointer' src='../scripts/bdp/Framework/icons/mkb/load.png' class='download'><span style='display:none'>"_MKBDMPath_"</span></img></a></td>"
              s doctr=doctr_"<tr>"_doctd_"</tr>"
              s count=count+1
          }
        }
        s dochtml="<tr><th width='35%'>文件名<span id='countdoc'>"_count_"<span></th><th>上传人</th><th>上传时间</th><th>知识表达式</th><th style='text-align:center'>预览</th><th style='text-align:center'>下载</th></tr>"_doctr
        q dochtml
}

/// Creator:chenghegui
/// CreatDate:2018-05-05
/// Description：获得属性内容不包括树形和列表型
/// Input：属性id,属性类型 
/// Return:属性内容文本串
/// w ##class(web.DHCBL.MKB.MKBEncyclopedia).GetDetailDesc("216394","F")
ClassMethod GetDetailDesc(id, type) As %String
{
     q:((id="")||(type="")) ""
     s MKBTPDRowId=""
     s desc=""
     if ((type="TX")||(type="TA")||(type="SD")||(type="ETX")){
        for{
          s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProIdx",id,MKBTPDRowId)) q:MKBTPDRowId="" 
          s MKBTPDesc=$LISTGET($G(^User.MKBTermPropertyD(id)),3) 
          s MKBTPDDesc=$listGet($g(^User.MKBTermProDetailD(MKBTPDRowId)),3)  //描述
          s:type="SD" MKBTPDDesc=##class(web.DHCBL.MKB.MKBKnoExpression).GetDiagDesc(MKBTPDDesc)
          //s desc="<span>"_"</span><span>"_MKBTPDDesc_"</span>"
          s desc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPDDesc)	
        }
    }elseif ((type="C")||(type="CB")||(type="R"))
      {  
        if ($d(^User.MKBTermProDetailI("ProIdx",id))){
            s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProIdx",id,0)) 
            s MKBTPDesc=$LISTGET($G(^User.MKBTermPropertyD(id)),3) 
            s MKBTPDDesc=$listGet($g(^User.MKBTermProDetailD(MKBTPDRowId)),3)  //描述
            /*s len=0
            s len=$length(MKBTPDDesc,",")
            s descstr = ""
            for i=1:1:len
            {
                s num=$p(MKBTPDDesc,",",i)
                s DDesc=##Class(web.DHCBL.MKB.MKBTermProperty).GetConfigName(id,num) 
                s:descstr'="" descstr=descstr_","_DDesc
                s:descstr="" descstr=DDesc
            }*/
             s desc=desc_"<span>"_"</span><span>"_MKBTPDDesc_"</span><br/>"
        }
    }elseif (type="F"){
        s MKBTPDRowId=0
        for  
        {   
            s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProIdx",id,MKBTPDRowId)) q:MKBTPDRowId=""    
            s MKBTPDesc=$LISTGET($G(^User.MKBTermPropertyD(id)),3)      
            s MKBTPDDesc=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)
            s MKBTPDDesc= ..EvalJSON(MKBTPDDesc)
            s ExtendStr=""   //知识点扩展属性子表的字段
            s subId=0  //循环扩展属性子表User.MKBTermProperty
            for 
            {
                S subId=$o(^User.MKBTermPropertyD(id,"ChildExtPro",subId)) q:subId=""
                s MKBTEPRowId=id_"||"_subId  //扩展属性表的ID
                s MKBTEPName=$LISTGET($G(^User.MKBTermPropertyD(id,"ChildExtPro",subId)),2)   //扩展属性名称
                continue:MKBTEPName=""
                s MKBTEPType=$LISTGET($G(^User.MKBTermPropertyD(id,"ChildExtPro",subId)),3)   //扩展属性类型
                s MKBTEPVRowId=$o(^User.MKBTermExtendProValI("ValIndex",MKBTPDRowId,MKBTEPRowId,0))  //扩展属性内容表的id
                s MKBTEPVValue=""
                s:MKBTEPVRowId'="" MKBTEPVValue=$LISTGET($G(^User.MKBTermExtendProValD(MKBTEPVRowId)),4) //扩展属性内容的值
                if (MKBTEPVValue'="")
                {   
                    if (MKBTEPType="S")  //数据来源型 (注意要换成MKBTerm)
                    {   
                        s MKBTEPVValue=##class(web.DHCBL.MKB.MKBTerm).GetTreeComboDesc(MKBTEPVValue)  //获取描述，树形的所有上级节点也要显示  
          
                    }
                    if (MKBTEPType="SD")  //引用诊断型
                    {         
                         s MKBTEPVValue=##class(web.DHCBL.MKB.MKBKnoExpression).GetDiagDesc(MKBTEPVValue)         
                    }
                    if (MKBTEPType="CB")   //多选框
                    {   
                        s MKBTEPVValue=##class(web.BDP.util.String).Replace(MKBTEPVValue,"&%",",")  
                    }
                    
                }
                s MKBTEPVValue=..EvalJSON(MKBTEPVValue)
                //s:MKBTEPVValue="" MKBTEPVValue="暂无"
                s ExtendStr=ExtendStr_"<td>"_MKBTEPName_"</td><td>"_MKBTEPVValue_"</td>"
                s ExtendStr= "<tr>"_ExtendStr_"</tr>"
            }   
        s desc="<table  cellspacing='0'><tbody>"_"<tr>"_"<th colspan='2'>"_MKBTPDDesc_"</th></tr>"_ExtendStr_"</tbody></table>"
    }
  
   }
     q desc
}

/// Creator:谷雪萍
/// CreatDate:2018-04-13
/// Description：给医生站提供获取引用树形术语的接口 获取选中节点信息—— Json格式
/// Input:LastLevel ：上级节点id property:属性id
/// return:父节点及其所有子节点 Json格式
/// Other:w ##class(web.DHCBL.MKB.MKBEncyclopedia).GetDocSourseTreeJson("","69920")
ClassMethod GetDocSourseTreeJson(LastLevel As %String, property As %String) As %String
{
    
    q:(property="") "[]"
    s DATSOU=$LISTGET($G(^User.MKBTermPropertyD(property)),5)  //配置项
    q:(DATSOU="") "[]"
    
    s selItemIds= ##class(web.DHCBL.MKB.MKBTermProDetail).GetSelTermIdsStr(property)
    s selItemIds=","_selItemIds_","
    s definedNode=$LISTGET($G(^User.MKBTermPropertyD(property)),10)  //起始节点
    if (definedNode="")  //如果起始节点为空，显示所有术语数据
    {
        w ..GetDocSourseJsonDataForCmb(DATSOU,definedNode,selItemIds)
    } 
    else  //如果定义了起始节点，显示该节点及以下的节点
    {       
        s strId=","_definedNode_","
        if (selItemIds[strId){
                
            s definedNodeDesc=$listGet($g(^User.MKBTermD(definedNode)),3)  //已选术语描述
            s definedNodeDesc= ..EvalJSON(definedNodeDesc)
            s MKBTNote=$LISTGET($G(^User.MKBTermD(definedNode)),7)  //备注
            s strComAndAlisa=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(definedNode)
            s strCom=$p(strComAndAlisa,"[A]",1)
            s comDesc=$p(strCom,"&%",1) //常用名
            s MKBTPYCode=$LISTGET($G(^User.MKBTermD(definedNode)),6)   //检索码

            s spanDesc=definedNodeDesc  //中心词
            s spanDesc= ..EvalJSON(spanDesc)
        
            w "["
            w "{""id"":"""_definedNode_""",""text"":"""_definedNodeDesc_""""
            w ",""state"":""open"""

            if $d(^User.MKBTermI("ParentIndex",DATSOU,definedNode))  //如果有子节点
            {
                w ",""children"":"
                w ..GetDocSourseJsonDataForCmb(DATSOU,definedNode,selItemIds)
            }
            w "}"
            w "]"
        }
        else{
            q "[]"
        }
        
    }
    
    q ""
}

/// Creator：谷雪萍
/// CreatDate:2018-05-09
/// Description：：获取引用-树形术语-tree的数据，如果属性中定义了初始节点，则内容区域显示该节点及以下的节点，如果没有定义起始节点，显示全部
/// Table：User.MKBTerm
/// Input：base-术语库注册id，   id-父节点id， selItemIds-要选中的节点
/// Return：treegrid格式数据串
/// w ##class(web.DHCBL.MKB.MKBEncyclopedia).GetDocSourseJsonDataForCmb("31","")
ClassMethod GetDocSourseJsonDataForCmb(base As %String, id As %String, selItemIds As %String) As %String
{
    
    s IDStr=""
    s parentcatdr=id
    if (parentcatdr="") s parentcatdr=-100000000000000
    
    s myJsonStr=""
    s myRowID=0
    
    s mySeq=0
    k myArray
    k a
    //生成索引数组
    s mySeq=0
    s n=0
    for {
        s mySeq=$o(^User.MKBTermI("ParSeqIndex",base,parentcatdr,mySeq)) q:(mySeq="")
        s n=n+1
        s a(n)= mySeq
    }
    set left=1,right=n
    d:$d(a) ##class(web.DHCBL.BDP.FunLib).QuickSort(.a,left,right) //排序

    s n=0
    s mySeq=0
    s myCount=0
    for {
        s n=$o(a(n)) q:(n="")
        s mySeq=$g(a(n))
        s myRowID=0
        for {
            s myRowID=$o(^User.MKBTermI("ParSeqIndex",base,parentcatdr,mySeq,myRowID)) q:(myRowID="")
            s myCount=myCount+1
            s myArray(myCount)=myRowID
        }
    }
    //输出菜单JSON串
    s myRowID=0
    s mySeq=0
    s childStr=""
    w "["
    s count=0
    for {
        s mySeq=$o(myArray(mySeq)) q:(mySeq="")
        s myRowID=$g(myArray(mySeq))
        s strId=","_myRowID_","
        if '(selItemIds[strId){
            continue
        }
        s count=count+1
        s Caption=$LISTGET($G(^User.MKBTermD(myRowID)),3)
        s Caption= ..EvalJSON(Caption)
        s MKBTNote=$LISTGET($G(^User.MKBTermD(myRowID)),7)  //备注
        s strComAndAlisa=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(myRowID)
        s strCom=$p(strComAndAlisa,"[A]",1)
        s comDesc=$p(strCom,"&%",1) //常用名
        s MKBTPYCode=$LISTGET($G(^User.MKBTermD(myRowID)),6)   //检索码

        if count>1 w ","
        w "{""id"":"""_myRowID_""",""text"":"""_Caption_""""
        s childStr=##class(web.DHCBL.MKB.MKBTermProDetail).GetDocChildOrderedIDStr(base,myRowID,selItemIds)
        if childStr'=""
        {
            w ",""state"":""open"""
            w ",""children"":"
            w ..GetDocSourseJsonDataForCmb(base,myRowID,selItemIds) 
        }
        else
        {
            w ",""state"":""open"""
        }
        w "}"
        
    }
    w "]"
    q ""
}

// 新表  相关文献

ClassMethod RelationDocHtml(rowid)
{
    q:rowid="" ""
    s doctr=""
    s doctd=""
    s count=0
    
    if ($D(^User.MKBKLMappingBaseI("DescIndex"," 文献对照"))'=0)
    {
        s KMBRowId = $O(^User.MKBKLMappingBaseI("DescIndex"," 文献对照",0))
        s KMBFChild1 = $O(^User.MKBKLMappingBaseFieldI("DescIndex",KMBRowId," 诊断",0))
        s KMBFChild2 = $O(^User.MKBKLMappingBaseFieldI("DescIndex",KMBRowId," 文献",0))
    
        s KMDRowId = 0
        for
        {
            s KMDRowId = $O(^TMP("MKB","DiagTermID",KMBRowId,rowid,KMDRowId))
            q:KMDRowId=""
            
            s tmp(KMDRowId)=""
        }
        s result = ""
        s KMDRowId = "" 
        for
        {
            s KMDRowId = $o(tmp(KMDRowId))
            q:KMDRowId=""
            
            s KMDRowNum = $LG($G(^User.MKBKLMappingDetailD(KMDRowId)),4)
                    
            continue:KMDRowNum=""
            s KMDRowId2 = $O(^User.MKBKLMappingDetailI("ValIndex",KMDRowNum,KMBRowId_"||"_KMBFChild2,0))
            continue:KMDRowId2=""
            s MKBDMRowId = $LG($G(^User.MKBKLMappingDetailD(KMDRowId2)),2)
            
            if (MKBDMRowId'="")
            {
                s MKBDMCode=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),2)
                s MKBDMDesc=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),3)
                s MKBDMPath=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),4)
                s MKBDMSource=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),5)
                s MKBDMType=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),6)
                s MKBDMUpdateUser=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),7)
                s:MKBDMUpdateUser'="" SSUSRName=$p($g(^SSU("SSUSR",MKBDMUpdateUser)),"^",2)
                s:MKBDMUpdateUser="" SSUSRName=""
                s MKBDMUpdateDate=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),8)
                s:MKBDMUpdateDate'="" MKBDMUpdateDate=$zd(MKBDMUpdateDate,3)
                s MKBDMFlag=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),10)
                s MKBDMNote=$LISTGET($G(^User.MKBDocManageD(MKBDMRowId)),11)   
                s count=count+1
                s doctd="<td>"_MKBDMDesc_"</td><td>"_SSUSRName_"</td><td>"_MKBDMUpdateDate_"</td><td style='text-align:center'><a href='#' class='pre'><img style='cursor:pointer' src='../scripts/bdp/Framework/icons/mkb/detailsview.png' class='preview'><span style='display:none'>"_MKBDMPath_"<span></img></a></td><td style='text-align:center'><a href='#' class='load'><img style='cursor:pointer' src='../scripts/bdp/Framework/icons/mkb/load.png' class='download'><span style='display:none'>"_MKBDMPath_"</span></img></a></td>"
                s doctr=doctr_"<tr>"_doctd_"</tr>"
            }
        }  
      s dochtml="<tr><th width='35%'>文件名<span style='display:none' id='countdoc'>"_count_"<span></th><th>上传人</th><th>上传时间</th><th style='text-align:center'>预览</th><th style='text-align:center'>下载</th></tr>"_doctr 
    } 
  
  q dochtml
}

}
