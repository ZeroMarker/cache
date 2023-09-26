Import SQLUser

/// 名称:  医嘱与结果-医嘱大类维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-陈莹1
/// 编写日期: 2012-8-31
Class web.DHCBL.CT.OECOrderCategory Extends %RegisteredObject [ Not ProcedureBlock ]
{

Parameter SQLTableName = "OEC_OrderCategory";

/// Creator：陈莹
/// CreatDate: 2012-12-3  modified @201702015
/// Description：数据重复验证方法,js调用
/// Table：User.OECOrderCategory
/// Input：id, code, desc,hospid(医院id)
/// Return："1"(数据重复),"0"(数据不重复)
/// w ##class(web.DHCBL.CT.OECOrderCategory).FormValidate("","西药","","3") 
ClassMethod FormValidate(id As %String, code As %String, desc As %String, hospid As %String = "") As %String
{
	n (id,code,desc,hospid)
	s flag=0
	if $$ALPHAUP^SSUTIL4(code)'=""
	{
		s idc=0
		for
		{
			s idc=$o(^OEC("ORCAT",0,"Code",$$ALPHAUP^SSUTIL4(code),idc)) q:idc=""
			if (idc'=id)
			{
				//2022-12-30限制代码跨院区也不能重复
				//s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,idc,hospid)
				//continue:showflag="N"
				s flag=1
			}
		}
	}
	
	if $$ALPHAUP^SSUTIL4(desc)'=""
	{
		s idd=0
		for
		{
	
			s idd=$o(^OEC("ORCAT",0,"Desc",$$ALPHAUP^SSUTIL4(desc),idd)) q:idd=""
			if (idd'=id)
			{
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,idd,hospid)
				continue:showflag="N"
				s flag=1
			}
		}
	}
	q flag
}

/// Creator：陈莹
/// CreatDate: 2012-8-31
/// Description：保存修改医嘱大类的内容
/// Table：User.OECOrderCategory
/// Input：web.Entity.CT.OECOrderCategory 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.CT.OECOrderCategory).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.CT.OECOrderCategory) As %String
{
	n (%session,eobj)
	s result = ""
	if $IsObject(eobj)
	{
		s:eobj.ORCATRepeatInOrder="" eobj.ORCATRepeatInOrder="N"
		
		s flag=..FormValidate(eobj.ORCATRowId,eobj.ORCATCode,eobj.ORCATDesc,eobj.LinkHospId)  //调用重复验证
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		else
		{
			if (eobj.ORCATRowId="")  //如果RowId未赋值则增加
			{
				s obj=##class(User.OECOrderCategory).%New()
			}
			else                     //如果RowId已赋值则修改
			{
				s obj=##class(User.OECOrderCategory).%OpenId(eobj.ORCATRowId)
				s bobj=##class(web.Entity.CT.OECOrderCategory).%New()
				s bobj.ORCATRowId = eobj.ORCATRowId
				s bobj.ORCATCode = obj.ORCATCode          
				s bobj.ORCATDesc = obj.ORCATDesc          	
				if $IsObject(obj.ORCATOCGroupDR){
					s bobj.ORCATOCGroupDR = obj.ORCATOCGroupDR.%Id() 
				}				
				s bobj.ORCATRepeatInOrder = obj.ORCATRepeatInOrder
			}
			Ts	        		        	
			s obj.ORCATCode = eobj.ORCATCode          //修改代码
			s obj.ORCATDesc = eobj.ORCATDesc          //修改描述			
			d obj.ORCATOCGroupDRSetObjectId(eobj.ORCATOCGroupDR)				
			s obj.ORCATRepeatInOrder = eobj.ORCATRepeatInOrder
			s sc = obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				Tc
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}"         //返回RowId
				//保存日志
				d:eobj.ORCATRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("OEC_OrderCategory","User.OECOrderCategory","医嘱大类",id,eobj.ORCATDesc,"A",eobj)
				d:eobj.ORCATRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("OEC_OrderCategory","User.OECOrderCategory","医嘱大类",eobj.ORCATRowId,eobj.ORCATDesc,"U",eobj,bobj)
			}
			else
			{
				Trollback
				s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医嘱大类","web.DHCBL.CT.OECOrderCategory","SaveEntity",eobj)
    			s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
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
	
 	//1 是否被"安全组-医嘱授权"引用
	s found1=0
 	s sub1=0 f  s sub1=$o(^SSU("SSGRP",sub1)) q:sub1=""  q:found1  d
 	.s sub2=0 f  s sub2=$o(^SSU("SSGRP",sub1,"SSORD",sub2)) q:sub2=""  q:found1  d
 	..i ($p($g(^SSU("SSGRP",sub1,"SSORD",sub2)),"^",1)=id) s found1=1
 	i (found1) s myInfo=myInfo_"<安全组-医嘱授权>"
 	
 	//2 是否被"医嘱套"引用
 	i $d(^ARCOS(0,"OrdCat",id)) s myInfo=myInfo_"<医嘱套>"
 	
 	//3 是否被"医嘱子分类"引用
 	i $d(^ARC("IC",0,"OrdCat",id)) s myInfo=myInfo_"<医嘱子分类>"
 	
 	i myInfo="" s return="0^未被引用可删除!"
 	else  s return="1^在"_myInfo_"表里被引用,不能删除!"
 	q return
}

/// Creator：陈莹
/// CreatDate: 2012-8-31
/// Description：根据ID删除医嘱大类的内容
/// Table：User.OECOrderCategory
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
		s eobj = ##class(web.Entity.CT.OECOrderCategory).%New()
		s eobj.ORCATRowId = id
		s eobj.ORCATCode = $p($g(^OEC("ORCAT",id)),"^",1)
		s eobj.ORCATDesc = $p($g(^OEC("ORCAT",id)),"^",2)	
		s eobj.ORCATRepeatInOrder = $p($g(^OEC("ORCAT",id)),"^",3)
		s eobj.ORCATOCGroupDR = $p($g(^OEC("ORCAT",id)),"^",15)
		ts
		s sc = ##class(User.OECOrderCategory).%DeleteId(id)
		if $$$ISOK(sc)
		{
			tc
			s result = "{success:'true',info:'删除成功！'}"	
			//保存日志
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("OEC_OrderCategory","User.OECOrderCategory","医嘱大类",id,eobj.ORCATDesc,"D",eobj)
			d eobj.%Close()
		}
		else 
		{
			tro
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医嘱大类","web.DHCBL.CT.OECOrderCategory","DeleteData",eobj)
   			s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
	}
	q result
}

/// Creator：陈莹
/// CreatDate: 2012-12-3
/// Description：修改时打开的数据
/// Table：User.OECOrderCategory
/// Input：id
/// RetFlag=""时，用于EXT, =JSON时，用于HISUI，不输出 "{list:["_str_"]}",Y/N不需要转换true
ClassMethod OpenData(id As %String, RetFlag As %String = "") As %String
{
	n (id,RetFlag)
	s str=""	
	s eobj = ##class(web.Entity.CT.OECOrderCategory).%New()
	s eobj.ORCATRowId = id
	s eobj.ORCATCode = $p($g(^OEC("ORCAT",id)),"^",1)
	s eobj.ORCATDesc = $p($g(^OEC("ORCAT",id)),"^",2)	
	s eobj.ORCATRepeatInOrder = $p($g(^OEC("ORCAT",id)),"^",3)
	s eobj.ORCATOCGroupDR = $p($g(^OEC("ORCAT",id)),"^",15)
	
	if RetFlag=""
	{
		s:eobj.ORCATRepeatInOrder="Y" eobj.ORCATRepeatInOrder="true"
	}
	s str = eobj.JsonS()	
	d eobj.%Close()
	if RetFlag=""
	{
		s str = "{list:["_str_"]}"
	}
	q str
}

/// Creator：陈莹
/// CreatDate: 2012-8-31
/// Description：查询医嘱大类的内容
/// Table：User.OECOrderCategory
/// Input：rowid,code,desc,hospid(医院id)
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.OECOrderCategory","GetList","","","","")
Query GetList(rowid As %String, code As %String, desc As %String, OCGRPRowId As %String, hospid As %String) As %Query(ROWSPEC = "ORCATRowId:%String,ORCATCode:%String,ORCATDesc:%String,ORCATRepeatInOrder:%String,ORCATOCGroupDesc:%String,BDPInternalCode:%String,BDPInternalDesc:%String,BDPHospNationalCode:%String,BDPHospNationalDesc:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, OCGRPRowId As %String, hospid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s ORCATRowId = rowid
		s ORCATCode = $p($g(^OEC("ORCAT",ORCATRowId)),"^",1)
		s ORCATDesc = $p($g(^OEC("ORCAT",ORCATRowId)),"^",2)	
		s ORCATRepeatInOrder = $p($g(^OEC("ORCAT",ORCATRowId)),"^",3)
		s ORCATOCGroupDR = $p($g(^OEC("ORCAT",ORCATRowId)),"^",15)
		s ORCATOCGroupDesc = ""
		s:ORCATOCGroupDR'="" ORCATOCGroupDesc = $p($g(^OEC("OCGRP",ORCATOCGroupDR)),"^",2) //获取医嘱类组描述
		s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc=""  
		s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("OEC_OrderCategory",ORCATRowId)
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
		s AuStr=##class(web.DHCBL.Authorize.OECOrderCategory).DHCGetDataByDefaultSession()
		s AuFlag=0
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
	
		s ORCATOCGroupDRAuStr=##class(web.DHCBL.Authorize.OECOrderCategoryGroup).DHCGetDataByDefaultSession()
		s ORCATOCGroupDRAuFlag=0
		if (ORCATOCGroupDRAuStr="")||(ORCATOCGroupDRAuStr["limited:0") s ORCATOCGroupDRAuFlag=1 //判断是否有授权,如果没有则全部显示

		s ORCATRowId=0
		f {
			s ORCATRowId=$o(^OEC("ORCAT",ORCATRowId))
			q:ORCATRowId=""
			s ORCATOCGroupDR = $p($g(^OEC("ORCAT",ORCATRowId)),"^",15)
			//筛选授权后的数据
			s ORCATOCGroupDRstrRowId="{ID:"_ORCATOCGroupDR_"}"
			s strRowId="{ID:"_ORCATRowId_"}"
			if ((AuStr[strRowId)||(AuFlag=1))&&((ORCATOCGroupDRAuStr[ORCATOCGroupDRstrRowId)||(ORCATOCGroupDRAuFlag=1))
			{
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,ORCATRowId,hospid)
				continue:showflag="N"
				
				s ORCATCode = $p($g(^OEC("ORCAT",ORCATRowId)),"^",1)
				s ORCATDesc = $p($g(^OEC("ORCAT",ORCATRowId)),"^",2)	
				s ORCATRepeatInOrder = $p($g(^OEC("ORCAT",ORCATRowId)),"^",3)
				
				s ORCATOCGroupDesc = ""
				s:ORCATOCGroupDR'="" ORCATOCGroupDesc = $p($g(^OEC("OCGRP",ORCATOCGroupDR)),"^",2) //获取医嘱类组描述
				
				s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc=""  
				s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("OEC_OrderCategory",ORCATRowId)
				s BDPInternalCode =$p($g(resultStr),"^",1)       
				s BDPInternalDesc = $p($g(resultStr),"^",2)  
				s BDPHospNationalCode=$p($g(resultStr),"^",3)         
				s BDPHospNationalDesc = $p($g(resultStr),"^",4)  
				
				if (desc'="")
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("OEC_OrderCategory",ORCATRowId,ORCATDesc,desc)
				}
				else
				{
					s AliasFlag= 1   
				}
				i ($zcvt(ORCATCode,"u")[code)&&(AliasFlag=1)&((ORCATOCGroupDR=OCGRPRowId)||(OCGRPRowId=""))
				{
					d OutputRow
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ORCATRowId,ORCATCode,ORCATDesc,ORCATRepeatInOrder,ORCATOCGroupDesc,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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
/// Description：医嘱大类,为combobox查询取数据
/// Table：User.OECOrderCategory
/// Input：rowid,code,desc,hospid(医院id)
/// Return：ORCATRowId,ORCATCode,ORCATDesc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.OECOrderCategory","GetDataForCmb1","","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "ORCATRowId:%String,ORCATCode:%String,ORCATDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, hospid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s ORCATRowId = rowid
		s ORCATCode = $p($g(^OEC("ORCAT",ORCATRowId)),"^",1)
		s ORCATDesc = $p($g(^OEC("ORCAT",ORCATRowId)),"^",2)
		d OutputRowCmb
	}
	else
	{
		//获取授权Json
		s AuStr=##class(web.DHCBL.Authorize.OECOrderCategory).DHCGetDataByDefaultSession()
		s AuFlag=0
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
		s ORCATOCGroupDRAuStr=##class(web.DHCBL.Authorize.OECOrderCategoryGroup).DHCGetDataByDefaultSession()
		s ORCATOCGroupDRAuFlag=0
		if (ORCATOCGroupDRAuStr="")||(ORCATOCGroupDRAuStr["limited:0") s ORCATOCGroupDRAuFlag=1 //判断是否有授权,如果没有则全部显示
	
		s:code'="" code=$zcvt(code,"U") //转换成大写
		s:desc'="" desc=$zcvt(desc,"U") //转换成大写
		
		s ORCATRowId=0
		f {
			s ORCATRowId=$o(^OEC("ORCAT",ORCATRowId))
			q:ORCATRowId=""
			s ORCATOCGroupDR = $p($g(^OEC("ORCAT",ORCATRowId)),"^",15)
			//筛选授权后的数据
			s ORCATOCGroupDRstrRowId="{ID:"_ORCATOCGroupDR_"}"
			s strRowId="{ID:"_ORCATRowId_"}"
			if ((AuStr[strRowId)||(AuFlag=1))&&((ORCATOCGroupDRAuStr[ORCATOCGroupDRstrRowId)||(ORCATOCGroupDRAuFlag=1))
			{
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,ORCATRowId,hospid)
				continue:showflag="N"
				
				s ORCATCode = $p($g(^OEC("ORCAT",ORCATRowId)),"^",1)
				s ORCATDesc = $p($g(^OEC("ORCAT",ORCATRowId)),"^",2)
				if (desc'="")
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("OEC_OrderCategory",ORCATRowId,ORCATDesc,desc)
				}
				else
				{
					s AliasFlag= 1   
				}
				i ($zcvt(ORCATCode,"u")[code)&&(AliasFlag=1)
				{
					d OutputRowCmb
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(ORCATRowId,ORCATCode,ORCATDesc)
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
