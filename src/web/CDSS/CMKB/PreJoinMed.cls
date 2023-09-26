/// Creator:赵文伟
/// CreatDate:2021-08-30 
/// Description：中医方剂关联中药
Class web.CDSS.CMKB.PreJoinMed Extends %RegisteredObject
{

/// Creator:赵文伟
/// CreatDate:2022-02-10
/// Description:获得方剂关联中药
/// Table: CT.WDT.CDSS.TCMPreJoinMed
/// Input: PrescriptionDR
/// Return:返回方剂关联中药
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.PreJoinMed","GetList","")
Query GetList(prescriptionDR As %String) As %Query(ROWSPEC = "RowId,PrescriptionDR,MedicineDR,MedicineName,RecommendDose,DoseUnit,UnitDesc,Decoction,DecoctionName")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, prescriptionDR As %String) As %Status
{
	
 	s repid=$I(^CacheTemp)
 	s ind=1
 	if (prescriptionDR'=""){
		s RowId=""
		for
		{
			s RowId = $o(^CT.WDT.CDSS.TCMPreJoinMedI("PrescriptionIndex",prescriptionDR,RowId))
		
			q:RowId=""
			s PrescriptionDR=prescriptionDR
			s MedicineDR = $lg($g(^CT.WDT.CDSS.TCMPreJoinMedD(RowId)),3) //中药指向(方剂组成)
			s MedicineName=""
			s:MedicineDR'="" MedicineName=$lg($g(^CT.WDT.CDSS.TCMMedicineD(MedicineDR)),3)
			s RecommendDose= $lg($g(^CT.WDT.CDSS.TCMPreJoinMedD(RowId)),4) 	//推荐剂量
			//s MedicineUsage=""
			//s:RecommendDose'="" MedicineUsage=$lg($g(^CT.WDT.CDSS.TCMMedicineD(RecommendDose)),9)
			s DoseUnit= $lg($g(^CT.WDT.CDSS.TCMPreJoinMedD(RowId)),5) 	//推荐单位
			s UnitDesc=""
			s:DoseUnit'="" UnitDesc=$lg($g(^CT.WDT.CDSS.UnitDictD(DoseUnit)),3)
			s Decoction= $lg($g(^CT.WDT.CDSS.TCMPreJoinMedD(RowId)),6) 	//煎法
			s DecoctionName=""
			s:Decoction'="" DecoctionName=$lg($g(^CT.WDT.CDSS.TCMDecoctionD(Decoction)),3)
			
		  	d OutputRow
		} 
	}

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RowId,PrescriptionDR,MedicineDR,MedicineName,RecommendDose,DoseUnit,UnitDesc,Decoction,DecoctionName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/*
/// Creator:赵文伟
/// CreatDate:2020-08-30
/// Description:获得方剂关联中药
/// Table: CT.WDT.CDSS.TCMPreJoinMed
/// Input: PrescriptionDR
/// Return:返回方剂关联中药
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.PreJoinMed","GetList","")
Query GetList(prescriptionDR As %String) As %Query(ROWSPEC = "RowId:%String,MedicineDR:%String,MedicineName:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, prescriptionDR As %String) As %Status
{
	
 	s repid=$I(^CacheTemp)
 	s ind=1
 	if (prescriptionDR'=""){
		s RowId=""
		for
		{
			s RowId = $o(^CT.WDT.CDSS.TCMPreJoinMedI("PrescriptionIndex",PrescriptionDR,RowId))
		
			q:RowId=""
			s MedicineDR = $lg($g(^CT.WDT.CDSS.TCMPreJoinMedD(RowId)),3) //中药指向
			s MedicineName=""
			s:MedicineDR'="" MedicineName=$lg($g(^CT.WDT.CDSS.TCMMedicineD(MedicineDR)),3)
		  	d OutputRow
		  	
		} 
	}

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RowId,MedicineDR,MedicineName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:赵文伟
/// CreatDate:2021-08-30
/// Description:保存方剂关联中药
/// Table: CT.WDT.CDSS.TCMPreJoinMed
/// Input: PrescriptionDR, MedicineStr
/// others:w ##class(web.CDSS.CMKB.PreJoinMed).SaveData(4,"^950,^951")
ClassMethod SaveData(PrescriptionDR, MedicineStr)
{
	q:PrescriptionDR="" ""
	q:MedicineStr="" ""
	Ts
	s result=""
	s len=$Length(MedicineStr,",")
	for i=1:1:len{
		s Medicine=$p(MedicineStr,",",i)
		continue:Medicine=""
		s RowId=$p(Medicine,"^",1)
		s MedicineDR=$p(Medicine,"^",2)
		if (RowId=""){ //方剂关联中药新增
			s objMedicine=##class(CT.WDT.CDSS.TCMPreJoinMed).%New()
			d objMedicine.PrescriptionDRSetObjectId(PrescriptionDR)
			d:MedicineDR'="" objMedicine.MedicineDRSetObjectId(MedicineDR)
			d:MedicineDR="" objMedicine.MedicineDRSetObjectId("")
			
			s scAdd=objMedicine.%Save() 
			d objMedicine.%Close()
			If $$$ISOK(scAdd) //新增数据存入数组
			{
				s arrExist(PrescriptionDR,objMedicine.%Id())=""
			}else{
				s result="false"
				Trollback
			}
			
		}else{ //前台原有数据存入数组
			s arrExist(PrescriptionDR,RowId)=""
		}	
	}
	
	s id=""
	for{
		s id=$o(^CT.WDT.CDSS.TCMPreJoinMedI("PrescriptionIndex",PrescriptionDR,id)) q:id=""
		continue:$d(arrExist(PrescriptionDR,id))	 //过滤现有数据
		//关联中药删除
		s scDel=##class(CT.WDT.CDSS.TCMPreJoinMed).%DeleteId(id)
		If $$$ISERR(scDel)
		{	
			s result="false"
			Trollback
		}
	}
	if (result="false"){
		s result = "{success:'false'}"
	}else{
		Tc
		s result = "{success:'true'}"
	}
	q result
}
*/
/// Creator:赵文伟
/// Description:测试保存方法
/// Other: w ##class(web.CDSS.CMKB.PreJoinMed).SaveTest()
ClassMethod SaveTest()
{
	s eobj = ##class(web.CDSSEntity.CMKB.PreJoinMed).%New()
	s eobj.PrescriptionDR="210"	
	s eobj.MedicineDR="1133"
	s eobj.RecommendDose="1133"
	s eobj.DoseUnit="52"
	s eobj.Decoction="3"
	
	w ..SaveData(eobj)
	q ""
}

/// Creator:赵文伟
/// CreatDate:2022-03-02
/// Description:方剂组成重复校验
/// Table: CT.WDT.CDSS.TCMPreJoinMed
/// Input: RowId、PrescriptionDR、MedicineDR
/// Return："1"(数据重复),"0"(数据不重复)
/// w ##class(web.CDSS.CMKB.PreJoinMed).FormValidate("","213","655")
ClassMethod FormValidate(id As %String, prescriptionDR As %String, medicineDR As %String) As %String
{
	
	/*s flag="",flagc="",flagd=""
	s:prescriptionDR'="" flagc=$d(^CT.WDT.CDSS.TCMPreJoinMedI("PrescriptionIndex",prescriptionDR))
	s:medicineDR'="" flagd=$d(^CT.WDT.CDSS.TCMPreJoinMedI("MedicineIndex",medicineDR))
	
	if (flagc>0){
		if (id="")	//如果为空，增加时的重复判断
		{
			if (flagd>0) s flag=1	//返回重复标志
			else  s flag=0 			//返回不重复标志
			
		}
		else 		//如果不为空，修改时的重复判断
		{
			s idd=""
			s:medicineDR'="" idd=$o(^CT.WDT.CDSS.TCMPreJoinMedI("MedicineIndex",medicineDR,0))
			if (((idd'="")&(idd'=id)&(flagd>0))) s flag=1	//返回重复标志
			else  s flag=0 			//返回不重复标志
											
		}
	}
	q flag*/
	s flag="",flagz=""
	if (prescriptionDR'="")&(medicineDR){	
		s flagz=$d(^CT.WDT.CDSS.TCMPreJoinMedI("PrescriptMedIndex",prescriptionDR,medicineDR))
		
		if (id="")	//如果为空，增加时的重复判断
		{
			if (flagz>0) s flag=1	//返回重复标志
			else  s flag=0 			//返回不重复标志
			
		}
		else 		//如果不为空，修改时的重复判断
		{
			s idd=""
			//s:medicineDR'="" idd=$o(^CT.WDT.CDSS.TCMPreJoinMedI("MedicineIndex",medicineDR,0))
			s idd=$o(^CT.WDT.CDSS.TCMPreJoinMedI("PrescriptMedIndex",prescriptionDR,medicineDR,0))
			
			if (((idd'="")&(idd'=id)&(flagz>0))) s flag=1	//返回重复标志
			else  s flag=0 			//返回不重复标志								
		}	
	}
		q flag
}

/// Creator:赵文伟
/// CreatDate:2022-02-10
/// Description:保存方剂关联中药
/// Table: CT.WDT.CDSS.TCMPreJoinMed
/// Input: PrescriptionDR, MedicineStr
/// others:w ##class(web.CDSS.CMKB.PreJoinMed).SaveData()
ClassMethod SaveData(RowId, PrescriptionDR, MedicineDR, RecommendDose, DoseUnit, Decoction)
{
	
	s result=""
	q:MedicineDR="" "{success:'false',errorinfo:'方剂组成不能为空！'}"
	s flag=..FormValidate(RowId,PrescriptionDR,MedicineDR)  //调用重复验证
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在'}"
			q result
		}
		
		if (RowId="")  //如果RowId未赋值则增加
		{
			s obj=##class(CT.WDT.CDSS.TCMPreJoinMed).%New()	
		}
		else  //如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.TCMPreJoinMed).%OpenId(RowId)
			s bobj = ##class(web.CDSSEntity.CMKB.PreJoinMed).%New()
			s:obj.PrescriptionDR'="" bobj.PrescriptionDR = obj.PrescriptionDR.%Id()
			//s bobj.PrescriptionDR = obj.PrescriptionDR  //方剂指向
			s:obj.MedicineDR'="" bobj.MedicineDR = obj.MedicineDR.%Id()
			//s bobj.MedicineDR = obj.MedicineDR			//中药(方剂组成)指向
			s bobj.RecommendDose = obj.RecommendDose	//推荐剂量 指向
			s bobj.DoseUnit = obj.DoseUnit				//剂量单位 指向
			s bobj.Decoction = obj.Decoction			//煎法 指向
			
		}
		d obj.PrescriptionDRSetObjectId(PrescriptionDR)		
		//s obj.PrescriptionDR = PrescriptionDR
		//s obj.MedicineDR = MedicineDR
		d obj.MedicineDRSetObjectId(MedicineDR)	
		s obj.RecommendDose = RecommendDose
		//d obj.RecommendDoseSetObjectId(RecommendDose)	
		//s obj.RecommendDose = eobj.MedicineDR
		//s obj.DoseUnit = DoseUnit
		d obj.DoseUnitSetObjectId(DoseUnit)
		//s obj.Decoction = Decoction
		d obj.DecoctionSetObjectId(Decoction)
		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" //返回RowId
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}		
	q result
}

