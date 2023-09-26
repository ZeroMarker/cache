/// Creator:chendailei
/// web.DHCBL.MKB.MKBWikiFrequencyService
Class web.DHCBL.MKB.MKBWikiFrequencyService Extends %SOAP.WebService [ ProcedureBlock ]
{

// Parameter LOCATION = "https://mkb.mediway.com.cn/dthealth/web/";

Parameter LOCATION = "http://192.144.152.252/dthealth/web/";

/// WebService 的名称.
Parameter SERVICENAME = "MKBWikiFrequencyService";

/// TODO:将此更改为实际 SOAP namespace.
/// WebService 的 SOAP Namespace
Parameter NAMESPACE = "http://tempuri.org";

/// 引用类的 Namespace 将在 WSDL 中使用.
Parameter USECLASSNAMESPACES = 1;

Method Test(input) As %String [ WebMethod ]
{
	q "Test^"_input
}

/// Description:保存-入参为表名^数据ID^数据描述
/// Table:SQLUser.MKB_WikiFrequency
/// Input:SaveDataStr：知识库名的Flag^中心词ID^中心词描述
/// Return:成功返回success:'true'和新增或修改的数据的ID;失败返回success:'false'和失败原因
Method SaveData(SaveDataStr) As %String [ WebMethod ]
{
	s eobj=##class(web.Entity.MKB.MKBWikiFrequency).%New()
	s TableFlag=$P(SaveDataStr,"^",1)        //获得Flag
	s TableId=$o( ^User.MKBTermBaseI("FlagIndex"," "_$ZCONVERT(TableFlag,"U"),0)) //获得表的
	s eobj.MKBWFTableName="User.MKBTerm"_TableId                       //拼接表名
	s eobj.MKBWFDataReference=$P(SaveDataStr,"^",2)                                 //术语ID
	s eobj.MKBWFDesc=$P(SaveDataStr,"^",3)                        //描述
	S rs=##class(web.DHCBL.MKB.MKBWikiFrequency).SaveEntity(eobj)
	q rs
}

/// Description:获取频次最高的前n条数据描述-入参1为表名，入参2为n
/// Table:SQLUser.MKB_WikiFrequency
/// Input:MKBFlag-知识库标志，n-前n条数据
/// Return返回频次最高的前n条数据描述 id^描述^频次：MKBWFDataReference^MKBWFDesc^MKBWFFrequency&&MKBWFDataReference^MKBWFDesc^MKBWFFrequency……
/// Other:w ##class(web.DHCBL.MKB.MKBWikiFrequency).HighestFreData("Loc",3)
Method HighestFreData(MKBFlag As %String, n As %Integer) As %String [ WebMethod ]
{
	k ^MKBFTMP
 	s TableId=$o( ^User.MKBTermBaseI("FlagIndex"," "_$ZCONVERT(MKBFlag,"U"),0)) //获得知识库的id作为表名的后缀
	s MKBWFTableName="User.MKBTerm"_TableId                       //拼接表名
 	s MKBWFDataReference=0
 	s sum=0
 	s result=""
 	//w MKBWFTableName,!
 	for
 	{
	 	s MKBWFDataReference=$o(^User.MKBWikiFrequencyI("TableReferenceIdx"," "_$ZCONVERT(MKBWFTableName,"U"),MKBWFDataReference))    //遍历对应知识库的术语
	 	q:MKBWFDataReference=""
	 	//w MKBWFDataReference,!
	 	s RowId=0
	 	s count=0
	 	for
	 	{
		 	s RowId=$o(^User.MKBWikiFrequencyI("TableReferenceIdx"," "_$ZCONVERT(MKBWFTableName,"U"),MKBWFDataReference,RowId))
		 	q:RowId=""
		 	s MKBFDate=$lg(^User.MKBWikiFrequencyD(RowId),5)
		 	s NowDate=$p($h,",",1)
		 	
			if ((NowDate-MKBFDate)<30)
			{
				s count=count+1
			}
	 	}
	 	if ($o(^MKBFTMP(count-1))'=count)
	 	{
		 	s ^MKBFTMP(count)=MKBWFDataReference
	 	}
	 	else
	 	{
		 	s ^MKBFTMP(count,sum)=MKBWFDataReference
		 	
	 	}
	 	s sum=sum+1
	 	//s Frequency=$lg(^User.MKBWikiFrequencyD(RowId),5)
	 	//s ^CDL(Frequency)=""           //将频率存入临时global中自动排序
	 	//s sum=sum+1
 	}
 	if (n>sum)             //当所要求数据大于总数据时
 	{
	 	s n=sum
 	}
 	s Frequency=$o(^MKBFTMP(""),-1)
 	for i=1:1:n
 	{
	 	
	 	s TermId=^MKBFTMP(Frequency)
	 	//w TermId,!
	 	s MKBFDesc=$lg(^User.MKBTermD(TermId),3)
	 	s MKBWFDataReference=TermId
	 	s MKBWFDesc=MKBFDesc
	 	s MKBWFFrequency=Frequency
	 	if (result="")
	 	{
		 	s result=MKBWFDataReference_"^"_MKBWFDesc_"^"_MKBWFFrequency
	 	}
	 	else
	 	{
		 	s result=result_"&&"_MKBWFDataReference_"^"_MKBWFDesc_"^"_MKBWFFrequency
	 	}
	 	
	 	if ($o(^MKBFTMP(Frequency,0))="")
	 	{
		 	s Frequency=$o(^MKBFTMP(Frequency),-1)
	 	}
	 	else
	 	{
		 	s Id=0
		 	for
		 	{
			 	if (i>=n)
	 			{
		 			q
	 			}
			 	s Id=$o(^MKBFTMP(Frequency,Id))
			 	q:Id=""
			 	s TermId=^MKBFTMP(Frequency,Id)
	 			s MKBFDesc=$lg(^User.MKBTermD(TermId),3)
	 			s MKBWFDataReference=TermId
	 			s MKBWFDesc=MKBFDesc
	 			s MKBWFFrequency=Frequency
	 			if (result="")
	 			{
		 			s result=MKBWFDataReference_"^"_MKBWFDesc_"^"_MKBWFFrequency
	 			}
	 			else
	 			{
		 			s result=result_"&&"_MKBWFDataReference_"^"_MKBWFDesc_"^"_MKBWFFrequency
	 			}
	 			s i=i+1
	 			
		 	}
		 	s Frequency=$o(^MKBFTMP(Frequency),-1)
		 	
	 	}
	 	
	 	
	 	
 	}
 	q result
}

/// Description：查询诊断属性父表内容(即小程序title)
/// input：termdr 中心词id 
/// output: MKBTPRowId 属性id（titleid）  MKBTPDesc 属性内容（title描述）
Query GetList(rowid, termdr, desc) As %Query(ROWSPEC = "MKBTPRowId,MKBTPDesc,MKBTPDDesc,MKBTPType,MKBTPTermDr,MKBTPConfig,MKBTPName,MKBTPFlag,MKBTPPublic,MKBTPDefinedNode,MKBTPSequence")
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
            s MKBTPRowId=0
            for  
            {   
                s MKBTPRowId=$o(^User.MKBTermPropertyI("TermIndex",termdr,MKBTPRowId)) q:MKBTPRowId="" 
                s MKBTPDesc=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),3)
                s MKBTPDescU=$ZCONVERT(MKBTPDesc,"U")
                s MKBTPType=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),4)
                s MKBTPDDesc=##class(web.DHCBL.MKB.MKBTermProperty).GetDetail(MKBTPType,MKBTPRowId)  //缩略名
                continue:MKBTPDDesc=""
                s MKBTPTermDr=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),6)
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
                s MKBTPFlag=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),8)
                s MKBTPPublic=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),9)
                s DefinedNode=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),10)
                s:DefinedNode'="" MKBTPDefinedNode=$listget($g(^User.MKBTermD(DefinedNode)),3) 
                s:DefinedNode="" MKBTPDefinedNode="" 
        
                s MKBTPSequence=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),11)
                
                s PINYIN=""
                s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBTPDescU)
                i ((MKBTPDescU[desc)||(PINYIN[desc))   //条件
                {
                    d OutputRow
                }       
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(MKBTPRowId,MKBTPDesc,MKBTPDDesc,MKBTPType,MKBTPTermDr,MKBTPConfig,MKBTPName,MKBTPFlag,MKBTPPublic,MKBTPDefinedNode,MKBTPSequence)
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

/// Description：查询诊断属性父表内容(即小程序title)
/// input：rowid:属性rowid（可为空）, termdr:疾病诊断id, desc:属性描述（可为空） 
/// output: 属性id（titleid）^属性内容（title描述）^属性值^属性类型^对应诊断Id^配置项^属性名^属性标识^公有属性标识^起始节点^顺序&&…… MKBTPRowId_"^"_MKBTPDesc_"^"_MKBTPDDesc_"^"_MKBTPType_"^"_MKBTPTermDr_"^"_MKBTPConfig_"^"_MKBTPName_"^"_MKBTPFlag_"^"_MKBTPPublic_"^"_MKBTPDefinedNode_"^"_MKBTPSequence
/// others:d ##class(web.DHCBL.MKB.MKBWikiFrequency).GetTitleData("",15805,"")
Method GetTitleData(rowid, termdr, desc) As %String [ WebMethod ]
{
 
	//s Flag=0
	s result=""
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
        s result=MKBTPRowId_"^"_MKBTPDesc_"^"_MKBTPDDesc_"^"_MKBTPType_"^"_MKBTPTermDr_"^"_MKBTPConfig_"^"_MKBTPName_"^"_MKBTPFlag_"^"_MKBTPPublic_"^"_MKBTPDefinedNode_"^"_MKBTPSequence
    }
    else
    {
        if (termdr'=""){
            s:desc'="" desc=$ZCONVERT(desc,"U")
            s MKBTPRowId=0
            for  
            {   
                s MKBTPRowId=$o(^User.MKBTermPropertyI("TermIndex",termdr,MKBTPRowId)) q:MKBTPRowId="" 
                s MKBTPDesc=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),3)
                s MKBTPDescU=$ZCONVERT(MKBTPDesc,"U")
                s MKBTPType=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),4)
                s MKBTPDDesc=##class(web.DHCBL.MKB.MKBTermProperty).GetDetail(MKBTPType,MKBTPRowId)  //缩略名
                continue:MKBTPDDesc=""
                s MKBTPTermDr=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),6)
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
                s MKBTPFlag=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),8)
                s MKBTPPublic=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),9)
                s DefinedNode=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),10)
                s:DefinedNode'="" MKBTPDefinedNode=$listget($g(^User.MKBTermD(DefinedNode)),3) 
                s:DefinedNode="" MKBTPDefinedNode="" 
        
                s MKBTPSequence=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),11)
                
                s PINYIN=""
                s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBTPDescU)
                i ((MKBTPDescU[desc)||(PINYIN[desc))   //条件
                {
					if (result="")
					{
						s result=MKBTPRowId_"^"_MKBTPDesc_"^"_MKBTPDDesc_"^"_MKBTPType_"^"_MKBTPTermDr_"^"_MKBTPConfig_"^"_MKBTPName_"^"_MKBTPFlag_"^"_MKBTPPublic_"^"_MKBTPDefinedNode_"^"_MKBTPSequence
						//s Flag=1
					}
					else
					{
						s result=result_"&&"_MKBTPRowId_"^"_MKBTPDesc_"^"_MKBTPDDesc_"^"_MKBTPType_"^"_MKBTPTermDr_"^"_MKBTPConfig_"^"_MKBTPName_"^"_MKBTPFlag_"^"_MKBTPPublic_"^"_MKBTPDefinedNode_"^"_MKBTPSequence
					}
                }       
            }
        }
    }
    q result
}

