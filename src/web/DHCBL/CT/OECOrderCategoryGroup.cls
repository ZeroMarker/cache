Import SQLUser

/// 名称: 医嘱与结果- 医嘱类组维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-陈莹
/// 编写日期: 2012-8-31
Class web.DHCBL.CT.OECOrderCategoryGroup Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：陈莹
/// CreatDate: 2012-12-3
/// Description：修改时打开的数据
/// Table：User.OECOrderCategoryGroup
/// Input：id
/// w ##class(web.DHCBL.CT.OECOrderCategoryGroup).OpenData(1)
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s eobj = ##class(web.Entity.CT.OECOrderCategoryGroup).%New()
	s eobj.OCGRPRowId = id
	s eobj.OCGRPCode=$p($g(^OEC("OCGRP",eobj.OCGRPRowId)),"^",1)
	s eobj.OCGRPDesc=$p($g(^OEC("OCGRP",eobj.OCGRPRowId)),"^",2)
	s eobj.OCGRPDateFrom=$p($g(^OEC("OCGRP",eobj.OCGRPRowId)),"^",3)
	s eobj.OCGRPDateTo=$p($g(^OEC("OCGRP",eobj.OCGRPRowId)),"^",4)
	s eobj.OCGRPDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.OCGRPDateFrom)
	s eobj.OCGRPDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.OCGRPDateTo)
	
	s str = eobj.JsonS()	
	d eobj.%Close()
	s str = "{list:["_str_"]}"
	q str
}

/// Creator：陈莹
/// CreatDate: 2012-12-3  modified @201702015
/// Description：数据重复验证方法,js调用
/// Table：User.OECOrderCategoryGroup
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	n (id,code,desc)
	s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
	s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
	s flag="",flagc="",flagd=""
	s:code'="" flagc = $d(^OEC("OCGRP",0,"Code",code))
	s:desc'="" flagd = $d(^OEC("OCGRP",0,"Desc",desc))
	if (id="") //如果为空，增加时的重复判断
	{
		if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc="",idd=""
		s:code'="" idc=$o(^OEC("OCGRP",0,"Code",code,0))
		s:desc'="" idd=$o(^OEC("OCGRP",0,"Desc",desc,0))
		if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	q flag
}

/// Creator：陈莹
/// CreatDate: 2012-8-31
/// Description：保存修改医嘱类组的内容
/// Table：User.OECOrderCategoryGroup
/// Input：web.Entity.CT.OECOrderCategoryGroup 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.CT.OECOrderCategoryGroup).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.CT.OECOrderCategoryGroup) As %String
{
	n (eobj,%session)
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.OCGRPDateFrom'="" eobj.OCGRPDateFrom = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.OCGRPDateFrom)
		s:eobj.OCGRPDateTo'="" eobj.OCGRPDateTo = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.OCGRPDateTo)
		s:eobj.OCGRPDateFrom="" eobj.OCGRPDateFrom = +$h
		s flag=..FormValidate(eobj.OCGRPRowId,eobj.OCGRPCode,eobj.OCGRPDesc)  //调用重复验证
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		else
		{
			if (eobj.OCGRPRowId="")  //如果RowId为空则增加
			{
				s obj = ##class(User.OECOrderCategoryGroup).%New()
			}
			else                    //如果RowId不为空则修改
			{
				s obj=##class(User.OECOrderCategoryGroup).%OpenId(eobj.OCGRPRowId)
				s bobj = ##class(web.Entity.CT.OECOrderCategoryGroup).%New()
				s bobj.OCGRPRowId = eobj.OCGRPRowId    
				s bobj.OCGRPCode = obj.OCGRPCode          
				s bobj.OCGRPDesc = obj.OCGRPDesc         
				s bobj.OCGRPDateFrom = obj.OCGRPDateFrom  
				s bobj.OCGRPDateTo = obj.OCGRPDateTo
			}
			
			Ts	        		        	
			s obj.OCGRPCode = eobj.OCGRPCode          //修改代码
			s obj.OCGRPDesc = eobj.OCGRPDesc          //修改描述
			s obj.OCGRPDateFrom = eobj.OCGRPDateFrom  //修改开始日期
			s obj.OCGRPDateTo = eobj.OCGRPDateTo      //修改结束日期
			s sc = obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				Tc
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}"         //返回RowId
				//保存日志
				d:eobj.OCGRPRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("OEC_OrderCategoryGroup","User.OECOrderCategoryGroup","医嘱类组",id,eobj.OCGRPDesc,"A",eobj)
				d:eobj.OCGRPRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("OEC_OrderCategoryGroup","User.OECOrderCategoryGroup","医嘱类组",eobj.OCGRPRowId,eobj.OCGRPDesc,"U",eobj,bobj)
			}
			else
			{
				Trollback
				s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医嘱类组","web.DHCBL.CT.OECOrderCategoryGroup","SaveEntity",eobj)
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

/// 删除时验证数据是否被引用
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""
	
	//1 是否被"医嘱大类"引用
 	i $d(^OEC("ORCAT",0,"Group",id)) s myInfo=myInfo_"<医嘱大类>"
 	
 	i myInfo="" s return="0^未被引用可删除!"
 	else  s return="1^在"_myInfo_"表里被引用,不能删除!"
 	q return
}

