/// 名称:cdss第三方数据患者模型渲染方法
/// 描述: 对结构化之后的数据进行患者模型渲染 分为新增患者和更新患者两大类
/// 编写者：范文凯-基础数据平台
/// 编写日期: 2020-05-14
Class web.CDSS.Demo.ParseMode [ Abstract, Not ProcedureBlock ]
{

ClassMethod LetUsGo()
{
}

/// Creator:范文凯
/// CreatDate:2020-05-14
/// Description：解析json串，把所有的患者信息存入到对应的业务数据表中
/// Input：患者信息json串
/// Output: "SUCCESS"
/// w ##class(web.CDSS.Demo.ParseMode).ParsePatientModel(^TMP("FWK"))
ClassMethod ParsePatientModel(StructuredString)
{
    n (StructuredString)
    s StructuredString = ##class(web.BDP.util.String).Replace(StructuredString,$c(13,10),"")   
    if ((StructuredString = "DeleteDiagnosisInfo")||(StructuredString=""))
    {
        q "success"
    }
    s:StructuredString["DM000770" ^TMP("FWK")=StructuredString
    if ($e(StructuredString,1,1)'="[")     //如果入参外层不是列表，就加一层列表
    {
        s StructuredString="["_StructuredString_"]"
    }
    //b
    k ^TmpCC
    k ^TmpCM
    k ^TmpPD
    k ^TmpPI
    k ^TmpMI
    k ^TmpFH
    k ^TmpAH
    k ^TmpPE
    k ^TmpSE
    k ^TmpINP
    k ^TmpLE
    k ^TmpDiagInfo
    s ^TmpCC=0
    s ^TmpCM=0
    s ^TmpPD=0
    s ^TmpPI=0
    s ^TmpMI=0
    s ^TmpFH=0
    s ^TmpAH=0
    s ^TmpPE=0
    s ^TmpSE=0
    s ^TmpINP=0
    s ^TmpLE=0
    s ^TmpDiagInfo = 0
    s ^TmpExam = 0
    s ErrorInfo=[]
    s StructuredString=[].%FromJSON(StructuredString)
    s PatientJson=StructuredString.%Get(0)
    s OperResult = PatientJson.%Get("OperResult")
    if (OperResult="DeleteDiagnosisInfo")
    {
        q "success"
    }
    //判断是新增还是删除  OrderFlag = 1 新增/修改   OrderFlag = 2 删除
    s OperationFlag = PatientJson.%Get("OperationFlag")
    if ((OperationFlag'="")&&(OperationFlag '= 1 ))
    {
        d ..DeletePatientModel(StructuredString)
        q "success"
    }
    s IDNO=PatientJson.%Get("IDNO")
    s VisitID=PatientJson.%Get("VisitID")
    s PatientDR=PatientJson.%Get("PatientDR")
    //s Config=PatientJson.%Get("Config")
    s Config=1
    //默认Config=1 通过PatientDR以及VisitID来判断是新增患者还是更新患者
    if (Config=1)
    {
        d ..AddPatientModelbyPatientDR(StructuredString)
    }
    else   //Config!=1 通过IDNO为患者唯一标识
    {

        d ..AddPatientModelbyIDNO(StructuredString)
    }
    q "success"
}

/// Creator:范文凯
/// CreatDate:2020-05-14
/// Description：拆分入参，分别把不同CDSS业务表的数据存入表中
/// Input：患者信息json串
/// Output: "success"
/// w ##class(web.CDSS.MachineLearning.DataVerification).DataConsistency()
ClassMethod AddPatientModelbyPatientDR(StructuredString)
{
    n (StructuredString)
    s UpdateFlag=""     //是否是更新对象的标识 如果是更新对象则无需对顺序号进行修改
    s RequiredField = "IDNO^PatientDR^VisitID^VisitType"
    
    s ErrorInfo=[]
    s PatientArray=StructuredString
    for i=0:1:PatientArray.%Size()-1   //遍历第一层列表
    {
        s PatientJson=PatientArray.%Get(i)
        k key
        k value
        s IDNOValue=PatientJson.%Get("IDNO")
        s VisitIDValue=PatientJson.%Get("VisitID")
        s PatientDRValue=PatientJson.%Get("PatientDR")
        s VisitTypeValue=PatientJson.%Get("VisitType")
        s Config=##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSSdyn20200416")
		s:Config'="Y" Config = "1"
        s RequiredFieldValue= IDNOValue_"^"_PatientDRValue_"^"_VisitIDValue_"^"_VisitTypeValue
        s PatientIterator=PatientJson.%GetIterator()
        while PatientIterator.%GetNext(.key,.value)
        {
            if key="children"    //如果键值对中的键为"children"
            {
                s ChildrenArray=PatientJson.%Get("children")       //包含表名的children
                for j=0:1:(ChildrenArray.%Size()-1)
                { 
                    s ChildrenJson=ChildrenArray.%Get(j)
                    s TableName="WDT.CDSS."_ChildrenJson.%Get("DataClass")   //字段所属表名
                    s GrandChildrenArray=ChildrenJson.%Get("children")       //包含字段名的children                  
                    continue:TableName="WDT.CDSS.AnestInfo"
                    //continue:TableName="WDT.CDSS.BloodTransInfo"
                    continue:TableName="WDT.CDSS.OtherDisOrderInfo"
                    if (TableName="WDT.CDSS.")
                    {
                        continue
                    }
                    // TableName 去调用方法 根据返回值来判断是新增还是更新
                    s ObjectID = ..JudgmentUpdate(TableName,PatientDRValue,VisitIDValue,VisitTypeValue,GrandChildrenArray,IDNOValue)                    
                    if (ObjectID="")           //新增一个表对象
                    {
                        s NewObjStr="s obj=##class("_TableName_").%New()"
                        x NewObjStr
                        s UpdateFlag = "N"
                    }
                    else
                    {
                        s OpenObjStr ="s obj=##class("_TableName_").%OpenId("_ObjectID_")" 
                        x OpenObjStr
                        s UpdateFlag = "Y"   //标识为更新表对象
                    }
                   
                    for i=0:1:GrandChildrenArray.%Size()-1      //遍历children的每一个键值对
                    {
                        //必填项的写入
                        for Reqf=0:1:3
                        {
                            s FieldName = $p(RequiredField,"^",Reqf+1)
                            continue:FieldName=""
                            s FieldNameValue= $p(RequiredFieldValue,"^",Reqf+1)
                            if $d(^CT.WDT.CDSS.DataTableDictI("TableNameIndex",TableName,FieldName)) //如果数据库中存在此字段
                            {
                               s Exp ="s obj."_FieldName_"="""_FieldNameValue_""""
                               x Exp
                            }
                        }
                        s GrandChildren=GrandChildrenArray.%Get(i)
                        k fieldkey
                        k fieldvalue    //清空数据，以防数据窜值
                        s FieldNameIterator=GrandChildren.%GetIterator()
                        while FieldNameIterator.%GetNext(.fieldkey,.fieldvalue)    //遍历当前键值对的key value
                        {
                            if $d(^CT.WDT.CDSS.DataTableDictI("TableNameIndex",TableName,fieldkey)) //如果数据库中存在此字段
                            {
	                            s Exp ="s obj."_fieldkey_"="_""""_fieldvalue_""""
                                //5张表信息项只写入阳性症状信息
                                if (((TableName="WDT.CDSS.ChiefCompInfo")||(TableName="WDT.CDSS.CurrentMedHistory")||(TableName="WDT.CDSS.PhysicalExam")||(TableName="WDT.CDSS.SpecExam")||(TableName="WDT.CDSS.AllergyHistory"))&&(fieldkey="SymptomResult")&&(fieldvalue="阴性"))
                                {
                                    q
                                }
                                //jiazushi
                                if ((fieldkey="GeneticDiseNo")&&(UpdateFlag="Y"))
                                {
                                    continue   //跳出本次循环无需对顺序做出修改
                                }
                                if (fieldkey="GeneticDiseNo")
                                {
                                    
                                    s NumAble = "s NumValue =$o(^"_TableName_"I(""GeneticDiseNo"","""_PatientDRValue_""","" ""),-1)"
                                    x NumAble
                                    if (NumValue=" ")
                                    {
                                        s fieldvalue = 1
                                    }
                                    else
                                    {
                                        s fieldvalue = NumValue+1
                                    }
                                    s Exp ="s obj."_fieldkey_"="_""""_fieldvalue_""""   
                                }
                                //jiwangshi 
                                if ((fieldkey="PastHistoryNum")&&(UpdateFlag="Y"))
                                {
                                    continue   //跳出本次循环无需对顺序做出修改
                                }
                                if (fieldkey ="NursingItemNum")
                                {
	                                s NumAble = "s NumValue =$o(^"_TableName_"I(""PatVisDRNursNumIndex"","""_PatientDRValue_""","_VisitIDValue_","" ""),-1)"
                                    x NumAble
                                    if (NumValue=" ")
                                    {
                                        s fieldvalue = 1
                                    }
                                    else
                                    {
                                        s fieldvalue = NumValue+1
                                    }
                                    s Exp ="s obj."_fieldkey_"="_""""_fieldvalue_""""   
	                            }
                                if (fieldkey="PastHistoryNum")
                                {
                                    
                                    s NumAble = "s NumValue =$o(^"_TableName_"I(""PastHistoryNum"","""_PatientDRValue_""","_VisitIDValue_","" ""),-1)"
                                    x NumAble
                                    if (NumValue=" ")
                                    {
                                        s fieldvalue = 1
                                    }
                                    else
                                    {
                                        s fieldvalue = NumValue+1
                                    } 
                                    s Exp ="s obj."_fieldkey_"="_""""_fieldvalue_""""  
                                }
                                //yaowuguominshi
                                /*if ((fieldkey="AllergyHistoryNum")&&(UpdateFlag="Y"))
                                {
                                    continue   //跳出本次循环无需对顺序做出修改
                                }*/
                                if (fieldkey="AllergyHistoryNum")
                                {
                                    
                                    s NumAble = "s NumValue =$o(^"_TableName_"I(""AllergyHistoryNum"","""_PatientDRValue_""","" ""),-1)"
                                    x NumAble
                                    if (NumValue=" ")
                                    {
                                        s fieldvalue = 1
                                    }
                                    else
                                    {
                                        s fieldvalue = NumValue+1
                                    }   
                                    s Exp ="s obj."_fieldkey_"="_""""_fieldvalue_""""
                                }
                                if ((fieldkey="SymptomNum")&&(UpdateFlag="Y"))
                                {
                                    continue   //跳出本次循环无需对顺序做出修改
                                }
                                if (fieldkey="SymptomNum")
                                {
                                    
                                    s NumAble = "s NumValue =$o(^"_TableName_"I(""SymptomNum"","""_PatientDRValue_""","_VisitIDValue_","" ""),-1)"
                                    x NumAble
                                    if (NumValue=" ")
                                    {
                                        s fieldvalue = 1
                                    }
                                    else
                                    {
                                        s fieldvalue = NumValue+1
                                    }   
                                    s Exp ="s obj."_fieldkey_"="_""""_fieldvalue_""""
                                }
                                //如果是诊断顺序号字段
                                //如果是诊断顺序号字段
                                if (fieldkey = "DiagnosisSequence")
                                {
                                    s NumAble = "s NumValue =$o(^"_TableName_"I(""IDNOSequenceIndex"","""_IDNOValue_""","" ""),-1)"
                                    x NumAble
                                    if (NumValue=" ")
                                    {
                                        s fieldvalue = 1
                                    }
                                    else
                                    {
                                        s fieldvalue = NumValue+1
                                    }
                                    s Exp ="s obj."_fieldkey_"="_""""_fieldvalue_""""
                                }
                                //如果是手术次数字段
                                if (fieldkey = "OperNum")
                                {
	                                
                                    s OperNum = $o(^WDT.CDSS.OperationInfoI("PatVisDRTyOpNumIndex",PatientDRValue,VisitIDValue,VisitTypeValue," "),-1)
                                    if (OperNum = "")
                                    {
                                        s fieldvalue = 1
                                    }
                                    else
                                    {
                                        s fieldvalue = OperNum+1
                                    }
                                    s Exp ="s obj."_fieldkey_"="_""""_fieldvalue_""""
                                }
                                //如果是手术顺序字段
                                if (fieldkey = "OperSequence")
                                {
                                    s OperSequence = $o(^WDT.CDSS.OperationInfoI("OperSequenceIndex",PatientDRValue,VisitIDValue," "),-1)
                                    if (OperSequence = "")
                                    {
                                        s fieldvalue = 1
                                    }
                                    else
                                    {
                                        s fieldvalue = OperSequence+1
                                    }
                                    s Exp ="s obj."_fieldkey_"="_""""_fieldvalue_""""
                                }
                                if (fieldkey="PartDR")
                                {
                                    if (fieldvalue'="")
                                    {
	                                    //s:fieldvalue="腹" fieldvalue="腹部"
                                        s PartDRValue = $o(^WDT.CDSS.BodyParDictI("NameIndex"," "_fieldvalue,0))
                                        /*s NewPartDR = $o(^WDT.CDSS.BodyPartsDictI("DescIndex"," "_fieldvalue,0))
                                        if (NewPartDR="")
                                        {
	                                        s NewPartDR =$o(^CT.WDT.CDSS.AliasI("AliasIndex","WDT.CDSS.BodyPartsDict",fieldvalue,0))
	                                        s:NewPartDR'="" Exp1="d obj.CDSS2PartDRSetObjectId("_NewPartDR_")"
	                                        x:NewPartDR'="" Exp1
	                                        
	                                    }
	                                    else
	                                    {
		                                    s Exp1="d obj.CDSS2PartDRSetObjectId("_NewPartDR_")"
	                                        x Exp1
		                                }*/
                                        if (PartDRValue'="")
                                        {
	                                        s Exp="d obj."_fieldkey_"SetObjectId("_PartDRValue_")"
	                                    }
	                                    else
	                                    {
		                                    continue
		                                }  
                                    }
                                }
                                
                                if (fieldkey="CDSS2PartDR")
                                {
	                            	if (fieldvalue'="")
                                    {
	                                    //s:fieldvalue="腹" fieldvalue="腹部"
                                        s NewPartDR = $o(^CT.WDT.CDSS.BodyPartsDictI("DescIndex"," "_fieldvalue,0))
                                        if (NewPartDR="")
                                        {
	                                        s NewPartDR =$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.BodyPartsDict",fieldvalue,0))
	                                        continue:NewPartDR=""
	                                        s:NewPartDR'="" Exp="d obj.CDSS2PartDRSetObjectId("_NewPartDR_")"
	                                        //x:NewPartDR'="" Exp1
	                                    }
	                                    else
	                                    {
		                                    s Exp="d obj.CDSS2PartDRSetObjectId("_NewPartDR_")"
		                                }
                                    }
	                            }
	                            if (fieldkey="PositionWordDR")
	                            {
		                        	if (fieldvalue'="")
                                    {
	                                    //s:fieldvalue="腹" fieldvalue="腹部"
                                        s PosDR = $o(^CT.WDT.CDSS.PositionWordI("DescIndex"," "_fieldvalue,0))
                                        if (PosDR="")
                                        {
	                                        continue
	                                    }
	                                    else
	                                    {
		                                    s Exp="d obj.PositionWordDRSetObjectId("_PosDR_")"
		                                }
                                    } 
		                        }
                                //Specimen
                                if (fieldkey="Specimen")
                                {
                                    if (fieldvalue'="")
                                    {
                                        s LabDRValue = $o(^WDT.CDSS.LabSpecimenDictI("NameIndex"," "_fieldvalue,0))
                                        if (LabDRValue'="")
                                        {
	                                        s Exp="d obj."_fieldkey_"SetObjectId("_LabDRValue_")"
	                                    }
	                                    else
	                                    {
		                                    continue
		                                }  
	                                    
                                    }
                                    else
                                    {
	                                    continue
	                                }
                                }
                           	    x Exp
                           	    continue:((fieldvalue="")&&(fieldkey'="Age"))
	                            //判断该字段是否要触发识别词
	                            s TableRowID = $o(^CT.WDT.CDSS.DataTableDictI("TableNameIndex",TableName,fieldkey,""))
	                            s PMDataType=$lg($g(^CT.WDT.CDSS.DataTableDictD(TableRowID)),14)
	                            if (PMDataType'="")
								{
									s PMDataTypeNum=$l(PMDataType,"&")
									for zz=0:1:(PMDataTypeNum-1)
									{
										s DataType=$p(PMDataType,"&",zz+1)
										if (Config=1){
											continue:$d(^WDT.CDSS.PatPMTypeIndexI("PatVisDRUpTypeIndex",PatientDRValue,VisitIDValue,1,DataType))
										}elseif(Config="Y"){
											continue:$d(^WDT.CDSS.PatPMTypeIndexI("IDNOUpTypeIndex",IDNOValue,1,DataType))
										}
										s PMobj=##class(WDT.CDSS.PatPMTypeIndex).%New()
										s PMobj.IDNO=IDNOValue
										s PMobj.PatientDR=PatientDRValue
										s PMobj.VisitID=VisitIDValue
										s PMobj.VisitType=VisitTypeValue
										s PMobj.DataType=DataType
										s PMobj.IsLastUpdate=1
										d PMobj.%Save()
										d PMobj.%Close()
									}
								}
                            }
                        }
                        s SaveObjStr = "s sc = obj.%Save()"
                        s CloseObjStr = "d obj.%Close()"
                        x SaveObjStr
                        //w ##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc),!
                        x CloseObjStr
                    }
                }
            }
        }
        
    }
    q "sc"
}

/// Creator:范文凯
/// CreatDate:2020-05-14
/// Description：
/// Input：患者信息json串
/// Output: 
/// w ##class(web.CDSS.MachineLearning.DataVerification).DataConsistency()
ClassMethod AddPatientModelbyINDO(StructuredString)
{
}

/// Creator:范文凯
/// CreatDate:2020-05-14
/// Description：
/// Input：患者信息json串
/// Output: 
/// w ##class(web.CDSS.MachineLearning.DataVerification).DataConsistency()
ClassMethod UpdatePatientModelbyIDNO()
{
}

/// Creator:范文凯
/// CreatDate:2020-05-14
/// Description：
/// Input：患者信息json串
/// Output: 
/// w ##class(web.CDSS.MachineLearning.DataVerification).DataConsistency()
ClassMethod UpdatePatientModelbyPatientDR()
{
}

/// Creator:范文凯
/// CreatDate:2020-05-18
/// Description：判断是新增患者表对象还是更新患者表对象
/// Input：根据霍工指定的字段判断是否已经存在 如何已经存在 则更新 不存在则新增
/// Output: 
/// w ##class(web.CDSS.MachineLearning.DataVerification).InputToClinicalFDetailed()
ClassMethod JudgmentUpdate(TableName As %String, PatientDR As %String, VisitID As %String, VisitType As %String, PatientArray As %String, IDNO As %String)
{
    n (TableName,PatientDR,VisitID,VisitType,PatientArray,IDNO)
    s ObjectID=""
    s Config=##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSSdyn20200416")
    if (Config="") s Config=1
    //w PatientJson
    s PatientJson=PatientArray.%Get(0)
    if (TableName="WDT.CDSS.PatientMaster")   //基础信息表
    {
	    if ((Config=1)&(PatientDR'="")&(VisitID'="")){
	        if ($d(^WDT.CDSS.PatientMasterI("PatDRIndex",PatientDR)))
	        {
	            s ObjectID = $o(^WDT.CDSS.PatientMasterI("PatDRIndex",PatientDR,0))
	            q ObjectID
	        }
	        else
	        {
	            q ObjectID
	        }
        }else{
	        if ($d(^WDT.CDSS.PatientMasterI("IDNOIndex"," "_$zcvt(IDNO,"U"))))
	        {
	            s ObjectID = $o(^WDT.CDSS.PatientMasterI("IDNOIndex"," "_$zcvt(IDNO,"U"),0))
	            q ObjectID
	        }
	        else
	        {
	            q ObjectID
	        }
	    }
    }
    elseif(TableName="WDT.CDSS.PatientVisit")
    {
	    if ((Config=1)&(PatientDR'="")&(VisitID'="")){
	        if ($d(^WDT.CDSS.PatientVisitI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType)))
	        {
	            s ObjectID = $o(^WDT.CDSS.PatientVisitI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType,0))
	            q ObjectID
	        }
	        else
	        {
	            q ObjectID
	        }
	    }else{
		    if ($d(^WDT.CDSS.PatientVisitI("IDNOIndex"," "_$zcvt(IDNO,"U"))))
	        {
	            s ObjectID = $o(^WDT.CDSS.PatientVisitI("IDNOIndex"," "_$zcvt(IDNO,"U"),0))
	            q ObjectID
	        }
	        else
	        {
	            q ObjectID
	        }
		}
    }
    elseif (TableName="WDT.CDSS.SignInfo")   //体征信息表
    {
        s MeasureDate=PatientJson.%Get("MeasureDate")    //测量时间  时间已经存在则更新数据 时间不存在则新增数据
        if ((Config=1)&(PatientDR'="")&(VisitID'=""))
        {
	        if ($d(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType," "_MeasureDate)))
	        {
	            //更新数据
	            s ObjectID = $o(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType," "_MeasureDate,0))
	            q ObjectID
	        }
	        else
	        {
	            //新增数据
	            q ObjectID
	        }
        }else
        {
	        if ($d(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO," "_MeasureDate)))
	        {
	            //更新数据
	            s ObjectID = $o(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO," "_MeasureDate,0))
	            q ObjectID
	        }
	        else
	        {
	            //新增数据
	            q ObjectID
	        }
	    }
    }
    elseif(TableName="WDT.CDSS.ChiefCompInfo")  //主诉信息
    {
        //删除掉本次就诊旧的主诉
        s ^TmpCC = $g(^TmpCC)+1
        if (Config=1){
	        if ($g(^TmpCC)=1)
	        {
	            s ChiefCompInfoID=0
	            for
	            {
	                s ChiefCompInfoID = $o(^WDT.CDSS.ChiefCompInfoI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType,ChiefCompInfoID))
	                q:ChiefCompInfoID=""
	                d ##class(WDT.CDSS.ChiefCompInfo).%DeleteId(ChiefCompInfoID)
	            }
	            q ObjectID
	        }
	        else
	        {
	            //新增数据
	            q ObjectID
	        }
        }
        else
        {
	        if ($g(^TmpCC)=1)
	        {
	            s ChiefCompInfoID=0
	            for
	            {
	                s ChiefCompInfoID = $o(^WDT.CDSS.ChiefCompInfoI("IDNOIndex"," "_$zcvt(IDNO,"U"),ChiefCompInfoID))
	                q:ChiefCompInfoID=""
	                d ##class(WDT.CDSS.ChiefCompInfo).%DeleteId(ChiefCompInfoID)
	            }
	            q ObjectID
	        }
	        else
	        {
	            //新增数据
	            q ObjectID
	        }
	    }
    }
	elseif(TableName="WDT.CDSS.DiagnosisInfo")    //诊断信息表  
    {
        s ^TmpDiagInfo = $g(^TmpDiagInfo)+1
        if (Config=1){
	        if ($g(^TmpDiagInfo)=1)
	        {
	            s DiagInfoID=0
	            for
	            {
	                s DiagInfoID= $o(^WDT.CDSS.DiagnosisInfoI("PatVisDRIndex",PatientDR,VisitID,VisitType,DiagInfoID))
	                q:DiagInfoID=""
	                d ##class(WDT.CDSS.DiagnosisInfo).%DeleteId(DiagInfoID)
	            }
	            q ObjectID
	        }
	        else
	        {
	            //新增数据
	            q ObjectID
	        }
        }
        else
        {
	        if ($g(^TmpDiagInfo)=1)
	        {
	            s DiagInfoID=0
	            for
	            {
	                s DiagInfoID= $o(^WDT.CDSS.DiagnosisInfoI("IDNOIndex"," "_$zcvt(IDNO,"U"),DiagInfoID))
	                q:DiagInfoID=""
	                d ##class(WDT.CDSS.DiagnosisInfo).%DeleteId(DiagInfoID)
	            }
	            q ObjectID
	        }
	        else
	        {
	            //新增数据
	            q ObjectID
	        }
	    }
    }
    elseif(TableName="WDT.CDSS.LabExamInfo")  //辅助检验检查信息
    {
        //删除掉本次就诊旧的主诉
        s ^TmpLE = $g(^TmpLE)+1
        if ((Config=1)&(PatientDR'="")&(VisitID'=""))
        {
	        if ($g(^TmpLE)=1)
	        {
	            s ChiefCompInfoID=0
	            for
	            {
	                s ChiefCompInfoID = $o(^WDT.CDSS.LabExamInfoI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType,ChiefCompInfoID))
	                q:ChiefCompInfoID=""
	                d ##class(WDT.CDSS.LabExamInfo).%DeleteId(ChiefCompInfoID)
	            }
	            q ObjectID
	        }
	        else
	        {
	            //新增数据
	            q ObjectID
	        }
        }
        else
        {
	        if ($g(^TmpLE)=1)
	        {
	            s ChiefCompInfoID=0
	            for
	            {
	                s ChiefCompInfoID = $o(^WDT.CDSS.LabExamInfoI("IDNOIndex"," "_$zcvt(IDNO,"U"),ChiefCompInfoID))
	                q:ChiefCompInfoID=""
	                d ##class(WDT.CDSS.LabExamInfo).%DeleteId(ChiefCompInfoID)
	            }
	            q ObjectID
	        }
	        else
	        {
	            //新增数据
	            q ObjectID
	        }
	    }
    }
    elseif(TableName="WDT.CDSS.CurrentMedHistory")  //现病史信息
    {
        s ^TmpCM = $g(^TmpCM)+1
        if ((Config=1)&(PatientDR'="")&(VisitID'=""))
        {
	        if ($g(^TmpCM)=1)
	        {
	            s CurrentMedHistoryID=0
	            for
	            {
	                s CurrentMedHistoryID = $o(^WDT.CDSS.CurrentMedHistoryI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType,CurrentMedHistoryID))
	                q:CurrentMedHistoryID=""
	                d ##class(WDT.CDSS.CurrentMedHistory).%DeleteId(CurrentMedHistoryID)
	            }
	            q ObjectID
	        }
	        else
	        {
	            //新增数据
	            q ObjectID
	        }
        }
        else
        {
	        if ($g(^TmpCM)=1)
	        {
	            s CurrentMedHistoryID=0
	            for
	            {
	                s CurrentMedHistoryID = $o(^WDT.CDSS.CurrentMedHistoryI("IDNOIndex"," "_$zcvt(IDNO,"U"),CurrentMedHistoryID))
	                q:CurrentMedHistoryID=""
	                d ##class(WDT.CDSS.CurrentMedHistory).%DeleteId(CurrentMedHistoryID)
	            }
	            q ObjectID
	        }
	        else
	        {
	            //新增数据
	            q ObjectID
	        }
	    }
    }
    elseif(TableName="WDT.CDSS.PastDiagnosis")  //既往史信息
    {
        s ^TmpPD = $g(^TmpPD)+1
        if ((Config=1)&(PatientDR'="")&(VisitID'=""))
        {
	        if ($g(^TmpPD)=1)
	        {
	            s PastDiagnosisID=0
	            for
	            {
	                s PastDiagnosisID = $o(^WDT.CDSS.PastDiagnosisI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType,PastDiagnosisID))
	                q:PastDiagnosisID=""
	                d ##class(WDT.CDSS.PastDiagnosis).%DeleteId(PastDiagnosisID)
	            }
	            q ObjectID
	        }
	        else
	        {
	            //新增数据
	            q ObjectID
	        }
        }
        else
        {
	        if ($g(^TmpPD)=1)
	        {
	            s PastDiagnosisID=0
	            for
	            {
	                s PastDiagnosisID = $o(^WDT.CDSS.PastDiagnosisI("IDNOIndex"," "_$zcvt(IDNO,"U"),PastDiagnosisID))
	                q:PastDiagnosisID=""
	                d ##class(WDT.CDSS.PastDiagnosis).%DeleteId(PastDiagnosisID)
	            }
	            q ObjectID
	        }
	        else
	        {
	            //新增数据
	            q ObjectID
	        }
	    }
    }
    elseif(TableName="WDT.CDSS.PersonalInfo")   //个人史信息
    {
        s ^TmpPI = $g(^TmpPI)+1
        if ((Config=1)&(PatientDR'="")&(VisitID'=""))
        {
	        if ($g(^TmpPI)=1)
	        {
	            s PersonalInfoID=0
	            for
	            {
	                s PersonalInfoID = $o(^WDT.CDSS.PersonalInfoI("PatDRIndex",PatientDR,PersonalInfoID))
	                q:PersonalInfoID=""
	                d ##class(WDT.CDSS.PersonalInfo).%DeleteId(PersonalInfoID)
	            }
	            q ObjectID
	        }
	        else
	        {
	            //新增数据
	            q ObjectID
	        }
        }
        else
        {
	        if ($g(^TmpPI)=1)
	        {
	            s PersonalInfoID=0
	            for
	            {
	                s PersonalInfoID = $o(^WDT.CDSS.PersonalInfoI("IDNOIndex"," "_$zcvt(IDNO,"U"),PersonalInfoID))
	                q:PersonalInfoID=""
	                d ##class(WDT.CDSS.PersonalInfo).%DeleteId(PersonalInfoID)
	            }
	            q ObjectID
	        }
	        else
	        {
	            //新增数据
	            q ObjectID
	        }
	    }
    }
    elseif(TableName="WDT.CDSS.MarryInfo")   //婚育史信息
    {
        s ^TmpMI = $g(^TmpMI)+1
        if ((Config=1)&(PatientDR'="")&(VisitID'=""))
        {
	        if ($g(^TmpMI)=1)
	        {
	            s MarryInfoID=0
	            for
	            {
	                s MarryInfoID = $o(^WDT.CDSS.MarryInfoI("PatDRIndex",PatientDR,MarryInfoID))
	                q:MarryInfoID=""
	                d ##class(WDT.CDSS.MarryInfo).%DeleteId(MarryInfoID)
	            }
	            q ObjectID
	        }
	        else
	        {
	            //新增数据
	            q ObjectID
	        }
        }
        else
        {
	        if ($g(^TmpMI)=1)
	        {
	            s MarryInfoID=0
	            for
	            {
	                s MarryInfoID = $o(^WDT.CDSS.MarryInfoI("IDNOIndex"," "_$zcvt(IDNO,"U"),MarryInfoID))
	                q:MarryInfoID=""
	                d ##class(WDT.CDSS.MarryInfo).%DeleteId(MarryInfoID)
	            }
	            q ObjectID
	        }
	        else
	        {
	            //新增数据
	            q ObjectID
	        }
	    }
    }
    elseif(TableName="WDT.CDSS.FamilyHisInfo")    //家族史信息
    {
        s ^TmpFH = $g(^TmpFH)+1
        if ((Config=1)&(PatientDR'="")&(VisitID'=""))
        {
	        if ($g(^TmpFH)=1)
	        {
	            s FamilyHisInfoID=0
	            for
	            {
	                s FamilyHisInfoID = $o(^WDT.CDSS.FamilyHisInfoI("PatDRIndex",PatientDR,FamilyHisInfoID))
	                q:FamilyHisInfoID=""
	                d ##class(WDT.CDSS.FamilyHisInfo).%DeleteId(FamilyHisInfoID)
	            }
	            q ObjectID
	        }
	        else
	        {
	            //新增数据
	            q ObjectID
	        }
        }
        else
        {
	        if ($g(^TmpFH)=1)
	        {
	            s FamilyHisInfoID=0
	            for
	            {
	                s FamilyHisInfoID = $o(^WDT.CDSS.FamilyHisInfoI("IDNOIndex"," "_$zcvt(IDNO,"U"),FamilyHisInfoID))
	                q:FamilyHisInfoID=""
	                d ##class(WDT.CDSS.FamilyHisInfo).%DeleteId(FamilyHisInfoID)
	            }
	            q ObjectID
	        }
	        else
	        {
	            //新增数据
	            q ObjectID
	        }
	    }
    }
    elseif(TableName="WDT.CDSS.AllergyHistory")    //过敏史信息
    {
        s ^TmpAH = $g(^TmpAH)+1
        if ((Config=1)&(PatientDR'="")&(VisitID'=""))
        {
	        if ($g(^TmpAH)=1)
	        {
	            s AllergyHistoryID=0
	            for
	            {
	                s AllergyHistoryID = $o(^WDT.CDSS.AllergyHistoryI("PatDRIndex",PatientDR,AllergyHistoryID))
	                q:AllergyHistoryID=""
	                s RiskLevel=$lg($g(^WDT.CDSS.AllergyHistoryD(AllergyHistoryID)),9) //危险等级
	                continue:RiskLevel'="" //等于空是过敏记录存的，可删；不等于空是病历存的，不可删
	                d ##class(WDT.CDSS.AllergyHistory).%DeleteId(AllergyHistoryID)
	            }
	            q ObjectID
	        }
	        else
	        {
		        q ObjectID
		    }
        }
        else
        {
	        if ($g(^TmpAH)=1)
	        {
	            s AllergyHistoryID=0
	            for
	            {
	                s AllergyHistoryID = $o(^WDT.CDSS.AllergyHistoryI("IDNOIndex"," "_$zcvt(IDNO,"U"),AllergyHistoryID))
	                q:AllergyHistoryID=""
	                s RiskLevel=$lg($g(^WDT.CDSS.AllergyHistoryD(AllergyHistoryID)),9) //危险等级
	                continue:RiskLevel'="" //等于空是过敏记录存的，可删；不等于空是病历存的，不可删
	                d ##class(WDT.CDSS.AllergyHistory).%DeleteId(AllergyHistoryID)
	            }
	            q ObjectID
	        }
	        else
	        {
		        q ObjectID
		    }
	    }
    }
    elseif(TableName="WDT.CDSS.PhysicalExam")    //体格检查表
    {
        s ^TmpPE = $g(^TmpPE)+1
        if ((Config=1)&(PatientDR'="")&(VisitID'=""))
        {
	        if ($g(^TmpPE)=1)
	        {
	            s PhysicalExamID=0
	            for
	            {
	                s PhysicalExamID = $o(^WDT.CDSS.PhysicalExamI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType,PhysicalExamID))
	                q:PhysicalExamID=""
	                d ##class(WDT.CDSS.PhysicalExam).%DeleteId(PhysicalExamID)
	            }
	            q ObjectID
	        }
	        else
	        {
	            //新增数据
	            q ObjectID
	        }
        }
        else
        {
	       if ($g(^TmpPE)=1)
	        {
	            s PhysicalExamID=0
	            for
	            {
	                s PhysicalExamID = $o(^WDT.CDSS.PhysicalExamI("IDNOIndex"," "_$zcvt(IDNO,"U"),PhysicalExamID))
	                q:PhysicalExamID=""
	                d ##class(WDT.CDSS.PhysicalExam).%DeleteId(PhysicalExamID)
	            }
	            q ObjectID
	        }
	        else
	        {
	            //新增数据
	            q ObjectID
	        } 
	    }
    }
    elseif(TableName="WDT.CDSS.SpecExam")    //专科检查表
    {
        s ^TmpSE = $g(^TmpSE)+1
        if ((Config=1)&(PatientDR'="")&(VisitID'=""))
        {
	        if ($g(^TmpSE)=1)
	        {
	            s SpecExamID=0
	            for
	            {
	                s SpecExamID = $o(^WDT.CDSS.SpecExamI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType,SpecExamID))
	                q:SpecExamID=""
	                d ##class(WDT.CDSS.SpecExam).%DeleteId(SpecExamID)
	            }
	            q ObjectID
	        }
	        else
	        {
	            //新增数据
	            q ObjectID
	        }
        }
        else
        {
	        if ($g(^TmpSE)=1)
	        {
	            s SpecExamID=0
	            for
	            {
	                s SpecExamID = $o(^WDT.CDSS.SpecExamI("IDNOIndex"," "_$zcvt(IDNO,"U"),SpecExamID))
	                q:SpecExamID=""
	                d ##class(WDT.CDSS.SpecExam).%DeleteId(SpecExamID)
	            }
	            q ObjectID
	        }
	        else
	        {
	            //新增数据
	            q ObjectID
	        }
	    }
    }
    /*elseif(TableName="WDT.CDSS.OperationInfo")    //手术信息表
    {   
        s OperCode=PatientJson.%Get("OperCode")  
        s OperNum=PatientJson.%Get("OperNum") 
        if ((Config=1)&(PatientDR'="")&(VisitID'=""))
        {
	        if ($d(^WDT.CDSS.OperationInfoI("PatVisDRTyOpNumIndex",PatientDR,VisitID,VisitType,OperNum,OperCode)))
	        {
	            //更新数据
	            s ObjectID = $o(^WDT.CDSS.OperationInfoI("PatVisDRTyOpNumIndex",PatientDR,VisitID,VisitType,OperNum,OperCode,0))
	            q ObjectID
	        }
	        else
	        {
	            //新增数据
	            q ObjectID
	        }
        }
        else
        {
	        if ($d(^WDT.CDSS.OperationInfoI("IDNOOpNumIndex",IDNO,OperNum,OperCode)))
	        {
	            //更新数据
	            s ObjectID = $o(^WDT.CDSS.OperationInfoI("IDNOOpNumIndex",IDNO,OperNum,OperCode,0))
	            q ObjectID
	        }
	        else
	        {
	            //新增数据
	            q ObjectID
	        }
	    }
    }*/
    elseif(TableName="WDT.CDSS.InpatientInfo")    //住院病历信息表
    {
        s MRClass=PatientJson.%Get("MRClass")    
        if ((Config=1)&(PatientDR'="")&(VisitID'=""))
        {
	        if ($d(^WDT.CDSS.InpatientInfoI("UniqueClassIndex",PatientDR,VisitID,VisitType," "_$zcvt(MRClass,"U"))))
	        {
	            //更新数据
	            s ObjectID = $o(^WDT.CDSS.InpatientInfoI("UniqueClassIndex",PatientDR,VisitID,VisitType," "_$zcvt(MRClass,"U"),0))
	            q ObjectID
	        }
	        else
	        {
	            //新增数据
	            q ObjectID
	        }
        }
        else
        {
	        if ($d(^WDT.CDSS.InpatientInfoI("UniqueIDNOClassIndex",IDNO," "_$zcvt(MRClass,"U"))))
	        {
	            //更新数据
	            s ObjectID = $o(^WDT.CDSS.InpatientInfoI("UniqueIDNOClassIndex",IDNO," "_$zcvt(MRClass,"U"),0))
	            q ObjectID
	        }
	        else
	        {
	            //新增数据
	            q ObjectID
	        }
	    }
    }
    else
    {
        q ObjectID
    }
}

/// Creator:范文凯
/// CreatDate:2020-07-22
/// Description：提供数据库更新检验报告数据
/// Input：action -> update = 更新字段值 | add = 新增数据
/// Output: 
/// w ##class(web.CDSS.MachineLearning.ParseMode).UpdateLabInfo(action,json)
ClassMethod UpdateLabInfo(action As %String, json As %String) As %String
{
    q "success"
}

/// Creator:范文凯
/// CreatDate:2020-07-23
/// Description：提供数据库更新检查报告数据
/// Input：
/// Output: 
/// w ##class(web.CDSS.MachineLearning.ParseMode).UpdateExamInfo(json)
ClassMethod UpdateExamInfo(json As %String) As %String
{
    q "success"
}

/// Creator:范文凯
/// CreatDate:2020-07-23
/// Description：提供数据库更新患者体征信息数据
/// Input：{"IDNO":"51634131","MeasureDate":"2020-06-24 00:00:00.0","HeartRate":"3200"}
/// Output: 
/// w ##class(web.CDSS.MachineLearning.ParseMode).UpdateSignInfo("")
ClassMethod UpdateSignInfo(json As %String) As %String
{
    q "success"
}

/// Creator:范文凯
/// CreatDate:2020-08-04
/// Description：提供删除方法
/// Input：{"IDNO":"51634131","MeasureDate":"2020-06-24 00:00:00.0","HeartRate":"3200"}
/// Output: 
/// w ##class(web.CDSS.MachineLearning.ParseMode).DeletePatientModel("json")
ClassMethod DeletePatientModel(StructuredString)
{
    n (StructuredString)
    s ^TMP("FWKDelete") = StructuredString
    s Config=##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSSdyn20200416")
    if (Config="") s Config=1
    s PatientJson=StructuredString.%Get(0)
    s IDNO=PatientJson.%Get("IDNO")
    s VisitID=PatientJson.%Get("VisitID")
    s PatientDR=PatientJson.%Get("PatientDR")
    s VisitTypeValue=PatientJson.%Get("VisitType")
    s OperationFlag = PatientJson.%Get("OperationFlag")
    s PatientArray=StructuredString
    for i=0:1:PatientArray.%Size()-1   //遍历第一层列表
    {
        s PatientJson=PatientArray.%Get(i)
        s PatientIterator=PatientJson.%GetIterator()
        while PatientIterator.%GetNext(.key,.value)
        {
            if key="children"    //如果键值对中的键为"children"
            {
                s ChildrenArray=PatientJson.%Get("children")       //包含表名的children
                for j=0:1:(ChildrenArray.%Size()-1)
                { 
                    s ChildrenJson=ChildrenArray.%Get(j)
                    s TableName="WDT.CDSS."_ChildrenJson.%Get("DataClass")   //字段所属表名
                    s GrandChildrenArray=ChildrenJson.%Get("children")       //包含字段名的children
                    s GrandChildrenJson=GrandChildrenArray.%Get(0)
                    if (TableName = "WDT.CDSS.DiagnosisInfo")     //删除患者诊断信息
                    {
	                    //更新诊断
	                    if (OperationFlag=3){
		                    s HISDiagnosisID=GrandChildrenJson.%Get("HISDiagnosisID")    
	                        s DiagnosisType = GrandChildrenJson.%Get("DiagnosisType")
	                        s DiagnosisName = GrandChildrenJson.%Get("DiagnosisName")
	                        s ChildDiagnosisFlag = GrandChildrenJson.%Get("ChildDiagnosisFlag")
	                        if ((Config=1)&(PatientDR'="")&(VisitID'=""))
	                        {
	                        	s DiagnosisInfoID = $o(^WDT.CDSS.DiagnosisInfoI("PatVisDRTyHISDiaIDIndex",PatientDR,VisitID,VisitTypeValue,HISDiagnosisID,""))
	                        }
	                        else
	                        {
		                        s DiagnosisInfoID = $o(^WDT.CDSS.DiagnosisInfoI("IDNOHISDiaIDIndex",IDNO,HISDiagnosisID,""))
		                    }
	                        continue:DiagnosisInfoID=""
	                       	s nobj= ##class(WDT.CDSS.DiagnosisInfo).%OpenId(DiagnosisInfoID)
	                       	s nobj.ChildDiagnosisFlag =ChildDiagnosisFlag
	                       	s nobj.DiagnosisType =DiagnosisType
                            d nobj.%Save()
            				d nobj.%Close()
            				d SaveSatisfyIW(IDNO,PatientDR,VisitID,VisitTypeValue,TableName,"DiagnosisName")
		                }
		                else
		                {
	                        s DiagnosisCode=GrandChildrenJson.%Get("DiagnosisCode")    
	                        s DiagnosisType = GrandChildrenJson.%Get("DiagnosisType") 
	                        s HISDiagnosisID=GrandChildrenJson.%Get("HISDiagnosisID")   
		                    s DiagnosisInfoID = 0
		                    if ((Config=1)&(PatientDR'="")&(VisitID'=""))
	                        {
		                        s DiagnosisInfoID = $o(^WDT.CDSS.DiagnosisInfoI("PatVisDRTyHISDiaIDIndex",PatientDR,VisitID,VisitTypeValue,HISDiagnosisID,DiagnosisInfoID))
	                        }else
	                        {
		                        s DiagnosisInfoID = $o(^WDT.CDSS.DiagnosisInfoI("IDNOHISDiaIDIndex",IDNO,HISDiagnosisID,DiagnosisInfoID))
		                    }
		                    d ##class(WDT.CDSS.DiagnosisInfo).%DeleteId(DiagnosisInfoID)   
	                        
	                        d SaveSatisfyIW(IDNO,PatientDR,VisitID,VisitTypeValue,TableName,"DiagnosisName")
                        }
                        //诊断号为唯一标识
                    }
                    elseif (TableName = "WDT.CDSS.OperationInfo")  //删除手术信息
                    {
                        
                        //Index UniquePatIndex On (PatientDR As Exact, VisitID, OperCode);
                        s OperCode = GrandChildrenJson.%Get("OperCode")
                        s GroupFlag=GrandChildrenJson.%Get("GroupFlag")
                        q:((OperCode="")||(GroupFlag=""))
                        s OperationInfoID = 0
                        if ((Config=1)&(PatientDR'="")&(VisitID'=""))
                        {
	                        s OperationInfoID = $o(^WDT.CDSS.OperationInfoI("UniquePatIndex",PatientDR,VisitID,VisitTypeValue,GroupFlag,OperationInfoID))
	                    }
	                    else
	                    {
		                    s OperationInfoID = $o(^WDT.CDSS.OperationInfoI("UniqueIDNOIndex"," "_$zcvt(IDNO,"U"),GroupFlag,OperationInfoID))
		                }
                        d ##class(WDT.CDSS.OperationInfo).%DeleteId(OperationInfoID)
                        d SaveSatisfyIW(IDNO,PatientDR,VisitID,VisitTypeValue,TableName,"OperName")
                    }
                    elseif (TableName = "WDT.CDSS.DrugInfo")  //删除药物信息
                    {
                        //删除药物信息表下该医嘱单号的所有信息
                        //Index UniquePatIndex On (PatientDR As Exact, VisitID, GroupFlag);                     
                        //医嘱单号为唯一标识GroupFlag
                        s GroupFlag=GrandChildrenJson.%Get("GroupFlag")
                        q:GroupFlag=""
                        s DrugInfoID = 0
                        if ((Config=1)&(PatientDR'="")&(VisitID'=""))
                        {
                        	s DrugInfoID = $o(^WDT.CDSS.DrugInfoI("UniquePatIndex",PatientDR,VisitID,VisitTypeValue," "_GroupFlag,DrugInfoID))
                        }
                        else
                        {
	                        s DrugInfoID = $o(^WDT.CDSS.DrugInfoI("UniqueIDNOIndex"," "_$zcvt(IDNO,"U")," "_GroupFlag,DrugInfoID))
	                    }
                        d ##class(WDT.CDSS.DrugInfo).%DeleteId(DrugInfoID)
                        d SaveSatisfyIW(IDNO,PatientDR,VisitID,VisitTypeValue,TableName,"DrugName")
                    }
                    elseif (TableName ="WDT.CDSS.ExamInfo")  //删除检查信息表
                    {
                        //医嘱单号为唯一标识GroupFlag
                        s GroupFlag=GrandChildrenJson.%Get("GroupFlag")
                        q:GroupFlag=""
                        s ExamInfoID = 0
                        if ((Config=1)&(PatientDR'="")&(VisitID'=""))
                        {
                            s ExamInfoID = $o(^WDT.CDSS.ExamInfoI("UniquePatIndex",PatientDR,VisitID,VisitTypeValue," "_GroupFlag,ExamInfoID))
                        }
                        else
                        {
	                        s ExamInfoID = $o(^WDT.CDSS.ExamInfoI("UniqueIDNOIndex"," "_$zcvt(IDNO,"U")," "_GroupFlag,ExamInfoID))
	                    }
                        d ##class(WDT.CDSS.ExamInfo).%DeleteId(ExamInfoID)
                        d SaveSatisfyIW(IDNO,PatientDR,VisitID,VisitTypeValue,TableName,"ExamName")
                    }
                    elseif (TableName = "WDT.CDSS.LabInfo") //删除检验信息表
                    {
	                    
                        //医嘱单号为唯一标识GroupFlag
                        s GroupFlag=GrandChildrenJson.%Get("GroupFlag")
                        q:GroupFlag=""
                        s LabInfoID = 0
						if ((Config=1)&(PatientDR'="")&(VisitID'=""))
						{
							for
	                        {
	                            s LabInfoID = $o(^WDT.CDSS.LabInfoI("UniquePatIndex",PatientDR,VisitID,VisitTypeValue," "_GroupFlag,LabInfoID))
	                            q:LabInfoID=""
	                            d ##class(WDT.CDSS.LabInfo).%DeleteId(LabInfoID)
	                        }
						}
						else
						{
							for
	                        {
	                            s LabInfoID = $o(^WDT.CDSS.LabInfoI("UniqueIDNOIndex"," "_$zcvt(IDNO,"U")," "_GroupFlag,LabInfoID))
	                            q:LabInfoID=""
	                            d ##class(WDT.CDSS.LabInfo).%DeleteId(LabInfoID)
	                        }
						}

                        d ##class(WDT.CDSS.LabInfo).%DeleteId(LabInfoID)
                        d SaveSatisfyIW(IDNO,PatientDR,VisitID,VisitTypeValue,TableName,"InspectionName")
                    }
                    elseif (TableName = "WDT.CDSS.OtherOrderInfo") //删除其它医嘱信息表
                    {
	                    
                        //医嘱单号为唯一标识GroupFlag
                        s GroupFlag=GrandChildrenJson.%Get("GroupFlag")
                        
                        q:GroupFlag=""
                        s LabInfoID = 0
						if ((Config=1)&(PatientDR'="")&(VisitID'=""))
						{
                            s LabInfoID = $o(^WDT.CDSS.OtherOrderInfoI("UniquePatIndex",PatientDR,VisitID,VisitTypeValue," "_GroupFlag,LabInfoID))
						}
						else
						{
							s LabInfoID = $o(^WDT.CDSS.OtherOrderInfoI("UniqueIDNOIndex"," "_$zcvt(IDNO,"U")," "_GroupFlag,LabInfoID))
						}
                        d ##class(WDT.CDSS.OtherOrderInfo).%DeleteId(LabInfoID)
                    }
                    elseif (TableName = "WDT.CDSS.NursingInfo") //删除护理信息表
                    {
	                    
                        //医嘱单号为唯一标识GroupFlag
                        s NursingItemCode=GrandChildrenJson.%Get("NursingItemCode")
                        s GroupFlag=GrandChildrenJson.%Get("GroupFlag")
                        q:((NursingItemCode="")||(GroupFlag=""))
                        s LabInfoID = 0
                        if ((Config=1)&(PatientDR'="")&(VisitID'=""))
                        {
	                        s LabInfoID = $o(^WDT.CDSS.NursingInfoI("UniquePatIndex",PatientDR,VisitID,VisitTypeValue,GroupFlag,LabInfoID))
	                    }
	                    else
	                    {
		                    s LabInfoID = $o(^WDT.CDSS.NursingInfoI("UniqueIDNOIndex"," "_$zcvt(IDNO,"U"),GroupFlag,LabInfoID))
		                }
                        d ##class(WDT.CDSS.NursingInfo).%DeleteId(LabInfoID)
                        d SaveSatisfyIW(IDNO,PatientDR,VisitID,VisitTypeValue,TableName,"NursingItemName")
                    }
                    elseif (TableName = "WDT.CDSS.AllergyHistory") //删除过敏信息表
                    {
	                    
                        //医嘱单号为唯一标识GroupFlag
                        s AllergyItemCode=GrandChildrenJson.%Get("AllergyHistoryNum")
                        
                        q:AllergyItemCode=""
                        s LabInfoID = 0
                        for
                        {
	                         
                            s LabInfoID = $o(^WDT.CDSS.AllergyHistoryI("AllergyHistoryNum",PatientDR,AllergyItemCode,LabInfoID))
                            q:LabInfoID=""
                            d ##class(WDT.CDSS.AllergyHistory).%DeleteId(LabInfoID)
                        }
                        d SaveSatisfyIW(IDNO,PatientDR,VisitID,VisitTypeValue,TableName,"AllergySourceName")
                    }
                }
            }
        }
    }
SaveSatisfyIW(IDNOValue,PatientDRValue,VisitIDValue,VisitTypeValue,TableName,fieldkey)
	//判断该字段是否要触发识别词
    s TableRowID = $o(^CT.WDT.CDSS.DataTableDictI("TableNameIndex",TableName,fieldkey,""))
    s PMDataType=$lg($g(^CT.WDT.CDSS.DataTableDictD(TableRowID)),14)
    s Config=##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSSdyn20200416")
	s:Config="" Config = "1"
    if (PMDataType'="")
	{
		s PMDataTypeNum=$l(PMDataType,"&")
		for zz=0:1:(PMDataTypeNum-1)
		{
			s DataType=$p(PMDataType,"&",zz+1)
			if (Config=1){
				continue:$d(^WDT.CDSS.PatPMTypeIndexI("PatVisDRUpTypeIndex",PatientDRValue,VisitIDValue,VisitTypeValue,1,DataType))
			}else{
				continue:$d(^WDT.CDSS.PatPMTypeIndexI("IDNOUpTypeIndex",IDNOValue,1,DataType))
			}
			s PMobj=##class(WDT.CDSS.PatPMTypeIndex).%New()
			s PMobj.IDNO=IDNOValue
			s PMobj.PatientDR=PatientDRValue
			s PMobj.VisitID=VisitIDValue
			s PMobj.VisitType=VisitTypeValue
			s PMobj.DataType=DataType
			s PMobj.IsLastUpdate=1
			d PMobj.%Save()
			d PMobj.%Close()
		}
	}    
    q ""
}

/// Creator:范文凯
/// CreatDate:2020-08-12
/// Description：清空该患者本次就诊的所有诊断信息
/// Input：PatientUserInfo
/// Output: 
/// w ##class(web.CDSS.MachineLearning.ParseMode).DeletePatientDiagnose(PatientDR,VisitID,VisitType,IDNO,Config)
ClassMethod DeletePatientDiagnose(PatientDR, VisitID, VisitType, IDNO, Config) As %String
{
    n (PatientDR,VisitID,VisitType,IDNO,Config)
    if ((Config=1)&(PatientDR'="")&(VisitID'=""))
    {
        s DiagnosisSequence = 0
        for
        {
            s DiagnosisSequence  = $o(^WDT.CDSS.DiagnosisInfoI("PatVisDRTySequenceIndex",PatientDR,VisitID,VisitType,DiagnosisSequence))
            q:DiagnosisSequence=""
            s DiagnoseRowID = $o(^WDT.CDSS.DiagnosisInfoI("PatVisDRTySequenceIndex",PatientDR,VisitID,VisitType,DiagnosisSequence,0))
            d ##class(WDT.CDSS.DiagnosisInfo).%DeleteId(DiagnoseRowID)
        }
    }
    else
    {
        s DiagnoseRowID = 0
        for
        {
            s DiagnoseRowID  = $o(^WDT.CDSS.DiagnosisInfoI("IDNOIndex"," "_$zcvt(IDNO,"U"),DiagnoseRowID))
            q:DiagnoseRowID=""
            d ##class(WDT.CDSS.DiagnosisInfo).%DeleteId(DiagnoseRowID)
        }
    }
    q "success"
}

/// Creator:范文凯
/// CreatDate:2022-04-08
/// Description：删除医嘱后要更新患者的触发识别器
/// Input：PatientUserInfo
/// Output: 
/// w ##class(web.CDSS.MachineLearning.ParseMode).upPatPMTypeIndex(TableName)
ClassMethod upPatPMTypeIndex(TableName, IDNO, PatientDR, VisitID, VisitType) As %String
{
	n (TableName,IDNO,PatientDR, VisitID,VisitType)
	s PMDataType=""
	if (TableName="WDT.CDSS.DiagnosisInfo"){
		s PMDataType="诊断&诊断症状"
	}elseif(TableName="WDT.CDSS.OperationInfo")
	{
		s PMDataType="手术"
	}elseif(TableName="WDT.CDSS.DrugInfo")
	{
		s PMDataType="药品"
	}elseif(TableName="WDT.CDSS.ExamInfo")
	{
		s PMDataType="检查&检查结果"
	}elseif(TableName="WDT.CDSS.LabInfo")
	{
		s PMDataType="检验"
	}elseif(TableName="WDT.CDSS.NursingInfo")
	{
		s PMDataType="护理"
	}elseif(TableName="WDT.CDSS.AllergyHistory")
	{
		s PMDataType="过敏史"
	}
    if (PMDataType'="")
	{
		s PMDataTypeNum=$l(PMDataType,"&")
		for i=0:1:(PMDataTypeNum-1)
		{
			s DataType=$p(PMDataType,"&",i+1)
			continue:$d(^WDT.CDSS.PatPMTypeIndexI("PatVisDRUpTypeIndex",PatientDR,VisitID,1,DataType))
			s PMobj=##class(WDT.CDSS.PatPMTypeIndex).%New()
			s PMobj.IDNO=IDNO
			s PMobj.PatientDR=PatientDR
			s PMobj.VisitID=VisitID
			s PMobj.VisitType=VisitType
			s PMobj.DataType=DataType
			s PMobj.IsLastUpdate=1
			d PMobj.%Save()
			d PMobj.%Close()
		}
	}
	q ""
}

}
