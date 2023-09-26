Import SQLUser

/// 名称: 医嘱与结果-操作部位维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-陈莹
/// 编写日期: 2012-9-4
Class web.DHCBL.CT.OECBodySite Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：陈莹
/// CreatDate: 2012-12-3
/// Description：修改时打开的数据
/// Table：User.OECBodySite
/// Input：id
ClassMethod OpenData(id As %String) As %String
{
	n (id)
	s str=""	
	s eobj = ##class(web.Entity.CT.OECBodySite).%New()
	s eobj.BODSRowId = id
	s eobj.BODSCode=$p($g(^OEC("BODS",eobj.BODSRowId)),"^",1)
	s eobj.BODSDesc=$p($g(^OEC("BODS",eobj.BODSRowId)),"^",2)	
	
	s str = eobj.JsonS()	
	d eobj.%Close()
	s str = "{list:["_str_"]}"
	q str
}

/// Creator：陈莹
/// CreatDate: 2012-12-3  modified @201702015
/// Description：数据重复验证方法,js调用
/// Table：User.OECBodySite
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	n (id,code,desc)
	s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
	s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
	s flag="",flagc="",flagd=""
	s:code'="" flagc=$d(^OEC("BODS",0,"Code",code))
	s:desc'="" flagd=$d(^OEC("BODS",0,"Desc",desc))
	if (id="") //如果为空，增加时的重复判断
	{
		if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc="",idd=""
		s:code'="" idc=$o(^OEC("BODS",0,"Code",code,0))
		s:desc'="" idd=$o(^OEC("BODS",0,"Desc",desc,0))
		if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	q flag
}

/// Creator：陈莹
/// CreatDate: 2012-9-4
/// Description：保存修改操作部位的内容
/// Table：User.OECBodySite
/// Input：web.Entity.CT.OECBodySite 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.CT.OECBodySite).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.CT.OECBodySite) As %String
{
	n (eobj,%session)
	s result=""
	if $IsObject(eobj)
	{
		
		s flag=..FormValidate(eobj.BODSRowId,eobj.BODSCode,eobj.BODSDesc)  //调用重复验证
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		else
		{
			if (eobj.BODSRowId="")  //如果RowId未赋值则增加
			{
				s obj=##class(User.OECBodySite).%New()
			}
			else                    //如果RowId已赋值则修改
			{
				s obj=##class(User.OECBodySite).%OpenId(eobj.BODSRowId)
				s bobj=##class(web.Entity.CT.OECBodySite).%New()
				s bobj.BODSRowId = eobj.BODSRowId
				s bobj.BODSCode = obj.BODSCode
				s bobj.BODSDesc = obj.BODSDesc
			}	        		        	
			s obj.BODSCode = eobj.BODSCode          //修改代码
			s obj.BODSDesc = eobj.BODSDesc          //修改描述
			Ts
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				Tc
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}"         //返回RowId
				//保存日志
				d:eobj.BODSRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("OEC_BodySite","User.OECBodySite","操作部位",id,eobj.BODSDesc,"A",eobj)
				d:eobj.BODSRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("OEC_BodySite","User.OECBodySite","操作部位",eobj.BODSRowId,eobj.BODSDesc,"U",eobj,bobj)
			}
			else
			{
				Trollback
				s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("操作部位","web.DHCBL.CT.OECBodySite","SaveEntity",eobj)
     			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
			}
		}	
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
}

/// Creator：陈莹
/// CreatDate: 2012-9-4
/// Description：根据ID删除操作部位的内容
/// Table：User.OECBodySite
/// Input：Id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
	n (id,%session)
	s result=""
	s re=##class(web.DHCBL.CT.OECBodySite).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0){
		s eobj = ##class(web.Entity.CT.OECBodySite).%New()
		s eobj.BODSRowId = id
		s eobj.BODSCode=$p($g(^OEC("BODS",eobj.BODSRowId)),"^",1)
		s eobj.BODSDesc=$p($g(^OEC("BODS",eobj.BODSRowId)),"^",2)
		ts
		s sc=##class(User.OECBodySite).%DeleteId(id)
		i $$$ISOK(sc)
		{
			tc
			s result = "{success:'true',info:'删除成功！'}"	
			//保存日志
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("OEC_BodySite","User.OECBodySite","操作部位",id,eobj.BODSDesc,"D",eobj)
			d eobj.%Close()
		}
		else 
		{
			tro
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("操作部位","web.DHCBL.CT.OECBodySite","DeleteData",eobj)
     		s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
	}
	else{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}
	q result
}

