///打开PDF文档
function doPDF(tempParam)
{
    pluginType = "DOC";
    if (!wordDoc(tempParam)) return false;
    loadPDFDocument(tempParam); 
	return true;
}

//设置PDF工作环境
function setPDFWorkEnvironment(tempParam)
{
    //清空文档
    var argJson = {action:"CLEAN_DOCUMENT",args:""};
    cmdDoExecute(argJson);
    //设置工作空间上下文
    argJson = {action:"SET_WORKSPACE_CONTEXT",args:tempParam["chartItemType"]};
    cmdDoExecute(argJson);
    //设置浏览状态
    argJson = {action:"SET_NOTE_STATE",args:"Browse"};
    cmdDoExecute(argJson);
}

//加载文档
function loadPDFDocument(tempParam)
{
    setPDFWorkEnvironment(tempParam);
    setPatientInfo(tempParam);
    if (param.emrDocId != tempParam.emrDocId) loadFalg = true;
    var status = tempParam["status"];
    //加载文档
    var argJson = {action:"LOAD_DOCUMENT",args:{params:{"status":status,"LoadType":tempParam["pdfDocType"]},InstanceID:tempParam["id"],actionType:tempParam["actionType"]}};
    cmdDoExecute(argJson); 
    
	//设置浏览状态
    argJson = {action:"SET_NOTE_STATE",args:"Browse"};
    cmdDoExecute(argJson);
	
	
	//取文档信息
	var documentContext = getDocumentContext(tempParam.id);
	documentContext.privelege = checkActionPrivilege(tempParam);
	//设置当前文档操作权限
	setPrivelege(documentContext);
    //当前文档状态
    setStatus(documentContext);
    //设置工具栏按钮状态
    //parent.setToolBarStatus("disable");
    //parent.setPrintStatus('enable');
}
