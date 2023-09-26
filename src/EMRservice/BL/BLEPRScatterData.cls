/// Desc:       二版打散接口
/// Creator:    Candy
/// CreateDate: 2016-3-31
Class EMRservice.BL.BLEPRScatterData Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:  根据原数据编码规则到不同的打散结构里去取数据
/// Creator: Candy
/// Input: AEpisodeID  就诊号
///        ATemplateID 模板ID;
///        AItemCode   单元code 
///           若为G单元或T单元的内嵌单元, 形式为 parentItemCode.subItemCode, 如 E0001.S0009
///           若为E单元的内嵌单元,形式可为parentItemCode.subItemCode 或者 parentItemCode.subItemCode.KBNodeId.KBPartNo
///           若为其他单元, 形式为 ItemCode,  如 S0009 或 E0099 或 G0087  等等
///        AValueType 取值类型,默认为 V
/// Output:对于TableSimpleItem，若有多行，返回 值以^分割				  
ClassMethod GetScatterDatas(AEpisodeID As %String, ATemplateID As %String, AItemCode As %String, AValueType As %String = "V") As %String
{
	s result = ##Class(%ArrayOfDataTypes).%New()
	q:(AEpisodeID = ""||ATemplateID = ""||AItemCode = ""||AValueType = "") result
	s AValueType = $case(AValueType,"":"V",:$zcvt(AValueType,"U")) 

	//若为G单元、T单元的内嵌单元
	if (AItemCode [ ".") 
	{
		s parentCode = $p(AItemCode,".",1)
		s subItemCode = $e(AItemCode,$f(AItemCode,"."),$l(AItemCode))
		s subItemType = $e(subItemCode,0,1)
		if ($e(parentCode,0,1) = "G")
		{
			s instanceId = ""
			for
			{
				s instanceId = $O(^DHCEPRI.ISegmentSimpleI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_parentCode," "_subItemCode,instanceId))
				q:(instanceId = "")
				s tmpInstanceId = $tr(instanceId," ","")
				s objInstance = ##Class(EPRinstance.InstanceData).%OpenId(tmpInstanceId)
				continue:(objInstance = "")
				continue:($zcvt(objInstance.Status,"U") '= "SAVE")
				s rowId = $O(^DHCEPRI.ISegmentSimpleI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_parentCode," "_subItemCode,instanceId,""))
				s value = ##Class(EPRservice.BOScatterData).GetISegmentSimpleValue(rowId,subItemType,AValueType)
				d result.SetAt(value,tmpInstanceId)
			}			
		}
		elseif ($e(ParentCode,0,1) = "T")
		{
			s instanceId = ""
			for
			{
				s instanceId = $o(^DHCEPRI.ITableSimpleI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_parentCode," "_subItemCode,instanceId))
				q:(instanceId = "")
				s value = ""
				s tmpInstanceId = $tr(instanceId," ","")
				s objInstance = ##Class(EPRinstance.InstanceData).%OpenId(tmpInstanceId)
				continue:(objInstance = "")
				continue:($zcvt(objInstance.Status,"U") '= "SAVE")	
				s rowNum = ""
				for
				{
					s rowNum = $o(^DHCEPRI.ITableSimpleI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_parentCode," "_subItemCode,instanceId,rowNum))
					q:(rowNum = "")
					s rowId = $o(^DHCEPRI.ITableSimpleI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_parentCode," "_subItemCode,instanceId,rowNum,""))
					s tmpvalue = ##Class(EPRservice.BOScatterData).GetITableSimpleValue(rowId,subItemType,AValueType)
					s value = value_$C(2)_tmpvalue
				}
				d result.SetAt(value,tmpInstanceId)
			}
		}
	}
	else   	//若为非内嵌单元 
	{
		s itemType = $e(AItemCode,0,1)
		if ($e(AItemCode,0,1) = "G")
		{
			s instanceId = ""
			for
			{
				s instanceId = $o(^DHCEPRI.ISegmentI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_AItemCode,instanceId))
				q:(instanceId = "")
				s tmpInstanceId = $tr(instanceId," ","")
				s objInstance = ##Class(EPRinstance.InstanceData).%OpenId(tmpInstanceId)
				continue:(objInstance = "")
				continue:($zcvt(objInstance.Status,"U") '= "SAVE")				
				s rowId = $o(^DHCEPRI.ISegmentI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_AItemCode,instanceId,""))
				s value = ##Class(EPRservice.BOScatterData).GetISegmentValue(rowId)
				d result.SetAt(value,tmpInstanceId)
			}
		}
		elseif ($e(AItemCode,0,1) = "E")
		{
			s instanceId = ""
			for
			{
				s instanceId = $o(^DHCEPRI.ITextDescI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_AItemCode,instanceId))
				q:(instanceId = "")
				s tmpInstanceId = $tr(instanceId," ","")
				s objInstance = ##Class(EPRinstance.InstanceData).%OpenId(tmpInstanceId)
				continue:(objInstance = "")
				continue:($zcvt(objInstance.Status,"U") '= "SAVE")			
				s rowId = $o(^DHCEPRI.ITextDescI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_AItemCode,instanceId,""))
				s value = ##Class(EPRservice.BOScatterData).GetITextDescValue(rowId)
				d result.SetAt(value,tmpInstanceId)
			}
		}
		elseif ($e(AItemCode,0,1) = "Y")
		{	
			/// do nothing
		}
		else
		{
			s instanceId = ""
			for
			{
				s instanceId = $o(^DHCEPRI.ISimpleI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_AItemCode,instanceId))
				q:(instanceId = "")
				s tmpInstanceId = $tr(instanceId," ","")
				s objInstance = ##Class(EPRinstance.InstanceData).%OpenId(tmpInstanceId)
				continue:(objInstance = "")
				continue:($zcvt(objInstance.Status,"U") '= "SAVE")			
				s rowId = $o(^DHCEPRI.ISimpleI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_AItemCode,instanceId,""))
				s value = ##Class(EPRservice.BOScatterData).GetISimpleValue(rowId,itemType,AValueType)
				d result.SetAt(value,tmpInstanceId)				
			}	
		}
	}
	q result
}

