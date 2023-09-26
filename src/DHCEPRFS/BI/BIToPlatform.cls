Class DHCEPRFS.BI.BIToPlatform Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc:  通过就诊号获取权全部PDF路径
/// Input: AEpisodeID - 就诊rowid
/// Return: MRItemID_"^"_MRItemName_"^"_PDF路径_# 多行分隔符
/// Debug： w ##Class(DHCEPRFS.BI.BIToPlatform).GetEpisodePDFPath("1")
ClassMethod GetEpisodePDFPath(AEpisodeID As %String) As %String
{
	s ret = ""
	s webIP=##class(DHCEPRFS.BL.BLSysOption).GetValueByName("WebURL")
	s MREpisodeID=##Class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm(AEpisodeID,"DHC")
	s MRVersionID=##class(DHCEPRFS.BL.BLMRVersion).GetMRVersionID(MREpisodeID)
	
	s rset = ##class(%ResultSet).%New("DHCEPRFS.BL.BLMRVerItem:GetAllByMRVersion")
	S sc = rset.Execute(MRVersionID)
	While (rset.Next())
	{
		s MRItemID=rset.GetDataByName("MRItemID")
		s MRItemName=rset.GetDataByName("MRItemName")
		s mrVerItemID=rset.GetDataByName("MRVerItemID")
		s detailNum = ""
		s detailNum = $O(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain", mrVerItemID, detailNum),-1)
		continue:(detailNum="")
		s subID = $O(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain", mrVerItemID, detailNum, ""))    
		continue:(subID="")
		s mrVerItemDetailID = mrVerItemID_"||"_subID
		
		s objMRVerItemDetail = ##Class(DHCEPRFS.INST.MRVerItemDetail).%OpenId(mrVerItemDetailID)
		s FileMasterID = objMRVerItemDetail.FileMasterID
		s EncryFileMasterID=##class(web.Util.Encryption).SimpleEncrypt(FileMasterID)
		s PDFUrl=webIP_"DHCEPRFS.Util.PDFView.cls?FileID="_EncryFileMasterID
		s oneItemRet=MRItemID_"^"_MRItemName_"^"_PDFUrl
		if (ret = "")
		{
			s ret=oneItemRet
		}
		else
		{
			s ret=ret_"#"_oneItemRet
		}
		
	}
	q ret
}

/// Desc:   获取PDF路径
/// Input: AEpisodeID - 就诊rowid, AMRItemIDS - 归档项目ID的串
/// Return: PDF路径
/// Debug：  w ##Class(DHCEPRFS.BI.BIToPlatform).GetPDFPathByItemID("330","2","1")
ClassMethod GetPDFPathByItemID(AEpisodeID As %String, AMRItemIDS As %String, ADocumentID As %String = "") As %String
{
    s:(ADocumentID=$c(0)) ADocumentID = ""
    
    s ret = ""
    for index=1:1:$l(AMRItemIDS,"^")
    {
        s oneMRItemID = $p(AMRItemIDS,"^",index)
        s mrVerItemID = ##class(DHCEPRFS.BL.BLMRVerItem).GetVerItemByItemIDAndEpisodeID(AEpisodeID,oneMRItemID) 
        continue:(mrVerItemID="")
        if (ADocumentID ="")
        {   
            s detailNum = ""
            s detailNum = $O(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain", mrVerItemID, detailNum),-1)
            continue:(detailNum="")
            s subID = $O(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain", mrVerItemID, detailNum, ""))    
            continue:(subID="")
            s mrVerItemDetailID = mrVerItemID_"||"_subID
        
            s objMRVerItemDetail = ##Class(DHCEPRFS.INST.MRVerItemDetail).%OpenId(mrVerItemDetailID)
            s FileMasterID = objMRVerItemDetail.FileMasterID
            s FileLocPath = ##Class(DHCEPRFS.BL.BLFileMaster).GetFullFileLocName(FileMasterID)
            s ftpConfig = $p(FileLocPath,"@@@",1)
            s filePath = $p(FileLocPath,"@@@",2)
            if (ret = "")
            {
                s ret = "ftp://"_$p(ftpConfig,"^",4)_":"_$p(ftpConfig,"^",5)_"@"_$p(ftpConfig,"^",2)_":"_$p(ftpConfig,"^",3)_"/"_filePath    
            }
            else
            {
                s ret = ret_"^"_"ftp://"_$p(ftpConfig,"^",4)_":"_$p(ftpConfig,"^",5)_"@"_$p(ftpConfig,"^",2)_":"_$p(ftpConfig,"^",3)_"/"_filePath  
            }
        }
        else
        {   
            s rowID = $o(^DHCEPRFS.INST.MRVerSubItemI("IdxMRVerItemID"," "_mrVerItemID," "_$zcvt(ADocumentID,"U"),""),-1) //get last id
            continue:(rowID = "")
            
            s detailNum = ""
            s detailNum = $o(^DHCEPRFS.INST.MRVerSubItemDtlI("IdxMain",rowID,detailNum),-1)
            continue:(detailNum="")
            
            s rowIDSubItem = ""
            s rowIDSubItem = $o(^DHCEPRFS.INST.MRVerSubItemDtlI("IdxMain",rowID,detailNum,rowIDSubItem))
            if (rowIDSubItem '= "")
            {
                s rowIDSub = rowID_"||"_rowIDSubItem
                s obj = ##class(DHCEPRFS.INST.MRVerSubItemDetail).%OpenId(rowIDSub)
                s FileMasterID = obj.FileMasterID
                s FileLocPath = ##Class(DHCEPRFS.BL.BLFileMaster).GetFullFileLocName(FileMasterID)
                s ftpConfig = $p(FileLocPath,"@@@",1)
                s filePath = $p(FileLocPath,"@@@",2)
                if (ret = "")
                {
                    s ret = "ftp://"_$p(ftpConfig,"^",4)_":"_$p(ftpConfig,"^",5)_"@"_$p(ftpConfig,"^",2)_":"_$p(ftpConfig,"^",3)_"/"_filePath     
                }
                else
                {
                    s ret = ret_"^"_"ftp://"_$p(ftpConfig,"^",4)_":"_$p(ftpConfig,"^",5)_"@"_$p(ftpConfig,"^",2)_":"_$p(ftpConfig,"^",3)_"/"_filePath    
                }
            }
        }
    }
    q ret
}

ClassMethod RegDoc(AMRItemID As %String, AXMLStr As %String) As %String
{
    s ret=""
    s EpisodeID=""
    //取当前时间
    s now = $h
    s nowDate = $p(now,",",1)
    s nowTime = $p(now,",",2)
    
    s ^CacheTemp("yangpengtest","AXMLStr")=AXMLStr
    s sc=##class(%XML.TextReader).ParseString(AXMLStr,.reader)
    if $$$ISERR(sc)
    {
        d SetRet("-1")
        q ret
    }
    while(reader.Read())
    {
        //w reader.Name_"="_reader.Value,!
        if (reader.Name="PAADMVisitNumber")
        {
            d reader.Read()
            w "PAADMVisitNumber="_reader.Value
            s EpisodeID=reader.Value
            q
        }
    }
    
    //加入队列
    s $zt = "OnErrorRegQueue"
    TSTART
    s sysCode = "DHC"
    s priority = "151"
    s SchemeType=""
    //新设置P的任务类型，专门用以平台的生成
    s admTaskQueueID = ##Class(DHCEPRFS.BL.BLAdmTaskQueue).Create(sysCode, EpisodeID, priority, SchemeType,"P","")
    s ^CacheTemp("yangpengtest","admTaskQueueID")=admTaskQueueID
    if (admTaskQueueID="")
    {
        TROLLBACK
        d SetRet("-1") 
        q ret
    }
    s ^CacheTemp("yangpengtest","objAdmTaskXmlInfo.XMLInfoBeforeNEW")="y"
    s objAdmTaskXmlInfo=##class(DHCEPRFS.INST.AdmTaskXmlInfo).%New()
    s ^CacheTemp("yangpengtest","objAdmTaskXmlInfo.XMLInfoBefore")="y"
    s objAdmTaskXmlInfo.EpisodeID=EpisodeID
    s objAdmTaskXmlInfo.MRItemID=AMRItemID
    s objAdmTaskXmlInfo.XMLInfo=AXMLStr
    s objAdmTaskXmlInfo.OperDate=nowDate
    s objAdmTaskXmlInfo.OperTime=nowTime
    s sc=objAdmTaskXmlInfo.%Save()
    s ^CacheTemp("yangpengtest","objAdmTaskXmlInfo_sc")=sc
    if $$$ISERR(sc)
    {
        TROLLBACK
        d SetRet("-1") 
        q ret
    }
    s ^CacheTemp("yangpengtest","objAdmTaskXmlInfo.XMLInfoBeforeUpdate")="y"
    s objAdmTaskQueue=##class(DHCEPRFS.INST.AdmTaskQueue).%OpenId(admTaskQueueID)
    S objAdmTaskQueue.AdmTaskXmlInfoID=objAdmTaskXmlInfo.%Id()
    s sc=objAdmTaskQueue.%Save()
    s ^CacheTemp("yangpengtest","objAdmTaskQueue_sc_update")=sc
    if $$$ISERR(sc)
    {
        TROLLBACK
        d SetRet("-1") 
        q ret
    }
    else
    {
        TCOMMIT
        d SetRet("0")
        q ret
    }

SetRet(flag)
    s ret="<Response>"
    s ret=ret_"<Header>"
    s ret=ret_"<SourceSystem></SourceSystem> "
    s ret=ret_"<MessageID></MessageID>"
    s ret=ret_"</Header>"
    s ret=ret_"<Body>"
    if (flag="0")   //succeed
    {
        s ret=ret_"<ResultCode>0</ResultCode>"
        s ret=ret_"<ResultContent>成功</ResultContent>"
    }
    else
    {
        s ret=ret_"<ResultCode>-1</ResultCode>"
        s ret=ret_"<ResultContent>失败</ResultContent>"
    }

    s ret=ret_"</Body>"
    s ret=ret_"</Response>"
    q
OnErrorRegQueue
    TROLLBACK
    d SetRet("-1") 
    q ret
}

/// Desc:   注册平台文档new
/// Input: AEpisodeID - 就诊rowid, AMRItemIDS - 归档项目ID的串
/// Return: PDF路径
/// Debug：  w ##Class(DHCEPRFS.BI.BIToPlatform).GetPDFPathByItemID("330","2","1")
ClassMethod RegDocNew(AMRItemID As %String, AXMLStr As %String, AOperIP As %String) As %String
{
    s $zt = "OnErrorRegDoc"
    s ret=""
    s EpisodeID=""
    //取当前时间
    s now = $h
    s nowDate = $p(now,",",1)
    s nowTime = $p(now,",",2)
    
    //首先存储日志表
    s objAdmTaskXmlInfo=##class(DHCEPRFS.INST.AdmTaskXmlInfo).%New()
    s objAdmTaskXmlInfo.EpisodeID=""    //暂时为空,等业务完成后再Update
    s objAdmTaskXmlInfo.MRItemID=AMRItemID
    s objAdmTaskXmlInfo.XMLInfo=AXMLStr
    s objAdmTaskXmlInfo.OperDate=nowDate
    s objAdmTaskXmlInfo.OperTime=nowTime
    s objAdmTaskXmlInfo.OperIP=AOperIP
    s sc=objAdmTaskXmlInfo.%Save()
    s AdmTaskXmlInfoID=""
    if $$$ISERR(sc)
    {
        q ""
    }
    else
    {
        s AdmTaskXmlInfoID=objAdmTaskXmlInfo.%Id()
    }
    //取EpisodeID
    s ^CacheTemp("yangpengtest","RegDocNewAXMLStr")=AXMLStr
    s sc=##class(%XML.TextReader).ParseString(AXMLStr,.reader)
    if $$$ISERR(sc)
    {
        q ""
    }
    while(reader.Read())
    {
        //w reader.Name_"="_reader.Value,!
        if (reader.Name="PAADMVisitNumber")
        {
            d reader.Read()
            w "PAADMVisitNumber="_reader.Value
            s EpisodeID=reader.Value
            q
        }
    }
    
    //处理就诊号河南省医历史病历的（DR开头的）
    s EpisodeID=$zcvt(EpisodeID,"U")    // to upper
    if ($e(EpisodeID,1,2)="DR") //历史就诊
    {
        s retImport=..ImportEpisode(EpisodeID)
        q:($e(retImport,1,1)'="1") ""
        s EpisodeID=$tr(EpisodeID,"_","")   //去掉下划线
        s EpisodeID="VE"_EpisodeID  //增加VE前缀
    }
    
    TSTART
    s sysCode = "DHC"
    //注册MREpisode等
    s MREpisodeID=##class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm(EpisodeID,sysCode)
    if (MREpisodeID="")
    {
        s MREpisodeID=##Class(DHCEPRFS.BL.BLMREpisode).RegMREpisodeIDByAdm(EpisodeID,sysCode)
    }
    if (MREpisodeID="")
    {
        TROLLBACK
        q ""    
    }
    
    //增加MRVersion
    s MRVersionID=""
    s MaxVersion=""
    s MaxVersion=$o(^DHCEPRFS.INST.MRVersionI("IdxMain"," "_MREpisodeID,MaxVersion),-1)
    if (MaxVersion="")  //没有Version,创建之
    {
        s objMRVersion = ##Class(DHCEPRFS.INST.MRVersion).%New()
        s objMRVersion.Version = 0
        s objMRVersion.MRMedRecordID = ""
        s objMRVersion.MREpisodeID = MREpisodeID    
        s objMRVersion.CreateDate = nowDate
        s objMRVersion.CreateTime = nowTime
        s objMRVersion.ModifyDate = nowDate
        s objMRVersion.ModifyTime = nowTime
        s objMRVersion.Type = ""
        s sc = objMRVersion.%Save()
        if $$$ISERR(sc)
        {
            TROLLBACK
            q ""    
        }
        else
        {
            s MRVersionID=objMRVersion.%Id()
        }
    }
    else
    {
        s MRVersionID=$o(^DHCEPRFS.INST.MRVersionI("IdxMain"," "_MREpisodeID,MaxVersion,""))
    }
    
    s ^CacheTemp("yangpengtest","MRVersionID")=MRVersionID
    //增加MRVerItem
    s MRVerItemID=""
    s MRVerItemID = $O(^DHCEPRFS.INST.MRVerItemI("IdxMain", " "_MRVersionID, " "_AMRItemID, ""))
    s ^CacheTemp("yangpengtest","MRVerItemIDOOO")="Y"_MRVerItemID
    if (MRVerItemID="") //为空则创建
    {
        s objMRVerItem = ##Class(DHCEPRFS.INST.MRVerItem).%New()
        s objMRVerItem.MRVersionID = MRVersionID
        s objMRVerItem.MRItemID = AMRItemID
        s objMRVerItem.TotCount = 0
        s objMRVerItem.CreateDate = nowDate
        s objMRVerItem.CreateTime = nowTime
        s objMRVerItem.ModifyDate = nowDate
        s objMRVerItem.ModifyTime = nowTime
        s ^CacheTemp("yangpengtest","objMRVerItemSaveBEFORE")="Y"
        s sc = objMRVerItem.%Save()
        if $$$ISERR(sc)
        {
            TROLLBACK
            q ""    
        }
        else
        {
            s MRVerItemID=objMRVerItem.%Id()
        }
    }
    s ^CacheTemp("yangpengtest","MRVerItemID")="Y"
    
    s objAdmTaskXmlInfo=##class(DHCEPRFS.INST.AdmTaskXmlInfo).%OpenId(AdmTaskXmlInfoID) 
    s objAdmTaskXmlInfo.EpisodeID=EpisodeID //只需要更新EpisodeID即可
    s sc=objAdmTaskXmlInfo.%Save()
    if $$$ISERR(sc)
    {
        TROLLBACK
        q ""
    }
    else
    {
        TCOMMIT
        q objAdmTaskXmlInfo.%Id()
    }

OnErrorRegDoc
    TROLLBACK
    s ^CacheTemp("yangpengtest","RegDocNewAXMLStrERROR")=111
    q ret
}

/// Debug：  w ##Class(DHCEPRFS.BI.BIToPlatform).AddProcessResult("85","1","192.168.1.130")
ClassMethod AddProcessResult(AAdmTaskXmlInfoID As %String, ASucceedFlag As %String, AProcessIP As %String, APlatformXMLInfo As %String, APlatformRet As %String) As %String
{
    if (ASucceedFlag="1")
    {
        if (APlatformXMLInfo["<PAADMVisitNumber>DR_ZY") //lishi bingli
        {
            w ##class(User.EnsInterface).InsertData("jhpdf",APlatformXMLInfo)
        }
        else
        {
            set result=##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000060",APlatformXMLInfo)
        }
    }
    s objAdmTaskXmlInfo=##class(DHCEPRFS.INST.AdmTaskXmlInfo).%OpenId(AAdmTaskXmlInfoID)
    s objAdmTaskXmlInfo.SucceedFlag=ASucceedFlag
    s objAdmTaskXmlInfo.ProcessDate=$p($h,",",1)
    s objAdmTaskXmlInfo.ProcessTime=$p($h,",",2)
    s objAdmTaskXmlInfo.ProcessIP=AProcessIP
    s objAdmTaskXmlInfo.PlatformXMLInfo=APlatformXMLInfo
    s objAdmTaskXmlInfo.PlatformRet=APlatformRet
    s sc=objAdmTaskXmlInfo.%Save()
    if ($$$ISERR(sc))
    {
        q "0"
    }
    else
    {
        q "1"   
    }
}

/// Desc:   根据平台提供的Global导入归档就诊记录
/// Input：  AIndex索引编号
///         
/// Debug：  w ##Class(DHCEPRFS.BI.BIToPlatform).ImportEpisode("1")
ClassMethod ImportEpisode(AAdmNo As %String) As %String
{
    s tempAdmNo=$zcvt("VE"_$tr(AAdmNo,"_",""),"U")
    s checkMREpisodeID=""
    s checkMREpisodeID=$o(^DHCEPRFS.INST.MREpisodeI("IdxSysCodeAndEpisodeID"," DHC"," "_tempAdmNo,""))
    q:(checkMREpisodeID'="") "1|已经导入"    //说明已经导入
    
    s DRAdmInfoID=""
    s DRAdmInfoID=$o(^DHCEPRFS.INST.DRAdmInfoI("IdxAdmNo"," "_$zcvt(AAdmNo,"U"),""))
    q:(DRAdmInfoID="") "0|No DRAdmInfo" 
    
    s objDRAdmInfo=##class(DHCEPRFS.INST.DRAdmInfo).%OpenId(DRAdmInfoID)
    //取平台Global信息
    s PlatRegNo=objDRAdmInfo.RegNo
    s PlatAdmNo=objDRAdmInfo.AdmNo
    s PlatDoctorCode=objDRAdmInfo.DoctorNo
    s PlatDoctorName=objDRAdmInfo.DoctorName
    s PlatAdminDate=objDRAdmInfo.AdmDate
    s PlatAdminTime=objDRAdmInfo.AdmTime
    s PlatAdminLocCode=objDRAdmInfo.AdmLocCode
    s PlatAdminLocName=objDRAdmInfo.AdmLocName
    s PlatDisDate=objDRAdmInfo.DisDate
    s PlatDisTime=objDRAdmInfo.DisTime
    s PlatDisLocCode=objDRAdmInfo.DisLocCode
    s PlatDisLocName=objDRAdmInfo.DisLocName
    
    //去掉登记号中的下划线
    if ($l(PlatAdmNo,"_")>1)
    {
        s PlatAdmNo=$tr(PlatAdmNo,"_","")
    }
    s PlatAdmNo="VE"_PlatAdmNo  //添加VE标识
    s PlatAdmNo=$zcvt(PlatAdmNo,"U")    // to upper
    
    //判断基本信息
    s PAPMI=""
    s PAPMI=$o(^PAPERi("PAPMI_PatNo",PlatRegNo,"")) //取得PatientID/PAPMI
    q:(PAPMI="") "0|未查询到PAPMI"
    
    s objPatMas=##class(User.PAPatMas).%OpenId(PAPMI)
    q:(objPatMas="") "0|患者信息不存在"
    
    //处理病案号 如果不存在用 "VM"+PAPMI ELSE "JHVM"+"MedRecordNo"
    s MedRecordNo=""
    if ((objPatMas.PAPMIMedicare="")||(objPatMas.PAPMIMedicare=$c(0)))
    {
        s MedRecordNo="VM"_PAPMI
    }
    else
    {
        s MedRecordNo="VMJH"_objPatMas.PAPMIMedicare
    }
    s MedRecordNo=$zcvt(MedRecordNo,"U")    // to upper
    
    s SexDR=$p($g(^PAPER(PAPMI,"ALL")),"^",7)
    s PatiSex=$p($g(^CT("SEX",SexDR)),"^",2)
    s nowDate = $p($h,",",1)
    s nowTime = $p($h,",",2)
    
    TSTART
    s $zt = "OnImportEpisodeErrHandler"
    ////×××××处理MRPatient
    s MRPatientID=""
    s MRPatientID=$o(^DHCEPRFS.INST.MRPatientI("IdxPatientID"," DHC"," "_PAPMI,MRPatientID))
    if (MRPatientID="") //未找到PAPMI对应的MRPatient则 新建
    {
        s objMRPatient=##class(DHCEPRFS.INST.MRPatient).%New()
        s objMRPatient.SysCode="DHC"    //??
        s objMRPatient.PatientID=PAPMI
        s objMRPatient.Name=objPatMas.PAPMIName
        s objMRPatient.Gender=PatiSex
        s objMRPatient.MedRecordNo=MedRecordNo
        s objMRPatient.CreateDate=nowDate
        s objMRPatient.CreateTime=nowTime
        s objMRPatient.LastModifyDate=nowDate
        s objMRPatient.LastModifyTime=nowTime
        s objMRPatient.Birthday=objPatMas.PAPMIDOB
        s objMRPatient.Company="PlatformImport|"_$zd(nowDate,3)
        s status = objMRPatient.%Save()
        if ($$$ISERR(status))
        {
            TROLLBACK
            q "0|保存MRPatient出错!"
        }
        else
        {
            s MRPatientID=objMRPatient.%Id()
        }
    }
    
    ////×××××处理MRMedRecord
    s MRMedRecordID=""
    s MRMedRecordID=$o(^DHCEPRFS.INST.MRMedRecordI("IdxMedRecordNo"," DHC"," "_MedRecordNo,MRMedRecordID))
    
    if (MRMedRecordID="")
    {
        s objMRMedRecord=##class(DHCEPRFS.INST.MRMedRecord).%New()
        s objMRMedRecord.MedRecordNo=MedRecordNo
        s objMRMedRecord.MRPatientID=MRPatientID
        s objMRMedRecord.SysCode="DHC"
        s objMRMedRecord.CreateDate=nowDate
        s objMRMedRecord.CreateTime=nowTime
        s objMRMedRecord.LastModifyDate=nowDate
        s objMRMedRecord.LastModifyTime=nowTime
        s objMRMedRecord.IsHISMedRecord="N"
        s status = objMRMedRecord.%Save()
        if ($$$ISERR(status))
        {
            TROLLBACK
            q "0|保存MRMedRecord出错!"
        }
        else
        {
            s MRMedRecordID=objMRMedRecord.%Id()
        }
    }
    
    ////×××××处理MREpisode
    s MREpisodeID=""
    s MREpisodeID=$o(^DHCEPRFS.INST.MREpisodeI("IdxSysCodeAndEpisodeID"," DHC"," "_PlatAdmNo,MREpisodeID))
    if (MREpisodeID="")
    {
        s objMREpisode = ##class(DHCEPRFS.INST.MREpisode).%New()
        s objMREpisode.SysCode = "DHC"
        s objMREpisode.CreateDate = nowDate
        s objMREpisode.CreateTime = nowTime
        s objMREpisode.LastModifyDate = nowDate
        s objMREpisode.LastModifyTime = nowTime
        s objMREpisode.AdmLocID = ""
        s objMREpisode.AdmLoc = PlatAdminLocName
        s objMREpisode.DisLocID = PlatDisLocCode
        s objMREpisode.DisLoc = PlatDisLocName
        s objMREpisode.AdmDate = $zdh(PlatAdminDate,3)
        s objMREpisode.DisDate = $zdh(PlatDisDate,3)
        s objMREpisode.EpisodeID=PlatAdmNo
        s objMREpisode.MedRecordNo = MedRecordNo
        s objMREpisode.MRMedRecordID = MRMedRecordID
        s objMREpisode.MRPatientID = MRPatientID
        s status = objMREpisode.%Save()
        if ($$$ISERR(status))
        {
            TROLLBACK
            q "0|保存MREpisode出错!"
        }
        else
        {
            s MREpisodeID=objMREpisode.%Id()
        }
        
        //处理    MREpisodePat
        s objMREpiosodePat=##class(DHCEPRFS.INST.MREpisodePat).%New()
        s objMREpiosodePat.SysCode="DHC"
        s objMREpiosodePat.PatientID=PAPMI
        s objMREpiosodePat.CompanyCode=""
        s objMREpiosodePat.CreateDate=nowDate
        s objMREpiosodePat.CreateTime=nowTime
        s objMREpiosodePat.LastModifyDate=nowDate
        s objMREpiosodePat.LastModifyTime=nowTime
        s objMREpiosodePat.AdmCount=1
        s objMREpiosodePat.InCount=1
        s objMREpiosodePat.MedRecordNo=MedRecordNo
        s objMREpiosodePat.Name=objPatMas.PAPMIName
        s objMREpiosodePat.Gender=PatiSex
        s objMREpiosodePat.Birthday=objPatMas.PAPMIDOB
        s objMREpiosodePat.EpisodeID=PlatAdmNo
        s objMREpiosodePat.MREpisodeID=MREpisodeID
        s objMREpiosodePat.MRPatientID=MRPatientID
        s objMREpiosodePat.MRMedRecordID=MRMedRecordID
        s status = objMREpiosodePat.%Save()
        if ($$$ISERR(status))
        {
            TROLLBACK
            q "0|保存MREpiosodePat出错!"
        }
        else
        {
            TCOMMIT         //成功 提交
            q "1|"_MREpisodeID
        }
    }
    else        //如果找到MREpisode说明已经存在
    {
        TROLLBACK
        q "0|已经存在MREpisodeID("_MREpisodeID_"),不允许重新导入!"
    }
    
OnImportEpisodeErrHandler
    TROLLBACK
    q "0|ImportEpisode方法执行出错!"
}

/// Desc:   将平台提供的嘉禾历史患者就诊记录导入表中
/// Input：  
///         
/// Debug：  d ##Class(DHCEPRFS.BI.BIToPlatform).TransAdmGlobal2Table()
ClassMethod TransAdmGlobal2Table() As %String
{
    s index=""
    for {
        s index = $o(^DRAdmInfo(index))
        q:(index="")
        s obj=##class(DHCEPRFS.INST.DRAdmInfo).%New()
        //取平台Global信息
        s obj.RegNo=$lg(^DRAdmInfo(index),2)
        s obj.AdmNo=$lg(^DRAdmInfo(index),3)
        s obj.DoctorNo=$lg(^DRAdmInfo(index),4)
        s obj.DoctorName=$lg(^DRAdmInfo(index),5)
        s obj.AdmDate=$lg(^DRAdmInfo(index),6)
        s obj.AdmTime=$lg(^DRAdmInfo(index),7)
        s obj.AdmLocCode=$lg(^DRAdmInfo(index),8)
        s obj.AdmLocName=$lg(^DRAdmInfo(index),9)
        s obj.DisDate=$lg(^DRAdmInfo(index),10)
        s obj.DisTime=$lg(^DRAdmInfo(index),11)
        s obj.DisLocCode=$lg(^DRAdmInfo(index),12)
        s obj.DisLocName=$lg(^DRAdmInfo(index),13)
        
        s status = obj.%Save()
        if ($$$ISOK(status))
        {
            w index,!
        }
        else
        {
            w "error:"_index,!
            q
        }
    }
}

/// Desc: 获取扫描项目PDF路径(数字媒体组接口)
/// Input: EpisodeID - 就诊RowID
/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.BI.BIToPlatform","GetPDFPathInfo","2944131")
Query GetPDFPathInfo(AEpisodeID As %String) As %Query(ROWSPEC = "ItemCode:%String,ItemName:%String,ItemDesc:%String,FilePath:%String")
{
}

ClassMethod GetPDFPathInfoExecute(ByRef qHandle As %Binary, AEpisodeID As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set ind = 1
	set qHandle = $lb(0,repid,0)
	
	q:(AEpisodeID = "") $$$OK
	s mrEpisodeID = ##class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm(AEpisodeID,"DHC")
	q:(mrEpisodeID = "") $$$OK
	s mrVersionID = ##class(DHCEPRFS.BL.BLMRVersion).GetMRVersionID(mrEpisodeID,"0")
	q:(mrVersionID = "") $$$OK
	
	s scanViewSchemeID = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("ScanViewSchemeID")
	q:(scanViewSchemeID = "") $$$OK
	s objScheme = ##class(DHCEPRFS.META.PrintScheme).%OpenId(scanViewSchemeID)
	s scanViewItems = objScheme.SchemeItems
	d objScheme.%Close()
	q:(scanViewItems = "") $$$OK
	
	s ftpConfig = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("FTPConfig")
	for i=1:1:$l(scanViewItems,"^")
	{
		s xMrItemID = $p($p(scanViewItems,"^",i),"#",3)
		s mrVerItemID = ""
		s mrVerItemID = $o(^DHCEPRFS.INST.MRVerItemI("IdxMain"," "_mrVersionID," "_xMrItemID,mrVerItemID))
		continue:(mrVerItemID = "")
		
		s detailNum = ""
		s detailNum = $o(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain",mrVerItemID,detailNum),-1)
		continue:(detailNum = "")
		s subID = ""
		s subID = $o(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain",mrVerItemID,detailNum,subID))
		continue:(subID = "")
		s mrVerItemDetailID = mrVerItemID_"||"_subID
		
		s objMRVerItemDetail = ##class(DHCEPRFS.INST.MRVerItemDetail).%OpenId(mrVerItemDetailID)
		s fileMasterID = objMRVerItemDetail.FileMasterID
		d objMRVerItemDetail.%Close()
		s fileLocPath = ##class(DHCEPRFS.BL.BLFileMaster).GetFullFileLocName(fileMasterID)
		if (fileLocPath["|")  //含有虚拟路径
		{
			if ($p(fileLocPath,"|",2)="/")  //虚拟目录为根目录
			{
				s filePath = "ftp://"_$p(ftpConfig,"^",2)_":"_$p(ftpConfig,"^",3)_$p(fileLocPath,"|",3)
			}
			else
			{
				s filePath = "ftp://"_$p(ftpConfig,"^",2)_":"_$p(ftpConfig,"^",3)_$p(fileLocPath,"|",2)_$p(fileLocPath,"|",3)
			}
		}
		else
		{
			s filePath = "ftp://"_$p(ftpConfig,"^",2)_":"_$p(ftpConfig,"^",3)_fileLocPath
		}
		
		s objMRItem = ##class(DHCEPRFS.META.MRItem).%OpenId(xMrItemID)
		s itemCode = objMRItem.Code
		s itemName = objMRItem.Name
		s itemDesc = objMRItem.Description
		s itemType = objMRItem.Type
		d objMRItem.%Close()
		continue:(itemType '= "PS")
		
		s data = $lb(itemCode,itemName,itemDesc,filePath)
		s ^CacheTemp(repid,ind)=data
		s ind=ind+1
	}
	q $$$OK
}

ClassMethod GetPDFPathInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPDFPathInfoExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
	Set repid = $LIST(qHandle,2)
	Set ind = $LIST(qHandle,3)
	Set ind = $o(^CacheTemp(repid,ind))
	If ind = "" {				// if there are no more rows, finish fetching
		Set AtEnd = 1
		Set Row = ""
	}
	Else      {				// fetch row
		Set Row = ^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetPDFPathInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPDFPathInfoExecute ]
{
	Set repid = $LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc:   获取归档病历项目的最新归档时间
/// Input:  AEpisodeID - 就诊rowid, AMRItemID - 归档项目ID
/// Return: 最新归档时间(yyyy-mm-dd hh:mi:ss)，未归档返回空串
/// Debug： w ##Class(DHCEPRFS.BI.BIToPlatform).GetMRItemArchiveTime("59","179")
ClassMethod GetMRItemArchiveTime(AEpisodeID As %String, AMRItemID As %String) As %String
{
    s MRVerItemID = ##class(DHCEPRFS.BL.BLMRVerItem).GetVerItemByItemIDAndEpisodeID(AEpisodeID,AMRItemID) 
    if (MRVerItemID = "")
    {
	    q ""
	}
	else
	{
		s objMRVerItem = ##class(DHCEPRFS.INST.MRVerItem).%OpenId(MRVerItemID)
		s ArchiveTime = $zd(objMRVerItem.ModifyDate,3) _" " _ $zt(objMRVerItem.ModifyTime,1)
		q ArchiveTime
	}
}

/// 	desc: 获取患者就诊病案文件列表
/// Input: <request><episodeid>EpisodeID</episodeid></request>
/// Return: <response><flag></flag><message></message><filelist><file><itemcode></itemcode><itemname></itemname><ordernum></ordernum><filename></filename><fileaccesscode></fileaccesscode></file>...</filelist></response>
/// temcode(类型编码) itemname(类型名称) ordernum(序号) filename(文档名称) fileaccesscode(文档授权码)
/// debug: w ##class(DHCEPRFS.BI.BIToPlateform).GetArchiveFileList("<request><episodeid>123</episodeid></request>")
/// webservice调用该方法的时候，返回类型应为%XML.GlobalCharacterStream
ClassMethod GetArchiveFileList(AXMLStr As %String) As %XML.GlobalCharacterStream
{
	s sc=##class(%XML.TextReader).ParseString(AXMLStr,.reader)
	s ret = ##class(%XML.GlobalCharacterStream).%New()
	if $$$ISERR(sc)
    {
        d Error
        q ret
    }
     while(reader.Read())
    {
        //w reader.Name_"="_reader.Value,!
        if (reader.Name="episodeid")
        {
            d reader.Read()
            s EpisodeID=reader.Value
            q
        }
    }
    s MREpisodeID=##Class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm(EpisodeID,"DHC")
    s MRVersionID=##class(DHCEPRFS.BL.BLMRVersion).GetMRVersionID(MREpisodeID)
    s rset = ##class(%ResultSet).%New("DHCEPRFS.BL.BLMRVerItem:GetAllByMRVersion")
	S sc = rset.Execute(MRVersionID)
	
	d ret.Write("<Response><flag>1</flag><message>ok</message><filelist>")
	s order = 0
	While (rset.Next())
	{
		s mrVerItemID=rset.GetDataByName("MRVerItemID")
		s detailNum = ""
		s detailNum = $O(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain", mrVerItemID, detailNum),-1)
		continue:(detailNum="")
		s subID = $O(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain", mrVerItemID, detailNum, ""))    
		continue:(subID="")
		s mrVerItemDetailID = mrVerItemID_"||"_subID
		s objMRVerItemDetail = ##Class(DHCEPRFS.INST.MRVerItemDetail).%OpenId(mrVerItemDetailID)
		s FileMasterID = objMRVerItemDetail.FileMasterID
		continue:(FileMasterID="")
		s order = order+1
		d ret.Write("<file>")
		d ret.Write("<itemcode>"_rset.GetDataByName("MRItemCode")_"</itemcode>")
		d ret.Write("<itemname>"_rset.GetDataByName("MRItemName")_"</itemname>")
		d ret.Write("<ordernum>"_order_"</ordernum>")
		d ret.Write("<filename>"_rset.GetDataByName("MRItemDescription")_"</filename>")
		d ret.Write("<fileaccesscode>"_##class(DHCEPRFS.Util.Encryption).Encrypt(FileMasterID)_"</fileaccesscode>")
		d ret.Write("</file>")
	}
    d ret.Write("</filelist></Response>")
    q ret
Error
	d ret.Write("<Response><flag>0</flag><message>ilegal xml param</message></Response>")
}

/// desc: 获取归档文件
/// input: <request><fileaccesscode>FileAccessCode<fileaccesscode></request>  FileAccessCode 
/// debug: w ##class(DHCEPRFS.BI.BIToPlatform).GetArchiveFile("<request><fileaccesscode>hhjkjkhhjhj<fileaccesscode></request>")
/// webservice调用该方法的时候，返回类型应为%XML.GlobalCharacterStream
ClassMethod GetArchiveFile(AXMLStr As %String) As %XML.GlobalCharacterStream
{
	s flag = "0"
	s ret=##class(%XML.GlobalCharacterStream).%New()
	s sc=##class(%XML.TextReader).ParseString(AXMLStr,.reader)
	if $$$ISERR(sc)
    {
        d Error(0)
        s flag="1"
    }
    q:(flag="1") ret
     while(reader.Read())
    {
        //w reader.Name_"="_reader.Value,!
        if (reader.Name="fileaccesscode")
        {
            d reader.Read()
            s FileAccessCode=reader.Value
            q
        }
    }
    try
    {
    	s flieMasterID = ##class(DHCEPRFS.Util.Encryption).Decrypt(FileAccessCode)
    }catch errobj
    {
	    d Error(1)
        s flag = "1"
	}
	q:(flag="1") ret
	try
	{
		s fileBase64Stream = ##class(DHCEPRFS.BL.BLPDFView).GetPDFStream(flieMasterID)
		s retST = "<Response><flag>1</flag><message>ok</message><data><![CDATA["
		do ret.Write(retST)
		do ret.CopyFrom(fileBase64Stream)
		do ret.Write("]]></data></Response>")
	}
	catch errobj
	{
		d Error(2)
		s flag="1"
	}
	q ret
    
Error(xflag)
	if (xflag="0")
	{
		s message="ilegal xml param"
	}
	elseif (xflag="1")
	{
		s message="ilegal fileaccesscode"
	}
	elseif(xflag="2")
	{
		s message="expired fileaccesscode,request new fileaccesscode"
	}
	else
	{
		s message="server error"
	}
	d ret.Write("<Response><flag>0</flag><message>"_message_"</message></Response>")
}

}
