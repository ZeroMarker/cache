/// 手写签名业务逻辑类
Class EPRservice.BLHandWrittenSign Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

/// d ##Class(EPRservice.BLHandWrittenSign).foo()
ClassMethod foo()
{
	    s obj=##Class(EPRmeta.SysOption).%New()
		s obj.Name="HandWrittenPrintDocIDs"
		s obj.Description="系统22|使用手写签名的打印模板ID"
		s obj.IsVisible="Y"
		s obj.OptionValue="523"
		d obj.%Save()
}

/// 保存签名文件信息，再物理保存文件成功之后调用
ClassMethod SaveHandWrittenSign(EpisodeID, PrintDocID, EPRNum, FileName, FilePath As %String)
{
		s obj=##Class(EPRinstance.HandWrittenSign).%New()
		s obj.EpisodeID=EpisodeID
		s obj.PrintDocID=PrintDocID
		s obj.EPRNum=EPRNum
		s obj.FileName=FileName
		s obj.FilePath=FilePath
		s obj.IsValid=1
		s obj.CreateDate=$p($h, ",", 1)
		s obj.CreateTime=$p($h, ",", 2)
		d obj.%Save()
}

/// 获取存在FTP上的路径
ClassMethod GetFilePath(EpisodeID, PrintDocID, EPRNum As %String) As %String
{
	s id=..GetLastValidSign(EpisodeID, PrintDocID, EPRNum)
	q:(id="") ""
		
	s obj=##Class(EPRinstance.HandWrittenSign).%OpenId(id)
	q:(obj="")
	q obj.FilePath
}

/// 取最后一条有效相关的记录，返回ID
ClassMethod GetLastValidSign(EpisodeID, PrintDocID, EPRNum As %String) As %String
{
	s id = ..GetLastSign(EpisodeID, PrintDocID, EPRNum)
	q:(id="") ""
	
	s obj=##Class(EPRinstance.HandWrittenSign).%OpenId(id)
	q:(obj="")	
	
	q:(obj.IsValid=1) id
	
	q ""
}

/// 取最后一条相关的记录，返回ID
ClassMethod GetLastSign(EpisodeID, PrintDocID, EPRNum As %String) As %String
{
	s id=""
	s id=$O(^DHCEPRI.HandWrittenSignI("Idx", " "_EpisodeID, " "_PrintDocID, " "_EPRNum, id), -1)
	q id
}

/// 将所有相关的签名日志记录都设置为失效状态
/// d ##Class(EPRservice.BLHandWrittenSign).SetSignUnvalid(EpisodeID, PrintDocID, EPRNum)
ClassMethod SetSignUnvalid(EpisodeID, PrintDocID, EPRNum As %String)
{
	s id=""
	s log=""
	for {
		s id=$O(^DHCEPRI.HandWrittenSignI("Idx", " "_EpisodeID, " "_PrintDocID, " "_EPRNum, id), -1)
		q:(id="") 
		s log=##Class(EPRinstance.HandWrittenSign).%OpenId(id)
		if (log '= "")
		{
			s log.IsValid=0
			d log.%Save()
			s log=""
		}
    }
}

/// 查询是否需要进行手写签名 无需则返回0
/// w ##Class(EPRservice.BLHandWrittenSign).IsNeedHandWritten(1)
ClassMethod IsNeedHandWrittenOld(PrintDocID As %String) As %String
{
	s result="0"
	q:(PrintDocID="") result
	
	s prtDocIDs=##class(EPRmeta.SysOption).GetOptionValueByName2("HandWrittenPrintDocIDs","")
    q:(prtDocIDs="") result
	s count=$Length(prtDocIDs, "^")
	f i=1:1:count 
	{
		if (PrintDocID = $P(prtDocIDs, "^", i))
		{
			s result = "1"
			q 
		}	     
	}
	
	q result
}

ClassMethod CanHandWritten(CTLOCID, PrintDocID As %String) As %String
{
	//q:((CTLOCID="19")&&(..IsNeedHandWritten(PrintDocID))) "1"
	q:((..IsNeedHandWritten(PrintDocID))) "1"
	q "0"
}

/// w ##Class(EPRservice.BLHandWrittenSign).IsNeedHandWritten1("")
ClassMethod IsNeedHandWritten(PrintDocID As %String) As %String
{
	s id=""
	s id=$O(^DHCEPRM.HandWrittenPrtIDI("Idx", " "_PrintDocID, id))
	q:(""=id) "0"
	
	q "1"
}

/// 将需要手写签名的打印模板号写入到系统参数中，以^分割
ClassMethod SetHandWrittenPrtDocIDsOld(PrintDocIDs As %String)
{
	s id=$o(^DHCEPRM.SysOptionI("NameIndex"," "_$zcvt("HandWrittenPrintDocIDs","U"),""))
	if (""=id)	//新增系统参数
	{
		s obj=##Class(EPRmeta.SysOption).%New()
		s obj.Name="HandWrittenPrintDocIDs"
		s obj.Description="系统22|使用手写签名的打印模板ID"
		s obj.IsVisible="Y"
		s obj.OptionValue=PrintDocIDs
		d obj.%Save()	
	}
	else	//更新描述
	{
		s obj=##Class(EPRmeta.SysOption).%OpenId(id)
		s obj.OptionValue=PrintDocIDs
		d obj.%Save()
    }
}

/// PrintDocIDs:以^分割
/// d ##Class(EPRservice.BLHandWrittenSign).SetHandWrittenPrtDocIDs("")
ClassMethod SetHandWrittenPrtDocIDs(PrintDocIDs As %String)
{
	&sql(delete from EPRmeta.HandWrittenPrtID)
	
	q:(PrintDocIDs="")||(PrintDocIDs=$C(0)) 
	s count=$Length(PrintDocIDs, "^")
	f i=1:1:count 
	{
		s obj=##Class(EPRmeta.HandWrittenPrtID).%New()
		s obj.PrtID=$Piece(PrintDocIDs, "^", i)
		d obj.%Save()
	}
}

/// w ##Class(EPRservice.BLHandWrittenSign).GetHandWrittenPrtDocIDs()
ClassMethod GetHandWrittenPrtDocIDs1() As %String
{
	s result = ""
	s id=$o(^DHCEPRM.SysOptionI("NameIndex"," "_$zcvt("HandWrittenPrintDocIDs","U"),""))
	if (""=id)	//新增系统参数
	{
		s obj=##Class(EPRmeta.SysOption).%New()
		s obj.Name="HandWrittenPrintDocIDs"
		s obj.Description="系统22|使用手写签名的打印模板ID"
		s obj.IsVisible="Y"
		s obj.OptionValue=""
		d obj.%Save()	
	}
	else	//更新描述
	{
		s obj=##Class(EPRmeta.SysOption).%OpenId(id)
		s result = obj.OptionValue 
    }
    
    q result
}

ClassMethod GetHandWrittenPrtDocIDs() As %String
{
	s result = ""
	
		&sql(declare myCursor cursor for 
			SELECT PrtID INTO :curid FROM EPRmeta.HandWrittenPrtID)
		&sql(open myCursor)
		for {
			&sql(fetch myCursor)
			q:(SQLCODE)
			
			if (result="") { s result = curid }
			else { s result = result_"^"_curid }
		}
		&sql(close myCursor)	
    
    q result
}

}
