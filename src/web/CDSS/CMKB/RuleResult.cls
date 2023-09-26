/// Description：诊疗节点内容表（辅助诊疗-推荐辅助检验检查、推荐评估表、推荐护理措施、推荐治疗方案）
/// Table：CT.WDT.CDSS.RuleResult
Class web.CDSS.CMKB.RuleResult Extends %RegisteredObject
{

/// Creator:丁亚男
/// CreatDate:2021-01-08
/// Description:获得节点内容
/// Table: CT.WDT.CDSS.RuleResult
/// Input:节点id NodeDR
/// Return:返回节点的节点内容列表
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.RuleResult","GetList","538159","")
Query GetList(NodeDR As %String, desc As %String) As %Query(ROWSPEC = "NodeDR,ResultRowId,Sequence,RecommendType,RecommendResult,RecommendResultDesc,Remarks,BaseTable,TreatSource,SourceImg,RuleBasisDR")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, NodeDR As %String, desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	if (NodeDR="") q ""
 	s:desc'="" desc=$ZCONVERT(desc,"U")  //转换成大写
 	s:desc'="" desc=$tr(desc," ","")     //过滤空格
	s ResultRowId = ""
	for
	{
		s ResultRowId = $o(^CT.WDT.CDSS.RuleResultI("NodeDRIndex",NodeDR,ResultRowId),-1) q:ResultRowId=""
		
		s Sequence  = $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),3)
		s RecommendType  = $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),4)
		s RecommendResult  = $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),5)
		s RecommendResultDesc=""
		if (RecommendType="检验") 
		{
			s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.LabInspectionDictD(RecommendResult)),4)
		}
		elseif(RecommendType="检查")
		{
			s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.ExamDictD(RecommendResult)),4)
		}
		elseif(RecommendType="检验医嘱")
		{
			s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.LabOrdersDictD(RecommendResult)),3)
		}
		elseif(RecommendType="评估表")
		{
			s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.AssBaseD(RecommendResult)),3)
		}
		elseif(RecommendType="治疗方案")
		{
			s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.TreatDictD(RecommendResult)),3)
		}
		elseif((RecommendType="确诊诊断")||(RecommendType="鉴别诊断"))
		{
			s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.DiseaseDictD(RecommendResult)),3)
		}
		elseif((RecommendType="护理措施")||(RecommendType="护理处置"))
		{
			s RecommendResultDesc=$LISTGET($G(^CT.WDT.CDSS.NursingDictD(RecommendResult)),4)
		}elseif(RecommendType="文献"){
			s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.DocuManageD(RecommendResult)),3) //中文文献名称
		}elseif(RecommendType="出院指导"){
			s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.DischargeGuideD(RecommendResult)),2)
		}elseif(RecommendType="辅助计算"){
			s RecommendResultDesc=$lg($g(^CT.WDT.CDSS.TermD(RecommendResult)),3)
		}
		s Remarks  = $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),6)
		s BaseTable  = $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),7)
		s TreatSource  = $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),8)
		s RuleBasisDR  = $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),10)
		//读取流
		s obj=##class(CT.WDT.CDSS.RuleResult).%OpenId(ResultRowId)
		s Img  = obj.SourceImg //$lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),9)
		s len=Img.SizeGet()
        d Img.Rewind()
        s SourceImg=Img.Read(len)
		d obj.%Close()	
		k obj
 
    
		if ($ZCONVERT(RecommendResultDesc,"U")[desc)
		{
			d OutputRow
		}
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(NodeDR,ResultRowId,Sequence,RecommendType,RecommendResult,RecommendResultDesc,Remarks,BaseTable,TreatSource,SourceImg,RuleBasisDR)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCTPMExecute ]
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

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Function:用于实现数据校验功能的方法
/// Creator:基础数据平台组 丁亚男
/// CreateDate:2021-06-24   
/// w ##class(web.CDSS.CMKB.RuleComplication).FormValidate("","","")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, NodeDR As %String, RecommendType As %String, RecommendResult As %String) As %String
{
	if (NodeDR="")||(RecommendResult="") q ""
	
	s flag="",flagc=""
	s flagc=$d(^CT.WDT.CDSS.RuleResultI("NodeTypeResultIndex",NodeDR,RecommendType,RecommendResult)) 
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagc>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc=""
		s idc=$o(^CT.WDT.CDSS.RuleResultI("NodeTypeResultIndex",NodeDR,RecommendType,RecommendResult,0))
		if ((idc'="")&(idc'=id)&(flagc>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志

	}
	q flag
}

/*
/// Creator：丁亚男
/// CreatDate: 2021-01-06
/// Description：数据保存方法
/// Table：CT.WDT.CDSS.RuleResult
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.RuleResult).SaveEntity()
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.RuleResult) As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{ 
		s flag=..FormValidate(eobj.ResultRowId,eobj.NodeDR,eobj.RecommendType,eobj.RecommendResult)  //调用重复验证
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在'}"
			q result
		}
		if (eobj.ResultRowId="")  //如果RowId未赋值则增加
		{ 
			s obj=##class(CT.WDT.CDSS.RuleResult).%New()
		}
		else   //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.RuleResult).%OpenId(eobj.ResultRowId)
			s bobj = ##class(web.CDSSEntity.CMKB.RuleResult).%New() 
			if $IsObject(obj.NodeDR)
			{
			 	s bobj.NodeDR = obj.NodeDR.%Id()
			}
			s bobj.Sequence = obj.Sequence  
			s bobj.RecommendType = obj.RecommendType 
			s bobj.RecommendResult = obj.RecommendResult 
			s bobj.Remarks = obj.Remarks
			s bobj.BaseTable = obj.BaseTable
		}
		d:eobj.NodeDR'="" obj.NodeDRSetObjectId(eobj.NodeDR)
		s obj.Sequence = eobj.Sequence  
		s obj.RecommendType = eobj.RecommendType 
		s obj.RecommendResult = eobj.RecommendResult 
		s obj.Remarks = eobj.Remarks
		s obj.BaseTable = eobj.BaseTable
			
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" 
			//保存日志
			s RuleDR="",NodeNum="",RuleDesc="" 
			s:eobj.NodeDR'="" RuleDR=$LISTGET($G(^CT.WDT.CDSS.RuleNodeD(eobj.NodeDR)),2)
			s:eobj.NodeDR'="" NodeNum="节点"_$LISTGET($G(^CT.WDT.CDSS.RuleNodeD(eobj.NodeDR)),4)
			s:RuleDR'="" RuleDesc=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleDR)),3)
		
			d:eobj.ResultRowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.RuleResult","CT.WDT.CDSS.RuleResult","诊疗节点内容表(结论类)",id,RuleDesc_","_NodeNum_","_eobj.RecommendType,"A",eobj)
			d:eobj.ResultRowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.RuleResult","CT.WDT.CDSS.RuleResult","诊疗节点内容表(结论类)",eobj.ResultRowId,RuleDesc_","_NodeNum_","_eobj.RecommendType,"U",eobj,bobj)
			
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("诊疗节点内容表(结论类)","web.CDSS.CMKB.RuleResult","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"  
	} 
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("诊疗节点内容表(结论类)","web.CDSS.CMKB.RuleResult","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
} */
/// Creator：石萧伟
/// CreatDate: 2022-03-22
/// Description：数据保存方法
/// Table：CT.WDT.CDSS.RuleResult
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.RuleResult).SaveEntity()
ClassMethod SaveData(ResultRowId, NodeDR, Sequence, RecommendType, RecommendResult, Remarks, BaseTable, TreatSource, SourceImg, RuleBasisDR) As %String
{
	s $zt="ERROR"
	s result=""
	//保存日志
	s eobj = ##class(web.CDSSEntity.CMKB.RuleResult).%New() 
	s eobj.ResultRowId = ResultRowId
	s eobj.NodeDR = NodeDR
	s eobj.Sequence = Sequence
	s eobj.RecommendType = RecommendType
	s eobj.RecommendResult = RecommendResult
	s eobj.Remarks = Remarks
	s eobj.BaseTable = BaseTable
	s eobj.TreatSource = TreatSource
	s eobj.SourceImg = SourceImg
	s eobj.RuleBasisDR = RuleBasisDR
	if $IsObject(eobj)
	{ 
		s flag=..FormValidate(ResultRowId,NodeDR,RecommendType,RecommendResult)  //调用重复验证
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在'}"
			q result
		}
		if (eobj.ResultRowId="")  //如果RowId未赋值则增加
		{ 
			s obj=##class(CT.WDT.CDSS.RuleResult).%New() 
		}
		else   //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.RuleResult).%OpenId(eobj.ResultRowId)
			s bobj = ##class(web.CDSSEntity.CMKB.RuleResult).%New() 
			if $IsObject(obj.NodeDR)
			{
			 	s bobj.NodeDR = obj.NodeDR.%Id() 
			}
			s bobj.Sequence = obj.Sequence  
			s bobj.RecommendType = obj.RecommendType 
			s bobj.RecommendResult = obj.RecommendResult 
			s bobj.Remarks = obj.Remarks
			s bobj.BaseTable = obj.BaseTable
			s bobj.TreatSource = obj.TreatSource
			s bobj.SourceImg = obj.SourceImg
			if $IsObject(obj.RuleBasisDR)
			{
			 	s bobj.RuleBasisDR = obj.RuleBasisDR.%Id()
			}
		}
		d:eobj.NodeDR'="" obj.NodeDRSetObjectId(eobj.NodeDR)
		s obj.Sequence = eobj.Sequence  
		s obj.RecommendType = eobj.RecommendType 
		s obj.RecommendResult = eobj.RecommendResult 
		s obj.Remarks = eobj.Remarks
		s obj.BaseTable = eobj.BaseTable
		s obj.TreatSource = eobj.TreatSource
		d:eobj.RuleBasisDR'="" obj.RuleBasisDRSetObjectId(eobj.RuleBasisDR)
		//判断是否是流对象
		if ($isobject(SourceImg))
		{
			s ^TMP("SXWN")=SourceImg
			s obj.SourceImg=SourceImg
		}
		else
		{			
			s ImgStream=##class(%Stream.GlobalCharacter).%New()
	    	d ImgStream.Write(SourceImg)
	    	s obj.SourceImg=ImgStream
		}
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" 
			//保存日志
			s RuleDR="",NodeNum="",RuleDesc="" 
			s:eobj.NodeDR'="" RuleDR=$LISTGET($G(^CT.WDT.CDSS.RuleNodeD(eobj.NodeDR)),2)
			s:eobj.NodeDR'="" NodeNum="节点"_$LISTGET($G(^CT.WDT.CDSS.RuleNodeD(eobj.NodeDR)),4)
			s:RuleDR'="" RuleDesc=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleDR)),3)
		
			d:eobj.ResultRowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.RuleResult","CT.WDT.CDSS.RuleResult","诊疗节点内容表(结论类)",id,RuleDesc_","_NodeNum_","_eobj.RecommendType,"A",eobj)
			d:eobj.ResultRowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.RuleResult","CT.WDT.CDSS.RuleResult","诊疗节点内容表(结论类)",eobj.ResultRowId,RuleDesc_","_NodeNum_","_eobj.RecommendType,"U",eobj,bobj)
			
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("诊疗节点内容表(结论类)","web.CDSS.CMKB.RuleResult","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"  
	} 
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("诊疗节点内容表(结论类)","web.CDSS.CMKB.RuleResult","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator：丁亚男
/// CreatDate: 2021-01-05
/// Description：数据打开方法
/// Table：CT.WDT.CDSS.RuleResult
/// Input：RowId
/// Return:Json
/// Other: w ##class(web.CDSS.CMKB.RuleResult).OpenData("543813")
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s obj=##class(CT.WDT.CDSS.RuleResult).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.RuleResult).%New() 
	if $IsObject(obj.NodeDR)
	{
	 	s bobj.NodeDR = obj.NodeDR.%Id()
	}
	s bobj.Sequence = obj.Sequence  
	s bobj.RecommendType = obj.RecommendType 
	s bobj.RecommendResult = obj.RecommendResult 
	s bobj.Remarks = obj.Remarks
	s bobj.BaseTable = obj.BaseTable
	s bobj.TreatSource = obj.TreatSource
	if $IsObject(obj.RuleBasisDR)
	{
	 	s bobj.RuleBasisDR = obj.RuleBasisDR.%Id()
	}
	//读取流
	s ImgStream=obj.SourceImg
	
    s len=ImgStream.SizeGet()
    d ImgStream.Rewind()
    s bobj.SourceImg=ImgStream.Read(len)
	d obj.%Close()	
	k obj	
	
	s str = bobj.JsonS()	
	q str
}

