/// 名称:评估表基础信息表维护界面
/// 描述:包含增删改查功能
/// 编写者:基础数据平台 - Xuwenhu
/// 编写日期:2021-03-19
Class web.CDSS.Access.AssBasicInfo Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：Xuwenhu 		
/// CreatDate: 2021-04-14
/// Description：查询数据 
/// Table:CT.WDT.CDSS.AssBasicInfo 
/// Input:rowid, assdesc(评估表名称),displayname(展示名),linkurl(第三方URL),remark(备注)
/// Output:RowId,AssDR,AssDesc,DataType,DataValue
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.Access.AssBasicInfo","GetList","","","")
Query GetList(rowid As %String, assdr As %String, displayname As %String, linkurl As %String, remark As %String) As %Query(ROWSPEC = "RowId,AssDR,AssDesc,DocSource,DisplayName,LinkURL,DocumentID,StartDate,EndDate,PageHeader,PageFooter,ResultExplain,RelatedExplain,Remark,VisitType,ShowScoreFlag,ShowResultFlag,ShowConclusionFlag,ScoreCalculateType,BaseFlag,ShowPriority")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, assdr As %String, displayname As %String, linkurl As %String, remark As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //获取授权
    //s AuStr=##class(web.DHCBL.Authorize.DHCPHLibaryAssessel).DHCGetDataByDefaultSession()
    //s AuFlag=0
    //if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s ID=rowid
        s AssDR=$lg($g(^CT.WDT.CDSS.AssBasicInfoD(ID)),2) 		//评估表ID
        s AssDesc=$lg($g(^CT.WDT.CDSS.AssBaseD(AssDR)),3) 	//评估表名称
        s DocSource=$lg($g(^CT.WDT.CDSS.AssBasicInfoD(ID)),3)	//文献出处
        s DisplayName=$lg($g(^CT.WDT.CDSS.AssBasicInfoD(ID)),4)	// 展示名
        s LinkURL=$lg($g(^CT.WDT.CDSS.AssBasicInfoD(ID)),5)		// 第三方URL
        s DocumentID=$lg($g(^CT.WDT.CDSS.AssBasicInfoD(ID)),6)	// 第三方评估表ID
        s StartDate=$lg($g(^CT.WDT.CDSS.AssBasicInfoD(ID)),7)	// 开始日期
        s EndDate=$lg($g(^CT.WDT.CDSS.AssBasicInfoD(ID)),8)		// 结束日期
        s PageHeader=$lg($g(^CT.WDT.CDSS.AssBasicInfoD(ID)),9)	// 页眉
        s PageFooter=$lg($g(^CT.WDT.CDSS.AssBasicInfoD(ID)),10)	// 页脚
        s ResultExplain=$lg($g(^CT.WDT.CDSS.AssBasicInfoD(ID)),11)	// 结果解读
        s RelatedExplain=$lg($g(^CT.WDT.CDSS.AssBasicInfoD(ID)),12)	// 相关解释
        s Remark=$lg($g(^CT.WDT.CDSS.AssBasicInfoD(ID)),13)			// 备注
        s VisitType=$lg($g(^CT.WDT.CDSS.AssBasicInfoD(ID)),14)	// 就诊类型(门诊-O、住院-I、体检-H、急诊-E、全部-空,多选,连接)(门诊，住院，全部)
        s VisitType=..VisitTypeCase(VisitType)		
        s ShowScoreFlag=$lg($g(^CT.WDT.CDSS.AssBasicInfoD(ID)),15)		//是否显示总分(1-不显示或空，0-显示)
       	s ShowResultFlag=$lg($g(^CT.WDT.CDSS.AssBasicInfoD(ID)),16)		//是否显示评估结果(1-不显示或空，0-显示)
       	s ShowConclusionFlag=$lg($g(^CT.WDT.CDSS.AssBasicInfoD(ID)),17)		//是否显示结论(1-不显示或空，0-显示)
       	s ScoreCalculateType=$lg($g(^CT.WDT.CDSS.AssBasicInfoD(ID)),18)		//评分结果计算类型(Sum-累加；Avg-计算平均值；Max-取所有选项最大值。默认值是累加)
       	s ShowRatingUser=$lg($g(^CT.WDT.CDSS.AssBasicInfoD(ID)),19)		//历史记录是否显示评定人
        s BaseFlag=$lg($g(^CT.WDT.CDSS.AssBasicInfoD(ID)),20)			//是否基础评估表
        s ShowPriority=$lg($g(^CT.WDT.CDSS.AssBasicInfoD(ID)),22)			//展示优先级
        d OutputRow
    }
    else
    {
		s:linkurl'="" linkurl=$ZCONVERT(linkurl,"U") //转换成大写
		s:displayname'="" displayname=$ZCONVERT(displayname,"U") //转换成大写
		s:remark'="" remark=$ZCONVERT(remark,"U") //转换成大写
        s RowId=0
        for {
            s RowId=$o(^CT.WDT.CDSS.AssBasicInfoD(RowId))
			q:RowId=""
			s AssDR=$lg($g(^CT.WDT.CDSS.AssBasicInfoD(RowId)),2) 		//评估表ID
			continue:((assdr'="")&&(AssDR'=assdr))
        	s AssDesc=$lg($g(^CT.WDT.CDSS.AssBaseD(AssDR)),3) 		//评估表名称
        	s DocSource=$lg($g(^CT.WDT.CDSS.AssBasicInfoD(RowId)),3)		//文献出处
        	s DisplayName=$lg($g(^CT.WDT.CDSS.AssBasicInfoD(RowId)),4)	// 展示名
        	continue:((displayname'="")&&($ZCONVERT(DisplayName,"U")'[displayname))
        	s LinkURL=$lg($g(^CT.WDT.CDSS.AssBasicInfoD(RowId)),5)		// 第三方URL
        	continue:((linkurl'="")&&($ZCONVERT(LinkURL,"U")'[linkurl))
        	s DocumentID=$lg($g(^CT.WDT.CDSS.AssBasicInfoD(RowId)),6)	// 第三方评估表ID
        	s StartDate=$lg($g(^CT.WDT.CDSS.AssBasicInfoD(RowId)),7)		// 开始日期
        	s:StartDate'="" StartDate=$ZD(StartDate,3)
        	s EndDate=$lg($g(^CT.WDT.CDSS.AssBasicInfoD(RowId)),8)		// 结束日期
        	s:EndDate'="" EndDate=$ZD(EndDate,3)
        	s PageHeader=$lg($g(^CT.WDT.CDSS.AssBasicInfoD(RowId)),9)	// 页眉
        	s PageFooter=$lg($g(^CT.WDT.CDSS.AssBasicInfoD(RowId)),10)	// 页脚
        	s ResultExplain=$lg($g(^CT.WDT.CDSS.AssBasicInfoD(RowId)),11)	// 结果解读
        	s RelatedExplain=$lg($g(^CT.WDT.CDSS.AssBasicInfoD(RowId)),12)	// 相关解释
        	s Remark=$lg($g(^CT.WDT.CDSS.AssBasicInfoD(RowId)),13)			// 备注
        	continue:((remark'="")&&($ZCONVERT(Remark,"U")'[remark))
        	s VisitType=$lg($g(^CT.WDT.CDSS.AssBasicInfoD(RowId)),14)			//就诊类型(门诊-O、住院-I、体检-H、急诊-E、全部-空,多选,连接)(门诊，住院，全部)
        	s VisitType=..VisitTypeCase(VisitType)
        	s ShowScoreFlag=$lg($g(^CT.WDT.CDSS.AssBasicInfoD(RowId)),15)		//是否显示总分(1-不显示或空，0-显示)
       		s ShowResultFlag=$lg($g(^CT.WDT.CDSS.AssBasicInfoD(RowId)),16)			//是否显示评估结果(1-不显示或空，0-显示)
       		s ShowConclusionFlag=$lg($g(^CT.WDT.CDSS.AssBasicInfoD(RowId)),17)		//是否显示结论(1-不显示或空，0-显示)
       		s ScoreCalculateType=$lg($g(^CT.WDT.CDSS.AssBasicInfoD(RowId)),18)		//评分结果计算类型(Sum-累加；Avg-计算平均值；Max-取所有选项最大值。默认值是累加)
        	s ShowRatingUser=$lg($g(^CT.WDT.CDSS.AssBasicInfoD(RowId)),19)			//历史记录是否显示评定人
			s BaseFlag=$lg($g(^CT.WDT.CDSS.AssBasicInfoD(ID)),20)					//是否基础评估表
			s ShowPriority=$lg($g(^CT.WDT.CDSS.AssBasicInfoD(ID)),22)				//展示优先级
			d OutputRow
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(RowId,AssDR,AssDesc,DocSource,DisplayName,LinkURL,DocumentID,StartDate,EndDate,PageHeader,PageFooter,ResultExplain,RelatedExplain,Remark,VisitType,ShowScoreFlag,ShowResultFlag,ShowConclusionFlag,ScoreCalculateType,BaseFlag,ShowPriority)
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

/// Creator：dingyanan
/// CreatDate:2021-03-31
/// Description：数据重复验证方法
/// Table：CT.WDT.CDSS.AssBasicInfo
/// Input：id,desc(描述)
/// Return："1"(数据重复),"0"(数据不重复)
/// other:w ##class(web.CDSS.Access.AssBasicInfo).FormValidate("","")
ClassMethod FormValidate(id As %String, AssDR As %String) As %String
{
	if (AssDR="") q ""
	s flag="",flagc=""
	s flagc=$d(^CT.WDT.CDSS.AssBasicInfoI("AssIndex",AssDR))
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagc>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc=""
		s:AssDR'="" idc=$o(^CT.WDT.CDSS.AssBasicInfoI("AssIndex",AssDR,0))
		if (idc'=id)&(flagc>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	q flag
}

/// Creator:Xuwenhu
/// CreatDate:2021-04-14
/// Description：保存评估表基础信息和评估表关联科室表的内容
/// Table：CT.WDT.CDSS.AssBasicInfo
/// Input：web.CDSSEntity.Access.AssBasicInfo 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.CDSS.Access.AssBasicInfo).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.Access.AssBasicInfo) As %String
{
   	s $zt="ERROE"
    s result="",flag=""
    if $IsObject(eobj)
    {   
        s flag=..FormValidate(eobj.RowId,eobj.AssDR)  //调用重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在！'}"
        }
        else
        {
            if (eobj.RowId="")  //如果RowId未赋值则增加
            {
                s obj=##class(CT.WDT.CDSS.AssBasicInfo).%New()             
            }
            else                     //如果RowId已赋值则修改
            {
                s obj=##class(CT.WDT.CDSS.AssBasicInfo).%OpenId(eobj.RowId) 				
                
                s bobj = ##class(web.CDSSEntity.Access.AssBasicInfo).%New()
				s bobj.AssDR=obj.AssDR.%Id()				//评估表名称
        		s bobj.DocSource=obj.DocSource				//文献出处
        		s bobj.DisplayName=obj.DisplayName			// 展示名
        		s bobj.LinkURL=obj.LinkURL					// 第三方URL
        		s bobj.DocumentID=obj.DocumentID			// 第三方评估表ID
        		s bobj.StartDate=obj.StartDate				// 开始日期
        		s bobj.EndDate=obj.EndDate					// 结束日期
        		s bobj.PageHeader=obj.PageHeader			// 页眉
        		s bobj.PageFooter=obj.PageFooter			// 页脚
        		s bobj.ResultExplain=obj.ResultExplain		// 结果解读
        		s bobj.RelatedExplain=obj.RelatedExplain	// 相关解释
        		s bobj.Remark=obj.Remark					// 备注
        		s bobj.VisitType=obj.VisitType				// 就诊类型(门诊-O、住院-I、体检-H、急诊-E、全部-空,多选,连接)
        		s bobj.ShowScoreFlag=obj.ShowScoreFlag				// 是否显示总分
        		s bobj.ShowResultFlag=obj.ShowResultFlag			//是否显示评估结果
        		s bobj.ShowConclusionFlag=obj.ShowConclusionFlag	//是否显示结论
        		s bobj.ScoreCalculateType=obj.ScoreCalculateType	//评分结果计算类型
        		s bobj.ShowRatingUser=obj.ShowRatingUser			//历史记录是否显示评定人
        		s bobj.BaseFlag=obj.BaseFlag						//是否基础评估表
        		s bobj.AliasName=obj.AliasName						//别名
				s bobj.ShowPriority=obj.ShowPriority				//展示优先级
            }
            Ts
            d obj.AssDRSetObjectId(eobj.AssDR)			//评估表名称
			s obj.DocSource=eobj.DocSource				//文献出处
        	s obj.DisplayName=eobj.DisplayName			// 展示名
        	s obj.LinkURL=eobj.LinkURL					// 第三方URL
        	s obj.DocumentID=eobj.DocumentID			// 第三方评估表ID
        	
			s obj.StartDate = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.StartDate)	// 开始日期
        	s obj.EndDate = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.EndDate)		// 结束日期
        	
        	s obj.PageHeader=eobj.PageHeader			// 页眉
        	s obj.PageFooter=eobj.PageFooter			// 页脚
        	s obj.ResultExplain=eobj.ResultExplain		// 结果解读
        	s obj.RelatedExplain=eobj.RelatedExplain	// 相关解释
        	s obj.Remark=eobj.Remark					// 备注
        	s obj.VisitType=eobj.VisitType				// 就诊类型(门诊-O、住院-I、体检-H、急诊-E、全部-空,多选,连接)
        	s obj.ShowScoreFlag=eobj.ShowScoreFlag		// 是否显示总分
        	s obj.ShowResultFlag=eobj.ShowResultFlag			//是否显示评估结果
        	s obj.ShowConclusionFlag=eobj.ShowConclusionFlag	//是否显示结论
        	s obj.ScoreCalculateType=eobj.ScoreCalculateType	//评分结果计算类型
        	s obj.ShowRatingUser=eobj.ShowRatingUser			//历史记录是否显示评定人
        	s obj.BaseFlag=eobj.BaseFlag						//是否基础评估表
			s obj.AliasName=eobj.AliasName 						//别名
			s obj.ShowPriority=eobj.ShowPriority				//展示优先级
			
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc)
            {
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}"  //返回RowId
                //保存日志
				d:eobj.RowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.AssBasicInfo","CT.WDT.CDSS.AssBasicInfo","评估表基本信息表",id,eobj.AssDR,"A",eobj)
				d:eobj.RowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.AssBasicInfo","CT.WDT.CDSS.AssBasicInfo","评估表基本信息表",eobj.RowId,eobj.AssDR,"U",eobj,bobj)
            	//如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表
	            if ((eobj.RowId="")&&(eobj.AliasName'=""))||((eobj.RowId'="")&&(eobj.AliasName'=bobj.AliasName))
	            {
	            	d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.AssBasicInfo",id,eobj.AliasName)
	            }
            }
            else
            {
                Trollback
                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
                s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("评估表基本信息表","web.CDSS.Access.AssBasicInfo","SaveData",eobj)
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
	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("评估表基本信息表","web.CDSS.Access.AssBasicInfo","SaveData",eobj)
 	s ^ERRORLOGINFO(logid)=$ze 
    q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator:Xuwenhu
/// CreatDate:2021-04—14
/// Description：根据ID删除评估表基本信息表的内容
/// Table：CT.WDT.CDSS.AssBasicInfo
/// Input：id-评估表基本信息表的rowid
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.CDSS.Access.AssBasicInfo).DeleteData("7")
ClassMethod DeleteData(id As %String) As %String
{
    s result=""  
    s obj=##class(CT.WDT.CDSS.AssBasicInfo).%OpenId(id)  
    s bobj = ##class(web.CDSSEntity.Access.AssBasicInfo).%New()
    s bobj.RowId=id
	s bobj.AssDR=obj.AssDR.%Id() 			 //评估表名称
	s bobj.DocSource=obj.DocSource				//文献出处
    s bobj.DisplayName=obj.DisplayName			// 展示名
    s bobj.LinkURL=obj.LinkURL					// 第三方URL
    s bobj.DocumentID=obj.DocumentID			// 第三方评估表ID
    s bobj.StartDate=obj.StartDate				// 开始日期
    s bobj.EndDate=obj.EndDate					// 结束日期
    s bobj.PageHeader=obj.PageHeader			// 页眉
    s bobj.PageFooter=obj.PageFooter			// 页脚
    s bobj.ResultExplain=obj.ResultExplain		// 结果解读
    s bobj.RelatedExplain=obj.RelatedExplain	// 相关解释
    s bobj.Remark=obj.Remark					// 备注
    s bobj.VisitType=obj.VisitType						// 就诊类型(门诊-O、住院-I、体检-H、急诊-E、全部-空,多选,连接)
    s bobj.ShowScoreFlag=obj.ShowScoreFlag				// 是否显示总分
    s bobj.ShowResultFlag=obj.ShowResultFlag			//是否显示评估结果
    s bobj.ShowConclusionFlag=obj.ShowConclusionFlag	//是否显示结论
    s bobj.ScoreCalculateType=obj.ScoreCalculateType	//评分结果计算类型
    s bobj.ShowRatingUser=obj.ShowRatingUser			//历史记录是否显示评定人
    s bobj.BaseFlag=obj.BaseFlag						//是否基础评估表
    s bobj.AliasName=obj.AliasName						//别名
    s bobj.ShowPriority=obj.ShowPriority				//展示优先级
    
	d obj.%Close()
    k obj
    Tstart
    s sc=##class(CT.WDT.CDSS.AssBasicInfo).%DeleteId(id)
    if $$$ISOK(sc)
    {
        Tcommit
        s result = "{success:'true',info:'删除成功！'}"  
        d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.AssBasicInfo","CT.WDT.CDSS.AssBasicInfo","评估表基本信息表",id,bobj.RowId,"D",bobj)
        //删除别名通用表中数据 2022-10-09 
        d ##class(web.CDSS.CMKB.Alias).DeleteAlias("CT.WDT.CDSS.AssBasicInfo",id)
        d bobj.%Close()   
    }
    else 
    {
        Trollback
        s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
        s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("评估表基本信息表","web.CDSS.Access.AssBasicInfo","DeleteData",bobj)
        s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
     }
     q result
}

/// Creator：Xuwenhu
/// CreatDate: 2021-4-14
/// Description：数据打开方法
/// Table：CT.WDT.CDSS.AssBasicInfo
/// Input：RowId
/// Return:Json
/// Other: w ##class(web.CDSS.Access.AssBasicInfo).OpenData("3")
ClassMethod OpenData(id As %String) As %String
{
	
	s str=""	
	s obj=##class(CT.WDT.CDSS.AssBasicInfo).%OpenId(id)  
    s bobj = ##class(web.CDSSEntity.Access.AssBasicInfo).%New()
    s bobj.RowId=id
	s bobj.AssDR=obj.AssDR.%Id() 				//评估表名称
	s bobj.DocSource=obj.DocSource				//文献出处
    s bobj.DisplayName=obj.DisplayName			// 展示名
    s bobj.LinkURL=obj.LinkURL					// 第三方URL
    s bobj.DocumentID=obj.DocumentID			// 第三方评估表ID
    s:obj.StartDate'="" bobj.StartDate=$ZD(obj.StartDate,3)		// 开始日期
    s:obj.EndDate'="" bobj.EndDate=$ZD(obj.EndDate,3)			// 结束日期
    s bobj.PageHeader=obj.PageHeader			// 页眉
    s bobj.PageFooter=obj.PageFooter			// 页脚
    s bobj.ResultExplain=obj.ResultExplain		// 结果解读
    s bobj.RelatedExplain=obj.RelatedExplain	// 相关解释
    s bobj.Remark=obj.Remark					// 备注		
   	s bobj.VisitType=obj.VisitType						// 就诊类型(门诊-O、住院-I、体检-H、急诊-E、全部-空,多选,连接)
   	s:obj.VisitType="" bobj.VisitType="O,I,H,E"	
    s bobj.ShowScoreFlag=obj.ShowScoreFlag				// 是否显示总分
    s bobj.ShowResultFlag=obj.ShowResultFlag			// 是否显示评估结果
    s bobj.ShowConclusionFlag=obj.ShowConclusionFlag	// 是否显示结论
    s bobj.ScoreCalculateType=obj.ScoreCalculateType	// 评分结果计算类型
    s bobj.ShowRatingUser=obj.ShowRatingUser			//历史记录是否显示评定人
    s bobj.BaseFlag=obj.BaseFlag						//是否基础评估表
    s bobj.AliasName=obj.AliasName						//别名
    s bobj.ShowPriority=obj.ShowPriority				//展示优先级
	d obj.%Close()		
	k obj	
	
	s str = bobj.JsonS()	
	q str
}

/// Creator：Xuwenhu
/// CreatDate: 2021-4-23
/// Description：根据评估表id获取基础信息表id
/// Table：CT.WDT.CDSS.AssBasicInfo
/// Input：RowId
/// Return:Json
/// Other: w ##class(web.CDSS.Access.AssBasicInfo).OpenData("3")
ClassMethod GetBasicId(id As %String) As %String
{
	q:id="" ""
	s BasicID=$o(^CT.WDT.CDSS.AssBasicInfoI("AssIndex",id,0))	
	q BasicID
}

/// Creator：Xuwenhu
/// CreatDate: 2021-3-19
/// Description：数据打开方法
/// Table：CT.WDT.CDSS.AssBasicInfo
/// Input：RowId
/// Return:Json
/// Other: w ##class(web.CDSS.Access.AssBasicInfo).VisitTypeCase("")
ClassMethod VisitTypeCase(visit As %String) As %String
{
	//就诊类型(门诊-O、住院-I、体检-H、急诊-E、全部-空,多选,连接)
	s VisitStr=""	
	if visit'=""
	{
		if visit["O"
		{
			s VisitStr="门诊"
		}
		else
		{
			s VisitStr=""	
		}
		if visit["I"
		{
			if VisitStr=""
			{
				s VisitStr="住院"
			}
			else
			{
				s VisitStr=VisitStr_","_"住院"
			}
		}	
		if visit["H"
		{
			if VisitStr=""
			{
				s VisitStr="体检"
			}
			else
			{
				s VisitStr=VisitStr_","_"体检"
			}
		}
		if visit["E"
		{
			if VisitStr=""
			{
				s VisitStr="急诊"
			}
			else
			{
				s VisitStr=VisitStr_","_"急诊"	
			}
		}
	}
	else
	{
		s VisitStr="门诊,住院,体检,急诊"
	}
	q VisitStr
}

/// Creator:Xuwenhu
/// CreatDate:2022-10-09
/// Description:获得别名列表
/// Table: Table：CT.WDT.CDSS.AssBasicInfo
/// Input: id-AssId
/// Return:返回别名列表
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.Access.AssBasicInfo","GetAliasList","2")
Query GetAliasList(id) As %Query(ROWSPEC = "Desc")
{
}

ClassMethod GetAliasListExecute(ByRef qHandle As %Binary, id) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	if (id'=""){
		s Alias = $lg($g(^CT.WDT.CDSS.AssBasicInfoD(id)),21)
		s Len=$Length(Alias,",")
		for i=1:1:Len{
			s Desc=$p(Alias,",",i)
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

/// Function:存评估表数据
/// Others: w ##class(web.CDSS.Access.AssBasicInfo).TestReadCsv2()
ClassMethod TestReadCsv2()
{
	s num=0
	s num1=0
	s Path="D:\mongodbdata\是否基础评估表-标记.csv"
	s file=##class(%File).%New(Path)  ///创建file对象
	d file.Open("RS")   ///以读取的方式打开文件
	d file.ReadLine()
	while 'file.AtEnd  ///如果文件不到结尾，一直循环
	{
		s Line=file.ReadLine()
		continue:Line=""
		s MKBABDesc=$p(Line,",",1)
		s BaseFlagNow=$p(Line,",",3)
		s AssDR=$o(^CT.WDT.CDSS.AssBaseI("DescIndex"," "_$ZCONVERT(MKBABDesc,"U"),0))
		if AssDR=""
		{
			w "找不到ASSDR",!
			w MKBABDesc,!
		}
		continue:AssDR=""
		s ID=$o(^CT.WDT.CDSS.AssBasicInfoI("AssIndex",AssDR,0))
		if ID=""
		{
			w "找不到ID",!
			w MKBABDesc,!
		}
		continue:ID=""
		s obj=##class(CT.WDT.CDSS.AssBasicInfo).%OpenId(ID)
		if obj.BaseFlag'=BaseFlagNow
		{
			s num1=num1+1
			//s obj.BaseFlag=BaseFlagNow
		}
		//TS
	    //s sc=obj.%Save()
		d obj.%Close()
		/*If $$$ISOK(sc)
        { 
            TC
		}
		else
		{
			TRO
		}*/  
		s num=num+1
	}
	
	//d file.%Save()
	d file.Close()
	w num1,!
	w num,!
	q ""
}

/// w ##class(web.CDSS.Access.AssBasicInfo).ImportData("D:\AssShow.csv")
ClassMethod ImportData(Path) As %String
{
	TS
	s file=##class(%File).%New(Path)  ///创建file对象
	d file.Open("RS")   ///以读取的方式打开文件
	d file.ReadLine()
	while 'file.AtEnd  ///如果文件不到结尾，一直循环
	{
		s Line=file.ReadLine()
		continue:Line=""
		s MKBABDesc=$p(Line,",",1)
		s ShowValue=$p(Line,",",2)
		s AssDR=$o(^CT.WDT.CDSS.AssBaseI("DescIndex"," "_$ZCONVERT(MKBABDesc,"U"),0))
		if AssDR=""
		{
			w "找不到ASSDR",!
			w MKBABDesc,!
		}
		continue:AssDR=""
		s ID=$o(^CT.WDT.CDSS.AssBasicInfoI("AssIndex",AssDR,0))
		if ID=""
		{
			w "找不到ID",!
			w MKBABDesc,!
		}
		continue:ID=""
		s obj=##class(CT.WDT.CDSS.AssBasicInfo).%OpenId(ID)
		s obj.ShowPriority=ShowValue
		d obj.%Save()
		d obj.%Close()
	}
	d file.Close()
	q ""
}

}
