Class web.DHCEQ.query.DHCEQPicture Extends %Library.RegisteredObject [ Not ProcedureBlock ]
{

/*
ClassMethod GetPicture(Start = 0, Limit = 40, CurrentSourceType As %String, CurrentSourceID As %String, vData As %String = "")
{
	s json = ##class(Code.JsonObj).%New()
	s count = 0
	s end = Start+Limit
	
	s PicNo=$p($G(vData),"^",3)
	s PicTypeDR=$p($G(vData),"^",6)
	S SourceType=$p($G(vData),"^",9)
	s:SourceType="" SourceType=CurrentSourceType
	s SourceID=##Class(web.DHCEQ.query.DHCEQPicture).GetSourceID(CurrentSourceType,CurrentSourceID,SourceType)
	d BuildDataGetPictureList
	
	s resultString = json.getJsonData("RowId^EquipDR^Path^Remark^PicTypeDR^PicTypeDesc^PicNo^PicLocation^PicNum^PicName^SourceType^SourceTypeDesc",count)
    k json
    q resultString
	Quit $$$OK
BuildDataGetPictureList
	
	i (SourceType'="")&&(SourceID'="")  d
	.s NewRowid=0
	.f  s NewRowid=$o(^DHCEQPicture(0,"Source",SourceType,SourceID,NewRowid)) q:NewRowid=""  d
	..d ResetVariablesGetPictureList
	..s TRowID=NewRowid
	..s TPicNo=$p($g(^DHCEQPicture(TRowID)),"^",2)
	..q:(PicNo'="")&&(PicNo'[TPicNo)
	..s TPicTypeDR=$p($g(^DHCEQPicture(TRowID)),"^",5)
	..q:(PicTypeDR'="")&&(PicTypeDR'=TPicTypeDR)
	..d GetListInfo
	..d OutputRowGetPictureList
	quit
GetListInfo
	s TEquipDR=$p($g(^DHCEQPicture(TRowID)),"^",1)
	s TPath=$p($g(^DHCEQPicture(TRowID)),"^",4)
	s TRemark=$p($g(^DHCEQPicture(TRowID)),"^",3)
	
	s:TPicTypeDR'="" TPicTypeDesc=$p($G(^DHCEQCCode("DHCEQCPicType",TPicTypeDR)),"^",2)
	s TPicLocation=$p($g(^DHCEQPicture(TRowID)),"^",18)
	s TPicName=$p($g(^DHCEQPicture(TRowID)),"^",13)
	d GetPicNum
	s TSourceType=SourceType
	s TSourceTypeDesc=$Case(TSourceType,0:"设备",1:"保养",2:"检查",3:"维修",4:"证件",5:"采购合同",6:"保修合同",7:"验收",99:"培训")
	quit
GetPicNum
	s TPicNum=0
	s PictureListDR=""
	for  s PictureListDR=$o(^DHCEQPictureList(PictureListDR)) q:PictureListDR=""  s TPicNum=TPicNum+1
	quit
OutputRowGetPictureList
	s Data=TRowID_"^"_TEquipDR_"^"_TPath_"^"_TRemark_"^"_TPicTypeDR_"^"_TPicTypeDesc_"^"_TPicNo_"^"_TPicLocation_"^"_TPicNum_"^"_TPicName_"^"_TSourceType_"^"_TSourceTypeDesc
	s count = count+1
	i (count>Start)&(count<=end) d
	.d json.InsertRowData(Data)
	quit
ResetVariablesGetPictureList
	s (TRowID,TEquipDR,TPath,TRemark,TPicTypeDR,TPicTypeDesc,TPicNo,TPicLocation,TPicNum,TPicName,TSourceType,TSourceTypeDesc)=""
	quit
}

ClassMethod SaveData(PTData = "", PLData = "")
{
	Set PTRowID=$p($G(PTData),"^",1)
 	Set PTEquipDR=$p($G(PTData),"^",2)
 	Set PTPictureNo=$p($G(PTData),"^",3)
 	Set PTRemark=$p($G(PTData),"^",4)
 	Set PTPath=$p($G(PTData),"^",5)	
 	Set PTPicTypeDR=$p($G(PTData),"^",6)
 	Set PTSourceType=$p($G(PTData),"^",9)
 	Set PTSourceID=$p($G(PTData),"^",10)
 	Set PTPicName=$p($G(PTData),"^",14)
 	Set PTLocation=$p($G(PTData),"^",19)
 	
 	Set PLRowID=$p($G(PLData),"^",1)
 	Set PLSuffix=$p($G(PLData),"^",3)
 	Set PLPicSort=$p($G(PLData),"^",5)
 	Set PLDefaultFlag=$p($G(PLData),"^",4)
 	Set:PLDefaultFlag="" PLDefaultFlag="N"
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	if (PTRowID="")
 	{ 
 		TSTART
 		&SQL(Insert into SQLUSER.DHC_EQPicture(PT_EquipDR,PT_PictureNo,PT_Remark,PT_Path,PT_PicTypeDR,PT_SourceType,PT_SourceID,PT_PicName,PT_UpdateDate,PT_UpdateTime,PT_UpdateUser,PT_Location,PT_InvalidFlag)
 			values (:PTEquipDR,:PTPictureNo,:PTRemark,:PTPath,:PTPicTypeDR,:PTSourceType,:PTSourceID,:PTPicName,:User,:Date,:Time,:PTLocation,0)) 
 		s PTRowID=$g(%ROWID)
 		if SQLCODE
		{
	   		TROLLBACK
	   		q SQLCODE
	 	}
	 	//&SQL(insert into SQLUSER.DHC_EQPictureList (PL_PictureDR,PL_Remark,PL_UpdateUserDR,PL_UpdateDate,PL_UpdateTime) values(:rowid,:remark,:Date,:Time,:User))
	 	&SQL(insert into SQLUSER.DHC_EQPictureList (PL_PictureDR,PL_Suffix,PL_PicSort,PL_UploadUserDR,PL_UploadDate,PL_UploadTime,PL_InvalidFlag,PL_DefaultFlag,PL_UpLoadFlag) values(:PTRowID,:PLSuffix,:PLPicSort,:Date,:Time,:User,'N',:PLDefaultFlag,'N')) //QW-2015-06-23 新增PL_UpLoadFlag
	 	s rowid=$g(%ROWID)
	 	if SQLCODE
		{
	   		TROLLBACK
	   		q SQLCODE
	 	}
 	}
 	else{
	 	TSTART
 		&SQL(Update SQLUSER.DHC_EQPicture set PT_PictureNo=:PTPictureNo,PT_Remark=:PTRemark,PT_Path=:PTPath,PT_PicTypeDR=:PTPicTypeDR,PT_PicName=:PTPicName,PT_UpdateDate=:Date,PT_UpdateTime=:Time,PT_UpdateUser=:User,PT_Location=:PTLocation,PT_InvalidFlag=1 where PT_RowID = :PTRowID)
 		s PTRowID=$g(%ROWID)
 		if SQLCODE
		{
	   		TROLLBACK
	   		q SQLCODE
	 	}
	 	if PLRowID=""
	 	{
		 	&SQL(insert into SQLUSER.DHC_EQPictureList (PL_PictureDR,PL_Suffix,PL_PicSort,PL_UploadUserDR,PL_UploadDate,PL_UploadTime,PL_InvalidFlag,PL_DefaultFlag,PL_UpLoadFlag) values(:PTRowID,:PLSuffix,:PLPicSort,:Date,:Time,:User,'N',:PLDefaultFlag,"N"))  //QW-2015-06-23 新增PL_UpLoadFlag
	 		s rowid=$g(%ROWID)
	 		if SQLCODE
			{
	   			TROLLBACK
	   			q SQLCODE
	 		}
	 	}
	 	else
	 	{
	 		//&SQL(Update SQLUSER.DHC_EQPictureList set PL_Remark=:remark,PL_UpdateDate=:Date,PL_UpdateTime=:Time,PL_UpdateUserDR=:User where PL_PictureDR = :rowid)
	 		&SQL(Update SQLUSER.DHC_EQPictureList set PL_Suffix=:PLSuffix,PL_PicSort=:PLPicSort,PL_UploadUserDR=:User,PL_UploadDate=:Date,PL_UploadTime=:Time,PL_DefaultFlag=:PLDefaultFlag,PL_UpLoadFlag="N" where PL_RowID = :PLRowID)
	 		s rowid=$g(%ROWID)
	 		if SQLCODE
			{
	   			TROLLBACK
	   			q SQLCODE
	 		}
	 	}
	 	
	}
	if PLDefaultFlag="Y"
	{
		
		&SQL(Update SQLUSER.DHC_EQPictureList set PL_DefaultFlag='N' where PL_RowID != :PLRowID and PL_PictureDR=:PTRowID )
		if SQLCODE&&(SQLCODE'=100)
		{
	  	 	TROLLBACK
	   		q SQLCODE
		}
	}
	TCOMMIT
 	if SQLCODE&&(SQLCODE'=100)  q SQLCODE
 	q rowid
}

ClassMethod SaveData(vData As %Library.String = "")
{
	
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	Set PTRowID=$p($G(vData),"^",1)
 	Set PTEquipDR=$p($G(vData),"^",2)
 	Set PTRemark=$p($G(vData),"^",4)
 	Set PTPath=$p($G(vData),"^",5)	
 	Set PTPicTypeDR=$p($G(vData),"^",6)
 	Set PTSourceType=$p($G(vData),"^",9)
 	Set PTSourceID=$p($G(vData),"^",10)
 	if (PTRowID="")
 	{ 
 		&SQL(Insert into SQLUSER.DHC_EQPicture(PT_RowID,PT_EquipDR,PT_Remark,PT_Path,PT_PicTypeDR,PT_SourceType,PT_SourceID,PT_UpdateDate,PT_UpdateTime,PT_UpdateUser)
 			values (:PTRowID,:PTEquipDR,:PTRemark,:PTPath,:PTPicTypeDR,:PTSourceType,:PTSourceID,:User,:Date,:Time))
 		s rowid=$g(%ROWID)
 	}
 	else{
 		&SQL(Update SQLUSER.DHC_EQPicture set PT_EquipDR=:PTEquipDR,PT_Remark=:PTRemark,PT_Path=:PTPath,PT_PicTypeDR=:PTPicTypeDR,PT_SourceType=:PTSourceType,PT_SourceID=:PTSourceID,PT_UpdateDate=:User,PT_UpdateTime=:Date,PT_UpdateUser=:Time where PT_RowID = :PTRowID)
 		s rowid=$g(%ROWID)
	}
 	if SQLCODE  q SQLCODE
 	q rowid
}

ClassMethod GetSourceID(CurrentSourceType As %String, CurrentSourceID As %String, SourceType = "")
{
	i SourceType="" q CurrentSourceID
	q:##Class(web.DHCEQ.query.DHCEQCPicSourceType).Configure(CurrentSourceType,SourceType)=0 -1
	set menusJson="["
	i CurrentSourceType=7 d
	.i SourceType=7 d
	..s TSourceID=CurrentSourceID
	e  d
	.s EquipDR=$CASE(CurrentSourceType,0:CurrentSourceID,1:$p($G(^DHCEQMaint(CurrentSourceID)),"^",1),2:$p($G(^DHCEQMaint(CurrentSourceID)),"^",1),3:$p($G(^DHCEQMaintRequest(CurrentSourceID)),"^",1),:"")
	.q:EquipDR=""
	.i SourceType=0 d
	..s TSourceID=EquipDR
	.i SourceType=1 d
	..s TSourceID=$o(^DHCEQCCode(0,"Equip",1,EquipDR,""))
	.i SourceType=2 d
	..s TSourceID=$o(^DHCEQCCode(0,"Equip",2,EquipDR,""))
	.i SourceType=3 d
	..s TSourceID=$o(^DHCEQMaintRequest(0,"Equip",EquipDR,""))
	.i SourceType=7 d
	..s TSourceID=$p(^DHCEQEquip(EquipDR),"^",77)
	q TSourceID
}

//GR0033 EXTJS 图片上传 添加4个取url函数

ClassMethod GetFtpSrcByRowid(rowid)
{
	set server=##class(web.DHCEQCommon).GetSysInfo("990018")
	set name=$p(server,"&",2)
	set password=$p(server,"&",3)
	set port=21
	i $p(server,"&",4)'="" set port=$p(server,"&",4)
	set server=$p(server,"&",1)
	//s Link="ftp://"_name_":"_password_"@"_server_##class(web.DHCEQCommon).GetSysInfo("990004")
	s Link="ftp://"_name_":"_password_"@192.168.109.129"_##class(web.DHCEQCommon).GetSysInfo("990004")
	s PicName=$p($g(^DHCEQPicture(rowid)),"^",13)
	s Link=Link_PicName
	q Link
}

ClassMethod GetStreamSrcByRowid(rowid)
{
	s PSLRowID=""
	&SQL(select PSL_RowID into :PSLRowID from SQLUser.DHC_EQPictureStreamList where PLS_PictureDR=:rowid)
	set attachement=##Class(User.DHCEQPictureStreamList).%OpenId(PSLRowID)
	s oid=attachement.PLSPhoto.%Oid()
	i $G(^DHCEQTemp("Cache","ID"))="" s ^DHCEQTemp("Cache","ID")=0
	q "%25CSP.StreamServer.cls?STREAMOID="_(##Class(websys.Page).Encrypt(oid))_"&CacheID="_$I(^DHCEQTemp("Cache","ID"))
}

ClassMethod GetFtpStreamSrcByPTRowID(PTRowID)
{
	s PLRowID=""
	&SQL(select PL_RowID  into:PLRowID from SQLUser.DHC_EQPictureList where PL_PictureDR=:PTRowID and PL_DefaultFlag='Y')
	q ##Class(web.DHCEQ.query.DHCEQPicture).GetFtpStreamSrcByPLRowID(PLRowID)
}

ClassMethod GetFtpStreamSrcByPLRowID(PLRowID)
{
	b
	i PLRowID="" q 0
	i $G(^DHCEQTemp("Cache","ID"))="" s ^DHCEQTemp("Cache","ID")=0	//清缓存用
	q "web.DHCEQ.CSP.DHCEQStreamServer.cls?PICTUREROWID="_(##Class(websys.Page).Encrypt(PLRowID))_"&CacheID="_$I(^DHCEQTemp("Cache","ID"))
}

ClassMethod GetHttpSrcByRowid(rowid)
{
	q "http://192.168.109.129/dthealth/web/FTP"_##class(web.DHCEQCommon).GetSysInfo("990004")_$p($g(^DHCEQPicture(rowid)),"^",13)
}
*/
}
