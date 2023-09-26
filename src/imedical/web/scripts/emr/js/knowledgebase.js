$(function(){
	//node = {'id':'23','text':'��ʯ֢','attributes':{'type':'KBNode','desc':'','isCommon':'Y','isInUse':'Y','isEmpty':'N'}};
	init();
});

///�����༭��//////////////////////////////////////////////////////////////////////////////////////

//�ҽӲ��\�¼�����
function pluginAdd() {	
	addEvent(plugin(), 'onFailure', function(command){
		alert(command);
	});
    addEvent(plugin(), 'onExecute', function(command){
	   var commandJson = jQuery.parseJSON(command);
	   if (commandJson.action == "eventGetMetaDataTree")
	   {
		   eventGetMetaDataTree(commandJson);
	   }
	   else if (commandJson.action == "eventElementChanged")
	   {
		   eventElementChanged(commandJson);
	   }
	   else if (commandJson.action == "eventAppendElement")
	   {
		   eventAppendElement(commandJson);
	   }
	   else if (commandJson.action == "eventUpdateElement")
	   {
		   eventUpdateElement (commandJson);
	   }
	   else if (commandJson.action == "eventSaveDocument")
	   {
		   eventSaveDocument(commandJson);
	   }
	   else if (commandJson.action == "eventCaretContext")
	   {
		   eventCaretContext(commandJson);
	   }
    });
}
//��Ӽ����¼�
function addEvent(obj, name, func)
{
    if (obj.attachEvent) 
    {
        obj.attachEvent("on"+name, func);
    }  
    else 
    {
        obj.addEventListener(name, func, false); 
    }
}
//���Ҳ��
function plugin() {
	return $("#plugin")[0];
}

///����////////////////////////////////////////////////////////////////////////////////////////

function init()
{
	pluginAdd();
	plugin().initWindow("iEditor");
	//������������
    setConnect();
	//���ù�������
	strJson = {"action":"SET_WORKSPACE_CONTEXT","args": "Composite"};
	cmdDoExecute(strJson);
	var strJson = {action:"SET_DEFAULT_FONTSTYLE",args:defaultFontStyle};
	cmdDoExecute(strJson);		
	setNodeInfo();
	getDataBaseCatalog();
	//��ȡ�󶨲�������Ŀ¼
	getDataEMRCatalog();
	setFontData();
	setFontSizeData();
}

//�������ݿ�����
function setConnect(){
	var netConnect = "";
	$.ajax({
		type: 'Post',
		dataType: 'text',
		url: '../EMRservice.Ajax.common.cls',
		async: false,
		cache: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLSysOption",
			"Method":"GetNetConnectJson"
		},
		success: function (ret) {

			netConnect = eval("("+ret+")");
		},
		error: function (ret) {
			alert('get err');
			if (!onError) {}
			else {
				onError(ret);
			}
		}
	});
	var strJson = {action:"SET_NET_CONNECT",args:netConnect};
	return cmdSyncExecute(strJson);
}

//����֪ʶ������Ϣ
function setNodeInfo()
{
	$("#nodeText").val(node.text);
	if (node.attributes.isCommon.toUpperCase() == "Y")
	{
		$("#chkCommon").attr("checked",true);	
	}
	else
	{
		$("#chkCommon").attr("checked",false);
	}
	if (node.attributes.isInUse.toUpperCase() == "N")
	{
		$("#nodeStatus").text("����");
	}
	else
	{
		$("#nodeStatus").text("ͣ��");
	}
	$("#nodeDesc").val(node.desc);
	if (node.attributes.isEmpty.toUpperCase() == "Y")
	{
		createComposite();
	}
	else
	{
		loadComposite();
	}
	loadStructTree();
}

//��MeteData json ת��easyui tree��׼json
function convertToTreeJson(dataList,treeJson,path)
{
	var tempJson = "";
	for (var i=0;i<dataList.length;i++) 
	{
		 var tempPath = "";
		 if (path != undefined && path != "") tempPath = path + "_" + dataList[i].Code;else tempPath = dataList[i].Code;
		 if (dataList[i].items != undefined) 
		 {
			 
			tempJson = {"id":tempPath,"text":dataList[i].DisplayName,"attributes":{"path":tempPath,"type":dataList[i].Type},"children":[]};
			convertToTreeJson(dataList[i].items,tempJson.children,tempPath);
			treeJson.push(tempJson);
		 }
		 else
		 {
			tempJson = {"id":tempPath,"text":dataList[i].DisplayName,"attributes":{"path":tempPath,"type":dataList[i].Type}};
			treeJson.push(tempJson);
			setMaxElementObj(dataList[i].Code);
		 }
	}
}
//��ʼ��Ԫ�ص�ǰ���ֵ(���ڴ�����һ��Ԫ��)
function setMaxElementObj(code)
{
	var type = code.substring(0,1);
	var value = code.substring(1);
	switch(type)
	{
		case "L": 
			if (+value > +maxElementObj.MIString) maxElementObj.MIString = value;
			break;
		case "N": 
			if (+value > +maxElementObj.MINumber) maxElementObj.MINumber = value;
			break;
	 	case "D": 
			if (+value > +maxElementObj.MIDateTime) maxElementObj.MIDateTime = value; 
			break;  
		case "O":
			if (+value > +maxElementObj.MIMonoChoice) maxElementObj.MIMonoChoice = value; 
			break;  
	 	case "M": 
			if (+value > +maxElementObj.MIMultiChoice) maxElementObj.MIMultiChoice = value; 
			break;  
		case "I":
			if (+value > +maxElementObj.MIDictionary) maxElementObj.MIDictionary = value; 
			break;  			
	}
}
//��ȡԪ�ش���
function getNewCode(code)
{
	code = code + 1;
    code = code.toString();
    var count = 3 - code.length;
    for (i=0;i<count;i++)
    {
       code = "0" + code ; 
    }	
    return code;
}

//�첽ִ��execute
function cmdDoExecute(argJson){
	plugin().execute(JSON.stringify(argJson));
};

//ͬ��ִ��
function cmdSyncExecute(argJson){
	return plugin().syncExecute(JSON.stringify(argJson));
};

//����֪ʶ��
function createComposite()
{
	var strJson = {"action":"CREATE_COMPOSITE","args":{"Code":node.id,"DisplayName":node.text,"KBNodeID":node.id,"Instances":"0..1",
                  "BindKBBaseID":node.KBBaseID,"BindKBName":node.KBBaseName}};                   
	cmdDoExecute(strJson);
}
//����֪ʶ��
function loadComposite()
{
	var	strJson = {"action":"LOAD_DOCUMENT","args":{"params":{"action":"LOAD_COMPOSITE","KBNodeID":node.id}}};
	cmdDoExecute(strJson);
}

//���ü���֪ʶ��Ԫ�ؽṹ
function loadStructTree()
{
	var strJson = {"action":"GET_METADATA_TREE","args":""}
	cmdDoExecute(strJson);
}

//��λԪ��
function focusElement(path)
{
	var strJson = {action:"FOCUS_ELEMENT",args:{"Path":path,"actionType":"Select"}};
	cmdDoExecute(strJson);
}