/// Description：获取属性内容列表的数据
/// input: property 属性id
/// Other:w ##class(web.DHCBL.MKB.MKBWikiFrequencyService).GetListHtml(4995)
Method GetListHtml(property As %String) As %String [ WebMethod ]
{
    s htmlstr=""
    q:property="" ""
    s MKBTPDRowId=0
    s MainClsName=$lg($g(^User.MKBTermPropertyD(property)),7)   //获得主列名即属性值列表中的第一列
    s AutoExtendCls=""           //扩展属性列表列名
    s ExtendProRowId=0
    for
    {
	    s ExtendProRowId=$o(^User.MKBTermPropertyD(property,"ChildExtPro",ExtendProRowId))
	    q:ExtendProRowId=""
	    s AutoExtendCls=AutoExtendCls_"<td>"_$lg($g(^User.MKBTermPropertyD(property,"ChildExtPro",ExtendProRowId)),2)_"</td></tr>"
    }
    s title="<tr><td>"_MainClsName_"</td><td>备注</td>"_AutoExtendCls
    s htmlstr=htmlstr_title
    for  
    {   
        s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProIdx",property,MKBTPDRowId)) q:MKBTPDRowId="" 
        s MKBTPDDesc=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)
        s MKBTPDDesc= ..EvalJSON(MKBTPDDesc)
        s:MKBTPDDesc="" MKBTPDDesc="暂无"
        s MKBTPDDescU=$ZCONVERT(MKBTPDDesc,"U")
        s MKBTPDRemark=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),7)
        s MKBTPDRemark= ..EvalJSON(MKBTPDRemark)
        s:MKBTPDRemark="" MKBTPDRemark="暂无"
        s MKBTPDSequence=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),9) 
        s ExtendStr=""   //知识点扩展属性子表的字段

        s subId=0  //循环扩展属性子表User.MKBTermProperty
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
            s:MKBTEPVValue="" MKBTEPVValue="暂无"
            s ExtendStr=ExtendStr_"<td>"_MKBTEPVValue_"</td>"
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

/// Description：用户参与编辑的疾病列表（包含状态、失败原因） 
/// input：flag="M"（必传）
Query KnoManageGetList(rowid As %String, desc As %String, flag As %String, username As %String) As %Query(ROWSPEC = "MKBKMRowId,MKBKMCode,MKBKMDesc,MKBKMSource,MKBKMType,SSUSRName,MKBKMUpdateDate,MKBKMFlag,MKBKMNote,MKBKMPath,MKBKMTermDr,MKBKMProDr,MKBKMUpdateLoc,MKBKMDetail,MKBKMMiniFlag,MKBKMFailureReason")
{
}

