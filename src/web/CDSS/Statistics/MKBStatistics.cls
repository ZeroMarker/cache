/// 名称:医学组数据运维统计
/// 描述:医学组数据运维统计
/// 编写者:基础数据平台组 - Xuwenhu
/// 编写日期:2022-01-20
Class web.CDSS.Statistics.MKBStatistics Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:Xuwenhu
/// CreatDate:2022-01-20
/// Description:查询数据
/// Table:WDT.CDSS.MKBStatistics
/// Input:
/// Return:json
/// Others:w ##class(web.CDSS.Statistics.MKBStatistics).GetJsonData("","2022-02-09","2022-02-10")
ClassMethod GetJsonData(id, starttime As %String = "", endtime As %String = "") As %String
{
	n (id,starttime,endtime)
	s parentcatdr=id
	s:parentcatdr="" parentcatdr=-100000000000000
	
	s RowID=0
	w "["
	s count=0
	for 
	{
		s RowID=$o(^CF.WDT.CDSS.StatisticsConfigI("ParentDrIndex",parentcatdr,RowID)) 
		q:(RowID="")
		s count=count+1
		
		s SCCode=$LISTGET($G(^CF.WDT.CDSS.StatisticsConfigD(RowID)),2)   						//代码
		s SCDesc=$LISTGET($G(^CF.WDT.CDSS.StatisticsConfigD(RowID)),3)   						//描述
		s SCParentDr=$LISTGET($G(^CF.WDT.CDSS.StatisticsConfigD(RowID)),4)    					//父菜单
		s:SCParentDr'="" SCParentDr=$LISTGET($G(^CF.WDT.CDSS.StatisticsConfigD(SCParentDr)),3)  //父菜单描述
		s SCActiveFlag=$LISTGET($G(^CF.WDT.CDSS.StatisticsConfigD(RowID)),8)  					//是否激活
		
		s (TotalNum,EditNum,PassedNum,StayNum)=""
		
		//计算差值
		if ((starttime="")&&(endtime=""))
		{
			s StaRowID=$o(^WDT.CDSS.MKBStatisticsI("ConDataIndex",RowID,+$H,0))		//统计表ID
			if StaRowID'=""
			{
				s TotalNum=$LISTGET($G(^WDT.CDSS.MKBStatisticsD(StaRowID)),3)   		//总数据量
				s EditNum=$LISTGET($G(^WDT.CDSS.MKBStatisticsD(StaRowID)),4)   			//编辑中的数据量
				s StayNum=$LISTGET($G(^WDT.CDSS.MKBStatisticsD(StaRowID)),5)			//待审核
				s PassedNum=$LISTGET($G(^WDT.CDSS.MKBStatisticsD(StaRowID)),6)   		//已审核的数据量（审核通过+已上线）
			}
		}
		else
		{
			if starttime=endtime
			{
				s starttime=$ZDT($ZDH(endtime,3)-1,3)	
			}
			if starttime'=""
			{
				s TStaRowID=$o(^WDT.CDSS.MKBStatisticsI("ConDataIndex",RowID,$ZDH(starttime,3),0))		//开始时间ID
			}
			else
			{
				s TStaRowID=$o(^WDT.CDSS.MKBStatisticsI("ConDataIndex",RowID,$ZDH(endtime,3),0))
			}
			if endtime'=""
			{
				s EStaRowID=$o(^WDT.CDSS.MKBStatisticsI("ConDataIndex",RowID,$ZDH(endtime,3),0))	
			}
			else
			{
				s EStaRowID=$o(^WDT.CDSS.MKBStatisticsI("ConDataIndex",RowID,+$H,0))	
			}
			s (STotalNum,SEditNum,SPassedNum,ETotalNum,EEditNum,EPassedNum,SStayNum,EStayNum)=""
			if TStaRowID'=""
			{
				s STotalNum=$LISTGET($G(^WDT.CDSS.MKBStatisticsD(TStaRowID)),3)   				//开始时间总数据量
				s SEditNum=$LISTGET($G(^WDT.CDSS.MKBStatisticsD(TStaRowID)),4)   				//开始时间编辑中的数据量
				s SStayNum=$LISTGET($G(^WDT.CDSS.MKBStatisticsD(TStaRowID)),5)					//待审核
				s SPassedNum=$LISTGET($G(^WDT.CDSS.MKBStatisticsD(TStaRowID)),6)   				//开始时间已审核的数据量（审核通过+已上线）
			}
			if EStaRowID'=""
			{
				s ETotalNum=$LISTGET($G(^WDT.CDSS.MKBStatisticsD(EStaRowID)),3)   				//结束时间总数据量
				s EEditNum=$LISTGET($G(^WDT.CDSS.MKBStatisticsD(EStaRowID)),4)   				//结束时间编辑中的数据量
				s EStayNum=$LISTGET($G(^WDT.CDSS.MKBStatisticsD(EStaRowID)),5)					//待审核
				s EPassedNum=$LISTGET($G(^WDT.CDSS.MKBStatisticsD(EStaRowID)),6)   				//结束时间已审核的数据量（审核通过+已上线）	
			}
			//结束-开始
			s TotalNum=ETotalNum-STotalNum
			s EditNum=EEditNum-SEditNum
			s StayNum=EStayNum-SStayNum
			s PassedNum=EPassedNum-SPassedNum
							
		}
		if SCParentDr=""
		{
			s (TotalNum,EditNum,StayNum,PassedNum)=""	
		}
		continue:SCActiveFlag'="Y"
		if count>1 w ","
		w "{""ID"":"""_RowID_""""
		w ",""SCCode"":"""_SCCode_""",""SCDesc"":"""_SCDesc_""",""SCParentDr"":"""_SCParentDr_""",""TotalNum"":"""_TotalNum_""",""EditNum"":"""_EditNum_""",""PassedNum"":"""_PassedNum_""""
		w ",""StayNum"":"""_StayNum
		w """"
		
		if $d(^CF.WDT.CDSS.StatisticsConfigI("ParentDrIndex",RowID))
		{	
			w ",""state"":""open"""   //closed节点不展开,open节点展开
			w ",""children"":"
			w ..GetJsonData(RowID,starttime,endtime)
		}
		else
		{
			w ",""state"":""open"""
		}
		w "}"
	}
	w "]"
	q ""
}

