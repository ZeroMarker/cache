/// CA认证(数字证书认证)
Class DHCMed.CA.SignVerify Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 产品代码（指向DHCMed.SS.Products.Code）
Property SVProductCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 报告类型
Property SVModuleType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 报告ID
Property SVReportID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 数字签名证书（签名用户）
Property SVUserCertCode As %String(MAXLEN = 5000, TRUNCATE = 1);

/// 原文(使用HASH数据存储) 压缩格式存储
Property SVHashData As %String(MAXLEN = 5000, TRUNCATE = 1);

/// 签名时间戳
Property SVSignTimeStamp As %String(MAXLEN = 99999, TRUNCATE = 1);

/// 签名信息
Property SVSignedData As %String(MAXLEN = 5000, TRUNCATE = 1);

/// 创建日期
Property SVCreateDate As %Date;

/// 创建时间
Property SVCreateTime As %Time;

/// 创建人（指向SS_User）
Property SVCreateUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 操作类型
Property SVOperationType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 指向 CA.DigitalSignature (电子病历接口表关联)
Property SVDigitalSignatureDR As CA.DigitalSignature;

/// 证书唯一标识(可以是证书SN, 也可以是证书密码卡号)
Property SVCertNo As %String(MAXLEN = 500, TRUNCATE = 0);

Index IndexReportOpr On (SVProductCode As Exact, SVModuleType As Exact, SVReportID As Exact, SVOperationType As Exact);

/// 创建目的：获取同一动作下最后一次签名的记录对象
/// 输入：
/// w ##class(DHCMed.CA.SignVerify).GetObjByReportOpr("CPW","CPW","52||4","DS")
ClassMethod GetObjByReportOpr(aProCode As %String, aModType As %String, aRepID As %String, aOperType As %String) As DHCMed.CA.SignVerify
{
	New (aProCode,aModType,aRepID,aOperType)
	Set return=""
	Quit:aProCode=""||aModType=""||aRepID=""||aOperType return
	
	Set ID=$o(^DHCMed.CA.SignVerifyI("IndexReportOpr",aProCode, aModType, aRepID, aOperType,""),-1)
	Set obj=##class(DHCMed.CA.SignVerify).%OpenId(ID)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// 例：死亡证明书（产品代码【DTH】，报告类型【REP】，报告ID【死亡证报告ID】，操作【S提交】）
/// w ##Class(DHCMed.CA.SignVerify).SaveSign("EPD^EPD^16^12175^S","86","SF12345678901234567X","oyHs13N01dKvmXyIDPDB4IjpZ4U","TeHa7dGT0ZTDM7ApMxc2Y1Eu9Rg","8A1D45A5C4E189B7")
ClassMethod SaveSign(aBaseInfo As %String, aSignID As %String, aUserCertCode As %String, aHashData As %String, aSignedData As %String, aCertNo As %String) As %String
{
	new (aBaseInfo,aSignID,aUserCertCode,aHashData,aSignedData,aCertNo)
	set return="-100"
	quit:aBaseInfo="" return
	quit:aSignID="" return
	quit:aUserCertCode="" return
	quit:aCertNo="" return
	set ProductCode=$p(aBaseInfo,"^",1)
	set ModuleType=$p(aBaseInfo,"^",2)
	set ReportID=$p(aBaseInfo,"^",3)
	set UserID=$p(aBaseInfo,"^",4)
	set OperationType=$p(aBaseInfo,"^",5)
	
	set obj=##class(DHCMed.CA.SignVerify).%New()
	set obj.SVProductCode=ProductCode
	set obj.SVModuleType=ModuleType
	set obj.SVReportID=ReportID
	set obj.SVUserCertCode=aUserCertCode
	set obj.SVHashData=aHashData
	set obj.SVSignedData=aSignedData
	set obj.SVSignTimeStamp=""
	set obj.SVCreateDate=+$h
	set obj.SVCreateTime=$p($h,",",2)
	set obj.SVCreateUser=UserID
	set obj.SVOperationType=OperationType
	do obj.SVDigitalSignatureDRSetObjectId(aSignID)
	//set obj.SVDigitalSignatureDR=SignID
	set obj.SVCertNo=aCertNo
	set sc=obj.%Save()
	if ($System.Status.IsError(sc)){
		//Do $System.Status.DisplayError(sc)
		Set return = "-100"
	}else{
		set return=obj.%Id()
	}
	set ret=##class(CA.BICAService).GetImageByUserID(UserID)
	if (ret'=""){
		quit return	
	}else{
		quit ""	
	}
}

/// 判断报告是否进行CA认证
/// w ##Class(DHCMed.CA.SignVerify).GetRepIsSign("EPD","EPD",1,"S")
ClassMethod GetRepIsSign(aProCode As %String, aModType As %String, aReportID As %String, aOprType As %String) As %String
{
	new (aProCode, aModType, aReportID, aOprType)
	Set return=0
	
	// 特殊处理订正的传染病报告，使其使用被订正报告医生的签名
	If (aProCode="EPD") {
		Set MepdDR=""
		Set objRep =##class(DHCMed.EPD.Epidemic).GetObjById(aReportID)
		Quit:'$IsObject(objRep) return
		Set MepdDR=objRep.MEPDMepdDR
		If MepdDR'=""{
			Set aReportID=MepdDR
		}
	}
	
	Set flg = $d(^DHCMed.CA.SignVerifyI("IndexReportOpr",aProCode, aModType, aReportID, aOprType))
	Set:flg'=0 return=1
	Quit return
}