ClassMethod KnoManageGetListExecute(ByRef qHandle As %Binary, rowid As %String, desc As %String, flag As %String, username As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s len=0
 if (rowid'="") //根据rowid返回该条记录
 {
    s MKBKMRowId=rowid
    s MKBKMCode=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),2)
    s MKBKMDesc=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),3)
    s MKBKMPath=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),4)
    s MKBKMSource=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),5)
    s MKBKMType=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),6)
    s SSUSRName=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),7)
    //s:MKBKMUpdateUser'="" SSUSRName=$p($g(^SSU("SSUSR",MKBKMUpdateUser)),"^",2)//2019-09-09
    //s:MKBKMUpdateUser="" SSUSRName=""
    s MKBKMUpdateDate=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),8)
    s:MKBKMUpdateDate'="" MKBKMUpdateDate=$zd(MKBKMUpdateDate,3)
    s MKBKMFlag=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),9)
    s MKBKMNote=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),10)
    s MKBKMUpdateLoc = $LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),11)
    s:MKBKMUpdateLoc'="" MKBKMUpdateLoc=$p($g(^CTLOC(MKBKMUpdateLoc)),"^",2)
    s:MKBKMUpdateLoc="" MKBKMUpdateLoc=""
    s MKBKMTermDr = $LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),12)
    s:MKBKMTermDr'="" MKBKMTermDr=$LISTGET($g(^User.MKBTermD(MKBKMTermDr)),3)
    s MKBKMProDr = $LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),13)
    s:MKBKMProDr'="" MKBKMProDr=$LISTGET($g(^User.MKBTermPropertyD(MKBKMProDr)),3)
    s MKBKMDetailo =  $LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),14)
    s:MKBKMDetailo'="" len = $L(MKBKMDetailo,"^")
    s MKBKMDetail=""
    for i=0:1:len
    {
       s MKBKMDetaili=$p($g(MKBKMDetailo),"^",i)
       s DetailiDesc = ##class(web.DHCBL.MKB.MKBTermProDetail).GetDesc(MKBKMDetaili)
       s:MKBKMDetail'="" MKBKMDetail=MKBKMDetail_"^"_DetailiDesc
       s:MKBKMDetail="" MKBKMDetail=DetailiDesc
    }
    s MKBKMMiniFlag=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),15)
    s MKBKMFailureReason=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),16)
    d OutputRow
 }
 else
 {
    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    s MKBKMRowId=""
    for{  
        s MKBKMRowId=$o(^User.MKBKnoManageD(MKBKMRowId),-1) q:MKBKMRowId=""   
        s MKBKMCode=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),2)
        s MKBKMDesc=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),3)
        s MKBKMPath=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),4)
        s MKBKMSource=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),5)
        s MKBKMType=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),6)
        s SSUSRName=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),7)
        //s:MKBKMUpdateUser'="" SSUSRName=$p($g(^SSU("SSUSR",MKBKMUpdateUser)),"^",2)
        //s:MKBKMUpdateUser="" SSUSRName=""
        s MKBKMUpdateDate=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),8)
        s:MKBKMUpdateDate'="" MKBKMUpdateDate=$zd(MKBKMUpdateDate,3)
        s MKBKMFlag=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),9)
        /*s:(MKBKMFlag'="Y")&&(MKBKMFlag'="N") MKBKMFlag="初传"
        s:MKBKMFlag="N" MKBKMFlag="审核未通过"
        s:MKBKMFlag="Y" MKBKMFlag="审核通过"*/
        s MKBKMNote=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),10)
        s MKBKMUpdateLoc = $LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),11)
        s:MKBKMUpdateLoc'="" MKBKMUpdateLoc=$p($g(^CTLOC(MKBKMUpdateLoc)),"^",2)
        s:MKBKMUpdateLoc="" MKBKMUpdateLoc=""
        s MKBKMTermDr = $LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),12)
        s:MKBKMTermDr'="" MKBKMTermDr=$LISTGET($g(^User.MKBTermD(MKBKMTermDr)),3)
        s MKBKMProDr = $LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),13)
        s:MKBKMProDr'="" MKBKMProDr=$LISTGET($g(^User.MKBTermPropertyD(MKBKMProDr)),3)
        s MKBKMDetailo =  $LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),14)
        s:MKBKMDetailo'="" len = $L(MKBKMDetailo,"^")
        s MKBKMDetail=""
        for i=0:1:len
        {
           s MKBKMDetaili=$p($g(MKBKMDetailo),"^",i)
           s DetailiDesc = ##class(web.DHCBL.MKB.MKBTermProDetail).GetDesc(MKBKMDetaili)
           s:MKBKMDetail'="" MKBKMDetail=MKBKMDetail_"^"_DetailiDesc
           s:MKBKMDetail="" MKBKMDetail=DetailiDesc
        }
        s MKBKMMiniFlag=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),15)
   		s MKBKMFailureReason=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),16)

        s PINYIN=""
        s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBKMDesc)  
        if ((($ZCONVERT(MKBKMDesc,"U")[desc)||(PINYIN[desc)) && (MKBKMMiniFlag[flag) && (SSUSRName[username))
        {
            d OutputRow
        }
    }
 }

 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(MKBKMRowId,MKBKMCode,MKBKMDesc,MKBKMSource,MKBKMType,SSUSRName,MKBKMUpdateDate,MKBKMFlag,MKBKMNote,MKBKMPath,MKBKMTermDr,MKBKMProDr,MKBKMUpdateLoc,MKBKMDetail,MKBKMMiniFlag,MKBKMFailureReason)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod KnoManageGetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = KnoManageGetListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod KnoManageGetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = KnoManageGetListExecute ]
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

/// Description：用户参与编辑的疾病列表（包含状态、失败原因） 
/// input：rowid, desc:描述， flag="M"（必传）, username:用户名
/// return: MKBKMRowId(RowId)^MKBKMCode(代码)^MKBKMDesc(描述)^MKBKMSource(出处)^MKBKMType(类型)^MKBKMUpdateUser(上传人)^SSUSRName(上传人姓名)^MKBKMUpdateDate(上传时间)^MKBKMFlag(审核状态)^MKBKMNote(备注)^MKBKMPath(路径)^MKBKMTermDr(术语Id)^MKBKMProDr(属性Id)^MKBKMUpdateLoc(科室)^MKBKMDetail(扩展属性Id串)^MKBKMMiniFlag(微信小程序(mini)和电脑端(computer)的区分标志)^MKBKMFailureReason(审核不通过的原因)
/// others:d ##class(web.DHCBL.MKB.MKBWikiFrequency).GetKnoManageData("","","M","")
Method GetKnoManageData(rowid As %String, desc As %String, flag As %String, username As %String) As %String [ WebMethod ]
{
 s len=0
 s result=""
 if (rowid'="") //根据rowid返回该条记录
 {
    s MKBKMRowId=rowid
    s MKBKMCode=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),2)
    s MKBKMDesc=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),3)
    s MKBKMPath=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),4)
    s MKBKMSource=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),5)
    s MKBKMType=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),6)
    s SSUSRName=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),7)
    //s:MKBKMUpdateUser'="" SSUSRName=$p($g(^SSU("SSUSR",MKBKMUpdateUser)),"^",2)//2019-09-09
    //s:MKBKMUpdateUser="" SSUSRName=""
    s MKBKMUpdateDate=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),8)
    s:MKBKMUpdateDate'="" MKBKMUpdateDate=$zd(MKBKMUpdateDate,3)
    s MKBKMFlag=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),9)
    s MKBKMNote=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),10)
    s MKBKMUpdateLoc = $LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),11)
    s:MKBKMUpdateLoc'="" MKBKMUpdateLoc=$p($g(^CTLOC(MKBKMUpdateLoc)),"^",2)
    s:MKBKMUpdateLoc="" MKBKMUpdateLoc=""
    s MKBKMTermDr = $LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),12)
    s:MKBKMTermDr'="" MKBKMTermDr=$LISTGET($g(^User.MKBTermD(MKBKMTermDr)),3)
    s MKBKMProDr = $LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),13)
    s:MKBKMProDr'="" MKBKMProDr=$LISTGET($g(^User.MKBTermPropertyD(MKBKMProDr)),3)
    s MKBKMDetailo =  $LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),14)
    s:MKBKMDetailo'="" len = $L(MKBKMDetailo,"^")
    s MKBKMDetail=""
    for i=0:1:len
    {
       s MKBKMDetaili=$p($g(MKBKMDetailo),"^",i)
       s DetailiDesc = ##class(web.DHCBL.MKB.MKBTermProDetail).GetDesc(MKBKMDetaili)
       s:MKBKMDetail'="" MKBKMDetail=MKBKMDetail_"^"_DetailiDesc
       s:MKBKMDetail="" MKBKMDetail=DetailiDesc
    }
    s MKBKMMiniFlag=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),15)
    s MKBKMFailureReason=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),16)
    s result=MKBKMRowId_"^"_MKBKMCode_"^"_MKBKMDesc_"^"_MKBKMSource_"^"_MKBKMType_"^"_SSUSRName_"^"_MKBKMUpdateDate_"^"_MKBKMFlag_"^"_MKBKMNote_"^"_MKBKMPath_"^"_MKBKMTermDr_"^"_MKBKMProDr_"^"_MKBKMUpdateLoc_"^"_MKBKMDetail_"^"_MKBKMMiniFlag_"^"_MKBKMFailureReason
 }
 else
 {
    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    s MKBKMRowId=""
    for{  
        s MKBKMRowId=$o(^User.MKBKnoManageD(MKBKMRowId),-1) q:MKBKMRowId=""   
        s MKBKMCode=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),2)
        s MKBKMDesc=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),3)
        s MKBKMPath=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),4)
        s MKBKMSource=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),5)
        s MKBKMType=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),6)
        s SSUSRName=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),7)
        //s:MKBKMUpdateUser'="" SSUSRName=$p($g(^SSU("SSUSR",MKBKMUpdateUser)),"^",2)
        //s:MKBKMUpdateUser="" SSUSRName=""
        s MKBKMUpdateDate=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),8)
        s:MKBKMUpdateDate'="" MKBKMUpdateDate=$zd(MKBKMUpdateDate,3)
        s MKBKMFlag=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),9)
        /*s:(MKBKMFlag'="Y")&&(MKBKMFlag'="N") MKBKMFlag="初传"
        s:MKBKMFlag="N" MKBKMFlag="审核未通过"
        s:MKBKMFlag="Y" MKBKMFlag="审核通过"*/
        s MKBKMNote=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),10)
        s MKBKMUpdateLoc = $LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),11)
        s:MKBKMUpdateLoc'="" MKBKMUpdateLoc=$p($g(^CTLOC(MKBKMUpdateLoc)),"^",2)
        s:MKBKMUpdateLoc="" MKBKMUpdateLoc=""
        s MKBKMTermDr = $LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),12)
        s:MKBKMTermDr'="" MKBKMTermDr=$LISTGET($g(^User.MKBTermD(MKBKMTermDr)),3)
        s MKBKMProDr = $LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),13)
        s:MKBKMProDr'="" MKBKMProDr=$LISTGET($g(^User.MKBTermPropertyD(MKBKMProDr)),3)
        s MKBKMDetailo =  $LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),14)
        s:MKBKMDetailo'="" len = $L(MKBKMDetailo,"^")
        s MKBKMDetail=""
        for i=0:1:len
        {
           s MKBKMDetaili=$p($g(MKBKMDetailo),"^",i)
           s DetailiDesc = ##class(web.DHCBL.MKB.MKBTermProDetail).GetDesc(MKBKMDetaili)
           s:MKBKMDetail'="" MKBKMDetail=MKBKMDetail_"^"_DetailiDesc
           s:MKBKMDetail="" MKBKMDetail=DetailiDesc
        }
        s MKBKMMiniFlag=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),15)
   		s MKBKMFailureReason=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),16)

        s PINYIN=""
        s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBKMDesc)  
        if ((($ZCONVERT(MKBKMDesc,"U")[desc)||(PINYIN[desc)) && (MKBKMMiniFlag[flag) && (SSUSRName[username))
        {
			if (result="")
			{
				s result=MKBKMRowId_"^"_MKBKMCode_"^"_MKBKMDesc_"^"_MKBKMSource_"^"_MKBKMType_"^"_SSUSRName_"^"_MKBKMUpdateDate_"^"_MKBKMFlag_"^"_MKBKMNote_"^"_MKBKMPath_"^"_MKBKMTermDr_"^"_MKBKMProDr_"^"_MKBKMUpdateLoc_"^"_MKBKMDetail_"^"_MKBKMMiniFlag_"^"_MKBKMFailureReason
				//s Flag=1
			}
			else
			{
				s result=result_"&&"_MKBKMRowId_"^"_MKBKMCode_"^"_MKBKMDesc_"^"_MKBKMSource_"^"_MKBKMType_"^"_SSUSRName_"^"_MKBKMUpdateDate_"^"_MKBKMFlag_"^"_MKBKMNote_"^"_MKBKMPath_"^"_MKBKMTermDr_"^"_MKBKMProDr_"^"_MKBKMUpdateLoc_"^"_MKBKMDetail_"^"_MKBKMMiniFlag_"^"_MKBKMFailureReason
			}
        }
    }
 }

    q result
}

/// Description：保存微信小程序提供的数据
/// input: note（修改备注，即要修改的内容）, termid（修改的中心词id）, proid（修改的属性id）, detail（修改的属性内容）
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other:w ##class(web.DHCBL.MKB.MKBKnoManage).SaveMiniData("11111111","","","")
Method SaveMiniData(note, termid, proid, detail, username) As %String [ WebMethod ]
{
    
    s result = ""
    Set UpdateDate=$p($h,",",1)       //上传日期
   

    s obj=##class(User.MKBKnoManage).%New()
    s obj.MKBKMUpdateDate = UpdateDate
    s obj.MKBKMType = ""
    s obj.MKBKMNote = note
   
    d:termid'="" obj.MKBKMTermDrSetObjectId(termid)
    d:proid'="" obj.MKBKMProDrSetObjectId(proid)
    s obj.MKBKMDetail = detail
    s obj.MKBKMMiniFlag = "M"
  	s obj.MKBKMUpdateUser = username
    Ts
    s sc=obj.%Save()
    d obj.%Close()
    If $$$ISOK(sc){
        Tc
        s id = obj.%Id()
        s result = "{success:'true',id:'"_id_"'}" //返回RowId
    }else{
        Trollback
        s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
    }
      
  
    /*else
    {
        s result = "{success:'false',errorinfo:'对象不存在'}"
    }*/
    
    q result
}

/// Description:获取疾病列表
/// Table：User.MKBTerm
/// Input：rowid,desc:疾病描述
/// Output: rowID、中心词、拼音码、备注
/// d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBWikiFrequencyService","GetDataForCmb2","","")
Query GetDataForCmb2(rowid As %String, desc As %String) As %Query(ROWSPEC = "MKBTRowId:%String,MKBTDesc:%String,MKBTPYCode:%String,MKBTNote:%String")
{
}

ClassMethod GetDataForCmb2Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String) As %Status
{
	
	s repid=$I(^CacheTemp)
	s ind=1
	
	s base = ##class(web.DHCBL.MKB.MKBTermBase).GetIdByFlag("Diagnose")
	if (rowid'="") //根据rowid返回该条记录
	{
		s MKBTRowId=rowid
		s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTRowId)),3)  //描述
		s MKBTPYCode=$listGet($g(^User.MKBTermD(MKBTRowId)),6)  //检索码
		s MKBTNote=$listGet($g(^User.MKBTermD(MKBTRowId)),7)  //备注
		d OutputRowCmb
	}
	else
	{

		s MKBTRowId=""
		for  
		{	
			s MKBTRowId=$o(^User.MKBTermI("BaseIndex",base,MKBTRowId)) 
			q:MKBTRowId=""
			s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTRowId)),3)  //描述
			s MKBTPYCode=$listGet($g(^User.MKBTermD(MKBTRowId)),6)  //检索码
			s MKBTNote=$listGet($g(^User.MKBTermD(MKBTRowId)),7)  //备注
			
			s outDiaFlag=""  //输出标识
			if (desc'="")  //如果诊断不为空
			{
				s:desc'="" desc=$ZCONVERT(desc,"U")
				

				//可以根据检索码，描述来查询  				 			
				s isDescKey=($ZCONVERT(MKBTPYCode,"U")[desc) //检索码
				s isDesc=($ZCONVERT(MKBTDesc,"U")[desc)  //描述
				i (isDescKey)||(isDesc)
				{
					s outDiaFlag="Y"
				}
				
			}
			else  //如果诊断为空
			{
				s outDiaFlag="Y"
			}
					
			i (outDiaFlag="Y")   //条件
			{
				d OutputRowCmb
	        }

		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(MKBTRowId,MKBTDesc,MKBTPYCode,MKBTNote)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb2Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb2Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDataForCmb2Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb2Execute ]
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

/// Description:获取疾病列表
/// Table：User.MKBTerm
/// Input：rowid,desc:疾病描述(rowid和desc均可为空)
/// Output: rowID^中心词^拼音码^备注 MKBTRowId^MKBTDesc^MKBTPYCode^MKBTNote&&MKBTRowId^MKBTDesc^MKBTPYCode^MKBTNote……
/// w ##class(web.DHCBL.MKB.MKBWikiFrequencyService).GetDiseaseList("","")
ClassMethod GetDiseaseList(rowid As %String, desc As %String) As %String [ WebMethod ]
{
	
	//s Flag=0
	s result=""
	s base = ##class(web.DHCBL.MKB.MKBTermBase).GetIdByFlag("Diagnose")
	if (rowid'="") //根据rowid返回该条记录
	{
		s MKBTRowId=rowid
		s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTRowId)),3)  //描述
		s MKBTPYCode=$listGet($g(^User.MKBTermD(MKBTRowId)),6)  //拼音码
		s MKBTNote=$listGet($g(^User.MKBTermD(MKBTRowId)),7)  //备注
		s result=MKBTRowId_"^"_MKBTDesc_"^"_MKBTPYCode_"^"_MKBTNote
	}
	else
	{

		s MKBTRowId=""
		for  
		{	
			s MKBTRowId=$o(^User.MKBTermI("BaseIndex",base,MKBTRowId)) 
			q:MKBTRowId=""
			s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTRowId)),3)  //描述
			s MKBTPYCode=$listGet($g(^User.MKBTermD(MKBTRowId)),6)  //拼音码
			s MKBTNote=$listGet($g(^User.MKBTermD(MKBTRowId)),7)  //备注
			
			s outDiaFlag=""  //输出标识
			s isDesc=1
			//s isDescKey=1
			if (desc'="")  //如果诊断不为空
			{
				s:desc'="" desc=$ZCONVERT(desc,"U")
				if (desc[" ")
				{
					
					s KeywordsNum=$l(desc," ")
					for i=1:1:KeywordsNum
					{
						s Keywords=$p(desc," ",i)
						s isDesc=isDesc&($ZCONVERT(MKBTDesc,"U")[Keywords)  //描述
						if (isDesc=0)
						{
							q
						}
					}
				}
				else
				{
					s isDesc=($ZCONVERT(MKBTDesc,"U")[desc)  //描述
				}
				///可以根据检索码，描述来查询  				 			
				s isDescKey=($ZCONVERT(MKBTPYCode,"U")[desc) //检索码
				///根据别名查询
				s OtherNameProId=$o(^User.MKBTermPropertyI("DescIndex",MKBTRowId," 别名",0))
				s OtherNameDetailId=$o(^User.MKBTermProDetailI("ProIdx",OtherNameProId,0))
				if (OtherNameDetailId)
				{
					s OtherName=$lg($g(^User.MKBTermProDetailD(OtherNameDetailId)),3)
				}
				else
				{
					s OtherName=""
				}
				s isOtherName=($ZCONVERT(OtherName,"U")[desc) //别名
				
				
				i (isDescKey)||(isDesc)||(isOtherName)
				{
					s outDiaFlag="Y"
				}
				
			}
			else  //如果诊断为空
			{
				s outDiaFlag="Y"
			}
					
			i (outDiaFlag="Y")   //条件
			{
				if (result="")
				{
					s result=MKBTRowId_"^"_MKBTDesc_"^"_MKBTPYCode_"^"_MKBTNote
					//s Flag=1
				}
				else
				{
					s result=result_"&&"_MKBTRowId_"^"_MKBTDesc_"^"_MKBTPYCode_"^"_MKBTNote
				}
	        }

		}
	}
    q result
}

/// Description：获取树形属性内容数据
/// Table：User.MKBTermProDetail
/// Input：父节点 
/// Return：treegrid格式数据串
/// w ##class(web.DHCBL.MKB.MKBEncyclopedia).GetJsonList("","")
/// w ##class(web.DHCBL.MKB.MKBWikiFrequencyService).GetJsonList("","4998")
Method GetJsonList(id As %String, property As %String) As %String [ WebMethod ]
{
	s result=""
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
    s result=result_"["
    s count=0
    for 
    {
        s mySeq=$o(myArray(mySeq)) q:(mySeq="")
        s myRowID=$g(myArray(mySeq))
        //continue:$LISTGET($G(^User.MKBTermProDetailD(myRowID)),6)'="Y"
        s count=count+1
        s MKBTPDDesc=$LISTGET($G(^User.MKBTermProDetailD(myRowID)),3)
        s MKBTPDDesc=$tr(MKBTPDDesc,"""","")
        s:MKBTPDDesc="" MKBTPDDesc="暂无"
        if count>1 s result=result_","
        s MKBTPDCode=$LISTGET($G(^User.MKBTermProDetailD(myRowID)),2)
        s:MKBTPDCode="" MKBTPDCode="暂无"
        s MKBTPDRemark=$LISTGET($G(^User.MKBTermProDetailD(myRowID)),7)
        s:MKBTPDRemark="" MKBTPDRemark="暂无"
        s MKBTPDSequence=$LISTGET($G(^User.MKBTermProDetailD(myRowID)),9)
        s:MKBTPDSequence="" MKBTPDSequence="暂无"
        s MKBTPDLastLevel=$LISTGET($G(^User.MKBTermProDetailD(myRowID)),4)
        if MKBTPDLastLevel'="" s MKBTPDLastLevel=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDLastLevel)),3)
        s MKBTPDLevel=$LISTGET($G(^User.MKBTermProDetailD(myRowID)),5)
        s result=result_"{""id"":"""_myRowID_""""
        s result=result_",""MKBTPDCode"":"""_MKBTPDCode_""",""MKBTPDDesc"":"""_MKBTPDDesc_""",""MKBTPDRemark"":"""_MKBTPDRemark_""",""MKBTPDLastLevel"":"""_MKBTPDLastLevel_""",""MKBTPDSequence"":"""_MKBTPDSequence_""",""MKBTPDLevel"":"""_MKBTPDLevel_""""
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
            s MKBTEPVValue=..EvalJSON(MKBTEPVValue) 
            s:MKBTEPVValue="" MKBTEPVValue="暂无"
            s:ExtendStr'="" ExtendStr=ExtendStr_",""Extend"_subId_""":"""_MKBTEPVValue_""""
            s:ExtendStr="" ExtendStr="""Extend"_subId_""":"""_MKBTEPVValue_""""
            
        }
        if ExtendStr'=""
        {
            s result=result_","_ExtendStr
        }
        s childStr=##class(web.DHCBL.MKB.MKBTermProDetail).GetChildOrderedIDStr(myRowID,property)
        if childStr'=""
        {
            //一次性加载   
            s result=result_",""state"":""open"""   //closed节点不展开,open节点展开
            s result=result_",""children"":"
            s result=result_(..GetJsonList(myRowID,property))
        }
        else
        {
            s result=result_",""state"":""open"""
        }
        s result=result_"}"
        
    }
    s result=result_ "]"
    q result
}

/// Description：获取树形属性内容标题
/// Table：User.MKBTermProDetail
/// Input：id:父节点id  property:属性值
/// Return：treegrid格式数据串
/// w ##class(web.DHCBL.MKB.MKBEncyclopedia).GetJsonList("","")
/// w ##class(web.DHCBL.MKB.MKBWikiFrequencyService).GetTreePropertyTitle("","4998")
ClassMethod GetTreePropertyTitle(id As %String, property As %String) As %String [ WebMethod ]
{
	s result="["
	s result=result_"{""id"":""ID"""
	s MKBTPDDesc=$lg($g(^User.MKBTermPropertyD(property)),7)   //获得主列名即属性值列表中的第一列
	s MKBTPDRemark="备注"
	s MKBTPDLastLevel="上级分类"
	s MKBTPDSequence="顺序"
	s MKBTPDLevel="级别"
	s result=result_",""MKBTPDCode"":""属性代码"",""MKBTPDDesc"":"""_MKBTPDDesc_""",""MKBTPDRemark"":"""_MKBTPDRemark_""",""MKBTPDLastLevel"":"""_MKBTPDLastLevel_""",""MKBTPDSequence"":"""_MKBTPDSequence_""",""MKBTPDLevel"":"""_MKBTPDLevel_""""
	s ExtendStr=""   //知识点扩展属性子表的字段
        s subId=0  //循环扩展属性子表User.MKBTermProperty
        for 
        {
            S subId=$o(^User.MKBTermPropertyD(property,"ChildExtPro",subId)) 
            q:subId=""
            s:ExtendStr'="" ExtendStr=ExtendStr_",""Extend"_subId_""":"""_$lg($g(^User.MKBTermPropertyD(property,"ChildExtPro",subId)),2)_""""
            s:ExtendStr="" ExtendStr="""Extend"_subId_""":"""_$lg($g(^User.MKBTermPropertyD(property,"ChildExtPro",subId)),2)_""""
            
        }
        if ExtendStr'=""
        {
            s result=result_","_ExtendStr
        }
            //一次性加载   
            s result=result_",""state"":""节点开合状态"""   //closed节点不展开,open节点展开
            s result=result_",""children"":""子节点"""
        s result=result_"}"
    s result=result_ "]"
    q result
}

/// Creator:chenghegui
/// CreatDate:2018-05-05
/// Description：获得属性内容不包括树形和列表型
/// Input：属性id,属性类型 
/// Return:属性内容文本串
/// w ##class(web.DHCBL.MKB.MKBEncyclopedia).GetDetailDesc("216394","F")
ClassMethod GetDetailDesc(id, type) As %String [ WebMethod ]
{
     q:((id="")||(type="")) ""
     s MKBTPDRowId=""
     s desc=""
     if ((type="TX")||(type="TA")||(type="SD")){
        for{
          s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProIdx",id,MKBTPDRowId)) q:MKBTPDRowId="" 
          s MKBTPDesc=$LISTGET($G(^User.MKBTermPropertyD(id)),3) 
          s MKBTPDDesc=$listGet($g(^User.MKBTermProDetailD(MKBTPDRowId)),3)  //描述
          s:type="SD" MKBTPDDesc=##class(web.DHCBL.MKB.MKBKnoExpression).GetDiagDesc(MKBTPDDesc)
          s desc="<span>"_"</span><span>"_MKBTPDDesc_"</span>"
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
                s:MKBTEPVValue="" MKBTEPVValue="暂无"
                s ExtendStr=ExtendStr_"<td>"_MKBTEPName_"</td><td>"_MKBTEPVValue_"</td>"
                s ExtendStr= "<tr>"_ExtendStr_"</tr>"
            }   
        s desc="<table  cellspacing='0'><tbody>"_"<tr>"_"<th colspan='2'>"_MKBTPDDesc_"</th></tr>"_ExtendStr_"</tbody></table>"
    }
  
   }
     q desc
}

/// Creator：谷雪萍
/// CreatDate: 2018-04-02
/// Description：引用属性类型属性内容维护模块-获取已选属性列表
/// Table：User.MKBTermProperty
/// Input：rowid, code, desc
/// return: id：属性：展示格式：属性格式：顺序：定义节点
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBTermProDetail","GetSelPropertyList","37")
Query GetSelPropertyList(property As %String) As %Query(ROWSPEC = "MKBTPRowId,MKBTPDesc,MKBTPShowType,MKBTPType,MKBTPOrder,MKBTPTreeNode,MKBTPChoice,MKBTPRequired,MKBTPTOrP")
{
}

ClassMethod GetSelPropertyListExecute(ByRef qHandle As %Binary, property As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
  
    if (property'="")
    {
	    s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProIdx",property,0))
		s MKBTPDDesc=""
		s:MKBTPDRowId'="" MKBTPDDesc=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)
		if (MKBTPDDesc'="")
		{
	        s argsLen=$Length(MKBTPDDesc,",")
	        for i=1:1:argsLen  
	        { 
	          s argstr=$p(MKBTPDDesc,",",i)
	          s MKBTPRowId=$p(argstr,"&",1)
	          s MKBTPShowType=$p(argstr,"&",2)  //展示格式
	          s MKBTPTreeNode=$p(argstr,"&",3)  //定义节点
	          s MKBTPChoice=$p(argstr,"&",4)  //单选多选 (S/D)
	          s:MKBTPChoice="" MKBTPChoice="S"   //默认是单选
	          s MKBTPRequired=$p(argstr,"&",5)  //是否必填（Y/N）
	          s:MKBTPRequired="" MKBTPRequired="N"  //默认不必填
	          s MKBTPTOrP=$p(argstr,"&",6)  //术语T或属性P
	          s:MKBTPTOrP="" MKBTPTOrP="P"  //默认属性P
	          s MKBTPOrder=i
	          s MKBTPDesc="",MKBTPType=""
	          if (MKBTPTOrP="T")   //术语
	          {
		          s MKBTPDesc=$LISTGET($G(^User.MKBTermBaseD(MKBTPRowId)),3) //术语库描述 
		          s MKBTPType=$LISTGET($G(^User.MKBTermBaseD(MKBTPRowId)),4)  //术语库格式
	          }
	          else   //属性
	          {
	          	  s MKBTPDesc=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),3) //属性描述 
	          	  s MKBTPType=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),4)  //属性格式
	          }
	          
	          d OutputRowSelPro
	        }
		}
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowSelPro
    set Data=$lb(MKBTPRowId,MKBTPDesc,MKBTPShowType,MKBTPType,MKBTPOrder,MKBTPTreeNode,MKBTPChoice,MKBTPRequired,MKBTPTOrP)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetSelPropertyListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSelPropertyListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetSelPropertyListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSelPropertyListExecute ]
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

