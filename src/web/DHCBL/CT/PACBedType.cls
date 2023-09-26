Import SQLUser

Class web.DHCBL.CT.PACBedType Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// update2020-02-11
Parameter SQLTableName = "PAC_BedType";

/// Function:床位类型维护 获取grid列表
/// Creator:基础数据平台组 蔡昊哲
/// Table:PAC_BedType
/// Input:RowId,code ,desc
/// Output:BEDTP_RowId,BEDTP_Code,BEDTP_Desc,BEDTP_RcFlag,BEDTP_BedTypeCode_DR,BEDTP_ICUFlag,BEDTP_DateFrom,BEDTP_DateTo
/// Others:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACBedType", "GetList")
Query GetList(rowid As %String, code As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "BEDTPRowId,BEDTPCode,BEDTPDesc,BEDTPRcFlag,BEDTPBedTypeCodeDR,BEDTPICUFlag,BEDTPDateFrom,BEDTPDateTo,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, hospid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s:code'="" code=$ZCONVERT(code,"U")
	s:desc'="" desc=$ZCONVERT(desc,"U")
	
	//获取授权Json
	s AuStr=##class(web.DHCBL.Authorize.PACBedType).DHCGetDataByDefaultSession()
	;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
	;设未授权情况下默认全部显示数据
	s AuFlag=0
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s BEDTPRowId=rowid
		s BEDTPCode=$p($g(^PAC("BEDTP",BEDTPRowId)),"^",1)
		s BEDTPDesc=$p($g(^PAC("BEDTP",BEDTPRowId)),"^",2)
		s BEDTPRcFlag=$p($g(^PAC("BEDTP",BEDTPRowId)),"^",3)
		s BEDTPBedTypeCodeDR=$p($g(^PAC("BEDTP",BEDTPRowId)),"^",4)
		if BEDTPBedTypeCodeDR'=""
		{
			s ARCIMSubscript=$P(BEDTPBedTypeCodeDR,"||",1) //获取医嘱项
			s ARCIMVersion=$P(BEDTPBedTypeCodeDR,"||",2)
			s BEDTPBedTypeCodeDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)	
		}	
		s BEDTPICUFlag=$p($g(^PAC("BEDTP",BEDTPRowId)),"^",5)
		s BEDTPDateFrom=$p($g(^PAC("BEDTP",BEDTPRowId)),"^",8)
		s BEDTPDateTo=$p($g(^PAC("BEDTP",BEDTPRowId)),"^",9)
		s:BEDTPDateFrom'="" BEDTPDateFrom=$zd(BEDTPDateFrom,1) //转换日期格式
		s:BEDTPDateTo'="" BEDTPDateTo=$zd(BEDTPDateTo,1) //转换日期格式	
		s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
    	s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_BedType",BEDTPRowId)
    	s BDPInternalCode =$p($g(resultStr),"^",1)       
    	s BDPInternalDesc = $p($g(resultStr),"^",2)  
    	s BDPHospNationalCode=$p($g(resultStr),"^",3)         
    	s BDPHospNationalDesc = $p($g(resultStr),"^",4)
		d OutputRow
	}
	else
	{
		s BEDTPRowId=0
		for  
		{	
			s BEDTPRowId=$o(^PAC("BEDTP",BEDTPRowId)) q:BEDTPRowId=""
			s strRowId = "{ID:"_BEDTPRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			{
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,BEDTPRowId,hospid)
	  			continue:showflag="N"
				
				s BEDTPCode=$p($g(^PAC("BEDTP",BEDTPRowId)),"^",1)
				s BEDTPDesc=$p($g(^PAC("BEDTP",BEDTPRowId)),"^",2)
				s BEDTPRcFlag=$p($g(^PAC("BEDTP",BEDTPRowId)),"^",3)
				s BEDTPBedTypeCodeDR=$p($g(^PAC("BEDTP",BEDTPRowId)),"^",4)
				if BEDTPBedTypeCodeDR'=""
				{
					s ARCIMSubscript=$P(BEDTPBedTypeCodeDR,"||",1) //获取医嘱项
					s ARCIMVersion=$P(BEDTPBedTypeCodeDR,"||",2)
					s BEDTPBedTypeCodeDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)	
				}	
				s BEDTPICUFlag=$p($g(^PAC("BEDTP",BEDTPRowId)),"^",5)
				s BEDTPDateFrom=$p($g(^PAC("BEDTP",BEDTPRowId)),"^",8)
				s BEDTPDateTo=$p($g(^PAC("BEDTP",BEDTPRowId)),"^",9)
				s:BEDTPDateFrom'="" BEDTPDateFrom=$zd(BEDTPDateFrom,1) //转换日期格式
				s:BEDTPDateTo'="" BEDTPDateTo=$zd(BEDTPDateTo,1) //转换日期格式
				s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
            	s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_BedType",BEDTPRowId)
            	s BDPInternalCode =$p($g(resultStr),"^",1)       
            	s BDPInternalDesc = $p($g(resultStr),"^",2)  
            	s BDPHospNationalCode=$p($g(resultStr),"^",3)         
            	s BDPHospNationalDesc = $p($g(resultStr),"^",4)
            	/*
				s ALIASText1=""
				s AliasRowId=0
				for{
					s AliasRowId=$o(^User.BDPAliasI("DataRef","PAC_BedType",BEDTPRowId,AliasRowId))
					q:AliasRowId=""
  					S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
					s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
				}
				s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($ZCVT(BEDTPDesc,"u"))
				*/
				if (desc'="")
		       {
			        ;需要对描述或者别名进行检索      
			        s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_BedType",BEDTPRowId,BEDTPDesc,desc)
		       }
			   	else
		       {
		         	s AliasFlag= 1   
		       } 
				if ($ZCVT(BEDTPCode,"u")[code)&(AliasFlag=1) 
				/*($ZCVT(BEDTPDesc,"u")[desc)||(PINYIN[desc)||(ALIASText1[desc)*/
				{
					d OutputRow
				}
			}
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(BEDTPRowId,BEDTPCode,BEDTPDesc,BEDTPRcFlag,BEDTPBedTypeCodeDR,BEDTPICUFlag,BEDTPDateFrom,BEDTPDateTo,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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
/// Table:PAC_BedType
/// Input: desc, code 
/// Output:   
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACBedType", "GetDataForCmbl","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "BEDTPRowId,BEDTPCode,BEDTPDesc")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, hospid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	//获取授权Json
	s AuStr=##class(web.DHCBL.Authorize.PACBedType).DHCGetDataByDefaultSession()
	;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
	;假设未授权情况下默认全部显示数据
	s AuFlag=0
	if AuStr="" s AuFlag=1 //判断是否有授权,如果没有则全部显示
	
	s:code'="" code=$ZCONVERT(code,"U")
	s:desc'="" desc=$ZCONVERT(desc,"U")
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s BEDTPRowId= rowid
		s BEDTPCode=$p($g(^PAC("BEDTP",BEDTPRowId)),"^",1)
		s BEDTPDesc=$p($g(^PAC("BEDTP",BEDTPRowId)),"^",2)
		d OutputRow1
	}
	else
	{
		s BEDTPRowId=0
		for  
		{	
			s BEDTPRowId=$o(^PAC("BEDTP",BEDTPRowId)) q:BEDTPRowId=""
			s strRowId = "{ID:"_BEDTPRowId_"}"
			i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			{
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,BEDTPRowId,hospid)
	 			continue:showflag="N"
				
				s BEDTPCode=$p($g(^PAC("BEDTP",BEDTPRowId)),"^",1)
				s BEDTPDesc=$p($g(^PAC("BEDTP",BEDTPRowId)),"^",2)
				s BEDTPDateFrom=$p($g(^PAC("BEDTP",BEDTPRowId)),"^",8)
				s BEDTPDateTo=$p($g(^PAC("BEDTP",BEDTPRowId)),"^",9)
				continue:(BEDTPDateFrom'="")&&(BEDTPDateFrom>+$h)
				continue:(BEDTPDateTo'="")&&(BEDTPDateTo<+$h)
				/*
				s ALIASText1=""
				s AliasRowId=0
				for{
					s AliasRowId=$o(^User.BDPAliasI("DataRef","PAC_BedType",BEDTPRowId,AliasRowId))
					q:AliasRowId=""
  					S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
					s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
				}
				s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($ZCVT(BEDTPDesc,"u"))
				*/
				if (desc'="")
		       {
			        ;需要对描述或者别名进行检索      
			        s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_BedType",BEDTPRowId,BEDTPDesc,desc)
		       }
			   	else
		       {
		         	s AliasFlag= 1   
		       } 
				if ($ZCVT(BEDTPCode,"u")[code)&(AliasFlag=1)
				/*($ZCVT(BEDTPDesc,"u")[desc)||(PINYIN[desc)||(ALIASText1[desc)*/
				{
					d OutputRow1
				}
			}
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
    set Data=$lb(BEDTPRowId,BEDTPCode,BEDTPDesc)
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
	s return="",myInfo=""
	
	s return="0^未被引用可删除！"
	
	i $d(^PAWARD("BED_BedType_DR",+id))	s myInfo=myInfo_"<床位表>" ;原索引
	i $d(^PAWARD(0,"BED_BedType_DR",+id))	s myInfo=myInfo_"<床位表>"
    		
	i myInfo="" s return="0^未被引用可删除!"
 	else  s return="1^在"_myInfo_"表里被引用,不能删除!"
 	
	q return
}

/// Function:实现对床位类型的删除操作
/// Creator: 基础数据平台组 蔡昊哲
/// CreateDate:2012-08-30
/// Desc:通过rowid来删除床位类型
/// Input: rowid
/// Output:success:'true',info:'删除成功！ 失败时输出删除成功！
/// Tables: PAC_BedType
/// Others:do ##class(web.DHCBL.CT.PACBedType).DeleteData("")
ClassMethod DeleteData(id) As %String
{
	;n (id)
	s result=""
	
	s re=##class(web.DHCBL.CT.PACBedType).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag'=0){
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}
	else
	{
		
		s pobj = ##class(User.PACBedType).%OpenId(id)
		s eobj = ##class(web.Entity.CT.PACBedType).%New()
		s eobj.BEDTPRowId=id
		s eobj.BEDTPCode = pobj.BEDTPCode
		s eobj.BEDTPDesc = pobj.BEDTPDesc
		s eobj.BEDTPRcFlag = pobj.BEDTPRcFlag 
	    if $IsObject(pobj.BEDTPBedTypeCodeDR)
	    {
			s eobj.BEDTPBedTypeCodeDR = pobj.BEDTPBedTypeCodeDR.%Id() 
		}
		s eobj.BEDTPICUFlag = pobj.BEDTPICUFlag
		s eobj.BEDTPDateFrom =pobj.BEDTPDateFrom
		s eobj.BEDTPDateTo = pobj.BEDTPDateTo
		Ts
		s sc=##class(User.PACBedType).%DeleteId(id)
		IF $$$ISOK(sc){
			Tc
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_BedType","User.PACBedType","床位类型",id,eobj.BEDTPDesc,"D",eobj)
		}
		else{
			Trollback
			//s result= "{success:'false',info:'删除失败！'}"
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("床位类型","web.DHCBL.CT.PACBedType","DeleteData",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	q result
}

/// Function:双击时显示弹出窗口的信息
/// CreateDate:2012-08-30
/// Creator:基础数据平台公共产品组 蔡昊哲
/// Input:输入sid
/// Tables: PAC_BedType
/// Others:do ##class(web.DHCBL.CT.PACBedType).OpenData("")
ClassMethod OpenData(id As %String) As %String
{
	s str=""
	s pobj = ##class(User.PACBedType).%OpenId(id)
	s eobj = ##class(web.Entity.CT.PACBedType).%New()
	s eobj.BEDTPRowId=id
	s eobj.BEDTPCode = pobj.BEDTPCode
	s eobj.BEDTPDesc = pobj.BEDTPDesc
    if $IsObject(pobj.BEDTPBedTypeCodeDR)
    {
		s eobj.BEDTPBedTypeCodeDR = pobj.BEDTPBedTypeCodeDR.%Id() 
	}
	;s:pobj.BEDTPDateFrom'="" eobj.BEDTPDateFrom =$zd(pobj.BEDTPDateFrom,1)
	;s:pobj.BEDTPDateTo'="" eobj.BEDTPDateTo = $zd(pobj.BEDTPDateTo,1)
	s:pobj.BEDTPDateFrom'="" eobj.BEDTPDateFrom =##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.BEDTPDateFrom)
	s:pobj.BEDTPDateTo'="" eobj.BEDTPDateTo = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.BEDTPDateTo)
    s eobj.BEDTPRcFlag=pobj.BEDTPRcFlag
    s eobj.BEDTPICUFlag=pobj.BEDTPICUFlag
    s:eobj.BEDTPRcFlag="Y" eobj.BEDTPRcFlag="true"
    s:eobj.BEDTPICUFlag="Y" eobj.BEDTPICUFlag="true"
    d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Function:用于实现数据校验功能的方法
/// Creator:基础数据平台组 蔡昊哲
/// CreateDate:2012-12-13
/// Table: PAC_BedType
/// w ##class(web.DHCBL.CT.PACBedType).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String, hospid As %String = "") As %String
{
	s flag=0
	if $$ALPHAUP^SSUTIL4(code)'=""
	{
		s idc=0
		for
		{ 
			s idc=$o(^PAC("BEDTP",0,"BEDTP_Code",$$ALPHAUP^SSUTIL4(code),idc)) q:idc=""
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
	
			s idd=$o(^PAC("BEDTP",0,"BEDTP_Desc",$$ALPHAUP^SSUTIL4(desc),idd)) q:idd=""
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

/// Function:对床位类型的添加，修改操作
/// CreateDate:2012-08-30
/// Creator:基础数据平台公共产品组 蔡昊哲
/// Input:输入sid
/// Tables:PAC_BedType
/// Others:do ##class(web.DHCBL.CT.PACBedType).SaveEntity("")
ClassMethod SaveEntity(eobj As web.Entity.CT.PACBedType) As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.BEDTPICUFlag="" eobj.BEDTPICUFlag="N"
		s:eobj.BEDTPRcFlag="" eobj.BEDTPRcFlag="N"
		;s:eobj.BEDTPDateFrom'="" eobj.BEDTPDateFrom=$zdh(eobj.BEDTPDateFrom,15)  //转换日期
		;s:eobj.BEDTPDateTo'="" eobj.BEDTPDateTo=$zdh(eobj.BEDTPDateTo,15)      //转换日期
		s:eobj.BEDTPDateFrom'="" eobj.BEDTPDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.BEDTPDateFrom)  //转换日期
		s:eobj.BEDTPDateTo'="" eobj.BEDTPDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.BEDTPDateTo)      //转换日期
		s:eobj.BEDTPDateFrom="" eobj.BEDTPDateFrom=+$h
		s flag=..FormValidate(eobj.BEDTPRowId,eobj.BEDTPCode,eobj.BEDTPDesc,eobj.LinkHospId)  //调用重复验证
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		else
		{
			if (eobj.BEDTPRowId="")       
			{
				//RowId未赋值,增加
				s obj=##class(User.PACBedType).%New()	
			}
			else                           
			{
				//RowId已存在,修改
				s obj=##class(User.PACBedType).%OpenId(eobj.BEDTPRowId)
				s bobj=##class(web.Entity.CT.PACBedType).%New()
				s bobj.BEDTPRowId=eobj.BEDTPRowId
				s bobj.BEDTPCode =obj.BEDTPCode
				s bobj.BEDTPDesc = obj.BEDTPDesc
				s bobj.BEDTPRcFlag = obj.BEDTPRcFlag
				s bobj.BEDTPICUFlag = obj.BEDTPICUFlag
				s:obj.BEDTPBedTypeCodeDR'="" bobj.BEDTPBedTypeCodeDR = obj.BEDTPBedTypeCodeDR.%Id()
				s bobj.BEDTPDateFrom=obj.BEDTPDateFrom
				s bobj.BEDTPDateTo=obj.BEDTPDateTo
			}
			s obj.BEDTPCode =eobj.BEDTPCode
			s obj.BEDTPDesc = eobj.BEDTPDesc
			
			s obj.BEDTPRcFlag = eobj.BEDTPRcFlag
			
			s obj.BEDTPICUFlag = eobj.BEDTPICUFlag
			d obj.BEDTPBedTypeCodeDRSetObjectId(eobj.BEDTPBedTypeCodeDR)
			s obj.BEDTPDateFrom=eobj.BEDTPDateFrom
			s obj.BEDTPDateTo=eobj.BEDTPDateTo
			Tstart
			s sc=obj.%Save()
			do obj.%Close()
			if $$$ISOK(sc){
				Tcommit
				s id = obj.%Id()
				d:eobj.BEDTPRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_BedType","User.PACBedType","床位类型",id,eobj.BEDTPDesc,"A",eobj)
				d:eobj.BEDTPRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_BedType","User.PACBedType","床位类型",id,eobj.BEDTPDesc,"U",eobj,bobj)
				s result = "{success:'true',id:'"_id_"'}"         //保存数据后,通过RowId返回到这条数据
			}else{
				Trollback
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
				s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("床位类型","web.DHCBL.CT.PACBedType","SaveEntity",eobj)
				s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
			}						
		}	
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
ERROR
	s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("床位类型","web.DHCBL.CT.PACBedType","SaveEntity",eobj)
	s ^ERRORLOGINFO(logid)=$ze
	q "{success:'false',errorinfo:'保存失败！'}"
}

}
