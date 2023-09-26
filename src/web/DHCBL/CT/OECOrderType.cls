Import SQLUser

/// 名称:  医嘱与结果-系统医嘱类型维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-陈莹
/// 编写日期: 2012-9-4
Class web.DHCBL.CT.OECOrderType Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：陈莹
/// CreatDate: 2012-12-3
/// Description：修改时打开的数据
/// Table：User.OECOrderType
/// Input：id
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s eobj = ##class(web.Entity.CT.OECOrderType).%New()
	s eobj.TYPRowId = id
	s eobj.TYPCode=$p($g(^OEC("TYP",eobj.TYPRowId)),"^",1)
	s eobj.TYPDesc=$p($g(^OEC("TYP",eobj.TYPRowId)),"^",2)
	
	s str = eobj.JsonS()	
	d eobj.%Close()
	s str = "{list:["_str_"]}"
	q str
}

/// Creator：陈莹
/// CreatDate: 2012-12-3  modified @201702015
/// Description：数据重复验证方法,js调用
/// Table：User.OECOrderType
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
	s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
	s flag="",flagc="",flagd=""
	s:code'="" flagc=$d(^OEC("TYP",0,"Code",code))
	s:desc'="" flagd=$d(^OEC("TYP",0,"Desc",desc))
	if (id="") //如果为空，增加时的重复判断
	{
		if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc="",idd=""
		s:code'="" idc=$o(^OEC("TYP",0,"Code",code,0))
		s:desc'="" idd=$o(^OEC("TYP",0,"Desc",desc,0))
		if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	q flag
}

