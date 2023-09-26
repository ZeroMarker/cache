/// 描述：电子病历术语信息查询业务对象
/// 创建者：Candyxu
/// 创建日期：2012-03-12
Class EPRservice.BLL.Query.BLGlossaryInfo Extends EPRservice.BLL.Query.BLEPRInfo [ ClassType = "", LegacyInstanceContext, ProcedureBlock ]
{

/// Desc:	实例化业务逻辑对象
/// Debug:	w ##Class(EPRservice.BLL.Query.BLGlossaryInfo).CreateInstance()
ClassMethod CreateInstance(AEpisodeID As %String) As EPRservice.BLL.Query.BLEPRInfo
{
	s obj = ##Class(EPRservice.BLL.Query.BLGlossaryInfo).%New()
	s obj.EpisodeID = AEpisodeID
	q obj
}

/// Desc 查询术语中各单元模板
Method GetGlossaryData(AItemPara As %String) As %String
{
	s retVal = ""
	s AEpisodeID = %this.EpisodeID
	//////////////////////////////////////////////////////////////////////////////////////////////
	///                                          修改段落start							//////////
	//////////////////////////////////////////////////////////////////////////////////////////////
	//病历查询项目，维护术语集查询时需要将Code字段维护成内部标识符"HDSD*"，但是早起有一些可能维护成的术语集ID
	if (AItemPara [ "HDSD")
	{
		s length = $L(AItemPara,"#")
		if (length = 2)
		{
			s AGlossaryCateID = $P(AItemPara,"#",1)
			s AInternalID = $P(AItemPara,"#",2)
			s AGlossaryID =$o(^DHCEPRM.GlossaryI("IdxInternalID"," "_AInternalID,AGlossaryCateID,""))
		}
		else
		{
			s AGlossaryCateID = $o(^DHCEPRM.GlossaryI("IdxInternalID"," "_AItemPara,""))  //此索引不唯一，入院记录、24小时入出院记录中的主诉的InternalID一样，所以如果术语集里面都维护对照了，则取不到准确的主诉数据，只能取到索引下第一个
			s AGlossaryID =$o(^DHCEPRM.GlossaryI("IdxInternalID"," "_AItemPara,AGlossaryCateID,""))
		}
		//有的项目维护术语集时，上面取到的GlossaryCateID就是GlossaryID，再根据GlossaryID去取，出来为空值，所以增加下面一句代码
		s:(AGlossaryID="") AGlossaryID = AGlossaryCateID
	}
	else
	{
		s AGlossaryID = AItemPara
	}
	  
	//////////////////////////////////////////////////////////////////////////////////////////////
	///                                          修改段落end							//////////
	//////////////////////////////////////////////////////////////////////////////////////////////
	q:($d(AGlossaryID) = 0)||(AGlossaryID = "") retVal
	
	s objGlossary = ##Class(EPRmeta.Glossary).%OpenId(AGlossaryID)
	q:(objGlossary = "") retVal
	
	s name = objGlossary.Name
	s type = objGlossary.GlossaryType
	if ($zcvt(type,"U") = "TG")
	{
		s rowID = ""
		for {
			s rowID = $o(^DHCEPRM.GlossaryItemI("IdxGlossaryID",AGlossaryID,rowID))
			q:(rowID = "")
			
			s objItem = ##Class(EPRmeta.GlossaryItem).%OpenId(rowID)
			//////////////////////////////////////////////////////////////////////////////////////////////
			///                                          修改段落start							//////////
			//////////////////////////////////////////////////////////////////////////////////////////////
			if (objItem.TemType="NEW"){
				s InstanceIDS="",tmpInstanceID="",templateCategoryID=""				
				s categoryid=objGlossary.GlossaryCategoryID
				//通过术语集目录获取关联的模板ID
				s objGlossaryCategory =  ##Class(EPRmeta.GlossaryCategory).%OpenId(categoryid)
				q:(objGlossaryCategory="")
				s CategoryInternalID = objGlossaryCategory.InternalID
				s templateCategoryID =##Class(EMRservice.BL.BLScatterData).GetGlossaryTemplateIDS(CategoryInternalID)
				if (templateCategoryID="")
				{
					s templateCategoryID = objGlossaryCategory.TemplateCategroyID
				}
				s InstanceIDS = ##Class(EMRservice.BL.BLScatterData).GetInstanceIDByTInterID(AEpisodeID,templateCategoryID,CategoryInternalID)

				if (InstanceIDS="")
				{
					s retVal="Null" 
					continue
				}
				s tmpInstanceID=$listget(InstanceIDS,1)
				s retVal=##class(EMRservice.BL.BLScatterData).GetNewScatterDataByGlossaryID(AEpisodeID,AGlossaryID,tmpInstanceID)
				
			}
			else {
			s itemCode = objItem.ItemCode
			s valueType = objItem.ValueType
			s templateID = objItem.TemplateID
			
			s NewCode = ..GetGlossaryCode(itemCode,templateID,valueType)
			s retVal = ..GetItemData(NewCode)
			}
			//////////////////////////////////////////////////////////////////////////////////////////////
			///                                          修改段落end							//////////
			//////////////////////////////////////////////////////////////////////////////////////////////
			q:(retVal '= "")&&(retVal '= "Null")
		}	
	}
	else
	{
		s parGlossaryID = objGlossary.ParentID
		q:(parGlossaryID = "") retVal

		s objParGlossary = ##Class(EPRmeta.Glossary).%OpenId(parGlossaryID)
		q:(objParGlossary = "") retVal
		
		s parRowID = ""
		for {
			s parRowID = $o(^DHCEPRM.GlossaryItemI("IdxGlossaryID",parGlossaryID,parRowID))
			q:(parRowID = "")
			
			s objParItem = ##Class(EPRmeta.GlossaryItem).%OpenId(parRowID)
			s parItemCode = objParItem.ItemCode
			s parValueType = objParItem.ValueType
			s parTemplateID = objParItem.TemplateID

			//取 EPRinstance.InstanceData ID
			s instanceDataID = ""
			s instanceDataID = ..GetCachedInstanceID(parTemplateID)
			if (instanceDataID = "")
			{
				s instanceDataID = $O(^DHCEPRI.ITextDescI("IdxForLink"," "_%this.EpisodeID," "_parTemplateID," "_parItemCode,""))
				d ..SetCachedInstanceID(instanceDataID, parTemplateID)
			}
			continue:(instanceDataID = "")||(instanceDataID = "UnSave")
			s kbNodeID = ""
			for {
				s kbNodeID = $o(^DHCEPRI.ITextDescSimpleI("IdxForUpdate",instanceDataID," "_parItemCode,kbNodeID))
				q:(kbNodeID = "")

				s kbPartNo = ""
				for {
					s kbPartNo = $o(^DHCEPRI.ITextDescSimpleI("IdxForUpdate",instanceDataID," "_parItemCode,kbNodeID,kbPartNo))
					q:(kbPartNo = "")

					s curItemCode = ""
					for {
						s curItemCode = $o(^DHCEPRI.ITextDescSimpleI("IdxForUpdate",instanceDataID," "_parItemCode,kbNodeID,kbPartNo,curItemCode))
						q:(curItemCode = "")
						//当前单元是否为数据集中的单元
						s curValueType = $o(^DHCEPRM.GlossaryKBItemI("IdxComposite",AGlossaryID,$tr(kbNodeID," ",""),$tr(kbPartNo," ",""),curItemCode,""))
						continue:(curValueType = "")
						//取 EPRinstance.ITextDescSimple ID							
						s rowid = $O(^DHCEPRI.ITextDescSimpleI("IdxForLink"," "_AEpisodeID," "_parTemplateID," "_parItemCode,kbNodeID,kbPartNo,curItemCode,instanceDataID, ""))
						q:(rowid = "")
	
						//取 EPRinstance.ITextDescSimple 数据
						s obj = ##Class(EPRinstance.ITextDescSimple).%OpenId(rowid)
						q:(obj = "")
							
						s AVType = $e(curValueType,2,$L(curValueType)) 
						s retVal = ..GetDataValue(AVType,obj.DataValue,obj.ValueCode)	
					}	
				}	
			}			
		}
	}
	
	s:(retVal="Null") retVal = ""
	s retVal = ..ConvertChar(retVal)
	q retVal
}

/// desc: 格式化Glossarycode
/// creator: Candyxu
ClassMethod GetGlossaryCode(ItemCode As %String, Tid As %String, Vtype As %String) As %String
{
	s Tver = 0
	s Result = ""
	//判断单元类型
	i $F("SNOMQDIP",$E(ItemCode,1)) '= 0{
		s Type = "Simple"
		s Result = "#TYPE:"_Type_"#TID:"_Tid_"#TVER:"_Tver_"#SCODE:"_ItemCode_"#VTYPE:"_Vtype
				   
	} elseif $F("G",$E(ItemCode,1)) '= 0{
		if $F(ItemCode,".") '= 0 { 
			s Type = "SegmentSimple" 
			s Tcode = $p(ItemCode,".",1)
			s Scode = $p(ItemCode,".",2)
			s Result = "#TYPE:"_Type_"#TID:"_Tid_"#TVER:"_Tver_"#TCODE:"_Tcode_"#SCODE:"_Scode_"#VTYPE:"_Vtype	   
		} else {
			s Type = "Segment"
			s Result = "#TYPE:"_Type_"#TID:"_Tid_"#TVER:"_Tver_"#GCODE:"_ItemCode
					   
		}
	} elseif $F("E",$E(ItemCode,1)) '= 0{
		if $F(ItemCode,".") = 0 {
			s Type = "TextDesc"
			s Result = "#TYPE:"_Type_"#TID:"_Tid_"#TVER:"_Tver_"#ECODE:"_ItemCode					   
		}				   
	}
	q Result
}

}
