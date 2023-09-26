Class EMRservice.BL.BLDPCategory Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:      取科室短语目录
/// CreateDate:2021-10-13
/// Input:     AUserLocID 科室ID
///            AUserID    用户ID
/// Debug:     w ##Class(EMRservice.BL.BLDPCategory).getDPCategory(95,6)
ClassMethod getDPCategory(AUserLocID As %String, AUserID As %String) As %GlobalBinaryStream
{
    s json = ##Class(%GlobalBinaryStream).%New()
    s DPTreeBaseDesc = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans","科室短语")
    d json.Write("[{""id"":""0"",""text"":"""_DPTreeBaseDesc_""",""state"":""open""")
    d json.Write(",""attributes"":{")
    d json.Write("""type"":""DPTreeBase""")
    d json.Write(",""personalDPUserID"":""""")
    d json.Write(",""textData"":""""}")
    
    s tempjson = ##Class(%GlobalBinaryStream).%New()
    d tempjson
    if (tempjson.Size '= 0){
        d json.Write(",""children"":[")
        d json.CopyFrom(tempjson)
        d json.Write("]")
    }
    d json.Write("}]")
    q json
tempjson
    s DPData = ..getDPData(0,AUserLocID,AUserID)
    d:(DPData.Size '= 0) tempjson.CopyFrom(DPData)
    if (AUserLocID '= ""){
        //个人共享目录
        s DPShareData = ..getShareDPData(AUserLocID)
        if (DPShareData.Size '= 0){
            d:(tempjson.Size '= 0) tempjson.Write(",")
            s DPShareTree = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans","共享科室短语")
            d tempjson.Write("{""id"":""ShareDPTree"",""text"":"""_DPShareTree_""",""state"":""closed""")
            d tempjson.Write(",""attributes"":{""type"":""ShareDPTree""")
            d tempjson.Write(",""personalDPUserID"":""""")
            d tempjson.Write(",""textData"":""""")
            d tempjson.Write("},""children"":[")
            d tempjson.CopyFrom(DPShareData)
            d tempjson.Write("]}")
        }
    }
    q
}

/// Desc:      取科室短语目录数据
/// CreateDate:2021-10-13
/// Input:     AParentID  父节点
///            AUserLocID 科室ID,为空时获取全院科室短语
///            AUserID    用户ID
/// Debug:     w ##Class(EMRservice.BL.BLDPCategory).getDPData(0,95,6)
ClassMethod getDPData(AParentID As %String, AUserLocID As %String, AUserID As %String) As %GlobalBinaryStream
{
    s json = ##Class(%GlobalBinaryStream).%New()
    q:(AParentID = "") json
    
    s langid=20
    if ($d(%session)){
        set langid=+$g(%session.Data("LOGON.LANGID"))
    }
    s seq = ""
    for
    {
        s seq = $o(^DHCEMRM.DPCategoryI("IdxParentIDSeq",AParentID,seq))
        q:(seq = "")
        s rowId = ""
        for
        {
            s rowId = $o(^DHCEMRM.DPCategoryI("IdxParentIDSeq",AParentID,seq,rowId))
            q:(rowId = "")
            s obj = ##Class(EMRmeta.DPCategory).%OpenId(rowId)
            q:(obj = "")
            q:(obj.IsValid = "N")
            
            if (AUserLocID '= ""){
                //过滤科室ID的科室短语节点
                q:((AParentID = 0)&&(obj.PersonalDPUserID = "")&&($d(^DHCEMRM.DPCTLocI("IdxCategoryLocID",rowId,AUserLocID))<=0))
                //过滤用户ID的个人短语节点
                q:((AUserID '= "")&&(obj.PersonalDPUserID '= "")&&(obj.PersonalDPUserID '= AUserID))
            }else{
                //过滤个人短语节点
                q:(obj.PersonalDPUserID '= "")
            }
            
            d:(json.Size '= 0) json.Write(",")
            d json.Write("{""id"":"""_rowId_"""")
            s name = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(obj.Name)
            s name = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.DPCategory","Name",name,langid)
            d json.Write(",""text"":"""_name_"""")
            if (obj.Type [ "DPTree")
            {
                d json.Write(",""state"":""closed""")
            }
            d json.Write(",""attributes"":{")
            d json.Write("""type"":"""_obj.Type_"""")
            d json.Write(",""personalDPUserID"":"""_obj.PersonalDPUserID_"""")
            d json.Write(",""parentID"":"""_obj.ParentID_"""")
            d json.Write(",""textData"":""")
            s textData = ..getDPNodeContent(rowId)
            d json.CopyFrom(textData)
            d json.Write("""")
            s DPNodeID = ..getDPNodeID(rowId)
            d json.Write(",""DPNodeID"":"""_DPNodeID_"""")
            s child = ..getDPData(rowId,AUserLocID,AUserID)
            if (child.Size '= 0)
            {
                d json.Write(",""isLeaf"":""N""},""children"":[")
                d json.CopyFrom(child)
                d json.Write("]")
            }else
            {
                if (obj.Type [ "DPTree"){
                    d json.Write(",""isLeaf"":""Y""")
                }
                d json.Write("}")
            }
            d json.Write("}")
        }
    }
    
    q json
}

/// Desc:      取个人科室短语的共享目录数据
/// CreateDate:2021-10-13
/// Input:     AUserLocID 科室ID
/// Debug:     w ##Class(EMRservice.BL.BLDPCategory).getShareDPData(95)
ClassMethod getShareDPData(AUserLocID As %String) As %GlobalBinaryStream
{
    s json = ##Class(%GlobalBinaryStream).%New()
    q:(AUserLocID = "") json
    
    s langid=20
    if ($d(%session)){
        set langid=+$g(%session.Data("LOGON.LANGID"))
    }
    s key = $i(^CacheTemp)
    k ^TempDPShareData(key)
    s seq = ""
    for
    {
        s seq = $o(^DHCEMRM.DPShareI("IdxCTLocIDSeq"," "_AUserLocID,seq))
        q:(seq = "")
        s rowId = ""
        for
        {
            s rowId = $o(^DHCEMRM.DPShareI("IdxCTLocIDSeq"," "_AUserLocID,seq,rowId))
            q:(rowId = "")
            s objShare = ##Class(EMRmeta.DPShare).%OpenId(rowId)
            q:(objShare = "")
            s obj = ##Class(EMRmeta.DPCategory).%OpenId(objShare.CategoryID)
            q:(obj = "")
            q:(obj.IsValid = "N")
            s tempjson = "{""id"":"""_rowId_""""
            s name = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(obj.Name)
            s name = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.DPCategory","Name",name,langid)
            s tempjson = tempjson_",""text"":"""_name_""""
            s tempjson = tempjson_",""attributes"":{"
            s tempjson = tempjson_"""type"":""ShareDPNode"""
            s tempjson = tempjson_",""personalDPUserID"":"""_obj.PersonalDPUserID_""""
            s tempjson = tempjson_",""CategoryID"":"""_objShare.CategoryID_""""
            s tempjson = tempjson_",""textData"":"""
            s textData = ""
            s textContent = ..getDPNodeContent(objShare.CategoryID)
            while (textContent.AtEnd = 0)
            {
                s textData = textData_$ZSTRIP(textContent.Read(32000),"*C",,$c(1)_$c(2))
            }
            s tempjson = tempjson_textData_""""
            s DPNodeID = ..getDPNodeID(objShare.CategoryID)
            s tempjson = tempjson_",""DPNodeID"":"""_DPNodeID_""""
            s tempjson = tempjson_"}}"
            s ^TempDPShareData(key,objShare.UserID,seq) = tempjson
        }
    }
    s userID = "", currUserID = ""
    for
    {
        s userID = $o(^TempDPShareData(key,userID))
        q:(userID = "")
        if (currUserID '= userID){
            s currUserID = userID
            s userName = ##class(EMRservice.BL.BLPowerUser).GetUserName(userID)
            d:(json.Size '= 0) json.Write("]},")
            s id = "ShareDPTree-"_currUserID
            s shareDPTree = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans",userName_"的共享短语")
            d json.Write("{""id"":"""_id_""",""text"":"""_shareDPTree_""",""state"":""closed""")
            d json.Write(",""attributes"":{""type"":""ShareDPTree""")
            d json.Write(",""shareDPUserID"":"""_userID_"""")
            d json.Write(",""textData"":""""")
            d json.Write("},""children"":[")
        }
        s seq = "",i = 0
        for
        {
            s seq = $o(^TempDPShareData(key,userID,seq))
            q:(seq = "")
            d:(i '= 0) json.Write(",")
            d json.Write(^TempDPShareData(key,userID,seq))
            s i = i + 1
        }
    }
    d:(json.Size '= 0) json.Write("]}")
    k ^TempDPShareData(key)
    
    q json
}

/// Desc:      获取科室短语节点内容的ID
/// CreateDate:2021-10-13
/// Input:     AID  目录节点ID
/// Debug:     w ##Class(EMRservice.BL.BLDPCategory).getDPNodeID("4")
ClassMethod getDPNodeID(AID As %String) As %String
{
    s rowId = ""
    q:(AID = "") rowId
    s obj = ##class(EMRmeta.DPCategory).%OpenId(AID)
    q:(obj = "") rowId
    s rowId = $o(^DHCEMRM.DPContentI("IdxCategoryID",AID,""))
    q:(rowId = "") rowId
    q rowId
}

/// Desc:      获取科室短语节点内容
/// CreateDate:2021-10-13
/// Input:     AID  目录节点ID
/// Debug:     w ##Class(EMRservice.BL.BLDPCategory).getDPNodeContent("4")
ClassMethod getDPNodeContent(AID As %String) As %GlobalBinaryStream
{
    s text = ##Class(%GlobalBinaryStream).%New()
    q:(AID = "") text
    s obj = ##class(EMRmeta.DPCategory).%OpenId(AID)
    q:(obj = "") text
    s rowId = $o(^DHCEMRM.DPContentI("IdxCategoryID",AID,""))
    q:(rowId = "") text
    s objContent = ##class(EMRmeta.DPContent).%OpenId(rowId)
    q:(objContent = "") text
    while('objContent.TextData.AtEnd)
    {
        s tmptxt = objContent.TextData.Read(1)
        s:(tmptxt = " ") tmptxt = "&nbsp;"
        s:(tmptxt = $c(10))||(tmptxt = $c(13)) tmptxt = "<br/>"
        d text.Write(tmptxt)
    }
    q text
}

/// Desc:      保存目录节点
/// CreateDate:2021-10-13
/// Input:     AParentID  父节点
///            AName      目录节点名称
///            AType      目录节点类型
///            AUserID    用户ID
/// Output:    json  
/// Debug:     w ##Class(EMRservice.BL.BLDPCategory).newDP(0,"新建目录","PersonalDPTree","6")
/// Debug:     w ##Class(EMRservice.BL.BLDPCategory).newDP(0,"新建节点","PersonalDPNode","6")
ClassMethod newDP(AParentID As %String, AName As %String, AType As %String, AUserID As %String) As %GlobalBinaryStream
{
    s json = ##Class(%GlobalBinaryStream).%New()
    q:(AParentID = "")||(AType = "") json
    s cateID = ..createDPCategory(AParentID,AName,AType,AUserID)
    q:(cateID = "0") json
    s name = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans",AName)
    d json.Write("[{""id"":"""_cateID_"""")
    d json.Write(",""text"":"""_name_"""")
    if (AType [ "DPTree")
    {
        d json.Write(",""state"":""closed""")
    }
    else
    {
        s DPNodeID = ..createDPContent(cateID,AUserID)
        if (DPNodeID = "0")
        {
            d json.Clear()
            q json
        }
        
    }
    d json.Write(",""attributes"":")
    d json.Write("{""type"":"""_AType_"""")
    d json.Write(",""personalDPUserID"":"""_AUserID_"""")
    d json.Write(",""textData"":""""")
    d json.Write(",""parentID"":"""_AParentID_"""")  
    if (AType [ "DPTree"){
        d json.Write(",""isLeaf"":""Y""")
        d json.Write("}")
    }else{
        d json.Write(",""DPNodeID"":"""_DPNodeID_"""")
        d json.Write("}")
    }
    d json.Write("}]")      
    q json
}

/// Desc:      创建目录/节点
/// CreateDate:2021-10-13
/// Input:     AParentID  父节点
///            AName      目录/节点名称
///            AType      目录/节点类型
///            AUserID    用户ID
/// Debug:     w ##Class(EMRservice.BL.BLDPCategory).createDPCategory(0,"新建目录",DPTree","")
/// Debug:     w ##Class(EMRservice.BL.BLDPCategory).createDPCategory(0,"新建节点","PersonalDPTree","6")
ClassMethod createDPCategory(AParentID As %String, AName As %String, AType As %String, AUserID As %String = "") As %String
{
    s result = "0"
    q:(AParentID = "")||(AType = "") result
    s obj = ##class(EMRmeta.DPCategory).%New()
    s obj.Name = AName
    s obj.Type = AType
    s obj.ParentID = AParentID
    s obj.PersonalDPUserID = AUserID
    s obj.IsValid = "Y"
    s obj.Sequence = $case($d(^DHCEMRM.DPCategoryD)>0,0:1,:^DHCEMRM.DPCategoryD+1)
    s sc = obj.%Save()
    s:($$$ISOK(sc)) result = obj.%Id()
    d obj.%Close()
    k obj
    q result
}

/// Desc:      创建节点内容
/// CreateDate:2021-10-13
/// Input:     AID        关联表EMRmeta.DPCategory
///            AUserID    用户ID
///            AContent   节点内容
/// Debug:     w ##Class(EMRservice.BL.BLDPCategory).createDPContent(0,"6","")
ClassMethod createDPContent(AID As %String, AUserID As %String) As %String
{
    s result = "0"
    q:(AID = "") result
    s obj = ##class(EMRmeta.DPContent).%New()
    s obj.CategoryID = AID
    s obj.UserID = AUserID
    s obj.CreateDate = $zd($P($H,",",1),3)_" "_$zt($P($H,",",2),1)
    s obj.AuditID = AUserID
    s obj.AuditDate = $zd($P($H,",",1),3)_" "_$zt($P($H,",",2),1)
    s obj.Status = "1"
    s sc = obj.%Save()
    s:($$$ISOK(sc)) result = obj.%Id()
    d obj.%Close()
    k obj
    q result
}

/// Desc:      修改目录节点名称
/// CreateDate:2021-10-13
/// Input:     AID        目录节点ID
///            AName      名称
/// Debug:     w ##Class(EMRservice.BL.BLDPCategory).updateDPCateName("1","新建目录一")
ClassMethod updateDPCateName(AID As %String, AName As %String) As %String
{
    s result = "0"
    q:(AID = "") result
    s obj = ##class(EMRmeta.DPCategory).%OpenId(AID)
    q:(obj = "") result
    s obj.Name = AName
    s sc = obj.%Save()
    s:($$$ISOK(sc)) result = "1"
    d obj.%Close()
    k obj 
    q result
}

/// Desc:      停用目录/节点
/// CreateDate:2021-10-13
/// Input:     AID        目录节点ID
/// Debug:     w ##Class(EMRservice.BL.BLDPCategory).stopDPCategory("1","N")
ClassMethod stopDPCategory(AID As %String, AIsValid As %String) As %String
{
    s result = "0"
    q:(AID = "") result
    s obj = ##class(EMRmeta.DPCategory).%OpenId(AID)
    q:(obj = "") result
    s obj.IsValid = AIsValid
    s sc = obj.%Save()
    s:($$$ISOK(sc)) result = "1"
    d obj.%Close()
    k obj
    q result
}

/// Desc:      分享个人科室短语
/// CreateDate:2021-10-13
/// Input:     AID        目录节点ID
///            AUserLocID 科室ID
///            AUserID    用户ID
/// Debug:     w ##Class(EMRservice.BL.BLDPCategory).SharePersonalDPNode("1","95","6")
ClassMethod SharePersonalDPNode(AID As %String, AUserLocID As %String, AUserID As %String) As %String
{
    s result = "0"
    q:(AID = "")||(AUserLocID = "")||(AUserID = "") result
    s DPShareID = $o(^DHCEMRM.DPShareI("IdxUserIDCTLocIDCategoryID"," "_AUserID," "_AUserLocID,AID,""))
    q:(DPShareID '= "") "-1"
    s obj = ##Class(EMRmeta.DPShare).%New()
    s obj.CategoryID = AID
    s obj.UserID = AUserID
    s obj.CTLocID = AUserLocID
    s obj.ShareDate = $zd($P($H,",",1),3)_" "_$zt($P($H,",",2),1)
    s obj.Sequence = $case($d(^DHCEMRM.DPShareD)>0,0:1,:^DHCEMRM.DPShareD+1)
    s sc = obj.%Save()
    s:($$$ISOK(sc)) result = obj.%Id()
    d obj.%Close()
    k obj
    q result
}

/// Desc:      取消分享个人科室短语
/// CreateDate:2021-10-13
/// Input:     AID        目录节点ID
///            AUserLocID 科室ID
///            AUserID    用户ID
/// Debug:     w ##Class(EMRservice.BL.BLDPCategory).CancelSharePersonalDPNode("1","95","6")
ClassMethod CancelSharePersonalDPNode(AID As %String, AUserLocID As %String, AUserID As %String) As %String
{
    s result = "0"
    q:(AID = "")||(AUserLocID = "")||(AUserID = "") result
    
    s DPShareID = $o(^DHCEMRM.DPShareI("IdxUserIDCTLocIDCategoryID"," "_AUserID," "_AUserLocID,AID,""))
    q:(DPShareID = "") result
    s sc = ##Class(EMRmeta.DPShare).%DeleteId(DPShareID)
    s:($$$ISOK(sc)) result = "1"
    q result
}

/// Desc:      获取科室短语节点数据
/// CreateDate:2021-10-13
/// Input:     AID  目录节点ID
/// Debug:     w ##Class(EMRservice.BL.BLDPCategory).getDPNodeData("6")
ClassMethod getDPNodeData(AID As %String) As %GlobalBinaryStream
{
    s json = ##Class(%GlobalBinaryStream).%New()
    q:(AID = "") json
    s obj = ##class(EMRmeta.DPCategory).%OpenId(AID)
    q:(obj = "") json
    s rowId = $o(^DHCEMRM.DPContentI("IdxCategoryID",AID,""))
    q:(rowId = "") json
    s objContent = ##class(EMRmeta.DPContent).%OpenId(rowId)
    q:(objContent = "") json
    s langid=20
    if ($d(%session)){
        set langid=+$g(%session.Data("LOGON.LANGID"))
    }
    s name = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.DPCategory","Name",obj.Name,langid)
    s isEmpty = $case(objContent.Content.Size,0:"Y",:"N")
    d json.Write("[{""id"":"""_rowId_"""")
    d json.Write(",""text"":"""_name_"""")
    d json.Write(",""desc"":"""_obj.Description_"""")
    d json.Write(",""type"":"""_obj.Type_"""")
    d json.Write(",""isValid"":"""_obj.IsValid_"""")
    d json.Write(",""CategoryID"":"""_AID_"""")
    d json.Write(",""textData"":""")
    s textData = ..getDPNodeContent(AID)
    d json.CopyFrom(textData)
    d json.Write("""")
    d json.Write(",""isEmpty"":"""_isEmpty_"""}]")
    
    q json
}

/// Desc:       保存科室短语xml数据
/// Createdate: 2021-10-13
/// Input:      AInData 模板文件流
///             AContentID EMRmeta.DPContent表rowID
/// Output:     result 1成功,-1失败 
ClassMethod SaveDPComposite(AInData As %GlobalBinaryStream, AContentID As %String) As %String
{
    s result = "-1"     
    q:((AContentID = "")||(AInData = "")) result 
    s objContent = ##Class(EMRmeta.DPContent).%OpenId(AContentID)
    q:(objContent = "") result
    d objContent.Content.CopyFrom(AInData)
    s sc = objContent.%Save()
    s:($$$ISOK(sc)) result = "1"
    q result
}

/// Desc:       加载科室短语xml数据
/// CreateDate: 2021-10-13
/// Input:      AContentID EMRmeta.DPContent表rowID
/// OutPut:     OutRecords 科室短语xml流
/// Deubgger:   w ##Class(EMRservice.BL.BLDPCategory).LoadDPComposite("",4)
ClassMethod LoadDPComposite(ByRef AOutRecords As %GlobalBinaryStream, AContentID As %String) As %String
{
    s result = "-1"     
    q:(AContentID = "") result
    s objContent = ##class(EMRmeta.DPContent).%OpenId(AContentID)
    q:(objContent = "") result
    d AOutRecords.CopyFrom(objContent.Content)
    s result = "1"
    q result
}

/// Desc:      修改节点数据
/// CreateDate:2021-10-13
/// Input:     AID        目录节点ID
///            ADesc      描述信息
///            AName      名称
///            AIsValid   是否有效
///            AContentID EMRmeta.DPContent表rowID
///            ATextData  纯文本内容
/// Debug:     w ##Class(EMRservice.BL.BLDPCategory).UpdateDPNodeData("1","描述信息","名称","Y","4","内容")
ClassMethod UpdateDPNodeData(AID As %String, ADesc As %String, AName As %String, AIsValid As %String, AContentID As %String, ATextData As %String) As %String
{
    s result = "0"
    q:(AID = "")||(AContentID = "") result
    s obj = ##class(EMRmeta.DPCategory).%OpenId(AID)
    q:(obj = "") result
    s obj.Description = ##Class(EMRservice.Tools.Tool).UnEscape(ADesc)
    s obj.Name = ##Class(EMRservice.Tools.Tool).UnEscape(AName)
    s obj.IsValid = AIsValid
    s objContent = ##class(EMRmeta.DPContent).%OpenId(AContentID)
    q:(objContent = "") result
    d objContent.TextData.Write(ATextData)
    
    s $zt = "UpdateErrorHandler"
    TStart
    s scResult = obj.%Save()
    if ($$$ISERR(scResult))
    {
        TROLLBACK
        q result
    }
    s sc = objContent.%Save() 
    if ($$$ISERR(sc))
    {
        TROLLBACK
        q result
    }
    TCOMMIT            
    d obj.%Close()
    d objContent.%Close()
    k obj,objContent
    s result = "1"
    q result

UpdateErrorHandler
    TROLLBACK
    q result
}

/// ////////科室配置界面方法////////////
/// 获取所有科室数据
/// Debug:  d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLDPCategory","SelectAllLoc")
Query SelectAllLoc(desc As %String = "") As %SQLQuery(CONTAINID = 2, ROWSPEC = "id:%String,text:%String")
{
    SELECT CTLOC_RowId,CTLOC_CODE || " " || upper(CTLOC_Desc) From SQLUser.CT_Loc Where ((%ALPHAUP CTLOC_CODE || " " || upper(CTLOC_Desc) [ %ALPHAUP :desc) OR (:desc IS NULL)) AND (CTLOC_Type='E' or CTLOC_Type='OP' or CTLOC_Type='OR' or CTLOC_Type='EM')  Order By CTLOC_Desc,CTLOC_RowId
}

/// Desc:      根据入参获取所有科室数据  
/// CreateDate:2021-10-13
/// Input:     ADesc  过滤字段（科室描述）
/// Output:    id     科室ID
///            text   科室描述
/// Debug:     w ##Class(EMRservice.BL.BLDPCategory).getAllLocData()
ClassMethod getAllLocData(ADesc As %String = "") As %GlobalCharacterStream
{
    s json = ##Class(%GlobalCharacterStream).%New()
    s ds = ##class(%ResultSet).%New("EMRservice.BL.BLDPCategory:SelectAllLoc")
    d ds.Execute(ADesc)
    s result = "", count = 0
    While (ds.Next()){
        s:(count '= 0) result = result_","
        s result = result_"{""id"":"""_ds.Data("id")_""""
        s result = result_",""text"":"""_ds.Data("text")_"""}"
        s count = count + 1
    }
    s result = $ZSTRIP(result,"*C")
    d json.Write("{""total"":"_count_",""rows"":["_result_"]}")
    q json
}

/// Desc:      根据ID获取关联科室数据  
/// CreateDate:2021-10-13
/// Input:     AID    目录节点ID
/// Output:    id     科室ID
///            text   科室描述
/// Debug:     w ##Class(EMRservice.BL.BLDPCategory).getSelCTLocData("1")
ClassMethod getSelCTLocData(AID As %String) As %GlobalCharacterStream
{
    s json = ##Class(%GlobalCharacterStream).%New()
    if (AID = "") {
        d json.Write("{""total"":0,""rows"":[]}")
        q json
    }
    s seq = "", result = "", count = 0
    for {
        s seq = $o(^DHCEMRM.DPCTLocI("IdxCategorySeq",AID,seq))
        q:(seq = "")
        s rowID = $o(^DHCEMRM.DPCTLocI("IdxCategorySeq",AID,seq,""))
        continue:(rowID = "")
        s obj = ##class(EMRmeta.DPCTLoc).%OpenId(rowID)
        continue:(obj = "")
        s:(count '= 0) result = result_","
        s result = result_"{""id"":"""_obj.CTLocID_""""
        s result = result_",""text"":"""_obj.CTLocDesc_"""}"
        s count = count + 1
        d obj.%Close()
    }
    
    s result = $ZSTRIP(result,"*C")
    d json.Write("{""total"":"_count_",""rows"":["_result_"]}")
    q json
}

/// Desc:      检查目录节点是否在表中存在记录  
/// CreateDate:2021-10-13
/// Input:     AID    目录节点ID
/// Table:     EMRmeta.DPCTLoc
/// Output:    1-该目录在库中已经存在 0-该目录在库中不存在
/// Debug:     w ##Class(EMRservice.BL.BLDPCategory).CheckCTLoIDExist("1")
ClassMethod CheckCTLoIDExist(AID As %String) As %Integer
{
    s ret = 0
    q:(AID = "") ret
    
    s rowID = $o(^DHCEMRM.DPCTLocI("IdxCategoryLocID",AID,""))
    if (+rowID>0)
    {
        s ret = 1
    }
    q ret
}

/// Desc:      保存关联科室数据  
/// CreateDate:2021-10-13
/// Input:     AID    目录节点ID
///            AName  名称
///            AData  JSON格式数据
/// Output:    result 1成功,0失败
/// Debug:     w ##Class(EMRservice.BL.BLDPCategory).saveDPCTLoc("1","新名字","[{""id"":""260"",""text"":""ZYYJ003 X线室""},{""id"":""262"",""text"":""FYYJ001 CT室[分院]""}]")
ClassMethod saveDPCTLoc(AID As %String, AName As %String, AData As %String) As %String
{
    s result = "0"
    q:(AID = "") result
    s rtn = ..updateDPCateName(AID,AName)
    q:(rtn = "0") result
    s data = ##Class(%GlobalBinaryStream).%New()
    d data.Write(AData)
    s objJson = ##Class(EMRservice.Parser.Json).%New()  
    s array = objJson.Deserialize(data)
    s count = array.Count()
    
    s $ZT="ERROR"
    TStart
    s result = "1"
    //检查该科室短语是否已存在
    s CTLoIDExist = ..CheckCTLoIDExist(AID)
    if (CTLoIDExist = 0)
    {
        //创建
        d:(count > 0) addDPCTLoc
    }else{
        s ctlocID = "", deleteIDs = ""
        for {
            s ctlocID = $o(^DHCEMRM.DPCTLocI("IdxCategoryLocID",AID,ctlocID))
            q:(ctlocID = "")
            s rowID = $o(^DHCEMRM.DPCTLocI("IdxCategoryLocID",AID,ctlocID,""))
            continue:(rowID = "")
            s ctlocID = $tr(ctlocID," ","")
            //配置的科室数据为空,清空原先库中已有的记录
            if (count = 0){
                s deleteIDs = deleteIDs_$lb(rowID)
                continue
            }else{
                for i=1:1:count
                {
                    if (array.GetAt(i).Find(ctlocID) = "")
                    {
                        //依次判断原先库中存在的该节点挂接的科室是否存在新增的科室ID
                        s deleteIDs = deleteIDs_$lb(rowID)
                        q
                    }else{
                        //去掉已经找到的ctlocID
                        d array.RemoveAt(i)
                        q
                    }
                } 
            }
        }
        
        if (deleteIDs '= "")
        {
            for ind=1:1:$listlength(deleteIDs)
            {
                s deleteID = $listget(deleteIDs,ind)
                continue:(deleteID = "")
                s sc = ##class(EMRmeta.DPCTLoc).%DeleteId(deleteID)
                if ($$$ISERR(sc)){
                    TROLLBACK
                    s result = "0"
                    q
                }
            }   
        }
        
        s count = array.Count()
        if (count > 0){
            d addDPCTLoc
        }
    }
    if (result = "0"){
        TROLLBACK
    }else{
        TCommit
    }
    q result
ERROR
    Trollback
    q result
addDPCTLoc
    for i=1:1:count
    {
        s id = array.GetAt(i).GetAt("id")
        s text = array.GetAt(i).GetAt("text")
        q:(id = "")
        s objCTLoc = ##class(EMRmeta.DPCTLoc).%New()
        s objCTLoc.CategoryID = AID
        s objCTLoc.CTLocDesc = text
        s objCTLoc.CTLocID = id
        s objCTLoc.Sequence = $case($d(^DHCEMRM.DPCTLocD)>0,0:1,:^DHCEMRM.DPCTLocD+1)
        s sc = objCTLoc.%Save()
        if ($$$ISERR(sc)){
            TROLLBACK
            s result = "0"
            q
        }
        d objCTLoc.%Close()
    }
    q
}

/// Desc:      取共享科室短语目录数据   
/// CreateDate:2021-10-13
/// Input:     AUserLocID 科室ID
/// Debug:     w ##Class(EMRservice.BL.BLDPCategory).getAllShareDPTree(951)
ClassMethod getAllShareDPTree(AUserLocID As %String) As %GlobalBinaryStream
{
    s json = ##Class(%GlobalBinaryStream).%New()
    q:(AUserLocID = "") DPShareData
    s DPShareData = ..getShareDPData(AUserLocID)
    if (DPShareData.Size '= 0){
        s DPShareTree = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans","共享科室短语")
        d json.Write("[{""id"":""ShareDPTree"",""text"":"""_DPShareTree_""",""state"":""closed""")
        d json.Write(",""attributes"":{""type"":""ShareDPTree""")
        d json.Write(",""personalDPUserID"":""""")
        d json.Write(",""textData"":""""")
        d json.Write("},""children"":[")
        d json.CopyFrom(DPShareData)
        d json.Write("]}]")
    }
    q json
}

/// Desc:      修改科室短语目录的排序顺序号  
/// CreateDate:2021-10-13
/// Input:     CategoryID1树节点1
///            CategoryID2树节点2
/// Output:    result是否操作成功
/// Debug:     w ##Class(EMRservice.BL.BLDPCategory).SwapSequence(951)
ClassMethod SwapSequence(ACategoryID1 As %String, ACategoryID2 As %String) As %Boolean [ WebMethod ]
{
    s result = 0
    s objNextCategory = ##class(EMRmeta.DPCategory).%OpenId(ACategoryID1)
    s objSelectCategory = ##class(EMRmeta.DPCategory).%OpenId(ACategoryID2)
    q:((objNextCategory = "")||(objSelectCategory = "")) result
    
    s TempSequence = objNextCategory.Sequence
    s objNextCategory.Sequence = objSelectCategory.Sequence
    s objSelectCategory.Sequence = TempSequence
    
    s $zt = "SwapErrorHandler"
    TStart
    s scResult = objNextCategory.%Save() 
    if $$$ISERR(scResult)
    {
        Trollback
        q result
    }
    s scResultSele = objSelectCategory.%Save() 
    if $$$ISERR(objSelectCategory)
    {
        Trollback
        q result
    }
    TCOMMIT
    d objSelectCategory.%Close()
    d objNextCategory.%Close()
    s objSelectCategory = ""
    s objNextCategory = ""
    s result = 1
    q result
     
SwapErrorHandler
    q 0
}

}