/// Creator:赵文伟
/// CreatDate:2022-02-10
/// Description:通过id获取字典表内容
/// Table: CT.WDT.CDSS.TCMPreJoinMed
/// Input: id 字典表id
/// Return: 字典表内容
/// others:w ##class(web.CDSS.CMKB.PreJoinMed).OpenData("1")
ClassMethod OpenData(prescriptionDR As %String)
{
	s str=""
	s RowId=""
	s eobj = ##class(web.CDSSEntity.CMKB.PreJoinMed).%New()
	s RowId = $o(^CT.WDT.CDSS.TCMPreJoinMedI("PrescriptionIndex",prescriptionDR,RowId))	
	s eobj.RowId = RowId
    s eobj.PrescriptionDR = $lg($g(^CT.WDT.CDSS.TCMPreJoinMedD(RowId)),2)
    
    s eobj.MedicineDR = $lg($g(^CT.WDT.CDSS.TCMPreJoinMedD(RowId)),3)
    s MedicineName=""
	s:eobj.MedicineDR'="" MedicineName=$lg($g(^CT.WDT.CDSS.TCMMedicineD(eobj.MedicineDR)),3)
    s eobj.RecommendDose = $lg($g(^CT.WDT.CDSS.TCMPreJoinMedD(RowId)),4)
    //s MedicineUsage=""
	//s:eobj.RecommendDose'="" MedicineUsage=$lg($g(^CT.WDT.CDSS.TCMMedicineD(eobj.RecommendDose)),9)
    s eobj.DoseUnit = $lg($g(^CT.WDT.CDSS.TCMPreJoinMedD(RowId)),5)
    s DoseUnitName=""
	s:eobj.DoseUnit'="" DoseUnitName=$lg($g(^CT.WDT.CDSS.UnitDictD(eobj.DoseUnit)),3)
    s eobj.Decoction = $lg($g(^CT.WDT.CDSS.TCMPreJoinMedD(RowId)),6)
	s DecoctionName=""
	s:eobj.Decoction'="" DecoctionName=$lg($g(^CT.WDT.CDSS.TCMDecoctionD(eobj.DoseUnit)),3)
	
	s str = eobj.JsonS()
	d eobj.%Close()
	q str
}

