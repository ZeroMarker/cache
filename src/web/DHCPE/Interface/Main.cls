/// 体检上传第三方图像及读取txt文件
Class web.DHCPE.Interface.Main Extends %RegisteredObject
{

Parameter HeightDetailCode = "PE030001";

Parameter WeightDetailCode = "PE030002";

/// 解析读取的txt结果内容
/// 需要根据ArcDesc（项目描述）调用不同的获取体检号及检查结果的代码
/// w ##class(web.DHCPE.Interface.Main).GetResultInfo("@PTzy000407@"_$c(13,10)_"#xindianceshi#"_$c(13,10)_"$xindiantuzhenduanyijian$","105","1")
ClassMethod GetResultInfo(ResultInfo, LocID, URid)
{
	s ^TempDHCPE("ResultInfo")=$LB(ResultInfo, LocID, URid)
	s ResultInfo=##class(web.DHCPE.ReportGetInfor).Replace(ResultInfo,"：",":")
	s ResultInfo=##class(web.DHCPE.ReportGetInfor).Replace(ResultInfo," ","")
	s ResultInfo=##class(web.DHCPE.ReportGetInfor).Replace(ResultInfo,"^","~")
	s ResultInfo=##class(web.DHCPE.ReportGetInfor).Replace(ResultInfo,$c(13,10),"")
	s HPNo="",ExamResult="",ExamDesc=""
	s CurARCIM=""
	//先循环确定医嘱是哪个
	s LURid=""
    f  s LURid=$o(^CF.PE.LocUpLoadResultI("IdxOfLURDR",URid,LURid)) q:LURid=""  d
	.s LURPENoSepB=$lg(^CF.PE.LocUpLoadResultD(LURid),6) //获取体检号分隔符前
	.q:LURPENoSepB=""
	.s LURPENoSepA=$lg(^CF.PE.LocUpLoadResultD(LURid),7) //获取体检号分隔符后
	.q:LURPENoSepA=""
	.s HPNo=$P(ResultInfo,LURPENoSepB,2)
	.s HPNo=$P(HPNo,LURPENoSepA,1)
	.s HPNo=##class(web.DHCPE.ReportGetInfor).Replace(HPNo," ","")
	.q:HPNo=""
	.q:'$D(^DHCPEPreIADM(0,"HPNo",HPNo)) //取出来的不是体检号
	.s LURARCIM=$lg(^CF.PE.LocUpLoadResultD(LURid),3)
	.s IsHaARCIMFlag=..HPNoIsHaveARCIM(HPNo, LURARCIM)
	.q:IsHaARCIMFlag=0
	.s CurARCIM=LURARCIM
	
	i CurARCIM'="" d
	.s CurLurid=$o(^CF.PE.LocUpLoadResultI("IdxOfLURARCIMDR",URid," "_CurARCIM,""))
	e  d
	.s CurLurid=$o(^CF.PE.LocUpLoadResultI("IdxOfLURDR",URid,""))
	
	
	s ARCItemID=$lg(^CF.PE.LocUpLoadResultD(CurLurid),3)
	s ODID=$o(^DHCPEODR(0,"ARCITMODDR",ARCItemID,""))    //如果没有这个索引的话需要在DHC_PE_OrderDetailRelate表新建索引
	
	
	s LURJCSJSepB=$lg(^CF.PE.LocUpLoadResultD(CurLurid),8) //获取检查所见分隔符前
	s LURJCSJSepA=$lg(^CF.PE.LocUpLoadResultD(CurLurid),9) //获取检查所见分隔符后
	s LURZDYJSepB=$lg(^CF.PE.LocUpLoadResultD(CurLurid),10) //获取诊断意见分隔符前
	s LURZDYJSepA=$lg(^CF.PE.LocUpLoadResultD(CurLurid),11) //获取诊断意见分隔符前
	
	//检查所见
	s ExamResult=$P(ResultInfo,LURZDYJSepB,2)
	s ExamResult=$P(ExamResult,LURZDYJSepA,1)
	s ExamResult=##class(web.DHCPE.ReportGetInfor).Replace(ExamResult," ","")
	s ExamResult=##class(web.DHCPE.ReportGetInfor).Replace(ExamResult,$c(13,10),"")
	//诊断意见	
	s ExamDesc=$P(ResultInfo,LURJCSJSepB,2)
	s ExamDesc=$P(ExamDesc,LURJCSJSepA,1)
	s ExamDesc=##class(web.DHCPE.ReportGetInfor).Replace(ExamDesc," ","")
	s ExamDesc=##class(web.DHCPE.ReportGetInfor).Replace(ExamDesc,$c(13,10),"")
	
	q HPNo_"^"_ExamResult_"^"_ExamDesc
}

/// 根据登记号、体检科室、检查项目获取最后一次的体检记录，记录需要是到达或登记（可以考虑调用到达方法）状态
/// 
ClassMethod GetLastPreRecordID(RegNo, LocID As %String = "", ArcimID)
{
	i RegNo'="" s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo,LocID) 
	s PIBI=$o(^DHCPEPreIBI(0,"PAPMINo",RegNo,0))
	s Job=$J
	k ^TempDHCPE(Job,"GetLastPreRecordID")
	q:PIBI="" ""
	s PIADM=""
	f  s PIADM=$o(^DHCPEPreIADM(0,"PIBI",PIBI,PIADM),-1) q:(PIADM="")  d
	.s PIADMStutas=$P(^DHCPEPreIADM(PIADM),"^", 8)
	.q:PIADMStutas="CANCELPE"
	.q:("ARRIVED"'=PIADMStutas)&&("REGISTERED"'=PIADMStutas)
	.s CurLocID=$P(^DHCPEPreIADM(PIADM),"^", 26)
	.q:(LocID'="")&&(CurLocID'=LocID)
	.//判断是否有此检查项目
	.s PreItemID=""
	.s ItemLength=$L(ArcimID,"^")
	.f ItemI=1:1:ItemLength d
	..q:PreItemID'=""
	..s OneItemID=$P(ArcimID,"^",ItemI)
	..s ItemSub=0
	..f  s ItemSub=$O(^DHCPEPreIADM(0,"ItmMast",OneItemID,PIADM,ItemSub)) q:(ItemSub="")||(PreItemID'="")  d
	...s ItemStat=$P(^DHCPEPreIADM(PIADM,"ORDITEM",ItemSub),"^",16)
	...q:ItemStat'="1"
	...s PreItemID=PIADM_"||"_ItemSub
	.q:PreItemID=""
	
	.s PreDate=$P(^DHCPEPreIADM(PIADM),"^", 4)
	.s ^TempDHCPE(Job,"GetLastPreRecordID",PreDate,PIADM)=""
	s PreDate=$O(^TempDHCPE(Job,"GetLastPreRecordID",""),-1)
	q:PreDate="" ""
	s PIADM=$O(^TempDHCPE(Job,"GetLastPreRecordID",PreDate,""),-1)
	k ^TempDHCPE(Job,"GetLastPreRecordID")
	q PIADM
}

/// Creator:wrz
/// CreatDate:2021-01-27
/// Description:获取检查患者基本信息,别处复制过来，没改变量名
/// Input:PAADM 就诊ID
/// Output:^登记号^姓^名^出生日期^性别
/// w ##class(web.DHCPE.Interface.Main).GetBaseInfo("0000093800","4794||1","HPNo",65)
ClassMethod GetBaseInfo(PAADM, ArcimID, IDType As %String = "PAADM", LocID)
{
	s ^wrzGetBaseInfo=PAADM_"^"_ArcimID_"^"_IDType_"^"_LocID
	i IDType="PAADM"{
		s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
		s PIADM=$P(^DHCPEIADM(IADM),"^",4)
	}elseif IDType="HPNo"{
		s PIADM=$O(^DHCPEPreIADM(0,"HPNo",PAADM,0))
		i PIADM=""{
			s PIADM=..GetLastPreRecordID(PAADM,LocID,ArcimID)
		}
		q:PIADM="" "NoHP"
		s IADM=$O(^DHCPEIADM(0,"CRMADM",PIADM,0))
		s PAADM=$P(^DHCPEIADM(IADM),"^",4)
	}
	s PreItemID=""
	s ItemLength=$L(ArcimID,"^")
	f ItemI=1:1:ItemLength d
	.q:PreItemID'=""
	.s OneItemID=$P(ArcimID,"^",ItemI)
	.s ItemSub=0
	.f  s ItemSub=$O(^DHCPEPreIADM(0,"ItmMast",OneItemID,PIADM,ItemSub)) q:(ItemSub="")||(PreItemID'="")  d
	..s ItemStat=$P(^DHCPEPreIADM(PIADM,"ORDITEM",ItemSub),"^",16)
	..q:ItemStat'="1"
	..s PreItemID=PIADM_"||"_ItemSub
	
	q:PreItemID="" "NoItem"
	
	s CrmID=$O(^DHCPECRMO(0,"CRMORI",PreItemID,0))
	s OEID=$P(^DHCPECRMO(CrmID),"^",1)
	s PaiedFlag=$P(^OEORD(+OEID,"I",$P(OEID,"||",2),3),"^",5)
	q:PaiedFlag'="P" "NoPaied"
	s MZH=$P(^DHCPEPreIADM(PIADM),"^",27)
	s PIBI=$P(^DHCPEPreIADM(PIADM),"^",1)
	s XM=$P(^DHCPEPreIBI(PIBI),"^",2)
	s XB=$P(^DHCPEPreIBI(PIBI),"^",3)
	s:XB'="" XB=$P(^CT("SEX",XB),"^",2)
	s Dob=$P(^DHCPEPreIBI(PIBI),"^",4)
	s nl=+$P(##class(web.DHCLCNUREXCUTE).CalAge(Dob,+$H),"Y",1)
	i Dob'=""{
		s Dob=$ZD(Dob,3)
		//s Dob=##class(web.DHCPE.ReportGetInfor).Replace(Dob,"-","/")
	}
	s SJDW=$P(^DHCPEPreIADM(PIADM),"^",26)
	s:SJDW'="" SJDW=$P(^CTLOC(SJDW),"^",2)
	s:$L(SJDW,"-")>1 SJDW=$P(SJDW,"-",2,$L(SJDW,"-"))
	s LXXX=$P(^DHCPEPreIBI(PIBI),"^",8)
	s:LXXX="" LXXX=$P(^DHCPEPreIBI(PIBI),"^",6)
	s:LXXX="" LXXX=$P(^DHCPEPreIBI(PIBI),"^",7)
	s mcyj=""
	s bszy=""
	//s:MZH="" MZH=$P(^DHCPEPreIBI(PIBI),"^",1)
	s RegNo=$P(^DHCPEPreIBI(PIBI),"^",1)
	s MZH=$P(^DHCPEPreIADM(PIADM),"^",27)
	s height=+..GetHPResult(PAADM,..#HeightDetailCode)
	s weight=+..GetHPResult(PAADM,..#WeightDetailCode)
	s OEID=##class(web.DHCPE.ReportGetInfor).Replace(OEID,"||","-")
	s Info=RegNo_"^"_MZH_"^"_XM_"^"_XB_"^"_Dob_"^"_height_"^"_weight_"^"_OEID
	q Info
}

/// Creator:wrz
/// CreatDate:2021-01-27
/// Description:保存骨密度检查结果
/// Input: PAADM：就诊ID,ResultInfo：ret=SOS+"^"+BUA+"^"+OI+"^"+Zscore+"^"+Tscore+"^"+TRatio+"^"+ZRatio+"^"+Comment+"^"+TestTime;,UserID：操作员
/// Output: 0：正常  非0：不正常
/// w ##class(web.DHCPE.Interface.Main).SaveResult(660)
ClassMethod SaveResult(HPNo, ResultInfo, UserID, ArcimID, ODID, LocID)
{
	//n (HPNo,ResultInfo,UserID)
	s PIADM=$O(^DHCPEPreIADM(0,"HPNo",HPNo,0))
	i PIADM=""{
		s PIADM=..GetLastPreRecordID(HPNo,LocID,ArcimID)
	}
	q:PIADM="" "NoHP"
	s IADM=$O(^DHCPEIADM(0,"CRMADM",PIADM,0))
	q:IADM="" ""
	s PAADM=$P(^DHCPEIADM(IADM),"^",1)
	s PreItemID=""
	
	s ItemLength=$L(ArcimID,"^")
	f ItemI=1:1:ItemLength d
	.q:PreItemID'=""
	.s OneItemID=$P(ArcimID,"^",ItemI)
	.s ItemSub=0
	.f  s ItemSub=$O(^DHCPEPreIADM(0,"ItmMast",OneItemID,PIADM,ItemSub)) q:(ItemSub="")||(PreItemID'="")  d
	..s ItemStat=$P(^DHCPEPreIADM(PIADM,"ORDITEM",ItemSub),"^",16)
	..q:ItemStat'="1"
	..s PreItemID=PIADM_"||"_ItemSub
	q:PreItemID="" "NoItem"
	s CrmID=$O(^DHCPECRMO(0,"CRMORI",PreItemID,0))
	s OEID=$P(^DHCPECRMO(CrmID),"^",1)
	s ResultStr="临床诊断:"_""
	s ResultStr=ResultStr_";检查所见:"_$P(ResultInfo,"^",1)
	//s ResultStr=ResultStr_";检查所见:"_"SOS值:"_$P(ResultInfo,"^",8)
	s ResultStr=ResultStr_";诊断意见:"_$P(ResultInfo,"^",2)
	s CheckDate=+$H
	//s:CheckDate'="" CheckDate=$ZDH(CheckDate,3)
	s ResultInfo=OEID_"^"_ODID_"^"_ResultStr
	s ExpStr=CheckDate
	q ##class(web.DHCPE.ResultNew).SaveResult(ResultInfo,UserID,"",ExpStr)
}

/// 根据就诊id，和细项代码获取细项结果
ClassMethod GetHPResult(PAADM, ODCode)
{
	;w ##class(web.DHCPE.Interface.FGN.Main).GetHPResult()
	s $ZT="ResultErr"
	s STID="0"
	s STID=$O(^DHCPEST(0,"OD_Code",ODCode,STID))
	q:STID="" ""
	s ODSub="0"
	s ODSub=$O(^DHCPEST(0,"OD_Code",ODCode,STID,ODSub))
	s ODID=STID_"||"_ODSub
	s ResultID=$O(^DHCPERLT(0,"PAADM_OD",PAADM,ODID,0))
	q:ResultID="" ""
	s Result=$P(^DHCPERLT(ResultID),"^",4)
	q Result
ResultErr
	q ""
}

/// w ##class(web.DHCPE.Interface.Main).GetInfoFTP()
ClassMethod GetInfoFTP(LocID)
{
	//ip^用户名^密码^端口^目录^宽^高^协议类型(ftp或ftps)
	q "172.16.5.145^dhcpe^DHCc2020@01^21^pe/patphotos^300^200^ftp"
	q $G(^DHCPEUploadImgInfo("FTPInfo",LocID))
}

ClassMethod GetUserID(UserCode, CurLocID, ArcimID)
{
	s UserCode=$ZCVT(UserCode,"U")
	s UserID=$O(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,0))
	s:UserID'="" ^DHCPEDataEx("UploadCheckResult","UserCode",CurLocID,ArcimID)=UserCode
	q UserID
}

ClassMethod GetImgCurSort(OEID)
{
	s OEID=##class(web.DHCPE.ReportGetInfor).Replace(OEID,"-","||")
	s Sort=+$G(^DHCPEDataEx("UploadImg",OEID))
	q Sort
}

ClassMethod SaveUploadInfo(OEID, UserID, FTPFileName, DeleteFlag As %String = "1")
{
	s OEID=##class(web.DHCPE.ReportGetInfor).Replace(OEID,"-","||")
	s Sort=$I(^DHCPEDataEx("UploadImg",OEID))
	//s DeleteFlag=0
	if DeleteFlag=1 d
	.m ^DHCPEDataEx("UploadImgDelete",OEID)=^DHCPEDataEx("UploadImg",OEID)
	.k ^DHCPEDataEx("UploadImg",OEID)
	.s ^DHCPEDataEx("UploadImg",OEID)=Sort
	.
	s FTPFileName=##class(web.DHCPE.ReportGetInfor).Replace(FTPFileName,"||","-")
	s Date=+$H
	s Time=$P($H,",",2)
	s ^DHCPEDataEx("UploadImg",OEID,Sort)=Date_","_Time_"^"_UserID_"^"_FTPFileName
	s ^DHCPEDataExI("UploadImg",Date,Time,OEID)=Sort
	//s ^DHCPEDataEx("UploadImg",OEID,Sort)=$H_"^"_UserID_"^"_FTPFileName
	q ""
}

/// w ##class(web.DHCPE.Interface.Main).Test("aHC00000010b","152","1")
ClassMethod Test(ResultInfo, LocID, URid)
{

	s ResultInfo=##class(web.DHCPE.ReportGetInfor).Replace(ResultInfo,"：",":")
	s ResultInfo=##class(web.DHCPE.ReportGetInfor).Replace(ResultInfo," ","")
	s ResultInfo=##class(web.DHCPE.ReportGetInfor).Replace(ResultInfo,"^","~")
	s ResultInfo=##class(web.DHCPE.ReportGetInfor).Replace(ResultInfo,$c(13,10),"")
	s HPNo="",ExamResult="",ExamDesc=""
	s CurARCIM=""
	//先循环确定医嘱是哪个
	s LURid=""
    f  s LURid=$o(^CF.PE.LocUpLoadResultI("IdxOfLURDR",URid,LURid)) q:LURid=""  d
	.s LURPENoSepB=$lg(^CF.PE.LocUpLoadResultD(LURid),6) //获取体检号分隔符前
	.q:LURPENoSepB=""
	.s LURPENoSepA=$lg(^CF.PE.LocUpLoadResultD(LURid),7) //获取体检号分隔符后
	.q:LURPENoSepA=""
	.s HPNo=$P(ResultInfo,LURPENoSepB,2)
	.s HPNo=$P(HPNo,LURPENoSepA,1)
	.s HPNo=##class(web.DHCPE.ReportGetInfor).Replace(HPNo," ","")
	.q:HPNo=""
	.q:'$D(^DHCPEPreIADM(0,"HPNo",HPNo)) //取出来的不是体检号
	.s LURARCIM=$lg(^CF.PE.LocUpLoadResultD(LURid),3)
	.s IsHaARCIMFlag=..HPNoIsHaveARCIM(HPNo, LURARCIM)
	.q:IsHaARCIMFlag=0
	.s CurARCIM=LURARCIM
	.b ;
	b ;CurARCIM
	
	i CurARCIM'="" d
	.s CurLurid=$o(^CF.PE.LocUpLoadResultI("IdxOfLURARCIMDR",URid," "_CurARCIM,""))
	e  d
	.s CurLurid=$o(^CF.PE.LocUpLoadResultI("IdxOfLURDR",URid,""))
	b ;CurLurid
	
	s LURJCSJSepB=$lg(^CF.PE.LocUpLoadResultD(CurLurid),8) //获取检查所见分隔符前
	s LURJCSJSepA=$lg(^CF.PE.LocUpLoadResultD(CurLurid),9) //获取检查所见分隔符后
	s LURZDYJSepB=$lg(^CF.PE.LocUpLoadResultD(CurLurid),10) //获取诊断意见分隔符前
	s LURZDYJSepA=$lg(^CF.PE.LocUpLoadResultD(CurLurid),11) //获取诊断意见分隔符前
	
	//诊断意见
	s ExamResult=$P(ResultInfo,LURJCSJSepB,2)
	s ExamResult=$P(ExamResult,LURJCSJSepA,1)
	s ExamResult=##class(web.DHCPE.ReportGetInfor).Replace(ExamResult," ","")
	s ExamResult=##class(web.DHCPE.ReportGetInfor).Replace(ExamResult,$c(13,10),"")
	//检查所见	
	s ExamDesc=$P(ResultInfo,LURZDYJSepB,2)
	s ExamDesc=$P(ExamResult,LURZDYJSepA,1)
	s ExamDesc=##class(web.DHCPE.ReportGetInfor).Replace(ExamDesc," ","")
	s ExamDesc=##class(web.DHCPE.ReportGetInfor).Replace(ExamDesc,$c(13,10),"")
	
	q HPNo_"^"_ExamResult_"^"_ExamDesc
}

/// 判断体检号是否含有此医嘱  有1 没有0
/// w ##class(web.DHCPE.Interface.Main).HPNoIsHaveARCIM("HC00000010","2556||1")
ClassMethod HPNoIsHaveARCIM(HPNo, ARCITIM)
{
	s Flag=0
	s PIADMRowId=$o(^DHCPEPreIADM(0,"HPNo",HPNo,""))
	s PIOIChildSub=""
	f  s PIOIChildSub=$o(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOIChildSub)) q:PIOIChildSub=""  d
	.s PIOIItemStat=$p($g(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOIChildSub)),"^",16)
	.q:PIOIItemStat'="1"
	.s PIOIItmMastDR=$p($g(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOIChildSub)),"^",1)
	.i PIOIItmMastDR=ARCITIM s Flag=1
	
	q Flag
}

/// Description：图片上传
/// Input：
/// Return：       0 成功  非0^失败信息
/// Creator：     wangguoying
/// CreateDate：  2022-09-27
/// Debug: w ##class(web.DHCPE.Interface.Main).UploadImg(1)
ClassMethod UploadImg()
{
	///ClassMethod SaveUploadInfo(OEID, UserID, FTPFileName, DeleteFlag As %String = "1")
    Set UserID = $GET(%request.Data("UserID",1))
    Set LocID = $GET(%request.Data("LocID",1))
    If UserID = ""
    {
        Set UserID = ##class(HS.BL.PECommon).GetDftSessionParam("USERID")
    }
    Set OEORI = $GET(%request.Data("OEORI",1))
    Set IMGType = $GET(%request.Data("IMGType",1))
    Set DeleteFlag = $GET(%request.Data("DeleteFlag",1))
    Set stream = %request.GetMimeData("imageFile")
    Set imgSize=stream.Size  // 大小
    Set imgType=stream.ContentType  // 类型
    Set ftpInfo = ..GetInfoFTP(LocID)
    Set path = $P(ftpInfo,"^",5)_ "/"_$Replace(OEORI,"||","-")
    Set fileName = $Replace(OEORI,"||","-")_"_"_..GetImgCurSort(OEORI)_IMGType
    If imgSize > 0{
        Set ret = ..UploadFTP(stream,path,fileName,LocID)
        s ^tmpwgyy("UploadFTP") = ret
        Quit:+ret'=0 ret
    }Else{
        Quit "-1^文件大小为空！"
    }
    d ..SaveUploadInfo(OEORI,UserID,path_"/"_fileName,DeleteFlag)
	Quit 0
}

/// Description：上传文件到FTP
/// Input：
/// Return：       0    非0^失败信息
/// Creator：     wangguoying
/// CreateDate：  2022-08-09
/// Debug: w ##class(web.DHCPE.Interface.Main).UploadFTP(1)
ClassMethod UploadFTP(stream As %Stream, path As %String, fileName As %String, LocID As %String)
{
	Set ftpInfo= ..GetInfoFTP(LocID)
	Set ftp=##class(%Net.FtpSession).%New()
	If $P(ftpInfo,"^",8)="ftps" Set ftp.SSLConfiguration="FTPS"
    
	If 'ftp.Connect($PIECE(ftpInfo,"^",1),$PIECE(ftpInfo,"^",2),$PIECE(ftpInfo,"^",3),$PIECE(ftpInfo,"^",4)) {
		Quit "-1^ftp服务器连接失败！"
	}
	do ftp.Binary()
	Set path=$TRANSLATE(path,"//","/")
	For iPath=1:1:$LENGTH(path,"/") Do
	.Quit:$PIECE(path,"/",iPath)=""
	.Do ftp.MakeDirectory($PIECE(path,"/",iPath))
	.Do ftp.SetDirectory($PIECE(path,"/",iPath))
	Set sc=ftp.Store(fileName,stream)
    if $$$ISERR(sc) quit "-1^"_$SYSTEM.Status.GetErrorText(sc)
	Do ftp.Logout()
	Quit 0
}

/// Description：获取FTP上传信息
/// Input：
/// Return：       {}
/// Creator：     wangguoying
/// CreateDate：  2023-03-17
/// Debug: w ##class(web.DHCPE.Interface.Main).GetUploadInfo("2||3",".jpg",105)
ClassMethod GetUploadInfo(OEORI, IMGType, LocID)
{
	Set ret = {}
	Set ftpInfo= ..GetInfoFTP(LocID)  //ip^用户名^密码^端口^目录^宽^高^协议类型(ftp或ftps)
	Set path = $P(ftpInfo,"^",5)_ "/"_$Replace(OEORI,"||","-")
	Set srvPath = $P(ftpInfo,"^",8)_"://"_$PIECE(ftpInfo,"^",2)_":"_$PIECE(ftpInfo,"^",3)_"@"_$PIECE(ftpInfo,"^",1)_":"_$PIECE(ftpInfo,"^",4)_"/"_path
	Set fileName = $Replace(OEORI,"||","-")_"_"_..GetImgCurSort(OEORI)_IMGType
	Set ret.transType = $ZCVT($P(ftpInfo,"^",8),"U")
	Set ret.fileNames = fileName
	Set ret.serverPath = srvPath
	Set ret.path = path_"/"_fileName 
	Quit ret.%ToJSON()
}

}