/// Creator:Xuwenhu
/// CreatDate:2022-01-22
/// Description:保存数据
/// Table:WDT.CDSS.MKBStatistics
/// Input:eobj
/// Return:success-成功，false-失败
/// Others:w ##class(web.CDSS.Statistics.MKBStatistics).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.Statistics.MKBStatistics) As %String
{
	n (eobj)
	s $zt="ERROE"
    s result="",flag=""
    if $IsObject(eobj)
    {   
        if (eobj.RowId="")  //如果RowId未赋值则增加
        {
            s obj=##class(WDT.CDSS.MKBStatistics).%New()             
        }
        else                     //如果RowId已赋值则修改
        {
            s obj=##class(WDT.CDSS.MKBStatistics).%OpenId(eobj.RowId)  
            s bobj = ##class(web.CDSSEntity.Statistics.MKBStatistics).%New()
			s bobj.ConfigDr=obj.ConfigDr.%Id()						// 医学组数据统计配置表指针
    		s bobj.TotalNum=obj.TotalNum							// 总数据量
    		s bobj.EditNum=obj.EditNum								// 编辑中的数据量
    		s bobj.StayNum=obj.StayNum								// 待审核
    		s bobj.PassedNum=obj.PassedNum							// 已审核的数据量（审核通过+已上线）
    		s bobj.StatisticsDate=obj.StatisticsDate				// 统计日期
    		s bobj.Remark=obj.Remark								// 备注
        }
        Ts
        d obj.ConfigDrSetObjectId(eobj.ConfigDr)				// 医学组数据统计配置表指针
		s obj.TotalNum=eobj.TotalNum							// 总数据量
    	s obj.EditNum=eobj.EditNum								// 编辑中的数据量
    	s obj.StayNum=eobj.StayNum								// 待审核
    	s obj.PassedNum=eobj.PassedNum							// 已审核的数据量（审核通过+已上线）
    	s obj.StatisticsDate=eobj.StatisticsDate				// 统计日期
    	s obj.Remark=eobj.Remark								// 备注
        s sc=obj.%Save()
        d obj.%Close()
        If $$$ISOK(sc)
        {
            Tc
            s id = obj.%Id()
            s result = "{success:'true',id:'"_id_"'}"  //返回RowId
            //保存日志
			d:eobj.RowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("MKBStatistics","WDT.CDSS.MKBStatistics","医学组数据运维统计表",id,eobj.RowId,"A",eobj)
			d:eobj.RowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("MKBStatistics","WDT.CDSS.MKBStatistics","医学组数据运维统计表",eobj.RowId,eobj.RowId,"U",eobj,bobj)
        }
        else
        {
            Trollback
            s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("医学组数据运维统计表","web.CDSS.Statistics.MKBStatistics","SaveData",eobj)
   	    	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
        }
                 
    }
    else
    {
        s result = "{success:'false',errorinfo:'对象不存在！'}"
    }
    q result
ERROE
	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("医学组数据运维统计表","web.CDSS.Statistics.MKBStatistics","SaveData",eobj)
 	s ^ERRORLOGINFO(logid)=$ze 
    q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator:Xuwenhu
/// CreatDate:2022-01-22
/// Description:遍历配置表，执行统计接口，得到统计数据并保存
/// Table:CF.WDT.CDSS.StatisticsConfig
/// Input:eobj
/// Return:success-成功，false-失败
/// Others:w ##class(web.CDSS.Statistics.MKBStatistics).SaveStatisticsData("")
ClassMethod SaveStatisticsData(id As %String) As %String
{
	n (id)
	s parentcatdr=id
	s:parentcatdr="" parentcatdr=-100000000000000
	
	s RowID=0
	for 
	{
		s RowID=$o(^CF.WDT.CDSS.StatisticsConfigI("ParentDrIndex",parentcatdr,RowID)) 
		q:(RowID="")
		
		s SCCode=$LISTGET($G(^CF.WDT.CDSS.StatisticsConfigD(RowID)),2)   						//代码
		s SCDesc=$LISTGET($G(^CF.WDT.CDSS.StatisticsConfigD(RowID)),3)   						//描述
		s SCParentDr=$LISTGET($G(^CF.WDT.CDSS.StatisticsConfigD(RowID)),4)    					//父菜单
		s:SCParentDr'="" SCParentDr=$LISTGET($G(^CF.WDT.CDSS.StatisticsConfigD(SCParentDr)),3)  //父菜单描述
		s SCInfo=$LISTGET($G(^CF.WDT.CDSS.StatisticsConfigD(RowID)),5)							//统计接口
		s SCActiveFlag=$LISTGET($G(^CF.WDT.CDSS.StatisticsConfigD(RowID)),8)  					//是否激活	
		if ((SCActiveFlag="Y")&&(SCInfo'=""))
		{
			//x "s Datas=##class(web.DHCBL.MKB.MKBAssessmentBase).CountData()"
			
			s ClassName=$e(SCInfo,$locate(SCInfo,"\(")+1,$locate(SCInfo,"\)")-1)
			if ##class(web.DHCBL.BDP.FunLib).IsValidMethodName(ClassName,"CountData")
			{
				x "s Datas="_SCInfo
				
				s SRowId=$o(^WDT.CDSS.MKBStatisticsI("ConDataIndex",RowID,+$H,0))
				s obj=##class(web.CDSSEntity.Statistics.MKBStatistics).%New()
				s obj.RowId=SRowId
				s obj.ConfigDr=RowID
				s obj.TotalNum=$p(Datas,"^",1)
				s obj.EditNum=$p(Datas,"^",2)
				s obj.StayNum=$p(Datas,"^",4)
				s obj.PassedNum=$p(Datas,"^",3)
				s obj.StatisticsDate=+$H
				s obj.Remark=""
				s result=..SaveData(obj)
			}
		}
		if $d(^CF.WDT.CDSS.StatisticsConfigI("ParentDrIndex",RowID))
		{
			d ..SaveStatisticsData(RowID)
		}
	}
	q ""
}

/// Creator:Xuwenhu
/// CreatDate:2022-01-22
/// Description:获取数据覆盖程度json 已对照/全部的或者常用的
/// Table:CF.WDT.CDSS.StatisticsConfig
/// Input:
/// Return:json
/// Others:w ##class(web.CDSS.Statistics.MKBStatistics).GetMapPercentJson()
ClassMethod GetMapPercentJson2() As %String
{
	s HospitalDR=##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401")
	s DataArray=[]
	s PercentJSON={}
	s SQL="SELECT a.type,a.allnum,b.connum,Round((b.connum/a.allnum)*100,2) AS per FROM (SELECT ContrastType AS type,count(*) AS allnum FROM CT_WDT_CDSS.ContrastDict WHERE HospitalDR="_HospitalDR_" AND ContrastType<>'检查检验' GROUP BY ContrastType) a FULL JOIN (SELECT ContrastType AS type,count(*) AS connum FROM CT_WDT_CDSS.ContrastDict WHERE HospitalDR="_HospitalDR_" AND ContrastType<>'检查检验' GROUP BY ContrastType,State HAVING State='已关联') b ON a.type=b.type UNION SELECT a.type,a.allnum,b.connum,Round((b.connum/a.allnum)*100,2) AS per FROM (SELECT ExamType AS type,count(*) AS allnum FROM CT_WDT_CDSS.ConExamDict WHERE HospitalDR="_HospitalDR_" GROUP BY ExamType) a FULL JOIN (SELECT ExamType AS type,count(*) AS connum FROM CT_WDT_CDSS.ConExamDict WHERE HospitalDR="_HospitalDR_" GROUP BY ExamType,State HAVING State='已关联') b ON a.type=b.type"
	s tStatement=##class(%SQL.Statement).%New()
	s qStatus = tStatement.%Prepare(SQL)
	if qStatus '= 1 
	{
		w "%Prepare failed:"
		d $System.status.DisplayError(qStatus)
		q
	}
	s rset = tStatement.%Execute()
	while rset.%Next() 
	{
		continue:(rset.connum="")
		d PercentJSON.%Set(rset.type,rset.allnum_"^"_rset.connum_"^"_rset.per_"%")
	}
	d DataArray.%Push(PercentJSON)
	q DataArray.%ToJSON()
}

/// Creator:Xuwenhu
/// CreatDate:2023-04-19
/// Description:获取数据覆盖程度json 已对照/全部的或者常用的
/// Table:CF.WDT.CDSS.StatisticsConfig
/// Input:
/// Return:json
/// Others:w ##class(web.CDSS.Statistics.MKBStatistics).GetMapPercentJson()
ClassMethod GetMapPercentJson() As %String
{
	// 总数
	s DataArray=[]
	s PercentJSON={}
	s HospitalDR=##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401")
	s Type="药品,诊断,检查检验,手术,护理,输血品,频率,检验标本,用法,单位,科室,中药,中医诊断,中医证型"
	
	for Typei=1:1:$l(Type,",")
	{
		s zType=$p(Type,",",Typei)
		continue:zType=""
		continue:zType="检查检验"
		s NumS=##class(web.CDSS.IMP.ContrastDict).GetMatchData(HospitalDR,zType)
		s allnum=$p(NumS,",",1)		//总数
		continue:allnum=0
		s connum=$p(NumS,",",2)		//已对照数
		s per=$fn(connum/allnum*100,"",2)
		d PercentJSON.%Set(zType,allnum_"^"_connum_"^"_per_"%")
	} 	
	// 检查检验分开计算
	s State=""
	k AllNum,MapNum
	for
	{
		s State=$o(^CT.WDT.CDSS.ConExamDictI("HospStateIndex",HospitalDR,State))
		q:State=""
		
		s RowID=0
		for
		{
			s RowID=$o(^CT.WDT.CDSS.ConExamDictI("HospStateIndex",HospitalDR,State,RowID))
			q:RowID=""
			continue:(State="已删除")	//已删除数据不计入总数
			s ExamType=$LISTGET($G(^CT.WDT.CDSS.ConExamDictD(RowID)),4)
			s AllNum(ExamType)=$g(AllNum(ExamType))+1
			
			//状态（未关联/已关联/已确认/已删除）
			continue:((State'="已关联")&&(State'="已确认"))
			s MapNum(ExamType)=$g(MapNum(ExamType))+1
		}
	}
	s Extype=""
	for
	{
		s Extype=$o(AllNum(Extype))
		q:Extype=""
		s Eall=$g(AllNum(Extype))
		s Econ=$g(MapNum(Extype))
		s Eper=$g(MapNum(Extype))/$g(AllNum(Extype))*100
		s Value=Eall_"^"_Econ_"^"_$fn(Eper,"",2)_"%"
		d PercentJSON.%Set(Extype,Value)
	}
	d DataArray.%Push(PercentJSON)
	q DataArray.%ToJSON()
}

/// Creator:Xuwenhu
/// CreatDate:2022-01-22
/// Description:获取百科数据json 已对照/全部的或者常用的
/// Table:CT.WDT.CDSS.Term
/// Input:
/// Return:json
/// Others:w ##class(web.CDSS.Statistics.MKBStatistics).GetWikiPercentJson()
ClassMethod GetWikiPercentJson() As %String
{
	k arr
	s DataArray=[]
	s WiKiJSON={}
	s HospitalDR=##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401")
	/*if '$d(^User.CT.WDT.CDSS.ContrastDictI("HospIndex",HospitalDR))  
	{
		q "[]"		//如果无对照数据直接退出
	}*/
	//有对照，遍历百科表，找到已对照且有百科的数据总数
	s UpdateDate1=""
	for  
	{	
		s UpdateDate1=$o(^CT.WDT.CDSS.TermI("DateIndex",UpdateDate1),-1) q:UpdateDate1=""
		s MKBTRowId=""
		for  
		{	
			s MKBTRowId=$o(^CT.WDT.CDSS.TermI("DateIndex",UpdateDate1,MKBTRowId)) q:MKBTRowId=""
			s MKBTCode=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),2)  //代码 
			s MKBTDesc=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),3)  //描述
			s MKBTBaseDR=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),4)
			s MKBTBDesc="",MKBTBCode=""
			s:MKBTBaseDR'="" MKBTBCode=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(MKBTBaseDR)),2)
			s:MKBTBaseDR'="" MKBTBDesc=$LISTGET($G(^CT.WDT.CDSS.TermBaseD(MKBTBaseDR)),3)
			s State=$listGet($g(^CT.WDT.CDSS.TermD(MKBTRowId)),14)		//状态
			continue:((State'="2")&(State'="3"))
			s Type=$case(MKBTBDesc,"疾病":"诊断",:MKBTBDesc)
			continue:Type=""
			s DictDR=""
			if MKBTBDesc="疾病"
			{
				s DictDR=$o(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_$ZCONVERT(MKBTDesc,"U"),0))	
			}
			elseif MKBTBDesc="检查"
			{
				s DictDR=$o(^CT.WDT.CDSS.ExamDictI("NameIndex"," "_$ZCONVERT(MKBTDesc,"U"),0))
			}
			elseif MKBTBDesc="检验"
			{
				s DictDR=$o(^CT.WDT.CDSS.LabInspectionDictI("NameIndex"," "_$ZCONVERT(MKBTDesc,"U"),0))
				s Type="检验项目"	
				if DictDR="" 
				{
					s DictDR=$o(^CT.WDT.CDSS.LabOrdersDictI("DescIndex"," "_$ZCONVERT(MKBTDesc,"U"),0))
					s Type="检验医嘱"
				}
			}
			elseif MKBTBDesc="手术"
			{
				s DictDR=$o(^CT.WDT.CDSS.OperationDictI("NameIndex"," "_$ZCONVERT(MKBTDesc,"U"),0))
			}
			else
			{
				s DictDR=$o(^CT.WDT.CDSS.NursingDictI("NameIndex"," "_$ZCONVERT(MKBTDesc,"U"),0))	
			}
			continue:(DictDR="")
			if ((MKBTBDesc="检查")||(MKBTBDesc="检验"))
			{
				s MappState=$o(^CT.WDT.CDSS.ContrastDictI("DictDRStateIndex",HospitalDR,"检查检验",DictDR,""))	
			}
			else
			{
				s MappState=$o(^CT.WDT.CDSS.ContrastDictI("DictDRStateIndex",HospitalDR,Type,DictDR,""))	
			}
			continue:((MappState'="已关联"))
			s WikiMKBTPRowId=$O(^CT.WDT.CDSS.TermPropertyI("DescIndex",MKBTRowId," 百科名称",""))
			continue:WikiMKBTPRowId=""
			s:$d(arr(Type))=0 arr(Type)=0
        	s:$d(arr(Type)) arr(Type)=arr(Type)+1
		}
	}
	
	s name=""
	for
	{
		s name=$o(arr(name))
		q:name=""
		if ((name="检查")||(name="检验项目")||(name="检验医嘱"))
		{
			s TotalNum=0
			s wikiNum=arr(name)
			s State=""
			for
			{
				s State=$o(^CT.WDT.CDSS.ConExamDictI("HospStateIndex",HospitalDR,State))
				q:State=""
				s RowID=0
				for
				{
					s RowID=$o(^CT.WDT.CDSS.ConExamDictI("HospStateIndex",HospitalDR,State,RowID))
					q:RowID=""
					s ExamType=$lg($g(^CT.WDT.CDSS.ConExamDictD(RowID)),4)		//类型
					continue:(State="已删除")	//已删除数据不计入总数
					continue:(ExamType'=name)
					s TotalNum=TotalNum+1	
				}
			}
			try
			{
				s Percent=$FNUMBER(100*(wikiNum/TotalNum),"",2)_"%"
			}
			catch
			{
				s Percent="0%"	
			}
			d WiKiJSON.%Set(name,TotalNum_"^"_wikiNum_"^"_Percent) 
		}
		else
		{
			s wikiNum=arr(name)
			s Datas=##class(web.CDSS.IMP.ContrastDict).GetMatchData(HospitalDR,name)
			if Datas'=""
			{
				s TotalNum=$p(Datas,",",1)		
				try
				{
					s Percent=$FNUMBER(100*(wikiNum/TotalNum),"",2)_"%"
				}
				catch
				{
					s Percent="0%"	
				}
			}
			d WiKiJSON.%Set(name,TotalNum_"^"_wikiNum_"^"_Percent) 
		}
	}
	d DataArray.%Push(WiKiJSON)
	q DataArray.%ToJSON()
}

