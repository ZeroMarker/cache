/// Description: 中医疾病关联证候表
/// Creator: 胡宜良
/// Date: 2022-02-21
Class web.CDSS.CMKB.TCMDiseJSym Extends %RegisteredObject
{

/// Description:测试保存方法
/// Other: w ##class(web.CDSS.CMKB.TCMDiseJSym).TestSaveData()
ClassMethod TestSaveData()
{
	s eobj = ##class(web.CDSSEntity.CMKB.TCMDiseJSym).%New()
	s eobj.RowId=""	
	s eobj.TCMDiseDR="1291"
	s eobj.TCMSymDR="2041" //1892
	s eobj.DiseaseDR=""
	//s eobj.PrescriptionAlias="32"
	
	
	//s eobj.Medicine="^950,^951"
	
	w ..SaveData(eobj)
	q ""
}

/// Creator:胡宜良
/// CreatDate:2022-02-21
/// Description：获得中医疾病关联证候
/// Table：CT.WDT.CDSS.TCMDiseJSym
/// Input: TCMDiseDR 
/// Return:返回疾病关联证型
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.TCMDiseJSym","GetList","1299")
Query GetList(TCMDiseDR) As %Query(ROWSPEC = "RowId,TCMSymDR,SymptomName")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, TCMDiseDR) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	if (TCMDiseDR'=""){
		s RowId=""
		for
		{
			s RowId = $o(^CT.WDT.CDSS.TCMDiseJSymI("DiseDRIndex",TCMDiseDR,RowId))
			q:RowId=""
			s TCMSymDR = $lg($g(^CT.WDT.CDSS.TCMDiseJSymD(RowId)),3) //证型指向
			s SymptomName=""
			s:TCMSymDR'="" SymptomName=$lg($g(^CT.WDT.CDSS.TCMSymptomD(TCMSymDR)),3)
		  	d OutputRow
		  	
		} 
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RowId,TCMSymDR,SymptomName)
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

/// Creator:胡宜良
/// CreatDate:2022-08-04
/// Description：获得中医疾病关联证候
/// Table：CT.WDT.CDSS.TCMDiseJSym
/// Input: TCMDiseDR 
/// Return:返回疾病关联证型以及关联西医
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.TCMDiseJSym","GetDisList","1257")
Query GetDisList(TCMDiseDR As %String) As %Query(ROWSPEC = "RowId,TCMDiseDR,DiseaseDR,DiseaseName,TCMSymDR,SymptomName")
{
}

ClassMethod GetDisListExecute(ByRef qHandle As %Binary, TCMDiseDR As %String) As %Status
{
	
 	s repid=$I(^CacheTemp)
 	s ind=1
 	if (TCMDiseDR'=""){
		s RowId=""
		for
		{
			
			s RowId = $o(^CT.WDT.CDSS.TCMDiseJSymI("DiseDRIndex",TCMDiseDR,RowId))
			q:RowId=""
			
			s DiseaseDR = $lg($g(^CT.WDT.CDSS.TCMDiseJSymD(RowId)),9) 		//西医DR
			s DiseaseName=""
			s:DiseaseDR'="" DiseaseName=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseDR)),3)	//疾病名称
			
			s TCMSymDR = $lg($g(^CT.WDT.CDSS.TCMDiseJSymD(RowId)),3) //证型指向
			s SymptomName=""
			s:TCMSymDR'="" SymptomName=$lg($g(^CT.WDT.CDSS.TCMSymptomD(TCMSymDR)),3)
		  	d OutputRow
		} 
	}

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RowId,TCMDiseDR,DiseaseDR,DiseaseName,TCMSymDR,SymptomName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetDisListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDisListExecute ]
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

