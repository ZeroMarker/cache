/// 名称:	EMR.OP.HISInterface.LinkSrv
/// 描述:	门诊病历-链接单元数据服务基类
/// 编写者：yejian
/// 编写日期: 2021-7-22
/// 产品组：电子病历产品组
Class EMR.OP.HISInterface.LinkSrvBase Extends %RegisteredObject
{

/// Desc:       获取本次就诊诊断记录
/// Creator:    yejian
/// CreateDate: 2022-8-18
/// Input:      AEpisodeID 是就诊号
/// 			ICDType 是否获取中医诊断(1 中医,空或0 西医)
/// OutPut:     出参：ICD诊断描述
/// Return:		成功 1,失败 -1^失败描述
/// Debug:     	s objRes = ##class(%GlobalBinaryStream).%New()
/// 	     	s obj = ##Class(EMR.OP.HISInterface.LinkSrv).getDiag("715","",.objRes)
/// Others:       
ClassMethod GetDiag(AEpisodeID As %String, ICDType As %String = "", ByRef argOutData As %GlobalBinaryStream = "") As %String
{
	s $zt = "Error"
	s strRes = "1"
	q:(AEpisodeID="") "-1^就诊号不能为空"
	s i = 0
	//换行符号
	s liner = "@"
	//下标的替换符号（需要展示下标内容，前增加&~sub）
	s sub="&~sub"
	//上标的替换符号（需要展示下标内容，前增加&~sup）
	s sup="&~sup"
	//下标、上标内容结束符号(上下标内容结束增加&~)
	s suend = "&~"
	s ret = ""
	// 根据诊断级别，设置诊断前的空格
	s diagLeavelPreFix = " "
	s jsonArr = ##class(%DynamicArray).%New()
	s MRAdmRowid=$p($g(^PAADM(AEpisodeID)),"^",61)
	
	;d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.Service","DiagnosList","1117")
	Set obj=##class(%ResultSet).%New("DHCDoc.Interface.Inside.Service:DiagnosList")
	d obj.Execute(MRAdmRowid,ICDType)
	while obj.%Next()
	{
		s diagDesc = obj.Data("DiagnosDesc")
		s diagValue = obj.Data("DiagnosValue")
		s diagCodeRowId = obj.Data("DiagnosCodeRowid")
		s diagMRDesc = obj.Data("DiagnosMRDesc")
		s diagStatus = obj.Data("DiagStat")
		s diagLeavel = obj.Data("DiagnosLeavel")
		s diagPrefix = $g(obj.Data("DiagnosPrefix"))
		//s:(diagMRDesc '= "") diagMRDesc = $LIST(diagMRDesc,1)
		s i = i + 1
		//s diagDesc = i_"."_diagDesc
		//诊断和备注都不为空，增加（）
		s:($tr(diagDesc,"&nbsp","") '= "")&&(diagMRDesc'="") diagMRDesc = "("_diagMRDesc_")"
		//将&nbsp替换为空格
		s:(diagDesc["&nbsp") diagDesc= $tr(diagDesc,"&nbsp",diagLeavelPreFix)
		//diagStatus不为空，且不为确诊，增加（）
		s status = ""
		s:((diagStatus '= "") && (diagStatus '= "确诊")) status = "("_diagStatus_")"
		//s:((diagStatus '= "") && (diagStatus [ "确诊")) status = " ("_diagStatus_")"
		//s:(diagLeavel '= "") diagnosePrefix = ..SetDiagnosLeavel(diagLeavel)
		
		s strItem = diagPrefix_diagDesc_diagMRDesc_status
		
		s ret = $case(ret,"":strItem,:ret_liner_strItem)
	}
	d obj.Close()
	//将字符转换为JSON数据
	s jsonArr = ##Class(EMR.OP.HISInterface.LinkSrv).SetJsonData(ret,liner,"false")
	d jsonArr.%ToJSON(argOutData)
	q strRes
Error
	q "-1^"_$zerror
}

/// Desc:       获取本次就诊医嘱记录
/// Creator:    yejian
/// CreateDate: 2022-8-18
/// Input:      AEpisodeID 是就诊号
/// OutPut:     出参：医嘱名称 X 数量 数量单位 
///                   用法：剂量 剂量单位 频次 用法 疗程 医嘱项目备注
/// Return:		成功 1,失败 -1^失败描述
/// Debug:     	s objRes = ##class(%GlobalBinaryStream).%New()
/// 			s obj = ##Class(EMR.OP.HISInterface.LinkSrv).GetOeord("715",.objRes)
ClassMethod GetOeord(AEpisodeID As %String, ByRef argOutData As %GlobalBinaryStream = "") As %String
{
	s $zt = "Error"
	s strRes = "1"
	q:(AEpisodeID="") "-1^就诊号不能为空"
	//换行符号
	s liner = "@"
	//下标的替换符号（需要展示下标内容，前增加&~sub）
	s sub="&~sub"
	//上标的替换符号（需要展示上标内容，前增加&~sup）
	s sup="&~sup"
	//下标、上标内容结束符号(上下标内容结束增加&~)
	s suend = "&~"
	s ret = ""
	s jsonArr = ##class(%DynamicArray).%New()
	;d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.Service","FindEMROPItems","1117","","SaveOrder")
	s rset = ##Class(%ResultSet).%New("DHCDoc.Interface.Inside.Service:FindEMROPItems")
	s sc = rset.Execute(AEpisodeID,"","SaveOrder")
	s pascData = ""
	s lisData = ""
	s medData = ""
	s ortherData = "" //其他

	Set columns = rset.GetColumnCount()
	While rset.Next() 
	{
		s TypeClass = rset.Get("TypeClass")
		s OrderName = rset.OrderName
		s OrderFreq = rset.Get("OrderFreq")
		s OrderSeqNo= rset.Get("OrderSeqNo")
		s OrderDepProcNote = rset.Get("OrderDepProcNote")
		s OrderPackQty = rset.Get("OrderPackQty")
		s OrderDur = rset.Get("OrderDur")
		s OrderPackUOM = rset.Get("OrderPackUOM")
		if ("检查"=TypeClass) 
		{ 	
			s pascData= $case(pascData,"":" "_OrderName,:pascData_"^^ "_OrderName)		
		} 
		elseif ("检验"=TypeClass)
		{
			s lisData= $case(lisData,"":" "_OrderName,:lisData_"^^ "_OrderName)				
		} 
		elseif ("西药"=TypeClass) 
		{  
			// 特殊处理子医嘱	
			s drugInfo = " "_OrderName 
			s:(OrderSeqNo[".") drugInfo="@."_$P(OrderSeqNo,".",2)_" "_OrderName
			s drugInfo = drugInfo_" X "_OrderPackQty_OrderPackUOM
			s drugInfo = drugInfo_"#   用法："
			//用法显示为下标
			;s drugInfo = drugInfo_sub
			s drugInfo = drugInfo_"每次"_rset.Get("OrderDoseQty")_rset.Get("OrderDoseUOM")
			s drugInfo = drugInfo_"  "_..convertOrderFreq(OrderFreq)
			//OrderInstr 用法 OrderDur 疗程
			s drugInfo = drugInfo_"  "_rset.Get("OrderInstr")_"  "_OrderDur
			//OrderDepProcNote 备注
			s:(rset.Get("OrderDepProcNote") '= "") drugInfo = drugInfo_"  "_OrderDepProcNote
			//用法显示为下标
			;s drugInfo = drugInfo_suend
			s medData= $case(medData,"":drugInfo,:medData_"^^"_drugInfo)		 	 
		}
		elseif ("其他"=TypeClass) 
		{
			//医嘱名称 频次 疗程 数量 单位 备注
			s oeord = ..FilterIlleaglChar(OrderName)
            s:(OrderSeqNo[".") oeord = "@."_$P(OrderSeqNo,".",2)_" "_oeord
			s:(OrderFreq '= "") oeord = oeord_"  "_..convertOrderFreq($ZCVT(OrderFreq,"U"))
			s:(OrderDur '= "") oeord = oeord_"  "_OrderDur
			s oeord = oeord_"  "_OrderPackQty_OrderPackUOM
			s:(OrderDepProcNote '= "") oeord = oeord_"  "_OrderDepProcNote
			s ortherData= $case(ortherData,"":oeord,:ortherData_"^^"_oeord)			
		}
	}

	s idx=0
	if (""'=pascData) {
		s count = $Length(pascData,"^^")
		for I = 1:1:count {
			s idx=idx+1
			s strItem=idx_"."_$p(pascData,"^^",I)
			s ret = $case(ret,"":strItem,:ret_liner_strItem)
		}
	}
	if (""'=lisData) {
		s count = $Length(lisData,"^^")
		for I = 1:1:count {
			s idx=idx+1
			s strItem=idx_"."_$p(lisData,"^^",I)
			s ret = $case(ret,"":strItem,:ret_liner_strItem)
		}
	}
	
	if (""'=medData) {
		s count = $Length(medData,"^^")
		for I = 1:1:count {
			s idx=idx+1
			s strItem=$p(medData,"^^",I)
			if (strItem["@") {
				s ret = ret_liner_$replace(strItem,"@",idx)
			} else {
				s strItem = idx_"."_strItem
				s ret = $case(ret,"":strItem,:ret_liner_strItem)
			}
		}	
	}
	if (""'=ortherData) {
		s count = $Length(ortherData,"^^")
		for I = 1:1:count {
			s idx=idx+1
			s strItem=$p(ortherData,"^^",I)
			if (strItem["@") {
				s ret = ret_liner_$replace(strItem,"@",idx)
			} else {
				s strItem = idx_"."_strItem
				s ret = $case(ret,"":strItem,:ret_liner_strItem)
			}
        }
    }
	s flag = ##class(DHCDoc.Interface.Inside.Service).CheckOrdIsExist(AEpisodeID, "CHMED")
	s:(flag = 1)&&(ret '= "") ret = ret_liner
	d rset.Close()
	
	if (ret["#")
	{
		s ret = $replace(ret,"#",liner)
	}
	//将字符转换为JSON数据
	s jsonArr = ##Class(EMR.OP.HISInterface.LinkSrv).SetJsonData(ret,liner,"false")
    d jsonArr.%ToJSON(argOutData)
	
	q strRes
Error
	q "-1^"_$zerror
}

/// Desc:       获取本次就诊医嘱(中草药)记录
/// Creator:    yejian
/// CreateDate: 2022-8-18
/// Input:      AEpisodeID 是就诊号
/// OutPut:     出参：医嘱名称 X 数量 数量单位 
///                   用法：剂量 剂量单位 频次 用法 疗程 医嘱项目备注
/// Return:		成功 1,失败 -1^失败描述
/// Debug:     	s objRes = ##class(%GlobalBinaryStream).%New()
/// 			s obj = ##Class(EMR.OP.HISInterface.LinkSrv).GetOeordCN("715",.objRes)
ClassMethod GetOeordCN(AEpisodeID, ByRef argOutData As %GlobalBinaryStream = "") As %String
{
	s $zt = "Error"
	s strRes = "1"
	q:(AEpisodeID="") "-1^就诊号不能为空"
	s liner = "@"
	//下标的替换符号（需要展示下标内容，前增加&~sub）
	s sub="&~sub"
	//上标的替换符号（需要展示下标内容，前增加&~sup）
	s sup="&~sup"
	//下标、上标内容结束符号(上下标内容结束增加&~)
	s suend = "&~"
	s ret = ""
	s jsonArr = ##class(%DynamicArray).%New()
	
	;d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.Service","FindEMROPItems","1117","CHMED","SaveOrder")
	s chmedData = ..SortChmedData(AEpisodeID,"CHMED")
	q:(chmedData = "") strRes
	for i = 1:1:$L(chmedData,"^^^")
	{
		s:(ret '="") ret = ret_liner
		s chmedDataResult = $P($P(chmedData,"^^^",i),"!",2)
		for j = 1:1:$L(chmedDataResult,"@")
		{
			if (ret="") 
			{
				s ret = $P(chmedDataResult,"@",j)
			}
			else 
			{
				if (j-1#4=0) 
				{
					s:(j = 1) ret = ret_$P(chmedDataResult,"@",j)
					s:(j '=1) ret = ret_liner_$P(chmedDataResult,"@",j)
				}
				else 
				{
					s ret = ret_"    "_$P(chmedDataResult,"@",j)
				}
			}
		}
		s ret = ret_liner_$P($P(chmedData,"^^^",i),"!",1)
	}
	s flag = ##class(DHCDoc.Interface.Inside.Service).CheckOrdIsExist(AEpisodeID, "")
	s:(flag = 1)&&(ret '= "") ret = liner_ret
	s:(ret["#") ret = $replace(ret,"#",liner)

	//将字符转换为JSON数据
	s jsonArr = ##Class(EMR.OP.HISInterface.LinkSrv).SetJsonData(ret,liner,"true")
    d jsonArr.%ToJSON(argOutData)
	
	q strRes
Error
	q "-1^"_$zerror
}

/// Desc:       获取该患者所有过敏记录
/// Creator:    yejian
/// CreateDate: 2022-8-18
/// Input:      AEpisodeID 是就诊号
/// 			AQueryAllergiesList过滤需要展示的过敏记录ID串（为空时展示所有）
/// OutPut:     出参：过敏记录
/// Return:		成功 1,失败 -1^失败描述
/// Debug:     	s objRes = ##class(%GlobalBinaryStream).%New()
/// 			s obj = ##Class(EMR.OP.HISInterface.LinkSrv).GetAllergic("715","",.objRes)
/// Others:     
ClassMethod GetAllergic(AEpisodeID As %String, AQueryAllergiesList As %String = "", ByRef argOutData As %GlobalBinaryStream = "") As %String
{
	s $zt = "Error"
	s strRes = "1"
	q:(AEpisodeID="") "-1^就诊号不能为空"
	s patientID=$P(^PAADM(AEpisodeID),"^",1)
	q:(patientID = "") "-1^住院号获取失败"
	s i = 0
	s liner = "@"
	//下标的替换符号（需要展示下标内容，前增加&~sub）
	s sub="&~sub"
	//上标的替换符号（需要展示下标内容，前增加&~sup）
	s sup="&~sup"
	//下标、上标内容结束符号(上下标内容结束增加&~)
	s suend = "&~"
	s ret = ""
	;d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.Service","Allergies","1117","")
	Set obj=##class(%ResultSet).%New("DHCDoc.Interface.Inside.Service:Allergies")
	d obj.Execute(patientID,AQueryAllergiesList)
	while obj.%Next()
	{
		//过敏源
		s allergen = obj.Data("Allergen")
		//过敏项目
		s aLGItem = obj.Data("ALGItem")
		//注释
		s comments = obj.Data("Comments")
		
		//实现换行
		s:(i'=0) ret = ret_liner
		s i = i + 1
		
		s:(allergen'="") ret = ret_allergen_"过敏"
		s:(aLGItem'="")&&(allergen'="") ret = ret_","_aLGItem
		s:(aLGItem'="")&&(allergen="") ret = ret_aLGItem
		s:(comments'="") ret = ret_"("_comments_")"
		
	}
	d obj.Close()
	s:(ret="") ret = "否认药物或食物过敏史"
	//将字符转换为JSON数据
	s jsonArr = ##Class(EMR.OP.HISInterface.LinkSrv).SetJsonData(ret,liner,"false")
    d jsonArr.%ToJSON(argOutData)
	q strRes
Error
	q "-1^"_$zerror
}

ClassMethod convertOrderFreq(OrderFreq As %String) As %String
{
	q:("ONCE"=$zcvt(OrderFreq,"U")) "一次"
	q:("BID"=$zcvt(OrderFreq,"U")) "每日两次"
	q:("TID"=$zcvt(OrderFreq,"U")) "每日三次"
	q:("QD"=$zcvt(OrderFreq,"U")) "每日一次"
	q:("QOD"=$zcvt(OrderFreq,"U")) "隔日一次"
	q:("TIDAC"=$zcvt(OrderFreq,"U")) "每日三次,餐前服用"
	q OrderFreq
}

ClassMethod FilterIlleaglChar(txt As %String) As %String
{
	s txt = $tr(txt,$c(10),"")
	s txt = $tr(txt,$c(13),"")
	q txt
}

///  d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.Service","FindEMROPItems","23085959","CHMED","")
///  w ##Class(EMR.OP.HISInterface.LinkSrv).SortChmedData("23085959","CHMED")
ClassMethod SortChmedData(AEpisodeID, CHMEDFlag As %String = "") As %String
{
	s rset = ##Class(%ResultSet).%New("DHCDoc.Interface.Inside.Service:FindEMROPItems")
	s sc = rset.Execute(AEpisodeID,CHMEDFlag,"SaveOrder")
	if (CHMEDFlag = "CHMED") {
		s idx=0
		s TOrderPrescNo = ""
		s CHMEDNotes = ""
		s Result = ""
		while rset.%Next() 
		{ 	
			i (TOrderPrescNo '= rset.Data("OrderPrescNo"))
			{
				s CHMEDNotes = ..ReplaceEnterChar(rset.Data("CHMEDNotes")) //备注
				s TOrderPrescNo = rset.Data("OrderPrescNo")
				s:(Result '="") Result = Result_"^^^"
				s Result = Result_ CHMEDNotes_"!"_..ReplaceEnterChar($replace(rset.Data("OrderName")," ","")_""_rset.Data("OrderDoseQty")_rset.Data("OrderDoseUOM"))
			}
			else 
			{	
				s Result = Result_"@"_..ReplaceEnterChar($replace(rset.Data("OrderName")," ","")_""_rset.Data("OrderDoseQty")_rset.Data("OrderDoseUOM"))
			}
		}
	}
	d rset.Close()
	q Result
}

/// Desc:	替换掉json串中的回车换行符号
ClassMethod ReplaceEnterChar(inputStr As %String) As %String
{
	s fromStr = $c(13)
	s toStr = "\r\n"
	set count = $Length(inputStr, fromStr)
    quit:(count <= 1) inputStr
    
    set outStr = $p(inputStr,fromStr,1)
	for i = 2:1:count
	{
		set outStr = outStr_toStr_$p(inputStr,fromStr,i)
	}
	
	q outStr
}

/// Desc:       将字符转换为JSON数据
/// Creator:    yejian
/// CreateDate: 2022-8-18
/// Input:      aDatas 字符
/// 			aliner 换行符
/// 			aFlinefeed 第一行是否换行显示(是 true,否 false)
/// OutPut:     
/// Return:		json对象
/// Debug:		s strData = "1. 十二导心电图检查@2. 甲状腺及颈部淋巴结超声@3. 骨密度测定@4. 血常规@5. 瑞格列奈片(孚来迪)[0.5mg*30] X 1@   用法：每次0.5mg  每日3次  口服  1天@6.挂号费  1次@"
/// 			w ##Class(EMR.OP.HISInterface.LinkSrv).SetJsonData(strData,"@","false")
ClassMethod SetJsonData(aDatas As %String, aliner As %String, aFlinefeed As %String) As %DynamicArray
{
	s jsonArr=##class(%DynamicArray).%New()
	s intCount =$l(aDatas,aliner)
	for i = 1:1:intCount {
        s strItem=$p(aDatas,aliner,i)
        continue:(strItem="")
        s linefeed = $case(i,"1":aFlinefeed,:"true")
        //   用法：&~sub每次0.5mg&~  &~sup每日3次  口服  1天&~
        //包含上下标处理
       	if (strItem [ "&~")
       	{
	       	s suCount = $l(strItem,"&~")
	       	for j = 1:1:suCount {
		       	s strSuItem = $p(strItem,"&~",j)
		       	s strbid =""
		       	//处理下标
		       	if (strSuItem["sub")
		       	{
			       	s strbid="sub"
			       	s strSuItem = $tr(strSuItem,"sub","")
		       	}
		       	//处理上标
		       	if (strSuItem["sup")
		       	{
			       	s strbid="sup"
			       	s strSuItem = $tr(strSuItem,"sup","")
		       	}
		       	continue:(strSuItem="")
				s jsonItem = ##class(%DynamicObject).%New()
				s jsonItem.text = strSuItem
				s:(strbid="sub") jsonItem.sub = "true"
				s:(strbid="sup") jsonItem.sup = "true"
				d jsonArr.%Push(jsonItem)
	       	}
	       	//结束后增加换行标识
	       	s jsonItem = ##class(%DynamicObject).%New()
			s jsonItem.text = ""
			s jsonItem.linefeed = linefeed
			d jsonArr.%Push(jsonItem)
       	}
       	else
       	{
			s jsonItem = ##class(%DynamicObject).%New()
			s jsonItem.text = strItem
			s jsonItem.linefeed = linefeed
			d jsonArr.%Push(jsonItem)
       	}
    }
   q jsonArr
}

}