//���Ԫ��
$(function(){  
    
    //��ӵ�Ԫ
    //�ַ���Ԫ
    $('#MIString').bind('click', function(){  
        maxElementObj.MIString = getNewCode(+maxElementObj.MIString);
        var strJosn = {action:"APPEND_ELEMENT",args:{"ElemType":"MIString","Code":"L"+maxElementObj.MIString,
            "DisplayName":"�½��ַ���Ԫ"+(+maxElementObj.MIString)}};
        cmdDoExecute(strJosn);
    });  
    
    //��ֵ��Ԫ
    $('#MINumber').bind('click', function(){  
        maxElementObj.MINumber = getNewCode(+maxElementObj.MINumber);
        var strJosn = {action:"APPEND_ELEMENT",args:{"ElemType":"MINumber","Code":"N"+maxElementObj.MINumber,
            "DisplayName":"�½����ֵ�Ԫ"+(+maxElementObj.MINumber)}};
        cmdDoExecute(strJosn);
    });
    
     //���ڵ�Ԫ
    $('#MIDateTime').bind('click', function(){  
        maxElementObj.MIDateTime = getNewCode(+maxElementObj.MIDateTime);
        var strJosn = {action:"APPEND_ELEMENT",args:{"ElemType":"MIDateTime","Code":"D"+maxElementObj.MIDateTime,
            "DisplayName":"�½����ڵ�Ԫ"+(+maxElementObj.MIDateTime),"IncludeDate":"True","IncludeTime":"True",
            "DateFormat":"yyyy-MM-dd","TimeFormat":"HH:mm:ss"}};
        cmdDoExecute(strJosn);
    });

     //��ѡ��Ԫ
    $('#MIMonoChoice').bind('click', function(){  
        maxElementObj.MIMonoChoice = getNewCode(+maxElementObj.MIMonoChoice);
        var strJosn = {action:"APPEND_ELEMENT",args:{"ElemType":"MIMonoChoice","Code":"O"+maxElementObj.MIMonoChoice,
            "DisplayName":"�½���ѡ��Ԫ"+(+maxElementObj.MIMonoChoice)}};
        cmdDoExecute(strJosn);
    });
    
     //��ѡ��Ԫ
    $('#MIMultiChoice').bind('click', function(){  
        maxElementObj.MIMultiChoice = getNewCode(+maxElementObj.MIMultiChoice);
        var strJosn = {action:"APPEND_ELEMENT",args:{"ElemType":"MIMultiChoice","Code":"M"+maxElementObj.MIMultiChoice,
            "DisplayName":"�½���ѡ��Ԫ"+(+maxElementObj.MIMultiChoice)}};
        cmdDoExecute(strJosn);
    });
    
     //�ֵ䵥Ԫ
    $('#MIDictionary').bind('click', function(){  
        maxElementObj.MIDictionary = getNewCode(+maxElementObj.MIDictionary);
        var strJosn = {action:"APPEND_ELEMENT",args:{"ElemType":"MIDictionary","Code":"I"+maxElementObj.MIDictionary,
            "DisplayName":"�½��ֵ䵥Ԫ"+(+maxElementObj.MIDictionary)}};
        cmdDoExecute(strJosn);
    });   
          
    $("#propertySave").on("click",function(){
		var type = $("#Code").val().substring(0,1);
		//����xml
		var strJson = {action:"UPDATE_ELEMENT",args:{"Path":currentPath,"Props":getElementPropty(type)}}
		cmdDoExecute(strJson);
	});
	$("#publicSave").click(function(){
		//����xml
		var strJson = {"action":"SAVE_DOCUMENT","args":{"params":{"action":"SAVE_COMPOSITE","KBNodeID":node.id}}};
		cmdDoExecute(strJson);
		
	});
	$("#sureSelect").click(function(){
		
		if (!$("#BindCode") || $("#BindCode").length <= 0) return;
		
		var tab = $('#databind').tabs('getSelected');
		var bindType = tab[0].id;
		var bindString = "";
		if (bindType == "DataBase")
		{
			var rowCategory = $("#dataBaseCategory").datagrid('getSelected');  
			var rowDetial = $("#dataBaseDeital").datagrid('getSelected'); 
			if (rowCategory && rowDetial)
			{
				bindString = rowCategory.Name + "." + rowDetial.Name + "#TYPE:DataSet#CNAME:"
				+ rowCategory.ClassName + "#QNAME:" + rowCategory.QueryName + "#FNAME:" 
				+ rowDetial.FieldName + "#VALUETYPE:" + rowDetial.ValueType;
			}
		}
		$("#BindCode").val(bindString);
		$("#BindType").val(bindType);
		$("#setPropty").accordion('select','��������');

	});
});
/////������//////////////////////////////////////////////////////////////////
//������������Դ
function setFontData()
{
	var json=[{"value":"����","name":"����"},
	          {"value":"����","name":"����"},
	          {"value":"����","name":"����"},
	          {"value":"����","name":"����"}
	         ]
	$('#font').combobox({
		textField:'name',
		valueField:'value',
		data:json,
		onLoadSuccess:function(){
			$('#font').combobox('setValue',defaultFontStyle.fontFamily)
			},
		onSelect:function(){
			//����ı�
			    var strJson = {action:"FONT_FAMILY",args:$('#font').combobox('getValue')};
				cmdDoExecute(strJson);	
			}
		})	
}
//���������С����Դ
function setFontSizeData()
{
	var json=[{"value":"42pt","name":"����"},
  		      {"value":"36pt","name":"С����"},
	          {"value":"31.5pt","name":"��һ��"},
	          {"value":"28pt","name":"һ��"},
	          {"value":"21pt","name":"����"},
	          {"value":"18pt","name":"С����"},
	          {"value":"16pt","name":"����"},
	          {"value":"14pt","name":"�ĺ�"},
	          {"value":"12pt","name":"С�ĺ�"},
	          {"value":"10.5pt","name":"���"},
	          {"value":"9pt","name":"С���"},
	          {"value":"8pt","name":"����"},
	          {"value":"6.875pt","name":"С����"},
	          {"value":"5.25pt","name":"�ߺ�"},
	          {"value":"4.5pt","name":"�˺�"},
	          {"value":"5pt","name":"5"},
	          {"value":"5.5pt","name":"5.5"},
	          {"value":"6.5pt","name":"6.5"},
	          {"value":"7.5pt","name":"7.5"},
	          {"value":"8.5pt","name":"8.5"},
	          {"value":"9.5pt","name":"9.5"},
	          {"value":"10pt","name":"10"},
			  {"value":"10.5pt","name":"10.5"},
	          {"value":"11pt","name":"11"}
	         ]
	$('#fontSize').combobox({
		textField:'name',
		valueField:'value',
		data:json,
		onLoadSuccess:function(){
			$('#fontSize').combobox('setValue',defaultFontStyle.fontSize)
			},
		onSelect:function(){
			var strJson = {action:"FONT_SIZE",args:$('#fontSize').combobox('getValue')};
			document.getElementById('fontSizeText').value = $('#fontSize').combobox('getValue');
			cmdDoExecute(strJson);
			}
		})
		
	document.getElementById('fontSizeText').value = defaultFontStyle.fontSize.replace('pt','');
}


