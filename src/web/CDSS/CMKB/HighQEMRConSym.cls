/// 名称:优质病历关联诊断因子表
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 - 丁亚男
/// 编写日期:2023-3-27
Class web.CDSS.CMKB.HighQEMRConSym Extends %RegisteredObject
{

/// Creator：丁亚男	
/// CreatDate: 2023-3-27
/// Description：查询 
/// Table:CT.WDT.CDSS.HighQEMRConSym优质病历关联诊断因子表
/// Input:id, code,desc
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.HighQEMRConSym","GetList","","","肺炎","","","","1","","")
Query GetList(rowid As %String, EMRId As %String, NodeType As %String, symptom As %String) As %Query(ROWSPEC = "RowId,EMRDR,EMRNode,SymptomNum,Symptom,Duration,AbnormalMax,AbnormalMin,NormalMax,NormalMin,RangeUnit,RangeType,Cause,SymptomType,SymptomFormal,SymptomCore,SymProperty,SymptomChildren,PartDR,Part,PositionWordDR,PositionWord,Remarks")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, EMRId As %String, NodeType As %String, symptom As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s RowId=rowid
		s EMRDR= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),2)      
		s EMRNode= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),3)      
		s SymptomNum= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),4)
	    s Symptom= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),5) 	
	    s Duration= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),6)     
	    s AbnormalMax= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),7)        
	    s AbnormalMin= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),8) 
	    
	    s NormalMax= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),9)      
		s NormalMin= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),10)      
		s RangeUnit= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),11)
	    s RangeType= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),12) 	
	    s Cause= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),13)     
	    s SymptomType= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),14)        
	    s SymptomFormal= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),15) 
	    s SymptomCore= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),16)      
		s SymProperty= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),17)      
		s SymptomChildren= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),18)
	    s PartDR= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),19) 
	    s Part=""
	    s:PartDR'="" Part=$lg($g(^CT.WDT.CDSS.BodyPartsDictD(PartDR)),3) //取部位名称
	    s PositionWordDR= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),20)
	    s PositionWord="" 
	    s:PositionWordDR'="" PositionWord=$lg($g(^CT.WDT.CDSS.PositionWordD(PositionWordDR)),3)    
	    s Remarks= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),21)
	    
	        
		d OutputRow
	}
	elseif(EMRId'="")
	{
		if $d(^CT.WDT.CDSS.HighQEMRConSymI("EMRDRIndex",EMRId))
		{
			s RowId=""
			for 
			{
				s RowId=$O(^CT.WDT.CDSS.HighQEMRConSymI("EMRDRIndex",EMRId,RowId)) q:RowId=""
				s EMRDR= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),2)      
				s EMRNode= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),3)      
				s SymptomNum= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),4)
			    s Symptom= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),5) 	
			    s Duration= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),6)     
			    s AbnormalMax= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),7)        
			    s AbnormalMin= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),8) 
			    s NormalMax= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),9)      
				s NormalMin= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),10)      
				s RangeUnit= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),11)
			    s RangeType= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),12) 	
			    s Cause= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),13)     
			    s SymptomType= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),14)        
			    s SymptomFormal= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),15) 
			    s SymptomCore= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),16)      
				s SymProperty= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),17)      
				s SymptomChildren= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),18)
			    s PartDR= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),19) 
			    s Part=""
			    s:PartDR'="" Part=$lg($g(^CT.WDT.CDSS.BodyPartsDictD(PartDR)),3) //取部位名称
			    s PositionWordDR= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),20)
			    s PositionWord="" 
			    s:PositionWordDR'="" PositionWord=$lg($g(^CT.WDT.CDSS.PositionWordD(PositionWordDR)),3)    
			    s Remarks= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),21)
			    
			    if ((NodeType="")||((NodeType'="")&(EMRNode=NodeType)))&&((SymptomNum[symptom))
			    {
				  d OutputRow  
				} 
			}
		}
	}
	else
	{
		s RowId=""
		for 
		{
			s RowId=$O(^CT.WDT.CDSS.HighQEMRConSymD(RowId)) q:RowId=""
			s EMRDR= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),2)      
			s EMRNode= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),3)      
			s SymptomNum= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),4)
		    s Symptom= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),5) 	
		    s Duration= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),6)     
		    s AbnormalMax= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),7)        
		    s AbnormalMin= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),8) 
		    s NormalMax= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),9)      
			s NormalMin= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),10)      
			s RangeUnit= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),11)
		    s RangeType= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),12) 	
		    s Cause= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),13)     
		    s SymptomType= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),14)        
		    s SymptomFormal= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),15) 
		    s SymptomCore= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),16)      
			s SymProperty= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),17)      
			s SymptomChildren= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),18)
		    s PartDR= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),19) 
		    s Part=""
		    s:PartDR'="" Part=$lg($g(^CT.WDT.CDSS.BodyPartsDictD(PartDR)),3) //取部位名称
		    s PositionWordDR= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),20)
		    s PositionWord="" 
		    s:PositionWordDR'="" PositionWord=$lg($g(^CT.WDT.CDSS.PositionWordD(PositionWordDR)),3)    
		    s Remarks= $lg($g(^CT.WDT.CDSS.HighQEMRConSymD(RowId)),21)
		    
		    if ((NodeType="")||((NodeType'="")&(EMRNode=NodeType)))&&((SymptomNum[symptom))
		    {
			  d OutputRow  
			} 
		}
	}		
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(RowId,EMRDR,EMRNode,SymptomNum,Symptom,Duration,AbnormalMax,AbnormalMin,NormalMax,NormalMin,RangeUnit,RangeType,Cause,SymptomType,SymptomFormal,SymptomCore,SymProperty,SymptomChildren,PartDR,Part,PositionWordDR,PositionWord,Remarks)
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

/// Creator:丁亚男
/// CreatDate:2023-3-27
/// Description：打开单条的数据
/// Table:CT.WDT.CDSS.HighQEMRConSym优质病历关联诊断因子表
/// Input：id
/// Return:Json格式的字符串
/// Other: w ##class(web.CDSS.CMKB.HighQEMRConSym).OpenData("9099")
ClassMethod OpenData(Id As %String) As %String
{
    s str="" 
    s obj=##class(CT.WDT.CDSS.HighQEMRConSym).%OpenId(Id)
    s bobj=##class(web.CDSSEntity.CMKB.HighQEMRConSym).%New()
    s bobj.RowId=Id
    if $IsObject(obj.EMRDR)
	{
	 	s bobj.EMRDR = obj.EMRDR.%Id()
	}         
    s bobj.EMRNode=obj.EMRNode 
    s bobj.SymptomNum=obj.SymptomNum
    s bobj.Symptom=obj.Symptom
    s bobj.Duration=obj.Duration          
    s bobj.AbnormalMax=obj.AbnormalMax 
    s bobj.AbnormalMin=obj.AbnormalMin
    s bobj.NormalMax= obj.NormalMax    
	s bobj.NormalMin= obj.NormalMin     
	s bobj.RangeUnit= obj.RangeUnit
    s bobj.RangeType= obj.RangeType	
    s bobj.Cause= obj.Cause     
    s bobj.SymptomType= obj.SymptomType       
    s bobj.SymptomFormal= obj.SymptomFormal 
    s bobj.SymptomCore= obj.SymptomCore    
	s bobj.SymProperty= obj.SymProperty     
	s bobj.SymptomChildren= obj.SymptomChildren
    if $IsObject(obj.PartDR)
	{
	 	s bobj.PartDR = obj.PartDR.%Id()
	} 
    if $IsObject(obj.PositionWordDR)
	{
	 	s bobj.PositionWordDR = obj.PositionWordDR.%Id()
	}  
    s bobj.Remarks= obj.Remarks    
    s str = bobj.JsonS()    
    d obj.%Close()
    q str
}

/// Creator:丁亚男
/// CreatDate:2023-04-14
/// Description:保存优质病历关联诊断因子表
/// Table: CT_WDT_CDSS.HighQEMRConSym
/// Input: eobj 优质病历关联诊断因子表实体对象
/// Return:
/// others:w ##class(web.CDSS.CMKB.HighQEMRConSym).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.HighQEMRConSym)
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{
		if (eobj.RowId="")  //如果RowId未赋值则增加
		{
			s obj=##class(CT.WDT.CDSS.HighQEMRConSym).%New()
		}
		else  //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.HighQEMRConSym).%OpenId(eobj.RowId)
			s bobj = ##class(web.CDSSEntity.CMKB.HighQEMRConSym).%New()
			s bobj.RowId=eobj.RowId
		    if $IsObject(obj.EMRDR)
			{
			 	s bobj.EMRDR = obj.EMRDR.%Id()
			}         
		    s bobj.EMRNode=obj.EMRNode 
		    s bobj.SymptomNum=obj.SymptomNum
		    s bobj.Symptom=obj.Symptom
		    s bobj.Duration=obj.Duration          
		    s bobj.AbnormalMax=obj.AbnormalMax 
		    s bobj.AbnormalMin=obj.AbnormalMin
		    s bobj.NormalMax= obj.NormalMax    
			s bobj.NormalMin= obj.NormalMin     
			s bobj.RangeUnit= obj.RangeUnit
		    s bobj.RangeType= obj.RangeType	
		    s bobj.Cause= obj.Cause     
		    s bobj.SymptomType= obj.SymptomType       
		    s bobj.SymptomFormal= obj.SymptomFormal 
		    s bobj.SymptomCore= obj.SymptomCore    
			s bobj.SymProperty= obj.SymProperty     
			s bobj.SymptomChildren= obj.SymptomChildren
		    if $IsObject(obj.PartDR)
			{
			 	s bobj.PartDR = obj.PartDR.%Id()
			} 
		    if $IsObject(obj.PositionWordDR)
			{
			 	s bobj.PositionWordDR = obj.PositionWordDR.%Id()
			}  
		    s bobj.Remarks= obj.Remarks  
			
		}
		d:eobj.EMRDR'="" obj.EMRDRSetObjectId(eobj.EMRDR)
		s obj.EMRNode=eobj.EMRNode 
	    s obj.SymptomNum=eobj.SymptomNum
	    s obj.Symptom=eobj.Symptom
	    s obj.Duration=eobj.Duration          
	    s obj.AbnormalMax=eobj.AbnormalMax 
	    s obj.AbnormalMin=eobj.AbnormalMin
	    s obj.NormalMax= eobj.NormalMax    
		s obj.NormalMin= eobj.NormalMin     
		s obj.RangeUnit= eobj.RangeUnit
	    s obj.RangeType= eobj.RangeType	
	    s obj.Cause= eobj.Cause     
	    s obj.SymptomType= eobj.SymptomType       
	    s obj.SymptomFormal= eobj.SymptomFormal 
	    s obj.SymptomCore= eobj.SymptomCore    
		s obj.SymProperty= eobj.SymProperty     
		s obj.SymptomChildren= eobj.SymptomChildren
		d:eobj.PartDR'="" obj.PartDRSetObjectId(eobj.PartDR)
		d:eobj.PositionWordDR'="" obj.PositionWordDRSetObjectId(eobj.PositionWordDR)  
	    s obj.Remarks= eobj.Remarks  
    
	    
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" 
			//保存日志
			d:eobj.RowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.HighQEMRConSym","CT.WDT.CDSS.HighQEMRConSym","优质病历关联诊断因子表",id,eobj.Symptom,"A",eobj)
			d:eobj.RowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.HighQEMRConSym","CT.WDT.CDSS.HighQEMRConSym","优质病历关联诊断因子表",eobj.RowId,eobj.Symptom,"U",eobj,bobj)	
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("优质病历关联诊断因子表","web.CDSS.CMKB.HighQEMRConSym","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"  
	} 
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("优质病历关联诊断因子表","web.CDSS.CMKB.HighQEMRConSym","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator:丁亚男
/// CreatDate:2023-04-14
/// Description:数据删除方法
/// Table: CT.WDT.CDSS.HighQEMRConSym
/// Input: id 
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.HighQEMRConSym).DeleteData("1")
ClassMethod DeleteData(id As %String)
{
	s result=""	
	Ts
	s obj=##class(CT.WDT.CDSS.HighQEMRConSym).%OpenId(id)
    s bobj=##class(web.CDSSEntity.CMKB.HighQEMRConSym).%New()
    s bobj.RowId=id
    if $IsObject(obj.EMRDR)
	{
	 	s bobj.EMRDR = obj.EMRDR.%Id()
	}        
    s bobj.EMRNode=obj.EMRNode 
    s bobj.SymptomNum=obj.SymptomNum
    s bobj.Symptom=obj.Symptom
    s bobj.Duration=obj.Duration          
    s bobj.AbnormalMax=obj.AbnormalMax 
    s bobj.AbnormalMin=obj.AbnormalMin
	s bobj.NormalMax= obj.NormalMax    
	s bobj.NormalMin= obj.NormalMin     
	s bobj.RangeUnit= obj.RangeUnit
    s bobj.RangeType= obj.RangeType	
    s bobj.Cause= obj.Cause     
    s bobj.SymptomType= obj.SymptomType       
    s bobj.SymptomFormal= obj.SymptomFormal 
    s bobj.SymptomCore= obj.SymptomCore    
	s bobj.SymProperty= obj.SymProperty     
	s bobj.SymptomChildren= obj.SymptomChildren
    if $IsObject(obj.PartDR)
	{
	 	s bobj.PartDR = obj.PartDR.%Id()
	} 
    if $IsObject(obj.PositionWordDR)
	{
	 	s bobj.PositionWordDR = obj.PositionWordDR.%Id()
	}  
    s bobj.Remarks= obj.Remarks 
		    
		
	s sc=##class(CT.WDT.CDSS.HighQEMRConSym).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.HighQEMRConSym","CT.WDT.CDSS.HighQEMRConSym","优质病历关联诊断因子表",id,bobj.Symptom,"D",bobj)
		d bobj.%Close()
	}
	else
	{
		Tro
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("优质病历关联诊断因子表","web.CDSS.CMKB.HighQEMRConSym","DeleteData",bobj)
       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
    
	q result
}

}
