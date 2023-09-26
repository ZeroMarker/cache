/// 名称: DHCMed.INFService.CJBTest
/// 描述: 测试用类
/// 编写者：ChenJB
/// 编写日期: 2010-08-01
Class DHCMed.INFService.CJBTest Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod GetQueryStore() As %String
{
	//Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId(ClassName)
 	//set count = cdef.Queries.Count() 
 	s ret="var data={name:'Appendix',kids: ["
 	s ret=ret_$c(13)_$c(10)
 	s tmpStr=""
 	F i=1:1:2  d
 	.s:tmpStr'="" tmpStr=tmpStr_",{"
	.s:tmpStr="" tmpStr="{"
    .s tmpStr=tmpStr_"rowid: '"_i_"',"
    .s tmpStr=tmpStr_"titles: 'titles"_i_"',"
    .s tmpStr=tmpStr_"code: 'code"_i_"',"
    .s tmpStr=tmpStr_"type: 'text',"
    .s tmpStr=tmpStr_"defalutVal:[{value:'t1',selected:''}],"
    .s tmpStr=tmpStr_"eventArr:[{evName:'onclick',handler:'T1()'}],"
    .s tmpStr=tmpStr_"Pos:1"
    .s tmpStr=tmpStr_"}"
 	//d cdef.%Close()
 	//k cdef	
 	s ret=ret_tmpStr_"]}"
 	q ret
}

/// w ##class(DHCMed.INFService.CJBTest).WriteAricmType()
ClassMethod WriteAricmType() As %String
{
	n 
	s ItmCat=0
	f  s ItmCat=$o(^ARC("IC",+ItmCat)) q:ItmCat=""  d
	.s Type=$p($g(^ARC("IC",+ItmCat)),"^",7)
    .q:Type'="L"
    .w $g(^ARC("IC",+ItmCat)),!
    .s TypeName=$p($g(^ARC("IC",+ItmCat)),"^",2)    //获取类别名称
    q ""
}

/// f  s Rowid=$o(^CTLOC(Rowid)) q:Rowid=""  d
/// 	.s LocDesc=$p($g(^CTLOC(Rowid)),"^",2)
ClassMethod SavePaadm(StoreID)
{
	n (StoreID)
	//k ^CacheTemp(StoreID)
	s DeptItem=""
	s ind=+$o(^CacheTemp(StoreID,""),-1)
	f  s DeptItem=$o(^CTLOC(DeptItem)) q:DeptItem=""  d
	.s LocType=$p($g(^CTLOC(DeptItem)),"^",13)
	.q:LocType'="E"
	.s Date=""
    .f  s Date=$o(^PAADMi("AdmTypeCurrLoc","I",DeptItem,Date)) q:(Date="")  d
    ..s Time=""
    ..f  s Time=$o(^PAADMi("AdmTypeCurrLoc","I",DeptItem,Date,Time)) q:(Time="")  d
    ...s paadm=""
    ...f  s paadm=$o(^PAADMi("AdmTypeCurrLoc","I",DeptItem,Date,Time,paadm)) q:(paadm="")  d
    ....s ind=ind+1
	....s ^CacheTemp(StoreID,ind)=paadm
	q "OK"
}

/// ^PAADMi("PAADM_Type",{PAADM_Type}
ClassMethod SavePaadm1(StoreID)
{
	n (StoreID)
	//k ^CacheTemp(StoreID)
	s DeptItem=""
	s ind=+$o(^CacheTemp(StoreID,""),-1)
	f  s DeptItem=$o(^PAADMi("PAADM_Type","I",DeptItem),-1) q:(DeptItem="")!(ind>10)  d
    .s ind=ind+1
	.s ^CacheTemp(StoreID,ind)=DeptItem
	s ind=ind+1
	s ^CacheTemp(StoreID,ind)=51104
	s ind=ind+1
	s ^CacheTemp(StoreID,ind)=68163
	q "OK"
}

ClassMethod Test()
{
	// w ##class(DHCMed.INFService.CJBTest).Test()
	//k ^CacheTemp
	s storeID=$I(^CacheTemp)	
	d ..SavePaadm1(storeID)
	d ##class(%Library.ResultSet).RunQuery("DHCMed.CCService.System.VMShell","RunVM",1,storeID)
	//.s rSet=##class(%ResultSet).%New("DHCMed.INFService.PatAntiRelationSrv:QuertAntiRelation")
    //.s rc=rSet.Execute(DicID)
    //.f  q:'rSet.Next()  d
	q ""
}