/// Creator：陈莹
/// CreatDate: 2012-8-31
/// Description：根据ID删除医嘱类组的内容
/// Table：User.OECOrderCategoryGroup
/// Input：Id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
	s result = ""
	//验证是否被引用
	s re=..GetRefFlag(id)
	if ($p(re,"^",1)) {
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}
	else
	{
		s eobj = ##class(web.Entity.CT.OECOrderCategoryGroup).%New()
		s eobj.OCGRPRowId = id
		s eobj.OCGRPCode=$p($g(^OEC("OCGRP",eobj.OCGRPRowId)),"^",1)
		s eobj.OCGRPDesc=$p($g(^OEC("OCGRP",eobj.OCGRPRowId)),"^",2)
		s eobj.OCGRPDateFrom=$p($g(^OEC("OCGRP",eobj.OCGRPRowId)),"^",3)
		s eobj.OCGRPDateTo=$p($g(^OEC("OCGRP",eobj.OCGRPRowId)),"^",4)
		ts
		s sc=##class(User.OECOrderCategoryGroup).%DeleteId(id)
		if $$$ISOK(sc)
		{
			tc
			s result = "{success:'true',info:'删除成功！'}"	
			//保存日志
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("OEC_OrderCategoryGroup","User.OECOrderCategoryGroup","医嘱类组",id,eobj.OCGRPDesc,"D",eobj)
			d eobj.%Close()
		}
		else 
		{
			tro
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医嘱类组","web.DHCBL.CT.OECOrderCategoryGroup","DeleteData",eobj)
   			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
	}
	q result
}

