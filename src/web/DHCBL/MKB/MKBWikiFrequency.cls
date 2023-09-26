Class web.DHCBL.MKB.MKBWikiFrequency Extends %RegisteredObject
{

/// Creator:陈代雷
/// CreatDate:2019-08-29
/// Description:保存-入参为表名^数据ID^数据描述
/// Table:SQLUser.MKB_WikiFrequency
/// Input:SaveDataStr：知识库名的Flag^中心词ID^中心词描述
/// Return:成功返回success:'true'和新增或修改的数据的ID;失败返回success:'false'和失败原因
/// w ##class(web.DHCBL.MKB.MKBWikiFrequency).SaveData("MKBWFTableName^MKBWFDataReference^MKBWFDesc")
/// w ##class(web.DHCBL.MKB.MKBWikiFrequency).SaveData("Loc^77547^传染病科")
ClassMethod SaveData(SaveDataStr) As %String
{
	s eobj=##class(web.Entity.MKB.MKBWikiFrequency).%New()
	s TableFlag=$P(SaveDataStr,"^",1)        //获得Flag
	s TableId=$o( ^User.MKBTermBaseI("FlagIndex"," "_$ZCONVERT(TableFlag,"U"),0)) //获得表的
	s eobj.MKBWFTableName="User.MKBTerm"_TableId                       //拼接表名
	s eobj.MKBWFDataReference=$P(SaveDataStr,"^",2)                                 //术语ID
	s eobj.MKBWFDesc=$P(SaveDataStr,"^",3)                        //描述
	S rs=##class(web.DHCBL.MKB.MKBWikiFrequency).SaveEntity(eobj)
	q rs
}

/// Creator:陈代雷
/// CreatDate:2019-08-30
/// Description:增加/修改 
/// Table:SQLUser.MKB_WikiFrequency
/// web.Entity.MKB.MKBWikiFrequency
/// Return:成功返回success:'true'和新增或修改的数据的ID;失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.Entity.MKB.MKBWikiFrequency) As %String
{
    s $ZT="ERROR"
	s result=""
	if $IsObject(eobj)
	{
		//s eobj.BDPDAFUserID=$g(%session.Data("LOGON.USERID"))
		//s eobj.BDPCTLocDR=$g(%session.Data("LOGON.CTLOCID"))
		q:(eobj.MKBWFTableName="")||(eobj.MKBWFDataReference="")||(eobj.MKBWFDesc="") "{success:'false',errorinfo:'没有获取到表名和术语信息！'}"
		
		//s uptablename=" "_$ZCONVERT(eobj.MKBWFTableName,"U")
		//s dataReference=" "_$ZCONVERT(eobj.MKBWFDataReference,"U")
		//s RowId=$o(^User.MKBWikiFrequencyI("TableReferenceIdx",uptablename,dataReference,0))
		//s eobj.ID=RowId

		//if (eobj.ID="")      
		//{
		s obj=##class(User.MKBWikiFrequency).%New()
		//s eobj.MKBWFFrequency=1  //新增时，频率为1 
		//}
		/*else                           
		{
			s obj=##class(User.MKBWikiFrequency).%OpenId(eobj.ID)
			
			s eobj.MKBWFFrequency=$listget($g(^User.MKBWikiFrequencyD(RowId)),5)+1  //修改时，频率加1
			
			s bobj=##class(web.Entity.MKB.MKBWikiFrequency).%New()
			
			s bobj.ID = eobj.ID
			s bobj.MKBWFTableName = obj.MKBWFTableName
			s bobj.MKBWFDataReference   = obj.MKBWFDataReference
			s bobj.MKBWFDesc = obj.MKBWFDesc
			s bobj.MKBWFFrequency = obj.MKBWFFrequency
			/*if $IsObject(obj.BDPDAFUserID){
					s bobj.BDPDAFUserID = obj.BDPDAFUserID.%Id() 
				}
			if $IsObject(obj.BDPCTLocDR){
					s bobj.BDPCTLocDR = obj.BDPCTLocDR.%Id() 
				}
			s bobj.BDPDAFType = obj.BDPDAFType*/
			
			
		//}
		s obj.MKBWFTableName = eobj.MKBWFTableName
		d obj.MKBWFDataReferenceSetObjectId(eobj.MKBWFDataReference)
		s obj.MKBWFDesc = eobj.MKBWFDesc
		//s obj.MKBWFFrequency = eobj.MKBWFFrequency
		//d obj.BDPDAFUserIDSetObjectId(eobj.BDPDAFUserID)
		//d obj.BDPCTLocDRSetObjectId(eobj.BDPCTLocDR)
		//s obj.BDPDAFType=eobj.BDPDAFType
		s sc=obj.%Save()
		do obj.%Close()
		if $$$ISOK(sc){
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
		}else{
			s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"    //返回错误信息
			
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
ERROR
	s result = "{success:'false',errorinfo:'"_$ze_"'}"
	q result
}

/// Creator:陈代雷
/// CreatDate:2019-8-30
/// Description:获取频次最高的前n条数据描述-入参1为表名，入参2为n
/// Table:SQLUser.MKB_WikiFrequency
/// Input:MKBFlag-知识库标志，n-前n条数据
/// Return返回频次最高的前n条数据描述 MKBWFDataReference : MKBWFDesc : MKBWFFrequency
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBWikiFrequency","GetHighestFreData","","")
Query GetHighestFreData(MKBFlag As %String, n As %Integer) As %Query(ROWSPEC = "MKBWFDataReference:%String,MKBWFDesc:%String,MKBWFFrequency:%Double")
{
}

ClassMethod GetHighestFreDataExecute(ByRef qHandle As %Binary, MKBFlag As %String, n As %Integer) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	k ^MKBFTMP
 	s TableId=$o( ^User.MKBTermBaseI("FlagIndex"," "_$ZCONVERT(MKBFlag,"U"),0)) //获得表的
	s MKBWFTableName="User.MKBTerm"_TableId                       //拼接表名
 	s MKBWFDataReference=0
 	s sum=0
 	//w MKBWFTableName,!
 	for
 	{
	 	s MKBWFDataReference=$o(^User.MKBWikiFrequencyI("TableReferenceIdx"," "_$ZCONVERT(MKBWFTableName,"U"),MKBWFDataReference))    //遍历对应知识库的术语
	 	q:MKBWFDataReference=""
	 	//w MKBWFDataReference,!
	 	s RowId=0
	 	s count=0
	 	for
	 	{
		 	s RowId=$o(^User.MKBWikiFrequencyI("TableReferenceIdx"," "_$ZCONVERT(MKBWFTableName,"U"),MKBWFDataReference,RowId))
		 	q:RowId=""
		 	s MKBFDate=$lg(^User.MKBWikiFrequencyD(RowId),5)
		 	s NowDate=$p($h,",",1)
		 	
			if ((NowDate-MKBFDate)<30)
			{
				s count=count+1
			}
	 	}
	 	if ($o(^MKBFTMP(count-1))'=count)
	 	{
		 	s ^MKBFTMP(count)=MKBWFDataReference
	 	}
	 	else
	 	{
		 	s ^MKBFTMP(count,sum)=MKBWFDataReference
		 	
	 	}
	 	s sum=sum+1
	 	//s Frequency=$lg(^User.MKBWikiFrequencyD(RowId),5)
	 	//s ^CDL(Frequency)=""           //将频率存入临时global中自动排序
	 	//s sum=sum+1
 	}
 	if (n>sum)             //当所要求数据大于总数据时
 	{
	 	s n=sum
 	}
 	s Frequency=$o(^MKBFTMP(""),-1)
 	for i=1:1:n
 	{
	 	
	 	s TermId=^MKBFTMP(Frequency)
	 	//w TermId,!
	 	s MKBFDesc=$lg(^User.MKBTermD(TermId),3)
	 	s MKBWFDataReference=TermId
	 	s MKBWFDesc=MKBFDesc
	 	s MKBWFFrequency=Frequency
	 	d OutputRow8
	 	if ($o(^MKBFTMP(Frequency,0))="")
	 	{
		 	s Frequency=$o(^MKBFTMP(Frequency),-1)
	 	}
	 	else
	 	{
		 	s Id=0
		 	for
		 	{
			 	s Id=$o(^MKBFTMP(Frequency,Id))
			 	q:Id=""
			 	s TermId=^MKBFTMP(Frequency,Id)
	 			s MKBFDesc=$lg(^User.MKBTermD(TermId),3)
	 			s MKBWFDataReference=TermId
	 			s MKBWFDesc=MKBFDesc
	 			s MKBWFFrequency=Frequency
	 			d OutputRow8
	 			s i=i+1
	 			if (i>=n)
	 			{
		 			q
	 			}
		 	}
		 	s Frequency=$o(^MKBFTMP(Frequency),-1)
		 	
	 	}
	 	
	 	
	 	
 	}
 	/*s Fre=0
 	for i=1:1:sum
 	{
	 	s Fre=$o(^CDL(Fre))
 	}
 	//w Fre
 	//w sum," "_n,!
 	if (n>sum)             //当所要求数据大于总数据时
 	{
	 	s n=sum
 	}
 	//w sum," "_n,!
 	s ID=0
 	//w MKBWFTableName,!
 	for i=1:1:n
 	{
	 	s ID=$o(^User.MKBWikiFrequencyI("TableFreqIdx"," "_$ZCONVERT(MKBWFTableName,"U"),Fre,ID))   // 根据表名和频率获得对应ID
	 	//w ID,!
	 	if (ID="")
	 	{
	 		s Fre=$o(^CDL(Fre),-1)
	 		s i=i-1
	 		continue
	 		
	 	}
	 	s MKBWFDataReference=$listget($g(^User.MKBWikiFrequencyD(ID)),3)
	 	s MKBWFDesc=$listget($g(^User.MKBWikiFrequencyD(ID)),4)
	 	s MKBWFFrequency=$listget($g(^User.MKBWikiFrequencyD(ID)),5)
	 	
	 	d OutputRow8
 	}*/
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(MKBWFDataReference,MKBWFDesc,MKBWFFrequency)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetHighestFreDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHighestFreDataExecute ]
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

ClassMethod GetHighestFreDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHighestFreDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:陈代雷
/// CreatDate:2019-9-16
/// Description:获取频次最高的前n条数据描述-入参1为表名，入参2为n
/// Table:SQLUser.MKB_WikiFrequency
/// Input:MKBFlag-知识库标志，n-前n条数据
/// Return返回频次最高的前n条数据描述 id^描述^频次：MKBWFDataReference^MKBWFDesc^MKBWFFrequency&&MKBWFDataReference^MKBWFDesc^MKBWFFrequency……
/// Other:w ##class(web.DHCBL.MKB.MKBWikiFrequency).HighestFreData("Loc",3)
ClassMethod HighestFreData(MKBFlag As %String, n As %Integer) As %String
{
	k ^MKBFTMP
 	s TableId=$o( ^User.MKBTermBaseI("FlagIndex"," "_$ZCONVERT(MKBFlag,"U"),0)) //获得知识库的id作为表名的后缀
	s MKBWFTableName="User.MKBTerm"_TableId                       //拼接表名
	w MKBWFTableName,!
 	s MKBWFDataReference=0
 	s sum=0
 	s result=""
 	//w MKBWFTableName,!
 	for
 	{
	 	s MKBWFDataReference=$o(^User.MKBWikiFrequencyI("TableReferenceIdx"," "_$ZCONVERT(MKBWFTableName,"U"),MKBWFDataReference))    //遍历对应知识库的术语
	 	q:MKBWFDataReference=""
	 	//w MKBWFDataReference,!
	 	s RowId=0
	 	s count=0
	 	for
	 	{
		 	s RowId=$o(^User.MKBWikiFrequencyI("TableReferenceIdx"," "_$ZCONVERT(MKBWFTableName,"U"),MKBWFDataReference,RowId))
		 	q:RowId=""
		 	s MKBFDate=$lg(^User.MKBWikiFrequencyD(RowId),5)
		 	s NowDate=$p($h,",",1)
		 	
			if ((NowDate-MKBFDate)<30)
			{
				s count=count+1
			}
	 	}
	 	if ($o(^MKBFTMP(count-1))'=count)
	 	{
		 	s ^MKBFTMP(count)=MKBWFDataReference
	 	}
	 	else
	 	{
		 	s ^MKBFTMP(count,sum)=MKBWFDataReference
		 	
	 	}
	 	s sum=sum+1
	 	//s Frequency=$lg(^User.MKBWikiFrequencyD(RowId),5)
	 	//s ^CDL(Frequency)=""           //将频率存入临时global中自动排序
	 	//s sum=sum+1
 	}
 	if (n>sum)             //当所要求数据大于总数据时
 	{
	 	s n=sum
 	}
 	s Frequency=$o(^MKBFTMP(""),-1)
 	for i=1:1:n
 	{
	 	
	 	s TermId=^MKBFTMP(Frequency)
	 	//w TermId,!
	 	s MKBFDesc=$lg(^User.MKBTermD(TermId),3)
	 	s MKBWFDataReference=TermId
	 	s MKBWFDesc=MKBFDesc
	 	s MKBWFFrequency=Frequency
	 	if (result="")
	 	{
		 	s result=MKBWFDataReference_"^"_MKBWFDesc_"^"_MKBWFFrequency
	 	}
	 	else
	 	{
		 	s result=result_"&&"_MKBWFDataReference_"^"_MKBWFDesc_"^"_MKBWFFrequency
	 	}
	 	
	 	if ($o(^MKBFTMP(Frequency,0))="")
	 	{
		 	s Frequency=$o(^MKBFTMP(Frequency),-1)
	 	}
	 	else
	 	{
		 	s Id=0
		 	for
		 	{
			 	if (i>=n)
	 			{
		 			q
	 			}
			 	s Id=$o(^MKBFTMP(Frequency,Id))
			 	q:Id=""
			 	s TermId=^MKBFTMP(Frequency,Id)
	 			s MKBFDesc=$lg(^User.MKBTermD(TermId),3)
	 			s MKBWFDataReference=TermId
	 			s MKBWFDesc=MKBFDesc
	 			s MKBWFFrequency=Frequency
	 			if (result="")
	 			{
		 			s result=MKBWFDataReference_"^"_MKBWFDesc_"^"_MKBWFFrequency
	 			}
	 			else
	 			{
		 			s result=result_"&&"_MKBWFDataReference_"^"_MKBWFDesc_"^"_MKBWFFrequency
	 			}
	 			s i=i+1
	 			
		 	}
		 	s Frequency=$o(^MKBFTMP(Frequency),-1)
		 	
	 	}
	 	
	 	
	 	
 	}
 	q result
}

/// Creator:陈代雷
/// CreatDate:2019-9-18
/// Description:入参是科室id(必有)，诊断描述（可为空），出参是诊断ID、描述、拼音码、备注
/// Table:User.MKB_Reference User.MKB_Term 
/// Input:LocID-科室id，Desc-诊断描述（可为空）
/// Return: 出参是诊断ID、描述、拼音码、备注 DiseaseRowId^DiseaseDese^DiseasePY^DiseaseNote&&DiseaseRowId^DiseaseDese^DiseasePY^DiseaseNote……
/// d ##class(web.DHCBL.MKB.MKBWikiFrequency).GetMKBInfoByLocId(166634,"")
ClassMethod GetMKBInfoByLocId(LocID As %String, Desc As %String) As %String
{
	s MKBMFChild = $O(^User.MKBKLMappingBaseFieldI("DescIndex",20," 诊断",0))  //获得规则注册中的列号
	s:Desc'="" Desc=$ZCONVERT(Desc,"U")
	s Flag=0
	if (LocID'="")
	{
		if ($D(^User.MKBReferenceI("InverAllIndex","T",LocID,"MD"))'=0)
		{
			s MDRowId = 0
			for
			{
				s MDRowId = $O(^User.MKBReferenceI("InverAllIndex","T",LocID,"MD",MDRowId))   //通过引用表获得与科室对照的诊断表的在映射表中的Rowid
				//w "诊断ID"_MDRowId,!	
				q:MDRowId=""
				continue:($D(^User.MKBKLMappingDetailI("BaseIndex",20,MDRowId))=0)	
				s RowNum = $LG($G(^User.MKBKLMappingDetailD(MDRowId)),4)       //获得行号
				s FlagMDRowId=$O(^User.MKBKLMappingDetailI("ValIndex",RowNum,20_"||"_MKBMFChild,0))  //通过行号列号定位到数据
				//w FlagMDRowId,!
				s DiseaseRowId = $LG($G(^User.MKBKLMappingDetailD(FlagMDRowId)),2)
				s DiseaseDese = $lg($g(^User.MKBTermD(DiseaseRowId)),3)
				s DiseasePY = $lg($g(^User.MKBTermD(DiseaseRowId)),6)
				s DiseaseNote = $lg($g(^User.MKBTermD(DiseaseRowId)),7)
				if (Flag=0)
				{
					if (($ZCONVERT(DiseaseDese,"U")[Desc))
					{
						w DiseaseRowId_"^"_DiseaseDese_"^"_DiseasePY_"^"_DiseaseNote
						s Flag=1
					}
				}
				else
				{
					if (($ZCONVERT(DiseaseDese,"U")[Desc))
					{
						w "&&"_DiseaseRowId_"^"_DiseaseDese_"^"_DiseasePY_"^"_DiseaseNote
					}
				}
			}	
		}	
	}
	q ""
}

/// Description:获取疾病列表
/// Table：User.MKBTerm
/// Input：rowid,desc:疾病描述
/// Output: rowID、中心词、拼音码、备注
/// d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBWikiFrequency","GetDataForCmb2","","")
Query GetDataForCmb2(rowid As %String, desc As %String) As %Query(ROWSPEC = "MKBTRowId:%String,MKBTDesc:%String,MKBTPYCode:%String,MKBTNote:%String")
{
}

ClassMethod GetDataForCmb2Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String) As %Status
{
	
	s repid=$I(^CacheTemp)
	s ind=1
	
	s base = ##class(web.DHCBL.MKB.MKBTermBase).GetIdByFlag("Diagnose")
	if (rowid'="") //根据rowid返回该条记录
	{
		s MKBTRowId=rowid
		s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTRowId)),3)  //描述
		s MKBTPYCode=$listGet($g(^User.MKBTermD(MKBTRowId)),6)  //检索码
		s MKBTNote=$listGet($g(^User.MKBTermD(MKBTRowId)),7)  //备注
		d OutputRowCmb
	}
	else
	{

		s MKBTRowId=""
		for  
		{	
			s MKBTRowId=$o(^User.MKBTermI("BaseIndex",base,MKBTRowId)) 
			q:MKBTRowId=""
			s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTRowId)),3)  //描述
			s MKBTPYCode=$listGet($g(^User.MKBTermD(MKBTRowId)),6)  //检索码
			s MKBTNote=$listGet($g(^User.MKBTermD(MKBTRowId)),7)  //备注
			
			s outDiaFlag=""  //输出标识
			if (desc'="")  //如果诊断不为空
			{
				s:desc'="" desc=$ZCONVERT(desc,"U")
				

				//可以根据检索码，描述来查询  				 			
				s isDescKey=($ZCONVERT(MKBTPYCode,"U")[desc) //检索码
				s isDesc=($ZCONVERT(MKBTDesc,"U")[desc)  //描述
				i (isDescKey)||(isDesc)
				{
					s outDiaFlag="Y"
				}
				
			}
			else  //如果诊断为空
			{
				s outDiaFlag="Y"
			}
					
			i (outDiaFlag="Y")   //条件
			{
				d OutputRowCmb
	        }

		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(MKBTRowId,MKBTDesc,MKBTPYCode,MKBTNote)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb2Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb2Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDataForCmb2Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb2Execute ]
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

/// Description:获取疾病列表
/// Table：User.MKBTerm
/// Input：rowid,desc:疾病描述(rowid和desc均可为空)
/// Output: rowID^中心词^拼音码^备注 MKBTRowId^MKBTDesc^MKBTPYCode^MKBTNote&&MKBTRowId^MKBTDesc^MKBTPYCode^MKBTNote……
/// w ##class(web.DHCBL.MKB.MKBWikiFrequency).GetDataForCmb("","")
ClassMethod GetDataForCmb(rowid As %String, desc As %String) As %String
{
	
	s Flag=0
	s result=""
	s base = ##class(web.DHCBL.MKB.MKBTermBase).GetIdByFlag("Diagnose")
	if (rowid'="") //根据rowid返回该条记录
	{
		s MKBTRowId=rowid
		s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTRowId)),3)  //描述
		s MKBTPYCode=$listGet($g(^User.MKBTermD(MKBTRowId)),6)  //拼音码
		s MKBTNote=$listGet($g(^User.MKBTermD(MKBTRowId)),7)  //备注
		s result=MKBTRowId_"^"_MKBTDesc_"^"_MKBTPYCode_"^"_MKBTNote
	}
	else
	{

		s MKBTRowId=""
		for  
		{	
			s MKBTRowId=$o(^User.MKBTermI("BaseIndex",base,MKBTRowId)) 
			q:MKBTRowId=""
			s MKBTDesc=$listGet($g(^User.MKBTermD(MKBTRowId)),3)  //描述
			s MKBTPYCode=$listGet($g(^User.MKBTermD(MKBTRowId)),6)  //拼音码
			s MKBTNote=$listGet($g(^User.MKBTermD(MKBTRowId)),7)  //备注
			
			s outDiaFlag=""  //输出标识
			if (desc'="")  //如果诊断不为空
			{
				s:desc'="" desc=$ZCONVERT(desc,"U")
				

				//可以根据检索码，描述来查询  				 			
				s isDescKey=($ZCONVERT(MKBTPYCode,"U")[desc) //检索码
				s isDesc=($ZCONVERT(MKBTDesc,"U")[desc)  //描述
				i (isDescKey)||(isDesc)
				{
					s outDiaFlag="Y"
				}
				
			}
			else  //如果诊断为空
			{
				s outDiaFlag="Y"
			}
					
			i (outDiaFlag="Y")   //条件
			{
				if (result="")
				{
					s result=MKBTRowId_"^"_MKBTDesc_"^"_MKBTPYCode_"^"_MKBTNote
					s Flag=1
				}
				else
				{
					s result=result_"&&"_MKBTRowId_"^"_MKBTDesc_"^"_MKBTPYCode_"^"_MKBTNote
				}
	        }

		}
	}
    q result
}

/// Description：查询诊断属性父表内容(即小程序title)
/// input：rowid:属性rowid（可为空）, termdr:疾病诊断id, desc:属性描述（可为空） 
/// output: 属性id（titleid）^属性内容（title描述）^属性值^属性类型^对应诊断Id^配置项^属性名^属性标识^公有属性标识^起始节点^顺序&&…… MKBTPRowId_"^"_MKBTPDesc_"^"_MKBTPDDesc_"^"_MKBTPType_"^"_MKBTPTermDr_"^"_MKBTPConfig_"^"_MKBTPName_"^"_MKBTPFlag_"^"_MKBTPPublic_"^"_MKBTPDefinedNode_"^"_MKBTPSequence
/// others:d ##class(web.DHCBL.MKB.MKBWikiFrequency).GetTitleData("",15805,"")
ClassMethod GetTitleData(rowid, termdr, desc) As %String
{
	s Flag=0
    if (rowid'="") //根据rowid返回该条记录
    {
        s MKBTPRowId=rowid
        s MKBTPDesc=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),3)
        s MKBTPType=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),4)
        
        s MKBTPDDesc=##class(web.DHCBL.MKB.MKBTermProperty).GetDetail(MKBTPType,MKBTPRowId)  //缩略名
        s MKBTPTermDr=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),6)
        s Config=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),5)
        if (MKBTPType="R")||(MKBTPType="CB")||(MKBTPType="C")
        {
            s:Config'="" MKBTPConfig=$LISTGET($G(^User.MKBTermBaseD(Config)),3)
            s:Config="" MKBTPConfig=""
        }
        else{
            s MKBTPConfig=Config
            
        }
        s MKBTPName=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),7)
        s MKBTPFlag=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),8)
        s MKBTPPublic=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),9)
        s DefinedNode=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),10)
        
        s:DefinedNode'="" MKBTPDefinedNode=$listget($g(^User.MKBTermD(DefinedNode)),3) 
        s:DefinedNode="" MKBTPDefinedNode="" 
        
        s MKBTPSequence=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),11)
        w MKBTPRowId_"^"_MKBTPDesc_"^"_MKBTPDDesc_"^"_MKBTPType_"^"_MKBTPTermDr_"^"_MKBTPConfig_"^"_MKBTPName_"^"_MKBTPFlag_"^"_MKBTPPublic_"^"_MKBTPDefinedNode_"^"_MKBTPSequence
    }
    else
    {
        if (termdr'=""){
            s:desc'="" desc=$ZCONVERT(desc,"U")
            s MKBTPRowId=0
            for  
            {   
                s MKBTPRowId=$o(^User.MKBTermPropertyI("TermIndex",termdr,MKBTPRowId)) q:MKBTPRowId="" 
                s MKBTPDesc=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),3)
                s MKBTPDescU=$ZCONVERT(MKBTPDesc,"U")
                s MKBTPType=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),4)
                s MKBTPDDesc=##class(web.DHCBL.MKB.MKBTermProperty).GetDetail(MKBTPType,MKBTPRowId)  //缩略名
                continue:MKBTPDDesc=""
                s MKBTPTermDr=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),6)
                s Config=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),5)
                if (MKBTPType="S")||(MKBTPType="SD")||(MKBTPType="T")
                {
                    s:Config'="" MKBTPConfig=$LISTGET($G(^User.MKBTermBaseD(Config)),3)
                    s:Config="" MKBTPConfig=""
                }
                else{
                    s MKBTPConfig=Config
                    
                }
                s MKBTPName=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),7)
                s MKBTPFlag=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),8)
                s MKBTPPublic=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),9)
                s DefinedNode=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),10)
                s:DefinedNode'="" MKBTPDefinedNode=$listget($g(^User.MKBTermD(DefinedNode)),3) 
                s:DefinedNode="" MKBTPDefinedNode="" 
        
                s MKBTPSequence=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),11)
                
                s PINYIN=""
                s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBTPDescU)
                i ((MKBTPDescU[desc)||(PINYIN[desc))   //条件
                {
                    if (Flag=0)
					{
						w MKBTPRowId_"^"_MKBTPDesc_"^"_MKBTPDDesc_"^"_MKBTPType_"^"_MKBTPTermDr_"^"_MKBTPConfig_"^"_MKBTPName_"^"_MKBTPFlag_"^"_MKBTPPublic_"^"_MKBTPDefinedNode_"^"_MKBTPSequence
						s Flag=1
					}
					else
					{
						w "&&"_MKBTPRowId_"^"_MKBTPDesc_"^"_MKBTPDDesc_"^"_MKBTPType_"^"_MKBTPTermDr_"^"_MKBTPConfig_"^"_MKBTPName_"^"_MKBTPFlag_"^"_MKBTPPublic_"^"_MKBTPDefinedNode_"^"_MKBTPSequence
					}
                }       
            }
        }
    }
    q ""
}

