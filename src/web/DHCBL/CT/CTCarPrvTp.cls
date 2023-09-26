Import SQLUser

/// 名称: 医护人员类型	
/// 描述: 医护人员类型维护，包含增删改查功能
/// 编写者：基础平台组 、蔡昊哲
/// 编写日期: 2012-7-20
Class web.DHCBL.CT.CTCarPrvTp Extends %RegisteredObject
{

/// Creator：蔡昊哲
/// CreatDate: 2013-2-22
/// Description：查询医护人员类型的内容
/// Table：User.CTCarPrvTp
/// Input：rowid,code,desc,query
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTCarPrvTp","GetList","","","","")
Query GetList(rowid, code, desc, InternalType, query) As %Query(ROWSPEC = "CTCPTRowId,CTCPTCode,CTCPTDesc,CTCPTActiveFlag,CTCPTInternalType,CTCPTDateFrom,CTCPTDateTo,CTCPTRotaryFlag,CTCPTStudyFlag,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, code, desc, InternalType, query) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权Json
	s AuStr=##class(web.DHCBL.Authorize.CTCarPrvTp).DHCGetDataByDefaultSession()
	;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
	;假设未授权情况下默认全部显示数据
	s AuFlag=0
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s CTCPTRowId=rowid
		s CTCPTCode=$p($g(^CT("CPT",CTCPTRowId)),"^",1)
		s CTCPTDesc=$p($g(^CT("CPT",CTCPTRowId)),"^",2)
		s CTCPTActiveFlag=$p($g(^CT("CPT",CTCPTRowId)),"^",3)
		s CTCPTInternalType=$p($g(^CT("CPT",CTCPTRowId)),"^",4)
		s CTCPTDateFrom=$p($g(^CT("CPT",CTCPTRowId)),"^",5)
		s CTCPTDateTo=$p($g(^CT("CPT",CTCPTRowId)),"^",6)
		s CTCPTRotaryFlag=$p($g(^CT("CPT",CTCPTRowId)),"^",8)
		s CTCPTStudyFlag=$p($g(^CT("CPT",CTCPTRowId)),"^",9)
		s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
        s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_CarPrvTp",CTCPTRowId)
        s BDPInternalCode =$p($g(resultStr),"^",1)       
        s BDPInternalDesc = $p($g(resultStr),"^",2)  
        s BDPHospNationalCode=$p($g(resultStr),"^",3)         
        s BDPHospNationalDesc = $p($g(resultStr),"^",4)
		s:CTCPTDateFrom'="" CTCPTDateFrom=$zd(CTCPTDateFrom,1) //转换日期格式
		s:CTCPTDateTo'="" CTCPTDateTo=$zd(CTCPTDateTo,1) //转换日期格式
	
		d OutputRow
	}
	else
	{
		s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
		s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
		s:query'="" query=$$ALPHAUP^SSUTIL4(query)
		s CTCPTRowId=0
		for  
		{	
			s CTCPTRowId=$o(^CT("CPT",CTCPTRowId)) q:CTCPTRowId=""
			s strRowId = "{ID:"_CTCPTRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			{
				s CTCPTCode=$p($g(^CT("CPT",CTCPTRowId)),"^",1)
				s CTCPTDesc=$p($g(^CT("CPT",CTCPTRowId)),"^",2)
				s CTCPTActiveFlag=$p($g(^CT("CPT",CTCPTRowId)),"^",3)
				s CTCPTInternalType=$p($g(^CT("CPT",CTCPTRowId)),"^",4)
				s CTCPTDateFrom=$p($g(^CT("CPT",CTCPTRowId)),"^",5)
				s CTCPTDateTo=$p($g(^CT("CPT",CTCPTRowId)),"^",6)
				s CTCPTRotaryFlag=$p($g(^CT("CPT",CTCPTRowId)),"^",8)
				s CTCPTStudyFlag=$p($g(^CT("CPT",CTCPTRowId)),"^",9)
				s CTCPTCode1=$ZCONVERT(CTCPTCode,"U")
				s CTCPTDesc1=$ZCONVERT(CTCPTDesc,"U")
				s:CTCPTDateFrom'="" CTCPTDateFrom=$zd(CTCPTDateFrom,1) //转换日期格式
				s:CTCPTDateTo'="" CTCPTDateTo=$zd(CTCPTDateTo,1) //转换日期格式		
				s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
            	s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_CarPrvTp",CTCPTRowId)
            	s BDPInternalCode =$p($g(resultStr),"^",1)       
            	s BDPInternalDesc = $p($g(resultStr),"^",2)  
            	s BDPHospNationalCode=$p($g(resultStr),"^",3)         
            	s BDPHospNationalDesc = $p($g(resultStr),"^",4)
            	/*
				s ALIASText1=""
				s AliasRowId=0
				for{
					s AliasRowId=$o(^User.BDPAliasI("DataRef","CT_CarPrvTp",CTCPTRowId,AliasRowId))
					q:AliasRowId=""
  					S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
					s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
				}
				*/
				s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(CTCPTDesc1)
				if (desc'="")
		       {
			        ;需要对描述或者别名进行检索      
			        s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_CarPrvTp",CTCPTRowId,CTCPTDesc,desc)
		       }
			   	else
		       {
		         	s AliasFlag= 1   
		       } 
				i (CTCPTCode1[code)&(AliasFlag=1)&(CTCPTInternalType[InternalType)&((CTCPTDesc[query)||(PINYIN[query))
				/*((CTCPTDesc1[desc)||(PINYIN[desc)||(ALIASText1[desc))*/
				{
					d OutputRow	
				}
			}
		}	
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(CTCPTRowId,CTCPTCode,CTCPTDesc,CTCPTActiveFlag,CTCPTInternalType,CTCPTDateFrom,CTCPTDateTo,CTCPTRotaryFlag,CTCPTStudyFlag,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = NewQuery1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = NewQuery1Execute ]
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

/// Creator：蔡昊哲
/// CreatDate: 2013-11-5
/// Description：根据条件获取医护人员类型
/// Table：User.CTCarPrvTp
/// Input：无
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTCareProv","GetDataForCmb1")
Query GetDataForCmb1(code, desc, InternalType, query, rowid) As %Query(ROWSPEC = "CTCPTRowId,CTCPTCode,CTCPTDesc")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, code, desc, InternalType, query, rowid) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权Json
	s AuStr=##class(web.DHCBL.Authorize.CTCarPrvTp).DHCGetDataByDefaultSession()
	;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
	;假设未授权情况下默认全部显示数据
	;s AuStr=""
	s AuFlag=0
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	s:code'="" code=$$ALPHAUP^SSUTIL4(code)
	s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
	s:query'="" query=$$ALPHAUP^SSUTIL4(query)
	if (rowid'="") //根据rowid返回该条记录
	{
		s CTCPTRowId=rowid
		s CTCPTCode=$p($g(^CT("CPT",CTCPTRowId)),"^",1)
		s CTCPTDesc=$p($g(^CT("CPT",CTCPTRowId)),"^",2)
		s CTCPTActiveFlag=$p($g(^CT("CPT",CTCPTRowId)),"^",3)
		s CTCPTInternalType=$p($g(^CT("CPT",CTCPTRowId)),"^",4)
		s CTCPTDateFrom=$p($g(^CT("CPT",CTCPTRowId)),"^",5)
		s CTCPTDateTo=$p($g(^CT("CPT",CTCPTRowId)),"^",6)
		
		s:CTCPTDateFrom'="" CTCPTDateFrom=$zd(CTCPTDateFrom,1) //转换日期格式
		s:CTCPTDateTo'="" CTCPTDateTo=$zd(CTCPTDateTo,1) //转换日期格式
	
		d OutputRowCmb
	}
	else
	{
		s CTCPTRowId=0
		for  
		{	
			s CTCPTRowId=$o(^CT("CPT",CTCPTRowId)) q:CTCPTRowId=""
			s strRowId = "{ID:"_CTCPTRowId_"}"
			//s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			{
				s CTCPTCode=$p($g(^CT("CPT",CTCPTRowId)),"^",1)
				s CTCPTDesc=$p($g(^CT("CPT",CTCPTRowId)),"^",2)
				s CTCPTInternalType=$p($g(^CT("CPT",CTCPTRowId)),"^",4)
				s CTCPTCode1=$ZCONVERT(CTCPTCode,"U")
				s CTCPTDesc1=$ZCONVERT(CTCPTDesc,"U")
				s CTCPTDateFrom=$p($g(^CT("CPT",CTCPTRowId)),"^",5)
				s CTCPTDateTo=$p($g(^CT("CPT",CTCPTRowId)),"^",6)
				continue:(CTCPTDateFrom'="")&&(CTCPTDateFrom>+$h)
				continue:(CTCPTDateTo'="")&&(CTCPTDateTo<+$h)
				/*
				s ALIASText1=""
				s AliasRowId=0
				for{
					s AliasRowId=$o(^User.BDPAliasI("DataRef","CT_CarPrvTp",CTCPTRowId,AliasRowId))
					q:AliasRowId=""
  					S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
					s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
				}
				*/
				s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(CTCPTDesc1)
				if (desc'="")
		       {
			        ;需要对描述或者别名进行检索      
			        s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_CarPrvTp",CTCPTRowId,CTCPTDesc,desc)
		       }
			   	else
		       {
		         	s AliasFlag= 1   
		       } 
				i (CTCPTCode1[code)&(AliasFlag=1)&(CTCPTInternalType[InternalType)&((CTCPTDesc[query)||(PINYIN[query))
				/*((CTCPTDesc1[desc)||(PINYIN[desc)||(ALIASText1[desc))*/
				{
					d OutputRowCmb	
				}
			}
		}	
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(CTCPTRowId,CTCPTCode,CTCPTDesc)
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

/// Function:用于获取类型
/// Creator:基础数据平台组 蔡昊哲
/// CreateDate:2013-7-11
/// Table：User.CTCarPrvTp
/// w ##class(web.DHCBL.CT.CTCarPrvTp).GetInternalType("1")
ClassMethod GetInternalType(id As %String) As %String
{
	s flag=""
	s flag=$p($g(^CT("CPT",id)),"^",4)
	i (flag="DOCTOR")
	{
		 s flag="D"
	}
	elseif (flag="NURSE")
	{
		s flag="N"
	}
	else
	{
		s flag="O"  //other
	}
	q flag
}

/// Function:用于获取类型
/// Creator:基础数据平台组 蔡昊哲
/// CreateDate:2013-7-11
/// Table：User.CTCarPrvTp
/// w ##class(web.DHCBL.CT.CTCarPrvTp).GetInternalTypeForCareID("1")
ClassMethod GetInternalTypeForCareID(id As %String) As %String
{
	s flag=""
	s CTPCPCarPrvTpDR1=$p($g(^CTPCP(id,1)),"^",4)    //人员类型ID
	s flag=$p($g(^CT("CPT",CTPCPCarPrvTpDR1)),"^",4)
	i (flag="DOCTOR")
	{
		 s flag="D"
	}
	elseif (flag="NURSE")
	{
		s flag="N"
	}
	else
	{
		s flag="O"  //other
	}
	q flag
}

/// Function:用于实现数据校验功能的方法
/// Creator:基础数据平台组 蔡昊哲
/// CreateDate:2013-1-11
/// Table：User.CTCarPrvTp
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	s code=$ZCONVERT(code,"U")
	s desc=$ZCONVERT(desc,"U")
	
	s flag=""
	s flagc=""
	s flagd=""
	s:code'="" flagc=$d(^CT("CPT",0,"Code",code))
	s:desc'="" flagd=$d(^CT("CPT",0,"Desc",desc))
	if (id="") //如果为空，增加时的重复判断
	{
		if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc=""
		s idd=""
		s:code'="" idc=$o(^CT("CPT",0,"Code",code,0))
		s:desc'="" idd=$o(^CT("CPT",0,"Desc",desc,0))
		if (desc="")
		{
			if (idc'=id)&(flagc>0) s flag=1  //返回重复标志
			else  s flag=0 //返回不重复标志
		}
		elseif (code="")
		{
			if (idd'=id)&(flagd>0) s flag=1  //返回重复标志
			else  s flag=0 //返回不重复标志
		}
		else
		{
			if ((idc'=id)&(flagc>0))||((idd'=id)&(flagd>0)) s flag=1  //返回重复标志
			else  s flag=0 //返回不重复标志
		}
	}
	q flag
}

/// Creator：蔡昊哲
/// CreatDate: 2012-7-18
/// Description：保存修改医护人员类型的内容
/// Table：User.CTCarPrvTp
/// Input：web.Entity.CT.CTCarPrvTp 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.Entity.CT.CTCarPrvTp) As %String
{
    ; d ##class(web.DHCBL.CT.CTCarPrvTp).SaveEntity()
	s $zt="EEROE"
	s result=""
	s:eobj.CTCPTRotaryFlag="" eobj.CTCPTRotaryFlag="N"
	s:eobj.CTCPTStudyFlag="" eobj.CTCPTStudyFlag="N"
	s eobj.CTCPTInternalType=$CASE(eobj.CTCPTInternalType,"护士":"NURSE","医生":"DOCTOR","技师":"Technician","药师":"Pharmacist","其他":"Other",:eobj.CTCPTInternalType)  //适用于BDP数据导入里转换中文为对应的类型英文
	
	s flag=..FormValidate(eobj.CTCPTRowId,eobj.CTCPTCode,eobj.CTCPTDesc)  //调用重复验证
	if (flag=1)
	{
		s result = "{success:'false',errorinfo:'该记录已经存在！'}"
	}
	else
	{
		if $IsObject(eobj)
		{	
			s:eobj.CTCPTDateFrom="" eobj.CTCPTDateFrom=+$h
		  	;s:eobj.CTCPTDateFrom'="" eobj.CTCPTDateFrom=$zdh(eobj.CTCPTDateFrom,15)  //转换日期
  			;s:eobj.CTCPTDateTo'="" eobj.CTCPTDateTo=$zdh(eobj.CTCPTDateTo,15)      //转换日期
  			s:eobj.CTCPTDateFrom'="" eobj.CTCPTDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTCPTDateFrom)  //转换日期
  			s:eobj.CTCPTDateTo'="" eobj.CTCPTDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTCPTDateTo)      //转换日期
			if ((eobj.CTCPTRowId)="")                             //如果RowId未赋值则增加
			{	
		        s obj=##class(User.CTCarPrvTp).%New()
			}
			else                                                  //如果RowId已赋值则修改
			{
				s obj=##class(User.CTCarPrvTp).%OpenId(eobj.CTCPTRowId)
				s bobj=##class(web.Entity.CT.CTCarPrvTp).%New()
				s bobj.CTCPTRowId = eobj.CTCPTRowId
				s bobj.CTCPTCode = obj.CTCPTCode                      //修改代码
				s bobj.CTCPTDesc = obj.CTCPTDesc                      //修改描述
				s bobj.CTCPTInternalType = obj.CTCPTInternalType      //修改类型
				s bobj.CTCPTDateFrom = obj.CTCPTDateFrom
				s bobj.CTCPTDateTo = obj.CTCPTDateTo
				s bobj.CTCPTRotaryFlag = obj.CTCPTRotaryFlag
				s bobj.CTCPTStudyFlag = obj.CTCPTStudyFlag
			
			}	
			s obj.CTCPTCode = eobj.CTCPTCode                      //修改代码
			s obj.CTCPTDesc = eobj.CTCPTDesc                      //修改描述
			s obj.CTCPTInternalType = eobj.CTCPTInternalType      //修改类型
			i eobj.CTCPTDateFrom'=""
			{
				s obj.CTCPTDateFrom = eobj.CTCPTDateFrom  //修改开始日期
			}
			else
			{
				s obj.CTCPTDateFrom = ""
			}
			i eobj.CTCPTDateTo'=""
			{
				s obj.CTCPTDateTo = eobj.CTCPTDateTo      //修改结束日期     
			}
			else
			{
				s obj.CTCPTDateTo = ""
			}	
			i eobj.CTCPTRotaryFlag="Y"
			{
				s obj.CTCPTRotaryFlag ="Y"
			}
			else
			{
				s obj.CTCPTRotaryFlag = "N"
			}
			i eobj.CTCPTStudyFlag="Y"
			{
				s obj.CTCPTStudyFlag ="Y"
			}
			else
			{
				s obj.CTCPTStudyFlag = "N"
			}
			Ts
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc){
				Tc
				s id = obj.%Id()
				d:eobj.CTCPTRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_CarPrvTp","User.CTCarPrvTp","医护人员类型",eobj.CTCPTRowId,eobj.CTCPTDesc,"U",eobj,bobj)
				d:eobj.CTCPTRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_CarPrvTp","User.CTCarPrvTp","医护人员类型",id,eobj.CTCPTDesc,"A",eobj)
				s result = "{success:'true',id:'"_id_"'}"         //返回RowId
			}else{
				Trollback
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
				s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医护人员类型","web.DHCBL.CT.CTCarPrvTp","SaveEntity",eobj)
				s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)  
			}
   		
		}
		else
		{
			s result = "{success:'false',errorinfo:'对象不存在！'}"
		}
	}	
	q result
EEROE
	s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医护人员类型","web.DHCBL.CT.CTCarPrvTp","SaveEntity",eobj)
 	s ^ERRORLOGINFO(logid)=$ze
	q "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator:蔡昊哲
/// CreatDate:2013-8-30
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="0^未被引用可删除！"
    
    i $d(^CTPCP(0,"CareProvType",+id)) s return="1^在医护人员里被引用,不能删除！"   ; CTCareProv	
    		
	q return
}

/// Creator：蔡昊哲
/// CreatDate: 2012-7-18
/// Description：根据ID删除医护人员类型的内容
/// Table：User.CTCarPrvTp
/// Input：Id(CTCarPrvTp的rowid)
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id) As %String
{
	s result=""
	
	s re=##class(web.DHCBL.CT.CTCarPrvTp).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag'=0){
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}
	else
	{
		Tstart
		s eobj = ##class(web.Entity.CT.CTCarPrvTp).%New()
		s pobj = ##class(User.CTCarPrvTp).%OpenId(id)
		s eobj.CTCPTRowId = id
		s eobj.CTCPTCode = pobj.CTCPTCode                      //修改代码
		s eobj.CTCPTDesc = pobj.CTCPTDesc                      //修改描述
		s eobj.CTCPTInternalType = pobj.CTCPTInternalType      //修改类型
		s eobj.CTCPTRotaryFlag = pobj.CTCPTRotaryFlag
		s eobj.CTCPTStudyFlag = pobj.CTCPTStudyFlag
			
		s sc=##class(User.CTCarPrvTp).%DeleteId(id)
		IF $$$ISOK(sc){
			Tc
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_CarPrvTp","User.CTCarPrvTp","医护人员类型",id,eobj.CTCPTDesc,"D",eobj)
			s result="{success:'true',info:'删除成功！'}"
		}
		else{
			Trollback
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医护人员类型","web.DHCBL.CT.CTCarPrvTp","DeleteData",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	q result
}

/// 用作调试增改功能
ClassMethod SaveTest()
{
	; d ##class(web.DHCBL.CT.CTCarPrvTp).SaveTest()
	s obj = ##class(web.Entity.CT.CTCarPrvTp).%New()
	d ..SaveEntity(obj)
}

/// 登录人员为医生时,医护人员类型默认PRACTICE,且不得修改
/// w ##class(web.DHCBL.CT.CTCarPrvTp).GetPRACTICE(1)
ClassMethod GetPRACTICE(userid) As %String
{
	s CarPrvTpStr="",doctorFlag="",CarPrvTpDR=""
	s SSUSRCareProvDR=$p($g(^SSU("SSUSR",userid)),"^",14) 
	s:SSUSRCareProvDR'="" CTPCPCarPrvTpDR=$p($g(^CTPCP(SSUSRCareProvDR,1)),"^",4)    //医护人员类型ID
	s:SSUSRCareProvDR="" CTPCPCarPrvTpDR=""
	s CTCPTInternalType=""
	s:CTPCPCarPrvTpDR'="" CTCPTInternalType=$p($g(^CT("CPT",CTPCPCarPrvTpDR)),"^",4)
	if (CTCPTInternalType="DOCTOR"){
		s doctorFlag="Y"
		s CarPrvTpDR=$o(^CT("CPT",0,"Code","PRACTICE",0))
	}
	s CarPrvTpStr=doctorFlag_"^"_CarPrvTpDR
	q CarPrvTpStr
}

/// Creator:高姗姗
/// CreatDate:2017-8-7
/// Description:双击修改时,从后台取数据
/// Table:User.CTCarPrvTp
/// Input:id
/// Return:Json格式的字符串
/// Other:w ##class(web.DHCBL.CT.CTCarPrvTp).OpenData("53")
ClassMethod OpenData(id As %String) As %String
{
	s str=""
	s pobj = ##class(User.CTCarPrvTp).%OpenId(id)
	s eobj = ##class(web.Entity.CT.CTCarPrvTp).%New()
	s eobj.CTCPTRowId = id
	s eobj.CTCPTCode = pobj.CTCPTCode
	s eobj.CTCPTDesc = pobj.CTCPTDesc
	s eobj.CTCPTInternalType = pobj.CTCPTInternalType
	;s:pobj.CTCPTDateFrom'="" eobj.CTCPTDateFrom=$zd(pobj.CTCPTDateFrom,1)
	;s:pobj.CTCPTDateTo'="" eobj.CTCPTDateTo=$zd(pobj.CTCPTDateTo,1)
	s:pobj.CTCPTDateFrom'="" eobj.CTCPTDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.CTCPTDateFrom)
	s:pobj.CTCPTDateTo'="" eobj.CTCPTDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.CTCPTDateTo)
	s:pobj.CTCPTRotaryFlag="Y" eobj.CTCPTRotaryFlag="true"
	s:pobj.CTCPTStudyFlag="Y" eobj.CTCPTStudyFlag="true"
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

}
