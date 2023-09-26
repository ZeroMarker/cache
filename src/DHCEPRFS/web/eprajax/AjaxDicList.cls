Class DHCEPRFS.web.eprajax.AjaxDicList Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s filter = $g(%request.Data("Filter",1),"")
	s pageSize = $g(%request.Data("rows",1),"")
	s pageNum = $g(%request.Data("page",1),"")
	s startRow = (pageNum -1)*pageSize + 1
	s endRow = startRow + pageSize -1
	s dicCode = $g(%request.Data("DicCode",1),"")
	s action = $g(%request.Data("Action",1),"")
	
	if (action = "ssgroup")
	{
		d ..GetSSGroup(filter,startRow,endRow)
	}
	else
	{
		d ..GetDicList(dicCode,filter,startRow-1,pageSize,"True",0,"","","")
	}
	Quit $$$OK
}

/// d ##Class(DHCEPRFS.web.eprajax.AjaxDicList).GetDicList("S07","",0,12,"True",0,"","","")
ClassMethod GetDicList(ADicCode As %String, AItem As %String, AStartRow As %Integer, ARowCount As %Integer, CountFlag As %String, ByRef AResultCount As %String, ByRef SessionId As %String, AConditionCode As %String = "", ACondition As %String = "")
{
    //检查参数有效性
 	if (ADicCode=$C(0)) { s ADicCode= "" Quit ""}
 	if (AItem=$C(0)){ s AItem= ""}
 	if (AStartRow=$C(0)){ s AStartRow = 0 Quit ""}
 	if (ARowCount=$C(0)){ s ARowCount = 0 Quit ""} 
 	
   	S ASessionId=$I(^CacheTemp)
   	s SessionId=ASessionId
   	K ^CacheTempStdQuery(ASessionId)
   
   	//生成字典查询结果集，并存储在临时global中
    s PageCount= ..SelectNewStdDicPageCount(ADicCode,AItem,AStartRow,ARowCount,ASessionId,AConditionCode,ACondition)
   	s AResultCount =PageCount
   	s TotalRowCount =  $G(^CacheTempStdQueryCount(ASessionId,"StdQueryDataCount"))
   	//取相应页码的结果
  	if (PageCount'=0)
  	{ 
  		//以AStartRow开始，查询ARowCount个数据到Result中，与下面的按页查询相区别
        s Result = ##class(%ResultSet).%New("DHCEPRFS.web.eprajax.AjaxDicList:GetDicInTurn")
    	d Result.Execute(ADicCode,AItem,AStartRow,ARowCount,ASessionId)
  	}
  	else
  	{
		s SessionId=0
		s Result = "" 
	}
 	
 	w "{""rows"":["
 	s count = 0
 	while(Result.Next())
 	{
	 	s count = count + 1
	 	if (count > 1) w ","
		w "{"
        w ..TrimEnter("""ID"":"""_$g(Result.Data("DicCode"))_""",")
        w ..TrimEnter("""DicAlias"":"""_$g(Result.Data("DicAlias"))_""",")
        w ..TrimEnter("""DicCode"":"""_$g(Result.Data("DicCode"))_""",")
        w ..TrimEnter("""DicDesc"":"""_$g(Result.Data("DicDesc"))_"""")
        w "}"   
    }
    w "],""total"":"_TotalRowCount_"}"
}

ClassMethod TrimEnter(AInput As %String) As %String
{
	s ret = $TR(AInput,$C(13),"")
	s ret = $TR(ret,$C(10),"")
	q ret
}

/// d ##Class(DHCEPRFS.web.eprajax.AjaxDicList).GetSSGroup("",1,10)
ClassMethod GetSSGroup(AGroupName As %String, AIdxStart As %Integer, AIdxLast As %Integer)
{
	if (AGroupName = $c(0)) s AGroupName = ""
	
	if (AGroupName = "")
	{
		s result = ##Class(%ResultSet).%New("DHCEPRFS.web.eprajax.AjaxDicList:GetAllSSGroup")
		s sc = result.Execute()
	}
	else
	{
		s result = ##Class(%ResultSet).%New("DHCEPRFS.web.eprajax.AjaxDicList:GetSSGroupByName")
		s sc = result.Execute("%"_AGroupName_"%")		
	}
	
 	//b "s"
 	w "{""rows"":["
 	s count = 0
 	s first = 1
 	while(result.Next())
 	{
	 	s count = count + 1
		if ( count >= AIdxStart) && (count <= AIdxLast)
		{
		 	if ((count > 1)&&(first '= 1)) w ","
			w "{"
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""ID"":"""_$g(result.Data("SSGRP_RowId"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""DicDesc"":"""_$g(result.Data("SSGRP_Desc"))_"""")
			w "}"
			s first = 0	
		}
 	}
	w "],""total"":"_count_"}"
}

Query GetAllSSGroup() As %SQLQuery(CONTAINID = 1, ROWSPEC = "SSGRP_RowId:%String,SSGRP_Desc:%String")
{
	select SSGRP_RowId,SSGRP_Desc 
	from SQLUser.SS_Group 
	order by SSGRP_RowId
}

Query GetSSGroupByName(argGroupName As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "SSGRP_RowId:%String,SSGRP_Desc:%String")
{
	select SSGRP_RowId,SSGRP_Desc 
	from SQLUser.SS_Group 
	where SSGRP_Desc like :argGroupName
}

Query GetDicInTurn(ADicCode As %String, AItem As %String, AStartRow As %Integer, ARowCount As %Integer, ASessionId As %String) As %Query(ROWSPEC = "ID:%String,DicAlias:%String,DicCode:%String,DicDesc:%String")
{
}

ClassMethod GetDicInTurnExecute(ByRef qHandle As %Binary, ADicCode As %String, AItem As %String, AStartRow As %Integer, ARowCount As %Integer, ASessionId As %String) As %Status
{
    //b "s"
    s qHandle="1" 
    s SQLCODE=0 
    //s %ROWID=0 
    s %counter=0
    s ID=""
    S %ResultID=""
    s ^AA("baaa")=ASessionId
    //S ^CacheTempStdQuery($J)="True"   
    if ($D(^CacheTempStdQuery(ASessionId)))
    {
    
        if ($G(^CacheTempStdQuery(ASessionId))="True") 
        {
            Set StartPageID= AStartRow
            s ^AA("BBB")=StartPageID
            Set LastPageId = AStartRow+ARowCount
            Set PageNumCounter = 0 
            s ^AA("ccc")=LastPageId
            set PageKey= $O(^CacheTempStdQuery(ASessionId,""))
            s ^AA("iii")=PageKey
            While (PageKey '="")
            {
                s PageNumCounter = PageNumCounter + 1
                if (PageNumCounter> StartPageID)&(PageNumCounter <= LastPageId)
                { 
                    s ^AA("qqq")=PageNumCounter _"@@@"_PageKey
                    Set %ResultID(PageNumCounter-StartPageID)= $G(^CacheTempStdQuery(ASessionId,PageKey))    
                }
        
                set PageKey= $O(^CacheTempStdQuery(ASessionId,PageKey))  
            }
            ;s ^gjbtest("ASessionId",ASessionId)=""
            s qHandle=%ResultID
            Quit $$$OK
        }
    }
    Quit $$$OK
}

ClassMethod GetDicInTurnFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDicInTurnExecute ]
{
 s SQLCODE=0 
 s $ET="QUIT" 
 s %counter=%counter+1
 if $o(%ResultID(""),-1)<%counter 
 {
    s Row = ""
    s AtEnd=1
 }
 else 
 {
    set Row=%ResultID(%counter)
    ;s ^gjbtest(%counter)=Row
    }

 Quit $$$OK
}

ClassMethod GetDicInTurnClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDicInTurnExecute ]
{
 s qHandle="" 
 Quit $$$OK
}

ClassMethod SelectNewStdDicPageCount(ADicCode As %String, AConditon As %String, APageNum As %Integer, ARowCount As %Integer, ASessionId As %String, ADefaultConditionCode As %String = "", ADefaultCondition As %String = "") As %Integer
{
 //初始化返回值
 s returnPageCount = 0
 
 // 校验入参
 q:(ADicCode="") returnPageCount
 
 // 转换入参
 if ARowCount= 0    
 {  s ARowCount = 12}
    
 //取字典及相关配置信息
 s arrDicInfo = ..GetDicInfo(ADicCode)
 q:(arrDicInfo = "") returnPageCount
 s DicTableName = arrDicInfo.GetAt("TableName")
 s DicAlias = arrDicInfo.GetAt("DicAliasCol")
 s DicCode = arrDicInfo.GetAt("DicCodeCol")
 s DicDesc = arrDicInfo.GetAt("DicDescCol")
    
 //是否保留字典描述列中的横线
 set isKeepMinus = ##Class(EPRmeta.SysOption).CheckMinusFieldExist(DicTableName,DicDesc)
 
 //查询条件中是否含有GB字符
 s hasGB=0
 s ComLength = $L(AConditon)
 for I=1:1:ComLength 
 {
    s GBStr= $E(AConditon,I)  
    if (($A(GBStr)>=19968)&& ($A(GBStr)<=40869))||(($A(GBStr)>=63744)&& ($A(GBStr)<=64045))
    {
        s hasGB=1
        q
    }
 }
 
 //查询字典内容
 s totRowCount = ..SelectStdDicCTLoc(AConditon, DicAlias, DicCode, DicDesc, ASessionId, hasGB, isKeepMinus)

 
 s ^CacheTempStdQueryCount(ASessionId,"StdQueryDataCount")=totRowCount	
 s ^CacheTempStdQuery(ASessionId)="True"
 
 s returnPageCount = totRowCount\ARowCount
 s modulo = totRowCount#ARowCount
 if modulo'=0
 {  s returnPageCount = returnPageCount + 1}  
    
 q returnPageCount
}

/// Desc:   取字典信息
ClassMethod GetDicInfo(ADicCode As %String) As %ArrayOfDataTypes
{
    s dicInfo = ""
    
    s dicID = "", dicTableName = "", dicAliasCol = "", dicCodeCol = "", dicDescCol = ""
    &sql(select top 1 ID, TableName, DicAliasCol, DicCodeCol, DicDescCol
        into :dicID, :dicTableName, :dicAliasCol, :dicCodeCol, :dicDescCol 
        from EPRmeta.StdDictionary where EPRmeta.StdDictionary.Code = :ADicCode)
    
    q:(dicID = "")||(dicID = $c(0)) dicInfo
 
    
    s dicInfo = ##Class(%ArrayOfDataTypes).%New()
    d dicInfo.SetAt(dicTableName,"TableName")
    d dicInfo.SetAt(dicAliasCol,"DicAliasCol") 
    d dicInfo.SetAt(dicCodeCol,"DicCodeCol") 
    d dicInfo.SetAt(dicDescCol,"DicDescCol") 
    
    q dicInfo
}

/// Create: 2008-11-27  HouJ
/// Desc:   查询【科室】字典内容：SQLUser.CT_Loc
/// Input：  AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicCTLoc(AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String) As %Integer
{
    //结果行总数
    s totRowCount = 0
    
    //开始查询
    s rowid = 0
    for {
        s rowid=$o(^CTLOC(rowid))
        quit:(rowid = "")
        
        s ret = ##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).CheckCTLocType(rowid)
        if (ret = "0")
        {
            continue    
        }
        
        //取代码列,描述列,别名列
        if ($zcvt(ADicCodeCol,"U") = "CTLOC_CODE")
        {   s CodeValue=$p($g(^CTLOC(rowid)),"^",1)}
        elseif ($zcvt(ADicCodeCol,"U") = "CTLOC_ROWID")
        {   s CodeValue=rowid}
        
        s DescValue=$p($g(^CTLOC(rowid)),"^",2)
        
        s AliasValue=""
        if ($zcvt(ADicAliasCol,"U") = "CTLOC_CONTACTNAME")
        {   s AliasValue = $p($g(^CTLOC(rowid)),"^",43)}
        
        //是否满足查询条件
        s CodeCom=0, DescCom=0, AliasCom=0
        if (AComItem '= "")
        {   
            
            s CodeCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
            S DescCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
            if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
            {   s AliasCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
            
            if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
            {   continue}
        }
        
        //处理满足条件的结果并存入临时global
        s totRowCount = totRowCount + 1
        if (AIsKeepMinus = "0")
        {   s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
        s ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(totRowCount,AliasValue,CodeValue,DescValue)
    }
    
    s ^CacheTempStdQueryCount(ASessionId,"StdQueryDataCount")= totRowCount
    
    q totRowCount
}

}