//�����ֺ�
function changeFontSizeText()
{
	if(event.keyCode == 13)
	{
		var strJson = {action:"FONT_SIZE",args:document.getElementById('fontSizeText').value};
		cmdDoExecute(strJson);
		document.getElementById('fontSize').value = ""; 
	} 
	
}

//������
function toolButtonClick(type)
{
	var strJson = "";
	if (type == "bold")
	{
		 strJson = {action:"BOLD",args:{path:""}}; //���ô���
	}
	else if (type == "italic")
	{
		strJson = {action:"ITALIC",args:""};       //����б��
	} 
	else if (type == "underline")
	{
		strJson = {action:"UNDER_LINE",args:""};   //�����»���
	}
	else if (type == "strike")
	{
		strJson = {action:"STRIKE",args:""};
	}
	else if (type == "super")                      //�����ϱ�
	{
		strJson = {action:"SUPER",args:""};
	}
	else if (type == "sub") 
	{
	    strJson = {action:"SUB",args:""};	      //�����±�
	}
	else if (type == "justify") 
	{
		strJson = {action:"ALIGN_JUSTIFY",args:""}; //�������˶���
	}
	else if (type == "alignleft") 
	{
		strJson = {action:"ALIGN_LEFT",args:""};    //���������
	}
	else if (type == "aligncenter") 
	{
		strJson = {action:"ALIGN_CENTER",args:""};  //���þ��ж���
	}
	else if (type == "alignright") 
	{
		strJson = {action:"ALIGN_RIGHT",args:""};  //�����Ҷ���
	}
	else if (type == "indent") 
	{
		strJson = {action:"INDENT",args:""};       //��������
	}
	else if (type == "unindent") 
	{
		strJson = {action:"UNINDENT",args:""};    //���÷�����
	}
	else if (type == "cut") 
	{
		strJson = {action:"CUT",args:""};       //����
	}
	else if (type == "copy") 
	{
		strJson = {action:"COPY",args:""};      //����
	}
	else if (type == "paste") 
	{
		strJson = {action:"PASTE",args:""};      //ճ��
	}
	else if (type == "undo") 
	{
		strJson = {action:"UNDO",args:""};      //����
	}
	else if (type == "redo") 
	{
		strJson = {action:"REDO",args:""};      //����
	}
	else if (type == "spechars")
	{
		
		//��ǰ��ģ̬��
//		var returnValues = window.showModalDialog("emr.ip.tool.spechars.csp","","dialogHeight:420px;dialogWidth:490px;resizable:no;center:yes;status:no");
//		//HISUIģ̬��
		var iframeContent = '<iframe id="specharsIframe" scrolling="auto" frameborder="0" src="emr.ip.tool.spechars.csp" style="width:100%;height:100%;display:block;"></iframe>';
		var callback = function(returnValues,arr){
			strJson={action:"INSERT_STYLE_TEXT_BLOCK",args:returnValues};
			if(strJson!="")	cmdDoExecute(strJson);
	    }
	    createModalDialog("dialogSpechars", "�����ַ�", 490, 450, "specharsIframe", iframeContent,callback,"");
	}
	if(strJson!="")	cmdDoExecute(strJson);
}


///�¼�����///////////////////////////////////////////////////////////////////////////////

//���ģ��Ԫ�ؽṹ
function eventGetMetaDataTree(commandJson)
{
	var json = commandJson.args.items;
	var treeJson = new Array();
	convertToTreeJson(json,treeJson,"");
		$('#elementTree').tree({
			data: treeJson,
			onClick: function(node){
			focusElement(node.id);  
		}
	})
}
//Ԫ�ظı��¼�
function eventElementChanged(commandJson)
{
	if (commandJson.args.Focus == "Get")
	{
		var node = $('#elementTree').tree('find',commandJson.args.Path);
		$('#elementTree').tree('select', node.target);
		currentPath = commandJson.args.Path;
		setProperty();
	}	
}

function eventAppendElement(commandJson)
{
	if (commandJson.args.result == "OK")  
	{
		loadStructTree();
		setProperty();
	}
}

//�༭�������ĸ�֪����
function eventCaretContext(commandJson)
{
	//�жϵ�ǰ����
	if (typeof(commandJson.args.FONT_FAMILY) == "undefined") 
	{
		document.getElementById('font').value = "";
	}
	else
	{
		$('#font').attr("value",commandJson.args.FONT_FAMILY);
	}
	//�жϵ�ǰ�ֺ�
	document.getElementById('fontSize').value = ""; 
	if (typeof(commandJson.args.FONT_SIZE) == "undefined") 
	{
		document.getElementById('fontSizeText').value = "";
	}
	else
	{
		document.getElementById('fontSizeText').value = isExistOption(commandJson.args.FONT_SIZE);
	}  
}

function isExistOption(value) 
{
	var count = $('#fontSize').find('option').length; 
	for(var i=0;i<count;i++)
	{
		 if($('#fontSize').get(0).options[i].value == value) 
		 {
			 document.getElementById('fontSize').value = value;
			 value = $('#fontSize').get(0).options[i].text;
			 break;
		 }
	}
	return value;
}

//�ĵ������¼�����
function eventSaveDocument(commandJson)
{
	var flag = saveNodePropty();  //��������
	if (commandJson.args.result == "OK")
	{
		if (commandJson.args.params.result != "OK")
		{
			alert('����ʧ��');
		}
		else
		{
			if (flag == "1")
			{
				alert('����ɹ�');
			}
			else
			{
				alert('����ʧ��');
			}
		}
	}
	else if (commandJson.args.result == "NONE")
	{
		if (flag == "1")
		{
			alert('����ɹ�');
		}
		else
		{
			alert('����ʧ��');
		}
	}
}

//�޸�Ԫ�ؼ���
function eventUpdateElement(commandJson)
{
	if (commandJson.args.result == "OK")
	{
		loadStructTree();
	}
}

///��������/////////////////////////////////////////////////////////////////////////////

//���õ�Ԫ����
function setProperty()
{
	var strJson = {"action":"GET_ELEMENT_CONTEXT", "args":{"Type":"MIElement"}}
	var elementContext = cmdSyncExecute(strJson);
	var elementContext = eval("("+elementContext+")");
	var type = elementContext.Props.ElemType;
	currentPath = elementContext.Path;
	if (type == "MIString")
	{
		setMIString(elementContext);
	}
	else if (type == "MINumber")
	{	
		setMINumber(elementContext);
	}	
	else if (type == "MIDateTime")
	{
		setMIDateTime(elementContext);
	}	
	else if (type == "MIMonoChoice")
	{
		setMIMonoChoice(elementContext);
	}
	else if (type == "MIMultiChoice")
	{
		setMIMultiChoice(elementContext);
	}	
	else if (type == "MIDictionary")
	{
		 setMIDictionary(elementContext);
	}
}
//��ʼ��Ԫ�ػ�������
function initBasePropty()
{
	var strPropty = 
		'<div>'+initTabIndex()+initVisible()+initAllowNull()+initReadOnly()+'</div>'
		+'<div>'+initCode()+'</div>'
		+'<div>'+initDisplayName()+'</div>'
		+'<div>'+initDescription()+'</div>'
		+'<div>'+initDataBind()+initSynch()+'</div>'
		+'<div>'+initValidateMsg()+'</div>'	
		+'<div>'+initConfidentiality()+'</div>' 
		+'<div>'+initFixedStructs()+'</div>'
	return strPropty;
}
//����Ԫ�ػ�������
function setBasePropty(obj)
{
	setTabIndex(obj.Props.TabIndex);
	setVisible(obj.Props.Visible);
	setAllowNull(obj.Props.AllowNull);
	setReadOnly(obj.Props.ReadOnly);
	setCode(obj.Props.Code);
	setDisplayName(obj.Props.DisplayName);
	setDescription(obj.Props.Description);
	setDataBind(obj.Props.BindCode,obj.Props.BindType);
	setSynch(obj.Props.Synch);
	setValidateMsg(obj.Props.ValidateMsg);
	setConfidentiality(obj.Props.ConfidentialityCode);
	setFixedStructs(obj.Props.FixedStructs);	
}