/// Creator:丁亚男
/// CreatDate:2021-01-05
/// Description:数据删除方法
/// Table: CT.WDT.CDSS.RuleResult
/// Input: id 
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.RuleResult).DeleteData("1")
ClassMethod DeleteData(id As %String)
{
	s result=""
	Ts
	//删除关联截图数据
	s RuleBasisDR  = $lg($g(^CT.WDT.CDSS.RuleResultD(id)),10)
	if (RuleBasisDR'="")&&($d(^CT.WDT.CDSS.RuleBasisD(RuleBasisDR)))
	{
		s result=##class(web.CDSS.CMKB.RuleBasis).DeleteData(RuleBasisDR)
		if (result["false")
		{
			Tro	
			s result = "{success:'false',info:'诊疗节点内容（触发条件类）删除失败'}"  //返回错误信息
		}
	}
	
	s obj=##class(CT.WDT.CDSS.RuleResult).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.RuleResult).%New() 
	if $IsObject(obj.NodeDR)
	{
	 	s bobj.NodeDR = obj.NodeDR.%Id()
	}
	s bobj.Sequence = obj.Sequence  
	s bobj.RecommendType = obj.RecommendType 
	s bobj.RecommendResult = obj.RecommendResult 
	s bobj.Remarks = obj.Remarks
	s bobj.BaseTable = obj.BaseTable
	if $IsObject(obj.RuleBasisDR)
	{
	 	s bobj.RuleBasisDR = obj.RuleBasisDR.%Id()
	}
	s sc=##class(CT.WDT.CDSS.RuleResult).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		s RuleDR="",NodeNum="",RuleDesc="" 
		s:bobj.NodeDR'="" RuleDR=$LISTGET($G(^CT.WDT.CDSS.RuleNodeD(bobj.NodeDR)),2)
		s:bobj.NodeDR'="" NodeNum="节点"_$LISTGET($G(^CT.WDT.CDSS.RuleNodeD(bobj.NodeDR)),4)
		s:RuleDR'="" RuleDesc=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleDR)),3)
		
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.RuleResult","CT.WDT.CDSS.RuleResult","诊疗节点内容表(结论类)",id,RuleDesc_","_NodeNum_","_bobj.RecommendType,"D",bobj)
		d bobj.%Close()
	}
	else
	{
		Tro
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("诊疗节点内容表(结论类)","web.CDSS.CMKB.RuleResult","DeleteData",bobj)
       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
    
	q result
}

/// Creator：石萧伟
/// CreatDate: 2022-04-07
/// Description：获取来源类型及路径
/// Table：CT.WDT.CDSS.RuleResult
/// Input：id
/// Return:Json
/// Other: w ##class(web.CDSS.CMKB.RuleResult).GetFileTypeAndSource("15327")
ClassMethod GetFileTypeAndSource(id As %String)
{
		s result = ""
		s obj=##class(CT.WDT.CDSS.RuleResult).%OpenId(id)
		s Img  = obj.SourceImg //$lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),9)
		s len=Img.SizeGet()
        d Img.Rewind()
        s SourceImg=Img.Read(len)
        s RuleBasisDR = ""
        if $IsObject(obj.RuleBasisDR)
		{
		 	s RuleBasisDR = obj.RuleBasisDR.%Id()
		}
		s docName = obj.TreatSource
       	/*if ((SourceImg="")&(RuleBasisDR="")){
	       	s docName = obj.TreatSource
	    	s result = "{type:'doc',source:'"_docName_".pdf'}" 
	    }elseif(SourceImg'=""){
			s result = "{type:'img',source:'"_SourceImg_"'}" 
		}else{
			
		}*/
		
		s isExistDoc = ##class(web.DHCBL.BDP.BDPUploadFile).IsExistsFile("scripts\\bdp\\MKB\\Doc\\Doc\\"_docName_".pdf")
		s docSource = ""
		if (isExistDoc=1){
			s docSource = docName_".pdf"
		}
		s htmlSource = ""
		if (RuleBasisDR'=""){
			s htmlSource = ##class(web.CDSS.CMKB.RuleBasis).getRuleSource(RuleBasisDR)
		}
		s result = "[{type:'doc',source:'"_docSource_"'},{type:'img',source:'"_SourceImg_"'},{type:'html',source:'"_htmlSource_"'}]"
		d obj.%Close()	
		k obj	
		q result
}

/// Creator：石萧伟
/// CreatDate: 2022-04-08
/// Description：删除图片地址
/// Table：CT.WDT.CDSS.RuleResult
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.RuleResult).DelImgSource()
ClassMethod DelImgSource(ResultRowId) As %String
{
	s $zt="ERROR"
	s result=""
	//保存日志
	s SourceImg = ""
	s eobj = ##class(web.CDSSEntity.CMKB.RuleResult).%New() 
	s eobj.ResultRowId = ResultRowId
	s eobj.SourceImg = SourceImg
	
	if $IsObject(eobj)
	{ 

		s obj=##class(CT.WDT.CDSS.RuleResult).%OpenId(eobj.ResultRowId)
		s bobj = ##class(web.CDSSEntity.CMKB.RuleResult).%New() 
		if $IsObject(obj.NodeDR)
		{
		 	s bobj.NodeDR = obj.NodeDR.%Id() 
		}
		s bobj.Sequence = obj.Sequence  
		s bobj.RecommendType = obj.RecommendType 
		s bobj.RecommendResult = obj.RecommendResult 
		s bobj.Remarks = obj.Remarks
		s bobj.BaseTable = obj.BaseTable
		s bobj.TreatSource = obj.TreatSource
		s bobj.SourceImg = obj.SourceImg
		

		//判断是否是流对象
		if ($isobject(SourceImg))
		{
			s obj.SourceImg=SourceImg
		}
		else
		{			
			s ImgStream=##class(%Stream.GlobalCharacter).%New()
	    	d ImgStream.Write(SourceImg)
	    	s obj.SourceImg=ImgStream
		}
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" 
			//保存日志
			s RuleDR="",NodeNum="",RuleDesc="" 
			s:eobj.NodeDR'="" RuleDR=$LISTGET($G(^CT.WDT.CDSS.RuleNodeD(eobj.NodeDR)),2)
			s:eobj.NodeDR'="" NodeNum="节点"_$LISTGET($G(^CT.WDT.CDSS.RuleNodeD(eobj.NodeDR)),4)
			s:RuleDR'="" RuleDesc=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleDR)),3)
		
			d:eobj.ResultRowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.RuleResult","CT.WDT.CDSS.RuleResult","诊疗节点内容表(结论类)",id,RuleDesc_","_NodeNum_","_eobj.RecommendType,"A",eobj)
			d:eobj.ResultRowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.RuleResult","CT.WDT.CDSS.RuleResult","诊疗节点内容表(结论类)",eobj.ResultRowId,RuleDesc_","_NodeNum_","_eobj.RecommendType,"U",eobj,bobj)
			
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("诊疗节点内容表(结论类)","web.CDSS.CMKB.RuleResult","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"  
	} 
	q result
ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("诊疗节点内容表(结论类)","web.CDSS.CMKB.RuleResult","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator:石萧伟
/// CreatDate:2022-05-11
/// Input:RowId 治疗方案id，SourceId 来源表id
/// Return:
/// Other:w ##class(web.CDSS.CMKB.RuleComplication).ChangeSource("722","59")
ClassMethod ChangeSource(RowId, SourceId)
{
	s result="{success:'true'}"
	s eobj = ##class(web.CDSSEntity.CMKB.RuleResult).%New()	 	
 	s obj=##class(CT.WDT.CDSS.RuleResult).%OpenId(RowId)
 	s bobj = ##class(web.CDSSEntity.CMKB.RuleResult).%New()
 	s eobj.RuleBasisDR = SourceId
	if $IsObject(obj.RuleBasisDR)
	{
	 	s bobj.RuleBasisDR = obj.RuleBasisDR.%Id()
	}
	d:eobj.RuleBasisDR'="" obj.RuleBasisDRSetObjectId(eobj.RuleBasisDR)
 	Ts
 	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{
		Tc
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
		//保存日志 描述拼接操作，在日志中读取显示
		//d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.RuleRationality","CT.WDT.CDSS.RuleRationality","诊疗节点内容表(合理性预警)",RowId,obj.WarningContent,"U",eobj,bobj)  
		
	}
	else
	{
		Trollback
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		//s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("诊疗节点内容表(合理性预警)","web.CDSS.CMKB.RuleRationality","ChangeSource",eobj)
   		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

/// Creator:石萧伟
/// CreatDate:2022-05-11
/// Input:RowId 治疗方案id，docs文献串
/// Return:
/// Other:w ##class(web.CDSS.CMKB.RuleComplication).ChangeDocs("722","59")
ClassMethod ChangeDocs(RowId, docs)
{
	s result="{success:'true'}"
	s eobj = ##class(web.CDSSEntity.CMKB.RuleResult).%New()	 	
 	s obj=##class(CT.WDT.CDSS.RuleResult).%OpenId(RowId)
 	s bobj = ##class(web.CDSSEntity.CMKB.RuleResult).%New()
 	s eobj.TreatSource = docs
	s bobj.TreatSource = obj.TreatSource
	s obj.TreatSource = eobj.TreatSource
 	Ts
 	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{
		Tc
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
		//保存日志 描述拼接操作，在日志中读取显示
		//d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.RuleRationality","CT.WDT.CDSS.RuleRationality","诊疗节点内容表(合理性预警)",RowId,obj.WarningContent,"U",eobj,bobj)  
		
	}
	else
	{
		Trollback
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		//s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("诊疗节点内容表(合理性预警)","web.CDSS.CMKB.RuleRationality","ChangeSource",eobj)
   		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

/// Creator:丁亚男
/// CreatDate:2023-04-21
/// Description:将检验项目换成检验医嘱
/// Table:CT.WDT.CDSS.RuleResult
/// Input:FilePath-csv文件，注意需要先在Excel里把英文,转换成中文，再转为csv文件
/// Return:
/// Other:w ##class(web.CDSS.CMKB.RuleResult).ImportLabOrders("D:\询证规则推荐检验替换成检验医嘱.csv")
ClassMethod ImportLabOrders(FilePath As %String) As %String
{
	q:FilePath="" "false^文件路径为空！"
	s file=##class(%File).%New(FilePath)
	d file.Open("RS")
	s NewFilePath=$p(FilePath,".",1)_"导入结果.csv"
	s Wfile=##class(%File).%New(NewFilePath)
	d Wfile.Open("NWS")
	s result=""
	
	s NewLine=file.ReadLine()_",导入标识"
	d Wfile.WriteLine(NewLine)
	
	s count=1
	while 'file.AtEnd
	{
		s Line=file.Read()
		continue:Line=""
		s count=count+1
		//保存检验医嘱
		s RuleDesc=$p(Line,",",1)  //规则名称
		s LabName=$p(Line,",",4)  //检验项目名称
		s LabOrderName=$p(Line,",",5)  //检验医嘱名称
		s LabOrderDR=""
		if ($d(^CT.WDT.CDSS.LabOrdersDictI("DescIndex"," "_$ZCONVERT(LabOrderName,"U"))))
		{
			s LabOrderDR=$o(^CT.WDT.CDSS.LabOrdersDictI("DescIndex"," "_$ZCONVERT(LabOrderName,"U"),0))
		}
		if (LabOrderDR="")
		{
			s eobj = ##class(web.CDSSEntity.CMKB.LabOrdersDict).%New()
			s eobj.LabOrdersCode=##class(web.CDSS.CMKB.LabOrdersDict).GetCode()			//代码
			s eobj.LabOrdersDesc =LabOrderName			//描述
			s eobj.UseFlag=2						//状态（0已审核，1编辑中,2已弃用）
			s eobj.UpdateUser="丁亚男"					//编辑人员
			s eobj.Remarks=""
			s labresult=##class(web.CDSS.CMKB.LabOrdersDict).SaveData(eobj)
			if (labresult["true")
			{
				s LabOrderDR=$p(labresult,"'",4)
			}
			else
			{
				s NewLine=file.ReadLine()_",检验医嘱新增失败"
				d Wfile.WriteLine(NewLine)
				
			}
		}
		continue:LabOrderDR=""
		s LabDR=$o(^CT.WDT.CDSS.LabInspectionDictI("NameIndex"," "_$ZCONVERT(LabName,"U"),0))
		if (LabDR="")
		{
			s NewLine=file.ReadLine()_",检验项目数据不存在"
			d Wfile.WriteLine(NewLine)
			continue
		}
		
		s RuleDR=0
		for
		{
			s RuleDR=$o(^CT.WDT.CDSS.RuleDictI("DescIndex"," "_RuleDesc,RuleDR)) q:RuleDR=""
			s NodeDR=0
			for
			{
				s NodeDR=$o(^CT.WDT.CDSS.RuleNodeI("RuleDRNodeTypeIndex",RuleDR,8,NodeDR)) q:NodeDR=""   //8--推荐检验检查
				s ResultRowId = 0
				for
				{
					s ResultRowId = $o(^CT.WDT.CDSS.RuleResultI("NodeTypeResultIndex",NodeDR,"检验",LabDR,ResultRowId)) q:ResultRowId=""
					if ($d(^CT.WDT.CDSS.RuleResultI("NodeTypeResultIndex",NodeDR,"检验医嘱",LabOrderDR)))
					{
						s orgResultRowId=$o(^CT.WDT.CDSS.RuleResultI("NodeTypeResultIndex",NodeDR,"检验医嘱",LabOrderDR,""))
						s obj=##class(CT.WDT.CDSS.RuleResult).%OpenId(orgResultRowId)
						s:obj.Remarks'="" obj.Remarks=obj.Remarks_"  "_LabName
						s:obj.Remarks="" obj.Remarks=LabName
						s sc=obj.%Save()
						d obj.%Close()
						
						s delresult=..DeleteData(ResultRowId)
						if (delresult["true")
						{
							s NewLine=file.ReadLine()_",已存在该推荐数据，此数据已删除"
						}
						else
						{
							s NewLine=file.ReadLine()_",已存在该推荐数据，此数据删除失败"
						}
					}
					else
					{
						s obj=##class(CT.WDT.CDSS.RuleResult).%OpenId(ResultRowId)
						s obj.RecommendType = "检验医嘱"
						s obj.RecommendResult = LabOrderDR
						s sc=obj.%Save()
						d obj.%Close()
						s NewLine=file.ReadLine()_",已改成此检验医嘱"
					}
					
				}
			}
		}
		d Wfile.WriteLine(NewLine)
		
	}
	d Wfile.%Save()
	d Wfile.%Close()
	d file.%Close()
	q result
}

/// Creator:赵文伟·
/// CreatDate:2023-05-05
/// Description: 获取文献引用信息
/// Input: desc 文献名称
/// Return: 
/// Other:w ##class(web.CDSS.CMKB.RuleResult).GetDocuRefFlag("磁共振影像标志物对椎间盘退变及盘源性下腰痛诊断的研究进展")
ClassMethod GetDocuRefFlag(desc)
{
	s RuleDescStr=""
	s rulestr={}
	if ($d(^CT.WDT.CDSS.RuleResultI("TreatSourceIndex",desc)))
	{
		s ResultRowId=""
		for{
			s ResultRowId=$o(^CT.WDT.CDSS.RuleResultI("TreatSourceIndex",desc,ResultRowId),-1)
			q:ResultRowId=""
			s NodeDR = $lg($g(^CT.WDT.CDSS.RuleResultD(ResultRowId)),2)
			if (NodeDR'="")
			{
				s RuleDR=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeDR)),2)
				s RuleDesc=""
				if (RuleDR'="")
				{
					s RuleDesc=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleDR)),3)
					s flag=rulestr.%Get(RuleDesc)
			 		if (flag=""){
				 		d rulestr.%Set(RuleDesc,RuleDesc)
				 		s:RuleDescStr'="" RuleDescStr=RuleDescStr_","_RuleDesc
						s:RuleDescStr="" RuleDescStr=RuleDesc
			 		}
					
				}
			}
		}
	}
	q RuleDescStr
}

}
