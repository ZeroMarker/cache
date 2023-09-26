/// Desc:       保存打散数据
/// Creator:    Candyxu
/// CreateDate: 2014-7-1
Class EMRservice.BL.BLScatterData Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       解析打散的数据
/// Creator:    Candyxu
/// CreateDate: 2014-7-1
/// Input:      AScatterData 反序列化的打散Data
///             AInstanceID 实例数据ID
///             AKey 唯一识别码 
ClassMethod BuildIndexData(AScatterData As EMRservice.Parser.NIScatterData, AInstanceID As %String, AKey As %String)
{
	s count = AScatterData.Sections.Count()
	for i=1:1:count
	{
		s sctionCode = $zcvt(AScatterData.Sections.GetAt(i).Code,"U")
		s ^CacheTempEMRScatterData(AKey,"tmpNewSection",AInstanceID,sctionCode)= AScatterData.Sections.GetAt(i).Text
		s ^CacheTempEMRScatterData(AKey,"tmpNewSection",AInstanceID,sctionCode,"StyleText")= AScatterData.Sections.GetAt(i).StyleText
		s ccount = AScatterData.Sections.GetAt(i).Composites.Count()
		for j=1:1:ccount
		{
			s compsiteCode = $zcvt(AScatterData.Sections.GetAt(i).Composites.GetAt(j).Code,"U")
			s ^CacheTempEMRScatterData(AKey,"tmpNewComposite",AInstanceID,sctionCode,compsiteCode) = AScatterData.Sections.GetAt(i).Composites.GetAt(j).Text 
			s ^CacheTempEMRScatterData(AKey,"tmpNewComposite",AInstanceID,sctionCode,compsiteCode,"StyleText") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).StyleText
			s scount = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.Count()
			for k=1:1:scount
			{
				if (AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeConcept '= "")
				{
					s conceptCode = $zcvt(AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeConcept.Code,"U")
					s ^CacheTempEMRScatterData(AKey,"tmpNewCompositeConcept",AInstanceID,sctionCode,compsiteCode,conceptCode) = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeConcept.Text
					s ^CacheTempEMRScatterData(AKey,"tmpNewCompositeConcept",AInstanceID,sctionCode,compsiteCode,conceptCode,"StyleText") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeConcept.StyleText
					s ccscount = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeConcept.SubItems.Count()
				    for l=1:1:ccscount
				    {
						s conceptSimpleCode = $zcvt(AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeConcept.SubItems.GetAt(l).Code,"U")
						s ^CacheTempEMRScatterData(AKey,"tmpNewConceptSimple",AInstanceID,sctionCode,compsiteCode,conceptCode,conceptSimpleCode,"ValueCode") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeConcept.SubItems.GetAt(l).ValueCode
						s ^CacheTempEMRScatterData(AKey,"tmpNewConceptSimple",AInstanceID,sctionCode,compsiteCode,conceptCode,conceptSimpleCode,"DataValue") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeConcept.SubItems.GetAt(l).DataValue
						s ^CacheTempEMRScatterData(AKey,"tmpNewConceptSimple",AInstanceID,sctionCode,compsiteCode,conceptCode,conceptSimpleCode,"DataRef") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeConcept.SubItems.GetAt(l).DataRef
						s ^CacheTempEMRScatterData(AKey,"tmpNewConceptSimple",AInstanceID,sctionCode,compsiteCode,conceptCode,conceptSimpleCode,"Separator") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeConcept.SubItems.GetAt(l).Separator
						s ^CacheTempEMRScatterData(AKey,"tmpNewConceptSimple",AInstanceID,sctionCode,compsiteCode,conceptCode,conceptSimpleCode,"Type") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeConcept.SubItems.GetAt(l).Type
						s ^CacheTempEMRScatterData(AKey,"tmpNewConceptSimple",AInstanceID,sctionCode,compsiteCode,conceptCode,conceptSimpleCode,"BindKBCode") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).BindKBBaseID
						s ^CacheTempEMRScatterData(AKey,"tmpNewConceptSimple",AInstanceID,sctionCode,compsiteCode,conceptCode,conceptSimpleCode,"KBNodeID") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).KBNodeID
					}						
				}
				elseif (AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeMacro '= "")
				{
					s macroCode = $zcvt(AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeMacro.Code,"U")
					s ^CacheTempEMRScatterData(AKey,"tmpNewCompositeMacro",AInstanceID,sctionCode,compsiteCode,macroCode) = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeMacro.Text
					s ^CacheTempEMRScatterData(AKey,"tmpNewCompositeMacro",AInstanceID,sctionCode,compsiteCode,macroCode,"StyleText") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeMacro.StyleText
					s ^CacheTempEMRScatterData(AKey,"tmpNewCompositeMacro",AInstanceID,sctionCode,compsiteCode,macroCode,"DisplayName") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeMacro.DisplayName
					s ^CacheTempEMRScatterData(AKey,"tmpNewCompositeMacro",AInstanceID,sctionCode,compsiteCode,macroCode,"MacroID") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeMacro.MacroID
					s ^CacheTempEMRScatterData(AKey,"tmpNewCompositeMacro",AInstanceID,sctionCode,compsiteCode,macroCode,"Type") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeMacro.Type
					s ccmcount = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeMacro.MacroItems.Count()
				    for l=1:1:ccmcount
				    {
					    s ^CacheTempEMRScatterData(AKey,"tmpNewMacroItems",AInstanceID,sctionCode,compsiteCode,macroCode,l,"Name") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeMacro.MacroItems.GetAt(l).Name
						s procount = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeMacro.MacroItems.GetAt(l).MacroItemProperty.Count()
						for m=1:1:procount
						{
							s ^CacheTempEMRScatterData(AKey,"tmpNewMacroItemsProperty",AInstanceID,sctionCode,compsiteCode,macroCode,l,m,"PropertyName") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeMacro.MacroItems.GetAt(l).MacroItemProperty.GetAt(m).PropertyName	
							s ^CacheTempEMRScatterData(AKey,"tmpNewMacroItemsProperty",AInstanceID,sctionCode,compsiteCode,macroCode,l,m,"PropertyValue") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeMacro.MacroItems.GetAt(l).MacroItemProperty.GetAt(m).PropertyValue
						}
					}					
				}
				elseif (AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeToothImage '= "")
				{
					s CrossToothImageCode = $zcvt(AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeToothImage.Code,"U")
					s ^CacheTempEMRScatterData(AKey,"tmpNewCrossToothImage",AInstanceID,sctionCode,compsiteCode,CrossToothImageCode,"Text") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeToothImage.Text
					s ^CacheTempEMRScatterData(AKey,"tmpNewCrossToothImage",AInstanceID,sctionCode,compsiteCode,CrossToothImageCode,"SourceCode") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeToothImage.SourceCode
					s ^CacheTempEMRScatterData(AKey,"tmpNewCrossToothImage",AInstanceID,sctionCode,compsiteCode,CrossToothImageCode,"SourceCCode") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeToothImage.SourceCCode
					s ^CacheTempEMRScatterData(AKey,"tmpNewCrossToothImage",AInstanceID,sctionCode,compsiteCode,CrossToothImageCode,"KBNodeID") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeToothImage.KBNodeID
					s ^CacheTempEMRScatterData(AKey,"tmpNewCrossToothImage",AInstanceID,sctionCode,compsiteCode,CrossToothImageCode,"DisplayName") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeToothImage.DisplayName
					s ^CacheTempEMRScatterData(AKey,"tmpNewCrossToothImage",AInstanceID,sctionCode,compsiteCode,CrossToothImageCode,"ShowMode") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeToothImage.ShowMode
					s tcount = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeToothImage.ToothItems.Count()
				    for l=1:1:tcount
				    {
					    s ^CacheTempEMRScatterData(AKey,"tmpNewToothItems",AInstanceID,sctionCode,compsiteCode,CrossToothImageCode,l,"DisplayName") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeToothImage.ToothItems.GetAt(l).DisplayName
					    s ^CacheTempEMRScatterData(AKey,"tmpNewToothItems",AInstanceID,sctionCode,compsiteCode,CrossToothImageCode,l,"QuadrantType") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeToothImage.ToothItems.GetAt(l).QuadrantType
					    s ^CacheTempEMRScatterData(AKey,"tmpNewToothItems",AInstanceID,sctionCode,compsiteCode,CrossToothImageCode,l,"InCode") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeToothImage.ToothItems.GetAt(l).InCode
					    s ^CacheTempEMRScatterData(AKey,"tmpNewToothItems",AInstanceID,sctionCode,compsiteCode,CrossToothImageCode,l,"AreaType") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeToothImage.ToothItems.GetAt(l).AreaType
					    s ^CacheTempEMRScatterData(AKey,"tmpNewToothItems",AInstanceID,sctionCode,compsiteCode,CrossToothImageCode,l,"Code") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeToothImage.ToothItems.GetAt(l).Code
					    s ^CacheTempEMRScatterData(AKey,"tmpNewToothItems",AInstanceID,sctionCode,compsiteCode,CrossToothImageCode,l,"PDisplayName") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeToothImage.ToothItems.GetAt(l).PDisplayName
					    s ^CacheTempEMRScatterData(AKey,"tmpNewToothItems",AInstanceID,sctionCode,compsiteCode,CrossToothImageCode,l,"CodeSystem") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeToothImage.ToothItems.GetAt(l).CodeSystem
					    s ^CacheTempEMRScatterData(AKey,"tmpNewToothItems",AInstanceID,sctionCode,compsiteCode,CrossToothImageCode,l,"CodeSystemName") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeToothImage.ToothItems.GetAt(l).CodeSystemName
					    s ^CacheTempEMRScatterData(AKey,"tmpNewToothItems",AInstanceID,sctionCode,compsiteCode,CrossToothImageCode,l,"Position") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeToothImage.ToothItems.GetAt(l).Position
						s acount = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeToothImage.ToothItems.GetAt(l).ToothItemAreas.Count()
					    for n=1:1:acount
					    {
						    s ^CacheTempEMRScatterData(AKey,"tmpNewToothItemAreas",AInstanceID,sctionCode,compsiteCode,CrossToothImageCode,l,n,"InCode") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeToothImage.ToothItems.GetAt(l).ToothItemAreas.GetAt(n).InCode
						    s ^CacheTempEMRScatterData(AKey,"tmpNewToothItemAreas",AInstanceID,sctionCode,compsiteCode,CrossToothImageCode,l,n,"Code") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeToothImage.ToothItems.GetAt(l).ToothItemAreas.GetAt(n).Code
						    s ^CacheTempEMRScatterData(AKey,"tmpNewToothItemAreas",AInstanceID,sctionCode,compsiteCode,CrossToothImageCode,l,n,"DisplayName") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeToothImage.ToothItems.GetAt(l).ToothItemAreas.GetAt(n).DisplayName
						    s ^CacheTempEMRScatterData(AKey,"tmpNewToothItemAreas",AInstanceID,sctionCode,compsiteCode,CrossToothImageCode,l,n,"ScriptMode") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeToothImage.ToothItems.GetAt(l).ToothItemAreas.GetAt(n).ScriptMode
							s ^CacheTempEMRScatterData(AKey,"tmpNewToothItemAreas",AInstanceID,sctionCode,compsiteCode,CrossToothImageCode,l,n,"CodeSystem") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeToothImage.ToothItems.GetAt(l).ToothItemAreas.GetAt(n).CodeSystem
						    s ^CacheTempEMRScatterData(AKey,"tmpNewToothItemAreas",AInstanceID,sctionCode,compsiteCode,CrossToothImageCode,l,n,"CodeSystemName") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeToothImage.ToothItems.GetAt(l).ToothItemAreas.GetAt(n).CodeSystemName
							s ^CacheTempEMRScatterData(AKey,"tmpNewToothItemAreas",AInstanceID,sctionCode,compsiteCode,CrossToothImageCode,l,n,"Area") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeToothImage.ToothItems.GetAt(l).ToothItemAreas.GetAt(n).Area
						}
					}					
				}
				else
				{
					s compositeSimpleCode = $zcvt(AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).Code,"U")
					continue:(""=compositeSimpleCode)
					s ^CacheTempEMRScatterData(AKey,"tmpNewSimple",AInstanceID,sctionCode,compsiteCode,compositeSimpleCode,"ValueCode") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).ValueCode
					s ^CacheTempEMRScatterData(AKey,"tmpNewSimple",AInstanceID,sctionCode,compsiteCode,compositeSimpleCode,"DataValue") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).DataValue
					s ^CacheTempEMRScatterData(AKey,"tmpNewSimple",AInstanceID,sctionCode,compsiteCode,compositeSimpleCode,"DataRef") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).DataRef
					s ^CacheTempEMRScatterData(AKey,"tmpNewSimple",AInstanceID,sctionCode,compsiteCode,compositeSimpleCode,"Separator") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).Separator
					s ^CacheTempEMRScatterData(AKey,"tmpNewSimple",AInstanceID,sctionCode,compsiteCode,compositeSimpleCode,"Type") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).Type
					s ^CacheTempEMRScatterData(AKey,"tmpNewSimple",AInstanceID,sctionCode,compsiteCode,compositeSimpleCode,"BindKBCode") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).BindKBBaseID
					s ^CacheTempEMRScatterData(AKey,"tmpNewSimple",AInstanceID,sctionCode,compsiteCode,compositeSimpleCode,"KBNodeID") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).KBNodeID
					s ^CacheTempEMRScatterData(AKey,"tmpNewSimple",AInstanceID,sctionCode,compsiteCode,compositeSimpleCode,"SourceCode") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).SourceCode
					s ^CacheTempEMRScatterData(AKey,"tmpNewSimple",AInstanceID,sctionCode,compsiteCode,compositeSimpleCode,"SourceCCode") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).SourceCCode
				}

			}
		}
		if (AScatterData.Sections.GetAt(i).Sections.Count()>0)
		{
			s tmpScatterData = ##Class(EMRservice.Parser.NIScatterData).%New()
			s tmpScatterData.Sections = AScatterData.Sections.GetAt(i).Sections
			d ..BuildIndexData(tmpScatterData,AInstanceID,AKey)
		}
	}
}

/// Desc：      保存打散数据
/// Creator:    Candyxu
/// CreateDate: 2014-7-1
/// Input:      AInstanceID 实例数据ID
///             AKey 唯一识别码 
ClassMethod Save(AInstanceID As %String, AKey As %String) As %String
{
	s $zt = "Error"
	s result = -1
	q:(AInstanceID="")||(AKey="") result
	s reSction = ##Class(EMRservice.BL.BLIScetionDesc).Save(AInstanceID,AKey)
	q:(reSction = -1) result
	s reComposite = ##Class(EMRservice.BL.BLICompositeDesc).Save(AInstanceID,AKey)
	q:(reComposite = -1) result
	s reConcept = ##Class(EMRservice.BL.BLICompositeConcept).Save(AInstanceID,AKey)
	q:(reConcept = -1) result
	s reConceptSimple = ##Class(EMRservice.BL.BLICompositeConceptSimple).Save(AInstanceID,AKey)
	q:(reConceptSimple = -1) result	
	s reMacro = ##Class(EMRservice.BL.BLCompositeMacro).Save(AInstanceID,AKey)
	q:(reMacro = -1) result
	s reMacroItems = ##Class(EMRservice.BL.BLICompositeMacroItems).Save(AInstanceID,AKey)
	q:(reMacroItems = -1) result
	s reToothImage = ##Class(EMRservice.BL.BLICompositeToothImage).Save(AInstanceID,AKey)
	q:(reToothImage = -1) result
	s reToothItems = ##Class(EMRservice.BL.BLIToothItems).Save(AInstanceID,AKey)
	q:(reToothItems = -1) result
	s reToothArea = ##Class(EMRservice.BL.BLIToothArea).Save(AInstanceID,AKey)
	q:(reToothArea = -1) result
	s reCompositeSimple = ##Class(EMRservice.BL.BLICompositeSimple).Save(AInstanceID,AKey)
	q:(reCompositeSimple = -1) result
	k ^CacheTempEMRScatterData(AKey)
   	s result = 1 
	q result
Error
    q -1
}

/// Desc 清除章节临时global
/// Creator:    Candyxu
/// CreateDate: 2014-7-1
/// Input:      AInstanceID 实例数据ID
///             AKey 唯一识别码 
ClassMethod ClearSectionGlobal(AInstanceID As %String, AKey As %String)
{
	k ^CacheTempEMRScatterData(AKey,"tmpNewSection",AInstanceID)
   	k ^CacheTempEMRScatterData(AKey,"tmpDeleteSection",AInstanceID)
   	k ^CacheTempEMRScatterData(AKey,"tmpUpdateSection",AInstanceID)
   	k ^CacheTempEMRScatterData(AKey,"tmpInsertSection",AInstanceID)
}

/// Desc 清除复合元素临时global
/// Creator:    Candyxu
/// CreateDate: 2014-7-1
/// Input:      AInstanceID 实例数据ID
///             AKey 唯一识别码 
ClassMethod ClearCompositeGlobal(AInstanceID As %String, AKey As %String)
{
	k ^CacheTempEMRScatterData(AKey,"tmpNewComposite",AInstanceID)
    k ^CacheTempEMRScatterData(AKey,"tmpDeleteComposite",AInstanceID)
	k ^CacheTempEMRScatterData(AKey,"tmpUpdateComposite",AInstanceID)
	k ^CacheTempEMRScatterData(AKey,"tmpInsertComposite",AInstanceID)
}

/// Desc 清除简单元素临时global
/// Creator:    Candyxu
/// CreateDate: 2014-7-1
/// Input:      AInstanceID 实例数据ID
///             AKey 唯一识别码 
ClassMethod ClearSimpleGlobal(AInstanceID As %String, AKey As %String)
{
    k ^CacheTempEMRScatterData(AKey,"tmpNewSimple",AInstanceID)
    k ^CacheTempEMRScatterData(AKey,"tmpDeleteSimple",AInstanceID)
	k ^CacheTempEMRScatterData(AKey,"tmpUpdateSimple",AInstanceID)
	k ^CacheTempEMRScatterData(AKey,"tmpInsertSimple",AInstanceID)
}

/// Desc 清除医学概念元素临时global
/// Creator:    Candyxu
/// CreateDate: 2014-7-1
/// Input:      AInstanceID 实例数据ID
///             AKey 唯一识别码 
ClassMethod ClearCompositeConcept(AInstanceID As %String, AKey As %String)
{
	k ^CacheTempEMRScatterData(AKey,"tmpNewCompositeConcept",AInstanceID)
	k ^CacheTempEMRScatterData(AKey,"tmpDeleteCompositeConcept",AInstanceID)
	k ^CacheTempEMRScatterData(AKey,"tmpUpdateCompositeConcept",AInstanceID)
	k ^CacheTempEMRScatterData(AKey,"tmpInsertCompositeConcept",AInstanceID)
}

