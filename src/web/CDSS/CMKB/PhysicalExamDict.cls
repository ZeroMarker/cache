/// Description：体格检查字典表
/// Table：CT.WDT.CDSS.PhysicalExamDict
Class web.CDSS.CMKB.PhysicalExamDict Extends %RegisteredObject
{

/// Creator：丁亚男
/// CreatDate: 2020-06-03
/// Description：查询 检查项目
/// Table：CT.WDT.CDSS.PhysicalExamDict
/// Input：rowid, desc
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.PhysicalExamDict","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, desc As %String, q As %String) As %Query(ROWSPEC = "PhysicalExamDR:%String,PhysicalExamName:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String, q As %String) As %Status
{
	
 s repid=$I(^CacheTemp)
 s ind=1
 if (rowid'="") //根据rowid返回该条记录
 {
  s PhysicalExamDR=rowid
  s PhysicalExamName=$LISTGET($G(^CT.WDT.CDSS.PhysicalExamDictD(PhysicalExamDR)),3)
  d OutputRowCmb
 }
 else
 {
	
  s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
  s:q'="" q=$ZCONVERT(q,"U") //转换成大写
  s PhysicalExamDR=""
  for{  
	  s PhysicalExamDR=$o(^CT.WDT.CDSS.PhysicalExamDictD(PhysicalExamDR),-1) q:PhysicalExamDR=""  
	  s PhysicalExamName=$LISTGET($G(^CT.WDT.CDSS.PhysicalExamDictD(PhysicalExamDR)),3)
	  s Usefalg= $lg($g(^CT.WDT.CDSS.PhysicalExamDictD(PhysicalExamDR)),10)
	  s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(PhysicalExamName)  
	  if (($ZCONVERT(PhysicalExamName,"U")[desc)||(PINYIN[desc)&(($ZCONVERT(PhysicalExamName,"U")[q)||(PINYIN[q)))&(Usefalg=2) {
	  	d OutputRowCmb
	  }
  }
 }
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb
    set Data=$lb(PhysicalExamDR,PhysicalExamName)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
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

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：钟荣枫 		
/// CreatDate: 2020-6-29
/// Description：查询 体格检查
/// Table：CT.WDT.CDSS.PhysicalExamDict
/// Input:id, code, desc,
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.PhysicalExamDict","GetList","","","","","","","","","","")
Query GetList(rowid As %String, code As %String, desc As %String, alias As %String, opername As %String, state As %String, starttime As %String, endtime As %String, remarks As %String, sortmethod As %String) As %Query(ROWSPEC = "PhysicalExamID,PhysicalExamCode,PhysicalExamName,PhysicalExamDesc,PhysicalExamExplain,PhysicalExamValue,Remarks,CreateDate,CreateUserID,UseFlag,PhysicalExamAlias")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, alias As %String, opername As %String, state As %String, starttime As %String, endtime As %String, remarks As %String, sortmethod As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s:opername'="" opername=$ZCONVERT(opername,"U") //转换成大写
	s:remarks'="" remarks=$ZCONVERT(remarks,"U") //转换成大写
	s:alias'="" alias=$ZCONVERT(alias,"U") //转换成大写
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s PhysicalExamID=rowid
		s PhysicalExamCode= $lg($g(^CT.WDT.CDSS.PhysicalExamDictD(PhysicalExamID)),2)		//体格检查编码
		s PhysicalExamName= $lg($g(^CT.WDT.CDSS.PhysicalExamDictD(PhysicalExamID)),3)		//体格检查名称
		s PhysicalExamDesc= $lg($g(^CT.WDT.CDSS.PhysicalExamDictD(PhysicalExamID)),4)		//体格检查概述
		s PhysicalExamExplain=$lg($g(^CT.WDT.CDSS.PhysicalExamDictD(PhysicalExamID)),5)		//体格检查说明
		s PhysicalExamValue=$lg($g(^CT.WDT.CDSS.PhysicalExamDictD(PhysicalExamID)),6)		//体格检查值域
		s Remarks=$lg($g(^CT.WDT.CDSS.PhysicalExamDictD(PhysicalExamID)),7)		//备注
		s CreateDate=$lg($g(^CT.WDT.CDSS.PhysicalExamDictD(PhysicalExamID)),8)		//创建时间
		s CreateUserID=$lg($g(^CT.WDT.CDSS.PhysicalExamDictD(PhysicalExamID)),9)		//创建人员
		s UseFlag=$lg($g(^CT.WDT.CDSS.PhysicalExamDictD(PhysicalExamID)),10)			//状态（0编辑中，1已弃用，2已审核）
		s PhysicalExamAlias=$lg($g(^CT.WDT.CDSS.PhysicalExamDictD(PhysicalExamID)),11)		//别名
		
		d OutputRow
	}
	else
	{
		k ^TempDataHandle($ZNAME,repid,$JOB,"Handle")
		if (sortmethod="Short")
		{
			s ID=0
			for 
			{
				s ID=$o(^CT.WDT.CDSS.PhysicalExamDictD(ID))
				q:ID=""
				s PhysicalExamDictName= $lg($g(^CT.WDT.CDSS.PhysicalExamDictD(ID)),3)		//名称
				s length=$l(PhysicalExamDictName)
				s ^TempDataHandle($ZNAME,repid,$JOB,"Handle",length,ID)=ID
			}
		}
		else
		{
			s ID=0
			for
			{
	 			s ID=$o(^CT.WDT.CDSS.PhysicalExamDictD(ID))
				q:ID=""
				s CreateDate= $lg($g(^CT.WDT.CDSS.PhysicalExamDictD(ID)),8)				//编辑时间
				s:CreateDate="" CreateDate="2021-01-01"
				s ^TempDataHandle($ZNAME,repid,$JOB,"Handle",CreateDate,ID)=ID
			}	
		}
		s le=""
		for
		{
			if (sortmethod="Short"){
				s le=$o(^TempDataHandle($ZNAME,repid,$JOB,"Handle",le)) 
			} else{
				s le=$o(^TempDataHandle($ZNAME,repid,$JOB,"Handle",le),-1) 
			}
			q:le=""
			s PhysicalExamID=0
        	for {
            
	       		s PhysicalExamID=$o(^TempDataHandle($ZNAME,repid,$JOB,"Handle",le,PhysicalExamID)) q:PhysicalExamID=""
	       		s PhysicalExamCode= $lg($g(^CT.WDT.CDSS.PhysicalExamDictD(PhysicalExamID)),2)		//体格检查编码
				s PhysicalExamName= $lg($g(^CT.WDT.CDSS.PhysicalExamDictD(PhysicalExamID)),3)		//体格检查名称
				s PhysicalExamDesc= $lg($g(^CT.WDT.CDSS.PhysicalExamDictD(PhysicalExamID)),4)		//体格检查概述
				s PhysicalExamExplain=$lg($g(^CT.WDT.CDSS.PhysicalExamDictD(PhysicalExamID)),5)		//体格检查说明
				s PhysicalExamValue=$lg($g(^CT.WDT.CDSS.PhysicalExamDictD(PhysicalExamID)),6)		//体格检查值域
				s Remarks=$lg($g(^CT.WDT.CDSS.PhysicalExamDictD(PhysicalExamID)),7)		//备注
				continue:((remarks'="")&&($ZCONVERT(Remarks,"U")'[remarks))
				s CreateDate=$lg($g(^CT.WDT.CDSS.PhysicalExamDictD(PhysicalExamID)),8)		//创建时间
				s:CreateDate="" CreateDate="2021-01-01 00:00:00"
				continue:((starttime'="")&&($ZDH(starttime,3)>$ZDH(CreateDate,3)))
        		continue:((endtime'="")&&($ZDH(endtime,3)<$ZDH(CreateDate,3)))
				s CreateUserID=$lg($g(^CT.WDT.CDSS.PhysicalExamDictD(PhysicalExamID)),9)		//创建人员
				continue:((opername'="")&&($ZCONVERT(CreateUserID,"U")'[opername))
				s UseFlag=$lg($g(^CT.WDT.CDSS.PhysicalExamDictD(PhysicalExamID)),10)			//状态（0编辑中，1已弃用，2已审核）
				s:UseFlag="" UseFlag=0
				s PhysicalExamAlias=$lg($g(^CT.WDT.CDSS.PhysicalExamDictD(PhysicalExamID)),11)		//别名
				continue:((alias'="")&&(PhysicalExamAlias'[alias))
				if (state=""){
					continue:(UseFlag="1")			
				}
				else{
					continue:((state'="")&&(UseFlag'=state))
				}
				s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(PhysicalExamName)
				if (($ZCONVERT(PhysicalExamName,"U")[desc)||(PINYIN[desc))&&($ZCONVERT(PhysicalExamCode,"U")[code)
		  		{
		  			d OutputRow
				}
			
			}
	  	}				
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PhysicalExamID,PhysicalExamCode,PhysicalExamName,PhysicalExamDesc,PhysicalExamExplain,PhysicalExamValue,Remarks,CreateDate,CreateUserID,UseFlag,PhysicalExamAlias)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)	
	k ^TempDataHandle($ZNAME,repid,$JOB,"Handle")	
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

/// Creator：钟荣枫 
/// CreatDate: 2020-6-19
/// Description：新增，修改时打开Form，根据RowId查询
/// Table:CT.WDT.CDSS.PhysicalExamDict 体格检查表
/// Input：id
/// Return：json串 
/// Other: w ##class(web.CDSS.CMKB.PhysicalExamDict).OpenData(1)
ClassMethod OpenData(id As %String) As %String
{
    s str = ""
	s pobj = ##class(CT.WDT.CDSS.PhysicalExamDict).%OpenId(id) 
	s eobj = ##class(web.CDSSEntity.CMKB.PhysicalExamDict).%New() 
	s eobj.PhysicalExamID = id

	s eobj.PhysicalExamCode= pobj.PhysicalExamCode		//体格检查编码
	s eobj.PhysicalExamName= pobj.PhysicalExamName		//体格检查名称
	s eobj.PhysicalExamName=$tr(eobj.PhysicalExamName,"	 "," ")
	s eobj.PhysicalExamDesc=pobj.PhysicalExamDesc		//体格检查概述
	s eobj.PhysicalExamDesc=$tr(eobj.PhysicalExamDesc,"	 "," ")
	s eobj.PhysicalExamExplain=pobj.PhysicalExamExplain		//体格检查说明
	s eobj.PhysicalExamExplain=$tr(eobj.PhysicalExamExplain,"	 "," ")
	s eobj.PhysicalExamValue=pobj.PhysicalExamValue		//体格检查值域
	s eobj.Remarks=pobj.Remarks		//备注
	s eobj.PhysicalExamAlias=pobj.PhysicalExamAlias		//别名
	
	kill pobj
	s str = eobj.JsonS()
	q str
}

/// Creator:丁亚男
/// CreatDate:2020-08-19
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// 目前没有引用手术的表、病因等用到但是保存的是手术名称，不影响
/// w ##class(web.CDSS.CMKB.PhysicalExamDict).GetRefFlag("97")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""
    s flag=0
    s count=0
    if ($d(^User.DHCDSSDiseJoinPhysicalEI("PhysicalExamDRIndex",id)))
    {
	    s PhysicalEID=0
	    for
	    {
	        s PhysicalEID=$o(^User.DHCDSSDiseJoinPhysicalEI("PhysicalExamDRIndex",id,PhysicalEID)) q:(PhysicalEID="")
            s DiseaseDR=$lg($g(^User.DHCDSSDiseJoinPhysicalED(PhysicalEID)),2)
            s DiseaseName=""
            s:DiseaseDR'="" DiseaseName=$lg($g(^User.DHCDSSDiseaseDictD(DiseaseDR)),3)
            s flag=1
            s count=count+1
            //s myInfo=myInfo_"<诊断知识库:"_DiseaseName_"-关联体格检查>"
	        if (count>3)
            {
	            s myInfo=myInfo_"..."
	            q
            }
            else
            {
	            s myInfo=myInfo_"<诊断知识库:"_DiseaseName_"-关联体格检查>"
            }
	    }
    }
    if ($d(^User.DHCDSSDiseJoinExamI("ExamLabDRIndex",0,id)))
    {
	    s DiseJoinExamID=0
	    for
	    {
	        s DiseJoinExamID=$o(^User.DHCDSSDiseJoinExamI("ExamLabDRIndex",0,id,DiseJoinExamID)) 
	        q:(DiseJoinExamID="")
	        s DiseaseDR=$lg($g(^User.DHCDSSDiseJoinExamD(DiseJoinExamID)),2)
            s DiseaseName=""
            s:DiseaseDR'="" DiseaseName=$lg($g(^User.DHCDSSDiseaseDictD(DiseaseDR)),3)
            s flag=1
            s count=count+1
            
	        if (count>3)
            {
	            s myInfo=myInfo_"..."
	            q
            }
            else
            {
	            s myInfo=myInfo_"<诊断知识库:"_DiseaseName_"-关联辅助检查检验>"
            }
	    }
    }
    //识别词项目引用接口
    s PhysicalExamName=$lg($g(^CT.WDT.CDSS.PhysicalExamDictD(id)),3)
    s IWordsStr=##class(web.CDSS.CMKB.WordsCondition).GetRefFlag("体格检查名称",PhysicalExamName)
    if IWordsStr'="" s myInfo=myInfo_IWordsStr
    //同步修改识别词项目数据
    //d:eobj.RowId'="" ##class(web.CDSS.CMKB.WordsCondition).SynchroDictWord("诊断名称",eobj.DiseaseName,bobj.DiseaseName)
    
    //诊疗规则引用接口 
    s Exist =##class(web.DHCBL.BDP.FunLib).IsValidMethodName("web.CDSS.CMKB.RuleTrigger","GetQuoteFlag")
	s ExistChild =##class(web.DHCBL.BDP.FunLib).IsValidMethodName("web.CDSS.CMKB.ChildRuleTrigger","GetQuoteFlag")
	if (Exist="1"&&ExistChild="1"){
		s RuleTriggerFlag=##class(web.CDSS.CMKB.RuleTrigger).GetQuoteFlag("体格检查",PhysicalExamName) //被诊疗规则引用判断
		s ChildRuleTriggerFlag=##class(web.CDSS.CMKB.ChildRuleTrigger).GetQuoteFlag("体格检查",PhysicalExamName) //被诊疗子规则引用判断
		if ((RuleTriggerFlag=1)||(ChildRuleTriggerFlag=1))
		{
			s myInfo=myInfo_"<诊疗规则关联触发条件表>"
		}
	}
    
    i myInfo="" s return="0^未被引用可删除!"
    else  s return="1^在"_myInfo_"表里被引用,不能删除!"
    q return
}

/// Creator：钟荣枫 
/// CreatDate: 2020-6-29
/// Description：根据id删除 体格检查
/// Table:CT.WDT.CDSS.PhysicalExamDict 体格检查表
/// Input：id 
/// Return：成功返回true，失败返回false和info
/// Other: w ##class(web.CDSS.CMKB.PhysicalExamDict).DeleteData(1)
ClassMethod DeleteData(id) As %String
{
	s result=""
	s re=##class(web.CDSS.CMKB.PhysicalExamDict).GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag'=0){
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    }
    else
    {
		s pobj = ##class(CT.WDT.CDSS.PhysicalExamDict).%OpenId(id) 
		s eobj = ##class(web.CDSSEntity.CMKB.PhysicalExamDict).%New() 

		s eobj.PhysicalExamCode= pobj.PhysicalExamCode		//体格检查编码
		s eobj.PhysicalExamName= pobj.PhysicalExamName		//体格检查名称
		s eobj.PhysicalExamDesc=pobj.PhysicalExamDesc		//体格检查概述
		s eobj.PhysicalExamExplain=pobj.PhysicalExamExplain		//体格检查说明
		s eobj.PhysicalExamValue=pobj.PhysicalExamValue		//体格检查值域
		s eobj.Remarks=pobj.Remarks		//备注
		s eobj.CreateDate=pobj.CreateDate		//创建时间
		s eobj.CreateUserID=pobj.CreateUserID		//创建人员
		s eobj.UseFlag=pobj.UseFlag			//状态
		s eobj.PhysicalExamAlias=pobj.PhysicalExamAlias		//别名
		
		d pobj.%Close()
		kill pobj
		Tstart
		s sc=##class(CT.WDT.CDSS.PhysicalExamDict).%DeleteId(id)
		IF $$$ISOK(sc)
		{
			Tc
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.PhysicalExamDict","CT.WDT.CDSS.PhysicalExamDict","体格检查",id,eobj.PhysicalExamName,"D",eobj)
		    //删除别名通用表中数据 2021-11-05 GXP
            d ##class(web.CDSS.CMKB.Alias).DeleteAlias("CT.WDT.CDSS.PhysicalExamDict",id)
		}
		else
		{
			Trollback
			s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("体格检查","web.CDSS.CMKB.PhysicalExamDict","DeleteData",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
    }
	q result
}

/// Creator:钟荣枫 
/// CreatDate:2020-6-29
/// Description:数据重复验证方法,js调用
/// Table:CT.WDT.CDSS.PhysicalExamDict 体格检查表
/// Input:id, code
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.CDSS.CMKB.PhysicalExamDict).FormValidate("",,"身高")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	s flag=0
    if ($ZCONVERT(desc,"U")'="")	//校验名称重复
    {
        s idd=0
        for
        {
            s idd=$o(^CT.WDT.CDSS.PhysicalExamDictI("NameIndex"," "_$ZCONVERT(desc,"U"),idd)) q:idd=""
            if (idd'=id)	//重复
            {
				s flag=1
            }
        }
    }
    if ($ZCONVERT(code,"U")'="")	//校验名称重复
    {
        s idc=0
        for
        {
            s idc=$o(^CT.WDT.CDSS.PhysicalExamDictI("CodeIndex"," "_$ZCONVERT(code,"U"),idc)) q:idc=""
            if (idc'=id)	//重复
            {
				s flag=1
            }
        }
    }
    q flag
}

/// Creator:赵文伟
/// CreateDate:2023-03-09   
/// Description:校验别名【新增别名与表中所有名称及别名重复校验】
/// w ##class(web.CDSS.CMKB.PhysicalExamDict).ValidateAlias("","")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod ValidateAlias(id As %String, name As %String, aliasStr As %String) As %String
{
	s flag=0
	s len = $l(aliasStr,",")
	for i=1:1:len
	{
		s Alias=$p(aliasStr,",",i)
		if (Alias="") continue  //别名为空，则跳过
		if (Alias=name)
		{
			s flag=1  //如果别名=名称，则数据重复
			q
		}
		
		s Alias=" "_$ZCONVERT(Alias,"U") //别名转换成大写
	    s flagA="",flagN=""
	    s flagA=$d(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.PhysicalExamDict",Alias))
	    s flagN=$d(^CT.WDT.CDSS.PhysicalExamDictI("NameIndex",Alias))
	    if (id="")	//如果为空，增加时的重复判断
	    {
	        if ((flagA>0)||(flagN>0)) 
	        {
		        s flag=1  //返回重复标志
		        q
	        }
	    }
	    else 	//如果不为空，修改时的重复判断
	    {
	        s idA="",idN=""
	        s idA=$o(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.PhysicalExamDict",Alias,0))	//用别名表中别名数据校验别名重复
	        s idN=$o(^CT.WDT.CDSS.PhysicalExamDictI("NameIndex",Alias,0))  						//字典表的名称来校验别名重复
	        if ((idA'="")&(idA'=id)&(flagA>0))||((flagN'="")&(idN'=id)&(flagN>0))
	        {
		         s flag=1  //返回重复标志
		         q
	        }
	    }
	}
	q flag
}

/// Creator:钟荣枫 
/// CreatDate: 2020-6-29
/// Description：保存 体格检查表 
/// Input: eobj As web.CDSSEntity.CMKB.PhysicalExamDict
/// Table:CT.WDT.CDSS.PhysicalExamDict 体格检查表
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.CDSS.CMKB.PhysicalExamDict).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.PhysicalExamDict) As %String
{
	s $zt="ERROE"
	s result=""
	if $IsObject(eobj)
	{	
		
		s flagAlias=..ValidateAlias(eobj.PhysicalExamID,eobj.PhysicalExamName,eobj.PhysicalExamAlias)		//调用别名重复验证
		if (flagAlias=1)
		{
			q "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}"
		}
		if (eobj.PhysicalExamID="")	//新增
		{	
	        s obj=##class(CT.WDT.CDSS.PhysicalExamDict).%New()
		}
		else	//修改
		{
			s obj=##class(CT.WDT.CDSS.PhysicalExamDict).%OpenId(eobj.PhysicalExamID)
			s bobj = ##class(web.CDSSEntity.CMKB.PhysicalExamDict).%New()
			s bobj.PhysicalExamID = eobj.PhysicalExamID
			
			s bobj.PhysicalExamCode= obj.PhysicalExamCode		//体格检查编码
			s bobj.PhysicalExamName= obj.PhysicalExamName		//体格检查名称
			s bobj.PhysicalExamDesc=obj.PhysicalExamDesc		//体格检查概述
			s bobj.PhysicalExamExplain=obj.PhysicalExamExplain		//体格检查说明
			s bobj.PhysicalExamValue=obj.PhysicalExamValue		//体格检查值域
			s bobj.Remarks=obj.Remarks		//备注
			s bobj.CreateDate=obj.CreateDate		//创建时间
			s bobj.CreateUserID=obj.CreateUserID	//创建人员
			s bobj.UseFlag=obj.UseFlag				//状态
			s bobj.PhysicalExamAlias=obj.PhysicalExamAlias		//别名
						
		}
		
		s obj.PhysicalExamCode= eobj.PhysicalExamCode		//体格检查编码
		s obj.PhysicalExamName= eobj.PhysicalExamName		//体格检查名称
		s obj.PhysicalExamDesc=eobj.PhysicalExamDesc		//体格检查概述
		s obj.PhysicalExamExplain=eobj.PhysicalExamExplain		//体格检查说明
		s obj.PhysicalExamValue=eobj.PhysicalExamValue		//体格检查值域
		s obj.Remarks=eobj.Remarks		//备注
		//s obj.CreateDate=eobj.CreateDate	//创建时间
		//s obj.CreateUserID=eobj.CreateUserID		//创建人员
		s eobj.CreateUserID=$g(%session.Data("LOGON.USERNAME"))					//编辑人员
		s obj.CreateUserID=eobj.CreateUserID
		s eobj.CreateDate=$ZDATETIME($H,3)						//编辑时间
		s obj.CreateDate=eobj.CreateDate
		
		s obj.UseFlag=eobj.UseFlag		//状态  
		s obj.PhysicalExamAlias=eobj.PhysicalExamAlias		//状态
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.PhysicalExamID="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.PhysicalExamDict","CT.WDT.CDSS.PhysicalExamDict","体格检查",id,eobj.PhysicalExamName,"A",eobj)
			d:eobj.PhysicalExamID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.PhysicalExamDict","CT.WDT.CDSS.PhysicalExamDict","体格检查",id,eobj.PhysicalExamName,"U",eobj,bobj)
			//同步修改识别词项目数据
            d:eobj.PhysicalExamID'="" ##class(web.CDSS.CMKB.WordsCondition).SynchroDictWord("体格检查名称",eobj.PhysicalExamName,bobj.PhysicalExamName)
		    //如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表  2021-11-05 GXP
            if ((eobj.PhysicalExamID="")&&(eobj.PhysicalExamAlias'=""))||((eobj.PhysicalExamID'="")&&(eobj.PhysicalExamAlias'=bobj.PhysicalExamAlias))
            {
            	d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.PhysicalExamDict",id,eobj.PhysicalExamAlias)
            } 
            
		}
		else
		{
			Trollback
			s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("体格检查","web.CDSS.CMKB.PhysicalExamDict","SaveData",eobj)
    		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
		}	
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
ERROE
	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("体格检查字典表","web.CDSS.CMKB.PhysicalExamDict","SaveData",eobj)
 	s ^ERRORLOGINFO(logid)=$ze
}

/// Creator:钟荣枫
/// CreatDate:2020-6-17
/// Description:代码自动生成  
/// Input：
/// Return： code
/// Other:w ##class(web.CDSS.CMKB.PhysicalExamDict).GetCode()
ClassMethod GetCode() As %String
{
  	s Code=""
  	s PhysicalExamID=0
	/*for 
	{
		s PhysicalExamID=$o(^CT.WDT.CDSS.PhysicalExamDictD(PhysicalExamID))
		q:PhysicalExamID=""
		s Code=PhysicalExamID
		
	}*/
	s Code=$o(^CT.WDT.CDSS.PhysicalExamDictD(""),-1)
	
	if (Code="")
	{
		s:Code="" Code="01631"
	}
	else
	{
		s Code=##class(web.DHCBL.BDP.FunLib).AddZEROToStr(Code+1,5)	//补0
		//s Code="PE"_Code
	}
  
	q Code
}

/// Creator：xuwenhu
/// CreatDate: 2021-02-19
/// Description:状态修改
/// Input:id useflag(0编辑中,1已弃用,2已审核)
/// Table：CT.WDT.CDSS.PhysicalExamDict
/// Other: w ##class(web.CDSS.CMKB.PhysicalExamDict).UpdateUseFlag(3364,"通过")
ClassMethod UpdateUseFlag(id, Operation) As %String
{
	s result=""
	s eobj = ##class(web.CDSSEntity.CMKB.PhysicalExamDict).%New()
	//"0":"编辑中","1":"已弃用","2":"已审核"
	//s:useflag="2" eobj.UseFlag="2"	//已审核
	//s:useflag="1" eobj.UseFlag="1"	//已弃用
	//s:useflag="0" eobj.UseFlag="0"	//编辑中
	//s:useflag="0" eobj.UseFlag="0"	//编辑中
	s:Operation="通过" eobj.UseFlag="2"	//已审核
	s:Operation="弃用" eobj.UseFlag="1"	//已弃用
	s:Operation="恢复" eobj.UseFlag="0"	//编辑中
	s:Operation="驳回" eobj.UseFlag="0"	//编辑中
	s eobj.CreateDate=$zdt($h,3)
	if ($d(%session)) {s eobj.CreateUserID=$g(%session.Data("LOGON.USERNAME"))}
	
	s obj=##class(CT.WDT.CDSS.PhysicalExamDict).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.PhysicalExamDict).%New() 
	s bobj.UseFlag=obj.UseFlag
	s bobj.CreateDate=obj.CreateDate
	s bobj.CreateUserID=obj.CreateUserID
		
	s obj.UseFlag=eobj.UseFlag
 	s obj.CreateDate=eobj.CreateDate
 	s obj.CreateUserID=eobj.CreateUserID
	Ts
 	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{
		Tc
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
		//状态改为已审核时识别词新增已拆分数据  Add By ZWW 2023-05-05 
		if (obj.UseFlag= "2"){ 
	        s lineI=obj.PhysicalExamName_",识别条件,主要条件-识别词,1,体格检查名称,"_obj.PhysicalExamName_",0"
	        d ##class(web.CDSS.CMKB.ImportViewRules).SaveIdentifyWordsInfo(lineI)
		}
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.PhysicalExamDict","CT.WDT.CDSS.PhysicalExamDict","体格检查字典表",id,obj.PhysicalExamDesc_"&&"_Operation,"U",eobj,bobj)	
	}
	else
	{
		Trollback
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		
	}
	q result
}

/// Creator:xuwenhu
/// CreatDate:2021-02-19
/// Description：导出体格检查字典表数据
/// Other:w ##class(web.CDSS.CMKB.PhysicalExamDict).ExportPhysicalData("","","","","","","","")
ClassMethod ExportPhysicalData(code As %String, desc As %String, opername As %String, state As %String, starttime As %String, endtime As %String, remarks As %String, alias As %String)
{
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	/*s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName=time_"体格检查字典数据.txt"
	s file=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\DataExport\"_fileName*/
	
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"体格检查字典数据.txt"		
	s file=""			 	;key转放到web目录下
	if (Path["\"){
		s DirName = Path_"scripts\bdp\CDSS\DataExport\"
		s file=Path_"scripts\bdp\CDSS\DataExport\"_fileName
	}else{
		s DirName = Path_"scripts/bdp/CDSS/DataExport/"
		s file=Path_"scripts/bdp/CDSS/DataExport/"_fileName
	}
	if '##class(%File).DirectoryExists(DirName){d ##class(%File).CreateDirectoryChain(DirName)}
	
	
	o file:"NWS"
	u file
	w "体格检查编码	体格检查名称	操作人	操作时间	备注	状态	别名"
	
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	s:opername'="" opername=$ZCONVERT(opername,"U") //转换成大写 
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s:alias'="" alias=$ZCONVERT(alias,"U") //转换成大写 
	s PhysicalExamID=0
	for
	{
		s PhysicalExamID=$o(^CT.WDT.CDSS.PhysicalExamDictD(PhysicalExamID))
		q:PhysicalExamID=""
		s PhysicalExamCode= $lg($g(^CT.WDT.CDSS.PhysicalExamDictD(PhysicalExamID)),2)		//体格检查编码
		s PhysicalExamName= $lg($g(^CT.WDT.CDSS.PhysicalExamDictD(PhysicalExamID)),3)		//体格检查名称
		s PhysicalExamDesc= $lg($g(^CT.WDT.CDSS.PhysicalExamDictD(PhysicalExamID)),4)		//体格检查概述
		s PhysicalExamExplain=$lg($g(^CT.WDT.CDSS.PhysicalExamDictD(PhysicalExamID)),5)		//体格检查说明
		s PhysicalExamValue=$lg($g(^CT.WDT.CDSS.PhysicalExamDictD(PhysicalExamID)),6)		//体格检查值域
		s Remarks=$lg($g(^CT.WDT.CDSS.PhysicalExamDictD(PhysicalExamID)),7)		//备注
		continue:((remarks'="")&&($ZCONVERT(Remarks,"U")'[remarks))
		s CreateDate=$lg($g(^CT.WDT.CDSS.PhysicalExamDictD(PhysicalExamID)),8)		//创建时间
		continue:((starttime'="")&&($ZDH(starttime,3)>$ZDH(CreateDate,3)))
        continue:((endtime'="")&&($ZDH(endtime,3)<$ZDH(CreateDate,3)))
		s CreateUserID=$lg($g(^CT.WDT.CDSS.PhysicalExamDictD(PhysicalExamID)),9)		//创建人员
		continue:((opername'="")&&($ZCONVERT(CreateUserID,"U")'[opername))
		s UseFlag=$lg($g(^CT.WDT.CDSS.PhysicalExamDictD(PhysicalExamID)),10)			//状态（0编辑中，1已弃用，2已审核）
		if (state=""){
			continue:(UseFlag="1")			
		}
		else{
			continue:((state'="")&&(UseFlag'=state))
		}
		s UseFlag=$case(UseFlag,0:"编辑中",1:"已删除",2:"已审核",:"编辑中")
		s PhysicalExamAlias=$lg($g(^CT.WDT.CDSS.PhysicalExamDictD(PhysicalExamID)),11)		//别名
		continue:((alias'="")&&($ZCONVERT(PhysicalExamAlias,"U")'[alias))
			
		s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(PhysicalExamName)
		if (($ZCONVERT(PhysicalExamName,"U")[desc)||(PINYIN[desc))&&($ZCONVERT(PhysicalExamCode,"U")[code)
		{
			w !,PhysicalExamCode_"	"_PhysicalExamName_"	"_CreateUserID_"	"_CreateDate_"	"_Remarks_"	"_UseFlag_"	"_PhysicalExamAlias
		}
	}
	
	c file
	q fileName
}

/// Creator：xuwenhu
/// CreatDate: 2021-05-07
/// Description: 批量处理数据，将代码更改为纯数字递增
/// Input:
/// Table：CT.WDT.CDSS.PhysicalExamDict
/// Other: w ##class(web.CDSS.CMKB.PhysicalExamDict).BatchChangeCode()
ClassMethod BatchChangeCode() As %String
{
	s ID=0
	s code=0
	s count=0 		//总处理数
	s failcount=0	//失败数
	for
	{
		s ID=$o(^CT.WDT.CDSS.PhysicalExamDictD(ID))
		q:ID=""
		s code=code+1
		s obj=##class(CT.WDT.CDSS.PhysicalExamDict).%OpenId(ID)
		s obj.PhysicalExamCode=##class(web.DHCBL.BDP.FunLib).AddZEROToStr(code,5)
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			s count=count+1
		}
		else{
			s failcount=failcount+1
		}
	}
	q "总处理"_count_"条,失败"_failcount_"条"
}

/// Creator：胡宜良 
/// CreatDate: 2021-10-18
/// Description：批量通过
/// Table：CT.WDT.CDSS.PhysicalExamDict
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.CMKB.PhysicalExamDict).BatchConfirm()
ClassMethod BatchConfirm(idstr As %String, hosp As %String, type As %String)
{
	s result=""
	s errorfalg=0
	s total=$l(idstr,",")
	
	q:idstr="" "false"
	TS
	if (total>=1)
	{
		for m=1:1:total
		{
			s ConID=$p(idstr,",",m)
			s re= ..UpdateUseFlag(ConID,"通过")
			s:re["false" errorfalg=errorfalg+1
		}
		
	}
	if (errorfalg'=0)
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

/// Creator：胡宜良 
/// CreatDate: 2021-10-18
/// Description：批量驳回
/// Table：CT.WDT.CDSS.PhysicalExamDict
/// Input： 
/// Return：
/// Other: w ##class(web.CDSS.CMKB.PhysicalExamDict).BatchCancel()
ClassMethod BatchCancel(idstr As %String, hosp As %String, type As %String)
{
	s result=""
	s errorfalg=0
	s total=$l(idstr,",")
	
	q:idstr="" "false"
	TS
	if (total>=1)
	{
		for m=1:1:total
		{
			s ConID=$p(idstr,",",m)
			s re= ..UpdateUseFlag(ConID,"驳回")
			s:re["false" errorfalg=errorfalg+1
		}
		
	}
	if (errorfalg'=0)
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

/// Creator:胡宜良
/// CreatDate:2021-11-10
/// Description:获得别名列表
/// Table：CT.WDT.CDSS.PhysicalExamDict
/// Input: id
/// Return:返回别名列表
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.PhysicalExamDict","GetAliasList","1700")
Query GetAliasList(id) As %Query(ROWSPEC = "Desc")
{
}

ClassMethod GetAliasListExecute(ByRef qHandle As %Binary, id) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	if (id'=""){
		
		s SPhysicalExamAlias=$LISTGET($G(^CT.WDT.CDSS.PhysicalExamDictD(id)),11)
		s Len=$Length(SPhysicalExamAlias,",")
		for i=1:1:Len{
			s Desc=$p(SPhysicalExamAlias,",",i)
			continue:(Desc="")
			d OutputRowKeyWords
		}
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowKeyWords
	set Data=$lb(Desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAliasListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAliasListExecute ]
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

ClassMethod GetAliasListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAliasListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:胡宜良
/// CreatDate:2021-11-30
/// Description：导入体格检查字典
/// Table：CT.WDT.CDSS.PhysicalExamDict
/// Input：
/// Output：
/// Other: w ##class(web.CDSS.CMKB.PhysicalExamDict).ImportDataTXT("D:\Works\PhysicalExamDict.txt")
ClassMethod ImportDataTXT(path) As %String
{
	
	s savecount=0
	s nosavecount=0
	s linksavecount=0
	s updatecount=0
	s continuecount=0
	s timecontinuecount=0
	s id=0
	
	Set path1 = ##Class(%File).NormalizeFilename(path) //获取当前路径 D
	if '##class(%File).Exists(path1) 
	{
   		q "文件不存在"
    }
    Set file=##class(%File).%New(path)

	d file.Open("R")
	
	s TheType=""
	s TheHosp=""
	s TheMarkFlag=""
	
	s num=0
	k myFileAry
	for i=1:1:file.Size 
	{
		s data=file.Read()
		q:data=""
		s num=num+1
		continue:num=1  //跳过第一行
		s myFileAry(i)=data
		//s PhysicalExamID= $p(data,$c(9),1) 
		s PhysicalExamCode= $p(data,$c(9),2)       //体格检查编码
		s PhysicalExamName= $p(data,$c(9),3)       //体格检查编码
		s PhysicalExamAlias= $p(data,$c(9),4)      //别名
		
		s ID=$o(^CT.WDT.CDSS.PhysicalExamDictI("CodeIndex"," "_PhysicalExamCode,0))
		s eobj = ##class(web.CDSSEntity.CMKB.PhysicalExamDict).%New()
		s eobj.PhysicalExamID = ID
		s eobj.PhysicalExamCode = PhysicalExamCode		
		s eobj.PhysicalExamName = PhysicalExamName	             	
		s eobj.PhysicalExamAlias = PhysicalExamAlias					
		
		s eobj.CreateUserID = "dhcc"
		s eobj.CreateDate = $ZDATETIME($HOROLOG,3)	
		s eobj.UseFlag = 0	
		s eobj.Remarks = ""					
			
		
		s result=..SaveData(eobj)

		if ((result'["false"))
		{
			s savecount=savecount+1		
		}
		else
		{
			s nosavecount=nosavecount+1
		}
	}
	close file
    k file
	w "读取数据总共"_(num-1)_"条",!
	w "savecount："_savecount,!
	w "nosavecount:"_nosavecount,!
	q "{success:'true'}"
}

/// Creator:胡宜良 
/// CreatDate: 2022-01-21
/// Description：别名数据转存到别名通用表中
/// Table：CT.WDT.CDSS.PhysicalExamDict
/// Other: w ##class(web.CDSS.CMKB.PhysicalExamDict).TransferAliasData() 
ClassMethod TransferAliasData() As %String
{
	s RowId=0
	s count=0
	for
	{
		s RowId=$o(^CT.WDT.CDSS.PhysicalExamDictD(RowId))
		q:RowId=""
		s Alias= $lg($g(^CT.WDT.CDSS.PhysicalExamDictD(RowId)),11)        
		if Alias'=""
		{
			//s Alias=$replace(Alias,"，",",")
			d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.PhysicalExamDict",RowId,Alias)
			s count=count+1
		}	 	
	}
	q "success!savecount:"_count
}

/// Creator:胡宜良 
/// CreatDate: 2022-01-24
/// Description：数据统计方法
/// Table:CT.WDT.CDSS.PhysicalExamDict
/// Output: 总数据量^编辑中的数据量^已审核的数据量(审核通过+已上线)^待审核的数据量
/// Other: w ##class(web.CDSS.CMKB.PhysicalExamDict).CountData() 
ClassMethod CountData() As %String
{
	s RowId=0
	s totalcount=0		//总数据量
	s editcount=0		//编辑中的数据量
	s auditcount=0		//已审核的数据量
	s unauditcount=0	//待审核的数据量
	for
	{
		s RowId=$o(^CT.WDT.CDSS.PhysicalExamDictD(RowId))
		q:RowId=""
		s totalcount=totalcount+1
		s UseFlag = $lg($g(^CT.WDT.CDSS.PhysicalExamDictD(RowId)),10)       
		if (UseFlag'="")
		{
			if (UseFlag=0){
				s editcount=editcount+1
			} elseif (UseFlag=2){
				s auditcount=auditcount+1
			}
		}
		s totalcount=editcount+auditcount	 	
	}
	q totalcount_"^"_editcount_"^"_auditcount_"^"_unauditcount
}

/// Creator:胡宜良
/// CreatDate:2022-11-16
/// Description:根据ID获取状态变化的日志
/// Table: CF.WDT.CDSS.DataChangeLog
/// Input: ID
/// Return:返回ID获取该数据的状态变化的日志
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.PhysicalExamDict","GetLogList","524")
Query GetLogList(RowId As %String) As %Query(ROWSPEC = "LogID,CreateDate,UpdateTime,CreateUserIDName,Operation")
{
}

ClassMethod GetLogListExecute(ByRef qHandle As %Binary, RowId As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s str=""
 	if (RowId'="")
 	{
		s LogID=""
	    for
	    {
	    	s LogID=$o(^CF.WDT.CDSS.DataChangeLogI("ObjectReferIndex","CT.WDT.CDSS.PhysicalExamDict",RowId,LogID),-1) q:LogID=""
	    	s CreateUserIDName=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(LogID)),7)
	    	s CreateDate=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(LogID)),8)
	    	s CreateDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(CreateDate)
          	s UpdateTime=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(LogID)),9)
          	s UpdateTime=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(UpdateTime)
          	
          	s ObjectDesc=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(LogID)),13)   //新增对象描述
          	b ;1
          	if (ObjectDesc["&&")
          	{
	          	s Operation=$p(ObjectDesc,"&&",2)
          	}
         	else
         	{
          		s Operation="编辑"
         	}
         	d OutputRowLog
	    }
	    
	}
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowLog
	set Data=$lb(LogID,CreateDate,UpdateTime,CreateUserIDName,Operation)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetLogListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLogListExecute ]
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

ClassMethod GetLogListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLogListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：胡宜良
/// CreatDate: 2023-02-08
/// Description：修正数据保存方法
/// Table： CT.WDT.CDSS.PhysicalExamDict
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.PhysicalExamDict).SaveAmendData()
ClassMethod SaveAmendData(eobj As web.CDSSEntity.CMKB.PhysicalExamDict) As %String
{
	
	s result=""
	if $IsObject(eobj)
	{ 
		
		s flagAlias=..ValidateAlias(eobj.PhysicalExamID,eobj.PhysicalExamName,eobj.PhysicalExamAlias)		//调用别名重复验证
		if (flagAlias=1)
		{
			q "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}"
		}
		if (eobj.PhysicalExamID="")  //如果RowId未赋值则增加
		{ 
			s obj=##class(CT.WDT.CDSS.PhysicalExamDict).%New() 
		}
		else   //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.PhysicalExamDict).%OpenId(eobj.PhysicalExamID)
			s bobj = ##class(web.CDSSEntity.CMKB.PhysicalExamDict).%New()
			s bobj.PhysicalExamName=obj.PhysicalExamName          //修改描述
            s bobj.CreateUserID=obj.CreateUserID
            s bobj.CreateDate=obj.CreateDate
            s bobj.PhysicalExamAlias=obj.PhysicalExamAlias
			
		}
		
		s obj.PhysicalExamName = eobj.PhysicalExamName          //修改描述
        s eobj.CreateUserID =$g(%session.Data("LOGON.USERNAME"))
        s obj.CreateUserID =eobj.CreateUserID
        s eobj.CreateDate=$ZDATETIME($HOROLOG,3)
        s obj.CreateDate= eobj.CreateDate
        s obj.PhysicalExamAlias=eobj.PhysicalExamAlias
        
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" 
			d:eobj.PhysicalExamID="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.PhysicalExamDict","CT.WDT.CDSS.PhysicalExamDict","体格检查",id,eobj.PhysicalExamName,"A",eobj)
			d:eobj.PhysicalExamID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.PhysicalExamDict","CT.WDT.CDSS.PhysicalExamDict","体格检查",id,eobj.PhysicalExamName,"U",eobj,bobj)
			//同步修改识别词项目数据
            d:eobj.PhysicalExamID'="" ##class(web.CDSS.CMKB.WordsCondition).SynchroDictWord("体格检查名称",eobj.PhysicalExamName,bobj.PhysicalExamName)
		    //如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表  2021-11-05 GXP
            if ((eobj.PhysicalExamID="")&&(eobj.PhysicalExamAlias'=""))||((eobj.PhysicalExamID'="")&&(eobj.PhysicalExamAlias'=bobj.PhysicalExamAlias))
            {
            	d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.PhysicalExamDict",id,eobj.PhysicalExamAlias)
            } 
		}
		else
		{
			Trollback
			s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("体格检查","web.CDSS.CMKB.PhysicalExamDict","SaveData",eobj)
    		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"  
	} 
	q result
ERROR
	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("体格检查字典表","web.CDSS.CMKB.PhysicalExamDict","SaveData",eobj)
 	s ^ERRORLOGINFO(logid)=$ze
	q result= "{success:'false',errorinfo:'保存失败！'}"
}

}