/// Desc:        取知识库
/// Creator:     Candy
/// CreeateDate: 取知识库
/// Input:       AEpisodeID  就诊号
///             ATemplateID 模板ID
///             APItemCode  E单元代码
///             AItemCode   E单元内嵌单元代码
///             AKbNodeID   知识库ID
///             AKbPartNo   知识库第几部分
///             AValueType  值类型 
ClassMethod GetKBScatterDatas(AEpisodeID As %String, ATemplateID As %String, APItemCode As %String, AItemCode As %String, AKbNodeID As %String, AKbPartNo As %String, AValueType = "V") As %ArrayOfDataTypes
{
	s result = ##Class(%ArrayOfDataTypes).%New()
	q:(AEpisodeID = "")||(ATemplateID = "")||(APItemCode = "")||(AItemCode = "")||(AKbNodeID = "")||(AKbPartNo = "") result
	s instanceId = ""
	for
	{
		s instanceId = $o(^DHCEPRI.ITextDescI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_APItemCode,instanceId))
		q:(instanceId = "")
		s tmpInstanceId = $tr(instanceId," ","")
		s objInstance = ##Class(EPRinstance.InstanceData).%OpenId(tmpInstanceId)
		continue:(objInstance = "")
		continue:($zcvt(objInstance.Status,"U") '= "SAVE")		
		s rowId = $o(^DHCEPRI.ITextDescSimpleI("IdxForUpdate",instanceId," "_APItemCode," "_AKbNodeID," "_AKbPartNo," "_AItemCode,""))
		s value = ##Class(EPRservice.BOScatterData).GetITextDescSimpleValue(rowId,$p(AItemCode,".",1),AValueType)
		d result.SetAt(value,tmpInstanceId)			
	}
	q result
}

}