/// Creator:Xuwenhu
/// CreatDate:2022-01-22
/// Description:CDSS用户点击量统计
/// Table:WDT.CDSS.UserClickStatic
/// Input:
/// Return:json
/// Others:w ##class(web.CDSS.Statistics.MKBStatistics).GetClickNum("2022-03-10","2022-03-10")
ClassMethod GetClickNum(StartTime As %String, EndTime As %String) As %String
{
	n (StartTime,EndTime)
	s DataArray=[]
	s ClickJSON={}
	s time=StartTime
	s:time="" time=$ZDT(+$H-15,3)			//默认只取两周数据显示
	if EndTime=""
	{
		s EndTime=$ZDH(time,3)+15,EndTime=$ZDT(EndTime,3)
	}
	for
	{
		s time=$o(^WDT.CDSS.UserClickStaticI("TimeIndex",time)) 
		q:time=""
		q:((EndTime'="")&&($ZDH(time,3)>$zdh(EndTime,3)))

		s id=$o(^WDT.CDSS.UserClickStaticI("TimeIndex",time,"")) 
		continue:(id="")
		
		s:$d(arr($p(time," ",1)))=0 arr($p(time," ",1))=0
        s:$d(arr($p(time," ",1))) arr($p(time," ",1))=arr($p(time," ",1))+1	
        
	}
	s jsonstr=""
	s name=""
	for
	{
		s name=$O(arr(name))	
		q:name=""	
		
		d ClickJSON.%Set(name,arr(name))				
	}
	d DataArray.%Push(ClickJSON)
	q DataArray.%ToJSON()
}

/// Creator:Xuwenhu
/// CreatDate:2022-01-26
/// Description:CDSS科室点击量TOP10
/// Table:WDT.CDSS.UserClickStatic
/// Input:
/// Return:json
/// Others:w ##class(web.CDSS.Statistics.MKBStatistics).GetDeptClickNum("2022-03-09","2022-03-11")
ClassMethod GetDeptClickNum(StartTime As %String, EndTime As %String) As %String
{
	n (StartTime,EndTime)
	s DataArray=[]
	
	s SQL="SELECT TOP 10 CTLocDesc As dept,count(*) AS num FROM WDT_CDSS.UserClickStatic WHERE ClickTime>='"_StartTime_" 23:59:59"_"' AND ClickTime<='"_EndTime_" 23:59:59"_"' GROUP BY CTLocDesc ORDER BY num DESC"
	s tStatement=##class(%SQL.Statement).%New()
	s qStatus = tStatement.%Prepare(SQL)
	if qStatus '= 1 
	{
		w "%Prepare failed:"
		d $System.status.DisplayError(qStatus)
		q
	}
	s rset = tStatement.%Execute()
	while rset.%Next() 
	{
		s DeptClickJSON={}
		d DeptClickJSON.%Set("dept",rset.dept)
		d DeptClickJSON.%Set("num",rset.num)
		d DataArray.%Push(DeptClickJSON)
	}
	q DataArray.%ToJSON()
}

/// Creator:Xuwenhu
/// CreatDate:2022-01-26
/// Description:CDSS页面使用量TOP10
/// Table:WDT.CDSS.UserClickStatic
/// Input:
/// Return:json
/// Others:w ##class(web.CDSS.Statistics.MKBStatistics).GetPageClickNum("2022-03-01","2022-03-11")
ClassMethod GetPageClickNum(StartTime As %String, EndTime As %String) As %String
{
	n (StartTime,EndTime)
	s DataArray=[]
	s PageClickJSON={}
	s SQL="SELECT TOP 10 ClickModule As page,count(*) AS num FROM WDT_CDSS.UserClickStatic WHERE ClickTime>='"_StartTime_" 23:59:59"_"' AND ClickTime<='"_EndTime_" 23:59:59"_"' GROUP BY ClickModule ORDER BY num DESC"
	s tStatement=##class(%SQL.Statement).%New()
	s qStatus = tStatement.%Prepare(SQL)
	if qStatus '= 1 
	{
		w "%Prepare failed:"
		d $System.status.DisplayError(qStatus)
		q
	}
	s rset = tStatement.%Execute()
	while rset.%Next() 
	{
		s PageClickJSON={}
		d PageClickJSON.%Set("page",rset.page)
		d PageClickJSON.%Set("num",rset.num)
		d DataArray.%Push(PageClickJSON)
	}
	q DataArray.%ToJSON()
}

/// Creator:Xuwenhu
/// CreatDate:2022-01-26
/// Description:CDSS热搜榜TOP10
/// Table:WDT.CDSS.UserClickStatic
/// Input:
/// Return:json
/// Others:w ##class(web.CDSS.Statistics.MKBStatistics).GetSearchNum("2022-03-01","2022-03-11")
ClassMethod GetSearchNum(StartTime As %String, EndTime As %String) As %String
{
	n (StartTime,EndTime)
	s DataArray=[]
	s SearchJSON={}
	s SQL="SELECT TOP 10 ClickText As text,count(*) AS num FROM WDT_CDSS.UserClickStatic WHERE ClickTime>='"_StartTime_" 23:59:59"_"' AND ClickTime<='"_EndTime_" 23:59:59"_"' GROUP BY ClickProType, ClickText HAVING ClickProType='检索框' ORDER BY num DESC"
	s tStatement=##class(%SQL.Statement).%New()
	s qStatus = tStatement.%Prepare(SQL)
	if qStatus '= 1 
	{
		w "%Prepare failed:"
		d $System.status.DisplayError(qStatus)
		q
	}
	s rset = tStatement.%Execute()
	while rset.%Next() 
	{
		s SearchJSON={}
		d SearchJSON.%Set("search",rset.text)
		d SearchJSON.%Set("num",rset.num)
		d DataArray.%Push(SearchJSON)
	}
	q DataArray.%ToJSON()
}

/// Creator:Xuwenhu
/// CreatDate:2022-01-26
/// Description:CDSS评估表使用量TOP10
/// Table:WDT.CDSS.UserClickStatic
/// Input:
/// Return:json
/// Others:w ##class(web.CDSS.Statistics.MKBStatistics).GetAssessClickNum("2022-01-01","2022-01-30")
ClassMethod GetAssessClickNum(StartTime As %String, EndTime As %String) As %String
{
	n (StartTime,EndTime)
	s DataArray=[]
	s AssClickJSON={}
	s SQL="SELECT TOP 10 ClickText As text,count(*) AS num FROM WDT_CDSS.UserClickStatic WHERE ClickTime>='"_StartTime_" 23:59:59"_"' AND ClickTime<='"_EndTime_" 23:59:59"_"' GROUP BY ClickProType, ClickText HAVING ClickProType='推荐评估表' ORDER BY num DESC"
	s tStatement=##class(%SQL.Statement).%New()
	s qStatus = tStatement.%Prepare(SQL)
	if qStatus '= 1 
	{
		w "%Prepare failed:"
		d $System.status.DisplayError(qStatus)
		q
	}
	s rset = tStatement.%Execute()
	while rset.%Next() 
	{
		s AssClickJSON={}
		d AssClickJSON.%Set("ass",rset.text)
		d AssClickJSON.%Set("num",rset.num)
		d DataArray.%Push(AssClickJSON)
	}
	q DataArray.%ToJSON()
}

/// Creator:Xuwenhu
/// CreatDate:2022-01-26
/// Description:CDSS文献点击TOP100
/// Table:WDT.CDSS.UserClickStatic
/// Input:
/// Return:json
/// Others:w ##class(web.CDSS.Statistics.MKBStatistics).GetDocClickNum("2022-01-01","2022-03-11")
ClassMethod GetDocClickNum(StartTime As %String, EndTime As %String) As %String
{
	n (StartTime,EndTime)
	s DataArray=[]
	s DocClickJSON={}
	s SQL="SELECT TOP 100 ClickText As text,count(*) AS num FROM WDT_CDSS.UserClickStatic WHERE ClickTime>='"_StartTime_" 23:59:59"_"' AND ClickTime<='"_EndTime_" 23:59:59"_"' GROUP BY ClickProType, ClickText HAVING ClickProType='医为文献' AND ClickText IS NOT NULL ORDER BY num DESC"
	s tStatement=##class(%SQL.Statement).%New()
	s qStatus = tStatement.%Prepare(SQL)
	if qStatus '= 1 
	{
		w "%Prepare failed:"
		d $System.status.DisplayError(qStatus)
		q
	}
	s rset = tStatement.%Execute()
	while rset.%Next() 
	{
		s DocClickJSON={}
		d DocClickJSON.%Set("doc",rset.text)
		d DocClickJSON.%Set("num",rset.num)
		d DataArray.%Push(DocClickJSON)		
	}
	q DataArray.%ToJSON()
}

/// Creator:Xuwenhu
/// CreatDate:2022-01-26
/// Description:CDSS用户点击TOP100
/// Table:WDT.CDSS.UserClickStatic
/// Input:
/// Return:json
/// Others:w ##class(web.CDSS.Statistics.MKBStatistics).GetUserClickNum("2022-01-01","2022-03-30")
ClassMethod GetUserClickNum(StartTime As %String, EndTime As %String) As %String
{
	n (StartTime,EndTime)
	s DataArray=[]
	s UserClickJSON={}
	s SQL="SELECT TOP 100 UserName As name,count(*) AS num FROM WDT_CDSS.UserClickStatic WHERE ClickTime>='"_StartTime_" 23:59:59"_"' AND ClickTime<='"_EndTime_" 23:59:59"_"' GROUP BY UserName HAVING UserName IS NOT NULL ORDER BY num DESC"
	s tStatement=##class(%SQL.Statement).%New()
	s qStatus = tStatement.%Prepare(SQL)
	if qStatus '= 1 
	{
		w "%Prepare failed:"
		d $System.status.DisplayError(qStatus)
		q
	}
	s rset = tStatement.%Execute()
	while rset.%Next() 
	{
		s UserClickJSON={}
		d UserClickJSON.%Set("user",rset.name)
		d UserClickJSON.%Set("num",rset.num)
		d DataArray.%Push(UserClickJSON)
	}
	q DataArray.%ToJSON()
}

/// Creator:Xuwenhu
/// CreatDate:2022-01-26
/// Description:CDSS预警触发分析
/// Table:WDT.CDSS.PatTriggerStatic
/// Input:
/// Return:json
/// Others:w ##class(web.CDSS.Statistics.MKBStatistics).GetTriggerByDeptNum("","2022-01-01","2022-01-30")
ClassMethod GetTriggerByDeptNum(Loc As %String, StartTime As %String, EndTime As %String) As %String
{
	n (Loc,StartTime,EndTime)
	k arr
	s DataArray=[]
	s:Loc'="" SQL="SELECT CTLocDesc AS loc,RiskLevel As levels,count(*) AS num FROM WDT_CDSS.PatTriggerStatic WHERE TriggerTime>='"_StartTime_"' AND TriggerTime<='"_EndTime_"' AND CTLocDesc='"_Loc_"' GROUP BY CTLocDesc,RiskLevel HAVING RiskLevel IS NOT NULL  ORDER BY num DESC "
	s:Loc="" SQL="SELECT CTLocDesc AS loc,RiskLevel As levels,count(*) AS num FROM WDT_CDSS.PatTriggerStatic WHERE TriggerTime>='"_StartTime_"' AND TriggerTime<='"_EndTime_"' AND CTLocDesc IS NOT NULL GROUP BY CTLocDesc,RiskLevel HAVING RiskLevel IS NOT NULL  ORDER BY num DESC "
	s tStatement=##class(%SQL.Statement).%New()
	s qStatus = tStatement.%Prepare(SQL)
	if qStatus '= 1 
	{
		w "%Prepare failed:"
		d $System.status.DisplayError(qStatus)
		q
	}
	s rset = tStatement.%Execute()
	while rset.%Next() 
	{
		s arr(rset.loc,rset.levels)=rset.num
	}
	s loc=""
	for
	{
		s loc=$o(arr(loc))
		q:loc=""
		s TriggerJSON={}
		d TriggerJSON.%Set("loc",loc)
		s lev=""
		for
		{
			s lev=$o(arr(loc,lev))
			q:lev=""
			d:lev="绝对" TriggerJSON.%Set("red",arr(loc,lev))
			d:lev="相对" TriggerJSON.%Set("orange",arr(loc,lev))
			d:lev="注意事项" TriggerJSON.%Set("blue",arr(loc,lev))	
		}
		d DataArray.%Push(TriggerJSON)
	}
	q DataArray.%ToJSON()
}

/// Creator:Xuwenhu
/// CreatDate:2022-01-26
/// Description:CDSS预警触发情况
/// Table:WDT.CDSS.PatTriggerStatic
/// Input:
/// Return:json
/// Others:w ##class(web.CDSS.Statistics.MKBStatistics).GetTriggerByTypeNum("","2022-01-01","2022-01-30")
ClassMethod GetTriggerByTypeNum(Loc As %String, StartTime As %String, EndTime As %String) As %String
{
	n (Loc,StartTime,EndTime)
	k arr
	s DataArray=[]
	s SQL=2
	s:Loc'="" SQL(1)="SELECT CTLocDesc AS loc,NodeType As type,count(*) AS num FROM WDT_CDSS.PatTriggerStatic WHERE TriggerTime>='"_StartTime_"' AND TriggerTime<='"_EndTime_"' AND CTLocDesc='"_Loc_"' GROUP BY CTLocDesc,NodeType"
	s:Loc="" SQL(1)="SELECT CTLocDesc AS loc,NodeType As type,count(*) AS num FROM WDT_CDSS.PatTriggerStatic WHERE TriggerTime>='"_StartTime_"' AND TriggerTime<='"_EndTime_"' GROUP BY CTLocDesc,NodeType"
	s SQL(2)="HAVING (NodeType='药品合理性' OR NodeType='检查合理性' OR NodeType='检验合理性' OR NodeType='手术合理性' OR NodeType='护理/处置合理性' OR NodeType='疾病预警' OR NodeType='输血预警') AND CTLocDesc IS NOT NULL"
	s tStatement=##class(%SQL.Statement).%New()
	s qStatus = tStatement.%Prepare(.SQL)
	if qStatus '= 1 
	{
		w "%Prepare failed:"
		d $System.status.DisplayError(qStatus)
		q
	}
	s rset = tStatement.%Execute()
	while rset.%Next() 
	{
		s arr(rset.loc,rset.type)=rset.num
	}
	s loc=""
	for
	{
		s loc=$o(arr(loc))
		q:loc=""
		s TriggerJSON={}
		d TriggerJSON.%Set("loc",loc)
		s type=""
		for
		{
			s type=$o(arr(loc,type))
			q:type=""
			d:type="药品合理性" TriggerJSON.%Set("drug",arr(loc,type))
			d:type="检查合理性" TriggerJSON.%Set("exam",arr(loc,type))
			d:type="检验合理性" TriggerJSON.%Set("check",arr(loc,type))
			d:type="手术合理性" TriggerJSON.%Set("oper",arr(loc,type))
			d:type="护理/处置合理性" TriggerJSON.%Set("nurse",arr(loc,type))
			d:type="疾病预警" TriggerJSON.%Set("drug",arr(loc,type))	
			d:type="输血预警" TriggerJSON.%Set("blood",arr(loc,type))
		}
		d DataArray.%Push(TriggerJSON)
	}
	q DataArray.%ToJSON()
}

/// Creator:Xuwenhu
/// CreatDate:2022-02-215
/// Description:CDSS诊疗规则总数
/// Table:User.DHCDSSRuleRationality
/// Input:
/// Return:json
/// Others:w ##class(web.CDSS.Statistics.MKBStatistics).GetTriggerAllNumJson()
ClassMethod GetTriggerAllNumJson() As %String
{
	n (StartTime,EndTime)
	s DataArray=[]
	s TriggerAllJSON={}
	s Config=##class(web.CDSS.Config.MKBConfig).GetConfigValue("V1.2MKBConfig")		//配置
	if Config="N"
	{
		s SQL="SELECT Type AS type,count(Type) AS num FROM (SELECT NodeDR->RuleDR->RuleType->ChartTypeDesc AS Type FROM CT_WDT_CDSS.RuleRationality) GROUP BY Type Having Type IS NOT NULL"
	}else
	{
		s SQL="SELECT b.DictItemName AS type,a.num FROM (SELECT RuleResultDesc,count(*) AS num FROM DHCDSSMedicalRule GROUP BY RuleResultDesc)  a,DHCDSSBasicsDict b WHERE a.RuleResultDesc=b.DictItemCode"
	}
	s tStatement=##class(%SQL.Statement).%New()
	s qStatus = tStatement.%Prepare(.SQL)
	if qStatus '= 1 
	{
		w "%Prepare failed:"
		d $System.status.DisplayError(qStatus)
		q
	}
	s rset = tStatement.%Execute()
	while rset.%Next() 
	{
		d TriggerAllJSON.%Set(rset.type,rset.num)	
	}
	d DataArray.%Push(TriggerAllJSON)
	q DataArray.%ToJSON()
}

/// CreatDate:2022-01-28
/// Description:遍历配置表，执行同步别名接口
/// Table:CF.WDT.CDSS.StatisticsConfig
/// Input:eobj
/// Return:success-成功，false-失败
/// Others:w ##class(web.CDSS.Statistics.MKBStatistics).SynAliasData("")
ClassMethod SynAliasData(id As %String) As %String
{
	n (id)
	s parentcatdr=id
	s:parentcatdr="" parentcatdr=-100000000000000
	
	s RowID=0
	for 
	{
		s RowID=$o(^CF.WDT.CDSS.StatisticsConfigI("ParentDrIndex",parentcatdr,RowID)) 
		q:(RowID="")
		
		s SCCode=$LISTGET($G(^CF.WDT.CDSS.StatisticsConfigD(RowID)),2)   						//代码
		s SCDesc=$LISTGET($G(^CF.WDT.CDSS.StatisticsConfigD(RowID)),3)   						//描述
		s SCParentDr=$LISTGET($G(^CF.WDT.CDSS.StatisticsConfigD(RowID)),4)    					//父菜单
		s:SCParentDr'="" SCParentDr=$LISTGET($G(^CF.WDT.CDSS.StatisticsConfigD(SCParentDr)),3)  //父菜单描述
		s SCInfo=$LISTGET($G(^CF.WDT.CDSS.StatisticsConfigD(RowID)),5)							//统计接口
		s SCActiveFlag=$LISTGET($G(^CF.WDT.CDSS.StatisticsConfigD(RowID)),8)  					//是否激活	
		s AliasInfo=$LISTGET($G(^CF.WDT.CDSS.StatisticsConfigD(RowID)),10)  					//别名接口	
		if ((SCActiveFlag="Y")&&(AliasInfo'=""))
		{
			//x "s Datas=##class(web.DHCBL.MKB.MKBAssessmentBase).CountData()"
			x "d "_AliasInfo
		}
		if $d(^CF.WDT.CDSS.StatisticsConfigI("ParentDrIndex",RowID))
		{
			d ..SynAliasData(RowID)
		}
	}
	q ""
}

/// Creator：Xuwenhu		
/// CreatDate: 2022-03-08
/// Description：查询数据 
/// Table:CF.WDT.CDSS.StatisticsConfig
/// Input:
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.Statistics.MKBStatistics","GetShowList","")
Query GetShowList(rowid As %String) As %Query(ROWSPEC = "RowId,SCShowName,TotalNum,SCDesc")
{
}

ClassMethod GetShowListExecute(ByRef qHandle As %Binary, rowid As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s RowId=rowid
        s SCHomeFlag=$lg($g(^CF.WDT.CDSS.StatisticsConfigD(RowId)),6) 			//是否在首页展示
        s SCShowName=$lg($g(^CF.WDT.CDSS.StatisticsConfigD(RowId)),7) 			//展示名
        s SCDesc=$LISTGET($G(^CF.WDT.CDSS.StatisticsConfigD(RowId)),3)   						//描述

        s TotalNum=""
        s StaRowID=$o(^WDT.CDSS.MKBStatisticsI("ConfigDrIndex",RowId,""),-1)		//统计表ID
        s:StaRowID'="" TotalNum=$lg($g(^WDT.CDSS.MKBStatisticsD(StaRowID)),3)
        d OutputRow
    }
    else
    {
        s RowId=0
        for 
        {
            s RowId=$o(^CF.WDT.CDSS.StatisticsConfigD(RowId))
			q:RowId=""
			s SCHomeFlag=$lg($g(^CF.WDT.CDSS.StatisticsConfigD(RowId)),6) 			//是否在首页展示
			continue:(SCHomeFlag'="Y")
	        s SCShowName=$lg($g(^CF.WDT.CDSS.StatisticsConfigD(RowId)),7) 			//展示名
	        s SCDesc=$LISTGET($G(^CF.WDT.CDSS.StatisticsConfigD(RowId)),3)   						//描述

	        s TotalNum=""
	        s StaRowID=$o(^WDT.CDSS.MKBStatisticsI("ConfigDrIndex",RowId,""),-1)		//统计表ID
	        s:StaRowID'="" TotalNum=$lg($g(^WDT.CDSS.MKBStatisticsD(StaRowID)),3)		//数据总量	    	
			d OutputRow
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(RowId,SCShowName,TotalNum,SCDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetShowListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetShowListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetShowListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetShowListExecute ]
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

}
