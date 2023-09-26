/// Creator:高姗姗
/// CreatDate:2020-02-11
/// Description：结构化手术
/// Table：User.MKBOperationResult
Class web.DHCBL.MKB.MKBStructOperation Extends %RegisteredObject
{

/// Creator:高姗姗
/// CreatDate:2020-02-13
/// Description：勾选值对比已维护值，判断是否全部包含
/// Input: SDSValue后台原有维护值，checkedVal前台勾选属性值
/// return:全部包含返回Y，否则返回N
/// Other:w ##class(web.DHCBL.MKB.MKBStructOperation).GetAllExistFlag("8847434:1864881,8851328:S1440290*S1440291*S1440292,8869213:S1438809","")
ClassMethod GetAllExistFlag(SDSValue As %String, checkedVal As %String) As %String
{
	s result=""
	//原有维护值放入临时global
	k ^TMPMKBOPSRES("OperationResult")
	s len=$Length(SDSValue,",")
	for m=1:1:len{
		s progroup=$p(SDSValue,",",m)
		s key=$p(progroup,":",1)
		s value=$p(progroup,":",2)
		s ^TMPMKBOPSRES("OperationResult",key)=value
	}
	//遍历勾选值，比对临时global
	s lenCheck=$Length(checkedVal,",")
	for n=1:1:lenCheck{
		s checkgroup=$p(checkedVal,",",n)
		s checkkey=$p(checkgroup,":",1)
		s checkvalue=$p(checkgroup,":",2)
		if ($d(^TMPMKBOPSRES("OperationResult",checkkey))){ //比对属性
			s opsvalue="*"_$g(^TMPMKBOPSRES("OperationResult",checkkey))_"*"
			s lenckvalue=$Length(checkvalue,"*")
			for k=1:1:lenckvalue{
				s ckvalue="*"_$p(checkvalue,"*",k)_"*"
				if (opsvalue'[ckvalue){ //比对属性内容
					s result="false"	
				}
			}
		}else{
			s result="false"	
		}
	}
	if (result="false"){
		s result="N"	
	}else{
		s result="Y"	
	}
	q result
}

/// Creator:高姗姗
/// CreatDate:2020-02-11
/// Description：获取结构化诊断的信息
/// Table：User.MKBOperationResult
/// Input：手术术语id，勾选属性内容值串
/// Return：术语属性内容值串
/// Other: w ##class(web.DHCBL.MKB.MKBStructOperation).GetData("1438805","8834325:1865354")
ClassMethod GetData(termid, checkedVal) As %String
{
	q:checkedVal="" ""
	s result=""
	s opsVersion=$p(##class(web.DHCBL.MKB.MKBConfig).GetConfigValue("SDSOperationResource"),"ICD",2) //取平台配置
	s PropertyDR=..GetPropertyIdByFlag(termid,"DT")
	d ..GetShowType(PropertyDR)
	s TreeCheckedIdStr=""
	s ComboCheckedIdStr=""
	s RadioCheckedIdStr=""
	s CheckBoxCheckedIdStr=""
	s GridCheckedIdStr=""
	s SDSValue="" 
	for {
		s SDSValue=$o(^User.MKBOperationResultI("SortIndex",termid,SDSValue)) q:SDSValue=""
		continue:(SDSValue=-100000000000000) //过滤未维护属性数据
		
		s flag=0
		s parref=""
		for {
			s parref=$o(^User.MKBOperationResultI("SortIndex",termid,SDSValue,parref)) q:parref=""
			s OperationSource=$lg($g(^User.MKBOperationContrastD(parref)),6) //父表手术来源，可能为多个，&分隔
			if (OperationSource[opsVersion){
				s flag=1
			}
		}
		continue:(flag=0) //版本过滤
		
		//判断是否包含checkedVal所有项
		s existflag=..GetAllExistFlag(SDSValue,checkedVal)
		if (existflag="Y"){
			s len=$Length(SDSValue,",")
			for i=1:1:len{
				s progroup=$p(SDSValue,",",i)
				s key=$p(progroup,":",1)
				s value=$p(progroup,":",2)
				s len2 = $Length(value,"*")		
				for j=1:1:len2{
					s value1=$p(value,"*",j)
					if (value1 [ "S"){
						s value1 = 	$p(value1,"S",2)
					}
				 	if ($g(^TMPMKBSHOWTYPE(key))="T"){
					 	continue:TreeCheckedIdStr[value1
					 	if (TreeCheckedIdStr=""){
							s TreeCheckedIdStr=value1
						}else{
							s TreeCheckedIdStr=TreeCheckedIdStr_"&"_value1
						}
					}	
					if ($g(^TMPMKBSHOWTYPE(key))="C"){
						continue:ComboCheckedIdStr[value1
						if (ComboCheckedIdStr=""){
							s ComboCheckedIdStr=value1
						}else{
							s ComboCheckedIdStr=ComboCheckedIdStr_"&"_value1
						}
					}
					if ($g(^TMPMKBSHOWTYPE(key))="CB"){
						continue:RadioCheckedIdStr[value1
						if (RadioCheckedIdStr=""){
							s RadioCheckedIdStr=value1
						}else{
							s RadioCheckedIdStr=RadioCheckedIdStr_"&"_value1
						}
					}
					if ($g(^TMPMKBSHOWTYPE(key))="CG"){
						continue:CheckBoxCheckedIdStr[value1
						if (CheckBoxCheckedIdStr=""){
							s CheckBoxCheckedIdStr=value1
						}else{
							s CheckBoxCheckedIdStr=CheckBoxCheckedIdStr_"&"_value1
						}
					}
					if ($g(^TMPMKBSHOWTYPE(key))="G"){
						continue:GridCheckedIdStr[value1
						if (GridCheckedIdStr=""){
							s GridCheckedIdStr=value1
						}else{
							s GridCheckedIdStr=GridCheckedIdStr_"&"_value1
						}
					}
				}
			}
			
		}	
	}
	s result=TreeCheckedIdStr_"^"_ComboCheckedIdStr_"^"_RadioCheckedIdStr_"^"_CheckBoxCheckedIdStr_"^"_GridCheckedIdStr
	q result
}

/// Creator:高姗姗
/// CreatDate:2020-02-11
/// Description：根据标识获取属性id
/// Input: termid术语id，desc属性描述
/// return:属性id
/// Other:w ##class(web.DHCBL.MKB.MKBStructOperation).GetPropertyIdByFlag("16354","DT")
ClassMethod GetPropertyIdByFlag(termid As %String, flag As %String) As %String
{
	s propertyid=""
	s propertyid=$o(^User.MKBTermPropertyI("FlagIndex",termid," "_flag,0))
	q propertyid
}

/// Creator:高姗姗
/// CreatDate:2020-02-11
/// Description：根据属性id获取诊断模板中的展示格式
/// Table：User.MKBTermProDetail
/// Input：属性id
/// Other: w ##class(web.DHCBL.MKB.MKBStructOperation).GetShowType("4989")
ClassMethod GetShowType(property) As %String
{
	k ^TMPMKBSHOWTYPE
	q:property="" ""
	s MKBTPDRowId=$o(^User.MKBTermProDetailI("ProIdx",property,0))
	s MKBTPDDesc=""
	s:MKBTPDRowId'="" MKBTPDDesc=$LISTGET($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)
	if (MKBTPDDesc'="")
	{
        s argsLen=$Length(MKBTPDDesc,",")
        for i=1:1:argsLen  
        { 
          s argstr=$p(MKBTPDDesc,",",i)
          s MKBTPRowId=$p(argstr,"&",1)
          s MKBTPShowType=$p(argstr,"&",2)  //展示格式
          s MKBTPTreeNode=$p(argstr,"&",3)  //定义节点
          s ^TMPMKBSHOWTYPE(MKBTPRowId)=MKBTPShowType
        }
	}
}

/// Creator：高姗姗
/// CreatDate: 2020-02-19
/// Description：查询相关手术ICD
/// Table：User.MKBOperationResult
/// Input：手术术语id，勾选属性内容值串
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBStructOperation","GetRelatedICDList","1438805","")
Query GetRelatedICDList(termid As %String, checkedVal As %String) As %Query(ROWSPEC = "OperationRowId,OperationNumber,OperationDesc,OperationChild")
{
}

ClassMethod GetRelatedICDListExecute(ByRef qHandle As %Binary, termid As %String, checkedVal As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 s opsVersion=$p(##class(web.DHCBL.MKB.MKBConfig).GetConfigValue("SDSOperationResource"),"ICD",2) //取平台配置
 s SDSValue="" 
 for {
 	s SDSValue=$o(^User.MKBOperationResultI("SortIndex",termid,SDSValue)) q:SDSValue=""
 	s parref=""
 	for {
		s parref=$o(^User.MKBOperationResultI("SortIndex",termid,SDSValue,parref)) q:parref=""
		s OperationSource=$lg($g(^User.MKBOperationContrastD(parref)),6) //父表手术来源，可能为多个，&分隔
		continue:(OperationSource'[opsVersion) //版本过滤
		if (checkedVal'=""){
			continue:(SDSValue=-100000000000000) //过滤未维护属性数据
			//判断是否包含checkedVal所有项
			s existflag=..GetAllExistFlag(SDSValue,checkedVal)
			continue:(existflag'="Y")
		}
		s OperationRowId=parref //各版本手术对照中手术id
		s OperationDesc=$lg($g(^User.MKBOperationContrastD(OperationRowId)),3) //手术描述	
		s OperationNumber=$lg($g(^User.MKBOperationContrastD(OperationRowId)),4) //手术主要编码
		s OperationChild=OperationRowId_"||"_$o(^User.MKBOperationResultI("SortIndex",termid,SDSValue,OperationRowId,0)) //结构化结果手术1
		d OutputRow
	}
	
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(OperationRowId,OperationNumber,OperationDesc,OperationChild)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetRelatedICDListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRelatedICDListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetRelatedICDListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRelatedICDListExecute ]
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