/// 创建目的：获取同一动作下最后一次签名的记录SignID (CA.DigitalSignature)
/// w ##class(DHCMed.CA.SignVerify).GetRepSignID("EPD","EPD","105","S")
ClassMethod GetRepSignID(aProCode As %String, aModType As %String, aReportID As %String, aOprType As %String) As %String
{
	New (aProCode,aModType,aReportID,aOprType)
	Set return=""
	
	// 特殊处理订正的传染病报告，使其使用被订正报告医生的签名
	If (aProCode="EPD") {
		Set MepdDR=""
		Set objRep =##class(DHCMed.EPD.Epidemic).GetObjById(aReportID)
		Quit:'$IsObject(objRep) return
		Set MepdDR=objRep.MEPDMepdDR
		If MepdDR'=""{
			Set aReportID=MepdDR
		}
	}
	
	Set obj=..GetObjByReportOpr(aProCode,aModType,aReportID,aOprType)
	Quit:'$IsObject(obj) return
	If $IsObject(obj.SVDigitalSignatureDR) {
		Set return=obj.SVDigitalSignatureDR.%Id()
	}
	Quit return
}

/// 例：死亡证明书（产品代码【DTH】，报告类型【REP】，报告ID【死亡证报告ID】，操作【S提交】）
ClassMethod Update(aBaseInfo As %String, aUserCertCode As %String, aHashData As %String, aSignedData As %String) As %String
{
	new (aBaseInfo,aUserCertCode,aHashData,aSignedData)
	set return="-100"
	quit:aBaseInfo="" return
	quit:aUserCertCode="" return
	set ProductCode=$p(aBaseInfo,"^",1)
	set ModuleType=$p(aBaseInfo,"^",2)
	set ReportID=$p(aBaseInfo,"^",3)
	set UserID=$p(aBaseInfo,"^",4)
	set OperationType=$p(aBaseInfo,"^",5)
	
	TStart
	//MED表示医政组代码
	set ret=##Class(CA.DigitalSignatureService).Sign(aUserCertCode,"MED",aHashData,aSignedData)
	set retcode=$p(ret,"^")
	if (+retcode)'=1 {
		TRollback
		quit "-100"
	}
	set SignID=$p(ret,"^",2)
	
	set obj=##class(DHCMed.CA.SignVerify).%New()
	set obj.SVProductCode=ProductCode
	set obj.SVModuleType=ModuleType
	set obj.SVReportID=ReportID
	set obj.SVUserCertCode=aUserCertCode
	set obj.SVHashData=aHashData
	set obj.SVSignedData=aSignedData
	set obj.SVSignTimeStamp=""
	set obj.SVCreateDate=+$h
	set obj.SVCreateTime=$p($h,",",2)
	set obj.SVCreateUser=UserID
	set obj.SVOperationType=OperationType
	do obj.SVDigitalSignatureDRSetObjectId(SignID)
	//set obj.SVDigitalSignatureDR=SignID
	set sc=obj.%Save()
	if ($System.Status.IsError(sc)){
		//Do $System.Status.DisplayError(sc)
		TRollback
		Set return = "-100"
	}else{
		TCommit
		set return=obj.%Id()
	}
	set ret=##Class(web.DHCNurSignVerify).GetUserSignImage(UserID)
	if (ret'=""){
		quit return	
	}else{
		quit ""	
	}
}

/// 服务器端签名验证:调用CA的服务,登录login
/// 创建目的：验证CA用户名和密码（通过，返回空；未通过，返回错误信息）
/// w ##Class(DHCMed.CA.SignVerify).CAServiceVerify()
ClassMethod CAServiceVerify(strContainerName As %String, varCert As %String, strServerRan As %String, strClientSignedData As %String, strPicData As %String, varCertCode As %String = "", certificateNo As %String = "", UserID As %String = "") As %String
{
	s svrRan = %session.Get("ServerRan")
	s ^TMP("CAServiceVerify",1)=strContainerName
	s ^TMP("CAServiceVerify",2)=strClientSignedData
	s ^TMP("CAServiceVerify",3)=strServerRan
	s ^TMP("CAServiceVerify",4)=varCert
	s ^TMP("CAServiceVerify",5)=svrRan
	s ^TMP("CAServiceVerify",6)=strPicData
	//Login
	s uID = ##Class(CA.UsrSignatureInfo).GetUsrIdByKey(varCertCode)
	q:uID'=UserID "数字证书与当前登陆用户不匹配"
	s info=##Class(CA.DigitalSignatureService).Login(UserID,varCertCode,svrRan,strClientSignedData,certificateNo,varCert)
	q:info'="" info
	q ""
}

