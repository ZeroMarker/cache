Class web.DHCBL.BDP.BKRSMessage Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:		陈莹
/// CreatDate:		2021-01-07
/// Description:	北科瑞声，调用http接口
/// Table:			
/// Input:			ReqCode:请求代码  Params调用参数多维数组的引用
/// Output:			ErrMsg错误信息
/// Return:			0^success  -1^错误消息
/// Others:			其它说明
/// Debug:			w ##class(web.DHCBL.BDP.BKRSMessage).PostMessage("YHT_Send_User","username^test4$&password^123456$&nickname^123")  //用户注册
///                 w ##class(web.DHCBL.BDP.BKRSMessage).PostMessage("YHT_Delete_User","username^工号")   //删除用户
///                 w ##class(web.DHCBL.BDP.BKRSMessage).PostMessage("YHT_Get_User","username^test4")   //获取用户
ClassMethod PostMessage(ReqCode As %String, InputParams As %String) As %String
{
	n (ReqCode, InputParams)
	s token=""
	s ParamLength=$L(InputParams,"$&")
	for Parami=1:1:ParamLength
	{
		s InputParam=$p(InputParams,"$&",Parami)
		s name=$p(InputParam,"^",1)
		continue:name=""
		s value=$p(InputParam,"^",2)
		x "s p("""_name_""")="""_value_""""
	}
	s token=..GetToken(ReqCode)
	
	if ((token="")||(token<0))  q "-1^获取不到token"
	s p("token")=token
	s ret=##class(CF.BSP.SYS.SRV.Request).Send(ReqCode,.p,.errMsg)  //调用基础平台http请求接口
	//if errMsg'="" q errMsg
	set jsonObj=##class(%DynamicAbstractObject).%FromJSON(ret)  //将返回值json处理成对象
	if (jsonObj.code=200)
	{
		//消息调用成功
		q "0^"_jsonObj.code_jsonObj.description
	}
	else
	{
		q "-1^"_jsonObj.code_jsonObj.description
	}
}

/// Creator:		陈莹
/// CreatDate:		2021-01-07
/// Description:	北科瑞声，调用http接口,获取token
/// Table:			
/// Input:			
/// Output:			token(为空时/-1^报错），非空时是为正常token
/// Others:			其它说明
/// Debug: w ##class(web.DHCBL.BDP.BKRSMessage).GetToken("YHT_Get_User")
ClassMethod GetToken(ReqCode) As %String
{
	n (ReqCode)
	s token=""
	s oid=$o(^CF.BSP.SYS.RequestI("ReqCode"," "_$zcvt(ReqCode,"U"),""),-1)
	if oid="" q "-1^ReqCode="_ReqCode_"不存在"
	
	Set obj = ##class(CF.BSP.SYS.Request).%OpenId(oid)
	s ServerUrl=""
	if $IsObject(obj){
		set ServerUrl=obj.ServerUrl
	}
	if (ServerUrl["voice-interaction-api")
	{
		s p("account")="admin"
		s p("passward")="123456"
		//s ret="{""code"":""200"",""description"":""IM Token Add Successful By Redis"",""data"":{""token_ttl"":3600,""token"":""7d8a40c83a8f256974519d20b9bae0ea""},""other"":{}}"
		s messageret=##class(CF.BSP.SYS.SRV.Request).Send("Get_Token",.p,.errMsg) //调用基础平台http请求接口  调用第二个获取token接口 语音训练
	}
	else
	{
		
		s p("im_code")="donghua"
		//s ret="{""code"":""200"",""description"":""IM Token Add Successful By Redis"",""data"":{""token_ttl"":3600,""token"":""7d8a40c83a8f256974519d20b9bae0ea""},""other"":{}}"
		s messageret=##class(CF.BSP.SYS.SRV.Request).Send("YHT_Get_Token",.p,.errMsg) //调用基础平台http请求接口  调用第一个获取token接口 用户注册
	}
	set messageJsonObj=##class(%DynamicAbstractObject).%FromJSON(messageret)  //将返回值json处理成对象
	if (messageJsonObj.code=200)
	{
		s token=messageJsonObj.data.token
	}
	else
	{
		q "-1"
	}
	q token
}

/// Creator:		陈莹
/// CreatDate:		2021-03-12
/// Description:	北科瑞声，调用http接口,更新场景
/// Table:			
/// Input:			
/// Output:			0^success  -1^错误消息
/// Others:			
/// Debug: w ##class(web.DHCBL.BDP.BKRSMessage).UpdateScene()
ClassMethod UpdateScene() As %String
{
	n
	s InputParams=""
	s sceneid=$p($g(^Config.BDPSpeConfig("CTHCCS")),"^",2)  //场景ID   //平台ID 场景ID WordID   科室ID 群组ID 姓名ID
	if sceneid="" q "-1^场景ID为空,请确认配置"
	s InputParams="scene_id^"_sceneid_"$&add_tongyong^0"
	s ret=..PostMessage("YHT_Update_Scene",InputParams)   // 更新场景
	q ret
}

/// Creator:		陈莹
/// CreatDate:		2021-03-12
/// Description:	北科瑞声，调用http接口,更新附加训练8.1接口
/// Table:			
/// Input:			content:内容
/// Output:			0^success  -1^错误消息
/// Others:			
/// Debug: w ##class(web.DHCBL.BDP.BKRSMessage).TrainingSet("内分泌科胡珊")
ClassMethod TrainingSet(content As %String) As %String
{
	n (content)
	s InputParams=""
	s sceneid=$p($g(^Config.BDPSpeConfig("CTHCCS")),"^",2)  //场景ID   //平台ID 场景ID WordID   科室ID 群组ID 姓名ID
	if sceneid="" q "-1^场景ID为空,请确认配置"
	s InputParams="scene_id^"_sceneid_"$&content^"_content
	s ret= ##class(web.DHCBL.BDP.BKRSMessage).PostMessage("YHT_Training_Set",InputParams)   // 更新附件训练
	q ret
}

/// Creator:		陈莹
/// CreatDate:		2021-03-12
/// Description:	北科瑞声，调用http接口,医呼通-新增 、 修改Value(用户/科室/医呼通科室/医呼通群组） 7.9 ，7.12
/// Table:			
/// Input:		TableDesc:科室、群组、姓名	   OperateType:A 新增  U 修改  先不考虑删除
/// Output:			0^success  -1^错误消息
/// Others:			
/// Debug: w ##class(web.DHCBL.BDP.BKRSMessage).SaveValue("科室","name^内分泌科","A")
/// Debug: w ##class(web.DHCBL.BDP.BKRSMessage).SaveValue("科室","value^内分泌科$&new_value^内分泌","U")
ClassMethod SaveValue(TableDesc As %String, Value As %String, OperateType As %String) As %String
{
	n (TableDesc,Value,OperateType)
	s InputParams=""
	//配置：平台ID 场景ID WordID   科室ID 群组ID 姓名ID
	if (TableDesc="科室")
	{
		s InputParams="word_id^"_$p($g(^Config.BDPSpeConfig("CTHCCS")),"^",3)_"$&"_"father_id^"_$p($g(^Config.BDPSpeConfig("CTHCCS")),"^",4)
	}
	elseif (TableDesc="群组")
	{
		s InputParams="word_id^"_$p($g(^Config.BDPSpeConfig("CTHCCS")),"^",3)_"$&"_"father_id^"_$p($g(^Config.BDPSpeConfig("CTHCCS")),"^",5)
	}
	elseif (TableDesc="姓名")
	{
		s InputParams="word_id^"_$p($g(^Config.BDPSpeConfig("CTHCCS")),"^",3)_"$&"_"father_id^"_$p($g(^Config.BDPSpeConfig("CTHCCS")),"^",6)
	}
	s InputParams=InputParams_"$&"_Value  //将参数内容拼接起来。
	if OperateType="A" 
	{
		s ReqCode="YHT_Add_Value"  //新增Value
	}
	if OperateType="U" 
	{
		s ReqCode="YHT_Update_ValueByName"  //修改Value
	}
	s ret= ..PostMessage(ReqCode,InputParams)   //调用新增/修改Value 接口
	q ret
}

/// Creator:丁亚男 
/// CreatDate:2021-03-11
/// Description:科室名称+用户名称 群组名称+用户名称 医呼通科室名称+用户名称 的组合调用接口推送同步数据 训练
/// Return:ok(推送完成)
/// Other:w ##class(web.DHCBL.BDP.BKRSMessage).PushLocJoinUserTrainingSet()
ClassMethod PushLocJoinUserTrainingSet() As %String
{
	n
	k TrainingArray
	//科室名称+用户名称
	s HCCSCLRowId=0
	for 
	{
		s HCCSCLRowId=$o(^CT("HCCSCL",HCCSCLRowId)) q:HCCSCLRowId=""
		s HCCSCLUserDesc=$p($g(^CT("HCCSCL",HCCSCLRowId)),"^",6)     //用户描述
		
		s HCCSCLLocDesc= $p($g(^CT("HCCSCL",HCCSCLRowId)),"^",7)		//科室描述
		
		if (HCCSCLUserDesc["[")
		{
			s HCCSCLUserDesc=$p(HCCSCLUserDesc,"[",1)
		}
		if (HCCSCLLocDesc["/")
		{
			s HCCSCLLocDesc=$tr(HCCSCLLocDesc,"/","")
		}
		//w "姓名","name^"_HCCSCLUserDesc_##class(web.DHCBL.BDP.BKRSMessage).SaveValue("姓名","name^"_HCCSCLUserDesc,"A"),!
		//w "科室","name^"_HCCSCLLocDesc_##class(web.DHCBL.BDP.BKRSMessage).SaveValue("科室","name^"_HCCSCLLocDesc,"A"),!
		
		s TrainingArray(HCCSCLLocDesc_HCCSCLUserDesc)="科室名称+用户名称"
		
		
	}
	//群组名称+用户名称
	s groupid=0
	for 
	{
		s groupid=$o(^CT("HCCSGROUP",0,"ContactList",groupid)) q:groupid=""
		s GROUPDesc= $p($g(^CT("HCCSGROUP",groupid)),"^",2)		//群组名称
		//w "群组","name^"_GROUPDesc_##class(web.DHCBL.BDP.BKRSMessage).SaveValue("群组","name^"_GROUPDesc,"A"),!
		s hccsclid=0
		for 
		{
			s hccsclid=$o(^CT("HCCSGROUP",0,"ContactList",groupid,hccsclid)) q:hccsclid=""
			s HCCSCLUserDesc=$p($g(^CT("HCCSCL",hccsclid)),"^",6)     //用户描述
			if (HCCSCLUserDesc["[")
			{
				s HCCSCLUserDesc=$p(HCCSCLUserDesc,"[",1)
			}
			s TrainingArray(GROUPDesc_HCCSCLUserDesc)="群组名称+用户名称"
		}
		
	}
	//医呼通科室名称+用户名称
	s LOCRowId=0
	for 
	{
		s LOCRowId=$o(^CT("HCCSLOC",0,"HISCode",LOCRowId)) q:LOCRowId=""
		s LOCDesc= $p($g(^CT("HCCSLOC",LOCRowId)),"^",2)		//医呼通科室名称
		//w "科室","name^"_LOCDesc_##class(web.DHCBL.BDP.BKRSMessage).SaveValue("科室","name^"_LOCDesc,"A"),!
		s CTLOCCode=0
		for 
		{
			s CTLOCCode=$o(^CT("HCCSLOC",0,"HISCode",LOCRowId,CTLOCCode)) q:CTLOCCode=""
			s HCCSCLRowId=0
			for 
			{
				s HCCSCLRowId=$o(^CT("HCCSCL",0,"Loc",CTLOCCode,HCCSCLRowId)) q:HCCSCLRowId="" //个人通讯录表 
				s HCCSCLUserDesc=$p($g(^CT("HCCSCL",HCCSCLRowId)),"^",6)     //用户描述
				if (HCCSCLUserDesc["[")
				{
					s HCCSCLUserDesc=$p(HCCSCLUserDesc,"[",1)
				}
				s TrainingArray(LOCDesc_HCCSCLUserDesc)="医呼通科室名称+用户名称"
			}
		}	
	}
	s Str=""
	s content=0
	for 
	{
		s content=$o(TrainingArray(content)) q:content=""
		if Str'=""
		{
			s Str=Str_","_content
		}
		else
		{
			s Str=content
		}
	}
	s ret= ..TrainingSet(Str) //调用语音附加训练接口 8.1 需要一次同步所有数据
	q "ok"
}

/// Creator:chenying 
/// CreatDate:2021-03-17
/// Description:科室名称+用户名称 群组名称+用户名称 医呼通科室名称+用户名称 的组合调用接口推送同步数据 训练，并更新场景
/// Return:ok(推送完成)
/// Other:d ##class(web.DHCBL.BDP.BKRSMessage).TrainingSetAndUpdateScene()
ClassMethod TrainingSetAndUpdateScene() As %String
{
	d ##class(web.DHCBL.BDP.BKRSMessage).PushLocJoinUserTrainingSet()  //同步语音训练数据
	d ##class(web.DHCBL.BDP.BKRSMessage).UpdateScene()  //更新场景
	Q "ok"
}

/// chenying 
/// 2021-01-27
/// 批量导入个人通讯录
/// W ##class(web.DHCBL.BDP.ClassIOLiuqi).AddContactListData("D:\通讯录.txt")
/// TXT要求格式为ANSI编码
/// txt中列顺序 (前六列必填) ；医院名称	用户代码	用户姓名	科室代码	科室名称	VOIP号码	开始日期	结束日期
ClassMethod AddContactListData(path) As %String
{
	k ^tmpcy
	Set path1 = ##Class(%File).NormalizeFilename(path) //获取当前路径 D
    if '##class(%File).Exists(path1) {
	    q "文件不存在"
    }
    Set file=##class(%File).%New(path)
	//w file.Size,!
	d file.Open("R")
	s num=0
	k myFileAry
	for i=1:1:file.Size {
		s data=file.Read()
		q:data=""
		s num=num+1
		continue:num=1  //跳过第一行
		s myFileAry(i)=data
		s HospDesc=$p(data,"	",1)     //医院名称
		continue:HospDesc=""
        s HospId=$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(HospDesc),0))
        If (HospId="")
        {
			w !,num_" "_data_" 没找到对应的医院"
		}
		
		s HCCSCLUserCode=$p(data,"	",2)  //医生工号
		continue:HCCSCLUserCode=""
		s UserDesc=$p(data,"	",3)  //医生姓名
		continue:UserDesc=""
		s HCCSCLLocCode=$p(data,"	",4)     //科室代码
		continue:HCCSCLLocCode=""
		s LocDesc=$p(data,"	",5)     //科室名称
		continue:LocDesc=""
		s HCCSCLVOIPNumber=$p(data,"	",6)     //VOIP号码
		continue:HCCSCLVOIPNumber=""
		s HCCSCLDateFrom=$p(data,"	",7)     //开始日期
		s:HCCSCLDateFrom'="" HCCSCLDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(HCCSCLDateFrom)
		s:HCCSCLDateFrom="" HCCSCLDateFrom=+$h
		s HCCSCLDateTo=$p(data,"	",8)     //结束日期
		s:HCCSCLDateTo'="" HCCSCLDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(HCCSCLDateTo)
		s SSUSRRowId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(HCCSCLUserCode),0))
		if (SSUSRRowId'="")
		{
			s SSUSRName=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",2)      //用户名称
			if (SSUSRName=UserDesc)  //用户 代码名称匹配
			{
				//新增个人通讯录
				s flag= ##class(web.DHCBL.CT.CTHCCSContactList).FormValidate("",HCCSCLUserCode,HospId)
				if flag'=1
				{
					s obj=##class(User.CTHCCSContactList).%New()
	 		   		s obj.HCCSCLUserCode = HCCSCLUserCode  // 用户代码
	 		   		s obj.HCCSCLLocCode = HCCSCLLocCode  /// 科室代码
	 		   		s obj.HCCSCLVOIPNumber = HCCSCLVOIPNumber /// VOIP号码
	 		   		s obj.HCCSCLDateFrom = HCCSCLDateFrom  /// 开始日期
	 		   		s obj.HCCSCLDateTo = HCCSCLDateTo   /// 结束日期
	 		   		s sc=obj.%Save()
					If $$$ISOK(sc){  //保存成功
						s id=obj.%Id()
						d ##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("CT_HCCSContactList",id,HospId)  //将个人通讯录数据关联医院
						//调用北科瑞声用户注册接口
			    		s (SSUSRRowId,SSUSRName)=""
						//s HCCSCLUserCode=eobj.HCCSCLUserCode     //用户代码
						s SSUSRRowId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(HCCSCLUserCode),0))
						s:SSUSRRowId'="" SSUSRName=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",2)       //用户名
						s ret=##class(web.DHCBL.BDP.BKRSMessage).PostMessage("YHT_Send_User","username^"_HCCSCLUserCode_"$&password^123456$&nickname^"_$p(SSUSRName,"[",1))
						if ($p(ret,"^",1)=-1) 
						{
							s ret=num_" "_data_" 保存失败"_"北科瑞声同步报错:"_$p(ret,"^",2) //返回错误信息
							w !,ret
							s ^tmpcy(num)=ret
						}
					}
					else  //保存失败
					{
						s ret=num_" "_data_" 保存失败"_$SYSTEM.Status.GetErrorText(sc)
						w !,ret
						s ^tmpcy(num)=ret
					}
				}
				else
				{
					s ret=num_" "_data_" 数据已存在"
					w !,ret
					s ^tmpcy(num)=ret
				
				}
				
			}
			else  //用户 代码名称不匹配
			{
				s ret=num_" "_data_" 用户 代码名称不匹配"_" "_SSUSRName
				w !,ret
				s ^tmpcy(num)=ret
			}
		}
		else  //没有找到用户RowId
		{
			s ret=num_" "_data_" 无此用户"
			w !,ret
			s ^tmpcy(num)=ret
		}
	}
	close file
    k file
    w !,"读取数据总共"_(num-1)_"条"
    q ""
}

}
