/// Creator:基础数据平台组-谷雪萍
/// CreatDate:2019-08-12
/// Description：给医学知识库数据导入提供接口
Class web.CDSS.CMKB.MKBDataImportInfo Extends %RegisteredObject
{

/// Creator:丁亚男
/// CreatDate:2021-04-16
/// Description:导出TXT格式中心词数据
/// Table:
/// Input：
/// Output:文件名 fileName
/// Others：w ##class(web.CDSS.CMKB.MKBDataImportInfo).ExportTermTXTData()
ClassMethod ExportTermTXTData(base As %String) As %String
{
	q:base="" ""
	s MKBTBDesc=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(base)),3)  //表名
	s MKBTBType=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(base)),4)  //树形/列表型
	
	s sum=0
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=MKBTBDesc_"百科数据.txt"
	s file=""			 	;key转放到web目录下
	if (Path["\"){
		s DirName = Path_"scripts\bdp\CDSS\DataExport\"
		s file = Path_"scripts\bdp\CDSS\DataExport\"_fileName
	}else{
		s DirName = Path_"scripts/bdp/CDSS/DataExport/"
		s file = Path_"scripts/bdp/CDSS/DataExport/"_fileName
	}
	
	o file:"NWS"
	u file
	//d file.Open("NWS")
	w "术语中心词	知识量	责任人	审核人	最后操作时间	状态"
	
	s MKBTDetailCount=""
	for  
	{	
		s MKBTDetailCount=$o(^CT.WDT.CDSS.TermI("DCountIndex",base,MKBTDetailCount),-1) q:MKBTDetailCount=""
		s MKBTRowId=0
		for  
		{	
			s MKBTRowId=$o(^CT.WDT.CDSS.TermI("DCountIndex",base,MKBTDetailCount,MKBTRowId)) q:MKBTRowId="" 
			s MKBTDesc=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),3)  //描述
			
			s UpdateDate=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),11)
			s ResponUser=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),12)
			s ReviewUser=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),13)
			s Status=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),14)
			s Status=$CASE(Status,"0":"编辑中","1":"已弃用","2":"已审核","3":"待审核",:"编辑中")
				
	 		//替换双引号
			s MKBTDesc=$replace(MKBTDesc,"""","”")
			
			w !,MKBTDesc_"	"_MKBTDetailCount_"	"_ResponUser_"	"_ReviewUser_"	"_UpdateDate_"	"_Status
			//d file.WriteLine(str)
			s sum = sum+1
		}
	}
	c file
	
	
	q fileName
}

/// Creator:谷雪萍
/// CreatDate:2019-08-12
/// Description：用于获取术语导入模版的表名、列ID及列名
/// Input：base-知识库注册id,onlyDescFlag-只导中心词的表示
/// Return：表名[N]字段拼串[N]列名拼串
/// Other:w ##class(web.CDSS.CMKB.MKBDataImportInfo).GetTermTableColumn("73")
ClassMethod GetTermTableColumn(base As %String, onlyDescFlag As %String = "") As %String
{
	q:base="" ""
	s MKBTBDesc=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(base)),3)  //表名
	s MKBTBType=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(base)),4)  //树形/列表型
	s codeStr=""   //知识库注册属性id列
	s descStr=""   //知识库注册属性描述列
	if (onlyDescFlag'="1")  //如果不是只导中心词，则导出公有属性
	{
		//遍历知识库注册属性表
		s MKBTBPRowId=0
		for  
		{
			s MKBTBPRowId=$o(^CT.WDT.CDSS.TermBasePropertyI("TermBaseIdx",base,MKBTBPRowId)) q:MKBTBPRowId="" 

			s MKBTBPDesc=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(MKBTBPRowId)),3)  //属性名
			continue:MKBTBPDesc=""
			s MKBTBPType=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(MKBTBPRowId)),4)  //类型
			s MKBTBPName=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(MKBTBPRowId)),7)  //主列名
			s:MKBTBPName="" MKBTBPName=MKBTBPDesc
			continue:(MKBTBPType="T")||(MKBTBPType="S")||(MKBTBPType="P")||(MKBTBPType="SD")||(MKBTBPType="M") //过滤掉树形、引用、知识模板、表达式、映射类型
			if (codeStr'="") 
			{
				s codeStr=codeStr_"[A]"
				s descStr=descStr_"[A]"
				
			}	
			s codeStr=codeStr_MKBTBPRowId
			s descStr=descStr_MKBTBPDesc
			
			s ChildNameStr=""
			if (MKBTBPType="L") //如果属性为列表型
			{
				s MKBTBEPChildsub=0
				for 
				{
					S MKBTBEPChildsub=$o(^CT.WDT.CDSS.TermBasePropertyD(MKBTBPRowId,"ChildExt",MKBTBEPChildsub)) 
					q:MKBTBEPChildsub=""
					s MKBTBEPName=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(MKBTBPRowId,"ChildExt",MKBTBEPChildsub)),2)
					continue:MKBTBEPName=""
					s:ChildNameStr'="" ChildNameStr=ChildNameStr_"[and]"
					s ChildNameStr=ChildNameStr_MKBTBEPName
				}
				if (ChildNameStr'="") //如果有扩展属性，则标题为属性名（主列名[and]扩展属性名，多条数据用[next]连接）
				{
					s descStr=descStr_"（"_MKBTBPName_"[and]"_ChildNameStr_"，多条数据用[next]连接）"  
				}
				else  //如果没有扩展属性，则标题为属性名（多条数据用[next]连接）
				{	
					s descStr=descStr_"（多条数据用[next]连接）"  
				}	
			}
							
		}
	}
	
	s termCodeStr="", termDescStr=""
	if (MKBTBType="L") //列表型术语
	{
		s termCodeStr="MKBTCode[A]MKBTDesc[A]MKBTPYCode[A]MKBTNote[A]MKBTDetailCount"
		s termDescStr="代码[A]中心词[A]检索码[A]备注[A]知识量"
	}
	else  //树形术语有上级分类
	{
		s termCodeStr="MKBTCode[A]MKBTDesc[A]MKBTPYCode[A]MKBTLastLevel[A]MKBTNote[A]MKBTDetailCount"
		s termDescStr="代码[A]中心词[A]检索码[A]上级节点[A]备注[A]知识量"
	}
	s:codeStr'="" termCodeStr=termCodeStr_"[A]"_codeStr
	s:descStr'="" termDescStr=termDescStr_"[A]"_descStr
	q MKBTBDesc_"[N]"_termCodeStr_"[N]"_termDescStr
}

/// Creator:谷雪萍
/// CreatDate:2019-08-15
/// Description：用于校验模版
/// Input：base-知识库注册id,tableName-表名,columStr-属性列串
/// Return："{success:'true',info:'校验成功！'}"/"{success:'false',errorinfo:'错误信息'}"  
/// Other:w ##class(web.CDSS.CMKB.MKBDataImportInfo).ValidateTermTable("73","国家临床2.0-疾病分类与代码","MKBTCode[A]MKBTDesc[A]MKBTPYCode[A]MKBTNote[A]255[A]256")
ClassMethod ValidateTermTable(base As %String, tableName As %String, columStr As %String) As %String
{
	s result=""
	q:base="" "{success:'false',errorinfo:'知识库注册ID不能为空！'}"    //知识库注册ID不能为空
	q:columStr="" "{success:'false',errorinfo:'传入列不能为空！'}"    	 //传入列不能为空
	s MKBTBDesc=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(base)),3)  //表名
	q:(MKBTBDesc'=tableName) "{success:'false',errorinfo:'传入的表名和该界面标题不对应，请确认！'}"   //导入的不是该界面的数据
	
	s wrongColumn=""  //错误列
	s termDescFlag=0  //是否有中心词列
	s columLen=$Length(columStr,"[A]")
    for i=1:1:columLen  
    { 
		s code=$p(columStr,"[A]",i)
		if (code="MKBTCode")||(code="MKBTPYCode")||(code="MKBTLastLevel")||(code="MKBTNote")||(code="MKBTDetailCount")
      	{
			continue
      	}
		elseif (code="MKBTDesc")
      	{
			s termDescFlag=1   
      	}

      	else  //其他存成属性内容
      	{
	      	
	      	s MKBTBPDesc=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(code)),3)   //属性描述
	      	s MKBTBPBaseDr=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(code)),5)  //指向术语库注册的指针
	      	if (MKBTBPDesc="")||(MKBTBPBaseDr'=base)
	      	{
		      	if (wrongColumn'="")
		      	{
		      		s wrongColumn=wrongColumn_"，"
		      	}
		      	s wrongColumn=wrongColumn_i
	      	}
	      	
      	}
	  
    }
    if (termDescFlag=0)
    {
	    q "{success:'false',errorinfo:'缺少中心词列！'}"
    }
    if (wrongColumn'="")
    {
	    s result="{success:'false',errorinfo:'第"_wrongColumn_"列不属于"_tableName_"！'}"
    }
    else
    {
	    s result="{success:'true',info:'校验成功！'}"
    }
    q result
}

/// Creator:谷雪萍
/// CreatDate:2019-08-13
/// Description：用于保存导入模版中的某一行术语数据
/// Input：base-知识库注册id,columStr-属性列串,valueStr-值串
/// Return："{success:'true',id:'术语ID或最后一个属性内容ID'}" /"{success:'false',errorinfo:'错误信息'}"
/// Other:w ##class(web.CDSS.CMKB.MKBDataImportInfo).SaveTermTableData("73","MKBTCode[A]MKBTDesc[A]MKBTPYCode[A]MKBTNote[A]255[A]256","[A]测试数据[A][A]bz[A]01[A]02")
ClassMethod SaveTermTableData(base As %String, columStr As %String, valueStr As %String) As %String
{
	s result=""
	q:base="" "{success:'false',errorinfo:'知识库注册ID不能为空！'}"   //返回错误信息
	q:columStr="" "{success:'false',errorinfo:'传入列不能为空！'}"   //返回错误信息
	q:valueStr="" "{success:'false',errorinfo:'传入值不能为空！'}"   //返回错误信息
		
	s proDescStr=""   //属性描述串
	s proValueStr=""   //属性内容串
	s baseProIdStr=""  //知识库注册属性id串
	s eobj = ##class(web.CDSSEntity.CMKB.Term).%New()
	s eobj.MKBTBaseDR=base
    s columLen=$Length(columStr,"[A]")
    for i=1:1:columLen  
    { 
		s code=$p(columStr,"[A]",i)
		s value=$p(valueStr,"[A]",i)
		continue:code=""
		if (code="MKBTCode")
      	{
			s eobj.MKBTCode=value
      	}
		elseif (code="MKBTDesc")
      	{
			s eobj.MKBTDesc=value
      	}
      	elseif (code="MKBTPYCode")
      	{
			s eobj.MKBTPYCode=value
      	}
      	elseif(code="MKBTLastLevel")
      	{
	      	if (value'="")
	      	{
		      	s value=$p(value,"-",$l(value,"-")) //父子级那种的只取子集
		      	s value=" "_$ZCONVERT(value,"U")
	      		s value=$o(^CT.WDT.CDSS.TermI("DescIndex",base,value,0))
	      	}
	      	s eobj.MKBTLastLevel=value
      	}
      	elseif(code="MKBTNote")
      	{				
			s eobj.MKBTNote=value
      	}
      	elseif(code="MKBTDetailCount") //知识量
      	{

      	}
      	else  //其他存成属性内容
      	{
	      	s MKBTBPDesc=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(code)),3)   //属性描述
	      	s MKBTBPType=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(code)),4)  //属性类型
	      	s MKBTBPConfig=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(code)),6)  //属性配置项
	      	if (MKBTBPType="SS")&(value'="")&(MKBTBPConfig'="")  //引用起始节点类型
			{								
				s value=$p(value,"-",$l(value,"-")) //父子级那种的只取子集
				s value=" "_$ZCONVERT(value,"U")
				s value=$o(^CT.WDT.CDSS.TermI("DescIndex",MKBTBPConfig,value,0))
			}  
		    if (proDescStr'="")
	      	{
		      	s proDescStr=proDescStr_"[A]"_MKBTBPDesc
		      	s proValueStr=proValueStr_"[A]"_value
		      	s baseProIdStr=baseProIdStr_"[A]"_code
	      	}
	      	else
	      	{
		      	s proDescStr=MKBTBPDesc
		      	s proValueStr=value
		      	s baseProIdStr=code
	      	}
      	}
	  
    }
    //如果术语中心词不为空，则判断术语id是否存在
    if (eobj.MKBTDesc'="")
    {	
    	s eobj.MKBTRowId=$o(^CT.WDT.CDSS.TermI("DescIndex",base," "_$ZCONVERT(eobj.MKBTDesc,"U"),0))
    	s:eobj.MKBTRowId'="" eobj.MKBTCode=$listGet($g(^CT.WDT.CDSS.TermD(eobj.MKBTRowId)),2)  //代码
    }
    Ts
    s flag=0   //错误标识
    //先保存术语
    s result=##class(web.CDSS.CMKB.Term).SaveData(eobj)
    if (result["true")
    {
	    //获取术语id
		s termId=$p(result,"'",4)
		if (termId="")  //如果刚保存的术语id没有获取到
		{
			 s result="{success:'false',errorinfo:'没有获取到术语ID！'}"   //返回错误信息
			 s flag=1
		}
		else
		{
			if (proDescStr'="")&(proValueStr'="")  //保存属性内容
			{
				s proDescLen=$Length(proDescStr,"[A]")
			    for iPro=1:1:proDescLen  
			    { 
					s proDesc=$p(proDescStr,"[A]",iPro)
					s proValue=$p(proValueStr,"[A]",iPro)
					continue:(proDesc="")||(proValue="")
					s upProDesc=" "_$ZCONVERT(proDesc,"U")
					s proDr=$o(^CT.WDT.CDSS.TermPropertyI("DescIndex",termId,upProDesc,0))  //获取该术语的属性ID
					if (proDr="")  
					{
						s flag=1
						s result="{success:'false',errorinfo:'没有获取到"_proDesc_"属性！'}"
						q
					}
					else
					{
						s MKBTPType=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(proDr)),4)  //属性类型
						if (MKBTPType="L")  //列表型属性 比如 检验标本及采集要求（检验标本[and]采集要求，多行数据用[next]连接），需要保存多条属性内容数据，且需要保存扩展属性内容
						{
							s MKBTPDDesc=$p(proValue,"[and]",1)  //[and]连接的第一个数据为属性内容中心词的数据
							s TermChildStr=""  //术语扩展属性的child串
							s baseProId=$p(baseProIdStr,"[A]",iPro)  //知识库注册属性id
							s MKBTBEPChildsub=0  //遍历知识库扩展属性表
							for 
							{
								S MKBTBEPChildsub=$o(^CT.WDT.CDSS.TermBasePropertyD(baseProId,"ChildExt",MKBTBEPChildsub)) 
								q:MKBTBEPChildsub=""
								s MKBTBEPName=$LISTGET($G(^CT.WDT.CDSS.TermBasePropertyD(baseProId,"ChildExt",MKBTBEPChildsub)),2)  //找到扩展属性名
								continue:MKBTBEPName=""
								s TermChildsub=$o(^CT.WDT.CDSS.TermExtendProI("NameIndex",proDr," "_$ZCONVERT(MKBTBEPName,"U"),0))  //找到术语的扩展属性的child
								s:TermChildStr'="" TermChildStr=TermChildStr_"[and]"  //用[and]把术语扩展属性的child拼成串
								s TermChildStr=TermChildStr_TermChildsub
							}
							s detailLen=$Length(proValue,"[next]")  //多个属性内容用[next]连接，属性内容1[and]属性内容1的扩展属性1内容[and]属性内容1的扩展属性2内容[next]属性内容2[and]属性内容2的扩展属性1内容[and]属性内容2的扩展属性2内容
							for iDetail=1:1:detailLen  
							{
								s detailStr=$p(proValue,"[next]",iDetail)    //属性内容1[and]属性内容1的扩展属性1内容[and]属性内容1的扩展属性2内容
								s MKBTPDDesc=$p(detailStr,"[and]",1)  //属性内容1
								s MKBTPDExtend=""
								s extendValueLen=$Length(detailStr,"[and]")
								if (extendValueLen>1)
								{
									for iExtend=2:1:extendValueLen 
									{
										s extendValue=$p(detailStr,"[and]",extendValueLen)  //属性内容1的扩展属性1内容
										s extendChild=$p(TermChildStr,"[and]",extendValueLen-1)
										continue:(extendValue="")||(extendChild="")
										s:MKBTPDExtend'="" MKBTPDExtend=MKBTPDExtend_"[N]"
										s MKBTPDExtend=MKBTPDExtend_extendChild_"[A]"_extendValue
									}
								}
								//保存属性内容和扩展属性内容
								s eobj = ##class(web.CDSSEntity.CMKB.TermProDetail).%New()
								s eobj.MKBTPDDesc=MKBTPDDesc
								s eobj.MKBTPDProDR=proDr
								s eobj.MKBTPDExtend=MKBTPDExtend
								s result=##class(web.CDSS.CMKB.TermProDetail).SaveData(eobj)
								if (result["false")
							    {
								    s flag=1
								    q
							    }
								
							}	
						}
						else   //其他类型的属性，只保存一条属性内容数据。没有扩展属性，也不需要保存扩展属性内容
						{
							if ($d(^CT.WDT.CDSS.TermProDetailI("ProIdx",proDr))>0)
							{
								s result="{success:'false',errorinfo:'"_proDesc_"属性已经存在内容，请勿重复导入！'}"   //返回错误信息
								s flag=1
								q
							}
							else
							{
								s eobj = ##class(web.CDSSEntity.CMKB.TermProDetail).%New()
								s eobj.MKBTPDDesc=proValue
								s eobj.MKBTPDProDR=proDr
								s result=##class(web.CDSS.CMKB.TermProDetail).SaveData(eobj)
								if (result["false")
							    {
								    s flag=1
								    q
							    }
							}
						}
					}
			    }
			}
		}
    }
    
	if (flag=1)
	{
		Trollback
	}
	else
	{
		TC
	}
	
	q result
}

/// Creator:谷雪萍
/// CreatDate:2019-08-30
/// Description：用于获取导出知识库术语的总数
/// Input：base-知识库注册id
/// Return：count-一共有多少数据
/// Other:w ##class(web.CDSS.CMKB.MKBDataImportInfo).GetTermDataCount(5)
ClassMethod GetTermDataCount(base As %String) As %String
{
	q:base="" ""
	k ^TMPMKBDATAIMPORT("T",base)
	s count=0
	s MKBTRowId=""
	for  
	{	
		s MKBTRowId=$o(^CT.WDT.CDSS.TermI("BaseIndex",base,MKBTRowId)) q:MKBTRowId=""
		s MKBTCode=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),2)  //代码
		continue:MKBTCode=""
		s count=count+1
		s ^TMPMKBDATAIMPORT("T",base,count)=MKBTRowId
	}
	q count
}

/// Creator:谷雪萍
/// CreatDate:2019-09-23
/// Description：用于获取知识库术语某一行的数据
/// Input：base-知识库注册id ,i-第几行
/// Return：ColumValueStr-[A]连接的某一行的值
/// Other:w ##class(web.CDSS.CMKB.MKBDataImportInfo).GetTermDataInfo(5,1)
ClassMethod GetTermDataInfo(base As %String, i As %String, onlyDescFlag As %String = "") As %String
{
	q:(base="")||(i="") ""
	S MKBTRowId=$g(^TMPMKBDATAIMPORT("T",base,i))   //术语id
	q:MKBTRowId="" ""
	
	s ColumInfoStr=..GetTermTableColumn(base,onlyDescFlag)    //列信息串
	s ColumDescStr=$p(ColumInfoStr,"[N]",3)      //列描述串
	s ColumDescLen=$Length(ColumDescStr,"[A]")
	s ColumValueStr=""    //列值串
    for j=1:1:ColumDescLen  
    { 
    	s ColumValue=""
    	s ColumDesc=$p(ColumDescStr,"[A]",j)  //列描述
    	if (ColumDesc="代码")
    	{
	    	s ColumValue=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),2)  //代码
    	}
    	elseif (ColumDesc="中心词")
    	{
	    	s ColumValue=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),3)  //中心词
    	}
    	elseif (ColumDesc="检索码")
    	{
	    	s ColumValue=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),6)  //检索码
    	}
    	elseif (ColumDesc="上级节点")
    	{
	    	s ColumValue=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),5)  //上级节点
	    	//s:ColumValue'="" ColumValue=$listGet($g(^CT.WDT.CDSS.TermD(ColumValue)),3)  //上级节点描述
	    	s:ColumValue'="" ColumValue=##class(web.CDSS.CMKB.Term).GetTreeComboDesc(ColumValue) 
    	}
    	elseif (ColumDesc="备注")
    	{
	    	s ColumValue=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),7)  //备注
    	}
    	elseif (ColumDesc="知识量")
    	{
	    	s ColumValue=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),10)  //知识量
    	}
    	else
    	{
	    	if (ColumDesc["（")
	    	{
		    	s ColumDesc=$p(ColumDesc,"（",1)  //列表型属性，如果有扩展属性则会把展示名和扩展属性名拼起来
	    	}
			s UpColumDesc=" "_$ZCONVERT(ColumDesc,"U")
			s ProDr=$o(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId,UpColumDesc,0))  //获取该术语的属性ID
			if (ProDr'="")  
			{
				s ProType=$LISTGET($G(^CT.WDT.CDSS.TermPropertyD(ProDr)),4)   //属性格式
				
				//遍历属性内容
				s ProDetailId=0
				for  
				{	
					s ProDetailId=$o(^CT.WDT.CDSS.TermProDetailI("ProIdx",ProDr,ProDetailId))
					q:ProDetailId=""

					s DetailValues=$LISTGET($G(^CT.WDT.CDSS.TermProDetailD(ProDetailId)),3)   //属性内容

					s ChildValueStr="" 
					s subId=0  //循环扩展属性子表
					for 
					{
						S subId=$o(^CT.WDT.CDSS.TermPropertyD(ProDr,"ChildExtPro",subId)) 
						q:subId=""
						s MKBTEPVValueStr=##class(web.CDSS.CMKB.TermProDetail).GetExtendProValValue(ProDr,subId,ProDetailId)
						s MKBTEPVValue=$p(MKBTEPVValueStr,"[A]",1)
						s:ChildValueStr'="" ChildValueStr=ChildValueStr_"[and]"
						s ChildValueStr=ChildValueStr_MKBTEPVValue
					}
					s:ChildValueStr'="" DetailValues=DetailValues_"[and]"_ChildValueStr
					s:ColumValue'="" ColumValue=ColumValue_"[next]"
					s ColumValue=ColumValue_DetailValues
				}
				
			
			}

    	}
    	if (j=1)
    	{
	    	s ColumValueStr=ColumValue
    	}
    	else
    	{
    		s ColumValueStr=ColumValueStr_"[A]"_ColumValue
    	}
    	
    	
    }	
	q ColumValueStr
}

}