function getBasePropty()
{
	var obj = {};
	obj.TabIndex = $("#TabIndex").val();
	obj.Visible = $("#Visible")[0].status;
	obj.AllowNull = $("#AllowNull")[0].status;
	obj.ReadOnly = $("#ReadOnly")[0].status;
    obj.Code = $("#Code").val();
	obj.DisplayName = $("#DisplayName").val();	
	obj.Description = $("#Description").val();
	obj.BindCode = $("#BindCode").val();
	obj.BindType = $("#BindType").val();
	obj.Synch = $("#Synch")[0].status;
	obj.ValidateMsg = $("#ValidateMsg").val();
	obj.ConfidentialityCode = $("#ConfidentialityCode").val();
	obj.FixedStructs = $("#FixedStructs")[0].status;
    return obj;
}

//�ַ���Ԫ
function setMIString(obj)
{
	if (!obj || obj == "") return;
	var strPropty = initBasePropty()
	 +'<div>'+initRegExp()+'</div>' 
	 +'<div>'+initMaxLength()+'</div>'
	 +'<div>'+initSave()+'</div>'
	
	$("#property")[0].innerHTML = strPropty;
	
	setBasePropty(obj);
	setRegExp(obj.Props.RegExp);
	setMaxLength(obj.Props.MaxLength);	
}
//�������ֵ�Ԫ
function setMINumber(obj)
{
	if (!obj || obj == "") return;
	var strPropty = initBasePropty()
	 +'<div>'+initHasMinVal()+initMinVal()+initIncludeMax()+'</div>'
	 +'<div>'+initHasMaxVal()+initMaxVal()+initIncludeMin()+'</div>'
	 +'<div>'+initDecimalPlace()+'</div>'
	 +'<div>'+initSave()+'</div>'
	
	$("#property")[0].innerHTML = strPropty;
	
	setBasePropty(obj);
	setHasMinVal(obj.Props.HasMinVal);
	setMinVal(obj.Props.MinVal);
	setIncludeMin(obj.Props.IncludeMin);
	setHasMaxVal(obj.Props.HasMaxVal);
	setMaxVal(obj.Props.MaxVal);
	setIncludeMax(obj.Props.IncludeMax);
	setDecimalPlace(obj.Props.DecimalPlace);	
}
//��ѡ��Ԫ
function setMIMonoChoice(obj)
{
	if (!obj || obj == "") return;
	var strPropty = initBasePropty()
	 +'<div>'+initChoices()+'</div>'
	 +'<div>'+initSave()+'</div>'
	
	$("#property")[0].innerHTML = strPropty;
	
	setBasePropty(obj);
	setChoices(obj.Props.Choices);
}

//��ѡ��Ԫ
function setMIMultiChoice(obj)
{
	if (!obj || obj == "") return;
	var strPropty = initBasePropty() 
	 +'<div>'+initSeparator()+initWrapChoice()+'</div>'
	 +'<div>'+initChoices()+'</div>'
	 +'<div>'+initSave()+'</div>'
	
	$("#property")[0].innerHTML = strPropty;
	
	setBasePropty(obj);
	setSeparator(obj.Props.Separator);
	setWrapChoice(obj.Props.WrapChoice);
	setChoices(obj.Props.Choices);
}

//���ڵ�Ԫ
function setMIDateTime(obj)
{
	if (!obj || obj == "") return;
	var strPropty = initBasePropty() 
	 +'<div>'+initIncludeDate()+initDateFormat()+'</div>'
	 +'<div>'+initIncludeTime()+initTimeFormat()+'</div>'
	 +'<div>'+initSave()+'</div>'
	
	$("#property")[0].innerHTML = strPropty;

	setBasePropty(obj);
	setIncludeDate(obj.Props.IncludeDate);
	setIncludeTime(obj.Props.IncludeTime);
	setDateFormat(obj.Props.DateFormat);
	setTimeFormat(obj.Props.TimeFormat);
}

