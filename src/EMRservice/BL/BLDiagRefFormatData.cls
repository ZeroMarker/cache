Class EMRservice.BL.BLDiagRefFormatData Extends %RegisteredObject
{

/// Desc:		诊断数据格式化字符串
/// Creator:	lifengbo
/// CreateDate: 2019-08-14
/// Input:      AEpisodeID：就诊ID
///      		ALinkUnitName：链接单元标志
/// 				ADiagType：诊断类型，PRE 初步诊断
/// 				DiagnoseObjJson : 前端医生站传入诊断对象字符串
/// Output:  	输出诊断数据格式化后字符串
/// Debug:
/// w ##class(EMRservice.BL.BLDiagRefFormatData).GetDiagRefFormatData("4674","diagnosesLayerV8","PRE",jsonstring)
/// w ##class(EMRservice.BL.BLDiagRefFormatData).GetDiagRefFormatData("4674","diagnosesLayerV8","C008")
ClassMethod GetDiagRefFormatData(AEpisodeID As %String, ALinkUnitName As %String, ADiagType As %String = "PRE", DiagnoseObjJson As %String = "") As %String
{
	s result=""
	 
	s diagRefStyleID=""
	s diagRefStyleID = $o(^DHCEMRM.DiagRefStyleDataI("IdxUnitLinkNameActive"," "_$zcvt(ALinkUnitName,"U")," Y",diagRefStyleID))
	if (diagRefStyleID="") 
	{
		s result="DiagRefFormatData Is Not Exist"
		q result
	}
	
	//s json = [{"TypeDesc":"初步诊断","ICDDesc":"食管裂孔疝test","MemoDesc":"备注211","ICDCode":"K44.901","EvaluationDesc":"确诊","UserName":"医生01","Date":"2018-03-26","BillFlagDesc":"西医","BillFlag":0,"Level":"1"},{"TypeDesc":"初步诊断","ICDDesc":"食管裂孔疝","MemoDesc":"","ICDCode":"K44.901","EvaluationDesc":"确诊","UserName":"医生01","Date":"2018-04-08","BillFlagDesc":"西医","BillFlag":0,"Level":"1"},{"TypeDesc":"初步诊断","ICDDesc":"肺占位性病变","MemoDesc":"备注3","ICDCode":"R91.x03","EvaluationDesc":"确诊","UserName":"医生01","Date":"2018-04-08","BillFlagDesc":"西医","BillFlag":0,"Level":"2"},{"TypeDesc":"初步诊断","ICDDesc":"下颌后缩","MemoDesc":"","ICDCode":"K07.106","EvaluationDesc":"确诊","UserName":"医生01","Date":"2018-05-30","BillFlagDesc":"西医","BillFlag":0,"Level":"1"},{"TypeDesc":"初步诊断","ICDDesc":"夜盲","MemoDesc":"","ICDCode":"H53.600","EvaluationDesc":"确诊","UserName":"医生01","Date":"2018-05-30","BillFlagDesc":"西医","BillFlag":0,"Level":"1"}]
	//s DiagnoseObjJson = json.%ToJSON()
	
	s result = ..GetLinkUnitSchemeData(AEpisodeID,ALinkUnitName,ADiagType,diagRefStyleID,DiagnoseObjJson)
	q result
}

/// Desc:		诊断数据格式化字符串
/// Creator:	lifengbo
/// CreateDate: 2019-08-14
/// Input:      AEpisodeID：就诊ID
///      		ALinkUnitName：链接单元标志
/// 				ADiagType：诊断类型，PRE 初步诊断 
/// 				ADiagRefStyleID:诊断数据格式要求配置表ID EMRmeta.DiagRefStyleData
/// 				DiagnoseObjJson : 前端医生站传入诊断对象字符串
/// Output:  	输出诊断数据格式化后字符串
/// Debug:
/// w ##class(EMRservice.HISInterface.PatientInfoAssist).GetLinkUnitSchemeData(94,"diagnosesLayerV8","PRE")
/// {"name":"diagnosesLayerV8","type":"PRE"}
ClassMethod GetLinkUnitSchemeData(AEpisodeID As %String, ALinkUnitName As %String, ADiagType As %String, ADiagRefStyleID As %String = "", DiagnoseObjJson As %String = "") As %String
{
	q:(ALinkUnitName="") 0
	//diagnosesLayerV8
	
	s objDiagRefStyle=##class(EMRmeta.DiagRefStyleData).%OpenId(ADiagRefStyleID)
	
	//获取展现type配置
	s displayType = objDiagRefStyle.DisplayType
	
	//获取展现category配置
	s displayCategory = objDiagRefStyle.DisplayCategory
	
	//获取中医诊断样式
	s tcmDiagStyle = objDiagRefStyle.TCMDiagStyle
	
	//序号
	s orderNum = objDiagRefStyle.OrderNumber
	
	//获取样式数据配置
	s diagRefSytleConfig = objDiagRefStyle.ConfigData
	
	s diagCateOrder=$case(diagRefSytleConfig,"WC":-1,"CW":1)
	
	//获取诊断分隔符
	s mainDiagStyle = objDiagRefStyle.MainDiagStyle
	s typeSeparate = $case(mainDiagStyle,"Layer":"\n","Row":"")
	s categorySeparate = $case(mainDiagStyle,"Layer":"\n","Row":"")
	s separate = $case(mainDiagStyle,"Layer":"\n","Row":"")
	s unitSpace = $case(mainDiagStyle,"Layer":"    ","Row":"")
	
	//中医诊断分隔符
	s tcmDiagStyle = objDiagRefStyle.TCMDiagStyle
	s tcmSeparate = $case(tcmDiagStyle,"sublayer":"\n","subbehind":"")

	//显示诊断开立人与时间
	s tmpnamedate = "N"
	
	//序号显示控制，
	//一级诊断序号"."，效果：1.		2.  3.  
	//二级诊断序号")"，效果：1) 	2)	3)
	s interpunction = ".^)"
	
	//备注默认值 非ICD直接显示备注信息。 ICD诊断备注显示在"()"内。
	s memosep = "()"
	
	s MRADMID = ""
	s MRADMID = $p(^PAADM(AEpisodeID),"^",61)
   
   	if (DiagnoseObjJson="")
   	{
	   	//诊断数据来源
	   	//1.医生站诊断录入_诊断数据接口
	    //s rSC = ##class(%ResultSet).%New("web.DHCDocDiagnosEntryV8:DiagnosList")
	    s rSC = ##class(%ResultSet).%New("EMRservice.BL.BLDiagRefFormatData:DiagnosList")
	    
	    //2.结构化诊断知识库_诊断数据接口
	    //s rSC = ##class(%ResultSet).%New("web.DHCDocDiagnosEntryV8:DiagnosList")
	    //s rSC = ##class(%ResultSet).%New("EMRservice.BL.BLDiagRefFormatData:DiagnosList")
	    
	    q:(rSC.QueryIsValid()=0) "Query Is Not Exsit"
		d rSC.Execute(MRADMID)
	
   	}
    else
    {
	    s rSC = ##class(%ResultSet).%New("EMRservice.BL.BLDiagRefFormatData:DiagnosListFromJson")
	    q:(rSC.QueryIsValid()=0) "Query Is Not Exsit"
		d rSC.Execute(DiagnoseObjJson)
		    
	}
    
    

	//因ResultSet没法返回到起始位置多次循环，无法满足后续的代码
	//未找到ResultSet中，将当前cusor行的数据拷贝出来的方法。
	//将结果转换成临时数据，易于遍历，取值。
	
	s rowNum=""
	s ColumnCount=rSC.GetColumnCount()
	s repid=$i(^CacheTemp)
	
	k CacheTemp(repid,"EMRDiagInfo")
	//转换诊断类型
	//MRC_DiagnosType
	//1	DIS	出院诊断	N
	//3	PRE	初步诊断	N
	//4	C008	入院诊断	N
	//5	OP	门诊诊断	N
	s DiagTypeDesc=$case(ADiagType,"PRE":"^初步诊断^","DIS":"^出院诊断^","OP":"^门诊诊断^","C008":"^入院诊断^","PRE,C008":"^初步诊断^入院诊断^","MOD":"^修正诊断^","SUPP":"^补充诊断^")
	
	while rSC.%Next() {
		
		//continue:(DiagTypeDesc'= rSC.Data("DiagnosType"))
		continue:(DiagTypeDesc'[ ("^"_rSC.Data("DiagnosType")_"^"))
		
		set rowNum = $i(rowNum)
		s diagData = ##Class(%ArrayOfDataTypes).%New()
		
	 	for column = 1:1:ColumnCount 
	 	{
		 	
			s columnValue = rSC.%GetData(column)
			s columnValue = $replace(columnValue,"&nbsp","")
			s columnName =  rSC.GetColumnName(column)
			d diagData.SetAt(columnValue,columnName)
			
		}
		
		s CacheTemp(repid,"EMRDiagInfo",rowNum) = diagData
	}	
	
	
	s typeList = "",tmpRowID="",ListNum="",ListWithDUNum="",BillFlagList=""
	for
	{
		s tmpRowID=$o(CacheTemp(repid,"EMRDiagInfo",tmpRowID))
		q:(tmpRowID="")
		
		s tmpArray = CacheTemp(repid,"EMRDiagInfo",tmpRowID)
		

		//s ItemTypeDesc = tmpArray.GetAt("DiagnosType")
		if (displayType = "Y")
		{
			s ItemTypeDesc = $case(tmpArray.GetAt("DiagnosType"),"出院诊断":"出院诊断","门诊诊断":"门诊诊断",:"初步诊断")
		}
		else
		{
			//当诊断类型不显示时，通过重置数据Global数据构成，防止中西医等分类重复的问题。
			s ItemTypeDesc = "忽略诊断类型"
		}
		s ItemBillFlag = $case(tmpArray.GetAt("DiagnosCat"),"西医":"西医",:"中医")
		s ItemDate = tmpArray.GetAt("DiagnosDate")
		s ItemUserName = tmpArray.GetAt("DiagnosDoctor")
		//设定诊断类型临时global
		s:($listfind(BillFlagList,ItemBillFlag)=0) BillFlagList=BillFlagList_$lb(ItemBillFlag)
		
		s CacheTemp(repid,"EMRDiagInfoTypeList",ItemTypeDesc,ItemBillFlag,$i(ListNum)) = tmpArray
		
		//处理住院证导入诊断，缺少诊断录入医生和日期
		if ((tmpnamedate="Y")&&((ItemDate'="")&&(ItemUserName'="")))
		{
			s CacheTemp(repid,"EMRDiagInfoTypeListWithDateUser",ItemTypeDesc,ItemBillFlag,ItemDate,ItemUserName,$i(ListWithDUNum)) = tmpArray
		}
		
	}
	
	
	s result ="",seqLevel1="",seq=0
	if (tmpnamedate = "Y")
	{
	}
	else
	{
		s tmpType=""
		for
		{
			s tmpType=$o(CacheTemp(repid,"EMRDiagInfoTypeList",tmpType))	
			q:(tmpType="")
			
			if (displayType = "Y")
			{
				///因换行符为 下一个循环补上，导致切换Type缺少诊断结束换行符号
				s:($l(result)>0) result = result _ separate
				
				s result = result_tmpType_":"_typeSeparate
			}
			
			s tmpBillFlag=""
			for
			{
				s tmpBillFlag=$o(CacheTemp(repid,"EMRDiagInfoTypeList",tmpType,tmpBillFlag),diagCateOrder)
				q:(tmpBillFlag="")
				if (($ll(BillFlagList) >1) && (displayCategory = "Y"))
				{
					s:((tmpType '="")&&(displayType = "Y")) result = result_unitSpace
					if (tmpBillFlag="西医")
					{
						///因换行符为 下一个循环补上，导致切换Category缺少诊断结束换行符号
						s:($l(result)>7) result = result _ separate
						
						s result = result_"西医诊断:"
					}
					else
					{
						///因换行符为 下一个循环补上，导致切换Category缺少诊断结束换行符号
						s:($l(result)>7) result = result _ separate
						
						s result = result_"中医诊断:"
					}
					
					s result = result_categorySeparate
				}
				s tmpItemID="",preDiagLevel=""
				s seqLevel1="",tmpResult=""
				for
				{
					s tmpItemID=$o(CacheTemp(repid,"EMRDiagInfoTypeList",tmpType,tmpBillFlag,tmpItemID))
					q:(tmpItemID="")
					
					s tmpDiagItemData = CacheTemp(repid,"EMRDiagInfoTypeList",tmpType,tmpBillFlag,tmpItemID)
					
					s level = tmpDiagItemData.GetAt("DiagnosLeavel")
					
					
					//实现中医诊断
			        if ((tmpBillFlag ="中医")&&(tcmDiagStyle="subbehind"))
			        {
				        
				        if (level = 2)&&(preDiagLevel=1)
				        {
					        s tmpResult = tmpResult_"("
							
				        }
				        if (level = 1)&&(preDiagLevel=2)
				        {
					    	s tmpResult = tmpResult_")"_ separate
							 
					    }
					    if (level = 2)&&(preDiagLevel=2)
					    {
						    //中医证型间内部分隔符
						    s tmpResult = tmpResult_";"
						}
						
			        }
			        else
			        {
				    	s:(tmpResult'="") tmpResult = tmpResult _ separate    
				    }
			        
			        s result = result _tmpResult
			        
					s tmpResult=""
					
					
					///诊断缩进
					
					if ((tmpBillFlag ="中医")&&(tcmDiagStyle="subbehind")&&(level = 2))
					{
						//中医诊断格式为subbehind
						//中医诊断 证型 不参与缩进。
						
					}
					else
					{
						s:((tmpType '="")&&(displayType = "Y")) tmpResult = tmpResult _ unitSpace
			            s:(("" '= tmpBillFlag)&&(($ll(BillFlagList) >1))) tmpResult = tmpResult _ unitSpace
						
				        s level = tmpDiagItemData.GetAt("DiagnosLeavel")
				        s space = ..getSpace(level,mainDiagStyle,unitSpace)
				        
				        s tmpResult = tmpResult_space
 					}
 					
 					///诊断序号
			        if (level = 1) 
			        {
			        	s seqLevel1 = $case(seqLevel1,"" :1,:(+$g(seqLevel1)+1))
			        }
			        else 
			        {
				        //处理住院证导入诊断，缺少诊断subseq
			            s subseq = $case(preDiagLevel, level:(+$g(subseq)+1) ,: 1) 
			        }
			            
			        //序号逻辑
			        //开启序号：
			        //1.西医诊断显示序号
			        //2.中医诊断subbehind模式，1级诊断显示序号 
			        //3.中医诊断sublayer模式，显示序号   
			        //关闭序号：
			        //不显示序号 
			       if (orderNum="Y")&&((tmpBillFlag ="西医")||((tmpBillFlag ="中医")&&((level=1)||(tcmDiagStyle="sublayer"))))
			       {
				        s tmpResult = tmpResult _ $case(level, 1 :seqLevel1 ,: subseq)
				            
						if ($l(interpunction,"^") >0) 
						{
							s tmpResult = tmpResult _ $p(interpunction,"^",level)
						}
			        }
					//增加前缀代码
					s tmpResult = tmpResult _ tmpDiagItemData.GetAt("DiagnosPrefix")_tmpDiagItemData.GetAt("DiagnosICDDesc")
					//诊断状态 疑诊、确诊
					if (tmpDiagItemData.GetAt("DiagnosStatus") = "疑诊")
					{
						s tmpResult = tmpResult _ "?"
					}
					//备注 string  / list
					//string
					s diagnosNotesList = tmpDiagItemData.GetAt("DiagnosNotes")
					
					if (diagnosNotesList="")
					{
						if ($zstrip(tmpDiagItemData.GetAt("DiagnosNotes"),"*C")'="")
						{
							if (memosep = "()")
							{
								if (tmpDiagItemData.GetAt("MRCIDCode") = "")
								{
									s tmpResult = tmpResult _ tmpDiagItemData.GetAt("DiagnosNotes")
								}
								else
								{
									s tmpResult = tmpResult _ "("_tmpDiagItemData.GetAt("DiagnosNotes")_")"
								}
							}
							else
							{
								s tmpResult = tmpResult _ memosep _ tmpDiagItemData.GetAt("DiagnosNotes")
							}
				        }
					}
					else
					{
						///备注信息返回值为list
						
						if ($LISTVALID(diagnosNotesList)=1)
						{
							if ($zstrip($list(diagnosNotesList,1),"*C")'="")
							{
								if (memosep = "()")
								{
									if (tmpDiagItemData.GetAt("MRCIDCode") = "")
									{
										s tmpResult = tmpResult _ $list(diagnosNotesList,1)
									}
									else
									{
										s tmpResult = tmpResult _ "("_$list(diagnosNotesList,1)_")"
									}
								}
								else
								{
									s tmpResult = tmpResult _ memosep _ tmpDiagItemData.GetAt("DiagnosNotes")
								}
					        }
						}
						else{
							if ($zstrip(diagnosNotesList,"*C")'="")
							{
								if (memosep = "()")
								{
									if (tmpDiagItemData.GetAt("MRCIDCode") = "")
									{
										s tmpResult = tmpResult _ $zstrip(diagnosNotesList,"*C")
									}
									else
									{
										s tmpResult = tmpResult _ "("_$zstrip(diagnosNotesList,"*C")_")"
									}
								}
								else
								{
									s tmpResult = tmpResult _ memosep _ tmpDiagItemData.GetAt("DiagnosNotes")
								}
					        }
						
						}
					}
			        if ((tmpBillFlag ="中医")&&(tcmDiagStyle="subbehind"))
					{
						//level=2  tcmDiagStyle="subbehind"  中医下一个为空，补充")"
						if (level = 2)
						{
							s nexttmpItemID = ""
							s nexttmpItemID = $o(CacheTemp(repid,"EMRDiagInfoTypeList",tmpType,tmpBillFlag,tmpItemID))
							if (nexttmpItemID="")
							{
								s tmpResult = tmpResult_")"
							}
						}
					}
			        
			        s preDiagLevel = level
			        
				}
				
				//将最后一个生成的tmpResult 拼接到返回结果中，
				//否则会丢失一个诊断
				s result = result _tmpResult
				
				if (mainDiagStyle = "Row")
				{
					//s result = $e(result,1,($l(result)-$l(separate,"^"))) _ "。"
					s result = result_ "。"
				}
            
			}
		}
	}
	
			   
    Quit result
}

/// Desc:		诊断数据格式化字符串
/// Creator:	lifengbo
/// CreateDate: 2019-08-14
/// Input:      level：诊断级别
///      		schemetype：显示模式 Row，同行显示模式。
/// 				AUnitSpace：单位缩进量
/// Output:  	输出级别缩进量
/// Debug:
/// 		d ##class(EMRservice.BL.BLDiagRefFormatData).getSpace(2,)
ClassMethod getSpace(level As %String, schemetype As %String, AUnitSpace As %String) As %String
{
		s result = ""
		q:(level = 1) result
		
		//s result = $case(schemetype ,"row":"",:"    ")
		
		for i=1:1:(level-1)
		{
			s result = result_$case(schemetype ,"Row":"",:AUnitSpace)
		}
		q result
}

/// Desc:		
/// 			获取患者本次就诊诊断列表(优化数据来源，走医生站诊断统一接口）
/// Creator:	lifengbo
/// CreateDate: 2019-08-14
/// Input:      MRADMID:
///      		ICDType:
/// 			DiagnosTypeCode：
/// 			LogonCTLocRowId：
/// Output:  	
/// Debug:
/// d ##class(%ResultSet).RunQuery("EMRservice.BL.BLDiagRefFormatData","DiagnosList",4674)
Query DiagnosList(MRADMID As %String = "", ICDType As %String = "", DiagnosTypeCode As %String = "", LogonCTLocRowId As %String = "") As %Query(ROWSPEC = "MRCIDRowId:%String,MRDIARowId:%String,DiagnosCat:%String,DiagnosType:%String,DiagnosLeavel:%String,DiagnosICDDesc:%String,MainDiagFlag:%String,DiagnosNotes:%String,MRCIDCode:%String,DiagnosStatus:%String,DiagnosOnsetDate:%String,DiagnosDate:%String,SyndromeDesc:%String,MRDIAMRDIADR:%String,DiagnosStatusRowId:%String,DiagnosTypeRowId:%String,DiagnosDoctor:%String,DiagnosBodyPart:%String,DiagnosBodyPartRowId:%String,DiagnosPrefix:%String")
{
}

ClassMethod DiagnosListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DiagnosListExecute ]
{
	Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

ClassMethod DiagnosListExecute(ByRef qHandle As %Binary, MRADMID As %String = "", ICDType As %String = "", DiagnosTypeCode As %String = "", LogonCTLocRowId As %String = "") As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(MRADMID="") $$$OK
	
	Set RetStr="",NO=1
	k TempArr("FindDiagnos",repid)
	
	s defaultDiagnosTypeID=""
	if DiagnosTypeCode'="" {
		s defaultDiagnosTypeID=$O(^MRC("DTYP",0,"Code",DiagnosTypeCode,0))
	}
	s Id=0
	
	Set obj=##class(%ResultSet).%New("DHCDoc.Interface.Inside.Service:DiagnosList")	
	d obj.Execute(MRADMID,"","")
	
	/*
	诊断接口输出字段

		DiagnosDesc						诊断描述
		DiagnosValue					患者诊断ID
		DiagnosCodeRowid				诊断表ID
		DiagnosMRDesc					备注信息
		DiagnosICDCode					ICD编码
		DiagnosType						诊断类型
		DiagnosDate						时间
		DiagnosOnsetDate:%String		发病时间
		DiagStat:%String				诊断状态：确诊、疑诊
		DiagnosLeavel:%String			诊断级别
		MainDiagFlag:%String			主诊断
		DiagnosPrefix:%String			前缀

	*/

	while (obj.Next())
	{
		s (DiagnosCodeRowid,DiagnosValue,DiagnosCat,DiagnosType ,DiagnosLeavel,DiagnosDesc,MainDiagFlag,DiagnosMRDesc) = ""
		s (DiagnosICDCode,DiagStat,Id,DiagnosOnsetDate,DiagnosDate,SyndromeDesc,MRDIAMRDIADR,DiagStatDr,MRDiagnosTypeDr) = ""
		s (DiagnosDoctor,BodyPartDesc,BodyPartDr) = ""
		
		s DiagnosCodeRowid = obj.Data("DiagnosCodeRowid")
		s DiagnosValue = obj.Data("DiagnosValue")
		
		s DiagnosType = obj.Data("DiagnosType")
		s DiagnosLeavel = obj.Data("DiagnosLeavel")
		s DiagnosDesc = obj.Data("DiagnosDesc")
		//主诊断标记
		s MainDiagFlag = $case(obj.Data("MainDiagFlag"),"Y":"是",:"否")
		//备注
		s DiagnosMRDesc = obj.Data("DiagnosMRDesc")
		s DiagnosICDCode = obj.Data("DiagnosICDCode")
		s DiagStat = obj.Data("DiagStat")
		
		s DiagnosOnsetDate = obj.Data("DiagnosOnsetDate")
		s DiagnosDate = obj.Data("DiagnosDate")
		
		s DiagnosPrefix = $g(obj.Data("DiagnosPrefix"))
		
		//
		s MRDIAMRDIADR=$p($g(^MR($P(DiagnosValue,"||",1),"DIA",$P(DiagnosValue,"||",2))),"^",15)
		
		//诊断状态ID
		s DiagStatDr=$p($g(^MR($P(DiagnosValue,"||",1),"DIA",$P(DiagnosValue,"||",2))),"^",9)
		
		//诊断类型过滤
		S SubRowid=$G(^MR($P(DiagnosValue,"||",1),"DIA",$P(DiagnosValue,"||",2),"TYP",0))
		if SubRowid'="" 
		{
			s MRDiagnosTypeDr=$G(^MR($P(DiagnosValue,"||",1),"DIA",$P(DiagnosValue,"||",2),"TYP",SubRowid))
		}
		continue:(defaultDiagnosTypeID'="")&&(MRDiagnosTypeDr'=defaultDiagnosTypeID)


		//综合症状描述：Syndrome 综合征; 综合症状; 典型意见; 典型表现;
		s SyndromeDesc=##class(web.DHCDocDiagnosNew).GetDiaSyndDesc(DiagnosValue)
    	i SyndromeDesc'="" s SyndromeDesc=$tr(SyndromeDesc,","," ")
		
		
		//诊断开立医生信息
		s DoctorDr=$p($g(^MR($P(DiagnosValue,"||",1),"DIA",$P(DiagnosValue,"||",2))),"^",4)
    	i DoctorDr'="" s DiagnosDoctor=$P($G(^CTPCP(DoctorDr,1)),"^",2)
		
		//诊断部位信息
		s BodyPartDesc=""
    	s BodyPartDr=$p($g(^MR($P(DiagnosValue,"||",1),"DIA",$P(DiagnosValue,"||",2),1)),"^",21)
    	i BodyPartDr'="" s BodyPartDesc=$List(^DHCEMRM.DicDiagnosPositionD(BodyPartDr),3)
		
		s BillFlag1="" ,BillFlag3=""
		
		i DiagnosCodeRowid'=""
		{
			s BillFlag1=$P($G(^MRC("ID",+DiagnosCodeRowid)),"^",13)
			s BillFlag3=$P($g(^MRC("ID",+DiagnosCodeRowid)),"^",15)
		
			i BillFlag3'="Y"
			{
				s DiagnosCat="西医"
			}
			elseif (BillFlag3="Y")&&(BillFlag1'="Y")
			{
				s DiagnosCat="中医"
			}
			else
			{
				s DiagnosCat="证型"
			}
		}
		else{
			s Questionnaire=$P($G(^MR($P(DiagnosValue,"||",1),"DIA",$P(DiagnosValue,"||",2))),"^",22)
			
			i Questionnaire=1
			{
				s DiagnosCat="西医"
			}
			elseif (Questionnaire=2)
			{
				s DiagnosCat="中医"
			}
			elseif (Questionnaire=3)
			{
				s DiagnosCat="证型"
			}
			i DiagnosCat="" 
			{
				s DiagnosCat="西医"
			}
		}
		Q:(ICDType="1")&&(BillFlag3'="Y")
		
		
		//备注，取值优化
		if ($LISTVALID(DiagnosMRDesc) = 1)&&(DiagnosMRDesc'="")
		{	
			//医生站代码因为MRDesc为字符串，通过$list取值导致绑定数据失败。
			//将代码迁移到电子病历中管理，如果项目存在问题 与医生站代码同步后使用。
			s DiagnosMRDesc=$LIST(DiagnosMRDesc,1)	
		}
		

		
		
		set Data=$lb(DiagnosCodeRowid,DiagnosValue,DiagnosCat,DiagnosType,DiagnosLeavel,DiagnosDesc,MainDiagFlag,DiagnosMRDesc,DiagnosICDCode,DiagStat,DiagnosOnsetDate,DiagnosDate,SyndromeDesc,MRDIAMRDIADR,DiagStatDr,MRDiagnosTypeDr,DiagnosDoctor,BodyPartDesc,BodyPartDr,DiagnosPrefix)
		set ^CacheTemp(repid,ind)=Data
		set ind=ind+1
		
	}
	
	d obj.Close()
	
	q $$$OK
}

ClassMethod DiagnosListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DiagnosListExecute ]
{
	 Set AtEnd=$LIST(qHandle,1)
	 Set repid=$LIST(qHandle,2)
	 Set ind=$LIST(qHandle,3)
		//
	 Set ind=$o(^CacheTemp(repid,ind))
	 If ind="" {				// if there are no more rows, finish fetching
	 Set AtEnd=1
	 Set Row=""
	 }
	 Else      {				// fetch row
	 Set Row=^CacheTemp(repid,ind)
	 }
	 // Save QHandle
	 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Desc:		测试接口返回值类型
/// Creator:	lifengbo
/// CreateDate: 2019-08-14
/// Input:      
/// Output:  	
/// Debug:
/// s stream = ##class(EMRservice.BL.BLDiagRefFormatData).debuggerGetDiagRefStyle()
ClassMethod debuggerGetDiagRefStyle() As %Stream
{
	s json = ##class(%GlobalCharacterStream).%New()
	d json.Write("[")
	s tmpid=""
	for	
	{
		s tmpid=$o(^DHCEMRM.DiagRefStyleDataD(tmpid))
		q:(tmpid="")
		
		s obj=##class(EMRmeta.DiagRefStyleData).%OpenId(tmpid)
		s name=obj.Name
		s code = obj.Code
		s description = obj.Description
		
		d:(json.SizeGet() '= 1) json.Write(",{")
		d:(json.SizeGet() = 1) json.Write("{")
		s jsonStr = """id"":"""_tmpid_""",""text"":"""_name_":"_description_""""
		d json.Write(jsonStr)
		d json.Write("}")
			
	}
	d json.Write("]")
	q json
}

/// /w ##class(EMRservice.BL.BLDiagRefFormatData).debuggerGetDiagRefFormatData(96,"diagnosesLayerV8","PRE",1)
ClassMethod debuggerGetDiagRefFormatData(AEpisodeID As %String, ALinkUnitName As %String, ADiagType As %String, diagRefStyleID As %String) As %String
{
	s result=""
	
	//s diagRefStyleID=""
	//s diagRefStyleID = $o(^DHCEMRM.DiagRefStyleDataI("IdxUnitLinkNameActive"," "_ALinkUnitName," Y",diagRefStyleID))
	if (diagRefStyleID="") 
	{
		s result="DiagRefFormatData Is Not Exist"
		q result
	}
	//s objDiagRefStyle=##class(EMRmeta.DiagRefStyleData).%OpenId(diagRefStyleID)
	
	s result = ..GetLinkUnitSchemeData(AEpisodeID,ALinkUnitName,ADiagType,diagRefStyleID)
	q result
}

/// Desc:		将前端传入的诊断数据转换为Query数据输出。
/// Creator:	lifengbo
/// CreateDate: 2019-08-14
/// Input:      DiagnoseJson：诊断对象数据JSON字符串
/// Output:  	格式化JSON字符串，返回Query结果	
/// Debug:
/// d ##class(%ResultSet).RunQuery("EMRservice.BL.BLDiagRefFormatData","DiagnosListFromJson",190)
/// 		s json = [{"TypeDesc":"初步诊断","ICDDesc":"食管裂孔疝","MemoDesc":"备注2","ICDCode":"K44.901","EvaluationDesc":"确诊","UserName":"医生01","Date":"2018-03-26","BillFlagDesc":"西医","BillFlag":0,"Level":"1"},{"TypeDesc":"初步诊断","ICDDesc":"食管裂孔疝","MemoDesc":"","ICDCode":"K44.901","EvaluationDesc":"确诊","UserName":"医生01","Date":"2018-04-08","BillFlagDesc":"西医","BillFlag":0,"Level":"1"},{"TypeDesc":"初步诊断","ICDDesc":"肺占位性病变","MemoDesc":"备注3","ICDCode":"R91.x03","EvaluationDesc":"确诊","UserName":"医生01","Date":"2018-04-08","BillFlagDesc":"西医","BillFlag":0,"Level":"2"},{"TypeDesc":"初步诊断","ICDDesc":"下颌后缩","MemoDesc":"","ICDCode":"K07.106","EvaluationDesc":"确诊","UserName":"医生01","Date":"2018-05-30","BillFlagDesc":"西医","BillFlag":0,"Level":"1"},{"TypeDesc":"初步诊断","ICDDesc":"夜盲","MemoDesc":"","ICDCode":"H53.600","EvaluationDesc":"确诊","UserName":"医生01","Date":"2018-05-30","BillFlagDesc":"西医","BillFlag":0,"Level":"1"}]
/// 		d ##class(%ResultSet).RunQuery("EMRservice.BL.BLDiagRefFormatData","DiagnosListFromJson",jsonstring)
Query DiagnosListFromJson(DiagnoseJson As %String) As %Query(ROWSPEC = "MRCIDRowId:%String,MRDIARowId:%String,DiagnosCat:%String,DiagnosType:%String,DiagnosLeavel:%String,DiagnosICDDesc:%String,MainDiagFlag:%String,DiagnosNotes:%String,MRCIDCode:%String,DiagnosStatus:%String,id:%String,DiagnosOnsetDate:%String,DiagnosDate:%String,SyndromeDesc:%String,MRDIAMRDIADR:%String,DiagnosStatusRowId:%String,DiagnosTypeRowId:%String,DiagnosDoctor:%String,DiagnosBodyPart:%String,DiagnosBodyPartRowId:%String")
{
}

ClassMethod DiagnosListFromJsonExecute(ByRef qHandle As %Binary, DiagnoseJson As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(DiagnoseJson="") $$$OK
	
	s DiagJsonArray = [].%FromJSON(DiagnoseJson)
	set iterator=DiagJsonArray.%GetIterator()
	/*
		{"TypeDesc":"初步诊断","ICDDesc":"食管裂孔疝",
		"MemoDesc":"备注2","ICDCode":"K44.901","EvaluationDesc":"确诊",
		"UserName":"医生01","Date":"2018-03-26","BillFlagDesc":"西医",
		"BillFlag":0,"Level":"1"}
   	*/
   	while iterator.%GetNext(.key,.val)
   	{
	   	s tmpJson = "" 
		s tmpJson = val
		s DiagnosCodeRowid = "" // tmpJson.DiagnosCodeRowid
 		s DiagnosValue ="" // tmpJson.DiagnosValue
 		s DiagnosCat = tmpJson.BillFlagDesc
 		s DiagnosType = tmpJson.TypeDesc
 		s DiagnosLeavel = tmpJson.Level
 		s DiagnosDesc = tmpJson.ICDDesc
 		s MainDiagFlag = "" //tmpJson.MainDiagFlag
 		//备注信息特殊处理为list 与医生站返回值数据保持一致
 		s DiagnosMRDesc = $s(tmpJson.MemoDesc="":"",1:$lb(tmpJson.MemoDesc))
 		s DiagnosICDCode = tmpJson.ICDCode
 		s DiagStat = tmpJson.EvaluationDesc
 		s Id = "" //tmpJson.Id
 		s DiagnosOnsetDate = tmpJson.Date
 		s DiagnosDate = tmpJson.Date
 		s SyndromeDesc = "" //tmpJson.MemoDesc
 		s MRDIAMRDIADR = "" //tmpJson.MRDIAMRDIADR
 		s DiagStatDr = "" //tmpJson.DiagStatDr
 		s MRDiagnosTypeDr = "" //tmpJson.MRDiagnosTypeDr
 		s DiagnosDoctor = tmpJson.UserName //tmpJson.DiagnosDoctor
 		s BodyPartDesc = "" //tmpJson.BodyPartDesc
 		s BodyPartDr =	"" //tmpJson.BodyPartDr

		set Data=$lb(DiagnosCodeRowid,DiagnosValue,DiagnosCat,DiagnosType,DiagnosLeavel,DiagnosDesc,MainDiagFlag,DiagnosMRDesc,DiagnosICDCode,DiagStat,Id,DiagnosOnsetDate,DiagnosDate,SyndromeDesc,MRDIAMRDIADR,DiagStatDr,MRDiagnosTypeDr,DiagnosDoctor,BodyPartDesc,BodyPartDr)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod DiagnosListFromJsonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DiagnosListFromJsonExecute ]
{
	Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

ClassMethod DiagnosListFromJsonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DiagnosListFromJsonExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	 Set repid=$LIST(qHandle,2)
	 Set ind=$LIST(qHandle,3)
		//
	 Set ind=$o(^CacheTemp(repid,ind))
	 If ind="" {				// if there are no more rows, finish fetching
	 Set AtEnd=1
	 Set Row=""
	 }
	 Else      {				// fetch row
	 Set Row=^CacheTemp(repid,ind)
	 }
	 // Save QHandle
	 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