/// Creator:赵文伟
/// CreatDate:2022-02-10
/// Description:删除数据————根据方剂关联中药表id删除
/// Table: CT.WDT.CDSS.TCMPreJoinMed
/// Input: id 字典表id
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.PreJoinMed).DeleteInitialData("1")
ClassMethod DeleteData(id As %String)
{
	s result=""
	
		s obj=##class(CT.WDT.CDSS.TCMPreJoinMed).%OpenId(id)
		s bobj = ##class(web.CDSSEntity.CMKB.PreJoinMed).%New()
	    s bobj.PrescriptionDR = obj.PrescriptionDR
		s bobj.MedicineDR = obj.MedicineDR
		s bobj.RecommendDose = obj.RecommendDose
		s bobj.DoseUnit = obj.DoseUnit
		s bobj.Decoction = obj.Decoction
		Ts	
			
		s sc=##class(CT.WDT.CDSS.TCMPreJoinMed).%DeleteId(id)
		if $$$ISOK(sc)
		{
			Tc
			s result = "{success:'true',info:'删除成功！'}"	
			//保存日志
			d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMPreJoinMed","CT.WDT.CDSS.TCMPreJoinMed","方剂关联中药字典表",id,bobj.PrescriptionDR,"D",bobj)
			
			d bobj.%Close()
		}
		else
		{
			Tro
			s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			
	       	s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("方剂关联中药字典表","web.CDSS.CMKB.PreJoinMed","DeleteData",bobj)
	       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
    
	q result
}

/// Creator:赵文伟
/// CreatDate:2022-02-21
/// Description:删除数据【根据prescriptionDR删除,中医方剂字典中同步删除时调用】
/// Table: CT.WDT.CDSS.TCMPreJoinMed
/// Input: id 字典表id
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.PreJoinMed).DeleteLinkData("1")
ClassMethod DeleteLinkData(prescriptionDR As %String)
{
	for
	{
		s result=""
		s id=""
		s:prescriptionDR'="" id = $o(^CT.WDT.CDSS.TCMPreJoinMedI("PrescriptionIndex",prescriptionDR,id)) q:id=""
		s obj=##class(CT.WDT.CDSS.TCMPreJoinMed).%OpenId(id)
		//b ;1
		s bobj = ##class(web.CDSSEntity.CMKB.PreJoinMed).%New()
	    s bobj.PrescriptionDR = obj.PrescriptionDR
		s bobj.MedicineDR = obj.MedicineDR
		s bobj.RecommendDose = obj.RecommendDose
		s bobj.DoseUnit = obj.DoseUnit
		s bobj.Decoction = obj.Decoction
		
		Ts		
		s sc=##class(CT.WDT.CDSS.TCMPreJoinMed).%DeleteId(id)
		if $$$ISOK(sc)
		{
			Tc
			s result = "{success:'true',info:'删除成功！'}"	
			//保存日志
			d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMPreJoinMed","CT.WDT.CDSS.TCMPreJoinMed","方剂关联中药字典表",id,bobj.PrescriptionDR,"D",bobj)
			
			d bobj.%Close()
		}
		else
		{
			Tro
			s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			
	       	s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("方剂关联中药字典表","web.CDSS.CMKB.PreJoinMed","DeleteData",bobj)
	       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	q result
}

/// Creator:赵文伟
/// CreatDate:2022-03-31
/// Description:根据方剂组成获取并保存对应的推荐剂量数据 
/// Table: CT.WDT.CDSS.TCMPreJoinMed
/// Return： result
/// Other:w ##class(web.CDSS.CMKB.PreJoinMed).SaveRecommendDoseData()
ClassMethod SaveRecommendDoseData() As %String
{
	s readcount=0
	s savecount=0
	s unsavecount=0
	s RowId=""
	for
	{
		s RowId = $o(^CT.WDT.CDSS.TCMPreJoinMedD(RowId))
		q:RowId=""
		s MedicineDR = $lg($g(^CT.WDT.CDSS.TCMPreJoinMedD(RowId)),3) //中药指向(方剂组成)
		s RecommendDose=""
		s:MedicineDR'="" RecommendDose=$lg($g(^CT.WDT.CDSS.TCMMedicineD(MedicineDR)),9)
		if (RecommendDose'=""){			
			s obj=##class(CT.WDT.CDSS.TCMPreJoinMed).%OpenId(RowId)
			s obj.RecommendDose = RecommendDose
			
			s readcount=readcount+1
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{		
				s savecount=savecount+1
			}
			else
			{	
				s unsavecount=unsavecount+1
				w "保存不成功数据RowId:"_RowId ,!
			}
		}		
	}
	q "readcount:"_readcount_"，savecount:"_savecount_"，unsavecount:"_unsavecount
}

/// Creator:赵文伟
/// CreatDate:2023-03-01
/// Description:返回中药在方剂中的引用
/// Return:引用数据
/// w ##class(web.CDSS.CMKB.PreJoinMed).GetRefFlag("668")
ClassMethod GetRefFlag(MedicineDR As %String) As %String
{
	s QuoteStr=""
	if (MedicineDR'=""){
		if ($d(^CT.WDT.CDSS.TCMPreJoinMedI("MedicineIndex",MedicineDR))){
			s RowId=""
			for {
				s RowId = $o(^CT.WDT.CDSS.TCMPreJoinMedI("MedicineIndex",MedicineDR,RowId)) q:RowId=""
				s PrescriptionDR=$lg($g(^CT.WDT.CDSS.TCMPreJoinMedD(RowId)),2)
				s PrescriptionName=""
				s:PrescriptionDR'="" PrescriptionName=$LISTGET($G(^CT.WDT.CDSS.TCMPrescriptionD(PrescriptionDR)),3)
				q:PrescriptionName=""
				if (QuoteStr=""){
					s QuoteStr=PrescriptionName
				}else{
					s QuoteStr=QuoteStr_","_PrescriptionName
				}
			}
		}
	}
	q QuoteStr
}

}