/// Desc 清除医学概念简单元素临时global
/// Creator:    Candyxu
/// CreateDate: 2014-7-1
/// Input:      AInstanceID 实例数据ID
///             AKey 唯一识别码
ClassMethod ClearCompositeConceptSimple(AInstanceID As %String, AKey As %String)
{
	k ^CacheTempEMRScatterData(AKey,"tmpNewConceptSimple",AInstanceID)
	k ^CacheTempEMRScatterData(AKey,"tmpDeleteConceptSimple",AInstanceID)
	k ^CacheTempEMRScatterData(AKey,"tmpUpdateConceptSimple",AInstanceID)
	k ^CacheTempEMRScatterData(AKey,"tmpInsertConceptSimple",AInstanceID)
}

/// Desc:       取打散数据
/// Creator:    Candy
/// CreateDate: 2014-07-24
/// Input:      AEpisodeID 就诊号
///             AItem 单元路径 TYPE:ICompositeSample#TID:81#SCODE:S001|CCODE:VK1|CSCODE:L010#VTYPE:V
///             AInstanceID 实例数据ID
/// Return:     result 实例数据单元值
/// Debug:      w ##Class(EMRservice.BL.BLScatterData).GetScatterData(456449,"#TYPE:IMACRODESC#TID:96#SCODE:S008|CCODE:V010|CSCODE:MA0001|Name:menarche#VTYPE:T","")           
ClassMethod GetScatterData(AEpisodeID As %String, AItem As %String, AInstanceID As %String) As %String
{
	s $ZT="ERROR"	
	s result = ""
	q:(AEpisodeID = "") result
	s ItemList = ##Class(EMRservice.Tools.Tool).GetListFromString(AItem,"#")
	q:($ll(ItemList) '= 4) result
	s elementType = $zcvt($p($lg(ItemList,1),":",2),"U")
	s templateId = $p($lg(ItemList,2),":",2)
	s itemCode = $lg(ItemList,3)
	s valueType = $p($lg(ItemList,4),":",2)
	if (elementType = "ISECTIONDESC")
	{	
		s rowId = ..GetSectionID(AEpisodeID,templateId,itemCode,AInstanceID)
		q:(rowId = "") result
		s result = ..GetSectionData(rowId,valueType)
	}
	elseif(elementType = "ICOMPOSITEDESC")
	{
		s rowId = ..GetCompositeID(AEpisodeID,templateId,itemCode,AInstanceID)
		q:(rowId = "") result
		s result = ..GetCompositeData(rowId,valueType)		
	}
	elseif(elementType = "ICOMPOSITESAMPLE")
	{
		s rowId = ..GetCompositeSimpleID(AEpisodeID,templateId,itemCode,AInstanceID)
		q:(rowId = "") result
		s result = ..GetCompositeSimpleData(rowId,valueType)
	}
	elseif(elementType = "ICONCEPTDESC")
	{
		s rowId = ..GetConIDByConCode(AEpisodeID,templateId,itemCode,AInstanceID)
		q:(rowId = "") result
		s result = ..GetConceptData(rowId,valueType)	
	}
	elseif(elementType = "ICONCEPTSAMPLE")
	{
		s rowId = ..GetConSimIDByConCode(AEpisodeID,templateId,itemCode,AInstanceID)
		q:(rowId = "") result
		s result = ..GetConceptSimpleData(rowId,valueType)	
	}
	elseif(elementType = "IMACRODESC") 
	{
		s rowId = ..GetCompositeMacroID(AEpisodeID,templateId,itemCode,AInstanceID)
		q:(rowId = "") result
		s result = ..GetCompositeMacroData(rowId,valueType)		
	}
	elseif(elementType = "IMACROSAMPLE") 
	{
		s result = ..GetMacroObjectItemsData(AEpisodeID,templateId,itemCode,AInstanceID)
	}
	q result
ERROR
    q "ERROR"
}

/// Desc:       根据单元代码取所有病历打散数据
/// Creator:    Candy
/// CreateDate: 2016-3-30
/// Input:      AEpisodeID 就诊号
///            AItem #TYPE:ICOMPOSITESAMPLE#SCODE:S010|CCODE:V001|CSCODE:L013#TID:88#VTYPE:V
/// Output:     result 数组 key:病历ID value:单元值
/// Debug:
ClassMethod GetScatterDatas(AEpisodeID As %String, AItem As %String, ATemplateID As %String, AValueType As %String) As %ArrayOfDataTypes
{
	s $ZT="ERROR"
	s result = ##Class(%ArrayOfDataTypes).%New()
	q:((AEpisodeID = "")||(AItem = "")||(ATemplateID = "")) result
	s elementType = $p($p(AItem,"#",2),":",2)
	s vtype = $Case(AValueType,"":"V",:AValueType)
	if (elementType = "ISECTIONDESC")
	{
		s code = $p($p(AItem,"#",3),":",2)
		s instanceId = ""
		for
		{
			s instanceId = $o(^DHCEMRI.ISectionDescI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_code,instanceId))
			q:(instanceId = "")
			s tmpInstanceId = $tr(instanceId," ","")
			s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(tmpInstanceId)
			continue:(objInstance = "")
			continue:($zcvt(objInstance.Status,"U") '= "SAVE")
			s rowId = $o(^DHCEMRI.ISectionDescI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_code,instanceId,""))
			s value = ..GetSectionData(rowId,vtype)
			d result.SetAt(value,tmpInstanceId)
		}
	} 
	elseif (elementType = "ICOMPOSITEDESC")
	{
		s scode = $p($p($p(AItem,"#",3),"|",1),":",2)
		s ccode = $p($p($p(AItem,"#",3),"|",2),":",2)
		s instanceId = ""
		for
		{
			s instanceId = $o(^DHCEMRI.ICompositeDescI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_scode," "_ccode,instanceId))
			q:(instanceId = "")
			s tmpInstanceId = $tr(instanceId," ","")
			s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(tmpInstanceId)
			continue:(objInstance = "")
			continue:($zcvt(objInstance.Status,"U") '= "SAVE")
			s rowId = $o(^DHCEMRI.ICompositeDescI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_scode," "_ccode,instanceId,""))
			s value = ..GetCompositeData(rowId,vtype)
			d result.SetAt(value,tmpInstanceId)
		}
	}
	elseif (elementType = "ICOMPOSITESAMPLE")
	{
		s scode = $p($p($p(AItem,"#",3),"|",1),":",2)
		s ccode = $p($p($p(AItem,"#",3),"|",2),":",2)
		s cscode = $p($p($p(AItem,"#",3),"|",3),":",2)
		s instanceId = ""
		for
		{
			s instanceId = $o(^DHCEMRI.ICompositeSimpleI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_scode," "_ccode," "_cscode,instanceId))
			q:(instanceId = "")
			s tmpInstanceId = $tr(instanceId," ","")
			s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(tmpInstanceId)
			continue:(objInstance = "")
			continue:($zcvt(objInstance.Status,"U") '= "SAVE")
			s rowId = $o(^DHCEMRI.ICompositeSimpleI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_scode," "_ccode," "_cscode,instanceId,""))
			s value = ..GetCompositeSimpleData(rowId,vtype)
			d result.SetAt(value,tmpInstanceId)
		}		
	}
	elseif (elementType = "ICONCEPTDESC")
	{
		s scode = $p($p($p(AItem,"#",3),"|",1),":",2)
		s ccode = $p($p($p(AItem,"#",3),"|",2),":",2)
		s cocode = $p($p($p(AItem,"#",3),"|",3),":",2)
		s instanceId = ""
		for
		{
			s instanceId = $o(^DHCEMRI.ICompositeConceptI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_scode," "_ccode," "_cocode,instanceId))
			q:(instanceId = "")
			s tmpInstanceId = $tr(instanceId," ","")
			s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(tmpInstanceId)
			continue:(objInstance = "")
			continue:($zcvt(objInstance.Status,"U") '= "SAVE")
			s rowId = $o(^DHCEMRI.ICompositeConceptI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_scode," "_ccode," "_cocode,instanceId,""))
			s value = ..GetConceptData(rowId,vtype)
			d result.SetAt(value,tmpInstanceId)
		}
	}
	elseif (elementType = "ICONCEPTSAMPLE")
	{
		s scode = $p($p($p(AItem,"#",3),"|",1),":",2)
		s ccode = $p($p($p(AItem,"#",3),"|",2),":",2)
		s cocode = $p($p($p(AItem,"#",3),"|",3),":",2)
		s cscode = $p($p($p(AItem,"#",3),"|",4),":",2)
		s instanceId = ""
		for
		{
			s instanceId = $o(^DHCEMRI.IConceptSimpleI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_scode," "_ccode," "_cocode," "_cscode,instanceId))
			q:(instanceId = "")
			s tmpInstanceId = $tr(instanceId," ","")
			s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(tmpInstanceId)
			continue:(objInstance = "")
			continue:($zcvt(objInstance.Status,"U") '= "SAVE")
			s rowId = $o(^DHCEMRI.IConceptSimpleI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_scode," "_ccode," "_cocode," "_cscode,instanceId,""))
			s value = ..GetConceptSimpleData(rowId,vtype)
			d result.SetAt(value,tmpInstanceId)
		}
	}
	elseif (elementType = "IMACRODESC")
	{
		s scode = $p($p($p(AItem,"#",3),"|",1),":",2)
		s ccode = $p($p($p(AItem,"#",3),"|",2),":",2)
		s macode = $p($p($p(AItem,"#",3),"|",3),":",2)
		s instanceId = ""
		for
		{
			s instanceId = $o(^DHCEMRI.ICompositeMacroI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_scode," "_ccode," "_macode,instanceId))
			q:(instanceId = "")
			s tmpInstanceId = $tr(instanceId," ","")
			s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(tmpInstanceId)
			continue:(objInstance = "")
			continue:($zcvt(objInstance.Status,"U") '= "SAVE")
			s rowId = $o(^DHCEMRI.ICompositeMacroI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_scode," "_ccode," "_cocode,instanceId,""))
			s value = ..GetCompositeMacroData(rowId,vtype)
			d result.SetAt(value,tmpInstanceId)
		}		
	}
	elseif (elementType = "IMACROSAMPLE")
	{
		s scode = $p($p($p(AItem,"#",3),"|",1),":",2)
		s ccode = $p($p($p(AItem,"#",3),"|",2),":",2)
		s mccode = $p($p($p(AItem,"#",3),"|",3),":",2)
		s mcname = $p($p($p(AItem,"#",3),"|",4),":",2)		
		s instanceId = ""
		for
		{
			s instanceId = $o(^DHCEMRI.IMacroObjectItemsI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_sCode," "_cCode," "_mcCode,instanceId),-1)
			q:(instanceId = "")
			s tmpInstanceId = $tr(instanceId," ","")
			s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(tmpInstanceId)
			continue:(objInstance = "")
			q:($zcvt(objInstance.Status,"U") = "SAVE")
			s value = ..GetMacroObjectItemsDataByInstanceID(AEpisodeID,tmpInstanceId,ATemplateID,scode,ccode,mccode,mcname)
			d result.SetAt(value,tmpInstanceId)
		}		
	}
	q result
	
ERROR
    q "ERROR"
}

/// Desc:       取知识库打散数据集
/// CreateDate: 2016-3-30
/// Input:      AEpisodeID 就诊号
///            AItem #TYPE:ICOMPOSITESAMPLE#SCODE:CCODE:104|CSCODE:L001# 
ClassMethod GetKBScatterDatas(AEpisodeID As %String, APItem As %String, AItem As %String, ATemplateID As %String, AKBNodeID As %String, AValueType As %String) As %ArrayOfDataTypes
{
	s $ZT="ERROR"
	s result = ##Class(%ArrayOfDataTypes).%New()
	q:((AEpisodeID = "")||(AItem = "")||(ATemplateID = "")||(AKBNodeID = "")) result
	s elementType = $p($p(AItem,"#",2),":",2)
	s vtype = $case(AValueType,"":"V",:AValueType)
	if (elementType = "ICOMPOSITEDESC")
	{
		q result
	}
	elseif (elementType = "ICOMPOSITESAMPLE")
	{
		s scode = $p($p($p(APItem,"#",3),"|",1),":",2)
		s ccode = $p($p($p(AItem,"#",3),"|",1),":",3)
		s cscode = $p($p($p(AItem,"#",3),"|",2),":",2)
		s instanceId = ""
		for
		{
			s instanceId = $o(^DHCEMRI.ICompositeSimpleI("IdxForKBNode"," "_AEpisodeID," "_ATemplateID," "_AKBNodeID," "_scode," "_ccode," "_cscode,instanceId))
			q:(instanceId = "")
			s tmpInstanceId = $tr(instanceId," ","")
			s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(tmpInstanceId)
			continue:(objInstance = "")
			continue:($zcvt(objInstance.Status,"U") '= "SAVE")
			s rowId = $o(^DHCEMRI.ICompositeSimpleI("IdxForKBNode"," "_AEpisodeID," "_ATemplateID," "_AKBNodeID," "_scode," "_ccode," "_cscode,instanceId,""))
			s value = ..GetCompositeSimpleData(rowId,vtype)
			d result.SetAt(value,tmpInstanceId)
		}		
	}
	elseif(elementType = "ICONCEPTDESC")
	{
		s scode = $p($p($p(APItem,"#",3),"|",1),":",2)
		s ccode = $p($p($p(AItem,"#",3),"|",1),":",3)
		s coCode = $p($p($p(AItem,"#",3),"|",2),":",2)
		s instanceId = ""			
		for
		{
			s instanceId = $o(^DHCEMRI.ICompositeConceptI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_scode," "_ccode," "_coCode,instanceId))
			q:(instanceId = "")
			s tmpInstanceId = $tr(instanceId," ","")
			s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(tmpInstanceId)
			continue:(objInstance = "")
			continue:($zcvt(objInstance.Status,"U") '= "SAVE")
			s rowId = $o(^DHCEMRI.ICompositeConceptI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_scode," "_ccode," "_coCode,instanceId,""))
			s value = ..GetConceptData(rowId,vtype)
			d result.SetAt(value,tmpInstanceId)
		}
		s result = ##Class(EMRservice.BL.BLScatterData).GetConceptData(curRowID,valueType)
		
	}
	elseif(elementType = "ICONCEPTSAMPLE")
	{
		s CompositeCode = ""
		s coCode = ""
		s SimpleItemCode = ""
		
		if ($l(itemCode,"|")=2)
		{
			s CompositeCode = $p($p(itemCode,"|",1),":",2) 
			s coCode = $p($p(itemCode,"|",2),":",2)
			s SimpleItemCode = $p($p(itemCode,"|",3),":",2)
		}
		q:(CompositeCode="") ""
		q:(coCode="") ""
		q:(SimpleItemCode="") ""
		s curSectionCode = ""
		for {
			s curSectionCode = $o(^DHCEMRI.IConceptSimpleI("IdxForGetSection"," "_AInstanceID," "_CompositeCode," "_coCode," "_SimpleItemCode,curSectionCode))
			q:(curSectionCode = "")
			s curRowID= ""
			s curRowID = $o(^DHCEMRI.IConceptSimpleI("IdxForGetSection"," "_AInstanceID," "_CompositeCode," "_coCode," "_SimpleItemCode,curSectionCode,curRowID))
			continue:(curRowID = "")
			s result = ##Class(EMRservice.BL.BLScatterData).GetConceptSimpleData(curRowID,valueType)
			q:(result'="")
		}
	}
	q result
	
ERROR
    q "ERROR"
}

/// Desc:       返回GetSectionDesc的rowID
/// Creator:    Candy
/// CreateDate: 2014-7-24
/// Input:      AEpisodeID 就诊号
///             ATemplateID 模板ID
///             ACode 单元代码(路径)
///             AInstanceID 就诊号
/// Return:     EMRinstance.ISectionDesc 的 rowID
/// Debug:      w ##Class(EMRservice.BL.BLScatterData).GetSectionID(76,2,"Code:S001","")
ClassMethod GetSectionID(AEpisodeID As %String, ATemplateID As %String, ACode As %String, AInstanceID As %String) As %String
{
	s result = ""
	q:((AEpisodeID = "")||(ATemplateID = "")||(ACode = "")) result
	s sCode = $p(ACode,":",2)
	s SCode = $zcvt(sCode,"U")
	if (AInstanceID = "")
	{
		s instanceId = ""
		for
		{
			s instanceId = $o(^DHCEMRI.ISectionDescI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_SCode,instanceId),-1)
			q:(instanceId = "")
			s tmpInstanceId = $tr(instanceId," ","")
			s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(tmpInstanceId)
			continue:(objInstance = "")
			q:($zcvt(objInstance.Status,"U") = "SAVE")
		}		
	}
	else
	{
		s instanceId = " "_AInstanceID
	}
	q:(instanceId = "") result
	s result = $o(^DHCEMRI.ISectionDescI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_SCode,instanceId,""),-1)
	q result
}

/// Desc:       返回GetSectionDesc的rowID
/// Creator:    Candy
/// CreateDate: 2014-7-24
/// Input:      AEpisodeID 就诊号
///             ATemplateID 模板ID
///             ACode 单元代码(路径)
///             AInstanceID 就诊号
/// Return:     EMRinstance.ICompositeDesc 的 rowID
/// Debug:      w ##Class(EMRservice.BL.BLScatterData).GetCompositeID(76,2,"SCode:S001|CCode:29","")
ClassMethod GetCompositeID(AEpisodeID As %String, ATemplateID As %String, ACode As %String, AInstanceID As %String) As %String
{
	s result = ""
	q:((AEpisodeID = "")||(ATemplateID = "")||(ACode = "")) result
	s sCode = $p($p(ACode,"|",1),":",2)
	s cCode = $p($p(ACode,"|",2),":",2)
	s sCode = $zcvt(sCode,"U")
	s cCode = $zcvt(cCode,"U")
	if (AInstanceID = "")
	{
		s instanceId = ""
		for
		{
			s instanceId = $o(^DHCEMRI.ICompositeDescI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_sCode," "_cCode,instanceId),-1)
			q:(instanceId = "")
			s tmpInstanceId = $tr(instanceId," ","")
			s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(tmpInstanceId)
			continue:(objInstance = "")
			q:($zcvt(objInstance.Status,"U") = "SAVE")
		}	
	}
	else
	{
		s instanceId = " "_AInstanceID
	}
	q:(instanceId = "") result
	s result = $o(^DHCEMRI.ICompositeDescI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_sCode," "_cCode,instanceId,""),-1)
	q result
}

