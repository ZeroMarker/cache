/// 名称:优质病历关联诊断表
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 - 丁亚男
/// 编写日期:2023-3-27
Class web.CDSS.CMKB.HighQEMRConDia Extends %RegisteredObject
{

/// Creator：丁亚男	
/// CreatDate: 2023-3-27
/// Description：查询 
/// Table:CT.WDT.CDSS.HighQEMRConDia优质病历关联诊断表
/// Input:id, code,desc
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.HighQEMRConDia","GetList","","","肺炎","","","","1","","")
Query GetList(rowid As %String, EMRId As %String, DiagClass As %String, DiagName As %String) As %Query(ROWSPEC = "RowId,EMRDR,DiagnosisClass,DiagnosisName,DiagnosisSequence,IsMainDiagnosis,DiagnosisType,Remarks")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, EMRId As %String, DiagClass As %String, DiagName As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s RowId=rowid
		s EMRDR= $lg($g(^CT.WDT.CDSS.HighQEMRConDiaD(RowId)),2)      
		s DiagnosisClass= $lg($g(^CT.WDT.CDSS.HighQEMRConDiaD(RowId)),3)      
		s DiagnosisName= $lg($g(^CT.WDT.CDSS.HighQEMRConDiaD(RowId)),4)
	    s DiagnosisSequence= $lg($g(^CT.WDT.CDSS.HighQEMRConDiaD(RowId)),5) 	
	    s IsMainDiagnosis= $lg($g(^CT.WDT.CDSS.HighQEMRConDiaD(RowId)),6)     
	    s DiagnosisType= $lg($g(^CT.WDT.CDSS.HighQEMRConDiaD(RowId)),7)        
	    s Remarks= $lg($g(^CT.WDT.CDSS.HighQEMRConDiaD(RowId)),8) 
	        
		d OutputRow
	}
	elseif(EMRId'="")
	{
		if $d(^CT.WDT.CDSS.HighQEMRConDiaI("EMRDRIndex",EMRId))
		{
			s RowId=""
			for 
			{
				s RowId=$O(^CT.WDT.CDSS.HighQEMRConDiaI("EMRDRIndex",EMRId,RowId)) q:RowId=""
				s EMRDR= $lg($g(^CT.WDT.CDSS.HighQEMRConDiaD(RowId)),2)      
				s DiagnosisClass= $lg($g(^CT.WDT.CDSS.HighQEMRConDiaD(RowId)),3)      
				s DiagnosisName= $lg($g(^CT.WDT.CDSS.HighQEMRConDiaD(RowId)),4)
			    s DiagnosisSequence= $lg($g(^CT.WDT.CDSS.HighQEMRConDiaD(RowId)),5) 	
			    s IsMainDiagnosis= $lg($g(^CT.WDT.CDSS.HighQEMRConDiaD(RowId)),6)     
			    s DiagnosisType= $lg($g(^CT.WDT.CDSS.HighQEMRConDiaD(RowId)),7)        
			    s Remarks= $lg($g(^CT.WDT.CDSS.HighQEMRConDiaD(RowId)),8)
			    
			    if ((DiagClass="")||((DiagClass'="")&(DiagnosisClass=DiagClass)))&&((DiagnosisName[DiagName))
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
			s RowId=$O(^CT.WDT.CDSS.HighQEMRConDiaD(RowId)) q:RowId=""
			s EMRDR= $lg($g(^CT.WDT.CDSS.HighQEMRConDiaD(RowId)),2)      
			s DiagnosisClass= $lg($g(^CT.WDT.CDSS.HighQEMRConDiaD(RowId)),3)      
			s DiagnosisName= $lg($g(^CT.WDT.CDSS.HighQEMRConDiaD(RowId)),4)
		    s DiagnosisSequence= $lg($g(^CT.WDT.CDSS.HighQEMRConDiaD(RowId)),5) 	
		    s IsMainDiagnosis= $lg($g(^CT.WDT.CDSS.HighQEMRConDiaD(RowId)),6)     
		    s DiagnosisType= $lg($g(^CT.WDT.CDSS.HighQEMRConDiaD(RowId)),7)        
		    s Remarks= $lg($g(^CT.WDT.CDSS.HighQEMRConDiaD(RowId)),8)
		    
		    if ((DiagClass="")||((DiagClass'="")&(DiagnosisClass=DiagClass)))&&((DiagnosisName[DiagName))
		    {
			  d OutputRow  
			} 
		}
	}		
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(RowId,EMRDR,DiagnosisClass,DiagnosisName,DiagnosisSequence,IsMainDiagnosis,DiagnosisType,Remarks)
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
/// Table:CT.WDT.CDSS.HighQEMRConDia优质病历关联诊断表
/// Input：id
/// Return:Json格式的字符串
/// Other: w ##class(web.CDSS.CMKB.HighQEMRConDia).OpenData("9099")
ClassMethod OpenData(Id As %String) As %String
{
    s str="" 
    s obj=##class(CT.WDT.CDSS.HighQEMRConDia).%OpenId(Id)
    s bobj=##class(web.CDSSEntity.CMKB.HighQEMRConDia).%New()
    s bobj.RowId=Id
    if $IsObject(obj.EMRDR)
	{
	 	s bobj.EMRDR = obj.EMRDR.%Id()
	}         
    s bobj.DiagnosisClass=obj.DiagnosisClass 
    s bobj.DiagnosisName=obj.DiagnosisName
    s bobj.DiagnosisSequence=obj.DiagnosisSequence
    s bobj.IsMainDiagnosis=obj.IsMainDiagnosis          
    s bobj.DiagnosisType=obj.DiagnosisType 
    s bobj.Remarks=obj.Remarks
    
    s str = bobj.JsonS()    
    d obj.%Close()
    q str
}

/// Creator:丁亚男
/// CreatDate:2023-04-14
/// Description:保存优质病历关联诊断表
/// Table: CT_WDT_CDSS.HighQEMRConDia
/// Input: eobj 优质病历关联诊断表实体对象
/// Return:
/// others:w ##class(web.CDSS.CMKB.HighQEMRConDia).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.HighQEMRConDia)
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{
		if (eobj.RowId="")  //如果RowId未赋值则增加
		{
			s obj=##class(CT.WDT.CDSS.HighQEMRConDia).%New()
		}
		else  //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.HighQEMRConDia).%OpenId(eobj.RowId)
			s bobj = ##class(web.CDSSEntity.CMKB.HighQEMRConDia).%New()
			s bobj.RowId=eobj.RowId
		    if $IsObject(obj.EMRDR)
			{
			 	s bobj.EMRDR = obj.EMRDR.%Id()
			}         
		    s bobj.DiagnosisClass=obj.DiagnosisClass 
		    s bobj.DiagnosisName=obj.DiagnosisName
		    s bobj.DiagnosisSequence=obj.DiagnosisSequence
		    s bobj.IsMainDiagnosis=obj.IsMainDiagnosis          
		    s bobj.DiagnosisType=obj.DiagnosisType 
		    s bobj.Remarks=obj.Remarks
			
		}
		d:eobj.EMRDR'="" obj.EMRDRSetObjectId(eobj.EMRDR)
		s obj.DiagnosisClass=eobj.DiagnosisClass 
	    s obj.DiagnosisName=eobj.DiagnosisName
	    s obj.DiagnosisSequence=eobj.DiagnosisSequence
	    s obj.IsMainDiagnosis=eobj.IsMainDiagnosis          
	    s obj.DiagnosisType=eobj.DiagnosisType 
	    s obj.Remarks=eobj.Remarks
	    
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" 
			//保存日志
			d:eobj.RowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.HighQEMRConDia","CT.WDT.CDSS.HighQEMRConDia","优质病历关联诊断表",id,eobj.DiagnosisName,"A",eobj)
			d:eobj.RowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.HighQEMRConDia","CT.WDT.CDSS.HighQEMRConDia","优质病历关联诊断表",eobj.RowId,eobj.DiagnosisName,"U",eobj,bobj)	
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("优质病历关联诊断表","web.CDSS.CMKB.HighQEMRConDia","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"  
	} 
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("优质病历关联诊断表","web.CDSS.CMKB.HighQEMRConDia","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator:丁亚男
/// CreatDate:2023-04-14
/// Description:数据删除方法
/// Table: CT.WDT.CDSS.HighQEMRConDia
/// Input: id 
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.HighQEMRConDia).DeleteData("1")
ClassMethod DeleteData(id As %String)
{
	s result=""	
	Ts
	s obj=##class(CT.WDT.CDSS.HighQEMRConDia).%OpenId(id)
    s bobj=##class(web.CDSSEntity.CMKB.HighQEMRConDia).%New()
    s bobj.RowId=id
    if $IsObject(obj.EMRDR)
	{
	 	s bobj.EMRDR = obj.EMRDR.%Id()
	}        
    s bobj.DiagnosisClass=obj.DiagnosisClass 
    s bobj.DiagnosisName=obj.DiagnosisName
    s bobj.DiagnosisSequence=obj.DiagnosisSequence
    s bobj.IsMainDiagnosis=obj.IsMainDiagnosis          
    s bobj.DiagnosisType=obj.DiagnosisType 
    s bobj.Remarks=obj.Remarks
	
		
	s sc=##class(CT.WDT.CDSS.HighQEMRConDia).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.HighQEMRConDia","CT.WDT.CDSS.HighQEMRConDia","优质病历关联诊断表",id,bobj.DiagnosisName,"D",bobj)
		d bobj.%Close()
	}
	else
	{
		Tro
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("优质病历关联诊断表","web.CDSS.CMKB.HighQEMRConDia","DeleteData",bobj)
       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
    
	q result
}

}
