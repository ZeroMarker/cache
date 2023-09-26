/// 名称：		EMRservice.BL.BLPrivRuleStore
/// 描述：		规则脚本仓库BL层
/// 编写者：	yejian
/// 编写时间：	2021-5-28
Class EMRservice.BL.BLPrivRuleStore Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       获取规则脚本仓库
/// Creator:    yejian
/// CreateDate: 2021-5-28
/// Input:      
/// OutPut:     返回数据 %XML.DataSet,
/// Debug:	d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLPrivRuleStore","GetPrivRuleStore")
Query GetPrivRuleStore() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,RuleDesc:%String,RuleCode:%String,Sequence:%String", SELECTMODE = "RUNTIME")
{
	SELECT p.ID,p.RuleDesc,p.RuleCode,p.Sequence
	FROM EMRmeta.PrivRuleStore p 
	ORDER BY p.Sequence
}

/// Desc:       添加规则脚本仓库
/// Creator:    yejian
/// CreateDate: 2021-5-28
/// Input:      aEPrivRuleStore 仓库对象
/// OutPut:     返回数据 成功 ID,失败 -1,
/// Debug: d ##class(EMRservice.BL.BLPrivRuleStore).AddPrivRuleItem(aEPrivRuleStore)
ClassMethod AddPrivRuleItem(aEPrivRuleStore As EMRservice.entity.EPrivRuleStore) As %String
{
	s $zt="error"
	s ret = "-1"
	s objPrivRuleItem = ##Class(EMRmeta.PrivRuleStore).%New()
	s objPrivRuleItem.RuleCode =aEPrivRuleStore.RuleCode
	s objPrivRuleItem.RuleDesc =aEPrivRuleStore.RuleDesc
	s objPrivRuleItem.Sequence = +($g(^DHCEMRM.PrivRuleStoreD))+1
	if (objPrivRuleItem.%Save())
	{
	    s ret=objPrivRuleItem.%Id()
	}
	else
	{
		q ret
	}
	d objPrivRuleItem.%Close()
	s ret = "1"
	q ret
error
	q "-1"
}

