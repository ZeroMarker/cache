Class EMRservice.Ajax.pictureManage Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s episodes = $Get(%request.Data("episodes",1),"")
	s sort = $Get(%request.Data("sort",1),"")
	s action = $Get(%request.Data("Action",1),"")
	if (action = "getPicList")
	{
		s json = ..GetPic(episodes,sort)
		w json
	}elseif (action = "delPic")
	{
		s rowID = $Get(%request.Data("RowId",1),"")
		s result = ..DeletePic(rowID)
		w result	
	}
	Quit $$$OK
}

/// Desc	:保存图片
/// Input	:
/// Output	:1 成功		,	其他 失败
/// Debug	:w ##class(EMRservice.Ajax.pictureManage).SavePicture(13,413,"/picDoc/vo(1)/13/413/Default/","13-1598343593723.jpg","Default","ftp://dhcepr:dhcc$123@10.17.0.9","张松亮","Y")
ClassMethod SavePicture(APatientID As %String, AEpisodeID As %String, ADicName As %String, AFileName As %String, ASort As %String, AFtpUrl As %String, AUserName As %String, AStatus As %String = "") As %String
{
	s Response=""
	//s ^Temp("duan","SavePicture")=APatientID_","_AEpisodeID_","_ADicName_","_AFileName_","_ASort_","_AFtpUrl_","_AUserName_","_AStatus
	q:APatientID="" "没有PatientID"
	q:AEpisodeID="" "就诊号为空"
	q:ADicName="" "文件夹名称为空"
	if (AStatus="") s AStatus="Y"
	s obj=""
	s obj=##class(EMRinstance.pictureManage).%New()
	s obj.PatientID=APatientID
	s obj.EpisodeID=AEpisodeID
	s obj.DicName=ADicName
	s obj.FileName=AFileName
    s obj.CreatUser=AUserName
    s obj.CreatDate=+$h
    s obj.CreatTime=$p($h,",",2)
    s obj.Sort = ASort
    s obj.FtpUrl = AFtpUrl
    s obj.Status = AStatus
    s sc=obj.%Save()
   
    i sc'=1 d
    .s Response="保存出错!"
    i sc=1 d
    .s Response="1"
    q Response
}

/// Desc	:获取图片
/// Input	:AEpisodes 就诊号
/// Output	:
/// Debug	:w ##class(EMRservice.Ajax.pictureManage).GetPic("413","Default")
ClassMethod GetPic(AEpisodes As %String, ASort As %String)
{
	s ret=""
	s result = ""
	q:AEpisodes="" ret
	s length = $l(AEpisodes,",")
	for I=1:1:length
	{
		s episodeId = $P(AEpisodes,",",I)
		if (I=1){
			s flag = 1
		}else{
			s flag = 0	
		}
		s result = result_""_ ..GetPicJsonByEpisodeID(episodeId,ASort,flag)	
	}
	s result = $ZSTRIP(result,"*C")
	s ret = "["_result_"]"
	q ret
}

/// Desc	:删除图片 
/// Input	:图片id ARowID
/// Output	:
/// Debug	:w ##class(EMRservice.Ajax.pictureManage).DeletePic("1")
ClassMethod DeletePic(ARowID)
{
	q:ARowID="" "删除出错!"
	s picObj = ##class(EMRinstance.pictureManage).%OpenId(ARowID)
	s picObj.Status = "N"
	s sc = picObj.%Save()
	i sc'=1 d
    .s Response="删除出错!"
    i sc=1 d
    .s Response="删除成功!"
    q Response
}

