/// 名称:	EMR.IP.COM.ActionViewFactory
/// 描述:	病历浏览--公用程序层 Request数据请求代理工厂
/// 编写者:	yejian
/// 编写日期: 	2020-12-7
/// 产品组：	电子病历产品组
Class EMR.IP.COM.ActionViewFactory Extends EMR.IP.COM.ActionBase
{

/// Creator：      yejian
/// CreatDate：    2020-12-7
/// Description:   编辑器的命令工厂,解析argInMessage参数，进行分支处理
/// Table：        
/// Input：        argInMessage :命令信息 JSON格式  {"action":"GET_PATIENTLIST_BYUSERID","params":{"LocID":"6","UserID":"10209","StartDate":"2019-04-01","EndDate":"2020-04-01"},"product":"GlobalEMR"}
///                argInData    :传入的数据
/// Output         argOutMessage:传出的函数处理信息
///                argOutData   :传出数据
/// Return：       函数返回值的说明
/// Others：       其它说明
/// Debug:         w ##Class(EMR.IP.COM.ActionViewFactory).AcitonProxy(argInMessage,argInData,argOutMessage,argOutData)	
ClassMethod AcitonProxy(ByRef argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream) As %String
{
	//定义错误处理函数
	s $ZT="ERROR"
	s array = argInJson
	s strAction = array.action
	d ..DefaultOutMessage(argOutMessage)
	
	//命令分发
	if (strAction = "GET_VERSIONID")         
	{	
		//获取病历版本标识(三版、四版)
		d ##Class(EMR.DOC.BL.GlobalData).GetVersionID(array,argInData,argOutMessage,argOutData)
	}elseif (strAction = "GET_PTIDBYEPID"){
		//根据就诊号获取PatientID
		d ##Class(EMR.IP.BL.View.Browse).GetPtIDByEpisodeID(array,argInData,argOutMessage,argOutData)
	}elseif (strAction = "GET_DEPTIDBYEPID"){
		//根据就诊号获取当前科室
		d ##Class(EMR.IP.BL.View.Browse).GetDeptIDByEpisodeID(array,argInData,argOutMessage,argOutData)
	}elseif (strAction = "GET_PTRECORDLIST"){
		//获取患者某次就诊的病历列表
		d ##Class(EMR.IP.BL.View.Browse).GetBrowseCategory(array,argInData,argOutMessage,argOutData)
	}elseif (strAction = "GET_RECORD_HTML"){
		//根据病历id获取病历的html数据
		d ##Class(EMR.IP.BL.View.Browse).GetRecordHtml(array,argInData,argOutMessage,argOutData)
	}elseif (strAction = "GET_RECORD_PRIVILEGE"){
		//根据脚本获取病历权限
		d ##Class(EMR.IP.BL.View.Browse).GetRecordPrivilege(array,argInData,argOutMessage,argOutData)
	}elseif (strAction = "GET_DETAILLOG_PART"){
		d ##Class(EMR.IP.BL.View.Browse).GetDetaillogPart(array,argInData,argOutMessage,argOutData)
	}elseif (strAction = "GET_DETAILLOG_ALL"){
		d ##Class(EMR.IP.BL.View.Browse).GetDetaillogAll(array,argInData,argOutMessage,argOutData)
		}
	
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","action操作不存在",2)
	}
	q "1"
	
ERROR			
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000",2)
}

}
