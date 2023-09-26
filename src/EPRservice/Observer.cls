/// Class Name:		EPRservice.Observer
/// Description:	
/// Creator:	    YHY
/// Create Date:	2012-10-28
Class EPRservice.Observer Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Description:	根据传入参数，更新订阅数据项的内容
/// Creator:	    YHY
/// Create Date:	2012-11-01
/// Return:         1:更新成功   -1：保存失败   -2：缺少参数
/// debug:          d ##class(EPRservice.Observer).BLUpdateData("12","NAME^^TUTU","3928","192.168.1.104")
ClassMethod BLUpdateData(ArgPateintID As %String, ArgChangedata As %String, ArgUserID As %String, ArgIPaddress As %String) As %String
{
	q:ArgChangedata="" -1
	for count = 1:1:$l(ArgChangedata,"&")
	{
		s changedata = $p(ArgChangedata,"&",count)
        s Code = $p(changedata,"^",1)
    	s CurrentValue = $p(changedata,"^",2)
    	if (Code = "NAME")
    	{
   			s ret = ##class(EPRservice.Observer.PaPatMas).UpdateName(ArgPateintID,CurrentValue)
   			if (ret = 1)
   			{
	   			d ..BLSaveLog(ArgPateintID,ArgChangedata,ArgUserID,ArgIPaddress)
	   		}
	        
     	}
     	elseif(Code = "IDCARD")
		{
   			s ret = ##class(EPRservice.Observer.PaPatMas).UpdateIDCard(ArgPateintID,CurrentValue)
   			if (ret = 1)
   			{
	   			d ..BLSaveLog(ArgPateintID,ArgChangedata,ArgUserID,ArgIPaddress)
	   		}
		}
 		//Elseif()....}
	}
	q ret
}

/// Description:	取患者基本信息的原数据
/// Creator:	    YHY
/// Create Date:	2012-11-05
/// Return:         患者基本信息表原有数据
/// Debug: 			w ##class(EPRservice.Observer).BLGetData("IDCARD","11")
ClassMethod BLGetData(ArgCode As %String, ArgpateintID As %String) As %String
{
	q:ArgpateintID="" -1
	s original = ""
	s PAPatMasobj = ##class(User.PAPatMas).%OpenId(ArgpateintID)
	if (ArgCode = "NAME")
	{
		s original = PAPatMasobj.PAPMIName
	}
	elseif (ArgCode = "IDCARD")
	{
		s original = PAPatMasobj.PAPMIID
	}
	q original
}

/// Description:	电子病历订阅信息操作日志保存
/// Creator:	    YHY
/// Create Date:	2012-11-05
/// Return:         1:保存成功   -1：保存失败   -2：缺少参数
ClassMethod BLSaveLog(ArgPateintID As %String, ArgChangedata As %String, ArgUserID As %String, ArgIPaddress As %String) As %String
{
	q:ArgPateintID="" -2
	s ReturnValue = 0
	for count = 1:1:$l(ArgChangedata,"&")
	{
		s changedata = $p(ArgChangedata,"&",count)
        s Code = $p(changedata,"^",1)
    	s Current = $p(changedata,"^",2)
    	s Original= $p(changedata,"^",3)
    	
		s LogObj = ##class(EPRmeta.SubjectLog).%New()
		s LogObj.PateintID = ArgPateintID
		s LogObj.SaveDoc = ArgUserID
		s LogObj.SaveCode = Code
		s LogObj.SaveOriginal = Original
		s LogObj.SaveCurrent = Current
		s LogObj.SaveDate = $p($H,",",1)
		s LogObj.SaveTime = $p($H,",",2)
		s LogObj.SaveIP = ArgIPaddress

	    s sc = LogObj.%Save()
	
	    if $system.Status.IsError(sc) 		//检查Save是否成功
		{                               
   			d $system.OBJ.DisplayError(sc) 
   			set ReturnValue = -1
		}
		else
		{
			set ReturnValue = 1
		}
		d LogObj.%Close()
		s LogObj = ""
	}
    q ReturnValue
}

}
