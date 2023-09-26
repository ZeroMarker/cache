Import SQLUser

/// 名称:  医嘱与结果-医嘱执行状态维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-陈莹
/// 编写日期: 2012-9-4
Class web.DHCBL.CT.OECOrderAdminStatus Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：陈莹
/// CreatDate: 2012-12-3
/// Description：修改时打开的数据
/// Table：User.OECOrderAdminStatus
/// Input：id
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s eobj = ##class(web.Entity.CT.OECOrderAdminStatus).%New()
	s eobj.STATRowId = id
	s eobj.STATCode=$p($g(^OEC("STAT",eobj.STATRowId)),"^",1)
	s eobj.STATDesc=$p($g(^OEC("STAT",eobj.STATRowId)),"^",2)
	s eobj.STATBill=$p($g(^OEC("STAT",eobj.STATRowId)),"^",3)
	s eobj.STATDeductStock=$p($g(^OEC("STAT",eobj.STATRowId)),"^",4)
	s eobj.STATIVCompleted=$p($g(^OEC("STAT",eobj.STATRowId)),"^",5)
	s eobj.STATCanAdminSkinTest=$p($g(^OEC("STAT",eobj.STATRowId)),"^",6)
	
	s:eobj.STATBill="Y" eobj.STATBill="true"	
	s:eobj.STATDeductStock="Y" eobj.STATDeductStock="true"
	s:eobj.STATIVCompleted="Y" eobj.STATIVCompleted="true"
	s:eobj.STATCanAdminSkinTest="Y" eobj.STATCanAdminSkinTest="true"
	
	s str = eobj.JsonS()	
	d eobj.%Close()
	s str = "{list:["_str_"]}"
	q str
}

/// Creator：陈莹
/// CreatDate: 2012-12-3  modified @201702015
/// Description：数据重复验证方法,js调用
/// Table：User.OECOrderAdminStatus
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
	s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
	s flag="",flagc="",flagd=""
	s:code'="" flagc=$d(^OEC("STAT",0,"Code",code))
	s:desc'="" flagd=$d(^OEC("STAT",0,"Desc",desc))
	if (id="") //如果为空，增加时的重复判断
	{
		if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc="",idd=""
		s:code'="" idc=$o(^OEC("STAT",0,"Code",code,0))
		s:desc'="" idd=$o(^OEC("STAT",0,"Desc",desc,0))
		if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	q flag
}

