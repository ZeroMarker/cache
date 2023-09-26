Class EMRinstance.PDF.AuditSignLog Extends %Persistent [ ProcedureBlock ]
{

/// 就诊号
Property EpisodeID As %String(MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

/// 病历结构ID,历结构表中绑定模板的ID
Property EMRDocID As %String(MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

/// 签名单元
Property Code As %String(MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

/// 病历顺序号
Property EMRNum As %String(MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

/// 病历ID
Property InstanceID As %String(MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 6 ];

/// 签名用户ID
Property UsrID As %String(MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 7 ];

/// 签名类型：患者签名——patsigned 机构签章orgsealed
Property Action As %String(MAXLEN = 50, TRUNCATE = 0, VALUELIST = ",patsigned,PATSIGNED,orgsealed,ORGSEALED") [ SqlColumnNumber = 8 ];

Property CreateDate As %Date [ SqlColumnNumber = 9 ];

Property CreateTime As %Time [ SqlColumnNumber = 10 ];

/// 数字签名有效
Property IsValid As %Boolean [ SqlColumnNumber = 11 ];

/// 存储类型：FTP——ftp 数据库存储Base64—-db
/// 	混合：hybrid传输使用FTP中转，db存储签后PDF Base64
Property StoreType As %String(MAXLEN = 50, TRUNCATE = 0, VALUELIST = ",db,DB,ftp,FTP,hybrid,HYBRID") [ SqlColumnNumber = 12 ];

/// PDF的文件名
Property FileName As %String(MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 13 ];

/// PDF在FTP上全路径
Property FilePath As %String(MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 14 ];

/// 企业签章后的PDF Base64字符串，解码后即为PDF的二进制文件
Property PDFBase64 As %GlobalCharacterStream(LOCATION = "^DHCEMRCA.AuditSignLogS") [ SqlColumnNumber = 15 ];

/// 待签名的PDF Base64字符串，解码后即为PDF的二进制文件
Property OriginalPDFBase64 As %GlobalCharacterStream(LOCATION = "^DHCEMRCA.AuditSignLogS") [ SqlColumnNumber = 16 ];

/// 文档编号
Property UniqueDocID As %String(MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 17 ];

/// 业务编号
Property BusinessNo As %String(MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 18 ];

/// 签名关键字
Property KeyWord As %String(MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 19 ];

/// 签名状态，TOSIGN 待签，SIGNED 已签名
Property SignStatus As %String(MAXLEN = 50, TRUNCATE = 0, VALUELIST = ",TOSIGN,SIGNED,CANCEL,PUSHED,EXPIRE") [ SqlColumnNumber = 20 ];

/// 更新日期
Property UpdateDate As %Date [ SqlColumnNumber = 21 ];

/// 更新时间
Property UpdateTime As %Time [ SqlColumnNumber = 22 ];

/// 患者推送签名表ID CA.DigitalSignPatPush.ID
Property PatPushSignID As %String [ SqlColumnNumber = 23 ];

/// CA端业务编号GUID
Property CABusinessGUID As %String [ SqlColumnNumber = 24 ];

Index IdxInstance On (EpisodeID, InstanceID, IsValid);

Index IdxBusiness On (UniqueDocID, IsValid);

Index IdxUniqueDocID On UniqueDocID;

Index IdxPatPushSignID On PatPushSignID;

/// Desc:	获取最后一次有效患者签名记录id
/// Input:	episodeID : 就诊rowid
/// Return:	患者签名记录id, 即 EMRinstance.PDF.AuditSignLog.ID
/// Debug:	w ##Class(EMRinstance.PDF.AuditSignLog).GetLastValidPDFInfo()
ClassMethod GetLastValidPDFInfo(episodeID As %String, insID As %String) As %String
{
	s id = ""
	s id = $O(^DHCEMRCA.AuditSignLogI("IdxInstance"," "_episodeID, " "_insID, 1, id),-1)
	q:(id = "") ""
	
	s obj = ##class(EMRinstance.PDF.AuditSignLog).%OpenId(id)
	q:(obj = "") ""
	q:(obj.IsValid '= "1") ""
	q:(obj.SignStatus '= "SIGNED") ""
	
	q id
}

/// w ##Class(EMRinstance.PDF.AuditSignLog).GetLastSuccPDFInfo("25434653","75812||26")
ClassMethod GetLastSuccPDFInfo(episodeID As %String, insID As %String)
{
    s (pid,pObj) = ""
    for {
        s pid = $O(^DHCEMRCA.AuditSignLogI("IdxInstance"," "_episodeID, " "_insID, 1, pid),-1)
        q:pid=""
        //w pid,!
        s:(pid'="") pObj = ..%OpenId(pid)
        //continue:((pObj'="")&&(pObj.PDFBase64.IsNull()))
        quit:(((pObj'="")&&('pObj.PDFBase64.IsNull())))
    }
    q pid
}

/// w ##Class(EMRinstance.PDF.AuditSignLog).GetSpecPDFCnt("25434653","75812||26")
ClassMethod GetSpecPDFCnt(episodeID As %String, insID As %String, async2 As %String = "N")
{
    s (qid,qObj,qArr,sArr,deb) = ""
    s (totalCnt, succeedCnt) = 0
    for {
        s qid = $O(^DHCEMRCA.AuditSignLogI("IdxInstance"," "_episodeID, " "_insID, 1, qid))
        q:qid=""
        if (async2="Y") {
            s qObj =..%OpenId(qid)
            //s:qObj.PDFBase64="" 1
            
            if ('qObj.PDFBase64.IsNull()) {
	            s succeedCnt=succeedCnt+1
	            s sArr = sArr_"^"_qObj.%Id()
            } else { s qArr = qArr_"^"_qObj.%Id() }
            s qObj = ""
        } 
        s totalCnt = totalCnt+1
    }
    //q "{""totalcount"":"_totalCnt_",""succeedcount"":"_succeedCnt_"}"
    q totalCnt_"-"_succeedCnt_"@"_qArr_"@"_sArr
}

/// w ##Class(EMRinstance.PDF.AuditSignLog).GetSpecPDFInfo("39","Y")
ClassMethod GetSpecPDFInfo(infId As %String, async2 As %String = "N")
{
    q:(infId="") ""
    s infObj = ""
    s infObj = ..%OpenId(infId)
    if ((async2="Y")&&('infObj.PDFBase64.IsNull())) {
        q infObj
    } elseif (async2="N") {
        q infObj
    } else { q "" }
}

/// w ##Class(EMRinstance.PDF.AuditSignLog).GetLastValidPDFInfoByUniqueCode("FEDE7F62A8F3409FD4AD09EC0779F005E2BD4773")
ClassMethod GetLastValidPDFInfoByUniqueCode(uniqueCode As %String)
{
	s uniqueCode = $ZCVT(uniqueCode,"U")
    s id = ""
    s id = $O(^DHCEMRCA.AuditSignLogI("IdxBusiness"," "_uniqueCode, 1, id),-1)
    //w id
    q:(id'="") ..%OpenId(id)
    q ""
}

/// d ##class(%ResultSet).RunQuery("EMRinstance.PDF.AuditSignLog","GetOrdByAdm","30517","62525","62745","24","","","","")
/// d ##class(%ResultSet).RunQuery("EMRinstance.PDF.AuditSignLog","SltAllValidPDFInfo","25434653")
Query SltAllValidPDFInfo(aEId) As %SQLQuery(CONTAINID = 0, ROWSPEC = "ID:%String,BusinessNo:%String,UniqueDocID:%String,EpisodeID:%String,EMRDocID:%String,Code:%String,EMRNum:%String,InstanceID:%String,UsrID:%String,Action:%String,CreateDate:%String,CreateTime:%String,IsValid:%String,StoreType:%String,FileName:%String,FilePath:%String,PDFBase64:%String")
{
	SELECT ID,BusinessNo,UniqueDocID,EpisodeID,EMRDocID,Code,EMRNum
	,InstanceID,UsrID,Action,CreateDate,CreateTime,IsValid
	,StoreType,FileName,FilePath,PDFBase64 FROM EMRinstance_PDF.AuditSignLog 
	WHERE IsValid = 1 AND CreateDate <> 'NULL' AND StoreType <> 'db' AND EpisodeID = :aEId
	ORDER BY ID DESC
}

/// Desc:	指定文档Guid是否已存在
/// Input：	guid : 文档guid
/// Return:	1 已存在，0 不存在
ClassMethod IsUniqueDocIDExist(guid As %String) As %String
{
	s id = $O(^DHCEMRCA.AuditSignLogI("IdxUniqueDocID"," "_guid, ""))
	q (id '= "")
}

/// Desc:	获取guid
/// Input：	remark : 备注，可以为空、默认为空
/// Return：Guid字符串，格式如：1E299BAA-3388-4199-9F91-3BB7DB4DAB03
/// Debug:	w ##Class(EMRinstance.PDF.AuditSignLog).CreateGUID("")
ClassMethod CreateGUID(remark = "") As %String
{
	s guid = ##Class(%SYSTEM.Util).CreateGUID()
	if (..IsUniqueDocIDExist(guid))
	{
		hang 0.1
		s guid = ##Class(%SYSTEM.Util).CreateGUID()
	}
	q guid
}

/// Debug:	w ##Class(EMRinstance.PDF.AuditSignLog).GetIDByUniqueDocID("")
ClassMethod GetIDByUniqueDocID(ADocGUID) As %String
{
	s id = $O(^DHCEMRCA.AuditSignLogI("IdxUniqueDocID"," "_$zcvt(guid,"u"), ""),-1)
	q id
}

Storage Default
{
<Data name="AuditSignLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>EMRDocID</Value>
</Value>
<Value name="4">
<Value>Code</Value>
</Value>
<Value name="5">
<Value>EMRNum</Value>
</Value>
<Value name="6">
<Value>InstanceID</Value>
</Value>
<Value name="7">
<Value>UsrID</Value>
</Value>
<Value name="8">
<Value>Action</Value>
</Value>
<Value name="9">
<Value>CreateDate</Value>
</Value>
<Value name="10">
<Value>CreateTime</Value>
</Value>
<Value name="11">
<Value>IsValid</Value>
</Value>
<Value name="12">
<Value>StoreType</Value>
</Value>
<Value name="13">
<Value>FileName</Value>
</Value>
<Value name="14">
<Value>FilePath</Value>
</Value>
<Value name="15">
<Value>PDFBase64</Value>
</Value>
<Value name="16">
<Value>OriginalPDFBase64</Value>
</Value>
<Value name="17">
<Value>UniqueDocID</Value>
</Value>
<Value name="18">
<Value>BusinessNo</Value>
</Value>
<Value name="19">
<Value>KeyWord</Value>
</Value>
<Value name="20">
<Value>SignStatus</Value>
</Value>
<Value name="21">
<Value>UpdateDate</Value>
</Value>
<Value name="22">
<Value>UpdateTime</Value>
</Value>
<Value name="23">
<Value>PatPushSignID</Value>
</Value>
<Value name="24">
<Value>CABusinessGUID</Value>
</Value>
</Data>
<DataLocation>^DHCEMRCA.AuditSignLogD</DataLocation>
<DefaultData>AuditSignLogDefaultData</DefaultData>
<IdLocation>^DHCEMRCA.AuditSignLogD</IdLocation>
<IndexLocation>^DHCEMRCA.AuditSignLogI</IndexLocation>
<StreamLocation>^DHCEMRCA.AuditSignLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