//�ֵ䵥Ԫ
function setMIDictionary(obj)
{
	if (!obj || obj == "") return;
	var strPropty = initBasePropty()
	 +'<div>'+initDictionaryType()+'</div>'
	 +'<div>'+initCodeSystem()+'</div>'
	 +'<div>'+initCustDicClassName()+'</div>'
	 +'<div>'+initDisplayType()+initSeparator()+'</div>'
	 +'<div>'+initLinkCode()+initLinkMethod()+'</div>'
	 +'<div>'+initLinkDisplayType()+'</div>'
	 +'<div>'+initAllowCodeNull()+'</div>'
	 +'<div>'+initAllowValueNull()+'</div>'
	 +'<div>'+initAssociateItem()+'</div>'
	 +'<div>'+initRegExp()+'</div>'
	 +'<div>'+initMaxLength()+'</div>'
	 +'<div>'+initSave()+'</div>'
	
	$("#property")[0].innerHTML = strPropty;

	setBasePropty(obj);
	setDictionaryType(obj.Props.DictionaryType);
	getCodeSystemData(obj.Props.CodeSystem);
	setCustDicClassName(obj.Props.CustDicClassName);
	setDisplayType(obj.Props.DisplayType);
	setSeparator(obj.Props.Separator);
	setLinkCode(obj.Props.LinkCode);
	setLinkMethod(obj.Props.LinkMethod);
	setLinkDisplayType(obj.Props.LinkDisplayType);
	setAllowCodeNull(obj.Props.AllowCodeNull);
	setAllowValueNull(obj.Props.AllowValueNull);
	setAssociateItem(obj.Props.AssociateItem);
	setRegExp(obj.Props.RegExp);
	setMaxLength(obj.Props.MaxLength);
}
//�ַ�Ԫ��obj
function getMIString()
{
	var obj = getBasePropty();
	obj.ElemType = "MIString";
	obj.RegExp = $("#RegExp").val();
	obj.MaxLength = $("#MaxLength").val();
	return obj;
}
//����Ԫ��obj
function getMINumber()
{
	var obj =  getBasePropty();
	obj.ElemType = "MINumber";
	obj.HasMinVal = $("#HasMinVal")[0].status;
	obj.MinVal = $("#MinVal").val();
	obj.IncludeMin = $("#IncludeMin")[0].status;
	obj.HasMaxVal = $("#HasMaxVal")[0].status;
	obj.MaxVal = $("#MaxVal").val();
	obj.IncludeMax = $("#IncludeMax")[0].status;
	obj.DecimalPlace = $("#DecimalPlace").val();
	return obj;
}
//��ѡ��Ԫ
function getMIMonoChoice()
{
	var obj =  getBasePropty();
	obj.ElemType = "MIMonoChoice";
	var list = $("#Choices").val().split("\n");
	var Choices = new Array();
	for (i=0;i<list.length;i++)
	{
		if (list[i] != "")
		{
			Choices.push({"Code":list[i].split("|")[1],"DisplayName":list[i].split("|")[0]});
		}
	}
	obj.Choices = Choices;
	return obj;
}
//��ѡ��Ԫ
function getMIMultiChoice()
{
	var obj =  getBasePropty();
	obj.ElemType = "MIMultiChoice";
	obj.Separator = $("#Separator").val();
	obj.WrapChoice = $("#WrapChoice")[0].status;
	var list = $("#Choices").val().split("\n");
	var Choices = new Array();
	for (i=0;i<list.length;i++)
	{
		Choices.push({"Code":list[i].split("|")[1],"DisplayName":list[i].split("|")[0]});
	}
	obj.Choices = Choices;
	return obj;
}
//���ڵ�Ԫ
function getMIDateTime()
{
	var obj =  getBasePropty();
	obj.ElemType = "MIDateTime";
	obj.IncludeDate = $("#IncludeDate")[0].status;
	obj.IncludeTime = $("#IncludeTime")[0].status;
	obj.DateFormat = $("#DateFormat").find("option:selected").text();
	obj.TimeFormat = $("#TimeFormat").find("option:selected").text();
	return obj;
}
//�ֵ䵥Ԫ
function getMIDictionary()
{
	var obj =  getBasePropty();
	obj.ElemType = "MIDictionary";
	obj.DictionaryType = $("#DictionaryType").val();
	obj.CodeSystem = $("#CodeSystem").val();
	obj.CodeSystemName = $("#CodeSystem").text();
	obj.CustDicClassName = $("#CustDicClassName").val();
	obj.DisplayType = $("#DisplayType").val();
	obj.Separator = $("#Separator").val();
	obj.LinkCode = $("#LinkCode").val();
	obj.LinkMethod = $("#LinkMethod").val();
	obj.LinkDisplayType = $("#LinkDisplayType").val();
	obj.AllowCodeNull = $("#AllowCodeNull")[0].status;
	obj.AllowValueNull = $("#AssociateItem").val();
	obj.RegExp = $("#RegExp").val();
	obj.MaxLength = $("#MaxLength").val();
	return obj;
}
//ȡԪ������
function getElementPropty(type)
{
	var obj = "";
	if (type == "L")
	{
		obj = getMIString();
	}
	else if (type == "N")
	{
		obj = getMINumber();
	}	
	else if (type == "D")
	{
		obj = getMIDateTime();
	}		
	else if (type == "O")
	{
		obj = getMIMonoChoice();
	}
	else if (type == "M")
	{
		obj = getMIMultiChoice();
	}
	else if (type == "I")
	{
		obj = getMIDictionary();
	}
	return obj;
}


//��Ԫ�ر���
function initCode()
{
	var str = '<span>Ԫ�ر���</span>'
			 +'<span><input id="Code" type="text" disabled="true" style="width:200px;"></input></span>'
	return str;
}
//��Ԫ������
function initDisplayName()
{
	var str ='<span>Ԫ������</span>'
	 	 +'<span><textarea id="DisplayName" rows="2" cols="20" style="width:200px;"></textarea></span>'
	return str;	
}
//��Ԫ�غ�������
function initDescription()
{
	var str ='<span>��������</span>'
	 	 +'<span><textarea id="Description" rows="2" cols="20" style="width:200px;"></textarea></span>'
	return str;	
}
//���ݰ�
function initDataBind()
{
	var str ='<span>���ݰ�</span>'
	 	 +'<span><input id="BindCode" type="text" disabled="true" style="width:140px;"></input></span>'
	 	 +'<span><input id="BindType" type="text" style="display:none;"></input></span>'
	 	 +'<span><input id="clearBind" type="button" value="-"></input></span>'
	return str;
}
//ͬ��
function initSynch()
{
	var str ='<span><input id="Synch" type="checkbox" name="Synch">ͬ��</input></span>'
	return str;
}
//��Ϊ��
function initAllowNull()
{
	var str = '<span><input id="AllowNull" type="checkbox" name="AllowNull">�Ǳ�����</input></span>'
	return str;
}
//У����Ϣ
function initValidateMsg()
{
	var str ='<span>У����Ϣ</span>'
	 	 +'<span><input id="ValidateMsg" type="text" style="width:200px;"></input></span>'
	return str;
}
//������ʽ
function initRegExp()
{
	var str ='<span>������ʽ</span>'
	 	 +'<span><input id="RegExp" type="text" style="width:190px;"></input></span>'
	return str; 	 
}
//˳���
function initTabIndex()
{
	var str = '<span>TabIndex</span>'
		     +'<span><input id="TabIndex" type="text" style="width:30px;"></input></span>'	
    return str;
}
//���ɼ�
function initVisible()
{
	var str = '<span style="display:none;"><input id="Visible" type="checkbox" name="Visible">���ɼ�</input></span>'
	return str;	
}
//ֻ��
function initReadOnly()
{
	var str = '<span><input id="ReadOnly" type="checkbox" name="ReadOnly">ֻ��</input></span>'
	return str;
}
//���ܼ���
function initConfidentiality()
{
	var str ='<span>���ܼ���</span>'
	 	 +'<span><select id="ConfidentialityCode" name="ConfidentialityCode" style="width:200px;"></select></span>'
	return str; 	 
}
//�̶��ṹ
function initFixedStructs()
{
	var str = '<span><input id="FixedStructs" type="checkbox" name="FixedStructs">�̶��ṹ</input></span>'
	return str;
}
//��󳤶�(MIString)
function initMaxLength()
{
	var str ='<span>��󳤶�</span>'
	 	 +'<span><input id="MaxLength" type="text" style="width:200px;"></input></span>'
	return str; 	 
}
//��Сֵ
function initMinVal()
{
	var str ='<span>��Сֵ</span>'
	 	 +'<span><input id="MinVal" type="text" style="width:30px;"></input></span>'
	return str; 
}
//���ֵ
function initMaxVal()
{
	var str ='<span>���ֵ</span>'
	 	 +'<span><input id="MaxVal" type="text" style="width:30px;"></input></span>'
	return str; 
	
}
//������Сֵ
function initHasMinVal()
{
	var str = '<span><input id="HasMinVal" type="checkbox" name="HasMinVal"></input></span>'
	return str;
}
//�������ֵ
function initHasMaxVal()
{
	var str = '<span><input id="HasMaxVal" type="checkbox" name="HasMaxVal"></input></span>'
	return str;	
}
//�Ƿ���С�ڵ���
function initIncludeMin()
{
	var str = '<span><input id="IncludeMin" type="checkbox" name="IncludeMin">�Ƿ�С�ڵ���</input></span>'
	return str;	
}
//�Ƿ��Ǵ��ڵ���
function initIncludeMax()
{
	var str = '<span><input id="IncludeMax" type="checkbox" name="IncludeMax">�Ƿ���ڵ���</input></span>'
	return str;	
}
//С����λ��
function initDecimalPlace()
{
	var str ='<span>С��λ��</span>'
	 	 +'<span><input id="DecimalPlace" type="text" style="width:50px;"></input></span>'
	return str; 
}
//��ѡ���
function initChoices()
{
	var str ='<span>�ڼ��������뱸ѡ��(ÿ��һ�� ֵ|ID)</span>'
	 	 +'<span><textarea id="Choices" rows="6" cols="60" style="width:250px;"></textarea></span>'
	return str;		
}
//�ָ���
function initSeparator()
{
	var str ='<span>�ָ���</span>'
	 	 +'<span><input id="Separator" type="text" style="width:50px;"></input></span>'
	return str; 	
}
//��ѡ��ǿ�ƻ���
function initWrapChoice()
{
	var str = '<span><input id="WrapChoice" type="checkbox" name="WrapChoice">ǿ�ƻ���</input></span>'
	return str;	
}

