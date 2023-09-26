/// 名称:	EMR.DOC.DTO.DocumentData
/// 描述:	门诊病历 实例数据传输对象
/// 编写者：	yejian
/// 编写日期: 	2021-7-29
/// 产品组：电子病历产品组
Class EMR.DOC.DTO.DocumentData Extends %RegisteredObject
{

/// rowID
Property ID As %String;

/// 全局ECRecordID
Property GlobalDataID As %String;

/// 就诊号
Property EpisodeID As User.PAAdm;

/// 住院号
Property PatientID As User.PAPatMas;

/// 模板ID
Property TemplateID As CF.EMR.DOC.Template;

/// 版本
Property TemplateVersion As %Integer;

/// 业务活动记录分类编码
Property DOCCategoryCode As %String(TRUNCATE = 0);

/// 业务活动记录编码(标题代码)
Property DOCCode As %String(TRUNCATE = 0);

/// 标题
Property DOCName As %String(TRUNCATE = 0);

/// 顺序号
Property ListNo As %Integer;

/// 状态（保存 Save、删除 Delete)
Property Status As %String(TRUNCATE = 0);

/// 模板目录ID
Property TemplateCategoryID As CF.EMR.DOC.TemplateCategory;

/// 模板目录名
Property TemplateCategoryName As %String(TRUNCATE = 0);

/// 病历创建者
Property CreateUser As User.SSUser;

/// 病历创建日期
Property CreateDate As %Date;

/// 病历创建时间
Property CreateTime As %Time;

/// 病历对应的行为发生日期，一般来说等于CreateDate
Property HappenDate As %Date;

/// 发生时间
Property HappenTime As %Time;

/// 修改者
Property ModifyUser As User.SSUser;

/// 病历修改日期
Property ModifyDate As %Date;

/// 修改时间
Property ModifyTime As %Time;

/// 病历上次修改日期
Property PModifyDate As %Date;

/// 上次修改时间
Property PModifyTime As %Time;

/// 备注
Property Memo As %String(MAXLEN = 32767, TRUNCATE = 0);

/// 文档源ID（模板ID/科室模板ID/个人模板ID/引用病历ID）
Property SourceID As %String(TRUNCATE = 0);

/// 文档源类型（TEMPLATE(模板)/LOCTEMPLATE(科室模板)/PERSONTEMPLATE(个人模板ID)/REFREANCE(引用病历)
Property SourceType As %String(TRUNCATE = 0);

/// 文档特性 0单文档显示 1多个文档连续显示
Property Serial As %String(TRUNCATE = 0);

/// 实例数据
Property DocumentData As %GlobalBinaryStream;

/// 事件ID
Property EventID As %String(TRUNCATE = 0);

/// 事件类型
Property EventType As %String(TRUNCATE = 0);

/// 文档类型（PDF：有对应患者签名后的PDF文档；WORD：文档型）
Property DocType As %String(TRUNCATE = 0);

/// 是否加密（文档ID 加密 Y，不加密 N）
Property IsEncry As %String(TRUNCATE = 0) [ InitialExpression = "N" ];

/// 实例ID集合
Property DocumentIds As %DynamicArray;

/// 病历目前最新状态Code
Property EMRStatus As %String;

/// 标题选择的医生姓名
Property DoctorName As %String;

/// 标题选择的医生ID
Property DoctorID As %String;

/// 医师级别
Property DoctorLevel As %String;

/// 医师级别编码
Property DoctorLevelCode As %String;

Method EpisodeIDSet(arg) As %Status [ ServerOnly = 1 ]
{
	if ($isobject(arg)) {
	    if (arg.%IsA("User.PAAdm") && (arg.%Id() '= "")){
			s i%EpisodeID = arg.%Id()
			q $$$OK
		}
	}else{
		if (arg = ""){
			s i%EpisodeID = ""
			q $$$OK
		}else{
			if ##class(User.PAAdm).%ExistsId(arg){
				s i%EpisodeID = arg
				q $$$OK
			}
		}
	}
	q 0
}

Method EpisodeIDGet() As User.PAAdm [ ServerOnly = 1 ]
{
    q:(i%EpisodeID="") ""
    q ##class(User.PAAdm).%OpenId(i%EpisodeID,0)
}

Method TemplateIDSet(arg) As %Status [ ServerOnly = 1 ]
{
	if ($isobject(arg)) {
	    if (arg.%IsA("CF.EMR.DOC.Template") && (arg.%Id() '= "")){
			s i%TemplateID = arg.%Id()
			q $$$OK
		}
	}else{
		if (arg = ""){
			s i%TemplateID = ""
			q $$$OK
		}else{
			if ##class(CF.EMR.DOC.Template).%ExistsId(arg){
				s i%TemplateID = arg
				q $$$OK
			}
		}
	}
	q 0
}

Method TemplateIDGet() As CF.EMR.DOC.Template [ ServerOnly = 1 ]
{
    q:(i%TemplateID="") ""
    q ##class(CF.EMR.DOC.Template).%OpenId(i%TemplateID,0)
}

Method CreateUserSet(arg) As %Status [ ServerOnly = 1 ]
{
	if ($isobject(arg)) {
	    if (arg.%IsA("User.SSUser") && (arg.%Id() '= "")){
			s i%CreateUser = arg.%Id()
			q $$$OK
		}
	}else{
		if (arg = ""){
			s i%CreateUser = ""
			q $$$OK
		}else{
			if ##class(User.SSUser).%ExistsId(arg){
				s i%CreateUser = arg
				q $$$OK
			}
		}
	}
	q 0
}

Method CreateUserGet() As User.SSUser [ ServerOnly = 1 ]
{
    q:(i%CreateUser="") ""
    q ##class(User.SSUser).%OpenId(i%CreateUser,0)
}

Method ModifyUserSet(arg) As %Status [ ServerOnly = 1 ]
{
	if ($isobject(arg)) {
	    if (arg.%IsA("User.SSUser") && (arg.%Id() '= "")){
			s i%ModifyUser = arg.%Id()
			q $$$OK
		}
	}else{
		if (arg = ""){
			s i%ModifyUser = ""
			q $$$OK
		}else{
			if ##class(User.SSUser).%ExistsId(arg){
				s i%ModifyUser = arg
				q $$$OK
			}
		}
	}
	q 0
}

Method ModifyUserGet() As User.SSUser [ ServerOnly = 1 ]
{
    q:(i%ModifyUser="") ""
    q ##class(User.SSUser).%OpenId(i%ModifyUser,0)
}

}