/// Desc:       修改规则脚本仓库
/// Creator:    yejian
/// CreateDate: 2021-5-28
/// Input:      aEPrivRuleStore 仓库对象
/// OutPut:     返回数据 成功 1,失败 -1,
/// Debug: d ##class(EMRservice.BL.BLPrivRuleStore).UpPrivRuleItem(aEPrivRuleStore)
ClassMethod UpPrivRuleItem(aEPrivRuleStore As EMRservice.entity.EPrivRuleStore) As %String
{
	s $zt="error"
	s ret = "-1"
	s objPrivRuleItem = ##Class(EMRmeta.PrivRuleStore).%OpenId(aEPrivRuleStore.ID)
	s objPrivRuleItem.RuleCode =aEPrivRuleStore.RuleCode
	s objPrivRuleItem.RuleDesc =aEPrivRuleStore.RuleDesc
	if ('objPrivRuleItem.%Save())
	{
	   q ret
	}		
	d objPrivRuleItem.%Close()
	s ret = "1"
	q ret
error
	TROLLBACK
	q "-1"
}

/// Desc:       删除规则脚本仓库
/// Creator:    yejian
/// CreateDate: 2021-5-28
/// Input:      rowID 仓库对象
/// OutPut:     返回数据 成功 1,失败 -1,
/// Debug: d ##class(EMRservice.BL.BLPrivRuleStore).DelPrivRuleItem("1")
ClassMethod DelPrivRuleItem(rowID As %String) As %String
{
	s $zt="error"
	s ret = "-1"
	q:(rowID="") ret

	//原有数据进行“删除”,将数据ActiveFlag设置为0
	s obj = ##class(EMRmeta.PrivRuleStore).%OpenId(rowID)
	q:(obj="") ret
	//已经存在privRuleDetail中的rulestore数据不可以删除
	if ($d(^DHCEMRM.PrivRuleDetailI("IdxPrivRuleStore",rowID))=10)
	{
		q ret
	}
	if (##class(EMRmeta.PrivRuleStore).%DeleteId(rowID))
	{
		s ret = "1"
	}
	q ret
error
	q "-1"
}

/// Desc:       规则脚本仓库排序
/// Creator:    yejian
/// CreateDate: 2021-5-28
/// Input:      rowID 仓库对象
/// OutPut:     返回数据 成功 1,失败 -1,
/// Debug: w ##Class(EMRservice.BL.BLPrivRuleStore).UpdateSequences("1^2,2^1")
ClassMethod UpdateSequences(argStr As %String) As %String
{
	 S IDCount =$L(argStr,",")
	 S strMrk= 1
	 TSTART 
	 For I=1:1:IDCount
	 {
		S argstrItem= $P(argStr,",",I)
		S argID = $P(argstrItem,"^",1)
		S argSeq = $P(argstrItem,"^",2)
		if ($d(argID)=0)||($d(argSeq)=0)||(argID="")||(argSeq="")
		{
			TROLLBACK
			s strMrk = 0
			quit
		}
		s objEntity="",result=""
		s objEntity=##class(EMRmeta.PrivRuleStore).%OpenId(argID)
		if (objEntity ="")
		{
			TROLLBACK
			s strMrk = 0
			quit
		}	
		s objEntity.Sequence=argSeq
		s result=""
		if '(objEntity.%Save())
		{
			TROLLBACK
			s strMrk = 0
		    quit
		}
	 }
	 if (strMrk = 0)
	 {
		 TROLLBACK
		 quit 0
	 }
	TCOMMIT
	Quit 1
}

/// Desc:       脚本测试
/// Creator:    yejian
/// CreateDate: 2021-5-28
/// Input:      rowID 仓库对象
/// OutPut:     返回数据 成功 1,失败 -1,
/// InPut:          argEnviromentInfo 方法参数(userid^3928!admid^201871!patientid^1!instanceid^""!userloc^34!templateid^822!ssgroupid^576!categoryid^642!docid^67)
///                 argType 脚本类型(ActionPrivilege,LoadPrivilege)
/// OutPut:         view^1!save^1!print^1!check^0!switch^1!switchtemplate^1!chiefcheck^0!attendingcheck^0!revise^0!commit^1
ClassMethod TestRuleItem(argEnviromentInfo As %String, aRuleCode As %String) As %String
{
	s $zt="errhandle2"
	s result = "save^1!print^1!delete^1!check^1!recheck^0!revokcheck=0!reference^1!export^1!view^1!new^1!copypaste^1!revise^-1!viewrevise^1!appoint^0!authlevel^300!commit^1!applyedit^0!unlock^1!transfer^1!quote^0!autoapply^0"
	;s PrivControl = ##class(EMRservice.BL.BLSysOption).GetOptionValueByName("PrivControl")
	;q:(PrivControl '= "Y") result
	q:(aRuleCode = "") ""
	s operators = "save=1"	                       //保存
	s operators = operators_",print=1"		       //打印
	s operators = operators_",delete=1"		       //删除
	s operators = operators_",check=1"	           //医师审核
	s operators = operators_",recheck=0"		   //改签
	s operators = operators_",revokcheck=0"		   //撤销签名
	s operators = operators_",reference=1"         //文档对照
	s operators = operators_",export=1"            //导出文档
	s operators = operators_",view=1"              //查看病历
	s operators = operators_",new=1"               //创建病历
	s operators = operators_",copypaste=1"         //复制粘贴
	s operators = operators_",revise=-1"           //留痕
	s operators = operators_",viewrevise=1"        //显示留痕
	s operators = operators_",appoint=1"           //病历授权
	s operators = operators_",authlevel=300"       //病历授权级别
	s operators = operators_",commit=1"			   //送病案室
	s operators = operators_",applyedit=0"		   //自动审批
	s operators = operators_",unlock=1"		   	   //手工解锁
	s operators = operators_",transfer=1"          //病历转移
    s operators = operators_",quote=0"             //门诊历史病历引用
    s operators = operators_",autoapply=0"		   //门诊自动审批功能
	s result = ##Class(EMRservice.BL.BLPrivRule).ParsePrivRuleLogic(operators,argEnviromentInfo,aRuleCode)
	q "1"
errhandle2
	q "0"
}

}