/// Creator：谷雪萍
/// CreatDate: 2018-04-02
/// Description：引用属性类型属性内容维护模块-获取已选属性列表
/// Table：User.MKBTermProperty
/// Input：Property:属性Id
/// return: 属性id^属性^展示格式^属性格式^顺序^定义节点^单选多选 (S/D)^是否必填（Y/N）^术语T或属性P MKBTPRowId,MKBTPDesc,MKBTPShowType,MKBTPType,MKBTPOrder,MKBTPTreeNode,MKBTPChoice,MKBTPRequired,MKBTPTOrP
/// others:d ##class(web.DHCBL.MKB.MKBWikiFrequency).GetSelPropertyData()
ClassMethod GetSelPropertyData(property As %String) As %String
{
    if (property'="")
    {
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
	          s MKBTPChoice=$p(argstr,"&",4)  //单选多选 (S/D)
	          s:MKBTPChoice="" MKBTPChoice="S"   //默认是单选
	          s MKBTPRequired=$p(argstr,"&",5)  //是否必填（Y/N）
	          s:MKBTPRequired="" MKBTPRequired="N"  //默认不必填
	          s MKBTPTOrP=$p(argstr,"&",6)  //术语T或属性P
	          s:MKBTPTOrP="" MKBTPTOrP="P"  //默认属性P
	          s MKBTPOrder=i
	          s MKBTPDesc="",MKBTPType=""
	          if (MKBTPTOrP="T")   //术语
	          {
		          s MKBTPDesc=$LISTGET($G(^User.MKBTermBaseD(MKBTPRowId)),3) //术语库描述 
		          s MKBTPType=$LISTGET($G(^User.MKBTermBaseD(MKBTPRowId)),4)  //术语库格式
	          }
	          else   //属性
	          {
	          	  s MKBTPDesc=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),3) //属性描述 
	          	  s MKBTPType=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),4)  //属性格式
	          }
	          
	          w MKBTPRowId_"^"_MKBTPDesc_"^"_MKBTPShowType_"^"_MKBTPType_"^"_MKBTPOrder_"^"_MKBTPTreeNode_"^"_MKBTPChoice_"^"_MKBTPRequired_"^"_MKBTPTOrP
	        }
		}
    }
    q ""
}