/// d ##class(DHCMed.INFService.CJBTest).LoadPMO()
ClassMethod LoadPMO()
{
	//k ^DHCMed.SS.MenusD
	//k ^DHCMed.SS.MenusI
	//k ^DHCMed.SS.ProductsD
	//k ^DHCMed.SS.ProductsI
	k ^DHCMed.SS.SecurityD
	k ^DHCMed.SS.SecurityI
	//k ^DHCMed.SS.MenuOperationD
	//k ^DHCMed.SS.MenuOperationI
	k ^DHCMed.SS.SecurityOperaD
	k ^DHCMed.SS.SecurityOperaI
	
	//set id=##class(DHCMed.SS.Products).Update("^Systeml^系统管理^v1.1.0^icon-sysconfig^99^1^")
	//set mid=##class(DHCMed.SS.Menus).Update("^Productsl^产品维护^dhcmed.main.products.csp^^"_id_"^1^icon-menupro^")
	// 4  8 -- 12
	s id=4
	set sid=##class(DHCMed.SS.Security).Update(1,id,8,1)
	set sid=##class(DHCMed.SS.Security).Update(1,id,9,1)
	set sid=##class(DHCMed.SS.Security).Update(1,id,10,1)
	set sid=##class(DHCMed.SS.Security).Update(1,id,11,1)
	set sid=##class(DHCMed.SS.Security).Update(1,id,12,1)
}

ClassMethod GetDictionaryByType(type As %String) As %String
{
	s ret=""
	q:type="" ret
    s type=$ZCVT($g(type),"U")
 	/*
 	if (type="")
 	{
 		s type="SYS"
 	}
 	*/
    s type=" "_type
 	s myid=$o(^DHCMed.SS.DictionaryI("IdxofType",type,""))
 	
 	//s myid=$o(^DHCMed.SS.DictionaryD(""))
 	while (myid'="")
 	{
	s mydictionary=##class(DHCMed.SS.Dictionary).%OpenId(myid)
	if ($IsObject(mydictionary))
	{    
	    
		s Code=mydictionary.Code
		s Description=mydictionary.Description
		s TypeV=mydictionary.Type
		s Active=mydictionary.Active
		if (Active="1")
		{
			s Active="YES"  
			}
	    else
	    {
		  	s Active="NO"  
		    }
			    
		s HospitalDr=mydictionary.HospitalDr
		s HispsDescs=$p($g(^CT("HOSP",+HospitalDr)),"^",2)
		
		s DateFrom=mydictionary.DateFrom
		s DateTo=mydictionary.DateTo
		if (DateFrom'="")
		{
		s DateFrom=$zd(DateFrom,1)
		}
		if (DateTo'="")
		{
	    s DateTo=$zd(DateTo,1)
		}
		//set Data=$lb(myid,Code,Description,Type,Active,HispsDescs,DateFrom,DateTo,HospitalDr)
        set:ret'="" ret=ret_$c(1)_myid_"^"_Code_"^"_Description_"^"_TypeV_"^^^^^^^^^^^"
        set:ret="" ret=myid_"^"_Code_"^"_Description_"^"_TypeV_"^^^^^^^^^^^"
		  } 	
	   //  s myid=$o(^DHCMed.SS.DictionaryD(myid))
	   s myid=$o(^DHCMed.SS.DictionaryI("IdxofType",type,myid))
	 	}
	 	q ret
}

/// 清除 院感 测试数据
/// w ##class(DHCMed.INFService.CJBTest).ClearInfectionData()
ClassMethod ClearInfectionData() As %String
{
    s ret="Success"
    k ^DHCMed.INF.RepAppenD
	k ^DHCMed.INF.RepAppenI
	k ^DHCMed.INF.RepDrugD
	k ^DHCMed.INF.RepDrugI
	k ^DHCMed.INF.RepOPRD
	k ^DHCMed.INF.RepOPRI
	k ^DHCMed.INF.RepStatusDtlsD
	k ^DHCMed.INF.RepStatusDtlsI
	k ^DHCMed.INF.ReportD
	k ^DHCMed.INF.ReportI
	k ^DHCMed.INF.SummaryD
	k ^DHCMed.INF.SummaryI
	k ^DHCMed.INF.RepPosD
	k ^DHCMed.INF.RepPosI
	k ^DHCMed.INF.RepReasonD
	k ^DHCMed.INF.RepReasonI
	k ^DHCMed.INF.RepInfoRelD
	k ^DHCMed.INF.RepInfoRelI
	k ^DHCMed.INF.PathogenyD
	k ^DHCMed.INF.PathogenyI
	k ^DHCMed.INF.PyObjD
	k ^DHCMed.INF.PyObjI
	k ^DHCMed.INF.PyObjDrugD
	k ^DHCMed.INF.PyObjDrugI
	
	k ^DHCMed.INF.ICUInfoD
	k ^DHCMed.INF.ICUInfoI
	k ^DHCMed.INF.ICUDeviceInfoD
	k ^DHCMed.INF.ICUDeviceInfoI
	k ^DHCMed.INF.TypeLocConfigI
	k ^DHCMed.INF.TypeLocConfigD

    q ret
}

}