/// 创建目的：UsrID获取签名图
/// 输入：签名医生的ID(##Class(CA.UsrSignatureInfo).GetUsrIdByKey(varCertCode))
/// w ##class(DHCMed.CA.SignVerify).GetUserSignImage(290)
ClassMethod GetUserSignImage(usrID As %String) As %String
{
	s id = ##Class(CA.UsrSignatureInfo).GetInUseID(usrID)
	q:id="" ""
	s info=##Class(CA.UsrSignatureInfo).%OpenId(id) 
	q info.SignImage
}

/// Creator：     mayanpeng
/// CreatDate：   2021-12-14
/// Description:  CA图片目录生成图片
/// w ##class(DHCMed.CA.SignVerify).SaveSignImg(37)
ClassMethod SaveSignImg(aSignID As %String) As %String
{
	New (aSignID)
	Set return=""
	Quit:(aSignID="") return
	
	Set DirPath="/scripts/DHCMA/Upload/CA/"		//保存路径(两端都有斜线/)
	Set PhysicalPath = ##class(ext.util.String).GetPhysicalPath("",DirPath)
	if ('##class(%File).DirectoryExists(PhysicalPath)){
		Do ##class(%File).CreateDirectoryChain(PhysicalPath)
	}
	Set SignImg=##class(CA.BICAService).GetImageBySignID(aSignID)
	Quit:SignImg="" return
	Set IsSaveFlag=##class(DHCMA.Util.IO.CommonSrv).Base642Img(SignImg,PhysicalPath_aSignID_".gif")
	Set:IsSaveFlag=1 return=DirPath
	Quit return
}

/*
   打印时需判断是否绑定UKey,绑定:返回上报医生的ID;未绑定:返回上报医生的姓名
   Set imguser=##class(DHCMed.CA.SignVerify).GetUserSignImage(usrID) //该用户有没有绑定UKey
   If(imguser'=""){
  	   Set User=usrID 
   Else{
	   Set User=$p($g(^SSU("SSUSR",usrID)),"^",2)
   }
*/

/*
// 护理用的是c#写的打印程序，ca证书里存了照片信息，直接打印就行
string imageuser = Comm.DocServComm.GetData("web.DHCNurSignVerify:GetUserSignImage", "par:" + uid + "^");
if (imageuser != null)
{
    Comm cmg = new Comm();
    Image img = cmg.StringToImage(imageuser);

    int addh = 0;
    int addw = 0;
    if (qmprnorientation == 1)
    {
        addw = qmwildth + qmhori;
    }
    if (qmprnorientation == 0)
    {
        addh = qmheight + qmport;
    }
    if (blackflag == "Y") //红色转黑色
    {
        Bitmap bmp = changecolor(img, 4);
        g.DrawImage(bmp, x1 + qmleft + addw * i2, y1 + qmtop + addh * i2, qmwildth, qmheight);
    }
	    
核心是这个方法：
public Image StringToImage(string imgstr)
{ //字符串－－〉流
    if (imgstr == "") return null;
    byte[] ChangeAfterImageBytes = Convert.FromBase64String(imgstr);//再将字符串分拆成字节数组
    MemoryStream ChangeAfterMS = new MemoryStream(ChangeAfterImageBytes);//将字节数组保存到新的内存流上
    Image Image = Image.FromStream(ChangeAfterMS);//将内存流保存成一张图片
    return Image;
}
*/
Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SVProductCode</Value>
</Value>
<Value name="3">
<Value>SVModuleType</Value>
</Value>
<Value name="4">
<Value>SVReportID</Value>
</Value>
<Value name="5">
<Value>SVMainHashInfo</Value>
</Value>
<Value name="6">
<Value>SVMainSignCert</Value>
</Value>
<Value name="7">
<Value>SVMainSignTimeStamp</Value>
</Value>
<Value name="8">
<Value>SVMainSignValue</Value>
</Value>
<Value name="9">
<Value>SVCreateDate</Value>
</Value>
<Value name="10">
<Value>SVCreateTime</Value>
</Value>
<Value name="11">
<Value>SVCreateUser</Value>
</Value>
<Value name="12">
<Value>SVOperationType</Value>
</Value>
<Value name="13">
<Value>SVDigitalSignatureDR</Value>
</Value>
<Value name="14">
<Value>SVUserCertCode</Value>
</Value>
<Value name="15">
<Value>SVHashData</Value>
</Value>
<Value name="16">
<Value>SVSignTimeStamp</Value>
</Value>
<Value name="17">
<Value>SVSignedData</Value>
</Value>
<Value name="18">
<Value>SVCertNo</Value>
</Value>
</Data>
<DataLocation>^DHCMed.CA.SignVerifyD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^DHCMed.CA.SignVerifyD</IdLocation>
<IndexLocation>^DHCMed.CA.SignVerifyI</IndexLocation>
<StreamLocation>^DHCMed.CA.SignVerifyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
