Import SQLUser

/// 名称: 生理周期维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-杨本庆
/// 编写日期:  2017-12-1
Class web.DHCBL.CT.DHCPhysiologicalCycle Extends %RegisteredObject
{

/// Description：修改时打开的数据
/// Table：User.DHCPhysiologicalCycle
/// Input：id
/// Other: w ##class(web.DHCBL.CT.DHCPhysiologicalCycle).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s eobj = ##class(web.Entity.CT.DHCPhysiologicalCycle).%New()
	s eobj.PHYCRowId=id
	s eobj.PHYCCode=$p($g(^DHCPHYC(id)),"^",1)
	s eobj.PHYCDesc=$p($g(^DHCPHYC(id)),"^",2)
	s eobj.PHYCActiveFlag=$p($g(^DHCPHYC(id)),"^",3)
	s:eobj.PHYCActiveFlag="Y" eobj.PHYCActiveFlag="true"
	s:eobj.PHYCActiveFlag="N" eobj.PHYCActiveFlag="no"
	s str = eobj.JsonS()	
	d eobj.%Close()
	s str = "{list:["_str_"]}"
	q str
}

/// Description：数据重复验证方法，由js调用
/// Table：User.DHCPhysiologicalCycle
/// Input：id, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod Validate(id As %String, code As %String, desc As %String) As %String
{
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s flag="",flagc="",flagd=""
	s:code'="" flagc=$d(^DHCPHYCi(0,"Code",code))
	s:desc'="" flagd=$d(^DHCPHYCi(0,"Desc",desc))
	if (id="") //如果为空，增加时的重复判断
	{
		if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc="",idd=""
		s:code'="" idc=$o(^DHCPHYCi(0,"Code",code,0))
		s:desc'="" idd=$o(^DHCPHYCi(0,"Desc",desc,0))
		if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	q flag
}

/// Description：保存生理周期的内容
/// Table：User.DHCPhysiologicalCycle
/// Input：web.Entity.CT.DHCPhysiologicalCycle 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.CT.DHCPhysiologicalCycle).SaveData()
ClassMethod SaveData(eobj As web.Entity.CT.DHCPhysiologicalCycle) As %String
{
	s $zt="ERROE"
	s result="",flag=""
	if $IsObject(eobj)
	{	
		s flag=..Validate(eobj.PHYCRowId,eobj.PHYCCode,eobj.PHYCDesc)  //调用重复验证
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		else
		{
			if (eobj.PHYCRowId="")  //如果RowId未赋值则增加
			{
				s obj=##class(User.DHCPhysiologicalCycle).%New()
			}
			else                     //如果RowId已赋值则修改
			{
				s obj=##class(User.DHCPhysiologicalCycle).%OpenId(eobj.PHYCRowId)
				s bobj=##class(web.Entity.CT.DHCPhysiologicalCycle).%New()
				s bobj.PHYCRowId=eobj.PHYCRowId
				s bobj.PHYCCode=obj.PHYCCode
				s bobj.PHYCDesc = obj.PHYCDesc          //修改描述
				s bobj.PHYCActiveFlag = obj.PHYCActiveFlag 
			}
			Ts
			s obj.PHYCCode = eobj.PHYCCode
			s obj.PHYCDesc = eobj.PHYCDesc          //修改描述
			s:eobj.PHYCActiveFlag'="" obj.PHYCActiveFlag = eobj.PHYCActiveFlag  
			s:eobj.PHYCActiveFlag="" obj.PHYCActiveFlag = "N"		
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				Tc
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}"  //返回RowId
				//新增时，日志
				d:eobj.PHYCRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PhysiologicalCycle","User.DHCPhysiologicalCycle","生理周期",id,eobj.PHYCDesc,"A",eobj)
				//修改时，日志
				d:eobj.PHYCRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PhysiologicalCycle","User.DHCPhysiologicalCycle","生理周期",eobj.PHYCRowId,eobj.PHYCDesc,"U",eobj,bobj)
			}
			else
			{
				Trollback
				s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
				s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("生理周期","web.DHCBL.CT.DHCPhysiologicalCycle","SaveData",eobj)
    			s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
			}
		}				
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
ERROE
	s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("生理周期","web.DHCBL.CT.DHCPhysiologicalCycle","SaveData",eobj)
  	s ^ERRORLOGINFO(logid)=$ze
	q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Description：查询生理周期的内容
/// Table：User.DHCPhysiologicalCycle
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DHCPhysiologicalCycle","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "PHYCRowId:%String,PHYCCode:%String,PHYCDesc:%String,PHYCActiveFlag")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权
	//s AuStr=##class(web.DHCBL.Authorize.DHCPhysiologicalCycle).DHCGetDataByDefaultSession()
	//s AuFlag=0
	//if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s PHYCRowId=rowid
		s PHYCCode=$p($g(^DHCPHYC(PHYCRowId)),"^",1)
		s PHYCDesc=$p($g(^DHCPHYC(PHYCRowId)),"^",2)
		s PHYCActiveFlag=$p($g(^DHCPHYC(PHYCRowId)),"^",3)
	
		d OutputRow
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U") //转换成大写
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		s PHYCRowId=0
		for {
			s PHYCRowId=$o(^DHCPHYC(PHYCRowId))
			q:PHYCRowId=""
			//筛选授权后的数据
			//s strRowId="{ID:"_PHYCRowId_"}"
			//if (AuStr[strRowId)||(AuFlag=1) {
				s PHYCCode=$p($g(^DHCPHYC(PHYCRowId)),"^",1)
				s PHYCDesc=$p($g(^DHCPHYC(PHYCRowId)),"^",2)
				s PHYCActiveFlag=$p($g(^DHCPHYC(PHYCRowId)),"^",3)
				if (desc'="")
		        {
		        	;需要对描述或者别名进行检索      
		        	s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("DHC_PhysiologicalCycle",PHYCRowId,PHYCDesc,desc)
		        }
		        else
		        {
		        	s AliasFlag= 1   
		        } 
		        if ($$ALPHAUP^SSUTIL4(PHYCCode)[code)&(AliasFlag=1)
		        //s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(PHYCDesc)	
				//if ($ZCONVERT(PHYCCode,"U")[code)&(($ZCONVERT(PHYCDesc,"U")[desc)||(PINYIN[desc))
				{
					d OutputRow
				}
			//}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PHYCRowId,PHYCCode,PHYCDesc,PHYCActiveFlag)
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

/// Description:为combobox查询取数据
/// Table：User.DHCPhysiologicalCycle
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DHCPhysiologicalCycle","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "PHYCRowId:%String,PHYCCode:%String,PHYCDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权
	//s AuStr=##class(web.DHCBL.Authorize.DHCPhysiologicalCycle).DHCGetDataByDefaultSession()
	//s AuFlag=0
	//if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s PHYCRowId=rowid
		s PHYCCode=$p($g(^DHCPHYC(PHYCRowId)),"^",1)
		s PHYCDesc=$p($g(^DHCPHYC(PHYCRowId)),"^",2)	
		d OutputRowCmb
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U") //转换成大写
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		s PHYCRowId=0
		for {
			s PHYCRowId=$o(^DHCPHYC(PHYCRowId))
			q:PHYCRowId=""
			//筛选授权后的数据
			//s strRowId="{ID:"_PHYCRowId_"}"
			//if (AuStr[strRowId)||(AuFlag=1) {
				s PHYCCode=$p($g(^DHCPHYC(PHYCRowId)),"^",1)
				s PHYCDesc=$p($g(^DHCPHYC(PHYCRowId)),"^",2)
				/*s uPHYCDesc=$ZCONVERT(PHYCDesc,"U")
				s PINYIN=""
				s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(uPHYCDesc)				
				if ($ZCONVERT(PHYCCode,"U")[code)&(($ZCONVERT(PHYCDesc,"U")[desc)||(PINYIN[desc))*/
				if (desc'="")
		        {
		        	;需要对描述或者别名进行检索      
		        	s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("DHC_PhysiologicalCycle",PHYCRowId,PHYCDesc,desc)
		        }
		        else
		        {
		        	s AliasFlag= 1   
		        } 
		        
		        if ($$ALPHAUP^SSUTIL4(PHYCCode)[code)&(AliasFlag=1)
				{
					d OutputRowCmb
				}
			//}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(PHYCRowId,PHYCCode,PHYCDesc)
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

/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// w ##class(web.DHCBL.CT.DHCPhysiologicalCycle).GetRefFlag("7")
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""
	s lev=0,flag=0
	for
	{
		s lev=$o(^DHCPHYCi(0,lev)) q:(lev="")||(flag=1)  d
		s haslev=$d(^DHCPHYCi(0,lev,id))
		if haslev
		{
			s flag=1
		}
		
	}
	if (flag){
		s myInfo=myInfo_"<关联生理周期>"
	}	
	s PHYCCode=$p($g(^DHCPHYC(id)),"^",1)
	i ($d(^DHCPHSYMCON(0,"HisCode",PHYCCode)))
	{
		s myInfo=myInfo_"<知识库症状字典对照>"
	}
	i myInfo="" s return="0^未被引用可删除！"
	else  s return="1^在"_myInfo_"表里被引用,不能删除！"
	q return
}

/// Description：根据ID删除生理周期的内容
/// Table：User.DHCPhysiologicalCycle
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
	s result=""	
	//s re=##class(web.DHCBL.CT.DHCPhysiologicalCycle).GetRefFlag(id)
	//s RefFlag=$p(re,"^",1)
	//if (RefFlag=0){
		//new Entity对象，用于保存日志
		s pobj = ##class(User.DHCPhysiologicalCycle).%OpenId(id)
		s eobj = ##class(web.Entity.CT.DHCPhysiologicalCycle).%New()
		s eobj.PHYCRowId = id
		s eobj.PHYCCode=pobj.PHYCCode
		s eobj.PHYCDesc=pobj.PHYCDesc
		s eobj.PHYCActiveFlag=pobj.PHYCActiveFlag
		d pobj.%Close()
		k pobj
		Tstart
		s sc=##class(User.DHCPhysiologicalCycle).%DeleteId(id)
		if $$$ISOK(sc)
		{
			Tcommit
			s result = "{success:'true',info:'删除成功！'}"	
			//保存日志
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PhysiologicalCycle","User.DHCPhysiologicalCycle","生理周期",id,eobj.PHYCDesc,"D",eobj)
			d eobj.%Close()
		}
		else 
		{
			Trollback
			s result = "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("生理周期","web.DHCBL.CT.DHCPhysiologicalCycle","DeleteData",eobj)
    		s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
		}
	/*}
	else{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}*/
	
	q result
}

}