/// Desc:       返回CompositeSimple的rowID
/// Creator:    Candy
/// CreateDate: 2014-7-24
/// Input:      AEpisodeID 就诊号
///             ATemplateID 模板ID
///             ACode 单元代码(路径)
///             AInstanceID 就诊号
/// Return:     EMRinstance.ICompositeSimple 的 rowID
/// Debug:      w ##Class(EMRservice.BL.BLScatterData).GetCompositeSimpleID(76,81,"SCODE:S001|CCODE:29|CSCODE:I001","")
ClassMethod GetCompositeSimpleID(AEpisodeID As %String, ATemplateID As %String, ACode As %String, AInstanceID As %String) As %String
{
	s result = ""
	q:((AEpisodeID = "")||(ACode = "")||(ATemplateID = "")) result
	s sCode = $p($p(ACode,"|",1),":",2)
	s cCode = $p($p(ACode,"|",2),":",2) 
	s csCode = $p($p(ACode,"|",3),":",2)
	
	s sCode = $zcvt(sCode,"U")
	s cCode = $zcvt(cCode,"U")
	s csCode = $zcvt(csCode,"U")
	
	if (AInstanceID = "")
	{
		s instanceId = ""
		for
		{
			s instanceId = $o(^DHCEMRI.ICompositeSimpleI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_sCode," "_cCode," "_csCode,instanceId),-1)
			q:(instanceId = "")
			s tmpInstanceId = $tr(instanceId," ","")
			s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(tmpInstanceId)
			continue:(objInstance = "")
			q:($zcvt(objInstance.Status,"U") = "SAVE")
		}		
	}
	else
	{
		s instanceId = " "_AInstanceID
	}
	q:(instanceId = "") result
	s result = $o(^DHCEMRI.ICompositeSimpleI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_sCode," "_cCode," "_csCode,instanceId,""),-1)
	q result
}

/// Desc:       返回EMRinstance.ICompositeMacro(公式)的rowID
/// Creator:    Candy
/// CreateDate: 2018-5-15
/// Input:      AEpisodeID 就诊号
///             ATemplateID 模板ID
///             ACode 单元代码(路径)
///             AInstanceID 就诊号
/// Return:     EMRinstance.ICompositeSimple 的 rowID
/// Debug:      w ##Class(EMRservice.BL.BLScatterData).GetCompositeSimpleID(76,81,"SCODE:S001|CCODE:29|CSCODE:I001","")
ClassMethod GetCompositeMacroID(AEpisodeID As %String, ATemplateID As %String, ACode As %String, AInstanceID As %String) As %String
{
	s result = ""
	q:((AEpisodeID = "")||(ACode = "")||(ATemplateID = "")) result
	s sCode = $p($p(ACode,"|",1),":",2)
	s cCode = $p($p(ACode,"|",2),":",2) 
	s mcCode = $p($p(ACode,"|",3),":",2)
	
	s sCode = $zcvt(sCode,"U")
	s cCode = $zcvt(cCode,"U")
	s mcCode = $zcvt(mcCode,"U")
	
	if (AInstanceID = "")
	{
		s instanceId = ""
		for
		{
			s instanceId = $o(^DHCEMRI.ICompositeMacroI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_sCode," "_cCode," "_mcCode,instanceId),-1)
			q:(instanceId = "")
			s tmpInstanceId = $tr(instanceId," ","")
			s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(tmpInstanceId)
			continue:(objInstance = "")
			q:($zcvt(objInstance.Status,"U") = "SAVE")
		}		
	}
	else
	{
		s instanceId = " "_AInstanceID
	}
	q:(instanceId = "") result
	s result = $o(^DHCEMRI.ICompositeMacroI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_sCode," "_cCode," "_mcCode,instanceId,""),-1)
	q result
}

/// Desc:       取Section内容
/// Creator:    Candy
/// CreateDate: 2014-7-24
/// Input:      AID EMRinstance.ISectionDesc 的 rowID
///            AVType 取值类型
/// Output:     单元值
/// Debug w ##Class(EMRservice.BL.BLScatterData).GetSectionData("1","")
ClassMethod GetSectionData(AID As %String, AVType As %String) As %String
{
	s result = ""
	q:(AID = "") result
	s objSection = ##Class(EMRinstance.ISectionDesc).%OpenId(AID)
	q:(objSection = "") result
	
	if (AVType = "T")
	{ 
		do objSection.Text.Rewind()
		while (objSection.Text.AtEnd = 0) 
	  	{ 	s len = 1024
	    	s tmpStr = objSection.Text.Read(len)
	    	s result = result_tmpStr  
	   	}
	}
	elseif (AVType = "S")
	{
		do objSection.StyleText.Rewind()
		while (objSection.StyleText.AtEnd = 0) 
	  	{ 	s len = 1024
	    	s tmpStr = objSection.StyleText.Read(len)
	    	s result = result_tmpStr  
	   	}	
	}
	elseif (AVType = "V")
	{ 
		do objSection.Text.Rewind()
		while (objSection.Text.AtEnd = 0) 
	  	{ 	s len = 1024
	    	s tmpStr = objSection.Text.Read(len)
	    	s result = result_tmpStr  
	   	}
	}
	q result
}

/// Desc:       取Composite内容
/// Creator:    Candy
/// CreateDate: 2014-7-24
/// Input:      AID EMRinstance.ICompositeDesc 的 rowID
///            AVType 取值类型
/// Output:     单元值
ClassMethod GetCompositeData(AID As %String, AVType As %String) As %String
{
	s result = ""
	q:(AID = "") result
	s objComposite = ##Class(EMRinstance.ICompositeDesc).%OpenId(AID)
	q:(objComposite = "") result
	
	if (AVType = "T")
	{
		do objComposite.Text.Rewind()
		while (objComposite.Text.AtEnd = 0) 
	  	{ 	s len = 1024
	    	s tmpStr = objComposite.Text.Read(len)
	    	s result = result_tmpStr  
	   	}
	}
	elseif( AVType = "S")
	{
		do objComposite.StyleText.Rewind()
		while (objComposite.Text.AtEnd = 0) 
	  	{ 	s len = 1024
	    	s tmpStr = objComposite.StyleText.Read(len)
	    	s result = result_tmpStr  
	   	}	
	}
	q result
}

