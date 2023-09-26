/// Creator:基础数据平台组-谷雪萍
/// CreatDate:2019-08-12
/// Description：给医学知识库数据导入提供接口
Class web.DHCBL.MKB.MKBDataImportInfo Extends %RegisteredObject
{

/// Creator:丁亚男
/// CreatDate:2021-04-16
/// Description:导出TXT格式中心词数据 改成导出csv格式 linux系统下导出txt显示乱码
/// Table:
/// Input：
/// Output:文件名 fileName
/// Others：w ##class(web.DHCBL.MKB.MKBDataImportInfo).ExportTermTXTData(5)
ClassMethod ExportTermTXTData(base As %String) As %String
{
	q:base="" ""
	s MKBTBDesc=$LISTGET($G(^User.MKBTermBaseD(base)),3)  //表名
	s MKBTBType=$LISTGET($G(^User.MKBTermBaseD(base)),4)  //树形/列表型
	
	s sum=0
	//s Path=##class(%File).GetDirectory()
	//s Disk=$p(Path,":",1) //截取盘符
	s fileName=MKBTBDesc_"数据.csv"
	Set componentxml = "\scripts\bdp\MKB\" 
	;Set componentxml = "D:\" 
	s dirname = ##class(ext.util.String).GetPhysicalPath("",componentxml)
	s filePath= dirname_fileName  
	//o file:"NWS"
	//u file
	//w "术语中心词	知识量	状态	责任人"
	
	//s file=Disk_":\DtHealth\app\dthis\web\scripts\bdp\MKB\"_fileName
	s file=##class(%File).%New(filePath)
	d file.Open("NWS")
	d file.WriteLine("中心词,知识量,状态,责任人")
	
	s MKBTDetailCount=""
	for  
	{	
		s MKBTDetailCount=$o(^User.MKBTermI("DCountIndex",base,MKBTDetailCount),-1) q:MKBTDetailCount=""
		s MKBTRowId=0
		for  
		{	
			s MKBTRowId=$o(^User.MKBTermI("DCountIndex",base,MKBTDetailCount,MKBTRowId)) q:MKBTRowId="" 
			
			s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTRowId)),3)  //描述
			s State=""
			if $d(^User.MKBTermPropertyI("DescIndex",MKBTRowId," 状态"))
			{
				s MKBTPRowId=$o(^User.MKBTermPropertyI("DescIndex",MKBTRowId," 状态",0))
				s MKBTPType=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),4)
				s State=##class(web.DHCBL.MKB.MKBTermProperty).GetALLDetail(MKBTPType,MKBTPRowId)
			}
			
			s Response=""
			if $d(^User.MKBTermPropertyI("DescIndex",MKBTRowId," 责任人"))
			{
				s MKBTPRowId=$o(^User.MKBTermPropertyI("DescIndex",MKBTRowId," 责任人",0))
				s MKBTPType=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),4)
				s Response=##class(web.DHCBL.MKB.MKBTermProperty).GetALLDetail(MKBTPType,MKBTPRowId)
			}	
		
	 		//替换双引号
			s MKBTDesc=$replace(MKBTDesc,"""","”")
			s State=$replace(State,"""","”")
			s Response=$replace(Response,"""","”")
			
			//w !,MKBTDesc_"	"_MKBTDetailCount_"	"_State_"	"_Response
			d file.WriteLine(MKBTDesc_","_MKBTDetailCount_","_State_","_Response)
			s sum = sum+1
		}
	}
	//c file
	d file.%Save()
	d file.%Close()
	k file
	
	q fileName
}

/// Creator:谷雪萍
/// CreatDate:2019-08-12
/// Description：用于获取术语导入模版的表名、列ID及列名
/// Input：base-知识库注册id,onlyDescFlag-只导中心词的表示
/// Return：表名[N]字段拼串[N]列名拼串
/// Other:w ##class(web.DHCBL.MKB.MKBDataImportInfo).GetTermTableColumn("73")
ClassMethod GetTermTableColumn(base As %String, onlyDescFlag As %String = "") As %String
{
	q:base="" ""
	s MKBTBDesc=$LISTGET($G(^User.MKBTermBaseD(base)),3)  //表名
	s MKBTBType=$LISTGET($G(^User.MKBTermBaseD(base)),4)  //树形/列表型
	s codeStr=""   //id列
	s descStr=""   //描述列
	if (onlyDescFlag'="1")  //如果不是只导中心词，则导出公有属性
	{
		//遍历知识库注册属性表
		s MKBTBPRowId=0
		for  
		{
			s MKBTBPRowId=$o(^User.MKBTermBasePropertyI("TermBaseIdx",base,MKBTBPRowId)) q:MKBTBPRowId="" 

			s MKBTBPDesc=$LISTGET($G(^User.MKBTermBasePropertyD(MKBTBPRowId)),3)  //属性名
			s MKBTBPType=$LISTGET($G(^User.MKBTermBasePropertyD(MKBTBPRowId)),4)  //类型
			continue:(MKBTBPType="L")||(MKBTBPType="T")||(MKBTBPType="S")||(MKBTBPType="P")||(MKBTBPType="SD")||(MKBTBPType="M") //过滤掉列表、树形、引用、知识模板、表达式、映射类型
			if (codeStr'="") 
			{
				s codeStr=codeStr_"[A]"_MKBTBPRowId
				s descStr=descStr_"[A]"_MKBTBPDesc
			}
			else
			{				
				s codeStr=MKBTBPRowId
				s descStr=MKBTBPDesc
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
/// Other:w ##class(web.DHCBL.MKB.MKBDataImportInfo).ValidateTermTable("73","国家临床2.0-疾病分类与代码","MKBTCode[A]MKBTDesc[A]MKBTPYCode[A]MKBTNote[A]255[A]256")
ClassMethod ValidateTermTable(base As %String, tableName As %String, columStr As %String) As %String
{
	s result=""
	q:base="" "{success:'false',errorinfo:'知识库注册ID不能为空！'}"    //知识库注册ID不能为空
	q:columStr="" "{success:'false',errorinfo:'传入列不能为空！'}"    	 //传入列不能为空
	s MKBTBDesc=$LISTGET($G(^User.MKBTermBaseD(base)),3)  //表名
	q:(MKBTBDesc'=tableName) "{success:'false',errorinfo:'传入的表名和该界面标题不对应，请确认！'}"   //导入的不是该界面的数据
	
	s wrongColumn=""  //错误列
	s termDescFlag=0  //是否有中心词列
	//如果是流，先解析
	if ($isobject(columStr))
	{
		s Stream=columStr
		s len=Stream.SizeGet()
        d Stream.Rewind()
        s columStr=Stream.Read(len)
	}
	
		
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
	      	
	      	s MKBTBPDesc=$LISTGET($G(^User.MKBTermBasePropertyD(code)),3)   //属性描述
	      	s MKBTBPBaseDr=$LISTGET($G(^User.MKBTermBasePropertyD(code)),5)  //指向术语库注册的指针
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
/// Other:w ##class(web.DHCBL.MKB.MKBDataImportInfo).SaveTermTableData("73","MKBTCode[A]MKBTDesc[A]MKBTPYCode[A]MKBTNote[A]255[A]256","[A]测试数据[A][A]bz[A]01[A]02")
ClassMethod SaveTermTableData(base As %String, columStr As %String, valueStr As %String) As %String
{
	s result=""
	q:base="" "{success:'false',errorinfo:'知识库注册ID不能为空！'}"   //返回错误信息
	q:columStr="" "{success:'false',errorinfo:'传入列不能为空！'}"   //返回错误信息
	q:valueStr="" "{success:'false',errorinfo:'传入值不能为空！'}"   //返回错误信息
		
	s proDescStr=""   //属性描述串
	s proValueStr=""   //属性内容串
	s eobj = ##class(web.Entity.MKB.MKBTerm).%New()
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
	      		s value=$o(^User.MKBTermI("DescIndex",base,value,0))
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
	      	s MKBTBPDesc=$LISTGET($G(^User.MKBTermBasePropertyD(code)),3)   //属性描述
	      	s MKBTBPType=$LISTGET($G(^User.MKBTermBasePropertyD(code)),4)  //属性类型
	      	s MKBTBPConfig=$LISTGET($G(^User.MKBTermBasePropertyD(code)),6)  //属性配置项
	      	if (MKBTBPType="SS")&(value'="")&(MKBTBPConfig'="")  //引用起始节点类型
			{								
				s value=$p(value,"-",$l(value,"-")) //父子级那种的只取子集
				s value=" "_$ZCONVERT(value,"U")
				s value=$o(^User.MKBTermI("DescIndex",MKBTBPConfig,value,0))
			}  
		    if (proDescStr'="")
	      	{
		      	s proDescStr=proDescStr_"[A]"_MKBTBPDesc
		      	s proValueStr=proValueStr_"[A]"_value
	      	}
	      	else
	      	{
		      	s proDescStr=MKBTBPDesc
		      	s proValueStr=value
	      	}
      	}
	  
    }
    
    Ts
    //先保存术语
    s result=##class(web.DHCBL.MKB.MKBTerm).SaveData(eobj)
    if (result["true")
    {
	    //获取术语id
		s termId=$p(result,"'",4)
		if (termId="")  //如果刚保存的术语id没有获取到
		{
			 s result="{success:'false',errorinfo:'没有获取到术语ID！'}"   //返回错误信息
		}
		else
		{
			s flag=0   //错误标识
			if (proDescStr'="")&(proValueStr'="")  //保存属性内容
			{
				s proDescLen=$Length(proDescStr,"[A]")
			    for i=1:1:proDescLen  
			    { 
			    	q:flag=1
					s proDesc=$p(proDescStr,"[A]",i)
					s proValue=$p(proValueStr,"[A]",i)
					continue:(proDesc="")||(proValue="")
					s upProDesc=" "_$ZCONVERT(proDesc,"U")
					s proDr=$o(^User.MKBTermPropertyI("DescIndex",termId,upProDesc,0))  //获取该术语的属性ID
					if (proDr="")  
					{
						s flag=1
						s result="{success:'false',errorinfo:'没有获取到"_proDesc_"属性！'}"
					}
					else
					{
						s eobj = ##class(web.Entity.MKB.MKBTermProDetail).%New()
						s eobj.MKBTPDDesc=proValue
						s eobj.MKBTPDProDR=proDr
						s result=##class(web.DHCBL.MKB.MKBTermProDetail).SaveData(eobj)
						if (result["false")
					    {
						    s flag=1
					    }
					}
			    }
			}
		}
    }
    
	if (result["false")
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
/// CreatDate:2019-08-12
/// Description：用于获取规则管理的表名、列ID及列名
/// Input：base-规则注册id
/// Return：表名[N]字段拼串[N]列名拼串
/// Other:w ##class(web.DHCBL.MKB.MKBDataImportInfo).GetMappingTableColumn("36")
ClassMethod GetMappingTableColumn(base As %String) As %String
{
	q:base="" ""
	s MKBKMBDesc=$LISTGET($G(^User.MKBKLMappingBaseD(base)),3)  //表名

	s codeStr=""   //id列
	s descStr=""   //描述列
	
	//遍历规则注册子表
	s MKBKMBFSequence = 0
	for
	{
		s MKBKMBFSequence = $O(^User.MKBKLMappingBaseFieldI("SeqIndex",base,MKBKMBFSequence))
		q:MKBKMBFSequence=""
		s MKBKMBFChildSub=0
		for
		{
			s MKBKMBFChildSub = $O(^User.MKBKLMappingBaseFieldI("SeqIndex",base,MKBKMBFSequence,MKBKMBFChildSub))
			q:MKBKMBFChildSub=""
			s MKBKMBFRowId = base_"||"_MKBKMBFChildSub
			s MKBKMBFDesc = $LG($G(^User.MKBKLMappingBaseD(base,"ChildField",MKBKMBFChildSub)),3)
			s MKBKMBFType = $LG($G(^User.MKBKLMappingBaseD(base,"ChildField",MKBKMBFChildSub)),4)
			s MKBKMBFConfig = $LG($G(^User.MKBKLMappingBaseD(base,"ChildField",MKBKMBFChildSub)),5)  //配置项
			if (MKBKMBFType="K1")||(MKBKMBFType="K2")  //知识点1或者知识点2格式
			{
				/*if (MKBKMBFConfig'="Desc")   //只能导入列源为中心词的
				{
					continue
				} */

			}
			if (codeStr'="") 
			{
				s codeStr=codeStr_"[A]"_MKBKMBFRowId
				s descStr=descStr_"[A]"_MKBKMBFDesc
			}
			else
			{				
				s codeStr=MKBKMBFRowId
				s descStr=MKBKMBFDesc
			}

		}
	}	
	q MKBKMBDesc_"[N]"_codeStr_"[N]"_descStr
}

/// Creator:谷雪萍
/// CreatDate:2019-08-15
/// Description：用于校验模版
/// Input：base-知识库注册id,tableName-表名,columStr-属性列串
/// Return："{success:'true',info:'校验成功！'}"/"{success:'false',errorinfo:'错误信息'}"  
/// Other:w ##class(web.DHCBL.MKB.MKBDataImportInfo).ValidateMappingTable("36","科室专业诊断","36||94[A]36||95[A]36||96[A]36||97")
ClassMethod ValidateMappingTable(base As %String, tableName As %String, columStr As %String) As %String
{
	s result=""
	q:base="" "{success:'false',errorinfo:'规则注册ID不能为空！'}"   //返回错误信息
	q:columStr="" "{success:'false',errorinfo:'传入列不能为空！'}"   //返回错误信息
	
	s MKBKMBDesc=$LISTGET($G(^User.MKBKLMappingBaseD(base)),3)  //表名
	q:(MKBKMBDesc'=tableName) "{success:'false',errorinfo:'导入的不是该界面的数据，请确认！'}"   //返回错误信息
	
	s wrongColumn=""  //错误列
	s columLen=$Length(columStr,"[A]")
    for i=1:1:columLen  
    { 
		s columId=$p(columStr,"[A]",i)  //规则注册子表ID
		s columBase=$p(columId,"||",1)  //规则注册子表parent
		s columChild=$p(columId,"||",2)  //规则注册子表child
		s MKBKMBFDesc=""  //规则管理的列名
		if (columBase'="")&(columChild'="")
		{
			s MKBKMBFDesc = $LG($G(^User.MKBKLMappingBaseD(columBase,"ChildField",columChild)),3)  //列名
		}
		if (columBase'=base)||(MKBKMBFDesc="")  //如果传入的规则注册子表的id指向的不是当前界面，或者根据id没有获取到列名
		{
	      	if (wrongColumn'="")
	      	{
	      		s wrongColumn=wrongColumn_"，"
	      	}
	      	s wrongColumn=wrongColumn_i
		}
		
	  
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
/// CreatDate:2019-08-15
/// Description：用于保存导入模版中的某一行规则数据
/// Input：base-知识库注册id,columStr-列串,valueStr-值串
/// Return："{success:'true',id:'规则管理表的ID'}" /"{success:'false',errorinfo:'错误信息'}"
/// Other:w ##class(web.DHCBL.MKB.MKBDataImportInfo).SaveMappingTableData("36","36||94[A]36||95[A]36||96[A]36||97","骨科[A]骨髓增殖性肿瘤[A]bz[A]2")
ClassMethod SaveMappingTableData(base As %String, columStr As %String, valueStr As %String) As %String
{
	s result=""
	q:base="" "{success:'false',errorinfo:'规则注册ID不能为空！'}"   //返回错误信息
	q:columStr="" "{success:'false',errorinfo:'传入列不能为空！'}"   //返回错误信息
	q:valueStr="" "{success:'false',errorinfo:'传入值不能为空！'}"   //返回错误信息
	
	s MKBKMBKnowledge1=$LISTGET($G(^User.MKBKLMappingBaseD(base)),5)  //知识点1	
	s MKBKMBKnowledge2=$LISTGET($G(^User.MKBKLMappingBaseD(base)),6)  //知识点2
	q:(MKBKMBKnowledge1="")||(MKBKMBKnowledge2="") "{success:'false',errorinfo:'规则注册里知识点1和知识点2不能为空！'}"   //返回错误信息
	
	s fieldValueStr=""   //保存值串
	s flag=0    //错误标识
	s columLen=$Length(columStr,"[A]")
    for i=1:1:columLen  
    { 
    	q:flag=1
		s columId=$p(columStr,"[A]",i)  //规则注册子表ID
		s columBase=$p(columId,"||",1)  //规则注册子表parent
		s columChild=$p(columId,"||",2)  //规则注册子表child
		if (columBase'=base)||(columChild="")  //如果传入的注册子表id不对
		{
			s flag=1
			s result="{success:'false',errorinfo:'第"_i_"列不属于"_tableName_"！'}"
		}
		s columValue=$p(valueStr,"[A]",i)  //单元格的值
		
		if (columValue'="")  //如果值不为空
		{
			s MKBKMBFType = $LG($G(^User.MKBKLMappingBaseD(base,"ChildField",columChild)),4)  //列的类型
			s MKBKMBFConfig = $LG($G(^User.MKBKLMappingBaseD(base,"ChildField",columChild)),5)  //配置项
			if (MKBKMBFType="K1")||(MKBKMBFType="K2")  //知识点1或者知识点2格式
			{
				s knoBase=""   //知识点1或者知识点2
				if (MKBKMBFType="K1")
				{
					s knoBase=MKBKMBKnowledge1
				}
				else
				{
					s knoBase=MKBKMBKnowledge2
				}
				
				if (MKBKMBFConfig="Desc")
				{					

					if (((MKBKMBFType="K1")&(knoBase="D"))||((MKBKMBFType="K2")&(knoBase="D")))  //文献管理
					{
						s columValue=$o(^User.MKBDocManageI("DescIndex"," "_$ZCONVERT(columValue,"U"),0))
					}
					elseif(((MKBKMBFType="K1")&(knoBase="A"))||((MKBKMBFType="K2")&(knoBase="A")))  //评估表
					{
						s columValue=$o(^User.MKBAssessmentBaseI("DescIndex"," "_$ZCONVERT(columValue,"U"),0))
					}
					else
					{
						s columValue=$p(columValue,"-",$l(columValue,"-")) //父子级那种的只取子集
						s columValue=" "_$ZCONVERT(columValue,"U") //转换成大写
						s columValue=$o(^User.MKBTermI("DescIndex",knoBase,columValue,0))
					}
				} 
				elseif(MKBKMBFConfig="Exp")  //表达式类型  目前没法导入
				{
					s columValue=$p(columValue,"[",1)
					s columValue=$p(columValue,"-",$l(columValue,"-")) //父子级那种的只取子集
					s columValue=" "_$ZCONVERT(columValue,"U") //转换成大写
					s columValue=$o(^User.MKBTermI("DescIndex",knoBase,columValue,0))
				}
				else   //属性内容  目前没法导入
				{
					s columValue=""
				} 
				
			}
			if (MKBKMBFType="TP")  //引用术语型  
			{				
				s columValue=$p(columValue,"-",$l(columValue,"-")) //父子级那种的只取子集
				s columValue=" "_$ZCONVERT(columValue,"U") //转换成大写
				s columValue=$o(^User.MKBTermI("DescIndex",MKBKMBFConfig,columValue,0))	
			}
	
		}
		
		if (fieldValueStr'="")
		{
			s fieldValueStr=fieldValueStr_"[N]"
			
		}
		s fieldValueStr=fieldValueStr_columChild_"[A]"_columValue

    }
    
 	if (result["false")
	{
	    q result
    }
	s result=##class(web.DHCBL.MKB.MKBKLMappingDetail).SaveData("",base,fieldValueStr)
	q result
}

/// Creator:谷雪萍
/// CreatDate:2019-08-30
/// Description：用于获取导出知识库术语的总数
/// Input：base-知识库注册id
/// Return：count-一共有多少数据
/// Other:w ##class(web.DHCBL.MKB.MKBDataImportInfo).GetTermDataCount(5)
ClassMethod GetTermDataCount(base As %String) As %String
{
	q:base="" ""
	k ^TMPMKBDATAIMPORT("T",base)
	s count=0
	s MKBTRowId=""
	for  
	{	
		s MKBTRowId=$o(^User.MKBTermI("BaseIndex",base,MKBTRowId)) q:MKBTRowId=""
		s MKBTCode=$listGet($g(^User.MKBTermD(MKBTRowId)),2)  //代码
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
/// Other:w ##class(web.DHCBL.MKB.MKBDataImportInfo).GetTermDataInfo(5,1)
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
	    	s ColumValue=$listGet($g(^User.MKBTermD(MKBTRowId)),2)  //代码
    	}
    	elseif (ColumDesc="中心词")
    	{
	    	s ColumValue=$listGet($g(^User.MKBTermD(MKBTRowId)),3)  //中心词
    	}
    	elseif (ColumDesc="检索码")
    	{
	    	s ColumValue=$listGet($g(^User.MKBTermD(MKBTRowId)),6)  //检索码
    	}
    	elseif (ColumDesc="上级节点")
    	{
	    	s ColumValue=$listGet($g(^User.MKBTermD(MKBTRowId)),5)  //上级节点
	    	//s:ColumValue'="" ColumValue=$listGet($g(^User.MKBTermD(ColumValue)),3)  //上级节点描述
	    	s:ColumValue'="" ColumValue=##class(web.DHCBL.MKB.MKBTerm).GetTreeComboDesc(ColumValue) 
    	}
    	elseif (ColumDesc="备注")
    	{
	    	s ColumValue=$listGet($g(^User.MKBTermD(MKBTRowId)),7)  //备注
    	}
    	elseif (ColumDesc="知识量")
    	{
	    	s ColumValue=$listGet($g(^User.MKBTermD(MKBTRowId)),10)  //知识量
    	}
    	else
    	{
			s UpColumDesc=" "_$ZCONVERT(ColumDesc,"U")
			s ProDr=$o(^User.MKBTermPropertyI("DescIndex",MKBTRowId,UpColumDesc,0))  //获取该术语的属性ID
			if (ProDr'="")  
			{
				s ProType=$LISTGET($G(^User.MKBTermPropertyD(ProDr)),4)   //属性格式
				s ProDetailId=$o(^User.MKBTermProDetailI("ProIdx",ProDr,0)) //属性内容的id
		
				if (ProDetailId'="")
				{
					s ColumValue=$LISTGET($G(^User.MKBTermProDetailD(ProDetailId)),3)   //属性内容
					if (ColumValue'="")&(ProType="SS")  //引用起始节点类型
					{
						//s ColumValue=$listGet($g(^User.MKBTermD(ColumValue)),3)  //中心词
						s ColumValue=##class(web.DHCBL.MKB.MKBTerm).GetTreeComboDesc(ColumValue) 
					}
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

/// Creator:谷雪萍
/// CreatDate:2019-09-24
/// Description：用于获取导出规则管理的总数
/// Input：base-规则注册id
/// Return：count-一共有多少数据
/// Other:w ##class(web.DHCBL.MKB.MKBDataImportInfo).GetMappingDataCount(36)
ClassMethod GetMappingDataCount(base As %String) As %String
{
	q:base="" ""
	k ^TMPMKBDATAIMPORT("M",base)
	s count=0
	s MKBKMDRowNum=0
	for  
	{	
		s MKBKMDRowNum=$o(^User.MKBKLMappingDetailI("RowNumIndex",base,MKBKMDRowNum)) q:MKBKMDRowNum="" 
		s count=count+1
		s ^TMPMKBDATAIMPORT("M",base,count)=MKBKMDRowNum
	}
	q count
}

/// Creator:谷雪萍
/// CreatDate:2019-09-24
/// Description：用于获取规则管理某一行的数据
/// Input：base-规则注册id ,i-第几行
/// Return：[A]连接的某一行的值
/// Other:w ##class(web.DHCBL.MKB.MKBDataImportInfo).GetMappingDataInfo(36,1)
ClassMethod GetMappingDataInfo(base As %String, i As %String) As %String
{
	q:(base="")||(i="") ""
	S MKBKMDRowNum=$g(^TMPMKBDATAIMPORT("M",base,i))   //规则管理MKBKMDRowNum
	q:MKBKMDRowNum="" ""
	
	s K1K2ChildStr=##class(web.DHCBL.MKB.MKBKLMappingDetail).GetK1AndK2EditChild(base)   //获取知识点1和知识点2的编辑列
	s K1Child=$p(K1K2ChildStr,"^",1)   //知识点1的编辑列
	s K2Child=$p(K1K2ChildStr,"^",2)  //知识点2的编辑列
			
	s ColumInfoStr=..GetMappingTableColumn(base)    //列信息串
	s ColumCodeStr=$p(ColumInfoStr,"[N]",2)      //列描述串
	s ColumCodeLen=$Length(ColumCodeStr,"[A]")
	s ColumValueStr=""    //列值串

    for j=1:1:ColumCodeLen  
    { 
    	s MKBKMDValue=""
    	s ColumCode=$p(ColumCodeStr,"[A]",j)  //列描述
    	s MKBKMBFChildSub=$p(ColumCode,"||",2)
		s MKBKMDValueStr=##class(web.DHCBL.MKB.MKBKLMappingDetail).GetMappingDetailValue(base, MKBKMBFChildSub,MKBKMDRowNum,K1Child,K2Child)  //获取规则管理明细表的值		
		s MKBKMDValue=$p(MKBKMDValueStr,"[A]",1)
		s MKBKMDValueF=$p(MKBKMDValueStr,"[A]",2)
		if (j=1){
	    	s ColumValueStr=MKBKMDValue
    	}
    	else
    	{
    		s ColumValueStr=ColumValueStr_"[A]"_MKBKMDValue
    	}
    }
    q ColumValueStr
}

/// Creator:李得原
/// CreatDate:2019-11-05
/// Description：导出临床实用诊断诊断模板中的数据
/// Input：
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBDataImportInfo).ExportDiagTemplate(base)
ClassMethod ExportDiagTemplate(base)
{
	q:base="" ""
	/*s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1)
	s PathDir=Disk_":\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\"
	s ifExistsDir=##class(%File).DirectoryExists(PathDir)
	if 'ifExistsDir
	{
		d ##class(%File).CreateDirectory("D:\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\")
	}*/
	
	s filename = $LISTGET($G(^User.MKBTermBaseD(base)),3)_"知识模板数据"_".csv"
	//s PathDir=Disk_":\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\"_filename
	
	Set componentxml = "\scripts\bdp\MKB\DataExport\" 
	;Set componentxml = "D:\" 
	s dirname = ##class(ext.util.String).GetPhysicalPath("",componentxml)
	s PathDir= dirname_filename  
	
	s file=##class(%File).%New(PathDir)
	d file.Open("NWS")
	d file.WriteLine("中心词,别名,属性,属性内容")
	s MKBTBRowid=$o(^User.MKBTermBaseI("DescIndex"," 临床实用诊断",0))   //获取baseid
	s MKBTermRowid=0
	for
	{
		s MKBTermRowid=$o(^User.MKBTermD(MKBTermRowid))
		q:MKBTermRowid=""
		s MKBTBase=$lg($g(^User.MKBTermD(MKBTermRowid)),4)
		continue:MKBTBase'=MKBTBRowid
		s MKBTDesc=$lg($g(^User.MKBTermD(MKBTermRowid)),3)
		s MKBTAliasString=""
		s MKBTAliasString=##class(web.DHCBL.MKB.MKBTermProperty).GetComOrAlias(MKBTermRowid)
		s MKBTAlias=$p(MKBTAliasString,"||",1)
		if MKBTAlias'=""   //如果别名不为空
		{
			s MKBTAlias=$tr(MKBTAlias,",","，")
			d file.WriteLine(MKBTDesc_","_MKBTAlias)
		}
		else
		{
			d file.WriteLine(MKBTDesc_","_"")
		}
		s MKBTermProRowid=$o(^User.MKBTermPropertyI("DescIndex",MKBTermRowid," 诊断模板",0))   //获取诊断模板rowid
		s MKBTemplateRowid=$o(^User.MKBTermProDetailI("ProIdx",MKBTermProRowid,0))
		continue:MKBTemplateRowid=""
		s MKBTemplate=$lg($g(^User.MKBTermProDetailD(MKBTemplateRowid)),3)    //诊断模板内容
		s length=$l(MKBTemplate,",")
		for i=1:1:length
		{
			continue:i=""
			s OnePiece=$p(MKBTemplate,",",i)
			s TempProRowid=$p(OnePiece,"&",1)    //属性ID
			s DefineNode=$p(OnePiece,"&",3)  //定义节点
			s MKBTPType=$lg($g(^User.MKBTermPropertyD(TempProRowid)),4)   //属性类型
			s MKBConfig=$lg($g(^User.MKBTermPropertyD(TempProRowid)),5)    //配置项(basedr)
			s PDesc=$lg($g(^User.MKBTermPropertyD(TempProRowid)),3)
			continue:PDesc="其他描述"
			d file.WriteLine(", ,"_PDesc)
			s Desc=""
			if "TX,TA,R,CB,C,L,T,F"[MKBTPType
			{
				if DefineNode'=""
				{
					s Property=$lg($g(^User.MKBTermProDetailD(DefineNode)),3)
					s Property=$replace(Property,",","，")
					d file.WriteLine(", , ,"_Property)
					s DescStr=..GetChildOrderedIDStrBatch(DefineNode,TempProRowid,0,1)
					continue:DescStr=""
					s desclen=$l(DescStr,"^")
					for k=1:1:desclen
					{
						continue:k=""
						s Desc=$p(DescStr,"^",k)
	
						s Desc=$replace(Desc,",","，")
						d file.WriteLine(" , , , ,"_Desc)
					}
				}
				else
				{
					s MKBTPDRowid=0
					for
					{
						s MKBTPDRowid=$o(^User.MKBTermProDetailI("ProIdx",TempProRowid,MKBTPDRowid))
						q:MKBTPDRowid=""
						s Desc=$lg($g(^User.MKBTermProDetailD(MKBTPDRowid)),3)
						s Desc=$replace(Desc,",","，")
						d file.WriteLine(", , ,"_Desc)
					}
				}
			} 
			elseif MKBTPType="S"    //引用术语
			{
				
				s MKBTPDRowid=0
				for
				{
					s MKBTPDRowid=$o(^User.MKBTermProDetailI("ProIdx",TempProRowid,MKBTPDRowid))
					q:MKBTPDRowid=""
					s Term=$lg($g(^User.MKBTermProDetailD(MKBTPDRowid)),3)
					set TermDataAlias=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(Term)    
					s strCom=$p(strComAndAlisa,"[A]",1)
					s Desc=$p(strCom,"&%",1) //诊断常用名
					if Desc=""
					{
						s Desc=$lg($g(^User.MKBTermD(Term)),3)
					}
					s Desc=$replace(Desc,",","，")
					d file.WriteLine(" , , ,"_Desc)
				}
			}
			elseif MKBTPType="P"
			{
				s MKBTPDRowid=0
				for
				{
					s MKBTPDRowid=$o(^User.MKBTermProDetailI("ProIdx",TempProRowid,MKBTPDRowid))
					q:MKBTPDRowid=""
					s Pro=$lg($g(^User.MKBTermProDetailD(MKBTPDRowid)),3)
					s Desc=$lg($g(^User.MKBTermPropertyD(Pro)),3)
					s Desc=$replace(Desc,",","，")
					d file.WriteLine(" , , ,"_Desc)
				}
			}
			elseif MKBTPType="SS"   //引用单节点
			{
				s MKBTPDRowid=0
				for
				{
					
					s MKBTPDRowid=$o(^User.MKBTermProDetailI("ProIdx",TempProRowid,MKBTPDRowid))
					q:MKBTPDRowid=""
					s Term=$lg($g(^User.MKBTermProDetailD(MKBTPDRowid)),3)
					
					s str=""
					;s term=$lg($g(^User.MKBTermD(Term)),3)
					s strComAndAlisa=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(Term)
					s strCom=$p(strComAndAlisa,"[A]",1)
					s term=$p(strCom,"&%",1) //诊断常用名
					if term=""
					{
						s term=$lg($g(^User.MKBTermD(Term)),3)
					}
					s term=$replace(term,",","，")
					d file.WriteLine(" , , ,"_term)
					s Desc=..GetSSDataSeq(.str,MKBConfig,Term,0,1)
					s str=$replace(str,",","，")
					s len=$l(str,"^")
					for j=1:1:len
					{
						continue:j=""
						s desc=$p(str,"^",j)
						d file.WriteLine(" , , , ,"_desc)
					}
				}
			}
		}
	}
	d file.%Save()
	d file.%Close()
	k file
	q filename
}

/// Creator:李得原
/// CreatDate:2019-11-06
/// Description：按顺序导出树形结构起始节点的数据
/// Input：字符串str； Term表的Base指向；Term表rowid；flags第几层循环，用来加空格；first,区别第几次进入函数
/// Return:返回字符串str
/// Other:w ##class(web.DHCBL.MKB.MKBDataImportInfo).GetSSDataSeq()
ClassMethod GetSSDataSeq(ByRef str, base As %String, id As %String, flags As %String, first As %String) As %String
{
	if first=1
	{
		s mark=""
	}
	else
	{
		s flags=flags+1
		s mark=""
		for i=1:1:flags
		{
			s mark="    "_mark
		}
	}
	s seq=0
	for
	{
		s seq=$o(^User.MKBTermI("ParSeqIndex",base,id,seq))
		
		q:seq=""
		s MKBTRowid=0
		for
		{
			s MKBTRowid=$o(^User.MKBTermI("ParSeqIndex",base,id,seq,MKBTRowid))
			q:MKBTRowid=""
			
			s strComAndAlisa=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(MKBTRowid)
			s strCom=$p(strComAndAlisa,"[A]",1)
			s MKBTDesc=$p(strCom,"&%",1) //诊断常用名
			if MKBTDesc=""
			{
				s MKBTDesc=$lg($g(^User.MKBTermD(MKBTRowid)),3)
			}
			s:str'="" str=str_"^"_mark_MKBTDesc
			s:str="" str=mark_MKBTDesc
			if $d(^User.MKBTermI("ParentIndex",base,MKBTRowid))  //如果有子节点
			{
				d ..GetSSDataSeq(.str,base,MKBTRowid,flags,2)
			}
		}
	}
	q str
}

/// Creator:李得原
/// CreatDate:2019-11-06
/// Description：导出非引用型数据的树形节点
/// Input：LastLevel：上级节点； property：属性id；flags第几层循环，用来加空格；first,区别第几次进入函数
/// Return:返回字符串IDStr
/// Other:w ##class(web.DHCBL.MKB.MKBDataImportInfo).GetSSDataSeq()
ClassMethod GetChildOrderedIDStrBatch(LastLevel As %String, property As %String, flags As %String, first As %String) As %String
{
	if first=1
	{
		s mark=""
	}
	else
	{
		s flags=flags+1
		s mark=""
		for i=1:1:flags
		{
			s mark="    "_mark
		}
	}
	if (LastLevel="") s LastLevel=-100000000000000	
	s IDStr=""
	s childStr=""
	s mySeq=""
	for {
		s mySeq=$o(^User.MKBTermProDetailI("ProParSeqIndex",property,LastLevel,mySeq)) q:(mySeq="")
		s myRowID=0
		for {
			s myRowID=$o(^User.MKBTermProDetailI("ProParSeqIndex",property,LastLevel,mySeq,myRowID)) q:(myRowID="")
			
			s childStr=..GetChildOrderedIDStrBatch(myRowID, property,flags,2)
			s desc=$lg($g(^User.MKBTermProDetailD(myRowID)),3)
			if childStr'="" s childStr=mark_desc_"^"_childStr
			if childStr="" s childStr=mark_desc
			
			if IDStr="" s IDStr=childStr
			else  s IDStr=IDStr_"^"_childStr
		}
	}
	q IDStr
}

/// Creator: 谷雪萍
/// CreatDate: 2021-06-23
/// Description: 读取科室诊断频次文件，导出科室常用中心词及诊断模板
/// Input: filePath-要读取的诊断及频次csv文件，base-数据处理工厂id，PathDir-要导出的文件夹路径
/// Other:w ##class(web.DHCBL.MKB.MKBDataImportInfo).ExportHospitalTermMode("D:\安贞\心外.csv",14,"D:\安贞\心外\") 
ClassMethod ExportHospitalTermMode(filePath As %String, base As %String, PathDir As %String)
{
	s Rtn=""
	s file=##class(%File).%New(filePath)
	d file.Open("RS")
	s linenum=1
	s str= file.ReadLine()
	s str= file.ReadLine()
	k ^TMPTERMMODE
	

	While 'file.AtEnd
	{	
		s str= file.ReadLine()
		q:str=""
		s linenum=linenum+1
		s diaName = $p(str,",",1)  //诊断名		
		s freq = $p(str,",",2)   //频次
		s:freq="" freq=0
		continue:diaName=""
		s updiaName=" "_$ZCONVERT(diaName,"U")
		s MKBSDDRowId=$o(^User.MKBStructuredDataI("MKBSDDiagIndex",base,updiaName,0)) //数据处理工厂id
		continue:MKBSDDRowId=""
		s seq=$O(^User.MKBStructuredDataResultI("SeqIndex",MKBSDDRowId,0))
		continue:seq=""
		s MKBSDChild=$O(^User.MKBStructuredDataResultI("SeqIndex",MKBSDDRowId,seq,0))
		continue:MKBSDChild=""
		s TermId=$LG($G(^User.MKBStructuredDataD(MKBSDDRowId,"MKBSDStructResult",MKBSDChild)),4)
		continue:(TermId="")||(TermId="false")
		s ^TMPTERMMODE(TermId)=$g(^TMPTERMMODE(TermId))+freq 	//记录中心词及频次放在临时global
	}

	//生成频次+中心词的临时global，用于输出
	k ^TMPTERMMODEOUTPUT
	s MKBTerm=0
	for
	{
		s MKBTerm=$o(^TMPTERMMODE(MKBTerm)) q:MKBTerm=""
		s fre=$g(^TMPTERMMODE(MKBTerm))
		s:fre="" fre=0
		s ^TMPTERMMODEOUTPUT(fre,MKBTerm)=""
	}

	//按频次由大到小输出
	s count=0
	s Frequ=""
	for
	{
		s Frequ=$o(^TMPTERMMODEOUTPUT(Frequ),-1)
		q:(Frequ="")||(Rtn["false")
		s MKBTermRowid=0
		for
		{
			s MKBTermRowid=$o(^TMPTERMMODEOUTPUT(Frequ,MKBTermRowid))
			q:MKBTermRowid=""
			s count=count+1
			//if (count<=5)
			//{
				s result=##class(web.DHCBL.MKB.MKBDataImportInfo).ExportTermMode(MKBTermRowid,PathDir,Frequ) 
				if (result["false")
				{
					s Rtn=result
					q
				}
			//}
		}
		
	}
	if (Rtn="")
	{
		s Rtn="true"
	}
	q Rtn
}

/// Creator: 谷雪萍
/// CreatDate: 2021-06-23
/// Description: 把该诊断的诊断模板里的数据都导出到excel中。
/// Input: MKBTermRowid-术语id，PathDir-导出路径 Frequ-频次
/// 参考w ##class(web.DHCBL.MKB.MKBStructuredData).ExportYDYTermProDetail(1,"D:\ANZHEN\") 
/// Other:w ##class(web.DHCBL.MKB.MKBDataImportInfo).ExportTermMode(15385,"D:\ANZHEN\") 
ClassMethod ExportTermMode(MKBTermRowid As %String, PathDir As %String, Frequ As %String)
{
	q:(MKBTermRowid="")||(PathDir="") "{success:'false',info:'入参不能为空'}" 
	s ifExistsDir=##class(%File).DirectoryExists(PathDir)
	if ifExistsDir'=1
	{
		d ##class(%File).CreateDirectory(PathDir)
	}
	s MKBTBRowid=##class(web.DHCBL.MKB.MKBTermBase).GetIdByFlag("Diagnose")   //获取baseid
	q:MKBTBRowid="" "{success:'false',info:'没有获取到诊断的知识库注册id'}" 
	q:'($d(^User.MKBTermD(MKBTermRowid))) "{success:'false',info:'诊断知识库下没有诊断id"_MKBTermRowid_"'}" 
	s MKBTermDesc=$lg($g(^User.MKBTermD(MKBTermRowid)),3)  //获取临床实用诊断中心词
	s MKBTermDesc=$replace(MKBTermDesc,",","，")
	q:MKBTermDesc="" "{success:'false',info:'根据诊断id"_MKBTermRowid_"获取到的中心词为空'}" 
	
	;获取中心词的常用名、别名
	s AliasOutput="",Com=""
	s TermDataAlias=##class(web.DHCBL.MKB.MKBTermProperty).GetComOrAlias(MKBTermRowid) 
	s TermDataAlias=$p(TermDataAlias,"||",1) ;获取别名
	if (TermDataAlias'="")   
	{
		s AliasNum=$l(TermDataAlias,",")  ;获取别名个数	
		for n=1:1:AliasNum
		{
			s AliasItem=$p(TermDataAlias,",",n)
			s AliasItem=$replace(AliasItem,",","，")
			if (n=1)
			{
				s Com=AliasItem
			}
			s:AliasOutput'="" AliasOutput=AliasOutput_"，"_AliasItem
			s:AliasOutput="" AliasOutput=AliasItem
		}
	}
	s:Com="" Com=MKBTermDesc
	s filename=PathDir_Frequ_Com_".csv"
	s file=##class(%File).%New(filename)
	d file.Open("NSW")
	d file.WriteLine("中心词,属性,属性名称,属性内容")


	d file.WriteLine(MKBTermDesc_",常用名,"_Com)
	d file.WriteLine(",别名,"_AliasOutput)
	
	s MKBTermProRowid=$o(^User.MKBTermPropertyI("DescIndex",MKBTermRowid," 诊断模板",0))   //获取诊断模板rowid
	q:MKBTermProRowid="" "{success:'false',info:'"_MKBTermDesc_"没有诊断模板'}" 
	s MKBTemplateRowid=$o(^User.MKBTermProDetailI("ProIdx",MKBTermProRowid,0))
	q:MKBTemplateRowid="" "{success:'false',info:'"_MKBTermDesc_"诊断模板内容为空'}" 
	s MKBTemplate=$lg($g(^User.MKBTermProDetailD(MKBTemplateRowid)),3)    //诊断模板内容
	s length=$l(MKBTemplate,",")
	for i=1:1:length
	{
		continue:i=""
		s OnePiece=$p(MKBTemplate,",",i)
		s TempProRowid=$p(OnePiece,"&",1)    //属性ID
		s DefineNode=$p(OnePiece,"&",3)  //定义节点
		s MKBTPType=$lg($g(^User.MKBTermPropertyD(TempProRowid)),4)   //属性类型
		s MKBConfig=$lg($g(^User.MKBTermPropertyD(TempProRowid)),5)    //配置项(basedr)
		s PDesc=$lg($g(^User.MKBTermPropertyD(TempProRowid)),3)  //属性名
		continue:PDesc="其他描述"
		d file.WriteLine(","_PDesc)
		s Desc=""
		if "TX,TA,R,CB,C,L,T,F"[MKBTPType
		{
			if DefineNode'=""
			{
				s Property=##class(web.DHCBL.MKB.MKBTermProDetail).GetExtendVal(DefineNode,TempProRowid,"展示名")  //获取展示名
				s:Property="" Property=$LISTGET($G(^User.MKBTermProDetailD(DefineNode)),3) //节点描述
				//s Property=$LISTGET($G(^User.MKBTermProDetailD(DefineNode)),3)  //20210624 改为取中心词，不取常用名
				s Property=$replace(Property,",","，")
				d file.WriteLine(",,"_Property)
				s DescStr=##class(web.DHCBL.MKB.MKBStructuredData).GetChildOrderedIDStr(DefineNode,TempProRowid,0,1)  //20210624 改为取中心词，不取常用名
				continue:DescStr=""
				s desclen=$l(DescStr,"^")
				for k=1:1:desclen
				{
					continue:k=""
					s Desc=$p(DescStr,"^",k)

					s Desc=$replace(Desc,",","，")
					d file.WriteLine(" ,,,"_Desc)
				}
			}
			else
			{
				

				s DescStr=##class(web.DHCBL.MKB.MKBStructuredData).GetChildOrderedIDStr("",TempProRowid,0,1)  //20210624 改为取中心词，不取常用名
				continue:DescStr=""
				s desclen=$l(DescStr,"^")
				for k=1:1:desclen
				{
					continue:k=""
					s Desc=$p(DescStr,"^",k)

					s Desc=$replace(Desc,",","，")
					d file.WriteLine(" ,,,"_Desc)
				}
				
			}
		} 
		elseif MKBTPType="S"    //引用术语
		{
			
			if DefineNode'=""
			{

				s Desc=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComByTermId(DefineNode)
				//s Desc=$listGet($g(^User.MKBTermD(DefineNode)),3)  //术语中心词	 20210624 改为取中心词，不取常用名
				s Desc=$replace(Desc,",","，")
				d file.WriteLine(",,,"_Desc)
			
			}
			s sd=""      //用来存储选中的引用术语
			s MKBTinD=0
			for
			{
				s MKBTinD=$o(^User.MKBTermProDetailI("ProIdx",TempProRowid,MKBTinD))
				q:MKBTinD=""
				s MKBt=$lg($g(^User.MKBTermProDetailD(MKBTinD)),3)
				s sd(MKBt)=""
			}
			s sstr=""
			d ##class(web.DHCBL.MKB.MKBStructuredData).GetSTermTree(.sstr, MKBConfig, DefineNode, TempProRowid,.sd,1) // 20210624 改为取中心词，不取常用名
			s ls=$l(sstr,"&")
			for p=1:1:ls
			{
				if p=1
				{
					s Desc=$p(sstr,"&",1)
					d file.WriteLine(",,"_Desc)
				}
				else
				{
					s Desc=$p(sstr,"&",p)
					d file.WriteLine(",,,"_Desc)
				}
			}
		}
		elseif MKBTPType="P"
		{
			s MKBTPDRowid=0
			for
			{
				s MKBTPDRowid=$o(^User.MKBTermProDetailI("ProIdx",TempProRowid,MKBTPDRowid))
				q:MKBTPDRowid=""
				s Pro=$lg($g(^User.MKBTermProDetailD(MKBTPDRowid)),3)
				s Desc=$lg($g(^User.MKBTermPropertyD(Pro)),3)
				s Desc=$replace(Desc,",","，")
				d file.WriteLine(" ,,"_Desc)
			}
		}
		elseif MKBTPType="SS"   //引用单节点
		{		
			s MKBTPDRowid=$o(^User.MKBTermProDetailI("ProIdx",TempProRowid,0))
			s Term=""
			s:MKBTPDRowid'="" Term=$lg($g(^User.MKBTermProDetailD(MKBTPDRowid)),3)
			s:MKBTPDRowid="" Term=-100000000000000
			
			s term=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComByTermId(Term)
			//s term=$listGet($g(^User.MKBTermD(Term)),3)  //术语中心词	20210624 改为取中心词，不取常用名
			d file.WriteLine(",,"_term)
			s str=""
			s Desc=##class(web.DHCBL.MKB.MKBStructuredData).GetSSData(.str,MKBConfig,Term,0,1)  //20210624 改为取中心词，不取常用名
			s str=$replace(str,",","，")
			s len=$l(str,"^")
			for j=1:1:len
			{
				continue:j=""
				s desc=$p(str,"^",j)
				d file.WriteLine(" ,,,"_desc)
			}
			
			
		}
		else
		{
			continue
		}
	}
	
	
	d file.%Save()
	d file.%Close()
	k file
	q filename
}

/// Creator：丁亚男 
/// CreatDate: 2021-11-22
/// Description：导入检查的注意事项
/// Table:
/// Input： path
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBDataImportInfo).ImportAttentionData("C:\Users\DELL\Desktop\安徽省立百科注意事项导入版.csv")
ClassMethod ImportAttentionData(path)
{
	s savecount=0
	s nosavecount=0
	
	s file=##class(%File).%New(path)
	d file.Open("RS")
	d file.ReadLine()		//读取第一行
	while 'file.AtEnd
	{
		s str=file.ReadLine()
		continue:str=""
		
		s MKBTDesc=$p(str,",",1)	//中心词
		s MKBTPDDesc=$p(str,",",2)
		s MKBTDesc=$Zstrip(MKBTDesc,"<>W")
		s MKBTPDDesc=$Zstrip(MKBTPDDesc,"<>W")
		s MKBTDesc=$tr(MKBTDesc,"&%",",")
		s MKBTPDDesc=$tr(MKBTPDDesc,"&%",",")
		continue:(MKBTDesc="")||(MKBTPDDesc="")
		s termdr="",MKBTPDProDR=""
		s BaseDR=$o(^User.MKBTermBaseI("DescIndex"," "_"检查",0))
		s termdr=$o(^User.MKBTermI("DescIndex",BaseDR," "_$ZCONVERT(MKBTDesc,"U"),0))
		s:termdr'="" MKBTPDProDR=$o(^User.MKBTermPropertyI("DescIndex",termdr," "_"注意事项",0))
		
		s bobj = ##class(web.Entity.MKB.MKBTermProDetail).%New()
	    s bobj.MKBTPDProDR = MKBTPDProDR
		s bobj.MKBTPDDesc = MKBTPDDesc
		
		s result=##class(web.DHCBL.MKB.MKBTermProDetail).SaveData(bobj)
		if ((result'["false"))
		{
			s savecount=savecount+1
		}
		else
		{
			w !,MKBTDesc
			s nosavecount=nosavecount+1
		}
	}
	w "savecount："_savecount,!
	w "nosavecount:"_nosavecount,!
	
	q "{success:'true'}"
}

/// Creator：丁亚男 
/// CreatDate: 2022-01-22
/// Description：导入检验的注意事项等属性
/// Table:
/// Input： path
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBDataImportInfo).ImportLabAttentionData("C:\Users\DELL\Desktop\20220122检验百科数据导入--安徽省立.csv")
ClassMethod ImportLabAttentionData(path)
{
	s KFsavecount=0,ZYSXsavecount=0,JYBBsavecount=0
	s KFnosavecount=0,ZYSXnosavecount=0,JYBBnosavecount=0
	
	s file=##class(%File).%New(path)
	d file.Open("RS")
	d file.ReadLine()		//读取第一行
	d file.ReadLine()		//读取第二行
	d file.ReadLine()		//读取第三行
	while 'file.AtEnd
	{
		s str=file.ReadLine()
		continue:str=""
		
		s MKBTDesc=$p(str,",",2)	//中心词
		s KFMKBTPDDesc=$p(str,",",9)  //空腹
		s ZYSXMKBTPDDesc=$p(str,",",12)  //注意事项
		s JYBBMKBTPDDesc=$p(str,",",17)  //检验标本及采集要求
		
		s MKBTDesc=$Zstrip(MKBTDesc,"<>W")
		s KFMKBTPDDesc=$Zstrip(KFMKBTPDDesc,"<>W")
		s ZYSXMKBTPDDesc=$Zstrip(ZYSXMKBTPDDesc,"<>W")
		s JYBBMKBTPDDesc=$Zstrip(JYBBMKBTPDDesc,"<>W")
		
		s MKBTDesc=$tr(MKBTDesc,"&%",",")
		s KFMKBTPDDesc=$tr(KFMKBTPDDesc,"&%",",")
		s ZYSXMKBTPDDesc=$tr(ZYSXMKBTPDDesc,"&%",",")
		s JYBBMKBTPDDesc=$tr(JYBBMKBTPDDesc,"&%",",")
		
		//保存空腹
		s termdr="",KFMKBTPDProDR="",KFDetailDr=""
		s BaseDR=$o(^User.MKBTermBaseI("DescIndex"," "_"检验",0))
		s termdr=$o(^User.MKBTermI("DescIndex",BaseDR," "_$ZCONVERT(MKBTDesc,"U"),0))
		if (termdr="")
		{
			s eobj = ##class(web.Entity.MKB.MKBTerm).%New()
			s eobj.MKBTBaseDR=BaseDR
			s eobj.MKBTDesc=MKBTDesc
			//先保存术语
		    s result=##class(web.DHCBL.MKB.MKBTerm).SaveData(eobj)
		    if (result["true")
		    {
			    //获取术语id
				s termdr=$p(result,"'",4)
		    }
		}
		if (KFMKBTPDDesc'="")
		{
			s:termdr'="" KFMKBTPDProDR=$o(^User.MKBTermPropertyI("DescIndex",termdr," "_"空腹检查",0))
			s:KFMKBTPDProDR'="" KFDetailDr=$o(^User.MKBTermProDetailI("ProIdx",KFMKBTPDProDR,0))
			
			
			s KFbobj = ##class(web.Entity.MKB.MKBTermProDetail).%New()
			s KFbobj.MKBTPDRowId = KFDetailDr
		    s KFbobj.MKBTPDProDR = KFMKBTPDProDR
			s KFbobj.MKBTPDDesc = KFMKBTPDDesc
			
			s KFresult=##class(web.DHCBL.MKB.MKBTermProDetail).SaveData(KFbobj)
			if ((KFresult'["false"))
			{
				s KFsavecount=KFsavecount+1
			}
			else
			{
				s KFnosavecount=KFnosavecount+1
			}
		}
		//保存注意事项
		if (ZYSXMKBTPDDesc'="")
		{
			s ZYSXMKBTPDProDR="",ZYSXDetailDr="",OZYSXMKBTPDDesc=""
			s:termdr'="" ZYSXMKBTPDProDR=$o(^User.MKBTermPropertyI("DescIndex",termdr," "_"注意事项",0))
			//先取原来的注意事项
			s:ZYSXMKBTPDProDR'="" ZYSXDetailDr=$o(^User.MKBTermProDetailI("ProIdx",ZYSXMKBTPDProDR,0))
			s:ZYSXDetailDr'="" OZYSXMKBTPDDesc=$LISTGET($G(^User.MKBTermProDetailD(ZYSXDetailDr)),3)
			if (OZYSXMKBTPDDesc'="")&(OZYSXMKBTPDDesc'[ZYSXMKBTPDDesc)
			{
				s ZYSXMKBTPDDesc=OZYSXMKBTPDDesc_"<br>"_ZYSXMKBTPDDesc
			}
			
			s ZYSXbobj = ##class(web.Entity.MKB.MKBTermProDetail).%New()
			s ZYSXbobj.MKBTPDRowId = ZYSXDetailDr
		    s ZYSXbobj.MKBTPDProDR = ZYSXMKBTPDProDR
			s ZYSXbobj.MKBTPDDesc = ZYSXMKBTPDDesc
			
			s ZYSXresult=##class(web.DHCBL.MKB.MKBTermProDetail).SaveData(ZYSXbobj)
			if ((ZYSXresult'["false"))
			{
				s ZYSXsavecount=ZYSXsavecount+1
			}
			else
			{
				s ZYSXnosavecount=ZYSXnosavecount+1
			}
		}
		//保存检验标本及采集要求
		if (ZYSXMKBTPDDesc'="")
		{
			s JYBBMKBTPDProDR="",JYBBDetailDr="",CJYQChildsubId=""
			s:termdr'="" JYBBMKBTPDProDR=$o(^User.MKBTermPropertyI("DescIndex",termdr," "_"检验标本及采集要求",0))
			//删除检验标本及采集要求
			s MKBTPDRowId=0
			for  
			{	
				s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProIdx",JYBBMKBTPDProDR,MKBTPDRowId)) q:MKBTPDRowId="" 
				s rnt=##class(web.DHCBL.MKB.MKBTermProDetail).DeleteData(MKBTPDRowId)
			}
			
			s:JYBBMKBTPDProDR'="" CJYQChildsubId=$o(^User.MKBTermExtendProI("NameIndex",JYBBMKBTPDProDR," 采集要求",0))
			
			s lenNext=$l(JYBBMKBTPDDesc,"[next]")
			for iNext=1:1:lenNext
			{
				s JYBBMKBTPDDescOne=$p(JYBBMKBTPDDesc,"[next]",iNext)
				s JYBBMKBTPDDescValue=$p(JYBBMKBTPDDescOne,"[and]",1)
				s CJYQMKBTPDDescValue=$p(JYBBMKBTPDDescOne,"[and]",2)
				s MKBTPDExtend=""
				if (CJYQChildsubId'="")&(CJYQMKBTPDDescValue'="")
				{
					s MKBTPDExtend=CJYQChildsubId_"[A]"_CJYQMKBTPDDescValue
				}
				s JYBBDetailDr=""
				//获取当前标本的属性内容ID
				if (JYBBMKBTPDProDR'="")
				{
					s MKBTPDRowId=0
					for  
					{	
						s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProIdx",JYBBMKBTPDProDR,MKBTPDRowId)) q:MKBTPDRowId="" 
						s MKBTPDDesc=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),3) //描述
						if (MKBTPDDesc=JYBBMKBTPDDescValue)
						{
							s JYBBDetailDr=MKBTPDRowId
							q 
						}
					}
					if (JYBBMKBTPDDescValue'="")
					{
						s JYBBbobj = ##class(web.Entity.MKB.MKBTermProDetail).%New()
						s JYBBbobj.MKBTPDRowId = JYBBDetailDr
					    s JYBBbobj.MKBTPDProDR = JYBBMKBTPDProDR
						s JYBBbobj.MKBTPDDesc = JYBBMKBTPDDescValue
						s JYBBbobj.MKBTPDExtend=MKBTPDExtend
						s JYBBresult=##class(web.DHCBL.MKB.MKBTermProDetail).SaveData(JYBBbobj)
						if ((JYBBresult'["false"))
						{
							s JYBBsavecount=JYBBsavecount+1
						}
						else
						{
							s JYBBnosavecount=JYBBnosavecount+1
						}
					}
				}
				
			}
			
			
		}
		
		
		
	}
	w "KFsavecount："_KFsavecount_"ZYSXsavecount："_KFsavecount_"JYBBsavecount："_JYBBsavecount,!
	w "KFnosavecount:"_KFnosavecount_"ZYSXnosavecount:"_KFnosavecount_"JYBBnosavecount:"_JYBBnosavecount,!
	
	q "{success:'true'}"
}

}