/// Creator：陈莹
/// CreatDate: 2012-9-4
/// Description：保存修改系统医嘱类型的内容
/// Table：User.OECOrderType
/// Input：web.Entity.CT.OECOrderType 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.CT.OECOrderType).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.CT.OECOrderType) As %String
{
	n (eobj,%session)
	s result=""
	if $IsObject(eobj)
	{
		s flag=..FormValidate(eobj.TYPRowId,eobj.TYPCode,eobj.TYPDesc)  //调用重复验证
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		else
		{
			if (eobj.TYPRowId="")  //如果RowId未赋值则增加
			{
				s obj=##class(User.OECOrderType).%New()
			}
			else                   //如果RowId已赋值则修改
			{
				s obj=##class(User.OECOrderType).%OpenId(eobj.TYPRowId)
				s bobj=##class(web.Entity.CT.OECOrderType).%New()
				s bobj.TYPRowId = eobj.TYPRowId
				s bobj.TYPCode = obj.TYPCode
				s bobj.TYPDesc = obj.TYPDesc
			}
			Ts	        		        	
			s obj.TYPCode = eobj.TYPCode          //修改代码
			s obj.TYPDesc = eobj.TYPDesc          //修改描述
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				Tc
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}"         //返回RowId
				//保存日志
				d:eobj.TYPRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("OEC_OrderType","User.OECOrderType","系统医嘱类型",id,eobj.TYPDesc,"A",eobj)
				d:eobj.TYPRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("OEC_OrderType","User.OECOrderType","系统医嘱类型",eobj.TYPRowId,eobj.TYPDesc,"U",eobj,bobj)
			}
			else
			{
				Trollback
				s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("系统医嘱类型","web.DHCBL.CT.OECOrderType","SaveEntity",eobj)
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
/// Description：根据ID删除系统医嘱类型的内容
/// Table：User.OECOrderType
/// Input：Id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	s eobj = ##class(web.Entity.CT.OECOrderType).%New()
	s eobj.TYPRowId = id
	s eobj.TYPCode=$p($g(^OEC("TYP",eobj.TYPRowId)),"^",1)
	s eobj.TYPDesc=$p($g(^OEC("TYP",eobj.TYPRowId)),"^",2)
	ts
	s sc=##class(User.OECOrderType).%DeleteId(id)
	i $$$ISOK(sc)
	{
		tc
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("OEC_OrderType","User.OECOrderType","系统医嘱类型",id,eobj.TYPDesc,"D",eobj)
		d eobj.%Close()
	}
	else 
	{
		tro
		s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("系统医嘱类型","web.DHCBL.CT.OECOrderType","DeleteData",eobj)
   		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	q result
}

/// Creator：陈莹
/// CreatDate: 2012-9-4
/// Description：查询系统医嘱类型的内容
/// Table：User.OECOrderType
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.OECOrderType","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "TYPRowId:%String,TYPCode:%String,TYPDesc:%String,BDPInternalCode:%String,BDPInternalDesc:%String,BDPHospNationalCode:%String,BDPHospNationalDesc:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s TYPRowId = rowid
		s TYPCode = $p($g(^OEC("TYP",TYPRowId)),"^",1)
		s TYPDesc = $p($g(^OEC("TYP",TYPRowId)),"^",2)
		s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc=""  
		s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("OEC_OrderType",TYPRowId)
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
		s AuStr=##class(web.DHCBL.Authorize.OECOrderType).DHCGetDataByDefaultSession()
		s AuFlag=0
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示

		s TYPRowId=0
		f {
			s TYPRowId=$o(^OEC("TYP",TYPRowId))
			q:TYPRowId=""
			//筛选授权后的数据
			s strRowId="{ID:"_TYPRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) {
				s TYPCode = $p($g(^OEC("TYP",TYPRowId)),"^",1)
				s TYPDesc = $p($g(^OEC("TYP",TYPRowId)),"^",2)
				s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc=""  
				s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("OEC_OrderType",TYPRowId)
				s BDPInternalCode =$p($g(resultStr),"^",1)       
				s BDPInternalDesc = $p($g(resultStr),"^",2)  
				s BDPHospNationalCode=$p($g(resultStr),"^",3)         
				s BDPHospNationalDesc = $p($g(resultStr),"^",4)  
				if (desc'="")           
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("OEC_OrderType",TYPRowId,TYPDesc,desc)
				}
				else
				{
					s AliasFlag= 1   
				} 
				i ($zcvt(TYPCode,"u")[code)&(AliasFlag=1)
				{
					d OutputRow
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(TYPRowId,TYPCode,TYPDesc,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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
/// Description：系统医嘱类型,为combobox查询取数据
/// Table：User.OECOrderType
/// Input：rowid,code,desc
/// Return：TYPRowId,TYPCode,TYPDesc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.OECOrderType","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "TYPRowId:%String,TYPCode:%String,TYPDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s TYPRowId = rowid
		s TYPCode = $p($g(^OEC("TYP",TYPRowId)),"^",1)
		s TYPDesc = $p($g(^OEC("TYP",TYPRowId)),"^",2)
		d OutputRowCmb
	}
	else
	{
		s:code'="" code=$zcvt(code,"U") //转换成大写
		s:desc'="" desc=$zcvt(desc,"U") //转换成大写
		//获取授权Json
		s AuStr=##class(web.DHCBL.Authorize.OECOrderType).DHCGetDataByDefaultSession()
		s AuFlag=0
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
	

		s TYPRowId=0
		f {
			s TYPRowId=$o(^OEC("TYP",TYPRowId))
			q:TYPRowId=""
			//筛选授权后的数据
			s strRowId="{ID:"_TYPRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) {
				s TYPCode = $p($g(^OEC("TYP",TYPRowId)),"^",1)
				s TYPDesc = $p($g(^OEC("TYP",TYPRowId)),"^",2)
				if (desc'="")           
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("OEC_OrderType",TYPRowId,TYPDesc,desc)
				}
				else
				{
					s AliasFlag= 1   
				} 
				i ($zcvt(TYPCode,"u")[code)&(AliasFlag=1)
				{
					d OutputRowCmb
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(TYPRowId,TYPCode,TYPDesc)
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