ClassMethod GetDisListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDisListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:胡宜良
/// CreatDate:2022-02-21
/// Description：保存中医疾病关联证候表的内容
/// Table：CT.WDT.CDSS.TCMDiseJSym
/// Input：web.CDSSEntity.CMKB.TCMDiseJSym 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// others:w ##class(web.CDSS.CMKB.TCMDiseJSym).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.TCMDiseJSym)
{
	//s $zt="ERROR"
	s result=""
	
	if $IsObject(eobj)
	{
        //b ;000
        s flag=..FormValidate1(eobj.RowId,eobj.TCMDiseDR,eobj.TCMSymDR,eobj.DiseaseDR)
		s ^TMP("HYL")=""
		if (flag=1)	 //校验重复
		{
			q "{success:'false',errorinfo:'该记录已存在！'}"
		}
		if (eobj.RowId="")  //如果RowId未赋值则增加
		{
			s obj=##class(CT.WDT.CDSS.TCMDiseJSym).%New()	
		}
		else  //如果RowId已赋值则修改
		{

			s obj=##class(CT.WDT.CDSS.TCMDiseJSym).%OpenId(eobj.RowId)
			s bobj = ##class(web.CDSSEntity.CMKB.TCMDiseJSym).%New()
			if $IsObject(obj.TCMDiseDR)
			{
			 	s bobj.TCMDiseDR = obj.TCMDiseDR.%Id()
			}
			if $IsObject(obj.TCMSymDR)
			{
			 	s bobj.TCMSymDR = obj.TCMSymDR.%Id()
			}
			/*if $IsObject(obj.DiseaseDR)
			{
			 	s bobj.DiseaseDR = obj.DiseaseDR.%Id()
			}*/
			s bobj.DiseaseDR = obj.DiseaseDR
			s bobj.UpdateDate = obj.UpdateDate
			s bobj.ResponUser = obj.ResponUser
			s bobj.ReviewUser = obj.ReviewUser
			s bobj.State = obj.State
			s bobj.Remarks= obj.Remarks
			
		}

		d:eobj.TCMDiseDR'="" obj.TCMDiseDRSetObjectId(eobj.TCMDiseDR)
		d:eobj.TCMSymDR'="" obj.TCMSymDRSetObjectId(eobj.TCMSymDR)
		
		s obj.UpdateDate = eobj.UpdateDate
		s obj.ResponUser = eobj.ResponUser
		s obj.ReviewUser = eobj.ReviewUser
		s obj.State = eobj.State
		s obj.Remarks= eobj.Remarks
		//s obj.DiseaseDR = eobj.DiseaseDR
		d:eobj.DiseaseDR'="" obj.DiseaseDRSetObjectId(eobj.DiseaseDR)
		s ^TMP("HYL")=^TMP("HYL")_1
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			//b ;0000
			s result = "{success:'true',id:'"_id_"'}" //返回RowId
			//b ;00
			//保存责任人、操作时间
			//d ##class(web.CDSS.CMKB.DiseJProperty).AddResponUser(eobj.TCMDiseDR,eobj.OperationUser)
			
			
			//保存日志
			d:eobj.RowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMDiseJSym","CT.WDT.CDSS.TCMDiseJSym","中医疾病关联证候",id,eobj.TCMSymDR,"A",eobj)
			d:eobj.RowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMDiseJSym","CT.WDT.CDSS.TCMDiseJSym","中医疾病关联证候",eobj.RowId,eobj.TCMSymDR,"U",eobj,bobj)
			
		}
		else
		{
			Trollback
			//b ;y
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("中医疾病关联证候","web.CDSS.CMKB.TCMDiseJSym","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
			
	}
	//b ;x
	q result
 /*ERROR
 s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("中医疾病关联证候","web.CDSS.CMKB.TCMDiseJSym","SaveData",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 b ;z
 q result= "{success:'false',errorinfo:'保存失败！'}"*/
}

/// Creator:胡宜良
/// CreatDate:2022-02-21
/// Description:数据重复验证方法,js调用
/// Table：CT.WDT.CDSS.TCMDiseJSym
/// Input:id, code
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.CDSS.CMKB.TCMDiseJSym).FormValidate("","1","")
ClassMethod FormValidate(id As %String, TCMDiseDR As %String, TCMSymDR As %String) As %String
{
	q:(TCMDiseDR="")||(TCMSymDR="") ""
	s flag="",flagc=""
	s flagc=$d(^CT.WDT.CDSS.TCMDiseJSymI("DiseSymIndex",TCMDiseDR,TCMSymDR))
	
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagc>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc=""
		s idc=$o(^CT.WDT.CDSS.TCMDiseJSymI("DiseSymIndex",TCMDiseDR,TCMSymDR,0))
  		
  		if ((idc'="")&(idc'=id)&(flagc>0)) s flag=1  //返回重复标志
  		else  s flag=0 //返回不重复标志
	}
	
	q flag
}