/// Creator：陈莹
/// CreatDate: 2012-9-4
/// Description：保存修改医嘱执行状态的内容
/// Table：User.OECOrderAdminStatus
/// Input：web.Entity.CT.OECOrderAdminStatus 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.CT.OECOrderAdminStatus).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.CT.OECOrderAdminStatus) As %String
{
	n (eobj,%session)
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.STATBill="" eobj.STATBill="N"
		s:eobj.STATDeductStock="" eobj.STATDeductStock="N"
		s:eobj.STATIVCompleted="" eobj.STATIVCompleted="N"
		s:eobj.STATCanAdminSkinTest="" eobj.STATCanAdminSkinTest="N"
		
		s flag=..FormValidate(eobj.STATRowId,eobj.STATCode,eobj.STATDesc)  //调用重复验证
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		else
		{
			if (eobj.STATRowId="")  //如果RowId未赋值则增加
			{
				s obj=##class(User.OECOrderAdminStatus).%New()
			}
			else                    //如果RowId已赋值则修改
			{
				s obj=##class(User.OECOrderAdminStatus).%OpenId(eobj.STATRowId)
				s bobj=##class(web.Entity.CT.OECOrderAdminStatus).%New()
				s bobj.STATRowId = eobj.STATRowId
				s bobj.STATCode = obj.STATCode
				s bobj.STATDesc = obj.STATDesc
				s bobj.STATBill = obj.STATBill
				s bobj.STATDeductStock = obj.STATDeductStock
				s bobj.STATIVCompleted = obj.STATIVCompleted
				s bobj.STATCanAdminSkinTest = obj.STATCanAdminSkinTest
			}			
			Ts	        		        	
			s obj.STATCode = eobj.STATCode          //修改代码
			s obj.STATDesc = eobj.STATDesc          //修改描述
			s obj.STATBill = eobj.STATBill
			s obj.STATDeductStock = eobj.STATDeductStock
			s obj.STATIVCompleted = eobj.STATIVCompleted
			s obj.STATCanAdminSkinTest = eobj.STATCanAdminSkinTest
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				Tc
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}"         //返回RowId
				//保存日志
				d:eobj.STATRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("OEC_Order_AdminStatus","User.OECOrderAdminStatus","医嘱执行状态",id,eobj.STATDesc,"A",eobj)
				d:eobj.STATRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("OEC_Order_AdminStatus","User.OECOrderAdminStatus","医嘱执行状态",eobj.STATRowId,eobj.STATDesc,"U",eobj,bobj)
			}
			else
			{
				Trollback
				s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医嘱执行状态","web.DHCBL.CT.OECOrderAdminStatus","SaveEntity",eobj)
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
/// Description：根据ID删除医嘱执行状态的内容
/// Table：User.OECOrderAdminStatus
/// Input：Id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	s eobj = ##class(web.Entity.CT.OECOrderAdminStatus).%New()
	s eobj.STATRowId = id
	s eobj.STATCode=$p($g(^OEC("STAT",eobj.STATRowId)),"^",1)
	s eobj.STATDesc=$p($g(^OEC("STAT",eobj.STATRowId)),"^",2)
	s eobj.STATBill=$p($g(^OEC("STAT",eobj.STATRowId)),"^",3)
	s eobj.STATDeductStock=$p($g(^OEC("STAT",eobj.STATRowId)),"^",4)
	s eobj.STATIVCompleted=$p($g(^OEC("STAT",eobj.STATRowId)),"^",5)
	s eobj.STATCanAdminSkinTest=$p($g(^OEC("STAT",eobj.STATRowId)),"^",6)
	ts
	s sc=##class(User.OECOrderAdminStatus).%DeleteId(id)
	i $$$ISOK(sc)
	{
		tc
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("OEC_Order_AdminStatus","User.OECOrderAdminStatus","医嘱执行状态",id,eobj.STATDesc,"D",eobj)
		d eobj.%Close()
	}
	else 
	{
		tro
		s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医嘱执行状态","web.DHCBL.CT.OECOrderAdminStatus","DeleteData",eobj)
     	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	q result
}

/// Creator：陈莹
/// CreatDate: 2012-9-4
/// Description：查询医嘱执行状态的内容
/// Table：User.OECOrderAdminStatus
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.OECOrderAdminStatus","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "STATRowId:%String,STATCode:%String,STATDesc:%String,STATBill:%String,STATDeductStock:%String,STATIVCompleted:%String,STATCanAdminSkinTest:%String,BDPInternalCode:%String,BDPInternalDesc:%String,BDPHospNationalCode:%String,BDPHospNationalDesc:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s STATRowId = rowid
		s STATCode = $p($g(^OEC("STAT",STATRowId)),"^",1)
		s STATDesc = $p($g(^OEC("STAT",STATRowId)),"^",2)
		s STATBill = $p($g(^OEC("STAT",STATRowId)),"^",3)
		s STATDeductStock = $p($g(^OEC("STAT",STATRowId)),"^",4)
		s STATIVCompleted = $p($g(^OEC("STAT",STATRowId)),"^",5)
		s STATCanAdminSkinTest = $p($g(^OEC("STAT",STATRowId)),"^",6)
		s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc=""  
		s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("OEC_Order_AdminStatus",STATRowId)
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
		s AuStr=##class(web.DHCBL.Authorize.OECOrderAdminStatus).DHCGetDataByDefaultSession()
		s AuFlag=0
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示

		s STATRowId=0
		f {
			s STATRowId=$o(^OEC("STAT",STATRowId))
			q:STATRowId=""
			//筛选授权后的数据
			s strRowId="{ID:"_STATRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) {
				s STATCode = $p($g(^OEC("STAT",STATRowId)),"^",1)
				s STATDesc = $p($g(^OEC("STAT",STATRowId)),"^",2)
				s STATBill = $p($g(^OEC("STAT",STATRowId)),"^",3)
				s STATDeductStock = $p($g(^OEC("STAT",STATRowId)),"^",4)
				s STATIVCompleted = $p($g(^OEC("STAT",STATRowId)),"^",5)
				s STATCanAdminSkinTest = $p($g(^OEC("STAT",STATRowId)),"^",6)
				s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc=""  
				s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("OEC_Order_AdminStatus",STATRowId)
				s BDPInternalCode =$p($g(resultStr),"^",1)       
				s BDPInternalDesc = $p($g(resultStr),"^",2)  
				s BDPHospNationalCode=$p($g(resultStr),"^",3)         
				s BDPHospNationalDesc = $p($g(resultStr),"^",4)  
				
				if (desc'="")            
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("OEC_Order_AdminStatus",STATRowId,STATDesc,desc)
				}
				else
				{
					s AliasFlag= 1   
				}  
				i ($zcvt(STATCode,"u")[code)&&(AliasFlag=1)
				{
					d OutputRow
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(STATRowId,STATCode,STATDesc,STATBill,STATDeductStock,STATIVCompleted,STATCanAdminSkinTest,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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
/// Description：医嘱执行状态,为combobox查询取数据
/// Table：User.OECOrderAdminStatus
/// Input：rowid,code,desc
/// Return：STATRowId,STATCode,STATDesc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.OECOrderAdminStatus","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "STATRowId:%String,STATCode:%String,STATDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s STATRowId = rowid
		s STATCode = $p($g(^OEC("STAT",STATRowId)),"^",1)
		s STATDesc = $p($g(^OEC("STAT",STATRowId)),"^",2)
		d OutputRowCmb
	}
	else
	{
		s:code'="" code=$zcvt(code,"U") //转换成大写
		s:desc'="" desc=$zcvt(desc,"U") //转换成大写
		//获取授权Json
		s AuStr=##class(web.DHCBL.Authorize.OECOrderAdminStatus).DHCGetDataByDefaultSession()
		s AuFlag=0
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
	

		s STATRowId=0
		f {
			s STATRowId=$o(^OEC("STAT",STATRowId))
			q:STATRowId=""
			//筛选授权后的数据
			s strRowId="{ID:"_STATRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) {
				s STATCode = $p($g(^OEC("STAT",STATRowId)),"^",1)
				s STATDesc = $p($g(^OEC("STAT",STATRowId)),"^",2)
				if (desc'="")            
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("OEC_Order_AdminStatus",STATRowId,STATDesc,desc)
				}
				else
				{
					s AliasFlag= 1   
				}  
				i ($zcvt(STATCode,"u")[code)&&(AliasFlag=1)
				{
					d OutputRowCmb
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(STATRowId,STATCode,STATDesc)
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