//��������
function initIncludeDate()
{
	var str = '<span><input id="IncludeDate" type="checkbox" name="IncludeDate">����</input></span>'
	return str;		
}

//����ʱ��
function initIncludeTime()
{
	var str = '<span><input id="IncludeTime" type="checkbox" name="IncludeTime">ʱ��</input></span>'
	return str;		
}
//���ڸ�ʽ
function initDateFormat()
{
	var str ='<span style="padding-left:5px">���ڸ�ʽ</span>'
	 	 +'<span><select id="DateFormat" name="DateFormat" style="width:150px;"></select></span>'
	return str; 
}
//ʱ���ʽ
function initTimeFormat()
{
	var str ='<span style="padding-left:5px">ʱ���ʽ</span>'
	 	 +'<span"><select id="TimeFormat" name="TimeFormat" style="width:150px;"></select></span>'
	return str; 
}
//�ֵ�����
function initDictionaryType()
{
	var str ='<span>�ֵ�����</span>'
	 	 +'<span><select id="DictionaryType" name="DictionaryType" style="width:200px;"></select></span>'
	return str; 		
}
//��׼�ֵ�����
function initCodeSystem()
{
	var str ='<span>��׼�ֵ�</span>'
	 	 +'<span><select id="CodeSystem" name="CodeSystem" style="width:200px;"></select></span>'
	return str; 		
}
//�Զ����ֵ�����
function initCustDicClassName()
{
	var str ='<span>�Զ����ֵ�</span>'
	 	 +'<span><input id="CustDicClassName" type="text" style="width:190px;"></input></span>'
	return str; 		
}
//�ֵ���ʾ����
function initDisplayType()
{
	var str ='<span>��ʾ����</span>'
	 	 +'<span><select id="DisplayType" name="DisplayType" style="width:115px;"></select></span>'
	return str; 		
}
//�����Ľṹ����Ԫ
function initLinkCode()
{
	var str ='<span>����Code</span>'
	 	 +'<span><input id="LinkCode" type="text" style="width:80px;"></input></span>'
	return str; 	
}
//���ӷ�ʽ��Append/Replace/Prefix
function initLinkMethod()
{
	var str ='<span>���ӷ�ʽ</span>'
	 	 +'<span><select id="LinkMethod" name="DisplayType" style="width:70px;"></select></span>'
	return str; 	
}
//����ʹ�÷Ǳ�׼�ֵ����
function initAllowCodeNull()
{
	var str = '<span><input id="AllowCodeNull" type="checkbox" name="IncludeDate">����ʹ�÷Ǳ�׼�ֵ����</input></span>'
	return str;		
}
//����ʹ�÷Ǳ�׼�ֵ�����
function initAllowValueNull()
{
	var str = '<span><input id="IncludeDate" type="checkbox" name="IncludeDate">����ʹ�÷Ǳ�׼�ֵ�����</input></span>'
	return str;		
}
//��ѯ������Ԫ
function initAssociateItem()
{
	var str ='<span>��ѯ������Ԫ</span>'
	 	 +'<span><input id="AssociateItem" type="text" style="width:180px;"></input></span>'
	return str; 		
}
//����Ԫ����ʾ����
function initLinkDisplayType()
{
	var str ='<span>����Ԫ����ʾ����</span>'
	 	 +'<span><select id="LinkDisplayType" name="LinkDisplayType" style="width:115px;"></select></span>'
	return str; 	
}

//����
function initSave()
{
	var str ='<input id="propertySave" type="button" value="����" style="float:right" ></input>'
	return str; 	
}


//��Ԫ�ر���
function setCode(value)
{
	$("#Code").val(value);
}
//��Ԫ������
function setDisplayName(value)
{
	$("#DisplayName").val(value);
}
//��Ԫ�غ�������
function setDescription(value)
{
	$("#Description").val(value);
}
//���ݰ�
function setDataBind(codeValue,typeValue)
{
	$("#BindCode").val(codeValue);
	$("#BindType").val(typeValue);
}
//ͬ��
function setSynch(value)
{
	if (value.toUpperCase() == "TRUE")
	{
		$("#Synch").attr("checked",true);	
	}else
	{
		$("#Synch").attr("checked",false);	
	}
}
//��Ϊ��
function setAllowNull(value)
{
	if (value.toUpperCase() == "TRUE")
	{
		$("#AllowNull").attr("checked",true);	
	}else
	{
		$("#AllowNull").attr("checked",false);	
	}
}
//У����Ϣ
function setValidateMsg(value)
{
	$("#ValidateMsg").val(value)
}
//������ʽ
function setRegExp(value)
{
	$("#RegExp").val(value);	 
}
//˳���
function setTabIndex(value)
{
	$("#TabIndex").val(value)
}
//���ɼ�
function setVisible(value)
{
	if (value.toUpperCase() == "TRUE")
	{
		$("#Visible").attr("checked",true);	
	}else
	{
		$("#Visible").attr("checked",false);	
	}
}
//ֻ��
function setReadOnly(value)
{
	if (value.toUpperCase() == "TRUE")
	{
		$("#ReadOnly").attr("checked",true);	
	}else
	{
		$("#ReadOnly").attr("checked",false);	
	}
}
//���ܼ���
function setConfidentiality(value)
{
	var json = [{value:"N",name:"����"},{value:"R",name:"�ϸ�"},{value:"V",name:"�ǳ��ϸ�"}]
	for (var i=0;i<json.length;i++)  
	{       
    	$('#ConfidentialityCode').append("<option value='" + json[i].value + "'>" + json[i].name + "</option>");
		if (json[i].value == value){$("#ConfidentialityCode").val(value);}
	}	
}
//�̶��ṹ
function setFixedStructs(value)
{
	if (value.toUpperCase() == "TRUE")
	{
		$("#FixedStructs").attr("checked",true);	
	}else
	{
		$("#FixedStructs").attr("checked",false);	
	}
}
//��󳤶� (MIString)
function setMaxLength(value)
{
	$("#MaxLength").val(value);	 
}
//��Сֵ
function setMinVal(value)
{
	$("#MinVal").val(value);
}
//���ֵ
function setMaxVal(value)
{
	$("#MaxVal").val(value);	
}
//������Сֵ
function setHasMinVal(value)
{
	if (value.toUpperCase() == "TRUE")
	{
		$("#HasMinVal").attr("checked",true);	
	}
	else
	{
		$("#HasMinVal").attr("checked",false);	
		$("#MinVal").attr("disabled",true);
		$("#IncludeMin").attr("disabled",true);	
	}
}
//�������ֵ
function setHasMaxVal(value)
{
	if (value.toUpperCase() == "TRUE")
	{
		$("#HasMaxVal").attr("checked",true);	
	}
	else
	{
		$("#HasMaxVal").attr("checked",false);
		$("#MaxVal").attr("disabled",true);
		$("#IncludeMin").attr("disabled",true);	
	}
}
//�Ƿ���С�ڵ���
function setIncludeMin(value)
{
	if (value.toUpperCase() == "TRUE")
	{
		$("#IncludeMin").attr("checked",true);	
	}
	else
	{
		$("#IncludeMin").attr("checked",false);	
	}
}
//�Ƿ��Ǵ��ڵ���
function setIncludeMax(value)
{
	if (value.toUpperCase() == "TRUE")
	{
		$("#IncludeMax").attr("checked",true);	
	}
	else
	{
		$("#IncludeMax").attr("checked",false);	
	}
}
//С����λ��
function setDecimalPlace(value)
{
	$("#DecimalPlace").val(value);
}
//��ѡ��
function setChoices(value)
{
	var text = "";
	for(var i=0;i<value.length;i++)
	{
		text = text + value[i].DisplayName+"|"+value[i].Code +"\n";
	}
	$("#Choices").val(text);
}
//�ָ���
function setSeparator(value)
{
	$("#Separator").val(value);	
}

