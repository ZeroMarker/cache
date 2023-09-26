Import SQLUser

/// 名称: 医嘱子分类维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-陈莹
/// 编写日期: 2012-9-6
Class web.DHCBL.CT.ARCItemCat Extends %RegisteredObject [ Not ProcedureBlock ]
{

Parameter SQLTableName = "ARC_ItemCat";

/// Creator：陈莹
/// CreatDate: 2012-12-3
/// Description：数据重复验证方法,js调用
/// Table：User.ARCItemCat
/// Input：id, code, desc,hospid(医院id)
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String, hospid As %String = "") As %String
{
	
	n (code,id,desc,hospid)
	s flag=0
	if $$ALPHAUP^SSUTIL4(code)'=""
	{
		s idc=0
		for
		{
			s idc=$o(^ARC("IC",0,"Code",$$ALPHAUP^SSUTIL4(code),idc)) q:idc=""
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
	
			s idd=$o(^ARC("IC",0,"Desc",$$ALPHAUP^SSUTIL4(desc),idd)) q:idd=""
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
/// CreatDate: 2012-9-6
/// Description：保存修改医嘱子分类的内容
/// Table：User.ARCItemCat
/// Input：web.Entity.CT.ARCItemCat 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.CT.ARCItemCat).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.CT.ARCItemCat) As %String
{
	n (%session,eobj)
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.ARCICCalcQtyFlag="" eobj.ARCICCalcQtyFlag="N"
		s:eobj.ARCICRestrictedOrder="" eobj.ARCICRestrictedOrder="N"
		
		s flag=..FormValidate(eobj.ARCICRowId,eobj.ARCICCode,eobj.ARCICDesc,eobj.LinkHospId)  //调用重复验证
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		else
		{
			if (eobj.ARCICRowId="")  //如果RowId未赋值则增加
			{
				s obj=##class(User.ARCItemCat).%New()
			}
			else                     //如果RowId已赋值则修改
			{
				s obj=##class(User.ARCItemCat).%OpenId(eobj.ARCICRowId)
				s bobj=##class(web.Entity.CT.ARCItemCat).%New()
				s bobj.ARCICRowId = eobj.ARCICRowId
				s bobj.ARCICCode = obj.ARCICCode
				s bobj.ARCICDesc = obj.ARCICDesc
				s bobj.ARCICOrderType = obj.ARCICOrderType
				if $IsObject(obj.ARCICOrdCatDR){
					s bobj.ARCICOrdCatDR = obj.ARCICOrdCatDR.%Id() 
				}
				if $IsObject(obj.ARCICExecCategDR){
					s bobj.ARCICExecCategDR = obj.ARCICExecCategDR.%Id() 
				}
				
				s bobj.ARCICCalcQtyFlag = obj.ARCICCalcQtyFlag
				s bobj.ARCICRestrictedOrder = obj.ARCICRestrictedOrder
				
			}
			
			
				        		        	
			s obj.ARCICCode = eobj.ARCICCode          //修改代码
			s obj.ARCICDesc = eobj.ARCICDesc          //修改描述
			s obj.ARCICOrderType = eobj.ARCICOrderType
			d obj.ARCICOrdCatDRSetObjectId(eobj.ARCICOrdCatDR)
			d obj.ARCICExecCategDRSetObjectId(eobj.ARCICExecCategDR)
			s obj.ARCICCalcQtyFlag = eobj.ARCICCalcQtyFlag
			s obj.ARCICRestrictedOrder = eobj.ARCICRestrictedOrder
			Ts
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				Tc
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}"         //返回RowId
				d:eobj.ARCICRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_ItemCat","User.ARCItemCat","医嘱子分类",id,eobj.ARCICDesc,"A",eobj)
				d:eobj.ARCICRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_ItemCat","User.ARCItemCat","医嘱子分类",eobj.ARCICRowId,eobj.ARCICDesc,"U",eobj,bobj)
			}
			else
			{
				Trollback
				s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医嘱子分类","web.DHCBL.CT.ARCItemCat","SaveEntity",eobj)
	   			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	   			s result ="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
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
	n (id)
	s return="",myInfo=""
	
	//1 是否被"医嘱项"引用
	i ($d(^ARCIM(0,"ARCIC_DR",id)))  s myInfo=myInfo_"<医嘱项>"
	
	//2 是否被"医嘱套"引用
	i ($d(^ARCOS(0,"ItemCat",id)))  s myInfo=myInfo_"<医嘱套>"
	
	//3 是否被"医嘱项-别名"引用
	s flag=0
 	s sub1=0 
 	for
 	{
	 	s sub1=$o(^ARC("ALIAS",sub1)) q:sub1=""  q:flag=1
 		i ($p($g(^ARC("ALIAS",sub1)),"^",4)=id) s flag=1	
 	}
 	i (flag=1) s myInfo=myInfo_"<医嘱项-别名>"
 	
 	//4 是否被"安全组-医嘱授权"引用
	s flag=0
 	s sub1=0
 	for
 	{
	 	s sub1=$o(^SSU("SSGRP",sub1)) q:sub1=""  q:flag
 		s sub2=0
 		for
 		{
	 		s sub2=$o(^SSU("SSGRP",sub1,"SSORD",sub2)) q:sub2=""  q:flag=1
 			i ($p($g(^SSU("SSGRP",sub1,"SSORD",sub2)),"^",5)=id) s flag=1
 		}
 	}
 	i (flag=1) s myInfo=myInfo_"<安全组-医嘱授权>"
 	
 	i myInfo="" s return="0^未被引用可删除!"
 	else  s return="1^在"_myInfo_"表里被引用,不能删除!"
	q return
}

/// Creator：陈莹
/// CreatDate: 2012-9-6
/// Description：根据ID删除医嘱子分类的内容
/// Table：User.ARCItemCat
/// Input：Id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
	n (id,%session)
	s result=""
	//验证是否被引用
 	s re=..GetRefFlag(id)
	if ($p(re,"^",1)) {
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}
	else
	{
		s eobj = ##class(web.Entity.CT.ARCItemCat).%New()
		s eobj.ARCICRowId = id
		s eobj.ARCICCode = $p($g(^ARC("IC",id)),"^",1)
		s eobj.ARCICDesc = $p($g(^ARC("IC",id)),"^",2)
		s eobj.ARCICOrderType = $p($g(^ARC("IC",id)),"^",7)
		s eobj.ARCICOrdCatDR = $p($g(^ARC("IC",id)),"^",8)
		s eobj.ARCICExecCategDR = $p($g(^ARC("IC",id)),"^",9)	
		s eobj.ARCICCalcQtyFlag = $p($g(^ARC("IC",id)),"^",11)
		s eobj.ARCICRestrictedOrder = $p($g(^ARC("IC",id)),"^",25)
		
		
		ts
		s sc=##class(User.ARCItemCat).%DeleteId(id)
		if $$$ISOK(sc)
		{
			tc
			s result = "{success:'true',info:'删除成功！'}"	
			//保存日志
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_ItemCat","User.ARCItemCat","医嘱子分类",id,eobj.ARCICDesc,"D",eobj)
			d eobj.%Close()
		}
		else 
		{
			tro
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医嘱子分类","web.DHCBL.CT.ARCItemCat","DeleteData",eobj)
	   		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)  //$zconvert(sc,"O","JS")
			s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
	}
	q result
}

/// Creator：陈莹
/// CreatDate: 2012-12-3
/// Description：修改时打开的数据
/// Table：User.ARCItemCat
/// Input：id，RetFlag=""时，用于EXT, =JSON时，用于HISUI，不输出 "{list:["_str_"]}",Y/N不需要转换true
ClassMethod OpenData(id As %String, RetFlag As %String = "") As %String
{
	n (id,RetFlag)
	s str=""	
	s eobj = ##class(web.Entity.CT.ARCItemCat).%New()
	s eobj.ARCICRowId = id
	s eobj.ARCICCode = $p($g(^ARC("IC",id)),"^",1)
	s eobj.ARCICDesc = $p($g(^ARC("IC",id)),"^",2)
	s eobj.ARCICOrderType = $p($g(^ARC("IC",id)),"^",7)
	s eobj.ARCICOrdCatDR = $p($g(^ARC("IC",id)),"^",8)
	s eobj.ARCICExecCategDR = $p($g(^ARC("IC",id)),"^",9)	
	s eobj.ARCICCalcQtyFlag = $p($g(^ARC("IC",id)),"^",11)
	s eobj.ARCICRestrictedOrder = $p($g(^ARC("IC",id)),"^",25)
	if RetFlag=""
	{
		s:eobj.ARCICCalcQtyFlag="Y" eobj.ARCICCalcQtyFlag="true"
		s:eobj.ARCICRestrictedOrder="Y" eobj.ARCICRestrictedOrder="true"
	}
	s str = eobj.JsonS()
	d eobj.%Close()
	if RetFlag=""
	{
		s str = "{list:["_str_"]}"
	}
	q str
}

/*
/// Creator：陈莹
/// CreatDate: 2018-03-05
/// Description：修改时打开的数据
/// Table：User.ARCItemCat
/// Input：id
ClassMethod NewOpenData(id As %String) As %String
{
	n (id)
	s str=""	
	s eobj = ##class(web.Entity.CT.ARCItemCat).%New()
	s eobj.ARCICRowId = id
	s eobj.ARCICCode = $p($g(^ARC("IC",id)),"^",1)
	s eobj.ARCICDesc = $p($g(^ARC("IC",id)),"^",2)
	s eobj.ARCICOrderType = $p($g(^ARC("IC",id)),"^",7)
	s eobj.ARCICOrdCatDR = $p($g(^ARC("IC",id)),"^",8)
	s eobj.ARCICExecCategDR = $p($g(^ARC("IC",id)),"^",9)	
	s eobj.ARCICCalcQtyFlag = $p($g(^ARC("IC",id)),"^",11)
	s eobj.ARCICRestrictedOrder = $p($g(^ARC("IC",id)),"^",25)
	//s:eobj.ARCICCalcQtyFlag="Y" eobj.ARCICCalcQtyFlag="true"
	//s:eobj.ARCICRestrictedOrder="Y" eobj.ARCICRestrictedOrder="true"
	s str = eobj.JsonS()
	d eobj.%Close()
	//s str = "{list:["_str_"]}"
	q str
}*/
/// Creator：陈莹
/// CreatDate: 2012-9-6
/// Description：查询医嘱子分类的内容
/// Table：User.ARCItemCat
/// Input：rowid,code,desc,hospid(医院id)
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ARCItemCat","GetList","","","","","","")
Query GetList(rowid As %String, code As %String, desc As %String, OrderType As %String, OrderCat As %String, hospid As %String) As %Query(ROWSPEC = "ARCICRowId:%String,ARCICCode:%String,ARCICDesc:%String,ARCICOrderType:%String,ARCICOrdCatDR:%String,ARCICExecCategDR:%String,ARCICCalcQtyFlag:%String,ARCICRestrictedOrder:%String,BDPInternalCode:%String,BDPInternalDesc:%String,BDPHospNationalCode:%String,BDPHospNationalDesc:%String,HospitalDR,HospitalDesc,HospitalGroupDR")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, OrderType As %String, OrderCat As %String, hospid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权Json
	s AuStr=##class(web.DHCBL.Authorize.ARCItemCat).DHCGetDataByDefaultSession()
	s AuFlag=0
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
	
	s ARCICOrdCatDRAuStr=##class(web.DHCBL.Authorize.OECOrderCategory).DHCGetDataByDefaultSession()
	s ARCICOrdCatDRAuFlag=0
	if (ARCICOrdCatDRAuStr="")||(ARCICOrdCatDRAuStr["limited:0") s ARCICOrdCatDRAuFlag=1 //判断是否有授权,如果没有则全部显示
	s ARCICExecCategDRAuStr=##class(web.DHCBL.Authorize.OECExecCateg).DHCGetDataByDefaultSession()
	s ARCICExecCategDRAuFlag=0
	if (ARCICExecCategDRAuStr="")||(ARCICExecCategDRAuStr["limited:0") s ARCICExecCategDRAuFlag=1 //判断是否有授权,如果没有则全部显示
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s ARCICRowId=rowid
		s ARCICCode=$p($g(^ARC("IC",ARCICRowId)),"^",1)
		s ARCICDesc=$p($g(^ARC("IC",ARCICRowId)),"^",2)
		s ARCICOrderType=$p($g(^ARC("IC",ARCICRowId)),"^",7)
		s ARCICOrdCatDR=$p($g(^ARC("IC",ARCICRowId)),"^",8)
		s:ARCICOrdCatDR'="" ARCICOrdCatDR=$p($g(^OEC("ORCAT",ARCICOrdCatDR)),"^",2) //获取医嘱分类描述
		s ARCICExecCategDR=$p($g(^ARC("IC",ARCICRowId)),"^",9)
		s:ARCICExecCategDR'="" ARCICExecCategDR=$p($g(^OEC("EXEC",ARCICExecCategDR)),"^",2) //获取医嘱执行类型描述
		s ARCICCalcQtyFlag=$p($g(^ARC("IC",ARCICRowId)),"^",11)
		s ARCICRestrictedOrder=$p($g(^ARC("IC",ARCICRowId)),"^",25)
		s HospitalDR=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospital("ARC_ItemCat",ARCICRowId,"ID")	//关联医院
		s HospitalDesc=""
		s HospitalGroupDR=""
		if (HospitalDR'="")
		{
			s HospitalDesc=$p($g(^CT("HOSP",HospitalDR)),"^",2) //获取医院描述
			s HospitalGroupDR=$p($g(^CT("HOSP",HospitalDR)),"^",41)	//所属医院组
			s:HospitalGroupDR="" HospitalGroupDR=HospitalDR	//如果默认医院为空，则显示它本身
		}
		
		s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
		s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("ARC_ItemCat",ARCICRowId)
		s BDPInternalCode =$p($g(resultStr),"^",1)       
		s BDPInternalDesc = $p($g(resultStr),"^",2)  
		s BDPHospNationalCode=$p($g(resultStr),"^",3)         
		s BDPHospNationalDesc = $p($g(resultStr),"^",4)  
		
		d OutputRow
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U") //转换成大写
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		s ARCICRowId=0
		f {
			s ARCICRowId=$o(^ARC("IC",ARCICRowId))
			q:ARCICRowId=""
			s ARCICOrdCatDR=$p($g(^ARC("IC",ARCICRowId)),"^",8)
			s ARCICExecCategDR=$p($g(^ARC("IC",ARCICRowId)),"^",9)
			//筛选授权后的数据
			s strRowId="{ID:"_ARCICRowId_"}"
			s ARCICOrdCatDRstrRowId="{ID:"_ARCICOrdCatDR_"}"
			s ARCICExecCategDRstrRowId="{ID:"_ARCICExecCategDR_"}"
			if ((AuStr[strRowId)||(AuFlag=1))&&((ARCICOrdCatDRAuStr[ARCICOrdCatDRstrRowId)||(ARCICOrdCatDRAuFlag=1))&&((ARCICExecCategDRAuStr[ARCICExecCategDRstrRowId)||(ARCICExecCategDRAuFlag=1))
			{
				///2019-06-25
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,ARCICRowId,hospid)
				continue:showflag="N"
				
				s HospitalDR=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospital("ARC_ItemCat",ARCICRowId,"ID")	//关联医院
				s HospitalDesc=""
				s HospitalGroupDR=""
				if (HospitalDR'="")
				{
					s HospitalDesc=$p($g(^CT("HOSP",HospitalDR)),"^",2) //获取医院描述
					s HospitalGroupDR=$p($g(^CT("HOSP",HospitalDR)),"^",41)	//所属医院组
					s:HospitalGroupDR="" HospitalGroupDR=HospitalDR	//如果默认医院为空，则显示它本身
				}
				s ARCICCode=$p($g(^ARC("IC",ARCICRowId)),"^",1)
				s ARCICDesc=$p($g(^ARC("IC",ARCICRowId)),"^",2)
				s ARCICOrderType=$p($g(^ARC("IC",ARCICRowId)),"^",7)
				continue:((ARCICOrdCatDR'=OrderCat)&&(OrderCat'=""))
				s:ARCICOrdCatDR'="" ARCICOrdCatDR=$p($g(^OEC("ORCAT",ARCICOrdCatDR)),"^",2) //获取医嘱分类描述
				s:ARCICExecCategDR'="" ARCICExecCategDR=$p($g(^OEC("EXEC",ARCICExecCategDR)),"^",2) //获取医嘱执行类型描述
				s ARCICCalcQtyFlag=$p($g(^ARC("IC",ARCICRowId)),"^",11)
				s ARCICRestrictedOrder=$p($g(^ARC("IC",ARCICRowId)),"^",25)
				s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
				s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("ARC_ItemCat",ARCICRowId)
				s BDPInternalCode =$p($g(resultStr),"^",1)       
				s BDPInternalDesc = $p($g(resultStr),"^",2)  
				s BDPHospNationalCode=$p($g(resultStr),"^",3)         
				s BDPHospNationalDesc = $p($g(resultStr),"^",4)  
				
				if (desc'="")
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("ARC_ItemCat",ARCICRowId,ARCICDesc,desc)
				}
				else
				{
					s AliasFlag= 1   
				}  
       
				i ($ZCONVERT(ARCICCode,"U")[code)&&(AliasFlag=1)&&((ARCICOrderType=OrderType)||(OrderType=""))
				{
					d OutputRow
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ARCICRowId,ARCICCode,ARCICDesc,ARCICOrderType,ARCICOrdCatDR,ARCICExecCategDR,ARCICCalcQtyFlag,ARCICRestrictedOrder,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc,HospitalDR,HospitalDesc,HospitalGroupDR)
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
/// Description：医嘱子分类,为combobox查询取数据
/// Table：User.ARCItemCat
/// Input：rowid,code,desc,hospid(医院id)
/// Return：ARCICRowId,ARCICCode,ARCICDesc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ARCItemCat","GetDataForCmb1","","","","","")
Query GetDataForCmb1(ordcat As %String, rowid As %String, code As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "ARCICRowId:%String,ARCICCode:%String,ARCICDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, ordcat As %String, rowid As %String, code As %String, desc As %String, hospid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s ARCICRowId=rowid
		s ARCICCode=$p($g(^ARC("IC",ARCICRowId)),"^",1)
		s ARCICDesc=$p($g(^ARC("IC",ARCICRowId)),"^",2)
		d OutputRowCmb
	}
	else
	{
		
		//获取授权Json
		s AuStr=##class(web.DHCBL.Authorize.ARCItemCat).DHCGetDataByDefaultSession()
		s AuFlag=0
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
		s ARCICOrdCatDRAuStr=##class(web.DHCBL.Authorize.OECOrderCategory).DHCGetDataByDefaultSession()
		s ARCICOrdCatDRAuFlag=0
		if (ARCICOrdCatDRAuStr="")||(ARCICOrdCatDRAuStr["limited:0") s ARCICOrdCatDRAuFlag=1 //判断是否有授权,如果没有则全部显示
		s ARCICExecCategDRAuStr=##class(web.DHCBL.Authorize.OECExecCateg).DHCGetDataByDefaultSession()
		s ARCICExecCategDRAuFlag=0
		if (ARCICExecCategDRAuStr="")||(ARCICExecCategDRAuStr["limited:0") s ARCICExecCategDRAuFlag=1 //判断是否有授权,如果没有则全部显示
	
		s:code'="" code=$ZCONVERT(code,"U") //转换成大写
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		s ARCICRowId=0
		f {
			s ARCICRowId=$o(^ARC("IC",ARCICRowId))
			q:ARCICRowId=""
			//筛选授权后的数据
			s ARCICOrdCatDR=$p($g(^ARC("IC",ARCICRowId)),"^",8)
			s ARCICExecCategDR=$p($g(^ARC("IC",ARCICRowId)),"^",9)
			//筛选授权后的数据
			s strRowId="{ID:"_ARCICRowId_"}"
			s ARCICOrdCatDRstrRowId="{ID:"_ARCICOrdCatDR_"}"
			s ARCICExecCategDRstrRowId="{ID:"_ARCICExecCategDR_"}"
			if ((AuStr[strRowId)||(AuFlag=1))&&((ARCICOrdCatDRAuStr[ARCICOrdCatDRstrRowId)||(ARCICOrdCatDRAuFlag=1))&&((ARCICExecCategDRAuStr[ARCICExecCategDRstrRowId)||(ARCICExecCategDRAuFlag=1))
			{
				///2019-06-25
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,ARCICRowId,hospid)
				continue:showflag="N"
				
				s ARCICCode=$p($g(^ARC("IC",ARCICRowId)),"^",1)
				s ARCICDesc=$p($g(^ARC("IC",ARCICRowId)),"^",2)
				s ARCICOrdCatDR=$p($g(^ARC("IC",ARCICRowId)),"^",8)
				
				if (desc'="")            
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("ARC_ItemCat",ARCICRowId,ARCICDesc,desc)
				}
				else
				{
					s AliasFlag= 1   
				} 
				i ($ZCONVERT(ARCICCode,"U")[code)&(AliasFlag=1)&((ARCICOrdCatDR=ordcat)||(ordcat=""))
				{
					d OutputRowCmb
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(ARCICRowId,ARCICCode,ARCICDesc)
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

/// Function:获取医嘱子分类的类型（可以在医嘱项添加、复制的时候判断医嘱子分类是R类型时给出提示
/// Creator:陈莹
/// CreateDate: 2022-09-13
/// Input:医嘱子分类id
/// Output:医嘱子分类的类型
/// w ##class(web.DHCBL.CT.ARCItemCat).GetTypeByARCICRowId("1")
ClassMethod GetTypeByARCICRowId(arcicrowid As %String) As %String
{
    n (arcicrowid)
    q:arcicrowid="" ""
    s ARCICOrderType = $p($g(^ARC("IC",arcicrowid)),"^",7)
    q ARCICOrderType
}

}
