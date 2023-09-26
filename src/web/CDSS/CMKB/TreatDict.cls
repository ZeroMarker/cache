/// 名称:治疗方案字典表 
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 - 阚延新
/// 编写日期:2021-1-7
Class web.CDSS.CMKB.TreatDict Extends %RegisteredObject
{

/// Creator：阚延新	
/// Editor: 赵文伟
/// CreatDate: 2021-10-28
/// Description：查询 
/// Table:CT.WDT.CDSS.TreatDict治疗方案字典表
/// Input:id, code,desc
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.TreatDict","GetList","","","","","","","1","","","UpdateDate")
Query GetList(rowid As %String, desc As %String, alias As %String, RDesc, DName, state, UUser, timescope, sortmethod As %String) As %Query(ROWSPEC = "ID,TreatCode,TreatDesc,TreatAlias,UseFlag,UpdateUser,UpdateDate,Remarks,RuleDescStr,DiagNamestr")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, desc As %String, alias As %String, RDesc, DName, state, UUser, timescope, sortmethod As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s ID=rowid
		s TreatCode= $lg($g(^CT.WDT.CDSS.TreatDictD(ID)),2)      //治疗方案代码
		s TreatDesc= $lg($g(^CT.WDT.CDSS.TreatDictD(ID)),3)      //治疗方案名称
		s ResultRowId=0,RuleDescStr="",DiagNamestr=""
		for
		{
			s ResultRowId = $o(^CT.WDT.CDSS.RuleResultI("TypeResultIndex","治疗方案",ID,ResultRowId)) q:ResultRowId=""
			s NodeDR=$lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),2)
			continue:(NodeDR="")
			s RuleDR=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),2)
			s FlowChartNum=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),3)
			s RuleDesc=""
			continue:(RuleDR="")
			s RuleDesc=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleDR)),3)
			s:RuleDescStr'="" RuleDescStr=RuleDescStr_","_RuleDesc
			s:RuleDescStr="" RuleDescStr=RuleDesc
			s NodeRowId=0
			for
			{
				s NodeRowId = $o(^CT.WDT.CDSS.RuleNodeI("RuleDRTypeIndex",RuleDR,FlowChartNum,"诊断条件",NodeRowId)) q:NodeRowId=""
				s ConditionRowId = 0
				for
				{
					s ConditionRowId = $o(^CT.WDT.CDSS.RuleConditionI("NodeDRIndex",NodeRowId,ConditionRowId)) q:ConditionRowId=""
					s ConditionItemValue  = $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowId)),6)
					s:DiagNamestr'="" DiagNamestr=DiagNamestr_","_ConditionItemValue
					s:DiagNamestr="" DiagNamestr=ConditionItemValue
				}
			}
		}
	    s UseFlag= $lg($g(^CT.WDT.CDSS.TreatDictD(ID)),4)        //使用标志（0已审核，1编辑中）
	    s:UseFlag="" UseFlag=0
	     
	    s UpdateUser= $lg($g(^CT.WDT.CDSS.TreatDictD(ID)),5) 	//编辑人员
	    s UpdateDate= $lg($g(^CT.WDT.CDSS.TreatDictD(ID)),6)     //编辑时间
	    s Remarks= $lg($g(^CT.WDT.CDSS.TreatDictD(ID)),7)        //备注
	    s TreatAlias= $lg($g(^CT.WDT.CDSS.TreatDictD(ID)),8)        
	d OutputRow
	}
	else
	{
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		s:alias'="" alias=$ZCONVERT(alias,"U") //转换成大写
		
		s:UUser'="" UUser=$ZCONVERT(UUser,"U")
		s:RDesc'="" RDesc=$ZCONVERT(RDesc,"U")
		s:DName'="" DName=$ZCONVERT(DName,"U")
		
		k ^TempDataHandle($ZNAME,repid,$JOB,"Handle")
		if (sortmethod="Short")
		{
			s TID=0
			for 
			{
				s TID=$o(^CT.WDT.CDSS.TreatDictD(TID))
				q:TID=""
				s TreatDesc= $lg($g(^CT.WDT.CDSS.TreatDictD(TID)),3)		//名称
				s length=$l(TreatDesc)
				s ^TempDataHandle($ZNAME,repid,$JOB,"Handle",length,TID)=TID
			}
			s num=0
			
		}
		elseif (sortmethod="UpdateDate")
		{
			s TID=0
			for 
			{
				s TID=$o(^CT.WDT.CDSS.TreatDictD(TID))
				q:TID=""
				s UpdateDate= $lg($g(^CT.WDT.CDSS.TreatDictD(TID)),6)				//编辑时间
				s:UpdateDate="" UpdateDate="2021-08-08"
				s ^TempDataHandle($ZNAME,repid,$JOB,"Handle",UpdateDate,TID)=TID
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
			s ID=0
			for
			{
				s ID=$o(^TempDataHandle($ZNAME,repid,$JOB,"Handle",le,ID)) q:ID=""
		
				s TreatCode= $lg($g(^CT.WDT.CDSS.TreatDictD(ID)),2)      //治疗方案代码
				s TreatDesc= $lg($g(^CT.WDT.CDSS.TreatDictD(ID)),3)      //治疗方案名称
				s ResultRowId=0,RuleDescStr="",DiagNamestr=""
				for
				{
					s ResultRowId = $o(^CT.WDT.CDSS.RuleResultI("TypeResultIndex","治疗方案",ID,ResultRowId)) q:ResultRowId=""
					s NodeDR=$lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),2)
					if (NodeDR'="")
					{
						s RuleDR=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),2)
						s FlowChartNum=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),3)
						s RuleDesc=""
						if (RuleDR'="")
						{
							s RuleDesc=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleDR)),3)
							s:RuleDescStr'="" RuleDescStr=RuleDescStr_","_RuleDesc
							s:RuleDescStr="" RuleDescStr=RuleDesc
							s NodeRowId=0
							for
							{
								s NodeRowId = $o(^CT.WDT.CDSS.RuleNodeI("RuleDRTypeIndex",RuleDR,FlowChartNum,"诊断条件",NodeRowId)) q:NodeRowId=""
								s ConditionRowId = 0
								for
								{
									s ConditionRowId = $o(^CT.WDT.CDSS.RuleConditionI("NodeDRIndex",NodeRowId,ConditionRowId)) q:ConditionRowId=""
									s ConditionItemValue  = $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowId)),6)
									s:DiagNamestr'="" DiagNamestr=DiagNamestr_","_ConditionItemValue
									s:DiagNamestr="" DiagNamestr=ConditionItemValue
								}
							}
						}
						
					}
					
				}
		   	 	s UseFlag= $lg($g(^CT.WDT.CDSS.TreatDictD(ID)),4)        //使用标志
		   	 	s:UseFlag="" UseFlag=0
				if (state="")
				{
					continue:(UseFlag="1")	
				}else
				{
					continue:(UseFlag'=state)
				}
		    	
		    	s UpdateUser= $lg($g(^CT.WDT.CDSS.TreatDictD(ID)),5) 	//编辑人员
		    	continue:((UUser'="")&&($ZCONVERT(UpdateUser,"U")'[UUser))
		    	s SUpdateDate=$p(timescope,"^",1)
		    	s EUpdateDate=$p(timescope,"^",2)
		    	s UpdateDate= $lg($g(^CT.WDT.CDSS.TreatDictD(ID)),6)     //编辑时间
		    	continue:((SUpdateDate'="")&&($ZDH(SUpdateDate,3)>$ZDH(UpdateDate,3)))
	        	continue:((EUpdateDate'="")&&($ZDH(EUpdateDate,3)<$ZDH(UpdateDate,3)))
		    	s Remarks= $lg($g(^CT.WDT.CDSS.TreatDictD(ID)),7)        //备注
		    	s TreatAlias= $lg($g(^CT.WDT.CDSS.TreatDictD(ID)),8) 
		    	
			    if ($ZCONVERT(TreatDesc,"U")[desc)&&($ZCONVERT(TreatAlias,"U")[alias)&&($ZCONVERT(RuleDescStr,"U")[RDesc)&&($ZCONVERT(DiagNamestr,"U")[DName)
				{
					d OutputRow
				} 
			}
		}				
	}
			
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ID,TreatCode,TreatDesc,TreatAlias,UseFlag,UpdateUser,UpdateDate,Remarks,RuleDescStr,DiagNamestr)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	k ^TempDataHandle($ZNAME,repid,$JOB,"Handle")
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

/// Creator:阚延新
/// Editor:丁亚男
/// CreatDate:2021-1-8
/// Description：数据重复验证方法，由js调用
/// Table:CT.WDT.CDSS.TreatDict治疗方案字典表
/// Input：Id；code；name
/// Return："1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.CDSS.CMKB.TreatDict).Validate("","1","")
ClassMethod Validate(id As %String, name As %String) As %String
{
    s:name'="" name=$ZCONVERT(name,"U") //转换成大写
    s flag="",flagname=""
    s:name'="" flagname=$d(^CT.WDT.CDSS.TreatDictI("DescIndex"," "_name)) 
    if (id="") //如果为空，增加时的重复判断
    {
        if ((flagname>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    else //如果不为空，修改时的重复判断
    {
        s idname=""
        s:name'="" idname=$o(^CT.WDT.CDSS.TreatDictI("DescIndex"," "_name,0))
        if ((idname'="")&(idname'=id)&(flagname>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    q flag
}

/// Creator:赵文伟
/// CreateDate:2023-03-09   
/// Description:校验别名【新增别名与表中所有名称及别名重复校验】
/// w ##class(web.CDSS.CMKB.TreatDict).ValidateAlias("","")
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
	    s flagA=$d(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.TreatDict",Alias))
	    s flagN=$d(^CT.WDT.CDSS.TreatDictI("DescIndex",Alias))
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
	        s idA=$o(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.TreatDict",Alias,0))	//用别名表中别名数据校验别名重复
	        s idN=$o(^CT.WDT.CDSS.TreatDictI("DescIndex",Alias,0))  						//字典表的名称来校验别名重复
	        if ((idA'="")&(idA'=id)&(flagA>0))||((flagN'="")&(idN'=id)&(flagN>0))
	        {
		         s flag=1  //返回重复标志
		         q
	        }
	    }
	}
	q flag
}

/// Creator：丁亚男
/// CreatDate: 2021-01-05
/// Description:代码自动生成  GZ00001 代码最大值加1
/// Other: w ##class(web.CDSS.CMKB.TreatDict).GetLastCode()
ClassMethod GetLastCode() As %String
{
  	s ID = $o(^CT.WDT.CDSS.TreatDictD(""),-1)
	if (ID="")
	{
		s code=1
	}
	else
	{
		s code = $lg($g(^CT.WDT.CDSS.TreatDictD(ID)),2)+1
	}
	q code
}

/// Creator:阚延新
/// Editor:丁亚男
/// CreatDate:2021-1-8
/// Description：保存治疗方案字典表的内容
/// Table:CT.WDT.CDSS.TreatDict治疗方案字典表
/// Input：web.CDSSEntity.CMKB.TreatDict 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.CDSS.CMKB.TreatDict).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.CDSSEntity.CMKB.TreatDict) As %String
{
    s $zt="ERROE"
    s result="",flag=""
    if $IsObject(eobj)
    {   
    	
        s flag=..Validate(eobj.ID,eobj.TreatDesc)  //调用重复验证
        s flagAlias=..ValidateAlias(eobj.ID,eobj.TreatDesc,eobj.TreatAlias)  //调用重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在！'}"
        }
        elseif(flagAlias=1)
        {
	        q "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}"
	    }
        else
        {
            if (eobj.ID="")  //如果RowId未赋值则增加
            {
                s obj=##class(CT.WDT.CDSS.TreatDict).%New()
                s eobj.TreatCode=..GetLastCode()
            }
            else                     //如果RowId已赋值则修改
            {
                s obj=##class(CT.WDT.CDSS.TreatDict).%OpenId(eobj.ID)
                s bobj=##class(web.CDSSEntity.CMKB.TreatDict).%New()
                s bobj.ID=eobj.ID
                s bobj.TreatCode=obj.TreatCode
                s bobj.TreatDesc=obj.TreatDesc          //修改描述
                s bobj.UseFlag=obj.UseFlag
                s bobj.UpdateUser=obj.UpdateUser
                s bobj.UpdateDate=obj.UpdateDate
                s bobj.Remarks=obj.Remarks 
                s eobj.TreatCode=obj.TreatCode
                s bobj.TreatAlias=obj.TreatAlias 
            }
            Ts
            s obj.TreatCode = eobj.TreatCode
            s obj.TreatDesc = eobj.TreatDesc          //修改描述
            s obj.UseFlag=0
            s eobj.UpdateUser = $g(%session.Data("LOGON.USERNAME"))
            s obj.UpdateUser = eobj.UpdateUser
            s eobj.UpdateDate=$zdt($h,3)
            s obj.UpdateDate=eobj.UpdateDate
            s obj.Remarks = eobj.Remarks
            s obj.TreatAlias=eobj.TreatAlias 
            
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc)
            {
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}"  //返回RowId
                //新增时，日志
                d:eobj.ID="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TreatDict","CT.WDT.CDSS.TreatDict","治疗方案字典",id,eobj.TreatDesc,"A",eobj)
                //修改时，日志
                d:eobj.ID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TreatDict","CT.WDT.CDSS.TreatDict","治疗方案字典",eobj.ID,eobj.TreatDesc,"U",eobj,bobj)
            	
            	//如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表
            	if ((eobj.ID="")&&(eobj.TreatAlias'=""))||((eobj.ID'="")&&(eobj.TreatAlias'=bobj.TreatAlias))
            	{
            		d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.TreatDict",id,eobj.TreatAlias)
            	}
            }
            else
            {
                Trollback
                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
                s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("治疗方案字典","web.CDSS.CMKB.TreatDict","SaveEntity",eobj)
                s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			}
        }               
    }
    else
    {
        s result = "{success:'false',errorinfo:'对象不存在！'}"
    }
    q result
ERROE
    s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("治疗方案字典","web.CDSS.CMKB.TreatDict","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=$ze
    q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator：赵文伟
/// CreatDate: 2022-08-21
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// Other: w ##class(web.CDSS.CMKB.TreatDict).GetRefFlag("1")
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""
	
	//规则引用接口
	s RuleDescStr=##class(web.CDSS.CMKB.RuleDict).GetRefFlag("治疗方案",id)
	if RuleDescStr'="" s myInfo=myInfo_"<规则管理："_RuleDescStr_">"
	
	i myInfo="" s return="0^未被引用可删除!"
 	else  s return="1^在"_myInfo_"表里被引用"
 	q return
}

/// Creator:赵文伟
/// CreatDate:2021-10—25
/// Description：根据ID删除字典表的内容
/// Table：CT.WDT.CDSS.TreatDict
/// Input：id-字典表的rowid
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.CDSS.CMKB.TreatDict).DeleteData("10")
ClassMethod DeleteData(id As %String) As %String
{
         
    s result="" 
    s obj=##class(CT.WDT.CDSS.TreatDict).%OpenId(id)      
    s bobj = ##class(web.CDSSEntity.CMKB.TreatDict).%New()
    s bobj.ID=id	
    s bobj.TreatCode=obj.TreatCode
    s bobj.TreatDesc=obj.TreatDesc          //修改描述
    s bobj.UseFlag=obj.UseFlag
    s bobj.UpdateUser=obj.UpdateUser
    s bobj.UpdateDate=obj.UpdateDate
    s bobj.Remarks=obj.Remarks
    s bobj.TreatAlias=obj.TreatAlias 
	d obj.%Close()
    k obj
    Tstart
    s sc=##class(CT.WDT.CDSS.TreatDict).%DeleteId(id)
    if $$$ISOK(sc)
    {
        Tcommit
        s result = "{success:'true',info:'删除成功！'}"  
        d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TreatDict","CT.WDT.CDSS.TreatDict","治疗方案字典",id,bobj.TreatDesc,"D",bobj)
        
        //同步删除别名通用表中数据 
		d ##class(web.CDSS.CMKB.Alias).DeleteAlias("CT.WDT.CDSS.TreatDict",id)
        d bobj.%Close()
           
    }
    else 
    {
        Trollback
        s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
        s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("治疗方案字典","web.CDSS.CMKB.TreatDict","DeleteData",bobj)
        s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
     }
     q result
}

/// Creator:阚延新
/// Editor:丁亚男
/// CreatDate:2021-1-8
/// Description：修改时打开的数据
/// Table:CT.WDT.CDSS.TreatDict治疗方案字典表
/// Input：id
/// Return:Json格式的字符串{"PHLIActiveFlag":"Y","PHLICode":"PUBLIC","PHLIDesc":"公共","PHLIRowId":"9"}
/// Other: w ##class(web.CDSS.CMKB.TreatDict).OpenData("9099")
ClassMethod OpenData(Id As %String) As %String
{
    s str="" 
    s obj=##class(CT.WDT.CDSS.TreatDict).%OpenId(Id)
    s eobj=##class(web.CDSSEntity.CMKB.TreatDict).%New()
    s eobj.ID=Id
    s eobj.TreatDesc=obj.TreatDesc          //修改描述
    s eobj.Remarks=obj.Remarks 
    s eobj.TreatAlias=obj.TreatAlias 
    s str = eobj.JsonS()    
    d obj.%Close()
    q str
}

/// Creator:阚延新
/// CreatDate:2021-1-12
/// Description:导出治疗方案字典数据【暂不用】
/// Table:
/// Input：
/// Output:文件名 fileName
/// Others：w ##class(web.CDSS.CMKB.TreatDict).ExportData()
ClassMethod ExporData() As %String
{
	s sum=0
	
	s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName="治疗方案字典数据.csv"
	s P=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\"_fileName
	s file=##class(%File).%New(P)
	d file.Open("NWS")
	d file.WriteLine("治疗方案代码,治疗方案名称,编辑人员,编辑时间,备注,使用标志")
	s ID=0
	for 
	{
		s ID=$o(^CT.WDT.CDSS.TreatDictD(ID))
		q:ID=""
		s TreatCode= $lg($g(^CT.WDT.CDSS.TreatDictD(ID)),2)      //治疗方案代码
		s TreatDesc= $lg($g(^CT.WDT.CDSS.TreatDictD(ID)),3)      //治疗方案名称
	   	s UseFlag= $lg($g(^CT.WDT.CDSS.TreatDictD(ID)),4)        //使用标志
	    s UseFlag=$case(UseFlag,"0":"编辑中","1":"已弃用","2":"已审核",:"编辑中") 
	    s UpdateUser= $lg($g(^CT.WDT.CDSS.TreatDictD(ID)),5) 	//编辑人员
	    s UpdateDate= $lg($g(^CT.WDT.CDSS.TreatDictD(ID)),6)     //编辑时间
	    s Remarks= $lg($g(^CT.WDT.CDSS.TreatDictD(ID)),7)        //备注
		
	 	//替换双引号
		s TreatCode=$replace(TreatCode,"""","”")
		s TreatDesc=$replace(TreatDesc,"""","”")
		s UpdateUser=$replace(UpdateUser,"""","”")
		s UpdateDate=$replace(UpdateDate,"""","”")
		s Remarks=$replace(Remarks,"""","”")
		s str=TreatCode_","_TreatDesc_","_UpdateUser_","_UpdateDate_","_Remarks_","_UseFlag
		d file.WriteLine(str)
		s sum = sum+1
	}
	d file.%Save()
	d file.%Close()
	//w sum 
	//q "{fileName:"""_fileName_"""}"
	q fileName
}

/// Creator:zhaowenwei
/// CreatDate:2021-11-05
/// Description：导出治疗方案字典表数据txt
/// Other:w ##class(web.CDSS.CMKB.TreatDict).ExportTreatTXTData()
ClassMethod ExportTreatTXTData(desc, alias, RDesc, DName, state, UUser, SUpdateDate, EUpdateDate) As %String
{
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"治疗方案字典数据.txt"		
	s file=""			 	;key转放到web目录下
	if (Path["\"){
		s DirName = Path_"scripts\bdp\CDSS\DataExport\"
		s file = Path_"scripts\bdp\CDSS\DataExport\"_fileName
	}else{
		s DirName = Path_"scripts/bdp/CDSS/DataExport/"
		s file = Path_"scripts/bdp/CDSS/DataExport/"_fileName
	}
	if '##class(%File).DirectoryExists(DirName){	//文件保存路径不存在，新建文件夹
		d ##class(%File).CreateDirectoryChain(DirName)
	}
	o file:"NWS"
	u file
	w "治疗方案代码	治疗方案名称	别名	使用标志	编辑人员	编辑时间	备注"
	
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s:alias'="" alias=$ZCONVERT(alias,"U") //转换成大写
	s:UUser'="" UUser=$ZCONVERT(UUser,"U")
	s:RDesc'="" RDesc=$ZCONVERT(RDesc,"U")
	s:DName'="" DName=$ZCONVERT(DName,"U")
	s ID=""
	for
	{ 
		s ID=$o(^CT.WDT.CDSS.TreatDictD(ID),-1)  q:ID="" 	
		q:ID=""
		s TreatCode= $lg($g(^CT.WDT.CDSS.TreatDictD(ID)),2)      //治疗方案代码
		s TreatDesc= $lg($g(^CT.WDT.CDSS.TreatDictD(ID)),3)      //治疗方案名称
		s ResultRowId=0,RuleDescStr="",DiagNamestr=""
		for
		{
			s ResultRowId = $o(^CT.WDT.CDSS.RuleResultI("TypeResultIndex","治疗方案",ID,ResultRowId)) q:ResultRowId=""
			s NodeDR=$lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),2)
			if (NodeDR'="")
			{
				s RuleDR=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),2)
				s FlowChartNum=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),3)
				s RuleDesc=""
				if (RuleDR'="")
				{
					s RuleDesc=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleDR)),3)
					s:RuleDescStr'="" RuleDescStr=RuleDescStr_","_RuleDesc
					s:RuleDescStr="" RuleDescStr=RuleDesc
					s NodeRowId=0
					for
					{
						s NodeRowId = $o(^CT.WDT.CDSS.RuleNodeI("RuleDRTypeIndex",RuleDR,FlowChartNum,"诊断条件",NodeRowId)) q:NodeRowId=""
						s ConditionRowId = 0
						for
						{
							s ConditionRowId = $o(^CT.WDT.CDSS.RuleConditionI("NodeDRIndex",NodeRowId,ConditionRowId)) q:ConditionRowId=""
							s ConditionItemValue  = $lg($g(^CT.WDT.CDSS.RuleConditionD(ConditionRowId)),6)
							s:DiagNamestr'="" DiagNamestr=DiagNamestr_","_ConditionItemValue
							s:DiagNamestr="" DiagNamestr=ConditionItemValue
						}
					}
				}		
			}		
		}
		s UseFlag= $lg($g(^CT.WDT.CDSS.TreatDictD(ID)),4)        //使用标志
		s:UseFlag="" UseFlag=0
		if (state="")
		{
			continue:(UseFlag="1")	
		}else
		{
			continue:(UseFlag'=state)
		}
		s UseFlag=$case(UseFlag,"0":"编辑中","1":"已弃用","2":"已审核",:"编辑中") 
		s UpdateUser= $lg($g(^CT.WDT.CDSS.TreatDictD(ID)),5) 	//编辑人员
		continue:((UUser'="")&&($ZCONVERT(UpdateUser,"U")'[UUser))
		s UpdateDate= $lg($g(^CT.WDT.CDSS.TreatDictD(ID)),6)     //编辑时间
		continue:((SUpdateDate'="")&&($ZDH(SUpdateDate,3)>$ZDH(UpdateDate,3)))
	    continue:((EUpdateDate'="")&&($ZDH(EUpdateDate,3)<$ZDH(UpdateDate,3)))
		s Remarks= $lg($g(^CT.WDT.CDSS.TreatDictD(ID)),7)        //备注
		s TreatAlias= $lg($g(^CT.WDT.CDSS.TreatDictD(ID)),8) 
		    	
		if ($ZCONVERT(TreatDesc,"U")[desc)&&($ZCONVERT(TreatAlias,"U")[alias)&&($ZCONVERT(RuleDescStr,"U")[RDesc)&&($ZCONVERT(DiagNamestr,"U")[DName)
		{
			w !,TreatCode_"	"_TreatDesc_"	"_TreatAlias_"	"_UseFlag_"	"_UpdateUser_"	"_UpdateDate_"	"_Remarks
		}
	}
	c file
	q fileName
}

/// Creator：丁亚男
/// CreatDate: 2021-01-19
/// Description：查询 治疗方案 
/// Table：CT.WDT.CDSS.TreatDict
/// Input：rowid, desc
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.TreatDict","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, desc As %String, q As %String) As %Query(ROWSPEC = "TreatRowId:%String,TreatCode:%String,TreatDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String, q As %String) As %Status
{
	
 s repid=$I(^CacheTemp)
 s ind=1
 if (rowid'="") //根据rowid返回该条记录
 {
	s TreatRowId=rowid
	s TreatCode= $lg($g(^CT.WDT.CDSS.TreatDictD(TreatRowId)),2)      //治疗方案代码
	s TreatDesc= $lg($g(^CT.WDT.CDSS.TreatDictD(TreatRowId)),3)      //治疗方案名称
  	d OutputRowCmb
 }
 else
 {
	
  s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
  s:q'="" q=$ZCONVERT(q,"U") //转换成大写
  s TreatRowId=""
  for{  
	  s TreatRowId=$o(^CT.WDT.CDSS.TreatDictD(TreatRowId),-1) q:TreatRowId=""  
	  s TreatCode= $lg($g(^CT.WDT.CDSS.TreatDictD(TreatRowId)),2)      //治疗方案代码
	  s TreatDesc= $lg($g(^CT.WDT.CDSS.TreatDictD(TreatRowId)),3)      //治疗方案名称
	  s UseFlag= $lg($g(^CT.WDT.CDSS.TreatDictD(TreatRowId)),4)
	  s PINYIN=""
	  s:q'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(TreatDesc)  
	  if (($ZCONVERT(TreatDesc,"U")[desc)||(PINYIN[desc)&(($ZCONVERT(TreatDesc,"U")[q)||(PINYIN[q))&(UseFlag=2)) 
	  {
	  	d OutputRowCmb
	  }
  }
 }
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb
    set Data=$lb(TreatRowId,TreatCode,TreatDesc)
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

/// Creator:阚延新
/// CreatDate:2021-1-18
/// Description：导入治疗方案字典
/// Table：CT.WDT.CDSS.TreatDict治疗方案字典表
/// Input：
/// Output：
/// w ##class(web.CDSS.CMKB.TreatDict).ImportDiagFactor()
ClassMethod ImportDiagFactor()
{
	s result ="" 
	s TreatCode=0
	s file=##class(%File).%New("D:\东华培训\治疗方案及措施导出.csv")
	d file.Open("RS")
	d file.ReadLine()
	while 'file.AtEnd
	{
		s Line=file.ReadLine() q:Line=""
		s eobj = ##class(web.CDSSEntity.CMKB.TreatDict).%New()
		s eobj.TreatDesc=$p(Line,",",1)
		s del=$p(Line,",",3)
		continue:(del="删除")
		s TreatDesc = $ZCONVERT(eobj.TreatDesc,"U")
	    if $d(^CT.WDT.CDSS.TreatDictI("DescIndex"," "_TreatDesc))
	    {
		   s eobj.ID =$o(^CT.WDT.CDSS.TreatDictI("DescIndex"," "_TreatDesc,""))
		   s obj=##class(CT.WDT.CDSS.TreatDict).%OpenId(eobj.ID) 
	    }
	    else
	    {
		    s obj=##class(CT.WDT.CDSS.TreatDict).%New()
		    s TreatCode=TreatCode+1
		    s obj.TreatCode=TreatCode
		}
        s obj.TreatDesc = eobj.TreatDesc
		s obj.UseFlag = 0
		s obj.Remarks = ""	
		s obj.UpdateUser = "dhcc"
		s obj.UpdateDate = $ZDATETIME($HOROLOG,3)
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		s id =""
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" //返回RowId
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'保存失败'}"   //返回错误信息
		}
		
	}
	q result
}

/// Creator: 赵文伟 
/// CreatDate: 2021-10-25
/// Description: 批量通过
/// Table: CT.WDT.CDSS.TreatDict
/// Input: RowIdStr id串
/// Return: true/false
/// Other: w ##class(web.CDSS.CMKB.TreatDict).ChangeStatusPass("")
ClassMethod ChangeStatusPass(RowIdStr As %String)
{
	s result=""
	s errorflag=0
	s num=$l(RowIdStr,",")
	q:RowIdStr="" "false"
	TS
	if (num>=1)
	{
		for m=1:1:num
		{
			s id=$p(RowIdStr,",",m)
			s flag=..ChangeStatus(id,"通过")

			if (flag'["true"){
				s errorflag = errorflag+1
			}
		}
	}
	if (errorflag'=0)
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

/// Creator: 赵文伟 
/// CreatDate: 2021-10-25
/// Description: 批量驳回
/// Table: CT.WDT.CDSS.TreatDict
/// Input: RowIdStr id串
/// Return: true/false
/// Other: w ##class(web.CDSS.CMKB.TreatDict).ChangeStatusBack("")
ClassMethod ChangeStatusBack(RowIdStr As %String)
{
	s result=""
	s errorflag=0
	s num=$l(RowIdStr,",")
	q:RowIdStr="" "false"
	TS
	if (num>=1)
	{
		for m=1:1:num
		{
			s id=$p(RowIdStr,",",m)
			s flag=..ChangeStatus(id,"驳回")

			if (flag'["true"){
				s errorflag = errorflag+1
			}
		}
	}
	if (errorflag'=0)
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

/// Creator：赵文伟
/// CreatDate:2021-10-27
/// Input:RowId  Operation 操作(操作状态改变)
/// Return:
/// Other:w ##class(web.CDSS.CMKB.TreatDict).ChangeStatus(003,"1")
ClassMethod ChangeStatus(RowId, Operation)
{
	s result=""
	s eobj = ##class(web.CDSSEntity.CMKB.TreatDict).%New()
	
	s:Operation="通过" eobj.UseFlag="2"	//已审核
	s:Operation="弃用" eobj.UseFlag="1"	//已弃用
	s:Operation="恢复" eobj.UseFlag="0"	//编辑中
	s:Operation="驳回" eobj.UseFlag="0"	//编辑中
	s eobj.UpdateDate=$zdt($h,3)
	if ($d(%session)) {s eobj.UpdateUser=$g(%session.Data("LOGON.USERNAME"))}
	
	s obj=##class(CT.WDT.CDSS.TreatDict).%OpenId(RowId)
	s bobj = ##class(web.CDSSEntity.CMKB.TreatDict).%New()
	s bobj.UseFlag=obj.UseFlag
	s bobj.UpdateDate=obj.UpdateDate
	s bobj.UpdateUser=obj.UpdateUser
	
	s obj.UseFlag=eobj.UseFlag
 	s obj.UpdateDate=eobj.UpdateDate
 	s obj.UpdateUser=eobj.UpdateUser
 	Ts
 	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{
		Tc
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
		
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TreatDict","CT.WDT.CDSS.TreatDict","治疗方案字典",RowId,obj.TreatDesc_"&&"_Operation,"U",eobj,bobj)	
	}
	else
	{
		Trollback
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		
	}
	q result
}

/// Creator:zhaowenwei
/// CreatDate:2022-1-19
/// Description:获得别名列表
/// Table: CT.WDT.CDSS.TreatDict
/// Input: id
/// Return:返回别名列表
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.TreatDict","GetAliasList","")
Query GetAliasList(id) As %Query(ROWSPEC = "Desc")
{
}

ClassMethod GetAliasListExecute(ByRef qHandle As %Binary, id) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	if (id'=""){
		s TreatAlias = $lg($g(^CT.WDT.CDSS.TreatDictD(id)),8)
		s Len=$Length(TreatAlias,",")
		for i=1:1:Len{
			s Desc=$p(TreatAlias,",",i)
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

/// Creator：赵文伟 
/// CreatDate: 2022-01-19
/// Description：别名数据转存到别名通用表中
/// Table: CT.WDT.CDSS.TreatDict
/// Other: w ##class(web.CDSS.CMKB.TreatDict).TransferAliasData() 
ClassMethod TransferAliasData() As %String
{
	s RowId=0
	s count=0
	for
	{
		s RowId=$o(^CT.WDT.CDSS.TreatDictD(RowId))
		q:RowId=""
		s Alias= $lg($g(^CT.WDT.CDSS.TreatDictD(RowId)),8)        
		if Alias'=""
		{
			//s Alias=$replace(Alias,"，",",")
			d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.TreatDict",RowId,Alias)
			s count=count+1
		}	 	
	}
	q "success!savecount:"_count
}

/// Creator：赵文伟 
/// CreatDate: 2022-01-24
/// Description：数据统计方法
/// Table: CT.WDT.CDSS.TreatDict
/// Output: 总数据量^编辑中的数据量^已审核的数据量(审核通过+已上线)^待审核的数据量
/// Other: w ##class(web.CDSS.CMKB.TreatDict).CountData() 
ClassMethod CountData() As %String
{
	s RowId=0
	s totalcount=0		//总数据量
	s editcount=0		//编辑中的数据量
	s auditcount=0		//已审核的数据量
	s unauditcount=0	//待审核的数据量
	for
	{
		s RowId=$o(^CT.WDT.CDSS.TreatDictD(RowId))
		q:RowId=""
		//s totalcount=totalcount+1
		s UseFlag = $lg($g(^CT.WDT.CDSS.TreatDictD(RowId)),4)       
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

/// Creator:赵文伟
/// CreatDate:2022-11-10
/// Description:获得操作日志
/// Table: 
/// Input: RowId
/// Return:返回日志
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.TreatDict","GetLogList","")
Query GetLogList(RowId As %String) As %Query(ROWSPEC = "LogID,UpdateDate,UpdateTime,UpdateUserName,Operation")
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
	    	s LogID=$o(^CF.WDT.CDSS.DataChangeLogI("ObjectReferIndex","CT.WDT.CDSS.TreatDict",RowId,LogID),-1) q:LogID=""
	    	s UpdateUserName=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(LogID)),7)
	    	s UpdateDate=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(LogID)),8)
	    	s UpdateDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(UpdateDate)
          	s UpdateTime=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(LogID)),9)
          	s UpdateTime=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(UpdateTime)
          	s ObjectDesc=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(LogID)),13)   //新增对象描述
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
	set Data=$lb(LogID,UpdateDate,UpdateTime,UpdateUserName,Operation)
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

/// Creator：赵文伟
/// CreatDate: 2023-01-17
/// Description：修正数据保存方法
/// Table：CT.WDT.CDSS.TreatDict
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.TreatDict).SaveAmendData()
ClassMethod SaveAmendData(eobj As web.CDSSEntity.CMKB.TreatDict) As %String
{
	s $zt="ERROE"
    s result="",flag=""
    if $IsObject(eobj)
    {   
    	
        s flag=..Validate(eobj.ID,eobj.TreatDesc)  //调用重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在！'}"
        }
        s flagAlias=..ValidateAlias(eobj.ID,eobj.TreatDesc,eobj.TreatAlias)		//调用别名重复验证
		if (flagAlias=1)
		{
			q "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}"
		}
        else
        {
            if (eobj.ID="")  //如果RowId未赋值则增加
            {
                s obj=##class(CT.WDT.CDSS.TreatDict).%New()
                s eobj.TreatCode=..GetLastCode()
            }
            else                     //如果RowId已赋值则修改
            {
                s obj=##class(CT.WDT.CDSS.TreatDict).%OpenId(eobj.ID)
                s bobj=##class(web.CDSSEntity.CMKB.TreatDict).%New()
                s bobj.ID=eobj.ID
                s bobj.TreatCode=obj.TreatCode
                s bobj.TreatDesc=obj.TreatDesc          //修改描述
                s bobj.UpdateUser=obj.UpdateUser
                s bobj.UpdateDate=obj.UpdateDate
                s eobj.TreatCode=obj.TreatCode
                s bobj.TreatAlias=obj.TreatAlias 
            }
            Ts
            s obj.TreatCode = eobj.TreatCode
            s obj.TreatDesc = eobj.TreatDesc          //修改描述
            s eobj.UpdateUser = $g(%session.Data("LOGON.USERNAME"))
            s obj.UpdateUser = eobj.UpdateUser
            s eobj.UpdateDate=$zdt($h,3)
            s obj.UpdateDate=eobj.UpdateDate
            s obj.TreatAlias=eobj.TreatAlias 
            
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc)
            {
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}"  //返回RowId
                //新增时，日志
                d:eobj.ID="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TreatDict","CT.WDT.CDSS.TreatDict","治疗方案字典",id,eobj.TreatDesc,"A",eobj)
                //修改时，日志
                d:eobj.ID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TreatDict","CT.WDT.CDSS.TreatDict","治疗方案字典",eobj.ID,eobj.TreatDesc,"U",eobj,bobj)
            	
            	//如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表
            	if ((eobj.ID="")&&(eobj.TreatAlias'=""))||((eobj.ID'="")&&(eobj.TreatAlias'=bobj.TreatAlias))
            	{
            		d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.TreatDict",id,eobj.TreatAlias)
            	}
            }
            else
            {
                Trollback
                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
                s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("治疗方案字典","web.CDSS.CMKB.TreatDict","SaveEntity",eobj)
                s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			}
        }               
    }
    else
    {
        s result = "{success:'false',errorinfo:'对象不存在！'}"
    }
    q result
ERROE
    s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("治疗方案字典","web.CDSS.CMKB.TreatDict","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=$ze
    q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

}
