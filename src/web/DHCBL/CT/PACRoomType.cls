Import SQLUser

Class web.DHCBL.CT.PACRoomType Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// update2020-02-11
Parameter SQLTableName = "PAC_RoomType";

/// Function:房间类型维护 获取grid列表
/// Creator:基础数据平台组 蔡昊哲
/// Table:PAC_RoomType
/// Input:rowid,code ,desc
/// Output:ROOMT_RowId,ROOMT_Code,ROOMT_Desc,ROOMT_ARCIM_DR,ROOMT_DateFrom,ROOMT_DateTo
/// Others:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACRoomType", "GetList")
Query GetList(rowid As %String, code As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "ROOMTRowId,ROOMTCode,ROOMTDesc,ROOMTDateFrom,ROOMTDateTo,ROOMTARCIMDR,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, hospid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权Json
	s AuStr=##class(web.DHCBL.Authorize.PACRoomType).DHCGetDataByDefaultSession()
	;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
	;假设未授权情况下默认全部显示数据
	s AuFlag=0
	if AuStr="" s AuFlag=1 //判断是否有授权,如果没有则全部显示
	
	s:code'="" code=$ZCONVERT(code,"U")
	s:desc'="" desc=$ZCONVERT(desc,"U")
	if (rowid'="") //根据rowid返回该条记录
	{
		s ROOMTRowId=rowid
		s ROOMTCode=$p($g(^PAC("ROOMT",ROOMTRowId)),"^",1)
		s ROOMTDesc=$p($g(^PAC("ROOMT",ROOMTRowId)),"^",2)
		s ROOMTDateFrom=$p($g(^PAC("ROOMT",ROOMTRowId)),"^",5)
		s ROOMTDateTo=$p($g(^PAC("ROOMT",ROOMTRowId)),"^",6)
		s ROOMTARCIMDR=$p($g(^PAC("ROOMT",ROOMTRowId)),"^",3)
		S:ROOMTARCIMDR'="" ARCIMSubscript=$P(ROOMTARCIMDR,"||",1)
		S:ROOMTARCIMDR'="" ARCIMVersion=$P(ROOMTARCIMDR,"||",2)
		s:ROOMTARCIMDR'="" ROOMTARCIMDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
		s:ROOMTDateFrom'="" ROOMTDateFrom=$zd(ROOMTDateFrom,1) //转换日期格式
		s:ROOMTDateTo'="" ROOMTDateTo=$zd(ROOMTDateTo,1) //转换日期格式	
		s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
    	s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_RoomType",ROOMTRowId)
    	s BDPInternalCode =$p($g(resultStr),"^",1)       
    	s BDPInternalDesc = $p($g(resultStr),"^",2)  
    	s BDPHospNationalCode=$p($g(resultStr),"^",3)         
    	s BDPHospNationalDesc = $p($g(resultStr),"^",4)
		d OutputRow
	}
	else
	{
		s ROOMTRowId=0
		for  
		{	
			s ROOMTRowId=$o(^PAC("ROOMT",ROOMTRowId)) q:ROOMTRowId=""
			s strRowId = "{ID:"_ROOMTRowId_"}"
			i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			{
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,ROOMTRowId,hospid)
	  			continue:showflag="N"
	  			
				s ROOMTCode=$p($g(^PAC("ROOMT",ROOMTRowId)),"^",1)
				s ROOMTDesc=$p($g(^PAC("ROOMT",ROOMTRowId)),"^",2)
				s ROOMTDateFrom=$p($g(^PAC("ROOMT",ROOMTRowId)),"^",5)
				s ROOMTDateTo=$p($g(^PAC("ROOMT",ROOMTRowId)),"^",6)
				s ROOMTARCIMDR=$p($g(^PAC("ROOMT",ROOMTRowId)),"^",3)
				S:ROOMTARCIMDR'="" ARCIMSubscript=$P(ROOMTARCIMDR,"||",1) //获取医嘱项
				S:ROOMTARCIMDR'="" ARCIMVersion=$P(ROOMTARCIMDR,"||",2)
				s:ROOMTARCIMDR'="" ROOMTARCIMDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
				s:ROOMTDateFrom'="" ROOMTDateFrom=$zd(ROOMTDateFrom,1) //转换日期格式
				s:ROOMTDateTo'="" ROOMTDateTo=$zd(ROOMTDateTo,1) //转换日期格式
				s:ROOMTCode'="" Bcode=$ZCONVERT(ROOMTCode,"U")
				s:ROOMTDesc'="" Bdesc=$ZCONVERT(ROOMTDesc,"U")
				s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
            	s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_RoomType",ROOMTRowId)
            	s BDPInternalCode =$p($g(resultStr),"^",1)       
            	s BDPInternalDesc = $p($g(resultStr),"^",2)  
            	s BDPHospNationalCode=$p($g(resultStr),"^",3)         
            	s BDPHospNationalDesc = $p($g(resultStr),"^",4)
            	/*
				s ALIASText1=""
				s AliasRowId=0
				for{
					s AliasRowId=$o(^User.BDPAliasI("DataRef","PAC_RoomType",ROOMTRowId,AliasRowId))
					q:AliasRowId=""
  					S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
					s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
				}
				s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(Bdesc)
				*/
				if (desc'="")
		       {
			        ;需要对描述或者别名进行检索      
			        s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_RoomType",ROOMTRowId,ROOMTDesc,desc)
		       }
			   	else
		       {
		         	s AliasFlag= 1   
		       } 
				i (Bcode[code)&(AliasFlag=1)
				/*((Bdesc[desc)||(PINYIN[desc)||(ALIASText1[desc))*/
				{
					d OutputRow
				}
			}
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ROOMTRowId,ROOMTCode,ROOMTDesc,ROOMTDateFrom,ROOMTDateTo,ROOMTARCIMDR,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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
/// Table:PAC_RoomType
/// Input: desc, code 
/// Output:   
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACRoomType", "GetDataForCmbl","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "ROOMTRowId,ROOMTCode,ROOMTDesc")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, hospid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权Json
	s AuStr=##class(web.DHCBL.Authorize.PACRoomType).DHCGetDataByDefaultSession()
	;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
	;假设未授权情况下默认全部显示数据
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s ROOMTRowId=rowid
		s ROOMTCode=$p($g(^PAC("ROOMT",ROOMTRowId)),"^",1)
		s ROOMTDesc=$p($g(^PAC("ROOMT",ROOMTRowId)),"^",2)
		d OutputRow1
	}
	else
	{
		s AuFlag=0
		if AuStr="" s AuFlag=1 //判断是否有授权,如果没有则全部显示
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s ROOMTRowId=0
		for  
		{	
			s ROOMTRowId=$o(^PAC("ROOMT",ROOMTRowId)) q:ROOMTRowId=""
			s strRowId = "{ID:"_ROOMTRowId_"}"
			i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			{
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,ROOMTRowId,hospid)
	 			continue:showflag="N"
	 			
				s ROOMTCode=$p($g(^PAC("ROOMT",ROOMTRowId)),"^",1)
				s ROOMTDesc=$p($g(^PAC("ROOMT",ROOMTRowId)),"^",2)
				s:ROOMTCode'="" Bcode=$ZCONVERT(ROOMTCode,"U")
				s:ROOMTDesc'="" Bdesc=$ZCONVERT(ROOMTDesc,"U")
				s ROOMTDateFrom=$p($g(^PAC("ROOMT",ROOMTRowId)),"^",5)
				s ROOMTDateTo=$p($g(^PAC("ROOMT",ROOMTRowId)),"^",6)
				continue:(ROOMTDateFrom'="")&&(ROOMTDateFrom>+$h)
				continue:(ROOMTDateTo'="")&&(ROOMTDateTo<+$h)
				/*
				s ALIASText1=""
				s AliasRowId=0
				for{
					s AliasRowId=$o(^User.BDPAliasI("DataRef","PAC_RoomType",ROOMTRowId,AliasRowId))
					q:AliasRowId=""
  					S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
					s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
				}
				s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(Bdesc)
				*/
				if (desc'="")
		       {
			        ;需要对描述或者别名进行检索      
			        s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_RoomType",ROOMTRowId,ROOMTDesc,desc)
		       }
			   	else
		       {
		         	s AliasFlag= 1   
		       } 
				i (Bcode[code)&(AliasFlag=1)
				/*((Bdesc[desc)||(PINYIN[desc)||(ALIASText1[desc))*/
				{
					d OutputRow1
				}
			}
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
    set Data=$lb(ROOMTRowId,ROOMTCode,ROOMTDesc)
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
	
	s ROOMRowID=0
	f  s ROOMRowID=$o(^PAROOM(ROOMRowID)) q:ROOMRowID=""  d
	.s ROOMRoomTypeDR=$p($g(^PAROOM(ROOMRowID)),"^",3)
	.i ROOMRoomTypeDR=id s return="1^在房间表里被引用,不能删除！" ;PACROOM	
    		
	q return
}

/// Function:实现对房间类型的删除操作
/// Creator: 基础数据平台组 蔡昊哲
/// CreateDate:2012-08-30
/// Desc:通过rowid来删除房间类型
/// Input: rowid
/// Output:success:'true',info:'删除成功！ 失败时输出删除成功！
/// Tables: PAC_RoomType
/// Others:do ##class(web.DHCBL.CT.PACRoomType).DeleteData("")
ClassMethod DeleteData(id) As %String
{
	;n (id)
	s result=""
	
	s re=##class(web.DHCBL.CT.PACRoomType).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag'=0){
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}
	else
	{
	Ts
		s pobj = ##class(User.PACRoomType).%OpenId(id)
		s eobj = ##class(web.Entity.CT.PACRoomType).%New()
		s eobj.ROOMTRowId=id
		s eobj.ROOMTCode = pobj.ROOMTCode
		s eobj.ROOMTDesc = pobj.ROOMTDesc
	    if $IsObject(pobj.ROOMTARCIMDR){
			s eobj.ROOMTARCIMDR = pobj.ROOMTARCIMDR.%Id() 
			}
		s sc=##class(User.PACRoomType).%DeleteId(id)
		IF $$$ISOK(sc){
			Tc
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_RoomType","User.PACRoomType","房间类型",id,eobj.ROOMTDesc,"D",eobj)
		}
		else{
			Trollback
			//s result= "{success:'false',info:'删除失败！'}"
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("房间类型","web.DHCBL.CT.PACRoomType","DeleteData",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	q result
}

/// Function:双击时显示弹出窗口的信息
/// CreateDate:2012-08-30
/// Creator:基础数据平台公共产品组 蔡昊哲
/// Input:输入sid
/// Tables: PAC_RoomType
/// Others:do ##class(web.DHCBL.CT.PACRoomType).OpenData("")
ClassMethod OpenData(id As %String) As %String
{
	s str=""
	s pobj = ##class(User.PACRoomType).%OpenId(id)
	s eobj = ##class(web.Entity.CT.PACRoomType).%New()
	s eobj.ROOMTRowId=id
	s eobj.ROOMTCode = pobj.ROOMTCode
	s eobj.ROOMTDesc = pobj.ROOMTDesc
    if $IsObject(pobj.ROOMTARCIMDR){
		s eobj.ROOMTARCIMDR = pobj.ROOMTARCIMDR.%Id() 
		}
	;s:pobj.ROOMTDateFrom'="" eobj.ROOMTDateFrom =$zd(pobj.ROOMTDateFrom,1)
	;s:pobj.ROOMTDateTo'="" eobj.ROOMTDateTo = $zd(pobj.ROOMTDateTo,1)
	s:pobj.ROOMTDateFrom'="" eobj.ROOMTDateFrom =##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.ROOMTDateFrom)
	s:pobj.ROOMTDateTo'="" eobj.ROOMTDateTo =##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.ROOMTDateTo)
    d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Function:用于实现数据校验功能的方法
/// Creator:基础数据平台组 蔡昊哲
/// CreateDate:2012-12-13
/// Table: PAC_RoomType
ClassMethod FormValidate(id As %String, code As %String, desc As %String, hospid As %String = "") As %String
{
	s flag=0
    if $$ALPHAUP^SSUTIL4(code)'=""
    {
        s idc=0
        for
        {
            s idc=$o(^PAC("ROOMT",0,"Code",$$ALPHAUP^SSUTIL4(code),idc)) q:idc=""
            if (idc'=id)
            {
                s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,idc,hospid)
				continue:showflag="N"
				s flag=1
            }
        }
    }
    
    if $$ALPHAUP^SSUTIL4(desc)'=""
    {
        s idd=0
        for
        {
    
            s idd=$o(^PAC("ROOMT",0,"Desc",$$ALPHAUP^SSUTIL4(desc),idd)) q:idd=""
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

/// Function:对房间类型的添加，修改操作
/// CreateDate:2012-08-30
/// Creator:基础数据平台公共产品组 蔡昊哲
/// Input:输入sid
/// Tables:PAC_RoomType
/// Others:do ##class(web.DHCBL.CT.PACRoomType).SaveEntity("")
ClassMethod SaveEntity(eobj As web.Entity.CT.PACRoomType) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s flag=..FormValidate(eobj.ROOMTRowId,eobj.ROOMTCode,eobj.ROOMTDesc,eobj.LinkHospId)  //调用重复验证
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		else
		{
			s:eobj.ROOMTDateFrom'="" eobj.ROOMTDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ROOMTDateFrom)  //转换日期
			s:eobj.ROOMTDateTo'="" eobj.ROOMTDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ROOMTDateTo)      //转换日期
			s:eobj.ROOMTDateFrom="" eobj.ROOMTDateFrom=+$h
			//如果RowId未赋值则增加
			if (eobj.ROOMTRowId="")       
			{
				//RowId未赋值,增加
				s obj=##class(User.PACRoomType).%New()
				s obj.ROOMTCode =eobj.ROOMTCode
				s obj.ROOMTDesc = eobj.ROOMTDesc
				d:eobj.ROOMTARCIMDR'="" obj.ROOMTARCIMDRSetObjectId(eobj.ROOMTARCIMDR)
				s obj.ROOMTDateFrom=eobj.ROOMTDateFrom
				s obj.ROOMTDateTo=eobj.ROOMTDateTo
				Tstart
				s sc=obj.%Save()
				s ^TMPL(1)=sc
				do obj.%Close()
				if $$$ISOK(sc){
					Tcommit
					s id = obj.%Id()
					s result = "{success:'true',id:'"_id_"'}"         //保存数据后,通过RowId返回到这条数据
					d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_RoomType","User.PACRoomType","房间类型",id,eobj.ROOMTDesc,"A",eobj)
				}else{
					Trollback
					s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
					s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("房间类型","web.DHCBL.CT.PACRoomType","SaveEntity",eobj)
					s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)  
				}	
			}
				//如果RowId已赋值则修改
			else                           
			{
				//RowId已存在,修改
				s obj=##class(User.PACRoomType).%OpenId(eobj.ROOMTRowId)
				s bobj=##class(web.Entity.CT.PACRoomType).%New()
				s bobj.ROOMTRowId=eobj.ROOMTRowId
				s bobj.ROOMTCode =obj.ROOMTCode
				s bobj.ROOMTDesc = obj.ROOMTDesc
				s:obj.ROOMTARCIMDR'="" bobj.ROOMTARCIMDR=obj.ROOMTARCIMDR.%Id()
				s bobj.ROOMTDateFrom=obj.ROOMTDateFrom
	  			s bobj.ROOMTDateTo= obj.ROOMTDateTo
							
				s obj.ROOMTCode =eobj.ROOMTCode
				s obj.ROOMTDesc = eobj.ROOMTDesc
				s obj.ROOMTARCIMDR=##class(User.ARCItmMast).%OpenId(eobj.ROOMTARCIMDR)
				s obj.ROOMTDateFrom=eobj.ROOMTDateFrom
				s obj.ROOMTDateTo=eobj.ROOMTDateTo
		
				Tstart
				s sc=obj.%Save()
				do obj.%Close()
				if $$$ISOK(sc){
					Tcommit
					s id = obj.%Id()
					d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_RoomType","User.PACRoomType","房间类型",id,eobj.ROOMTDesc,"U",eobj,bobj)
					s result = "{success:'true',id:'"_id_"'}"         //保存数据后,通过RowId返回到这条数据
				}else{
					Trollback
					s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
					s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("房间类型","web.DHCBL.CT.PACRoomType","SaveEntity",eobj)
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
}

}
