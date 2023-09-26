Class DHCEPRFS.BL.HISInfo.BLMediaInfo Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 获取图片信息
/// 入参：就诊ID              类型（S  P  V）（声音、图片、文本）    标签ID
/// 返回值： 标签描述   类型   地址
/// FTP服务器IP ^ 端口 ^ 虚拟目录名称 ^ 用户名 ^ 密码 # 标签描述 ^ 类型 ^ 地址 ！标签描述 ^ 类型 ^ 地址
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLMediaInfo).GetFTPPath("4550449")
ClassMethod GetFTPPath(AEpisodeID As %String) As %String
{
	q:(AEpisodeID = "") ""
	s ret = ##Class(DWR.BL.Media).GetMediaFileList(AEpisodeID)
	q ret
}

/// 检查某类型的图片是否存在
/// 入参：就诊ID              类型（S  P  V）（声音、图片、文本）    标签ID
/// 返回值： 标签描述   类型   地址
/// FTP服务器IP ^ 端口 ^ 虚拟目录名称 ^ 用户名 ^ 密码 # 标签描述 ^ 类型 ^ 地址 ！标签描述 ^ 类型 ^ 地址
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLMediaInfo).HasPicToPrint("4550449","S")
ClassMethod HasPicToPrint(AEpisodeID As %String, ATypeParams As %String) As %String
{
	s flag = 0
	s result = ""
	q:(AEpisodeID = "") ""
	s hospitalFlag = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalFlag")
	if (hospitalFlag = "DYEY")
	{
		s ret = ##Class(DWR.BL.Media).GetMediaFileList(AEpisodeID)
		q:(ret = "") ""
		s allPath = $p(ret,"#",2)
		for i = 1:1:$l(allPath,"!")
		{
			s onePath = $p(allPath,"!",i)
			s itemType = $p(onePath,"^",2)
			if (itemType = "P")
			{
				s flag = 1
			}
		}
		if (flag = 1)
		{
			s result = ATypeParams
		}
	}
	q result
}

/// 检查某类型的音频是否存在
/// 入参：就诊ID              类型（S  P  V）（声音、图片、文本）    标签ID
/// 返回值： 标签描述   类型   地址
/// FTP服务器IP ^ 端口 ^ 虚拟目录名称 ^ 用户名 ^ 密码 # 标签描述 ^ 类型 ^ 地址 ！标签描述 ^ 类型 ^ 地址
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLMediaInfo).HasPicToPrint("4550449","S")
ClassMethod HasAudioToPrint(AEpisodeID As %String, ATypeParams As %String) As %String
{
	s flag = 0
	s result = ""
	q:(AEpisodeID = "") ""
	s hospitalFlag = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalFlag")
	if (hospitalFlag = "DYEY")
	{
		s ret = ##Class(DWR.BL.Media).GetMediaFileList(AEpisodeID)
		q:(ret = "") ""
		s allPath = $p(ret,"#",2)
		for i = 1:1:$l(allPath,"!")
		{
			s onePath = $p(allPath,"!",i)
			s itemType = $p(onePath,"^",2)
			if (itemType = "S")
			{
				s flag = 1
			}
		}
		if (flag = 1)
		{
			s result = ATypeParams
		}
	}
	q result
}

/// 通过就诊号和项目类型得到图片地址
/// 入参：就诊ID              类型（S  P  V）（声音、图片、文本）    标签ID
/// 返回值： 标签描述   类型   地址
/// FTP服务器IP ^ 端口 ^ 虚拟目录名称 ^ 用户名 ^ 密码 # 标签描述 ^ 类型 ^ 地址 ！标签描述 ^ 类型 ^ 地址
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLMediaInfo).GetFTPPath("4550449")
ClassMethod GetFTPPathByTypeParams(AEpisodeID As %String, ATypeParams As %String) As %String
{
	s result = ""
	q:(AEpisodeID = "") ""
	s ret = ##Class(DWR.BL.Media).GetMediaFileList(AEpisodeID)
	q:(ret = "") ""
	s allPath = $p(ret,"#",2)
	for i = 1:1:$l(allPath,"!")
	{
		s onePath = $p(allPath,"!",i)
		s itemType = $p(onePath,"^",2)
		if (itemType = ATypeParams)
		{
			if (result = "")
			{
				s result = $p(onePath,"^",3)
			}
			else
			{
				s result = result_"#"_$p(onePath,"^",3)
			}
		}
	}
	q result
}

/// 通过就诊号获取图片地址
/// 入参：就诊ID              类型（S  P  V）（声音、图片、文本）    标签ID
/// 返回值： 标签描述   类型   地址
/// FTP服务器IP ^ 端口 ^ 虚拟目录名称 ^ 用户名 ^ 密码 # 标签描述 ^ 类型 ^ 地址 ！标签描述 ^ 类型 ^ 地址
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLMediaInfo).GetFTPPath("4550449")
ClassMethod GetPICFTPPath(AEpisodeID As %String) As %String
{
	s result = ""
	q:(AEpisodeID = "") ""
	s hospitalFlag = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalFlag")
	if (hospitalFlag = "DYEY")
	{
		s ret = ##Class(DWR.BL.Media).GetMediaFileList(AEpisodeID)
		q:(ret = "") ""
		s allPath = $p(ret,"#",2)
		for i = 1:1:$l(allPath,"!")
		{
			s onePath = $p(allPath,"!",i)
			s itemType = $p(onePath,"^",2)
			if (itemType = "P")
			{
				if (result = "")
				{
					s result = $p(onePath,"^",3)
				}
				else
				{
					s result = result_"#"_$p(onePath,"^",3)
				}
			}
		}
	}
	q result
}

/// 通过就诊号获取音频ftp地址
/// 入参：就诊ID              类型（S  P  V）（声音、图片、文本）    标签ID
/// 返回值： 标签描述   类型   地址
/// FTP服务器IP ^ 端口 ^ 虚拟目录名称 ^ 用户名 ^ 密码 # 标签描述 ^ 类型 ^ 地址 ！标签描述 ^ 类型 ^ 地址
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLMediaInfo).GetFTPPath("4550449")
ClassMethod GetAudioFTPPath(AEpisodeID As %String) As %String
{
	s result = ""
	q:(AEpisodeID = "") ""
	s hospitalFlag = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalFlag")
	if (hospitalFlag = "DYEY")
	{
		s ret = ##Class(DWR.BL.Media).GetMediaFileList(AEpisodeID)
		q:(ret = "") ""
		s allPath = $p(ret,"#",2)
		for i = 1:1:$l(allPath,"!")
		{
			s onePath = $p(allPath,"!",i)
			s itemType = $p(onePath,"^",2)
			if (itemType = "S")
			{
				if (result = "")
				{
					s result = $p(onePath,"^",3)
				}
				else
				{
					s result = result_"#"_$p(onePath,"^",3)
				}
			}
		}
	}
	q result
}

/// 通过就诊号获取视频ftp地址
/// 入参：就诊ID              类型（S  P  V）（声音、图片、文本）    标签ID
/// 返回值： 标签描述   类型   地址
/// FTP服务器IP ^ 端口 ^ 虚拟目录名称 ^ 用户名 ^ 密码 # 标签描述 ^ 类型 ^ 地址 ！标签描述 ^ 类型 ^ 地址
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLMediaInfo).GetFTPPath("4550449")
ClassMethod GetVideoFTPPath(AEpisodeID As %String) As %String
{
}

}
