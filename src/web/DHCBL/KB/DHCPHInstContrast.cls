Class web.DHCBL.KB.DHCPHInstContrast Extends %RegisteredObject
{

/// Creator：高姗姗
/// CreatDate: 2014-11-6
/// Description：查询已对照用法表内容
/// Input：rowid, code, desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHInstContrast","GetList","","","","","")
Query GetList(id) As %Query(ROWSPEC = "PHICTRowId,PHICTInstCode,PHICTInstDesc,PHICTHisInstCode,PHICTHisInstDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, id) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (id'=""){
		s code=$p($g(^DHCPHEINSTR(id)),"^",1)
    	s desc=$p($g(^DHCPHEINSTR(id)),"^",2)
        
		s:code'="" code="<"_$ZCONVERT(code,"U")_">"
		s:desc'="" desc="<"_$ZCONVERT(desc,"U")_">"
		s PHICTRowId=0
		for  
		{	
			s PHICTRowId=$o(^DHCPHINSTCON(PHICTRowId)) q:PHICTRowId="" 

			s PHICTInstCode=$p($g(^DHCPHINSTCON(PHICTRowId)),"^",1)  //代码
			s PHICTInstCodeU="<"_$ZCONVERT(PHICTInstCode,"U")_">"
			s PHICTInstDesc=$p($g(^DHCPHINSTCON(PHICTRowId)),"^",2)  //描述
			s PHICTInstDescU="<"_$ZCONVERT(PHICTInstDesc,"U")_">"
			s PHICTHisInstCode=$p($g(^DHCPHINSTCON(PHICTRowId)),"^",3)  //his代码
			s PHICTHisInstDesc=$p($g(^DHCPHINSTCON(PHICTRowId)),"^",4)  //his描述
		
			i (PHICTInstCodeU[code)&(PHICTInstDescU[desc)   //条件
			{
				d OutputRow
			}		
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PHICTRowId,PHICTInstCode,PHICTInstDesc,PHICTHisInstCode,PHICTHisInstDesc)
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

/// Description：获取已对照用法中的hiscode
/// Other: w ##class(web.DHCBL.KB.DHCPHInstContrast).GetHisCode()
ClassMethod GetHisCode() As %String
{
 s str=""
	s PHICTRowId=0
	for
	{
		s PHICTRowId=$o(^DHCPHINSTCON(PHICTRowId)) q:PHICTRowId=""
		s PHICTHisCode=$p(^DHCPHINSTCON(PHICTRowId),"^",3) //HisCode
		s str="<"_PHICTHisCode_">^"_str
	}
 q str
}

/// Creator:高姗姗
/// CreatDate: 2014-11-4
/// Description：对照
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// d ##class(web.DHCBL.KB.DHCPHInstContrast).SaveData("8^9")
ClassMethod SaveData(ids As %String) As %String
{
	s result = ""
	s rowid=$p(ids,"^",1) //rowid
    s hisrowid=$p(ids,"^",2) //hisrowid
    s code=$p($g(^DHCPHEINSTR(rowid)),"^",1)
	s desc=$p($g(^DHCPHEINSTR(rowid)),"^",2)
	s hiscode=$p($g(^PHCIN(hisrowid)),"^",1)
	s hisdesc=$p($g(^PHCIN(hisrowid)),"^",2)
	
	
	If hiscode'="" s sshiscode=$o(^DHCPHINSTCON(0,"HisCode",hiscode,""))
	//If code'="" s sscode=$o(^DHCPHINSTCON(0,"Code",code,hiscode,""))
	s Exdesc=""
	If (sshiscode'="") 
	{
		s Exdesc=$p($g(^DHCPHINSTCON(sshiscode)),"^",2)  //描述
	 	Quit "{success:'false',info:'该记录已与"_Exdesc_"对照, 不能重复对照!'}"	
	}	
	/*s codeStr = ##class(web.DHCBL.KB.DHCPHInstContrast).GetHisCode()
	s hcode = "<"_hiscode_">"
	if (codeStr[hcode) Quit "{success:'false',info:'该记录已对照, 请删除后再对照!'}"*/
	
	s obj=##class(User.DHCPHInstContrast).%New()
	s obj.PHICTInstCode = code
	s obj.PHICTInstDesc = desc
	s obj.PHICTHisInstCode = hiscode
	s obj.PHICTHisInstDesc = hisdesc
	s logJson="{PHICTInstCode:"_$c(34)_code_$c(34)_",PHICTInstDesc:"_$c(34)_desc_$c(34)_",PHICTHisInstCode:"_$c(34)_hiscode_$c(34)_",PHICTHisInstDesc:"_$c(34)_hisdesc_$c(34)_"}"
	Ts
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc){	
		Tc		
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_PHInstContrast","User.DHCPHInstContrast","用法对照",id,desc,"A",logJson)
	}else{
		Trollback
		s result = "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"   //返回错误信息
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("用法对照","web.DHCBL.KB.DHCPHInstContrast","SaveData",logJson)
		s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
	}
	q result
}

/// Creator:高姗姗
/// CreatDate:2014-11-5
/// Description:根据id删除
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
	s return="",myInfo=""

		Tstart
		s eobj = ##class(web.Entity.KB.DHCPHInstContrast).%New()
		s pobj = ##class(User.DHCPHInstContrast).%OpenId(id)
		s eobj.PHICTRowId = id
		s eobj.PHICTInstCode = pobj.PHICTInstCode
		s eobj.PHICTInstDesc = pobj.PHICTInstDesc
		s eobj.PHICTHisInstCode = pobj.PHICTHisInstCode
		s eobj.PHICTHisInstDesc = pobj.PHICTHisInstDesc
	
		s sc=##class(User.DHCPHInstContrast).%DeleteId(id)
		if $$$ISOK(sc){
			Tcommit
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstContrast","User.DHCPHInstContrast","用法对照",id,eobj.PHICTInstDesc,"D",eobj)
		}
		else{
			Trollback
			s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("用法对照","web.DHCBL.KB.DHCPHInstContrast","DeleteData",eobj)
			s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
		}
	q result
}

/// Creator：丁亚男 		
/// CreatDate: 2018-02-09
/// Description：用法对照查询 药品用法 
/// Table：User.PHCInstruc
/// Input：rowid,code,desc1,desc2
/// Output：PHCINRowId,PHCINCode,PHCINDesc1,PHCINDesc2,PHCINActiveFlag,PHCINClinicType
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHInstContrast","DataForContrast","","","","")
Query GetDataForContrast(rowid As %String, code As %String, desc1 As %String, desc2 As %String) As %Query(ROWSPEC = "PHCINRowId:%String,PHCINCode:%String,PHCINDesc1:%String,PHCINDesc2:%String")
{
}

ClassMethod GetDataForContrastExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc1 As %String, desc2 As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="")
	{
		s PHCINRowId=rowid
		
		s PHCINCode= $p($g(^PHCIN(PHCINRowId)),"^",1)
		s PHCINDesc1 = $p($g(^PHCIN(PHCINRowId)),"^",2)
		s PHCINDesc2 = $p($g(^PHCIN(PHCINRowId)),"^",3)
		s PHCINActiveFlag = $p($g(^PHCIN(PHCINRowId)),"^",4)         ;是否激活 20170612
		s:PHCINActiveFlag="" PHCINActiveFlag="Y"                     ;激活标志为空时默认为激活
		
		/*s PHCINClinicType = $p($g(^PHCIN(PHCINRowId)),"^",5)         ;就诊类型
		//就诊类型 (门诊,急诊,住院,体检,新生儿) 20170612
		if PHCINClinicType'=""
		{
			s PHCINClinicTypeDesc=""
			if PHCINClinicType["O"
			{
				s PHCINClinicTypeDesc="门诊"
			}
			else
			{
				s PHCINClinicTypeDesc=""
			}
			if PHCINClinicType["E"
			{
				if PHCINClinicTypeDesc=""
				{
					s PHCINClinicTypeDesc="急诊"
				}
				else
				{
					s PHCINClinicTypeDesc=PHCINClinicTypeDesc_"，"_"急诊"
					
				}
			}
			
			if PHCINClinicType["I"
			{
				if PHCINClinicTypeDesc=""
				{
					s PHCINClinicTypeDesc="住院"
				}
				else
				{
					s PHCINClinicTypeDesc=PHCINClinicTypeDesc_"，"_"住院"
					
				}
			}
			
			if PHCINClinicType["H"
			{
				if PHCINClinicTypeDesc=""
				{
					s PHCINClinicTypeDesc="体检"
				}
				else
				{
					s PHCINClinicTypeDesc=PHCINClinicTypeDesc_"，"_"体检"
					
				}
			}
			if PHCINClinicType["N"
			{
				if PHCINClinicTypeDesc=""
				{
					s PHCINClinicTypeDesc="新生儿"
				}
				else
				{
					s PHCINClinicTypeDesc=PHCINClinicTypeDesc_"，"_"新生儿"
					
				}
			}
			s PHCINClinicType=PHCINClinicTypeDesc
		}
		else
		{
			s PHCINClinicType="门诊，急诊，住院，体检，新生儿"
		}
		s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc="" 
		s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PHC_Instruc",PHCINRowId)
		s BDPInternalCode =$p($g(resultStr),"^",1)
		s BDPInternalDesc = $p($g(resultStr),"^",2)
		s BDPHospNationalCode=$p($g(resultStr),"^",3)  
		s BDPHospNationalDesc = $p($g(resultStr),"^",4)*/
		if (PHCINActiveFlag'="N")
		{
			d OutputRow1
		}
		
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc1'="" desc1=$ZCONVERT(desc1,"U")
		s:desc2'="" desc2=$ZCONVERT(desc2,"U")
		s AuStr=##class(web.DHCBL.Authorize.PHCInstruc).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s PHCINRowId=0
		for
		{
			s PHCINRowId=$o(^PHCIN(PHCINRowId)) q:PHCINRowId=""
			s strRowId="{ID:"_PHCINRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s PHCINCode=$p($g(^PHCIN(PHCINRowId)),"^",1)
				s PHCINDesc1 = $p($g(^PHCIN(PHCINRowId)),"^",2)
				s PHCINDesc2 = $p($g(^PHCIN(PHCINRowId)),"^",3)
				s PHCINActiveFlag = $p($g(^PHCIN(PHCINRowId)),"^",4)       ;是否激活 20170612
				s:PHCINActiveFlag="" PHCINActiveFlag="Y"                   ;激活标志为空时默认为激活
				/*s PHCINClinicType = $p($g(^PHCIN(PHCINRowId)),"^",5)       ;就诊类型
				
				//就诊类型 (门诊,急诊,住院,体检,新生儿) 20170612
				if PHCINClinicType'=""
				{
					s PHCINClinicTypeDesc=""
					if PHCINClinicType["O"
					{
						s PHCINClinicTypeDesc="门诊"
					}
					else
					{
						s PHCINClinicTypeDesc=""
					}
					if PHCINClinicType["E"
					{
						if PHCINClinicTypeDesc=""
						{
							s PHCINClinicTypeDesc="急诊"
						}
						else
						{
							s PHCINClinicTypeDesc=PHCINClinicTypeDesc_"，"_"急诊"
					
						}
					}
			
					if PHCINClinicType["I"
					{
						if PHCINClinicTypeDesc=""
						{
							s PHCINClinicTypeDesc="住院"
						}
						else
						{
							s PHCINClinicTypeDesc=PHCINClinicTypeDesc_"，"_"住院"
					
						}
					}
			
					if PHCINClinicType["H"
					{
						if PHCINClinicTypeDesc=""
						{
							s PHCINClinicTypeDesc="体检"
						}
						else
						{
							s PHCINClinicTypeDesc=PHCINClinicTypeDesc_"，"_"体检"
					
						}
					}
					if PHCINClinicType["N"
					{
						if PHCINClinicTypeDesc=""
						{
							s PHCINClinicTypeDesc="新生儿"
						}
						else
						{
							s PHCINClinicTypeDesc=PHCINClinicTypeDesc_"，"_"新生儿"
					
						}
					}
					s PHCINClinicType=PHCINClinicTypeDesc
					
				}
				else
				{
					s PHCINClinicType="门诊，急诊，住院，体检，新生儿"
				}
				s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc="" 
				s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PHC_Instruc",PHCINRowId)
				s BDPInternalCode =$p($g(resultStr),"^",1)
				s BDPInternalDesc = $p($g(resultStr),"^",2)
				s BDPHospNationalCode=$p($g(resultStr),"^",3)  
				s BDPHospNationalDesc = $p($g(resultStr),"^",4)*/
				
				if (desc1'="")           
				{
					;需要对描述或者别名进行检索      
					s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PHC_Instruc",PHCINRowId,PHCINDesc1,desc1)
				}
				else
				{
					s AliasFlag=1
				}
				s PINYIN2=""
				s:desc2'="" PINYIN2= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(PHCINDesc2)
				i ($ZCONVERT(PHCINCode,"U")[code)&(AliasFlag=1)&(($ZCONVERT(PHCINDesc2,"U")[desc2)||((PINYIN2[desc2)))&(PHCINActiveFlag'="N")
				{
					d OutputRow1
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
    set Data=$lb(PHCINRowId,PHCINCode,PHCINDesc1,PHCINDesc2)
    //,PHCINActiveFlag,PHCINClinicType,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForContrastClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForContrastExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDataForContrastFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForContrastExecute ]
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

/// Creator:xuwenhu
/// CreatDate: 2021-05-24
/// Description：自动对照
/// Return：匹配数据的数目
/// w ##class(web.DHCBL.KB.DHCPHInstContrast).AutoContrastData()
ClassMethod AutoContrastData() As %String
{
	s count=0
	//遍历用法字典表
	s PHInstRowId=0
    for {
        s PHInstRowId=$o(^DHCPHEINSTR(PHInstRowId)) q:PHInstRowId=""
        s PHInstCode=$p($g(^DHCPHEINSTR(PHInstRowId)),"^",1)
        s PHInstDesc=$p($g(^DHCPHEINSTR(PHInstRowId)),"^",2)
        s PHInstAcitveFlag=$p($g(^DHCPHEINSTR(PHInstRowId)),"^",3)
        s PHInstSysFlag=$p($g(^DHCPHEINSTR(PHInstRowId)),"^",4)
        continue:PHInstAcitveFlag="N" 
        s RowId=0,Code=""
        for
        {
			s RowId=$o(^PHCIN(0,"Desc1",$$ALPHAUP^SSUTIL4(PHInstDesc),RowId)) q:RowId=""
			s Code=$p($g(^PHCIN(RowId)),"^",1) 
        }
       	//保存对照
	 	if (Code'="")
	 	{
			s sshiscode=$o(^DHCPHINSTCON(0,"HisCode",Code,""))
			s Exdesc=""
			If (sshiscode="") 
			{
				
				s obj=##class(User.DHCPHInstContrast).%New()
				s obj.PHICTInstCode = PHInstCode
				s obj.PHICTInstDesc = PHInstDesc
				s obj.PHICTHisInstCode = Code
				s obj.PHICTHisInstDesc = PHInstDesc
				s logJson="{PHICTInstCode:"_$c(34)_PHInstCode_$c(34)_",PHICTInstDesc:"_$c(34)_PHInstDesc_$c(34)_",PHICTHisInstCode:"_$c(34)_Code_$c(34)_",PHICTHisInstDesc:"_$c(34)_PHInstDesc_$c(34)_"}"
				Ts
				s sc=obj.%Save()
				d obj.%Close()
				If $$$ISOK(sc){	
					Tc		
					s id = obj.%Id()
					s count=count+1
					d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_PHInstContrast","User.DHCPHInstContrast","用法对照",id,PHInstDesc,"A",logJson)
				}else{
					Trollback
					s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("用法对照","web.DHCBL.KB.DHCPHInstContrast","SaveData",logJson)
					s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				}
				
			 }
	 	} 
    }
 	
 	s result = "{success:'true',count:'"_count_"'}" //返回RowId
 	q result
}

}