/// Description：引用属性类型属性内容维护模块-获取已选属性列表
/// Table：User.MKBTermProperty
/// Input：Property:属性Id
/// return: 属性id^属性^展示格式^属性格式^顺序^定义节点^单选多选 (S/D)^是否必填（Y/N）^术语T或属性P MKBTPRowId,MKBTPDesc,MKBTPShowType,MKBTPType,MKBTPOrder,MKBTPTreeNode,MKBTPChoice,MKBTPRequired,MKBTPTOrP
/// others:w ##class(web.DHCBL.MKB.MKBWikiFrequencyService).GetSelPropertyData()
Method GetSelPropertyData(property As %String) As %String [ WebMethod ]
{
	s result=""
	s result="属性id^属性^展示格式^属性格式^顺序^定义节点^单选多选(S/D)^是否必填(Y/N)^术语T或属性P"
    if (property'="")
    {
	    s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProIdx",property,0))
	    //w MKBTPDRowId,!
		s MKBTPDDesc=""
		s:MKBTPDRowId'="" MKBTPDDesc=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)
		if (MKBTPDDesc'="")
		{
	        s argsLen=$Length(MKBTPDDesc,",")
	        for i=1:1:argsLen  
	        { 
	          s argstr=$p(MKBTPDDesc,",",i)
	          s MKBTPRowId=$p(argstr,"&",1)
	          s MKBTPShowType=$p(argstr,"&",2)  //展示格式
	          if (MKBTPShowType="C")
	          {
		          s MKBTPShowType="下拉框"
		      }
		      if (MKBTPShowType="T")
	          {
		          s MKBTPShowType="下拉树"
		      }
		      if (MKBTPShowType="TX")
	          {
		          s MKBTPShowType="文本框"
		      }
		      if (MKBTPShowType="TA")
	          {
		          s MKBTPShowType="多行文本框"
		      }
		      if (MKBTPShowType="CB")
	          {
		          s MKBTPShowType="单选框"
		      }
		      if (MKBTPShowType="CG")
	          {
		          s MKBTPShowType="复选框"
		      }
		      if (MKBTPShowType="G")
	          {
		          s MKBTPShowType="列表"
		      }
	          s MKBTPTreeNode=$p(argstr,"&",3)  //定义节点
	          s:MKBTPTreeNode'="" MKBTPTreeNode=##class(web.DHCBL.MKB.MKBTermProDetail).GetDesc(MKBTPTreeNode)
	          s MKBTPChoice=$p(argstr,"&",4)  //单选/复选 (S/D)
	          s:MKBTPChoice="" MKBTPChoice="S"   //默认是单选
	          s:MKBTPChoice="S" MKBTPChoice="单选"
	          s:MKBTPChoice="D" MKBTPChoice="复选"
	          s MKBTPRequired=$p(argstr,"&",5)  //是否必填（Y/N）
	          s:MKBTPRequired="" MKBTPRequired="N"  //默认不必填
	          s:MKBTPRequired="Y" MKBTPRequired="必填"
	          s:MKBTPRequired="N" MKBTPRequired="不必填"  
	          s MKBTPTOrP=$p(argstr,"&",6)  //术语T或属性P
	          s:MKBTPTOrP="" MKBTPTOrP="P"  //默认属性P
	          
	          s MKBTPOrder=i
	          s MKBTPDesc="",MKBTPType=""
	          if (MKBTPTOrP="T")   //术语
	          {
		          s MKBTPDesc=$LISTGET($G(^User.MKBTermBaseD(MKBTPRowId)),3) //术语库描述 
		          s MKBTPType=$LISTGET($G(^User.MKBTermBaseD(MKBTPRowId)),4)  //术语库格式
	          }
	          else   //属性
	          {
	          	  s MKBTPDesc=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),3) //属性描述 
	          	  s MKBTPType=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),4)  //属性格式
	          }
	          s:MKBTPTOrP="T" MKBTPTOrP="术语"
	          s:MKBTPTOrP="P" MKBTPTOrP="属性"
	          if (MKBTPType="M")
	          {
		          s MKBTPType="映射"
		      }
		      if (MKBTPType="C")
	          {
		          s MKBTPType="下拉框"
		      }
		      if (MKBTPType="T")
	          {
		          s MKBTPType="树型"
		      }
		      if (MKBTPType="TX")
	          {
		          s MKBTPType="文本"
		      }
		      if (MKBTPType="TA")
	          {
		          s MKBTPType="多行文本框"
		      }
		      if (MKBTPType="R")
	          {
		          s MKBTPType="单选框"
		      }
		      if (MKBTPType="CB")
	          {
		          s MKBTPType="复选框"
		      }
		      if (MKBTPType="L")
	          {
		          s MKBTPType="列表"
		      }
		      if (MKBTPType="F")
	          {
		          s MKBTPType="表单"
		      }
		      if (MKBTPType="S")
	          {
		          s MKBTPType="引用术语"
		      }
		      if (MKBTPType="P")
	          {
		          s MKBTPType="引用属性"
		      }
		      if (MKBTPType="SD")
	          {
		          s MKBTPType="引用属性内容"
		      }
		      if (MKBTPType="SS")
	          {
		          s MKBTPType="引用单节点"
		      }
		      //s result="属性id^属性^展示格式^属性格式^顺序^定义节点^单选多选(S/D)^是否必填(Y/N)^术语T或属性P"
	          if (result="")
				{
					s result=MKBTPRowId_"^"_MKBTPDesc_"^"_MKBTPShowType_"^"_MKBTPType_"^"_MKBTPOrder_"^"_MKBTPTreeNode_"^"_MKBTPChoice_"^"_MKBTPRequired_"^"_MKBTPTOrP
					//s Flag=1
				}
				else
				{
					s result=result_"&&"_MKBTPRowId_"^"_MKBTPDesc_"^"_MKBTPShowType_"^"_MKBTPType_"^"_MKBTPOrder_"^"_MKBTPTreeNode_"^"_MKBTPChoice_"^"_MKBTPRequired_"^"_MKBTPTOrP
				}
	        }
		}
    }
    q result
}

