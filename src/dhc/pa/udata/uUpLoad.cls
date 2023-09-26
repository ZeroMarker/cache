Class dhc.pa.udata.uUpLoad Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// ftp服务器配置
///  ftpip 配置ftp的服务ip地址
///  ftpuser  权限用户名称
///  ftppass  权限用户密码
ClassMethod GetFtpConfig() As %String
{
        s ftpip="10.160.17.11"
        s ftpuser="root"
        s ftppass="Root!234"
        s ftpsrc="dhcpa/dhcpaupload"
        s ftpconf=ftpip_"^"_ftpuser_"^"_ftppass_"^"_ftpsrc
        q ftpconf
}

/// w ##class(dhc.pa.udata.uUpLoad).testFTP("10.160.17.11^root^Root!234^dhcpa/dhcpaupload^21")
ClassMethod testFTP(ftpconfig)
{
	   n (ftpconfig)
        ;s ftpconfig=..GetFtpConfig()
        s ftpip=$p(ftpconfig,"^",1)
        s ftpuser=$p(ftpconfig,"^",2)
        s ftppass=$p(ftpconfig,"^",3)
        s ftpsrc=$p(ftpconfig,"^",4)
        s ftpport=$p(ftpconfig,"^",5)
        s ftp=##class(%Net.FtpSession).%New()
        i 'ftp.Connect(ftpip,ftpuser,ftppass,ftpport) q -1
        Q 0
}

//

/// Description: 对上传文件的删除操作，删除库里说句的时候，同时删除本地的文件
/// others: w ##class(dhc.pa.udata.uUpLoad).DeleFile("/2016/07/26/1334500199/1334500199.xml","1") 
ClassMethod DeleFile(FileName As %String, Delrowid, ftpcon As %String) As %String
{
        n (FileName,Delrowid,ftpcon)
   		 ;s ftpconfig=..GetFtpConfig()
   		 s ftpconfig=ftpcon
   		 s ftpip=$p(ftpconfig,"^",1)
   		 s ftpuser=$p(ftpconfig,"^",2)
   		 s ftppass=$p(ftpconfig,"^",3)
   		 s ftpsrc=$p(ftpconfig,"^",4)
   		 s ftpport=$p(ftpconfig,"^",5)
  		 s ftp=##class(%Net.FtpSession).%New()
  		 i 'ftp.Connect(ftpip,ftpuser,ftppass,ftpport) q -1
  		 &SQL(delete from dhc_pa_data.PAUpLoadInfo where PAULI_Rowid=:Delrowid )
  		 s FileName="/"_ftpsrc_""_FileName
         i 'ftp.Delete(FileName) q -3
         i 'ftp.Logout() q -4
         Q 0
         q SQLCODE
}