/// Creator:陈莹
/// CreatDate:2016-8-10
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
ClassMethod GetRefFlag(id As %String) As %String
{
	n (id)
	s return="",myInfo=""

	s OPERRowId=0,flag=0
	for
	{
		s OPERRowId=$o(^ORC("OPER",OPERRowId)) q:(OPERRowId="")||(flag=1)
		s OPERBodySiteDr=$p($g(^ORC("OPER",OPERRowId,"DHC")),"^",2)   //手术部位表
		i OPERBodySiteDr=id
		{
			s flag=1
			s myInfo=myInfo_"<手术/过程扩展信息表>"
		}
	}
	
	
	i myInfo="" s return="0^未被引用可删除！"
	else  s return="1^在"_myInfo_"表里被引用,不能删除！"
	q return
}

/// Creator：陈莹
/// CreatDate: 2012-9-4
/// Description：查询操作部位的内容
/// Table：User.OECBodySite
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.OECBodySite","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "BODSRowId:%String,BODSCode:%String,BODSDesc:%String,BDPInternalCode:%String,BDPInternalDesc:%String,BDPHospNationalCode:%String,BDPHospNationalDesc:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s BODSRowId = rowid
		s BODSCode = $p($g(^OEC("BODS",BODSRowId)),"^",1)
		s BODSDesc = $p($g(^OEC("BODS",BODSRowId)),"^",2)
		s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc=""  
		s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("OEC_BodySite",BODSRowId)
		s BDPInternalCode =$p($g(resultStr),"^",1)       
		s BDPInternalDesc = $p($g(resultStr),"^",2)  
		s BDPHospNationalCode=$p($g(resultStr),"^",3)         
		s BDPHospNationalDesc = $p($g(resultStr),"^",4)  
		d OutputRow
	}
	else
	{
		s:code'="" code=$zcvt(code,"U") //转换成大写
		s:desc'="" desc=$zcvt(desc,"U") //转换成大写
		//获取授权Json
		s AuStr=##class(web.DHCBL.Authorize.OECBodySite).DHCGetDataByDefaultSession()
		s AuFlag=0
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
	
		s BODSRowId=0
		f {
			s BODSRowId=$o(^OEC("BODS",BODSRowId))
			q:BODSRowId=""
			//筛选授权后的数据
			s strRowId="{ID:"_BODSRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) {
				s BODSCode = $p($g(^OEC("BODS",BODSRowId)),"^",1)
				s BODSDesc = $p($g(^OEC("BODS",BODSRowId)),"^",2)
				s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc=""  
				s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("OEC_BodySite",BODSRowId)
				s BDPInternalCode =$p($g(resultStr),"^",1)       
				s BDPInternalDesc = $p($g(resultStr),"^",2)  
				s BDPHospNationalCode=$p($g(resultStr),"^",3)         
				s BDPHospNationalDesc = $p($g(resultStr),"^",4)  
				
				
				if (desc'="")
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("OEC_BodySite",BODSRowId,BODSDesc,desc)
				}
				else
				{
					s AliasFlag= 1   
				}
				
				i ($ZCVT(BODSCode,"U")[code)&&(AliasFlag=1)
				{
					d OutputRow
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(BODSRowId,BODSCode,BODSDesc,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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

/// Creator：陈莹
/// CreatDate: 2012-12-10
/// Description：操作部位,为combobox查询取数据
/// Table：User.OECBodySite
/// Input：rowid,code,desc
/// Return：BODSRowId,BODSCode,BODSDesc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.OECBodySite","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "BODSRowId:%String,BODSCode:%String,BODSDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s BODSRowId = rowid
		s BODSCode = $p($g(^OEC("BODS",BODSRowId)),"^",1)
		s BODSDesc = $p($g(^OEC("BODS",BODSRowId)),"^",2)
		d OutputRowCmb
	}
	else
	{
		s:code'="" code=$zcvt(code,"U") //转换成大写
		s:desc'="" desc=$zcvt(desc,"U") //转换成大写
		//获取授权Json
		s AuStr=##class(web.DHCBL.Authorize.OECBodySite).DHCGetDataByDefaultSession()
		s AuFlag=0
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
	

		s BODSRowId=0
		f {
			s BODSRowId=$o(^OEC("BODS",BODSRowId))
			q:BODSRowId=""
			//筛选授权后的数据
			s strRowId="{ID:"_BODSRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) {
				s BODSCode = $p($g(^OEC("BODS",BODSRowId)),"^",1)
				s BODSDesc = $p($g(^OEC("BODS",BODSRowId)),"^",2)
				if (desc'="")
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("OEC_BodySite",BODSRowId,BODSDesc,desc)
				}
				else
				{
					s AliasFlag= 1   
				}
				
				i ($zcvt(BODSCode,"U")[code)&&(AliasFlag=1)
				{
					d OutputRowCmb
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(BODSRowId,BODSCode,BODSDesc)
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

}