/// Description：用户参与编辑的疾病列表（包含状态、失败原因） 
/// input：rowid, desc:描述， flag="M"（必传）, username:用户名
/// return: MKBKMRowId(RowId)^MKBKMCode(代码)^MKBKMDesc(描述)^MKBKMSource(出处)^MKBKMType(类型)^MKBKMUpdateUser(上传人)^SSUSRName(上传人姓名)^MKBKMUpdateDate(上传时间)^MKBKMFlag(审核状态)^MKBKMNote(备注)^MKBKMPath(路径)^MKBKMTermDr(术语Id)^MKBKMProDr(属性Id)^MKBKMUpdateLoc(科室)^MKBKMDetail(扩展属性Id串)^MKBKMMiniFlag(微信小程序(mini)和电脑端(computer)的区分标志)^MKBKMFailureReason(审核不通过的原因)
/// others:d ##class(web.DHCBL.MKB.MKBWikiFrequency).GetKnoManageData("","","M","")
ClassMethod GetKnoManageData(rowid As %String, desc As %String, flag As %String, username As %String) As %String
{
 s len=0
 s TmpFlag=0
 if (rowid'="") //根据rowid返回该条记录
 {
    s MKBKMRowId=rowid
    s MKBKMCode=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),2)
    s MKBKMDesc=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),3)
    s MKBKMPath=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),4)
    s MKBKMSource=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),5)
    s MKBKMType=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),6)
    s SSUSRName=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),7)
    //s:MKBKMUpdateUser'="" SSUSRName=$p($g(^SSU("SSUSR",MKBKMUpdateUser)),"^",2)//2019-09-09
    //s:MKBKMUpdateUser="" SSUSRName=""
    s MKBKMUpdateDate=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),8)
    s:MKBKMUpdateDate'="" MKBKMUpdateDate=$zd(MKBKMUpdateDate,3)
    s MKBKMFlag=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),9)
    s MKBKMNote=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),10)
    s MKBKMUpdateLoc = $LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),11)
    s:MKBKMUpdateLoc'="" MKBKMUpdateLoc=$p($g(^CTLOC(MKBKMUpdateLoc)),"^",2)
    s:MKBKMUpdateLoc="" MKBKMUpdateLoc=""
    s MKBKMTermDr = $LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),12)
    s:MKBKMTermDr'="" MKBKMTermDr=$LISTGET($g(^User.MKBTermD(MKBKMTermDr)),3)
    s MKBKMProDr = $LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),13)
    s:MKBKMProDr'="" MKBKMProDr=$LISTGET($g(^User.MKBTermPropertyD(MKBKMProDr)),3)
    s MKBKMDetailo =  $LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),14)
    s:MKBKMDetailo'="" len = $L(MKBKMDetailo,"^")
    s MKBKMDetail=""
    for i=0:1:len
    {
       s MKBKMDetaili=$p($g(MKBKMDetailo),"^",i)
       s DetailiDesc = ##class(web.DHCBL.MKB.MKBTermProDetail).GetDesc(MKBKMDetaili)
       s:MKBKMDetail'="" MKBKMDetail=MKBKMDetail_"^"_DetailiDesc
       s:MKBKMDetail="" MKBKMDetail=DetailiDesc
    }
    s MKBKMMiniFlag=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),15)
    s MKBKMFailureReason=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),16)
    w MKBKMRowId_"^"_MKBKMCode_"^"_MKBKMDesc_"^"_MKBKMSource_"^"_MKBKMType_"^"_SSUSRName_"^"_MKBKMUpdateDate_"^"_MKBKMFlag_"^"_MKBKMNote_"^"_MKBKMPath_"^"_MKBKMTermDr_"^"_MKBKMProDr_"^"_MKBKMUpdateLoc_"^"_MKBKMDetail_"^"_MKBKMMiniFlag_"^"_MKBKMFailureReason
 }
 else
 {
    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    s MKBKMRowId=""
    for{  
        s MKBKMRowId=$o(^User.MKBKnoManageD(MKBKMRowId),-1) q:MKBKMRowId=""   
        s MKBKMCode=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),2)
        s MKBKMDesc=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),3)
        s MKBKMPath=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),4)
        s MKBKMSource=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),5)
        s MKBKMType=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),6)
        s SSUSRName=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),7)
        //s:MKBKMUpdateUser'="" SSUSRName=$p($g(^SSU("SSUSR",MKBKMUpdateUser)),"^",2)
        //s:MKBKMUpdateUser="" SSUSRName=""
        s MKBKMUpdateDate=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),8)
        s:MKBKMUpdateDate'="" MKBKMUpdateDate=$zd(MKBKMUpdateDate,3)
        s MKBKMFlag=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),9)
        /*s:(MKBKMFlag'="Y")&&(MKBKMFlag'="N") MKBKMFlag="初传"
        s:MKBKMFlag="N" MKBKMFlag="审核未通过"
        s:MKBKMFlag="Y" MKBKMFlag="审核通过"*/
        s MKBKMNote=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),10)
        s MKBKMUpdateLoc = $LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),11)
        s:MKBKMUpdateLoc'="" MKBKMUpdateLoc=$p($g(^CTLOC(MKBKMUpdateLoc)),"^",2)
        s:MKBKMUpdateLoc="" MKBKMUpdateLoc=""
        s MKBKMTermDr = $LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),12)
        s:MKBKMTermDr'="" MKBKMTermDr=$LISTGET($g(^User.MKBTermD(MKBKMTermDr)),3)
        s MKBKMProDr = $LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),13)
        s:MKBKMProDr'="" MKBKMProDr=$LISTGET($g(^User.MKBTermPropertyD(MKBKMProDr)),3)
        s MKBKMDetailo =  $LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),14)
        s:MKBKMDetailo'="" len = $L(MKBKMDetailo,"^")
        s MKBKMDetail=""
        for i=0:1:len
        {
           s MKBKMDetaili=$p($g(MKBKMDetailo),"^",i)
           s DetailiDesc = ##class(web.DHCBL.MKB.MKBTermProDetail).GetDesc(MKBKMDetaili)
           s:MKBKMDetail'="" MKBKMDetail=MKBKMDetail_"^"_DetailiDesc
           s:MKBKMDetail="" MKBKMDetail=DetailiDesc
        }
        s MKBKMMiniFlag=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),15)
   		s MKBKMFailureReason=$LISTGET($G(^User.MKBKnoManageD(MKBKMRowId)),16)

        s PINYIN=""
        s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBKMDesc)  
        if ((($ZCONVERT(MKBKMDesc,"U")[desc)||(PINYIN[desc)) && (MKBKMMiniFlag[flag) && (SSUSRName[username))
        {
            if (TmpFlag=0)
				{
					w MKBKMRowId_"^"_MKBKMCode_"^"_MKBKMDesc_"^"_MKBKMSource_"^"_MKBKMType_"^"_SSUSRName_"^"_MKBKMUpdateDate_"^"_MKBKMFlag_"^"_MKBKMNote_"^"_MKBKMPath_"^"_MKBKMTermDr_"^"_MKBKMProDr_"^"_MKBKMUpdateLoc_"^"_MKBKMDetail_"^"_MKBKMMiniFlag_"^"_MKBKMFailureReason
					s Flag=1
				}
				else
				{
					w "&&"_MKBKMRowId_"^"_MKBKMCode_"^"_MKBKMDesc_"^"_MKBKMSource_"^"_MKBKMType_"^"_SSUSRName_"^"_MKBKMUpdateDate_"^"_MKBKMFlag_"^"_MKBKMNote_"^"_MKBKMPath_"^"_MKBKMTermDr_"^"_MKBKMProDr_"^"_MKBKMUpdateLoc_"^"_MKBKMDetail_"^"_MKBKMMiniFlag_"^"_MKBKMFailureReason
				}
        }
    }
 }

    q ""
}

}
