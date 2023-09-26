/// 查询打散数据项
Class EPRservice.BOScatterData Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "ScatterDataInfo";

/// Desc: [对外接口]取电子病历唯一模板打散数据
ClassMethod GetEPRData(aEpisodeID As %String, aItemPara As %String) As %String [ WebMethod ]
{
	//debug
	//b "s"
	
	quit:($d(aEpisodeID)=0)||(aEpisodeID="")||($d(aItemPara)=0)||(aItemPara="") ""
	set retVal = ""
	
	set desc = $p(aItemPara,"#",1)
	set type = $p($p(aItemPara,"#",2),":",2)
	set tid = $p($p(aItemPara,"#",3),":",2)
	
	if (type = "Simple")
	{
		set scode = $p($p(aItemPara,"#",5),":",2)
		set vtype = $p($p(aItemPara,"#",6),":",2)
		set retVal = ..GetScatterData(aEpisodeID, tid, scode, vtype)
		if retVal = "Null"
		{	set retVal = ""}
	}
	elseif (type = "Segment")||(type = "TextDesc")
	{
		set scode = $p($p(aItemPara,"#",5),":",2)
		set retVal = ..GetScatterData(aEpisodeID, tid, scode, "")
		if retVal = "Null"
		{	set retVal = ""}
	} 
	elseif (type = "SegmentSimple")
	{
		set tcode = $p($p(aItemPara,"#",5),":",2)
		set scode = $p($p(aItemPara,"#",6),":",2)
		set vtype = $p($p(aItemPara,"#",7),":",2)
		set itemcode = tcode_"."_scode
		set retVal = ..GetScatterData(aEpisodeID, tid, itemcode, vtype)
		if retVal = "Null"
		{	set retVal = ""}
	}
	elseif (type = "TextDescSimple")
	{
		set tcode = $p($p(aItemPara,"#",5),":",2)
		set scode = $p($p(aItemPara,"#",6),":",2)
		set vtype = $p($p(aItemPara,"#",7),":",2)
		set kbnodeid =  $p($p(aItemPara,"#",8),":",2)
		set kbpartno =  $p($p(aItemPara,"#",9),":",2)
		set itemcode = tcode_"."_scode_"."_kbnodeid_"."_kbpartno
		set retVal = ..GetScatterData(aEpisodeID, tid, itemcode, vtype)
		if retVal = "Null"
		{	set retVal = ""}
	}
	elseif (type = "Table")
	{
		set tcode = $p($p(aItemPara,"#",5),":",2)
		set scode = $p($p(aItemPara,"#",6),":",2)
		set vtype = $p(aItemPara,"#",7)
		if ($e(vtype,1,5) '= "VTYPE")
		{
			set vtype = $p(aItemPara,"#",8)
		}
		set vtype = $p(vtype,":",2)
		set itemcode = tcode_"."_scode
		set retVal = ..GetScatterData(aEpisodeID, tid, itemcode, vtype)
		if retVal = "Null"
		{	set retVal = ""}
	}
	elseif (type = "Glossary")
	{
		set retVal = ..GetScatterDataByGlossaryID(aEpisodeID, tid)
	}
	
	quit retVal
}

/// Desc: [对外接口]取电子病历可重复模板打散数据
/// Debug：w ##class(EPRservice.BOScatterData).GetEPRMultipleData("65","录#TYPE:TextDesc#TID:352#TVER:0#ECODE:E0001","24||2")
ClassMethod GetEPRMultipleData(aEpisodeID As %String, aItemPara As %String, aInstanceID As %String) As %String [ WebMethod ]
{
	//debug
	//b "s"
	
	quit:(($d(aEpisodeID)=0)||(aEpisodeID="")||($d(aItemPara)=0)||(aItemPara="")||($d(aInstanceID)=0)||(aInstanceID="")) ""
	set retVal = ""
	
	set desc = $p(aItemPara,"#",1)
	set type = $p($p(aItemPara,"#",2),":",2)
	set tid = $p($p(aItemPara,"#",3),":",2)
	
	if (type = "Simple")
	{
		set scode = $p($p(aItemPara,"#",5),":",2)
		set vtype = $p($p(aItemPara,"#",6),":",2)
		set retVal = ..GetMultipleScatterData(aEpisodeID, tid, scode, aInstanceID, vtype)
		if retVal = "Null"
		{	set retVal = ""}
	}
	elseif (type = "Segment")||(type = "TextDesc")
	{
		set scode = $p($p(aItemPara,"#",5),":",2)
		set retVal = ..GetMultipleScatterData(aEpisodeID, tid, scode, aInstanceID, "")
		if retVal = "Null"
		{	set retVal = ""}
	} 
	elseif (type = "SegmentSimple")
	{
		set tcode = $p($p(aItemPara,"#",5),":",2)
		set scode = $p($p(aItemPara,"#",6),":",2)
		set vtype = $p($p(aItemPara,"#",7),":",2)
		set itemcode = tcode_"."_scode
		set retVal = ..GetMultipleScatterData(aEpisodeID, tid, itemcode, aInstanceID, vtype)
		if retVal = "Null"
		{	set retVal = ""}
	}
	elseif (type = "TextDescSimple")
	{
		set tcode = $p($p(aItemPara,"#",5),":",2)
		set scode = $p($p(aItemPara,"#",6),":",2)
		set vtype = $p($p(aItemPara,"#",7),":",2)
		set kbnodeid =  $p($p(aItemPara,"#",8),":",2)
		set kbpartno =  $p($p(aItemPara,"#",9),":",2)
		set itemcode = tcode_"."_scode_"."_kbnodeid_"."_kbpartno
		set retVal = ..GetMultipleScatterData(aEpisodeID, tid, itemcode, aInstanceID, vtype)
		if retVal = "Null"
		{	set retVal = ""}
	}
	elseif (type = "Table")
	{
		set tcode = $p($p(aItemPara,"#",5),":",2)
		set scode = $p($p(aItemPara,"#",6),":",2)
		set vtype = $p(aItemPara,"#",7)
		if ($e(vtype,1,5) '= "VTYPE")
		{
			set vtype = $p(aItemPara,"#",8)
		}
		set vtype = $p(vtype,":",2)
		set itemcode = tcode_"."_scode
		set retVal = ..GetMultipleScatterData(aEpisodeID, tid, itemcode, aInstanceID, vtype)
		if retVal = "Null"
		{	set retVal = ""}
	}
	quit retVal
}

/// Desc:[对外接口]取电子病历打散数据集合
ClassMethod GetEPRDataList(aEpisodeID As %String, aItemPara As %String) As %ResultSet
{
	quit:($d(aEpisodeID)=0)||(aEpisodeID="")||($d(aItemPara)=0)||(aItemPara="") ""
	set retVal = ""
	
	set desc = $p(aItemPara,"#",1)
	set type = $p($p(aItemPara,"#",2),":",2)
	set tid = $p($p(aItemPara,"#",3),":",2)
	
	if (type = "Simple")
	{
		set scode = $p($p(aItemPara,"#",5),":",2)
		set vtype = $p($p(aItemPara,"#",6),":",2)
		q ..GetScatterDataList(aEpisodeID, tid, scode, vtype)
	}
	elseif (type = "Segment")||(type = "TextDesc")
	{
		set scode = $p($p(aItemPara,"#",5),":",2)
		q ..GetScatterDataList(aEpisodeID, tid, scode, "")
	} 
	elseif (type = "SegmentSimple")
	{
		set tcode = $p($p(aItemPara,"#",5),":",2)
		set scode = $p($p(aItemPara,"#",6),":",2)
		set vtype = $p($p(aItemPara,"#",7),":",2)
		set itemcode = tcode_"."_scode
		q ..GetScatterDataList(aEpisodeID, tid, itemcode, vtype)
	}
	elseif (type = "TextDescSimple")
	{
		set tcode = $p($p(aItemPara,"#",5),":",2)
		set scode = $p($p(aItemPara,"#",6),":",2)
		set vtype = $p($p(aItemPara,"#",7),":",2)
		set kbnodeid =  $p($p(aItemPara,"#",8),":",2)
		set kbpartno =  $p($p(aItemPara,"#",9),":",2)
		set itemcode = tcode_"."_scode_"."_kbnodeid_"."_kbpartno
		q ..GetScatterDataList(aEpisodeID, tid, itemcode, vtype)
	}
	elseif (type = "Glossary")
	{
		//do nothing，暂不支持术语集
	}
	
	quit ""
}

/// Desc: 	使用术语集取电子病历打散数据
/// Return:	metaItemInfo$|value&|metaItemInfo$|value
/// Debug: 	w ##class(EPRservice.BOScatterData).GetScatterDataByGlossaryID("201871","20")
ClassMethod GetScatterDataByGlossaryID(AEpisodeID As %String, AGlossaryID As %String) As %String
{
	s ret = ""
	q:($d(AEpisodeID) = 0)||(AEpisodeID = "") ret
	q:($d(AGlossaryID) = 0)||(AGlossaryID = "") ret
	
	s objGlossary = ##Class(EPRmeta.Glossary).%OpenId(AGlossaryID)
	q:(objGlossary = "") ret
	
	s name = objGlossary.Name
	s type = objGlossary.GlossaryType
	
	if ($zcvt(type,"U") = "TG")
	{
		s rowID = ""
		for {
			s rowID = $o(^DHCEPRM.GlossaryItemI("IdxGlossaryID",AGlossaryID,rowID))
			q:(rowID = "")
			
			s objItem = ##Class(EPRmeta.GlossaryItem).%OpenId(rowID)
			
			s itemCode = objItem.ItemCode
			s valueType = objItem.ValueType
			s templateID = objItem.TemplateID
			s TemType = objItem.TemType
			if (TemType="GROUP")
			{

				s seq=""
				for 
				{
					s seq=$o(^DHCEPRM.GloTemplateItmGrpI("IdxGroupCodeSeq"," "_itemCode,seq))
					
					q:(seq="")
					s tmpid=""
					for 
					{
						s tmpid=$o(^DHCEPRM.GloTemplateItmGrpI("IdxGroupCodeSeq"," "_itemCode,seq,tmpid))
						q:(tmpid="")
						s objGloTmpGrp=##class(EPRmeta.GlossaryTemplateItemGroup).%OpenId(tmpid)
						s tmpType=objGloTmpGrp.Type
						s tmpValue=objGloTmpGrp.Value
						if (tmpType="Txt")
						{
							s:((tmpValue'="")&&(ret="Null")) ret=""
							s ret=ret_tmpValue
						}
						else 
						{
							s strResult = ..GetScatterData(AEpisodeID,templateID,tmpValue,valueType)
							s:(strResult="Null") strResult=""
							s ret=ret_strResult
						}	
					}
				}
			}
			else
			{
				s ret = ..GetScatterData(AEpisodeID,templateID,itemCode,valueType)
			}
			q:(ret '= "")&&(ret '= "Null")
		}	
	}
	else
	{
		s parGlossaryID = objGlossary.ParentID
		q:(parGlossaryID = "") ret

		s objParGlossary = ##Class(EPRmeta.Glossary).%OpenId(parGlossaryID)
		q:(objParGlossary = "") ret
		
		s parRowID = ""
		for {
			s parRowID = $o(^DHCEPRM.GlossaryItemI("IdxGlossaryID",parGlossaryID,parRowID))
			q:(parRowID = "")
			
			s objParItem = ##Class(EPRmeta.GlossaryItem).%OpenId(parRowID)
			
			s parItemCode = objParItem.ItemCode
			s parValueType = objParItem.ValueType
			s parTemplateID = objParItem.TemplateID

			s parItemValue = ..GetScatterData(AEpisodeID,parTemplateID,parItemCode,parValueType)
			if (parItemValue '= "")
			{
				s instanceDataID = $o(^DHCEPRI.ITextDescI("IdxForLink"," "_AEpisodeID," "_parTemplateID," "_parItemCode,""))
				s instanceDataID = $tr(instanceDataID," ","")
				q:(instanceDataID = "")

				s kbNodeID = ""
				for {
					s kbNodeID = $o(^DHCEPRI.ITextDescSimpleI("IdxForUpdate"," "_instanceDataID," "_parItemCode,kbNodeID))
					q:(kbNodeID = "")

					s kbPartNo = ""
					for {
						s kbPartNo = $o(^DHCEPRI.ITextDescSimpleI("IdxForUpdate"," "_instanceDataID," "_parItemCode,kbNodeID,kbPartNo))
						q:(kbPartNo = "")

						s curItemCode = ""
						for {
							s curItemCode = $o(^DHCEPRI.ITextDescSimpleI("IdxForUpdate"," "_instanceDataID," "_parItemCode,kbNodeID,kbPartNo,curItemCode))
							q:(curItemCode = "")

							s curValueType = $o(^DHCEPRM.GlossaryKBItemI("IdxComposite",AGlossaryID,$tr(kbNodeID," ",""),$tr(kbPartNo," ",""),curItemCode,""))
							if (curValueType '= "")
							{
								s curTextSimpleRowID = ..GetITextDescSimpleId(AEpisodeID, parTemplateID, parItemCode, $tr(curItemCode," ",""), $tr(kbNodeID," ",""),$tr(kbPartNo," ",""))
								q:(curTextSimpleRowID = "")

								s curItemType = $e($tr(curItemCode," ",""),0,1)
								s curTextSimpleValue = ..GetITextDescSimpleValue(curTextSimpleRowID,curItemType,$tr(curValueType," ",""))
								if (curTextSimpleValue '= "")
								{
									s ret = curTextSimpleValue
									q	
								}
							}
							else
							{
								continue	
							}	
						}	
					}	
				}	
			}	
		}
	}
	
	s:(ret="Null") ret = ""
	q ret
}

/// 根据原数据编码规则到不同的打散结构里去取数据。
/// 返回值：若未保存过，返回Nulll; 若已保存过，返回rowId^DataValue
///         对于TableSimpleItem，若有多行，返回 rowId1^DataValue1#rowId2^DataValue2
/// 参数：aEpisodeID 就诊号；
/// 	  aTemplateID 模板ID; 
///  	  aSampleItemCode 单元code;   
///  	  				  若为G单元或T单元的内嵌单元, 形式为 parentItemCode.subItemCode, 如 E0001.S0009
/// 					  若为E单元的内嵌单元,形式可为parentItemCode.subItemCode 或者 parentItemCode.subItemCode.KBNodeId.KBPartNo
/// 					  若为其他单元, 形式为 ItemCode,  如 S0009 或 E0099 或 G0087  等等.
/// 	  aValueType 取值类型, 若不填或为空值, 默认为 V ;
/// 	  			 V 取描述, C 取code					  
ClassMethod GetScatterData(aEpisodeID As %String, aTemplateID As %String, aSampleItemCode As %String, aValueType As %String = "V") As %String
{
	
	quit:($d(aEpisodeID)=0)||($d(aTemplateID)=0)||($d(aSampleItemCode)=0)||(aEpisodeID="")||(aTemplateID="")||(aSampleItemCode="") "Null"
	
	/// 取值类型为空时，默认为取 "值"
	/// 将取值类型转化为大写
	if (aValueType="") 
	{	set aValueType="V"}
	else
	{
		set aValueType=$zcvt(aValueType,"U")
	}
	
	/// 初始化返回值
	s outStr="Null"
	s itemId=""
	
	///若为G单元、E单元或T单元的内嵌单元
	if aSampleItemCode["."  
	{
		s ParentCode=$p(aSampleItemCode,".",1)
		///s SubItemCode=$p(aSampleItemCode,".",2)
		s SubItemCode=$e(aSampleItemCode,$f(aSampleItemCode,"."),$l(aSampleItemCode))
		s SubItemType=$e(SubItemCode,0,1)
		if $e(ParentCode,0,1)="G"
		{
			s itemId = ..GetISegmentSimpleId(aEpisodeID,aTemplateID,ParentCode,SubItemCode)
			q:itemId="" outStr
			s value = ..GetISegmentSimpleValue(itemId,SubItemType,aValueType)
			
			s outStr = value
			
		}
		elseif $e(ParentCode,0,1)="E"
		{	
			if ($l(SubItemCode,".") = 1)
			{
				s itemId = ..GetITextDescSimpleId(aEpisodeID,aTemplateID,ParentCode,SubItemCode)
			}
			elseif ($l(SubItemCode,".") = 3)
			{
				s itemId = ..GetITextDescSimpleId(aEpisodeID,aTemplateID,ParentCode,$p(SubItemCode,".",1),$p(SubItemCode,".",2),$p(SubItemCode,".",3))
			}
			q:itemId="" outStr
			s value = ..GetITextDescSimpleValue(itemId,SubItemType,aValueType)
			
			s outStr = value
		}
		elseif $e(ParentCode,0,1)="T"
		{
			//b "s"
			s itemId = ..GetITableSimpleId(aEpisodeID,aTemplateID,ParentCode,SubItemCode)
			q:itemId="" outStr
			s count=$length(itemId,"|")
			for I=1:1:count
			{
				s tmpItemId=$p($P(itemId,"|",I),"^",2)
				s value = ..GetITableSimpleValue(tmpItemId,SubItemType,aValueType)
				
				/*
				if (value '= Null) && (value '= "")
				{
					if outStr="Null"
					{	s outStr = value}
					else
					{	s outStr=outStr_"#"_value}
				}
				*/
				if (I = 1)
				{	s outStr = value}
				else
				{	s outStr=outStr_$C(2)_value}
			}
		}

	}
	///若为非内嵌单元
	elseif aSampleItemCode'["." 
	{
		s itemType = $e(aSampleItemCode,0,1)
		if $e(aSampleItemCode,0,1)="G"
		{
			s itemId = ..GetISegmentId(aEpisodeID,aTemplateID,aSampleItemCode)
			s itemValue = ..GetISegmentValue(itemId)
			if itemId '=""
			{
				s outStr = itemValue
			}
		}
		elseif $e(aSampleItemCode,0,1)="E"
		{
			s itemId = ..GetITextDescId(aEpisodeID,aTemplateID,aSampleItemCode)
			s itemValue = ..GetITextDescValue(itemId)
			if itemId'=""
			{
				s outStr = itemValue
			}
		}
		elseif $e(aSampleItemCode,0,1)="Y"
		{	
			/// do nothing
		}
		else
		{	
			s itemId = ..GetISimpleId(aEpisodeID,aTemplateID,aSampleItemCode)
			q:itemId="" outStr
			s value = ..GetISimpleValue(itemId,itemType,aValueType)
			if itemId '=""
			{
				s outStr=value
			}
		}
	}
	
	//转换 &EnterKey;
	set count = $Length(outStr, "&KeyEnter;")
    if count > 1
    {
	    set tmpRetVal = ""
		for I = 1:1:count
		{
			set tmpRetVal = tmpRetVal_$p(outStr,"&KeyEnter;",I)_$c(13) 
		}
		set outStr = $extract(tmpRetVal,1,$Length(tmpRetVal)-1)
    }
	//转换 &nbsp;
	set count = $Length(outStr, "&nbsp;")
	if count > 1
	{
		set tmpRetVal=""
		for I = 1:1:count
		{
			set tmpRetVal = tmpRetVal_$p(outStr,"&nbsp;",I)_$c(32)
		}
		set outStr = $extract(tmpRetVal,1,$Length(tmpRetVal)-1)
	}
	
	q outStr
}

/// 取可重复模板的打散数据
ClassMethod GetMultipleScatterData(aEpisodeID As %String, aTemplateID As %String, aSampleItemCode As %String, aInstanceID As %String, aValueType As %String = "V") As %String
{
	//b "s"
	
	quit:(($d(aEpisodeID)=0)||($d(aTemplateID)=0)||($d(aSampleItemCode)=0)||(aEpisodeID="")||(aTemplateID="")||(aSampleItemCode="")||($d(aInstanceID)=0)||(aInstanceID="")) "Null"
	
	/// 取值类型为空时，默认为取 "值"
	/// 将取值类型转化为大写
	if (aValueType="") 
	{	set aValueType="V"}
	else
	{
		set aValueType=$zcvt(aValueType,"U")
	}
	
	/// 初始化返回值
	s outStr="Null"
	s itemId=""
	
	///若为G单元、E单元或T单元的内嵌单元
	if aSampleItemCode["."  
	{
		s ParentCode=$p(aSampleItemCode,".",1)
		s SubItemCode=$e(aSampleItemCode,$f(aSampleItemCode,"."),$l(aSampleItemCode))
		s SubItemType=$e(SubItemCode,0,1)
		if $e(ParentCode,0,1)="G"
		{
			s itemId = ..GetMultipleISegmentSimpleId(aEpisodeID,aTemplateID,ParentCode,SubItemCode,aInstanceID)
			q:itemId="" outStr
			s outStr  = ..GetISegmentSimpleValue(itemId,SubItemType,aValueType)	
		}
		elseif $e(ParentCode,0,1)="E"
		{	
			if ($l(SubItemCode,".") = 3)
			{
				s itemId = ..GetMultipleITextDescSimpleId(aEpisodeID,aTemplateID,ParentCode,$p(SubItemCode,".",1),$p(SubItemCode,".",2),$p(SubItemCode,".",3),aInstanceID)
			}
			q:itemId="" outStr
			s outStr = ..GetITextDescSimpleValue(itemId,SubItemType,aValueType)	
		}
		elseif $e(ParentCode,0,1)="T"
		{
			s itemId = ..GetMultipleITableSimpleId(aEpisodeID,aTemplateID,ParentCode,SubItemCode,aInstanceID)
			q:itemId="" outStr
			s count=$length(itemId,"|")
			for I=1:1:count
			{
				s tmpItemId=$p($P(itemId,"|",I),"^",2)
				s value = ..GetITableSimpleValue(tmpItemId,SubItemType,aValueType)
				/*
				if (value '= Null) && (value '= "")
				{
					if outStr="Null"
					{	s outStr = value}
					else
					{	s outStr=outStr_"#"_value}
				}
				*/
				if (I = 1)
				{	s outStr = value}
				else
				{	s outStr = outStr_$C(2)_value}
			}
		}
	}
	///若为非内嵌单元
	elseif aSampleItemCode'["." 
	{
		s itemType = $e(aSampleItemCode,0,1)
		if $e(aSampleItemCode,0,1)="G"
		{
			s itemId = ..GetMultipleISegmentId(aEpisodeID,aTemplateID,aSampleItemCode,aInstanceID)
			q:itemId="" outStr
			s outStr = ..GetISegmentValue(itemId)	
		}
		elseif $e(aSampleItemCode,0,1)="E"
		{
			//b "s"
			s itemId = ..GetMultipleITextDescId(aEpisodeID,aTemplateID,aSampleItemCode,aInstanceID)
			q:itemId="" outStr
			s outStr= ..GetITextDescValue(itemId)
		}
		elseif $e(aSampleItemCode,0,1)="Y"
		{	
			/// do nothing
		}
		else
		{	
			s itemId = ..GetMultipleISimpleId(aEpisodeID,aTemplateID,aSampleItemCode,aInstanceID)
			q:itemId="" outStr
			s outStr = ..GetISimpleValue(itemId,itemType,aValueType)
		}
	}
	
	//转换 &EnterKey;
	set count = $Length(outStr, "&KeyEnter;")
    if count > 1
    {
	    set tmpRetVal = ""
		for I = 1:1:count
		{
			set tmpRetVal = tmpRetVal_$p(outStr,"&KeyEnter;",I)_$c(13) 
		}
		set outStr = $extract(tmpRetVal,1,$Length(tmpRetVal)-1)
    }
	//转换 &nbsp;
	set count = $Length(outStr, "&nbsp;")
	if count > 1
	{
		set tmpRetVal=""
		for I = 1:1:count
		{
			set tmpRetVal = tmpRetVal_$p(outStr,"&nbsp;",I)_$c(32)
		}
		set outStr = $extract(tmpRetVal,1,$Length(tmpRetVal)-1)
	}
	
	q outStr
}

ClassMethod GetScatterDataList(aEpisodeID As %String, aTemplateID As %String, aSampleItemCode As %String, aValueType As %String = "V") As %ResultSet
{
	quit:($d(aEpisodeID)=0)||($d(aTemplateID)=0)||($d(aSampleItemCode)=0)||(aEpisodeID="")||(aTemplateID="")||(aSampleItemCode="") "Null"
	
	/// 取值类型为空时，默认为取 "值"
	/// 将取值类型转化为大写
	if (aValueType="") 
	{	set aValueType="V"}
	else
	{
		set aValueType=$zcvt(aValueType,"U")
	}
	
	/// 初始化返回值
	s retVal = ""
	
	///若为G单元、E单元或T单元的内嵌单元
	if aSampleItemCode["."  
	{
		s ParentCode=$p(aSampleItemCode,".",1)
		s SubItemCode=$e(aSampleItemCode,$f(aSampleItemCode,"."),$l(aSampleItemCode))
		s SubItemType=$e(SubItemCode,0,1)
		if $e(ParentCode,0,1)="G"
		{
			s rs = ##class(%ResultSet).%New("EPRservice.BOScatterData:GetISegmentSimpleList")
			s sc = rs.Execute(aEpisodeID,SubItemType,aValueType,aTemplateID,ParentCode,SubItemCode)
			q rs
		}
		elseif $e(ParentCode,0,1)="E"
		{	
			if ($l(SubItemCode,".") = 1)
			{
				s rs = ##class(%ResultSet).%New("EPRservice.BOScatterData:GetITextDescSimpleList")
				s sc = rs.Execute(aEpisodeID,SubItemType,aValueType,aTemplateID,ParentCode,SubItemCode)
				q rs
			}
			elseif ($l(SubItemCode,".") = 3)
			{
				s rs = ##class(%ResultSet).%New("EPRservice.BOScatterData:GetITextDescSimpleList")
				s sc = rs.Execute(aEpisodeID,SubItemType,aValueType,aTemplateID,ParentCode,$p(SubItemCode,".",1),$p(SubItemCode,".",2),$p(SubItemCode,".",3))
				q rs
			}
		}
		elseif $e(ParentCode,0,1)="T"
		{
			//do nothing, 暂不支持T单元
		}
	}
	///若为非内嵌单元
	elseif aSampleItemCode'["." 
	{
		s itemType = $e(aSampleItemCode,0,1)
		if $e(aSampleItemCode,0,1)="G"
		{
			s rs = ##class(%ResultSet).%New("EPRservice.BOScatterData:GetISegmentList")
			s sc = rs.Execute(aEpisodeID,itemType,aValueType,aTemplateID,aSampleItemCode)
			q rs
		}
		elseif $e(aSampleItemCode,0,1)="E"
		{
			s rs = ##class(%ResultSet).%New("EPRservice.BOScatterData:GetITextDescList")
			s sc = rs.Execute(aEpisodeID,itemType,aValueType,aTemplateID,aSampleItemCode)
			q rs
		}
		elseif $e(aSampleItemCode,0,1)="Y"
		{	
			/// do nothing，暂不支持Y单元
		}
		else
		{	
			s rs = ##class(%ResultSet).%New("EPRservice.BOScatterData:GetISimpleList")
			s sc = rs.Execute(aEpisodeID,itemType,aValueType,aTemplateID,aSampleItemCode)
			q rs
		}
	}
	
	q ""
}

/// 查询ISimpleItem的rowId
ClassMethod GetISimpleId(episodeId As %String, templateId As %String, simpleItemCode As %String) As %String
{
	quit:($d(episodeId)=0)||(episodeId="")||($d(templateId)=0)||(templateId="")||($d(simpleItemCode)=0)||(simpleItemCode="") ""
	set blankEpisodeId=" "_episodeId
	set blankTemplateId=" "_templateId
	set blankSimpleItemCode=" "_simpleItemCode
	Set blankInstanceDataId=$O(^DHCEPRI.ISimpleI("IdxForLink",blankEpisodeId,blankTemplateId,blankSimpleItemCode,""))
	quit:blankInstanceDataId="" ""
	set itemId=$O(^DHCEPRI.ISimpleI("IdxForLink",blankEpisodeId,blankTemplateId,blankSimpleItemCode,blankInstanceDataId,""))
	quit itemId
}

/// 查询可重复模板的ISimpleItem的rowId
ClassMethod GetMultipleISimpleId(episodeId As %String, templateId As %String, simpleItemCode As %String, instanceID As %String) As %String
{
	//b "s"
	
	quit:($d(episodeId)=0)||(episodeId="")||($d(templateId)=0)||(templateId="")||($d(simpleItemCode)=0)||(simpleItemCode="") ""
	set itemId=""
	
	set blankEpisodeId=" "_episodeId
	set blankTemplateId=" "_templateId
	set blankSimpleItemCode=" "_simpleItemCode
	set blankInstanceDataId = " "_instanceID
	//Set blankInstanceDataId=$O(^DHCEPRI.ISimpleI("IdxForLink",blankEpisodeId,blankTemplateId,blankSimpleItemCode,""))
	//if (blankInstanceDataId = (" "_instanceID))
	//{
	set itemId=$O(^DHCEPRI.ISimpleI("IdxForLink",blankEpisodeId,blankTemplateId,blankSimpleItemCode,blankInstanceDataId,""))
	//}
	
	quit itemId
}

/// 查询ISegmentItem的rowId
ClassMethod GetISegmentId(episodeId As %String, templateId As %String, segmentItemCode As %String) As %String
{
	quit:($d(episodeId)=0)||(episodeId="")||($d(templateId)=0)||(templateId="")||($d(segmentItemCode)=0)||(segmentItemCode="") ""
	set blankEpisodeId=" "_episodeId
	set blankTemplateId=" "_templateId
	set blankSegmentItemCode=" "_segmentItemCode
	Set blankInstanceDataId=$O(^DHCEPRI.ISegmentI("IdxForLink",blankEpisodeId,blankTemplateId,blankSegmentItemCode,""))
	quit:blankInstanceDataId="" ""
	set itemId=$O(^DHCEPRI.ISegmentI("IdxForLink",blankEpisodeId,blankTemplateId,blankSegmentItemCode,blankInstanceDataId,""))
	quit itemId
}

/// 查询可重复模板的ISegmentItem的rowId
ClassMethod GetMultipleISegmentId(episodeId As %String, templateId As %String, segmentItemCode As %String, instanceID As %String) As %String
{
	quit:($d(episodeId)=0)||(episodeId="")||($d(templateId)=0)||(templateId="")||($d(segmentItemCode)=0)||(segmentItemCode="") ""
	set itemId=""
	
	set blankEpisodeId=" "_episodeId
	set blankTemplateId=" "_templateId
	set blankSegmentItemCode=" "_segmentItemCode
	set blankInstanceDataId = " "_instanceID
	//Set blankInstanceDataId=$O(^DHCEPRI.ISegmentI("IdxForLink",blankEpisodeId,blankTemplateId,blankSegmentItemCode,""))
	//if (blankInstanceDataId = (" "_instanceID))
	//{
		set itemId=$O(^DHCEPRI.ISegmentI("IdxForLink",blankEpisodeId,blankTemplateId,blankSegmentItemCode,blankInstanceDataId,""))
	//}
	
	quit itemId
}

/// 查询ISegmentSimpleItem的rowId
ClassMethod GetISegmentSimpleId(episodeId As %String, templateId As %String, segmentItemCode As %String, sgSimpleItemCode As %String) As %String
{
	//b "s"
	quit:($d(episodeId)=0)||(episodeId="")||($d(templateId)=0)||(templateId="")||($d(segmentItemCode)=0)||(segmentItemCode="")||($d(sgSimpleItemCode)=0)||(sgSimpleItemCode="") ""
	set blankEpisodeId=" "_episodeId
	set blankTemplateId=" "_templateId
	set blankSegmentItemCode=" "_segmentItemCode
	set blankSgSimpleItemCode=" "_sgSimpleItemCode
	Set blankInstanceDataId=$O(^DHCEPRI.ISegmentSimpleI("IdxForLink",blankEpisodeId,blankTemplateId,blankSegmentItemCode,blankSgSimpleItemCode,""))
	quit:blankInstanceDataId="" ""
	set itemId=$O(^DHCEPRI.ISegmentSimpleI("IdxForLink",blankEpisodeId,blankTemplateId,blankSegmentItemCode,blankSgSimpleItemCode,blankInstanceDataId,""))
	quit itemId
}

/// 查询可重复模板的ISegmentSimpleItem的rowId
ClassMethod GetMultipleISegmentSimpleId(episodeId As %String, templateId As %String, segmentItemCode As %String, sgSimpleItemCode As %String, instanceID As %String) As %String
{
	//b "s"
	quit:($d(episodeId)=0)||(episodeId="")||($d(templateId)=0)||(templateId="")||($d(segmentItemCode)=0)||(segmentItemCode="")||($d(sgSimpleItemCode)=0)||(sgSimpleItemCode="") ""
	set itemId=""
	
	set blankEpisodeId=" "_episodeId
	set blankTemplateId=" "_templateId
	set blankSegmentItemCode=" "_segmentItemCode
	set blankSgSimpleItemCode=" "_sgSimpleItemCode
	set blankInstanceDataId = " "_instanceID
	//Set blankInstanceDataId=$O(^DHCEPRI.ISegmentSimpleI("IdxForLink",blankEpisodeId,blankTemplateId,blankSegmentItemCode,blankSgSimpleItemCode,""))
	//if (blankInstanceDataId = (" "_instanceID))
	//{
		set itemId=$O(^DHCEPRI.ISegmentSimpleI("IdxForLink",blankEpisodeId,blankTemplateId,blankSegmentItemCode,blankSgSimpleItemCode,blankInstanceDataId,""))
	//}
	
	quit itemId
}

/// 查询ITextDescItem的rowId
ClassMethod GetITextDescId(episodeId As %String, templateId As %String, textDescItemCode As %String) As %String
{
	quit:($d(episodeId)=0)||(episodeId="")||($d(templateId)=0)||(templateId="")||($d(textDescItemCode)=0)||(textDescItemCode="") ""
	set blankEpisodeId=" "_episodeId
	set blankTemplateId=" "_templateId
	set blankTextDescItemCode=" "_textDescItemCode
	Set blankInstanceDataId=$O(^DHCEPRI.ITextDescI("IdxForLink",blankEpisodeId,blankTemplateId,blankTextDescItemCode,""))
	quit:blankInstanceDataId="" ""
	set itemId=$O(^DHCEPRI.ITextDescI("IdxForLink",blankEpisodeId,blankTemplateId,blankTextDescItemCode,blankInstanceDataId,""))
	quit itemId
}

/// 查询可重复模板的ITextDescItem的rowId
ClassMethod GetMultipleITextDescId(episodeId As %String, templateId As %String, textDescItemCode As %String, instanceID As %String) As %String
{
	quit:($d(episodeId)=0)||(episodeId="")||($d(templateId)=0)||(templateId="")||($d(textDescItemCode)=0)||(textDescItemCode="") ""
	set itemId=""
	
	set blankEpisodeId=" "_episodeId
	set blankTemplateId=" "_templateId
	set blankTextDescItemCode=" "_textDescItemCode
	set blankInstanceDataId = " "_instanceID
	//Set blankInstanceDataId=$O(^DHCEPRI.ITextDescI("IdxForLink",blankEpisodeId,blankTemplateId,blankTextDescItemCode,""))
	//if (blankInstanceDataId = (" "_instanceID))
	//{
		set itemId=$O(^DHCEPRI.ITextDescI("IdxForLink",blankEpisodeId,blankTemplateId,blankTextDescItemCode,blankInstanceDataId,""))
	//}
	
	quit itemId
}

/// 查询ITextDescSimpleItem的rowId
ClassMethod GetITextDescSimpleId(episodeId As %String, templateId As %String, textDescItemCode As %String, textSimpleItemCode As %String, KBNodeId As %String = "", KBPartNo As %String = "") As %String
{
	quit:($d(episodeId)=0)||(episodeId="")||($d(templateId)=0)||(templateId="")||($d(textDescItemCode)=0)||(textDescItemCode="")||($d(textSimpleItemCode)=0)||(textSimpleItemCode="") ""
	set itemId=""
	set blankEpisodeId=" "_episodeId
	set blankTemplateId=" "_templateId
	set blankTextDescItemCode=" "_textDescItemCode
	set blankTextSimpleItemCode=" "_textSimpleItemCode
	if (KBNodeId '= "")&&(KBPartNo '= "")
	{	
		set blankKBNodeId=" "_KBNodeId
		set blankKBPartNo=" "_KBPartNo
		Set blankInstanceDataId=$O(^DHCEPRI.ITextDescSimpleI("IdxForLink",blankEpisodeId,blankTemplateId,blankTextDescItemCode,blankKBNodeId,blankKBPartNo,blankTextSimpleItemCode,""))
		quit:blankInstanceDataId="" ""
		set itemId=$O(^DHCEPRI.ITextDescSimpleI("IdxForLink",blankEpisodeId,blankTemplateId,blankTextDescItemCode,blankKBNodeId,blankKBPartNo,blankTextSimpleItemCode,blankInstanceDataId,""))
	}
	else
	{	
		set blankKBNodeId=$O(^DHCEPRI.ITextDescSimpleI("IdxForLink",blankEpisodeId,blankTemplateId,blankTextDescItemCode,""))
		while (blankKBNodeId'="")
		{
			set blankKBPartNo=$O(^DHCEPRI.ITextDescSimpleI("IdxForLink",blankEpisodeId,blankTemplateId,blankTextDescItemCode,blankKBNodeId,""))
			while (blankKBPartNo '= "")
			{
				set blankInstanceDataId=$O(^DHCEPRI.ITextDescSimpleI("IdxForLink",blankEpisodeId,blankTemplateId,blankTextDescItemCode,blankKBNodeId,blankKBPartNo,blankTextSimpleItemCode,""))
				if (blankInstanceDataId '= "")
				{	
					set itemId=$O(^DHCEPRI.ITextDescSimpleI("IdxForLink",blankEpisodeId,blankTemplateId,blankTextDescItemCode,blankKBNodeId,blankKBPartNo,blankTextSimpleItemCode,blankInstanceDataId,""))
				}
				set blankKBPartNo=$O(^DHCEPRI.ITextDescSimpleI("IdxForLink",blankEpisodeId,blankTemplateId,blankTextDescItemCode,blankKBNodeId,blankKBPartNo))
			}
			set blankKBNodeId=$O(^DHCEPRI.ITextDescSimpleI("IdxForLink",blankEpisodeId,blankTemplateId,blankTextDescItemCode,blankKBNodeId))
		}
	}
	quit itemId
}

/// 查询可重复模板的ITextDescSimpleItem的rowId
ClassMethod GetMultipleITextDescSimpleId(episodeId As %String, templateId As %String, textDescItemCode As %String, textSimpleItemCode As %String, KBNodeId As %String, KBPartNo As %String, instanceID As %String) As %String
{
	quit:($d(episodeId)=0)||(episodeId="")||($d(templateId)=0)||(templateId="")||($d(textDescItemCode)=0)||(textDescItemCode="")||($d(textSimpleItemCode)=0)||(textSimpleItemCode="") ""
	quit:($d(KBNodeId)=0)||(KBNodeId="")||($d(KBPartNo)="")||(KBPartNo="")||($d(instanceID)="")||(instanceID="") ""
	set itemId=""
	
	set blankEpisodeId=" "_episodeId
	set blankTemplateId=" "_templateId
	set blankTextDescItemCode=" "_textDescItemCode
	set blankTextSimpleItemCode=" "_textSimpleItemCode
	set blankKBNodeId=" "_KBNodeId
	set blankKBPartNo=" "_KBPartNo
	set blankInstanceDataId = " "_instanceID
	//Set blankInstanceDataId=$O(^DHCEPRI.ITextDescSimpleI("IdxForLink",blankEpisodeId,blankTemplateId,blankTextDescItemCode,blankKBNodeId,blankKBPartNo,blankTextSimpleItemCode,""))
	//if (blankInstanceDataId = (" "_instanceID))
	//{
		set itemId=$O(^DHCEPRI.ITextDescSimpleI("IdxForLink",blankEpisodeId,blankTemplateId,blankTextDescItemCode,blankKBNodeId,blankKBPartNo,blankTextSimpleItemCode,blankInstanceDataId,""))
	//}

	quit itemId
}

/// 查询ITableSimpleItem的rowId
/// 对于TableSimpleItem，每一个Item可能有多行数据，从而的得到多个itemId
/// 返回值格式为：rowNum1^itemId1|rowNum2^itemId2
ClassMethod GetITableSimpleId(episodeId As %String, templateId As %String, tableCode As %String, tableSimpleItemCode As %String) As %String
{
	quit:($d(episodeId)=0)||(episodeId="")||($d(templateId)=0)||(templateId="")||($d(tableCode)=0)||(tableCode="")||($d(tableSimpleItemCode)=0)||(tableSimpleItemCode="") ""
	set itemId=""
	
	set blankEpisodeId=" "_episodeId
	set blankTemplateId=" "_templateId
	set blankTableCode=" "_tableCode
	set blankTableSimpleItemCode=" "_tableSimpleItemCode
	Set blankInstanceDataId=$O(^DHCEPRI.ITableSimpleI("IdxForLink",blankEpisodeId,blankTemplateId,blankTableCode,blankTableSimpleItemCode,""))
	quit:blankInstanceDataId="" ""
	set blankRowNum=$O(^DHCEPRI.ITableSimpleI("IdxForLink",blankEpisodeId,blankTemplateId,blankTableCode,blankTableSimpleItemCode,blankInstanceDataId,""))
	while blankRowNum '= ""
	{
		set tmpItemId=$O(^DHCEPRI.ITableSimpleI("IdxForLink",blankEpisodeId,blankTemplateId,blankTableCode,blankTableSimpleItemCode,blankInstanceDataId,blankRowNum,""))
		if tmpItemId '= ""
		{
			s rowNum=$extract(blankRowNum,2,$L(blankRowNum))
			if itemId = ""
			{	s itemId=rowNum_"^"_tmpItemId}
			else
			{	s itemId=itemId_"|"_rowNum_"^"_tmpItemId}
		}
		set blankRowNum=$O(^DHCEPRI.ITableSimpleI("IdxForLink",blankEpisodeId,blankTemplateId,blankTableCode,blankTableSimpleItemCode,blankInstanceDataId,blankRowNum))
	}
	quit itemId
}

/// 查询ITableSimpleItem的rowId
/// 对于TableSimpleItem，每一个Item可能有多行数据，从而的得到多个itemId
/// 返回值格式为：rowNum1^itemId1|rowNum2^itemId2
ClassMethod GetMultipleITableSimpleId(episodeId As %String, templateId As %String, tableCode As %String, tableSimpleItemCode As %String, instanceID As %String) As %String
{
	quit:($d(episodeId)=0)||(episodeId="")||($d(templateId)=0)||(templateId="")||($d(tableCode)=0)||(tableCode="")||($d(tableSimpleItemCode)=0)||(tableSimpleItemCode="")||(instanceID="") ""
	set itemId=""
	
	set blankEpisodeId=" "_episodeId
	set blankTemplateId=" "_templateId
	set blankTableCode=" "_tableCode
	set blankTableSimpleItemCode=" "_tableSimpleItemCode
	Set blankInstanceDataId=" "_instanceID
	set blankRowNum=$O(^DHCEPRI.ITableSimpleI("IdxForLink",blankEpisodeId,blankTemplateId,blankTableCode,blankTableSimpleItemCode,blankInstanceDataId,""))
	while blankRowNum '= ""
	{
		set tmpItemId=$O(^DHCEPRI.ITableSimpleI("IdxForLink",blankEpisodeId,blankTemplateId,blankTableCode,blankTableSimpleItemCode,blankInstanceDataId,blankRowNum,""))
		if tmpItemId '= ""
		{
			s rowNum=$extract(blankRowNum,2,$L(blankRowNum))
			if itemId = ""
			{	s itemId=rowNum_"^"_tmpItemId}
			else
			{	s itemId=itemId_"|"_rowNum_"^"_tmpItemId}
		}
		set blankRowNum=$O(^DHCEPRI.ITableSimpleI("IdxForLink",blankEpisodeId,blankTemplateId,blankTableCode,blankTableSimpleItemCode,blankInstanceDataId,blankRowNum))
	}
	quit itemId
}

/// 获取ISimpleItem的数据
/// 参数：itemId 数据项的rowId， metaType 数据项的元数据类型，valueType 返回值的类型 
ClassMethod GetISimpleValue(itemId As %String, metaType As %String = "", valueType As %String = "") As %String
{
	quit:($d(itemId)=0)||(itemId="") ""
	s returnValue=""
	
	set objISimple=##class(EPRinstance.ISimple).%OpenId(itemId)
	quit:objISimple="" returnValue
	
	///若元数据类型参数或返回值类型参数为空，则只取 DataValue
	if (metaType="")||(valueType="")
	{
		set returnValue=objISimple.DataValue
		quit returnValue
	}
	
	///由元数据类型和返回值类型取相应的数据值
	if (metaType="S")||(metaType="N")
	{
		if valueType="V"
		{	set returnValue=objISimple.DataValue}
		elseif valueType="C"
		{	set returnValue=objISimple.ValueCode}
	}
	elseif (metaType="O")||(metaType="M")||(metaType="Q")||(metaType="I")||(metaType="P")
	{
		if valueType="V"
		{	set returnValue=objISimple.DataValue}
		elseif valueType="C"
		{	set returnValue=objISimple.ValueCode}
		elseif valueType="VC"
		{	set returnValue=objISimple.DataValue_objISimple.ValueCode}
		elseif valueType="CV"
		{	set returnValue=objISimple.ValueCode_objISimple.DataValue}
		elseif valueType="VANDC"
		{	set returnValue=objISimple.DataValue_"^"_objISimple.ValueCode}
		elseif valueType="CANDV"
		{	set returnValue=objISimple.ValueCode_"^"_objISimple.DataValue}
	}
	elseif (metaType="D")
	{
		///ValueCode的格式为：2007-1-29 12:09:56
		set tmpDateTime=objISimple.ValueCode
		if valueType="V"
		{	set returnValue=objISimple.DataValue}
		elseif valueType="C"
		{	set returnValue=objISimple.ValueCode} 
		elseif valueType="VANDC"
		{	set returnValue=objISimple.DataValue_"^"_objISimple.ValueCode}
		elseif valueType="YEAR"
		{	set returnValue=$P(tmpDateTime,"-",1)}
		elseif valueType="MONTH"
		{	set returnValue=$P(tmpDateTime,"-",2)}
		elseif valueType="DAY"
		{	set returnValue=$p($P(tmpDateTime," ",1),"-",3)}
		elseif valueType="HOUR"
		{	set returnValue=$p($P(tmpDateTime," ",2),":",1)}
		elseif valueType="MINUTE"
		{	set returnValue=$p($P(tmpDateTime," ",2),":",2)}
		elseif valueType="SECOND"
		{	set returnValue=$p($P(tmpDateTime," ",2),":",3)}
		elseif valueType="YMDHM"
		{
			//YYYY-MM-DD HH:MM
			set returnValue = $P(tmpDateTime," ",1)_" "_$E($P(tmpDateTime," ",2), 1, 5)
		}
		elseif valueType="MDHM"
		{
			//MM-DD HH:MM
			set tmpDate = $P(tmpDateTime," ",1)
			set tmpTime = $P(tmpDateTime," ",2)
			set returnValue = $E(tmpDate,6,$L(tmpDate))_" "_$E(tmpTime, 1, 5)
		}
		elseif valueType="YMD"
		{
			//YYYY-MM-DD
			set returnValue = $P(objISimple.ValueCode," ",1)	
		}
		elseif valueType="HMS"
		{
			//HH:MM:SS
			set returnValue = $P(objISimple.ValueCode," ",2)	
		}
		elseif valueType="HM"
		{
			//HH:MM
			set returnValue = $E($P(objISimple.ValueCode," ",2),1,5)	
		}
	}
	
	//s returnValue=$tr(returnValue,"&nbsp;"," ")
	quit returnValue
}

/// 获取ISegmentSimpleItem的数据
/// 参数：itemId 数据项的rowId， metaType 数据项的元数据类型，valueType 返回值的类型 
ClassMethod GetISegmentSimpleValue(itemId As %String, metaType As %String = "", valueType As %String = "") As %String
{
	quit:($d(itemId)=0)||(itemId="") ""
	s returnValue=""
	
	set objISegmentSimple=##class(EPRinstance.ISegmentSimple).%OpenId(itemId)
	quit:objISegmentSimple="" returnValue
	
	///若元数据类型参数或返回值类型参数为空，则只取 DataValue
	if (metaType="")||(valueType="")
	{
		set returnValue=objISegmentSimple.DataValue
		quit returnValue
	}
	
	///由元数据类型和返回值类型取相应的数据值
	if (metaType="S")||(metaType="N")||(metaType="L")
	{
		if valueType="V"
		{	set returnValue=objISegmentSimple.DataValue}
		elseif valueType="C"
		{	set returnValue=objISegmentSimple.ValueCode}
	}
	elseif (metaType="O")||(metaType="M")||(metaType="Q")||(metaType="I")||(metaType="P")
	{
		if valueType="V"
		{	set returnValue=objISegmentSimple.DataValue}
		elseif valueType="C"
		{	set returnValue=objISegmentSimple.ValueCode}
		elseif valueType="VC"
		{	set returnValue=objISegmentSimple.DataValue_objISegmentSimple.ValueCode}
		elseif valueType="CV"
		{	set returnValue=objISegmentSimple.ValueCode_objISegmentSimple.DataValue}
		elseif valueType="VANDC"
		{	set returnValue=objISegmentSimple.DataValue_"^"_objISegmentSimple.ValueCode}
		elseif valueType="CANDV"
		{	set returnValue=objISegmentSimple.ValueCode_"^"_objISegmentSimple.DataValue}
	}
	elseif (metaType="D")
	{
		///ValueCode的格式为：2007-1-29 12:09:56
		set tmpDateTime=objISegmentSimple.ValueCode
		if valueType="V"
		{	set returnValue=objISegmentSimple.DataValue}
		elseif valueType="C"
		{	set returnValue=objISegmentSimple.ValueCode} 
		elseif valueType="VANDC"
		{	set returnValue=objISegmentSimple.DataValue_"^"_objISegmentSimple.ValueCode}
		elseif valueType="YEAR"
		{	set returnValue=$P(tmpDateTime,"-",1)}
		elseif valueType="MONTH"
		{	set returnValue=$P(tmpDateTime,"-",2)}
		elseif valueType="DAY"
		{	set returnValue=$p($P(tmpDateTime," ",1),"-",3)}
		elseif valueType="HOUR"
		{	set returnValue=$p($P(tmpDateTime," ",2),":",1)}
		elseif valueType="MINUTE"
		{	set returnValue=$p($P(tmpDateTime," ",2),":",2)}
		elseif valueType="SECOND"
		{	set returnValue=$p($P(tmpDateTime," ",2),":",3)}
		elseif valueType="YMDHM"
		{
			//YYYY-MM-DD HH:MM
			set returnValue = $P(tmpDateTime," ",1)_" "_$E($P(tmpDateTime," ",2), 1, 5)
		}
		elseif valueType="MDHM"
		{
			//MM-DD HH:MM
			set tmpDate = $P(tmpDateTime," ",1)
			set tmpTime = $P(tmpDateTime," ",2)
			set returnValue = $E(tmpDate,6,$L(tmpDate))_" "_$E(tmpTime, 1, 5)
		}
		elseif valueType="YMD"
		{
			//YYYY-MM-DD
			set returnValue = $P(objISimple.ValueCode," ",1)	
		}
		elseif valueType="HMS"
		{
			//HH:MM:SS
			set returnValue = $P(objISimple.ValueCode," ",2)	
		}
		elseif valueType="HM"
		{
			//HH:MM
			set returnValue = $E($P(objISimple.ValueCode," ",2),1,5)	
		}
	}
	
	//s returnValue=$tr(returnValue,"&nbsp;"," ")
	quit returnValue
}

/// 获取ISegmentItem的数据
ClassMethod GetISegmentValue(itemId As %String) As %String
{
	quit:($d(itemId)=0)||(itemId="") ""
	s returnValue=""
	
	set objISegment=##class(EPRinstance.ISegment).%OpenId(itemId)
	quit:objISegment="" returnValue

	do objISegment.Text.Rewind()
	while (objISegment.Text.AtEnd = 0) 
  	{ 	Set len=1024
    	set tmpStr=objISegment.Text.Read(len)
    	set returnValue=returnValue_tmpStr  
   	}
   	
   	//s returnValue=$tr(returnValue,"&nbsp;"," ")
    quit returnValue
}

/// 获取ITextDescSimpleItem的数据
/// 参数：itemId 数据项的rowId， metaType 数据项的元数据类型，valueType 返回值的类型 
ClassMethod GetITextDescSimpleValue(itemId As %String, metaType As %String = "", valueType As %String = "") As %String
{
	quit:($d(itemId)=0)||(itemId="") ""
	s returnValue=""
	
	set objITextDescSimple=##class(EPRinstance.ITextDescSimple).%OpenId(itemId)
	quit:objITextDescSimple="" returnValue
	
	///若元数据类型参数或返回值类型参数为空，则只取 DataValue
	if (metaType="")||(valueType="")
	{
		set returnValue=objITextDescSimple.DataValue
		quit returnValue
	}
	
	///由元数据类型和返回值类型取相应的数据值
	if (metaType="S")||(metaType="N")
	{
		if valueType="V"
		{	set returnValue=objITextDescSimple.DataValue}
		elseif valueType="C"
		{	set returnValue=objITextDescSimple.ValueCode}
	}
	elseif (metaType="O")||(metaType="M")||(metaType="Q")||(metaType="I")||(metaType="P")
	{
		if valueType="V"
		{	set returnValue=objITextDescSimple.DataValue}
		elseif valueType="C"
		{	set returnValue=objITextDescSimple.ValueCode}
		elseif valueType="VC"
		{	set returnValue=objITextDescSimple.DataValue_objITextDescSimple.ValueCode}
		elseif valueType="CV"
		{	set returnValue=objITextDescSimple.ValueCode_objITextDescSimple.DataValue}
		elseif valueType="VANDC"
		{	set returnValue=objITextDescSimple.DataValue_"^"_objITextDescSimple.ValueCode}
		elseif valueType="CANDV"
		{	set returnValue=objITextDescSimple.DataValue_"^"_objITextDescSimple.ValueCode}
	}
	elseif (metaType="D")
	{
		///ValueCode的格式为：2007-1-29 12:09:56
		set tmpDateTime=objITextDescSimple.ValueCode
		if valueType="V"
		{	set returnValue=objITextDescSimple.DataValue}
		elseif valueType="C"
		{	set returnValue=objITextDescSimple.ValueCode} 
		elseif valueType="VANDC"
		{	set returnValue=objITextDescSimple.DataValue_"^"_objITextDescSimple.ValueCode}
		elseif valueType="YEAR"
		{	set returnValue=$P(tmpDateTime,"-",1)}
		elseif valueType="MONTH"
		{	set returnValue=$P(tmpDateTime,"-",2)}
		elseif valueType="DAY"
		{	set returnValue=$p($P(tmpDateTime," ",1),"-",3)}
		elseif valueType="HOUR"
		{	set returnValue=$p($P(tmpDateTime," ",2),":",1)}
		elseif valueType="MINUTE"
		{	set returnValue=$p($P(tmpDateTime," ",2),":",2)}
		elseif valueType="SECOND"
		{	set returnValue=$p($P(tmpDateTime," ",2),":",3)}
		elseif valueType="YMDHM"
		{
			//YYYY-MM-DD HH:MM
			set returnValue = $P(tmpDateTime," ",1)_" "_$E($P(tmpDateTime," ",2), 1, 5)
		}
		elseif valueType="MDHM"
		{
			//MM-DD HH:MM
			set tmpDate = $P(tmpDateTime," ",1)
			set tmpTime = $P(tmpDateTime," ",2)
			set returnValue = $E(tmpDate,6,$L(tmpDate))_" "_$E(tmpTime, 1, 5)
		}
		elseif valueType="YMD"
		{
			//YYYY-MM-DD
			set returnValue = $P(objISimple.ValueCode," ",1)	
		}
		elseif valueType="HMS"
		{
			//HH:MM:SS
			set returnValue = $P(objISimple.ValueCode," ",2)	
		}
		elseif valueType="HM"
		{
			//HH:MM
			set returnValue = $E($P(objISimple.ValueCode," ",2),1,5)	
		}
	}
	
	//s returnValue=$tr(returnValue,"&nbsp;"," ")
	quit returnValue
}

/// 获取ITextDescItem的数据
ClassMethod GetITextDescValue(itemId As %String) As %String
{
	//b "s"
	quit:($d(itemId)=0)||(itemId="") ""
	s returnValue=""
	
	set objITextDesc=##class(EPRinstance.ITextDesc).%OpenId(itemId)
	quit:objITextDesc="" returnValue
	
	do objITextDesc.Text.Rewind()
	while (objITextDesc.Text.AtEnd = 0) 
  	{ 	Set len=1024
    	set tmpStr=objITextDesc.Text.Read(len)
    	set returnValue=returnValue_tmpStr  
   	}
   	
   	//s returnValue=$tr(returnValue,"&nbsp;"," ")
    quit returnValue
}

/// 获取ITableSimpleItem的数据
/// 参数：itemId 数据项的rowId， metaType 数据项的元数据类型，valueType 返回值的类型 
ClassMethod GetITableSimpleValue(itemId As %String, metaType As %String = "", valueType As %String = "") As %String
{
	quit:($d(itemId)=0)||(itemId="") ""
	s returnValue=""
	
	set objITableSimple=##class(EPRinstance.ITableSimple).%OpenId(itemId)
	quit:objITableSimple="" returnValue
	
	///若元数据类型参数或返回值类型参数为空，则只取 DataValue
	if (metaType="")||(valueType="")
	{
		set returnValue=objITableSimple.DataValue
		quit returnValue
	}
	
	///由元数据类型和返回值类型取相应的数据值
	if (metaType="S")||(metaType="N")
	{
		if valueType="V"
		{	set returnValue=objITableSimple.DataValue}
		elseif valueType="C"
		{	set returnValue=objITableSimple.ValueCode}
	}
	elseif (metaType="O")||(metaType="M")||(metaType="Q")||(metaType="I")||(metaType="P")
	{
		if valueType="V"
		{	set returnValue=objITableSimple.DataValue}
		elseif valueType="C"
		{	set returnValue=objITableSimple.ValueCode}
		elseif valueType="VC"
		{	set returnValue=objITableSimple.DataValue_objITableSimple.ValueCode}
		elseif valueType="CV"
		{	set returnValue=objITableSimple.ValueCode_objITableSimple.DataValue}
		elseif valueType="VANDC"
		{	set returnValue=objITableSimple.DataValue_"^"_objITableSimple.ValueCode}
		elseif valueType="CANDV"
		{	set returnValue=objITableSimple.ValueCode_"^"_objITableSimple.DataValue}
	}
	elseif (metaType="D")
	{
		///ValueCode的格式为：2007-1-29 12:09:56
		set tmpDateTime=objITableSimple.ValueCode
		if valueType="V"
		{	set returnValue=objITableSimple.DataValue}
		elseif valueType="C"
		{	set returnValue=objITableSimple.ValueCode} 
		elseif valueType="VANDC"
		{	set returnValue=objITableSimple.DataValue_"^"_objITableSimple.ValueCode}
		elseif valueType="YEAR"
		{	set returnValue=$P(tmpDateTime,"-",1)}
		elseif valueType="MONTH"
		{	set returnValue=$P(tmpDateTime,"-",2)}
		elseif valueType="DAY"
		{	set returnValue=$p($P(tmpDateTime," ",1),"-",3)}
		elseif valueType="HOUR"
		{	set returnValue=$p($P(tmpDateTime," ",2),":",1)}
		elseif valueType="MINUTE"
		{	set returnValue=$p($P(tmpDateTime," ",2),":",2)}
		elseif valueType="SECOND"
		{	set returnValue=$p($P(tmpDateTime," ",2),":",3)}
		elseif valueType="YMDHM"
		{
			//YYYY-MM-DD HH:MM
			set returnValue = $P(tmpDateTime," ",1)_" "_$E($P(tmpDateTime," ",2), 1, 5)
		}
		elseif valueType="MDHM"
		{
			//MM-DD HH:MM
			set tmpDate = $P(tmpDateTime," ",1)
			set tmpTime = $P(tmpDateTime," ",2)
			set returnValue = $E(tmpDate,6,$L(tmpDate))_" "_$E(tmpTime, 1, 5)
		}
		elseif valueType="YMD"
		{
			//YYYY-MM-DD
			set returnValue = $P(objISimple.ValueCode," ",1)	
		}
		elseif valueType="HMS"
		{
			//HH:MM:SS
			set returnValue = $P(objISimple.ValueCode," ",2)	
		}
		elseif valueType="HM"
		{
			//HH:MM
			set returnValue = $E($P(objISimple.ValueCode," ",2),1,5)	
		}
	}
	
	//s returnValue=$tr(returnValue,"&nbsp;"," ")
	quit returnValue
}

/// 查询IFigure的rowId
/// 对于IFugure，每一个Item可能有多行数据，从而的得到多个itemId
/// 返回值格式为：rowNum1^itemId1|rowNum2^itemId2
ClassMethod GetIFigureId(episodeId As %String, templateId As %String, figureCode As %String) As %String
{
	//B "S"
	quit:(($d(episodeId)=0)||(episodeId="")||($d(templateId)=0)||(templateId="")||($d(figureCode)=0)||(figureCode="")) ""
	set itemId=""
	
	set blankEId=" "_episodeId
	set blankTId=" "_templateId
	set blankFCode=" "_figureCode
	Set instanceId=$O(^DHCEPRI.IFigureI("IdxForLink",blankEId,blankTId,blankFCode,""))
	quit:(instanceId="") ""
	set indexRowNum=$O(^DHCEPRI.IFigureI("IdxForLink",blankEId,blankTId,blankFCode,instanceId,""))
	while indexRowNum '= ""
	{
		set tmpItemId=$O(^DHCEPRI.IFigureI("IdxForLink",blankEId,blankTId,blankFCode,instanceId,indexRowNum,""))
		if tmpItemId '= ""
		{
			s rowNum=$extract(indexRowNum,2,$L(indexRowNum))
			if itemId = ""
			{	s itemId=rowNum_"^"_tmpItemId}
			else
			{	s itemId=itemId_"|"_rowNum_"^"_tmpItemId}
		}
		
		set indexRowNum=$O(^DHCEPRI.IFigureI("IdxForLink",blankEId,blankTId,blankFCode,instanceId,indexRowNum))
	}
	
	quit itemId
}

ClassMethod GetMultipleIFigureId(episodeId As %String, templateId As %String, figureCode As %String, instanceId As %String) As %String
{
	//B "S"
	quit:(($d(episodeId)=0)||(episodeId="")||($d(templateId)=0)||(templateId="")||($d(figureCode)=0)||(figureCode="")) ""
	set itemId=""
	
	set blankEId=" "_episodeId
	set blankTId=" "_templateId
	set blankFCode=" "_figureCode
	set blankInstanceId=" "_instanceId
	
	set indexRowNum = ""
	for {
		set indexRowNum=$O(^DHCEPRI.IFigureI("IdxForLink",blankEId,blankTId,blankFCode,blankInstanceId,indexRowNum))
		q:(indexRowNum = "")
		
		set tmpItemId=$O(^DHCEPRI.IFigureI("IdxForLink",blankEId,blankTId,blankFCode,blankInstanceId,indexRowNum,""))
		if tmpItemId '= ""
		{
			s rowNum=$extract(indexRowNum,2,$L(indexRowNum))
			if itemId = ""
			{	s itemId=rowNum_"^"_tmpItemId}
			else
			{	s itemId=itemId_"|"_rowNum_"^"_tmpItemId}
		}
	}
	
	quit itemId
}

/// 根据Figure单元的rowId取图像
/// w ##class(EPRservice.BOScatterData).GetIFigureData(73)
ClassMethod GetIFigureData(itemId As %String) As EPRservice.entity.ReStreamData [ WebMethod ]
{

	quit:(($d(itemId)=0)||(itemId="")) ""
	s retStream=""
	
	s objIFigure = ##class(EPRinstance.IFigure).%OpenId(itemId)
	quit:(objIFigure="") retStream
	
	s retStream = ##class(EPRservice.entity.ReStreamData).%New()
	while (objIFigure.FigureData.AtEnd = 0)
	{
		s tmpString = objIFigure.FigureData.Read(10240)
		do retStream.StreamData.Write(tmpString)
	}
	
	quit retStream
}

/// 根据Figure单元的RowId取描述
/// w ##class(EPRservice.BOScatterData).GetIFigureDesc(73)
ClassMethod GetIFigureDesc(itemId As %String) As %String
{
	quit:($d(itemId)=0)||(itemId="") ""
	s retValue=""
	
	s objIFigure = ##class(EPRinstance.IFigure).%OpenId(itemId)
	quit:(objIFigure="") retValue
	
	
	s retValue = objIFigure.FigureDesc
	
	//s returnValue=$tr(returnValue,"&nbsp;"," ")
	quit retValue
}

/// Desc: 取 ISimple 数据
Query GetISimpleList(episodeId As %String, metaType As %String, valueType As %String, templateId As %String, simpleItemCode As %String) As %Query(ROWSPEC = "OutData:%String,InstanceDataID:%String")
{
}

ClassMethod GetISimpleListExecute(ByRef qHandle As %Binary, episodeId As %String, metaType As %String, valueType As %String, templateId As %String, simpleItemCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	s ind=1
	
	quit:($d(episodeId)=0)||(episodeId="")||($d(templateId)=0)||(templateId="")||($d(simpleItemCode)=0)||(simpleItemCode="") $$$OK
	
	set blankEpisodeId=" "_episodeId
	set blankTemplateId=" "_templateId
	set blankSimpleItemCode=" "_simpleItemCode
	set blankInstanceDataId = ""
	for {
		set blankInstanceDataId=$O(^DHCEPRI.ISimpleI("IdxForLink",blankEpisodeId,blankTemplateId,blankSimpleItemCode,blankInstanceDataId))
		q:(blankInstanceDataId="")
		
		set itemId=$O(^DHCEPRI.ISimpleI("IdxForLink",blankEpisodeId,blankTemplateId,blankSimpleItemCode,blankInstanceDataId,""))
		s itemValue = ..GetISimpleValue(itemId, metaType, valueType)
		
		//设置返回值
		s instanceID = $e(blankInstanceDataId,2,$L(blankInstanceDataId))	//<added on 2012-3-27>
		set ^CacheTemp(repid, ind) = $LB(itemValue,instanceID)
		s ind = ind + 1
	}
	
	Quit $$$OK
}

ClassMethod GetISimpleListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetISimpleListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetISimpleListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetISimpleListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// Desc: 取 ISegment 数据
Query GetISegmentList(episodeId As %String, metaType As %String, valueType As %String, templateId As %String, segmentItemCode As %String) As %Query(ROWSPEC = "OutData:%String,InstanceDataID:%String")
{
}

ClassMethod GetISegmentListExecute(ByRef qHandle As %Binary, episodeId As %String, metaType As %String, valueType As %String, templateId As %String, segmentItemCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	s ind=1
	
	quit:($d(episodeId)=0)||(episodeId="")||($d(templateId)=0)||(templateId="")||($d(segmentItemCode)=0)||(segmentItemCode="") $$$OK
	set itemId=""
	
	set blankEpisodeId=" "_episodeId
	set blankTemplateId=" "_templateId
	set blankSegmentItemCode=" "_segmentItemCode
	set blankInstanceDataId = ""
	for {
		set blankInstanceDataId=$O(^DHCEPRI.ISegmentI("IdxForLink",blankEpisodeId,blankTemplateId,blankSegmentItemCode,blankInstanceDataId))
		q:(blankInstanceDataId="")
		
		set itemId=$O(^DHCEPRI.ISegmentI("IdxForLink",blankEpisodeId,blankTemplateId,blankSegmentItemCode,blankInstanceDataId,""))
		set itemValue = ..GetISegmentValue(itemId)
		
		//设置返回值
		s instanceID = $e(blankInstanceDataId,2,$L(blankInstanceDataId))	//<added on 2012-3-27>
		set ^CacheTemp(repid, ind) = $LB(itemValue,instanceID)
		s ind = ind + 1
	}
	Quit $$$OK
}

ClassMethod GetISegmentListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetISegmentListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetISegmentListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetISegmentListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// Desc: 取 ISegmentSimple 数据
Query GetISegmentSimpleList(episodeId As %String, metaType As %String, valueType As %String, templateId As %String, segmentItemCode As %String, sgSimpleItemCode As %String) As %Query(ROWSPEC = "OutData:%String,InstanceDataID:%String")
{
}

ClassMethod GetISegmentSimpleListExecute(ByRef qHandle As %Binary, episodeId As %String, metaType As %String, valueType As %String, templateId As %String, segmentItemCode As %String, sgSimpleItemCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	s ind=1
	
	quit:($d(episodeId)=0)||(episodeId="")||($d(templateId)=0)||(templateId="")||($d(segmentItemCode)=0)||(segmentItemCode="")||($d(sgSimpleItemCode)=0)||(sgSimpleItemCode="") $$$OK
	
	set blankEpisodeId=" "_episodeId
	set blankTemplateId=" "_templateId
	set blankSegmentItemCode=" "_segmentItemCode
	set blankSgSimpleItemCode=" "_sgSimpleItemCode
	set blankInstanceDataId="" 
	for {
		Set blankInstanceDataId=$O(^DHCEPRI.ISegmentSimpleI("IdxForLink",blankEpisodeId,blankTemplateId,blankSegmentItemCode,blankSgSimpleItemCode,blankInstanceDataId))
		quit:(blankInstanceDataId="")
		
		set itemId=$O(^DHCEPRI.ISegmentSimpleI("IdxForLink",blankEpisodeId,blankTemplateId,blankSegmentItemCode,blankSgSimpleItemCode,blankInstanceDataId,""))
		set itemValue = ..GetISegmentSimpleValue(itemId,metaType,valueType)
		
		//设置返回值
		s instanceID = $e(blankInstanceDataId,2,$L(blankInstanceDataId))	//<added on 2012-3-27>
		set ^CacheTemp(repid, ind) = $LB(itemValue,instanceID)
		s ind = ind + 1
	}
	Quit $$$OK
}

ClassMethod GetISegmentSimpleListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetISegmentSimpleListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetISegmentSimpleListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetISegmentSimpleListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// Desc: 取 ITextDesc 数据
Query GetITextDescList(episodeId As %String, metaType As %String, valueType As %String, templateId As %String, textDescItemCode As %String) As %Query(ROWSPEC = "OutData:%String,InstanceDataID:%String")
{
}

ClassMethod GetITextDescListExecute(ByRef qHandle As %Binary, episodeId As %String, metaType As %String, valueType As %String, templateId As %String, textDescItemCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	s ind=1
	
	quit:($d(episodeId)=0)||(episodeId="")||($d(templateId)=0)||(templateId="")||($d(textDescItemCode)=0)||(textDescItemCode="") $$$OK
	
	set blankEpisodeId=" "_episodeId
	set blankTemplateId=" "_templateId
	set blankTextDescItemCode=" "_textDescItemCode
	set blankInstanceDataId=""
	for {
		set blankInstanceDataId=$O(^DHCEPRI.ITextDescI("IdxForLink",blankEpisodeId,blankTemplateId,blankTextDescItemCode,blankInstanceDataId))
		q:(blankInstanceDataId="")
		
		set itemId=$O(^DHCEPRI.ITextDescI("IdxForLink",blankEpisodeId,blankTemplateId,blankTextDescItemCode,blankInstanceDataId,""))
		set itemValue = ..GetITextDescValue(itemId)
		
		//设置返回值
		s instanceID = $e(blankInstanceDataId,2,$L(blankInstanceDataId))	//<added on 2012-3-27>
		set ^CacheTemp(repid, ind) = $LB(itemValue,instanceID)
		s ind = ind + 1
	}
	Quit $$$OK
}

ClassMethod GetITextDescListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetITextDescListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetITextDescListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetITextDescListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// Desc: 取 ITextDescSimple 数据
Query GetITextDescSimpleList(episodeId As %String, metaType As %String, valueType As %String, templateId As %String, textDescItemCode As %String, textSimpleItemCode As %String, KBNodeId As %String = "", KBPartNo As %String = "") As %Query(ROWSPEC = "OutData:%String,InstanceDataID:%String")
{
}

ClassMethod GetITextDescSimpleListExecute(ByRef qHandle As %Binary, episodeId As %String, metaType As %String, valueType As %String, templateId As %String, textDescItemCode As %String, textSimpleItemCode As %String, KBNodeId As %String = "", KBPartNo As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	set ind=1
	
	quit:($d(episodeId)=0)||(episodeId="")||($d(templateId)=0)||(templateId="")||($d(textDescItemCode)=0)||(textDescItemCode="")||($d(textSimpleItemCode)=0)||(textSimpleItemCode="") ""
	set itemId=""
	set blankEpisodeId=" "_episodeId
	set blankTemplateId=" "_templateId
	set blankTextDescItemCode=" "_textDescItemCode
	set blankTextSimpleItemCode=" "_textSimpleItemCode
	if (KBNodeId '= "")&&(KBPartNo '= "")
	{	
		set blankKBNodeId=" "_KBNodeId
		set blankKBPartNo=" "_KBPartNo
		set blankInstanceDataId=""
		for {
			set blankInstanceDataId=$O(^DHCEPRI.ITextDescSimpleI("IdxForLink",blankEpisodeId,blankTemplateId,blankTextDescItemCode,blankKBNodeId,blankKBPartNo,blankTextSimpleItemCode,blankInstanceDataId))
			quit:(blankInstanceDataId="")
			
			set itemId=$O(^DHCEPRI.ITextDescSimpleI("IdxForLink",blankEpisodeId,blankTemplateId,blankTextDescItemCode,blankKBNodeId,blankKBPartNo,blankTextSimpleItemCode,blankInstanceDataId,""))
			set itemValue = ..GetITextDescSimpleValue(itemId,metaType,valueType)
		
			//设置返回值
			s instanceID = $e(blankInstanceDataId,2,$L(blankInstanceDataId))	//<added on 2012-3-27>
			set ^CacheTemp(repid, ind) = $LB(itemValue,instanceID)
			set ind = ind + 1
		}
	}
	
	Quit $$$OK
}

ClassMethod GetITextDescSimpleListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetITextDescSimpleListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetITextDescSimpleListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetITextDescSimpleListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// Desc: 取知识库中的打散数据
ClassMethod GetKBData(aEpisodeID As %String, aItemPara As %String, ByRef aItemValue As %String, aInList As %List = "", ByRef aOutList As %List = "")
{
	//初始化返回值
	s aItemValue = ""
	
	//校验入参
	q:((aEisodeID="")||(aItemPara=""))
	
	/////////////////////
	//取TextDesc单元的值
	/////////////////////
	
	s curTemplateID = "", curTextDescCode = ""
	
	//解析病历单元参数
	s desc = $p(aItemPara,"#",1)
	s type = $p($p(aItemPara,"#",2),":",2)
	
	
	//根据类型取数据
	if (type = "TextDesc")
	{
		s tid = $p($p(aItemPara,"#",3),":",2)
		s itemCode = $p($p(aItemPara,"#",5),":",2)
		s rowid = ..GetITextDescId(aEpisodeID, tid, itemCode)
		s aItemValue = ..GetITextDescValue(rowid)
		s aItemValue = ..ConvertChar(aItemValue)
		
		s curTemlateID = tid
		s curTextDescCode = itemCode
	}
	elseif (type = "Glossary")
	{
		// 获取术语对应元数据项
		s metaItemStr=##class(EPRmeta.Glossary).GetMetaItem(aGlossaryID)
		q:(metaItemStr="")
	
		// 取元数据项对应打散数据
		s itemCount=$Length(metaItemStr,"^")
		for I = 1:1:itemCount
		{
			s item=$piece(metaItemStr,"^",I)
			if (item = "") continue
			
			set desc=$p(item,"#",1)
			set type=$p($p(item,"#",2),":",2)
			set tid=$p($p(item,"#",3),":",2)
			if (type '= "TextDesc") continue	//只处理E单元
			
			s itemcode=$p($p(item,"#",5),":",2)
			s metatype=$e(itemcode,0,1)
			
			s rowid = ..GetITextDescId(aEpisodeID, tid, itemCode)
			if (rowid = "") continue	//rowid为空说明该单元没有对应打散数据，也就是没有保存过
			
			s aItemValue = ..GetITextDescValue(rowid)
			s aItemValue = ..ConvertChar(aItemValue)
			
			s returnVal=itemValue
			
			s curTemlateID = tid
			s curTextDescCode = itemCode
			
			q
		}
	}
	
	q:(curTemplateID="") returnVal
	
	/////////////////////////////////
	//取TextDesc单元中结构化单元的值
	/////////////////////////////////
	
	s listCount = aInList.Length
	for i = 1:1:listCount
	{
		s itemPara = aInList.GetAt(i)
		if itemPara="" continue 
		
		
		
		
	}
}

/// Desc: 转化回车和换行
ClassMethod ConvertChar(str As %String) As %String
{
	//转换 &EnterKey;
	set count = $Length(str, "&KeyEnter;")
    if count > 1
    {
	    set tmpStr = ""
		for I = 1:1:count
		{
			set tmpStr = tmpStr_$p(str,"&KeyEnter;",I)_$c(13) 
		}
		set str = $extract(tmpStr,1,$Length(tmpStr)-1)
    }
	//转换 &nbsp;
	set count = $Length(outStr, "&nbsp;")
	if count > 1
	{
		set tmpStr=""
		for I = 1:1:count
		{
			set tmpStr = tmpStr_$p(str,"&nbsp;",I)_$c(32)
		}
		set str = $extract(tmpStr,1,$Length(tmpStr)-1)
	}
	
	q str
}

/// Desc:	获取指定术语集范畴下的所有术语值
/// Input：	AEpisodeID : 就诊指针
/// 		ACategoryInternalID : 指定术语集范畴内部标识符
/// Output:	术语值数组
/// Debug:	w ##Class(EPRservice.BOScatterData).GetDataByGlossaryCategory("1","1")
ClassMethod GetDataByGlossaryCategory(AEpisodeID As %String, ACategoryInternalID As %String) As %ArrayOfDataTypes
{
	//判断是旧版还是新版
	s count = ##class(EMRservice.BL.BLScatterData).GetOldRecCount(AEpisodeID)
	if (count<=0)
	{
		s retArray = ##Class(EMRservice.BL.BLScatterData).GetNewDataByGlossaryCategory(AEpisodeID,ACategoryInternalID)
	}
	else
	{
		s glossaryCategoryID = $O(^DHCEPRM.GlossaryCategoryI("IdxOnInternalID"," "_ACategoryInternalID,""))
		q:(glossaryCategoryID="") ""
	
		//s objGlossaryCategory = ##Class(EPRmeta.GlossaryCategory).%OpenId(glossaryCategoryID)
		//q:(glossaryCategoryID="") ""

		s retArray = ##Class(%ArrayOfDataTypes).%New()
	
		s glossaryID = ""
		for {
			s glossaryID = $O(^DHCEPRM.GlossaryI("IdxCategoryID"," "_glossaryCategoryID,glossaryID))
			q:(glossaryID="")
		
			s objGlossary = ##Class(EPRmeta.Glossary).%OpenId(glossaryID)
			continue:(objGlossary="")
		
			s internalID = objGlossary.InternalID
			s value = ##class(EPRservice.BOScatterData).GetScatterDataByGlossaryID(AEpisodeID,glossaryID)
		
			d retArray.SetAt(value, internalID)
		}
	}
	q retArray
}

/// Desc: 	使用术语集取电子病历打散业务标准术语值
/// Return:	metaItemInfo$|value&|metaItemInfo$|value
/// Debug: 	w ##class(EPRservice.BOScatterData).GetStandDataByGlossaryID("35","8")
ClassMethod GetStandDataByGlossaryID(AEpisodeID As %String, AGlossaryID As %String) As %String
{
	s strDataValue = ""
	
	//通过注册号，术语rowId获取业务数据
	s strDataValue = ##class(EPRservice.BOScatterData).GetScatterDataByGlossaryID(AEpisodeID,AGlossaryID)
	
	s objGlossary = ##Class(EPRmeta.Glossary).%OpenId(AGlossaryID)
	//关联标准数据元标识符
	S strMetaID = objGlossary.MetaID
	q:(strMetaID = "")
	//通过数据元标识符取数据元
	s derowID = ""
	s derowID = $o(^DHCEPRM.DataElementI("IdxEntifier"," "_strMetaID,derowID))
	if (derowID = "")
	{
		s derowID = ##Class(EPRmeta.DataElement).SelectByEntifier(strMetaID)
	}
	s strDEVID = ""
	s strFormat = ""
	if (derowID '= "")
	{
		s objCurDataE = ##class(EPRmeta.DataElement).%OpenId(derowID)
		s strDataType = objCurDataE.DataType
		s strFormat = objCurDataE.Format
		//数据元允许值标识符
		s strDEVID = objCurDataE.DEVID
	}
	//判断是否有数据元映射关系
	//strDataValue="" 的时候也需要去取对应关联
	s devCategoryID = ""
	s categroyName = ""
	s MaprowID= ""
	//通过数据元允许值标识符取映射关系
	if ($d(strDEVID) & (strDEVID'="") & ($L(strDEVID) > 1))
	{
		//通过数据元允许值取允许值范畴名字
		s devCategoryID = $o(^DHCEPRM.DEValuesCategoryI("IdxDECVMID"," "_strDEVID,devCategoryID))
		if (devCategoryID '="")
		{
		s objdevCategory = ##class(EPRmeta.DataElementValuesCategory).%OpenId(devCategoryID)
		s categroyName = objdevCategory.Name
		}
		//如果允许值范畴名字为空，则名字等于数据元允许值标识符
		if (categroyName="")
		{
			s categroyName = strDEVID
		}
		//通过数据元 允许值标识符，取关系映射
		for {
			s MaprowID = $o(^DHCEPRM.GlossaryItemMapI("IdxDECVMID"," "_strDEVID,MaprowID))
			if (MaprowID = "")
			{
			   	q	
			}
			s objMap = ##Class(EPRmeta.GlossaryItemMap).%OpenId(MaprowID)
			if (strValueType = "V"){
				s strTempV = objMap.TempDes
				if (strTempV = strDataValue)
				{
					s strDataValue = objMap.DEVDes
					q
				}
			}elseif (strValueType = "C"){
				s strTempV = objMap.TempID
				if (strTempV = strDataValue)
				{
					s strDataValue = objMap.DEVDes
					q
				}
			}
		}
	}
	//判断数据类型
	if ((strDataType'="")&(strDataValue'=""))
	{
		s strDataValue =..GetDataByType(strDataValue,strDataType)
	}
	//判断数据格式
	if ((strFormat'="")&(strDataValue'=""))
	{
	
		s strDataValue = ..GetDataByFormat(strDataValue,strFormat,"1")
		
	}
	q strDataValue
}

/// Desc:	获取指定术语集范畴下的所有标准术语值(仅门诊病历首页使用 20130604 wangwentao update )
/// Input：	AEpisodeID : 就诊指针
/// 		ACategoryInternalID : 指定术语集范畴内部标识符
/// Output:	术语值数组
/// Debug:	w ##Class(EPRservice.BOScatterData).GetStandByGlossaryCategory("1363961","DHCC00.01")
ClassMethod GetStandByGlossaryCategory(AEpisodeID As %String, ACategoryInternalID As %String) As %ArrayOfDataTypes
{
		s retArray = ##Class(%ArrayOfDataTypes).%New()
	//判断是旧版还是新版
	s count = ##class(EMRservice.BL.BLScatterData).GetOldRecCount(AEpisodeID)
	if (count<=0)
	{
		s retArray = ##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(AEpisodeID,ACategoryInternalID)
	}
	else
	{
		s glossaryCategoryID = $O(^DHCEPRM.GlossaryCategoryI("IdxOnInternalID"," "_ACategoryInternalID,""))
		q:(glossaryCategoryID="") ""
	
		s glossaryID = ""
		for {
			s glossaryID = $O(^DHCEPRM.GlossaryI("IdxCategoryID"," "_glossaryCategoryID,glossaryID))
			q:(glossaryID="")
		
			s objGlossary = ##Class(EPRmeta.Glossary).%OpenId(glossaryID)
			continue:(objGlossary="")
			s deName = objGlossary.Name
			s deName = $p(deName," ",2)
			s strInternalID = objGlossary.InternalID
			//关联标准数据元标识符
			S strMetaID = objGlossary.MetaID
			s strDescription = objGlossary.Description
			q:(strMetaID = "")
			//通过数据元标识符取数据元
			s derowID = ""
			s derowID = $o(^DHCEPRM.DataElementI("IdxEntifier"," "_strMetaID,derowID))
			if (derowID = "")
			{
				s derowID = ##Class(EPRmeta.DataElement).SelectByEntifier(strMetaID)
			}
			s strDEVID = ""
			s strFormat = ""
			if (derowID '= "")
			{
				s objCurDataE = ##class(EPRmeta.DataElement).%OpenId(derowID)
				s strDataType = objCurDataE.DataType
				s strFormat = objCurDataE.Format
				//数据元允许值标识符
				s strDEVID = objCurDataE.DEVID
			}
			else
			{
				s strDataType = ""
				s strFormat = ""
				s strDEVID = ""
			}
			//通过术语子集取数据类型
			s itemRowID = ""
			s strValueType = ""
			s itemCode = ""
			s templateID = ""
			s itemRowID = $o(^DHCEPRM.GlossaryItemI("IdxGlossaryID",glossaryID,itemRowID))
			if (itemRowID '= "")
			{
				s objGlossaryItem = ##class(EPRmeta.GlossaryItem).%OpenId(itemRowID)
				s strValueType = objGlossaryItem.ValueType
				s itemCode = objGlossaryItem.ItemCode
				s templateID = objGlossaryItem.TemplateID
			}
			s strDataValue = ""
		
		
			//通过注册号，术语rowId获取业务数据
			s strDataValue = ##class(EPRservice.BOScatterData).GetScatterDataByGlossaryID(AEpisodeID,glossaryID)
		

			//判断是否有数据元映射关系
			//strDataValue="" 的时候也需要去取对应关联
			s devCategoryID = ""
			s sysCode = ""
			s categroyName = ""
			s MaprowID= ""
			//通过数据元允许值标识符取映射关系
			if ($d(strDEVID) & (strDEVID'="") & ($L(strDEVID) > 1))
			{
				//通过数据元允许值取允许值范畴名字
				s devCategoryID = $o(^DHCEPRM.DEValuesCategoryI("IdxDECVMID"," "_strDEVID,devCategoryID))
				if (devCategoryID '="")
				{
				s objdevCategory = ##class(EPRmeta.DataElementValuesCategory).%OpenId(devCategoryID)
				s categroyName = objdevCategory.Name
				}
				//如果允许值范畴名字为空，则名字等于数据元允许值标识符
				if (categroyName="")
				{
					s categroyName = strDEVID
				}
			
				//如果术语集业务数据不为空,则通新索引处理!
				if (strDataValue'="")
				{
					if (strValueType="C")
					{
						s IndexMaprowID = MaprowID
						s MaprowID = $o(^DHCEPRM.GlossaryItemMapI("IdxDECVMIDTempID"," "_strDEVID," "_strDataValue,MaprowID))
						s:(MaprowID="") MaprowID = $o(^DHCEPRM.GlossaryItemMapI("IdxDECVMIDTempID"," "_strDEVID," "_$ZCVT(strDataValue,"U"),IndexMaprowID))
					}
					if (strValueType="V")
					{
						s IndexMaprowID = MaprowID
						s MaprowID = $o(^DHCEPRM.GlossaryItemMapI("IdxDECVMIDTempDes"," "_strDEVID," "_strDataValue,MaprowID))
						s:(MaprowID="") MaprowID = $o(^DHCEPRM.GlossaryItemMapI("IdxDECVMIDTempDes"," "_strDEVID," "_$ZCVT(strDataValue,"U"),IndexMaprowID))
					}
				
					if (MaprowID '= "")
					{		
						s objMap = ##Class(EPRmeta.GlossaryItemMap).%OpenId(MaprowID)
						s strDataValue = objMap.DEVDes
						s sysCode = objMap.DEVID
					}
				}
				/*
				else
				{
					//通过数据元 允许值标识符，取关系映射
					for {
						s MaprowID = $o(^DHCEPRM.GlossaryItemMapI("IdxDECVMID"," "_strDEVID,MaprowID))
						if (MaprowID = "")
						{
						   	q	
						}
						s objMap = ##Class(EPRmeta.GlossaryItemMap).%OpenId(MaprowID)
						if (strValueType = "V"){
							s strTempV = objMap.TempDes
							if (strTempV = strDataValue)
							{
								s strDataValue = objMap.DEVDes
								s sysCode = objMap.DEVID
								q
							}
						}elseif (strValueType = "C"){
							s strTempV = objMap.TempID
							if (strTempV = strDataValue)
							{
								s strDataValue = objMap.DEVDes
								s sysCode = objMap.DEVID
								q
							}
						}
					}
				}
				//*/		
			}
			else
			{
				s:(sysCode="") sysCode = strDataValue
			}
		
			
			//判断数据元数据类型
			if ((strDataType'="")&(strDataValue'=""))
			{
				s strDataValue =..GetDataByType(strDataValue,strDataType)
			}
			//判断数据元数据格式
			if ((strFormat'="")&(strDataValue'=""))
			{
				if (sysCode'=""){
				s sysCode = ..GetDataByFormat(sysCode,strFormat,"1")
				}
				else
				{
					s strDataValue = ..GetDataByFormat(strDataValue,strFormat,"1")
				}
			}
		
		
			//处理日期数据类型
			if ((strValueType'="")&(itemCode'="")&(strDataValue'=""))
			{
				if ($e(itemCode,1,1)="D")
				{
					s:(strValueType="C") sysCode= $zdt($zdth(strDataValue,3,1),3,1)
					s:(strValueType="YMD") sysCode= $zd($zdh(strDataValue,3),3)
				}
			}
		
			//处理按ValueType返回结果
			s strDataValues = $s(strValueType="V":strDataValue,strValueType="C":sysCode,strValueType="YMD":sysCode,1:"")

			//w glossaryID_" "_strDescription_"		:"_strDataValues,!
		
			d retArray.SetAt(strDataValues, strInternalID)
		}
	}
	q retArray
}

/// Desc:	获取指定术语集范畴下的所有标准术语值
/// Input：	AEpisodeID : 就诊指针
/// 		ACategoryInternalID : 指定术语集范畴内部标识符
/// Output:	术语值数组
/// Debug:	w ##Class(EPRservice.BOScatterData).GetStandDataByGlossaryCategory("35","HDSD00.11")
ClassMethod GetStandDataByGlossaryCategory(AEpisodeID As %String, ACategoryInternalID As %String) As %ArrayOfDataTypes
{
	s glossaryCategoryID = $O(^DHCEPRM.GlossaryCategoryI("IdxOnInternalID"," "_ACategoryInternalID,""))
	q:(glossaryCategoryID="") ""

	s retArray = ##Class(%ArrayOfDataTypes).%New()
	
	s glossaryID = ""
	for {
		s glossaryID = $O(^DHCEPRM.GlossaryI("IdxCategoryID"," "_glossaryCategoryID,glossaryID))
		q:(glossaryID="")
		
		s objGlossary = ##Class(EPRmeta.Glossary).%OpenId(glossaryID)
		continue:(objGlossary="")
		s deName = objGlossary.Name
		s deName = $p(deName," ",2)
		s strInternalID = objGlossary.InternalID
		//关联标准数据元标识符
		S strMetaID = objGlossary.MetaID
		s strDescription = objGlossary.Description
		q:(strMetaID = "")
		//通过数据元标识符取数据元
		s derowID = ""
		s derowID = $o(^DHCEPRM.DataElementI("IdxEntifier"," "_strMetaID,derowID))
		if (derowID = "")
		{
			s derowID = ##Class(EPRmeta.DataElement).SelectByEntifier(strMetaID)
		}
		s strDEVID = ""
		s strFormat = ""
		if (derowID '= "")
		{
			s objCurDataE = ##class(EPRmeta.DataElement).%OpenId(derowID)
			s strDataType = objCurDataE.DataType
			s strFormat = objCurDataE.Format
			//数据元允许值标识符
			s strDEVID = objCurDataE.DEVID
		}
		//通过术语子集取数据类型
		s itemRowID = ""
		s strValueType = ""
		s itemCode = ""
		s templateID = ""
		s itemRowID = $o(^DHCEPRM.GlossaryItemI("IdxGlossaryID",glossaryID,itemRowID))
		if (itemRowID '= "")
		{
			s objGlossaryItem = ##class(EPRmeta.GlossaryItem).%OpenId(itemRowID)
			s strValueType = objGlossaryItem.ValueType
			s itemCode = objGlossaryItem.ItemCode
			s templateID = objGlossaryItem.TemplateID
		}
		s strDataValue = ""
		
		//通过注册号，术语rowId获取业务数据
		s strDataValue = ##class(EPRservice.BOScatterData).GetScatterDataByGlossaryID(AEpisodeID,glossaryID)
		
		//判断是否有数据元映射关系
		//strDataValue="" 的时候也需要去取对应关联
		s devCategoryID = ""
		s sysCode = ""
		s categroyName = ""
		s MaprowID= ""
		//通过数据元允许值标识符取映射关系
		if ($d(strDEVID) & (strDEVID'="") & ($L(strDEVID) > 1))
		{
			//通过数据元允许值取允许值范畴名字
			s devCategoryID = $o(^DHCEPRM.DEValuesCategoryI("IdxDECVMID"," "_strDEVID,devCategoryID))
			if (devCategoryID '="")
			{
			s objdevCategory = ##class(EPRmeta.DataElementValuesCategory).%OpenId(devCategoryID)
			s categroyName = objdevCategory.Name
			}
			//如果允许值范畴名字为空，则名字等于数据元允许值标识符
			if (categroyName="")
			{
				s categroyName = strDEVID
			}
			//通过数据元 允许值标识符，取关系映射
			for {
				s MaprowID = $o(^DHCEPRM.GlossaryItemMapI("IdxDECVMID"," "_strDEVID,MaprowID))
				if (MaprowID = "")
				{
				   	q	
				}
				s objMap = ##Class(EPRmeta.GlossaryItemMap).%OpenId(MaprowID)
				if (strValueType = "V"){
					s strTempV = objMap.TempDes
					if (strTempV = strDataValue)
					{
						s strDataValue = objMap.DEVDes
						s sysCode = objMap.DEVID
						q
					}
				}elseif (strValueType = "C"){
					s strTempV = objMap.TempID
					if (strTempV = strDataValue)
					{
						s strDataValue = objMap.DEVDes
						s sysCode = objMap.DEVID
						q
					}
				}
			}
		}
		//判断数据类型
		if ((strDataType'="")&(strDataValue'=""))
		{
			s strDataValue =..GetDataByType(strDataValue,strDataType)
		}
		//判断数据格式
		if ((strFormat'="")&(strDataValue'=""))
		{
			if (sysCode'=""){
			s sysCode = ..GetDataByFormat(sysCode,strFormat,"1")
			}
			else
			{
				s strDataValue = ..GetDataByFormat(strDataValue,strFormat,"1")
			}
		}
		if ((sysCode = "")&(strDataValue'=""))
		{
			s sysCode = strDataValue
			s strDataValue = " "
		}
		/*
		if (strValueType = "V")
		{
			s strDataValues = strDataValue
		}
		if (strValueType = "C")
		{
			s strDataValues = sysCode
		}
		if (strValueType = "")
		{
			s strDataValues = strDataValue _"^"_sysCode
		}*/
		s strDataValues = strDataValue _"^"_sysCode
		//w strInternalID _"^"_strDataValues,!
		d retArray.SetAt(strDataValues, strInternalID)
	}
	
	q retArray
}

/// Desc:根据数据类型进行标准转换
/// strDataValue 1，数据值，2:strDataType，数据类型
/// w ##Class(EPRservice.BOScatterData).GetDataByType("G63","N")
ClassMethod GetDataByType(strDataValue As %String, strDataType As %String) As %String
{
	//为数字类型时，转换为数字
	if (strDataType = "N")
	{
		s strDataValue = +strDataValue
	}
	q strDataValue
}

/// Desc:根据数据格式进行标准转换
///  1:strDataValue业务数据值，2:strFormat为schemas样式转换格式，3strMark为标示：1为转换为包含T的时间格式，2为转换为不包含T的时间格式
/// w ##Class(EPRservice.BOScatterData).GetDataByFormat("1823-1-2 12:2:23","D8","1")
ClassMethod GetDataByFormat(strDataValue As %String, strFormat As %String, strMark As %String) As %String
{
	//将包含年月日日期格式转换为yyyy-mm-dd
	if ((strDataValue [ "年") &(strDataValue [ "月") &(strDataValue [ "日"))
	{
		if $L(strDataValue," ") = 2
		{
			s strdatat = $p(strDataValue," ",1)
			s strdatats = $p(strDataValue," ",2)
			s year = $p(strdatat,"年",1)
			s moth = $p($p(strdatat,"年",2),"月",1)
			s date = $p($p($p(strdatat,"年",2),"月",2),"日",1)
			s strDataValue = year_"-"_moth_"-"_date_" "_strdatats
		}
		else
		{
			s year = $p(strDataValue,"年",1)
			s moth = $p($p(strDataValue,"年",2),"月",1)
			s date = $p($p($p(strDataValue,"年",2),"月",2),"日",1)
			s strDataValue = year_"-"_moth_"-"_date
		}
	}
	
	
		
	//对D8，T8的数据进行标准转换
	if (strFormat [ "D8" ) || (strFormat [ "T8") 
	{
		if $L(strDataValue," ") = 2
		{
			s strDataValue = $p(strDataValue," ",1)_" "_$ZTime($ZTimeH($p(strDataValue," ",2)))
			s strDataValue = $p(strDataValue," ",1)
		}
		if ((strDataValue [ "年") &(strDataValue [ "月") &(strDataValue [ "日"))
		{
			s year = $p(strDataValue,"年",1)
			s moth = $p($p(strDataValue,"年",2),"月",1)
			s date = $p($p($p(strDataValue,"年",2),"月",2),"日",1)
			s strDataValue = year_"-"_moth_"-"_date
		}
		s datev = $ZDATEH(strDataValue,8)
		s strDataValue =$ZDATE(datev,8)
	}
	//对d6，t6的数据进行标准转换
	elseif (strFormat [ "T6") ||  (strFormat [ "D6") 
	{
		if (strDataValue [ " ")
		{
			s strDataValue = $p(strDataValue," ",1)_" "_$ZTime($ZTimeH($p(strDataValue," ",2)))
			s strDataValue = $p(strDataValue," ",2)
		}
		
		if (strDataValue [ ":") & ($l(strDataValue,":") = 3)
		{
			s strDataValue = $p(strDataValue,":",1)_$p(strDataValue,":",2)_$p(strDataValue,":",3)
		}else
		{
			s strDataValue = " "
		}
		
	}
	//对dt15，t15的数据进行标准转换
	elseif (strFormat [ "DT15") || (strFormat [ "T15") 
	{
		if ((strDataValue [ "时")&(strDataValue [ "分"))
		{
			s strDataValue = $replace(strDataValue,"时",":")
			s strDataValue = $replace(strDataValue,"分","")
		}
		
		if (strDataValue [ " ")
		{
			s strDataValue = $p(strDataValue," ",1)_" "_$ZTime($ZTimeH($p(strDataValue," ",2)))
		}
		//转换为包含T的时间格式(schemas样式需要)
		if (strMark = "1")
		{
			if (strDataValue [ " ")
			{
				s strdate = $ZDATEH($P(strDataValue," ",1),8)
				s DataV =$ZDATE(strdate,8)
				s strtime = $p(strDataValue," ",2)
				s timev = "000000"
				if (strtime [ ":") & ($l(strtime,":") = 3)
				{
				s timev = $p(strtime,":",1)_$p(strtime,":",2)_$p(strtime,":",3)
				}
				s strDataValue = DataV_ "T" _timev
			
			}
			elseif(strDataValue [ ":") & ($l(strDataValue,":") = 3)
			{
				
				
				s timev = $p(strDataValue,":",1)_$p(strDataValue,":",2)_$p(strDataValue,":",3)
				s strDataValue = 0_ "T" _timev
			}
		   else
		   {
		       if ((strDataValue ="─")||(strDataValue ="-"))   //
		       {
			     s strDataValue = "" 
		       }
			   else
			   {
					s strdate = $ZDateH($P(strDataValue," ",1),8)
					s DataV =$ZDATE(strdate,8)
					s strDataValue = DataV_ "T" _"000000"
				}
			}
		}
		//转换为不包含T的时间格式
		elseif(strMark = "2")
		{
			if (strDataValue [ " ")
			{
				s strdate = $ZDATEH($P(strDataValue," ",1),8)
				s DataV =$ZDATE(strdate,8)
				s strtime = $p(strDataValue," ",2)
				s timev = "000000"
				if (strtime [ ":") & ($l(strtime,":") = 3)
				{
					s timev = $p(strtime,":",1)_$p(strtime,":",2)_$p(strtime,":",3)
				}
				s strDataValue = DataV_ "" _timev
			}
			else
			{
				if (strDataValue [ ":") & ($l(strDataValue,":") = 3)
				{
					s timev = $p(strDataValue,":",1)_$p(strDataValue,":",2)_$p(strDataValue,":",3)
					s strDataValue = 0_ "" _timev
				}
				else
				{
					s strdate = $ZDateH($P(strDataValue," ",1),8)
					s DataV =$ZDATE(strdate,8)
					s strDataValue = DataV_ "" _"000000"
				}
			}
		}
	}
	//对AN类型的数据转换
	elseif (strFormat [ "AN") 
	{
		S strDataValue = ..GetDataByAN(strDataValue,strFormat,"AN")
		
	}
	//对A类型的数据转换
	elseif (strFormat [ "A")
	{
		S strDataValue = ..GetDataByAN(strDataValue,strFormat,"A")
	}
	//对N类型的数据转换
	elseif (strFormat [ "N")
	{
		S strDataValue = ..GetDataByAN(strDataValue,strFormat,"N")
	}
	q strDataValue
}

/// Desc:数据标准转换byAN
///  w ##Class(EPRservice.BOScatterData).GetDataByAN("2134233443","AN4..8","AN")
ClassMethod GetDataByAN(strDataValue As %String, strFormat As %String, strMake As %String) As %String
{

	//固定长度
	s length = 0
	//可变长度最小值
	s chageS = 0
	//可变长度最大值
	s chageE = 0
	//行数值
	s strXE = 0
	//小数点位数值
	s strPE = 0
	//N类型固定长度前面填充0串
	s strFixL = ""
	//包含有".."情况
	if (strFormat [ "..") 
	{
		s strvs = $p(strFormat,strMake,2)
		s chageS = $p(strvs,"..",1)
		s strvs = $p(strvs,"..",2)
		//包含有"X",".."情况
		if (strvs [ "X")
		{ 
			s strXE = $p(strvs,"X",2)
			s chageE = $P(strvs,"X",1)
		} 
		//包含有",",".."情况
		elseif (strvs [ ",")
		{
			s strPE = $p(strvs,",",2)
			s chageE = $P(strvs,",",1)
		}
		//只包含".."情况
		else
		{
			s chageE = strvs
		}
	}
	//包含有","，不包含".."情况
	elseif (strFormat [ ",") 
	{
		s strvs = $p(strFormat,",",1)
		s length = $p(strvs,strMake,2)
		s strPE = $p(strFormat,",",2)
		
	}
	//包含有"X"，不包含".."情况
	elseif (strFormat [ "X") 
	{ 
		s strvs = $p(strFormat,"X",1)
		s length = $p(strvs,strMake,2)
		s strXE = $p(strFormat,"X",2)
	}
	//固定长度情况
	else
	{
		s length = $p(strFormat,strMake,2)
	}

	s strpvalue = "."
	if (strPE'=0)
	{
		for int=1:1:strPE
		{
			S strpvalue = strpvalue_"0"
		}
	}
	
	//不包含有".."情况
	if (length '= 0) 
	{
		if (strXE '=0)
		{
			if $l(strDataValue) > (strXE * length)
			{
				s strDataValue = $e(strDataValue,0,strXE * length)
			}
		}
		elseif (strPE '=0)
		{
			if (strDataValue '[ ".")
			{
				s strDataValue = strDataValue_strpvalue
			}
			else
			{
				s nowPe = $L($p(strDataValue,".",2))
				if (strPE>nowPe)
				{
					S strpvalue = ""
					for int=1:1:(strPE-nowPe)
					{
						S strpvalue = strpvalue_"0"
					}
					s strDataValue = strDataValue_strpvalue
				}
				else
				{
					s strPbef = $p(strDataValue,".",1)
					if ($L(strPbef)=0)
					{
					s strPbef = 0
					}
					s strPaft = $p(strDataValue,".",2)
					s strPaft =  $e(strPaft,0,strPE)
					s strDataValue = strPbef_"."_strPaft
				}
			}
			if ($l(strDataValue) >= length)
			{
				s strDataValue = $e(strDataValue,0,length)
			}
			
		}
		else{
			if ($l(strDataValue) >= length)
			{
				s strDataValue = $e(strDataValue,0,length)
			}
			else
			{
				/*
				if (strMake = "N")
				{
					s strFixL = ""
				
					for int=1:1:(length-$l(strDataValue))
					{
						S strFixL = strFixL_"0"
					}
					s strDataValue = strFixL_strDataValue
				}
				*/
			}
		}
	}
	//包含有".."情况
	else  
	{
		if (strXE '=0)
		{
			if ($l(strDataValue) > (chageE*strXE))
			{
				s strDataValue = $e(strDataValue,0,chageE*strXE)
			}
		}
		elseif (strPE '=0)
		{
			if (strDataValue '[ ".")
			{
				s strDataValue = strDataValue_strpvalue
			}
			else
			{
				s nowPe = $L($p(strDataValue,".",2))
				if (strPE>nowPe)
				{
					S strpvalue = ""
					for int=1:1:(strPE-nowPe)
					{
						S strpvalue = strpvalue_"0"
					}
					s strDataValue = strDataValue_strpvalue
				}
				else
				{
					s strPbef = $p(strDataValue,".",1)
					if ($L(strPbef)=0)
					{
					s strPbef = 0
					}
					s strPaft = $p(strDataValue,".",2)
					s strPaft =  $e(strPaft,0,strPE)
					s strDataValue = strPbef_"."_strPaft
				}
			}
			if ($l(strDataValue) >= chageE)
			{
				s strDataValue = $e(strDataValue,0,chageE)
			}
			
		}
		else{
			if ($l(strDataValue) >= (chageE))
			{
				s strDataValue = $e(strDataValue,0,chageE)
			}
		}
	}
	q strDataValue
}

/// Desc:	获取指定术语值
/// Input：	AEpisodeID : 就诊指针
/// 		AGlossaryInternalID : 指定术语内部标识符
/// Output:	术语值
/// Debug:	w ##Class(EPRservice.BOScatterData).GetDataByGlossary("201869","HDSD00.11.050")
ClassMethod GetDataByGlossary(AEpisodeID As %String, AGlossaryInternalID As %String, AInstanceID As %String) As %String
{

	 q:(AEpisodeID="")||(AGlossaryInternalID="")||(AInstanceID="") ""

	 s value = ""
	 s glossaryID = ""

	 For
	 {

		  s glossaryID = $O(^DHCEPRM.GlossaryI("IdxGlossaryID"," "_AGlossaryInternalID,glossaryID))

		  q:(glossaryID="")

		  s value = ##class(EMRservice.BL.BLScatterData).GetNewScatterDataByGlossaryID(AEpisodeID,glossaryID,AInstanceID)

		  q:(value'="")

	 }

	 q value
}

/// ------------- 以下方法已停用 ---------------
/// 
/// 根据原数据编码规则到不同的打散结构里去取数据。
/// 返回值：若未保存过，返回Nulll; 若已保存过，返回rowId^DataValue
///         对于TableSimpleItem，若有多行，返回 rowId1^DataValue1#rowId2^DataValue2
ClassMethod GetValueFacade(aEpisodeID As %String, aTemplateID As %String, aSampleItemCode As %String) As %String
{
	//b "s"
	s outStr="Null"
	
	///若为G单元、E单元或T单元的内嵌单元
	if aSampleItemCode["."  
	{
		s ParentCode=$p(aSampleItemCode,".",1)
		s SubItemCode=$p(aSampleItemCode,".",2)
		if $e(ParentCode,0,1)="G"
		{
			s itemId = ..GetISegmentSimpleId(aEpisodeID,aTemplateID,ParentCode,SubItemCode)
			q:itemId="" outStr
			s obj = ##class(EPRinstance.ISegmentSimple).%OpenId(itemId)
			if obj'=""
			{
				s outStr = itemId_"^"_obj.DataValue
			}
		}
		elseif $e(ParentCode,0,1)="E"
		{
			s itemId = ..GetITextDescSimpleId(aEpisodeID,aTemplateID,ParentCode,SubItemCode)
			q:itemId="" outStr
			s obj = ##class(EPRinstance.ITextDescSimple).%OpenId(itemId)
			if obj'=""
			{
				s outStr = itemId_"^"_obj.DataValue
			}
		}
		elseif $e(ParentCode,0,1)="T"
		{
			s itemId = ..GetITableSimpleId(aEpisodeID,aTemplateID,ParentCode,SubItemCode)
			q:itemId="" outStr
			s count=$length(itemId,"|")
			for I=1:1:count
			{
				s tmpItemId=$p($P(itemId,"|",I),"^",2)
				s obj = ##class(EPRinstance.ITableSimple).%OpenId(tmpItemId)
				if obj'=""
				{
					if outStr="Null"
					{s outStr = tmpItemId_"^"_obj.DataValue}
					else
					{s outStr=outStr_"#"_tmpItemId_"^"_obj.DataValue}
				}
			}
		}

	}
	///若为非内嵌单元
	elseif aSampleItemCode'["." 
	{
		if $e(aSampleItemCode,0,1)="G"
		{
			s itemId = ..GetISegmentId(aEpisodeID,aTemplateID,aSampleItemCode)
			s itemValue = ..GetISegmentValue(itemId)
			if itemId '=""
			{
				s outStr = itemId_"^"_itemValue
			}
		}
		elseif $e(aSampleItemCode,0,1)="E"
		{
			s itemId = ..GetITextDescId(aEpisodeID,aTemplateID,aSampleItemCode)
			s itemValue = ..GetITextDescValue(itemId)
			if itemId'=""
			{
				s outStr = itemId_"^"_itemValue
			}
		}
		elseif $e(aSampleItemCode,0,1)="Y"
		{	
			/// do nothing
		}
		else
		{	
			s itemId = ..GetISimpleId(aEpisodeID,aTemplateID,aSampleItemCode)
			q:itemId="" outStr
			s obj = ##class(EPRinstance.ISimple).%OpenId(itemId)
			if obj'=""
			{
				s outStr=itemId_"^"_obj.DataValue
			}
		}
	}
	
	q outStr
}

/// ------------- 以下为测试方法 ---------------
/// 
/// 电子病历取数接口
/// 参数：在 维护程序 ->  设置 -> 导出数据 中取得
/// 返回值格式：界面模板元数据	Value
/// 			术语			metaItemInfo$|Value&|metaItemInfo$|Value
/// w ##class(EPRservice.BOScatterData).Test()
ClassMethod Test()
{
	//w "name: "_##class(EPRservice.BOScatterData).GetEPRData("49","初诊病史.一般情况主诉现病史 既往史.一般情况.儿科病历.姓名：#TYPE:Simple#TID:2#TVER:0#SCODE:S0016#VTYPE:V")
	//w !, "loc: "_##class(EPRservice.BOScatterData).GetEPRData("49","初诊病史.一般情况主诉现病史 既往史.一般情况.儿科病历.科室：#TYPE:Simple#TID:2#TVER:0#SCODE:I0013#VTYPE:V")
	//w !, "admtime: "_##class(EPRservice.BOScatterData).GetEPRData("49","初诊病史.一般情况主诉现病史 既往史.一般情况.儿科病历.入院时间：#TYPE:Simple#TID:2#TVER:0#SCODE:D0022#VTYPE:V")
	//w !, "可靠程度: "_##class(EPRservice.BOScatterData).GetEPRData("49","初诊病史.一般情况主诉现病史 既往史.一般情况.儿科病历.可靠程度：#TYPE:Simple#TID:2#TVER:0#SCODE:O0026#VTYPE:V")
	//w !, "病史叙述者G: "_##class(EPRservice.BOScatterData).GetEPRData("49","初诊病史.一般情况主诉现病史 既往史.一般情况.儿科病历.病史叙述者：#TYPE:Segment#TID:2#TVER:0#GCODE:G0028")
	//w !, "病史叙述着GM: "_##class(EPRservice.BOScatterData).GetEPRData("49","初诊病史.一般情况主诉现病史 既往史.一般情况.儿科病历.病史叙述者：.病史叙述者#TYPE:SegmentSimple#TID:2#TVER:0#TCODE:G0028#SCODE:M0029#VTYPE:V")
	//w !, "病史叙述着GS: "_##class(EPRservice.BOScatterData).GetEPRData("49","初诊病史.一般情况主诉现病史 既往史.一般情况.儿科病历.病史叙述者：.姓名#TYPE:SegmentSimple#TID:2#TVER:0#TCODE:G0028#SCODE:S0042#VTYPE:V")
	;w !, "主诉E: "_##class(EPRservice.BOScatterData).GetEPRData("49","初诊病史.一般情况主诉现病史 既往史.主诉.妇科.主诉#TYPE:TextDesc#TID:28#TVER:0#ECODE:E0002")
	w "初潮: "_##class(EPRservice.BOScatterData).GetEPRData(65,"#TYPE:SegmentSimple#TID:104#TVER:0#TCODE:G0094#SCODE:L0118#VTYPE:V")
	//w ##class(EPRservice.BOScatterData).GetEPRData("49","")
}

///  w ##Class(EPRservice.BOScatterData).Test2("65","主诉#TYPE:TextDesc#TID:31#TVER:0#ECODE:E0001")
ClassMethod Test2(adm, itemPara)
{
	s rset = ..GetEPRDataList(adm,itemPara)
	q:(rset="") ""
	
	Set columns = rset.GetColumnCount()
	While (rset.Next()) {
		Write "------------------------",!
	 	For col = 1:1:columns 
	 	{
	 		Write rset.GetColumnName(col),": "
	 		Write rset.GetData(col),!
	 	}
	 	Write "------------------------"
	}
}

}