/// Creator：陈莹
/// CreatDate: 2012-8-31
/// Description：查询医嘱类组的内容
/// Table：User.OECOrderCategoryGroup
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.OECOrderCategoryGroup","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "OCGRPRowId:%String,OCGRPCode:%String,OCGRPDesc:%String,OCGRPDateFrom:%String,OCGRPDateTo:%String ,BDPInternalCode:%String,BDPInternalDesc:%String,BDPHospNationalCode:%String,BDPHospNationalDesc:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s OCGRPRowId = rowid
		s OCGRPCode = $p($g(^OEC("OCGRP",OCGRPRowId)),"^",1)
		s OCGRPDesc = $p($g(^OEC("OCGRP",OCGRPRowId)),"^",2)
		s OCGRPDateFrom=$p($g(^OEC("OCGRP",OCGRPRowId)),"^",3)
		s OCGRPDateTo=$p($g(^OEC("OCGRP",OCGRPRowId)),"^",4)
		s:OCGRPDateFrom'="" OCGRPDateFrom=$zd(OCGRPDateFrom,1) //转换日期格式
		s:OCGRPDateTo'="" OCGRPDateTo=$zd(OCGRPDateTo,1) //转换日期格式
		s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc=""  
		s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("OEC_OrderCategoryGroup",OCGRPRowId)
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
		s AuStr=##class(web.DHCBL.Authorize.OECOrderCategoryGroup).DHCGetDataByDefaultSession()
		s AuFlag=0
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
	

		s OCGRPRowId=0
		f {
			s OCGRPRowId=$o(^OEC("OCGRP",OCGRPRowId))
			q:OCGRPRowId=""
			//筛选授权后的数据
			s strRowId="{ID:"_OCGRPRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) {
				s OCGRPCode = $p($g(^OEC("OCGRP",OCGRPRowId)),"^",1)
				s OCGRPDesc = $p($g(^OEC("OCGRP",OCGRPRowId)),"^",2)
				s OCGRPDateFrom=$p($g(^OEC("OCGRP",OCGRPRowId)),"^",3)
				s OCGRPDateTo=$p($g(^OEC("OCGRP",OCGRPRowId)),"^",4)
				s:OCGRPDateFrom'="" OCGRPDateFrom=$zd(OCGRPDateFrom,1) //转换日期格式
				s:OCGRPDateTo'="" OCGRPDateTo=$zd(OCGRPDateTo,1) //转换日期格式
				
				s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc=""  
				s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("OEC_OrderCategoryGroup",OCGRPRowId)
				s BDPInternalCode =$p($g(resultStr),"^",1)       
				s BDPInternalDesc = $p($g(resultStr),"^",2)  
				s BDPHospNationalCode=$p($g(resultStr),"^",3)         
				s BDPHospNationalDesc = $p($g(resultStr),"^",4)  
				if (desc'="")
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("OEC_OrderCategoryGroup",OCGRPRowId,OCGRPDesc,desc)
				}
				else
				{
					s AliasFlag= 1   
				}
				i ($zcvt(OCGRPCode,"u")[code)&&(AliasFlag=1)
				{
					d OutputRow
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(OCGRPRowId,OCGRPCode,OCGRPDesc,OCGRPDateFrom,OCGRPDateTo,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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
/// Description：医嘱类组,为combobox查询取数据
/// Table：User.OECOrderCategoryGroup
/// Input：rowid,code,desc
/// Return：OCGRPRowId,OCGRPCode,OCGRPDesc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.OECOrderCategoryGroup","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "OCGRPRowId:%String,OCGRPCode:%String,OCGRPDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s OCGRPRowId = rowid
		s OCGRPCode = $p($g(^OEC("OCGRP",OCGRPRowId)),"^",1)
		s OCGRPDesc = $p($g(^OEC("OCGRP",OCGRPRowId)),"^",2)
		d OutputRowCmb
	}
	else
	{
		s:code'="" code=$zcvt(code,"U") //转换成大写
		s:desc'="" desc=$zcvt(desc,"U") //转换成大写
		//获取授权Json
		s AuStr=##class(web.DHCBL.Authorize.OECOrderCategoryGroup).DHCGetDataByDefaultSession()
		s AuFlag=0
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示

		s OCGRPRowId=0
		f {
			s OCGRPRowId=$o(^OEC("OCGRP",OCGRPRowId))
			q:OCGRPRowId=""
			//筛选授权后的数据
			s strRowId="{ID:"_OCGRPRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) {
				s OCGRPCode = $p($g(^OEC("OCGRP",OCGRPRowId)),"^",1)
				s OCGRPDesc = $p($g(^OEC("OCGRP",OCGRPRowId)),"^",2)
				s OCGRPDateFrom=$p($g(^OEC("OCGRP",OCGRPRowId)),"^",3)
				continue:(OCGRPDateFrom'="")&&(OCGRPDateFrom>+$h)
				s OCGRPDateTo=$p($g(^OEC("OCGRP",OCGRPRowId)),"^",4)
				continue:(OCGRPDateTo'="")&&(OCGRPDateTo<+$h)
				if (desc'="")
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("OEC_OrderCategoryGroup",OCGRPRowId,OCGRPDesc,desc)
				}
				else
				{
					s AliasFlag= 1   
				}
				i ($zcvt(OCGRPCode,"u")[code)&&(AliasFlag=1)
				{
					d OutputRowCmb
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(OCGRPRowId,OCGRPCode,OCGRPDesc)
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
