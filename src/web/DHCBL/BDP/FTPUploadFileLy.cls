/// Fucntion: FTP服务器方式 操作文件流
/// CreateDate: 2018-5-29
/// Creator:  chenghegui
Class web.DHCBL.BDP.FTPUploadFileLy Extends %RegisteredObject
{

/// 上传文件
/// 目前没有配置界面,所以后台先写固定值
/// Set IP ="127.0.0.1"   
/// Set UserName ="dhcbdp"       
/// Set Password ="1"
/// Set Port = "21"
ClassMethod Upload(config, FileStream As %CSP.BinaryStream, Dir As %String, FileName = "")
{
    Set IP =$p($g(config),"^",1)
    Set UserName =$p($g(config),"^",2)       
    Set Password =$p($g(config),"^",3)
    Set Port = $p($g(config),"^",4)
    s ftp=##class(%Net.FtpSession).%New()
    d ftp.CommandTranslateTableSet("GB18030")
    i 'ftp.Connect(IP,UserName,Password,Port) q "-1^"_ftp.ReturnMessage
    i 'ftp.Binary() q "-2^"_ftp.ReturnMessage
    if (FileName="") Set FileName = FileStream.FileName
    ;create dir and goto dir
    if Dir'="" {
        Set Dir = ##class(ext.util.String).Replace(Dir,"//","/")
        if Dir["/" Set DirLen = $l(Dir,"/"),sep="/"
        if Dir["\" Set DirLen = $l(Dir,"\"),sep="\"
        for i=1:1:DirLen {
            set CurrentDir = $p(Dir,sep,i)
            if $l(CurrentDir)>0 {
                i ftp.SetDirectory(CurrentDir){
                }else{
                    s MakeDir = ftp.MakeDirectory(CurrentDir)
                    s cdFlag = ftp.SetDirectory(CurrentDir)
                }
            }
        }
    }
    i 'ftp.Store(FileName,FileStream) q "-3^"_ftp.ReturnMessage
    d FileStream.Clear()
    s FileStream=""
    i 'ftp.Logout() quit "-4^"_ftp.ReturnMessage
    s ftp=""
    q 1
}

/// 把某IP的某目录下某文件读到流中
/// 目前没有配置界面,所以后台先写固定值
/// Set IP ="127.0.0.1"   
/// Set UserName ="dhcbdp"       
/// Set Password ="1"
/// Set Port = "21"
ClassMethod Download(config, ByRef FileStream As %BinaryStream, Dir As %String, FileName = "")
{
    Set IP =$p($g(config),"^",1)
    Set UserName =$p($g(config),"^",2)       
    Set Password =$p($g(config),"^",3)
    Set Port = $p($g(config),"^",4)
    
    s ftp=##class(%Net.FtpSession).%New()
    d ftp.CommandTranslateTableSet("GB18030")
    i 'ftp.Connect(IP,UserName,Password,Port) q "-1^"_ftp.ReturnMessage
    i 'ftp.Binary() q "-2^"_ftp.ReturnMessage
    ;create dir and goto dir
    if Dir'="" {
        Set Dir = ##class(ext.util.String).Replace(Dir,"//","/")
        if Dir["/" Set DirLen = $l(Dir,"/"),sep="/"
        if Dir["\" Set DirLen = $l(Dir,"\"),sep="\"
        for i=1:1:DirLen {
            set CurrentDir = $p(Dir,sep,i)
            if $l(CurrentDir)>0 {
                i ftp.SetDirectory(CurrentDir){
                }else{
                    s MakeDir = ftp.MakeDirectory(CurrentDir)
                    s cdFlag = ftp.SetDirectory(CurrentDir)
                }
            }
        }
    }
    i 'ftp.Retrieve(FileName,.FileStream) q "-3^"_ftp.ReturnMessage
    i 'ftp.Logout() quit "-4^"_ftp.ReturnMessage
    s ftp=""
    q 1
}

/// ftp 判断文件是否存在
/// 目前没有配置界面,所以后台先写固定值
/// Set IP ="127.0.0.1"   
/// Set UserName ="dhcbdp"       
/// Set Password ="1"
/// Set Port = "21"
/// input:dirname eg:"/scripts/bdp/Doc/", filename eg："1.pdf"
ClassMethod FTPFileExit(config, Directory, FileName)
{
    Set FTPIP =$p($g(config),"^",1)
    Set FTPUser =$p($g(config),"^",2)       
    Set PassWord =$p($g(config),"^",3)
    Set Port = $p($g(config),"^",4)
    Set ftp=##class(%Net.FtpSession).%New()
    d ftp.CommandTranslateTableSet("GB18030")
    If 'ftp.Connect(FTPIP,FTPUser,PassWord,Port)  q 0
    s sc=ftp.Rename(Directory_FileName,Directory_FileName)
    If 'ftp.Logout() q 0
    q sc
}

/// ftp 删除文件
/// 目前没有配置界面,所以后台先写固定值
/// Set IP ="127.0.0.1"   
/// Set UserName ="dhcbdp"       
/// Set Password ="1"
/// Set Port = "21"
/// input: input:dirname eg:"/scripts/bdp/Doc/", filename eg："1.pdf"
ClassMethod DeleFile(config, Directory, FileName As %String) As %String
{
    Set FTPIP =$p($g(config),"^",1)
    Set FTPUser =$p($g(config),"^",2)       
    Set PassWord =$p($g(config),"^",3)
    Set Port = $p($g(config),"^",4)
   
    s FileNameOnly=FileName         ;名称: "****.pdf"
    s ftp=##class(%Net.FtpSession).%New()
    d ftp.CommandTranslateTableSet("GB18030")
    i 'ftp.Connect(FTPIP,FTPUser,PassWord,Port) q -1
    s FileName=Directory_FileName
    //s ExistFlag=$$IsFtpFileExist()
    //i ExistFlag=0 d ftp.Logout() q 0        ;不存在图片的,不再进行ftp删除
    i 'ftp.Delete(FileName) q -3
    i 'ftp.Logout() q -4
    q 1
    /* IsFtpFileExist()
    ;确认目录下是否存在该文件: 1存在,0不存在
    If 'ftp.NameList(Directory,.fileArray) q 1
    Set key="",isExists=0
    s count=0
    For  s tmpFileName=fileArray.GetNext(.key) Quit:(key="")||(isExists=1)  d
    .i (FileName=tmpFileName) s isExists=1
    q isExists
    */
}

}