/// Desc	:获取图片Json串
/// Input	:episodeID
/// Output	:
/// Debug	:w ##class(EMRservice.Ajax.pictureManage).GetPicJsonByEpisodeID("413","DEFAULT","1")
ClassMethod GetPicJsonByEpisodeID(AEpisodeID As %String, ASort As %String, isNewPic As %String)
{
	s json = ""
	q:AEpisodeID="" "就诊号为空"
	s ASort=$zcvt(ASort,"U")
    if (ASort = "DEFAULT")
    {
		s sort = ""
		for 
		{
			s sort=$o(^DHCEMRI.pictureManageI("IdxEpisodeAndStatus"," "_AEpisodeID,sort))
			q:sort=""
			s CreateDate=""
			for
			{
				s CreateDate=$o(^DHCEMRI.pictureManageI("IdxEpisodeAndStatus"," "_AEpisodeID,sort," Y",CreateDate))
				q:CreateDate=""
				s CreateTime=""
				for
				{
					s CreateTime=$o(^DHCEMRI.pictureManageI("IdxEpisodeAndStatus"," "_AEpisodeID,sort," Y",CreateDate,CreateTime))
					q:CreateTime=""
					s PicRowid = 0
					for
					{
						s PicRowid=$o(^DHCEMRI.pictureManageI("IdxEpisodeAndStatus"," "_AEpisodeID,sort," Y",CreateDate,CreateTime,PicRowid))
						q:PicRowid=""
						s obj = ##class(EMRinstance.pictureManage).%OpenId(PicRowid)
						s DicName = obj.DicName
						s FileName = obj.FileName
						s FtpUrl = obj.FtpUrl
						if (isNewPic=0) s json = json_","
						s json = json_"{""RowId"":"""_PicRowid_""","
						s json = json_"""pic"":"""_FtpUrl_DicName_"/"_FileName_"""}"
						s isNewPic = 0
					}
				}
			}
		}   
	}
	else
	{
		s CreateDate=""
			for
			{
				s CreateDate=$o(^DHCEMRI.pictureManageI("IdxEpisodeAndStatus"," "_AEpisodeID," "_ASort_""," Y",CreateDate))
				q:CreateDate=""
				s CreateTime=""
				for
				{
					s CreateTime=$o(^DHCEMRI.pictureManageI("IdxEpisodeAndStatus"," "_AEpisodeID," "_ASort_""," Y",CreateDate,CreateTime))
					q:CreateTime=""
					s PicRowid = 0
					for
					{
						s PicRowid=$o(^DHCEMRI.pictureManageI("IdxEpisodeAndStatus"," "_AEpisodeID," "_ASort_""," Y",CreateDate,CreateTime,PicRowid))
						q:PicRowid=""
						s obj = ##class(EMRinstance.pictureManage).%OpenId(PicRowid)
						s DicName = obj.DicName
						s FileName = obj.FileName
						s FtpUrl = obj.FtpUrl
						if (isNewPic=0) s json = json_","
						s json = json_"{""RowId"":"""_PicRowid_""","
						s json = json_"""pic"":"""_FtpUrl_DicName_"/"_FileName_"""}"
						s isNewPic = 0
					}
				}
			}
	}
	q json
}

/// desc：获取FTP信息
///  w ##class(EMRservice.Ajax.pictureManage).GetFtpValue()
ClassMethod GetFtpValue()
{
	s json="{"
	s ftpStr = ##class(EMRservice.BL.BLSysOption).GetOptionValueByName2("FTP_CONNECT_PARAMS_UPLOAD")
	s len = $l(ftpStr,",")
	for i=1:1:len
	{
		s str =	$P(ftpStr,",",i)
		s key = $replace($P(str,":",1),"'","")
		s value = $replace($P(str,":",2),"'","")
		s:i>1 json = json_","
		s json	= json_""""_key_""":"""_value_""""
	}
	s json = json_"}"
	s json = $ZSTRIP(json,"*C")
	q json
}

/// desc：获取患者姓名全拼
///  w ##class(EMRservice.Ajax.pictureManage).NameFull()
ClassMethod NameFull(argPaperDR As %String)
{
	q:($d(argPaperDR)=0)||(argPaperDR="") ""
	s name=""
	
	q:($d(^PAPER(argPaperDR,"ALL"))'=1)&&($d(^PAPER(argPaperDR,"ALL"))'=11) ""
	s name=$P($G(^PAPER(argPaperDR,"ALL")),"^",19)
	s name = $tr(name," ","")
		
	q name
}

}