/// Creator:谷雪萍
/// CreatDate:2018-04-02
/// Description:判断诊断模板里的引用术语型属性是列表型还是树形
/// Input:property- 属性ID
/// return：L/T或""
/// Other:w ##class(web.DHCBL.MKB.MKBTermProDetail).GetProListOrTree()
Method GetProListOrTree(property As %String) As %String [ WebMethod ]
{
    q:property="" ""
    s MKBTBType=""
    s DATSOU=$LISTGET($G(^User.MKBTermPropertyD(property)),5)  //配置项
    s:DATSOU'="" MKBTBType=$LISTGET($G(^User.MKBTermBaseD(DATSOU)),4)  //术语类型
    q MKBTBType
}

/// Description:入参是科室id(必有)，诊断描述（可为空），出参是诊断ID、描述、拼音码、备注
/// Table:User.MKB_Reference User.MKB_Term 
/// Input:LocID-科室id，Desc-诊断描述（可为空）
/// Return: 出参是诊断ID、描述、拼音码、备注 DiseaseRowId^DiseaseDese^DiseasePY^DiseaseNote&&DiseaseRowId^DiseaseDese^DiseasePY^DiseaseNote……
/// d ##class(web.DHCBL.MKB.MKBWikiFrequency).GetMKBInfoByLocId(166634,"")
/// d ##class(web.DHCBL.MKB.MKBWikiFrequencyService).GetMKBInfoByLocId(17227,"")
ClassMethod GetMKBInfoByLocId(LocID As %String, Desc As %String) As %String [ WebMethod ]
{
	
	
	k ^MKBFTMP
 	s TableId=$o( ^User.MKBTermBaseI("FlagIndex"," "_$ZCONVERT("Diagnose","U"),0)) //获得知识库的id作为表名的后缀
	s MKBWFTableName="User.MKBTerm"_TableId                       //拼接表名
 	s MKBWFDataReference=0
 	s sum=0
 	s result=""
 	//w MKBWFTableName,!			
 	for
 	{
	 	s MKBWFDataReference=$o(^User.MKBWikiFrequencyI("TableReferenceIdx"," "_$ZCONVERT(MKBWFTableName,"U"),MKBWFDataReference))    //遍历对应知识库的术语
	 	q:MKBWFDataReference=""
	 	//s PropertyId=$o(^User.MKBTermPropertyI("DescIndex",MKBWFDataReference," 相关科室",0))
	 	//s ProDetailId=0
	 	s LocFlag=0    //判断是否是给定科室下的疾病
	 	w MKBWFDataReference_"AAA",!
	 	s LocChild = $O(^User.MKBKLMappingBaseFieldI("DescIndex",20," 科室",0))  //获得规则注册中科室的列号
 		if ($D(^User.MKBReferenceI("InverAllIndex","T",MKBWFDataReference,"MD"))'=0)
		{
			W "OKT",!
			s TRowId = 0
			for
			{
				s TRowId = $O(^User.MKBReferenceI("InverAllIndex","T",MKBWFDataReference,"MD",TRowId))   //通过引用表获得与疾病对照的科室的在映射表中的Rowid
				//w "诊断ID"_MDRowId,!	
				q:TRowId=""
				continue:($D(^User.MKBKLMappingDetailI("BaseIndex",20,TRowId))=0)	
				s RowNum = $LG($G(^User.MKBKLMappingDetailD(TRowId)),4)       //获得行号
				s FlagTRowId=$O(^User.MKBKLMappingDetailI("ValIndex",RowNum,20_"||"_LocChild,0))  //通过行号列号定位到数据在映射表中的ID（非科室表中ID）
				//w FlagMDRowId,!
				s Loc = $LG($G(^User.MKBKLMappingDetailD(FlagTRowId)),2)    //科室表中的ID
				if (LocID=Loc)
				{
					s LocFlag=1
					q
				}
			}
		}
	 	continue:LocFlag=0
	 	//w MKBWFDataReference,!
	 	s RowId=0
	 	s count=0
	 	for
	 	{
		 	s RowId=$o(^User.MKBWikiFrequencyI("TableReferenceIdx"," "_$ZCONVERT(MKBWFTableName,"U"),MKBWFDataReference,RowId))
		 	q:RowId=""
		 	s MKBFDate=$lg(^User.MKBWikiFrequencyD(RowId),5)
		 	s NowDate=$p($h,",",1)
		 	
			if ((NowDate-MKBFDate)<30)
			{
				s count=count+1
			}
	 	}
	 	if ($o(^MKBFTMP(count-1))'=count)
	 	{
		 	s ^MKBFTMP(count)=MKBWFDataReference
	 	}
	 	else
	 	{
		 	s ^MKBFTMP(count,sum)=MKBWFDataReference
		 	
	 	}
	 	s sum=sum+1
 	}
 	

	s MKBMFChild = $O(^User.MKBKLMappingBaseFieldI("DescIndex",20," 诊断",0))  //获得规则注册中的列号
	s:Desc'="" Desc=$ZCONVERT(Desc,"U")
	s HotCount=0
	//s Flag=0
	s result=""
	if (LocID'="")
	{
		if ($D(^User.MKBReferenceI("InverAllIndex","T",LocID,"MD"))'=0)
		{
			s MDRowId = 0
			for
			{
				s MDRowId = $O(^User.MKBReferenceI("InverAllIndex","T",LocID,"MD",MDRowId))   //通过引用表获得与科室对照的诊断表的在映射表中的Rowid
				//w "诊断ID"_MDRowId,!	
				q:MDRowId=""
				continue:($D(^User.MKBKLMappingDetailI("BaseIndex",20,MDRowId))=0)	
				s RowNum = $LG($G(^User.MKBKLMappingDetailD(MDRowId)),4)       //获得行号
				s FlagMDRowId=$O(^User.MKBKLMappingDetailI("ValIndex",RowNum,20_"||"_MKBMFChild,0))  //通过行号列号定位到数据在映射表中的ID（非疾病表中ID）
				//w FlagMDRowId,!
				s DiseaseRowId = $LG($G(^User.MKBKLMappingDetailD(FlagMDRowId)),2)    //疾病表中的ID
				s DiseaseDese = $lg($g(^User.MKBTermD(DiseaseRowId)),3)
				s DiseasePY = $lg($g(^User.MKBTermD(DiseaseRowId)),6)
				s DiseaseNote = $lg($g(^User.MKBTermD(DiseaseRowId)),7)
				s Frequency=$o(^MKBFTMP(""),-1)
				s Flag=""
				for i=1:1:3
 				{
	 	
	 				s TermId=^MKBFTMP(Frequency)
	 				//w TermId,!
	 				if (TermId=DiseaseRowId)
	 				{
		 				s Flag="hot"
	 				}
	 	
	 				if ($o(^MKBFTMP(Frequency,0))="")
	 				{
		 				s Frequency=$o(^MKBFTMP(Frequency),-1)
	 				}
	 				else
	 				{
		 				s Id=0
		 				for
		 				{
			 				if (i>=3)
	 						{
		 						q
	 						}
			 				s Id=$o(^MKBFTMP(Frequency,Id))
			 				q:Id=""
			 				s TermId=^MKBFTMP(Frequency,Id)
	 						if (TermId=DiseaseRowId)
	 						{
		 						s Flag="hot"
	 						}
	 						s i=i+1
	 			
		 				}
		 				s Frequency=$o(^MKBFTMP(Frequency),-1)
	 				}
 				}
 				
 				
 				s outDiaFlag=""  //输出标识
				s isDesc=1
				//s isDescKey=1
				if (Desc'="")  //如果诊断不为空
				{
					s:Desc'="" Desc=$ZCONVERT(Desc,"U")
					if (Desc[" ")
					{
					
						s KeywordsNum=$l(Desc," ")
						for i=1:1:KeywordsNum
						{
							s Keywords=$p(Desc," ",i)
							s isDesc=isDesc&($ZCONVERT(DiseaseDese,"U")[Keywords)  //描述
							if (isDesc=0)
							{
								q
							}
						}
					}
					else
					{
						s isDesc=($ZCONVERT(DiseaseDese,"U")[Desc)  //描述
					}
					///可以根据检索码，描述来查询  				 			
					s isDescKey=($ZCONVERT(DiseasePY,"U")[Desc) //检索码
					///根据别名查询
					s OtherNameProId=$o(^User.MKBTermPropertyI("DescIndex",DiseaseRowId," 别名",0))
					s OtherNameDetailId=$o(^User.MKBTermProDetailI("ProIdx",OtherNameProId,0))
					if (OtherNameDetailId)
					{
						s OtherName=$lg($g(^User.MKBTermProDetailD(OtherNameDetailId)),3)
					}
					else
					{
						s OtherName=""
					}
					s isOtherName=($ZCONVERT(OtherName,"U")[Desc) //别名
				
				
					i (isDescKey)||(isDesc)||(isOtherName)
					{
						s outDiaFlag="Y"
					}
				
				}
				else  //如果诊断为空
				{
					s outDiaFlag="Y"
				}
						
				if (outDiaFlag="Y")   //条件
				{
					if (result="")
					{
						s result=DiseaseRowId_"^"_DiseaseDese_"^"_DiseasePY_"^"_DiseaseNote_"^"_Flag
						//s Flag=1
					}
					else
					{
						s result=result_"&&"_DiseaseRowId_"^"_DiseaseDese_"^"_DiseasePY_"^"_DiseaseNote_"^"_Flag
					}
	        	}	
			}	
		}	
	}
	q result
}

/// Creator:谷雪萍
/// CreatDate:2018-04-13
/// Description：给医生站提供获取引用树形术语的接口 获取选中节点信息—— Json格式
/// Input:LastLevel ：上级节点id property:属性id
/// return:父节点及其所有子节点 Json格式
/// Other:w ##class(web.DHCBL.MKB.MKBEncyclopedia).GetDocSourseTreeJson("","5006")
/// Other:w ##class(web.DHCBL.MKB.MKBWikiFrequencyService).GetDocSourseTreeJson("","5006")
Method GetDocSourseTreeJson(LastLevel As %String, property As %String) As %String [ WebMethod ]
{
    s result=""
    q:(property="") "[]"
    s DATSOU=$LISTGET($G(^User.MKBTermPropertyD(property)),5)  //配置项
    q:(DATSOU="") "[]"
    
    s selItemIds= ##class(web.DHCBL.MKB.MKBTermProDetail).GetSelTermIdsStr(property)
    s selItemIds=","_selItemIds_","
    s definedNode=$LISTGET($G(^User.MKBTermPropertyD(property)),10)  //起始节点
    if (definedNode="")  //如果起始节点为空，显示所有术语数据
    {
        s result=result_..GetDocSourseJsonDataForCmb(DATSOU,definedNode,selItemIds)
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
        
            s result=result_"["
            s result=result_"{""id"":"""_definedNode_""",""text"":"""_definedNodeDesc_""""
            s result=result_",""state"":""open"""

            if $d(^User.MKBTermI("ParentIndex",DATSOU,definedNode))  //如果有子节点
            {
                s result=result_",""children"":"
                s result=result_##class(web.DHCBL.MKB.MKBEncyclopedia).GetDocSourseJsonDataForCmb(DATSOU,definedNode,selItemIds)
            }
            s result=result_"}"
            s result=result_"]"
        }
        else{
            q "[]"
        }
        
    }
    
    q result
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
    s result=""
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
    s result=result_"["
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
        s result=result_"{""id"":"""_myRowID_""",""text"":"""_Caption_""""
        s childStr=##class(web.DHCBL.MKB.MKBTermProDetail).GetDocChildOrderedIDStr(base,myRowID,selItemIds)
        if childStr'=""
        {
            s result=result_",""state"":""open"""
            s result=result_",""children"":"
            s result=result_..GetDocSourseJsonDataForCmb(base,myRowID,selItemIds) 
        }
        else
        {
            s result=result_",""state"":""open"""
        }
        s result=result_"}"
        
    }
    s result=result_"]"
    q result
}

/// Creator：谷雪萍
/// CreatDate: 2018-05-08
/// Description：引用术语类型-引用列表型术语内容维护模块-获取已选术语列表（新-多选术语存成多个属性内容）
/// Table：User.MKBTerm
/// Input：property-属性id,rowid-已选术语id
/// return: 术语id：术语代码：术语描述
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBTermProDetail","GetSellistTermList","6")
Method GetSellistTermList(property As %String, rowid As %String) As %String [ WebMethod ]
{
	s result=""
	if (property'="")
    {
	    s MKBTPDRowId=0
		for  
		{	
			s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProIdx",property,MKBTPDRowId)) q:MKBTPDRowId=""   //遍历该属性下的内容
			
			s MKBTPDSequence=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),9)  //顺序
			s MKBTRowId=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)  //属性内容表描述字段MKBTPDDesc存的值——术语id
			continue:MKBTRowId=""
			//封闭的数据不显示
			s MKBTActiveFlag=$listGet($g(^User.MKBTermD(MKBTRowId)),9)
			continue:MKBTActiveFlag="N"  //判断是否显示封闭数据
			s MKBTCode=$listGet($g(^User.MKBTermD(MKBTRowId)),2)  //代码
	        s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTRowId)),3)  //描述
	        //如果没有定位到具体的术语id则输出全部数据，如果定位到具体的术语则只输出一条
	        if (rowid="")||((rowid'="")&(rowid=MKBTRowId))
	        {
				if (result="")
				{
					s result=MKBTRowId_"^"_MKBTCode_"^"_MKBTDesc_"^"_MKBTPDRowId_"^"_MKBTPDSequence
		
				}
				else
				{
					s result=result_"&&"_MKBTRowId_"^"_MKBTCode_"^"_MKBTDesc_"^"_MKBTPDRowId_"^"_MKBTPDSequence
				}
	        }
		}

    }
    q result
}

}