/// Desc: 	   取CompositeSimple数据
/// Creator:    Candy
/// CreateDate: 2014-7-24
/// Input:      AID EMRinstance.ICompositeSimple 的 rowID
///            AVType 取值类型
/// Output:     单元值
ClassMethod GetCompositeSimpleData(AID As %String, AVType As %String) As %String
{
	s result = ""
	q:(AID = "") result
	s objCompositeSimple = ##Class(EMRinstance.ICompositeSimple).%OpenId(AID)
	q:(objCompositeSimple = "") result
	if ((AVType = "")||(AVType = "V"))
	{
		s result = objCompositeSimple.DataValue
	}
	elseif(AVType = "C")
	{
		s result = objCompositeSimple.ValueCode
	}
	elseif(AVType = "I")
	{
		s result = objCompositeSimple.DataRef
	}
	elseif (AVType = "VC")
	{
		s result = objCompositeSimple.ValueCode_objCompositeSimple.DataValue
	}
	elseif (AVType = "CV")
	{
		s result = objCompositeSimple.DataValue_objCompositeSimple.ValueCode
	}
	elseif (AVType = "VANDC")
	{
		s result = objCompositeSimple.DataValue_"^"_objCompositeSimple.ValueCode
	}
	elseif (AVType = "CANDV")
	{
		s result = objCompositeSimple.ValueCode_"^"_objCompositeSimple.DataValue
	}
	elseif (AVType = "YEAR")
	{
		//YYYY
		q:(objCompositeSimple.Type'="MIDateTime") result
		s tempData = $zd(objCompositeSimple.DataValue,3)
		s result = $p(tempData,"-",1)
	}
	elseif (AVType = "MONTH")
	{
		//MM
		q:(objCompositeSimple.Type'="MIDateTime") result
		s tempData = $zd(objCompositeSimple.DataValue,3)
		s result = $p(tempData,"-",2)	
	}
	elseif (AVType = "DAY")
	{
		//DD
		q:(objCompositeSimple.Type'="MIDateTime") result
		s tempData = $zd(objCompositeSimple.DataValue,3)
		s result = $p(tempData,"-",3)	
	}
	elseif (AVType = "HOUR")
	{
		//HH
		q:(objCompositeSimple.Type'="MIDateTime") result
		s tempData = $zt(objCompositeSimple.DataValue)
		s result = $p(tempData,":",1)	
	}
	elseif (AVType = "MINUTE")
	{
		//MM
		q:(objCompositeSimple.Type'="MIDateTime") result
		s tempData = $zt(objCompositeSimple.DataValue)
		s result = $p(tempData,":",2)	
	}
	elseif (AVType = "SECOND")
	{
		//SS
		q:(objCompositeSimple.Type'="MIDateTime") result
		s tempData = $zt(objCompositeSimple.DataValue)
		s result = $p(tempData,":",3)		
	}
	elseif (AVType = "YMDHM")
	{
		//YYYY-MM-DD HH:MM
		q:(objCompositeSimple.Type'="MIDateTime") result
		s tempData = $zd(objCompositeSimple.DataValue,3)
		s tempTime = $zt(objCompositeSimple.DataValue,2)
		s result = tempData_" "_tempTime
	}
	elseif (AVType = "MDHM")
	{
		//MM-DD HH:MM
		q:(objCompositeSimple.Type'="MIDateTime") result
		s tempData = $zd(objCompositeSimple.DataValue,3)
		s tempData = $e(tempData,6,$l(tempData))
		s tempTime = $zt(objCompositeSimple.DataValue,2)
		s result = tempData_" "_tempTime
	}
	elseif (AVType = "YMD")
	{
		//YYYY-MM-DD
		q:(objCompositeSimple.Type'="MIDateTime") result
		s result = $zd(objCompositeSimple.DataValue,3)
	}
	elseif (AVType = "HMS")
	{
		//HH:MM:SS
		q:(objCompositeSimple.Type'="MIDateTime") result
		s result = $zt(objCompositeSimple.DataValue)
	}
	elseif (AVType = "HM")
	{
		//HH:MM
		q:(objCompositeSimple.Type'="MIDateTime") result
		s result = $zt(objCompositeSimple.DataValue,2)
	}
	elseif(AVType = "Dict")
	{
		s rowID = objCompositeSimple.DataRef
		s code = objCompositeSimple.ValueCode
		s desc = objCompositeSimple.DataValue
		s result = rowID_"|"_code_"|"_desc
	}
	elseif(AVType = "Mono")
	{
		s code = objCompositeSimple.ValueCode
		s desc = objCompositeSimple.DataValue
		s result = code_"|"_desc
	}
	elseif(AVType = "Mult")
	{
		s result = ""
		s code = objCompositeSimple.ValueCode
		s desc = objCompositeSimple.DataValue
		s separator = objCompositeSimple.Separator
		s count = $l(code,separator)
		for I=1:1:count
		{
			s:(I '= 1) result = result_"#"
			s result = result_$p(code,separator,I)_"|"_$p(desc,separator,I)
		}
	}
	elseif(AVType = "U") //获取签名数据用户ID
	{
		s result = ""
		s strPath = objCompositeSimple.SectionCode _"_"_objCompositeSimple.CompositeCode
		s intstanceID = objCompositeSimple.InstanceDataID
		s objInstance = ##class(EMRinstance.InstanceData).%OpenId(intstanceID)
		q:(objInstance ="") result
		s objEcrord= objInstance.TheECRecord
		s docType = objEcrord.DocumentType
		
		s sRowID =""
		for {
			s sRowID =$o(^DHCEMRI.EMRSignI("IdxInstance"," "_intstanceID,sRowID))
			q:(sRowID="")
			s objSign =##Class(EMRinstance.EMRSign).%OpenId(sRowID)
			if (objSign.Code [ strPath)&&(objSign.isSignValid = 1)
			{
				if (docType ="GRID")&&(objSign.Code [ objCompositeSimple.SimpleItemCode)
				{
					s result = objSign.UsrID
					q
				}
				elseif(docType '="GRID")
				{
					if (result="")
					{
						s result = objSign.UsrID
					}
					else
					{
						s result = result_"|"_objSign.UsrID
					}
				}
			}
		}
	}
	elseif(AVType = "UV") //获取签名数据用户ID^用户名
	{
		s result = ""
		s strPath = objCompositeSimple.SectionCode _"_"_objCompositeSimple.CompositeCode
		s intstanceID = objCompositeSimple.InstanceDataID
		s objInstance = ##class(EMRinstance.InstanceData).%OpenId(intstanceID)
		q:(objInstance ="") result
		s objEcrord= objInstance.TheECRecord
		s docType = objEcrord.DocumentType
		s sRowID =""
		for {
			s sRowID =$o(^DHCEMRI.EMRSignI("IdxInstance"," "_intstanceID,sRowID))
			q:(sRowID="")
			s objSign =##Class(EMRinstance.EMRSign).%OpenId(sRowID)
			if (objSign.Code [ strPath)&&(objSign.isSignValid = 1)
			{
				if (docType ="GRID")&&(objSign.Code [ objCompositeSimple.SimpleItemCode)
				{
					s uName = $p($g(^SSU("SSUSR",objSign.UsrID)),"^",2)
					s result = objSign.UsrID_"^"_uName
					q
				}
				elseif(docType '="GRID")
				{
					if (result="")
					{
						s uName = $p($g(^SSU("SSUSR",objSign.UsrID)),"^",2)
						s result = objSign.UsrID_"^"_uName
					}
					else
					{
						s uName = $p($g(^SSU("SSUSR",objSign.UsrID)),"^",2)
						s result = result_"|"_objSign.UsrID_"^"_uName
					}
				}
			}
		}
	}

	q result
}

/// Desc:       取EMRinstance.ICompositeConcept内容
/// Creator:    yejian
/// CreateDate: 2017-1-4
/// Input:      AID EMRinstance.ICompositeConcept 的 rowID
///            AVType 取值类型
/// Output:     单元值
ClassMethod GetConceptData(AID As %String, AVType As %String) As %String
{
	s result = ""
	q:(AID = "") result
	s objComposite = ##Class(EMRinstance.ICompositeConcept).%OpenId(AID)
	q:(objComposite = "") result
	
	if (AVType = "T")
	{
		do objComposite.Text.Rewind()
		while (objComposite.Text.AtEnd = 0) 
	  	{ 	s len = 1024
	    	s tmpStr = objComposite.Text.Read(len)
	    	s result = result_tmpStr  
	   	}
	}
	elseif( AVType = "S")
	{
		do objComposite.StyleText.Rewind()
		while (objComposite.Text.AtEnd = 0) 
	  	{ 	s len = 1024
	    	s tmpStr = objComposite.StyleText.Read(len)
	    	s result = result_tmpStr  
	   	}	
	}
	q result
}

/// Desc: 	   取EMRinstance.ICompositeConceptSimple数据
/// Creator:    yejian
/// CreateDate: 2017-1-4
/// Input:      AID EMRinstance.ICompositeConceptSimple 的 rowID
///            AVType 取值类型
/// Output:     单元值
ClassMethod GetConceptSimpleData(AID As %String, AVType As %String) As %String
{
	s result = ""
	q:(AID = "") result
	s objCompositeSimple = ##Class(EMRinstance.ICompositeConceptSimple).%OpenId(AID)
	q:(objCompositeSimple = "") result
	if ((AVType = "")||(AVType = "V"))
	{
		s result = objCompositeSimple.DataValue
	}
	elseif(AVType = "C")
	{
		s result = objCompositeSimple.ValueCode
	}
	elseif(AVType = "I")
	{
		s result = objCompositeSimple.DataRef
	}
	elseif (AVType = "VC")
	{
		s result = objCompositeSimple.ValueCode_objCompositeSimple.DataValue
	}
	elseif (AVType = "CV")
	{
		s result = objCompositeSimple.DataValue_objCompositeSimple.ValueCode
	}
	elseif (AVType = "VANDC")
	{
		s result = objCompositeSimple.DataValue_"^"_objCompositeSimple.ValueCode
	}
	elseif (AVType = "CANDV")
	{
		s result = objCompositeSimple.ValueCode_"^"_objCompositeSimple.DataValue
	}
	elseif (AVType = "YEAR")
	{
		//YYYY
		q:(objCompositeSimple.Type'="MIDateTime") result
		s tempData = $zd(objCompositeSimple.DataValue,3)
		s result = $p(tempData,"-",1)
	}
	elseif (AVType = "MONTH")
	{
		//MM
		q:(objCompositeSimple.Type'="MIDateTime") result
		s tempData = $zd(objCompositeSimple.DataValue,3)
		s result = $p(tempData,"-",2)	
	}
	elseif (AVType = "DAY")
	{
		//DD
		q:(objCompositeSimple.Type'="MIDateTime") result
		s tempData = $zd(objCompositeSimple.DataValue,3)
		s result = $p(tempData,"-",3)	
	}
	elseif (AVType = "HOUR")
	{
		//HH
		q:(objCompositeSimple.Type'="MIDateTime") result
		s tempData = $zt(objCompositeSimple.DataValue)
		s result = $p(tempData,":",1)	
	}
	elseif (AVType = "MINUTE")
	{
		//MM
		q:(objCompositeSimple.Type'="MIDateTime") result
		s tempData = $zt(objCompositeSimple.DataValue)
		s result = $p(tempData,":",2)	
	}
	elseif (AVType = "SECOND")
	{
		//SS
		q:(objCompositeSimple.Type'="MIDateTime") result
		s tempData = $zt(objCompositeSimple.DataValue)
		s result = $p(tempData,":",3)		
	}
	elseif (AVType = "YMDHM")
	{
		//YYYY-MM-DD HH:MM
		q:(objCompositeSimple.Type'="MIDateTime") result
		s tempData = $zd(objCompositeSimple.DataValue,3)
		s tempTime = $zt(objCompositeSimple.DataValue,2)
		s result = tempData_" "_tempTime
	}
	elseif (AVType = "MDHM")
	{
		//MM-DD HH:MM
		q:(objCompositeSimple.Type'="MIDateTime") result
		s tempData = $zd(objCompositeSimple.DataValue,3)
		s tempData = $e(tempData,6,$l(tempData))
		s tempTime = $zt(objCompositeSimple.DataValue,2)
		s result = tempData_" "_tempTime
	}
	elseif (AVType = "YMD")
	{
		//YYYY-MM-DD
		q:(objCompositeSimple.Type'="MIDateTime") result
		s result = $zd(objCompositeSimple.DataValue,3)
	}
	elseif (AVType = "HMS")
	{
		//HH:MM:SS
		q:(objCompositeSimple.Type'="MIDateTime") result
		s result = $zt(objCompositeSimple.DataValue)
	}
	elseif (AVType = "HM")
	{
		//HH:MM
		q:(objCompositeSimple.Type'="MIDateTime") result
		s result = $zt(objCompositeSimple.DataValue,2)
	}
	elseif(AVType = "Dict")
	{
		s rowID = objCompositeSimple.DataRef
		s code = objCompositeSimple.ValueCode
		s desc = objCompositeSimple.DataValue
		s result = rowID_"|"_code_"|"_desc
	}
	elseif(AVType = "Mono")
	{
		s code = objCompositeSimple.ValueCode
		s desc = objCompositeSimple.DataValue
		s result = code_"|"_desc
	}
	elseif(AVType = "Mult")
	{
		s result = ""
		s code = objCompositeSimple.ValueCode
		s desc = objCompositeSimple.DataValue
		s separator = objCompositeSimple.Separator
		s count = $l(code,separator)
		for I=1:1:count
		{
			s:(I '= 1) result = result_"#"
			s result = result_$p(code,separator,I)_"|"_$p(desc,separator,I)
		}
	}
	q result
}

/// Desc:       取EMRinstance.ICompositeMacro(公式)内容
/// Creator:    Candy
/// CreateDate: 2018-5-15
/// Input:      AID EMRinstance.ICompositeMacro 的 rowID
///            AVType 取值类型
/// Output:     单元值
ClassMethod GetCompositeMacroData(AID As %String, AVType As %String) As %String
{
	s result = ""
	q:(AID = "") result
	s obj = ##Class(EMRinstance.ICompositeMacro).%OpenId(AID)
	q:(obj = "") result
	
	if (AVType = "T")
	{
		do obj.Text.Rewind()
		while (obj.Text.AtEnd = 0) 
	  	{ 	s len = 1024
	    	s tmpStr = obj.Text.Read(len)
	    	s result = result_tmpStr  
	   	}
	}
	elseif( AVType = "S")
	{
		do obj.StyleText.Rewind()
		while (obj.Text.AtEnd = 0) 
	  	{ 	s len = 1024
	    	s tmpStr = obj.StyleText.Read(len)
	    	s result = result_tmpStr  
	   	}	
	}
	q result
}

/// Desc:       取EMRinstance.IMacroObjectItems(公式项内容)内容
/// Creator:    Candy
/// CreateDate: 2018-5-15
/// Input:      AEpisodeID 就诊号
///             ATemplateID 模板ID
///             ACode  SCODE:S005|CCODE:V005|MACODE:MA0001|MASCODE:MENARCHE    
///             AInstanceID
///             AVType 取值类型
/// Output:     单元值
ClassMethod GetMacroObjectItemsData(AEpisodeID As %String, ATemplateID As %String, ACode As %String, AInstanceID As %String) As %String
{
	s result = ""
	q:((AEpisodeID = "")||(ACode = "")||(ATemplateID = "")) result
	s sCode = $p($p(ACode,"|",1),":",2)
	s cCode = $p($p(ACode,"|",2),":",2) 
	s mcCode = $p($p(ACode,"|",3),":",2)
	s mcName = $p($p(ACode,"|",4),":",2)
	
	s sCode = $zcvt(sCode,"U")
	s cCode = $zcvt(cCode,"U")
	s mcCode = $zcvt(mcCode,"U")
	s mcName = $zcvt(mcName,"U")
	
	if (AInstanceID = "")
	{
		s instanceId = ""
		for
		{
			s instanceId = $o(^DHCEMRI.IMacroObjectItemsI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_sCode," "_cCode," "_mcCode,instanceId),-1)
			q:(instanceId = "")
			s tmpInstanceId = $tr(instanceId," ","")
			s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(tmpInstanceId)
			continue:(objInstance = "")
			q:($zcvt(objInstance.Status,"U") = "SAVE")
		}		
	}
	else
	{
		s instanceId = AInstanceID
	}
	s instanceId = $tr(instanceId," ","")
	q:(instanceId = "") result
	s result = ..GetMacroObjectItemsDataByInstanceID(AEpisodeID,instanceId,ATemplateID,sCode,cCode,mcCode,mcName)
	q result
}

/// Desc:       取EMRinstance.ICompositeMacro(公式)内容
/// Creator:    Candy
/// CreateDate: 2018-5-15
/// Input:      AID EMRinstance.ICompositeMacro 的 rowID
///            AVType 取值类型
/// Output:     单元值
ClassMethod GetMacroObjectItemsDataByInstanceID(AEpisodeID, AInstanceID, ATemplateID, ASCode, ACCode, AMcCode, AMcName As %String) As %String
{
	s result = ""
	q:(AInstanceID = "") result
	s rowId = $o(^DHCEMRI.IMacroObjectItemsI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_ASCode," "_ACCode," "_AMcCode," "_AInstanceID," "_AMcName," PREFIX",""))
	if (rowId '= "")
	{ 
		s obj = ##Class(EMRinstance.IMacroObjectItems).%OpenId(rowId)
		s:(obj '= "") result = obj.Value
	}
	s rowId = $o(^DHCEMRI.IMacroObjectItemsI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_ASCode," "_ACCode," "_AMcCode," "_AInstanceID," "_AMcName," VALUE",""))
	if (rowId '= "")
	{ 
		s obj = ##Class(EMRinstance.IMacroObjectItems).%OpenId(rowId)
		s:(obj '= "") result = result_obj.Value
	}	
	s rowId = $o(^DHCEMRI.IMacroObjectItemsI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_ASCode," "_ACCode," "_AMcCode," "_AInstanceID," "_AMcName," SUFFIX",""))
	if (rowId '= "")
	{ 
		s obj = ##Class(EMRinstance.IMacroObjectItems).%OpenId(rowId)
		s:(obj '= "") result = result_obj.Value
	}
	q result
}

/// Desc:       取模板打散数据
/// Creator:    yejian
/// CreateDate: 2014-07-24
/// Input:      AEpisodeID 就诊号
///            AItem 单元路径(TYPE:ICompositeSample#TID:81#SCODE:S001#VTYPE:S|CCODE:VK1#VTYPE:S|CSCODE:L010#VTYPE:V
///            AInstanceID 实例数据ID
/// Return:     result 实例数据单元值
/// Debug:      w ##Class(EMRservice.BL.BLScatterData).GetTGScatterData(76,"TYPE:ICompositeSample#TID:2#SCODE:S005|CCODE:32|CSCODE:L001#VTYPE:V","")           
ClassMethod GetTGScatterData(AEpisodeID As %String, templateId As %String, AInstanceID As %String, itemCode As %String, valueType As %String, elementType As %String) As %String
{
	s result = ""
	q:(AEpisodeID = "") result
	q:(AInstanceID ="") result
	s rowId =""
	if (elementType = "ISECTIONDESC")
	{	
		if (templateId'="-1")
		{
			s rowId = ##Class(EMRservice.BL.BLScatterData).GetSectionID(AEpisodeID,templateId,itemCode,AInstanceID)
		}
		else
		{
			s rowId = ##Class(EMRservice.BL.BLScatterData).GetSectionIDBySecCode(AEpisodeID,templateId,itemCode,AInstanceID)
		}
		q:(rowId = "") result
		s result = ##Class(EMRservice.BL.BLScatterData).GetSectionData(rowId,valueType)
	}
	elseif(elementType = "ICOMPOSITEDESC")
	{
		s rowId = ##Class(EMRservice.BL.BLScatterData).GetCompositeID(AEpisodeID,templateId,itemCode,AInstanceID)
		q:(rowId = "") result
		s result = ##Class(EMRservice.BL.BLScatterData).GetCompositeData(rowId,valueType)		
	}
	elseif(elementType = "ICOMPOSITESAMPLE")
	{
		if (templateId'="-1")
		{
			s rowId = ##Class(EMRservice.BL.BLScatterData).GetCompositeSimpleID(AEpisodeID,templateId,itemCode,AInstanceID)
		}
		else
		{
			s rowId = ##Class(EMRservice.BL.BLScatterData).GetComSimIDBySecSimCode(AEpisodeID,templateId,itemCode,AInstanceID)
	
		}
		q:(rowId = "") result
		s result = ##Class(EMRservice.BL.BLScatterData).GetCompositeSimpleData(rowId,valueType)
	}
	elseif(elementType = "ICONCEPTDESC")
	{
		s rowId = ##Class(EMRservice.BL.BLScatterData).GetConIDByConCode(AEpisodeID,templateId,itemCode,AInstanceID)
		q:(rowId = "") result
		s result = ##Class(EMRservice.BL.BLScatterData).GetConceptData(rowId,valueType)		
	}
	elseif(elementType = "ICONCEPTSAMPLE")
	{
		s rowId = ##Class(EMRservice.BL.BLScatterData).GetConSimIDByConCode(AEpisodeID,templateId,itemCode,AInstanceID)
		q:(rowId = "") result
		s result = ##Class(EMRservice.BL.BLScatterData).GetConceptSimpleData(rowId,valueType)		
	}
	elseif(elementType = "IMACRODESC")  //月经史取值
	{
		s rowId = ##Class(EMRservice.BL.BLScatterData).GetCompositeMacroID(AEpisodeID,templateId,itemCode,AInstanceID)
		q:(rowId = "") result
		s result = ##Class(EMRservice.BL.BLScatterData).GetCompositeMacroData(rowId,valueType)				
	}
	elseif(elementType = "IMACROSAMPLE")  //月经史子项取值
	{
		s result = ##Class(EMRservice.BL.BLScatterData).GetMacroObjectItemsData(AEpisodeID,templateId,itemCode,AInstanceID)
	}
	q result
}

/// Desc:       返回GetSectionDesc的rowID
/// Creator:    yejian
/// CreateDate: 2016-3-22
/// Input:      AEpisodeID 就诊号
///             ATemplateID 模板ID
///             ACode 单元代码(路径)
///             AInstanceID 就诊号
/// Return:     EMRinstance.ISectionDesc 的 rowID
/// Debug:      w ##Class(EMRservice.BL.BLScatterData).GetSectionIDBySecCode(76,2,"Code:S001","")
ClassMethod GetSectionIDBySecCode(AEpisodeID As %String, ATemplateID As %String, ACode As %String, AInstanceID As %String) As %String
{
	s result = ""
	q:((AEpisodeID = "")||(ATemplateID = "")||(ACode = "")) result
	s sCode = $p(ACode,":",2)
	s SCode = $zcvt(sCode,"U")
	s instanceId= ""
	if (AInstanceID '= "")
	{
		s instanceId = " "_AInstanceID
	}
	q:(instanceId = "") result
	s result = $o(^DHCEMRI.ISectionDescI("IdxForUpdate",instanceId," "_SCode,""))
	q result
}

/// Desc:       返回GetSectionDesc的rowID
/// Creator:    yejian
/// CreateDate: 2016-3-22
/// Input:      AEpisodeID 就诊号
///             ATemplateID 模板ID
///             ACode 单元代码(路径)
///             AInstanceID 就诊号
/// Return:     EMRinstance.ISectionDesc 的 rowID
/// Debug:      w ##Class(EMRservice.BL.BLScatterData).GetComSimIDBySecSimCode(76,81,"SCODE:S001|CCODE:29|CSCODE:I001","")
ClassMethod GetComSimIDBySecSimCode(AEpisodeID As %String, ATemplateID As %String, ACode As %String, AInstanceID As %String) As %String
{
	s result = ""
	q:((AEpisodeID = "")||(ACode = "")||(ATemplateID = "")) result
	s sCode = $p($p(ACode,"|",1),":",2)
	s csCode = $p($p(ACode,"|",2),":",2)
	
	s sCode = $zcvt(sCode,"U")
	s csCode = $zcvt(csCode,"U")
	s cCode = ""
	s instanceId= ""
	if (AInstanceID '= "")
	{
		s instanceId = " "_AInstanceID
	}
	q:(instanceId = "") result
	s cCode = $o(^DHCEMRI.ICompositeSimpleI("IdxForUpdate",instanceId," "_sCode,cCode))
	q:(cCode = "") result
	s result = $o(^DHCEMRI.ICompositeSimpleI("IdxForUpdate",instanceId," "_sCode,cCode," "_csCode,""))
	q result
}

/// Desc:       返回EMRinstance.ICompositeConceptSimple的rowID
/// Creator:    yejian
/// CreateDate: 2017-1-3
/// Input:      AEpisodeID 就诊号
///             ATemplateID 模板ID
///             ACode 单元代码(路径)
///             AInstanceID 就诊号
/// Return:     EMRinstance.ICompositeConceptSimple 的 rowID
/// Debug:      w ##Class(EMRservice.BL.BLScatterData).GetConSimIDByConCode(76,81,"SCODE:S006|CCODE:V008|MCC0001","")
ClassMethod GetConIDByConCode(AEpisodeID As %String, ATemplateID As %String, ACode As %String, AInstanceID As %String) As %String
{
	s result = ""
	q:((AEpisodeID = "")||(ACode = "")||(ATemplateID = "")) result
	s sCode = $p($p(ACode,"|",1),":",2)
	s csCode = $p($p(ACode,"|",2),":",2)
	s coCode = $p($p(ACode,"|",3),":",2)
	
	s sCode = $zcvt(sCode,"U")
	s csCode = $zcvt(csCode,"U")
	s coCode = $zcvt(coCode,"U")
	s instanceId= ""
	if (AInstanceID '= "")
	{
		s instanceId = " "_AInstanceID
	}
	q:(instanceId = "") result

	s result = $o(^DHCEMRI.ICompositeConceptI("IdxForUpdate",instanceId," "_sCode," "_csCode," "_coCode,""))
	q result
}

/// Desc:       返回EMRinstance.ICompositeConceptSimple的rowID
/// Creator:    yejian
/// CreateDate: 2017-1-3
/// Input:      AEpisodeID 就诊号
///             ATemplateID 模板ID
///             ACode 单元代码(路径)
///             AInstanceID 就诊号
/// Return:     EMRinstance.ICompositeConceptSimple 的 rowID
/// Debug:      w ##Class(EMRservice.BL.BLScatterData).GetConSimIDByConCode(76,81,"SCODE:S001|CCODE:29|CSCODE:I001","")
ClassMethod GetConSimIDByConCode(AEpisodeID As %String, ATemplateID As %String, ACode As %String, AInstanceID As %String) As %String
{
	s result = ""
	q:((AEpisodeID = "")||(ACode = "")||(ATemplateID = "")) result
	s sCode = $p($p(ACode,"|",1),":",2)
	s csCode = $p($p(ACode,"|",2),":",2)
	s coCode = $p($p(ACode,"|",3),":",2)
	s cosCode = $p($p(ACode,"|",4),":",2)
		
	s sCode = $zcvt(sCode,"U")
	s csCode = $zcvt(csCode,"U")
	s coCode = $zcvt(coCode,"U")
	s cosCode = $zcvt(cosCode,"U")
	s instanceId= ""
	if (AInstanceID '= "")
	{
		s instanceId = " "_AInstanceID
	}
	q:(instanceId = "") result
	s result = $o(^DHCEMRI.IConceptSimpleI("IdxForUpdate",instanceId," "_sCode," "_csCode," "_coCode," "_cosCode,""))
	q result
}

/// Desc:       取知识库打散数据
/// Creator:    yejian
/// CreateDate: 2014-07-24
/// Input:      AEpisodeID 就诊号
///            AItem 单元路径(TYPE:ICompositeSample#TID:81#SCODE:S001#VTYPE:S|CCODE:VK1#VTYPE:S|CSCODE:L010#VTYPE:V
///            AInstanceID 实例数据ID
/// Return:     result 实例数据单元值
/// Debug:      w ##Class(EMRservice.BL.BLScatterData).GetTGScatterData(76,"TYPE:ICompositeSample#TID:2#SCODE:S005|CCODE:32|CSCODE:L001#VTYPE:V","")           
ClassMethod GetKBScatterData(AEpisodeID As %String, AInstanceID As %String, itemCode As %String, valueType As %String, elementType As %String) As %String
{
	s result = ""
	q:(AEpisodeID = "") result
	q:(AInstanceID ="") result
	
	if (elementType = "ICOMPOSITEDESC")
	{
		s CompositeCode = ""
		if ($l(itemCode,"|")=1)
		{
			s CompositeCode = $p($p(itemCode,"|",1),":",2)
		}
		q:(CompositeCode="") ""
		s curSectionCode = ""
		for {
			s curSectionCode = $o(^DHCEMRI.ICompositeDescI("IdxForGetSection"," "_AInstanceID," "_CompositeCode,curSectionCode))
			q:(curSectionCode = "")
			s curRowID= ""
			s curRowID = $o(^DHCEMRI.ICompositeDescI("IdxForGetSection"," "_AInstanceID," "_CompositeCode,curSectionCode,curRowID))
			continue:(curRowID = "")
			s result = ##Class(EMRservice.BL.BLScatterData).GetCompositeData(curRowID,valueType)
			q:(result'="")
		}
	}
	elseif(elementType = "ICOMPOSITESAMPLE")
	{
		s CompositeCode = ""
		s SimpleItemCode = ""
		if ($l(itemCode,"|")=2)
		{
			s CompositeCode = $p($p(itemCode,"|",1),":",2) 
			s SimpleItemCode = $p($p(itemCode,"|",2),":",2)
		}
		q:(CompositeCode="") ""
		q:(SimpleItemCode="") ""
		
		s curSectionCode = ""
		for {
			s curSectionCode = $o(^DHCEMRI.ICompositeSimpleI("IdxForGetSection"," "_AInstanceID," "_CompositeCode," "_SimpleItemCode,curSectionCode))
			q:(curSectionCode = "")
			s curRowID= ""
			s curRowID = $o(^DHCEMRI.ICompositeSimpleI("IdxForGetSection"," "_AInstanceID," "_CompositeCode," "_SimpleItemCode,curSectionCode,curRowID))
			continue:(curRowID = "")
			s curRes = ##Class(EMRservice.BL.BLScatterData).GetCompositeSimpleData(curRowID,valueType)
			s:(curRes'="") result=$case(result,"":curRes,:result_"^"_curRes)
		}
		//嵌套、多次插入知识库扩展表查询
		s curSectionCode = ""
		for {
			s curSectionCode = $o(^DHCEMRI.ICompSimpExpandI("IdxForGetSection"," "_AInstanceID," "_SimpleItemCode," "_CompositeCode,curSectionCode))
			q:(curSectionCode = "")
			s expRowID= ""
			for {
				s expRowID = $o(^DHCEMRI.ICompSimpExpandI("IdxForGetSection"," "_AInstanceID," "_SimpleItemCode," "_CompositeCode,curSectionCode,expRowID))
				q:(expRowID = "")
				s objExpend = ##class(EMRinstance.ICompSimpExpand).%OpenId(expRowID)
				s curRowID = objExpend.ICompositeSimpleID
				s curRes = ##Class(EMRservice.BL.BLScatterData).GetCompositeSimpleData(curRowID,valueType)
				s:(curRes'="") result=$case(result,"":curRes,:result_"^"_curRes)
			}
		}
	}
	elseif(elementType = "ICONCEPTDESC")
	{
		
		s CompositeCode = ""
		s coCode = ""
		if ($l(itemCode,"|")=2)
		{
			s CompositeCode = $p($p(itemCode,"|",1),":",2)
			s coCode = $p($p(itemCode,"|",2),":",2)
		}
		q:(CompositeCode="") ""
		q:(coCode="") ""
		s curSectionCode = ""
		for {
			s curSectionCode = $o(^DHCEMRI.ICompositeConceptI("IdxForGetSection"," "_AInstanceID," "_CompositeCode," "_coCode,curSectionCode))
			q:(curSectionCode = "")
			s curRowID= ""
			s curRowID = $o(^DHCEMRI.ICompositeConceptI("IdxForGetSection"," "_AInstanceID," "_CompositeCode," "_coCode,curSectionCode,curRowID))
			continue:(curRowID = "")
			s result = ##Class(EMRservice.BL.BLScatterData).GetConceptData(curRowID,valueType)
			q:(result'="")
		}
		
	}
	elseif(elementType = "ICONCEPTSAMPLE")
	{
		s CompositeCode = ""
		s coCode = ""
		s SimpleItemCode = ""
		
		if ($l(itemCode,"|")=3)
		{
			s CompositeCode = $p($p(itemCode,"|",1),":",2) 
			s coCode = $p($p(itemCode,"|",2),":",2)
			s SimpleItemCode = $p($p(itemCode,"|",3),":",2)
		}
		q:(CompositeCode="") ""
		q:(coCode="") ""
		q:(SimpleItemCode="") ""
		s curSectionCode = ""
		for {
			s curSectionCode = $o(^DHCEMRI.IConceptSimpleI("IdxForGetSection"," "_AInstanceID," "_CompositeCode," "_coCode," "_SimpleItemCode,curSectionCode))
			q:(curSectionCode = "")
			s curRowID= ""
			s curRowID = $o(^DHCEMRI.IConceptSimpleI("IdxForGetSection"," "_AInstanceID," "_CompositeCode," "_coCode," "_SimpleItemCode,curSectionCode,curRowID))
			continue:(curRowID = "")
			s result = ##Class(EMRservice.BL.BLScatterData).GetConceptSimpleData(curRowID,valueType)
			q:(result'="")
		}
	}
	q result
}

/// Desc: 	使用术语集取电子病历打散数据
/// Return:	metaItemInfo$|value&|metaItemInfo$|value
/// Debug: 	w ##class(EMRservice.BL.BLScatterData).GetNewScatterDataByGlossaryID("503","861","")
ClassMethod GetNewScatterDataByGlossaryID(AEpisodeID As %String, AGlossaryID As %String, AInstanceID As %String, Output aRowID As %String = "") As %String
{
	s ret = ""
	q:($d(AEpisodeID) = 0)||(AEpisodeID = "") ret
	q:($d(AGlossaryID) = 0)||(AGlossaryID = "") ret
	q:($d(AInstanceID) = 0)||(AInstanceID = "") ret
	s objGlossary = ##Class(EPRmeta.Glossary).%OpenId(AGlossaryID)
	q:(objGlossary = "") ret
	//b
	s name = objGlossary.Name
	s type = objGlossary.GlossaryType
	s strInstanceID = AInstanceID
	if ($zcvt(type,"U") = "TG")
	{
		s rowID = ""
		for {
			s rowID = $o(^DHCEPRM.GlossaryItemI("IdxGlossaryID",AGlossaryID,rowID))
			q:(rowID = "")
			
			s objItem = ##Class(EPRmeta.GlossaryItem).%OpenId(rowID)
			s aRowID =rowID
			s itemCodes = objItem.ItemCode
			s valueType = objItem.ValueType
			s templateID = objItem.TemplateID
			s strInstanceID = AInstanceID
			s objIn = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
			s tempID = objIn.RealTemplateID
			if (templateID '= tempID)
			{
			    s strInstanceID = ..GetInstanceByEpisodeTemID(AEpisodeID,templateID)
			}
			s strTemType = objItem.TemType
			if (($zcvt(strTemType,"U") ="NEW")||($zcvt(strTemType,"U") ="BASE"))
			{
				s itemCode	= ""
				s elementType = ""
				q:('itemCodes [ "#")
				s ItemList = ##Class(EMRservice.Tools.Tool).GetListFromString(itemCodes,"#")
				q:($ll(ItemList) '= 2)
				s elementType = $zcvt($p($lg(ItemList,1),":",2),"U")
				s itemCode = $lg(ItemList,2)
				s ret = ""
				s ret = ..GetTGScatterData(AEpisodeID,templateID,strInstanceID,itemCode,valueType,elementType)
			}
			//取EMRinstance.InstanceData表其他属性字段的值
			elseif($zcvt(strTemType,"U") = "EMRINSTANCE")
			{
				s ret = ..GetInstanceDataProperty(AEpisodeID,itemCodes,valueType,AInstanceID)
			}
			q:(ret '= "")&&(ret '= "Null")

			q:(ret '= "")&&(ret '= "Null")
		}	
	}
	else
	{
		s kbRowID = ""
		for {
			s kbRowID = $o(^DHCEPRM.GlossaryKBItemI("IdxGlossaryID",AGlossaryID,kbRowID))
			q:(kbRowID = "")
			s aRowID =kbRowID
			s objParItem = ##Class(EPRmeta.GlossaryKBItem).%OpenId(kbRowID)
			s curItemCodes = objParItem.ItemCode
			s curValueType = objParItem.ValueType
			s kbPartNo = objParItem.KBPartNo
			S KBNodeID = objParItem.KBNodeID
			
			s strKBType = objParItem.KBType
			if ($zcvt(strKBType,"U") ="NEW")
			{
				s itemCode	= ""
				s elementType = ""
				q:('curItemCodes [ "#")
				s ItemList = ##Class(EMRservice.Tools.Tool).GetListFromString(curItemCodes,"#")
				q:($ll(ItemList) '= 2)
				s elementType = $zcvt($p($lg(ItemList,1),":",2),"U")
				s itemCode = $lg(ItemList,2)
				//去掉"SCODE:"+前面的一个特殊符号
				s itemCode = $e(itemCode,7,$l(itemCode))
				s ret = ""
				s ret = ..GetKBScatterData(AEpisodeID,AInstanceID,itemCode,curValueType,elementType)
			}
		}	
	}
	s:(ret="Null") ret = ""
	q ret
}

/// Desc:	通过就诊号，获取instanceData表中其他属性字段值
/// Input：	AEpisodeID : 就诊指针
/// 		ACategoryInternalID : 指定术语集范畴内部标识符
/// Output:	获取instanceID，重复模板获取最新的保存状态的instanceID。
/// Debug:	w ##Class(EMRservice.BL.BLScatterData).GetInstanceDataProperty("7","Tooth#ToothPCode|AUR.1","CV","")
ClassMethod GetInstanceDataProperty(AEpisodeID As %String, itemCodes As %String, valueType As %String, AInstanceID As %String) As %String
{
	s reslut = ""
	if ($p(itemCodes,"#",1) = "Tooth")
	{
		s toothInCode = $p($p(itemCodes,"#",2),"|",2)
		s ToothDataStream = ##class(EMRservice.BL.BLIToothItems).getToothScatterData(AEpisodeID,toothInCode,valueType,AInstanceID)
		while (ToothDataStream.AtEnd = 0)
		{
			s reslut = reslut_$ZSTRIP(ToothDataStream.Read(32000),"*C",,$c(1)_$c(2))
		}
		q reslut
	}
	//EMRinstance.InstanceData#CreateDate|CreateTime
	s strClassName = $p(itemCodes,"#",1)
	s strPropertys = $p(itemCodes,"#",2)
	s strPropertyO = $p(strPropertys,"|",1)
	s strPropertyT = $p(strPropertys,"|",2)
	s strValueO = ""
	s strValueT = ""
	s cmdCreateCls="objData=##class("_strClassName_").%OpenId("""_AInstanceID_""")"
	s @cmdCreateCls
	if (strPropertyO'="")
	{
		s ^TempGetDataProperty(strPropertyO) = ""
		s cmdSetValue ="^TempGetDataProperty("""_strPropertyO_""")=objData."_strPropertyO_""
		s @cmdSetValue
		s strValueO =^TempGetDataProperty(strPropertyO)
		k ^TempGetDataProperty(strPropertyO)
	}
	if (strPropertyT'="")
	{
		s ^TempGetDataProperty(strPropertyT) = ""
		s cmdSetValue ="^TempGetDataProperty("""_strPropertyT_""")=objData."_strPropertyT_""
		s @cmdSetValue
		s strValueT =^TempGetDataProperty(strPropertyT)
		k ^TempGetDataProperty(strPropertyT)
	}
	if ((strPropertyO="CreateUser")||("ModifyUser"=strPropertyO))
	{
		s userName = ""
		&SQL(select ssusr_name into :userName  from SQLUser.SS_User where ssusr_rowid = :strValueO)
		s strValueO = strValueO _"^"_userName
	}
	
	//日期类型转换
	if ((strPropertyO="CreateDate")||("HappenDate"=strPropertyO)||("ModifyDate"=strPropertyO))
	{
		//YYYY-MM-DD HH:MM
		if (strValueO'="")
		{
			s strValueO = $zd(strValueO,3)
		}
	}
	elseif((strPropertyO="CreateTime")||("HappenTime"=strPropertyO)||("ModifyTime"=strPropertyO))
	{
		if (strValueT'="")
		{
			s strValueO = $zt(strValueO,1)
		}
		
	}
	if ((strPropertyT="CreateTime")||("HappenTime"=strPropertyT)||("ModifyTime"=strPropertyT))
	{
		if (strValueT'="")
		{
			s strValueT = $zt(strValueT,1)
		}
		
	}
	if (strValueT'="")
	{
		s reslut = strValueO_" "_strValueT
	}
	else
	{
		s reslut = strValueO
	}
	q reslut
}

/// Desc:	获取InstanceID集合通过AEpisodeID和TemplateID
/// Input：	AEpisodeID : 就诊指针
/// 		ACategoryInternalID : 指定术语集范畴内部标识符
/// Output:	获取instanceID，重复模板获取最新的保存状态的instanceID。
/// Debug:	w ##Class(EMRservice.BL.BLScatterData).GetInstanceIDSByTemID("35","73")
ClassMethod GetInstanceByEpisodeTemID(AEpisodeID As %String, ATemplateID As %String) As %String
{
	s reslut = ""
	s emrTemRowID = ""
	for {
		s emrTemRowID = $o(^DHCEMRM.EMRTemplateI("IdxBindTemplateID"," "_ATemplateID,emrTemRowID))
		q:(emrTemRowID = "")
		s objEMRTem = ##Class(EMRmeta.EMRTemplate).%OpenId(emrTemRowID)
		continue:(objEMRTem="")
		s strChartItemID = objEMRTem.CategoryID
		s strECRowID = ""
		s strECRowID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID,strChartItemID,strECRowID))
		continue:(strECRowID = "")
		s objECRecord = ##Class(EMRinstance.ECRecord).%OpenId(strECRowID)

		Set key = ""
		do
		{ 
	    	S objInstanceData = objECRecord.Instances.GetNext(.key)
		    if (objInstanceData '= "")
	     	{ 
	     	 continue:((objInstanceData.Status="UnSave")||(objInstanceData.Status="Delete"))
		     s reslut = objInstanceData.%Id()
		  	} 
 		 } 
 		 while (key '="" )
	 }
	q reslut
}

/// Desc:	获取指定术语值
/// Input：	AEpisodeID : 就诊指针
/// 		AGlossaryInternalID : 指定术语内部标识符
/// Output:	术语值
/// Debug:	w ##Class(EPRservice.BOScatterData).GetDataByGlossary("201869","HDSD00.11.050")
ClassMethod GetDataByGlossary(AEpisodeID As %String, AGlossaryInternalID As %String, AInstanceID As %String) As %String
{
	q:(AEpisodeID="")||(AGlossaryInternalID="")||(AInstanceID="") ""
	
	s glossaryID = $O(^DHCEPRM.GlossaryI("IdxGlossaryID"," "_AGlossaryInternalID,""))
	q:(glossaryID="") ""
	
	s value = ##class(EMRservice.BL.BLScatterData).GetNewScatterDataByGlossaryID(AEpisodeID,glossaryID,AInstanceID)
	
	q value
}

/// Desc:	获取指定术语集范畴下的所有标准术语值
/// Input：	AEpisodeID : 就诊指针
/// 		ACategoryInternalID : 指定术语集范畴内部标识符
/// 		AState:病历状态，SAVE：保存，SIGN:签名状态，PRINT:打印状态。（空值为保存状态）
/// Output:	术语值数组
/// Debug:	w ##Class(EMRservice.BL.BLScatterData).GetNewDataByGlossaryCategory("356","HDSD00.13.03")
ClassMethod GetNewDataByGlossaryCategory(AEpisodeID As %String, ACategoryInternalID As %String, AState As %String = "") As %ArrayOfDataTypes
{
	s ret = ##Class(%ArrayOfDataTypes).%New()
	q:($d(AEpisodeID) = 0)||(AEpisodeID = "") ret
	q:($d(ACategoryInternalID) = 0)||(ACategoryInternalID = "") ret
	
	//判断是旧版还是新版
	//s count = ..GetOldRecCount(AEpisodeID)
	s version = ..GetDataVersion(AEpisodeID)
	q:(version = "") ret
	if (version = 2)
	{
		s ret = ##Class(EPRservice.BOScatterData).GetDataByGlossaryCategory(AEpisodeID,ACategoryInternalID)
	}
	elseif(version = 4)
	{
		s ret = ##class(EMR.DOC.BL.GlossaryAchieveValue).GetGlossaryValue(AEpisodeID,ACategoryInternalID,"127.0.0.1"," ","EMR","")
	}
	else
	{
		s glossaryCategoryID = $O(^DHCEPRM.GlossaryCategoryI("IdxOnInternalID"," "_ACategoryInternalID,""))
		q:(glossaryCategoryID="") ret
		//通过术语集目录获取关联的模板ID
		s objGlossaryCategory =  ##Class(EPRmeta.GlossaryCategory).%OpenId(glossaryCategoryID)
		q:(objGlossaryCategory="") ret
		s templateCategoryID =..GetGlossaryTemplateIDS(ACategoryInternalID)
		if (templateCategoryID="")
		{
			s templateCategoryID = objGlossaryCategory.TemplateCategroyID
		}
		q:(templateCategoryID="") ret
		//获取InstanceID集合
		s InstanceIDS = ..GetInstanceIDByTInterID(AEpisodeID,templateCategoryID,ACategoryInternalID,AState)
		s intInsCount = $ll(InstanceIDS)
		q:(intInsCount = 0) ret
		for i = 1:1:intInsCount
		{
			s AInstanceID = $lg(InstanceIDS,i)
			continue:(AInstanceID="")
			s retArray = ##Class(%ArrayOfDataTypes).%New()
			
			s glossaryID = ""
			for {
				s glossaryID = $O(^DHCEPRM.GlossaryI("IdxCategoryID"," "_glossaryCategoryID,glossaryID))
				q:(glossaryID="")
		
				s objGlossary = ##Class(EPRmeta.Glossary).%OpenId(glossaryID)
				continue:(objGlossary="")
			
				s strDataValue = ""
				//通过注册号，术语rowId获取业务数据
				s strDataValue =..GetNewScatterDataByGlossaryID(AEpisodeID,glossaryID,AInstanceID)
			 	d ret.SetAt(strDataValue, objGlossary.InternalID)
			 	
			 	//获取知识库节点数据
				s glossarySubID = ""
				for
				{
					s glossarySubID = $o(^DHCEPRM.GlossaryI("IdxParentID"," "_glossaryID,glossarySubID))
					q:(glossarySubID = "")
					s objsubGlossary = ##Class(EPRmeta.Glossary).%OpenId(glossarySubID)
					continue:(objsubGlossary = "")
					
					s strDataValue = ""
					//通过注册号，术语rowId获取业务数据
					s strDataValue =..GetNewScatterDataByGlossaryID(AEpisodeID,glossarySubID,AInstanceID)
			 		d ret.SetAt(strDataValue, objsubGlossary.InternalID)
				}
			 }
			//d ret.SetAt(retArray, AInstanceID)
		 }
	 }
	 q ret
}

/// Desc:	获取指定术语集范畴下的所有标准术语值
/// Input：	AEpisodeID : 就诊指针
/// 		ACategoryInternalID : 指定术语集范畴内部标识符
/// Output:	术语值数组
/// Debug:	w ##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory("112","HDSD00.11")
ClassMethod GetNewStdDataByGlossaryCategory(AEpisodeID As %String, ACategoryInternalID As %String) As %ArrayOfDataTypes
{
 
	s ret = ##Class(%ArrayOfDataTypes).%New()
	q:($d(AEpisodeID) = 0)||(AEpisodeID = "") ret
	q:($d(ACategoryInternalID) = 0)||(ACategoryInternalID = "") ret
	//判断是旧版还是新版
	//s count = ..GetOldRecCount(AEpisodeID)
	s version = ..GetDataVersion(AEpisodeID)
	q:(version = "") ret
	if (version = 2)
	{
		s ret = ##Class(EPRservice.BOScatterData).GetStandByGlossaryCategory(AEpisodeID,ACategoryInternalID)
	}
	elseif(version = 4)
	{
		s ret = ##class(EMR.DOC.BL.GlossaryAchieveValue).GetGlossaryValue(AEpisodeID,ACategoryInternalID,"127.0.0.1"," ","EMR","")
	}
	else
	{
		s glossaryCategoryID = $O(^DHCEPRM.GlossaryCategoryI("IdxOnInternalID"," "_ACategoryInternalID,""))
		q:(glossaryCategoryID="") ret
		//通过术语集目录获取关联的模板ID
		s objGlossaryCategory =  ##Class(EPRmeta.GlossaryCategory).%OpenId(glossaryCategoryID)
		q:(objGlossaryCategory="") ret
		s templateCategoryID =..GetGlossaryTemplateIDS(ACategoryInternalID)
		if (templateCategoryID="")
		{
			s templateCategoryID = objGlossaryCategory.TemplateCategroyID
		}
		q:(templateCategoryID="") ret
		//获取InstanceID集合
		s InstanceIDS = ..GetInstanceIDByTInterID(AEpisodeID,templateCategoryID,ACategoryInternalID)
		s intInsCount = $ll(InstanceIDS)
		q:(intInsCount = 0) ret
		for i = 1:1:intInsCount
		{
			s AInstanceID = $lg(InstanceIDS,i)
			continue:(AInstanceID="")
			s retArray = ##Class(%ArrayOfDataTypes).%New()
			s templateID = ""
			s glossaryID = ""
			for {
				s glossaryID = $O(^DHCEPRM.GlossaryI("IdxCategoryID"," "_glossaryCategoryID,glossaryID))
				q:(glossaryID="")
				//w glossaryID
				s objGlossary = ##Class(EPRmeta.Glossary).%OpenId(glossaryID)
				continue:(objGlossary="")
				//w objGlossary.Description,!
				s strDataValues = ""
				
				//通过注册号，术语rowId获取业务数据
				s strDataValues =..GetNewScatterDataByGlossaryID(AEpisodeID,glossaryID,AInstanceID)
				;continue:(strDataValues = "")
			 	s strDataValue=strDataValues
		 	
				s deName = objGlossary.Name
				s deName = $p(deName," ",2)
				s strInternalID = objGlossary.InternalID
				//关联标准数据元标识符
				S strMetaID = objGlossary.MetaID
				s strDescription = objGlossary.Description
				
				/* test 
				if ("HDSD00.03.057"=strInternalID)
				{
					//b "s" //s strtest = ""
				}*/
				
				//如果没有关联数据元标示符，直接返回业务值
				if ((strMetaID = "") || (strMetaID=$char(0)))
				{
					//if (""'=strDataValues) w strInternalID _"^"_deName_"^"_strDataValues,!
					d ret.SetAt(strDataValue, strInternalID)
					continue
				}
				//通过数据元标识符取数据元
				s derowID = ""
				s derowID = $o(^DHCEPRM.DataElementI("IdxEntifier"," "_strMetaID,derowID))
				if (derowID = "")
				{
					s derowID = ##Class(EPRmeta.DataElement).SelectByEntifier(strMetaID)
				}
				s strDataType =""
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
				}
				
				//判断数据类型
				if ((strDataType'="")&(strDataValue'=""))
				{
					s strDataValue =##class(EPRservice.BOScatterData).GetDataByType(strDataValue,strDataType)
				}

				//判断数据元数据格式
				if ((strFormat'="")&(strDataValue'=""))
				{
					if (sysCode'=""){
					s sysCode = ##class(EPRservice.BOScatterData).GetDataByFormat(sysCode,strFormat,"1")
					}
					else
					{
						s strDataValue = ##class(EPRservice.BOScatterData).GetDataByFormat(strDataValue,strFormat,"1")
					}
				}
		
		
				//处理日期数据类型
				/*
				if ((strValueType'="")&(itemCode'="")&(strDataValue'=""))
				{
					if ($e(itemCode,1,1)="D")
					{
						s:(strValueType="C") sysCode= $zdt($zdth(strDataValue,3,1),3,1)
						s:(strValueType="YMD") sysCode= $zd($zdh(strDataValue,3),3)
					}
				}
				*/
				if ((sysCode = "")&(strDataValue'="")&(strValueType = "C"))
				{
					s sysCode = strDataValue
					s strDataValue = " "
				}
				//处理按ValueType返回结果
				s strDataValues = $s(strValueType="VANDC":strDataValue,strValueType="V":strDataValue,strValueType="":strDataValue,strValueType="T":strDataValue,strValueType="C":sysCode,strValueType="YMD":sysCode,1:strDataValue)
				
				//w strInternalID _"^"_deName_"^"_strDataValues,!
				d ret.SetAt(strDataValues, strInternalID)
			}
			;d ret.SetAt(retArray, AInstanceID)
		}
	}
	q ret
}

/// Desc:	获取指定术语集范畴下的所有标准术语值
/// Input：	AEpisodeID : 就诊指针
/// 		ACategoryInternalID : 指定术语集范畴内部标识符
/// Output:	术语值数组
/// Debug:	w ##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary("35","HDSD00.11")
ClassMethod GetNewStdDataByGlossary(AEpisodeID As %String, ACategoryInternalID As %String, AInstanceID As %String = "") As %ArrayOfDataTypes
{
	s ret = ##Class(%ArrayOfDataTypes).%New()
	q:($d(AEpisodeID) = 0)||(AEpisodeID = "") ret
	q:($d(ACategoryInternalID) = 0)||(ACategoryInternalID = "") ret
	s version = ..GetDataVersion(AEpisodeID)
	q:(version = "") ret
	if (version = 2)
	{
		s ret = ##Class(EPRservice.BOScatterData).GetStandByGlossaryCategory(AEpisodeID,ACategoryInternalID)
	}
	elseif(version = 4)
	{
		s ret = ##class(EMR.DOC.BL.GlossaryAchieveValue).GetGlossaryValue(AEpisodeID,ACategoryInternalID,"127.0.0.1"," ","EMR","")
	}
	else
	{
		s glossaryCategoryID = $O(^DHCEPRM.GlossaryCategoryI("IdxOnInternalID"," "_ACategoryInternalID,""))
		s:(glossaryCategoryID="") glossaryCategoryID =..GetGlossaryTemplateIDS(ACategoryInternalID)
		q:(glossaryCategoryID="") ret
		//通过术语集目录获取关联的模板ID
		s objGlossaryCategory =  ##Class(EPRmeta.GlossaryCategory).%OpenId(glossaryCategoryID)
		q:(objGlossaryCategory="")
		if (AInstanceID '="")
		{
			s InstanceIDS = $lb(AInstanceID)
		}
		else
		{
			s templateCategoryID =..GetGlossaryTemplateIDS(ACategoryInternalID)
			if (templateCategoryID="")
			{
				s templateCategoryID = objGlossaryCategory.TemplateCategroyID
				//协和术语集CategoryID=2时与实际数据不一致，所以暂行处理如下
				s templateCategoryID = $s(glossaryCategoryID=2:49,1:objGlossaryCategory.TemplateCategroyID)
			}
			q:(templateCategoryID="") ret
			//获取InstanceID集合
			s InstanceIDS = ..GetInstanceIDByTInterID(AEpisodeID,templateCategoryID,ACategoryInternalID)
		}
		
		s intInsCount = $ll(InstanceIDS)

		q:(intInsCount = 0) ret
		for i = 1:1:intInsCount
		{
			s tmpInstanceID = $lg(InstanceIDS,i)
			continue:(tmpInstanceID="")
			
			s ret = ##Class(%ArrayOfDataTypes).%New()
			s templateID = ""
			s glossaryID = ""
			for {
				s glossaryID = $O(^DHCEPRM.GlossaryI("IdxCategoryID"," "_glossaryCategoryID,glossaryID))
				q:(glossaryID="")
		
				s objGlossary = ##Class(EPRmeta.Glossary).%OpenId(glossaryID)
				continue:(objGlossary="")
			
				s strDataValues = ""
				//通过注册号，术语rowId获取业务数据
				s strDataValues =..GetNewScatterDataByGlossaryID(AEpisodeID,glossaryID,tmpInstanceID, .arowid)
				//continue:(strDataValues = "")
			 	s strDataValue=strDataValues
		 	
				s deName = objGlossary.Name
				s deName = $p(deName," ",2)
				s strInternalID = objGlossary.InternalID
				//关联标准数据元标识符
				S strMetaID = objGlossary.MetaID
				s strDescription = objGlossary.Description
			
				//如果没有关联数据元标示符，直接返回业务值
				if ((strMetaID = "") || (strMetaID=$char(0)))
				{
					
					
					d ret.SetAt(strDataValue, strInternalID)
					continue
				}
				//通过数据元标识符取数据元
				s derowID = ""
				s derowID = $o(^DHCEPRM.DataElementI("IdxEntifier"," "_strMetaID,derowID))
				if (derowID = "")
				{
					s derowID = ##Class(EPRmeta.DataElement).SelectByEntifier(strMetaID)
				}
				s strDataType =""
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
				if (arowid'="")
				{
					s itemRowID = arowid
				}
				else
				{	
					s itemRowID = $o(^DHCEPRM.GlossaryItemI("IdxGlossaryID",glossaryID,arowid))
				}
				if (itemRowID '= "")
				{
					s objGlossaryItem = ##class(EPRmeta.GlossaryItem).%OpenId(itemRowID)
					
					s strValueType = objGlossaryItem.ValueType
					s itemCode = objGlossaryItem.ItemCode
					s templateID = objGlossaryItem.TemplateID
				}
		
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
				}
				
				//判断数据类型
				if ((strDataType'="")&&(strDataValue'=""))
				{
					s strDataValue =##class(EPRservice.BOScatterData).GetDataByType(strDataValue,strDataType)
				}

				//判断数据元数据格式
				//lfb 问题处理 主诉等信息值被清空
				/*
				if ((strFormat'="")&(strDataValue'=""))
				{
					if (sysCode'=""){
					s sysCode = ##class(EPRservice.BOScatterData).GetDataByFormat(sysCode,strFormat,"1")
					}
					else
					{
						s strDataValue = ##class(EPRservice.BOScatterData).GetDataByFormat(strDataValue,strFormat,"1")
					}
				}
				*/
				
				//处理日期数据类型
				if ((strValueType'="")&(itemCode'="")&(strDataValue'=""))
				{
					if ($e(itemCode,1,1)="D")
					{
						//s:(strValueType="C")&&(strDataValue'="─")&&(strDataValue'="—")&&(strDataValue'="-") sysCode= $zdt($zdth(strDataValue,3,1),3,1)
						//s:(strValueType="YMD")&&(strDataValue'="─")&&(strDataValue'="—")&&(strDataValue'="-") sysCode= $zd($zdh(strDataValue,3),3)
						s sysCode=strDataValue
					}
				}
		
				//处理按ValueType返回结果
				//lfb 问题处理 现病史等信息值被清空
				
				s strDataValues = $s(strValueType="V":strDataValue,strValueType="T":strDataValue,strValueType="C":strDataValue,strValueType="YMD":sysCode,1:strDataValue)
				
				//s:(strDataValues="─") strDataValues=""
				
				///手工取可重复模板发生时间
				s:(strInternalID="HDSD00.14.046")&&(strDataValues="") strDataValues=$$GetInstanceHappnenDT(AInstanceID)
				
				////lfb test code
				w:($g(^DHCEMRGlossary("Bee"))="Y") !,"EMR--strInternalID:"_strInternalID_",Name:"_deName_",strDataValues:"_strDataValues
				
				d ret.SetAt(strDataValues, strInternalID)
				
			}
		}
	}
	q ret
CheckInstanceID(intids,glossaryinterid)
	q:(glossaryinterid="")||(intids="")||($a(intids)=2) ""
	q:(glossaryinterid="HDSB05.10") $lb($listget(intids,$listlength(intids)))
	s (glossaryCateTitleCode,idnum,intobj,tmptitlecode,intid,tmpret,gccode)=""
	//1		首 次 病 程 记 录
	//2		日常病程记录
	//3	    上级医师首次查房记录
	//7		转出记录
	//8		转入记录
	//9		交班记录
	//10	接班记录
	//11	阶段小结
	//14	术前讨论记录
	//15	术后首次病程记录
	//20	                  抢救记录
	//42	手术记录
	//63	成熟度-手术知情同意书
	//64	成熟度-麻醉知情同意书
	//65	成熟度-输血治疗同意书
	//66	成熟度-病危（重）通知书
	//69	           输血记录
	//71	专业组查房记录
	//73	成熟度-特殊检查及特殊治疗同意书
	//74	成熟度-其他知情同意书
	s glossaryCateTitleCode=$s(glossaryinterid="HDSD00.14.01":1,glossaryinterid="HDSD00.14.02":2,glossaryinterid="HDSD00.14.03":3,glossaryinterid="HDSD00.14.04":71,glossaryinterid="HDSD00.14.05":"9^10",glossaryinterid="HDSD00.14.06":"7^8",glossaryinterid="HDSD00.14.07":11,glossaryinterid="HDSD00.14.08":20,glossaryinterid="HDSD00.14.10":12,glossaryinterid="HDSD00.14.12":15,glossaryinterid="HDSD00.14.11":14,glossaryinterid="HDSD00.10.01":63,glossaryinterid="HDSD00.10.02":64,glossaryinterid="HDSD00.10.03":65,glossaryinterid="HDSD00.10.04":73,glossaryinterid="HDSD00.10.05":66,glossaryinterid="HDSD00.10.06":74,glossaryinterid="HDSD00.06.02":42,glossaryinterid="HDSD00.06.06":69,1:"")
	s idnum=$ll(intids)
	
	for i=1:1:idnum {
			s intid=$listget(intids,i)
			
			s intobj=##class(EMRinstance.InstanceData).%OpenId(intid)
			s tmptitlecode=intobj.TitleCode
			continue:tmptitlecode="" 
			for m=1:1:$l(glossaryCateTitleCode,"^")
			{
				s gccode=$p(glossaryCateTitleCode,"^",m)
				s:(tmptitlecode=gccode) tmpret=$lb(intid)
				q:(tmpret'="")
			}
				

			
			q:tmpret'=""
				
		}
	s:(tmpret="") tmpret=$lb(intid)
	q tmpret
	
GetInstanceHappnenDT(intid)
	q:(intid="") $zd(+$h,3)_" "_$zt($p($h,",",2),2)
	s intobj=##class(EMRinstance.InstanceData).%OpenId(intid)
	s intobjhpdate=intobj.HappenDate
	s intobjhptime=intobj.HappenTime
	s dtime=$zd(intobjhpdate,3)_" "_$zt(intobjhptime,2)
	
	s intobj=""
	q dtime
}

ClassMethod GetOldRecCount(parEpisodeID As %String) As %Integer
{
	s $zt="errhandler"
	k SLQCODE
	s count=-1
	&sql(select count(*) into :count from EPRinstance.ECRecord where EpisodeID = :parEpisodeID)	
	q count
errhandler
	q -1
}

/// Desc:	获取病历数据版本
/// 	Input:	AEpisodeID : 就诊rowid
/// 	Return:	2 : 二版病历，3 : 三版病历，4:四版病历，空值表示无数据,4:四版病历
ClassMethod GetDataVersion(AEpisodeID As %String) As %String
{
	//如果包含四版代码判断版本走统一方法
	if (##class(%Dictionary.CompiledClass).%ExistsId("EMR.DOC.BL.GlobalData"))
	{
		q ##Class(EMR.DOC.BL.GlobalData).GetEMRVersionID(AEpisodeID)
	} 
	s id = $O(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID, ""))
	q:(id '= "") "2"
	
	s id = $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID, ""))
	q:(id '= "") "3"
	
	s id = $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID, ""))
	q:(id '= "") "3"
	
	s id = $O(^EMR.GB.GlobalDataI("IdxMain",AEpisodeID, ""))
	q:(id '= "") "4"
	
	q ""
}

/// Desc:	获取旧版病历是否有数据
/// 	Input:	AEpisodeID : 就诊rowid
/// 	Return:	1 : 有数据，0 : 无数据
ClassMethod GetDataByLogs(AEpisodeID As %String) As %String
{
	s id = $O(^DHCEPRI.EPRLogsI("IdxMain"," "_AEpisodeID, ""))
	q:(id '= "") "1"
	
	q "0"
}

/// Desc:	获取InstanceID集合通过AEpisodeID和TemplateID
/// Input：	AEpisodeID : 就诊指针
/// 		ACategoryInternalID : 指定术语集范畴内部标识符
/// Output:	术语值数组
/// Debug:	w ##Class(EMRservice.BL.BLScatterData).GetGlossaryTemplateIDS("HDSD00.11")
ClassMethod GetGlossaryTemplateIDS(aInternalID As %String) As %String
{
	s TemplateCategroyID = ""
	q:(aInternalID ="") TemplateCategroyID
	s sub = ""
	for {
		s sub = $o(^DHCEPRM.GlossarysTemplateIDI("IdxInternalID"," "_aInternalID,sub))
		q:(sub = "")
		s objGlossaryTem =##Class(EPRmeta.GlossarysTemplateID).%OpenId(sub)
		q:(objGlossaryTem ="")
		
		if (TemplateCategroyID="")
		{
			/*s objTemplate = ##class(EMRmeta.Template).%OpenId(objGlossaryTem.TemplateID)
			continue:(objTemplate = "")
			s TemplateCategroyID = objTemplate.TemplateCategoryID*/
			s TemplateCategroyID = objGlossaryTem.TemplateID
		}
		else
		{
			/*s objTemplate = ##class(EMRmeta.Template).%OpenId(objGlossaryTem.TemplateID)
			continue:(objTemplate = "")
			s TemplateCategroyID = TemplateCategroyID_"^"_objTemplate.TemplateCategoryID */
			s TemplateCategroyID = TemplateCategroyID_"^"_objGlossaryTem.TemplateID
		}
	}
	q TemplateCategroyID
}

/// Desc:	获取InstanceID集合通过AEpisodeID和TemplateID
/// Input：	AEpisodeID : 就诊指针
/// 		ACategoryInternalID : 指定术语集范畴内部标识符
/// 		AState:病历状态，SAVE：保存，SIGN:签名状态，PRINT:打印状态。（空值为保存状态）
/// Output:	术语值数组
/// Debug:	w ##Class(EMRservice.BL.BLScatterData).GetInstanceIDByTInterID("112","55^38","")
ClassMethod GetInstanceIDByTInterID(AEpisodeID As %String, ATemplateCategoryIDs As %String, ACategoryInternalID As %String = "", AState As %String = "") As %List
{
	s reslut = ""
	s ATemplateID = ""
	s intTC = $L(ATemplateCategoryIDs,"^")
	for i=1:1:intTC
	{
		s ATemplateCategoryID = $p(ATemplateCategoryIDs,"^",i)
		q:(ATemplateCategoryID="")
		s strTitleCode = ""
		if (ACategoryInternalID'="")
		{
			s strTitleCode = ..GetTitleBYGlossaryIntaID(ACategoryInternalID)
		}
		//术语集目录关联模板目录ID改成关联模板ID
		s isTempID = $O(^DHCEPRM.GlossarysTemplateIDI("IdxInternalID"," "_ACategoryInternalID,""))
		if (i=1)&&(isTempID="")
		{
			for {
				s ATemplateID = $o(^DHCEMRM.TemplateI("IndexCategoryId"," "_ATemplateCategoryID,ATemplateID))
				q:(ATemplateID="")
				s reslutID = ..GetInstanceBTInterIDTemID(AEpisodeID,ATemplateID,strTitleCode,.reslut,AState)
			}
		}
		else
		{
			s reslutID = ..GetInstanceBTInterIDTemID(AEpisodeID,ATemplateCategoryID,strTitleCode,.reslut,AState)
		}
	}
	q reslut
}

/// Desc:	获取InstanceID集合通过AEpisodeID和TemplateID
/// Input：	AEpisodeID : 就诊指针
/// 		ACategoryInternalID : 指定术语集范畴内部标识符
/// 		AState:病历状态，SAVE：保存，SIGN:签名状态，PRINT:打印状态。（空值为保存状态）
/// Output:	获取instanceID，重复模板获取最新的保存状态的instanceID。
/// Debug:	w ##Class(EMRservice.BL.BLScatterData).GetInstanceIDSByTemID("35","73")
ClassMethod GetInstanceBTInterIDTemID(AEpisodeID As %String, ATemplateID As %String, strTitleCode As %String = "", ByRef reslut As %List, AState As %String = "") As %String
{
	s emrTemRowID = ""
	for {
		s emrTemRowID = $o(^DHCEMRM.EMRTemplateI("IdxBindTemplateID"," "_ATemplateID,emrTemRowID))
		q:(emrTemRowID = "")
		s objEMRTem = ##Class(EMRmeta.EMRTemplate).%OpenId(emrTemRowID)
		continue:(objEMRTem="")
		s strChartItemID = objEMRTem.CategoryID
		s strECRowID = ""
		s strECRowID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID,strChartItemID,strECRowID))
		continue:(strECRowID = "")
		s objECRecord = ##Class(EMRinstance.ECRecord).%OpenId(strECRowID)
		s strInstancID = ""
		S key = ""
		s key = objECRecord.Instances.Count()+1		
		do
		{ 			
	    	s objInstanceData = objECRecord.Instances.GetPrevious(.key)
		    if (objInstanceData '= "")
	     	{ 
		     	 continue:((objInstanceData.Status="UnSave")||(objInstanceData.Status="Delete")||(ATemplateID'=objInstanceData.RealTemplateID))
		     	 if (strTitleCode ="")
		     	 {
			     	  s strInstancID = objInstanceData.%Id()
		     	 }
		     	 else
		     	 {
			     	 if (objInstanceData.TitleCode =strTitleCode)
			     	 {
			     	 	s strInstancID = objInstanceData.%Id()
			     	 }
		     	 }
				 s resState="1"
				 //是否有有效签名，1：有效，0：无效
				 s:(AState="SIGN") resState = ##Class(EMRservice.BOPrivAssist).HasValidSign(strInstancID)
				 //判断是否打印
				 s:(AState="PRINT") resState = ##class(EMRservice.BL.BLEMRLogs).RecHasAction(objECRecord.RealEpisodeID,strInstancID,"Print")
				 continue:(resState=0)
		     	 //q:(strInstancID '="")
		     	 s:(strInstancID '="") reslut = reslut _ $lb(strInstancID)
		  	} 
 		 } 
 		 while (key '="")
	 	 /*
 		 if (strInstancID '="")
 		 {
	 		s reslut = $lb(strInstancID)_reslut
 		 }
 		 */
	 }
	q reslut
}

ClassMethod GetTitleBYGlossaryIntaID(AGlossaryCategoryID As %String) As %String
{
	q:(AGlossaryCategoryID="") ""
	s InterCodeValues = ##class(EMRservice.BOSysOption).GetValueByName("InternalIDTitleCode")
	q:(InterCodeValues="") ""
	s strTitleCode = ""
	if (InterCodeValues [ AGlossaryCategoryID)
	{
		s intCount = $l(InterCodeValues,"|")
		for i=1:1:intCount
		{
			s strValue = $p(InterCodeValues,"|",i)
			s strInterID = $p(strValue,"^",1)
			if (strInterID = AGlossaryCategoryID)
			{
				s strTitleCode = $p(strValue,"^",2)
				q
			}
		}
	}
	q strTitleCode
}

/// //////////
/// Debug:	w ##Class(EMRservice.BL.BLScatterData).GetInstanceIDsByTInterID("35","73")
ClassMethod GetInstanceIDsByTInterID(AEpisodeID, ATemplateCategoryID, ACategoryInternalID As %String) As %List
{
	s result = ""
	s ATemplateID = ""
	s strTitleCode = ..GetTitleBYGlossaryIntaID(ACategoryInternalID)
	for {
		s ATemplateID = $o(^DHCEMRM.TemplateI("IndexCategoryId"," "_ATemplateCategoryID,ATemplateID))
		q:(ATemplateID="")
		s emrTemRowID = ""
		for {
			s emrTemRowID = $o(^DHCEMRM.EMRTemplateI("IdxBindTemplateID"," "_ATemplateID,emrTemRowID))
			q:(emrTemRowID = "")
			s objEMRTem = ##Class(EMRmeta.EMRTemplate).%OpenId(emrTemRowID)
			continue:(objEMRTem="")
			s strChartItemID = objEMRTem.CategoryID
			s strECRowID = ""
			s strECRowID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID,strChartItemID,strECRowID))
			continue:(strECRowID = "")
			s objECRecord = ##Class(EMRinstance.ECRecord).%OpenId(strECRowID)
			s strInstancID = ""
			S key = ""
			s key = objECRecord.Instances.Count()+1		
			do
			{ 			
		    	s objInstanceData = objECRecord.Instances.GetPrevious(.key)
			    if (objInstanceData '= "")
		     	{ 
			     	 continue:((objInstanceData.Status="UnSave")||(objInstanceData.Status="Delete")||(ATemplateID'=objInstanceData.RealTemplateID))
			     	 if (strTitleCode ="")
			     	 {
				     	  s strInstancID = objInstanceData.%Id()
			     	 }
			     	 else
			     	 {
				     	 if (objInstanceData.TitleCode =strTitleCode)
				     	 {
				     	 	s strInstancID = objInstanceData.%Id()
				     	 }
			     	 }
			     	 s:(strInstancID '="") result = $lb(strInstancID)_result
			  	} 
	 		 } 
	 		 while (key '="")
		 }
	}
	q result
}

/// Desc:	获取指定术语集范畴下的所有标准术语值 仅仅支持第三版
/// Input：	AEpisodeID : 就诊指针
/// 		ACategoryInternalID : 指定术语集范畴内部标识符
/// Output:	术语值二维数组
/// Debug:	w ##Class(EMRservice.BL.BLScatterData).GetAllStdDataByGlossaryCategory("69","HDSD00.06")
ClassMethod GetAllStdDataByGlossaryCategory(AEpisodeID, ACategoryInternalID, templateCategoryID As %String) As %ArrayOfDataTypes
{
	s retArray = ##Class(%ArrayOfDataTypes).%New()
	q:($d(AEpisodeID) = 0)||(AEpisodeID = "") ret
	q:($d(ACategoryInternalID) = 0)||(ACategoryInternalID = "") ret
	q:($d(templateCategoryID) = 0)||(templateCategoryID = "") ret
	
	s glossaryCategoryID = $O(^DHCEPRM.GlossaryCategoryI("IdxOnInternalID"," "_ACategoryInternalID,""))
	q:(glossaryCategoryID="") ret
	/*//通过术语集目录获取关联的模板ID
	s objGlossaryCategory =  ##Class(EPRmeta.GlossaryCategory).%OpenId(glossaryCategoryID)
	w "glossaryCategoryID:"_glossaryCategoryID,!
	q:(objGlossaryCategory="") ret
	s templateCategoryID = objGlossaryCategory.TemplateCategroyID
	w "templateCategoryID:"_templateCategoryID,!
	q:(templateCategoryID="") ret*/
	//获取InstanceID集合
	s InstanceIDS = ..GetInstanceIDsByTInterID(AEpisodeID,templateCategoryID,ACategoryInternalID)
	s intInsCount = $ll(InstanceIDS)
	q:(intInsCount = 0) retArray
	for i = 1:1:intInsCount
	{
		s AInstanceID = $lg(InstanceIDS,i)
		continue:(AInstanceID="")
		s ret = ##Class(%ArrayOfDataTypes).%New()
		
		s templateID = ""
		s glossaryID = ""
		for {
			s glossaryID = $O(^DHCEPRM.GlossaryI("IdxCategoryID"," "_glossaryCategoryID,glossaryID))
			q:(glossaryID="")
			s objGlossary = ##Class(EPRmeta.Glossary).%OpenId(glossaryID)
			continue:(objGlossary="")
			s strDataValues = ""
			
			//通过注册号，术语rowId获取业务数据
			s strDataValues =..GetNewScatterDataByGlossaryID(AEpisodeID,glossaryID,AInstanceID)
			;continue:(strDataValues = "")
		 	s strDataValue=strDataValues
	 	
			s deName = objGlossary.Name
			s deName = $p(deName," ",2)
			s strInternalID = objGlossary.InternalID
			//关联标准数据元标识符
			S strMetaID = objGlossary.MetaID
			s strDescription = objGlossary.Description
			
			//如果没有关联数据元标示符，直接返回业务值
			if ((strMetaID = "") || (strMetaID=$char(0)))
			{
				//if (""'=strDataValues) w strInternalID _"^"_deName_"^"_strDataValues,!
				d ret.SetAt(strDataValue, strInternalID)
				continue
			}
			//通过数据元标识符取数据元
			s derowID = ""
			s derowID = $o(^DHCEPRM.DataElementI("IdxEntifier"," "_strMetaID,derowID))
			if (derowID = "")
			{
				s derowID = ##Class(EPRmeta.DataElement).SelectByEntifier(strMetaID)
			}
			s strDataType =""
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
			}
			if (MaprowID '= "")
			{	
				d ret.SetAt(strDataValue, strInternalID)
				continue
			}
			//判断数据类型
			if ((strDataType'="")&(strDataValue'=""))
			{
				s strDataValue =##class(EPRservice.BOScatterData).GetDataByType(strDataValue,strDataType)
			}

			//判断数据元数据格式
			if ((strFormat'="")&(strDataValue'=""))
			{
				if (sysCode'=""){
				s sysCode = ##class(EPRservice.BOScatterData).GetDataByFormat(sysCode,strFormat,"1")
				}
				else
				{
					s strDataValue = ##class(EPRservice.BOScatterData).GetDataByFormat(strDataValue,strFormat,"1")
				}
			}
	
			//处理日期数据类型
			/*
			if ((strValueType'="")&(itemCode'="")&(strDataValue'=""))
			{
				if ($e(itemCode,1,1)="D")
				{
					s:(strValueType="C") sysCode= $zdt($zdth(strDataValue,3,1),3,1)
					s:(strValueType="YMD") sysCode= $zd($zdh(strDataValue,3),3)
				}
			}
			*/
			if ((sysCode = "")&(strDataValue'="")&(strValueType = "C"))
			{
				s sysCode = strDataValue
				s strDataValue = " "
			}
			//处理按ValueType返回结果
			s strDataValues = $s(strValueType="V":strDataValue,strValueType="":strDataValue,strValueType="T":strDataValue,strValueType="C":sysCode,strValueType="YMD":sysCode,1:"")
			
			//if (""'=strDataValues) w strInternalID _"^"_deName_"^"_strDataValues,!
			d ret.SetAt(strDataValues, strInternalID)
		}
		d retArray.SetAt(ret, i)
	}
	
	q retArray
}

/// 门诊用
ClassMethod setScatterDataInArr(AEpisodeID, glossaryCategoryID, AInstanceID As %String, ret As %ArrayOfDataTypes)
{
    s templateID = ""
    s glossaryID = ""
    for {
        s glossaryID = $O(^DHCEPRM.GlossaryI("IdxCategoryID"," "_glossaryCategoryID,glossaryID))
        q:(glossaryID="")
        s objGlossary = ##Class(EPRmeta.Glossary).%OpenId(glossaryID)
        continue:(objGlossary="")
        s strDataValues = ""

        //通过注册号，术语rowId获取业务数据
        s strDataValues =..GetNewScatterDataByGlossaryIDOP(AEpisodeID,glossaryID,AInstanceID)

        //continue:(strDataValues = "")
         s strDataValue=strDataValues
         //w glossaryID_","_AInstanceID_","_strDataValues,!
        s deName = objGlossary.Name
        s deName = $p(deName," ",2)
        s strInternalID = objGlossary.InternalID
        //关联标准数据元标识符
        S strMetaID = objGlossary.MetaID
        s strDescription = objGlossary.Description

        //如果没有关联数据元标示符，直接返回业务值
        if ((strMetaID = "") || (strMetaID=$char(0)))
        {
            //if (""'=strDataValues) w "1:"_strInternalID _"^"_deName_"^"_strDataValues_"^"_glossaryID,!
            d ret.SetAt(strDataValue, strInternalID)
            continue
        }
        //通过数据元标识符取数据元
        s derowID = ""
        s derowID = $o(^DHCEPRM.DataElementI("IdxEntifier"," "_strMetaID,derowID))
        if (derowID = "")
        {
            s derowID = ##Class(EPRmeta.DataElement).SelectByEntifier(strMetaID)
        }
        s strDataType =""
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
        }
        if (MaprowID '= "")
        {   
            //w "2:"_strInternalID_"^"_"^"_strDataValues,!
            d ret.SetAt(strDataValue, strInternalID)
            continue
        }
        //判断数据类型
        if ((strDataType'="")&(strDataValue'=""))
        {
            s strDataValue =##class(EPRservice.BOScatterData).GetDataByType(strDataValue,strDataType)
        }

        //判断数据元数据格式
        if ((strFormat'="")&(strDataValue'=""))
        {
            if (sysCode'=""){
            s sysCode = ##class(EPRservice.BOScatterData).GetDataByFormat(sysCode,strFormat,"1")
            }
            else
            {
                s strDataValue = ##class(EPRservice.BOScatterData).GetDataByFormat(strDataValue,strFormat,"1")
            }
        }

        //处理日期数据类型
        /*
        if ((strValueType'="")&(itemCode'="")&(strDataValue'=""))
        {
            if ($e(itemCode,1,1)="D")
            {
                s:(strValueType="C") sysCode= $zdt($zdth(strDataValue,3,1),3,1)
                s:(strValueType="YMD") sysCode= $zd($zdh(strDataValue,3),3)
            }
        }
        */
        if ((sysCode = "")&(strDataValue'="")&(strValueType = "C"))
        {
            s sysCode = strDataValue
            s strDataValue = " "
        }
        //处理按ValueType返回结果
        s strDataValues = $s(strValueType="V":strDataValue,strValueType="":strDataValue,strValueType="T":strDataValue,strValueType="C":sysCode,strValueType="YMD":sysCode,1:"")

        d ret.SetAt(strDataValues, strInternalID)

    }
}

/// 门诊用     将实例直接存进reslut中
ClassMethod GetInstanceIDByTInterIDOP(AEpisodeID As %String, ATemplateCategoryIDs As %String, ACategoryInternalID As %String = "") As %List
{
	s reslut = ""
	s ATemplateID = ""
	s strTitleCode = ..GetTitleBYGlossaryIntaID(ACategoryInternalID)
	for {
		s ATemplateID = $o(^DHCEMRM.TemplateI("IndexCategoryId"," "_ATemplateCategoryIDs,ATemplateID))
		q:(ATemplateID="")
		s emrTemRowID = ""
		for {
			s emrTemRowID = $o(^DHCEMRM.EMRTemplateI("IdxBindTemplateID"," "_ATemplateID,emrTemRowID))
			q:(emrTemRowID = "")
			s objEMRTem = ##Class(EMRmeta.EMRTemplate).%OpenId(emrTemRowID)
			continue:(objEMRTem="")
			s strChartItemID = objEMRTem.CategoryID
			s strECRowID = ""
			s strECRowID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID,strChartItemID,strECRowID))
			continue:(strECRowID = "")
			s objECRecord = ##Class(EMRinstance.ECRecord).%OpenId(strECRowID)
			s strInstancID = ""
			S key = ""
			//s key = objECRecord.Instances.Count()+1		
			do
			{ 			
		    	s objInstanceData = objECRecord.Instances.GetPrevious(.key)
			    if (objInstanceData '= "")
		     	{ 
			     	 continue:((objInstanceData.Status="UnSave")||(objInstanceData.Status="Delete"))
			     	 if (strTitleCode ="")
			     	 {
				     	  s strInstancID = objInstanceData.%Id()
			     	 }
			     	 else
			     	 {
				     	 if (objInstanceData.TitleCode =strTitleCode)
				     	 {
				     	 	s strInstancID = objInstanceData.%Id()
				     	 }
			     	 }
			     	 //q:(strInstancID '="")
			     	 s:(strInstancID '="") reslut = reslut _ $lb(strInstancID)
			  	} 
	 		 } 
	 		 while (key '="")
	 		 
	 		 /*if (strInstancID '="")
	 		 {
		 		 s reslut = reslut _ $lb(strInstancID)
	 		 }*/
		 }
	}
	q reslut
}

/// 门诊用，屏蔽下面内容
/// 			if (templateID '= tempID)
/// 			{
/// 			    s strInstanceID = ..GetInstanceByEpisodeTemID(AEpisodeID,templateID)
/// 			}
ClassMethod GetNewScatterDataByGlossaryIDOP(AEpisodeID As %String, AGlossaryID As %String, AInstanceID As %String, Output aRowID As %String = "") As %String
{
	s ret = ""
	q:($d(AEpisodeID) = 0)||(AEpisodeID = "") ret
	q:($d(AGlossaryID) = 0)||(AGlossaryID = "") ret
	q:($d(AInstanceID) = 0)||(AInstanceID = "") ret
	s objGlossary = ##Class(EPRmeta.Glossary).%OpenId(AGlossaryID)
	q:(objGlossary = "") ret
	//b
	s name = objGlossary.Name
	s type = objGlossary.GlossaryType
	s strInstanceID = AInstanceID
	if ($zcvt(type,"U") = "TG")
	{
		s rowID = ""
		for {
			s rowID = $o(^DHCEPRM.GlossaryItemI("IdxGlossaryID",AGlossaryID,rowID))
			q:(rowID = "")
			
			s objItem = ##Class(EPRmeta.GlossaryItem).%OpenId(rowID)
			s aRowID =rowID
			s itemCodes = objItem.ItemCode
			s valueType = objItem.ValueType
			s templateID = objItem.TemplateID
			s strInstanceID = AInstanceID
			s objIn = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
			s tempID = objIn.RealTemplateID
			s strTemType = objItem.TemType
			if (($zcvt(strTemType,"U") ="NEW")||($zcvt(strTemType,"U") ="BASE"))
			{
				s itemCode	= ""
				s elementType = ""
				q:('itemCodes [ "#")
				s ItemList = ##Class(EMRservice.Tools.Tool).GetListFromString(itemCodes,"#")
				q:($ll(ItemList) '= 2)
				s elementType = $zcvt($p($lg(ItemList,1),":",2),"U")
				s itemCode = $lg(ItemList,2)
				s ret = ""
				s ret = ..GetTGScatterData(AEpisodeID,templateID,strInstanceID,itemCode,valueType,elementType)
			}
			
			q:(ret '= "")&&(ret '= "Null")
		}	
	}
	else
	{
		s kbRowID = ""
		for {
			s kbRowID = $o(^DHCEPRM.GlossaryKBItemI("IdxGlossaryID",AGlossaryID,kbRowID))
			q:(kbRowID = "")
			s aRowID =kbRowID
			s objParItem = ##Class(EPRmeta.GlossaryKBItem).%OpenId(kbRowID)
			s curItemCodes = objParItem.ItemCode
			s curValueType = objParItem.ValueType
			s kbPartNo = objParItem.KBPartNo
			S KBNodeID = objParItem.KBNodeID
			
			s strKBType = objParItem.KBType
			if ($zcvt(strKBType,"U") ="NEW")
			{
				s itemCode	= ""
				s elementType = ""
				q:('curItemCodes [ "#")
				s ItemList = ##Class(EMRservice.Tools.Tool).GetListFromString(curItemCodes,"#")
				q:($ll(ItemList) '= 2)
				s elementType = $zcvt($p($lg(ItemList,1),":",2),"U")
				s itemCode = $lg(ItemList,2)
				//去掉"SCODE:"+前面的一个特殊符号
				s itemCode = $e(itemCode,7,$l(itemCode))
				s ret = ""
				s ret = ..GetKBScatterData(AEpisodeID,AInstanceID,itemCode,curValueType,elementType)
			}
		}	
	}
	s:(ret="Null") ret = ""
	q ret
}

/// Desc:	获取InstanceID集合通过AEpisodeID和TemplateID
/// Input：	AEpisodeID : 就诊指针
/// 		ACategoryInternalID : 指定术语集范畴内部标识符
/// Output:	获取instanceID，重复模板获取最新的保存状态的instanceID。
/// Debug:	w ##Class(EMRservice.BL.BLScatterData).GetInstanceIDSByTemID("35","73")
ClassMethod GetInstanceBTInterIDTemCateID(AEpisodeID As %String, ATemplateCategoryID As %String, strTitleCode As %String = "", ByRef reslut As %List) As %String
{
	s strECRowID = ""
	for {

		s strECRowID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDCategoryID",AEpisodeID,ATemplateCategoryID,strECRowID))
		q:(strECRowID = "")
		s objECRecord = ##Class(EMRinstance.ECRecord).%OpenId(strECRowID)
		s strInstancID = ""
		S key = ""
		s key = objECRecord.Instances.Count()+1		
		do
		{ 			
	    	s objInstanceData = objECRecord.Instances.GetPrevious(.key)
		    if (objInstanceData '= "")
	     	{ 
		     	 continue:((objInstanceData.Status="UnSave")||(objInstanceData.Status="Delete"))
		     	 if (strTitleCode ="")
		     	 {
			     	  s strInstancID = objInstanceData.%Id()
		     	 }
		     	 else
		     	 {
			     	 if (objInstanceData.TitleCode =strTitleCode)
			     	 {
			     	 	s strInstancID = objInstanceData.%Id()
			     	 }
		     	 }
		     	 q:(strInstancID '="")
		     	 //s:(strInstancID '="") reslut = reslut _ $lb(strInstancID)
		  	} 
 		 } 
 		 while (key '="")
	 
 		 if (strInstancID '="")
 		 {
	 		s reslut = $lb(strInstancID)_reslut
 		 }
	 }
	q reslut
}

/// Desc:	获取InstanceID集合通过AEpisodeID和TemplateID
/// Input：	AEpisodeID : 就诊指针
/// 		ACategoryInternalID : 指定术语集范畴内部标识符
/// Output:	术语值数组
/// Debug:	w ##Class(EMRservice.BL.BLScatterData).GetInstanceIDSByTemID("20186533","49")
ClassMethod GetInstanceIDSByTemID(AEpisodeID As %String, ATemplateCategoryID As %String) As %List
{
	s reslut = ""
	s ATemplateID = ""
	for {
		s ATemplateID = $o(^DHCEMRM.TemplateI("IndexCategoryId"," "_ATemplateCategoryID,ATemplateID))
		q:(ATemplateID="")
		s emrTemRowID = ""
		for {
			s emrTemRowID = $o(^DHCEMRM.EMRTemplateI("IdxBindTemplateID"," "_ATemplateID,emrTemRowID))
			q:(emrTemRowID = "")
			s objEMRTem = ##Class(EMRmeta.EMRTemplate).%OpenId(emrTemRowID)
			continue:(objEMRTem="")
			s strChartItemID = objEMRTem.CategoryID
			s strECRowID = ""
			s strECRowID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID,strChartItemID,strECRowID))
			continue:(strECRowID = "")
			s objECRecord = ##Class(EMRinstance.ECRecord).%OpenId(strECRowID)

			Set key = ""
			do
			{ 
		    	S objInstanceData = objECRecord.Instances.GetNext(.key)
			    if (objInstanceData '= "")
		     	{ 
		     	  continue:((objInstanceData.Status="UnSave")||(objInstanceData.Status="Delete"))
			     s reslut = reslut_$lb(objInstanceData.%Id())
			  	} 
	 		 } 
	 		 while (key '="" )
		 }
	}
	q reslut
}

/// Desc:	获取InstanceID集合通过AEpisodeID和TemplateID
/// Input：	AEpisodeID : 就诊指针
/// 		ACategoryInternalID : 指定术语集范畴内部标识符
/// Output:	术语值数组
/// Debug:	w ##Class(EMRservice.BL.BLScatterData).GetInstanceIDSByTemIDStr("8702063","51^49")
ClassMethod GetInstanceIDSByTemIDStr(AEpisodeID As %String, ATemplateCategoryIDs As %String) As %List
{
	s reslut = "",ret=""
	s ATemplateID = ""
	for i=1:1:$length(ATemplateCategoryIDs,"^"){
		
		s tmpTemplateCategoryID=$p(ATemplateCategoryIDs,"^",i)
		
		for {
			s ATemplateID = $o(^DHCEMRM.TemplateI("IndexCategoryId"," "_tmpTemplateCategoryID,ATemplateID))
			q:(ATemplateID="")
			s emrTemRowID = ""
			for {
				s emrTemRowID = $o(^DHCEMRM.EMRTemplateI("IdxBindTemplateID"," "_ATemplateID,emrTemRowID))
				q:(emrTemRowID = "")
				s objEMRTem = ##Class(EMRmeta.EMRTemplate).%OpenId(emrTemRowID)
				continue:(objEMRTem="")
				s strChartItemID = objEMRTem.CategoryID
				s strECRowID = ""
				s strECRowID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID,strChartItemID,strECRowID))
				continue:(strECRowID = "")
				s objECRecord = ##Class(EMRinstance.ECRecord).%OpenId(strECRowID)

				Set key = ""
				do
				{ 
			    	S objInstanceData = objECRecord.Instances.GetNext(.key)
				    if (objInstanceData '= "")
			     	{ 
			     	 continue:(objInstanceData.Status="UnSave")
			     	 // mod leefb add medical status
			     	 continue:(objInstanceData.Status="Delete")
				     s reslut = objInstanceData.%Id()
				  	} 
		 		 } 
		 		 while (key '="" )
			 }
		}
		if ret="" { 
			s ret=$lb(reslut) 
			continue 
		}
		
		s ret=ret_$lb(reslut)
		
	}
	q ret
}

/// Desc:       获取指定术语值
/// Creator:    LiXJ
/// CreateDate: 2016-06-12
/// Input：AEpisodeID : 就诊指针
///             AGlossaryInternalID : 指定术语内部标识符
///             Flag:取值结果设定
///             Flag=1，输出格式为：模板id.标题#数据源值
///             Flag=0，输出格式为：单元值
/// Output:     术语值
/// Debug:      w ##Class(EMRservice.BL.BLScatterData).GetDataByGlossaryNew("110852","HDSD00.13.114","0")
ClassMethod GetDataByGlossaryNew(AEpisodeID As %String, AGlossaryInternalID As %String = "", Flag As %String = "") As %String
{
    s:(Flag="") Flag=0
    q:(AEpisodeID="")||(AGlossaryInternalID="") ""
    s parentID = "",value="",valuestring=""
    for
    {
        s parentID = $O(^DHCEPRM.GlossaryI("IdxInternalID"," "_AGlossaryInternalID,parentID))
        Q:parentID=""
        s glossaryID = $O(^DHCEPRM.GlossaryI("IdxInternalID"," "_AGlossaryInternalID,parentID,""))
        q:(glossaryID="")
        s rowID = ""
        for
        {
            s rowID = $o(^DHCEPRM.GlossaryItemI("IdxGlossaryID",glossaryID,rowID))
            q:(rowID = "")
            s objItem = ##Class(EPRmeta.GlossaryItem).%OpenId(rowID)
            s AitemCode = objItem.ItemCode
            s valueType = objItem.ValueType
            s templateID = objItem.TemplateID
            s itemCodeEYPE = $P($p(AitemCode,"#",2),":",2)
            s InstanceID=""
            IF itemCodeEYPE = "ICOMPOSITESAMPLE"
            {
                s itemCode = "TYPE:ICompositeSample#TID:"_templateID_"#"_$p(AitemCode,"#",3)_"#VTYPE:"_valueType
            }
            ELSEIF itemCodeEYPE = "ISECTIONDESC"
            {
                s itemCode = "TYPE:ISectionDesc#TID:"_templateID_"#"_$p(AitemCode,"#",3)_"#VTYPE:"_valueType
            }    
            ELSEIF itemCodeEYPE = "ICOMPOSITEDESC"
            {
                 s itemCode = "TYPE:ICompositeDesc#TID:"_templateID_"#"_$p(AitemCode,"#",3)_"#VTYPE:"_valueType
            }
            s value = ..GetScatterDataSNew(AEpisodeID,itemCode,InstanceID,Flag)
            continue:(value="")
            s valuestring=valuestring_value
        }
    }
    s valuestring = $TR(valuestring,"^","/")
    q $e(valuestring,1,$l(valuestring)-1)
}

/// Desc:       取打散数据
/// Creator:    LiXJ
/// CreateDate: 2016-06-12
/// Input:      AEpisodeID 就诊号
///             AItem 单元路径(TYPE:ICompositeSample#TID:81#SCODE:S001#VTYPE:S|CCODE:VK1#VTYPE:S|CSCODE:L010#VTYPE:V
///             AInstanceID 实例数据ID
///             Flag:取值结果设定
///             Flag=1，输出格式为：模板id.标题#数据源值
///             Flag=0，输出格式为：单元值
/// Return:     result 实例数据单元值
ClassMethod GetScatterDataSNew(AEpisodeID As %String, AItem As %String, AInstanceID As %String, Flag As %String = 0) As %String
{
    s $ZT="ERROR"    
    s result = "",ret=""
    q:(AEpisodeID = "") result
    s ItemList = ##Class(EMRservice.Tools.Tool).GetListFromString(AItem,"#")
    q:($ll(ItemList) '= 4) result
    s elementType = $p($lg(ItemList,1),":",2)
    s templateId = $p($lg(ItemList,2),":",2)
    s itemCode = $lg(ItemList,3)
    s valueType = $p($lg(ItemList,4),":",2)
    //W elementType
    if (elementType = "ISectionDesc")
    {    
        //w templateId_"**"_itemCode
        s rowIdS = ..GetSectionIDS(AEpisodeID,templateId,itemCode,AInstanceID)
        q:(rowIdS="") result
        S Lenth=$l(rowIdS,"||")
        for i=1:1:(Lenth-1)
        {
            s rowId=$p($p(rowIdS,"||",i),"*",2)
            s Title=$p($p(rowIdS,"||",i),"*",1)
            s valueType = "T"
            //w rowId_"&"
            s result = ..GetSectionData(rowId,valueType)
            //continue:(result="")
            s:(Flag=0) ret=ret_result_"^"
            s:(Flag=1) ret=ret_templateId_"#"_Title_"#"_result_"^"
        }
    }
    elseif(elementType = "ICompositeDesc")
    {
        s rowIdS = ..GetCompositeIDS(AEpisodeID,templateId,itemCode,AInstanceID)
        q:(rowIdS="") result
        S Lenth=$l(rowIdS,"||")
        for i=1:1:(Lenth-1)
        {
            s rowId=$p($p(rowIdS,"||",i),"*",2)
            s Title=$p($p(rowIdS,"||",i),"*",1)
            s result = ..GetCompositeData(rowId,valueType)
            //continue:(result="")
            s:(Flag=0) ret=ret_result_"^"
            s:(Flag=1) ret=ret_templateId_"#"_Title_"#"_result_"^"
        }    
    }
    elseif(elementType = "ICompositeSample")
    {
        s rowIdS = ..GetCompositeSimpleIDS(AEpisodeID,templateId,itemCode,AInstanceID)
        q:(rowIdS="") result
        S Lenth=$l(rowIdS,"||")
        for i=1:1:(Lenth-1)
        {
            s rowId=$p($p(rowIdS,"||",i),"*",2)
            s Title=$p($p(rowIdS,"||",i),"*",1)
            s result = ..GetCompositeSimpleData(rowId,valueType)
            //continue:(result="")
            s:(Flag=0) ret=ret_result_"^"
            s:(Flag=1) ret=ret_templateId_"#"_Title_"#"_result_"^"
        }    
    }
    q ret
ERROR
    q "ERROR"
}

/// Desc:       返回GetSectionDesc的rowID
/// Creator:    LiXJ
/// CreateDate: 2016-06-12
/// Input:      AEpisodeID 就诊号
///             ATemplateID 模板ID
///             ACode 单元代码(路径)
///             AInstanceID 就诊号
/// Return:     EMRinstance.ISectionDesc 的 rowID
/// Debug:      w ##Class(EMRservice.BL.BLScatterData).GetSectionIDS(110852,1413,"SCODE:S001","")
ClassMethod GetSectionIDS(AEpisodeID As %String, ATemplateID As %String, ACode As %String, AInstanceID As %String) As %String
{
    s result = ""
    q:((AEpisodeID = "")||(ATemplateID = "")||(ACode = "")) result
    s sCode = $p(ACode,":",2)
    s SCode = $zcvt(sCode,"U")
    s instanceId = "",ret = ""
    if (AInstanceID = "")
    {
        for
        {
            //w AEpisodeID_"**"_ATemplateID_"**"_SCode
            s instanceId = $o(^DHCEMRI.ISectionDescI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_SCode,instanceId))
            q:(instanceId = "")
            s tmpInstanceId = $tr(instanceId," ","")
            s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(tmpInstanceId)
            CONTINUE:(objInstance.Status'="Save")
            s Title=objInstance.Title
            s result = $o(^DHCEMRI.ISectionDescI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_SCode,instanceId,""))
            s ret=ret_Title_"*"_result_"||"
        }
    }
    else
    {
        s instanceId = " "_AInstanceID
        s result = $o(^DHCEMRI.ISectionDescI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_SCode,instanceId,""))
        s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(tmpInstanceId)
        s Title=objInstance.Title
        s ret=Title_"*"_result
    }
    q ret
}

/// Desc:       返回GetSectionDesc的rowID
/// Creator:    LiXJ
/// CreateDate: 2016-06-12
/// Input:      AEpisodeID 就诊号
///             ATemplateID 模板ID
///             ACode 单元代码(路径)
///             AInstanceID 就诊号
/// Return:     EMRinstance.ICompositeDesc 的 rowID
/// Debug:      w ##Class(EMRservice.BL.BLScatterData).GetCompositeIDS(76,2,"SCode:S001|CCode:29","")
ClassMethod GetCompositeIDS(AEpisodeID As %String, ATemplateID As %String, ACode As %String, AInstanceID As %String) As %String
{
    s result = ""
    q:((AEpisodeID = "")||(ATemplateID = "")||(ACode = "")) result
    s sCode = $p($p(ACode,"|",1),":",2)
    s cCode = $p($p(ACode,"|",2),":",2)
    s sCode = $zcvt(sCode,"U")
    s cCode = $zcvt(cCode,"U")
    s instanceId = "",ret=""
    if (AInstanceID = "")
    {
        for
        {
            s instanceId = $o(^DHCEMRI.ICompositeDescI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_sCode," "_cCode,instanceId))
            q:(instanceId = "")
            s tmpInstanceId = $tr(instanceId," ","")
            s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(tmpInstanceId)
            CONTINUE:(objInstance.Status'="Save")
            s Title=objInstance.Title
            s result = $o(^DHCEMRI.ICompositeDescI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_sCode," "_cCode,instanceId))
            s ret=ret_Title_"*"_result_"||"
        }    
    }
    else
    {
        s instanceId = " "_AInstanceID
        s result = $o(^DHCEMRI.ICompositeDescI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_sCode," "_cCode,instanceId,""))
        s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(tmpInstanceId)
        s Title=objInstance.Title
        s ret=Title_"*"_result
    }
    q ret
}

/// Desc:       返回CompositeSimple的rowID
/// Creator:    LiXJ
/// CreateDate: 2016-06-12
/// Input:      AEpisodeID 就诊号
///             ATemplateID 模板ID
///             ACode 单元代码(路径)
///             AInstanceID 就诊号
/// Return:     EMRinstance.ICompositeSimple 的 rowID
ClassMethod GetCompositeSimpleIDS(AEpisodeID As %String, ATemplateID As %String, ACode As %String, AInstanceID As %String) As %String
{
    s result = ""
    q:((AEpisodeID = "")||(ACode = "")||(ATemplateID = "")) result
    s sCode = $p($p(ACode,"|",1),":",2)
    s cCode = $p($p(ACode,"|",2),":",2)
    s csCode = $p($p(ACode,"|",3),":",2)
    s sCode = $zcvt(sCode,"U")
    s cCode = $zcvt(cCode,"U")
    s csCode = $zcvt(csCode,"U")
    s instanceId = "",ret="",EcRecordId=""
    if (AInstanceID = "")
    {
        s instanceId = ""
        for
        {
            s instanceId = $o(^DHCEMRI.ICompositeSimpleI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_sCode," "_cCode," "_csCode,instanceId))
            q:(instanceId="")
            s tmpInstanceId = $tr(instanceId," ","")
            s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(tmpInstanceId)
            CONTINUE:(objInstance.Status'="Save")
            s Title=objInstance.Title
            s result = $o(^DHCEMRI.ICompositeSimpleI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_sCode," "_cCode," "_csCode,instanceId,""))
            s ret=ret_Title_"*"_result_"||"
        }
    }
    else
    {
        s instanceId = " "_AInstanceID
        s result = $o(^DHCEMRI.ICompositeSimpleI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_sCode," "_cCode," "_csCode,instanceId,""))
        s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(tmpInstanceId)
        s Title=objInstance.Title
        s ret=Title_"*"_result
    }
    q ret
}

}
