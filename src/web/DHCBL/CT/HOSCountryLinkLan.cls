/// 名称:国家关联语言
/// 表名：CT_BDP_CT.HOS_CountryLinkLan
/// 描述:包含增删改查功能
/// 编写者：鲁俊文
/// 编写日期: 2022-10-11
Class web.DHCBL.CT.HOSCountryLinkLan Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator:鲁俊文
/// CreatDate:2022-10-11
/// Description：国家关联语言
/// Table：CT_BDP_CT.HOS_CountryLinkLan
/// Input：id cllcoudr(国家dr) clllandr(语言dr), cllremark (备注) 
/// Return:  ID:RowId CLLCountryCode:国家,CLLLANCode:语言,CLLActivity:是否激活,CLLStartDate:开始日期,CLLEndDate:结束日期,CLLMark:备注
/// Debug: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSCountryLinkLan","GetList","","",“”,“”)
Query GetList(id As %String, cllcoudr As %String, clllandr As %String, cllremark As %String) As %Query(ROWSPEC = "ID:%String,CLLCountryCode:%String,CLLLANCode:%String,CLLActivity:%String,CLLIsDefault:%String,CLLStartDate:%Date,CLLEndDate:%Date,CLLSeqNo:%String,CLLPYCode:%String,CLLWBCode:%String,CLLMark:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, id As %String, cllcoudr As %String, clllandr As %String, cllremark As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1  
	if (id'="") //根据rowid返回该条记录
	{
    	s ID=id        													///RowID
	    s CLLCountryCode=$lg($g(^CT.BDP.CT.HOSCountryLinkLanD(ID)),2)  ///国家指针
	    
	    s:CLLCountryCode'="" CLLCountryCode=$p($g(^CT("COU",CLLCountryCode)),"^",2) ///国家描述
	    s CLLLANCode=$lg($g(^CT.BDP.CT.HOSCountryLinkLanD(ID)),3) ///语言指针 
	    s:CLLLANCode'="" CLLLANCode=$p($g(^SS("LAN",CLLLANCode)),"^",2) ///语言描述   
	    s CLLActivity=$lg($g(^CT.BDP.CT.HOSCountryLinkLanD(ID)),4) ///是否有效	    
	    s CLLIsDefault=$lg($g(^CT.BDP.CT.HOSCountryLinkLanD(ID)),17) ///是否默认 
	    s CLLStartDate=$lg($g(^CT.BDP.CT.HOSCountryLinkLanD(ID)),5) ///开始日期 
	    s CLLEndDate=$lg($g(^CT.BDP.CT.HOSCountryLinkLanD(ID)),6) ///结束日期
	    s:CLLStartDate'="" CLLStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(CLLStartDate) ///转日期格式
	    s:CLLEndDate'="" CLLEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(CLLEndDate)	///转日期格式

	    s CLLSeqNo=$lg($g(^CT.BDP.CT.HOSCountryLinkLanD(ID)),10) ///系统排序号	    

	    s CLLPYCode=$lg($g(^CT.BDP.CT.HOSCountryLinkLanD(ID)),14) ///拼音码
	    s CLLWBCode=$lg($g(^CT.BDP.CT.HOSCountryLinkLanD(ID)),15) ///五笔码
	    s CLLMark=$lg($g(^CT.BDP.CT.HOSCountryLinkLanD(ID)),16) //////备注 
	    d OutputRow
	}
	else
	{
			
	    	s ID=0
    		for 
			{
				s ID=$o(^CT.BDP.CT.HOSCountryLinkLanD(ID)) q:ID=""  ///RowID
				s CLLCountryCode=$lg($g(^CT.BDP.CT.HOSCountryLinkLanD(ID)),2)  ///国家指针
				continue:(cllcoudr'="")&&(cllcoudr'=CLLCountryCode)
				s:CLLCountryCode'="" CLLCountryCode=$p($g(^CT("COU",CLLCountryCode)),"^",2) ///国家
				s CLLLANCode=$lg($g(^CT.BDP.CT.HOSCountryLinkLanD(ID)),3) ///语言指针
				continue:(clllandr'="")&&(clllandr'=CLLLANCode)
				s:CLLLANCode'="" CLLLANCode=$p($g(^SS("LAN",CLLLANCode)),"^",2) ///语言 
				s CLLActivity=$lg($g(^CT.BDP.CT.HOSCountryLinkLanD(ID)),4) ///是否有效
				s CLLIsDefault=$lg($g(^CT.BDP.CT.HOSCountryLinkLanD(ID)),17) ///是否默认   
				s CLLStartDate=$lg($g(^CT.BDP.CT.HOSCountryLinkLanD(ID)),5) ///开始日期 
				s CLLEndDate=$lg($g(^CT.BDP.CT.HOSCountryLinkLanD(ID)),6) ///结束日期
				s:CLLStartDate'="" CLLStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(CLLStartDate) ///转日期格式
				s:CLLEndDate'="" CLLEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(CLLEndDate)	///转日期格式

				s CLLSeqNo=$lg($g(^CT.BDP.CT.HOSCountryLinkLanD(ID)),10) ///系统排序号	    
				s CLLPYCode=$lg($g(^CT.BDP.CT.HOSCountryLinkLanD(ID)),14) ///拼音码
				s CLLWBCode=$lg($g(^CT.BDP.CT.HOSCountryLinkLanD(ID)),15) ///五笔码
				s CLLMark=$lg($g(^CT.BDP.CT.HOSCountryLinkLanD(ID)),16) ///备注    	 	
		    	d OutputRow
			}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(ID,CLLCountryCode,CLLLANCode,CLLActivity,CLLIsDefault,CLLStartDate,CLLEndDate,CLLSeqNo,CLLPYCode,CLLWBCode,CLLMark)
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

/// Creator:鲁俊文
/// CreatDate:2022-11-18
/// Description:为combobox查询取数据
/// Table：Table：CT_BDP_CT.HOS_CountryLinkLan
/// input id 
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSCountryLinkLan","GetDataForCmb1","")
Query GetDataForCmb1(id As %String) As %Query(ROWSPEC = "ID:%String,CLLCountryCode:%String,CLLLANCode:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, id As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1  
	if (id'="") //根据rowid返回该条记录
	{
		
    	s ID=id        													///RowID
	    s CLLCountryCode=$lg($g(^CT.BDP.CT.HOSCountryLinkLanD(ID)),2)  ///国家指针
	    
	    s:CLLCountryCode'="" CLLCountryCode=$p($g(^CT("COU",CLLCountryCode)),"^",2) ///国家描述
	    s CLLLANCode=$lg($g(^CT.BDP.CT.HOSCountryLinkLanD(ID)),3) ///语言指针 
	    s:CLLLANCode'="" CLLLANCode=$p($g(^SS("LAN",CLLLANCode)),"^",2) ///语言描述   
	    s CLLActivity=$lg($g(^CT.BDP.CT.HOSCountryLinkLanD(ID)),4) ///是否有效

	    s CLLStartDate=$lg($g(^CT.BDP.CT.HOSCountryLinkLanD(ID)),5) ///开始日期 
	    s CLLEndDate=$lg($g(^CT.BDP.CT.HOSCountryLinkLanD(ID)),6) ///结束日期
	    d OutputRowCmb
	}
	else
	{
    	s ID=0
		for 
		{
			s ID=$o(^CT.BDP.CT.HOSCountryLinkLanD(ID)) q:ID=""  ///RowID
			s CLLCountryCode=$lg($g(^CT.BDP.CT.HOSCountryLinkLanD(ID)),2)  ///国家指针
			s:CLLCountryCode'="" CLLCountryCode=$p($g(^CT("COU",CLLCountryCode)),"^",2) ///国家
			s CLLLANCode=$lg($g(^CT.BDP.CT.HOSCountryLinkLanD(ID)),3) ///语言指针
			s:CLLLANCode'="" CLLLANCode=$p($g(^SS("LAN",CLLLANCode)),"^",2) ///语言 
			s CLLActivity=$lg($g(^CT.BDP.CT.HOSCountryLinkLanD(ID)),4) ///是否有效
			continue:CLLActivity="N"  
			s CLLStartDate=$lg($g(^CT.BDP.CT.HOSCountryLinkLanD(ID)),5) ///开始日期 
			continue:(CLLStartDate'="")&&(CLLStartDate>+$h)
			s CLLEndDate=$lg($g(^CT.BDP.CT.HOSCountryLinkLanD(ID)),6) ///结束日期
			continue:(CLLEndDate'="")&&(CLLEndDate<+$h)
	        d OutputRowCmb 
		}
}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
	set Data=$lb(ID,CLLCountryCode,CLLLANCode)
	set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
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

/// Creator:鲁俊文
/// CreatDate:  2022-10-11
/// Description：修改时打开的数据-EXTJS
/// Input：     id 
/// Return:Json格式的字符串
/// Other: w ##class(web.DHCBL.CT.HOSCountryLinkLan).OpenDataExt("1")
ClassMethod OpenDataExt(id As %String) As %String
{
	s str=""    
	s eobj = ##class(web.Entity.CT.HOSCountryLinkLan).%New()
	s obj = ##class(CT.BDP.CT.HOSCountryLinkLan).%OpenId(id)
	s eobj.ID=id ///Id
	if $IsObject(obj.CLLCountryCode)
	{
		s eobj.CLLCountryCode = obj.CLLCountryCode.%Id()   //国家
	}
	if $IsObject(obj.CLLLANCode)
	{
		s eobj.CLLLANCode = obj.CLLLANCode.%Id()    //语言
	} 
	s eobj.CLLActivity=obj.CLLActivity ///是否有效
	s:eobj.CLLActivity="Y" eobj.CLLActivity="true"

	s eobj.CLLIsDefault=obj.CLLIsDefault ///是否默认
	s:eobj.CLLIsDefault="Y" eobj.CLLIsDefault="true"
	
	s:obj.CLLStartDate'="" eobj.CLLStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.CLLStartDate) ///开始日期 
	s:obj.CLLEndDate'="" eobj.CLLEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.CLLEndDate) ///结束日期
	s eobj.CLLSeqNo=obj.CLLSeqNo ///系统排序号
	s eobj.CLLPYCode=obj.CLLPYCode  ///拼音码
	s eobj.CLLWBCode=obj.CLLWBCode  ///五笔码
	s eobj.CLLMark=obj.CLLMark ///备注
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"     
	d eobj.%Close()
	d obj.%Close()
	q str
}

/// Creator:鲁俊文
/// CreatDate:  2022-10-11
/// Description：修改时打开的数据-HISUI
/// Input：     id 
/// Return:Json格式的字符串
/// Other: w ##class(web.DHCBL.CT.HOSCountryLinkLan).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	s str=""    
	s eobj = ##class(web.Entity.CT.HOSCountryLinkLan).%New()
	s obj = ##class(CT.BDP.CT.HOSCountryLinkLan).%OpenId(id)
	s eobj.ID=id ///Id 
	if $IsObject(obj.CLLCountryCode)
	{
		s eobj.CLLCountryCode = obj.CLLCountryCode.%Id()   //国家
	}
	if $IsObject(obj.CLLLANCode)
	{
		s eobj.CLLLANCode = obj.CLLLANCode.%Id()    //语言
	} 
	s eobj.CLLActivity=obj.CLLActivity ///是否有效
	s:eobj.CLLActivity="" eobj.CLLActivity="Y"
	s:eobj.CLLActivity="Y" eobj.CLLActivity="true"
	
	s eobj.CLLIsDefault=obj.CLLIsDefault ///是否默认
	s:eobj.CLLIsDefault="" eobj.CLLIsDefault="Y"
	s:eobj.CLLIsDefault="Y" eobj.CLLIsDefault="true"	
		
	s:obj.CLLStartDate'="" eobj.CLLStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.CLLStartDate) ///开始日期 
	s:obj.CLLEndDate'="" eobj.CLLEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.CLLEndDate) ///结束日期
	s eobj.CLLSeqNo=obj.CLLSeqNo ///系统排序号
	s eobj.CLLPYCode=obj.CLLPYCode ///拼音码
	s eobj.CLLWBCode=obj.CLLWBCode ///五笔码
	s eobj.CLLMark=obj.CLLMark ///备注
	s str = eobj.JsonS()
	d eobj.%Close()
	d obj.%Close()
	q str
}

/// Creator：鲁俊文
/// CreatDate: 2022-10-11
/// Description：重复校验
/// Table：CT_BDP_CT.HOS_CountryLinkLan
/// Input：id country(国家dr) lan(语言dr)
/// Others：w ##class(web.DHCBL.CT.HOSCountryLinkLan).FormValidate(“”,1,20)
ClassMethod FormValidate(id As %String, country As %String, lan As %String) As %String
{
	s flag=0
	if (country'="")&&(lan'="")
	{
		s ID=$o(^CT.BDP.CT.HOSCountryLinkLanI("IndexCountryLAN",country,lan,0)) 	
		if (ID'="")&&(id'=ID)
		{
			s flag=1
		}
		
	}
	q flag
}

/// Creator：鲁俊文
/// CreatDate: 2022-10-11
/// Description：保存国家关联语言
/// Table：CT_BDP_CT.HOS_CountryLinkLan
/// Others：w ##class(web.Entity.CT.HOSCountryLinkLan).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.HOSCountryLinkLan) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.CLLStartDate'="" eobj.CLLStartDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CLLStartDate) ///转日期格式
    	s:eobj.CLLEndDate'="" eobj.CLLEndDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CLLEndDate)	///转日期格式
		s:eobj.CLLStartDate="" eobj.CLLStartDate=+$h
		s:eobj.CLLActivity="" eobj.CLLActivity="N"
		s:eobj.CLLIsDefault="" eobj.CLLIsDefault="N"
		s eobj.CLLLastUpdateDate=$p($h,",",1) ///系统最后更新日期
		s eobj.CLLLastUpdateTime=$p($h,",",2) ///系统最后更新时间
		s flag=..FormValidate(eobj.ID,eobj.CLLCountryCode,eobj.CLLLANCode)  //调用重复验证
		if $d(%session)
		{
			s USERID=$g(%session.Data("LOGON.USERID")) 
			if (eobj.CLLCreateUser="") s eobj.CLLCreateUser=USERID   ///系统创建人
			if (eobj.CLLLastUpdateUser="") s eobj.CLLLastUpdateUser=USERID  ///系统最新更新人
		}

		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.ID="")
		{
			s obj=##class(CT.BDP.CT.HOSCountryLinkLan).%New()
			//s obj.CLLCreateDate=+$H           ///系统创建日期
			//s obj.CLLCreateTime=$p($h,",",2)  ///系统创建时间
			d obj.CLLCreateUserSetObjectId(eobj.CLLLastUpdateUser)  ///系统创建人
		}
		else
		{
			s obj=##class(CT.BDP.CT.HOSCountryLinkLan).%OpenId(eobj.ID)
			s bobj=##class(web.Entity.CT.HOSCountryLinkLan).%New()
			s bobj.ID=eobj.ID    ////RowId
			if $IsObject(obj.CLLCountryCode){
				s bobj.CLLCountryCode = obj.CLLCountryCode.%Id()   //国家
			}
			if $IsObject(obj.CLLLANCode){
				s bobj.CLLLANCode = obj.CLLLANCode.%Id()    //语言
			}
			s bobj.CLLActivity=obj.CLLActivity ///是否有效	
			s bobj.CLLIsDefault=obj.CLLIsDefault ///是否默认	
			s bobj.CLLStartDate=obj.CLLStartDate ///开始日期
			s bobj.CLLEndDate=obj.CLLEndDate ///结束日期
			s bobj.CLLCreateDate=obj.CLLCreateDate ///系统创建日期
			s bobj.CLLCreateTime=obj.CLLCreateTime ///系统创建时间
			if $IsObject(obj.CLLCreateUser)
			{   
				s bobj.CLLCreateUser = obj.CLLCreateUser.%Id()   ///系统创建人
			}
			s bobj.CLLSeqNo=obj.CLLSeqNo ///系统排序号
			s bobj.CLLLastUpdateDate=obj.CLLLastUpdateDate ///系统最后更新日期
			s bobj.CLLLastUpdateTime=obj.CLLLastUpdateTime ///系统最后更新时间
			if $IsObject(obj.CLLLastUpdateUser)
			{   
				s bobj.CLLLastUpdateUser = obj.CLLLastUpdateUser.%Id()   ///系统最新更新人
			}
			s bobj.CLLPYCode=obj.CLLPYCode ///拼音码
			s bobj.CLLWBCode=obj.CLLWBCode ///五笔码
			s bobj.CLLMark=obj.CLLMark ///备注
		}
		d obj.CLLCountryCodeSetObjectId(eobj.CLLCountryCode) ///国家		
		d obj.CLLLANCodeSetObjectId(eobj.CLLLANCode) ///语言		

		s obj.CLLActivity=eobj.CLLActivity		  ///是否有效
		s obj.CLLIsDefault=eobj.CLLIsDefault     ///是否默认
		s obj.CLLStartDate= eobj.CLLStartDate     ///开始日期
	    s obj.CLLEndDate= eobj.CLLEndDate 		 ///结束日期

		
		s obj.CLLSeqNo=eobj.CLLSeqNo ///系统排序号
		s obj.CLLLastUpdateDate=$p($h,",",1) ///系统最后更新日期
		s obj.CLLLastUpdateTime=$p($h,",",2) ///系统最后更新时间
		d obj.CLLLastUpdateUserSetObjectId(eobj.CLLLastUpdateUser)  ///系统最新更新人
		s obj.CLLPYCode=eobj.CLLPYCode ///拼音码
		s obj.CLLWBCode=eobj.CLLWBCode ///五笔码		
		s obj.CLLMark=eobj.CLLMark ///备注
		TS
		s sc=obj.%Save()
		if (sc=1)
		{
			TC
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			// 国家关联语言默认数据需和国家的的语言字段保持一致
			if (eobj.CLLCountryCode'="")
			{
				if (eobj.CLLIsDefault="Y")
				{
					s CLLLANCode=0
					for
					{
						s CLLLANCode=$o(^CT.BDP.CT.HOSCountryLinkLanI("IndexCountryLAN",eobj.CLLCountryCode,CLLLANCode)) q:CLLLANCode=""
						continue:eobj.CLLLANCode=CLLLANCode
						
						s ID=$o(^CT.BDP.CT.HOSCountryLinkLanI("IndexCountryLAN",eobj.CLLCountryCode,CLLLANCode,0))					
						s CLLIsDefault=$lg($g(^CT.BDP.CT.HOSCountryLinkLanD(ID)),17)
						if (CLLIsDefault'="N")
						{
							s obj2=##class(CT.BDP.CT.HOSCountryLinkLan).%OpenId(ID)
							s obj2.CLLIsDefault=0
							s sc2=obj2.%Save()
							d obj2.%Close()
						}						
						
					}

					//判断国家关联语言默认数据是否和国家表一致，不一致则修改一致
					if (eobj.CLLLANCode'="")
					{
						s CTCOULanguageDR=$p($g(^SS("LAN",eobj.CLLCountryCode)),"^",2)	
						
						if (CTCOULanguageDR'=eobj.CLLLANCode)
						{
							
							s obj3=##class(User.CTCountry).%OpenId(eobj.CLLCountryCode)
							
							d obj3.CTCOULanguageDRSetObjectId(eobj.CLLLANCode)		//语言
							s sc3=obj3.%Save()
							d obj3.%Close()
						}
					}
					elseif (eobj.CLLIsDefault="N")&&(eobj.ID'="")&&(bobj.CLLIsDefault="Y")	//去掉默认勾选，需同步修改国家的语言字段
					{
						s obj4=##class(User.CTCountry).%OpenId(eobj.CLLCountryCode)
						s obj4.CTCOULanguageDR=""		//语言
						s sc4=obj4.%Save()
						d obj4.%Close()
					}										
					
					
					
					
				}
				
				
				
				
			}
			s:eobj.CLLLANCode'="" CLLLANCode=$p($g(^SS("LAN",eobj.CLLLANCode)),"^",2) ///语言描述 
						
			s Desc=$p($g(^CT("COU",eobj.CLLCountryCode)),"^",2)_"-"_$p($g(^SS("LAN",eobj.CLLLANCode)),"^",2) ///国家描述-语言描述   
			///保存日志
			d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_CountryLinkLan","CT.BDP.CT.HOSCountryLinkLan","国家关联语言",eobj.ID,Desc,"U",eobj,bobj) 
			d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_CountryLinkLan","CT.BDP.CT.HOSCountryLinkLan","国家关联语言",id,Desc,"A",eobj) 
		}
		else
		{
			TRO
			s result="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			//保存错误日志
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("国家关联语言","web.DHCBL.CT.HOSCountryLinkLan","SaveEntity",eobj) 
	        s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
}

/// Creator:鲁俊文
/// CreatDate:2022-10-12
/// Description：根据ID删除国家关联语言的内容
/// Table：CT.BDP.CT.HOSCountryLinkLan
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.HOSCountryLinkLan).DeleteData("3")
ClassMethod DeleteData(id As %String) As %String
{
	s result="" 
	s pobj = ##class(CT.BDP.CT.HOSCountryLinkLan).%OpenId(id)
	s eobj = ##class(web.Entity.CT.HOSCountryLinkLan).%New()
	s eobj.ID = id ///RowId
	if $IsObject(pobj.CLLCountryCode){
		s eobj.CLLCountryCode = pobj.CLLCountryCode.%Id()   //国家
	}
	if $IsObject(pobj.CLLLANCode){
		s eobj.CLLLANCode = pobj.CLLLANCode.%Id()    //语言
	}
	s eobj.CLLActivity=pobj.CLLActivity ///是否有效	
	s eobj.CLLIsDefault=pobj.CLLIsDefault ///是否默认
	s eobj.CLLStartDate=pobj.CLLStartDate ///开始日期
	s eobj.CLLEndDate=pobj.CLLEndDate ///结束日期
	s eobj.CLLCreateDate=pobj.CLLCreateDate ///系统创建日期
	s eobj.CLLCreateTime=pobj.CLLCreateTime ///系统创建时间
	if $IsObject(pobj.CLLCreateUser)
	{   
		s eobj.CLLCreateUser = pobj.CLLCreateUser.%Id()   ///系统创建人
	}
	s eobj.CLLSeqNo=pobj.CLLSeqNo ///系统排序号
	s eobj.CLLLastUpdateDate=pobj.CLLLastUpdateDate ///系统最后更新日期
	s eobj.CLLLastUpdateTime=pobj.CLLLastUpdateTime ///系统最后更新时间
	if $IsObject(pobj.CLLLastUpdateUser)
	{   
		s eobj.CLLLastUpdateUser = pobj.CLLLastUpdateUser.%Id()   ///系统最新更新人
	}
	s eobj.CLLPYCode=pobj.CLLPYCode ///拼音码
	s eobj.CLLWBCode=pobj.CLLWBCode ///五笔码
	s eobj.CLLMark=pobj.CLLMark ///备注
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(CT.BDP.CT.HOSCountryLinkLan).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tcommit
		s result = "{success:'true',info:'删除成功！'}"  
		//保存日志
		s Desc=$p($g(^CT("COU",eobj.CLLCountryCode)),"^",2)_"-"_$p($g(^SS("LAN",eobj.CLLLANCode)),"^",2) ///国家描述-语言描述   
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_CountryLinkLan","CT.BDP.CT.HOSCountryLinkLan","国家关联语言",id,Desc,"D",eobj)
		d eobj.%Close()
	}
	else 
	{
		Trollback
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		//保存错误日志
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("国家关联语言","web.DHCBL.CT.HOSCountryLinkLan","DeleteData",eobj)
		s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
	} 
	q result
}

}