/*
//w ##class(dhc.pa.udata.test).SendLargeFile("","demo","31","P002")

ClassMethod SendLargeFile(File As %CSP.BinaryStream, userId, UDRDDr) As %String
{
    n (File,userId,UDRDDr)
    
    ;s ^TMPLY(2)=File_"^"_userCode_"^"_UDRDDr
    Set filestream=##class(%FileBinaryStream).%New()
    
    s FileName=File.FileName    ///上传时的全路径
    Set sc=filestream.LinkToFile(FileName)
    
    s Len=$l(FileName,"\")
    s FileName=$P(FileName,"\",Len)
   
    //文件名转码
    
    s Len1=$l(FileName,".")
    s FileName2=$P(FileName,".",Len1)
    s FileName3=$E(FileName,1,$l(FileName)-$l(FileName2)-1)
  	/**
  	SET CS=0
  	
    FOR i=1:1:$LENGTH(FileName3) {
    SET CS=CS_$ASCII(FileName3,i)
    }
  
  	//s CS=FileName3
    s ftpconfig=..GetFtpConfig()
    s ftpip=$p(ftpconfig,"^",1)
    s ftpuser=$p(ftpconfig,"^",2)
    s ftppass=$p(ftpconfig,"^",3)
    s ftpsrc=$p(ftpconfig,"^",4)
    s ftp=##class(%Net.FtpSession).%New()
    i 'ftp.Connect(ftpip,ftpuser,ftppass) q -1
   
   
    i ftp.GetDirectory("dhcpaupload") d
    .i 'ftp.MakeDirectory("dhcpaupload") d
    .i ftp.GetDirectory("dhcpaupload"_"\"_$zd($h,8)) d
    ..i 'ftp.MakeDirectory("dhcpaupload"_"\"_$zd($h,8)) d
    ..i ftp.GetDirectory("dhcpaupload"_"\"_$zd($h,8)_"\"_$P($h,",",2)) d
    ...i 'ftp.MakeDirectory("dhcpaupload"_"\"_$zd($h,8)_"\"_$P($h,",",2)) 

  	
    ;Set newname="herpsrmupload"_"\"_$zd($h,8)_"\"_$P($h,",",2)_"\"_CS_"."_FileName2
    ;s newname ="/herpsrmupload"_"/"_$zd($h,8)_"/"_$P($h,",",2)_"/"_CS_"."_FileName2
  	s FileURL ="dhcpaupload"_"/"_$zd($h,8)_"/"_$P($h,",",2)_"/"_$P($h,",",2)_"."_FileName2
    i 'ftp.Store(FileURL,File) q -3
     i 'ftp.Logout() q -4
   	//文件存储路径
   	
   	//上传日期
   	s UploadDate=$P($h,",",1)
   
    
    &SQL(INSERT INTO dhc_pa_data.PAUpLoadInfo(PAULI_UDRDDr,PAULI_FileName,PAULI_UploadUser,PAULI_UploadDate,PAULI_FileURL) VALUES (:UDRDDr,:FileName,:userId,:UploadDate,:FileURL))
    ;If $$$ISERR(sc) do $System.Status.DisplayError(sc) quit $$$ERROR()
    q SQLCODE
}*/
/// Creator:ban
/// CreatDate:2016-07-21
/// Table: dhc_pa_data.PAUpLoadInfo
/// Input:
/// Output:
/// Return:返回resultString
/// Description: 查询符合条件的记录
/// others:w ##class(dhc.pa.udata.uUpLoad).FileList("","",0,25,"7")
ClassMethod FileList(sortField, sortDir, start, limit, UDRDDr) As %String
{
	n (sortField, sortDir, start, limit, UDRDDr)
	s tmpStr=""
	i UDRDDr'="" d
    .s len=$L(UDRDDr,",")
	.f i=1:1:len d
	..s tmpStr=$p(UDRDDr,",",i)
	..i tmpStr="" s tmpStr="'"_$P(UDRDDr,",",i)_"'"
	..e  s tmpStr=tmpStr_","_"'"_$P(UDRDDr,",",i)_"'"
    
	
	s sqlStr="select PAULI_Rowid,PAULI_UDRDDr,PAULI_FileName,PAULI_UploadUser->SSUSR_Name as userName,PAULI_UploadDate,PAULI_FileURL from  dhc_pa_data.PAUpLoadInfo where   PAULI_UDRDDr in ("_tmpStr_")"
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	;w sqlStr,!
	d result.Execute()
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="rowid^UDRDDr^FileName^UploadUser^UploadDate^FileURL"
	While(result.Next())
	{   
	    
	    s rowid = result.Data("PAULI_Rowid")
		s UDRDDr = result.Data("PAULI_UDRDDr")
		s FileName = result.Data("PAULI_FileName")
		s UploadUser = result.Data("userName")
		s UploadDate = result.Data("PAULI_UploadDate")
		i UploadDate  '="" s UploadDate=$zdt(UploadDate,3)
		s FileURL = result.Data("PAULI_FileURL")
	    
		s tmp=rowid_"^"_UDRDDr_"^"_FileName_"^"_UploadUser_"^"_UploadDate_"^"_FileURL
		
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator:LY
/// CreatDate:2015-01-19
/// Description:根据条件查询记录
/// Table: herp_srm_data.UpLoadInfo
/// Input:
/// Output:
/// Return:返回userID
/// Others:w ##class(herp.srm.udata.uUpLoad).GetUpLoadInfo("","")
ClassMethod GetUpLoadInfo(UDRDDr) As %String
{
	n (UDRDDr)
	
	s tmpStr=""
	i UDRDDr'="" d
    .s len=$L(UDRDDr,",")
	.f i=1:1:len d
	..s UDRDDrStr=$p(UDRDDr,",",i)
	..i tmpStr="" s tmpStr="'"_$P(UDRDDr,",",i)_"'"
	..e  s tmpStr=tmpStr_","_"'"_$P(UDRDDr,",",i)_"'"
	
	
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select PAULI_Rowid  from  dhc_pa_data.PAUpLoadInfo where   PAULI_UDRDDr in ("_tmpStr_")"

	d result.Prepare(sqlStr)
	d result.Execute()
	s rowid=0
	While(result.Next()){
			
		s rowid = result.Data("PAULI_Rowid")
		
	}
	
	q 1
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uUpLoadS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
