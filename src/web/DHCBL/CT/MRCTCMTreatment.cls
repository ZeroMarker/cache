/// 名称: 中医治法
/// 编写者：基础数据平台组  陈莹
/// 编写日期: 2020-12-22
Class web.DHCBL.CT.MRCTCMTreatment Extends %RegisteredObject [ ProcedureBlock ]
{

Parameter SQLTableName = "MRC_TCMTreatment";

/// Creator：chenying
/// CreatDate: 2020-12-22
/// Description：查询中医治法的内容 分页
/// Table：User.MRCTCMTreatment中医治法
/// Input：rowid,code,desc,nationaldesc(国家标准名称),validflag(有效标识)，start，limit
/// w ##class(web.DHCBL.CT.MRCTCMTreatment).GetList("","","","","","0","20","")
ClassMethod GetList(rowid As %String, code As %String, desc As %String, nationaldesc As %String, validflag, start As %String, limit As %String) As %String
{
	if start="" s start=0
	if limit="" s limit=20
	if (rowid'="") //根据rowid返回该条记录
	{
		w "{""data"":["
        s TCMTRowId=rowid
		s TCMTCode=$p($g(^MRC("TCMT",TCMTRowId)),"^",1)   //中医治法代码
		s TCMTDesc=$p($g(^MRC("TCMT",TCMTRowId)),"^",2)   //中医治法名称
		s TCMTNumber=$p($g(^MRC("TCMT",TCMTRowId)),"^",3)            ///编号
		s TCMTNationalDesc=$p($g(^MRC("TCMT",TCMTRowId)),"^",4)      ///国家标准名称
		s TCMTValid=$p($g(^MRC("TCMT",TCMTRowId)),"^",5) //临床可用标识
		if TCMTValid="" s TCMTValid="Y"
		s TCMTDateFrom=$p($g(^MRC("TCMT",TCMTRowId)),"^",6)
		s TCMTDateTo=$p($g(^MRC("TCMT",TCMTRowId)),"^",7)
		s TCMTAlias=$p($g(^MRC("TCMT",TCMTRowId)),"^",8)  //检索码
		
		
		s TCMTDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(TCMTDateFrom)  //转换日期格式
		s TCMTDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(TCMTDateTo)  //转换日期格式
		
		s strResult=  "{""TCMTRowId"":"""_TCMTRowId_""",""TCMTCode"":"""_TCMTCode_""",""TCMTDesc"":"""_TCMTDesc_""",""TCMTNumber"":"""_TCMTNumber_""",""TCMTDateFrom"":"""_TCMTDateFrom_""",""TCMTDateTo"":"""_TCMTDateTo_""",""TCMTNationalDesc"":"""_TCMTNationalDesc_""",""TCMTValid"":"""_TCMTValid_""",""TCMTAlias"":"""_TCMTAlias_"""}"
		W strResult
	
		w "],""total"":""1"",""success"":""true""}"
	}
	else
	{
		s:code'="" code=$ZCVT(code,"U") //转换成大写
		s:desc'="" desc=$ZCVT(desc,"U") //转换成大写
		//获取授权
		s AuStr=##class(web.DHCBL.Authorize.MRCTCMTreatment).DHCGetDataByDefaultSession()
		if ($l(AuStr,"#")=1) {
			s Limited=0
			s AutBit=""
		}
		elseif ($l(AuStr,"#")=2) {
			s Limited=$p(AuStr,"#",1)
			s AutBit=$p(AuStr,"#",2)
		}
		s AuFlag=0
		if (AuStr="")||((AuStr'="")&(Limited=0)) s AuFlag=1 //判断是否有授权,如果没有则全部显示	
		s total=0
		s start=start+1  //start=0时从第1条开始
        s CurrentCount=0
        w "{""data"":["
		s TCMTRowId=0
		for
		{
			s TCMTRowId=$o(^MRC("TCMT",TCMTRowId)) q:TCMTRowId=""
			//筛选授权后的数据
			if (($bit(AutBit,TCMTRowId)=1)||(AuFlag=1))
			{
				s TCMTCode=$p($g(^MRC("TCMT",TCMTRowId)),"^",1)   //中医治法代码
				s TCMTDesc=$p($g(^MRC("TCMT",TCMTRowId)),"^",2)   //中医治法名称
				s TCMTNumber=$p($g(^MRC("TCMT",TCMTRowId)),"^",3)            ///编号
				s TCMTNationalDesc=$p($g(^MRC("TCMT",TCMTRowId)),"^",4)      ///国家标准名称
				s TCMTValid=$p($g(^MRC("TCMT",TCMTRowId)),"^",5) //临床可用标识
				if TCMTValid="" s TCMTValid="Y"
				s TCMTDateFrom=$p($g(^MRC("TCMT",TCMTRowId)),"^",6) //开始日期
				s TCMTDateTo=$p($g(^MRC("TCMT",TCMTRowId)),"^",7)  //结束日期
				s TCMTAlias=$p($g(^MRC("TCMT",TCMTRowId)),"^",8)  //检索码
				i ($zcvt(TCMTCode,"U")[code)&&($ZCVT(TCMTNationalDesc,"U")[nationaldesc)&&(TCMTValid[validflag)
				{
					if (desc'="")
					{
						;需要对描述、检索码、别名进行检索      
						s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("MRC_TCMTreatment",TCMTRowId,TCMTDesc,desc)
						s AliasFlag=(AliasFlag||($zcvt(TCMTAlias,"U")[desc))
					}
					else
					{
						s AliasFlag= 1   
					}  
					continue:(AliasFlag'=1) 
					s total=total+1
					if (total<start) continue
					if ((total<(start+limit)))
					{
						s CurrentCount=CurrentCount+1
						if (CurrentCount>1) 
						{
							w ","
						}
						s TCMTDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(TCMTDateFrom)  //转换日期格式
						s TCMTDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(TCMTDateTo)  //转换日期格式
						s strResult=  "{""TCMTRowId"":"""_TCMTRowId_""",""TCMTCode"":"""_TCMTCode_""",""TCMTDesc"":"""_TCMTDesc_""",""TCMTNumber"":"""_TCMTNumber_""",""TCMTDateFrom"":"""_TCMTDateFrom_""",""TCMTDateTo"":"""_TCMTDateTo_""",""TCMTNationalDesc"":"""_TCMTNationalDesc_""",""TCMTValid"":"""_TCMTValid_""",""TCMTAlias"":"""_TCMTAlias_"""}"
						W strResult
					}
				}
			}
		}
		w "],""total"":"""_total_""",""success"":""true""}"
		
	}
	q ""
}

/// Creator：chenying
/// CreatDate: 2020-12-22
/// Description：中医治法下拉框接口
/// Table：User.MRCTCMTreatment中医治法
/// Input：rowid,code,desc,nationaldesc(国家标准名称)
/// Return：TCMTRowId,TCMTCode(中医治法代码),TCMTDesc(中医治法名称),TCMTNationalDesc(国家标准名称)
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.MRCTCMTreatment","GetDataForCmb1","","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String, nationaldesc As %String) As %Query(ROWSPEC = "TCMTRowId:%String,TCMTCode:%String,TCMTDesc:%String,TCMTNationalDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, nationaldesc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s TCMTRowId=rowid
		s TCMTCode=$p($g(^MRC("TCMT",TCMTRowId)),"^",1)   //中医治法代码
		s TCMTDesc=$p($g(^MRC("TCMT",TCMTRowId)),"^",2)   //中医治法名称
		s TCMTNationalDesc=$p($g(^MRC("TCMT",TCMTRowId)),"^",4)      ///国家标准名称
		d OutputRowCmb
	}
	else
	{
		s:code'="" code=$ZCVT(code,"U") //转换成大写
		s:desc'="" desc=$ZCVT(desc,"U") //转换成大写
		s:nationaldesc'="" nationaldesc=$ZCVT(nationaldesc,"U")
		//获取授权
		s AuStr=##class(web.DHCBL.Authorize.MRCTCMTreatment).DHCGetDataByDefaultSession()
		if ($l(AuStr,"#")=1) {
			s Limited=0
			s AutBit=""
		}
		elseif ($l(AuStr,"#")=2) {
			s Limited=$p(AuStr,"#",1)
			s AutBit=$p(AuStr,"#",2)
		}
		s AuFlag=0
		if (AuStr="")||((AuStr'="")&(Limited=0)) s AuFlag=1 //判断是否有授权,如果没有则全部显示
		
		s TCMTRowId=0
		for
		{
			s TCMTRowId=$o(^MRC("TCMT",TCMTRowId)) q:TCMTRowId=""
			
			//筛选基础数据授权后的数据
			if (($bit(AutBit,TCMTRowId)=1)||(AuFlag=1))
			{
				s TCMTCode=$p($g(^MRC("TCMT",TCMTRowId)),"^",1)  //中医治法代码
				s TCMTDesc=$p($g(^MRC("TCMT",TCMTRowId)),"^",2) //中医治法名称
				s TCMTNationalDesc=$p($g(^MRC("TCMT",TCMTRowId)),"^",4)  //国家标准名称
				s TCMTAlias=$p($g(^MRC("TCMT",TCMTRowId)),"^",8)  //检索码
				s TCMTValid=$p($g(^MRC("TCMT",TCMTRowId)),"^",5) //临床可用标识
				if TCMTValid="" s TCMTValid="Y"
				continue:TCMTValid="N"  //过滤掉临床不可用数据
				s TCMTDateFrom=$p($g(^MRC("TCMT",TCMTRowId)),"^",6)  //开始日期
				s TCMTDateTo=$p($g(^MRC("TCMT",TCMTRowId)),"^",7)  //结束日期
				continue:(TCMTDateFrom'="")&&(TCMTDateFrom>+$h)   //过滤当天不生效的数据
				continue:(TCMTDateTo'="")&&(TCMTDateTo<+$h)    //过滤当天不生效的数据
				i ($ZCVT(TCMTCode,"U")[code)&&($ZCVT(TCMTNationalDesc,"U")[nationaldesc)
				{
					if (desc'="")
					{
						;需要对描述、检索码、别名进行检索      
						s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("MRC_TCMTreatment",TCMTRowId,TCMTDesc,desc)
						s AliasFlag=(AliasFlag||($zcvt(TCMTAlias,"U")[desc))
					}
					else
					{
						s AliasFlag= 1   
					}  
					continue:(AliasFlag'=1)
					d OutputRowCmb
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(TCMTRowId,TCMTCode,TCMTDesc,TCMTNationalDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
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

/// Creator：chenying
/// CreatDate: 2020-12-22
/// Description：数据重复验证方法,js调用
/// Table：User.MRCTCMTreatment中医治法
/// Input：id, desc
/// Return："1"(数据重复),"0"(数据不重复)
/// w ##class(web.DHCBL.CT.MRCTCMTreatment).FormValidate("1","已病防变")
ClassMethod FormValidate(id As %String, desc As %String) As %String
{
	s flag=0	
	///停掉的数据不校验名称和代码
	if id'=""
	{
		s TCMTDateTo=$p($g(^MRC("TCMT",id)),"^",7)
		if (TCMTDateTo'="") q flag
	}
	
	//校验名称
	if (desc'="")
	{
		
		s rowid=0
		for
		{
			s rowid=$o(^MRC("TCMT",0,"Desc",desc,rowid)) q:rowid=""
			s TCMTDateTo=$p($g(^MRC("TCMT",rowid)),"^",7)  //结束日期
			continue:(TCMTDateTo'="")
			if ((desc=$p($g(^MRC("TCMT",rowid)),"^",2))&&(id'=rowid))
			{
				s flag=1	
			}
		}
		
	}
	q flag
}

/// Creator：chenying
/// CreatDate:2020-12-22
/// Description：修改时打开的数据
/// Table：User.MRCTCMTreatment中医治法
/// input: id(中医治法的rowid)
/// Ruturn： Json字符串
/// w ##class(web.DHCBL.CT.MRCTCMTreatment).OpenData(1)
ClassMethod OpenData(id As %String) As %String
{
	s str=""
	s eobj = ##class(web.Entity.CT.MRCTCMTreatment).%New()
	s eobj.TCMTRowId = id
	s eobj.TCMTCode=$p($g(^MRC("TCMT",id)),"^",1)      //中医治法代码
	s eobj.TCMTDesc=$p($g(^MRC("TCMT",id)),"^",2)     //中医治法名称
	s eobj.TCMTNumber=$p($g(^MRC("TCMT",id)),"^",3)  //编号
	s eobj.TCMTNationalDesc=$p($g(^MRC("TCMT",id)),"^",4)  // 国家标准名称
	s eobj.TCMTValid=$p($g(^MRC("TCMT",id)),"^",5)   //临床可用标识
	if eobj.TCMTValid="" s eobj.TCMTValid="Y"
	s eobj.TCMTDateFrom=$p($g(^MRC("TCMT",id)),"^",6)   //开始日期
	s eobj.TCMTDateTo=$p($g(^MRC("TCMT",id)),"^",7)   //结束日期 
	s eobj.TCMTAlias=$p($g(^MRC("TCMT",id)),"^",8)   //检索码
	s eobj.TCMTDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.TCMTDateFrom)  //日期格式转换
	s eobj.TCMTDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.TCMTDateTo)   //日期格式转换
	s:eobj.TCMTValid="Y" eobj.TCMTValid="true"  // //临床可用标识
	s str = eobj.JsonS()	
	s str = "{list:["_str_"]}"
	q str
}

/// Creator：chenying
/// CreatDate: 2020-12-22
/// Description：保存修改中医治法的内容
/// Table：User.MRCTCMTreatment中医治法
/// Input：web.Entity.CT.MRCTCMTreatment 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.CT.MRCTCMTreatment).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.MRCTCMTreatment) As %String
{
	s $ZT="ERROR"
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.TCMTValid="" eobj.TCMTValid="N" //临床可用标识
		s:eobj.TCMTDateFrom'="" eobj.TCMTDateFrom = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.TCMTDateFrom) //开始日期
		s:eobj.TCMTDateTo'="" eobj.TCMTDateTo = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.TCMTDateTo)  //结束日期
		s:eobj.TCMTDateFrom="" eobj.TCMTDateFrom=+$h
		
		if (eobj.TCMTRowId="")&&(eobj.TCMTAlias="") s eobj.TCMTAlias=##class(web.DHCBL.BDP.FunLib).GetPYCODE(eobj.TCMTDesc)  //新增时检索码为空时，生成描述首拼码检索码
		s flag=##class(web.DHCBL.CT.MRCTCMTreatment).FormValidate(eobj.TCMTRowId,eobj.TCMTDesc)  //校验名称
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该名称已经存在！'}"
		}
		else
		{
			if (eobj.TCMTRowId="")  //如果RowId未赋值则增加
			{
				s obj=##class(User.MRCTCMTreatment).%New()
				
		
			}
			else     //如果RowId已赋值则修改
			{
				s obj=##class(User.MRCTCMTreatment).%OpenId(eobj.TCMTRowId)
				s bobj=##class(web.Entity.CT.MRCTCMTreatment).%New()
				s bobj.TCMTRowId = eobj.TCMTRowId   //RowId
				s bobj.TCMTCode = obj.TCMTCode    //中医治法代码
				s bobj.TCMTDesc = obj.TCMTDesc		//中医治法名称
				s bobj.TCMTNumber = obj.TCMTNumber   //编号
				s bobj.TCMTNationalDesc = obj.TCMTNationalDesc  //国家标准名称
				s bobj.TCMTValid = obj.TCMTValid    //临床可用标识
				s bobj.TCMTDateFrom = obj.TCMTDateFrom  //开始日期
				s bobj.TCMTDateTo = obj.TCMTDateTo	 //结束日期
				s bobj.TCMTAlias = obj.TCMTAlias	 //检索码
				
			}      		        	
			s obj.TCMTCode = eobj.TCMTCode   //中医治法代码
			s obj.TCMTDesc = eobj.TCMTDesc    //中医治法名称
			s obj.TCMTNumber = eobj.TCMTNumber   //编号
			s obj.TCMTNationalDesc = eobj.TCMTNationalDesc  //国家标准名称
			s obj.TCMTValid = eobj.TCMTValid   //临床可用标识
			s obj.TCMTDateFrom = eobj.TCMTDateFrom  //开始日期
			s obj.TCMTDateTo = eobj.TCMTDateTo    //结束日期
			s obj.TCMTAlias = eobj.TCMTAlias	 //检索码
			Ts
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				Tc
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}"         //返回RowId
				//保存日志
				d:eobj.TCMTRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MRC_TCMTreatment","User.MRCTCMTreatment","中医治法",id,eobj.TCMTDesc,"A",eobj)
				d:eobj.TCMTRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MRC_TCMTreatment","User.MRCTCMTreatment","中医治法",eobj.TCMTRowId,eobj.TCMTDesc,"U",eobj,bobj)
			}
			else
			{
				Trollback
				s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("中医治法","web.DHCBL.CT.MRCTCMTreatment","SaveEntity",eobj)
     			s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				s result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
			}
		}		
	}
	else
	{
		s result= "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
ERROR
	s result= "{success:'false',errorinfo:'"_$ze_"'}"    //返回错误信息
	Q result
}

/// Creator:chenying 
/// CreatDate:2020-12-22
/// Description:批量更新数据前，批量停用之前的中医治法数据
/// Table:User.MRCTCMTreatment中医治法
/// Input:enddate 结束日期（年-月-日格式）
/// d ##class(web.DHCBL.CT.MRCTCMTreatment).EndAllTCMTreatment("2020-12-31")  //批量停中医治法
ClassMethod EndAllTCMTreatment(enddate) As %String
{
	s enddate=$zdh(enddate,3)
	s id=0
	for
	{
		s id=$o(^MRC("TCMT",id)) q:id=""

		s TCMTDateFrom=$p($g(^MRC("TCMT",id)),"^",6)   //开始日期
		s TCMTDateTo=$p($g(^MRC("TCMT",id)),"^",7)   //结束日期 
		///给结束日期为空，且开始日期早于结束日期的数据，增加结束日期数据。
		if (TCMTDateTo="")&&(TCMTDateFrom'="")&&(TCMTDateFrom<enddate)
		{
			s obj=##class(User.MRCTCMTreatment).%OpenId(id)
			s obj.TCMTDateTo=enddate
			Ts
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				Tc
				s TCMTDesc=$p($g(^MRC("TCMT",id)),"^",2)     //中医治法名称
				w TCMTDesc_",保存成功",!
			}
			else
			{
				Trollback
				w TCMTDesc_","_id_","_$SYSTEM.Status.GetErrorText(sc),!   //输出 治法名称，rowid，错误信息
			}

		}	

	}
}

/// Creator:chenying 
/// CreatDate:2020-12-22
/// Description:对已经导入的中医治法数据，对检索码为空的数据批量生成检索码（描述首拼）
/// Table:User.MRCTCMTreatment中医治法
/// d ##class(web.DHCBL.CT.MRCTCMTreatment).BatchCreatAlias()
ClassMethod BatchCreatAlias() As %String
{
	s id=0
	for
	{
		s id=$o(^MRC("TCMT",id)) q:id=""
		s TCMTAlias=$p($g(^MRC("TCMT",id)),"^",8)   //检索码
		if (TCMTAlias="")  ///检索码为空时
		{
			s obj=##class(User.MRCTCMTreatment).%OpenId(id)
			s TCMTDesc=$p($g(^MRC("TCMT",id)),"^",2)     //中医治法名称
			s obj.TCMTAlias=##class(web.DHCBL.BDP.FunLib).GetPYCODE(TCMTDesc) //检索码
			Ts
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				Tc
				w TCMTDesc_",保存成功",!
			}
			else
			{
				Trollback
				w TCMTDesc_","_id_","_$SYSTEM.Status.GetErrorText(sc),!   //输出 治法名称，rowid，错误信息
			}
		}
	}
}

}