//��ѡ��ǿ�ƻ���
function setWrapChoice(value)
{
	if (value.toUpperCase() == "TRUE")
	{
		$("#WrapChoice").attr("checked",true);	
	}
	else
	{
		$("#WrapChoice").attr("checked",false);	
	}
}

//��������
function setIncludeDate(value)
{
	if (value.toUpperCase() == "TRUE")
	{
		$("#IncludeDate").attr("checked",true);	
	}
	else
	{
		$("#IncludeDate").attr("checked",false);
		$("#DateFormat").attr("disabled",true);
	}
}
//��������
function setIncludeTime(value)
{
	if (value.toUpperCase() == "TRUE")
	{
		$("#IncludeTime").attr("checked",true);	
	}
	else
	{
		$("#IncludeTime").attr("checked",false);
		$("#TimeFormat").attr("disabled",true);
	}
}
//���ڸ�ʽ
function setDateFormat(value)
{
	var json = [{value:"1",name:"yyyy-MM-dd"},{value:"2",name:"yyyy��MM��dd��"}]
	for (var i=0;i<json.length;i++)  
	{       
    	$('#DateFormat').append("<option value='" + json[i].value + "'>" + json[i].name + "</option>");
		if (json[i].name == value)
		{
			if ($.browser.version == '6.0')
			{
				setTimeout(function() { 
					$("#DateFormat option[text='"+value+"']").attr("selected", true);
				}, 1);
			}
			else
			{
				$("#DateFormat option[text='"+value+"']").attr("selected", true);
			}
		}
	}	
}
//ʱ����ʾ��ʽ
function setTimeFormat(value)
{
	var json = [{value:"1",name:"HH:mm"},{value:"2",name:"HH:mm:ss"}]
	for (var i=0;i<json.length;i++)  
	{       
    	$('#TimeFormat').append("<option value='" + json[i].value + "'>" + json[i].name + "</option>");
		if (json[i].name == value)
		{
			if ($.browser.version == '6.0')
			{
				setTimeout(function() {
					$("#TimeFormat option[text='"+value+"']").attr("selected", true);
				}, 1);
			}
			else
			{
				$("#TimeFormat option[text='"+value+"']").attr("selected", true);
			}
		}
	}	
}

//�ֵ�����
function setDictionaryType(value)
{
	var json = [{value:"STDDIC",name:"��׼�ֵ�"},{value:"CUSTDIC",name:"�Զ����ֵ�"}]
	for (var i=0;i<json.length;i++)  
	{       
    	$('#DictionaryType').append("<option value='" + json[i].value + "'>" + json[i].name + "</option>");
		if (json[i].value == value){$("#DictionaryType").val(value);}
	}	
}
//�ֵ����
function setCodeSystem(value,data)
{
	for (var i=0;i<data.length;i++)  
	{       
    	$('#CodeSystem').append("<option value='" + data[i].Code + "'>" + data[i].Name + "</option>");
		if (data[i].Code == value){$("#CodeSystem").val(value);}
	}
}
//�Զ����ֵ���
function setCustDicClassName(value)
{
	$("#CustDicClassName").val(value);
}
//��ʾ����
function setDisplayType(value)
{
	var json = [{value:"Desc",name:"����"},{value:"Code",name:"����"}]
	for (var i=0;i<json.length;i++)  
	{       
    	$('#DisplayType').append("<option value='" + json[i].value + "'>" + json[i].name + "</option>");
		if (json[i].value == value){$("#DisplayType").val(value);}
	}	
}
//�����Ľṹ����Ԫ
function setLinkCode(value)
{
	$("#LinkCode").val(value);
}
//���ӷ�ʽ
function setLinkMethod(value)
{
	var json = [{value:"Append",name:"׷��"},{value:"Replace",name:"�滻"},{value:"Prefix",name:"ǰ��"}]
	for (var i=0;i<json.length;i++)  
	{       
    	$('#LinkMethod').append("<option value='" + json[i].value + "'>" + json[i].name + "</option>");
		if (json[i].value == value){$("#LinkMethod").val(value);}
	}		
}
//����ʹ�÷Ǳ�׼�ֵ���� 
function setAllowCodeNull(value)
{
	if (value.toUpperCase() == "TRUE")
	{
		$("#AllowCodeNull").attr("checked",true);	
	}else
	{
		$("#AllowCodeNull").attr("checked",false);	
	}
}

//����ʹ�÷Ǳ�׼�ֵ�����
function setAllowValueNull(value)
{
	if (value.toUpperCase() == "TRUE")
	{
		$("#AllowValueNull").attr("checked",true);	
	}else
	{
		$("#AllowValueNull").attr("checked",false);	
	}
}
//��ѯ������Ԫ
function setAssociateItem(value)
{
	$("#AssociateItem").val(value);
}

//����Ԫ����ʾ����
function setLinkDisplayType(value)
{
	var json = [{value:"Desc",name:"����"},{value:"Code",name:"����"}]
	for (var i=0;i<json.length;i++)  
	{       
    	$('#LinkDisplayType').append("<option value='" + json[i].value + "'>" + json[i].name + "</option>");
		if (json[i].value == value){$("#LinkDisplayType").val(value);}
	}	
}

