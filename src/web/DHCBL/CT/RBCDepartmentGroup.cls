Import SQLUser

Class web.DHCBL.CT.RBCDepartmentGroup Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// update2020-02-11
Parameter SQLTableName = "RBC_DepartmentGroup";

/// Function:科室部门组类型维护 获取grid列表
/// Creator:基础数据平台组 蔡昊哲
/// Table:RBC_DepartmentGroup
/// Input:RowId,code ,desc
/// Output:DEP_RowId,DEP_Code,DEP_Desc,DEP_DateFrom,DEP_DateTo
/// Others:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.RBCDepartmentGroup", "GetList")
Query GetList(rowid As %String, code As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "DEPRowId,DEPCode,DEPDesc,DEPDateFrom,DEPDateTo,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, hospid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	
	//获取授权Json
	s AuStr=##class(web.DHCBL.Authorize.RBCDepartmentGroup).DHCGetDataByDefaultSession()
	;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
	;假设未授权情况下默认全部显示数据
	s AuFlag=0
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	
	s:code'="" code=$ZCONVERT(code,"U")
	s:desc'="" desc=$ZCONVERT(desc,"U")
	if (rowid'="") //根据rowid返回该条记录
	{
		s DEPRowId=rowid
		s DEPCode=$p($g(^RBC("DEP",DEPRowId)),"^",1)
		s DEPDesc=$p($g(^RBC("DEP",DEPRowId)),"^",2)
		s DEPDateFrom=$p($g(^RBC("DEP",DEPRowId)),"^",3)
		s DEPDateTo=$p($g(^RBC("DEP",DEPRowId)),"^",4)
		s:DEPDateFrom'="" DEPDateFrom=$zd(DEPDateFrom,1) //转换日期格式
		s:DEPDateTo'="" DEPDateTo=$zd(DEPDateTo,1) //转换日期格式
		s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
    	s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("RBC_DepartmentGroup",DEPRowId)
    	s BDPInternalCode =$p($g(resultStr),"^",1)       
    	s BDPInternalDesc = $p($g(resultStr),"^",2)  
    	s BDPHospNationalCode=$p($g(resultStr),"^",3)         
    	s BDPHospNationalDesc = $p($g(resultStr),"^",4)	
		d OutputRow
	}
	else
	{
		s DEPRowId=0
		for  
		{	
			s DEPRowId=$o(^RBC("DEP",DEPRowId)) q:DEPRowId=""
			s strRowId = "{ID:"_DEPRowId_"}"
			i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			{
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,DEPRowId,hospid)
	  			continue:showflag="N"
	  			
				s DEPCode=$p($g(^RBC("DEP",DEPRowId)),"^",1)
				s DEPDesc=$p($g(^RBC("DEP",DEPRowId)),"^",2)
				s DEPDateFrom=$p($g(^RBC("DEP",DEPRowId)),"^",3)
				s DEPDateTo=$p($g(^RBC("DEP",DEPRowId)),"^",4)
				s:DEPDateFrom'="" DEPDateFrom=$zd(DEPDateFrom,1) //转换日期格式
				s:DEPDateTo'="" DEPDateTo=$zd(DEPDateTo,1) //转换日期格式
				s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
            	s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("RBC_DepartmentGroup",DEPRowId)
            	s BDPInternalCode =$p($g(resultStr),"^",1)       
            	s BDPInternalDesc = $p($g(resultStr),"^",2)  
            	s BDPHospNationalCode=$p($g(resultStr),"^",3)         
            	s BDPHospNationalDesc = $p($g(resultStr),"^",4)
            	/*
				s ALIASText1=""
				s AliasRowId=0
				for{
					s AliasRowId=$o(^User.BDPAliasI("DataRef","RBC_DepartmentGroup",DEPRowId,AliasRowId))
					q:AliasRowId=""
  					S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
					s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
				}
				s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(DEPDesc))
				*/
				if (desc'="")
		       {
			        ;需要对描述或者别名进行检索      
			        s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("RBC_DepartmentGroup",DEPRowId,DEPDesc,desc)
		       }
			   	else
		       {
		         	s AliasFlag= 1   
		       } 
				i ($$ALPHAUP^SSUTIL4(DEPCode)[code)&(AliasFlag=1)
				/*((PINYIN[desc)||($$ALPHAUP^SSUTIL4(DEPDesc)[desc)||(ALIASText1[desc))*/
				{
					d OutputRow
				}	
			}
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(DEPRowId,DEPCode,DEPDesc,DEPDateFrom,DEPDateTo,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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

/// Function:进行数据检索，为combo查询提供接口
/// CreateDate:2012-08-30
/// Creator:基础数据平台公共产品组  蔡昊哲
/// Table:RBC_DepartmentGroup
/// Input: desc, code 
/// Output:   
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.RBCDepartmentGroup", "GetDataForCmb1","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "DEPRowId,DEPCode,DEPDesc")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, hospid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权Json
	s AuStr=##class(web.DHCBL.Authorize.RBCDepartmentGroup).DHCGetDataByDefaultSession()
	;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
	;假设未授权情况下默认全部显示数据
	s AuFlag=0
	if AuStr="" s AuFlag=1 //判断是否有授权,如果没有则全部显示
	
	s:code'="" code=$ZCONVERT(code,"U")
	s:desc'="" desc=$ZCONVERT(desc,"U")
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s DEPRowId=rowid
		s DEPDesc=$p($g(^RBC("DEP",DEPRowId)),"^",2)
		d OutputRow1
	}
	else
	{
		s DEPRowId=0
		for  
		{	
			s DEPRowId=$o(^RBC("DEP",DEPRowId)) q:DEPRowId=""
			s strRowId = "{ID:"_DEPRowId_"}"
			i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			{
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,DEPRowId,hospid)
	 			continue:showflag="N"
	 			
				s DEPCode=$p($g(^RBC("DEP",DEPRowId)),"^",1)
				s DEPDesc=$p($g(^RBC("DEP",DEPRowId)),"^",2)
				s DEPDateFrom=$p($g(^RBC("DEP",DEPRowId)),"^",3)
				s DEPDateTo=$p($g(^RBC("DEP",DEPRowId)),"^",4)
				continue:(DEPDateFrom'="")&&(DEPDateFrom>+$h)
				continue:(DEPDateTo'="")&&(DEPDateTo<+$h)
				/*
				s ALIASText1=""
				s AliasRowId=0
				for{
					s AliasRowId=$o(^User.BDPAliasI("DataRef","RBC_DepartmentGroup",DEPRowId,AliasRowId))
					q:AliasRowId=""
  					S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
					s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
				}
				s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(DEPDesc))
				*/
				if (desc'="")
		       {
			        ;需要对描述或者别名进行检索      
			        s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("RBC_DepartmentGroup",DEPRowId,DEPDesc,desc)
		       }
			   	else
		       {
		         	s AliasFlag= 1   
		       } 			
				i ($$ALPHAUP^SSUTIL4(DEPCode)[code)&(AliasFlag=1)
				/*((PINYIN[desc)||($$ALPHAUP^SSUTIL4(DEPDesc)[desc)||(ALIASText1[desc))*/
				{
					d OutputRow1
				}			
			}
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
    set Data=$lb(DEPRowId,DEPCode,DEPDesc)
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

/// Creator:蔡昊哲
/// CreatDate:2013-8-30
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="0^未被引用可删除！"
	
	i $d(^CTLOC(0,"DepGrp",+id)) s return="1^在<科室表>里被引用,不能删除！"   ;CTLoc
    		
	q return
}

/// Function:实现对科室部门组类型的删除操作
/// Creator: 基础数据平台组 蔡昊哲
/// CreateDate:2012-08-30
/// Desc:通过rowid来删除科室部门组类型
/// Input: rowid
/// Output:success:'true',info:'删除成功！ 失败时输出删除成功！
/// Tables: RBC_DepartmentGroup
/// Others:do ##class(web.DHCBL.CT.RBCDepartmentGroup).DeleteData("")
ClassMethod DeleteData(id) As %String
{
	;n (id)
	s result=""
	
	s re=##class(web.DHCBL.CT.RBCDepartmentGroup).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag'=0){
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}
	else
	{
		Ts
		s pobj = ##class(User.RBCDepartmentGroup).%OpenId(id)
		s eobj = ##class(web.Entity.CT.RBCDepartmentGroup).%New()
		s eobj.DEPRowId=id
		s eobj.DEPCode = pobj.DEPCode
		s eobj.DEPDesc = pobj.DEPDesc
		s sc=##class(User.RBCDepartmentGroup).%DeleteId(id)
		IF $$$ISOK(sc){
			Tc
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("RBC_DepartmentGroup","User.RBCDepartmentGroup","科室部门组",id,eobj.DEPDesc,"D",eobj)
			s result="{success:'true',info:'删除成功！'}"
		}
		else{
			Trollback
			//s result= "{success:'false',info:'删除失败！'}"
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("科室部门组","web.DHCBL.CT.RBCDepartmentGroup","DeleteData",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	q result
}

/// Function:双击时显示弹出窗口的信息
/// CreateDate:2012-08-30
/// Creator:基础数据平台公共产品组 蔡昊哲
/// Input:输入sid
/// Tables: RBC_DepartmentGroup
/// Others:do ##class(web.DHCBL.CT.RBCDepartmentGroup).OpenData("")
ClassMethod OpenData(id As %String) As %String
{
	s str=""
	s pobj = ##class(User.RBCDepartmentGroup).%OpenId(id)
	s eobj = ##class(web.Entity.CT.RBCDepartmentGroup).%New()
	s eobj.DEPRowId=id
	s eobj.DEPCode = pobj.DEPCode
	s eobj.DEPDesc = pobj.DEPDesc
	;s:pobj.DEPDateFrom'="" eobj.DEPDateFrom =$zd(pobj.DEPDateFrom,1)
	;s:pobj.DEPDateTo'="" eobj.DEPDateTo = $zd(pobj.DEPDateTo,1)
	s:pobj.DEPDateFrom'="" eobj.DEPDateFrom =##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.DEPDateFrom)
	s:pobj.DEPDateTo'="" eobj.DEPDateTo = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.DEPDateTo)
    d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Function:用于实现数据校验功能的方法
/// Creator:基础数据平台组 蔡昊哲
/// CreateDate:2012-12-13
/// Table: RBC_DepartmentGroup
ClassMethod FormValidate(id As %String, code As %String, desc As %String, hospid As %String = "") As %String
{
	s flag=0
    if $$ALPHAUP^SSUTIL4(code)'=""
    {
        s idc=0
        for
        {
            s idc=$o(^RBC("DEP",0,"Code",$$ALPHAUP^SSUTIL4(code),idc)) q:idc=""
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
    
            s idd=$o(^RBC("DEP",0,"Desc",$$ALPHAUP^SSUTIL4(desc),idd)) q:idd=""
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

/// Function:对科室部门组类型的添加，修改操作
/// CreateDate:2012-08-30
/// Creator:基础数据平台公共产品组 蔡昊哲
/// Input:输入sid
/// Tables:RBC_DepartmentGroup
/// Others:do ##class(web.DHCBL.CT.RBCDepartmentGroup).SaveEntity("")
ClassMethod SaveEntity(eobj As web.Entity.CT.RBCDepartmentGroup) As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{
		s flag=..FormValidate(eobj.DEPRowId,eobj.DEPCode,eobj.DEPDesc,eobj.LinkHospId)  //调用重复验证
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		else
		{
			s:eobj.DEPDateFrom'="" eobj.DEPDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.DEPDateFrom)  //转换日期
			s:eobj.DEPDateTo'="" eobj.DEPDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.DEPDateTo)      //转换日期
			s:eobj.DEPDateFrom="" eobj.DEPDateFrom=+$h
			//如果RowId未赋值则增加
			if (eobj.DEPRowId="")       
			{
				//RowId未赋值,增加
				s obj=##class(User.RBCDepartmentGroup).%New()		
				s obj.DEPCode =eobj.DEPCode
				s obj.DEPDesc = eobj.DEPDesc
				s obj.DEPDateFrom=eobj.DEPDateFrom
				s obj.DEPDateTo=eobj.DEPDateTo
				Tstart
				s sc=obj.%Save()
				do obj.%Close()
				if $$$ISOK(sc){
					Tcommit
					s id = obj.%Id()
					d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("RBC_DepartmentGroup","User.RBCDepartmentGroup","科室部门组",id,eobj.DEPDesc,"A",eobj)
					s result = "{success:'true',id:'"_id_"'}"         //保存数据后,通过RowId返回到这条数据
				}else{
					Trollback
					s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
					s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("科室部门组","web.DHCBL.CT.RBCDepartmentGroup","SaveEntity",eobj)
					s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				}	
			}
				//如果RowId已赋值则修改
			else                           
			{
				//RowId已存在,修改
				s obj=##class(User.RBCDepartmentGroup).%OpenId(eobj.DEPRowId)
				s bobj=##class(web.Entity.CT.RBCDepartmentGroup).%New()
				s bobj.DEPRowId=eobj.DEPRowId
				s bobj.DEPCode =obj.DEPCode
				s bobj.DEPDesc = obj.DEPDesc
				s bobj.DEPDateFrom=obj.DEPDateFrom
	   			s bobj.DEPDateTo=obj.DEPDateTo		
				s obj.DEPCode =eobj.DEPCode
				s obj.DEPDesc = eobj.DEPDesc
				s obj.DEPDateFrom=eobj.DEPDateFrom
				s obj.DEPDateTo=eobj.DEPDateTo
		
				Tstart
				s sc=obj.%Save()
				do obj.%Close()
				if $$$ISOK(sc){
					Tcommit
					s id = obj.%Id()
					d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("RBC_DepartmentGroup","User.RBCDepartmentGroup","科室部门组",eobj.DEPRowId,eobj.DEPDesc,"U",eobj,bobj)
					s result = "{success:'true',id:'"_id_"'}"         //保存数据后,通过RowId返回到这条数据
				}else{
					Trollback
					s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
					s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("科室部门组","web.DHCBL.CT.RBCDepartmentGroup","SaveEntity",eobj)
					s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				}
			}	
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
ERROR
	s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("科室部门组","web.DHCBL.CT.RBCDepartmentGroup","SaveEntity",eobj)
	s ^ERRORLOGINFO(logid)=$ze
	q "{success:'false',errorinfo:'保存失败！'}"
}

}