/// Other:w ##class(web.CDSS.CMKB.TCMDiseJSym).FormValidate1("","1279","24984","1725")
ClassMethod FormValidate1(id As %String, TCMDiseDR As %String, DiseaseDR As %String, TCMSymDR As %String) As %String
{
	s flag="",flagz=""
	if (TCMDiseDR'="")&(DiseaseDR)&(TCMSymDR){	
		s flagz=$d(^CT.WDT.CDSS.TCMDiseJSymI("TCMDiseSymIndex",TCMDiseDR,DiseaseDR,TCMSymDR))
		
		if (id="")	//如果为空，增加时的重复判断
		{
			if (flagz>0) s flag=1	//返回重复标志
			else  s flag=0 			//返回不重复标志
			
		}
		else 		//如果不为空，修改时的重复判断
		{
			s idd=""
			s idd=$o(^CT.WDT.CDSS.TCMDiseJSymI("TCMDiseSymIndex",TCMDiseDR,DiseaseDR,TCMSymDR,0))
			
			if (((idd'="")&(idd'=id)&(flagz>0))) s flag=1	//返回重复标志
			else  s flag=0 			//返回不重复标志								
		}	
	}
		q flag
}

/// Creator:胡宜良
/// CreatDate:2022-02-21
/// Description:删除中医疾病关联证候表
/// Table：CT.WDT.CDSS.TCMDiseJSym
/// Input: id 
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.CMKB.TCMDiseJSym).DeleteData("")
ClassMethod DeleteData(id As %String)
{
	s result=""
	Ts
	s obj=##class(CT.WDT.CDSS.TCMDiseJSym).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.CMKB.TCMDiseJSym).%New()
	if $IsObject(obj.TCMDiseDR)
	{
	 	s bobj.TCMDiseDR = obj.TCMDiseDR.%Id()
	}
	if $IsObject(obj.TCMSymDR)
	{
	 	s bobj.TCMSymDR = obj.TCMSymDR.%Id()
	}
	if $IsObject(obj.DiseaseDR)
	{
	 	s bobj.DiseaseDR = obj.DiseaseDR.%Id()
	}
	s bobj.UpdateDate = obj.UpdateDate
	s bobj.ResponUser = obj.ResponUser
	s bobj.ReviewUser = obj.ReviewUser
	s bobj.State = obj.State
	s bobj.Remarks= obj.Remarks
			
	s sc=##class(CT.WDT.CDSS.TCMDiseJSym).%DeleteId(id)
	if $$$ISOK(sc)
	{
			
		//同步删除辩证识别词
		s TCMDSJWordsID=""
		for{
			s TCMDSJWordsID=$o(^CT.WDT.CDSS.TCMDiseSymJWordsI("DiseSymDRIndex",id,TCMDSJWordsID)) q:TCMDSJWordsID=""
			s TCMDJWordresult= ##class(web.CDSS.CMKB.TCMDiseSymJWords).DeleteData(TCMDSJWordsID)
			if (TCMDJWordresult["false")
			{
				tro
				s result = "{success:'false',info:'辩证识别词同步删除失败！'}"
			}
		}
		Tc
		s result = "{success:'true',info:'删除成功！'}"
		//保存日志
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMDiseJSym","CT.WDT.CDSS.TCMDiseJSym","中医疾病关联证候",id,bobj.TCMSymDR,"D",bobj)
		d bobj.%Close()
	}
	else
	{
		Tro
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("中医疾病关联证候","web.CDSS.CMKB.TCMDiseJSym","DeleteData",bobj)
       	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

/// Creator:胡宜良 
/// CreatDate: 2022-07-29
/// Description：取消关联
/// Table：CT.WDT.CDSS.TCMDiseJSym 
/// Input: 
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.CDSS.CMKB.TCMDiseJSym).CancelMapping()
ClassMethod CancelMapping(TCMDiseDR, TCMSymDR)
{
	s result=""
	//q:id="" "{success:'false',errorinfo:'对象不存在！'}"
	for
		{
			s MappingID=$o(^CT.WDT.CDSS.TCMDiseJSymI("DiseSymIndex",TCMDiseDR,TCMSymDR))
			q:MappingID=""
			q:errorflag=1
			s re= ..DeleteData(MappingID)
			if (re["false")		//删除关联证型数据出错
			{
				s errorflag=1
			}
		}
			
	q result
}

/// Creator:胡宜良
/// CreatDate:2022-02-21
/// Description:通过id获取中医疾病关联证候内容
/// Table：CT.WDT.CDSS.TCMDiseJSym 
/// Input: id 中医疾病关联证候表id
/// Return: 中医疾病关联证候表内容
/// others:w ##class(web.CDSS.CMKB.TCMDiseJSym).OpenData("1")
ClassMethod OpenData(id As %String)
{
	s str=""	
	s eobj = ##class(web.CDSSEntity.CMKB.TCMDiseJSym).%New()
	//s id=$o(^CT.WDT.CDSS.TCMDiseJSymI("DiseSymIndex",id,0))
	s eobj.RowId= id
	s eobj.TCMDiseDR = $LISTGET($G(^CT.WDT.CDSS.TCMDiseJSymD(id)),2)
	s eobj.TCMSymDR= $lg($g(^CT.WDT.CDSS.TCMDiseJSymD(id)),3)
	s eobj.UpdateDate = $lg($g(^CT.WDT.CDSS.TCMDiseJSymD(id)),4)
	s eobj.ResponUser = $lg($g(^CT.WDT.CDSS.TCMDiseJSymD(id)),5)
	s eobj.ReviewUser= $lg($g(^CT.WDT.CDSS.TCMDiseJSymD(id)),6)
	s eobj.State= $lg($g(^CT.WDT.CDSS.TCMDiseJSymD(id)),7)
	s eobj.Remarks= $lg($g(^CT.WDT.CDSS.TCMDiseJSymD(id)),8)
	
	s str = eobj.JsonS()
	d eobj.%Close()
	q str
}

/// Creator:胡宜良
/// CreatDate:2022-02-24
/// Description:把疾病关联识别词转移到疾病关联证型表
/// Table:CT.WDT.CDSS.TCMDiseSymJWords、CT.WDT.CDSS.TCMDiseJSym
/// Input:DiseID 疾病的ID
/// Return:成功转移多少条数据
/// Other:w ##class(web.CDSS.CMKB.TCMDiseJSym).TransferSingleDataToDJI(3)
ClassMethod TransferSingleDataToDJI(DiseID)
{
	if (DiseID="")
	{
		q "请选中一条疾病！"
	}
	s count=0,fcount=0
	s DJFRowID=0
	for
	{
		s DJFRowID=$o(^CT.WDT.CDSS.TCMDiseJWordsI("DiseDRIndex",DiseID,DJFRowID)) q:DJFRowID=""
		s WordDR = $lg($g(^CT.WDT.CDSS.TCMDiseJWordsD(DJFRowID)),3)
		s WordsDesc =""
		s:WordDR'="" WordsDesc = $lg($g(^CT.WDT.CDSS.IdentifyWordsD(WordDR)),3)
		s TCMSymDR=$O(^CT.WDT.CDSS.TCMSymptomI("NameIndex"," "_$ZCONVERT(WordsDesc,"U"),""))
		continue:(TCMSymDR="")
		s eobj=##class(web.CDSSEntity.CMKB.TCMDiseJSym).%New()
		s eobj.TCMDiseDR=DiseID
		s eobj.TCMSymDR=TCMSymDR
		s eobj.SymptomName=TCMSymDR
		s eobj.UpdateDate= $lg($g(^CT.WDT.CDSS.TCMDiseJWordsD(DJFRowID)),4)
		s eobj.ResponUser= $lg($g(^CT.WDT.CDSS.TCMDiseJWordsD(DJFRowID)),5)
		s eobj.ReviewUser= $lg($g(^CT.WDT.CDSS.TCMDiseJWordsD(DJFRowID)),6)
		s eobj.State= $lg($g(^CT.WDT.CDSS.TCMDiseJWordsD(DJFRowID)),7)
		s eobj.Remarks= $lg($g(^CT.WDT.CDSS.TCMDiseJWordsD(DJFRowID)),8)
	
		s result=..SaveData(eobj)
		
		if (result["true")||(result["已存在")
		{
			s count=count+1
		}
		else
		{
			s fcount=fcount+1
		}
	}
	s result=count_"条转移成功！"_fcount_"条转移失败！"
	q result
}

/// Other:w ##class(web.CDSS.CMKB.TCMDiseJSym).ImportDataTXT("D:\TSM.txt")
ClassMethod ImportDataTXT(path) As %String
{
	s savecount=0
	s unsavecount=0
	s incount=0
	
	Set path1 = ##Class(%File).NormalizeFilename(path) //获取当前路径 D
	if '##class(%File).Exists(path1) 
	{
   		q "文件不存在"
    }
    Set file=##class(%File).%New(path)

	d file.Open("R")
	
	s TheMarkFlag=""
	
	s num=0
	k myFileAry
	TS
	for i=1:1:file.Size 
	{
		s data=file.Read()
		q:data=""
		s num=num+1
		continue:num=1  //跳过第一行
		s myFileAry(i)=data
		//s DiseaseCode=$p(data,$c(9),1)
		 
		s DiseaseName=$p(data,$c(9),2)    		
		continue:DiseaseName=""
		//s TCMDiseDR=$o(^CT.WDT.CDSS.TCMDiseaseI("NameIndex"," "_$ZCONVERT(DiseaseName,"U"),0))
		s TCMDiseDR=$o(^CT.WDT.CDSS.TCMDiseaseI("NameIndex",$ZCONVERT(DiseaseName,"U"),0))
		

	 	s SymptomName=$p(data,$c(9),3)
	 	continue:SymptomName="" 
	 	s TCMSymDR=$o(^CT.WDT.CDSS.TCMSymptomI("NameIndex"," "_$ZCONVERT(SymptomName,"U"),0))
		continue:TCMSymDR=""   	
        
        s DiseaseNamex=$p(data,$c(9),4)
	 	//continue:DiseaseNamex="" 
	 	s DiseaseDR=$o(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_$ZCONVERT(DiseaseNamex,"U"),0))
		//continue:DiseaseDR=""
		
		s eobj = ##class(web.CDSSEntity.CMKB.TCMDiseJSym).%New()
		s eobj.RowId = ""
		//s eobj.DiseaseCode = DiseaseCode
		s eobj.TCMDiseDR =TCMDiseDR
        s eobj.TCMSymDR=TCMSymDR
        s eobj.DiseaseDR=DiseaseDR

		s result=..SaveData(eobj)
		//b ;0
		if ((result'["false"))
		{	
			//b ;00
			s savecount=savecount+1
			
		}
		else
		{
			if (result'["存在")
			{
				b ;1
				s unsavecount=unsavecount+1
			}
			else
			{
			   	s incount=incount+1	
			}	
		}
	}	
	close file
    k file
	w "读取数据总共"_(num-1)_"条",!
	w "savecount："_savecount,!
	w "unsavecount："_unsavecount,!
	w "incount："_incount,!
	q "{success:'true'}"
}

/// Creator:胡宜良 
/// CreatDate: 2022-03-25
/// Description：关联
/// Table:CT.WDT.CDSS.TCMDiseJSym 
/// Input： idstr 诊断id串，dictid 疾病知识库id
/// Return：成功或失败
/// Other: w ##class(web.CDSS.CMKB.TCMDiseJSym).BatchMapping("1","16,13")
ClassMethod BatchMapping(tcmdiseDR As %String, dictidstr As %String)
{
	s saveid=""
    if (dictidstr'="")
    {
	s dicttotal=$l(dictidstr,",")
	for m=1:1:dicttotal
	{
		s dictid=$p(dictidstr,",",m)
		q:dictid=""
		s eobj=##class(web.CDSSEntity.CMKB.TCMDiseJSym).%New()
		s eobj.TCMDiseDR=tcmdiseDR
		s eobj.TCMSymDR=dictid
		//s eobj.SymptomName=TCMSymDR
			
	}
	s re=..SaveData(eobj)
	
	if (re["false")
	{
		s result="{success:'false',saveid:'"_tcmdiseDR_"'}"
	}
	else
	{
		if (dictidstr'="")
		{
			//d ..UpdateState(ID,"已关联")
		}
		s result="{success:'true',saveid:'"_tcmdiseDR_"'}"	
	}	
	q result
    }
    s result="{success:'false'}"	
	q result
}

/// Creator:胡宜良
/// CreatDate:2022-4-20
/// Description:保存中医疾病关联证型
/// Table:CT.WDT.CDSS.TCMDiseJSym
/// Input: TCMDiseDR, SymptomStr
/// others:w ##class(web.CDSS.CMKB.TCMDiseJSym).SaveSymData(1299,"^13")
ClassMethod SaveSymData(TCMDiseDR, SymptomStr)
{
	q:TCMDiseDR="" ""
	Ts
	s result=""
	s len=$Length(SymptomStr,",")
	for i=1:1:len{
		s Symptom=$p(SymptomStr,",",i)
		s RowId=$p(Symptom,"^",1)
		s TCMSymDR=$p(Symptom,"^",2)
		continue:(TCMSymDR="")
		
		if (RowId=""){ //中医疾病关联证型
			s objSymptom=##class(CT.WDT.CDSS.TCMDiseJSym).%New()
			d objSymptom.TCMDiseDRSetObjectId(TCMDiseDR)
			d:TCMSymDR'="" objSymptom.TCMSymDRSetObjectId(TCMSymDR)
			d:TCMSymDR="" objSymptom.TCMSymDRSetObjectId("")
			s objSymptom.UpdateDate = $zd($p($h,",",1),3)_" "_$zt($p($h,",",2),1)
			s objSymptom.ResponUser = $g(%session.Data("LOGON.USERNAME"))
			
			s scAdd=objSymptom.%Save() 
			d objSymptom.%Close()
			If $$$ISOK(scAdd) //新增数据存入数组
			{
				s arrExist(TCMDiseDR,objSymptom.%Id())=""
				
			}else{
				s result="false"
				Trollback
			}
			
		}else{ //前台原有数据存入数组
			s arrExist(TCMDiseDR,RowId)=""
		}	
	}
	
	s id=""
	for{
		s id=$o(^CT.WDT.CDSS.TCMDiseJSymI("DiseDRIndex",TCMDiseDR,id)) q:id=""
		continue:$d(arrExist(TCMDiseDR,id))	 //过滤现有数据
		//关联证型删除
		s scDel=##class(CT.WDT.CDSS.TCMDiseJSym).%DeleteId(id)
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

/// Creator:胡宜良
/// CreatDate:2022-08-04
/// Description:保存中医疾病关联疾病与关联证型
/// Table:CT.WDT.CDSS.TCMDiseJSym
/// Input: TCMDiseDR, DiseaseDR, TCMSymDR
/// others:w ##class(web.CDSS.CMKB.TCMDiseJSym).SaveTDSData("",7,728,16)
ClassMethod SaveTDSData(RowId, TCMDiseDR, DiseaseDR, TCMSymDR)
{
	
	s result=""
	//s:(DiseaseDR'=""&TCMSymDR'="") q:continue
	Quit:((DiseaseDR="")&(TCMSymDR="")) result="{success:'false',info:'保存失败,入参为空！'}" 
	s flag=..FormValidate1(RowId,TCMDiseDR,DiseaseDR,TCMSymDR)  //调用重复验证
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在'}"
			q result
		}
		
		if (RowId="")	//如果RowId未赋值则增加
		{
			s obj=##class(CT.WDT.CDSS.TCMDiseJSym).%New()	
		}
		else  			//如果RowId已赋值则修改
		{
			s obj=##class(CT.WDT.CDSS.TCMDiseJSym).%OpenId(RowId)
			s bobj = ##class(web.CDSSEntity.CMKB.TCMDiseJSym).%New()
			
			s bobj.TCMDiseDR = obj.TCMDiseDR  			//中医疾病指向
			s bobj.DiseaseDR = obj.DiseaseDR		    //疾病指向
			s bobj.TCMSymDR = obj.TCMSymDR		    	//证型指向
			
		}
		d obj.TCMDiseDRSetObjectId(TCMDiseDR)	
		d obj.DiseaseDRSetObjectId(DiseaseDR)
		d obj.TCMSymDRSetObjectId(TCMSymDR)	
		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			//d ##class(web.CDSS.CMKB.TCMDiseJSym).BatchMapping(TCMDiseDR,TCMSymDR)
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

/// Creator:胡宜良
/// CreatDate:2022-07-06
/// Input:TCMSymDR 证型ID State 状态
/// Return:
/// Other:w ##class(web.CDSS.CMKB.TCMDiseJSym).ChangeStatus(13,"上线","",1)
ClassMethod ChangeStatus(TCMSymDR, Opreation, OperaUser, DiseaseRowId)
{
	s result="{success:'true'}"
	s eobj = ##class(web.CDSSEntity.CMKB.TCMDiseJSym).%New()
	if (Opreation="提交") s eobj.State="待审核"
	if (Opreation="上线" )
	{
		s WordsName=""
		if ($d(^CT.WDT.CDSS.TCMDiseJSymI("SymIndex",TCMSymDR))&$d(^CT.WDT.CDSS.TCMDiseSymJWordsI("DiseSymDRIndex",DiseaseRowId)))
	 	{
		 	s DiseSymJWords=0
		 	for 
		 	{
			 	//s DiseSymJWords=$O(^CT.WDT.CDSS.TCMDiseJSymI("SymIndex",TCMSymDR,DiseSymJWords)) q:DiseSymJWords=""
			 	//s WordDR=$lg($g(^CT.WDT.CDSS.TCMDiseJSymD(DiseSymJWords)),3)
			 	
			 	s DiseSymJWords=$O(^CT.WDT.CDSS.TCMDiseSymJWordsI("DiseSymDRIndex",DiseaseRowId,DiseSymJWords)) q:DiseSymJWords=""
			 	s WordDR=$lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(DiseSymJWords)),3)
			 	if (WordDR'="")
			 	{
				 	s WordsDesc=$lg($g(^CT.WDT.CDSS.IdentifyWordsD(WordDR)),3)
					if ($d(^CT.WDT.CDSS.IdentifyWordsI("DescIndex"," "_$ZCONVERT(WordsDesc,"U"))))
					{
						s WordsRowId=$o(^CT.WDT.CDSS.IdentifyWordsI("DescIndex"," "_$ZCONVERT(WordsDesc,"U"),0))
						s WordsState=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsRowId)),5)
						if (WordsState'="已上线")
						{
							s:WordsName'="" WordsName=WordsName_","_WordsDesc
							s:WordsName="" WordsName=WordsDesc 
						}
					}
				}
			}
		 	
		}
		if (WordsName'="")	
		{
			return "{success:'false',errorinfo:'"_WordsName_"未完成拆分，不能上线！'}" 
		}
		else
		{
			s eobj.State="已上线"
		}	
	}
	
	
	if Opreation="不通过" s eobj.State="审核不通过"
	if Opreation="下线" s eobj.State="已下线"
	s eobj.TCMDiseDR=DiseaseRowId
	s eobj.TCMSymDR=TCMSymDR
	s eobj.ReviewUser=OperaUser
	s DiseaseName=$lg($g(^CT.WDT.CDSS.TCMDiseaseD(DiseaseRowId)),3)
	if ($d(^CT.WDT.CDSS.TCMDiseJSymI("SymIndex",TCMSymDR)))
 	{
	 	s TCMDiseJSymID=$O(^CT.WDT.CDSS.TCMDiseJSymI("DiseSymIndex",DiseaseRowId,TCMSymDR,0))
	 	s obj=##class(CT.WDT.CDSS.TCMDiseJSym).%OpenId(TCMDiseJSymID)
	 	s bobj = ##class(web.CDSSEntity.CMKB.TCMDiseJSym).%New()
	 	if $IsObject(obj.TCMDiseDR)
		{
		 	s bobj.TCMDiseDR = obj.TCMDiseDR.%Id()
		}
		if $IsObject(obj.TCMSymDR)
		{
		 	s bobj.TCMSymDR = obj.TCMSymDR.%Id()
		}
	 	s bobj.State=obj.State
	 	s bobj.ReviewUser=obj.ReviewUser
	 	s bobj.UpdateDate=obj.UpdateDate
	 	s obj.State=eobj.State
	 	s obj.ReviewUser=eobj.ReviewUser
	 	s obj.UpdateDate=$zdt($h,3)
	 	Ts
	 	s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" //返回RowId
			//保存日志 描述拼接操作，在日志中读取显示
			d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMDiseJSym","CT.WDT.CDSS.TCMDiseJSym","中医疾病关联证候表",TCMDiseJSymID,DiseaseName_"&&"_Opreation,"U",eobj,bobj)  
			
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("中医疾病关联证候表","web.CDSS.CMKB.TCMDiseJSym","ChangeStatus",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s obj=##class(CT.WDT.CDSS.TCMDiseJSym).%New()
		d:eobj.TCMDiseDR'="" obj.TCMDiseDRSetObjectId(eobj.TCMDiseDR)
		d:eobj.TCMSymDR'="" obj.TCMSymDRSetObjectId(eobj.TCMSymDR)
	 	s obj.State=eobj.State
	 	s obj.ReviewUser=eobj.ReviewUser
	 	s obj.UpdateDate=$zdt($h,3)
	 	Ts
	 	s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" //返回RowId
			//保存日志
			d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.TCMDiseJSym","CT.WDT.CDSS.TCMDiseJSym","中医疾病关联证候表",id,DiseaseName,"A",eobj)
			
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("中医疾病关联证候表","web.CDSS.CMKB.TCMDiseJSym","ChangeStatus",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	q result
}

/// Creator:胡宜良
/// CreatDate:2022-08-01
/// Input:TCMSymDR 
/// Return:TCMSiseJSymID
/// Other:w ##class(web.CDSS.CMKB.TCMDiseJSym).GetTCMSiseJSymid("13","3")
ClassMethod GetTCMSiseJSymid(TCMSymDR As %String, DiseaseID As %String) As %String
{
	
	s TCMSiseJSymID=""
	
	if (TCMSymDR'="")	//有数据
	{
		s TCMSiseJSymID=$o(^CT.WDT.CDSS.TCMDiseJSymI("DiseSymIndex",DiseaseID,TCMSymDR,0))	
	}
	/*s str=""	
	s eobj = ##class(web.CDSSEntity.CMKB.TCMDiseSymJWords).%New()
	s eobj.TCMDiseSymDR =TCMSiseJSymID

	s str = eobj.JsonS()
	d eobj.%Close()
	q str
	*/
	q TCMSiseJSymID
}

}