$(function(){
	//��Сֵ�ǲ�����Ч
	$("#HasMinVal").on("change",function(){
		var flag = true;
		if ($("#HasMinVal").attr("checked")) flag = false;	
		$("#MinVal").attr("disabled",flag);
		$("#IncludeMax").attr("disabled",flag);	
	});
	//���ֵ�ǲ�����Ч
	$("#HasMaxVal").on("change",function(){
		var flag = true;
		if ($("#HasMaxVal").attr("checked")) flag = false;	
		$("#MaxVal").attr("disabled",flag);
		$("#IncludeMin").attr("disabled",flag);	
	});
	//�Ƿ��������
	$("#IncludeDate").on("change",function(){
		var flag = true;
		if ($("#IncludeDate").attr("checked")) flag = false;	
		$("#DateFormat").attr("disabled",flag);
	});
	
	//�Ƿ����ʱ��
	$("#IncludeTime").on("change",function(){
		var flag = true;
		if ($("#IncludeTime").attr("checked")) flag = false;	
		$("#TimeFormat").attr("disabled",flag);
	});	
	
	$("#DictionaryType").on("change",function(){
		 var selValue = $(this).children('option:selected').val();
		 if (selValue == "STDDIC")
		 {
			 $("#CustDicClassName").attr("disabled",true);
			 $("#CodeSystem").attr("disabled",false);
		 }
		 else if(selValue == "CUSTDIC")
		 {
			 $("#CodeSystem").attr("disabled",true);
			 $("#CustDicClassName").attr("disabled",false);
		 }
	});

});
///��̨����///////////////////////////////////////////////////////////////

//ȡ��׼�ֵ�����
function getCodeSystemData(value)
{
	jQuery.ajax({
		type: "GET",
		dataType: "text",
		url: "../EMRservice.Ajax.dictionary.cls",
		async: true,
		data: {"Action":"getStdDic"},
		success: function(obj) {
			result = eval(obj);
			setCodeSystem(value,result);
		},
		error: function(d) {alert("error");}
	});
}

//����֪ʶ������
function saveNodePropty()
{
	var result = -1;
	var Description = escape($("#nodeDesc").val());
	var Name = escape($("#nodeText").val());
	var IsCommon = "Y";
	var IsInUse = "Y";
	if (!$("#chkCommon")[0].status) IsCommon = "N";
	if (!$("#nodeStatus").val() == "ͣ��") IsInUse = "N";
	
	var TextData = "";
	//��ȡ֪ʶ���ı����� add by Lina 2016-11-07
	var strJson = {"action":"GET_ELEMENT_TEXT","args":{"Path":"","Type":"Composite","RemoveHintText":"False"}};
	var value = cmdSyncExecute(strJson);
	value = value.replace(/(^\s*)|(\s*$)/g, "");
	var text = value.substring(value.indexOf("Value")+8,value.indexOf("result")-3);
	var returnvalue = eval("("+value+")");
	if (returnvalue.result == "True") TextData = text;
	
	jQuery.ajax({
		type: "post",
		dataType: "text",
		url: "../EMRservice.Ajax.kbTree.cls",
		async: false,
		data: {"ACTION":"UpdateKBNode","ID":node.id,"Description":Description,"Name":Name,"IsCommon":IsCommon,"IsInUse":IsInUse,"TextData":TextData},
		success: function(d) {
            if(d == "1")
            {
	            var nodeText = $("#nodeText").val();
	            returnValues.NodeText = nodeText;
	            returnValues.TextData = TextData;
	            window.returnValue = returnValues;
	            result = 1;
				node.attributes.isEmpty = "N";
	        }
		},
		error: function(d) {alert("error");}
	});	
	return result;
}
//����HIS���ֶ�
function getDataBaseCatalog()
{
	$('#dataBaseCategory').datagrid({  
		height: '200px',
	    url:'../EMRservice.Ajax.databind.cls',  
	    loadMsg:'����װ����......',
	    autoRowHeight: true,
	    fitColumns: true,
	    singleSelect:true,
	    singleSelect:true,
	    idField:'ID',
	    fit:true,
	    columns:[[  
	        {field:'ID',title:'ID',width:100,hidden:true},  
	        {field:'Name',title:'ѡ��ϵͳ��',width:100},  
	        {field:'ClassName',title:'ClassName',width:100,hidden:true},
	        {field:'QueryName',title:'QueryName',width:100,hidden:true}, 
	        {field:'Description',title:'Description',width:100,hidden:true}, 
	        {field:'SingleResult',title:'SingleResult',width:100,hidden:true}
	    ]],
	    onSelect: function(rowIndex,rowData){
			var id = rowData.ID;
			getDataBaseDetial(id);
		},
		queryParams: {
			ACTION: 'DataBaseCatalog'		
		}
	});
}

function getDataBaseDetial(id)
{
	$('#dataBaseDeital').datagrid({  
	    url:'../EMRservice.Ajax.databind.cls',  
	    loadMsg:'����װ����......',
	    autoRowHeight: true,
	    fitColumns: true,
	    singleSelect:true,
	    singleSelect:true,
	    idField:'ID',
	    fit:true,
	    columns:[[  
	        {field:'ID',title:'ID',width:100,hidden:true},  
	        {field:'Name',title:'ѡ���ֶ�',width:100},  
	        {field:'FieldName',title:'FieldName',width:100,hidden:true}, 
	        {field:'FieldType',title:'FieldType',width:100,hidden:true}, 
	        {field:'Description',title:'Description',width:100,hidden:true},
	        {field:'DicID',title:'DicID',width:100,hidden:true}

	    ]],
		queryParams: {
			ACTION: 'dataBaseDeital',
			pId: id		
		} 
	});	
}

///���ذ󶨲�������Ŀ¼
function getDataEMRCatalog()
{
	$('#dataEMRCategory').tree({
		url:'../EMRservice.Ajax.databind.cls?ACTION=DataEMRCategory',
		method:'get',
		animate:true,
		lines:true,
		autoRowHeight: true,
		onSelect: function(node){
			$('#dataEMRDeital').tree('reload');
			$('#valueType').combobox('clear');
			var type = node.attributes.type;
			var text = node.text;
			var id = node.id;
			//ѡ�в���ģ�����ȡģ��xml
			if(type == "Template")
			{
				getXml(id);
			}
		}
		//�۵�ȫ��
		//onLoadSuccess:function(node, data) {$('#dataEMRCategory').tree('collapseAll');},
		//onLoadError: function(){ alert("EMRCatalogonLoadError");}
	});	
}


/// ͣ��֪ʶ��
$("#nodeStatus").on("click",function(){
	
	var IsInUse = ($("#nodeStatus").val() == "ͣ��")?"N":"Y";
	jQuery.ajax({
		type: "GET",
		dataType: "text",
		url: "../EMRservice.Ajax.kbTree.cls",
		async: false,
		data: {"ACTION":"StopOrStartKBNode","KBTreeID":node.id,"IsInUse":IsInUse},
		success: function(d) {
			var btText = (IsInUse == "N")?"����":"ͣ��";	
			$("#nodeStatus").text(btText);	
			returnValues.NodeStatus = IsInUse;
			window.returnValue = returnValues;
		},
		error: function(d) {alert("error");}
	});		
});
