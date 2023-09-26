/// Creator:高姗姗
/// CreatDate:2020-12-23
/// Description：文献关联诊断
Class web.CDSS.CMKB.DocuJoinDisease Extends %RegisteredObject
{

/// Creator:高姗姗
/// CreatDate:2020-12-23
/// Description:获得文献关联诊断
/// Table: CT.WDT.CDSS.DocuJoinDisease
/// Input: DocuDR 
/// Return:返回文献关联诊断
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.DocuJoinDisease","GetList","7")
Query GetList(DocuDR) As %Query(ROWSPEC = "RowId,DiseaseDR,DiseaseName,WordsDR,WordsDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, DocuDR) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	if (DocuDR'=""){
		s RowId=""
		for
		{
			s RowId = $o(^CT.WDT.CDSS.DocuJoinDiseaseI("DocuIndex",DocuDR,RowId))
			q:RowId=""
			s DiseaseDR = $lg($g(^CT.WDT.CDSS.DocuJoinDiseaseD(RowId)),3) //诊断指向
			s DiseaseName=""
			s:DiseaseDR'="" DiseaseName=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseDR)),3)
			
			s WordsDR = $lg($g(^CT.WDT.CDSS.DocuJoinDiseaseD(RowId)),7) //诊断指向,识别类型识别词
			s WordsDesc=""
			s:WordsDR'="" WordsDesc=$lg($g(^CT.WDT.CDSS.IdentifyWordsD(WordsDR)),3)
			if (WordsDR=""){
				s WordsDR = $lg($g(^CT.WDT.CDSS.DocuJoinDiseaseD(RowId)),6) //诊断指向，诊断类型识别词
				s WordsDesc=""
				s:WordsDR'="" WordsDesc=$lg($g(^CT.WDT.CDSS.IdentifyWordsD(WordsDR)),3)
			}
			continue:WordsDesc=""
		  	d OutputRow
		  	
		} 
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RowId,DiseaseDR,DiseaseName,WordsDR,WordsDesc)
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
/// Creator:高姗姗
/// CreatDate:2020-12-25
/// Description:保存文献关联诊断
/// Table: CT.WDT.CDSS.DocuJoinDisease
/// Input: DocuDR, DiseaseStr
/// others:w ##class(web.CDSS.CMKB.DocuJoinDisease).SaveData(7308,"")
ClassMethod SaveData(DocuDR, DiseaseStr)
{
	q:DocuDR="" ""
	Ts
	s result=""
	s len=$Length(DiseaseStr,",")
	for i=1:1:len{
		s Disease=$p(DiseaseStr,",",i)
		s RowId=$p(Disease,"^",1)
		s DiseaseDR=$p(Disease,"^",2)
		continue:(DiseaseDR="")
		if (RowId=""){ //文献关联诊断新增
			s objDisease=##class(CT.WDT.CDSS.DocuJoinDisease).%New()
			d objDisease.DocuDRSetObjectId(DocuDR)
			d:DiseaseDR'="" objDisease.DiseaseDRSetObjectId(DiseaseDR)
			d:DiseaseDR="" objDisease.DiseaseDRSetObjectId("")
			s objDisease.DocuModifyDate = $zd($p($h,",",1),3)_" "_$zt($p($h,",",2),1)
			s objDisease.DocuModifyUser = $Get(%session.Data("LOGON.USERNAME")) 
			s scAdd=objDisease.%Save() 
			d objDisease.%Close()
			If $$$ISOK(scAdd) //新增数据存入数组
			{
				s arrExist(DocuDR,objDisease.%Id())=""
			}else{
				s result="false"
				Trollback
			}
			
		}else{ //前台原有数据存入数组
			s arrExist(DocuDR,RowId)=""
		}	
	}
	
	s id=""
	for{
		s id=$o(^CT.WDT.CDSS.DocuJoinDiseaseI("DocuIndex",DocuDR,id)) q:id=""
		continue:$d(arrExist(DocuDR,id))	 //过滤现有数据
		//关联诊断删除
		s scDel=##class(CT.WDT.CDSS.DocuJoinDisease).%DeleteId(id)
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
/// Creator:ZWW
/// CreatDate:2022-08-16
/// Description:保存文献关联诊断条件-识别词
/// Table: CT.WDT.CDSS.DocuJoinDisease
/// Input: DocuDR, WordsStr
/// others:w ##class(web.CDSS.CMKB.DocuJoinDisease).SaveData(7308,"")
ClassMethod SaveData(DocuDR, WordsStr)
{
	q:DocuDR="" ""
	Ts
	s result=""
	s len=$Length(WordsStr,",")
	for i=1:1:len{
		s Words=$p(WordsStr,",",i)
		s RowId=$p(Words,"^",1)
		s WordsDR=$p(Words,"^",2)
		continue:(WordsDR="")
		if (RowId=""){ //文献关联诊断条件新增
			s objWords=##class(CT.WDT.CDSS.DocuJoinDisease).%New()
			d objWords.DocuDRSetObjectId(DocuDR)
			s WordsType=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsDR)),4)
			if (WordsType="识别条件"){
				d objWords.IWordsDRSetObjectId(WordsDR)
			} elseif (WordsType="诊断条件"){
				d objWords.WordsDRSetObjectId(WordsDR)
			}
			//d:WordsDR'="" objWords.WordsDRSetObjectId(WordsDR)
			//d:WordsDR="" objWords.WordsDRSetObjectId("")
			s objWords.DocuModifyDate = $zd($p($h,",",1),3)_" "_$zt($p($h,",",2),1)
			s objWords.DocuModifyUser = $Get(%session.Data("LOGON.USERNAME")) 
			s scAdd=objWords.%Save() 
			d objWords.%Close()
			If $$$ISOK(scAdd) //新增数据存入数组
			{
				s arrExist(DocuDR,objWords.%Id())=""
			}else{
				s result="false"
				Trollback
			}
			
		}else{ //前台原有数据存入数组
			s arrExist(DocuDR,RowId)=""
		}	
	}
	
	s id=""
	for{
		s id=$o(^CT.WDT.CDSS.DocuJoinDiseaseI("DocuIndex",DocuDR,id)) q:id=""
		continue:$d(arrExist(DocuDR,id))	 //过滤现有数据
		//关联诊断条件删除
		s scDel=##class(CT.WDT.CDSS.DocuJoinDisease).%DeleteId(id)
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

/// Creator:ZWW
/// CreatDate:2022-08-17
/// Description:文献关联诊断数据转移【取疾病——》取识别词[诊断条件]】
/// Table: CT.WDT.CDSS.DocuJoinDisease
/// Input: DocuDR, WordsStr
/// others:d ##class(web.CDSS.CMKB.DocuJoinDisease).TransferData()
ClassMethod TransferData()
{
	s readcount=0,savecount=0,unsavecount=0
	s RowId=""
	for
	{
		
		s RowId = $o(^CT.WDT.CDSS.DocuJoinDiseaseD(RowId),1) q:RowId=""
		
		s DiseaseDR = $lg($g(^CT.WDT.CDSS.DocuJoinDiseaseD(RowId)),3) //原诊断指向
		if DiseaseDR="" continue
		s DiseaseName=""
		s:DiseaseDR'="" DiseaseName=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseDR)),3) 
		if DiseaseName="" continue
		s readcount=readcount+1
		s WordsType="诊断条件"
		s WordsRowId=""
		//s WordsRowId=$o(^CT.WDT.CDSS.IdentifyWordsI("DescTypeIndex",$ZCONVERT(DiseaseName,"U"),WordsType,WordsRowId)) 
		s WordsRowId=$o(^CT.WDT.CDSS.IdentifyWordsI("DescTypeIndex",DiseaseName,WordsType,WordsRowId)) 
		if (WordsRowId=""){
			w !,RowId_"^"_DiseaseName
			
		}else{
			s obj=##class(CT.WDT.CDSS.DocuJoinDisease).%OpenId(RowId)
			d obj.WordsDRSetObjectId(WordsRowId)
			
			s sc=obj.%Save() 
			d obj.%Close()
			If $$$ISOK(sc) 
			{
				s savecount=savecount+1
			}else{
				s unsavecount=unsavecount+1
				w !,RowId_"保存失败"
			}  
		}	
	}
	w !,"readcount:"_readcount,"savecount:"_savecount,"unsavecount:"_unsavecount
}

/// Creator:ZWW
/// CreatDate:2022-08-17
/// Description:文献关联诊断数据转移【取疾病——》取识别词[识别条件]】
/// Table: CT.WDT.CDSS.DocuJoinDisease
/// Input: DocuDR, WordsStr
/// others:d ##class(web.CDSS.CMKB.DocuJoinDisease).TransferIWData()
ClassMethod TransferIWData()
{
	s readcount=0,savecount=0,unsavecount=0
	s RowId=""
	for
	{
		
		s RowId = $o(^CT.WDT.CDSS.DocuJoinDiseaseD(RowId),1) q:RowId=""
		
		s DiseaseDR = $lg($g(^CT.WDT.CDSS.DocuJoinDiseaseD(RowId)),3) //原诊断指向
		continue:DiseaseDR="" 
		s DiseaseName=""
		s:DiseaseDR'="" DiseaseName=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseDR)),3) 
		continue:DiseaseName="" 
		s readcount=readcount+1
		s WordsType="识别条件"
		s WordsRowId=""
		//s WordsRowId=$o(^CT.WDT.CDSS.IdentifyWordsI("DescTypeIndex",$ZCONVERT(DiseaseName,"U"),WordsType,WordsRowId)) 
		s WordsRowId=$o(^CT.WDT.CDSS.IdentifyWordsI("DescTypeIndex",DiseaseName,WordsType,WordsRowId)) 
		if (WordsRowId=""){
			w !,RowId_"^"_DiseaseName
			
		}else{
			s obj=##class(CT.WDT.CDSS.DocuJoinDisease).%OpenId(RowId)
			d obj.IWordsDRSetObjectId(WordsRowId)
			
			s sc=obj.%Save() 
			d obj.%Close()
			If $$$ISOK(sc) 
			{
				s savecount=savecount+1
			}else{
				s unsavecount=unsavecount+1
				w !,RowId_"保存失败"
			}  
		}	
	}
	w !,"readcount:"_readcount,"savecount:"_savecount,"unsavecount:"_unsavecount
}

/// Creator:ZWW
/// CreatDate:2022-08-17
/// Description:文献关联诊断数据转移时识别词中不存在的诊断数据
/// Table: CT.WDT.CDSS.DocuJoinDisease
/// Input: DocuDR, WordsStr
/// others:w ##class(web.CDSS.CMKB.DocuJoinDisease).InexistWordsData()
ClassMethod InexistWordsData()
{
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
   	s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName=time_"导出数据.txt"
	s file=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\"_fileName
	
    o file:"WNS"
    u file
    w "关联表ID	文献ID	中文文献名称	疾病/诊断ID	关联诊断名称"   
    
	s RowId=""
	for
	{
		
		s RowId = $o(^CT.WDT.CDSS.DocuJoinDiseaseD(RowId)) q:RowId=""
		s DocuDR = $lg($g(^CT.WDT.CDSS.DocuJoinDiseaseD(RowId)),2)
		s DocuDesc = $lg($g(^CT.WDT.CDSS.DocuManageD(DocuDR)),3) //中文文献名称
		s DiseaseDR = $lg($g(^CT.WDT.CDSS.DocuJoinDiseaseD(RowId)),3) //原诊断指向
		if DiseaseDR="" continue
		s DiseaseName=""
		s:DiseaseDR'="" DiseaseName=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseDR)),3)
		if DiseaseName="" continue
		
		s WordsType="诊断条件"
		s WordsRowId=""
		//s WordsRowId=$o(^CT.WDT.CDSS.IdentifyWordsI("DescTypeIndex",$ZCONVERT(DiseaseName,"U"),WordsType,WordsRowId)) 
		s WordsRowId=$o(^CT.WDT.CDSS.IdentifyWordsI("DescTypeIndex",DiseaseName,WordsType,WordsRowId)) 
		if (WordsRowId=""){
			w !,RowId_"	"_DocuDR_"	"_DocuDesc_"	"_DiseaseDR_"	"_DiseaseName
			
		}
	}
	c file
	q fileName
}

/// Creator:赵文伟
/// CreatDate:2022-08-31
/// Description:文献关联诊断数据转移【诊断条件识别词WordsDR——》识别条件识别词IWordsDR】
/// Table: CT.WDT.CDSS.DocuJoinDisease
/// Input: 
/// others:d ##class(web.CDSS.CMKB.DocuJoinDisease).TransferWordsData()
ClassMethod TransferWordsData()
{
	s readcount=0,savecount=0,unsavecount=0
	s RowId=""
	for
	{
		
		s RowId = $o(^CT.WDT.CDSS.DocuJoinDiseaseD(RowId),1) q:RowId=""
		
		s WordsDR = $lg($g(^CT.WDT.CDSS.DocuJoinDiseaseD(RowId)),6) //诊断指向，原诊断类型识别词
		if WordsDR="" continue
		s WordsDesc=""
		s:WordsDR'="" WordsDesc=$lg($g(^CT.WDT.CDSS.IdentifyWordsD(WordsDR)),3)
		if WordsDesc="" continue
		s readcount=readcount+1
		s WordsType="识别条件"
		s WordsRowId=""
		s WordsRowId=$o(^CT.WDT.CDSS.IdentifyWordsI("DescTypeIndex",WordsDesc,WordsType,WordsRowId)) 
		if (WordsRowId=""){
			w !,RowId_"^"_WordsDesc
			
		}else{
			s obj=##class(CT.WDT.CDSS.DocuJoinDisease).%OpenId(RowId)
			d obj.IWordsDRSetObjectId(WordsRowId)
			
			s sc=obj.%Save() 
			d obj.%Close()
			If $$$ISOK(sc) 
			{
				s savecount=savecount+1
			}else{
				s unsavecount=unsavecount+1
				w !,RowId_"保存失败"
			}  
		}	
	}
	w !,"readcount:"_readcount,"savecount:"_savecount,"unsavecount:"_unsavecount
}

/// Creator:赵文伟
/// CreatDate:2022-08-31
/// Description:文献关联诊断数据转移时识别词中不存在的诊断数据[识别条件类型]
/// Table: CT.WDT.CDSS.DocuJoinDisease
/// Input: 
/// others:w ##class(web.CDSS.CMKB.DocuJoinDisease).InexistIdentWordsData()
ClassMethod InexistIdentWordsData()
{
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
   	s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName=time_"导出数据.txt"
	s file=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\"_fileName
	
    o file:"WNS"
    u file
    w "关联表ID	文献ID	中文文献名称	诊断条件识别词ID	关联诊断名称"   
    
	s RowId=""
	for
	{
		
		s RowId = $o(^CT.WDT.CDSS.DocuJoinDiseaseD(RowId)) q:RowId=""
		s DocuDR= $lg($g(^CT.WDT.CDSS.DocuJoinDiseaseD(RowId)),2)
		s DocuDesc = $lg($g(^CT.WDT.CDSS.DocuManageD(DocuDR)),3) //中文文献名称
	
		s WordsDR = $lg($g(^CT.WDT.CDSS.DocuJoinDiseaseD(RowId)),6) //诊断指向，原诊断类型识别词
		if WordsDR="" continue
		s WordsDesc=""
		s:WordsDR'="" WordsDesc=$lg($g(^CT.WDT.CDSS.IdentifyWordsD(WordsDR)),3)
		
		s WordsType="识别条件"
		
		if '($d(^CT.WDT.CDSS.IdentifyWordsI("DescTypeIndex",WordsDesc,WordsType))){
			w !,RowId_"	"_DocuDR_"	"_DocuDesc_"	"_WordsDR_"	"_WordsDesc
			
		}
	}
	c file
	q fileName
}

/// Creator:赵文伟
/// CreatDate:2022-10-25
/// Description:
/// Table: CT.WDT.CDSS.DocuJoinDisease
/// Input: 文献关联诊断表中，关联的诊断类型的识别词保存对应的识别类型识别词
/// others:d ##class(web.CDSS.CMKB.DocuJoinDisease).MoveData()
ClassMethod MoveData()
{
	s readcount=0,savecount=0,unsavecount=0
	s RowId=""
	for
	{
		s RowId = $o(^CT.WDT.CDSS.DocuJoinDiseaseD(RowId)) q:RowId=""
		s WordsDR = $lg($g(^CT.WDT.CDSS.DocuJoinDiseaseD(RowId)),6) //诊断指向，诊断类型识别词
		s IWordsDR = $lg($g(^CT.WDT.CDSS.DocuJoinDiseaseD(RowId)),7) //诊断指向，识别类型识别词
		s readcount=readcount+1
		if ((IWordsDR="")&&(WordsDR'="")){
			s WordsDesc=$LISTGET($G(^CT.WDT.CDSS.IdentifyWordsD(WordsDR)),3) 
			continue:WordsDesc=""
			s IWordsDR = $o(^CT.WDT.CDSS.IdentifyWordsI("DescTypeIndex",WordsDesc,"识别条件",IWordsDR))
			
			if (IWordsDR'=""){
				s obj=##class(CT.WDT.CDSS.DocuJoinDisease).%OpenId(RowId)
				d obj.IWordsDRSetObjectId(IWordsDR)
				
				s sc=obj.%Save() 
				d obj.%Close()
				If $$$ISOK(sc) 
				{
					s savecount=savecount+1
				}else{
					s unsavecount=unsavecount+1
					w !,RowId_"保存失败"
				}  
			}
		}
	}
	w !,"readcount:"_readcount,"savecount:"_savecount,"unsavecount:"_unsavecount
}

}
